-----------------------------
--节日祝福
-----------------------------
RedAlertTimeFestivalEachChild = class("RedAlertTimeFestivalEachChildClass", Window)

local red_alert_time_festival_each_child_window_open_terminal = {
    _name = "red_alert_time_festival_each_child_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeFestivalEachChildClass") then
            fwin:open(RedAlertTimeFestivalEachChild:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_festival_each_child_window_close_terminal = {
    _name = "red_alert_time_festival_each_child_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeFestivalEachChildClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_festival_each_child_window_open_terminal)
state_machine.add(red_alert_time_festival_each_child_window_close_terminal)
state_machine.init()

function RedAlertTimeFestivalEachChild:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_info = nil 
    self._activity_type = 0
    self._current_page = 0
    self._gift_panel = nil
    self._bless_panel = nil

    self._is_end = false
    self.m_times = 0
    self.m_reset_times = 0
    self._label_close_text = nil
    self._label_reset_text = nil

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFestivalEachChildGift")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFestivalEachChildBless")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFestivalEachRecord")

    local function init_red_alert_time_festival_each_child_terminal()
        local red_alert_time_festival_each_child_change_page_terminal = {
            _name = "red_alert_time_festival_each_child_change_page",
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

        local red_alert_time_festival_each_child_rule_infor_terminal = {
            _name = "red_alert_time_festival_each_child_rule_infor",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_festival_each_child_change_page_terminal)
        state_machine.add(red_alert_time_festival_each_child_rule_infor_terminal)
        state_machine.init()
    end
    init_red_alert_time_festival_each_child_terminal()
end

function RedAlertTimeFestivalEachChild:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_festival_each_child_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_festival_each_child_tab_box")
    local Button_festival_each_child = ccui.Helper:seekWidgetByName(root, "Button_festival_each_child")
    local Button_festival_blessing = ccui.Helper:seekWidgetByName(root, "Button_festival_blessing")
    if page == self._current_page then
        if page == 1 then
            Button_festival_each_child:setHighlighted(true)
        elseif page == 2 then
            Button_festival_blessing:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_festival_each_child:setHighlighted(false)
    Button_festival_blessing:setHighlighted(false)
    state_machine.excute("red_alert_time_festival_each_child_gift_hide", 0, nil)
    state_machine.excute("red_alert_time_festival_each_child_bless_hide", 0, nil)
    if page == 1 then
        Button_festival_each_child:setHighlighted(true)
        if self._gift_panel == nil then
            self._gift_panel = state_machine.excute("red_alert_time_festival_each_child_gift_open", 0, {Panel_festival_each_child_tab_box, self._activity_type})
        else
            state_machine.excute("red_alert_time_festival_each_child_gift_show", 0, nil)
        end
    elseif page == 2 then
        Button_festival_blessing:setHighlighted(true)
        if self._bless_panel == nil then
            self._bless_panel = state_machine.excute("red_alert_time_festival_each_child_bless_open", 0, {Panel_festival_each_child_tab_box, self._activity_type})
        else
            state_machine.excute("red_alert_time_festival_each_child_bless_show", 0, nil)
        end
    end

    self:onUpdateDraw()
end

function RedAlertTimeFestivalEachChild:onUpdateDraw()
    local root = self.roots[1]

    self._activity_info = _ED.activity_info[""..self._activity_type]

    local Text_festival_each_child_tit = ccui.Helper:seekWidgetByName(root, "Text_festival_each_child_tit")
    Text_festival_each_child_tit:setString(self._activity_info.activity_title)

    local Text_festival_blessing_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_festival_blessing_infor_p_1")
    Text_festival_blessing_infor_p_1:setString(self._activity_info.activity_dec)
    -- 结束和关闭倒计时
    self._is_end = false
    local time_str = activity_str_tip[93]
    local activity_add_state_arr = zstring.split(self._activity_info.activity_add_state, "|")
    local activity_add_state = zstring.split(activity_add_state_arr[1], ",")
    if tonumber(activity_add_state[3]) / 1000 < (os.time() + _ED.time_add_or_sub) then
        self._is_end = true
        self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)
        time_str = activity_str_tip[179]
    else
        self._is_end = false
        self.m_times = tonumber(activity_add_state[3]) / 1000 - (os.time() + _ED.time_add_or_sub)
        time_str = activity_str_tip[93]
    end
    local Text_festival_blessing_time_1 = ccui.Helper:seekWidgetByName(root,"Text_festival_blessing_time_1")
    Text_festival_blessing_time_1:removeAllChildren(true)
    Text_festival_blessing_time_1:setString("")
    local time_info, time_int = createActivityTimeLable(Text_festival_blessing_time_1, 0, time_str, getRedAlertTimeActivityFormat(self.m_times))
    Text_festival_blessing_time_1:addChild(time_info)
    Text_festival_blessing_time_1:addChild(time_int)
    self._label_close_text = time_int

    -- 重置倒计时
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    local Text_festival_blessing_time_2 = ccui.Helper:seekWidgetByName(root,"Text_festival_blessing_time_2")
    Text_festival_blessing_time_2:removeAllChildren(true)
    Text_festival_blessing_time_2:setString("")
    local reset_time_info, reset_time_int = createActivityTimeLable(Text_festival_blessing_time_2, 1, activity_str_tip[97], getRedAlertTimeActivityFormat(self.m_reset_times))
    Text_festival_blessing_time_2:addChild(reset_time_info)
    Text_festival_blessing_time_2:addChild(reset_time_int)
    self._label_reset_text = reset_time_int
end

function RedAlertTimeFestivalEachChild:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_text ~= nil then
            self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
            state_machine.excute("red_alert_time_festival_each_child_gift_update", 0, "")
        end
    end

    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self._is_end == false then
                self:onUpdateDraw()
                state_machine.excute("red_alert_time_festival_each_child_gift_update", 0, "")
            else
                state_machine.excute("red_alert_time_center_find",0,"red_alert_time_festival_each_child_window_close")
            end
        end
    end
end

function RedAlertTimeFestivalEachChild:onEnterTransitionFinish()

end

function RedAlertTimeFestivalEachChild:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.festival_each_child)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_festival_each_child_close"), nil, 
    {
        terminal_name = "red_alert_time_festival_each_child_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_each_child"), nil, 
    {
        terminal_name = "red_alert_time_festival_each_child_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_blessing"), nil, 
    {
        terminal_name = "red_alert_time_festival_each_child_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_blessing_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_festival_each_child_rule_infor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:changeSelectPage(1)
end

function RedAlertTimeFestivalEachChild:init(params)
    self._activity_info = params[1]
    self._activity_type = self._activity_info.activity_type
    self:onInit()
    return self
end

function RedAlertTimeFestivalEachChild:onExit()
    state_machine.remove("red_alert_time_festival_each_child_change_page")
    state_machine.remove("red_alert_time_festival_each_child_rule_infor")
end
