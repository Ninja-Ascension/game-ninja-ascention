-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗地图
-- ----------------------------------------------------------------------------------------------------
BattleScene = class("BattleSceneClass", Window)

app.load("configs.battle.config")
app.load("configs.sprite.config")
app.load("client.red_alert.battle.report.BattleReport")
app.load("client.red_alert.battle.battle_enum")
app.load("client.red_alert.battle.battle_logic")
app.load("client.red_alert.battle.battle_map")
app.load("client.red_alert.battle.battle_player")
app.load("client.red_alert.battle.battle_role")
app.load("client.red_alert.battle.battle_ui")
app.load("client.red_alert.battle.battle_skill_ui")
app.load("client.red_alert.battle.battle_time_out")
app.load("client.red_alert.battle.battle_win")
app.load("client.red_alert.battle.battle_fail")
app.load("client.red_alert.battle.battle_drop_pos")
app.load("client.red_alert.battle.battle_pvp_skill_control")
app.load("client.red_alert.campaign.soul_duplicate.SoulDuplicateBattleFail")
app.load("client.red_alert.battle.battle_skill_effect")
app.load("client.red_alert.battle.battle_player_skill_effect")
app.load("client.red_alert.battle.battle_role_hp")


-- ZOerder
_scene_zorder_map                               = -2
_scene_zorder_floor_effect                      = -1
_scene_zorder_object                            = 0
_scene_zorder_object_effect_layer               = 100000
_scene_zorder_fly_effect                        = 100001
_scene_zorder_hurt                              = 1000001
_scene_zorder_miss                              = 1000002
_scene_zorder_bullet                            = 1000003
_scene_zorder_effect                            = 1000004
_scene_zorder_drop                              = 1000005

_scene_tag_effect                              = 2000000

-- 战场中站位坐标
___role_coords = {}
___role_coords_status = {}
___role_coords_map = nil

___total_damage = nil

function __resetRoleCoordsStatus()
    for i, v in pairs(___role_coords_status) do
        for j, t in pairs(v) do
            v[j] = nil
        end
    end
end

local battle_scene_window_open_terminal = {
    _name = "battle_scene_window_open",
    _init = function (terminal)
        if _ED._fightModule == nil then
            _ED._fightModule = FightModule:new()
        end
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battleScene = BattleScene:new():init(params)
        fwin:open(_battleScene, fwin._view)
        return _battleScene
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_scene_window_close_terminal = {
    _name = "battle_scene_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleSceneClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_scene_window_open_terminal)
state_machine.add(battle_scene_window_close_terminal)
state_machine.init()

function BattleScene:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ___total_damage = 0
    
    -- var
    self._elapsed = 0
    self._duration = 300
    -- 主公
    self._players = {}
    -- 角色列表
    self._objectList = {}
    -- 子弹列表
    self._bulletList = {}
    self._bulletRemoveList = {}
    -- 攻方角色
    self._attackerTeam = {}
    -- 攻方角色阵型
    self._attackerFormation = {}
    self._attackerFormation_b = {}
    self._attackerFormation7 = {}
    -- 守方角色
    self._defenderTeam = {}
    -- 守方角色阵型
    self._defenderFormation = {}
    self._defenderFormation_b = {}
    self._defenderFormation7 = {}
    -- 死亡角色列表
    self._deatherList = {}
    -- 战斗结束
    self._is_over = false
    -- 战斗结果
    self._is_win = false
    -- 精灵运行状态
    self._is_running = false
    -- 攻击锁屏运行状态
    self._attack_running = false
    -- 锁屏中释放技能角色数量
    self._lock_screen_number = 0
    -- 当前焦点目标
    self._focus = nil
    -- 当前焦点目标数
    self._change_focus_count = 0
    -- 战斗胜利获得的星数
    self.stars = 0
    -- 每几场战斗
    self._battle_index = 1
    -- 技能锁定逻辑
    self._skill_lock_funcs = nil
    -- 技能缓存
    self._effect_cache = {}
    -- 地图上面的坐标系统
    -- 攻击方的坐标系
    self._attacker_coords = {}
    -- 防守方的坐标系
    self._defender_coords = {}
    -- 战斗类型
    self._fight_type = 0
    -- 掉落列表
    self.drop_list = {}

    -- 进入攻击位完毕
    self._attacker_move_into_over = false
    self._byAttacker_move_into_over = false
    -- 战斗结束参数
    self._battle_result_params = ""

    -- 战斗结束
    self._fight_end = false
    -- 战斗等待结束时间
    self._waitOverTime = 0.5
    -- 推迟的暂停
    self._need_pause = false
    -- 援军进入
    self._partner_come_ing = false

    self._cache_buffs = {}

    self._is_show_boss = false
    -- Initialize battle scene state machine.
    local function init_battle_scene_terminal()
        -- 启动场景
        local battle_scene_running_terminal = {
            _name = "battle_scene_running",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:running(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 场景暂停
        local battle_scene_pause_terminal = {
            _name = "battle_scene_pause",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:_pause(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 场景暂停
        local battle_scene_defer_pause_terminal = {
            _name = "battle_scene_defer_pause",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:_defer_pause(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 场景恢复
        local battle_scene_resume_terminal = {
            _name = "battle_scene_resume",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:_resume(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 自动战斗
        local battle_scene_auto_fight_terminal = {
            _name = "battle_scene_auto_fight",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:autoFight(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 开始攻击
        local battle_scene_start_attack_terminal = {
            _name = "battle_scene_start_attack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:startAttack(params[1], params[2])
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 校验开始攻击
        local battle_scene_check_start_attack_terminal = {
            _name = "battle_scene_check_start_attack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:checkStartAttack(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 解锁开始攻击
        local battle_scene_unlock_start_attack_terminal = {
            _name = "battle_scene_unlock_start_attack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:unlockStartAttack(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加载队伍信息
        local battle_scene_load_battle_role_terminal = {
            _name = "battle_scene_load_battle_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("battle_scene_create_attacker_team", 0, instance)
                state_machine.excute("battle_scene_create_defender_team", 0, instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 创建敌我双方主公信息
        local battle_scene_load_battle_master_terminal = {
            _name = "battle_scene_load_battle_master",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:createMaster(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 施放主公技
        local battle_scene_execute_master_skill_terminal = {
            _name = "battle_scene_execute_master_skill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:executeMasterSkill(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加载动画
        local battle_scene_load_effect_terminal = {
            _name = "battle_scene_load_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal._load_objects == nil then
                    terminal._load_objects = {}
                    table.add(terminal._load_objects, instance._attackerTeam)
                    table.add(terminal._load_objects, instance._defenderTeam)
                end
                if #terminal._load_objects > 0 then
                    local cell = table.remove(terminal._load_objects, 1)
                    instance:loadEffectCell(cell)
                    return false
                end

                -- instance:loadEffect(instance._attackerTeam)
                -- instance:loadEffect(instance._defenderTeam)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加载buff
        local battle_scene_load_buff_terminal = {
            _name = "battle_scene_load_buff",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:loadBuff()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加载缓存资源
        local battle_scene_load_cache_terminal = {
            _name = "battle_scene_load_cache",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:loadCache()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 创建攻方队伍信息
        local battle_scene_create_attacker_team_terminal = {
            _name = "battle_scene_create_attacker_team",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local battleScene = params
                battleScene:createAttackerTeams()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 创建守方队伍信息
        local battle_scene_create_defender_team_terminal = {
            _name = "battle_scene_create_defender_team",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local battleScene = params
                battleScene:createDefenderTeams()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 解析战斗数据
        local battle_scene_parser_battle_info_terminal = {
            _name = "battle_scene_parser_battle_info",
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

        -- 更新技能效用数据
        local battle_scene_update_skill_influence_terminal = {
            _name = "battle_scene_update_skill_influence",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateSkillInfluence(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 获得群伤对象
        local battle_scene_range_attack_role_terminal = {
            _name = "battle_scene_range_attack_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local pos = params[1]
                local camp = params[2]
                local range = params[3]
                local type_info = params[4]
                local byAttackerObjects = instance:checkByAttackerRange(pos, range, camp, type_info)
                return byAttackerObjects
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 添加子弹实例
        local battle_scene_add_bullet_terminal = {
            _name = "battle_scene_add_bullet",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                table.insert(instance._bulletList, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 移除子弹实例
        local battle_scene_remove_bullet_terminal = {
            _name = "battle_scene_remove_bullet",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- for i, v in pairs(instance._bulletList) do
                --     if v == params then
                --         local _battleBullet = table.remove(instance._bulletList, i, 1)
                --         state_machine.excute("battle_bullet_delete", 0, _battleBullet)
                --     end
                -- end

                table.insert(instance._bulletRemoveList, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 检测场景对象碰撞
        local battle_scene_check_collision_terminal = {
            _name = "battle_scene_check_collision",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:checkCollision(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 检测场景对象攻击
        local battle_scene_check_attack_terminal = {
            _name = "battle_scene_check_attack",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:checkAttack(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 清除场景中角色的被攻击状态
        local battle_scene_clear_by_attacker_state_terminal = {
            _name = "battle_scene_clear_by_attacker_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:clearByAttackerState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 移除场景中的死亡角色
        local battle_scene_remove_deather_terminal = {
            _name = "battle_scene_remove_deather",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:removeDeather(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 复活场景中的死亡角色
        local battle_scene_review_deather_terminal = {
            _name = "battle_scene_review_deather",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:reviewDeather(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 清除死亡状态的受击对象状态
        local battle_scene_clear_death_state_terminal = {
            _name = "battle_scene_clear_death_state",
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

        -- 攻击阵型换线
        local battle_scene_change_camp_attack_line_terminal = {
            _name = "battle_scene_change_camp_attack_line",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeCampAttackLine(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 锁定攻击者目标
        local battle_scene_lock_attack_terminal = {
            _name = "battle_scene_lock_attack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:lockAttack(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 锁定技能攻击者目标
        local battle_scene_lock_skill_attack_terminal = {
            _name = "battle_scene_lock_skill_attack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:lockSkillAttack(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 获取阵营中心
        local battle_scene_get_camp_center_position_terminal = {
            _name = "battle_scene_get_camp_center_position",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:getCampCenterPosition(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 暂停场景中的动画，支持当前角色的技能的释放
        local battle_scene_attack_pause_terminal = {
            _name = "battle_scene_attack_pause",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:attackPause(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 恢复场景中的动画，支持当前角色的技能的释放
        local battle_scene_attack_resume_terminal = {
            _name = "battle_scene_attack_resume",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:attackResume(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 移动到下一个战斗场景
        local battle_scene_move_to_next_fight_scene_terminal = {
            _name = "battle_scene_move_to_next_fight_scene",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:moveToNextFightScene(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗结束
        local battle_scene_fight_over_terminal = {
            _name = "battle_scene_fight_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:fightOver(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 掉落数据
        local battle_scene_add_drop_item_terminal = {
            _name = "battle_scene_add_drop_item",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                table.insert(instance.drop_list, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 添加执行的事件
        local battle_scene_push_mission_terminal = {
            _name = "battle_scene_push_mission",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:pushMission(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 事件改变攻击状态（首场战斗）
        local battle_scene_mission_change_attacking_state_terminal = {
            _name = "battle_scene_mission_change_attacking_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:missionChangeRoleAttacking(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 给战场中的角色加怒气
        local battle_scene_add_role_power_terminal = {
            _name = "battle_scene_add_role_power",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addRolePower(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 检测队伍是否有近战攻击
        local battle_scene_check_team_have_near_attack_terminal = {
            _name = "battle_scene_check_team_have_near_attack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:checkTeamIsHaveNearAttack(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 攻击方入场完毕，地方进入战斗准备区
        local battle_scene_attack_move_fight_arena_over_terminal = {
            _name = "battle_scene_attack_move_fight_arena_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._attacker_move_into_over = true
                for k,v in pairs(instance._defenderTeam) do
                    v:fristMoveToAttackLine()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 检测所有人进入攻击准备区
        local battle_scene_all_move_fight_arena_over_terminal = {
            _name = "battle_scene_all_move_fight_arena_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local result = true
                for k,v in pairs(instance._attackerFormation) do
                    if v._formation_row == 1 then
                        if v._frsitMoveEnd == false and v._moving == false then
                            result = false
                        end
                    else
                        if v._frsitMoveEnd == true then
                            v._enterFightMoveEnd = true
                        end
                    end
                end
                for k,v in pairs(instance._defenderFormation) do
                    if v._formation_row == 1 then
                        if v._frsitMoveEnd == false and v._moving == false then
                            result = false
                        end
                    else
                        if v._frsitMoveEnd == true then
                            v._enterFightMoveEnd = true
                        end
                    end
                end
                if result == true then
                    state_machine.excute("battle_scene_unlock_start_attack", 0, true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 获取攻击等待CD
        local battle_scene_get_attack_wait_cd_terminal = {
            _name = "battle_scene_get_attack_wait_cd",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:getAttackWaitCD(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 援军开始移动
        local battle_scene_ready_move_partner_terminal = {
            _name = "battle_scene_ready_move_partner",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i, v in pairs(instance._attackerFormation) do
                    if v._isPartner == true and instance._partner_come_ing == false then
                        instance._partner_come_ing = true
                        local effect_paths = "images/ui/effice/effect_yuanjunchuxian/effect_yuanjunchuxian.ExportJson"
                        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
                        
                        local armature = ccs.Armature:create("effect_yuanjunchuxian")
                        draw.initArmature(armature, nil, -1, 0, 1)
                        local function changeActionCallback( armatureBack )
                            armatureBack.target:partnerMoveToFightArena()
                            armatureBack:removeFromParent(true)
                        end
                        armature._invoke = changeActionCallback
                        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                        armature.target = v
                        state_machine.excute("battle_ui_add_partner_effect", 0, armature)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 援军入场移动完毕，开始进入攻击位
        local battle_scene_ready_move_to_fight_arena_terminal = {
            _name = "battle_scene_ready_move_to_fight_arena",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i, v in pairs(instance._attackerFormation) do
                    v:moveToFightReadyArena()
                end
                for k,v in pairs(instance._defenderFormation) do
                    v:moveToFightReadyArena()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示战场中角色的血条信息
        local battle_scene_show_ui_role_name_terminal = {
            _name = "battle_scene_show_ui_role_name",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showUIRoleName()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 检测boss介绍
        local battle_scene_check_boos_introduce_terminal = {
            _name = "battle_scene_check_boos_introduce",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_show_boss == false then
                    if decryptInfo(_ED._fightModule.maxBattleCount) == instance._battle_index then
                        local npc_id = tonumber(_ED._scene_npc_id)
                        if tonumber(_ED.npc_state[npc_id]) == 0 then
                            local boss_id = dms.int(dms["npc"], npc_id, npc.boss_id)
                            if boss_id > 0 then
                                instance._is_show_boss = true
                                state_machine.excute("battle_scene_pause", 0, {})
                                app.load("client.mission.boss.BossIntroduce")
                                state_machine.excute("bossintroduce_open_window", 0, boss_id)
                            end
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_scene_load_other_effect_terminal = {
            _name = "battle_scene_load_other_effect",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if pve_battle_resource ~= nil and pve_battle_resource["".._ED._scene_npc_id] ~= nil then
                    local infos = pve_battle_resource["".._ED._scene_npc_id][1][params]
                    if infos ~= nil then
                        instance:loadOtherEffect(infos, params)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_scene_all_pause_terminal = {
            _name = "battle_scene_all_pause",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:_pauseAll()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(battle_scene_running_terminal)
        state_machine.add(battle_scene_pause_terminal)
        state_machine.add(battle_scene_defer_pause_terminal)
        state_machine.add(battle_scene_resume_terminal)
        state_machine.add(battle_scene_auto_fight_terminal)
        state_machine.add(battle_scene_start_attack_terminal)
        state_machine.add(battle_scene_check_start_attack_terminal)
        state_machine.add(battle_scene_unlock_start_attack_terminal)
        state_machine.add(battle_scene_load_battle_role_terminal)
        state_machine.add(battle_scene_load_battle_master_terminal)
        state_machine.add(battle_scene_execute_master_skill_terminal)
        state_machine.add(battle_scene_load_effect_terminal)
        state_machine.add(battle_scene_load_buff_terminal)
        state_machine.add(battle_scene_load_cache_terminal)
        state_machine.add(battle_scene_create_attacker_team_terminal)
        state_machine.add(battle_scene_create_defender_team_terminal)
        state_machine.add(battle_scene_parser_battle_info_terminal)
        state_machine.add(battle_scene_update_skill_influence_terminal)
        state_machine.add(battle_scene_range_attack_role_terminal)       
        state_machine.add(battle_scene_add_bullet_terminal)
        state_machine.add(battle_scene_remove_bullet_terminal)
        state_machine.add(battle_scene_check_collision_terminal)
        state_machine.add(battle_scene_check_attack_terminal)
        state_machine.add(battle_scene_clear_by_attacker_state_terminal)
        state_machine.add(battle_scene_remove_deather_terminal)
        state_machine.add(battle_scene_review_deather_terminal)
        state_machine.add(battle_scene_clear_death_state_terminal)
        state_machine.add(battle_scene_change_camp_attack_line_terminal)
        state_machine.add(battle_scene_lock_attack_terminal)
        state_machine.add(battle_scene_lock_skill_attack_terminal)
        state_machine.add(battle_scene_get_camp_center_position_terminal)
        state_machine.add(battle_scene_attack_pause_terminal)
        state_machine.add(battle_scene_attack_resume_terminal)
        state_machine.add(battle_scene_move_to_next_fight_scene_terminal)
        state_machine.add(battle_scene_fight_over_terminal)
        state_machine.add(battle_scene_add_drop_item_terminal)
        state_machine.add(battle_scene_push_mission_terminal)
        state_machine.add(battle_scene_mission_change_attacking_state_terminal)
        state_machine.add(battle_scene_add_role_power_terminal)
        state_machine.add(battle_scene_check_team_have_near_attack_terminal)
        state_machine.add(battle_scene_attack_move_fight_arena_over_terminal)
        state_machine.add(battle_scene_all_move_fight_arena_over_terminal)
        state_machine.add(battle_scene_get_attack_wait_cd_terminal)
        state_machine.add(battle_scene_ready_move_partner_terminal)
        state_machine.add(battle_scene_ready_move_to_fight_arena_terminal)
        state_machine.add(battle_scene_show_ui_role_name_terminal)
        state_machine.add(battle_scene_check_boos_introduce_terminal)
        state_machine.add(battle_scene_load_other_effect_terminal)
        state_machine.add(battle_scene_all_pause_terminal)
        state_machine.init()
    end

    -- call func init battle scene state machine.
    init_battle_scene_terminal()
end

function BattleScene:init(params)
    -- 绘制地图信息
    self._fight_type = params

    _ED.npcLastState = tonumber(_ED.npc_state[zstring.tonumber(_ED._scene_npc_id)])

    -- state_machine.excute("battle_map_window_open", 0, {self})
    -- state_machine.excute("battle_skill_ui_window_open",0,{self})
    -- state_machine.excute("battle_ui_window_open",0,{self})
    -- state_machine.excute("battle_drop_pos_create",0,{self})
    -- if checkPvpBattleType(self._fight_type) == true then
    --     state_machine.excute("battle_pvp_skill_control_open", 0, 0)
    -- end
    -- -- state_machine.excute("battle_scene_create_attacker_team", 0, self)
    -- -- state_machine.excute("battle_scene_create_defender_team", 0, self)

    -- -- ------------------------------------------------------
    -- -- 加载角色坐标系统
    -- -- Panel_role_0_1           我方初始位
    -- -- Panel_role_1             回合中角色复位位
    -- -- Panel_role_attack_1      我方攻击位
    -- -- Panel_role_round_1       我方切场位
    -- -- Panel_role_enemy_1       敌方初始位
    -- -- Panel_enemy_attack_1     敌方攻击位
    -- local csbBattleMapRole = csb.createNode(config_csb.battle.battle_map_role)
    -- local csbBattleMapRoleRoot = csbBattleMapRole:getChildByName("root")
    -- local function addCoord(root, coords, exName)
    --     local coord = {}
    --     for i = 1, 9 do
    --         local target = ccui.Helper:seekWidgetByName(root, exName .. i)
    --         local pos = cc.p(target:getPosition())
    --         table.insert(coord, pos)
    --     end
    --     table.insert(coords, coord)
    -- end
    -- addCoord(csbBattleMapRoleRoot, self._attacker_coords, "Panel_role_0_")
    -- addCoord(csbBattleMapRoleRoot, self._attacker_coords, "Panel_role_attack_")
    -- addCoord(csbBattleMapRoleRoot, self._attacker_coords, "Panel_role_")
    -- addCoord(csbBattleMapRoleRoot, self._attacker_coords, "Panel_role_round_")
    -- addCoord(csbBattleMapRoleRoot, self._defender_coords , "Panel_role_enemy_")
    -- addCoord(csbBattleMapRoleRoot, self._defender_coords, "Panel_enemy_attack_")

    if #___role_coords == 0 then
        -- local csbBattleMapRole = csb.createNode(config_csb.battle.battle_map_role)
        -- local csbBattleMapRoleRoot = csbBattleMapRole:getChildByName("root")
        for row = 1, 32 do
            local coord = {}
            local status = {}
            for col = 1, 7 do
                -- local target = ccui.Helper:seekWidgetByName(csbBattleMapRoleRoot, "Panel_role_" .. row .. "_" .. col)
                -- local pos = cc.p(target:getPosition())
                -- table.insert(coord, pos)
                -- status[col] = nil
                local target = battle_move_info[row][col]
                local pos = cc.p(target[1], target[2])
                table.insert(coord, pos)
                status[col] = nil
            end
            table.insert(___role_coords, coord)
            table.insert(___role_coords_status, status)
        end
        ___role_coords_map = cc.Pathfinding:create(7, 32, 1, 1)
        ___role_coords_map:retain()
    else
        __resetRoleCoordsStatus()
    end
    return self
end

function BattleScene:startMission()
    if tonumber(_ED.npc_state[tonumber(_ED._scene_npc_id)]) <= 0 then
        if executeMissionExt(mission_mould_battle, touch_off_mission_start_battle, "".._ED._scene_npc_id.."v"..self._battle_index, nil) == true then
            executeNextEvent(nil, true)
        end
    end
end

function BattleScene:missionChangeRoleAttacking(params)
    local attackerCamp = tonumber(params[1])
    local attackerFormationIndex = tonumber(params[2])
    local objects = attackerCamp == 0 and self._attackerFormation or self._defenderFormation
    local object = objects[attackerFormationIndex]
    if object ~= nil then
        object._attacking = false
    end
end

function BattleScene:pushMission(missionEvent)
    local executeType = missionEvent[1]
    local attackerCamp = missionEvent[2]
    local attackerFormationIndex = missionEvent[3]
    local attackCount = missionEvent[4]
    local adderCamp = missionEvent[5]
    local adderFormationIndex = missionEvent[6]
    local addValue = missionEvent[7]
    local objects = attackerCamp == 0 and self._attackerFormation or self._defenderFormation
    local object = objects[attackerFormationIndex]
    assert(object ~= nil, "push mission didn't exist : object is nil ")
    object._event = {execute_type = executeType, attack_count = attackCount, adder_camp = adderCamp, adder_formation_index = adderFormationIndex, add_value = addValue}
    -- state_machine.excute("battle_ui_change_show_state", 0, true)
    if executeType == execute_type_add_role_power then
        -- print("把我的怒气加满", self._shipName)
        state_machine.excute("battle_scene_add_role_power", 0, object._event)
        object._event = nil
        executeNextEvent(nil, nil)
    elseif executeType == execute_type_role_change then
        state_machine.excute("battle_role_change_sprite", 0, {object, attackCount})
        object._event = nil
        executeNextEvent(nil, nil)
    elseif executeType == execute_type_role_remove then
        local deather = object
        local camp = attackerCamp
        local tobjects = camp == 0 and self._attackerTeam or self._defenderTeam
        for i, v in pairs(tobjects) do
            if v == deather then
                table.remove(tobjects, i, 1)
                break
            end
        end
        object:setVisible(false)
        object._death = true
        object._event = nil
        executeNextEvent(nil, nil)
    elseif executeType == execute_type_role_add then
        local tobjects = camp == 0 and self._attackerTeam or self._defenderTeam
        table.insert(tobjects, object)
        object:setVisible(true)
        object._death = false
        object._event = nil
        executeNextEvent(nil, nil)
    end
end


function BattleScene:addRolePower(missionEvent)
    if missionEvent.adder_formation_index == 0 then
        state_machine.excute("battle_ui_update_player_sp", 0, missionEvent.add_value)
        return
    end
    local objects = missionEvent.adder_camp == 0 and self._attackerFormation or self._defenderFormation
    local object = objects[missionEvent.adder_formation_index]
    assert(object ~= nil, "in animation didn't exist")
    object._sp = encryptInfo(decryptInfo(object._sp) + missionEvent.add_value)
    state_machine.excute("battle_ui_update_role_sp", 0, {role = object, shipId = object._shipMouldId, sp = decryptInfo(object._sp), maxSp = decryptInfo(object._max_sp), showSpEffect = true})
end

function BattleScene:running(params)
    self._is_running = true
    self._attack_running = true

    cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_he.png")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_he.plist")

    state_machine.excute("battle_ui_update_time", 0, self._duration - self._elapsed)

    self:startMission()

    -- cc.Director:getInstance():getScheduler():setTimeScale(1.2)
end

function BattleScene:_pause(params)
    self._is_running = false
    self:pause()
    self:rolePause(params)
    state_machine.excute("battle_map_pause_all_effect", 0, nil)
end

function BattleScene:_pauseAll()
    self._is_running = false
    self:pause()
    self._change_focus_count = self._change_focus_count + 1

    self._attack_running = false
    for i, v in pairs(self._attackerTeam) do
        v:onPause({mustPause = true})
    end

    for i, v in pairs(self._defenderTeam) do
        v:onPause({mustPause = true})
    end

    state_machine.excute("battle_map_pause_all_effect", 0, nil)
end

function BattleScene:_defer_pause(params)
    self._need_pause = true
end

function BattleScene:_resume(params)
    self._is_running = true
    self._need_pause = false
    self:resume()
    self:attackResume()
    state_machine.excute("battle_map_resume_all_effect", 0, nil)
end

function BattleScene:autoFight(params)
    local auto = params
    for i, v in pairs(self._attackerFormation) do
        v._is_auto = auto
        v._is_skill = auto
    end
end

function BattleScene:startAttack(attacker, attacked)
    -- local attacker = params
    local smAttacker = nil
    for i, v in pairs(self._attackerTeam) do
        if v._range <= 100 then
            smAttacker = v
            break
        end
    end

    local seAttacker = nil
    for i, v in pairs(self._defenderTeam) do
        if v._range <= 100 then
            seAttacker = v
            break
        end
    end

    if nil ~= smAttacker
        then
        if attacker._camp == 0 
            and attacker._range <= 100
            then
            if attacked == true then
                for i, v in pairs(self._attackerTeam) do
                    v._run_state = v._enum_run_state._run
                    v._move_state = v._enum_move_state._moving
                end

                for i, v in pairs(self._defenderTeam) do
                    v._run_state = v._enum_run_state._run
                    v._move_state = v._enum_move_state._moving
                end
            end
            return true
        end
        return false
    end

    if nil ~= seAttacker
        then
        if attacker._camp == 1 
            and attacker._range <= 100
            then
            if attacked == true then
                for i, v in pairs(self._attackerTeam) do
                    v._run_state = v._enum_run_state._run
                    v._move_state = v._enum_move_state._moving
                end

                for i, v in pairs(self._defenderTeam) do
                    v._run_state = v._enum_run_state._run
                    v._move_state = v._enum_move_state._moving
                end
            end
            return true
        end
        return false
    end

    if nil == smAttacker and nil == seAttacker then
        if attacker._range > 100
            then
            if attacked == true then
                for i, v in pairs(self._attackerTeam) do
                    v._run_state = v._enum_run_state._run
                    v._move_state = v._enum_move_state._moving
                end

                for i, v in pairs(self._defenderTeam) do
                    v._run_state = v._enum_run_state._run
                    v._move_state = v._enum_move_state._moving
                end
            end
            return true
        end
    end
    return false
end

function BattleScene:checkStartAttack(camp)
    -- for i, v in pairs(self._attackerTeam) do
    --     if v._run_state ~= v._enum_run_state._lock_attack then
    --         return false
    --     end
    -- end

    -- for i, v in pairs(self._defenderTeam) do
    --     if v._run_state ~= v._enum_run_state._lock_attack then
    --         return false
    --     end
    -- end

    -- for i, v in pairs(self._attackerTeam) do
    --     v._run_state = v._enum_run_state._run
    --     v._move_state = v._enum_move_state._moving
    --     v._start_attack = true
    -- end

    -- for i, v in pairs(self._defenderTeam) do
    --     v._run_state = v._enum_run_state._run
    --     v._move_state = v._enum_move_state._moving
    --     v._start_attack = true
    -- end

    local unlockCampAttack = true
    for i, v in pairs(self._attackerFormation) do
        if v._formation_row == 1 and v._range <= 2 and v._isPartner ~= true then
            unlockCampAttack = false
            if v._run_state == v._enum_run_state._lock_attack then
                return false
            end
        end
    end

    if (true == unlockCampAttack and 0 == camp) or 1 == camp then
        if 1 == camp then
            for i, v in pairs(self._defenderFormation) do
                if v._formation_row == 1 and v._range <= 2 and v._isPartner ~= true then
                    if v._run_state == v._enum_run_state._lock_attack then
                        return false
                    end
                end
            end
        else
            return false
        end
    end
    
    for i, v in pairs(self._attackerFormation) do
        v._run_state = v._enum_run_state._run
        v._move_state = v._enum_move_state._moving
        v._start_attack = true
    end

    for i, v in pairs(self._defenderFormation) do
        v._run_state = v._enum_run_state._run
        v._move_state = v._enum_move_state._moving
        v._start_attack = true
    end
    return true
end

function BattleScene:unlockStartAttack(params)
    for i, v in pairs(self._attackerTeam) do
        v._run_state = v._enum_run_state._run
        v._move_state = v._enum_move_state._moving
        if params ~= nil and params == true and v._enterFightMoveEnd == false then
            v._start_attack = true
        end
    end

    for i, v in pairs(self._defenderTeam) do
        v._run_state = v._enum_run_state._run
        v._move_state = v._enum_move_state._moving
        if params ~= nil and params == true and v._enterFightMoveEnd == false  then
            v._start_attack = true
        end
    end
    return true
end

function BattleScene:loadEffectCell(role)
    for m, n in pairs(role._skills) do
        local baseName = nil
        if zstring.tonumber(n.bullet) > 0 and self._effect_cache[""..n.bullet] == nil then
            baseName = "effect/bullet_" .. n.bullet
            -- print(baseName)
            local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
            skeletonNode:retain()
            self._effect_cache[""..n.bullet] = skeletonNode
        end

        if zstring.tonumber(n.effect) > 0 and self._effect_cache[""..n.effect] == nil then
            baseName = "effect/effect_" .. n.effect
            -- print(baseName)
            local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
            skeletonNode:retain()
            self._effect_cache[""..n.effect] = skeletonNode
        end

        if zstring.tonumber(n.floor_effect) > 0 and self._effect_cache[""..n.floor_effect] == nil then
            baseName = "effect/effect_" .. n.floor_effect
            -- print(baseName)
            local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
            skeletonNode:retain()
            self._effect_cache[""..n.floor_effect] = skeletonNode
        end

        if zstring.tonumber(n.fly_effect) > 0 and self._effect_cache[""..n.fly_effect] == nil then
            baseName = "effect/effect_" .. n.fly_effect
            -- print(baseName)
            local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
            skeletonNode:retain()
            self._effect_cache[""..n.fly_effect] = skeletonNode
        end

        if zstring.tonumber(n.bear_lighting_effect_id) > 0 and self._effect_cache[""..n.bear_lighting_effect_id] == nil then
            baseName = "effect/effect_" .. n.bear_lighting_effect_id
            -- print(baseName)
            local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
            skeletonNode:retain()
            self._effect_cache[""..n.bear_lighting_effect_id] = skeletonNode
        end
    end

    if #role._team > 0 then
        self:loadEffectCell(role._team[1])
    end
end

function BattleScene:loadOtherEffect(infos, index)
    for m, n in pairs(infos) do
        local baseName = nil
        if index == 1 then
            if zstring.tonumber(n) > 0 and self._effect_cache[""..n] == nil then
                baseName = "effect/bullet_" .. n
                print(baseName)
                local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
                skeletonNode:retain()
                self._effect_cache[""..n] = skeletonNode
            end
        else
            if zstring.tonumber(n) > 0 and self._effect_cache[""..n] == nil then
                baseName = "effect/effect_" .. n
                print(baseName)
                local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
                skeletonNode:retain()
                self._effect_cache[""..n] = skeletonNode
            end
        end
    end
end

function BattleScene:loadBuff()
    for k,v in pairs(self._cache_buffs) do
        if tonumber(v) > 0 and self._effect_cache[""..v] == nil then
            local baseName = "effect/buff_" .. v
            if cc.FileUtils:getInstance():isFileExist(baseName) == true then
                local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
                skeletonNode:retain()
                self._effect_cache[""..v] = skeletonNode
            end
        end
    end
end

function BattleScene:loadCache()
    cacher.addTextures(config_res.images_cached["battle_scene"])
    for i, v in pairs(config_res.spines_cached["battle_scene"]) do
        local skeletonNode = sp.spine(v[1], v[2], 1, 0, nil, false, nil)
        skeletonNode:retain()
        self._effect_cache[""..v[1]] = skeletonNode
    end
    for i, v in pairs(config_res.armatures_cached["battle_scene"]) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
    end
end

function BattleScene:loadEffect(roles)
    -- print("------------------------------------------------------------")
    for i, v in pairs(roles) do
        self:loadEffectCell(v)
    end
    -- print("------------------------------------------------------------")
end

function BattleScene:onEnterTransitionFinish()
    
end

function BattleScene:onExit()
    local effect_paths = "images/ui/effice/effect_yuanjunchuxian/effect_yuanjunchuxian.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    for i, v in pairs(config_res.armatures_cached["battle_scene"]) do
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v)
    end
    for i, v in pairs(self._effect_cache) do
        v:release()
    end
    cacher.removeTextureForKeys(config_res.images_cached["battle_scene"])
    state_machine.remove("battle_scene_running")
    state_machine.remove("battle_scene_pause")
    state_machine.remove("battle_scene_defer_pause")
    state_machine.remove("battle_scene_resume")
    state_machine.remove("battle_scene_auto_fight")
    state_machine.remove("battle_scene_start_attack")
    state_machine.remove("battle_scene_check_start_attack")
    state_machine.remove("battle_scene_unlock_start_attack")
    state_machine.remove("battle_scene_load_battle_role")
    state_machine.remove("battle_scene_load_effect")
    state_machine.remove("battle_scene_load_buff")
    state_machine.remove("battle_scene_load_cache")
    state_machine.remove("battle_scene_load_battle_master")
    state_machine.remove("battle_scene_execute_master_skill")
    state_machine.remove("battle_scene_create_attacker_team")
    state_machine.remove("battle_scene_create_defender_team")
    state_machine.remove("battle_scene_parser_battle_info")
    state_machine.remove("battle_scene_update_skill_influence")
    state_machine.remove("battle_scene_range_attack_role") 
    state_machine.remove("battle_scene_add_bullet")
    state_machine.remove("battle_scene_remove_bullet")
    state_machine.remove("battle_scene_check_collision")
    state_machine.remove("battle_scene_check_attack")
    state_machine.remove("battle_scene_clear_by_attacker_state")
    state_machine.remove("battle_scene_remove_deather")
    state_machine.remove("battle_scene_review_deather")
    state_machine.remove("battle_scene_clear_death_state")
    state_machine.remove("battle_scene_change_camp_attack_line")
    state_machine.remove("battle_scene_lock_attack")
    state_machine.remove("battle_scene_lock_skill_attack")
    state_machine.remove("battle_scene_get_camp_center_position")
    state_machine.remove("battle_scene_attack_pause")
    state_machine.remove("battle_scene_attack_resume")
    state_machine.remove("battle_scene_move_to_next_fight_scene")
    state_machine.remove("battle_scene_fight_over")
    state_machine.remove("battle_scene_add_drop_item")
    state_machine.remove("battle_scene_push_mission")
    state_machine.remove("battle_scene_mission_change_attacking_state")
    state_machine.remove("battle_scene_add_role_power")
    state_machine.remove("battle_scene_check_team_have_near_attack")
    state_machine.remove("battle_scene_attack_move_fight_arena_over")
    state_machine.remove("battle_scene_all_move_fight_arena_over")
    state_machine.remove("battle_scene_get_attack_wait_cd")
    state_machine.remove("battle_scene_ready_move_partner")
    state_machine.remove("battle_scene_ready_move_to_fight_arena")
    state_machine.remove("battle_scene_show_ui_role_name")
    state_machine.remove("battle_scene_check_boos_introduce")
    state_machine.remove("battle_scene_load_other_effect")
    state_machine.remove("battle_scene_all_pause")
end

-- 定时器1.处理时间到 2.遍历fightrole 战斗定时器
function BattleScene:onUpdate(dt)
    if self._fight_end == true then
        self._waitOverTime = self._waitOverTime - dt
        if self._waitOverTime <= 0 then
            self._fight_end = false
            state_machine.excute("battle_scene_fight_over", 0, 0)
        end
    end

    if self._is_running == false then
        return
    end

    -- 时间已到
    if self._is_over ~= true then
        self._elapsed = self._elapsed + dt
        if self._elapsed >= self._duration then
            self:unregisterOnNoteUpdate(self)
            state_machine.excute("battle_scene_pause", 0, nil)
            if _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
                self._is_win = false
                self:fightOver()
            else
                state_machine.excute("battle_fail_window_open", 0, 0)
            end
            return
        end
    end
    -- 
    state_machine.excute("battle_ui_update_time", 0, self._duration - self._elapsed)

    for i, v in pairs(self._bulletList) do
        if v ~= nil and v.onUpdate ~= nil then
            v:onUpdate(dt)
        end
    end
    
    if #self._bulletRemoveList > 0 then
        for i, v in pairs(self._bulletRemoveList) do
            for j, h in pairs(self._bulletList) do
                if v == h then
                    local _battleBullet = table.remove(self._bulletList, j, 1)
                    state_machine.excute("battle_bullet_delete", 0, _battleBullet)
                    break
                end
            end
        end
        self._bulletRemoveList = {nil}
    end

    if self._attack_running == false then
        return
    end

    if self._need_pause == true then
        self._need_pause = false
        self:_pause({forcing = true})
    end

    -- 结束战斗逻辑
    if self._is_over ~= true then
        local minx = 100000000
        local miny = 100000000
        local maxx = 0
        local maxy = 0
        for i, v in pairs(self._attackerTeam) do
            v:onUpdate(dt)
            if v._death == false 
                and v._hero_type == v._enum_hero_type._hero
                then
                local x = v._move_pos.x
                if x < minx then
                    minx = x
                end
                if x > maxx then
                    maxx = x
                end

                local y = v._move_pos.y
                if y < miny then
                    miny = y
                end
                if y > maxy then
                    maxy = y
                end
            end
        end
        
        for i, v in pairs(self._defenderTeam) do
            v:onUpdate(dt)
            if v._death == false 
                and v._hero_type == v._enum_hero_type._hero
                then
                local x = v._move_pos.x
                if x < minx then
                    minx = x
                end
                if x > maxx then
                    maxx = x
                end

                local y = v._move_pos.y
                if y < miny then
                    miny = y
                end
                if y > maxy then
                    maxy = y
                end
            end
        end

        local attackerCount = #self._attackerTeam
        local defenderCount = #self._defenderTeam

        local moveMapState = true
        for k,v in pairs(self._attackerTeam) do
            if v._hero_type == v._enum_hero_type._hero and v._is_running ~= true then
                moveMapState = false
            end
        end
        if moveMapState == true then
            for k,v in pairs(self._defenderTeam) do
                if v._hero_type == v._enum_hero_type._hero and v._is_running ~= true then
                    moveMapState = false
                end
            end
        end

        if moveMapState == true then
            -- defenderCount > 0 then
            state_machine.excute("battle_map_move_to_camp_center", 0, {x = (minx + (maxx - minx) / 2), y = (miny + (maxy - miny) / 2), time = 0, v = 0.15, s = 1.6, stop_actions = defenderCount == 0})
        end

        if attackerCount == 0 
            or defenderCount == 0 
            then
            self._is_over = true
            local aCount = #self._attackerTeam
            self._is_win = ((aCount > 0) and true or false)

            self:resetPlayerAndRoleInfo()
            if self._is_win == true 
                and _ED._fightModule:initNewBattleInfo() == true 
                then
                -- self._is_over = false
                self._is_win = false
                self._battle_index = self._battle_index + 1
                state_machine.excute("battle_scene_move_to_next_fight_scene", 0, 0)
            else
                local winTeam = (self._is_win == true and self._attackerTeam or self._defenderTeam)
                for i, v in pairs(winTeam) do
                    v:onSleep(dt)
                    if v._camp == 0 then
                        state_machine.excute("battle_ui_update_role_reset", 0, {role = v, shipId = v._shipMouldId, hp = v._hp, maxHp = v._max_hp, sp = decryptInfo(v._sp), maxSp = decryptInfo(v._max_sp), showSpEffect = true})
                    end
                end
                self._fight_end = true
            end
        end
    end
end

-- 检测碰撞框 暂时没用到
function BattleScene:checkCollision(params)
    for i, v in pairs(self._attackerTeam) do
        local collision, obstacle = v:checkCollisionRect(params)
        if collision == true then
            return collision, obstacle
        end
    end
    for i, v in pairs(self._defenderTeam) do
        local collision, obstacle = v:checkCollisionRect(params)
        if collision == true then
            return collision, obstacle
        end
    end
    return false, nil
end

-- 更新已经有的技术数据
function BattleScene:updateSkillInfluence(params)
    local camp = params[1]
    local skill = params[2]
    local skillInfluenceId = params[3]
    skill.other = {}
    skill.buffs = {}
    skill.influences = {}
    self:addSkillData(0, skill, skill.skill_element, skillInfluenceId)
end

-- 群体伤害
function BattleScene:checkByAttackerRange(pos, range, camp, type_info)
    local objects = camp == 1 and  self._defenderFormation or self._attackerFormation
    local byAttackObjects = {}
    -- 受击对象
    for i, v in pairs(objects) do
        local ret = v:checkByAttackerRange(pos, range, type_info)
        -- print("oooooooooooooooooooooooooooo",ret)
        if ret == true then
            table.insert(byAttackObjects, v)
        end
    end 
    if byAttackObjects == {} then
        byAttackObjects = nil
    end
    return byAttackObjects
end

function BattleScene:checkAttack(params)
    local attacker = params[1]
    local camp = params[2]
    local objects = camp == 1 and self._attackerTeam or self._defenderTeam
    local defs = {}
    for i, v in pairs(objects) do
        local ret, space = v:checkByAttack(attacker)
        if ret == true then
            table.insert(defs, {v, space})
        end
    end
    local def = defs[1]
    for i, v in pairs(defs) do
        if v[2] < def[2] then
            def = v
        end
    end
    if def ~= nil then
        return def[1], def[2]
    end
    return nil, nil
end

function BattleScene:changeCampAttackLine(params)
    local role = params.role
    local camp = params.camp
    local mcount = params.mcount
    local coord_y = params.coord_y

    for i = 1, 7 do
        if ___role_coords_status[coord_y][i] ~= nil then
            return
        end
    end

    local flag = 1
    if camp == 0 then
        flag = -1
    end

    local row = 0
    local trow = coord_y + flag
    while (trow > 0 and trow < 31) do
        for i = 1, 7 do
            if ___role_coords_status[trow][i] ~= nil then
                row = trow
                trow = 100
                break
            end
        end
        trow = trow + flag
    end

    if row ~= 0 then
        local attackerRow = 0
        local defenderRow = 0
        if camp == 0 then
            attackerRow = row
            defenderRow = row + 1
        else
            attackerRow = row - 1
            defenderRow = row
        end

        for i, v in pairs(self._attackerFormation) do
            v._attack_coord_y = attackerRow
        end

        for i, v in pairs(self._defenderFormation) do
            v._attack_coord_y = defenderRow
        end
    end
end

function BattleScene:lockAttack(params)
    -- 根据阵型位置来寻找目标 7 * 3
    local attacker = params[1]
    local camp = params[2]
    if attacker._hero ~= nil 
        and attacker._hero._byLockAttackTarget ~= nil 
        and attacker._hero._byLockAttackTarget._death == false
        then
        return attacker._hero._byLockAttackTarget, nil, nil
    else
        if attacker._hero_type == attacker._enum_hero_type._dogface then
            attacker._coord_y = attacker._hero._coord_y
            attacker._coord_x = attacker._hero._coord_x
        end
        local objects = camp == 1 and self._attackerFormation or self._defenderFormation
        local row = 0
        local tobjects = {nil}
        for i, v in pairs(objects) do
            local trow = v._formation_row
            if row == 0 
                or row > trow
                then
                if v._death == false
                    then
                    row = trow
                end
            end
        end
        for i, v in pairs(objects) do
            local trow = v._formation_row
            if row == 0 
                or row == trow
                then
                if v._death == false
                    -- and table.nums(v._team) > 0 
                    then
                    tobjects[v._formation_column] = v
                    row = trow
                end
            end
        end
        -- local column = attacker._formation_column
        local column = 0
        if attacker._hero ~= nil 
            then
            column = attacker._hero._formation_column
        else
            -- column = math.floor((attacker._coord_x - 1) / 3) + 1
            column = math.floor((attacker._coord_x) / 2)
        end

        local defender = tobjects[column]
        if defender == nil then
            for i = 1, 3 do
                local tdefender = tobjects[column - i]
                if tdefender ~= nil then
                    -- break
                    if defender == nil then
                        defender = tdefender
                    else
                        if math.abs(defender._coord_x - attacker._coord_x) > math.abs(tdefender._coord_x - attacker._coord_x) then
                            defender = tdefender
                        elseif tdefender._by_lock == false then
                            defender = tdefender
                        end
                    end
                end

                tdefender = tobjects[column + i]
                if tdefender ~= nil then
                    -- break
                    if defender == nil then
                        defender = tdefender
                    else
                        if math.abs(defender._coord_x - attacker._coord_x) > math.abs(tdefender._coord_x - attacker._coord_x) then
                            defender = tdefender
                        elseif tdefender._by_lock == false then
                            defender = tdefender
                        end
                    end
                end
            end
        end

        if defender ~= nil then
            for i, v in pairs(tobjects) do
                if nil ~= v then
                    if v._range <= 2 
                        and defender._range > 2
                        then
                        defender = v
                    end
                end
            end
        end
        
        -- if defender == nil then
        --     debug.print_r(tobjects)
        -- end

        -- print("defender:", defender, defender._camp, defender._sprite_id, defender._formation_row, defender._formation_column, attacker._formation_row, attacker._formation_column)

        -- local object = defender
        -- if object ~= nil 
        --     and defender._death == true
        --     then
        --     for i = 1, 3 do
        --         object = defender._team[3 - i + 1]
        --         if object ~= nil then
        --             break
        --         end
        --     end
        -- end
        -- return object, nil, nil

        return defender, nil, nil
    end

    -- -- 根据阵型位置来寻找目标
    -- local attacker = params[1]
    -- local camp = params[2]
    -- if attacker._hero ~= nil 
    --     and attacker._hero._byLockAttackTarget ~= nil 
    --     and attacker._hero._byLockAttackTarget._death == false
    --     then
    --     return attacker._hero._byLockAttackTarget, nil, nil
    -- else
    --     local objects = camp == 1 and self._attackerFormation or self._defenderFormation
    --     local row = 0
    --     local tobjects = {nil}
    --     for i, v in pairs(objects) do
    --         local trow = v._formation_row
    --         if row == 0 
    --             or row == trow
    --             then
    --             if v._death == false
    --                 or table.nums(v._team) > 0 
    --                 then
    --                 tobjects[v._formation_column] = v
    --                 row = trow
    --             end
    --         end
    --     end

    --     local defender = tobjects[attacker._formation_column]
    --     if defender == nil then
    --         for i = 1, 3 do
    --             defender = tobjects[attacker._formation_column - i]
    --             if defender ~= nil then
    --                 break
    --             end
    --             defender = tobjects[attacker._formation_column + i]
    --             if defender ~= nil then
    --                 break
    --             end
    --         end
    --     end
        
    --     -- print("defender:", defender, defender._camp, defender._sprite_id, defender._formation_row, defender._formation_column, attacker._formation_row, attacker._formation_column)

    --     local object = defender
    --     if object ~= nil 
    --         and defender._death == true
    --         then
    --         for i = 1, 3 do
    --             object = defender._team[3 - i + 1]
    --             if object ~= nil then
    --                 break
    --             end
    --         end
    --     end
    --     return object, nil, nil
    -- end

    -- -- 根据距离来寻找目标
    -- local attacker = params[1]
    
    -- if attacker._hero ~= nil 
    --     -- and attacker._hero._byLockAttackTarget ~= nil 
    --     -- and attacker._hero._byLockAttackTarget._death == false
    --     then
    --     return attacker._hero._byLockAttackTarget, nil, nil
    -- end

    -- local camp = params[2]
    -- local objects = camp == 1 and self._attackerTeam or self._defenderTeam
    -- local defs = {nil}
    -- local defsa = {{nil},{nil},{nil}}
    -- local defsa1 = {{nil},{nil},{nil}}
    -- for i, v in pairs(objects) do
    --     local ret, space, mspace = v:lockByAttack(attacker)
    --     if ret == true then
    --         -- local index = math.modf((v._formation_index - 1) / 3 + 1)
    --         local index = 1
    --         if v._hero == nil then
    --             table.insert(defsa1[index], {v, space, mspace})
    --         else
    --             table.insert(defsa[index], {v, space, mspace})
    --         end
    --     end
    -- end
    -- for i = 1, 3 do
    --     if #defsa1[i] > 0 then
    --         defs = defsa1[i]
    --         break
    --     end
    --     if #defsa[i] > 0 then
    --         defs = defsa[i]
    --         break
    --     end
    -- end
    -- local def = defs[1]
    -- for i, v in pairs(defs) do
    --     if v[2] < def[2] then
    --         def = v
    --     end
    -- end

    -- if def ~= nil then
    --     return def[1], def[2], def[3]
    -- end

    -- return nil, nil, nil
end

function BattleScene:lockSkillAttack(params)
    local funcs = self._skill_lock_funcs or {
        --  0 单体
        ["0"] = function (params)
            -->>print("0")
            local attacker = params[1]
            return true, {attacker._byAttackTarget}
        end,
        --  1 自己
        ["1"] = function (params)
            -->>print("1")
            local attacker = params[1]
            attacker._byAttackTarget = attacker
            attacker._byLockAttackTarget = attacker
            return true, {attacker}
        end,
        --  2 后排单体
        ["2"] = function (params)
            -->>print("2")
            local attacker = params[1]
            local skill = params[3]
            -- local objects = skill.influence_group == 0 and self._attackerFormation_b or self._defenderFormation_b
            -- local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            -- local targets = {}
            -- for i = 1, 3 do
            --     local index = (3 - i) * 3
            --     local object = objects[index + attacker._formation_column_b]
            --     if object ~= nil and object._death == false then
            --         object = objects[index + (attacker._formation_column_b - 1 + 1) % 3 + 1]
            --     end
            --     if object ~= nil and object._death == false then
            --         object = objects[index + (attacker._formation_column_b - 1 + 2) % 3 + 1]
            --     end
            --     if object ~= nil and object._death == false then
            --         attacker._byAttackTarget = object
            --         attacker._byLockAttackTarget = object
            --         table.insert(targets, object)
            --         break
            --     end
            -- end

            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local target = nil
            -- local mx, my = attacker:getPosition()
            local mx, my = attacker._coord_x, attacker._coord_y
            for i, v in pairs(objects) do
                -- local tx, ty = v:getPosition()
                local tx, ty = v._coord_x, v._coord_y
                if v._death == false then
                    if target == nil then
                        target = v
                    else
                        if attacker._camp == 0 then
                            if ty > target._coord_y 
                                or (ty == target._coord_y and tx < target._coord_x) 
                                then
                                target = v
                            end
                        else
                            if ty < target._coord_y 
                                or (ty == target._coord_y and tx < target._coord_x) 
                                then
                                target = v
                            end
                        end
                    end
                end
                -- v._lmt_x = math.abs(tx - mx)
                -- v._lmt_y = math.abs(ty - my)
                -- if target == nil then
                --     target = v
                -- else
                --     if v._lmt_x > target._lmt_x 
                --         or (v._lmt_x == target._lmt_x and v._lmt_y > target._lmt_y)
                --         then
                --         target = v
                --     end
                -- end
            end
            if target ~= nil then
                table.insert(targets, target)
            end
            return true, targets
        end,
        --  3 一列
        ["3"] = function (params)
            -- -->>print("3")
            -- local attacker = params[1]
            -- local skill = params[3]
            -- -- local objects = skill.influence_group == 0 and self._attackerFormation_b or self._defenderFormation_b
            -- local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            -- local targets = {}
            -- for i = 1, 3 do
            --     local index = (attacker._formation_column_b + (i - 1) - 1) % 3 + 1
            --     local object = objects[index]
            --     if object ~= nil and object._death == false then
            --         table.insert(targets, object)
            --     end

            --     object = objects[index + 3]
            --     if object ~= nil and object._death == false then
            --         table.insert(targets, object)
            --     end

            --     object = objects[index + 6]
            --     if object ~= nil and object._death == false then
            --         table.insert(targets, object)
            --     end
            -- end
            -- return targets
        end,
        --  4 前排
        ["4"] = function (params)
            -->>print("4")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation_b or self._defenderFormation_b
            local targets = {}
            for i = 1, 3 do
                -- local index = (i - 1) * 3
                -- local object = objects[index + attacker._formation_column_b]
                -- if object ~= nil and object._death == false then
                --     table.insert(targets, object)
                -- end
                
                -- object = objects[index + (attacker._formation_column_b - 1 + 1) % 3 + 1]
                -- if object ~= nil and object._death == false then
                --     table.insert(targets, object)
                -- end
                
                -- object = objects[index + (attacker._formation_column_b - 1 + 2) % 3 + 1]
                -- if object ~= nil and object._death == false then
                --     table.insert(targets, object)
                -- end

                local tobjects = objects[i]
                if tobjects ~= nil and #tobjects > 0 then
                    for n, m in pairs(tobjects) do
                        local object = m
                        if object ~= nil and object._death == false then
                            table.insert(targets, object)
                        end
                    end
                    if #targets > 0 then
                        local object = targets[1]
                        attacker._byAttackTarget = object
                        attacker._byLockAttackTarget = object
                        break
                    end
                end
            end
            return false, targets
        end,
        --  5 后排
        ["5"] = function (params)
            -->>print("5")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation_b or self._defenderFormation_b
            local targets = {}
            local mi = 3
            for i = 7, 9 do
                -- local index = (3 - i) * 3
                -- local object = objects[index + attacker._formation_column_b]
                -- if object ~= nil and object._death == false then
                --     table.insert(targets, object)
                -- end
                
                -- object = objects[index + (attacker._formation_column_b - 1 + 1) % 3 + 1]
                -- if object ~= nil and object._death == false then
                --     table.insert(targets, object)
                -- end
                
                -- object = objects[index + (attacker._formation_column_b - 1 + 2) % 3 + 1]
                -- if object ~= nil and object._death == false then
                --     table.insert(targets, object)
                -- end

                local index = ((mi - 1) % 3 + 1)
                mi = mi + 1
                local tobjects = objects[i]
                if tobjects ~= nil and #tobjects > 0 then
                    for n, m in pairs(tobjects) do
                        local object = m
                        if object ~= nil and object._death == false then
                            table.insert(targets, object)
                        end
                    end
                end
                if #targets > 0 then
                    local object = targets[1]
                    attacker._byAttackTarget = object
                    attacker._byLockAttackTarget = object
                    break
                end
            end
            return false, targets
        end,
        --  6 全体
        ["6"] = function (params)
            -->>print("6")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            if skill.influence_group == 3 then
                objects = self._attackerFormation
            end
            local targets = {}
            -->>print("attacker:", skill.influence_group)
            for i, v in pairs(objects) do
                if v ~= nil and v._death == false then
                    if (skill.influence_group ~= 3 
                        or (skill.influence_group == 3 and v ~= attacker))
                        and (skill.befor_influence_group == nil or (zstring.tonumber(skill.befor_influence_group) == 3 and v ~= attacker))
                        then
                        table.insert(targets, v)
                    end
                end
            end
            if #targets > 0 and attacker._byLockAttackTarget == nil 
                then
                local object = targets[1]
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
        --  7 血最多的1个
        ["7"] = function (params)
            -->>print("7")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    if object == nil 
                        or object._hp < v._hp
                        then
                        object = v
                    end
                end
            end
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
                table.insert(targets, object)
            end
            return false, targets
        end,
        --  8 血最少的1个
        ["8"] = function (params)
            -->>print("8")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            if skill.influence_group == 3 then
                objects = self._attackerFormation
            end
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil 
                    and v._death == false 
                    then
                    if object == nil 
                        or object._hp > v._hp
                        then
                        if skill.influence_group ~= 3 or
                            (skill.influence_group == 3 and v ~= attacker) 
                            then
                            object = v
                        end
                    end
                end
            end
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
                table.insert(targets, object)
            end
            return false, targets
        end,
        --  9 随机1个
        ["9"] = function (params)
            -- print("9")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            if skill.influence_group == 3 or skill.influence_group == 4 then
                objects = self._attackerFormation
            end
            local targets = {}
            local object = nil
            if skill.influence_group == 4 then
                for i, v in pairs(objects) do
                    if v ~= nil 
                        and v._death == true 
                        then
                        table.insert(targets, v)
                    end
                end
            else
                for i, v in pairs(objects) do
                    if v ~= nil 
                        and v._death == false 
                        then
                        if skill.influence_group ~= 3 or
                            (skill.influence_group == 3 and v ~= attacker) 
                            then
                            table.insert(targets, v)
                        end
                        -- table.insert(targets, v)
                    end
                end
            end
            local count = #targets
            if count > 0 then
                object = targets[math.random(1, count)]
                targets = {}
                if object ~= nil then
                    attacker._byAttackTarget = object
                    attacker._byLockAttackTarget = object
                    table.insert(targets, object)
                end
            end
            return false, targets
        end,
        -- 10 随机2个
        ["10"] = function (params)
            -->>print("10")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil 
                    and v._death == false 
                    then
                    table.insert(targets, v)
                end
            end
            local count = #targets
            if count > 0 then
                local rtargets = {}
                local rcount = math.min(2, count)
                for i=1, rcount do
                    local rIdx = math.random(1, count)
                    object = targets[rIdx]
                    table.remove(targets, rIdx, 1)
                    table.insert(rtargets, object)
                    count = #targets
                end
                targets = rtargets
                if object ~= nil then
                    attacker._byAttackTarget = object
                    attacker._byLockAttackTarget = object
                end
            end
            return false, targets
        end,
        -- 11 随机3个
        ["11"] = function (params)
            -->>print("11")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil 
                    and v._death == false 
                    then
                    table.insert(targets, v)
                end
            end
            local count = #targets
            -- -->>print("count:", count, #objects)
            if count > 0 then
                local rtargets = {}
                local rcount = math.min(3, count)
                for i=1, rcount do
                    local rIdx = math.random(1, count)
                    object = targets[rIdx]
                    table.remove(targets, rIdx, 1)
                    table.insert(rtargets, object)
                    count = #targets
                end
                targets = rtargets
                if object ~= nil then
                    attacker._byAttackTarget = object
                    attacker._byLockAttackTarget = object
                end
            end
            -- -->>print("随便选3个：", #targets)
            return false, targets
        end,
        -- 12 十字
        ["12"] = function (params)
            -->>print("12")
        end,
        -- 13 怒气最高的1个
        ["13"] = function (params)
            -->>print("13")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    if object == nil 
                        or decryptInfo(object._sp) < decryptInfo(v._sp)
                        then
                        object = v
                    end
                end
            end
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
                table.insert(targets, object)
            end
            return false, targets
        end,
        -- 14 血最少的3个
        ["14"] = function (params)
            -->>print("14")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    table.insert(targets, v)
                end
            end
            
            table.sort(targets, function(a, b)
                return a._hp < b._hp
            end)

            local count = #targets
            if count > 3 then
                for i = 4, count do
                    table.remove(targets, #targets)
                end
            end
            
            object = targets[1]
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
        -- 15 血量低于60%的全部
        ["15"] = function (params)
            -->>print("15")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    local rt = v._hp_rt
                    if rt < 0.6 then
                        table.insert(targets, v)
                    end
                end
            end

            object = targets[1]
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
        -- 16 中后排目标
        ["16"] = function (params)
            -->>print("16")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation_b or self._defenderFormation_b
            local targets = {}
            local mi = 2
            local miCount = 0
            for i = 1, 3 do
                -- local index = ((mi - 1) % 3 + 1) * 3
                -- mi = mi + 1
                -- local object = objects[index + attacker._formation_column_b]
                -- if object ~= nil and object._death == false then
                --     object = objects[index + (attacker._formation_column_b - 1 + 1) % 3 + 1]
                -- end
                -- if object ~= nil and object._death == false then
                --     object = objects[index + (attacker._formation_column_b - 1 + 2) % 3 + 1]
                -- end
                -- if object ~= nil and object._death == false then
                --     attacker._byAttackTarget = object
                --     attacker._byLockAttackTarget = object
                --     table.insert(targets, object)
                --     break
                -- end

                local index = ((mi - 1) % 3 + 1)
                mi = mi + 1
                local tobjects = objects[index]
                if tobjects ~= nil and #tobjects > 0 then
                    for n, m in pairs(tobjects) do
                        local object = m
                        if object ~= nil and object._death == false then
                            table.insert(targets, object)
                        end
                    end
                    miCount = miCount + 1
                end
                if #targets > 0 and miCount == 1 then
                    local object = targets[1]
                    attacker._byAttackTarget = object
                    attacker._byLockAttackTarget = object
                end
                if miCount == 2 then
                    break
                end
            end
            return false, targets
        end,
        -- 17 随机4个
        ["17"] = function (params)
            -->>print("17")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil 
                    and v._death == false 
                    then
                    table.insert(targets, v)
                end
            end
            local count = #targets
            if count > 0 then
                local rtargets = {}
                local rcount = math.min(4, count)
                for i=1, rcount do
                    local rIdx = math.random(1, count)
                    object = targets[rIdx]
                    table.remove(targets, rIdx, 1)
                    table.insert(rtargets, object)
                    count = #targets
                end
                targets = rtargets
                if object ~= nil then
                    attacker._byAttackTarget = object
                    attacker._byLockAttackTarget = object
                end
            end
            return false, targets
        end,
        -- 18 随机5个
        ["18"] = function (params)
            -->>print("18")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil 
                    and v._death == false 
                    then
                    table.insert(targets, v)
                end
            end
            local count = #targets
            if count > 0 then
                local rtargets = {}
                local rcount = math.min(5, count)
                for i=1, rcount do
                    local rIdx = math.random(1, count)
                    object = targets[rIdx]
                    table.remove(targets, rIdx, 1)
                    table.insert(rtargets, object)
                    count = #targets
                end
                targets = rtargets
                if object ~= nil then
                    attacker._byAttackTarget = object
                    attacker._byLockAttackTarget = object
                end
            end
            return false, targets
        end,
        -- 19 血量最少的2个
        ["19"] = function (params)
            -->>print("19")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            if skill.influence_group == 3 then
                objects = self._attackerFormation
            end
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    if skill.influence_group ~= 3 or
                        (skill.influence_group == 3 and v ~= attacker) 
                        then
                        table.insert(targets, v)
                    end
                    -- table.insert(targets, v)
                end
            end
            
            table.sort(targets, function(a, b)
                return a._hp < b._hp
            end)

            local count = #targets
            if count > 2 then
                for i = 3, count do
                    table.remove(targets, #targets)
                end
            end
            
            object = targets[1]
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
        -- 20 血量最少的3个
        ["20"] = function (params)
            -->>print("20")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            if skill.influence_group == 3 then
                objects = self._attackerFormation
            end
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    if skill.influence_group ~= 3 or
                        (skill.influence_group == 3 and v ~= attacker) 
                        then
                        table.insert(targets, v)
                    end
                end
            end
            
            table.sort(targets, function(a, b)
                return a._hp < b._hp
            end)

            local count = #targets
            if count > 3 then
                for i = 4, count do
                    table.remove(targets, #targets)
                end
            end
            
            object = targets[1]
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
        -- 21 血量最少的4个
        ["21"] = function (params)
            -->>print("21")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    table.insert(targets, v)
                end
            end
            
            table.sort(targets, function(a, b)
                return a._hp < b._hp
            end)

            local count = #targets
            if count > 4 then
                for i = 5, count do
                    table.remove(targets, #targets)
                end
            end
            
            object = targets[1]
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
        -- 22 血量百分比最少的1个
        ["22"] = function (params)
            -->>print("22")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            if skill.influence_group == 3 then
                objects = self._attackerFormation
            end
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    if skill.influence_group ~= 3 or
                        (skill.influence_group == 3 and v ~= attacker) 
                        then
                        if object == nil 
                            or object._hp_rt > v._hp_rt
                            then
                            object = v
                        end
                    end
                end
            end

            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
                table.insert(targets, object)
            end
            return false, targets
        end,
        -- 23 血量百分比最少的2个
        ["23"] = function (params)
            -->>print("23")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    table.insert(targets, v)
                end
            end
            
            table.sort(targets, function(a, b)
                return a._hp_rt < b._hp_rt
            end)

            local count = #targets
            if count > 2 then
                for i = 3, count do
                    table.remove(targets, #targets)
                end
            end
            
            object = targets[1]
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
        -- 24 血量百分比最少的3个
        ["24"] = function (params)
            -->>print("24")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    table.insert(targets, v)
                end
            end
            
            table.sort(targets, function(a, b)
                return a._hp_rt < b._hp_rt
            end)

            local count = #targets
            if count > 3 then
                for i = 4, count do
                    table.remove(targets, #targets)
                end
            end
            
            object = targets[1]
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
        -- 25 血量百分比最少的4个
        ["25"] = function (params)
            -->>print("25")
            local attacker = params[1]
            local skill = params[3]
            local objects = skill.influence_group == 0 and self._attackerFormation or self._defenderFormation
            local targets = {}
            local object = nil
            for i, v in pairs(objects) do
                if v ~= nil
                    and v._death == false
                    then
                    table.insert(targets, v)
                end
            end
            
            table.sort(targets, function(a, b)
                return a._hp_rt < b._hp_rt
            end)

            local count = #targets
            if count > 4 then
                for i = 5, count do
                    table.remove(targets, #targets)
                end
            end
            
            object = targets[1]
            if object ~= nil then
                attacker._byAttackTarget = object
                attacker._byLockAttackTarget = object
            end
            return false, targets
        end,
    }
    local skill = params[3]
    local influence_range = skill.influence_range
    -- print("******:", params[1]._shipName, influence_range, skill.id)
    local func = funcs["" .. influence_range]
    return func(params)
end

function BattleScene:getCampCenterPosition(params)
    local camp = params[1]
    local objects = params[2]
    if objects == nil or table.nums(objects) then
        objects = camp == 0 and self._attackerFormation or self._defenderFormation
    end
    local lx = 10000000
    local ly = 10000000
    local rx = -10000000
    local ry = -10000000
    for i, v in pairs(objects) do
        if v._move_pos.x <= lx then
            lx = v._move_pos.x
        end
        if v._move_pos.x >= rx then
            rx = v._move_pos.x
        end
        if v._move_pos.y <= ly then
            ly = v._move_pos.y
        end
        if v._move_pos.y >= ry then
            ry = v._move_pos.y
        end
    end
    return cc.p(lx + (rx - lx) / 2, ly + (ry - ly) / 2)
end

function BattleScene:clearByAttackerState(params)
    local byAttacker = params[1]
    for i, v in pairs(self._attackerTeam) do
        state_machine.excute("battle_role_clear_by_attacker_state", 0, {v, byAttacker})
    end
    for i, v in pairs(self._defenderTeam) do
        state_machine.excute("battle_role_clear_by_attacker_state", 0, {v, byAttacker})
    end
end

function BattleScene:removeDeather(params)
    local deather = params[1]
    local camp = params[2]
    if camp == 0 then
        for k,v in pairs(self._attackerTeam) do
            if v == deather then
                table.insert(self._deatherList, v)
                table.remove(self._attackerTeam, k, 1)
            end
        end
    else
        for k,v in pairs(self._defenderTeam) do
            if v == deather then
                table.insert(self._deatherList, v)
                table.remove(self._defenderTeam, k, 1)
            end
        end
    end
end

function BattleScene:reviewDeather(params)
    local deather = params[1]
    local camp = params[2]
    local objects = camp == 0 and self._attackerTeam or self._defenderTeam
    for i, v in pairs(self._deatherList) do
        if v == deather then
            if camp == 0 then 
                table.insert(self._attackerTeam, v)
            else
                table.insert(self._defenderTeam, v)
            end
            table.remove(self._deatherList, i, 1)
            break
        end
    end
end

function BattleScene:createMaster()
    local player0 = state_machine.excute("battle_role_create_master", 0, {self, 0, zstring.tonumber(_ED.user_info.user_gender)})
    local player1 = state_machine.excute("battle_role_create_master", 0, {self, 1, 1})
    table.insert(self._players, player0)
    table.insert(self._players, player1)

    local majesty_info = _ED.majesty_info
    if self._fight_type == battle_enum._fight_type._fight_type_20 then
        majesty_info = {"13", "0", "0", "0"}
    end
    for i,v in pairs(majesty_info) do
        if zstring.tonumber(v) ~= 0 then
            local skillId = dms.int(dms["majesty_skill"], v, majesty_skill.to_skill_id)
            local skills = {}
            local skill_mould_element = dms.element(dms["skill_mould"], skillId)
            local talent_skill_inflence_index = dms.atos(skill_mould_element, skill_mould.health_affect)
            self:addSkillData(0, skills, skill_mould_element, talent_skill_inflence_index)
            local result = {_skills = skills, _team = {}}
            self:loadEffectCell(result)
        end
    end
end

function BattleScene:executeMasterSkill(params)
    local camp = params[1]
    local majestyId = params[2]
    local skillId = dms.int(dms["majesty_skill"], majestyId, majesty_skill.to_skill_id)

    local skills = {}
    local skill_mould_element = dms.element(dms["skill_mould"], skillId)
    local talent_skill_inflence_index = dms.atos(skill_mould_element, skill_mould.health_affect)
    self:addSkillData(camp, skills, skill_mould_element, talent_skill_inflence_index)

    state_machine.excute("battle_role_execute_master_skill", 0, {self._players[camp + 1], skills[1]})
end

function BattleScene:createHero(index, camp, sprite_id, sprite_type, hero_x, hero_y, size, hero_range, hero_bullet, hero_effect, hero_skills, hero_battle_object, hero)
    -- 英雄角色坐标
    local fix_start_pos = nil
    local fix_over_pos = nil

    local moveByPostion = cc.pSub(battle_enum._init_move_pos_fix[index], battle_enum._init_pos[index])
    -- 根据阵营调整坐标
    if camp == 0 then
        -- fix_start_pos = cc.p(hero_x + 200 , hero_y )
        fix_start_pos = cc.p(hero_x, hero_y )
        -- fix_over_pos = cc.p(fwin._width - hero_x, hero_y)
        -- fix_over_pos = cc.p(fix_start_pos.x + moveByPostion.x, fix_start_pos.y + moveByPostion.y)
        fix_over_pos = cc.p(fix_start_pos.x + moveByPostion.x, fix_start_pos.y)
    elseif camp == 1 then
        -- fix_start_pos = cc.p(fwin._width - app.baseOffsetX - hero_x - 200 , hero_y )
        fix_start_pos = cc.p((fwin._width - app.baseOffsetX) * self._battle_index - hero_x, hero_y )
        -- fix_over_pos = cc.p(hero_x, hero_y)
        -- fix_over_pos = cc.p(fix_start_pos.x - moveByPostion.x, fix_start_pos.y - moveByPostion.y)
        fix_over_pos = cc.p(fix_start_pos.x - moveByPostion.x, fix_start_pos.y)

    end

    local row = math.modf((index - 1) / 3 + 1)
    local column = (index -  1) % 3 + 1

    -- 改成斜45度度的地图，重新定义坐标
    local fix_attack_position = nil
    local fix_reset_position = nil
    local fix_round_position = nil
    local fix_coord_x = 0
    local fix_coord_y = 0
    local fix_attack_coord_x = 0
    local fix_attack_coord_y = 0
    if camp == 0 then
        -- fix_start_pos = self._attacker_coords[1][index]
        -- fix_attack_position = self._attacker_coords[2][index]
        -- fix_reset_position = self._attacker_coords[3][index]
        -- fix_round_position = self._attacker_coords[4][index]
        -- fix_over_pos = fix_round_position
        fix_start_pos           = ___role_coords[battle_enum._fix_start_pos[row][1]][column * 2]
        fix_attack_position     = ___role_coords[battle_enum._fix_attack_position[row][1]][column * 2]
        fix_reset_position      = ___role_coords[battle_enum._fix_reset_position[row][1]][column * 2]
        fix_round_position      = ___role_coords[battle_enum._fix_round_position[row][1]][column * 2]
        
        -- fix_start_pos           = ___role_coords[7 - row * 2][column * 2]
        -- fix_attack_position     = ___role_coords[17 - row * 2][column * 2]
        -- fix_reset_position      = ___role_coords[28 - row][column * 2]
        -- fix_round_position      = ___role_coords[32 - row][column * 2]
        fix_over_pos            = fix_round_position

        fix_coord_x = column * 2
        fix_coord_y = battle_enum._fix_attack_position[row][1]

        fix_attack_coord_x = column * 2
        fix_attack_coord_y = 16
    else
        -- fix_start_pos = self._defender_coords[1][index]
        -- fix_attack_position = self._defender_coords[2][index]
        -- fix_over_pos = fix_attack_position

        fix_start_pos           = ___role_coords[battle_enum._fix_start_pos[row][2]][column * 2]
        fix_attack_position     = ___role_coords[battle_enum._fix_attack_position[row][2]][column * 2]
        -- fix_start_pos           = ___role_coords[25 + row * 2][column * 2]
        -- fix_attack_position     = ___role_coords[16 + row * 2][column * 2]
        fix_over_pos            = ___role_coords[1][column * 2]

        fix_coord_x = column * 2
        fix_coord_y = battle_enum._fix_attack_position[row][2]

        fix_attack_coord_x = column * 2
        fix_attack_coord_y = 17
    end

    if hero_battle_object.isPartner then
        local formation_type = dms.string(dms["formation_mould"], tonumber(_ED.formetion[1]), formation_mould.position)
        local formation = zstring.split(formation_type, ",")
        local fightCount = 0
        for idx = 1, 6 do
            local ship_id = _ED.formetion[idx + 1]
            if tonumber(ship_id) > 0 and _ED.user_ship[ship_id] ~= nil then
                fightCount = fightCount + 1
            end
        end

        local partner_info = {}
        local capacity = dms.int(dms["ship_mould"], tonumber(hero_battle_object.shipMould), ship_mould.capacity)
        if capacity <= 3 then
            capacity = 1
        elseif capacity > 3 and capacity <= 6 then
            capacity = 2
        else
            capacity = 3
        end
        local posY = battle_enum._fix_attack_position[capacity][1]
        local posX = 0
        if capacity == 1 then
            for i=1,fightCount do
                if tonumber(formation[i]) == 1 then
                    posX = 3
                    break
                else
                    posX = 2
                end
            end
        else
            for i=1,fightCount do
                if tonumber(formation[i]) == capacity * 3 then
                    posX = 5
                    break
                else
                    posX = 6
                end
            end
        end

        fix_start_pos           = ___role_coords[battle_enum._partner_start_position[1]][battle_enum._partner_start_position[2]]
        fix_attack_position     = ___role_coords[battle_enum._fix_attack_position[capacity][1]][posX]
        fix_reset_position      = ___role_coords[battle_enum._fix_reset_position[capacity][1]][posX]
        fix_round_position      = ___role_coords[battle_enum._fix_round_position[capacity][1]][posX]

        fix_over_pos            = fix_round_position

        fix_coord_x = posX
        fix_coord_y = battle_enum._fix_attack_position[capacity][1]

        fix_attack_coord_x = posX
        fix_attack_coord_y = 16
    end

    local object = state_machine.excute("battle_role_create", 0, {
            _scene = self, 
            _camp = camp, 
            _sprite_id = sprite_id, 
            _sprite_type = sprite_type, 
            _start_position = fix_start_pos, 
            _over_position = fix_over_pos, 
            _size = size, 
            _hero_range = hero_range, 
            _hero_bullet = hero_bullet, 
            _hero_effect = hero_effect,
            _hero_skills = hero_skills, 
            _hero_battle_object = hero_battle_object,
            _hero = hero,
            _formation_index = index,
            _attack_position = fix_attack_position,
            _reset_position = fix_reset_position,
            _coord_x = fix_coord_x,
            _coord_y = fix_coord_y,
            _attack_coord_x = fix_attack_coord_x,
            _attack_coord_y = fix_attack_coord_y,
        })
    return object
end

function BattleScene:createForce(index, camp, sprite_id, sprite_type, force_x, force_y, size, force_range, force_bullet, force_effect, force_skills, force_battle_object, force)
    -- 小兵修正坐标
    local fix_start_pos = nil
    local fix_over_pos = nil
    local fix_force_x = force_x + battle_enum._init_pos_fix[index].x
    local fix_force_y = force_y + battle_enum._init_pos_fix[index].y
    local moveByPostion = cc.pSub(battle_enum._init_move_pos_fix[index], battle_enum._init_pos[index])
    -- print("ppppppppppppppppppppppppp",fix_force_x)
    -- print("ppppppppppppppppppppppppp",fix_force_y)
    -- 根据阵营调整坐标
    if camp == 0 then
        -- fix_start_pos = cc.p(fix_force_x + 200 , fix_force_y)
        fix_start_pos = cc.p(fix_force_x, fix_force_y)
        -- fix_over_pos = cc.p(fwin._width - fix_force_x, fix_force_y)
        -- fix_over_pos = cc.p(fix_start_pos.x + moveByPostion.x, fix_start_pos.y + moveByPostion.y)
        fix_over_pos = cc.p(fix_start_pos.x + moveByPostion.x, fix_start_pos.y)
    elseif camp == 1 then
        -- fix_start_pos = cc.p(fwin._width - app.baseOffsetX - fix_force_x - 200 ,fix_force_y)
        fix_start_pos = cc.p((fwin._width - app.baseOffsetX) * self._battle_index - fix_force_x, fix_force_y)
        -- fix_over_pos = cc.p(fix_force_x, fix_force_y)
        -- fix_over_pos = cc.p(fix_start_pos.x - moveByPostion.x, fix_start_pos.y - moveByPostion.y)
        fix_over_pos = cc.p(fix_start_pos.x - moveByPostion.x, fix_start_pos.y)
    end

    -- 改成斜45度度的地图，重新定义坐标
    local fix_attack_position = {x = 0, y = 0}
    local fix_reset_position = {x = 0, y = 0}
    local fix_round_position = {x = 0, y = 0}

    local offsetX = battle_enum._follow_move_pos_fix[force._move_dir][index].x
    local offsetY = battle_enum._follow_move_pos_fix[force._move_dir][index].y
    if camp == 0 then
        fix_start_pos.x = force._start_pos.x + offsetX -- + battle_enum._init_pos_fix[index].x
        fix_start_pos.y = force._start_pos.y + offsetY -- + battle_enum._init_pos_fix[index].y

        fix_attack_position.x = force._attack_position.x + offsetX -- + battle_enum._init_pos_fix[index].x
        fix_attack_position.y = force._attack_position.y + offsetY -- + battle_enum._init_pos_fix[index].y

        fix_reset_position.x = force._reset_position.x + offsetX -- + battle_enum._init_pos_fix[index].x
        fix_reset_position.y = force._reset_position.y + offsetY -- + battle_enum._init_pos_fix[index].y

        fix_round_position.x = force._end_pos.x + offsetX -- + battle_enum._init_pos_fix[index].x
        fix_round_position.y = force._end_pos.y + offsetY -- + battle_enum._init_pos_fix[index].y

        fix_over_pos.x = force._end_pos.x + offsetX -- + battle_enum._init_pos_fix[index].x
        fix_over_pos.y = force._end_pos.y + offsetY -- + battle_enum._init_pos_fix[index].y
    else
        fix_start_pos.x = force._start_pos.x + offsetX -- - battle_enum._init_pos_fix[index].x
        fix_start_pos.y = force._start_pos.y + offsetY -- - battle_enum._init_pos_fix[index].y

        fix_attack_position.x = force._attack_position.x + offsetX -- - battle_enum._init_pos_fix[index].x
        fix_attack_position.y = force._attack_position.y + offsetY -- - battle_enum._init_pos_fix[index].y


        fix_over_pos = fix_attack_position
    end
    local object = state_machine.excute("battle_role_create", 0, {
            _scene = self, 
            _camp = camp, 
            _sprite_id = sprite_id, 
            _sprite_type = sprite_type, 
            _start_position = fix_start_pos, 
            _over_position = fix_over_pos, 
            _size = size, 
            _hero_range = force_range, 
            _hero_bullet = force_bullet, 
            _hero_effect = force_effect,
            _hero_skills = force_skills, 
            _hero_battle_object = force_battle_object,
            _hero = force,
            _formation_index = force._formation_index,
            _team_index = index,
            _attack_position = fix_attack_position,
            _reset_position = fix_reset_position,
        })
    return object
end


-- 解析角色技能数据 data:天赋数据
function BattleScene:parserSkillData(camp, commonAttackIndex,data, ship, skillMouldId)
    local skills = {}

    local skillElement = dms.element(dms["skill_mould"], commonAttackIndex)

    -- 普通技能技能效用索引
    local common_attack_skill = dms.atos(skillElement, skill_mould.health_affect)

    -- 解析普通攻击技能
    self:addSkillData(camp, skills, skillElement, common_attack_skill)

    if skillMouldId ~= nil and tonumber(skillMouldId) > 0 then
        local skillElement = dms.element(dms["skill_mould"], skillMouldId)

        common_attack_skill = dms.atos(skillElement, skill_mould.health_affect)

        self:addSkillData(camp, skills, skillElement, common_attack_skill)
    end

    -- 小兵data = nil  英雄才解析天赋到技能
    if data ~= nil then
        if ship then
            for i, v in pairs(ship.talents) do
                if v.is_activited == "1" then
                    local talent_mould_element = dms.element(dms["talent_mould"],v.talent_id)
                    -- 天赋 技能调用数据
                    local skill_mould_index = dms.atoi(talent_mould_element, talent_mould.skill_mould_id)
                    if skill_mould_index ~= -1 then
                        local skill_mould_element = dms.element(dms["skill_mould"], skill_mould_index)
                        local talent_skill_inflence_index = dms.atos(skill_mould_element, skill_mould.health_affect)
                        local skill = self:addSkillData(camp, nil, skill_mould_element, talent_skill_inflence_index)
                        local needAdd = true
                        for m, n in pairs(skills) do
                            if n.base_mould == skill.base_mould
                                and n.skill_level < skill.skill_level
                                then
                                skills[m] = skill
                                needAdd = false
                                break
                            end
                        end
                        if needAdd == true then
                            table.insert(skills, skill)
                            needAdd = false
                        end
                    end
                end
            end
            
            -- 解析神兵技能
            if tonumber(ship.god_weaponry) > 0 then
                local god_weaponry = _ED.god_weaponry_info[""..ship.god_weaponry]
                if god_weaponry ~= nil then
                    local talent_mould_element = dms.element(dms["talent_mould"], god_weaponry.talent_id)
                    -- 天赋 技能调用数据
                    local skill_mould_index = dms.atoi(talent_mould_element, talent_mould.skill_mould_id)
                    if skill_mould_index ~= -1 then
                        local skill_mould_element = dms.element(dms["skill_mould"], skill_mould_index)
                        local talent_skill_inflence_index = dms.atos(skill_mould_element, skill_mould.health_affect)
                        local skill = self:addSkillData(camp, nil, skill_mould_element, talent_skill_inflence_index)
                        local needAdd = true
                        for m, n in pairs(skills) do
                            if n.base_mould == skill.base_mould
                                and n.skill_level < skill.skill_level
                                then
                                skills[m] = skill
                                needAdd = false
                                break
                            end
                        end
                        if needAdd == true then
                            table.insert(skills, skill)
                            needAdd = false
                        end
                    end
                end
            end

            -- 武学突破获得的技能
            if nil ~= ship.skill_grow_up_states and #ship.skill_grow_up_states > 0 then
                local shipSkillGrowUpParam = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.skill_grow_up_param)
                -- debug.print_r(ship)
                -- print(ship.ship_mould_id, shipSkillGrowUpParam)
                shipSkillGrowUpParam = zstring.split(shipSkillGrowUpParam, "|")
                for i, v in pairs(ship.skill_grow_up_states) do
                    local params = zstring.split(shipSkillGrowUpParam[i], ",")
                    local talentId = params[1]
                    local isAlive = v == "1"
                    if isAlive then
                        local talent_mould_element = dms.element(dms["talent_mould"], talentId)
                        -- 天赋 技能调用数据
                        local skill_mould_index = dms.atoi(talent_mould_element, talent_mould.skill_mould_id)
                        if skill_mould_index ~= -1 then
                            local skill_mould_element = dms.element(dms["skill_mould"], skill_mould_index)
                            local talent_skill_inflence_index = dms.atos(skill_mould_element, skill_mould.health_affect)
                            local skill = self:addSkillData(camp, nil, skill_mould_element, talent_skill_inflence_index)
                            local needAdd = true
                            for m, n in pairs(skills) do
                                if n.base_mould == skill.base_mould
                                    and n.skill_level < skill.skill_level
                                    then
                                    skills[m] = skill
                                    needAdd = false
                                    break
                                end
                            end
                            if needAdd == true then
                                table.insert(skills, skill)
                                needAdd = false
                            end
                        end
                    end
                end
            end

            -- 珍兽附带技能
            local horse = _ED.horses[""..ship.rider_horse_id]
            if horse ~= nil then
                local skill_id = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.skill)
                if skill_id > 0 then
                    local skill_mould_element = dms.element(dms["skill_mould"], skill_id)
                    local talent_skill_inflence_index = dms.atos(skill_mould_element, skill_mould.health_affect)
                    local skill = self:addSkillData(camp, nil, skill_mould_element, talent_skill_inflence_index)
                    local needAdd = true
                    for m, n in pairs(skills) do
                        if n.base_mould == skill.base_mould
                            and n.skill_level < skill.skill_level
                            then
                            skills[m] = skill
                            needAdd = false
                            break
                        end
                    end
                    if needAdd == true then
                        table.insert(skills, skill)
                        needAdd = false
                    end
                end
            end
        else
            local table_split_talent_list = zstring.split(data, "|")
            -- 解析天赋中主动技能
            for i,v in pairs(table_split_talent_list) do
                local table_split_talent_info = zstring.split(v,",")
                local talent_mould_index = tonumber(table_split_talent_info[3])
                local talent_mould_element = dms.element(dms["talent_mould"],talent_mould_index)
                
                -- 天赋 技能调用数据
                local skill_mould_index = dms.atoi(talent_mould_element, talent_mould.skill_mould_id)
                -- print("===============================")
                -- print(skill_mould_index)
                if skill_mould_index ~= -1 then
                    local skill_mould_element = dms.element(dms["skill_mould"], skill_mould_index)
                    local talent_skill_inflence_index = dms.atos(skill_mould_element, skill_mould.health_affect)
                    self:addSkillData(camp, skills, skill_mould_element, talent_skill_inflence_index)
                end
            end
        end
    end
    -- print("*******************************")
    -- debug.print_r(skills)
    return skills
end

-- 添加技能数据 子弹等 所有伤害数据都封装在skill中再到 bullet中解析
function BattleScene:addSkillData(camp, skilldata, skillElement, attackTypeSkillInfluenceIds)
    local skill = {other = {}, buffs = {}}
    skill.bullet = -1
    skill.effect = -1
    skill.effect_draw_type = 0
    skill.floor_effect_draw_type = 0
    skill.floor_effect = -1
    skill.fly_effect_draw_type = 0
    skill.fly_effect = -1
    skill.bear_lighting_effect_id = -1

    -- 技能模板数据
    skill.skill_element = skillElement

    local skillProperty = dms.atoi(skillElement, skill_mould.skill_property)
    skill.skill_property = skillProperty

    skill.skill_quality = dms.atoi(skillElement, skill_mould.skill_quality)

    -- 技能基础模板ID
    skill.base_mould = dms.atoi(skillElement, skill_mould.base_mould)

    -- 技能基础等级
    skill.skill_level = dms.atoi(skillElement, skill_mould.skill_level)

    -- 效用是否逐一执行
    skill.seriatim = dms.atoi(skillElement, skill_mould.seriatim)

    -- 技能作用范围
    skill.attack_scope = zstring.split(dms.atos(skillElement, skill_mould.attack_scope), ",")
    skill.attack_scope_xy = cc.p(zstring.tonumber(skill.attack_scope[1]), zstring.tonumber(skill.attack_scope[2]))

    attackTypeSkillInfluenceIds = zstring.split(attackTypeSkillInfluenceIds, ",")
    attackTypeSkillInfluenceId = attackTypeSkillInfluenceIds[1]

    if zstring.tonumber(attackTypeSkillInfluenceId) > 0 then
        self:parserSkillInfluenceData(camp, skill, attackTypeSkillInfluenceId)
    end

    for i=2, #attackTypeSkillInfluenceIds do
        if zstring.tonumber(attackTypeSkillInfluenceIds[i]) > 0 then
            local influence = {}
            self:parserSkillInfluenceData(camp, influence, attackTypeSkillInfluenceIds[i])
            table.insert(skill.other, influence)
        end
    end

    -- buff
    local buffAffectIds = zstring.split(dms.atos(skillElement, skill_mould.buff_affect), ",")
    for i=1, #buffAffectIds do
        if zstring.tonumber(buffAffectIds[i]) > 0 then
            local influence = {}
            self:parserSkillInfluenceData(camp, influence, buffAffectIds[i])
            table.insert(skill.buffs, influence)
        end
    end

    if skilldata ~= nil then
        table.insert(skilldata, skill)
    end
    return skill
end

function BattleScene:parserSkillInfluenceData(camp, skill, killInfluenceId)
    -- 技能效用行数据
    skill.id = zstring.tonumber(killInfluenceId)
    local skill_influence_element = dms.element(dms["skill_influence"], killInfluenceId)
    skill.skill_influence_element = skill_influence_element

    -- 技能作用类型
    skill.skill_influence_type = dms.atoi(skill_influence_element, skill_influence.skill_category)
    
    -- buff特效
    skill.buff_effect = dms.atoi(skill_influence_element, skill_influence.scene_effect)

    self._cache_buffs[""..skill.buff_effect] = skill.buff_effect

    -- 技能影响最大值
    skill.skill_effect_max_value = dms.atof(skill_influence_element, skill_influence.skill_effect_max_value)

    -- 是否安百分比计算，0， 1
    skill.is_rate = dms.atoi(skill_influence_element, skill_influence.is_rate)

    -- 效用的命中率
    skill.addition_effect_probability = dms.atoi(skill_influence_element, skill_influence.addition_effect_probability)

    -- 目标锁定方式
    skill.influence_range = dms.atoi(skill_influence_element, skill_influence.influence_range)

    -- 作用阵营
    skill.influence_group = dms.atoi(skill_influence_element, skill_influence.influence_group)
    if camp == 1 and skill.influence_range ~= 1 then
        skill.befor_influence_group = skill.influence_group
        if skill.influence_group == 1 then
            skill.influence_group = 0
        else
            skill.influence_group = 1
        end
    end

    -- 作用时长
    skill.influence_duration = dms.atoi(skill_influence_element, skill_influence.influence_duration)

    -- 作用周期
    skill.buff_duration = dms.atoi(skill_influence_element, skill_influence.buff_duration)

    -- 叠加次数
    skill.buff_additioal_count = dms.atoi(skill_influence_element, skill_influence.buff_additioal_count)

    -- 光效的绘制方式
    skill.lighting_effect_draw_method = dms.atoi(skill_influence_element, skill_influence.lighting_effect_draw_method)

    -- 子弹属性
    local bullet = dms.atos(skill_influence_element, skill_influence.forepart_lighting_effect_id)
    if bullet ~= "-1" then
        bullet = zstring.split(bullet, "|") -- 100101|1,1;1,1;1,1;1,1;1,1|1 (.|.|是否有拖尾)
        skill.bullet = zstring.tonumber(bullet[1])
        if #bullet > 1 then
            skill.bullet_positions = {}
            local positions = zstring.split(bullet[2], ";")
            local dirs = {
                2, 3, 3, 3, 2
            }
            local index = 1
            for i, v in pairs(positions) do
                local position = zstring.split(v, ",")
                for n=1, dirs[i] do
                    skill.bullet_positions[index] = cc.p(position[1], position[2])
                    index = index + 1
                end
            end
            for n = 1, 11 do
                skill.bullet_positions[index] = cc.p(-1 * skill.bullet_positions[13 - n].x, skill.bullet_positions[13 - n].y)
                index = index + 1
            end
            skill.showStreak = false
            if bullet[3] == "1" then
                skill.showStreak = true
            end
        end
    else
        skill.bullet = zstring.tonumber(bullet)
    end

    -- 子弹类型
    local bullet_type = dms.atoi(skill_influence_element, skill_influence.before_action)
    skill.bullet_type = bullet_type

    -- 子弹速度
    local bullet_speed = dms.atoi(skill_influence_element, skill_influence.influence_bullet_speed)
    skill.bullet_speed = bullet_speed

    -- 碰撞类型
    local bullet_collision_type = 0
    skill.bullet_collision_type = bullet_collision_type

    -- 命中特效的绘制类型
    skill.effect = -1
    skill.effect_draw_type = 0
    skill.floor_effect_draw_type = 0
    skill.floor_effect = -1
    skill.fly_effect_draw_type = 0
    skill.fly_effect = -1

    -- 命中特效属性
    local effectString = dms.atos(skill_influence_element, skill_influence.posterior_lighting_effect_id)
    local effect = zstring.split(effectString, "|")
    local eCount = #effect
    if eCount > 0 then
        local edata = zstring.split(effect[1], ",")
        if #edata > 1 then
            skill.effect_draw_type = zstring.tonumber(edata[1])
            skill.effect = zstring.tonumber(edata[2])
        end

        if eCount > 1 then
            edata = zstring.split(effect[2], ",")
            if #edata > 1 then
                skill.floor_effect_draw_type = zstring.tonumber(edata[1])
                skill.floor_effect = zstring.tonumber(edata[2])
            end
        end

        if eCount > 2 then
            edata = zstring.split(effect[3], ",")
            if #edata > 1 then
                skill.fly_effect_draw_type = zstring.tonumber(edata[1])
                skill.fly_effect = zstring.tonumber(edata[2])
            end
        end
    else
        skill.effect = zstring.tonumber(effectString)
    end

    -- 命中特效循环
    local effect_isloop = 0
    skill.effect_isloop = effect_isloop

    --承受特效
    local bear_effect = dms.atos(skill_influence_element, skill_influence.bear_lighting_effect_id)
    skill.bear_lighting_effect_id = zstring.tonumber(bear_effect)

    -- 效用计算类型
    skill.compute_mode = dms.atoi(skill_influence_element, skill_influence.compute_mode)

    -- 触发的时机
    skill.trigger_timing = dms.atoi(skill_influence_element, skill_influence.trigger_timing)

    -- 触发的值
    skill.trigger_need_value = dms.atos(skill_influence_element, skill_influence.trigger_need_value)

    -- 结束条件
    skill.influence_over_condition = dms.atoi(skill_influence_element, skill_influence.influence_over_condition)
    skill.influence_over_need_param = dms.atoi(skill_influence_element, skill_influence.influence_over_need_param)

    -- 技能音效
    local sound_effect_ids = zstring.split(dms.atos(skill_influence_element, skill_influence.forepart_lighting_sound_effect_id), ",")
    skill.forepart_lighting_sound_effect_id = zstring.tonumber(sound_effect_ids[1])
    skill.posterior_lighting_sound_effect_id = dms.atoi(skill_influence_element, skill_influence.posterior_lighting_sound_effect_id)
    skill.bear_sound_effect_id = dms.atoi(skill_influence_element, skill_influence.bear_sound_effect_id)
    skill.start_ani_sound_effect_id = zstring.tonumber(sound_effect_ids[2])

    -- 本效用触发的其他效用
    local additionInfluenceString = dms.atos(skill_influence_element, skill_influence.trigger_influence_id)
    if additionInfluenceString ~= "-1" then
        local additionInfluences = zstring.split(additionInfluenceString, ",")
        if #additionInfluences > 0 then
            skill.influences = skill.influences or {}
            for i, v in pairs(additionInfluences) do
                local influence = {}
                self:parserSkillInfluenceData(camp, influence, v)
                table.insert(skill.influences, influence)
            end
        end
    end
end

function BattleScene:initBattleTeamInfo(camp_info, fightModule_data)
    -- 阵营数据 0 - 攻击方 1 - 防守方
    local camp = camp_info
    -- size
    local size = self:getContentSize()

    -- 生成角色战斗数据
    for i,v in pairs(fightModule_data) do
        if zstring.tonumber(v.shipMould) ~= 0 then
            -- ship模板行数据     
            local ship_mould_element = dms.element(dms["ship_mould"], zstring.tonumber(v.shipMould))

            -- ship模板对应ship force id
            local ship_force_mould_index = dms.atoi(ship_mould_element, ship_mould.base_mould2)

            -- ship force行数据
            local ship_force_mould_element = dms.element(dms["ship_force_mould"], ship_force_mould_index)
            -- 阵型索引
            local init_formation_index = v.coordinate --tonumber(i)
            
            -- 角色坐标
            -- local x = dms.int(dms["battle_init_pos"], table_formation[init_formation_index], battle_init_pos.x)
            -- local y = dms.int(dms["battle_init_pos"], table_formation[init_formation_index], battle_init_pos.y)
            local x = battle_enum._init_pos[init_formation_index].x
            -- print("///////////////////////////x",x)
            local y = battle_enum._init_pos[init_formation_index].y
            -- print("///////////////////////////y",y)

            -- 英雄sprite绘制id   
            local sprite_id = v.sprite_id--dms.atoi(ship_mould_element, ship_mould.ship_pic)    

            -- sprite type
            local sprite_type = 0
            -- 攻击距离 
            local range = dms.atoi(ship_force_mould_element, ship_force_mould.attack_range) 

            -- 英雄技能数据
            local skills = nil

            -- 普攻索引
            local commonAttackIndex = v.common_skill_mould--dms.atoi(ship_mould_element, ship_mould.skill_mould)
            -- 英雄模板对应天赋索引列表 
            local talent_mould_index_list = v.talent_mould_index_list
            if self._fight_type == battle_enum._fight_type._fight_type_20 then
                talent_mould_index_list = dms.atos(ship_mould_element, ship_mould.talent_id)
            end
            -- 解析生成英雄技能数据
            if camp == 0 then 
                if v.isPartner == true then
                    skills = self:parserSkillData(camp, commonAttackIndex, talent_mould_index_list, nil, v.special_skill_mould)
                else
                    skills = self:parserSkillData(camp, commonAttackIndex, talent_mould_index_list, _ED.user_ship[v.id])
                end
            else
                if checkPvpBattleType(self._fight_type) == true then
                    skills = self:parserSkillData(camp, commonAttackIndex, talent_mould_index_list, _ED.other_user_info.ship_list[v.id])
                else
                    skills = self:parserSkillData(camp, v.common_skill_mould,nil,nil,v.special_skill_mould)
                end
            end
            -- 废弃数据 暂时用作读取血量和攻击
            -- local bullet = 0
            -- local effect = 0
            -- local bullet = v.healthPoint
            -- local effect = v.attack

            -- 生成英雄
            local hero = self:createHero(init_formation_index, camp, sprite_id, sprite_type, x, y, size, range, bullet, effect, skills, v)
            -- 
            local capacity = v.capacity--dms.atoi(ship_mould_element, ship_mould.capacity)
            local row = math.modf((capacity - 1) / 3 + 1)
            hero._formation_row_b = row

            hero._formation_column_b = (capacity -  1) % 3 + 1

            if camp == 0 then 
                table.insert(self._attackerTeam, hero)
                self._attackerFormation[init_formation_index] = hero
                assert(row >= 1 and row <= 3, "self._attackerFormation_b[" .. row .. "] didn't exist")
                self._attackerFormation_b[row] = self._attackerFormation_b[row] or {}
                table.insert(self._attackerFormation_b[row], hero)
                -- self._attackerFormation_b[init_formation_index] = hero
            elseif camp == 1 then
                table.insert(self._defenderTeam, hero)
                self._defenderFormation[init_formation_index] = hero
                assert(row >= 1 and row <= 3, "self._defenderFormation_b[" .. row .. "] didn't exist")
                self._defenderFormation_b[row] = self._defenderFormation_b[row] or {}
                table.insert(self._defenderFormation_b[row], hero)
                -- self._defenderFormation_b[init_formation_index] = hero
            end
            -- 

            -- hero._musics = v.musics--zstring.split(dms.atos(ship_mould_element, ship_mould.sound_index), ",")
            if v.musics ~= "" then
                hero._musics = zstring.split(v.musics, "|")
            end
            -- 小兵ship mould id
            local ship_force_mould_id = dms.atoi(ship_force_mould_element, ship_force_mould.force_mould)

            -- 小兵ship mould行数据
            local ship_mould_force_element = dms.element(dms["ship_mould"], ship_force_mould_id)

            -- 小兵普攻索引
            local commonAttackForceIndex = dms.atoi(ship_mould_force_element, ship_mould.skill_mould)

            -- 小兵sprite绘制id 
            local sprite_force_id = dms.atoi(ship_mould_force_element, ship_mould.ship_pic)

            -- 小兵模板对应天赋索引列表
            local force_skills = nil

            -- 解析生成小兵技能数据
            force_skills = self:parserSkillData(camp, commonAttackForceIndex, nil)

            -- for m,n in pairs(v.forceArray) do
            for m, n in pairs(v.forceObjects) do
                -- print("*****************************************",n.shipMould)
                -- 生成小兵
                -- local bullet = v.healthPoint * 0.2
                -- local effect = v.attack * 0.2

                -- ship模板行数据     
                local ship_mould_element1 = dms.element(dms["ship_mould"], zstring.tonumber(n.shipMould))
                -- ship模板对应ship force id
                local ship_force_mould_index1 = dms.atoi(ship_mould_element1, ship_mould.base_mould2)

                -- ship force行数据
                local ship_force_mould_element1 = dms.element(dms["ship_force_mould"], ship_force_mould_index1)

                -- 攻击距离 
                local range1 = dms.atoi(ship_force_mould_element1, ship_force_mould.attack_range)

                local ranker = self:createForce(tonumber(m), camp, sprite_force_id, sprite_type, x, y, size, range1, bullet, effect, force_skills, n, hero)
                if camp == 0 then 
                    table.insert(self._attackerTeam, ranker)
                elseif camp == 1 then
                    table.insert(self._defenderTeam, ranker)
                end
            end
        end     
    end 
end

function BattleScene:createAttackerTeams()
    if checkGameDataVerify() == false then
        return
    end
    -- print("英雄", #_ED._fightModule.heroBattleObjects, #_ED._fightModule.attackObjects)
    -- debug.print_r(_ED._fightModule.heroBattleObjects)
    -- self:initBattleTeamInfo(0, _ED.user_info.battleCache.attackerObjects)
    self:initBattleTeamInfo(0, _ED._fightModule.heroBattleObjects)

end

function BattleScene:createDefenderTeams()
    -- print("怪物", #_ED._fightModule.armyBattleObjects)
    -- self:initBattleTeamInfo(1, _ED.user_info.battleCache.attackerObjects)
    self:initBattleTeamInfo(1, _ED._fightModule.armyBattleObjects)
end

function BattleScene:rolePause(params)
    self._change_focus_count = self._change_focus_count + 1
    if params ~= nil then
        self._focus = params._focus
    end
    if self._attack_running == false then
        return
    end

    self._attack_running = false
    for i, v in pairs(self._attackerTeam) do
        if params == nil then
            v:onPause(v)
        else
            v:onPause(params)
        end
    end

    for i, v in pairs(self._defenderTeam) do
        if params == nil then
            v:onPause(v)
        else
            v:onPause(params)
        end
    end
end

-- 技能时间
function BattleScene:attackPause(params)
    self:rolePause(params)

    state_machine.excute("battle_map_show_object_layer_skill_effect", 0, 0)
end

-- 技能时间恢复
function BattleScene:attackResume(params)
    self._change_focus_count = self._change_focus_count - 1
    -- print("1111111111  attackResume", self._change_focus_count)
    if self._change_focus_count > 0 then
        return
    end
    -- print("2222222222lock")
    -- if self._focus ~= params then
    --     return
    -- end
    if self._attack_running == true then
        return
    end

    self._attack_running = true
    self._focus = nil
    for i, v in pairs(self._attackerTeam) do
        v:onResume(params)
    end

    for i, v in pairs(self._defenderTeam) do
        v:onResume(params)
    end
    state_machine.excute("battle_map_hide_object_layer_skill_effect", 0, 0)
end

-- 重置角色信息显示
function BattleScene:resetPlayerAndRoleInfo( ... )
    -- 锁定主公技能的界面显示
    state_machine.excute("battle_ui_set_all_majesty_skill_cannot_use", 0, 0)
    -- 重置玩家信息显示
    state_machine.excute("battle_ui_update_player_reset", 0, 0)
end

-- 移动到下一个战斗场景
function BattleScene:moveToNextFightScene(params)
    cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_he.png")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_he.plist")
    local maxTime = 0
    -- step 1 复位动画
    for i, v in pairs(self._attackerTeam) do
        -- local t = v:moveToNextFight()
        local t = v:resetMoveToNextFight()
        if t > maxTime then
            maxTime = t
        end
    end

    -- state_machine.excute("battle_map_move_to_camp_center", 0, {x = (self._battle_index - 2) * (fwin._width - app.baseOffsetX) + (fwin._width - app.baseOffsetX) / 2, time = maxTime / 2, v = 1, s = 0.5, stop_actions = true})
    state_machine.excute("battle_map_move_to_camp_center", 0, {x = nil, x = nil, time = maxTime / 2, v = 1, s = 0.5, stop_actions = true})

    for i, v in pairs(self._attackerTeam) do
        if v._hero_type == v._enum_hero_type._hero then
            v._is_running = false
        end
        v:removeAllBuffs(true)
    end

    for i, v in pairs(self._defenderTeam) do
        if v._hero_type == v._enum_hero_type._hero then
            v._is_running = false
        end
        v:removeAllBuffs(true)
    end

    if checkGameDataVerify() == false then
        return
    end

    -- step 2 进入重置点
    self:runAction(cc.Sequence:create({cc.DelayTime:create(maxTime),
            cc.CallFunc:create(function(sender)
                __resetRoleCoordsStatus()
                local maxTime = 10000
                for i, v in pairs(sender._attackerTeam) do
                    local t = v:moveToNextFight()
                    if t < maxTime then
                        maxTime = t
                    end
                end

                -- step 3 进入出生位
                sender:runAction(cc.Sequence:create({cc.DelayTime:create(maxTime),
                        cc.CallFunc:create(function(sender)
                                for i, v in pairs(sender._deatherList) do
                                    if v._camp == 1 then
                                        v:removeFromParent(true)
                                    end
                                end

                                sender._deatherList = {}
                                sender._defenderTeam = {}
                                sender._defenderFormation = {}
                                sender._defenderFormation_b = {}
                                
                                sender:initBattleTeamInfo(1, _ED._fightModule.armyBattleObjects)
                                -- for i, v in pairs(sender._attackerTeam) do
                                --     v:moveTo(v._end_pos)
                                -- end
                                sender._is_win = false
                                sender._is_over = false
                                sender:startMission()
                                -- state_machine.excute("battle_map_move_to_next_fight_scene", 0, cc.p(-1 * (fwin._width - app.baseOffsetX) * (self._battle_index - 1), 0))
                                state_machine.excute("battle_map_move_to_next_fight_scene", 0, cc.p(-1 * (fwin._width - app.baseOffsetX) * (self._battle_index - 1), 0))
                                
                                state_machine.excute("battle_ui_update_fight_count", 0, nil)

                            end)
                    }))
                end)
        }))
end

function BattleScene:showUIRoleName()
    if true == BattleRoleHP.__name_visible then
        BattleRoleHP.__name_visible = false
    else
        BattleRoleHP.__name_visible = true
    end
    local visible = BattleRoleHP.__name_visible
    for k,v in pairs(self._attackerTeam) do
        if nil ~= v and v._death ~= true then
            v:showUIRoleName(visible)
        end
    end

    for k,v in pairs(self._defenderTeam) do
        if nil ~= v and v._death ~= true then
            v:showUIRoleName(visible)
        end
    end
end

-- 检测队伍是否有近战攻击
function BattleScene:checkTeamIsHaveNearAttack( camp )
    local attackHaveNearAttack = false
    local byAttackHaveNearAttack = false
    -- if camp == 0 then
        for k,v in pairs(self._attackerTeam) do
            if v._range <= 1 and v._formation_row == 1 then
                attackHaveNearAttack = true
            end
        end
    -- else
        for k,v in pairs(self._defenderTeam) do
            if v._range <= 1 and v._formation_row == 1 then
                byAttackHaveNearAttack = true
            end
        end
    -- end
    return attackHaveNearAttack, byAttackHaveNearAttack
end

-- 获取攻击等待CD
function BattleScene:getAttackWaitCD(params)
    local role = params[1]
    local objects = role._camp == 0 and self._attackerFormation or self._defenderFormation
    local cd = 0
    for i, v in pairs(objects) do
        if v._formation_row > 1 then
            cd = cd + 0.5
            if nil ~= v._attack_wait_cd then
                v._attack_wait_cd = cd
            end
        end
    end
end

-- 战斗结束
function BattleScene:fightOver(params)
    if checkGameDataVerify() == false then
        return
    end
    -- cc.Director:getInstance():getScheduler():setTimeScale(1)
    -- >print((self._is_win == true and "战斗胜利" or "战斗失败"))
    local personal_result = ""
    local myHpInfo = ""
    if _ED._battle_init_type == battle_enum._fight_type._fight_type_105 then
        personal_result = _ED._battle_type_params[1].."\r\n" .. _ED._battle_type_params[2].."\r\n" .. _ED._battle_type_params[3].."\r\n".._ED._battle_type_params[4].."\r\n"
        local index = 0
        for k,v in pairs(self._attackerFormation) do
            index = index + 1
            local base_id = _ED.user_ship[""..v._shipId].ship_base_template_id
            if index == 1 then
                local hp = v._hp
                if tonumber(hp) > tonumber(v._personal_max_hp) then
                    hp = v._personal_max_hp
                end
                myHpInfo = myHpInfo..v._shipId..","..base_id..","..math.ceil(v._personal_max_hp)..","..math.ceil(hp)
                personal_result = personal_result..v._shipId..","..base_id..","..math.ceil(hp)
            else
                local hp = v._hp
                if tonumber(hp) > tonumber(v._personal_max_hp) then
                    hp = v._personal_max_hp
                end
                myHpInfo = myHpInfo.."|"..v._shipId..","..base_id..","..math.ceil(v._personal_max_hp)..","..math.ceil(hp)
                personal_result = personal_result.."|"..v._shipId..","..base_id..","..math.ceil(hp)
            end
        end
        index = 0
        personal_result = personal_result.."!"
        for k,v in pairs(self._defenderFormation) do
            index = index + 1
            local base_id = v._heroBattleObject.shipMould
            if index == 1 then
                local hp = v._hp
                if tonumber(hp) > tonumber(v._personal_max_hp) then
                    hp = v._personal_max_hp
                end
                personal_result = personal_result..v._shipId..","..base_id..","..math.ceil(hp)
            else
                local hp = v._hp
                if tonumber(hp) > tonumber(v._personal_max_hp) then
                    hp = v._personal_max_hp
                end
                personal_result = personal_result.."|"..v._shipId..","..base_id..","..math.ceil(hp)
            end
        end
    end

    local function responseEnvironmentFightCallback( ... )
        if _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
            if self._is_win == true then
                state_machine.excute("battle_win_window_open",0,{self.stars})
            else
                state_machine.excute("soul_duplicate_battle_fail_window_open",0,"")
            end
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_105 then
            state_machine.excute("personal_fight_result_open", 0, {self._is_win, myHpInfo})
        else
            state_machine.excute("battle_win_window_open",0,{self.stars})
        end
    end

    local death_count = 0
    for k,v in pairs(self._attackerFormation) do
        if v._death == true then
            death_count = death_count + 1
        end
    end
    if death_count == 0 then
        self.stars = 3
    elseif death_count == 1 then
        self.stars = 2
    else
        self.stars = 1
    end

    local dropInfo = ""
    local drop_data = {}
    for i,v in pairs(self.drop_list) do
        local add_item =  false
        for j,k in pairs(drop_data) do
            if v.item_id == k.item_id and v.item_type == k.item_type and
                ( tonumber(v.item_type) == 1 
                or tonumber(v.item_type) == 2 
                or tonumber(v.item_type) == 3
                or tonumber(v.item_type) == 4 
                or tonumber(v.item_type) == 5 
                or tonumber(v.item_type) == 8 
                or tonumber(v.item_type) == 9
                or tonumber(v.item_type) == 12
                or tonumber(v.item_type) == 18
                or tonumber(v.item_type) == 19
                or tonumber(v.item_type) == 20
                or tonumber(v.item_type) == 21
                or tonumber(v.item_type) == 28
                or tonumber(v.item_type) == 31
                or tonumber(v.item_type) == 32
                or tonumber(v.item_type) == 33
                or tonumber(v.item_type) == 33
                or (tonumber(v.item_type) == 6 and  tonumber(v.item_id) == 215) ) then
                    k.item_count = tonumber(k.item_count) + tonumber(v.item_count)
                    add_item = true
            end
        end
        if add_item == false then
            table.insert(drop_data,v)
        end
    end

    local drop_data_result = {}
    for i,v in pairs(drop_data) do
        if v.item_type == 6 and v.item_id ~= 215 then
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.item_id), prop_mould.change_of_equipment))> 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.item_id), prop_mould.use_of_ship)) > 0  then
                table.insert(drop_data_result,v) 
            else
                for j = 1 ,tonumber(v.item_count) do
                    local temp_data = {
                        item_id = v.item_id,
                        item_type = v.item_type,
                        item_count = 1
                    }
                    table.insert(drop_data_result,temp_data)
                end
            end 
        else
            table.insert(drop_data_result,v) 
        end
    end

    for k,v in pairs(drop_data_result) do
        if k == table.nums(drop_data_result) then
            dropInfo = dropInfo..v.item_id..","..v.item_type..","..v.item_count
        else
            dropInfo = dropInfo..v.item_id..","..v.item_type..","..v.item_count.."|"
        end
    end
    getUserFight()
    if _ED._battle_init_type == battle_enum._fight_type._fight_type_0 
        or _ED._battle_init_type == battle_enum._fight_type._fight_type_1
        or _ED._battle_init_type == battle_enum._fight_type._fight_type_15
        or _ED._battle_init_type == battle_enum._fight_type._fight_type_16
        or _ED._battle_init_type == battle_enum._fight_type._fight_type_17
        or _ED._battle_init_type == battle_enum._fight_type._fight_type_103
        then
        if dropInfo ~= "" then
            self._battle_result_params = self.stars.."\r\n".._ED.user_info.fighter_capacity.. "\r\n" .. dropInfo
        else
            self._battle_result_params = self.stars.."\r\n".._ED.user_info.fighter_capacity
        end
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
        self._battle_result_params = ""..math.ceil(___total_damage)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_22 then
        self._battle_result_params = _ED.union.user_union_info.union_id.."\r\n".._ED.union.union_get_physical_my_team_id
    end

    if self._is_win == true then
        if self._battle_result_params ~= "" then
            if #protocol_command.battle_result_verify.param_list > 0 then
                protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. "\r\n"
            end
            protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. self._battle_result_params
        end

        if _ED._battle_init_type == battle_enum._fight_type._fight_type_20 then
            if executeMissionExt(mission_mould_battle, touch_off_mission_battle_over, "".._ED._scene_npc_id.."v"..self._battle_index, nil) == true then
                executeNextEvent(nil, true)
            else
                state_machine.excute("battle_win_window_open",0,{self.stars})
            end
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_24 then
            state_machine.excute("battle_win_window_open",0,{0})
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_105 then
            protocol_command.battle_result_verify.param_list = personal_result
            NetworkManager:register(protocol_command.battle_result_verify.code, nil, nil, nil, self, responseEnvironmentFightCallback, false, nil)  
        else
            NetworkManager:register(protocol_command.battle_result_verify.code, nil, nil, nil, self, responseEnvironmentFightCallback, false, nil)  
        end
    else
        if _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
            if #protocol_command.battle_result_verify.param_list > 0 then
                protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. "\r\n"
            end
            protocol_command.battle_result_verify.param_list = protocol_command.battle_result_verify.param_list .. self._battle_result_params
            NetworkManager:register(protocol_command.battle_result_verify.code, nil, nil, nil, self, responseEnvironmentFightCallback, false, nil)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_24 then
            state_machine.excute("battle_fail_window_open",0,"")
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_11 then
            protocol_command.battle_result_fail.param_list = _ED._revenge_user_id
            NetworkManager:register(protocol_command.battle_result_fail.code, nil, nil, nil, nil, nil, false, nil)
            state_machine.excute("battle_fail_window_open",0,"")
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then
            protocol_command.battle_result_fail.param_list = _ED._battle_type_params[1]
            NetworkManager:register(protocol_command.battle_result_fail.code, nil, nil, nil, nil, nil, false, nil)
            state_machine.excute("battle_fail_window_open",0,"")
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_19 then
            protocol_command.battle_result_fail.param_list = _ED._battle_type_params[1]
            NetworkManager:register(protocol_command.battle_result_fail.code, nil, nil, nil, nil, nil, false, nil)
            state_machine.excute("battle_fail_window_open",0,"")
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_105 then
            protocol_command.battle_result_fail.param_list = personal_result
            NetworkManager:register(protocol_command.battle_result_fail.code, nil, nil, nil, self, responseEnvironmentFightCallback, false, nil)  
        else
            protocol_command.battle_result_fail.param_list = _ED._scene_npc_id
            NetworkManager:register(protocol_command.battle_result_fail.code, nil, nil, nil, nil, nil, false, nil)
            state_machine.excute("battle_fail_window_open",0,"")
        end
    end       
    state_machine.excute("battle_drop_pos_window_close",0,"")
end

function BattleScene:close()

end

function BattleScene:destroy()
    -- clean frame windows
    fwin:removeAll()
    -- state_machine.excute("duplicate_map_window_open", 0, 0)

    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end

    _ED.user_info.battleCache:clear()
    _ED.user_info.battleCache = nil
    -- debug.print_r(_ED.user_info.battleCache)

    _ED.city_resource_battle_attack_additional = 0
    _ED._fightModule:clear()
    -- debug.print_r(_ED._fightModule)

    upLevelTriggerMission()
end

-- function BattleScene:executeCurrentRountFightData(battle_role)
--     local _roundData = nil
--     _roundData = self:getFightData(battle_role, 0)

--     self.attack_list = {}

--     for i = 1, _roundData.curAttackCount do
--         local attData = _roundData.roundAttacksData[i]
--         self:executeRoleFightData(attData, _roundData)
--     end
--     -- self:removeBeAttackerEffect()
-- end

-- function BattleScene:getFightData( fightRole, grade )
--     local attData = {}
--     local resultBuffer = {}
--     if fightRole then
--         local attackObject = _ED._fightModule:getAppointFightObject(0, fightRole._info._pos)
--         if attackObject == nil then
--             -- print("获取单个战斗数据。。。。索引获取不到角色攻击对象")
--             return nil
--         end
--         _ED._fightModule:setGradeAttack(attackObject, grade)
--         if fightRole.isBeginHeti == true then
--             _ED._fightModule:setFreeSkillTrue()
--         end
--         _ED._fightModule:fightObjectAttack(attackObject,resultBuffer)
--         local resultString = ""
--         for i,v in ipairs(resultBuffer) do
--             resultString = resultString..v
--         end
--         -- print("单个战斗数据。。。。索引位置为：", fightRole._info._pos, resultString)
--         self.pveFightInfoString = resultString
--         if resultString == "" or resultString == nil then
--             return nil
--         end
--         local lists = lua_string_split_line(resultString, "\r\n")
--         local list = lua_string_splits(lists, " ")
--         if list == "" then
--             return nil
--         end
--         list.pos = 1
--         parse_environment_fight_role_round_attack_data(nil,nil,0,nil,list,nil,attData)
--     end
--     return attData
-- end

-- function BattleScene:executeRoleFightData()


-- end


