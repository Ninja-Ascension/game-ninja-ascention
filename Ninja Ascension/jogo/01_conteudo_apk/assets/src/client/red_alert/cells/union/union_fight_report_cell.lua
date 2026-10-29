
UnionFightReportCell = class("UnionFightReportCellClass", Window)
UnionFightReportCell.__size = nil

local union_fight_report_cell_create_terminal = {
    _name = "union_fight_report_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local report_info = params[1]
        local index = params[2]
        local cell = UnionFightReportCell:new()
        cell:init(report_info, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fight_report_cell_create_terminal)
state_machine.init()

function UnionFightReportCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._report_info = nil
    
    local function init_union_fight_report_cell_terminal()
        
    end
    init_union_fight_report_cell_terminal()
end

function UnionFightReportCell:updateDraw()
    local root = self.roots[1]
    local Text_field_infor = ccui.Helper:seekWidgetByName(root, "Text_field_infor")
    Text_field_infor:removeAllChildren(true)
    local fontSize = Text_field_infor:getFontSize()
    local fontName = Text_field_infor:getFontName()
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    _richText2:setContentSize(cc.size(320, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))

    if self._report_info.nType == 0 then
        local info1 = string.format(union_fight_report_str[1], self._report_info.attack_union_name)
        local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[2], 255, info1, fontName, fontSize)
        _richText2:pushBackElement(rtre1)

        local info2 = self._report_info.attack_user_name
        local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info2, fontName, fontSize)
        _richText2:pushBackElement(rtre2)

        local info3 = union_fight_report_str[2]
        local rtre3 = ccui.RichElementText:create(1, union_fight_report_color[4], 255, info3, fontName, fontSize)
        _richText2:pushBackElement(rtre3)

        local info4 = string.format(union_fight_report_str[1], self._report_info.defend_union_name)
        local rtre4 = ccui.RichElementText:create(1, union_fight_report_color[1], 255, info4, fontName, fontSize)
        _richText2:pushBackElement(rtre4)

        local info5 = self._report_info.defend_user_name
        local rtre5 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info5, fontName, fontSize)
        _richText2:pushBackElement(rtre5)

    elseif self._report_info.nType == 1 then
        local info1 = string.format(union_fight_report_str[1], self._report_info.attack_union_name)
        local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[2], 255, info1, fontName, fontSize)
        _richText2:pushBackElement(rtre1)

        local info2 = self._report_info.attack_user_name
        local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info2, fontName, fontSize)
        _richText2:pushBackElement(rtre2)

        local info3 = union_fight_report_str[3] --4,5
        local rtre3 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info3, fontName, fontSize)
        _richText2:pushBackElement(rtre3)

        local info4 = string.format(union_fight_report_str[6], self._report_info.kill_num)
        local rtre4 = ccui.RichElementText:create(1, union_fight_report_color[5], 255, info4, fontName, fontSize)
        _richText2:pushBackElement(rtre4)

    elseif self._report_info.nType == 2 then
        local info1 = string.format(union_fight_report_str[1], self._report_info.attack_union_name)
        local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[2], 255, info1, fontName, fontSize)
        _richText2:pushBackElement(rtre1)

        local info2 = self._report_info.attack_user_name
        local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info2, fontName, fontSize)
        _richText2:pushBackElement(rtre2)

        local info3 = union_fight_report_str[7]
        local rtre3 = ccui.RichElementText:create(1, union_fight_report_color[4], 255, info3, fontName, fontSize)
        _richText2:pushBackElement(rtre3)

    elseif self._report_info.nType == 3 then
        local info1 = string.format(union_fight_report_str[1], self._report_info.attack_union_name)
        local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[2], 255, info1, fontName, fontSize)
        _richText2:pushBackElement(rtre1)

        local info2 = self._report_info.attack_user_name
        local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info2, fontName, fontSize)
        _richText2:pushBackElement(rtre2)

        local info3 = union_fight_report_str[8]
        local rtre3 = ccui.RichElementText:create(1, union_fight_report_color[4], 255, info3, fontName, fontSize)
        _richText2:pushBackElement(rtre3)

        local info4 = string.format(union_fight_report_str[1], self._report_info.defend_union_name)
        local rtre4 = ccui.RichElementText:create(1, union_fight_report_color[1], 255, info4, fontName, fontSize)
        _richText2:pushBackElement(rtre4)

        local info5 = self._report_info.defend_user_name
        local rtre5 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info5, fontName, fontSize)
        _richText2:pushBackElement(rtre5)

        local info6 = string.format(union_fight_report_str[9], self._report_info.kill_num)
        local rtre6 = ccui.RichElementText:create(1, union_fight_report_color[5], 255, info6, fontName, fontSize)
        _richText2:pushBackElement(rtre6)

    elseif self._report_info.nType == 4 then
        local info1 = string.format(union_fight_report_str[1], self._report_info.attack_union_name)
        local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[2], 255, info1, fontName, fontSize)
        _richText2:pushBackElement(rtre1)

        local info2 = string.format(union_fight_report_str[10], self._report_info.attack_score)
        local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info2, fontName, fontSize)
        _richText2:pushBackElement(rtre2)

        local info3 = string.format(union_fight_report_str[1], self._report_info.city_name)
        local rtre3 = ccui.RichElementText:create(1, union_fight_report_color[4], 255, info3, fontName, fontSize)
        _richText2:pushBackElement(rtre3)

    elseif self._report_info.nType == 5 then
        local info1 = string.format(union_fight_report_str[1], self._report_info.attack_union_name)
        local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[2], 255, info1, fontName, fontSize)
        _richText2:pushBackElement(rtre1)

        local info2 = string.format(union_fight_report_str[11], self._report_info.attack_score)
        local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[5], 255, info2, fontName, fontSize)
        _richText2:pushBackElement(rtre2)

        local info3 = string.format(union_fight_report_str[1], self._report_info.city_name)
        local rtre3 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info3, fontName, fontSize)
        _richText2:pushBackElement(rtre3)

    elseif self._report_info.nType == 6 then
        local info1 = string.format(union_fight_report_str[1], self._report_info.attack_union_name, self._report_info.attack_user_name)
        local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[2], 255, info1, fontName, fontSize)
        _richText2:pushBackElement(rtre1)

        local info2 = self._report_info.attack_user_name
        local rtre2 = ccui.RichElementText:create(1, union_fight_report_color[3], 255, info2, fontName, fontSize)
        _richText2:pushBackElement(rtre2)

        local info3 = union_fight_report_str[12]
        local rtre3 = ccui.RichElementText:create(1, union_fight_report_color[4], 255, info3, fontName, fontSize)
        _richText2:pushBackElement(rtre3)

    elseif self._report_info.nType == 7 then
        local info1 = string.format(union_fight_report_str[13], self._report_info.cd_time)
        local rtre1 = ccui.RichElementText:create(1, union_fight_report_color[4], 255, info1, fontName, fontSize)
        _richText2:pushBackElement(rtre1)
    end

    _richText2:setPositionX(-160)
    Text_field_infor:addChild(_richText2)
end

function UnionFightReportCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.big_map.map_legion_battle_field_cell, "root")
    self:addChild(root)
    table.insert(self.roots, root)

    if UnionFightReportCell.__size == nil then
        UnionFightReportCell.__size = root:getContentSize()
    end

    ccui.Helper:seekWidgetByName(root, "Text_field_infor"):setString("")

    self:updateDraw()
end

function UnionFightReportCell:onEnterTransitionFinish()

end

function UnionFightReportCell:init(report_info, index)
    self._report_info = report_info
    self.index = index
    if index < 8 then
        self:onInit()
    end
    self:setContentSize(UnionFightReportCell.__size)
    return self
end

function UnionFightReportCell:reload()
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
    local Text_field_infor = ccui.Helper:seekWidgetByName(root, "Text_field_infor")
    Text_field_infor:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.big_map.map_legion_battle_field_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function UnionFightReportCell:onExit()
    local Text_field_infor = ccui.Helper:seekWidgetByName(self.roots[1], "Text_field_infor")
    if Text_field_infor ~= nil then
        Text_field_infor:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.big_map.map_legion_battle_field_cell, self.roots[1])
end
