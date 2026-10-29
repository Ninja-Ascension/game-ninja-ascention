-----------------------------
--月卡
-----------------------------
OnCard = class("OnCardClass", Window)

local on_card_window_open_terminal = {
    _name = "on_card_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("OnCardClass") then
            local panel = OnCard:new():init(params)
            fwin:open(panel)
            return panel
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(on_card_window_open_terminal)
state_machine.init()

function OnCard:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file

    -- Initialize on_card state machine.
    local function init_on_card_terminal()
      -- 充值界面跳转
        local on_card_goto_recharge_list_terminal = {
            _name = "on_card_goto_recharge_list",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("recharge_dialog_window_open",0,params._datas.ntype)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local on_card_update_terminal = {
            _name = "on_card_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --领取月卡
        local on_card_get_month_card_reward_terminal = {
            _name = "on_card_get_month_card_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{1001})
                        state_machine.excute("on_card_update", 0, nil)
                    end
                end
                protocol_command.draw_month_card_reward.param_list = "".._drawMonth[params._datas.ntype][1]
                NetworkManager:register(protocol_command.draw_month_card_reward.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(on_card_update_terminal)
        state_machine.add(on_card_goto_recharge_list_terminal)
        state_machine.add(on_card_get_month_card_reward_terminal)
        state_machine.init()
    end
    
    -- call func init sign_in state machine.
    init_on_card_terminal()
end

function OnCard:onUpdateDraw()
    local root = self.roots[1]
    local Text_on_card_17 = ccui.Helper:seekWidgetByName(root,"Text_on_card_17")--月卡每天宝石数量
    local Text_6 = ccui.Helper:seekWidgetByName(root,"Text_6")--终身卡每天宝石数量
    local Text_on_card_day = ccui.Helper:seekWidgetByName(root,"Text_on_card_day")--第一种月卡天数
    local Text_on_card_z_day = ccui.Helper:seekWidgetByName(root,"Text_on_card_z_day")--第二种月卡天数
    
    local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
    local one_month_data = _drawMonth[1]
    local two_month_data = _drawMonth[2]
    local daily_reward_one = dms.atoi(one_month_data,top_up_goods.daily_reward_gold)
    local daily_reward_two = dms.atoi(two_month_data,top_up_goods.daily_reward_gold)
    Text_on_card_17:setString(daily_reward_one)
    Text_6:setString(daily_reward_two)
    if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[_drawMonth[1][1]] ~= nil and _ED.month_card[_drawMonth[1][1]] ~= "" then
        local monthCardDayOne = _ED.month_card[_drawMonth[1][1]].surplus_month_card_time
        Text_on_card_day:setString(monthCardDayOne)
        local month_card_state = _ED.month_card[_drawMonth[1][1]].draw_month_card_state
        if zstring.tonumber(monthCardDayOne) > 0 then
            if zstring.tonumber(month_card_state) == 0 then
                ccui.Helper:seekWidgetByName(root,"Button_on_card_buy"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_1"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_have_receive_1"):setVisible(false)
            else
                if tonumber(monthCardDayOne) < 90 then 
                    ccui.Helper:seekWidgetByName(root,"Button_on_card_buy"):setVisible(true)
                    ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_1"):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Image_have_receive_1"):setVisible(true)
                else
                    ccui.Helper:seekWidgetByName(root,"Button_on_card_buy"):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_1"):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Image_have_receive_1"):setVisible(true)
                end
            end
        else
            ccui.Helper:seekWidgetByName(root,"Button_on_card_buy"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_1"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_have_receive_1"):setVisible(false)
        end
    else
        Text_on_card_day:setString(0)
        ccui.Helper:seekWidgetByName(root,"Button_on_card_buy"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_have_receive_1"):setVisible(false)
    end
    if Text_on_card_z_day ~= nil then
        if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[_drawMonth[2][1]] ~= nil and _ED.month_card[_drawMonth[1][1]] ~= "" then
            local monthCardDayOne = _ED.month_card[_drawMonth[2][1]].surplus_month_card_time
            Text_on_card_z_day:setString(monthCardDayOne)
            local month_card_state = _ED.month_card[_drawMonth[2][1]].draw_month_card_state
            if zstring.tonumber(monthCardDayOne) > 0 then
                if zstring.tonumber(month_card_state) == 0 then
                    ccui.Helper:seekWidgetByName(root,"Button_1"):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_2"):setVisible(true)
                    ccui.Helper:seekWidgetByName(root,"Image_have_receive_2"):setVisible(false)
                else
                    if tonumber(monthCardDayOne) < 90 then 
                        ccui.Helper:seekWidgetByName(root,"Button_1"):setVisible(true)
                        ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_2"):setVisible(false)
                        ccui.Helper:seekWidgetByName(root,"Image_have_receive_2"):setVisible(true)
                    else
                        ccui.Helper:seekWidgetByName(root,"Button_1"):setVisible(false)
                        ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_2"):setVisible(false)
                        ccui.Helper:seekWidgetByName(root,"Image_have_receive_2"):setVisible(true)
                    end
                end
            else
                ccui.Helper:seekWidgetByName(root,"Button_1"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_2"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Image_have_receive_2"):setVisible(false)
            end
        else
            Text_on_card_z_day:setString(0)
            ccui.Helper:seekWidgetByName(root,"Button_1"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_2"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_have_receive_2"):setVisible(false)
        end
    end
end

function OnCard:onEnterTransitionFinish()

end

function OnCard:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.on_card)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --购买  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_on_card_buy"), nil, 
    {
        terminal_name = "on_card_goto_recharge_list", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 1,
    }, nil, 0)

    --购买   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "on_card_goto_recharge_list", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 2,
    }, nil, 0)

    -- 金卡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_1"), nil, 
    {
        terminal_name = "on_card_get_month_card_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 1,
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_activity_on_card_gold",
    _widget = ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_1"),
    _invoke = nil,
    _interval = 0.5,})

    -- 钻卡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_2"), nil, 
    {
        terminal_name = "on_card_get_month_card_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 2,
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_activity_on_card_jewel",
    _widget = ccui.Helper:seekWidgetByName(root,"Button_on_card_receive_2"),
    _invoke = nil,
    _interval = 0.5,})

    self:onUpdateDraw()
end

function OnCard:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function OnCard:onExit()
    state_machine.remove("on_card_goto_recharge_list")
    state_machine.remove("on_card_update")
    state_machine.remove("on_card_get_month_card_reward")
end
