-- ------------------------------------------------------------------------------------------------------------
--  极限挑战排行cell
-- ------------------------------------------------------------------------------------------------------------
LimitDekaronaRankCell = class("LimitDekaronaRankCellClass", Window)
LimitDekaronaRankCell.__size = nil

--创建cell
local limit_dekarona_rank_cell_create_terminal = {
    _name = "limit_dekarona_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LimitDekaronaRankCell:new()
        local index = params[1]
        local info_data = params[2]
        cell:init(index, info_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(limit_dekarona_rank_cell_create_terminal)
state_machine.init()

function LimitDekaronaRankCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_limit_dekarona_rank_cell_terminal()

    end
    init_limit_dekarona_rank_cell_terminal()
end

function LimitDekaronaRankCell:updateDraw()
    local root = self.roots[1]
    local Panel_rebel_week_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_rebel_week_rank_top_icon")
    local Text_rebel_week_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_week_rank_n")
    local Text_player_name_n = ccui.Helper:seekWidgetByName(root, "Text_player_name_n")
    local Text_settlement_n = ccui.Helper:seekWidgetByName(root, "Text_settlement_n")
    Panel_rebel_week_rank_top_icon:removeBackGroundImage()
    Text_rebel_week_rank_n:setString("")
    Text_player_name_n:setString("")
    Text_settlement_n:setString("")

    -- 排名
    if self._index <= 3 then
        Panel_rebel_week_rank_top_icon:setBackGroundImage(string.format(config_res.images.ui.share.rank_icon, self._index))
    else
        Text_rebel_week_rank_n:setString(self._index)
    end

    if self._info_data ~= nil then
        Text_player_name_n:setString(self._info_data.user_name)
        Text_settlement_n:setString(string.format(red_alert_time_str[135],self._info_data.npc_count,self._info_data.star_count))
    end
end

function LimitDekaronaRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.limit_dekarona_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LimitDekaronaRankCell.__size == nil then
        LimitDekaronaRankCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LimitDekaronaRankCell:onEnterTransitionFinish()

end

function LimitDekaronaRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimitDekaronaRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.limit_dekarona_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LimitDekaronaRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_rebel_week_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_rebel_week_rank_top_icon")
    local Text_rebel_week_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_week_rank_n")
    local Text_player_name_n = ccui.Helper:seekWidgetByName(root, "Text_player_name_n")
    local Text_settlement_n = ccui.Helper:seekWidgetByName(root, "Text_settlement_n")

    if Text_rebel_week_rank_n ~=nil then
        Panel_rebel_week_rank_top_icon:removeBackGroundImage()
        Text_rebel_week_rank_n:setString("")
        Text_player_name_n:setString("")
        Text_settlement_n:setString("")
    end
end

function LimitDekaronaRankCell:init(index, info_data)
    self._info_data = info_data
    self._index = index 
    if index ~= nil and index <= 16 then
        self:onInit()
    end
    self:setContentSize(LimitDekaronaRankCell.__size)
    return self
end

function LimitDekaronaRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.limit_dekarona_rank_cell, self.roots[1])
end

