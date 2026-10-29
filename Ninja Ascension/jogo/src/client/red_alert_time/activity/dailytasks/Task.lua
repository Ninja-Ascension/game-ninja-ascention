-----------------------------
--任务
-----------------------------
Task = class("TaskClass", Window)

local task_window_open_terminal = {
    _name = "task_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(239) == true then
            return
        end 
        if _ED.mould_function_push_info["12"] ~= nil then
            local function responseTaskInitCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    _ED.mould_function_push_info["12"] = nil
                    if missionIsOver() == true then
                        state_machine.excute("tuition_controller_touch_other_exit", 0, 0)
                    end
                    local _Window = fwin:find("TaskClass")
                    if nil == _Window then
                        fwin:open(Task:new():init(), fwin._ui)
                    else
                        state_machine.excute("task_window_show",0,"")
                    end
                    if missionIsOver() == true then
                        fwin:close(fwin:find("TuitionControllerClass"))
                        state_machine.excute("task_main_line_list_update_drawtuition_controller", 0, 0)
                    end
                end
            end
            _ED.user_task_infos = nil
            NetworkManager:register(protocol_command.task_init.code, nil, nil, nil, nil, responseTaskInitCallback, false, nil)
        else
            if missionIsOver() == true then
                state_machine.excute("tuition_controller_touch_other_exit", 0, 0)
            end
            local _Window = fwin:find("TaskClass")
            if nil == _Window then
                fwin:open(Task:new():init(), fwin._ui)
            else
                state_machine.excute("task_window_show",0,"")
            end
            if missionIsOver() == true then
                fwin:close(fwin:find("TuitionControllerClass"))
                state_machine.excute("task_main_line_list_update_drawtuition_controller", 0, 0)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local task_window_close_terminal = {
    _name = "task_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TaskClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_window_open_terminal)
state_machine.add(task_window_close_terminal)
state_machine.init()

function Task:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._current_page = 0
    self._mainPanel = nil
    self._dailyPanel = nil
    self._teachingPanel = nil

    app.load("client.red_alert_time.activity.dailytasks.TaskMainLineList")
    app.load("client.red_alert_time.activity.dailytasks.TaskDailyList")
    app.load("client.red_alert_time.activity.dailytasks.TaskDetail")
    app.load("client.red_alert_time.activity.dailytasks.TaskGameTeaching")
    
    app.load("client.red_alert_time.cells.activity.dailytasks.task_cell")
    app.load("client.red_alert_time.cells.activity.dailytasks.task_title_cell")
    app.load("client.red_alert_time.cells.activity.dailytasks.task_daily_cell")
    app.load("client.red_alert_time.cells.activity.dailytasks.task_game_teaching_cell")

    local function init_task_terminal()
        local task_main_change_page_terminal = {
            _name = "task_main_change_page",
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

        local task_main_update_task_state_terminal = {
            _name = "task_main_update_task_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("task_daily_list_update_listview", 0, nil)
                state_machine.excute("task_main_line_list_update_listview", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_window_close_check_terminal = {
            _name = "task_window_close_check",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("task_window_close", 0, nil)
                state_machine.excute("main_window_check_mission", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(task_main_change_page_terminal)
        state_machine.add(task_main_update_task_state_terminal)
        state_machine.add(task_window_close_check_terminal)
        state_machine.init()
    end
    init_task_terminal()
end

function Task:onHide( ... )
    self:setVisible(false)
end

function Task:onShow( ... )
    self:setVisible(true)
end

function Task:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_task_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_task_tab_box")
    local Button_main_task = ccui.Helper:seekWidgetByName(root, "Button_main_task")
    local Button_daily_task = ccui.Helper:seekWidgetByName(root, "Button_daily_task")
    local Button_game_teaching = ccui.Helper:seekWidgetByName(root, "Button_game_teaching")
    if page == self._current_page then
        if page == 1 then
            Button_main_task:setHighlighted(true)
        elseif page == 2 then
            Button_daily_task:setHighlighted(true)
        elseif page == 3 then
            Button_game_teaching:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_main_task:setHighlighted(false)
    Button_daily_task:setHighlighted(false)
    if Button_game_teaching ~= nil then
        Button_game_teaching:setHighlighted(false)
    end
    state_machine.excute("task_main_line_list_window_hide", 0, nil)
    state_machine.excute("task_daily_list_window_hide", 0, nil)
    state_machine.excute("task_game_teaching_window_hide", 0, nil)
    if page == 1 then
        Button_main_task:setHighlighted(true)
        if self._mainPanel == nil then
            self._mainPanel = state_machine.excute("task_main_line_list_window_open", 0, {Panel_task_tab_box})
        else
            state_machine.excute("task_main_line_list_window_show", 0, nil)
        end
    elseif page == 2 then
        Button_daily_task:setHighlighted(true)
        if self._dailyPanel == nil then
            self._dailyPanel = state_machine.excute("task_daily_list_window_open", 0, {Panel_task_tab_box})
        else
            state_machine.excute("task_daily_list_window_show", 0, nil)
        end
    elseif page == 3 then
        Button_game_teaching:setHighlighted(true)
        if self._teachingPanel == nil then
            self._teachingPanel = state_machine.excute("task_game_teaching_window_open", 0, {Panel_task_tab_box})
        else
            state_machine.excute("task_game_teaching_window_show", 0, nil)
        end
    end
end

function Task:onEnterTransitionFinish()

end

function Task:onInit( )
    local csbItem = csb.createNode(config_csb.task.task)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    app.notification_center.running = false
    self.__check_covers = true
    root.__cwindow = self
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN, nil)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_close"), nil, 
    {
        terminal_name = "task_window_close_check", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_main_task"), nil, 
    {
        terminal_name = "task_main_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_button_main",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_main_task"),
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_daily_task"), nil, 
    {
        terminal_name = "task_main_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_button_daily",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_daily_task"),
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_game_teaching"), nil, 
    {
        terminal_name = "task_main_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    if params ~= nil and params._datas ~= nil and params._datas.page ~= nil then
        self:changeSelectPage(tonumber(params.page))
    else
        self:changeSelectPage(1)
    end
end

function Task:init(params)
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function Task:onResume( ... )
    -- body
end

function Task:onExit()
    state_machine.remove("task_main_change_page")
    state_machine.remove("task_main_update_task_state")
    state_machine.remove("task_window_close_check")
end

function Task:close()
    if missionIsOver() == true then
        fwin:close(fwin:find("TuitionControllerClass"))
    end
end