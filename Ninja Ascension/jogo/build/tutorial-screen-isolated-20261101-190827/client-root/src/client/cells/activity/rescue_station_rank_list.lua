--[[ ----------------------------------------------------------------------------
-- 救助排名界面列表控件
--]] ----------------------------------------------------------------------------
RescueStationRankList = class("RescueStationRankListClass", Window)
RescueStationRankList.__size = nil

-- 创建Cell实例
local rescue_station_rank_list_create_terminal = {
	_name = "rescue_station_rank_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RescueStationRankList then
			local cell = RescueStationRankList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_rank_list_create_terminal)
state_machine.init()

-- 构造器
function RescueStationRankList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	local function init_rescue_station_rank_list_terminal()
		
	end
	-- call func init rescue station rank list state machine.
	init_rescue_station_rank_list_terminal()
end

-- 对象初始化
function RescueStationRankList:init(params)
	self._info = params[1]
	self:onInit(params)
	self:setContentSize(RescueStationRankList.__size)
	return self
end

function RescueStationRankList:onUpdateDraw()
	local root = self.roots[1]
   
	-- 第三名开启隐藏
	self.Image_ranking_c = ccui.Helper:seekWidgetByName(root, "Image_ranking_c")
	self.Image_ranking_c:setVisible(false)
	if 1 == tonumber(self._info.rank) or 2 == tonumber(self._info.rank) or 3 == tonumber(self._info.rank)then 
		if tonumber(self._info.rank) == 3 then
			self.Image_ranking_c:setVisible(true)
		end
		-- 第二名开启隐藏
		self.Image_ranking_b = ccui.Helper:seekWidgetByName(root, "Image_ranking_b")
		self.Image_ranking_b:setVisible(false)
		if tonumber(self._info.rank) == 2 then
			self.Image_ranking_b:setVisible(true)
		end
		-- 第一名开启隐藏
		self.Image_ranking_a = ccui.Helper:seekWidgetByName(root, "Image_ranking_a")
		self.Image_ranking_a:setVisible(false)
		if tonumber(self._info.rank) == 1 then
			self.Image_ranking_a:setVisible(true)
		end
	else
		-- 名次
		self.Text_rank_list_my_raning = ccui.Helper:seekWidgetByName(root, "Text_rank_list_my_raning")
		self.Text_rank_list_my_raning:setString(self._info.rank)
	end
    
	-- 角色名
	self.Text_ranking_info_a = ccui.Helper:seekWidgetByName(root, "Text_ranking_info_a")
	self.Text_ranking_info_a:setString(self._info.info.nickname)

	-- 服务器
	self.Text_ranking_info_b = ccui.Helper:seekWidgetByName(root, "Text_ranking_info_b")
    self.Text_ranking_info_b:setString(self._info.info.serverName)
    
    -- 积分
    self.Text_ranking_info_c = ccui.Helper:seekWidgetByName(root, "Text_ranking_info_c")
    self.Text_ranking_info_c:setString(self._info.info.score)
    
end

function RescueStationRankList:onEnterTransitionFinish()
	
end

function RescueStationRankList:onInit(params)
	-- 加载RescueStationRankListWindow界面资源.
	-- res.activity.rescue_station_rank_list = res/activity/rescue_station_rank_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/ue_station_rank_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/rescue_station/rescue_station_rank_list.csb", "root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RescueStationRankList.__size == nil then
		RescueStationRankList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RescueStationRankList:onExit()
	-- 释放RescueStationRankListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/ue_station_rank_list.csb", root)
	-- ]]
end

function RescueStationRankList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RescueStationRankList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/ue_station_rank_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
