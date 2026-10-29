----------------------------------------------------------------------------------------------------
-- 说明：工会战战况cell
-------------------------------------------------------------------------------------------------------
UnionFightingUnionCell = class("UnionFightingUnionCellClass", Window)
UnionFightingUnionCell.__size = nil

local union_fighting_union_cell_create_terminal = {
    _name = "union_fighting_union_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = UnionFightingUnionCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_union_cell_create_terminal)
state_machine.init()

function UnionFightingUnionCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info = nil

    local function init_union_fighting_union_cell_terminal()
        local union_fighting_union_cell_update_terminal = {
            _name = "union_fighting_union_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._info = params.info
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_union_cell_update_terminal)   
        state_machine.init()
    end
    init_union_fighting_union_cell_terminal()           
end

function UnionFightingUnionCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_ghz_bm_name = ccui.Helper:seekWidgetByName(root, "Text_ghz_bm_name")
    local Text_ghz_bm_num = ccui.Helper:seekWidgetByName(root, "Text_ghz_bm_num")
    Text_ghz_bm_name:setString(self._info.union_name)
    if tonumber(_ED.union.union_fight_battle_info.state) == 4 then
        Text_ghz_bm_num:setString(self._info.current_num.."/"..self._info.join_num)
    else
        Text_ghz_bm_num:setString(self._info.current_num.."/"..self._info.total_num)
    end
end

function UnionFightingUnionCell:onEnterTransitionFinish()

end

function UnionFightingUnionCell:onInit()
    local root = cacher.createUIRef(config_csb.union_fight.sm_legion_ghz_tab_1_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if UnionFightingUnionCell.__size == nil then
        UnionFightingUnionCell.__size = root:getContentSize()
    end
    
    self:onUpdateDraw()
end

function UnionFightingUnionCell:onExit()
    self:unload()
end

function UnionFightingUnionCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightingUnionCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.union_fight.sm_legion_ghz_tab_1_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function UnionFightingUnionCell:clearUIInfo()
    local root = self.roots[1]
    local Text_ghz_bm_name = ccui.Helper:seekWidgetByName(root, "Text_ghz_bm_name")
    local Text_ghz_bm_num = ccui.Helper:seekWidgetByName(root, "Text_ghz_bm_num")
    if Text_ghz_bm_name ~= nil then
        Text_ghz_bm_name:setString("")
        Text_ghz_bm_num:setString("")
    end
end

function UnionFightingUnionCell:init(params)
    self._info = params[1]
    self:onInit()
    self:setContentSize(UnionFightingUnionCell.__size)
end

