-----------------------------
--兄弟同享
-----------------------------
RedAlertTimeBrothersShare = class("RedAlertTimeBrothersShareClass", Window)

local red_alert_time_brothers_share_window_open_terminal = {
    _name = "red_alert_time_brothers_share_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeBrothersShareClass") then
			fwin:open(RedAlertTimeBrothersShare:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_brothers_share_window_close_terminal = {
    _name = "red_alert_time_brothers_share_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeBrothersShareClass"))
        state_machine.excute("red_alert_time_center_update_push", 0, 58)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_brothers_share_window_open_terminal)
state_machine.add(red_alert_time_brothers_share_window_close_terminal)
state_machine.init()

function RedAlertTimeBrothersShare:ctor()
    self.super:ctor()
    self.roots = {}
	self.activityInfo = nil
	self._current_page = 0
    self._activty = nil
    self._package = nil

    self.m_times = 0
	
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeBrothersActivty")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeBrothersPackage")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
	
    -- Initialize red_alert_time_brothers_share state machine.
    local function init_red_alert_time_brothers_share_terminal()
		  local red_alert_time_brothers_share_change_page_terminal = {
            _name = "red_alert_time_brothers_share_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(params._datas._page) == 2 then
                    if _ED.union.union_info == nil 
                        or _ED.union.union_info == {} 
                        or _ED.union.union_info.union_id == nil 
                        or _ED.union.union_info.union_id == "" 
                        or tonumber(_ED.union.union_info.union_id) == 0 
                        then
                            TipDlg.drawTextDailog(red_alert_time_str[158])
                            return
                    end
                end
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_brothers_share_change_page_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_brothers_share state machine.
    init_red_alert_time_brothers_share_terminal()
end

function RedAlertTimeBrothersShare:changeSelectPage( page )
	-- debug.print_r(self.activityInfo)
	local root = self.roots[1]
	local Panel_brothers_share_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_brothers_share_tab_box")
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
	state_machine.excute("red_alert_time_brothers_activty_hide", 0, nil)
    state_machine.excute("red_alert_time_brothers_package_hide", 0, nil)
	 if page == 1 then
        Button_brothers_activty:setHighlighted(true)
        if self._activty == nil then
            self._activty = state_machine.excute("red_alert_time_brothers_activty_window_open", 0, {Panel_brothers_share_tab_box,self.activityInfo})
        else
            state_machine.excute("red_alert_time_brothers_activty_show", 0, nil)
        end
	elseif page == 2 then      
		Button_brothers_package:setHighlighted(true)
		if self._package == nil then
            self._package = state_machine.excute("red_alert_time_brothers_package_window_open", 0, {Panel_brothers_share_tab_box,self.activityInfo})
        else
            state_machine.excute("red_alert_time_brothers_package_show", 0, nil)
        end
	end
end

function RedAlertTimeBrothersShare:onUpdateDraw()
    local root = self.roots[1]
    --标题
    ccui.Helper:seekWidgetByName(root,"Text_brothers_share_tit"):setString(self.activityInfo[1].activity_title)
    
    local timesData = zstring.split(self.activityInfo[1].activity_add_state, ",")
	self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
end

function RedAlertTimeBrothersShare:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt

        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_brothers_share_window_close")
        end
    end
end

function RedAlertTimeBrothersShare:onEnterTransitionFinish()

end

function RedAlertTimeBrothersShare:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.brothers_share)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_brothers_share_close"), nil, 
    {
        terminal_name = "red_alert_time_brothers_share_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
	--活动
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_brothers_activty"), nil, 
    {
        terminal_name = "red_alert_time_brothers_share_change_page", 
        terminal_state = 0,
		_page = 1,
    }, nil, 1)
	--礼包
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_brothers_package"), nil, 
    {
        terminal_name = "red_alert_time_brothers_share_change_page", 
        terminal_state = 0,
		_page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_brothers_personal",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_brothers_package"),
    _m_type = 3,
    _invoke = nil,
    _interval = 0.3,})
    
	self:changeSelectPage(1)
    self:onUpdateDraw()
end

function RedAlertTimeBrothersShare:init(params)
	self.activityInfo = params
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function RedAlertTimeBrothersShare:onExit()
    state_machine.remove("red_alert_time_brothers_share_change_page")
end
