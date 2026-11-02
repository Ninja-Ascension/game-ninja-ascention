-- ------------------------------------------------------------------------------------------------------------
--  工会战战报轮cell
-- ------------------------------------------------------------------------------------------------------------
UnionFightingRoundEXCell = class("UnionFightingRoundEXCellClass", Window)
UnionFightingRoundEXCell.__size = nil

--创建cell
local union_fighting_round_ex_cell_create_terminal = {
    _name = "union_fighting_round_ex_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = UnionFightingRoundEXCell:new()
        local round = params[1]
        cell:init(round)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_fighting_round_ex_cell_create_terminal)
state_machine.init()

function UnionFightingRoundEXCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._round = 0
end

function UnionFightingRoundEXCell:updateDraw()
    local root = self.roots[1]
    local AtlasLabel_ghz_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_ghz_n")
    AtlasLabel_ghz_n:setString(self._round)
end

function UnionFightingRoundEXCell:onInit(isNewReport)
    local root = cacher.createUIRef(string.format(config_csb.union_fight.sm_legion_ghz_fighting_cell, 1), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if UnionFightingRoundEXCell.__size == nil then
        UnionFightingRoundEXCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function UnionFightingRoundEXCell:onEnterTransitionFinish()

end

function UnionFightingRoundEXCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightingRoundEXCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_fighting_cell, 1), root)
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionFightingRoundEXCell:clearUIInfo( ... )
    local root = self.roots[1]
    local AtlasLabel_ghz_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_ghz_n")
    if AtlasLabel_ghz_n ~= nil then
        AtlasLabel_ghz_n:setString("")
    end
end

function UnionFightingRoundEXCell:init(round)
    self._round = round
    self:onInit()
    self:setContentSize(UnionFightingRoundEXCell.__size)
    return self
end

function UnionFightingRoundEXCell:onExit()
    self:clearUIInfo()
    local root = self.roots[1]
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_fighting_cell, 1), root)
end

