PropInformation = class("PropInformationClass", Window)

function PropInformation:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize PropInformation page state machine.
    local function init_prop_information_terminal()
		local prop_information_exit_terminal = {
            _name = "prop_information_exit",
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
	
		state_machine.add(prop_information_exit_terminal)
        state_machine.init()
    end
    
    -- call func init PropInformation state machine.
    init_prop_page_terminal()
end

function  PropInformation:onUpdateDraw()
	
end

function PropInformation:onEnterTransitionFinish()

	self:onUpdateDraw()
end

function PropInformation:onExit()
	state_machine.remove("prop_information_exit")
end
