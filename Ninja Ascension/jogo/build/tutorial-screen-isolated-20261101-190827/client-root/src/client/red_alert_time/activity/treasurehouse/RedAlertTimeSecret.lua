-----------------------------
--科威特的秘密
-----------------------------
RedAlertTimeSecret = class("RedAlertTimeSecretClass", Window)

local red_alert_time_secret_window_open_terminal = {
    _name = "red_alert_time_secret_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeSecretClass") then
			fwin:open(RedAlertTimeSecret:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_secret_window_close_terminal = {
    _name = "red_alert_time_secret_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.show_reward_list_group_ex = {}
        fwin:close(fwin:find("RedAlertTimeSecretClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_secret_window_open_terminal)
state_machine.add(red_alert_time_secret_window_close_terminal)
state_machine.init()

function RedAlertTimeSecret:ctor()
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
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecretTransfer")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecretRule")
	app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seek_treasure_rank_cell")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecretGet")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecretGetTen")
	
    --load lua file
    -- Initialize red_alert_time_secret state machine.
    local function init_red_alert_time_secret_terminal()
    
        -- 切换界面
        local red_alert_time_secret_change_page_terminal = {
          _name = "red_alert_time_secret_change_page",
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
        state_machine.add(red_alert_time_secret_change_page_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_secret state machine.
    init_red_alert_time_secret_terminal()
end


function RedAlertTimeSecret:changeSelectPage( page )
    local root = self.roots[1]
    --标题
    ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_title"):setString(self._activity_type.activity_title)
    local Panel_seek_treasure_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_seek_treasure_tab_box")
    local Button_seek_treasure = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure")
    local Button_seek_treasure_rule = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rule")
    local Button_seek_treasure_rank = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rank")
    local Button_seek_treasure_reward = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_reward")
    if page == self._current_page then
        if page == 1 then
            Button_seek_treasure:setHighlighted(true)
        elseif page == 2 then
            Button_seek_treasure_rule:setHighlighted(true)
        elseif page == 3 then
            Button_seek_treasure_rank:setHighlighted(true)
        else
            Button_seek_treasure_reward:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_seek_treasure:setHighlighted(false)
    Button_seek_treasure_rule:setHighlighted(false)
    Button_seek_treasure_rank:setHighlighted(false)
    Button_seek_treasure_reward:setHighlighted(false)
    state_machine.excute("red_alert_time_secret_transfer_hide", 0, nil)
    state_machine.excute("red_alert_time_secret_rank_hide", 0, nil)
    state_machine.excute("red_alert_time_secret_reward_hide", 0, nil)
    state_machine.excute("red_alert_time_secret_rule_hide", 0, nil)
    if page == 1 then
        Button_seek_treasure:setHighlighted(true)
        if self._turntable_panel == nil then
            self._turntable_panel = state_machine.excute("red_alert_time_secret_transfer_open", 0, {Panel_seek_treasure_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_secret_transfer_show", 0, nil)
        end
    elseif page == 2 then
        Button_seek_treasure_rule:setHighlighted(true)
        if self._rank_panel == nil then
            self._rank_panel = state_machine.excute("red_alert_time_secret_rank_open", 0, {Panel_seek_treasure_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_secret_rank_show", 0, nil)
        end
    elseif page == 3 then
        Button_seek_treasure_rank:setHighlighted(true)
        if self._reward_panel == nil then
            self._reward_panel = state_machine.excute("red_alert_time_secret_reward_open", 0, {Panel_seek_treasure_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_secret_reward_show", 0, nil)
        end
    else
        Button_seek_treasure_reward:setHighlighted(true)
        if self._rule_panel == nil then
            self._rule_panel = state_machine.excute("red_alert_time_secret_rule_open", 0, {Panel_seek_treasure_tab_box,self._activity_type})
        else
            state_machine.excute("red_alert_time_secret_rule_show", 0, nil)
        end
    end
end

function RedAlertTimeSecret:onEnterTransitionFinish()

end

function RedAlertTimeSecret:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_seek_treasure_close"), nil, 
    {
        terminal_name = "red_alert_time_secret_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure"), nil, 
    {
        terminal_name = "red_alert_time_secret_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rule"), nil, 
    {
        terminal_name = "red_alert_time_secret_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rank"), nil, 
    {
        terminal_name = "red_alert_time_secret_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seek_treasure",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rank"),
    _invoke = nil,
    _interval = 0.3,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_reward"), nil, 
    {
        terminal_name = "red_alert_time_secret_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)
	
    -- if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
    --     self:changeSelectPage(tonumber(params._datas._page))
    -- else
        self:changeSelectPage(1)
    -- end
    local timesData = zstring.split(self._activity_type.activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

end

function RedAlertTimeSecret:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt

        if self.m_times <= 0 then
            self.m_times = 0
            -- print("科威特的秘密")
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_secret_window_close")
            -- state_machine.excute("red_alert_time_secret_window_close",0,self._activity_type.activity_type)
        end
    end
end


function RedAlertTimeSecret:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeSecret:onExit()
    state_machine.remove("red_alert_time_secret_change_page")
end
