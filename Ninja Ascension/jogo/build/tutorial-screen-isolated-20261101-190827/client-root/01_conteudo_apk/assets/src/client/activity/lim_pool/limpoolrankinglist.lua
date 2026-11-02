--[[ ----------------------------------------------------------------------------
-- 排行列表项
--]] ----------------------------------------------------------------------------
LimPoolRankingList = class("LimPoolRankingListClass", Window)
LimPoolRankingList.__size = nil

-- 创建Cell实例
local lim_pool_ranking_list_create_terminal = {
	_name = "lim_pool_ranking_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if LimPoolRankingList then
			local cell = LimPoolRankingList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_ranking_list_create_terminal)
state_machine.init()

-- 构造器
function LimPoolRankingList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.rankInfo = nil
	self._activityType = 0

	self.Image_rankings = {}
	-- load lua files.

	-- Initialize lim pool ranking list page state machine.
	local function init_lim_pool_ranking_list_terminal()
		
	end
	-- call func init lim pool ranking list state machine.
	init_lim_pool_ranking_list_terminal()
end

-- 对象初始化
function LimPoolRankingList:init(params)
	self.rankInfo = params[1]
	self._activityType = params[2]
	if self.rankInfo.index < 9 then
		self:onInit(params)
	end
	self:setContentSize(LimPoolRankingList.__size)
	return self
end

function LimPoolRankingList:updateRankUI()
	local rankNumber = tonumber(self.rankInfo.data.rank)
	self:showRankNumber(rankNumber)

	local nickname = self.rankInfo.data.nickname
	self.Text_ranking_name:setString(nickname)

	local score = self.rankInfo.data.score
	self.Text_ranking_point:setString(score)

	-- 跨服限时奖池需要展示玩家所在服务器

	if self.Text_ranking_fuwuqi ~= nil then
		if self._activityType == 188 then
			self.Text_ranking_fuwuqi:setString(GetServerNameByServerNumber(self.rankInfo.data.serverNumber))
		else
			self.Text_ranking_fuwuqi:setString("")
		end
	end

	self:updateRewards()
end

function LimPoolRankingList:updateRewards()
	local ListView_rewards = self.ListView_rewards
	ListView_rewards:removeAllItems()

	local rewards = self.rankInfo.data.rewards
	for _, v in pairs(rewards) do
		local cell = self:addResourcesIconCell(v)
		ListView_rewards:addChild(cell)
	end

	ListView_rewards:jumpToLeft()
	ListView_rewards:requestRefreshView()
end

function LimPoolRankingList:addResourcesIconCell(propData)
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

-- 显示对应的名次数字
function LimPoolRankingList:showRankNumber(rankNumber)
	for _, v in ipairs(self.Image_rankings) do
		v:setVisible(false)
	end
	self.Text_rank_list_my_raning:setVisible(false)

	if rankNumber <= 3 then
		self.Image_rankings[rankNumber]:setVisible(true)
	else
		self.Text_rank_list_my_raning:setVisible(true)
		self.Text_rank_list_my_raning:setString(""..rankNumber)
	end
end

function LimPoolRankingList:onUpdateDraw()
	local root = self.roots[1]

	-- 前三名名次图片
	self.Image_ranking_1 = ccui.Helper:seekWidgetByName(root, "Image_ranking_1")
	self.Image_ranking_2 = ccui.Helper:seekWidgetByName(root, "Image_ranking_2")
	self.Image_ranking_3 = ccui.Helper:seekWidgetByName(root, "Image_ranking_3")

	self.Image_rankings = {self.Image_ranking_1, self.Image_ranking_2, self.Image_ranking_3}

	-- 普通名次文本
	self.Text_rank_list_my_raning = ccui.Helper:seekWidgetByName(root, "Text_rank_list_my_raning")

	-- 名字
	self.Text_ranking_name = ccui.Helper:seekWidgetByName(root, "Text_ranking_name")

	-- 积分
	self.Text_ranking_point = ccui.Helper:seekWidgetByName(root, "Text_ranking_point")

	-- 服务器名
	self.Text_ranking_fuwuqi = ccui.Helper:seekWidgetByName(root, "Text_ranking_fuwuqi")

	-- 虚位以待图片
	self.Image_rank_list_no_people = ccui.Helper:seekWidgetByName(root, "Image_rank_list_no_people")

	-- 奖励
	self.ListView_rewards = ccui.Helper:seekWidgetByName(root, "ListView_rewards")

	self:updateRankUI()
end

function LimPoolRankingList:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Image_ranking_1 = ccui.Helper:seekWidgetByName(root, "Image_ranking_1")
	self.Image_ranking_1:setVisible(false)

	self.Image_ranking_2 = ccui.Helper:seekWidgetByName(root, "Image_ranking_2")
	self.Image_ranking_2:setVisible(false)

	self.Image_ranking_3 = ccui.Helper:seekWidgetByName(root, "Image_ranking_3")
	self.Image_ranking_3:setVisible(false)

	self.Image_rank_list_no_people = ccui.Helper:seekWidgetByName(root, "Image_rank_list_no_people")
	self.Image_rank_list_no_people:setVisible(false)

	self.Text_rank_list_my_raning = ccui.Helper:seekWidgetByName(root, "Text_rank_list_my_raning")
	self.Text_rank_list_my_raning:setString("")

	self.Text_ranking_name = ccui.Helper:seekWidgetByName(root, "Text_ranking_name")
	self.Text_ranking_name:setString("")

	self.Text_ranking_point = ccui.Helper:seekWidgetByName(root, "Text_ranking_point")
	self.Text_ranking_point:setString("")

	self.Text_ranking_fuwuqi = ccui.Helper:seekWidgetByName(root, "Text_ranking_fuwuqi")
	if self.Text_ranking_fuwuqi ~= nil then
		self.Text_ranking_fuwuqi:setString("")
	end

	self.ListView_rewards = ccui.Helper:seekWidgetByName(root, "ListView_rewards")
	self.ListView_rewards:removeAllItems()
end

function LimPoolRankingList:onEnterTransitionFinish()
	
end

function LimPoolRankingList:onInit(params)
	-- 加载LimPoolRankingListWindow界面资源.
	-- res.activity.lim_pool.lim_pool_ranking_list = res/activity/lim_pool/lim_pool_ranking_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_ranking_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/lim_pool/lim_pool_ranking_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if LimPoolRankingList.__size == nil then
		LimPoolRankingList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function LimPoolRankingList:onExit()
	-- 释放LimPoolRankingListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/lim_pool/lim_pool_ranking_list.csb", root)
	-- ]]
end

function LimPoolRankingList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LimPoolRankingList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/lim_pool/lim_pool_ranking_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
