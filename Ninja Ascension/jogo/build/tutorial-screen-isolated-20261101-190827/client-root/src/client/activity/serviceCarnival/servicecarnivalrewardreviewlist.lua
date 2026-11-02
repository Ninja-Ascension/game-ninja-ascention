--[[ ----------------------------------------------------------------------------
-- 列表容器cell
--]] ----------------------------------------------------------------------------
ServiceCarnivalRewardReviewList = class("ServiceCarnivalRewardReviewListClass", Window)
ServiceCarnivalRewardReviewList.__size = nil

-- 创建Cell实例
local service_carnival_reward_review_list_create_terminal = {
	_name = "service_carnival_reward_review_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ServiceCarnivalRewardReviewList then
			local cell = ServiceCarnivalRewardReviewList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnival_reward_review_list_create_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalRewardReviewList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.index = 1
	self.rankNum = 1			-- 当前排名阶段
	self.curLevel = 1			-- 排名等级
	self.m_type = 1				-- 当前类型
	
	self.rewardInfo = {}		-- 奖励预览信息
	self.SpriteRankList = {}		-- 排名底板
	-- load lua files.

	-- Initialize service carnival reward review list page state machine.
	local function init_service_carnival_reward_review_list_terminal()
		
	end
	-- call func init service carnival reward review list state machine.
	init_service_carnival_reward_review_list_terminal()
end

function ServiceCarnivalRewardReviewList:updateDrawContent()
	
	local rankIcon = nil
	for i = 1 , 4 do
		self.SpriteRankList[i]:setVisible(false)
	end
	self.Text_review_ph_st:setVisible(false)
	self.ListView_rewards:removeAllItems()
	if self.rankNum <= 3 then
		self.SpriteRankList[self.rankNum]:setVisible(true)
	else
		self.SpriteRankList[4]:setVisible(true)
	end
	if self.rankNum == self.curLevel then
		local state = zstring.split(self.rewardInfo , ":")
		local rankTextInfo = zstring.split(state[1], "-")
		if tonumber(rankTextInfo[1]) == 1 and tonumber(rankTextInfo[2]) == 1 then
			self.Text_review_ph_st:setVisible(false)
		else
			self.Text_review_ph_st:setVisible(true)
			self.Text_review_ph_st:setString(state[1].."")
		end
		self.Text_review_ph_st:setString(state[1].."")
		local rewardInfos = zstring.split(state[2], "|")
		for i, v in ipairs(rewardInfos) do
			local reward = zstring.split(v, ",")
			local cell = DrawHandle.drawIcon(reward)
			self.ListView_rewards:addChild(cell)
		end
	else
		-- 绘制最后一名奖励
		local rewardString = dms.string(dms["activity_config"] , 98 , activity_config.param)
		local rewardInfos = zstring.split(rewardString , "@")
		local reward = rewardInfos[self.m_type]
		local cells = DrawHandle.drawIcons(reward)
		for i, v in ipairs(cells) do
			self.ListView_rewards:addChild(v)
		end
		local state = zstring.split(self.rewardInfo , ":")
		local rankTextInfo = zstring.split(state[1], "-")
		local text = tonumber(rankTextInfo[2]) + 1
		self.Text_review_ph_st:setString(string.format(_new_interface_text[330],text))
		self.Text_review_ph_st:setVisible(true)
	end
	self.ListView_rewards:requestRefreshView()
end

-- 对象初始化
function ServiceCarnivalRewardReviewList:init(params)
	self.rewardInfo = params.rewardInfo
	self.rankNum = params.rankNum
	self.index = params.index
	self.curLevel = params.curLevel
	self.m_type = params.type
	if self.index <= 4 then
		self:onInit()
	end
	self:setContentSize(ServiceCarnivalRewardReviewList.__size)
	return self
end

function ServiceCarnivalRewardReviewList:onUpdateDraw()
	local root = self.roots[1]
	self.SpriteRankList = {}

	-- 第一名底板
	self.Image_rank_gold = ccui.Helper:seekWidgetByName(root, "Image_rank_gold")
	table.insert(self.SpriteRankList , self.Image_rank_gold)

	-- 第二名底板
	self.Image_rank_silver = ccui.Helper:seekWidgetByName(root, "Image_rank_silver")
	table.insert(self.SpriteRankList , self.Image_rank_silver)

	-- 第三名底板
	self.Image_rank_copper = ccui.Helper:seekWidgetByName(root, "Image_rank_copper")
	table.insert(self.SpriteRankList , self.Image_rank_copper)

	-- 常规底板
	self.Image_rank_normal = ccui.Helper:seekWidgetByName(root, "Image_rank_normal")
	table.insert(self.SpriteRankList , self.Image_rank_normal)

	-- 排行名次
	self.Text_review_ph_st = ccui.Helper:seekWidgetByName(root, "Text_review_ph_st")

	-- 獎勵列表容器
	self.ListView_rewards = ccui.Helper:seekWidgetByName(root, "ListView_rewards")

	self:updateDrawContent()
end

function ServiceCarnivalRewardReviewList:onEnterTransitionFinish()
	
end

function ServiceCarnivalRewardReviewList:onInit()
	-- 加载ServiceCarnivalRewardReviewListWindow界面资源.
	-- res.activity.service_carnival.service_carnival_reward_review_list = res/activity/service_carnival/service_carnival_reward_review_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_reward_review_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/service_carnival/service_carnival_reward_review_list.csb", "root")
	-- ]]
	-- root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)

	if ServiceCarnivalRewardReviewList.__size == nil then
		ServiceCarnivalRewardReviewList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function ServiceCarnivalRewardReviewList:clearUIInfo(...)
	local root = self.roots[1]
	if root == nil then
		return
	end
	-- 第一名底板
	local Image_rank_gold = ccui.Helper:seekWidgetByName(root, "Image_rank_gold")

	-- 第二名底板
	local Image_rank_silver = ccui.Helper:seekWidgetByName(root, "Image_rank_silver")

	-- 第三名底板
	local Image_rank_copper = ccui.Helper:seekWidgetByName(root, "Image_rank_copper")

	-- 常规底板
	local Image_rank_normal = ccui.Helper:seekWidgetByName(root, "Image_rank_normal")

	-- 排行名次
	local Text_review_ph_st = ccui.Helper:seekWidgetByName(root, "Text_review_ph_st")

	-- 獎勵列表容器
	local ListView_rewards = ccui.Helper:seekWidgetByName(root, "ListView_rewards")

	if ListView_rewards ~= nil then
		ListView_rewards:removeAllItems()
		Image_rank_gold:setVisible(false)
		Image_rank_silver:setVisible(false)
		Image_rank_copper:setVisible(false)
		Image_rank_normal:setVisible(false)
		Text_review_ph_st:setString("")
	end
end

function ServiceCarnivalRewardReviewList:onExit()
	-- 释放ServiceCarnivalRewardReviewListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	self:clearUIInfo()
	cacher.freeRef("activity/service_carnival/service_carnival_reward_review_list.csb", root)
	-- ]]
end

function ServiceCarnivalRewardReviewList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ServiceCarnivalRewardReviewList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/service_carnival/service_carnival_reward_review_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
