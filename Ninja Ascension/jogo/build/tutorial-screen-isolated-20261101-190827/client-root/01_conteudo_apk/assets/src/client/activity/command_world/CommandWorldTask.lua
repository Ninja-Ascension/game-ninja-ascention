--[[ ----------------------------------------------------------------------------
-- 任务完成界面
--]] ----------------------------------------------------------------------------
CommandWorldTask = class("CommandWorldTaskClass", Window)

-- 打开窗口
local command_world_task_window_open_terminal = {
	_name = "command_world_task_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CommandWorldTaskClass") then
			fwin:open(CommandWorldTask:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_task_window_close_terminal = {
	_name = "command_world_task_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldTaskClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_task_window_open_terminal)
state_machine.add(command_world_task_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorldTask:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world task page state machine.
	local function init_command_world_task_terminal()
		-- 打开角色创建窗口
		local command_world_task_open_terminal = {
			_name = "command_world_task_open",
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
		local command_world_task_close_terminal = {
			_name = "command_world_task_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_task_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_task_show_terminal = {
			_name = "command_world_task_show",
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
		local command_world_task_hide_terminal = {
			_name = "command_world_task_hide",
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

		-- 
		local command_world_task_refresh_terminal = {
			_name = "command_world_task_refresh",
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

		state_machine.add(command_world_task_open_terminal)
		state_machine.add(command_world_task_close_terminal)
		state_machine.add(command_world_task_show_terminal)
		state_machine.add(command_world_task_hide_terminal)
		state_machine.add(command_world_task_refresh_terminal)
		state_machine.init()
	end
	-- call func init command world task state machine.
	init_command_world_task_terminal()
end

-- 对象初始化
function CommandWorldTask:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CommandWorldTask:updateUI()
	self.ListView_1:removeAllItems()
	local sortData = self:getSortData()
	for i, v in ipairs(sortData) do
		local cell = state_machine.excute("command_world_task_cell_create", 0, {index = i, data = v})
		self.ListView_1:addChild(cell)
	end
	self.ListView_1_poy = self.ListView_1:getInnerContainer():getPositionY()
	self.ListView_1:jumpToTop()
	self.ListView_1:requestRefreshView()
end

function CommandWorldTask:getSortData()
	local data = CommandWorldHandle.getCommandWorldTaskInfo()

	local taskTypeList = {}
	for _, v in pairs(data) do
		local taskId = tonumber(v.taskId)
		local taskType = tonumber(v.taskType)

		if taskTypeList[taskType] == nil then
			taskTypeList[taskType] = {}
		end

		table.insert(taskTypeList[taskType], v)
	end
	
	local function sortFunc_1(a, b)
		local preTaskIdA = dms.int(dms["orders_world_task_list"], a.taskId, orders_world_task_list.preTaskId)
		local preTaskIdB = dms.int(dms["orders_world_task_list"], b.taskId, orders_world_task_list.preTaskId)
		return preTaskIdA < preTaskIdB
	end

	local function sortFunc_2(a, b)
		return tonumber(a.taskType) < tonumber(b.taskType)
	end
	
	-- 对类型内部任务的排序，排序好的结果只取第一个
	local result = {}
	for k, v in pairs(taskTypeList) do
		local sortData = v

		-- 可领取
		local temp1 = {}
		-- 未完成
		local temp2 = {}
		-- 已领取
		local temp3 = {}

		for _, v in ipairs(sortData) do
			if tonumber(v.status) == 1 then
				table.insert(temp1, v)
			elseif tonumber(v.status) == 0 then
				table.insert(temp2, v)
			else
				table.insert(temp3, v)
			end
		end

		table.sort(temp1, sortFunc_1)
		table.sort(temp2, sortFunc_1)
		table.sort(temp3, sortFunc_1)

		local tempData = {}
		for _, v in ipairs(temp1) do
			table.insert(tempData, v)
		end
		for _, v in ipairs(temp2) do
			table.insert(tempData, v)
		end
		for _, v in ipairs(temp3) do
			table.insert(tempData, v)
		end

		table.insert(result, tempData[1])
	end

	-- 在对剩余结果排序，按照可领，不可领，已领取排序
	local finalResult = {}

	-- 可领取
	local temp1 = {}
	-- 未完成
	local temp2 = {}
	-- 已领取
	local temp3 = {}

	for _, v in ipairs(result) do
		if tonumber(v.status) == 1 then
			table.insert(temp1, v)
		elseif tonumber(v.status) == 0 then
			table.insert(temp2, v)
		else
			table.insert(temp3, v)
		end
	end

	table.sort(temp1, sortFunc_2)
	table.sort(temp2, sortFunc_2)
	table.sort(temp3, sortFunc_2)

	for _, v in ipairs(temp1) do
		table.insert(finalResult, v)
	end
	for _, v in ipairs(temp2) do
		table.insert(finalResult, v)
	end
	for _, v in ipairs(temp3) do
		table.insert(finalResult, v)
	end
	return finalResult
end

-- @onUpdate(dt)
-- function CommandWorldTask:onUpdate(dt)
-- 	if self.ListView_1 ~= nil then
-- 		local size = self.ListView_1:getContentSize()
-- 		local posY = self.ListView_1:getInnerContainer():getPositionY()
-- 		if self.ListView_1_poy == posY then
-- 			return
-- 		end
-- 		self.ListView_1_poy = posY
-- 		local items = self.ListView_1:getItems()
-- 		if items[1] == nil then
-- 			return
-- 		end
-- 		local itemSize = items[1]:getContentSize()
-- 		for i, v in pairs(items) do
-- 			local tempY = v:getPositionY() + posY
-- 			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
-- 				v:unload()
-- 			else	
-- 				v:reload()				
-- 			end
-- 		end
-- 	end
-- end

function CommandWorldTask:onUpdateDraw()
	local root = self.roots[1]

	-- 任务显示容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateUI()
end

function CommandWorldTask:onEnterTransitionFinish()
	-- 加载CommandWorldTaskWindow界面资源.
	-- res.activity.command_world.command_world_task = res/activity/command_world/command_world_task.csb
	local csbNode = csb.createNode("activity/command_world/command_world_task.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "command_world_task_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CommandWorldTask:onExit()
	-- 释放CommandWorldTaskWindow界面资源.
	state_machine.remove("command_world_task_open")
	state_machine.remove("command_world_task_close")
	state_machine.remove("command_world_task_show")
	state_machine.remove("command_world_task_hide")
end

function CommandWorldTask:close()
	-- window event : close.
	
end

function CommandWorldTask:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
