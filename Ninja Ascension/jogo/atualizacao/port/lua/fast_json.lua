-- Strict JSON reader for server snapshots: no loadstring or document copies.
local M={}
local sub,find,byte,char=string.sub,string.find,string.byte,string.char
local escapes={['"']='"',['\\']='\\',['/']='/',b='\b',f='\f',n='\n',r='\r',t='\t'}
local function utf8(n)
    if n<128 then return char(n) end
    if n<2048 then return char(192+math.floor(n/64),128+n%64) end
    if n<65536 then return char(224+math.floor(n/4096),128+math.floor(n/64)%64,128+n%64) end
    return char(240+math.floor(n/262144),128+math.floor(n/4096)%64,128+math.floor(n/64)%64,128+n%64)
end
function M.decode(text)
    assert(type(text)=='string','JSON string required')
    local pos,length=1,#text
    local function fail() error('Invalid JSON at position '..pos,0) end
    local function whitespace()
        while pos<=length do
            local b=byte(text,pos)
            if b~=32 and b~=9 and b~=10 and b~=13 then break end
            pos=pos+1
        end
    end
    local function stringValue()
        pos=pos+1
        local start=pos
        local parts
        while true do
            local finish=find(text,'["\\%z\1-\31]',pos)
            if not finish then fail() end
            local c=sub(text,finish,finish)
            if c=='"' then
                local tail=sub(text,start,finish-1);pos=finish+1
                if not parts then return tail end
                parts[#parts+1]=tail;return table.concat(parts)
            end
            if c~='\\' then pos=finish;fail() end
            parts=parts or {};parts[#parts+1]=sub(text,start,finish-1)
            pos=finish+1;c=sub(text,pos,pos)
            if c=='u' then
                local hex=sub(text,pos+1,pos+4)
                if #hex~=4 or not hex:match('^%x%x%x%x$') then fail() end
                local n=tonumber(hex,16);pos=pos+5
                if n>=55296 and n<=56319 then
                    if sub(text,pos,pos+1)~='\\u' then fail() end
                    hex=sub(text,pos+2,pos+5)
                    local low=hex:match('^%x%x%x%x$') and tonumber(hex,16)
                    if not low or low<56320 or low>57343 then fail() end
                    n=65536+(n-55296)*1024+low-56320;pos=pos+6
                elseif n>=56320 and n<=57343 then fail() end
                parts[#parts+1]=utf8(n)
            else
                if not escapes[c] then fail() end
                parts[#parts+1]=escapes[c];pos=pos+1
            end
            start=pos
        end
    end
    local value
    value=function(depth)
        if depth>128 then fail() end
        whitespace()
        local c=sub(text,pos,pos)
        if c=='"' then return stringValue() end
        if c=='{' or c=='[' then
            local object=c=='{';local close=object and '}' or ']'
            local result,index={},1;pos=pos+1;whitespace()
            if sub(text,pos,pos)==close then pos=pos+1;return result end
            while true do
                local key=index
                if object then
                    if sub(text,pos,pos)~='"' then fail() end
                    key=stringValue();whitespace()
                    if sub(text,pos,pos)~=':' then fail() end
                    pos=pos+1
                end
                result[key]=value(depth+1);index=index+1;whitespace()
                c=sub(text,pos,pos);pos=pos+1
                if c==close then return result end
                if c~=',' then fail() end
                whitespace()
            end
        end
        for _,constant in ipairs({'true','false','null'}) do
            if sub(text,pos,pos+#constant-1)==constant then
                pos=pos+#constant
                if constant=='null' then return nil end
                return constant=='true'
            end
        end
        local start=pos
        if c=='-' then pos=pos+1 end
        c=sub(text,pos,pos)
        if c=='0' then pos=pos+1
        elseif c:match('^[1-9]$') then repeat pos=pos+1 until not sub(text,pos,pos):match('^%d$')
        else fail() end
        if sub(text,pos,pos)=='.' then
            pos=pos+1;if not sub(text,pos,pos):match('^%d$') then fail() end
            repeat pos=pos+1 until not sub(text,pos,pos):match('^%d$')
        end
        c=sub(text,pos,pos)
        if c=='e' or c=='E' then
            pos=pos+1;c=sub(text,pos,pos)
            if c=='+' or c=='-' then pos=pos+1 end
            if not sub(text,pos,pos):match('^%d$') then fail() end
            repeat pos=pos+1 until not sub(text,pos,pos):match('^%d$')
        end
        return assert(tonumber(sub(text,start,pos-1)),'Invalid JSON number')
    end
    local result=value(0);whitespace()
    if pos<=length then fail() end
    return result
end
return M
