--------------------------------------------------------------------------------------------------------------
--  说明：七日狂欢
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSevenDayActivity = class("RedAlertTimeSevenDayActivityClass", Window)

--打开界面
local red_alert_time_seven_day_activity_window_open_terminal = {
    _name = "red_alert_time_seven_day_activity_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RedAlertTimeSevenDayActivityClass") then
            fwin:open(RedAlertTimeSevenDayActivity:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local red_alert_time_seven_day_activity_window_close_terminal = {
    _name = "red_alert_time_seven_day_activity_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeSevenDayActivityClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_seven_day_activity_window_open_terminal)
state_machine.add(red_alert_time_seven_day_activity_window_close_terminal)
state_machine.init()

function RedAlertTimeSevenDayActivity:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0

    self._panel_tables = {}

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSevenDayActivityTab")
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seven_day_activity_cell")
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seven_day_activity_recharge_cell")

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")

    local function init_red_alert_time_seven_day_activity_terminal()
        local red_alert_time_seven_day_activity_change_page_terminal = {
            _name = "red_alert_time_seven_day_activity_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas.page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_update_draw_terminal = {
            _name = "red_alert_time_seven_day_activity_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local update_day_index = params[1]
                for k, v in pairs(instance._panel_tables) do
                    state_machine.excute("red_alert_time_seven_day_activity_tab_update", 0, {v, update_day_index})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_update_state_terminal = {
            _name = "red_alert_time_seven_day_activity_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if _ED.activity_info["100"] == nil then
                    fwin:addService({
                        callback = function ( params )
                            state_machine.excute("red_alert_time_seven_day_activity_window_close", 0, "")
                        end,
                        delay = 0.4,
                        params = ""
                    })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_select_tab_page_terminal = {
            _name = "red_alert_time_seven_day_activity_select_tab_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params[1]
                local page = params[2]
                if instance._panel_tables[""..index] ~= nil then
                    state_machine.excute("red_alert_time_seven_day_activity_tab_change_page", 0, 
                        {_datas = {panel = instance._panel_tables[""..index], page = page}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(red_alert_time_seven_day_activity_change_page_terminal)    
        state_machine.add(red_alert_time_seven_day_activity_update_draw_terminal)    
        state_machine.add(red_alert_time_seven_day_activity_update_state_terminal)    
        state_machine.add(red_alert_time_seven_day_activity_select_tab_page_terminal)   
        state_machine.init()
    end
    init_red_alert_time_seven_day_activity_terminal()
end

function RedAlertTimeSevenDayActivity:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_consumption_turntable_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_consumption_turntable_tab_box")
    local Button_consumption_turntable = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable")
    local Button_consumption_turntable_rank = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rank")
    local Button_consumption_turntable_reward = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_reward")
    local Button_consumption_turntable_rule = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rule")
    local Button_consumption_turntable_act = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_act")
    Button_consumption_turntable:setHighlighted(false)
    Button_consumption_turntable_rank:setHighlighted(false)
    Button_consumption_turntable_reward:setHighlighted(false)
    Button_consumption_turntable_rule:setHighlighted(false) 
    if Button_consumption_turntable_act ~= nil then
        Button_consumption_turntable_act:setHighlighted(false)
    end 
    if page == 1 then
        Button_consumption_turntable:setHighlighted(true)
    elseif page == 2 then
        Button_consumption_turntable_rank:setHighlighted(true)
    elseif page == 3 then
        Button_consumption_turntable_reward:setHighlighted(true)
    elseif page == 4 then
        Button_consumption_turntable_rule:setHighlighted(true)
    else
        Button_consumption_turntable_act:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end

    local day_index = 0
    if __lua_project_id == __lua_project_pacific_rim then
        if self._current_page ~= 5 and self._panel_tables[""..self._current_page] ~= nil then
            day_index = self._panel_tables[""..self._current_page]._day_index
        end
    end
    
    self._current_page = page
    for k, v in pairs(self._panel_tables) do
        state_machine.excute("red_alert_time_seven_day_activity_tab_hide", 0, v)
    end

    if self._panel_tables[""..self._current_page] == nil then
        self._panel_tables[""..self._current_page] = state_machine.excute("red_alert_time_seven_day_activity_tab_window_open", 0, {Panel_consumption_turntable_tab_box, self._current_page, day_index})
    else
        state_machine.excute("red_alert_time_seven_day_activity_tab_show", 0, {self._panel_tables[""..self._current_page], day_index})
    end
end

function RedAlertTimeSevenDayActivity:onInit(params)
    local csbItem = csb.createNode(config_csb.treasurehouse.seven_day_activity)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_close"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_change_page", 
        terminal_state = 0, 
        page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_day_activity_type",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable"),
        _invoke = nil,
        _activity_index = 1,
        _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rank"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_change_page", 
        terminal_state = 0, 
        page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_day_activity_type",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rank"),
        _invoke = nil,
        _activity_index = 2,
        _interval = 0.2,})
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_reward"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_change_page", 
        terminal_state = 0, 
        page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_day_activity_type",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_reward"),
        _invoke = nil,
        _activity_index = 3,
        _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rule"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_change_page", 
        terminal_state = 0, 
        page = 4,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_day_activity_type",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rule"),
        _invoke = nil,
        _activity_index = 4,
        _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_act"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_change_page", 
        terminal_state = 0, 
        page = 5,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_day_activity",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_act"),
        _invoke = nil,
        _activity_index = 1,
        _day = 8,
        _interval = 0.2,})
    
    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function RedAlertTimeSevenDayActivity:onEnterTransitionFinish()

end

function RedAlertTimeSevenDayActivity:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
    return self
end

function RedAlertTimeSevenDayActivity:onExit()
    state_machine.remove("red_alert_time_seven_day_activity_change_page")
    state_machine.remove("red_alert_time_seven_day_activity_update_draw")
    state_machine.remove("red_alert_time_seven_day_activity_update_state")
    state_machine.remove("red_alert_time_seven_day_activity_select_tab_page")
end