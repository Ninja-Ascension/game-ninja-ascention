-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗对象
-- ----------------------------------------------------------------------------------------------------
BattleRole = class("BattleRoleClass", Window)

-- load lua file
app.load("client.red_alert_time.battle.report.BattleLogic")
app.load("client.red_alert_time.battle.battle_drop")
app.load("client.utils.ShadowUtil")

-- 新建战斗对象
local battle_role_create_terminal = {
    _name = "battle_role_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return BattleRole:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_role_create_master_terminal = {
    _name = "battle_role_create_master",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return BattleRole:new():initMaster(params)
    end,
    _terminal = nil,
    _terminals = nil
}

-- 删除战斗对象
local battle_role_delete_terminal = {
    _name = "battle_role_delete",
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

-- 移除受攻击者
local battle_role_clear_by_attacker_state_terminal = {
    _name = "battle_role_clear_by_attacker_state",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local attacker = params[1]
        local byAttacker = params[2]
        attacker:clearByAttackerState(byAttacker)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 受击
local battle_role_hit_terminal = {
    _name = "battle_role_hit",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local attacker = params[1]
        local bullet = params[2]
        local byAttacker = params[3]
        local isFristHurt = false
        if params[4] == nil or (params[4] ~= nil and params[4] == true) then
            isFristHurt = true
        end
        if byAttacker ~= nil 
            and attacker._death == false 
            then
            byAttacker:hit(attacker, bullet, isFristHurt)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_role_state_change_terminal = {
    _name = "battle_role_state_change",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- if params._attacking == false then
        --     return true
        -- end
        -- params._attacking = false
        -- instance = params
        -- if params._sprite ~= nil and nil ~= params._sprite._actionIndex then
        --     local nCount = params._sprite._actionIndex % _spine_sprite_animation_team_count
        --     if nCount == 3 then
        --         params._sprite._nextAction = params._sprite._actionIndex - 1
        --     elseif nCount == 4 then
        --         if params:getChildByTag(300000) ~= nil then
        --             params:removeChildByTag(300000)
        --         end
        --     end
        -- end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 角色技能攻击
local battle_role_skill_attack_terminal = {
    _name = "battle_role_skill_attack",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local role = params.role
        if role._is_skill == false
            and decryptInfo(role._sp) >= decryptInfo(role._max_sp)
            and role._moving == false
            and role._move_state ~= role._enum_move_state._join
            then
            if role._run_state == role._enum_run_state._run
                and #role._path == 0 then
                role:onSleep()
                csb.animationChangeToAction(role._sprite, role._sprite._nextAction, role._sprite._nextAction)
            end

            if role._attack_pause == true then
                role:onResume()
                role._attack_pause = true
            end

            role._sleep_cd = 0
            role._run_state = role._enum_run_state._run
            role._is_skill = true
            if role._byLockAttackTarget ~= nil then
                role:attackTarget(role._byLockAttackTarget)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 施放主公技
local battle_role_execute_master_skill_terminal = {
    _name = "battle_role_execute_master_skill",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local role = params[1]
        local skill = params[2]
        role:executeMasterSkill(skill)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 执行某BUFF效用
local battle_role_execute_buff_skill_terminal = {
    _name = "battle_role_execute_buff_skill",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local role = params[1]
        local skill = params[2]
        role:executeSkill(skill)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 移除BUFF
local battle_role_remove_buff_terminal = {
    _name = "battle_role_remove_buff",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local role = params.role
        local buff = params.buff
        for i, v in pairs(role._buffs) do
            if v == buff then
                state_machine.excute("battle_buff_over", 0, buff)
                table.remove(role._buffs, i, 1)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 显示战场中角色的血条信息
local battle_role_show_ui_role_hp_terminal = {
    _name = "battle_role_show_ui_role_hp",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local role = params
        role:showUIRoleHp()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 更换战场中的形象
local battle_role_change_sprite_terminal = {
    _name = "battle_role_change_sprite",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local role = params[1]
        local spriteId = params[2]
        role:changeRoleSprite(spriteId)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_role_create_terminal)
state_machine.add(battle_role_create_master_terminal)
state_machine.add(battle_role_delete_terminal)
state_machine.add(battle_role_clear_by_attacker_state_terminal)
state_machine.add(battle_role_hit_terminal)
state_machine.add(battle_role_state_change_terminal)
state_machine.add(battle_role_skill_attack_terminal)
state_machine.add(battle_role_execute_master_skill_terminal)
state_machine.add(battle_role_execute_buff_skill_terminal)
state_machine.add(battle_role_remove_buff_terminal)
state_machine.add(battle_role_show_ui_role_hp_terminal)
state_machine.add(battle_role_change_sprite_terminal)
state_machine.init()

function BattleRole:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua file
    app.load("configs.csb.config")
    app.load("client.red_alert_time.battle.battle_buff")
    app.load("client.red_alert_time.battle.battle_bullet")
    app.load("client.red_alert_time.battle.battle_clipper")
    app.load("client.red_alert_time.battle.battle_effect")
    app.load("client.red_alert_time.battle.battle_macros")
    app.load("client.red_alert_time.battle.battle_role_hp")

    -- var
    -- 场景
    self._is_running = false
    self._run_state = 0
    self._enum_run_state = {
        _wait = 0,
        _run = 1,
        _pause = 2,
        _sleep = 3,
        _lock_attack = 4,
    }

    self._isPartner = false
    -- 移动中
    self._moving  = false

    self._follow = true

    self._by_lock = false

    self._coord_x = 0

    self._coord_y = 0

    self._last_coord_x = 0

    self._last_coord_y = 0

    self._attack_coord_x = 0

    self._attack_coord_y = 0

    self._last_attack_coord_x = 0

    self._last_attack_coord_y = 0

    self._follow_path = {}

    self._sleep_cd = 0

    self._attack_pause = false

    self._scene = nil

    -- 战斗类型 0: pve 1 pvp
    self._battle_type = 0

    -- 角色所在的阵型位置
    self._formation_index = -1

    -- 所在英雄的队伍索引
    self._team_index = 0

    -- 当前所属排
    self._formation_row = 0

    -- 当前所属列
    self._formation_column = 0

    -- 英雄的队伍信息
    self._team = {nil}

    -- 角色身体大小
    self._rect = nil

    -- 父层容器
    self._parent = nil

    -- 阵容
    self._camp = 0

    -- 角色动画ID
    self._sprite_id = -1

    -- 攻击的策略
    self._act_strategy = 0

    -- 起点
    self._start_pos = nil

    -- 当前坐标
    self._last_pos = nil

    -- 当前坐标
    self._move_pos = nil

    -- 碰撞区域宽高
    self._collision_size = nil

    -- 终点
    self._end_pos = nil

    -- 攻击准备坐标
    self._attack_position = nil

    -- 复位坐标
    self._reset_position = nil

    -- 角色当前角度
    self._angle = 0

    -- 角色变更前角度
    self._last_angle = 0

    -- 镜头聚焦
    self.camera_focus = false
    
    -- 被锁定的攻击目标
    self._byLockAttackTarget = nil

    -- 当前的攻击目标
    self._byAttackTarget = nil

    -- 当前的攻击目标所属阵营
    self._byAttackTargetCamp = nil

    -- 目标最后所在的位置
    self._byAttackTargetPosition = nil

    -- 攻击占位
    self._moveAttackTargetPosition = nil

    -- 攻击复位
    self._resetAttackTargetPosition = nil

    -- 移动攻击的拖影
    self._attackMoveShadow = false

    -- 移动攻击的拖影计数
    self._ghostIndex = 0
    self._ghostCount = 1
    
    -- 移动的速度 
    self._velocity = 1.5 * 1.4

    -- 攻击的范围
    self._range = 100

    -- 攻击
    self._attack = 0

    -- 解锁攻击
    self._unlock_attack = false

    -- 子弹id
    self._bullet_id = 0

    -- 子弹类型
    self._bullet_type = 0

    -- 承受光效id
    self._effect_id = 0

    -- 底部承受光效
    self._floor_effect_id = 0

    -- 攻击类型
    self._attack_type = 0

    -- 目标帧组
    self._targetIndex = -1

    -- 精灵
    self._sprite = nil

    -- 影子
    self._shadow = nil

    -- 武器
    self._weapon = nil

    -- 旋转速率
    self._vrevolve = 0

    -- 角色实例数据
    self._info = nil

    -- 角色HP
    self._hp = 100

    -- 角色最大HP
    self._max_hp = 100

    -- 个人战角色最大HP
    self._personal_max_hp = 100

    -- 角色SP
    self._sp = encryptInfo(50)

    -- 角色最大SP
    self._max_sp = encryptInfo(90)

    -- 角色死亡
    self._death = false

    -- 角色攻击状态
    self._attacking = false

    -- 角色等待发起攻击
    self._wait_attacking = false

    -- 攻击等待CD
    self._attack_wait_cd = 0

    -- 
    self._stop_attack_count = 0

    -- 角色所属英雄
    self._hero = nil

    -- 角色技能数据
    self._skills = nil

    -- 当前触发的技能
    self._current_skill = nil

    -- 天赋技术
    self._talent = {_skills = {nil}}

    -- 角色技能攻击
    self._is_skill = false

    -- 角色自动攻击
    self._is_auto = false

    -- 绘制战场中角色HP信息
    self._ui_role_hp = nil

    -- 战场中角色的防御时间
    self._def_timer = 0

    -- 普攻次数
    self._normal_attack_count = 0
    -- 是否已经激活神将技能
    self._active_god_skill = false

    -- 显示战场中角色HP信息
    self._show_ui_role_hp = false

    self._show_ui_role_hp_timer = 0

    self._heroBattleObject = nil

    self._shipId = nil

    -- 英雄类型
    self._hero_type = nil
    self._enum_hero_type = {
        _hero = 0,
        _dogface = 1,
        _master = 2
    }

    -- 移动的状态
    self._move_state = 0

    self._enum_move_state = {
        _wait = 0,
        _pause = 1,
        _moving = 2,
        _collision = 3,
        _lock_attacker = 4,
        _search = 5,
        _join = 6,
    }

    -- 移动的状态
    self._move_dir = 1

    self._last_move_dir = 1

    self._change_dir = false

    self._enum_move_dir = {
        _up = 1,
        _left = 2,
        _down = 3,
        _right = 4,
    }

    -- 寻路路径
    self._path = {}

    -- 路径节点
    self._cell = {_curr_node = nil, _last_node = nil, _last_passable = true, _curr_passable = true}

    -- 锁屏状态
    self._lock_screen = false

    -- 战船模板
    self._shipMould = nil

    self._shipMouldId = nil

    self._shipName = ""
    
    self.lastMode = ""
    
    self.moveNumber = 300
    
    --开场是否移动
    self.isOpenMove = false
    
    self.isOpenMoveTime = 0.6

    -- 角色BUFF技能
    self._buff_skills = {}

    -- 角色当前的buff
    self._buffs = {}

    -- 必定命中
    self._must_hit = false

    -- 当前场次攻击次数
    self._attack_count = 1

    -- 进入地图起始移动值
    self._fristEnterMoveX = 0
    self._fristEnterMoveY = 0
    self._frsitMoveEnd = false
    self._enterFightMoveEnd = false

    self._effect_layer = nil

    self._is_skill_attack_buffed = false
    self._is_used_not_death = false

    self._frist_activi_god_skill = false
    self._use_god_skill = false
    self._base_god_attack_times = 0
end

local function checkFrameEvent(events, mode)
    if events ~= n and #events > 0 then
        for i, v in pairs(events) do
            if v == mode then
                return true
            end
        end
    end
    return false
end

-- 根据帧事件处理具体的逻辑
local function onFrameEvent(bone, evt, originFrameIndex, currentFrameIndex)
    local armature = bone:getArmature()
    local actionIndex = math.modf(armature._actionIndex / _spine_sprite_animation_team_count)
    local frameEvents = zstring.split(evt, "_")

    if checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_mcamera) == true then -- 启动角色镜头聚焦
        armature._self.camera_focus = true
        state_machine.excute("battle_map_scene_scale_effect", 0, {armature._self._camp, 0,  false, true, armature._self})
    end

    if checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_scamera) == true then -- 取消角色镜头聚焦
        armature._self.camera_focus = false
        state_machine.excute("battle_map_scene_scale_effect", 0, {0, 0, false, false, armature._self})
    end

    -- print("dddddddddddddddddddddddddd",armature._self._sprite_id)
    -- print("bbbbbbbbbbbbbbbbbbbbbbbbbb",armature._self._bullet_id)
    if checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_start) == true then
  --       if armature._self.lastMode == _enum_spine_animation_frame_event_name.animation_unlock  then
        --  armature._self._lock_screen = false
        --  armature._self:__reorderChild()
        --  state_machine.excute("battle_scene_attack_resume", 0, armature._self)
        --  -- return
        -- end

        -- local mPos = cc.p(armature._self:getPosition())
        -- if armature._self._hero_type == armature._self._enum_hero_type._hero then
        --     -- armature._self._rect = armature._self._sprite:getBoundingBox()
        --     mPos.x = mPos.x + 10
        --     mPos.y = mPos.y + armature._self._rect.y + 150--armature._self._rect.height * 2 / 3
        -- else
        --     mPos.x = mPos.x
        --     mPos.y = mPos.y + 25
        -- end

        -- -- 角色死亡切换攻击目标
        -- if (armature._self._byAttackTarget == nil 
        --     or armature._self._byAttackTarget._death == true)
        --     and armature._self._hero_type == armature._self._enum_hero_type._hero
        --     then
        --     -- armature._self:onUpdate(0)
        --     armature._self:checkByAttacker()
        -- end
        if armature._self._attack_type == 0 
            and (armature._self._byAttackTarget == nil or armature._self._byAttackTarget._death == true)
            then
            if armature._self._use_god_skill == true then
                if armature._self:getChildByTag(300000) ~= nil then
                    armature._self:removeChildByTag(300000)
                end
            end
            armature._self:onSleep(true)
            armature._self:onSleep()
            armature._self._sleep_cd = 0
        else
            local skill = armature._self._current_skill
            if skill ~= nil then

                if skill.forepart_lighting_sound_effect_id > 0 then
                    playEffectMusic(skill.forepart_lighting_sound_effect_id)
                end
                armature._self:createBullet(armature, actionIndex, skill, true)
                for i, v in pairs(skill.other) do
                    local other_skill = v
                    armature._self:createBullet(armature, actionIndex, other_skill, false)
                end
                if armature._self._pfeffect ~= nil 
                    and decryptInfo(armature._self._sp) < decryptInfo(armature._self._max_sp)
                    then
                    armature._self._pfeffect:setVisible(false)
                end
                armature._self:onSleep(true)
                armature._self.lastMode = _enum_spine_animation_frame_event_name.animation_start
                
                -- if skill.trigger_timing == battle_enum._skill_influence_trigger._attack_addition then
                    -- 2：攻击附带
                    if armature._self._attack_type == 0 then
                        -- or skill.skill_influence_type == 0 then
                        armature._self:executeSkills(battle_enum._skill_influence_trigger._attack_addition, skill.id)
                    end
                    -- 5：释放技能时
                    -- if armature._self._attack_type == 1 then
                    --     armature._self:executeSkills(battle_enum._skill_influence_trigger._release_skills, skill.id)
                    -- end
                -- end
            end
        end
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_send) == true then
        armature._self._attack_param._send = true
        if armature._self.bullet_target_end_pos_x ~= nil then
            armature._self._attack_param[8].x = armature._self.bullet_target_end_pos_x
        end
        if armature._self.bullet_target_end_pos_y ~= nil then
            armature._self._attack_param[8].y = armature._self.bullet_target_end_pos_y
        end
        state_machine.excute("battle_bullet_create", 0, armature._self._attack_param)
        armature._self._attack_param._send = false
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_death) == true then
        -- print("角色死亡，移除死亡角色。")
        armature._self:deathed()
        armature._self.lastMode = _enum_spine_animation_frame_event_name.animation_death
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_hurt) == true then
        -- print("伤害掉血。")
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_shake) == true then
        -- print("场景抖动。")
        state_machine.excute("battle_map_shake_screen_play", 0, nil)
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_effect) == true then
        -- print("绘制渲染特效。")
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_lock) == true then
        -- if armature._self.lastMode == _enum_spine_animation_frame_event_name.animation_unlock then
        --  armature._self._lock_screen = false
        --  armature._self:__reorderChild()
        --  state_machine.excute("battle_scene_attack_resume", 0, armature._self)
        --  return
        -- end
  --       armature._self._lock_screen = true

  --       if armature._self._byAttackTarget ~= nil then
  --           -- if armature._self._lock_screen == false then
        --      state_machine.excute("battle_scene_attack_pause", 0, armature._self)
  --           -- end
  --       end
  --       -- 如果锁屏角色计数为0 才进行锁操作
  --       -- if armature._self._parent._lock_screen_number == 0 and armature._self._parent._attack_running  == true then
  --       --     state_machine.excute("battle_scene_attack_pause", 0, armature._self)
  --       -- end

  --       -- 锁屏角色计数 由第一个释放角色锁屏 最后角色恢复
  --       -- armature._self._parent._lock_screen_number = armature._self._parent._lock_screen_number + 1

  --       armature._self:__reorderChild()
        -- armature._self.lastMode = _enum_spine_animation_frame_event_name.animation_lock
        if armature._self._attack_type == 1 then
            armature._self:addAttackEffect()
        end
        if armature._self._hero_type == armature._self._enum_hero_type._hero then
            armature._self:drawSkillName(dms.atof(armature._self._current_skill.skill_element, skill_mould.skill_pic))
        end
        if armature._self._battle_type == 1 
            or armature._self._camp == 0
            then
            -- armature._self._scene._lock_screen_number = armature._self._scene._lock_screen_number + 1
            armature._self._lock_screen = true
            armature._self:__reorderChild()
            state_machine.excute("battle_scene_attack_pause", 0, armature._self)
        end
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_unlock) == true then
  --       -- armature._self._lock_screen = false

  --       -- 锁屏角色计数 由第一个释放角色锁屏 最后角色恢复
  --       -- armature._self._parent._lock_screen_number = armature._self._parent._lock_screen_number - 1

  --               -- 如果锁屏角色计数为0 才进行锁操作
  --       -- if armature._self._parent._lock_screen_number == 0 and armature._self._parent._attack_running  == false then
  --       --     state_machine.excute("battle_scene_attack_resume", 0, armature._self)
  --       -- end
  --       -- armature._self:__reorderChild()
  --       -- state_machine.excute("battle_scene_attack_resume", 0, armature._self)
        -- state_machine.excute("battle_map_hide_object_layer_skill_effect", 0, 0)
        -- armature._self.lastMode = _enum_spine_animation_frame_event_name.animation_unlock

        if armature._self._battle_type == 1 
            or armature._self._camp == 0
            then
            -- armature._self._scene._lock_screen_number = armature._self._scene._lock_screen_number - 1
            -- if armature._self._scene._lock_screen_number <= 0 then
                armature._self._lock_screen = false
                armature._self:__reorderChild()
                state_machine.excute("battle_scene_attack_resume", 0, armature._self)
            -- end
        end
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_end) == true then
        armature._self:setVisible(false)
        csb.animationChangeToAction(armature, 0, 0, false)
        armature._nextAction = 0
    end
end

function BattleRole.srcchangeActionCallback(armatureBack)
    local armature = armatureBack
    local battleRole = armature._self
    if armature ~= nil then
        -- if armature._self._sprite._actionIndex ~= armature._actionIndex
        --     then
        --     armature._self._sprite_src:setVisible(false)
        -- end
        armature:setVisible(false)
    end
end

-- 
function BattleRole.changeActionCallback(armatureBack)
    local armature = armatureBack
    local battleRole = armature._self
    if armature ~= nil then
        -- if armature._self._sprite_src ~= nil 
        --     and armature._self._sprite._actionIndex ~= armature._self._sprite_src._actionIndex
        --     then
        --     armature._self._sprite_src:setVisible(false)
        -- end

        if armature._self._lock_screen == true then
            armature._self._lock_screen = false
            armature._self:__reorderChild()
            state_machine.excute("battle_scene_attack_resume", 0, armature._self)
        end

        -- local actionIndex = armature._actionIndex
        local modeIndex = armature._actionIndex % _spine_sprite_animation_team_count
        if modeIndex == 2 or modeIndex == 3 or modeIndex == 4 then
            if modeIndex == 4 then
                armature._self:removeChildByTag(300000)
            end
            battleRole:onSleep()
            csb.animationChangeToAction(armature, armature._nextAction, armature._nextAction, false)

            -- local actionIndex = armature._actionIndex / _spine_sprite_animation_team_count
            -- armature._nextAction = actionIndex * _spine_sprite_animation_team_count
            -- armature._self._attacking = false
            -- armature._self:stopAllActions()
            return
        end

        -- 帧组判断方位
        local actionIndex = armature._actionIndex / _spine_sprite_animation_team_count
        -- _targetIndex目标帧组
        if battleRole._targetIndex >= 0 then
            actionIndex = math.modf(actionIndex)
            -- 有旋转 用旋转控制动作帧 暂无用
            if battleRole._vrevolve > 0 then
                if battleRole._targetIndex > actionIndex then
                    actionIndex = actionIndex + battleRole._vrevolve
                else
                    actionIndex = actionIndex - battleRole._vrevolve
                end
            else
                actionIndex = battleRole._targetIndex
            end

            -- 如果目标帧组和当前帧组相同 则目标帧组设置为 -1
            if battleRole._targetIndex == actionIndex then
                battleRole._targetIndex = -1
            end

            armature._nextAction = actionIndex * _spine_sprite_animation_team_count + armature._actionIndex % _spine_sprite_animation_team_count
            return
        end

        -- if armature._self._move_state == armature._self._enum_move_state._wait then
        --     -- 待机状态
        --     if armature._actionIndex % _spine_sprite_animation_team_count == 0  then
        --         armature._self._move_state = armature._self._enum_move_state._moving
        --         -- armature._nextAction = armature._actionIndex + 1
        --         -->print("等待结束。")
        --     end
        -- end
    end
end

function cc.blendFunc(_src, _dst)
    return {src = _src, dst = _dst}
end


function BattleRole:createBullet(armature, actionIndex, skill, isMainSkill)
    local targets = nil
    local needCheckRange = false
    local byAttackTarget = self._byAttackTarget
    local yLockAttackTarget = self._byLockAttackTarget
    
    -- if self._attack_type == 1 
    --     or (self._attack_type == 0 and skill.influence_range > 0)
    --     then
        needCheckRange, targets = state_machine.excute("battle_scene_lock_skill_attack", 0, {self, self._camp, skill})
    -- end

    local isMyCamp = false
    if self._hero_type == self._enum_hero_type._master then
        if self._camp == 0 and skill.influence_group ~= 1 then
            isMyCamp = true
        end
        if self._camp == 1 and skill.influence_group == 1 then
            isMyCamp = true
        end
    end

    local mPos = cc.p(armature._self:getPosition())
    local base_offset_y = 0
    if skill.bullet_positions ~= nil and actionIndex > 0 then
        mPos.x = mPos.x + skill.bullet_positions[actionIndex].x
        base_offset_y = skill.bullet_positions[actionIndex].y
        mPos.y = mPos.y + base_offset_y
    end

    if self._byAttackTarget ~= nil 
        and self._byAttackTarget._death == true 
        then
        --::self._byAttackTarget = nil
    end

    if self._byAttackTarget == nil then
        if self._byLockAttackTarget ~= nil then
            local pos = cc.p(self._byLockAttackTarget:getPosition())
            local lockTarget = self._byLockAttackTarget
            if (self._attack_type == 0 and targets ~= nil) then
                lockTarget = targets[1]
                pos = cc.p(targets[1]:getPosition())
            end
            local camp = self._byLockAttackTarget._camp
            if isMyCamp == true then
                camp = self._camp
            end
            self._attack_param = {
                skill.bullet_type,                                -- 1
                self._parent,                                     -- 2
                mPos,                                              -- 3
                skill.bullet,                                      -- 4
                self,                                             -- 5
                lockTarget,                         -- 6
                360.0 / 25 * actionIndex,                         -- 7
                pos,                                        -- 8
                skill.effect,                                     -- 9
                skill.floor_effect,                               -- 10
                armature,                                         -- 11
                self._attack_type,                                -- 12
                skill,                                            -- 13
                camp,                   -- 14
                pos,     -- 15
                targets,                                          -- 16
                needCheckRange,                                   -- 17
                skill.bullet_speed,                                -- 18
                base_offset_y,                                  -- 19
                self._use_god_skill,                                  -- 20
                }
            state_machine.excute("battle_bullet_create", 0, self._attack_param)
        else
            if (self._attack_type == 0 and targets ~= nil) then
                self._byAttackTargetPosition = cc.p(targets[1]:getPosition())
            end
            local camp = self._byAttackTargetCamp
            if isMyCamp == true then
                camp = self._camp
            end
            state_machine.excute("battle_bullet_create", 0, {
                skill.bullet_type,                           -- 1
                self._parent,                                -- 2
                mPos,                                        -- 3
                skill.bullet,                                -- 4
                self,                                        -- 5
                nil,                                         -- 6
                360.0 / 25 * actionIndex,                    -- 7
                self._byAttackTargetPosition,                -- 8
                skill.effect,                                 -- 9
                skill.floor_effect,                           -- 10
                armature,                                     -- 11
                self._attack_type,                           -- 12
                skill,                                        -- 13
                camp,                    -- 14
                self._byAttackTargetPosition,                -- 15
                targets,                                      -- 16
                needCheckRange,                               -- 17
                skill.bullet_speed,                            -- 18
                base_offset_y,                                  -- 19
                self._use_god_skill,                                  -- 20
                })
            self._byAttackTargetPosition = nil
        end
    else
        local pos = cc.p(self._byAttackTarget:getPosition())
        local lockTarget = self._byAttackTarget
        if (self._attack_type == 0 and targets ~= nil) then
            pos = cc.p(targets[1]:getPosition())
            lockTarget = targets[1]
        end
        local camp = self._byAttackTarget._camp
        if isMyCamp == true then
            camp = self._camp
        end
        if isMainSkill ~= nil and isMainSkill == true then
            self.bullet_target_end_pos_x = pos.x
            self.bullet_target_end_pos_y = pos.y
            self._attack_param = {
                skill.bullet_type,                         -- 1
                self._parent,                              -- 2
                mPos,                                      -- 3 
                skill.bullet,                              -- 4
                self,                                      -- 5
                lockTarget,                      -- 6
                360.0 / 25 * actionIndex,                   -- 7
                pos,                                  -- 8
                skill.effect,                              -- 9
                skill.floor_effect,                        -- 10
                armature,                                   -- 11
                self._attack_type,                          -- 12
                skill,                                      -- 13
                camp,                 -- 14
                pos,   -- 15
                targets,                                    -- 16
                needCheckRange,                             -- 17
                skill.bullet_speed,                          -- 18
                base_offset_y,                                  -- 19
                self._use_god_skill,                                  -- 20
                }
            state_machine.excute("battle_bullet_create", 0, self._attack_param)
        else
            state_machine.excute("battle_bullet_create", 0, {
                skill.bullet_type,                          -- 1
                self._parent,                               -- 2
                mPos,                                       -- 3 
                skill.bullet,                               -- 4
                self,                                       -- 5
                lockTarget,                       -- 6
                360.0 / 25 * actionIndex,                   -- 7
                pos,                                  -- 8
                skill.effect,                              -- 9
                skill.floor_effect,                        -- 10
                armature,                                   -- 11
                self._attack_type,                          -- 12
                skill,                                      -- 13
                camp,                 -- 14
                pos,   -- 15
                targets,                                     -- 16
                needCheckRange,                              -- 17
                skill.bullet_speed,                           -- 18
                base_offset_y,                                  -- 19
                self._use_god_skill,                                  -- 20
                })
        end
    end
    if self._attack_type == 0 and self._use_god_skill == true then
        self._byAttackTarget = byAttackTarget
        self._byLockAttackTarget = yLockAttackTarget
    end
end

function BattleRole:createSprite(parent, spriteId)
   -- 创建精灵绘图 sprite = skeletonNode
    local sprite = sp.spine_sprite(parent, spriteId, _spine_sprite_animation_names[1], true, nil, nil, cc.p(0.5, 0))
    sprite:addAnimation(0, _spine_sprite_animation_names[2], true)

    -- spine动画初始化
    sp.initArmature(sprite, true)

    -- 设置战斗双方 方位
    sprite.playWithIndex = function(_self, actionIndex)
        if actionIndex > _enum_spine_animation_frame_index.animation_attack_dir_13 
            and actionIndex < _enum_spine_animation_frame_index.animation_death 
            then
            _self:setScaleX(-1)
            -- if _self._ui_role_hp ~= nil then
            --     _self._ui_role_hp.LoadingBar_bolld:setScaleX(-1)
            -- end
        else
            _self:setScaleX(1)
            -- if _self._ui_role_hp ~= nil then
            --     _self._ui_role_hp.LoadingBar_bolld:setScaleX(1)
            -- end
        end
        _self:setAnimation(0, _self.animationNameList[actionIndex + 1], true)
        if _self.changeActionCallfunc ~= nil then
            _self.changeActionCallfunc(_self, nil, nil)
        end
    end

    sprite.animationNameList = _spine_sprite_animation_names

    sprite:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)

    local actionIndex = _enum_spine_animation_frame_index.animation_standby_dir_1

    actionIndex = _enum_spine_animation_frame_index.animation_move_dir_1

    csb.animationChangeToAction(sprite, actionIndex, actionIndex, false)

    -- sprite._invoke = self.changeActionCallback
    -- sprite:getAnimation():setFrameEventCallFunc(onFrameEvent)

    sprite._self = self 
    return sprite
end

function BattleRole:drawSkillName(pic_index)
    if pic_index < 0 then
        return
    end

    -- 攻击方技能UI绘图
    if self._camp == 0 then
        if config_res.battle.spirte_skill_name ~= nil then
            state_machine.excute("battle_skill_ui_window_update_draw_skill", 0, pic_index)
            return
        end
    end
    
    local skillNameFile = string.format("images/face/skill_head/skill_name_%s.png", pic_index)
    if cc.FileUtils:getInstance():isFileExist(skillNameFile) == false then
        return
    end
    local armature = ccs.Armature:create("effect_jinengsf")
    local skill_name1 = ccs.Skin:create(skillNameFile)
    local skill_name2 = ccs.Skin:create(skillNameFile)
    armature:getBone("name1"):addDisplay(skill_name1, 0)
    armature:getBone("name2"):addDisplay(skill_name2, 0)
    armature:getAnimation():playWithIndex(0)
    -- local size = cc.size(app.screenSize.width / app.scaleFactor, app.screenSize.height / app.scaleFactor)
    -- armature:setPosition(cc.p(self:getPosition()))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature:getAnimation():setSpeedScale(1.0 / __fight_recorder_action_time_speed)
    armature._LastsCountTurns = 1
    armature._invoke = csb.deleteEffect
    self:addChild(armature)
end

function BattleRole:initMaster(params)
    self._scene = params[1]
    self._camp = params[2]
    self._gender = params[3]
    self._hero_type = self._enum_hero_type._master
    
    if checkPvpBattleType(self._scene._fight_type) == true then
        self._battle_type = 1
    else
        self._battle_type = 0
    end

    self._heroBattleObject = {_role = self}

    local shipMouldIdsString = dms.string(dms["fight_config"], battle_enum._fight_config_num.master_sprite_ids, fight_config.attribute)
    local shipMouldIds = zstring.split(shipMouldIdsString, ",")

    local sprite_id = dms.string(dms["ship_mould"], shipMouldIds[self._gender], ship_mould.ship_pic)

    local sprite = self:createSprite(self, sprite_id)
    -- sprite._invoke = self.changeActionCallback
    sprite:getAnimation():setFrameEventCallFunc(onFrameEvent)

    self._sprite = sprite

    sprite._self = self

    self:setVisible(false)

    self:setContentSize(cc.size(0, 0))

    if self._camp == 1 then
        self:setScaleX(-1)
    end

    self._parent = state_machine.excute("battle_map_add_master", 0, {self._camp, self})
    return self
end

function BattleRole:init(params)
    local scene = params._scene
    local camp = params._camp
    local spriteId = params._sprite_id
    local spriteType = params._sprite_type
    local startPosition = params._start_position
    local endPosition = params._over_position
    local sceneSize = params._size
    local range = params._hero_range
    local bullet = params._hero_bullet
    local effect = params._hero_effect
    local skills = params._hero_skills
    local hero = params._hero
    local heroBattleObject = params._hero_battle_object
    local formationIndex = params._formation_index
    local teamIndex = params._team_index
    local attackPosition = params._attack_position
    local resetPosition = params._reset_position
    if heroBattleObject.isPartner then
        self._isPartner = heroBattleObject.isPartner
    end

    if checkPvpBattleType(scene._fight_type) == true then
        self._battle_type = 1
    else
        self._battle_type = 0
    end
    self._coord_x = params._coord_x
    self._coord_y = params._coord_y
    self._last_coord_x = params._coord_x
    self._last_coord_y = params._coord_y
    self._attack_coord_x = params._attack_coord_x
    self._attack_coord_y = params._attack_coord_y
    self._last_attack_coord_x = params._attack_coord_x
    self._last_attack_coord_y = params._attack_coord_y

    -- self._run_state = self._enum_run_state._run
    self._run_state = self._enum_run_state._wait

    -- 根据逻辑战斗对象初始化绘图对象
    if heroBattleObject ~= nil then
        local shipMould = dms.element(dms["ship_mould"], heroBattleObject.shipMould)
        self._shipMould = shipMould
        self._shipMouldId = dms.atoi(shipMould, ship_mould.id)
        self._shipName = heroBattleObject.captainName -- dms.atos(shipMould, ship_mould.captain_name)
        self._shipId = heroBattleObject.id
        self._heroBattleObject = heroBattleObject
        self._heroBattleObject._role = self

        self._hp = heroBattleObject.healthPoint
        self._max_hp = heroBattleObject.healthMaxPoint
        self._personal_max_hp = heroBattleObject.healthMaxPoint

        self._sp = encryptInfo(heroBattleObject.skillPoint)
        self._max_sp = encryptInfo(dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_full, fight_config.attribute))

        if scene._fight_type == battle_enum._fight_type._fight_type_105 then
            self._hp = heroBattleObject.currentHealthPoint
            self._personal_max_hp = heroBattleObject.currentHealthPoint
        end

        if scene._fight_type ~= battle_enum._fight_type._fight_type_20 
            and self._fight_type ~= battle_enum._fight_type._fight_type_105
            then
            if self._camp == 0 and hero ~= nil then
                local isVerity = true
                local baseHp = decryptInfo(heroBattleObject.key_ship_health)
                if tonumber(self._hp) - 10 >= baseHp or tonumber(self._hp) + 10 < baseHp then
                    isVerity = false
                end
                if isVerity == false then
                    if fwin:find("ReconnectViewClass") == nil then
                        fwin:open(ReconnectView:new():init(red_alert_all_str[184]), fwin._system)
                    end
                    return
                end
            end
        end
        -- -- test code 
        -- if camp == 0 and hero == nil then
        --     self._sp = self._max_sp
        -- end
    end

    if hero ~= nil then
        table.insert(hero._team, self)
        self._hero_type = self._enum_hero_type._dogface
        self._hero = hero
        self._formation_index = hero._formation_index
        self._formation_row = hero._formation_index
        self._formation_column = hero._formation_column
        self._team_index = teamIndex

        self._move_dir = hero._move_dir
        self._last_move_dir = hero._last_move_dir

        self._heroBattleObject.attackSpeed = hero._heroBattleObject.attackSpeed
    else
        ___role_coords_status[self._coord_y][self._coord_x] = self

        self._hero_type = self._enum_hero_type._hero
        self._formation_index = formationIndex

        local row = math.modf((self._formation_index - 1) / 3 + 1)
        self._formation_row = row

        self._formation_column = (self._formation_index -  1) % 3 + 1

        local baseName = ""
        baseName = "effect/shadow"
        self._shadow = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        self:addChild(self._shadow)
        self._shadow:setAnimation(0, _spine_effect_animation_names[1], true)

        baseName = "effect/pfeffect_" .. 0
        self._pfeffect = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        self:addChild(self._pfeffect)
        self._pfeffect:setAnimation(0, _spine_effect_animation_names[1], true)
        self._pfeffect:setVisible(false)

        if camp == 1 then
            local sign_type = dms.int(dms["environment_ship"], heroBattleObject.mouldId, environment_ship.sign_type)
            if sign_type == 1 then
                baseName = "effect/camp_" .. camp
                self._camp_effect = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
                self:addChild(self._camp_effect)
                self._camp_effect:setAnimation(0, _spine_effect_animation_names[1], true)
            end
        end
    end
    self:setPosition(startPosition)
    self:setContentSize(cc.size(0, 0))
    
    -- -- 创建精灵绘图 sprite = skeletonNode
    -- local sprite = sp.spine_sprite(self, spriteId, _spine_sprite_animation_names[1], true, nil, nil, cc.p(0.5, 0))
    -- sprite:addAnimation(0, _spine_sprite_animation_names[2], true)
    -- if self._hero_type == self._enum_hero_type._hero then
    --     sprite:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
    -- end

    -- -- spine动画初始化
    -- sp.initArmature(sprite, true)

    -- -- 设置战斗双方 方位
    -- sprite.playWithIndex = function(_self, actionIndex)
    --     if actionIndex > _enum_spine_animation_frame_index.animation_attack_dir_13 
    --         and actionIndex < _enum_spine_animation_frame_index.animation_death 
    --         then
    --         _self:setScaleX(-1)
    --         -- if _self._ui_role_hp ~= nil then
    --         --     _self._ui_role_hp.LoadingBar_bolld:setScaleX(-1)
    --         -- end
    --     else
    --         _self:setScaleX(1)
    --         -- if _self._ui_role_hp ~= nil then
    --         --     _self._ui_role_hp.LoadingBar_bolld:setScaleX(1)
    --         -- end
    --     end
    --     _self:setAnimation(0, _self.animationNameList[actionIndex + 1], true)
    --     if _self.changeActionCallfunc ~= nil then
    --         _self.changeActionCallfunc(_self, nil, nil)
    --     end
    -- end

    -- sprite.animationNameList = _spine_sprite_animation_names

    -- sprite:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)

    -- local actionIndex = _enum_spine_animation_frame_index.animation_standby_dir_1

    -- actionIndex = _enum_spine_animation_frame_index.animation_move_dir_1

    -- csb.animationChangeToAction(sprite, actionIndex, actionIndex, false)

    -- sprite._invoke = self.changeActionCallback
    -- sprite:getAnimation():setFrameEventCallFunc(onFrameEvent)

    -- sprite._self = self

    -- local sprite = self:createSprite(self, spriteId)
    -- sprite._invoke = self.changeActionCallback
    -- sprite:getAnimation():setFrameEventCallFunc(onFrameEvent)

    -- self._sprite = sprite

    -- if self._hero_type == self._enum_hero_type._hero then
    --     sprite = self:createSprite(self, spriteId)
    --     sprite:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
    --     self._sprite_src = sprite
    --     self._sprite.__shader_spx = sprite
    --     sprite._invoke = self.srcchangeActionCallback
    --     sprite:setVisible(false)
    -- end
    self:changeRoleSprite(spriteId)

    if 1 == spriteType then
        local baseName = "sprite/weapon_" .. spriteId
        self._weapon = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        self:addChild(self._weapon)
        self._weapon:setAnimation(0, _spine_sprite_animation_names[actionIndex + 1], true)
    end

    -- self._hp = bullet
    -- self._attack = effect
    
    self._scene = scene
    self._camp = camp
    self._sprite_id = spriteId
    self._start_pos = startPosition
    self._end_pos = endPosition -- cc.p(sceneSize.width - startPosition.x, startPosition.y)
    self._attack_position = attackPosition
    self._reset_position = resetPosition
    self._vector = self._end_pos
    self._move_pos = startPosition
    self._collision_size = cc.size(128, 128) -- self:getContentSize()
    self._range = range
    self._skills = skills
    self._bullet_id = skills[1].bullet
    self._bullet_type = skills[1].bullet_type
    self._effect_id = skills[1].effect

    self._hp_rt = self._hp / self._max_hp

    -- 初始化天赋
    for i=1, #skills do
        local skill = skills[i]
        table.insert(self._talent._skills, skill)

        for m, n in pairs(skill.buffs) do
            self._buff_skills[n.trigger_timing]= self._buff_skills[n.trigger_timing] or {}
            table.insert(self._buff_skills[n.trigger_timing], n)
        end
    end

    -- for i, v in pairs(self._talent._skills) do
    --     for m, n in pairs(v.other) do
    --         self._buff_skills[n.trigger_timing] = self._buff_skills[n.trigger_timing] or {}
    --         table.insert(self._buff_skills[n.trigger_timing], n)
    --     end

    --     for m, n in pairs(v.buffs) do
    --         self._buff_skills[n.trigger_timing]= self._buff_skills[n.trigger_timing] or {}
    --         table.insert(self._buff_skills[n.trigger_timing], n)
    --     end
    -- end

    self._floor_effect_id = skills[1].floor_effect or 0
    self:move(self._move_pos, self._vector)
    -- self._move_state = self._enum_move_state._moving
    self._move_state = self._enum_move_state._join

    if self._camp == 1 then
        -- 设置敌方技能攻击自动
        self._is_skill = true
        self._is_auto = true

        self._move_dir = 3
        self._last_move_dir = 3
    else
        self._is_skill = BattleUI.__is_auto_fight
        self._is_auto = BattleUI.__is_auto_fight
    end
    if self._battle_type == 1 then
        self._is_skill = true
        self._is_auto = true
    end

    local currCell = state_machine.excute("battle_map_add_collision", 0, {object = self, x = self._move_pos.x, y = self._move_pos.y})
    if currCell ~= nil then
        self._cell._curr_node = currCell
        self._cell._last_node = currCell
        self._curr_passable = true
        self._last_passable = true

        self._cell._curr_node._object = self
    end
    self._parent = state_machine.excute("battle_map_add_object", 0, self)
    self._parent_size = self._parent:getContentSize()

    if self._hero_type == self._enum_hero_type._hero then
        if self._camp == 0 then
            state_machine.excute("battle_ui_update_role_hp", 0, {role = self, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp})
            state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = false})
        end
        -- if self._pfeffect ~= nil 
        --     and self._sp >= self._max_sp
        --     then
        --     self._pfeffect:setVisible(true)
        -- end
    end

    local map_cell_size = nil
    if self._hero_type == self._enum_hero_type._hero then
        self._ui_role_hp = state_machine.excute("battle_role_hp", 0, {role = self, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp})
        self:addChild(self._ui_role_hp)
        self._ui_role_hp:showUIRoleHp(self._show_ui_role_hp)

        map_cell_size = battle_enum._map_cell_size2
    else
        map_cell_size = battle_enum._map_cell_size
    end

    -- local s = math.sqrt(map_cell_size._width * map_cell_size._width + map_cell_size._height * map_cell_size._height)
    -- if s > self._range then
    --     self._range = s
    -- end
    if self._move_state == self._enum_move_state._join
        then
        -- self:move(startPosition, endPosition)

        -- -- -- local mp = cc.p((endPosition.x - startPosition.x), (endPosition.y - startPosition.y))
        -- -- local flag = 1
        -- -- if self._camp == 1 then
        -- --     flag = -1
        -- -- end
        -- -- if self._hero_type == self._enum_hero_type._hero
        -- --     then
        -- --     endPosition.y = endPosition.y - flag * (endPosition.y % battle_enum._map_cell_size2._width)
        -- -- else
        -- --     endPosition.y = endPosition.y - flag * (endPosition.y % battle_enum._map_cell_size._width)
        -- -- end

        -- self:moveToFightArena(startPosition, endPosition)

        if self._isPartner ~= true then
            local checkPartner = true
            if self._scene._battle_index > 1 and self._camp == 1 then
                checkPartner = false
            end
            self:move(startPosition, attackPosition)
            self:moveToFightArena(startPosition, attackPosition, checkPartner)
        end
    end

    self._effect_layer = ccui.Layout:create()
    self:addChild(self._effect_layer, _scene_zorder_effect)
    self._sprite._self = self
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	self:setScale(0.85)
    end
    return self
end

function BattleRole:changeRoleSprite(spriteId)
    if nil ~= self._sprite then
        self._sprite:removeFromParent(true)
        self._sprite = nil
    end

    if self._sprite_src ~= nil then
        self._sprite_src:removeFromParent(true)
        self._sprite_src = nil
    end

    local sprite = self:createSprite(self, spriteId)
    sprite._invoke = self.changeActionCallback
    sprite:getAnimation():setFrameEventCallFunc(onFrameEvent)

    self._sprite = sprite

    if self._hero_type == self._enum_hero_type._hero then
        sprite = self:createSprite(self, spriteId)
        sprite:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
        self._sprite_src = sprite
        self._sprite.__shader_spx = sprite
        sprite._invoke = self.srcchangeActionCallback
        sprite:setVisible(false)
    end
    self._sprite_id = spriteId

    if self._attack_pause == true then
        fwin:addService({
            callback = function ( params )
                params._sprite:pause()
                if params._sprite_src ~= nil then
                    params._sprite_src:pause()
                end
            end,
            delay = 0.3,
            params = self
        })
    end
end

function BattleRole:onEnterTransitionFinish()

end

function BattleRole:moving(dt)
    local f = self._angle -- self:getRotation() + 90
    local velocity = self._velocity
    local actionIndex = self._sprite._actionIndex
    if self._targetIndex > -1 and self._vrevolve > 0 then
        velocity = velocity / 30
    end

    local lmPos = self._move_pos
    self._move_pos = cc.p(self:getPosition())

    local cell = nil
    local pos = nil
    local lastX = self._move_pos.x
    local lastY = self._move_pos.y

    local move_pos = self._move_pos

    if self._path == nil or #self._path <= 0 then
        self:search(dt)
        if self._path ~= nil and #self._path > 0 then
            local moveX = self._move_pos.x
            local moveY = self._move_pos.y
            local array = {}
            local t = 0
            if self._cell._curr_node == self._path[1] then
                local tCell = table.remove(self._path, 1)
                if tCell._lineLayer ~= nil then
                    tCell._lineLayer:setVisible(false)
                end
            end

            -- if #self._path > 0 then
            --     local tCell = table.remove(self._path, #self._path)
            --     if tCell._lineLayer ~= nil then
            --         tCell._lineLayer:setVisible(false)
            --     end
            -- end

            -- local path = {}
            -- for i, v in pairs(self._path) do
            --     local b = true
            --     for m, n in pairs(path) do
            --         if n._r == v._r 
            --             and n._c == v._c
            --             then
            --             b = false
            --             break
            --         end
            --     end
            --     if b == true then
            --         table.insert(path, v)
            --     end
            -- end
            -- self:clearPath()
            -- self._path = path

            for i, v in pairs(self._path) do
                local mp = cc.p((v._pos.x - moveX), (v._pos.y - moveY))
                local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
                -- t = t + s / self._velocity * 0.013
                -- table.insert(array, mp)
                t = s / self._velocity * 0.013

                table.insert(array, cc.MoveTo:create(t * __fight_recorder_action_time_speed, v._pos))
                moveX = v._pos.x
                moveY = v._pos.y
                -- print(v._pos.x, v._pos.y)
            end
            
            if #array > 0 then
                self._move_stop = false
                table.insert(array, cc.CallFunc:create(function(sender)
                        sender:clearPath()
                        sender._move_pos = cc.p(sender:getPosition())
                    end))
                local seq = cc.Sequence:create(array)
                seq:setTag(1)
                self:runAction(cc.Sequence:create(array))

                local cell = self._path[1]
                -- self:move(self._move_pos, cell._pos)

                self._last_pos = self._move_pos
            end
        end
    else
        local lastCell, currCell = state_machine.excute("battle_map_update_collision", 0, {object = self, lx = lastX, ly = lastY, mx = move_pos.x, my = move_pos.y})
        local cell = self._path[1]
        if cell._object ~= nil and cell._object ~= self and #self._path > 1 then
            -- print("位置被占用", cell._object)
            -- self:move(self._last_pos, cell._pos)
            self:clearPath()
            self:stopAllActions()
        else
            if lastCell == cell 
                then
                if self._cell._curr_node ~= nil then
                    self._cell._curr_node:setPassable(true)
                    if self._cell._curr_node._lineLayer ~= nil then
                        self._cell._curr_node._lineLayer:setVisible(false)
                    end
                    self._cell._curr_node._object = nil
                end
                self._cell._curr_node = cell
                self._cell._curr_node._object = false

                self._cell._curr_node:setPassable(false)
                if #self._path > 1 then
                    table.remove(self._path, 1)
                    cell = self._path[1]
                    self:move(self._last_pos, cell._pos)
                    self._last_pos = cell._pos
                end
            else
                -- self:move(self._last_pos, self._move_pos)
            end

            -- self:move(self._move_pos, self._cell._curr_node._pos)
            -- self:move(lmPos, self._move_pos)
        end
    end
end

function BattleRole:moving_ex(dt)
    -- print("寻找目标移动:", self._shipName, self._moving, self._by_lock)
    if self._moving == false 
        and self._by_lock == false
        then
        local last__target_coord_y = self._coord_y
        local mspace = math.abs(self._byLockAttackTarget._coord_y - self._coord_y)
        print("寻找目标移动:", self._shipName, self._coord_y, self._coord_x, self._byLockAttackTarget._shipName, 
            self._byLockAttackTarget._coord_y, self._byLockAttackTarget._coord_x, self._range, mspace)
        if self._range < mspace then
            local by_attack_target_coord_x = self._byLockAttackTarget._coord_x
            local by_attack_target_coord_y = self._byLockAttackTarget._coord_y
            
            local flag = 1
            if self._byLockAttackTarget._camp == 1 then
                flag = -1
            end
            for i = 1, 31 do
                local calc_coord_y = self._coord_y - flag * i
                print("计算移动方格数量", calc_coord_y, by_attack_target_coord_y)
                local role = ___role_coords_status[calc_coord_y][by_attack_target_coord_x]
                local tspace = math.abs(calc_coord_y - by_attack_target_coord_y)
                if self._range == 0 then
                    last__target_coord_y = by_attack_target_coord_y + flag * i
                    break
                else
                    last__target_coord_y = calc_coord_y
                    if tspace <= self._range then
                        break
                    end
                end
            end
        elseif self._range > 1 then
            self._start_attack = true
            return
        end

        -- local lcount = math.abs(self._attack_coord_y - self._coord_y)
        -- local mcount = (self._formation_row_b - 1) * 2--last__target_coord_y --
        -- if lcount > mcount then
        --     print("需要移动攻击阵列:", lcount, self._formation_row_b, self._camp, self._attack_coord_y)
        --     local target_coord_x = self._coord_x
        --     local coord_xs = nil
        --     if self._attack_coord_x > target_coord_x then
        --         coord_xs = {target_coord_x + 1, target_coord_x, target_coord_x - 1}
        --     elseif self._attack_coord_x < target_coord_x then
        --         coord_xs = {target_coord_x - 1, target_coord_x, target_coord_x + 1}
        --     else
        --     end
        --     coord_xs = {target_coord_x, target_coord_x - 1, target_coord_x + 1}
        --     local coord_y = 0
        --     local coord_x = 0
        --     local flag = 1
        --     if self._camp == 0 then
        --         flag = -1
        --     end
        --     for i, v in pairs(coord_xs) do
        --         if v > 0 and v < 8 then
        --             local mx = math.abs(target_coord_x - v)
        --             if mx < 2 then
        --                 local role = ___role_coords_status[self._attack_coord_y + flag * mcount][v]
        --                 if role == nil then
        --                     if coord_y == 0 then
        --                         coord_y = self._attack_coord_y + flag * mcount
        --                         coord_x = v
        --                         print("可以移动：", self._shipName, coord_y, coord_x, self._coord_y, self._coord_x)
        --                         break
        --                     end
        --                 end
        --             end
        --         end
        --     end
        --     if coord_y == 0 then
        --         print("没有地方可以移动阵列：", self._shipName)
        --     else
        --         -- 锁定目标
        --         self._byLockAttackTarget._by_lock = true
        --         self._moving = true
        --         local mcoord_x = coord_x - self._coord_x
        --         if coord_x ~= self._coord_x then
        --             self._pos_v =  ___role_coords[coord_y][coord_x]

        --             local moveDir = self._move_dir
        --             self:move(___role_coords[self._coord_y][coord_x], self._pos_v)
        --             local moveDir2 = self._move_dir
                    
        --             self:moveToAttackNextLine(___role_coords[self._coord_y][coord_x])

        --             local moveInfo = {}
        --             moveInfo.coord_y = self._coord_y
        --             moveInfo.coord_x = self._coord_x
        --             moveInfo.move_dir = self._move_dir
        --             moveInfo.speed = 1.0
        --             table.insert(self._follow_path, moveInfo)

        --             moveInfo = {}
        --             moveInfo.coord_y = self._coord_y
        --             moveInfo.coord_x = coord_x
        --             moveInfo.move_dir = self._move_dir
        --             moveInfo.speed = 1.0
        --             table.insert(self._follow_path, moveInfo)

        --             moveInfo = {}
        --             moveInfo.coord_y = self._coord_y
        --             moveInfo.coord_x = coord_x
        --             moveInfo.move_dir = moveDir2
        --             moveInfo.speed = 1.0
        --             table.insert(self._follow_path, moveInfo)

        --             moveInfo = {}
        --             moveInfo.coord_y = coord_y
        --             moveInfo.coord_x = coord_x
        --             moveInfo.move_dir = moveDir2
        --             moveInfo.speed = 1.0
        --             table.insert(self._follow_path, moveInfo)

        --             self:teamFollowEX()

        --             if self._follow == true then
        --                 self:teamFollow(self._coord_y, coord_x)
        --             end
        --         else
        --             self:moveToAttackNextLine(___role_coords[coord_y][coord_x])
                    
        --             local moveInfo = {}
        --             moveInfo.coord_y = coord_y
        --             moveInfo.coord_x = coord_x
        --             moveInfo.move_dir = self._move_dir
        --             moveInfo.speed = 1.0
        --             table.insert(self._follow_path, moveInfo)
        --             self:teamFollowEX()

        --             if self._follow == true then
        --                 self:teamFollow(coord_y, coord_x)
        --             end
        --         end
        --         self:changeToAttackCoord(coord_y, coord_x)
        --         print("移动阵列：", self._shipName)
        --     end
        --     return
        -- end

        -- if self._range > 100 then
        --     print("远程英雄暂未处理：", self._shipName)
        --     self._moving = true
        --     self._start_attack = true
        --     return
        -- end

        -- print("锁定目标:", self._shipName, self._byLockAttackTarget._shipName, self._byLockAttackTarget._formation_row, self._byLockAttackTarget._formation_column)

        local target_coord_x = self._byLockAttackTarget._coord_x
        local coord_xs = nil
        if self._coord_x > target_coord_x then
            coord_xs = {target_coord_x + 1, target_coord_x, target_coord_x - 1}
        elseif self._coord_x < target_coord_x then
            coord_xs = {target_coord_x - 1, target_coord_x, target_coord_x + 1}
        else
            coord_xs = {target_coord_x, target_coord_x - 1, target_coord_x + 1}
        end
        if self._range > 1 then
            coord_xs = {self._coord_x, self._coord_x - 1, self._coord_x + 1, self._coord_x - 2, self._coord_x + 2}
        end
        local coord_y = 0
        local coord_x = 0
        for i, v in pairs(coord_xs) do
            if v > 0 and v < 8 then
                local mx = math.abs(target_coord_x - v)
                if mx < 2 then
                    local role = ___role_coords_status[last__target_coord_y][v]
                    if role == self then
                        self._start_attack = true
                        print("可以开始攻击：", self._shipName)
                        break
                    elseif role == nil then
                        if coord_y == 0 then
                            coord_y = last__target_coord_y--self._attack_coord_y
                            coord_x = v
                            local pos1 = ___role_coords[coord_y][coord_x]
                            local pos2 = ___role_coords[self._coord_y][self._coord_x]
                            print("可以移动：", self._shipName, coord_y, coord_x, 
                                pos1.x, pos1.y, self._coord_y, self._coord_x, pos2.x, pos2.y)
                        end
                    else
                        print("位置被占用：", self._shipName)
                    end
                end
            end
        end

        if self._start_attack == true then

        else
            if coord_y == 0 then
                print("没有地方可以移动：", self._shipName)
            else
                -- 锁定目标
                self._byLockAttackTarget._by_lock = true
                self._by_lock = true
                self._moving = true
                local mcoord_x = coord_x - self._coord_x
                if coord_y ~= self._coord_y then
                    self._pos_v =  ___role_coords[coord_y][coord_x]

                    local moveDir = self._move_dir
                    self:move(___role_coords[coord_y][self._coord_x], self._pos_v)
                    local moveDir2 = self._move_dir

                    local endPos = ___role_coords[coord_y][self._coord_x]
                    local beginPos = cc.p(self:getPosition())
                    print("开始移动：", self._shipName, endPos.x, endPos.y, beginPos.x, beginPos.y)
                    self:moveToByAttackTarget(endPos, math.abs(self._coord_y - coord_y))

                    local moveInfo = {}
                    moveInfo.coord_y = self._coord_y
                    moveInfo.coord_x = self._coord_x
                    moveInfo.move_dir = self._move_dir
                    moveInfo.speed = 0.85
                    table.insert(self._follow_path, moveInfo)

                    moveInfo = {}
                    moveInfo.coord_y = coord_y
                    moveInfo.coord_x = self._coord_x
                    moveInfo.move_dir = self._move_dir
                    moveInfo.speed = 0.85
                    table.insert(self._follow_path, moveInfo)

                    moveInfo = {}
                    moveInfo.coord_y = coord_y
                    moveInfo.coord_x = self._coord_x
                    moveInfo.move_dir = moveDir2
                    moveInfo.speed = 0.85
                    table.insert(self._follow_path, moveInfo)

                    moveInfo = {}
                    moveInfo.coord_y = coord_y
                    moveInfo.coord_x = coord_x
                    moveInfo.move_dir = moveDir2
                    moveInfo.speed = 0.85
                    table.insert(self._follow_path, moveInfo)

                    self:teamFollowEX()

                    -- if self._follow == true then
                    --     self:teamFollow(self._coord_y, coord_x)
                    -- end
                else
                    self:move(___role_coords[self._coord_y][self._coord_x], ___role_coords[coord_y][coord_x])

                    local endPos = ___role_coords[coord_y][self._coord_x]
                    local beginPos = cc.p(self:getPosition())
                    print("开始移动11111：", self._shipName, endPos.x, endPos.y, beginPos.x, beginPos.y)
                    self:moveToByAttackTarget(___role_coords[coord_y][coord_x], math.abs(self._coord_x - coord_x)/0.8)

                    local moveInfo = {}
                    moveInfo.coord_y = coord_y
                    moveInfo.coord_x = coord_x
                    moveInfo.move_dir = self._move_dir
                    moveInfo.speed = 0.85
                    table.insert(self._follow_path, moveInfo)
                    self:teamFollowEX()

                    if self._follow == true then
                        self:teamFollow(coord_y, coord_x)
                    end
                end
                self:changeToAttackCoord(coord_y, coord_x)
            end
        end


        -- local target_coord_x = self._byLockAttackTarget._coord_x
        -- local target_coord_y = self._byLockAttackTarget._coord_y
        -- local coord_x = 0
        -- local coord_y = 0

        -- -- 处理换线
        -- local lcount = target_coord_y - self._attack_coord_y
        -- if math.abs(lcount) > 1 then
        --     state_machine.excute("battle_scene_change_camp_attack_line", 0, {role = self, camp = self._camp, mcount = lcount})
        -- end

        -- self._moving = true
        -- local pos_v = ___role_coords[self._attack_coord_y][self._attack_coord_x]
        -- self:moveToByAttackTarget(pos_v)

        -- local coord_xs = {target_coord_x, target_coord_x - 1, target_coord_x + 1}
        -- if self._attack_coord_x == self._coord_x 
        --     and self._attack_coord_y == self._coord_y
        --     then
        --     -- self._start_attack = true
        -- else
        --     if self._range <= 100 then

        --     else

        --     end
        -- end

        -- self._move_pos = cc.p(self:getPosition())
        -- local pos_h = ___role_coords[self._coord_y][self._byLockAttackTarget._coord_x]
        -- local pos_v = nil
        -- local coord_x = 0
        -- local coord_y = 0

        -- if self._range <= 100 then
        --     if self._byLockAttackTarget._camp == 0 then
        --         coord_y = self._byLockAttackTarget._coord_y + 1
        --         coord_x = self._byLockAttackTarget._coord_x
        --         pos_v = ___role_coords[coord_y][coord_x]
        --     else

        --         coord_y = self._byLockAttackTarget._coord_y - 1
        --         coord_x = self._byLockAttackTarget._coord_x
        --         pos_v = ___role_coords[coord_y][coord_x]
        --     end
        -- else
        --     if self._byLockAttackTarget._camp == 0 then
        --         coord_y = self._coord_y - 1
        --         coord_x = self._coord_x
        --         pos_v = ___role_coords[coord_y][coord_x]
        --     else
        --         coord_y = self._coord_y + 1
        --         coord_x = self._coord_x
        --         pos_v = ___role_coords[coord_y][coord_x]
        --     end
        --     pos_h = pos_v
        --     pos_v = nil
        -- end

        -- if self._coord_y == coord_y 
        --     and self._coord_x == coord_x 
        --     then
        --     -- self:moving()
        --     self._start_attack = true
        -- else
        --     if self._range <= 100 then
        --         self._byLockAttackTarget._by_lock = true
        --     end

        --     if ___role_coords_status[coord_y][coord_x] > -1 then
        --         coord_x = coord_x - 1
        --     end
        --     if ___role_coords_status[coord_y][coord_x] > -1 then
        --         coord_x = coord_x + 2
        --     end
        --     if ___role_coords_status[coord_y][coord_x] > -1 then
        --         print("位置被占用", self._shipName, self._sprite_id, self._coord_x, self._coord_y, self._camp)
        --         return
        --     end
        --     if ___role_coords_status[coord_y][coord_x] == nil then
        --         return
        --     end

        --     self._moving = true
        --     if self._range <= 100 then
        --         pos_v = ___role_coords[coord_y][coord_x]
        --     else
        --         pos_v = ___role_coords[coord_y][coord_x]
        --         pos_h = pos_v
        --         pos_v = nil
        --     end

        --     if pos_v ~= nil then
        --         if pos_h.x == pos_v.x
        --             and pos_h.y == pos_v.y
        --             then
        --             pos_v = nil
        --         end
        --     end
        --     ___role_coords_status[self._coord_y][self._coord_x] = -1

        --     self._coord_y = coord_y
        --     self._coord_x = coord_x
        --     self._pos_h = pos_h
        --     self._pos_v =  pos_v

        --     ___role_coords_status[self._coord_y][self._coord_x] = self._camp
        --     -- print(self._shipName, self._sprite_id, self._coord_x, self._coord_y)
        --     self:moveToByAttackTarget(pos_h)
        -- end
    end
end

function BattleRole:moving_cell(dt)
    if self._moving == false 
        and self._by_lock == false
        then
        self._moving = true

        -- local coord_y = self._coord_y
        -- local coord_x = self._coord_x
        -- if coord_y > self._byLockAttackTarget._coord_y then
        --     coord_y = coord_y - 1
        -- end
        -- if coord_y < self._byLockAttackTarget._coord_y then
        --     coord_y = coord_y + 1
        -- end
        -- -- if coord_x > self._byLockAttackTarget._coord_x then
        -- --     coord_x = coord_x - 1
        -- -- end
        -- -- if coord_x < self._byLockAttackTarget._coord_x then
        -- --     coord_x = coord_x + 1
        -- -- end
        -- self:changeToAttackCoord(coord_y, coord_x)
        -- local vector = ___role_coords[coord_y][coord_x]
        -- self._move_pos = cc.p(self:getPosition())
        -- self:move(self._move_pos, vector)

        -- local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
        -- local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
        -- local t = s / self._velocity * 0.013
        -- self:runAction(cc.Sequence:create({cc.MoveTo:create(t, vector), cc.CallFunc:create(function(sender)
        --     -- print("移动结束:", sender._shipName, sender._sprite_id)
        --     -- if sender._move_state == sender._enum_move_state._join then
        --     --     local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
        --     --     actionIndex = actionIndex * _spine_sprite_animation_team_count
        --     --     csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
        --     --     sender._sprite._nextAction = actionIndex
        --     -- else
        --     --     if state_machine.excute("battle_scene_start_attack", 0, {sender, false}) == true then
        --     --         -->>print("可以进行攻击了。", sender._shipName, self._sprite_id)
        --     --         sender._unlock_attack = true
        --     --         sender._run_state = sender._enum_run_state._run
        --     --         -- sender._run_state = sender._enum_run_state._wait
        --     --         sender._move_state = sender._enum_move_state._moving
        --     --     else
        --     --         local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
        --     --         actionIndex = actionIndex * _spine_sprite_animation_team_count
        --     --         csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
        --     --         sender._sprite._nextAction = actionIndex
        --     --     end
        --     -- end
        -- end)}))

        self:moving_cell_y(dt)
    end
end

function BattleRole:moving_cell_x(dt)
    self._moving = true
    local coord_y = self._coord_y
    local coord_x = self._coord_x

    if ___role_coords_status[coord_y][coord_x] == nil then
        self:changeToAttackCoord(coord_y, coord_x)
    end

    if self._camp == 1 then
        self._by_lock = true
    else
        if self._byLockAttackTarget._camp == 1 then
            self._byLockAttackTarget._by_lock = true
        end
    end
    if (math.abs(coord_x - self._byLockAttackTarget._coord_x) <= 1 or self._range > 2)
        and ___role_coords_status[coord_y][coord_x] == self
        then
        -- self._move_pos = cc.p(self:getPosition())
        -- self:move(self._move_pos, self._end_pos)
        local endPos = ___role_coords[self._byLockAttackTarget._coord_y][self._coord_x]
        if self._byLockAttackTarget2 == self._byLockAttackTarget then
        else
            self:move(self._move_pos, endPos)
            local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count)
            actionIndex = actionIndex * _spine_sprite_animation_team_count
            csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            self._sprite._nextAction = actionIndex
        end
            
        self._byLockAttackTarget._by_lock = false
        self._moving = false 
        self._by_lock = false
        -- self._start_attack = true
        self._byLockAttackTarget2 = self._byLockAttackTarget

        local moveInfo = {}
        moveInfo.coord_y = coord_y
        moveInfo.coord_x = coord_x
        moveInfo.move_dir = self._move_dir
        moveInfo.speed = 0.85
        table.insert(self._follow_path, moveInfo)
        self:teamFollowCell()

        -- print(self._camp, self._shipName, self._coord_y, self._coord_x, self._range)
        if self._run_state == self._enum_run_state._lock_attack then
            -- print(self._camp, self._shipName, self._coord_y, self._coord_x)
            self._run_state = self._enum_run_state._run
            self._move_state = self._enum_move_state._join
            if self._attack_wait_cd ~= nil then
                state_machine.excute("battle_scene_get_attack_wait_cd", 0, {self})
            end
            state_machine.excute("battle_scene_check_start_attack", 0, self._camp)
            -- print("1111111:", self._camp, self._shipName, self._coord_y, self._coord_x, self._byLockAttackTarget._camp, self._byLockAttackTarget._shipName, self._byLockAttackTarget._coord_y, self._byLockAttackTarget._coord_x)
        else
            self._start_attack = true
            -- print("2222222:", self._camp, self._shipName, self._coord_y, self._coord_x, self._byLockAttackTarget._camp, self._byLockAttackTarget._shipName, self._byLockAttackTarget._coord_y, self._byLockAttackTarget._coord_x)
        end
    else
        -- if coord_x > self._byLockAttackTarget._coord_x then
        --     coord_x = coord_x - 1
        -- end
        -- if coord_x < self._byLockAttackTarget._coord_x then
        --     coord_x = coord_x + 1
        -- end
        local r, cy, cx = self:finding(self._byLockAttackTarget)
        if r then
            coord_x = cx
            coord_y = cy

            if coord_x > self._coord_x then
                coord_x = self._coord_x + 1
            else
                coord_x = self._coord_x - 1
            end

            self:changeToAttackCoord(coord_y, coord_x)
            local vector = ___role_coords[coord_y][coord_x]
            self._move_pos = cc.p(self:getPosition())
            self:move(self._move_pos, vector)

            local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
            local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
            local t = s / self._velocity * 0.013
            self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector), cc.CallFunc:create(function(sender)
                sender._moving = false
                local lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {sender, sender._camp})
                sender._byLockAttackTarget = lockAttackTarget
                if nil ~= lockAttackTarget and lockAttackTarget._death == false then
                    sender:moving_cell_x(0)
                end
            end)}))

            local moveInfo = {}
            moveInfo.coord_y = coord_y
            moveInfo.coord_x = coord_x
            moveInfo.move_dir = self._move_dir
            moveInfo.speed = 0.85
            table.insert(self._follow_path, moveInfo)
            self:teamFollowCell()
        else
            self._by_lock = false
            self._moving = false
            self._byLockAttackTarget._by_lock = false
            self._byLockAttackTarget = nil
            self._byAttackTarget = nil

            if self._run_state == self._enum_run_state._lock_attack then
                self._run_state = self._enum_run_state._run
                self._move_state = self._enum_move_state._join
                -- if self._camp == 0 then
                if self._attack_wait_cd ~= nil then
                    state_machine.excute("battle_scene_get_attack_wait_cd", 0, {self})
                end
                    state_machine.excute("battle_scene_check_start_attack", 0, 0)
                -- end
            else
                self._start_attack = true
                -- print("3333333:", self._camp, self._shipName, self._coord_y, self._coord_x, self._byLockAttackTarget._camp, self._byLockAttackTarget._shipName, self._byLockAttackTarget._coord_y, self._byLockAttackTarget._coord_x)
            end
        end
    end
end

function BattleRole:moving_cell_y(dt)
    self._moving = true
    local coord_y = self._coord_y
    local coord_x = self._coord_x
    if math.abs(coord_y - self._byLockAttackTarget._coord_y) <= self._range then
        if nil ~= self._byLockAttackTarget and self._byLockAttackTarget._death == false then
            if self._by_lock == false and (self._camp == 0 or self._byLockAttackTarget._range <= 2 or (self._camp == 1 and self._byLockAttackTarget._range > 2))
                then
                self:moving_cell_x(0)
            else
                if self._camp == 1 then
                    self._by_lock = true
                end

                self._moving = false
                local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count)
                actionIndex = actionIndex * _spine_sprite_animation_team_count
                csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
                self._sprite._nextAction = actionIndex

                if self._run_state == self._enum_run_state._lock_attack then
                    self._run_state = self._enum_run_state._run
                    self._move_state = self._enum_move_state._join
                    if self._attack_wait_cd ~= nil then
                        state_machine.excute("battle_scene_get_attack_wait_cd", 0, {self})
                    end
                    state_machine.excute("battle_scene_check_start_attack", 0, self._camp)
                end
            end
        end
    else
        if coord_y > self._byLockAttackTarget._coord_y then
            coord_y = coord_y - 1
            -- if coord_y < self._attack_coord_y then
            --     self._moving = false
            --     if nil ~= self._byLockAttackTarget and self._byLockAttackTarget._death == false then
            --         self:moving_cell_x(0)
            --     end
            --     return
            -- end
        end
        if coord_y < self._byLockAttackTarget._coord_y then
            coord_y = coord_y + 1
            -- if coord_y > self._attack_coord_y then
            --     self._moving = false
            --     if nil ~= self._byLockAttackTarget and self._byLockAttackTarget._death == false then
            --         self:moving_cell_x(0)
            --     end
            --     return
            -- end
        end

        self:changeToAttackCoord(coord_y, coord_x)
        local vector = ___role_coords[coord_y][coord_x]
        self._move_pos = cc.p(self:getPosition())
        self:move(self._move_pos, vector)

        local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
        local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
        local t = s / self._velocity * 0.013
        self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector), cc.CallFunc:create(function(sender)
            sender._moving = false
            local lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {sender, sender._camp})
            sender._byLockAttackTarget = lockAttackTarget
            if nil ~= lockAttackTarget and lockAttackTarget._death == false then
                sender:moving_cell_y(0)
            end
        end)}))

        local moveInfo = {}
        moveInfo.coord_y = coord_y
        moveInfo.coord_x = coord_x
        moveInfo.move_dir = self._move_dir
        moveInfo.speed = 0.85
        table.insert(self._follow_path, moveInfo)
        self:teamFollowCell()
    end

    -- local target_coord_y = self._byLockAttackTarget._coord_y
    -- local target_coord_x = self._byLockAttackTarget._coord_x
    -- if coord_y > target_coord_y then
    --     target_coord_y = target_coord_y + 1
    -- end
    -- if coord_y < target_coord_y then
    --     target_coord_y = target_coord_y - 1
    -- end
    -- ___role_coords_map:finding(2, coord_x, coord_y, target_coord_x target_coord_y)
end

function BattleRole:fristMoveCoordXY( target, targetMoveY )
    local target_coord_x = target._coord_x
    local coord_xs = nil
    if self._coord_x > target_coord_x then
        coord_xs = {target_coord_x + 1, target_coord_x, target_coord_x - 1}
    elseif self._coord_x < target_coord_x then
        coord_xs = {target_coord_x - 1, target_coord_x, target_coord_x + 1}
    else
        coord_xs = {target_coord_x, target_coord_x - 1, target_coord_x + 1}
    end
    local coord_y = 0
    local coord_x = 0
    if self._range > 1 then
        coord_xs = {self._coord_x, self._coord_x - 1, self._coord_x + 1, self._coord_x - 2, self._coord_x + 2, }
        for i, v in pairs(coord_xs) do
            if v > 0 and v < 8 then
                local role = ___role_coords_status[targetMoveY][v]
                if role == nil or (role ~= nil and role == self) then
                    coord_y = targetMoveY
                    coord_x = v
                    break
                end
            end
        end
    else
        for i, v in pairs(coord_xs) do
            if v > 0 and v < 8 then
                local mx = math.abs(target_coord_x - v)
                if mx < 2 then
                    local role = ___role_coords_status[targetMoveY][v]
                    if role == nil then
                        coord_y = targetMoveY
                        coord_x = v
                        break
                    end
                end
            end
        end
    end
    return coord_x, coord_y
end

-- 移动到指定地点
function BattleRole:moveToAttackPosition(vector)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013 / 3

    self._attackMoveShadow = true 
    self._ghostCount = 1
    self._ghostIndex = 0
    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector), cc.CallFunc:create(function(sender)
        sender:atartAttackTarget()
        sender._attackMoveShadow = false
    end)}))
    return t
end

function BattleRole:atartAttackTarget()
    self:checkAttackType()
    self:checkAttack(self._start_pos, self._end_pos)

    if self._hero_type == self._enum_hero_type._dogface then
        local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count
        self._sprite._nextAction = self._sprite._actionIndex
    end
end

function BattleRole:attackTarget(byAttackTarget)
    self._path = {}
    self._byAttackTarget = byAttackTarget
    self._attacking = true
    self:clearPath()
    self:stopAllActions()

    self._byAttackTargetPosition = cc.p(byAttackTarget:getPosition())

    if nil ~= self._resetAttackTargetPosition then
        self:setPosition(self._resetAttackTargetPosition)
    end

    if self._run_state == self._enum_run_state._sleep then
        self._wait_attacking = true
        local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count
        csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
        return
    end

    self:beforeCheckAttackType()
    local mcoord_y = math.abs(self._coord_y - byAttackTarget._coord_y)
    -- local mcoord_x = math.abs(self._coord_x - byAttackTarget._coord_x)
    if mcoord_y > 2 then
        local skill_release_position = dms.atoi(self._current_skill.skill_element, skill_mould.skill_release_position)
        if skill_release_position == 1 
            -- or self._range > 2 
            then
            local coord_x = byAttackTarget._coord_x
            local coord_y = byAttackTarget._coord_y
            if byAttackTarget._camp == 0 then
                coord_y = coord_y + 2
            else
                coord_y = coord_y - 2
            end
            self._moveAttackTargetPosition = cc.p(___role_coords[coord_y][coord_x].x, ___role_coords[coord_y][coord_x].y)
            self._resetAttackTargetPosition = cc.p(self:getPosition())
            -- self:setPosition(self._moveAttackTargetPosition)
            self:moveToAttackPosition(self._moveAttackTargetPosition)
            return
        end
    end

    self:atartAttackTarget()

-- --             self._path = {}
-- --             self._byAttackTarget = byAttackTarget
-- --             self._attacking = true
-- --             self:clearPath()
-- --             self:stopAllActions()
--     -- -- self:move(cc.p(self:getPosition()), cc.p(byAttackTarget:getPosition()))
--     self:checkAttackType()
--     -- self:checkAttack(cc.p(self:getPosition()), cc.p(byAttackTarget:getPosition()))
--     self:checkAttack(self._start_pos, self._end_pos)

--     if self._hero_type == self._enum_hero_type._dogface then
--         local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count
--         self._sprite._nextAction = self._sprite._actionIndex
--     end

--     -- local actionIndex = self._sprite._actionIndex % _spine_sprite_animation_team_count

--     -- -- actionIndex 0 待机 1移动
--     -- -- 将状态切至攻击状态 _attack_type 0为普攻 1为技能
--     -- if actionIndex == 0 then
--     --     actionIndex = self._sprite._actionIndex + 2 + self._attack_type
--     --     csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
--     -- elseif actionIndex == 1 then
--     --     actionIndex = self._sprite._actionIndex + 1 + self._attack_type
--     --     csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
--     -- else
--     --     self._sprite._nextAction = self._sprite._actionIndex
--     -- end
end

function BattleRole:__reorderChild()
    if self._lock_screen == true then
        self._parent:reorderChild(self, _scene_zorder_object_effect_layer + ((fwin._height - self._move_pos.y) * fwin._width + self._move_pos.x))
    else
        -- self._parent:reorderChild(self, (fwin._height - self._move_pos.y) * fwin._width + self._move_pos.x)
        if self._parent_size == nil then
            -- TODO..主公技
            self._parent:reorderChild(self, 1000000)
        else
            self._parent:reorderChild(self, -1 * self._move_pos.y * self._parent_size.height + self._move_pos.x)
        end
    end
end

-- 定时器处理移动和寻找战斗目标逻辑 
function BattleRole:onUpdate(dt)
    self._move_pos = cc.p(self:getPosition())
    self:__reorderChild()

    -- if self._hero_type == self._enum_hero_type._hero 
    --     and self._camp == 1 
        -- and self._shipName == "蒙古精锐"
        -- and tonumber(self._formation_index) == 9 
    --     then
    --     print("----------------------------------", self._shipName, self._camp)
    --     print("self._sprite_id:",                   self._sprite_id)
    --     print("self._byAttackTarget:",              self._byAttackTarget)
    --     print("self._byLockAttackTarget:",          self._byLockAttackTarget)
    --     print("self._attacking:",                   self._attacking)
    --     print("self._run_state:",                   self._run_state)
    --     print("self._sleep_cd:",                    self._sleep_cd)
    --     print("self._move_state:",                  self._move_state)
    --     print("self._hero_type:",                   self._hero_type)
    --     print("self._moving:",                      self._moving)
    --     print("self._by_lock:",                     self._by_lock)
    --     print("self._start_attack:",                self._start_attack)
    --     print("self._death:",                       self._death)
    --     print("self._resetAttackTargetPosition:",   self._resetAttackTargetPosition)
    --     print("self._dizziness:",                   self._dizziness)
    --     print("self._attack_pause:",                self._attack_pause)
    --     print("self._stop_attack_count:",           self._stop_attack_count)
    --     print("self._attack_wait_cd:",              self._attack_wait_cd)
    --     print("self._wait_attacking:",              self._wait_attacking)
    --     print("self._moving:",                      self._moving)
    --     print("self._by_lock:",                     self._by_lock)
    --     print("self._formation_index:",             self._formation_index)
    -- end

    if self._change_dir == true then
        -- self:move(self._move_pos, self._target_pos)
        self:move(self._move_pos, cc.p(self._hero:getPosition()))
        return
    end

    if self._move_state == self._enum_move_state._join
        then
        return
    end

    -- buff
    local nCount = #self._buffs
    for i=1, nCount do
        local index = nCount - i + 1
        local v = self._buffs[index]
        if v ~= nil and v.onUpdate ~= nil then
            v:onUpdate(dt)
        end
    end
    
    if self._def_timer > 0 then
        self._def_timer = self._def_timer - dt
        if self._def_timer <= 0 then
            -- self._sprite:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))

            if self._sprite_src ~= nil and self._sprite.__shader_spx_need_visible == true then
                self._sprite.__shader_spx_need_visible = false
                self._sprite_src:setVisible(false)
            end
        end
    end

    if self._rect == nil then
        self._rect = self._sprite:getBoundingBox()
    end

    if self._attackMoveShadow == true then
        if self._ghostIndex % self._ghostCount == 0 then
            self.parent = self._parent
            ShadowUtil_addGhost_mode4(self._sprite, self._parent, self._move_pos.x, self._move_pos.y, true)
            self.parent = nil
            -- if self._ghostCount > 1 then
            --     self._ghostCount = self._ghostCount - 1
            -- end
        end
        self._ghostIndex = self._ghostIndex + 1
    end

    if self._death == true 
        or self._byAttackTarget ~= nil 
        or self._attacking == true
        or self._stop_attack_count > 0
        or self._attack_pause == true
        or self._dizziness == true
        or self._resetAttackTargetPosition ~= nil
        then
        if self._run_state == self._enum_run_state._sleep or self._sleep_cd > 0 then
            self._sleep_cd = self._sleep_cd - dt
        end
        return
    end

    if self._show_ui_role_hp_timer > 0 then
        self._show_ui_role_hp_timer = self._show_ui_role_hp_timer - dt
        if self._show_ui_role_hp_timer <= 0 then
            self._show_ui_role_hp_timer = 0
            self._show_ui_role_hp = false
            self._ui_role_hp:showUIRoleHp(self._show_ui_role_hp)
        end
    end

    if self._start_attack and nil ~= self._attack_wait_cd then
        self._attack_wait_cd = self._attack_wait_cd - dt
    end

    if self._run_state == self._enum_run_state._sleep or self._sleep_cd > 0 then
        self._sleep_cd = self._sleep_cd - dt

        if self._is_auto == true
            and (self._camp == 0 or (self._battle_type == 1 and self._camp == 1))
            and decryptInfo(self._sp) >= decryptInfo(self._max_sp)
            then
            -- self._attack_wait_cd = 0
            self._sleep_cd = 0
        end

        if self._sleep_cd <= 0 then
            self._sleep_cd = 0
            self._run_state = self._enum_run_state._run

            if self._wait_attacking == true then
                self._wait_attacking = false

                local byAttackTarget = self._byLockAttackTarget--._byAttackTarget
                if nil ~= byAttackTarget
                    and byAttackTarget._death == false then
                    self:checkAttackType()
                    self:checkAttack(cc.p(self:getPosition()), cc.p(byAttackTarget:getPosition()))
                else
                    self._byAttackTarget = nil
                end
            end
        else
            if self._wait_attacking == false 
                and self._start_attack == true
                then
                return
            end
        end
    end

    if self._start_attack == true
        and self._attack_wait_cd ~= nil 
        and self._attack_wait_cd > 0
        and self._run_state == self._enum_run_state._run
        and self._byAttackTarget == nil
        then
        self._start_attack = false
        self._byLockAttackTarget2 = nil
        self:onSleep(true)
    end

    if self._move_state == self._enum_move_state._wait 
        or self._run_state == self._enum_run_state._lock_attack
        or self._moving == true 
        or self._by_lock == true
        then
        return
    end
 --    local lockAttackTarget, space, mspace

    -- --小兵在主角存在的时候跟主角打同一个目标
    -- if self._hero_type == self._enum_hero_type._dogface 
 --        and self._hero ~= nil 
 --        -- and self._hero._death == false 
 --        and self._hero._byLockAttackTarget ~= nil
 --        then
 --        self._byLockAttackTarget = self._hero._byLockAttackTarget
 --        if self._byLockAttackTarget._death == true then
 --            self._byLockAttackTarget = nil
 --            self._hero._byLockAttackTarget = nil
 --        end
    -- end

 --    if self._byLockAttackTarget == nil 
 --        or self._byLockAttackTarget._death 
 --        then
 --        lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {self, self._camp})
 --        if lockAttackTarget ~= nil 
 --            and lockAttackTarget._death == true 
 --            then
 --            lockAttackTarget= nil
 --        end
 --        self._byLockAttackTarget = lockAttackTarget
 --    end

 --    if self._byLockAttackTarget ~= nil
 --        and self._hero ~= nil 
 --        and self._hero._death == false
 --        and self._hero._byLockAttackTarget == nil
 --        then
 --        self._hero._byLockAttackTarget = self._byLockAttackTarget
 --    end

    local lockAttackTarget, space, mspace = self:checkByAttacker()

    -- 根据距离判断是否攻击，不能则进行移动
    local byAttackTarget = nil
    -- if self._hero_type == self._enum_hero_type._dogface 
    --     and self._hero._follow == false
    --     then
    --     lockAttackTarget = self._hero._byLockAttackTarget
    --     self._byLockAttackTarget = self._hero._byLockAttackTarget
    --     self._start_attack = true
    -- end
    if self._hero_type == self._enum_hero_type._hero 
        and self._byLockAttackTarget ~= nil 
        and self._byLockAttackTarget._death == false
        then
        if mspace == nil then
            _, space, mspace = self._byLockAttackTarget:lockByAttack(self)
        end
        if self._start_attack == true
            -- or (self._hero_type == self._enum_hero_type._dogface
            --     and mspace ~= nil 
            --     and self._range ~= nil 
            --     and self._range >= mspace)
            and self._range >= math.abs(self._byLockAttackTarget._coord_y - self._coord_y)
            and (self._range > 2 or 1 >= math.abs(self._byLockAttackTarget._coord_x - self._coord_x))
            and (self._attack_wait_cd == nil or self._attack_wait_cd <= 0)
            then

            -- if self._attack_wait_cd ~= nil then
            --     state_machine.excute("battle_scene_get_attack_wait_cd", 0, {self})
            -- end
            self._attack_wait_cd = nil
            -- v-fight6 unload code.
            -- if self._enterFightMoveEnd == true then
            --     self._enterFightMoveEnd = false
            --     self:moving_ex()
            --     return
            -- end

            -- if self._hero_type == self._enum_hero_type._dogface 
            --     and self._hero._death == false
            --     and self._hero._attacking == false
            --     then
            --     local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count
            --     if actionIndex ~= self._sprite._actionIndex then
            --         self._sprite._nextAction = actionIndex
            --     end
            --     return
            -- end

            -- print(self._shipName, self._byLockAttackTarget._shipName, self._byLockAttackTarget._formation_row, self._byLockAttackTarget._formation_column)
            self._start_attack = false
            self._byLockAttackTarget2 = nil

            if self._hero_type == self._enum_hero_type._hero then
                if self._range <= 100 then
                    -- self._follow = false
                end
            end

            -->>print("发起攻击：", self._shipName)
            if self._unlock_attack == true
                then
                -->>print("解锁攻击")
                self._unlock_attack = false
                state_machine.excute("battle_scene_unlock_start_attack", 0, 0)
            end

            -- 检测对象攻击
            -- byAttackTarget = state_machine.excute("battle_scene_check_attack", 0, {self, self._camp})

            if self._camp == 0 then
                state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
            else
                if self._battle_type == 1 then
                    state_machine.excute("battle_pvp_skill_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
                end
            end

            byAttackTarget = self._byLockAttackTarget
            if nil ~= byAttackTarget 
                -- and self._byAttackTarget == nil 
                then
                -- if self._run_state == self._enum_run_state._wait
                --     then
                --     local actionIndex = self._sprite._actionIndex - self._sprite._actionIndex % _spine_sprite_animation_team_count
                --     if actionIndex ~= self._sprite._actionIndex or #self._path > 0 then
                --         self:clearPath()
                --         --::self:stopAllActions()
                --         self._sprite._nextAction = actionIndex
                --         if self._hero_type == self._enum_hero_type._dogface
                --             or state_machine.excute("battle_scene_start_attack", 0, {self, true}) == false
                --             then
                --             self._run_state = self._enum_run_state._lock_attack
                --             return
                --         end
                --     else
                --         return
                --     end
                -- end

                -- 执行攻击前的锁定事件
                if self._event ~= nil then
                    -- print("-------------------", self._formation_index, self._shipName, self._event.attack_count, self._attack_count, self._event.execute_type, execute_type_battle_pause)
                    if self._event.attack_count == self._attack_count then
                        if self._event.execute_type == execute_type_battle_pause then
                            state_machine.excute("battle_scene_defer_pause", 0, {forcing = true})
                            state_machine.excute("battle_ui_change_show_state", 0, false)
                            self._event = nil
                            executeNextEvent(nil, nil)
                        -- elseif self._event.execute_type == execute_type_add_role_power then
                        --     print("把我的怒气加满", self._shipName)
                        --     state_machine.excute("battle_scene_add_role_power", 0, self._event)
                        --     self._event = nil
                        --     executeNextEvent(nil, nil)
                        end
                    end
                end
                self._attack_count = self._attack_count + 1
                local move_dir = self._move_dir
                self:attackTarget(byAttackTarget)

                if self._hero_type == self._enum_hero_type._hero 
                    -- and self._follow == true
                    then
                    for i, v in pairs(self._team) do
                        v._byLockAttackTarget = byAttackTarget
                        v._byAttackTarget = byAttackTarget
                        if v._death == false then
                            if v._moving == false 
                                and v._change_dir == false 
                                then
                                v._sleep_cd = 0
                                v._run_state = v._enum_run_state._run
                                v:attackTarget(byAttackTarget)
                            else
                                v._start_attack = true
                            end
                        end
                    end

                    -- local follow = false
                    -- for i, v in pairs(self._team) do
                    --     v._byLockAttackTarget = byAttackTarget
                    --     v._byAttackTarget = byAttackTarget
                    --     if move_dir ~= self._move_dir then
                    --         v._start_attack = true
                    --         v._moving = true
                    --         follow = true
                    --     else
                    --         v:attackTarget(byAttackTarget)
                    --     end
                    -- end
                    -- if follow == true then
                    --     self:teamFollow(self._coord_y, self._coord_x)
                    -- end
                end

    --             self._path = {}
    --             self._byAttackTarget = byAttackTarget
    --             self._attacking = true
    --             self:clearPath()
    --             self:stopAllActions()

    --             self._byAttackTargetPosition = cc.p(byAttackTarget:getPosition())

    --             if self._run_state == self._enum_run_state._sleep then
    --                 self._wait_attacking = true
    --                 local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count
    --                 csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
    --                 return
    --             end
    -- --             self._path = {}
    -- --             self._byAttackTarget = byAttackTarget
    -- --             self._attacking = true
    -- --             self:clearPath()
    -- --             self:stopAllActions()
    --             -- -- self:move(cc.p(self:getPosition()), cc.p(byAttackTarget:getPosition()))
    --             self:checkAttackType()
    --             self:checkAttack(cc.p(self:getPosition()), cc.p(byAttackTarget:getPosition()))
    --             -- local actionIndex = self._sprite._actionIndex % _spine_sprite_animation_team_count

    --             -- -- actionIndex 0 待机 1移动
    --             -- -- 将状态切至攻击状态 _attack_type 0为普攻 1为技能
    --             -- if actionIndex == 0 then
    --             --     actionIndex = self._sprite._actionIndex + 2 + self._attack_type
    --             --     csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
    --             -- elseif actionIndex == 1 then
    --             --     actionIndex = self._sprite._actionIndex + 1 + self._attack_type
    --             --     csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
    --             -- else
    --             --     self._sprite._nextAction = self._sprite._actionIndex
    --             -- end
            end
        else
            -- if self._hero_type == self._enum_hero_type._dogface then
            --     if self._path == nil or #self._path == 0 then
            --         self:move(self._move_pos, self._byLockAttackTarget._move_pos)
            --     end
            -- end
        end
    else
        -- if #self._path > 0 then
        --     self:clearPath()
        --     self:stopAllActions()
        -- end
        -- -- self._move_state = self._enum_move_state._wait
        -- -- 切换待机状态
        -- local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count
        -- self._sprite._nextAction = actionIndex
        -- -->print("战场中无可攻击的目标了！")
        -- return
    end

    if self._byAttackTarget == nil 
        and self._byLockAttackTarget ~= nil 
        and self._byLockAttackTarget._death == false
        then
        if self._hero_type == self._enum_hero_type._hero then
            -- self:moving_ex(dt)
            self:moving_cell(dt)
            if self._moving == true then
                state_machine.excute("battle_ui_update_role_reset", 0, {role = self, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
            end
        elseif self._hero_type == self._enum_hero_type._dogface 
            and self._hero._follow == false
            and self._hero._attacking == true
            then
            -- self:moving(dt)
        end

        -- if self._camp == 0 
        --     and self._hero_type == self._enum_hero_type._hero 
        --     -- and lastLockAttackTarget
        --     and lastLockAttackTarget ~= self._byLockAttackTarget
        --     then
        --     state_machine.excute("battle_ui_update_role_reset", 0, {role = self, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp, sp = self._sp, maxSp = self._max_sp, showSpEffect = true})
        -- end
    else
        -- if self._hero_type == self._enum_hero_type._hero 
        --     and self._camp == 0
        --     then
        --     print(self._byAttackTarget, self._byLockAttackTarget)
        -- end
    end
end

function BattleRole:removeAllBuffs( needClearState )
    for i, v in pairs(self._buffs) do
        if v ~= nil and v.roots ~= nil then
            v.need_tigger_buff = nil
            state_machine.excute("battle_buff_over", 0, v)
        end
    end
    self._buffs = {}
    if needClearState ~= nil and needClearState == true then
        self._not_dizziness = false
        self._dizziness = false
        self._not_silence = false
        self._silence = false
        self._not_lose_sp = false
        self.addAttackOpen = false
        self._undead = false
        self._must_hit = false
        self.damage_absorbability = nil
        self._heroBattleObject.counterstrike = nil
    end
end

-- 死亡
function BattleRole:death(skillId)
    if self._hero_type == self._enum_hero_type._hero then
        -- 4：受到致命伤害时
        -- if skillId ~= nil and skillId > 0 then
        --     self:executeSkills(battle_enum._skill_influence_trigger._is_fatal_attac, skillId)
        -- end
        if self._undead == true then
            self._hp = 1
            return
        end
        ___role_coords_status[self._coord_y][self._coord_x] = nil
    end
    
    -- -- 受到致命伤害时, 触发相应的效用及BUFF
    -- local skills = self._buff_skills[battle_enum._skill_influence_trigger._is_fatal_attac]
    -- if skills ~= nil then
    --     for i, v in pairs(skills) do
    --         if v ~= nil
    --             then
    --             local accepter = {}
    --             battle_logic.attack(self, self, v, accepter, v.skill_property, self._battle_type)
    --             self:drawInfluence(1, accepter.skill.skill_influence_type, accepter)
    --         end
    --     end
    --     if self._undead == true then
    --         self._hp = 1
    --         return
    --     end
    -- end

    self._death = true
    if self._camp == 0 then
        state_machine.excute("battle_ui_update_role_hp", 0, {role = self, shipId = self._shipMouldId, hp = 0, maxHp = self._max_hp})
    end
    
    if self._attack_pause == true then
        self:onResume()
    end

    if self._shadow ~= nil then
        self._shadow:setVisible(false)
    end

    if self._camp_effect ~= nil then
        self._camp_effect:setVisible(false)
    end

    if self._pfeffect ~= nil then
        self._pfeffect:setVisible(false)
    end

    if self._ui_role_hp ~= nil then
        self._show_ui_role_hp = false
        self._ui_role_hp:showUIRoleHp(self._show_ui_role_hp)
        self._ui_role_hp:showUIRoleName(self._show_ui_role_hp)
    end

    if self._camp == 1 then
        self._sprite:setScaleX(-1)
    end

    self:removeAllBuffs()

    self:clearPath()
    self:stopAllActions()

    -- 如果释放技能的角色在释放途中死亡
    if self._lock_screen == true then
        self._lock_screen = false
        -- self:__reorderChild()
        state_machine.excute("battle_scene_attack_resume", 0, self)
    end

    self._sp = encryptInfo(0)
    if self._hero_type == self._enum_hero_type._hero then
        if self._camp == 0 then
            state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
        end
    end

    -- print("0000000000000")
    state_machine.excute("battle_scene_clear_by_attacker_state", 0, {self})

    -- if self._parent._attack_running == false then
    --     print("111111111111")
    --     state_machine.excute("battle_scene_clear_by_attacker_state", 0, {self})
    -- else
    --     -- 锁屏后才进行角色死亡逻辑
    -- end

    if self._musics ~= nil and #self._musics > 1 then
        local musicId = zstring.tonumber(self._musics[2])
        if musicId > 0 then
            playEffectMusic(musicId)
        end
    end

    state_machine.excute("battle_scene_remove_deather", 0, {self, self._camp})

    if self._parent_size ~= nil then
        self._parent:reorderChild(self, -1 * self._move_pos.y * self._parent_size.height + self._move_pos.x)
    end

    if self._hero_type == self._enum_hero_type._hero then
        if self._camp == 1 then
            if self._battle_type == 0 then
                local drop_items = nil
                if zstring.tonumber(_ED.npc_state[tonumber(_ED._scene_npc_id)]) == 0 then
                    drop_items = dms.string(dms["environment_ship"], self._heroBattleObject.mouldId, environment_ship.frist_drop_items) 
                end
                if drop_items == nil 
                    or (zstring.tonumber(drop_items) ~= nil and zstring.tonumber(drop_items) == -1) 
                    then
                    drop_items = dms.string(dms["environment_ship"], self._heroBattleObject.mouldId, environment_ship.drop_items) 
                end
                if drop_items == nil 
                    or (zstring.tonumber(drop_items) ~= nil and zstring.tonumber(drop_items) == -1) 
                    then
                else
                    local drop_list = zstring.split(drop_items, "|")
                    for k,v in pairs(drop_list) do
                        local drop_item_info = zstring.split(v, ",")
                        local drop_type = tonumber(drop_item_info[1])
                        local drop_id = tonumber(drop_item_info[2])
                        local drop_counts = zstring.split(drop_item_info[3], "/")
                        local random = math.random(1, 10000)
                        if tonumber(drop_item_info[4]) >= random then
                            local count = math.random(tonumber(drop_counts[1]), tonumber(drop_counts[2]))
                            local dropItem = {
                                                item_type = drop_type, 
                                                item_id = drop_id, 
                                                item_count = count
                                            }
                            state_machine.excute("battle_scene_add_drop_item", 0, dropItem)
                            if drop_type == 1 then
                                state_machine.excute("battle_drop_create", 0, {parent = self._parent, zorder = _scene_zorder_drop, dropItem = dropItem, pos = self._move_pos})
                                state_machine.excute("battle_ui_drop_silver", 0, {count})
                            else
                                -- 掉落动画
                                state_machine.excute("battle_drop_pos_update_drop", 0, {parent = self._parent, zorder = _scene_zorder_drop, dropItem = dropItem, pos = self._move_pos})
                            end
                        end
                    end
                end
            elseif self._scene._fight_type == battle_enum._fight_type._fight_type_105 then
                if #self._scene._defenderTeam == 1 or 
                    (#self._scene._defenderTeam == 0 and table.nums(self._scene._defenderFormation) == 1) then
                    for i=1,2 do
                        local dropItem = {
                            item_type = 10000, 
                            item_id = 1, 
                            item_count = 1,
                        }
                        state_machine.excute("battle_drop_pos_update_drop", 0, {parent = self._parent, zorder = _scene_zorder_drop, dropItem = dropItem, pos = self._move_pos})
                    end
                end
            end
        end
    end

    -- 处理换线
    if self._hero_type == self._enum_hero_type._hero then
        local lcount = 1
        state_machine.excute("battle_scene_change_camp_attack_line", 0, {role = self, camp = self._camp, coord_y = self._coord_y, mcount = lcount})
    end

    if self._event ~= nil then
        if self._event.execute_type == execute_type_role_death then
            -- print("角色死亡事件", self._shipName)
            state_machine.excute("battle_scene_defer_pause", 0, {forcing = true})
            self._event = nil
            executeNextEvent(nil, nil)
        end
    end

    -- local actionIndex = _enum_spine_animation_frame_index.animation_death
    if self._camp == 1 and self._scene._fight_type == battle_enum._fight_type._fight_type_20 then
        self._sprite:getAnimation():setSpeedScale(1)
    end 
    local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count + 6
    csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
    self._sprite._nextAction = actionIndex

    if self.camera_focus == true then
        self.camera_focus = false
        state_machine.excute("battle_map_scene_scale_effect", 0, {0, 0, false, false, self})
    end
end

-- 复活
function BattleRole:review()
    self._death = false
    
    local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count)
    csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
    self._sprite._nextAction = actionIndex

    self:setVisible(true)

    if self._shadow ~= nil then
        self._shadow:setVisible(true)
    end

    if self._camp_effect ~= nil then
        self._camp_effect:setVisible(true)
    end

    if self._pfeffect ~= nil then
        self._pfeffect:setVisible(true)
    end

    if self._ui_role_hp ~= nil then
        self._show_ui_role_hp = true
        self._ui_role_hp:showUIRoleHp(self._show_ui_role_hp)
    end

    local startPosition = ___role_coords[battle_enum._partner_start_position[1]][battle_enum._partner_start_position[2]]
    self:setPosition(startPosition)
    if self._hero_type == self._enum_hero_type._hero then
        self:changeToAttackCoord(battle_enum._partner_start_position[1], battle_enum._partner_start_position[2])
    end

    self._attacking = false
    self._byAttackTarget = nil
    self._stop_attack_count = 0
    self._attack_pause = false
    self._dizziness = false
    self._resetAttackTargetPosition = nil

    state_machine.excute("battle_scene_review_deather", 0, {self, self._camp})

    if self._hero_type == self._enum_hero_type._hero then
        local count = math.ceil(self._hp / (self._max_hp / 4))
        for k,v in pairs(self._team) do
            if k <= count then
                v:review()
            end
        end
        if self._camp == 0 then
            state_machine.excute("battle_ui_update_role_hp", 0, {role = self, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp})
            state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = false})
        end
        local lockAttackTarget, space = state_machine.excute("battle_scene_lock_attack", 0, {self, self._camp})
        self._byLockAttackTarget = lockAttackTarget
        self._run_state = self._enum_run_state._run
        self._move_state = self._enum_move_state._moving
        self:moving_cell_y(0)
    end
end

function BattleRole:deathed(armature)
    self:setVisible(false)
    if true then
        return
    end
    self._sprite:removeFromParent(true)
    self._sprite = nil

    if self._sprite_src ~= nil then
        self._sprite_src:removeFromParent(true)
        self._sprite_src = nil
    end

    if self._hero ~= nil then
        self._hero._team[self._team_index] = nil
    end

    if self._cell._curr_node ~= nil 
        then
        self._cell._curr_node:setPassable(true)
        self._cell._curr_node._object = nil
        self:clearPath()
    end
    -- state_machine.excute("battle_scene_remove_deather", 0, {self, self._camp})
end

function BattleRole:addGodEffect( ... )
    self:setScale(1.15)
    if self._frist_activi_god_skill == false then
        local baseName = "effect/effect_zhandoushenbing1"
        local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        skeletonNode:registerSpineEventHandler(function (event)
            event.skeletonAnimation:removeFromParent(true)
        end, sp.EventType.ANIMATION_COMPLETE)

        skeletonNode:setAnimation(0, "animation_event", true)
        self:addChild(skeletonNode)
    end
    self._frist_activi_god_skill = true

    if self:getChildByTag(300000) ~= nil then
        self:removeChildByTag(300000)
    end
    local baseName = "effect/effect_zhandoushenbing2"
    local skeletonNode1 = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    skeletonNode1:registerSpineEventHandler(function (event)
        -- event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode1:setTag(300000)
    skeletonNode1:setAnimation(0, "animation_event", true)
    self:addChild(skeletonNode1)
end

-- 切换攻击状态
function BattleRole:checkAttackType()
    if self._moving == true then
        return
    end
    if self._dizziness == true then
        return
    end
    if self._scene._fight_type ~= battle_enum._fight_type._fight_type_20
        and self._scene._fight_type ~= battle_enum._fight_type._fight_type_105 then
        if self._camp == 1 and self._battle_type == 0 then
            if camprareFightingWithBaseInfo(self._heroBattleObject.power, self._heroBattleObject.courage, 
                self._heroBattleObject.intellect, self._heroBattleObject.nimable, self._heroBattleObject.base_fighting) == false then
                if fwin:find("ReconnectViewClass") == nil then
                -- fwin:close(fwin:find("ReconnectViewClass"))
                    fwin:open(ReconnectView:new():init(red_alert_all_str[184]), fwin._system)
                end
                return
            end
        end
    end
    self._use_god_skill = false
    -- 怒气攻击
    if decryptInfo(self._sp) >= decryptInfo(self._max_sp)
        and #self._skills > 1
        and self._is_skill == true
        and self._silence ~= true
        then
        self._is_skill = self._is_auto
        self._current_skill = self._skills[2]
        self._bullet_id = self._skills[2].bullet
        self._effect_id = self._skills[2].effect
        self._bullet_type = self._skills[2].bullet_type
        self._floor_effect_id = self._skills[2].floor_effect or 0
        -- self._sp = self._sp - self._max_sp
        self._sp = encryptInfo(0)
        self._is_skill_attack_buffed = false
        self._attack_type = 1

        local actionIndex = self._sprite._actionIndex - self._sprite._actionIndex % _spine_sprite_animation_team_count + 3
        csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
        self._sprite._nextAction = actionIndex - 1
        -- 锁屏标示
        self._lock_screen = true

        if self._hero_type == self._enum_hero_type._hero then
            if self._camp == 0 then
                state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
            else
                if self._battle_type == 1 then
                    state_machine.excute("battle_pvp_skill_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
                end
            end
        end
    -- 普通攻击
    else
        self._normal_attack_count = self._normal_attack_count + 1
        if self._active_god_skill == true then
            if (self._normal_attack_count - 1) == self._base_god_attack_times then
                self._use_god_skill = true
            else
                if (self._normal_attack_count - self._base_god_attack_times) % 4 == 0 then
                    self:addGodEffect()
                elseif (self._normal_attack_count - self._base_god_attack_times - 1) % 4 == 0 then
                    self._use_god_skill = true
                end
            end
        end
        if self._normal_attack_count > 0 then
            self:executeSkills(battle_enum._skill_influence_trigger._physical_attack)
        end
        if self._use_god_skill == true then
            self._current_skill = self._skills[3]
            self._bullet_id = self._skills[3].bullet
            self._effect_id = self._skills[3].effect
            self._bullet_type = self._skills[3].bullet_type
            self._floor_effect_id = self._skills[3].floor_effect or 0
            self._attack_type = 0
            local actionIndex = self._sprite._actionIndex - self._sprite._actionIndex % _spine_sprite_animation_team_count + 4
            csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            self._sprite._nextAction = actionIndex - 2
        else
            self._current_skill = self._skills[1]
            self._bullet_id = self._skills[1].bullet
            self._effect_id = self._skills[1].effect
            self._bullet_type = self._skills[1].bullet_type
            self._floor_effect_id = self._skills[1].floor_effect or 0
            self._attack_type = 0
            local actionIndex = self._sprite._actionIndex - self._sprite._actionIndex % _spine_sprite_animation_team_count + 2
            csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            self._sprite._nextAction = actionIndex
        end
        if self._hero_type == self._enum_hero_type._hero then
            if self._scene._fight_type == battle_enum._fight_type._fight_type_20 then
                local addSp = dms.int(dms["environment_ship"], self._heroBattleObject.mouldId, environment_ship.common_attack_add_sp)
                self._sp = encryptInfo(decryptInfo(self._sp) + addSp)
                state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
            else
                if self._camp == 0 then
                    self._sp = encryptInfo(decryptInfo(self._sp) + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_attack, fight_config.attribute) * (1 + battle_logic.spPercent(self._heroBattleObject)))
                    state_machine.excute("battle_ui_update_player_sp", 0, 10)
                    state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
                else
                    if self._battle_type == 1 then
                        self._sp = encryptInfo(decryptInfo(self._sp) + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_attack, fight_config.attribute) * (1 + battle_logic.spPercent(self._heroBattleObject)))
                        state_machine.excute("battle_pvp_skill_update_player_sp", 0, 10)
                        state_machine.excute("battle_pvp_skill_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = false})
                    else
                        local addSp = dms.int(dms["environment_ship"], self._heroBattleObject.mouldId, environment_ship.common_attack_add_sp)
                        self._sp = encryptInfo(decryptInfo(self._sp) + addSp)
                    end
                end
            end
        end
    end
    if self._debilitated == true then
        local rate = math.random(1, 100)
        if rate > self._debilitated_rate then
            for i, v in pairs(self._buffs) do
                if v._accepter ~= nil 
                    and v._accepter.skill ~= nil
                    and tonumber(v._accepter.skill.skill_influence_type) == 63 
                    then
                    v.need_tigger_buff = true
                    state_machine.excute("battle_role_remove_buff", 0, {role = self, buff = v})
                end
            end
        end
    end
end

function BattleRole:beforeCheckAttackType()
    if self._moving == true then
        return
    end
    -- 怒气攻击
    if decryptInfo(self._sp) >= decryptInfo(self._max_sp)
        and #self._skills > 1
        and self._is_skill == true
        and self._silence ~= true
        then
        self._current_skill = self._skills[2]
    else
        if self._active_god_skill == true then
            if self._normal_attack_count == self._base_god_attack_times then
                self._current_skill = self._skills[3]
            elseif (self._normal_attack_count - self._base_god_attack_times) % 4 == 0 then
                self._current_skill = self._skills[3]
            else
                self._current_skill = self._skills[1]
            end
        else
            self._current_skill = self._skills[1]
        end
    end
end

-- 受击特效
function BattleRole:createEffectForSpine()
    local baseName = "effect/effect_beiji"
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)

    skeletonNode:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)

    skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
    self:addChild(skeletonNode)
end

-- 效用的效果绘图
function BattleRole:drawInfluence(attackType, skillInfluenceType, accepter)
    if _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
        if self._camp == 1 and self._hp_rt < 0.6 then
            local buffs = zstring.split(dms.string(dms["soul_copy_config"], 8, soul_copy_config.param), ",")
            local result = true
            for k,v in pairs(buffs) do
                if tonumber(v) == skillInfluenceType then
                    result = true
                    break
                else
                    result = false
                end
            end
            if result == false then
                return
            end
        end
    end
    if skillInfluenceType == 0 then
        if nil ~= accepter.damage then
            self:drawHurt(accepter.damage.value, attackType, accepter.crit)
            if accepter.damage.absorbability == true then
                BattleBuff.drawTextureAction(self, "images/ui/battle/shanghaixishou.png")
                accepter.damage.absorbability = false
                state_machine.excute("battle_buff_create", 0, {self, accepter})
            end
        end
    elseif skillInfluenceType == 1 then
        self:drawReply(accepter.cure.value, attackType)
    elseif skillInfluenceType == 14 then
        self:drawBloodsucking(attackType, skillInfluenceType, accepter)
    end
    if skillInfluenceType ~= 0 then
        if ((tonumber(skillInfluenceType) == 5 
            or tonumber(skillInfluenceType) == 54 
            or tonumber(skillInfluenceType) == 55) 
            and accepter ~= nil 
            and accepter._dizziness ~= true)
            or (tonumber(skillInfluenceType) == 8 
            and accepter ~= nil 
            and accepter._silence ~= true)
            or (tonumber(skillInfluenceType) == 3 
            and accepter ~= nil 
            and accepter._lose_sp ~= true)
            then
        else
            state_machine.excute("battle_buff_create", 0, {self, accepter})
        end
    end
end

-- 受击
function BattleRole:hit(attacker, battleBullet, isFristHurt)
    if self._death == true then
        if self._hero_type == self._enum_hero_type._hero then
            if battleBullet ~= nil and battleBullet._current_skill.skill_influence_type == 38 then
                local accepter = {}
                battle_logic.attack(attacker._heroBattleObject, self._heroBattleObject, battleBullet._current_skill, accepter, battleBullet._current_skill.skill_property, self._battle_type)
                if accepter.resurrection ~= nil and accepter.resurrection.value > 0 then
                    self._hp = accepter.resurrection.value
                    self:review()
                end
            end
        end
        return
    end

    self._move_pos = cc.p(self:getPosition())

    local accepter = {}
    local damage = 0
    -- local damage = math.modf(attacker._attack)


    local skillInfluenceType = 0
    -- 取消小兵的攻击伤害
    local skillId = 0
    if attacker._hero_type == attacker._enum_hero_type._dogface then

    else
        skillId = battleBullet._current_skill.id
        if battleBullet._current_skill.trigger_timing == battle_enum._skill_influence_trigger._normal then
            battle_logic.attack(attacker._heroBattleObject, self._heroBattleObject, battleBullet._current_skill, accepter, battleBullet._current_skill.skill_property, self._battle_type)
        elseif battleBullet._current_skill.trigger_timing == battle_enum._skill_influence_trigger._unstrike_damage_over then
            battle_logic.attack(attacker._heroBattleObject, self._heroBattleObject, battleBullet._current_skill, accepter, battleBullet._current_skill.skill_property, self._battle_type)
            state_machine.excute("battle_buff_create", 0, {self, accepter})
            return
        else
            return
        end
        if accepter.invalid == true then
            if accepter.accepters ~= nil then
                for i, v in pairs(accepter.accepters) do
                    if v.invalid ~= true then
                        local tskillInfluenceType = v.skill.skill_influence_type
                        self:drawInfluence(battleBullet._attack_type, tskillInfluenceType, v)
                    end
                end
            end
            return
        end

        skillInfluenceType = accepter.skill.skill_influence_type
        if skillId == nil then
            skillId = accepter.skill.id
        end
        --判断是否闪避
        if accepter.miss ~= true 
            and accepter.damage ~= nil
            then
            damage = accepter.damage.value
            self._hp = self._hp - damage
        end
        if self._hp <= 0 then
            -- 4：受到致命伤害时
            self:executeSkills(battle_enum._skill_influence_trigger._is_fatal_attac, skillId)
        end
        if self._undead == true and self._hp <= 1 then
            self._hp = 1
        end
        -- self._hp = self._max_hp
        -- if accepter.cure ~= nil
        --     then
        --     self._hp = self._hp + accepter.cure.value
        --     self._hp = math.min(self._hp, self._max_hp)
        -- end
        if self._scene._fight_type ~= battle_enum._fight_type._fight_type_20 
            and self._scene._fight_type ~= battle_enum._fight_type._fight_type_105
            then
            if self._camp == 0 and self._hero_type == self._enum_hero_type._hero then
                local baseHp = decryptInfo(self._heroBattleObject.key_ship_health)
                if self._hp > baseHp then
                    if fwin:find("ReconnectViewClass") == nil then
                        fwin:open(ReconnectView:new():init(red_alert_all_str[184]), fwin._system)
                        return
                    end
                end
            end
        end
        self._hp_rt = self._hp / self._max_hp
    end
    
    if self._hero_type == self._enum_hero_type._hero then
        if skillInfluenceType == 0 
            or skillInfluenceType == 14 then
            -- 3：受到伤害后触发
            self:executeSkills(battle_enum._skill_influence_trigger._damage_over, skillId)
            if skillInfluenceType == 0 then
                -- 11：受到非反伤类型的伤害
                if self._heroBattleObject.counterstrike ~= nil then
                    if self._camp ~= attacker._camp and accepter.init_damage ~= nil then
                        local counterHurt = self._heroBattleObject.counterstrike.value * accepter.init_damage
                        attacker._hp = attacker._hp - counterHurt
                        attacker._hp = math.min(attacker._hp, attacker._max_hp)
                        if attacker._undead == true and attacker._hp <= 1 then
                            attacker._hp = 1
                        end
                        if attacker._scene._fight_type ~= battle_enum._fight_type._fight_type_20 
                            and self._scene._fight_type ~= battle_enum._fight_type._fight_type_105
                            then
                            if attacker._camp == 0 and attacker._hero_type == attacker._enum_hero_type._hero then
                                local baseHp = decryptInfo(attacker._heroBattleObject.key_ship_health)
                                if attacker._hp > baseHp then
                                    if fwin:find("ReconnectViewClass") == nil then
                                        fwin:open(ReconnectView:new():init(red_alert_all_str[184]), fwin._system)
                                        return
                                    end
                                end
                            end
                        end
                        if attacker._camp == 0 then
                            state_machine.excute("battle_role_hp_update", 0, {roleHP = attacker._ui_role_hp, shipId = attacker._shipMouldId, hp = attacker._hp, maxHp = attacker._max_hp})
                        end
                        attacker:drawHurt(math.ceil(counterHurt), attackType, accepter.crit)
                        attacker:drawHit(self, math.ceil(counterHurt), false, 0)
                    end
                else
                    attacker:executeSkills(battle_enum._skill_influence_trigger._influence0_damage_over, skillId) 
                end
                -- self:executeSkills(battle_enum._skill_influence_trigger._unstrike_damage_over, skillId)
            end
        end

        if accepter.crit == true then
            if nil ~= config_csb.battle.battle_text_critical then
                
            else
                BattleBuff.drawTextureAction(self, "images/ui/battle/baoji.png")
            end
            -- 8：暴击时
            attacker:executeSkills(battle_enum._skill_influence_trigger._crit, skillId)
        end
        if accepter.parry == true then
			if cc.Application:getInstance():getTargetPlatform() == m_optimization_Platform  and m_android_optimization~=nil and m_android_optimization~="" and m_android_optimization == true then
				BattleBuff.drawTextureAction(self, "images/ui/battle/gedang.png")
			else
				if nil ~= config_csb.battle.battle_text_parry then
					self:drawAttackStatusAction(config_csb.battle.battle_text_parry, nil)
				else
					BattleBuff.drawTextureAction(self, "images/ui/battle/gedang.png")
				end
			end
            -- 7：格挡时
            self:executeSkills(battle_enum._skill_influence_trigger._parry, skillId)
        end
        if accepter._dizziness == true 
            or accepter._silence == true
            then
            if self._attacking == true and self._attack_type == 1 then
                if nil ~= config_csb.battle.battle_text_interrupt then
                    self:drawAttackStatusAction(config_csb.battle.battle_text_interrupt, nil)
                else
                    BattleBuff.drawTextureAction(self, "images/ui/battle/beidaduan.png")
                end
                if self._effect_layer ~= nil then 
                    local childs = self._effect_layer:getChildren()
                    for i, v in pairs(childs) do
                        state_machine.excute("battle_effect_remove", 0, v)
                    end
                end
                self:onSleep()
                csb.animationChangeToAction(self._sprite, self._sprite._nextAction, self._sprite._nextAction, false)
            end
        end
        -- 5：释放技能时
        if isFristHurt == true and battleBullet._attack_type == 1 then
            if attacker._is_skill_attack_buffed == false then
                attacker._is_skill_attack_buffed = true
                attacker:executeSkills(battle_enum._skill_influence_trigger._release_skills, skillId)
            end
        end
        if accepter.miss == true then
            self:drawMiss()
            -- 9：闪避时
            self:executeSkills(battle_enum._skill_influence_trigger._miss, skillId)
        else
            -- 取消小兵的攻击伤害
            if attacker._hero_type == attacker._enum_hero_type._dogface then
            else
                -- -- print("skillInfluenceType::::", skillInfluenceType, damage)
                -- if damage > 0 then
                --     if skillInfluenceType == 0 then
                --         self:drawHurt(damage, battleBullet._attack_type)
                --     elseif skillInfluenceType == 1 then
                --         self:drawReply(damage, battleBullet._attack_type)
                --     else
                --         -- BattleBuff["" .. skillInfluenceType]:add(self, accepter)
                --         state_machine.excute("battle_buff_create", 0, {self, accepter})
                --     end
                -- else
                --     if skillInfluenceType == 0 then

                --     elseif skillInfluenceType == 1 then
                        
                --     else
                --         -- BattleBuff["" .. skillInfluenceType]:add(self, accepter)
                --         state_machine.excute("battle_buff_create", 0, {self, accepter})
                --     end
                -- end

                if isFristHurt == true then
                    -- 12：普攻命中时
                    if battleBullet._attack_type == 0 then
                        attacker:executeSkills(battle_enum._skill_influence_trigger._normal_attack, skillId)
                    end
                end

                self:drawInfluence(battleBullet._attack_type, skillInfluenceType, accepter)

                if accepter.accepters ~= nil then
                    for i, v in pairs(accepter.accepters) do
                        if v.invalid ~= true then
                            local tskillInfluenceType = v.skill.skill_influence_type
                            -- -- print("tskillInfluenceType:", tskillInfluenceType)
                            -- if tskillInfluenceType == 0 then
                            --     self:drawHurt(damage, battleBullet._attack_type)
                            -- elseif tskillInfluenceType == 1 then
                            --     self:drawReply(damage, battleBullet._attack_type)
                            -- else
                            --     -- BattleBuff["" .. tskillInfluenceType]:add(self, v)
                            --     state_machine.excute("battle_buff_create", 0, {self, v})
                            -- end
                            if v._dizziness == true 
                                or v._silence == true
                                then
                                if self._attacking == true and self._attack_type == 1 then
									if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
										BattleBuff.drawTextureAction(self, "images/ui/battle/beidaduan.png")
									else
										if nil ~= config_csb.battle.battle_text_interrupt then
											self:drawAttackStatusAction(config_csb.battle.battle_text_interrupt, nil)
										else
											BattleBuff.drawTextureAction(self, "images/ui/battle/beidaduan.png")
										end
									end
                                    if self._effect_layer ~= nil then 
                                        local childs = self._effect_layer:getChildren()
                                        for i, v in pairs(childs) do
                                            state_machine.excute("battle_effect_remove", 0, v)
                                        end
                                    end
                                    self:onSleep()
                                    csb.animationChangeToAction(self._sprite, self._sprite._nextAction, self._sprite._nextAction, false)
                                end
                            end
                            self:drawInfluence(battleBullet._attack_type, tskillInfluenceType, v)
                        end
                    end
                end
            end
        end
        
        -- if self._hp < 0 then
        --     self._hp = 0
        -- end
        -- if attacker.roots == nil or self._camp ~= attacker._camp then
        --     local crc = 4 - math.ceil(self._hp / (self._max_hp / 4))
        --     for i=1, crc do
        --         local e = self._team[i]
        --         if e ~= nil and e._death == false then
        --             e:stopAllActions()
        --             e:clearPath()
        --             e:onSleep()
        --             csb.animationChangeToAction(e._sprite, e._sprite._nextAction, e._sprite._nextAction, false)
        --             e:death()
        --         end
        --     end
        -- end

        -- -- 取消小兵的攻击伤害
        -- if attacker._hero_type == attacker._enum_hero_type._dogface then

        -- else
        --     if self._ui_role_hp ~= nil then
        --         if false == self._show_ui_role_hp then
        --             self._show_ui_role_hp = true
        --             self._show_ui_role_hp_timer = 2.0
        --             self._ui_role_hp:showUIRoleHp(self._show_ui_role_hp)
        --         end
        --         state_machine.excute("battle_role_hp_update", 0, {roleHP = self._ui_role_hp, shipId = self._shipId, hp = self._hp, maxHp = self._max_hp})
        --     end
        -- end

        -- -- 角色承受的时候，变高亮
        -- if self._hero_type == self._enum_hero_type._hero
        --     then
        --     -- local sleepCd = (self._sleep_cd - 15 / 60 * __fight_recorder_action_time_speed) / 2
        --     if self._run_state == self._enum_run_state._sleep 
        --         -- and sleepCd >= 0.000001
        --         then
        --         local modeIndex = self._sprite._actionIndex % _spine_sprite_animation_team_count
        --         if modeIndex ~= 2 and modeIndex ~= 3 
        --             and (attacker.roots == nil or self._camp ~= attacker._camp)
        --             then
        --             local actionIndex = self._sprite._actionIndex - (self._sprite._actionIndex % _spine_sprite_animation_team_count) + 4
        --             if actionIndex ~= self._sprite._actionIndex 
        --                 and actionIndex ~= self._sprite._nextAction 
        --                 then
        --                 csb.animationChangeToAction(self._sprite, actionIndex, self._sprite._actionIndex, false)
        --             end
        --         end
        --         if self._sprite_src ~= nil then
        --             -- csb.animationChangeToAction(self._sprite_src, actionIndex, self._sprite._actionIndex, false)
        --             self._sprite_src:setVisible(true)
        --         end
        --     else
        --         if self._def_timer <= 0.000001
        --             then
        --             self._def_timer = 0.5
        --             -- self._sprite:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        --             -- csb.animationChangeToAction(self._sprite_src, self._sprite._actionIndex, self._sprite._actionIndex, false)
        --             self._sprite_src:setVisible(true)
        --             self:createEffectForSpine()
        --         end
        --     end
        -- end
        self:drawHit(attacker, damage, isFristHurt, skillId)
    end

    -- -- 取消小兵的攻击伤害
    -- if attacker._hero_type == attacker._enum_hero_type._dogface then
    -- else
    --     if self._hp <= 0 then
    --         self:death()
    --         -- 绘制攻击效果
    --         BattleBuff.drawTextureAction(attacker, "images/ui/battle/jishajiangli.png")
    --         if attacker._hero_type ~= attacker._enum_hero_type._dogface then
    --             attacker._sp = attacker._sp + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_kill, fight_config.attribute) * (1 + battle_logic.spPercent(attacker._heroBattleObject))
    --             if attacker._camp == 0 and attacker._hero_type ~= attacker._enum_hero_type._dogface then
    --                 state_machine.excute("battle_ui_update_player_sp", 0, 10)
    --                 state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipId, sp = attacker._sp, maxSp = attacker._max_sp, showSpEffect = false})
    --             end
    --             if attacker._pfeffect ~= nil 
    --                 and attacker._sp >= attacker._max_sp
    --                 then
    --                 attacker._pfeffect:setVisible(true)
    --             end
    --         end
    --     else
    --         -- if battleBullet._attacker._attack_type == 0 then
    --             if attacker._hero_type ~= attacker._enum_hero_type._dogface then
    --                 if battleBullet._attack_type == 0 then
    --                     attacker._sp = attacker._sp + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_attack, fight_config.attribute) * (1 + battle_logic.spPercent(attacker._heroBattleObject))
    --                     if attacker._camp == 0 and attacker._hero_type ~= attacker._enum_hero_type._dogface then
    --                         state_machine.excute("battle_ui_update_player_sp", 0, 10)
    --                         state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipId, sp = attacker._sp, maxSp = attacker._max_sp, showSpEffect = false})
    --                     end
    --                     if attacker._pfeffect ~= nil 
    --                         and attacker._sp >= attacker._max_sp
    --                         then
    --                         attacker._pfeffect:setVisible(true)
    --                     end
    --                 end
    --             end
    --             if self._hero_type ~= self._enum_hero_type._dogface then
    --                 if battleBullet._attack_type == 0 then
    --                     self._sp = self._sp + math.floor(damage / self._max_hp) * 100 * (1 + battle_logic.spPercent(self._heroBattleObject))
    --                     if self._camp == 0 and self._hero_type ~= self._enum_hero_type._dogface then
    --                         state_machine.excute("battle_ui_update_player_sp", 0, 10)
    --                         state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipId, sp = self._sp, maxSp = self._max_sp, showSpEffect = false})
    --                     end
    --                     if self._pfeffect ~= nil 
    --                         and self._sp >= self._max_sp
    --                         then
    --                         self._pfeffect:setVisible(true)
    --                     end
    --                 end
    --             end
    --         -- end
    --     end
    -- end

    -- self:drawHit(attacker, battleBullet._current_skill.skill_quality, damage, battleBullet._current_skill, isFristHurt)
end

function BattleRole:showUIRoleName(visible)
    if self._ui_role_hp ~= nil then
        self._ui_role_hp:showUIRoleName(visible)
    end
end

function BattleRole:showUIRoleHp()
    if false == self._show_ui_role_hp then
        self._show_ui_role_hp = true
        self._show_ui_role_hp_timer = 2.0
        if self._ui_role_hp ~= nil then
            self._ui_role_hp:showUIRoleHp(self._show_ui_role_hp)
        end
    end
end

function BattleRole:drawHit(attacker, damage, isFristHurt, skillId)
    if self._hero_type == self._enum_hero_type._hero then
        if self._hp < 0 then
            self._hp = 0
        end
        if attacker.roots == nil or self._camp ~= attacker._camp then
            local crc = 4 - math.ceil(self._hp) / (self._max_hp / 4)
            for i=1, crc do
                local e = self._team[i]
                if e ~= nil and e._death == false then
                    -- self._team[i] = nil
                    e:clearPath()
                    e:onSleep()
                    e:stopAllActions()
                    -- csb.animationChangeToAction(e._sprite, e._sprite._nextAction, e._sprite._nextAction, false)
                    e:death()
                end
            end
        end

        -- 取消小兵的攻击伤害
        if attacker._hero_type == attacker._enum_hero_type._dogface then

        else
            if self._ui_role_hp ~= nil then
                -- if false == self._show_ui_role_hp then
                --     self._show_ui_role_hp = true
                --     self._show_ui_role_hp_timer = 2.0
                --     self._ui_role_hp:showUIRoleHp(self._show_ui_role_hp)
                -- end
                self:showUIRoleHp()
                state_machine.excute("battle_role_hp_update", 0, {roleHP = self._ui_role_hp, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp})
            end
        end

        -- 角色承受的时候，变高亮
        if self._hero_type == self._enum_hero_type._hero
            then
            -- local sleepCd = (self._sleep_cd - 15 / 60 * __fight_recorder_action_time_speed) / 2
            if self._run_state == self._enum_run_state._sleep 
                -- and sleepCd >= 0.000001
                then
                local modeIndex = self._sprite._actionIndex % _spine_sprite_animation_team_count
                if modeIndex ~= 2 and modeIndex ~= 3 and modeIndex ~= 4
                    and (attacker.roots == nil or self._camp ~= attacker._camp)
                    and self._moving ~= true
                    and (damage ~= nil and damage > 0)
                    then
                    local actionIndex = self._sprite._actionIndex - (self._sprite._actionIndex % _spine_sprite_animation_team_count) + 5
                    if actionIndex ~= self._sprite._actionIndex 
                        and actionIndex ~= self._sprite._nextAction 
                        then
                        self._sprite.__shader_spx_need_visible = true
                        csb.animationChangeToAction(self._sprite, actionIndex, self._sprite._actionIndex, false)
                        if self._sprite_src ~= nil then
                            -- csb.animationChangeToAction(self._sprite_src, actionIndex, self._sprite._actionIndex, false)
                            self._sprite_src:setVisible(true)
                            self._sprite.__shader_spx_need_visible = false
                        end
                    end
                end
            else
                if self._def_timer <= 0.000001
                    then
                    self._def_timer = 0.5
                    -- self._sprite:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
                    -- csb.animationChangeToAction(self._sprite_src, self._sprite._actionIndex, self._sprite._actionIndex, false)
                    -- self._sprite_src:setVisible(true)
                    self._sprite.__shader_spx_need_visible = true
                    if self._sprite_src ~= nil then
                        -- csb.animationChangeToAction(self._sprite_src, actionIndex, self._sprite._actionIndex, false)
                        self._sprite_src:setVisible(true)
                    end
                    self:createEffectForSpine()
                end
            end
        end
    end

    -- 取消小兵的攻击伤害
    if attacker._hero_type == attacker._enum_hero_type._dogface then
    else
        -- test
        -- if attacker._camp == 0 then
            -- attacker._sp = encryptInfo(decryptInfo(attacker._sp) + 100)
            -- state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = decryptInfo(attacker._sp), maxSp = decryptInfo(attacker._max_sp), showSpEffect = true})
            -- state_machine.excute("battle_ui_update_player_sp", 0, 10)
        -- end
        -- if self._camp == 0 then
            -- self._sp = encryptInfo(decryptInfo(self._sp) + 100)
            -- state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
            -- state_machine.excute("battle_ui_update_player_sp", 0, 10)
        -- end
        if self._undead == true and self._hp <= 1 then
            self._hp = 1
        end
        if self._hp <= 0 then
            self:death(skillId)
            attacker:executeSkills(battle_enum._skill_influence_trigger._kill_target)
            -- 绘制攻击效果
			if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
				BattleBuff.drawTextureAction(attacker, "images/ui/battle/jishajiangli.png")
			else
				if nil ~= config_csb.battle.battle_text_kill_reward then
					attacker:drawAttackStatusAction(config_csb.battle.battle_text_kill_reward, nil)
				else
					BattleBuff.drawTextureAction(attacker, "images/ui/battle/jishajiangli.png")
				end
			end
            if attacker._hero_type == attacker._enum_hero_type._hero then
                if attacker._scene._fight_type == battle_enum._fight_type._fight_type_20 then
                    attacker._sp = encryptInfo(decryptInfo(attacker._sp) + dms.int(dms["fight_config"], battle_enum._fight_config_num.frist_fight_juqi_kill, fight_config.attribute) * (1 + battle_logic.spPercent(attacker._heroBattleObject)))
                    state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = decryptInfo(attacker._sp), maxSp = decryptInfo(attacker._max_sp), showSpEffect = false})
                else
                    if attacker._camp == 0 then
                        attacker._sp = encryptInfo(decryptInfo(attacker._sp) + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_kill, fight_config.attribute) * (1 + battle_logic.spPercent(attacker._heroBattleObject)))
                        -- state_machine.excute("battle_ui_update_player_sp", 0, 10)
                        state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = decryptInfo(attacker._sp), maxSp = decryptInfo(attacker._max_sp), showSpEffect = false})
                    else
                        if attacker._battle_type == 1 then
                            attacker._sp = encryptInfo(decryptInfo(attacker._sp) + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_kill, fight_config.attribute) * (1 + battle_logic.spPercent(attacker._heroBattleObject)))
                            -- state_machine.excute("battle_pvp_skill_update_player_sp", 0, 10)
                            state_machine.excute("battle_pvp_skill_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = decryptInfo(attacker._sp), maxSp = decryptInfo(attacker._max_sp), showSpEffect = false})
                        end
                    end
                end

                -- if attacker._attack_type == 0 then
                --     if attacker._camp == 0 then
                --         attacker._sp = attacker._sp + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_attack, fight_config.attribute) * (1 + battle_logic.spPercent(attacker._heroBattleObject))
                --         state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = attacker._sp, maxSp = attacker._max_sp, showSpEffect = false})
                --     else
                --         local addSp = dms.int(dms["environment_ship"], attacker._heroBattleObject.mouldId, environment_ship.common_attack_add_sp)
                --         attacker._sp = attacker._sp + addSp
                --     end
                -- end
                if attacker._pfeffect ~= nil 
                    and decryptInfo(attacker._sp) >= decryptInfo(attacker._max_sp)
                    then
                    attacker._pfeffect:setVisible(true)
                end
                if attacker._start_attack == true then
                    attacker._run_state = attacker._enum_run_state._run
                    attacker._sleep_cd = 0.1
                end
            end
        else
            if attacker._hero_type == attacker._enum_hero_type._hero then
                -- if battleBullet._attack_type == 0 then
                -- 普通回怒挪到普攻发起的时候
                -- if attackType == 0 then
                --     if self._scene._fight_type == battle_enum._fight_type._fight_type_20 then
                --         if isFristHurt == nil or (isFristHurt ~= nil and isFristHurt == true) then
                --             local addSp = dms.int(dms["environment_ship"], attacker._heroBattleObject.mouldId, environment_ship.common_attack_add_sp)
                --             attacker._sp = attacker._sp + addSp
                --         end
                --         state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = attacker._sp, maxSp = attacker._max_sp, showSpEffect = true})
                --     else
                --         if attacker._camp == 0 then
                --             if isFristHurt == nil or (isFristHurt ~= nil and isFristHurt == true) then
                --                 attacker._sp = attacker._sp + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_attack, fight_config.attribute) * (1 + battle_logic.spPercent(attacker._heroBattleObject))
                --                 state_machine.excute("battle_ui_update_player_sp", 0, 10)
                --             end
                --             state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = attacker._sp, maxSp = attacker._max_sp, showSpEffect = true})
                --         else
                --             if attacker._battle_type == 1 then
                --                 if isFristHurt == nil or (isFristHurt ~= nil and isFristHurt == true) then
                --                     attacker._sp = attacker._sp + dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_attack, fight_config.attribute) * (1 + battle_logic.spPercent(attacker._heroBattleObject))
                --                     state_machine.excute("battle_pvp_skill_update_player_sp", 0, 10)
                --                 end
                --                 state_machine.excute("battle_pvp_skill_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = attacker._sp, maxSp = attacker._max_sp, showSpEffect = false})
                --             else
                --                 if isFristHurt == nil or (isFristHurt ~= nil and isFristHurt == true) then
                --                     local addSp = dms.int(dms["environment_ship"], attacker._heroBattleObject.mouldId, environment_ship.common_attack_add_sp)
                --                     attacker._sp = attacker._sp + addSp
                --                     -- state_machine.excute("battle_ui_update_player_sp", 0, 10)
                --                 end
                --                 -- state_machine.excute("battle_ui_update_role_sp", 0, {role = attacker, shipId = attacker._shipMouldId, sp = attacker._sp, maxSp = attacker._max_sp, showSpEffect = false})
                --             end
                --         end
                --     end
                -- end
                if attacker._pfeffect ~= nil 
                    and decryptInfo(attacker._sp) >= decryptInfo(attacker._max_sp)
                    then
                    attacker._pfeffect:setVisible(true)
                end
            end
            if self._hero_type == self._enum_hero_type._hero then
                self._sp = encryptInfo(decryptInfo(self._sp) + (damage / self._max_hp) * dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_hurt, fight_config.attribute) * (1 + battle_logic.spPercent(self._heroBattleObject)))
                if self._scene._fight_type == battle_enum._fight_type._fight_type_20 then
                    state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
                else
                    if self._camp == 0 then
                        -- state_machine.excute("battle_ui_update_player_sp", 0, 10)
                        state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
                    else
                        if self._battle_type == 1 then
                            -- state_machine.excute("battle_pvp_skill_update_player_sp", 0, 10)
                            state_machine.excute("battle_pvp_skill_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = false})
                        -- else
                        --     state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = self._sp, maxSp = self._max_sp, showSpEffect = false})
                        end
                    end
                end
                if self._pfeffect ~= nil 
                    and decryptInfo(self._sp) >= decryptInfo(self._max_sp)
                    then
                    self._pfeffect:setVisible(true)
                end
            end 
        end
    end
end

local function removeDrawAntNumberFuncN(sender)
    sender:removeFromParent(true)
end

function BattleRole:drawInfluenceNumber(number, attackType, fileName, crit, csbFile)
    local hScale = 1.0
    if (attackType ~= nil and attackType > 0) or crit then
        hScale = 1.5
    end

    if nil == csbFile then
        local number = cc.LabelAtlas:_create(number, fileName, 17, 22, 43)
        number:setAnchorPoint(cc.p(0.5, 0.5))
        number:setPosition(cc.p(self._move_pos.x, self._move_pos.y + 90))
        number:setScale(hScale * 0.5)
        number:setOpacity(0)

        -- step 1
        number:runAction(cc.Sequence:create({
                cc.Spawn:create({cc.MoveBy:create(10 / 60 * __fight_recorder_action_time_speed, cc.p(0, 16)),
                        cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, hScale * 1.1),
                        cc.FadeTo:create(10 / 60 * __fight_recorder_action_time_speed, 255)
                    }),
                cc.ScaleTo:create(9 / 60 * __fight_recorder_action_time_speed, hScale * 1.0),
                cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
                cc.Spawn:create({cc.MoveBy:create(15 / 60 * __fight_recorder_action_time_speed, cc.p(0, 34)), 
                    cc.FadeTo:create(15 / 60 * __fight_recorder_action_time_speed, 0)}),
                cc.CallFunc:create(removeDrawAntNumberFuncN)
            }))

        self._parent:addChild(number, _scene_zorder_hurt)
    else
        local nodeNumber = csb.createNode(csbFile)
        nodeNumber:setPosition(cc.p(self._move_pos.x, self._move_pos.y + 90))
        nodeNumber:setScale(hScale)
        local root = nodeNumber:getChildByName("root")
        local BitmapFontLabel_blood = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_blood")
        BitmapFontLabel_blood:setString(number)
        self._parent:addChild(nodeNumber, _scene_zorder_hurt)

        local action = csb.createTimeline(csbFile)
        nodeNumber:runAction(action)
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end
            local str = frame:getEvent()
            if str == "animation_text_over" then
                nodeNumber:removeFromParent(true)
                nodeNumber = nil
            end
        end)
        action:play("animation_text", false)
    end

    if self._camp == 0 and self._hero_type ~= self._enum_hero_type._dogface then
        state_machine.excute("battle_ui_update_role_hp", 0, {role = self, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp})
    end
end

-- 绘制伤害
function BattleRole:drawHurt(hurt, attackType, crit)
    if self._scene._fight_type == battle_enum._fight_type._fight_type_18 then
        if self._camp == 1 then
            ___total_damage = ___total_damage + hurt
        end
    end
    hurt = math.ceil(hurt)
    if hurt > 0 then
        local csbFile = nil
        if self._camp == 0 then
            csbFile = config_csb.battle.battle_text_1
        else
            csbFile = config_csb.battle.battle_text_2
        end
        if crit == true and nil ~= config_csb.battle.battle_text_critical then
            self:drawAttackStatusAction(config_csb.battle.battle_text_critical, hurt)
        else
            self:drawInfluenceNumber("-"..hurt, attackType, "images/ui/number/xue.png", crit, config_csb.battle.battle_text_damage or csbFile)
        end
    end

    -- local hScale = 1.0
    -- if attackType > 0 then
    --     hScale = 1.5
    -- end

    -- local number = cc.LabelAtlas:_create("-"..hurt, "images/ui/number/xue.png", 17, 22, 43)
    -- number:setAnchorPoint(cc.p(0.5, 0.5))
    -- number:setPosition(cc.p(self._move_pos.x, self._move_pos.y + 90))
    -- number:setScale(hScale * 0.5)
    -- number:setOpacity(0)

    -- -- step 1
    -- number:runAction(cc.Sequence:create({
    --         cc.Spawn:create({cc.MoveBy:create(10 / 60 * __fight_recorder_action_time_speed, cc.p(0, 16)),
    --                 cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, hScale * 1.1),
    --                 cc.FadeTo:create(10 / 60 * __fight_recorder_action_time_speed, 255)
    --             }),
    --         cc.ScaleTo:create(9 / 60 * __fight_recorder_action_time_speed, hScale * 1.0),
    --         cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
    --         cc.Spawn:create({cc.MoveBy:create(15 / 60 * __fight_recorder_action_time_speed, cc.p(0, 34)), 
    --             cc.FadeTo:create(15 / 60 * __fight_recorder_action_time_speed, 0)}),
    --         cc.CallFunc:create(removeDrawAntNumberFuncN)
    --     }))

    -- -- -- step 1
    -- -- number:runAction(cc.MoveBy:create(10 / 60 * __fight_recorder_action_time_speed, cc.p(0, 16)))
    -- -- number:runAction(cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, hScale))
    -- -- number:runAction(cc.Sequence:create({cc.FadeTo:create(10 / 60 * __fight_recorder_action_time_speed, 255),
    -- --         cc.CallFunc:create(function(sender) 
    -- --             -- step 2
    -- --             sender:runAction(cc.Sequence:create({cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
    -- --                     cc.CallFunc:create(function(sender) 
    -- --                             -- step 3
    -- --                             sender:runAction(cc.Sequence:create({cc.MoveBy:create(15 / 60 * __fight_recorder_action_time_speed, cc.p(0, 30)), cc.MoveBy:create(30 / 60 * __fight_recorder_action_time_speed, cc.p(0, 30))}))
    -- --                             sender:runAction(cc.Sequence:create({cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed), 
    -- --                                     cc.FadeTo:create(30 / 60 * __fight_recorder_action_time_speed, 1.0),
    -- --                                     cc.CallFunc:create(removeDrawAntNumberFuncN)
    -- --                                 }))
    -- --                         end)
    -- --                 }))
    -- --         end)
    -- --     }))
    
    -- -- local arrayForFadeOut = {
    -- --         cc.ScaleTo:create(5 / 60 * __fight_recorder_action_time_speed, 2.0 * 0.2),
    -- --         cc.DelayTime:create(5 / 60 * __fight_recorder_action_time_speed),
    -- --         cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, 1.0 * 0.2),
    -- --         cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
    -- --         cc.MoveBy:create(25 / 60 * __fight_recorder_action_time_speed, cc.p(0, 118)),
    -- --         cc.MoveBy:create(10 / 60 * __fight_recorder_action_time_speed, cc.p(0, 146)),
    -- --         cc.FadeOut:create(10 / 60 * __fight_recorder_action_time_speed),
    -- --         cc.CallFunc:create(removeDrawAntNumberFuncN)
    -- --     }
    -- -- local fadeOutSeq = cc.Sequence:create(arrayForFadeOut)
    -- -- number:runAction(fadeOutSeq)
    -- -- number:setPosition(self._move_pos)
    -- self._parent:addChild(number, _scene_zorder_hurt)

    -- if self._camp == 0 and self._hero_type ~= self._enum_hero_type._dogface then
    --     state_machine.excute("battle_ui_update_role_hp", 0, {role = self, shipId = self._shipId, hp = self._hp, maxHp = self._max_hp})
    -- end
end

-- 绘制加血
function BattleRole:drawReply(reply, attackType)
    if tonumber(reply) > 0 then
        if nil ~= config_csb.battle.battle_text_recovery then
            self:drawAttackStatusAction(config_csb.battle.battle_text_recovery, "+"..reply)
        else
            self:drawInfluenceNumber("+"..reply, attackType, "images/ui/number/jiaxue.png", config_csb.battle.battle_text)
        end
    end
end

-- 绘制吸血
function BattleRole:drawBloodsucking(attackType, skillInfluenceType, accepter)
    self:drawReply(math.ceil(accepter.bloodsucking.value), attackType)

    local baseName = "effect/effect_"..accepter.skill.buff_effect
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)

    -- 完成删除特效 event.skeletonAnimation._self调用方 子弹
    skeletonNode:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)

    skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
    self:addChild(skeletonNode, _scene_zorder_effect)
end

function BattleRole:drawAttackStatusAction(csbFile, number)
    local nodeNumber = csb.createNode(csbFile)
    nodeNumber:setPosition(cc.p(self._move_pos.x, self._move_pos.y + 90))
    local root = nodeNumber:getChildByName("root")
    if nil ~= number then
        local BitmapFontLabel_blood = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_blood")
        BitmapFontLabel_blood:setString(number)
    end
    self._parent:addChild(nodeNumber, _scene_zorder_hurt)

    local action = csb.createTimeline(csbFile)
    nodeNumber:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "animation_text_over" then
            nodeNumber:removeFromParent(true)
            nodeNumber = nil
        end
    end)
    action:play("animation_text", false)
end

-- 绘制MISS
function BattleRole:drawMiss()
    -- local hScale = 1.0
    -- local miss = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shanbi.png")
    -- miss:setAnchorPoint(cc.p(0.5, 0.5))
    -- miss:setPosition(cc.p(self._move_pos.x, self._move_pos.y + 90))
    -- self._parent:addChild(miss, _scene_zorder_miss)
    -- miss:setScale(hScale * 0.5)
    -- miss:setOpacity(0)

    -- -- local seq = cc.Sequence:create(
    -- --     cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, 100)),
    -- --     cc.CallFunc:create(removeDrawAntNumberFuncN)
    -- -- )
    -- miss:runAction(cc.Sequence:create({
    --         cc.Spawn:create({cc.MoveBy:create(10 / 60 * __fight_recorder_action_time_speed, cc.p(0, 30)),
    --                 cc.ScaleTo:create(10 / 60 * __fight_recorder_action_time_speed, hScale * 1.1),
    --                 cc.FadeTo:create(10 / 60 * __fight_recorder_action_time_speed, 255)
    --             }),
    --         cc.ScaleTo:create(9 / 60 * __fight_recorder_action_time_speed, hScale * 1.0),
    --         cc.DelayTime:create(15 / 60 * __fight_recorder_action_time_speed),
    --         cc.FadeTo:create(20 / 60 * __fight_recorder_action_time_speed, 0),
    --         cc.CallFunc:create(removeDrawAntNumberFuncN)
    --     }))
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	BattleBuff.drawTextureAction(self, "images/ui/battle/shanbi.png")
    else
		if nil ~= config_csb.battle.battle_text_miss then
			self:drawAttackStatusAction(config_csb.battle.battle_text_miss, nil)
		else
			BattleBuff.drawTextureAction(self, "images/ui/battle/shanbi.png")
		end
    end
end

-- 寻路
function BattleRole:search(t)
    local path = nil
    if self.isOpenMove == true then
        if zstring.tonumber(self._camp) == 0 then
            path = state_machine.excute("battle_map_pathfinding", 0, {object = self, mx = self._move_pos.x, my = self._move_pos.y, dx = self._start_pos.x+self.moveNumber, dy = self._move_pos.y})
            self.isOpenMoveTime = self.isOpenMoveTime-t
            if self._move_pos.x >= self._start_pos.x+self.moveNumber-40 then
                self._move_state = self._enum_move_state._wait
                local actionIndex = self._sprite._actionIndex - (self._sprite._actionIndex % _spine_sprite_animation_team_count)
                self._sprite._nextAction = actionIndex
                csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
                if self.isOpenMoveTime <= 0 then
                    self.isOpenMove = false
                end
            end
        else
            path = state_machine.excute("battle_map_pathfinding", 0, {object = self, mx = self._move_pos.x, my = self._move_pos.y, dx = self._start_pos.x-self.moveNumber, dy = self._move_pos.y})
            self.isOpenMoveTime = self.isOpenMoveTime-t
            if self._move_pos.x <= self._start_pos.x-self.moveNumber+40 then
                self._move_state = self._enum_move_state._wait
                local actionIndex = self._sprite._actionIndex - (self._sprite._actionIndex % _spine_sprite_animation_team_count)
                self._sprite._nextAction = actionIndex
                csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
                if self.isOpenMoveTime <= 0 then
                    self.isOpenMove = false
                end
            end
        end
    else
        self._byLockAttackTarget._move_pos = cc.p(self._byLockAttackTarget:getPosition())
        local targetPostion = self._byLockAttackTarget._move_pos
        if self._range > 100 then
            targetPostion.y = self._move_pos.y
        end
        path = state_machine.excute("battle_map_pathfinding", 0, {object = self, mx = self._move_pos.x, my = self._move_pos.y, dx = self._byLockAttackTarget._move_pos.x, dy = self._byLockAttackTarget._move_pos.y})
    end
    -- local path = state_machine.excute("battle_map_pathfinding", 0, {self._move_pos.x , self._move_pos.y, self._byLockAttackTarget._move_pos.x, self._byLockAttackTarget._move_pos.y})
    -- local path = state_machine.excute("battle_map_pathfinding", 0, {self._move_pos.x , self._move_pos.y, self._vector.x, self._vector.y})
    self._path = path
    if self._path ~= nil and #self._path > 0 then
        if #self._path > 50 then
            -- self:clearPath()
            -- print("路径被清除")
            -- self._move_state = self._enum_move_state._wait
            -- local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count
            -- self._sprite._nextAction = actionIndex
            -- -- csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            return true
        end

        local cell = path[1]
        if self._cell._curr_node == cell then
            table.remove(self._path, 1)
            if cell._lineLayer ~= nil then
                -- cell._lineLayer:removeFromParent(true)
                cell._lineLayer:setVisible(false)
            end
        end

        if #self._path > 0 then
            self._move_state = self._enum_move_state._search
            return true
        end
    else
        -- print("有碰撞，无路可走了。")
        self._move_state = self._enum_move_state._wait
        local actionIndex = self._sprite._actionIndex - (self._sprite._actionIndex % _spine_sprite_animation_team_count)
        self._sprite._nextAction = actionIndex
        -- csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
        return true
    end
end

function BattleRole:clearPath()
    if self._path ~= nil and #self._path > 0 then

        while #self._path > 0 do
            local cell = table.remove(self._path, 1)
            if cell._lineLayer ~= nil then
                -- cell._lineLayer:removeFromParent(true)
                -- cell._lineLayer = nil
                cell._lineLayer:setVisible(false)
            end
        end
    end
    self._move_pos = cc.p(self:getPosition())
end

-- 检测碰撞 用于寻路
function BattleRole:checkCollision(move_pos)
    if self._move_state == self._enum_move_state._search or self._byLockAttackTarget == nil then
        return false
    end
    local passable, obstacle = state_machine.excute("battle_map_check_collision", 0, {object = self, cell = self._cell._curr_node, pos = move_pos, size = self._collision_size})
    if passable == true then
        -->print("发生了碰撞!", self._sprite_id, obstacle:getPassable(), obstacle._object, obstacle._object._sprite_id)
        -- 寻路
        self:clearPath()
        local path = state_machine.excute("battle_map_pathfinding", 0, {object = self, mx = self._move_pos.x, my = self._move_pos.y, dx = self._byLockAttackTarget._move_pos.x, dy = self._byLockAttackTarget._move_pos.y})
        self._path = path
        if self._path ~= nil and #self._path > 0 then
            if #self._path > 50 then
                self:clearPath()
                -->print("路径被清除")
                self._move_state = self._enum_move_state._wait
                local actionIndex = self._sprite._actionIndex - (self._sprite._actionIndex % _spine_sprite_animation_team_count)
                self._sprite._nextAction = actionIndex
                -- csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
                return true
            end

            local cell = path[1]
            if self._cell._curr_node == cell then
                table.remove(self._path, 1)
                if cell._lineLayer ~= nil then
                    cell._lineLayer:removeFromParent(true)
                end
            end

            if #self._path > 0 then
                self._move_state = self._enum_move_state._search
                return true
            end
        else
            -- print("有碰撞，无路可走了。")
            self._move_state = self._enum_move_state._wait
            local actionIndex = self._sprite._actionIndex - (self._sprite._actionIndex % _spine_sprite_animation_team_count)
            self._sprite._nextAction = actionIndex
            -- csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            return true
        end
    end
    return false
end

-- 检测碰撞框 暂时没用到
function BattleRole:checkCollisionRect(params)
    local rect = params
    if rect.object ~= self then
        if rect.pos.x > self._move_pos.x
            and rect.pos.x < self._move_pos.x + self._collision_size.width
            and rect.pos.y > self._move_pos.y
            and rect.pos.y < self._move_pos.y + self._collision_size.height
            then
            local obstacle = {
                name = "",
                node = self,
                rect = {
                    pos = self._move_pos,
                    size = self._collision_size
                }
            }
            return true, obstacle
        end
    end
    return false, nil
end

function BattleRole:addAttackEffect( ... )
    local baseName = "effect/effect_jinengshifang"
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    skeletonNode:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode:setAnimation(0, "animation", true)
    self:addChild(skeletonNode, -10000)

    baseName = "effect/effect_jinengshifang2"
    local skeletonNode2 = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    skeletonNode2:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode2:setAnimation(0, "animation", true)
    self:addChild(skeletonNode2)
end

-- 检查攻击方位 
function BattleRole:checkAttack(move_pos, vector)
    if move_pos == nil and vector == nil then
        if self._camp == 0 then
            self._targetIndex = 3
        else
            self._targetIndex = 9
        end

        local actionIndex = self._targetIndex * _spine_sprite_animation_team_count + 2
        self._targetIndex = -1
        if actionIndex ~= self._sprite._actionIndex 
            then
            if self._use_god_skill == true then
                actionIndex = actionIndex + 2
            else
                actionIndex = actionIndex + self._attack_type
            end
            csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            self._sprite._nextAction = actionIndex
        end
    else
        local at = CC_POSITIONS_TO_DEGREES(cc.p(move_pos), vector)
        if at < 0 then
            at = at - 7.5
        else
            at = at + 7.5
        end
        -- self:runAction(cc.RotateTo:create(3.5, at))

        local actionIndex = math.modf(at / (360.0 / 24.0))
        if actionIndex < 0 then
            -- actionIndex = -1 * actionIndex + 13
            actionIndex = 12 + actionIndex + 12
        end
        -- self._targetIndex = actionIndex + 1
        self._targetIndex = actionIndex

        self._angle = at

        local actionIndex = self._targetIndex * _spine_sprite_animation_team_count + 2
        self._targetIndex = -1
        if actionIndex ~= self._sprite._actionIndex 
            then
            if self._use_god_skill == true then
                actionIndex = actionIndex + 2
            else
                actionIndex = actionIndex + self._attack_type
            end
            csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            self._sprite._nextAction = actionIndex
            -- if (actionIndex % _spine_sprite_animation_team_count) == 0 then
            --     actionIndex = actionIndex + self._attack_type
            --     csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            -- elseif (actionIndex % _spine_sprite_animation_team_count) == 1 then
            --     actionIndex = actionIndex + self._attack_type
            --     csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            -- end
        end
    end

    if self._current_skill ~= nil and self._current_skill.start_ani_sound_effect_id > 0 then
        playEffectMusic(self._current_skill.start_ani_sound_effect_id)
    end
end

-- 检查攻击距离是否达到攻击条件
function BattleRole:checkByAttack(attaker)
    if self._death == true or attaker._death == true then
        return false
    end

    if attaker._hero_type == attaker._enum_hero_type._dogface and attaker._hero ~= nil then
        if attaker._hero._byLockAttackTarget == self or attaker._hero._byAttackTarget == self then
        else
            return false
        end
    end
    local spaceX = math.abs(attaker._move_pos.x - self._move_pos.x)
    local spaceY = math.abs(attaker._move_pos.y - self._move_pos.y)
    if attaker._range >= spaceX
        or attaker._range >= spaceY
        then
        local space = math.sqrt(spaceX * spaceX + spaceY * spaceY)
        if space <= attaker._range then
            return true, space
        end
    end
    return false
end

-- 检查范围攻击受影响对象 用于范围技能
function BattleRole:checkByAttackerRange(pos, range, skill_range_type)
    -- 0.圆形
    if skill_range_type == 0 then
        local spaceX = math.abs(pos.x - self._move_pos.x)
        local spaceY = math.abs(pos.y - self._move_pos.y)
        if range.x >= spaceX
            or range.x >= spaceY
            then
            local space = math.sqrt(spaceX * spaceX + spaceY * spaceY)
            if space <= range.x then
                return true
            end
        end
        return false
    end

    -- 1.矩形
    if skill_range_type == 1 then
        local spaceX = math.abs(pos.x - self._move_pos.x)
        local spaceY = math.abs(pos.y - self._move_pos.y)
        if (range / 2 ) >= spaceX and (range / 2) >= spaceY then
            return true
        end
        return false
    end

    -- 1.矩形2
    if skill_range_type == 2 then
        -- 像素距离
        local spaceX = math.abs(pos.x - self._move_pos.x)
        local spaceY = math.abs(pos.y - self._move_pos.y)
        -- 格子距离
        spaceX = math.abs(pos.x - self._coord_x)
        spaceY = math.abs(pos.y - self._coord_y)

        if range.x >= spaceX and range.y >= spaceY then
            return true
        end
        return false
    end
end

function BattleRole:checkByAttacker()
    local lockAttackTarget, space, mspace
    if self._hero_type == self._enum_hero_type._dogface 
        then
        return self._hero._byLockAttackTarget, nil, nil
    else
        if self._byLockAttackTarget == nil 
            or self._byLockAttackTarget._death 
            then
            lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {self, self._camp})
            self._byLockAttackTarget = lockAttackTarget
        else
            lockAttackTarget = self._byLockAttackTarget
        end
        return lockAttackTarget, space, mspace
    end
    -- local lockAttackTarget, space, mspace

    -- --小兵在主角存在的时候跟主角打同一个目标
    -- if self._hero_type == self._enum_hero_type._dogface 
    --     and self._hero ~= nil 
    --     -- and self._hero._death == false 
    --     and self._hero._byLockAttackTarget ~= nil
    --     then
    --     self._byLockAttackTarget = self._hero._byLockAttackTarget
    --     if self._byLockAttackTarget._death == true then
    --         self._byLockAttackTarget = nil
    --         self._hero._byLockAttackTarget = nil
    --     end
    -- end

    -- if self._byLockAttackTarget == nil 
    --     or self._byLockAttackTarget._death 
    --     then

    --     if lockAttackTarget == nil 
    --         and self._hero ~= nil 
    --         and self._hero._death == false
    --         then
    --         lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {self._hero, self._hero._camp})
    --     end

    --     if lockAttackTarget == nil then
    --         lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {self, self._camp})
    --     end
    --     if lockAttackTarget ~= nil 
    --         and lockAttackTarget._death == true 
    --         then
    --         lockAttackTarget= nil
    --     end
    --     self._byLockAttackTarget = lockAttackTarget
    -- end

    -- if self._byLockAttackTarget ~= nil
    --     and self._hero ~= nil 
    --     and self._hero._death == false
    --     and self._hero._byLockAttackTarget == nil
    --     then
    --     self._hero._byLockAttackTarget = self._byLockAttackTarget
    -- end
    -- return lockAttackTarget, space, mspace
end

-- 锁定被攻击者 看其是否可以锁定
function BattleRole:lockByAttack(attaker)
    -- step 1
    if self._death == true or attaker._death == true then
        return false
    end
    local sx, sy = attaker:getPosition()
    local ex, ey = self:getPosition()

    local spaceX = math.abs(ex - sx)
    local spaceY = math.abs(ey - sy)
    local mspace = math.sqrt(spaceX * spaceX + spaceY * spaceY)
    local space = mspace
    -- if attaker._range > 100 then
    --     space = spaceX
    --     mspace = spaceX
    -- else
    --     space = spaceX
    --     mspace = math.sqrt(spaceX * spaceX + spaceY * spaceY)
    -- end

    -- step 2
    -- if self._death == true or attaker._death == true then
    --     return false
    -- end
    -- local sx, sy = attaker:getPosition()
    -- local ex, ey = self:getPosition()

    -- local spaceX = math.abs(ex - sx)
    -- local spaceY = math.abs(ey - sy)
    -- local mspace = 0
    -- local space = 0
    -- if attaker._range > 100 then
    --     space = spaceX
    --     mspace = spaceX
    -- else
    --     space = spaceX
    --     mspace = math.sqrt(spaceX * spaceX + spaceY * spaceY)
    -- end
    return true, space, mspace
end

function BattleRole:space(scr, disc)
    local spaceX = math.abs(disc.x - scr.x)
    local spaceY = math.abs(disc.y - scr.y)
    local mspace = math.sqrt(spaceX * spaceX + spaceY * spaceY)
    return mspace
end

-- 角色死亡后清除其攻击者 攻击目标
function BattleRole:clearByAttackerState(byAttackTarget)
    if byAttackTarget == self._byAttackTarget 
        or byAttackTarget == self._byLockAttackTarget
        then
        if self._camp == 0 
            and self._hero_type == self._enum_hero_type._hero 
            -- and lastLockAttackTarget ~= self._byLockAttackTarget
            then
            -- state_machine.excute("battle_ui_update_role_reset", 0, {role = self, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp, sp = self._sp, maxSp = self._max_sp, showSpEffect = true})
        end

        if self._use_god_skill == true then
            if self:getChildByTag(300000) ~= nil then
                self:removeChildByTag(300000)
            end
        end

        self._by_lock = false

        self._byAttackTarget = nil
        local lockAttackTarget, space = state_machine.excute("battle_scene_lock_attack", 0, {self, self._camp})
        self._byLockAttackTarget = lockAttackTarget
        self._run_state = self._enum_run_state._run
        self._sleep_cd = 0.1
        -- self._attack_wait_cd = 1

        self:clearPath()
        --::self:stopAllActions()

        self._byAttackTargetCamp = byAttackTarget._camp
        self._byAttackTargetPosition = cc.p(byAttackTarget:getPosition())
    end
end

function BattleRole:executeSkills(skillType, skillId)
    local skills = self._buff_skills[skillType]
    if nil ~= skills then
        for i, skill in pairs(skills) do
            if skill.id ~= skillId then
                if tonumber(skill.trigger_timing) == battle_enum._skill_influence_trigger._physical_attack then
                    if self._normal_attack_count == tonumber(skill.trigger_need_value) 
                        and self._active_god_skill == false
                        then
                        self._active_god_skill = true
                        self._base_god_attack_times = tonumber(skill.trigger_need_value)
                        self:addGodEffect()
                    end
                else
                    if tonumber(skill.skill_influence_type) == 53 then
                        if self._is_used_not_death == false then
                            self._is_used_not_death = true
                            self:executeSkill(skill)
                        end
                    else
                        self:executeSkill(skill)
                    end
                end
            end
        end
    end
end

function BattleRole:executeSkill(skill)
    local byAttackTarget = self._byAttackTarget
    local yLockAttackTarget = self._byLockAttackTarget
    local needCheckRange, targets = state_machine.excute("battle_scene_lock_skill_attack", 0, {self, self._camp, skill})
    self._byAttackTarget = byAttackTarget
    self._byLockAttackTarget = yLockAttackTarget
    for _, target in pairs(targets) do
        local accepter = {}
        battle_logic.attack(self._heroBattleObject, target._heroBattleObject, skill, accepter, skill.skill_property, target._battle_type)
        if accepter.invalid ~= true then
            local skillInfluenceType = accepter.skill.skill_influence_type
            if true ~= accepter.miss 
                and true ~= accepter.parry 
                then
                target:drawInfluence(skill.skill_quality, skillInfluenceType, accepter)
            end

            if accepter.accepters ~= nil then
                for i, v in pairs(accepter.accepters) do
                    if v.invalid ~= true then
                        local tskillInfluenceType = v.skill.skill_influence_type
                        target:drawInfluence(v.skill.skill_quality, tskillInfluenceType, v)
                    end
                end
            end

            local damage = 0
            if accepter.damage ~= nil then
                damage = accepter.damage.value
            end
            
            -- if skillInfluenceType == 0 
            --     or skillInfluenceType == 1
            --     then
                target._hp = target._hp - damage
                if target._undead == true and target._hp <= 1 then
                    target._hp = 1
                end
                if tonumber(damage) ~= 0 then
                    target:drawHit(target, damage, true)
                end
            -- end
        end
    end
end

function BattleRole:executeMasterSkill(skill)
    self._skills = self._skills or {}
    self._skills[1] = skill
    self._skills[2] = skill
    self._skills[3] = skill
    self._is_skill = true
    self._sp = self._max_sp
    self._heroBattleObject = {_role = self}
    local srole = battle_logic.maxAttacker(self._heroBattleObject)
    self._heroBattleObject = srole._heroBattleObject
    skill.skill_property = srole._skills[2].skill_property
    -- local needCheckRange, targets = state_machine.excute("battle_scene_lock_skill_attack", 0, {self, self._camp, skill})

    self:setVisible(true)

    local lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {self, self._camp})
    self._byLockAttackTarget = lockAttackTarget
    if nil == lockAttackTarget then
        return
    end
    
    self:attackTarget(self._byLockAttackTarget)

    -- 绘制主公技技能释放特效
    if config_res.battle ~= nil and config_res.battle.effect ~= nil and config_res.battle.effect.general_skill_effect ~= nil then
        state_machine.excute("battle_player_skill_effect_window_open", 0, {self._camp})
    end
end

-- 寻路
function BattleRole:finding(lockAttackTarget)
    -- local flag = 1
    -- if lockAttackTarget._camp == 1 then
    --     flag = -1
    -- end
    
    -- local coord_y = nil
    -- local coord_x = nil

    -- if self._range <= 1 then
    --     coord_y = lockAttackTarget._coord_y + flag
    --     coord_x = lockAttackTarget._coord_x
    --     if self._coord_x < coord_x then
    --         coord_x = coord_x - 1
    --     elseif self._coord_x > coord_x then
    --         coord_x = coord_x + 1
    --     else
    --         coord_x = coord_x
    --     end
    --     coord_x = math.max(1, math.min(7, coord_x))
    -- else
    --     coord_y = lockAttackTarget._coord_y + flag * self._range
    --     coord_x = self._coord_x
    -- end

    -- -- 生成路径
    -- local path = {}
    -- while coord_y ~= self._coord_y do
    --     if coord_y > self._coord_y then
    --         coord_y = coord_y - 1
    --     else
    --         coord_y = coord_y + 1
    --     end
    --     table.insert(path, {x = coord_x, y = coord_y})
    -- end
    -- while coord_x ~= self._coord_x do
    --     if coord_x > self._coord_x then
    --         coord_x = coord_x - 1
    --     else
    --         coord_x = coord_x + 1
    --     end
    --     table.insert(path, {x = coord_x, y = coord_y})
    -- end
    -- debug.print_r(path)
    -- return path


    -- local flag = 1
    -- if lockAttackTarget._camp == 1 then
    --     flag = -1
    -- end
    
    -- local coord_y = lockAttackTarget._coord_y + flag * self._range
    -- local coord_x = lockAttackTarget._coord_x

    -- if self._range <= 1 then
    --     local xy = nil
    --     if self._coord_x > coord_x then
    --         xy = {{coord_x + 1, coord_y}, {coord_x, coord_y}, {coord_x - 1, coord_y}}
    --     elseif self._coord_x < coord_x then
    --         xy = {{coord_x - 1, coord_y}, {coord_x, coord_y}, {coord_x + 1, coord_y}}
    --     else
    --         xy = {{coord_x, coord_y}, {coord_x + 1, coord_y}, {coord_x - 1, coord_y}}
    --     end
    --     for i, v in pairs(xy) do
    --         if ___role_coords_status[v.coord_y][v.coord_x] == nil then
    --             self._coord_y = v.coord_y
    --             self._coord_x = v.coord_x
    --             return true, v.coord_y, v.coord_x
    --         end
    --     end
    -- end
    -- return false

    local coord_y = self._coord_y
    local coord_x = lockAttackTarget._coord_x
    local xy = nil
    if self._coord_x > coord_x then
        xy = {{x = coord_x + 1, y = coord_y}, {x = coord_x, y = coord_y}, {x = coord_x - 1, y = coord_y}}
    elseif self._coord_x < coord_x then
        xy = {{x = coord_x - 1, y = coord_y}, {x = coord_x, y = coord_y}, {x = coord_x + 1, y = coord_y}}
    else
        xy = {{x = coord_x, y = coord_y}, {x = coord_x + 1, y = coord_y}, {x = coord_x - 1, y = coord_y}}
    end
    for i, v in pairs(xy) do
        if v.x >= 1 and v.x <= 7 then
            if ___role_coords_status[v.y][v.x] == nil then
                return true, v.y, v.x
            end
        end
    end
    return false
end

function BattleRole:partnerMoveToFightArena()
    local endPosition = ___role_coords[self._coord_y][battle_enum._partner_start_position[2]]
    self:move(self._start_pos, endPosition)
    t = 0.4 * math.abs(battle_enum._partner_start_position[1] - self._coord_y)
    local moveInfo = {}
    moveInfo.coord_y = self._coord_y
    moveInfo.coord_x = battle_enum._partner_start_position[2]
    moveInfo.move_dir = self._move_dir
    moveInfo.speed = 1
    table.insert(self._follow_path, moveInfo)
    self:teamFollowCell()

    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, endPosition),
        cc.CallFunc:create(function(sender)
            t = 0.4 * math.abs(battle_enum._partner_start_position[2] - sender._coord_x)
            local startPosition = ___role_coords[self._coord_y][battle_enum._partner_start_position[2]]
            local endPosition = ___role_coords[sender._coord_y][sender._coord_x]
            sender:move(startPosition, endPosition)
            sender:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, endPosition),
                cc.CallFunc:create(function(sender)
                    state_machine.excute("battle_ui_add_partner_icon", 0, sender._heroBattleObject)
                    state_machine.excute("battle_scene_ready_move_to_fight_arena", 0, nil)
                    end)
                }))
            local moveInfo = {}
            moveInfo.coord_y = sender._coord_y
            moveInfo.coord_x = sender._coord_x
            moveInfo.move_dir = sender._move_dir
            moveInfo.speed = 1
            table.insert(sender._follow_path, moveInfo)
            sender:teamFollowCell()
        end)
    }))
end

-- 移动到战斗区域
function BattleRole:moveToFightArena(startPosition, endPosition, checkPartner)
    self:move(startPosition, endPosition)
    local mp = cc.p((endPosition.x - startPosition.x), (endPosition.y - startPosition.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013
    
    local row = math.modf((self._formation_index - 1) / 3 + 1)
    local column = (self._formation_index - 1) % 3 + 1
    if camp == 0 then
        t = 0.4 * math.abs(battle_enum._fix_start_pos[row][1] - battle_enum._fix_attack_position[row][1])
    else
        t = 0.4 * math.abs(battle_enum._fix_start_pos[row][2] - battle_enum._fix_attack_position[row][2])
    end

    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, endPosition),
            cc.CallFunc:create(function(sender)
                    -- -- if sender._scene._battle_index > 1 then
                    -- --     sender._move_state = sender._enum_move_state._moving
                    -- --     sender._run_state = sender._enum_run_state._run
                    -- --     sender:onUpdate(0)
                    -- -- else
                    -- --     -- sender._move_state = sender._enum_move_state._moving
                    -- --     -- sender:onSleep()
                    -- --     -- state_machine.excute("battle_scene_start_attack", 0, nil)

                    --     -- local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                    --     -- actionIndex = actionIndex * _spine_sprite_animation_team_count
                    --     -- csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)

                    --     sender._move_pos = cc.p(sender:getPosition())

                    --     sender._run_state = sender._enum_run_state._wait
                    --     if sender._hero_type == sender._enum_hero_type._hero
                    --         then
                    --         if state_machine.excute("battle_scene_start_attack", 0, {sender, false}) == true then
                    --             sender:onUpdate(0)
                    --             sender._move_state = sender._enum_move_state._moving
                    --             for i, v in pairs(sender._team) do
                    --                 v._move_state = v._enum_move_state._moving
                    --                 v:onUpdate(0)
                    --             end
                    --         else
                    --             -- if sender._camp == 1
                    --             -- and sender._range <= 100
                    --             -- then
                    --             local lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {sender, sender._camp})
                    --             if lockAttackTarget ~= nil then 
                    --                 if mspace == nil then
                    --                     _, space, mspace = lockAttackTarget:lockByAttack(sender)
                    --                 end
                    --                 local moveByX = lockAttackTarget:getPositionX() - sender:getPositionX()
                    --                 sender:moveTo(cc.p(sender._move_pos.x + moveByX, sender._move_pos.y))
                    --                 for i, v in pairs(sender._team) do
                    --                     v._move_pos = cc.p(v:getPosition())
                    --                     v:moveTo(cc.p(v._move_pos.x + moveByX, v._move_pos.y))
                    --                 end
                    --             else
                    --                 sender:onSleep()
                    --             end
                    --         end
                    --         if sender._camp == 0 then
                    --             state_machine.excute("battle_ui_un_set_all_majesty_skill_cannot_use", 0, 0)
                    --         end
                    --     end
                    -- -- end

                    -- step 1
                    -- sender._run_state = sender._enum_run_state._run
                    -- sender._move_state = sender._enum_move_state._moving

                    -- step 2
                    -- sender._run_state = sender._enum_run_state._wait

                    -- -- step 3
                    -- sender._run_state = sender._enum_run_state._lock_attack
                    -- local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                    -- actionIndex = actionIndex * _spine_sprite_animation_team_count
                    -- sender._sprite._nextAction = actionIndex
                    -- state_machine.excute("battle_scene_check_start_attack", 0, 0)

                    -- -- step 4
                    -- sender._run_state = sender._enum_run_state._lock_attack
                    -- if sender._hero_type == sender._enum_hero_type._hero then
                    --     if sender._camp == 0 then
                    --         -- sender:moveToByAttackTarget(___role_coords[sender._attack_coord_y - (sender._formation_row_b * 2 - 2)][sender._coord_x])
                    --         -- sender:moveToByAttackTarget(___role_coords[sender._coord_y + 1][sender._coord_x])
                    --         sender:moveToAttackLine(___role_coords[sender._coord_y + 1][sender._coord_x])
                    --         sender:changeToAttackCoord(sender._coord_y + 1, sender._coord_x)
                    --     else
                    --         -- sender:moveToByAttackTarget(___role_coords[sender._attack_coord_y + (sender._formation_row_b * 2 - 2)][sender._coord_x])
                    --         -- sender:moveToByAttackTarget(___role_coords[sender._coord_y - 1][sender._coord_x])
                    --         sender:moveToAttackLine(___role_coords[sender._coord_y - 1][sender._coord_x])
                    --         sender:changeToAttackCoord(sender._coord_y - 1, sender._coord_x)
                    --     end
                    --     sender:teamFollow(sender._coord_y, sender._coord_x)
                    -- end

                    -- -- step 5
                    -- local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                    -- actionIndex = actionIndex * _spine_sprite_animation_team_count
                    -- csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                    -- if sender._hero_type == sender._enum_hero_type._hero then
                    --     sender._move_dir = 4
                    --     sender:teamFollow(sender._coord_y, sender._coord_x)
                    -- end

                    -- -- step 6
                    -- if sender._run_state == sender._enum_run_state._wait
                    --     and sender._move_state == sender._enum_move_state._join
                    --     then
                    --     sender._run_state = sender._enum_run_state._lock_attack
                    -- end
                    -- if sender._hero_type == sender._enum_hero_type._hero then
                    --     if sender._camp == 0 then
                    --         -- sender:moveToByAttackTarget(___role_coords[sender._attack_coord_y - (sender._formation_row_b * 2 - 2)][sender._coord_x])
                    --         -- sender:moveToByAttackTarget(___role_coords[sender._coord_y + 1][sender._coord_x])
                    --         sender:moveToAttackLine(___role_coords[sender._coord_y + 1][sender._coord_x])
                    --         table.insert(self._follow_path, {coord_y = (sender._coord_y + 1), coord_x = sender._coord_x, move_dir = sender._move_dir, speed = 1})
                    --         sender:changeToAttackCoord(sender._coord_y + 1, sender._coord_x)
                    --     else
                    --         -- sender:moveToByAttackTarget(___role_coords[sender._attack_coord_y + (sender._formation_row_b * 2 - 2)][sender._coord_x])
                    --         -- sender:moveToByAttackTarget(___role_coords[sender._coord_y - 1][sender._coord_x])
                    --         sender:moveToAttackLine(___role_coords[sender._coord_y - 1][sender._coord_x])
                    --         table.insert(self._follow_path, {coord_y = (sender._coord_y - 1), coord_x = sender._coord_x, move_dir = sender._move_dir, speed = 1})
                    --         sender:changeToAttackCoord(sender._coord_y - 1, sender._coord_x)
                    --     end
                    --     -- sender:teamFollow(sender._coord_y, sender._coord_x)
                    --     sender:teamFollowEX()
                    -- end

                    -- -- step 7
                    -- if sender._hero_type == sender._enum_hero_type._hero then
                    --     if self._event ~= nil then
                    --         if self._event.attack_count == self._attack_count then
                    --             if self._event.execute_type == execute_type_battle_pause then
                    --                 state_machine.excute("battle_scene_pause", 0, 0)
                    --                 self._event = nil
                    --                 executeNextEvent(nil, nil)
                    --             end
                    --         end
                    --     end
                    --     local flag = 1
                    --     if sender._camp == 0 then
                    --         flag = -1
                    --     end
                    --     sender._frsitMoveEnd = false
                    --     sender._enterFightMoveEnd = false
                    --     local moveY = sender._coord_y
                    --     local attackNear, byAttackNear = state_machine.excute("battle_scene_check_team_have_near_attack", 0, 1)
                    --     if sender._formation_row == 1 then
                    --         if attackNear == true then
                    --             if byAttackNear == true then
                    --                 moveY = sender._attack_coord_y
                    --             else
                    --                 local lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {sender, sender._camp})
                    --                 moveY = lockAttackTarget._coord_y - 1 * flag
                    --             end
                    --         end
                    --         if sender._range > 1 then
                    --             moveY = sender._coord_y
                    --         end
                    --     else
                    --         sender._frsitMoveEnd = true
                    --         local baseLine = 0
                    --         if byAttackNear == false then
                    --             if sender._camp == 0 then
                    --                 baseLine = battle_enum._fix_attack_position[1][2]
                    --             else
                    --                 baseLine = battle_enum._fix_attack_position[1][1]
                    --             end
                    --         else
                    --             if attackNear == true then
                    --                 baseLine = sender._attack_coord_y - flag * 1
                    --             else
                    --                 baseLine = battle_enum._fix_attack_position[1][sender._camp + 1] - flag * 1
                    --             end
                    --         end
                    --         local range = sender._range
                    --         local space = math.abs(sender._coord_y - baseLine)
                    --         if range < space then
                    --             moveY = sender._coord_y - (space - range) * flag
                    --         end
                    --     end
                    --     local lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {sender, sender._camp})
                    --     local coord_x, coord_y = sender:fristMoveCoordXY(lockAttackTarget, moveY)
                    --     sender._fristEnterMoveX = coord_x
                    --     sender._fristEnterMoveY = coord_y
                    --     sender:fristMoveToAttackLine()
                    --     -- sender:moveToAttackLine(___role_coords[coord_y][coord_x])
                    --     -- table.insert(self._follow_path, {coord_y = coord_y, coord_x = sender._coord_x, move_dir = sender._move_dir, speed = 1})
                    --     -- table.insert(self._follow_path, {coord_y = coord_y, coord_x = coord_x, move_dir = sender._move_dir, speed = 1})
                    --     sender:changeToAttackCoord(coord_y, coord_x)
                    --     if sender._camp == 0 then
                    --         state_machine.excute("battle_ui_un_set_all_majesty_skill_cannot_use", 0, 0)
                    --     end

                    --     -- sender:teamFollowEX()
                    -- end

                    -- -- step 8
                    -- local lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {sender, sender._camp})
                    -- sender:finding(lockAttackTarget)

                    -- -- step 9
                    -- if sender._run_state == sender._enum_run_state._wait
                    --     and sender._move_state == sender._enum_move_state._join
                    --     then
                    --     sender._run_state = sender._enum_run_state._lock_attack
                    -- end
                    -- if sender._hero_type == sender._enum_hero_type._hero then
                    --     if sender._camp == 0 then
                    --         sender:moveToAttackLine(___role_coords[sender._attack_coord_y - (sender._formation_row_b * 2 - 2)][sender._coord_x])
                    --         sender:changeToAttackCoord(sender._attack_coord_y - (sender._formation_row_b * 2 - 2), sender._attack_coord_x)
                    --     else
                    --         sender:moveToAttackLine(___role_coords[sender._attack_coord_y + (sender._formation_row_b * 2 - 2)][sender._coord_x])
                    --         sender:changeToAttackCoord(sender._attack_coord_y + (sender._formation_row_b * 2 - 2), sender._attack_coord_x)
                    --     end
                    -- end

                    -- -- step 10
                    -- sender._run_state = sender._enum_run_state._wait
                    -- sender._move_state = sender._enum_move_state._moving

                    -- 执行攻击前的锁定事件
                    state_machine.excute("battle_scene_check_boos_introduce", 0, nil)
                    if sender._event ~= nil then
                        if sender._event.attack_count == sender._attack_count then
                            if sender._event.execute_type == execute_type_battle_pause then
                                state_machine.excute("battle_scene_defer_pause", 0, {forcing = true})
                                sender._event = nil
                                executeNextEvent(nil, nil)
                            elseif sender._event.execute_type == execute_type_add_role_power then
                                -- print("把我的怒气加满")
                                state_machine.excute("battle_scene_add_role_power", 0, sender._event)
                                sender._event = nil
                                executeNextEvent(nil, nil)
                            end
                        end
                    end
                    if checkPartner == true then
                        if sender._scene._fight_type == battle_enum._fight_type._fight_type_102 then
                            if sender._isPartner == true then
                                state_machine.excute("battle_scene_ready_move_to_fight_arena", 0, nil)
                            else
                                local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                                actionIndex = actionIndex * _spine_sprite_animation_team_count
                                csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                                sender._sprite._nextAction = actionIndex
                                state_machine.excute("battle_scene_ready_move_partner", 0, nil)
                            end
                        else
                            sender:moveToFightReadyArena()
                        end
                    else
                        sender:moveToFightReadyArena()
                    end
                end)
        }))
    return t
end

function BattleRole:moveToFightReadyArena( ... )
    local lockAttackTarget, space, mspace = state_machine.excute("battle_scene_lock_attack", 0, {self, self._camp})
    self._byLockAttackTarget = lockAttackTarget
    if self._hero_type == self._enum_hero_type._hero then
        if self._isPartner == true then
            self._run_state = self._enum_run_state._run
            self._move_state = self._enum_move_state._moving
        else
            if self._move_state == self._enum_move_state._join then
                self._run_state = self._enum_run_state._lock_attack
                self._move_state = self._enum_move_state._moving
            end
        end
        self:moving_cell_y(0)
    else
        self._run_state = self._enum_run_state._run
        self._move_state = self._enum_move_state._moving
    end
    if self._is_running ~= true then
        self._is_running = true
        -- 启动战斗效用
        if self._hero_type == self._enum_hero_type._hero then
            -- -- print("启动战斗效用:", sender._camp, sender._shipMouldId, sender._shipName, sender._sprite_id)
            -- local skills = sender._buff_skills[battle_enum._skill_influence_trigger._fight_start]
            -- -- if sender._shipMouldId == 258 then
            -- --     -- debug.print_r(sender._skills)
            -- -- end
            -- if nil ~= skills then
            --     for i, skill in pairs(skills) do
            --         sender:executeSkill(skill)
            --     end
            -- end

            self:executeSkills(battle_enum._skill_influence_trigger._fight_start)

            if self._camp == 0 then
                state_machine.excute("battle_ui_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
            else
                if self._battle_type == 1 then
                    state_machine.excute("battle_pvp_skill_update_role_sp", 0, {role = self, shipId = self._shipMouldId, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
                end
            end
            if self._pfeffect ~= nil 
                and decryptInfo(self._sp) >= decryptInfo(self._max_sp)
                then
                self._pfeffect:setVisible(true)
            end
            if self._camp == 0 then
                state_machine.excute("battle_ui_un_set_all_majesty_skill_cannot_use", 0, 0)
            end
        end
    end
end

-- 检测攻击距离
function BattleRole:checkRoleAttackRange( attacker, byAttacker )
    local range = attacker._range
    local space = math.abs(attacker._coord_y - byAttacker._coord_y)
    local flag = 1
    if byAttacker._camp == 0 then
        flag = -1
    end
    if range < space then
        return false, attacker._coord_y + (space - range) * flag
    else
        return true, 0
    end
end

-- 重置切场指定地点
function BattleRole:resetMoveToNextFight()
    self._run_state = self._enum_run_state._wait
    self._move_state = self._enum_move_state._join
    self._move_pos = cc.p(self:getPosition())
    local pos = cc.p(self._start_pos.x + fwin._width - app.baseOffsetX - 100, self._start_pos.y)

    -- 改成斜45度度的地图，重新定义坐标
    pos.x = self._reset_position.x
    pos.y = self._reset_position.y

    self:stopAllActions()
    local t = self:resetMoveTo(pos)
    -- self._end_pos.x = self._end_pos.x + (pos.x - self._start_pos.x)
    -- self._end_pos.y = self._end_pos.y + (pos.y - self._start_pos.y)
    -- self._start_pos.x = pos.x
    -- self._start_pos.y = pos.y
    -- self._attacking = false
    -- self._byAttackTarget = nil
    -- self._byLockAttackTarget = nil
    self:clearPath()

    self._change_dir = false
    self._moving = false
    self._start_attack = false
    self._unlock_attack = false
    self._attacking = false
    self._by_lock = false
    self._attack_coord_y = self._last_attack_coord_y
    self._attack_coord_x = self._last_attack_coord_x
    self._pos_h = nil
    self._pos_v = nil
    self._byAttackTarget = nil
    self._byLockAttackTarget = nil

    if nil ~= self._resetAttackTargetPosition then
        self:setPosition(self._resetAttackTargetPosition)
        self._resetAttackTargetPosition = nil
    end

    self._attack_wait_cd = 0
    self._sleep_cd = 0

    self._attack_count = 1

    if self._hero_type == self._enum_hero_type._hero then
        for i, v in pairs(self._team) do
            v._moving = false
            v._change_dir = false
            v._start_attack = false
            v._move_state = v._enum_move_state._moving
            v._run_state = v._enum_run_state._run
        end
        self:changeToAttackCoord(self._last_coord_y, self._last_coord_x)
        if self._camp == 0 then
            self._is_skill = self._is_auto
            -- state_machine.excute("battle_ui_update_player_reset", 0, 0)
            state_machine.excute("battle_ui_update_role_reset", 0, {role = self, shipId = self._shipMouldId, hp = self._hp, maxHp = self._max_hp, sp = decryptInfo(self._sp), maxSp = decryptInfo(self._max_sp), showSpEffect = true})
        end
    end
    return t
end

-- 重置切场移动到指定地点
function BattleRole:resetMoveTo(vector)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = (s / self._velocity * 0.013) * __fight_recorder_action_time_speed

    self:runAction(cc.Sequence:create({cc.MoveTo:create(t, vector),
            cc.CallFunc:create(function(sender)
                    local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                    actionIndex = actionIndex * _spine_sprite_animation_team_count
                    csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                    sender._sprite._nextAction = actionIndex
                end)
        }))
    return t
end

-- 移动到指定地点
function BattleRole:moveToNextFight()
    self._move_pos = cc.p(self:getPosition())
    local pos = cc.p(self._start_pos.x + fwin._width - app.baseOffsetX, self._start_pos.y)
    
    -- 改成斜45度度的地图，重新定义坐标
    pos.x = self._end_pos.x
    pos.y = self._end_pos.y

    local t = self:moveToNext(pos)
    -- 改成斜45度度的地图，重新定义坐标
    -- self._end_pos.x = self._end_pos.x + fwin._width - app.baseOffsetX
    -- self._end_pos.y = self._end_pos.y
    -- self._start_pos.x = pos.x
    -- self._start_pos.y = pos.y
    -- -- self._attacking = false
    -- -- self._byAttackTarget = nil
    -- -- self._byLockAttackTarget = nil
    self:clearPath()
    return t
end

-- 移动到指定地点
function BattleRole:moveToNext(vector)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = (s / self._velocity * 0.013) * __fight_recorder_action_time_speed

    self:runAction(cc.Sequence:create({cc.MoveTo:create(t, vector),
            cc.CallFunc:create(function(sender)
                    sender._attacking = false
                    sender._byAttackTarget = nil
                    sender._byLockAttackTarget = nil
                    -- sender._move_state = sender._enum_move_state._moving
                    -- sender._run_state = sender._enum_run_state._run
                    -- sender:onUpdate(0)

                    -- 改成斜45度度的地图，重新定义坐标
                    -- sender:moveToFightArena(sender._start_pos, sender._end_pos)

                    sender._run_state = sender._enum_run_state._wait
                    sender._move_state = sender._enum_move_state._join
                    sender:setPosition(sender._start_pos)
                    sender._move_pos = cc.p(sender:getPosition())

                    if sender._hero_type == sender._enum_hero_type._hero then
                        sender._follow = true
                        -- for i, v in pairs(sender._team) do
                        --     v:setPosition(cc.p(v._start_pos))
                        --     v._move_pos = cc.p(v:getPosition())
                        -- end
                    end
                    sender:executeSkills(battle_enum._skill_influence_trigger._fight_start)
                    sender:moveToFightArena(sender._start_pos, sender._attack_position, false)
                end)
        }))
    
    -- self._run_state = self._enum_run_state._wait
    -- local t = self:moveToFightArena(self._start_pos, vector)
    return t
end

-- 移动到指定地点
function BattleRole:moveTo(vector)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013

    self:runAction(cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector))
    return t
end

function BattleRole:moveToEx(vector)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013

    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector), cc.CallFunc:create(function(sender)
            local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
            actionIndex = actionIndex * _spine_sprite_animation_team_count
            sender._sprite._nextAction = actionIndex
            sender._change_dir = false
            sender._moving = false
        end)
    }))
    return t
end


function BattleRole:followMoveToEx(move_pos, vector, speed)
    -- self._move_pos = cc.p(self:getPosition())
    local mp = cc.p((vector.x - move_pos.x), (vector.y - move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.015 * speed
    return cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector)
end

-- 小兵跟随
function BattleRole:teamFollow(coord_y, coord_x)
    -- local pos = ___role_coords[coord_y][coord_x]
    -- local flag = -1
    -- if self._camp == 0 then
    --     flag = 1
    -- end
    -- cc.CallFunc:create(function(sender)end)
    -- for i, v in pairs(self._team) do
    --     local index = v._team_index
    --     local offsetX = battle_enum._follow_move_pos_fix[v._hero._move_dir][index].x
    --     local offsetY = battle_enum._follow_move_pos_fix[v._hero._move_dir][index].y
    --     v._change_dir = true
    --     -- v:moveToEx(cc.p(pos.x + flag * battle_enum._init_pos_fix[i].x, pos.y + flag * battle_enum._init_pos_fix[i].y))
    --     v._target_pos = cc.p(pos.x + offsetX, pos.y + offsetY)
    --     v:moveToEx(v._target_pos)
    -- end
end

function BattleRole:teamFollowEX()
    for i, v in pairs(self._team) do
        local index = v._team_index
        local actions = {}
        local current_pos = cc.p(v:getPosition())
        for m, n in pairs(self._follow_path) do
            local moveInfo = n
            local offsetX = battle_enum._follow_move_pos_fix[moveInfo.move_dir][index].x
            local offsetY = battle_enum._follow_move_pos_fix[moveInfo.move_dir][index].y
            local pos = ___role_coords[moveInfo.coord_y][moveInfo.coord_x]
            v._target_pos = cc.p(pos.x + offsetX, pos.y + offsetY)
            local action = v:followMoveToEx(current_pos, v._target_pos, moveInfo.speed)
            current_pos.x = v._target_pos.x
            current_pos.y = v._target_pos.y
            v._move_dir = moveInfo.move_dir
            table.insert(actions, action)
        end
        table.insert(actions, cc.CallFunc:create(function(sender)
            if sender._move_dir ~= sender._hero._move_dir then
                local moveInfo = {}
                moveInfo.coord_y = sender._hero._coord_y
                moveInfo.coord_x = sender._hero._coord_x
                moveInfo.move_dir = sender._hero._move_dir
                moveInfo.speed = 0.85
                table.insert(sender._hero._follow_path, moveInfo)
                sender._hero:teamFollowCell()
            else
                if sender._death == false then
                    local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                    actionIndex = actionIndex * _spine_sprite_animation_team_count
                    csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                    sender._sprite._nextAction = actionIndex
                end
                sender._change_dir = false
                sender._moving = false

                if sender._start_attack == true 
                    and sender._death == false
                    then
                    sender._start_attack = false
                    if sender._byAttackTarget ~= nil 
                        and sender._byAttackTarget._death == false
                        then
                        sender:attackTarget(sender._byAttackTarget)
                    end
                end
            end
        end))
        v._change_dir = true
        v._moving = true
        v._start_attack = false
        v:stopAllActions()
        v:runAction(cc.Sequence:create(actions))
    end
    self._follow_path = {}
end


function BattleRole:teamFollowCell()
    for i, v in pairs(self._team) do
        if v._death == false then
            local index = v._team_index
            local actions = {}
            local current_pos = cc.p(v:getPosition())
            for m, n in pairs(self._follow_path) do
                local moveInfo = n
                local offsetX = battle_enum._follow_move_pos_fix[moveInfo.move_dir][index].x
                local offsetY = battle_enum._follow_move_pos_fix[moveInfo.move_dir][index].y
                local pos = ___role_coords[moveInfo.coord_y][moveInfo.coord_x]
                v._target_pos = cc.p(pos.x + offsetX, pos.y + offsetY)
                v:move(current_pos, v._target_pos)
                local action = v:followMoveToEx(current_pos, v._target_pos, moveInfo.speed)
                current_pos.x = v._target_pos.x
                current_pos.y = v._target_pos.y
                table.insert(actions, action)
            end
            table.insert(actions, cc.CallFunc:create(function(sender)
                sender._moving = false
                sender._change_dir = false
                sender._move_pos = cc.p(sender:getPosition())
                if sender._death == false and sender._start_attack == true then
                    if sender._start_attack == true then
                        sender._start_attack = false
                        if sender._byAttackTarget ~= nil 
                            and sender._byAttackTarget._death == false
                            then
                            sender:attackTarget(sender._byAttackTarget)
                        else
                            sender._byAttackTarget = nil
                            sender._byLockAttackTarget = nil
                            sender:move(sender._move_pos, sender._hero._end_pos)
                            local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                            actionIndex = actionIndex * _spine_sprite_animation_team_count
                            csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                            sender._sprite._nextAction = actionIndex
                        end
                    else
                        sender:move(sender._move_pos, sender._hero._end_pos)
                        local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                        actionIndex = actionIndex * _spine_sprite_animation_team_count
                        csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                        sender._sprite._nextAction = actionIndex
                    end
                else
                    sender:move(sender._move_pos, sender._hero._end_pos)
                    local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                    actionIndex = actionIndex * _spine_sprite_animation_team_count
                    csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                    sender._sprite._nextAction = actionIndex
                end
            end))

            v._change_dir = false
            v._moving = true
            v:stopAllActions()
            v:runAction(cc.Sequence:create(actions))
        end
    end
    self._follow_path = {}
end

-- 切换坐标点
function BattleRole:changeToAttackCoord(coord_y, coord_x)
    if ___role_coords_status[self._coord_y][self._coord_x] == self then
        ___role_coords_status[self._coord_y][self._coord_x] = nil
    end
    self._coord_y = coord_y
    self._coord_x = coord_x
    if ___role_coords_status[self._coord_y][self._coord_x] == nil then
        ___role_coords_status[self._coord_y][self._coord_x] = self
    end
end

-- 移动到攻击线
function BattleRole:moveToAttackLine(vector)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013
    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector), cc.CallFunc:create(function(sender)
        -- print("移动结束:", sender._shipName, sender._sprite_id)
        if sender._move_state == sender._enum_move_state._join then
            local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
            actionIndex = actionIndex * _spine_sprite_animation_team_count
            csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
            sender._sprite._nextAction = actionIndex
        else
            if state_machine.excute("battle_scene_start_attack", 0, {sender, false}) == true then
                -->>print("可以进行攻击了。", sender._shipName, self._sprite_id)
                sender._unlock_attack = true
                sender._run_state = sender._enum_run_state._run
                -- sender._run_state = sender._enum_run_state._wait
                sender._move_state = sender._enum_move_state._moving
            else
                local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                actionIndex = actionIndex * _spine_sprite_animation_team_count
                csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                sender._sprite._nextAction = actionIndex
            end
        end
    end)}))
    return t
end

-- 入场移动到攻击线
function BattleRole:fristMoveToAttackLine()
    if self._fristEnterMoveX == 0 and self._fristEnterMoveY == 0 then
        self._frsitMoveEnd = true
        -- state_machine.excute("battle_scene_all_move_fight_arena_over", 0, nil)
        return
    end
    local vector = nil
    local lineCount = 0
    if self._fristEnterMoveY ~= 0 then
        vector = ___role_coords[self._fristEnterMoveY][self._last_coord_x]
        lineCount = math.abs(self._fristEnterMoveY - self._coord_y)
        table.insert(self._follow_path, {coord_y = self._fristEnterMoveY, coord_x = self._coord_x, move_dir = self._move_dir, speed = 1})
        self._fristEnterMoveY = 0
    else
        vector = ___role_coords[self._coord_y][self._fristEnterMoveX]
        lineCount = math.abs(self._fristEnterMoveX - self._coord_x)/0.8
        table.insert(self._follow_path, {coord_y = self._coord_y, coord_x = self._coord_x, move_dir = self._move_dir, speed = 1})
        -- print("转向移动前：", self._shipName, self._move_dir)
        self:move(self._move_pos, vector)
        -- print("转向移动后：", self._shipName, self._move_dir)
        table.insert(self._follow_path, {coord_y = self._coord_y, coord_x = self._fristEnterMoveX, move_dir = self._move_dir, speed = 1})
        self._fristEnterMoveX = 0
    end
    self._move_pos = cc.p(self:getPosition())
    if self._move_pos.x == vector.x and self._move_pos.y == vector.y then
        local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count)
        actionIndex = actionIndex * _spine_sprite_animation_team_count
        csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
        self._sprite._nextAction = actionIndex
        for i, v in pairs(self._team) do
            if v._death == false then
                local actionIndex = math.modf(v._sprite._actionIndex / _spine_sprite_animation_team_count)
                actionIndex = actionIndex * _spine_sprite_animation_team_count
                csb.animationChangeToAction(v._sprite, actionIndex, actionIndex, false)
                v._sprite._nextAction = actionIndex
            end
        end
        self._frsitMoveEnd = true
        state_machine.excute("battle_scene_all_move_fight_arena_over", 0, nil)
    else
        self:move(self._move_pos, vector)
        self:teamFollowEX()
    end

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013
    if lineCount == 0 then
        lineCount = 2
    end
    t = lineCount * 0.4

    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector), cc.CallFunc:create(function(sender)
        if sender._fristEnterMoveX ~= 0 then
            if sender._camp == 0 then 
                sender:fristMoveToAttackLine()
            else
                local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
                actionIndex = actionIndex * _spine_sprite_animation_team_count
                csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
                sender._sprite._nextAction = actionIndex
                for i, v in pairs(self._team) do
                    if v._death == false then
                        local actionIndex = math.modf(v._sprite._actionIndex / _spine_sprite_animation_team_count)
                        actionIndex = actionIndex * _spine_sprite_animation_team_count
                        csb.animationChangeToAction(v._sprite, actionIndex, actionIndex, false)
                        v._sprite._nextAction = actionIndex
                    end
                end
                -- sender._frsitMoveEnd = true
            end
        elseif sender._move_state == sender._enum_move_state._join then
            local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
            actionIndex = actionIndex * _spine_sprite_animation_team_count
            csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
            sender._sprite._nextAction = actionIndex
            for i, v in pairs(self._team) do
                if v._death == false then
                    local actionIndex = math.modf(v._sprite._actionIndex / _spine_sprite_animation_team_count)
                    actionIndex = actionIndex * _spine_sprite_animation_team_count
                    csb.animationChangeToAction(v._sprite, actionIndex, actionIndex, false)
                    v._sprite._nextAction = actionIndex
                end
            end
            sender._frsitMoveEnd = true
            if sender._camp == 0 
                and sender._formation_row == 1 
                then
                state_machine.excute("battle_scene_attack_move_fight_arena_over", 0, nil)
            end
        end
        state_machine.excute("battle_scene_all_move_fight_arena_over", 0, nil)
    end)}))
    return t
end

-- 移动到下一个攻击阵列位置
function BattleRole:moveToAttackNextLine(vector)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013

    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed + 0.000001, vector), cc.CallFunc:create(function(sender)
        if sender._pos_v ~= nil then
            sender:moveToAttackNextLine(sender._pos_v)
            sender._pos_v = nil
            if sender._follow == true then
                sender:teamFollow(sender._coord_y, sender._coord_x)
            end
            return
        end
        local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
        actionIndex = actionIndex * _spine_sprite_animation_team_count
        csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
        sender._sprite._nextAction = actionIndex
        self._moving = false
        sender._pos_v = nil
        sender._pos_h = nil
    end)}))
    return t
end

-- 移动到指定地点
function BattleRole:moveToByAttackTarget(vector, lineCount)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)
    -- print("移动到指定地点", self._shipName, self._move_pos.x, self._move_pos.y, vector.x, vector.y, lineCount)
    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = 0
    if lineCount ~= nil then
        if lineCount == 0 then
            lineCount = 1
        end
        t = lineCount * 0.4
    else
        t = s / self._velocity * 0.013
    end
    self.lineCount = lineCount
    if self._move_pos.x == vector.x and self._move_pos.y == vector.y then
        self:move(self._move_pos, self._end_pos)
        -- print("停止移动。....", self._shipName, self._coord_x, self._coord_y, self._byLockAttackTarget)
        self._moving = false
        self._by_lock = false
        self._pos_v = nil
        self.lineCount = nil
        self._pos_h = nil
        if self._byLockAttackTarget ~= nil 
            -- and sender._byLockAttackTarget._death == false
            then
            if self._byLockAttackTarget._death == true then
                self._start_attack = false
            end
            self._byLockAttackTarget._by_lock = false
            -- sender._start_attack = true
            -- if sender._range <= 100 then
                -- sender._follow = false
            -- end
        else
            self._start_attack = false
        end
        return
    end
    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed + 0.000001, vector), cc.CallFunc:create(function(sender)
        if sender._pos_v ~= nil then
            if sender._byLockAttackTarget ~= nil 
                and sender._byLockAttackTarget._death == false
                then
                sender:moveToByAttackTarget(sender._pos_v, nil)
                sender._pos_v = nil
                sender.lineCount = nil
                if sender._follow == true then
                    sender:teamFollow(sender._coord_y, sender._coord_x)
                end
                return
            end
        end
        sender:move(sender._move_pos, sender._end_pos)
        -- print("停止移动。", sender._shipName, sender._coord_x, sender._coord_y)
        sender._moving = false
        sender._by_lock = false
        sender._pos_v = nil
        sender.lineCount = nil
        sender._pos_h = nil
        if sender._byLockAttackTarget ~= nil 
            -- and sender._byLockAttackTarget._death == false
            then
            if sender._byLockAttackTarget._death == true then
                sender._start_attack = false
            end
            sender._byLockAttackTarget._by_lock = false
            -- sender._start_attack = true
            -- if sender._range <= 100 then
                -- sender._follow = false
            -- end
        else
            sender._start_attack = false
        end

        -- if sender._pos_v ~= nil then
        --     sender._move_pos = cc.p(sender:getPosition())
        --     if sender._byLockAttackTarget ~= nil then
        --         sender:moveToByAttackTarget(sender._pos_v)
        --     else
        --         -- sender._pos_h = nil
        --         -- sender._pos_v = nil
        --         -- sender._moving = false
        --     end
        --     sender._pos_v = nil
        -- else
        --     -- sender._pos_h = nil
        --     -- sender._pos_v = nil
        --     -- sender._moving = false
        --     -- -- sender._by_lock = false
        --     -- if sender._byLockAttackTarget ~= nil then
        --     --     -- sender._byLockAttackTarget._moving = false
        --     --     sender._byLockAttackTarget._by_lock = false
        --     -- end
        -- end
    end)}))
    return t
end

-- 移动
function BattleRole:move(move_pos, vector)
    local at = CC_POSITIONS_TO_DEGREES(move_pos, vector)
    if at < 0 then
        at = at - 7.5
    else
        at = at + 7.5
    end
    -- self:runAction(cc.RotateTo:create(3.5, at))
    -- local actionIndex = math.modf(at / (360.0 / 25.0))
    local actionIndex = math.modf(at / (360.0 / 24.0))
    if actionIndex < 1 then
        actionIndex = 12 + actionIndex + 12
    end
    -- self._targetIndex = actionIndex + 1
    self._targetIndex = actionIndex

    -- if self._hero == nil then
    --     print(self._targetIndex, move_pos.x, move_pos.y, vector.x, vector.y, at, actionIndex)
    -- end

    self._last_angle = self._angle
    self._angle = at

    if self._hero_type == self._enum_hero_type._hero then
        if actionIndex >=0 and actionIndex < 7 then
            self._move_dir = 1
        elseif actionIndex >=7 and actionIndex < 14 then
            self._move_dir = 2
        elseif actionIndex >=14 and actionIndex < 21 then
            self._move_dir = 3
        elseif actionIndex >=21 and actionIndex < 27 then
            self._move_dir = 4
        end
    end

    if self._vrevolve <= 0 then
        self._targetIndex = self._targetIndex % 24
        local actionIndex = self._targetIndex * _spine_sprite_animation_team_count + 1
        -- self._targetIndex = -1
        if self._hero_type == self._enum_hero_type._hero then
        else
            if self._camp == 0 then
                if actionIndex == 1 then
                    actionIndex = 21
                end
            else
                if actionIndex == 1 then
                    actionIndex = 112
                end
            end
        end

        if actionIndex ~= self._sprite._actionIndex 
            or self._sprite._nextAction ~= actionIndex
            -- and _spine_sprite_animation_names[actionIndex + 1] ~= _spine_sprite_animation_names[self._sprite._actionIndex + 1]
            then
            -- if math.abs(self._angle - self._last_angle) >= 45 then
            --     -- self:stopAllActions()
            --     self._sprite:runAction(cc.Sequence:create({cc.RotateTo:create(50 / 60 * __fight_recorder_action_time_speed, self._angle),
            --         cc.CallFunc:create(function(sender)
            --                 sender:setRotation(0)
            --                 csb.animationChangeToAction(sender, sender._nextAction, sender._nextAction, false)
            --             end)
            --     }))
            -- else
            --     csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
            --     self._sprite._nextAction = actionIndex
            -- end
            csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
        end
        self._sprite._nextAction = actionIndex
    end
end

-- 目标技能时间锁定
function BattleRole:onPause(params)
    if params ~= nil and params.mustPause == true then
        self._sprite:pause()
        if self._sprite_src ~= nil then
            self._sprite_src:pause()
        end
        self:pause()
        self._attack_pause = true
    elseif self._battle_type == 1 then
        if (self._lock_screen == false
            -- and self._is_skill == false
            -- and self._attack_type == 0
            and self._death == false)
            or params.forcing == true
            then
            self._sprite:pause()
            if self._sprite_src ~= nil then
                self._sprite_src:pause()
            end
            self:pause()
            self._attack_pause = true
        end
    else
        if ((self._lock_screen == false or self._camp == 1)
            and (self._is_skill == false or self._camp == 1)
            and (self._attack_type == 0 or self._camp == 1)
            and self._death == false)
            or params.forcing == true
            then
            self._sprite:pause()
            if self._sprite_src ~= nil then
                self._sprite_src:pause()
            end
            self:pause()
            self._attack_pause = true
        end
    end
end

-- 目标技能时间解锁
function BattleRole:onResume(params)
    -- if self._lock_screen == true then
    self._sprite:resume()
    if self._sprite_src ~= nil then
            self._sprite_src:resume()
        end
    self:resume()
    self._attack_pause = false
    -- end
end

function BattleRole:getAnimationDuration(armature, actionIndex)
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

-- 移动到指定地点
function BattleRole:backToAttackPosition(vector)
    self._move_pos = cc.p(self:getPosition())
    self:move(self._move_pos, vector)

    local mp = cc.p((vector.x - self._move_pos.x), (vector.y - self._move_pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013 / 3

    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, vector), cc.CallFunc:create(function(sender)
        sender:move(sender._move_pos, sender._end_pos)
        local actionIndex = math.modf(sender._sprite._actionIndex / _spine_sprite_animation_team_count)
        actionIndex = actionIndex * _spine_sprite_animation_team_count
        csb.animationChangeToAction(sender._sprite, actionIndex, actionIndex, false)
        sender._sprite._nextAction = actionIndex
        sender._sprite._actionIndex = actionIndex
        sender._resetAttackTargetPosition = nil
    end)}))
    return t
end

-- 角色攻击等待CD
function BattleRole:onSleep(isTime)
    if self._sleep_cd > 0 then
        if isTime then
            return
        end
    else
        if isTime then
            local gongsu = dms.float(dms["fight_config"], battle_enum._fight_config_num.gongsu_A, fight_config.attribute)
            local duration = gongsu / battle_logic.attackSpeed(self._heroBattleObject)-- self._heroBattleObject.attackSpeed

            local interval = 0--self:getAnimationDuration(self._sprite, self._sprite._actionIndex)
            if self._hero_type ~= self._enum_hero_type._master then
                self._run_state = self._enum_run_state._sleep
            end
            self._sleep_cd = duration - interval
            return
        end
        -- self._last_sleep_cd = self._sleep_cd
    end
    self._byAttackTarget = nil

    local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count)
    self._sprite._nextAction = actionIndex * _spine_sprite_animation_team_count
    -- actionIndex = actionIndex * _spine_sprite_animation_team_count
    -- csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)
    self._attacking = false
    self:clearPath()
    self:stopAllActions()

    if self._attack_type == 1 then
        self._byLockAttackTarget = nil
    end

    if self._attack_pause == true then
        self:onPause({})
    end

    if self.camera_focus == true then
        self.camera_focus = false
        state_machine.excute("battle_map_scene_scale_effect", 0, {0, 0, false, false, self})
    end

    if nil ~= self._resetAttackTargetPosition then
        -- self:setPosition(self._resetAttackTargetPosition)
        -- self._resetAttackTargetPosition = nil
        self:backToAttackPosition(self._resetAttackTargetPosition)
    end
end

function BattleRole:changeActionToIDLE()
    self:onSleep()
    local actionIndex = math.modf(self._sprite._actionIndex / _spine_sprite_animation_team_count) * _spine_sprite_animation_team_count
    csb.animationChangeToAction(self._sprite, actionIndex, actionIndex, false)

    self:setStopAttackCount(1)

    if self:getChildByTag(300000) ~= nil and self._use_god_skill == true then
        self:removeChildByTag(300000)
    end

    self._byAttackTarget = nil
    self._attacking = false
    self._byLockAttackTarget = nil
end

function BattleRole:setStopAttackCount(count)
    self._stop_attack_count = self._stop_attack_count + count
    if self._stop_attack_count < 0 then
        self._stop_attack_count = 0
    end
end

function BattleRole:lockRole()
    
end

function BattleRole:close()

end

function BattleRole:destroy()

end


-- ----------------------------------------------------------------------------------------------------