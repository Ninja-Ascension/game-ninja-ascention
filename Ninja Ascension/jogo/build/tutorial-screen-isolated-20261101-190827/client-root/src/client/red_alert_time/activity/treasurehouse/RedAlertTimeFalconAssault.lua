-----------------------------
-- 猎鹰突击
-----------------------------
RedAlertTimeFalconAssault = class("RedAlertTimeFalconAssaultClass", Window)

local red_alert_time_falcon_assault_window_open_terminal = {
    _name = "red_alert_time_falcon_assault_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeFalconAssaultClass") then
            local panel = RedAlertTimeFalconAssault:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_falcon_assault_window_close_terminal = {
    _name = "red_alert_time_falcon_assault_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("RedAlertTimeFalconAssaultClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_falcon_assault_window_open_terminal)
state_machine.add(red_alert_time_falcon_assault_window_close_terminal)
state_machine.init()

function RedAlertTimeFalconAssault:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._current_page = 0

    self._collotion_panel = nil
    self._reform_panel = nil

    self._activity_info = nil
    self._activity_type = 0

    self.m_times = 0

    -- 加载lua文件
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFalconAssaultCollotion")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFalconAssaultReform")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorOnce")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorTen")

    -- 初始化状态机
    local function init_red_alert_time_falcon_assault_terminal()
        -- 刷新
        local red_alert_time_falcon_assault_update_draw_terminal = {
            _name = "red_alert_time_falcon_assault_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                state_machine.excute("red_alert_time_falcon_assault_collotion_update_draw", 0, "")
                state_machine.excute("red_alert_time_falcon_assault_reform_update_draw`", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local red_alert_time_falcon_assault_change_page_terminal = {
            _name = "red_alert_time_falcon_assault_change_page",
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

        local red_alert_time_falcon_assault_get_rule_terminal = {
            _name = "red_alert_time_falcon_assault_get_rule",
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
        
        state_machine.add(red_alert_time_falcon_assault_update_draw_terminal)
        state_machine.add(red_alert_time_falcon_assault_change_page_terminal)
        state_machine.add(red_alert_time_falcon_assault_get_rule_terminal)
        state_machine.init()
    end
    init_red_alert_time_falcon_assault_terminal()
end

-- 切换页面
function RedAlertTimeFalconAssault:changeSelectPage( page )
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
    state_machine.excute("red_alert_time_falcon_assault_collotion_hide", 0, nil)
    state_machine.excute("red_alert_time_falcon_assault_reform_hide", 0, nil)
    if page == 1 then
        Button_festival_each_child:setHighlighted(true)
        if self._collotion_panel == nil then
            self._collotion_panel = state_machine.excute("red_alert_time_falcon_assault_collotion_open", 0, {Panel_festival_each_child_tab_box, self._activity_type})
        else
            state_machine.excute("red_alert_time_falcon_assault_collotion_show", 0, nil)
        end
    elseif page == 2 then
        Button_festival_blessing:setHighlighted(true)
        if self._reform_panel == nil then
            self._reform_panel = state_machine.excute("red_alert_time_falcon_assault_reform_open", 0, {Panel_festival_each_child_tab_box, self._activity_type})
        else
            state_machine.excute("red_alert_time_falcon_assault_reform_show", 0, nil)
        end
    end

    self:onUpdateDraw()
end

-- 刷新界面
function RedAlertTimeFalconAssault:onUpdateDraw()
    local root = self.roots[1]
    
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")

    -- 名称
    local Text_festival_each_child_tit = ccui.Helper:seekWidgetByName(root,"Text_festival_each_child_tit")
    Text_festival_each_child_tit:setString(activity_info.activity_title)

    -- 结束时间
    self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)
end

function RedAlertTimeFalconAssault:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("notification_center_update", 0, "red_alert_time_falcon_assault_window_close")
        end
    end
end

function RedAlertTimeFalconAssault:onEnterTransitionFinish()

end

function RedAlertTimeFalconAssault:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.falcon_assault) 
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_festival_each_child_close"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_each_child"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_blessing"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    self:changeSelectPage(1)
end

function RedAlertTimeFalconAssault:init(params)
    self._activity_info = params[1]
    self._activity_type = tonumber(self._activity_info.activity_type)
    self:onInit()
    return self
end

function RedAlertTimeFalconAssault:onExit()
    -- 移除状态机
    state_machine.remove("red_alert_time_falcon_assault_update_draw")
    state_machine.remove("red_alert_time_falcon_assault_change_page")
    state_machine.remove("red_alert_time_falcon_assault_get_rule")
end
