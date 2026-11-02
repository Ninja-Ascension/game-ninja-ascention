--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
CommandWorldRewardCell = class("CommandWorldRewardCellClass", Window)
CommandWorldRewardCell.__size = nil

-- 创建Cell实例
local command_world_reward_cell_create_terminal = {
	_name = "command_world_reward_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommandWorldRewardCell then
			local cell = CommandWorldRewardCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_reward_cell_create_terminal)
state_machine.init()

-- 构造器
function CommandWorldRewardCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies report list page state machine.
	local function init_command_world_reward_cell_terminal()
		
	end
	-- call func init ninja biographies report list state machine.
	init_command_world_reward_cell_terminal()
end

-- 对象初始化
function CommandWorldRewardCell:init(params)
	self._index = params.index
	self._rankType = params.rankType

	if self._index < 8 then
		self:onInit(params)
	end
	self:setContentSize(CommandWorldRewardCell.__size)
	return self
end

function CommandWorldRewardCell:onUpdateDraw()
	local root = self.roots[1]

	for i = 1, 3 do
		local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no_"..i)
		Image_no:setVisible(false)
	end

	local Image_ranking = ccui.Helper:seekWidgetByName(root, "Image_ranking")
	Image_ranking:setVisible(false)

	-- self._index 即 为排名
	local data = CommandWorldHandle.getCommandWorldRankInfoByRank(self._index)

	local rank = self._index
	if rank <= 3 then
		local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no_"..rank)
		Image_no:setVisible(true)
	else
		Image_ranking:setVisible(true)
		local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
		Text_ranking:setString(rank)
	end

	local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	local Image_14 = ccui.Helper:seekWidgetByName(root, "Image_14")
	if data then
		local rankInfo = data.rankInfo
		--玩家昵称
		local Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")

		-- 跨服
		if self._rankType == 1 then
			local serverNumber = GetServerNameByServerNumber(rankInfo.serverNumber)
			local serverNumberStr = "(" .. serverNumber .. ")"
			
			Text_name_lv:setString(serverNumberStr .. rankInfo.nickName)
		else
			Text_name_lv:setString(rankInfo.nickName)
		end
		
		--公会名称
		local Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
		Text_1_0:setString(rankInfo.unionName)
		
		--积分
		local Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")
		Text_2_0:setString(rankInfo.score)

		Panel_1:setVisible(true)
		Image_14:setVisible(false)
	else
		Panel_1:setVisible(false)
		Image_14:setVisible(true)
	end

	-- 本服、跨服个人奖励
	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ListView_1:removeAllItems()

	local reward1 = self._rankType == 0 and CommandWorldHandle.getCommandWorldSingleServerPersonRankRewardsInfo(rank) or CommandWorldHandle.getCommandWorldCrossServerPersonRankRewardsInfo(rank)
	for _, v in pairs(reward1) do
		local cell = self:addResourcesIconCell(v)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToLeft()
	ListView_1:requestRefreshView()

	-- 本服公会奖励、跨服全服奖励
	local ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
	ListView_2:removeAllItems()

	local reward2 = self._rankType == 0 and CommandWorldHandle.getCommandWorldSingleServerUnionRankRewardsInfo(rank) or CommandWorldHandle.getCommandWorldCrossServerRankRewardsInfo(rank)
	for _, v in pairs(reward2) do
		local cell = self:addResourcesIconCell(v)
		ListView_2:addChild(cell)
	end

	ListView_2:jumpToLeft()
	ListView_2:requestRefreshView()
end

function CommandWorldRewardCell:addResourcesIconCell(propData)
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

function CommandWorldRewardCell:onEnterTransitionFinish()
	
end

function CommandWorldRewardCell:onInit(params)
	-- 加载CommandWorldRewardCellWindow界面资源.
	-- res.activity.command_world.command_world_reward_cell = res/activity/command_world/command_world_reward_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/command_world/command_world_reward_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/command_world/command_world_reward_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommandWorldRewardCell.__size == nil then
		CommandWorldRewardCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function CommandWorldRewardCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	for i = 1, 3 do
		local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no_"..i)
		Image_no:setVisible(false)
	end

	local Image_ranking = ccui.Helper:seekWidgetByName(root, "Image_ranking")
	Image_ranking:setVisible(false)

	local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	Text_ranking:setString("")

	local Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")
	Text_name_lv:setString("")

	local Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	Text_1_0:setString("")

	local Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")
	Text_2_0:setString("")

	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ListView_1:removeAllItems()

	local ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
	ListView_2:removeAllItems()
end

function CommandWorldRewardCell:onExit()
	-- 释放CommandWorldRewardCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/command_world/command_world_reward_cell.csb", root)
	-- ]]
end

function CommandWorldRewardCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommandWorldRewardCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/command_world/command_world_reward_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
