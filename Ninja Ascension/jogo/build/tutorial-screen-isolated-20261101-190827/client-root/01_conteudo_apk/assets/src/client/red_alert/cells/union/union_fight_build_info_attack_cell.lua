
UnionFightBuildInfoAttackCell = class("UnionFightBuildInfoAttackCellClass", Window)
UnionFightBuildInfoAttackCell.__size = nil

local union_fight_build_info_attack_cell_create_terminal = {
    _name = "union_fight_build_info_attack_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local attack_infos = params[1]
        local cell = UnionFightBuildInfoAttackCell:new()
        cell:init(attack_infos)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fight_build_info_attack_cell_create_terminal)
state_machine.init()

function UnionFightBuildInfoAttackCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._attack_infos = nil
end

function UnionFightBuildInfoAttackCell:updateDraw()
    local root = self.roots[1]
    for i=1,2 do
        local Text_legion_name_infor = ccui.Helper:seekWidgetByName(root, "Text_legion_name_infor_"..i)
        Text_legion_name_infor:removeAllChildren(true)
        Text_legion_name_infor:setString("")
        local info = self._attack_infos[i]
        if info ~= nil then
            local fontSize = Text_legion_name_infor:getFontSize()
            local fontName = Text_legion_name_infor:getFontName()

            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)
            _richText2:setContentSize(cc.size(284, 0))
            _richText2:setAnchorPoint(cc.p(0, 0))

            local info1 = "【"..info.union_name.."】"
            local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[10], 255, info1, fontName, fontSize)
            _richText2:pushBackElement(rtre1)

            local info2 = info.user_name
            local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[11], 255, info2, fontName, fontSize)
            _richText2:pushBackElement(rtre2)

            _richText2:setPositionX(-140)
            _richText2:setPositionY(15)
            Text_legion_name_infor:addChild(_richText2)
        end
    end
end

function UnionFightBuildInfoAttackCell:onInit()
    local csbNode = csb.createNode(config_csb.cells.big_map.map_legion_battle_build_infor_cell_2)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    if UnionFightBuildInfoAttackCell.__size == nil then
        UnionFightBuildInfoAttackCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function UnionFightBuildInfoAttackCell:onEnterTransitionFinish()

end

function UnionFightBuildInfoAttackCell:init(attack_infos)
    self._attack_infos = attack_infos
    self:onInit()
    self:setContentSize(UnionFightBuildInfoAttackCell.__size)
    return self
end

function UnionFightBuildInfoAttackCell:onExit()
end
