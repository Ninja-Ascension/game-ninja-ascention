-----------------------------
--战力排行榜活动
-----------------------------
SmFullServiceRankings = class("SmFullServiceRankingsClass", Window)

--打开界面
local sm_full_service_rankings_open_terminal = {
	_name = "sm_full_service_rankings_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmFullServiceRankingsClass") == nil then
			fwin:open(SmFullServiceRankings:new():init(), fwin._background)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_full_service_rankings_close_terminal = {
	_name = "sm_full_service_rankings_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmFullServiceRankingsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_full_service_rankings_open_terminal)
state_machine.add(sm_full_service_rankings_close_terminal)
state_machine.init()

function SmFullServiceRankings:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._award = nil
    self._power_reward = nil
    self._ranking = nil
    self._monster = nil
    self._rank_rules= nil
    self._Text_time_1 = nil

    self._text_time = nil
    self._is_end = false
    self._tick_time = 0

    app.load("client.l_digital.activity.wonderful.SmRankActivityAward")
    app.load("client.l_digital.activity.wonderful.SmCombatPowerReward")
    app.load("client.l_digital.activity.wonderful.SmActivityRankingInformation")
    app.load("client.l_digital.activity.wonderful.SmMonsterIntroduction")
    app.load("client.l_digital.activity.wonderful.SmActivityRankRules")

    local function init_prop_warehouse_terminal()
        local sm_full_service_rankings_change_page_terminal = {
            _name = "sm_full_service_rankings_change_page",
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
        local sm_full_service_rankings_open_rank_terminal = {
            _name = "sm_full_service_rankings_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- Fury 4-oct (:96): la pagina se lee AL PULSAR; si la ventana se cerro antes
                -- de la respuesta, el boton ya no tiene _datas y no hay pagina que cambiar.
                local page = tonumber(params._datas._page)
                local function responseBattleFieldRankCallback(response)
                    if fwin:find("SmFullServiceRankingsClass") == nil then
                        return
                    end
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        instance:changeSelectPage(page)
                    end
                end
                protocol_command.search_order_list.param_list = "2"
                NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseBattleFieldRankCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开排行榜
        local sm_full_service_rankings_open_new_rule_terminal = {
            _name = "sm_full_service_rankings_open_new_rule",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmActivityRankRulesTwo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("sm_activity_rank_rules_two_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_full_service_rankings_change_page_terminal)
        state_machine.add(sm_full_service_rankings_open_rank_terminal)
        state_machine.add(sm_full_service_rankings_open_new_rule_terminal)
        state_machine.init()
    end
    init_prop_warehouse_terminal()
end


function SmFullServiceRankings:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then 
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
        if self._tick_time <= 0 then
            self._tick_time = 0
            if self._is_end == false then
                self:onUpdateDraw()
            else
            end
        end
    end
end

function SmFullServiceRankings:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_page = ccui.Helper:seekWidgetByName(root, "Panel_page")
    local Button_tab_1 = ccui.Helper:seekWidgetByName(root, "Button_tab_1")
    local Button_tab_2 = ccui.Helper:seekWidgetByName(root, "Button_tab_2")
    local Button_tab_3 = ccui.Helper:seekWidgetByName(root, "Button_tab_3")
    local Button_tab_4 = ccui.Helper:seekWidgetByName(root, "Button_tab_4")
    local Button_tab_5 = ccui.Helper:seekWidgetByName(root, "Button_tab_5")
    if page == self._current_page then
        if page == 1 then
            Button_tab_1:setHighlighted(true)
        elseif page == 2 then
            Button_tab_2:setHighlighted(true)
        elseif page == 3 then
            Button_tab_3:setHighlighted(true)
        elseif page == 4 then
            Button_tab_4:setHighlighted(true)
        elseif page == 5 then    
            Button_tab_5:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_tab_1:setHighlighted(false)
    Button_tab_2:setHighlighted(false)
    Button_tab_3:setHighlighted(false)
    Button_tab_4:setHighlighted(false)
    Button_tab_5:setHighlighted(false)
    state_machine.excute("sm_rank_activity_award_hide", 0, nil)
    state_machine.excute("sm_combat_power_reward_hide", 0, nil)
    state_machine.excute("sm_activity_ranking_information_hide", 0, nil)
    state_machine.excute("sm_monster_introduction_hide", 0, nil)
    state_machine.excute("sm_activity_rank_rules_hide", 0, nil)
    
    if page == 1 then
        Button_tab_1:setHighlighted(true)
        if self._award == nil then
            self._award = state_machine.excute("sm_rank_activity_award_window_open", 0, {Panel_page})
        else
            state_machine.excute("sm_rank_activity_award_show", 0, nil)
        end
	elseif page == 2 then
		Button_tab_2:setHighlighted(true)
		if self._power_reward == nil then
            self._power_reward = state_machine.excute("sm_combat_power_reward_window_open", 0, {Panel_page})
        else
            state_machine.excute("sm_combat_power_reward_show", 0, nil)
        end
	elseif page == 3 then
		Button_tab_3:setHighlighted(true)
		if self._ranking == nil then
            self._ranking = state_machine.excute("sm_activity_ranking_information_window_open", 0, {Panel_page})
        else
            state_machine.excute("sm_activity_ranking_information_show", 0, nil)
        end
    elseif page == 4 then
		Button_tab_4:setHighlighted(true)
        if self._monster == nil then
            self._monster = state_machine.excute("sm_monster_introduction_window_open", 0, {Panel_page})
        else
            state_machine.excute("sm_monster_introduction_show", 0, nil)
        end
    else
        Button_tab_5:setHighlighted(true)
        if self._rank_rules == nil then
            self._rank_rules = state_machine.excute("sm_activity_rank_rules_window_open", 0, {Panel_page})
        else
            state_machine.excute("sm_activity_rank_rules_show", 0, nil)
        end   
	end
end

function SmFullServiceRankings:init()
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmFullServiceRankings:onUpdateDraw()
    local root = self.roots[1]
    Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")
    
    local Text_my_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_my_fighting_n")
    Text_my_fighting_n:setString(_ED.charts.my_fight)

    local activity = _ED.active_activity[86]
    local activity_params = _ED.active_activity[86].activity_params
    local paramsdatas = zstring.split(activity_params,"!")

    self._text_time = nil
    self._is_end = false
    local end_time = tonumber(paramsdatas[3])
    if (os.time() + _ED.time_add_or_sub) > end_time / 1000 then         -- 活动结束
        self._tick_time = tonumber(activity.end_time) / 1000 - (os.time() + _ED.time_add_or_sub)
        self._is_end = true
    else
        self._tick_time = end_time / 1000 - (os.time() + _ED.time_add_or_sub)
        self._is_end = false
    end
    if self._is_end == false then
        Text_time_1:setString(getRedAlertTimeActivityFormat(self._tick_time))
        self._text_time = Text_time_1
    else
        Text_time_1:setString(_string_piece_info[305])
    end

    local strs = string.format(_new_interface_text[90],zstring.tonumber(paramsdatas[2]))
    local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
    Text_tip:setString(strs)

    --是否上榜
    local Text_my_ranking = ccui.Helper:seekWidgetByName(root, "Text_my_ranking")
    local index = 1
    local number = 0
    for i, v in pairs(_ED.charts.force) do
        if index <= 10 then
            if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                number = index
                break
            end
            index = index + 1
        end
    end
    if number == 0 then
        Text_my_ranking:setString(_string_piece_info[34])
    else
        Text_my_ranking:setString(number)
    end
end

function SmFullServiceRankings:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_fighting_up.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_full_service_rankings_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --活动奖励
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_1"), nil, 
    {
        terminal_name = "sm_full_service_rankings_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	
    --战力奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_2"), nil, 
    {
        terminal_name = "sm_full_service_rankings_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    --活动排名
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_3"), nil, 
    {
        terminal_name = "sm_full_service_rankings_open_rank", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    --天使兽介绍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_4"), nil, 
    {
        terminal_name = "sm_full_service_rankings_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        --活动规则
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_5"), nil, 
        {
            terminal_name = "sm_full_service_rankings_open_new_rule", 
            terminal_state = 0, 
        }, nil, 1)
    else
        --活动规则
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_5"), nil, 
        {
            terminal_name = "sm_full_service_rankings_change_page", 
            terminal_state = 0, 
            _page = 5,
        }, nil, 1)
    end

    self:changeSelectPage(1)

    self:onUpdateDraw()
    if __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_digital then 
        self:updateDrawShipTwo()
    else
        self:updateDrawShip()
    end
end

function SmFullServiceRankings:updateDrawShipTwo()
    -- 模型的显示由config表控制
    local ship_mould_id = tonumber(tipStringInfo_fightRank_activity_ship_mould_id[1])

    local ship_mould_info = dms.atos(dms["ship_mould"], ship_mould_id)
    local initial_state = dms.atoi(ship_mould_info, ship_mould.captain_name)
    local ship_type = dms.atoi(ship_mould_info, ship_mould.camp_preference)
    local ship_initial_star = dms.atoi(ship_mould_info, ship_mould.ship_star)
    local ship_evo_mould_ids = zstring.split(dms.atos(ship_mould_info, 72), ",")

    local ship_evo_mould_id = ship_evo_mould_ids[initial_state]
    local ship_evo_mould_info = dms.atos(dms["ship_evo_mould"], tonumber(ship_evo_mould_id))
    local name_id = dms.atoi(ship_evo_mould_info, ship_evo_mould.name_index)
    local spine_id = dms.atoi(ship_evo_mould_info, ship_evo_mould.form_id)

    local root = self.roots[1]
    local Panel_digimon_big_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_big_icon")
    if Panel_digimon_big_icon ~= nil then
        app.load("client.battle.fight.FightEnum")
        local shipSpine = sp.spine_sprite(Panel_digimon_big_icon, spine_id, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    end
end

function SmFullServiceRankings:updateDrawShip()
    local root = self.roots[1]
    -- 模型的显示由config表控制
    local ship_mould_id = tonumber(tipStringInfo_fightRank_activity_ship_mould_id[1])

    local ship_mould_info = dms.atos(dms["ship_mould"], ship_mould_id)
    local initial_state = dms.atoi(ship_mould_info, ship_mould.captain_name)
    local ship_type = dms.atoi(ship_mould_info, ship_mould.camp_preference)
    local ship_initial_star = dms.atoi(ship_mould_info, ship_mould.ship_star)
    local ship_evo_mould_ids = zstring.split(dms.atos(ship_mould_info, 72), ",")

    local ship_evo_mould_id = ship_evo_mould_ids[initial_state]
    local ship_evo_mould_info = dms.atos(dms["ship_evo_mould"], tonumber(ship_evo_mould_id))
    local name_id = dms.atoi(ship_evo_mould_info, ship_evo_mould.name_index)
    local spine_id = dms.atoi(ship_evo_mould_info, ship_evo_mould.form_id)

    -- 名字
    local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name")
    local name_msg = getMessageForWordMouldID(name_id)
    Text_digimon_name:setString(name_msg)

    -- 职业
    local Panel_20 = ccui.Helper:seekWidgetByName(root, "Panel_20")
    local Sprite_name_bar = Panel_20:getChildByName("Sprite_name_bar") 
    if ship_type >= 1 and ship_type <= 3 then
        Sprite_name_bar:setVisible(true)
        Sprite_name_bar:setTexture(string.format("images/ui/icon/sm_type_bar_%s.png", ship_type))
    else
        Sprite_name_bar:setVisible(false)
    end

    -- 星级
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
    local Image_13_0 = ccui.Helper:seekWidgetByName(root, "Image_13_0")
    local Image_13_1 = ccui.Helper:seekWidgetByName(root, "Image_13_1")
    local Image_13_1_0 = ccui.Helper:seekWidgetByName(root, "Image_13_1_0")
    local pics = {Image_13 , Image_13_0 , Image_13_1 , Image_13_1_0}
    for i,pic in ipairs(pics) do
        pic:setVisible(false)
        if i <= ship_initial_star then
            pic:setVisible(true)
        end
    end

    -- 形象
    local Panel_digimon_big_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_big_icon")
    if Panel_digimon_big_icon ~= nil then
        app.load("client.battle.fight.FightEnum")
        local shipSpine = sp.spine_sprite(Panel_digimon_big_icon, spine_id, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    end
end

function SmFullServiceRankings:onEnterTransitionFinish()
    
end


function SmFullServiceRankings:onExit()
	-- state_machine.remove("prop_warehouse_change_page")
end

