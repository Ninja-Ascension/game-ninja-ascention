-- ------------------------------------------------------------------------------------------------------------
--  守卫战增益cell
-- ------------------------------------------------------------------------------------------------------------
GuardBattleRankCell = class("GuardBattleRankCellClass", Window)
GuardBattleRankCell.__size = nil

--创建cell
local guard_battle_rank_cell_create_terminal = {
    _name = "guard_battle_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = GuardBattleRankCell:new()
        local index = params[1]
        local info_data = params[2]
        cell:init(index, info_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(guard_battle_rank_cell_create_terminal)
state_machine.init()

function GuardBattleRankCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_guard_battle_rank_cell_terminal()

    end
    
    init_guard_battle_rank_cell_terminal()
end


function GuardBattleRankCell:updateDraw()
    local root = self.roots[1]
    local Panel_guard_battle_rank_top = ccui.Helper:seekWidgetByName(root, "Panel_guard_battle_rank_top")
    local Text_guard_battle_rank_n = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_rank_n")
    local Text_guard_battle_legion_name = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_legion_name")
    local Text_guard_battle_cotribution_n = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_cotribution_n")
    Panel_guard_battle_rank_top:removeBackGroundImage()

    if self._index <= 3 then
        Panel_guard_battle_rank_top:setBackGroundImage(string.format(config_res.images.ui.share.rank_icon, self._index))
    else
        Text_guard_battle_rank_n:setString(self._index)
    end

    local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    if self._index <= 3 then
        color = cc.c3b(arena_color_Type[self._index+2][1], arena_color_Type[self._index+2][2], arena_color_Type[self._index+2][3])
    elseif self._index <= 10 then
        color = cc.c3b(arena_color_Type[6][1], arena_color_Type[6][2], arena_color_Type[6][3])
    else
        color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    end
    Text_guard_battle_rank_n:setColor(color)
    Text_guard_battle_legion_name:setColor(color)
    Text_guard_battle_cotribution_n:setColor(color)

    Text_guard_battle_legion_name:setString(self._info_data.name)
    Text_guard_battle_cotribution_n:setString(exChangeNumToString(self._info_data.contribution))
end

function GuardBattleRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.guard_battle_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if GuardBattleRankCell.__size == nil then
        GuardBattleRankCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function GuardBattleRankCell:onEnterTransitionFinish()

end

function GuardBattleRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function GuardBattleRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.guard_battle_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function GuardBattleRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_guard_battle_rank_top = ccui.Helper:seekWidgetByName(root, "Panel_guard_battle_rank_top")
    local Text_guard_battle_rank_n = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_rank_n")
    local Text_guard_battle_legion_name = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_legion_name")
    local Text_guard_battle_cotribution_n = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_cotribution_n")

    if Panel_guard_battle_rank_top ~= nil then
        Panel_guard_battle_rank_top:removeBackGroundImage()
        Text_guard_battle_rank_n:setString("")
        Text_guard_battle_legion_name:setString("")
        Text_guard_battle_cotribution_n:setString("")
    end
end

function GuardBattleRankCell:init(index, info_data)
    self._index = index 
    self._info_data = info_data
    if index ~= nil and index <= 17 then
        self:onInit()
    end
    self:setContentSize(GuardBattleRankCell.__size)
    return self
end

function GuardBattleRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.guard_battle_rank_cell, self.roots[1])
end

