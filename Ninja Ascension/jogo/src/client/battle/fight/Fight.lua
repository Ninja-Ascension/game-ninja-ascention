Fight = class("FightClass", Window)

Fight._self = nil

local fight_window_open_terminal = {
    _name = "fight_window_open",
    _init = function (terminal)
        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            app.load("client.red_alert_time.battle.battle_macros")
            app.load("client.red_alert_time.battle.battle_logic")
            cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
            cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
        end
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        app.notification_center.running = false
        fwin:allCovers()

        executeResetCurrentEvent()

        local fightWindow = Fight:new()
        fightWindow:init(_ED._battle_init_type, 
            _ED._current_scene_id, 
            _ED._scene_npc_id, 
            _ED._npc_difficulty_index, 
            _ED._npc_addition_params)
        fightWindow:initMap()
        fwin:open(fightWindow, fwin._view)

        fightWindow:initHeros()
        state_machine.excute("fight_draw_ui", 0, 0)

        state_machine.excute("pve_attack_close", 0, 0)

        -- state_machine.excute("fight_hero_into", 0, 0)
        -- state_machine.excute("home_button_window_hide", 0, 0)
        -- state_machine.excute("main_window_hide", 0, 0)
        -- state_machine.excute("pve_manager_hide", 0, 0)
        -- state_machine.excute("pve_map_hide", 0, 0)
        -- -- state_machine.excute("fight_is_over", 0, 0)
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fight_window_open_terminal)
state_machine.init()

function showSpineAnimationStandby(armature, actionIndex)
    if __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_pokemon 
        then
        local pos = zstring.tonumber(armature._pos)
        if armature ~= nil and pos ~= 102 then
            if armature._spArmature ~= nil then
                if actionIndex == 0 then
                    armature._spArmature:setVisible(true)
                    armature:setVisible(false)
                else
                    armature._spArmature:setVisible(false)
                    armature:setVisible(true)
                end
            else
                armature:setVisible(true)
            end
        end
    end
end

function Fight:ctor()

    Fight._self = self
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- fwin:cleanView(fwin._background)
    -- fwin:cleanView(fwin._view)
    -- fwin:cleanView(fwin._viewdialog)
    -- fwin:cleanView(fwin._taskbar)
    -- fwin:cleanView(fwin._ui)
    self._petHero = nil
    self._inited = false
    self._need_inited = 0
    self._init_status = 0
    self._fightIsOver = false
    self._waitOverTime = 1

    self._exportJsons = {}
    self._exportJsonIndex = 0
    self._exportJsonOver = false

    self._spineJsons = {}
    self._spineEffects = {}

    self._show_name = false
    self._show_sp = false
    self._show_hp = false

    self._actionTimeSpeed = 1.0

    self._fight_type = -1
    self._scene_id = -1
    self._npc_id = -1
    self._npc_type = "0"
    self._difficulty = -1
    self._addition_params = "0".."\r\n".."0"
    self._map_index = "0"
    self._map_background_image_index = -1

    self._canSkipFighting = false

    self._heroCount = 0
    self._heros = {}
    self._hero_formation = {} --我方角色组
    self._heroReadyToFightCount = 0


    self._masterCount = 0
    self._masters = {}
    self._master_formation = {}
    self._masterReadyToFightCount = 0

    self._fightMapLayer = nil

    self._currentFightIndex = 1
    self._totalFightCount = 1
    self._attackLogicRunning = false
    self._fightLogicOver = false

    self._isHaveStory = false

    self.fightScene = nil

    self.zoarium_skill_list = {}
    self.zoarium_skills = {}

    self._boss_battle_card_num = nil -- 用于显示某个特殊boss的形象(日常副本使用) 
    self._boss_battle_card_string = "sprite/boss_battle_card_%d.ExportJson" -- 用于显示某个特殊boss的形象(日常副本使用) 

    self.skip_misson = false 
    self.isMasterPet = false -- 敌方是否有宠物   
    self.master_mould_id = 0 -- 敌方宠物ID

    self._bullets = {}

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local kname = "userFightSpeed"
        _ED.user_set_fight_recorder_action_time_speed = readKey(kname)
        if zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed) > 0 then
            local isSame = false
            for k,v in pairs(_enum_action_time_speed) do
                if v == zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed) then
                    isSame = true
                    break
                end
            end
            if isSame == true then
                __fight_recorder_action_time_speed = zstring.tonumber(_ED.user_set_fight_recorder_action_time_speed)
            else
                __fight_recorder_action_time_speed = _enum_action_time_speed[1]
                _ED.init_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
            end
            __fight_recorder_action_time_speed = 1.0
        else
            __fight_recorder_action_time_speed = _enum_action_time_speed[1]
            _ED.init_fight_recorder_action_time_speed = __fight_recorder_action_time_speed
        end
    end

    -- Initialize fight page state machine.
    local function init_fight_terminal()
        -- 英雄入场
        local fight_hero_into_terminal = {
            _name = "fight_hero_into",
            _init = function (terminal)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_red_alert 
                    or __lua_project_id == __lua_project_legendary_game then
                    app.load("client.landscape.duplicate.LDuplicateWindow")
                    app.load("client.battle.fight.FightRoundOne")
                end
                app.load("client.battle.BattleFormationController")
                app.load("client.battle.fight.DrawHitDamage")
                app.load("client.battle.fight.FightEnum")
                app.load("client.battle.fight.FightRecorder")
                app.load("client.battle.fight.FightMap")
                app.load("client.battle.fight.FightRound")
                app.load("client.battle.fight.FightUI")
                app.load("client.battle.fight.Master")
                app.load("client.battle.fight.Hero")
                -- app.load("client.battle.fight.NormalLogic")
                app.load("client.battle.fight.FightUIForDailyActivityCopy")
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    app.load("client.l_digital.campaign.trialtower.TrialTowerBattleDescribe")
                else
                    app.load("client.campaign.trialtower.TrialTowerBattleDescribe")
                end
                app.load("client.campaign.worldboss.WorldbossBattleDescribe")
                app.load("client.campaign.worldboss.WorldbossBattleTipTitle")
                
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- if instance._init_status == 0 then
                --     instance._init_status = 3
                --     return false
                -- end
                -- local fightWindow = instance
                local fightWindow = fwin:find("FightClass")
                fightWindow:playAnimationByHeroIntoFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 有英雄入场结束
        local fight_hero_into_over_terminal = {
            _name = "fight_hero_into_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("hero_ready_to_fight_state", 0, instance._heros[tonumber(""..params)])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 英雄战场重置结束
        local fight_hero_reset_over_terminal = {
            _name = "fight_hero_reset_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i, v in pairs(instance._heros) do
                    state_machine.excute("hero_reset_to_fight_state", 0, v)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 有英雄战斗准备结束
        local fight_hero_fight_ready_over_terminal = {
            _name = "fight_hero_fight_ready_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._heroReadyToFightCount = instance._heroReadyToFightCount + 1
                if instance._heroReadyToFightCount == table.getn(instance._heros) then
                    --> print("所有英雄都已经准备好战斗。")
                    if _ED.formation_pet_id ~= nil and  _ED.formation_pet_id ~= 0 then 
                        --播放宠物战斗加层动画
                        instance:playAnimationByPetToHeros(0,_ED.user_ship["".._ED.formation_pet_id].ship_template_id)
                    else
                        state_machine.excute("fight_master_into_start", 0, 0)
                    end
                    
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --敌方宠物开始播放加层属性动画
        local fight_master_play_pet_ready_terminal = {
            _name = "fight_master_play_pet_ready",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                instance:playAnimationByPetToHeros(1,instance.master_mould_id)
               
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --宠物加层完毕准备战斗
        local fight_pet_play_over_terminal = {
            _name = "fight_pet_play_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal._isOver == nil then 
                    state_machine.excute("fight_master_into_start", 0, 0)
                    terminal._isOver = true
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --敌方宠物加层完毕准备战斗
        local fight_pet_play_master_over_terminal = {
            _name = "fight_pet_play_master_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal._isOver == nil then
                    state_machine.excute("fight_request_battle", 0, instance._currentFightIndex)
                    terminal._isOver = true
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 有英雄战斗重置结束
        local fight_hero_fight_reset_over_terminal = {
            _name = "fight_hero_fight_reset_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._heroReadyToFightCount = instance._heroReadyToFightCount + 1
                if instance._heroReadyToFightCount == table.getn(instance._heros) then
                    --> print("所有英雄都已经重置好战斗。")
                    state_machine.excute("fight_master_into_start", 0, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 敌方入场
        local fight_master_into_start_terminal = {
            _name = "fight_master_into_start",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --> print("敌方入场", instance._currentFightIndex)
                instance:initMasters()
                if instance.isMasterPet == true then 
                    state_machine.excute("fight_map_master_into_play_pet", 0, instance._currentFightIndex)
                else
                    state_machine.excute("fight_map_master_into", 0, instance._currentFightIndex)    
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示战斗阵型UI
        local fight_draw_formation_ui_terminal = {
            _name = "fight_draw_formation_ui",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawFightFormationUI()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示战斗UI
        local fight_draw_ui_terminal = {
            _name = "fight_draw_ui",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawFightUI()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求战斗
        local fight_request_battle_terminal = {
            _name = "fight_request_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if true then
                    --> print("准备请求战斗")
                    if true ~= _ED._battle_wait_change_scene and missionIsOver() == false then
                        --> print("有剧情事件，进入事件的执行逻辑。")
                        executeNextEvent(nil, false)
                    else
						if self._fight_type == _enum_fight_type._fight_type_101 then
							if __lua_project_id ~= __lua_project_gragon_tiger_gate
                                and __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2
                                and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_naruto 
                                then
								_ED.init_environment_fight_complete = false
								state_machine.excute("fight_start_fight", 0, 0)
								return true
							end
						end
                        if self._fight_type == _enum_fight_type._fight_type_10
                            or self._fight_type == _enum_fight_type._fight_type_11
                            or self._fight_type == _enum_fight_type._fight_type_13
                            -- or self._fight_type == _enum_fight_type._fight_type_53
                            or self._fight_type == _enum_fight_type._fight_type_109
							or self._fight_type > _enum_fight_type._fight_type_101
                            or self._fight_type == _enum_fight_type._fight_type_211
                            or self._fight_type == _enum_fight_type._fight_type_213
                            or self._fight_type == _enum_fight_type._fight_type_214
                            or self._fight_type == _enum_fight_type._fight_type_218
                            or self._fight_type == _enum_fight_type._fight_type_219
                            or self._fight_type == _enum_fight_type._fight_type_220
                            or _ED.init_environment_fight_complete == true
                            then
                                -- 已经提前请求过战斗数据,直接打吧
                            _ED.init_environment_fight_complete = false 
                            state_machine.excute("fight_start_fight", 0, 0)
                        else 
                            --> print("普通PVE战斗，开始向服务器请求战斗数据。")
                            local function responseEnvironmentFightCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    --> print("战斗请求成功。", response.node._currentBattleIndex)
                                    --response.node:startFight()
                                    state_machine.excute("fight_start_fight", 0, 0)
                                end
                            end
							
							if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
								app.load("client.battle.report.BattleReport")
								local fightModule = FightModule:new()
								fightModule:doFight()
								
								responseEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
							else
                                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                                    or __lua_project_id == __lua_project_red_alert then
                                    if self._fight_type ~= _enum_fight_type._fight_type_8 and
                                        self._fight_type ~= _enum_fight_type._fight_type_10 and
                                        self._fight_type ~= _enum_fight_type._fight_type_11 and 
                                        self._fight_type ~= _enum_fight_type._fight_type_13 and 
                                        self._fight_type ~= _enum_fight_type._fight_type_14 and 
                                        -- self._fight_type ~= _enum_fight_type._fight_type_53 and 
                                        self._fight_type ~= _enum_fight_type._fight_type_102 and
                                        self._fight_type ~= _enum_fight_type._fight_type_107 
                                        and self._fight_type ~= _enum_fight_type._fight_type_211
                                        and self._fight_type ~= _enum_fight_type._fight_type_213
                                        and self._fight_type ~= _enum_fight_type._fight_type_214
                                        and self._fight_type ~= _enum_fight_type._fight_type_218
                                        and self._fight_type ~= _enum_fight_type._fight_type_219
                                        and self._fight_type ~= _enum_fight_type._fight_type_220
                                        then
                                        if self._fight_type == _enum_fight_type._fight_type_101 then
                                            responseEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                                            return true
                                        end
                                        local function responseBattleStartCallback( response )
                                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                                app.load("client.battle.report.BattleReport")
                                                if _ED._fightModule == nil then
                                                    _ED._fightModule = FightModule:new()
                                                end
                                                _ED.attackData = {
                                                    roundCount = _ED._fightModule.totalRound,
                                                    roundData = {}
                                                }
                                                if self._fight_type == _enum_fight_type._fight_type_101 then
                                                    local resultBuffer = {}
                                                    _ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0, resultBuffer)
                                                    local orderList = {}
                                                end
                                                _ED.attackData.isWin = _ED._fightModule.result
                                                local orderList = {}
                                                _ED._fightModule:initFightOrder(_ED.user_info, orderList)
                                                responseEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                                            end
                                        end
										if self._fight_type == _enum_fight_type._fight_type_105 then
                                            NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                                        else
                                            if MissionClass._isFirstGame == true then
                                                responseEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                                            else
                                                responseBattleStartCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                                            end
                                        end
                                    else
                                        if self._fight_type == _enum_fight_type._fight_type_8 or
                                            self._fight_type ~= _enum_fight_type._fight_type_107 then
                                            responseEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                                            return true
                                        else
                                            local battleFieldInitParam = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
                                            protocol_command.battle_field_init.param_list = battleFieldInitParam
                                            NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseEnvironmentFightCallback, false, nil)
                                        end
                                    end
                                else
    								protocol_command.environment_fight.param_list = ""..instance._scene_id.."\r\n"..instance._npc_id.."\r\n"..instance._difficulty.."\r\n"..self._addition_params
    								NetworkManager:register(protocol_command.environment_fight.code, nil, nil, nil, instance, responseEnvironmentFightCallback, false, nil)
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
        
        -- 开始战斗
        local fight_start_fight_terminal = {
            _name = "fight_start_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --> print(" === 开始战斗 === ")
                instance:loadAttackEffects()
                -- instance:startFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --战斗开始加重资源
        local fight_begin_load_assets_terminal = {
            _name = "fight_begin_load_assets",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:LoadAssetsInTigerGate()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --战斗资源加载结束
        local fight_load_assets_end_terminal = {
            _name = "fight_load_assets_end",
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


        -- 战斗开始检测boss介绍
        local fight_attack_check_boss_instro_terminal = {
            _name = "fight_attack_check_boss_instro",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
                    then
                    if instance.isPveType then
                        local npc_id = tonumber(_ED._scene_npc_id)
                        if tonumber(_ED.npc_state[npc_id]) == 0 then
                            if instance._currentFightIndex >= instance._totalFightCount then
                                local boss_ids = zstring.split(dms.string(dms["npc"],npc_id,npc.boss_id), ",")
                                if #boss_ids > 1 then
                                    app.load("client.mission.boss.BossIntroduce")
                                    state_machine.excute("bossintroduce_open_window", 0, boss_ids)
                                    return true
                                end
                            end
                        end
                    end
                elseif __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert 
                    then
                    if tonumber(_ED.battleData._currentBattleIndex) == 1 then
                        local npc_id = tonumber(_ED._scene_npc_id)
                        if tonumber(_ED.npc_state[npc_id]) == 0 then
                            local boss_id = dms.int(dms["npc"],npc_id,npc.boss_id)
                            if boss_id > 0 then
                                app.load("client.mission.boss.BossIntroduce")
                                state_machine.excute("bossintroduce_open_window", 0, boss_id)
                                return true
                            end
                        end
                    end
                end
                return false
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗回合开始
        local fight_attack_round_start_terminal = {
            _name = "fight_attack_round_start",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                __fight_recorder_action_time_speed_index = __fight_recorder_action_time_speed_index or 1
                fwin._close_touch_end_event = false
                -- FightRoleController.__lock_battle = false

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    then
                    -- 绘制回合前的效用状态信息
                    state_machine.excute("fight_role_controller_update_draw_battle_start_influence_info")
                    state_machine.excute("fight_role_controller_update_draw_round_influence_info")
                end

                if _ED.battleData.battle_init_type ~= 0 and isMissionSnatch() ~= true then
                
                else
                    if true ~= _ED._battle_wait_change_scene then
                        local isHaveMission = executeMissionExt(mission_mould_battle, touch_off_mission_start_battle, 
                            "".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil)
                        
                        if __lua_project_id == __lua_project_gragon_tiger_gate
                            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                            then
                            if executeMissionExt(mission_mould_battle, touch_off_mission_comkill, 
                            "".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) then
                                isHaveMission = true
                            end
                        end
                        
                        state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                        state_machine.unlock("battle_qte_head_touch_head_role")
                        
                        if isHaveMission == true then
                            --> print("有战斗回合开始事件")
                            -- state_machine.excute("fight_attack_check_boss_instro", 0, 0)
                            return false
                        end
                    end
                end
                --if state_machine.excute("fight_attack_check_boss_instro", 0, 0) == false then
                    state_machine.excute("fight_attack_logic_round_running", 0, 0)
                --end
                if nil ~= _ED._fightModule then
                    state_machine.excute("fight_role_controller_check_battle_speed", 0, 0)
                    _ED._battle_wait_change_scene = false
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 战斗回合启动
        local fight_attack_round_logic_running_terminal = {
            _name = "fight_attack_logic_round_running",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- --> print("战斗回合启动。", instance._attackLogicRunning, instance._fightLogicOver)
                if instance._attackLogicRunning == true then
                    --> print("返回战斗。")
                    BattleSceneClass:resumePVEBattle()
                else
                    if instance._fightLogicOver == true then
                        --> print("返回可以结束了。")
                        -- state_machine.excute("fight_is_over", 0, 0)
                        attack_logic.__fight_is_over = true
                    else
                        -- state_machine.excute("fight_draw_ui", 0, 0)
                        --> print("开始战斗逻辑。")
                        instance._attackLogicRunning = true
                        -- NormalLogic:startPVEBattle(_ED.battleData, _ED.attackData, instance._hero_formation, instance._master_formation)
                        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                            or __lua_project_id == __lua_project_red_alert 
                            or __lua_project_id == __lua_project_legendary_game 
                            then
                            -- instance._currentFightIndex = instance._currentFightIndex + 1
                        end
                        BattleSceneClass:startPVEBattle(_ED.battleData, _ED.attackData, instance._hero_formation, instance._master_formation)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 校验进入下一场战斗
        local fight_check_next_fight_terminal = {
            _name = "fight_check_next_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._attackLogicRunning = false
                --> print("校验进入下一场战斗", instance._currentFightIndex, instance._totalFightCount, _ED.attackData.isWin)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
                        _ED.attackData.isWin = "1"
                        _ED._fightModule.fightResult = 1
                    end
                end
                if instance._currentFightIndex >= instance._totalFightCount
                    or (_ED.attackData.isWin == "0" and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_214   and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_219  and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_220  )
                    then
                    --> print("没有下一场战斗了，战斗可以结束了。", _ED.attackData.isWin, _ED.battleData.battle_init_type)
                    instance._fightLogicOver = true
                    if __lua_project_id == __lua_project_gragon_tiger_gate 
                        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                        or __lua_project_id == __lua_project_red_alert 
                        or __lua_project_id == __lua_project_legendary_game 
                        then
                        self._fightIsOver = true
                        if tonumber(_ED.attackData.isWin) == 1 then
                            --> print("准备启动战斗结束事件", instance.skip_misson)
                            if instance.skip_misson == false then
                                --> print("启动战斗结束事件")
                                if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, 
                                    "".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) == true then
                                    instance._isHaveStory = true
                                    --> print("进入战斗结束事件中")
                                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                        then
                                    else
                                        instance:fightOver()
                                    end
                                end
                            end
                        else
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
                                    instance:fightOver()
                                else
                                    instance:fightEnd()
                                end
                            else
                                instance:fightEnd()
                            end
                        end
                        return
                    end
                    
                    if _ED.battleData.battle_init_type ~= 0 and isMissionSnatch() ~= true then
                    
                    else
                        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                        else
                            -- 当前是普通副本战斗结束,如果战斗失败了,就不要进到教学去
                        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_0 
                            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_54 then
                                if _ED.attackData.isWin == "1" then
                                    if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, 
                                        "".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) == true then
                                        --> print("有战斗结束前的事件")
                                        return
                                    end
                                end
                            else
                                if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, 
                                    "".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) == true then
                                    --> print("有战斗结束前的事件")
                                    if _ED.battleData.battle_init_type == 10 then
                                        state_machine.excute("tuition_controller_touch_node", 0, {
                                            _datas = {
                                                terminal_name = "tuition_controller_touch_node",
                                                terminal_state = 0, 
                                            }
                                        })
                                    end
                                    return
                                end
                            end

                            -- if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, 
                                -- "".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) == true then
                                -- --> print("有战斗结束前的事件")
                                -- if _ED.battleData.battle_init_type == 10 then
                                    -- state_machine.excute("tuition_controller_touch_node", 0, {
                                        -- _datas = {
                                            -- terminal_name = "tuition_controller_touch_node",
                                            -- terminal_state = 0, 
                                        -- }
                                    -- })
                                -- end
                                -- return
                            -- end
                        end   
                    end 
                        
                    -- instance:fightOver()
                    -- if _ED.attackData.roundCount == _ED.attackData.totalRoundCount then
                    --  state_machine.excute("fight_is_over", 0, 0)
                    -- else
                    --  attack_logic.__fight_is_over = true
                    -- end

                    self._fightIsOver = true
                else
                    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                        or __lua_project_id == __lua_project_red_alert 
                        or __lua_project_id == __lua_project_legendary_game 
                        then
                        instance._currentFightIndex = instance._currentFightIndex + 1
                        _ED.battleData._currentBattleIndex = instance._currentFightIndex
                        state_machine.excute("fight_request_battle", 0, 0)
                    else
                        instance._heroReadyToFightCount = 0
                        instance:resetRoleInfo()
                        -- 隐藏角色小头像
                        state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
                        state_machine.excute("battle_formation_hide_ui", 0, 0)
                        state_machine.excute("fight_ui_visible", 0, false)
                        
                        if __lua_project_id == __lua_project_warship_girl_b
                            or __lua_project_id == __lua_project_digimon_adventure 
                            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
                            or __lua_project_id == __lua_project_naruto 
                            or __lua_project_id == __lua_project_pokemon 
                            or __lua_project_id == __lua_project_rouge 
                            or __lua_project_id == __lua_project_yugioh 
                            or __lua_project_id == __lua_project_koone 
                            then
                            attack_logic.__hero_ui_lock = true
                            state_machine.excute("fight_hero_info_ui_show", 0, {_datas = {_type = 0, _visible = false}})
                        end
                        
                        instance:playAnimationByHeroIntoNextFight()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 校验战斗跳过是否结束
        local fight_check_skeep_fight_terminal = {
            _name = "fight_check_skeep_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._attackLogicRunning = false
                if instance._currentFightIndex >= instance._totalFightCount then
                    instance._fightLogicOver = true
                    
                    if _ED.battleData.battle_init_type ~= 0 and isMissionSnatch() ~= true then
                    
                    else
                        if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, 
                         "".._ED._scene_npc_id.."v".._ED.battleData._currentBattleIndex, nil) == true then
                            
                            
                            -- 修改时间 07/15 
                            -- 修正教学抢夺时,点跳过指引,此处会直接return,导致__fight_is_over不能被设置为结束. 游戏就一直卡在跳过界面了.
                            -- 此处的 return 注释处理
                            --return
                        end
                    end
                    -- state_machine.excute("fight_is_over", 0, 0)
                    attack_logic.__fight_is_over = true
                    if (__lua_project_id == __lua_project_warship_girl_a 
                        or __lua_project_id == __lua_project_warship_girl_b
                        or __lua_project_id == __lua_project_digimon_adventure 
                        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
                        or __lua_project_id == __lua_project_naruto 
                        or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge 
                        or __lua_project_id == __lua_project_yugioh) 
                        and BattleSceneClass._isSkepBattle == true and _ED.attackData.isWin == "0" then
                        state_machine.excute("fight_is_over", 0, 0)
                    end
                else
                    local function responseEnvironmentFightCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            response.node._currentFightIndex = response.node._currentFightIndex + 1
                            state_machine.excute("fight_check_skeep_fight", 0, 0)
                        end
                    end
					if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
						app.load("client.battle.report.BattleReport")
						local fightModule = FightModule:new()
						fightModule:doFight()
						
						responseEnvironmentFightCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
					else
						protocol_command.environment_fight.param_list = ""..instance._scene_id.."\r\n"..instance._npc_id.."\r\n"..instance._difficulty.."\r\n"..self._addition_params
						NetworkManager:register(protocol_command.environment_fight.code, nil, nil, nil, instance, responseEnvironmentFightCallback, false, nil)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 战斗结束
        local fight_is_over_terminal = {
            _name = "fight_is_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --> print("战斗结束。")
                state_machine.lock("fight_is_over", 0, "")
                instance:fightOver()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 退出战斗
        local fight_exit_terminal = {
            _name = "fight_exit",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --> print("退出战斗。")
                state_machine.lock("fight_exit", 0, "")
                instance:exitFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 角色进入下一场战斗的准备逻辑处理完毕
        local fight_hero_ready_next_fight_over_terminal = {
            _name = "fight_hero_ready_next_fight_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._heroReadyToFightCount = instance._heroReadyToFightCount + 1
                if instance._heroReadyToFightCount == table.getn(instance._heros) then
                    --> print("所有英雄下一场战斗移动前的准备工作完毕。")
                    instance._heroReadyToFightCount = 0
                    state_machine.excute("fight_hero_next_go", 0, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 启动角色进入下一场战斗的动画
        local fight_hero_next_go_terminal = {
            _name = "fight_hero_next_go",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fight_map_hero_next_go", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 跳过战斗
        local fight_skeep_fighting_terminal = {
            _name = "fight_skeep_fighting",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:skeepFighting()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 我方角色死亡
        local fight_hero_deathed_terminal = {
            _name = "fight_hero_deathed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("trial_tower_battle_describe_add_dead_unit_limit_count", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 对方角色死亡
        local fight_master_deathed_terminal = {
            _name = "fight_master_deathed",
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

        -- 更新战斗的总攻击次数
        local fight_total_attack_count_terminal = {
            _name = "fight_total_attack_count",
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

        -- 更新战斗的当前回合数
        local fight_total_round_count_terminal = {
            _name = "fight_total_round_count",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fight_ui_for_daily_activity_copy_update_fight_round_count", 0, params)
                
                state_machine.excute("trial_tower_battle_describe_add_round_count", 0, {_value = params[1]})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗中我方攻击总伤害
        local fight_total_attack_damage_terminal = {
            _name = "fight_total_attack_damage",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --state_machine.excute("fight_ui_for_daily_activity_copy_update_fight_damage", 0, params)
                state_machine.excute("world_boss_battle_describe_hurt_activity", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --我方血量更新
        local fight_hero_hp_update_terminal = {
            _name = "fight_hero_hp_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                local maxHP = 0
                local currentHP = 0

                for k, v in pairs(instance._hero_formation) do
                    if nil ~= v._armature and tonumber(v._armature._pos) ~= 101 
                        and tonumber(v._armature._pos) ~= 102 
                     then
                        maxHP = maxHP + tonumber(v._armature._brole._hp)
                        currentHP = currentHP + tonumber(v._armature._role._hp)
                    end
                end
                
                local percent = currentHP / maxHP * 100
                percent = math.floor(percent*10) / 10
                
                state_machine.excute("trial_tower_battle_describe_add_hp_remainder_percent", 0, {_value = percent})
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --全部英雄血条显示控制
        local fight_hero_info_ui_show_terminal = {
            _name = "fight_hero_info_ui_show",
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
                
                for i, v in pairs (instance._heros) do
                    if v._armature ~= nil then
                        if _type == 0 then -- 系统控制
                            local _visible = params._datas._visible
                            
                            if _visible == true and attack_logic.__hero_ui_visible == true 
                              or _visible == false then
                                if nil ~= v._armature._heroInfoWidget then
                                    v._armature._heroInfoWidget:controlLife(false, 1)
                                    v._armature._heroInfoWidget:showControl(_visible)
                                    
                                    -- 攻击时特殊处理
                                    v._armature._heroInfoWidget.bIsAttacking = false
                                end
                            end
                            
                        elseif _type == 1 then -- 手动控制
                            if nil ~= v._armature._heroInfoWidget then
                                v._armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
                            end
                        end 
                    end 
                end
                
                for i, v in pairs (instance._masters) do
                    if v._armature ~= nil then
                        if _type == 0 then -- 系统控制
                            local _visible = params._datas._visible
                            
                            if _visible == true and attack_logic.__hero_ui_visible == true 
                              or _visible == false then
                                if nil ~= v._armature._heroInfoWidget then
                                    v._armature._heroInfoWidget:controlLife(false, 1)
                                    v._armature._heroInfoWidget:showControl(_visible)
                                    
                                    -- 攻击时特殊处理
                                    v._armature._heroInfoWidget.bIsAttacking = false
                                end
                            end 
                            
                        elseif _type == 1 then -- 手动控制
                            if nil ~= v._armature._heroInfoWidget then
                                v._armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
                            end
                        end 
                    end
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --指定英雄血条显示控制
        local fight_hero_info_ui_show_by_pos_terminal = {
            _name = "fight_hero_info_ui_show_by_pos",
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
                    for i, v in pairs (instance._masters) do
                        if v._armature ~= nil and v._armature._pos == roleIndex then
                            v._armature._heroInfoWidget:controlLife(false, 2)
                            v._armature._heroInfoWidget:showControl(visible)
                            v._armature._heroInfoWidget:controlLife(true, 1)
                            
                            -- 攻击时特殊处理
                            v._armature._heroInfoWidget.bIsAttacking = visible == false and true or false
                            break
                        end
                    end
                elseif roleType == 2 then -- 我方
                    for i, v in pairs (instance._heros) do
                        if v._armature ~= nil and v._armature._pos == roleIndex then
                            v._armature._heroInfoWidget:controlLife(false, 2)
                            v._armature._heroInfoWidget:showControl(visible)
                            v._armature._heroInfoWidget:controlLife(true, 1)
                            
                            -- 攻击时特殊处理
                            v._armature._heroInfoWidget.bIsAttacking = visible == false and true or false
                            break
                        end
                    end
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --获取当前战斗类型
        local fight_get_current_fight_type_terminal = {
            _name = "fight_get_current_fight_type",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:getFightType()
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_get_zoarium_skill_list_terminal = {
            _name = "fight_get_zoarium_skill_list",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:getFightZoariumSkills()
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_get_zoarium_skill_movers_terminal = {
            _name = "fight_get_zoarium_skill_movers",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:getFightZoariumSkillMovers()
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_first_set_skip_misson_terminal = {
            _name = "fight_first_set_skip_misson",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.skip_misson = true 
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_add_bullet_terminal = {
            _name = "fight_add_bullet",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                table.insert(instance._bullets, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_remove_bullet_terminal = {
            _name = "fight_remove_bullet",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local bullet = params
                for i, v in pairs(instance._bullets) do
                    if v == bullet then
                        table.remove(instance._bullets, i, 1)
                        break
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
   
        state_machine.add(fight_hero_hp_update_terminal)
        state_machine.add(fight_hero_into_terminal)
        state_machine.add(fight_hero_into_over_terminal)
        state_machine.add(fight_hero_reset_over_terminal)
        state_machine.add(fight_hero_fight_ready_over_terminal)
        state_machine.add(fight_hero_fight_reset_over_terminal)
        state_machine.add(fight_master_into_start_terminal)
        state_machine.add(fight_draw_formation_ui_terminal)
        state_machine.add(fight_draw_ui_terminal)
        state_machine.add(fight_request_battle_terminal)
        state_machine.add(fight_start_fight_terminal)
        state_machine.add(fight_begin_load_assets_terminal)
        state_machine.add(fight_load_assets_end_terminal)
        state_machine.add(fight_attack_round_start_terminal)
        state_machine.add(fight_attack_round_logic_running_terminal)
        state_machine.add(fight_check_next_fight_terminal)
        state_machine.add(fight_check_skeep_fight_terminal)
        state_machine.add(fight_is_over_terminal)
        state_machine.add(fight_exit_terminal)
        state_machine.add(fight_hero_ready_next_fight_over_terminal)
        state_machine.add(fight_hero_next_go_terminal)
        state_machine.add(fight_skeep_fighting_terminal)
        state_machine.add(fight_hero_deathed_terminal)
        state_machine.add(fight_master_deathed_terminal)
        state_machine.add(fight_total_attack_count_terminal)
        state_machine.add(fight_total_round_count_terminal)
        state_machine.add(fight_total_attack_damage_terminal)
        state_machine.add(fight_hero_info_ui_show_terminal)
        state_machine.add(fight_hero_info_ui_show_by_pos_terminal)
        state_machine.add(fight_get_current_fight_type_terminal)
        state_machine.add(fight_get_zoarium_skill_list_terminal)
        state_machine.add(fight_get_zoarium_skill_movers_terminal)
        state_machine.add(fight_first_set_skip_misson_terminal)
        state_machine.add(fight_attack_check_boss_instro_terminal)
        state_machine.add(fight_pet_play_over_terminal)
        state_machine.add(fight_pet_play_master_over_terminal)
        state_machine.add(fight_master_play_pet_ready_terminal)
        state_machine.add(fight_add_bullet_terminal)
        state_machine.add(fight_remove_bullet_terminal)
        state_machine.init()
    end

    -- call func init fight state machine.
    init_fight_terminal()
end

function Fight:init(_fight_type, _scene_id, _npc_id, _difficulty, _addition_params)
    -- print("Fight:init---------", _fight_type, _scene_id, _npc_id)
    -- _ED.user_info.last_user_grade = _ED.user_info.user_grade
    -- _ED.user_info.last_user_food = _ED.user_info.user_food
    -- _ED.user_info.last_endurance = _ED.user_info.endurance
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        _ED.user_info.last_user_food = _ED.user_info.user_food
        _ED.user_info.last_endurance = _ED.user_info.endurance
    end
    _ED.user_info.last_user_experience = _ED.user_info.user_experience
    _ED.user_info.last_user_grade_need_experience = _ED.user_info.user_grade_need_experience

    if _fight_type ~= nil then
        self._fight_type = zstring.tonumber(_fight_type)
    end

    if _scene_id ~= nil then
        self._scene_id = zstring.tonumber(_scene_id)
    end

    if _npc_id ~= nil then
        self._npc_id = zstring.tonumber(_npc_id)
    end

    if _difficulty ~= nil then
        self._difficulty = zstring.tonumber(_difficulty)
    end
    
    if _addition_params ~= nil and _addition_params ~= "" then
        self._addition_params = _addition_params
    else
        self._addition_params = "0"
    end
    
    local mapIndex = "0"
    local mapBgIndex = "0"
    self._npc_type = dms.string(dms["npc"], self._npc_id, npc.npc_type)
    if self._npc_type == "1" then
        --> print("当前战斗为副本中的BOSS战。")
    end

    if self._npc_type == "1" then
        -- for i = 1, 6 do
        --  local v = _ED.battleData._armys[_ED.battleData._currentBattleIndex]._data["" .. i]
        --  if v ~= nil then
        --      if v._type == "1" then
        --          local sign_type = dms.int(dms["environment_ship"], v._mouldId, environment_ship.sign_type)
        --          if sign_type == 1 then
        --              self._boss_battle_card_num = dms.int(dms["environment_ship"], v._mouldId, environment_ship.sign_pic)
        --              break
        --          end
        --      end
        --  end
        -- end
    end
    if self._fight_type == _enum_fight_type._fight_type_14 then
    elseif self._fight_type >= _enum_fight_type._fight_type_10 then
        mapIndex = "99"
        mapBgIndex = "99"
    else
        local npcData = dms.element(dms["npc"], self._npc_id)
        if npcData ~= nil then
            mapIndex = dms.atos(npcData, npc.map_index)
            mapBgIndex = dms.atos(npcData, npc.battle_background)
        end
    end

    if _ED.nr_arena_fight_rank then
        -- NinjaAscension arena fought with the live engine: arena background.
        mapIndex = "99"
        mapBgIndex = "99"
        -- Arena uses the original timed/VIP skip control in FightUI. This
        -- battle is otherwise initialized as type 0 to run the live engine,
        -- so its normal type check would leave the skip button hidden.
        self._canSkipFighting = true
    end
    if self._fight_type == _enum_fight_type._fight_type_8 then
        mapIndex = "2"
        mapBgIndex = "2"
    end
    self._map_index = mapIndex
    self._map_background_image_index = mapBgIndex

    if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert
        then
        if self._fight_type == _enum_fight_type._fight_type_1 or self._fight_type == 15 then
            self._canSkipFighting = false
        elseif self._fight_type == _enum_fight_type._fight_type_7 or 
            self._fight_type == _enum_fight_type._fight_type_8 or
            self._fight_type == _enum_fight_type._fight_type_10 or 
            self._fight_type == _enum_fight_type._fight_type_11 or
            self._fight_type == _enum_fight_type._fight_type_13 or
            self._fight_type == _enum_fight_type._fight_type_53 or
            self._fight_type == _enum_fight_type._fight_type_104 or
            self._fight_type == _enum_fight_type._fight_type_102 or 
            self._fight_type == _enum_fight_type._fight_type_106 or 
            self._fight_type == _enum_fight_type._fight_type_107 or 
            self._fight_type == _enum_fight_type._fight_type_211 or
            self._fight_type == _enum_fight_type._fight_type_213 or
            self._fight_type == _enum_fight_type._fight_type_214 or 
            self._fight_type == _enum_fight_type._fight_type_219 or 
            self._fight_type == _enum_fight_type._fight_type_220 or 
            self._fight_type == _enum_fight_type._fight_type_218 or 
            self._fight_type == _enum_fight_type._fight_type_215
            -- 个人挑战的跳过功能有bug，计算结果的时候，会一直循环直到回合上限，然后判定我方输
            -- self._fight_type == _enum_fight_type._fight_type_216 or
            -- self._fight_type == _enum_fight_type._fight_type_217
            then
            self._canSkipFighting = true
        elseif self._fight_type == _enum_fight_type._fight_type_0 or 
            -- self._fight_type == _enum_fight_type._fight_type_1 or 
            self._fight_type == _enum_fight_type._fight_type_2 or 
            self._fight_type == _enum_fight_type._fight_type_3 or
            self._fight_type == _enum_fight_type._fight_type_4 or
            self._fight_type == _enum_fight_type._fight_type_51 or
            self._fight_type == _enum_fight_type._fight_type_52 or
            self._fight_type == _enum_fight_type._fight_type_53 or
            self._fight_type == _enum_fight_type._fight_type_54 or
            self._fight_type == _enum_fight_type._fight_type_108 then
            if self._fight_type == _enum_fight_type._fight_type_2 or 
                self._fight_type == _enum_fight_type._fight_type_3 or
                self._fight_type == _enum_fight_type._fight_type_51 or
                self._fight_type == _enum_fight_type._fight_type_52 then
                if funOpenDrawTip(174,false) == false then
                    self._canSkipFighting = true
                end
            else
                if _ED.npc_max_state ~= nil then
                    local npc_state = 0
                    local npcState = _ED.npc_state[tonumber(""..self._npc_id)]
                    local npcMaxState = _ED.npc_max_state[tonumber(""..self._npc_id)]
                    if npcState ~= nil and npcMaxState ~= nil then
                        if zstring.tonumber(npcState) < zstring.tonumber(npcMaxState) and zstring.tonumber(npcState) ~= 0 then
                            npc_state = npcMaxState
                        else
                            npc_state = npcState
                        end
                    end
                    if zstring.tonumber(npc_state) > 2 then
                        self._canSkipFighting = true
                    end
                end
            end
        end
    else
		if self._fight_type == _enum_fight_type._fight_type_0 or 
            self._fight_type == _enum_fight_type._fight_type_1 or 
            self._fight_type == _enum_fight_type._fight_type_2 or 
            self._fight_type == _enum_fight_type._fight_type_3 or
            self._fight_type == _enum_fight_type._fight_type_4 or
            self._fight_type == _enum_fight_type._fight_type_51 or
            self._fight_type == _enum_fight_type._fight_type_52 or
            self._fight_type == _enum_fight_type._fight_type_53 or
            self._fight_type == _enum_fight_type._fight_type_54 or
            self._fight_type == _enum_fight_type._fight_type_108 then
			if _ED.npc_max_state ~= nil then
				if zstring.tonumber(_ED.npc_state[tonumber(""..self._npc_id)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self._npc_id)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self._npc_id)]) ~= 0 then
					npc_state = tonumber(_ED.npc_max_state[tonumber(""..self._npc_id)])
				else
					npc_state = tonumber(_ED.npc_state[tonumber(""..self._npc_id)])
				end
				if npc_state > 2 then
					self._canSkipFighting = true
				end
			end
            if __lua_project_id == __lua_project_warship_girl_a 
                or __lua_project_id == __lua_project_warship_girl_b
                or __lua_project_id == __lua_project_digimon_adventure 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
                or __lua_project_id == __lua_project_naruto 
                or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge 
                or __lua_project_id == __lua_project_yugioh 
                then
                if self._canSkipFighting == true and _ED.npc_last_state ~= nil and zstring.tonumber(_ED.npc_last_state[tonumber(""..self._npc_id)]) <= 0 then
                    self._canSkipFighting = false
                end
            end
		end
        if self._fight_type >= _enum_fight_type._fight_type_10 and _ED.battleData.battle_init_type < _enum_fight_type._fight_type_101 or 
            self._fight_type == _enum_fight_type._fight_type_11 or
            self._fight_type == _enum_fight_type._fight_type_13 or
            -- self._fight_type == _enum_fight_type._fight_type_53 or
            self._fight_type == _enum_fight_type._fight_type_102 or
            self._fight_type == _enum_fight_type._fight_type_104 or 
            self._fight_type == _enum_fight_type._fight_type_107 or 
            self._fight_type == _enum_fight_type._fight_type_109 or
            self._fight_type == _enum_fight_type._fight_type_110 
            or self._fight_type == _enum_fight_type._fight_type_211
            or self._fight_type == _enum_fight_type._fight_type_213
            or self._fight_type == _enum_fight_type._fight_type_214
            or self._fight_type == _enum_fight_type._fight_type_218
            or self._fight_type == _enum_fight_type._fight_type_219
            or self._fight_type == _enum_fight_type._fight_type_220
            then
            self._canSkipFighting = true
        end

    end

    self._totalFightCount = _ED.battleData.battle_total_count
    fwin:open(BattleSceneClass:new(), fwin._background)

    self:playBackgroundMusic()

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
    else
        -- fwin:open(BattleFormationController:new(), fwin._view)
        self.battleFormationController = BattleFormationController:new()
        self.battleFormationController:retain()
    end
    -- init fight datas
    self:initEffect()
    -- self:initMap()
    -- self:initHeros()
    -- -- self:initMasters()
    
    -- if _ED.battleData.battle_init_type ~= 0 then
        -- _ED._scene_npc_id = 0
    -- end

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local isPveType = false
        if --self._fight_type == _enum_fight_type._fight_type_7 or
            self._fight_type == _enum_fight_type._fight_type_10 or --抢夺
            self._fight_type == _enum_fight_type._fight_type_11 or -- 竞技场
            -- self._fight_type == _enum_fight_type._fight_type_53 or --
            self._fight_type == _enum_fight_type._fight_type_102 or --罗刹道场
            self._fight_type == _enum_fight_type._fight_type_104 or--惩奸除恶目前也算pve
            self._fight_type == _enum_fight_type._fight_type_106 
            -- or self._fight_type == _enum_fight_type._fight_type_211 -- 王者之战
            -- or self._fight_type == _enum_fight_type._fight_type_213 -- 工会战
            then--资源矿
            isPveType = true
        end
		
		if isPveType == true then
            _ED._scene_npc_id = 0
            _ED.user_info.last_user_grade = _ED.user_info.user_grade
        end
    end
    return self
end

function Fight:playBackgroundMusic()
    local musicIndex = -1
    if _ED.battleData.battle_init_type == 10 then
        musicIndex = 98
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            musicIndex = battle_fight_type_10_bg_music
        end
    elseif _ED.battleData.battle_init_type == 14 then
        -- local npcIndex = LuaClasses["MineInformationClass"].__battleObj
        -- musicIndex = elementAt(NPC, npcIndex):atoi(npc.battle_background_music)
        
        -- local npcIndex = elementAt(spiritePalaceMould, tonumber(_ED.palace_inside_info.current_floor)):atoi(spirite_palace_mould.npc_index)
        -- musicIndex = elementAt(NPC, npcIndex):atoi(npc.battle_background_music)
    elseif _ED.battleData.battle_init_type == 16 then
        musicIndex = 99
    elseif _ED.battleData.battle_init_type == 11 then
        musicIndex = 99
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            musicIndex = battle_fight_type_11_bg_music
        end
    elseif _ED.battleData.battle_init_type == 12 then
        musicIndex = 99
    elseif _ED.battleData.battle_init_type == 13 then
        musicIndex = 6
    elseif _ED.battleData.battle_init_type == 5 then
        musicIndex = 99
    elseif _ED.battleData.battle_init_type == 213 then
        musicIndex = 6

    elseif _ED.battleData.battle_init_type == 214 then
        musicIndex = battle_fight_type_11_bg_music
    --elseif _ED.battleData.battle_init_type == fight_type_8 then
    --  musicIndex = 99
    elseif _ED.battleData.battle_init_type == fight_type_7 then
        local list =  zstring.split(_ED._scene_npc_id,",")
        local _scene_npc_id =  439 --list[#list]
        -- -- musicIndex = elementAt(NPC, tonumber(_scene_npc_id)):atoi(npc.battle_background_music)
        
        local npcData = dms.element(dms["npc"], _scene_npc_id)
        if npcData ~= nil then
            musicIndex = dms.atoi(npcData, npc.battle_background_music)
        end
    else
        -- -- musicIndex = elementAt(NPC, tonumber(_ED._scene_npc_id)):atoi(npc.battle_background_music)
        local npcData = dms.element(dms["npc"], _ED._scene_npc_id)
        if npcData ~= nil then
            musicIndex = dms.atoi(npcData, npc.battle_background_music)
        end
    end
    -- 开始播放背景音效（index : %d）", musicIndex
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        musicIndex = 2
        -- stopBgm()
        checkPlayEffect(42)
    else
        if musicIndex >= 0 then
            playBgm(formatMusicFile("background", musicIndex))
        end
    end
end

function Fight:resetRoleInfo()
    --> print("重置英雄数据，进入移动状态。")   
    state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
    for i, v in pairs(self._heros) do
        v:resetHeroInfo()
    end

    for i, v in pairs(self._masters) do
        if v ~= nil and v._currentParent ~= nil then
            v._currentParent:removeAllChildren(true)
        end
    end
end

function Fight:playAnimationByHeroIntoNextFight()
    --> print("播放下一场角色入场动画")
    self._currentFightIndex = self._currentFightIndex + 1
    _ED.battleData._currentBattleIndex = self._currentFightIndex
    state_machine.excute("fight_map_hero_into_next_fight", 0, self._currentFightIndex)
end

function Fight:startFight()
    -- --> print("战斗回合开始", self._currentFightIndex, _ED.battleData.battle_total_count)
    self._totalFightCount = _ED.battleData.battle_total_count

    -- 如果 战斗回合只有 1/1 则不显示当前的战斗回合数 07/11策划优化需求
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51 then
            if state_machine.excute("fight_role_controller_check_same_hero_tip_info", 0, 0) == true then
                self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function ( sender )
                    fwin:open(FightRound:new():init(sender._currentFightIndex, sender._totalFightCount), fwin._window)
                end)))
            else
                fwin:open(FightRound:new():init(self._currentFightIndex, self._totalFightCount), fwin._window)
            end
        else
            fwin:open(FightRound:new():init(self._currentFightIndex, self._totalFightCount), fwin._window)
        end
    else
        if zstring.tonumber(self._totalFightCount) == 1 then
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 
                    then
                    fwin:open(FightRound:new():init(self._currentFightIndex, 5), fwin._window)
                else
                    fwin:open(FightRoundOne:new():init(), fwin._window)
                end
            else
                state_machine.excute("fight_attack_round_start", 0, "")
            end
        else
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
                then
                if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51 then
                    if state_machine.excute("fight_role_controller_check_same_hero_tip_info", 0, 0) == true then
                        self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function ( sender )
                            fwin:open(FightRound:new():init(sender._currentFightIndex, sender._totalFightCount), fwin._window)
                        end)))
                    else
                        fwin:open(FightRound:new():init(self._currentFightIndex, self._totalFightCount), fwin._window)
                    end
                    -- app.load("client.battle.landscape.GhostCopySameHeroTip")
                    -- app.load("client.battle.landscape.GhostCopySameHeroSteamBubble")
                    -- local isHaveSameHero = false
                    -- -- 校验是否有相同的武将
                    -- for i, v in pairs(self._heros) do
                    --     for m, n in pairs(self._masters) do
                    --         if v._info._mouldId == n._info._mouldId or true then
                    --             v:addChild(GhostCopySameHeroTip:new():init(v))
                    --             n:addChild(GhostCopySameHeroTip:new():init(n))
                    --             isHaveSameHero = true
                    --             print("1111111111111111")
                    --         end
                    --     end
                    -- end
                    -- if true == isHaveSameHero then
                    --     self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function ( sender )
                    --         fwin:open(FightRound:new():init(sender._currentFightIndex, sender._totalFightCount), fwin._window)
                    --     end)))
                    -- else
                    --     fwin:open(FightRound:new():init(self._currentFightIndex, self._totalFightCount), fwin._window)
                    -- end
                else
                    fwin:open(FightRound:new():init(self._currentFightIndex, self._totalFightCount), fwin._window)
                end
            else
                state_machine.excute("fight_attack_round_start", 0, "")
            -- fwin:open(FightRound:new():init(self._currentFightIndex, self._totalFightCount), fwin._window)
            end
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        state_machine.excute("fight_ui_update_battle_count", 0, "" .. self._currentFightIndex .. "/" .. self._totalFightCount)

        if self._currentFightIndex > 1 then
            if true == self.isPveType then
                local byAttackerName = nil
                local headPic = nil
                local signType = 0
                local defnederSpeedValue = 0
                if nil ~= _ED.user_info.battleCache.byAttackerObjectsList then
                    for i, v in pairs(_ED.user_info.battleCache.byAttackerObjectsList[self._currentFightIndex]) do
                        byAttackerName = v.name
                        headPic = v.picIndex
                        defnederSpeedValue = v.attackSpeed
                        if (tonumber(v.signType) or 0) > 0 then
                            signType = v.signType
                            break
                        end
                    end
                end

                if _ED.nr_arena_fight_rank then
                -- NinjaAscension arena: the opponent player, not one of the ninjas.
                byAttackerName = _ED.nr_arena_defender_name or byAttackerName
                defnederSpeedValue = _ED.nr_arena_defender_speed or defnederSpeedValue
            end
            state_machine.excute("fight_ui_update_battle_player_info", 0, {_ED.user_info.user_name, byAttackerName, headPic, signType, _ED.user_info.battleCache.attackerSpeedValue, defnederSpeedValue,_ED._scene_npc_id,self._currentFightIndex})
            if _ED.nr_arena_fight_rank then
                -- Arena fights are automatic only, as in the original.
                state_machine.excute("fight_ui_begin_auto_fight", 0, {_datas = {terminal_name = "fight_ui_begin_auto_fight", terminal_state = 1}})
            end
            end
        end
    end
end

function Fight:loadAttackSkillInfluenceEffect(skillInfluenceId, _sforIndex) 
    -- 加载技能效用

    local function checkIsHaveSameResource( effectId )
        for k,v in pairs(self._spineJsons) do
            if ""..v == ""..effectId then
                return true
            end
        end
        return false
    end

    local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
    if skillInfluenceElementData ~= nil then
        local effectIdss = zstring.splits(dms.atos(skillInfluenceElementData, _sforIndex), "|", ",", function ( value )
            return tonumber(value)
        end)
        for _, effectIds in pairs(effectIdss) do
            for i, effectId in pairs(effectIds) do
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if effectId >= 0 and checkIsHaveSameResource(effectId) == false then
                        local fileName = string.format("effect/effice_%d.ExportJson", effectId)
                        self._exportJsons[fileName] = fileName
                        table.insert(self._spineJsons, effectId)
                    end
                else
                    if effectId >= 0 then
                        -- local function dataLoaded(percent)
                        --     if percent >= 1 then
                        --     end
                        -- end
                        local fileName = string.format("effect/effice_%d.ExportJson", effectId)

                        self._exportJsons[fileName] = fileName
                        table.insert(self._spineJsons, effectId)
                        -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded)
                    end
                end
            end
        end
    end
end

function Fight:loadAttackSkillInfluencesEffects(skillInfluences)
    for n, t in pairs(skillInfluences) do
        local _skf = t
        local skillInfluenceId  = tonumber(_skf.skillInfluenceId)
        -- 后段光效
        self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.bear_lighting_effect_id)
    end
end

function Fight:loadAttackEffects()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
        then
        self:startFight()
        return
    end
    if _ED._fightModule ~= nil then
        self._exportJsons = {}
        self._spineJsons = {}
        self._spineEffects = {}
        local formation_count = dms.int(dms["npc"], tonumber(_ED._scene_npc_id), npc.formation_count)
        for i=1,formation_count do
            local environmentIndex = npc.environment_formation1 + i - 1
            local environmentId = dms.int(dms["npc"], tonumber(_ED._scene_npc_id), environmentIndex)
            for j=1,6 do
                local environment_shipIndex = environment_formation.seat_one + j - 1
                local environment_shipId = dms.int(dms["environment_formation"], environmentId, environment_shipIndex)
                if environment_shipId ~= 0 then
                    local common_skill_mouldId = dms.int(dms["environment_ship"], environment_shipId, environment_ship.common_skill_mould)
                    local skill_mouldId = dms.int(dms["environment_ship"], environment_shipId, environment_ship.skill_mould)
                    local commonSkillElementData = dms.element(dms["skill_mould"], common_skill_mouldId)
                    local commonSkillInfluenceIds = zstring.split(dms.atos(commonSkillElementData, skill_mould.health_affect), ",")
                    local skillElementData = dms.element(dms["skill_mould"], skill_mouldId)
                    local skillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")
                    for k,v in pairs(commonSkillInfluenceIds) do
                        self:loadAttackSkillInfluenceEffect(v, skill_influence.posterior_lighting_effect_id)
                        self:loadAttackSkillInfluenceEffect(v, skill_influence.bear_lighting_effect_id)
                    end
                    for k1,v1 in pairs(skillInfluenceIds) do
                        self:loadAttackSkillInfluenceEffect(v1, skill_influence.posterior_lighting_effect_id)
                        self:loadAttackSkillInfluenceEffect(v1, skill_influence.bear_lighting_effect_id)
                    end
                end
            end
        end
        self._exportJsonIndex = 0
        self._exportJsonOver = false
        for i, v in pairs(self._exportJsons) do
            local function dataLoaded1(percent)
                if percent >= 1 then
                    if self._exportJsonOver == false then
                        self._exportJsonOver = true
                        self:startFight()
                    end
                end
            end
            if animationMode == 1 then
                local effectId = self._spineJsons[i]
                if effectId ~= nil then
                    local spine = sp.spine_effect(effectId, effectAnimations[1], false, nil, nil, nil)
                    spine.animationNameList = effectAnimations
                    spine:retain()
                    table.insert(self._spineEffects, spine)
                end
            else
                local fileName = v
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded1)
            end
        end
    else
        self._exportJsons = {}
        self._spineJsons = {}
        self._spineEffects = {}
        for i, v in pairs(_ED.attackData.roundData) do
            for j, h in pairs(v.roundAttacksData) do
                if h.cardMouldId == nil then
                    local attData = h
                    local skillMouldId          = tonumber(attData.skillMouldId)
                    local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
                    local skillInfluenceId = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")[1]
                    -- 启动技能中段
                    self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.posterior_lighting_effect_id)

                    self:loadAttackSkillInfluencesEffects(h.skillInfluences)
                    -- 合体技能
                    if h.fitHeros ~= nil then
                        for f, s in pairs(h.fitHeros) do
                            skillElementData = dms.element(dms["skill_mould"], tonumber(s.skillMouldId))
                            
                            local skillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.releas_skill), "|")
                            skillInfluenceIds = zstring.split(skillInfluenceIds[f], ",")
                            skillInfluenceId = zstring.tonumber(skillInfluenceIds[1])
                            -- 启动技能中段
                            self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.posterior_lighting_effect_id)

                            self:loadAttackSkillInfluencesEffects(s.skillInfluences)
                        end
        				
        				if attData.restrainState == "1" then
        					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_" .. #h.fitHeros .. "_1.ExportJson")
        				else
        					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_" .. #h.fitHeros .. ".ExportJson")
        				end
                    end
                    self:loadAttackSkillInfluencesEffects(h.skillAfterInfluences)
                end
            end
        end
        if __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
            or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_yugioh then
            local fileName = "effect/effice_62.ExportJson"
            self._exportJsons[fileName] = fileName
        end
        if __lua_project_id == __lua_project_yugioh then
            local fileName = "sprite/effect_magic.ExportJson"
            self._exportJsons[fileName] = fileName
        end
        --战宠技能
        for i=1,13 do
            local connect = ""
            if i >= 10 then 
                connect = ""
            else
                connect = "0"
            end
            local fileName1 = "sprite/hero_head_zc_7" .. connect .. i.."_1.ExportJson"
            local fileName2 = "sprite/hero_head_zc_7" .. connect .. i.."_0.ExportJson"
            if cc.FileUtils:getInstance():isFileExist(fileName1) == true then
                self._exportJsons[fileName1] = fileName1
            end
            if cc.FileUtils:getInstance():isFileExist(fileName2) == true then
                self._exportJsons[fileName2] = fileName2
            end
        end
        cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
        cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
        self._exportJsonIndex = 0
        self._exportJsonOver = false
        for i, v in pairs(self._exportJsons) do
            local function dataLoaded1(percent)
                --> print("光效加载完成-", percent)
                if percent >= 1 then
                    --> print("光效加载完成")
                    if self._exportJsonOver == false then
                        self._exportJsonOver = true
                        self:startFight()
                    end
                end
            end
            if animationMode == 1 then
                local effectId = self._spineJsons[i]
                if effectId ~= nil then
                    local spine = sp.spine_effect(effectId, effectAnimations[1], false, nil, nil, nil)
                    spine.animationNameList = effectAnimations
                    spine:retain()
                    table.insert(self._spineEffects, spine)
                end
            else
                local fileName = v
                --> print("加载光效：", fileName)
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded1) 
                -- cacher.addArmatureFileInfoAsync(fileName, dataLoaded1) 
            end
        end

        -- local _swapExportJsons = {}
        -- for i, v in pairs(self._exportJsons) do
        --     table.insert(_swapExportJsons, v)
        -- end
        -- if #_swapExportJsons > 0 then
        --     self._exportJsonIndex = 1
        --     self._exportJsons = _swapExportJsons

        --     local function dataLoaded1(percent)
        --         --> print("光效加载完成的进度：", percent)
        --         if percent >= 1 then
        --             self._exportJsonIndex = self._exportJsonIndex + 1
        --             local fileName = self._exportJsons[self._exportJsonIndex]
        --             if fileName ~= nil then
        --                 --> print("光效加载: ", fileName)
        --                 ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded1)
        --             else
        --                 --> print("光效加载完成")
        --                 self:startFight()
        --             end
        --         end
        --     end
        --     local fileName = self._exportJsons[self._exportJsonIndex]
        --     --> print("光效加载: ", fileName)
        --     ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded1)
        -- else
        --     self._exportJsonIndex = 0
        --     self._exportJsons = {}
        --     self:startFight()
        -- end
    end
end

function Fight:LoadAssetsInTigerGate( ... )
    if __lua_project_id ~= __lua_project_gragon_tiger_gate and __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_naruto  then
        return
    end
    self.zoarium_skill_list = {}
    self.zoarium_skills = {}
    local function checkIsHaveSkillCsb( csbName )
        for k,v in pairs(self.zoarium_skill_list) do
            if ""..v == ""..csbName then
                return true
            end
        end
        return false
    end

    local function decodeEnvironment( environmentId, isAttack )
        for j=1,6 do
            local prime_mover = 0
            local environment_shipIndex = environment_formation.seat_one + j - 1
            local environment_shipId = dms.int(dms["environment_formation"], environmentId, environment_shipIndex)
            if environment_shipId ~= 0 then
                local common_skill_mouldId = dms.int(dms["environment_ship"], environment_shipId, environment_ship.common_skill_mould)
                local skill_mouldId = dms.int(dms["environment_ship"], environment_shipId, environment_ship.skill_mould)
                local commonSkillElementData = dms.element(dms["skill_mould"], common_skill_mouldId)
                local commonSkillInfluenceIds = zstring.split(dms.atos(commonSkillElementData, skill_mould.health_affect), ",")
                local skillElementData = dms.element(dms["skill_mould"], skill_mouldId)

                local normal_skill_mouldId = tonumber(zstring.split(dms.string(dms["environment_ship"], environment_shipId, environment_ship.physics_attack_effect), ",")[1])
                local normalSkillElementData = dms.element(dms["skill_mould"], normal_skill_mouldId)
                local normalSkillInfluenceIds = zstring.split(dms.atos(normalSkillElementData, skill_mould.health_affect), ",")

                local skillInfluenceIds = {}
                if skillElementData ~= nil then
                    skillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")
                end
                -- 普通光效
                for k,v in pairs(commonSkillInfluenceIds) do
                    self:loadAttackSkillInfluenceEffect(v, skill_influence.forepart_lighting_effect_id)
                    self:loadAttackSkillInfluenceEffect(v, skill_influence.posterior_lighting_effect_id)
                    self:loadAttackSkillInfluenceEffect(v, skill_influence.bear_lighting_effect_id)
                end
                for k1,v1 in pairs(skillInfluenceIds) do
                    self:loadAttackSkillInfluenceEffect(v1, skill_influence.forepart_lighting_effect_id)
                    self:loadAttackSkillInfluenceEffect(v1, skill_influence.posterior_lighting_effect_id)
                    self:loadAttackSkillInfluenceEffect(v1, skill_influence.bear_lighting_effect_id)
                end
                for k1,v1 in pairs(normalSkillInfluenceIds) do
                    self:loadAttackSkillInfluenceEffect(v1, skill_influence.forepart_lighting_effect_id)
                    self:loadAttackSkillInfluenceEffect(v1, skill_influence.posterior_lighting_effect_id)
                    self:loadAttackSkillInfluenceEffect(v1, skill_influence.bear_lighting_effect_id)
                end

                -- 合体技
                local directing = dms.int(dms["environment_ship"], environment_shipId, environment_ship.directing)
                if tonumber(directing) ~= 0 and directing ~= "" and tonumber(directing) ~= -1 then
                    local ship_zoarium_skill = dms.int(dms["ship_mould"], directing, ship_mould.zoarium_skill)
                    -- 合体技光效
                    if tonumber(ship_zoarium_skill) ~= 0 and ship_zoarium_skill ~= "" and tonumber(ship_zoarium_skill) ~= -1 then
                        local skillElementData = dms.element(dms["skill_mould"], ship_zoarium_skill)
                        local totalSkillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.releas_skill), "|")
                        for p,y in pairs(totalSkillInfluenceIds) do
                            local skillInfluenceIds = zstring.split(totalSkillInfluenceIds[p], ",")
                            for q,m in pairs(skillInfluenceIds) do
                                self:loadAttackSkillInfluenceEffect(m, skill_influence.forepart_lighting_effect_id)
                                self:loadAttackSkillInfluenceEffect(m, skill_influence.posterior_lighting_effect_id)
                                self:loadAttackSkillInfluenceEffect(m, skill_influence.bear_lighting_effect_id)
                            end
                            self:loadAttackSkillInfluencesEffects(skillInfluenceIds)
                        end

                        -- 合体技csb
                        prime_mover = dms.int(dms["ship_mould"], directing, ship_mould.prime_mover)
                        if tonumber(prime_mover) ~= 0 and prime_mover ~= "" and tonumber(prime_mover) ~= -1 then
                            local hetiCsb = dms.int(dms["ship_mould"], directing, ship_mould.screen_attack_effect)
                            if checkIsHaveSkillCsb(hetiCsb) == false then
                                table.insert(self.zoarium_skill_list, hetiCsb)
                            end
                            local releaseIds = zstring.split(dms.atos(skillElementData, skill_mould.release_mould), ",")
                            local sameIdCount = 0
                            local shipIds = zstring.split(_ED._battle_eve_release_ship_id, ",")
                            for k,v in pairs(releaseIds) do
                                for k1,v1 in pairs(shipIds) do
                                    if v ~= "" and v1 ~= "" and tonumber(v) ~= nil and 
                                        tonumber(v1) ~= nil and tonumber(v1) > 0 and tonumber(v1) == tonumber(v) then
                                        sameIdCount = sameIdCount + 1
                                    end
                                end
                            end
                            if sameIdCount < #releaseIds then
                                prime_mover = 0
                            end
                        else
                            prime_mover = 0
                        end
                    else
                        prime_mover = 0
                    end
                else
                    prime_mover = 0
                end

                self:loadAttackSkillInfluencesEffects(commonSkillInfluenceIds)
                self:loadAttackSkillInfluencesEffects(skillInfluenceIds)
            else
                prime_mover = 0
            end
            if isAttack == true then
                table.insert(self.zoarium_skills, prime_mover)
            end
        end
    end

    if _ED._fightModule ~= nil then
        self._exportJsons = {}
        self._spineJsons = {}
        self._spineEffects = {}
        if self._npc_id ~= nil and self._npc_id ~= "" and tonumber(self._npc_id) ~= 0 then
            local formation_count = dms.int(dms["npc"], tonumber(self._npc_id), npc.formation_count)
            for i=1,tonumber(formation_count) do
                local environmentIndex = npc.environment_formation1 + i - 1
                local environmentId = dms.int(dms["npc"], tonumber(self._npc_id), environmentIndex)
                decodeEnvironment(environmentId, false)
            end
        end

        -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_2_1.ExportJson")
       if animationMode == 1 then

            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
                or __lua_project_id == __lua_project_l_naruto
                then
            else
                local spine = sp.spine_hetiSprite("hero_head_effect_2", effectAnimations[1], false, nil, nil, nil)
                spine.animationNameList = effectAnimations
                spine:retain()
                table.insert(self._spineEffects, spine)
                
                local animation = sp.spine("effect/effice_shifang.json", "effect/effice_shifang.atlas", 1, 0, "animation", true, nil)
                animation.animationNameList = effectAnimations
                animation:retain()
                table.insert(self._spineEffects, animation)
            end

            for i, v in pairs({
                _battle_controller._explode_effice_id,
                _battle_controller._dead_effice_id,
                _battle_controller._vertigo_effice_id,
                _battle_controller._invincible_effice_id,
                _battle_controller._burn_effice_id,
                _battle_controller._poisoning_effice_id
            }) do
                if v > 0 then
                    local jsonFile = string.format("effect/effice_%d.json", v)
                    local atlasFile = string.format("effect/effice_%d.atlas", v)
                    local spine = sp.spine_effect(v, effectAnimations[1], false, nil, nil, nil)
                    spine.animationNameList = effectAnimations
                    spine:retain()
                    table.insert(self._spineEffects, spine)
                end
            end
        else
            for i, v in pairs({
                _battle_controller._explode_effice_id,
                _battle_controller._dead_effice_id,
                _battle_controller._vertigo_effice_id,
                _battle_controller._invincible_effice_id,
                _battle_controller._burn_effice_id,
                _battle_controller._poisoning_effice_id
            }) do
                local fileName = string.format("effect/effice_%d.ExportJson", v)
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
            end
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_2.ExportJson")
        end

        if tonumber(_ED._battle_eve_environment_ship_id) ~= 0 then
            decodeEnvironment(_ED._battle_eve_environment_ship_id, true)
        else
            for i=2,7 do
                local ship = fundShipWidthId(_ED.formetion[i])
                local prime_mover = 0
                if ship ~= nil then
                    local ship_template_id = tonumber(ship.ship_template_id)
                    if tonumber(ship_template_id) > 0 then
                        local common_skill_mouldId = dms.int(dms["ship_mould"], ship_template_id, ship_mould.skill_mould)
                        local skill_mouldId = dms.int(dms["ship_mould"], ship_template_id, ship_mould.deadly_skill_mould)
                        local normal_skill_mouldId = nil
                        if nil ~= _ED.user_info.battleCache then
                            local fightObject = _ED.user_info.battleCache.attackerObjects[i - 1]
                            if nil ~= fightObject then
                                if nil ~= fightObject.commonSkill then
                                    common_skill_mouldId = fightObject.commonSkill.id
                                end
                                if nil ~= fightObject.specialSkill then
                                    skill_mouldId = fightObject.specialSkill.id
                                end
                                if nil ~= fightObject.normalSkillMould then
                                    normal_skill_mouldId = fightObject.normalSkillMould
                                end
                            end
                        end
                        
                        local commonSkillElementData = nil
                        if nil ~= common_skill_mouldId and common_skill_mouldId > 0 then
                            commonSkillElementData = dms.element(dms["skill_mould"], common_skill_mouldId)
                        end
                        local commonSkillInfluenceIds = nil
                        if nil ~= commonSkillElementData then
                            commonSkillInfluenceIds = zstring.split(dms.atos(commonSkillElementData, skill_mould.health_affect), ",")
                        end

                        local skillElementData = nil
                        if nil ~= skill_mouldId and skill_mouldId > 0 then
                            skillElementData = dms.element(dms["skill_mould"], skill_mouldId)
                        end
                        local skillInfluenceIds = nil
                        if nil ~= skillElementData then
                            skillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")
                        end

                        local normalSkillElementData = nil
                        if nil ~= normal_skill_mouldId and normal_skill_mouldId > 0 then
                            normalSkillElementData = dms.element(dms["skill_mould"], normal_skill_mouldId)
                        end
                        local normalSkillInfluenceIds = nil
                        if nil ~= normalSkillElementData then
                            normalSkillInfluenceIds = zstring.split(dms.atos(normalSkillElementData, skill_mould.health_affect), ",")
                        end

                        -- 普通光效
                        if nil ~= commonSkillInfluenceIds then
                            for k,v in pairs(commonSkillInfluenceIds) do
                                self:loadAttackSkillInfluenceEffect(v, skill_influence.forepart_lighting_effect_id)
                                self:loadAttackSkillInfluenceEffect(v, skill_influence.posterior_lighting_effect_id)
                                self:loadAttackSkillInfluenceEffect(v, skill_influence.bear_lighting_effect_id)
                            end
                        end
                        -- 怒气光效
                        if nil ~= skillInfluenceIds then
                            for k1,v1 in pairs(skillInfluenceIds) do
                                self:loadAttackSkillInfluenceEffect(v1, skill_influence.forepart_lighting_effect_id)
                                self:loadAttackSkillInfluenceEffect(v1, skill_influence.posterior_lighting_effect_id)
                                self:loadAttackSkillInfluenceEffect(v1, skill_influence.bear_lighting_effect_id)
                            end
                        end
                        -- 小技能光效
                        if nil ~= normalSkillInfluenceIds then
                            for k1,v1 in pairs(normalSkillInfluenceIds) do
                                self:loadAttackSkillInfluenceEffect(v1, skill_influence.forepart_lighting_effect_id)
                                self:loadAttackSkillInfluenceEffect(v1, skill_influence.posterior_lighting_effect_id)
                                self:loadAttackSkillInfluenceEffect(v1, skill_influence.bear_lighting_effect_id)
                            end
                        end

                        local zoarium_skill = dms.int(dms["ship_mould"], ship_template_id, ship_mould.zoarium_skill)
                        -- 合体技
                        if tonumber(zoarium_skill) ~= 0 and zoarium_skill ~= "" and tonumber(zoarium_skill) ~= -1 then
                            -- 合体技光效
                            local skillElementData = dms.element(dms["skill_mould"], zoarium_skill)
                            local totalSkillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.releas_skill), "|")
                            for k,v in pairs(totalSkillInfluenceIds) do
                                local skillInfluenceIds = zstring.split(totalSkillInfluenceIds[k], ",")
                                for q,m in pairs(skillInfluenceIds) do
                                    self:loadAttackSkillInfluenceEffect(m, skill_influence.forepart_lighting_effect_id)
                                    self:loadAttackSkillInfluenceEffect(m, skill_influence.posterior_lighting_effect_id)
                                    self:loadAttackSkillInfluenceEffect(m, skill_influence.bear_lighting_effect_id)
                                end
                                self:loadAttackSkillInfluencesEffects(skillInfluenceIds)
                            end

                            -- 合体技csb
                            prime_mover = dms.int(dms["ship_mould"], ship_template_id, ship_mould.prime_mover)
                            if tonumber(prime_mover) ~= 0 and prime_mover ~= "" and tonumber(prime_mover) ~= -1 then
                                local hetiCsb = dms.int(dms["ship_mould"], ship_template_id, ship_mould.screen_attack_effect)
                                if checkIsHaveSkillCsb(hetiCsb) == false then
                                    table.insert(self.zoarium_skill_list, hetiCsb)
                                end
                                local releaseIds = zstring.split(dms.atos(skillElementData, skill_mould.release_mould), ",")
                                local sameIdCount = 0
                                for k,v in pairs(releaseIds) do
                                    for m=2,7 do
                                        local ship = fundShipWidthId(_ED.formetion[m])
                                        if ship ~= nil and tonumber(ship.ship_template_id) > 0 then
                                            local baseShipId = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.base_mould)
                                            if tonumber(baseShipId) == tonumber(v) then
                                                sameIdCount = k
                                            end
                                        end
                                    end
                                end
                                if sameIdCount < #releaseIds then
                                    prime_mover = 0
                                end
                            else
                                prime_mover = 0
                            end
                        else
                            prime_mover = 0
                        end
                    else
                        prime_mover = 0
                    end
                    table.insert(self.zoarium_skills, prime_mover)
                else
                    prime_mover = 0
                    table.insert(self.zoarium_skills, prime_mover)
                end
            end
        end

        self._exportJsonIndex = 0
        self._exportJsonOver = false
        if animationMode == 1 then
            for k,v in pairs(self._spineJsons) do
                if v ~= nil then
                    local spine = sp.spine_effect(v, effectAnimations[1], false, nil, nil, nil)
                    spine.animationNameList = effectAnimations
                    spine:retain()
                    table.insert(self._spineEffects, spine)
                end
            end
        else
            for i, v in pairs(self._exportJsons) do
                local function dataLoaded1(percent)
                    if percent >= 1 then
                        if self._exportJsonOver == false then
                            self._exportJsonOver = true
                            -- self:startFight()
                        end
                    end
                end
                local fileName = v
                -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded1)
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
            end
        end
        self._exportJsonOver = true
    else
        self._exportJsons = {}
        self._spineJsons = {}
        self._spineEffects = {}
        for i, v in pairs(_ED.attackData.roundData) do
            for j, h in pairs(v.roundAttacksData) do
                local attData = h
                local skillMouldId          = tonumber(attData.skillMouldId)
                local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
                -- local skillInfluenceId = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")[1]
                -- 启动技能中段
                for _, skillInfluenceId in pairs(zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")) do
                    self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.forepart_lighting_effect_id)
                    self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.posterior_lighting_effect_id)
                    self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.bear_lighting_effect_id)
                end

                self:loadAttackSkillInfluencesEffects(h.skillInfluences)
                -- 合体技能
                if h.fitHeros ~= nil then
                    for f, s in pairs(h.fitHeros) do
                        skillElementData = dms.element(dms["skill_mould"], tonumber(s.skillMouldId))
                        
                        local skillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.releas_skill), "|")
                        skillInfluenceIds = zstring.split(skillInfluenceIds[f], ",")
                        -- skillInfluenceId = zstring.tonumber(skillInfluenceIds[1])
                        -- 启动技能中段
                        for _, skillInfluenceId in pairs(skillInfluenceIds) do
                            self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.forepart_lighting_effect_id)
                            self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.posterior_lighting_effect_id)
                            self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.bear_lighting_effect_id)
                        end

                        self:loadAttackSkillInfluencesEffects(s.skillInfluences)
                    end
                    
                    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_2_1.ExportJson")
                    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_2.ExportJson")
                end

                self:loadAttackSkillInfluencesEffects(h.skillAfterInfluences)
            end
        end

        if animationMode == 1 then

            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
                or __lua_project_id == __lua_project_l_naruto
                then
            else
                local spine = sp.spine_hetiSprite("hero_head_effect_2", effectAnimations[1], false, nil, nil, nil)
                spine.animationNameList = effectAnimations
                spine:retain()
                table.insert(self._spineEffects, spine)
                local animation = sp.spine("effect/effice_shifang.json", "effect/effice_shifang.atlas", 1, 0, "animation", true, nil)
                animation.animationNameList = effectAnimations
                animation:retain()
                table.insert(self._spineEffects, animation)
            end
            for i, v in pairs({
                _battle_controller._explode_effice_id,
                _battle_controller._dead_effice_id,
                _battle_controller._vertigo_effice_id,
                _battle_controller._invincible_effice_id,
                _battle_controller._burn_effice_id,
                _battle_controller._poisoning_effice_id
            }) do
                if v > 0 then
                    local jsonFile = string.format("effect/effice_%d.json", v)
                    local atlasFile = string.format("effect/effice_%d.atlas", v)
                    local spine = sp.spine_effect(v, effectAnimations[1], false, nil, nil, nil)
                    spine.animationNameList = effectAnimations
                    spine:retain()
                    table.insert(self._spineEffects, spine)
                end
            end
        else
            for i, v in pairs({
                _battle_controller._explode_effice_id,
                _battle_controller._dead_effice_id,
                _battle_controller._vertigo_effice_id,
                _battle_controller._invincible_effice_id,
                _battle_controller._burn_effice_id,
                _battle_controller._poisoning_effice_id
            }) do
                local fileName = string.format("effect/effice_%d.ExportJson", v)
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
            end
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect_2.ExportJson")
        end

        -- 合体技csb
        if _ED.battleData ~= nil then
            local function parseHetiData( list, isAttack )
                for i=1,6 do
                    local hero = list[""..i]
                    local prime_mover = 0
                    if hero ~= nil then
                        local ntype = hero._type
                        local mouldId = hero._mouldId
                        if tonumber(ntype) == 0 then
                            local zoarium_skill = dms.int(dms["ship_mould"], mouldId, ship_mould.zoarium_skill)
                            if tonumber(zoarium_skill) ~= 0 and zoarium_skill ~= "" and tonumber(zoarium_skill) ~= -1 then
                                prime_mover = dms.int(dms["ship_mould"], mouldId, ship_mould.prime_mover)
                                if tonumber(prime_mover) ~= 0 and prime_mover ~= "" and tonumber(prime_mover) ~= -1 then
                                    local hetiCsb = dms.int(dms["ship_mould"], mouldId, ship_mould.screen_attack_effect)
                                    if checkIsHaveSkillCsb(hetiCsb) == false then
                                        table.insert(self.zoarium_skill_list, hetiCsb)
                                    end
                                    local skillElementData = dms.element(dms["skill_mould"], zoarium_skill)
                                    local releaseIds = zstring.split(dms.atos(skillElementData, skill_mould.release_mould), ",")
                                    local sameIdCount = 0
                                    for k,v in pairs(releaseIds) do
                                        for m=2,7 do
                                            local ship = fundShipWidthId(_ED.formetion[m])
                                            if ship ~= nil and tonumber(ship.ship_template_id) > 0 then
                                                local baseShipId = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.base_mould)
                                                if tonumber(baseShipId) == tonumber(v) then
                                                    sameIdCount = k
                                                end
                                            end
                                        end
                                    end
                                    if sameIdCount < #releaseIds then
                                        prime_mover = 0
                                    end
                                else
                                    prime_mover = 0    
                                end
                            else
                                prime_mover = 0
                            end
                        elseif tonumber(ntype) == 1 then
                            local directing = dms.int(dms["environment_ship"], mouldId, environment_ship.directing)
                            if tonumber(directing) ~= 0 and directing ~= "" and tonumber(directing) ~= -1 then
                                local zoarium_skill = dms.int(dms["ship_mould"], directing, ship_mould.zoarium_skill)
                                if tonumber(zoarium_skill) ~= 0 and zoarium_skill ~= "" and tonumber(zoarium_skill) ~= -1 then
                                    prime_mover = dms.int(dms["ship_mould"], directing, ship_mould.prime_mover)
                                    if tonumber(prime_mover) ~= 0 and prime_mover ~= "" and tonumber(prime_mover) ~= -1 then
                                        local hetiCsb = dms.int(dms["ship_mould"], directing, ship_mould.screen_attack_effect)
                                        if checkIsHaveSkillCsb(hetiCsb) == false then
                                            table.insert(self.zoarium_skill_list, hetiCsb)
                                        end
                                        local skillElementData = dms.element(dms["skill_mould"], zoarium_skill)
                                        local releaseIds = zstring.split(dms.atos(skillElementData, skill_mould.release_mould), ",")
                                        local sameIdCount = 0
                                        for k,v in pairs(releaseIds) do
                                            for m=2,7 do
                                                local ship = fundShipWidthId(_ED.formetion[m])
                                                if ship ~= nil and tonumber(ship.ship_template_id) > 0 then
                                                    local baseShipId = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.base_mould)
                                                    if tonumber(baseShipId) == tonumber(v) then
                                                        sameIdCount = k
                                                    end
                                                end
                                            end
                                        end
                                        if sameIdCount < #releaseIds then
                                            prime_mover = 0
                                        end
                                    else
                                        prime_mover = 0
                                    end
                                else
                                    prime_mover = 0
                                end
                            end
                        end
                    end
                    if isAttack == true then
                        table.insert(self.zoarium_skills, prime_mover)
                    end
                end
            end
            parseHetiData(_ED.battleData._heros, true)
            for i = 1, _ED.battleData.battle_total_count do
                local armyRound = _ED.battleData._armys[i]
                if armyRound ~= nil and armyRound._data ~= nil then
                    parseHetiData(armyRound._data, false)
                end
            end
        end

        self._exportJsonIndex = 0
        self._exportJsonOver = false
        if animationMode == 1 then
            for k,v in pairs(self._spineJsons) do
                if v ~= nil then
                    local spine = sp.spine_effect(v, effectAnimations[1], false, nil, nil, nil)
                    spine.animationNameList = effectAnimations
                    spine:retain()
                    table.insert(self._spineEffects, spine)
                end
            end
        else
            for i, v in pairs(self._exportJsons) do
                local function dataLoaded1(percent)
                    --> print("光效加载完成-", percent)
                    if percent >= 1 then
                        --> print("光效加载完成")
                        if self._exportJsonOver == false then
                            self._exportJsonOver = true
                            -- self:startFight()
                        end
                    end
                end
                local fileName = v
                --> print("加载光效：", fileName)
                -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded1) 
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName) 
                -- cacher.addArmatureFileInfoAsync(fileName, dataLoaded1)
            end
        end
        self._exportJsonOver = true
    end
end

function Fight:getFightZoariumSkills()
    return self.zoarium_skill_list
end

function Fight:getFightZoariumSkillMovers( ... )
    return self.zoarium_skills
end

function Fight:drawFightUI()
    if self._currentFightIndex == 1 then
        --> print("绘制战斗主UI")
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            or __lua_project_id == __lua_project_red_alert 
            then
        else
            fwin:open(FightUI:new():init(self._canSkipFighting), fwin._view)
        end
        
        if __lua_project_id == __lua_project_warship_girl_b 
            or __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
            or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_yugioh 
            or __lua_project_id == __lua_project_koone then
            attack_logic.__hero_ui_visible = false
            attack_logic.__hero_ui_lock = false
            -- state_machine.excute("fight_hero_info_ui_show", 0, {_datas = {_type = 1}})
        end
    else
        --> print("更新战斗主UI")
        state_machine.excute("fight_ui_visible", 0, true)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            if _ED._fightModule ~= nil then
                state_machine.excute("fight_ui_update_battle_round_count", 0, "0/".._ED._fightModule.totalRound)
            else
                state_machine.excute("fight_ui_update_battle_round_count", 0, "0/".._ED.attackData.totalRoundCount)
            end
        else
            state_machine.excute("fight_ui_update_battle_round_count", 0, "0/20")
        end
        
        if __lua_project_id == __lua_project_warship_girl_b
            or __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
            or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_yugioh 
            or __lua_project_id == __lua_project_koone 
            then
            attack_logic.__hero_ui_lock = false
            state_machine.excute("fight_hero_info_ui_show", 0, {_datas = {_type = 0, _visible = attack_logic.__hero_ui_visible}})
        end
    end
    -- version 1.0
    -- state_machine.excute("fight_request_battle", 0, self._currentFightIndex)

    -- 绘制日常副本的战斗结算UI信息
    if self._fight_type == _enum_fight_type._fight_type_101 then
        fwin:close(fwin:find("FightUIForDailyActivityCopyClass"))
        fwin:open(FightUIForDailyActivityCopy:new():init(self._fight_type), fwin._view)
        
    elseif self._fight_type == _enum_fight_type._fight_type_54 then
        fwin:close(fwin:find("TrialTowerBattleDescribeClass"))
         
        local view = TrialTowerBattleDescribe:new()
        view:init()
        fwin:open(view, fwin._view)
    elseif self._fight_type == _enum_fight_type._fight_type_102 then
        fwin:close(fwin:find("TrialTowerBattleDescribeClass"))
         
        local view = TrialTowerBattleDescribe:new()
        view:init()
        fwin:open(view, fwin._view)
    elseif self._fight_type == _enum_fight_type._fight_type_104 then
        -- 覆盖战功提醒
        fwin:close(fwin:find("WorldbossBattleDescribeClass"))
         
        local view = WorldbossBattleDescribe:new()
        view:init()
        fwin:open(view, fwin._view)
        
        
        -- 覆盖突破提升
        fwin:close(fwin:find("WorldbossBattleTipTitleClass"))
        local view = WorldbossBattleTipTitle:createCell()
        view:init()
        fwin:open(view, fwin._view)
    elseif self._fight_type == _enum_fight_type._fight_type_110 then 
         -- 覆盖战功提醒
        fwin:close(fwin:find("WorldbossBattleDescribeClass"))
         
        local view = WorldbossBattleDescribe:new()
        view:init()
        fwin:open(view, fwin._view)
    end
end

function Fight:drawFightFormationUI()
    --> print("绘制战斗阵型UI")
    state_machine.excute("battle_formation_show_ui", 0, nil)
end

function Fight:playAnimationByHeroIntoFight()
    state_machine.excute("fight_map_hero_into", 0, self._heroCount)
end

function Fight:initEffect()
    -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    --     return
    -- end
    -- local function dataLoaded(percent)
    --     -- local label = self:getChildByTag(10001)
    --     -- if nil ~= label then
    --     --     local subInfo = ArmatureTestLayer.subTitle(1) .. (percent * 100)
    --     --     label:setString(subInfo)
    --     -- end
    --     -- if percent >= 1 and nil ~= self._backItem and nil ~= self._restarItem and nil ~= self._nextItem then
    --     --     self._backItem:setEnabled(true)
    --     --     self._restarItem:setEnabled(true)
    --     --     self._nextItem:setEnabled(true)
    --     -- end

    --     if percent >= 1 and self._inited == false then
    --         -- self:initMap()
    --         self:initHeros()

    --         if missionIsOver() == false and checkEventType(execute_type_role_restart, 1) == true then
    --             executeNextEvent(nil, true)
    --         end

    --         -- fwin:open(self.battleFormationController, fwin._view)
    --         -- self.battleFormationController:release()

    --         -- fwin:open(self._fightMapLayer, fwin._background)
    --         -- self._fightMapLayer:release()

    --         if self._init_status == 3 then
    --             state_machine.excute("fight_hero_into", 0, 0)
    --         else
    --             self._init_status = 1
    --         end
    --     end
    -- end

    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/spirte_battle_card.ExportJson", dataLoaded)
    -- if self._npc_type == "0" then
        
    -- elseif self._npc_type == "1" then
        
    --     -- if self._boss_battle_card_num ~= nil then
    --     --  local pathName = string.format(self._boss_battle_card_string,self._boss_battle_card_num)
    --     --  ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(pathName, dataLoaded)
    --     -- end

    -- end
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_head_effect.ExportJson", dataLoaded)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_head_effect_2.ExportJson", dataLoaded)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_head_effect_2_1.ExportJson", dataLoaded)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_head_effect_4.ExportJson", dataLoaded)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_broken_effect.ExportJson", dataLoaded)
end

function  Fight:initMap()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        return
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        app.load("client.battle.landscape.FightScene")
        local isPveType = false
        if self._fight_type ~= _enum_fight_type._fight_type_10 and
            self._fight_type ~= _enum_fight_type._fight_type_11 and 
            self._fight_type ~= _enum_fight_type._fight_type_14 and 
            -- self._fight_type ~= _enum_fight_type._fight_type_53 and 
            self._fight_type ~= _enum_fight_type._fight_type_102 and 
            self._fight_type ~= _enum_fight_type._fight_type_104 
            and self._fight_type ~= _enum_fight_type._fight_type_211 
            and self._fight_type ~= _enum_fight_type._fight_type_213 
            and self._fight_type ~= _enum_fight_type._fight_type_214
            and self._fight_type ~= _enum_fight_type._fight_type_218
            and self._fight_type ~= _enum_fight_type._fight_type_219
            and self._fight_type ~= _enum_fight_type._fight_type_220
            then
            isPveType = true
        end
        if _ED._battle_eve_auto_fight == true then
            isPveType = false
        end
        fwin:open(FightScene:new():init(self._map_index, self._npc_type, isPveType), fwin._background)
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            state_machine.excute("fight_scene_add_shake_ui", 0, self._canSkipFighting)
        end
    else
        local fightMapLayer = FightMap:new()
        fightMapLayer:init(self._map_background_image_index, self._npc_type)
        -- fwin:open(fightMapLayer, fwin._background)
        self._fightMapLayer = fightMapLayer
        self._fightMapLayer:retain()

        -- self._fightMapLayer = state_machine.excute("fight_map_create_map", 0, {self._map_background_image_index, self._npc_type})
        -- self._fightMapLayer:retain()
    end
end

function Fight:initTigerGateMap( ... )
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        app.load("client.battle.landscape.FightScene")
        local isPveType = false
        if self._fight_type ~= _enum_fight_type._fight_type_8 and
            self._fight_type ~= _enum_fight_type._fight_type_10 and
            self._fight_type ~= _enum_fight_type._fight_type_11 and 
            self._fight_type ~= _enum_fight_type._fight_type_13 and 
            self._fight_type ~= _enum_fight_type._fight_type_14 and 
            -- self._fight_type ~= _enum_fight_type._fight_type_53 and 
            self._fight_type ~= _enum_fight_type._fight_type_102 and 
            self._fight_type ~= _enum_fight_type._fight_type_104 and 
            self._fight_type ~= _enum_fight_type._fight_type_106 and 
            self._fight_type ~= _enum_fight_type._fight_type_107
            and self._fight_type ~= _enum_fight_type._fight_type_211 
            and self._fight_type ~= _enum_fight_type._fight_type_213 
            and self._fight_type ~= _enum_fight_type._fight_type_214
            and self._fight_type ~= _enum_fight_type._fight_type_219
            and self._fight_type ~= _enum_fight_type._fight_type_220
            and self._fight_type ~= _enum_fight_type._fight_type_218  -- 将世界boss改为服务器计算
            then
            isPveType = true
        end
        if _ED._battle_eve_auto_fight == true then
            isPveType = false
        end
        self.fightScene = FightScene:new()
        self.fightScene:init(self._map_index, self._npc_type, isPveType)
        self.fightScene:retain()

        self.isPveType = isPveType
    end
end

function Fight:loadTigerGateFight( index )
    if index == 1 then
        self.fightScene:loadFightTeamController()
    elseif index == 2 then
        self.fightScene:loadFightQTEController()
    elseif index == 3 then
        self.fightScene:loadFightRoleController()
    end
end

function Fight:addTigerGateMap( ... )
    fwin:open(self.fightScene, fwin._background)
end

function Fight:addTigerGateController( ... )
    self.fightScene:addTigerGateFight()
end

function Fight:addTigerGateFightUI( ... )
    self.fightScene:release()
    state_machine.excute("fight_scene_add_shake_ui", 0, self._canSkipFighting)


    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        state_machine.excute("fight_ui_update_battle_count", 0, "" .. self._currentFightIndex .. "/" .. self._totalFightCount)

        local byAttackerName = nil
        local headPic = nil
        local signType = 0
        local defnederSpeedValue = 0
        if true == self.isPveType then
            if nil ~= _ED.user_info.battleCache.byAttackerObjectsList then
                for i, v in pairs(_ED.user_info.battleCache.byAttackerObjectsList[self._currentFightIndex]) do
                    byAttackerName = v.name
                    headPic = v.picIndex
                    defnederSpeedValue = v.attackSpeed
                    if (tonumber(v.signType) or 0) > 0 then
                        signType = v.signType
                        break
                    end
                end
            end
            if _ED.nr_arena_fight_rank then
                -- NinjaAscension arena: the opponent player, not one of the ninjas.
                byAttackerName = _ED.nr_arena_defender_name or byAttackerName
                defnederSpeedValue = _ED.nr_arena_defender_speed or defnederSpeedValue
            end
            state_machine.excute("fight_ui_update_battle_player_info", 0, {_ED.user_info.user_name, byAttackerName, headPic, signType, _ED.user_info.battleCache.attackerSpeedValue, defnederSpeedValue,_ED._scene_npc_id,self._currentFightIndex})
            if _ED.nr_arena_fight_rank then
                -- Arena fights are automatic only, as in the original.
                state_machine.excute("fight_ui_begin_auto_fight", 0, {_datas = {terminal_name = "fight_ui_begin_auto_fight", terminal_state = 1}})
            end
        else
            state_machine.excute("fight_ui_update_battle_player_info", 0, {_ED._attack_people_name , _ED._defense_people_name, headPic, signType, 0, 0})
        end
    end
end

function Fight:initHeros()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_legendary_game then
        return
    end
    local root = self.roots[1]

    -- local node_names = {
    --     "Panel_0_1",
    --     "Panel_0_2",
    --     "Panel_0_3",
    --     "Panel_0_4",
    --     "Panel_0_5",
    --     "Panel_0_6",
    -- }

    -- local flying_node_names = {
    --     "Panel__hero_1",
    --     "Panel__hero_2",
    --     "Panel__hero_3",
    --     "Panel__hero_4",
    --     "Panel__hero_5",
    --     "Panel__hero_6",
    -- }
    -- state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
    for i = 1, 6 do
        local v = _ED.battleData._heros["" .. i]
        local hero = nil
        if v ~= nil then
            -- 此处重置mid之后,会导致取船只的数据出错 (06/18)
            v._original_mouldId = v._mouldId -- 保存一个原始未重置的mid,用于后面取船只(因为下面被重置了mid)
            if v._type == "1" then
                local shipMouldId = dms.int(dms["environment_ship"], v._mouldId, environment_ship.directing)
                if shipMouldId > 0 then
                    -- 此处重置,对1-5的eve合体技有影响,屏蔽该重置就导致合体技错误
                    v._mouldId = shipMouldId
                end
            end
            self._heroCount = self._heroCount + 1
            if __lua_project_id == __lua_project_digimon_adventure  
                or __lua_project_id == __lua_project_naruto 
                or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge 
                or __lua_project_id == __lua_project_yugioh  
                then 
                hero = Hero:new():init(v, self._fightMapLayer, 
                string.format("Panel_0_%d", tonumber(""..v._pos)), 
                string.format("Panel__hero_%s_2",v._pos),
                string.format("Panel__hero_%s_2", v._pos),
                self._fight_type)
            elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                hero = Hero:new():init(v, self._fightMapLayer, 
                string.format("Node_postion_%d", tonumber(""..v._pos)), 
                nil,
                string.format("Node_postion_%d", tonumber(""..v._pos)),
                self._fight_type)
            else
                hero = Hero:new():init(v, self._fightMapLayer, 
                string.format("Panel_0_%d", tonumber(""..v._pos)), 
                string.format("Panel__hero_%d", self._heroCount),
                string.format("Panel__hero_%s_2", v._pos),
                self._fight_type)
            end
            table.insert(self._heros, hero)
            state_machine.excute("battle_formation_create_role_head", 0, {_roleType = 2, _id = v._id, _mouldId = v._mouldId, _original_mouldId = v._original_mouldId, _pos = v._pos, _head = v._head, _roleName = "", _v = v})
        else
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                hero = Hero:new():init({_pos = i}, self._fightMapLayer, 
                    string.format("Node_postion_%d", tonumber(""..i)), 
                    nil, 0,self._fight_type)
            else
                hero = Hero:new():init({_pos = i}, self._fightMapLayer, 
                    string.format("Panel_0_%d", tonumber(""..i)), 
                    nil, 0,self._fight_type)
            end
        end
        table.insert(self._hero_formation, hero._fightParent)
        if __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
            or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_yugioh 
            then
            --主动隐藏 特殊处理,剧情战斗
            if zstring.tonumber(self._npc_id) == 1722 then 
                self:showRole("0","0,0,0,0,0,0", true)
            end
        end
    end
    if __lua_project_id == __lua_project_yugioh then
        local hero = Hero:new():init({_pos = 101, _head = 0}, self._fightMapLayer, 
            "Panel_0_101", nil, 0, self._fight_type)
        table.insert(self._hero_formation, hero._fightParent)
    else
        table.insert(self._hero_formation, "")
    end
    local cwPanle = ccui.Helper:seekWidgetByName(self._fightMapLayer:rootAtIndex(1), "Panel_0_102")
    if cwPanle ~= nil then 
        if _ED.formation_pet_id ~= nil and _ED.formation_pet_id ~= 0 then
            --有战宠
            local hero_pet = _ED.battleData._heros["102"]
            local hero = Hero:new():init({_pos = 102, _head = 0,_mouldId = hero_pet._mouldId ,train_level = hero_pet.train_level}, self._fightMapLayer, 
                "Panel_0_102", nil, 0, self._fight_type)
            table.insert(self._hero_formation, hero._fightParent)
            self._petHero = hero
        end
    end
    -- for i, v in pairs(_ED.battleData._heros) do
    --     local hero = Hero:new():init(v, self._fightMapLayer, 
    --         string.format("Panel_0_%d", tonumber(""..v._pos)), 
    --         string.format("Panel__hero_%d", table.getn(self._heros) + 1))
    --     table.insert(self._heros, hero)
    --     state_machine.excute("battle_formation_create_role_head", 0, {_roleType = 2, _id = v._id, _mouldId = v._mouldId, _pos = v._pos, _head = v._head, _roleName = "", _v = v})
    
    -- end

    -- self._heroCount = table.getn(self._heros)

    state_machine.excute("battle_formation_create_role_head_over", 0, {_num = num})

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        -- fightWindow:initMasters()
        state_machine.excute("fight_master_into_start", 0, 0)
    end
end

function Fight:initMasters()
    if self._boss_battle_card_num ~= nil then
        local pathName = string.format(self._boss_battle_card_string,self._boss_battle_card_num)
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(pathName)
    end
    --> print("initMasters", self._currentFightIndex, _ED.battleData._currentBattleIndex)
    state_machine.excute("battle_formation_update_ui", 0, {_num = 1})
    local root = self.roots[1]
    self._masters = {}
    self._master_formation = {}
    for i = 1, 6 do
        local v = _ED.battleData._armys[_ED.battleData._currentBattleIndex]._data["" .. i]
        local master = nil
        if v ~= nil then
            self._masterCount = self._masterCount + 1

            if self._npc_type == "0" then
                local sign_type = dms.int(dms["environment_ship"], v._mouldId, environment_ship.sign_type)
                if sign_type == 1 then
                    self._boss_battle_card_num = dms.int(dms["environment_ship"], v._mouldId, environment_ship.sign_pic)
                    v._master_type = "1"
                    self._npc_type = "1"
                    local pathName = string.format(self._boss_battle_card_string,self._boss_battle_card_num)
                    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pathName)
                else
                    v._master_type = "0"
                end
            else
                v._master_type = self._npc_type
            end

            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                master = Master:new():init(v, self._fightMapLayer, 
                    string.format("Node_postion_enemy_%d", tonumber(""..v._pos)),self._boss_battle_card_num, self._fight_type)
            else
                master = Master:new():init(v, self._fightMapLayer, 
                    string.format("Panel_%d_%d", self._currentFightIndex, tonumber(""..v._pos)),self._boss_battle_card_num,self._fight_type)
            end
            table.insert(self._masters, master)
            state_machine.excute("battle_formation_create_role_head", 0, {_roleType = 1, _id = v._id, _mouldId = v._mouldId, _pos = v._pos, _head = v._head, _roleName = "", _v = v})
        else
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                master = Master:new():init({_pos = i}, self._fightMapLayer, 
                    string.format("Node_postion_enemy_%d", i, tonumber(""..i)),self._boss_battle_card_num, self._fight_type)
            else
                master = Master:new():init({_pos = i}, self._fightMapLayer, 
                    string.format("Panel_%d_%d", self._currentFightIndex, tonumber(""..i)),self._boss_battle_card_num, self._fight_type)
            end
        end
        table.insert(self._master_formation, master._fightParent)
        if  __lua_project_id == __lua_project_yugioh
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge
            then
            --主动隐藏 特殊处理,剧情战斗
            if zstring.tonumber(self._npc_id) == 1722 then 
                self:showRole("1","0,0,0,0,0,0", true)
            end
        end
    end
    table.insert(self._master_formation, "")
    local cwPanle = ccui.Helper:seekWidgetByName(self._fightMapLayer:rootAtIndex(1), "Panel_1_102")
    local master_pet = _ED.battleData._armys[_ED.battleData._currentBattleIndex]._data["102"]
    if cwPanle ~= nil and master_pet ~= nil then 
        self.isMasterPet = true
        self.master_mould_id = master_pet._mouldId
        local master = Master:new():init({_pos = 102, _head = 0,_mouldId = master_pet._mouldId,_train_level = master_pet.train_level}, self._fightMapLayer, 
            "Panel_1_102", nil, 0, self._fight_type)
        table.insert(self._master_formation, master._fightParent)
    end
    -- for i, v in pairs(_ED.battleData._armys[_ED.battleData._currentBattleIndex]._data) do
    --     local master = Master:new():init(v, self._fightMapLayer, 
    --         string.format("Panel_%d_%d", self._currentFightIndex, tonumber(""..v._pos)))
    --     table.insert(self._masters, master)
    --     state_machine.excute("battle_formation_create_role_head", 0, {_roleType = 1, _id = v._id, _mouldId = v._mouldId, _pos = v._pos, _head = v._head, _roleName = "", _v = v})
    
    -- end

    -- self._masterCount = table.getn(self._masters)

    if __lua_project_id == __lua_project_pacific_rim then
        state_machine.excute("fight_map_join_battle_shake_action", 0, 0)
    end
end

function Fight:skeepFighting()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_legendary_game 
        then
        -- --> print("龙虎门的战斗跳过功能需要实现")
        state_machine.excute("fight_role_controller_skeep_fight", 0, 0)

        if self._fight_type == _enum_fight_type._fight_type_214 then
            self:fightEnd()
        end
        if self._fight_type == _enum_fight_type._fight_type_219 then
            self:fightEnd()
        end

        if self._fight_type == _enum_fight_type._fight_type_220 then
            self:fightEnd()
        end

    else
        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            battle_execute._playEffectMusic = nil
            self._fight_is_end = true
            self:fightEnd()
        else
            --> print("跳过当前场次的战斗，准备进入下一场战斗。")
            -- state_machine.excute("fight_check_next_fight", 0, 0)
            state_machine.excute("attack_logic_skeep_fight", 0, {self._hero_formation, self._master_formation})
            
            -- if self._currentFightIndex == self._totalFightCount then
            --     self:fightOver()
            -- else
            --> print("跳过当前场次的战斗，准备进入下一场战斗。")
            --     -- state_machine.excute("fight_check_next_fight", 0, 0)
            --     state_machine.excute("attack_logic_skeep_fight", 0, {self._hero_formation, self._master_formation})
            -- end
        end
    end
end

function Fight:gameDataRecord()
    if (__lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true
        then
        if _ED.battleData ~= nil then
            if zstring.tonumber(_ED.battleData.objId) <= 0 then
                return
            end
            if _ED.battleData.battle_init_type == 0 or _ED.battleData.battle_init_type == 101
                or _ED.battleData.battle_init_type == 9 or _ED.battleData.battle_init_type == 105
                or _ED.battleData.battle_init_type == 102 or _ED.battleData.battle_init_type == 104
              then
                local npcData = dms.element(dms["npc"], _ED.battleData.objId)
                if npcData ~= nil then
                    if _ED.attackData.isWin == "1" then
                        jttd.replicaScheduleCompleted(dms.atos(npcData,npc.npc_name))
                    elseif _ED.attackData.isWin == "0" then
                        jttd.replicaScheduleFailed(dms.atos(npcData,npc.npc_name))
                    end
                end
            elseif _ED.battleData.battle_init_type == 103 then
                local data = dms.searchs(dms["manor_mould"], manor_mould.npc_id, _ED.battleData.objId)
                if data ~= nil and #data > 0 and data[1] ~= nil then
                    if _ED.attackData.isWin == "1" then
                        jttd.replicaScheduleCompleted(dms.atos(data[1],manor_mould.manor_name))
                    elseif _ED.attackData.isWin == "0" then
                        jttd.replicaScheduleFailed(dms.atos(data[1],manor_mould.manor_name))
                    end
                end
            end


            if _ED.battleData.battle_init_type == 102 then
                local npcData = dms.element(dms["npc"], _ED.battleData.objId)
                if npcData ~= nil then
                    local nextNpcId =  tonumber(zstring.split(dms.atos(npcData,npc.unlock_npc),",")[1])
                    -- local guanKaId = dms.atoi(npcData,npc.get_star_condition)
                    if _ED.attackData.isWin == "1" and nextNpcId ~= -1 then
                        jttd.replicaScheduleBegin(dms.string(dms["npc"], nextNpcId, npc.npc_name))
                    end
                end
            elseif _ED.battleData.battle_init_type == 103 then
                -- manor_mould.txt
                if _ED.attackData.isWin == "1" then
                    local data = dms.searchs(dms["manor_mould"], manor_mould.npc_id, _ED.battleData.objId)
                    if data ~= nil and #data > 0 and data[1] ~= nil then
                        local openId = dms.atoi(data[1],manor_mould.by_open_manor)
                        if _ED.manor_info ~= nil and _ED.manor_info ~= "" and _ED.manor_info.player ~= nil then
                            for i,v in ipairs(_ED.manor_info.player.city) do
                                if v ~= nil then
                                    if openId == tonumber(v.manor_index_id) then
                                        if v.manor_status > 1 then
                                            return
                                        end
                                        break
                                    end
                                end
                            end
                        end
                        if openId ~= -1 then
                            local openData = dms.element(dms["manor_mould"],openId)
                            if openData ~= nil then
                                 jttd.replicaScheduleBegin(dms.atos(openData, manor_mould.manor_name))
                            end
                        end
                    end
                end
            end
        end
    end
end


function Fight:showNomralLose()
    app.load("client.battle.BattleLose")
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        then
        local function delayEndFuncN( _sender )
            if _sender ~= nil then
                if fwin:find("BattleLoseClass") == nil then
                    local battleLose = BattleLose:new() 
                    battleLose:init(self._fight_type)
                    fwin:open(battleLose, fwin._window)
                end
            end
        end
        local actions = {}
        table.insert(actions, cc.DelayTime:create(1))
        table.insert(actions, cc.CallFunc:create(delayEndFuncN))
        local seq = cc.Sequence:create(actions)
        self:runAction(seq)
    else
        local battleLose = BattleLose:new() 
        battleLose:init(self._fight_type)
        fwin:open(battleLose, fwin._window)
    end
end

function Fight:fightEnd( ... )
    if _ED.nr_arena_fight_active then
        -- NinjaAscension arena (fought as type 0): show the original arena result screens.
        _ED.nr_arena_fight_active = nil
        self._fight_type = _enum_fight_type._fight_type_11
    end

    self._fight_is_end = true
    
    cc.Director:getInstance():getScheduler():setTimeScale(1)

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        if self._fight_is_end == nil then
            self._fight_is_end = true

            if self._fight_type == _enum_fight_type._fight_type_204 --敌军来袭
                or self._fight_type == _enum_fight_type._fight_type_208 --阵营战
                then  
                fwin:addService({
                    callback = function ( params )
                        if nil ~= params.fightEnd then
                            params:fightEnd()
                        end
                    end,
                    params = self,
                    delay = 0.01
                })
            else
                local tagets = nil
                local flag = 1
                if tonumber(_ED.attackData.isWin) == 1 then
                    tagets = self._hero_formation
                else
                    tagets = self._master_formation
                    flag = -1
                end

                if __lua_project_id == __lua_project_pacific_rim then
                    state_machine.excute("fight_map_out_battle_shake_action", 0, 50)
                end

                local h = ((fwin._height - app.baseOffsetY) * 4 / 5) + 300

                for i, v in pairs(tagets) do
                    if v~= nil and v.getParent ~= nil then
                        if v._armature ~= nil 
                            and nil ~= v._armature._posTile 
                            and true == v._armature._posTile:isVisible() 
                            then
                            v._armature._over = true
                            if __lua_project_id == __lua_project_pacific_rim then
                                -- battle_execute._changeToAction(v._armature, animation_moving)
                                v._armature._nextAction = animation_moving
                                v._armature:getAnimation():playWithIndex(animation_moving)
                            else
                                v._armature._nextAction = animation_moving
                            end
                            if nil ~= v._armature._child_list then
                                for m, n in pairs(v._armature._child_list) do
                                    n._over = true
                                    if __lua_project_id == __lua_project_pacific_rim then
                                        -- battle_execute._changeToAction(n, animation_moving)
                                        n._weapon._nextAction = animation_moving
                                        n._weapon:getAnimation():playWithIndex(animation_moving)
                                    else
                                        n._nextAction = animation_moving
                                    end
                                end
                            end
                            if __lua_project_id == __lua_project_pacific_rim then
                                if nil ~= v._armature._weapon then
                                    v._armature._weapon._nextAction = animation_moving
                                    v._armature._weapon:getAnimation():playWithIndex(animation_moving)
                                    v._armature._weapon._over = true
                                end
                            end

                            v:stopAllActions()
                            v._armature._node._add_track = true
                            if __lua_project_id == __lua_project_pacific_rim then
                                if flag == 1 then
                                    v:runAction(cc.Sequence:create(cc.MoveBy:create(1.5 * h / 150 * 5, cc.p(3800 * flag, 3800 * flag)), cc.CallFunc:create(function ( sender )
                                        sender._armature._node._add_track = false
                                    end)))
                                else
                                    v:runAction(cc.Sequence:create(cc.MoveBy:create(1.5 * h / 150 * 5, cc.p(3800 * flag, 3800 * flag)), cc.CallFunc:create(function ( sender )
                                        sender._armature._node._add_track = false
                                    end)))
                                end
                            else
                                if flag == 1 then
                                    v:runAction(cc.Sequence:create(cc.MoveBy:create(1.5 * h / 150, cc.p(0, h * flag)), cc.CallFunc:create(function ( sender )
                                        sender._armature._node._add_track = false
                                    end)))
                                else
                                    v:runAction(cc.Sequence:create(cc.MoveBy:create(1.5 * h / 150, cc.p(0, h * flag)), cc.CallFunc:create(function ( sender )
                                        sender._armature._node._add_track = false
                                    end)))
                                end
                            end
                        end
                    end
                end

                if _ED._is_playback == true then
                    _ED._is_playback = false
                    fwin:addService({
                        callback = function ( params )
                            params._is_playback = true
                            -- fwin:close(fwin:find("BattleSceneClass"))
                            state_machine.excute("window_lock_swallow_touches", 0, false)
                            fwin:close(fwin:find("FightUIClass"))
                            fwin:close(fwin:find("FightMapClass"))
                            fwin:close(fwin:find("FightClass"))
                        end,
                        params = self
                    })
                    return
                else
                    fwin:addService({
                        callback = function ( params )
                            if nil ~= params.fightEnd then
                                params:fightEnd()
                            end
                        end,
                        params = self,
                        delay = 1.0
                    })
                end
            end
            return
        end
		if _ED._is_playback == true then
			_ED._is_playback = false
			fwin:addService({
				callback = function ( params )
                    params._is_playback = true
					-- fwin:close(fwin:find("BattleSceneClass"))
                    state_machine.excute("window_lock_swallow_touches", 0, false)
					fwin:close(fwin:find("FightUIClass"))
					fwin:close(fwin:find("FightMapClass"))
					fwin:close(fwin:find("FightClass"))
                    state_machine.excute("enemy_strike_fight_update_hp_info", 0, {true})
				end,
				params = self
			})
			return
		end
	end

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        if true == self._is_call_fight_end then
            return
        end
        self._is_call_fight_end = true
        if self._fight_type == _enum_fight_type._fight_type_203 --叛军战斗
            or self._fight_type == _enum_fight_type._fight_type_204  --敌军来袭
            or self._fight_type == _enum_fight_type._fight_type_208  --阵营战
            then 
            fwin:addService({
                callback = function ( params )
                    -- fwin:close(fwin:find("BattleSceneClass"))
                    state_machine.excute("window_lock_swallow_touches", 0, false)
                    fwin:close(fwin:find("FightUIClass"))
                    fwin:close(fwin:find("FightMapClass"))
                    fwin:close(fwin:find("FightClass"))
                    state_machine.excute("enemy_strike_fight_update_hp_info", 0, {true})
                end,
                params = self
            })
            return
        end
    end

    cacher.remvoeUnusedArmatureFileInfoes()
    state_machine.excute("window_lock_swallow_touches", 0, false)
    -- print("战斗结束--------------------------------------------------")
    if self._fight_type == _enum_fight_type._fight_type_106 then
        _ED._capture_resource_fight_win = _ED.attackData.isWin
    end

    if self._fight_type == _enum_fight_type._fight_type_101 then --日常活动
        app.load("client.battle.draw.win.FightRewardForDailyActivityCopy")
        local battleReward = FightRewardForDailyActivityCopy:new()
        battleReward:init(self._fight_type)
        fwin:open(battleReward, fwin._windows)
        _ED._fight_is_win = true
    else
        local formationInfo = ""
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            if self._fight_type == _enum_fight_type._fight_type_53 then
                for i=1, 6 do
                    local ship = _ED.purify_user_ship[i]
                    if ship ~= nil then
                        if formationInfo == "" then
                            formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        else
                            formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        end
                    else
                        if formationInfo == "" then
                            formationInfo = "0,0,0,0"
                        else
                            formationInfo = formationInfo.."|".."0,0,0,0"
                        end
                    end
                end
            else
                -- 噩梦副本
                local user_info = self._fight_type == 15 and _ED.em_user_ship or _ED.user_formetion_status
                for i, v in pairs(user_info) do
                    local ship = _ED.user_ship[""..v]
                    if ship ~= nil then
                        if formationInfo == "" then
                            formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        else
                            formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        end
                    else
                        if formationInfo == "" then
                            formationInfo = "0,0,0,0"
                        else
                            formationInfo = formationInfo.."|".."0,0,0,0"
                        end
                    end
                end
            end
        end
        local scene_id = _ED._current_scene_id
        local npc_id = _ED._scene_npc_id
        if scene_id == "" then
            scene_id = "-1"
        end
        if npc_id == "" then
            npc_id = "-1"
        end

        -- 如果是矿战，小于2场算输
        if (self._fight_type ~= _enum_fight_type._fight_type_214 and tonumber(_ED.attackData.isWin) == 0) or (self._fight_type == _enum_fight_type._fight_type_214 and tonumber(_ED.cross_server_battel_grab_other_formation2.BattleResult) < 2 )    then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
                protocol_command.battle_result_fail.param_list = scene_id.."\r\n"..npc_id.."\r\n"..formationInfo
                NetworkManager:register(protocol_command.battle_result_fail.code, nil, nil, nil, nil, nil, false, nil)
            end

            if __lua_project_id == __lua_project_gragon_tiger_gate 
                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_legendary_game 
                then
                -- 记录上次战斗是否胜利
                LDuplicateWindow._infoDatas._isBattleWin = false
            end 

            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                self:showNomralLose()
            else
                if self._fight_type == _enum_fight_type._fight_type_102 then --三国无双
                    app.load("client.campaign.trialtower.TrialTowerBattleLose")
                    if fwin:find("TrialTowerBattleLoseClass") == nil then
                        fwin:open(TrialTowerBattleLose:new(), fwin._windows) 
                    end
                elseif self._fight_type == _enum_fight_type._fight_type_54 then --试炼
                    app.load("client.l_digital.campaign.trialtower.TrialTowerBattleLose")
                    if fwin:find("TrialTowerBattleLoseClass") == nil then
                        state_machine.excute("trial_tower_battle_lose_open", 0, self._fight_type)
                    end    
                elseif self._fight_type == _enum_fight_type._fight_type_103 then --领地
                    app.load("client.campaign.mine.MineManagerBattleLose")
                    fwin:open(MineManagerBattleLose:new(), fwin._windows) 
                elseif self._fight_type == _enum_fight_type._fight_type_104 then --叛军
                    app.load("client.campaign.worldboss.BetrayArmyBattleEnd")
                    if fwin:find("BetrayArmyBattleEndClass") == nil then
                        local battleReward = BetrayArmyBattleEnd:new()
                        battleReward:init(self._fight_type)
                        fwin:open(battleReward, fwin._window)
                    end
                elseif self._fight_type == _enum_fight_type._fight_type_110 then --叛军BOSS
                    app.load("client.campaign.worldboss.RebelBossBattleEnd")
                    battleReward = RebelBossBattleEnd:new()
                    battleReward:init(self._fight_type)
                    fwin:open(battleReward, fwin._window)
                -- elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_53 then
                --     app.load("client.l_digital.campaign.digitalpurify.PurifyBattleVictoryWindow")
                --     state_machine.excute("purify_battle_victory_window_open", 0, 0)
                elseif self._fight_type == _enum_fight_type._fight_type_54 then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        app.load("client.battle.SmBattleLose")
                        state_machine.excute("sm_battle_lose_open", 0, self._fight_type)
                    end
                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
                    state_machine.excute("the_kings_battle_ui_window_update_draw_win", 0, 2)
                elseif self._fight_type == _enum_fight_type._fight_type_213 then --工会战
                    app.load("client.battle.SmArenaBattleReward")
                    state_machine.excute("sm_arena_battle_reward_open", 0, self._fight_type)
                else
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        if self._fight_type == _enum_fight_type._fight_type_7 then 
                            app.load("client.l_digital.union.duplicate.SmUnionBattleReward")
                            state_machine.excute("sm_union_battle_reward_open", 0, "")

                        -- 如果是竞技场
                        elseif self._fight_type == _enum_fight_type._fight_type_11 then
                            -- 如果是回放并且我是守方，攻方输了，我看到胜利界面
                            if _ED.battle_playback_arena.playback == true and tonumber(_ED.battleData.objId) == tonumber(_ED.user_info.user_id) then
                                app.load("client.battle.SmArenaBattleReward")
                                state_machine.excute("sm_arena_battle_reward_open", 0, self._fight_type)
                            else
                                app.load("client.battle.SmBattleLose")
                                state_machine.excute("sm_battle_lose_open", 0, self._fight_type)
                            end
                        elseif self._fight_type == _enum_fight_type._fight_type_218 then
                            app.load("client.l_digital.campaign.worldboss.WorldBossFightReward")
                            state_machine.excute("world_boss_fight_reward_open", 0, "")
                        elseif self._fight_type == _enum_fight_type._fight_type_219 then
                            app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarVictory")
                            state_machine.excute("cross_total_war_victory_window_open", 0, 0)        
                        elseif self._fight_type == _enum_fight_type._fight_type_220 then
                            app.load("client.l_digital.campaign.team_arena.TeamArenaVictory")
                            state_machine.excute("team_arena_victory_window_open", 0, 0)        
                        else
                            app.load("client.battle.SmBattleLose")
                            state_machine.excute("sm_battle_lose_open", 0, self._fight_type)
                        end

                        
                    else
                        -- app.load("client.battle.BattleLose")
                        -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                        --     local function delayEndFuncN( _sender )
                        --         if _sender ~= nil then
                        --             if fwin:find("BattleLoseClass") == nil then
                        --                 local battleLose = BattleLose:new() 
                        --                 battleLose:init(self._fight_type)
                        --                 fwin:open(battleLose, fwin._window)
                        --             end
                        --         end
                        --     end
                        --     local actions = {}
                        --     table.insert(actions, cc.DelayTime:create(1))
                        --     table.insert(actions, cc.CallFunc:create(delayEndFuncN))
                        --     local seq = cc.Sequence:create(actions)
                        --     self:runAction(seq)
                        -- else
                        --     local battleLose = BattleLose:new() 
                        --     battleLose:init(self._fight_type)
                        --     fwin:open(battleLose, fwin._window)
                        -- end
                        self:showNomralLose()
                    end
                end
            end
            _ED._fight_is_win = false
        else
            _ED._fight_is_win = true

            -- Optional online friend tasks must not block a local campaign win.
            -- Enable this only when the local File Island protocol is implemented.
            if self._fight_type == _enum_fight_type._fight_type_0
                and (not _ED.local_quest_enabled or _ED.local_file_island_enabled == true) then
                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local taskInfo = _ED.fileIsland.taskInfo
                        if taskInfo then
                            -- 我的任务
                            local taskInfo1 = {}

                            for i = 1, #taskInfo.mySingleTaskInfo do
                                local data = taskInfo.mySingleTaskInfo[i]
                                if data.curProgress == 0 then
                                    local configId = data.configId
                                    local configdata = dms.element(dms["file_island_friend_task"], configId)
                                    local npcNum = dms.atos(configdata, file_island_friend_task.npcNum)
                                    if tonumber(data.selfChallengeTimes) < tonumber(npcNum) then
                                        table.insert(taskInfo1, data)
                                    end
                                end
                            end

                            for i = 1, #taskInfo.myJoinTaskInfo do
                                local data = taskInfo.myJoinTaskInfo[i]
                                data.isMyJoinTaskInfo = true
                                local configId = data.configId
                                local npcNum = dms.atos(configdata, file_island_friend_task.friend_npcNum)
                                if tonumber(data.friendChallengeTimes) < tonumber(npcNum) then
                                    table.insert(taskInfo1, data)
                                end
                            end

                            for i = 1, #taskInfo.myMultiTaskInfo do
                                local data = taskInfo.myMultiTaskInfo[i]
                                if data.curProgress == 0 then
                                    local configId = data.configId
                                    local configdata = dms.element(dms["file_island_friend_task"], configId)
                                    local npcNum = dms.atos(configdata, file_island_friend_task.npcNum)
                                    if tonumber(data.selfChallengeTimes) < tonumber(npcNum) then
                                        table.insert(taskInfo1, data)
                                    end
                                end
                            end

                            local task = {}
                            for i = 1, #taskInfo1 do
                                local configId = taskInfo1[i].configId
                                local configdata = dms.element(dms["file_island_friend_task"], configId)
                                local npcId = dms.atos(configdata, file_island_friend_task.npcId)

                                if taskInfo1[i].isMyJoinTaskInfo == true then
                                    npcId = dms.atos(configdata, file_island_friend_task.friend_npcId)
                                end

                                local finderUid = taskInfo1[i].uid
                                local taskId = taskInfo1[i].taskId

                                local t = {}
                                t.npcId = npcId
                                t.attackCount = 0
                                table.insert(task, t)
                            end

                            local formation_count = dms.int(dms["npc"], tonumber(_ED._scene_npc_id), npc.formation_count)
                            for i = 1, formation_count do
                                local environmentIndex = npc.environment_formation1 + i - 1
                                local environmentId = dms.int(dms["npc"], tonumber(_ED._scene_npc_id), environmentIndex)
                                for j = 1, 6 do
                                    local environment_shipIndex = environment_formation.seat_one + j - 1
                                    local environment_shipId = dms.int(dms["environment_formation"], environmentId, environment_shipIndex)
                                    if environment_shipId ~= 0 then
                                        local shipId = dms.int(dms["environment_ship"], environment_shipId, environment_ship.directing)
                                        for k = 1, #task do
                                            local t = task[k]
                                            if tonumber(t.npcId) == shipId then
                                                t.attackCount = t.attackCount + 1
                                            end
                                        end
                                    end
                                end
                            end

                            local function callback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    state_machine.excute("fileIsland_friends_refresh_list", 0, "")
                                end
                            end

                            local map = {}
                            for k = 1, #task do
                                local t = task[k]
                                if t.attackCount ~= 0 then
                                    map[t.npcId] = t.attackCount
                                end
                            end

                            local t = {}
                            for k, v in pairs(map) do
                                local temp = {}
                                temp.npcId = k
                                temp.attackCount = v
                                table.insert(t, temp)
                            end

                            if #t ~= 0 then
                                local str = json.encode(t)
                                protocol_command.fileIslandFriendTaskExecute.param_list = str
                                NetworkManager:register(protocol_command.fileIslandFriendTaskExecute.code, nil, nil, nil, nil, callback, false, nil)
                            end
                        end
                    
                    end
                end

                _ED.fileIsland = _ED.fileIsland or {}
                protocol_command.fileIslandTaskInfo.param_list = ""
                NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, callback, false, nil)

            end

            if self._fight_type ==  _enum_fight_type._fight_type_215 then
                if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    if _ED.pokemonExplore and _ED.pokemonExplore.file_island_boss_challenge then
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                app.load("client.battle.SmBattleReward")
                                state_machine.excute("sm_battle_reward_open", 0, self._fight_type)
                            end
                        end

                        local str = json.encode(_ED.pokemonExplore.file_island_boss_challenge)
                        print("发送boss挑战完成 " .. str)
                        protocol_command.pokemon_explore_boss_challenge.param_list = str
                        NetworkManager:register(protocol_command.pokemon_explore_boss_challenge.code, nil, nil, nil, nil, callback, false, nil)
                    end
                else
                    if _ED.fileIsland and _ED.fileIsland.file_island_boss_challenge then
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                app.load("client.battle.SmBattleReward")
                                state_machine.excute("sm_battle_reward_open", 0, self._fight_type)
                            end
                        end

                        local str = json.encode(_ED.fileIsland.file_island_boss_challenge)
                        print("发送boss挑战完成 " .. str)
                        protocol_command.file_island_boss_challenge.param_list = str
                        NetworkManager:register(protocol_command.file_island_boss_challenge.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end
            elseif self._fight_type ==  _enum_fight_type._fight_type_216 or self._fight_type ==  _enum_fight_type._fight_type_217 then
                if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    if _ED.pokemonExplore and _ED.pokemonExplore.fileIslandSingleChallenge then
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                app.load("client.battle.SmBattleReward")
                                state_machine.excute("sm_battle_reward_open", 0, self._fight_type)
                                -- NetworkManager:register(protocol_command.pokemon_explore_finish_search_result.code, nil, nil, nil, nil, nil, false, nil)
                            end
                        end

                        local str = json.encode(_ED.pokemonExplore.fileIslandSingleChallenge)
                        print("发送单人挑战完成 " .. str)
                        protocol_command.pokemon_explore_single_challenge.param_list = str
                        NetworkManager:register(protocol_command.pokemon_explore_single_challenge.code, nil, nil, nil, nil, callback, false, nil)
                    end
                else
                    if _ED.fileIsland and _ED.fileIsland.fileIslandSingleChallenge then
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                app.load("client.battle.SmBattleReward")
                                state_machine.excute("sm_battle_reward_open", 0, self._fight_type)
                                if _ED.eventIds[5] and table.nums(_ED.eventIds[5]) <= 0 then
                                    NetworkManager:register(protocol_command.file_island_finish_search_result.code, nil, nil, nil, nil, nil, false, nil)
                                end
                            end
                        end

                        local str = json.encode(_ED.fileIsland.fileIslandSingleChallenge)
                        print("发送单人挑战完成 " .. str)
                        protocol_command.fileIslandSingleChallenge.param_list = str
                        NetworkManager:register(protocol_command.fileIslandSingleChallenge.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end
            end


            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                -- 记录上次战斗是否胜利
                LDuplicateWindow._infoDatas._isBattleWin = true
            end 
        
            -- 根据战斗类型,做不同的胜利界面跳转
            --> print("胜利了----_fight_type----",self._fight_type)
            local battleReward = nil
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                app.load("client.battle.BattleReward")
                battleReward = BattleReward:new()
            else
                if self._fight_type == _enum_fight_type._fight_type_10 then --抢夺
                    app.load("client.campaign.plunder.PlunderBattleReward")
                    battleReward = PlunderBattleReward:new()
                    battleReward:init(self._fight_type)
                    local sceneParam = "pbw1"
                    executeMissionExt(mission_mould_tuition, touch_off_mission_into_home, "0", nil, false, sceneParam, true)
                elseif self._fight_type == _enum_fight_type._fight_type_11 then --竞技场
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

                        -- 如果是回放并且我是守方，攻方赢了，我看到失败界面
                        if _ED.battle_playback_arena.playback == true and tonumber(_ED.battleData.objId) == tonumber(_ED.user_info.user_id) then
                            app.load("client.battle.SmBattleLose")
                            state_machine.excute("sm_battle_lose_open", 0, self._fight_type)
                        else
                            app.load("client.battle.SmArenaBattleReward")
                            state_machine.excute("sm_arena_battle_reward_open", 0, self._fight_type)
                        end

                    else
	                    app.load("client.campaign.arena.ArenaBattleReward")
	                    battleReward = ArenaBattleReward:new()
	                    battleReward:init(self._fight_type)
                    end
                    local sceneParam = "abw1"
                    executeMissionExt(mission_mould_tuition, touch_off_mission_into_home, "0", nil, false, sceneParam, true)
                elseif self._fight_type == _enum_fight_type._fight_type_13 then --切磋
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        app.load("client.battle.SmArenaBattleReward")
                        state_machine.excute("sm_arena_battle_reward_open", 0, self._fight_type)
                    end
                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_53 then
                    app.load("client.l_digital.campaign.digitalpurify.PurifyBattleVictoryWindow")
                    state_machine.excute("purify_battle_victory_window_open", 0, 0)
                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_54 then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        app.load("client.l_digital.campaign.trialtower.TrialTowerBattleReward")
                        battleReward = TrialTowerBattleReward:new()
                        battleReward:init(self._fight_type, _ED._fightModule.attackObjects)
                    end
                elseif self._fight_type == _enum_fight_type._fight_type_102 then --三国无双
                    app.load("client.campaign.trialtower.TrialTowerBattleReward")
                    battleReward = TrialTowerBattleReward:new()
                    battleReward:init(self._fight_type, _ED._fightModule.attackObjects)
                elseif self._fight_type == _enum_fight_type._fight_type_103 then --领地
                    app.load("client.campaign.mine.MineManagerBattleReward")
                    battleReward = MineManagerBattleReward:new()
                    battleReward:init(self._fight_type)
                elseif self._fight_type == _enum_fight_type._fight_type_104 then --叛军
                    app.load("client.campaign.worldboss.BetrayArmyBattleEnd")
                    battleReward = BetrayArmyBattleEnd:new()
                    battleReward:init(self._fight_type)
                elseif self._fight_type == _enum_fight_type._fight_type_110 then --叛军boss
                    app.load("client.campaign.worldboss.RebelBossBattleEnd")
                    battleReward = RebelBossBattleEnd:new()
                    battleReward:init(self._fight_type)
                elseif self._fight_type == _enum_fight_type._fight_type_106 then --资源抢夺
                    app.load("client.captureResource.CaptureResourceWin")
                    battleReward = CaptureResourceWin:new()
                elseif self._fight_type == _enum_fight_type._fight_type_8 then --工会战
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        app.load("client.l_digital.union.unionFighting.UnionFightWin")
                    else
                        app.load("client.union.unionFighting.UnionFightWin")
                    end
                    battleReward = UnionFightWin:new():init(self._fight_type)
                elseif self._fight_type == _enum_fight_type._fight_type_107 then  --排位赛
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        app.load("client.l_digital.union.unionFighting.UnionFightWin")
                    else
                        app.load("client.union.unionFighting.UnionFightWin")
                    end
                    battleReward = UnionFightWin:new():init(self._fight_type)
                elseif self._fight_type == _enum_fight_type._fight_type_109 then  --宠物副本
                    app.load("client.campaign.battlefield.BattleFieldFightReward")
                    battleReward = BattleFieldFightReward:new()
                    battleReward:init(self._fight_type)
                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                        app.load("client.battle.BattleRewardForActivityCopy")
                        state_machine.excute("battle_reward_for_activity_copy_window_open", 0, self._fight_type)
                    else
                        app.load("client.battle.BattleReward")
                        battleReward = BattleReward:new()
                        fwin:open(battleReward, fwin._window)
                    end
                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then -- 王者之战
                    state_machine.excute("the_kings_battle_ui_window_update_draw_win", 0, 0)
                elseif self._fight_type == _enum_fight_type._fight_type_213 then --工会战
                    app.load("client.battle.SmArenaBattleReward")
                    state_machine.excute("sm_arena_battle_reward_open", 0, self._fight_type)

                -- 跨服矿战
                elseif self._fight_type == _enum_fight_type._fight_type_214 then
                    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelVictory")
                    state_machine.excute("cross_server_battel_victory_open", 0, self._fight_type)

                -- 跨服忍界
                elseif self._fight_type == _enum_fight_type._fight_type_219 then
	                app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarVictory")
                    state_machine.excute("cross_total_war_victory_window_open", 0, 1)
                elseif self._fight_type == _enum_fight_type._fight_type_220 then
                    app.load("client.l_digital.campaign.team_arena.TeamArenaVictory")
                    state_machine.excute("team_arena_victory_window_open", 0, 1)        
                else
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        if self._fight_type == _enum_fight_type._fight_type_7 then
                            app.load("client.l_digital.union.duplicate.SmUnionBattleReward")
                            state_machine.excute("sm_union_battle_reward_open", 0, "")
                        elseif self._fight_type == _enum_fight_type._fight_type_218 then
                            app.load("client.l_digital.campaign.worldboss.WorldBossFightReward")
                            state_machine.excute("world_boss_fight_reward_open", 0, "")
                        else

                            if self._fight_type ~= _enum_fight_type._fight_type_215 
                                and self._fight_type ~= _enum_fight_type._fight_type_216
                                and self._fight_type ~= _enum_fight_type._fight_type_217 then

                                app.load("client.battle.SmBattleReward")
                                state_machine.excute("sm_battle_reward_open", 0, self._fight_type)
                            end

                        end
                    else
                        app.load("client.battle.BattleReward")
                        battleReward = BattleReward:new()
                        battleReward:init(self._fight_type)
                    end
                end
            end
            fwin:open(battleReward, fwin._ui)
        end
    end

    if __lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh then
        self:gameDataRecord()
    end
    collectgarbage("restart")
    attack_logic.__hero_ui_visible = false
    attack_logic.__hero_ui_lock = true
    -- if _ED._fightModule ~= nil then
    --     _ED._fightModule = nil
    -- end
    _ED._battle_eve_environment_ship_id = 0
    _ED._battle_eve_release_ship_id = ""
    _ED._battle_eve_auto_fight = false
    self._spineJsons = {}
    for k,v in pairs(self._spineEffects) do
        if v ~= nil then
            v:release()
            v = nil
        end
    end
    self._spineEffects = {}
    if __lua_project_id == __lua_project_yugioh then
        _ED.trapCardInfo = ""
    end

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        if _ED._fight_is_win == true then
            self._battle_index = self._battle_index or 1
            executeResetCurrentEvent()
            if self._fight_type == _enum_fight_type._fight_type_0 
                or self._fight_type == _enum_fight_type._fight_type_1
                then
                if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, "".._ED._scene_npc_id.."v"..self._battle_index, nil) == true then
                    executeNextEvent(nil, true)
                end
            end
        end
    end
end

function Fight:exitFight()
    self:fightOver()
end

function Fight:fightOver()
    if self._fight_is_end == true then
        return
    end
    
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        state_machine.excute("fight_role_controller_fight_end_stop_auto", 0 , nil)
        local function responseEnvironmentFightCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                _ED.attackData.isWin = "".._ED._fightModule.fightResult
                -- _ED._fightModule = nil
                _ED._fightModule._response = true
                if missionIsOver() == true then
                    response.node:fightEnd()
                end
            end
        end
        if _ED._fightModule ~= nil or (nil ~= _ED._fightModule and true ~= _ED._fightModule._response) then
            if _ED.nr_arena_fight_rank then
                if _ED.nr_arena_fight_replay then
                    -- A report replay must not spend an attempt or settle the
                    -- historical rank and points a second time.
                    _ED.nr_arena_fight_replay = nil
                    _ED.nr_arena_fight_rank = nil
                    _ED.nr_arena_fight_match_id = nil
                    _ED.attackData.isWin = "".._ED._fightModule.fightResult
                    _ED._fightModule._response = true
                    if missionIsOver() == true then self:fightEnd() end
                else
                    -- NinjaAscension arena: tell the server who won (arena_local.py launch).
                    local win = tonumber(_ED._fightModule.fightResult) == 1 and "1" or "0"
                    protocol_command.arena_launch.param_list = _ED.nr_arena_fight_rank .. "\r\n2\r\n" .. win
                    if _ED.nr_arena_fight_match_id then
                        protocol_command.arena_launch.param_list = protocol_command.arena_launch.param_list
                            .. "\r\n" .. _ED.nr_arena_fight_match_id
                        if type(cc.nrSpineCommand)=='function' then
                            local record=require('arena_replay').finish(_ED.nr_arena_fight_match_id,win)
                            if record then protocol_command.arena_launch.param_list=protocol_command.arena_launch.param_list.."\r\n"..record end
                        end
                    end
                    _ED.nr_arena_fight_rank = nil
                    _ED.nr_arena_fight_match_id = nil
                    NetworkManager:register(protocol_command.arena_launch.code, nil, nil, nil, self, responseEnvironmentFightCallback, false, nil)
                end
            elseif self._fight_type == _enum_fight_type._fight_type_101 then
                state_machine.excute("fight_ui_for_daily_activity_copy_update_fight_damage", 0, {_ED.user_info.battleCache.totalDamage})               
				protocol_command.daily_instance_verify.param_list = _ED._daily_copy_npc_id.."\r\n".._ED.user_info.battleCache.totalDamage.."\r\n".._ED._fightModule.roundCount.."\r\n"..self._difficulty.."\r\n".."1"
				NetworkManager:register(protocol_command.daily_instance_verify.code, nil, nil, nil, self, responseEnvironmentFightCallback, false, nil)
            elseif self._fight_type == _enum_fight_type._fight_type_54 
                or self._fight_type == _enum_fight_type._fight_type_53 then
                local npcId = self._npc_id
                if _ED._battle_eve_unlock_npc ~= "" and tonumber(_ED._battle_eve_unlock_npc) ~= 0 then
                    npcId = _ED._battle_eve_unlock_npc
                    _ED._battle_eve_unlock_npc = 0
                end
                _ED.attackData.isWin = "".._ED._fightModule.fightResult
                -- _ED._fightModule = nil
                _ED._fightModule._response = true
                if missionIsOver() == true then
                    self:fightEnd()
                end
            elseif self._fight_type == _enum_fight_type._fight_type_7 or self._fight_type == _enum_fight_type._fight_type_218 then
                self:fightEnd()

            elseif self._fight_type == _enum_fight_type._fight_type_215 or self._fight_type == _enum_fight_type._fight_type_216 or self._fight_type == _enum_fight_type._fight_type_217 then
                self:fightEnd()

			else
                local npcId = self._npc_id
                if _ED._battle_eve_unlock_npc ~= "" and tonumber(_ED._battle_eve_unlock_npc) ~= 0 then
                    npcId = _ED._battle_eve_unlock_npc
                    _ED._battle_eve_unlock_npc = 0
                end
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 
                        then
                        local r = math.floor(_ED._fightModule.totalDefenceDamage / _ED._fightModule.npcMaxHealth * 100)
                        local ns = 0
                        if r < 10 then
                            _ED._fightModule.star = 1
                        elseif r < 100 then
                            _ED._fightModule.star = 1
                        else
                            if _ED._fightModule.star == 3 then
                                _ED._fightModule.star = _ED._fightModule.star
                            else
                                _ED._fightModule.star = 2
                            end
                        end
                        _ED._activity_copy_drop_info_str = ""
                        _ED._fightModule._drop_info_count = _ED._fightModule._drop_info_count or 0
                        local r = 0.5
                        -- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 then
                        --     r = dms.float(dms["play_config"], 4, pirates_config.param)
                        -- elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 
                        --     or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
                        --     then
                        --     r = dms.float(dms["play_config"], 9, pirates_config.param)
                        -- end
                        
                        if nil ~= _ED._fightModule._g_c_silver_info then
                            local history_info = aeslua.decrypt("jar-world", _ED._fightModule._g_c_silver_info, aeslua.AES128, aeslua.ECBMODE)
                            if history_info ~= "" .. _ED._fightModule._g_c_silver then
                                if fwin:find("ReconnectViewClass") == nil then
                                    _ED._fightModule._error = true
                                    fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
                                    return
                                end
                            end
                        end

                        local _g_silver = _ED._fightModule._g_c_silver -- math.floor(_ED._fightModule.totalDefenceDamage * r)
                        local mergeReward = {}
                        if _ED._activity_copy_drop_info_arr ~= nil then
                            for i, v in pairs(_ED._activity_copy_drop_info_arr) do
                                if i <= _ED._fightModule._drop_info_count then
                                    if _g_silver > 0 then
                                        for m, n in pairs(v) do
                                            -- if n[1] == "1" then
                                            --     _g_silver = _g_silver + tonumber(n[3])
                                            --     n[3] = "" .. _g_silver
                                            --     _g_silver = 0
                                            -- end

                                            local key = n[1] .. "&" .. n[2]
                                            local t = mergeReward[key]
                                            if nil ~= t then
                                                local nCount = tonumber(t[3]) + tonumber(n[3])
                                                t[3] = "" .. nCount
                                            else
                                                mergeReward[key] = n
                                            end
                                        end
                                    end
                                    -- local rewardInfo = zstring.concats(v, "|", ",")
                                    -- if #rewardInfo > 0 then
                                    --     if #_ED._activity_copy_drop_info_str > 0 then
                                    --         _ED._activity_copy_drop_info_str = _ED._activity_copy_drop_info_str .. "|"
                                    --     end
                                    --     _ED._activity_copy_drop_info_str = _ED._activity_copy_drop_info_str .. rewardInfo
                                    -- end
                                end
                            end
                        end
                        if _g_silver > 0 then
                            -- if #_ED._activity_copy_drop_info_str > 0 then
                            --     _ED._activity_copy_drop_info_str = _ED._activity_copy_drop_info_str .. "!"
                            -- end
                            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 then
                                -- _ED._activity_copy_drop_info_str = _ED._activity_copy_drop_info_str .. "1,-1," .. _g_silver
                                local key = "1&-1"
                                local t = mergeReward[key]
                                if nil ~= t then
                                    local nCount = tonumber(t[3]) + _g_silver
                                    t[3] = "" .. nCount
                                else
                                    mergeReward[key] = {"1", "-1", "" .. _g_silver}
                                end
                            elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 
                                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
                                then
                                -- _ED._activity_copy_drop_info_str = _ED._activity_copy_drop_info_str .. "6,229," .. _g_silver
                                local propMouldId = _ED._fightModule._boss_reward_h[1][4]
                                local key = "6&" .. propMouldId
                                local t = mergeReward[key]
                                if nil ~= t then
                                    local nCount = tonumber(t[3]) + _g_silver
                                    t[3] = "" .. nCount
                                else
                                    mergeReward[key] = {"6", propMouldId, "" .. _g_silver}
                                end
                            end
                        end
                        local rewardInfo = zstring.concats(mergeReward, "|", ",")
                        if #rewardInfo > 0 then
                            if #_ED._activity_copy_drop_info_str > 0 then
                                _ED._activity_copy_drop_info_str = _ED._activity_copy_drop_info_str .. "|"
                            end
                            _ED._activity_copy_drop_info_str = _ED._activity_copy_drop_info_str .. rewardInfo
                        end
                        -- print("****::", _g_silver, r, _ED._fightModule.totalDefenceDamage, _ED._activity_copy_drop_info_str, _ED._fightModule.npcMaxHealth)
                    end
                end
                if Fight._lock_start_count ~= nil then
                    _ED._fightModule.star = Fight._lock_start_count
                    Fight._lock_start_count = nil
                end
				protocol_command.battle_result_verify.param_list = self._scene_id.."\r\n".. npcId .. "-" .. self._npc_id .."\r\n".._ED._fightModule.star.."\r\n"..self._difficulty.."\r\n".."1"
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
                        protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. "\r\n" .. _ED._activity_copy_drop_info_str or ""
                    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51 then
                        if _ED.m_activity_battle_fight_type_51_list ~= nil and _ED.m_activity_battle_fight_type_51_list ~= "" then
                            protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. "\r\n" .. _ED.m_activity_battle_fight_type_51_list
                        else
                            protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. "\r\n" .. "-1"
                        end
                    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_212 then
                        if _ED._fightModule.fightResult == 0 then
                            protocol_command.battle_result_verify.param_list = self._scene_id.."\r\n"..npcId.."\r\n0\r\n"..self._difficulty.."\r\n1"
                        end
                        if _ED.m_activity_battle_fight_type_212_list ~= nil and _ED.m_activity_battle_fight_type_212_list ~= "" then
                            protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. "\r\n" .. _ED.m_activity_battle_fight_type_212_list
                        else
                            protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. "\r\n" .. "-1"
                        end
                    end
                end

                if tonumber(_ED.npc_last_state[self._npc_id]) <= 0 then
                    self._check_npc_mission = true
                end
                local user_info = self._fight_type == 15 and _ED.em_user_ship or _ED.user_formetion_status
                local formationInfo = ""
                for i, v in pairs(user_info) do
                    local ship = _ED.user_ship[""..v]
                    if ship ~= nil then
                        if formationInfo == "" then
                            formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        else
                            formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        end
                    else
                        if formationInfo == "" then
                            formationInfo = "0,0,0,0"
                        else
                            formationInfo = formationInfo.."|".."0,0,0,0"
                        end
                    end
                end
                protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. "\r\n" .. formationInfo
                -- print("............", protocol_command.battle_result_verify.param_list)
				NetworkManager:register(protocol_command.battle_result_verify.code, nil, nil, nil, self, responseEnvironmentFightCallback, false, nil)
			end
        else
            if missionIsOver() == true then
                self:fightEnd()
            end
        end
    else
        self:fightEnd()
    --[[
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
    if self._npc_type == "0" then
        
    elseif self._npc_type == "1" then
        if self._boss_battle_card_num ~= nil then
            local pathName = string.format(self._boss_battle_card_string,self._boss_battle_card_num)
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(pathName)
        end
    end
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_head_effect.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_head_effect_2.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_head_effect_2_1.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_head_effect_4.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_broken_effect.ExportJson")
    ccs.ArmatureDataManager:destroyInstance()
    cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
    -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()

    -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, f_imageLoaded)

    cacher.removeAllTextures()
    -- cacher.addTextureAsync(texture_cache_load_images)
    --]]
    
    end
end

function Fight:reorderRole(role)
    if role._moving == true then
        return
    end
    local p = cc.p(role:getPosition())
    -- p = CC_POINT_POINTS_TO_PIXELS(p)
    local  map = role:getParent()

    -- there are only 4 layers. (grass and 3 trees layers)
    -- if tamara < 81, z=4
    -- if tamara < 162, z=3
    -- if tamara < 243,z=2

    -- -10: customization for this particular sample
    local newZ = 40 - ( (p.y-10) / 81)
    newZ = math.max(newZ,0)
    -- map:reorderChild(role, newZ)
    -- --> print(math.floor(newZ), role:getName(), role:getParent():getName(), role:getParent():getParent():getName())
    role:setLocalZOrder(math.floor(newZ))
end

function Fight:onUpdate(dt)
    for i, v in pairs(self._bullets) do
        if nil ~= v and nil ~= v.getPosition then
            local pos = cc.p(v:getPosition())
            local taget_pos = v._mp
            local angle = CC_POSITIONS_TO_DEGREES(taget_pos, pos)
            v._mp = pos
            if false == v._visible then
                local vfr = angle - v:getRotation()
                if math.abs(vfr) < 10 then
                    v._visible = true
                    v:setVisible(true)
                end
            end
            v:setRotation(angle)
            v._streak:setPosition(pos)
        end
    end

    for i, v in pairs(self._hero_formation) do
        if v~= nil and v.getParent ~= nil then
            self:reorderRole(v)
            -- if v._armature ~= nil and v._armature._node ~= nil then
            --     v._armature._node:onUpdate(dt)
            -- end
        end
    end
    for i, v in pairs(self._master_formation) do
        if v~= nil and v.getParent ~= nil then
            self:reorderRole(v)
            -- if v._armature ~= nil and v._armature._node ~= nil then
            --     v._armature._node:onUpdate(dt)
            -- end
        end
    end
    
    -- local w = app.designSize.width * app.scaleFactor / 48
    -- local h = app.designSize.height * app.scaleFactor / 48
    -- for i, v in pairs(self._hero_formation) do
    --     if v~= nil and v.getParent ~= nil then
    --         local root = v:getParent()
    --         local x, y = v:getPosition()
    --         root:reorderChild(v, (h - y / 48) * w + x / 48)
    --         --> print(v:getName(), (h - y / 48) * w + x / 48)
    --     end
    -- end
    -- for i, v in pairs(self._master_formation) do
    --     if v~= nil and v.getParent ~= nil then
    --         local root = v:getParent()
    --         local x, y = v:getPosition()
    --         root:reorderChild(v, (h - y / 48) * w + x / 48)
    --         --> print(v:getName(), (h - y / 48) * w + x / 48)
    --     end
    -- end

    if __lua_project_id ~= __lua_project_gragon_tiger_gate and __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_naruto  then
        if self._fightIsOver == true then
            self._waitOverTime = self._waitOverTime - dt
            if self._waitOverTime < 0 then
                self._fightIsOver = false
                self:fightOver()
            end
        end
    else
        if self._isHaveStory == false then
            if self._fightIsOver == true then
                self._waitOverTime = self._waitOverTime - dt
                if self._waitOverTime < 0 then
                    self._fightIsOver = false
                    self:fightOver()
                end
            end
        end
    end
end

function Fight:onEnterTransitionFinish()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_legendary_game then
        -- code
    else
        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        else
            fwin:open(self.battleFormationController, fwin._view)
            self.battleFormationController:release()
        end
        fwin:open(self._fightMapLayer, fwin._background)
        self._fightMapLayer:release()
    end
    if __lua_project_id ==__lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b
        or __lua_project_id == __lua_project_digimon_adventure 
        -- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge   
        or __lua_project_id == __lua_project_yugioh 
        then
        if ___is_open_push_info ~= false  then
            app.load("client.home.WarshipGirlPushInfo")
            state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=1}})
        end
    end
end

function Fight:showRole(_camp, params, isInit)
    -- 角色出现或消失
    local show_list = zstring.split(params, ",")
    if _camp == "0" then
        if #self._hero_formation == 0 then
            return false
        end
        for i=1, 6 do
            if __lua_project_id == __lua_project_digimon_adventure 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
                or __lua_project_id == __lua_project_naruto 
                or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge 
                or __lua_project_id == __lua_project_yugioh 
                then
                if self._hero_formation[i] == nil then 
                    break
                end
            end
            local posTile = self._hero_formation[i]._armature
            local isVisible = tonumber(show_list[i]) == 1 and true or false
            local proVisible = posTile:isVisible()
            local spArmature = nil
            if __lua_project_id == __lua_project_yugioh
               or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge 
               then
                spArmature = self._hero_formation[i]._spArmature
            end
            --if proVisible ~= isVisible then
                if isInit == true then
                    posTile:setVisible(false)
                    if spArmature ~= nil then
                        spArmature:setVisible(false)
                    end
                else
                    if spArmature ~= nil then
                        spArmature:setVisible(isVisible)
                        posTile:setVisible(false)
                    else
                        posTile:setVisible(isVisible)
                    end
                end
                if isVisible == true then
                    if posTile._isShow ~= true then
                        posTile._isShow = true
                        -- heroJoinBattle1(posTile, eventJoinCount)
                        -- eventJoinCount = eventJoinCount + 1
                        
                        posTile._heroInfoWidget:controlLife(false, 10)
                        posTile._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
                        -- posTile._heroInfoWidget:controlLife(true, 10)
                    end
                else
                    posTile._isShow = false
                    
                    posTile._heroInfoWidget:controlLife(false, 10)
                    posTile._heroInfoWidget:showControl(false)
                    posTile._heroInfoWidget:controlLife(true, 10)
                end
            --end
        end
    else
        if #self._master_formation == 0 then
            for i = 1, 6 do
                local padNode = ccui.Helper:seekWidgetByName(self._fightMapLayer:rootAtIndex(1), string.format("Panel_%d_%d", 1, tonumber(""..i)))
                local posTile = padNode
                local isVisible = tonumber(show_list[i]) == 1 and true or false
                posTile._isShow = isVisible
            end
            return true
        end
        local fIndex =  1
        for i=1, 6 do
            local formation_master = self._master_formation[i]
            if formation_master ~= nil then
                local posTile = formation_master._armature
                local isVisible = tonumber(show_list[i]) == 1 and true or false
                local spArmature = nil
                if __lua_project_id == __lua_project_yugioh 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge 
                    then
                    spArmature = self._master_formation[i]._spArmature
                end
                if posTile ~= nil and posTile._pos ~= nil then
                    local proVisible = posTile:isVisible()
                --if proVisible ~= isVisible then
                    if isInit == true then
                        posTile:setVisible(false)
                        if spArmature ~= nil then
                            spArmature:setVisible(false)
                        end
                    else
                        if spArmature ~= nil then
                            spArmature:setVisible(isVisible)
                            posTile:setVisible(false)
                        else
                            posTile:setVisible(isVisible)
                        end
                    end

                    if isVisible == true then
                        if posTile._isShow ~= true then
                            posTile._isShow = true
                            -- heroJoinBattle1(posTile, eventJoinCount)
                            -- eventJoinCount = eventJoinCount + 1
                            
                            posTile._heroInfoWidget:controlLife(false, 10)
                            posTile._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
                        end
                    else
                        posTile._isShow = false
                        
                        posTile._heroInfoWidget:controlLife(false, 10)
                        posTile._heroInfoWidget:showControl(false)
                        posTile._heroInfoWidget:controlLife(true, 10)
                    end
                end
                self._master_formation[i]._isShow = isVisible
            end
        end
    end
    return true
end

--宠物加层显示播放完毕
function petAnimationEventCallFunc(armatureBack)
    local camp = armatureBack._camp
    if armatureBack ~= nil  then 
        armatureBack:removeFromParent(true)
    end
    local isPlayPetAnimation = false
    if camp == 0 then 
        for i, v in pairs(Fight._self._heros) do
            if v ~= nil and v ~= "" then 
                v:showPetAddAnimation()
            end
        
            if v._playPetArmature == true then 
                isPlayPetAnimation = true
            end
        end
    else
        for i, v in pairs(Fight._self._masters) do
            if v ~= nil and v ~= "" then 
                v:showPetAddAnimation()
            end
            if v._playPetArmature == true then 
                isPlayPetAnimation = true
            end
        end
    end

    if isPlayPetAnimation == false then 
        --没有播放宠物加层效果 宠物加层阵位，玩家没有上阵此角色
        if camp == 0 then 
            state_machine.excute("fight_pet_play_over", 0, 0)
        else
            state_machine.excute("fight_request_battle", 0, params)
        end
    end
    -- if Fight._self._petHero ~= nil then 
    --     Fight._self._petHero:showPetAddAnimation()
    -- end
end

function Fight:playAnimationByPetToHeros(camp,shipId)
     local picIndex = dms.string(dms["ship_mould"], shipId, ship_mould.All_icon)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_"..picIndex..".ExportJson")
    local armatureName = "effice_" ..picIndex
    local armature1 = ccs.Armature:create(armatureName)
    if armature1 ~= nil then 
        armature1.actionIndex = 0
        armature1:getAnimation():playWithIndex(0)
        armature1._camp = camp
        
        armature1:getAnimation():setMovementEventCallFunc(petAnimationEventCallFunc)

        local cwPanle = ccui.Helper:seekWidgetByName(self._fightMapLayer:rootAtIndex(1), "Panel_" .. camp.."_pet") 
        if cwPanle ~= nil then 
            armature1:setPosition(cc.p(cwPanle:getContentSize().width/2, cwPanle:getContentSize().height/2))
            cwPanle:addChild(armature1)
        end
    end
end

function Fight:getFightType( ... )
    return self._fight_type
end

function Fight:close()
    if __lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        then
        -- if _ED._fight_is_win == false then
        --     app.load("client.activity.ActivityFirstRechargePopup")
        --     state_machine.excute("activity_first_recharge_popup_open_window", 0, 0)
        -- end
    end
end

function Fight:destroy(window)
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        app.notification_center.running = true
        fwin:unAllCovers(nil, false, nil)
		if fwin:find("PveMapClass") ~= nil then
			state_machine.excute("pve_map_update_draw", 0, 0)
		end
        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            -- againPlayBgm()
        end
    end
    cacher.destorySystemCacher(nil)
    if _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_212 then
        if nil ~= sp.SkeletonRenderer.clear then
            sp.SkeletonRenderer:clear()
        end
    end
    cacher.removeAllTextures()
    if nil ~= audioUtilUncacheAllEx then
        audioUtilUncacheAllEx()
    end
end

function Fight:onExit()
    cc.Director:getInstance():getScheduler():setTimeScale(1)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_7
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_52 
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_54 
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_215
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_216
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_217
            then
            if nil ~= _ED.user_formetion_status_copy then
                _ED.user_formetion_status = _ED.user_formetion_status_copy
                _ED.user_formetion_status_copy = nil
            end
            
            if nil ~= _ED.formetion_copy then
                _ED.formetion = _ED.formetion_copy
                _ED.formetion_copy = nil
            end
            -- _ED.user_info.fight_capacity = getUserTotalFight()
        end
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        then
        if self._spineEffects ~= nil then
            for k,v in pairs(self._spineEffects) do
                if v ~= nil then
                    v:release()
                    v = nil
                end
            end
            self._spineEffects = {}
        end
		cacher.remvoeUnusedArmatureFileInfoes()
        state_machine.remove("fight_attack_check_boss_instro")
    end

    state_machine.remove("fight_hero_hp_update")
    state_machine.remove("fight_hero_into")
    state_machine.remove("fight_hero_into_over")
    state_machine.remove("fight_hero_reset_over")
    state_machine.remove("fight_hero_fight_ready_over")
    state_machine.remove("fight_hero_fight_reset_over")
    state_machine.remove("fight_master_into_start")
    state_machine.remove("fight_draw_formation_ui")
    state_machine.remove("fight_draw_ui")
    state_machine.remove("fight_request_battle")
    state_machine.remove("fight_start_fight")
    state_machine.remove("fight_begin_load_assets")
    state_machine.remove("fight_load_assets_end")
    state_machine.remove("fight_attack_round_start")
    state_machine.remove("fight_attack_round_logic_running")
    state_machine.remove("fight_check_next_fight")
    state_machine.remove("fight_check_skeep_fight")
    state_machine.remove("fight_is_over")
    state_machine.remove("fight_exit")
    state_machine.remove("fight_hero_ready_next_fight_over")
    state_machine.remove("fight_hero_next_go")
    state_machine.remove("fight_skeep_fighting")
    state_machine.remove("fight_hero_deathed")
    state_machine.remove("fight_master_deathed")
    state_machine.remove("fight_total_attack_count")
    state_machine.remove("fight_total_round_count")
    state_machine.remove("fight_total_attack_damage")
    state_machine.remove("fight_hero_info_ui_show")
    state_machine.remove("fight_hero_info_ui_show_by_pos")
    state_machine.remove("fight_get_current_fight_type")
    state_machine.remove("fight_get_zoarium_skill_list")
    state_machine.remove("fight_get_zoarium_skill_movers")
    state_machine.remove("fight_first_set_skip_misson")
    state_machine.remove("fight_pet_play_over")
    state_machine.remove("fight_pet_play_master_over")
    state_machine.remove("fight_master_play_pet_ready")
    state_machine.remove("fight_add_bullet")
    state_machine.remove("fight_remove_bullet")
    state_machine.excute("window_lock_swallow_touches", 0, true)

    -- 将攻击过程信息写入文件
    -- if true == app.configJson.fightDebug then
    --     if nil ~= _ED._fightModule then
    --         local file = io.open("fight_debug_info_" .. os.time() .. ".txt", "w+")
    --         for i, v in pairs(_ED._fightModule.debug_info) do
    --             file:write(v)
    --         end
    --     end
    -- end
    

    local currentBattleIndex = _ED.battleData._currentBattleIndex 
    local isWin = _ED.attackData.isWin

    if self._fight_type ~= _enum_fight_type._fight_type_214 then
        _ED.attackData = nil
    end
    if self._fight_type ~= _enum_fight_type._fight_type_219 then
        _ED.attackData = nil
    end
    if self._fight_type ~= _enum_fight_type._fight_type_220 then
        _ED.attackData = nil
    end

    _ED.user_info.battleCache = nil
    _ED._fightModule = nil
    
    attack_logic.__hero_ui_visible = false
    attack_logic.__hero_ui_lock = true
    _ED._battle_wait_change_scene = false
    _ED._battle_pause = false

    _mission_stop_fight_change_scene_action = 0

    -- for i, v in pairs(self._hero_formation) do
    --     if v._armature ~= nil and v._armature._heroInfoWidget ~= nil then
    --         v._armature._heroInfoWidget:removeFromParent(true)
    --     end
    --     v._armature = nil
    --     v:removeAllChildren(true)
    -- end

    -- for i, v in pairs(self._master_formation) do
    --     if v._armature ~= nil and v._armature._heroInfoWidget ~= nil then
    --         v._armature._heroInfoWidget:removeFromParent(true)
    --     end
    --     v._armature = nil
    --     v:removeAllChildren(true)
    -- end
    
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
    -- if self._npc_type == "0" then
        
    -- elseif self._npc_type == "1" then
    --  ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/boss_battle_card.ExportJson")
    -- end
 --    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_head_effect.ExportJson")
 --    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_head_effect_2.ExportJson")
 --    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_head_effect_4.ExportJson")
 --    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/hero_broken_effect.ExportJson")
    -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()

    if isWin == "1" then
        if missionIsOver() == true and _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
            if true == self._is_playback then
            else
                executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, false, nil, false)
            end
            -- _ED.user_info.last_user_grade = _ED.user_info.user_grade
        end

        if self._check_npc_mission == true then
            if missionIsOver() == true then
                if executeMissionExt(mission_mould_tuition, touch_off_mission_battle_over, "".._ED._scene_npc_id.."v"..currentBattleIndex, nil, false, nil, false) == true then

                end
            end
        end
    end

    if (__lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh) and ___is_open_firstCharge == true
        then

         if _ED._fight_is_win == false
            or (_ED.npc_last_state ~= nil and tonumber(self._npc_id) == 7 and tonumber(_ED.npc_last_state[self._npc_id]) == 0)
            then
            _ED._fight_is_win_bool = true
            -- app.load("client.activity.ActivityFirstRechargePopup")
            -- state_machine.excute("activity_first_recharge_popup_open_window", 0, 0)
        end
    end

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        -- --> print("=====",tonumber(self._npc_id) )
        if _ED._fight_is_win == false
            or (_ED.npc_last_state ~= nil and tonumber(self._npc_id) == 7 and tonumber(_ED.npc_last_state[self._npc_id]) == 0)
            then
            _ED._fight_is_win_bool = true
        end        
    end
    if __lua_project_id ==__lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b
        or __lua_project_id == __lua_project_digimon_adventure 
        --or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        then
        if ___is_open_push_info ~= false then
            state_machine.excute("warship_girl_push_info_close",0,"")
        end
    end

    if __lua_project_id == __lua_project_pacific_rim then
        fwin._current_music = 1
        playBgm(formatMusicFile("background", 1))
    end
end
