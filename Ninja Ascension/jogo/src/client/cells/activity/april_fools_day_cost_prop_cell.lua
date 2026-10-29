--[[ ----------------------------------------------------------------------------
-- 消耗显示控件
--]] ----------------------------------------------------------------------------
AprilFoolsDayCostPropCell = class("AprilFoolsDayCostPropCellClass", Window)
AprilFoolsDayCostPropCell.__size = nil

-- 创建Cell实例
local april_fools_day_cost_prop_cell_create_terminal = {
	_name = "april_fools_day_cost_prop_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if AprilFoolsDayCostPropCell then
			local cell = AprilFoolsDayCostPropCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(april_fools_day_cost_prop_cell_create_terminal)
state_machine.init()

-- 构造器
function AprilFoolsDayCostPropCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure task list page state machine.
	local function init_april_fools_day_cost_prop_cell_terminal()
		
	end
	-- call func init secret treasure task list state machine.
	init_april_fools_day_cost_prop_cell_terminal()
end

-- 对象初始化
function AprilFoolsDayCostPropCell:init(params)
	self.propID = params

	self:onInit(params)
	self:setContentSize(AprilFoolsDayCostPropCell.__size)
	return self
end

function AprilFoolsDayCostPropCell:updateUI()
	self.Panel_16:removeAllChildren(true)

	local cell = self:addResourcesIconCell({6, self.propID, 0, -1})
	self.Panel_16:addChild(cell)


	local propNum = getPropAllCountByMouldId(self.propID)
	self.Text_23:setString(propNum)

	if tonumber(propNum) <= 0 then
		self.Text_23:setColor(cc.c3b(255, 0, 0))
	else
		self.Text_23:setColor(cc.c3b(0, 0, 0))
	end
end

function AprilFoolsDayCostPropCell:addResourcesIconCell(propData)
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

function AprilFoolsDayCostPropCell:onUpdateDraw()
	local root = self.roots[1]

	-- 道具
	self.Panel_16 = ccui.Helper:seekWidgetByName(root, "Panel_16")

	-- 数量
	self.Text_23 = ccui.Helper:seekWidgetByName(root, "Text_23")

	self:updateUI()
end

function AprilFoolsDayCostPropCell:onEnterTransitionFinish()
	
end

function AprilFoolsDayCostPropCell:onInit(params)
	-- 加载AprilFoolsDayCostPropCellWindow界面资源.
	-- res.activity.wonderful.april_fools_day_list_1 = res/activity/wonderful/april_fools_day_list_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/wonderful/april_fools_day_list_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/wonderful/april_fools_day_list_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if AprilFoolsDayCostPropCell.__size == nil then
		AprilFoolsDayCostPropCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function AprilFoolsDayCostPropCell:onExit()
	-- 释放AprilFoolsDayCostPropCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/wonderful/april_fools_day_list_1.csb", root)
	-- ]]
end

function AprilFoolsDayCostPropCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AprilFoolsDayCostPropCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/wonderful/april_fools_day_list_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
