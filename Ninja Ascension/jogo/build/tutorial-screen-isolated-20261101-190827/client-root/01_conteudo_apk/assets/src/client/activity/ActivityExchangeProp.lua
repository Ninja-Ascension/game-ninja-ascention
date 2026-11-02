--[[ ----------------------------------------------------------------------------
-- 武器&刃具置换
--]] ----------------------------------------------------------------------------
ActivityExchangeProp = class("ActivityExchangePropClass", Window)

-- 打开窗口
local activity_exchange_prop_window_open_terminal = {
	_name = "activity_exchange_prop_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityExchangePropClass") then
			fwin:open(ActivityExchangeProp:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_exchange_prop_window_close_terminal = {
	_name = "activity_exchange_prop_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityExchangePropClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_exchange_prop_window_open_terminal)
state_machine.add(activity_exchange_prop_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityExchangeProp:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0

	-- load lua files.
	app.load("client.activity.ActivityExchangePropList")

	-- Initialize lim pool rule page state machine.
	local function init_activity_exchange_prop_terminal()
		-- 打开角色创建窗口
		local activity_exchange_prop_open_terminal = {
			_name = "activity_exchange_prop_open",
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
		local activity_exchange_prop_close_terminal = {
			_name = "activity_exchange_prop_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("activity_exchange_prop_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local activity_exchange_prop_show_terminal = {
			_name = "activity_exchange_prop_show",
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
		local activity_exchange_prop_hide_terminal = {
			_name = "activity_exchange_prop_hide",
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
		local activity_exchange_prop_refresh_ui_terminal = {
			_name = "activity_exchange_prop_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(activity_exchange_prop_open_terminal)
		state_machine.add(activity_exchange_prop_close_terminal)
		state_machine.add(activity_exchange_prop_show_terminal)
		state_machine.add(activity_exchange_prop_hide_terminal)
		state_machine.add(activity_exchange_prop_refresh_ui_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_activity_exchange_prop_terminal()
end

-- 对象初始化
function ActivityExchangeProp:init(params)
	return self
end

function ActivityExchangeProp:updateUI()
	local activity = _ED.active_activity[28]

	if _ED.half_price_shop_exchang_times == nil or _ED.half_price_shop_exchang_times == "" then
		_ED.half_price_shop_exchang_times = zstring.split(activity.activity_extra_prame2, ",")
	end

	self._datas = zstring.split(activity.activity_extra_prame, "\\r\\n")

	self._activityEndTime = tonumber(activity.activity_login_day) * 1000

	-- debug.print_r(_ED.silkbag_pack_info, "锦囊总数据 _ED.silkbag_pack_info ")

	self:updateActivityRemainTime()
	self:updateList()
end

function ActivityExchangeProp:updateList()
	local ListView_weapon_exchange_dh = self.ListView_weapon_exchange_dh
	ListView_weapon_exchange_dh:removeAllItems()

	local sortData = self:getSortData()
	for _, v in ipairs(sortData) do
		local cell = state_machine.excute("activity_exchange_prop_list_create", 0, {v.data, v.index})
		ListView_weapon_exchange_dh:addChild(cell)
	end

	ListView_weapon_exchange_dh:jumpToTop()
	ListView_weapon_exchange_dh:requestRefreshView()
end

function ActivityExchangeProp:getSortData()
	local datas = self._datas

	local result = {}
	local closeItems = {} 		-- 已完成
	local drawItems = {}			-- 可领取
	local uncompItems = {}		-- 未完成

	for k, v in pairs(datas) do
		if tonumber(v.rewardState) == 0 then
			table.insert(uncompItems, {index = k, data = v})
		elseif tonumber(v.rewardState) == 1 then
			table.insert(drawItems, {index = k, data = v})
		else
			table.insert(closeItems, {index = k, data = v})
		end
	end
	for k, v in pairs(drawItems) do
		table.insert(result, v)
	end
	for k, v in pairs(uncompItems) do
		table.insert(result, v)
	end
	for k, v in pairs(closeItems) do
		table.insert(result, v)
	end

	return result
end

function ActivityExchangeProp:updateActivityRemainTime()
	if self.Text_time_limit_time_n == nil or self._activityEndTime == nil then
		return
	end
	local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time_limit_time_n:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function ActivityExchangeProp:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateActivityRemainTime()
		self.totalTime = 0
	end
end

function ActivityExchangeProp:drawTime(_time)
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

function ActivityExchangeProp:onUpdateDraw()
	local root = self.roots[1]

	self.ListView_weapon_exchange_dh = ccui.Helper:seekWidgetByName(root, "ListView_weapon_exchange_dh")
	self.Text_time_limit_time_n = ccui.Helper:seekWidgetByName(root, "Text_time_limit_time_n")

	self:updateUI()
end

function ActivityExchangeProp:onEnterTransitionFinish()
	-- 加载ActivityExchangePropWindow界面资源.
	-- res.activity.wonderful.weapon_exchange = res/activity/wonderful/weapon_exchange.csb
	local csbNode = csb.createNode("activity/wonderful/weapon_exchange.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_weapon_exchange_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_weapon_exchange_close"), nil,
	{
		terminal_name = "activity_exchange_prop_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ActivityExchangeProp:onExit()
	-- 释放ActivityExchangePropWindow界面资源.
	state_machine.remove("activity_exchange_prop_open")
	state_machine.remove("activity_exchange_prop_close")
	state_machine.remove("activity_exchange_prop_show")
	state_machine.remove("activity_exchange_prop_hide")
	state_machine.remove("activity_exchange_prop_refresh_ui")
end

function ActivityExchangeProp:close()
	-- window event : close.
	
end

function ActivityExchangeProp:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
