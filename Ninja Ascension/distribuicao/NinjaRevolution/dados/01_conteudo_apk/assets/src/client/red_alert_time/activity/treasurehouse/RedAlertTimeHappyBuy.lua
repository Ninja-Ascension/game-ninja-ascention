-----------------------------
--欢乐团购
-----------------------------
RedAlertTimeHappyBuy = class("RedAlertTimeHappyBuyClass", Window)

local red_alert_time_happy_buy_window_open_terminal = {
    _name = "red_alert_time_happy_buy_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local acitvity = _ED.activity_info[""..params[1].activity_type]
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("RedAlertTimeHappyBuyClass") then
                    fwin:open(RedAlertTimeHappyBuy:new():init(params), fwin._ui)
                    return panel
                end    
            end
        end     
        protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n"..(0).."\r\n"..(0).."\r\n2"
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_happy_buy_window_close_terminal = {
    _name = "red_alert_time_happy_buy_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeHappyBuyClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_happy_buy_window_open_terminal)
state_machine.add(red_alert_time_happy_buy_window_close_terminal)
state_machine.init()

function RedAlertTimeHappyBuy:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0
    self._gift_panel = nil
    self._record_panel = nil

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeHappyBuyGift")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeHappyBuyRecord")

    local function init_red_alert_time_happy_buy_terminal()
        local red_alert_time_happy_buy_change_page_terminal = {
          _name = "red_alert_time_happy_buy_change_page",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
        state_machine.add(red_alert_time_happy_buy_change_page_terminal)
        state_machine.init()
    end
    init_red_alert_time_happy_buy_terminal()
end

function RedAlertTimeHappyBuy:changeSelectPage( page )
    local root = self.roots[1]
    local Text_leader_senior_tit = ccui.Helper:seekWidgetByName(root, "Text_leader_senior_tit")
    Text_leader_senior_tit:setString(self._activity_type.activity_title)

    local Panel_leader_senior_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_leader_senior_tab_box")
    local Button_happy_buy_dis_reward = ccui.Helper:seekWidgetByName(root, "Button_happy_buy_dis_reward")
    local Button_happy_buy_record = ccui.Helper:seekWidgetByName(root, "Button_happy_buy_record")
    if page == self._current_page then
        if page == 1 then
            Button_happy_buy_dis_reward:setHighlighted(true)
        elseif page == 2 then
            Button_happy_buy_record:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_happy_buy_dis_reward:setHighlighted(false)
    Button_happy_buy_record:setHighlighted(false)
    state_machine.excute("red_alert_time_happy_buy_gift_hide", 0, nil)
    state_machine.excute("red_alert_time_happy_buy_record_hide", 0, nil)
    if page == 1 then
        Button_happy_buy_dis_reward:setHighlighted(true)
        if self._gift_panel == nil then
            self._gift_panel = state_machine.excute("red_alert_time_happy_buy_gift_open", 0, {Panel_leader_senior_tab_box, self._activity_type.activity_type})
        else
            state_machine.excute("red_alert_time_happy_buy_gift_show", 0, nil)
        end
    elseif page == 2 then
        Button_happy_buy_record:setHighlighted(true)
        if self._record_panel == nil then
            self._record_panel = state_machine.excute("red_alert_time_happy_buy_record_open", 0, {Panel_leader_senior_tab_box, self._activity_type.activity_type})
        else
            state_machine.excute("red_alert_time_happy_buy_record_show", 0, nil)
        end
    end
end

function RedAlertTimeHappyBuy:onEnterTransitionFinish()

end

function RedAlertTimeHappyBuy:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.happy_buy)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_leader_senior_close"), nil, 
    {
        terminal_name = "red_alert_time_happy_buy_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_happy_buy_dis_reward"), nil, 
    {
        terminal_name = "red_alert_time_happy_buy_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_happy_buy_record"), nil, 
    {
        terminal_name = "red_alert_time_happy_buy_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_happy_buy_record_push",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_happy_buy_record"),
        _invoke = nil,
        _interval = 0.3,})

    self:changeSelectPage(1)
end

function RedAlertTimeHappyBuy:onUpdate(dt)

end

function RedAlertTimeHappyBuy:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeHappyBuy:onExit()
    state_machine.remove("red_alert_time_happy_buy_change_page")
end
