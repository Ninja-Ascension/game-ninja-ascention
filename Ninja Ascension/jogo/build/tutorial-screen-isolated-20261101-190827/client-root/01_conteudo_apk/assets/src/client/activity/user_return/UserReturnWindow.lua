--[[ ----------------------------------------------------------------------------
-- 老用户回归主界面
--]] ----------------------------------------------------------------------------
UserReturnWindow = class("UserReturnWindowClass", Window)

-- 打开窗口
local user_return_window_open_terminal = {
	_name = "user_return_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("UserReturnWindowClass") then
			fwin:open(UserReturnWindow:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local user_return_window_close_terminal = {
	_name = "user_return_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		-- TOD0: 跳转老用户七天乐
		if _ED.active_activity[164] and _ED.user_return_open_datas and 1 == _ED.user_return_open_datas.open_flag and not _ED.seven_day_regression_flag then
			app.load("client.activity.sevendaysregression.SevenHappyRegressionManager")
			state_machine.excute("seven_happy_regression_manager_open",0,"")
		end
		_ED.seven_day_regression_flag = true
		fwin:close(fwin:find("UserReturnWindowClass"))
		
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(user_return_window_open_terminal)
state_machine.add(user_return_window_close_terminal)
state_machine.init()

-- 构造器
function UserReturnWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._current_page = 0			-- 当前页面
	self.Text_time = nil
	-- load lua files.
	app.load("client.activity.user_return.UserReturnMainTab1")
	app.load("client.activity.user_return.UserReturnMainTab2")
	app.load("client.activity.user_return.UserReturnMainTab3")
	app.load("client.activity.user_return.UserReturnRule")
	-- Initialize user return window page state machine.
	local function init_user_return_window_terminal()
		-- 打开角色创建窗口
		local user_return_open_terminal = {
			_name = "user_return_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local user_return_close_terminal = {
			_name = "user_return_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:close(fwin:find("UserReturnWindowClass"))
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local user_return_window_show_terminal = {
			_name = "user_return_window_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local user_return_window_hide_terminal = {
			_name = "user_return_window_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 切换页签
		local user_return_window_change_page_terminal = {
			_name = "user_return_window_change_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:changeToPage(params._datas.m_type)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新红点
		local user_return_window_refresh_red_tip_terminal = {
			_name = "user_return_window_refresh_red_tip",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then
					fwin:addService({
						callback = function ( params )
							state_machine.excute("notification_center_update", 0, "push_notification_user_return_page_push")
							state_machine.excute("notification_center_update", 0, "push_notification_user_return_page_push")
						end,
						delay = 0,
					})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(user_return_open_terminal)
		state_machine.add(user_return_close_terminal)
		state_machine.add(user_return_window_show_terminal)
		state_machine.add(user_return_window_hide_terminal)
		state_machine.add(user_return_window_change_page_terminal)
		state_machine.add(user_return_window_refresh_red_tip_terminal)
		state_machine.init()
	end
	-- call func init user return window state machine.
	init_user_return_window_terminal()
end

-- 对象初始化
function UserReturnWindow:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function UserReturnWindow:onUpdateDraw()
	local root = self.roots[1]

	-- 活动分页容器列表
	self.PageView_wdf_1 = ccui.Helper:seekWidgetByName(root, "PageView_wdf_1")

	-- 活动分页容器
	self.Panel_page_act = ccui.Helper:seekWidgetByName(root, "Panel_page_act")

	-- 左侧分页按钮列表
	self.ListView_wonder_btn = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	
	-- 时间
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	
	self:changeToPage(1)
	self:pushRedTip()
end

function UserReturnWindow:changeToPage(page)
	if page == self._current_page then
        if page == 1 then
            self.Button_hgfl:setHighlighted(true)
        elseif page == 2 then
            self.Button_czhglb:setHighlighted(true)
        elseif page == 3 then
            self.Button_zddfl:setHighlighted(true)
        end
        return
    end
	self._current_page = page
	self.Button_hgfl:setHighlighted(false)
	self.Button_czhglb:setHighlighted(false)
	self.Button_zddfl:setHighlighted(false)
	state_machine.excute("user_return_main_tab1_hide", 0, "")
    state_machine.excute("user_return_main_tab2_hide", 0, "")
    state_machine.excute("user_return_main_tab3_hide", 0, "")

	if 1 == page then
		self.Button_hgfl:setHighlighted(true)
		if self._gift then
			state_machine.excute("user_return_main_tab1_show",0,"")
		else
			self._gift = state_machine.excute("user_return_main_tab1_window_open", 0, {self.Panel_page_act})
		end
	elseif 2 == page then
		self.Button_czhglb:setHighlighted(true)
		if self._rechage then
			state_machine.excute("user_return_main_tab2_show",0,"")
		else
			self._rechage = state_machine.excute("user_return_main_tab2_window_open", 0, {self.Panel_page_act})
		end
	else
		self.Button_zddfl:setHighlighted(true)
		if self._sign then
			state_machine.excute("user_return_main_tab3_show",0,"")
		else
			self._sign = state_machine.excute("user_return_main_tab3_window_open", 0, {self.Panel_page_act})
		end
	end

end

function UserReturnWindow:onUpdate(dt)
	if self.Text_time == nil and nil == self.activity then
        return
    end

    local current = _ED.system_time + (os.time() - _ED.native_time)

    local activity = self.activity
    local surplus_time = activity.end_time / 1000 - current
    self.Text_time:setString(getRedAlertTimeActivityFormat(surplus_time))
end

function UserReturnWindow:pushRedTip()

	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_user_return_page_push",
            _widget = self.Button_hgfl,
            _invoke = nil,
            _pageIndex = 1,
			_interval = 0.5,})

	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_user_return_page_push",
	_widget = self.Button_czhglb,
	_invoke = nil,
	_pageIndex = 2,
	_interval = 0.5,})

	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_user_return_page_push",
            _widget = self.Button_zddfl,
            _invoke = nil,
            _pageIndex = 3,
            _interval = 0.5,})
end

function UserReturnWindow:onEnterTransitionFinish()
	-- 加载UserReturnWindowWindow界面资源.
	-- res.activity.user_return.user_return_main = res/activity/user_return/user_return_main.csb
	local csbNode = csb.createNode("activity/user_return/user_return_main.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 回归福利按钮
	self.Button_hgfl = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hgfl"), nil,
	{
		terminal_name = "user_return_window_change_page",
		terminal_state = 0,
		m_type = 1,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
			
	-- 超值回归礼包按钮
	self.Button_czhglb = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_czhglb"), nil,
	{
		terminal_name = "user_return_window_change_page",
		terminal_state = 0,
		m_type = 2,
		isPressedActionEnabled = true,
	}, nil, 0)
	

	-- 周登录福利按钮
	self.Button_zddfl = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zddfl"), nil,
	{
		terminal_name = "user_return_window_change_page",
		terminal_state = 0,
		m_type = 3,
		isPressedActionEnabled = true,
	}, nil, 0)	
	

	-- 老用户回归规则按钮
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "user_return_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_wonderful_back_pr1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wonderful_back"), nil,
	{
		terminal_name = "user_return_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.activity = _ED.active_activity[164]

	state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 164)

	self:onUpdateDraw()
end

function UserReturnWindow:onExit()
	-- 释放UserReturnWindowWindow界面资源.
	state_machine.remove("user_return_open")
	state_machine.remove("user_return_close")
	state_machine.remove("user_return_window_show")
	state_machine.remove("user_return_window_hide")
	state_machine.remove("user_return_window_change_page")
	state_machine.remove("user_return_window_refresh_red_tip")
end

function UserReturnWindow:close()
	-- window event : close.
	
end

function UserReturnWindow:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
