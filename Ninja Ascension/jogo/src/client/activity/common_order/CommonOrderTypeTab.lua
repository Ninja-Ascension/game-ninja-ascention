--[[ ----------------------------------------------------------------------------
-- 常规战令左侧
--]] ----------------------------------------------------------------------------
CommonOrderTypeTab = class("CommonOrderTypeTabClass", Window)
CommonOrderTypeTab.__size = nil

-- 打开窗口
local common_order_type_tab_window_create_terminal = {
    _name = "common_order_type_tab_window_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- if nil == fwin:find("CommonOrderTypeTabClass") then
        --     local panel = fwin:open(CommonOrderTypeTab:new():init(params), fwin._view)
        --     return panel
        -- end
        -- return true
        local cell = CommonOrderTypeTab:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(common_order_type_tab_window_create_terminal)
state_machine.init()

-- 构造器
function CommonOrderTypeTab:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    
   
    
    -- Initialize common_order_type_tab page state machine.
    local function init_common_order_type_tab_terminal()
        
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_common_order_type_tab_terminal()
end

-- 对象初始化
function CommonOrderTypeTab:init(params)
  
    if nil ~= self.onInit then
        self:onInit(params)
    end
    self:setContentSize(CommonOrderTypeTab.__size)
    return self
end

function CommonOrderTypeTab:onUpdate(dt)
    
end

function CommonOrderTypeTab:onInit(params)
	-- [[ 使用缓存创建
    local root = cacher.createUIRef("utils/common_paging_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommonOrderTypeTab.__size == nil then
		CommonOrderTypeTab.__size = root:getContentSize()
	end
 
    self.ListView_paging_tab = ccui.Helper:seekWidgetByName(root, "ListView_paging_tab_1")

    self.ListView_paging_tab_2 = ccui.Helper:seekWidgetByName(root, "ListView_paging_tab_2")
    self.ListView_paging_tab_2:setVisible(false)
end


function CommonOrderTypeTab:onEnterTransitionFinish()
   
end

function CommonOrderTypeTab:onExit()
    -- 释放资源.
    local root = self.roots[1]
	cacher.freeRef("utils/common_paging_1.csb", root)
    
end

-- ~END
-- ----------------------------------------------------------------------------
