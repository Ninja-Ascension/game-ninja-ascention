--------------------------------------------------------------------------------------------------------------
--  说明：每日签到补签
--------------------------------------------------------------------------------------------------------------
RedAlertTimeDaySignRetroactive = class("RedAlertTimeDaySignRetroactiveClass", Window)

--打开界面
local red_alert_time_day_sign_retroactive_open_terminal = {
    _name = "red_alert_time_day_sign_retroactive_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeDaySignRetroactiveClass") == nil then
            fwin:open(RedAlertTimeDaySignRetroactive:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local red_alert_time_day_sign_retroactive_close_terminal = {
    _name = "red_alert_time_day_sign_retroactive_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeDaySignRetroactiveClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_day_sign_retroactive_open_terminal)
state_machine.add(red_alert_time_day_sign_retroactive_close_terminal)
state_machine.init()

function RedAlertTimeDaySignRetroactive:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_red_alert_time_day_sign_retroactive_terminal()
        local red_alert_time_day_sign_retroactive_reset_terminal = {
            _name = "red_alert_time_day_sign_retroactive_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("red_alert_time_day_sign_retroactive_close", 0, nil)
                        state_machine.excute("red_alert_time_day_sign_update_draw", 0, nil)
                    end
                end
                local signTimeInfo = zstring.split(_ED.activity_info["83"].activity_add_state, ",")
                signTimeInfo = math.min(tonumber(signTimeInfo[2]), 5)
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["83"].activity_id .. "\r\n83\r\n1\r\n"..(signTimeInfo-1).."\r\n2"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_day_sign_retroactive_sign_terminal = {
            _name = "red_alert_time_day_sign_retroactive_sign",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("red_alert_time_day_sign_retroactive_close", 0, nil)
                        state_machine.excute("red_alert_time_day_sign_update_draw", 0, nil)
                        checkRewardObtainDraw()
                    end
                end
                local signTimeInfo = zstring.split(_ED.activity_info["83"].activity_add_state, ",")
                signTimeInfo = math.min(tonumber(signTimeInfo[2]), 5)
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["83"].activity_id .. "\r\n83\r\n1\r\n"..(signTimeInfo-1).."\r\n1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_day_sign_retroactive_reset_terminal)
        state_machine.add(red_alert_time_day_sign_retroactive_sign_terminal)
        state_machine.init()
    end
    init_red_alert_time_day_sign_retroactive_terminal()
end

function RedAlertTimeDaySignRetroactive:updateDraw()
    local root = self.roots[1]
    local Text_141 = ccui.Helper:seekWidgetByName(root,"Text_141")
    local Text_money = ccui.Helper:seekWidgetByName(root,"Text_money")
    local datas = zstring.split(_ED.activity_info["83"].activity_add_state, "|")
    local signTimeInfo = zstring.split(datas[1], ",")
    local signDay = tonumber(signTimeInfo[2]) - tonumber(signTimeInfo[1]) - 1
    signDay = math.min(signDay, 4)
    Text_141:setString(string.format(activity_str_tip[90], signDay))

    local costInfo = zstring.split(datas[signDay + 1], ",")
    Text_money:setString(costInfo[2])
end

function RedAlertTimeDaySignRetroactive:onInit()
    local csbItem = csb.createNode(config_csb.utils.prompt_3)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_3_6"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_retroactive_reset",
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_4_8"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_retroactive_sign",
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_prompt_close"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_retroactive_close",
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_retroactive_close",
        terminal_state = 0, 
    }, nil, 3)

    self:updateDraw()
    
end

function RedAlertTimeDaySignRetroactive:onEnterTransitionFinish()

end

function RedAlertTimeDaySignRetroactive:init()
    self:onInit()
    return self
end

function RedAlertTimeDaySignRetroactive:onExit()
    state_machine.remove("red_alert_time_day_sign_retroactive_reset")
    state_machine.remove("red_alert_time_day_sign_retroactive_sign")
end