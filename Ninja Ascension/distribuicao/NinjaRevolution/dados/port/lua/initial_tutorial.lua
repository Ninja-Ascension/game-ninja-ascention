-- Authoritative per-profile choice, delivered before LoginLoading opens.
local M={state='legacy'}
function M.apply(value)
    assert(value=='legacy' or value=='choice' or value=='playing' or value=='completed' or value=='skipped','invalid initial tutorial state')
    M.state=value
    _ED.nr_initial_tutorial=value
    local gate=require('tutorial_disabled')
    gate.enabled=value=='choice' or value=='playing'
    if value=='completed' and state_machine and state_machine.find('tuition_controller_exit') then
        state_machine.excute('tuition_controller_exit',0,'')
    end
    local user=tostring(_ED.user_info.user_id)
    local changed=M.profile~=user
    M.profile=user
    if TutorialSkip then
        if changed then
            TutorialSkip.pending=nil
            TutorialSkip.busy=false
        end
        TutorialSkip.profile=user
        TutorialSkip.decidedFor=value~='choice' and user or nil
    end
end
function M.install()
    if not NetworkProtocol or not NetworkProtocol.protocol_parses then return end
    if not NetworkProtocol.find_parser(15989) then
        table.insert(NetworkProtocol.protocol_parses,{code=15989,parser='initial_tutorial_state',parser_fun=function(_,_,_,_,list)
            M.apply(npos(list))
        end})
    end
    protocol_command.tutorial_start=protocol_command.tutorial_start or {
        code=9992,command='tutorial_start',param_list='',command_fun=function(str)
            return str..'\r\ntutorial_start\r\n'.._ED.user_info.user_id
        end
    }
end
return M
