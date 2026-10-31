local is2004 = false
if __lua_project_id == __lua_project_gragon_tiger_gate 
    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
    or __lua_project_id == __lua_project_l_naruto 
    or __lua_project_id == __lua_project_red_alert 
    or __lua_project_id == __lua_project_legendary_game 
    then
    if dev_version >= 2004 then
        is2004 = true
    end
end

FightRoleController = class("FightRoleControllerClass", Window)
FightRoleController.__lock_battle = false
FightRoleController.__select_target_effect_visible = true
FightRoleController.__battle_formation_info = {}

local fight_role_controller_battle_formation_info_terminal = {
    _name = "fight_role_controller_battle_formation_info",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- e: state_machine.excute("fight_role_controller_visible_formation",0,{1,"2",1})
        -- e: state_machine.excute("fight_role_controller_battle_formation_info",0,{{1,1,1,1,0,1}{1,1,1,1,0,1}})
        FightRoleController.__battle_formation_info = params
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
local fight_role_controller_select_target_effect_visible_terminal = {
    _name = "fight_role_controller_select_target_effect_visible",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- 显示的脚本
        -- state_machine.excute("fight_role_controller_select_target_effect_visible", 0, true)
        -- 隐藏的脚本
        -- state_machine.excute("fight_role_controller_select_target_effect_visible", 0, false)
        if type(params) == "boolean" then
            FightRoleController.__select_target_effect_visible = params
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(fight_role_controller_battle_formation_info_terminal)
state_machine.add(fight_role_controller_select_target_effect_visible_terminal)
state_machine.init()

function FightRoleController:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.sprite_info = {}
    self.hero_slots = {}
    self.master_slots = {}

    self.attack_list = {}

    self._hero_formation = {}
    self._hero_formation_ex = {}
    self._hero_formation_copy = {}
    self._master_formation = {}
    self._master_formation_ex = {}

    self.fightIndex = 0

    self.isStopFight = false

    self.isCanStartUpAutoTick = false

    self.scale_arena = 0.10
    self.scale_start_y = -1
    self.scale_end_y = -1
    self.scale_arena_y = 0
    self.scale_py = 0

    self.enter_into_count = 0
    self.kill_count = 0

    self.current_fight_over = true
    self.current_fight_index = 0
    self.last_fight_round = 0
    self.last_fight_round_data = 0
    self.current_fight_round = 0
    self.current_attack_round = 0

    self.role_celebrate_count = 0

    -- team hp info
    self.heros_current_hp = 0
    self.heros_total_hp = 0
    self.masters_current_hp = 0
    self.masters_total_hp = 0

    -- scene pos
    self.open_camera = false
    self.center_left_offset = cc.p(0, 0)
    self.center_right_offset = cc.p(0, 0)
    self.center_offset = cc.p(0, 0)
    self.center_position = cc.p(0, 0)
    self.act_center_positions = {}
    self.column_center_positions = {}
    self.hero_column_positions = {}
    self.master_column_positions = {}

    self.base_camp_boundary = cc.p(0, 0)
    self.move_camp_boundary = cc.p(0, 0)

    self.isPvEType = true
    -- qte
    self.isAuto = false
    self.qte_fighting = false
    self.auto_fighting = false
    self.auto_duration = 30
    self.auto_duration1 = 10
    self.auto_intervel = self.auto_duration
    self.auto_queue = {}
    self.auto_double_hit_queue = {}
    self.auto_wait_queue = {}
    self.wakeUpProgressList = {}
    self.roundMakeHurtNum = 0
    self.isCalcTotalKillNum = false

    -- 存放已经出手攻击过的角色
    self.haveAttackedList = {}

    self.guideTime = 0
    self.guideNeedClick = false
    self.current_mission = nil

    self.currentAttackCount = 0

    self.isInDialogMission = false
    self.isLockScene = false

    self.isRoundOver = false

    self.isNeedChangeBattle = false
    self.changeBattleDelay = 2

    self.isResumeTimeLine = false
    self.resumeTimeLineDelay = 1.2

    self.totalAttacker = 0
    self.totalMonster = 0

    self.wakeUpArmature = nil
    self.qteProgressPos = 0

    self.pveFightInfoString = ""

    self.isWaitDeathOver = false
    self.isWaitDeathOverDelay = 0

    BattleSceneClass.curDamage = 0
    BattleSceneClass.bossDamage = 0

    self.byAttackTargetTag = 0

    self._add_wake_up_beAttack_effect_index = 0
    self._add_wake_up_beAttack_effect_last_index = 0
    
    self.keepAcliveInterval = 0

    self._open_hit_count = true

    -- 神兽位置
    self.hero_animal_slots = {}
    self.master_animal_slots = {}

    self._hero_animal_formation = {}
    self._master_animal_formation = {}

    self._hero_animal_formation_ex = {}
    self._master_animal_formation_ex = {}

    self.current_logic_round = 0

    -- Initialize fight role controller state machine.
    local function init_fight_role_controller_terminal()
        local fight_role_controller_manager_terminal = {
            _name = "fight_role_controller_manager",
            _init = function (terminal)
                app.load("client.battle.fight.Master")
                app.load("client.battle.fight.Hero")
                app.load("client.battle.landscape.FightRole")
                app.load("client.battle.landscape.FightTeamController")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_role_enter_into_over_terminal = {
            _name = "fight_role_controller_role_enter_into_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.enter_into_count = instance.enter_into_count - 1
                if instance.enter_into_count == 0 then
                    if instance.current_fight_index == 0 then
                        attack_logic.__hero_ui_visible = false
                        attack_logic.__hero_ui_lock = false
                        -- state_machine.excute("fight_role_controller_hero_info_ui_show", 0, {_datas = {_type = 1}})
                        state_machine.excute("fight_request_battle", 0, instance.current_fight_index)
                    else
                        state_machine.excute("fight_check_next_fight", 0, 0)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_change_battle_terminal = {
            _name = "fight_role_controller_change_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeBattle()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_request_next_fight_terminal = {
            _name = "fight_role_controller_request_next_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:requestNextFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_notification_role_be_kill_terminal = {
            _name = "fight_role_controller_notification_role_be_kill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.kill_count = instance.kill_count + 1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_notification_skeep_fight_terminal = {
            _name = "fight_role_controller_notification_skeep_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.current_fight_round = _ED.attackData.roundCount
                instance:nextRoundFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_notification_role_death_over_terminal = {
            _name = "fight_role_controller_notification_role_death_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if FightRole.__skeep_fighting == true then
                else
                    local role = params
                    -- test code
                    instance.kill_count = instance.kill_count - 1
                    if instance.kill_count == 0 then
                        -- state_machine.excute("fight_check_next_fight", 0, 0)
                        -- state_machine.excute("fight_role_controller_change_battle", 0, 0)
                        instance.current_fight_round = _ED.attackData.roundCount
                        instance:nextRoundFight()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_notification_role_death_for_last_kill_terminal = {
            _name = "fight_role_controller_notification_role_death_for_last_kill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:checkLastKiller(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_notification_role_celebrate_win_over_terminal = {
            _name = "fight_role_controller_notification_role_celebrate_win_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params
                instance.role_celebrate_count = instance.role_celebrate_count - 1
                if instance.role_celebrate_count == 0 then
                    -- instance:checkNextFight()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_ready_fight_terminal = {
            _name = "fight_role_controller_ready_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:readyFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_start_fight_terminal = {
            _name = "fight_role_controller_start_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:startFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_start_round_fight_terminal = {
            _name = "fight_role_controller_start_round_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:startRoundFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_check_next_round_fight_terminal = {
            _name = "fight_role_controller_check_next_round_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:checkNextRoundFight()
                if instance._add_wake_up_beAttack_effect == true then
                    instance._add_wake_up_beAttack_effect = false

                    state_machine.excute("fight_role_controller_restart_qte_timer", 0, 0)
                    state_machine.excute("fight_role_controller_wake_up_beAttack_effect", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_add_wake_up_beAttack_effect_terminal = {
            _name = "fight_role_controller_add_wake_up_beAttack_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._add_wake_up_beAttack_effect = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --全部英雄血条显示控制
        local fight_role_controller_hero_info_ui_show_terminal = {
            _name = "fight_role_controller_hero_info_ui_show",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params._datas._type
                
                if _type == 1 then
                    if attack_logic.__hero_ui_lock == true then 
                        return
                    end
                
                    attack_logic.__hero_ui_visible = not attack_logic.__hero_ui_visible
                end
                
                for i, v in pairs (instance._hero_formation_ex) do
                    if v.armature ~= nil then
                        if _type == 0 then -- 系统控制
                            local _visible = params._datas._visible
                            
                            if _visible == true and attack_logic.__hero_ui_visible == true 
                              or _visible == false then
                                v.armature._heroInfoWidget:controlLife(false, 1)
                                v.armature._heroInfoWidget:showControl(_visible)
                                
                                -- 攻击时特殊处理
                                v.armature._heroInfoWidget.bIsAttacking = false
                            end
                            
                        elseif _type == 1 then -- 手动控制
                            v.armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
                        end 
                    end 
                end
                
                for i, v in pairs (instance._master_formation_ex) do
                    if v.armature ~= nil then
                        if _type == 0 then -- 系统控制
                            local _visible = params._datas._visible
                            
                            if _visible == true and attack_logic.__hero_ui_visible == true 
                              or _visible == false then
                                v.armature._heroInfoWidget:controlLife(false, 1)
                                v.armature._heroInfoWidget:showControl(_visible)
                                
                                -- 攻击时特殊处理
                                v.armature._heroInfoWidget.bIsAttacking = false
                            end 
                            
                        elseif _type == 1 then -- 手动控制
                            v.armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
                        end 
                    end
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --指定英雄血条显示控制
        local fight_role_controller_hero_info_ui_show_by_pos_terminal = {
            _name = "fight_role_controller_hero_info_ui_show_by_pos",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local roleType = params._roleType
                local roleIndex = params._roleIndex
                local visible = params._visible
                
                if roleType == 1 then -- 敌方
                    for i, v in pairs (instance._master_formation_ex) do
                        if v.armature ~= nil and v.armature._pos == roleIndex then
                            v.armature._heroInfoWidget:controlLife(false, 2)
                            v.armature._heroInfoWidget:showControl(visible)
                            v.armature._heroInfoWidget:controlLife(true, 1)
                            
                            -- 攻击时特殊处理
                            v.armature._heroInfoWidget.bIsAttacking = visible == false and true or false
                            break
                        end
                    end
                elseif roleType == 2 then -- 我方
                    for i, v in pairs (instance._hero_formation_ex) do
                        if v.armature ~= nil and v.armature._pos == roleIndex then
                            v.armature._heroInfoWidget:controlLife(false, 2)
                            v.armature._heroInfoWidget:showControl(visible)
                            v.armature._heroInfoWidget:controlLife(true, 1)
                            
                            -- 攻击时特殊处理
                            v.armature._heroInfoWidget.bIsAttacking = visible == false and true or false
                            break
                        end
                    end
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --更新UI信息中的血量显示
        local fight_role_controller_update_hp_progress_terminal = {
            _name = "fight_role_controller_update_hp_progress",
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

        --战斗跳过功能的实现
        local fight_role_controller_skeep_fight_terminal = {
            _name = "fight_role_controller_skeep_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:skeepFighting()

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    then
                    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 
                        then
                        for i, v in pairs(instance._master_formation) do
                            if v.parent ~= nil and v.armature ~= nil then
                                for p = 1, 6 do
                                    _ED._fightModule._boss_reward_p1 = nil
                                    v:updateDrawRoleHP()
                                end
                            end
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --将战斗中的角色设置到出生点
        local fight_role_controller_reset_role_position_terminal = {
            _name = "fight_role_controller_reset_role_position",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:resetRolePosition(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换到下一下进攻角色
        local fight_role_controller_change_to_next_attack_role_terminal = {
            _name = "fight_role_controller_change_to_next_attack_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
                    if params and #params.fight_cacher_pool > 0 then
                        return false
                    end
                end
                instance:changeToNextAttackRole(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --qte切换到下一下进攻角色
        local fight_role_controller_qte_to_next_attack_role_terminal = {
            _name = "fight_role_controller_qte_to_next_attack_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:qteToNextAttackRole(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新阵营的移动分界线
        local fight_role_controller_update_camp_boundary_terminal = {
            _name = "fight_role_controller_update_camp_boundary",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:updateCampBoundary(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 镜头根据角色来聚焦
        local fight_role_controller_camera_focus_with_role_terminal = {
            _name = "fight_role_controller_camera_focus_with_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params
                if role ~= nil and role.camera_focus ~= nil then
                    if terminal._focus ~= nil then
                        terminal._focus.camera_focus = false
                        if terminal._focus == role then
                            role = nil
                        end
                    end
                    terminal._focus = role
                    if terminal._focus ~= nil then
                        terminal._focus.camera_focus = true
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重新启动QET计时
        local fight_role_controller_restart_qte_timer_terminal = {
            _name = "fight_role_controller_restart_qte_timer",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:restartQTETimer(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换到自动战斗
        local fight_role_controller_change_to_auto_fight_terminal = {
            _name = "fight_role_controller_change_to_auto_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    then

                    if params == true then
                        instance.isNextAuto = true
                        if instance.isAuto == false then
                            instance:changeToAutoFight(params)
                        end
                    else
                        instance.isNextAuto = false
                        -- instance.isAuto = false
                        -- -- instance.auto_fighting = false
                        -- -- instance.qte_fighting = false
                        -- instance.auto_intervel = 0
                    end
                else
                    instance.auto_intervel = 0
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 暂停战斗
        local fight_role_controller_change_to_stop_fight_terminal = {
            _name = "fight_role_controller_change_to_stop_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 启动连击进度条
        local fight_role_controller_startup_comkill_progress_terminal = {
            _name = "fight_role_controller_startup_comkill_progress",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if missionIsOver() == false then
                    executeNextRoundBattleEvent(self.currentAttackCount)
                end
                instance:startupComkillProgress(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_fight_end_stop_auto_terminal = {
            _name = "fight_role_controller_fight_end_stop_auto",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:fightEndStop()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_begin_mission_terminal = {
            _name = "fight_role_controller_begin_mission",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local state = params[1]
                local isStop = params[2]
                instance.isStopFight = isStop
                instance:changeFightRoleState(instance.isStopFight)
                if tonumber(state) ~= 0 and instance.guideTime < 0 and instance.current_mission ~= nil then
                    TuitionController._locked = false
                    saveExecuteEvent(instance.current_mission, true)
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_mission_fight_terminal = {
            _name = "fight_role_controller_mission_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    local state = params[2]
                    state_machine.excute("fight_qte_controller_change_mission_state", 0, state)
                else
                    instance.guideTime = params[1]
                    local state = params[2]
                    if instance.guideTime < 0 then
                        instance.guideNeedClick = true
                    else
                        instance.guideNeedClick = false
                    end
                    instance.current_mission = params[3]
                    state_machine.excute("fight_qte_controller_change_mission_state", 0, state)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_update_dialog_state_terminal = {
            _name = "fight_role_controller_update_dialog_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.isInDialogMission = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_begin_hetiSkill_terminal = {
            _name = "fight_role_controller_begin_hetiSkill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:beginHetiSkill(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_end_hetiSkill_terminal = {
            _name = "fight_role_controller_end_hetiSkill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:endHetiSkill(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_hide_role_layer_terminal = {
            _name = "fight_role_controller_hide_role_layer",
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

        local fight_role_controller_load_success_terminal = {
            _name = "fight_role_controller_load_success",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:loadSuccess()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_wake_up_beAttack_effect_terminal = {
            _name = "fight_role_controller_wake_up_beAttack_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params.isShow == true then
                    instance:wakeUpBeAttackerEffect(nil, true)
                else
                    instance:wakeUpBeAttackerEffect()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_lock_fight_terminal = {
            _name = "fight_role_controller_lock_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params == true then
                    instance:lockFight()
                else
                    instance:unlockFight()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置连击进度条
        local fight_role_controller_reset_comkill_progress_terminal = {
            _name = "fight_role_controller_reset_comkill_progress",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance.currentAttackCount = 0
                -- instance.auto_double_hit_queue = {}
                _ED._fightModule.greadCount = 0
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择被攻击的目标
        local fight_role_controller_select_by_attack_role_terminal = {
            _name = "fight_role_controller_select_by_attack_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:selectByAttackRole(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择被攻击的目标
        local fight_role_controller_play_power_skill_screen_effect_terminal = {
            _name = "fight_role_controller_play_power_skill_screen_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:palyerPowerSkillScreenEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制相同武将的提示信息
        local fight_role_controller_check_same_hero_tip_info_terminal = {
            _name = "fight_role_controller_check_same_hero_tip_info",
            _init = function (terminal)
                app.load("client.battle.landscape.GhostCopySameHeroTip")
                app.load("client.battle.landscape.GhostCopySameHeroSteamBubble")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:checkSameHeroTipInfo(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 校验先手
        local fight_role_controller_check_battle_speed_terminal = {
            _name = "fight_role_controller_check_battle_speed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if 1 == _ED._fightModule._attack_speed_type then
                    if _ED._battle_pause ~= true then
                        _ED._fightModule._attack_speed_type = 0
                        -- -- instance:executeCurrentRountFightData()
                        -- -- state_machine.excute("fight_qte_controller_role_by_active", 0, "lock")
                        -- for i, v in pairs(_ED._fightModule.attackObjects) do
                        --     v.isAction = true
                        -- end
                        instance:checkAttackerRoundOver()
                    else
                        executeNextEvent(nil, nil)
                    end
                end
                state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                state_machine.unlock("battle_qte_head_touch_head_role")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_check_battle_speed_for_mission_terminal = {
            _name = "fight_role_controller_check_battle_speed_for_mission",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- -- if 1 == _ED._fightModule._attack_speed_type then
                --     if _ED._battle_pause ~= true then
                --         -- _ED._fightModule._attack_speed_type = 0
                --         -- instance:executeCurrentRountFightData()
                --         -- state_machine.excute("fight_qte_controller_role_by_active", 0, "lock")
                        -- for i, v in pairs(_ED._fightModule.attackObjects) do
                        --     -- v.isAction = true
                        --     print("..........", v.battleTag, v.coordinate, v.isAction)
                        -- end
                --         instance:checkAttackerRoundOver()
                --     else
                --         -- executeNextEvent(nil, nil)
                --     end
                -- -- end
                -- instance:checkAttackerRoundOver()
                state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, nil)
                state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                -- executeNextEvent(nil, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_battle_lock_attack_for_mission_terminal = {
            _name = "fight_role_controller_battle_lock_attack_for_mission",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._battle_lock_attack = params
                -- print("_battle_lock_attack:", instance._battle_lock_attack)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏队伍信息
        local fight_role_controller_visible_formation_terminal = {
            _name = "fight_role_controller_visible_formation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local camp = params[1]
                local indexs = zstring.split(params[2], ",")
                local visible = false
                if zstring.tonumber(params[3]) == 1 then
                    visible = true
                end
                local t = nil
                if camp == 0 then
                    t = instance._hero_formation
                else
                    t = instance._master_formation
                end
                for i, v in pairs(indexs) do
                    local g = t[v]
                    if nil ~= g and g.parent ~= nil then
                        g.parent:setVisible(visible)
                    end
                end
                -- eg: state_machine.excute("fight_role_controller_visible_formation",0,{1,"1,2,3,4,5,6",0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 移除选择光标动画
        local fight_role_controller_remove_be_attacker_effect_terminal = {
            _name = "fight_role_controller_remove_be_attacker_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:removeBeAttackerEffect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新角色动画的播放速度
        local fight_role_controller_update_role_animation_speed_terminal = {
            _name = "fight_role_controller_update_role_animation_speed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateRoleAnimationSpeed(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 变更战斗角色
        local fight_role_controller_change_battle_role_terminal = {
            _name = "fight_role_controller_change_battle_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeBattleRole(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制战斗开始前的效用状态信息
        local fight_role_controller_update_draw_battle_start_influence_info_terminal = {
            _name = "fight_role_controller_update_draw_battle_start_influence_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawBattleStartInfluenceInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制回合前的效用状态信息
        local fight_role_controller_update_draw_round_influence_info_terminal = {
            _name = "fight_role_controller_update_draw_round_influence_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawRoundInfluenceInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制回合内攻击方切换的效用状态信息
        local fight_role_controller_update_draw_camp_change_influence_info_terminal = {
            _name = "fight_role_controller_update_draw_camp_change_influence_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawCampChangeInfluenceInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 自动选择目标
        local fight_role_controller_auto_select_terminal = {
            _name = "fight_role_controller_auto_select",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance.auto_select
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_controller_update_draw_ui_window_terminal = {
            _name = "fight_role_controller_update_draw_ui_window",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fight_ui_update_hp_progress", 0, {0, instance.heros_current_hp, instance.heros_total_hp})
                state_machine.excute("fight_ui_update_hp_progress", 0, {1, instance.masters_current_hp, instance.masters_total_hp})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fight_role_controller_manager_terminal)
        state_machine.add(fight_role_controller_role_enter_into_over_terminal)
        state_machine.add(fight_role_controller_change_battle_terminal)
        state_machine.add(fight_role_controller_request_next_fight_terminal)
        state_machine.add(fight_role_controller_notification_role_be_kill_terminal)
        state_machine.add(fight_role_controller_notification_skeep_fight_terminal)
        state_machine.add(fight_role_controller_notification_role_death_over_terminal)
        state_machine.add(fight_role_controller_notification_role_death_for_last_kill_terminal)
        state_machine.add(fight_role_controller_notification_role_celebrate_win_over_terminal)
        state_machine.add(fight_role_controller_ready_fight_terminal)
        state_machine.add(fight_role_controller_start_fight_terminal)
        state_machine.add(fight_role_controller_start_round_fight_terminal)
        state_machine.add(fight_role_controller_check_next_round_fight_terminal)
        state_machine.add(fight_role_controller_add_wake_up_beAttack_effect_terminal)
        state_machine.add(fight_role_controller_hero_info_ui_show_terminal)
        state_machine.add(fight_role_controller_hero_info_ui_show_by_pos_terminal)
        state_machine.add(fight_role_controller_update_hp_progress_terminal)
        state_machine.add(fight_role_controller_skeep_fight_terminal)
        state_machine.add(fight_role_controller_reset_role_position_terminal)
        state_machine.add(fight_role_controller_change_to_next_attack_role_terminal)
        state_machine.add(fight_role_controller_qte_to_next_attack_role_terminal)
        state_machine.add(fight_role_controller_update_camp_boundary_terminal)
        state_machine.add(fight_role_controller_camera_focus_with_role_terminal)
        state_machine.add(fight_role_controller_restart_qte_timer_terminal)
        state_machine.add(fight_role_controller_change_to_auto_fight_terminal)
        state_machine.add(fight_role_controller_change_to_stop_fight_terminal)
        state_machine.add(fight_role_controller_startup_comkill_progress_terminal)
        state_machine.add(fight_role_controller_fight_end_stop_auto_terminal)
        state_machine.add(fight_role_controller_begin_mission_terminal)
        state_machine.add(fight_role_controller_mission_fight_terminal)
        state_machine.add(fight_role_controller_update_dialog_state_terminal)
        state_machine.add(fight_role_controller_begin_hetiSkill_terminal)
        state_machine.add(fight_role_controller_end_hetiSkill_terminal)
        state_machine.add(fight_role_controller_hide_role_layer_terminal)
        state_machine.add(fight_role_controller_load_success_terminal)
        state_machine.add(fight_role_controller_wake_up_beAttack_effect_terminal)
        state_machine.add(fight_role_controller_lock_fight_terminal)
        state_machine.add(fight_role_controller_reset_comkill_progress_terminal)
        state_machine.add(fight_role_controller_select_by_attack_role_terminal)
        state_machine.add(fight_role_controller_play_power_skill_screen_effect_terminal)
        state_machine.add(fight_role_controller_check_same_hero_tip_info_terminal)
        state_machine.add(fight_role_controller_check_battle_speed_terminal)
        state_machine.add(fight_role_controller_check_battle_speed_for_mission_terminal)
        state_machine.add(fight_role_controller_battle_lock_attack_for_mission_terminal)
        state_machine.add(fight_role_controller_visible_formation_terminal)
        state_machine.add(fight_role_controller_remove_be_attacker_effect_terminal)
        state_machine.add(fight_role_controller_update_role_animation_speed_terminal)
        state_machine.add(fight_role_controller_change_battle_role_terminal)
        state_machine.add(fight_role_controller_update_draw_battle_start_influence_info_terminal)
        state_machine.add(fight_role_controller_update_draw_round_influence_info_terminal)
        state_machine.add(fight_role_controller_update_draw_camp_change_influence_info_terminal)
        state_machine.add(fight_role_controller_auto_select_terminal)
        state_machine.add(fight_role_controller_update_draw_ui_window_terminal)
        state_machine.init()
    end

    -- call func init fight role controller state machine.
    init_fight_role_controller_terminal()

    self._load_over = false
    self:onLoad()
end

-- 显示锁定圆圈
function FightRoleController:wakeUpBeAttackerEffect( _role, isShow )
    local lockRole = _role or self._master_formation["" .. self.byAttackTargetTag]
    if nil == lockRole or lockRole.parent == nil or lockRole.roleWaitDeath == true or lockRole.isDeathRemove == true or lockRole.is_killed == true or lockRole.is_deathed == true then
        self.byAttackTargetTag = 0
        lockRole = nil
        for k,v in pairs(self._master_formation) do
            if v ~= nil and v.parent ~= nil and v.roleWaitDeath == false and v.isDeathRemove == false and v.is_killed == false and v.is_deathed == false and nil == v.buffList["79"] then
                if lockRole == nil or (nil ~= lockRole._brole and tonumber(lockRole._brole._pos) > tonumber(v._brole._pos)) then
                    lockRole = v
                end
            end
        end
    end
    
    self:removeBeAttackerEffect()

    if lockRole == nil or lockRole.parent == nil or lockRole.roleWaitDeath == true or lockRole.isDeathRemove == true or lockRole.is_killed == true or lockRole.is_deathed == true then
        state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
        return
    end
    
    if self.auto_fighting == true then
        return
    end

    local xx, yy = lockRole.parent:getPosition()
    if isShow == true or (xx == lockRole.parent._base_pos.x and yy == lockRole.parent._base_pos.y) then
        self.wakeUpArmature = nil
        self.wakeUpArmature = ccs.Armature:create("effect_zhandou_gongji")
        draw.initArmature(self.wakeUpArmature, nil, -1, 0, 1)
        csb.animationChangeToAction(self.wakeUpArmature, 0, 1, true)
        lockRole.parent:addChild(self.wakeUpArmature)
        self.wakeUpArmature:setPosition(lockRole:getContentSize().width/2, lockRole:getContentSize().height + 10)

        self.wakeUpArmature._lockRole = lockRole

        if nil ~= FightRoleController.__select_target_effect_visible then
            self.wakeUpArmature:setVisible(FightRoleController.__select_target_effect_visible)
        end
    end

    if nil == _role then
        state_machine.unlock("fight_role_controller_select_by_attack_role")
    end
    state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role")
end

-- 移除锁定圆圈
function FightRoleController:removeBeAttackerEffect( ... )
    if self.wakeUpArmature ~= nil and self.wakeUpArmature.getParent ~= nil and tolua.isnull(self.wakeUpArmature) == false then
        self.wakeUpArmature:removeFromParent(true)
    end
    self.wakeUpArmature = nil
end

function FightRoleController:updateRoleAnimationSpeed(speed)
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil then
            v.actionTimeSpeed = speed
            v.armature:getAnimation():setSpeedScale(1.0/v.actionTimeSpeed)
        end
    end

    for i, v in pairs(self._master_formation_ex) do
        if v.parent ~= nil then
            v.actionTimeSpeed = speed
            v.armature:getAnimation():setSpeedScale(1.0/v.actionTimeSpeed)
        end
    end    
end

function FightRoleController:changeBattleRole( params )
    local attackerCamp = params[1]
    local attackerFormationIndex = params[2]
    local environmentShipId = params[3]

    

    local role = nil
    if attackerCamp == 0 then
        role = self._hero_formation["" .. attackerFormationIndex]
    else
        role = self._master_formation["" .. attackerFormationIndex]
    end

    if role == nil then
        local tempFormation = attackerCamp == 0 and self._hero_formation or self._master_formation
        for i = 6, 1, -1 do
            if tempFormation["" .. i] ~= nil then
                attackerFormationIndex = i
                role = tempFormation["" .. i]
                break
            end
        end
    end

    if role == nil then
        return true
    end

    local battleObject = _ED._fightModule:changeBattleRoleInfo(attackerCamp, attackerFormationIndex, environmentShipId)
    role._brole._head = battleObject.fightObject.picIndex

    role:updateChange(nil)
    
    if nil ~= role._qte then
        role._qte:onUpdateDrawHead(zstring.tonumber(role._brole._head))
    end
end

function FightRoleController:updateDrawBattleStartInfluenceInfo( params )
    if nil == _ED.battleData._battle_start_influence_info then
        return
    end

    local lastDefenderPos = 6

    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
        for i, v in pairs(_ED.battleData._battle_start_influence_info._defenders) do
            local skf = v
            if tonumber(skf.defenderPos) < lastDefenderPos then
                lastDefenderPos = tonumber(skf.defenderPos)
            end
        end
        lastDefenderPos = "" .. lastDefenderPos

        for i, v in pairs(_ED.battleData._battle_start_influence_info._defenders) do
            local skf = v
            if skf.defenderPos ~= lastDefenderPos then
                if skf.defenderST == "2" or skf.defenderST == "3" or skf.defenderST == "20" then
                    _ED.battleData._battle_start_influence_info._defenders[i] = nil
                end
            end
        end
    end

    for i, v in pairs(_ED.battleData._battle_start_influence_info._defenders) do
        local skf = v
        local role = nil
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
            if nil == lastDefenderPos or lastDefenderPos == skf.defenderPos then
                if skf.defender == "0" then
                    role = self._hero_formation["2"]
                else
                    role = self._master_formation["2"]
                end
                lastDefenderPos = skf.defenderPos

                _ED.battleData._battle_start_influence_info._defenders[i] = nil
            end
        else
            if skf.defender == "0" then
                role = self._hero_formation[skf.defenderPos]
            else
                role = self._master_formation[skf.defenderPos]
            end
        end

        if nil ~= role and role.parent ~= nil then

            if self.isPvEType == true then
                if tonumber(skf.defenderST) == 45 then
                    skf.stRound = skf.stRound + 1
                end
            end
            role:updateDrawInfluenceInfo(skf, true)
        end
    end

    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
    else
        _ED.battleData._battle_start_influence_info = nil
    end
    state_machine.excute("fight_role_controller_update_hp_progress", 0, nil)
end

function FightRoleController:updateDrawRoundInfluenceInfo( params )
    if nil == _ED.battleData._battle_round_influence_infos then
        return
    end
    local battle_round_influence_info = _ED.battleData._battle_round_influence_infos[self.current_fight_round]
    if nil == battle_round_influence_info then
        return
    end
    local defenders = battle_round_influence_info._defenders
    if nil == defenders then
        return
    end
    for i, v in pairs(defenders) do
        local skf = v
        local role = nil
        if skf.defender == "0" then
            role = self._hero_formation[skf.defenderPos]
        else
            role = self._master_formation[skf.defenderPos]
        end

        if nil ~= role and role.parent ~= nil then
            role:updateDrawInfluenceInfo(skf, true)
        end
    end
    state_machine.excute("fight_role_controller_update_hp_progress", 0, nil)
end

function FightRoleController:updateDrawCampChangeInfluenceInfo_2(key)
    _ED.battleData._camp_change_influence_info = _ED.battleData._camp_change_influence_infos[key]
    if nil == _ED.battleData._camp_change_influence_info then
        -- print("updateDrawCampChangeInfluenceInfo，找不到灼烧信息，return")
        return
    end

    -- print("updateDrawCampChangeInfluenceInfo 4")
    -- debug.print_r(_ED.battleData._camp_change_influence_info._defenders, "嘎嘎111222")

    local firings = {}
    for i, v in pairs(_ED.battleData._camp_change_influence_info._defenders) do
        local skf = v
        local role = nil
        if skf.defender == "0" then
            role = self._hero_formation[skf.defenderPos]
        else
            role = self._master_formation[skf.defenderPos]
        end

        if skf.defenderST == "9" then -- 合并灼烧伤害
            local key = skf.defender .. "-" .. skf.defenderPos
            local firing = firings[key]
            if nil ~= firing then
                local fv = tonumber(skf.stValue) + tonumber(firing._skf.stValue)
                skf.stValue = "" .. fv
                firing._skf = skf
            else
                firings[key] = {_skf = skf, _role = role}
            end
        else
            if nil ~= role and role.parent ~= nil then
                role:updateDrawInfluenceInfo(skf, true)
            end
        end
    end

    for key, firing in pairs(firings) do
        if nil ~= firing and nil ~= firing._role and firing._role.parent ~= nil then
            firing._role:updateDrawInfluenceInfo(firing._skf, true, true)
        end
    end

    _ED.battleData._camp_change_influence_info = nil
    _ED.battleData._camp_change_influence_infos[key] = nil
    state_machine.excute("fight_role_controller_update_hp_progress", 0, nil)
end

function FightRoleController:updateDrawCampChangeInfluenceInfo( params )
    if nil == _ED.battleData._camp_change_influence_infos then
        -- print("FightRoleController:updateDrawCampChangeInfluenceInfo 2 return")
        return
    end

    local round = tonumber(self.current_fight_round)

    if self.isPvEType == true then
        local firstCamp = 0
        if tonumber(_ED.battleData.attacker_priority) < tonumber(_ED.battleData.defender_priority) then
            firstCamp = 1
        end

        -- 如果是先手方，round减1，因为先手方出手时，要么是最先出手，要么是下一回合出手，这样就取上一回合的灼烧数据
        if tonumber(params) == firstCamp then
            -- print("绘制灼烧，回合数减1，取上一回合数据")
            round = round - 1
        end
    end

    local key = "" .. round .. "-" .. params

    self:updateDrawCampChangeInfluenceInfo_2(key)
    
end

function FightRoleController:checkLastKiller( params )
    if FightRole.__skeep_fighting == true then
    elseif animationMode == 1 then
        local role = params[1]
        local isNeedCheckEffect = params[2]
        if role.roleCamp == 0 then
            self.totalAttacker = self.totalAttacker - 1
        else
            self.totalMonster = self.totalMonster - 1
            self:removeBeAttackerEffect()
        end
        if self.fightIndex >= _ED.battleData.battle_total_count then
            if self.totalAttacker == 0 or self.totalMonster == 0 then
                if isNeedCheckEffect == true then
                    self.isResumeTimeLine = true
                    cc.Director:getInstance():getScheduler():setTimeScale(0.3)
                    state_machine.excute("fight_ui_add_last_kill_effect", 0, nil)
                end
                --隐藏罗刹道场的描述
                if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_102 then
                    if fwin:find("TrialTowerBattleDescribeClass") ~= nil then
                        state_machine.excute("trial_tower_battle_describe_hidden",0,"")     
                    end
                end
            end
        end
        local dead_hero_number = #self._hero_formation_ex - self.totalAttacker 
        state_machine.excute("trial_tower_battle_describe_add_dead_unit_limit_count",0,dead_hero_number)
    end
end

function FightRoleController:init(isPvEFight)
    mission_setIsInBattler(true)
    self:checkIsStartUpAutoTick()
    self.isPvEType = isPvEFight
    if self.isPvEType == true then
        self.isAuto = self:getIsAutoFight()
        self.auto_fighting = self:getIsAutoFight()
        if self.isCanStartUpAutoTick == false then
            self.isAuto = false
            self.auto_fighting = false
        end
    else
        self.isAuto = true
        self.auto_fighting = true
    end
    
    __________b = false
    FightRole.__g_role_attacking = false
    FightRole.__g_lock_sp_attack = false
    FightRole.__g_lock_camp_attack = 0
    FightRole._current_attack_camp = -1
    FightRole._last_attack_camp = -1
    FightRole.__priority_camp = -1
    return self
end

function FightRoleController:checkAllRoleDeathed()
    if self.role_celebrate_count > 0 then
        return
    end
    -- if role ~= nil then

        -- if role.roleCamp == 0 then
        --     for i, v in pairs(self._hero_formation_ex) do
        --         if v ~= role then
        --             table.remove(self._hero_formation_ex, i)
        --             break;
        --         end
        --     end
        -- else
        --     for i, v in pairs(self._master_formation_ex) do
        --         if v ~= role then
        --             table.remove(self._master_formation_ex, i)
        --             break;
        --         end
        --     end
        -- end

        local aliveCount = 0
        for i, v in pairs(self._master_formation_ex) do
            if v ~= nil and v.parent ~= nil then
                aliveCount = aliveCount + 1
                -- break
            end
        end

        if aliveCount == 0 then
            self.role_celebrate_count = 0
            for i, v in pairs(self._hero_formation_ex) do
                if v ~= nil and v.parent ~= nil then  
                    v.parent:stopAllActions()  
                    v:skeepFighting()
                    self.role_celebrate_count = self.role_celebrate_count + 1
                    state_machine.excute("fight_role_change_fight_win_event", 0, v)
                end
            end
        end
    -- end
end

function FightRoleController:fightEndStop( ... )
    mission_setIsInBattler(false)
    local result = "1"
    if self.isPvEType == true and _ED._fightModule ~= nil then
        result = _ED._fightModule.fightResult
    else
        result = _ED.attackData.isWin
    end
    if tonumber(result) == 0 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_101 then
        state_machine.excute("fight_ui_update_hp_progress", 0, {0, 0, self.heros_total_hp})
        state_machine.excute("fight_ui_update_hp_progress", 0, {1, self.masters_current_hp, self.masters_total_hp})
    else
        state_machine.excute("fight_ui_update_hp_progress", 0, {0, self.heros_current_hp, self.heros_total_hp})
        state_machine.excute("fight_ui_update_hp_progress", 0, {1, 0, self.masters_total_hp})
    end
    -- self:unregisterOnNoteUpdate(self)
    self.isAuto = false
    self.auto_fighting = false
    self.qte_fighting = false
    self.auto_intervel = 0
    state_machine.excute("fight_ui_update_auto_fight_time",0, {time = 0, isShowAuto = false})
end

function FightRoleController:checkNextRoundFight()
    local attackListCount = #self.attack_list
    local heroAttackCount = 0
    local masterAttackCount = 0
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil and (table.nums(v.fight_cacher_pool) > 0 or (nil ~= v._ecsrfd and #v._ecsrfd > 0)) then
            if attackListCount == 0 then
                v._ecsrfd = {}
            else
                heroAttackCount = heroAttackCount + 1

                -- debug.print_r(v.fight_cacher_pool)
                v:checkNextFight()
            end
        end
    end

    for i, v in pairs(self._master_formation_ex) do
        if v.parent ~= nil and (table.nums(v.fight_cacher_pool) > 0 or (nil ~= v._ecsrfd and #v._ecsrfd > 0)) then
            if attackListCount == 0 then
                v._ecsrfd = {}
            else
                masterAttackCount = masterAttackCount + 1
            end
        end
    end

    -- 获得目前还在攻击列表的神兽数量，如果都出手完了就进入下一回合或下一波次
    for i, v in pairs(self._hero_animal_formation_ex) do
        if v.parent ~= nil and (table.nums(v.fight_cacher_pool) > 0 or (nil ~= v._ecsrfd and #v._ecsrfd > 0)) then
            if attackListCount == 0 then
                v._ecsrfd = {}
            else
                heroAttackCount = heroAttackCount + 1
            end
        end
    end

    for i, v in pairs(self._master_animal_formation_ex) do
        if v.parent ~= nil and (table.nums(v.fight_cacher_pool) > 0 or (nil ~= v._ecsrfd and #v._ecsrfd > 0)) then
            if attackListCount == 0 then
                v._ecsrfd = {}
            else
                masterAttackCount = masterAttackCount + 1
            end
        end
    end

    local autoOver = true
    if self.isPvEType == true and true == missionIsOver() then
        if self.auto_fighting == false then
            if #self.auto_queue > 0 or #self.auto_wait_queue > 0 or (_ED._fightModule ~= nil and _ED._fightModule:checkAttackSell(true) == true) then
                autoOver = false
            end
        end
    end

    -- print("剩余未出手玩家数:", heroAttackCount, masterAttackCount, autoOver, #self.auto_queue, #self.auto_wait_queue, table.nums(self.attack_list))
    if (heroAttackCount == 0 and masterAttackCount == 0 and autoOver == true) or true == FightRole.__skeep_fighting then
        -- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
        --     if heroAttackCount == 0 then
        --         if nil ~= _ED.battleData.__heros and #_ED.battleData.__heros > 0 then
        --             _ED.battleData.__heros["2"] = table.remove(_ED.battleData.__heros, 1, 1)
        --             self:initHero()
        --             return
        --         end
        --     end

        --     if masterAttackCount == 0 then
        --         if nil ~= _ED.battleData._armys.__data and #_ED.battleData._armys.__data > 0 then
        --             _ED.battleData._armys._data["2"] = table.remove(_ED.battleData._armys.__data, 1, 1)
        --             self:initMaster()
        --             return
        --         end
        --     end
        -- end
        self:nextRoundFight()

        state_machine.excute("fight_ui_resume_action_nodes", 0, 0)
    end
end

function FightRoleController:startRoundFight()
    self.current_fight_index = self.current_fight_index + 1
    self.last_fight_round = 0
    self.last_fight_round_data = 0
    self.current_fight_round = 0
    -- print("战斗回合逻辑处理")
    local function startRoundFightFuncN(_self)
        -->___crint("当前回合处理完毕")
        _self:nextRoundFight()
    end

    local array = {}
    table.insert(array, cc.CallFunc:create(startRoundFightFuncN))
    local seq = cc.Sequence:create(array)

    self:runAction(seq)
end

function FightRoleController:resetRolePosition(params)
    if params == true then
        for i = 1, 6 do
            local hero = self.hero_slots[i]
            hero:setVisible(hero._fited == true)
            hero:setPosition(hero._base_pos)
            -- hero:stopAllActions()
            local heroRole = hero._self
            if heroRole ~= nil then
                heroRole.armature:getAnimation():playWithIndex(_enum_animation_l_frame_index.animation_standby)
                heroRole.move_state = 0
            end

            local master = self.master_slots[i]
            master:setVisible(master._fited == true)
            master:setPosition(master._base_pos)
            -- master:stopAllActions()
            local masterRole = master._self
            if masterRole ~= nil then
                masterRole.armature:getAnimation():playWithIndex(_enum_animation_l_frame_index.animation_standby)
                masterRole.move_state = 0
            end
        end
    else
        for i = 1, 6 do
            local hero = self.hero_slots[i]
            hero._fited = false
            hero:setVisible(true)

            local master = self.master_slots[i]
            master._fited = false
            master:setVisible(true)
        end
    end
end

function FightRoleController:skeepFighting()
    -- 跨服战跳过时直接进结算
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214 or  _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219   or  _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220  then
        for i, v in pairs(self._hero_formation) do
            if v.parent ~= nil then
                v:removeFromParent(true)
            end
        end
        for i, v in pairs(self._master_formation) do
            if v.parent ~= nil then
                v:removeFromParent(true)
            end
        end

        return
    end

    if FightRole.__skeep_fighting == true or FightRole.__fit_attacking == true then
        return
    end

    if _ED._fightModule ~= nil then
        _ED._fightModule:jumpCurrentFight(_ED.use_info, {})
        _ED.attackData.isWin = "".._ED._fightModule.fightResult
    end
    self:removeBeAttackerEffect()
    state_machine.lock("fight_skeep_fighting")
    FightRole.__skeep_fighting = true
    if _ED.attackData.isWin == "0" then
        for i, v in pairs(self._hero_formation) do
            if v.parent ~= nil then
                v:skeepFighting()
                state_machine.excute("fight_role_be_killed", 0, v)
                -- state_machine.excute("fight_role_controller_notification_role_be_kill", 0, 0)
            end
        end
        for i, v in pairs(self._master_formation) do
            if v.parent ~= nil then
                v:skeepFighting()
            end
        end
        -- 更新UI上面的血量显示
        state_machine.excute("fight_ui_update_hp_progress", 0, {0, 0, self.heros_total_hp})
        state_machine.excute("fight_ui_update_hp_progress", 0, {1, self.masters_current_hp, self.masters_total_hp})
    else
        for i, v in pairs(self._hero_formation) do
            if v.parent ~= nil then
                v:skeepFighting()
            end
        end
        for i, v in pairs(self._master_formation) do
            if v.parent ~= nil then
                v:skeepFighting()
                state_machine.excute("fight_role_be_killed", 0, v)
                -- state_machine.excute("fight_role_controller_notification_role_be_kill", 0, 0)
            end
        end
        -- 更新UI上面的血量显示
        state_machine.excute("fight_ui_update_hp_progress", 0, {0, self.heros_current_hp, self.heros_total_hp})
        state_machine.excute("fight_ui_update_hp_progress", 0, {1, 0, self.masters_total_hp})
    end
    state_machine.excute("fight_role_controller_notification_skeep_fight", 0, nil)

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        state_machine.excute("fight_ui_skeep_animation_visible_false",0,"")        
    end
    -- state_machine.excute("fight_check_next_fight", 0, 0)
end

function FightRoleController:checkNextFight()
    if self.current_fight_over == true then
        return
    end
    -- print("当前场次战斗结束")
    local fightRoundOver = true
    for i, v in pairs(self._hero_formation_ex) do
        if self.isRoundOver == true then
            if v ~= nil and v.parent ~= nil and v.roleAttacking == true or v.roleByAttacking == true then
                fightRoundOver = false
            end
        else
            if v.parent ~= nil 
                -- and v:checkNextFight() == false 
                then
                fightRoundOver = false
                break
            end
        end
    end

    if fightRoundOver == false then
        fightRoundOver = true
        for i, v in pairs(self._master_formation_ex) do
            if self.isRoundOver == true then
                if v ~= nil and v.parent ~= nil and v.roleAttacking == true or v.roleByAttacking == true then
                    fightRoundOver = false
                end
            else
                if v.parent ~= nil 
                    -- and v:checkNextFight() == false 
                    then
                    fightRoundOver = false
                    break
                end
            end
        end
    end
    
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_101 
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_109
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220
        then
        fightRoundOver = true
    end
    
    if fightRoundOver == true or FightRole.__skeep_fighting == true then
        FightRole.__skeep_fighting = false
        self.current_fight_over = true
        self.open_camera = false
        self.isRoundOver = false
        state_machine.lock("fight_skeep_fighting")

        if self.current_fight_index >= _ED.battleData.battle_total_count then
        else
            for k,data in pairs(FightRole.__mapEffectList) do
                if data.armature ~= nil and data.armature.getParent ~= nil then
                    data.armature:removeFromParent(true)
                end
            end
            FightRole.__mapEffectList = {}
            self.open_camera = true
            local result = {}
            if tonumber(_ED.attackData.isWin) == 0 then
                result = self.master_slots
            else
                result = self.hero_slots
            end
            for i, v in pairs(result) do
                v._swap_pos.x = v._base_pos.x
                v._swap_pos.y = v._base_pos.y
                v._move_pos.x = v._base_pos.x
                v._move_pos.y = v._base_pos.y

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                else
                    -- 角色复位
                    v:stopAllActions()
                    v:setPosition(v._base_pos)
                end
            end
        end

        -- print("当前场次战斗结束!")
        -- state_machine.excute("fight_role_controller_change_battle", 0, 0)

        -- self.center_left_offset.x = 99999999 --size.width / 2
        -- self.center_right_offset.x = 0 --size.width / 2
        -- self.center_position.y = 0
        -- for i, v in pairs(self._hero_formation_ex) do
        --     if v.parent ~= nil then
        --         self:cameraFocusChange(v)
        --     end
        -- end
        -- self.center_position.x = self.center_left_offset.x + (self.center_right_offset.x - self.center_left_offset.x) / 2
        -- state_machine.excute("fight_scene_camera_focussing", 0, {self.center_position, self.center_left_offset, self.center_right_offset})
        
        local currentAuto = state_machine.excute("fight_ui_update_fight_get_auto_state", 0, nil)
        self:saveAsAuFightType(currentAuto)

        self.isNeedChangeBattle = true
        self.changeBattleDelay = 2

    end 
end

function FightRoleController:cleanDeathedRole()
    local hadDeathedRold = false
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil and v.roleWaitDeath == true and v.repelAndFlyEffectCount == 0 then
            hadDeathedRold = true
            v.roleWaitDeath = false
            v:skeepFighting()
            v.parent:stopAllActions()
            state_machine.excute("fight_role_be_killed", 0, v)
        end
    end

    for i, v in pairs(self._master_formation_ex) do
        if v.parent ~= nil and v.roleWaitDeath == true and v.repelAndFlyEffectCount == 0 then
            hadDeathedRold = true
            v.roleWaitDeath = false
            v:skeepFighting()
            v.parent:stopAllActions()
            state_machine.excute("fight_role_be_killed", 0, v)
        end
    end
    return hadDeathedRold
end

function FightRoleController:checkHaveInAttacking( ... )
    local result = false
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil and v.roleAttacking == true then
            result = true
        end
    end

    for i, v in pairs(self._master_formation_ex) do
        if v.parent ~= nil and v.roleAttacking == true then
            result = true
        end
    end
    return result
end

function FightRoleController:startupComkillProgress( params )
    if self.isPvEType ~= true then
        return
    end
    if self.auto_fighting == false then
        if #self.auto_wait_queue ~= 0 or _ED._fightModule:checkAttackSell() == true then
            for i,v in ipairs(self.wakeUpProgressList) do
                if v ~= nil and v.fightRole == params and v.state == true then
                    local qteProgressPos = self.qteProgressPos
                    -- if self.auto_select == true then
                    --     qteProgressPos = -1
                    -- end
                    state_machine.excute("fight_qte_controller_start_qte_active", 0, {qteProgressPos, v.fightRole.firstTarget, self.auto_select})
                end
            end
        end
    end
end

function FightRoleController:checkAttackerRoundOver()
    -- print("=============checkAttackerRoundOver", #self.auto_wait_queue, _ED._fightModule, _ED._fightModule:checkAttackSell())
    if #self.auto_wait_queue == 0 then
        if _ED._fightModule ~= nil and _ED._fightModule:checkAttackSell(true) == false then
            -- self.auto_fighting = true
            -- self.qte_fighting = false
            -- if _ED._fightModule:checkByAttackSell() == true then
            --     self:executeCurrentRountFightData()
            -- end
            -- if self.isPvEType == true then
            --     if self.isCalcTotalKillNum == false and self.isAuto == false and self.roundMakeHurtNum ~= 0 then
            --         state_machine.excute("fight_qte_controller_update_fight_score_info", 0, {self.roundMakeHurtNum, #self.auto_double_hit_queue})
            --         self.isCalcTotalKillNum = true
            --     end
            -- end

            self.change_next_camp_battle_round = true
            if true ~= self.unchange_next_camp_battle_round then
                self:checkChangeNextCampBattleRound()
            end
            -- self.unchange_next_camp_battle_round = false

            -- print("****************9999999999999999999****************")
        else
            -- print("********************************")
        end
    end 
end

function FightRoleController:checkChangeNextCampBattleRound()
    if true == self.change_next_camp_battle_round then
        self.change_next_camp_battle_round = false
        self.auto_fighting = true
        self.qte_fighting = false
        if _ED._fightModule:checkByAttackSell() == true then
            self:executeCurrentRountFightData()
        end
        if self.isPvEType == true then
            if self.isCalcTotalKillNum == false and self.isAuto == false and self.roundMakeHurtNum ~= 0 then
                state_machine.excute("fight_qte_controller_update_fight_score_info", 0, {self.roundMakeHurtNum, #self.auto_double_hit_queue})
                self.isCalcTotalKillNum = true
            end
        end
    end
end

function FightRoleController:changeToNextAttackRole(_currentRole)
    if _ED._battle_pause == true then
        _ED._battle_pause = false
        if false == missionIsOver() then
            executeNextEvent(nil, nil)
        end
    end
    if self._battle_lock_attack == true then
        self._battle_lock_attack = false
        return
    end

    if FightRole.__fit_attacking == true then
        return
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

    else
        if self.isPvEType == true and calcTotalFormationFightCheck() == false then --_ED.baseFightingCount ~= calcTotalFormationFight() then
            fwin:close(fwin:find("ReconnectViewClass"))
            fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
            return
        end
    end

    -- state_machine.unlock("fight_qte_controller_qte_to_next_attack_role")
    state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, 0)
    -- print("切换到下一个攻击角色", self.auto_fighting, _currentRole)
    local currentAttacker = nil
    if self.auto_fighting == true 
        -- or ((nil ~= _currentRole and _currentRole.roleCamp == 1) or ((#self.auto_queue == 0 and #self.auto_wait_queue == 0) and #self.attack_list > 0)) 
        then
        if _currentRole ~= nil then
            if _currentRole == self.attack_list[1] then
                table.remove(self.attack_list, "1")
                if nil ~= _currentRole._ecsrfd and #_currentRole._ecsrfd > 0 then
                    table.remove(_currentRole._ecsrfd, "1")
                end
                -- print("切换到下一个攻击角色--1---", _currentRole.roleCamp, _currentRole._info._pos, #self.attack_list, table.nums(_currentRole._ecsrfd))
                self.currentAttackCount = self.currentAttackCount + 1
                if executeNextRoundBattleEvent(self.currentAttackCount) == true then
                    return
                end
            end
        end
        _currentRole = self.attack_list[1]
        if _currentRole ~= nil then
            -- print("切换到下一个攻击角色--2---", _currentRole.roleCamp, _currentRole._info._pos, #self.attack_list, #_currentRole._ecsrfd)
            if nil ~= _currentRole._ecsrfd and #_currentRole._ecsrfd > 0 then
                if true == _currentRole._call_next then
                    _currentRole._call_next1 = true
                    return 
                end
                -- table.remove(self.attack_list, "1")
                local aa = _currentRole._ecsrfd[1]
                self:executeCurrentSelectRoleFightData(aa[1], aa[2], true)
            end
            currentAttacker = _currentRole
            state_machine.excute("fight_role_change_to_next_attack_role", 0, _currentRole)
        end
    else
        local activeRole = self.auto_queue[1]
        if activeRole ~= nil then
            if activeRole == _currentRole then
                table.remove(self.auto_queue, "1")
                if executeNextRoundBattleEvent(self.currentAttackCount) == true then
                    return
                end

                self:checkAttackerRoundOver()
            else
                table.remove(self.auto_queue, "1")
            end
        end

        -- 队友等待出手 但是已经被魅惑的队友杀死 则从将队友从等待列表移除
        for i = #self.auto_wait_queue, 1, -1 do
            local role = self.auto_wait_queue[i]
            if role.is_killed == true or role.is_deathed == true or role.roleWaitDeath == true then
                table.remove(self.auto_wait_queue, i)
            end
        end

        local canAttack = false
        -- print("self.auto_select = ", self.auto_select, _currentRole)
        if false == self.auto_select and nil ~= _currentRole and _currentRole.roleCamp == 0 then
            -- 检测是否可以进行神兽攻击
            local canAnimalAttack, canAttackAnimal, animaldIndex = state_machine.excute("fight_qte_controller_qte_to_auto_animal_start_attack", 0, 0)

            -- print("FightRoleController:changeToNextAttackRole canAnimalAttack = ", canAnimalAttack, canAttackAnimal)
            -- if _currentRole then
            --     print("_currentRole = ", _currentRole.roleCamp, _currentRole._info._pos)
            -- end

            -- if activeRole then
            --     print("activeRole = ", activeRole.roleCamp, activeRole._info._pos)
            -- end

            -- if canAttackAnimal then
            --     print("canAttackAnimal = ", canAttackAnimal.roleCamp, canAttackAnimal._info._pos)
            -- end

            if canAnimalAttack == true then
                local animalIsInQueue = false
                for k, v in pairs(self.auto_queue) do
                    if v ~= nil and v == canAttackAnimal then
                        animalIsInQueue = true
                        break
                    end
                end

                for k, v in pairs(self.auto_wait_queue) do
                    if v ~= nil and v == canAttackAnimal then
                        animalIsInQueue = true
                        break
                    end
                end
                -- 列表里没有就加入到列表里
                if animalIsInQueue == false then
                    canAttack = canAnimalAttack
                    state_machine.excute("fight_role_controller_qte_to_next_attack_role", 0, {canAttackAnimal, animaldIndex})
                end
            end
        end

        local selectRole = self.auto_wait_queue[1]
        if selectRole ~= nil and canAttack == false then
            currentAttacker = selectRole
            -- print("selectRole = ", selectRole.roleCamp, selectRole._info._pos, selectRole._isAnimal, selectRole._ecsrfd, selectRole._call_next)
            if nil ~= selectRole._ecsrfd and #selectRole._ecsrfd > 0 then
                -- print("#selectRole._ecsrfd = ", #selectRole._ecsrfd)
                if true == selectRole._call_next then
                    selectRole._call_next1 = true
                    return 
                end
                local aa = table.remove(selectRole._ecsrfd, "1")
                self:executeCurrentSelectRoleFightData(aa[1], aa[2], true)
            end
            
            table.remove(self.auto_wait_queue, "1")
            if self:qteAddAttackRole(selectRole) == true then
                self:qteExecuteRoleAttack(selectRole)
                self.currentAttackCount = self.currentAttackCount + 1
                state_machine.excute("fight_role_controller_restart_qte_timer", 0, 0)
            else
                self:checkAttackerRoundOver()
                self.auto_queue = {}
                self.auto_wait_queue = {}
            end
        end

        -- 自动选择目标进行攻击
        if true == self.auto_select and nil ~= _currentRole and _currentRole.roleCamp == 0 
            -- and _currentRole.skillQuality == 1 
            then
            fwin:addService({
                callback = function ( params )
                    -- print("自动选择目标进行攻击 step 2")
                    FightRoleController.__lock_battle = false
                    state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                    state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                end,
                delay = 0.01,
                params = self
            })
        end

    end


    -- fix bug#556 王者之战出现过这样的bug，切换到敌方新上场的2号位，但敌方上一个号2号位数据被灼烧死，但显示没有被灼烧死，并动手了，这里做个检测，如果切换到当前角色，但当前角色已经被烧死，做个刷新操作
    local battleTag = 0
    if currentAttacker then
        battleTag = currentAttacker.roleCamp or 0

        ----------------------------------
        -- 如果有被灼烧死的数据，则做一次刷新
        if _ED.battleData._camp_change_influence_infos then
            local key = "" .. self.current_fight_round .. "-" .. battleTag
            local camp_change_influence_info = _ED.battleData._camp_change_influence_infos[key]
            if camp_change_influence_info then
                local need_update_draw_camp_change_influence_info = false
                for i, v in pairs(camp_change_influence_info._defenders) do
                    if v.defenderST == "9" and v.defAState == "1" and tonumber(v.defenderPos) == tonumber(currentAttacker._info._pos) then
                        need_update_draw_camp_change_influence_info = true
                        break
                    end
                end

                if need_update_draw_camp_change_influence_info == true then
                    state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "" .. battleTag)
                end
            end
        end
        ----------------------------------

    end


end

function FightRoleController:qteExecuteRoleAttack(selectRole)
    if self.isPvEType ~= true then
        return
    end
    table.insert(self.auto_queue, selectRole)
    local isPlayScoreAni = false
    if #self.auto_wait_queue ~= 0 or _ED._fightModule:checkAttackSell() == true then
        -- print("手动攻击还没有完成")
        --self:restartQTETimer()
    else
        -- print("手动攻击完成，进入评分状态")
        if table.getn(self.auto_double_hit_queue) > 1 then
            isPlayScoreAni = true
            -- state_machine.excute("fight_qte_controller_update_fight_score_info", 0, self.auto_double_hit_queue)
        end
    end
    if #self.auto_double_hit_queue > 0 then
        state_machine.excute("fight_qte_controller_update_fight_comkill_info", 0, {hitList = self.auto_double_hit_queue, playScoreAni = isPlayScoreAni, totalHurt = self.roundMakeHurtNum})
    end
    state_machine.excute("fight_ui_update_auto_fight_time",0, {time = 0, isShowAuto = false})
    state_machine.excute("fight_role_change_to_next_attack_role", 0, selectRole)
end

function FightRoleController:qteAddAttackRole(selectRole)
    if selectRole.isBeginHeti == false then
        if not selectRole._isAnimal then
            selectRole.qteOver = true
        end
    end
    if _ED._fightModule == nil or _ED._fightModule:checkAttackSell(true) == false then
        return false
    end
    local hitCount = table.getn(self.auto_double_hit_queue)

    local dataNums = dms.count(dms["operate_addition"])
    local row = (hitCount + 1) >= dataNums and dataNums or (hitCount + 1)

    local comKillScore = dms.string(dms["operate_addition"], row, (5 - selectRole.comKill) * 2 + 2)
    local roleFightData = self:getFightData(selectRole, comKillScore)
    if roleFightData ~= nil then
        if selectRole.isBeginHeti == false then
            self.qte_fighting = true
            table.insert(self.auto_double_hit_queue, {selectRole.comKill, selectRole._open_hit_count})
            table.insert(self.haveAttackedList, selectRole)
        end
        self.attack_list = {}
        self.attack_swap = {}
        self.firstRole = nil
        self:executeCurrentSelectRoleFightData(roleFightData)
        self:calcComkillHurtNum(selectRole)
        return true
    else
        -- print("role fight date nil")
    end
    return false
end

function FightRoleController:calcComkillHurtNum( fightRole )
    self.qteProgressPos = 0
    local function printHurtCount( skf )
        if skf ~= nil then
            for w = 1, zstring.tonumber(skf.defenderCount) do
                local _def = skf._defenders[w]
                if _def ~= nil then
                    local stValue = _def.stValue
                    local defender = _def.defender
                    local defenderPos = tonumber(_def.defenderPos)
                    if _def.defenderST == "0" then
                        self.roundMakeHurtNum = self.roundMakeHurtNum + tonumber(stValue)
                    end
                    if tonumber(defender) ~= 0 and (tonumber(self.qteProgressPos) > tonumber(defenderPos) or tonumber(self.qteProgressPos) == 0) then
                        self.qteProgressPos = defenderPos
                    end
                end
            end
        end 
    end

    if fightRole ~= nil and tonumber(fightRole.roleCamp) == 0 then
        if fightRole.__fit_roles ~= nil and #fightRole.__fit_roles >= 1 then
            for roleIndex, role in pairs(fightRole.__fit_roles) do
                if role ~= nil and role.fight_fit_cacher_pool ~= nil then
                    for fitIndex, fit in pairs(role.fight_fit_cacher_pool) do
                        printHurtCount(fit.__skf)
                    end
                end
            end
        end
        if fightRole.fight_cacher_pool ~= nil and #fightRole.fight_cacher_pool >= 1 then
            for fightIndex, fightData in pairs(fightRole.fight_cacher_pool) do
                if fightData ~= nil then
                    printHurtCount(fightData.__skf)
                end
            end
        end
    end
end

function FightRoleController:qteToNextAttackRole(params)
    if self.isPvEType ~= true then
        return
    end
    if self.auto_fighting == false then
        -- 当前点击角色
        local selectRole = params[1]
        local dIndex = params[2]
        self:removeBeAttackerEffect()
        if selectRole == nil or selectRole.parent == nil or selectRole.qteOver == true then
            return
        end
        if #self.auto_queue == 0 then
            if dIndex > 4 then
                dIndex = 4
                self._open_hit_count = false
            else
                self._open_hit_count = true
            end
            selectRole._open_hit_count = self._open_hit_count
            selectRole.comKill = dIndex
            local flag = self:qteAddAttackRole(selectRole)
            if flag == true then
                if table.getn(self.auto_double_hit_queue) > 1 then
                    if true == self.auto_select then
                        selectRole._play_pinjia_ani = dIndex
                    else
                        state_machine.excute("fight_qte_controller_play_pinjia_ani", 0, dIndex)
                    end
                end
                self.currentAttackCount = self.currentAttackCount + 1
                self:checkProgressState(selectRole)
                self:qteExecuteRoleAttack(selectRole)
                state_machine.excute("fight_qte_controller_enter_next_auto_fight", 0, selectRole)
            else
                self:checkAttackerRoundOver()
            end
            self._open_hit_count = true
        else
            if _ED._fightModule ~= nil and _ED._fightModule:checkAttackSell() == true then
                local isHaveSameRole = false
                for i,v in ipairs(self.auto_wait_queue) do
                    if v == selectRole then
                        -- print("角色已经响应在等待队列中。。。。。。")
                        return
                    end
                end
                if missionIsOver() == false then
                    __________b = true
                end
                if true == self.auto_select then
                    selectRole._play_pinjia_ani = dIndex
                else
                    state_machine.excute("fight_qte_controller_play_pinjia_ani", 0, dIndex)
                end
                self._open_hit_count = true
                selectRole._open_hit_count = self._open_hit_count
                if dIndex > 4 then
                    dIndex = 4
                end
                selectRole.comKill = dIndex
                self:checkProgressState(selectRole)
                table.insert(self.auto_wait_queue, selectRole)
                state_machine.excute("fight_qte_controller_enter_next_auto_fight", 0, selectRole)
            end
        end
        



        -- local _currentRole = params[1]
        -- local dIndex = params[2]
        -- local doAttack = false
        -- local waitAttack = false
        -- self.qte_fighting = true

        -- local function checkQteFightRoleLogic( qteRole, index )
        --     if #self.auto_queue == 0 then
        --         doAttack = true
        --         table.remove(self.attack_list, ""..index)
        --         -->__crint("查找到行动的角色：", qteRole._info._name, qteRole._info._pos)
        --         table.insert(self.auto_queue, qteRole)
        --         table.insert(self.auto_double_hit_queue, dIndex)
        --         state_machine.excute("fight_ui_update_auto_fight_time",0, {time = 0, isShowAuto = false})
        --         state_machine.excute("fight_role_change_to_next_attack_role", 0, qteRole)
        --         state_machine.excute("fight_qte_controller_enter_next_auto_fight", 0, qteRole)
        --         return true
        --     else
        --         waitAttack = true
        --         local isHaveSameRole = false
        --         for i,v in ipairs(self.auto_wait_queue) do
        --             if v == qteRole then
        --                 isHaveSameRole = true
        --             end
        --         end
        --         if not isHaveSameRole then
        --             table.remove(self.attack_list, ""..index)
        --             table.insert(self.auto_wait_queue, qteRole)
        --             -->__crint("添加到队列的角色：", qteRole._info._name, qteRole._info._pos)
        --             local activeRole = self.auto_queue[1]
        --             if activeRole.roleAttacking == true then
        --                 table.insert(self.auto_double_hit_queue, dIndex)
        --                 --self.auto_double_hit_queue[qteRole._info._pos] = qteRole
        --             end
        --         end
        --         return not isHaveSameRole
        --     end
        -- end

        -- for i, v in pairs(self.attack_list) do
        --     if v == _currentRole then
        --         checkQteFightRoleLogic( v, i )
        --     -- 点击屏幕外，自动选择列表第一位攻击
        --     elseif _currentRole == nil then
        --         if v.roleCamp == 0 then
        --             _currentRole = v
        --             if checkQteFightRoleLogic( v, i ) then
        --                 break
        --             end
        --         end
        --     end
        -- end
        -- if doAttack == true then
        --     self:checkToAutoFight()
        -- else
        --     if waitAttack == true then
        --         -->__crint("角色加入到等待队列。")
        --     else
        --         -->__crint("无效的行动角色：", _currentRole._info._name, _currentRole._info._pos)
        --     end
        -- end
    else
        -->__crint("当前是自动战斗状态。")
    end
end

function FightRoleController:checkProgressState( selectedRole )
    local result = {state = false, fightRole = selectedRole}
    table.insert(self.wakeUpProgressList, result)
    local resultState = state_machine.excute("fight_qte_controller_get_qte_state", 0, dIndex)
    if resultState == false then
        local count = #self.wakeUpProgressList
        for i,v in ipairs(self.wakeUpProgressList) do
            if i == count then
                v.state = true
            else
                v.state = false
            end
        end
    end
end

function FightRoleController:checkToAutoFight( ... )
    local autoFighting = false
    local isHaveMyCampRole = false
    for i, v in pairs(self.attack_list) do
        if v.roleCamp == 0 then
            isHaveMyCampRole = true
        end
    end
    if #self.auto_wait_queue == 0 and not isHaveMyCampRole then
        autoFighting = true
    end
    self.auto_fighting = autoFighting
    if autoFighting == true then
        if #self.auto_double_hit_queue > 1 then
            state_machine.excute("fight_qte_controller_update_fight_score_info", 0, nil)
        end
        self.auto_double_hit_queue = {}
        self.haveAttackedList = {}
        self.qte_fighting = false
        -- print("进入敌方自动战斗状态")
    end
end

function FightRoleController:restartQTETimer(params)
    if self.isPvEType ~= true then
        return
    end
    local nextRole = self.attack_list[1]
    if #self.auto_wait_queue ~= 0 or (_ED._fightModule ~= nil and _ED._fightModule:checkAttackSell() == true and (nil == nextRole or nextRole.roleCamp == 0)) then
        -- print("重置qte时间状态")
        self.qte_fighting = false
        self.auto_fighting = false
        local autoState = state_machine.excute("fight_ui_update_fight_get_auto_state", 0, nil)
        if autoState == true then
            self.auto_intervel = 0
        else
            self.auto_intervel = self.auto_duration1
        end
    end
end

function FightRoleController:checkCurrentRoleListState(_roundData, _role)
    for i = 1, _roundData.curAttackCount do
        local attData = _roundData.roundAttacksData[i]
        local fightRole = attData.attacker == "0" and self._hero_formation[attData.attackerPos] or self._master_formation[attData.attackerPos]

        function checkFitAttackerDeath( defender )
            local isHaveDeath = false
            for m = 1, _roundData.curAttackCount do
                local attData = _roundData.roundAttacksData[m]
                if tonumber(attData.linkAttackerPos) > 0 then
                    local fitCount = #attData.fitHeros
                    for k = 1, fitCount do
                        local fitAttData = attData.fitHeros[k]
                        if defender == fitAttData.attacker then
                            local defendRole = defender == "0" and self._hero_formation[fitAttData.attackerPos] or self._master_formation[fitAttData.attackerPos]
                            if defendRole ~= nil then
                                isHaveDeath = true
                            end
                        end
                    end
                end
            end
            return isHaveDeath
        end
        
        -- if tonumber(attData.attackerForepartBuffState) ~= 0 then  -- 出手方是否有buff影响(0:没有 1:有)
        --     if attData.attackerForepartBuffDeath == "1" then  -- 攻击方BUFF生存状态(0:存活 1:死亡)
        --         if fightRole == _role then
        --             return true
        --         end
        --         if checkFitAttackerDeath(_role.roleCamp) == true then
        --             return true
        --         end
        --     end
        -- end
        
        for j = 1, attData.skillInfluenceCount do
            local _skf = attData.skillInfluences[j]
            for w = 1, _skf.defenderCount do
                local _def = _skf._defenders[w]
                -- if _def.defender ~= _skf.attackerType then
                    if _def.stVisible == "1" then
                        local defenderST = _def.defenderST
                        local defAState = _def.defAState
                        if -- defenderST ~= "0" or 
                            defAState == "1" then
                            local defendRole = _def.defender == "0" and self._hero_formation[_def.defenderPos] or self._master_formation[_def.defenderPos]
                            if defendRole == _role then
                                return true
                            end
                            if checkFitAttackerDeath(_def.defender) == true then
                                return true
                            end
                        end
                    end
                -- end
            end
        end

        if tonumber(attData.linkAttackerPos) > 0 then --如果有合体技能
            local fitCount = #attData.fitHeros
            for k = 1, fitCount do
                local fitAttData = attData.fitHeros[k]
                for j = 1, fitAttData.skillInfluenceCount do
                    local _fitSkf = fitAttData.skillInfluences[j]
                    for w = 1, _fitSkf.defenderCount do
                        local _def = _fitSkf._defenders[w]
                        -- if _def.defender ~= _fitSkf.attackerType then
                            if _def.stVisible == "1" then
                                local defenderST = _def.defenderST
                                local defAState = _def.defAState
                                if -- defenderST ~= "0" or 
                                    defAState == "1" then
                                    local defendRole = _def.defender == "0" and self._hero_formation[_def.defenderPos] or self._master_formation[_def.defenderPos]
                                    if defendRole == _role then
                                        return true
                                    end
                                    if checkFitAttackerDeath(_def.defender) == true then
                                        return true
                                    end
                                end
                            end
                        -- end
                    end
                end
            end
        end
        
        for j = 1, attData.skillAfterInfluenceCount do
            local _skf = attData.skillAfterInfluences[j]
            for w = 1, _skf.defenderCount do
                local _def = _skf._defenders[w]
                local defenderST = _def.defenderST
                local defAState = _def.defAState
                if -- defenderST ~= "0" or 
                    defAState == "1" then
                    local defendRole = _def.defender == "0" and self._hero_formation[_def.defenderPos] or self._master_formation[_def.defenderPos]
                    if defendRole == _role then
                        return true
                    end
                end
            end
        end
        
        if tonumber(attData.attackerBuffState) ~= 0 then  -- 出手方是否有buff影响(0:没有 1:有)
            if attData.attackerBuffDeath == "1" then
                if fightRole == _role then
                    return true
                end
            end
        end
    end
    return false
end

function FightRoleController:fightEndAll( ... )
    self.isWaitDeathOver = false
    self.isResumeTimeLine = false
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        __fight_recorder_action_time_speed_index = __fight_recorder_action_time_speed_index or 1
        if nil ~= _fight_time_scale then
            cc.Director:getInstance():getScheduler():setTimeScale(_fight_time_scale[__fight_recorder_action_time_speed_index])
        else
            cc.Director:getInstance():getScheduler():setTimeScale(1.0 * __fight_recorder_action_time_speed_index)
        end
        state_machine.excute("fight_qte_controller_change_time_speed", 0, 0)
    else
        cc.Director:getInstance():getScheduler():setTimeScale(1)
    end
    -- print("fightEndAll:", self.current_fight_index, _ED.battleData.battle_total_count, _ED.attackData.isWin, self.role_celebrate_count)
    if self.current_fight_index >= _ED.battleData.battle_total_count or _ED.attackData.isWin == "0" then
        if self.role_celebrate_count == 0 then
            self:checkAllRoleDeathed()
            -- if self.role_celebrate_count == 0 then
            --     self:checkNextFight()
            -- end
            self:checkNextFight()
            self.open_camera = true
        end
    else
        self:checkNextFight()
        self.open_camera = true
    end
end

-- 下一回合，下一波战斗
function FightRoleController:nextRoundFight()
    if missionIsOver() == true then
        local windowLock = fwin:find("WindowLockClass")
        if windowLock ~= nil then
            fwin:close(windowLock)
        end
    end
    if self.current_fight_over == true then
        return
    end

    -- state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "0")

    local current_logic_round = self.current_fight_round
    local isHaveNextRound = true
    if _ED._fightModule ~= nil and FightRole.__skeep_fighting == false then
        self.current_fight_round = _ED._fightModule.roundCount
        isHaveNextRound = _ED._fightModule.hasNextRound

        current_logic_round = self.current_fight_round
    else
        self.current_fight_round = self.current_fight_round + 1
        current_logic_round = self.current_fight_round
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
            if table.nums(_ED.attackData.roundData) > 0 then
                local _roundData = _ED.attackData.roundData[1]
                current_logic_round = tonumber(_roundData.currentRound)

                -- 上一局的战斗数据
                local lastRoundData = _ED.attackData._currentRoundData
                if nil ~= lastRoundData then
                    local lastRound = tonumber(lastRoundData.currentRound)
                    -- print("current_logic_round = ", current_logic_round, " lastRound  = ", lastRound)

                    if lastRound == 10 then
                        _ED.attackData._currentRoundData = nil
                            
                        -- 战斗结束后，重新校验攻防双方血量，根据血量百分比计算战斗胜利方
                        -- 剩余血量 / 总血量
                        local attackerLessHpPercent = 0
                        local beAtackerLessHpPercent = 0

                        for k,v in pairs(self._hero_formation_ex) do
                           local curAttackerHp = v.armature._role._hp
                           local attackerMaxHp = v._info._max_hp
                           attackerLessHpPercent = curAttackerHp / attackerMaxHp
                        end
                        for k,v in pairs(self._master_formation_ex) do
                            local curDefenderHp = v.armature._role._hp
                            local beAttackerMaxHp = v._info._max_hp
                            beAtackerLessHpPercent = curDefenderHp / beAttackerMaxHp
                        end

                        local kingsBattleWithLessBlood = attackerLessHpPercent < beAtackerLessHpPercent and 0 or 1
                        -- print("kingsBattleWithLessBlood = ", kingsBattleWithLessBlood, " attackerLessHpPercent = ", attackerLessHpPercent, " beAtackerLessHpPercent = ", beAtackerLessHpPercent)

                        local tempFormation = {}
                        if kingsBattleWithLessBlood == 0 then
                            tempFormation = self._hero_formation_ex
                        elseif kingsBattleWithLessBlood == 1 then
                            tempFormation = self._master_formation_ex
                        end
                        for i, v in pairs(tempFormation) do
                            -- print("v = ", v._info._id, v._info._pos, v.roleCamp)
                            state_machine.excute("fight_role_be_killed", 0, v)
                        end
                        FightRole.__priority_camp = -1
                    end
                end

                -- if 11 == self.current_fight_round then
                --     self.current_fight_round = 1
                --     local tempFormation = nil
                --     if FightRole.__priority_camp == 0 then
                --         tempFormation = self._hero_formation_ex
                --     else
                --         tempFormation = self._master_formation_ex
                --     end
                --     for i, v in pairs(tempFormation) do
                --         state_machine.excute("fight_role_be_killed", 0, v)
                --     end
                --     FightRole.__priority_camp = -1
                -- end
            else
                if nil ~= _ED.attackData._currentRoundData then
                    current_logic_round = tonumber(_ED.attackData._currentRoundData.currentRound)
                end
            end
        end
    end
    
    -- print("nextRoundFight", isHaveNextRound, self.current_fight_round, current_logic_round, _ED.attackData.roundCount, isHaveNextRound, table.nums(_ED.attackData.roundData))
    
    local fightOrderList = nil

    state_machine.excute("draw_hit_damage_exit", 0, nil)
    if isHaveNextRound == false or self.current_fight_round > _ED.attackData.roundCount or (_ED._fightModule == nil and table.nums(_ED.attackData.roundData) == 0) then
        self.current_fight_round = _ED.attackData.roundCount
        state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "0")
        state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "1")
        self.current_fight_round = self.current_fight_round + 1
        state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "0")
        state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "1")
        local currentAuto = state_machine.excute("fight_ui_update_fight_get_auto_state", 0, nil)
        self:saveAsAuFightType(currentAuto)
        self.isRoundOver = true
        if self:cleanDeathedRole() == true then
            self.isWaitDeathOver = true
            self.isWaitDeathOverDelay = 2
            return
        end
        self:fightEndAll()
    else
        if FightRole.__skeep_fighting == true then
            return
        end
        if __________b == true then
            __________b = false
            return
        end
        -- 更新战斗的回合数
        state_machine.excute("fight_total_round_count", 0, {current_logic_round})
        if current_logic_round ~= self.last_fight_round then
            self.last_fight_round = current_logic_round

            -- print("更新回合数: " .. self.last_fight_round)
            if self.isPvEType == true then
                fightOrderList = _ED._fightModule:resetAllRoleSkillStatus()
            end

        end

        -- 切换到新的回合的时候，判断是否有人被烧死，做刷新
        if self.current_fight_round ~= self.last_fight_round_data then

            if _ED.battleData._camp_change_influence_infos then
                local battleTag = 0
                local key = "" .. self.last_fight_round_data .. "-" .. battleTag
                local camp_change_influence_info = _ED.battleData._camp_change_influence_infos[key]
                if camp_change_influence_info then
                    local need_update_draw_camp_change_influence_info = false
                    for i, v in pairs(camp_change_influence_info._defenders) do
                        if v.defenderST == "9" and v.defAState == "1" then
                            need_update_draw_camp_change_influence_info = true
                            break
                        end
                    end

                    if need_update_draw_camp_change_influence_info == true then
                        self:updateDrawCampChangeInfluenceInfo_2(self.last_fight_round_data .. "-" .. 0)
                    end
                end

            end

            if _ED.battleData._camp_change_influence_infos then
                local battleTag = 1
                local key = "" .. self.last_fight_round_data .. "-" .. battleTag
                local camp_change_influence_info = _ED.battleData._camp_change_influence_infos[key]
                if camp_change_influence_info then
                    local need_update_draw_camp_change_influence_info = false
                    for i, v in pairs(camp_change_influence_info._defenders) do
                        if v.defenderST == "9" and v.defAState == "1" then
                            need_update_draw_camp_change_influence_info = true
                            break
                        end
                    end

                    if need_update_draw_camp_change_influence_info == true then
                        self:updateDrawCampChangeInfluenceInfo_2(self.last_fight_round_data .. "-" .. 1)
                    end
                end

            end

            -- 记录真实的上一回合的回合数，self.last_fight_round不准确，在王者之战中回合数会被不停的重置
            self.last_fight_round_data = self.current_fight_round
        end
        
        state_machine.excute("draw_hit_damage_check_window", 0, nil)
        --state_machine.excute("fight_qte_controller_role_by_active", 0, {checkAttackRole = false})
        if self.isNextAuto ~= nil then
            self.isAuto = self.isNextAuto
        
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                or __lua_project_id == __lua_project_l_naruto 
                then
                self.auto_select = self.isAuto
                self.isAuto = false
            end
        end

        if self.isAuto == false then
            -- print("一个回个结束，清空状态.....")
            self.auto_fighting = false
            self.auto_intervel = self.auto_duration
            self.isCalcTotalKillNum = false
        end
        self.auto_queue = {}
        self.auto_wait_queue = {}
        self.auto_double_hit_queue = {}
        self.roundMakeHurtNum = 0
        self.wakeUpProgressList = {}

        self.haveAttackedList = {}

        self.isStopFight = false
        self.guideTime = 0
        self.guideNeedClick = false
        self.current_mission = nil

        if self.isPvEType == true then
            local currentAuto = state_machine.excute("fight_ui_update_fight_get_auto_state", 0, nil)
            if currentAuto == true or self.isNextAuto then
                self.isAuto = true
                self.auto_fighting = true
                state_machine.excute("fight_ui_update_auto_fight_time",0, {time = 0, isShowAuto = true})
            else
                self.isAuto = false
                self.auto_fighting = false
                self.auto_intervel = self.auto_duration
            end
            self:saveAsAuFightType(currentAuto)

            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                or __lua_project_id == __lua_project_l_naruto 
                then
                self.auto_select = self.isAuto
                self.isAuto = false
                self.auto_fighting = false
            end
        else
            self.isAuto = true
            self.auto_fighting = true
        end
        if MissionClass._isFirstGame == true then
            MissionClass._isFirstGame = false
            self.auto_fighting = true
            state_machine.excute("fight_qte_controller_change_visible", 0, false)
        else
            state_machine.excute("fight_qte_controller_change_visible", 0, true)
        end

        -- print("进入下一回合的战斗数据处理")
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            if _ED._fightModule ~= nil then
                state_machine.excute("fight_ui_update_battle_round_count", 0, ""..current_logic_round .."/".._ED._fightModule.totalRound)
            else
                state_machine.excute("fight_ui_update_battle_round_count", 0, ""..current_logic_round .."/".._ED.attackData.totalRoundCount)
            end
            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
                state_machine.excute("the_kings_battle_ui_window_update_draw_round_count", 0, current_logic_round)
            end
            state_machine.excute("fight_role_controller_update_draw_round_influence_info")
        else
            state_machine.excute("fight_ui_update_battle_round_count", 0, ""..current_logic_round .."/".."20")
        end
        for index, hero in pairs(self._hero_formation) do
            if hero.__attack_permit ~= false then
                hero.__attack_permit = false
            end
            hero.attackerList = {}  
            hero.qteOver = false
            hero.comKill = 0
        end
        for index, master in pairs(self._master_formation) do
            if master.__attack_permit ~= false then
                master.__attack_permit = false
            end
            master.attackerList = {}
        end

        -- 更新神兽怒气值UI
        self.current_logic_round = current_logic_round

        local animalRoundData = _ED.animalRoundData and _ED.animalRoundData[current_logic_round]
        local animalData = nil
        if animalRoundData then
            local animalInfoData = animalRoundData.animalInfoData
            animalData = table.remove(animalInfoData, 1)
        end

        -- print("开场时 current_logic_round = ", current_logic_round)
        -- debug.print_r(animalData, "animalData")

        state_machine.excute("fight_ui_update_animal_anger_progress", 0, animalData)
        state_machine.excute("fight_ui_update_animal_skill_state", 0, animalData)

        -- _ED._fightModule:resetActionStatus()
        -- _ED._fightModule:clearPowerSkillState(0)

        -- local fightOrderList = nil
        -- if self.isPvEType == true then
        --     fightOrderList = _ED._fightModule:resetAllRoleSkillStatus()
        -- end

        -- print("回合开始时 nextRoundFight self.auto_fighting = ", self.auto_fighting)

        if self.auto_fighting == true then
            self:executeCurrentRountFightData()
            state_machine.excute("fight_qte_controller_role_by_active", 0, "lock")
        else
            --0:无人,1:正常普通技能,2:死亡,3:眩晕 4:怒气技能 5:合体技能 6:怒气+合体
            if _ED._fightModule ~= nil then
                local states = _ED._fightModule:checkSelfAttackStatus()
                local isAttackState = _ED._fightModule:checkAttackSell(true)
                if isAttackState == true then
                    -- FightRole._current_attack_camp = 0
                    -- self:cleanBuffState(nil, 0)
                    if false == missionIsOver() then
                    else
                        _ED._fightModule:resetAction(0)
                    end
                    state_machine.excute("fight_qte_controller_role_by_active", 0, "active")
                    self:wakeUpBeAttackerEffect()
                else
                    if _ED._fightModule:checkByAttackSell() ~= true then
                        _ED._fightModule:resetAction(1)
                        if true ~= _ED._fightModule:checkByAttackSell() then
                            -- fwin:addService({
                            --     callback = function ( params )
                            --         print(".............")
                                    local resultBuffer = {}
                                    _ED._fightModule:rountdFight(resultBuffer)
                                    _ED._fightModule:executeRevived(1)
                                    -- state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                                    -- state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                                    self:nextRoundFight()
                            --     end,
                            --     delay = 0.01,
                            --     params = self
                            -- })
                        else
                            self:checkAttackerRoundOver()
                        end
                        return
                    else
                        -- FightRole._current_attack_camp = 1
                        -- self:cleanBuffState(nil, 1)
                        if false == missionIsOver() then
                        else
                            _ED._fightModule:resetAction(1)
                        end
                        self:checkAttackerRoundOver()
                        -- self:executeCurrentRountFightData()
                    end
                end
                if self.isPvEType == true and isAttackState == true then
                    for i,v in pairs(states) do
                        -- print("初始化手操攻击状态，", i, v)
                        -- for index, hero in pairs(self._hero_formation) do
                        --     if hero ~= nil and hero._info ~= nil and hero._info._pos == i then
                        --         -- print("-----------", i, v, hero._info._name)
                        --         hero.is_dizziness = tonumber(v) == 3
                        --     end
                        -- end
                        state_machine.excute("fight_qte_controller_init_role_qte_state", 0, {slot = i, state = v})
                    end
                    -- print("wait auto cd!")

                    if nil ~= fightOrderList then
                        for i, v in pairs(fightOrderList) do
                            if tonumber(v.battleTag) == 0 and true == v.normalSkillMouldOpened then
                                state_machine.excute("fight_qte_controller_init_role_qte_state", 0, {slot = v.coordinate, state = 7})
                            end
                        end
                    end
                    state_machine.unlock("fight_role_controller_select_by_attack_role")
                end
            end
        end

        -- 自动选择目标进行攻击
        if true == self.auto_select then
            -- print("自动选择目标进行攻击")
            fwin:addService({
                callback = function ( params )
                    FightRoleController.__lock_battle = false
                    state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, 0)
                    state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                    state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                end,
                delay = 0.01,
                params = self
            })
        else
            -- 手动模式时 魅惑角色先攻击
            state_machine.excute("fight_qte_controller_qte_to_auto_chram_attack_role", 0, 0)
            -- 手动模式 神兽攻击
            local canAttack, canAttackAnimal, animaldIndex = state_machine.excute("fight_qte_controller_qte_to_auto_animal_start_attack", 0, 0)
            if canAttack == true then
                state_machine.excute("fight_role_controller_qte_to_next_attack_role", 0, {canAttackAnimal, animaldIndex})
            end
        end
    end
end

function FightRoleController:executeCurrentRountFightData()
    local _roundData = nil
    if _ED._fightModule ~= nil then
        _roundData = self:getFightData(nil, 0)
    else
        -- _roundData = _ED.attackData.roundData[self.current_fight_round]
        _roundData = table.remove(_ED.attackData.roundData, "1")
        -- print("当前的回合数：", _roundData.currentRound)
        _ED.attackData._currentRoundData = _roundData
    end

    self.attack_list = {}
    -- self.attack_swap = {}
    -- self.firstRole = nil
    if nil ~= _roundData then
        for i = 1, _roundData.curAttackCount do
            local attData = _roundData.roundAttacksData[i]
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                self:executeCurrentSelectRoleFightDataAddAttacker(attData, _roundData)
                -- print("添加自动战斗的数据")
            else
                self:executeCurrentSelectRoleFightData(attData, _roundData)
            end
        end
    else
        -- print("没有行动数据")
    end
    -- for i, v in pairs(self.attack_swap) do
    --     table.insert(self.attack_list, v)
    -- end
    -- self.attack_swap = {}
    -- state_machine.excute("fight_role_controller_start_round_fight", 0, 0)
    state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, nil)
    self:removeBeAttackerEffect()
    -- set attack role with gray
    --state_machine.excute("fight_qte_controller_role_by_active", 0, false)
end


function FightRoleController:executeCurrentSelectRoleFightData(attData, _roundData, lazy)
    local skillElementData = dms.element(dms["skill_mould"], attData.skillMouldId)
    local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)      -- 技能类型(0:普通 1:怒气)
    local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)    -- 技能属性(0:物理 1:法术)

    local fightRole = attData.attacker == "0" and self._hero_formation[attData.attackerPos] or self._master_formation[attData.attackerPos]

    if tonumber(attData.attackerPos) > 6 then
        fightRole = attData.attacker == "0" and self._hero_animal_formation[attData.attackerPos] or self._master_animal_formation[attData.attackerPos]
    end

    if nil == fightRole.fight_cacher_pool or #fightRole.fight_cacher_pool > 0 then
        return
    end
    -- if fightRole == nil then
    --     __G__TRACKBACK__(self.pveFightInfoString)
    -- end
    fightRole._firstPos = nil
    fightRole._skill_quality = skillQuality
    fightRole._skill_property = skillProperty
    if lazy then

    else
        if self.firstRole == nil then
            table.insert(self.attack_list, fightRole)
            self.firstRole = fightRole
        else
            -- if self.firstRole.roleCamp == fightRole.roleCamp then
                table.insert(self.attack_list, fightRole)
            -- else
            --     if _roundData ~= nil and self:checkCurrentRoleListState(_roundData, fightRole) then
            --         for i, v in pairs(self.attack_swap) do
            --             table.insert(self.attack_list, v)
            --         end
            --         self.attack_swap = {}
            --         table.insert(self.attack_list, fightRole)
            --     else
            --         table.insert(self.attack_swap, fightRole)
            --     end
            -- end
        end
    end

    if tonumber(attData.attackerForepartBuffState) ~= 0 then  -- 出手方是否有buff影响(0:没有 1:有)
        -- print("------::::->出手方有buff影响")
        fightRole._atkBuff = {}
        for zb=1, tonumber(attData.attackerForepartBuffState) do
            -- attData.attackerForepartBuffType[zb] = npos(list)   -- (有buff影响时传)影响类型(6为中毒,9为灼烧)
            -- attData.attackerForepartBuffValue[zb] = npos(list)  -- 影响值
            table.insert(fightRole._atkBuff, {nType = attData.attackerForepartBuffType[zb], nValue = attData.attackerForepartBuffValue[zb]})
        end

        fightRole._atkBuffDeath = false
        if attData.attackerForepartBuffDeath == "1" then  -- 攻击方BUFF生存状态(0:存活 1:死亡)
            -- attData.dropForepartType = npos(list)       --道具、战魂、装备
            -- attData.attackerForepartBuffDropCount = npos(list)
            fightRole._atkBuffDeath = true
            -- fightRole.run_fight_listener = true
        end
    end
    
    local heti = false;
    if tonumber(attData.linkAttackerPos) > 0 then --如果有合体技能
        heti = true;
        -- print("------ 出现了合体技能 -------")
        -- local skillElementData = dms.element(dms["skill_mould"], attData.skillMouldId)
        local skillInfluenceList = zstring.split(dms.atos(skillElementData, skill_mould.releas_skill), "|")
        for n = 1, #skillInfluenceList do
            skillInfluenceList[n] = zstring.split(skillInfluenceList[n], ",")
        end
        fightRole.run_fight_listener = true
        fightRole.__fit_roles = {}
        table.insert(fightRole.fight_cacher_pool, {__state = 0, __round = self.current_fight_round, __attData = attData, __fitAttData = attData, __skf = nil, __bySkf = nil, __attacker = nil, __fitAttacker = fightRole, __attackArmature = nil, __defenderList = nil, __def = nil})

        local fitCount = #attData.fitHeros
        for k = 1, fitCount do
            local fitAttData = attData.fitHeros[k]
            local fightFitRole = fitAttData.attacker == "0" and self._hero_formation[fitAttData.attackerPos] or self._master_formation[fitAttData.attackerPos]
            table.insert(fightRole.__fit_roles, fightFitRole)
            for j = 1, fitAttData.skillInfluenceCount do
                local _fitSkf = fitAttData.skillInfluences[j]
                local attackRole = _fitSkf.attackerType == "0" and self._hero_formation[_fitSkf.attackerPos] or self._master_formation[_fitSkf.attackerPos]
                attackRole.parent._fited = true
                local defenderList = {}
                local vailCount = 0
                for w = 1, _fitSkf.defenderCount do
                    local _def = _fitSkf._defenders[w]
                    -- if _def.defender ~= _fitSkf.attackerType then
                        -- if _def.stVisible == "1" then
                            local defendRole = _def.defender == "0" and self._hero_formation[_def.defenderPos] or self._master_formation[_def.defenderPos]
                            local defenderST = _def.defenderST
                            local defAState = _def.defAState
                            -- if defendRole == nil then
                            --     __G__TRACKBACK__(self.pveFightInfoString)
                            -- end
                            if defAState == "1" then
                                -->___crint("合体技能效用前段有角色死亡", defenderST)
                                -- defendRole.roleWaitDeath = true
                                defendRole.fitKiller = attackRole
                            end
                            defendRole.parent._fited = true
                            -- defendRole.attackerList[fightRole.roleCamp.."w"..fightRole._info._pos] = fightRole
            
                            defenderList["".._def.defender.."t".._def.defenderPos] = defendRole

                            -- print("技术效用的前段-防御者信息：", _def.defender, _def.defenderPos, defendRole, defenderST, defAState)
                            vailCount = vailCount + 1
                        -- end
                    -- end
                end
                if _fitSkf.defenderCount > 0 and vailCount > 0 then
                    -- print("给攻击者添加事件:", attackRole._info._pos)
                    attackRole.run_fight_listener = true
                    table.insert(attackRole.fight_fit_cacher_pool, {__state = 0, __round = self.current_fight_round, __attData = attData, __skf = _fitSkf, __bySkf = nil, __attacker = nil, __byFitAttacker = fightRole, __attackArmature = nil, __defenderList = defenderList, __def = nil})
                    -- for s, t in pairs(defenderList) do
                    --     -->___crint("给防御者添加事件")
                    --     t.run_fight_listener = true
                    --     table.insert(t.fight_cacher_pool, {__state = 1, __round = self.current_fight_round, __attData = attData, __skf = _fitSkf, __bySkf = nil, __attacker = attackRole, __attackArmature = nil, __defenderList = nil,  __def = nil})
                    -- end
                else
                    local _skillInfluenceId = skillInfluenceList[k][j]
                    table.insert(attackRole.fight_fit_cacher_pool, {__state = 0, __round = self.current_fight_round, __attData = attData, __skf = {skillInfluenceId = _skillInfluenceId}, __bySkf = nil, __attacker = nil, __byFitAttacker = fightRole, __attackArmature = nil, __defenderList = nil, __def = nil})
                end
            end
            
            if (fitAttData.skillInfluenceCount == 0) then
                local _skillInfluenceId = skillInfluenceList[k][1]
                fightFitRole.parent._fited = true
                table.insert(fightFitRole.fight_fit_cacher_pool, {__state = 0, __round = self.current_fight_round, __attData = attData, __skf = {skillInfluenceId = _skillInfluenceId}, __bySkf = nil, __attacker = nil, __byFitAttacker = fightRole, __attackArmature = nil, __defenderList = nil, __def = nil})
            end
            -- print("合体技效用数量：", #fightFitRole.fight_fit_cacher_pool)
        end
        local maxSkillInfluenceCount = 0
        for k = 1, fitCount do
            local fitAttData = attData.fitHeros[k]
            local mCount = fitAttData.fight_fit_cacher_pool == nil and 0 or #fitAttData.fight_fit_cacher_pool
            if mCount > maxSkillInfluenceCount then
                maxSkillInfluenceCount = mCount
            end
        end
        for k = 1, fitCount do
            local fitAttData = attData.fitHeros[k]
            local mCount = fitAttData.fight_fit_cacher_pool == nil and 0 or #fitAttData.fight_fit_cacher_pool
            local iCount = maxSkillInfluenceCount - mCount
            for si = 1, iCount do
                local _skillInfluenceId = skillInfluenceList[k][mCount + si]
                table.insert(attackRole.fight_fit_cacher_pool, {__state = 0, __round = self.current_fight_round, __attData = attData, __skf = {skillInfluenceId = _skillInfluenceId}, __bySkf = nil, __attacker = nil, __byFitAttacker = fightRole, __attackArmature = nil, __defenderList = nil, __def = nil})    
            end
        end
    end
    
    for j = 1, attData.skillAfterInfluenceCount do
        -- print("有技能效用后段, 实际什么也没有处理！！！")
        local _skf = attData.skillAfterInfluences[j]
        local attackRole = _skf.attackerType == "0" and self._hero_formation[_skf.attackerPos] or self._master_formation[_skf.attackerPos]
        
        for w = 1, _skf.defenderCount do
            local _def = _skf._defenders[w]
            local defendRole = _def.defender == "0" and self._hero_formation[_def.defenderPos] or self._master_formation[_def.defenderPos]
            local defenderST = _def.defenderST
            local defAState = _def.defAState
            -- defendRole.attackerList[fightRole.roleCamp.."w"..fightRole._info._pos] = fightRole
            if defAState == "1" then
                -- print("技能效用后段有角色死亡")
            end
        end
    end

    for j = 1, attData.skillInfluenceCount do
        local _skf = attData.skillInfluences[j]
        local attackRole = _skf.attackerType == "0" and self._hero_formation[_skf.attackerPos] or self._master_formation[_skf.attackerPos]

        if tonumber(_skf.attackerPos) > 6 then
            attackRole = _skf.attackerType == "0" and self._hero_animal_formation[_skf.attackerPos] or self._master_animal_formation[_skf.attackerPos]
        end

        -- print("技术效用的前段-攻击者信息：", _skf.attackerType, _skf.attackerPos, attackRole, attackRole.parent)
        local defenderList = {}
        local vailCount = 0
        for w = 1, _skf.defenderCount do
            local _def = _skf._defenders[w]
            -- if _def.defender ~= _skf.attackerType then
                if true then --_def.stVisible == "1"
                    local defendRole = _def.defender == "0" and self._hero_formation[_def.defenderPos] or self._master_formation[_def.defenderPos]

                    if tonumber(_def.defenderPos) > 6 then
                        defendRole = _def.defender == "0" and self._hero_animal_formation[_def.defenderPos] or self._master_animal_formation[_def.defenderPos]
                    end

                    if false == defendRole.is_killed then -- 防止战斗跳过，战斗报错
                        local defenderST = _def.defenderST
                        local defAState = _def.defAState
                        -- if defendRole == nil then
                        --     __G__TRACKBACK__(self.pveFightInfoString)
                        -- end
                        if defAState == "1" then
                            -->___("技能效用前段有角色死亡", defenderST)
                            -- defendRole.roleWaitDeath = true
                            defendRole.killer = attackRole
                            -- attackRole._show_kill_add_sp = true
                        end

                        defenderList["".._def.defender.."t".._def.defenderPos] = defendRole
                        -- defendRole.attackerList[fightRole.roleCamp.."w"..fightRole._info._pos] = fightRole
                
                        -- print("技术效用的前段-防御者信息：", _def.defender, _def.defenderPos, defendRole, defenderST, defAState)
                        vailCount = vailCount + 1

                        if nil ~= defendRole.parent then
                            defendRole:cleanBuffStateWithType("79")
                        end
                        

                        -- 把承受方里的第一个、并且是敌方，的位置给到_firstPos
                        if nil == fightRole._firstPos or defendRole.roleCamp ~= fightRole.roleCamp then
                            fightRole._firstPos = _def.defenderPos
                        end
                    end
                end
            -- end
        end
        if tonumber(_skf.defenderCount) > 0 and vailCount > 0 then
            -- print("给攻击者添加事件:", attackRole._info._name)
            attackRole.run_fight_listener = true
            if tonumber(attData.attackMovePos) == 11 
                then -- 绘图特殊处理
                if attData.skillInfluences[1].skillInfluenceId == _skf.skillInfluenceId and #attackRole.fight_cacher_pool > 0 then
                    attackRole.__fight_cacher_pool_temp = attackRole.__fight_cacher_pool_temp or {}
                    table.insert(attackRole.__fight_cacher_pool_temp, {__state = 0, __round = self.current_fight_round, __attData = attData, __skf = _skf, __bySkf = nil, __attacker = nil, __attackArmature = nil, __defenderList = defenderList, __def = nil})
                else
                    table.insert(attackRole.fight_cacher_pool, {__state = 0, __round = self.current_fight_round, __attData = attData, __skf = _skf, __bySkf = nil, __attacker = nil, __attackArmature = nil, __defenderList = defenderList, __def = nil})
                end
            else
                table.insert(attackRole.fight_cacher_pool, {__state = 0, __round = self.current_fight_round, __attData = attData, __skf = _skf, __bySkf = nil, __attacker = nil, __attackArmature = nil, __defenderList = defenderList, __def = nil})
            end
        
            -- for s, t in pairs(defenderList) do
            --     -->___crint("给防御者添加事件")
            --     t.run_fight_listener = true
            --     table.insert(t.fight_cacher_pool, {__state = 1, __round = self.current_fight_round, __attData = attData, __skf = _skf, __bySkf = nil, __attacker = attackRole, __attackArmature = nil, __defenderList = nil,  __def = nil})
            -- end
        end
    end
    
    if tonumber(attData.attackerBuffState) ~= 0 then  -- 出手方是否有buff影响(0:没有 1:有)
        -- print("出手方有后段BUFF，实际什么都没有处理！！！")
        for z=1, tonumber(attData.attackerBuffState) do
            -- attData.attackerBuffType[z] = npos(list)    -- (有buff影响时传)影响类型(6为中毒,9为灼烧)
            -- attData.attackerBuffValue[z] = npos(list)   -- 影响值
        end
        -- attData.attackerBuffDeath = npos(list)  -- 攻击方BUFF生存状态(0:存活 1:死亡)
        if attData.attackerBuffDeath == "1" then
            -- attData.dropType = npos(list)       --道具、战魂、装备
            -- attData.attackerBuffDropCount = npos(list)
        end
    end

    -- 有天赋技能
    if attData.attackerAfterTalent ~= nil then
        -- print("有天赋技能效用！！！ 数量为：", attData.attackerAfterTalentCount);
        for j = 1, attData.attackerAfterTalentCount do
            local _skf = attData.attackerAfterTalent[j]
            local attackRole = _skf.attackerType == "0" and self._hero_formation[_skf.attackerPos] or self._master_formation[_skf.attackerPos]
            -- print("天赋技能ID：", _skf.skillInfluenceId)
            local defenderList = {}
            local vailCount = 0
            for w = 1, _skf.defenderCount do
                local _def = _skf._defenders[w]
                if true then
                    local defendRole = _def.defender == "0" and self._hero_formation[_def.defenderPos] or self._master_formation[_def.defenderPos]
                    local defenderST = _def.defenderST
                    local defAState = _def.defAState
                    if defAState == "1" then
                        defendRole.killer = attackRole
                        -- attackRole._show_kill_add_sp = true
                    end
                    defenderList["".._def.defender.."t".._def.defenderPos] = defendRole
                    vailCount = vailCount + 1

                    if nil ~= defendRole.parent then
                        defendRole:cleanBuffStateWithType("79")
                    end

                    if nil == fightRole._firstPos or defendRole.roleCamp ~= fightRole.roleCamp then
                        fightRole._firstPos = _def.defenderPos
                    end
                end
            end
            -- 天赋技能，增加 __isTalent = true 天赋技能标志，合体技能和普通技能时，分开处理
            if _skf.defenderCount > 0 and vailCount > 0 then
                attackRole.run_fight_listener = true
                if heti == true then
                    table.insert(attackRole.fight_fit_cacher_pool, {__isTalent = true, __state = 0, __round = self.current_fight_round, __attData = attData, __skf = _skf, __bySkf = nil, __attacker = nil, __byFitAttacker = fightRole, __attackArmature = nil, __defenderList = defenderList, __def = nil})
                else
                    table.insert(attackRole.fight_cacher_pool, {__isTalent = true, __state = 0, __round = self.current_fight_round, __attData = attData, __skf = _skf, __bySkf = nil, __attacker = nil, __attackArmature = nil, __defenderList = defenderList, __def = nil})
                end
            end
        end
    end
    -- if heti == true then
    --     -- print("有合体技能时，fight_cacher_pool的长度为：", #fightRole.fight_cacher_pool)
    -- end
end

function FightRoleController:executeCurrentSelectRoleFightDataAddAttacker(attData, _roundData)
    local skillElementData = dms.element(dms["skill_mould"], attData.skillMouldId)
    local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)      -- 技能类型(0:普通 1:怒气)
    local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)    -- 技能属性(0:物理 1:法术)

    local fightRole = attData.attacker == "0" and self._hero_formation[attData.attackerPos] or self._master_formation[attData.attackerPos]

    if tonumber(attData.attackerPos) > 6 then
        fightRole = attData.attacker == "0" and self._hero_animal_formation[attData.attackerPos] or self._master_animal_formation[attData.attackerPos]
    end

    -- if fightRole == nil then
    --     __G__TRACKBACK__(self.pveFightInfoString)
    -- end
    -- fightRole._skill_quality = skillQuality
    -- fightRole._skill_property = skillProperty
    if self.firstRole == nil then
        table.insert(self.attack_list, fightRole)
        self.firstRole = fightRole
    else
        -- if self.firstRole.roleCamp == fightRole.roleCamp then
            table.insert(self.attack_list, fightRole)
        -- else
        --     if _roundData ~= nil and self:checkCurrentRoleListState(_roundData, fightRole) then
        --         for i, v in pairs(self.attack_swap) do
        --             table.insert(self.attack_list, v)
        --         end
        --         self.attack_swap = {}
        --         table.insert(self.attack_list, fightRole)
        --     else
        --         table.insert(self.attack_swap, fightRole)
        --     end
        -- end
    end
    fightRole._ecsrfd = fightRole._ecsrfd or {}
    table.insert(fightRole._ecsrfd, {attData, _roundData})
    -- print("len1:", #self.attack_list)
end

function FightRoleController:getFightData( fightRole, grade )
    local attData = {}
    local resultBuffer = {}
    if fightRole then
        -- 因 bug 6904 查到此处会在角色出手的时候清理身上的 buff, self.auto_double_hit_queue 会在大招释放完毕重置,所以不能用 self.auto_double_hit_queue来判断
        -- 这里 clean buff 的原因是第一个出手的角色会将本回合我方角色buff光效的回合数减1
        -- self.haveAttackedList 只会在回合结束的时候重置
        if table.getn(self.haveAttackedList) == 0 then
            self:cleanBuffState(nil, 0)
        end
        local attackObject = _ED._fightModule:getAppointFightObject(0, fightRole._info._pos)

        if fightRole._isAnimal == true then
            attackObject = _ED._fightModule:getAnimalFightObject(fightRole.roleCamp, fightRole._info._pos)
        end

        -- print("getFightData attackObject = ", attackObject.battleTag, attackObject.coordinate, attackObject.isAnimal)

        if attackObject == nil then
            -- print("获取单个战斗数据。。。。索引获取不到角色攻击对象")
            return nil
        end
        local poswerSkill = false
        if true ~= attackObject.skipSuperSkillMould and attackObject.skillPoint >= FightModule.MAX_SP then
            poswerSkill = true
        end

        if tonumber(_ED._fightModule.gradeAttack) > 0 and tonumber(grade) <= 0 then
            _ED._fightModule:setByAttackTargetTag(self.byAttackTargetTag)
        else
            _ED._fightModule:setGradeAttack(attackObject, grade, self.byAttackTargetTag)
        end

        -- self.byAttackTargetTag = 0
        if fightRole.isBeginHeti == true then
            _ED._fightModule:setFreeSkillTrue()
        end
        _ED._fightModule:fightObjectAttack(attackObject,resultBuffer)
        local resultString = ""
        for i,v in ipairs(resultBuffer) do
            resultString = resultString..v
        end
        -- print("单个战斗数据。。。。索引位置为：", fightRole._info._pos, resultString)
        self.pveFightInfoString = resultString
        if resultString == "" or resultString == nil then
            return nil
        end
        local lists = lua_string_split_line(resultString, "\r\n")
        local list = lua_string_splits(lists, " ")
        if list == "" then
            return nil
        end
        list.pos = 1
        parse_environment_fight_role_round_attack_data(nil,nil,0,nil,list,nil,attData)
        state_machine.lock("fight_role_controller_select_by_attack_role")
        -- state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
    else
        self:cleanBuffState(nil, 1)
        -- self.byAttackTargetTag = 0
        state_machine.lock("fight_role_controller_select_by_attack_role")
        state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
        _ED._fightModule:setFreeSkillTrue()
        _ED._fightModule:rountdFight(resultBuffer)
        local resultString = ""
        for i,v in ipairs(resultBuffer) do
            resultString = resultString..v
        end
        -- print("获取一轮战斗数据...="..resultString)
        self.pveFightInfoString = resultString
        if resultString == "" or resultString == nil then
            return nil
        end
        local lists = lua_string_split_line(resultString, "\r\n")
        local list = lua_string_splits(lists, " ")
        if list == "" then
            return nil
        end
        list.pos = 1
        parse_environment_fight_round_attack_data(nil,nil,0,nil,list,nil,1)
        -- self.attack_list = {}
        -- local attack_swap = {}
        attData = _ED.attackData.roundData[1]
        -- local fristRole = nil
        -- for i = 1, _roundData.curAttackCount do
        --     local attData = _roundData.roundAttacksData[i]
        --     self:preseRoleFightData( attData, attack_swap, fristRole)
        -- end
        -- for i, v in pairs(attack_swap) do
        --     table.insert(self.attack_list, v)
        -- end
        -- attack_swap = {}
        -- state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, nil)

        -- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
        --     or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
        --     or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
        --     or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51
        --     or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_52 then
        --     fwin:addService({
        --         callback = function ( params )
        --             params:nextRoundFight()
        --         end,
        --         delay = 1.5,
        --         params = self
        --     })

        --     -- attData = nil
        -- end

        -- state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "" .. attData.roundAttacksData.attacker)
    end
    if _ED._fightModule and _ED._fightModule.hasNextRound == false then
        _ED.attackData.isWin = "" .. _ED._fightModule.fightResult
        _ED.attackData.roundCount = self.current_fight_round
    end
    return attData
end

function FightRoleController:updateDrawHpProgress(params)
    -- local camp = params[1]
    -- local subValue = params[2]
    -- if camp == 0 then
        -- self.heros_current_hp = self.heros_current_hp + subValue
        self.heros_current_hp = 0
        -- self.heros_total_hp = 0
        for i, v in pairs(self._hero_formation) do
            if v.parent ~= nil and v.armature ~= nil then
                self.heros_current_hp = self.heros_current_hp + v.armature._role._hp
                -- self.heros_total_hp = self.heros_total_hp + v._info._max_hp
            end
        end
        state_machine.excute("fight_ui_update_hp_progress", 0, {0, self.heros_current_hp, self.heros_total_hp})
    -- else
        -- self.masters_current_hp = self.masters_current_hp + subValue
        self.masters_current_hp = 0
        -- self.masters_total_hp = 0
        for i, v in pairs(self._master_formation) do
            if v.parent ~= nil and v.armature ~= nil then
                self.masters_current_hp = self.masters_current_hp + v.armature._role._hp
                -- self.masters_total_hp = self.masters_total_hp + v._info._max_hp
            end
        end
        state_machine.excute("fight_ui_update_hp_progress", 0, {1, self.masters_current_hp, self.masters_total_hp})
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            --刷新罗刹道场的血量文字百分比
            local per = math.floor((self.heros_current_hp/self.heros_total_hp)*100)
            state_machine.excute("trial_tower_battle_describe_add_hp_remainder_percent", 0, {_value = per })
        end
    -- end
end

function FightRoleController:readyFight()
    -- state_machine.excute("fight_scene_initialize_scene", 0, 0)
    for i, v in pairs(self._hero_formation) do
        if v ~= nil and v.parent ~= nil then
            state_machine.excute("fight_role_move_event", 0, v)
        end
    end

    for i, v in pairs(self._master_formation) do
        if v ~= nil and v.parent ~= nil then
            state_machine.excute("fight_role_move_event", 0, v)
        end
    end
    self:startFight()
end

function FightRoleController:startFight()
    -- print("开始战斗")
    self.open_camera = true
    state_machine.excute("fight_ui_init_heti_skill_state", 0, self._hero_formation_copy)

    -- 绘制战斗的ui信息
    state_machine.excute("fight_draw_ui", 0, 0)
    
    self.current_fight_index = self.current_fight_index + 1
    self.last_fight_round = 0
    self.last_fight_round_data = 0
    self.current_fight_round = 0

    self.current_fight_over = false

    local initHpInfo = true
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        if self.fightIndex > 1 and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_214 and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_219 and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_220 then
            initHpInfo = false
            _ED._fightModule:resetActionStatus()
        end
    end
    if true == initHpInfo then
        -- self.heros_current_hp = 0
        -- self.heros_total_hp = 0
        for i, v in pairs(self._hero_formation) do
            if v.parent ~= nil then
                local hrole = _ED.battleData._heros["" .. i]
                v:resetInfo(hrole)
                -- -- state_machine.excute("fight_role_check_move_event", 0, v)
                -- self.heros_current_hp = self.heros_current_hp + hrole._hp
                -- self.heros_total_hp = self.heros_total_hp + hrole._max_hp
            end
        end
        -- self.heros_current_hp = self.heros_total_hp

        for i, v in pairs(self._master_formation_ex) do
           if v.parent ~= nil then
                -- state_machine.excute("fight_role_check_move_event", 0, v)
            end
        end
    end

    -- 更新UI上面的血量显示
    state_machine.excute("fight_ui_update_hp_progress", 0, {0, self.heros_current_hp, self.heros_total_hp})
    state_machine.excute("fight_ui_update_hp_progress", 0, {1, self.masters_current_hp, self.masters_total_hp})

    self:nextRoundFight()
    state_machine.unlock("fight_skeep_fighting")

    fwin:addService({
        callback = function ( params )
            FightRoleController.__lock_battle = false
        end,
        delay = 0.3,
        params = self
    })
end

function FightRoleController:cleanBuffState(isDeathClean, campType)
    if nil == campType or campType == 0 then
        for i, v in pairs(self._hero_formation_ex) do
            if v.parent ~= nil then
                v:cleanBuffState(isDeathClean)
            end
        end

        for i, v in pairs(self._master_formation_ex) do
            if v.parent ~= nil then
                v:clearBuffState()
            end
        end
    end
    
    if nil == campType or campType == 1 then
        for i, v in pairs(self._hero_formation_ex) do
            if v.parent ~= nil then
                v:clearBuffState()
            end
        end

        for i, v in pairs(self._master_formation_ex) do
            if v.parent ~= nil then
                v:cleanBuffState(isDeathClean)
            end
        end
    end
end

function FightRoleController:cleanBuffStateWithType(campType, nType)
    local tempFormation = nil
    if 0 == campType then
        tempFormation = self._hero_formation_ex
    else
        tempFormation = self._master_formation_ex
    end

    for i, v in pairs(tempFormation) do
        if v.parent ~= nil then
            v:cleanBuffStateWithType(nType)
        end
    end 
end

-- 我方神兽创建
function FightRoleController:initHeroAnimal()
    self._hero_animal_formation = {}
    self._hero_animal_formation_ex = {}

    local startIndex = 6
    for i, v in pairs(self.hero_animal_slots) do
        v._swap_pos.x = v._base_pos.x
        v._swap_pos.y = v._base_pos.y
        v._move_pos.x = v._base_pos.x
        v._move_pos.y = v._base_pos.y
        v:removeAllChildren(true)

        startIndex = startIndex + 1

        local hrole = _ED.battleData._hero_animals["" .. startIndex]
        if hrole ~= nil then
            local currentLine = 2
            local role = FightRole:new():init(v, v:getContentSize(), 0, currentLine, hrole, self, self.fightIndex, true)
            self._hero_animal_formation[""..startIndex] = role

            table.insert(self._hero_animal_formation_ex, role)

            v:addChild(role)
        end
    end

    local hero_animal_formation = self._hero_animal_formation
    for k, v in pairs(hero_animal_formation) do
        state_machine.excute("fight_qte_controller_add_role", 0, v)
    end
end

-- 对方神兽创建
function FightRoleController:initMasterAnimal()
    self._master_animal_formation = {}
    self._master_animal_formation_ex = {}

    local startIndex = 6
    for i, v in pairs(self.master_animal_slots) do
        v._swap_pos.x = v._base_pos.x
        v._swap_pos.y = v._base_pos.y
        v._move_pos.x = v._base_pos.x
        v._move_pos.y = v._base_pos.y
        v:removeAllChildren(true)

        startIndex = startIndex + 1

        local hrole = _ED.battleData._enemy_animals["" .. startIndex]
        if hrole ~= nil then
            local currentLine = 2
            local role = FightRole:new():init(v, v:getContentSize(), 1, currentLine, hrole, self, self.fightIndex, true)
            self._master_animal_formation[""..startIndex] = role

            table.insert(self._master_animal_formation_ex, role)

            v:addChild(role)
        end
    end

    -- local master_animal_formation = self._master_animal_formation
    -- for k, v in pairs(master_animal_formation) do
    --     state_machine.excute("fight_qte_controller_add_role", 0, v)
    -- end
end

function FightRoleController:initHero()
    self._hero_formation_ex = {}
    self._hero_formation_copy = {}
    self._hero_formation = {}
    self.totalAttacker = 0
    self.heros_current_hp = 0
    self.heros_total_hp = 0
    for i, v in pairs(self.hero_slots) do
        v._swap_pos.x = v._base_pos.x
        v._swap_pos.y = v._base_pos.y
        v._move_pos.x = v._base_pos.x
        v._move_pos.y = v._base_pos.y
        v:removeAllChildren(true)
        local hrole = _ED.battleData._heros["" .. i]
        local hero = nil
        if hrole ~= nil then
            local role = FightRole:new():init(v, v:getContentSize(), 0, (i - 1) % 3 + 1, hrole, self, self.fightIndex)
            table.insert(self._hero_formation_ex, role)
            table.insert(self._hero_formation_copy, role)
            self._hero_formation[""..i] = role
            v:addChild(role)
            self.totalAttacker = self.totalAttacker + 1
            -- v:setScale(v:getScale() - self.scale_py * (v:getPositionY() - self.scale_start_y)) 
            self.enter_into_count = self.enter_into_count + 1

            if nil ~= FightRoleController.__battle_formation_info then
                local mInfo = FightRoleController.__battle_formation_info[1]
                if nil ~= mInfo and 1 ~= mInfo[i] then
                    mInfo[i] = 1
                    role.parent:setVisible(false)
                end
            end
            
            self.heros_current_hp = self.heros_current_hp + hrole._hp
            self.heros_total_hp = self.heros_total_hp + hrole._max_hp
        else
            table.insert(self._hero_formation_copy, 0)    
        end
        
    end

    local slObjIdxs = {
        "4", "5", "6", "1", "2", "3"
    }
    for i=1, #slObjIdxs do
        local role = self._hero_formation[""..i]
        if role ~= nil then
            role._sl_role = self._hero_formation[slObjIdxs[i]]
        end
    end

    -- for i, v in pairs(self._hero_formation) do
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

        for i = 1, 6 do
            local role = self._hero_formation[""..(6 - i + 1)]
            if role ~= nil then
                state_machine.excute("fight_qte_controller_add_role", 0, role)
            end
        end
    else
        for i = 1, 6 do
            local role = self._hero_formation[""..i]
            if role ~= nil then
                state_machine.excute("fight_qte_controller_add_role", 0, role)
            end
        end
    end
end

function FightRoleController:resetHero()
    self.heros_current_hp = 0
    self._hero_formation_ex = {}
    for i, v in pairs(self.hero_slots) do
        v._swap_pos.x = v._base_pos.x
        v._swap_pos.y = v._base_pos.y
        v._move_pos.x = v._base_pos.x
        v._move_pos.y = v._base_pos.y
        local hrole = _ED.battleData._heros["" .. i]
        if hrole ~= nil then
            local role = self._hero_formation[""..i]
            if role ~= nil and role.parent ~= nil then
                
            else
                role = FightRole:new():init(v, v:getContentSize(), 0, (i - 1) % 3 + 1, hrole, self, self.fightIndex)
                table.insert(self._hero_formation_ex, role)
                self._hero_formation[""..i] = role
                v:addChild(role)
                -- v:setScale(v:getScale() - self.scale_py * (v:getPositionY() - self.scale_start_y)) 
                self.enter_into_count = self.enter_into_count + 1
            end
            self.heros_current_hp = self.heros_current_hp + hrole._hp
            table.insert(self._hero_formation_ex, role)

            if nil ~= FightRoleController.__battle_formation_info then
                local mInfo = FightRoleController.__battle_formation_info[1]
                if nil ~= mInfo and 1 ~= mInfo[i] then
                    mInfo[i] = 1
                    role.parent:setVisible(false)
                end
            end
        end
    end

    local slObjIdxs = {
        "4", "5", "6", "1", "2", "3"
    }
    for i=1, #slObjIdxs do
        local role = self._hero_formation[""..i]
        if role ~= nil then
            role._sl_role = self._hero_formation[slObjIdxs[i]]
        end
    end
end

-- 创建敌方角色，添加触摸事件
function FightRoleController:initMaster()
    self._master_formation_ex = {}
    self._master_formation= {}
    self.masters_current_hp = 0
    self.masters_total_hp = 0
    self.totalMonster = 0
    for i, v in pairs(self.master_slots) do
        v._swap_pos.x = v._base_pos.x
        v._swap_pos.y = v._base_pos.y
        v._move_pos.x = v._base_pos.x
        v._move_pos.y = v._base_pos.y
        v:setPosition(v._base_pos)
        v:removeAllChildren(true)
        local tempFightIndex = self.fightIndex
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214 or  _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219  or  _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
            tempFightIndex = 1
        end

        local hrole = _ED.battleData._armys[tempFightIndex]._data["" .. i]
        if hrole ~= nil then
            local role = FightRole:new():init(v, v:getContentSize(), 1, (i - 1) % 3 + 1, hrole, self, self.fightIndex)
            table.insert(self._master_formation_ex, role)
            self._master_formation[""..i] = role
            v:addChild(role)

            v:setPositionX(v._base_pos.x)

            self.totalMonster = self.totalMonster + 1
            -- v:setScale(v:getScale() - self.scale_py * (v:getPositionY() - self.scale_start_y))
            self.enter_into_count = self.enter_into_count + 1

            self.masters_current_hp = self.masters_current_hp + hrole._hp
            self.masters_total_hp = self.masters_total_hp + hrole._max_hp

            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                role:setTouchEnabled(true)
                role:setName("master-" .. i)
                local masterCallback = function (sender, evenType)
                    local __spoint = sender:getTouchBeganPosition()
                    local __mpoint = sender:getTouchMovePosition()
                    local __epoint = sender:getTouchEndPosition()
                    if true == FightRoleController.__lock_battle or state_machine.find("fight_role_controller_select_by_attack_role")._lock then
                        return
                    end
                    local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
                    if auto_select then
                        return
                    end
                    local mission = missionIsOver()
                    if evenType == ccui.TouchEventType.began then
                        -- state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role")
                        if true == mission then
                            sender._one_called = state_machine.excute("fight_role_controller_select_by_attack_role", 0, sender)
                        end
                    elseif evenType == ccui.TouchEventType.moved then
                    elseif evenType == ccui.TouchEventType.ended then
                        -- state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                        if false == mission then
                            sender._one_called = state_machine.excute("fight_role_controller_select_by_attack_role", 0, sender)
                        end
                    elseif evenType == ccui.TouchEventType.canceled then
                        -- state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                    end
                end
                role:addTouchEventListener(masterCallback)
                role.callback = masterCallback

                if nil ~= FightRoleController.__battle_formation_info then
                    local mInfo = FightRoleController.__battle_formation_info[2]
                    if nil ~= mInfo and 1 ~= mInfo[i] then
                        mInfo[i] = 1
                        role.parent:setVisible(false)
                    end
                end
            end
        end
    end

    state_machine.lock("fight_role_controller_select_by_attack_role")
    state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role_but")

    local slObjIdxs = {
        "4", "5", "6", "1", "2", "3"
    }
    for i=1, #slObjIdxs do
        local role = self._master_formation[""..i]
        if role ~= nil then
            role._sl_role = self._master_formation[slObjIdxs[i]]
        end
    end

    -- self.masters_current_hp = self.masters_total_hp
end

function FightRoleController:changeBattle()


    if self.current_fight_index >= _ED.battleData.battle_total_count or (_ED.attackData.isWin == "0" and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_214 and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_219  and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_220)  then
        state_machine.excute("fight_check_next_fight", 0, 0)
    else
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
            if _mission_stop_fight_change_scene_action == 1 then
                local moveScene = state_machine.excute("fight_scene_change_to_next_fight_scene", 0, self.current_fight_index)
            else
                self:removeBeAttackerEffect()
                
                _ED.battleData._battle_start_influence_info = nil
                _ED.battleData._battle_round_influence_infos = nil

                FightRoleController.__lock_battle = true
                state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role")
                state_machine.lock("battle_qte_head_touch_head_role")

                local offsetInfo = {
                    {888, 934, 984, 890, 940, 990},
                }

                self.roleJoining = true
                self.enter_into_count = 0
                

                if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214 then
                    print("self.current_fight_index: " .. self.current_fight_index)

                    _ED.battleData = _ED.crossServer_battleData[self.current_fight_index + 1]
                    _ED.attackData = _ED.crossServer_attackData[self.current_fight_index + 1]
                    _ED.battleData._battle_start_influence_info = _ED.crossServer_battle_start_influence_info[self.current_fight_index + 1]
                    _ED.battleData._battle_round_influence_infos = _ED.crossServer_battle_round_influence_infos[self.current_fight_index + 1]
                    _ED.battleData._camp_change_influence_infos = _ED.crossServer_start_influence_info[self.current_fight_index + 1]

                    -- 记录三场的输赢情况
                    table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

                    state_machine.excute("fight_ui_update_battle_player_info", 0, {_ED._attack_people_name , _ED._defense_people_name, nil, 0, 0, 0})
                    self:nextBattle()

                    -- _ED.cross_server_battel_requestIndex = self.current_fight_index + 1

                    -- local function callback(response)
                    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    --         -- 记录三场的输赢情况
                    --         table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

                    --         state_machine.excute("fight_ui_update_battle_player_info", 0, {_ED._attack_people_name , _ED._defense_people_name, nil, 0, 0, 0})
                    --         self:nextBattle()
                    --     end
                    -- end

                    -- protocol_command.cross_mine_load_battle_info.param_list = _ED.cross_server_battel_grab_other_formation2.index .. "\r\n" .. _ED.cross_server_battel_requestIndex
                    -- NetworkManager:register(protocol_command.cross_mine_load_battle_info.code, nil, nil, nil, self, callback, false, nil)
                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219 then
                    _ED.battleData = _ED.crossServerTotal_battleData[self.current_fight_index + 1]
                    _ED.attackData = _ED.crossServerTotal_attackData[self.current_fight_index + 1]
                    _ED.battleData._battle_start_influence_info = _ED.crossServerTotal_battle_start_influence_info[self.current_fight_index + 1]
                    _ED.battleData._battle_round_influence_infos = _ED.crossServerTotal_battle_round_influence_infos[self.current_fight_index + 1]
                    _ED.battleData._camp_change_influence_infos = _ED.crossServerTotal_start_influence_info[self.current_fight_index + 1]
                    _ED.animalRoundData = _ED.crossServerTotal_animal_round_data[self.current_fight_index + 1]

                    -- 记录三场的输赢情况
                    table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

                    state_machine.excute("fight_ui_update_battle_player_info", 0, {_ED._attack_people_name , _ED._defense_people_name, nil, 0, 0, 0})
                    self:nextBattle()
                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
                    _ED.battleData = _ED.TeamArena_battleData[self.current_fight_index + 1]
                    _ED.attackData = _ED.TeamArena_attackData[self.current_fight_index + 1]
                    _ED.battleData._battle_start_influence_info = _ED.TeamArena_battle_start_influence_info[self.current_fight_index + 1]
                    _ED.battleData._battle_round_influence_infos = _ED.TeamArena_battle_round_influence_infos[self.current_fight_index + 1]
                    _ED.battleData._camp_change_influence_infos = _ED.TeamArena_start_influence_info[self.current_fight_index + 1]
                    _ED.animalRoundData = _ED.TeamArena_animal_round_data[self.current_fight_index + 1]

                    -- 记录三场的输赢情况
                    table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)

                    state_machine.excute("fight_ui_update_battle_player_info", 0, {_ED._attack_people_name , _ED._defense_people_name, nil, 0, 0, 0})
                    self:nextBattle()
                else
                    for i, v in pairs(self._hero_formation_ex) do
                        if v.parent ~= nil then
                            v._ecsrfd = {}
                            self.enter_into_count = self.enter_into_count + 1
                            local offsetX = offsetInfo[1][tonumber(v.armature._pos)]
                            local actionIndex = _enum_animation_l_frame_index.animation_move
                            csb.animationChangeToAction(v.armature, actionIndex, actionIndex, false)
                            v.armature._lockActionIndex = actionIndex
                            v:cleanBuffState(true)
                            v:runAction(cc.Sequence:create({
                                    cc.MoveBy:create(2.0 * __fight_recorder_action_time_speed, cc.p(offsetX, 0)),
                                    cc.CallFunc:create(function ( sender )
                                        -- print(sender.armature._actionIndex, sender.armature._nextAction)
                                        self.roleJoining = false
                                        local armature = sender.armature
                                        armature._lockActionIndex = nil
                                        actionIndex = _enum_animation_l_frame_index.animation_standby
                                        csb.animationChangeToAction(armature, actionIndex, actionIndex, false)

                                        self.enter_into_count = self.enter_into_count - 1
                                        if self.enter_into_count == 0 then
                                            self.roleJoining = false
                                            state_machine.excute("fight_scene_change_to_next_fight_scene", 0, self.current_fight_index)
                                            state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role")
                                            state_machine.unlock("battle_qte_head_touch_head_role")
                                            state_machine.unlock("fight_role_controller_select_by_attack_role")
                                        end
                                    end)
                                }))
                        end
                    end
                end

            end
        else
            -- 移动场景
            local moveScene = state_machine.excute("fight_scene_change_to_next_fight_scene", 0, self.current_fight_index)

            -- if moveScene == true then
            --     for i, v in pairs(self._hero_formation_ex) do
            --         if v.parent ~= nil then
            --             v:changeFightEffect()
            --         end
            --     end
            -- end
        end
    end
end

function FightRoleController:requestNextFight()
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil then
            v:restartFight()
            
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                v.armature._heroInfoWidget:controlLife(false, 9)
                v.armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
                v.armature._heroInfoWidget:showRoleHP()
                v.armature._heroInfoWidget:showRoleSP()
            end
        end
    end
    
    self:nextBattle()
end

function FightRoleController:updateCampBoundary(params)
    local role = params[1]
    local needMove = params[2]
    local isNeedCoverMoveCamp = params[3]
    local moveCampPosX = params[4]
    if isNeedCoverMoveCamp == true then
        self.move_camp_boundary.x = moveCampPosX
    end
    return self.move_camp_boundary, self.base_camp_boundary
end

function FightRoleController:nextBattle()
    state_machine.excute("draw_hit_damage_exit", 0, 0)
    local tempFightIndex = self.fightIndex
    self.fightIndex = self.fightIndex + 1
    self.move_camp_boundary.x = self.base_camp_boundary.x
    self.currentAttackCount = 0
    __________b = false
    FightRole.__g_role_attacking = false
    FightRole.__g_lock_sp_attack = false
    FightRole.__g_lock_camp_attack = 0
    FightRole._current_attack_camp = -1
    FightRole._last_attack_camp = -1
    FightRole.__priority_camp = -1

    self._open_hit_count = true

    self.byAttackTargetTag = 0

    -- if tempFightIndex == 0 then
    --     self:initHero()
    -- else
    --     self:resetHero()
    -- end
    if self.isAuto == true then
        self.auto_fighting = true
    else
        self.auto_fighting = false
    end
    -- print("进入下一场战斗....", self.auto_fighting)
    
    -- 跨服矿战每场都要生成新的英雄
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_214 or  _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219  or  _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
        state_machine.excute("fight_qte_controller_reset_fight_head", 0, nil)
        self:initHero()
    else
        if tempFightIndex == 0 then
            state_machine.excute("fight_qte_controller_reset_fight_head", 0, nil)
            self:initHero()
        else
            _ED._fightModule:addPowerValueFightObject(0, -1, FightModule.CHANGE_NEXT_FIGHT_SP_ADD_VAULE)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                for index, hero in pairs(self._hero_formation) do
                    if nil ~= hero and nil ~= hero.parent then
                        hero.armature._role._sp = hero.armature._role._sp + FightModule.CHANGE_NEXT_FIGHT_SP_ADD_VAULE
                    end
                end
            end
        end
    end

    if self.auto_fighting == true then
        state_machine.excute("fight_ui_update_auto_fight_time",0, {time = 0, isShowAuto = true})
        state_machine.excute("fight_qte_controller_enter_auto_fight", 0, nil)
    else
        if tempFightIndex == 0 then
            state_machine.excute("fight_qte_controller_role_by_active", 0, "init")
        end
    end
    self:initMaster()

    self:initHeroAnimal()
    self:initMasterAnimal()
    
    -- 角色入场
    if _mission_stop_fight_change_scene_action == 1 then

    else
        self:roldJoinScene()
    end

    FightRoleController.__battle_formation_info = nil

    state_machine.excute("fight_ui_update_hp_progress", 0, {0, self.heros_current_hp, self.heros_total_hp})
    state_machine.excute("fight_ui_update_hp_progress", 0, {1, self.masters_current_hp, self.masters_total_hp})
    state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, true)

    -- 冠军试炼和跨服小队竞技场因为不切场 所以手动刷新下神兽的UI信息
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_219 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_220 then
        state_machine.excute("fight_ui_update_animal_skill_info_ui", 0, nil)
    end
end

function FightRoleController:roldJoinScene()
    local offsetInfo = {
        {590, 544, 494, 586, 536, 486},
        {562, 516, 466, 560, 510, 460},
    }

    self.enter_into_count = 0
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil then
            self.enter_into_count = self.enter_into_count + 1
            local offsetX = offsetInfo[1][tonumber(v.armature._pos)]
            v:setPositionX(0 - offsetX)
            local actionIndex = _enum_animation_l_frame_index.animation_move
            csb.animationChangeToAction(v.armature, actionIndex, actionIndex, false)
            v.armature._lockActionIndex = actionIndex
            v:runAction(cc.Sequence:create({
                    cc.MoveBy:create(1.5 * __fight_recorder_action_time_speed, cc.p(offsetX, 0)),
                    cc.CallFunc:create(function ( sender )
                        -- print(sender.armature._actionIndex, sender.armature._nextAction)
                        self.roleJoining = false
                        local armature = sender.armature
                        armature._lockActionIndex = nil
                        actionIndex = _enum_animation_l_frame_index.animation_standby
                        csb.animationChangeToAction(armature, actionIndex, actionIndex, false)
                        
                        state_machine.excute("fight_role_controller_role_enter_into_over", 0, 0)
                    end)
                }))
        end
    end

    for i, v in pairs(self._master_formation_ex) do
        if v.parent ~= nil then
            self.enter_into_count = self.enter_into_count + 1
            local offsetX = offsetInfo[2][tonumber(v.armature._pos)]
            v:setPositionX(0 + offsetX)
            local actionIndex = _enum_animation_l_frame_index.animation_move
            csb.animationChangeToAction(v.armature, actionIndex, actionIndex, false)
            v.armature._lockActionIndex = actionIndex
            v:runAction(cc.Sequence:create({
                    cc.MoveBy:create(1.5 * __fight_recorder_action_time_speed, cc.p(-1 * offsetX, 0)),
                    cc.CallFunc:create(function ( sender )
                        -- print(sender.armature._actionIndex, sender.armature._nextAction)
                        self.roleJoining = false
                        local armature = sender.armature
                        armature._lockActionIndex = nil
                        actionIndex = _enum_animation_l_frame_index.animation_standby
                        csb.animationChangeToAction(armature, actionIndex, actionIndex, false)
                        
                        state_machine.excute("fight_role_controller_role_enter_into_over", 0, 0)
                    end)
                }))
        end
    end
    self.roleJoining = true
end

function FightRoleController.onImageLoaded(texture)
    
end

function FightRoleController:onArmatureDataLoad(percent)
    
end

function FightRoleController:onArmatureDataLoadEx(percent)
    -- if percent >= 1 then
    --  if self._load_over == false then
    --      self._load_over = true
    --      self:onInit()
    --  end
    -- end
end

function FightRoleController:onLoad()
    -- local effect_paths = {
    --  "images/ui/effice/effect_22/effect_22.ExportJson",
    --  "images/ui/effice/effect_26/effect_26.ExportJson"
    -- }
    -- for i, v in pairs(effect_paths) do
    --  local fileName = v
    --  ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
    -- end

    -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, true)

    self:onInit()
    self:onLoadAssets()
end

function FightRoleController:onInit()
    if __lua_project_id ~= __lua_project_l_naruto then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect.ExportJson")
    end
    
    if animationMode == 1 then
    else
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_2.ExportJson")
    end
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_2_1.ExportJson")
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_4.ExportJson")

    local csbFightRoleController = csb.createNode("battle/battle_map_heng_role.csb")
    local root = csbFightRoleController:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFightRoleController)
    self:setContentSize(root:getContentSize())

    local action = csb.createTimeline("battle/battle_map_heng_role.csb")
    table.insert(self.actions, action)

    self.csbFightRoleController = csbFightRoleController

    for i = 1, 6 do
        local hero = ccui.Helper:seekWidgetByName(root, "Panel_role_0_"..i)
        hero:setPositionX(hero:getPositionX() + app.baseOffsetX/2)
        table.insert(self.hero_slots, hero)
        hero._base_pos = cc.p(hero:getPosition())
        hero._move_pos = cc.p(hero._base_pos.x, hero._base_pos.y)
        hero._swap_pos = cc.p(hero._base_pos.x, hero._base_pos.y)

        local master = ccui.Helper:seekWidgetByName(root, "Panel_role_1_"..i)
        table.insert(self.master_slots, master)
        -- master:setPositionX(master:getPositionX() - app.baseOffsetX)
        master:setPositionX(master:getPositionX() - app.baseOffsetX/2)
        master._base_pos = cc.p(master:getPosition())
        master._move_pos = cc.p(master._base_pos.x, master._base_pos.y)
        master._swap_pos = cc.p(master._base_pos.x, master._base_pos.y)

        if i == 1 then
            self.scale_end_y = hero:getPositionY()
            self.base_camp_boundary.x = hero._base_pos.x
        end
        if i == 3 then
            self.scale_start_y = hero:getPositionY()
            self.base_camp_boundary.x = self.base_camp_boundary.x + (master._base_pos.x - self.base_camp_boundary.x) / 2
            self.move_camp_boundary.x = self.base_camp_boundary.x
        end
    end

    for i = 1, 3 do
        local hero = self.hero_slots[i]
        local master = self.master_slots[i]

        local herox, heroy = hero:getPosition()
        local masterx, mastery = master:getPosition()
        table.insert(self.act_center_positions, cc.p((herox + masterx)/2, (heroy + mastery)/2))

        -- local hero1 = self.hero_slots[i + 3]
        local hero1 = self.hero_slots[i]
        local herox1, heroy1 = hero1:getPosition()
        -- table.insert(self.column_center_positions, cc.p((herox + herox1)/2, (heroy + heroy1)/2))
        table.insert(self.hero_column_positions, cc.p(herox1, heroy1))

        -- local master1 = self.master_slots[i + 3]
        local master1 = self.master_slots[i]
        local masterx1, mastery1 = master1:getPosition()
        -- table.insert(self.column_center_positions, cc.p((herox + masterx1)/2, (heroy + mastery1)/2))
        table.insert(self.master_column_positions, cc.p(masterx1, mastery1))
    end

    -- 神兽位置
    for i = 1, 3 do
        local hero_animal = ccui.Helper:seekWidgetByName(root, "Panel_animal_0_"..i)
        if hero_animal ~= nil then
            hero_animal:setPositionX(hero_animal:getPositionX() + app.baseOffsetX/2)
            table.insert(self.hero_animal_slots, hero_animal)
            hero_animal._base_pos = cc.p(hero_animal:getPosition())
            hero_animal._move_pos = cc.p(hero_animal._base_pos.x, hero_animal._base_pos.y)
            hero_animal._swap_pos = cc.p(hero_animal._base_pos.x, hero_animal._base_pos.y)
        end

        local master_animal = ccui.Helper:seekWidgetByName(root, "Panel_animal_1_"..i)
        if master_animal ~= nil then
            table.insert(self.master_animal_slots, master_animal)
            master_animal:setPositionX(master_animal:getPositionX() - app.baseOffsetX/2)
            master_animal._base_pos = cc.p(master_animal:getPosition())
            master_animal._move_pos = cc.p(master_animal._base_pos.x, master_animal._base_pos.y)
            master_animal._swap_pos = cc.p(master_animal._base_pos.x, master_animal._base_pos.y)
        end
    end

    self.scale_arena_y = self.scale_end_y - self.scale_start_y
    self.scale_py = self.scale_arena / self.scale_arena_y

    if self.isPvEType == true then
        self.isAuto = self:getIsAutoFight()
        self.auto_fighting = self:getIsAutoFight()
    else
        self.isAuto = true
        self.auto_fighting = true
    end
end

function FightRoleController:loadSuccess( ... )
    self:nextBattle()

    self:registerOnNoteUpdate(self, 0.5)
end

function FightRoleController:reorderRole(role, zOrder)
    if role ~= nil and role._self ~= nil and role._self.roleAttacking == true then
        local tempzOrder = role._self.parent:getPositionY() + 10
        if zOrder ~= nil then
            tempzOrder = zOrder
        end
        local newZ = fwin._height * 10 - tempzOrder -- -1 * (role._self.parent:getPositionY() + 10)  
        role:getParent():reorderChild(role, newZ)
        return
    end
    if role == nil or role._moving == true 
        -- or (role._self ~= nil and role._self.repelAndFlyEffectCount ~= nil and role._self.repelAndFlyEffectCount > 0) 
        then
        return
    end
    -- local newZ = math.floor(fwin._height - role:getPositionY())
    local tempzOrder = role._base_pos.y
    if zOrder ~= nil then
        tempzOrder = zOrder
    end
    local newZ = fwin._height * 10 - tempzOrder -- -1 * role._base_pos.y
    role:getParent():reorderChild(role, newZ)
end

function FightRoleController:cameraFocusChange(_role, _mp)
    local posx, posy = _role.parent:getPosition()
    if _mp == true and tonumber(_role._info._pos) > 3 and _role.roleAttacking == true then
        posx = _role.parent._move_pos.x
        posy = _role.parent._move_pos.y
    end
    if self.center_left_offset.x > posx then
        self.center_left_offset.x = posx
    end
    if self.center_right_offset.x < posx then
        self.center_right_offset.x = posx
    end
    local my = posy - _role.parent._base_pos.y
    if my > self.center_position.y then
        self.center_position.y = my
    end
end

function FightRoleController:changeToAutoFight( ... )
    if self.isPvEType ~= true then
        return
    end
    -- local currentFightState = self.auto_fighting
    -- self.auto_intervel = 0
    -- self.auto_fighting = true
    -- self.isAuto = true
    -- self.qte_fighting = false
    -- -->__crint("定时器结束：进入自动战斗状态；")
    -- if currentFightState == false then
    --     if _ED._fightModule ~= nil and _ED._fightModule:checkAttackSell() == false and 
    --         _ED._fightModule:checkAttackSell() == false then
    --         self:checkNextRoundFight()
    --     else
    --         state_machine.excute("fight_qte_controller_qte_hide_progress", 0, nil)
    --         state_machine.excute("fight_ui_update_auto_fight_time",0, {time = 0, isShowAuto = true})

    --         self:executeCurrentRountFightData()
    --         state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, nil)
            
    --         state_machine.excute("fight_qte_controller_enter_auto_fight", 0, nil)
    --     end
    -- end
    -- state_machine.excute("fight_ui_update_fight_auto_state", 0, nil)
    -- self:saveAsAuFightType(self.isAuto)

    if self.auto_fighting == false then
        if self.isPvEType == true then
            local currentAuto = state_machine.excute("fight_ui_update_fight_get_auto_state", 0, nil)
            if currentAuto == true or self.isNextAuto then
                self.isAuto = true
                self.auto_fighting = true
                state_machine.excute("fight_ui_update_auto_fight_time",0, {time = 0, isShowAuto = true})
            else
                self.isAuto = false
                self.auto_fighting = false
                self.auto_intervel = self.auto_duration
            end
            self:saveAsAuFightType(currentAuto)

            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                or __lua_project_id == __lua_project_l_naruto 
                then
                self.auto_select = self.isAuto
                self.isAuto = false
                self.auto_fighting = false
            end
        else
            self.isAuto = true
            self.auto_fighting = true
        end
        if MissionClass._isFirstGame == true then
            MissionClass._isFirstGame = false
            self.auto_fighting = true
            state_machine.excute("fight_qte_controller_change_visible", 0, false)
        else
            state_machine.excute("fight_qte_controller_change_visible", 0, true)
        end

        -- 自动选择目标进行攻击
        if true == self.auto_select then
            -- print("自动选择目标进行攻击")
            fwin:addService({
                callback = function ( params )
                    FightRoleController.__lock_battle = false
                    state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, 0)
                    state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                    state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                end,
                delay = 0.01,
                params = self
            })
        end
    end
end

function FightRoleController:changeFightRoleState( isStop )
    if self.current_mission == nil then
        return
    end
    for index, hero in pairs(self._hero_formation) do
        if hero ~= nil then
            hero.isStopFight = self.isStopFight
        end
    end
    for index, master in pairs(self._master_formation) do
        if master ~= nil then
            master.isStopFight = self.isStopFight
        end
    end
    if self.isStopFight == false then
        saveExecuteEvent(self.current_mission, true)
    end
    state_machine.excute("fight_role_change_fight_action_state", 0, self.isStopFight)
end

function FightRoleController:lockFight()
    self.isLockScene = true
end

function FightRoleController:unlockFight()
    self.isLockScene = false
end

-- 选中被攻击的角色
function FightRoleController:selectByAttackRole( params )
    if self.auto_fighting == true or nil == params then
        return
    end


    for k,v in pairs(self._master_formation) do
        if v ~= nil and v.parent ~= nil and v.roleWaitDeath == false and v.isDeathRemove == false and v.is_killed == false and v.is_deathed == false and nil == v.buffList["79"] then
            if tonumber(params._brole._pos) > 3 and tonumber(v._brole._pos) < 4 then
                return
            end
        end
    end

    if nil ~= self.wakeUpArmature and params == self.wakeUpArmature._lockRole then
        state_machine.excute("fight_role_controller_reset_comkill_progress", 0, 0)
        state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
        state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, nil)
        state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role")
        return
    end

    if nil ~= self.wakeUpArmature and params ~= self.wakeUpArmature._lockRole then
        -- print("开始攻击 3-1")
        state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role")
    end

    self.byAttackTargetTag = tonumber(params._brole._pos)

    self:removeBeAttackerEffect()
    self:wakeUpBeAttackerEffect(params)
end

function FightRoleController:palyerPowerSkillScreenEffect( params )
    -- local root = self.roots[1]
    -- local Panel_super_skill_bg = ccui.Helper:seekWidgetByName(root, "Panel_super_skill_bg")
    -- if params._unload == true then
    --     if Panel_super_skill_bg._role == params._role then
    --         Panel_super_skill_bg._role = nil
    --         Panel_super_skill_bg:removeAllChildren(true)
    --     end
    --     return
    -- end

    -- Panel_super_skill_bg._role = params._role
    -- local armature = draw.createEffect("effice_super_skill_bg", "images/ui/effice/effice_super_skill_bg/effice_super_skill_bg.ExportJson", Panel_super_skill_bg, 1, 0)
    -- armature._role = params._role
    -- armature._invoke = function ( armatureBack )
    --     -- state_machine.excute("skill_closeup_window_open", 0, {armatureBack._role, armatureBack._role.roleCamp, armatureBack._role._info._head})
    --     -- draw.deleteEffect(armatureBack)
    -- end

    state_machine.excute("fight_scene_play_power_skill_screen_effect", 0, params)
end

function FightRoleController:checkSameHeroTipInfo(params)
    local isHaveSameHero = false
    -- 校验是否有相同的武将
    for i, v in pairs(self._hero_formation_ex) do
        for m, n in pairs(self._master_formation_ex) do
            local shipMouldId = dms.string(dms["environment_ship"], n._info._mouldId, environment_ship.directing)
            -- print(v._info._mouldId, shipMouldId)
            if nil ~= v._info and v._info._mouldId == shipMouldId then
                v:addChild(GhostCopySameHeroTip:new():init(v))
                n:addChild(GhostCopySameHeroTip:new():init(n))
                isHaveSameHero = true
            end
        end
    end
    return isHaveSameHero
end

function FightRoleController:onUpdate( dt )
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto
        then
        if (os.time() - self.keepAcliveInterval) > 120 then
            self.keepAcliveInterval = os.time()
            local function responseKeepAliveCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                end             
            end
            NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, responseKeepAliveCallback,-1)
        end
    end
    if FightRole.__skeep_fighting == true then
        return
    end
    if self.isLockScene == true or self.roleJoining then
        return
    end

    if self.isNeedChangeBattle == true then
        self.changeBattleDelay = self.changeBattleDelay - dt
        if self.changeBattleDelay <= 0 then
            self.isNeedChangeBattle = false
            -- app.load("client.battle.landscape.FightChangeScene")
            -- fwin:open(FightChangeScene:new(), fwin._view)

            if true ~= _ED._battle_wait_change_scene then
                state_machine.excute("fight_role_controller_change_battle", 0, 0)
            else
                executeNextEvent(nil, nil)
            end

            if self.current_fight_index >= _ED.battleData.battle_total_count then
            else
                state_machine.excute("fight_scene_initialize_scene", 0, 0)
            end
        end
    end

    if self.isResumeTimeLine == true then
        self.resumeTimeLineDelay = self.resumeTimeLineDelay - dt
        if self.resumeTimeLineDelay <= 0 then
            self.isResumeTimeLine = false
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                or __lua_project_id == __lua_project_l_naruto 
                then
                __fight_recorder_action_time_speed_index = __fight_recorder_action_time_speed_index or 1
                if nil ~= _fight_time_scale then
                    cc.Director:getInstance():getScheduler():setTimeScale(_fight_time_scale[__fight_recorder_action_time_speed_index])
                else
                    cc.Director:getInstance():getScheduler():setTimeScale(1.0 * __fight_recorder_action_time_speed_index)
                end
                state_machine.excute("fight_qte_controller_change_time_speed", 0, 0)
            else
                cc.Director:getInstance():getScheduler():setTimeScale(1)
            end
        end
    end

    if self.isWaitDeathOver == true then
        self.isWaitDeathOverDelay = self.isWaitDeathOverDelay - dt
        if self.isWaitDeathOverDelay <= 0 then
            self.isWaitDeathOver = false
            self:fightEndAll()
        end
    end

    if self.isStopFight == true then
        if self.guideNeedClick == false then
            self.guideTime = self.guideTime - dt
            if self.guideTime <= 0 then
                self.isStopFight = false
                state_machine.excute("fight_qte_controller_progress_continue_play", 0, true)
                self:changeFightRoleState(self.isStopFight)
            end
        end
    else
        if self.isAuto == false and self.current_fight_over == false then
            if self.auto_fighting == false and self.qte_fighting == false then
                if self.isInDialogMission == false and self.isCanStartUpAutoTick == true then
                    local userlevel= tonumber(_ED.user_info.user_grade)
                    local openautolevel= tonumber(dms.string(dms["fun_open_condition"],53, fun_open_condition.level)) 
                    if userlevel >= openautolevel then
                        self.auto_intervel = self.auto_intervel - dt
                        state_machine.excute("fight_ui_update_auto_fight_time",0, {time = self.auto_intervel, isShowAuto = false})
                        if self.auto_intervel <= 0 then
                            self:changeToAutoFight()
                        end
                    end
                end
            end
        end
    end
    
    local size = self:getContentSize()
    size.width = size.width - app.baseOffsetX
    self.center_left_offset.x = 99999999 --size.width / 2
    self.center_right_offset.x = 0 --size.width / 2
    self.center_position.y = 0

    local heroCount = 0
    local heroAttackCount = 0
    local mt = false
    local et = false
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil then
            v:onUpdate(dt)
            self:reorderRole(v.parent)
            if mt == false and tonumber(v._info._pos) < 4 then
                mt = true
            end
        end
    end
    
    for i, v in pairs(self._master_formation_ex) do
        if v.parent ~= nil then
            v:onUpdate(dt)
            self:reorderRole(v.parent)
            if et == false and tonumber(v._info._pos) < 4 then
                et = true
            end
        end
    end

    for i, v in pairs(self._hero_animal_formation_ex) do
        if v.parent ~= nil then
            v:onUpdate(dt)
            self:reorderRole(v.parent, 0)
        end
    end

    for i, v in pairs(self._master_animal_formation_ex) do
        if v.parent ~= nil then
            v:onUpdate(dt)
            self:reorderRole(v.parent, 0)
        end
    end
    
    local skillAttackLockScreen = false
    local _camera_posx = {}
    local _camera_posy = {}
    local oneSideAttackCount = 0
    local focus = nil
    
    if self.auto_fighting == true then
        for i, v in pairs(self.attack_list) do
            if v.parent ~= nil then
                if --v._skill_quality == 1 and 
                    v.roleAttacking == true 
                    -- and v.changeActionToAttacking == true 
                    and v.camera_focus == true
                    -- and (((v.roleCamp == 0 and mt == false) or (v.roleCamp == 1 and et == false)) or tonumber(v._info._pos) < 4)
                    then
                    -->___crint("==============  我方怒气技能---镜头改变  ===============")
                    skillAttackLockScreen = true
                    
                    oneSideAttackCount = oneSideAttackCount + 1
                    self:cameraFocusChange(v)

                    focus = v
                    
                end
            end
        end

        for i, v in pairs(self._hero_formation_ex) do
            if v.parent ~= nil then
                if 
                    -- true or 
                    skillAttackLockScreen == false 
                    then
                    self:cameraFocusChange(v, mt)
                end 
            end
        end

        for i, v in pairs(self._master_formation_ex) do
            if v.parent ~= nil then
                if 
                    -- true or 
                    skillAttackLockScreen == false 
                    then
                    self:cameraFocusChange(v, et)
                end 
            end
        end
    else
        for i, v in pairs(self._hero_formation_ex) do
            if v.parent ~= nil then
                if v.roleAttacking == true 
                    and v.camera_focus == true
                    -- and (((v.roleCamp == 0 and mt == false) or (v.roleCamp == 1 and et == false)) or tonumber(v._info._pos) < 4)
                    then
                    -->___crint("==============  我方怒气技能---镜头改变  ===============")
                    skillAttackLockScreen = true
                    
                    oneSideAttackCount = oneSideAttackCount + 1
                    self:cameraFocusChange(v)
                    focus = v
                else
                    self:cameraFocusChange(v, mt)
                end
            end
        end

        for i, v in pairs(self._master_formation_ex) do
            if v.parent ~= nil then
                if v.roleAttacking == true 
                    and v.camera_focus == true
                    -- and (((v.roleCamp == 0 and mt == false) or (v.roleCamp == 1 and et == false)) or tonumber(v._info._pos) < 4)
                    then
                    -->___crint("==============  我方怒气技能---镜头改变  ===============")
                    skillAttackLockScreen = true
                    
                    oneSideAttackCount = oneSideAttackCount + 1
                    self:cameraFocusChange(v)

                    focus = v
                else
                    self:cameraFocusChange(v, et)
                end
            end
        end
    end
    -- if skillAttackLockScreen == true then
    --     self.center_left_offset.x = self.center_left_offset.x + (self.center_right_offset.x - self.center_left_offset.x) / 2
    --     self.center_right_offset.x = self.center_left_offset.x
    -- end
    if self.open_camera == true then
        self.center_position.x = self.center_left_offset.x + (self.center_right_offset.x - self.center_left_offset.x) / 2
        state_machine.excute("fight_scene_camera_focussing", 0, {self.center_position, self.center_left_offset, self.center_right_offset, focus, self.center_position.x - self.base_camp_boundary.x})
    end
end

function FightRoleController:onUpdate111(dt)
    if FightRole.__skeep_fighting == true then
        return
    end
    if self.isLockScene == true then
        return
    end
    
    if self.isStopFight == true then
        return
    end

    local size = self:getContentSize()
    size.width = size.width - app.baseOffsetX
    self.center_left_offset.x = 99999999 --size.width / 2
    self.center_right_offset.x = 0 --size.width / 2
    self.center_position.y = 0

    local heroCount = 0
    local heroAttackCount = 0
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil then
            v:onUpdate(dt)
            self:reorderRole(v.parent)
        end
    end

    for i, v in pairs(self._master_formation_ex) do
        if v.parent ~= nil then
            v:onUpdate(dt)
            self:reorderRole(v.parent)
        end
    end

    local function cameraFocusChange(_role)
        local posx, posy = _role.parent:getPosition()
        if self.center_left_offset.x > posx then
            self.center_left_offset.x = posx
        end
        if self.center_right_offset.x < posx then
            self.center_right_offset.x = posx
        end
        local my = posy - _role.parent._base_pos.y
        if my > self.center_position.y then
            self.center_position.y = my
        end
    end
    
    local skillAttackLockScreen = false
    local _camera_posx = {}
    local _camera_posy = {}
    local oneSideAttackCount = 0
    
    local function checkDefenders(_role)
        for i, v in pairs (_role.fight_cacher_pool) do
            if v.__defenderList ~= nil then
                return v.__defenderList
            end
        end
        return nil
    end
    
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil then
            if --v._skill_quality == 1 and 
                v.roleAttacking == true and v.changeActionToAttacking == true then
                -->___crint("==============  我方怒气技能---镜头改变  ===============")
                skillAttackLockScreen = true
                
                oneSideAttackCount = oneSideAttackCount + 1
                
                -- table.insert(_camera_posx, cc.p(v.parent:getPosition()).x)
                -- table.insert(_camera_posy, cc.p(v.parent:getPosition()).y - v.parent._base_pos.y)
                
                -- local _hero_defenderList = checkDefenders(v)
                -- for idx, def in pairs(_hero_defenderList) do
                --  if def.parent ~= nil then
                --      table.insert(_camera_posx, cc.p(def.parent:getPosition()).x)
                --      table.insert(_camera_posy, cc.p(def.parent:getPosition()).y - def.parent._base_pos.y)
                --  end 
                -- end

                cameraFocusChange(v)
            end
        end
    end
    
    
    if oneSideAttackCount == 0 then
        for i, v in pairs(self._master_formation_ex) do
            if v.parent ~= nil then
                if --v._skill_quality == 1 and 
                    v.roleAttacking == true and v.changeActionToAttacking == true then
                    -- -->__crint("==============  敌方怒气技能---镜头改变  ===============")
                    skillAttackLockScreen = true
                    
                    -- table.insert(_camera_posx, cc.p(v.parent:getPosition()).x)
                    -- table.insert(_camera_posy, cc.p(v.parent:getPosition()).y - v.parent._base_pos.y)
                    
                    -- local _master_defenderList = checkDefenders(v)
                    -- for idx, def in pairs(_master_defenderList) do
                    --  if def.parent ~= nil then
                    --      table.insert(_camera_posx, cc.p(def.parent:getPosition()).x)
                    --      table.insert(_camera_posy, cc.p(def.parent:getPosition()).y - def.parent._base_pos.y)
                    --  end 
                    -- end

                    cameraFocusChange(v)
                end
            end
        end
    end 
    
    -- for i, v in pairs(_camera_posx) do
    --  if self.center_left_offset.x > v then
    --      self.center_left_offset.x = v
    --  end
        
    --  if self.center_right_offset.x < v then
    --      self.center_right_offset.x = v
    --  end
    -- end
    
    -- for i, v in pairs(_camera_posy) do
    --  if v > self.center_position.y then
    --      self.center_position.y = v
    --  end
    -- end

    local fitIndex = -1
    for i, v in pairs(self._hero_formation_ex) do
        if v.parent ~= nil then
            for index, pool in pairs(v.fight_cacher_pool) do
                if pool.__fitAttacker ~= nil then
                    fitIndex = i
            
                    -- self:reorderRole(v.parent)
                    v:attackListener()
                    if v.roleAttacking == true or #v.fight_cacher_pool > 0 then
                        heroAttackCount = heroAttackCount + 1
                    end
                    heroCount = heroCount + 1
                    
                    if skillAttackLockScreen == false then
                        cameraFocusChange(v)
                    end 
                end
            end
        end
    end

    if fitIndex == -1 then
        for i, v in pairs(self._hero_formation_ex) do
            if v.parent ~= nil then
                -- self:reorderRole(v.parent)
                v:attackListener()
                if v.roleAttacking == true or #v.fight_cacher_pool > 0 then
                    heroAttackCount = heroAttackCount + 1
                end
                heroCount = heroCount + 1

                if skillAttackLockScreen == false then
                    cameraFocusChange(v)
                end 
            end
        end
    end 

    if heroAttackCount == 0 then
        local masterCount = 0
        
        local fitIndex1 = -1
        for i, v in pairs(self._master_formation_ex) do
            if v.parent ~= nil then
                for index, pool in pairs(v.fight_cacher_pool) do
                    if pool.__fitAttacker ~= nil then
                        fitIndex1 = i
                        
                        -- self:reorderRole(v.parent)
                        v:attackListener()

                        masterCount = masterCount + 1

                        if skillAttackLockScreen == false then
                            cameraFocusChange(v)
                        end 
                    end
                end
            end
        end

        if fitIndex1 == -1 then
            for i, v in pairs(self._master_formation_ex) do
               if v.parent ~= nil and fitIndex1 ~= i then
                    -- self:reorderRole(v.parent)
                    v:attackListener()

                    masterCount = masterCount + 1

                    if skillAttackLockScreen == false then
                        cameraFocusChange(v)
                    end 
                end
            end
        end
            
        if masterCount == 0 then
            for i, v in pairs(self._hero_formation_ex) do
                if v.parent ~= nil and #v.fight_cacher_pool > 0 then
                    v.fight_cacher_pool = {}
                    v.fight_over = false
                    v:checkNextFight()
                end
            end
        end
    else
        for i, v in pairs(self._master_formation_ex) do
            if v.parent ~= nil then
                if skillAttackLockScreen == false then
                    cameraFocusChange(v)
                end 
            end
        end
    end

    -- self.center_offset.x = self.center_left_offset.x + (self.center_right_offset.x - self.center_left_offset.x) / 2 - size.width / 2 - app.baseOffsetX / 2
    self.center_position.x = self.center_left_offset.x + (self.center_right_offset.x - self.center_left_offset.x) / 2
    -- self.center_left_offset.x = self.center_left_offset.x - 200
    -- self.center_right_offset.x = self.center_right_offset.x + 200

    if self.open_camera == true then
        -- -->___crint("self.center_offset.x", self.center_offset.x, app.baseOffsetX)
        -- state_machine.excute("fight_scene_camera_focussing", 0, self.center_offset)
        state_machine.excute("fight_scene_camera_focussing", 0, {self.center_position, self.center_left_offset, self.center_right_offset})
    end

    -- if heroCount == 0 or masterCount == 0 then
    --     state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
    -- end
end

function FightRoleController:checkIsStartUpAutoTick( ... )
    local currentNPCId = tonumber(_ED._scene_npc_id)
    if currentNPCId == 1 or currentNPCId == 2 or currentNPCId == 3 then
        local npcLastState = 0
        if _ED.npc_last_state == nil then
            npcLastState = -1
        else
            npcLastState = zstring.tonumber(_ED.npc_last_state[currentNPCId]) or -1
        end
        if npcLastState <= 0 then
            self.isCanStartUpAutoTick = false
        else
            self.isCanStartUpAutoTick = true
        end
    else
        self.isCanStartUpAutoTick = true
    end
end

function FightRoleController:onEnterTransitionFinish()

end

function FightRoleController:beginHetiSkill( params )
    self.isLockScene = true
    self:setVisible(false)
    for i,v in pairs(params) do
        if v ~= nil then
            state_machine.excute("fight_role_remove_armature", 0 , v)
        end
    end
end

function FightRoleController:endHetiSkill( params )
    -- state_machine.excute("fight_scene_blink_white", 0, nil)
    -- local csbNode = csb.createNode("battle/battle_map_heng_role_hetiji_zhuanchang.csb")
    -- local action = csb.createTimeline("battle/battle_map_heng_role_hetiji_zhuanchang.csb")
    -- csbNode:runAction(action)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end
    --     local str = frame:getEvent()
    --     if str == "end" then
    --         fwin._ui._layer:removeChild(csbNode)
    --     end
    -- end)
    -- fwin._ui._layer:addChild(csbNode)
    -- action:play("zhuanchang", false)

    self.isLockScene = false
    self.open_camera = true
    self:setVisible(true)
    for i,v in pairs(params[2]) do
        if v ~= nil then
            state_machine.excute("fight_role_add_armature", 0, {role = v, isAttack = true})
        end
    end
    for i,v in pairs(params[3]) do
        if v ~= nil then
            state_machine.excute("fight_role_add_armature", 0, {role = v, isAttack = false})
        end
    end
    for k,v in pairs(self._hero_formation) do
        if v ~= nil and v.parent ~= nil then
            local isSame = false
            for k1,v1 in pairs(params[2]) do
                if v1 ~= nil and v1._info ~= nil and v1._info._pos == v._info._pos then
                    isSame = true
                end
            end
            if isSame == false then
                state_machine.excute("fight_role_reset_armature", 0, v)
            end
        end
    end
    for k,v in pairs(self._master_formation) do
        if v ~= nil and v.parent ~= nil then
            local isSame = false
            for k1,v1 in pairs(params[3]) do
                if v1 ~= nil and v1._info ~= nil and v1._info._pos == v._info._pos then
                    isSame = true
                end
            end
            if isSame == false then
                state_machine.excute("fight_role_reset_armature", 0, v)
            end
        end
    end
    local hero = params[1]
    hero:hetiSkillEnd()
end

function FightRoleController:getIsAutoFight( ... )
    local isAuto = false
    local result = cc.UserDefault:getInstance():getStringForKey(getKey("m_isAutoFight"))
    if result == nil then
        isAuto = false
    end
    if tonumber(result) == 0 then
        isAuto = false
    elseif tonumber(result) == 1 then
        isAuto = true
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        self.auto_select = isAuto
        return false
    else
        return isAuto
    end
end

function FightRoleController:saveAsAuFightType( isAuto )
    local result = 1
    if isAuto == false then
        result = 0
    end
    cc.UserDefault:getInstance():setStringForKey(getKey("m_isAutoFight"), result)
    cc.UserDefault:getInstance():flush()
end

function FightRoleController:onLoadAssets()
    local effect_paths = "images/ui/effice/effect_zhandou_gongji/effect_zhandou_gongji.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end

function FightRoleController:unLoadAssets()
    local effect_paths = "images/ui/effice/effect_zhandou_gongji/effect_zhandou_gongji.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
end

function FightRoleController:onExit()
    __________b = false
    FightRole.__g_role_attacking = false
    FightRole.__g_lock_sp_attack = false
    FightRole.__g_lock_camp_attack = 0
    FightRole._current_attack_camp = -1
    FightRole._last_attack_camp = -1
    FightRole.__priority_camp = -1

    FightRole.__skeep_fighting = false
    FightRole.__fit_attacking = false

    FightRoleController.__lock_battle = false
    FightRoleController.__battle_formation_info = {}
    self:unLoadAssets()
    state_machine.remove("fight_role_controller_manager")
    state_machine.remove("fight_role_controller_role_enter_into_over")
    state_machine.remove("fight_role_controller_change_battle")
    state_machine.remove("fight_role_controller_request_next_fight")
    state_machine.remove("fight_role_controller_notification_role_be_kill")
    state_machine.remove("fight_role_controller_notification_skeep_fight")
    state_machine.remove("fight_role_controller_notification_role_death_over")
    state_machine.remove("fight_role_controller_notification_role_death_for_last_kill")
    state_machine.remove("fight_role_controller_notification_role_celebrate_win_over")
    state_machine.remove("fight_role_controller_ready_fight")
    state_machine.remove("fight_role_controller_start_fight")
    state_machine.remove("fight_role_controller_start_round_fight")
    state_machine.remove("fight_role_controller_check_next_round_fight")
    state_machine.remove("fight_role_controller_add_wake_up_beAttack_effect")
    state_machine.remove("fight_role_controller_hero_info_ui_show")
    state_machine.remove("fight_role_controller_hero_info_ui_show_by_pos")
    state_machine.remove("fight_role_controller_update_hp_progress")
    state_machine.remove("fight_role_controller_skeep_fight")
    state_machine.remove("fight_role_controller_reset_role_position")
    state_machine.remove("fight_role_controller_change_to_next_attack_role")
    state_machine.remove("fight_role_controller_qte_to_next_attack_role")
    state_machine.remove("fight_role_controller_update_camp_boundary")
    state_machine.remove("fight_role_controller_camera_focus_with_role")
    state_machine.remove("fight_role_controller_restart_qte_timer")
    state_machine.remove("fight_role_controller_change_to_auto_fight")
    state_machine.remove("fight_role_controller_change_to_stop_fight")
    state_machine.remove("fight_role_controller_startup_comkill_progress")
    state_machine.remove("fight_role_controller_fight_end_stop_auto")
    state_machine.remove("fight_role_controller_begin_mission")
    state_machine.remove("fight_role_controller_mission_fight")
    state_machine.remove("fight_role_controller_update_dialog_state")
    state_machine.remove("fight_role_controller_begin_hetiSkill")
    state_machine.remove("fight_role_controller_end_hetiSkill")
    state_machine.remove("fight_role_controller_hide_role_layer")
    state_machine.remove("fight_role_controller_load_success")
    state_machine.remove("fight_role_controller_wake_up_beAttack_effect")
    state_machine.remove("fight_role_controller_reset_comkill_progress")
    state_machine.remove("fight_role_controller_select_by_attack_role")
    state_machine.remove("fight_role_controller_play_power_skill_screen_effect")
    state_machine.remove("fight_role_controller_check_same_hero_tip_info")
    state_machine.remove("fight_role_controller_check_battle_speed")
    state_machine.remove("fight_role_controller_check_battle_speed_for_mission")
    state_machine.remove("fight_role_controller_battle_lock_attack_for_mission")
    state_machine.remove("fight_role_controller_visible_formation")
    state_machine.remove("fight_role_controller_remove_be_attacker_effect")
    state_machine.remove("fight_role_controller_update_role_animation_speed")
    state_machine.remove("fight_role_controller_change_battle_role")
    state_machine.remove("fight_role_controller_update_draw_battle_start_influence_info")
    state_machine.remove("fight_role_controller_update_draw_round_influence_info")
    state_machine.remove("fight_role_controller_update_draw_camp_change_influence_info")
    state_machine.remove("fight_role_controller_auto_select")
    state_machine.remove("fight_role_controller_update_draw_ui_window")
end
