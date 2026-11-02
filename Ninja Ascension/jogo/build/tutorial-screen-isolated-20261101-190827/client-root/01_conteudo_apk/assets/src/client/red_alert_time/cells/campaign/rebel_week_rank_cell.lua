-- ------------------------------------------------------------------------------------------------------------
--  叛军出没排行cell
-- ------------------------------------------------------------------------------------------------------------
RebelWeekRankCell = class("RebelWeekRankCellClass", Window)
RebelWeekRankCell.__size = nil

--创建cell
local rebel_week_rank_create_cell_terminal = {
    _name = "rebel_week_rank_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RebelWeekRankCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(rebel_week_rank_create_cell_terminal)
state_machine.init()

function RebelWeekRankCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    self._nType = 0
end

function RebelWeekRankCell:updateDraw()
    local root = self.roots[1]
    local Text_rebel_week_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_week_rank_n")
    local Panel_rebel_week_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_rebel_week_rank_top_icon")
    local Text_player_name_n = ccui.Helper:seekWidgetByName(root, "Text_player_name_n")
    local Text_player_lv_n = ccui.Helper:seekWidgetByName(root, "Text_player_lv_n")
    local Text_rank_integral_n = ccui.Helper:seekWidgetByName(root, "Text_rank_integral_n")
    Text_rebel_week_rank_n:setString("")
    Text_player_name_n:setString("")
    Text_player_lv_n:setString("")
    Text_player_lv_n:removeAllChildren(true)
    Text_rank_integral_n:setString("")
    Panel_rebel_week_rank_top_icon:removeBackGroundImage()

    Text_player_name_n:setString(self._info_data.user_name)
    Text_rebel_week_rank_n:setString(""..self._index)
    Text_rank_integral_n:setString(self._info_data.score)

    -- 排名
    if self._index <= 3 then
        Panel_rebel_week_rank_top_icon:setBackGroundImage(string.format(config_res.images.ui.share.rank_icon, self._index))
    else
        Text_rebel_week_rank_n:setString(self._index)
    end

    local kill_info = zstring.split(self._info_data.kill_info, ",")
    local little_count = tonumber(kill_info[1])
    local bettle_count = tonumber(kill_info[2])
    local boss_count = tonumber(kill_info[3])

    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local color = cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3])
    local re1 = ccui.RichElementText:create(1, color, 255, ""..little_count, "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re1)
    color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
    local re2 = ccui.RichElementText:create(1, color, 255, "/"..bettle_count.."/", "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re2)
    color = cc.c3b(color_Type[4][1],color_Type[4][2],color_Type[4][3])
    local re3 = ccui.RichElementText:create(1, color, 255, ""..boss_count, "fonts/simhei.ttf", 20)
    _richText_2:pushBackElement(re3)
    _richText_2:setContentSize(cc.size(200,40))
    _richText_2:setPosition(cc.p(100,0))
    Text_player_lv_n:addChild(_richText_2)
end

function RebelWeekRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.rebel_week_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RebelWeekRankCell.__size == nil then
        RebelWeekRankCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function RebelWeekRankCell:onEnterTransitionFinish()

end

function RebelWeekRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RebelWeekRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.rebel_week_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RebelWeekRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_rebel_week_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_week_rank_n")
    local Panel_rebel_week_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_rebel_week_rank_top_icon")
    local Text_player_name_n = ccui.Helper:seekWidgetByName(root, "Text_player_name_n")
    local Text_player_lv_n = ccui.Helper:seekWidgetByName(root, "Text_player_lv_n")
    local Text_rank_integral_n = ccui.Helper:seekWidgetByName(root, "Text_rank_integral_n")
    if Text_rebel_week_rank_n ~= nil then
        Text_rebel_week_rank_n:setString("")
        Text_player_name_n:setString("")
        Text_player_lv_n:setString("")
        Text_player_lv_n:removeAllChildren(true)
        Text_rank_integral_n:setString("")
        Panel_rebel_week_rank_top_icon:removeBackGroundImage()
    end
end

function RebelWeekRankCell:init(params)
    self._info_data = params[1]
    self._index = params[2]
    self._nType = params[3]

    if self._index ~= nil and self._index <= 15 then
        self:onInit()
    end

    self:setContentSize(RebelWeekRankCell.__size)
    return self
end

function RebelWeekRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.rebel_week_rank_cell, self.roots[1])
end

