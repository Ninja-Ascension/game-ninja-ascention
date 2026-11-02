--[[ ----------------------------------------------------------------------------
-- 皮肤属性List
--]] ----------------------------------------------------------------------------
ConstructionOrderPropertyList = class("ConstructionOrderPropertyListClass", Window)
ConstructionOrderPropertyList.__size = nil

-- 创建Cell实例
local construction_order_property_list_create_terminal = {
	_name = "construction_order_property_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ConstructionOrderPropertyList then
			local cell = ConstructionOrderPropertyList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(construction_order_property_list_create_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderPropertyList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.propertyInfo = {}

	-- load lua files.
	

	-- Initialize construction order property list page state machine.
	local function init_construction_order_property_list_terminal()
		
	end
	-- call func init construction order property list state machine.
	init_construction_order_property_list_terminal()
end

-- 对象初始化
function ConstructionOrderPropertyList:init(params)
	self.propertyInfo = params.propertyInfo
	self.isAddPercent = params.isAddPercent
	self:onInit(params)
	self:setContentSize(ConstructionOrderPropertyList.__size)
	return self
end


function ConstructionOrderPropertyList:onUpdateDraw()
	local root = self.roots[1]

	-- 属性名称
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	-- 属性数据
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	-- 是否进行百分比运算
	local isAdd = self.isAddPercent == 1
	local propertyName, propertyData = getHardenPropertyNameAndValue(self.propertyInfo[1], self.propertyInfo[2], isAdd)
	self.Text_1:setString(propertyName)
	self.Text_2:setString(propertyData)
end

function ConstructionOrderPropertyList:onEnterTransitionFinish()
	
end

function ConstructionOrderPropertyList:onInit(params)

	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/passport/passport_main_jianhao_cell_0.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if ConstructionOrderPropertyList.__size == nil then
		ConstructionOrderPropertyList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function ConstructionOrderPropertyList:onExit()
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/passport/passport_main_jianhao_cell_0.csb", root)
	-- ]]
end

function ConstructionOrderPropertyList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ConstructionOrderPropertyList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/passport/passport_main_jianhao_cell_0.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
