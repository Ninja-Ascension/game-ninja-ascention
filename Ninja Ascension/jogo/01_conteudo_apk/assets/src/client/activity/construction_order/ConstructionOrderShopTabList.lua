--[[ ----------------------------------------------------------------------------
-- 商店类型标签
--]] ----------------------------------------------------------------------------
ConstructionOrderShopTabList = class("ConstructionOrderShopTabListClass", Window)
ConstructionOrderShopTabList.__size = nil

-- 创建Cell实例
local construction_order_shop_tab_list_create_terminal = {
	_name = "construction_order_shop_tab_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ConstructionOrderShopTabList then
			local cell = ConstructionOrderShopTabList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(construction_order_shop_tab_list_create_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderShopTabList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._info = nil
    self.curType = 0

	-- load lua files.

	-- Initialize lim pool record list page state machine.
	local function init_construction_order_shop_tab_list_terminal()
		
	end
	-- call func init lim pool record list state machine.
	init_construction_order_shop_tab_list_terminal()
end

function ConstructionOrderShopTabList:onUpdateDraw()
    local typeString = ""
    if self.curType == 1 then
        typeString = war_order_str[7]
    elseif self.curType == 2 then
        typeString = war_order_str[8]
    end
    self.Text_type_1:setString(typeString)
    self.Text_type_2:setString(typeString)
end

-- 对象初始化
function ConstructionOrderShopTabList:init(params)
	self.curType = params.curType

	self:onInit(params)
	self:setContentSize(ConstructionOrderShopTabList.__size)
	return self
end

function ConstructionOrderShopTabList:onEnterTransitionFinish()
	
end

function ConstructionOrderShopTabList:onInit(params)
	
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("utils/common_paging_1_tab.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if ConstructionOrderShopTabList.__size == nil then
		ConstructionOrderShopTabList.__size = root:getContentSize()
	end

    self.Text_type_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    self.Text_type_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

    self:onUpdateDraw()

end

function ConstructionOrderShopTabList:onExit()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("utils/common_paging_1_tab.csb", root)
	-- ]]
end

function ConstructionOrderShopTabList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ConstructionOrderShopTabList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("utils/common_paging_1_tab.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
