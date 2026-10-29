-----------------------------
--愚你同乐
-----------------------------
RedAlertTimeAprilFoolsHappy = class("RedAlertTimeAprilFoolsHappyClass", Window)

local red_alert_time_april_fools_happy_window_open_terminal = {
    _name = "red_alert_time_april_fools_happy_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeAprilFoolsHappyClass") then
            fwin:open(RedAlertTimeAprilFoolsHappy:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_april_fools_happy_window_close_terminal = {
    _name = "red_alert_time_april_fools_happy_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeAprilFoolsHappyClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_april_fools_happy_window_open_terminal)
state_machine.add(red_alert_time_april_fools_happy_window_close_terminal)
state_machine.init()

function RedAlertTimeAprilFoolsHappy:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0
    self._collection_panel = nil
    self._exchange_panel = nil
    self.m_times = 0

    --load lua file
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeAprilFoolsHappyCollection")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeAprilFoolsHappyExchange")
    -- Initialize red_alert_time_april_fools_happy state machine.
    local function init_red_alert_time_april_fools_happy_terminal()
        -- 切换界面
        local red_alert_time_april_fools_happy_change_page_terminal = {
            _name = "red_alert_time_april_fools_happy_change_page",
            _init = function (terminal) 
            end,
            _inited = false,
              _instance = self,
            _tate = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_april_fools_happy_change_page_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_april_fools_happy state machine.
    init_red_alert_time_april_fools_happy_terminal()
end

function RedAlertTimeAprilFoolsHappy:onUpdateDraw()
    local root = self.roots[1]

    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")

    local Text_recharge_bonus_name = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_name")
    Text_recharge_bonus_name:setString(self._activity_type.activity_title)

    -- 结束和关闭倒计时
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
end

function RedAlertTimeAprilFoolsHappy:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_funding_aggregation_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_funding_aggregation_tab_box")
    local Button_brothers_activty = ccui.Helper:seekWidgetByName(root, "Button_brothers_activty")
    local Button_brothers_package = ccui.Helper:seekWidgetByName(root, "Button_brothers_package")
    if page == self._current_page then
        if page == 1 then
            Button_brothers_activty:setHighlighted(true)
        elseif page == 2 then
            Button_brothers_package:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_brothers_activty:setHighlighted(false)
    Button_brothers_package:setHighlighted(false)
    state_machine.excute("red_alert_time_april_fools_happy_collection_hide", 0, nil)
    state_machine.excute("red_alert_time_april_fools_happy_exchange_hide", 0, nil)
    if page == 1 then
        Button_brothers_activty:setHighlighted(true)
        if self._collection_panel == nil then
            self._collection_panel = state_machine.excute("red_alert_time_april_fools_happy_collection_open", 0, {Panel_funding_aggregation_tab_box,self._activity_type.activity_type})
        else
            state_machine.excute("red_alert_time_april_fools_happy_collection_show", 0, nil)
        end
    elseif page == 2 then
        Button_brothers_package:setHighlighted(true)
        if self._exchange_panel == nil then
            self._exchange_panel = state_machine.excute("red_alert_time_april_fools_happy_exchange_open", 0, {Panel_funding_aggregation_tab_box,self._activity_type.activity_type})
        else
            state_machine.excute("red_alert_time_april_fools_happy_exchange_show", 0, nil)
        end
    end

    self:onUpdateDraw()
end

function RedAlertTimeAprilFoolsHappy:onEnterTransitionFinish()

end

function RedAlertTimeAprilFoolsHappy:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.april_fools_happy)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_close"), nil, 
    {
        terminal_name = "red_alert_time_april_fools_happy_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    -- 收集
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_brothers_activty"), nil, 
    {
        terminal_name = "red_alert_time_april_fools_happy_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    -- 兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_brothers_package"), nil, 
    {
        terminal_name = "red_alert_time_april_fools_happy_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    self:changeSelectPage(1)
end

function RedAlertTimeAprilFoolsHappy:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times < 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_april_fools_happy_window_close")
        end
    end
end

function RedAlertTimeAprilFoolsHappy:init(params)
    self._activity_type = params[1]
    self:onInit()
    return self
end

function RedAlertTimeAprilFoolsHappy:onExit()
    state_machine.remove("red_alert_time_april_fools_happy_change_page")
    state_machine.remove("red_alert_time_april_fools_happy_rule_open")
end
