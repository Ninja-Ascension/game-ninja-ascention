-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗中主公技技能特效
-- ----------------------------------------------------------------------------------------------------
BattlePlayerSkillEffect = class("BattlePlayerSkillEffectClass", Window)

local battle_player_skill_effect_window_open_terminal = {
    _name = "battle_player_skill_effect_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local battlePlayerSkillEffect = fwin:find("BattlePlayerSkillEffectClass")
        if nil == battlePlayerSkillEffect then
            battlePlayerSkillEffect = BattlePlayerSkillEffect:new():init(params)
            fwin:open(battlePlayerSkillEffect,fwin._windows)
        else
            battlePlayerSkillEffect:addRole(params[2])
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_player_skill_effect_window_close_terminal = {
    _name = "battle_player_skill_effect_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattlePlayerSkillEffectClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_player_skill_effect_window_open_terminal)
state_machine.add(battle_player_skill_effect_window_close_terminal)
state_machine.init()

function BattlePlayerSkillEffect:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {} 

    self._drawCount = 0
end

function BattlePlayerSkillEffect:init(params)
    self:onInit(params)
    return self
end


function BattlePlayerSkillEffect:onEnterTransitionFinish()

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
            playEffectMusic(config_res.battle.music.skill_effect[4])
        end
    end
end

local function deleteEffect(armatureBack)
    state_machine.excute("battle_player_skill_effect_window_close", 0, 0)
end

function BattlePlayerSkillEffect:onInit(params)
    self:setPositionX(-1 * app.baseOffsetX)
    local armature = csb.createEffect(config_res.battle.effect.general_skill_effect.bg, nil, self, 1, nil, __fight_recorder_action_time_speed)
    armature._invoke = nil
    self:addRole(params)
end

function BattlePlayerSkillEffect:addRole(params)
    local camp = params[1]
    local headPic = nil
    if camp == 0 then
        headPic = _ED.user_info.user_head_id
    else
        headPic = _ED.other_user_info.user_head_id or 301
    end
    local armature_role = csb.createEffect(config_res.battle.effect.general_skill_effect.role, nil, self, -1, nil, __fight_recorder_action_time_speed)
    local animation = armature_role:getAnimation()
    animation:setFrameEventCallFunc(onMoveFrameEvent)
    armature_role._self = self
    armature_role._invoke = nil
    -- animation:playWithIndex(self._drawCount)
    armature_role._invoke = deleteEffect
    self._drawCount = self._drawCount + 1
    armature_role._drawIndex = self._drawCount

    local campIndex = zstring.tonumber(camp) + 1
    local zhujueString = "zhujue_"..campIndex
    local headPng = "images/face/skill_head/skill_head_" .. headPic .. ".png"
    local zhujue = ccs.Skin:create(headPng)
    -- print(zhujueString, headPng)
    armature_role:getBone(zhujueString):addDisplay(zhujue, 0)
end

function BattlePlayerSkillEffect:close()

end

function BattlePlayerSkillEffect:destroy()

end

function BattlePlayerSkillEffect:onExit()
    state_machine.remove("battle_time_out_leave_fight")
end
-- ----------------------------------------------------------------------------------------------------