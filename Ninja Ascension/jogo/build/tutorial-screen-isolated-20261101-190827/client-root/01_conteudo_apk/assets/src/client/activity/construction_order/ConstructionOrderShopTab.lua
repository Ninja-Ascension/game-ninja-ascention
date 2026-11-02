--[[ ----------------------------------------------------------------------------
-- 商店类型列表
--]] ----------------------------------------------------------------------------
ConstructionOrderShopTab = class("ConstructionOrderShopTabClass", Window)
ConstructionOrderShopTab.__size = nil

-- 打开窗口
local construction_order_shop_tab_create_terminal = {
    _name = "construction_order_shop_tab_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- if nil == fwin:find("ConstructionOrderShopTabClass") then
        --     local panel = fwin:open(ConstructionOrderShopTab:new():init(params), fwin._view)
        --     return panel
        -- end
        -- return true
        local cell = ConstructionOrderShopTab:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_shop_tab_create_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderShopTab:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    
   
    
    -- Initialize construction_order_shop_tab page state machine.
    local function init_construction_order_shop_tab_terminal()
        
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_construction_order_shop_tab_terminal()
end

-- 对象初始化
function ConstructionOrderShopTab:init(params)
  
    if nil ~= self.onInit then
        self:onInit(params)
    end
    self:setContentSize(ConstructionOrderShopTab.__size)
    return self
end

-- 对象初始化
function ConstructionOrderShopTab:onInit(params)
  
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("utils/common_paging_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)

    if ConstructionOrderShopTab.__size == nil then
        ConstructionOrderShopTab.__size = root:getContentSize()
    end
    
    self.ListView_paging_tab = ccui.Helper:seekWidgetByName(root, "ListView_paging_tab_1")

    self.ListView_paging_tab_2 = ccui.Helper:seekWidgetByName(root, "ListView_paging_tab_2")
    self.ListView_paging_tab_2:setVisible(false)
end

function ConstructionOrderShopTab:onEnterTransitionFinish()
    
end


function ConstructionOrderShopTab:onExit()
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("utils/common_paging_1.csb", root)
	-- ]]
end

-- ~END
-- ----------------------------------------------------------------------------
