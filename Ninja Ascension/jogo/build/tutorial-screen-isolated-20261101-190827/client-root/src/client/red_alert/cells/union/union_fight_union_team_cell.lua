
UnionFightUnionTeamCell = class("UnionFightUnionTeamCellClass", Window)
UnionFightUnionTeamCell.__size = nil

local union_fight_union_team_cell_create_terminal = {
    _name = "union_fight_union_team_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local isAttacker = params[1]
        local count = params[2]
        local info = params[3]
        local index = params[4]
        local cell = UnionFightUnionTeamCell:new()
        cell:init(isAttacker, count, info, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fight_union_team_cell_create_terminal)
state_machine.init()

function UnionFightUnionTeamCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._isAttacker = false
    self._info = ""
    self._count = 0
end

function UnionFightUnionTeamCell:updateDraw()
    local root = self.roots[1]
    local Panel_attack = ccui.Helper:seekWidgetByName(root, "Panel_attack")
    local Text_battle_legion = ccui.Helper:seekWidgetByName(root, "Text_battle_legion")
    local Text_battle_pl = ccui.Helper:seekWidgetByName(root, "Text_battle_pl")
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    if self._isAttacker == true then
        Panel_attack:setVisible(true)
        Text_battle_pl:setString(""..self._count)
        Text_battle_legion:setString("【"..self._info.."】")
        Text_legion_name:setString("")
    else
        Panel_attack:setVisible(false)
        Text_legion_name:setString(self._info)
    end
end

function UnionFightUnionTeamCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.big_map.map_legion_battle_player_cell, "root")
    self:addChild(root)
    table.insert(self.roots, root)

    if UnionFightUnionTeamCell.__size == nil then
        UnionFightUnionTeamCell.__size = root:getContentSize()
    end
    self:updateDraw()
end

function UnionFightUnionTeamCell:onEnterTransitionFinish()

end

function UnionFightUnionTeamCell:init(isAttacker, count, info, index)
    self._isAttacker = isAttacker
    self._count = count
    self._info = info
    if index < 12 then
        self:onInit()
    end
    self:setContentSize(UnionFightUnionTeamCell.__size)
    return self
end

function UnionFightUnionTeamCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightReportCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.big_map.map_legion_battle_player_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function UnionFightUnionTeamCell:onExit()
    cacher.freeRef(config_csb.cells.big_map.map_legion_battle_player_cell, self.roots[1])
end
