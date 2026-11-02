-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗特效
-- ----------------------------------------------------------------------------------------------------
BattleEffect = class("BattleEffectClass", Window)

local battle_effect_create_terminal = {
    _name = "battle_effect_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- local index = params[4]
        -- if index == nil or index <= 0 then
        --     return false
        -- end

    	return BattleEffect:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_effect_delete_terminal = {
    _name = "battle_effect_delete",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battleEffect = params
        if _battleEffect ~= nil and _battleEffect.roots ~= nil then
            _battleEffect._draw_effect_count = _battleEffect._draw_effect_count - 1
            if _battleEffect._draw_effect_count <= 0 then
        		-- _battleEffect._attacker._attacking = false
        		-- _battleEffect._attacker._byAttackTarget = nil
        		-- state_machine.excute("battle_role_state_change", 0, _battleEffect._attacker)
                _battleEffect:removeFromParent(true)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_effect_hurt_terminal = {
    _name = "battle_effect_hurt",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battleEffect = params
        if _battleEffect ~= nil and _battleEffect.roots ~= nil then
            _battleEffect:hurt()
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_effect_remove_terminal = {
    _name = "battle_effect_remove",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battleEffect = params
        if _battleEffect ~= nil and _battleEffect.roots ~= nil then
            _battleEffect._draw_effect_count = 0
            -- local effect = _battleEffect:getChildByName("effect")
            local floor_effect = _battleEffect:getChildByName("floor_effect")
            local fly_effect = _battleEffect:getChildByName("fly_effect")
            if effect ~= nil and effect:getParent() ~= nil then
                state_machine.excute("battle_map_remove_effect", 0, effect)
                effect:removeFromParent(true)
            end
            if floor_effect ~= nil and floor_effect:getParent() ~= nil then
                state_machine.excute("battle_map_remove_effect", 0, floor_effect)
                floor_effect:removeFromParent(true)
                state_machine.excute("battle_effect_delete", 0, _battleEffect)
            end
            if fly_effect ~= nil and fly_effect:getParent() ~= nil then
                state_machine.excute("battle_map_remove_effect", 0, fly_effect)
                fly_effect:removeFromParent(true)
                state_machine.excute("battle_effect_delete", 0, _battleEffect)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_effect_create_terminal)
state_machine.add(battle_effect_delete_terminal)
state_machine.add(battle_effect_hurt_terminal)
state_machine.add(battle_effect_remove_terminal)
state_machine.init()

function BattleEffect:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    
    -- var
    self._elapsed = 0
    self._duration = 3
    self._position = nil
    self._size = nil

    self._draw_effect_count = 0

    self._effect_type = 0
    self._enum_effect_type = {
        _spine = 0,
        _splash = 1,
    }

    self._parent = nil
    self._attacker = nil
    self._target = nil
    self._sprite_id = -1
    self._floor_effect_id = -1
    self._velocity = 10
    self._accel = 15
    self._vector = nil -- cc.p(500, 500)
    self._angle = 0
    self._turnRate = 180

    self._bear_lighting_effect_id = 0

    self._current_skill = nil
    self._attack_type = 0
    self._targets = nil
    self._is_attacking = false

    self._is_frist_hurt = true
end

function BattleEffect:init(params)
    local effectType = params[1]
    local parent = params[2]
    local position = params[3]
    local index = params[4]
    local attaker = params[5]
    local target = params[6]
    local angle = params[7]
    local vector = params[8]
    local floor_effect = params[9]
    local fly_effect = params[10]
    local currentSkill = params[11]
    local attackType = params[12]
    local targets = params[13]
    local isAttacking = params[14]

    self._effect_type = effectType

    -- 设置特效位置的偏移
    position.y = position.y + 40
    self._position = position
    self._size = parent:getContentSize()

    self._parent = parent
    self._attacker = attaker
    self._target = target
    self._sprite_id = index
    self._effect_draw_type = 0
    self._floor_effect_id = floor_effect or 0
    self._floor_effect_draw_type = 0
    self._fly_effect_id = fly_effect or 0
    self._fly_effect_draw_type = 0
    self._vector = vector

    self._is_attacking = isAttacking or false

    self._is_frist_hurt = true

    self._angle = angle

    if currentSkill ~= nil then
        self._current_skill = currentSkill
        if self._is_attacking == true then
            self._sprite_id = currentSkill.effect
            self._effect_draw_type = currentSkill.effect_draw_type
        end
        self._floor_effect_id = currentSkill.floor_effect
        self._floor_effect_draw_type = currentSkill.floor_effect_draw_type
        self._fly_effect_id = currentSkill.fly_effect
        self._fly_effect_draw_type = currentSkill.fly_effect_draw_type
        self._bear_lighting_effect_id = currentSkill.bear_lighting_effect_id
    end
    self._attack_type = attackType
    self._targets = targets

    self._effect_type = 0
    if self._effect_type == self._enum_effect_type._spine then
        if self._sprite_id > 0 then
            self:createEffectForSpine()
        end
    elseif self._effect_type == self._enum_effect_type._splash then
        self:createEffectForSplash()
    end

    if isAttacking == true then
        if self._floor_effect_id > 0 then
            self:createFloorEffect()
        end

        if self._fly_effect_id > 0 then
            self:createFlyEffect()
        end
        if currentSkill.posterior_lighting_sound_effect_id > 0 then
            playEffectMusic(currentSkill.posterior_lighting_sound_effect_id)
        end
    else
        if currentSkill.bear_sound_effect_id > 0 then
            playEffectMusic(currentSkill.bear_sound_effect_id)
        end
    end

    self:setContentSize(cc.size(0, 0))
    -- self:setPosition(self._position)
    -- self._parent:addChild(self, _scene_zorder_effect)

    local h = 0
    if self._target._hero_type == self._target._enum_hero_type._hero then
        h = 50 -- battle_enum._map_cell_size2._width / 2
    else
        h = 28 -- battle_enum._map_cell_size._width / 2
    end
    self:setPositionY(h)
    -- self:setRotation(angle)
    -- self._target:addChild(self, _scene_zorder_effect, _scene_tag_effect)
    self._target._effect_layer:addChild(self)
	return self
end

function BattleEffect:executeHurt()
    if self._target == nil 
        or (self._target._death == true and self._current_skill.skill_influence_type ~= 38)
        or self._target._death == nil
        then
        return
    end

    if self._current_skill == nil then
        return
    end

    state_machine.excute("battle_role_hit", 0, {self._attacker, self, self._target, self._is_frist_hurt})

    if self._is_attacking == true then
        state_machine.excute("battle_effect_create", 0, {
            0, -- self._attack_type, 
            self._parent, 
            cc.p(self._target:getPosition()), -- cc.p(self._target:getPosition()), 
            self._bear_lighting_effect_id, 
            self._attacker, 
            self._target,
            self._angle, 
            self._vector, 
            0,
            0,
            self._current_skill,
            self._attack_type,
            nil,
            false})
    else
        if self._current_skill ~= nil 
            and self._current_skill.bear_sound_effect_id > 0 
            then
            playEffectMusic(self._current_skill.bear_sound_effect_id)
        end
    end
end

function BattleEffect:hurt()
    if self._current_skill == nil or self.executeHurt == nil then
        return
    end
    if self._targets ~= nil 
        and #self._targets > 0 
        then
        for i, v in pairs(self._targets) do
            self._target = v
            self:executeHurt()
        end
    else
        self:executeHurt()
    end
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
    local armature = bone --:getArmature()
    local frameEvents = zstring.split(evt, "_")
    if checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_hurt) == true then
        state_machine.excute("battle_effect_hurt", 0, armature._self)
        if armature._self._is_frist_hurt == true then
            armature._self._is_frist_hurt = false
        end
    elseif checkFrameEvent(frameEvents, _enum_spine_animation_frame_event_name.animation_shake) == true then
        state_machine.excute("battle_map_shake_screen_play", 0, nil)
    end
end

-- 命中特效
function BattleEffect:createEffectForSpine()
    if self._sprite_id <= 0 then
        return
    end
    self._draw_effect_count = self._draw_effect_count + 1
    local baseName = "effect/effect_" .. self._sprite_id
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)

    if self._attacker._camp == 1 then
        skeletonNode:setScaleX(-1)
    else
        skeletonNode:setScaleX(1)
    end

    -- 完成删除特效 event.skeletonAnimation._self调用方 子弹
    skeletonNode:registerSpineEventHandler(function (event)
        state_machine.excute("battle_map_remove_effect", 0, event.skeletonAnimation)
        event.skeletonAnimation:removeFromParent(true)
        state_machine.excute("battle_effect_delete", 0, event.skeletonAnimation._self)
    end, sp.EventType.ANIMATION_COMPLETE)

    skeletonNode:registerSpineEventHandler(function (event)
        if event.eventData.stringValue ~= "" and event.eventData.stringValue ~= " " then
            onFrameEvent(event.skeletonAnimation, event.eventData.stringValue, event.trackIndex, event.trackIndex)
        end
    end, sp.EventType.ANIMATION_EVENT)

    skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
    skeletonNode._self = self
    self:addChild(skeletonNode)
    state_machine.excute("battle_map_add_effect", 0, skeletonNode)
    skeletonNode:setName("effect")
    skeletonNode._self = self

    if self._effect_draw_type == 1 then
        self._angle = battle_enum._battle_effect_angle[1]
        if self._attacker._camp == 1 then
            self._angle = battle_enum._battle_effect_angle[2]
        end
        skeletonNode:setRotation(self._angle)
    end
end

-- 脚下特效
function BattleEffect:createFloorEffect()
    if self._floor_effect_id <= 0 then
        return
    end
    self._draw_effect_count = self._draw_effect_count + 1
    local baseName = "effect/effect_" .. self._floor_effect_id
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)

    -- 完成删除特效
    skeletonNode:registerSpineEventHandler(function (event)
        state_machine.excute("battle_map_remove_effect", 0, event.skeletonAnimation)
        event.skeletonAnimation:removeFromParent(true)
        state_machine.excute("battle_effect_delete", 0, event.skeletonAnimation._self)
    end, sp.EventType.ANIMATION_COMPLETE)

    skeletonNode:registerSpineEventHandler(function (event)
        if event.eventData.stringValue ~= "" and event.eventData.stringValue ~= " " then
            onFrameEvent(event.skeletonAnimation, event.eventData.stringValue, event.trackIndex, event.trackIndex)
        end
    end, sp.EventType.ANIMATION_EVENT)

    skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
    self._parent._front_effect_layer:addChild(skeletonNode, _scene_zorder_floor_effect)
    skeletonNode:setPosition(self._position)
    state_machine.excute("battle_map_add_effect", 0, skeletonNode)
    skeletonNode:setName("floor_effect")

    skeletonNode._self = self

    if self._floor_effect_draw_type == 1 then
        skeletonNode:setRotation(self._angle)
    elseif self._floor_effect_draw_type == 2 then
        if self._attacker._camp == 1 then
            skeletonNode:setScaleX(-1)
        else
            skeletonNode:setScaleX(1)
        end
    elseif self._floor_effect_draw_type == 3 then
        skeletonNode:setRotation(self._angle)
        if self._attacker._camp == 1 then
            skeletonNode:setScaleX(-1)
        else
            skeletonNode:setScaleX(1)
        end
    end
end

--角色前景特效
function BattleEffect:createFlyEffect()
    if self._fly_effect_id <= 0 then
        return
    end
    self._draw_effect_count = self._draw_effect_count + 1
    local baseName = "effect/effect_" .. self._fly_effect_id
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    -- 完成删除特效
    skeletonNode:registerSpineEventHandler(function (event)
        state_machine.excute("battle_map_remove_effect", 0, event.skeletonAnimation)
        event.skeletonAnimation:removeFromParent(true)
        state_machine.excute("battle_effect_delete", 0, event.skeletonAnimation._self)
    end, sp.EventType.ANIMATION_COMPLETE)

    skeletonNode:registerSpineEventHandler(function (event)
        if event.eventData.stringValue ~= "" and event.eventData.stringValue ~= " " then
            onFrameEvent(event.skeletonAnimation, event.eventData.stringValue, event.trackIndex, event.trackIndex)
        end
    end, sp.EventType.ANIMATION_EVENT)

    skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
    self._parent._back_effect_layer:addChild(skeletonNode, _scene_zorder_fly_effect)
    skeletonNode:setPosition(self._position)
    state_machine.excute("battle_map_add_effect", 0, skeletonNode)
    skeletonNode:setName("fly_effect")

    skeletonNode._self = self

    if self._fly_effect_draw_type == 1 then
        skeletonNode:setRotation(self._angle)
    elseif self._fly_effect_draw_type == 2 then
        if self._attacker._camp == 1 then
            skeletonNode:setScaleX(-1)
        else
            skeletonNode:setScaleX(1)
        end
    elseif self._fly_effect_draw_type == 3 then
        skeletonNode:setRotation(self._angle)
        if self._attacker._camp == 1 then
            skeletonNode:setScaleX(-1)
        else
            skeletonNode:setScaleX(1)
        end
    end
end

-- 爆点特效 暂时不使用
function BattleEffect:createEffectForSplash()
    -- self._duration = 0.3
    -- local splashNode = cc.EffectSplash:create(
    --         "effect/splash/splashSpot1.png", -- tex0
    --         "effect/splash/splashSpot2.png", -- tex1
    --         "shaders/splash/highlight.fsh", -- metaBall_fsh
    --         "shaders/splash/metaBall.fsh" -- highlight_fsh
    --     )
    -- local size = cc.size(fwin._width, fwin._height)
    -- splashNode:onStart(cc.p(size.width / 2, size.height / 2))
    -- splashNode:setPosition(cc.p(size.width / -2, size.height / -2))
    -- self:addChild(splashNode)

    -- fwin:addService({
    --     callback = function ( params )
    --         state_machine.excute("battle_effect_delete", 0, params)
    --     end,
    --     params = self,
    --     dilay = 0.3
    -- })
end

function BattleEffect:onEnterTransitionFinish()

end

function BattleEffect:close()

end

function BattleEffect:destroy()

end
-- ----------------------------------------------------------------------------------------------------