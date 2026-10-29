--[[ ----------------------------------------------------------------------------
-- 排行榜控件
--]] ----------------------------------------------------------------------------
ActivityLuckRankCell = class("ActivityLuckRankCellClass", Window)
ActivityLuckRankCell.__size = nil

-- 创建Cell实例
local activity_luck_rank_cell_create_terminal = {
	_name = "activity_luck_rank_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ActivityLuckRankCell then
			local cell = ActivityLuckRankCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local activity_luck_rank_personal_information_open_terminal = {
	_name = "activity_luck_rank_personal_information_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local cell = params._datas.cell
		if _ED.ranking_item_info ~= nil and _ED.ranking_item_info.ranking_hero ~= nil then
			_ED.ranking_item_info = nil
		end
		local function responseRankingItemInfoCallback(response)
			
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				state_machine.excute("rank_personal_information_tips_window_open", 0, {_ED.ranking_item_info})
			else
				-- debug.log("rank_personal_information_tips_window_open-error")
			end
		end
		protocol_command.act_divination_ranking_item_info.param_list = {uuid=_ED.uuid,token=_ED.token,handle=protocol_command.act_divination_ranking_item_info.command,data = {nick_name = cell.playerData.name}}
		NetworkManager:register(protocol_command.act_divination_ranking_item_info.code, nil, nil, nil, self, responseRankingItemInfoCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(activity_luck_rank_personal_information_open_terminal)

state_machine.add(activity_luck_rank_cell_create_terminal)
state_machine.init()

-- 构造器
function ActivityLuckRankCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize activity luck rank cell page state machine.
	local function init_activity_luck_rank_cell_terminal()
		
	end
	-- call func init activity luck rank cell state machine.
	init_activity_luck_rank_cell_terminal()
end

-- 对象初始化
function ActivityLuckRankCell:init(params)
	self.playerData = params
	if self.playerData.rank < 4 then
		self:onInit(params)
	end
	self:setContentSize(ActivityLuckRankCell.__size)
	return self
end

function ActivityLuckRankCell:onUpdateDraw()
	local root = self.roots[1]
	self.Text_activity_name = ccui.Helper:seekWidgetByName(root, "Text_activity_name")
	self.Image_no_people = ccui.Helper:seekWidgetByName(root, "Image_no_people")
	self.Text_activity_number = ccui.Helper:seekWidgetByName(root, "Text_activity_number")
	if self.playerData.rankInfo ~= nil then
		-- 玩家名称（自己上榜名称颜色为R:213 G:85 B:9 ）
		self.Image_no_people:setVisible(false)
		self.Text_activity_name:setString(self.playerData.rankInfo.nickName)
		
		if self.playerData.rankInfo.nickName==_ED.user_info.user_name then
			self.Text_activity_name:setColor(cc.c3b(213, 85, 9))
		else
			self.Text_activity_name:setColor(cc.c3b(117, 75, 50))
		end	

		-- 数字（自己上榜名称颜色为R:213 G:85 B:9 ）
		
		self.Text_activity_number:setString(self.playerData.rankInfo.divineNum)
		if self.playerData.nickName==_ED.user_info.user_name then
			self.Text_activity_number:setColor(cc.c3b(213, 85, 9))
		else
			self.Text_activity_number:setColor(cc.c3b(117, 75, 50))
		end	
	else
		self.Text_activity_name:setString("")
		self.Text_activity_number:setString("")
		self.Image_no_people:setVisible(true)
	end

	-- 图标
	self.Text_activity_rank_number = ccui.Helper:seekWidgetByName(root, "Text_activity_rank_number")
	self.Text_activity_rank_number:setString("")

	self.Image_ranking_3 = ccui.Helper:seekWidgetByName(root, "Image_ranking_3")
	self.Image_ranking_2 = ccui.Helper:seekWidgetByName(root, "Image_ranking_2")
	self.Image_ranking_1 = ccui.Helper:seekWidgetByName(root, "Image_ranking_1")
	self.Text_my_raning = ccui.Helper:seekWidgetByName(root, "Text_my_raning")
	self.Panel_activity_rank = ccui.Helper:seekWidgetByName(root, "Panel_activity_rank")

	-- if self.Text_activity_rank_number._s == nil then
	-- 	self.Text_activity_rank_number._s = self.Text_activity_rank_number:getString()
	-- end
	-- self.Text_activity_rank_number:setString(string.format(self.Text_activity_rank_number._s, self.playerData.rank))
	
	


	self.Image_ranking_1:setVisible(false)
	self.Image_ranking_2:setVisible(false)
	self.Image_ranking_3:setVisible(false)
	self.m_index = tonumber(self.playerData.rank)
	if self.m_index <= 3 then
		self.Text_my_raning:setString("")
		if self.m_index == 1 then
			self.Image_ranking_1:setVisible(true)
		end
		if self.m_index == 2 then
			self.Image_ranking_2:setVisible(true)
		end
		if self.m_index == 3 then
			self.Image_ranking_3:setVisible(true)
		end
	else
		self.Text_my_raning:setString(self.m_index)
	end
	self.Panel_activity_rank:removeAllItems()
	self.Panel_activity_rank:removeAllChildren(true)
	local myReworld = nil
	if self.playerData.reward ~= nil then
		myReworld = zstring.splits(self.playerData.reward, "|", ",")
		for i,v in pairs(myReworld) do
			local prop_data = v
			local cell = ResourcesIconCell:createCell()
			cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,{shipStar=prop_data[4]})
			cell:setScale(0.7)
			cell:setAnchorPoint(0,0.5)
			self.Panel_activity_rank:addChild(cell)
		end
		self.Panel_activity_rank:setItemsMargin(-50)
		self.Panel_activity_rank:requestRefreshView()
	end
	-- fwin:addTouchEventListener(self.roots[1], nil,
	-- {
	-- 	terminal_name = "activity_luck_rank_personal_information_open",
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true,
	-- 	cell = self,
	-- }, nil, 0)	
end

function ActivityLuckRankCell:onEnterTransitionFinish()
	
end

function ActivityLuckRankCell:onInit(params)
	-- 加载ActivityLuckRankCellWindow界面资源.
	-- cells.activity.activity_luck_rank_cell = cells/activity/activity_luck_rank_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cells/activity/activity_luck_rank_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("Lucky/activity_luck_rank_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if ActivityLuckRankCell.__size == nil then
		ActivityLuckRankCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function ActivityLuckRankCell:onExit()
	-- 释放ActivityLuckRankCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cells/activity/activity_luck_rank_cell.csb", root)
	-- ]]
end

function ActivityLuckRankCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ActivityLuckRankCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cells/activity/activity_luck_rank_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
