--------------------------------------------------------------------------------------------------------------
--  说明：王者之战下注控件
--------------------------------------------------------------------------------------------------------------
SmBattleOfKingsBettingListCell = class("SmBattleOfKingsBettingListCellClass", Window)
SmBattleOfKingsBettingListCell.__size = nil

--创建cell
local sm_battle_of_kings_betting_list_cell_create_terminal = {
    _name = "sm_battle_of_kings_betting_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmBattleOfKingsBettingListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_battle_of_kings_betting_list_cell_create_terminal)
state_machine.init()

function SmBattleOfKingsBettingListCell:ctor()
	self.super:ctor()
	self.roots = {}
    -- app.load("client.cells.utils.resources_icon_cell")
    -- var
    self.datas = nil
    self._from_type = 0

    app.load("client.l_digital.cells.union.union_logo_icon_cell")

	 -- Initialize sm_battle_of_kings_betting_list_cell state machine.
    local function init_sm_battle_of_kings_betting_list_cell_terminal()
        local sm_battle_of_kings_betting_list_cell_exchange_terminal = {
            _name = "sm_battle_of_kings_betting_list_cell_exchange",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local m_type = params._datas.m_type
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if nil ~= response.node and nil ~= response.node.roots then
                            --刷新
                            state_machine.excute("sm_battleof_kings_betting_update_draw", 0, nil)
                        end
                    end
                end
                if cell._from_type == 1 then
                    protocol_command.the_kings_battle_manager.param_list = "2".."\r\n"..m_type..","..cell.datas.user_id
                    NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, instance, responseCallback, false, nil) 
                elseif cell._from_type == 2 then
                    protocol_command.union_warfare_manager.param_list = "5".."\r\n5\r\n"..m_type..","..cell.datas.union_id
                    NetworkManager:register(protocol_command.union_warfare_manager.code, nil, nil, nil, instance, responseCallback, false, nil) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battle_of_kings_betting_list_cell_exchange_terminal)
        state_machine.init()
    end 
    -- call func sm_battle_of_kings_betting_list_cell create state machine.
    init_sm_battle_of_kings_betting_list_cell_terminal()

end

function SmBattleOfKingsBettingListCell:onHeadDraw(headIndex, vipLevel)
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_1")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

    local quality_path = ""
    if tonumber(vipLevel) > 0 then
        quality_path = "images/ui/quality/player_1.png"
    else
        quality_path = "images/ui/quality/player_2.png"
    end
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(SpritKuang,0)

    local big_icon_path = ""
    local pic = tonumber(headIndex)
    if pic >= 9 then
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    end
    local sprit = cc.Sprite:create(big_icon_path)
    sprit:setAnchorPoint(cc.p(0.5,0.5))
    sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(sprit,0)
end

function SmBattleOfKingsBettingListCell:updateDraw()
    local root = self.roots[1]

    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    local Panel_props_1 = ccui.Helper:seekWidgetByName(root,"Panel_props_1")
    Panel_props_1:removeAllChildren(true)
    Panel_props_1:removeBackGroundImage()
    
    local battle_info = "0,0"
    local rank = 0
    local info_id = 0
    local nick = ""
    if self._from_type == 1 then
        --名称
        --Text_name:setString(self.datas.user_name)
        nick = self.datas.user_name
        --等级
        Text_lv:setString(_new_interface_text[30].." "..self.datas.user_level)
        --头像
        self:onHeadDraw(self.datas.user_head_id, self.datas.user_vip_level)
        
        battle_info = _ED.kings_battle.kings_battle_betting
        rank = self.datas.user_rank
        info_id = self.datas.user_id
    elseif self._from_type == 2 then
        --名称
        --Text_name:setString(self.datas.union_name)
        nick = self.datas.union_name
        --等级
        Text_lv:setString(_new_interface_text[30].." "..self.datas.union_level)
        --头像
        local cell = CnionLogoIconCell:createCell()
        cell:init(1,tonumber(self.datas.union_pic),2)
        Panel_props_1:addChild(cell)

        battle_info = _ED.union.union_fight_user_info.bet_info
        rank = self.datas.rank
        info_id = self.datas.union_id
    end
    Text_name:removeAllChildren(true)
    if Text_name._s == nil then
        Text_name._s = Text_name:getContentSize()
    end
    local richTextName = ccui.RichText:create()
    local size = Text_name._s

    if size.width == 0 then
        size.width = Text_name:getFontSize()*6
    end

    Text_name:setString("")
    richTextName:ignoreContentAdaptWithSize(false)
    richTextName:setContentSize(cc.size(size.width, 0))
    richTextName:setAnchorPoint(0, 0)
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(71, 71, 71)
        color_Type_2 = cc.c3b(71, 71, 71)
    else
        color_Type_1 = cc.c3b(255, 255, 255)
        color_Type_2 = cc.c3b(255, 255, 255)
    end
    local rt, count, text = draw.richTextCollectionMethod(richTextName, 
    nick, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    Text_name:getFontName(), 
    Text_name:getFontSize(),
    chat_rich_text_color)
    richTextName:formatTextExt()
    local rich_size = richTextName:getContentSize()
    richTextName:setPositionY(size.height/2 + rich_size.height/2)
    Text_name:addChild(richTextName)

    -- 排名
    local Text_pm = ccui.Helper:seekWidgetByName(root,"Text_pm")
    Text_pm:setString("")
    for i = 1, 3 do
        local Image_pm = ccui.Helper:seekWidgetByName(root,"Image_pm"..i)
        Image_pm:setVisible(false)
    end
    if tonumber(rank) <= 3 then
        local Image_pm = ccui.Helper:seekWidgetByName(root,"Image_pm"..rank)
        Image_pm:setVisible(true)
    else
        Text_pm:setString(rank)
    end

    --赔率
    local Text_odds = ccui.Helper:seekWidgetByName(root,"Text_odds")
    if zstring.tonumber(self.datas.betting_count) <= 0 then
        Text_odds:setString(_new_interface_text[202])
    else
        Text_odds:setString(self.datas.percent)
    end
    if battle_info ~= "0,0" then
        ccui.Helper:seekWidgetByName(root,"Button_pt"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_pt"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_gj"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_gj"):setBright(false)
        local battle_data = zstring.split(battle_info, ",")
        if tonumber(battle_data[2]) == tonumber(info_id) then
            if tonumber(battle_data[1]) > 0 then
                ccui.Helper:seekWidgetByName(root,"Button_pt"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Button_gj"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Image_yxz_1"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Image_yxz_2"):setVisible(true)
            else
                ccui.Helper:seekWidgetByName(root,"Button_pt"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Button_gj"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_yxz_1"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_yxz_2"):setVisible(false)
            end
        else
            ccui.Helper:seekWidgetByName(root,"Button_pt"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Button_gj"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_yxz_1"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_yxz_2"):setVisible(false)
        end
    end 

    if self._from_type == 2 then
        local cost = zstring.split(dms.string(dms["union_config"], 60, union_config.param), ",")
        for i=1,2 do
            local Text_money = ccui.Helper:seekWidgetByName(root, "Text_money_"..i)
            local info = tonumber(cost[i])
            if info >= 10000 then
                info = math.floor(info/1000)..string_equiprety_name[40]
            -- elseif info > 100000000 then
            --     info = math.floor(info/100000000)..string_equiprety_name[38]
            else
                info = info
            end
            Text_money:setString(info)
        end
    else
        local cost = zstring.split(dms.string(dms["play_config"], 41, play_config.param), ",")
        for i=1,2 do
            local Text_money = ccui.Helper:seekWidgetByName(root, "Text_money_"..i)
            local info = tonumber(cost[i])
            if info >= 10000 then
                info = math.floor(info/1000)..string_equiprety_name[40]
            -- elseif info > 100000000 then
            --     info = math.floor(info/100000000)..string_equiprety_name[38]
            else
                info = info
            end
            Text_money:setString(info)
        end
    end
end

function SmBattleOfKingsBettingListCell:onUpdate(dt)

end

function SmBattleOfKingsBettingListCell:onInit()
    local root = cacher.createUIRef("campaign/BattleofKings/battle_of_kings_stake_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmBattleOfKingsBettingListCell.__size == nil then
        SmBattleOfKingsBettingListCell.__size = root:getContentSize()
    end

    --普通
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pt"), nil, 
    {
        terminal_name = "sm_battle_of_kings_betting_list_cell_exchange", 
        m_type = 0,
        terminal_state = 0, 
        cell = self
    }, nil, 1)
    
    --高级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gj"), nil, 
    {
        terminal_name = "sm_battle_of_kings_betting_list_cell_exchange", 
        m_type = 1,
        terminal_state = 0, 
        cell = self
    }, nil, 1)

	self:updateDraw()
end

function SmBattleOfKingsBettingListCell:onEnterTransitionFinish()

end

function SmBattleOfKingsBettingListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_props_1 = ccui.Helper:seekWidgetByName(root,"Panel_props_1")
    local Button_pt = ccui.Helper:seekWidgetByName(root,"Button_pt"):setVisible(true)
    local Button_gj = ccui.Helper:seekWidgetByName(root,"Button_gj"):setVisible(true)
    local Image_yxz_1 = ccui.Helper:seekWidgetByName(root,"Image_yxz_1"):setVisible(false)
    local Image_yxz_2 = ccui.Helper:seekWidgetByName(root,"Image_yxz_2"):setVisible(false)
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    local Text_odds = ccui.Helper:seekWidgetByName(root,"Text_odds")
    local Text_money_1 = ccui.Helper:seekWidgetByName(root, "Text_money_1")
    local Text_money_2 = ccui.Helper:seekWidgetByName(root, "Text_money_2")

    if Panel_props_1 ~= nil then
        Panel_props_1:removeAllChildren(true)
    end

    if Button_pt then
        Button_pt:setTouchEnabled(true)
        Button_pt:setBright(true)
        Button_pt:setVisible(true)
    end

    if Button_gj then
        Button_gj:setTouchEnabled(true)
        Button_gj:setBright(true)
        Button_gj:setVisible(true)
    end

    if Image_yxz_1 then
        Image_yxz_1:setVisible(false)
    end

    if Image_yxz_2 then
        Image_yxz_2:setVisible(false)
    end

    if Text_name then
        Text_name:setString("")
    end

    if Text_lv then
        Text_lv:setString("")
    end

    if Text_odds then
        Text_odds:setString("")
    end

    if Text_money_1 then
        Text_money_1:setString("")
    end

    if Text_money_2 then
        Text_money_2:setString("")
    end
end

function SmBattleOfKingsBettingListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmBattleOfKingsBettingListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_stake_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmBattleOfKingsBettingListCell:init(params)
    self.datas = params[1]
    self._from_type = params[2]
	self:onInit()

    self:setContentSize(SmBattleOfKingsBettingListCell.__size)
    return self
end

function SmBattleOfKingsBettingListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_stake_list.csb", self.roots[1])
    state_machine.remove("sm_battle_of_kings_betting_list_cell_exchange")
end