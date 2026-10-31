
UnionFightBuildInfoDefendCell = class("UnionFightBuildInfoDefendCellClass", Window)
UnionFightBuildInfoDefendCell.__size = nil

local union_fight_build_info_defend_cell_create_terminal = {
    _name = "union_fight_build_info_defend_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local info = params[1]
        local cell = UnionFightBuildInfoDefendCell:new()
        cell:init(info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fight_build_info_defend_cell_create_terminal)
state_machine.init()

function UnionFightBuildInfoDefendCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._info = {}
end

function UnionFightBuildInfoDefendCell:updateDraw()
    local root = self.roots[1]
    for i=1,4 do
        local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name_"..i)
        Text_legion_name:setString("")
        if self._info[i] ~= nil then
            Text_legion_name:setString(self._info[i])
        end
    end
end

function UnionFightBuildInfoDefendCell:onInit()
    local csbNode = csb.createNode(config_csb.cells.big_map.map_legion_battle_build_infor_cell_1)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    if UnionFightBuildInfoDefendCell.__size == nil then
        UnionFightBuildInfoDefendCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function UnionFightBuildInfoDefendCell:onEnterTransitionFinish()

end

function UnionFightBuildInfoDefendCell:init(info)
    self._info = info
    self:onInit()
    self:setContentSize(UnionFightBuildInfoDefendCell.__size)
    return self
end

function UnionFightBuildInfoDefendCell:onExit()
end
