-- ----------------------------------------------------------------------------------------------------
-- 说明：说明界面
-------------------------------------------------------------------------------------------------------
redAlertTimeMinehelpInfo = class("redAlertTimeMinehelpInfoClass", Window)

local red_alert_time_mine_help_info_open_terminal = {
    _name = "red_alert_time_mine_help_info_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMinehelpInfoClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMinehelpInfo:new():init(), fwin._dview)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_help_info_close_terminal = {
    _name = "red_alert_time_mine_help_info_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMinehelpInfoClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMinehelpInfoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_help_info_open_terminal)
state_machine.add(red_alert_time_mine_help_info_close_terminal)
state_machine.init()
    
function redAlertTimeMinehelpInfo:ctor()
    self.super:ctor()
    self.roots = {}

end

function redAlertTimeMinehelpInfo:init()
    self:onInit()
    return self
end

function redAlertTimeMinehelpInfo:onInit()
    local csbredAlertTimeMinehelpInfo = csb.createNode(config_csb.world_map.help_info)
    local root = csbredAlertTimeMinehelpInfo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMinehelpInfo)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_infor_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_help_info_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_help_info_close",
        terminal_state = 0,
    },
    nil,3)
	
end

function redAlertTimeMinehelpInfo:onExit()
	
end