--[[ ----------------------------------------------------------------------------
-- 单笔充值独立界面
--]] ----------------------------------------------------------------------------
ActivitySingleRecharge = class("ActivitySingleRechargeClass", Window)

-- 打开窗口
local activity_single_recharge_window_open_terminal = {
	_name = "activity_single_recharge_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivitySingleRechargeClass") then
			fwin:open(ActivitySingleRecharge:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_single_recharge_window_close_terminal = {
	_name = "activity_single_recharge_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivitySingleRechargeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_single_recharge_window_open_terminal)
state_machine.add(activity_single_recharge_window_close_terminal)
state_machine.init()

-- 构造器
function ActivitySingleRecharge:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._tick_time = 0

	-- load lua files.
	app.load("client.activity.wonderful.ActivitySingleRechargeCell")

	-- Initialize activity single recharge page state machine.
	local function init_activity_single_recharge_terminal()
		-- 打开角色创建窗口
		local activity_single_recharge_open_terminal = {
			_name = "activity_single_recharge_open",
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
		local activity_single_recharge_close_terminal = {
			_name = "activity_single_recharge_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("activity_single_recharge_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local activity_single_recharge_show_terminal = {
			_name = "activity_single_recharge_show",
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
		local activity_single_recharge_hide_terminal = {
			_name = "activity_single_recharge_hide",
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

		-- 刷新界面
		local activity_single_recharge_refresh_terminal = {
			_name = "activity_single_recharge_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(activity_single_recharge_refresh_terminal)
		state_machine.add(activity_single_recharge_open_terminal)
		state_machine.add(activity_single_recharge_close_terminal)
		state_machine.add(activity_single_recharge_show_terminal)
		state_machine.add(activity_single_recharge_hide_terminal)
		state_machine.init()
	end
	-- call func init activity single recharge state machine.
	init_activity_single_recharge_terminal()
end

-- 对象初始化
function ActivitySingleRecharge:init(params)
	self.actType = params
	return self
end

function ActivitySingleRecharge:updateRechargeList()
	self.Text_45:setString(tipStringInfo_daily_once_recharge_tips[1])
	self.Text_45_1:setString(tipStringInfo_daily_once_recharge_tips[2])

	local activity_info = _ED.active_activity[self.actType]
	local activity_params = zstring.splits(activity_info.activity_params, "|", ",")
	local result = {}
	for i, v in ipairs(activity_info.activity_Info) do
		table.insert(result, v)
	end
	
	local closeItems = {}       -- 已完成
	local drawItems = {}            -- 可领取
	local uncompItems = {}      -- 未完成
	for k, v in ipairs(result) do
		local maxCompNum = zstring.split(v.activityInfo_need_day, ",")[2]
		if tonumber(maxCompNum) <= tonumber(activity_params[k][2]) then
			v.state = 2
			table.insert(closeItems, v)
		else
		if tonumber(activity_params[k][1]) > tonumber(activity_params[k][2]) then
			table.insert(drawItems, v)
			v.state = 1
		else
			table.insert(uncompItems, v)
			v.state = 0
		end
	end
		v.curRecharge = tonumber(activity_params[k][1])
		v.curGetReward = tonumber(activity_params[k][2])
	end

	result = {}
	for k, v in pairs(drawItems) do
		table.insert(result, v)
	end
	for k, v in pairs(uncompItems) do
		table.insert(result, v)
	end
	for k, v in pairs(closeItems) do
		table.insert(result, v)
	end

	self.ListView_1:removeAllItems()
	for k, v in ipairs(result) do
		local cell = state_machine.excute("activity_single_recharge_cell_create", 0, {v, self.actType})
		self.ListView_1:addChild(cell)
	end
	self.ListView_1:requestRefreshView()

	self._tick_time = (tonumber(activity_info.end_time) - (os.time() + _ED.time_add_or_sub) * 1000) / 1000
end

function ActivitySingleRecharge:onUpdateDraw()
	local root = self.roots[1]

	-- 单笔充值列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 倒计时
	self.Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")

	-- 说明1
	self.Text_45 = ccui.Helper:seekWidgetByName(root, "Text_45")

	-- 说明2
	self.Text_45_1 = ccui.Helper:seekWidgetByName(root, "Text_45_1")

	self:updateRechargeList()
end

function ActivitySingleRecharge:onUpdate(dt)
    if self.Text_32 ~= nil and self._tick_time > 0 then 
        self._tick_time = self._tick_time - dt
        self.Text_32:setString(getRedAlertTimeActivityFormat(self._tick_time))
        -- if self._tick_time <= 0 then
        --     self._tick_time = nil
        -- end
    end
end

function ActivitySingleRecharge:onEnterTransitionFinish()
	-- 加载ActivitySingleRechargeWindow界面资源.
	-- res.activity.wonderful.sm_discount_package = res/activity/wonderful/sm_discount_package.csb
	local csbNode = csb.createNode("activity/wonderful/sm_discount_package.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "activity_single_recharge_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ActivitySingleRecharge:onExit()
	-- 释放ActivitySingleRechargeWindow界面资源.
	state_machine.remove("activity_single_recharge_open")
	state_machine.remove("activity_single_recharge_close")
	state_machine.remove("activity_single_recharge_show")
	state_machine.remove("activity_single_recharge_hide")
	state_machine.remove("activity_single_recharge_refresh")
end

function ActivitySingleRecharge:close()
	-- window event : close.
	
end

function ActivitySingleRecharge:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
