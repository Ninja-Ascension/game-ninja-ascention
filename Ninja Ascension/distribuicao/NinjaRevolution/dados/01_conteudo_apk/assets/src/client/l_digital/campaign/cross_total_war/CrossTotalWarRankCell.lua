--[[ ----------------------------------------------------------------------------
-- 排行榜控件
--]] ----------------------------------------------------------------------------
CrossTotalWarRankCell = class("CrossTotalWarRankCellClass", Window)
CrossTotalWarRankCell.__size = nil

-- 创建Cell实例
local cross_total_war_rank_cell_create_terminal = {
	_name = "cross_total_war_rank_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CrossTotalWarRankCell then
			local cell = CrossTotalWarRankCell:new()
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

state_machine.add(cross_total_war_rank_cell_create_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarRankCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize activity luck rank cell page state machine.
	local function init_cross_total_war_rank_cell_terminal()
		
	end
	-- call func init activity luck rank cell state machine.
	init_cross_total_war_rank_cell_terminal()
end

-- 对象初始化
function CrossTotalWarRankCell:init(params)
	self.playerData = params
	if self.playerData.rank < 4 then
		self:onInit(params)
	end
	self:setContentSize(CrossTotalWarRankCell.__size)
	return self
end

function CrossTotalWarRankCell:onUpdateDraw()
	local root = self.roots[1]
	self.Text_ranking = ccui.Helper:seekWidgetByName(root,"Text_ranking")
	local rankt = zstring.split(self.playerData.reward[3], ",")
	local str = ''
	if tonumber(self.playerData.type) == 4 then
		str = dms.element(dms["word_mould"], 13517)[3] 
	elseif tonumber(self.playerData.type) == 5 then
		str = dms.element(dms["word_mould"], 13516)[3] 
	else
		if rankt[1] == rankt[2] then
			local word_info = dms.element(dms["word_mould"], 65201)
			str = string.format(word_info[3], rankt[1])
			self.Text_ranking:setString(str)
		else
			local word_info = dms.element(dms["word_mould"], 65200)
			str = string.format(word_info[3],rankt[1],rankt[2])
		end
	end
	
	self.Text_ranking:setString(str)

	self.ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")
	
	self.ListView_reward:removeAllItems()
	self.ListView_reward:removeAllChildren(true)
	local myReworld = nil
	if self.playerData.reward ~= nil then
		myReworld = zstring.splits(self.playerData.reward[4], "|", ",")
		for i,v in pairs(myReworld) do
			local prop_data = v
			local cell = ResourcesIconCell:createCell()
			cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,{shipStar=prop_data[4]})
			-- cell:setScale(0.7)
			-- cell:setAnchorPoint(0,0.5)
			self.ListView_reward:addChild(cell)
		end
		-- self.ListView_reward:setItemsMargin(-50)
		self.ListView_reward:requestRefreshView()
	end
	-- fwin:addTouchEventListener(self.roots[1], nil,
	-- {
	-- 	terminal_name = "activity_luck_rank_personal_information_open",
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true,
	-- 	cell = self,
	-- }, nil, 0)	
end

function CrossTotalWarRankCell:onEnterTransitionFinish()
	
end

function CrossTotalWarRankCell:onInit(params)
	-- 加载CrossTotalWarRankCellWindow界面资源.
	-- cells.activity.cross_total_war_rank_cell = campaign/cross_total_war/cross_total_war_preview_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_preview_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/cross_total_war/cross_total_war_preview_list.csb", "root")
	-- ]]
	
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CrossTotalWarRankCell.__size == nil then
		CrossTotalWarRankCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CrossTotalWarRankCell:onExit()
	-- 释放CrossTotalWarRankCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/cross_total_war/cross_total_war_preview_list.csb", root)
	-- ]]
end

function CrossTotalWarRankCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CrossTotalWarRankCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self.ListView_reward:removeAllItems()
	self.ListView_reward:removeAllChildren(true)
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("campaign/cross_total_war/cross_total_war_preview_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
