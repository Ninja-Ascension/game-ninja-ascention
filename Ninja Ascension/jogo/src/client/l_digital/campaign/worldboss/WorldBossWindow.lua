-- ----------------------------------------------------------------------------------------------------
-- 说明：世界boss主界面
-------------------------------------------------------------------------------------------------------
WorldBossWindow = class("WorldBossWindowClass", Window)

local world_boss_window_open_terminal = {
    _name = "world_boss_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        -- Fury (sistema D): al salir de un combate del jefe INTERSERVIDOR se vuelve a
        -- su ventana (FuryCrossBossWindow.lua), no a la del Juego de Cell.
        if _ED.fury_cross_boss_return then
            _ED.fury_cross_boss_return = nil
            app.load("client.l_digital.campaign.worldboss.FuryCrossBossWindow")
            state_machine.excute("fury_cross_boss_open", 0, "")
            return true
        end
        local function callback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("WorldBossWindowClass") == nil then
                    fwin:open(WorldBossWindow:new(), fwin._view)
                end
            end
        end
        NetworkManager:register(protocol_command.pokemon_world_boss_init.code, nil, nil, nil, nil, callback, false, nil)
        state_machine.unlock("explore_window_open_fun_window")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local world_boss_window_close_terminal = {
    _name = "world_boss_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:cleanView(fwin._view)
        if fwin:find("MenuClass") == nil then
            fwin:open(Menu:new(), fwin._taskbar)
        end
        if fwin:find("HomeClass") == nil then
            state_machine.excute("menu_manager", 0, 
                {
                    _datas = {
                        terminal_name = "menu_manager",     
                        next_terminal_name = "menu_show_home_page", 
                        current_button_name = "Button_home",
                        but_image = "Image_home",       
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                }
            )
        end                
        state_machine.excute("menu_back_home_page", 0, "")
        if fwin:find("ExploreWindowClass") == nil then
            state_machine.excute("explore_window_open", 0, "") 
        end
    	fwin:close(fwin:find("WorldBossWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_boss_window_open_terminal)
state_machine.add(world_boss_window_close_terminal)
state_machine.init()

function WorldBossWindow:ctor()
    self.super:ctor()
    self.roots = {}

    self:backupFormation()

    self.starting_point = 1
    self.end_point = 10
    self.ranktype = 1   --1为个人排行 
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.packs.hero.HeroFormationChoiceWear")
    app.load("client.l_digital.campaign.worldboss.WorldBossDailyTask")
    app.load("client.l_digital.campaign.worldboss.WorldBossRuleWindow")
    app.load("client.l_digital.cells.worldboss.world_boss_ranking_cell")

    local function init_world_boss_window_terminal()
        --进入战斗
        local world_boss_window_join_battle_terminal = {
            _name = "world_boss_window_join_battle",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("world_boss_window_join_battle")
                instance:fight()
                -- local function callback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         instance:fight()
                --     else
                --         state_machine.unlock("world_boss_window_join_battle")
                --     end
                -- end
                -- NetworkManager:register(protocol_command.world_boss_attack_start.code, nil, nil, nil, nil, callback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --重置冷却时间
        local world_boss_window_refresh_time_terminal = {
            _name = "world_boss_window_refresh_time",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                function showConfirmTip(instance,n)
                    if n == 0 then
                        state_machine.lock("world_boss_window_refresh_time")
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.unlock("world_boss_window_refresh_time")
                            else
                                state_machine.unlock("world_boss_window_refresh_time")
                            end
                        end
                        NetworkManager:register(protocol_command.world_boss_ref_cd.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                local needCosts = zstring.split(dms.string(dms["play_config"], 155, pirates_config.param), ",")
                local cost = 0
                if tonumber(_ED.world_boss_my_info.refAttackDateTime) + 1 > #needCosts then
                    cost = needCosts[#needCosts]
                else
                    cost = needCosts[tonumber(_ED.world_boss_my_info.refAttackDateTime) + 1]
                end

                tip:init(instance, showConfirmTip, string.format(tipStringInfo_world_boss[13], tonumber(cost)))
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开、关闭阵容
        local world_boss_window_open_formation_terminal = {
            _name = "world_boss_window_open_formation",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_boss_line = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_boss_line")
                local isShow = Panel_boss_line:isVisible()
                Panel_boss_line:setVisible(not isShow)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更换一个英雄
        local world_boss_open_join_formation_window_terminal = {
            _name = "world_boss_open_join_formation_window",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           
                state_machine.excute("hero_formation_choice_wear_window_open", 0, {params._datas.cell_index, 1, -1, nil, "world_boss_join_formation", params._datas.cell_index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更换一个英雄返回
        local world_boss_join_formation_terminal = {
            _name = "world_boss_join_formation",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:joinFormtion(params)
               
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --调整阵容
        local world_boss_formation_change_terminal = {
            _name = "world_boss_formation_change",
            _init = function (terminal) 
                app.load("client.formation.FormationChange") 
                app.load("client.home.HomeHero") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("formation_change_window_open", 0, {nil, "world_boss_formation_change_request", nil})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --调整阵容回调
        local world_boss_formation_change_request_terminal = {
            _name = "world_boss_formation_change_request",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:formationPosChange(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        --一键布阵
        local world_boss_oen_key_formation_window_terminal = {
            _name = "world_boss_oen_key_formation_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:oneKeyFormationChange(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --每日奖励
        local world_boss_open_daily_task_terminal = {
            _name = "world_boss_open_daily_task",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("world_boss_daily_task_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --每日奖励红点
        local world_boss_open_daily_task_redot_terminal = {
            _name = "world_boss_open_daily_task_redot",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:worldBossDailyTaskRedot()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换排行榜
        local world_boss_rebel_boss_check_enter_terminal = {
            _name = "world_boss_rebel_boss_check_enter",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        instance:onUpdateRankDraw(instance.ranktype)
                    end
                end
                instance.ranktype = params._datas.ranktype
                instance.starting_point = 1
                instance.end_point = 10
                _ED.world_boss_personal_rank = nil
                _ED.world_boss_union_rank = nil
                protocol_command.world_boss_get_order.param_list = instance.ranktype.."\r\n"..instance.starting_point.."\r\n"..instance.end_point
                NetworkManager:register(protocol_command.world_boss_get_order.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新排行榜
       local world_boss_rebel_boss_update_rank_terminal = {
            _name = "world_boss_rebel_boss_update_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance.starting_point = instance.starting_point+10
                            instance.end_point = instance.end_point+10
                            instance:addnewlistCell(instance.ranktype)
                        end
                    end
                end
                
                if  (tonumber(_ED.world_boss_union_ranking_size) >= 10 and instance.ranktype == 2) or (tonumber(_ED.world_boss_personal_size) >= 10 and instance.ranktype == 1)  then
                    protocol_command.world_boss_get_order.param_list = instance.ranktype.."\r\n"..(instance.starting_point+10).."\r\n"..(instance.end_point+10)
                    NetworkManager:register(protocol_command.world_boss_get_order.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

       --刷新排行榜
        local world_boss_status_update_terminal = {
            _name = "world_boss_status_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.onUpdateDraw ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_boss_window_join_battle_terminal)
        state_machine.add(world_boss_window_open_formation_terminal)
        state_machine.add(world_boss_open_join_formation_window_terminal)
        state_machine.add(world_boss_join_formation_terminal)
        state_machine.add(world_boss_formation_change_terminal)
        state_machine.add(world_boss_formation_change_request_terminal)
        state_machine.add(world_boss_oen_key_formation_window_terminal)
        state_machine.add(world_boss_window_refresh_time_terminal)
        state_machine.add(world_boss_open_daily_task_terminal)
        state_machine.add(world_boss_open_daily_task_redot_terminal)
        state_machine.add(world_boss_rebel_boss_check_enter_terminal)
        state_machine.add(world_boss_rebel_boss_update_rank_terminal)
        state_machine.add(world_boss_status_update_terminal)
        state_machine.init()
    end
    
    init_world_boss_window_terminal()
end

function WorldBossWindow:onUpdate(dt)
    self:updateAttackTime(os.time() + _ED.time_add_or_sub)
    self:updateBossTime(os.time() + _ED.time_add_or_sub)
end

function WorldBossWindow:updateAttackTime(times)
    local root = self.roots[1]
    if root == nil or not self.Text_boos_challenge_cool_time or not _ED.world_boss_my_info or not _ED.world_boss_my_info.nextAttackDate then
        return
    end
    local Button_boss_reset_cooling = ccui.Helper:seekWidgetByName(root, "Button_boss_reset_cooling")
    local Button_boss_challenge = ccui.Helper:seekWidgetByName(root, "Button_boss_challenge")
    local Image_119 = ccui.Helper:seekWidgetByName(root, "Image_119")
    local Text_boos_challenge_cool = ccui.Helper:seekWidgetByName(root, "Text_boos_challenge_cool")
    local surplus_time = (tonumber(_ED.world_boss_my_info.nextAttackDate) - ((times))*1000)
    if surplus_time > 0 and tonumber(_ED.world_boss_open_info.status) == 1 then
        self.Text_boos_challenge_cool_time:setString(getRedAlertTimeActivityFormat(surplus_time / 1000))
        Button_boss_reset_cooling:setVisible(true)
        self.Text_boos_challenge_cool_time:setVisible(true)
        Button_boss_challenge:setVisible(false)
        Image_119:setVisible(true)
        Text_boos_challenge_cool:setVisible(true)
    else
        self.Text_boos_challenge_cool_time:setString("00:00:00")
        Button_boss_reset_cooling:setVisible(false)
        Button_boss_challenge:setVisible(true)
        self.Text_boos_challenge_cool_time:setVisible(false)
        Image_119:setVisible(false)
        Text_boos_challenge_cool:setVisible(false)
    end
end

function WorldBossWindow:updateBossTime(times)
--    print("times=",times)
    local root = self.roots[1]
    if root == nil or not self.Text_boss_act_time or not _ED.world_boss_open_info or not _ED.world_boss_open_info.time then
        return
    end
    local surplus_time = (tonumber(_ED.world_boss_open_info.time) - ((times))*1000)
--    print("tonumber(_ED.world_boss_open_info.time) =",tonumber(_ED.world_boss_open_info.time) )
--    print("surplus_time=",surplus_time)
    if surplus_time > 0 and tonumber(_ED.world_boss_open_info.status) ~= 2 then
        self.Text_boss_act_time:setString(getRedAlertTimeActivityFormat(surplus_time / 1000))
    else
        self.Text_boss_act_time:setString(tipStringInfo_world_boss[1])
    end
end

--boss信息
function WorldBossWindow:drawWorldBossInfo()
    local root = self.roots[1]
    local Panel_boss_head = ccui.Helper:seekWidgetByName(root, "Panel_boss_head")
    local Text_boss_name = ccui.Helper:seekWidgetByName(root, "Text_boss_name")
    local Text_boss_blood = ccui.Helper:seekWidgetByName(root, "Text_boss_blood")
    local LoadingBar_npc_hp = ccui.Helper:seekWidgetByName(root, "LoadingBar_npc_hp")
    local Button_boss_reset_cooling = ccui.Helper:seekWidgetByName(root, "Button_boss_reset_cooling")
    self.Text_boos_challenge_cool_time = ccui.Helper:seekWidgetByName(root, "Text_boos_challenge_cool_time")
    self.Text_boss_act_time = ccui.Helper:seekWidgetByName(root, "Text_boss_act_time")
    local Text_boss_act_time_t = ccui.Helper:seekWidgetByName(root, "Text_boss_act_time_t")
    local Text_cooling_gem_n = ccui.Helper:seekWidgetByName(root, "Text_cooling_gem_n")
    Panel_boss_head:removeAllChildren(true)
    Text_boss_name:setString("")

    local cur_scene_id = dms.int(dms["world_boss"], _ED.world_boss_info.bossId, 3)
    local cur_npc_id = dms.int(dms["pve_scene"], cur_scene_id, 13)
    local environment_formation1 = dms.int(dms["npc"], zstring.tonumber(cur_npc_id), npc.environment_formation1)
    local temp_bust_index = nil
    local maxHp = 1
    for i=1, 6 do
        local environment_ship_id = dms.int(dms["environment_formation"], zstring.tonumber(environment_formation1), environment_formation.seat_one+i-1)
        if environment_ship_id ~= 0 then
            maxHp = dms.int(dms["environment_ship"], environment_ship_id, environment_ship.power)
            temp_bust_index = dms.int(dms["environment_ship"], environment_ship_id, environment_ship.pic_index)
            break
        end
    end
    if temp_bust_index then
        app.load("client.battle.fight.FightEnum")
        local shipSpine = sp.spine_sprite(Panel_boss_head, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        local bossScale = dms.searchs(dms["role_high"], pokemon_high.hero_fight_state_id, tonumber(temp_bust_index))
        Panel_boss_head:setScale(tonumber(bossScale[1][7]))
    end

    local battleNpcName = dms.string(dms["npc"], zstring.tonumber(cur_npc_id), npc.npc_name)
    local boss_level = dms.int(dms["world_boss"], _ED.world_boss_info.bossId, 2)
    local name_info = ""
    local name_data = zstring.split(battleNpcName, "|")
    for i, v in pairs(name_data) do
        local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
        name_info = name_info..word_info[3]
    end
    battleNpcName = name_info
    Text_boss_name:setString("Lv." .. boss_level .. " " .. battleNpcName)

    Text_boss_blood:setString(string.format("%0.2f%%", tonumber(_ED.world_boss_info.leftHp)/tonumber(_ED.world_boss_info.maxHp)*100) )
    LoadingBar_npc_hp:setPercent(tonumber(_ED.world_boss_info.leftHp)/tonumber(_ED.world_boss_info.maxHp)*100)

    local Image_explor_boss_hurt = ccui.Helper:seekWidgetByName(self.roots[1], "Image_explor_boss_hurt")
    Image_explor_boss_hurt:setVisible(tonumber(_ED.world_boss_info.leftHp) <= 0)

    local needCosts = zstring.split(dms.string(dms["play_config"], 155, pirates_config.param), ",")
    local cost = 0
    if tonumber(_ED.world_boss_my_info.refAttackDateTime) + 1 > #needCosts then
        cost = needCosts[#needCosts]
    else
        cost = needCosts[tonumber(_ED.world_boss_my_info.refAttackDateTime) + 1]
    end
    Text_cooling_gem_n:setString(cost)

    local str = tonumber(_ED.world_boss_open_info.status) == 0 and tipStringInfo_world_boss[11] or tipStringInfo_world_boss[12]
    Text_boss_act_time_t:setString(str)
end

function WorldBossWindow:onUpdateDraw()
    local root = self.roots[1]
    local Text_boss_last_hurt_name = ccui.Helper:seekWidgetByName(root, "Text_boss_last_hurt_name")
    local Text_boss_lucky_name = ccui.Helper:seekWidgetByName(root, "Text_boss_lucky_name")
    local Panel_top_role_head = ccui.Helper:seekWidgetByName(root, "Panel_top_role_head")
    local Text_boss_top_name = ccui.Helper:seekWidgetByName(root, "Text_boss_top_name")
    local Image_44 = ccui.Helper:seekWidgetByName(root, "Image_44")
    local ListView_rank_list = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_rank_list")
    ListView_rank_list:removeAllItems()
    Panel_top_role_head:removeAllChildren(true)
    Text_boss_last_hurt_name:setString(tipStringInfo_world_boss[7])
    Text_boss_lucky_name:setString(tipStringInfo_world_boss[7])
    Text_boss_top_name:setString(tipStringInfo_world_boss[7])
    if table.nums(_ED.world_boss_info.surprisedRewardUserInfo) > 0 then
        Text_boss_lucky_name:setString("Lv" .._ED.world_boss_info.surprisedRewardUserInfo[1].level.. "." .. _ED.world_boss_info.surprisedRewardUserInfo[1].nickNmae)
    end
    if table.nums(_ED.world_boss_info.lastAttackUser) > 0 then
        Text_boss_last_hurt_name:setString("Lv" .._ED.world_boss_info.lastAttackUser.level.. "." .. _ED.world_boss_info.lastAttackUser.nickNmae)
    end

    if _ED.world_boss_info.topUserInfo and table.nums(_ED.world_boss_info.topUserInfo) > 0 then
        local temp_bust_index = dms.int(dms["ship_evo_mould"], _ED.world_boss_info.topUserInfo.topShipEvo, ship_evo_mould.form_id)
        if temp_bust_index then
            app.load("client.battle.fight.FightEnum")
            local shipSpine = sp.spine_sprite(Panel_top_role_head, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        end
        Text_boss_top_name:setString(_ED.world_boss_info.topUserInfo.nickName)
        Image_44:setVisible(false)
    else
        Image_44:setVisible(true)
    end

    local world_boss_copy_formation_status_info = cc.UserDefault:getInstance():getStringForKey(getKey("world_boss_copy_formation_status_info"), "")
    local world_boss_copy_formation_info = cc.UserDefault:getInstance():getStringForKey(getKey("world_boss_copy_formation_info"), "")

    local  temp_ship = true

    if nil ~= world_boss_copy_formation_status_info or "" ~= world_boss_copy_formation_status_info or nil ~= world_boss_copy_formation_info or "" ~= world_boss_copy_formation_info then
        local temp_formation_status =  zstring.split(world_boss_copy_formation_status_info, ",")
        local temp_formation_info = zstring.split(world_boss_copy_formation_info, ",")
        
        for k,v in pairs(temp_formation_status) do
            if not _ED.user_ship[v] and tonumber(v) ~= 0  then
                temp_ship = false
            end
        end
    end
    
    if nil == world_boss_copy_formation_status_info or "" == world_boss_copy_formation_status_info or nil == world_boss_copy_formation_info or "" == world_boss_copy_formation_info or (not temp_ship) then
        cc.UserDefault:getInstance():setStringForKey(getKey("world_boss_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
        cc.UserDefault:getInstance():setStringForKey(getKey("world_boss_copy_formation_info"), zstring.concat(_ED.formetion, ","))
    else
        _ED.user_formetion_status = zstring.split(world_boss_copy_formation_status_info, ",")
        _ED.formetion = zstring.split(world_boss_copy_formation_info, ",")
    end

    --排行榜
    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
           state_machine.excute("world_boss_rebel_boss_update_rank", 0,nil)
        end
    end
    ListView_rank_list:addScrollViewEventListener(scrollViewEvent)

    self:drawFormationList()
    self:drawWorldBossInfo()
    self:onUpdateRankDraw(self.ranktype)
    self:worldBossDailyTaskRedot()
end

function WorldBossWindow:onUpdateRankDraw(rankingtype)     --更新2个小排行榜
    if (not _ED.world_boss_personal_rank and self.ranktype == 1 ) or (not _ED.world_boss_union_rank and self.ranktype == 2) then
        return
    end
    
    local Panel_top_rank_me = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_top_rank_me")
    local Text_boss_rank_player_rank_me = ccui.Helper:seekWidgetByName(self.roots[1], "Text_boss_rank_player_rank_me")
    local Text_boss_rank_player_name_me = ccui.Helper:seekWidgetByName(self.roots[1], "Text_boss_rank_player_name_me")
    local Text_boss_rank_player_hurt_me = ccui.Helper:seekWidgetByName(self.roots[1], "Text_boss_rank_player_hurt_me")
    
    Panel_top_rank_me:removeBackGroundImage()
    if tonumber(_ED.world_boss_personal_ranking_my) <=3  then
       Panel_top_rank_me:setBackGroundImage(string.format("images/ui/text/GHZ_res/gh_rank_%d.png", _ED.world_boss_personal_ranking_my))
    end
    if _ED.world_boss_personal_ranking_my_info then
        Text_boss_rank_player_rank_me:setString(_ED.world_boss_personal_ranking_my)
        Text_boss_rank_player_name_me:setString(_ED.world_boss_personal_ranking_my_info.nickName)
        Text_boss_rank_player_hurt_me:setString(_ED.world_boss_personal_ranking_my_info.score)
    else
        Text_boss_rank_player_rank_me:setString(tipStringInfo_world_boss[8])
        Text_boss_rank_player_name_me:setString(_ED.user_info.user_name)
        Text_boss_rank_player_hurt_me:setString(0)
    end

    local ListView_rank_list = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_rank_list")
    ListView_rank_list:removeAllItems()
    local Button_integral_everyday = ccui.Helper:seekWidgetByName(self.roots[1], "Button_integral_everyday")
    local Button_integral_add = ccui.Helper:seekWidgetByName(self.roots[1], "Button_integral_add")

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then 
        local Text_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_add")
        local Text_add_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_add_0")
        local Text_everyday = ccui.Helper:seekWidgetByName(self.roots[1], "Text_everyday")
        local Text_everyday_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_everyday_0")
        if Text_add and Text_add_0 and Text_everyday and Text_everyday_0 then 
            Text_add:setVisible(false)
            Text_add_0:setVisible(false)
            Text_everyday:setVisible(false)
            Text_everyday_0:setVisible(false)
            if rankingtype == 1 then
                Text_everyday_0:setVisible(true)
                Text_add:setVisible(true)
            else
                Text_everyday:setVisible(true)
                Text_add_0:setVisible(true)
            end
        end
    end
    
    local Text_9_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_9_0")
    local info = {}
    if rankingtype == 1 then
        info = _ED.world_boss_personal_rank
        Button_integral_everyday:setHighlighted(true)
        Button_integral_add:setHighlighted(false)
        Text_9_0:setString(tipStringInfo_world_boss[2])
    else
        info = _ED.world_boss_union_rank
        Button_integral_everyday:setHighlighted(false)
        Button_integral_add:setHighlighted(true)
        Text_9_0:setString(tipStringInfo_world_boss[3])
    end
    for i, v in ipairs(info) do 
        local cell = state_machine.excute("world_boss_ranking_cell_create",0,{v,i,rankingtype})
        ListView_rank_list:addChild(cell)
    end
end

function WorldBossWindow:addnewlistCell(rankingtype)  --给排行榜添加
    local ListView_rank_list = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_rank_list")
    local info = {}
    if rankingtype == 1 then
        info = _ED.world_boss_personal_rank
    else
        info = _ED.world_boss_union_rank
    end
    for i= self.starting_point,self.end_point do   
        if info[i] ~= nil then
            local temp = {}
            temp = info[i]
            local cell = state_machine.excute("world_boss_ranking_cell_create",0,{temp,i,rankingtype})
            ListView_rank_list:addChild(cell)
        end
    end
    ListView_rank_list:requestRefreshView()
end

--布阵
function WorldBossWindow:drawFormationList()
    local root = self.roots[1]

    local nMaxCount = 6
        --画武将列表
    local ListView_gh_pve_line = ccui.Helper:seekWidgetByName(root, "ListView_em_line")
    ListView_gh_pve_line:removeAllItems()
    for i= 1, 6 do
        local cell = HeroIconListCell:createCell()
        local ship = _ED.user_ship["".._ED.user_formetion_status[i]]
        if nil ~= ship then
            cell:init(ship, i, true)
            local Image_line_role = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_line_role")
            if nil ~= Image_line_role then
                Image_line_role:setVisible(false)
            end
        else
            cell:init(nil,i, true, nil,nil,true)
        end

        if i <= nMaxCount then
            -- 上阵
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
            {
                terminal_name = "world_boss_open_join_formation_window",
                cell_index = i,
                isPressedActionEnabled = true
            },
            nil,0)
        end
        -- if nil ~= ship then
            ListView_gh_pve_line:addChild(cell) 
        -- end
    end
    ListView_gh_pve_line:requestRefreshView()
end

--一键上阵
function WorldBossWindow:oneKeyFormationChange( ... )
    local nMaxCount = 6

    local function fightingCapacity(a,b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local fightShipList = {}

    for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil then
            table.insert(fightShipList, ship) 
        end
    end
    table.sort(fightShipList, fightingCapacity)

    local str = ""
    for i = 1, 6 do
        _ED.formetion[i + 1] = 0
        _ED.user_formetion_status[i] = 0
        if i <= nMaxCount then
            local ship = fightShipList[i]
            local shipId = zstring.tonumber(_ED.formetion[i + 1])
            if nil ~= ship then
                _ED.formetion[i + 1] = ship.ship_id
                _ED.user_formetion_status[i] = ship.ship_id
            end
        end
    end
    
    cc.UserDefault:getInstance():setStringForKey(getKey("world_boss_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("world_boss_copy_formation_info"), zstring.concat(_ED.formetion, ","))

    self:drawFormationList()
end

--单个英雄加入阵容
function WorldBossWindow:joinFormtion( params )
    state_machine.excute("hero_formation_choice_wear_window_close", 0, 0)

    local nMaxCount = 6

    local cell_index = params[1]
    local ship_id = params[2]

    for i, v in pairs(_ED.user_formetion_status) do
        if zstring.tonumber(v) <= 0 and i <= nMaxCount then
            cell_index = i
            break
        end
    end

    local old_ship_id = zstring.tonumber(_ED.user_formetion_status[cell_index])
    _ED.user_formetion_status[cell_index] = ship_id
    for i = 1, 6 do
        local shipId = zstring.tonumber(_ED.formetion[i + 1])
        if i <= nMaxCount then
            if shipId > 0 then
                if old_ship_id == shipId then
                    _ED.formetion[i + 1] = ship_id
                    break
                end
            else
                _ED.formetion[i + 1] = ship_id
                break
            end
        end
    end
    
    cc.UserDefault:getInstance():setStringForKey(getKey("world_boss_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("world_boss_copy_formation_info"), zstring.concat(_ED.formetion, ","))
    self:drawFormationList()
end

--英雄位置变换
function WorldBossWindow:formationPosChange()
    cc.UserDefault:getInstance():setStringForKey(getKey("world_boss_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("world_boss_copy_formation_info"), zstring.concat(_ED.formetion, ","))
end

--战斗（客户端计算->服务器计算）
function WorldBossWindow:fight()
    -- 初始6个位置没有英雄，传0
    local shipIds = {0, 0, 0, 0, 0, 0}
    for idx = 1, 6 do
        local shipID = _ED.formetion[idx + 1]
        if tonumber(shipID) > 0 then
            if _ED.user_ship[shipID] ~= nil then
                shipIds[idx] = shipID
            end
        end
    end

    local shipIdStr = ""
    for i = 1, #shipIds do
        shipIdStr = shipIdStr .. shipIds[i]
        if i ~= #shipIds then
            shipIdStr = shipIdStr .. "|"
        end
    end
    -- print("shipIdStr = ", shipIdStr)

    -- 战斗请求   
    local function responseBattleInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.unlock("world_boss_window_join_battle")

            if response.node == nil or response.node.roots == nil then
                return
            end

            fwin:cleanView(fwin._windows)
            cc.Director:getInstance():purgeCachedData()
            cacher.removeAllTextures()
                
            app.load("client.battle.report.BattleReport")
            app.load("client.battle.BattleStartEffect")

            local bse = BattleStartEffect:new()
            bse:init(_enum_fight_type._fight_type_218)
            fwin:open(bse, fwin._windows)
        else
            state_machine.unlock("world_boss_window_join_battle")
        end
    end

    protocol_command.world_boss_attack.param_list = shipIdStr
    NetworkManager:register(protocol_command.world_boss_attack.code, nil, nil, nil, self, responseBattleInitCallback, false, nil)

    -- local function launchBattle()
    --     app.load("client.battle.fight.FightEnum")
    --     local fightType = state_machine.excute("fight_get_current_fight_type", 0, nil)
    --     local function responseBattleStartCallback( response )
    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    --         app.load("client.battle.report.BattleReport")
    --         app.load("client.battle.BattleStartEffect")

    --         local resultBuffer = {}
    --         if _ED._fightModule == nil then
    --             _ED._fightModule = FightModule:new()
    --         end
    --         _ED.attackData = {
    --             roundCount = _ED._fightModule.totalRound,
    --             roundData ={}
    --         }
    --         if _ED._scene_npc_id == nil or _ED._scene_npc_id == "" or tonumber(_ED._scene_npc_id) == 0 then
    --             _ED._scene_npc_id = _ED._scene_npc_copy_net_id
    --         end
    --         local fightType = 0
    --         fightType = _enum_fight_type._fight_type_218
    --         -- _ED.union_copy_fight_data_id = tonumber(self.data_id)
    --         _ED._fightModule:initWordBossFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
            
    --         local orderList = {}
    --         _ED._fightModule:initFightOrder(_ED.user_info, orderList)
            
    --         responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
    --     else
    --         _ED._current_scene_id = ""
    --         _ED._scene_npc_id = ""
    --         _ED.trial_scene_npc_id = ""
    --         _ED._npc_difficulty_index = ""
    --         _ED.trial_star_Magnification = 1
    --     end
    -- end
    
    -- responseBattleStartCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
    -- end
    -- local cur_scene_id = dms.int(dms["world_boss"], _ED.world_boss_info.bossId, 3)
    -- _ED._current_scene_id = cur_scene_id
    -- local cur_npc_id = dms.int(dms["pve_scene"], cur_scene_id, 13)
    -- _ED._scene_npc_id = cur_npc_id
    -- _ED._npc_difficulty_index = 1
    -- -- if self.npc_id then
    --     _ED.world_boss_attack_npc_id = cur_npc_id
    -- -- end
    -- -- _ED.union_attack_data_id = self.data_id

    -- launchBattle()
end

function WorldBossWindow:worldBossDailyTaskRedot()
    local function isHaveRedot()
        for i = 1, #dms["world_boss_daily_reward"] do
            local condition = dms.int(dms["world_boss_daily_reward"], i, 2)
            local needcount = dms.int(dms["world_boss_daily_reward"], i, 3)
            local curCount = _ED.world_boss_my_info.allTask.taskInfo[condition .. ""]
            if (table.containValue(_ED.world_boss_my_info.allTask.drawTaskId, "" .. i) or table.containValue(_ED.world_boss_my_info.allTask.drawTaskId, i)) then -- 已经领取
            else
                if tonumber(curCount) >= needcount then --已完成
                    return true
                end
            end
        end

        return false
    end

    local Image_red = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_2")
    Image_red:setVisible(isHaveRedot())
end

function WorldBossWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/world_boss/world_boss.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 个人排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_integral_everyday"), nil, 
    {
        terminal_name = "world_boss_rebel_boss_check_enter", 
        isPressedActionEnabled = true,
        ranktype = 1,
    },
    nil, 0)

    -- 工会排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_integral_add"), nil, 
    {
        terminal_name = "world_boss_rebel_boss_check_enter", 
        isPressedActionEnabled = true,
        ranktype = 2,
    },
    nil, 0)

    -- 布阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boss_lineup"), nil, 
    {
        terminal_name = "world_boss_window_open_formation", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boss_reward"), nil, 
    {
        terminal_name = "world_boss_open_daily_task", 
        isPressedActionEnabled = true
    },
    nil, 0)
    --奖励红点
    self.Image_red_2 = ccui.Helper:seekWidgetByName(root, "Image_red_2")
    self.Image_red_2:setVisible(false)

    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boss_rule"), nil, 
    {
        terminal_name = "world_boss_rule_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 重置冷却
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boss_reset_cooling"), nil, 
    {
        terminal_name = "world_boss_window_refresh_time", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 挑战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boss_challenge"), nil, 
    {
        terminal_name = "world_boss_window_join_battle", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_phb_back"), nil, 
    {
        terminal_name = "world_boss_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 布阵关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_boss_line"), nil, 
    {
        terminal_name = "world_boss_window_open_formation", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 调整阵容
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_em_line_change"), nil, 
    {
        terminal_name = "world_boss_formation_change", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 一键上阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_em_line"), nil, 
    {
        terminal_name = "world_boss_oen_key_formation_window", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function WorldBossWindow:init()

end

function WorldBossWindow:onExit()
    _ED.world_boss_personal_rank = nil
    _ED.world_boss_union_rank = nil

    self:revertFormation()
end

-- 备份阵容
function WorldBossWindow:backupFormation()
    _ED.user_formetion_status_copy = {}
    _ED.formetion_copy = {}
    table.merge(_ED.user_formetion_status_copy, _ED.user_formetion_status)
    table.merge(_ED.formetion_copy, _ED.formetion)
end

-- 还原阵容
function WorldBossWindow:revertFormation()
    if nil ~= _ED.user_formetion_status_copy then
        _ED.user_formetion_status = _ED.user_formetion_status_copy
        _ED.user_formetion_status_copy = nil
    end
    if nil ~= _ED.formetion_copy then
        _ED.formetion = _ED.formetion_copy
        _ED.formetion_copy = nil
    end
end