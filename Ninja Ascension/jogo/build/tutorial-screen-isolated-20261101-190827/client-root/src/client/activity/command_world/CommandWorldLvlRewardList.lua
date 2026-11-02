--[[ ----------------------------------------------------------------------------
-- 获取窗口列表项
--]] ----------------------------------------------------------------------------
CommandWorldLvlRewardList = class("CommandWorldLvlRewardListClass", Window)
CommandWorldLvlRewardList.__size = nil

-- 创建Cell实例
local command_world_lvl_reward_list_create_terminal = {
	_name = "command_world_lvl_reward_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommandWorldLvlRewardList then
			local cell = CommandWorldLvlRewardList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_lvl_reward_list_create_terminal)
state_machine.init()

-- 构造器
function CommandWorldLvlRewardList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._data = nil

	-- load lua files.

	-- Initialize lim pool to get list page state machine.
	local function init_command_world_lvl_reward_list_terminal()
		-- 领取奖励
		local command_world_lvl_reward_list_get_reward_terminal = {
			_name = "command_world_lvl_reward_list_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local data = params._datas.data
				-- 工会积分奖励 类型1
				local taskType = 1
				local index = data.index

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(7)
						fwin:open(getRewardWnd, fwin._ui)

						-- 刷新红点
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 174)
						-- 刷新道具的数量
						state_machine.excute("command_world_refresh_top_prop_num", 0, nil)
						-- 领取完刷新界面
						state_machine.excute("command_world_lvl_reward_refresh", 0, nil)
					end
				end
				protocol_command.activity_orders_world_get_reward.param_list = "" .. taskType .. "\r\n" .. (index - 1)
				NetworkManager:register(protocol_command.activity_orders_world_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(command_world_lvl_reward_list_get_reward_terminal)
	end
	-- call func init lim pool to get list state machine.
	init_command_world_lvl_reward_list_terminal()
end

-- 对象初始化
function CommandWorldLvlRewardList:init(params)
	self._index = params.index
	self._data = params.data

	-- if self._index <= 6 then
		self:onInit(params)
	-- end
	self:setContentSize(CommandWorldLvlRewardList.__size)
	return self
end

function CommandWorldLvlRewardList:updateUI()
	self.Text_name_lv:setString(string.format(tipStringInfo_command_world[4], self._data.level))
	self.Text_point:setString(self._data.score)

	local rewardState = self._data.rewardState
	self.Button_lq:setVisible(rewardState ~= 2)
	self.Button_lq:setTouchEnabled(rewardState == 1)
	self.Button_lq:setBright(rewardState ~= 0)

	self.Image_ylq:setVisible(rewardState == 2)

	self:updateRewardList()
end

function CommandWorldLvlRewardList:updateRewardList()
	local rewardData = CommandWorldHandle.getCommandWorldUnionScoreRewardsInfo(self._data.level)
	
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	for _, v in pairs(rewardData) do
		local cell = self:addResourcesIconCell(v)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToLeft()
	ListView_1:requestRefreshView()
end

function CommandWorldLvlRewardList:addResourcesIconCell(propData)
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

function CommandWorldLvlRewardList:onUpdateDraw()
	local root = self.roots[1]

	self.Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")
	self.Text_point = ccui.Helper:seekWidgetByName(root, "Text_point")

	-- 奖励
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 已领取
	self.Image_ylq = ccui.Helper:seekWidgetByName(root, "Image_ylq")

	-- 领取
	self.Button_lq = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lq"), nil,
	{
		terminal_name = "command_world_lvl_reward_list_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		data = self._data,
	}, nil, 0)

	self:updateUI()
end

function CommandWorldLvlRewardList:onEnterTransitionFinish()
	
end

function CommandWorldLvlRewardList:onInit(params)
	-- 加载CommandWorldLvlRewardListWindow界面资源.
	-- res.activity.command_world.command_world_lvl_reward_list = res/activity/command_world/command_world_lvl_reward_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/command_world/command_world_lvl_reward_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/command_world/command_world_lvl_reward_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommandWorldLvlRewardList.__size == nil then
		CommandWorldLvlRewardList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CommandWorldLvlRewardList:onExit()
	-- 释放CommandWorldLvlRewardListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/command_world/command_world_lvl_reward_list.csb", root)
	-- ]]
end

function CommandWorldLvlRewardList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommandWorldLvlRewardList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/command_world/command_world_lvl_reward_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
