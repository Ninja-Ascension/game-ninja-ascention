-----------------------------
--消费转盘
-----------------------------
RedAlertTimeConsumptionTurntable = class("RedAlertTimeConsumptionTurntableClass", Window)

local red_alert_time_consumption_turntable_window_open_terminal = {
    _name = "red_alert_time_consumption_turntable_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeConsumptionTurntableClass") then
			fwin:open(RedAlertTimeConsumptionTurntable:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_consumption_turntable_window_close_terminal = {
    _name = "red_alert_time_consumption_turntable_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeConsumptionTurntableClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_consumption_turntable_window_open_terminal)
state_machine.add(red_alert_time_consumption_turntable_window_close_terminal)
state_machine.init()

function RedAlertTimeConsumptionTurntable:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0
    self._turntable_panel = nil
    self._rank_panel = nil
    self._reward_panel = nil
    self._rule_panel = nil
    self.m_times = 0
    --load lua file
    -- Initialize red_alert_time_consumption_turntable state machine.
    local function init_red_alert_time_consumption_turntable_terminal()
    
        -- 切换界面
        local red_alert_time_consumption_turntable_change_page_terminal = {
          _name = "red_alert_time_consumption_turntable_change_page",
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
        state_machine.add(red_alert_time_consumption_turntable_change_page_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_consumption_turntable state machine.
    init_red_alert_time_consumption_turntable_terminal()
end


function RedAlertTimeConsumptionTurntable:changeSelectPage( page )
    local root = self.roots[1]
    local Text_consumption_turntable_title = ccui.Helper:seekWidgetByName(root,"Text_consumption_turntable_title")
    Text_consumption_turntable_title:setString(self._activity_type.activity_title)
    local Panel_consumption_turntable_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_consumption_turntable_tab_box")
    local Button_consumption_turntable = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable")
    local Button_consumption_turntable_rank = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rank")
    local Button_consumption_turntable_reward = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_reward")
    local Button_consumption_turntable_rule = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rule")
    if page == self._current_page then
        if page == 1 then
            Button_consumption_turntable:setHighlighted(true)
        elseif page == 2 then
            Button_consumption_turntable_rank:setHighlighted(true)
        elseif page == 3 then
            Button_consumption_turntable_reward:setHighlighted(true)
        else
            Button_consumption_turntable_rule:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_consumption_turntable:setHighlighted(false)
    Button_consumption_turntable_rank:setHighlighted(false)
    Button_consumption_turntable_reward:setHighlighted(false)
    Button_consumption_turntable_rule:setHighlighted(false)
    state_machine.excute("red_alert_time_consumption_turntable_hide", 0, nil)
    state_machine.excute("red_alert_time_consumption_turntable_rank_hide", 0, nil)
    state_machine.excute("red_alert_time_consumption_turntable_reward_hide", 0, nil)
    state_machine.excute("red_alert_time_consumption_turntable_rule_hide", 0, nil)
    if page == 1 then
        Button_consumption_turntable:setHighlighted(true)
        if self._turntable_panel == nil then
            self._turntable_panel = state_machine.excute("red_alert_time_consumption_turntable_open", 0, {Panel_consumption_turntable_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_consumption_turntable_show", 0, nil)
        end
    elseif page == 2 then
        Button_consumption_turntable_rank:setHighlighted(true)
        if self._rank_panel == nil then
            self._rank_panel = state_machine.excute("red_alert_time_consumption_turntable_rank_open", 0, {Panel_consumption_turntable_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_consumption_turntable_rank_show", 0, nil)
        end
    elseif page == 3 then
        Button_consumption_turntable_reward:setHighlighted(true)
        if self._reward_panel == nil then
            self._reward_panel = state_machine.excute("red_alert_time_consumption_turntable_reward_open", 0, {Panel_consumption_turntable_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_consumption_turntable_reward_show", 0, nil)
        end
    else
        Button_consumption_turntable_rule:setHighlighted(true)
        if self._rule_panel == nil then
            self._rule_panel = state_machine.excute("red_alert_time_consumption_turntable_rule_open", 0, {Panel_consumption_turntable_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_consumption_turntable_rule_show", 0, nil)
        end
    end
end

function RedAlertTimeConsumptionTurntable:onEnterTransitionFinish()

end

function RedAlertTimeConsumptionTurntable:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.consumption_turntable)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_consumption_turntable_close"), nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable"), nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rank"), nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_reward"), nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_consumption_turntable",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_reward"),
    _invoke = nil,
    _interval = 0.3,})


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_turntable_rule"), nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)
	
    protocol_command.draw_activity_reward.param_list = self._activity_type.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, nil, false, nil)  

    -- if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
    --     self:changeSelectPage(tonumber(params._datas._page))
    -- else
        self:changeSelectPage(1)
    -- end
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
end

function RedAlertTimeConsumptionTurntable:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt

        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_consumption_turntable_close")
            -- state_machine.excute("red_alert_time_funding_aggregation_window_close",0,self._activity_type.activity_type)
        end
    end
end

function RedAlertTimeConsumptionTurntable:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeConsumptionTurntable:onExit()
    state_machine.remove("red_alert_time_consumption_turntable_change_page")
end
