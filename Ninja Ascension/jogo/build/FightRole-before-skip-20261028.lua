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

FightRole = class("FightRoleClass", Window)
FightRole.__fit_attacking = false
FightRole.__g_role_attacking = false
FightRole.__g_lock_sp_attack = false
FightRole.__g_lock_camp_attack = 0
FightRole._current_attack_camp = -1
FightRole._last_attack_camp = -1
FightRole.__fit_roles = {}
FightRole.__priority_camp = -1
-- skeep fight
FightRole.__skeep_fighting = false
-- 普通攻击队列
FightRole.__attacking_roles = {}

app.load("client.battle.fight.FightEnum")
app.load("data.TipStringInfo")
app.load("client.battle.fight.FightRecorder")
app.load("client.battle.landscape.SkillCloseupWindow")

local kZOrderInFightScene_StanddyRole  = 0
local kZOrderInFightScene_MoveRole     = 10000 
local kZOrderInFightScene_Effect       = 2000000       
local kZOrderInFightScene_Hurt         = 3000000       
local kZOrderInFightScene_sp_effect    = 4000000

FightRole.__mapEffectTag = 50000000
FightRole.__hetiNodeTag = 60000000

FightRole.__delayFightTag = 70000000

FightRole.__mapEffectList = {}

-- 减益buff列表
FightRole.DebuffList = {5, 7, 8, 9, 17, 22 ,24, 36, 39, 47, 48, 50, 51, 55, 56, 61, 66, 67, 69, 81, 82, 83, 84, 88, 96, 97, 120, 129}
-- 增益buff列表
FightRole.GainBuffList = {21, 23, 27, 28, 33, 38, 40, 42, 43, 44, 45, 52, 53, 54, 57, 58, 62, 68}

local ENUM_TYPE_DAMAGE = 
{
    TYPE_DAMAGE_NORMAL = 0,             -- 普通伤害
    TYPE_DAMAGE_INDIRECT = 2,           -- 间接伤害
}

local function isTypeDamage(enumTypeDamage, typeDamage)
    if enumTypeDamage == typeDamage then
        return true
    end
    return false
end

-- -- 播放音效
-- playEffectMusic = function(musicIndex)
--     -- 播放音效
--     pushEffect(formatMusicFile("effect", musicIndex))
-- end

local function removeFrameObjectFuncN(sender)
    sender:removeFromParent(true)
end

local function deleteEffectFile(armatureBack)
    if armatureBack == nil then
        return
    end
    -- 删除光效
    armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns
    if armatureBack._LastsCountTurns <= 0 then
        local fileName = armatureBack._fileName
        -- print("deleteEffectFile-----------", FightRole.animationList)
        -- for i,v in ipairs(FightRole.animationList) do
        --     if v ~= nil and v.fileName == fileName then
        --         table.remove(FightRole.animationList, ""..i)
        --     end
        -- end
        if m_tOperateSystem == 5 then
            if fileName ~= nil then
                CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
            end
        end
            if armatureBack.getParent ~= nil then
                if armatureBack:getParent() ~= nil then
                    if armatureBack.removeFromParent ~= nil then
                        armatureBack:removeFromParent(true)
                    end
                end
            end
        if m_tOperateSystem == 5 then
            -- draw.cleanMemory()
            -- draw.cleanCacheMemory()
            -- CCArmatureDataManager:purge()
            
            CCSpriteFrameCache:purgeSharedSpriteFrameCache()
            CCTextureCache:sharedTextureCache():removeUnusedTextures()
        end
    end
end

function FightRole:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.__fit_roles = {}

    self.__deleteEffectFile = deleteEffectFile

    self.actionTimeSpeed = __fight_recorder_action_time_speed

    self.roleCamp = -1
    self.enter_into = false

    self.parent = nil
    self.armature = nil
    self._FightRoleController = nil

    -- move logic data
    self._wail_count = 0
    self._ml = 0
    self._mr = 0

    -- fight logic
    self.is_killed = false
    self.is_deathed = false
    
    self.chanageMoveActions = false
    self._move_state_enum = {
        _MOVE_STATE_VACANT = 0,         -- 空闲状态
        _MOVE_STATE_WAIT = 1,           -- 待机状态
        _MOVE_STATE_FREE = 2,           -- 无目标自由移动
        _MOVE_STATE_TARGET = 3,         -- 有目标的移动
        _MOVE_STATE_STILL = 4,          -- 静止
        _MOVE_STATE_BACK_SCREEN = 5,    -- 返回屏幕
        _MOVE_STATE_MOVE_CAMP = 6,      -- 移动阵营
    }
    self.move_state = self._move_state_enum._MOVE_STATE_VACANT

    self._move_direction_enum = {
        _LEFT = 0,
        _RIGHT = 1
    }

    self._current_tile_index = 0
    self._sl_role = nil

    -- role info
    self._info = nil
    self._brole = nil
    self._erole = nil
    self._role = nil

    self._skill_quality = nil
    self._skill_property = nil

    self.isStopFight = false

    -- attack data
    self.run_fight_listener = false
    self.fight_cacher_pool = {}
    self.current_fight_data = nil
    self.instantLockAttackTarget = false
    self.current_attack_line = -1
    self.moveByPosition = nil
    self.roleAttacking = false
    self.attacker = nil
    self.roleByAttacking = false
    self.drawByAttackEffectCount = 0
    self.moveBackArena = false
    self.waitAttackOver = false
    self.waitByAttackOver = false
    self.waitByAttackOverDeathEvent = false
    self.roleWaitDeath = false
    self.sendDeathNotice = false
    self.celebrate_win = false
    self.is_dizziness = false
    self.waitNextSkillInfluence = false
    self.isCheckAttackEnd = false
    self.isCheckFitAttackEnd = false
    self.attackerCount = 0
    self.changeActionToAttacking = false
    self.byAttackEffectIndex = 0

    -- hit effect
    self.repelAndFlyEffectCount = 0
    self.byReqelAndFlyEffectWaitByAttackedOver = false

    self.isDeathRemove = false
    self.deathRemoveTime = 0

    -- fit skill
    self.fiter = false -- 合体技能的发起者
    self.byFiter = false  -- 合体技能攻击的被发动者
    self.fight_fit_cacher_pool = {}
    self.fitByKill = false
    -- 攻击状态解锁
    self.__attack_permit = false
    
    -- fight over
    self.fight_over = false
    
    -- 浮空状态 0-默认无 1-浮空上升 2-浮空下落
    self.fly_state = 0
    
    -- 浮空开始坐标
    self.fly_start_point_x = 0
    self.fly_start_point_y = 0
    
    --浮空公式变量 y=a(x - b)^2 + h
    self.fly_circle_a = 0
    self.fly_circle_b = 0
    self.fly_circle_h = 0
    
    -- 浮空最高点
    self.fly_height = 0
    
    -- 浮空时间
    self.fly_time = 0.0
    
    -- 浮空索引,在一个特效中可以有多个浮空事件
    self.fly_index = 0

    self._mdx = 0

    self.openAttackListener = false
    
    self.__cstart_fight = true

    -- 浮空追击相关
    self.jumpOffsetY = 0
    self.lockRole = nil
    self.foucsRole = nil
    self.waitJumpOver = false
    self.waitJumpBack = false
    self.isInJumping = false
    
    -- 浮空的边界反弹
    self.borderBounce = false

    -- 镜头聚焦
    self.camera_focus = false

    -- qte
    self._qte = nil
    self.isWakeUpComkillProgress = false

    self.isLock = false

    self.animationList = {}

    self._drawAttackEffectCount = 0 -- 多攻击目标的攻击光效计数
    
    self.attackerList = {}

    self.jumpAttackPosHeight = 0

    self.isBeginHeti = false

    self.buffList = {}

    self.buffEffectList = {}

    self.ghostIndex = 0

    self.signEffect = nil

    self._draw_influence_count = 0 -- 绘图效用信息的数量

    --部分光效id在事件帧里面，需要做提前加载
    self._spineEffects = {}

    self.drawDamageNumberCount = 0

    self.singleAttackCount = 0

    -- FightRole.__g_lock_camp_attack 是否增加的标志位
    self.isAddCampAttack = false

    -- 扣血飘字数值
    self._battle_combo_root_number = 0
    -- 加血飘字数值
    self._battle_add_blood_root_number = 0
    -- 加血飘字的次数
    self._battle_add_blood_times = 0
    -- 存储加血时的攻击段数
    self._attackSection = 0
    -- 角色计数器光效存储
    self.counterEffectMap = {}

    -- Initialize fight role state machine.
    local function init_fight_role_terminal()
        local fight_role_manager_terminal = {
            _name = "fight_role_manager",
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

        local fight_role_be_killed_terminal = {
            _name = "fight_role_be_killed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params
                if role ~= nil and role.armature ~= nil then
                    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
                        if role.roleCamp == 0 then
                            if nil ~= _ED.battleData.__heros and #_ED.battleData.__heros > 0 then
                                _ED.battleData.__heros["2"] = table.remove(_ED.battleData.__heros, 1, 1)
                                local kingsPercent = dms.float(dms["fight_config"], 21, fight_config.attribute)
                                _ED.battleData.__heros["2"]._sp = _ED.battleData.__heros["2"]._sp + math.min(FightModule.MAX_SP, role.armature._role._sp) * kingsPercent
                                -- role:initChange(_ED.battleData.__heros["2"])
                                -- return false
                                role.needChange = true
                            end
                        elseif role.roleCamp == 1 then
                            if nil ~= _ED.battleData._armys[1].__data and #_ED.battleData._armys[1].__data > 0 then
                                _ED.battleData._armys[1]._data["2"] = table.remove(_ED.battleData._armys[1].__data, 1, 1)
                                local kingsPercent = dms.float(dms["fight_config"], 21, fight_config.attribute)
                                _ED.battleData._armys[1]._data["2"]._sp = _ED.battleData._armys[1]._data["2"]._sp + math.min(FightModule.MAX_SP, role.armature._role._sp) * kingsPercent
                                -- role:initChange(_ED.battleData._armys[1]._data["2"])
                                -- return false
                                role.needChange = true
                            end
                        end
                    end

                    -- 攻击者被反击死亡 清除反击方的被击状态
                    if role.current_fight_data and role.current_fight_data.__defenderList then
                        local defenderList = role.current_fight_data.__defenderList
                        for i, v in pairs(defenderList) do
                            -- if v and v.roleCamp ~= self.roleCamp and v.roleByAttacking then
                            if v and v.roleByAttacking == true then
                                -- print("roleCamp = ", v.roleCamp, " pos = ", v._info._pos, " self.roleCamp = ", self.roleCamp, " self.pos = ", self._info._pos)
                                -- v.roleByAttacking = false
                                if v.checkByAttackEnd then
                                    v:checkByAttackEnd()
                                end
                            end
                        end
                    end

                    if role.sendDeathNotice == false then
                        state_machine.excute("fight_role_controller_notification_role_death_for_last_kill", 0, {role, true})
                    end
                    
                    -- 修复bug 5789 [竞技][跨服武道会]观看跨服武道会回放第二回合开始后，双方不进行战斗，只能点击跳过
                    if role._move_state_enum ~= nil then
                        role.move_state = role._move_state_enum._MOVE_STATE_VACANT
                    end
                    role.sendDeathNotice = true
                    role.fight_over = true
                    role.is_killed = true
                    role.roleAttacking = false
                    role.roleByAttacking = false
                    role:stopAllActions()
                    local armature = role.armature
                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = role._qte, status = "deathed"})
                    -- armature._nextAction = _enum_animation_l_frame_index.animation_conversely

                    -- 取消角色死亡时候的倒地动作帧组的调用，直接进入死亡的动作调用
                    -- local actionIndex = _enum_animation_l_frame_index.animation_conversely
                    -- armature._actionIndex = actionIndex
                    -- armature._nextAction = actionIndex
                    -- armature:getAnimation():playWithIndex(actionIndex)
                    role:executeAnimationConversely(role.armature)

                    -- 死亡更新武将UI的信息
                    if nil ~= armature._self then
                        armature._role._hp = 0
                        state_machine.excute("battle_qte_head_update_draw", 0, {cell = armature._self._qte, status = "update"})
                    end
                    state_machine.excute("fight_role_controller_update_hp_progress", 0, {role.roleCamp, 0})
                    return true
                end
                return false
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_check_move_event_terminal = {
            _name = "fight_role_check_move_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params
                if role ~= nil and role.armature ~= nil then
                    role:checkMoveEvent()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_move_event_terminal = {
            _name = "fight_role_move_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params
                if role ~= nil and role.armature ~= nil then
                    role:moveEvent()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_change_attack_target_event_terminal = {
            _name = "fight_role_change_attack_target_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params[1]
                local target = params[2]
                if role ~= nil and role.armature ~= nil and target ~= nil and target.armature ~= nil then
                    role:changeAttackTargetEvent(target)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_change_fight_win_event_terminal = {
            _name = "fight_role_change_fight_win_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params
                if role ~= nil and role.armature ~= nil then
                    role:changeFightWinEvent()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_change_to_next_attack_role_terminal = {
            _name = "fight_role_change_to_next_attack_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currentRole = params
                if FightRole.__skeep_fighting == true then
                    return true
                end
                if currentRole ~= nil and currentRole.parent ~= nil then
                    currentRole:changeToNextAttackRole()
                    -- currentRole:delayToFight()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_remove_armature_terminal = {
            _name = "fight_role_remove_armature",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currentRole = params
                if currentRole.armature ~= nil then
                    -- self.isLock = true
                    currentRole.armature:retain()
                    currentRole.armature:removeFromParent()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_add_armature_terminal = {
            _name = "fight_role_add_armature",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currentRole = params.role
                local isAttack = params.isAttack
                if currentRole.armature ~= nil then
                    currentRole:addChild(currentRole.armature)
                    if isAttack == true then
                        currentRole.armature:getAnimation():playWithIndex(_enum_animation_l_frame_index.animation_standby)
                    end
                    currentRole.armature:release()
                    if currentRole.parent ~= nil then
                        currentRole._FightRoleController.open_camera = true
                    end
                    -- currentRole.isLock = false
                    currentRole.repelAndFlyEffectCount = 0
                    currentRole.move_state = currentRole._move_state_enum._MOVE_STATE_FREE
                    if isAttack == false then
                        -- currentRole:checkByAttackEnd()
                        currentRole:delayFitByAttackEnd()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_reset_armature_terminal = {
            _name = "fight_role_reset_armature",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currentRole = params
                if currentRole.armature ~= nil then
                    currentRole.repelAndFlyEffectCount = 0
                    currentRole.move_state = currentRole._move_state_enum._MOVE_STATE_FREE
                    currentRole:resetByAttackState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_role_change_fight_action_state_terminal = {
            _name = "fight_role_change_fight_action_state",
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

        state_machine.add(fight_role_manager_terminal)
        state_machine.add(fight_role_be_killed_terminal)
        state_machine.add(fight_role_check_move_event_terminal)
        state_machine.add(fight_role_move_event_terminal)
        state_machine.add(fight_role_change_attack_target_event_terminal)
        state_machine.add(fight_role_change_fight_win_event_terminal)
        state_machine.add(fight_role_change_to_next_attack_role_terminal)
        state_machine.add(fight_role_change_fight_action_state_terminal)
        state_machine.add(fight_role_remove_armature_terminal)
        state_machine.add(fight_role_add_armature_terminal)
        state_machine.add(fight_role_reset_armature_terminal)
        state_machine.init()
    end

    -- call func init fight role state machine.
    init_fight_role_terminal()
end

function FightRole:delayFitByAttackEnd( ... )
    local function delayEndFuncN( _sender )
        if _sender ~= nil and _sender.parent ~= nil and _sender.armature ~= nil then
            local mactionIndex = _enum_animation_l_frame_index.animation_standby
            -- if _sender.armature._nextAction ~= mactionIndex then
                csb.animationChangeToAction(_sender.armature, mactionIndex, mactionIndex, false)
                _sender:checkByAttackEnd(true)
            -- end
        end
    end
    self.armature._actionIndex = _enum_animation_l_frame_index.animation_normal_conversely
    self.armature._nextAction = 0
    self.attackerCount = 0
    if self.roleWaitDeath == true then
        self.fitByKill = true
        if self.sendDeathNotice == false then
            self.sendDeathNotice = true
            state_machine.excute("fight_role_controller_notification_role_death_for_last_kill", 0, {self, false})
        end
        self:checkByAttackEnd()
    else
        local actions = {}
        table.insert(actions, cc.DelayTime:create(0.6))
        table.insert(actions, cc.CallFunc:create(delayEndFuncN))
        self:runAction(cc.Sequence:create(actions))
    end
    -- csb.animationChangeToAction(self.armature, self.armature._actionIndex, self.armature._nextAction, false)
end

function FightRole:resetByAttackState( ... )
    self.jumpOffsetY = 0
    self:setPosition(0, 0)
    self.armature._actionIndex = _enum_animation_l_frame_index.animation_standby
    self.armature._nextAction = 0
    csb.animationChangeToAction(self.armature, self.armature._actionIndex, self.armature._nextAction, false)
    self.attackerCount = 0
    -- self:checkByAttackEnd()

    -- self.fight_cacher_pool = {}
    self.waitAttackOver = false
    self.roleAttacking = false
    self.roleByAttacking = false
    self.waitByAttackOver = false
    self.waitJumpOver = false
    self.isInJumping = false
    self.waitJumpBack = false
    self.moveByPosition = nil
    -- self:cleanAttackData()
    self.shadow:setVisible(true)

    self.waitNextSkillInfluence = false
    self.moveBackArena = true
    -- self.openAttackListener = false
    self.move_state = self._move_state_enum._MOVE_STATE_FREE
    state_machine.excute("fight_role_move_event", 0, self)
end

function FightRole:delayToFight( ... )
    local function delayEndFuncN( _sender )
        if _sender ~= nil and _sender.parent ~= nil then
            _sender:changeToNextAttackRole()
        end
    end
    local actions = {}
    table.insert(actions, cc.DelayTime:create(0.3))
    table.insert(actions, cc.CallFunc:create(delayEndFuncN))
    local seq = cc.Sequence:create(actions)
    seq:setTag(FightRole.__delayFightTag)
    self:runAction(seq)
end

local function hitRepelAndFlyEffectFunN(sender)
    if sender._self ~= nil and sender._self.repelAndFlyEffectCount > 0 then
        sender._self.repelAndFlyEffectCount = sender._self.repelAndFlyEffectCount - 1
        
        sender._self.borderBounce = false
        
        if sender._self.repelAndFlyEffectCount <= 0 then
            if sender._self.byReqelAndFlyEffectWaitByAttackedOver == true or sender._self.waitByAttackOver == true then
                sender:setPositionY(sender._base_pos.y)
                sender._self.repelAndFlyEffectCount = 0
                sender._self._mdx = 0
                sender._self:checkByAttackEnd()
            end
            sender._self.armature._nextAction = _enum_animation_l_frame_index.animation_standby
        end
        
        if sender._self.repelAndFlyEffectCount <= 0 and sender._self.roleByAttacking == true then
            -- self.armature._nextAction = _enum_animation_l_frame_index.animation_diagonal_floated
            csb.animationChangeToAction(sender._self.armature, _enum_animation_l_frame_index.animation_standby, _enum_animation_l_frame_index.animation_standby, nil)
        end
        if sender._self.repelAndFlyEffectCount <= 0 and sender._self.is_dizziness == true then
            local actionIndex = _enum_animation_l_frame_index.animation_dizziness
            csb.animationChangeToAction(sender._self.armature, actionIndex, actionIndex, false)
        end

         -->___crint("...............999999999999")
     end
end

local function bossRewardDrop(l, h, s, m, d, p, v, rv, rd)
    -- [[活动副本奖励计算
    -- -- 配置伤害计算参数项
    -- local str = "0.15,0.47,1801|0.35,0.47,1802|0.75,0.47,1803|1,0,1804!0.15,0.15,1805|0.5,0.15,1806|0.75,0.15,1807|1,0,1808!0.25,0.12,1809|0.5,0.12,1810|0.75,0.12,1811|1,0,1812!0.25,0.1,1813|0.5,0.1,1814|0.75,0.1,1815|1,0.1,1816!0.25,0.08,1817|0.5,0.08,1818|0.75,0.08,1819|1,0.08,1820!0.25,0.05,1821|0.5,0.05,1822|0.75,0.05,1823|1,0.05,1824"

    -- local l = 6 -- 难度级别
    -- local h = zstring.splits(zstring.split(str, "!")[l], "|", ",", function ( value ) return tonumber(value) end) -- 奖励参数
    local ml = #h -- 最高难度级别
    -- local s = 10000000 -- 总血量
    -- local m = 0 -- 历史总伤害值
    -- local d = 0 -- 当前的总伤害值
    -- local p = 0 -- 当前所在梯度
    -- local rv = 0 -- 金币、经验奖励记录
    -- local rd = "" -- 掉落奖励记录

    -- -- 初始化当前所在的梯度索引
    -- for i, v in pairs(h) do
    --     if m <= v[1] * s then
    --         p = i
    --         break
    --     end
    -- end

    -- print("当前的梯度信息：", p)

    -- while true do
        if ml < p then
            -- break
            return p, rv, rd
        end
        
    --     if d >= s then
    --         break
    --     end

    --     local v = math.random(1, 10000) -- 当前的伤害值
    --     d = d + v -- 更新总伤害值

        while v > 0 do
            local md = h[p][1] * s -- 当前梯度最大伤害值
            local dv = md - m -- 当前梯度剩余量
            local tv = math.min(dv, v)
            
            v = v - tv -- 更新剩余伤害计算量

            rv = rv + tv * h[p][2] -- 计算奖励

            m = m + tv -- 更新历史总伤害值

            -- 更新梯度索引值
            if m >= md then
                if #rd > 0 then
                    rd = rd .. ","
                end
                rd = rd .. h[p][3]
                p = p + 1
            end

            -- print("计算奖励信息：", md, dv, tv, v, m, p, h[p][2], rv, rd)

            if ml < p then
                break
            end
        end
    -- end

    -- print("奖励记录：", math.floor(rv), rv, rd)
    -- 活动副本奖励计算处理完毕]]
    return p, rv, rd
end

local function showRoleHP(armature, skf)
    if armature ~= nil then
        if nil ~= skf and skf.defAState ~= "3" then
            local hp = tonumber(skf.aliveHP)
            if armature._role._hp < hp then
                armature._role._hp = hp
            end
        end

        armature._role._hp = armature._role._hp < 0 and 0 or armature._role._hp
        local percent = armature._role._hp/armature._brole._hp * 100
        percent = percent > 100 and 100 or percent

        if armature._self._info ~= nil and armature._role._hp > armature._self._info._max_hp then -- Fury 4-oct (:787)
            armature._role._hp = armature._self._info._max_hp
        end

        local armatureSkf = nil
        if nil ~= armature.__skill_influence then
            armatureSkf = armature.__skill_influence
        end

        if nil ~= skf and skf.__skill_influence ~= nil then
            -- -- 只在数码试炼中处理，把影响限制到最小
            -- if __lua_project_id == __lua_project_l_digital or (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and _ED.battleData.battle_init_type == _enum_fight_type._fight_type_54 then
            --     if nil ~= armature.__skill_influence and armature.__skill_influence < skf.__skill_influence then
            --         if tonumber(armature._role._hp) > tonumber(skf.aliveHP) then
            --             armature._role._hp = skf.aliveHP
            --         end
            --     end
            -- end

            if nil ~= armature.__skill_influence and armature.__skill_influence > skf.__skill_influence then
                armature._role._hp = armature.__aliveHP
            else
                armature.__aliveHP = skf.aliveHP
                armature.__skill_influence = skf.__skill_influence
            end
        end
        armature._heroInfoWidget:showRoleHP()

        state_machine.excute("fight_role_controller_update_hp_progress", 0, nil)
        -- state_machine.excute("battle_qte_head_update_draw", 0, {cell = armature._self._qte, status = "update", skf = skf})
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = armature._self._qte, status = "update", armatureSkf = armatureSkf, skf = skf})

        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
            if armature._camp == 0 then
                state_machine.excute("the_kings_battle_ui_window_update_draw_hp", 0, {armature, nil})
            else
                state_machine.excute("the_kings_battle_ui_window_update_draw_hp", 0, {nil, armature})
            end
        end
        
        if armature._role._hp == 0 then
            local function heroDeathFunc()
                if nil ~= armature._heroInfoWidget then
                    armature._heroInfoWidget:controlLife(false, 9)
                    armature._heroInfoWidget:showControl(false)
                    armature._heroInfoWidget:controlLife(true, 9)
                end
            end
            armature._heroInfoWidget:controlLife(false, 9)
            armature._heroInfoWidget:showControl(true)
            armature._heroInfoWidget:controlLife(true, 9)
            armature._heroInfoWidget:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(heroDeathFunc)))
        else
            armature._heroInfoWidget:controlLife(false, 8)
            armature._heroInfoWidget:keepShow(1.0)
        end 
        
        -- -- 更新角色hp显示
        -- if armature._camp == "0" then
            -- -- 玩家血量更新
            -- -->___rint("我方角色血量更新", armature._pos, tonumber(percent))
            -- state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 2, _type = 1, _roleIndex = armature._pos, _value = percent})
            -- state_machine.excute("fight_hero_hp_update", 0, 0)
        -- else
            -- -- 敌方血量更新
            -- -->___rint("敌方角色血量更新", armature._pos, tonumber(percent))
            -- state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 1, _type = 1, _roleIndex = armature._pos, _value = percent})
        -- end

        if armature._camp == 1 then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                or __lua_project_id == __lua_project_l_naruto 
                then
                if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
                    -- silver
                    armature._lose_t_hp = armature._lose_t_hp or 0
                    local dhp = _ED._fightModule.totalDefenceDamage - armature._lose_t_hp
                    local r = 1
                    -- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 then
                    --     r = dms.float(dms["play_config"], 4, pirates_config.param)
                    -- elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 
                    --     or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
                    --     then
                    --     r = dms.float(dms["play_config"], 9, pirates_config.param)
                    -- end

                    local pas = nil
                    local rrIdx = 3
                    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 then
                    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 
                        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
                        then
                        rrIdx = 8
                    end
                    if type(dms["play_config"][rrIdx]) == "table" then
                        pas = dms["play_config"][rrIdx]
                    else
                        pas = zstring.splits(dms.string(dms["play_config"], rrIdx, pirates_config.param), "|", ",")
                        -- dms["play_config"][rrIdx] = pas
                    end

                    if nil == _ED._fightModule._boss_reward_l then
                        local str = dms.string(dms["play_config"], rrIdx, pirates_config.param)
                        local l = _ED._activity_copy_battle_index
                        _ED._fightModule._boss_reward_l = l
                        _ED._fightModule._boss_reward_h = zstring.splits(zstring.split(str, "!")[l], "|", ",", function ( value ) return tonumber(value) end) -- 奖励参数
                        _ED._fightModule._boss_reward_s = armature._brole._hp
                        _ED._fightModule._boss_reward_m = 0
                        _ED._fightModule._boss_reward_d = 0
                        _ED._fightModule._boss_reward_p = 1
                        _ED._fightModule._boss_reward_v = 0
                        _ED._fightModule._boss_reward_rv = 0
                        _ED._fightModule._boss_reward_rd = ""
                    end


                    _ED._fightModule._g_c_silver = _ED._fightModule._g_c_silver or 0
                    _ED._fightModule._g_c_silver1 = _ED._fightModule._g_c_silver1 or 0

                    _ED._fightModule._boss_reward_v = _ED._fightModule.totalDefenceDamage - _ED._fightModule._boss_reward_m

                    _ED._fightModule._boss_reward_p1 = _ED._fightModule._boss_reward_p

                    _ED._fightModule._boss_reward_p, _ED._fightModule._boss_reward_rv, _ED._fightModule._boss_reward_rd = bossRewardDrop(_ED._fightModule._boss_reward_l, 
                        _ED._fightModule._boss_reward_h, 
                        _ED._fightModule._boss_reward_s, 
                        _ED._fightModule._boss_reward_m, 
                        _ED._fightModule._boss_reward_d, 
                        _ED._fightModule._boss_reward_p, 
                        _ED._fightModule._boss_reward_v, 
                        _ED._fightModule._boss_reward_rv, 
                        _ED._fightModule._boss_reward_rd)
                    _ED._fightModule._boss_reward_d = _ED._fightModule.totalDefenceDamage
                    _ED._fightModule._boss_reward_m = _ED._fightModule.totalDefenceDamage

                    -- print("boss info : ", _ED._fightModule._boss_reward_rv, _ED._fightModule._boss_reward_rd, _ED._fightModule._boss_reward_v)

                    -- debug.print_r(pas)

                    -- r = tonumber(pas[_ED._activity_copy_battle_index][armature._drop_info_count + 1][2])

                    -- local _g_c_silver = math.floor(dhp * r)
                    local _g_c_silver = math.ceil(_ED._fightModule._boss_reward_rv)
                    if _g_c_silver > 0 then
                        armature._lose_t_hp = _ED._fightModule.totalDefenceDamage
                        local damage = 0
                        local _tg_c_silver = _g_c_silver
                        -- for i, v in pairs(pas) do
                        --     local tdamage = damage
                        --     damage = armature._brole._hp * tonumber(v[1])
                        --     r = tonumber(v[2])

                        --     if damage <= armature._lose_t_hp then
                        --         _tg_c_silver = _tg_c_silver + math.floor((damage - tdamage) * r)
                        --         -- print("step1", i, armature._brole._hp, tdamage, damage, armature._lose_t_hp, r, _tg_c_silver)
                        --     else
                        --         _tg_c_silver = _tg_c_silver + math.floor((armature._lose_t_hp - tdamage) * r)
                        --         -- print("step2", armature._brole._hp, tdamage, damage, armature._lose_t_hp, r, _tg_c_silver)
                        --         break
                        --     end
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
                        _g_c_silver = _tg_c_silver - _ED._fightModule._g_c_silver
                        if 0 < _g_c_silver then
                            _ED._fightModule._g_c_silver = _tg_c_silver
                            _ED._fightModule._g_c_silver_info = aeslua.encrypt("jar-world", _ED._fightModule._g_c_silver, aeslua.AES128, aeslua.ECBMODE)
                            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 then
                                state_machine.excute("fight_ui_update_boss_drop_silver_count", 0, {1, _g_c_silver, _tg_c_silver})
                            elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 
                                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
                                then
                                state_machine.excute("fight_ui_update_boss_drop_prop_count", 0, {1, _g_c_silver, _tg_c_silver, _ED._fightModule._boss_reward_h[1][4]})
                            end
                        end
                    end

                    -- armature._drop_info_count = armature._drop_info_count or 0
                    -- if armature._drop_info_count < 6 then
                    --     -- local pvi = tonumber(pas[_ED._activity_copy_battle_index][armature._drop_info_count + 1][1])
                    --     local pvi = tonumber(_ED._fightModule._boss_reward_h[_ED._activity_copy_battle_index][armature._drop_info_count + 1][1])
                    --     -- if nil ~= pvi and (100 - pvi) >= (percent) then
                    --     if nil ~= pvi and (1 - pvi) >= (percent) then
                    --         -- print("boss:", pvi, percent)
                    --         armature._drop_info_count = armature._drop_info_count + 1
                    --         _ED._fightModule._drop_info_count = armature._drop_info_count
                    --         local arrs = _ED._activity_copy_drop_info_arr[armature._drop_info_count]
                    --         if nil ~= arrs and #arrs > 0 then
                    --             local hnValue = 0
                    --             local pnCount = 0
                    --             for i, v in pairs(arrs) do
                    --                 if tonumber(v[1]) == 1 then
                    --                     hnValue = hnValue + tonumber(v[3])
                    --                 else
                    --                     pnCount = pnCount + tonumber(v[3])
                    --                 end
                    --             end
                    --             if hnValue > 0 then
                    --                 state_machine.excute("fight_ui_update_boss_drop_silver_count", 0, {armature._drop_info_count, hnValue})
                    --             end
                    --             if pnCount > 0 then
                    --                 state_machine.excute("fight_ui_update_boss_drop_prop_count", 0, {armature._drop_info_count, pnCount})
                    --             end
                    --             -- print("boss:", pvi, percent, hnValue, pnCount)
                    --         end
                    --     end
                    -- end

                    if _ED._fightModule._boss_reward_p1 ~= _ED._fightModule._boss_reward_p then
                        armature._drop_info_count = armature._drop_info_count or 0
                        for i = armature._drop_info_count + 1, _ED._fightModule._boss_reward_p do
                            armature._drop_info_count = armature._drop_info_count + 1
                            _ED._fightModule._drop_info_count = armature._drop_info_count
                        
                            local arrs = _ED._activity_copy_drop_info_arr[armature._drop_info_count]
                            if nil ~= arrs and #arrs > 0 then
                                local hnValue = 0
                                local pnCount = 0
                                local pid = -1
                                for i, v in pairs(arrs) do
                                    if tonumber(v[1]) == 1 then
                                        hnValue = hnValue + tonumber(v[3])
                                    else
                                        pnCount = pnCount + tonumber(v[3])
                                        pid = tonumber(v[2])
                                    end
                                end
                                if hnValue > 0 then
                                    _ED._fightModule._g_c_silver1 = _ED._fightModule._g_c_silver1 + hnValue
                                    state_machine.excute("fight_ui_update_boss_drop_silver_count", 0, {armature._drop_info_count, hnValue})
                                end
                                if pnCount > 0 then
                                    state_machine.excute("fight_ui_update_boss_drop_prop_count", 0, {armature._drop_info_count, pnCount})
                                end
                                -- print("boss:", pvi, percent, hnValue, pnCount)
                            end
                        end
                    end
                end
            end
        else
            -- 1   加血  
            -- 2   加怒  
            -- 11  格挡  
            -- 12  无敌  
            -- 21  增加攻击    
            -- 23  增加防御    
            -- 26  受到的伤害降低 
            -- 27  增加暴击    
            -- 28  增加抗暴    
            -- 32  清除减益BUFF(清除技能类型5,7,8,9,17,22,24,36,39,47,48,50,51,55,56,61,66,67,69的效用) 
            -- 38  增加格挡强度  
            -- 40  增加吸血率   
            -- 42  小技能触发概率 
            -- 43  增加破格挡率  
            -- 44  增加反弹率   
            -- 45  增加伤害减免  
            -- 52  增加伤害加成  
            -- 53  增加控制率   
            -- 54  增加造成的必杀伤害   
            -- 57  提高怒气回复速度    
            -- 58  增加暴击伤害  
            -- 60  增加暴击强度  
            -- 62  增加必杀伤害率 
            -- 63  增加格挡率   
            -- 64  增加数码兽类型克制伤害加成   
            -- 65  增加数码兽类型克制伤害减免   
            -- 68  增加必杀抗性  
            -- 70  复活概率    
            -- 71  复活继承血量  
            -- 72  复活继承怒气  
            -- 73  增加复活复活概率    
            -- 74  增加复活继承血量    
            -- 75  被复活概率   
            -- 76  被复活继承血量 
            -- 77  被复活继承怒气 
            -- 78  免疫控制    
            -- 80  小技能伤害提升 

            local playAction = false
            if skf then 
                local defenderST = tonumber(skf.defenderST)
                if 1 == defenderST
                    or 2 == defenderST
                    or 11 == defenderST
                    or 12 == defenderST
                    or 21 == defenderST
                    or 23 == defenderST
                    or 26 == defenderST
                    or 27 == defenderST
                    or 28 == defenderST
                    or 32 == defenderST
                    or 104 == defenderST
                    or 107 == defenderST
                    or 38 == defenderST
                    or 40 == defenderST
                    or 42 == defenderST
                    or 43 == defenderST
                    or 44 == defenderST
                    or 45 == defenderST
                    or 52 == defenderST
                    or 53 == defenderST
                    or 54 == defenderST
                    or 57 == defenderST
                    or 58 == defenderST
                    or 60 == defenderST
                    or 62 == defenderST
                    or 63 == defenderST
                    or 64 == defenderST
                    or 65 == defenderST
                    or 68 == defenderST
                    or 70 == defenderST
                    or 71 == defenderST
                    or 72 == defenderST
                    or 73 == defenderST
                    or 74 == defenderST
                    or 75 == defenderST
                    or 76 == defenderST
                    or 77 == defenderST
                    or 78 == defenderST
                    or 80 == defenderST
                    or 14 == defenderST
                    or 106 == defenderST -- 数码试炼里面吃了吸血buff，数码兽出手时会受到这个效用
                    then
                    playAction = false
                else
                    playAction = true
                end
            end
            if true == playAction then
                state_machine.excute("battle_qte_head_cell_play_hurt_action", 0, {cell = armature._self._qte, status = "hurt"})
            end
        end
    end
end

local function showRoleSP(armature, def)
    -- 设置角色怒气
    -- if armature._camp == 0 then
        -- -- 玩家怒气更新
        -- state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 2, _type = 2, _roleIndex = armature._pos, _value = armature._role._sp})
    -- else
        -- -- 敌人怒气更新
        -- state_machine.excute("battle_formation_update_pragress", 0, {_roleType = 1, _type = 2, _roleIndex = armature._pos, _value = armature._role._sp})
    -- end
    if nil ~= def and def.__skill_influence ~= nil then
        if nil ~= armature.__skill_influence and armature.__skill_influence > def.__skill_influence then
            armature._role._sp = armature.__aliveSP
        else
            armature.__aliveHP = def.aliveHP
            armature.__aliveSP = def.aliveSP
            armature.__skill_influence = def.__skill_influence
        end
    end
    armature._heroInfoWidget:showRoleSP()
    -- state_machine.excute("battle_qte_head_update_draw", 0, {cell = armature._self._qte, status = "update"})

    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
        if armature._camp == 0 then
            state_machine.excute("the_kings_battle_ui_window_update_draw_sp", 0, {armature, nil})
        else
            state_machine.excute("the_kings_battle_ui_window_update_draw_sp", 0, {nil, armature})
        end
    else
        if armature._camp == 0 then
            state_machine.excute("battle_qte_head_update_draw", 0, {cell = armature._self._qte, status = "update"})
        end
    end

    -- if true == armature._self._show_kill_add_sp then
    --     armature._self._show_kill_add_sp = false
    --     local addSpp200 = cc.Sprite:createWithSpriteFrameName("images/ui/battle/jishanuqijiangli.png")
    --     addSpp200:setAnchorPoint(cc.p(0.5, 0.5))
    --     armature._self:getParent():getParent():addChild(addSpp200, 1999999)
    --     local pos = cc.p(armature._self:getParent():getPosition())
    --     pos.y = pos.y + 150
    --     addSpp200:setPosition(pos)
    --     local actions = {
    --         cc.DelayTime:create(60 / 60 * __fight_recorder_action_time_speed),
    --         cc.MoveBy:create(45 / 60 * __fight_recorder_action_time_speed, cc.p(0, 80)),
    --         cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
    --         cc.Spawn:create(
    --                 cc.MoveBy:create(45 / 60 * __fight_recorder_action_time_speed, cc.p(0, 50)),
    --                 cc.FadeOut:create(45 / 60 * __fight_recorder_action_time_speed)
    --             ),
    --         cc.CallFunc:create(function ( sender )
    --             sender:removeFromParent(true)
    --         end)
    --     }
    --     local seq = cc.Sequence:create(actions)
    --     addSpp200:runAction(seq)
    -- end
end

function FightRole:updateDrawRoleHP()
    showRoleHP(self.armature)
end

-- function FightRole:updateDrawRoleHPwhenByAttackEnd()
--     showRoleHP(self.armature, nil, true)
-- end

function FightRole:showKillAddSp()
    local xx, yy = self.parent:getPosition()
    if true == self._show_kill_add_sp 
        and xx == self.parent._base_pos.x
        and yy == self.parent._base_pos.y
        then
        playEffectMusic(9709)

        self._show_kill_add_sp = false
        local addSpp200 = cc.Sprite:createWithSpriteFrameName("images/ui/battle/jishanuqijiangli.png")
        if addSpp200 == nil then
            cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
            cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
            addSpp200 = cc.Sprite:createWithSpriteFrameName("images/ui/battle/jishanuqijiangli.png")
        end
        addSpp200:setAnchorPoint(cc.p(0.5, 0.5))
        self:getParent():getParent():addChild(addSpp200, 1999999)
        local pos = cc.p(self:getParent():getPosition())
        pos.y = pos.y + 150
        pos.x = pos.x - self:getParent():getContentSize().width / 2
        addSpp200:setPosition(pos)
        local actions = {
            cc.DelayTime:create(60 / 60 * __fight_recorder_action_time_speed),
            cc.MoveBy:create(45 / 60 * __fight_recorder_action_time_speed, cc.p(0, 80)),
            cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
            cc.Spawn:create(
                    cc.MoveBy:create(45 / 60 * __fight_recorder_action_time_speed, cc.p(0, 50)),
                    cc.FadeOut:create(45 / 60 * __fight_recorder_action_time_speed)
                ),
            cc.CallFunc:create(function ( sender )
                sender:removeFromParent(true)
            end)
        }
        local seq = cc.Sequence:create(actions)
        addSpp200:runAction(seq)
    end
end

function FightRole:init(parent, size, roleCamp, attackLine, brole, fightRoleController, fightIndex, isAnimal)
    self.parent = parent
    self:setContentSize(cc.size(size.width, size.height))

    self.roleCamp = roleCamp
    self.current_attack_line = attackLine or -1
    if zstring.tonumber(brole._current_hp) > 0 or zstring.tonumber(brole._current_sp) > 0 then
        local current_brole = brole
        current_brole._max_hp = brole._hp
        current_brole._hp = brole._current_hp
        current_brole._sp = brole._current_sp
        self._info = current_brole
    else
        self._info = brole
    end
    self._brole = brole
    self._erole = {_type = self._info._type}
    self._role = nil

    self._FightRoleController = fightRoleController

    self.actionTimeSpeed = __fight_recorder_action_time_speed
    
    self._load_over = false
    self.fight_over = false
    self.fightIndex = fightIndex
    self.isDeathRemove = false
    self.deathRemoveTime = 0
    
    self._isAnimal = isAnimal

    self:onLoad()
    return self
end

function FightRole:initChange(brole)
    if nil ~= brole then
        self._info = brole
        self._brole = brole
        self._erole = {_type = self._info._type}
    end
    self._role = nil
    
    self._load_over = false
    self.fight_over = false
    -- self.fightIndex = fightIndex
    self.isDeathRemove = false
    self.deathRemoveTime = 0

    self.sendDeathNotice = false
    self.fight_over = false
    self.is_killed = false
    self.roleAttacking = false
    self.roleByAttacking = false

    self.run_fight_listener = true
    self.roleAttacking = false
    self.roleByAttacking = false
    self.moveBackArena = false
    self.waitAttackOver = false
    self.waitByAttackOver = false
    self.roleWaitDeath = false
    self.sendDeathNotice = false
    self.is_killed = false
    self.is_deathed = false
    self.isDeathRemove = false
    self.deathRemoveTime = 0

    -- self.openAttackListener = true

    self:stopAllActions()

    self.armature:removeFromParent(true)

    self.needChange = true
    -- print("开始变更。")
    
    self:onLoad()

    local actionIndex = _enum_animation_l_frame_index.animation_move
    csb.animationChangeToAction(self.armature, actionIndex, actionIndex, false)
    self.armature._lockActionIndex = actionIndex

    if self.roleCamp == 0 then
        self.armature:setPositionX(-600)
    else
        self.armature:setPositionX(600)
    end
    self.armature:runAction(cc.Sequence:create(cc.MoveTo:create(1.0 / __fight_recorder_action_time_speed, cc.p(0, 0)), cc.CallFunc:create(function ( sender )
        -- print("变更完成：", sender._self.needChange)
        sender._self.needChange = false

        local armature = sender
        armature._lockActionIndex = nil
        actionIndex = _enum_animation_l_frame_index.animation_standby
        csb.animationChangeToAction(armature, actionIndex, actionIndex, false)

        showRoleHP(armature)
        showRoleSP(armature)

        -- 修复bug 6141 [竞技][跨服王者之战]在巅峰赛的3v3比赛中没有登场的宝可梦的被动技能效用直接生效触发了
        -- 与状态机 fight_attack_round_start 重复了
        -- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
        --     state_machine.excute("fight_role_controller_update_draw_battle_start_influence_info", 0, 0)
        -- end
    end)))

    self._FightRoleController.__fight_round = self._FightRoleController.__fight_round or 1
    self._FightRoleController.__fight_round = self._FightRoleController.__fight_round + 1
    fwin:open(FightRound:new():init(self._FightRoleController.__fight_round, 5), fwin._window)

    if self.armature._camp == 0 then
        state_machine.excute("the_kings_battle_ui_window_update_draw_hp", 0, {self.armature, nil})
        state_machine.excute("the_kings_battle_ui_window_update_draw_sp", 0, {self.armature, nil})
    else
        state_machine.excute("the_kings_battle_ui_window_update_draw_hp", 0, {nil, self.armature})
        state_machine.excute("the_kings_battle_ui_window_update_draw_sp", 0, {nil, self.armature})
    end
    state_machine.excute("the_kings_battle_ui_window_update_draw_round_count", 0, 0)
    state_machine.excute("the_kings_battle_ui_window_update_draw_camp_info", 0, self.roleCamp)

    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
        self._FightRoleController:cleanBuffState(true)
    end
    return self
end



function FightRole:updateChange(brole)
    -- if nil ~= brole then
    --     self._info = brole
    --     self._brole = brole
    --     self._erole = {_type = self._info._type}
    -- end
    -- self._role = nil
    
    -- self._load_over = false
    -- self.fight_over = false
    -- -- self.fightIndex = fightIndex
    -- self.isDeathRemove = false
    -- self.deathRemoveTime = 0

    -- self.sendDeathNotice = false
    -- self.fight_over = false
    -- self.is_killed = false
    -- self.roleAttacking = false
    -- self.roleByAttacking = false

    -- self.run_fight_listener = true
    -- self.roleAttacking = false
    -- self.roleByAttacking = false
    -- self.moveBackArena = false
    -- self.waitAttackOver = false
    -- self.waitByAttackOver = false
    -- self.roleWaitDeath = false
    -- self.sendDeathNotice = false
    -- self.is_killed = false
    -- self.is_deathed = false
    -- self.isDeathRemove = false
    -- self.deathRemoveTime = 0

    -- self.openAttackListener = true

    -- self:stopAllActions()

    local r = self.armature._role

    self.armature._heroInfoWidget:removeFromParent(true)

    self.armature:removeFromParent(true)
    
    self.needChange = true
    self:onInit()
    self.needChange = false

    self.armature._role = r

    -- local actionIndex = _enum_animation_l_frame_index.animation_standby
    -- csb.animationChangeToAction(self.armature, actionIndex, actionIndex, false)

    -- self.needChange = false
    -- self._lockActionIndex = nil
    return self
end


function FightRole:resetInfo(brole, fightIndex)
    self._info = brole
    self._brole = brole
    self._erole = {_type = self._info._type}
    self._role = nil
    
    -- self.armature._role._hp = self._info._hp
    -- self.armature._role._sp = self._info._sp

    self.fightIndex = fightIndex
    
    if self.is_killed == true then
        -- self:executeAnimationConverselyToGetUp(self.armature)
    end
    return self
end

function FightRole:changeAction(actionIndex)
    self.armature:getAnimation():playWithIndex(actionIndex)
end

function FightRole:changeFightEffect()
    self.parent:stopAllActionsByTag(2)
    self:changeAction(_enum_animation_l_frame_index.animation_onrush)
end

function FightRole:resetFight()
    -- if self.run_fight_listener == true then
    --     -- self.run_fight_listener = false
    --     self.roleAttacking = false
    --     self.roleByAttacking = false
    --     self.moveBackArena = false
    --     self.waitAttackOver = false
    --     self.waitByAttackOver = false
    --     self.roleWaitDeath = false
    --     -- self.is_killed = false
    --     -- self.is_deathed = false

    --     self:changeAction(_enum_animation_l_frame_index.animation_standby)
    --     self.move_state = 0
    -- end
end

function FightRole:restartFight()
    self:changeAction(_enum_animation_l_frame_index.animation_standby)
    self.move_state = 0
    -- state_machine.excute("fight_role_check_move_event", 0, self)
end

function FightRole:removeFromAttackingArgs()
    for i, v in pairs(FightRole.__attacking_roles) do
        if v == self then
            table.remove(FightRole.__attacking_roles, i)
        end
    end
end

function FightRole:skeepFighting()
    self.run_fight_listener = false
    self.roleAttacking = false
    self.roleByAttacking = false
    self.moveBackArena = false
    self.waitAttackOver = false
    self.waitByAttackOver = false
    self.roleWaitDeath = false
    self.sendDeathNotice = false
    self.is_killed = false
    self.is_deathed = false
    self.isDeathRemove = false
    self.deathRemoveTime = 0

    if is2004 == true then
        self:removeFromAttackingArgs()
    end 

    self:changeAction(_enum_animation_l_frame_index.animation_standby)
    self.move_state = 0
end

function FightRole:checkNextFight()
    -->___crint(self.roleCamp, self.attackLine, self.run_fight_listener, self.roleAttacking, self.roleByAttacking, self.moveBackArena, self.waitAttackOver, self.waitByAttackOver, self.roleWaitDeath, self.is_killed, self.is_deathed)
    if self.run_fight_listener == false 
        and self.roleAttacking == false
        and self.roleByAttacking == false
        and self.moveBackArena == false
        and self.waitAttackOver == false
        and self.waitByAttackOver == false
        and self.roleWaitDeath == false
        and self.is_killed == false
        -- and self.is_deathed == false
        then
        return true
    end
    return false
end

function FightRole:changeFightWinEvent()
    -- 取消胜利的动作帧组的调用，直接进入角色的胜利逻辑处理
    -- self.parent:stopAllActionsByTag(2)
    -- self:changeAction(_enum_animation_l_frame_index.animation_standby)
    -- self.armature._nextAction = _enum_animation_l_frame_index.animation_win_action
    self.celebrate_win = true
    self.parent:stopAllActionsByTag(2)
    self:changeAction(_enum_animation_l_frame_index.animation_standby)

    -->___crint("战斗胜利的动作调用")
end

function FightRole:checkByAttackDeath()
    -->___rint("校验角色死亡")
end

local function __drop_attackChangeActionCallback(armatureBack)
    local armature = armatureBack
    if armature ~= nil then
        local actionIndex = armature._actionIndex
        -- 攻击切帧控制
        if actionIndex == 0 then
            deleteDropEffectFile(armatureBack)
        elseif actionIndex == 1 then
            armature._nextAction = 2
            state_machine.excute("fight_ui_drop_moving", 0, {_index = armature.drawType, _armature = armature})
        elseif actionIndex == 2 then
            armature._nextAction = 0
        end
    end 
end

___createEffect = function(armaturePad, fileIndex, _camp, addToTile)
    -- 创建光效
    -- local armatureName, fileName = loadEffectFile(fileIndex)
    local posTile = armaturePad
    -- local armature = ccs.Armature:create(armatureName)
    -- armature._fileName = fileName
    local armature = nil
    if animationMode == 1 then
        armature = sp.spine_effect(fileIndex, effectAnimations[1], false, nil, nil, nil)
        armature.animationNameList = effectAnimations
        sp.initArmature(armature, true)
    else
        local armatureName, fileName = loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end
    -- table.insert(FightRole.animationList, {fileName = fileName, armature = armature})
    local tempX, tempY  = posTile:getPosition()
    armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2, tempY + posTile:getContentSize().height/2))

    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    local _tcamp = zstring.tonumber("".._camp)
    local _armatureIndex = frameListCount * _tcamp
    -->___rint("frameListCount->", frameListCount, _camp, _armatureIndex)
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    if addToTile == true then
        armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
        posTile:addChild(armature, kZOrderInFightScene_Effect)
    else    
        posTile:getParent():addChild(armature, kZOrderInFightScene_Effect)
        armature:setGlobalZOrder(kZOrderInFightScene_Effect)
    end
    armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
    
    local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
    armature._duration = duration / 60.0
    return armature
end

function FightRole:stopAllActionsByTag(tag)
    self.parent:stopAllActionsByTag(tag)
end

function FightRole:getAnimationDuration(armature, actionIndex)
    local duration = 0
    if animationMode == 1 then
        duration = armature:getAnimation():getAnimationDuration(actionIndex)
    else
        duration = armature:getAnimation():getAnimationDuration(actionIndex) - 1
    end
    if duration < 0 then
        duration = 0
    end
    if animationMode == 1 then
        duration = duration / 30.0
    else
        duration = duration / 60.0
    end
    return duration
end

function FightRole:getMoveAnimationDuration(armature, actionIndex, distance, distancex, distancey)
    local duration = nil
    
    if is2004 == true then
        local tmp_run_distance = math.sqrt(distancex * distancex + distancey * distancey)
        for i, v in ipairs(_run_controller) do
            if tmp_run_distance >= v._run_distance then
                duration = v._run_time
            end
        end
    else
        -- distance = math.abs(distance)
        -- duration = 1/60.0 * distance / 12
        -- return 0.6
        duration = 0.6
    end
    
    return duration
end

function FightRole:changeActionToByAttack()
    local armature = self.armature
    local actionIndex = 5

    if actionIndex ~= armature._actionIndex then
        if self.repelAndFlyEffectCount <= 0 then
            armature._actionIndex = actionIndex
            armature._nextAction = actionIndex
            armature:getAnimation():playWithIndex(actionIndex)
            armature._nextAction = _enum_animation_l_frame_index.animation_standby

            for k,v in pairs(self.buffList) do
                local armatureEffect = self.buffEffectList[k]
                if nil ~= armatureEffect and armatureEffect._buffInfo[2] > 2 then
                    armatureEffect._nextAction = 2
                end
            end
        end
    end
end

function FightRole:updateDrawInfluenceInfo( skf, updateUI, isFire )
    -- if __lua_project_id == __lua_project_l_naruto then
    --     return
    -- end
    if skf.visible == false then
        return
    end

    skf.visible = false

    -- 生命链接特殊处理
    if BattleSkill.isLifeChainSkill(skf.defenderST) then
        local count = zstring.tonumber(skf.stRound)
        if count < 0 then
            if skf.stVisible == "0" then
                self:cleanBuffStateWithType(skf.defenderST)
                return
            end

            local effectValue = zstring.tonumber(skf.stValue)
            if effectValue > 0 then
                -- 清理掉间接伤害的生命链接飘字
                return
            else
                -- 清理掉被击者的生命链接飘字
                return
            end
        else

        end
    end

    
    local isDeath = false
    if self.is_killed == true or self.is_deathed == true or self.roleWaitDeath == true then
        isDeath = true
    end

    -- 绘制buff光效
    self:addBuffEffect(self, tonumber(skf.stRound), isDeath, skf.defenderST, skf)

    local defenderST = zstring.tonumber(skf.defenderST)

    if updateUI == true then
        if skf.defenderST == "2" or skf.defenderST == "3" then
            -- local flag = -1
            -- if skf.defenderST == "2" then
            --     flag = 1
            -- end
            -- self.armature._role._sp = self.armature._role._sp + (flag * tonumber(skf.stValue))

            local sp = zstring.tonumber(skf.aliveSP)
            if sp < 0 then
                sp = 0
            elseif sp > FightModule.MAX_SP then
                sp = FightModule.MAX_SP
            end

            self.armature._role._sp = sp
            self.armature._role._lsp = sp

            showRoleSP(self.armature, skf)
        elseif skf.defenderST == "1" then
            self.armature._role._hp = self.armature._role._hp + (tonumber(skf.stValue))
            self.armature._role._lhp = skf.aliveHP
            if self.armature._role._hp < 0 then
                self.armature._role._hp = 0
            elseif self.armature._role._hp > self._info._max_hp then
                self.armature._role._hp = self._info._max_hp
            end
            showRoleHP(self.armature, skf)
        elseif skf.defenderST == "32" or skf.defenderST == "104" or skf.defenderST == "107" then

        elseif (skf.defenderST == "19") then
            self.armature._role._hp = self.armature._role._hp + tonumber(skf.stValue)
            self.armature._role._lhp = skf.aliveHP
            self._info._max_hp = self._info._max_hp + tonumber(skf.stValue)
            if self.roleCamp == 0 then
                self._FightRoleController.heros_total_hp = self._FightRoleController.heros_total_hp + tonumber(skf.stValue)
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "update"})
            else
                self._FightRoleController.masters_total_hp = self._FightRoleController.masters_total_hp + tonumber(skf.stValue)
            end
        elseif skf.defenderST == "20" then

        end

        local nDamage = tonumber(skf.stValue)
        if skf.defenderST == "9" and nDamage > 0 then
            local flag = -1
            self.armature._role._hp = self.armature._role._hp + (flag * nDamage)
            self.armature._role._lhp = skf.aliveHP
            if self.armature._role._hp < 0 then
                self.armature._role._hp = 0
            end
            showRoleHP(self.armature, skf)

            -- print("灼烧的绘图伤害值：", self.roleCamp, self._info._pos, (flag * tonumber(skf.stValue)), skf.stValue)

            -- local drawString = ""
            -- local numberFilePath = ""
            -- if skf.defenderST == "6" 
            --     or skf.defenderST == "9" 
            --     then
            --     drawString = "-"..skf.stValue
            --     numberFilePath = "images/ui/number/xue.png"
            --     if tonumber(self.roleCamp) == 1 then
            --         BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(skf.stValue)
            --         state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
            --     end
            -- elseif skf.defenderST == "31" then
            --     drawString = "+"..skf.stValue
            --     numberFilePath = "images/ui/number/jiaxue.png"
            -- end

            local drawString = "-"..nDamage
            local numberFilePath = "images/ui/number/xue.png"
            if tonumber(self.roleCamp) == 1 then
                BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + nDamage
                state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
            end

            -- if skf.defenderST == "6" 
            --     or skf.defenderST == "9" 
            --     or skf.defenderST == "31" 
            --     then
                -- self.armature._role._hp = self.armature._role._hp + tonumber(drawString)
                -- showRoleHP(self.armature)

                self._hurtCount = 1
                -- self.drawDamageNumberCount = 0
                local defState = skf.defState
                -- print("灼烧的绘图伤害值：", drawString)
                self:showChangeHpNumberAni(numberFilePath, drawString, false, defState)
                -- state_machine.excute("fight_role_controller_update_hp_progress", 0, nil)
                if skf.defAState == "1" then
                    -- print("角色被灼烧死亡")
                    self.roleWaitDeath = true
                    fwin:addService({
                        callback = function ( params )
                            if nil ~= params.checkByAttackEnd then
                                params:checkByAttackEnd()
                                state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                            end
                        end,
                        delay = 0,
                        params = self
                    })
                end
            -- end
        end

        -- self.buffList[skf.defenderST] = skf.stRound
        -- if 0 >= tonumber(skf.stRound) then
        --     local armatureEffect = self.buffEffectList[skf.defenderST]
        --     if armatureEffect ~= nil then
        --         armatureEffect._LastsCountTurns = 0
        --         deleteEffectFile(armatureEffect)
        --         self.buffEffectList[skf.defenderST] = nil
        --     end
        -- end
        
        if defenderST == 9
            then
            self:changeActionToByAttack()
        end
    end

    -- 如果是庇护效果，且回合数小于0，则不飘字
    if (defenderST == 113 or defenderST == 116 or defenderST == 121 or defenderST == 122 or defenderST == 138) and tonumber(skf.stRound) < 0 then
        return
    end

    if defenderST < 0 or nil == _battle_buff_effect_dictionary[defenderST + 1] or _battle_buff_effect_dictionary[defenderST + 1] == "-1" or skf.stVisible == "0" then
        return
    end

    -- 添加buff效果飘字, _battle_buff_effect_dictionary 在res/data/TipStringInfo.lua定义
    local size = self:getContentSize()
    -- print("------->>>>>:", defenderST, "images/ui/battle/".._battle_buff_effect_dictionary[zstring.tonumber(defenderST) + 1]..".png", self.roleAttacking, self.moveBackArena)

    local texturePath = "images/ui/battle/".._battle_buff_effect_dictionary[defenderST + 1]..".png"
    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(texturePath)

    -- print("spriteFrame = ", spriteFrame, " texturePath = ", texturePath)

    if spriteFrame == nil then
        return
    end

    local texture = cc.Sprite:createWithSpriteFrameName(texturePath)
    if nil == texture then
        return
    end

    if isFire == true then
        texture:setVisible(false)
    else
        texture:setVisible(true)
    end

    texture:setAnchorPoint(cc.p(0.5, 0.5))
    -- miss:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 

    local offsetY = math.random(10, 30)
    texture:setPosition(cc.p(self:getParent():getPositionX() + self:getPositionX(), self:getParent():getPositionY() + size.height + offsetY)) 
    local map = self:getParent():getParent()
    map:addChild(texture, kZOrderInFightScene_Hurt)
    -- texture:setScale(1.2)
    texture._self = self

    local actions = {}
    -- if self.roleAttacking or self.moveBackArena then
    --     table.insert(actions, cc.DelayTime:create(1.5))
    -- end
    if (self._draw_influence_count > 0) then
        texture:setVisible(false)
        table.insert(actions, cc.DelayTime:create(0.2 * self._draw_influence_count))
        table.insert(actions, cc.CallFunc:create(function ( sender )
            sender:setVisible(true)
        end))
    end
    table.insert(actions, cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())))

    local funcAction = cc.CallFunc:create(
        function ()
            if self and self._draw_influence_count then
                self._draw_influence_count = self._draw_influence_count - 1
            end
        end
        )
    table.insert(actions, funcAction)
    table.insert(actions, cc.CallFunc:create(removeFrameObjectFuncN))
    local seq = cc.Sequence:create(actions)
    texture:runAction(seq)

    self._draw_influence_count = self._draw_influence_count + 1
end

function FightRole:drawDrop(_dropType, _dropCount)
    if _dropType == nil or _dropCount == nil then
        return
    end

    if zstring.tonumber(_dropCount) > 0 then
        state_machine.excute("fight_ui_update_battle_card_drop", 0, {dropType = zstring.tonumber(_dropType), dropCount = zstring.tonumber(_dropCount)})
        
        local armatureEffect = nil
        if animationMode == 1 then
            armatureEffect = ___createEffect(fwin._view._layer, "96_0", 0)
        else
            armatureEffect = ___createEffect(fwin._view._layer, 96, 0)
            local drawIconImage = string.format("effect/effice_96_%s.png", _dropType)
            local drawIcon = ccs.Skin:create(drawIconImage)
            armatureEffect:getBone("Layer8"):addDisplay(drawIcon, 0)
        end
        armatureEffect:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
        armatureEffect._invoke = nil
        armatureEffect._actionIndex = 0
        armatureEffect.drawType = _dropType + 1

        armatureEffect:getAnimation():playWithIndex(0)
        armatureEffect._nextAction = 1
        armatureEffect._invoke = __drop_attackChangeActionCallback
        armatureEffect._move_position = cc.p(0, 0)

        local size = self.parent:getContentSize()
        local scaleX = self.parent:getScaleX()
        local scaleY = self.parent:getScaleX()
        local olePosition = fwin:convertToWorldSpaceAR(self.parent, cc.p(0, size.height/2)) -- armatureBack._posTile:convertToWorldSpace(cc.p(0, 0))
        olePosition.x = olePosition.x / app.scaleFactor + size.width * scaleX / 2
        olePosition.y = olePosition.y / app.scaleFactor + size.height * scaleY / 2
        --fwin._view._layer:addChild(armatureEffect)
        armatureEffect:setPosition(olePosition)
    end
end

-- 被攻击结束 死亡/存活
function FightRole:checkByAttackEnd(isFitEnd)
    if self.repelAndFlyEffectCount > 0 or self.roleAttacking then
        self.byReqelAndFlyEffectWaitByAttackedOver = true
        return 
    end
    -- if self.current_fight_data ~= nil then 
    --     local _def = self.current_fight_data.__def
    --     if _def ~= nil and _def.defAState == "1" then
            if isFitEnd ~= true and self.roleWaitDeath == true and self.attackerCount <= 0 then
                self.isDeathRemove = true
                self.roleWaitDeath = false
                -- self.sendDeathNotice = false
                self:cleanBuffState(true)
                if self.roleCamp == 1 then
                    state_machine.excute("fight_role_be_killed", 0, self)
                    -- print("敌方角色死亡", self.is_killed, self.is_deathed)
                else
                    state_machine.excute("fight_role_be_killed", 0, self)
                    -- print("我方角色死亡")
                end
                -- test code
                -- self:drawDrop(0, 1)
                if self.current_fight_data ~= nil then 
                    local _def = self.current_fight_data.__def
                    if nil ~= _def then
                        self:drawDrop(_def.dropType, _def.dropCount)
                    end
                end
            end
    --     end
    -- end

    -- print("被攻击结束 roleCamp = ", self.roleCamp, " pos = ", self._info._pos, " self.repelAndFlyEffectCount = ", self.repelAndFlyEffectCount, " self.roleAttacking = ", self.roleAttacking, " self.roleByAttacking = ", self.roleByAttacking)

    if nil ~= self._battle_combo_root then
        self._battle_combo_root._number = 0
    end

    self.drawDamageNumberCount = 0

    self.byReqelAndFlyEffectWaitByAttackedOver = false

    self.waitByAttackOverDeathEvent = false
    -- self.current_fight_data = nil
    self.roleByAttacking = false
    self.waitByAttackOver = false

    self.byAttackEffectIndex = 0
    self.attackerList = {}

    -- table.remove(self.fight_cacher_pool, "1")
    if self.is_killed == true or self.is_deathed == true then
    else
        -- self.armature._role._hp = self.armature._role._lhp or self.armature._role._hp
        if nil ~= self.armature._role._lhp then
            -- self.armature._role._hp = tonumber(self.armature._role._lhp)
        end
        local isDizz = false
        for k,v in pairs(self.buffList) do
            if k == "5" then
                if tonumber(v) > 0 then
                    isDizz = true
                end
            end
        end
        local isDeath = false
        if self.is_killed == true or self.is_deathed == true or self.roleWaitDeath == true then
            self.buffList["5"] = nil
            isDeath = true
        end
        if isDizz == true and isDeath == false then --self.is_dizziness == true then
            if __lua_project_id == __lua_project_gragon_tiger_gate then
                if self.dizzinessEffect == nil then
                    self.is_dizziness = true
                    local actionIndex = _enum_animation_l_frame_index.animation_dizziness
                    csb.animationChangeToAction(self.armature, actionIndex, actionIndex, false)

                    -- 绘制角色的眩晕光效
                    local armatureEffect = self:createEffect(_battle_controller._vertigo_effice_id)
                    -- armatureEffect._invoke = deleteEffectFile
                    local size = self:getContentSize()
                    armatureEffect:setPosition(cc.p(size.width / 2, 0))
                    -- armatureEffect:setPosition(cc.p(self.parent:getPosition()))
                    self.parent:addChild(armatureEffect)
                    self.dizzinessEffect = armatureEffect
                end
            else
                -- self:addBuffEffect(self, 1, isDeath, "5")
                self.is_dizziness = false
                -- state_machine.excute("fight_role_check_move_event", 0, self)
                state_machine.excute("fight_role_move_event", 0, self)
            end
        else
            self.is_dizziness = false
            -- state_machine.excute("fight_role_check_move_event", 0, self)
            state_machine.excute("fight_role_move_event", 0, self)
        end

        if nil ~= self.buffList["79"] then
            local buffTypes = {"5", "7", "8", "9", "17", "22", "24", "36", "39", "47", "48", "50", "51", "55", "56", "61", "66", "67", "69", "82", "83", "88", "120"}
            for i, t in pairs(buffTypes) do
                self:cleanBuffStateWithType(t)
            end
        end
    end

    if FightRole.__fit_attacking == true then
    else
        state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
    end
end

function FightRole:checkAttackerBuffDeath( ... )
    if self._atkBuffDeath == true then
        self._atkBuffDeath = false
        self.isDeathRemove = true
        self.roleWaitDeath = false
        -- self.sendDeathNotice = false
        self:cleanBuffState(true)
        self:cleanAttackData()
        state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self)
        state_machine.excute("fight_role_be_killed", 0, self)
    end
    self._atkBuffDeath = false
end

function FightRole:cleanAttackData()
    if self.current_fight_data == nil then
        return
    end
    -- local defenderList = self.current_fight_data.__defenderList
    -- if defenderList ~= nil then
    --     for i, v in pairs(defenderList) do
    --         if v.current_fight_data ~= nil then
    --             local _def = v.current_fight_data.__def
    --             if _def ~= nil and _def.defAState == "1" then
    --                 -->___rint("角色死亡")
    --             end
    --         end

    --         -- v.current_fight_data = nil
    --         -- v.roleByAttacking = false
    --         -- table.remove(v.fight_cacher_pool, "1")
    --         -- state_machine.excute("fight_role_check_move_event", 0, v)

    --         v.waitByAttackOver = true
    --         v.roleByAttacking = false
    --     end
    -- end

    -- self.current_fight_data = nil
    self.roleAttacking = false
    self.moveBackArena = false
    self.fitAttacking = false
    self.camera_focus = false

    if is2004 == true then
        self:removeFromAttackingArgs()
    end 
    
    -- if self.fiter == true then
    --     FightRole.__fit_attacking = false
    --     state_machine.excute("fight_role_controller_reset_role_position", 0, false)
    --     state_machine.excute("fight_scene_views_visible", 0, {true,true,true,true,true})
    -- end
    -- self.fiter = false

    -- __fit_params[_enum_params_index.param_attack_count] = 0
    -- state_machine.excute("move_logic_begin_move_all_role", 0, {__fit_roles, __fit_params})

    -- _self = armatureBack._self
    -- local __fit_roles = FightRole.__fit_roles
    -- local current_round_count = _self.current_fight_data.__round
    -- table.remove(_self.fight_cacher_pool, "1")
    -- _self:cleanAttackData()
    -- for i, v in pairs(__fit_roles) do
    --     v.fitAttacking = true
    --     -- for n, m in pairs(v.fight_cacher_pool) do
    --     --     if m.__round == current_round_count then
    --     --         m.__byFitAttacker = nil
    --     --     end
    --     -- end
    --     v.current_fight_data = v.fight_cacher_pool[1]
    --     if v.current_fight_data.__state == 0 then
    --         v:executeAttackLogic()
    --     end
    -- end

    if FightRole.__fit_attacking == true then
    else
        state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
    end
end

-- ----------------------------------------------------------------------------
-- @brief 获取当前角色所在阵营中的位置
-- @lua
-- @param camp 当前角色所属的阵营（0：我方，1：敌方）
-- @return 返回阵营起始坐标（x, y）
--         阵容组的编号            
-- @since v1.0.0
-- @project 龙虎门
-- @date 2015/8/17
-- ----------------------------------------------------------------------------
function FightRole:getCampPosition(camp)
    -- 获取当前阵容的队伍信息
    --  我方       敌方
    -- A4  A1    B1  B4
    -- A5  A2    B2  B5
    -- A6  A3    B3  B6
    local defenders = camp == 0 and self._FightRoleController._hero_formation 
                                or self._FightRoleController._master_formation
    local x = -1
    local line = -1
    for i, v in pairs(defenders) do
        if v ~= nil and v.parent ~= nil then -- 计算存活的角色
            -- local xx, yy
            -- if v.parent._target_position ~= nil then
            --     xx = v.parent._target_position.x
            --     yy = v.parent._target_position.y
            -- else
            --     xx, yy = v.parent:getPosition()
            -- end
            local xx = v.parent._move_pos.x
            if camp == 0 then -- 我方
                if x < xx or x == -1 then
                    x = xx
                    line = v.current_attack_line
                end
            else -- 敌方
                if x > xx or x == -1 then
                    x = xx
                    line = v.current_attack_line
                end
            end
        end
    end
    return cc.p(x, 0), line
end

-- 当前阵营最前方的角色
function FightRole:getCampPioneer(camp, dir)
    -- 获取当前阵容的队伍信息
    --  我方       敌方
    -- A4  A1    B1  B4
    -- A5  A2    B2  B5
    -- A6  A3    B3  B6
    local defenders = camp == 0 and self._FightRoleController._hero_formation 
                                or self._FightRoleController._master_formation
    local x = -100000000
    local role = nil
    for i, v in pairs(defenders) do
        if v ~= nil and v.parent ~= nil then -- 计算存活的角色
            if dir == 1 then
                local xx = v.parent._move_pos.x
                if camp == 0 then -- 我方
                    if x > xx or x == -100000000 then
                        x = xx
                        role = v
                    end
                else -- 敌方
                    if x < xx or x == -100000000 then
                        x = xx
                        role = v
                    end
                end
            else
                local xx = v.parent._move_pos.x
                if camp == 0 then -- 我方
                    if x < xx or x == -100000000 then
                        x = xx
                        role = v
                    end
                else -- 敌方
                    if x > xx or x == -100000000 then
                        x = xx
                        role = v
                    end
                end
            end
        end
    end
    return role
end

-- 复位
function FightRole:moveBackPosition( ... )
    if self.is_killed == true or self.roleWaitDeath == true then
        return
    end
    local moveDirection = 0  -- 0：左    1：右
    local line = self.current_attack_line
    local xx, yy = self.parent:getPosition()
    local distance = 0
    local moveByPosition = cc.p(0, 0)

    local array = {}
    local duration = 0
    local armature = self.armature
    local actionIndex = _enum_animation_l_frame_index.animation_standby
    local flag = self.roleCamp == 0 and 1 or -1

    moveByPosition.x = self.parent._base_pos.x - xx
    moveByPosition.y = self.parent._base_pos.y - yy

    if math.abs(moveByPosition.x) < 10 then
        return
    end

    local function checkMoveEventForChangeActionFuncN00(_parent)
        if _parent ~= nil and _parent._self ~= nil and FightRole.__fit_attacking ~= true then
            _parent._self.armature._lockActionIndex = nil
            local mactionIndex = _enum_animation_l_frame_index.animation_standby
            if _parent._self.armature._nextAction ~= mactionIndex then
                csb.animationChangeToAction(_parent._self.armature, mactionIndex, mactionIndex, false)
            end
        end
    end

    if moveByPosition.x > 0 then
        moveDirection = 1
    end
    
    if self.roleCamp == 1 then
        actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_pursue or _enum_animation_l_frame_index.animation_pursue_back
    else
        actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_pursue_back or _enum_animation_l_frame_index.animation_pursue
    end

    local duration = self:getMoveAnimationDuration(armature, actionIndex, distance, moveByPosition.x, moveByPosition.y)
    if duration < 0.3 then
        duration = 0.3
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        table.insert(array, cc.MoveTo:create(duration * __fight_recorder_action_time_speed, self.parent._base_pos))
    else
        table.insert(array, cc.MoveBy:create(duration * __fight_recorder_action_time_speed, moveByPosition))
    end
    table.insert(array, cc.CallFunc:create(checkMoveEventForChangeActionFuncN00))

    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    --     if self.roleAttacking and true ~= self.parent._mirror and false == self.openAttackListener then
    --         self.parent._mirror = true
    --         self.parent:setScaleX(self.parent:getScaleX() * -1)
    --     end
    -- end

    if self.parent ~= nil then
        if armature._nextAction ~= actionIndex then
            csb.animationChangeToAction(armature, actionIndex, actionIndex, false)
        end
        if #array > 0 then
            armature._lockActionIndex = actionIndex

            local seq = cc.Sequence:create(array)
            -- self.parent:stopAllActionsByTag(2)
            -- seq:setTag(2)
            self.parent:runAction(seq)
        end
    end
end

-- 角色的移动逻辑
function FightRole:moveEventEx()
    if self.parent == nil 
        or self.fight_over == true or self._move_state_enum == nil
        then
        return
    end

    if self.is_killed == true or self.is_deathed == true or self.roleWaitDeath == true then
        -- print("moveEventEx 角色已死亡 ", self.move_state, self.isAddCampAttack)

        -- 如果角色准备返回阵营时 已经判定死亡 则执行死亡逻辑
        if self.move_state == self._move_state_enum._MOVE_STATE_MOVE_CAMP then
            self:cleanAttackData()

            FightRole.__g_role_attacking = false
            FightRole.__g_lock_sp_attack = false

            if self.isAddCampAttack then
                FightRole.__g_lock_camp_attack = FightRole.__g_lock_camp_attack - 1
                self.isAddCampAttack = false
            end

            -- print("如果角色准备返回阵营时 已经判定死亡 则执行死亡逻辑!! roleCamp = ", self.roleCamp, " pos = ", self._info._pos)
            state_machine.excute("fight_role_be_killed", 0, self)
        end
        -- state_machine.excute("fight_role_be_killed", 0, self)
        return
    end

    if self.isInJumping == true or self.waitJumpOver == true or self.roleByAttacking == true or FightRole.__fit_attacking == true then
        return
    end

    local moveDirection = 0  -- 0：左    1：右
    local line = self.current_attack_line
    local xx, yy = self.parent:getPosition()
    local pioneer = self:getCampPioneer(self.roleCamp)  -- 当前阵营最前方的角色
    local distance = 0
    local moveByPosition = cc.p(0, 0)
    local state = self.move_state

    local array = {}
    local duration = 0
    local armature = self.armature
    local actionIndex = _enum_animation_l_frame_index.animation_standby
    local flag = self.roleCamp == 0 and 1 or -1

    moveByPosition.x = self.parent._base_pos.x - xx
    moveByPosition.y = self.parent._base_pos.y - yy

    local function cleanAttackDataFuncN(_parent)
        if _parent ~= nil and _parent._self ~= nil then
            if _parent ~= nil and _parent._self.moveBackArena == true then
                if math.floor(_parent:getPositionY()) == math.floor(_parent._base_pos.y) then
                    if _parent._self.roleAttacking == true then
                        _parent._self:cleanAttackData()
                    else
                        _parent._self.moveBackArena = false
                    end
                end
            end
        end
    end

    if moveByPosition.x ~= 0 or moveByPosition.y ~= 0 then
        local function checkMoveEventForChangeActionFuncN00(_parent)
            if _parent ~= nil and _parent._self ~= nil and FightRole.__fit_attacking ~= true then
                local mactionIndex = _enum_animation_l_frame_index.animation_standby
                if _parent._self.armature._nextAction ~= mactionIndex then
                    csb.animationChangeToAction(_parent._self.armature, mactionIndex, mactionIndex, false)
                end
            end
        end

        if moveByPosition.x > 0 then
            moveDirection = 1
        end
        
        if self.roleCamp == 1 then
            actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_pursue or _enum_animation_l_frame_index.animation_pursue_back
        else
            actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_pursue_back or _enum_animation_l_frame_index.animation_pursue
        end

        local duration = self:getMoveAnimationDuration(armature, actionIndex, distance, moveByPosition.x, moveByPosition.y)
        if duration < 0.3 then
            duration = 0.3
        end


        -- 是否不回位
        local bNoMoveBack = false
        local nMasterCount = 0
        local nMasterDieCount = 0

        if self.roleCamp == 0 then
            local nCount = 0
            for i, v in pairs(self._FightRoleController._hero_formation_ex) do
                if v.parent ~= nil then
                    nCount = nCount + 1
                end
            end

            if nCount == 1 and self.skillQuality == 1 then
                bNoMoveBack = true
            end

            -- 计算敌方人数和死亡数
            for i, v in pairs(self._FightRoleController._master_formation_ex) do
                if v.parent ~= nil then
                    nMasterCount = nMasterCount + 1

                    -- 算上复活，如果对面就剩下蛋，要回位
                    if v.is_killed == true or v.is_deathed == true or v.roleWaitDeath == true or v.buffList["79"] then
                        nMasterDieCount = nMasterDieCount + 1
                    end
                end
            end

        elseif self.roleCamp == 1 then
            local nCount = 0
            for i, v in pairs(self._FightRoleController._master_formation_ex) do
                if v.parent ~= nil then
                    nCount = nCount + 1
                end
            end

            if nCount == 1 and self.skillQuality == 1 then
                bNoMoveBack = true
            end
        end

        local currentAuto = state_machine.excute("fight_ui_update_fight_get_auto_state", 0, nil)

        -- 我方或地方只有一个英雄，并且放完必杀技后，不回位，如果对面人全死了，要回位
        if bNoMoveBack == true and currentAuto == true and nMasterCount > 0 and nMasterCount ~= nMasterDieCount then
            -- print("我方或地方只有一个英雄，并且放完必杀技后，不回位: " .. self._brole._head)
        else
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                table.insert(array, cc.MoveTo:create(duration * __fight_recorder_action_time_speed, self.parent._base_pos))
            else
                table.insert(array, cc.MoveBy:create(duration * __fight_recorder_action_time_speed, moveByPosition))
            end
        end

        table.insert(array, cc.CallFunc:create(checkMoveEventForChangeActionFuncN00))
        table.insert(array, cc.CallFunc:create(cleanAttackDataFuncN))
        -- self.moveBackArena = true
        -- self.move_state = self._move_state_enum._MOVE_STATE_MOVE_CAMP

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            if self.roleAttacking and true ~= self.parent._mirror and false == self.openAttackListener then
                self.parent._mirror = true
                self.parent:setScaleX(self.parent:getScaleX() * -1)
            end
        end
    else

    end
    if self.parent ~= nil then
        if self.parent ~= nil and self.moveBackArena == true then
            -- if math.floor(self.parent:getPositionY()) == math.floor(self.parent._base_pos.y) then
            --     self:cleanAttackData()
            -- else
            --     table.insert(array, cc.CallFunc:create(cleanAttackDataFuncN))
            -- end
        end
        if self._move_state_enum == nil then
            return
        end
        if state == self._move_state_enum._MOVE_STATE_VACANT
            then
            self.shadow:setVisible(true)
            -- print("事件类型：空闲状态")
            local function checkMoveEventForVacantFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    -- math.randomseed(tostring(os.time()):reverse():sub(1, 6))
                    local sCount = math.random(1, 5)
                    if sCount == 1 then
                        _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_WAIT
                    else
                        _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_FREE
                    end
                    state_machine.excute("fight_role_move_event", 0, _parent._self)

                    if true ~= _parent._self.isDeathRemove then
                        local armatureEffect = _parent._self.buffEffectList["79"]
                        if nil ~= armatureEffect then
                            _parent._self.armature:setVisible(false)
                            armatureEffect:setVisible(true)
                            local revivedDef = nil
                            revivedDef = armatureEffect._def
                            _parent._self:updateRevivedInfo(revivedDef)
                        end
                    end
                end
            end
            self.move_state = state
            table.insert(array, cc.DelayTime:create(3 * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForVacantFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_WAIT
            then
            self.shadow:setVisible(true)
            -->___rint("事件类型：待机状态")
            local function checkMoveEventForWaitFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            duration = self:getAnimationDuration(armature, actionIndex)
            table.insert(array, cc.DelayTime:create(duration * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForWaitFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_FREE
            then
            -->___rint("事件类型：自由移动状态")
            local function checkMoveEventForFreeFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._move_pos.x = _parent:getPositionX()
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_WAIT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            -- duration = self:getAnimationDuration(armature, actionIndex)
            -- table.insert(array, cc.DelayTime:create(duration * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForFreeFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_TARGET
            then    
            -->___rint("事件类型：寻找目录移动")
            -->>self.shadow:setVisible(false)
            local function checkMoveEventForTargetFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            duration = self:getAnimationDuration(armature, actionIndex)
            table.insert(array, cc.DelayTime:create(duration * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForTargetFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_STILL
            then     
            -->___rint("事件类型：静止状态")
            self.shadow:setVisible(true)
            local function checkMoveEventForStillFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            table.insert(array, cc.DelayTime:create(5 * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForStillFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_BACK_SCREEN
            then    
            -->___rint("事件类型：返回银屏内")
            self.move_state = state
        elseif state == self._move_state_enum._MOVE_STATE_MOVE_CAMP
            then
            -- print("事件类型：移动阵营")
            local function checkMoveEventForMoveCampFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._self.__cstart_fight = false
                    -- print("事件类型：移动阵营结束")
                    -- if _parent._self.moveBackArena == true then
                    --     _parent._self:cleanAttackData()
                    -- end

                    -- if _parent._self.roleAttacking == true then
                    --     _parent._self:cleanAttackData()
                    -- end

                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        if _parent._mirror then
                            _parent._mirror = false
                            _parent:setScaleX(_parent._self.parent:getScaleX() * -1) --TODO:wf 修改 【2663】 【KR】【跨服矿战】跨服矿战数码兽在第二场和第三场第一排最上方站位时，位置会反过来
                        end
                        _parent._self:showKillAddSp()
                    end

                    _parent._self:cleanAttackData()

                    FightRole.__g_role_attacking = false
                    FightRole.__g_lock_sp_attack = false

                    if self.isAddCampAttack then
                        FightRole.__g_lock_camp_attack = FightRole.__g_lock_camp_attack - 1
                        self.isAddCampAttack = false
                    end
                   
                    if true ~= _parent._self.isDeathRemove then
                        local armatureEffect = _parent._self.buffEffectList["79"]
                        if nil ~= armatureEffect then
                            _parent._self.armature:setVisible(false)
                            armatureEffect:setVisible(true)
                            local revivedDef = nil
                            revivedDef = armatureEffect._def
                            _parent._self:updateRevivedInfo(revivedDef)
                        end
                    end

                    _parent._move_pos.x = _parent._swap_pos.x
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                    state_machine.excute("fight_role_controller_play_power_skill_screen_effect", 0, {_role = _parent._self, _unload = true})
                    -- if 1 == _parent._self.roleCamp then
                    fwin:addService({
                        callback = function ( params )
                            
                            local isVisible = state_machine.excute("fight_qte_controller_start_qte_isVisible", 0, "")
                            if isVisible == false then
                                state_machine.excute("fight_role_controller_wake_up_beAttack_effect", 0, {isShow = true})
                            elseif isVisible == true then
                                -- print("有进度条不显示圆圈")
                            end

                        end,
                        delay = 0.2,
                        params = nil
                    })
                    -- end
                    if _parent._self._FightRoleController.isNeedChangeBattle == true then
                        _parent._self._FightRoleController.changeBattleDelay = 0
                    end
                end
            end
            self.move_state = state
            table.insert(array, cc.CallFunc:create(checkMoveEventForMoveCampFuncN))
        end
        if armature._nextAction ~= actionIndex then
            csb.animationChangeToAction(armature, actionIndex, actionIndex, false)
        end
        if #array > 0 then
            local seq = cc.Sequence:create(array)
            self.parent:stopAllActionsByTag(2)
            seq:setTag(2)
            self.parent:runAction(seq)
        end
    end
end

function FightRole:moveEvent()
    if self ~= nil and self.parent ~= nil and self.armature ~= nil and 
        self.armature._actionIndex == _enum_animation_l_frame_index.animation_fit_skill_attacking then
        return
    end

    if fightingMoveMode == 1 then
        return self:moveEventEx()
    end
    if self.parent == nil 
        or self.fight_over == true or self._move_state_enum == nil
        then
        return
    end

    if self.is_killed == true or self.is_deathed == true or self.roleWaitDeath == true then
        -- state_machine.excute("fight_role_be_killed", 0, self)
        return
    end

    if self.isInJumping == true then
        return
    end

    local moveDirection = 0  -- 0：左    1：右
    local line = self.current_attack_line
    local xx, yy = self.parent:getPosition()
    local pioneer = self:getCampPioneer(self.roleCamp)  -- 当前阵营最前方的角色
    local distance = 0
    local moveByPosition = cc.p(0, 0)
    local state = self.move_state

    local array = {}
    local duration = 0
    local armature = self.armature
    local actionIndex = _enum_animation_l_frame_index.animation_standby
    local flag = self.roleCamp == 0 and 1 or -1

    local moveCampBoundary, baseCampBoundary = state_machine.excute("fight_role_controller_update_camp_boundary", 0, {self, false, false, 0})

    -- 处理阵营整体的坐标
    if pioneer ~= nil and moveCampBoundary.x == baseCampBoundary.x and self.parent._swap_pos.x == self.parent._base_pos.x then
        local moveX = (moveCampBoundary.x - _battle_controller._camp_space * flag) - pioneer.parent._swap_pos.x
        if math.abs(moveX) > 0 then
            local _formation = self.roleCamp == 0 and self._FightRoleController._hero_formation 
                                or self._FightRoleController._master_formation
            for i, v in pairs(_formation) do
                if v ~= nil and v.parent ~= nil then
                    v.parent._swap_pos.x = v.parent._swap_pos.x + moveX
                    -- v.parent:setPositionX(v.parent._swap_pos.x)
                end
            end
        end

        if math.floor(self.parent._swap_pos.x) ~= math.floor(self.parent._move_pos.x) then    
            -- print("需要移动阵营：", self.roleCamp, self.parent._move_pos.x, self.parent._swap_pos.x, moveX, pioneer._info._pos)
            self.move_state = self._move_state_enum._MOVE_STATE_MOVE_CAMP
        end
    elseif self.move_state == self._move_state_enum._MOVE_STATE_WAIT then
    else
        if math.floor(self.parent._swap_pos.x) ~= math.floor(self.parent._move_pos.x) then
            self.move_state = self._move_state_enum._MOVE_STATE_MOVE_CAMP
        end
    end

    local function cleanAttackDataFuncN(_parent)
        if _parent ~= nil and _parent._self ~= nil then
            if _parent ~= nil and _parent._self.moveBackArena == true then
                if math.floor(_parent:getPositionY()) == math.floor(_parent._base_pos.y) then
                    self:cleanAttackData()
                end
            end
        end
    end

    if self.move_state == self._move_state_enum._MOVE_STATE_MOVE_CAMP
        then
        self.shadow:setVisible(true)
        state = self._move_state_enum._MOVE_STATE_MOVE_CAMP
        moveByPosition.x = moveByPosition.x + (self.parent._swap_pos.x - xx)
        local iw = _battle_controller._back_base_pos_cell_distance
        if moveByPosition.x < 0 then
            iw = -1 * iw
        else
            moveDirection = 1
        end
        
        -- actionIndex = _enum_animation_l_frame_index.animation_move
        if self.roleCamp == 1 then
            actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_pursue or _enum_animation_l_frame_index.animation_pursue_back
        else
            actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_pursue_back or _enum_animation_l_frame_index.animation_pursue
        end

        self.__meactionIndex = actionIndex
        actionIndex = _enum_animation_l_frame_index.animation_standby
        
        local function checkMoveEventForChangeActionFuncN00(_parent)
            if _parent ~= nil and _parent._self ~= nil then
                local mactionIndex = _parent._self.__meactionIndex
                if _parent._self.armature._nextAction ~= mactionIndex then
                    csb.animationChangeToAction(_parent._self.armature, mactionIndex, mactionIndex, false)
                end
            end
        end

        local function checkMoveEventForChangeActionFuncN01(_parent)
            if _parent ~= nil and _parent._self ~= nil then
                _parent._move_pos.x = _parent:getPositionX()
                if _parent._self.openAttackListener == true and _parent._self.__cstart_fight == true then
                    _parent._self.__cstart_fight = false
                    local currentFightData = self.fight_cacher_pool[1]
                    if currentFightData ~= nil then
                        local attData = currentFightData.__attData
                        if attData ~= nil then
                            local skillMouldId = tonumber(attData.skillMouldId)                    -- 技能模板id
                            local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
                            local spaceInfo = dms.atos(skillElementData, skill_mould.attack_scope)
                            local currSpace = math.abs(_parent._swap_pos.x - _parent:getPositionX())
                            local min_x = 0
                            local max_x = 0
                            if spaceInfo ~= nil then
                                spaceInfo = zstring.split(spaceInfo, ",")
                                if spaceInfo ~= nil and #spaceInfo == 2 then
                                    min_x = zstring.tonumber(spaceInfo[1])
                                    max_x = zstring.tonumber(spaceInfo[2])
                                end
                            end
                            if min_x >= currSpace and currSpace <= max_x  then
                                -- _parent._move_pos.x = _parent:getPositionX() -- _parent._swap_pos.x
                                _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                                -- -- state_machine.excute("fight_role_move_event", 0, _parent._self)
                                -- _parent:stopAllActions()
                                _parent:stopAllActionsByTag(2)
                                -- print("提前进入攻击")
                                -- return
                            end
                        end
                    end
                end
                csb.animationChangeToAction(_parent._self.armature, _enum_animation_l_frame_index.animation_standby, _enum_animation_l_frame_index.animation_standby, false)
            end
        end

        local _rwtime = math.random(_battle_controller._back_base_pos_start_min_wait_time, _battle_controller._back_base_pos_start_max_wait_time) / 1000

        while true do
            local its = 0
            local iexit = false
            if (math.abs(iw) * 1.2) > math.abs(moveByPosition.x) then
                its = moveByPosition.x
                iexit = true
                -- table.insert(array, cc.CallFunc:create(checkMoveEventForChangeActionFuncN01))
                -- break
            else
                its = iw
                moveByPosition.x = moveByPosition.x - iw
            end
            if _rwtime > 0 then
                _rwtime = 0
                table.insert(array, cc.CallFunc:create(cleanAttackDataFuncN))
                table.insert(array, cc.DelayTime:create(_rwtime * __fight_recorder_action_time_speed))
            end

            duration = self:getMoveAnimationDuration(armature, actionIndex, distance, its, 0)
            table.insert(array, cc.CallFunc:create(checkMoveEventForChangeActionFuncN00))
            table.insert(array, cc.MoveBy:create(duration * __fight_recorder_action_time_speed, cc.p(its, 0)))
            if self.isInJumping == false then
                if self.parent._swap_pos.y ~= self.parent:getPositionY() then
                    local moveY = self.parent._swap_pos.y - self.parent:getPositionY()
                    duration = self:getMoveAnimationDuration(armature, actionIndex, distance, 0, math.abs(moveY))
                    local moveBy = cc.MoveBy:create(duration * __fight_recorder_action_time_speed, cc.p(0, moveY))
                    moveBy:setTag(4)
                    self.parent:stopAllActionsByTag(4)
                    self.parent:runAction(moveBy)
                end
            end
            if iexit == true then
                break
            end
            table.insert(array, cc.CallFunc:create(checkMoveEventForChangeActionFuncN01))
            local _mwtime = math.random(_battle_controller._back_base_pos_moving_min_wait_time, _battle_controller._back_base_pos_moving_max_wait_time) / 1000
            table.insert(array, cc.CallFunc:create(cleanAttackDataFuncN))
            table.insert(array, cc.DelayTime:create(_mwtime * __fight_recorder_action_time_speed))
        end

        -- state = self._move_state_enum._MOVE_STATE_MOVE_CAMP
        -- -- moveByPosition.x = moveByPosition.x + (self.parent._swap_pos.x - self.parent._move_pos.x)
        -- moveByPosition.x = moveByPosition.x + (self.parent._swap_pos.x - xx)
        -- actionIndex = _enum_animation_l_frame_index.animation_move
        -- duration = self:getMoveAnimationDuration(armature, actionIndex, distance, moveByPosition.x, moveByPosition.y)
        -- table.insert(array, cc.MoveTo:create(duration * __fight_recorder_action_time_speed, self.parent._swap_pos))
    end

    if self.move_state == self._move_state_enum._MOVE_STATE_FREE
        then
        moveByPosition.x = moveByPosition.x + (self.parent._move_pos.x - xx)
        if math.abs(moveByPosition.x) < 12 then
            self.parent:setPositionX(xx + moveByPosition.x)
            moveByPosition.x = 0
        end
        if moveByPosition.x ~= 0 
            then
        else
            local iCount = math.random(0, 1)
            if iCount == 1
                then
                moveByPosition.x = _battle_controller._camp_space * flag
            else
                moveByPosition.x = -1 * _battle_controller._camp_attack_space * flag
            end
        end
        if moveByPosition.x < 0 then
        else
            moveDirection = 1
        end

        actionIndex = _enum_animation_l_frame_index.animation_move
        duration = self:getMoveAnimationDuration(armature, actionIndex, distance, moveByPosition.x, moveByPosition.y)
        table.insert(array, cc.MoveBy:create(duration * __fight_recorder_action_time_speed, moveByPosition))

        if self.roleCamp == 1 then
            actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_pursue or _enum_animation_l_frame_index.animation_pursue_back
        else
            actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_pursue_back or _enum_animation_l_frame_index.animation_pursue
        end
    end

    -- if state ~= self._move_state_enum._MOVE_STATE_MOVE_CAMP 
    --     and (self.moveBackArena == true
    --     -- or self.roleAttacking == true
    --     )
    --     then
    --     state = self._move_state_enum._MOVE_STATE_MOVE_CAMP
    -- end
    if self.parent ~= nil then
        if self.parent ~= nil and self.moveBackArena == true then
            if math.floor(self.parent:getPositionY()) == math.floor(self.parent._base_pos.y) then
                self:cleanAttackData()
            else
                table.insert(array, cc.CallFunc:create(cleanAttackDataFuncN))
            end
        end
        if self._move_state_enum == nil then
            return
        end
        if state == self._move_state_enum._MOVE_STATE_VACANT
            then
            self.shadow:setVisible(true)
            -->___rint("事件类型：空闲状态")
            local function checkMoveEventForVacantFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    -- math.randomseed(tostring(os.time()):reverse():sub(1, 6))
                    local sCount = math.random(1, 5)
                    if sCount == 1 then
                        _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_WAIT
                    else
                        _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_FREE
                    end
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            table.insert(array, cc.DelayTime:create(3 * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForVacantFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_WAIT
            then
            self.shadow:setVisible(true)
            -->___rint("事件类型：待机状态")
            local function checkMoveEventForWaitFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            duration = self:getAnimationDuration(armature, actionIndex)
            table.insert(array, cc.DelayTime:create(duration * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForWaitFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_FREE
            then
            -->___rint("事件类型：自由移动状态")
            local function checkMoveEventForFreeFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._move_pos.x = _parent:getPositionX()
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_WAIT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            -- duration = self:getAnimationDuration(armature, actionIndex)
            -- table.insert(array, cc.DelayTime:create(duration * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForFreeFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_TARGET
            then    
            -->___rint("事件类型：寻找目录移动")
            -->>self.shadow:setVisible(false)
            local function checkMoveEventForTargetFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            duration = self:getAnimationDuration(armature, actionIndex)
            table.insert(array, cc.DelayTime:create(duration * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForTargetFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_STILL
            then     
            -->___rint("事件类型：静止状态")
            self.shadow:setVisible(true)
            local function checkMoveEventForStillFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            table.insert(array, cc.DelayTime:create(5 * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(checkMoveEventForStillFuncN))
        elseif state == self._move_state_enum._MOVE_STATE_BACK_SCREEN
            then    
            -->___rint("事件类型：返回银屏内")
            self.move_state = state
        elseif state == self._move_state_enum._MOVE_STATE_MOVE_CAMP
            then
            -->___rint("事件类型：移动阵营")
            local function checkMoveEventForMoveCampFuncN(_parent)
                if _parent ~= nil and _parent._self ~= nil then
                    _parent._self.__cstart_fight = false
                    -->___rint("事件类型：移动阵营结束")
                    -- if _parent._self.moveBackArena == true then
                    --     _parent._self:cleanAttackData()
                    -- end

                    -- if _parent._self.roleAttacking == true then
                    --     _parent._self:cleanAttackData()
                    -- end

                    _parent._move_pos.x = _parent._swap_pos.x
                    _parent._self.move_state = _parent._self._move_state_enum._MOVE_STATE_VACANT
                    state_machine.excute("fight_role_move_event", 0, _parent._self)
                end
            end
            self.move_state = state
            table.insert(array, cc.CallFunc:create(checkMoveEventForMoveCampFuncN))
        end
        if armature._nextAction ~= actionIndex then
            csb.animationChangeToAction(armature, actionIndex, actionIndex, false)
        end

        if #array > 0 then
            local seq = cc.Sequence:create(array)
            self.parent:stopAllActionsByTag(2)
            seq:setTag(2)
            self.parent:runAction(seq)
        end
    end
end

-- 随机一个虚拟的网格进行移动
function FightRole:checkMoveToTileEvent()
    if self.moveEvent ~= nil then
        -- print("取消了非贴身战的移动")
        return self:moveEvent()
    end
    if self.parent == nil 
        then
        return
    end

    local size = self:getContentSize()
    local posx, posy = self:getPosition()
    local posIdx = tonumber(self._info._pos)

    -- if posIdx > 3 then
    --     if self.move_state ~= self._move_state_enum._MOVE_STATE_STILL then
    --         self.move_state = self._move_state_enum._MOVE_STATE_STILL
    --         return
    --     else
    --         self.move_state = self._move_state_enum._MOVE_STATE_WAIT
    --     end
    -- end

    -- 随机移动的数据
    local moveDirection = self._move_direction_enum._LEFT  -- 0：左    1：右
    local tileIndex = 0
    local array = {}
    local armature = self.armature
    local actionIndex = _enum_animation_l_frame_index.animation_standby
    local lastActionIndex = armature._actionIndex
    local duration = 0
    local start_tile_index = -1
    local end_tile_index = 2
    if self.roleCamp == 1 then
        start_tile_index = -2
        end_tile_index = 1
    end

    if self._sl_role ~= nil and self._sl_role.parent ~= nil then
        local sl__current_tile_index = self._sl_role._current_tile_index
        if (self.roleCamp == 0 and posIdx > 3) or (self.roleCamp == 1 and posIdx < 4) then
            end_tile_index = math.min(end_tile_index, end_tile_index + sl__current_tile_index)
        else
            start_tile_index = math.max(start_tile_index, start_tile_index + sl__current_tile_index)
        end
    end

    -- math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    tileIndex = math.random(start_tile_index, end_tile_index)

    self._wail_count = self._wail_count or 0

    if self.roleAttacking == true then
        self.move_state = self._move_state_enum._MOVE_STATE_FREE
        tileIndex = 0
        if end_tile_index > tileIndex then
            tileIndex = end_tile_index
        end
    end 

    local move_position = cc.p(self.parent._swap_pos.x + tileIndex * size.width, self.parent._swap_pos.y)
    if self.roleAttacking == true then
        local current_positionx, current_positiony = self.parent:getPosition()
        if math.abs(move_position.x - current_positionx) > _battle_controller._role_movd_smallest_distance then
            self._current_tile_index = tileIndex - 1
        else
            self._current_tile_index = tileIndex
        end
    end

    self.chanageMoveActions = false
    if self.move_state == self._move_state_enum._MOVE_STATE_STILL then
        self.move_state = self._move_state_enum._MOVE_STATE_VACANT
        table.insert(array, cc.DelayTime:create(3 * __fight_recorder_action_time_speed))
    elseif self._current_tile_index == tileIndex then
        self.move_state = self._move_state_enum._MOVE_STATE_WAIT

        -- duration = armature:getAnimation():getAnimationDuration(actionIndex)
        duration = self:getAnimationDuration(armature, actionIndex)

        table.insert(array, cc.DelayTime:create(duration * __fight_recorder_action_time_speed))
    else
        if move_position.x > posx then
            moveDirection = self._move_direction_enum._RIGHT
        else
            moveDirection = self._move_direction_enum._LEFT
        end
        
        self._wail_count = 0
        self.move_state = self._move_state_enum._MOVE_STATE_FREE

        if self.roleAttacking == true then
            -- actionIndex = _enum_animation_l_frame_index.animation_onrush_back
        else
            if self.roleCamp == 1 then
                actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_move or _enum_animation_l_frame_index.animation_move_back
            else
                actionIndex = moveDirection == self._move_direction_enum._LEFT and _enum_animation_l_frame_index.animation_move_back or _enum_animation_l_frame_index.animation_move
            end
        end
        local tileCount = math.abs(tileIndex - self._current_tile_index)
        self._current_tile_index = tileIndex
        if self.roleAttacking == true then
            local actionType = dms.atoi(armature._sed_action, skill_mould.attack_move_mode)  -- 角色的移动帧组
            actionIndex = actionType == 0 and _enum_animation_l_frame_index.animation_onrush_back or _enum_animation_l_frame_index.animation_pursue_back
            
            local cposx, cposy = self.parent:getPosition()
            local distancex = math.abs(move_position.x - cposx)
            local distancey = math.abs(move_position.y - cposy)
            local distance = math.max(distancex, distancey)
            if actionType > 0 then
                duration = self:getAnimationDuration(armature, actionIndex)
            else
                duration = self:getMoveAnimationDuration(armature, actionIndex, distance, distancex, distancey)
            end
            -->___rint(distance, distancex, distancey, duration, actionIndex)
        else
            -- duration = armature:getAnimation():getAnimationDuration(actionIndex) * tileCount
            duration = self:getAnimationDuration(armature, actionIndex) * tileCount
        end

        table.insert(array, cc.MoveTo:create(duration * __fight_recorder_action_time_speed, move_position))
    end

    -- armature._actionIndex = actionIndex
    -- armature._nextAction = actionIndex
    -- if lastActionIndex ~= actionIndex then
    --     local _invoke = armature._invoke
    --     armature._invoke = nil
    --     armature:getAnimation():playWithIndex(actionIndex)
    --     armature._invoke = _invoke
    -- end
    csb.animationChangeToAction(armature, actionIndex, actionIndex, false)

    local function checkMoveToTileEventMoveOverFuncN(_parent)
        if _parent ~= nil and _parent._self ~= nil then
            if _parent._self.moveBackArena == true then
                _parent._self:cleanAttackData()
            end

            if _parent._self.roleAttacking == true then
                _parent._self:cleanAttackData()
            end
            if _parent._self.move_state == _parent._self._move_state_enum._MOVE_STATE_FREE then
                -- _parent._self.chanageMoveActions = true

                local infoPos = zstring.tonumber(_parent._self._info._pos)
                if infoPos > 3 then
                    self.move_state = self._move_state_enum._MOVE_STATE_STILL
                else
                    self.move_state = self._move_state_enum._MOVE_STATE_VACANT
                end

                state_machine.excute("fight_role_check_move_event", 0, _parent._self)
            else
                state_machine.excute("fight_role_check_move_event", 0, _parent._self)
            end
        end
    end
    table.insert(array, cc.CallFunc:create(checkMoveToTileEventMoveOverFuncN))
    local seq = cc.Sequence:create(array)

    if self.parent ~= nil then
        self.parent:stopAllActionsByTag(2)
        seq:setTag(2)
        self.parent:runAction(seq)
    end
end

-- 随机距离进行移动
function FightRole:checkMoveEvent()
    if self.checkMoveToTileEvent ~= nil then
        return self:checkMoveToTileEvent()
    end

    if self.parent == nil 
        -- or self.roleAttacking == true
        -- or self.roleByAttacking == true
        -- or self.moveBackArena == true
        then
        -->___rint("**(((((((((******)))))))", self.parent, self.moveBackArena)
        return
    end

    -- 随机移动的数据
    local moveDirection = 0  -- 0：左    1：右
    local moveHeight = 0
    local moveOffsetX = 0
    local halfWidth = (fwin._width - app.baseOffsetX) / 2
    local array = {}
    local armature = self.armature

    local size = self:getContentSize()

    -- math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    moveDirection = math.random(0, 1)
    moveHeight = math.random(0, size.width * 3)

    local flag = 1
    if moveDirection == 0 then
        flag = -1
    end

    if self.roleCamp == 1 then
        local ml = self.parent._swap_pos.x - 64
        local mr = self.parent._swap_pos.x + 64
        moveOffsetX = self.parent._swap_pos.x + flag * moveHeight
        moveOffsetX = math.max(ml, math.min(moveOffsetX, mr))
        if moveOffsetX == halfWidth or moveOffsetX == mr then
            moveOffsetX = moveOffsetX + flag * math.random(1, 25)
        end
    else
        local ml = self.parent._swap_pos.x - 64
        local mr = self.parent._swap_pos.x + 64
        moveOffsetX = self.parent._swap_pos.x + flag * moveHeight
        moveOffsetX = math.max(ml, math.min(moveOffsetX, mr))
        if moveOffsetX == ml or moveOffsetX == mr then
            moveOffsetX = moveOffsetX + flag * math.random(1, 25)
        end
    end

    local rnumber = math.random(0, 3)

    self._wail_count = self._wail_count or 0

    self.chanageMoveActions = false
    self.move_state = self._move_state_enum._MOVE_STATE_VACANT

    local actionIndex = _enum_animation_l_frame_index.animation_standby
    if (rnumber == 1) and self.roleAttacking ~= true and self._wail_count < 2 then
        self.move_state = self._move_state_enum._MOVE_STATE_STILL
        self._wail_count = self._wail_count + 1
        table.insert(array, cc.DelayTime:create(1.5 * __fight_recorder_action_time_speed))

        local lastActionIndex = armature._actionIndex
        armature._actionIndex = actionIndex
        armature._nextAction = actionIndex
        if lastActionIndex ~= actionIndex then
            armature:getAnimation():playWithIndex(actionIndex)
        end
    else
        self._wail_count = 0
        self.move_state = self._move_state_enum._MOVE_STATE_FREE
        if self.roleAttacking == true then
            table.insert(array, cc.MoveTo:create(1/60.0 * (math.abs(math.abs(self.parent:getPositionX()) - math.abs(moveOffsetX))/4) * __fight_recorder_action_time_speed, cc.p(moveOffsetX, self.parent._swap_pos.y)))
        else
            table.insert(array, cc.MoveTo:create(1/60.0 * (math.abs(math.abs(self.parent:getPositionX()) - math.abs(moveOffsetX))/4) * __fight_recorder_action_time_speed, cc.p(moveOffsetX, self.parent:getPositionY())))
        end

        if self.roleCamp == 1 then
            actionIndex = moveDirection == 0 and _enum_animation_l_frame_index.animation_move or _enum_animation_l_frame_index.animation_move_back
        else
            actionIndex = moveDirection == 0 and _enum_animation_l_frame_index.animation_move_back or _enum_animation_l_frame_index.animation_move
        end

        local lastActionIndex = armature._actionIndex
        armature._actionIndex = actionIndex
        armature._nextAction = actionIndex
        if lastActionIndex ~= actionIndex then
            armature:getAnimation():playWithIndex(actionIndex)
        end
    end

    local function checkMoveEventMoveOverFuncN(_parent)
        if _parent ~= nil and _parent._self ~= nil then
            if _parent._self.moveBackArena == true then
                _parent._self:cleanAttackData()
            end

            if _parent._self.roleAttacking == true then
                _parent._self:cleanAttackData()
            end
            if _parent._self.move_state == _parent._self._move_state_enum._MOVE_STATE_FREE then
                -- _parent._self.chanageMoveActions = true
                state_machine.excute("fight_role_check_move_event", 0, _parent._self)
            else
                state_machine.excute("fight_role_check_move_event", 0, _parent._self)
            end
        end
    end
    table.insert(array, cc.CallFunc:create(checkMoveEventMoveOverFuncN))
    local seq = cc.Sequence:create(array)

    if self.parent ~= nil then
        self.parent:stopAllActionsByTag(2)
        self.parent:runAction(seq)
    end

end

function FightRole:waitByAttack()
    self.parent:stopAllActionsByTag(2)
    if self.repelAndFlyEffectCount > 0 then
    else
        -- self.armature._nextAction = _enum_animation_l_frame_index.animation_standby
        -- self.armature:getAnimation():playWithIndex(_enum_animation_l_frame_index.animation_standby)
        local actionIndex = _enum_animation_l_frame_index.animation_standby
        if self.is_dizziness == true then
            actionIndex = _enum_animation_l_frame_index.animation_dizziness
        end
        self.armature._actionIndex = actionIndex
        self.armature._nextAction = actionIndex
        csb.animationChangeToAction(self.armature, actionIndex, actionIndex, false)
    end
end

function FightRole:lockAttackTarget(instantLockAttackTarget)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    
    if instantLockAttackTarget == true then
        if self.current_attack_line == -1 then
            self.instantLockAttackTarget = false
            return true
        else
            self.instantLockAttackTarget = instantLockAttackTarget or false
            -- 移动到攻击者的对面
            local __skf = self.current_fight_data.__skf
            local defenderList = self.current_fight_data.__defenderList
            if defenderList ~= nil then
                local lockRole = nil
                for i, v in pairs(defenderList) do
                    if v.roleCamp ~= self.roleCamp then
                        lockRole = v
                        break
                    end
                end
                if lockRole ~=nil then
                    -- for i, v in pairs(defenderList) do
                    --     v.roleByAttacking = true
                    -- end
                    -- self.roleAttacking = true

                    self.parent:stopAllActionsByTag(2)

                    if self.current_attack_line ~= lockRole.current_attack_line and false then
                        local  my = 0 -- 100 * (self.current_attack_line - lockRole.current_attack_line)
                        local flag = -1
                        if self.roleCamp == 1 then
                            flag = 1
                        end
                        local size = self:getContentSize()
                        local mx = math.random(size.width, size.width * 3)
                        local array = {}

                        local function lockActtackTargetMoveEventMoveOverFuncN(_parent)
                            if _parent ~= nil and _parent._self ~= nil then
                                -- print("锁定目标线移动结束。")
                                self:executeHeroMoveToTarget()
                            end
                        end
                        local offsetX = self.parent:getPositionX() + flag * mx
                        offsetX = math.max(0, math.min(offsetX, (fwin._width - app.baseOffsetX) - size.width))
                        table.insert(array, cc.MoveTo:create(0.5 * __fight_recorder_action_time_speed, cc.p(offsetX, self.parent:getPositionY() + my)))
                        table.insert(array, cc.CallFunc:create(lockActtackTargetMoveEventMoveOverFuncN))
                        local seq = cc.Sequence:create(array)
                        self.parent:runAction(seq)
                        
                        -- self.armature._nextAction = _enum_animation_l_frame_index.animation_move_back
                        self.armature._invoke = nil
                        self.armature._actionIndex = _enum_animation_l_frame_index.animation_move_back
                        self.armature._nextAction = _enum_animation_l_frame_index.animation_standby
                        self.armature:getAnimation():playWithIndex(self.armature._actionIndex)
                        self.armature._invoke = self.changeActionCallback

                        self.current_attack_line = lockRole.current_attack_line
                    else
                        self:executeHeroMoveToTarget()
                    end
                    return false
                else
                    -->___rint("没有匹配上承受方")
                end
            end
        end
    else
        return true
    end
    return true
end

function FightRole:moveCamp(moveX)
    local _formation = self.roleCamp == 0 and self._FightRoleController._hero_formation 
                        or self._FightRoleController._master_formation
    for i, v in pairs(_formation) do
        if v ~= nil and v.parent ~= nil then
            v.parent._swap_pos.x = v.parent._swap_pos.x + moveX
        end
    end

    _formation = self.roleCamp == 1 and self._FightRoleController._hero_formation 
                        or self._FightRoleController._master_formation
    for i, v in pairs(_formation) do
        if v ~= nil and v.parent ~= nil then
            v.parent._swap_pos.x = v.parent._swap_pos.x + moveX
        end
    end
end

-- 攻击移动
function FightRole:changeActtackToAttackMoving()
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end

    local function acttackMoveEventMoveOverFuncN(_parent)
        if _parent ~= nil and _parent._self ~= nil then
            -- print("攻击前的移动结束")
            if _parent._self.pursuit_target ~= nil then
                -- _parent._self.pursuit_target.parent:stopAllActionsByTag(2)
                -- if _parent._self.pursuit_target.repelAndFlyEffectCount > 0 then
                --     _parent._self.pursuit_target.parent:stopAllActionsByTag(100)
                --     _parent._self.pursuit_target.parent:stopAllActionsByTag(101)
                --     _parent._self.pursuit_target.repelAndFlyEffectCount = _parent._self.pursuit_target.repelAndFlyEffectCount - 1
                -- end
                -- if _parent._self.current_fight_data ~= nil then
                --     local defenderList = _parent._self.current_fight_data.__defenderList
                --     for i, v in pairs(defenderList) do
                --         if v.roleCamp ~= nil and tonumber(v.roleCamp) ~= tonumber(_parent._self.roleCamp) and
                --           v ~= nil and v.parent ~= nil then
                --             v.parent:stopAllActionsByTag(2)
                --             if v.repelAndFlyEffectCount > 0 then
                --                 v.parent:stopAllActionsByTag(100)
                --                 v.parent:stopAllActionsByTag(101)
                --                 v.repelAndFlyEffectCount = v.repelAndFlyEffectCount - 1
                --             end
                --         end
                --     end
                -- end

                local xx, yy = _parent._self.pursuit_target.parent:getPosition()
                local xx1, yy1 = _parent:getPosition()
                _parent._self.pursuit_action = nil
                _parent._self.pursuit_target = nil
                _parent._self.ghostIndex = 0
                _parent._self.jumpOffsetY = _parent:getPositionY() - _parent._swap_pos.y
                -- _parent._self:executeAttacking()
            elseif _parent._self.pursuit_line_action ~= nil then
                _parent._self.pursuit_line_action = nil
                _parent._self.pursuit_line_target = nil
                _parent._self:changeActtackToAttackBegan(_parent._self.armature)
            else
                _parent._self:changeActtackToAttackBegan(_parent._self.armature)
            end
        end
    end

    local function acttackMoveEventMoveOverFuncN1(_parent)
        if _parent ~= nil and _parent._self ~= nil then
            local armatureEffect = _parent._self:createEffect("bishabaoqi", "sprite/effect_")
            armatureEffect._self = _parent._self
            armatureEffect._invoke = function ( armatureBack )
                acttackMoveEventMoveOverFuncN(armatureEffect._self.parent)
                armatureEffect._self.__deleteEffectFile(armatureBack)
            end

            local size = _parent._self:getContentSize()
            -- armatureEffect:setPosition(cc.p(size.width / 2, 0))
            armatureEffect:setPosition(cc.p(_parent._self.parent:getPosition()))
            _parent._self.parent:getParent():addChild(armatureEffect, 2000000)
            csb.animationChangeToAction(armatureEffect._self.armature, _enum_animation_l_frame_index.animation_standby, _enum_animation_l_frame_index.animation_standby, false)
        end
    end

    local function acttackMoveEventMoveOverFuncN2(_parent)
        if _parent ~= nil and _parent._self ~= nil then
            local armatureEffect = _parent._self:createEffect("bishabaoqi", "sprite/effect_")
            armatureEffect._self = _parent._self
            armatureEffect._invoke = _parent._self.__deleteEffectFile

            local size = _parent._self:getContentSize()
            -- armatureEffect:setPosition(cc.p(size.width / 2, 0))
            armatureEffect:setPosition(cc.p(_parent._self.parent:getPosition()))
            _parent._self.parent:getParent():addChild(armatureEffect, 2000000)
        end
    end

    local movespeed = 1
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        -- or __lua_project_id == __lua_project_l_naruto 
        then
        movespeed = 2
    end
    
    local armature = self.armature
    local actionType = dms.atoi(armature._sed_action, skill_mould.attack_move_mode)  -- 角色的移动帧组
    local actionIndex = actionType == 0 and _enum_animation_l_frame_index.animation_onrush or _enum_animation_l_frame_index.animation_pursue
    csb.animationChangeToAction(armature, actionIndex, actionIndex, false)

    local distancex = math.abs(self.moveByPosition.x)
    local distancey = math.abs(self.moveByPosition.y)
    local distance = math.max(distancex, distancey)
    local duration = 0
    if actionType > 0 then
        duration = self:getAnimationDuration(armature, actionIndex)
    else
        duration = self:getMoveAnimationDuration(armature, actionIndex, distance, distancex, distancey)
    end
    
    local xx, yy = self.parent:getPosition()
    -- 追击的时候修正其位移
    local isJump = dms.atoi(armature._sed_action, skill_mould.is_jump)
    local skillQuality = dms.atoi(armature._sed_action, skill_mould.skill_quality)  -- 技能类型(0:普通 1:怒气)
    self.jumpOffsetY = 0
    local base_swap_posY = self.parent._swap_pos.y
    if self.lockRole ~= nil and self.lockRole.parent ~= nil then
        if tonumber(isJump) == 1 and base_swap_posY < self.lockRole.parent._swap_pos.y then
            local lxx, lyy = self.lockRole.parent:getPosition()
            local offsetY = lyy - self.lockRole.parent._swap_pos.y 
            if offsetY > _battle_controller._air_pursuit_min_height then
                self.moveByPosition.y = self.moveByPosition.y + offsetY
                self.jumpOffsetY = offsetY
                duration = duration / 0.5
                -- if self._mdx > 0 then
                --     local mx = self._mdx - lxx
                --     mx = mx / 2
                --     self.moveByPosition.x = lxx + mx
                --     self.moveByPosition.x = self.moveByPosition.x - xx
                -- end
                self.pursuit_target = self.lockRole
                self.pursuit_action = cc.MoveTo:create(duration, cc.p(lxx, lyy))

                self.jumpAttackPosHeight = self.parent._base_pos.y - self.lockRole.parent._base_pos.y

                self.armature._reset = function(armatureBack)
                    if armatureBack._nextAction == _enum_animation_l_frame_index.animation_standby or
                        armatureBack._nextAction == _enum_animation_l_frame_index.animation_pursue_back then
                        self.parent:stopAllActionsByTag(4)
                        self.parent:stopAllActionsByTag(2)
                        armatureBack._reset = nil
                        -- if self.jumpOffsetY ~= nil and self.jumpOffsetY > 0 then
                        --     self.waitJumpBack = true
                        -- end
                        local jumpOffsetY = armatureBack._self.parent._move_pos.y - armatureBack._self.parent:getPositionY()
                        if (armatureBack._self.jumpOffsetY ~= nil and armatureBack._self.jumpOffsetY ~= 0) or jumpOffsetY ~= 0 then
                            armatureBack._self.isInJumping = true
                            armatureBack._self.jumpOffsetY = jumpOffsetY
                            -- local function jumpOffsetChangeActionCallback(_parent)
                            --     if _parent ~= nil and _parent._self ~= nil then
                            --         local actionIndex = _enum_animation_l_frame_index.animation_attack_jump_back
                            --         csb.animationChangeToAction(_parent._self.armature, actionIndex, actionIndex, false)
                            --     end
                            -- end
                            local function jumpOffsetCallback(sender)
                                local _self = sender._self
                                if _self ~= nil then
                                    _self.jumpOffsetY = 0
                                    _self.jumpAttackPosHeight = 0
                                    local waitJumpOver = _self.waitJumpOver
                                    _self.waitJumpOver = false
                                    _self.waitJumpBack = false
                                    _self.isInJumping = false
                                    -- local actionIndex = _enum_animation_l_frame_index.animation_standby
                                    -- csb.animationChangeToAction(_self.armature, actionIndex, actionIndex, false)
                                    if waitJumpOver == true then
                                        _self:checkAttackEnd()
                                    end
                                end
                            end
                            local duration = armatureBack._self:getMoveAnimationDuration(armature, actionIndex, distance, 0, armatureBack._self.jumpOffsetY)
                            armatureBack._self.jumpOffsetY = 0
                            armatureBack._self.waitJumpBack = true
                            local actionIndex = _enum_animation_l_frame_index.animation_attack_jump_back
                            csb.animationChangeToAction(armatureBack, actionIndex, actionIndex, false)
                            local jumpBackY = armatureBack._self.parent._move_pos.y - armatureBack._self.jumpAttackPosHeight
                            armatureBack._self.parent:runAction(cc.Sequence:create(
                                    -- cc.MoveBy:create(duration * __fight_recorder_action_time_speed, cc.p(0, -1 * armatureBack._self.jumpOffsetY)),
                                    -- cc.MoveBy:create(duration * __fight_recorder_action_time_speed, cc.p(0, armatureBack._self.jumpOffsetY)),
                                    -- cc.CallFunc:create(jumpOffsetChangeActionCallback),
                                    -- cc.EaseSineIn:create(cc.MoveTo:create(duration * __fight_recorder_action_time_speed, cc.p(armatureBack._self.parent._base_pos.x, armatureBack._self.parent._move_pos.y))),
                                    cc.EaseSineIn:create(cc.MoveTo:create(duration * __fight_recorder_action_time_speed, cc.p(armatureBack._self.parent:getPositionX(), jumpBackY))),
                                    cc.CallFunc:create(jumpOffsetCallback)
                                ))
                        end
                    end
                end
            end
        else
            self.pursuit_line_target = self.lockRole
            self.pursuit_line_action = cc.MoveTo:create(duration * __fight_recorder_action_time_speed / movespeed, self.moveByPosition)
        end
    end
    -- self.lockRole = nil
    self.foucsRole = self.lockRole
    if fightingMoveMode == 1 then
    else
        local moveCampBoundary, baseCampBoundary = state_machine.excute("fight_role_controller_update_camp_boundary", 0, {self, false, false, 0})

        local pioneer = self:getCampPioneer(self.roleCamp)  -- 当前阵营最前方的角色
        if pioneer ~= nil and math.floor(pioneer._info._pos / 4) == math.floor(self._info._pos / 4) then
            local flag = self.roleCamp == 0 and 1 or -1
            xx = xx + self.moveByPosition.x
     
            local moveX = xx - (moveCampBoundary.x - _battle_controller._camp_space * flag)
            -- local mpioneer = self:getCampPioneer((self.roleCamp + 1) % 2, 1)  -- 当前阵营最前方的角色
            local mpioneer = self:getCampPioneer(self.roleCamp, 1)  -- 当前阵营最前方的角色
            if mpioneer ~= nil and mpioneer.roleCamp == 0 and (mpioneer.parent._swap_pos.x + moveX) < _battle_controller._back_base_pos_distance then
                moveX = _battle_controller._back_base_pos_distance - mpioneer.parent._swap_pos.x
            elseif mpioneer ~= nil and mpioneer.roleCamp == 1 and (mpioneer.parent._swap_pos.x + moveX) > (baseCampBoundary.x * 2 - _battle_controller._back_base_pos_distance) then
                moveX = (baseCampBoundary.x * 2 - _battle_controller._back_base_pos_distance) - mpioneer.parent._swap_pos.x
            end
            moveCampBoundary.x = moveCampBoundary.x + moveX
            state_machine.excute("fight_role_controller_update_camp_boundary", 0, {self, false, true, moveCampBoundary.x})
            self:moveCamp(moveX)
        end
    end
    if self.lockRole ~= nil and self.lockRole.parent ~= nil and tonumber(isJump) == 1 and 
        self.jumpOffsetY >= _battle_controller._air_pursuit_min_height then
        self.lockRole.parent:stopAllActionsByTag(2)
        if self.lockRole.repelAndFlyEffectCount > 0 then
            self.lockRole.parent:stopAllActionsByTag(100)
            self.lockRole.parent:stopAllActionsByTag(101)
            self.lockRole.repelAndFlyEffectCount = self.lockRole.repelAndFlyEffectCount - 1
        end
        if self.current_fight_data ~= nil then
            local defenderList = self.current_fight_data.__defenderList
            for i, v in pairs(defenderList) do
                if v.roleCamp ~= nil and tonumber(v.roleCamp) ~= tonumber(self.roleCamp) and
                  v ~= nil and v.parent ~= nil then
                    v.parent:stopAllActionsByTag(2)
                    if v.repelAndFlyEffectCount > 0 then
                        v.parent:stopAllActionsByTag(100)
                        v.parent:stopAllActionsByTag(101)
                        v.repelAndFlyEffectCount = v.repelAndFlyEffectCount - 1
                    end
                end
            end
        end
    end

    local array = {}
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        -- 取消了空中，移动追击的效果
        if nil ~= self.moveByPosition then
            self.pursuit_action = nil
            self.pursuit_target = nil
            self.pursuit_line_action = nil
            table.insert(array, cc.MoveBy:create(duration * __fight_recorder_action_time_speed / movespeed, self.moveByPosition))
        elseif nil ~= self.foucsRole then
            self.pursuit_action = nil
            self.pursuit_target = nil
            self.pursuit_line_action = nil

            local xx, yy = self.foucsRole.parent._base_pos.x, self.foucsRole.parent._base_pos.y

            local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
            local min_x = 0
            local max_x = 0
            if spaceInfo ~= nil then
                spaceInfo = zstring.split(spaceInfo, ",")
                if spaceInfo ~= nil and #spaceInfo == 2 then
                    min_x = zstring.tonumber(spaceInfo[1])
                    max_x = zstring.tonumber(spaceInfo[2])
                end
            end
            if self.foucsRole.roleCamp == 0 then
                xx = xx + min_x
            else
                xx = xx - min_x
            end
            distancex = xx - self.parent:getPositionX()
            distancey = 0
            distance = math.max(distancex, distancey)
            duration = self:getMoveAnimationDuration(armature, actionIndex, distance, distancex, distancey)
            table.insert(array, cc.MoveBy:create(duration * __fight_recorder_action_time_speed / movespeed, cc.p(xx - self.parent:getPositionX(), self.moveByPosition.y)))
        else
            if self.pursuit_action ~= nil then
                table.insert(array, self.pursuit_action)
            elseif self.pursuit_line_target ~= nil and nil ~= self.pursuit_line_action then
                table.insert(array, self.pursuit_line_action)
            else
                table.insert(array, cc.MoveBy:create(duration * __fight_recorder_action_time_speed / movespeed, self.moveByPosition))
            end
        end
    else
        if self.pursuit_action ~= nil then
            table.insert(array, self.pursuit_action)
        elseif self.pursuit_line_target ~= nil then
            table.insert(array, self.pursuit_line_action)
        else
            table.insert(array, cc.MoveBy:create(duration * __fight_recorder_action_time_speed, self.moveByPosition))
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        if skillQuality == 1 then
            table.insert(array, cc.CallFunc:create(acttackMoveEventMoveOverFuncN2))
            table.insert(array, cc.CallFunc:create(acttackMoveEventMoveOverFuncN))
        else
            table.insert(array, cc.CallFunc:create(acttackMoveEventMoveOverFuncN))
        end
    else
        table.insert(array, cc.CallFunc:create(acttackMoveEventMoveOverFuncN))
    end

    local seq = cc.Sequence:create(array)
    self.parent:runAction(seq)
    if self.pursuit_target ~= nil then
        self:changeActtackToAttackBegan(self.armature)
    end
end

-- 播放神兽攻击光效
function FightRole:executeAnimalAttackEffect(skillInfluenceElementData)
    local posterior_lighting_effect_idss = zstring.splits(dms.atos(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id), "|", ",", function (value) return tonumber(value) end)
    local posterior_lighting_effect_ids = posterior_lighting_effect_idss[1]
    local posterior_lighting_effect_id = posterior_lighting_effect_ids[1]

    if posterior_lighting_effect_id > 0 then
        local armatureEffect = self:createEffect(posterior_lighting_effect_id, "sprite/effect_")
        armatureEffect._self = self
        armatureEffect._invoke = deleteEffectFile

        self:addChild(armatureEffect)

        local sx, sy = self:getPosition()
        armatureEffect:setPosition(cc.p(sx, sy))
        if self.roleCamp == 1 then
            armatureEffect:setScaleX(1)
        else
            armatureEffect:setScaleX(-1)
        end
    end
end

-- 开始打击 普攻/技能
function FightRole:changeActtackToAttackBegan(armatureBack)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    local armature = armatureBack
    -- armature._actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
    -- armature._nextAction = _enum_animation_l_frame_index.animation_skill_attacking
    -- armature:getAnimation():playWithIndex(armature._actionIndex)

    -- local actionIndexs = zstring.split(dms.atos(armature._sie_action, skill_influence.before_action), ",")
    -- local actionIndex = zstring.tonumber(actionIndexs[self.roleCamp] or actionIndexs[1])

    -- local armature = armatureBack
    -- if actionIndex == nil or actionIndex < 0 then
    --     armature._actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
    --     armature._nextAction = _enum_animation_l_frame_index.animation_skill_attacking
    --     armature:getAnimation():playWithIndex(armature._actionIndex)
    -- else
    --     armature:getAnimation():playWithIndex(actionIndex)
    --     armature._actionIndex = actionIndex
    --     armature._nextAction = actionIndex
    -- end

    -- 攻击方在还是承受方的时候，技能效用数据会被改写，所以再次赋值
    self.current_fight_data = self.current_fight_data_attacker
    self.armature._sed_action = self.armature._sed_action_attacker
    self.armature._sie_action = self.armature._sie_action_attacker
    local skillInfluenceId = self.current_fight_data.__skf.skillInfluenceId
    local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
    self.armature._sie_action = skillInfluenceElementData

    -->___crint("切换到角色攻击动作", armature._sie_action)
    local skillCategory = dms.atoi(armature._sie_action, skill_influence.skill_category)
    -->___rint(armature._sie_action)
    if skillCategory ~= 0 and skillCategory ~= 1 and skillCategory ~= 34 and skillCategory ~= 35 then
        -->___rint("不需要调用攻击动作帧组", skillCategory)
        self:executeAnimationSkillAttacking(self.armature)
        return
    else
        -->___rint("需要调用攻击动作帧组", skillCategory)
    end

    if self.skillQuality == 1 then
        self.armature._role._sp = 0
        showRoleSP(self.armature)
    end

    -- 调用神兽攻击光效
    if self._isAnimal == true then
        self:executeAnimalAttackEffect(skillInfluenceElementData)
    end
    
    local actionIndexs = zstring.split(dms.atos(armature._sie_action, skill_influence.after_action), ",")
    local actionIndex = zstring.tonumber(actionIndexs[self.roleCamp] or actionIndexs[1])
    local armature = armatureBack
    if actionIndex == nil then
        actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
    end
    local isJump = dms.atoi(armature._sed_action, skill_mould.is_jump)
    local skillQuality = dms.atoi(self.armature._sed_action, skill_mould.skill_quality)  -- 技能类型(0:普通 1:怒气)
    if self.lockRole ~= nil and self.lockRole.parent ~= nil then
        local offsetY = self.lockRole.parent:getPositionY() - self.lockRole.parent._move_pos.y or -99999
        if offsetY > _battle_controller._air_pursuit_min_height then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                -- 取消龙虎门浮空追击的动作组调用
            else
                if skillQuality == 0 then
                    actionIndex = _enum_animation_l_frame_index.animation_attack_normal_in_the_sky
                else
                    if actionIndex == _enum_animation_l_frame_index.animation_new_skill_31_ji1 then
                        actionIndex = _enum_animation_l_frame_index.animation_new_skill_36_ji1
                    elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_32_ji2 then
                        actionIndex = _enum_animation_l_frame_index.animation_new_skill_37_ji2
                    elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_33_ji3 then
                        actionIndex = _enum_animation_l_frame_index.animation_new_skill_38_ji3
                    elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_34_ji4 then
                        actionIndex = _enum_animation_l_frame_index.animation_new_skill_39_ji4
                    elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_35_ji5 then
                        actionIndex = _enum_animation_l_frame_index.animation_new_skill_40_ji5
                    else
                        actionIndex = _enum_animation_l_frame_index.animation_attack_skill_in_the_sky
                    end
                end
            end
        end

        if __lua_project_id == __lua_project_l_naruto then
            if skillQuality >= 1 then
                local armatureEffect = self:createEffect("shifang")
                armatureEffect._invoke = deleteEffectFile

                local size = self:getContentSize()
                -- armatureEffect:setPosition(cc.p(size.width / 2, 0))
                armatureEffect:setPosition(cc.p(self.parent:getPosition()))
                self.parent:getParent():addChild(armatureEffect, kZOrderInFightScene_Effect)
            end
        end
                
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            if skillQuality == 1 then
                local musicId = dms.atoi(armature._sie_action, skill_influence.forepart_lighting_sound_effect_id)
                -- print("播放音效（forepart_lighting_sound_effect_id）: ", musicId)
                if musicId > 0 then
                    playEffectMusic(musicId)
                end
            end
        end
    end
    
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
    else
        self.shadow:setVisible(false)
    end
    self.lockRole = nil

    -- if actionIndex > 16 then
    --     actionIndex = 16
    -- end

    -- local __invoke = armature._invoke
    -- armature._invoke = nil
    -- armature:getAnimation():playWithIndex(actionIndex)
    -- armature._invoke = __invoke
    -- -- armature._actionIndex = actionIndex
    -- armature._nextAction = actionIndex

    if actionIndex > 0 then
        armature._actionIndex = actionIndex
        armature._nextAction = actionIndex
        armature:getAnimation():playWithIndex(actionIndex)
    else
        self:executeAnimationSkillAttacking(armature)
    end
    -->___crint("切换到角色攻击动作1", actionIndex)
    if self.fitAttacking == true then
        -->___crint("actionIndex___:", actionIndex)
    end

    -- local camp = zstring.tonumber(armature._camp) + 1
    -- --> -->___rint("dms.atos(armature._sie_action, skill_influence.before_action):", dms.atos(armature._sie_action, skill_influence.before_action))
    -- local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.before_action), ",")
    -- local actionIndex = zstring.tonumber(indexs[camp])
    -- armature._nextAction = _enum_animation_l_frame_index.animation_onrush -- actionIndex
    -- -- armature._invoke = attackChangeActionCallback
    -- --> -->___rint("进入攻击前段：", actionIndex)

    -- local forepart_lighting_sound_effect_id = dms.atoi(armature._sie_action, skill_influence.forepart_lighting_sound_effect_id)
    -- if forepart_lighting_sound_effect_id >= 0 then
    --     playEffectMusic(forepart_lighting_sound_effect_id)
    -- end

    -- -- -- fwin:close(fwin:find("DrawHitDamageClass"))
    -- -- fwin:open(DrawHitDamage:new():init(0, 0), fwin._view)

    -- fwin:close(fwin:find("DrawHitDamageClass"))
    -- fwin:open(DrawHitDamage:new():init(0, 0), fwin._view)
    state_machine.excute("draw_hit_damage_check_window", 0, self.roleCamp)
end

-- 获取攻击移动位置
function FightRole:getAttackMovePosition()
    local attData               = self.current_fight_data.__attData
    local attackMovePos         = tonumber(attData.attackMovePos)                   -- 移动到的位置(0-8)
    
    if attackMovePos == 0 or attackMovePos == 8 then
    else
        if self.fitAttacking == true then
            -- local halfWidth = (fwin._width - app.baseOffsetX) / 2
            -- local moveEndPosition = cc.p(halfWidth, self.parent:getPositionY())
            -- local moveBeginPosition = cc.p(self.parent:getPosition())
            -- local moveByPosition = cc.p(moveEndPosition.x - moveBeginPosition.x, moveEndPosition.y - moveBeginPosition.y)
            -- self.moveByPosition = moveByPosition
            if self.moveByPosition == nil or (math.abs(self.moveByPosition.x) <= _battle_controller._role_movd_smallest_distance 
                and math.abs(self.moveByPosition.y) <= _battle_controller._role_movd_smallest_distance)
                then
                return false
            end
            -- self.moveByPosition.y = 0
            return true
        else
            local defenderList = self.current_fight_data.__defenderList
            local lockRole = nil
            local isFindFrist = false
            for i, v in pairs(defenderList) do
                if v.roleCamp ~= nil and tonumber(v.roleCamp) ~= tonumber(self.roleCamp) and
                  v ~= nil and v.parent ~= nil then
                    -- v:waitByAttack()
                    if attackMovePos == 1 then
                        if lockRole ~= nil and tonumber(lockRole._brole._pos) > tonumber(v._brole._pos) or 
                          lockRole == nil then
                            lockRole = v
                        end
                    elseif attackMovePos == 3 or attackMovePos == 4 then
                        -- lockRole = v
                        if lockRole ~= nil and tonumber(lockRole._brole._pos) > tonumber(v._brole._pos) or 
                          lockRole == nil then
                            lockRole = v
                        end
                    elseif ((attackMovePos-1) == tonumber(v._brole._pos) or  
                        (attackMovePos-1) == tonumber(v._brole._pos)-3) then
                        -- 直线攻击效用只会指向前排
                        -- v:waitByAttack()
                        if lockRole ~= nil and tonumber(lockRole._brole._pos) > tonumber(v._brole._pos) or 
                          lockRole == nil then
                            lockRole = v
                        end
                    else
                        -- lockRole = v
                        if lockRole ~= nil and tonumber(lockRole._brole._pos) > tonumber(v._brole._pos) or 
                          lockRole == nil then
                            lockRole = v
                        end
                    end

                    -- 特殊处理，黄蜂兽放必杀技
                    if tonumber(self._brole._mouldId) == 24 and tonumber(self.skillQuality) == 1 then

                    else
                        if nil ~= self._firstPos then
                            if self._firstPos ~= lockRole._info._pos then
                                lockRole = nil

                            -- 按照之前代码的约定，技能的承受方中的敌方的第一个人_firstPos是掉血的直接攻击目标，这段代码的作用大概就是想找到直接攻击目标fightRole，如果已经找到的就跳出循环，以免后续有被置为nil
                            else
                                break
                            end
                        end
                    end
                end
            end

            if lockRole == nil and attackMovePos >= 2 and attackMovePos < 8 then
                for i, v in pairs(defenderList) do
                    if v.roleCamp ~= nil and tonumber(v.roleCamp) ~= tonumber(self.roleCamp) and
                        v ~= nil and v.parent ~= nil then
                        lockRole = v
                        break
                    end
                end
            end

            -- 魅惑站位 一定是队友身后
            if attackMovePos == SkillMould.SKILL_RELEASE_POSION_BEHIND then
                 for i, v in pairs(defenderList) do
                    if v ~= nil and v.parent ~= nil and v.roleCamp ~= nil and tonumber(v.roleCamp) == tonumber(self.roleCamp) then
                        if tonumber(self._brole._pos) ~= tonumber(v._brole._pos) then
                            lockRole = v
                            break
                        end
                    end
                end
            end

            self._firstPos = nil

            self.firstTarget = lockRole
            if lockRole ~= nil and lockRole.parent ~= nil then
                FightRole.firstTargetPos = lockRole.parent._base_pos -- cc.p(lockRole.parent:getPosition())
            end
            
            if lockRole ~= nil and lockRole.parent ~= nil or attackMovePos == 1 or attackMovePos == SkillMould.SKILL_RELEASE_POSION_BEHIND then
                -- print("攻击的站位类型：", attackMovePos, lockRole, dms.atos(self.armature._sed_action, skill_mould.attack_scope))
                -- lockRole:waitByAttack()
                local moveBeginPosition = cc.p(self.parent:getPosition())
                local moveEndPosition = nil
                if attackMovePos == 1 then
                    local basePos = self._FightRoleController.act_center_positions[2]
                    moveEndPosition = cc.p(basePos.x, basePos.y)
                    local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
                    local min_x = 0
                    local max_x = 0
                    if spaceInfo ~= nil then
                        spaceInfo = zstring.split(spaceInfo, ",")
                        if spaceInfo ~= nil and #spaceInfo == 2 then
                            min_x = zstring.tonumber(spaceInfo[1])
                            max_x = zstring.tonumber(spaceInfo[2])
                        end
                    end
                    -- if self.roleCamp == 0 then
                    --     moveEndPosition.x = moveEndPosition.x - min_x
                    -- else
                    --     moveEndPosition.x = moveEndPosition.x + min_x
                    -- end
                    local calcX = 0
                    if lockRole ~= nil then
                        if tonumber(lockRole._info._pos) == 1 or tonumber(lockRole._info._pos) == 2 or tonumber(lockRole._info._pos) == 3 then
                            calcX = min_x
                        else
                            calcX = max_x
                        end
                        if self.roleCamp == 0 then
                            moveEndPosition.x = moveEndPosition.x - calcX
                            -- 取消追击的坐标计算 下同
                            -- local role = lockRole--self:getCampPioneer(1)
                            -- if role ~= nil then
                            --     local offsetX = role.parent:getPositionX() - role.parent._base_pos.x
                            --     moveEndPosition.x = moveEndPosition.x + offsetX
                            -- end
                        else
                            moveEndPosition.x = moveEndPosition.x + calcX
                            -- local role = lockRole--self:getCampPioneer(0)
                            -- if role ~= nil then
                            --     local offsetX = role.parent._base_pos.x - role.parent:getPositionX()
                            --     moveEndPosition.x = moveEndPosition.x - offsetX
                            -- end
                        end
                    end
                    lockRole = nil
                -- elseif attackMovePos == 2 then
                --     local basePos = nil
                --     if lockRole.roleCamp == 0 then
                --         basePos = self._FightRoleController.hero_column_positions[lockRole.current_attack_line]
                --     else
                --         basePos = self._FightRoleController.master_column_positions[lockRole.current_attack_line]
                --     end
                --     moveEndPosition = cc.p(basePos.x, basePos.y)
                --     local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
                --     local min_x = 0
                --     local max_x = 0
                --     if spaceInfo ~= nil then
                --         spaceInfo = zstring.split(spaceInfo, ",")
                --         if spaceInfo ~= nil and #spaceInfo == 2 then
                --             min_x = zstring.tonumber(spaceInfo[1])
                --             max_x = zstring.tonumber(spaceInfo[2])
                --         end
                --     end
                --     -- if self.roleCamp == 0 then
                --     --     moveEndPosition.x = moveEndPosition.x - min_x
                --     -- else
                --     --     moveEndPosition.x = moveEndPosition.x + min_x
                --     -- end
                --     local calcX = 0
                --     if lockRole ~= nil then
                --         if tonumber(lockRole._info._pos) == 1 or tonumber(lockRole._info._pos) == 2 or tonumber(lockRole._info._pos) == 3 then
                --             calcX = min_x
                --         else
                --             calcX = max_x
                --         end
                --         if self.roleCamp == 0 then
                --             moveEndPosition.x = moveEndPosition.x - calcX
                --             -- local role = lockRole--self:getCampPioneer(1)
                --             -- if role ~= nil then
                --             --     local offsetX = role.parent:getPositionX() - role.parent._base_pos.x
                --             --     moveEndPosition.x = moveEndPosition.x + offsetX
                --             -- end
                --         else
                --             moveEndPosition.x = moveEndPosition.x + calcX
                --             -- local role = lockRole--self:getCampPioneer(0)
                --             -- if role ~= nil then
                --             --     local offsetX = role.parent._base_pos.x - role.parent:getPositionX()
                --             --     moveEndPosition.x = moveEndPosition.x - offsetX
                --             -- end
                --         end
                --     end
                --     -- lockRole = nil
                -- elseif attackMovePos == 3 or attackMovePos == 4 then
                --     local hpos = 2
                --     if tonumber(lockRole._info._pos) > 3 then
                --         hpos = hpos + 3
                --     end
                --     local basePos = nil
                --     if lockRole.roleCamp == 0 then
                --         basePos = cc.p(self._FightRoleController.hero_slots[hpos]:getPosition())
                --     else
                --         basePos = cc.p(self._FightRoleController.master_slots[hpos]:getPosition())
                --     end
                --     moveEndPosition = cc.p(basePos.x, basePos.y)
                --     local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
                --     local min_x = 0
                --     local max_x = 0
                --     if spaceInfo ~= nil then
                --         spaceInfo = zstring.split(spaceInfo, ",")
                --         if spaceInfo ~= nil and #spaceInfo == 2 then
                --             min_x = zstring.tonumber(spaceInfo[1])
                --             max_x = zstring.tonumber(spaceInfo[2])
                --         end
                --     end
                --     -- if self.roleCamp == 0 then
                --     --     moveEndPosition.x = moveEndPosition.x - min_x
                --     -- else
                --     --     moveEndPosition.x = moveEndPosition.x + min_x
                --     -- end
                --     local calcX = 0
                --     if lockRole ~= nil then
                --         if tonumber(lockRole._info._pos) == 1 or tonumber(lockRole._info._pos) == 2 or tonumber(lockRole._info._pos) == 3 then
                --             calcX = min_x
                --         else
                --             calcX = max_x
                --         end
                --         if self.roleCamp == 0 then
                --             moveEndPosition.x = moveEndPosition.x - calcX
                --             local role = lockRole--self:getCampPioneer(1)
                --             if role ~= nil then
                --                 local offsetX = role.parent:getPositionX() - role.parent._base_pos.x
                --                 moveEndPosition.x = moveEndPosition.x + offsetX
                --             end
                --         else
                --             moveEndPosition.x = moveEndPosition.x + calcX
                --             local role = lockRole--self:getCampPioneer(0)
                --             if role ~= nil then
                --                 local offsetX = role.parent._base_pos.x - role.parent:getPositionX()
                --                 moveEndPosition.x = moveEndPosition.x - offsetX
                --             end
                --         end
                --     end
                --     lockRole = nil
                elseif attackMovePos == 10 then
                    local basePos = self._FightRoleController.act_center_positions[lockRole.current_attack_line]
                    moveEndPosition = cc.p(basePos.x, basePos.y)
                    local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
                    local min_x = 0
                    local max_x = 0
                    if spaceInfo ~= nil then
                        spaceInfo = zstring.split(spaceInfo, ",")
                        if spaceInfo ~= nil and #spaceInfo == 2 then
                            min_x = zstring.tonumber(spaceInfo[1])
                            max_x = zstring.tonumber(spaceInfo[2])
                        end
                    end
                    -- if self.roleCamp == 0 then
                    --     moveEndPosition.x = moveEndPosition.x - min_x
                    -- else
                    --     moveEndPosition.x = moveEndPosition.x + min_x
                    -- end
                    local calcX = 0
                    if lockRole ~= nil then
                        if tonumber(lockRole._info._pos) == 1 or tonumber(lockRole._info._pos) == 2 or tonumber(lockRole._info._pos) == 3 then
                            calcX = min_x
                        else
                            calcX = max_x
                        end
                        if self.roleCamp == 0 then
                            moveEndPosition.x = moveEndPosition.x - calcX
                            -- local role = lockRole--self:getCampPioneer(1)
                            -- if role ~= nil then
                            --     local offsetX = role.parent:getPositionX() - role.parent._base_pos.x
                            --     moveEndPosition.x = moveEndPosition.x + offsetX
                            -- end
                        else
                            moveEndPosition.x = moveEndPosition.x + calcX
                            -- local role = lockRole--self:getCampPioneer(0)
                            -- if role ~= nil then
                            --     local offsetX = role.parent._base_pos.x - role.parent:getPositionX()
                            --     moveEndPosition.x = moveEndPosition.x - offsetX
                            -- end
                        end
                    end
                    lockRole = nil
                elseif attackMovePos == SkillMould.SKILL_RELEASE_POSION_BEHIND then
                    if lockRole == nil then
                        self.lockRole = nil
                        return false
                    end
                    moveEndPosition = cc.p(lockRole.parent._base_pos.x, lockRole.parent._base_pos.y)
                    local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
                    local min_x = 0
                    local max_x = 0
                    if spaceInfo ~= nil then
                        spaceInfo = zstring.split(spaceInfo, ",")
                        if spaceInfo ~= nil and #spaceInfo == 2 then
                            min_x = zstring.tonumber(spaceInfo[1])
                            max_x = zstring.tonumber(spaceInfo[2])
                        end
                    end
                    local calcX = 0

                    if tonumber(lockRole._info._pos) == 1 or tonumber(lockRole._info._pos) == 2 or tonumber(lockRole._info._pos) == 3 then
                        calcX = min_x
                    else
                        calcX = max_x
                    end
                    if self.roleCamp == 0 then
                        moveEndPosition.x = moveEndPosition.x - calcX
                    else
                        moveEndPosition.x = moveEndPosition.x + calcX
                    end

                    lockRole = nil
                else
                    local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
                    local min_x = 0
                    local max_x = 0
                    if spaceInfo ~= nil then
                        spaceInfo = zstring.split(spaceInfo, ",")
                        if spaceInfo ~= nil and #spaceInfo == 2 then
                            min_x = zstring.tonumber(spaceInfo[1])
                            max_x = zstring.tonumber(spaceInfo[2])
                        end
                    end
                    -- moveEndPosition = cc.p(lockRole.parent:getPosition())
                    moveEndPosition = cc.p(lockRole.parent._base_pos.x, lockRole.parent._base_pos.y)

                    local calcX = 0
                    if lockRole ~= nil then
                        if tonumber(lockRole._info._pos) == 1 or tonumber(lockRole._info._pos) == 2 or tonumber(lockRole._info._pos) == 3 then
                            calcX = min_x
                        else
                            calcX = max_x
                        end
                        if self.roleCamp == 0 then
                            moveEndPosition.x = moveEndPosition.x - calcX
                            -- local role = lockRole--self:getCampPioneer(1)
                            -- if role ~= nil then
                            --     local offsetX = role.parent:getPositionX() - role.parent._base_pos.x
                            --     moveEndPosition.x = moveEndPosition.x + offsetX
                            -- end
                        else
                            moveEndPosition.x = moveEndPosition.x + calcX
                            -- local role = lockRole--self:getCampPioneer(0)
                            -- if role ~= nil then
                            --     local offsetX = role.parent._base_pos.x - role.parent:getPositionX()
                            --     moveEndPosition.x = moveEndPosition.x - offsetX
                            -- end
                        end
                    end

                    -- if lockRole.roleCamp == 0 then
                    --     moveEndPosition.x = moveEndPosition.x + _battle_controller._melee_hit_distance * 80-- + lockRole:getContentSize().width
                    -- else
                    --     moveEndPosition.x = moveEndPosition.x - _battle_controller._melee_hit_distance * 80-- - lockRole:getContentSize().width
                    -- end

                    -- if lockRole.roleCamp == 0 then
                    --     if moveEndPosition.x + min_x < moveBeginPosition.x then
                    --         moveEndPosition.x = math.min(moveEndPosition.x + max_x, moveBeginPosition.x)
                    --     else
                    --         moveEndPosition.x = moveEndPosition.x + min_x
                    --     end
                    -- else
                    --     if moveEndPosition.x - min_x > moveBeginPosition.x then
                    --         moveEndPosition.x = math.max(moveEndPosition.x - max_x, moveBeginPosition.x)
                    --     else
                    --         moveEndPosition.x = moveEndPosition.x - min_x
                    --     end
                    -- end

                    -- local isJump = dms.atoi(self.armature._sed_action, skill_mould.is_jump)
                    -- local lxx, lyy = lockRole.parent:getPosition()
                    -- local offsetY = lyy - lockRole.parent._swap_pos.y
                    -- if tonumber(isJump) == 1 and offsetY > _battle_controller._air_pursuit_min_height then
                    -- else
                    --     moveEndPosition.y = lockRole.parent._base_pos.y
                    -- end
                end

                -- debug.print_r(moveEndPosition)

                local moveByPosition = cc.p(moveEndPosition.x - moveBeginPosition.x, moveEndPosition.y - moveBeginPosition.y)
                self.moveByPosition = moveByPosition

                if math.abs(moveByPosition.x) <= _battle_controller._role_movd_smallest_distance 
                    and math.abs(moveByPosition.y) <= _battle_controller._role_movd_smallest_distance 
                    then
                    self.lockRole = nil
                    return false
                end
                self.lockRole = lockRole
                -- self.moveByPosition.y = 0
                return true
            end
        end
    end
    return false
end

function FightRole:executeHeroMoveToTarget()
    -- 技能施放位置
    -- 0原地
    -- 1屏幕中心（固定敌方2号位对象前）
    -- 2移动到承受者所在直线前方（固定敌方123号位前方）
    -- 3移动到承受者前方(前排优先)
    -- 4移动到承受者前方(后排优先)
    -- 5攻击者消失（暗杀)
    -- 6更改攻击目标，每次攻击都移动到承受者前方

    local attData               = self.current_fight_data.__attData
    local attackMovePos         = tonumber(attData.attackMovePos)                   -- 移动到的位置(0-8)
    if self._isAnimal == true then
        self:changeActtackToAttackBegan(self.armature)
    else
        if (attackMovePos == 0 or attackMovePos == 8) then
            self:changeActtackToAttackBegan(self.armature)
            if attackMovePos == 8 then
                self:setVisible(false)
            end
        else
            if self:getAttackMovePosition() == true then
                -- print("changeActtackToAttackMoving", self.roleCamp, self._info._pos)
                self:changeActtackToAttackMoving()
            else
                -- print("get attack move position lose!!!", self.roleCamp, self._info._pos)
                self:changeActtackToAttackBegan(self.armature)
            end
        end
    end
end

local function getRootPosition( target )
    local pos = cc.p(target:getPosition())
    pos = cc.pAdd(pos, cc.p(target:getParent():getPosition()))
    pos = cc.pAdd(pos, cc.p(target:getParent():getParent():getPosition()))
    pos = cc.pAdd(pos, cc.p(target:getParent():getParent():getParent():getPosition()))
    -- debug.print_r(pos)
    return pos
end

function FightRole:checkDrawAntNumber()
        -- print("step1:", self._battle_combo_root._need_over)
    if self._battle_combo_root._battle_hurt_action._need_over then
        -- print("step2:", self._battle_combo_root._drawAtlasLabel)
        if nil ~= self._battle_combo_root._drawAtlasLabel then
            -- print("step3")
            local hideAtlasLabel = self._battle_combo_root._drawAtlasLabel:clone()
            hideAtlasLabel:setString(self._battle_combo_root._old_number)
            -- self._battle_combo_root._drawAtlasLabel:getParent():addChild(hideAtlasLabel, -1)
            -- self._battle_combo_root._parent:addChild(hideAtlasLabel, kZOrderInFightScene_Hurt - 1)
            hideAtlasLabel:setVisible(true)
            hideAtlasLabel:setOpacity(255)
            self._battle_combo_root:addChild(hideAtlasLabel, - 1)
            -- hideAtlasLabel:setPosition(self._battle_combo_root._drawAtlasLabel._root_pos)
            hideAtlasLabel:setPosition(getRootPosition(self._battle_combo_root._drawAtlasLabel))
            -- local flag = -1
            -- if self.roleCamp == 1 then
            --     flag = 1
            -- end
            local flag = 1
            hideAtlasLabel:runAction(cc.Sequence:create({
                    cc.Spawn:create({
                            cc.FadeOut:create(2.2 * __fight_recorder_action_time_speed),
                            cc.MoveBy:create(2.0 * __fight_recorder_action_time_speed, cc.p(12 * flag, 116)),
                        }),
                    cc.CallFunc:create(function ( sender )
                        -- print("11111111111111")
                        -- if sender._draw_count == sender._battle_combo_root._draw_count then
                        --     sender._battle_combo_root._hideAtlasLabel = nil
                        --     sender._battle_combo_root._drawAtlasLabel = nil
                        --     sender._battle_combo_root._battle_hurt_action._need_over = false
                        --     -- print("22222222222")
                        -- end
                        sender:removeFromParent(true)
                    end)
                }))
            self._battle_combo_root._draw_count = self._battle_combo_root._draw_count + 1
            hideAtlasLabel._draw_count = self._battle_combo_root._draw_count
            hideAtlasLabel._drawAtlasLabel = _drawAtlasLabel
            hideAtlasLabel._battle_combo_root = self._battle_combo_root
            self._battle_combo_root._hideAtlasLabel = hideAtlasLabel
        end
    end
end

-- 飘字（伤害，加血等数值）
function FightRole:drawAntNumber(_parent, _number, numberFilePath, _tempX, _tempY, _widgetSize, _hurtCount, _ishaveBaoJi, isNeedScaleX, defState, _isHaveRealDamage, typeDamage)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        -- version 2.0
        --[[
            battle_combo.csb

            UI动画组名：battle_hurt
            控件说明：
                AtlasLabel_combo_n   绘制连击数值

                Panel_hp_1  普通伤害时打可见性
                Panel_hp_2  暴击伤害时打可见性
                Panel_hp_3  加血时打可见性
                Panel_crit    暴击伤害时打可见性
                Panel_hp_4  真实伤害时打可见性
                Panel_hp_5  间接伤害可见性

                AtlasLabel_xue  绘制普通伤害数值
                AtlasLabel_baoji  绘制暴击伤害数值
                AtlasLabel_jiaxue  绘制加血数值
                AtlasLabel_real_damage  绘制真实伤害数值
                AtlasLabel_indirect_damage  绘制间接伤害数值

            读到伤害帧则绘制此csb
            读到下一个伤害帧则清除上一个的绘制，重新绘制新的
        --]]
        if nil == self._battle_combo_root then
            local csbNode = nil
            if self.roleCamp == 0 then
                csbNode = csb.createNode("battle/battle_combo_1.csb")
            else
                csbNode = csb.createNode("battle/battle_combo.csb")
            end
            self._battle_combo_root = csbNode:getChildByName("root")
            self._battle_combo_root:removeFromParent(true)
            _parent:getParent():addChild(self._battle_combo_root, kZOrderInFightScene_Hurt)
            self._battle_combo_root._parent = _parent
            self._battle_combo_root._draw_count = 0

            if self.roleCamp == 0 then
                self._battle_combo_root._battle_hurt_action = csb.createTimeline("battle/battle_combo_1.csb")
                self._battle_combo_root:runAction(self._battle_combo_root._battle_hurt_action)
                self._battle_combo_root._battle_hurt_action._self = self
            else
                self._battle_combo_root._battle_hurt_action = csb.createTimeline("battle/battle_combo.csb")
                self._battle_combo_root:runAction(self._battle_combo_root._battle_hurt_action)
                self._battle_combo_root._battle_hurt_action._self = self
            end

            self._battle_combo_root.AtlasLabel_combo_n = ccui.Helper:seekWidgetByName(self._battle_combo_root, "AtlasLabel_combo_n")

            self._battle_combo_root.Panel_hp_1 = ccui.Helper:seekWidgetByName(self._battle_combo_root, "Panel_hp_1")
            self._battle_combo_root.Panel_hp_2 = ccui.Helper:seekWidgetByName(self._battle_combo_root, "Panel_hp_2")
            self._battle_combo_root.Panel_hp_3 = ccui.Helper:seekWidgetByName(self._battle_combo_root, "Panel_hp_3")
            self._battle_combo_root.Panel_hp_4 = ccui.Helper:seekWidgetByName(self._battle_combo_root, "Panel_hp_4")
            self._battle_combo_root.Panel_hp_5 = ccui.Helper:seekWidgetByName(self._battle_combo_root, "Panel_hp_5")
            self._battle_combo_root.Panel_crit = ccui.Helper:seekWidgetByName(self._battle_combo_root, "Panel_crit")
            self._battle_combo_root.Panel_gedang = ccui.Helper:seekWidgetByName(self._battle_combo_root, "Panel_gedang")

            self._battle_combo_root.AtlasLabel_xue = ccui.Helper:seekWidgetByName(self._battle_combo_root, "AtlasLabel_xue")
            self._battle_combo_root.AtlasLabel_baoji = ccui.Helper:seekWidgetByName(self._battle_combo_root, "AtlasLabel_baoji")
            self._battle_combo_root.AtlasLabel_jiaxue = ccui.Helper:seekWidgetByName(self._battle_combo_root, "AtlasLabel_jiaxue")
            self._battle_combo_root.AtlasLabel_real_damage = ccui.Helper:seekWidgetByName(self._battle_combo_root, "AtlasLabel_real_damage")
            self._battle_combo_root.AtlasLabel_indirect_damage = ccui.Helper:seekWidgetByName(self._battle_combo_root, "AtlasLabel_indirect_damage")

            -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            --     or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            --     then
                -- local function getRootPosition( target )
                --     local pos = cc.p(target:getPosition())
                --     pos = cc.pAdd(pos, cc.p(target:getParent():getPosition()))
                --     pos = cc.pAdd(pos, cc.p(target:getParent():getParent():getPosition()))
                --     -- pos = cc.pAdd(pos, cc.p(target:getParent():getParent():getParent():getPosition()))
                --     debug.print_r(pos)
                --     return pos
                -- end
                -- self._battle_combo_root.AtlasLabel_xue._root_pos = getRootPosition(self._battle_combo_root.AtlasLabel_xue)
                -- self._battle_combo_root.AtlasLabel_baoji._root_pos = getRootPosition(self._battle_combo_root.AtlasLabel_baoji)
                -- self._battle_combo_root.AtlasLabel_jiaxue._root_pos = getRootPosition(self._battle_combo_root.AtlasLabel_jiaxue)

                self._battle_combo_root._battle_hurt_action._root = self._battle_combo_root
                self._battle_combo_root._battle_hurt_action:setFrameEventCallFunc(function (frame)
                    if nil == frame then
                        return
                    end

                    local str = frame:getEvent()
                    local node = frame:getNode()
                    local action = frame:getTimeline():getActionTimeline()
                    if str == "over" then
                        -- -- print("---------------over!!!")
                        -- if nil ~= action._self and nil ~= action._self.checkDrawAntNumber then
                        --     action._self:checkDrawAntNumber()
                        --     action._self._battle_combo_root._battle_hurt_action._need_over = false
                        -- end

                        if nil == action._next then
                            -- action._self._battle_combo_root_prev = nil
                        else
                            action._next._prev = nil
                        end
                        -- if action == action._self._battle_combo_root_prev then
                        --     action._self._battle_combo_root_prev = nil
                        -- end
                        action._root._battle_hurt_action = nil
                        action._root:removeFromParent(true)
                        action._root = nil
                    end
                end)
            -- end
        end

        local px, py = _parent:getPosition()

        self._battle_combo_root:setPosition(cc.p(_tempX + px, _tempY + py + _widgetSize.height / 2))

        local drawNumber = math.floor(tonumber(_number) or 0)
        _number = drawNumber
        
        -- if __lua_project_id == __lua_project_l_naruto then
        -- else
            -- _number = zstring.replace(_number, "-", "")
            -- _number = zstring.replace(_number, "+", "")
        -- end
        self.drawDamageNumberCount = self.drawDamageNumberCount or 0
        if self.drawDamageNumberCount == 0 then
            -- self._battle_combo_root._number = 0
            self._battle_combo_root_number = 0
        end
		--TODO:wf 加个预防措施 2682 【竞技场】进入竞技场战斗，点击“跳过”按钮后，界面显示伤害飘字和加血飘字后卡死（区服：S1 ID：7 时间：3月2号10:30）
        if not self._battle_combo_root_number then
            self._battle_combo_root_number = 0
        end
        -- 如果之前的飘字是减血，后面飘字是加血，减血的先置为0，以免负数加正数，造成加血量变少
        -- if self._battle_combo_root_number < 0 and _number > 0 then
        --     self._battle_combo_root_number = 0
        -- end

        self.drawDamageNumberCount = self.drawDamageNumberCount + 1
        self._battle_combo_root.AtlasLabel_combo_n:setString("" .. self.drawDamageNumberCount)

        -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        --     or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        --     then
            -- self._battle_combo_root._number = self._battle_combo_root._number or 0
            -- self._battle_combo_root._old_number = self._battle_combo_root._number
            -- self._battle_combo_root._number = self._battle_combo_root._number + _number
            -- _number = math.ceil(self._battle_combo_root._number)

        if _number > 0 then
            -- print("_number = ", _number, " self._battle_add_blood_root_number = ", self._battle_add_blood_root_number)

            self._battle_add_blood_root_number = (self._battle_add_blood_root_number or 0) + _number
            _number = math.ceil(self._battle_add_blood_root_number)

            self._battle_add_blood_times = (self._battle_add_blood_times or 0) + 1

            -- print("self._battle_add_blood_times = ", self._battle_add_blood_times, " self._battle_add_blood_root_number = ", self._battle_add_blood_root_number, " self._attackSection = ", self._attackSection)

            if self._battle_add_blood_times >= self._attackSection then
                self._battle_add_blood_root_number = 0
                self._battle_add_blood_times = 0
                self._attackSection = 0
            end
        else
            if _isHaveRealDamage == true then
                _number = math.ceil(_number)
            elseif isTypeDamage(ENUM_TYPE_DAMAGE.TYPE_DAMAGE_INDIRECT,typeDamage) then
                _number = math.ceil(_number)
            else
                self._battle_combo_root_number = self._battle_combo_root_number or 0
                self._battle_combo_root_number = self._battle_combo_root_number + _number
                _number = math.ceil(self._battle_combo_root_number)
            end
        end

        -- end

        local _Panel_hp_1_visible = false
        local _Panel_hp_2_visible = false
        local _Panel_hp_3_visible = false
        local _Panel_hp_4_visible = false
        local _Panel_hp_5_visible = false
        local _Panel_crit_visible = false
        local _Panel_gedang_visible = false
        local _drawAtlasLabel = nil
        if drawNumber <= 0 then
            if _ishaveBaoJi then
                if nil ~= self._battle_combo_root.AtlasLabel_baoji then
                    self._battle_combo_root.AtlasLabel_baoji:setString(_number)
                    _drawAtlasLabel = self._battle_combo_root.AtlasLabel_baoji
                end
                _Panel_crit_visible = true
                _Panel_hp_2_visible = true
            else
                if nil ~= self._battle_combo_root.AtlasLabel_xue then
                    self._battle_combo_root.AtlasLabel_xue:setString(_number)
                    _drawAtlasLabel = self._battle_combo_root.AtlasLabel_xue
                end
                _Panel_hp_1_visible = true
            end

            if defState == "3" or defState == "4" then
                _Panel_gedang_visible = true
            end

            -- 是否是真实伤害
            if _isHaveRealDamage then
                if nil ~= self._battle_combo_root.AtlasLabel_real_damage then
                    self._battle_combo_root.AtlasLabel_real_damage:setString(_number)
                    _drawAtlasLabel = self._battle_combo_root.AtlasLabel_real_damage
                end
                _Panel_hp_4_visible = true

                _Panel_crit_visible = false
                _Panel_hp_1_visible = false
                _Panel_hp_2_visible = false
                _Panel_gedang_visible = false
            elseif isTypeDamage(ENUM_TYPE_DAMAGE.TYPE_DAMAGE_INDIRECT, typeDamage) then
                if nil ~= self._battle_combo_root.AtlasLabel_indirect_damage then
                    self._battle_combo_root.AtlasLabel_indirect_damage:setString(_number)
                    _drawAtlasLabel = self._battle_combo_root.AtlasLabel_indirect_damage

                    _Panel_hp_5_visible = true

                    _Panel_crit_visible = false
                    _Panel_hp_1_visible = false
                    _Panel_hp_2_visible = false
                    _Panel_gedang_visible = false
                end
            end
        else
            if nil ~= self._battle_combo_root.AtlasLabel_jiaxue then
                self._battle_combo_root.AtlasLabel_jiaxue:setString(_number)
                _drawAtlasLabel = self._battle_combo_root.AtlasLabel_jiaxue
            end
            _Panel_hp_3_visible = true
        end

        if nil ~= self._battle_combo_root.Panel_hp_1 then
            self._battle_combo_root.Panel_hp_1:setVisible(_Panel_hp_1_visible)
        end
        if nil ~= self._battle_combo_root.Panel_hp_2 then
            self._battle_combo_root.Panel_hp_2:setVisible(_Panel_hp_2_visible)
        end
        if nil ~= self._battle_combo_root.Panel_hp_3 then
            self._battle_combo_root.Panel_hp_3:setVisible(_Panel_hp_3_visible)
        end
        if nil ~= self._battle_combo_root.Panel_hp_4 then
            self._battle_combo_root.Panel_hp_4:setVisible(_Panel_hp_4_visible)
        end
        if nil ~= self._battle_combo_root.Panel_hp_5 then
            self._battle_combo_root.Panel_hp_5:setVisible(_Panel_hp_5_visible)
        end
        if nil ~= self._battle_combo_root.Panel_crit then
            self._battle_combo_root.Panel_crit:setVisible(_Panel_crit_visible)
        end
        if nil ~= self._battle_combo_root.Panel_gedang then
            self._battle_combo_root.Panel_gedang:setVisible(_Panel_gedang_visible)
        end

        -- print(_Panel_hp_1_visible, _Panel_hp_2_visible, _Panel_hp_3_visible, _Panel_crit_visible)


        -- if  __lua_project_id == __lua_project_l_naruto then
        --     self._battle_combo_root._battle_hurt_action._root = self._battle_combo_root
        --     self._battle_combo_root._battle_hurt_action:setFrameEventCallFunc(function (frame)
        --         if nil == frame then
        --             return
        --         end

        --         local str = frame:getEvent()
        --         local node = frame:getNode()
        --         local action = frame:getTimeline():getActionTimeline()
        --         -- print(str, node, action)
        --         if str == "close" then
        --             action._root:removeFromParent(true)
        --         end
        --     end)
        --     self._battle_combo_root._battle_hurt_action:play("battle_hurt", true)
        --     self._battle_combo_root = nil
        -- else
            self._battle_combo_root._battle_hurt_action:stop()
            self._battle_combo_root._battle_hurt_action:play("battle_hurt", false)
            -- self:checkDrawAntNumber()
            self._battle_combo_root._old_number = self._battle_combo_root._number
            self._battle_combo_root._drawAtlasLabel = _drawAtlasLabel
            self._battle_combo_root._battle_hurt_action._need_over = true

            local tempPrev = self._battle_combo_root_prev
            while nil ~= tempPrev and nil ~= tempPrev._battle_hurt_action do
                local xx, yy = tempPrev:getPosition()
                tempPrev:setPosition(xx + 5, yy + 25)
                tempPrev = tempPrev._prev
            end
            if nil ~= self._battle_combo_root_prev then
                self._battle_combo_root._prev = self._battle_combo_root_prev
                self._battle_combo_root_prev._next = self._battle_combo_root
            end
            self._battle_combo_root_prev = self._battle_combo_root
            self._battle_combo_root._battle_hurt_action._root = self._battle_combo_root
            self._battle_combo_root = nil
        -- end
        return
    end

    local isHavebaoji = true
    if _ishaveBaoJi == nil or _ishaveBaoJi == false then
        isHavebaoji = false
    end
    local _numberArray = {}
    local _pnode = cc.Node:create()
    _pnode:setAnchorPoint(cc.p(0.5, 0.5))
    
    local _node = cc.Node:create()
    _node:setAnchorPoint(cc.p(0.5, 0.5))

    local index = 0
    local _width = 0
    local _height = 0
    local _offHeight = 0
    local drawAtlas = {}

    local tnwidth = 31
    local tnheight = 39
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        tnwidth = 34
        tnheight = 46

        local inumber = zstring.tonumber(_number)
        
        _number = zstring.replace(_number, "-", "")
        _number = zstring.replace(_number, "+", "")

        table.insert(_numberArray, _number)

        if nil ~= self._number_node then
            self._number_node:getParent():removeFromParent(true)
        end
    
        self._number_node = _node
        _node._self = self

        -- _tempX = _tempX - self:getParent():getContentSize().width / 2
        -- print(self:getParent():getContentSize().width)
        _pnode:setRotation(-10)

        self.drawDamageNumberCount = self.drawDamageNumberCount or 0
        -- if inumber < 0 then
        --     local skillInfluenceElementData = self.armature._sie_action
        --     local bear_sound_effect_ids = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.bear_sound_effect_id), ",")
        --     local musicid = zstring.tonumber(bear_sound_effect_ids[self.drawDamageNumberCount])
        --     -- print('drawAntNumber -> musicId', self.drawDamageNumberCount, musicid)
        --     debug.print_r(bear_sound_effect_ids)
        --     if musicid > 0 then
        --         playEffectMusic(musicid)
        --     end
        -- end
    else
        for i=1, #_number  do
            table.insert(_numberArray, _number:sub(i, i))
        end
    end

    for i, v in pairs(_numberArray) do
        -- local labelAtlas = cc.LabelAtlas:_create(""..v, numberFilePath, 31, 39, 43)
        local labelAtlas = cc.LabelAtlas:_create(""..v, numberFilePath, tnwidth, tnheight, 43)
        local labelAtlasSize = labelAtlas:getContentSize()
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            -- labelAtlas:setAnchorPoint(cc.p(0, 0))
            -- labelAtlas:setPosition(cc.p(_width, 0))
        else
            if _height == 0 then
                _offHeight = _offHeight + labelAtlasSize.height/1.0
                _height = _height + labelAtlasSize.height + _offHeight
            end
            labelAtlas:setPosition(cc.p(_width, _offHeight))
        end
        _node:addChild(labelAtlas)

        table.insert(drawAtlas, labelAtlas)
        
        _width = _width + labelAtlasSize.width
    end
    
    _pnode:setPosition(cc.p(_tempX, _tempY + _widgetSize.height / 2))

    _pnode:setContentSize(cc.size(_width, _height))
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        self:addChild(_pnode, kZOrderInFightScene_Hurt)
    else
        _node:setContentSize(cc.size(_width, _height))
        _parent:addChild(_pnode, kZOrderInFightScene_Hurt)
        _node:setPosition(cc.p(_width / 2, _height / 2))
        _node:setScale(1.0)
    end
    _pnode:addChild(_node, kZOrderInFightScene_Hurt)

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        _pnode:setPosition(cc.p(70, 100))
        local function removeDrawAntNumberFuncN(sender)
            if sender._self and sender._self._number_node == sender then
                sender._self._number_node = nil
            end
            sender:getParent():removeFromParent(true)
        end

        for i, v in pairs(drawAtlas) do
            local arrayForFadeOut = {
                cc.DelayTime:create(0.5 * __fight_recorder_action_time_speed),
                cc.FadeOut:create(0.5 * __fight_recorder_action_time_speed)
            }
            local fadeOutSeq = cc.Sequence:create(arrayForFadeOut)
            v:runAction(fadeOutSeq)
        end

        local arrayForFadeOut = {
            cc.DelayTime:create(1.0 * __fight_recorder_action_time_speed),
            -- cc.FadeOut:create(0.5 * __fight_recorder_action_time_speed)
            cc.CallFunc:create(removeDrawAntNumberFuncN)
        }

        local fadeOutSeq = cc.Sequence:create(arrayForFadeOut)
        _node:runAction(fadeOutSeq)

        -- 被击数
        self.drawDamageNumberCount = self.drawDamageNumberCount + 1
        if self.drawDamageNumberCount > 0 then
            local combo = cc.Sprite:create("images/ui/battle/combo.png")
            combo:setAnchorPoint(cc.p(0, 0))
            combo:setPosition(cc.p(-30, tnheight))
            local labelAtlas = cc.LabelAtlas:_create(""..self.drawDamageNumberCount, "images/ui/number/number_comber.png", 30, 38, 48)
            labelAtlas:setAnchorPoint(cc.p(0, 0))
            labelAtlas:setPosition(cc.p(30, combo:getContentSize().height))
            _pnode:addChild(combo)
            combo:addChild(labelAtlas)

            local arrayForFadeOut1 = {
                cc.DelayTime:create(0.5 * __fight_recorder_action_time_speed),
                cc.FadeOut:create(0.5 * __fight_recorder_action_time_speed)
            }
            local fadeOutSeq1 = cc.Sequence:create(arrayForFadeOut1)
            combo:runAction(fadeOutSeq1)

            local arrayForFadeOut2 = {
                cc.DelayTime:create(0.5 * __fight_recorder_action_time_speed),
                cc.FadeOut:create(0.5 * __fight_recorder_action_time_speed)
            }
            local fadeOutSeq2 = cc.Sequence:create(arrayForFadeOut2)
            labelAtlas:runAction(fadeOutSeq2)

            -- combo:setPositionY(tnheight)
        end
    else
        local function removeDrawAntNumberFuncN(sender)
            sender:getParent():getParent():removeFromParent(true)
        end
        for i, v in pairs(drawAtlas) do
            local arrayForFadeOut = {
                cc.ScaleTo:create(5 / 60 * __fight_recorder_action_time_speed, 2.0),
                cc.DelayTime:create(5 / 60 * __fight_recorder_action_time_speed),
                cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, 1.0),
                cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
                cc.MoveBy:create(25 / 60 * __fight_recorder_action_time_speed, cc.p(0, 118)),
                cc.MoveBy:create(10 / 60 * __fight_recorder_action_time_speed, cc.p(0, 146)),
                cc.FadeOut:create(10 / 60 * __fight_recorder_action_time_speed),
                cc.CallFunc:create(removeDrawAntNumberFuncN)
            }
            local fadeOutSeq = cc.Sequence:create(arrayForFadeOut)
            v:runAction(fadeOutSeq)
        end
    end

    if isHavebaoji == true then
        local critNor = cc.Sprite:createWithSpriteFrameName("images/ui/battle/baoji.png")
        _pnode:addChild(critNor)
        
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            critNor:setAnchorPoint(cc.p(0, 0))
            -- critNor:setPosition(cc.p(-1 * critNor:getContentSize().width / 2, -1 * critNor:getContentSize().height / 2))
            critNor:setPositionY(-1 * critNor:getContentSize().height)
            local arrayForFadeOut = {
                cc.DelayTime:create(0.5 * __fight_recorder_action_time_speed),
                cc.FadeOut:create(0.5 * __fight_recorder_action_time_speed)
            }
            local fadeOutSeq = cc.Sequence:create(arrayForFadeOut)
            critNor:runAction(fadeOutSeq)
        else
            critNor:setAnchorPoint(cc.p(0.5, 0.5))
            critNor:setPosition(_node:getPositionX() - _node:getContentSize().width/2 - critNor:getContentSize().width/2, _node:getPositionY() + critNor:getContentSize().height/2)
            local baojiArrayForScale = {
                cc.ScaleTo:create(5 / 60 * __fight_recorder_action_time_speed, 2.0),
                cc.DelayTime:create(5 / 60 * __fight_recorder_action_time_speed),
                cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, 1.0),
                cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
                cc.MoveBy:create(25 / 60 * __fight_recorder_action_time_speed, cc.p(0, 118)),
                cc.MoveBy:create(10 / 60 * __fight_recorder_action_time_speed, cc.p(0, 146)),
                cc.FadeOut:create(10 / 60 * __fight_recorder_action_time_speed)
            }
            local baojiScaleSeq = cc.Sequence:create(baojiArrayForScale)
            critNor:runAction(baojiScaleSeq)

            local critLight = cc.Sprite:createWithSpriteFrameName("images/ui/battle/baoji_1.png")
            critLight:setOpacity(0)
            _pnode:addChild(critLight)
            critLight:setScale(2.0)
            critLight:setPosition(_node:getPositionX() - _node:getContentSize().width/2 - critLight:getContentSize().width/2, _node:getPositionY() + critLight:getContentSize().height/2)
            local arrayForScale = {
                cc.DelayTime:create(5 / 60 * __fight_recorder_action_time_speed),
                cc.FadeIn:create(5 / 60 * __fight_recorder_action_time_speed),
                cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, 1.0),
                cc.FadeOut:create(15 / 60 * __fight_recorder_action_time_speed)
            }
            local scaleSeq = cc.Sequence:create(arrayForScale)
            critLight:runAction(scaleSeq)

            local critNumNode = cc.Node:create()
            critNumNode:setAnchorPoint(cc.p(0.5, 0.5))
            _width = 0
            _height = 0
            _offHeight = 0
            drawAtlas = {}
            for i, v in pairs(_numberArray) do
                local labelAtlas = cc.LabelAtlas:_create(""..v, "images/ui/number/baoji_b.png", 31, 39, 43)
                local labelAtlasSize = labelAtlas:getContentSize()
                if _height == 0 then
                    _offHeight = _offHeight + labelAtlasSize.height/1.0
                    _height = _height + labelAtlasSize.height + _offHeight
                end
                labelAtlas:setPosition(cc.p(_width, _offHeight))
                critNumNode:addChild(labelAtlas)
                labelAtlas:setOpacity(0)
                labelAtlas:setScale(2.0)
                table.insert(drawAtlas, labelAtlas)
                _width = _width + labelAtlasSize.width
            end

            critNumNode:setContentSize(cc.size(_width, _height))
            _pnode:addChild(critNumNode, kZOrderInFightScene_Hurt)
            critNumNode:setPosition(cc.p(_width / 2, _height / 2))
            
            for i, v in pairs(drawAtlas) do
                local arrayForScaleCrit = {
                    cc.DelayTime:create(5 / 60 * __fight_recorder_action_time_speed),
                    cc.FadeIn:create(5 / 60 * __fight_recorder_action_time_speed),
                    cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, 1.0),
                    cc.FadeOut:create(15 / 60 * __fight_recorder_action_time_speed)
                }
                local fadeOutSeq = cc.Sequence:create(arrayForScaleCrit)
                v:runAction(fadeOutSeq)
            end
        end
    end

    if isNeedScaleX ~= nil and isNeedScaleX == true then
        _pnode:setScaleX(-1)
    end

    return _pnode
end

-- 真实伤害飘字
function FightRole:drawRealDamageNumber(stValue, attackSection, stRound, def, isBuff, skillId)
    local _baseValue = zstring.tonumber(stValue)
    local _value = math.ceil(zstring.tonumber(_baseValue) / attackSection)
    -- print("真实伤害数字的绘制 stValue = ", stValue)
    if _value < 1 and 1 == zstring.tonumber(_baseValue) then
        _value = 1
    end
    local drawString = "" .. _value
    local armatureBase = self.armature
    local armature = self
    local size = self:getContentSize()
    local _def = def
    local defenderST = _def.defenderST  --技能类型
    local tempX, tempY  = self:getPosition()
    local widgetSize = self:getContentSize()
    local defState = _def.defState

    armature._hurtCount = armature._hurtCount == nil and 0 or armature._hurtCount

    drawString = "-" .. zstring.tonumber(drawString)

    local numberFilePath = nil

    -- print("defState = ", defState)
    if defState == "0" or defState == "2" or defState == "3" or defState == "4" then
        if defenderST == "0" then
            -- numberFilePath 不影响显示的效果
            numberFilePath = "images/ui/number/xue.png"
            armatureBase._role._hp = zstring.tonumber(armatureBase._role._hp) + tonumber(drawString)
            armatureBase._role._lhp = _def.aliveHP
            showRoleHP(armatureBase, def)
            
            -- self:changeToByAttackAction()

            if numberFilePath ~= nil and drawString ~= nil and tonumber(drawString) < 0 then
                self:showChangeHpNumberAni(numberFilePath, drawString, false, defState, true)
            end
        end
    end
end

-- 掉血飘字
function FightRole:drawDamageNumber(stValue, attackSection, stRound, def, isBuff,skillId)
    local _baseValue = zstring.tonumber(stValue)
    -- if _baseValue == 0 then
    --     return
    -- end
    local _value = math.ceil(zstring.tonumber(_baseValue) / attackSection)
    -- print("伤害数字的绘制")
    if _value < 1 and 1 == zstring.tonumber(_baseValue) then
        _value = 1
    end
    local drawString = "" .. _value
    local armatureBase = self.armature
    local armature = self
    local size = self:getContentSize()
    local _def = def--self.current_fight_data.__def
    local defenderST = _def.defenderST  --技能类型
    local tempX, tempY  = self:getPosition()
    local widgetSize = self:getContentSize()
    local defState = _def.defState

    if defenderST == "5" and tonumber(stRound) ~= 0 then
        -- self.buffList[defenderST] = stRound
        self.is_dizziness = true
    end
    
    armature._hurtCount = armature._hurtCount == nil and 0 or armature._hurtCount

    if defenderST == "0" or defenderST == "6" or defenderST == "9" or defenderST == "35" or defenderST == "37" or defenderST == "41" 
        or BattleSkill.isLifeChainSkill(defenderST)
    then
        -- if tonumber(_def.defender) == 1 and defenderST == "0" then
        --     BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(drawString)
        --     state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
        -- end
        if zstring.tonumber(drawString) > 0 then
            drawString = "-"..zstring.tonumber(drawString)
        else
            -- print("该伤害值为负数!!")
            drawString = ""
        end
    elseif defenderST == "1" or defenderST == "31" then
        if zstring.tonumber(drawString) > 0 then
            drawString = "+"..zstring.tonumber(drawString)
        else
            -- print("该回血值为负数!!")
            drawString = ""
        end

        if isBuff == false then
            armature._attackSection = attackSection
            -- print("drawDamageNumber armature._attackSection = ", armature._attackSection)
        end
    end
    
    if (defenderST == "2" or defenderST == "3") and (armatureBase~= nil and armatureBase._role ~= nil) then
        if _def.stVisible == "1" and defState ~= "1" and defState ~= "5" then
            -- armatureBase._role._sp = armatureBase._role._sp + ((defenderST == "2" and 1 or -1) * tonumber(drawString))
            -- if armatureBase._role._sp < 0 then
            --     armatureBase._role._sp = 0
            -- end
            -- showRoleSP(armatureBase)
        end
    end
    
    ---------------------------------------------------------------------------
    -- 增加相克状态
    ---------------------------------------------------------------------------
    local restrainState = _def.restrainState --         = npos(list) --相克状态(0,无克制 1,有克制,2被克制)
    
    if restrainState == "1" and armature._hurtCount == 0 then
        -- local xiangke = cc.Sprite:createWithSpriteFrameName("images/ui/battle/xiangke.png")
        -- xiangke:setAnchorPoint(cc.p(0.5, 0.5))
        -- xiangke:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
        -- _widget:getParent():addChild(xiangke, kZOrderInMap_Hurt)
        
        -- local seq = cc.Sequence:create(
            -- cc.MoveBy:create(0.4 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
            -- cc.CallFunc:create(removeFrameObjectFuncN)
        -- )
        -- xiangke:runAction(seq)
        -- cleanBuffEffectWithMiss(armatureBase._posTile,true)
        
        local armatureEffect = self:createEffectCoverSkill(self, 999, zstring.tonumber(armature._camp))
        armatureEffect._invoke = deleteEffectFile
    end
    ---------------------------------------------------------------------------
    
    local numberFilePath = nil
    -- 0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格

    if defState == "1"
        then
    else
        self:updateDrawInfluenceInfo(def)
    end
    if defState == "0" or defState == "3" then
        if defenderST == "6" or
            defenderST == "9" or
            defenderST == "12" or
            defenderST == "23" or
            defenderST == "5" or 
            defenderST == "26" or
            defenderST == "106" 
            then
            -- self.buffList[defenderST] = stRound

        end
        -- 命中
        if defenderST == "1" or defenderST == "31" then
            if armatureBase._role._hp ~= nil and drawString ~= nil and drawString ~= "" and 
                (_def.stVisible ~= "1" or (_def.stVisible == "1" and defenderST == "1")) then
                numberFilePath = "images/ui/number/jiaxue.png"
            end
            armatureBase._role._hp = zstring.tonumber(armatureBase._role._hp) + zstring.tonumber(drawString)
            armatureBase._role._lhp = _def.aliveHP
            showRoleHP(armatureBase, _def)
            -- state_machine.excute("fight_role_controller_update_hp_progress", 0, {self.roleCamp, zstring.tonumber(drawString)})
        elseif defenderST == "2" 
            or defenderST == "3" 
            or defenderST == "4" 
            or defenderST == "5" 
            or defenderST == "7" 
            or defenderST == "8"
            or defenderST == "9" -- 临时取消灼烧的绘图 
            or defenderST == "10" 
            or defenderST == "11" 
            or defenderST == "12" 
            or defenderST == "13" 
            -- or defenderST == "14" 
            or defenderST == "15"
            or defenderST == "20"

            or defenderST == "34"
            or defenderST == "35"
            -- or defenderST == "37"
            -- or defenderST == "41"
            or defenderST == "42"
            -- or defenderST == "46"
            or defenderST == "47"
            or defenderST == "56"
            or defenderST == "57"
            or defenderST == "59"
            or defenderST == "106" 
            or defenderST == "120" 
            then
        elseif defenderST == "21"
            or defenderST == "22"
            or defenderST == "23"
            or defenderST == "24"
            or defenderST == "25"
            or defenderST == "26"
            or defenderST == "27"
            or defenderST == "28"
            or defenderST == "29"
            or defenderST == "30"
            or defenderST == "33"

            or defenderST == "36"
            or defenderST == "38"
            or defenderST == "39"
            or defenderST == "40"
            or defenderST == "43"
            or defenderST == "44"
            or defenderST == "45"
            or defenderST == "48"
            or defenderST == "49"
            or defenderST == "50"
            or defenderST == "51"
            or defenderST == "52"
             or defenderST == "53" --TODO:wf 放开注释解决 2303 【战斗】所有PVE战斗中，上齐四魂后雷公使用必杀会给全体宝可梦加血
            or defenderST == "54"
            or defenderST == "55"
            or defenderST == "58"
            or defenderST == "60"
            or defenderST == "61"
            or defenderST == "62"
            or defenderST == "63"
            or defenderST == "64"
            or defenderST == "65"
            or defenderST == "66"
            or defenderST == "67"
            or defenderST == "68"
            or defenderST == "69"
            then
            -- if _def.___draw == nil then
            --     local miss = cc.Sprite:createWithSpriteFrameName("images/ui/battle/".._battle_buff_effect_dictionary[zstring.tonumber(defenderST) + 1]..".png")
            --     if nil ~= miss then
            --         miss:setAnchorPoint(cc.p(0.5, 0.5))
            --         -- miss:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
            --         miss:setPosition(cc.p(self:getParent():getPositionX() + self:getPositionX(), self:getParent():getPositionY() + size.height)) 
            --         local map = self:getParent():getParent()
            --         map:addChild(miss, kZOrderInFightScene_Hurt)
            --         -- miss:setScale(1.2)
            --         local seq = cc.Sequence:create(
            --             cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
            --             cc.CallFunc:create(removeFrameObjectFuncN)
            --         )
            --         miss:runAction(seq)
            --     end
            --     _def.___draw = true
            -- end
            -- -- cleanBuffEffectWithMiss(armatureBase._posTile,true)
            self:updateDrawInfluenceInfo(_def)
        elseif defenderST == "32" then
             --清除
             -- print("清除负面BUFF:", self.roleCamp, self._info._pos, defenderST)
            if skillId ~= nil then 
                -- local cleanStateId = dms.int(dms["skill_influence"],skillId,skill_influence.formula_info)
                for k,v in pairs(self.buffList) do
                    -- if cleanStateId == zstring.tonumber(k) then
                    local skillCategory = tonumber(k)
                    if skillCategory == 5   
                        or skillCategory == 7   
                        or skillCategory == 8   
                        or skillCategory == 9   
                        or skillCategory == 17  
                        or skillCategory == 22  
                        or skillCategory == 24  
                        or skillCategory == 36  
                        or skillCategory == 39  
                        or skillCategory == 47  
                        or skillCategory == 48  
                        or skillCategory == 50  
                        or skillCategory == 51  
                        or skillCategory == 55  
                        or skillCategory == 56  
                        or skillCategory == 61  
                        or skillCategory == 66  
                        or skillCategory == 67  
                        or skillCategory == 69 
                        or skillCategory == 82 
                        or skillCategory == 83 
                        or skillCategory == 88 
                        or skillCategory == 120 
                        then
                        if self.dizzinessEffect ~= nil then 
                            --眩晕
                            self.dizzinessEffect._LastsCountTurns = 0
                            deleteEffectFile(self.dizzinessEffect)
                            self.dizzinessEffect = nil
                            self.move_state = self._move_state_enum._MOVE_STATE_WAIT
                        end
                        if self._poisoning_effice ~= nil then
                            --中毒
                            self._poisoning_effice._LastsCountTurns = 0
                            deleteEffectFile(self._poisoning_effice)
                            self._poisoning_effice = nil
                        end
                        if self._burn_effice ~= nil then
                            --燃烧
                            self._burn_effice._LastsCountTurns = 0
                            deleteEffectFile(self._burn_effice)
                            self._burn_effice = nil
                        end
                        if self._invincible_effice ~= nil then
                            deleteEffectFile(self._invincible_effice)
                            self._invincible_effice = nil
                        end
                        self.buffList[""..k] = nil
                        -- print("清理：：", k)
                        local armatureEffect = self.buffEffectList[k]
                        if armatureEffect ~= nil then
                            armatureEffect._LastsCountTurns = 0
                            deleteEffectFile(armatureEffect)
                            self.buffEffectList[k] = nil
                        end

                        -- 清除负面BUFF后，更新角色的行动状态
                        if 0 == self.roleCamp then
                            if nil ~= _ED._fightModule then
                                local state = _ED._fightModule:getSelfAttackStatus(tonumber(self._info._pos))
                                if 0 < state then
                                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizziness"})
                                    state_machine.excute("fight_qte_controller_init_role_qte_state", 0, {slot = tonumber(self._info._pos), state = state})
                                end
                            end
                            
                            if k == "5" then
                                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizzy"})
                            elseif k == "8" then
                                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unsilence"})
                            elseif k == "81" then
                                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unexile"})
                            elseif k == "84" or k == "129" then
                                self:resetArmatureColorAndSpeed()
                                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unstone"})
                            end
                        end
                    end
                end
            end
        elseif defenderST == "104" then
             --清除
             -- print("清除负面BUFF 104 :", self.roleCamp, self._info._pos, defenderST)
            if skillId ~= nil then 
                for k,v in pairs(self.buffList) do
                    local skillCategory = tonumber(k)

                    for _, v in pairs(FightRole.DebuffList) do
                        if skillCategory == v then
                            if self.dizzinessEffect ~= nil then 
                                --眩晕
                                self.dizzinessEffect._LastsCountTurns = 0
                                deleteEffectFile(self.dizzinessEffect)
                                self.dizzinessEffect = nil
                                self.move_state = self._move_state_enum._MOVE_STATE_WAIT
                            end
                            if self._poisoning_effice ~= nil then
                                --中毒
                                self._poisoning_effice._LastsCountTurns = 0
                                deleteEffectFile(self._poisoning_effice)
                                self._poisoning_effice = nil
                            end
                            if self._burn_effice ~= nil then
                                --燃烧
                                self._burn_effice._LastsCountTurns = 0
                                deleteEffectFile(self._burn_effice)
                                self._burn_effice = nil
                            end
                            if self._invincible_effice ~= nil then
                                deleteEffectFile(self._invincible_effice)
                                self._invincible_effice = nil
                            end
                            self.buffList[""..k] = nil
                            -- print("清理：：", k)
                            local armatureEffect = self.buffEffectList[k]
                            if armatureEffect ~= nil then
                                armatureEffect._LastsCountTurns = 0
                                deleteEffectFile(armatureEffect)
                                self.buffEffectList[k] = nil
                            end

                            -- 清除负面BUFF后，更新角色的行动状态
                            if 0 == self.roleCamp then
                                if nil ~= _ED._fightModule then
                                    local state = _ED._fightModule:getSelfAttackStatus(tonumber(self._info._pos))
                                    if 0 < state then
                                        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizziness"})
                                        state_machine.excute("fight_qte_controller_init_role_qte_state", 0, {slot = tonumber(self._info._pos), state = state})
                                    end
                                end
                                
                                if k == "5" then
                                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizzy"})
                                elseif k == "8" then
                                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unsilence"})
                                elseif k == "81" then
                                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unexile"})
                                elseif k == "84" or k == "129" then
                                    self:resetArmatureColorAndSpeed()
                                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unstone"})
                                end
                            end
                            break
                        end
                    end
                end
            end
        elseif defenderST == "107" then
            --清除
            -- print("清除正面BUFF 107 :", self.roleCamp, self._info._pos, defenderST)
            if skillId ~= nil then 
                for k,v in pairs(self.buffList) do
                    local skillCategory = tonumber(k)

                    for _, v in pairs(FightRole.GainBuffList) do
                        if skillCategory == v then
                            self.buffList[""..k] = nil
                            -- print("清理：：", k)
                            local armatureEffect = self.buffEffectList[k]
                            if armatureEffect ~= nil then
                                armatureEffect._LastsCountTurns = 0
                                deleteEffectFile(armatureEffect)
                                self.buffEffectList[k] = nil
                            end
                            break
                        end
                    end
                end
            end
        else
            numberFilePath = "images/ui/number/xue.png"
            armatureBase._role._hp = zstring.tonumber(armatureBase._role._hp) + tonumber(drawString)
            armatureBase._role._lhp = _def.aliveHP
            showRoleHP(armatureBase, def)
            -- 绘制连击伤害
            if self.attacker ~= nil and self.attacker.roleCamp ~= nil then
                if defenderST == "0" then
                    state_machine.excute("draw_hit_damage_draw_hit_count", 0, {1, self.attacker.roleCamp})
                    state_machine.excute("draw_hit_damage_draw_hit_damage", 0, {math.abs(tonumber(drawString)), self.attacker.roleCamp})
                end

                if defenderST ~= "41" then
                    if 0 == self.attacker.roleCamp and self.attacker.skillQuality == 1 then
                        state_machine.excute("fight_qte_controller_update_draw_power_skill_total_damage", 0, drawString)
                    end
                end
            end
            self:changeToByAttackAction()
        end
    elseif defState == "1" then
        if defenderST == "0" then
            -- 闪避
            local miss = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shanbi.png")
            miss:setAnchorPoint(cc.p(0.5, 0.5))
            -- miss:setScale(1.2)
            -- miss:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
            miss:setPosition(cc.p(self:getParent():getPositionX() + self:getPositionX(), self:getParent():getPositionY() + size.height)) 
            local map = self:getParent():getParent()
            map:addChild(miss, kZOrderInFightScene_Hurt)
            
            local seq = cc.Sequence:create(
                cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
                cc.CallFunc:create(removeFrameObjectFuncN)
            )
            miss:runAction(seq)
            -- cleanBuffEffectWithMiss(armatureBase._posTile,true)
        end
    elseif defState == "2" or defState == "4" then
        if armature._hnb ~= true then
            if defenderST == "1" then
                numberFilePath = "images/ui/number/baoji.png"
            else
                numberFilePath = "images/ui/number/baoji.png"
            end
            --armature._hnb = true
            armatureBase._role._hp = zstring.tonumber(armatureBase._role._hp) + tonumber(drawString)
            armatureBase._role._lhp = _def.aliveHP
            showRoleHP(armatureBase, def)

            -- state_machine.excute("fight_role_controller_update_hp_progress", 0, {self.roleCamp, tonumber(drawString)})
            
            -- 绘制连击伤害
            if defenderST == "0" and self.attacker ~= nil then -- Fury 3-oct: como la rama de impacto (FightRole:5442)
                state_machine.excute("draw_hit_damage_draw_hit_count", 0, {1, self.attacker.roleCamp})
                state_machine.excute("draw_hit_damage_draw_hit_damage", 0, {math.abs(tonumber(drawString)), self.attacker.roleCamp})
            end
            self:changeToByAttackAction()
        end
        
        if defenderST ~= "41" and self.attacker ~= nil then
            if 0 == self.attacker.roleCamp and self.attacker.skillQuality == 1 then
                state_machine.excute("fight_qte_controller_update_draw_power_skill_total_damage", 0, drawString)
            end
        end
    elseif defState == "3" then
        -- 格挡
    ---elseif defState == "4" then
        -- 暴击加挡格
    end
    
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        
    else
        if defenderST == "2" or defenderST == "3" then
            if _def.stVisible == "1"  and  defState ~= "1" and defState ~= "5" then
                -- print("怒气动画", defenderST == "2" and "1" or "-1")
                local spSprite = cc.Sprite:createWithSpriteFrameName(string.format("images/ui/battle/%s.png", defenderST == "2" and "nuqijia" or "nuqijian"))
                spSprite:setAnchorPoint(cc.p(0.5, 0.5))
                -- spSprite:setPosition(cc.p(tempX + (widgetSize.width) / 2, tempY + widgetSize.height / 2.0)) 
                spSprite:setPosition(cc.p(self:getParent():getPositionX() + self:getPositionX(), self:getParent():getPositionY() + size.height)) 
                local map = self:getParent():getParent()
                map:addChild(spSprite, kZOrderInFightScene_Hurt)
                -- spSprite:setScale(1.2)
                local seq = cc.Sequence:create(
                    cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, (defenderST == "2" and 1 or -1) * 100 / CC_CONTENT_SCALE_FACTOR())),
                    cc.CallFunc:create(removeFrameObjectFuncN)
                )
                spSprite:runAction(seq)
            end
        end
    end
    
    if numberFilePath ~= nil and drawString ~= nil then
        local isHaveBaoJi = false
        if defState == "2" or defState == "4" then
            isHaveBaoJi = true
        end
        if _value > 0 or true then
            local typeDamage = ENUM_TYPE_DAMAGE.TYPE_DAMAGE_NORMAL
            local skillCategory = zstring.tonumber(defenderST)
            if BattleSkill.isLifeChainSkill(skillCategory) then
                typeDamage = ENUM_TYPE_DAMAGE.TYPE_DAMAGE_INDIRECT
            end
            self:showChangeHpNumberAni(numberFilePath, drawString, isHaveBaoJi, defState, false, typeDamage)
        end

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            local armature = self.armature
            local skillInfluenceElementData = armature._sie_action
            if nil ~= skillInfluenceElementData then
                -- debug.print_r(skillInfluenceElementData)
                local bear_sound_effect_ids = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.bear_sound_effect_id), ",")
                self.drawDamageNumberCount = self.drawDamageNumberCount or 0
                local musicid = 0
                local len = #bear_sound_effect_ids
                if self.drawDamageNumberCount > len - 1 then
                    musicid = zstring.tonumber(bear_sound_effect_ids[len])
                else
                    musicid = zstring.tonumber(bear_sound_effect_ids[self.drawDamageNumberCount])
                end
                -- print('executeEffectSkillEnd1 -> musicId', self.drawDamageNumberCount, musicid)
                -- debug.print_r(bear_sound_effect_ids)
                if nil ~= musicid and musicid > 0 then
                    playEffectMusic(musicid)
                end
            end
        end
    end
    
    if defenderST == "0" and isBuff == false then
        armature._hurtCount = armature._hurtCount + 1
    end
end

function FightRole:showChangeHpNumberAni( numberFilePath, drawString, isHaveBaoJi, defState, isHaveRealDamage, typeDamage)
    if self.parent ~= nil then
        -- print("FightRole:showChangeHpNumberAni 变化值：".."numberFilePath="..numberFilePath.." drawString=".. drawString, " isHaveBaoJi = ", isHaveBaoJi, " defState = ", defState, " isHaveRealDamage = ", isHaveRealDamage)
        local map = self:getParent():getParent()
        local size = self:getContentSize()
        local tempDrawX = self:getParent():getPositionX() + self:getPositionX()
        local tempDrawY = self:getParent():getPositionY() + size.height
        local _numberNode = self:drawAntNumber(map, drawString, numberFilePath, tempDrawX, tempDrawY, size, self._hurtCount, isHaveBaoJi, false, defState, isHaveRealDamage, typeDamage)
    end
end

function FightRole:getCampEffectId(_skillInfluenceElementData, camp, effect_index)
    -- local camp = zstring.tonumber(camp)
    -- local effectIds = zstring.split(dms.atos(_skillInfluenceElementData, effect_index), ",")
    -- local effectId = zstring.tonumber(effectIds[camp])
    -- return effectId
    return dms.atoi(_skillInfluenceElementData, effect_index)
end

-- 加载光效资源文件
-- effect_6006.ExportJson
function FightRole:loadEffectFile(fileIndex)
    local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    local armatureName = string.format("effice_%d", fileIndex)
    return armatureName, fileName
end

function FightRole:createEffect(fileIndex, fileNameFormat, animationNames)
    -- 创建光效
    local armature = nil
    if animationMode == 1 then
        -- armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        -- armature.animationNameList = spineAnimations
        -- sp.initArmature(armature, true)
        animationNames = animationNames or effectAnimations
        armature = sp.spine_effect(fileIndex, animationNames[1], false, nil, nil, nil, nil, nil, nil, fileNameFormat)
        armature.animationNameList = animationNames
        sp.initArmature(armature, true)
        armature._fileName = "" .. fileIndex
    else
        local armatureName, fileName = self:loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end
    -- table.insert(self.animationList, {fileName = fileName, armature = armature})
    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    local _tcamp = zstring.tonumber(""..self.roleCamp)
    local _armatureIndex = 0 -- frameListCount * _tcamp
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    armature:getAnimation():setSpeedScale(1.0 / __fight_recorder_action_time_speed)
    
    local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
    armature._duration = duration / 60.0
    return armature
end

function FightRole:createEffectExt(armaturePad, fileIndex, _camp, addToTile, index, totalCount)
    -- 创建光效
    -- local armatureName, fileName = self:loadEffectFile(fileIndex)
    -- local armature = ccs.Armature:create(armatureName)
    -- armature._fileName = fileName
    local posTile = armaturePad or self:getParent()
    local armature = nil
    if animationMode == 1 then
        armature = sp.spine_effect(fileIndex, effectAnimations[1], false, nil, nil, nil)
        armature.animationNameList = effectAnimations
        sp.initArmature(armature, true)
    else
        local armatureName, fileName = self:loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end

    -- table.insert(self.animationList, {fileName = fileName, armature = armature})
    local tempX, tempY  = posTile:getPosition()
    armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2, tempY + posTile:getContentSize().height/2))
    -- local armatureIndex = totalCount * ((_camp + 1)%2) + index
    local armatureIndex = index
    --> -->___rint("createEffectExt->:", armatureIndex, _camp, index)
    armature:getAnimation():playWithIndex(armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    if addToTile == true then
        armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
        posTile:addChild(armature, kZOrderInMap_Effect)
    else    
        posTile:getParent():addChild(armature, kZOrderInFightScene_Effect)
    end
    armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
    return armature
end

function FightRole:createEffectCoverSkill(armaturePad, fileIndex, _camp, addToTile) 
    -- 创建光效
    local armatureName, fileName = self:loadEffectFile(fileIndex)
    local posTile = armaturePad or self:getParent()
    -- local armature = ccs.Armature:create(armatureName)
    -- armature._fileName = fileName
    local armature = nil
    if animationMode == 1 then
        armature = sp.spine_effect(fileIndex, effectAnimations[1], false, nil, nil, nil)
        armature.animationNameList = effectAnimations
        sp.initArmature(armature, true)
    else
        local armatureName, fileName = self:loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end
    -- table.insert(self.animationList, {fileName = fileName, armature = armature})
    local tempX, tempY  = posTile:getPosition()
    armature:setPosition(cc.p(tempX + posTile:getContentSize().width/2, tempY + posTile:getContentSize().height/2))
    
    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    local _tcamp = zstring.tonumber("".._camp)
    local _armatureIndex = frameListCount * _tcamp
    -->___rint("frameListCount->", frameListCount, _camp, _armatureIndex)
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    if addToTile == true then
        armature:setPosition(cc.p(posTile:getContentSize().width/2, posTile:getContentSize().height/2))
        posTile:addChild(armature, kZOrderInFightScene_sp_effect)
    else    
        posTile:getParent():addChild(armature, kZOrderInFightScene_Effect)
    end
    armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
    return armature
end    
    
local function onMoveFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
    if FightRole.__skeep_fighting == true then
        return
    end
    -- local info = string.format("(%s) emit a frame event (%s) originFrame(%d)at frame index (%d).", bone:getName(),evt,originFrameIndex, currentFrameIndex)
    -->  --> -->___rint("onMoveFrameEvent:(info)->", info)
    local pos = string.find(evt, "start_move_")
    if pos ~= nil then
        local stime = string.sub(evt, pos+#"start_move_", #evt)
        --> -->___rint("stime:", stime)
        if stime ~= nil and #stime > 0 then
            local armature = bone:getArmature()
            --> -->___rint(tonumber(stime) / 60)
            armature:runAction(cc.MoveTo:create(tonumber(stime) / 60 * __fight_recorder_action_time_speed, armature._move_position))
            -- armature:runAction(cc.MoveTo:create(tonumber(stime) * 60 / 1000, cc.p(100, 500)))
        end
    end
end

function FightRole:createFlyingEffect(index, totalCount, bone,evt,originFrameIndex,currentFrameIndex)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    local armature = bone:getArmature()
    local skillInfluenceElementData = armature._sie_action
    local posterior_lighting_effect_id = self:getCampEffectId(skillInfluenceElementData, self.roleCamp, skill_influence.posterior_lighting_effect_id)    --dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)

    local armatureEffect = self:createEffectExt(nil, posterior_lighting_effect_id, self.roleCamp, false, index, totalCount)
    armatureEffect._invoke = deleteEffectFile
    armatureEffect:getAnimation():setFrameEventCallFunc(onMoveFrameEvent)

    if armature.roleCamp == 1 then
        armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
    end

    local angle = armature._angle
    local start_pos = armature._start_position
    local _end_position = armature._end_position

    --> -->___rint("_end_position:", index, totalCount, armature._angle, start_pos.x, start_pos.y, _end_position.x, _end_position.y)
    armatureEffect:setRotation(angle)
    armatureEffect:setPosition(start_pos)
    -- armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration, end_pos))

    armatureEffect._move_position = _end_position
end

function FightRole:createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    local armature = bone:getArmature()
    -- local frameListCount = math.ceil(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    -- local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount())
    -->___rint("创建飞行光效", frameListCount)
    for i=2,frameListCount do
        -->___rint("创建飞行光效kkk", i-1)
        self:createFlyingEffect(i - 1, frameListCount, bone,evt,originFrameIndex,currentFrameIndex)
    end
end

function FightRole:executeEffectSkillEndOverEx(armatureBack)
    deleteEffectFile(armatureBack)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end

    self.drawByAttackEffectCount = self.drawByAttackEffectCount - 1
    if self.drawByAttackEffectCount < 0 then
        self.drawByAttackEffectCount = 0
    end

    if self.repelAndFlyEffectCount > 0 or self.roleAttacking == true then
        return
    end

    if self.repelAndFlyEffectCount <= 0 then
        -- 进入待机状态
        -- self.armature._invoke = nil
        -- self.armature._actionIndex = _enum_animation_l_frame_index.animation_standby
        self.armature._nextAction = _enum_animation_l_frame_index.animation_standby
        -- self.armature:getAnimation():playWithIndex(self.armature._actionIndex)
        -- self.armature._invoke = self.changeActionCallback
    end

    -- state_machine.excute("fight_role_check_move_event", 0, self)



    -- local attacker = self..__attackercurrent_fight_data
    -->___rint("------", self.waitByAttackOverDeathEvent, self.drawByAttackEffectCount)
    if self.drawByAttackEffectCount == 0 then
        if self.waitByAttackOverDeathEvent == true then
            self.waitByAttackOverDeathEvent = false
            -->___rint("00000000033333000000", self.roleWaitDeath)
            if self.roleWaitDeath == true then
                -->___rint("000000000000000")
                self:checkByAttackEnd()
            else
                self:checkByAttackEnd()
            end
        else
            if self.waitByAttackOver == true then
                self.waitByAttackOver = false
                -->___rint("8888888888")
                self:checkByAttackEnd()
                -- self:checkByAttackDeath()
            else
                
            end
        end
    end
end

local function executeEffectSkillEndOver(armatureBack)
    local _self = armatureBack._self
    if _self ~= nil and _self.parent ~= nil then
        _self:executeEffectSkillEndOverEx(armatureBack)
    end
end

function FightRole:executeEffectSkillEnd(isPlaySound)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end

    local armature = self.armature
    local skillInfluenceElementData = armature._sie_action

    local bear_lighting_effect_id = self:getCampEffectId(skillInfluenceElementData, self.roleCamp, skill_influence.bear_lighting_effect_id)

    if nil ~= bear_lighting_effect_id and bear_lighting_effect_id >= 0 then
        local armatureEffect = self:createEffect(bear_lighting_effect_id)
        armatureEffect._self = self
        if true or animationMode == 1 then
        else
            armatureEffect._invoke = executeEffectSkillEndOver
        end

        local frameListCount = math.floor(armatureEffect:getAnimation():getAnimationData():getMovementCount())
        self.byAttackEffectIndex = self.byAttackEffectIndex % frameListCount
        armatureEffect:getAnimation():playWithIndex(self.byAttackEffectIndex)
        self.byAttackEffectIndex = self.byAttackEffectIndex + 1

        if true or animationMode == 1 then
            armatureEffect._invoke = executeEffectSkillEndOver
        end

        local size = self:getContentSize()
        armatureEffect:setPosition(cc.p(size.width / 2, 0))
        if self.roleCamp == 1 then
            armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
        end
        self:addChild(armatureEffect)

        self.drawByAttackEffectCount = self.drawByAttackEffectCount + 1

        -- local map = self:getParent()
        -- map:addChild(armatureEffect)

        -- local size = self:getParent():getContentSize()
        -- local sx, sy = self:getParent():getPosition()
        -- armatureEffect:setPosition(cc.p(sx, sy))
        -- if self.roleCamp == 1 then
        --     armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
        -- end
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        -- local bear_sound_effect_ids = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.bear_sound_effect_id), ",")
        -- self.drawDamageNumberCount = self.drawDamageNumberCount or 0
        -- local musicid = 0
        -- local len = #bear_sound_effect_ids
        -- if self.drawDamageNumberCount >= len - 1 then
        --     musicid = zstring.tonumber(bear_sound_effect_ids[len])
        -- else
        --     musicid = zstring.tonumber(bear_sound_effect_ids[self.drawDamageNumberCount + 1])
        -- end
        -- print('executeEffectSkillEnd -> musicId', self.drawDamageNumberCount, musicid)
        -- debug.print_r(bear_sound_effect_ids)
        -- if nil ~= musicid and musicid > 0 then
        --     playEffectMusic(musicid)
        -- end
    else
        local bear_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.bear_sound_effect_id)
        if bear_sound_effect_id >= 0 and isPlaySound == true then
            playEffectMusic(bear_sound_effect_id)
        end
    end
end

-- 执行被击飞动作
function FightRole:executeHitRepelAndFlyEffect(_type, _positionx, _positiony)

    -- local frameTime = _type == 0 and 0.1 * 10 or 0.3 * 10

    -- -->___rint("...............", frameTime, _type, _positionx, _positiony, (frameTime * __fight_recorder_action_time_speed))

    -- local actionParmas = {
    --     cc.MoveBy:create(frameTime * __fight_recorder_action_time_speed, cc.p((self.roleCamp == 0 and -1 or 1) * _positionx / 2, _positiony)),
    --     cc.MoveBy:create(frameTime * __fight_recorder_action_time_speed, cc.p((self.roleCamp == 0 and -1 or 1) * _positionx / 2, -1 * _positiony)),
    --     cc.CallFunc:create(hitRepelAndFlyEffectFunN)
    -- }

    -- -- self.parent:stopAllActionsByTag(2)
    -- -- hitRepelAndFlyEffectFunN(self.parent)

    -- local seq = cc.Sequence:create(actionParmas)
    -- self.parent:runAction(seq)
    -- self.repelAndFlyEffectCount = self.repelAndFlyEffectCount + 1

    -- -- self.armature._actionIndex = _enum_animation_l_frame_index.animation_normal_be_attaked
    -- self.armature._nextAction = _enum_animation_l_frame_index.animation_normal_be_attaked
    -- -- self.armature.getAnimation():playWithIndex(self.armature._actionIndex)

    -- self.parent:stopAllActionsByTag(3)

    if self.is_killed == true 
        or self.is_deathed == true 
        or self.borderBounce == true
        then
        return
    end
    -- self.parent:stopAllActions()
    self.parent:stopAllActionsByTag(100)
    self.parent:stopAllActionsByTag(101)
    self.repelAndFlyEffectCount = self.repelAndFlyEffectCount + 1
    if self.repelAndFlyEffectCount > 1 then
        hitRepelAndFlyEffectFunN(self.parent)
    end

    local nextActionIndex = _enum_animation_l_frame_index.animation_normal_be_attaked
    if animationMode == 1 then
        local lastY = math.abs(_positiony) + (self.parent:getPositionY() - self.parent._base_pos.y)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            -- 直接进入空中持续浮空被击
            nextActionIndex = _enum_animation_l_frame_index.animation_vertical_floated
        else
            if lastY > _battle_controller._air_hurt_min_height then
                nextActionIndex = _enum_animation_l_frame_index.animation_vertical_floated
            else
                nextActionIndex = _enum_animation_l_frame_index.animation_standby
            end
        end
    end

    local flag = (self.roleCamp == 0 and -1 or 1)
    local mdx = 0
    local tb = 1 --1.5

    -- 校准击飞的宽度
    -- _battle_controller._byattck_flight_width  -- 击飞的宽度
    -- _battle_controller._byattck_flight_height -- 击飞的高度
    local dx, dy = self.parent:getPosition()
    if _battle_controller._byattck_flight_width ~= nil then
        if _positionx > 0 then
            _positionx = math.min(_positionx, math.max(0, flag * ((self.parent._base_pos.x + flag * _battle_controller._byattck_flight_width) - dx)))
        else
            _positionx = -1 * math.min(math.abs(_positionx), math.abs((self.parent._base_pos.x - flag * _battle_controller._byattck_flight_width) - dx))
        end
    end
    if _battle_controller._byattck_flight_height ~= nil then
        if _positiony < 0 then
            local mh = _positiony
            local offsetFlightHeight = ((dy - self.parent._base_pos.y) + _battle_controller._byattck_flight_height) + mh
            if offsetFlightHeight < 0 then
                _positiony = -1 * ((dy - self.parent._base_pos.y) + _battle_controller._byattck_flight_height)
            end
        else
            local offsetFlightHeight = (self.parent._base_pos.y + _battle_controller._byattck_flight_height) - (dy + _positiony)
            if offsetFlightHeight < 0 then
                _positiony = ((self.parent._base_pos.y + _battle_controller._byattck_flight_height) - dy)
            end
        end
    end
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    else
        if _positionx == 0 and _positiony == 0 then
            _positiony = 0.1
        end
    end

    if math.abs(_positiony) > 0 then
        if _positiony < 0 then
            -- local dx, dy = self.parent:getPosition()
            mdx = dx
            local array_x = {}
            local array_y = {}
            if self.parent._swap_pos.y <= dy then
                -- 处理下降的高度
                local h = dy - self.parent._swap_pos.y
                local w = math.abs(_positionx)
                local g = 0.00098 * 2 / 5
                local s = h
                local t = math.sqrt(2 * s * g) / 3
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if self.armature._actionIndex ~= nextActionIndex then
                        self.armature._actionIndex = nextActionIndex
                        self.armature._nextAction = nextActionIndex
                        self.armature:getAnimation():playWithIndex(nextActionIndex)
                    end
                else
                    self.armature._nextAction = nextActionIndex -- _enum_animation_l_frame_index.animation_normal_be_attaked
                end

                local pActionInterval_back_h = cc.MoveBy:create(t * __fight_recorder_action_time_speed, cc.p(0, -1 * h))

                local pSpeed_back_h = cc.EaseSineOut:create(pActionInterval_back_h)

                table.insert(array_y, pSpeed_back_h)

                table.insert(array_y, cc.CallFunc:create(function(sender)
                    if sender._self then
                        sender:setPositionY(sender._base_pos.y)
                        if __lua_project_id == __lua_project_l_naruto then
                            csb.animationChangeToAction(sender._self.armature, _enum_animation_l_frame_index.animation_new_skill_30_dingdian, _enum_animation_l_frame_index.animation_new_skill_31_xia, false)
                        end
                    end
                end))

                w = w * (h / math.abs(_positiony))
                _positiony = math.abs(_positiony + h)

                if w > 0 then
                    if _positionx < 0 then
                        w = -1 * w
                    end
                    _positionx = _positionx - w
                    local pActionInterval_back_w = cc.MoveBy:create(t * __fight_recorder_action_time_speed, cc.p((w + w*0.2) * flag, 0))
                    local pSpeed_back_w = cc.EaseSineOut:create(pActionInterval_back_w)
                    table.insert(array_x, pActionInterval_back_w)
                    mdx = mdx + (w + w*0.2) * flag
                end
            end
            if math.abs(_positiony) > 0 then
                local h = math.abs(_positiony)
                local w = math.abs(_positionx)
                local s = h -- math.min(h, w) -- math.sqrt(w/2*w/2+h/2*h/2)
                -- if s <= 0 then
                --     s = h
                -- end
                local g = 0.00098 * 2 / 5
                local t = math.sqrt(2 * s * g)

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if self.armature._actionIndex ~= nextActionIndex then
                        self.armature._actionIndex = nextActionIndex
                        self.armature._nextAction = nextActionIndex
                        self.armature:getAnimation():playWithIndex(nextActionIndex)
                    end
                else
                    self.armature._nextAction = nextActionIndex -- _enum_animation_l_frame_index.animation_normal_be_attaked
                end

                _positiony = h
                -- local dx, dy = self.parent:getPosition()

                local pActionInterval_h = cc.MoveBy:create(t * __fight_recorder_action_time_speed, cc.p(0, _positiony));
                -- local pActionInterval_back_h = cc.MoveBy:create(t, cc.p(0, -1 * h));
                s = math.abs(dy + _positiony - self.parent._swap_pos.y)
                local t2 = math.sqrt(2 * s * g) / 3
                -- t2 = math.max(t, t2)
                -- local pActionInterval_back_h = cc.MoveBy:create((t + t2) * 2 * tb, cc.p(0, -1 * (_positiony)))
                local pActionInterval_back_h = cc.MoveBy:create((t + t2) * tb * __fight_recorder_action_time_speed, cc.p(0, -1 * (_positiony)))

                local pSpeed_h = cc.EaseSineOut:create(pActionInterval_h)
                local pSpeed_back_h = cc.EaseSineIn:create(pActionInterval_back_h)
                -- local pSpeed_back_h = cc.EaseBounceOut:create(pActionInterval_back_h)

                if __lua_project_id == __lua_project_l_naruto then
                    table.insert(array_y, cc.Sequence:create({pSpeed_h, cc.CallFunc:create(function ( sender )
                        if sender._self then
                            csb.animationChangeToAction(sender._self.armature, _enum_animation_l_frame_index.animation_new_skill_30_dingdian, _enum_animation_l_frame_index.animation_new_skill_31_xia, false)
                        end
                    end)}))
                else
                    table.insert(array_y, pSpeed_h)
                end
                table.insert(array_y, pSpeed_back_h)

                table.insert(array_y, cc.CallFunc:create(function(sender)
                    sender:setPositionY(sender._base_pos.y)
                end))

                local jh = math.abs(_positiony) / 5
                local js = jh
                local jt = math.sqrt(2 * js * g) * tb
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    -- 设置回弹的固定高度
                    js = 20
                    jt = 0.4
                    table.insert(array_y, cc.CallFunc:create(function ( sender )
                        if sender._self then
                            -- sender._self.armature._actionIndex = _enum_animation_l_frame_index.animation_new_skill_29_daodi
                            -- sender._self.armature._nextAction = _enum_animation_l_frame_index.animation_new_skill_29_daodi
                            -- sender._self.armature:getAnimation():playWithIndex(_enum_animation_l_frame_index.animation_new_skill_29_daodi)
                            csb.animationChangeToAction(sender._self.armature, _enum_animation_l_frame_index.animation_new_skill_29_daodi, _enum_animation_l_frame_index.animation_new_skill_29_daodi, false)
                            -- print("切换到倒地动作组1")
                            playEffectMusic(9710)
                        end
                    end))
                end
                table.insert(array_y, cc.JumpBy:create(jt * __fight_recorder_action_time_speed, cc.p(0, 0), js, 1))

                js = jh / 5
                jt = math.sqrt(2 * js * g) * tb * 2
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    -- 设置回弹的固定高度
                    js = 10
                    jt = 0.4
                end
                table.insert(array_y, cc.JumpBy:create(jt * __fight_recorder_action_time_speed, cc.p(0, 0), js, 1))

                table.insert(array_y, cc.CallFunc:create(hitRepelAndFlyEffectFunN))

                if w > 0 then
                    local pActionInterval_w = cc.MoveBy:create(t * __fight_recorder_action_time_speed, cc.p(_positionx/2 * flag, 0))
                    local pActionInterval_back_w = cc.MoveBy:create((t + t2) * tb * __fight_recorder_action_time_speed, cc.p((_positionx/2 + _positionx/2*0.2) * flag, 0))

                    local pSpeed_w = cc.EaseSineIn:create(pActionInterval_w)
                    local pSpeed_back_w = cc.EaseSineOut:create(pActionInterval_back_w)
                    table.insert(array_x, pSpeed_w)
                    table.insert(array_x, pSpeed_back_w)
                    table.insert(array_x, cc.CallFunc:create(function ( sender )
                        if sender._self then
                            sender._self:moveBackPosition()
                        end
                    end))
                    local ret = cc.Sequence:create(array_x)
                    ret:setTag(101)
                    self.parent:runAction(ret)
                    mdx = mdx + _positionx/2 * flag + (_positionx/2 + _positionx/2*0.2) * flag
                end

                local ret = cc.Sequence:create(array_y)
                ret:setTag(100)
                self.parent:runAction(ret)
            end
        else
            local h = math.abs(_positiony)
            local w = math.abs(_positionx)
            local s = h -- math.min(h, w) -- math.sqrt(w/2*w/2+h/2*h/2)
            -- if s <= 0 then
            --     s = h
            -- end
            local g = 0.00098 * 2 / 5
            local t = math.sqrt(2 * s * g)

            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                if self.armature._actionIndex ~= nextActionIndex then
                    self.armature._actionIndex = nextActionIndex
                    self.armature._nextAction = nextActionIndex
                    self.armature:getAnimation():playWithIndex(nextActionIndex)
                end
            else
                self.armature._nextAction = nextActionIndex -- _enum_animation_l_frame_index.animation_normal_be_attaked
            end

            -- local dx, dy = self.parent:getPosition()
            mdx = dx

            local pActionInterval_h = cc.MoveBy:create(t * __fight_recorder_action_time_speed, cc.p(0, _positiony));
            -- local pActionInterval_back_h = cc.MoveBy:create(t, cc.p(0, -1 * h));
            s = math.abs(dy + h - self.parent._swap_pos.y)
            local t2 = math.sqrt(2 * s * g) / 3
            -- t2 = math.max(t, t2)
            -- local pActionInterval_back_h = cc.MoveBy:create((t + t2) * 2 * tb, cc.p(0, -1 * (dy + _positiony - self.parent._swap_pos.y)))
            local pActionInterval_back_h = cc.MoveBy:create((t + t2) * tb * __fight_recorder_action_time_speed, cc.p(0, -1 * (dy + _positiony - self.parent._swap_pos.y)))

            local pSpeed_h = cc.EaseSineOut:create(pActionInterval_h)
            local pSpeed_back_h = cc.EaseSineIn:create(pActionInterval_back_h)
            -- local pSpeed_back_h = cc.EaseBounceOut:create(pActionInterval_back_h)

            if w > 0 then
                local pActionInterval_w = cc.MoveBy:create(t * __fight_recorder_action_time_speed, cc.p(_positionx/2 * flag, 0))
                local pActionInterval_back_w = cc.MoveBy:create((t + t2) * tb * __fight_recorder_action_time_speed, cc.p((_positionx/2 + _positionx/2*0.2) * flag, 0))

                local pSpeed_w = cc.EaseSineIn:create(pActionInterval_w)
                local pSpeed_back_w = cc.EaseSineOut:create(pActionInterval_back_w)
                local ret = cc.Sequence:create({pSpeed_w, pSpeed_back_w, cc.CallFunc:create(function ( sender )
                        if sender._self then
                            sender._self:moveBackPosition()
                        end
                    end)})
                ret:setTag(101)
                self.parent:runAction(ret)
                mdx = mdx + _positionx/2 * flag + (_positionx/2 + _positionx/2*0.2) * flag
            end


            local array_y = {}

            if __lua_project_id == __lua_project_l_naruto then
                table.insert(array_y, cc.Sequence:create({pSpeed_h, cc.CallFunc:create(function ( sender )
                    if sender._self then
                        csb.animationChangeToAction(sender._self.armature, _enum_animation_l_frame_index.animation_new_skill_30_dingdian, _enum_animation_l_frame_index.animation_new_skill_31_xia, false)
                    end
                end)}))
            else
                table.insert(array_y, pSpeed_h)
            end
            table.insert(array_y, pSpeed_back_h)

            table.insert(array_y, cc.CallFunc:create(function(sender)
                sender:setPositionY(sender._base_pos.y)
            end))

            local jh = s / 5
            local js = jh
            local jt = math.sqrt(2 * js * g) * tb
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                -- 设置回弹的固定高度
                js = 20
                jt = 0.4
                table.insert(array_y, cc.CallFunc:create(function ( sender )
                    if sender._self then
                        -- sender._self.armature._actionIndex = _enum_animation_l_frame_index.animation_new_skill_29_daodi
                        -- sender._self.armature._nextAction = _enum_animation_l_frame_index.animation_new_skill_29_daodi
                        -- sender._self.armature:getAnimation():playWithIndex(_enum_animation_l_frame_index.animation_new_skill_29_daodi)
                        csb.animationChangeToAction(sender._self.armature, _enum_animation_l_frame_index.animation_new_skill_29_daodi, _enum_animation_l_frame_index.animation_new_skill_29_daodi, false)
                        -- print("切换到倒地动作组2")
                        playEffectMusic(9710)
                    end
                end))
            end
            table.insert(array_y, cc.JumpBy:create(jt * __fight_recorder_action_time_speed, cc.p(0, 0), js, 1))

            js = jh / 5
            jt = math.sqrt(2 * js * g) * tb * 2
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                -- 设置回弹的固定高度
                js = 10
                jt = 0.1
            end
            table.insert(array_y, cc.JumpBy:create(jt * __fight_recorder_action_time_speed, cc.p(0, 0), js, 1))

            table.insert(array_y, cc.CallFunc:create(hitRepelAndFlyEffectFunN))

            -- local ret = cc.Sequence:create({pSpeed_h, pSpeed_back_h, cc.CallFunc:create(hitRepelAndFlyEffectFunN)})
            local ret = cc.Sequence:create(array_y)
            ret:setTag(100)
            self.parent:runAction(ret)
        end
    elseif math.abs(_positionx) > 0 then
        -- local dx, dy = self.parent:getPosition()
        mdx = dx
        local array_y = {}
        local yt = 0
        if dy > self.parent._swap_pos.y then
            local h = dy - self.parent._swap_pos.y
            local w = 0
            local g = 0.00098 * 2 / 5
            local t = math.sqrt(2 * h * g)
            -- local pActionInterval_back_h = cc.MoveBy:create(t * 2 * tb, cc.p(0, -1 * h))
            -- local pSpeed_back_h = cc.EaseBounceOut:create(pActionInterval_back_h)

            yt = t * tb
            local pActionInterval_back_h = cc.MoveBy:create(t * tb * __fight_recorder_action_time_speed, cc.p(0, -1 * h))
            local pSpeed_back_h = cc.EaseSineIn:create(pActionInterval_back_h)

            -- local ret = cc.Sequence:create({pSpeed_back_h})
            -- ret:setTag(101)
            -- self.parent:runAction(ret)
            table.insert(array_y, pSpeed_back_h)

            table.insert(array_y, cc.CallFunc:create(function(sender)
                    sender:setPositionY(sender._base_pos.y)
                end))

            local jh = h / 5
            local js = jh
            local jt = math.sqrt(2 * js * g) * tb
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                -- 设置回弹的固定高度
                js = 20
                jt = 0.4
                table.insert(array_y, cc.CallFunc:create(function ( sender )
                    if sender._self then
                        -- sender._self.armature._actionIndex = _enum_animation_l_frame_index.animation_new_skill_29_daodi
                        -- sender._self.armature._nextAction = _enum_animation_l_frame_index.animation_new_skill_29_daodi
                        -- sender._self.armature:getAnimation():playWithIndex(_enum_animation_l_frame_index.animation_new_skill_29_daodi)
                        csb.animationChangeToAction(sender._self.armature, _enum_animation_l_frame_index.animation_new_skill_29_daodi, _enum_animation_l_frame_index.animation_new_skill_29_daodi, false)
                        -- print("切换到倒地动作组3")
                        playEffectMusic(9710)
                    end
                end))
            end
            table.insert(array_y, cc.JumpBy:create(jt * __fight_recorder_action_time_speed, cc.p(0, 0), js, 1))

            yt = yt + jt

            js = jh / 5
            jt = math.sqrt(2 * js * g) * tb * 2
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                -- 设置回弹的固定高度
                js = 10
                jt = 0.1
            end
            table.insert(array_y, cc.JumpBy:create(jt * __fight_recorder_action_time_speed, cc.p(0, 0), js, 1))
            yt = yt + jt
        else
            tb = 1
        end

        local h = 0
        local w = _positionx
        local g = 0.00098 * 4 / 5
        local t = math.sqrt(2 * math.abs(w) * g)

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            if self.armature._actionIndex ~= nextActionIndex then
                self.armature._actionIndex = nextActionIndex
                self.armature._nextAction = nextActionIndex
                self.armature:getAnimation():playWithIndex(nextActionIndex)
            end
        else
            self.armature._nextAction = nextActionIndex -- _enum_animation_l_frame_index.animation_normal_be_attaked
        end

        if dy > self.parent._swap_pos.y then
            local pActionInterval_w = cc.MoveBy:create(t * 2 * tb * __fight_recorder_action_time_speed, cc.p((w + w * 0.2) * flag, 0))
            local pSpeed_w = cc.EaseExponentialOut:create(pActionInterval_w)
            if yt > (t * 2 * tb) then
                local ret = cc.Sequence:create({pSpeed_w})
                ret:setTag(100)
                self.parent:runAction(ret)
                mdx = mdx + (w + w * 0.2) * flag

                table.insert(array_y, cc.CallFunc:create(hitRepelAndFlyEffectFunN))
            else
                local ret = cc.Sequence:create({pSpeed_w, cc.CallFunc:create(hitRepelAndFlyEffectFunN)})
                ret:setTag(100)
                self.parent:runAction(ret)
                mdx = mdx + (w + w * 0.2) * flag
            end
            local ret = cc.Sequence:create(array_y)
            ret:setTag(101)
            self.parent:runAction(ret)
        else
            local pActionInterval_w = cc.MoveBy:create(t * __fight_recorder_action_time_speed, cc.p(w * flag, 0))
            local pSpeed_w = cc.EaseExponentialOut:create(pActionInterval_w)
            local ret = cc.Sequence:create({pSpeed_w, cc.CallFunc:create(hitRepelAndFlyEffectFunN)})
            ret:setTag(100)
            self.parent:runAction(ret)
            mdx = mdx + w * flag
        end
    end
    self._mdx = mdx
end

function FightRole:createRoleDefendEffect()
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end

    local armature = self.armature

    local _effect_id = _battle_controller._explode_effice_id

    if _effect_id >= 0 then
        local armatureEffect = self:createEffect(_effect_id)
        armatureEffect._invoke = deleteEffectFile

        local size = self:getContentSize()
        -- armatureEffect:setPosition(cc.p(size.width / 2, 0))
        armatureEffect:setPosition(cc.p(self.parent:getPosition()))
        self.parent:getParent():addChild(armatureEffect)
    end
end

function FightRole:changeToByAttackAction( ... )
    if nil == self.current_fight_data or nil == self.current_fight_data.__attackArmature then
        return
    end
    if self.repelAndFlyEffectCount <= 0 and self.roleCamp ~= self.current_fight_data.__attackArmature._self.roleCamp then
        local armature = self.armature
        if nil == armature._sie_action then
            return
        end

        local actionIndexs = zstring.split(dms.atos(armature._sie_action, skill_influence.army_bear_action), ",")
        local actionIndex = zstring.tonumber(actionIndexs[self.roleCamp] or actionIndexs[1])

        if self.roleByAttacking == true and actionIndex > -1 then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                if actionIndex ~= armature._actionIndex then
                    if self.repelAndFlyEffectCount <= 0 then
                        armature._actionIndex = actionIndex
                        armature._nextAction = actionIndex
                        armature:getAnimation():playWithIndex(actionIndex)
                        armature._nextAction = _enum_animation_l_frame_index.animation_standby
                    end
                end
            else
                armature._actionIndex = actionIndex
                armature._nextAction = actionIndex
                armature:getAnimation():playWithIndex(actionIndex)
            end
        end
    end
end

function checkFrameEvent(events, mode)
    if events ~= n and #events > 0 then
        for i, v in pairs(events) do
            if v == mode then
                return true
            end
        end
    end
    return false
end

-- 不需要进行伤害数据绘图
-- 2   加怒  
-- 3   减怒  
-- 4   封怒（无法积累怒气）老项目废弃 
-- 5   眩晕（无法行动）    
-- 6   腐蚀（中毒）老项目废弃 
-- 7   麻痹（无法行动）    
-- 8   沉默（无法怒气攻击）  
-- 10  集中（老项目废弃）   
-- 11  格挡  
-- 12  无敌  
-- 13  必闪（老项目废弃）   
-- 15  封疗（老项目废弃）   
-- 16  盲目（老项目废弃）   
-- 17  冰冻（无法行动）    
-- 20  无绘制 
-- 21  增加攻击    
-- 22  降低攻击    
-- 23  增加防御    
-- 24  降低防御    
-- 25  受到的伤害增加（老项目废弃）  
-- 26  受到的伤害降低 
-- 27  增加暴击    
-- 28  增加抗暴    
-- 29  增加命中（老项目废弃） 
-- 30  增加闪避（老项目废弃） 
-- 32  清除减益BUFF(清除技能类型5,7,8,9,17,22,24,36,39,47,48,50,51,55,56,61,66,67,69的效用) 
-- 33  造成伤害增加（老项目废弃）   
-- 36  降低治疗效果(对应公式63）  
-- 38  增加格挡强度  
-- 39  降低格挡率   
-- 40  增加吸血率   
-- 42  小技能触发概率 
-- 43  增加破格挡率  
-- 44  增加反弹率   
-- 45  增加伤害减免  
-- 47  降低小技能触发概率   
-- 48  降低暴击伤害  
-- 49  减少造成的必杀伤害   
-- 50  嘲讽  
-- 51  降低伤害加成  
-- 52  增加伤害加成  
-- 53  增加控制率   
-- 54  增加造成的必杀伤害   
-- 55  减少必杀伤害率 
-- 56  降低怒气回复速度    
-- 57  提高怒气回复速度    
-- 58  增加暴击伤害  
-- 60  增加暴击强度  
-- 61  降低伤害减免  
-- 62  增加必杀伤害率 
-- 63  增加格挡率   
-- 64  增加数码兽类型克制伤害加成   
-- 65  增加数码兽类型克制伤害减免   
-- 66  降低暴击率   
-- 67  降低抗暴率   
-- 68  增加必杀抗性  
-- 69  减少必杀抗性  
-- 70  复活概率    
-- 71  复活继承血量  
-- 72  复活继承怒气  
-- 73  增加复活复活概率    
-- 74  增加复活继承血量    
-- 75  被复活概率   
-- 76  被复活继承血量 
-- 77  被复活继承怒气 
-- 78  免疫控制    
-- 80  小技能伤害提升（绘制类型）   

-- 执行被攻击的逻辑
function FightRole:executeByAttackLogic(bone,evt,originFrameIndex,currentFrameIndex, frameEvents, isDrawExplode, attacker)
    local _def = self.current_fight_data.__def
    -- debug.print_r(_def)
    -- print(evt, self.roleCamp, self._info._pos)
    -- debug.print_r(frameEvents)
    if evt ~= nil and #evt > 0 then
        local datas = frameEvents -- zstring.split(evt, "_")
        if checkFrameEvent(datas, "start") == true then
            local tempArmature = armatureBack
            if tempArmature == nil then
                tempArmature = bone:getArmature()
            end
            if tempArmature ~= nil and tempArmature._angle ~= nil then
                -- 创建飞行的光效
                -- print("绘制路径光效！！！", self.roleCamp, tempArmature._self.roleCamp)
                -- if tempArmature._self.roleCamp ~= self.roleCamp then
                    self:createFlyingEffects(bone,evt,originFrameIndex,currentFrameIndex)
                -- end
            end
        end
        if checkFrameEvent(datas, "after") == true then
            if _def~=nil then
                local defenderST = _def.defenderST
                -- 0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格
                local defState = _def.defState
                if defState == "3" or defState == "4" then
                    -- print("3:格挡 4:暴击加挡格")
                    self:updateDrawInfluenceInfo(_def)
                elseif defState == "1" 
                    then
                    -- 取消掉美术闪避的动作帧组的调用，改由后跳的动作来实现闪避的效果
                    -- local armature = self.armature
                    -- local actionIndex = _enum_animation_l_frame_index.animation_miss_action
                    -- if armature._actionIndex ~= actionIndex then
                    --     csb.animationChangeToAction(armature, actionIndex, _enum_animation_l_frame_index.animation_standby, false)
                    -- end
                    -- print("1:闪避")
                    local tempArmature = bone:getArmature()
                    if tempArmature._missed ~= true then
                        tempArmature._missed = true
                        local armature = self.armature
                        local actionIndex = _enum_animation_l_frame_index.animation_pursue_back
                        if armature._actionIndex ~= actionIndex and self.roleCamp ~= self.current_fight_data.__attackArmature._self.roleCamp then
                            if self.repelAndFlyEffectCount > 0 then
                            else
                                csb.animationChangeToAction(armature, actionIndex, _enum_animation_l_frame_index.animation_standby, false)
                            end

                            local move_position = cc.p(self.parent:getPosition())
                            local duration = 0.1
                            if self.roleCamp == 1 then
                                move_position.x = move_position.x + _battle_controller._back_jump_distance
                            else
                                move_position.x = move_position.x - _battle_controller._back_jump_distance
                            end
                            duration = self:getAnimationDuration(armature, actionIndex)
                            self.parent:runAction(cc.MoveTo:create(duration * __fight_recorder_action_time_speed, move_position))
                        end
                    else
                        return
                    end
                else
                    self:updateDrawInfluenceInfo(_def)
                    -- 修改BUFF处理状态(6为中毒，9为灼烧)
                    if (defenderST == "4" or defenderST == "5" or defenderST == "6" or defenderST == "7" or 
                        defenderST == "8" or defenderST == "9" or defenderST == "10" or defenderST == "11" or 
                        defenderST == "12" or defenderST == "13" or defenderST == "15" 
                        or defenderST == "21"
                        or defenderST == "22"
                        or defenderST == "23"
                        or defenderST == "24"
                        or defenderST == "25"
                        or defenderST == "26"
                        or defenderST == "27"
                        or defenderST == "28"
                        or defenderST == "29"
                        or defenderST == "30"
                        or defenderST == "32"
                        or defenderST == "104"
                        or defenderST == "107"
                        or defenderST == "33" -- 33造成伤害增加
                        or defenderST == "51"
                        or defenderST == "106" 
                        or defenderST == "120"
                        ) then
                        -- print("状态1", defenderST)
                    elseif defenderST == "2" 
                            or defenderST == "3"  
                            -- or defenderST == "4" 
                            or defenderST == "5" 
                            or defenderST == "7" 
                            or defenderST == "8" 
                            or defenderST == "10" 
                            or defenderST == "11" 
                            or defenderST == "14"
                            or defenderST == "120" 
                            then
                        -- print("状态2", defenderST)
                    elseif defenderST == "79" then
                        self:addBuffEffect(self, tonumber(_def.stRound), false, defenderST, _def)
                    elseif defenderST == "113" or defenderST == "116" or defenderST == "121" or defenderST == "122" or defenderST == "138" then
                        -- print("庇护结束后清除庇护效果 self.roleCamp = ", self.roleCamp, " _def.stRound = ", _def.stRound)
                        if tonumber(_def.stRound) <= 0 then
                            self:cleanBuffStateWithType(defenderST)
                        end
                    elseif BattleSkill.isLifeChainSkill(defenderST) then
                        -- 生命链接飘伤害
                        local skillInfluenceElementData = self.armature._sie_action
                        local attackSection = dms.atoi(skillInfluenceElementData, skill_influence.attack_section) or 1
                        if attackSection < 0 then
                            attackSection = 1
                        end

                        if attackSection == (self.drawDamageNumberCount + 1) then
                            if tonumber(_def.stValue) > 0 then
                                local drawString = "-" .. _def.stValue
                                local numberFilePath = "images/ui/number/xue.png"
                                local armatureBase = self.armature
                                armatureBase._role._hp = zstring.tonumber(armatureBase._role._hp) + zstring.tonumber(drawString)
                                armatureBase._role._lhp = _def.aliveHP
                                showRoleHP(armatureBase, _def)
    
                                self:showChangeHpNumberAni(numberFilePath, drawString, false, 0, false, ENUM_TYPE_DAMAGE.TYPE_DAMAGE_INDIRECT)
                            end
                        else
                            self.drawDamageNumberCount = self.drawDamageNumberCount + 1
                        end

                        -- 间接伤害不走下面的逻辑
                        return
                    else
                        -- 角色播放被攻击帧
                        -- -- self.armature._invoke = nil
                        -- self.armature._actionIndex = _enum_animation_l_frame_index.animation_normal_be_attaked
                        -- self.armature._nextAction = _enum_animation_l_frame_index.animation_normal_be_attaked
                        -- self.armature:getAnimation():playWithIndex(self.armature._actionIndex)
                        -- -- self.armature._invoke = self.changeActionCallback

                        -- print("角色进入被攻击状态")

                        if self.repelAndFlyEffectCount <= 0 and self.roleCamp ~= self.current_fight_data.__attackArmature._self.roleCamp then
                            local armature = self.armature
                            if nil ~= armature._sie_action then
                                local actionIndexs = zstring.split(dms.atos(armature._sie_action, skill_influence.army_bear_action), ",")
                                local actionIndex = zstring.tonumber(actionIndexs[self.roleCamp] or actionIndexs[1])

                                if self.roleByAttacking == true and actionIndex > -1 then
                                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                        if actionIndex ~= armature._actionIndex then
                                            if self.repelAndFlyEffectCount <= 0 then
                                                if (true ~= self.roleAttacking) and (nil == attacker or attacker.roleCamp ~= self.roleCamp) then
                                                    armature._actionIndex = actionIndex
                                                    armature._nextAction = actionIndex
                                                    armature:getAnimation():playWithIndex(actionIndex)
                                                    armature._nextAction = _enum_animation_l_frame_index.animation_standby
                                                end

                                                for k,v in pairs(self.buffList) do
                                                    local armatureEffect = self.buffEffectList[k]
                                                    if nil ~= armatureEffect and armatureEffect._buffInfo[2] > 2 then
                                                        armatureEffect._nextAction = 2
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        armature._actionIndex = actionIndex
                                        armature._nextAction = actionIndex
                                        armature:getAnimation():playWithIndex(actionIndex)
                                    end
                                end
                            end
                        end
                        
                        -- 处理被攻击的后段光效
                        if self.parent ~= nil then
                            self:executeEffectSkillEnd(isDrawExplode)
                        end
                    end
                end
            end
        end

        if checkFrameEvent(datas, "explode") == true and isDrawExplode == true then -- 角色的承受特效
            if self.roleCamp ~= self.current_fight_data.__attackArmature._self.roleCamp then
                self:createRoleDefendEffect()
            end
        end

        if self.current_fight_data ~= nil and self.current_fight_data.__def ~= nil then
            -- local _def = self.current_fight_data.__def
            local defenderST = _def.defenderST
            local defState = _def.defState

            if self.roleCamp ~= self.current_fight_data.__attackArmature._self.roleCamp then
                -- 数码项目取消击退浮空效果
                -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

                -- else
                    if defenderST == "0" and defState == "1" then
                    else
                        if checkFrameEvent(datas, "repel") == true then -- 击退
                            self.fly_index = self.fly_index + 1
                            -- print("repel_index:", self.fly_index, self._info._name)
                            
                            local skillInfluenceElementData = self.armature._sie_action
                            local hitDownString = dms.atos(skillInfluenceElementData, skill_influence.hit_down)
                            -- print("repel_index  hitDownString", hitDownString, self._info._name)
                            if hitDownString ~= nil then
                                -->___crint("repel_hitDownString:", hitDownString)
                                local hitDownParmas = zstring.split(hitDownString, "|")[self.fly_index]
                                -- print("repel_index  hitDownParmas", hitDownParmas, self._info._name)
                                -- if hitDownParmas[self.fly_index] ~= nil and #hitDownParmas[self.fly_index] > 0 then
                                if hitDownParmas ~= nil and #hitDownParmas > 0 then
                                    
                                    -- local repelParma = zstring.split(hitDownParmas[self.fly_index], ",")
                                    local repelParma = zstring.split(hitDownParmas, ",")
                                    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                                        if zstring.tonumber(repelParma[1]) == 0 and zstring.tonumber(repelParma[2]) == 0 then
                                        else
                                            if #repelParma > 1 then
                                                -- print("处理角色被击退", self.roleCamp, self._info._pos, repelParma[1], repelParma[2])
                                                self:executeHitRepelAndFlyEffect(0, zstring.tonumber(repelParma[1]), zstring.tonumber(repelParma[2]))
                                            end
                                        end
                                    else
                                        if #repelParma > 1 then
                                            -- print("处理角色被击退", self.roleCamp, self._info._pos, repelParma[1], repelParma[2])

                                            if tonumber(_def.defenderST) ~= 2
                                                and tonumber(_def.defenderST) ~= 51 
                                                then
                                                self:executeHitRepelAndFlyEffect(0, zstring.tonumber(repelParma[1]), zstring.tonumber(repelParma[2]))
                                            end
                                            
                                        end
                                    end
                                end
                            end
                        end

                        if checkFrameEvent(datas, "fly") == true then -- 浮空
                        
                            self.fly_index = self.fly_index + 1
                            
                            -- print("fly_index:", self.fly_index, self._info._name)
                            local skillInfluenceElementData = self.armature._sie_action
                            local hitDownString = dms.atos(skillInfluenceElementData, skill_influence.hit_down)
                            -- print("fly_index hitDownString", hitDownString, self._info._name)
                            -- hitDownString = "50, 100|50, 100|50, 100|50, 100|50, 100|50, 100|50, 100|50, 100|50, 100|50, 100"
                            if hitDownString ~= nil then
                                -->___crint("fly_hitDownString:", hitDownString)
                                local hitDownParmas = zstring.split(hitDownString, "|")[self.fly_index]
                                -- print("fly_index hitDownParmas", hitDownParmas, self._info._name)
                                -- if hitDownParmas[self.fly_index] ~= nil and #hitDownParmas[self.fly_index] > 0 then
                                if hitDownParmas ~= nil and #hitDownParmas > 0 then
                                    -- local flyParma = zstring.split(hitDownParmas[self.fly_index], ",")
                                    local flyParma = zstring.split(hitDownParmas, ",")
                                    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                                        if zstring.tonumber(flyParma[1]) == 0 and zstring.tonumber(flyParma[2]) == 0 then
                                        else
                                            if #flyParma > 1 then
                                                -- print("处理角色被击飞", self.roleCamp, self._info._pos, flyParma[1], flyParma[2])

                                                -- 如果只是加怒，不做被击动作，如果我方某数码兽被杀死，可能触发其他数码兽加怒气，仅仅是加怒气，不应该受被击动作
                                                if tonumber(_def.defenderST) ~= 2 
                                                    and tonumber(_def.defenderST) ~= 51 
                                                    then
                                                    self:executeHitRepelAndFlyEffect(1, zstring.tonumber(flyParma[1]), zstring.tonumber(flyParma[2]))
                                                end

                                            end
                                        end
                                    else
                                        if #flyParma > 1 then
                                            -- print("处理角色被击飞", self.roleCamp, self._info._pos, flyParma[1], flyParma[2])

                                            -- 如果只是加怒，不做被击动作，如果我方某数码兽被杀死，可能触发其他数码兽加怒气，仅仅是加怒气，不应该受被击动作
                                            if tonumber(_def.defenderST) ~= 2 
                                                and tonumber(_def.defenderST) ~= 51 
                                                then
                                                self:executeHitRepelAndFlyEffect(1, zstring.tonumber(flyParma[1]), zstring.tonumber(flyParma[2]))
                                            end

                                        end
                                    end
                                end
                            end
                        end

                        -- print(evt, bone:getArmature()._fileName)
                        if checkFrameEvent(datas, "pause") == true then -- 暂停
                            -- print("----------pause----------")
                            if true ~= self.parent._m_pause then
                                self.parent._m_pause = true
                                self.parent._m_actions = {}
                                local action100 = self.parent:getActionByTag(100)
                                local action101 = self.parent:getActionByTag(101)

                                -- if nil ~= action100 then
                                --     action100:retain()
                                --     table.insert(self.parent._m_actions, action100)
                                -- end

                                -- if nil ~= action101 then
                                --     action101:retain()
                                --     table.insert(self.parent._m_actions, action101)
                                -- end

                                self.parent:pause()
                            end
                        end

                        if checkFrameEvent(datas, "resume") == true then -- 恢复
                            -- print("----------resume----------")
                            if true == self.parent._m_pause then
                                self.parent._m_pause = false
                                self.parent:resume()
                            end
                        end
                    -- end
                end
            end
        end

        if checkFrameEvent(datas, "next") == true then -- 我方下一个可出手的角色马上开始出手
            self.__attack_permit = true
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                or __lua_project_id == __lua_project_l_naruto 
                then
                -- local __fight_cacher_pool_temp_len = table.nums(self.__fight_cacher_pool_temp) 
                -- if __fight_cacher_pool_temp_len > 0 then
                --     local __fight_cacher_data_temp = table.remove(self.__fight_cacher_pool_temp, "1")
                --     self.current_fight_data.__attData = __fight_cacher_data_temp.__attData
                --     self.current_fight_data.__skf = __fight_cacher_data_temp.__skf
                --     self.current_fight_data.__defenderList = __fight_cacher_data_temp.__defenderList
                --     -- self:executeHeroMoveToTarget()
                --     self:executeAttackLogic(nil, true)
                --     -- return
                -- end

                -- local attacker = self.current_fight_data.__attackArmature._self
                -- if attacker.skillQuality ~= 1 and true ~= attacker._call_next then
                --     FightRole.__g_role_attacking = false
                --     FightRole.__g_lock_sp_attack = true
                --     attacker._call_next = true
                --     attacker._call_next1 = false
                --     self._FightRoleController.unchange_next_camp_battle_round = true
                --     state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, attacker)
                --     if false == attacker._call_next1 then
                --         state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                --     end
                -- end
            else
                state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self.current_fight_data.__attackArmature._self)
            end
        end

        if checkFrameEvent(datas, "over") == true then
            local attacker = self.current_fight_data.__attackArmature._self
                if attacker.roleCamp == self.roleCamp then
                self.byReqelAndFlyEffectWaitByAttackedOver = false

                self.waitByAttackOverDeathEvent = false

                -- self.current_fight_data = nil
                self.roleByAttacking = false
                self.waitByAttackOver = false

                self.byAttackEffectIndex = 0
                -- self:checkByAttackEnd()
            end
        end

        if checkFrameEvent(datas, "kill") == true and _def.defAState == "1" then
            if (self.roleWaitDeath == true or self.fight_over == true) and self.sendDeathNotice == false then
                self.sendDeathNotice = true
                state_machine.excute("fight_role_controller_notification_role_death_for_last_kill", 0, {self, true})

                self.armature._role._hp = 0
                showRoleHP(self.armature)
            end
        end

        if checkFrameEvent(datas, "unkill") == true then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                or __lua_project_id == __lua_project_l_naruto 
                then
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

        if checkFrameEvent(datas, "hurt") == true then
            -- print("绘制攻击伤害！！！")
        else
            -- print("无效的帧事件！！！")
            return
        end
    else
        -- print("无效的帧事件！！！")
        return
    end

    -- print("绘制掉血动画----")
    if self.armature ~= nil then
        local skillInfluenceElementData = self.armature._sie_action
        local attackSection = dms.atoi(skillInfluenceElementData, skill_influence.attack_section) or 1
        if attackSection < 0 then
            attackSection = 1
        end
        -- print("attackSection = ", attackSection, " self.drawDamageNumberCount = ", self.drawDamageNumberCount)
            
        local drawDamageNumberCount = self.drawDamageNumberCount
        if attackSection > drawDamageNumberCount then
            if _def.stVisible == "2" then
                -- print("绘制承受动作和承受动画，但不绘制伤害数字")
            else
--                print("---------------------------")
--                debug.print_r(_def)
                if tonumber(_def.stValue) ~= 0 then
                    self:drawDamageNumber(_def.stValue, attackSection, _def.stRound, _def, false)
                end

                -- print("FightRole 真实伤害 stRealValue = ", _def.stRealValue, " 天赋26伤害 = ", _def.stTalentDamegeValue)
                if attackSection == (drawDamageNumberCount + 1) then
                    -- 真实伤害
                    if tonumber(_def.stRealValue) ~= 0 then 
                        self:drawRealDamageNumber(_def.stRealValue, 1, _def.stRound, _def, false)
                    end
                    -- 天赋类型26的掉血绘制
                    if tonumber(_def.stTalentDamegeValue) ~= 0 then
                        self:drawRealDamageNumber(_def.stTalentDamegeValue, 1, _def.stRound, _def, false)
                    end
                end
            end
        end
    end
end


local function onFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
    if FightRole.__skeep_fighting == true then
        return
    end
    local armature = bone:getArmature()
    local _self = armature._self
    if nil == _self.armature or nil == _self.current_fight_data_attacker then
        return
    end
    _self.current_fight_data = _self.current_fight_data_attacker
    _self.armature._sed_action = _self.armature._sed_action_attacker
    _self.armature._sie_action = _self.armature._sie_action_attacker
    if FightRole.__skeep_fighting == true or _self == nil or _self.current_fight_data == nil or FightRole.__fit_attacking == true then
        return
    end
    local _skf = _self.current_fight_data.__skf
    local defenderList = _self.current_fight_data.__defenderList
    local frameEvents = zstring.split(evt, "_")
    if checkFrameEvent(frameEvents, "mcamera") == true then -- 启动角色镜头聚焦
        _self.camera_focus = true
        local foucsRole = _self.foucsRole
        if nil == foucsRole then
            foucsRole = _self
        end
        -- print("-start::::>>>", foucsRole, _self.roleCamp, _self._info._pos)
        if foucsRole ~= nil and foucsRole._info ~= nil then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                playEffect(formatMusicFile("effect", 9994))
            end
            state_machine.excute("fight_scene_scene_scale_effect", 0, {foucsRole.roleCamp, 
                zstring.tonumber(foucsRole._info._pos - 1) % 3 + 1, -- foucsRole.current_attack_line, 
                foucsRole.repelAndFlyEffectCount > 0, true, _self})
        end
        state_machine.excute("fight_role_controller_camera_focus_with_role", 0, _self)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            -- state_machine.excute("fight_role_controller_play_power_skill_screen_effect", 0, {_role = _self, _unload = false})
            -- state_machine.excute("skill_closeup_window_open", 0, {_self.roleCamp, _self._info._head})
        end
    end

    if checkFrameEvent(frameEvents, "scamera") == true then -- 取消角色镜头聚焦
        _self.camera_focus = false
        -- print("-over::::>>>", _self.foucsRole, _self.roleCamp, _self._info._pos)
        state_machine.excute("fight_scene_scene_scale_effect", 0, {0, 0, false, false, _self})
    end

    if checkFrameEvent(frameEvents, "hurt") == true then
        if _self.isWakeUpComkillProgress == false and _self.roleCamp == 0 then
            state_machine.excute("fight_role_controller_startup_comkill_progress", 0, _self)
        end
        _self.isWakeUpComkillProgress = true
        if _self.current_fight_data and _self.current_fight_data.__defenderList ~= nil then
            for i, v in pairs(_self.current_fight_data.__defenderList) do
                if v.parent ~= nil then
                    v:removeByAttackSignEffect()
                end
            end
        end
    end

    if checkFrameEvent(frameEvents, "shake") == true then
        state_machine.excute("fight_scene_shake", 0, nil)
    end

    if checkFrameEvent(frameEvents, "white") == true then
        state_machine.excute("fight_scene_blink_white", 0, nil)
    end

    if checkFrameEvent(frameEvents, "black") == true then
        state_machine.excute("fight_scene_blink_black", 0, nil)
    end

    if defenderList ~= nil then
        local isDrawExplode = true
        -- for i, v in pairs(defenderList) do
        --     if v.current_fight_data ~= nil then
        --         local _def = v.current_fight_data.__def
        --         if _def ~= nil and v.armature ~= nil and v.parent ~= nil then
        --             v.armature._sie_action = _self.armature._sie_action
        --             v.current_fight_data.__def = _def
        --             v.current_fight_data.__bySkf = _skf
        --             v.current_fight_data.__attackArmature = _self.armature
        --             local defenderST = _def.defenderST
        --             if defenderST == "20" then
        --             else
        --                 v:executeByAttackLogic(bone,evt,originFrameIndex,currentFrameIndex, frameEvents,isDrawExplode)
        --                 if isDrawExplode == true and (defenderST == "0" or defenderST == "1") then
        --                     isDrawExplode = false
        --                 end
        --             end
        --         end
        --     end
        -- end

        -- 处理承受方的逻辑
        local _skf = _self.current_fight_data.__skf
        for w = 1, zstring.tonumber(_skf.defenderCount) do
            local _def = _skf._defenders[w]
            local defender = _def.defender                      -- = npos(list)         --承受方1的标识(0:我方 1:对方)
            local defenderPos = tonumber(_def.defenderPos)      -- = npos(list)         --承受方1的位置
            local restrainState = _def.restrainState            -- = npos(list)         --相克状态(0,无克制 1,有克制,2被克制)
            local defenderST = _def.defenderST                  -- = npos(list)         --承受方1的作用效果(?)
            local stValue = _def.stValue                        -- = npos(list)         --承受方1的作用值
            local stRound = _def.stRound                        -- = npos(list)         --承受方1的持续回合数
            local defState = _def.defState                      -- = npos(list)         --承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
            local defAState = _def.defAState                    -- = npos(list)         --承受方1生存状态(0:存活 1:死亡 2:反击)

            if _def.stVisible == "0" then

            else
                local byAttackTarget = defenderList["".._def.defender.."t".._def.defenderPos]
                if byAttackTarget ~= nil and byAttackTarget.parent ~= nil then
                    if byAttackTarget.current_fight_data == nil then
                        byAttackTarget.current_fight_data = {}
                    end
                    byAttackTarget.armature._sie_action = _self.armature._sie_action_attacker
                    byAttackTarget.current_fight_data.__def = _def
                    byAttackTarget.current_fight_data.__bySkf = _skf
                    byAttackTarget.current_fight_data.__attackArmature = _self.armature
                    if defenderST == "20" then

                    elseif (defenderST == "126" or defenderST == "127" or defenderST == "128") or (defenderST == "132" or defenderST == "133" or defenderST == "134") then
                        local defenderST = _def.defenderST
                        -- 0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格
                        local defState = _def.defState
                        if defState == "0" or defState == "2" then
                            byAttackTarget:updateDrawInfluenceInfo(_def)
                        end
                    else
                        byAttackTarget.drawDamageNumberCount = _self.singleAttackCount
                        byAttackTarget:executeByAttackLogic(bone,evt,originFrameIndex,currentFrameIndex, frameEvents,isDrawExplode, _self)
                        if isDrawExplode == true and (defenderST == "0" or defenderST == "1") then
                            isDrawExplode = false
                        end
                    end
                end
            end
        end
    end

    if checkFrameEvent(frameEvents, "after") == true then
        local lc = _self.singleAttackCount
        _self.singleAttackCount = 0
        for k,v in pairs(_self.current_fight_data.add_fight_data) do
            if v ~= nil then
                local skf = v.__skf
                local skillInfluenceId = skf.skillInfluenceId
                local defenderListEx = v.__defenderList
                for w = 1, zstring.tonumber(skf.defenderCount) do
                    local _def = skf._defenders[w]
                    local defenderST = _def.defenderST
                    if defenderST == "37" then
                        local attackSection = dms.int(dms["skill_influence"], skillInfluenceId, skill_influence.attack_section)
                        if attackSection < 0 then
                            attackSection = 1
                        end

                        local defender = _def.defender
                        local defenderPos = tonumber(_def.defenderPos)
                        local byAttackTarget = defenderListEx[""..defender.."t"..defenderPos]
                        if byAttackTarget ~= nil and byAttackTarget.parent ~= nil then
                            if _def.attackSection == nil then
                                _def.attackSection = attackSection
                                byAttackTarget._hurtCount = 1
                                -- byAttackTarget.drawDamageNumberCount = 0
                            end
                            if byAttackTarget.current_fight_data == nil then
                                byAttackTarget.current_fight_data = {}
                            end
                            byAttackTarget.armature._sie_action = _self.armature._sie_action_attacker
                            byAttackTarget.current_fight_data.__def = _def
                            byAttackTarget.current_fight_data.__bySkf = _skf
                            byAttackTarget.current_fight_data.__attackArmature = _self.armature

                            -- print("绘制溅射的伤害值：", _def.defender, _def.defenderPos, _def.stValue, attackSection)
                            byAttackTarget.drawDamageNumberCount = _self.singleAttackCount
                            if attackSection > byAttackTarget.drawDamageNumberCount then
                                if (tonumber(_def.stValue) or 0) > 0 then byAttackTarget:drawDamageNumber(_def.stValue, attackSection, _def.stRound, _def, true, skillInfluenceId) else byAttackTarget:updateDrawInfluenceInfo(_def) end -- Fury 3-oct: como la rama "next"; un 37 de 0 dejaba drawString "" (FightRole:5390/5434)
                            end

                            -- local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
                            -- v.armature._sed_action = skillElementData
                            -- v.armature._sie_action = skillInfluenceElementData

                            local bear_lighting_effect_id = dms.int(dms["skill_influence"], skillInfluenceId, skill_influence.bear_lighting_effect_id)
                            if bear_lighting_effect_id > 0 then
                                local armatureEffect = byAttackTarget:createEffect(bear_lighting_effect_id)
                                armatureEffect._invoke = deleteEffectFile
                                byAttackTarget.parent:addChild(armatureEffect)
                            end
                            byAttackTarget:changeActionToByAttack()
                        end
                    end
                end
            end
        end
        _self.singleAttackCount = lc
    end

    if checkFrameEvent(frameEvents, "next") == true then
        local lc = _self.singleAttackCount
        _self.singleAttackCount = 0
        for k,v in pairs(_self.current_fight_data.add_fight_data) do
            if v ~= nil then
                local skf = v.__skf
                local skillInfluenceId = skf.skillInfluenceId
                local defenderListEx = v.__defenderList
                for w = 1, zstring.tonumber(skf.defenderCount) do
                    local _def = skf._defenders[w]
                    local defenderST = _def.defenderST
                    local defender = _def.defender
                    local defenderPos = tonumber(_def.defenderPos)
                    local byAttackTarget = defenderListEx[""..defender.."t"..defenderPos]
                    if byAttackTarget ~= nil and byAttackTarget.parent ~= nil then

                        if byAttackTarget.current_fight_data == nil then
                            byAttackTarget.current_fight_data = {}
                        end
                        byAttackTarget.armature._sie_action = _self.armature._sie_action_attacker
                        byAttackTarget.current_fight_data.__def = _def
                        byAttackTarget.current_fight_data.__bySkf = _skf
                        byAttackTarget.current_fight_data.__attackArmature = _self.armature

                        if defenderST == "37" then

                        else
                            byAttackTarget._hurtCount = 1
                            -- byAttackTarget.drawDamageNumberCount = 0
                            if tonumber(_def.stValue) > 0 then
                                byAttackTarget:drawDamageNumber(_def.stValue, 1, _def.stRound, _def, true,skillInfluenceId)
                            else
                                byAttackTarget:updateDrawInfluenceInfo(_def)
                            end
                        end
                        if (byAttackTarget.roleWaitDeath == true or byAttackTarget.fight_over == true) and byAttackTarget.sendDeathNotice == false then
                            byAttackTarget.sendDeathNotice = true
                            state_machine.excute("fight_role_controller_notification_role_death_for_last_kill", 0, {byAttackTarget, true})
                        end

                        if _def.defAState == "1" then
                            byAttackTarget:checkByAttackEnd()
                        end
                    end
                end
            end
        end
        _self.current_fight_data.add_fight_data = {}
        _self.singleAttackCount = lc
    end

    if checkFrameEvent(frameEvents, "next") == true then -- 我方下一个可出手的角色马上开始出手
        -- self.__attack_permit = true
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            -- local __fight_cacher_pool_temp_len = table.nums(self.__fight_cacher_pool_temp) 
            -- if __fight_cacher_pool_temp_len > 0 then
            --     local __fight_cacher_data_temp = table.remove(self.__fight_cacher_pool_temp, "1")
            --     self.current_fight_data.__attData = __fight_cacher_data_temp.__attData
            --     self.current_fight_data.__skf = __fight_cacher_data_temp.__skf
            --     self.current_fight_data.__defenderList = __fight_cacher_data_temp.__defenderList
            --     -- self:executeHeroMoveToTarget()
            --     self:executeAttackLogic(nil, true)
            --     -- return
            -- end

            local attacker = _self
            if (attacker.skillQuality ~= 1 or attacker._isAnimal == true) and true ~= attacker._call_next then
                FightRole.__g_role_attacking = false

                if not attacker._isAnimal then
                    FightRole.__g_lock_sp_attack = true
                end 
                
                attacker._call_next = true
                attacker._call_next1 = false
                attacker._FightRoleController.unchange_next_camp_battle_round = true
                state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, attacker)
                if false == attacker._call_next1 then
                    state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                end
            end
        else
            state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self.current_fight_data.__attackArmature._self)
        end
    end

    if checkFrameEvent(frameEvents, "hurt") == true then
        _self.singleAttackCount = _self.singleAttackCount + 1
    end
end

function FightRole:checkFitAttackOver()   
    local __fit_roles = self.__fit_roles
    local __fiterCount = #self.__fit_roles
    -- local __fit_roles = FightRole.__fit_roles
    -- local __fiterCount = #FightRole.__fit_roles
    for m, n in pairs(__fit_roles) do
        local defenderList = n.current_fight_data.__defenderList
        if defenderList ~= nil then
            for i, v in pairs(defenderList) do
                if v ~= nil and v.parent ~= nil and (v.roleByAttacking == true or v.waitByAttackOver == true or v.waitByAttackOverDeathEvent == true)
                    then
                    return false
                end 
            end
        end
    end

    self.current_fight_data.__byFitAttacker.isCheckFitAttackEnd = false
    for i, v in pairs(__fit_roles) do
        table.remove(v.fight_fit_cacher_pool, "1")
    end
    if #__fit_roles[1].fight_fit_cacher_pool > 0 then
        for i, v in pairs(__fit_roles) do
            -- print("===============", v, v._info._pos, #v.fight_fit_cacher_pool)
            if #v.fight_fit_cacher_pool > 0 then
                v.current_fight_data = v.fight_fit_cacher_pool[1]
                v.moveByPosition = nil
                v:executeAttackLogic()
            end
        end
    else
        table.remove(self.fight_cacher_pool, "1")
        for i, v in pairs(__fit_roles) do
            v.waitNextSkillInfluence = false
            v.moveBackArena = true
            self.openAttackListener = false
            state_machine.excute("fight_role_check_move_event", 0, v)
            -- state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
        end
        state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self)
        state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
    end
end

local function onSPEffectFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
    if FightRole.__skeep_fighting == true then
        return
    end
    local frameEvents = zstring.split(evt, "_")
    if checkFrameEvent(frameEvents, "shake") == true then
        state_machine.excute("fight_scene_shake", 0, nil)
    end

    if checkFrameEvent(frameEvents, "white") == true then
        state_machine.excute("fight_scene_blink_white", 0, nil)
    end

    if checkFrameEvent(frameEvents, "black") == true then
        state_machine.excute("fight_scene_blink_black", 0, nil)
    end
end

function FightRole:excuteSPSkillEffectFitEX()
    -- print("合体技能显示效果处理")
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end

    -- 处理合体技能
    for i, v in pairs(self.__fit_roles) do
        local isCheckFightData = false
        for index,fightData in pairs(v.fight_fit_cacher_pool) do
            if fightData ~= nil then
                local skillInfluenceId = fightData.__skf.skillInfluenceId
                local skill_category = dms.int(dms["skill_influence"], skillInfluenceId, skill_influence.skill_category)
                -- print("+++++ excuteSPSkillEffectFitEX ++++++ skill_category=", skill_category);
                if isCheckFightData == false and (tonumber(skill_category) == 0 or tonumber(skill_category) == 1) then
                    v.current_fight_data = fightData
                    isCheckFightData = true
                end
            end
        end

        if isCheckFightData == false then
            v.current_fight_data = v.fight_fit_cacher_pool[1]
        end
        local attData = v.current_fight_data.__attData
        local skillMouldId = tonumber(attData.skillMouldId)
        local skillInfluenceId = v.current_fight_data.__skf.skillInfluenceId
        local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
        local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
        v.armature._sed_action = skillElementData
        v.armature._sie_action = skillInfluenceElementData
        if self == v then
            -- print("合体技发动前技能数量：", table.getn(self.fight_cacher_pool))
            local shipEffect = -1
            local effectName = -1
            if v._erole._type == "0" then
                effectName = dms.string(dms["ship_mould"], v._brole._mouldId, ship_mould.screen_attack_effect)
                shipEffect = effectName
            else
                local directing = dms.string(dms["environment_ship"], v._brole._mouldId, environment_ship.directing)
                effectName = dms.string(dms["ship_mould"], directing, ship_mould.screen_attack_effect)
                shipEffect = effectName
            end
            if shipEffect ~= nil and tonumber(shipEffect) > -1 then
                state_machine.excute("update_fight_team_controller_data", 0, {self, shipEffect, self.__fit_roles, self.armature._sie_action})
            end
        end
    end
end

local function excuteSPSkillEffectFitOver(armatureBack)
    -->___crint("合体技能特效播放结束")
    -- FightRole.__fit_attacking = false
    -- __fit_params[_enum_params_index.param_attack_count] = 0
    -- state_machine.excute("move_logic_begin_move_all_role", 0, {__fit_roles, __fit_params})

    -- fwin._ui._layer:removeChildByTag(FightRole.__hetiNodeTag, true)
    local _self = armatureBack._self
    local _shipEffect = armatureBack._shipEffect
    if FightRole.__skeep_fighting == true or _self.fight_over == true then
    else
        -- local __fit_roles = FightRole.__fit_roles
        -- local current_round_count = _self.current_fight_data.__round
        -- table.remove(_self.fight_cacher_pool, "1")
        -- state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
        -- _self:cleanAttackData()
        -- for i, v in pairs(__fit_roles) do
        --     v.fitAttacking = true
        --     -- for n, m in pairs(v.fight_cacher_pool) do
        --     --     if m.__round == current_round_count then
        --     --         m.__byFitAttacker = nil
        --     --     end
        --     -- end
        --     v.current_fight_data = v.fight_cacher_pool[1]
        --     if v.current_fight_data ~= nil and v.current_fight_data.__state == 0 then
        --         v:executeAttackLogic()
        --     else
        --         table.remove(v.fight_cacher_pool, "1")
        --         state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
        --     end
        -- end
        

        -- local __fit_roles = FightRole.__fit_roles
        -- local __fiterCount = #FightRole.__fit_roles
        -- local top = _self._FightRoleController.act_center_positions[1]
        -- local center = _self._FightRoleController.act_center_positions[2]
        -- local bottom = _self._FightRoleController.act_center_positions[3]
        -- local spm = (top.y - bottom.y) / __fiterCount
        -- for i, v in pairs(__fit_roles) do
        --     local moveBeginPosition = cc.p(v.parent:getPosition())
        --     local moveEndPosition = cc.p(top.x, bottom.y + spm * i - spm / 2)
        --     local moveByPosition = cc.p(moveEndPosition.x - moveBeginPosition.x, moveEndPosition.y - moveBeginPosition.y)
        --     v.moveByPosition = moveByPosition
        --     v.current_fight_data = v.fight_fit_cacher_pool[1]
        --     v.fitAttacking = true
        --     v:executeAttackLogic()
        -- end

        local __fit_roles = _self.__fit_roles
        local __fiterCount = #_self.__fit_roles
        -- local __fit_roles = FightRole.__fit_roles
        -- local __fiterCount = #FightRole.__fit_roles
        for i, v in pairs(__fit_roles) do
            local isCheckFightData = false
            for index,fightData in pairs(v.fight_fit_cacher_pool) do
                if fightData ~= nil then
                    local skillInfluenceId = fightData.__skf.skillInfluenceId
                    local skill_category = dms.int(dms["skill_influence"], skillInfluenceId, skill_influence.skill_category)
                    -- print("+++++ excuteSPSkillEffectFitOver ++++++ skill_category=", skill_category);
                    if isCheckFightData == false and (tonumber(skill_category) == 0 or tonumber(skill_category) == 1) then
                        v.current_fight_data = fightData
                        isCheckFightData = true
                    end
                end
            end

            if isCheckFightData == false then
                v.current_fight_data = v.fight_fit_cacher_pool[1]
            end

            local attData               = v.current_fight_data.__attData
            local attacker              = attData.attacker                                  -- 回合1出手方标识(0:我方 1:对方)
            local attackerPos           = attData.attackerPos                               -- 出手方位置(1-6)
            local linkAttackerPos       = attData.linkAttackerPos                           -- 是否有合体技(>0表示有.且表示合体的对象)
            local attackMovePos         = tonumber(attData.attackMovePos)                   -- 移动到的位置(0-8)
            local skillMouldId          = tonumber(attData.skillMouldId)                    -- 技能模板id
            local skillInfluenceCount   = tonumber(attData.skillInfluenceCount)             -- 技能效用数量

            local skillElementData = dms.element(dms["skill_mould"], skillMouldId)

            -- local skillInfluenceId = dms.atoi(skillElementData, skill_mould.health_affect)
            -- if skillInfluenceId == nil then
            --     skillInfluenceId = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")[1]
            -- end

            local skillInfluenceId = v.current_fight_data.__skf.skillInfluenceId
            -->___rint(skillElementData, skillInfluenceId)
            local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)

            v.armature._sed_action = skillElementData
            v.armature._sie_action = skillInfluenceElementData

        end
    end
    state_machine.excute("update_fight_team_controller_data", 0, {_self, _shipEffect, _self.__fit_roles, _self.armature._sie_action})
    deleteEffectFile(armatureBack)
end

function FightRole:excuteSPSkillEffectFit()
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    self._FightRoleController.isLockScene = true
    self._FightRoleController.open_camera = false
    state_machine.excute("fight_scene_initialize_scene", 0, nil)

    if true then
        self:excuteSPSkillEffectFitEX()
        return
    end

    local _dic_heads = {
        {"fit_1_1", "fit_1_2",  "fit_1_3",  "fit_1_4",  "fit_1_5"}, -- 头像A
        {"fit_2_1", "fit_2_2",  "fit_2_3",  "fit_2_4",  "fit_2_5"}, -- 头像B
        {"fit_3_1", "fit_3_2",  "fit_3_3",  "fit_3_4",  "fit_3_5"}, -- 头像C
        {"fit_4_1", "fit_4_2",  "fit_4_3",  "fit_4_4",  "fit_4_5"}, -- 头像D
    }
    local _dic_names = {    -- 技能名称
        "name_1",   "name_2",   "name_3"
    }
    local __fit_roles = self.__fit_roles
    -- local __fit_roles = FightRole.__fit_roles
    local attData = self.current_fight_data.__attData
    local nCount = #__fit_roles
    if nCount == 2 or true then
        -- __fit_params[_enum_params_index.param_attack_count] = 0
        local size = cc.size(app.designSize.width, app.designSize.height)
        
        -- nCount = 2
        -- local armature_name = string.format("hero_head_effect_%s", 2)
        
        -- if attData.restrainState == "1" and nCount == 2 then
        --     armature_name = string.format("hero_head_effect_%s_1", 2)
        -- end

        -- local csbName = string.format("battle/battle_hetiji_%s.csb", nCount)
        local csbNode = csb.createNode(string.format("battle/battle_hetiji_%s.csb", nCount))
        local root = csbNode:getChildByName("root")
        for i=1,3 do
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_"..i)
            panel:setVisible(false)
        end
        local action = csb.createTimeline(string.format("battle/battle_hetiji_%s.csb", nCount))
        csbNode:runAction(action)
        local index = 1

        local currentSkillMouldId = attData.skillMouldId
        local armature = nil
        if animationMode == 1 then
            armature = sp.spine_hetiSprite("hero_head_effect_2", effectAnimations[1], false, nil, nil, nil)
            armature.animationNameList = effectAnimations
            sp.initArmature(armature, true)
        else
            armature = ccs.Armature:create("hero_head_effect_2")
        end
        armature._self = self
        for i, v in pairs(__fit_roles) do
            local role = v
            local posTile = v
            local armatureBack = v

            local shipEffect = -1
            local effectName = -1
            if v._erole._type == "0" then
                effectName = dms.string(dms["ship_mould"], v._brole._mouldId, ship_mould.screen_attack_effect)
                if zstring.tonumber(v._brole._head) < 10000 then
                    shipEffect = effectName
                else
                    shipEffect = v._brole._head
                end
            else
                effectName = dms.string(dms["environment_ship"], v._brole._mouldId, environment_ship.screen_attack_effect)
                shipEffect = effectName
            end

            if shipEffect ~= nil and tonumber(shipEffect) > -1 then
                local skillName =  dms.string(dms["skill_mould"], currentSkillMouldId, skill_mould.skill_name)
                -- local size = posTile:getContentSize()
                -- for f, t in pairs(_dic_heads[i]) do
                --     local imagePath = string.format("images/face/big_head/big_head_%s.png", shipEffect)
                --     local head = ccs.Skin:create(imagePath)
                --     -->___rint("t:::", t, imagePath)
                --     armature:getBone(t):addDisplay(head, 0)
                -- end

                local animationName = string.format("big_head_%d", shipEffect)
                local jsonFile = string.format("images/face/big_head/big_head_%d.json", shipEffect)
                local atlasFile = string.format("images/face/big_head/big_head_%d.atlas", shipEffect)
                if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
                    local panel = nil
                    if role.roleCamp == self.roleCamp and role._info._pos == self._info._pos then
                        panel = ccui.Helper:seekWidgetByName(root, "Panel_1")
                    else
                        index = index + 1
                        panel = ccui.Helper:seekWidgetByName(root, "Panel_"..index)
                    end
                    panel:addChild(animation)
                    panel:setVisible(true)
                end
                
                if self == v then
                    -- draw skill name
                    for s, x in pairs(_dic_names) do
                        local  imagePath = ""
                        if tonumber(self._brole._fit_skill_id) > 0 then
                            -- imagePath = string.format("images/face/rage_head/rage_name_%s.png", armatureBack._brole._fit_skill_id + 10000) 
                            imagePath = string.format("images/face/rage_head/rage_name_%s.png", shipEffect + 10000) 
                            armature._shipEffect = shipEffect
                        else
                            imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectName + 10000) 
                            armature._shipEffect = effectName
                        end
                        if cc.FileUtils:getInstance():isFileExist(imagePath) == true then
                            local skill_name = ccs.Skin:create(imagePath)
                            if animationMode == 1 then
                                local skillPanel = ccui.Helper:seekWidgetByName(root, "Panel_hetiji_name")
                                skillPanel:setBackGroundImage(imagePath)
                            else
                                armature:getBone(x):addDisplay(skill_name, 0)
                            end
                        end
                    end
                end
            end
        end
        armature:getAnimation():playWithIndex(0)
        armature:setPosition(cc.p(size.width / 2, size.height / 2 - app.baseOffsetY * app.scaleFactor / 2))
        armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
        armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
        armature._invoke = excuteSPSkillEffectFitOver
        -- fwin._background._layer:addChild(armature)
        fwin._ui._layer:addChild(armature)
        fwin._ui._layer:addChild(csbNode)
        csbNode:setTag(FightRole.__hetiNodeTag)
        action:play("animation0", false)
    end

    playEffectMusic(9994)
    -- local forepart_lighting_sound_effect_id = dms.atoi(self.armature._sie_action, skill_influence.forepart_lighting_sound_effect_id)
    -- if forepart_lighting_sound_effect_id >= 0 then
    --     playEffectMusic(forepart_lighting_sound_effect_id)
    -- end
end

local function excuteSPSkillEffectOver(armatureBack)
    local _self = armatureBack._self
    -- _self:executeAttackLogicing()
    deleteEffectFile(armatureBack)
    
    _self._skill_quality = nil
end

function FightRole:excuteSPSkillEffect()
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    -->___crint("需要绘制怒气技术的过场特效")

    local shipEffect = -1
    local effectName = -1
    if self._brole._type == "0" then
        effectName = dms.string(dms["ship_mould"], self._brole._mouldId, ship_mould.screen_attack_effect)
        if zstring.tonumber(self._brole._head) < 10000 then
            shipEffect = effectName
        else
            shipEffect = self._brole._head
        end
    else
        effectName = dms.string(dms["environment_ship"], self._brole._mouldId, environment_ship.screen_attack_effect)
        shipEffect = effectName
    end

    --> -->___rint("怒气特效的绘制", shipEffect)
    if shipEffect ~= nil and tonumber(shipEffect) > -1 then
        
        local skillName =  dms.string(dms["skill_mould"], self._currentSkillMouldId, skill_mould.skill_name)
        local size = self:getContentSize()
        
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            self:executeAttackLogicing()
        else
            local armature = ccs.Armature:create("hero_head_effect")
            armature._self = self
            -- playEffect(formatMusicFile("effect", 9994))
            armature:getAnimation():playWithIndex(0)
            armature:setPosition(cc.p(size.width/2, 0))
            armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
            armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
            armature._invoke = excuteSPSkillEffectOver
            armature:setPosition(cc.p(self.parent:getPosition()))
            self.parent:getParent():addChild(armature)
            armature:getAnimation():setFrameEventCallFunc(onSPEffectFrameEvent)

            local  imagePath = ""
            if tonumber(self._brole._power_skill_id) > 0 then
                imagePath = string.format("images/face/rage_head/rage_name_%s.png", self._brole._power_skill_id) 
            else
                imagePath = string.format("images/face/rage_head/rage_name_%s.png", effectName) 
            end
            local skill_name = ccs.Skin:create(imagePath)
            armature:getBone("skill_name"):addDisplay(skill_name, 0)

            local armature = self.armature
            local actionIndexs = zstring.split(dms.atos(armature._sie_action, skill_influence.before_action), ",")
            local actionIndex = zstring.tonumber(actionIndexs[self.roleCamp] or actionIndexs[1])
            local forepart_lighting_sound_effect_id = dms.atoi(armature._sie_action, skill_influence.forepart_lighting_sound_effect_id)
            if forepart_lighting_sound_effect_id >= 0 then
                playEffectMusic(forepart_lighting_sound_effect_id)
            end

            -- local __invoke = armature._invoke
            -- armature._invoke = nil
            -- armature:getAnimation():playWithIndex(actionIndex)
            -- armature._invoke = __invoke
            -- -- armature._actionIndex = actionIndex
            -- armature._nextAction = actionIndex
            if actionIndex > 0 then
                csb.animationChangeToAction(armature, actionIndex, actionIndex, nil)
            else
                self:executeAttackLogicing()
            end
        end
    else
        self:executeAttackLogicing()
    end
end

function FightRole:hetiSkillEnd( ... )
    self.isBeginHeti = false
    self.fitAttacking = false
    self.roleAttacking = false
    -- self.fight_cacher_pool = {}
    table.remove(self.fight_cacher_pool, "1")
    FightRole.__fit_attacking = false
    -- FightRole.__fit_roles = {}
    for i, v in pairs(self.__fit_roles) do
        v.roleAttacking = false
        v.waitNextSkillInfluence = false
        v.moveBackArena = true
    end
    self.openAttackListener = false
    self.__fit_roles = {}
    self.fiter = false
    if is2004 == true then
        self:removeFromAttackingArgs()
    end
    --  回合结束清除上次合体技能列表
    for i,v in pairs(self.fight_fit_cacher_pool) do
        table.remove(self.fight_fit_cacher_pool, i)
    end
    self.fight_fit_cacher_pool = {}
    self:checkAttackEnd(true)
    self.move_state = self._move_state_enum._MOVE_STATE_FREE
    state_machine.excute("fight_role_check_move_event", 0, self)
end

-- 攻击者攻击结束
function FightRole:checkAttackEnd(isNeedCheckNextSkill)
    -- local defenderList = self.current_fight_data.__defenderList
    -- if defenderList ~= nil then
    --     for i, v in pairs(defenderList) do
    --         if v.parent ~= nil and (v.roleByAttacking == true or v.waitByAttackOver == true or v.waitByAttackOverDeathEvent == true)
    --             then
    --             return false
    --         end 

    --     end
    -- end

    -- if __lua_project_id == __lua_project_l_digital or (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and _ED.battleData.battle_init_type == _enum_fight_type._fight_type_54 then
    --     local defenderList = self.current_fight_data.__defenderList
    --     if defenderList ~= nil then
    --         for i, v in pairs(defenderList) do
    --             if v.parent ~= nil and tonumber(v.roleCamp) == 0 then
    --                 v:updateDrawRoleHPwhenByAttackEnd()
    --             end 
    --         end
    --     end
    -- end

    -- print("checkAttackEnd isNeedCheckNextSkill = ", isNeedCheckNextSkill, " self.fitAttacking = ", self.fitAttacking)

    if self.fitAttacking == true then
        -- self.current_fight_data.__byFitAttacker:checkFitAttackOver()
        self.current_fight_data.__byFitAttacker.isCheckFitAttackEnd = true
    else
        self.isCheckAttackEnd = false
        if isNeedCheckNextSkill == true then
            -- print("合体技能已经处理结束！");
            self.shadow:setVisible(true)
            self.waitNextSkillInfluence = false
            self.moveBackArena = true
            self.openAttackListener = false
            -- self.move_state = self._move_state_enum._MOVE_STATE_MOVE_CAMP
            self.move_state = self._move_state_enum._MOVE_STATE_FREE

            local __g_lock_sp_attack = FightRole.__g_lock_sp_attack

            state_machine.excute("fight_role_move_event", 0, self)

            if true ~= self._call_next or true == __g_lock_sp_attack then
                state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self)
                state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
            end
            self._call_next = false
            self.current_fight_data_attacker = nil

            -- self.armature._role._hp = tonumber(self.attackerHp) or self.armature._role._hp
            -- self.armature._role._sp = tonumber(self.attackerSp) or self.armature._role._sp
            -- state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "update"})
            -- showRoleSP(self.armature)
            -- showRoleHP(self.armature)

            if self.camera_focus == true or self.skillQuality == 1 then
                FightRoleController.__lock_battle = false
                self.camera_focus = false
                state_machine.excute("fight_scene_scene_scale_effect", 0, {0, 0, false, false, self})
            end

            if self.skillQuality == 1 then
                self._FightRoleController.auto_double_hit_queue = {}
                if nil ~= _ED._fightModule then
                    _ED._fightModule.greadCount = 0
                end
            end
        else
            table.remove(self.fight_cacher_pool, "1")
            if #self.fight_cacher_pool > 0 then
                -- print("非合体技能，主技能处理结束后剩余其他技能数量：", #self.fight_cacher_pool);
                self.waitNextSkillInfluence = true
            else
                -- local defenderList = self.current_fight_data.__defenderList
                -- if defenderList ~= nil then
                --     for i, v in pairs(defenderList) do
                --         if v.parent ~= nil then
                --             v.attackerList[self.roleCamp.."w"..self._info._pos] = nil
                --         end
                --     end
                -- end
                -- print("攻击者攻击结束 返回移动区域内 roleCamp = ", self.roleCamp, " pos = ", self._info._pos, " self.repelAndFlyEffectCount = ", self.repelAndFlyEffectCount, " self.roleAttacking = ", self.roleAttacking)
                self.shadow:setVisible(true)
                self.waitNextSkillInfluence = false
                self.moveBackArena = true
                self.openAttackListener = false
                -- state_machine.excute("fight_role_check_move_event", 0, self)
                self.move_state = self._move_state_enum._MOVE_STATE_MOVE_CAMP

                local __g_lock_sp_attack = FightRole.__g_lock_sp_attack

                state_machine.excute("fight_role_move_event", 0, self)

                local baseCallNext = self._call_next
                self._call_next = false
                self.current_fight_data_attacker = nil

                -- print("checkAttackEnd self.current_fight_data_attacker = ", self.current_fight_data_attacker)

                -- self._FightRoleController:onUpdate(dt)

                -- -- 清除连击伤害的UI显示
                -- state_machine.excute("draw_hit_damage_exit", 0, 0)

                -- self.armature._role._hp = tonumber(self.attackerHp) or self.armature._role._hp
                -- self.armature._role._sp = tonumber(self.attackerSp) or self.armature._role._sp
                -- state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "update"})
                -- showRoleSP(self.armature)
                -- showRoleHP(self.armature)

                if self.camera_focus == true or self.skillQuality == 1 then
                    FightRoleController.__lock_battle = false
                    self.camera_focus = false
                    state_machine.excute("fight_scene_scene_scale_effect", 0, {0, 0, false, false, self})
                end
                
                if self.skillQuality == 1 then
                    self._FightRoleController.auto_double_hit_queue = {}
                    if nil ~= _ED._fightModule then
                        _ED._fightModule.greadCount = 0
                    end
                end

                if true ~= baseCallNext or true == __g_lock_sp_attack or true == self._call_next1 then
                    self._call_next1 = false
                    state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self)
                    state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                end

                if self._FightRoleController.unchange_next_camp_battle_round == true then
                    self._FightRoleController.unchange_next_camp_battle_round = false
                    self._FightRoleController:checkChangeNextCampBattleRound()
                end
            end
        end
    end
end

-- 给角色添加buff
function FightRole:crateBuffEffect(armatureId, armatureNames)
    local armatureEffect = self:createEffect(armatureId, nil, armatureNames)
    local size = self:getContentSize()
    self.parent:addChild(armatureEffect)
    return armatureEffect
end

function FightRole:addBuffEffect(v, count, isDeath, nType, def)
    if (nType == "126" or nType == "127" or nType == "128") or (nType == "132" or nType == "133" or nType == "134") then
        self:excuteCounterBuffEffect(v, count, isDeath, nType, def)
        return
    end

    if nType == "79" then
        v:cleanBuffState(true)
        if FightRole.__priority_camp == v.roleCamp then
        else
            if count < 2 then
                count = 2
            end
        end
    end

    -- 如果是晕眩，持续的回合+1，避免晕眩效果清除过早
    -- 新增麻痹，眩晕
    local addBuffEffectCountList = {5, 7, 17, 96, 97, 120}
    for _, v in pairs(addBuffEffectCountList) do
        if tonumber(nType) == v then
            count = count + 1
            break
        end
    end

    -- print("self._FightRoleController.isPvEType = ", self._FightRoleController.isPvEType)
    -- pvp生命链接特殊处理
    if self._FightRoleController.isPvEType ~= true then
        if BattleSkill.isLifeChainSkill(nType) then
            count = count - 1
        end
    end

    local armatureEffect = v.buffEffectList[nType]
    if count >= 0 and isDeath == false then
        -- if FightRole.__priority_camp == v.roleCamp then
        --     count = count + 1
        -- end
        v.buffList[nType] = count
        -- print("add buff : ", self.roleCamp, self._info._pos, nType, count)
        local buffInfo = _battle_buff_animation_dictionary[tonumber(nType) + 1]
        if armatureEffect == nil 
            and nil ~= buffInfo 
            and nil ~= buffInfo[1] and "-1" ~= buffInfo[1] and "" ~= buffInfo[1]
            and nil ~= buffInfo[3] 
            then
            local _evolution_level = tonumber(v._info._evolution_level)
            armatureEffect = v:crateBuffEffect(buffInfo[1], buffInfo[3])
            armatureEffect._px = v.parent:getContentSize().width / 2

            -- buff 光效x轴位置翻转
            local posX = buffInfo[4][_evolution_level][1]
            if v.roleCamp == 0 then
                posX = -posX
            end
            armatureEffect:setPosition(cc.p(armatureEffect._px + posX, buffInfo[4][_evolution_level][2]))

            v.buffEffectList[nType] = armatureEffect
            
            armatureEffect._buffInfo = buffInfo
            armatureEffect._train_level = _evolution_level

            armatureEffect._invoke = function ( armatureBack )
                local armature = armatureBack
                local fightRole = armature._self
                if armature ~= nil then
                    local actionIndex = armature._actionIndex
                    if actionIndex == 0 then
                        -- if armature._buffInfo[2] > 1 then
                        --     armature._nextAction = 1
                        --     armatureEffect:setPosition(cc.p(armatureEffect._px + armature._buffInfo[5][armature._train_level][1], armature._buffInfo[5][armature._train_level][2]))
                        -- end
                    elseif actionIndex == 1 then

                    elseif actionIndex == 2 then
                        armature._nextAction = 1
                    end
                end
            end
            
            armatureEffect._actionIndex = 0
            armatureEffect._nextAction = 0
            if armatureEffect._buffInfo[2] > 1 then
                armatureEffect._nextAction = 1
            end

            if v.roleCamp == 1 then
                armatureEffect:setScaleX(-1)
            end

            armatureEffect._self = self

            if nType == "79" then
                -- 复活
                v.armature:setVisible(false)
                -- armatureEffect:setVisible(false)
                armatureEffect._def = def

                v.armature._role._rlhp = tonumber(def.aliveHP)
                v.armature._role._rlsp = tonumber(def.aliveSP)

                v.armature._role._hp = 0
                v.armature._role._sp = 0
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = v._qte, status = "update"})
                showRoleSP(v.armature, def)
                showRoleHP(v.armature, def)
            elseif nType == "5" then -- 眩晕
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = v._qte, status = "dizzy"})
            elseif nType == "8" then -- 沉默
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = v._qte, status = "silence"})
            elseif nType == "17" then -- 冰冻

            elseif nType == "81" then -- 放逐
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = v._qte, status = "exile"})
            elseif nType == "84" or nType == "129" then -- 石化
                --角色模型变灰，动作静止
                v.armature:getAnimation():setSpeedScale(0)
                v.armature:getAnimation():getAnimationData():setColor(cc.c3b(79, 79, 79))

                state_machine.excute("battle_qte_head_update_draw", 0, {cell = v._qte, status = "stone"})
            elseif nType == "87" then -- 复仇
                if v.roleCamp == 0 then
                    armatureEffect:setScaleX(-1)
                else
                    armatureEffect:setScaleX(1)
                end

                fwin:addService({
                    callback = function ( params )
                        params._self:cleanBuffStateWithType("87")
                    end,
                    delay = 2 * __fight_recorder_action_time_speed,
                    params = armatureEffect
                })
            elseif nType == "91" then -- 复仇2
                if v.roleCamp == 0 then
                    armatureEffect:setScaleX(-1)
                else
                    armatureEffect:setScaleX(1)
                end

                fwin:addService({
                    callback = function ( params )
                        params._self:cleanBuffStateWithType("91")
                    end,
                    delay = 1.5 * __fight_recorder_action_time_speed,
                    params = armatureEffect
                })
            elseif nType == "100" then -- 复仇3
                if v.roleCamp == 0 then
                    armatureEffect:setScaleX(-1)
                else
                    armatureEffect:setScaleX(1)
                end

                fwin:addService({
                    callback = function ( params )
                        params._self:cleanBuffStateWithType("100")
                    end,
                    delay = 2 * __fight_recorder_action_time_speed,
                    params = armatureEffect
                })
            elseif nType == "119" then -- 复仇4
                if v.roleCamp == 0 then
                    armatureEffect:setScaleX(-1)
                else
                    armatureEffect:setScaleX(1)
                end

                fwin:addService({
                    callback = function ( params )
                        params._self:cleanBuffStateWithType("119")
                    end,
                    delay = 1.3 * __fight_recorder_action_time_speed,
                    params = armatureEffect
                })
            elseif nType == "137" then -- 复仇5
                if v.roleCamp == 0 then
                    armatureEffect:setScaleX(-1)
                else
                    armatureEffect:setScaleX(1)
                end

                fwin:addService({
                    callback = function ( params )
                        params._self:cleanBuffStateWithType("137")
                    end,
                    delay = 1.5 * __fight_recorder_action_time_speed,
                    params = armatureEffect
                })
            elseif nType == "140" then -- 破除庇护效果
                if v.roleCamp == 0 then
                    armatureEffect:setScaleX(-1)
                else
                    armatureEffect:setScaleX(1)
                end
                fwin:addService({
                    callback = function ( params )
                        params._self:cleanBuffStateWithType("140")
                    end,
                    delay = 1.5 * __fight_recorder_action_time_speed,
                    params = armatureEffect
                })
            elseif nType == "141" then -- 破除伤害吸收效果
                if v.roleCamp == 0 then
                    armatureEffect:setScaleX(-1)
                else
                    armatureEffect:setScaleX(1)
                end
                fwin:addService({
                    callback = function ( params )
                        params._self:cleanBuffStateWithType("141")
                    end,
                    delay = 1.5 * __fight_recorder_action_time_speed,
                    params = armatureEffect
                })
            end
        end
    else
        -- if armatureEffect ~= nil then
        --     deleteEffectFile(armatureEffect)
        --     v.buffEffectList[nType] = nil
        -- end
        -- v.buffList[nType] = nil
        v.buffList[nType] = count
    end
end

function FightRole:excuteCounterBuffEffect(v, count, isDeath, nType, def)
    -- 计数器类型
    local stCounterType = tonumber(def.stCounterType)
    local stCounterCount = tonumber(def.stCounterCount)

    -- print("excuteCounterBuffEffect->stCounterType = ", stCounterType, " stCounterCount = ", stCounterCount)

    local oldArmatureEffect = v.counterEffectMap[stCounterType]
    if oldArmatureEffect ~= nil then
        -- 角色身上存在同种类型和同数量的计数器，不做后续的绘制处理
        if oldArmatureEffect._counterType == stCounterType and oldArmatureEffect._counterCount == stCounterCount then
            return
        end

        oldArmatureEffect:removeFromParent(true)
        v.counterEffectMap[stCounterType] = nil
        oldArmatureEffect = nil
    end

    local key = stCounterType .. "-" .. stCounterCount
    local buffInfo = _battle_buff_counter_animation[key]

    local maxCount = self:getMaxCountByCounterType(stCounterType)
    if buffInfo == nil then
        if stCounterCount > maxCount then
            key = stCounterType .. "-" .. maxCount
            buffInfo = _battle_buff_counter_animation[key]
        end
    end

    if buffInfo == nil then     
        return
    end

    if isDeath == false then
        local evolution_level = tonumber(v._info._evolution_level)
        local armatureEffect = v:crateBuffEffect(buffInfo[1], buffInfo[3])
        armatureEffect._px = v.parent:getContentSize().width / 2

        -- buff 光效x轴位置翻转
        local posX = buffInfo[4][evolution_level][1]
        if v.roleCamp == 0 then
            posX = -posX
        end
        -- if v.roleCamp == 1 then
        --     armatureEffect:setScaleX(-1)
        -- end

        armatureEffect:setPosition(cc.p(armatureEffect._px + posX, buffInfo[4][evolution_level][2]))
        armatureEffect._buffInfo = buffInfo
        armatureEffect._train_level = evolution_level
        armatureEffect._counterType = stCounterType
        armatureEffect._counterCount = stCounterCount
        armatureEffect._self = self

        -- 加入到角色身上的计数器map里
        v.counterEffectMap[stCounterType] = armatureEffect
    end
end

-- 计算得到该类型计数器光效配置的最大数量
function FightRole:getMaxCountByCounterType(counterType)
    local countList = {}
    for k, v in pairs(_battle_buff_counter_animation) do
        local keyStr = zstring.split(k, "-", tonumber)
        if counterType == keyStr[1] then
            table.insert(countList, keyStr[2])
        end
    end
    table.sort(countList, function(a, b)
        return a < b
    end)
    return countList[#countList]
end

-- 攻击特效播放完后
function FightRole:executeEffectSkillingOverEx(armatureBack)
    deleteEffectFile(armatureBack)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end

    self._drawAttackEffectCount = self._drawAttackEffectCount - 1
    if self._drawAttackEffectCount > 0 then
        return
    end

    -- if self.armature._nextAction ~= _enum_animation_l_frame_index.animation_standby then
    --     -- 进入待机状态
    --     self.armature._invoke = nil
    --     self.armature._actionIndex = _enum_animation_l_frame_index.animation_standby
    --     self.armature._nextAction = _enum_animation_l_frame_index.animation_standby
    --     self.armature:getAnimation():playWithIndex(self.armature._actionIndex)
    --     self.armature._invoke = self.changeActionCallback
    -- end

    self.current_fight_data = self.current_fight_data_attacker
    if nil == self.current_fight_data then
        return
    end
    self.armature._sed_action = self.armature._sed_action_attacker
    self.armature._sie_action = self.armature._sie_action_attacker
    local defenderList = self.current_fight_data.__defenderList
    if defenderList ~= nil then
        for i, v in pairs(defenderList) do
            if v.current_fight_data ~= nil then
                local _def = v.current_fight_data.__def
                if _def ~= nil and _def.defAState == "1" then
                    v.waitByAttackOverDeathEvent = true
                    -->___crint("角色死亡")
                end
            else
                -->___crint("v.current_fight_data ~= nil")
            end
            if v.attackerCount == nil then
                v.attackerCount = 0
            end
            v.attackerCount = v.attackerCount - 1
            local index = 0
            if v.attackerList ~= nil then
                for j,k in pairs(v.attackerList) do
                    if k.pos == self.roleCamp.."a"..self._info._pos then
                        index = j
                        break
                    end
                end
                if index ~= 0 then
                    table.remove(v.attackerList, index)
                end
                -- print("3837", v.roleCamp, v._info._pos, #v.attackerList)
            end
            if v.attackerList == nil or #v.attackerList == 0 and v ~= self then --v.attackerCount <= 0 then
                v.attackerCount = 0
                v.waitByAttackOver = true
                v.roleByAttacking = false
            end
            -- if v.roleCamp == self.roleCamp then
                -- v.attackerCount = 0
                -- v.waitByAttackOver = false
                -- v.roleByAttacking = false
            -- end
            if v.buffList ~= nil then
                for nType,nCount in pairs(v.buffList) do
                    local count = tonumber(nCount)
                    local isDeath = false
                    if v.is_killed == true or v.is_deathed == true or v.roleWaitDeath == true then
                        isDeath = true
                    end
                    if __lua_project_id == __lua_project_gragon_tiger_gate then
                        if nType == "6" then
                            if count > 0 and isDeath == false then
                                if v._poisoning_effice == nil then
                                    v._poisoning_effice = v:crateBuffEffect(_battle_controller._poisoning_effice_id)
                                    if v._poisoning_effice ~= nil then
                                        v._poisoning_effice:setPositionX(v.parent:getContentSize().width/2)
                                    end
                                end
                            else
                                if v._poisoning_effice ~= nil then
                                    deleteEffectFile(v._poisoning_effice)
                                    v._poisoning_effice = nil
                                end
                                v.buffList[nType] = nil
                            end
                        elseif nType == "9" then
                            if count > 0 and isDeath == false then
                                if v._burn_effice == nil then
                                    v._burn_effice = v:crateBuffEffect(_battle_controller._burn_effice_id)
                                    if v._burn_effice ~= nil then
                                        v._burn_effice:setPositionX(v.parent:getContentSize().width/2)
                                    end
                                end
                            else
                                if v._burn_effice ~= nil then
                                    deleteEffectFile(v._burn_effice)
                                    v._burn_effice = nil
                                end
                                v.buffList[nType] = nil
                            end
                        elseif nType == "12" or nType == "23" or nType == "26" or nType == "106" then
                            if count > 0 and isDeath == false then
                                if v._invincible_effice == nil then
                                    v._invincible_effice = v:crateBuffEffect(_battle_controller._invincible_effice_id)
                                    if v._invincible_effice ~= nil then
                                        v._invincible_effice:setPositionX(v.parent:getContentSize().width/2)
                                    end
                                end
                            else
                                if v._invincible_effice ~= nil then
                                    deleteEffectFile(v._invincible_effice)
                                    v._invincible_effice = nil
                                end
                                v.buffList[nType] = nil
                            end
                        end
                    else
                        if __lua_project_id == __lua_project_l_naruto then

                        else
                            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
                            else
                                -- self:addBuffEffect(v, count, isDeath, nType) -- 取消攻击结束进行的buff添加
                            end
                        end
                    end
                end
            end
            -- 绘制buff光效
            -- if v._poisoning_effice_id ~= nil then
            --     v._poisoning_effice = v:crateBuffEffect(v._poisoning_effice_id)
            --     if v._poisoning_effice ~= nil then
            --         v._poisoning_effice:setPositionX(v.parent:getContentSize().width/2)
            --     end
            --     v._poisoning_effice_id = nil
            -- else
            --     if v._poisoning_effice ~= nil then
            --         deleteEffectFile(v._poisoning_effice)
            --         v._poisoning_effice = nil
            --     end
            -- end

            -- if v._burn_effice_id ~= nil then
            --     v._burn_effice = v:crateBuffEffect(v._burn_effice_id)
            --     if v._burn_effice ~= nil then
            --         v._burn_effice:setPositionX(v.parent:getContentSize().width/2)
            --     end
            --     v._burn_effice_id = nil
            -- else
            --     if v._burn_effice ~= nil then
            --         deleteEffectFile(v._burn_effice)
            --         v._burn_effice = nil
            --     end
            -- end

            -- if v._invincible_effice_id ~= nil then
            --     v._invincible_effice = v:crateBuffEffect(v._invincible_effice_id)
            --     if v._invincible_effice ~= nil then
            --         v._invincible_effice:setPositionX(v.parent:getContentSize().width/2)
            --     end
            --     v._invincible_effice_id = nil
            -- else
            --     if v._invincible_effice ~= nil then
            --         deleteEffectFile(v._invincible_effice)
            --         v._invincible_effice = nil
            --     end
            -- end
        end
    end

    local __fight_cacher_pool_temp_len = table.nums(self.__fight_cacher_pool_temp) 
    if __fight_cacher_pool_temp_len > 0 then
        local __fight_cacher_data_temp = table.remove(self.__fight_cacher_pool_temp, "1")
        self.current_fight_data.__attData = __fight_cacher_data_temp.__attData
        self.current_fight_data.__skf = __fight_cacher_data_temp.__skf
        self.current_fight_data.__defenderList = __fight_cacher_data_temp.__defenderList
        -- self:executeHeroMoveToTarget()
        self:executeAttackLogic(nil, true)
        return
    end

    if self.waitJumpBack == true or self.jumpOffsetY > 0 then
        self.parent:stopAllActionsByTag(2)
        if self.armature._nextAction ~= _enum_animation_l_frame_index.animation_standby then
            self.armature._invoke = nil
            self.armature._actionIndex = _enum_animation_l_frame_index.animation_standby
            self.armature._nextAction = _enum_animation_l_frame_index.animation_standby
            self.armature:getAnimation():playWithIndex(self.armature._actionIndex)
            self.armature._invoke = self.changeActionCallback
        end
        self.waitJumpOver = true
    else
        -- self.isCheckAttackEnd = true
        self:checkAttackEnd()
    end
end

-- 技能光效中段
local function executeEffectSkillingOver(armatureBack)
    if FightRole.__skeep_fighting == true then
        return
    end
    local _self = armatureBack._self
    if _self ~= nil and _self.parent ~= nil then
        _self:executeEffectSkillingOverEx(armatureBack)
    end
end

function FightRole:executeEffectSkilling(targetRole, flag)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    -->___rint("绘制攻击前段光效。", self.armature._sie_action)
    local skillInfluenceElementData = self.armature._sie_action
    -- local posterior_lighting_effect_id = self:getCampEffectId(skillInfluenceElementData, self.roleCamp, skill_influence.posterior_lighting_effect_id)
    local posterior_lighting_effect_idss = zstring.splits(dms.atos(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id), "|", ",", function (value) return tonumber(value) end)
    local posterior_lighting_effect_ids = posterior_lighting_effect_idss[1]
    local posterior_lighting_effect_id = posterior_lighting_effect_ids[1]
    -- debug.print_r({"skilling 0:", posterior_lighting_effect_ids})
    if posterior_lighting_effect_id >= 0 then
        -->___rint("posterior_lighting_effect_id:", posterior_lighting_effect_id)
        local armatureEffect = self:createEffect(posterior_lighting_effect_id)
        armatureEffect._self = self
        self._drawAttackEffectCount = self._drawAttackEffectCount + 1
        armatureEffect._sie_action = self.armature._sie_action
        -->___rint("armatureEffect._self:", armatureEffect._self)
        if flag ~= true then
            armatureEffect._invoke = executeEffectSkillingOver
        else
            armatureEffect._invoke = executeEffectSkillingOver
            armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)
        end

        local map = self:getParent()
        map:addChild(armatureEffect)

        local size = self:getParent():getContentSize()
        local sx, sy = self:getParent():getPosition()
        armatureEffect:setPosition(cc.p(sx, sy))
        if self.roleCamp == 1 then
            armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
        end
        
        -- 处理角度和路径
        local start_pos = nil
        local end_pos = nil
        local langle = 0
        start_pos = cc.p(self:getParent():getPosition())
        end_pos = cc.p(targetRole:getParent():getPosition())
        -- if self.roleCamp == 1 then
        --     langle = -180
        -- end

        -- local angle = math.atan2((start_pos.x-end_pos.x),(start_pos.y-end_pos.x))*180/3.1415926+90 -- ccaf(start_pos, end_pos)+langle
        local angle = 0 -- ccaf(start_pos, end_pos) - 90
        -->___rint("angle::::", angle)
        -- if angle >= 180 then
        --     angle = 180 - angle
        -- end
        -- if angle <= -180 then
        --     angle = 180 - (180 - angle)
        -- end
        -- if angle == langle and langle < 0 then
        --     angle = 0
        -- end
        local pSize = self:getParent():getContentSize()
        -- start_pos.x = start_pos.x + pSize.width * self:getParent():getScaleX()/2
        -- start_pos.y = start_pos.y + pSize.height * self:getParent():getScaleY()/2
        -- end_pos.x = end_pos.x + pSize.width * targetRole:getParent():getScaleX()/2
        -- end_pos.y = end_pos.y + pSize.height * targetRole:getParent():getScaleY()/2
        
        armatureEffect:setRotation(angle)
        armatureEffect:setPosition(start_pos)
        armatureEffect:runAction(cc.MoveTo:create(armatureEffect._duration * __fight_recorder_action_time_speed, end_pos))

        armatureEffect._angle = angle
        armatureEffect._start_position = start_pos
        armatureEffect._end_position = end_pos

        local posterior_lighting_effect_id2 = posterior_lighting_effect_ids[2]
        if nil ~= posterior_lighting_effect_id2 and posterior_lighting_effect_id2 > 0 then
            local map2 = map:getParent()
            local sx2, sy2 = map:getPosition()
            local armatureEffect2 = self:createEffect(posterior_lighting_effect_id2)
            armatureEffect2._invoke = deleteEffectFile
            map2:addChild(armatureEffect2, kZOrderInFightScene_Effect)
            armatureEffect2:setPosition(cc.p(sx + sx2, sy + sy2))
            if self.roleCamp == 0 then
                armatureEffect2:setScaleX(-1 * armatureEffect2:getScaleX())
            end
        end

        if nil ~= posterior_lighting_effect_idss[2] then
            local posterior_lighting_effect_id3 = posterior_lighting_effect_idss[2][1]
            if nil ~= posterior_lighting_effect_id3 and posterior_lighting_effect_id3 > 0 then
                local armatureEffect3 = self:createEffect(posterior_lighting_effect_id3)
                armatureEffect3._invoke = deleteEffectFile
                if self.roleCamp == 0 then
                    armatureEffect3:setScaleX(-1 * armatureEffect3:getScaleX())
                end
                state_machine.excute("fight_scene_play_by_attack_screen_bottom_effect", 0, armatureEffect3)
            end
        end
    else
        -->___rint("0-没有中断光效")
        fwin:addService({
            callback = function ( params )
                if params ~= nil and params.parent ~= nil then
                    params:executeEffectSkillingOverEx(armatureBack)
                end
            end,
            delay = 0.01,
            params = self
        })
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local posterior_lighting_sound_effect_ids = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id), ",")
        local musicid = zstring.tonumber(posterior_lighting_sound_effect_ids[self._drawAttackEffectCount])
        -- print('executeEffectSkilling -> musicId', self._drawAttackEffectCount, musicid, posterior_lighting_sound_effect_ids)
        if musicid > 0 then
            playEffectMusic(musicid)
        end
    else
        local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
        if posterior_lighting_sound_effect_id >= 0 then
            playEffectMusic(posterior_lighting_sound_effect_id)
        end
    end
end

function FightRole:executeEffectSkilling1OverEx(armatureBack)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    self:executeEffectSkillingOverEx(armatureBack)
end

local function executeEffectSkilling1Over(armatureBack)
    if FightRole.__skeep_fighting == true then
        return
    end
    local _self = armatureBack._self
    if _self ~= nil and _self.parent ~= nil then
        _self:executeEffectSkilling1OverEx(armatureBack)
    end
end

-- 基于施放者位置（只绘制一个光效）
function FightRole:executeEffectSkilling1()
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    local skillInfluenceElementData = self.armature._sie_action
    -- local posterior_lighting_effect_id = self:getCampEffectId(skillInfluenceElementData, self.roleCamp, skill_influence.posterior_lighting_effect_id)    --dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
    local posterior_lighting_effect_idss = zstring.splits(dms.atos(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id), "|", ",", function (value) return tonumber(value) end)
    local posterior_lighting_effect_ids = posterior_lighting_effect_idss[1]
    local posterior_lighting_effect_id = posterior_lighting_effect_ids[1]
    -- debug.print_r({"skilling 1:", posterior_lighting_effect_ids})
    if posterior_lighting_effect_id >= 0 then 
        local armatureEffect = self:createEffect(posterior_lighting_effect_id)
        armatureEffect._self = self
        self._drawAttackEffectCount = self._drawAttackEffectCount + 1
        armatureEffect._sie_action = self.armature._sie_action
        armatureEffect._invoke = executeEffectSkilling1Over
        armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)

        -- local sx, sy = self:getParent():getPosition()
        -- local map = self:getParent():getParent()
        -- map:addChild(armatureEffect, kZOrderInFightScene_Effect)

        -- local size = self:getContentSize()
        -- armatureEffect:setPosition(cc.p(sx + size.width / 2, sy))
        -- if self.roleCamp == 1 then
        --     armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
        -- end

        local map = self:getParent()
        map:addChild(armatureEffect)

        -- local size = self:getParent():getContentSize()
        local sx, sy = self:getPosition()
        armatureEffect:setPosition(cc.p(sx, sy))
        if self.roleCamp == 1 then
            armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
        end

        local posterior_lighting_effect_id2 = posterior_lighting_effect_ids[2]
        if nil ~= posterior_lighting_effect_id2 and posterior_lighting_effect_id2 > 0 then
            local map2 = map:getParent()
            local sx2, sy2 = map:getPosition()
            local armatureEffect2 = self:createEffect(posterior_lighting_effect_id2)
            armatureEffect2._invoke = deleteEffectFile
            map2:addChild(armatureEffect2, kZOrderInFightScene_Effect)
            armatureEffect2:setPosition(cc.p(sx + sx2, sy + sy2))
            if self.roleCamp == 0 then
                armatureEffect2:setScaleX(-1 * armatureEffect2:getScaleX())
            end
        end

        if nil ~= posterior_lighting_effect_idss[2] then
            local posterior_lighting_effect_id3 = posterior_lighting_effect_idss[2][1]
            if nil ~= posterior_lighting_effect_id3 and posterior_lighting_effect_id3 > 0 then
                local armatureEffect3 = self:createEffect(posterior_lighting_effect_id3)
                armatureEffect3._invoke = deleteEffectFile
                if self.roleCamp == 0 then
                    armatureEffect3:setScaleX(-1 * armatureEffect3:getScaleX())
                end
                state_machine.excute("fight_scene_play_by_attack_screen_bottom_effect", 0, armatureEffect3)
            end
        end
    else
        -- -1为没有中段光效
        fwin:addService({
            callback = function ( params )
                if params ~= nil and params.parent ~= nil then
                    params:executeEffectSkillingOverEx(armatureBack)
                end
            end,
            delay = 0.01,
            params = self
        })
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local posterior_lighting_sound_effect_ids = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id), ",")
        local musicid = zstring.tonumber(posterior_lighting_sound_effect_ids[self._drawAttackEffectCount])
        -- print('executeEffectSkilling1 -> musicId', self._drawAttackEffectCount, musicid, posterior_lighting_sound_effect_ids)
        if musicid > 0 then
            playEffectMusic(musicid)
        end
    else
        local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
        if posterior_lighting_sound_effect_id >= 0 then
            playEffectMusic(posterior_lighting_sound_effect_id)
        end
    end
end

function FightRole:executeEffectSkilling2OverEx(armatureBack)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    self:executeEffectSkillingOverEx(armatureBack)
end

local function executeEffectSkilling2Over(armatureBack)
    if FightRole.__skeep_fighting == true then
        return
    end
    local tag = armatureBack:getTag()
    for k,v in pairs(FightRole.__mapEffectList) do
        if v.tag == tag then
            table.remove(FightRole.__mapEffectList, ""..k)
        end
    end
    
    local _self = armatureBack._self
    if _self ~= nil and _self.parent ~= nil then
        _self:executeEffectSkilling2OverEx(armatureBack)
    end
end

function FightRole:executeEffectSkilling2(targetRole, flg)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    local skillInfluenceElementData = self.armature._sie_action
    -- local posterior_lighting_effect_id = self:getCampEffectId(skillInfluenceElementData, self.roleCamp, skill_influence.posterior_lighting_effect_id)    --dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
    local posterior_lighting_effect_idss = zstring.splits(dms.atos(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id), "|", ",", function (value) return tonumber(value) end)
    local posterior_lighting_effect_ids = posterior_lighting_effect_idss[1]
    local posterior_lighting_effect_id = posterior_lighting_effect_ids[1]
    -- debug.print_r({"skilling 2:", posterior_lighting_effect_ids})
    if posterior_lighting_effect_id >= 0 then 
        local armatureEffect = self:createEffect(posterior_lighting_effect_id)
        armatureEffect._self = self
        self._drawAttackEffectCount = self._drawAttackEffectCount + 1
        armatureEffect._sie_action = self.armature._sie_action
        if flg ~= true then
            armatureEffect._invoke = executeEffectSkilling2Over
        else
            armatureEffect._invoke = executeEffectSkilling2Over
            armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)
        end
        FightRole.__mapEffectTag = FightRole.__mapEffectTag + 1
        armatureEffect:setTag(FightRole.__mapEffectTag)
        table.insert(FightRole.__mapEffectList, {armature = armatureEffect, tag = FightRole.__mapEffectTag})

        local sx, sy = targetRole.parent:getPosition()
        local map = targetRole.parent:getParent()
        map:addChild(armatureEffect, kZOrderInFightScene_Effect)

        local size = self:getContentSize()
        armatureEffect:setPosition(cc.p(sx + size.width / 2, sy))
        if self.roleCamp == 1 then
            armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
        end

        local posterior_lighting_effect_id2 = posterior_lighting_effect_ids[2]
        if nil ~= posterior_lighting_effect_id2 and posterior_lighting_effect_id2 > 0 then
            local map2 = map:getParent()
            local sx2, sy2 = map:getPosition()
            local armatureEffect2 = self:createEffect(posterior_lighting_effect_id2)
            armatureEffect2._invoke = deleteEffectFile
            map2:addChild(armatureEffect2, kZOrderInFightScene_Effect)
            armatureEffect2:setPosition(cc.p(sx + sx2, sy + sy2))
            if self.roleCamp == 0 then
                armatureEffect2:setScaleX(-1 * armatureEffect2:getScaleX())
            end
        end

        if nil ~= posterior_lighting_effect_idss[2] then
            local posterior_lighting_effect_id3 = posterior_lighting_effect_idss[2][1]
            if nil ~= posterior_lighting_effect_id3 and posterior_lighting_effect_id3 > 0 then
                local armatureEffect3 = self:createEffect(posterior_lighting_effect_id3)
                armatureEffect3._invoke = deleteEffectFile
                if self.roleCamp == 0 then
                    armatureEffect3:setScaleX(-1 * armatureEffect3:getScaleX())
                end
                state_machine.excute("fight_scene_play_by_attack_screen_bottom_effect", 0, armatureEffect3)
            end
        end
    else
        -->___rint("1-没有中断光效")
        fwin:addService({
            callback = function ( params )
                if params ~= nil and params.parent ~= nil then
                    params:executeEffectSkillingOverEx(armatureBack)
                end
            end,
            delay = 0.01,
            params = self
        })
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local posterior_lighting_sound_effect_ids = zstring.split(dms.atos(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id), ",")
        local musicid = zstring.tonumber(posterior_lighting_sound_effect_ids[self._drawAttackEffectCount])
        -- print('executeEffectSkilling2 -> musicId', self._drawAttackEffectCount, musicid, posterior_lighting_sound_effect_ids)
        if musicid > 0 then
            playEffectMusic(musicid)
        end
    else
        local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
        if posterior_lighting_sound_effect_id >= 0 then
            playEffectMusic(posterior_lighting_sound_effect_id)
        end
    end
end

-- 执行攻击技能效用
function FightRole:executeAttackInfluence(_skf)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    
    self.current_fight_data = self.current_fight_data_attacker
    self.armature._sed_action = self.armature._sed_action_attacker
    self.armature._sie_action = self.armature._sie_action_attacker
    local defenderList = self.current_fight_data.__defenderList
    local skillInfluenceElementData = self.armature._sie_action
    local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
    for w = 1, zstring.tonumber(_skf.defenderCount) do
        local _def = _skf._defenders[w]
        local defender = _def.defender                      -- = npos(list)         --承受方1的标识(0:我方 1:对方)
        local defenderPos = tonumber(_def.defenderPos)      -- = npos(list)         --承受方1的位置
        local restrainState = _def.restrainState            -- = npos(list)         --相克状态(0,无克制 1,有克制,2被克制)
        local defenderST = _def.defenderST                  -- = npos(list)         --承受方1的作用效果(?)
        local stValue = _def.stValue                        -- = npos(list)         --承受方1的作用值
        local stRound = _def.stRound                        -- = npos(list)         --承受方1的持续回合数
        local defState = _def.defState                      -- = npos(list)         --承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
        local defAState = _def.defAState                    -- = npos(list)         --承受方1生存状态(0:存活 1:死亡 2:反击)

        local byAttackTarget = defenderList["".._def.defender.."t".._def.defenderPos]
        if byAttackTarget ~= nil and byAttackTarget.parent ~= nil then
            --if zstring.tonumber(_def.defender) ~= self.roleCamp then
                if byAttackTarget.current_fight_data == nil then
                    byAttackTarget.current_fight_data = {}
                end
                byAttackTarget.current_fight_data.__def = _def
                byAttackTarget.current_fight_data.__bySkf = _skf
                byAttackTarget.current_fight_data.__attackArmature = self.armature
                -- byAttackTarget.attackerCount = byAttackTarget.attackerCount + 1
            --end

            byAttackTarget._hurtCount = 0
            byAttackTarget.drawDamageNumberCount = 0
        else
            -->___crint("current attack role is nil.")

            -- state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)

            defenderList["".._def.defender.."t".._def.defenderPos] = nil
        end
        
        
        local rPad = defender == "0" and 
                       self._FightRoleController._hero_formation[""..defenderPos] or
                       self._FightRoleController._master_formation[""..defenderPos]
        if rPad ~= nil and rPad.armature ~= nil then
            local drawString = _def.stValue
            if tonumber(_def.defender) == 1 and defenderST == "0" then
                BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(drawString)
                state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
            end
            if defenderST == "0" or defenderST == "6" or defenderST == "9" then
                drawString = "-"..drawString
            elseif defenderST == "1" or defenderST == "31" then
                drawString = "+"..drawString
            end
            
            if (defenderST == "2" or defenderST == "3") and (rPad.armature~= nil and rPad.armature._role ~= nil and rPad.armature._role._sp ~= nil) then
                -- local flag = -1
                -- if defenderST == "2" then
                --     flag = 1
                -- end
                
                -- rPad.armature._role._sp = rPad.armature._role._sp + ((defenderST == "2" and 1 or -1) * tonumber(_def.stValue))
                -- rPad.armature._role._sp = rPad.armature._role._sp + (flag * tonumber(_def.stValue))
                local sp = zstring.tonumber(_def.aliveSP)
                if sp < 0 then
                    sp = 0
                elseif sp > FightModule.MAX_SP then
                    sp = FightModule.MAX_SP
                end

                rPad.armature._role._sp = _def.aliveSP
                rPad.armature._role._lsp = _def.aliveSP

                showRoleSP(rPad.armature, _def)
            elseif (defenderST == "0" or defenderST == "1" or defenderST == "6" or defenderST == "9" or defenderST == "31") then
                -- rPad.armature._role._hp = rPad.armature._role._hp + tonumber(drawString)
                -- showRoleHP(rPad.armature)
            elseif (defenderST == "19") then
                rPad.armature._role._hp = rPad.armature._role._hp + tonumber(_def.stValue)
                rPad.armature._role._lhp = _def.aliveHP
                rPad._info._max_hp = rPad._info._max_hp + tonumber(_def.stValue)
                if rPad.roleCamp == 0 then
                    self._FightRoleController.heros_total_hp = self._FightRoleController.heros_total_hp + tonumber(_def.stValue)
                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "update"})
                else
                    self._FightRoleController.masters_total_hp = self._FightRoleController.masters_total_hp + tonumber(_def.stValue)
                end
            elseif defenderST == "20" then

            elseif BattleSkill.isLifeChainSkill(defenderST) then
                -- 如果生命链接的回合数结束，清理掉表现层
                local count = zstring.tonumber(_def.stRound)

                if count < 0 then
                    if _def.stVisible == "0" then
                        self:cleanBuffStateWithType(defenderST)
                    end
                end
            end
        end
    end

    for k,v in pairs(self.current_fight_data.add_fight_data) do
        if v ~= nil then
            local skf = v.__skf
            for w = 1, zstring.tonumber(skf.defenderCount) do
                local _def = skf._defenders[w]
                local defender = _def.defender
                local defenderPos = tonumber(_def.defenderPos) -- npos(list) 承受方1的位置
                local defenderST = _def.defenderST             -- npos(list) 承受方1的作用效果
                local stValue = _def.stValue                   -- npos(list) 承受方1的作用值

                local rPad = defender == "0" and 
                       self._FightRoleController._hero_formation[""..defenderPos] or
                       self._FightRoleController._master_formation[""..defenderPos]

                if tonumber(defender) == 1 and defenderST == "0" then
                    BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(stValue)
                    state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
                end

                if (defenderST == "2" or defenderST == "3") and (nil ~= rPad and rPad.armature~= nil and rPad.armature._role ~= nil) then
                    if rPad.armature._role._sp ~= nil then
                        -- local flag = -1
                        -- if defenderST == "2" then
                        --     flag = 1
                        -- end
                        -- rPad.armature._role._sp = rPad.armature._role._sp + ((defenderST == "2" and 1 or -1) * tonumber(stValue))
                        -- rPad.armature._role._sp = rPad.armature._role._sp + (flag * tonumber(stValue))

                        local sp = zstring.tonumber(_def.aliveSP)
                        if sp < 0 then
                            sp = 0
                        elseif sp > FightModule.MAX_SP then
                            sp = FightModule.MAX_SP
                        end

                        rPad.armature._role._sp = _def.aliveSP
                        rPad.armature._role._lsp = _def.aliveSP

                        showRoleSP(rPad.armature, _def)

                        rPad._hurtCount = 0
                        rPad.drawDamageNumberCount = 0
                    end
                elseif defenderST == "20" then

                end
            end
        end
    end

    for i, v in pairs(defenderList) do
        -- if v.attackerList == nil then
            v.attackerList = {}
        -- end
        local function checkSameAttacker( posInfo )
            for j,k in pairs(v.attackerList) do
                if k.pos == posInfo then
                    return true
                end
            end
            return false
        end
        if checkSameAttacker(self.roleCamp.."a"..self._info._pos) == false then
            table.insert(v.attackerList, {pos = self.roleCamp.."a"..self._info._pos, role = self})
        end
    end
    -->___rint("光效的绘制类型：", lightingEffectDrawMethod)
    -- 绘制攻击光效
    if lightingEffectDrawMethod == 0 then  -- 0基于施放者与承受者的路径（根据目标数量绘制光效）
        local index = 1
        for i, v in pairs(defenderList) do
            if v.roleCamp ~= self.roleCamp then
                self:executeEffectSkilling(v, index == 1)
                index = index + 1
            else
                if v == self and v.current_fight_data ~= nil and (v.current_fight_data.__def.defenderST == "2" or v.current_fight_data.__def.defenderST == "20") then
                else
                    self:executeEffectSkilling(v, false)
                end
            end
        end
    elseif lightingEffectDrawMethod == 1 then -- 1基于施放者位置（只绘制一个光效）
        self:executeEffectSkilling1()
    elseif lightingEffectDrawMethod == 2 then -- 2基于承受者位置（根据目标数量绘制光效）
        local index = 1
        for i, v in pairs(defenderList) do
            --if v.roleCamp ~= self.roleCamp then
            if v == self and v.current_fight_data ~= nil and (v.current_fight_data.__def.defenderST == "2" or v.current_fight_data.__def.defenderST == "20") then
            else
                self:executeEffectSkilling2(v, index == 1)
                index = index + 1
            end
            --end
        end
    else
        self:executeEffectSkilling1()
    end

    if table.nums(defenderList) == 0 then
        self:executeEffectSkillingOverEx(nil)
    end
end

function FightRole:executeAttacking()
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    -- if self.pursuit_target ~= nil then
    --     return
    -- end
    self.current_fight_data = self.current_fight_data_attacker
    self.armature._sed_action = self.armature._sed_action_attacker
    self.armature._sie_action = self.armature._sie_action_attacker
    local defenderList = self.current_fight_data.__defenderList
    local _skf = self.current_fight_data.__skf
    self:executeAttackInfluence(_skf)
end

function FightRole:executeAttackLogicing()
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end
    
    local function executeAttackLogicingFunc()
        if self:lockAttackTarget(true) == true then
            -- print("锁定角色一", self.roleCamp, self._info._pos)
            self:executeHeroMoveToTarget()
        else
            -- print("锁定角色二", self.roleCamp, self._info._pos)
        end
    end
    
    if is2004 == true then 
        local armature = self.armature
        local actionIndexs = zstring.split(dms.atos(armature._sie_action, skill_influence.after_action), ",")
        local actionIndex = zstring.tonumber(actionIndexs[self.roleCamp] or actionIndexs[1])

        if actionIndex == nil then
            actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
        end
        
        -- 普通攻击处理
        if actionIndex == _enum_animation_l_frame_index.animation_skill_attacking then
            self:removeFromAttackingArgs()
            table.insert(FightRole.__attacking_roles, 1, self)
        end
    
        if FightRole.__attacking_roles[1] ~= nil and
          #FightRole.__attacking_roles > 1 then
            math.randomseed(tostring(os.time()):reverse():sub(1,6))
            local speed_index = math.random(1,#_battle_controller._random_move_time)
            local speed_random = _battle_controller._random_move_time[speed_index]
          
            local array = {}
            table.insert(array, cc.DelayTime:create(speed_random * (#FightRole.__attacking_roles - 1) * __fight_recorder_action_time_speed))
            table.insert(array, cc.CallFunc:create(executeAttackLogicingFunc))
            local seq = cc.Sequence:create(array)
            self:runAction(seq)
        else
            executeAttackLogicingFunc()
        end
    else
        executeAttackLogicingFunc()
    end
end

function FightRole:checkNextSkillInfluence()
    local current_fight_data = self.fight_cacher_pool[1]
    self.current_fight_data = self.current_fight_data_attacker
    self.armature._sed_action = self.armature._sed_action_attacker
    self.armature._sie_action = self.armature._sie_action_attacker
    local defenderList = self.current_fight_data.__defenderList
    if defenderList ~= nil then
        for i, v in pairs(defenderList) do
            if v.parent ~= nil and v.roleCamp ~= self.roleCamp then
                v.armature._nextAction = _enum_animation_l_frame_index.animation_standby
            end
            if v.parent ~= nil and (v.roleByAttacking == true or v.waitByAttackOver == true or v.waitByAttackOverDeathEvent == true)
                then
                -->___rint(v.roleByAttacking, v.waitByAttackOver, v.waitByAttackOverDeathEvent)
                return false
            end 
        end
    end
    self.waitNextSkillInfluence = false
    self.current_fight_data = current_fight_data
    self.current_fight_data_attacker = current_fight_data
    self:executeAttackLogic(true)
end

function FightRole:checkDefenderList( defenderListEx, isBuff )
    if defenderListEx ~= nil then
        for i, v in pairs(defenderListEx) do
            if v.parent ~= nil and isBuff == false then
                -- if v.repelAndFlyEffectCount > 0 then
                -- else
                if v.roleCamp ~= self.roleCamp then
                    v.parent:stopAllActionsByTag(2)
                end
                -- end
                v.attackerCount = v.attackerCount + 1
                v.fly_index = 0
            end 
            if v.killer == self then
                v.killer._show_kill_add_sp = true
                v.killer = nil
                v.roleWaitDeath = true
            end
            if v ~= self then 
                -- v.waitByAttack ~= nil then
                v.attacker = self
                if v.roleCamp ~= self.roleCamp and isBuff == false then
                    -- print("checkDefenderList v.roleCamp = ", v.roleCamp, " v.pos = ", v._info._pos, " v.roleByAttacking 变为 true")
                    v.roleByAttacking = true
                    if v.parent ~= nil then
                        v:waitByAttack()
                        v:addRoleByAttackSignEffect()
                    end
                end
                v._hurtCount = nil
            end

            if nextSkillInfluence ~= true and isBuff == false then
                v.attackerList = {}
                local function checkSameAttacker( posInfo )
                    for j,k in pairs(v.attackerList) do
                        if k.pos == posInfo then
                            return true
                        end
                    end
                    return false
                end
                if checkSameAttacker(self.roleCamp.."a"..self._info._pos) == false then
                    table.insert(v.attackerList, {pos = self.roleCamp.."a"..self._info._pos, role = self})
                end
            end
        end
    end
end

-- 开始执行攻击逻辑
function FightRole:executeAttackLogic(nextSkillInfluence, changeTarget)
    if FightRole.__skeep_fighting == true or self.fight_over == true then
        return
    end

    -- print("开始执行攻击逻辑 roleCamp = ", self.roleCamp, " pos = ", self._info._pos)

    self:cleanBuffStateWithType("79")

    if self.current_fight_data.__fitAttacker ~= nil then
        if self.fiter == false then
            -- 全部的角色设置到出生的地点
            -- state_machine.excute("fight_role_controller_reset_role_position", 0, true)
            -- state_machine.excute("fight_role_controller_hide_role_layer", 0, nil)
            FightRole.__fit_attacking = true
            self.fiter = true
            -->___crint("合体者出现了！！！")
            self:excuteSPSkillEffectFit()

            -- 处理在合体技能发动的时候，隐藏相关的地图信息
            -- state_machine.excute("fight_scene_views_visible", 0, {false,false,false,true,false})
            return
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        if self.roleCamp == 1 then
            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
                local attData               = self.current_fight_data.__attData
                self.attackerHp = attData.attackerHp
                self.attackerSp = attData.attackerSp
                fwin:addService({
                    callback = function ( params )
                        if nil ~= params.checkAttackEnd then
                            params.roleAttacking = false
                            self.fight_cacher_pool = {}
                            params:checkAttackEnd()
                        end
                    end,
                    delay = 0.05,
                    params = self
                })
                self.roleAttacking = true
                return
            end
        end
    end

    local addFightData = {}
    -- self.current_fight_data.add_fight_data = {}
    local nextFightData = nil
    local isCheckFightData = false
    if #self.fight_cacher_pool > 1 then
        for k,v in pairs(self.fight_cacher_pool) do
            if v ~= nil then
                local skillInfluenceId = v.__skf.skillInfluenceId
                local skill_category = dms.int(dms["skill_influence"], skillInfluenceId, skill_influence.skill_category)
                -- print("+++++ executeAttackLogic ++++++ skill_category=", skill_category);
                if isCheckFightData == false 
                    and (tonumber(skill_category) == 0 or tonumber(skill_category) == 1) 
                    then
                    local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
                    local posterior_lighting_effect_idss = zstring.splits(dms.atos(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id), "|", ",", function (value) return tonumber(value) end)
                    local posterior_lighting_effect_ids = posterior_lighting_effect_idss[1]
                    local posterior_lighting_effect_id = posterior_lighting_effect_ids[1]
                    if posterior_lighting_effect_id >= 0 then
                        self.current_fight_data = v
                        self.current_fight_data_attacker = v
                        isCheckFightData = true
                    end
                else
                    table.insert(addFightData, v)
                end
            end
            -- currentFightIndex = currentFightIndex + 1
        end
        for k,v in pairs(addFightData) do
            for k1,v1 in pairs(self.fight_cacher_pool) do
                if v == v1 then
                    table.remove(self.fight_cacher_pool, k1)
                    break
                end
            end
        end
    end
    self.current_fight_data.add_fight_data = addFightData

    local attData               = self.current_fight_data.__attData
    local attacker              = attData.attacker                                  -- 回合1出手方标识(0:我方 1:对方)
    local attackerPos           = attData.attackerPos                               -- 出手方位置(1-6)
    local linkAttackerPos       = attData.linkAttackerPos                           -- 是否有合体技(>0表示有.且表示合体的对象)
    local attackMovePos         = tonumber(attData.attackMovePos)                   -- 移动到的位置(0-8)
    local skillMouldId          = tonumber(attData.skillMouldId)                    -- 技能模板id
    local skillInfluenceCount   = tonumber(attData.skillInfluenceCount)             -- 技能效用数量

    local skillElementData = dms.element(dms["skill_mould"], skillMouldId)

    self.attackerHp = attData.attackerHp
    self.attackerSp = attData.attackerSp

    -- 桃地再不斩大招 三次攻击 避免神兽数据解析多次
    if not changeTarget then
        local curRoundCount = self._FightRoleController.current_logic_round
        local animalRoundData = _ED.animalRoundData and _ED.animalRoundData[curRoundCount]
        local animalData = nil
        if animalRoundData then
            local animalInfoData = animalRoundData.animalInfoData
            animalData = table.remove(animalInfoData, 1)
        end

        -- print("开始执行攻击逻辑 curRoundCount = ", curRoundCount)
        -- debug.print_r(animalData, "animalData")

        -- 更新神兽怒气值UI
        state_machine.excute("fight_ui_update_animal_anger_progress", 0, animalData)
        state_machine.excute("fight_ui_update_animal_skill_state", 0, animalData)
    end

    -- if self.armature._role._hp <= 0 then
    --     self.armature._role._hp = tonumber(self.attackerHp)
    --     showRoleHP(self.armature)
    -- end

    self.singleAttackCount = 0

    -- local skillInfluenceId = dms.atoi(skillElementData, skill_mould.health_affect)
    -- if skillInfluenceId == nil then
    --     skillInfluenceId = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")[1]
    -- end

    local skillInfluenceId = self.current_fight_data.__skf.skillInfluenceId
    local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)

    self.armature._sed_action = skillElementData
    self.armature._sie_action = skillInfluenceElementData

    self.armature._sed_action_attacker = skillElementData
    self.armature._sie_action_attacker = skillInfluenceElementData

    local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)  -- 技能类型(0:普通 1:怒气)
    local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)    -- 技能属性(0:物理 1:法术)

    local defenderList = self.current_fight_data.__defenderList

    self.skillQuality = skillQuality

    -- self.current_fight_data.add_fight_data = {}

    -- local nextFightData = nil
    -- local currentFightIndex = 1
    -- if #self.fight_cacher_pool > 1 then
    --     for k,v in pairs(self.fight_cacher_pool) do
    --         if currentFightIndex > 1 and v ~= nil then
    --             -- local skillInfluenceId = v.__skf.skillInfluenceId
    --             -- local skill_category = dms.int(dms["skill_influence"], skillInfluenceId, skill_influence.skill_category)
    --             -- if tonumber(skill_category) > 0 then
    --                 table.insert(self.current_fight_data.add_fight_data, v)
    --             -- end
    --         end
    --         currentFightIndex = currentFightIndex + 1
    --     end
    --     for k,v in pairs(self.current_fight_data.add_fight_data) do
    --         for k1,v1 in pairs(self.fight_cacher_pool) do
    --             if v == v1 then
    --                 table.remove(self.fight_cacher_pool, k1)
    --                 break
    --             end
    --         end
    --     end
    -- end

    if attacker == "0" then
        local totalHurt = 0
        for j = 1, attData.skillInfluenceCount do
            local _skf = attData.skillInfluences[j]
            if _skf ~= nil then
                for w = 1, _skf.defenderCount do
                    local _def = _skf._defenders[w]
                    if _def ~= nil and (_def.defenderST == "0" or _def.defenderST == "6") then
                        if tonumber(_def.defender) == 1 then
                            totalHurt = totalHurt + tonumber(_def.stValue)
                        end
                    end
                end
            end
        end

        if tonumber(attData.linkAttackerPos) > 0 and attData.fitHeros ~= nil then --如果有合体技能
            for k, fitAttData in pairs(attData.fitHeros) do
                if fitAttData ~= nil then
                    for j = 1, fitAttData.skillInfluenceCount do
                        local _fitSkf = fitAttData.skillInfluences[j]
                        if _fitSkf ~= nil then
                            for w = 1, _fitSkf.defenderCount do
                                local _def = _fitSkf._defenders[w]
                                if _def ~= nil and (_def.defenderST == "0" or _def.defenderST == "6") then
                                    if tonumber(_def.defender) == 1 then
                                        totalHurt = totalHurt + tonumber(_def.stValue)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if totalHurt ~= 0 and attData.calcHurt == nil then
            attData.calcHurt = true
            BattleSceneClass.curDamage = BattleSceneClass.curDamage + totalHurt
            state_machine.excute("fight_ui_for_daily_activity_copy_update_fight_damage", 0, {BattleSceneClass.curDamage})               
        end
    end
    
    self:checkDefenderList(defenderList, false)
    for k,v in pairs(self.current_fight_data.add_fight_data) do
        self:checkDefenderList(v.__defenderList, true)
    end
    
    self.parent:stopAllActionsByTag(2)
    self.roleByAttacking = false
    self.roleAttacking = true
    self.fly_index = 0

    self.actionTimeSpeed = __fight_recorder_action_time_speed
    self.armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)

    if nil ~= self._play_pinjia_ani then
        state_machine.excute("fight_qte_controller_play_pinjia_ani", 0, self._play_pinjia_ani)
        self._play_pinjia_ani = nil
    end

    if nextSkillInfluence == true then
        -->___rint("进入下一个效用")
        self:changeActtackToAttackBegan(self.armature)
    else
        -- if self.current_fight_data.__fitAttacker ~= nil then
        --     FightRole.__fit_attacking = true
        --     self.fiter = true
        --     -->___crint("合体者出现了！！！")
        --     self:excuteSPSkillEffectFit()

        --     -- 处理在合体技能发动的时候，隐藏相关的地图信息
        --     state_machine.excute("fight_scene_views_visible", 0, {false,false,false,true,false})
        -- else
            if self.fitAttacking == true then
                self:executeAttackLogicing()
            else
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    then
                    if true == changeTarget then
                        -- ...
                    elseif skillQuality == 1 then
                        if self.armature._camp == 0 then
                            self.armature._role._sp = FightModule.MAX_SP
                            self.armature._role._lsp = FightModule.MAX_SP
                            -- state_machine.excute("the_kings_battle_ui_window_update_draw_hp", 0, {self.armature, nil})
                            state_machine.excute("the_kings_battle_ui_window_update_draw_sp", 0, {self.armature, nil})
                        else
                            self.armature._role._sp = FightModule.MAX_SP
                            self.armature._role._lsp = FightModule.MAX_SP
                            -- state_machine.excute("the_kings_battle_ui_window_update_draw_hp", 0, {nil, self.armature})
                            state_machine.excute("the_kings_battle_ui_window_update_draw_sp", 0, {nil, self.armature})
                        end

                        self.armature._role._sp = 0
                        FightRoleController.__lock_battle = true
                        showRoleSP(self.armature)

                        state_machine.excute("fight_qte_controller_update_draw_power_skill_total_damage", 0, 0)

                        -- state_machine.excute("fight_role_controller_play_power_skill_screen_effect", 0, {_role = self, _unload = true})
                        state_machine.excute("fight_role_controller_play_power_skill_screen_effect", 0, {_role = self, _unload = false})
                        state_machine.excute("skill_closeup_window_open", 0, {self, self.roleCamp, self._info._head})
                        return
                    end
                end
                if skillQuality == 1 or skillQuality == 2 then
                    self.parent:stopAllActionsByTag(2)
                    self:excuteSPSkillEffect()
                else
                    self:executeAttackLogicing()
                end
            end
        -- end
    end

    -- if self._update_draw_camp_change_influence_info == true then
    --     state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "" .. self.roleCamp)
    --     self._update_draw_camp_change_influence_info = false
    -- end
end

function FightRole:addRoleByAttackSignEffect( ... )
    if __lua_project_id == __lua_project_gragon_tiger_gate then
        self:removeByAttackSignEffect()

        self.signEffect = sp.spine_effect("duixiang", effectAnimations[1], false, nil, nil, nil)
        self.signEffect.animationNameList = effectAnimations
        sp.initArmature(self.signEffect, true)

        -- armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
        self.signEffect:getAnimation():setSpeedScale(1.0 / __fight_recorder_action_time_speed)

        local size = self:getContentSize()
        self.signEffect:setPosition(cc.p(size.width / 2, 0))
        self:addChild(self.signEffect, -2)
    end
end

function FightRole:removeByAttackSignEffect( ... )
    if self.signEffect ~= nil and self.signEffect.getParent ~= nil then
        self.signEffect:removeFromParent(true)
    end
    self.signEffect = nil
end

function FightRole:executeAnimationStandby(armatureBack)
    local armature = armatureBack

    self.changeActionToAttacking = false

    if self.enter_into == true then
        self.enter_into = false
        armature._nextAction = _enum_animation_l_frame_index.animation_move
    end

    if self.moveBackArena == true then
        
    end

    if self.celebrate_win == true then
        self.celebrate_win = false
        state_machine.excute("fight_role_controller_notification_role_celebrate_win_over", 0, 0)
    end

    if self.is_deathed == true then
        self:executeAnimationDeath(armatureBack)
    end
end

function FightRole:executeAnimationMove(armatureBack)
    -- if self.chanageMoveActions == true and self.move_state == self._move_state_enum._MOVE_STATE_FREE then
    --     -->___crint("----------executeAnimationMove---------", self.move_state, self.chanageMoveActions)
    --     state_machine.excute("fight_role_check_move_event", 0, self)
    -- end
end

function FightRole:executeAnimationMoveBack(armatureBack)
    -- if self.chanageMoveActions == true and self.move_state == self._move_state_enum._MOVE_STATE_FREE then
    --     -->___crint("-----------executeAnimationMoveBack--------", self.move_state, self.chanageMoveActions)
    --     state_machine.excute("fight_role_check_move_event", 0, self)
    -- end
end

function FightRole:executeAnimationOnrush(armatureBack)
    if self.current_fight_data ~= nil then
        -- local function checkMoveEventMoveOverFuncN(_parent)
        --     if _parent ~= nil and _parent._self ~= nil then
                
        --     end
        -- end

        -- local array = {}
        -- table.insert(array, cc.DelayTime:create(1.5 * __fight_recorder_action_time_speed))
        -- table.insert(array, cc.CallFunc:create(checkMoveEventMoveOverFuncN))
        -- local seq = cc.Sequence:create(array)

        -- self.parent:runAction(seq)
    end
end

function FightRole:executeAnimationSkillBegan(armatureBack)
    -- local armature = armatureBack

    -- local actionIndexs = zstring.split(dms.atos(armature._sie_action, skill_influence.after_action), ",")
    -- local actionIndex = zstring.tonumber(actionIndexs[self.roleCamp] or actionIndexs[1])

    -- local armature = armatureBack
    -- if actionIndex == nil then
    --     actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
    -- end
    -- -- armature:getAnimation():playWithIndex(actionIndex)
    -- -- armature._actionIndex = actionIndex
    -- armature._nextAction = actionIndex

    -->___crint("聚气完毕", self.armature._role._name)
    
    self:executeAttackLogicing()
end

function FightRole:executeAnimationNormalBeAttacked(armatureBack)
    local armature = armatureBack
    -- armature._nextAction = _enum_animation_l_frame_index.animation_standby
end

function FightRole:executeAnimationNormalConversely(armatureBack)
    local armature = armatureBack
    armature._nextAction = _enum_animation_l_frame_index.animation_standby
end

function FightRole:executeAnimationDiagonalFloated(armatureBack)
    local armature = armatureBack
    -- armature._nextAction = _enum_animation_l_frame_index.animation_standby
end

function FightRole:executeAnimationLandscapeBlowFly(armatureBack)
    local armature = armatureBack
    armature._nextAction = _enum_animation_l_frame_index.animation_standby
end

function FightRole:executeAnimationConversely(armatureBack)
    local armature = armatureBack
    
    if self.is_killed == true
      -- and (self.roleCamp == 1 or self._FightRoleController.current_fight_index >= _ED.battleData.battle_total_count or _ED.attackData.isWin == "0") then
      then
        self:cleanBuffState(true)
        -- 直接进入死亡动作帧组
        local actionIndex = _enum_animation_l_frame_index.animation_death
        if animationMode == 1 then
            if armature._actionIndex == _enum_animation_l_frame_index.animation_vertical_floated or
                armature._actionIndex == _enum_animation_l_frame_index.animation_diagonal_floated or
                self.fitByKill == true 
                then
                actionIndex = _enum_animation_l_frame_index.animation_conversely_death
            end
        end
        self.fitByKill = false
        armature._actionIndex = actionIndex
        armature._nextAction = actionIndex
        armature:getAnimation():playWithIndex(actionIndex)

        armature._role._hp = 0
        showRoleHP(armature)

        self.is_killed = false
        self.is_deathed = true
        -- 取消倒地动作，角色直接进入到死亡动作
        -- armature._nextAction = _enum_animation_l_frame_index.animation_death
        -- -- test code
        -- -- state_machine.excute("fight_role_controller_notification_role_be_kill", 0, 0)

        -- 叠加角色死亡的光效
        if self ~= nil and self.parent ~= nil then
            local armatureEffect = self:createEffect(_battle_controller._dead_effice_id)
            armatureEffect._invoke = deleteEffectFile

            local size = self:getContentSize()
            -- armatureEffect:setPosition(cc.p(size.width / 2, 0))
            armatureEffect:setPosition(cc.p(self.parent:getPosition()))
            self.parent:getParent():addChild(armatureEffect)
        end

        -- 死亡更新武将UI的信息
        if nil ~= armature._self then
            armature._role._hp = 0
            state_machine.excute("battle_qte_head_update_draw", 0, {cell = armature._self._qte, status = "update"})
        end
        state_machine.excute("fight_role_controller_update_hp_progress", 0, nil)

        playEffectMusic(9706)
    end
end

function FightRole:executeAnimationConverselyToGetUp(armatureBack)
    local armature = armatureBack
    if self.is_killed == true then
        self.is_killed = false
        self.fight_over = false
        self.is_deathed = true
        armature._nextAction = _enum_animation_l_frame_index.animation_conversely_get_up
    end
end

function FightRole:executeAnimationDeath(armatureBack)
    local armature = armatureBack
    if self.is_deathed == true then
        -- self.is_deathed = false

        -- if self.roleCamp == 1 then
        --     self:removeFromParent(true)
        --     state_machine.excute("fight_role_controller_notification_role_death_over", 0, 0)
        -- end
        self.parent:setPosition(self.parent._swap_pos)

        if self.needChange then
            -- if self.roleCamp == 0 then
            --     -- if nil ~= _ED.battleData.__heros and #_ED.battleData.__heros > 0 then
            --         -- _ED.battleData.__heros["2"] = table.remove(_ED.battleData.__heros, 1, 1)
            --         self:initChange(_ED.battleData.__heros["2"])
            --         -- return false
            --     -- end
            -- elseif self.roleCamp == 1 then
            --     -- if nil ~= _ED.battleData._armys[1].__data and #_ED.battleData._armys[1].__data > 0 then
            --         -- _ED.battleData._armys[1]._data["2"] = table.remove(_ED.battleData._armys[1].__data, 1, 1)
            --         self:initChange(_ED.battleData._armys[1]._data["2"])
            --         -- return false
            --     -- end
            -- end
            self.armature:setVisible(false)
            if true ~= self.needChangeAdd then
                self.armature._role._sp = 0
                showRoleSP(self.armature)
                self.needChangeAdd = true
                fwin:addService({
                    callback = function ( params )
                        local _self = params
                        _self.needChangeAdd = false
                        if _self.roleCamp == 0 then
                            -- if nil ~= _ED.battleData.__heros and #_ED.battleData.__heros > 0 then
                                -- _ED.battleData.__heros["2"] = table.remove(_ED.battleData.__heros, 1, 1)
                                _self:initChange(_ED.battleData.__heros["2"])
                                -- return false
                            -- end
                        elseif _self.roleCamp == 1 then
                            -- if nil ~= _ED.battleData._armys[1].__data and #_ED.battleData._armys[1].__data > 0 then
                                -- _ED.battleData._armys[1]._data["2"] = table.remove(_ED.battleData._armys[1].__data, 1, 1)
                                _self:initChange(_ED.battleData._armys[1]._data["2"])
                                -- return false
                            -- end
                        end
                    end,
                    delay = 2.5,
                    params = self
                })
            end
        else
            self:removeFromParent(true)
        end

        -- test code
        if FightRole.__skeep_fighting == true or self.fight_over == true then
            state_machine.excute("fight_role_controller_notification_role_death_over", 0, 0)
        else
            state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
        end
    end
end

function FightRole:executeAnimationConverselyGetUp(armatureBack)
    local armature = armatureBack
    if self.is_killed == true then
        self.is_killed = false
        self.fight_over = false
        self.is_deathed = true
        armatureBack._actionIndex = _enum_animation_l_frame_index.animation_conversely_death
        armatureBack._nextAction = _enum_animation_l_frame_index.animation_conversely_death
        -- armature._nextAction = _enum_animation_l_frame_index.animation_standby
    end
end

-- 执行不需要调用攻击动作帧组的攻击
function FightRole:executeAnimationSkillAttacking(armatureBack)
    local armature = armatureBack
    armature._nextAction = _enum_animation_l_frame_index.animation_standby
    self:executeAttacking()    
end

function FightRole:executeAnimationPowerSkillAttacking(armatureBack)
    local armature = armatureBack
    armature._nextAction = _enum_animation_l_frame_index.animation_standby
    self:executeAttacking()  

    self.current_fight_data = self.current_fight_data_attacker
    self.armature._sed_action = self.armature._sed_action_attacker
    self.armature._sie_action = self.armature._sie_action_attacker
    if self.current_fight_data ~= nil and self.current_fight_data.__attData ~= nil then
        local attData               = self.current_fight_data.__attData
        local attackMovePos         = tonumber(attData.attackMovePos)                   -- 移动到的位置(0-8)
        if attackMovePos ~= 0 and attackMovePos ~= 1 and attackMovePos ~= 8 then
            self.changeActionToAttacking = true 
        end
    end 
end

function FightRole:executeAnimationFitSkillAttacking(armatureBack)
    local armature = armatureBack
    -- armature._nextAction = _enum_animation_l_frame_index.animation_standby
    -- self:executeAttacking()
    armature._nextAction = _enum_animation_l_frame_index.animation_fit_skill_attacking
end

function FightRole:executeAnimationWinAction(armatureBack)
    local armature = armatureBack
    -- local actionIndex = _enum_animation_l_frame_index.animation_win_on_action
    -- csb.animationChangeToAction(armature, actionIndex, actionIndex, false)
    armature._nextAction = _enum_animation_l_frame_index.animation_win_on_action
    self.celebrate_win = true
end

function FightRole:executeAnimationAttackJumpBack(armatureBack)
    local armature = armatureBack
    armature._nextAction = _enum_animation_l_frame_index.animation_standby
end

function FightRole:executeAnimationAttackNormalInTheSky(armatureBack)
    local armature = armatureBack
    armature._nextAction = _enum_animation_l_frame_index.animation_standby
    self:executeAttacking()
end

function FightRole:executeAnimationAttackSkillInTheSky(armatureBack)
    local armature = armatureBack
    armature._nextAction = _enum_animation_l_frame_index.animation_standby
    self:executeAttacking()
end

function FightRole:executeAnimationConverselyDeath(armatureBack)
    local armature = armatureBack
    -- armature._nextAction = _enum_animation_l_frame_index.animation_standby
    self:setVisible(false)
end

function FightRole.changeActionCallback(armatureBack)
    local armature = armatureBack
    local fightRole = armature._self
    if armature ~= nil then
        local actionIndex = armature._actionIndex
        -- if actionIndex ~= _enum_animation_l_frame_index.animation_dizziness then
        --     if fightRole.dizzinessEffect ~= nil then
        --         deleteEffectFile(fightRole.dizzinessEffect)
        --         fightRole.dizzinessEffect = nil
        --     end
        -- end
        if fightRole ~= nil and fightRole.is_deathed == true then
            if armatureBack._actionIndex == _enum_animation_l_frame_index.animation_conversely then
                armatureBack._actionIndex = _enum_animation_l_frame_index.animation_conversely_death
                armatureBack._nextAction = _enum_animation_l_frame_index.animation_conversely_death
            else
                armatureBack._actionIndex = _enum_animation_l_frame_index.animation_death
                armatureBack._nextAction = _enum_animation_l_frame_index.animation_death
            end
        end
        if fightRole == nil or fightRole.parent == nil then
            return
        end
        if actionIndex == _enum_animation_l_frame_index.animation_standby then -- 待机  原地待机动作，根据各自的武功流派摆出合适的POSE
            fightRole:executeAnimationStandby(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_move then -- 前移动 角色往前移动，具体角色具体对待，可以是走，跑，滑行
            fightRole:executeAnimationMove(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_move_back then -- 后移动 角色往后退，具体角色具体对待，可以面对敌人，也可以转身走
            fightRole:executeAnimationMoveBack(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_onrush then -- 前冲  角色往前冲准备发动攻击，具体角色具体对待，可以是走，跑，滑行
            fightRole:executeAnimationOnrush(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_skill_began then -- 技能释放    施放怒气技能前的准备动作
            fightRole:executeAnimationSkillBegan(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_normal_be_attaked then -- 原地被攻击   站立被击动作
            fightRole:executeAnimationNormalBeAttacked(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_normal_conversely then -- 原地击倒    由原地被攻击转换为倒地的过渡动作
            fightRole:executeAnimationNormalConversely(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_vertical_floated then -- 垂直浮空    被垂直向上击飞，头朝上飞起，到顶点旋转180度头朝下落下，倒地
        elseif actionIndex == _enum_animation_l_frame_index.animation_diagonal_floated then -- 斜线浮空    被斜45度击飞，跟上一个动作类似，倾斜45度，倒地
            fightRole:executeAnimationDiagonalFloated(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_landscape_blow_fly then -- 横向击飞    被横向击飞，慢慢变低，倒地
            fightRole:executeAnimationLandscapeBlowFly(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_miss_action then -- 闪避
        elseif actionIndex == _enum_animation_l_frame_index.animation_dizziness then -- 眩晕  原地晕点姿势，KOF等游戏一大把参考
        elseif actionIndex == _enum_animation_l_frame_index.animation_conversely then -- 倒地  倒地持续帧
            fightRole:executeAnimationConversely(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_death then -- 死亡消失    倒地动作渐变消失
            fightRole:executeAnimationDeath(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_conversely_get_up then -- 倒地起身    由倒地转化为待机的过渡动作
            fightRole:executeAnimationConverselyGetUp(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_skill_attacking then -- 普通技能攻击  攻击动作1，根据实际需求制作
            fightRole:executeAnimationSkillAttacking(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_power_skill_attacking then -- 怒气技能攻击  攻击动作2，根据实际需求制作
            fightRole:executeAnimationPowerSkillAttacking(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_fit_skill_attacking then -- 合击技能攻击  攻击动作3，根据实际需求制作
            fightRole:executeAnimationFitSkillAttacking(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_win_action then -- 胜利庆祝    胜利结算时的动作，摆个POSE
            fightRole:executeAnimationWinAction(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_attack_jump_back then
            fightRole:executeAnimationAttackJumpBack(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_attack_normal_in_the_sky then
            fightRole:executeAnimationAttackNormalInTheSky(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_attack_skill_in_the_sky then
            fightRole:executeAnimationAttackSkillInTheSky(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_conversely_death then
            fightRole:executeAnimationDeath(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_31_ji1 then -- 怒气技能攻击  攻击动作2，根据实际需求制作
            fightRole:executeAnimationPowerSkillAttacking(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_32_ji2 then -- 怒气技能攻击  攻击动作2，根据实际需求制作
            fightRole:executeAnimationPowerSkillAttacking(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_33_ji3 then -- 怒气技能攻击  攻击动作2，根据实际需求制作
            fightRole:executeAnimationPowerSkillAttacking(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_34_ji4 then -- 怒气技能攻击  攻击动作2，根据实际需求制作
            fightRole:executeAnimationPowerSkillAttacking(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_35_ji5 then -- 怒气技能攻击  攻击动作2，根据实际需求制作
            fightRole:executeAnimationPowerSkillAttacking(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_36_ji1 then
            fightRole:executeAnimationAttackSkillInTheSky(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_37_ji2 then
            fightRole:executeAnimationAttackSkillInTheSky(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_38_ji3 then
            fightRole:executeAnimationAttackSkillInTheSky(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_39_ji4 then
            fightRole:executeAnimationAttackSkillInTheSky(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_40_ji5 then
            fightRole:executeAnimationAttackSkillInTheSky(armatureBack)
        elseif actionIndex == _enum_animation_l_frame_index.animation_new_skill_13_jueji then -- 绝技攻击
            fightRole:executeAnimationPowerSkillAttacking(armatureBack)
        end
    end
end

function FightRole.onImageLoaded(texture)
    
end

function FightRole:onArmatureDataLoad(percent)
     -- -->___rint("onArmatureDataLoad percent:", percent)
end

function FightRole:onArmatureDataLoadEx(percent)
    if percent >= 1 then
        if self._load_over == false then
            self._load_over = true
            self:onInit()
        end
    end
end

function FightRole:onLoad()
    -- local effect_paths = {
    --     "sprite/spirte_0.ExportJson"
    -- }

    -- for i, v in pairs(effect_paths) do
    --     local fileName = v
    --     ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
    -- end

    -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, true)

    if animationMode == 1 then
    else
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_"..self._brole._head..".ExportJson")
    end
    
    self:onInit()

    self:registerOnNodeEvent(self)
    -- self:registerOnNoteUpdate(self, 0.5)
end

local function onFrameEventRole(bone,evt,originFrameIndex,currentFrameIndex)
    if FightRole.__skeep_fighting == true then
        return
    end
    local armature = bone:getArmature()
    local _self = armature._self
    if FightRole.__skeep_fighting == true or _self == nil or _self.current_fight_data == nil or FightRole.__fit_attacking == true then
        return
    end

    local frameEvents = zstring.split(evt, "_")
    if checkFrameEvent(frameEvents, "union") == true then -- 启动角色镜头聚焦
        -- print("start union effect!")
        if true == _self.roleAttacking then
            local effectIds = zstring.split(frameEvents[2], ",")
            for i, v in pairs(effectIds) do
                -- print("create union effect:", v) 
                local armatureEffect = _self:createEffect(v, "sprite/effect_")
                armatureEffect._self = _self
                armatureEffect._invoke = deleteEffectFile

                local map = armature -- _self:getParent()
                map:addChild(armatureEffect)

                -- -- local sx, sy = _self:getPosition()
                -- -- armatureEffect:setPosition(cc.p(sx, sy))
                -- if _self.roleCamp == 1 then
                --     armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
                -- end
            end
        end
    end
end

function FightRole:loadStartEffect( ... )
    for i=1,3 do
        -- 需要预加载光效格式是固定的，在形象id的基础上+10，+20，+30
        local effectId = zstring.tonumber(self._brole._head) + 10 * i
        local jsonFile = "sprite/effect_"..effectId..".json"
        if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
            local spine = sp.spine_effect(effectId, effectAnimations[1], false, nil, nil, nil, nil, nil, nil, "sprite/effect_")
            spine.animationNameList = effectAnimations
            spine:retain()
            table.insert(self._spineEffects, spine)
        end
    end
end

function FightRole:onInit()
    local wsize = self._FightRoleController:getContentSize()
    local size = self:getContentSize()
    local armature = nil

    -- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_53 then
    --     if self.roleCamp == 1 then
    --         self._brole._head = _ED._purify_choice_rold_pic_index or self._brole._head
    --     end
    -- end

    if animationMode == 1 then
        armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        armature.animationNameList = spineAnimations
        sp.initArmature(armature, true)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            armature:getAnimation():setFrameEventCallFunc(onFrameEventRole)

            -- if nil ~= _fight_evolution_scales and nil ~= self._info._evolution_level then
            if nil ~= self._info._scale then
                -- print("进化等级", self._info._scale)
                self:setScale(self._info._scale)
            end
        end
        self:loadStartEffect()
    else
        armature = ccs.Armature:create("spirte_" .. self._brole._head)
        self:addChild(armature)
    end

    -- ui
    armature._self = self
    armature._camp = self.roleCamp

    -- self
    self.armature = armature

    local sacleType = 1
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        sacleType = 0
    end

    local flag = -1
    if self.roleCamp == sacleType then
        armature:setScaleX(-1)
        flag = 1
        -- self:setPositionX(wsize.width - self.parent._swap_pos.x + size.width)
    else
        -- self:setPositionX(flag * (self.parent._swap_pos.x + size.width))
    end
    if self.needChange then

    else
        self.parent = nil
    end
    -- self:setPositionX(flag * (500))

    armature:setPositionX(size.width / 2)
    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)

    if self.fightIndex == 1 or true then
        armature._actionIndex = _enum_animation_l_frame_index.animation_standby
        armature._nextAction = _enum_animation_l_frame_index.animation_standby
    else
        armature._actionIndex = _enum_animation_l_frame_index.animation_onrush
        armature._nextAction = _enum_animation_l_frame_index.animation_onrush
    end
    armature:getAnimation():playWithIndex(armature._actionIndex)
    armature._invoke = self.changeActionCallback

    ---------------------------------------------------------------------------
    -- hero information widget (show hp , sp , name , type) 
    ---------------------------------------------------------------------------
    armature._pos = self._info._pos
    armature._role = {}
    armature._role._id = self._info._id
    armature._role._mouldId = self._info._mouldId
    armature._role._type = self._info._type
    armature._role._name = self._info._name
    armature._role._hp = self._info._hp
    armature._role._sp = self._info._sp
    armature._role._quality = self._info._quality
    armature._brole = self._info

    self.attackerHp = self.armature._role._hp
    self.attackerSp = self.armature._role._sp

    app.load("client.battle.fight.HeroInfoUI")
    
    -- 玩家血条
    local heroInfoWidget = HeroInfoUI:createCell()
    heroInfoWidget:init(armature)
    local m_isShowMasterHp = cc.UserDefault:getInstance():getStringForKey("m_isShowMasterHp", "")
    -- 0 不显示 1显示
    if m_isShowMasterHp == nil or m_isShowMasterHp == "" or m_isShowMasterHp == "0" then
        heroInfoWidget:setVisible(false)
    else
        heroInfoWidget:setVisible(true)
    end
    
    self:addChild(heroInfoWidget, 2000000-1)
    
    heroInfoWidget:setAnchorPoint(cc.p(0.5, 0.5))
    heroInfoWidget:setPosition(cc.p(size.width/2, size.height + heroInfoWidget:getContentSize().height*3/2))
    
    armature._heroInfoWidget = heroInfoWidget
    armature._heroInfoWidget:showRoleName()
    armature._heroInfoWidget:showRoleType()
    armature._heroInfoWidget:showRoleSP()
    armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
    ---------------------------------------------------------------------------
    
    -- self:addChild(armature)
    
    if self._isAnimal == true then
        heroInfoWidget:setVisible(false)
        self.armature:setVisible(false)
    end

    local function enterIntoMoveOverFuncN(_self)
        if FightRole.__skeep_fighting == true or _self.fight_over == true then
            return
        end
        local armature = _self.armature
        actionIndex = _enum_animation_l_frame_index.animation_standby
        csb.animationChangeToAction(armature, actionIndex, actionIndex, false)

        -- state_machine.excute("fight_role_move_event", 0, _self)
        
        state_machine.excute("fight_role_controller_role_enter_into_over", 0, 0)
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        -- 在FightRoleControllerClass中构建每次切场的入场
        if _mission_stop_fight_change_scene_action == 1 and true ~= self.needChange then
            local array = {}
            if self.fightIndex == 1 or true then
                self:setPosition(cc.p(0, 0))
            else
                table.insert(array, cc.MoveTo:create(1.0 * __fight_recorder_action_time_speed, cc.p(0, 0)))
            end
            table.insert(array, cc.CallFunc:create(enterIntoMoveOverFuncN))
            local seq = cc.Sequence:create(array)

            self:runAction(seq)
        end
    else
        local array = {}
        if self.fightIndex == 1 or true then
            self:setPosition(cc.p(0, 0))
        else
            table.insert(array, cc.MoveTo:create(1.0 * __fight_recorder_action_time_speed, cc.p(0, 0)))
        end
        table.insert(array, cc.CallFunc:create(enterIntoMoveOverFuncN))
        local seq = cc.Sequence:create(array)

        self:runAction(seq)
    end

    local shadow = cc.Sprite:create("sprite/spirte_2442.png") -- cc.LayerGradient:create(cc.c4b(0,0,255,255), cc.c4b(0,255,0,255), cc.p(0.9, 0.9))
    shadow:setTextureRect(cc.rect(0, 0, 193, 89))
    shadow:setAnchorPoint(cc.p(0.5, 0.5))
    shadow:setPosition(cc.p(size.width / 2, 0))
    shadow:setOpacity(100)
    self:addChild(shadow, -1)
    self.shadow = shadow
end

function FightRole:onInit_0()
    local armature = ccs.Armature:create("spirte_" .. self._brole._head)
    local flag = -1
    if self.roleCamp == 1 then
        armature:setScaleX(-1)
        flag = 1
    end
    
    self:setPositionX(flag * (500))

    local size = self:getContentSize()
    armature:setPositionX(size.width / 2)
    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)

    armature._actionIndex = _enum_animation_l_frame_index.animation_onrush
    armature._nextAction = _enum_animation_l_frame_index.animation_onrush
    armature:getAnimation():playWithIndex(armature._actionIndex)
    armature._invoke = self.changeActionCallback

    -- ui
    armature._self = self
    armature._camp = self.roleCamp

    -- self
    self.armature = armature
    
    ---------------------------------------------------------------------------
    -- hero information widget (show hp , sp , name , type) 
    ---------------------------------------------------------------------------
    armature._pos = self._info._pos
    armature._role = {}
    armature._role._id = self._info._id
    armature._role._mouldId = self._info._mouldId
    armature._role._type = self._info._type
    armature._role._name = self._info._name
    armature._role._hp = self._info._hp
    armature._role._sp = self._info._sp
    armature._role._quality = self._info._quality
    armature._brole = self._info

    app.load("client.battle.fight.HeroInfoUI")
    
    local heroInfoWidget = HeroInfoUI:createCell()
    heroInfoWidget:init(armature)
    
    self:addChild(heroInfoWidget, 2000000-1)
    
    heroInfoWidget:setAnchorPoint(cc.p(0.5, 0.5))
    heroInfoWidget:setPosition(cc.p(size.width/2, size.height + heroInfoWidget:getContentSize().height*3/2))
    
    armature._heroInfoWidget = heroInfoWidget
    armature._heroInfoWidget:showRoleName()
    armature._heroInfoWidget:showRoleType()
    armature._heroInfoWidget:showRoleSP()
    armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
    ---------------------------------------------------------------------------
    
    self:addChild(armature)



    local function enterIntoMoveOverFuncN(_self)
        if FightRole.__skeep_fighting == true or _self.fight_over == true then
            return
        end
        local armature = _self.armature
        -- armature._nextAction = _enum_animation_l_frame_index.animation_standby
        -- 
        armature._invoke = nil
        armature._actionIndex = _enum_animation_l_frame_index.animation_standby
        armature._nextAction = _enum_animation_l_frame_index.animation_standby
        armature:getAnimation():playWithIndex(armature._actionIndex)
        armature._invoke = _self.changeActionCallback

        -- state_machine.excute("fight_role_check_move_event", 0, _self)
        
        state_machine.excute("fight_role_controller_role_enter_into_over", 0, 0)
    end

    local array = {}
    table.insert(array, cc.MoveTo:create(1.0 * __fight_recorder_action_time_speed, cc.p(0, 0)))
    table.insert(array, cc.CallFunc:create(enterIntoMoveOverFuncN))
    local seq = cc.Sequence:create(array)

    self:runAction(seq)
end

function FightRole:changeToNextAttackRole()
    -- self:stopAllActionsByTag(FightRole.__delayFightTag)
    self:attackBeginCheckBuff()
    -- print("changeToNextAttackRole ", self.move_state, self.roleCamp, self._info._pos)
    -- print("changeToNextAttackRole self.run_fight_listener = ", self.run_fight_listener)
    if self.run_fight_listener == true then
        self.isWakeUpComkillProgress = false
        self.openAttackListener = true
        -- self:cleanBuffState()

        -- print("changeToNextAttackRole self.run_fight_listener = ", self.run_fight_listener, " self.openAttackListener = ", self.openAttackListener, " self.fight_cacher_pool = ", self.fight_cacher_pool, " #self.fight_cacher_pool = ", #self.fight_cacher_pool)

        if self.fight_cacher_pool == nil or #self.fight_cacher_pool == 0 then
            -- state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self)
            -- state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)

            if nil == self._FightRoleController then
                return
            end

            if self._execute_round_count == self._FightRoleController.current_fight_round then
                return
            end
            self._execute_round_count = self._FightRoleController.current_fight_round

            local service = {
                callback = function ( params, service )
                    local _self = params
                    service = service or params.service
                    if nil ~= service then
                        if -1 < FightRole._last_attack_camp
                            and FightRole._last_attack_camp ~= _self.roleCamp
                            and nil ~= _self.roleCamp
                            -- and (true == FightRole.__g_role_attacking or true == FightRole.__g_lock_sp_attack)
                            and 0 < FightRole.__g_lock_camp_attack
                            then
                            state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "" .. _self.roleCamp)
                            service.delay = 1
                            fwin:addService(service)
                            return 
                        end
                    end
                    
                    local gbc0 = false
                    local gbc1 = false
                    if nil ~= _ED._fightModule then
                        gbc0 = _ED._fightModule:checkAttackSell(true)
                        gbc1 = _ED._fightModule:checkByAttackSell()
                    end

                    if nil ~= _self._FightRoleController and _self._FightRoleController.isPvEType ~= true then
                        if FightRole._current_attack_camp > -1 and FightRole._current_attack_camp ~= _self.roleCamp then
                            _self._FightRoleController:cleanBuffStateWithType(_self.roleCamp, "12")
                            _self._FightRoleController:cleanBuffStateWithType(_self.roleCamp, "106")
                            _self._FightRoleController:cleanBuffState(nil, _self.roleCamp)
                        end
                        FightRole._current_attack_camp = _self.roleCamp
                        params._FightRoleController.auto_queue = {}
                        params._FightRoleController.auto_wait_queue = {}
                    end

                    if (false == gbc0 and false == gbc1) or (params.roleCamp == 0 and gbc0 == true) or (params.roleCamp == 1 and gbc0 == true) then
                        state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, params)
                        state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                    else
                        state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, 0)
                        state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                        state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)

                        state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, params)
                        state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                    end

                    -- state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, params)
                    -- state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                    
                    -- state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, 0)
                    -- state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                    -- state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                end,
                delay = 0.01,
                params = self
            }
            fwin:addService(service)
        end
    else
        if self.fight_cacher_pool == nil or #self.fight_cacher_pool == 0 then
            if self._atkBuffDeath == true then
                self:checkAttackerBuffDeath()
            else
                -- -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                -- -- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                -- -- or __lua_project_id == __lua_project_l_naruto 
                -- --     then
                -- -- else
                --     state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self)
                --     state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                -- -- end

                if nil == self._FightRoleController then
                    return
                end

                -- 修复bug505，切换到下一个角色的时候在这里return了 
                -- if self._execute_round_count == self._FightRoleController.current_fight_round then
                --     print("日志 FightRole:changeToNextAttackRole, 重复进入，return")
                --     return
                -- end

                self._execute_round_count = self._FightRoleController.current_fight_round

                local service = {
                    callback = function ( params, service )
                        local _self = params
                        service = service or params.service
                        if nil ~= service then
                            if -1 < FightRole._last_attack_camp
                                and FightRole._last_attack_camp ~= _self.roleCamp
                                and nil ~= _self.roleCamp
                                -- and (true == FightRole.__g_role_attacking or true == FightRole.__g_lock_sp_attack)
                                and 0 < FightRole.__g_lock_camp_attack
                                then
                                state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "" .. _self.roleCamp)
                                service.delay = 1
                                fwin:addService(service)
                                return 
                            end
                        end
                        local gbc0 = false
                        local gbc1 = false
                        if nil ~= _ED._fightModule then
                            gbc0 = _ED._fightModule:checkAttackSell(true)
                            gbc1 = _ED._fightModule:checkByAttackSell()
                        end

                        if nil ~= _self._FightRoleController and _self._FightRoleController.isPvEType ~= true then
                            if FightRole._current_attack_camp > -1 and FightRole._current_attack_camp ~= _self.roleCamp then
                                _self._FightRoleController:cleanBuffStateWithType(_self.roleCamp, "12")
                                _self._FightRoleController:cleanBuffStateWithType(_self.roleCamp, "106")
                                _self._FightRoleController:cleanBuffState(nil, _self.roleCamp)
                            end
                            FightRole._current_attack_camp = _self.roleCamp
                            params._FightRoleController.auto_queue = {}
                            params._FightRoleController.auto_wait_queue = {}
                        end

                        if (nil == _ED._fightModule) or (false == gbc0 and false == gbc1) or (params.roleCamp == 0 and gbc0 == true) or (params.roleCamp == 1 and gbc0 == true) then
                            state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, params)
                            state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                        else
                            state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, 0)
                            state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                            state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)

                            state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, params)
                            state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                        end

                        -- state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, params)
                        -- state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                        
                        -- state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, 0)
                        -- state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                        -- state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                    end,
                    delay = 0.01,
                    params = self
                }
                fwin:addService(service)
            end
        else
            -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            --     or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            --     or __lua_project_id == __lua_project_l_naruto 
            --     then
            -- else
                state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self)
                state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
            -- end
        end
    end
end

function FightRole:attackBeginCheckBuff( ... )
    if self._atkBuff ~= nil and table.getn(self._atkBuff) > 0 then
        for k,v in pairs(self._atkBuff) do
            local drawString = ""
            local numberFilePath = ""
            if v.nType == "6" 
                -- or v.nType == "9" 
                then
                drawString = "-"..v.nValue
                numberFilePath = "images/ui/number/xue.png"
                if tonumber(self.roleCamp) == 1 then
                    BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(v.nValue)
                    state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
                end
            elseif v.nType == "31" then
                drawString = "+"..v.nValue
                numberFilePath = "images/ui/number/jiaxue.png"
            end
            if v.nType == "6" 
                -- or v.nType == "9" 
                or v.nType == "31" 
                then
                self.armature._role._hp = self.armature._role._hp + tonumber(drawString)
                self.armature._role._lhp = v.aliveHP
                showRoleHP(self.armature)
                self:showChangeHpNumberAni(numberFilePath, drawString, false)
                -- state_machine.excute("fight_role_controller_update_hp_progress", 0, nil)
            end
        end
        self._atkBuff = {}
    end
end

function FightRole:updateRevivedInfo( def )
    if -- def 
        nil ~= self.armature._role._rlhp
        and nil ~= self.armature._role._rlsp
        then
        -- self.armature._role._hp = tonumber(def.aliveHP) or 0
        -- self.armature._role._sp = tonumber(def.aliveSP) or 0
        self.armature._role._hp = tonumber(self.armature._role._rlhp) or 0
        self.armature._role._sp = tonumber(self.armature._role._rlsp) or 0
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "update"})
        if self.armature._heroInfoWidget ~= nil then self.armature._heroInfoWidget:controlLife(false, 9) end showRoleSP(self.armature, def) -- Fury 3-oct: la muerte del 79 deja controlLife(true, 9) y solo requestNextFight lo soltaba: la barra no volvia
        showRoleHP(self.armature, def)
        self.armature._role._rlhp = nil
        self.armature._role._rlsp = nil
    end
end

--还原角色spine模型动画的颜色和速度
function FightRole:resetArmatureColorAndSpeed()
    self.armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
    self.armature:getAnimation():getAnimationData():setColor(cc.c3b(255, 255, 255))
end

function FightRole:cleanBuffStateWithType( nType )
    self.buffList[nType] = nil
    local revivedDef = nil
    local armatureEffect = self.buffEffectList[nType]
    if armatureEffect ~= nil then
        revivedDef = armatureEffect._def
        armatureEffect._LastsCountTurns = 0
        deleteEffectFile(armatureEffect)
        self.buffEffectList[nType] = nil

        if nType == "79" then
            state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizziness"})
        end

    end

    if nType == "79" then -- 复活
        if not self._isAnimal then
            self.armature:setVisible(true)
            self:updateRevivedInfo(revivedDef)
        end
    elseif nType == "5" then
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizzy"})
    elseif nType == "8" then
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unsilence"})
    elseif nType == "81" then
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unexile"})
    elseif nType == "84" or nType == "129" then
        self:resetArmatureColorAndSpeed()
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unstone"})
    end
end


local ___excludeIds = {
    5, --   眩晕（无法行动）    
    7, --   麻痹（无法行动）    
    8, --   沉默（无法怒气攻击）
    9, --   燃烧  
    12, --  无敌  
    17, --  冰冻（无法行动）    
    21, --  增加攻击    
    22, --  降低攻击   
    23, --  增加防御 
    27, --  增加暴击    
    36, --  降低治疗效果(对应公式63）  
    40, --  增加吸血率   
    42, --  小技能触发概率 
    43, --  增加破格挡率  
    45, --  增加伤害减免  
    47, --  降低小技能触发概率   
    48, --  降低暴击伤害  
    49, --  减少造成的必杀伤害   
    50, --  嘲讽  
    51, --  降低伤害加成  
    52, --  增加伤害加成  
    53, --  增加控制率   
    54, --  增加造成的必杀伤害   
    55, --  减少必杀伤害率 
    56, --  降低怒气回复速度    
    57, --  提高怒气回复速度    
    58, --  增加暴击伤害  
    60, --  增加暴击强度  
    62, --  增加必杀伤害率 
    63, --  增加格挡率
    64, --  增加数码兽类型克制伤害加成   
    66, --  降低暴击率   
    80, --  小技能伤害提升（绘制类型）
    81, --  放逐效果
    82, --  虚弱效果
    83, --  魅惑
    84, --  石化
    88, --  魅惑2
    92, --  真实伤害
    96, --  弱感电
    97, --  强感电
    106, -- 无敌效果（虚化）
    113, -- 庇护效果
    116, -- 伤害吸收效果
    120, -- 睡眠效果（同麻痹）
    121, -- 伤害吸收效果2
    122, -- 庇护效果2
    126, -- 计数器增加
    127, -- 计数器减少
    128, -- 计数器清空
    129, -- 石化2(停滞)
    131, -- 生命链接
    132, -- 计数器增加2
    133, -- 计数器减少2
    134, -- 计数器清空2
    138, -- 伤害吸收效果3
    139, -- 生命链接2（守护之心）
    140, -- 破除庇护效果
    141, -- 破除伤害吸收效果
}

local ___exclude = {}

for i, v in pairs(___excludeIds) do
    ___exclude["" .. v] = v
end

function FightRole:clearBuffState()
    for k,v in pairs(self.buffList) do
        if nil ~= ___exclude[k] then
            local count = tonumber(v) -- - 1
            if k == "5" then
                if count <= 0 and self.dizzinessEffect ~= nil then
                    self.dizzinessEffect._LastsCountTurns = 0
                    deleteEffectFile(self.dizzinessEffect)
                    self.dizzinessEffect = nil
                    self.move_state = self._move_state_enum._MOVE_STATE_WAIT
                end
                self.buffList[k] = count
            elseif k == "6" then
                if count <= 0 and self._poisoning_effice ~= nil then
                    self._poisoning_effice._LastsCountTurns = 0
                    deleteEffectFile(self._poisoning_effice)
                    self._poisoning_effice = nil
                end
                self.buffList[k] = count
            elseif k == "9" then
                -- if count <= 0 and self._burn_effice ~= nil then
                --     self._burn_effice._LastsCountTurns = 0
                --     deleteEffectFile(self._burn_effice)
                --     self._burn_effice = nil
                -- end
                -- self.buffList[k] = count

                count = tonumber(v)
            elseif k == "12" or k == "23" or k == "26" or k == "106" then
                if count <= 0 and self._invincible_effice ~= nil then
                    self._invincible_effice._LastsCountTurns = 0
                    deleteEffectFile(self._invincible_effice)
                    self._invincible_effice = nil
                end
                self.buffList[k] = count
            end

            local armatureEffect = self.buffEffectList[k]
            -- if FightRole.__priority_camp == self.roleCamp or true then
                local bClean = false
                local skillCategory = tonumber(k)
                -- if skillCategory == 21
                --     or skillCategory == 22
                --     or skillCategory == 27
                --     or skillCategory == 33
                --     or skillCategory == 36
                --     or skillCategory == 43
                --     or skillCategory == 48
                --     or skillCategory == 51
                --     or skillCategory == 52
                --     or skillCategory == 52
                --     or skillCategory == 58
                --     or skillCategory == 60
                --     or skillCategory == 61
                --     or skillCategory == 64
                --     or skillCategory == 66
                --     then
                --     -- 沉默、眩晕、冰冻、麻痹这些控制类的光效多了一个回合，需要进行特殊处理
                --     -- 5眩晕，7麻痹，8沉默，17冰冻
                --     if FightRole.__priority_camp ~= self.roleCamp
                --         -- and (k == "5" 
                --         -- or k == "7" 
                --         -- or k == "8" 
                --         -- or k == "17")
                --         then
                --         if count <= 1 then
                --             bClean = true
                --         end
                --     else
                --         if count < 1 then
                --             bClean = true
                --         end
                --     end
                -- else
                --     -- 沉默、眩晕、冰冻、麻痹这些控制类的光效多了一个回合，需要进行特殊处理
                --     -- 5眩晕，7麻痹，8沉默，17冰冻
                --     if FightRole.__priority_camp ~= self.roleCamp
                --         -- and (k == "5" 
                --         -- or k == "7" 
                --         -- or k == "8" 
                --         -- or k == "17")
                --         then
                --         if count <= 0 then
                --             bClean = true
                --         end
                --     else
                --         if count < 0 then
                --             bClean = true
                --         end
                --     end
                -- end

                -- if FightRole.__priority_camp == self.roleCamp
                --     then
                    if count <= 0 then
                        bClean = true
                    end
                -- else
                --     if count < 0 then
                --         bClean = true
                --     end
                -- end

                -- print("-----clear->buff---:", self.roleCamp, self._info._pos, k, count, bClean, armatureEffect)
                if true == bClean then
                    local revivedDef = nil
                    if armatureEffect ~= nil then
                        revivedDef = armatureEffect._def
                        armatureEffect._LastsCountTurns = 0
                        deleteEffectFile(armatureEffect)
                        self.buffEffectList[k] = nil

                        if k == "79" then
                            state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizziness"})
                        end

                    end
                    if k == "79" then
                        -- 复活
                        if not self._isAnimal then
                            self.armature:setVisible(true)
                            self:updateRevivedInfo(revivedDef)
                        end
                    elseif k == "5" then
                        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizzy"})
                    elseif k == "8" then
                        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unsilence"})
                    elseif k == "81" then
                        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unexile"})
                    elseif k == "84" or k == "129" then
                        self:resetArmatureColorAndSpeed()
                        state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unstone"})
                    end
                    count = nil
                end
            -- else
            --     if count <= 0 then
            --         if armatureEffect ~= nil then
            --             armatureEffect._LastsCountTurns = 0
            --             deleteEffectFile(armatureEffect)
            --             self.buffEffectList[k] = nil
            --         end
            --     end
            -- end
            self.buffList[k] = count
            -- print("clean buff : ", self.roleCamp, self._info._pos, k, v, count)
        end
    end
end

function FightRole:cleanBuffState( isDeathClean, exclude )
    if isDeathClean then
        for i, v in pairs(self.buffEffectList) do
            local revivedDef = nil
            local armatureEffect = v
            if armatureEffect ~= nil then
                revivedDef = armatureEffect._def
                armatureEffect._LastsCountTurns = 0
                deleteEffectFile(armatureEffect)
                self.buffEffectList[i] = nil

                if i == "79" then
                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizziness"})
                end
            end

            if i == "79" then
                -- 复活
                if not self._isAnimal then
                    self.armature:setVisible(true)
                    self:updateRevivedInfo(revivedDef)
                end
            elseif i == "5" then
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizzy"})
            elseif i == "8" then
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unsilence"})
            elseif i == "81" then
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unexile"})
            elseif i == "84" or i == "129" then
                self:resetArmatureColorAndSpeed()
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unstone"})
            end
        end

        -- 死亡清除计数器的光效
        for k, armatureEffect in pairs(self.counterEffectMap) do
            if armatureEffect ~= nil then
                deleteEffectFile(armatureEffect)
                self.counterEffectMap[k] = nil
            end
        end
    else
        for k,v in pairs(self.buffList) do
            local count = tonumber(v) - 1
            if isDeathClean == true then
                count = 0
            end

            exclude = ___exclude or exclude
            if nil == exclude[k] then
                
            else
                if k == "5" then
                    if count <= 0 and self.dizzinessEffect ~= nil then
                        self.dizzinessEffect._LastsCountTurns = 0
                        deleteEffectFile(self.dizzinessEffect)
                        self.dizzinessEffect = nil
                        self.move_state = self._move_state_enum._MOVE_STATE_WAIT
                    end
                    self.buffList[k] = count
                elseif k == "6" then
                    if count <= 0 and self._poisoning_effice ~= nil then
                        self._poisoning_effice._LastsCountTurns = 0
                        deleteEffectFile(self._poisoning_effice)
                        self._poisoning_effice = nil
                    end
                    self.buffList[k] = count
                elseif k == "9" then
                    -- if count <= 0 and self._burn_effice ~= nil then
                    --     self._burn_effice._LastsCountTurns = 0
                    --     deleteEffectFile(self._burn_effice)
                    --     self._burn_effice = nil
                    -- end
                    -- self.buffList[k] = count

                    count = tonumber(v)
                elseif k == "12" or k == "23" or k == "26" or k == "106" then
                    if count <= 0 and self._invincible_effice ~= nil then
                        self._invincible_effice._LastsCountTurns = 0
                        deleteEffectFile(self._invincible_effice)
                        self._invincible_effice = nil
                    end
                    self.buffList[k] = count
                end

                local armatureEffect = self.buffEffectList[k]
                -- if FightRole.__priority_camp == self.roleCamp or true then
                    local bClean = false
                    local skillCategory = tonumber(k)
                    -- if skillCategory == 21
                    --     or skillCategory == 22
                    --     or skillCategory == 27
                    --     or skillCategory == 33
                    --     or skillCategory == 36
                    --     or skillCategory == 43
                    --     or skillCategory == 48
                    --     or skillCategory == 51
                    --     or skillCategory == 52
                    --     or skillCategory == 52
                    --     or skillCategory == 58
                    --     or skillCategory == 60
                    --     or skillCategory == 61
                    --     or skillCategory == 64
                    --     or skillCategory == 66
                    --     then
                    --     -- 沉默、眩晕、冰冻、麻痹这些控制类的光效多了一个回合，需要进行特殊处理
                    --     -- 5眩晕，7麻痹，8沉默，17冰冻
                    --     if FightRole.__priority_camp ~= self.roleCamp
                    --         -- and (k == "5" 
                    --         -- or k == "7" 
                    --         -- or k == "8" 
                    --         -- or k == "17")
                    --         then
                    --         if count <= 1 then
                    --             bClean = true
                    --         end
                    --     else
                    --         if count < 1 then
                    --             bClean = true
                    --         end
                    --     end
                    -- else
                    --     -- 沉默、眩晕、冰冻、麻痹这些控制类的光效多了一个回合，需要进行特殊处理
                    --     -- 5眩晕，7麻痹，8沉默，17冰冻
                    --     if FightRole.__priority_camp ~= self.roleCamp
                    --         -- and (k == "5" 
                    --         -- or k == "7" 
                    --         -- or k == "8" 
                    --         -- or k == "17")
                    --         then
                    --         if count <= 0 then
                    --             bClean = true
                    --         end
                    --     else
                    --         if count < 0 then
                    --             bClean = true
                    --         end
                    --     end
                    -- end

                    -- if FightRole.__priority_camp == self.roleCamp
                    --     then
                        if count <= 0 then
                            bClean = true
                        end
                    -- else
                        -- if count < 0 then
                        --     bClean = true
                        -- end
                    -- end

                    -- print("-----clean->buff---:", self.roleCamp, self._info._pos, k, count, bClean, armatureEffect)
                    if true == bClean then
                        local revivedDef = nil
                        if armatureEffect ~= nil then
                            revivedDef = armatureEffect._def
                            armatureEffect._LastsCountTurns = 0
                            deleteEffectFile(armatureEffect)
                            self.buffEffectList[k] = nil

                            if k == "79" then
                                state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizziness"})
                            end
                        end
                        if k == "79" then
                            -- 复活
                            if not self._isAnimal then
                                self.armature:setVisible(true)
                                self:updateRevivedInfo(revivedDef)
                            end
                        elseif k == "5" then
                            state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "undizzy"})
                        elseif k == "8" then
                            state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unsilence"})
                        elseif k == "81" then
                            state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unexile"})
                        elseif k == "84" or k == "129" then
                            self:resetArmatureColorAndSpeed()
                            state_machine.excute("battle_qte_head_update_draw", 0, {cell = self._qte, status = "unstone"})
                        end
                        count = nil
                    end
                -- else
                --     if count <= 0 then
                --         if armatureEffect ~= nil then
                --             armatureEffect._LastsCountTurns = 0
                --             deleteEffectFile(armatureEffect)
                --             self.buffEffectList[k] = nil
                --         end
                --     end
                -- end
            end
            self.buffList[k] = count
            -- print("clean buff : ", self.roleCamp, self._info._pos, k, v, count)
        end

        --  for i, v in pairs(self.buffEffectList) do
        --     if nil == self.buffList[i] or tonumber(self.buffList[i]) <= 0 then
        --         local armatureEffect = v
        --         if armatureEffect ~= nil then
        --             armatureEffect._LastsCountTurns = 0
        --             deleteEffectFile(armatureEffect)
        --             self.buffEffectList[i] = nil
        --         end
        --     end
        -- end
    end
end

local attack_count = 0
function FightRole:attackListener()
    -- if attack_count > -1 then
    --     return
    -- end

    -- if self.roleCamp == 1 then
    --     print("-----------", FightRole.__skeep_fighting, self.fight_over, FightRole.__fit_attacking, self.isStopFight, self.run_fight_listener, self.openAttackListener, self.waitNextSkillInfluence, self.move_state, #self.fight_cacher_pool, self.roleCamp, self._info._pos)
    -- end
    if FightRole.__skeep_fighting == true 
        or self.fight_over == true 
        or FightRole.__fit_attacking == true 
        or FightRole.__g_role_attacking == true
        or self.needChange == true
        then
        return false
    end

    if self.isStopFight == true then
        return
    end
    
    if self.fly_state ~= 0 then
        return false
    end

    if -1 < FightRole._last_attack_camp
        and FightRole._last_attack_camp ~= self.roleCamp
        -- and (true == FightRole.__g_role_attacking or true == FightRole.__g_lock_sp_attack)
        and 0 < FightRole.__g_lock_camp_attack
        then
        return 
    end
    
    -- print("----", self.move_state, self.roleCamp, self._info._pos)
    -- print("attackListener self.run_fight_listener = ", self.run_fight_listener, " self.openAttackListener = ", self.openAttackListener, " self.fight_cacher_pool = ", self.fight_cacher_pool, " #self.fight_cacher_pool = ", #self.fight_cacher_pool)

    if self.run_fight_listener == true then
        if self.fight_cacher_pool == nil or #self.fight_cacher_pool == 0 then
            self.openAttackListener = false
            self.run_fight_listener = false

            -- print("设置 run_fight_listener = ", self.run_fight_listener)

            if self.parent ~= nil and self:getParent() ~= nil and self.moveBackArena ~= true then
                self.parent:stopAllActionsByTag(2)
                state_machine.excute("fight_role_check_move_event", 0, self)
                -- state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self)
                state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
            end
        else
            if self.openAttackListener == false then
                return
            end
            -- print("self.waitNextSkillInfluence = ", self.waitNextSkillInfluence)
            if self.waitNextSkillInfluence == true then
                self:checkNextSkillInfluence()
                return false
            end
            -- print("----", self.move_state, self.roleCamp, self._info._pos)
            local isCanAttackState = true
            if self.move_state == self._move_state_enum._MOVE_STATE_TARGET or 
                self.move_state == self._move_state_enum._MOVE_STATE_STILL or 
                self.move_state == self._move_state_enum._MOVE_STATE_BACK_SCREEN or 
                self.move_state == self._move_state_enum._MOVE_STATE_MOVE_CAMP then
                isCanAttackState = false
            end

            -- -- 数码项目取消追击的效果
            -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            --     if self.move_state ~= self._move_state_enum._MOVE_STATE_VACANT then
            --         isCanAttackState = false
            --     end
            -- end

            -- print("isCanAttackState = ", isCanAttackState)
            if isCanAttackState == false then
                -- print("===5044", self.roleCamp, self._info._pos, self.move_state)
                return false
            end

            -- print("self.current_fight_data_attacker = ", self.current_fight_data_attacker)
            if nil ~= self.current_fight_data_attacker then
                return false
            end

            -- self:checkNextFight()
            -- print("self.fight_cacher_pool[1]", self.roleCamp, self._info._pos, self.fight_cacher_pool[1], self.roleAttacking, self.roleByAttacking )
            if (FightRole._current_attack_camp ~= self.roleCamp) and (self.openAttackListener == false or self.waitJumpOver == true or self.roleAttacking == true or self.roleByAttacking == true or self.waitByAttackOver == true or self.drawByAttackEffectCount > 0 or self.repelAndFlyEffectCount > 0) then
                -- print("===5051", self.roleCamp, self._info._pos, self.roleAttacking, self.roleByAttacking, self.waitByAttackOver, self.drawByAttackEffectCount, self.repelAndFlyEffectCount)
            else
                if self.current_fight_data == nil or true then
                    local currentFightData = self.fight_cacher_pool[1]
                    -- print("attackListener currentFightData.__fitAttacker = ", currentFightData.__fitAttacker)
                    if currentFightData.__fitAttacker ~= nil then
                        for i, v in pairs(self._FightRoleController._hero_formation ) do
                            if v ~= nil and v.parent ~= nil then
                                if v.roleAttacking == true or v.roleByAttacking == true then
                                    if v.roleCamp ~= self.roleCamp then
                                        return;
                                    end
                                end
                            end
                        end
                        for i, v in pairs(self._FightRoleController._master_formation ) do
                            if v ~= nil and v.parent ~= nil then
                               if v.roleAttacking == true or v.roleByAttacking == true then
                                    if v.roleCamp ~= self.roleCamp then
                                        return;
                                    end
                                end
                            end
                        end

                        self.current_fight_data = currentFightData

                        self:executeAttackLogic()
                    else
                        -- print("currentFightData.__state = ", currentFightData.__state, " currentFightData.__byFitAttacker = ", currentFightData.__byFitAttacker, " self.fitAttacking = ", self.fitAttacking)
                        if currentFightData.__state ~= 0 or (currentFightData.__byFitAttacker ~= nil and self.fitAttacking ~= true) then
                            -- print("return 1")
                            return false
                        end
                        local defenderList = currentFightData.__defenderList
                        -- print("defenderList = ", defenderList," currentFightData.__fitAttacker = ", currentFightData.__fitAttacker)
                        if defenderList == nil and currentFightData.__fitAttacker == nil then
                            -- print("return 3")
                            -- debug.print_r(currentFightData)
                            -- table.remove(self.fight_cacher_pool, "1")
                            -- state_machine.excute("fight_role_controller_check_next_round_fight", 0, 0)
                            return false
                        end
                        local commonDefender = nil
                        if defenderList ~= nil then
                            for i, v in pairs(defenderList) do
                                -- local tempCurrentFightData = v.fight_cacher_pool[1]

                                -- if tempCurrentFightData ~= nil 
                                --     then
                                --     if tempCurrentFightData.__attacker ~= self then
                                --         if tempCurrentFightData.__attacker == nil then
                                --             -- -->___rint("return 0", self.dddd)
                                --         else
                                --             -- -->___rint("return 0", tempCurrentFightData.__attacker.dddd, self.dddd)
                                --         end
                                --         return
                                --     end
                                -- else
                                --     -->___crint("return 1")
                                --     return
                                -- end

                                -->___crint(v.__attack_permit, v.roleAttacking, v.roleByAttacking, v.waitAttackOver, v.waitByAttackOver, v.moveBackArena, v.roleWaitDeath, #v.fight_cacher_pool)
                                if v.parent == nil then
                                    defenderList[i] = nil
                                elseif v.borderBounce == true 
                                    or v.roleAttacking == true 
                                    then
                                    if v.roleCamp ~= self.roleCamp then
                                        return false
                                    end
                                elseif v.__attack_permit == true 
                                    and v.roleAttacking ~= true
                                    and v.moveBackArena ~= true
                                    and v.drawByAttackEffectCount > 0
                                    then
                                    commonDefender = v
                                elseif v.roleAttacking == true 
                                    or v.roleByAttacking == true
                                    or v.waitAttackOver == true
                                    or v.waitByAttackOver == true
                                    or v.moveBackArena == true
                                    -- or (v.roleWaitDeath == true and v.killer ~= self and #v.fight_cacher_pool > 0)
                                    or v.drawByAttackEffectCount > 0 
                                    -- or v.repelAndFlyEffectCount > 0  -- 取消击飞锁定攻击的处理
                                    -- or (v.roleWaitDeath == true and #v.fight_cacher_pool > 0 and v ~= slef)
                                    or v.needChange == true
                                    or math.abs(v.parent._base_pos.x - v.parent:getPositionX()) > 10
                                    then
                                    -- print("return 2", v.roleAttacking, v.roleByAttacking, v.waitAttackOver, v.waitByAttackOver, v.moveBackArena, (v.roleWaitDeath == true and #v.fight_cacher_pool > 0), v.drawByAttackEffectCount, v.repelAndFlyEffectCount)
                                    if v.roleCamp ~= self.roleCamp and true ~= FightRole.__g_lock_sp_attack 
                                        then
                                        return false
                                    end
                                end

                                -- 数码项目取消追击的效果
                                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                    -- if nil ~= v._move_state_enum 
                                    --     and v.move_state ~= v._move_state_enum._MOVE_STATE_VACANT 
                                    --     and v.move_state ~= v._move_state_enum._MOVE_STATE_WAIT then
                                    --     if v.roleCamp ~= self.roleCamp then
                                    --         return false
                                    --     end
                                    -- end
                                end
                            end
                        end

                        self.current_fight_data = self.fight_cacher_pool[1]
                        if self.current_fight_data.__state == 0 then
                            if commonDefender ~= nil then
                                commonDefender.__attack_permit = false
                            end
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

                                if self._isAnimal == true then
                                    FightRole.__g_lock_sp_attack = false
                                end
                                -- print("FightRole.__g_lock_sp_attack = ", FightRole.__g_lock_sp_attack, " FightRole.__g_role_attacking = ", FightRole.__g_role_attacking)
                                if FightRole.__g_lock_sp_attack == true 
                                    or FightRole.__g_role_attacking == true
                                    then
                                    local attData               = self.current_fight_data.__attData
                                    local attacker              = attData.attacker                                  -- 回合1出手方标识(0:我方 1:对方)
                                    local attackerPos           = attData.attackerPos                               -- 出手方位置(1-6)
                                    local linkAttackerPos       = attData.linkAttackerPos                           -- 是否有合体技(>0表示有.且表示合体的对象)
                                    local attackMovePos         = tonumber(attData.attackMovePos)                   -- 移动到的位置(0-8)
                                    local skillMouldId          = tonumber(attData.skillMouldId)                    -- 技能模板id
                                    local skillInfluenceCount   = tonumber(attData.skillInfluenceCount)             -- 技能效用数量

                                    local skillElementData = dms.element(dms["skill_mould"], skillMouldId)

                                    local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)  -- 技能类型(0:普通 1:怒气)
                                    -- print("skillQuality = ", skillQuality, " FightRole._current_attack_camp = ", FightRole._current_attack_camp, " self.roleCamp = ", self.roleCamp)
                                    if 1 == skillQuality or (nil ~= FightRole._current_attack_camp and FightRole._current_attack_camp > -1 and FightRole._current_attack_camp ~= self.roleCamp) then
                                        if FightRole.__g_lock_sp_attack == true 
                                            or FightRole.__g_role_attacking == true
                                            then
                                            return false
                                        end
                                    else
                                        FightRole.__g_lock_sp_attack = false
                                    end
                                end

                                FightRole.__g_role_attacking = true

                                if not self.isAddCampAttack then
                                    FightRole.__g_lock_camp_attack = FightRole.__g_lock_camp_attack + 1
                                    self.isAddCampAttack = true
                                end

                                self._call_next = false
                            end
                            
                            self.current_fight_data_attacker = self.fight_cacher_pool[1]
                            -- print("attackListener executeAttackLogic 角色执行攻击逻辑 ", self.roleCamp, self._info._pos)
                            self:executeAttackLogic()
                            attack_count = attack_count + 1
                            if FightRole.__priority_camp == -1 then
                                FightRole.__priority_camp = self.roleCamp
                            end

                            if self._FightRoleController.isPvEType ~= true then
                                if FightRole._current_attack_camp > -1 and FightRole._current_attack_camp ~= self.roleCamp then
                                    self._FightRoleController:cleanBuffStateWithType(self.roleCamp, "12")
                                    self._FightRoleController:cleanBuffStateWithType(self.roleCamp, "106")
                                    self._FightRoleController:cleanBuffState(nil, self.roleCamp)
                                end
                            end

                            if (not self._isAnimal) and self.roleCamp ~= FightRole._last_attack_camp then
                                -- state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "" .. FightRole._last_attack_camp)
                                state_machine.excute("fight_role_controller_update_draw_camp_change_influence_info", 0, "" .. self.roleCamp)
                            end
                            if not self._isAnimal then
                                FightRole._current_attack_camp = self.roleCamp
                                FightRole._last_attack_camp = self.roleCamp
                            end
                            
                            self._FightRoleController:removeBeAttackerEffect()
                            self._FightRoleController._open_hit_count = true
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local function cleanGhostFuncN( sender )
    if sender ~= nil then
        sender:removeFromParent(true)
    end
end

function FightRole:onUpdate(dt)
    -- if attack_count > -1 then
    --     return
    -- end

        -- if self.roleCamp == 1 then
        --     print("->", self._info._name, self._info._pos, state, self.move_state, self.waitJumpOver, self.waitJumpBack)
        --     print(self.roleCamp, self.attackLine, self.run_fight_listener, self.roleAttacking, 
        --         self.roleByAttacking, self.moveBackArena, self.waitAttackOver, self.waitByAttackOver, 
        --         self.roleWaitDeath, self.is_killed, self.is_deathed, self.openAttackListener, self.drawByAttackEffectCount, self.repelAndFlyEffectCount)
        -- end

    -- if self._isAnimal == true then
    --     if self.armature ~= nil and self.armature:isVisible() == true then
    --         print("roleCamp = ", self.roleCamp, " pos = ", self._info._pos)
    --         self.armature:setVisible(false)
    --     end
    -- end

    if self.parent ~= nil and self.moveBackArena == true then
        if math.floor(self.parent:getPositionY()) == math.floor(self.parent._base_pos.y) then
            self:cleanAttackData()
        end
    end

    -- print("===================", FightRole.__skeep_fighting, self.fight_over, self._info._pos, self.roleCamp)
    if FightRole.__skeep_fighting == true 
        or self.fight_over == true 
        or _ED._battle_role_attack_state == 0 
        or (nil ~= _ED._fightModule and true == _ED._fightModule._error)
        then
        return
    end

    -- print("FightRole:onUpdate self.parent = ", self.parent, self.move_state, self.roleCamp, self._info._pos)

    if self.parent == nil then --self.isStopFight == true or 
        return
    end

    if self.pursuit_line_action ~= nil and self.pursuit_line_action.updatePositionDelta ~= nil then
        local xx, yy = self.pursuit_line_target.parent:getPosition()
        if self.pursuit_line_target ~= nil then
            yy = self.pursuit_line_target.parent._base_pos.y
        else
            yy = self.parent._swap_pos.y
        end

        if self.pursuit_line_target ~= nil and self.armature._sed_action ~= nil then
            local moveBeginPosition = cc.p(self.parent:getPosition())
            local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
            local min_x = 0
            local max_x = 0
            if spaceInfo ~= nil then
                spaceInfo = zstring.split(spaceInfo, ",")
                if spaceInfo ~= nil and #spaceInfo == 2 then
                    min_x = zstring.tonumber(spaceInfo[1])
                    max_x = zstring.tonumber(spaceInfo[2])
                end
            end
            if self.pursuit_line_target.roleCamp == 0 then
                if xx + min_x < moveBeginPosition.x then
                    xx = math.min(xx + max_x, moveBeginPosition.x)
                else
                    xx = xx + min_x
                end
            else
                if xx - min_x > moveBeginPosition.x then
                    xx = math.max(xx - max_x, moveBeginPosition.x)
                else
                    xx = xx - min_x
                end
            end
        end
        self.pursuit_line_action:updatePositionDelta(cc.p(xx, yy))
    elseif self.pursuit_action ~= nil and self.pursuit_action.updatePositionDelta ~= nil then
        local xx, yy = self.pursuit_target.parent:getPosition()
        -- if yy < self.parent._swap_pos.y then
        --     yy = self.parent._swap_pos.y
        -- end
        yy = yy - _battle_controller._air_pursuit_change_posY

        if self.pursuit_target ~= nil and self.armature._sed_action ~= nil then
            local moveBeginPosition = cc.p(self.parent:getPosition())
            local spaceInfo = dms.atos(self.armature._sed_action, skill_mould.attack_scope)
            local min_x = 0
            local max_x = 0
            if spaceInfo ~= nil then
                spaceInfo = zstring.split(spaceInfo, ",")
                if spaceInfo ~= nil and #spaceInfo == 2 then
                    min_x = zstring.tonumber(spaceInfo[1])
                    max_x = zstring.tonumber(spaceInfo[2])
                end
            end
            if self.pursuit_target.roleCamp == 0 then
                if xx + min_x < moveBeginPosition.x then
                    xx = math.min(xx + max_x, moveBeginPosition.x)
                else
                    xx = xx + min_x
                end
            else
                if xx - min_x > moveBeginPosition.x then
                    xx = math.max(xx - max_x, moveBeginPosition.x)
                else
                    xx = xx - min_x
                end
            end
        end
        if animationMode == 1 then
            if self.ghostIndex % 2 == 0 then
                ShadowUtil_addGhost(self.armature, self:getParent():getParent(), self:getParent():getPositionX(), self:getParent():getPositionY())
            end
            self.ghostIndex = self.ghostIndex + 1
        end
        self.pursuit_action:updatePositionDelta(cc.p(xx, yy))
    end

    -- if self.waitJumpBack == true and self.jumpOffsetY ~= nil and self.jumpOffsetY > 0 then
    --     self.jumpOffsetY = self.parent:getPositionY() - self.parent._swap_pos.y
    --     self.jumpOffsetY = self.jumpOffsetY - 10
    --     if self.jumpOffsetY < 0 then
    --         self.jumpOffsetY = 0
    --         self.parent:setPositionY(self.parent._swap_pos.y)
    --         local waitJumpOver = self.waitJumpOver
    --         self.waitJumpOver = false
    --         self.waitJumpBack = false
    --         if waitJumpOver == true then
    --             self:checkAttackEnd()
    --         end
    --     else
    --         self.parent:setPositionY(self.parent._swap_pos.y + self.jumpOffsetY)
    --     end
    -- end

    -- if self.roleAttacking == true and self.moveBackArena == true then
    --     local currX = self:getParent():getPositionX()
    --     self.roleByAttacking = false
    --     if currX >= self.ml and currX <= self.mr then
    --         -->___rint("清除")
    --         self:cleanAttackData()
    --     end
    -- end

    if self.fiter == true and self.isCheckFitAttackEnd == true then
        -- self:checkFitAttackOver()
    end

    -- print("FightRole:onUpdate self.isCheckAttackEnd = ", self.isCheckAttackEnd, self.move_state, self.roleCamp, self._info._pos)

    if self.isCheckAttackEnd == true then
        self:checkAttackEnd()
    end

    -- print("FightRole:onUpdate self.waitByAttackOver = ", self.waitByAttackOver, self.move_state, self.roleCamp, self._info._pos)

    if self.waitByAttackOver == true then
        if self.drawByAttackEffectCount == 0 and self.repelAndFlyEffectCount == 0 then
            self.waitByAttackOver = false
            -->___rint("999999999999")
            self:checkByAttackEnd()
        end
    end

    if true or self.repelAndFlyEffectCount > 0 and self.parent ~= nil then
        local dx, dy = self.parent:getPosition()
        local moveY = 0
        -- if self.moveByPosition ~= nil then
        --     moveY = self.moveByPosition.y
        -- end
        local mh = self.parent._base_pos.y - dy + moveY -- self.parent._move_pos.y - dy + moveY
        if mh < 0 and (
            -- self.pursuit_target ~= nil 
            self.jumpOffsetY > 0
            or self.waitJumpBack == true
            or self.repelAndFlyEffectCount > 0)
            -- self.pursuit_target ~= nil or self.repelAndFlyEffectCount > 0 
            then
            if self.jumpOffsetY > 0 or self.waitJumpBack == true then
                self.shadow:setPositionY(mh - self.jumpAttackPosHeight)
            else
                self.shadow:setPositionY(mh)
            end
        else
            self.shadow:setPositionY(0) 
        end
        if mh < 0 then
            mh = math.abs(mh)
            local mo = 100 - (100) * mh / _battle_controller._shadow_max_height
            mo = math.max(0, math.min(mo, 100))
            self.shadow:setOpacity(mo)
            local bms = (_battle_controller._shadow_max_proportion/100)
            local ms = 1 - bms * mh / _battle_controller._shadow_max_height
            ms = math.max(bms, math.min(1, ms))
            self.shadow:setScale(ms)
        else
            self.shadow:setOpacity(100)
            self.shadow:setScale(1)
        end       
    end
    
    if self.parent ~= nil then
        -- print("开始运行 attackListener")
        self:attackListener()
        if self.repelAndFlyEffectCount > 0 and self._mdx ~= 0 then
            local dx, dy = self.parent:getPosition()
            local size = self._FightRoleController:getContentSize()
            if dx > size.width or dx < 0 then
                self.parent:stopAllActionsByTag(100)
                self.parent:stopAllActionsByTag(101)
                -- self.parent:stopAllActions()

                local _positionx = dx < 0 and (-1 * self._mdx) or (size.width - self._mdx)
                local _positiony = self.parent._swap_pos.y - dy
                -- if self.roleCamp == 0 then
                    -- print("反弹坐标：", self._mdx, _positionx, _positiony)
                -- end
                self._mdx = 0

                local h = math.abs(_positiony)
                local w = math.abs(_positionx)
                local s = h > 0 and h or w
                local g = 0.00098 * 2 / 5
                local t = math.sqrt(2*s*g)

                local pActionInterval_back_h = cc.MoveBy:create((t) * 2, cc.p(0, _positiony))
                local pSpeed_back_h = cc.EaseBounceOut:create(pActionInterval_back_h)
                if w > 0 then
                    local pActionInterval_back_w = cc.MoveBy:create((t), cc.p((_positionx + _positionx*0.2), 0))

                    local pSpeed_back_w = cc.EaseSineOut:create(pActionInterval_back_w)
                    self.parent:runAction(cc.Sequence:create({pSpeed_back_w}))
                end
                self.borderBounce = true
                self.parent:runAction(cc.Sequence:create({pSpeed_back_h, cc.CallFunc:create(hitRepelAndFlyEffectFunN)}))
            else
                -- if (self.roleCamp == 0 and dx < self.parent._base_pos.x - _battle_controller._byattck_flight_width)
                --     or (self.roleCamp == 1 and dx > self.parent._base_pos.x + _battle_controller._byattck_flight_width)
                --     then
                --     self.parent:stopAllActionsByTag(100)
                --     self.parent:stopAllActionsByTag(101)
                --     -- self.parent:stopAllActions()

                --     local _positionx = dx - self._mdx
                --     if math.abs(_positionx) > _battle_controller._rebound_distance then
                --         if _positionx > 0 then
                --             _positionx = _battle_controller._rebound_distance
                --         else
                --             _positionx = -1 * _battle_controller._rebound_distance
                --         end
                --     end

                --     local _positiony = self.parent._swap_pos.y - dy
                --     -- if self.roleCamp == 0 then
                --     --     print("反弹坐标：", self._mdx, _positionx, _positiony)
                --     -- end
                --     self._mdx = 0

                --     local h = math.abs(_positiony)
                --     local w = math.abs(_positionx)
                --     local s = h > 0 and h or w
                --     local g = 0.00098 * 2 / 5
                --     local t = math.sqrt(2*s*g)

                --     local pActionInterval_back_h = cc.MoveBy:create((t) * 2, cc.p(0, _positiony))
                --     local pSpeed_back_h = cc.EaseBounceOut:create(pActionInterval_back_h)
                --     if w > 0 then
                --         local pActionInterval_back_w = cc.MoveBy:create((t), cc.p((_positionx + _positionx*0.2), 0))

                --         local pSpeed_back_w = cc.EaseSineOut:create(pActionInterval_back_w)
                --         self.parent:runAction(cc.Sequence:create({pSpeed_back_w}))
                --     end
                --     self.borderBounce = true
                --     self.parent:runAction(cc.Sequence:create({pSpeed_back_h, cc.CallFunc:create(hitRepelAndFlyEffectFunN)}))
                -- end
            end
        end
    end

    if self.roleWaitDeath == true and self.isDeathRemove == false then
        -- self.deathRemoveTime = self.deathRemoveTime + dt
        -- if self.deathRemoveTime >= 2 then
        --     state_machine.excute("fight_role_be_killed", 0, self)
        --     self.isDeathRemove = true
        --     self.roleWaitDeath = false
        --     self.deathRemoveTime = 0
        -- end
    end
end

function FightRole:onEnterTransitionFinish()
    app.load("client.utils.ShadowUtil")
    self.parent = self:getParent()
    self.parent._self = self

    self.ml = self.parent._swap_pos.x - 64
    self.mr = self.parent._swap_pos.x + 64
end

function FightRole:onExit()
    for k,v in pairs(self._spineEffects) do
        if v ~= nil then
            v:release()
            v = nil
        end
    end
    self._spineEffects = {}
    self.parent._self = nil
    self.parent = nil
    if self._sl_role ~= nil and self._sl_role.parent ~= nil then
        self._sl_role._sl_role = nil
    end
end
