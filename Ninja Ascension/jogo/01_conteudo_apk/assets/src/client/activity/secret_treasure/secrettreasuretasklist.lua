--[[ ----------------------------------------------------------------------------
-- 任务列表
--]] ----------------------------------------------------------------------------
SecretTreasureTaskList = class("SecretTreasureTaskListClass", Window)
SecretTreasureTaskList.__size = nil

-- 创建Cell实例
local secret_treasure_task_list_create_terminal = {
	_name = "secret_treasure_task_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SecretTreasureTaskList then
			local cell = SecretTreasureTaskList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_task_list_create_terminal)
state_machine.init()

-- 构造器
function SecretTreasureTaskList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure task list page state machine.
	local function init_secret_treasure_task_list_terminal()
		-- 领取奖励
		local secret_treasure_task_list_get_reward_terminal = {
			_name = "secret_treasure_task_list_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local _self = params._datas._self
				local data = _self._data

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(7)
						fwin:open(getRewardWnd, fwin._ui)

						-- 刷新红点
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 173)
						-- 刷新界面的数量
						state_machine.excute("secret_treasure_refresh_ui", 0, nil)
						-- 领取完刷新界面
						state_machine.excute("secret_treasure_task_refresh", 0, nil)
					end
				end
				protocol_command.secret_travel_get_reward.param_list = "" .. data.index
				NetworkManager:register(protocol_command.secret_travel_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(secret_treasure_task_list_get_reward_terminal)
	end
	-- call func init secret treasure task list state machine.
	init_secret_treasure_task_list_terminal()
end

-- 对象初始化
function SecretTreasureTaskList:init(params)
	self._data = params

	self:onInit(params)
	self:setContentSize(SecretTreasureTaskList.__size)
	return self
end

function SecretTreasureTaskList:updateUI()
	local data = self._data

	local achieveID = tonumber(data.taskId)
	local achieveData = dms.element(dms["achieve"], achieveID)
	local taskDes = dms.atos(achieveData, achieve.title)

	local totalProgress = data.totalProcess
	local curProgress = data.currentProcess >= totalProgress and totalProgress or data.currentProcess

	self.Text_task:setString(taskDes)
	self.Text_pro:setString(curProgress .. "/" .. totalProgress)
	self.LoadingBar_1:setPercent(curProgress / totalProgress * 100)

	-- 奖励领取状态（0不可领取，1可领取，2已领取）
	local rewardState = tonumber(data.rewardStatus)
	if rewardState == 0 then
		self.Image_50:setVisible(false)

		self.Button_task_lq:setVisible(true)
		self.Button_task_lq:setTouchEnabled(false)
		self.Button_task_lq:setBright(false)
	elseif rewardState == 1 then
		self.Image_50:setVisible(false)

		self.Button_task_lq:setVisible(true)
		self.Button_task_lq:setTouchEnabled(true)
		self.Button_task_lq:setBright(true)
	else
		self.Image_50:setVisible(true)
		self.Button_task_lq:setVisible(false)
	end
	
	self.ListView_item:removeAllItems()

	-- 奖励
	local propID = SecretTreasureHandle.getSecretCostPropID()
	-- 修改奖励数量为服务器传来的
	local getPropInfo = {6, propID, data.canGetPropNumber, -1}
	
	local cell = self:addResourcesIconCell(getPropInfo)
	self.ListView_item:addChild(cell)

	self.ListView_item:jumpToLeft()
	self.ListView_item:requestRefreshView()
end

function SecretTreasureTaskList:addResourcesIconCell(propData)
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

function SecretTreasureTaskList:onUpdateDraw()
	local root = self.roots[1]

	-- 进度条
	self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

	-- 进度
	self.Text_pro = ccui.Helper:seekWidgetByName(root, "Text_pro")

	-- 已完成
	self.Image_50 = ccui.Helper:seekWidgetByName(root, "Image_50")

	-- 任务描述
	self.Text_task = ccui.Helper:seekWidgetByName(root, "Text_task")

	-- 列表
	self.ListView_item = ccui.Helper:seekWidgetByName(root, "ListView_item")

	-- 领取
	self.Button_task_lq = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_lq"), nil,
	{
		terminal_name = "secret_treasure_task_list_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_self = self,
	}, nil, 0)

	self:updateUI()
end

function SecretTreasureTaskList:onEnterTransitionFinish()
	
end

function SecretTreasureTaskList:onInit(params)
	-- 加载SecretTreasureTaskListWindow界面资源.
	-- res.activity.secret_treasure.secret_treasure_task_list = res/activity/secret_treasure/secret_treasure_task_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_task_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/secret_treasure/secret_treasure_task_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SecretTreasureTaskList.__size == nil then
		SecretTreasureTaskList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function SecretTreasureTaskList:onExit()
	-- 释放SecretTreasureTaskListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/secret_treasure/secret_treasure_task_list.csb", root)
	-- ]]
end

function SecretTreasureTaskList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SecretTreasureTaskList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/secret_treasure/secret_treasure_task_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
