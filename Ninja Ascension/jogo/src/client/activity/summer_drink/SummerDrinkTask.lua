--[[ ----------------------------------------------------------------------------
-- 任务详情界面
--]] ----------------------------------------------------------------------------
SummerDrinkTask = class("SummerDrinkTaskClass", Window)

-- 打开窗口
local summer_drink_task_window_open_terminal = {
	_name = "summer_drink_task_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SummerDrinkTaskClass") then
			fwin:open(SummerDrinkTask:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local summer_drink_task_window_close_terminal = {
	_name = "summer_drink_task_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SummerDrinkTaskClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(summer_drink_task_window_open_terminal)
state_machine.add(summer_drink_task_window_close_terminal)
state_machine.init()

-- 构造器
function SummerDrinkTask:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.columnRowDes = {
		[16] = "1,2,3,4,5",
		[17] = "6,7,8,9,10",
		[18] = "11,12,13,14,15",
		[19] = "1,6,11",
		[20] = "2,7,12",
		[21] = "3,8,13",
		[22] = "4,9,14",
		[23] = "5,10,15",
	}


	-- load lua files.

	-- Initialize summer drink task page state machine.
	local function init_summer_drink_task_terminal()
		-- 打开角色创建窗口
		local summer_drink_task_open_terminal = {
			_name = "summer_drink_task_open",
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
		local summer_drink_task_close_terminal = {
			_name = "summer_drink_task_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("summer_drink_task_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local summer_drink_task_show_terminal = {
			_name = "summer_drink_task_show",
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
		local summer_drink_task_hide_terminal = {
			_name = "summer_drink_task_hide",
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
		local summer_drink_task_jump_window_terminal = {
			_name = "summer_drink_task_jump_window",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("shortcut_open_recharge_window", 0, "")

				state_machine.excute("summer_drink_task_close", 0, nil)
				state_machine.excute("summer_drink_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(summer_drink_task_open_terminal)
		state_machine.add(summer_drink_task_close_terminal)
		state_machine.add(summer_drink_task_show_terminal)
		state_machine.add(summer_drink_task_hide_terminal)
		state_machine.add(summer_drink_task_jump_window_terminal)
		state_machine.init()
	end
	-- call func init summer drink task state machine.
	init_summer_drink_task_terminal()
end

-- 对象初始化
function SummerDrinkTask:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SummerDrinkTask:onInit(params)
	-- type == 1 冰块任务 type == 2 行列宝箱任务
	self._type = params.type
	self._index = params.index
end

function SummerDrinkTask:updateUI()
	local index = self._index

	local titleStr = ""
	local taskDes = ""

	local summerDrinkData = SummerDrinkHandle.getSummerDrinkData()
	local data = summerDrinkData[index]
	local totalProgress = data.totalProgress
	local curProgress = data.curProgress >= totalProgress and totalProgress or data.curProgress

	if self._type == 1 then
		titleStr = tipStringInfo_activity_summer_drink[1] .. "" .. index
		local achieveData = dms.element(dms["achieve"], data.achieveID)
		taskDes = dms.atos(achieveData, achieve.title)
	elseif self._type == 2 then
		titleStr = tipStringInfo_activity_summer_drink[2]
		taskDes = string.format(tipStringInfo_activity_summer_drink[3], self.columnRowDes[index])
	end

	self.Text_title:setString(titleStr)
	self.Text_lodaing:setString(curProgress .. "/" .. totalProgress)
	self.LoadingBar_1:setPercent(curProgress / totalProgress * 100)
	self.Text_present:setString(taskDes)

	self.ListView_item:removeAllItems()

	-- 奖励
	local rewards = SummerDrinkHandle.getTaskReward(index)
	for _, v in pairs(rewards) do
		local cell = self:addResourcesIconCell(v)
		self.ListView_item:addChild(cell)
	end

	self.ListView_item:jumpToLeft()
	self.ListView_item:requestRefreshView()
end

function SummerDrinkTask:updateButtonState()
	local index = self._index
	-- 任务15为充值跳转任务
	-- 并且任务处于未完成状态
	local state = SummerDrinkHandle.getTaskRewardState(index)
	self.Button_go:setVisible(index == 15 and state == 0)
end

function SummerDrinkTask:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function SummerDrinkTask:onUpdateDraw()
	local root = self.roots[1]

	-- 任务%s
	self.Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")

	-- 道具奖励
	self.ListView_item = ccui.Helper:seekWidgetByName(root, "ListView_item")

	-- 任务进度条
	self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

	-- 任务进度
	self.Text_lodaing = ccui.Helper:seekWidgetByName(root, "Text_lodaing")

	-- 任务描述
	self.Text_present = ccui.Helper:seekWidgetByName(root, "Text_present")

	self:updateUI()
	self:updateButtonState()
end

function SummerDrinkTask:onEnterTransitionFinish()
	-- 加载SummerDrinkTaskWindow界面资源.
	-- res.activity.summer_drink.summer_drink_task = res/activity/summer_drink/summer_drink_task.csb
	local csbNode = csb.createNode("activity/summer_drink/summer_drink_task.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 前往任务相应界面
	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "summer_drink_task_jump_window",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "summer_drink_task_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SummerDrinkTask:onExit()
	-- 释放SummerDrinkTaskWindow界面资源.
	state_machine.remove("summer_drink_task_open")
	state_machine.remove("summer_drink_task_close")
	state_machine.remove("summer_drink_task_show")
	state_machine.remove("summer_drink_task_hide")
	state_machine.remove("summer_drink_task_jump_window")
end

function SummerDrinkTask:close()
	-- window event : close.
	
end

function SummerDrinkTask:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
