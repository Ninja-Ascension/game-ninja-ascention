-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗中怒气技能特效
-- ----------------------------------------------------------------------------------------------------
BattleSkillEffect = class("BattleSkillEffectClass", Window)

local battle_skill_effect_window_open_terminal = {
    _name = "battle_skill_effect_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local battleSkillEffect = fwin:find("BattleSkillEffectClass")
        if nil == battleSkillEffect then
            battleSkillEffect = BattleSkillEffect:new():init(params)
            fwin:open(battleSkillEffect,fwin._ui)
        else
            battleSkillEffect:addRole(params)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_skill_effect_window_close_terminal = {
    _name = "battle_skill_effect_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleSkillEffectClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_skill_effect_window_open_terminal)
state_machine.add(battle_skill_effect_window_close_terminal)
state_machine.init()

function BattleSkillEffect:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {} 

    self._drawCount = 0
end

function BattleSkillEffect:init(params)
    self:onInit(params)
    return self
end


function BattleSkillEffect:onEnterTransitionFinish()

end

local function onMoveFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
    local armature = bone:getArmature()
    if evt == "stop" then
        if armature._drawIndex < armature._self._drawCount then
            armature._invoke = nil
            armature:pause()
        end
    elseif evt == "music" then
        if config_res.battle ~= nil and config_res.battle.music ~= nil and config_res.battle.music.skill_effect ~= nil then
            playEffectMusic(config_res.battle.music.skill_effect[2])
        end
    end
end

local function deleteEffect(armatureBack)
    state_machine.excute("battle_skill_effect_window_close", 0, 0)
end

function BattleSkillEffect:onInit(spriteId)
    local armature = csb.createEffect(config_res.battle.effect.skill_effect.bg, nil, self, 1, nil, __fight_recorder_action_time_speed)
    armature._invoke = nil
    self:addRole(spriteId)
end

function BattleSkillEffect:addRole(spriteId)
    local armature_role = csb.createEffect(config_res.battle.effect.skill_effect.role, nil, self, -1, nil, __fight_recorder_action_time_speed)
    local animation = armature_role:getAnimation()
    animation:setFrameEventCallFunc(onMoveFrameEvent)
    armature_role._self = self
    armature_role._invoke = nil
    animation:playWithIndex(self._drawCount)
    armature_role._invoke = deleteEffect
    self._drawCount = self._drawCount + 1
    armature_role._drawIndex = self._drawCount

    local ka1Str = "ka"..self._drawCount
    local ka1_1Str = "ka"..self._drawCount.."_1"
    local headPng = "images/face/skill_head/skill_card_" .. spriteId .. ".png"
    local ka1 = ccs.Skin:create(headPng)
    local ka1_1 = ccs.Skin:create(headPng)
    armature_role:getBone(ka1Str):addDisplay(ka1, 0)
    armature_role:getBone(ka1_1Str):addDisplay(ka1_1, 0)
end

function BattleSkillEffect:close()

end

function BattleSkillEffect:destroy()

end

function BattleSkillEffect:onExit()
    state_machine.remove("battle_time_out_leave_fight")
end
-- ----------------------------------------------------------------------------------------------------