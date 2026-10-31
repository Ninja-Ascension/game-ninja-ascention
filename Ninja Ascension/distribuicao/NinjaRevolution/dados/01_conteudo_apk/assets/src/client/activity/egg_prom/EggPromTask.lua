--[[ ----------------------------------------------------------------------------
-- 成就任务
--]] ----------------------------------------------------------------------------
EggPromTask = class("EggPromTaskClass", Window)

-- 打开窗口
local egg_prom_task_window_open_terminal = {
	_name = "egg_prom_task_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("EggPromTaskClass") then
			fwin:open(EggPromTask:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local egg_prom_task_window_close_terminal = {
	_name = "egg_prom_task_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggPromTaskClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_task_window_open_terminal)
state_machine.add(egg_prom_task_window_close_terminal)
state_machine.init()

-- 构造器
function EggPromTask:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._activityData = {}
	self._eggPromData = {}

	-- load lua files.
	app.load("client.activity.egg_prom.eggpromtasklist")

	-- Initialize egg prom task page state machine.
	local function init_egg_prom_task_terminal()
		-- 打开角色创建窗口
		local egg_prom_task_open_terminal = {
			_name = "egg_prom_task_open",
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
		local egg_prom_task_close_terminal = {
			_name = "egg_prom_task_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("egg_prom_task_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local egg_prom_task_show_terminal = {
			_name = "egg_prom_task_show",
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
		local egg_prom_task_hide_terminal = {
			_name = "egg_prom_task_hide",
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
		local egg_prom_task_refresh_terminal = {
			_name = "egg_prom_task_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:onInit()
					instance:updateTaskList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(egg_prom_task_open_terminal)
		state_machine.add(egg_prom_task_close_terminal)
		state_machine.add(egg_prom_task_show_terminal)
		state_machine.add(egg_prom_task_hide_terminal)
		state_machine.add(egg_prom_task_refresh_terminal)
		state_machine.init()
	end
	-- call func init egg prom task state machine.
	init_egg_prom_task_terminal()
end

-- 对象初始化
function EggPromTask:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function EggPromTask:onInit(params)
	self._activityData = _ED.active_activity[171]
	self._eggPromData = self._activityData.eggPromData
end

function EggPromTask:updateTaskList()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local sortList = self:getSortTaskList()
	for _, v in ipairs(sortList) do
		local cell = state_machine.excute("egg_prom_task_list_create", 0, {v})
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()	
end


function EggPromTask:getSortTaskList()
	local achieveInfo = self._eggPromData.achieveInfo
	local sortAchieveInfos = {}

	local canGetReward = {}
	local canGoShake = {}
	local haveGotReward = {}

	for _, v in pairs(achieveInfo) do
		if tonumber(v.rewardStatus) == 0 then
			table.insert(canGoShake, v)
		elseif tonumber(v.rewardStatus) == 1 then
			table.insert(canGetReward, v)
		elseif tonumber(v.rewardStatus) == 2 then
			table.insert(haveGotReward, v)
		end
	end

	local function sortFunc(a, b)
		local aSort = tonumber(a.achieveType) * 100 + tonumber(a.maxProcess) * 0.01
		local bSort = tonumber(b.achieveType) * 100 + tonumber(b.maxProcess) * 0.01

		return aSort > bSort
	end

	table.sort(canGetReward, sortFunc)
	table.sort(canGoShake, sortFunc)
	table.sort(haveGotReward, sortFunc)


	for _, v in ipairs(canGetReward) do
		table.insert(sortAchieveInfos, v)
	end

	for _, v in ipairs(canGoShake) do
		table.insert(sortAchieveInfos, v)
	end

	for _, v in ipairs(haveGotReward) do
		table.insert(sortAchieveInfos, v)
	end

	return sortAchieveInfos
end

function EggPromTask:onUpdateDraw()
	local root = self.roots[1]

	-- 任务列表容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateTaskList()
end

function EggPromTask:onEnterTransitionFinish()
	-- 加载EggPromTaskWindow界面资源.
	-- res.activity.egg_prom.egg_prom_task = res/activity/egg_prom/egg_prom_task.csb
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_task.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "egg_prom_task_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
end

function EggPromTask:onExit()
	-- 释放EggPromTaskWindow界面资源.
	state_machine.remove("egg_prom_task_open")
	state_machine.remove("egg_prom_task_close")
	state_machine.remove("egg_prom_task_show")
	state_machine.remove("egg_prom_task_hide")
	state_machine.remove("egg_prom_task_refresh")
end

function EggPromTask:close()
	-- window event : close.
	
end

function EggPromTask:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
