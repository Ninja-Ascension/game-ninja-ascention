--[[ ----------------------------------------------------------------------------
-- 成就任务列表项
--]] ----------------------------------------------------------------------------
EggPromTaskList = class("EggPromTaskListClass", Window)
EggPromTaskList.__size = nil

-- 创建Cell实例
local egg_prom_task_list_create_terminal = {
	_name = "egg_prom_task_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if EggPromTaskList then
			local cell = EggPromTaskList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_task_list_create_terminal)
state_machine.init()

-- 构造器
function EggPromTaskList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._data = nil
	self._taskData = nil

	-- load lua files.

	-- Initialize egg prom task list page state machine.
	local function init_egg_prom_task_list_terminal()
		-- 前往
		local egg_prom_task_list_go_terminal = {
			_name = "egg_prom_task_list_go",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("egg_prom_task_window_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 领取奖励
		local egg_prom_task_list_get_reward_terminal = {
			_name = "egg_prom_task_list_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local achieveIndex = params._datas.achieveIndex
					-- print("领取奖励 achieveIndex = ", achieveIndex)
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							-- 刷新红点
							state_machine.excute("egg_prom_refresh", 0, nil)
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 171)
							-- 领取完刷新界面
							state_machine.excute("egg_prom_task_refresh", 0, nil)
						end
					end
					protocol_command.egg_frenzy_get_reward.param_list = "" .. achieveIndex
					NetworkManager:register(protocol_command.egg_frenzy_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(egg_prom_task_list_go_terminal)
		state_machine.add(egg_prom_task_list_get_reward_terminal)
	end
	-- call func init egg prom task list state machine.
	init_egg_prom_task_list_terminal()
end

-- 对象初始化
function EggPromTaskList:init(params)
	self._data = params[1]

	local taskID = tonumber(self._data.achieveIndex) + 1
	self._taskData = dms.searchs(dms["egg_ball_achievement_task"], egg_ball_achievement_task.id, taskID)[1]

	self:onInit(params)
	self:setContentSize(EggPromTaskList.__size)
	return self
end

function EggPromTaskList:updateUI()
	local taskData = self._taskData

	self:updateRewardList()
	self:updateButtonState()

	local maxProgress = self._data.maxProcess
	local name = dms.element(dms["word_mould"], taskData[4])[3]
	self.Text_task:setString(string.format(name, maxProgress))

	local currentProcess = self._data.currentProcess >= maxProgress and maxProgress or self._data.currentProcess
	self.Text_1:setString(currentProcess)
	self.Text_2:setString(maxProgress)
	self.LoadingBar_1:setPercent(tonumber(currentProcess) / tonumber(maxProgress) * 100)
end

function EggPromTaskList:updateButtonState()
	local rewardStatus = tonumber(self._data.rewardStatus)

	self.Button_go:setVisible(false)
	self.Button_collect:setVisible(false)
	self.Image_13:setVisible(false)
	
	-- 前往砸蛋
	if rewardStatus == 0 then
		self.Button_go:setVisible(true)
	elseif rewardStatus == 1 then
		self.Button_collect:setVisible(true)
	else
		-- self.Button_collect:setVisible(true)
		-- self.Button_collect:setTouchEnabled(false)
		self.Image_13:setVisible(true)
	end
end

function EggPromTaskList:updateRewardList()
	local achieveReward = self._data.achieveReward

	local rewardData = zstring.splits(achieveReward, "|", ",")

	local ListView_item = self.ListView_item
	ListView_item:removeAllItems()

	for _, v in pairs(rewardData) do
		local cell = self:addResourcesIconCell(v)
		ListView_item:addChild(cell)
	end

	ListView_item:jumpToLeft()
	ListView_item:requestRefreshView()
end

function EggPromTaskList:addResourcesIconCell(propData)
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

function EggPromTaskList:onUpdateDraw()
	local root = self.roots[1]

	-- 成就任务名称
	self.Text_task = ccui.Helper:seekWidgetByName(root, "Text_task")

	-- 已领取（默认隐藏）
	self.Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")

	-- 奖励道具列表
	self.ListView_item = ccui.Helper:seekWidgetByName(root, "ListView_item")

	-- 完成进度条
	self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

	-- 已完成数
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	-- 目标总数
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

	-- 前往
	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "egg_prom_task_list_go",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 领取
	self.Button_collect = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collect"), nil,
	{
		terminal_name = "egg_prom_task_list_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		achieveIndex = tonumber(self._data.achieveIndex),
	}, nil, 0)

	self:updateUI()
end

function EggPromTaskList:onEnterTransitionFinish()
	
end

function EggPromTaskList:onInit(params)
	-- 加载EggPromTaskListWindow界面资源.
	-- res.activity.egg_prom.egg_prom_task_list = res/activity/egg_prom/egg_prom_task_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_task_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/egg_prom/egg_prom_task_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if EggPromTaskList.__size == nil then
		EggPromTaskList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function EggPromTaskList:onExit()
	-- 释放EggPromTaskListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/egg_prom/egg_prom_task_list.csb", root)
	-- ]]
end

function EggPromTaskList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EggPromTaskList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/egg_prom/egg_prom_task_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
