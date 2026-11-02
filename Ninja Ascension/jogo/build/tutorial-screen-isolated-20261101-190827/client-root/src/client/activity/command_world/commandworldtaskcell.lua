--[[ ----------------------------------------------------------------------------
-- 任务详情
--]] ----------------------------------------------------------------------------
CommandWorldTaskCell = class("CommandWorldTaskCellClass", Window)
CommandWorldTaskCell.__size = nil

-- 创建Cell实例
local command_world_task_cell_create_terminal = {
	_name = "command_world_task_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommandWorldTaskCell then
			local cell = CommandWorldTaskCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_task_cell_create_terminal)
state_machine.init()

-- 构造器
function CommandWorldTaskCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world task cell page state machine.
	local function init_command_world_task_cell_terminal()
		-- 领取奖励
		local command_world_task_cell_get_reward_terminal = {
			_name = "command_world_task_cell_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local data = params._datas.data
				-- 任务领奖 类型0
				local taskType = 0
				local index = data.index

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(7)
						fwin:open(getRewardWnd, fwin._ui)

						-- 刷新红点
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 174)
						-- 刷新右侧按钮红点
						state_machine.excute("command_word_update_right_red_dot", 0, nil)
						-- 刷新主界面
						state_machine.excute("command_world_refresh_ui", 0, true)
						-- 领取完刷新界面
						state_machine.excute("command_world_task_refresh", 0, nil)
					end
				end
				protocol_command.activity_orders_world_get_reward.param_list = "" .. taskType .. "\r\n" .. index
				NetworkManager:register(protocol_command.activity_orders_world_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 跳转某个界面
		local command_world_task_cell_jump_windows_terminal = {
			_name = "command_world_task_cell_jump_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local data = params._datas.data
				instance:jumpToWindows(data)
				-- state_machine.excute("command_world_task_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(command_world_task_cell_get_reward_terminal)
		state_machine.add(command_world_task_cell_jump_windows_terminal)
	end
	-- call func init command world task cell state machine.
	init_command_world_task_cell_terminal()
end

-- 对象初始化
function CommandWorldTaskCell:init(params)
	self._index = params.index
	self._data = params.data

	-- if self._index <= 6 then
		self:onInit(params)
	-- end
	self:setContentSize(CommandWorldTaskCell.__size)
	return self
end

function CommandWorldTaskCell:updateUI()
	local data = dms.element(dms["orders_world_task_list"], tonumber(self._data.taskId))
	local name_mould_id = dms.atos(data, orders_world_task_list.name)

	local word_info = dms.element(dms["word_mould"], name_mould_id)
	local name = word_info[3]

	local taskValue = dms.atos(data, orders_world_task_list.taskValue)
	self.Text_task:setString(string.format(name, taskValue))

	local maxProcess = tonumber(self._data.maxProcess)
	local currentProcess = tonumber(self._data.currentProcess) > maxProcess and maxProcess or tonumber(self._data.currentProcess)

	self.Text_1:setString(currentProcess .. "/".. maxProcess)

	local status = tonumber(self._data.status)
	self.Button_lq:setVisible(status == 1)
	self.Button_wc:setVisible(status == 0)
	self.Image_ywc:setVisible(status == 2)


	self:updateRewardList()
end

function CommandWorldTaskCell:updateRewardList()
	local rewardData = CommandWorldHandle.getCommandWorldTaskRewardsInfo(tonumber(self._data.taskId))
	
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	for _, v in pairs(rewardData) do
		local cell = self:addResourcesIconCell(v)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToLeft()
	ListView_1:requestRefreshView()
end

function CommandWorldTaskCell:addResourcesIconCell(propData)
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

function CommandWorldTaskCell:jumpToWindows(data)
	local taskJumpType = dms.int(dms["orders_world_task_list"], data.taskId, orders_world_task_list.jumpType)
	--[[
		-1为不引用
		1.跳转到竞技场
		2.跳转到试练塔
		3.跳转到主线关卡
		4.跳转到精英关卡
		5.跳转到铜币商店界面
		6.跳转到活动关卡
		7.跳转到体力购买界面
	]]
	-- print("data.taskId = ", data.taskId)
	-- print("taskJumpType = ", taskJumpType)

	if taskJumpType == 1 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 297, _datas = {}})
	elseif taskJumpType == 2 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 298, _datas = {}})
	elseif taskJumpType == 3 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 288, _datas = {}})
	elseif taskJumpType == 4 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 289, _datas = {}})
	elseif taskJumpType == 5 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 280, _datas = {}})
	elseif taskJumpType == 6 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 290, _datas = {}})
	elseif taskJumpType == 7 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 293, _datas = {}})
	end
end

function CommandWorldTaskCell:onUpdateDraw()
	local root = self.roots[1]

	--任务名称
	self.Text_task = ccui.Helper:seekWidgetByName(root, "Text_task")

	-- 进度
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	-- 奖励
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 已领取
	self.Image_ywc = ccui.Helper:seekWidgetByName(root, "Image_ywc")

	-- 领取
	self.Button_lq = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lq"), nil,
	{
		terminal_name = "command_world_task_cell_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		data = self._data,
	}, nil, 0)

	-- 前往
	self.Button_wc = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wc"), nil,
	{
		terminal_name = "command_world_task_cell_jump_windows",
		terminal_state = 0,
		isPressedActionEnabled = true,
		data = self._data,
	}, nil, 0)

	self:updateUI()
end

function CommandWorldTaskCell:onEnterTransitionFinish()
	
end

function CommandWorldTaskCell:onInit(params)
	-- 加载CommandWorldTaskCellWindow界面资源.
	-- res.activity.command_world.command_world_task_cell = res/activity/command_world/command_world_task_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/command_world/command_world_task_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/command_world/command_world_task_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommandWorldTaskCell.__size == nil then
		CommandWorldTaskCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CommandWorldTaskCell:onExit()
	-- 释放CommandWorldTaskCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/command_world/command_world_task_cell.csb", root)
	-- ]]
end

function CommandWorldTaskCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommandWorldTaskCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/command_world/command_world_task_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
