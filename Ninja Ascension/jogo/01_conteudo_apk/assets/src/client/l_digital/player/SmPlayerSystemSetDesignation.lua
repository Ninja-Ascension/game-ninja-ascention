-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统头衔
-------------------------------------------------------------------------------------------------------
SmPlayerSystemSetDesignation = class("SmPlayerSystemSetDesignationClass", Window)
local sm_player_system_set_designation_page_open_terminal = {
    _name = "sm_player_system_set_designation_page_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerSystemSetDesignationClass")
        if _window == nil then
            fwin:open(SmPlayerSystemSetDesignation:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_system_set_designation_page_open_terminal)
state_machine.init()
    
function SmPlayerSystemSetDesignation:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
    local function init_sm_player_system_set_designation_page_terminal()

        --关闭
        local sm_player_system_set_designation_page_close_terminal = {
            _name = "sm_player_system_set_designation_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_player_system_set_designation_page_close_terminal)
        state_machine.init()
    end
    
    init_sm_player_system_set_designation_page_terminal()
end

function SmPlayerSystemSetDesignation:onUpdataDraw()
	local root = self.roots[1]
end


function SmPlayerSystemSetDesignation:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_change_head.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_player_system_set_designation_page_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	self:onUpdataDraw()
end

function SmPlayerSystemSetDesignation:onExit()
    state_machine.remove("sm_player_system_set_designation_page_close")
end
