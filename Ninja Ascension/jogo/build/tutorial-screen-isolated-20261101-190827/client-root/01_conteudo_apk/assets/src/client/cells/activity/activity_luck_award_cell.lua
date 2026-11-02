--[[ ----------------------------------------------------------------------------
-- 奖励控件
--]] ----------------------------------------------------------------------------
ActivityLuckAwardCell = class("ActivityLuckAwardCellClass", Window)
ActivityLuckAwardCell.__size = nil

-- 创建Cell实例
local activity_luck_award_cell_create_terminal = {
	_name = "activity_luck_award_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ActivityLuckAwardCell then
			local cell = ActivityLuckAwardCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_award_cell_create_terminal)
state_machine.init()

-- 构造器
function ActivityLuckAwardCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize activity luck award cell page state machine.
	local function init_activity_luck_award_cell_terminal()
		
	end
	-- call func init activity luck award cell state machine.
	init_activity_luck_award_cell_terminal()
end

-- 对象初始化
function ActivityLuckAwardCell:init(params)
	self.data = params
	self:onInit(params)
	self:setContentSize(ActivityLuckAwardCell.__size)
	return self
end

function ActivityLuckAwardCell:onUpdateDraw()
	local root = self.roots[1]

	-- 标题
	self.Text_activity_title = ccui.Helper:seekWidgetByName(root, "Text_activity_title")

	-- 奖励列表
	self.ListView_activity_content = ccui.Helper:seekWidgetByName(root, "ListView_activity_content")
	self:drawCellListView()
end


function ActivityLuckAwardCell:drawCellListView()
	self.ListView_activity_content:removeAllItems()
	self.ListView_activity_content:removeAllChildren(true)
	self.ListView_activity_content:setItemsMargin(-58)
	local myReworld =  zstring.splits(self.data.data[6], "|",",")
	for i,v in pairs(myReworld) do
		local prop_data = v
		local cell = ResourcesIconCell:createCell()
		cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1,{shipStar=prop_data[4]})
		cell:setScale(0.6)
		cell:setAnchorPoint(0,1)
		self.ListView_activity_content:addChild(cell)
	end
	self.ListView_activity_content:refreshView()

	local str = ""
	if tonumber(self.data.type) == 1 then --幸运奖励
		if tonumber(self.data.num) == tonumber(self.data.data[1][3])  then
			local word_info = dms.element(dms["word_mould"], 65202)
			str = word_info[3]
		else
			local word_info = dms.element(dms["word_mould"], 65203)
			str = string.format(word_info[3],tonumber(self.data.data[1][3]))
		end
	else
		local data = self.data.data[1]
		if data[3] == data[4] then
			local word_info = dms.element(dms["word_mould"], 65201)
			str = string.format(word_info[3],data[3])
		else
			local word_info = dms.element(dms["word_mould"], 65200)
			str = string.format(word_info[3],data[3],data[4])
		end
	end
	self.Text_activity_title:setString(str)
end

function ActivityLuckAwardCell:onEnterTransitionFinish()
	
end

function ActivityLuckAwardCell:onInit(params)
	-- 加载ActivityLuckAwardCellWindow界面资源.
	-- cells.activity.activity_luck_award_cell = cells/activity/activity_luck_award_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cells/activity/activity_luck_award_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("Lucky/activity_luck_award_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if ActivityLuckAwardCell.__size == nil then
		ActivityLuckAwardCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function ActivityLuckAwardCell:onExit()
	-- 释放ActivityLuckAwardCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cells/activity/activity_luck_award_cell.csb", root)
	-- ]]
end

function ActivityLuckAwardCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ActivityLuckAwardCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cells/activity/activity_luck_award_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
