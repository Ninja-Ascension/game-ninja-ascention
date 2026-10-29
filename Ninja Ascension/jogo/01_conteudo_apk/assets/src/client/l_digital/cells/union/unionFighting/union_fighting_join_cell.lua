----------------------------------------------------------------------------------------------------
-- 说明：工会战报名cell
-------------------------------------------------------------------------------------------------------
UnionFightingJoinCell = class("UnionFightingJoinCellClass", Window)
UnionFightingJoinCell.__size = nil

local union_fighting_join_cell_create_terminal = {
    _name = "union_fighting_join_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = UnionFightingJoinCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_join_cell_create_terminal)
state_machine.init()

function UnionFightingJoinCell:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_union_fighting_join_cell_terminal()
        local union_fighting_join_cell_update_terminal = {
            _name = "union_fighting_join_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._info = params.info
                -- if cell._info ~= nil then
                    if index <= 8 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_join_cell_update_terminal)   
        state_machine.init()
    end
    init_union_fighting_join_cell_terminal()           
end

function UnionFightingJoinCell:onUpdateDraw()
    local root = self.roots[1]

end

function UnionFightingJoinCell:onEnterTransitionFinish()

end

function UnionFightingJoinCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.armor.armor_formation_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if UnionFightingJoinCell.__size == nil then
        UnionFightingJoinCell.__size = root:getContentSize()
    end
    
    self:onUpdateDraw()
end

function UnionFightingJoinCell:onExit()
    self:unload()
end

function UnionFightingJoinCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightingJoinCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_formation_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function UnionFightingJoinCell:clearUIInfo()
    local root = self.roots[1]
    local Text_armor_formation_att = ccui.Helper:seekWidgetByName(root, "Text_armor_formation_att")
    local Image_armor_formation_hook = ccui.Helper:seekWidgetByName(root, "Image_armor_formation_hook")
    local Button_armor_formation = ccui.Helper:seekWidgetByName(root, "Button_armor_formation")
    if Text_armor_formation_att ~= nil then
        Text_armor_formation_att:setString("")
        Text_armor_formation_att:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Image_armor_formation_hook:setVisible(false)
        Button_armor_formation:setHighlighted(false)
    end
end

function UnionFightingJoinCell:init(params)
    self._info = params
    self:onInit()
    self:setContentSize(UnionFightingJoinCell.__size)
end

