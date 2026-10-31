--------------------------------------------------------------------------------------------------------------
-- 空方框
--------------------------------------------------------------------------------------------------------------
PacksIconBgCell = class("PacksIconBgCellClass", Window)
PacksIconBgCell.__size = nil

--创建cell
local packs_icon_bg_create_cell_terminal = {
    _name = "packs_icon_bg_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PacksIconBgCell:new()
        cell:init()
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(packs_icon_bg_create_cell_terminal)
state_machine.init()

function PacksIconBgCell:ctor()
    -- 初始化调用参数
    self.super:ctor()
    self.roots = {}
end

function PacksIconBgCell:onUpdateDraw()
  
end

function PacksIconBgCell:onInit()
    -- 绘图初始化
    local root = nil
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	root = ccui.Layout:create()
		root:setContentSize(cc.size(98,98))
		root:removeAllChildren(true)
		root:setBackGroundImage("images/ui/quality/props_icon_bg.png")
    else
    	root = cacher.createUIRef(config_csb.cells.packs.packs_icon_bg_cell, "root")
    end
    table.insert(self.roots, root)
    self:addChild(root)

    if PacksIconBgCell.__size == nil then
        PacksIconBgCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function PacksIconBgCell:reload()

end

function PacksIconBgCell:unload()
 
end

function PacksIconBgCell:init()
    self:onInit()
    self:setContentSize(PacksIconBgCell.__size)
    return self
end

function PacksIconBgCell:onExit()
    cacher.freeRef(config_csb.cells.packs.packs_icon_bg_cell, self.roots[1])
end