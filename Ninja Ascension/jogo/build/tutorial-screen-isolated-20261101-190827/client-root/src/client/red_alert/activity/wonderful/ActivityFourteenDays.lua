-----------------------------
-- 十四天乐(活动类型27)
-----------------------------
ActivityFourteenDays = class("ActivityFourteenDaysClass", Window)

local activity_fourteen_days_window_open_terminal = {
    _name = "activity_fourteen_days_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if config_csb.activity.days ~= nil and config_csb.activity.days.activity_sevenday ~= nil then
            if nil == fwin:find("ActivityFourteenDaysClass") then
                if _ED.activity_info["27"] ~= nil then
                    fwin:open(ActivityFourteenDays:new():init(params), fwin._windows)
                    return true
                end
            end
        end       
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_fourteen_days_window_close_terminal = {
    _name = "activity_fourteen_days_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ActivityFourteenDaysClass"))
        state_machine.excute("main_window_login_popup_banner_open", 0, 0) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_fourteen_days_window_open_terminal)
state_machine.add(activity_fourteen_days_window_close_terminal)
state_machine.init()

function ActivityFourteenDays:ctor()
    self.super:ctor()
    self.roots = {}

    self._now_day_index = nil

    local function init_activity_fourteen_days_terminal()
		local activity_fourteen_days_get_reward_terminal = {
            _name = "activity_fourteen_days_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local day_index = params._datas.day_index
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1027})
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["27"].activity_id .. "\r\n27\r\n" .. (day_index-1) .."\r\n0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(activity_fourteen_days_get_reward_terminal)	
        state_machine.init()
    end
    
    init_activity_fourteen_days_terminal()
end

function ActivityFourteenDays:onUpdateDraw()
    local root = self.roots[1]
    local now_day_index = tonumber(zstring.split(_ED.activity_info["27"].activity_add_state, ",")[1])
    now_day_index = now_day_index - 7
    now_day_index = math.max(1,now_day_index)
    now_day_index = math.min(7,now_day_index)
    local state = self._seven_activity_data[now_day_index][1].achieve_state
    local ArmatureNode_button_2 = ccui.Helper:seekWidgetByName(root, "Panel_2_day"):getChildByName("ArmatureNode_button_2")
    local ArmatureNode_button_4 = ccui.Helper:seekWidgetByName(root, "Panel_4_day"):getChildByName("ArmatureNode_button_4")
    local ArmatureNode_button_5 = ccui.Helper:seekWidgetByName(root, "Panel_5_day"):getChildByName("ArmatureNode_button_5")
    local ArmatureNode_button_7 = ccui.Helper:seekWidgetByName(root, "Panel_7_day"):getChildByName("ArmatureNode_button_7")
    local Button_get_2 = ccui.Helper:seekWidgetByName(root,"Button_get_2")
    local Button_get_4 = ccui.Helper:seekWidgetByName(root,"Button_get_4")
    local Button_get_5 = ccui.Helper:seekWidgetByName(root,"Button_get_5")
    local Button_get_7 = ccui.Helper:seekWidgetByName(root,"Button_get_7")
    local Text_get_2 = ccui.Helper:seekWidgetByName(root,"Text_get_2")
    local Text_get_4 = ccui.Helper:seekWidgetByName(root,"Text_get_4")
    local Text_get_5 = ccui.Helper:seekWidgetByName(root,"Text_get_5")
    local Text_get_7 = ccui.Helper:seekWidgetByName(root,"Text_get_7")
    local Panel_geted_2 = ccui.Helper:seekWidgetByName(root,"Panel_geted_2")
    local Panel_geted_4 = ccui.Helper:seekWidgetByName(root,"Panel_geted_4")
    local Panel_geted_5 = ccui.Helper:seekWidgetByName(root,"Panel_geted_5")
    local Panel_geted_7 = ccui.Helper:seekWidgetByName(root,"Panel_geted_7")
    ArmatureNode_button_2:setVisible(false)
    ArmatureNode_button_4:setVisible(false)
    ArmatureNode_button_5:setVisible(false)
    ArmatureNode_button_7:setVisible(false)
    Button_get_2:setVisible(false)
    Button_get_4:setVisible(false)
    Button_get_5:setVisible(false)
    Button_get_7:setVisible(false)
    Button_get_2:setTouchEnabled(false)
    Button_get_4:setTouchEnabled(false)
    Button_get_5:setTouchEnabled(false)
    Button_get_7:setTouchEnabled(false)
    Panel_geted_2:setVisible(false)
    Panel_geted_4:setVisible(false)
    Panel_geted_5:setVisible(false)
    Panel_geted_7:setVisible(false)
    Text_get_2:setString("")
    Text_get_4:setString("")
    Text_get_5:setString("")
    Text_get_7:setString("")
    if now_day_index == 1 then
        Text_get_2:setString(red_alert_all_str[171])
        
        ArmatureNode_button_2:setVisible(true)
        Button_get_2:setVisible(true)
    elseif now_day_index == 2 then
        Text_get_4:setString(red_alert_all_str[172])
        ArmatureNode_button_4:setVisible(true)
        Button_get_4:setVisible(true)
        
        if tonumber(state) == 2 then
            Panel_geted_2:setVisible(true)
        else
            Text_get_2:setString(red_alert_all_str[170])
            Button_get_2:setVisible(true)
            Button_get_2:setTouchEnabled(true)
        end
    elseif now_day_index == 3 then
        Text_get_4:setString(red_alert_all_str[171])
        Button_get_4:setVisible(true)
        ArmatureNode_button_4:setVisible(true)
        Button_get_5:setVisible(true)
        Text_get_5:setString(red_alert_all_str[172])
        ArmatureNode_button_5:setVisible(true)
        if tonumber(self._seven_activity_data[2][1].achieve_state) == 2 then
            Panel_geted_2:setVisible(true)
        else
            Button_get_2:setVisible(true)
            Text_get_2:setString(red_alert_all_str[170])
            Button_get_2:setTouchEnabled(true)
        end
    elseif now_day_index == 4 then
        Button_get_5:setVisible(true)
        Text_get_5:setString(red_alert_all_str[171])
        ArmatureNode_button_5:setVisible(true)
        if tonumber(state) == 2 then
            Panel_geted_4:setVisible(true)
        else
            Button_get_4:setVisible(true)
            Text_get_4:setString(red_alert_all_str[170])
            Button_get_4:setTouchEnabled(true)
        end
        if tonumber(self._seven_activity_data[2][1].achieve_state) == 2 then
            Panel_geted_2:setVisible(true)
        else
            Button_get_2:setVisible(true)
            Button_get_2:setTouchEnabled(true)
            Text_get_2:setString(red_alert_all_str[170])
        end
    elseif now_day_index == 5 then
        Button_get_7:setVisible(true)
        Text_get_7:setString(red_alert_all_str[172])
        ArmatureNode_button_7:setVisible(true)
        if tonumber(state) == 2 then
            Panel_geted_5:setVisible(true)
        else
            Button_get_5:setVisible(true)
            Button_get_5:setTouchEnabled(true)
            Text_get_5:setString(red_alert_all_str[170])
        end
        if tonumber(self._seven_activity_data[2][1].achieve_state) == 2 then
            Panel_geted_2:setVisible(true)
        else
            Button_get_2:setVisible(true)
            Button_get_2:setTouchEnabled(true)
            Text_get_2:setString(red_alert_all_str[170])
        end
        if tonumber(self._seven_activity_data[4][1].achieve_state) == 2 then
            Panel_geted_4:setVisible(true)
        else
            Button_get_4:setVisible(true)
            Button_get_4:setTouchEnabled(true)
            Text_get_4:setString(red_alert_all_str[170])
        end
    elseif now_day_index == 6 then
        Button_get_7:setVisible(true)
        Text_get_7:setString(red_alert_all_str[171])
        ArmatureNode_button_7:setVisible(true)
        if tonumber(self._seven_activity_data[2][1].achieve_state) == 2 then
            Panel_geted_2:setVisible(true)
        else
            Button_get_2:setVisible(true)
            Button_get_2:setTouchEnabled(true)
            Text_get_2:setString(red_alert_all_str[170])
        end
        if tonumber(self._seven_activity_data[4][1].achieve_state) == 2 then
            Panel_geted_4:setVisible(true)
        else
            Button_get_4:setVisible(true)
            Button_get_4:setTouchEnabled(true)
            Text_get_4:setString(red_alert_all_str[170])
        end
        if tonumber(self._seven_activity_data[5][1].achieve_state) == 2 then
            Panel_geted_5:setVisible(true)
        else
            Button_get_5:setVisible(true)
            Button_get_5:setTouchEnabled(true)
            Text_get_5:setString(red_alert_all_str[170])
        end
    elseif now_day_index == 7 then
        if tonumber(state) == 2 then
            Panel_geted_7:setVisible(true)
        else
            Button_get_7:setVisible(true)
            Button_get_7:setTouchEnabled(true)
            Text_get_7:setString(red_alert_all_str[170])
        end
        if tonumber(self._seven_activity_data[2][1].achieve_state) == 2 then
            Panel_geted_2:setVisible(true)
        else
            Button_get_2:setVisible(true)
            Button_get_2:setTouchEnabled(true)
            Text_get_2:setString(red_alert_all_str[170])
        end
        if tonumber(self._seven_activity_data[4][1].achieve_state) == 2 then
            Panel_geted_4:setVisible(true)
        else
            Button_get_4:setVisible(true)
            Button_get_4:setTouchEnabled(true)
            Text_get_4:setString(red_alert_all_str[170])
        end
        if tonumber(self._seven_activity_data[5][1].achieve_state) == 2 then
            Panel_geted_5:setVisible(true)
        else
            Button_get_5:setVisible(true)
            Button_get_5:setTouchEnabled(true)
            Text_get_5:setString(red_alert_all_str[170])
        end
    end
end

function ActivityFourteenDays:onEnterTransitionFinish()

end

function ActivityFourteenDays:onInit( )
    local csbItem = csb.createNode(config_csb.activity.days.activity_sevenday_8)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    for i = 1, 7 do
        local Button_get = ccui.Helper:seekWidgetByName(root, "Button_get_"..i)
        if Button_get ~= nil then
            fwin:addTouchEventListener(Button_get, nil, 
            {
                terminal_name = "activity_fourteen_days_get_reward", 
                terminal_state = 0, 
                day_index = i,
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }, nil, 0)    
        end
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "activity_fourteen_days_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()
end

function ActivityFourteenDays:init(params)
    if nil ~= params then
        self._zorder = params._zorder
    end
    self._seven_activity_data = _ED.activity_info["27"].activity_data
	self:onInit()
    return self
end

function ActivityFourteenDays:onExit()
    state_machine.remove("activity_fourteen_days_get_reward")
end
