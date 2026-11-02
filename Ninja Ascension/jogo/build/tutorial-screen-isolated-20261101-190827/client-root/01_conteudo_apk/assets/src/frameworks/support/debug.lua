debug = debug or {}



function debug.pr(t, name, indent)   
    local tableList = {}   
    function table_r (t, name, indent, full)   
        local id = not full and name or type(name)~="number" and tostring(name) or '['..name..']'   
        local tag = indent .. id .. ' = '   
        local out = {}  -- result   
        if type(t) == "table" then   
            if tableList[t] ~= nil then   
                table.insert(out, tag .. '{} -- ' .. tableList[t] .. ' (self reference)')   
            else  
                tableList[t]= full and (full .. '.' .. id) or id  
                if next(t) then -- Table not empty   
                    table.insert(out, tag .. '{')   
                    for key,value in pairs(t) do   
                        table.insert(out,table_r(value,key,indent .. '|  ',tableList[t]))   
                    end   
                    table.insert(out,indent .. '}')   
                else table.insert(out,tag .. '{}') end   
            end   
        else  
            local val = type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t)   
            table.insert(out, tag .. val)   
        end   
        return table.concat(out, '\n')   
    end   
    return table_r(t,name or 'Value',indent or '')   
end   
function debug.print_r(t, name)   
    print(debug.pr(t,name))   
end   

function debug.error(info, ...)
    -- debug.log(info, ...)
    local str = string.format(...)
    if str ~= nil and str ~= debug.error_info then
        debug.error_info = str
    end
end

function debug.log(info, ...)
    if debug._isOpen == true then
        local infoType = type(info)
        if infoType == "string" or info == true then
            local str = ""
            for i = 1, select('#', ...) do  -- get the count of the params
                local arg = select(i, ...); -- select the param
                str = table.concat({str, string.len(str) > 0 and " " or ""})
                str = table.concat({str, tostring(arg)})
            end
            cclog(str)
            if debug.view ~= nil then
                debug.view:display(str)
            end
        else
            cclog(...)
        end
    end
end

return debug