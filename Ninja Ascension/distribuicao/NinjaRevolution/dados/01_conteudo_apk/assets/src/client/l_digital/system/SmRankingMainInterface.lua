-----------------------------
-- 排行榜主界面
-----------------------------
SmRankingMainInterface = class("SmRankingMainInterfaceClass", Window)

--打开界面
local sm_ranking_main_interface_open_terminal = {
	_name = "sm_ranking_main_interface_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(168) == true then
            return false
        end
		if fwin:find("SmRankingMainInterfaceClass") == nil then
			fwin:open(SmRankingMainInterface:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_ranking_main_interface_close_terminal = {
	_name = "sm_ranking_main_interface_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.excute("union_unlock_state_machine", 0, nil)
        -- fwin:close(fwin:find("UserTopInfoAClass"))
        -- state_machine.excute("menu_back_home_page", 0, "") 
		fwin:close(fwin:find("SmRankingMainInterfaceClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_ranking_main_interface_open_terminal)
state_machine.add(sm_ranking_main_interface_close_terminal)
state_machine.init()

function SmRankingMainInterface:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._combat_power = nil
    self._check_mark = nil
    self._tame_beast = nil
    self._digital_beast = nil
    self._guild = nil
    self._king_of_the_war= nil

    app.load("client.l_digital.system.SmRankCombatPower")
    app.load("client.l_digital.system.SmRankCheckMark")
    app.load("client.l_digital.system.SmRankTameBeast")
    app.load("client.l_digital.system.SmRankDigitalBeast")
    app.load("client.l_digital.system.SmRankGuild")
    app.load("client.l_digital.system.SmRankKingOfTheWar")
    app.load("client.l_digital.cells.union.union_logo_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")


    local function init_sm_ranking_main_interface_terminal()
        local sm_ranking_main_interface_change_page_terminal = {
            _name = "sm_ranking_main_interface_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开排行榜
        local sm_ranking_main_interface_open_rank_terminal = {
            _name = "sm_ranking_main_interface_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = tonumber(params._datas._page)
                local m_type = params._datas.m_type
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:changeSelectPage(page)
                            instance:UpdateDrawLeftInterface()
                        end
                    end
                end
                protocol_command.order_get_info.param_list = m_type.."\r\n".."1".."\r\n".."10"
                NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开工会排行
        local sm_ranking_union_open_rank_terminal = {
            _name = "sm_ranking_union_open_rank",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = tonumber(params._datas._page)
                local m_type = params._datas.m_type
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:changeSelectPage(page)
                            instance:UpdateDrawLeftInterface()
                        end
                    end
                end
                protocol_command.union_order.param_list = "1".. "\r\n" .."10".."\r\n0"
                NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --查看第一名
        local sm_ranking_union_view_the_first_place_terminal = {
            _name = "sm_ranking_union_view_the_first_place",
            _init = function (terminal)
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                app.load("client.l_digital.union.create.SmUnionInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance._current_page) == 1 or tonumber(instance._current_page) == 2 or tonumber(instance._current_page) == 3 or tonumber(instance._current_page) == 4 or tonumber(instance._current_page) == 6 then
                    local datas = nil
                    if tonumber(instance._current_page) == 1 then
                        datas = _ED.fight_ranks.other_user[1]
                    elseif tonumber(instance._current_page) == 2 then
                        datas = _ED.npc_rank.other_user[1]
                    elseif tonumber(instance._current_page) == 3 then
                        datas = _ED.card_number_rank.other_user[1]
                    elseif tonumber(instance._current_page) == 4 then
                        datas = _ED.strongest_card_rank.other_user[1]
                    elseif tonumber(instance._current_page) == 6 then
                        datas = _ED.battle_kings_score_rank.other_user[1]
                    end
                    if datas == nil then
                        return
                    end
                    local function responseShowUserInfoCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                local datainfo = datas
                                datainfo.icon = datas.user_head_id
                                datainfo.name = datas.user_name
                                datainfo.level = datas.user_level
                                datainfo.rank = datas.user_rank
                                datainfo.force = _ED.chat_user_info.fighting
                                datainfo.vip = datas.user_vip_level
                                datainfo.template = {}
                                datainfo.template[1] = _ED.chat_user_info.formation
                                if datas.user_union_name == "" then
                                    datainfo.arame = "?"
                                else
                                    datainfo.arame = datas.user_union_name
                                end
                                state_machine.excute("sm_arena_player_info_window_open",0,datainfo)
                            end
                        end
                    end
                    protocol_command.see_user_info.param_list = datas.user_id
                    NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, instance, responseShowUserInfoCallBack, false, nil)
                -- elseif tonumber(instance._current_page) == 4 then
                    -- local function responseShowUserInfoCallBack(response)
                    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    --         app.load("client.packs.hero.SmRoleInformation")
                    --         state_machine.excute("sm_role_information_open", 0, {_ED.strongest_card_rank.other_user[1].ship_id,-1})
                    --     end
                    -- end
                    -- protocol_command.get_other_user_ship_info.param_list = _ED.strongest_card_rank.other_user[1].user_id.."\r\n".._ED.strongest_card_rank.other_user[1].ship_id
                    -- NetworkManager:register(protocol_command.get_other_user_ship_info.code, nil, nil, nil, instance, responseShowUserInfoCallBack, false, nil)
                elseif tonumber(instance._current_page) == 5 then
                    if _ED.union.rank_union_list_info[1] ~= nil then
                        local datas = {}
                        datas.example = {}
                        datas.example.union_icon = _ED.union.rank_union_list_info[1].nuion_icon
                        datas.example.union_kuang = 1
                        datas.example.union_name = _ED.union.rank_union_list_info[1].union_name
                        datas.example.union_president_name = _ED.union.rank_union_list_info[1].union_president_name
                        datas.example.union_id = _ED.union.rank_union_list_info[1].union_id
                        datas.example.union_rank = _ED.union.rank_union_list_info[1].union_rank
                        datas.example.union_level = _ED.union.rank_union_list_info[1].union_level
                        datas.example.union_member = _ED.union.rank_union_list_info[1].union_member
                        datas.example.union_watchword = _ED.union.rank_union_list_info[1].watchword
                        state_machine.excute("sm_union_info_window_window_open", 0, datas.example)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
        state_machine.add(sm_ranking_main_interface_change_page_terminal)
        state_machine.add(sm_ranking_main_interface_open_rank_terminal)
        state_machine.add(sm_ranking_union_open_rank_terminal)
        state_machine.add(sm_ranking_union_view_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_ranking_main_interface_terminal()
end

-- 刷新王者之战按钮的状态
function SmRankingMainInterface:updateKingOfTheWarButtonState()
    local root = self.roots[1]
    local Text_rank_tab_6 = ccui.Helper:seekWidgetByName(root, "Text_rank_tab_6")
    local Button_rank_tab_6 = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_6")
    
    -- 数据在打开排行榜之前就需要请求，状态机 home_click_fame_hall_manager
    if _ED.battle_kings_score_rank ~= nil and _ED.battle_kings_score_rank.other_user ~= nil then
        local isShow = #_ED.battle_kings_score_rank.other_user > 0
        if Text_rank_tab_6 ~= nil then
            Text_rank_tab_6:setVisible(isShow)
        end

        if Button_rank_tab_6 ~= nil then
            Button_rank_tab_6:setVisible(isShow)
        end
    end
end

--画左边的界面
function SmRankingMainInterface:UpdateDrawLeftInterface()
    local root = self.roots[1]
    for i=1,6 do 
        ccui.Helper:seekWidgetByName(root, "Image_title_bar_"..i):setVisible(false)
    end
    ccui.Helper:seekWidgetByName(root, "Image_title_bar_"..tonumber(self._current_page)):setVisible(true)

    --头像
    local Panel_best_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_best_player_icon")
    Panel_best_player_icon:removeAllChildren(true)
    --文字1
    local Text_best_info_1 = ccui.Helper:seekWidgetByName(root, "Text_best_info_1")
    Text_best_info_1:setString("")
    --文字2
    local Text_best_info_2 = ccui.Helper:seekWidgetByName(root, "Text_best_info_2")
    Text_best_info_2:setString("")
    --文字3
    local Text_best_info_3 = ccui.Helper:seekWidgetByName(root, "Text_best_info_3")
    Text_best_info_3:setString("")

    --自己的排名
    local Text_my_raning = ccui.Helper:seekWidgetByName(root, "Text_my_raning")
    Text_my_raning:setString("")
    --自己的工会图标
    local Panel_my_gh_icon = ccui.Helper:seekWidgetByName(root, "Panel_my_gh_icon")
    Panel_my_gh_icon:removeAllChildren(true)
    --自己的名称
    local Text_my_ranking_info_1 = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_1")
    Text_my_ranking_info_1:setString("")

    Text_my_ranking_info_1:getParent():removeChildByName("_richText2")

    --自己的等级
    local Text_my_ranking_info_2 = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_2")
    Text_my_ranking_info_2:setString("")
    --自己的战力，关卡星数，驯兽数，最强卡牌战力，工会战力，
    local Text_my_ranking_info_3 = ccui.Helper:seekWidgetByName(root, "Text_my_ranking_info_3")
    Text_my_ranking_info_3:setString("")
    --自己的工会名称
    local Text_my_gh_name = ccui.Helper:seekWidgetByName(root, "Text_my_gh_name")
    Text_my_gh_name:setString("")
    --自己的工会等级
    local Text_my_gh_lv = ccui.Helper:seekWidgetByName(root, "Text_my_gh_lv")
    Text_my_gh_lv:setString("")
    --自己的最强卡牌头像
    local Panel_my_digimon = ccui.Helper:seekWidgetByName(root, "Panel_my_digimon")
    Panel_my_digimon:removeAllChildren(true)
    local names = ""
    if tonumber(self._current_page) == 1 then
        --战斗力
        Text_my_raning:setString(_ED.fight_ranks.my_info.now_rank)
        names = _ED.user_info.user_name
        -- Text_my_ranking_info_1:setString(_ED.user_info.user_name)
        Text_my_ranking_info_2:setString(_ED.user_info.user_grade)
        Text_my_ranking_info_3:setString(_ED.fight_ranks.my_info.fight_number)

        Text_best_info_1:setString(_ED.fight_ranks.other_user[1].user_name)
        Text_best_info_2:setString(_new_interface_text[103].." ".._ED.fight_ranks.other_user[1].user_level)
        Text_best_info_3:setString(_new_interface_text[104].." ".._ED.fight_ranks.other_user[1].user_union_name)
    elseif tonumber(self._current_page) == 2 then
        --关卡星级
        Text_my_raning:setString(_ED.npc_rank.my_info.user_rank)
        names = _ED.user_info.user_name
        -- Text_my_ranking_info_1:setString(_ED.user_info.user_name)
        Text_my_ranking_info_2:setString(_ED.user_info.user_grade)
        Text_my_ranking_info_3:setString(_ED.npc_rank.my_info.npc_count)
        
        Text_best_info_1:setString(_ED.npc_rank.other_user[1].user_name)
        Text_best_info_2:setString(_new_interface_text[103].." ".._ED.npc_rank.other_user[1].user_level)
        Text_best_info_3:setString(_new_interface_text[104].." ".._ED.npc_rank.other_user[1].user_union_name)
    elseif tonumber(self._current_page) == 3 then
        --驯兽师
        Text_my_raning:setString(_ED.card_number_rank.my_info.user_rank)
        names = _ED.user_info.user_name
        -- Text_my_ranking_info_1:setString(_ED.user_info.user_name)
        Text_my_ranking_info_2:setString(_ED.card_number_rank.my_info.user_speed)
        Text_my_ranking_info_3:setString(_ED.card_number_rank.my_info.card_count)
        
        Text_best_info_1:setString(_ED.card_number_rank.other_user[1].user_name)
        Text_best_info_2:setString(_new_interface_text[103].." ".._ED.card_number_rank.other_user[1].user_level)
        Text_best_info_3:setString(_new_interface_text[104].." ".._ED.card_number_rank.other_user[1].user_union_name)
    elseif tonumber(self._current_page) == 4 then
        --数码兽
        Text_my_raning:setString(_ED.strongest_card_rank.my_info.user_rank)
        names = _ED.user_info.user_name
        -- Text_my_ranking_info_1:setString(_ED.user_info.user_name)
        --模板id:等级:进阶数据:星级:品阶:战力:皮肤
        local shipData = zstring.split(_ED.strongest_card_rank.my_info.ship_info, ":")
        local cell = HeroIconListCell:createCell()
        local ship = {}
        ship.ship_template_id = shipData[1]
        ship.evolution_status = shipData[3]
        ship.Order = shipData[5]
        ship.StarRating = shipData[4]
        ship.ship_grade = shipData[2]
        ship.ship_id = -1
        ship.skin_id = shipData[7]
        cell:init(ship, i,true)
        Panel_my_digimon:addChild(cell)
        Text_my_ranking_info_3:setString(_ED.strongest_card_rank.my_info.ship_fight)
        
        Text_best_info_1:setString(_ED.strongest_card_rank.other_user[1].user_name)
        Text_best_info_2:setString(_new_interface_text[103].." ".._ED.strongest_card_rank.other_user[1].user_level)
        Text_best_info_3:setString(_new_interface_text[104].." ".._ED.strongest_card_rank.other_user[1].user_union_name)
    elseif tonumber(self._current_page) == 5 then
        --公会
        if _ED.my_union_rank ~= nil then
            Text_my_raning:setString(_ED.my_union_rank)
            local quality = tonumber(_ED.my_union_iocn)
            local kuang = 1
            local cell = CnionLogoIconCell:createCell()
            cell:init(kuang,quality,nil)
            Panel_my_gh_icon:addChild(cell)
            Text_my_gh_name:setString(_ED.my_union_name)
            Text_my_gh_lv:setString("Lv.".._ED.my_union_level)
            Text_my_ranking_info_3:setString(_ED.my_union_fight)
            Text_my_ranking_info_2:setString(_ED.my_union_chairman)
        else
            names = _new_interface_text[110]
            -- Text_my_ranking_info_1:setString(_new_interface_text[110]) 
        end
        if _ED.union.rank_union_list_info[1] ~= nil then
            
            Text_best_info_1:setString(_ED.union.rank_union_list_info[1].union_name)
            Text_best_info_2:setString(_new_interface_text[103].." ".._ED.union.rank_union_list_info[1].union_level)
            Text_best_info_3:setString(union_job_title[1]..": ".._ED.union.rank_union_list_info[1].union_president_name)
        end
    elseif tonumber(self._current_page) == 6 then
        --王者之战
        if tonumber(_ED.battle_kings_score_rank.my_info.user_rank) < 0 then
            Text_my_raning:setString("0")
        else
            Text_my_raning:setString(_ED.battle_kings_score_rank.my_info.user_rank)
        end
        names = _ED.user_info.user_name
        -- Text_my_ranking_info_1:setString(_ED.user_info.user_name)
        Text_my_ranking_info_2:setString(_ED.battle_kings_score_rank.my_info.layer_count)
        Text_my_ranking_info_3:setString(_ED.battle_kings_score_rank.my_info.score)
        if _ED.battle_kings_score_rank.other_user ~= nil and _ED.battle_kings_score_rank.other_user[1] ~= nil then
            
            Text_best_info_1:setString(_ED.battle_kings_score_rank.other_user[1].user_name)
            Text_best_info_2:setString(_new_interface_text[103].." ".._ED.battle_kings_score_rank.other_user[1].user_level)
            Text_best_info_3:setString(_new_interface_text[104].." ".._ED.battle_kings_score_rank.other_user[1].user_union_name)
        else
            Text_best_info_1:setString("")
            Text_best_info_2:setString("")
            Text_best_info_3:setString("")
        end
    end 
    Text_my_ranking_info_1:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    local _width = Text_my_ranking_info_1:getContentSize().width == 0 and tonumber(Text_my_ranking_info_1:getFontSize())*7 or Text_my_ranking_info_1:getContentSize().width
    _richText2:setContentSize(cc.size(_width, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(71,71,71)
        color_Type_2 = cc.c3b(71,71,71)
    elseif __lua_project_id == __lua_project_l_digital then 
        -- DSC重塑
        color_Type_1 = Text_my_ranking_info_1:getColor()
        color_Type_2 = Text_my_ranking_info_1:getColor()
    else
        color_Type_1 = cc.c3b(255, 255, 0)
        color_Type_2 = cc.c3b(255, 255, 0)
    end
    local char_str = names
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    Text_my_ranking_info_1:getFontName(), 
    Text_my_ranking_info_1:getFontSize(),
    chat_rich_text_color)
    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()

    _richText2:setPosition(cc.p(Text_my_ranking_info_1:getPositionX() - _richText2:getContentSize().width / 2, Text_my_ranking_info_1:getPositionY() + _richText2:getContentSize().height / 2))
    _richText2:setName("_richText2")
    Text_my_ranking_info_1:getParent():addChild(_richText2)

    self:updateDrawIcon()
    self:updateDrawUserIcon()
end

-- 绘制玩家自己的头像
function SmRankingMainInterface:updateDrawUserIcon()
    local root = self.roots[1]
    local Panel_my_gh_icon = ccui.Helper:seekWidgetByName(root, "Panel_my_gh_icon")
    local currentPage = tonumber(self._current_page)
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
    if (currentPage == 1 or currentPage == 2 or currentPage == 3 or currentPage == 6) and fun_is_open == true then
        Panel_my_gh_icon:removeAllChildren(true)
        local headIconInfo = {
            headFrameID = _ED.user_info.head_frame.curHeadFrameID,
            headFrameStage = _ED.user_info.head_frame.curHeadFrameStage,
            headID = _ED.user_info.user_head,
        }
        local headIcon = CreateHeadIconCell(headIconInfo)

        Panel_my_gh_icon:addChild(headIcon)
    end
end

-- 绘制头像
function SmRankingMainInterface:updateDrawIcon()
    local headIcon = nil
    local root = self.roots[1]
    local Panel_best_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_best_player_icon")
    Panel_best_player_icon:removeAllChildren(true)
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)

    if tonumber(self._current_page) == 1 then
        -- 新增头像框
        if fun_is_open == true then
            local headIconInfo = {
                headFrameID = _ED.fight_ranks.other_user[1].headFrameID,
                headFrameStage = _ED.fight_ranks.other_user[1].headFrameStage,
                headID = _ED.fight_ranks.other_user[1].user_head_id,
            }
            
            headIcon = CreateHeadIconCell(headIconInfo)
        else
            headIcon = self:onHeadDraw(_ED.fight_ranks.other_user[1].user_head_id, _ED.fight_ranks.other_user[1].user_vip_level)
        end
    elseif tonumber(self._current_page) == 2 then
        if fun_is_open == true then
            local headIconInfo = {
                headFrameID = _ED.npc_rank.other_user[1].headFrameID,
                headFrameStage = _ED.npc_rank.other_user[1].headFrameStage,
                headID = _ED.npc_rank.other_user[1].user_head_id,
            }

            
            headIcon = CreateHeadIconCell(headIconInfo)
        else
            headIcon = self:onHeadDraw(_ED.npc_rank.other_user[1].user_head_id, _ED.npc_rank.other_user[1].user_vip_level)
        end
    elseif tonumber(self._current_page) == 3 then
        if fun_is_open == true then
            local headIconInfo = {
                headFrameID = _ED.card_number_rank.other_user[1].headFrameID,
                headFrameStage = _ED.card_number_rank.other_user[1].headFrameStage,
                headID = _ED.card_number_rank.other_user[1].user_head_id,
            }

            headIcon = CreateHeadIconCell(headIconInfo)
        else
            headIcon = self:onHeadDraw(_ED.card_number_rank.other_user[1].user_head_id, _ED.card_number_rank.other_user[1].user_vip_level)
        end
    elseif tonumber(self._current_page) == 4 then
        if fun_is_open == true then
            local headIconInfo = {
                headFrameID = _ED.strongest_card_rank.other_user[1].headFrameID,
                headFrameStage = _ED.strongest_card_rank.other_user[1].headFrameStage,
                headID = _ED.strongest_card_rank.other_user[1].user_head_id,
            }

            headIcon = CreateHeadIconCell(headIconInfo)
        else
            headIcon = self:onHeadDraw(_ED.strongest_card_rank.other_user[1].user_head_id, _ED.strongest_card_rank.other_user[1].user_vip_level)
        end
    elseif tonumber(self._current_page) == 5 then
        headIcon = CnionLogoIconCell:createCell()
        headIcon:init(1,tonumber(_ED.union.rank_union_list_info[1].nuion_icon),1)
        headIcon:setPosition(cc.p(headIcon:getPositionX()+10,headIcon:getPositionY()+10))
    elseif tonumber(self._current_page) == 6 then
        if _ED.battle_kings_score_rank.other_user ~= nil and _ED.battle_kings_score_rank.other_user[1] ~= nil then
            if fun_is_open == true then
                local headIconInfo = {
                    headFrameID = _ED.battle_kings_score_rank.other_user[1].headFrameID,
                    headFrameStage = _ED.battle_kings_score_rank.other_user[1].headFrameStage,
                    headID = _ED.battle_kings_score_rank.other_user[1].user_head_id,
                }
    
                headIcon = CreateHeadIconCell(headIconInfo)
            else
                headIcon = self:onHeadDraw(_ED.battle_kings_score_rank.other_user[1].user_head_id, _ED.battle_kings_score_rank.other_user[1].user_vip_level)
            end
        end
    end

    if headIcon ~= nil then
        Panel_best_player_icon:addChild(headIcon)
    end
end

function SmRankingMainInterface:onHeadDraw(headIndex, vipLevel)
    -- local csbItem = csb.createNode("icon/item.csb")
    -- local roots = csbItem:getChildByName("root")
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)
    self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
    if self.item_order_level._x == nil then
        self.item_order_level._x = self.item_order_level:getPositionX()
    end

    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
        Panel_head:removeBackGroundImage()
    end
    if Panel_kuang ~= nil then
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end
    local quality_path = 0
    local quality_kuang = 1
    if tonumber(vipLevel) > 0 then
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 5)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 14)
    else
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 1)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 1)
    end
    local big_icon_path = nil
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    Panel_ditu:setBackGroundImage(quality_path)
    Panel_kuang:setBackGroundImage(quality_kuang)
    Panel_head:setBackGroundImage(big_icon_path)
    Panel_head:setTouchEnabled(false)
    return roots
end

function SmRankingMainInterface:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_phb_listview = ccui.Helper:seekWidgetByName(root, "Panel_phb_listview")
    local Button_rank_tab_1 = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_1")
    local Button_rank_tab_2 = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_2")
    local Button_rank_tab_3 = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_3")
    local Button_rank_tab_4 = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_4")
    local Button_rank_tab_5 = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_5")
    local Button_rank_tab_6 = ccui.Helper:seekWidgetByName(root, "Button_rank_tab_6")

    -- DSC重塑
    local textTable = {}
    if __lua_project_id == __lua_project_l_digital then
        local Text_rank_1 = ccui.Helper:seekWidgetByName(root, "Text_rank_1")
        local Text_rank_2 = ccui.Helper:seekWidgetByName(root, "Text_rank_2")
        local Text_rank_3 = ccui.Helper:seekWidgetByName(root, "Text_rank_3")
        local Text_rank_4 = ccui.Helper:seekWidgetByName(root, "Text_rank_4")
        local Text_rank_5 = ccui.Helper:seekWidgetByName(root, "Text_rank_5")
        local Text_rank_6 = ccui.Helper:seekWidgetByName(root, "Text_rank_6")

        table.insert(textTable, Text_rank_1)
        table.insert(textTable, Text_rank_2)
        table.insert(textTable, Text_rank_3)
        table.insert(textTable, Text_rank_4)
        table.insert(textTable, Text_rank_5)
        table.insert(textTable, Text_rank_6)
        for i, v in ipairs(textTable) do
            if v ~= nil then
                v:setVisible(false)
            end
        end
    end
    if page == self._current_page then
        if page == 1 then
            Button_rank_tab_1:setHighlighted(true)
        elseif page == 2 then
            Button_rank_tab_2:setHighlighted(true)
        elseif page == 3 then
            Button_rank_tab_3:setHighlighted(true)
        elseif page == 4 then
            Button_rank_tab_4:setHighlighted(true)
        elseif page == 5 then    
            Button_rank_tab_5:setHighlighted(true)
		elseif page == 6 then    
            Button_rank_tab_6:setHighlighted(true)
        end

        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and textTable[page] ~= nil then
            textTable[page]:setVisible(true)
        end
        return
    end
    self._current_page = page
    Button_rank_tab_1:setHighlighted(false)
    Button_rank_tab_2:setHighlighted(false)
    Button_rank_tab_3:setHighlighted(false)
    Button_rank_tab_4:setHighlighted(false)
    Button_rank_tab_5:setHighlighted(false)
    Button_rank_tab_6:setHighlighted(false)
    state_machine.excute("sm_rank_combat_power_hide", 0, nil)
    state_machine.excute("sm_rank_check_mark_hide", 0, nil)
    state_machine.excute("sm_rank_tame_beast_hide", 0, nil)
    state_machine.excute("sm_rank_digital_beast_hide", 0, nil)
    state_machine.excute("sm_rank_guild_hide", 0, nil)
    state_machine.excute("sm_rank_king_of_the_war_hide", 0, nil)
	
    if page == 1 then
        Button_rank_tab_1:setHighlighted(true)
        if self._combat_power == nil then
            self._combat_power = state_machine.excute("sm_rank_combat_power_open", 0, {Panel_phb_listview})
        else
            state_machine.excute("sm_rank_combat_power_show", 0, nil)
        end
	elseif page == 2 then
		Button_rank_tab_2:setHighlighted(true)
		if self._check_mark == nil then
            self._check_mark = state_machine.excute("sm_rank_check_mark_open", 0, {Panel_phb_listview})
        else
            state_machine.excute("sm_rank_check_mark_show", 0, nil)
        end
	elseif page == 3 then
		Button_rank_tab_3:setHighlighted(true)
		if self._tame_beast == nil then
            self._tame_beast = state_machine.excute("sm_rank_tame_beast_open", 0, {Panel_phb_listview})
        else
            state_machine.excute("sm_rank_tame_beast_show", 0, nil)
        end
	elseif page == 4 then
		Button_rank_tab_4:setHighlighted(true)
		if self._digital_beast == nil then
            self._digital_beast = state_machine.excute("sm_rank_digital_beast_open", 0, {Panel_phb_listview})
        else
            state_machine.excute("sm_rank_digital_beast_show", 0, nil)
        end	
    elseif page == 5 then
		Button_rank_tab_5:setHighlighted(true)
        if self._guild == nil then
            self._guild = state_machine.excute("sm_rank_guild_open", 0, {Panel_phb_listview})
        else
            state_machine.excute("sm_rank_guild_show", 0, nil)
        end
    else
        Button_rank_tab_6:setHighlighted(true)
        if self._consumables == nil then
            self._consumables = state_machine.excute("sm_rank_king_of_the_war_open", 0, {Panel_phb_listview})
        else
            state_machine.excute("sm_rank_king_of_the_war_show", 0, nil)
        end   
	end

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        if textTable[page] ~= nil then
            textTable[page]:setVisible(true)
        end
    end
end

function SmRankingMainInterface:init(params)
    self.pages = params
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmRankingMainInterface:onInit()
    local csbItem = csb.createNode("system/sm_ranking.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_phb_back"), nil, 
    {
        terminal_name = "sm_ranking_main_interface_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --战斗力排行榜
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_tab_1"), nil, 
    {
        terminal_name = "sm_ranking_main_interface_open_rank", 
        terminal_state = 0, 
        _page = 1,
        m_type = 0,
    }, nil, 0)
	
    --关卡得星排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_tab_2"), nil, 
    {
        terminal_name = "sm_ranking_main_interface_open_rank", 
        terminal_state = 0, 
        _page = 2,
        m_type = 1,
    }, nil, 0)

    --驯兽榜
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_tab_3"), nil, 
    {
        terminal_name = "sm_ranking_main_interface_open_rank", 
        terminal_state = 0, 
        _page = 3,
        m_type = 3,
    }, nil, 0)

    --数码兽
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_tab_4"), nil, 
    {
        terminal_name = "sm_ranking_main_interface_open_rank", 
        terminal_state = 0, 
        _page = 4,
        m_type = 4,
    }, nil, 0)

    --公会排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_tab_5"), nil, 
    {
        terminal_name = "sm_ranking_union_open_rank", 
        terminal_state = 0, 
        _page = 5,
        m_type = 0,
    }, nil, 0)

    --王者之战排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_tab_6"), nil, 
    {
        terminal_name = "sm_ranking_main_interface_open_rank", 
        terminal_state = 0, 
        _page = 6,
        m_type = 7,
    }, nil, 0)
    
    --查看第一名
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chakan"), nil, 
    {
        terminal_name = "sm_ranking_union_view_the_first_place", 
        terminal_state = 0, 
    }, nil, 0)

    -- 显示/隐藏王者之战按钮
    self:updateKingOfTheWarButtonState()

    if zstring.tonumber(self.pages) ~= 0 then
        local m_type = 0
        if zstring.tonumber(self.pages) == 5 then 
            m_type = 0
            state_machine.excute("sm_ranking_union_open_rank", 0, {_datas = {_page = zstring.tonumber(self.pages),m_type = m_type}}) 
        else
            if zstring.tonumber(self.pages) == 1 then
                m_type = 0
            elseif zstring.tonumber(self.pages) == 2 then
                m_type = 1
            elseif zstring.tonumber(self.pages) == 3 then
                m_type = 3
            elseif zstring.tonumber(self.pages) == 4 then
                m_type = 4
            elseif zstring.tonumber(self.pages) == 6 then
                m_type = 7
            end
            state_machine.excute("sm_ranking_main_interface_open_rank", 0, {_datas = {_page = zstring.tonumber(self.pages),m_type = m_type}}) 
        end
        
    else
        state_machine.excute("sm_ranking_main_interface_open_rank", 0, {_datas = {_page = 1,m_type = 0}}) 
    end

    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._view)

    local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
        local jsonFile = "images/ui/effice/effect_chixu/effect_chixu.json"
        local atlasFile = "images/ui/effice/effect_chixu/effect_chixu.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation2:setPosition(cc.p(Panel_effec:getContentSize().width/2,0))
        Panel_effec:addChild(animation2)
    end
end

function SmRankingMainInterface:onEnterTransitionFinish()
    
end

function SmRankingMainInterface:clearUIInfo( ... )
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        local root = self.roots[2]
        local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
        local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
        local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
        local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
        local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
        local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
        local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
        local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
        local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
        local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
        local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
        local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
        local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
        local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
        local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
        local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
        local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
        local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
        local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
        local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
        local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
        if Image_double ~= nil then
            Image_double:setVisible(false)
        end
        if Image_xuanzhong ~= nil then
            Image_xuanzhong:setVisible(false)
        end
        if Image_3 ~= nil then
            Image_3:setVisible(false)
        end
        if Label_l_order_level ~= nil then 
            Label_l_order_level:setVisible(true)
            if Label_l_order_level._x then
                Label_l_order_level:setPositionX(Label_l_order_level._x)
            end
            Label_l_order_level:setString("")
        end
        if Label_name ~= nil then
            Label_name:setString("")
            Label_name:setVisible(true)
        end
        if Label_quantity ~= nil then
            Label_quantity:setString("")
        end
        if Label_shuxin ~= nil then
            Label_shuxin:setString("")
        end
        if Panel_prop ~= nil then
            Panel_prop:removeAllChildren(true)
            Panel_prop:removeBackGroundImage()
        end
        if Panel_kuang ~= nil then
            Panel_kuang:removeAllChildren(true)
            Panel_kuang:removeBackGroundImage()
        end
        if Panel_ditu ~= nil then
            Panel_ditu:removeAllChildren(true)
            Panel_ditu:removeBackGroundImage()
        end
        if Panel_star ~= nil then
            Panel_star:removeAllChildren(true)
            Panel_star:removeBackGroundImage()
        end
        if Panel_props_right_icon ~= nil then
            Panel_props_right_icon:removeAllChildren(true)
            Panel_props_right_icon:removeBackGroundImage()
        end
        if Panel_props_left_icon ~= nil then
            Panel_props_left_icon:removeAllChildren(true)
            Panel_props_left_icon:removeBackGroundImage()
        end
        if Panel_num ~= nil then
            Panel_num:removeAllChildren(true)
            Panel_num:removeBackGroundImage()
        end
        if Panel_4 ~= nil then
            Panel_4:removeAllChildren(true)
            Panel_4:removeBackGroundImage()
        end
        if Text_1 ~= nil then
            Text_1:setString("")
        end
    end
    local root = self.roots[1]
    local Panel_best_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_best_player_icon")
    Panel_best_player_icon:removeAllChildren(true)
    local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
    end
end

function SmRankingMainInterface:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    state_machine.remove("sm_ranking_main_interface_change_page")
	state_machine.remove("sm_ranking_main_interface_open_rank")
end

