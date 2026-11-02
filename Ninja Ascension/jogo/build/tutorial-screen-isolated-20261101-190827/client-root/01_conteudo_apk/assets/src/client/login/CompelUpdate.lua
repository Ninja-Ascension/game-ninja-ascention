CompelUpdate = class("CompelUpdateClass", Window)
    
function CompelUpdate:ctor()
    self.super:ctor()
    
    -- Initialize Union page state machine.
    local function init_CompelUpdate_terminal()
	
		
		local compel_update_manager_terminal = {
            _name = "compel_update_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

            end,
            _terminal = nil,
            _terminals = nil,
			isUpdate = true,
			_updateVersion = false
        }
	
		
		local compel_update_click_confirm_terminal = {
            _name = "compel_update_click_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, CC_OPEN_URL, CompelUpdateClass._serverInfo.server_update)
				state_machine.find("compel_update_manager").isUpdate = false
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		local compel_update_click_determine_terminal = {
            _name = "compel_update_click_determine",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.find("compel_update_manager").isUpdate = false
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(compel_update_manager_terminal)
		state_machine.add(compel_update_click_confirm_terminal)
		state_machine.add(compel_update_click_determine_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_CompelUpdate_terminal()
end

function CompelUpdate:onEnterTransitionFinish()
	
	local csbUnion = csb.createNode("union/Union.csb")
	self:addChild(csbUnion)
		
	local root = csbUnion:getChildByName("root")
	-- local confirm_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "", terminal_state = 0}, nil, 0)
	-- local determine_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "", terminal_state = 0}, nil, 0)
	local Text = ccui.Helper:seekWidgetByName(root, "Text")
	Text:setString(_string_piece_info[140])
	
end


function CompelUpdate:onExit()
	state_machine.remove("compel_update_manager")
	state_machine.remove("compel_update_click_confirm")
	state_machine.remove("compel_update_click_determine")
end