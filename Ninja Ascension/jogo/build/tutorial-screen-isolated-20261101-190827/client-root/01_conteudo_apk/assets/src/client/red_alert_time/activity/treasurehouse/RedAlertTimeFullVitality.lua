-----------------------------
--火力全开
-----------------------------
RedAlertTimeFullVitality = class("RedAlertTimeFullVitalityClass", Window)

local red_alert_time_full_vitality_window_open_terminal = {
    _name = "red_alert_time_full_vitality_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeFullVitalityClass") then
            fwin:open(RedAlertTimeFullVitality:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_full_vitality_window_close_terminal = {
    _name = "red_alert_time_full_vitality_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.show_reward_list_group_ex = {}
        fwin:close(fwin:find("RedAlertTimeFullVitalityClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_full_vitality_window_open_terminal)
state_machine.add(red_alert_time_full_vitality_window_close_terminal)
state_machine.init()

function RedAlertTimeFullVitality:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0
    self._turntable_panel = nil
    self._rank_panel = nil
    self._reward_panel = nil
    self._rule_panel = nil
    self.m_times = 0
    
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecretRank")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecretReward")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFullVitalityTransfer")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecretRule")
    
    local function init_red_alert_time_full_vitality_terminal()
    
        -- 切换界面
        local red_alert_time_full_vitality_change_page_terminal = {
          _name = "red_alert_time_full_vitality_change_page",
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
        state_machine.add(red_alert_time_full_vitality_change_page_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_full_vitality state machine.
    init_red_alert_time_full_vitality_terminal()
end


function RedAlertTimeFullVitality:changeSelectPage( page )
    local root = self.roots[1]
    -- 标题
    ccui.Helper:seekWidgetByName(root, "Text_full_vitality_title"):setString(self._activity_type.activity_title)
    
    local Panel_full_vitality_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_full_vitality_tab_box")
    local Button_full_vitality = ccui.Helper:seekWidgetByName(root, "Button_full_vitality")
    local Button_full_vitality_rule = ccui.Helper:seekWidgetByName(root, "Button_full_vitality_rule")
    local Button_full_vitality_rank = ccui.Helper:seekWidgetByName(root, "Button_full_vitality_rank")
    local Button_full_vitality_reward = ccui.Helper:seekWidgetByName(root, "Button_full_vitality_reward")
    if page == self._current_page then
        if page == 1 then
            Button_full_vitality:setHighlighted(true)
        elseif page == 2 then
            Button_full_vitality_rule:setHighlighted(true)
        elseif page == 3 then
            Button_full_vitality_rank:setHighlighted(true)
        else
            Button_full_vitality_reward:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_full_vitality:setHighlighted(false)
    Button_full_vitality_rule:setHighlighted(false)
    Button_full_vitality_rank:setHighlighted(false)
    Button_full_vitality_reward:setHighlighted(false)
    state_machine.excute("red_alert_time_full_vitality_transfer_hide", 0, nil)
    state_machine.excute("red_alert_time_secret_rank_hide", 0, nil)
    state_machine.excute("red_alert_time_secret_reward_hide", 0, nil)
    state_machine.excute("red_alert_time_secret_rule_hide", 0, nil)
    if page == 1 then
        Button_full_vitality:setHighlighted(true)
        if self._turntable_panel == nil then
            self._turntable_panel = state_machine.excute("red_alert_time_full_vitality_transfer_open", 0, {Panel_full_vitality_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_full_vitality_transfer_show", 0, nil)
        end
    elseif page == 2 then
        Button_full_vitality_rule:setHighlighted(true)
        if self._rank_panel == nil then
            self._rank_panel = state_machine.excute("red_alert_time_secret_rank_open", 0, {Panel_full_vitality_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_secret_rank_show", 0, nil)
        end
    elseif page == 3 then
        Button_full_vitality_rank:setHighlighted(true)
        if self._reward_panel == nil then
            self._reward_panel = state_machine.excute("red_alert_time_secret_reward_open", 0, {Panel_full_vitality_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_secret_reward_show", 0, nil)
        end
    else
        Button_full_vitality_reward:setHighlighted(true)
        if self._rule_panel == nil then
            self._rule_panel = state_machine.excute("red_alert_time_secret_rule_open", 0, {Panel_full_vitality_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_secret_rule_show", 0, nil)
        end
    end
end

function RedAlertTimeFullVitality:onEnterTransitionFinish()

end

function RedAlertTimeFullVitality:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.full_vitality)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_full_vitality_close"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_full_vitality"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_treasurehouse_full_vitality_get_reward",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_full_vitality"),
        _invoke = nil,
        _interval = 0.3,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_full_vitality_rule"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_full_vitality_rank"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_treasurehouse_full_vitality_rank",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_full_vitality_rank"),
        _invoke = nil,
        _interval = 0.3,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_full_vitality_reward"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)
    
    self:changeSelectPage(1)

    local timesData = zstring.split(self._activity_type.activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
end

function RedAlertTimeFullVitality:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt

        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_full_vitality_window_close")
        end
    end
end


function RedAlertTimeFullVitality:init(params)
    self._activity_type = params[1]
    self:onInit()
    return self
end

function RedAlertTimeFullVitality:onExit()
    state_machine.remove("red_alert_time_full_vitality_change_page")
end
