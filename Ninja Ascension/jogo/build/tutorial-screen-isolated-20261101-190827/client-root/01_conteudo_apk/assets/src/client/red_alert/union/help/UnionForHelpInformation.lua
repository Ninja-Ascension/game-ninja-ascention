--------------------------------------------------------------------------------------------------------------
--  说明：军团主界面帮助信息
--------------------------------------------------------------------------------------------------------------
UnionForHelpInformation = class("UnionForHelpInformationClass", Window)

function UnionForHelpInformation:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union for help information state machine.
    local function init_union_for_help_information_terminal()
		--打开界面
        local union_for_help_information_open_terminal = {
            _name = "union_for_help_information_open",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--关闭界面
		local union_for_help_information_close_terminal = {
            _name = "union_for_help_information_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_for_help_information_open_terminal)
		state_machine.add(union_for_help_information_close_terminal)
        state_machine.init()
    end
    
    -- call func init union for help information state machine.
    init_union_for_help_information_terminal()

end

function UnionForHelpInformation:updateDraw()

end

function UnionForHelpInformation:onInit()
	self:updateDraw()
end

function UnionForHelpInformation:onEnterTransitionFinish()

end

function UnionForHelpInformation:init()
	self:onInit()
	return self
end

function UnionForHelpInformation:onExit()
	state_machine.remove("union_for_help_information_open")
	state_machine.remove("union_for_help_information_close")
end