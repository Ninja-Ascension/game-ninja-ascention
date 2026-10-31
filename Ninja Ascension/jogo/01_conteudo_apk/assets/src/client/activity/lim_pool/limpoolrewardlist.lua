--[[ ----------------------------------------------------------------------------
-- 主界面排行奖励列表项
--]] ----------------------------------------------------------------------------
LimPoolRewardList = class("LimPoolRewardListClass", Window)
LimPoolRewardList.__size = nil

-- 创建Cell实例
local lim_pool_reward_list_create_terminal = {
	_name = "lim_pool_reward_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if LimPoolRewardList then
			local cell = LimPoolRewardList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_reward_list_create_terminal)
state_machine.init()

-- 构造器
function LimPoolRewardList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._info = nil

	-- load lua files.
	app.load("client.activity.lim_pool.limpoolrewardiconlist")

	-- Initialize lim pool ranking list main page state machine.
	local function init_lim_pool_reward_list_terminal()
		
	end
	-- call func init lim pool ranking list main state machine.
	init_lim_pool_reward_list_terminal()
end

-- 对象初始化
function LimPoolRewardList:init(params)
	self._info = params

	self:onInit(params)
	self:setContentSize(LimPoolRewardList.__size)
	return self
end

function LimPoolRewardList:updateUI()
	local info = self._info

	local minIndex = tonumber(info.minIndex)
	local maxIndex = tonumber(info.maxIndex)

	local rankStr = (maxIndex == minIndex) and maxIndex or (maxIndex .. "-" .. minIndex)
	self.Text_ranking:setString(string.format(tipStringInfo_activity_limit_pool[1], rankStr))

	self:updateRewardList()
end

function LimPoolRewardList:updateRewardList()
	local tempStr = self._info.indexRankReward
	local rewards = zstring.splits(tempStr, "|", ",")

	local ListView_reward = self.ListView_reward
	ListView_reward:removeAllItems()
	
	for _, v in pairs(rewards) do
		local cell = state_machine.excute("lim_pool_reward_icon_list_create", 0, v)
		ListView_reward:addChild(cell)
	end

	ListView_reward:jumpToLeft()
	ListView_reward:requestRefreshView()
end

function LimPoolRewardList:onUpdateDraw()
	local root = self.roots[1]

	-- 道具列表
	self.ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")

	-- 名次
	self.Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")

	self:updateUI()
end

function LimPoolRewardList:onEnterTransitionFinish()
	
end

function LimPoolRewardList:onInit(params)
	-- 加载LimPoolRewardListWindow界面资源.
	-- res.activity.lim_pool.lim_pool_reward_list = res/activity/lim_pool/lim_pool_reward_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_reward_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/lim_pool/lim_pool_reward_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if LimPoolRewardList.__size == nil then
		LimPoolRewardList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function LimPoolRewardList:onExit()
	-- 释放LimPoolRewardListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/lim_pool/lim_pool_reward_list.csb", root)
	-- ]]
end

function LimPoolRewardList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LimPoolRewardList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/lim_pool/lim_pool_reward_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
