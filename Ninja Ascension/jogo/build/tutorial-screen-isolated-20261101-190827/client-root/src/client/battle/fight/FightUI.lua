FightUI = class("FightUIClass", Window)
require("client.utils.FuryGameSpeed")   -- Fury (V2): marchas x4/x5/x6 por VIP

function FightUI:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._canSkipFighting = false
    self._isPvEType = false

    self._prop_drop_count = 0
    self._card_drop_count = 0
    self._equip_drop_count = 0
    self._isAuto = false
    if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
        self._isAuto = true
    end
    self.lastLevel = zstring.tonumber(_ED.user_info.user_grade)

    self.jumptTimes = 0
    self.isJump = false

    self.zoarium_skill_uis = {}

    self.action_nodes = {}

    -- Initialize fight ui page state machine.
    local function init_fight_ui_terminal()
        -- 更新战斗回合数
        local fight_ui_update_battle_round_count_terminal = {
            _name = "fight_ui_update_battle_round_count",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawRoundCount(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗次数
        local fight_ui_update_battle_count_terminal = {
            _name = "fight_ui_update_battle_count",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawCount(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制战斗双方信息
        local fight_ui_update_battle_player_info_terminal = {
            _name = "fight_ui_update_battle_player_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawPlayerInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗中角色死亡后的掉落
        local fight_ui_update_battle_card_drop_terminal = {
            _name = "fight_ui_update_battle_card_drop",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                else
                    if params.dropType == 0 then
                        instance:updateBattlePropDrop(params.dropCount)
                    elseif params.dropType == 1 then
                        instance:updateBattleCardDrop(params.dropCount)
                    elseif params.dropType == 2 then
                        instance:updateBattleEquipDrop(params.dropCount)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗的UI显示状态
        local fight_ui_visible_terminal = {
            _name = "fight_ui_visible",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 跳过战斗
        local fight_ui_skeep_fighting_terminal = {
            _name = "fight_ui_skeep_fighting",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 
                        then
                        if self.isJump == true then
                            return
                        end
                    end
                end
                state_machine.excute("fight_skeep_fighting", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗中的动画速度控制器
        local fight_ui_change_time_speed_terminal = {
            _name = "fight_ui_change_time_speed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local actionTimeSpeedIndex = params._datas._actionTimeSpeedIndex
                local lastActionTimeSpeedIndex = actionTimeSpeedIndex
                if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert
                    then
                    
                    if actionTimeSpeedIndex == 1 then
                        if true == funOpenDrawTip(36) then
                            return false
                        end
                        actionTimeSpeedIndex = 2
                    elseif actionTimeSpeedIndex == 2 then
                        if true == funOpenDrawTip(37, false) then
                            actionTimeSpeedIndex = 1
                        else
                            actionTimeSpeedIndex = 3
                        end
                    elseif actionTimeSpeedIndex >= 3 then
                        -- Fury (V2): despues de x3 vienen x4/x5/x6 si el VIP llega
                        actionTimeSpeedIndex = fury_game_speed.next_fight_index(actionTimeSpeedIndex)
                    end              
                else
                    if actionTimeSpeedIndex == 1 then
                        if tonumber("".. instance.lastLevel) < 5 and zstring.tonumber("".._ED.vip_grade) < 1 then
                            TipDlg.drawTextDailog(_string_piece_info[213])
                            return
                        end
                        actionTimeSpeedIndex = 2
                    elseif actionTimeSpeedIndex == 2 then
                        local needLevel = 40 
                        if __lua_project_id == __lua_project_pokemon 
                            or __lua_project_id == __lua_project_digimon_adventure 
                            or __lua_project_id == __lua_project_red_alert_time 
                            or __lua_project_id == __lua_project_pacific_rim  
                            or __lua_project_id == __lua_project_naruto 
                            then 
                            needLevel = 20
                        end
                        if tonumber(""..instance.lastLevel) < needLevel and zstring.tonumber("".._ED.vip_grade) < 1 then
                            TipDlg.drawTextDailog(_string_piece_info[214])
                            actionTimeSpeedIndex = 1
                        else
                            actionTimeSpeedIndex = 3
                        end
                    elseif actionTimeSpeedIndex == 3 then
                        actionTimeSpeedIndex = 1
                    end
                end

                local root = instance.roots[1]
                ccui.Helper:seekWidgetByName(root, string.format("Button_x%d", lastActionTimeSpeedIndex)):setVisible(false)
                ccui.Helper:seekWidgetByName(root, string.format("Button_x%d", actionTimeSpeedIndex)):setVisible(true)
                __fight_recorder_action_time_speed = _enum_action_time_speed[actionTimeSpeedIndex]

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    state_machine.excute("fight_role_controller_update_role_animation_speed", 0, __fight_recorder_action_time_speed)
                elseif __lua_project_id == __lua_project_gragon_tiger_gate 
                    or __lua_project_id == __lua_project_red_alert 
                    or __lua_project_id == __lua_project_legendary_game 
                    then
                    
                else
                    state_machine.excute("fight_map_action_time_speed", 0, 0)
                    state_machine.excute("battle_formation_action_time_speed", 0, 0)
                end
                
                
                _ED.user_set_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
                
                -- 写入记录
                local kname = "userFightSpeed" 
                writeKey(kname, _ED.user_set_fight_recorder_action_time_speed)

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    __fight_recorder_action_time_speed_index = actionTimeSpeedIndex
                    __fight_recorder_action_time_speed = _enum_action_time_speed[1]
                    -- _ED.user_set_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
                    if nil ~= _fight_time_scale then
                        cc.Director:getInstance():getScheduler():setTimeScale(_fight_time_scale[__fight_recorder_action_time_speed_index])
                    else
                        cc.Director:getInstance():getScheduler():setTimeScale(1.0 * __fight_recorder_action_time_speed_index)
                    end
                    __fight_recorder_action_time_speed = 1.0
                    state_machine.excute("fight_qte_controller_change_time_speed", 0, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗速度设置
        local fight_ui_change_time_speed_set_terminal = {
            _name = "fight_ui_change_time_speed_set",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- eg: state_machine.excute("fight_ui_change_time_speed_set", 0, 2)
                -- 写入记录
                local kname = "userFightSpeed" 
                writeKey(kname, _enum_action_time_speed[params])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 掉落的移动动画
        local fight_ui_drop_moving_terminal = {
            _name = "fight_ui_drop_moving",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _index = params._index
                local widget_names = {
                    "ImageView_10861", "ImageView_10862", "ImageView_10863"
                }
                if instance.roots == nil then
                    return false
                end

                local root = instance.roots[1]
                local dropWidget = ccui.Helper:seekWidgetByName(root,widget_names[_index])
                local movePosition = fwin:convertToWorldSpaceAR(dropWidget, cc.p(0, 0)) -- dropWidget:convertToWorldSpaceAR(cc.p(0, 0))
                local armature = params._armature
                armature._move_position = cc.p(movePosition.x / app.scaleFactor, movePosition.y / app.scaleFactor)
                local stime = 30
                local armature = params._armature
                
                local function playDropEffect()
                    pushEffect(formatMusicFile("button", 3))
                end
            
                armature:runAction(cc.Sequence:create(cc.MoveTo:create(tonumber(stime) / 60 * __fight_recorder_action_time_speed, armature._move_position),cc.CallFunc:create(playDropEffect)))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗中的HP
        local fight_ui_update_hp_progress_terminal = {
            _name = "fight_ui_update_hp_progress",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawHpProgress(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新切换自动战斗时间
        local fight_ui_update_auto_fight_time_terminal = {
            _name = "fight_ui_update_auto_fight_time",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateAutoFightTime(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 开始自动战斗
        local fight_ui_begin_auto_fight_terminal = {
            _name = "fight_ui_begin_auto_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots == nil then
                    return false
                end
                
                local root = instance.roots[1]

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if _ED.nr_arena_fight_rank then params._datas.terminal_state = 1 end -- arena: always auto
                    if _ED.nr_arena_fight_rank or (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
                    else
                    if true == funOpenDrawTip(161) then
                        return false
                    end
                    end
                    local autoBtn = ccui.Helper:seekWidgetByName(root, "Button_zidong")
                    local autoBtn2 = ccui.Helper:seekWidgetByName(root, "Button_zidong_2")
                    autoBtn:setVisible(false)
                    autoBtn2:setVisible(false)

                    if params._datas.terminal_state == 2 then
                        autoBtn:setVisible(true)
                        instance._isAuto = false
                        if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
                            instance._isAuto = true
                        end
                    else
                        autoBtn2:setVisible(not _ED.nr_arena_fight_rank) -- arena: no manual switch
                        instance._isAuto = true
                    end
                else
                    local autoBtn = ccui.Helper:seekWidgetByName(root, "Button_zidong")
                    instance._isAuto = not instance._isAuto
                    if instance._isAuto == true then
                        autoBtn:setHighlighted(true)
                    else
                        autoBtn:setHighlighted(false)
                    end
                end

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    state_machine.excute("fight_role_controller_change_to_auto_fight", 0, instance._isAuto)
                else
                    if instance._isAuto == true then
                        state_machine.excute("fight_role_controller_change_to_auto_fight", 0, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 暂停战斗
        local fight_ui_stop_fight_terminal = {
            _name = "fight_ui_stop_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --state_machine.excute("fight_role_controller_change_to_stop_fight", 0, nil)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if true == funOpenDrawTip(160) then
                        return false
                    end
                    instance:showFightPause()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_fight_auto_state_terminal = {
            _name = "fight_ui_update_fight_auto_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots == nil then
                    return false
                end
                local root = instance.roots[1]
                local autoBtn = ccui.Helper:seekWidgetByName(root, "Button_zidong")
                instance._isAuto = true
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    local autoBtn = ccui.Helper:seekWidgetByName(root, "Button_zidong")
                    local autoBtn2 = ccui.Helper:seekWidgetByName(root, "Button_zidong_2")
                    autoBtn:setVisible(false)
                    autoBtn2:setVisible(true)
                else
                    autoBtn:setHighlighted(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_fight_get_auto_state_terminal = {
            _name = "fight_ui_update_fight_get_auto_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance._isAuto
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_shake_ui_terminal = {
            _name = "fight_ui_shake_ui",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:startShakeUI()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_init_heti_skill_state_terminal = {
            _name = "fight_ui_init_heti_skill_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:initHetiSkillPanel(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_heti_skill_state_terminal = {
            _name = "fight_ui_update_heti_skill_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateHetiSkillState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_excute_heti_skill_terminal = {
            _name = "fight_ui_excute_heti_skill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:selectHetiPanel(params._datas.clickState)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_add_last_kill_effect_terminal = {
            _name = "fight_ui_add_last_kill_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addLastKillEffect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_change_battle_heti_state_terminal = {
            _name = "fight_ui_change_battle_heti_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeBattleHetiState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_skeep_heti_battle_terminal = {
            _name = "fight_ui_skeep_heti_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("update_fight_team_controller_skeep", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_skeep_animation_visible_false_terminal = {
            _name = "fight_ui_skeep_animation_visible_false",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_jiaoxue = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_jiaoxue")
                Panel_jiaoxue:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

                -- 跳过战斗
        local fight_ui_skeep_fighting_copy_terminal = {
            _name = "fight_ui_skeep_fighting_copy",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fight_skeep_fighting", 0, 0)
                state_machine.excute("fight_first_set_skip_misson",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_card_progress_terminal = {
            _name = "fight_ui_update_card_progress",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateCardProgress(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示战斗跳过按钮
        local fight_ui_show_keep_battle_terminal = {
            _name = "fight_ui_show_keep_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:showKeepBattle(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_play_attack_intitate_effect_terminal = {
            _name = "fight_ui_play_attack_intitate_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:playAttackIntitateEffect(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_open_attacker_hero_list_terminal = {
            _name = "fight_ui_open_attacker_hero_list",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:openAttackerHeroList(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_open_defender_hero_list_terminal = {
            _name = "fight_ui_open_defender_hero_list",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:openDefenderHeroList(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_boss_drop_silver_count_terminal = {
            _name = "fight_ui_update_boss_drop_silver_count",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateBossDropSilverCount(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_boss_drop_prop_count_terminal = {
            _name = "fight_ui_update_boss_drop_prop_count",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateBossDropPropCount(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_hide_mission_ui_control_terminal = {
            _name = "fight_ui_hide_mission_ui_control",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    local autoBtn = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_zidong")
                    autoBtn:setVisible(false)

                    local speedBtn = ccui.Helper:seekWidgetByName(instance.roots[1],"Button_x1")
                    if nil ~= speedBtn then
                        speedBtn:setVisible(false)
                    end
                    local speedBtn2 = ccui.Helper:seekWidgetByName(instance.roots[1],"Button_x2")
                    if nil ~= speedBtn2 then
                        speedBtn2:setVisible(false)
                    end
                    local speedBtn3 = ccui.Helper:seekWidgetByName(instance.roots[1],"Button_x3")
                    if nil ~= speedBtn3 then
                        speedBtn3:setVisible(false)
                    end
                    for n = 4, 6 do
                        local speedBtnN = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_x" .. n)
                        if nil ~= speedBtnN then
                            speedBtnN:setVisible(false)
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_resume_action_nodes_terminal = {
            _name = "fight_ui_resume_action_nodes",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                while #instance.action_nodes > 0 do
                    local node = table.remove(instance.action_nodes, 1)
                    if node ~= nil and node.resume ~= nil then
                        node._resume = true
                        node:resume()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 提供给教学使用的手动自动战斗控制器
        local fight_ui_mission_fight_controler_terminal = {
            _name = "fight_ui_mission_fight_controler",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- if zstring.tonumber(params) == 0 then

                -- else

                -- end
                if instance._isAuto then
                    state_machine.excute("fight_ui_begin_auto_fight", 0, {_datas = {
                            terminal_name = "fight_ui_begin_auto_fight",
                            terminal_state = 2, 
                            isPressedActionEnabled = true
                        }})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_animal_skill_state_terminal = {
            _name = "fight_ui_update_animal_skill_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    if instance:isShowAnimalPanel() == false then
                        return true
                    end

                    local animalInfoData = nil
                    if instance._isPvEType == false then
                        animalInfoData = params
                    end

                    instance:updateAnimalSkillState(animalInfoData)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_animal_anger_progress_terminal = {
            _name = "fight_ui_update_animal_anger_progress",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    if instance:isShowAnimalPanel() == false then
                        return true
                    end

                    local animalInfoData = nil
                    if instance._isPvEType == false then
                        animalInfoData = params
                    end
                    instance:updateAnimalAngerProgress(animalInfoData)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_ui_update_animal_skill_info_ui_terminal = {
            _name = "fight_ui_update_animal_skill_info_ui",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:refreshAnimalSkillInfoUI()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fight_ui_update_battle_round_count_terminal)
        state_machine.add(fight_ui_update_battle_count_terminal)
        state_machine.add(fight_ui_update_battle_player_info_terminal)
        state_machine.add(fight_ui_update_battle_card_drop_terminal)
        state_machine.add(fight_ui_visible_terminal)
        state_machine.add(fight_ui_skeep_fighting_terminal)
        state_machine.add(fight_ui_change_time_speed_terminal)
        state_machine.add(fight_ui_change_time_speed_set_terminal)
        state_machine.add(fight_ui_drop_moving_terminal)
        state_machine.add(fight_ui_update_hp_progress_terminal)
        state_machine.add(fight_ui_update_auto_fight_time_terminal)
        state_machine.add(fight_ui_update_fight_get_auto_state_terminal)
        state_machine.add(fight_ui_begin_auto_fight_terminal)
        state_machine.add(fight_ui_stop_fight_terminal)
        state_machine.add(fight_ui_update_fight_auto_state_terminal)
        state_machine.add(fight_ui_shake_ui_terminal)
        state_machine.add(fight_ui_init_heti_skill_state_terminal)
        state_machine.add(fight_ui_update_heti_skill_state_terminal)
        state_machine.add(fight_ui_excute_heti_skill_terminal)
        state_machine.add(fight_ui_add_last_kill_effect_terminal)
        state_machine.add(fight_ui_change_battle_heti_state_terminal)
        state_machine.add(fight_ui_skeep_heti_battle_terminal)
        state_machine.add(fight_ui_skeep_animation_visible_false_terminal)
        state_machine.add(fight_ui_skeep_fighting_copy_terminal)
        if __lua_project_id == __lua_project_yugioh then
            state_machine.add(fight_ui_update_card_progress_terminal)
        end
        state_machine.add(fight_ui_show_keep_battle_terminal)
        state_machine.add(fight_ui_play_attack_intitate_effect_terminal)
        state_machine.add(fight_ui_open_attacker_hero_list_terminal)
        state_machine.add(fight_ui_open_defender_hero_list_terminal)
        state_machine.add(fight_ui_update_boss_drop_silver_count_terminal)
        state_machine.add(fight_ui_update_boss_drop_prop_count_terminal)
        state_machine.add(fight_ui_hide_mission_ui_control_terminal)
        state_machine.add(fight_ui_resume_action_nodes_terminal)
        state_machine.add(fight_ui_mission_fight_controler_terminal)
        state_machine.add(fight_ui_update_animal_skill_state_terminal)
        state_machine.add(fight_ui_update_animal_anger_progress_terminal)
        state_machine.add(fight_ui_update_animal_skill_info_ui_terminal)
        state_machine.init()
    end

    -- call func init fight ui state machine.
    init_fight_ui_terminal()
end

function FightUI:init(_canSkipFighting, isPveFight)
    self._canSkipFighting = _canSkipFighting
    self._isPvEType = isPveFight
    return self
end

function FightUI:updateCardProgress( params )
    local root = self.roots[1]
    if root ~= nil then
        local LoadingBar_magic = ccui.Helper:seekWidgetByName(root, "LoadingBar_magic")
        local Panel_below = ccui.Helper:seekWidgetByName(root, "Panel_below")
        LoadingBar_magic:setPercent(zstring.tonumber(params)/zstring.tonumber(_ED.battleData.card_max_progress) * 100)
        if zstring.tonumber(params) >= zstring.tonumber(_ED.battleData.card_max_progress) then
            Panel_below:getChildByName("ArmatureNode_magic"):setVisible(true)
        else
            Panel_below:getChildByName("ArmatureNode_magic"):setVisible(false)
        end
    end
end

function FightUI:updateBossDropSilverCount( params )
    local root = self.roots[2]
    if root ~= nil then
        local Text_maoxian_reward_1 = ccui.Helper:seekWidgetByName(root, "Text_maoxian_reward_1")
        -- local oldCount = zstring.tonumber(Text_maoxian_reward_1:getString())
        -- Text_maoxian_reward_1:setString(oldCount + params[2])

        local Panel_reward_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_1")
        local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")

        local pos2 = cc.p(Panel_reward_2:getPosition())
        local size = Panel_reward_2:getContentSize()
        if size.width < 10 then
            size.height = 20
            size.width = 200
        end

        pos2.x = pos2.x + size.width / 2

        local rcCount = math.random(1, 5) * math.random(1, params[1])
        for i = 1, rcCount do
            local jinbi = cc.Sprite:create("images/ui/icon/jinbi.png")

            local pos = cc.p(Panel_reward_1:getPosition())
            jinbi:setPosition(pos)
            Panel_reward_1:getParent():addChild(jinbi)

            local rw = math.random(0, size.width / 2)
            local flag = 1
            if math.random(0, 1) == 1 then
                rw = -1 * rw
                flag = -1
            end
            local rh = math.random(0, size.height)
            local seq = cc.Sequence:create({
                    -- cc.MoveTo:create(math.random(0.3, 0.4), cc.p(pos.x + math.random(0, 10), pos.y + math.random(0, 20))),
                    -- cc.MoveTo:create(math.random(0.3, 0.4), cc.p(pos2.x + rw, pos2.y + rh)),
                    -- cc.JumpBy:create(math.random(0.3, 0.5), cc.p(math.random(10, 200), 0), math.random(10, 50), 1),
                    -- cc.DelayTime:create(math.random(0.3, 0.5)),
                    cc.MoveTo:create(0.1, cc.p(pos.x + math.random(0, 10), pos.y + math.random(0, 20))),
                    cc.MoveTo:create(0.3, cc.p(pos2.x + rw, pos2.y + rh)),
                    cc.JumpBy:create(0.3, cc.p(math.random(10, 200) * flag, 0), math.random(10, 50), 1),
                    cc.CallFunc:create(function ( sender ) if sender._resume ~= true then sender:pause() end end),
                    cc.DelayTime:create(0.5),
                    cc.CallFunc:create(function ( sender )
                        sender:runAction(cc.Sequence:create({
                            cc.MoveTo:create(0.5, cc.p(Text_maoxian_reward_1:getPosition())),
                            cc.CallFunc:create(function ( sender )
                                if nil ~= sender._n_count then
                                    local oldCount = zstring.tonumber(Text_maoxian_reward_1:getString())
                                    Text_maoxian_reward_1:setString(sender._n_count)
                                end
                                for k,v in pairs(sender._self.action_nodes) do
                                    if v == sender then
                                        table.remove(sender._self.action_nodes, k, 1)
                                        break
                                    end
                                end
                                sender:removeFromParent(true)
                            end)
                            }))
                    end)
                })
            jinbi:runAction(seq)
            jinbi._self = self

            table.insert(self.action_nodes, jinbi)

            if i == 1 then
                jinbi._n_count = _ED._fightModule._g_c_silver + _ED._fightModule._g_c_silver1 -- zstring.tonumber(Text_maoxian_reward_1:getString()) + params[2]
            end
        end
    end
end

function FightUI:updateBossDropPropCount( params )
    local root = self.roots[2]
    if root ~= nil then
        local Text_maoxian_reward_2 = ccui.Helper:seekWidgetByName(root, "Text_maoxian_reward_2")
        -- local oldCount = zstring.tonumber(Text_maoxian_reward_2:getString())
        -- Text_maoxian_reward_2:setString(oldCount + params[2])

        local Panel_reward_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_1")
        local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")

        local pos2 = cc.p(Panel_reward_2:getPosition())
        local size = Panel_reward_2:getContentSize()
        if size.width < 10 then
            size.height = 20
            size.width = 200
        end

        pos2.x = pos2.x + size.width / 2

        local baoxiangPng = nil
        if nil ~= params[4] and 0 < params[4] then
            local picIndex = dms.int(dms["prop_mould"], params[4], prop_mould.pic_index)
            baoxiangPng = string.format("images/ui/props/props_%d.png", picIndex)  
        else
            baoxiangPng = "images/ui/icon/vip_baoxiang.png"
        end

        local rcCount = math.random(1, 5) * math.random(1, params[1])
        for i = 1, rcCount do
            -- local vip_baoxiang = cc.Sprite:create("images/ui/props/props_3032.png")
            local vip_baoxiang = cc.Sprite:create(baoxiangPng)

            local pos = cc.p(Panel_reward_1:getPosition())
            vip_baoxiang:setPosition(pos)
            Panel_reward_1:getParent():addChild(vip_baoxiang)

            local rw = math.random(0, size.width / 2)
            local flag = 1
            if math.random(0, 1) == 1 then
                rw = -1 * rw
                flag = -1
            end
            local rh = math.random(0, size.height)
            local seq = cc.Sequence:create({
                    -- cc.MoveTo:create(math.random(0.3, 0.4), cc.p(pos.x + math.random(0, 10), pos.y + math.random(0, 20))),
                    -- cc.MoveTo:create(math.random(0.3, 0.4), cc.p(pos2.x + rw, pos2.y + rh)),
                    -- cc.JumpBy:create(math.random(0.3, 0.5), cc.p(math.random(10, 200), 0), math.random(10, 50), 1),
                    -- cc.DelayTime:create(math.random(0.3, 0.5)),
                    cc.MoveTo:create(0.1, cc.p(pos.x + math.random(0, 10), pos.y + math.random(0, 20))),
                    cc.MoveTo:create(0.3, cc.p(pos2.x + rw, pos2.y + rh)),
                    cc.JumpBy:create(0.3, cc.p(math.random(10, 200) * flag, 0), math.random(10, 50), 1),
                    cc.CallFunc:create(function ( sender ) if sender._resume ~= true then sender:pause() end end),
                    cc.DelayTime:create(0.5),
                    cc.CallFunc:create(function ( sender )
                        sender:runAction(cc.Sequence:create({
                            cc.MoveTo:create(0.5, cc.p(Text_maoxian_reward_2:getPosition())),
                            cc.CallFunc:create(function ( sender )
                                if nil ~= sender._n_count then
                                    local oldCount = zstring.tonumber(Text_maoxian_reward_2:getString())
                                    Text_maoxian_reward_2:setString(sender._n_count)
                                end
                                for k,v in pairs(sender._self.action_nodes) do
                                    if v == sender then
                                        table.remove(sender._self.action_nodes, k, 1)
                                        break
                                    end
                                end
                                sender:removeFromParent(true)
                            end)
                            }))
                    end)
                })
            vip_baoxiang:runAction(seq)
            vip_baoxiang._self = self

            table.insert(self.action_nodes, vip_baoxiang)

            if i == 1 then
                -- vip_baoxiang._n_count = zstring.tonumber(Text_maoxian_reward_2:getString()) + params[2]
                Text_maoxian_reward_2._rc = Text_maoxian_reward_2._rc or 0
                vip_baoxiang._n_count = Text_maoxian_reward_2._rc + params[2]
                Text_maoxian_reward_2._rc = vip_baoxiang._n_count
            end
        end
    end
end

function FightUI:changeBattleHetiState( params )
    local root = self.roots[1]
    if root ~= nil then
        if params == true then
            ccui.Helper:seekWidgetByName(root, "Panel_below"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Panel_19"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_htj_tg"):setVisible(true)
            for k,v in pairs(self.zoarium_skill_uis) do
                local hetiPanel = ccui.Helper:seekWidgetByName(root, "Panel_hetiji_"..v.panelIndex)
                hetiPanel:setVisible(false)
            end
            ccui.Helper:seekWidgetByName(root, "Panel_hetijiguangx"):setVisible(false)
        else
            ccui.Helper:seekWidgetByName(root, "Panel_below"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Panel_19"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Button_htj_tg"):setVisible(false)
            for k,v in pairs(self.zoarium_skill_uis) do
                local hetiPanel = ccui.Helper:seekWidgetByName(root, "Panel_hetiji_"..v.panelIndex)
                hetiPanel:setVisible(true)
            end
            ccui.Helper:seekWidgetByName(root, "Panel_hetijiguangx"):setVisible(true)
        end
    end
end

function FightUI:addLastKillEffect( ... )
    local root = self.roots[1]
    if root ~= nil then
        local function changeActionCallback( armatureBack )
            armatureBack:removeFromParent(true)
        end
        local panel_lask_kill = ccui.Helper:seekWidgetByName(root, "Panel_last_kill")
        panel_lask_kill:removeAllChildren(true)
        local animation = sp.spine("effect/effice_zuihouyiji.json", "effect/effice_zuihouyiji.atlas", 1, 0, effectAnimations[1], true, nil)
        sp.initArmature(animation, false)
        animation._invoke = changeActionCallback
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        animation:getAnimation():setSpeedScale(1.0 / __fight_recorder_action_time_speed)
        panel_lask_kill:addChild(animation)
    end
end

function FightUI:initHetiSkillPanel( params )
    self.zoarium_skill_uis = {}
    local root = self.roots[1]
    local zoarium_skill_list = state_machine.excute("fight_get_zoarium_skill_movers", 0, nil)
    local findIndex = 0
    for i=1,2 do
        local hetiPanel = ccui.Helper:seekWidgetByName(root, "Panel_hetiji_"..i)
        local mask = ccui.Helper:seekWidgetByName(root, "Panel_mask_"..i)
        local sprite = hetiPanel:getChildByName("Sprite_htj_"..i)
        for k, v in pairs(zoarium_skill_list) do
            if k > findIndex and tonumber(v) ~= 0 and v ~= "" and tonumber(v) ~= -1 then
                findIndex = k
                local armature = params[k]
                if armature ~= nil then
                    table.insert(self.zoarium_skill_uis, {armature = armature, slot = k, panelIndex = i, isCanTouch = false})
                    local picIndex = armature._info._head
                    sprite:setTexture(string.format("images/ui/battle/hetijitubiao/jinengtubiao_%d.png", picIndex))
                    display:gray(sprite)
                    -- mask:setBackGroundImage(string.format("images/ui/battle/hetijitubiao/jinengtubiao_%d.png", picIndex))
                    local sp = cc.Sprite:create(string.format("images/ui/battle/hetijitubiao/jinengtubiao_%d.png", picIndex))
                    if sp ~= nil then
                        mask:addChild(sp)
                        sp:setPosition(cc.p(0, 0))
                        sp:setAnchorPoint(cc.p(0,0))
                        sp:ignoreAnchorPointForPosition(false)
                    end
                    mask:setContentSize(cc.size(hetiPanel:getContentSize().width, 0))
                    hetiPanel:setVisible(true)
                    break
                end
            end
        end
    end
end

function FightUI:updateHetiSkillState( params )
    local cell = params.cell
    local state = tonumber(params.status)
    -- local slot = tonumber(params.slot)
    local root = self.roots[1]
    local slot = 1
    if cell._info ~= nil then
        slot = tonumber(cell._info._pos)
    end
    local Panel_hetijiguangx = ccui.Helper:seekWidgetByName(root, "Panel_hetijiguangx")
    for k,v in pairs(self.zoarium_skill_uis) do
        if tonumber(v.slot) == slot then
            local hetiPanel = ccui.Helper:seekWidgetByName(root, "Panel_hetiji_"..v.panelIndex)
            local hetiEffect = ccui.Helper:seekWidgetByName(root, "Panel_tub_gx_"..v.panelIndex)
            local actPanel = ccui.Helper:seekWidgetByName(root, "Panel_tub_gx_dc_"..v.panelIndex)
            local maskSp = ccui.Helper:seekWidgetByName(root, "Panel_mask_"..v.panelIndex)
            local effectPanel = ccui.Helper:seekWidgetByName(root, "Panel_hetiji_jindu_"..v.panelIndex)
            local animation = effectPanel:getChildByName("ArmatureNode_6")
            
            v.armature = cell
            local size = effectPanel:getContentSize()
            local scale = 0
            local skillPoint = 0
            if _ED._fightModule ~= nil then
                local states = _ED._fightModule:getAttackZomlllSkillPoint()
                if states[slot] ~= nil then
                    skillPoint = tonumber(states[slot])
                    scale = tonumber(states[slot])/tonumber(_ED._fightModule.maxZolSkillPoint)
                end
                if skillPoint > tonumber(_ED._fightModule.maxZolSkillPoint) then
                    skillPoint = tonumber(_ED._fightModule.maxZolSkillPoint)
                end
            end
            maskSp:setContentSize(cc.size(size.width, scale * size.height))
            maskSp:setOpacity(255)
            local pointInfo = zstring.split(fight_heti_icon_precent[skillPoint + 1], ",")
            if scale ~= 0 then
                effectPanel:setVisible(true)
                if animation ~= nil then
                    animation:setScale(tonumber(pointInfo[1]))
                    animation:setPositionY(tonumber(pointInfo[2]))
                end
            else
                effectPanel:setVisible(false)
            end
            -- local repetIndex = 0
            -- local function repetBack( sender )
            --     if sender ~= nil then
            --         repetIndex = repetIndex + 1
            --         if repetIndex > 5 then
            --             sender:removeAllActions()
            --         end
            --         sender:setContentSize(cc.size(size.width, scale * size.height * repetIndex/5))
            --     end
            -- end
            -- local array = {}
            -- table.insert(array, cc.ScaleTo:create(0.5, tonumber(pointInfo[1])))
            -- table.insert(array, cc.MoveTo:create(0.5, cc.p(animation:getPositionX(), tonumber(pointInfo[2]))))
            -- animation:runAction(cc.Spawn:create(array))
            -- maskSp:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(repetBack))))

            if tonumber(state) == 5 or tonumber(state) == 6 then
                Panel_hetijiguangx:removeAllChildren(true)
                local function changeActionCallback( armatureBack )
                    armatureBack:removeFromParent(true)
                end
                local jsonPath = "images/ui/effice/effice_hetijianniudianliang_0/effice_hetijianniudianliang_0.json"
                local atlasPath = "images/ui/effice/effice_hetijianniudianliang_0/effice_hetijianniudianliang_0.atlas"
                local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
                sp.initArmature(animation, false)
                animation._invoke = changeActionCallback
                animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                Panel_hetijiguangx:addChild(animation)

                local function changeActionCallback1( armatureBack )
                    armatureBack:removeFromParent(true)
                end
                local jsonPath = "images/ui/effice/effice_hetijianniudianliang_1/effice_hetijianniudianliang_1.json"
                local atlasPath = "images/ui/effice/effice_hetijianniudianliang_1/effice_hetijianniudianliang_1.atlas"
                local animation1 = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
                sp.initArmature(animation1, false)
                animation1._invoke = changeActionCallback1
                animation1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                actPanel:addChild(animation1)

                jsonPath = "images/ui/effice/effice_hetijianniuguangxiao/effice_hetijianniuguangxiao.json"
                atlasPath = "images/ui/effice/effice_hetijianniuguangxiao/effice_hetijianniuguangxiao.atlas"
                hetiEffect:addChild(sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil))
                
                -- hetiPanel:setColor(cc.c3b(255, 255, 255))
                v.isCanTouch = true
                v.armature.isBeginHeti = true
            else
                -- if scale >= 1 then
                --     maskSp:setOpacity(80)
                -- end
                actPanel:removeAllChildren(true)
                hetiEffect:removeAllChildren(true)
                -- hetiPanel:setColor(cc.c3b(80, 80, 80))
                v.isCanTouch = false
                v.armature.isBeginHeti = false
            end
        end
    end
end

function FightUI:selectHetiPanel( selectState )
    if #self.zoarium_skill_uis == 0 then
        return
    end
    local selectInfo = self.zoarium_skill_uis[selectState]
    if selectInfo ~= nil and selectInfo.isCanTouch == true then
        state_machine.excute("fight_qte_controller_qte_to_next_attack_role", 0, selectInfo)
    end
end

function FightUI:updateDrawHpProgress(params)
    local camp = params[1] + 1
    local currentValue = params[2]
    local totalValue = params[3]

    local hpProgress = currentValue * 1.0 / totalValue * 100

    hpProgress = math.max(0, math.min(100, hpProgress))

    -->___crint("camp:", hpProgress, currentValue, totalValue)

    -- LoadingBar_1_1  我方100%血量时显示
    -- LoadingBar_1_2  我方99%-51%血量时显示
    -- LoadingBar_1_3  我方50%-26%血量时显示
    -- LoadingBar_1_4  我方25%以下血量时显示

    -- LoadingBar_2_1  敌方方100%血量时显示
    -- LoadingBar_2_2  敌方99%-51%血量时显示
    -- LoadingBar_2_3  敌方50%-26%血量时显示
    -- LoadingBar_2_4  敌方25%以下血量时显示

    local hpLevel = 1
    if hpProgress > 99 then
        hpLevel = 1
    elseif hpProgress >= 51 then
        hpLevel = 2
    elseif hpProgress >= 26 then
        hpLevel = 3
    else
        hpLevel = 4
    end

    local root = self.roots[1]
    local hpLoadingBar = ccui.Helper:seekWidgetByName(root,"LoadingBar_" .. camp .. "_" .. hpLevel)
    local hpLoadingBar_0 = ccui.Helper:seekWidgetByName(root,"LoadingBar_" .. camp .. "_" .. hpLevel .. "_0")
    for i=1, 4 do
        ccui.Helper:seekWidgetByName(root,"LoadingBar_" .. camp .. "_" .. i):setVisible(false)

        local LoadingBar_c_0 = ccui.Helper:seekWidgetByName(root,"LoadingBar_" .. camp .. "_" .. i .. "_0")
        if nil ~= LoadingBar_c_0 then
            LoadingBar_c_0:setVisible(false)
        end
    end
    hpLoadingBar:setVisible(true)
    hpLoadingBar:setPercent(hpProgress)

    if nil ~= hpLoadingBar_0 then
        hpLoadingBar_0:stopAllActions()

        hpLoadingBar_0:setOpacity(255)
        hpLoadingBar_0:setVisible(true)
        if nil ~= hpLoadingBar_0.hpProgress then
            hpLoadingBar_0:setPercent(hpLoadingBar_0.hpProgress)
        end
        hpLoadingBar_0.hpProgress = hpProgress

        hpLoadingBar_0:runAction(cc.Sequence:create(cc.FadeOut:create(1.6), cc.CallFunc:create(function ( sender )
            if nil ~= sender.hpProgress then
                sender:setPercent(sender.hpProgress)
                sender.hpProgress = nil
            end
        end)))
    end

    local Panel_loading_bar = ccui.Helper:seekWidgetByName(root, "Panel_loading_bar_" .. camp)
    if nil ~= Panel_loading_bar then
        Panel_loading_bar._pos_x = Panel_loading_bar._pos_x or Panel_loading_bar:getPositionX()
        if 1 == camp then
            Panel_loading_bar:setPositionX(Panel_loading_bar._pos_x - (hpLoadingBar:getContentSize().width * (1 - hpProgress / 100)))
        else
            Panel_loading_bar:setPositionX(Panel_loading_bar._pos_x + (hpLoadingBar:getContentSize().width * (1 - hpProgress / 100)))
        end
    end
end

function FightUI:updateDrawRoundCount(_round_string)
    local root = self.roots[1]
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218 
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_7 then
            _round_string = zstring.split(_round_string, "/")[1] .. "/5"
        end
    end
    local fightRewardBoutCount = ccui.Helper:seekWidgetByName(root,"Label_10865")
    fightRewardBoutCount:setString(_round_string)
end

function FightUI:updateDrawCount( info )
    local root = self.roots[1]
    local Label__round_n = ccui.Helper:seekWidgetByName(root,"Label__round_n")
    Label__round_n:setString(info)
end

function FightUI:updateDrawPlayerInfo( info )
    local attackerSpeedValue = info[5]
    local defnederSpeedValue = info[6]
    local root = self.roots[1]
    local Label_1p_name = ccui.Helper:seekWidgetByName(root,"Label_1p_name")
    Label_1p_name:setString(info[1] or "")
    local Label_2p_name = ccui.Helper:seekWidgetByName(root,"Label_2p_name")
    --TODO: wf 2140 【战斗】【战斗回放】在PVP战斗回放中，如果玩家是纯数字名字，名字就会出现显示错误
--    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
--        if info[2] ~= nil and info[2] ~= "" then
--            if tonumber(info[2]) ~= nil then
--                local word_info = dms.element(dms["word_mould"], tonumber(info[2]))
--                if word_info ~= nil then
--                    info[2] = word_info[3]
--                end
--            end
--        end
--    end
    local defenderName = info[2]
    local nativeArena = type(cc.nrSpineCommand)=='function' and
        (_ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 or _ED.nr_arena_fight_rank ~= nil)
    if nativeArena then
        local savedName = _ED.nr_arena_fight_rank and _ED.nr_arena_defender_name or _ED.battleData.defender_name
        if savedName ~= nil and savedName ~= '' then defenderName = savedName end
    end
    -- 世界boss
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218 then
        local word_info = dms.element(dms["word_mould"], zstring.tonumber(defenderName))
        defenderName = word_info[3]
    end
    Label_2p_name:setString(defenderName or "")
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
        Label_1p_name:setString(_ED.battleData.attacker_name)
        Label_2p_name:setString(_ED.battleData.defender_name)
    end
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 and not nativeArena then
        local _richText2 = ccui.RichText:create()
        -- if Label_2p_name:getContentSize().width > 0 then
            _richText2:ignoreContentAdaptWithSize(false)
            _richText2:setContentSize(cc.size(500, 0))
            _richText2:setAnchorPoint(cc.p(0, 0))
            char_str = info[2]
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            cc.c3b(255, 255, 255),
            cc.c3b(255, 255, 255),
            0, 
            0, 
            "", 
            Label_2p_name:getFontSize(),
            chat_rich_text_color)
            _richText2:formatTextExt()
            local rsize = _richText2:getContentSize()
            _richText2:setPositionY(Label_2p_name:getContentSize().height/2)
            _richText2:setPositionX(-88 - (rsize.width)/2)
            Label_2p_name:addChild(_richText2)
            Label_2p_name:setString("")
        -- end
    end


    local Panel_pve_head_1 = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_1")
    local Panel_pve_head_2 = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_2")

    local attackerId = 0
    local defenderId = 0

    local attacker = 101304
    local pos = 1000
    local shipV = nil
    if self._isPvEType then
        for i, v in pairs(_ED.battleData._heros) do
            if tonumber(v._pos) < pos then
                attacker = v._head
                pos = tonumber(v._pos)
            end
        end
    else
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
            for i, v in pairs(_ED.battleData._heros) do
                if tonumber(v._pos) < pos then
                    attacker = v._head
                    attackerId = v._mouldId
                    pos = tonumber(v._pos)
                end
            end
        else
            attackerSpeedValue = _ED.battleData.attacker_priority
            for i, v in pairs(_ED.battleData._heros) do
                if tonumber(v._pos) < pos then
                    attacker = v._head
                end
            end
        end
    end

    --Panel_pve_head_1:setBackGroundImage("images/ui/pve_sn/props_" .. attacker .. ".png")
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        -- local quality_path = ""
        -- if tonumber(_ED.vip_grade) > 0 then
        --     quality_path = "images/ui/quality/player_1.png"
        -- else
        --     quality_path = "images/ui/quality/player_2.png"
        -- end
        -- local SpritKuang = cc.Sprite:create(quality_path)
        -- SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
        -- SpritKuang:setPosition(cc.p(Panel_pve_head_1:getContentSize().width / 2, Panel_pve_head_1:getContentSize().height / 2))
        -- Panel_pve_head_1:addChild(SpritKuang,0)

        local big_icon_path = ""
        local pic = tonumber(_ED.user_info.user_head)
        if pic >= 9 then
            big_icon_path = string.format("images/ui/props/props_%d.png", pic)
        else
            big_icon_path = string.format("images/ui/home/head_%d.png", pic)
        end
        local sprit = cc.Sprite:create(big_icon_path)
        sprit:setAnchorPoint(cc.p(0.5,0.5))
        sprit:setPosition(cc.p(Panel_pve_head_1:getContentSize().width / 2, Panel_pve_head_1:getContentSize().height / 2))
        --Panel_pve_head_1:addChild(sprit,0)
        Panel_pve_head_1:setBackGroundImage(big_icon_path)
    else
        Panel_pve_head_1:setBackGroundImage("images/ui/pve_sn/props_" .. attacker .. ".png")
    end

    local defender = info[3]
    if self._isPvEType then
        if zstring.tonumber(info[4]) > 0 then
            local Image_boss = ccui.Helper:seekWidgetByName(root, "Image_boss")
            Image_boss:setVisible(true)
        end
        if zstring.tonumber(info[7]) then
            local environmentIndex = 9 + zstring.tonumber(info[8]) - 1
            local environmentId = dms.int(dms["npc"], zstring.tonumber(info[7]), environmentIndex)
            defender = dms.int(dms["environment_formation"], environmentId, environment_formation.pic_index)
            local Image_boss = ccui.Helper:seekWidgetByName(root, "Image_boss")
            Image_boss:setVisible(false)
            for j=1,6 do
                local environment_shipIndex = environment_formation.seat_one + j - 1
                local environment_shipId = dms.int(dms["environment_formation"], environmentId, environment_shipIndex)
                if environment_shipId ~= 0 then
                    local sign_type = dms.int(dms["environment_ship"], environment_shipId, environment_ship.sign_type)
                    if sign_type == 1 then
                        Image_boss:setVisible(true)
                        break
                    end
                end
            end
            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_53 then
                if _ED.purify_team_name ~= nil or _ED.purify_team_name ~= "" then
                    local name_mould_id = dms.int(dms["ship_evo_mould"], tonumber(_ED.purify_team_name), ship_evo_mould.name_index)
                    local shipName = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
                    Label_2p_name:setString(shipName)
                    defender = dms.int(dms["ship_evo_mould"], tonumber(_ED.purify_team_name), ship_evo_mould.form_id)
                else
                    local name_id = dms.int(dms["environment_formation"], environmentId, environment_formation.formation_name)
                    local word_info = dms.element(dms["word_mould"], name_id)
                    if word_info~= nil then
                        Label_2p_name:setString(word_info[3])
                    end
                end
            else
                local name_id = dms.int(dms["environment_formation"], environmentId, environment_formation.formation_name)
                local word_info = dms.element(dms["word_mould"], name_id)
                if word_info~= nil then
                    Label_2p_name:setString(word_info[3])
                end
            end
        end
    else
        defnederSpeedValue = _ED.battleData.defender_priority
        pos = 1000
        
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214  or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219  or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
            for i, v in pairs(_ED.battleData._armys[1]._data) do
                if tonumber(v._pos) < pos then
                    pos = tonumber(v._pos)
                    defender = v._head
                    defenderId = v._mouldId
                end
            end
        else
            for i, v in pairs(_ED.battleData._armys[1]._data) do
                if tonumber(v._pos) < pos then
                    defender = v._head
                    if self._fight_type ~= _enum_fight_type._fight_type_53 then
                    else
                    end
                end
            end
        end

    end
    -- The local Arena fight builds its live defender from account data, not
    -- the regular NPC army parsed by the original battle UI. In that path the
    -- generic `defender` head can be nil; Arena's own header/portrait is set
    -- below from nr_arena_defender. Do not abort the entire FightUI on it.
    if defender ~= nil then
        Panel_pve_head_2:setBackGroundImage("images/ui/pve_sn/props_" .. defender .. ".png")
    end

    local Label_1p_speed_n = ccui.Helper:seekWidgetByName(root, "Label_1p_speed_n")
    local Label_2p_speed_n = ccui.Helper:seekWidgetByName(root, "Label_2p_speed_n")
    if _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_53 then
        Label_1p_speed_n:setString(_ED.battleData.attacker_priority or 0)
    else
        local speedNumber = 0
        for i, v in pairs(_ED.purify_user_ship) do
            speedNumber = speedNumber + math.ceil(zstring.tonumber(v.ship_wisdom))
        end
        -- Label_1p_speed_n:setString(attackerSpeedValue or 0)
        Label_1p_speed_n:setString(speedNumber or 0)
    end
    
    Label_2p_speed_n:setString(defnederSpeedValue)


    -- 跨服矿战
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214 then
        ccui.Helper:seekWidgetByName(root, "Panel_team"):setVisible(true)
        -- debug.print_r(_ED.cross_server_battel_ui_attackers, "跨服矿战ui 1")
        -- debug.print_r(_ED.cross_server_battel_ui_defenders, "跨服矿战ui 2")

        -- 我方
        local attackDown = {}
        for i = 1, 3 do
            local attack = _ED.cross_server_battel_ui_attackers[i]
            if attack and tonumber(attack.ship_template_id) ~= tonumber(attackerId) then
                attack.cross_server_battel_ui_index = i
                table.insert(attackDown, attack)

            else
                ccui.Helper:seekWidgetByName(root, "Label_1p_team_1"):setString(i .. tipStringInfo_union_str[88])
                if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and app.configJson.ReleaseLanguage == "en" then
                    ccui.Helper:seekWidgetByName(root, "Label_1p_team_1"):setString(tipStringInfo_union_str[88] .. i)
            end
        end
        end

        -- debug.print_r(_ED.cross_server_battel_result, "跨服矿战ui 3")


        for i = 1, 2 do
            local attacker = attackDown[i]
            local left = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_hb_left_" .. i)
            left:removeAllChildren(true)
            if left then
                local cell = ShipIconCell:createCell()
                local ships = {}
                ships.ship_template_id = attacker.ship_template_id
                ships.evolution_status = attacker.evolution_status
                ships.Order = attacker.Order
                ships.ship_grade = ""
                ships.StarRating = "0"

                -- print("attacker.cross_server_battel_ui_index: " .. attacker.cross_server_battel_ui_index)

                if tonumber(_ED.cross_server_battel_result[attacker.cross_server_battel_ui_index]) == 0 then
                    cell:init(ships, 12, nil, nil, nil, nil, true)

                    local lostWin = ccui.Helper:seekWidgetByName(root, "Panel_team_head_hb_left_" .. i)
                    lostWin:setVisible(true)
                    lostWin:removeBackGroundImage()
                    lostWin:setVisible(true)
                    lostWin:setBackGroundImage("images/ui/text/SMZB_res/47.png")

                elseif tonumber(_ED.cross_server_battel_result[attacker.cross_server_battel_ui_index]) == 1 then
                    cell:init(ships, 12, nil, nil, nil, nil, nil)

                    local lostWin = ccui.Helper:seekWidgetByName(root, "Panel_team_head_hb_left_" .. i)
                    lostWin:removeBackGroundImage()
                    lostWin:setVisible(true)
                    lostWin:setBackGroundImage("images/ui/text/SMZB_res/46.png")

                else 
                    cell:init(ships, 12, nil, nil, nil, nil, nil)

                    local lostWin = ccui.Helper:seekWidgetByName(root, "Panel_team_head_hb_left_" .. i)
                    lostWin:setVisible(false)
                end

                left:addChild(cell)
            end

            ccui.Helper:seekWidgetByName(root, "Label_1p_team_" .. (i + 1)):setString(attacker.cross_server_battel_ui_index .. tipStringInfo_union_str[88])
            if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and app.configJson.ReleaseLanguage == "en" then
                ccui.Helper:seekWidgetByName(root, "Label_1p_team_" .. (i + 1)):setString(tipStringInfo_union_str[88] .. attacker.cross_server_battel_ui_index)
            end

            -- local lostWin = ccui.Helper:seekWidgetByName(root, "Label_head_hb_left_" .. i)
            -- lostWin:setVisible(false)

        end

        -- 敌方
        local defenderDown = {}
        for i = 1, 3 do
            local defender = _ED.cross_server_battel_ui_defenders[i]
            if defender and tonumber(defender.ship_template_id) ~= tonumber(defenderId) then
                defender.cross_server_battel_ui_index = i
                table.insert(defenderDown, defender)
            else
                ccui.Helper:seekWidgetByName(root, "Label_2p_team_1"):setString(i .. tipStringInfo_union_str[88])
                if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and app.configJson.ReleaseLanguage == "en" then
                    ccui.Helper:seekWidgetByName(root, "Label_2p_team_1"):setString(tipStringInfo_union_str[88] .. i)
            end
        end
        end

        -- debug.print_r(defenderDown, "跨服矿战ui 4")

        for i = 1, 2 do
            local defender = defenderDown[i]
            local right = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_hb_right_" .. i)
            right:removeAllChildren(true)
            if right then
                local cell = ShipIconCell:createCell()
                local ships = {}
                ships.ship_template_id = defender.ship_template_id
                ships.evolution_status = defender.evolution_status
                ships.Order = defender.Order
                ships.ship_grade = ""
                ships.StarRating = "0"
                if tonumber(_ED.cross_server_battel_result[defender.cross_server_battel_ui_index]) == 1 then
                    cell:init(ships, 12, nil, nil, nil, nil, true)

                    local lostWin = ccui.Helper:seekWidgetByName(root, "Panel_team_head_hb_right_" .. i)
                    lostWin:removeBackGroundImage()
                    lostWin:setVisible(true)
                    lostWin:setBackGroundImage("images/ui/text/SMZB_res/47.png")

                elseif tonumber(_ED.cross_server_battel_result[defender.cross_server_battel_ui_index]) == 0 then
                    cell:init(ships, 12, nil, nil, nil, nil, nil)

                    local lostWin = ccui.Helper:seekWidgetByName(root, "Panel_team_head_hb_right_" .. i)
                    lostWin:removeBackGroundImage()
                    lostWin:setVisible(true)
                    lostWin:setBackGroundImage("images/ui/text/SMZB_res/46.png")

                else
                    cell:init(ships, 12, nil, nil, nil, nil, nil)
                    
                    local lostWin = ccui.Helper:seekWidgetByName(root, "Panel_team_head_hb_right_" .. i)
                    lostWin:setVisible(false)
                end
                right:addChild(cell)
            end

            ccui.Helper:seekWidgetByName(root, "Label_2p_team_" .. (i + 1)):setString(defender.cross_server_battel_ui_index .. tipStringInfo_union_str[88])
            if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and app.configJson.ReleaseLanguage == "en" then
                ccui.Helper:seekWidgetByName(root, "Label_2p_team_" .. (i + 1)):setString(tipStringInfo_union_str[88] .. defender.cross_server_battel_ui_index)
            end

            -- local lostWin = ccui.Helper:seekWidgetByName(root, "Panel_team_head_hb_right_" .. i)
            -- lostWin:setVisible(false)

        end

    end


end

function FightUI:updateBattlePropDrop(_drop_count)
    local root = self.roots[1]
    self._prop_drop_count = self._prop_drop_count + tonumber("".._drop_count)
    local cardDropCount = ccui.Helper:seekWidgetByName(root,"Label_10866")
    cardDropCount:setString(""..self._prop_drop_count)
end

function FightUI:updateBattleCardDrop(_drop_count)
    local root = self.roots[1]
    self._card_drop_count = self._card_drop_count + tonumber("".._drop_count)
    local cardDropCount = ccui.Helper:seekWidgetByName(root,"Label_10867")
    cardDropCount:setString(""..self._card_drop_count)
end

function FightUI:updateBattleEquipDrop(_drop_count)
    local root = self.roots[1]
    self._equip_drop_count = self._equip_drop_count + tonumber("".._drop_count)
    local cardDropCount = ccui.Helper:seekWidgetByName(root,"Label_10868")
    cardDropCount:setString(""..self._equip_drop_count)
end

function FightUI:updateAutoFightTime( params )
    local root = self.roots[1]
    local time = math.floor(params.time)
    local isShowAuto = params.isShowAuto
    local Panel_zidong_ing = ccui.Helper:seekWidgetByName(root,"Panel_zidong_ing")
    Panel_zidong_ing:setVisible(false)
    local Image_shoudong_ing = ccui.Helper:seekWidgetByName(root,"Image_shoudong_ing")
    Image_shoudong_ing:setVisible(false)
    local timeCount = ccui.Helper:seekWidgetByName(root,"Label_daojishi_ing")
    timeCount:setVisible(true)
    timeCount:setString(""..math.floor(time))
    if time <= 0 then
        timeCount:setVisible(false)
        Image_shoudong_ing:setVisible(true)
        if isShowAuto then
            Panel_zidong_ing:setVisible(true)    
        end
    end
end

function FightUI:showFightPause()
    app.load("client.battle.fight.BattlePause")
    state_machine.excute("battle_pause_window_open", 0, _ED.battleData.battle_init_type)
end

function FightUI:startShakeUI(params)
    local action = self.actions[1]
    action:play("battle_ui_doudong", false)
end

function FightUI:showKeepBattle(visible)
    local root = self.roots[1]
    local skipFightButton = ccui.Helper:seekWidgetByName(root, "Button_10871")
    if true == visible then
        -- skipFightButton:setVisible(self._canSkipFighting)
        skipFightButton:setVisible(visible)
    else
        skipFightButton:setVisible(visible)
    end
end

function FightUI:playAttackIntitateEffect()
    local effect_xianshou = draw.createEffect("effect_xianshou", "images/ui/effice/effect_xianshou/effect_xianshou.ExportJson", self, 1, 0, 1)
    local theight = fwin._height - app.baseOffsetY
    if zstring.tonumber(_ED.battleData.attacker_priority) >= zstring.tonumber(_ED.battleData.defender_priority) then
        effect_xianshou:setPositionY(theight / 3)
    else
        effect_xianshou:setPositionY(theight * 2 / 3)
    end
end

function FightUI:drawHeroListView(padButton, camp)
    local offsetY = padButton._offsetY or 0
    local ltime = 0.5
    local parent = padButton:getParent()
    local padSize = parent:getContentSize()
    padButton:stopAllActions()
    if nil ~= padButton._cells then
        for i, v in pairs(padButton._cells) do
            v:stopAllActions()
        end
    end

    if nil == padButton._cells then
        padButton._is_open = true
        padButton._cells = padButton._cells or {}
        app.load("client.red_alert_time.cells.battle.battle_leader_icon_cell")
        local theight = 0
        for i = 1, 6 do
            local v = nil
            if 0 == camp then
                v = _ED.battleData._heros["" .. i]
            else
                v = _ED.battleData._armys[1]._data["" .. i]
            end
            v = v or {_general_mould_id = 0}
            local cell = state_machine.excute("battle_leader_icon_cell_create", 0, {i, v._general_mould_id})
            parent:addChild(cell)
            if 0 == camp then
                cell:setPosition(cc.p((padSize.width - cell._size.width) / 2, -1 * cell._size.height))
            else
                cell:setPosition(cc.p((padSize.width - cell._size.width) / 2, 0))
            end
            theight = theight + cell._size.height
            cell._index = i

            table.insert(padButton._cells, cell)
        end
        if 0 == camp then
            offsetY = theight
        else
            offsetY = -1 * theight
        end
        padButton._offsetY = offsetY
    else
        if padButton._is_open == true then
            padButton._is_open = false
            offsetY = 0
        else
            padButton._is_open = true
        end
    end

    if padButton._is_open == false then
        for i, v in pairs(padButton._cells) do
            v:setVisible(true)
            if 0 == camp then
                v:runAction(cc.MoveTo:create(ltime, cc.p((padSize.width - v._size.width) / 2, 0 - v._size.height)))
            else
                v:runAction(cc.MoveTo:create(ltime, cc.p((padSize.width - v._size.width) / 2, 0)))
            end
        end
    else
        for i, v in pairs(padButton._cells) do
            v:setVisible(true)
            if 0 == camp then
                v:runAction(cc.MoveTo:create(ltime, cc.p((padSize.width - v._size.width) / 2, (6 - v._index) * v._size.height)))
            else
                v:runAction(cc.MoveTo:create(ltime, cc.p((padSize.width - v._size.width) / 2, (v._index - 7) * v._size.height)))
            end
        end
    end
    
    if __lua_project_id == __lua_project_pacific_rim then
        offsetY = 0
    end

    padButton._camp = camp
    padButton:runAction(cc.Sequence:create(cc.MoveTo:create(ltime, 
        cc.p(padButton._start_pos.x, padButton._start_pos.y + offsetY)), 
        cc.CallFunc:create(function ( sender )
            for i, v in pairs(sender._cells) do
                v:setVisible(sender._is_open)
            end
            if 0 == sender._camp then
                if true == sender._is_open then
                    sender:setScaleY(-1)
                else
                    sender:setScaleY(1)
                end
            else
                if true == sender._is_open then
                    sender:setScaleY(-1)
                else
                    sender:setScaleY(1)
                end
            end
        end)))
end

function FightUI:openAttackerHeroList(padButton)
    self:drawHeroListView(padButton, 0)
end

function FightUI:openDefenderHeroList(padButton)
    self:drawHeroListView(padButton, 1)
end

function FightUI:onUpdate(dt)
    dt = dt / _fight_time_scale[__fight_recorder_action_time_speed_index]

    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_53 
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_7 
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218 
        then
        if self.jumptTimes > 0 and self.isJump == true then
            self.jumptTimes = self.jumptTimes - dt
            if self.jumptTimes <= 0 then
                self.isJump = false
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_djs"):setString("")
                ccui.Helper:seekWidgetByName(self.roots[1], "Button_10871"):setBright(true)
                ccui.Helper:seekWidgetByName(self.roots[1], "Button_10871"):setTouchEnabled(true)
            else
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_djs"):setString(math.floor(self.jumptTimes))
            end
        end
    end
end

function FightUI:onEnterTransitionFinish()
    local csbBattleUI = csb.createNode("battle/battle_UI.csb")
    local root = csbBattleUI:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbBattleUI)

    local action = csb.createTimeline("battle/battle_UI.csb")
    table.insert(self.actions, action)
    csbBattleUI:runAction(action)

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
        then
        if _ED.attackData.roundData[_ED.battleData._currentBattleIndex] == nil then
             self:updateDrawRoundCount("0/" .. _ED.attackData.totalRoundCount)
        else
            self:updateDrawRoundCount(_ED.attackData.roundData[_ED.battleData._currentBattleIndex].currentRound .. "/" .. _ED.attackData.totalRoundCount)
        end
       
        
        -- local Panel_head_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_head_icon_1")
        -- Panel_head_icon_1:setBackGroundImage(string.format("images/ui/props/props_%s.png", _ED.battleData.attacker_head_pic))
        -- Panel_head_icon_1:removeBackGroundImage()
        --先屏蔽
        -- local cell = PlayerHeadIcon:createCell()
        -- local avatar_info = {}
        -- avatar_info.object = _ED.battleData.attacker_head_pic
        -- avatar_info.vip = 1
        -- avatar_info._type = 0
        -- cell:init(avatar_info)
        -- Panel_head_icon_1:addChild(cell)
        local Text_player_me_name = ccui.Helper:seekWidgetByName(root,"Text_player_me_name")
        Text_player_me_name:setString(_ED.battleData.attacker_name)
        local Text_successively_me_n = ccui.Helper:seekWidgetByName(root,"Text_successively_me_n")
        Text_successively_me_n:setString(_ED.battleData.attacker_priority)

        -- local Panel_head_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_head_icon_2")
        -- Panel_head_icon_2:setBackGroundImage(string.format("images/ui/props/props_%s.png", _ED.battleData.defender_head_pic))
        local fontName = config_res.font.font_name
        if isContentZh_TW() == true then
            local isGetLocalNpcName = true
            local pvpBattleType = {
                11,24,201,205,206,207,208
            }
            for i = 1 , #pvpBattleType do 
                if _ED.battleData.battle_init_type == pvpBattleType[i] then
                    isGetLocalNpcName = false
                end
            end
            if isGetLocalNpcName == false then
                fontName = ""
            end
        end
        local Text_player_me_enemy = ccui.Helper:seekWidgetByName(root,"Text_player_me_enemy")
        local fontSize = Text_player_me_enemy:getFontSize()
        Text_player_me_enemy:setString(_ED.battleData.defender_name)
        Text_player_me_enemy:setFontName(fontName)
        local Text_successively_enemy_n = ccui.Helper:seekWidgetByName(root,"Text_successively_enemy_n")
        Text_successively_enemy_n:setString(_ED.battleData.defender_priority)
        if isContentZh_TW() == true then
            Text_player_me_name:setFontName("")
            Text_player_me_name:setFontSize(fontSize)
            Text_player_me_enemy:setFontSize(fontSize)
        end

        -- 我方头像展开按钮
        local attackerHeroListButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_leader_1"), nil, 
        {
            terminal_name = "fight_ui_open_attacker_hero_list",
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, nil, 0)
        if nil ~= attackerHeroListButton then
            attackerHeroListButton._start_pos = cc.p(attackerHeroListButton:getPosition())
            attackerHeroListButton._is_open = false
        end

        -- 敌方头像展开按钮
        local defenderHeroListButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_leader_2"), nil, 
        {
            terminal_name = "fight_ui_open_defender_hero_list",
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, nil, 0)
        if nil ~= defenderHeroListButton then
            defenderHeroListButton._start_pos = cc.p(defenderHeroListButton:getPosition())
            defenderHeroListButton._is_open = false
        end

        local skipFightButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10871"), nil, 
        {
            terminal_name = "fight_ui_skeep_fighting",
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, nil, 0)
        -- skipFightButton:setVisible(self._canSkipFighting)

         action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "window_open_over" then
                state_machine.excute("fight_ui_play_attack_intitate_effect", 0, 0)
            end
        end)
        action:play("window_open", false)
        
    else
        self:updateDrawRoundCount("0/20")
        self:updateBattlePropDrop(0)
        self:updateBattleCardDrop(0)
        self:updateBattleEquipDrop(0)

        if __lua_project_id == __lua_project_gragon_tiger_gate 
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            or __lua_project_id == __lua_project_red_alert 
            then
            state_machine.lock("fight_skeep_fighting")
        end

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 
                --or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_7
                then
                local csbMaoxianBattleUI = csb.createNode("campaign/maoxian_battle_ui.csb")
                local root = csbMaoxianBattleUI:getChildByName("root")
                table.insert(self.roots, root)
                self:addChild(csbMaoxianBattleUI)
            end
            if _ED._fightModule ~= nil then
                state_machine.excute("fight_ui_update_battle_round_count", 0, "0/".._ED._fightModule.totalRound)
            else
                state_machine.excute("fight_ui_update_battle_round_count", 0, "0/".._ED.attackData.totalRoundCount)
            end
        end
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            ccui.Helper:seekWidgetByName(root, "Button_10871"):setBright(true)
            ccui.Helper:seekWidgetByName(root, "Button_10871"):setTouchEnabled(true)
            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 
                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_7
                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218
                then
                local jumptTimes = zstring.split(dms.string(dms["arena_config"], 15, arena_config.param),",")
                if tonumber(_ED.vip_grade) < tonumber(jumptTimes[1]) then
                    if self.jumptTimes == 0 then
                        self.jumptTimes = tonumber(jumptTimes[2])
                        self.isJump = true
                        ccui.Helper:seekWidgetByName(self.roots[1],"Text_djs"):setString(self.jumptTimes)
                        ccui.Helper:seekWidgetByName(root, "Button_10871"):setBright(false)
                        ccui.Helper:seekWidgetByName(root, "Button_10871"):setTouchEnabled(false)
                    end
                end
            end
            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_53 then
                local jumptTimes = dms.int(dms["arena_config"], 8, arena_config.param)
                if tonumber(_ED.user_info.user_grade) < dms.int(dms["fun_open_condition"],165, fun_open_condition.level) then
                    if self.jumptTimes == 0 then
                        self.jumptTimes = jumptTimes
                        self.isJump = true
                        ccui.Helper:seekWidgetByName(self.roots[1],"Text_djs"):setString(self.jumptTimes)
                        ccui.Helper:seekWidgetByName(root, "Button_10871"):setBright(false)
                        ccui.Helper:seekWidgetByName(root, "Button_10871"):setTouchEnabled(false)
                    end
                end
            end 
        end
        local skipFightButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10871"), nil, 
        {
            terminal_name = "fight_ui_skeep_fighting",
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, nil, 0)
        skipFightButton:setVisible(self._canSkipFighting)

        if __lua_project_id == __lua_project_gragon_tiger_gate 
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            or __lua_project_id == __lua_project_red_alert 
            then
            if self._fight_type ~= _enum_fight_type._fight_type_10 
                and self._fight_type ~= _enum_fight_type._fight_type_11 
                and self._fight_type ~= _enum_fight_type._fight_type_53 
                and self._fight_type ~= _enum_fight_type._fight_type_102 
                and self._fight_type ~= _enum_fight_type._fight_type_104 
                and self._fight_type ~= _enum_fight_type._fight_type_211
                and self._fight_type ~= _enum_fight_type._fight_type_213
                and self._fight_type ~= _enum_fight_type._fight_type_214
                and self._fight_type ~= _enum_fight_type._fight_type_218
                and self._fight_type ~= _enum_fight_type._fight_type_219
                and self._fight_type ~= _enum_fight_type._fight_type_220
                then
                if _ED._battle_eve_auto_fight == true then
                    local Panel_jiaoxue = ccui.Helper:seekWidgetByName(root,"Panel_jiaoxue")
                    Panel_jiaoxue:setVisible(true)

                    local Button_jiaoxue_tg = ccui.Helper:seekWidgetByName(root,"Button_jiaoxue_tg")
                    fwin:addTouchEventListener(Button_jiaoxue_tg, nil, 
                    {
                        terminal_name = "fight_ui_skeep_fighting_copy",
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }, nil, 0)
                           
                end
            end
        end
        local myLv = zstring.tonumber(_ED.user_info.user_grade)
        
        
        local is2002 = false
        if __lua_project_id == __lua_project_warship_girl_a 
            or __lua_project_id == __lua_project_warship_girl_b
            or __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_red_alert_time 
            or __lua_project_id == __lua_project_pacific_rim  
            or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_yugioh 
            or __lua_project_id == __lua_project_koone 
            then
            if dev_version >= 2002 then
                is2002 = true
            end
        end
            
        -- 读取可用加速值
        -- 1. 判定有没有存储加速值
        -- 2. 判定是否在游戏阶段手动修改了
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon 
            or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            if zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed) > 0 then
                __fight_recorder_action_time_speed = zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed)
            else
                __fight_recorder_action_time_speed = _enum_action_time_speed[1]
                _ED.init_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
            end
        else
            if true == is2002 then
                
                if myLv >= 5 then
                    if zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed) > 0 then
                        -- 如果能读到数据,则使用读取数据
                        __fight_recorder_action_time_speed = zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed)
                    else
                        -- 没有读取到数据设置的,就使用默认设置
                        if nil == _ED.init_fight_recorder_action_time_speed then
                            if __fight_recorder_action_time_speed > _enum_action_time_speed[2] then
                                __fight_recorder_action_time_speed = _enum_action_time_speed[2]
                                
                                _ED.init_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
                            end
                        end
                    end
                end
            end

            if __lua_project_id == __lua_project_gragon_tiger_gate 
                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon 
                or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                or __lua_project_id == __lua_project_red_alert 
                then
            --print("enter-------------------------------------------------")
                if myLv >= 5 then
                    if zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed) > 0 then
                        -- 如果能读到数据,则使用读取数据
                        __fight_recorder_action_time_speed = zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed)
                    else
                        if nil == _ED.init_fight_recorder_action_time_speed then
                            __fight_recorder_action_time_speed = _enum_action_time_speed[2]         
                            _ED.init_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
                            -- if myLv >= 25 then
                            --  __fight_recorder_action_time_speed = _enum_action_time_speed[3]         
                            --  _ED.init_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
                            -- end
                        end
                    end
                end
            end
        end
        
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon 
            or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            local x2SpeedClosed = funOpenDrawTip(36, false)

            local Image_x1_lock = ccui.Helper:seekWidgetByName(root, "Image_x1_lock")
            local Image_x2_lock = ccui.Helper:seekWidgetByName(root, "Image_x2_lock")

            if nil ~= Image_x1_lock then
                Image_x1_lock:setVisible(x2SpeedClosed == true)
            end

            if nil ~= Image_x2_lock then
                Image_x2_lock:setVisible(false)
            end
        end

        -- Fury (V2): la maqueta solo trae Button_x1..x3. Los x4-x6 se clonan del
        -- x3 (misma posicion) con su arte, images/ui/battle/ZD_<n>Xb.png.
        local threeTimeSpeedButton = ccui.Helper:seekWidgetByName(root, "Button_x3")
        if nil ~= threeTimeSpeedButton then
            for n = 4, #_enum_action_time_speed do
                if nil == ccui.Helper:seekWidgetByName(root, "Button_x" .. n) then
                    local image = string.format("images/ui/battle/ZD_%dXb.png", n)
                    local button = threeTimeSpeedButton:clone()
                    button:setName("Button_x" .. n)
                    button:loadTextures(image, image, image)
                    button:setVisible(false)
                    threeTimeSpeedButton:getParent():addChild(button)
                end
            end
        end

        local oneTimeSpeedButton = ccui.Helper:seekWidgetByName(root, string.format("Button_x%d", 1))
        if nil ~= oneTimeSpeedButton then
            oneTimeSpeedButton:setVisible(true)
            cc.Director:getInstance():getScheduler():setTimeScale(_fight_time_scale[1])
            state_machine.excute("fight_qte_controller_change_time_speed", 0, 0)
        end

        local index = 1
        for i, v in pairs(_enum_action_time_speed) do
            local timeSpeedButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, string.format("Button_x%d", index)), nil, 
            {
                terminal_name = "fight_ui_change_time_speed",
                terminal_state = 0, 
                _actionTimeSpeedIndex = index,
                isPressedActionEnabled = true
            }, nil, 0)
            
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon 
                or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then
                if timeSpeedButton ~= nil then
                    -- Fury (V2): una marcha VIP guardada no vale si ESTA cuenta no llega
                    if __fight_recorder_action_time_speed == v and fury_game_speed.fight_index_allowed(i) then
                        if nil ~= oneTimeSpeedButton then
                            oneTimeSpeedButton:setVisible(false)
                        end
                        timeSpeedButton:setVisible(true)
                        state_machine.excute("fight_role_controller_update_role_animation_speed", 0, __fight_recorder_action_time_speed)

                        __fight_recorder_action_time_speed_index = i
                        __fight_recorder_action_time_speed = _enum_action_time_speed[1]
                        -- _ED.user_set_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
                        if nil ~= _fight_time_scale then
                            cc.Director:getInstance():getScheduler():setTimeScale(_fight_time_scale[__fight_recorder_action_time_speed_index])
                        else
                            cc.Director:getInstance():getScheduler():setTimeScale(1.0 * __fight_recorder_action_time_speed_index)
                        end
                        state_machine.excute("fight_qte_controller_change_time_speed", 0, 0)
                    else
                        -- timeSpeedButton:setVisible(false)
                    end
                end
            else
                if timeSpeedButton ~= nil and __fight_recorder_action_time_speed == v then
                
                    if true == is2002 then
                        if myLv >= 5 then 
                            timeSpeedButton:setVisible(true)
                        end
                    else
                        timeSpeedButton:setVisible(true)
                    end
                end
            end
            index = index + 1
        end

        self._isAuto = self:getIsAutoFight()

        if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon 
        or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
            local Panel_zidong_ing = ccui.Helper:seekWidgetByName(root, "Panel_zidong_ing")
            self:changeBattleHetiState(false)
            -- ccui.Helper:seekWidgetByName(root, "Button_zanting"):setVisible(true)
            local Button_zanting = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zanting"), nil, 
            {
                terminal_name = "fight_ui_stop_fight",
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, nil, 0)

            if nil ~= Button_zanting then
                if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_7 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218 then
                    Button_zanting:setVisible(false)
                else 
                    if true == funOpenDrawTip(160, false) then
                        Button_zanting:setVisible(false)
                    end
                end
            end

            local autoBtn = ccui.Helper:seekWidgetByName(root, "Button_zidong")
            local autoBtn2 = ccui.Helper:seekWidgetByName(root, "Button_zidong_2")
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon 
                or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then
                -- if self._isPvEType == true then
                --     autoBtn:setVisible(true)
                --     autoBtn2:setVisible(false)
                --     -- Panel_zidong_ing:setVisible(self._isAuto)
                -- else
                    if self._isAuto then
                        autoBtn:setVisible(false)
                        autoBtn2:setVisible(true)
                    else
                        autoBtn:setVisible(true)
                        autoBtn2:setVisible(false)
                    end
                -- end
            else
                if self._isPvEType == true then
                    autoBtn:setVisible(true)
                    autoBtn:setHighlighted(self._isAuto)
                    Panel_zidong_ing:setVisible(self._isAuto)
                else
                    autoBtn:setVisible(false)
                end
            end
            -- print("---------------",_ED.user_info.user_grade,dms.string(dms["fun_open_condition"],53, fun_open_condition.level))
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then
            else
                local userlevel= tonumber(_ED.user_info.user_grade) 
                local openautolevel= tonumber(dms.string(dms["fun_open_condition"],53, fun_open_condition.level)) 
                if userlevel <= openautolevel then
                    autoBtn:setVisible(false)
                end
            end

            local zdfopen = funOpenDrawTip(161, false)

            if _ED._battle_eve_auto_fight == true or true == zdfopen then
                if true == zdfopen then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon 
                        or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                        if _ED._battle_eve_auto_fight == true then
                            autoBtn:setVisible(false)
                            autoBtn2:setVisible(true)
                        else
                            autoBtn:setVisible(true)
                            autoBtn2:setVisible(false)
                            self.isAuto = _ED._battle_eve_auto_fight
                        end
                    else
                        if _ED._battle_eve_auto_fight == true then
                            autoBtn:setTouchEnabled(false)
                            autoBtn:setHighlighted(true)
                        end
                    end
                    Panel_zidong_ing:setVisible(true)

                else
                    self.isAuto = false
                    autoBtn:setVisible(true)
                    autoBtn:setHighlighted(self._isAuto)
                    autoBtn2:setVisible(false)
                end
                local Image_zidong_suo = ccui.Helper:seekWidgetByName(root,"Image_zidong_lock")
                Image_zidong_suo:setVisible(true)
            end

            if self._isPvEType == true then
                
            else
                zdfopen = false
                autoBtn:setVisible(false)
                autoBtn2:setVisible(true)
                Panel_zidong_ing:setVisible(true)

                autoBtn2:setTouchEnabled(false)
                autoBtn2:setHighlighted(true)

                local Image_zidong_suo = ccui.Helper:seekWidgetByName(autoBtn2,"Image_zidong_lock_2")
                Image_zidong_suo:setVisible(true)
            end

            fwin:addTouchEventListener(autoBtn, nil, 
            {
                terminal_name = "fight_ui_begin_auto_fight",
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, nil, 0)

            fwin:addTouchEventListener(autoBtn2, nil, 
            {
                terminal_name = "fight_ui_begin_auto_fight",
                terminal_state = 2, 
                isPressedActionEnabled = true
            }, nil, 0)

            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hetiji_1"), nil, 
            {
                terminal_name = "fight_ui_excute_heti_skill",
                terminal_state = 0, 
                isPressedActionEnabled = true,
                clickState = 1
            }, nil, 0)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hetiji_2"), nil, 
            {
                terminal_name = "fight_ui_excute_heti_skill",
                terminal_state = 0, 
                isPressedActionEnabled = true,
                clickState = 2
            }, nil, 0)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_htj_tg"), nil, 
            {
                terminal_name = "fight_ui_skeep_heti_battle",
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, nil, 0)

            ccui.Helper:seekWidgetByName(root, "Panel_hetiji_1"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Panel_hetiji_2"):setVisible(false)

            -- self:updateDrawHpProgress({0, 100, 100})
            -- self:updateDrawHpProgress({1, 100, 100})
            state_machine.excute("fight_role_controller_update_draw_ui_window", 0, 0)

            if missionIsOver() == false then
                fwin:resetTouchLock()
            end
        end

        if __lua_project_id == __lua_project_yugioh then
            local LoadingBar_magic = ccui.Helper:seekWidgetByName(root, "LoadingBar_magic")
            LoadingBar_magic:setPercent(0)
        end
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_53 then
                if tonumber(_ED.user_info.user_grade) < dms.int(dms["fun_open_condition"],165, fun_open_condition.level) then
                    ccui.Helper:seekWidgetByName(root, "Button_10871"):setVisible(false)
                end
            end
            __fight_recorder_action_time_speed = 1.0
        end

        self:refreshAnimalSkillInfoUI()
    end

    self:adjustSkipButtonPos()
    -- NinjaAscension arena (live engine): players' names, whole-account speed,
    -- automatic only.
    if _ED.nr_arena_fight_rank then
        local function nrSet(name, text)
            local w = ccui.Helper:seekWidgetByName(root, name)
            if w then w:setString(tostring(text)) end
        end
        nrSet("Label_1p_name", _ED.user_info.user_name or "")
        nrSet("Label_2p_name", _ED.nr_arena_defender_name or "")
        nrSet("Label_1p_speed_n", math.floor(tonumber(_ED.user_info.speed_sum) or 0))
        nrSet("Label_2p_speed_n", math.floor(tonumber(_ED.nr_arena_defender_speed) or 0))
        for _, name in ipairs({"Button_zidong", "Button_zidong_2"}) do
            local b = ccui.Helper:seekWidgetByName(root, name)
            if b then b:setVisible(false); b:setTouchEnabled(false) end
        end
        -- Portraits: the first ninja of each formation (same images as PVE).
        local function firstHead(list, key)
            local best, pos = nil, 1000
            for _, v in pairs(list or {}) do
                local p = tonumber(v._pos or v.coordinate) or 1000
                if p < pos then best, pos = v[key], p end
            end
            return best
        end
        local myHead = firstHead(_ED.battleData and _ED.battleData._heros, "_head")
        local cache = _ED.user_info.battleCache
        local enemyHead = firstHead(cache and cache.byAttackerObjectsList and cache.byAttackerObjectsList[1], "picIndex")
        local h1 = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_1")
        local h2 = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_2")
        if h1 and myHead then h1:setBackGroundImage("images/ui/pve_sn/props_" .. myHead .. ".png") end
        if h2 and enemyHead then h2:setBackGroundImage("images/ui/pve_sn/props_" .. enemyHead .. ".png") end
        self._isAuto = true
        state_machine.excute("fight_role_controller_change_to_auto_fight", 0, true)
    end
end

-- 刷新右下角神兽信息栏
function FightUI:refreshAnimalSkillInfoUI()
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.MythicalAnimals)
    if fun_is_open == true then
        local root = self.roots[1]

        if root == nil then
            return
        end
        
        local isShowPanel = self:isShowAnimalPanel()

        local Panel_shenshou_effect = ccui.Helper:seekWidgetByName(root, "Panel_shenshou_effect")
        Panel_shenshou_effect:setVisible(false)
        Panel_shenshou_effect:removeAllChildren(true)
        if isShowPanel == true then
            -- 神兽怒气值光效
            local jsonFile = "images/ui/effice/effect_shenshou_fire/effect_shenshou_fire.json"
            local atlasFile = "images/ui/effice/effect_shenshou_fire/effect_shenshou_fire.atlas"

            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            sp.initArmature(animation, true)
            animation:setAnimation(0, "animation", true)
            animation:setPosition(Panel_shenshou_effect:getContentSize().width / 2, Panel_shenshou_effect:getContentSize().height / 2)
            Panel_shenshou_effect:addChild(animation)

            -- self:updateAnimalSkillState()
            -- self:updateAnimalAngerProgress()
        end
        self:updateAnimalUIShowState(isShowPanel)
    end
end

function FightUI:getIsAutoFight( ... )
    local isAuto = false
    if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
        isAuto = true
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
        if tonumber(_ED.user_info.user_grade) < 5 then
            return isAuto
        end
    end
    local result = cc.UserDefault:getInstance():getStringForKey(getKey("m_isAutoFight"))
    if result == nil then
        isAuto = false
        if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
            isAuto = true
    end
    end
    if tonumber(result) == 0 then
        isAuto = false
        if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
            isAuto = true
        end
    elseif tonumber(result) == 1 then
        isAuto = true
    end
    return isAuto
end

-- 是否显示神兽UI
function FightUI:isShowAnimalPanel()
    local heroAnimals = _ED.battleData._hero_animals
    return table.nums(heroAnimals) > 0
end

-- 刷新神兽技能状态
function FightUI:updateAnimalUIShowState(isShow)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Panel_shenshou"):setVisible(isShow)
end

-- 刷新技能状态
function FightUI:updateAnimalSkillState(animalInfoData)
    local root = self.roots[1]
    local skillList = {}

    for i = 1, 3 do
        table.insert(skillList, {
            Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill_"..i), 
            Text_skill_CD = ccui.Helper:seekWidgetByName(root, "Text_skill_CD_"..i),
            Panel_shenshou_effect = ccui.Helper:seekWidgetByName(root, "Panel_shenshou_effect_"..i)
        })
    end

    -- 可攻击的神兽下标
    local attackAnimalIndex = -1
    -- 神兽信息
    local attackAnimalList = {}

    -- pvp
    if animalInfoData then
        attackAnimalIndex = animalInfoData.attackAnimalIndex
        attackAnimalList = animalInfoData.attackAnimalList
    else
        attackAnimalIndex = zstring.tonumber(_ED.canAttackAnimalIndex)
    end
    local canBlink = false
    local animalSkillInfo = {}
    for i, v in ipairs(skillList) do
        v.Panel_skill:removeAllChildren(true)
        v.Text_skill_CD:setVisible(false)

        local index = i + 6
        local info = _ED.battleData._hero_animals[""..index]
        if info ~= nil then
            local animalCdRound = 0

            if animalInfoData then
                for _, m in ipairs(attackAnimalList) do
                    if tonumber(info._mouldId) == m.mouldId then
                        animalCdRound = m.animalCdRound
                        break
                    end
                end

            else
                for _, data in pairs(_ED.animalAttackCdRoundMap) do
                    if tonumber(data.coordinate) == index then
                        animalCdRound = tonumber(data.animalCdRound)
                        break
                    end
                end
            end
            
            
            local canAttack = attackAnimalIndex == index

            -- print("index = ", index, " canAttack = ", canAttack, " animalCdRound = ", animalCdRound)

            v.Text_skill_CD:setVisible(animalCdRound > 0)
            v.Text_skill_CD:setString(animalCdRound)

            local skillTalentMouldId = info._skillTalentMouldId
            local pic_index = dms.int(dms["talent_mould"], skillTalentMouldId, talent_mould.new_skill_pic)
            local skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
            skill_icon:setPosition(cc.p(v.Panel_skill:getContentSize().width/2, v.Panel_skill:getContentSize().height/2))

            if canAttack == true then
                display:ungray(skill_icon)
            else
                display:gray(skill_icon)
            end
            v.Panel_skill:addChild(skill_icon)
            v.Panel_shenshou_effect:removeAllChildren(true)
            if canAttack == true then
                canBlink = true
                local jsonFile = "images/ui/effice/effect_shenshou_skill/effect_shenshou_skill.json"
                local atlasFile = "images/ui/effice/effect_shenshou_skill/effect_shenshou_skill.atlas"

                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                sp.initArmature(animation, true)
                animation:setAnimation(0, "animation", true)
                animation:setPosition(v.Panel_shenshou_effect:getContentSize().width / 2, v.Panel_shenshou_effect:getContentSize().height / 2)
                v.Panel_shenshou_effect:addChild(animation)
            end
        end
    end
    -- 刷新神兽怒气动画
    ccui.Helper:seekWidgetByName(root, "Panel_shenshou_effect"):setVisible(canBlink)
end

-- 刷新神兽怒气值进度
function FightUI:updateAnimalAngerProgress(animalInfoData)
    local root = self.roots[1]

    local maxProgress = dms.float(dms["play_config"], 220, play_config.param)
    local progress = animalInfoData and animalInfoData.attackAnimalAnger or _ED.animalAttackAngerValue

    -- debug.print_r(animalInfoData, "animalInfoData")
    -- print("_ED.animalAttackAngerValue", _ED.animalAttackAngerValue)

    progress = progress == nil and 0 or progress
    progress = progress > maxProgress and maxProgress or progress

    -- print("更新怒气槽 progress / maxProgress = ", progress, maxProgress)

    ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent(progress / maxProgress * 100)
    ccui.Helper:seekWidgetByName(root, "Text_fire_1"):setString(progress)
end

-- 判断是否是指定的iphone机型（如果是该机型会对战斗中的跳过按钮进行偏移）
function FightUI:judgeSpecialIphoneDevice()
    local result = false

    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
        local frameSizeListStr = dms.string(dms["play_config"], 289, play_config.param)
        if frameSizeListStr ~= nil then
            local frameSizeList = zstring.split(frameSizeListStr, "|")
            local winsize = cc.Director:getInstance():getWinSize()

            for _, v in pairs(frameSizeList) do
                local frameSize = zstring.split(v, ",", tonumber)
                if winsize.width == frameSize[1] and winsize.height == frameSize[2] then
                    result = true
                    break
                end
            end
        end
    end

    return result
end

-- 调整跳过按钮的位置
function FightUI:adjustSkipButtonPos()
    if self:judgeSpecialIphoneDevice() == false then
        return
    end

    -- 只有龙珠需要修改跳过按钮的位置
    if __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 then
        return
    end

    local root = self.roots[1]
    local skipFightButton = ccui.Helper:seekWidgetByName(root, "Button_10871")

    local offestInfo = zstring.split(dms.string(dms["play_config"], 290, play_config.param), ",", tonumber)
    local winsize = cc.Director:getInstance():getWinSize()

    -- print("offestInfo = ", offestInfo[1], offestInfo[2])
    -- print("winsize = ", winsize.width, winsize.height)
    -- print("app.scaleFactor = ", app.scaleFactor)

    local worldPos = cc.p((0 + offestInfo[1] * app.scaleFactor), (winsize.height + offestInfo[2] * app.scaleFactor))
    -- debug.print_r(worldPos, "worldPos")

    buttonPos = skipFightButton:getParent():convertToNodeSpaceAR(worldPos)
    -- debug.print_r(buttonPos, "buttonPos")

    skipFightButton:setPosition(buttonPos)
end

function FightUI:onExit()
    state_machine.remove("fight_ui_update_battle_round_count")
    state_machine.remove("fight_ui_update_battle_count")
    state_machine.remove("fight_ui_update_battle_player_info")
    state_machine.remove("fight_ui_update_battle_card_drop")
    state_machine.remove("fight_ui_visible")
    state_machine.remove("fight_ui_skeep_fighting")
    state_machine.remove("fight_ui_change_time_speed")
    state_machine.remove("fight_ui_change_time_speed_set")
    state_machine.remove("fight_ui_drop_moving")
    state_machine.remove("fight_ui_update_hp_progress")
    state_machine.remove("fight_ui_update_auto_fight_time")
    state_machine.remove("fight_ui_begin_auto_fight")
    state_machine.remove("fight_ui_stop_fight")
    state_machine.remove("fight_ui_update_fight_auto_state")
    state_machine.remove("fight_ui_shake_ui")
    state_machine.remove("fight_ui_update_fight_get_auto_state")
    state_machine.remove("fight_ui_init_heti_skill_state")
    state_machine.remove("fight_ui_update_heti_skill_state")
    state_machine.remove("fight_ui_excute_heti_skill")
    state_machine.remove("fight_ui_add_last_kill_effect")
    state_machine.remove("fight_ui_change_battle_heti_state")
    state_machine.remove("fight_ui_skeep_heti_battle")
    state_machine.remove("fight_ui_skeep_animation_visible_false")
    state_machine.remove("fight_ui_skeep_fighting_copy")
    if __lua_project_id == __lua_project_yugioh then
        state_machine.remove("fight_ui_update_card_progress")
    end
    state_machine.remove("fight_ui_show_keep_battle")
    state_machine.remove("fight_ui_play_attack_intitate_effect")
    state_machine.remove("fight_ui_open_attacker_hero_list")
    state_machine.remove("fight_ui_open_defender_hero_list")
    state_machine.remove("fight_ui_update_boss_drop_silver_count")
    state_machine.remove("fight_ui_update_boss_drop_prop_count")
    state_machine.remove("fight_ui_resume_action_nodes")
    state_machine.remove("fight_ui_mission_fight_controler")
    state_machine.remove("fight_ui_update_animal_skill_state")
    state_machine.remove("fight_ui_update_animal_anger_progress")
    state_machine.remove("fight_ui_update_animal_skill_info_ui")
end
