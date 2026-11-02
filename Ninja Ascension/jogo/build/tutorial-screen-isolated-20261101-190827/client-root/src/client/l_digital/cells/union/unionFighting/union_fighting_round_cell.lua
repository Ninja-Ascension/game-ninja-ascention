-- ------------------------------------------------------------------------------------------------------------
--  工会战战报轮cell
-- ------------------------------------------------------------------------------------------------------------
UnionFightingRoundCell = class("UnionFightingRoundCellClass", Window)
UnionFightingRoundCell.__size = nil

--创建cell
local union_fighting_round_cell_create_terminal = {
    _name = "union_fighting_round_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = UnionFightingRoundCell:new()
        local round = params[1]
        cell:init(round)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_fighting_round_cell_create_terminal)
state_machine.init()

function UnionFightingRoundCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._round = 0
end

function UnionFightingRoundCell:updateDraw()
    local root = self.roots[1]
    local AtlasLabel_ghz_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_ghz_n")
    local Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
    local Image_ghz_js = ccui.Helper:seekWidgetByName(root, "Image_ghz_js")
    if self._round > 0 then
        Image_ghz_js:setVisible(false)  
        AtlasLabel_ghz_n:setVisible(true) 
        Image_4:setVisible(true)

        AtlasLabel_ghz_n:setString(self._round)
    else
        Image_ghz_js:setVisible(true)  
        AtlasLabel_ghz_n:setVisible(false) 
        Image_4:setVisible(false)
    end
end

function UnionFightingRoundCell:onInit(isNewReport)
    local root = cacher.createUIRef(string.format(config_csb.union_fight.sm_legion_ghz_tab_4_cell, 1), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if UnionFightingRoundCell.__size == nil then
        UnionFightingRoundCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function UnionFightingRoundCell:onEnterTransitionFinish()

end

function UnionFightingRoundCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightingRoundCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_tab_4_cell, 1), root)
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionFightingRoundCell:clearUIInfo( ... )
    local root = self.roots[1]
    local AtlasLabel_ghz_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_ghz_n")
    if AtlasLabel_ghz_n ~= nil then
        AtlasLabel_ghz_n:setString("")
    end
end

function UnionFightingRoundCell:init(round)
    self._round = round
    self:onInit()
    self:setContentSize(UnionFightingRoundCell.__size)
    return self
end

function UnionFightingRoundCell:onExit()
    self:clearUIInfo()
    local root = self.roots[1]
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_tab_4_cell, 1), root)
end

