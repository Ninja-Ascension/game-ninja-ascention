--[[ ----------------------------------------------------------------------------
-- 排行榜控件
--]] ----------------------------------------------------------------------------
ActivityLuckRecordCell = class("ActivityLuckRecordCellClass", Window)
ActivityLuckRecordCell.__size = nil

-- 创建Cell实例
local activity_luck_record_cell_create_terminal = {
	_name = "activity_luck_record_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ActivityLuckRecordCell then
			local cell = ActivityLuckRecordCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local activity_luck_record_personal_information_open_terminal = {
	_name = "activity_luck_record_personal_information_open",
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
state_machine.add(activity_luck_record_personal_information_open_terminal)

state_machine.add(activity_luck_record_cell_create_terminal)
state_machine.init()

-- 构造器
function ActivityLuckRecordCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize activity luck rank cell page state machine.
	local function init_activity_luck_record_cell_terminal()
		
	end
	-- call func init activity luck rank cell state machine.
	init_activity_luck_record_cell_terminal()
end

-- 对象初始化
function ActivityLuckRecordCell:init(params)
	self.playerData = params[2]
	self.rank = tonumber(params[1])
	if self.rank < 4 then
		self:onInit(params)
	end
	self:setContentSize(ActivityLuckRecordCell.__size)
	return self
end

function ActivityLuckRecordCell:onUpdateDraw()
	local root = self.roots[1]
	
	-- 玩家名称（自己上榜名称颜色为R:213 G:85 B:9 ）
	self.Text_my_raning = ccui.Helper:seekWidgetByName(root, "Text_my_raning")
	self.Text_activity_number = ccui.Helper:seekWidgetByName(root, "Text_activity_number")
	self.Text_activity_shijian = ccui.Helper:seekWidgetByName(root, "Text_activity_shijian")
	
	self.Text_my_raning:setString(self.rank)
	self.Text_activity_number:setString("")
	self.Text_activity_shijian:setString(EDgetPushIntervalByTimes(self.playerData.time,4))
	

	local lucknum = zstring.split(_ED.active_activity[161].need_recharge_count,"@")
	lucknum = tostring(lucknum[2])
	local xiangdeng = 0
	drawNum = tostring(self.playerData.num)
	for i=1, 5 do
		local char1 = string.sub(drawNum, i, i)
		local char2 = string.sub(lucknum, i, i)
		local Text_luck_number = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_"..i)
		if char1 == char2 then
			xiangdeng = xiangdeng+1
			Text_luck_number:setFntFile("fonts/num_double_hit_2.fnt")
		else
			Text_luck_number:setFntFile("fonts/num_double_hit.fnt")
		end
		Text_luck_number:setString(char1)
	end
	-- fwin:addTouchEventListener(self.roots[1], nil,
	-- {
	-- 	terminal_name = "activity_luck_record_personal_information_open",
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true,
	-- 	cell = self,
	-- }, nil, 0)	

end

function ActivityLuckRecordCell:onEnterTransitionFinish()
	
end

function ActivityLuckRecordCell:onInit(params)
	-- 加载ActivityLuckRecordCellWindow界面资源.
	-- cells.activity.activity_luck_record_cell = cells/activity/activity_luck_record_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cells/activity/activity_luck_record_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("Lucky/activity_luck_zhabbujilu_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if ActivityLuckRecordCell.__size == nil then
		ActivityLuckRecordCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function ActivityLuckRecordCell:onExit()
	-- 释放ActivityLuckRecordCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cells/activity/activity_luck_record_cell.csb", root)
	-- ]]
end

function ActivityLuckRecordCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ActivityLuckRecordCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cells/activity/activity_luck_record_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
