-- Diagnostics only: preserve lifecycle/mission behavior and original errors.
local M={}
function M.armar()
    if package.__nr_loading_diagnostics then return end
    package.__nr_loading_diagnostics=true
    local path=cc.FileUtils:getInstance():getWritablePath()..'tutorial-loading.log'
    local function record(message)
        local file=io.open(path,'a')
        if file then file:write(os.date('%H:%M:%S')..' '..message..'\n');file:close() end
    end
    record('SESSION_BEGIN')
    local original=__G__TRACKBACK__
    if type(original)=='function' then
        __G__TRACKBACK__=function(message)
            record('LUA_ERROR '..tostring(message)..'\n'..debug.traceback())
            return original(message)
        end
    end
    local previous=''
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        local ok,result=pcall(function()
            local parts={}
            for _,class in ipairs({'LoginClass','LoginLoadingClass','FightLoadingCellClass','FightClass'}) do
                local node=fwin and fwin:find(class)
                if node then
                    parts[#parts+1]=class..' total='..tostring(node.totalNum)
                        ..' begin='..tostring(node.isBeginLoad)..' unload='..tostring(node._unload)
                        ..' visible='..tostring(node:isVisible())
                end
            end
            parts[#parts+1]='scene_max_state='..type(_ED and _ED.scene_max_state)
            return table.concat(parts,' | ')
        end)
        if ok and result~=previous then previous=result;record(result) end
    end,2,false)
end
return M
