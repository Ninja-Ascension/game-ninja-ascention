-- Account/formation responses can arrive before login.lua loads formula.lua.
-- Load the original implementation before dispatch, never substitute a stub.
local M={}
function M.install()
    if not NetworkProtocol or type(NetworkProtocol.parser_func)~='function'
        or M.installed then return end
    M.installed=true
    local parse=NetworkProtocol.parser_func
    NetworkProtocol.parser_func=function(...)
        if type(getUserFight)~='function' then
            app.load('client.loader.formula')
            assert(type(getUserFight)=='function','Original profile formulas did not load')
            print('PROFILE_FORMULAS_READY before protocol dispatch')
        end
        local args={...}
        local reply=args[1] and args[1].resouce
        local login=type(reply)=='string' and (reply:match('^%d+ login_init ') or reply:match('^%d+ login_init_again '))
        local previous=NetworkProtocol.__nr_restoring_login
        local analytics=rawget(_G,'jttd')
        local event=analytics and analytics.NewAPPeventSlogger
        local skipped=0
        if login then
            NetworkProtocol.__nr_restoring_login=true
            print('NR_LOGIN_PARSE_BEGIN bytes='..#reply)
            if type(event)=='function' then
                analytics.NewAPPeventSlogger=function() skipped=skipped+1 end
            end
        end
        local result={xpcall(function() return parse(unpack(args)) end,debug.traceback)}
        if login then
            NetworkProtocol.__nr_restoring_login=previous
            if type(event)=='function' then analytics.NewAPPeventSlogger=event end
            print('NR_LOGIN_PARSE_END ok='..tostring(result[1])..' historical_events_skipped='..skipped)
        end
        if not result[1] then
            print('NR_PROTOCOL_PARSE_ERROR '..tostring(result[2]))
            local boot=rawget(_G,'__nr_android_boot')
            if boot then boot.report(result[2]) end
            error(result[2],0)
        end
        if login then
            local resume=require('tutorial_resume')
            resume.install();resume.restore()
        end
        return unpack(result,2)
    end
end
return M
