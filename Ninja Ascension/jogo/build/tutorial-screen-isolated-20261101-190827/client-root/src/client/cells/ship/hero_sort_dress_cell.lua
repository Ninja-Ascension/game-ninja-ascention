-- 武将筛选资质cell
HeroDortDressCell = class("HeroDortDressCellClass", Window)
HeroDortDressCell.__size = nil

-- 创建Cell实例
local hero_sort_dress_cell_create_terminal = {
    _name = "hero_sort_dress_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if HeroDortDressCell then
            local cell = HeroDortDressCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_sort_dress_cell_create_terminal)
state_machine.init()

-- 构造器
function HeroDortDressCell:ctor()
    self.super:ctor()
    self.roots = {}
end

-- 对象初始化
function HeroDortDressCell:init(params)
    self:onInit(params)
    self:setContentSize(HeroDortDressCell.__size)
    return self
end


function HeroDortDressCell:onInit(params)
    local root = cacher.createUIRef("packs/HeroStorage/generals_shaiXuan_cell.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if HeroDortDressCell.__size == nil then
        HeroDortDressCell.__size = root:getContentSize()
    end
end

function HeroDortDressCell:onExit()
    -- 释放HeroDortDressCellWindow界面资源.

    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("packs/HeroStorage/generals_shaiXuan_cell.csb", root)
    -- ]]
end

-- ~END
-- ----------------------------------------------------------------------------
