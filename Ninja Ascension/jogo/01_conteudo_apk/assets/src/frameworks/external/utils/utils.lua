zstring = {}
function zstring.split(str, delimeter, func)
	local start, s_end = 0,0
	local j = 1
	local tb = {}
	local s_str
	while true
	do
		start, s_end = str:find(delimeter, s_end+1)
		if (start ~= nil) then 
			s_str = str:sub(j, start - 1)
		else
			s_str = str:sub(j)
		end
        if func then
            table.insert(tb, func(s_str))
        else
            table.insert(tb, s_str)
        end
		if (start == nil) then
			break
		end
		j = s_end + 1
	end
	return tb
end

function zstring.splits(str, separate, delimeter, func)
    local arrs = {}
    local arr = zstring.split(str, separate)
    for i, v in pairs(arr) do
        arrs[i] = zstring.split(v, delimeter, func)
    end
    return arrs
end

function zstring.concat(arr, delimeter)
    local str = ""
    for i, v in pairs(arr) do
        if #str > 0 then
            str = str .. delimeter
        end
        str = str .. v
    end
    return str
end

function zstring.concats(arrs, separate, delimeter)
    local str = ""
    for i, v in pairs(arrs) do
        if #str > 0 then
            str = str .. separate
        end
        str = str .. zstring.concat(v, delimeter)
    end
    return str
end

local formatCharSequence = {
	{"&", "&amp;"},
	{" ", "&nbsp;"},
	{"\r", "&#13;"},
	{"\n", "&#10;"},
	{"\r\n", "&#13;&#10;"},
}

function zstring.exchangeTo(str)
	for i, v in pairs(formatCharSequence) do
		str = string.gsub(str, formatCharSequence[i][1], formatCharSequence[i][2])
	end
	return str
end

function zstring.replace(str, old, now)
	str = string.gsub(str, old, now)
	return str
end

function zstring.exchangeFrom(str)
	for i, v in pairs(formatCharSequence) do
		str = string.gsub(str, formatCharSequence[i][2], formatCharSequence[i][1])
	end
	return str
end

function zstring.utfstrlen(str)
	if str == nil or str == "" then
		return 0
	end
	local len = #str;
	local left = len;
	local cnt = 0;
	local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
	while left ~= 0 do
		local tmp=string.byte(str,-left);
		local i=#arr;
		local b = false
		while arr[i] do
			if tmp>=arr[i] then 
				left=left-i;
				break;
			end
			i=i-1;
		end
		if i == 1 then
			cnt = cnt - 0.5
		end
		cnt=cnt+1;
	end
	return cnt;
end

-- 对应服务器的字符串长度
function zstring.utfstrlenServer(str)
	local len = #str;
	local left = len;
	local cnt = 0;
	local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
	while left ~= 0 do
		local tmp=string.byte(str,-left);
		local i=#arr;
		local b = false
		while arr[i] do
			if tmp>=arr[i] then 
				left=left-i;
				break;
			end
			i=i-1;
		end
		cnt=cnt+1;
	end
	return cnt;
end

function zstring.zsplit(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end

function zstring.tonumber(str)
	if str == nil or str == "" then
		return 0
	else
		return tonumber(""..str)
	end
end

function zstring.tostring(ele)
	if ele == nil or #(""..ele) == 0 then
		return ""
	else
		return tonumber(ele)
	end
end

function zstring.npos(list)
	list.pos = list.pos + 1
	pos = list.pos
	return list[list.pos - 1]
end

zstring.log = function(...)
    -- cclog(string.format(...))
end

zstring.checkNikenameChar = function(str)
	for i=1, #str do
		local pos = string.find(str, " ");
		if (not pos) then
			return false
		else
			return true
		end
		-- local v = string.byte(str:sub(i, i), 1)
		-- if (v>=string.byte("0", 1) and v<=string.byte("9", 1))
			-- or (v>=string.byte("a", 1) and v<=string.byte("z", 1))
			-- or (v>=string.byte("A", 1) and v<=string.byte("Z", 1))
		-- then
		-- else
			-- return true
		-- end
	end
	return false
end

-- Fury (30-sep-2026): LINEALES. Las de antes recortaban el resto de la cadena en cada corte
-- (`str = string.sub(str, pos + N)`), cuadratico: el sobre del login_init de Player22 (421 KB,
-- 98.687 tokens) tardaba 47 s en partirse en LDPlayer con la pantalla congelada. Mismo resultado
-- (vacios incluidos, el ultimo trozo siempre, mismo salto de 2 y de 1): ahora se busca desde una
-- posicion. Prueba: tests/cliente_partir_sobre/test_partir.lua.
function lua_string_split_line(str, split_char)
    local sub_str_tab = {};
    local n, init = 0, 1
    while (true) do
        local pos = string.find(str, split_char, init);
        if (not pos) then
            n = n + 1
            sub_str_tab[n] = string.sub(str, init);
            break;
        end
        n = n + 1
        sub_str_tab[n] = string.sub(str, init, pos - 1);
        init = pos + 2
    end
    return sub_str_tab;
end

function lua_string_splits(strs, split_char)
    local sub_str_tab = {};
    local n = 0
    for i, str in ipairs(strs) do
        local init = 1
        while (true) do
            local pos = string.find(str, split_char, init);
            if (not pos) then
                n = n + 1
                sub_str_tab[n] = string.sub(str, init);
                break;
            end
            n = n + 1
            sub_str_tab[n] = string.sub(str, init, pos - 1);
            init = pos + 1
        end
    end
    return sub_str_tab;
end

function split(str, delim, maxNb)   
    -- Eliminate bad cases...   
    if string.find(str, delim) == nil then  
        return { str }  
    end  
    if maxNb == nil or maxNb < 1 then  
        maxNb = 0    -- No limit   
    end
    local result = {}  
    local pat = "(.-)" .. delim .. "()"   
    local nb = 0  
    local lastPos

    if string.gfind ~= nil then
        for part, pos in string.gfind(str, pat) do  
            nb = nb + 1  
            result[nb] = part   
            lastPos = pos   
            if nb == maxNb then break end  
        end
    else
        for part, pos in string.gmatch(str, pat) do  
            nb = nb + 1  
            result[nb] = part   
            lastPos = pos   
            if nb == maxNb then break end  
        end
    end  
    -- Handle the last field   
    if nb ~= maxNb then  
        result[nb + 1] = string.sub(str, lastPos)   
    end  
    return result   
end

function formatDate(seconds, dateformat)
    seconds = tonumber(seconds)
    dateformat = dateformat or "%Y-%m-%d %H:%M:%S"
    
    return os.date(dateformat, seconds)
end

-- change table to enum type (from 0 to n)
function CreateEnumTable(tbl, index)
    local enumTable = {}
    local enumIndex = index or -1
    for i, v in ipairs(tbl) do
        enumTable[v] = enumIndex + i
    end
    return enumTable
end

-- 分割utf8字符串
function SubUTF8String(s, n)    
  local dropping = string.byte(s, n+1)    
  if not dropping then return s end    
  if dropping >= 128 and dropping < 192 then    
    return SubUTF8String(s, n-1)    
  end    
  return string.sub(s, 1, n)    
end

--
-- csv解析  
-- 
  
-- 去掉字符串左空白  
local function trim_left(s)  
    return string.gsub(s, "^%s+", "");
end  
  
-- 去掉字符串右空白  
local function trim_right(s)  
    return string.gsub(s, "%s+$", "");  
end  
  
-- 解析一行  
local function parseline(line)  
    local ret = {};  
  
    local s = line .. ",";  -- 添加逗号,保证能得到最后一个字段  
  
    while (s ~= "") do  
        --print(0,s);  
        local v = "";  
        local tl = true;  
        local tr = true;  
  
        while(s ~= "" and string.find(s, "^,") == nil) do  
            --print(1,s);  
            if(string.find(s, "^\"")) then  
                local _,_,vx,vz = string.find(s, "^\"(.-)\"(.*)");  
                --print(2,vx,vz);  
                if(vx == nil) then  
                    return nil;  -- 不完整的一行  
                end  
  
                -- 引号开头的不去空白  
                if(v == "") then  
                    tl = false;  
                end  
  
                v = v..vx;  
                s = vz;  
  
                --print(3,v,s);  
  
                while(string.find(s, "^\"")) do  
                    local _,_,vx,vz = string.find(s, "^\"(.-)\"(.*)");  
                    --print(4,vx,vz);  
                    if(vx == nil) then  
                        return nil;  
                    end  
  
                    v = v.."\""..vx;  
                    s = vz;  
                    --print(5,v,s);  
                end  
  
                tr = true;  
            else  
                local _,_,vx,vz = string.find(s, "^(.-)([,\"].*)");  
                --print(6,vx,vz);  
                if(vx~=nil) then  
                    v = v..vx;  
                    s = vz;  
                else  
                    v = v..s;  
                    s = "";  
                end  
                --print(7,v,s);  
  
                tr = false;  
            end  
        end  
  
        if(tl) then v = trim_left(v); end  
        if(tr) then v = trim_right(v); end  
  
        ret[table.getn(ret)+1] = v;  
        --print(8,"ret["..table.getn(ret).."]=".."\""..v.."\"");  
  
        if(string.find(s, "^,")) then  
            s = string.gsub(s,"^,", "");  
        end  
  
    end  
  
    return ret;  
end  

--解析csv文件的每一行  
local function getRowContent(file)  
    local content;  
  
    local check = false  
    local count = 0  
    while true do  
        local t = file:read()  
        if not t then  if count==0 then check = true end  break end  
  
        if not content then  
            content = t  
        else  
            content = content..t  
        end  
  
        local i = 1  
        while true do  
            local index = string.find(t, "\"", i)  
            if not index then break end  
            i = index + 1  
            count = count + 1  
        end  
  
        if count % 2 == 0 then check = true break end  
    end  
  
    if not check then  assert(1~=1) end  
    return content  
end  
  
  
  
--解析csv文件  
function LoadCsv(fileName)  
    local ret = {};  
  
    local file = io.open(fileName, "r")  
    assert(file)  
    local content = {}  
    while true do  
        local line = getRowContent(file)  
        if not line then break end  
        table.insert(content, line)  
    end  
  
    for k,v in pairs(content) do  
        ret[table.getn(ret)+1] = parseline(v);  
    end  
  
  
    file:close()  
  
    return ret  
end  

function Csv2Lua(fileName, filePath, desFilePath )
    local t = LoadCsv(filePath);
    if t then
        t = luautil.serialize(fileName,t);
    end
    if t then
        luautil.writefile(t, desFilePath) 
    end
end

--test  
--local t= LoadCsv("csvtesttxt.csv")  
--for k,v in pairs(t) do  
--  local tt = v  
--  local s = ""  
--  for i,j in pairs(tt) do  
--      s = string.format("%s,%s",s,j)  
--  end  
--  print ("",s)  
--end

-- cvs end


-- local tonumber_ = tonumber

-- function tonumber(v, base)
--     return tonumber_(v, base) or 0
-- end

function toint(v)
    return math.round(tonumber(v))
end

function tobool(v)
    return (v ~= nil and v ~= false)
end

function totable(v)
    if type(v) ~= "table" then v = {} end
    return v
end

-- function clone(object)
--     local lookup_table = {}
--     local function _copy(object)
--         if type(object) ~= "table" then
--             return object
--         elseif lookup_table[object] then
--             return lookup_table[object]
--         end
--         local new_table = {}
--         lookup_table[object] = new_table
--         for key, value in pairs(object) do
--             new_table[_copy(key)] = _copy(value)
--         end
--         return setmetatable(new_table, getmetatable(object))
--     end
--     return _copy(object)
-- end

-- function class(classname, super)
--     local superType = type(super)
--     local cls

--     if superType ~= "function" and superType ~= "table" then
--         superType = nil
--         super = nil
--     end

--     if superType == "function" or (super and super.__ctype == 1) then
--         -- inherited from native C++ Object
--         cls = {}

--         if superType == "table" then
--             -- copy fields from super
--             print ("superTyper is table");
--             for k,v in pairs(super) do cls[k] = v end
--             cls.__create = super.__create
--             cls.super    = super
--         else
--             cls.__create = super
--             cls.ctor = function() end
--         end

--         cls.__cname = classname
--         cls.__ctype = 1

--         function cls.new(...)
--             local instance = cls.__create(...)
--             -- copy fields from class to native object
--             for k,v in pairs(cls) do instance[k] = v end
--             instance.class = cls
--             instance:ctor(...)
--             return instance
--         end

--     else
--         -- inherited from Lua Object
--         if super then
--             cls = {}
--             setmetatable(cls, {__index = super})
--             cls.super = super
--         else
--             cls = {ctor = function() end}
--         end

--         cls.__cname = classname
--         cls.__ctype = 2 -- lua
--         cls.__index = cls

--         function cls.new(...)
--             local instance = setmetatable({}, cls)
--             instance.class = cls
--             instance:ctor(...)
--             return instance
--         end
--     end

--     return cls
-- end

function import(moduleName, currentModuleName)
    local currentModuleNameParts
    local moduleFullName = moduleName
    local offset = 1

    while true do
        if string.byte(moduleName, offset) ~= 46 then -- .
            moduleFullName = string.sub(moduleName, offset)
            if currentModuleNameParts and #currentModuleNameParts > 0 then
                moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
            end
            break
        end
        offset = offset + 1

        if not currentModuleNameParts then
            if not currentModuleName then
                local n,v = debug.getlocal(3, 1)
                currentModuleName = v
            end

            currentModuleNameParts = string.split(currentModuleName, ".")
        end
        table.remove(currentModuleNameParts, #currentModuleNameParts)
    end

    return require(moduleFullName)
end

function handler(target, method)
    return function(...) return method(target, ...) end
end

function math.round(num)
    return math.floor(num + 0.5)
end

function io.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

function io.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        print("file is ok ok ok  ok ok ")
        if file:write(content) == nil then print("file is bad bad bad bad ") return false end
        io.close(file)
        return true
    else
        return false
    end
end

function io.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

function io.filesize(path)
    local size = false
    local file = io.open(path, "r")
    if file then
        local current = file:seek()
        size = file:seek("end")
        file:seek("set", current)
        io.close(file)
    end
    return size
end

function table.nums(t)
    local count = 0
    if t then
        for k, v in pairs(t) do
            count = count + 1
        end
    end
    return count
end

function table.keys(t)
    local keys = {}
    if t == nil then
        return keys;
    end
    for k, v in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end

function table.values(t)
    local values = {}
    if t == nil then
        return values;
    end
    for k, v in pairs(t) do
        values[#values + 1] = v
    end
    return values
end

function table.containKey( t, key )
    for k, v in pairs(t) do
        if key == k then
            return true;
        end
    end
    return false;
end

function table.containValue( t, value )
    for k, v in pairs(t) do
        if value == v then
            return true;
        end
    end
    return false;
end

function table.removeForKey( t, key )
    for k, v in pairs(t) do
        if key == k then
            if type(k) == "number" then
                table.remove(t, k, 1)
            else
                t[k] = nil
            end
            return v
        end
    end
    return nil
end

function table.removeForValue( t, value )
    for k, v in pairs(t) do
        if value == v then
            if type(k) == "number" then
                table.remove(t, k, 1)
            else
                t[k] = nil
            end
            return v
        end
    end
    return nil
end

function table.getKeyByValue( t, value )
    for k, v in pairs(t) do
        if value == v then
            return k;
        end
    end
end

function table.add(dest, src)
    for k, v in pairs(src) do
        table.insert(dest, v)
    end
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function table.merges(dest, src, r)
    for k, v in pairs(src) do
        if nil == dest[k] then
            dest[k] = v

            if type(v) == "table" then
                if dest.add ~= nil then
                    dest.add(dest, k, v)
                end
                if r then
                    table.insert(r, {dest, k, v})
                end
            end
        else
            local t = dest[k]
            if type(t) == "table" then
                if type(v) == "table" then
                    table.merges(t, v, r)
                else
                    print("table.merges error : src is not table (code 1).");
                end
            else
                dest[k] = v
            end
        end
    end
    return r
end

function table.clear(src)
    for k, v in pairs(src) do
        src[k] = nil
    end
end

function arrayContain( array, value)
    for i=1,#array do
        if array[i] == value then
            return true;
        end
    end
    return false;
end

function string.htmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, k, v)
    end
    return input
end
string._htmlspecialchars_set = {}
string._htmlspecialchars_set["&"] = "&amp;"
string._htmlspecialchars_set["\""] = "&quot;"
string._htmlspecialchars_set["'"] = "&#039;"
string._htmlspecialchars_set["<"] = "&lt;"
string._htmlspecialchars_set[">"] = "&gt;"

function string.nl2br(input)
    return string.gsub(input, "\n", "<br />")
end

function string.text2html(input)
    input = string.gsub(input, "\t", "    ")
    input = string.htmlspecialchars(input)
    input = string.gsub(input, " ", "&nbsp;")
    input = string.nl2br(input)
    return input
end

function string.split(str, delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

function string.ltrim(str)
    return string.gsub(str, "^[ \t\n\r]+", "")
end

function string.rtrim(str)
    return string.gsub(str, "[ \t\n\r]+$", "")
end

function string.trim(str)
    str = string.gsub(str, "^[ \t\n\r]+", "")
    return string.gsub(str, "[ \t\n\r]+$", "")
end

function string.ucfirst(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

--[[--
@ignore
]]
local function urlencodeChar(char)
    return "%" .. string.format("%02X", string.byte(c))
end

function string.urlencode(str)
    -- convert line endings
    str = string.gsub(tostring(str), "\n", "\r\n")
    -- escape all characters but alphanumeric, '.' and '-'
    str = string.gsub(str, "([^%w%.%- ])", urlencodeChar)
    -- convert spaces to "+" symbols
    return string.gsub(str, " ", "+")
end

function string.utf8len(str)
    local len  = #str
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(str, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

function string.formatNumberThousands(num)
    local formatted = tostring(tonumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function print_lua_table (lua_table, indent)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end


local function newCounter()
    local i = 0
    return function()     -- anonymous function
       i = i + 1
        return i
    end
end


g_id_generator = newCounter()

function getNextID()
  local nextID 
    nextID = g_id_generator()
    return nextID
end

luautil = luautil or {};
function luautil.serialize(tName, t, sort_parent, sort_child)  
    local mark={}  
    local assign={}  
      
    local function ser_table(tbl,parent)  
        mark[tbl]=parent  
        local tmp={}  
        local sortList = {};  
        for k,v in pairs(tbl) do  
            sortList[#sortList + 1] = {key=k, value=v};  
        end  
  
        if tostring(parent) == "ret" then  
            if sort_parent then table.sort(sortList, sort_parent); end  
        else  
            if sort_child then table.sort(sortList, sort_child); end  
        end  
  
        for i = 1, #sortList do  
            local info = sortList[i];  
            local k = info.key;  
            local v = info.value;  
            local key= type(k)=="number" and "["..k.."]" or k;  
            if type(v)=="table" then  
                local dotkey= parent..(type(k)=="number" and key or "."..key)  
                if mark[v] then  
                    table.insert(assign, "\n".. dotkey.."="..mark[v])  
                else  
                    table.insert(tmp, "\n"..key.."="..ser_table(v,dotkey))  
                end  
            else  
                if type(v) == "string" then  
                    table.insert(tmp, "\n".. key..'="'..v..'"');  
                else  
                    table.insert(tmp, "\n".. key.."="..tostring(v) .. "\n");  
                end  
            end  
        end  
  
        return "{"..table.concat(tmp,",").."\n}";  
    end  
   
    return "do local ".. tName .. "= \n\n"..ser_table(t, tName)..table.concat(assign," ").."\n\n return ".. tName .. " end"  
end  
  
function luautil.split(str, delimiter)  
    if (delimiter=='') then return false end  
    local pos,arr = 0, {}  
    -- for each divider found  
    for st,sp in function() return string.find(str, delimiter, pos, true) end do  
        table.insert(arr, string.sub(str, pos, st - 1))  
        pos = sp + 1  
    end  
    table.insert(arr, string.sub(str, pos))  
    return arr  
end  
  
function luautil.writefile(str, file)  
    os.remove(file);  
    local file=io.open(file,"ab");  
  
    local len = string.len(str);  
    local tbl = luautil.split(str, "\n");  
    for i = 1, #tbl do  
        file:write(tbl[i].."\n");  
    end  
    file:close();  
end 

function luautil.readfile( strData )
    local f = loadstring(strData)  
    if f then  
       return f()
    end  
end

function Json2Lua (fileName,filePath, desFilePath)  
    local jsonString = io.readfile(filePath)--myfile:read("*a")  
    t = CJson.decode(jsonString)  
    if t then
        t = luautil.serialize(fileName,t);
    end
    if t then
        luautil.writefile(t, desFilePath) 
    end 
end 

function performWithDelay(callback, delay)
    local handle
    handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function()
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
        handle = nil
        callback();
    end , delay , false)
end

-- 参数:待分割的字符串,分割字符
-- 返回:子串表.(含有空串)
function lua_string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end

--获取文件名
function getFileName(str)
    local idx = str:match(".+()%.%w+$")
    if(idx) then
        return str:sub(1, idx-1)
    else
        return str
    end
end

--获取扩展名
function getExtension(str)
    return str:match(".+%.(%w+)$")
end

--去除扩展名
function stripExtension(filename)
    local idx = filename:match(".+()%.%w+$")
    if(idx) then
        return filename:sub(1, idx-1)
    else
        return filename
    end
end

--获取路径
function stripfilename(filename)
    return string.match(filename, "(.+)/[^/]*%.%w+$") --*nix system
    --return string.match(filename, “(.+)\\[^\\]*%.%w+$”) — windows
end

--获取文件名
function strippath(filename)
    return string.match(filename, ".+/([^/]*%.%w+)$") -- *nix system
    --return string.match(filename, “.+\\([^\\]*%.%w+)$”) — *nix system
end

--解码
function decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

--加码
function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

-- 生产配置文件
function genCfg(  )
    local assets = require("res.Asset")
    local sceneKey = "Scene"
    local commonKey = "common"
    local className = {"textures", "atlas", "sounds", "animations"}
    
    local config = {};

    for i=1,#assets do
        local k = assets[i].k;
        local v = assets[i].v;

        local pathnames = lua_string_split(v, "/");
        local fileName = pathnames[#pathnames];
        local name = stripExtension(fileName);
        local pathType = fileName:match(".+%.(%w+)$");
        local sceneType;
        local commonType;
        local cur;
        for i=1,#pathnames do
            cur = pathnames[i];
             -- 1. 检查该路径是否是场景
            if string.find(cur, sceneKey) then
                sceneType = cur;
                if not config[sceneType] then
                    config[sceneType] = {};
                end
            end

            if string.find(cur, commonKey) then
                commonType = cur;
                if not config[commonType] then
                    config[commonType] = {};
                end
            end

            -- 2. 查找资源类型
            -- 2.1 是场景资源
            if sceneType then
                for n=1,#className do
                    local t = className[n];
                    if cur == t then
                        if not config[sceneType][t] then
                            config[sceneType][t] = {};
                        end

                        if (t == "atlas" and pathType == "plist") then
                            config[sceneType][t][name] = v;
                        end

                        if t == "atlas" and pathType == "ExportJson" then
                            if not config[sceneType]["json"] then
                               config[sceneType]["json"] = {}
                            end
                            config[sceneType]["json"][name] = v;
                        end

                        if (t == "textures") then
                            config[sceneType][t][name] = v;
                        end

                        if (t == "animations" and pathType == "xml") then
                            config[sceneType][t][name] = v;
                        end

                        if (t == "sounds")  then
                            config[sceneType][t][name] = v;
                        end
                    end
                end

            -- 2.2 是公用资源
            elseif commonType then
                for n=1,#className do
                    local t = className[n];
                    if cur == t then
                        if not config[commonType][t] then
                            config[commonType][t] = {};
                        end

                        if (t == "atlas" and pathType == "plist") then
                            config[commonType][t][name] = v;
                        end

                        if t == "atlas" and pathType == "ExportJson" then
                            if not config[commonType]["json"] then
                               config[commonType]["json"] = {}
                            end
                            config[commonType]["json"][name] = v;
                        end

                        if (t == "textures") then
                            config[commonType][t][name] = v;
                        end

                        if (t == "animations" and pathType == "xml") then
                            config[commonType][t][name] = v;
                        end

                        if (t == "sounds")  then
                            config[commonType][t][name] = v;
                        end
                    end
                end

            -- 2.3 贴图资源
            elseif string.find(cur, "textures") then
                if not config["textures"] then
                    config["textures"] = {}
                end
                config["textures"][name] = v;
            -- 2.4 图集资源
            elseif string.find(cur, "atlas") and pathType == "plist" then
                if not config["atlas"] then
                    config["atlas"] = {}
                end
                config["atlas"][name] = v;
            -- 2.5 图集json配置文件
            elseif string.find(cur, "atlas") and pathType == "ExportJson" then
                if not config["json"] then
                    config["json"] = {}
                end
                config["json"][name] = v;
            -- 2.6 声音资源
            elseif string.find(cur, "sounds") then
                if not config["sounds"] then
                    config["sounds"] = {}
                end
                config["sounds"][name] = v;
            -- 2.7 字体资源
            elseif string.find(cur, "fonts") and (pathType == "fnt" or pathType == "ttf" ) then
                if not config["fonts"] then
                    config["fonts"] = {}
                end
                config["fonts"][name] = v;
            -- 2.8 动画资源
            elseif string.find(cur, "animations") and pathType == "xml" then
                if not config["animations"] then
                    config["animations"] = {}
                end
                config["animations"][name] = v;
            end
        end
    end

    return config;
end

