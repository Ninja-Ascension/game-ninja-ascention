--[[ ----------------------------------------------------------------------------
-- 私人订制主界面
--]] ----------------------------------------------------------------------------
PrivateCustom = class("PrivateCustomClass", Window)

-- 打开窗口
local private_custom_window_open_terminal = {
	_name = "private_custom_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("PrivateCustomClass") then
			fwin:open(PrivateCustom:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local private_custom_window_close_terminal = {
	_name = "private_custom_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("PrivateCustomClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(private_custom_window_open_terminal)
state_machine.add(private_custom_window_close_terminal)
state_machine.init()

-- 构造器
function PrivateCustom:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0

	
	-- 活动数据信息
	self._activityData = {}
	self._activityEndTime = nil
	self._privateCustomInfo = {}

	-- load lua files.
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")

	app.load("client.activity.private_custom.PrivateCustomFormation")
	app.load("client.activity.private_custom.privatecustomitem")
	app.load("client.activity.private_custom.privatecustomlist")
	app.load("client.activity.private_custom.PrivateCustomPrompt")

	-- Initialize private custom page state machine.
	local function init_private_custom_terminal()
		-- 打开角色创建窗口
		local private_custom_open_terminal = {
			_name = "private_custom_open",
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
		local private_custom_close_terminal = {
			_name = "private_custom_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("private_custom_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local private_custom_show_terminal = {
			_name = "private_custom_show",
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
		local private_custom_hide_terminal = {
			_name = "private_custom_hide",
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

		-- 跳转充值界面
		local private_custom_jump_recharge_terminal = {
			_name = "private_custom_jump_recharge",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("shortcut_open_recharge_window", 0, "")
				state_machine.excute("private_custom_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新主界面
		local private_custom_refesh_windows_terminal = {
			_name = "private_custom_refesh_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:onInit()
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(private_custom_open_terminal)
		state_machine.add(private_custom_close_terminal)
		state_machine.add(private_custom_show_terminal)
		state_machine.add(private_custom_hide_terminal)
		state_machine.add(private_custom_jump_recharge_terminal)
		state_machine.add(private_custom_refesh_windows_terminal)
		state_machine.init()
	end
	-- call func init private custom state machine.
	init_private_custom_terminal()
end

-- 对象初始化
function PrivateCustom:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function PrivateCustom:onInit(params)
	self._activityData = _ED.active_activity[170]

	self._privateCustomInfo = self._activityData.privateCustomInfo
	self._activityEndTime = self._activityData.end_time
end

function PrivateCustom:updateList()
	local sortInfo = self:getSortInfo()

	self.ListView_1:removeAllItems()
	for _, v in ipairs(sortInfo) do
		local cell = state_machine.excute("private_custom_list_create", 0, v)
		self.ListView_1:addChild(cell)
	end

	self.ListView_1:requestRefreshView()
end

function PrivateCustom:getSortInfo()
	local privateCustomInfo = self._privateCustomInfo

	local completeInfo = {}
	local incompleteInfo = {}
	local haveGotRewardInfo = {}

	for _, v in pairs(privateCustomInfo) do
		local state = tonumber(v.state)
		if state == 1 then
			table.insert(completeInfo, v)
		elseif state == 0 then
			table.insert(incompleteInfo, v)
		elseif state == 2 then
			table.insert(haveGotRewardInfo, v)
		end
	end

	-- 排序函数
	local function sortByRechargeCost(a, b)
		local gearA = tonumber(a.gear)
		local gearB = tonumber(b.gear)

		return gearA < gearB
	end

	table.sort(completeInfo, sortByRechargeCost)
	table.sort(incompleteInfo, sortByRechargeCost)
	table.sort(haveGotRewardInfo, sortByRechargeCost)

	local result = {}
	for _, v in ipairs(completeInfo) do
		table.insert(result, v)
	end

	for _, v in ipairs(incompleteInfo) do
		table.insert(result, v)
	end

	for _, v in ipairs(haveGotRewardInfo) do
		table.insert(result, v)
	end

	return result
end

function PrivateCustom:updateActivityRemainTime()
	if self.Text_32 == nil or self._activityEndTime == nil then
		return
	end
	local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_32:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function PrivateCustom:updateUI()
	self:updateActivityRemainTime()
	self:updateList()
end

function PrivateCustom:onUpdateDraw()
	local root = self.roots[1]

	-- 活动倒计时
	self.Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")

	-- 主页列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateUI()
end

function PrivateCustom:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateActivityRemainTime()
		self.totalTime = 0
	end
end

function PrivateCustom:drawTime(_time)
	local timeString = ""
	local _dayTime = math.floor((_time / 1000) / 86400)
	local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
	local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
	local _secondsTime = math.floor((_time / 1000) % 60)
	if _dayTime > 0 then
		timeString = timeString .. _dayTime .._string_piece_info[231]
	end
	if _hourTime < 10 then
		timeString = timeString .. "0".._hourTime ..":"
	else
		timeString = timeString .. _hourTime ..":"
	end

	if _minutesTime < 10 then
		timeString = timeString .. "0".._minutesTime ..":"
	else
		timeString = timeString .. _minutesTime ..":"
	end

	if _secondsTime < 10 then
		timeString = timeString .. "0".._secondsTime 
	else
		timeString = timeString .. _secondsTime 
	end
	return timeString
end

function PrivateCustom:onEnterTransitionFinish()
	-- 加载PrivateCustomWindow界面资源.
	-- res.activity.private_custom.private_custom = res/activity/private_custom/private_custom.csb
	local csbNode = csb.createNode("activity/private_custom/private_custom.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "private_custom_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function PrivateCustom:onExit()
	-- 释放PrivateCustomWindow界面资源.
	state_machine.remove("private_custom_open")
	state_machine.remove("private_custom_close")
	state_machine.remove("private_custom_show")
	state_machine.remove("private_custom_hide")
	state_machine.remove("private_custom_jump_recharge")
	state_machine.remove("private_custom_refesh_windows")
end

function PrivateCustom:close()
	-- window event : close.
	
end

function PrivateCustom:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
