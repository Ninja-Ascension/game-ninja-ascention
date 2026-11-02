-----------------------------
--狂欢时刻
-----------------------------
RedAlertTimeCarnivalHour = class("RedAlertTimeCarnivalHourClass", Window)

local red_alert_time_carnival_hour_window_open_terminal = {
    _name = "red_alert_time_carnival_hour_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeCarnivalHourClass") then
            fwin:open(RedAlertTimeCarnivalHour:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_carnival_hour_window_close_terminal = {
    _name = "red_alert_time_carnival_hour_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.show_reward_list_group_ex = {}
        fwin:close(fwin:find("RedAlertTimeCarnivalHourClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_carnival_hour_window_open_terminal)
state_machine.add(red_alert_time_carnival_hour_window_close_terminal)
state_machine.init()

function RedAlertTimeCarnivalHour:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0

    self._online_panel = nil
    self._recharge_panel = nil
    self._shop_panel = nil

    self.m_times = 0
    self.m_reset_times = 0
    self.m_shop_time = 0
    self._label_close_time = nil
    self._label_reset_time = nil
    self._label_shop_time = nil

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeCarnivalHourOnline")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeCarnivalHourRecharge")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeCarnivalHourShop")

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_carnival_hour_all_cell")
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_carnival_hour_time_limit_cell")
    app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_discount_label")

    local function init_red_alert_time_carnival_hour_terminal()
    
        -- 切换界面
        local red_alert_time_carnival_hour_change_page_terminal = {
            _name = "red_alert_time_carnival_hour_change_page",
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

        -- 刷新界面
        local red_alert_time_carnival_hour_update_draw_terminal = {
            _name = "red_alert_time_carnival_hour_update_draw",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                state_machine.excute("red_alert_time_carnival_hour_online_update_draw", 0, "")
                state_machine.excute("red_alert_time_carnival_hour_recharge_update_draw", 0, "")
                state_machine.excute("red_alert_time_carnival_hour_shop_update_draw", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 商品刷新时间
        local red_alert_time_carnival_hour_update_shop_reset_time_terminal = {
            _name = "red_alert_time_carnival_hour_update_shop_reset_time",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateShopResetTime()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_carnival_hour_change_page_terminal)
        state_machine.add(red_alert_time_carnival_hour_update_draw_terminal)
        state_machine.add(red_alert_time_carnival_hour_update_shop_reset_time_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_carnival_hour state machine.
    init_red_alert_time_carnival_hour_terminal()
end


function RedAlertTimeCarnivalHour:changeSelectPage( page )
    local root = self.roots[1]
    
    local Panel_carnival_hour_tab = ccui.Helper:seekWidgetByName(root, "Panel_carnival_hour_tab")
    local Button_carnival_hour_all = ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_all")
    local Button_carnival_hour_recharge_reward = ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_recharge_reward")
    local Button_carnival_hour_time_limit = ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_time_limit")
    if page == self._current_page then
        if page == 1 then
            Button_carnival_hour_all:setHighlighted(true)
        elseif page == 2 then
            Button_carnival_hour_recharge_reward:setHighlighted(true)
        elseif page == 3 then
            Button_carnival_hour_time_limit:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_carnival_hour_all:setHighlighted(false)
    Button_carnival_hour_recharge_reward:setHighlighted(false)
    Button_carnival_hour_time_limit:setHighlighted(false)
    state_machine.excute("red_alert_time_carnival_hour_online_hide", 0, nil)
    state_machine.excute("red_alert_time_carnival_hour_recharge_hide", 0, nil)
    state_machine.excute("red_alert_time_carnival_hour_shop_hide", 0, nil)
    if page == 1 then
        Button_carnival_hour_all:setHighlighted(true)
        if self._online_panel == nil then
            self._online_panel = state_machine.excute("red_alert_time_carnival_hour_online_open", 0, {Panel_carnival_hour_tab,self._activity_type})
        else
            state_machine.excute("red_alert_time_carnival_hour_online_show", 0, nil)
        end
    elseif page == 2 then
        Button_carnival_hour_recharge_reward:setHighlighted(true)
        if self._recharge_panel == nil then
            self._recharge_panel = state_machine.excute("red_alert_time_carnival_hour_recharge_open", 0, {Panel_carnival_hour_tab,self._activity_type})
        else
            state_machine.excute("red_alert_time_carnival_hour_recharge_show", 0, nil)
        end
    elseif page == 3 then
        Button_carnival_hour_time_limit:setHighlighted(true)
        if self._shop_panel == nil then
            self._shop_panel = state_machine.excute("red_alert_time_carnival_hour_shop_open", 0, {Panel_carnival_hour_tab,self._activity_type})
        else
            state_machine.excute("red_alert_time_carnival_hour_shop_show", 0, nil)
        end
    end

    self:onUpdateDraw()
end

function RedAlertTimeCarnivalHour:onUpdateDraw()
    local root = self.roots[1]
    local Text_carnival_hour_tit = ccui.Helper:seekWidgetByName(root, "Text_carnival_hour_tit")
    local Text_discount_store_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_discount_store_infor_p_1")
    Text_carnival_hour_tit:setString(self._activity_type.activity_title)
    Text_discount_store_infor_p_1:setString(self._activity_type.activity_dec)

    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state_arr = zstring.split(self._activity_type.activity_add_state, "|")
    local timesData = zstring.split(activity_add_state_arr[1], ",")
    self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    -- 关闭倒计时
    local Text_discount_store_time_1 = ccui.Helper:seekWidgetByName(root,"Text_discount_store_time_1")
    Text_discount_store_time_1:removeAllChildren(true)
    Text_discount_store_time_1:setString("")

    local time_info, time_int = createActivityTimeLable(Text_discount_store_time_1, 0, activity_str_tip[93], "")
    Text_discount_store_time_1:addChild(time_info)
    Text_discount_store_time_1:addChild(time_int)
    self._label_close_time = time_int

    -- 重置倒计时
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    local Text_discount_store_time_2 = ccui.Helper:seekWidgetByName(root,"Text_discount_store_time_2")
    Text_discount_store_time_2:removeAllChildren(true)
    Text_discount_store_time_2:setString("")

    local reset_time_info, reset_time_int = createActivityTimeLable(Text_discount_store_time_2, 0, activity_str_tip[97], "")
    Text_discount_store_time_2:addChild(reset_time_info)
    Text_discount_store_time_2:addChild(reset_time_int)
    self._label_reset_time = reset_time_int

    local Text_discount_store_time_n = ccui.Helper:seekWidgetByName(root,"Text_discount_store_time_n")
    if self._current_page == 3 then
        Text_discount_store_time_1:setVisible(false)
        Text_discount_store_time_2:setVisible(false)
        Text_discount_store_time_n:setVisible(true)
    else
        Text_discount_store_time_1:setVisible(true)
        Text_discount_store_time_2:setVisible(true)
        Text_discount_store_time_n:setVisible(false)
    end
end

function RedAlertTimeCarnivalHour:onUpdateShopResetTime()
    local root = self.roots[1]
    -- 商品下次刷新时间
    self.m_shop_time = 0

    if _ED.carnival_hour_shop_reset_time ~= nil then
        self.m_shop_time = _ED.carnival_hour_shop_reset_time
    end

    local Text_discount_store_time_n = ccui.Helper:seekWidgetByName(root,"Text_discount_store_time_n")
    Text_discount_store_time_n:removeAllChildren(true)
    Text_discount_store_time_n:setString("")

    local shop_time_info, shop_time_int = createActivityTimeLable(Text_discount_store_time_n, 0, activity_str_tip[154], "")
    Text_discount_store_time_n:addChild(shop_time_info)
    Text_discount_store_time_n:addChild(shop_time_int)
    self._label_shop_time = shop_time_int

    if self._current_page == 3 then
        local next_push_time = os.time() + self.m_shop_time
        cc.UserDefault:getInstance():setStringForKey(getKey("activity_id_"..self._activity_type.activity_type), next_push_time)
        cc.UserDefault:getInstance():flush()
        state_machine.excute("treasure_carnival_hour_push_update",0,"")
        state_machine.excute("red_alert_time_center_update_push", 0, self._activity_type.activity_type)
        state_machine.excute("notification_center_update", 0, "push_notification_mine_treasure_push")
        state_machine.excute("notification_center_update", 0, "push_notification_canival_hour")
    end
end

function RedAlertTimeCarnivalHour:onEnterTransitionFinish()

end

function RedAlertTimeCarnivalHour:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.carnival_hour)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_carnival_hour_close"), nil, 
    {
        terminal_name = "red_alert_time_carnival_hour_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_all"), nil, 
    {
        terminal_name = "red_alert_time_carnival_hour_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_canival_hour",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_all"),
        _ntype = 1,
        _invoke = nil,
        _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_recharge_reward"), nil, 
    {
        terminal_name = "red_alert_time_carnival_hour_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_canival_hour",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_recharge_reward"),
        _ntype = 2,
        _invoke = nil,
        _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_time_limit"), nil, 
    {
        terminal_name = "red_alert_time_carnival_hour_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_canival_hour",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_carnival_hour_time_limit"),
        _ntype = 3,
        _invoke = nil,
        _interval = 0.2,})

    self:changeSelectPage(1)
end

function RedAlertTimeCarnivalHour:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_time ~= nil then
            self._label_reset_time:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end

    if self.m_shop_time > 0 then
        self.m_shop_time = self.m_shop_time - dt
        if self._label_shop_time ~= nil then
            self._label_shop_time:setString(getRedAlertTimeActivityFormat(self.m_shop_time))
        end
        if self.m_shop_time <= 0 then
            self.m_shop_time = 0
            state_machine.excute("red_alert_time_carnival_hour_shop_request_shop_info", 0, "")
        end
    end

    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_time ~= nil then
            self._label_close_time:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_carnival_hour_window_close")
        end
    end
end


function RedAlertTimeCarnivalHour:init(params)
    self._activity_type = params[1]
    self:onInit()
    return self
end

function RedAlertTimeCarnivalHour:onExit()
    state_machine.remove("red_alert_time_carnival_hour_change_page")
    state_machine.remove("red_alert_time_carnival_hour_update_draw")
    state_machine.remove("red_alert_time_carnival_hour_update_shop_reset_time")
end
