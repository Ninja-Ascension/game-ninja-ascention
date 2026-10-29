--[[ ----------------------------------------------------------------------------
-- 主界面排行列表项
--]] ----------------------------------------------------------------------------
LimPoolRankingListMain = class("LimPoolRankingListMainClass", Window)
LimPoolRankingListMain.__size = nil

-- 创建Cell实例
local lim_pool_ranking_list_main_create_terminal = {
	_name = "lim_pool_ranking_list_main_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if LimPoolRankingListMain then
			local cell = LimPoolRankingListMain:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_ranking_list_main_create_terminal)
state_machine.init()

-- 构造器
function LimPoolRankingListMain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._info = nil
	self._activityType = 0
	-- load lua files.

	-- Initialize lim pool ranking list main page state machine.
	local function init_lim_pool_ranking_list_main_terminal()
		
	end
	-- call func init lim pool ranking list main state machine.
	init_lim_pool_ranking_list_main_terminal()
end

-- 对象初始化
function LimPoolRankingListMain:init(params)
	self._info = params.rankInfo
	self._activityType = params._activityType

	self:onInit(params)
	self:setContentSize(LimPoolRankingListMain.__size)
	return self
end

function LimPoolRankingListMain:updateUI()
	local info = self._info

	self.Text_player_name:setString(info.nickname)
	self.Text_point:setString(info.score)
	self.Text_ranking:setString(string.format(tipStringInfo_activity_limit_pool[1], info.rank))

	-- 跨服限时奖池需要展示玩家所在服务器
	if self.Text_ranking_fuwuqi ~= nil then
		if self._activityType == 188 then
			self.Text_ranking_fuwuqi:setString(GetServerNameByServerNumber(self._info.serverNumber))
		else
			self.Text_ranking_fuwuqi:setString("")
		end
	end
end

function LimPoolRankingListMain:onUpdateDraw()
	local root = self.roots[1]

	-- 玩家名字
	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")

	-- 积分
	self.Text_point = ccui.Helper:seekWidgetByName(root, "Text_point")

	-- 名次
	self.Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	
	-- 服务器名
	self.Text_ranking_fuwuqi = ccui.Helper:seekWidgetByName(root, "Text_ranking_fuwuqi")

	self:updateUI()
end

function LimPoolRankingListMain:onEnterTransitionFinish()
	
end

function LimPoolRankingListMain:onInit(params)
	-- 加载LimPoolRankingListMainWindow界面资源.
	-- res.activity.lim_pool.lim_pool_ranking_list_main = res/activity/lim_pool/lim_pool_ranking_list_main.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_ranking_list_main.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/lim_pool/lim_pool_ranking_list_main.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if LimPoolRankingListMain.__size == nil then
		LimPoolRankingListMain.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function LimPoolRankingListMain:onExit()
	-- 释放LimPoolRankingListMainWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/lim_pool/lim_pool_ranking_list_main.csb", root)
	-- ]]
end

function LimPoolRankingListMain:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LimPoolRankingListMain:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/lim_pool/lim_pool_ranking_list_main.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
