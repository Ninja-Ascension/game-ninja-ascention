-- ------------------------------------------------------------------------------------------------------------
--  军团争霸排行cell
-- ------------------------------------------------------------------------------------------------------------
LegionHegemonyRankCell = class("LegionHegemonyRankCellClass", Window)
LegionHegemonyRankCell.__size = nil

--创建cell
local legion_hegemony_rank_cell_create_terminal = {
    _name = "legion_hegemony_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionHegemonyRankCell:new()
        local index = params[1]
        local info_data = params[2]
        cell:init(index, info_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_hegemony_rank_cell_create_terminal)
state_machine.init()

function LegionHegemonyRankCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_legion_hegemony_rank_cell_terminal()

    end
    
    init_legion_hegemony_rank_cell_terminal()
end


function LegionHegemonyRankCell:updateDraw()
    local root = self.roots[1]
    local Text_hegemony_fight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_n")
    local Text_hegemony_straight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_straight_n")
    local Text_hegemony_rank_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_rank_n")
    local Text_hegemony_name_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_name_n")
    local Panel_hegemony_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_hegemony_rank_top_icon")
    Panel_hegemony_rank_top_icon:removeBackGroundImage()

    -- 排名
    if self._index <= 3 then
        Panel_hegemony_rank_top_icon:setBackGroundImage(string.format(config_res.images.ui.share.rank_icon, self._index))
    else
        Text_hegemony_rank_n:setString(self._index)
    end

    local color = cc.c3b(gray_color[1], gray_color[2], gray_color[3])
    if self._index == 1 then
        color = cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])
    elseif self._index == 2 then
        color = cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3])
    elseif self._index == 3 then
        color = cc.c3b(color_Type[4][1], color_Type[4][2], color_Type[4][3])
    end
    
    Text_hegemony_fight_n:setString(exChangeNumToString(self._info_data.fight_number))
    Text_hegemony_straight_n:setString(self._info_data.number)
    Text_hegemony_name_n:setString(self._info_data.name)

    Text_hegemony_fight_n:setColor(color)
    Text_hegemony_straight_n:setColor(color)
    Text_hegemony_name_n:setColor(color)
end

function LegionHegemonyRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_hegemony_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionHegemonyRankCell.__size == nil then
        LegionHegemonyRankCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionHegemonyRankCell:onEnterTransitionFinish()

end

function LegionHegemonyRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionHegemonyRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionHegemonyRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_hegemony_fight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_n")
    local Text_hegemony_straight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_straight_n")
    local Text_hegemony_rank_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_rank_n")
    local Text_hegemony_name_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_name_n")
    local Panel_hegemony_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_hegemony_rank_top_icon")
    if Panel_hegemony_rank_top_icon ~= nil then
        Panel_hegemony_rank_top_icon:removeBackGroundImage()
        Text_hegemony_fight_n:setString("")
        Text_hegemony_straight_n:setString("")
        Text_hegemony_rank_n:setString("")
        Text_hegemony_name_n:setString("")
    end
end

function LegionHegemonyRankCell:init(index, info_data)
    self._index = index 
    self._info_data = info_data
    if index ~= nil and index <= 11 then
        self:onInit()
    end
    self:setContentSize(LegionHegemonyRankCell.__size)
    return self
end

function LegionHegemonyRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_rank_cell, self.roots[1])
end

