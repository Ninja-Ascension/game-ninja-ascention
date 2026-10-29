--------------------------------------------------------------------------------------------------------------
--  说明：节日祝福集福
--------------------------------------------------------------------------------------------------------------
RedAlertTimeFestivalEachChildGift = class("RedAlertTimeFestivalEachChildGiftClass", Window)

--打开界面
local red_alert_time_festival_each_child_gift_open_terminal = {
    _name = "red_alert_time_festival_each_child_gift_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeFestivalEachChildGift:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_festival_each_child_gift_open_terminal)
state_machine.init()

function RedAlertTimeFestivalEachChildGift:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._activity_type = 0

    local function init_red_alert_time_festival_each_child_gift_terminal()
        local red_alert_time_festival_each_child_gift_show_terminal = {
            _name = "red_alert_time_festival_each_child_gift_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_festival_each_child_gift_hide_terminal = {
            _name = "red_alert_time_festival_each_child_gift_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_festival_each_child_gift_update_terminal = {
            _name = "red_alert_time_festival_each_child_gift_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 集福记录
        local red_alert_time_festival_each_child_gift_get_record_terminal = {
            _name = "red_alert_time_festival_each_child_gift_get_record",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity_info = _ED.activity_info[""..instance._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            -- 集福记录
                            state_machine.excute("red_alert_time_festival_each_record_window_open",0,response.node._activity_type)
                        end
                    end
                end
                -- 请求集福记录
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 集福
        local red_alert_time_festival_each_child_gift_get_reward_terminal = {
            _name = "red_alert_time_festival_each_child_gift_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity_info = _ED.activity_info[""..instance._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end
                -- 请求集福
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_festival_each_child_gift_show_terminal)
        state_machine.add(red_alert_time_festival_each_child_gift_hide_terminal)
        state_machine.add(red_alert_time_festival_each_child_gift_update_terminal)
        state_machine.add(red_alert_time_festival_each_child_gift_get_record_terminal)
        state_machine.add(red_alert_time_festival_each_child_gift_get_reward_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_festival_each_child_gift_terminal()
end

function RedAlertTimeFestivalEachChildGift:onUpdateDraw()
    local root = self.roots[1]

    local Text_festival_each_child_time_n = ccui.Helper:seekWidgetByName(root, "Text_festival_each_child_time_n")
    local Text_festival_each_child_get = ccui.Helper:seekWidgetByName(root, "Text_festival_each_child_get")
    local Text_festival_each_child_get_n = ccui.Helper:seekWidgetByName(root, "Text_festival_each_child_get_n")
    local Text_festival_each_child_gold_n = ccui.Helper:seekWidgetByName(root, "Text_festival_each_child_gold_n")
    local Button_festival_each_child = ccui.Helper:seekWidgetByName(root, "Button_festival_each_child")
    local Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")

    local activity_info = _ED.activity_info[""..self._activity_type]

    -- 集福状态
    local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "|")
    -- activity_add_state = "活动起始时间,活动关闭时间,兑换时间,当前时间,可集福次数,第一档已祝福次数,第二档已祝福次数,第三档祝福次数
    --                      |鲜花id
    --                      |第一次集福消耗金币,获得最小金币,获得最大金币|。。。。
    --                      |配件祝福需要鲜花数量,掉落库组,次数限制....(3个)

    local activity_add_state = zstring.split(activity_add_state_arr[1], ",")

    local total_count = #activity_add_state_arr - 5
    local leave_count = tonumber(activity_add_state[5])
    local current_count = total_count - leave_count
    Text_festival_each_child_time_n:setString(""..leave_count.."/"..total_count)

    if current_count < total_count then
        local info = zstring.split(activity_add_state_arr[current_count + 3], ",")
        Text_festival_each_child_get:setVisible(true)
        Text_festival_each_child_get_n:setString(""..info[2].."~"..info[3]..reward_prop_list[2])

        Image_10:setVisible(true)
        Text_festival_each_child_gold_n:setString(info[1])
        Button_festival_each_child:setTouchEnabled(true)
        Button_festival_each_child:setBright(true)
    else
        Text_festival_each_child_get:setVisible(false)
        Text_festival_each_child_get_n:setString("")

        Image_10:setVisible(false)
        Text_festival_each_child_gold_n:setString("")
        Button_festival_each_child:setTouchEnabled(false)
        Button_festival_each_child:setBright(false)
    end

    if tonumber(activity_add_state[3]) / 1000 < (os.time() + _ED.time_add_or_sub) then
        -- 活动结束
        Button_festival_each_child:setTouchEnabled(false)
        Button_festival_each_child:setBright(false)
    end
end

function RedAlertTimeFestivalEachChildGift:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.festival_each_child_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 集福记录
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_each_child_record"), nil, 
    {
        terminal_name = "red_alert_time_festival_each_child_gift_get_record", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 集福
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_each_child"), nil, 
    {
        terminal_name = "red_alert_time_festival_each_child_gift_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:onUpdateDraw()
end

function RedAlertTimeFestivalEachChildGift:onEnterTransitionFinish()

end

function RedAlertTimeFestivalEachChildGift:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeFestivalEachChildGift:onExit()
    state_machine.remove("red_alert_time_festival_each_child_gift_show")
    state_machine.remove("red_alert_time_festival_each_child_gift_hide")
    state_machine.remove("red_alert_time_festival_each_child_gift_update")
    state_machine.remove("red_alert_time_festival_each_child_gift_get_record")
    state_machine.remove("red_alert_time_festival_each_child_gift_get_reward")
end