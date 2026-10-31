--[[ ----------------------------------------------------------------------------
-- 获取窗口列表项
--]] ----------------------------------------------------------------------------
LimPoolToGetList = class("LimPoolToGetListClass", Window)
LimPoolToGetList.__size = nil

-- 创建Cell实例
local lim_pool_to_get_list_create_terminal = {
	_name = "lim_pool_to_get_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if LimPoolToGetList then
			local cell = LimPoolToGetList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_to_get_list_create_terminal)
state_machine.init()

-- 构造器
function LimPoolToGetList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._taskInfo = nil
	self._remainBuyTimes = 0
	self._buyPropCost = 0
	self._activityType = 0					-- 当前活动类型

	-- load lua files.
	app.load("client.activity.lim_pool.LimPoolBuy")

	-- Initialize lim pool to get list page state machine.
	local function init_lim_pool_to_get_list_terminal()
		-- 跳转某个界面
		local lim_pool_to_get_list_jump_windows_terminal = {
			_name = "lim_pool_to_get_list_jump_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local taskInfo = params._datas.taskInfo
				instance:jumpToWindows(taskInfo)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 金币购买
		local lim_pool_to_get_list_open_buy_windows_terminal = {
			_name = "lim_pool_to_get_list_open_buy_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local remainBuyTimes = params._datas.remainBuyTimes
				local buyPropCost = params._datas.buyPropCost
				-- print("remainBuyTimes = ", remainBuyTimes, " buyPropCost = ", buyPropCost)
				local data = {remainBuyTimes = remainBuyTimes, buyPropCost = buyPropCost}
				state_machine.excute("lim_pool_buy_window_open", 0, {propBuyData = data, _activityType = instance._activityType})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 领取奖励
		local lim_pool_to_get_list_get_reward_terminal = {
			_name = "lim_pool_to_get_list_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local taskInfo = params._datas.taskInfo
				local taskType = tonumber(taskInfo[2])
				-- print("领奖类型 = ", taskType)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(7)
						fwin:open(getRewardWnd, fwin._ui)

						-- 刷新红点
						state_machine.excute("lim_pool_refesh_red_dot", 0, 0)
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, instance._activityType)
						-- 刷新道具的数量
						state_machine.excute("lim_user_top_info_refresh_prop_count", 0, 0)
						-- 领取完刷新界面
						state_machine.excute("lim_pool_to_get_update_windows", 0, 0)
					end
				end

				if instance._activityType == 168 then
					protocol_command.time_limit_jackpot_get_task_reward.param_list = "" .. taskType
					NetworkManager:register(protocol_command.time_limit_jackpot_get_task_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				elseif instance._activityType == 188 then
					protocol_command.cross_time_limit_jackpot_get_task_reward.param_list = "" .. taskType
					NetworkManager:register(protocol_command.cross_time_limit_jackpot_get_task_reward.code, nil, nil, nil, instance, responseCallback, false, nil)	
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(lim_pool_to_get_list_jump_windows_terminal)
		state_machine.add(lim_pool_to_get_list_open_buy_windows_terminal)
		state_machine.add(lim_pool_to_get_list_get_reward_terminal)
	end
	-- call func init lim pool to get list state machine.
	init_lim_pool_to_get_list_terminal()
end

-- 对象初始化
function LimPoolToGetList:init(params)
	-- 服务器任务数据
	self._taskData = params._taskData
	self._activityType = params._activityType

	local taskType = self._taskData.taskType
	local taskInfo = dms.searchs(dms["activity_limit_jackpot_task_mould"], activity_limit_jackpot_task_mould.task_type, taskType)[1]
	self._taskInfo = taskInfo

	self:onInit(params)
	self:setContentSize(LimPoolToGetList.__size)
	return self
end

function LimPoolToGetList:jumpToWindows(taskInfo)
	local taskJumpType = tonumber(taskInfo[5])

	-- print("taskJumpType = ", taskJumpType)
	-- 1.主线 2.精英 3.试炼塔 4.特惠礼包
	if taskJumpType == 1 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 288, _datas = {}})
	elseif taskJumpType == 2 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 289, _datas = {}})
	elseif taskJumpType == 3 then
		state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 298, _datas = {}})
	elseif taskJumpType == 4 then
		if _ED.active_activity[152] ~= nil then
			app.load("client.activity.wonderful.ActivitySingleRecharge")
			state_machine.excute("activity_single_recharge_window_open", 0, 152)
		else
			state_machine.excute("shortcut_open_recharge_window", 0, "")
		end
		
		state_machine.excute("lim_pool_to_get_window_close", 0, 0)
		state_machine.excute("lim_pool_window_close", 0, 0)
	end
end

function LimPoolToGetList:updateUI()
	local taskInfo = self._taskInfo
	local taskData = self._taskData

	local taskType = tonumber(taskInfo[2])
	local title = dms.element(dms["word_mould"], taskInfo[3])[3]
	local content = dms.element(dms["word_mould"], taskInfo[4])[3]

	local nowProgress = taskData.taskCompleteNumber
	local totalProgress = taskData.taskMaxCompleteNumber
	local buyPropCost = taskData.taskCostGoldNumber
	local getCostPropCount = taskData.taskRewardNumber
	local remainMoney = _ED.active_activity[self._activityType].info.remainMoney

	self.Text_num:setVisible(false)
	self.Image_received:setVisible(false)
	self.Button_go:setVisible(false)
	self.Button_buy:setVisible(false)
	self.Button_collect:setVisible(false)

	local haveGetReward = taskData.getReward == 1
	local canGetReward = taskData.getReward == 0 and taskData.taskStatus == 1

	-- 已领取
	if haveGetReward then
		self.Image_received:setVisible(true)
	elseif canGetReward then
		self.Button_collect:setVisible(true)
	else
		self.Text_num:setVisible(true)
		if taskType ~= 6 then
			self.Text_num:setString(nowProgress .. "/" .. totalProgress)
		else
			local haveBought = buyPropCost * nowProgress + remainMoney
			self.Text_num:setString(haveBought .. "/" .. buyPropCost)
		end
		if taskType == 5 then
			self.Button_buy:setVisible(true)
			self.Text_price:setString(buyPropCost)
		else
			self.Button_go:setVisible(true)
		end
	end

	-- 登录有礼
	if taskType == 1 then
		content = string.format(content, getCostPropCount)
	elseif taskType == 2 or taskType == 3 or taskType == 4 then -- 主线 试练塔 精英关卡
		content = string.format(content, totalProgress, getCostPropCount)
	elseif taskType == 5 then -- 金币购买
		local remainTimes = totalProgress - nowProgress
		self._remainBuyTimes = remainTimes
		self._buyPropCost = buyPropCost
		content = string.format(content, buyPropCost, remainTimes)
	elseif taskType == 6 then -- 充值有礼
		content = string.format(content, buyPropCost)
	end

	self.Text_title:setString(title)

	self.Text_contain:setString(content)
end

function LimPoolToGetList:onUpdateDraw()
	local root = self.roots[1]

	-- 任务名
	self.Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")

	-- 完成进度
	self.Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")

	-- 花费元宝
	self.Text_price = ccui.Helper:seekWidgetByName(root, "Text_price")

	-- 已完成
	self.Image_received = ccui.Helper:seekWidgetByName(root, "Image_received")

	-- 任务描述
	self.Text_contain = ccui.Helper:seekWidgetByName(root, "Text_contain")

	self.Button_go = ccui.Helper:seekWidgetByName(root, "Button_go")

	self.Button_buy = ccui.Helper:seekWidgetByName(root, "Button_buy")

	self.Button_collect = ccui.Helper:seekWidgetByName(root, "Button_collect")

	self:updateUI()

	-- 前往
	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "lim_pool_to_get_list_jump_windows",
		terminal_state = 0,
		isPressedActionEnabled = true,
		taskInfo = self._taskInfo,
	}, nil, 0)

	-- 购买
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil,
	{
		terminal_name = "lim_pool_to_get_list_open_buy_windows",
		terminal_state = 0,
		isPressedActionEnabled = true,
		remainBuyTimes = self._remainBuyTimes,
		buyPropCost = self._buyPropCost,
	}, nil, 0)

	-- 领取
	self.Button_collect = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collect"), nil,
	{
		terminal_name = "lim_pool_to_get_list_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		taskInfo = self._taskInfo,
	}, nil, 0)
end

function LimPoolToGetList:onEnterTransitionFinish()
	
end

function LimPoolToGetList:onInit(params)
	-- 加载LimPoolToGetListWindow界面资源.
	-- res.activity.lim_pool.lim_pool_to_get_list = res/activity/lim_pool/lim_pool_to_get_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_to_get_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/lim_pool/lim_pool_to_get_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if LimPoolToGetList.__size == nil then
		LimPoolToGetList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function LimPoolToGetList:onExit()
	-- 释放LimPoolToGetListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/lim_pool/lim_pool_to_get_list.csb", root)
	-- ]]
end

function LimPoolToGetList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LimPoolToGetList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/lim_pool/lim_pool_to_get_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
