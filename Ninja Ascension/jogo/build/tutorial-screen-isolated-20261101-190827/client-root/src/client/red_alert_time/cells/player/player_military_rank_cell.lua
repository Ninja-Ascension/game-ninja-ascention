----------------------------------------------------------------------------------------------------
-- 说明：军衔列表
-------------------------------------------------------------------------------------------------------
PlayerMilitaryRankCell = class("PlayerMilitaryRankCellClass", Window)
PlayerMilitaryRankCell.__size = nil

local player_military_rank_cell_create_terminal = {
    _name = "player_military_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PlayerMilitaryRankCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_military_rank_cell_create_terminal)
state_machine.init()

function PlayerMilitaryRankCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil

    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
    local function init_player_military_rank_cell_cell_terminal()
        
    end
    init_player_military_rank_cell_cell_terminal()           
end

function PlayerMilitaryRankCell:onUpdateDraw()
    local root = self.roots[1]

    local Panel_military_icon = ccui.Helper:seekWidgetByName(root,"Panel_military_icon")
    local Text_military_lv_n = ccui.Helper:seekWidgetByName(root,"Text_military_lv_n")
    local Text_reach_condition_n_1 = ccui.Helper:seekWidgetByName(root,"Text_reach_condition_n_1")
    local Text_reach_condition_n_2 = ccui.Helper:seekWidgetByName(root,"Text_reach_condition_n_2")
    local Text_reach_condition_n_3 = ccui.Helper:seekWidgetByName(root,"Text_reach_condition_n_3")
    local Text_reach_award_n_1 = ccui.Helper:seekWidgetByName(root,"Text_reach_award_n_1")
    local Text_reach_award_n_2 = ccui.Helper:seekWidgetByName(root,"Text_reach_award_n_2")
    local Text_reach_award_n_3 = ccui.Helper:seekWidgetByName(root,"Text_reach_award_n_3")
    local Text_reach_award_n_4 = ccui.Helper:seekWidgetByName(root,"Text_reach_award_n_4")

    Panel_military_icon:removeBackGroundImage()
    Panel_military_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, self._military_info.pic))
    Text_military_lv_n:setString(self._military_info.name)

    Text_reach_condition_n_1:setString(self._military_info.need_military)
    Text_reach_condition_n_2:setString(self._military_info.need_level)
    if 0 == self._military_info.max_user_count then
        Text_reach_condition_n_3:setString(_string_piece_info[310])
    else
        Text_reach_condition_n_3:setString(self._military_info.max_user_count)
    end
    -- 条件不足时显示红色
    if zstring.tonumber(_ED.user_info.total_war_industry) < self._military_info.need_military then
        Text_reach_condition_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        Text_reach_condition_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end
    if zstring.tonumber(_ED.user_info.user_grade) < self._military_info.need_level then
        Text_reach_condition_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        Text_reach_condition_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end

    Text_reach_award_n_1:setString("+"..self._military_info.add_famtion)
    Text_reach_award_n_2:setString("+"..self._military_info.add_attack.."%")
    Text_reach_award_n_3:setString("+"..self._military_info.add_power.."%")
    Text_reach_award_n_4:setString("+"..self._military_info.add_credit)

end

function PlayerMilitaryRankCell:onEnterTransitionFinish()

end

function PlayerMilitaryRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.player.player_military_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if PlayerMilitaryRankCell.__size == nil then
        PlayerMilitaryRankCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_military_icon"), nil, 
    {
        -- terminal_name = "player_skill_upgrade_upgrade",
        terminal_state = 0,
        touch_scale = true,
        touch_black = true,
    },
    nil,1)

    self:onUpdateDraw()
end

function PlayerMilitaryRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.player.player_military_rank_cell, self.roots[1])
end

function PlayerMilitaryRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PlayerMilitaryRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_military_icon = ccui.Helper:seekWidgetByName(root,"Panel_military_icon")
    local Text_military_lv_n = ccui.Helper:seekWidgetByName(root,"Text_military_lv_n")
    local Text_reach_condition_n_1 = ccui.Helper:seekWidgetByName(root,"Text_reach_condition_n_1")
    local Text_reach_condition_n_2 = ccui.Helper:seekWidgetByName(root,"Text_reach_condition_n_2")
    local Text_reach_condition_n_3 = ccui.Helper:seekWidgetByName(root,"Text_reach_condition_n_3")
    local Text_reach_award_n_1 = ccui.Helper:seekWidgetByName(root,"Text_reach_award_n_1")
    local Text_reach_award_n_2 = ccui.Helper:seekWidgetByName(root,"Text_reach_award_n_2")
    local Text_reach_award_n_3 = ccui.Helper:seekWidgetByName(root,"Text_reach_award_n_3")
    local Text_reach_award_n_4 = ccui.Helper:seekWidgetByName(root,"Text_reach_award_n_4")

    if Panel_military_icon ~= nil then
        Panel_military_icon:removeAllChildren(true)
        Panel_military_icon:removeBackGroundImage()
        Text_military_lv_n:setString("")
        Text_reach_condition_n_1:setString("")
        Text_reach_condition_n_2:setString("")
        Text_reach_condition_n_3:setString("")
        Text_reach_award_n_1:setString("")
        Text_reach_award_n_2:setString("")
        Text_reach_award_n_3:setString("")
        Text_reach_award_n_4:setString("")
    end
end

function PlayerMilitaryRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.player.player_military_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function PlayerMilitaryRankCell:init(params)
    self._index = params[1]
    self._military_info = params[2]
    -- if self._index <= 3 then
        self:onInit()
    -- end
    self:setContentSize(PlayerMilitaryRankCell.__size)
end

