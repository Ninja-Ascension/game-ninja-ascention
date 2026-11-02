--------------------------------------------------------------------------------------------------------------
--  说明：阵容进攻
--------------------------------------------------------------------------------------------------------------
FormationDefendAttack = class("FormationDefendAttackClass", Window)

--打开界面
local formation_defend_attack_open_terminal = {
    _name = "formation_defend_attack_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FormationDefendAttackClass") == nil then
            fwin:open(FormationDefendAttack:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local formation_defend_attack_close_terminal = {
    _name = "formation_defend_attack_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationDefendAttackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_defend_attack_open_terminal)
state_machine.add(formation_defend_attack_close_terminal)
state_machine.init()

function FormationDefendAttack:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    --(1: 战地争霸挑战    2：极限挑战进入战斗)
    self._form_type = 0
    self._choose_formation = {}
    self._choose_leaders = {}

    self._last_formation_info = nil

    self._arena_info = nil

    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")

    local function init_formation_defend_attack_terminal()
        local formation_defend_attack_show_terminal = {
            _name = "formation_defend_attack_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_attack_hide_terminal = {
            _name = "formation_defend_attack_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_attack_update_info_terminal = {
            _name = "formation_defend_attack_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_attack_save_terminal = {
            _name = "formation_defend_attack_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._form_type == 1 then
                    local isHaveSetFormation = false
                    local formation_tabs = zstring.split(_ED.arena_info.arena_formation, "|")
                    for k, v in pairs(formation_tabs) do
                        local info_tabs = zstring.split(v, ",")
                        if tonumber(info_tabs[1]) > 0 then
                            isHaveSetFormation = true
                            break
                        end
                    end
                    if isHaveSetFormation == false then
                        TipDlg.drawTextDailog(formation_type_string[14])
                        return
                    end

                    local old_cell = instance._arena_info
                    local old_rand = _ED.arena_info.rank
                    _ED.arena_last_rank = tonumber(_ED.arena_info.rank)
                    local function requestArenaFightDatasCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            fwin:addService({
                                callback = function ( params )
                                    state_machine.unlock("adventure_mine_request_battle_field_init")
                                end,
                                delay = 0.3,
                                params = nil
                            })
                            if tonumber(_ED.arena_info.rank) < tonumber(old_rand) then
                                state_machine.excute("arena_dearon_tab_rank_change_update", 0, old_cell)
                            end

                            _ED.init_environment_fight_complete = true
                            
                            state_machine.excute("formation_window_close", 0, 0)
                            state_machine.excute("fight_window_open", 0, 0)
                        else
                            state_machine.unlock("adventure_mine_request_battle_field_init")
                        end
                        state_machine.excute("arena_dearon_tab_update", 0, 0)
                        state_machine.excute("arena_reward_integral_tab_update_draw", 0, "")
                    end
                    
                    local scene_npc_tab = dms.string(dms["arena_config"],11,arena_config.param)
                    scene_npc_tab = zstring.split(scene_npc_tab,",")
                    local scene_id = scene_npc_tab[1]
                    local npc_id = scene_npc_tab[2]
                    _ED._current_scene_id = scene_id
                    _ED._scene_npc_id = npc_id
                    _ED._battle_init_type = 11
                    state_machine.excute("adventure_mine_request_battle_field_init", 0, {_ED._battle_init_type, _ED._current_scene_id, _ED._scene_npc_id, 0, 
                        instance._arena_info.user_id.."\r\n"..instance._arena_info.user_rank, 0, 0, requestArenaFightDatasCallback})
                elseif instance._form_type == 2 then
                    local fight_type = battle_enum._fight_type._fight_type_202
                    local scene_id = 1
                    local npc_id = 1
                    local difficulty = _ED._npc_difficulty_index
                    state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, difficulty})
                end
                state_machine.excute("formation_defend_attack_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local formation_defend_attack_add_arena_formation_info_terminal = {
            _name = "formation_defend_attack_add_arena_formation_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addArenaFormationInfo(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_attack_add_legion_formation_info_terminal = {
            _name = "formation_defend_attack_add_legion_formation_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addLegionFormationInfo(params[1], params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_defend_attack_show_terminal)
        state_machine.add(formation_defend_attack_hide_terminal)
        state_machine.add(formation_defend_attack_update_info_terminal)
        state_machine.add(formation_defend_attack_save_terminal)
        state_machine.add(formation_defend_attack_add_arena_formation_info_terminal)
        state_machine.add(formation_defend_attack_add_legion_formation_info_terminal)
        state_machine.init()
    end
    
    init_formation_defend_attack_terminal()
end

-- 刷新增益状态
function FormationDefendAttack:updateFactor()
    local root = self.roots[1]
    local fatcor_state = {0, 0, 0, 0, 0, 0}
    for k, v in pairs(_ED.factor_info) do 
        local build_buff_id = tonumber(v.build_buff_id)
        if build_buff_id == 7 then          -- 减伤
            fatcor_state[1] = 1
        elseif build_buff_id == 6 then      -- 加伤
            fatcor_state[2] = 1
        elseif build_buff_id == 8 then      -- 行军速度
            fatcor_state[3] = 1
        end
    end

    for i = 1, 3 do
        local Image_form_gain_icon_0 = ccui.Helper:seekWidgetByName(root,"Image_form_gain_icon_0_"..i)
        local Image_form_gain_icon = ccui.Helper:seekWidgetByName(root,"Image_form_gain_icon_"..i)
        if fatcor_state[i] > 0 then         -- 有增益
            Image_form_gain_icon_0:setVisible(false)
            Image_form_gain_icon:setVisible(true)
        else
            Image_form_gain_icon_0:setVisible(true)
            Image_form_gain_icon:setVisible(false)
        end
    end
end

function FormationDefendAttack:updateOtherInfo( ... )
    local root = self.roots[1]
    local Text_troops_t = ccui.Helper:seekWidgetByName(root, "Text_troops_t")
    local Text_troops_fight_t = ccui.Helper:seekWidgetByName(root, "Text_troops_fight_t")
    local Text_troops_load_t = ccui.Helper:seekWidgetByName(root, "Text_troops_load_t")

    Text_troops_t:setString(string.format(formation_type_string[3], tonumber(_ED.user_info.soldier)))

    -- 更新战斗力，载重
    local all_fight_number = 0
    local all_load_number = 0
    if self._choose_formation ~= nil then
        for k, info in pairs(self._choose_formation) do
            if info.ship ~= nil then
                all_fight_number = all_fight_number + getShipFightNumber(info.ship, info.choose_count, self._choose_leaders[k].ship)
                all_load_number = all_load_number + tonumber(info.ship.attack_speed) * info.choose_count
            end
        end
    end
    Text_troops_fight_t:setString(string.format(formation_type_string[4], exChangeNumToString(math.ceil(all_fight_number))))
    Text_troops_load_t:setString(string.format(formation_type_string[5], exChangeNumToString(all_load_number)))
end

function FormationDefendAttack:updateDraw()
    local root = self.roots[1]
    local Text_troops_automatic = ccui.Helper:seekWidgetByName(root, "Text_troops_automatic")
    local Text_troops_automatic_state = ccui.Helper:seekWidgetByName(root, "Text_troops_automatic_state")
    Text_troops_automatic:setVisible(true)
    Text_troops_automatic_state:setVisible(false)

    if self._form_type == 1 then
        Text_troops_automatic:setString(formation_type_string[30])
    elseif self._form_type == 2 then
        Text_troops_automatic:setString(formation_type_string[29])
    end

    local formation_info = {}
    if self._form_type == 1 then
        local formation_tabs = zstring.split(_ED.arena_info.arena_formation, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = tonumber(info_tabs[1])
            info.count = tonumber(info_tabs[3])
            info.leader_id = tonumber(info_tabs[6])
            table.insert(formation_info, info)
        end
    elseif self._form_type == 2 then
        local formation_tabs = zstring.split(_ED.user_extreme_info.formation_info, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = tonumber(info_tabs[1])
            info.count = tonumber(info_tabs[3])
            info.leader_id = tonumber(info_tabs[6])
            table.insert(formation_info, info)
        end
    end
    self._last_formation_info = formation_info

    self:updateFormation(formation_info)
    self:updateFactor()
end

function FormationDefendAttack:updateFormation(formation_info, params)
    local root = self.roots[1]

    local max_count = 6
    local formation_index_tab = {1, 3, 5, 2, 4, 6}
    if self._form_type == 2 then
        local info = _ED.user_extreme_info.challge_info[self._limit_type]
        local vs_info = zstring.split(info.vs_info, ",")
        max_count = tonumber(vs_info[2])
    end

    for i=1,6 do
        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
        Panel_formation_tank:removeAllChildren(true)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
        Panel_formation_leader:removeAllChildren(true)

        local formation_index = formation_index_tab[i]
        if formation_index <= max_count then
            local ship = nil
            local choose_count = 0
            local ship_id = 0
            local leader = nil
            if formation_info ~= nil and formation_info[i] ~= nil then
                ship_id = formation_info[i].ship_id
                local leader_id = formation_info[i].leader_id
                if zstring.tonumber(ship_id) > 0 then
                    ship = _ED.user_ship[""..ship_id]
                    choose_count = formation_info[i].count
                    if zstring.tonumber(leader_id) > 0 then
                        leader = _ED.user_ship[""..leader_id]
                    end
                end
            end

            self._choose_formation[""..i] = {ship = ship, choose_count = choose_count}
            self._choose_leaders[""..i] = {ship = leader}

            local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, choose_count,1, true})
            Panel_formation_tank:addChild(cell)

            local cell1 = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, leader, 1, 2})
            Panel_formation_leader:addChild(cell1)
        end
    end

    self:updateOtherInfo()
end

function FormationDefendAttack:addArenaFormationInfo( info )
    local root = self.roots[1]
    self._arena_info = info
    local shipData = zstring.split(info.ship_moulds, "|")
    local ship_number = 0
    for i = 1, #shipData do
        local infos = zstring.split(shipData[i], ",")
        if tonumber(infos[3]) > 0 then
            ship_number = ship_number + tonumber(infos[3])
        end
    end
    
    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    Panel_pve_attack_box:setVisible(true)
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")
    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
    Text_fight_t:setString(tipString_legion_info[42])
    Text_fight_n:setString(info.user_fight)

    -- 获得奖励
    local get_reward = zstring.split(dms.string(dms["arena_config"], 14, arena_config.param), ",")
    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
    local rewardFontSize = Text_get_reward:getFontSize()

    local colors = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    local color_2 = cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3])
    local _richText_3 = ccui.RichText:create()
    _richText_3:ignoreContentAdaptWithSize(false) 
    
    local re3_1 = ccui.RichElementText:create(1, colors,255, arena_tip_text[15], config_res.font.font_name,rewardFontSize)
    _richText_3:pushBackElement(re3_1)  
    --临时的0
    local re3_2 = ccui.RichElementText:create(1, color_2,255, string.format(arena_tip_text[16],get_reward[1]), config_res.font.font_name,rewardFontSize)
    _richText_3:pushBackElement(re3_2)  
    _richText_3:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2+6))
    _richText_3:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
    Text_get_reward:addChild(_richText_3)
    
    local _richText_4 = ccui.RichText:create()
    _richText_4:ignoreContentAdaptWithSize(false) 
    local rank = tonumber(_ED.arena_info.rank) - tonumber(info.user_rank)
    if rank <= 0 then
        rank = 0
    end
    local re4_1 = ccui.RichElementText:create(1, colors,255, arena_tip_text[17], config_res.font.font_name,rewardFontSize)
    _richText_4:pushBackElement(re4_1)  
    local re4_2 = ccui.RichElementText:create(1, color_2,255, "+"..rank, config_res.font.font_name,rewardFontSize)
    _richText_4:pushBackElement(re4_2)  
    _richText_4:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2-16))
    _richText_4:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
    Text_get_reward:addChild(_richText_4)
    

    -- 有几率获得
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    Text_get_t:setString(arena_tip_text[18])
    local Text_get_n = ccui.Helper:seekWidgetByName(root,"Text_get_n")
    Text_get_n:removeAllChildren(true)
    local reward_info = zstring.split(dms.string(dms["arena_config"], 18, arena_config.param), ",")
    local scene_reward_id = tonumber(reward_info[1])
    local prop_info = zstring.split(dms.string(dms["scene_reward"], scene_reward_id, scene_reward.reward_items), "|")
    local info = zstring.split(prop_info[1], ",")
    local prop_id = tonumber(info[1])
    local prop_name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
    local quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)
    Text_get_n:setString(prop_name)
    Text_get_n:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_get_n:setPositionX(Text_get_t:getPositionX() + Text_get_t:getContentSize().width)
    Text_get_n:setPositionY(Text_get_t:getPositionY())
    Text_get_n:setContentSize(cc.size(Text_get_n:getContentSize().width,Text_get_t:getContentSize().height))

    for i=1,6 do
        local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
        local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
        Panel_enemy_tank:removeAllChildren(true)
        Panel_enemy_leader:removeAllChildren(true)
        
        local infos = zstring.split(shipData[i], ",")
        local ship = {}
        ship.ship_template_id = infos[2]
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, infos[3],3})
        Panel_enemy_tank:addChild(cell)

        local leader_head = nil
        if tonumber(infos[6]) > 0 then
            leader_head = {}
            leader_head.captain_name = dms.string(dms["ship_mould"], tonumber(infos[7]), ship_mould.captain_name)
            leader_head.ship_type = dms.string(dms["ship_mould"], tonumber(infos[7]), ship_mould.ship_type)
            leader_head.ship_template_id = infos[7]
        end
        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,leader_head,1, 2})
        Panel_enemy_leader:addChild(cell)
    end
end

function FormationDefendAttack:addLegionFormationInfo( info, nType )
    local root = self.roots[1]
    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    Panel_pve_attack_box:setVisible(true)

    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")

    local play_formation_info = nil
    if nType <= 0 then
        play_formation_info = zstring.split(info.play_formation_info, "|")
    else
        play_formation_info = zstring.split(info, "|")
    end
    for i=1,6 do
        local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
        local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
        Panel_enemy_tank:removeAllChildren(true)
        Panel_enemy_leader:removeAllChildren(true)

        local choose_count = 0
        local info_ship = nil
        local leader = nil
        if play_formation_info[i] ~= nil then
            local formation_info = zstring.split(play_formation_info[i], ",")
            choose_count = tonumber(formation_info[3])
            info_ship = {ship_template_id = formation_info[2]}
            leader = {ship_template_id = formation_info[7]}
        end
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, info_ship, choose_count, 3})
        Panel_enemy_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, leader, 2, 2})
        Panel_enemy_leader:addChild(cell)
    end

    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    Text_get_t:setVisible(false)
    if nType <= 0 then
        Text_fight_t:setString(tipString_legion_info[42])
        Text_fight_n:setString(exChangeNumToString(info.formation_capactity))
    else
        Text_fight_t:setString("")
        Text_fight_n:setString("")
    end
end

--初始化
function FormationDefendAttack:onInit()
    local csbItem = csb.createNode(string.format(config_csb.formation.formation_tab, "5"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "formation_defend_attack_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "formation_defend_attack_close", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_save"), nil, 
    {
        terminal_name = "formation_defend_attack_save", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:updateDraw()
end

function FormationDefendAttack:onEnterTransitionFinish()

end

function FormationDefendAttack:init(param)
    self._form_type = param[1]
    self._limit_type = param[2]
    self:onInit()
    return self
end

function FormationDefendAttack:onExit()
    state_machine.remove("formation_defend_attack_show")
    state_machine.remove("formation_defend_attack_hide")
    state_machine.remove("formation_defend_attack_update_info")
    state_machine.remove("formation_defend_attack_add_arena_formation_info")
    state_machine.remove("formation_defend_attack_add_legion_formation_info")
end
