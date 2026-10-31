-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗子弹
-- ----------------------------------------------------------------------------------------------------
BattleBullet = class("BattleBulletClass", Window)

local battle_bullet_create_terminal = {
    _name = "battle_bullet_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return BattleBullet:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_bullet_delete_terminal = {
    _name = "battle_bullet_delete",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battleBullet = params
        for i, v in pairs(_battleBullet._streaks) do
            v:removeFromParent(true)
        end
        _battleBullet._streaks = {nil}
        _battleBullet:removeFromParent(true)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_bullet_create_terminal)
state_machine.add(battle_bullet_delete_terminal)
state_machine.init()

function BattleBullet:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    -- var
    self._elapsed = 0
    self._duration = 3
    self._position = nil
    self._size = nil
    self._rect = nil

    self._streaks = {} -- 拖尾

    self._lasers = nil -- 激光：
    self._current_laser = nil

    self._bullet_type = 0
    self._enum_bullet_type = {
        _spine = 0,
        _laser = 1,
        _crossbow = 2,
        _parabola = 3,
        _laser2 = 4,
        _lightning = 20,
    }

    self._parent = nil

    self._bullets_container = nil

    self._skeletonNode = nil

    self._attacker = nil
    self._target = nil
    self._target_camp = nil
    self._targets = nil
    self._sprite_id = -1
    self._effect_id = -1
    self._angle = 0
    self._velocity = 4
    self._accel = 10
    self._vector = nil -- cc.p(500, 500)
    self._turnRate = 150
	self._armature = 0
    self._attack_type = 0
    self._current_skill = nil
    self._draw_position = nil -- cc.p(0, 0)
    self._base_offset_y = 0
    self._use_god_skill = false

    self.needCheckRange = false

    self._send = false
	
end

function BattleBullet:init(params)
	local bulletType = params[1]
    local parent = params[2]
    local position = params[3]
    local index = params[4]
    local attaker = params[5]
    local target = params[6]
    local angle = params[7]
    local vector = params[8]
    local effect = params[9]
    local floor_effect = params[10]
    local armature = params[11]
    local attackType = params[12]
    local currentSkill = params[13]
    local targetCamp = params[14]
    local drawPosition = params[15]
    local targets = params[16]
    local needCheckRange = params[17]
    local speed = params[18]
    local base_offset_y = params[19]
    self._use_god_skill = params[20]

    self._send = params._send

    if vector ~= nil then
        vector.y = vector.y + 40
    end

    self._effect_id = effect
    self._floor_effect_id = floor_effect
    self._fly_effect_id = currentSkill.fly_effect

    self._bullet_type = bulletType

    self._sprite_id = index
    self._angle = angle

    -- 设置子弹发射位置的偏移
	position.y = position.y-- + 25
    self._position = position
    self._size = parent:getContentSize()

    self._parent = parent
    self._attacker = attaker
	self._target = target
	self._vector = vector
	self._armature = armature
    self._attack_type = attackType
    self._current_skill = currentSkill
    self._target_camp = targetCamp
    self._draw_position = drawPosition
    self._targets = targets
    self.needCheckRange = needCheckRange
    self._base_offset_y = base_offset_y
    if self._bullet_type == self._enum_bullet_type._crossbow then
        self._velocity = speed
    end

    if currentSkill.effect_draw_type == 0 then
        self._angle = 0
    end

    -- 子弹类型
    -- 0：一般子弹
    -- 1：连锁子弹
    -- 2：弩车子弹
    -- 3：抛物线子弹
    -- 4：闪电连子弹
    -- skill_influence的第16个字段

    if self._bullet_type == self._enum_bullet_type._spine then
        self._accel = self._accel * 2.3
        self:createBulletForSpine()
    elseif self._bullet_type == self._enum_bullet_type._laser then
        self:createBulletForLaser()
    elseif self._bullet_type == self._enum_bullet_type._crossbow then
        self:createBulletForCrossbow()
    elseif self._bullet_type == self._enum_bullet_type._parabola then
        self:createBulletForSpineParabola()
    -- elseif self._bullet_type == self._enum_bullet_type._laser2 then
    --     self:createBulletForLaser()
    elseif self._bullet_type == self._enum_bullet_type._lightning 
        or self._bullet_type == self._enum_bullet_type._laser2 
        then
        self:createBulletForLightningBolt()
    end

    state_machine.excute("battle_scene_add_bullet", 0, self)
	return self
end

function BattleBullet:setTarget(target)
	self._target = target
end

function BattleBullet:execute()
    self._elapsed = self._duration

    if self._send == true then
        -- 只发射子弹，不需要伤害计算
        return
    end

    if zstring.tonumber(self._sprite_id) > 0 then
        state_machine.excute("battle_role_state_change", 0, self._attacker)
    end

    -- 0基于施放者与承受者的路径（根据目标数量绘制光效）
    -- 1基于施放者位置（只绘制一个光效）
    -- 2基于承受者位置（根据目标数量绘制光效）
    -- 3基于对方阵营中心（只绘制一个光效）
    -- 4基于攻击范围无视存活数量（根据目标数量绘制光效）
    -- 5基于攻击范围逐格播放（根据目标数量绘制光效）（伤害逐格显示）
    -- 6基于施放者直线路径至屏幕外（只绘制一个光效）（攻击直线复数目标，伤害逐格显示）
    -- 7基于承受者绘制多个光效，角度偏移
    -- 8基于技能释放中心点
    local lighting_effect_draw_method = self._current_skill.lighting_effect_draw_method
    -- print("lighting_effect_draw_method:", lighting_effect_draw_method)
    -- lighting_effect_draw_method = 3
    local drawTargets = {}
    local range = self._current_skill.attack_scope_xy -- self._attacker._range
    local targets = {nil}
    local pos = self._draw_position
    -- 近战普攻
    if self._attack_type == 0 and self._use_god_skill ~= true then
        targets = {self._target}
    else
        targets = self._targets
        if targets == nil or table.nums(targets) == 0 or self.needCheckRange == true then
            if self._target ~= nil then
                pos = cc.p(self._target:getPosition())
                pos.x = self._target._coord_x
                pos.y = self._target._coord_y
            end
            if targets ~= nil and table.nums(targets) == 1 and self.needCheckRange == true then
                pos = cc.p(targets[1]:getPosition())
                pos.x = targets[1]._coord_x
                pos.y = targets[1]._coord_y
            end
            if tonumber(self._current_skill.influence_group) == 1 
                and tonumber(self._current_skill.influence_range) == 1 then
                pos.x = self._target._coord_x
                pos.y = self._target._coord_y
                if self._target._camp == 0 then
                    self._target_camp = 1
                else
                    self._target_camp = 0
                end
            end
            -- targets = state_machine.excute("battle_scene_range_attack_role", 0, {cc.p(self._target:getPosition()) ,self._target._camp , range , 0})--0.圆形
            -- targets = state_machine.excute("battle_scene_range_attack_role", 0, {cc.p(self._target:getPosition()) ,self._target._camp , range , 1})--1.矩形
            if pos ~= nil and range ~= nil then
                targets = state_machine.excute("battle_scene_range_attack_role", 0, {pos, self._target_camp , range , 2})--1.矩形2
                if targets == nil or #targets == 0 then
                    targets = {self._target}
                end
            end
        end
    end

    for i, v in pairs(targets) do
        if self._effect_id > 0 or self._floor_effect_id > 0 or self._fly_effect_id > 0 then
        else
            if self._current_skill.bear_lighting_effect_id > 0 then
                state_machine.excute("battle_effect_create", 0, {
                        0, -- self._attack_type, 
                        self._parent, 
                        cc.p(v:getPosition()), -- cc.p(self._target:getPosition()), 
                        self._current_skill.bear_lighting_effect_id, -- self._effect_id, 
                        self._attacker, 
                        v, -- self._target, 
                        self._angle, 
                        self._vector, 
                        self._floor_effect_id,
                        self._fly_effect_id,
                        self._current_skill,
                        self._attack_type,
                        nil,
                        false})
            else
                state_machine.excute("battle_role_hit", 0, {self._attacker, self, v})
            end
        end
        if (lighting_effect_draw_method == 0
                or lighting_effect_draw_method == 2
                or lighting_effect_draw_method == 4
                or lighting_effect_draw_method == 5
                or lighting_effect_draw_method == 7)
            then
            table.insert(drawTargets, v)
        end
    end

    --  -1代表不生成特效
    if self._effect_id > 0 or self._floor_effect_id > 0 or self._fly_effect_id > 0 then
        if #drawTargets > 0 then
            for i, v in pairs(drawTargets) do
                state_machine.excute("battle_effect_create", 0, {
                    self._attack_type, 
                    self._parent, 
                    cc.p(v:getPosition()), -- cc.p(self._target:getPosition()), 
                    self._effect_id, 
                    self._attacker, 
                    v, -- self._target, 
                    self._angle, 
                    self._vector, 
                    self._floor_effect_id,
                    self._fly_effect_id,
                    self._current_skill,
                    self._attack_type,
                    nil,
                    true})
            end
        else
            if self._target ~= nil then
                if lighting_effect_draw_method == 1 then
                    state_machine.excute("battle_effect_create", 0, {
                            self._attack_type, 
                            self._parent, 
                            cc.p(self._attacker:getPosition()), 
                            self._effect_id, 
                            self._attacker, 
                            self._target, 
                            self._angle, 
                            self._vector, 
                            self._floor_effect_id,
                            self._fly_effect_id,
                            self._current_skill,
                            self._attack_type,
                            targets,
                            true})
                elseif lighting_effect_draw_method == 3 then
                    local pos = state_machine.excute("battle_scene_get_camp_center_position", 0, {self._target_camp})
                    state_machine.excute("battle_effect_create", 0, {
                            self._attack_type, 
                            self._parent, 
                            pos, 
                            self._effect_id, 
                            self._attacker, 
                            self._target, 
                            self._angle, 
                            self._vector, 
                            self._floor_effect_id,
                            self._fly_effect_id,
                            self._current_skill,
                            self._attack_type,
                            targets,
                            true})
                elseif lighting_effect_draw_method == 8 then
                    local pos = state_machine.excute("battle_scene_get_camp_center_position", 0, {self._target_camp, self._targets})
                    -- pos.x = self._parent:getParent():getContentSize().width/2 -- self._parent:getPositionX()
                    -- pos.y = self._parent:getParent():getContentSize().height/2 -- self._parent:getPositionY()
                    state_machine.excute("battle_effect_create", 0, {
                            self._attack_type, 
                            self._parent, 
                            pos, 
                            self._effect_id, 
                            self._attacker, 
                            self._target, 
                            self._angle, 
                            self._vector, 
                            self._floor_effect_id,
                            self._fly_effect_id,
                            self._current_skill,
                            self._attack_type,
                            targets,
                            true})
                else
                    state_machine.excute("battle_effect_create", 0, {
                            self._attack_type, 
                            self._parent, 
                            cc.p(self._target:getPosition()), 
                            self._effect_id, 
                            self._attacker, 
                            self._target, 
                            self._angle, 
                            self._vector, 
                            self._floor_effect_id,
                            self._fly_effect_id,
                            self._current_skill,
                            self._attack_type,
                            targets,
                            true})
                end
            end
        end
    else
        if self._current_skill.posterior_lighting_sound_effect_id > 0 then
            playEffectMusic(self._current_skill.posterior_lighting_sound_effect_id)
        end
    end
end

function BattleBullet:createStreak()
    local streak = cc.MotionStreak:create(0.2, 5, 2, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), "effect/ms_0.png")
    -- streak:setAnchorPoint(cc.p(0.5, 1))
    streak:setPosition(self._position)
    self._parent:addChild(streak, _scene_zorder_bullet)
    table.insert(self._streaks, streak)
end

-- 
function BattleBullet:createBulletForSpine()
    -- 如果子弹的sprite_id 为0 或者-1 则没有子弹飞行效果，技能和近战普攻
    if self._sprite_id <= 0 then
        fwin:addService({
            callback = function ( params )
                params:execute()
            end,
            params = self
        })
    else
        local baseName = "effect/bullet_" .. self._sprite_id

        local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)

        skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)

        self:addChild(skeletonNode)
        -- skeletonNode:setDebugSlotsEnabled(true)

        self._skeletonNode = skeletonNode
    end

    self:setContentSize(cc.size(0, 0))
    self:setPosition(self._position)
    self._parent:addChild(self, _scene_zorder_bullet)

    if self._vector ~= nil then
        self._angle = CC_POSITIONS_TO_DEGREES(cc.p(self:getPosition()), self._vector)
    end

    if self._bullet_type == self._enum_bullet_type._crossbow then
        -- local pos_y = 31
        self._angle = battle_enum._battle_bullet_crossbow_angle[1]
        if self._attacker._camp == 1 then
            -- pos_y = 1
            self._angle = battle_enum._battle_bullet_crossbow_angle[2]
        end
        -- local endPos = ___role_coords[pos_y][self._attacker._coord_x]
        -- self._angle = CC_POSITIONS_TO_DEGREES(cc.p(self:getPosition()), endPos)
    end
    self:setRotation(self._angle)
    if true == self._current_skill.showStreak then
        self:createStreak()
    end
end

function BattleBullet:createBulletForLaserCell(src, dist)
    local laserNode = nil
    if self._bullet_type == self._enum_bullet_type._laser then
        laserNode = cc.EffectLaser:create(
                "effect/laser1/light2.png", -- lightTex
                "effect/laser1/mask.png", -- maskTex
                "effect/laser1/mask2.png", -- maskTex2
                "effect/laser1/noise.png", -- noiseTex
                "effect/laser1/noise2.png", -- noiseTex2
                "shaders/laser1.fsh" -- shaders
            )
    elseif self._bullet_type == self._enum_bullet_type._laser2 then
        laserNode = cc.EffectLaser:create(
                "effect/laser2/light2.png", -- lightTex
                "effect/laser2/mask.png", -- maskTex
                "effect/laser2/mask2.png", -- maskTex2
                "effect/laser2/noise.png", -- noiseTex
                "effect/laser2/noise2.png", -- noiseTex2
                "shaders/laser2.fsh" -- shaders
            )
    end

    laserNode._end_pos = cc.p(0, 0)

    self._position = cc.p(self:getPosition())
    laserNode:setPosition(self._position)
    laserNode:setStart(cc.p(0, 0))
    laserNode:setEnd(laserNode._end_pos)
    self._parent:addChild(laserNode, _scene_zorder_bullet)

    table.insert(self._lasers, laserNode)
    self._current_laser = laserNode

    local vector = cc.p(self._target:getPosition())
    local mp = cc.p((vector.x - self._position.x), (vector.y - self._position.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013 * 0.25
    self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, cc.p(dist:getPosition())), 
        cc.CallFunc:create(function(sender)
            local nIndex = #sender._lasers + 1
            local targets = sender._targets
            sender._targets = {sender._target}
            sender:execute()
            if nIndex <= #targets then
                sender._targets = targets
                sender._target = sender._targets[nIndex]
                sender:createBulletForLaserCell(sender._attacker, sender._target)
                sender._elapsed = 0
            else
                for i, v in pairs(sender._lasers) do
                    v:removeFromParent(true)
                end
                sender._current_laser = nil
            end
        end)}))

    -- ****************************
    -- local laserNode = cc.EffectLaser:create(
    --         "effect/laser/light2.png", -- lightTex
    --         "effect/laser/mask.png", -- maskTex
    --         "effect/laser/mask2.png", -- maskTex2
    --         "effect/laser/noise.png", -- noiseTex
    --         "effect/laser/noise2.png", -- noiseTex2
    --         "shaders/laser.fsh" -- shaders
    --     )

    -- laserNode:setStart(cc.p(0, 0))
    -- -- laserNode:setEnd(cc.pSub(cc.p(self._target:getPosition()), cc.p(self._attacker:getPosition())))
    -- laserNode:setEnd(cc.p(0, 0))
    -- self:addChild(laserNode)


    -- self:setContentSize(cc.size(0, 0))
    -- self:setPosition(self._position)
    -- self._parent:addChild(self, _scene_zorder_bullet)
end

-- 激光类型子弹
function BattleBullet:createBulletForLaser()
    if table.nums(self._targets) == 0 then
        self._duration = 0
        return
    end
    self._duration = 1000000.3
    self._lasers = {}
    self:setPosition(self._position)
    self._parent:addChild(self, _scene_zorder_bullet)
    for i, v in pairs(self._targets) do
        _, _, v._space = v:lockByAttack(self._attacker)
    end
    
    table.sort(self._targets, function (a, b)
        return a._space < b._space 
    end)

    for i, v in pairs(self._targets) do
        if v == self._attacker then
            table.remove(self._targets, i, 1)
            table.insert(self._targets, v)
            break
        end
    end
    self._target = self._targets[1]
    self:createBulletForLaserCell(self._attacker, self._target)

    -- -- 调用子弹 sprite_id对应配置
    -- local baseName = "effect/bullet_" .. self._sprite_id

    -- -- 拼接长度


    -- -- 动画调用
    -- local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    -- skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
    -- self:addChild(skeletonNode)

    -- -- 如果目标不为空
    -- if self._vector ~= nil then
    --     self._angle = CC_POSITIONS_TO_DEGREES(cc.p(self:getPosition()), self._vector)
    -- end

    -- self:setRotation(self._angle)
    -- self:setAnchorPoint(cc.p(0, 0.5))
end

function BattleBullet:moveOverFunc()
    self:execute()

    -- self._elapsed = self._duration
    -- state_machine.excute("battle_role_hit", 0, {self._attacker, self, self._target})

    -- --  -1代表不生成特效
    -- if self._target ~= nil and self._effect_id > 0 then
    --     local mPos = cc.p(self._target:getPosition())
    --     -- if self._target ~= nil 
    --     --     and self._target._hero_type ~= self._target._enum_hero_type._hero
    --     --     then
    --     --     mPos.y = mPos.y - 125
    --     -- end
    --     state_machine.excute("battle_effect_create", 0, {
    --         self._attack_type, 
    --         self._parent, 
    --         mPos, 
    --         self._effect_id, 
    --         self._attacker, 
    --         self._target, 
    --         self._angle, 
    --         self._vector, 
    --         self._floor_effect_id
    --         })
    --     state_machine.excute("battle_role_state_change", 0, self._attacker)
    -- end
end

function BattleBullet:createBulletForSpine_moveWithParabola()
    local startPoint = self._position
    local endPoint = self._vector
    local sx = startPoint.x
    local sy = startPoint.y
    local ex =endPoint.x + 50
    local ey =endPoint.y + 150

    local mp = cc.p((endPoint.x - startPoint.x), (endPoint.y - startPoint.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / self._velocity * 0.013 / 2.3

    if s > 400 then
        local h = 72 * 0.5
        if self._target ~= nil 
            and self._target._hero_type == self._target._enum_hero_type._hero
            then
            h = battle_enum._map_cell_size2._width * 0.5
        else
            h = battle_enum._map_cell_size._width * 0.5
        end
        h = math.max(0, math.min(math.abs(ex-sx) * 0.5, h))

        local spos = cc.p(sx, sy)
        local mpos = cc.p(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5)
        local epos = nil
        if ex > sx then
            epos = cc.p(endPoint.x-math.max(0, math.min(math.abs(ex-sx)*0.1, 50)), endPoint.y+h)
        else
            epos = cc.p(endPoint.x+math.max(0, math.min(math.abs(ex-sx)*0.1, 50)), endPoint.y+h)
        end


        local angle1 = CC_POSITIONS_TO_DEGREES(spos, mpos)
        local angle11 = CC_POSITIONS_TO_DEGREES(spos, cc.p(mpos.x, mpos.y))
        local angle2 = CC_POSITIONS_TO_DEGREES(mpos, epos)

        self:setRotation(angle11)

        self:runAction(cc.Spawn:create({cc.Sequence:create({--cc.RotateTo:create(t / 2 * __fight_recorder_action_time_speed, angle1), 
            cc.DelayTime:create(t / 2 * __fight_recorder_action_time_speed),
            cc.RotateTo:create(t / 2 * __fight_recorder_action_time_speed, angle2)}),
            cc.Sequence:create({cc.BezierTo:create(t * __fight_recorder_action_time_speed, {spos, mpos, epos}),
                cc.CallFunc:create(self.moveOverFunc)
            })}))

        self:createStreak()
    else
        if startPoint.x <= endPoint.x then
            endPoint.x = endPoint.x - self._rect.width
        else
            endPoint.x = endPoint.x + self._rect.width
        end
        self:runAction(cc.Sequence:create({cc.MoveTo:create(t * __fight_recorder_action_time_speed, endPoint),
                cc.CallFunc:create(self.moveOverFunc)
            }))

        self:createStreak()
    end
end

function BattleBullet:createBulletForSpineParabola()
    self:createBulletForSpine()

    -- self:createBulletForSpine_moveWithParabola()
end

function BattleBullet:createBulletForLightningBolt()
    self._duration = 0.5

    -- 调用子弹 sprite_id对应配置
    local baseName = "effect/bullet_" .. self._sprite_id

    local lightningBoltNode = cc.EffectLightning:create(
            "effect/lightning/lightingSeg.png", -- lightningTex
            "shaders/lightningBolt.vsh", -- vsh
            "shaders/lightningBolt.fsh", -- fsh
            cc.p(self._attacker:getPosition()),
            cc.p(self._target:getPosition())
        )

    self:addChild(lightningBoltNode)

    lightningBoltNode:runFlashAction()

    self:setContentSize(cc.size(0, 0))
    self:setPosition(self._position)
    self._parent:addChild(self, _scene_zorder_bullet)
end

function BattleBullet:createBulletForCrossbow()
    self._duration = 100000
    self._targets = {}
    self:createBulletForSpine()
end

function BattleBullet:onEnterTransitionFinish()

end

function BattleBullet:stepBulletForSpine(dt)
    local position = nil
    -- 计算子弹的移位
    if self._target ~= nil then
        local f = self:getRotation()
        self:setRotation(f)
        position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
        self:setPosition(position)
    elseif self._vector ~= nil then
        local f = self:getRotation()
        self:setRotation(f)
        position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
        self:setPosition(position)
    else
        local f = self:getRotation()
        self:setRotation(f)
        position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
        self:setPosition(position)
    end
    
    -- 子弹速度
    -- self._velocity = self._velocity + self._accel * dt
    self._velocity = self._accel
    if self._rect == nil then
        self._rect = self._skeletonNode:getBoundingBox()
    end

    -- 子弹与目标进行碰撞检测
    if self._vector ~= nil then
        if (self._target ~= nil and self._target._death == false) or self._send == true then
            self._vector = cc.p(self._target:getPosition())
            local nmpx = math.abs(self._vector.x - position.x)
            local nmpy = math.abs(self._vector.y - position.y)
            if nmpx < (self._velocity + self._rect.width) and nmpx < (self._velocity + self._rect.height)
                -- or (nmpx > self._nmpx and nmpy > self._nmpy)
                then
        --         self._elapsed = self._duration
        --         state_machine.excute("battle_role_hit", 0, {self._attacker, self, self._target})
        --         --  -1代表不生成特效
        --         if self._effect_id > 0 then
        --             state_machine.excute("battle_effect_create", 0, {math.random(0, 1), self._parent, cc.p(self._target:getPosition()), self._effect_id, self._attacker, self._target, self._angle, self._vector, self._floor_effect_id})
    				-- state_machine.excute("battle_role_state_change", 0, self._attacker)
        --         end
                self:moveOverFunc()
            end
            -- self._nmpx = nmpx
            -- self._nmpy = nmpy
        else
            -- if math.abs(self._vector.x - position.x) < self._velocity + self._rect.width
            --     and math.abs(self._vector.y - position.y) < self._velocity + self._rect.height
            --     then
            --         state_machine.excute("battle_role_state_change", 0, self._attacker)
            --         state_machine.excute("battle_scene_remove_bullet", 0, self)
            -- end
            
            state_machine.excute("battle_role_state_change", 0, self._attacker)
            state_machine.excute("battle_scene_remove_bullet", 0, self)
        end
    else 
        if position.x < 0 
            or position.y < 0 
            or position.x > self._size.width
            or position.y > self._size.height
            then
            -- print("子弹已经飞出了屏幕。")
            self._elapsed = self._duration
            state_machine.excute("battle_role_state_change", 0, self._attacker)
            state_machine.excute("battle_scene_remove_bullet", 0, self)
        end
   --      if position.x < 0 
   --          or position.y < 0 
   --          or position.x > self._size.width
   --          or position.y > self._size.height
   --          then
   --          self._elapsed = self._duration
   --          >print("子弹已经飞出了屏幕。")
			-- self._attacker._attacking = false
			-- self._attacker._byAttackTarget = nil
			-- local nCount = self._armature._actionIndex % _spine_sprite_animation_team_count
   --          if nCount == 3 then
   --              self._armature._nextAction = self._armature._actionIndex - 1
   --          end
   --          state_machine.excute("battle_role_state_change", 0, self._attacker)
			-- state_machine.excute("battle_scene_remove_bullet", 0, self)
   --      end
    end
end

function BattleBullet:stepBulletForLaser(dt)
    if self._current_laser == nil then
        return
    end

    local startPosition = self._position
    local currentPosition = cc.p(self:getPosition())
    self._current_laser._end_pos = cc.pSub(currentPosition, startPosition)
    self._current_laser:setEnd(self._current_laser._end_pos)

   --  local position = nil
   --  -- 计算子弹的移位
   --  if self._target ~= nil then
   --      local f = self:getRotation()
   --      self:setRotation(f)
   --      position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
   --      local scale = cc.pGetDistance(cc.p(self:getPosition()),position)
   --      self:setScaleX(scale)
   --      self:setPosition(position)
   --  elseif self._vector ~= nil then
   --      local f = self:getRotation()
   --      self:setRotation(f)
   --      position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
   --      local scale = cc.pGetDistance(cc.p(self:getPosition()),position)
   --      self:setScaleX(scale)
   --      self:setPosition(position)
   --  else
   --      local f = self:getRotation()
   --      self:setRotation(f)
   --      position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
   --      local scale = cc.pGetDistance(cc.p(self:getPosition()),position)
   --      self:setScaleX(scale)
   --      self:setPosition(position)
   --  end
    
   --  -- 子弹速度
   --  -- self._velocity = self._velocity + self._accel*dt
   --  self._velocity = self._accel

   --  -- 子弹与目标进行碰撞检测
   --  if self._vector ~= nil and self._target._death == false then
   --      if math.abs(self._vector.x - position.x) < self._velocity
   --          and math.abs(self._vector.y - position.y) < self._velocity
   --          then
   -- --          self._elapsed = self._duration
   -- --          state_machine.excute("battle_role_hit", 0, {self._attacker, self, self._target})
			-- -- if self._effect_id > 0 then
			-- -- 	state_machine.excute("battle_effect_create", 0, {math.random(0, 1), self._parent, cc.p(self._target:getPosition()), self._effect_id, self._attacker, self._target, self._angle, self._vector, self._floor_effect_id})
			-- -- end
   --          self:moveOverFunc()
   --      end
   --  else
   --      if position.x < 0 
   --          or position.y < 0 
   --          or position.x > self._size.width
   --          or position.y > self._size.height
   --          then
   --          self._elapsed = self._duration
   --          -->print("子弹已经飞出了屏幕。")
			-- state_machine.excute("battle_scene_remove_bullet", 0, self)
   --      end
   --  end
end

function BattleBullet:stepBulletForCrossbow(dt)
    local position = nil
    -- 计算子弹的移位
    if self._target ~= nil then
        local f = self:getRotation()
        self:setRotation(f)
        position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
        self:setPosition(position)
    elseif self._vector ~= nil then
        local f = self:getRotation()
        self:setRotation(f)
        position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
        self:setPosition(position)
    else
        local f = self:getRotation()
        self:setRotation(f)
        position = cc.pAdd(cc.p(self:getPosition()), cc.p(math.sin(CC_DEGREES_TO_RADIANS(f))*self._velocity, math.cos(CC_DEGREES_TO_RADIANS(f))*self._velocity))
        self:setPosition(position)
    end
    
    -- 子弹速度
    -- self._velocity = self._velocity + self._accel * dt
    -- self._velocity = self._accel
    if self._rect == nil then
        self._rect = self._skeletonNode:getBoundingBox()
    end

    -- 子弹与目标进行碰撞检测
    local range = self._current_skill.attack_scope_xy -- self._attacker._range
    position.y = position.y - self._base_offset_y
    local targets = state_machine.excute("battle_scene_range_attack_role", 0, {position, self._target_camp , range , 0})--1.圆形

    if targets ~= nil then
        if self._targets == nil then
            self._targets = {}
        end
        for i, v in pairs(targets) do
            local add = true
            for m, n in pairs(self._targets) do
                if v == n then
                    add = false
                    break
                end
            end

            if add == true then
                state_machine.excute("battle_role_hit", 0, {self._attacker, self, v})
                table.insert(self._targets, v)
            end
        end
    end

    if position.x < 0 
        or position.y < 0 
        or position.x > self._size.width
        or position.y > self._size.height
        then
        -- print("子弹已经飞出了屏幕。")
        self._elapsed = self._duration
        state_machine.excute("battle_role_state_change", 0, self._attacker)
        state_machine.excute("battle_scene_remove_bullet", 0, self)
    end
end

function BattleBullet:stepBulletForLightningBolt(dt)
    local position = nil

    local segment = 0

    if self._target ~= nil then
        if self._elapsed + dt < segment then
            -- state_machine.excute("battle_effect_create", 0, {math.random(0, 1), self._parent, cc.p(self._target:getPosition()), self._effect_id, self._attacker, self._target, self._angle, self._vector, self._floor_effect_id})
            self:moveOverFunc()
        end
    end
end

function BattleBullet:onUpdate(dt)
    self._elapsed = self._elapsed + dt
    if self._elapsed >= self._duration then
        -- 准备移除子弹
        self:unregisterOnNoteUpdate(self)
        self:setVisible(false)
        fwin:addService({
                callback = function ( params )
                    state_machine.excute("battle_scene_remove_bullet", 0, params)
                end,
                params = self
            })
        return
    end


    local rotation = self:getRotation()
    for i, v in pairs(self._streaks) do
        -- v:setRotation(rotation)
        v:setPosition(cc.p(self:getPosition()))
    end

    if self._bullet_type == self._enum_bullet_type._spine then
        self:stepBulletForSpine(dt)
    elseif self._bullet_type == self._enum_bullet_type._laser then
        self:stepBulletForLaser(dt)
    elseif self._bullet_type == self._enum_bullet_type._crossbow then
        self:stepBulletForCrossbow()
    elseif self._bullet_type == self._enum_bullet_type._parabola then
        if self._rect == nil then
            self._rect = self._skeletonNode:getBoundingBox()
            if self._position.x <= self._vector.x then
                self._vector.x = self._vector.x - self._rect.width
            else
                self._vector.x = self._vector.x + self._rect.width
            end
            self:createBulletForSpine_moveWithParabola()
        end
    elseif self._bullet_type == self._enum_bullet_type._laser2 then
        self:stepBulletForLaser(dt)
    elseif self._bullet_type == self._enum_bullet_type._lightning then
        self:stepBulletForLightningBolt()
    end
end

function BattleBullet:close()

end

function BattleBullet:destroy()

end
-- ----------------------------------------------------------------------------------------------------