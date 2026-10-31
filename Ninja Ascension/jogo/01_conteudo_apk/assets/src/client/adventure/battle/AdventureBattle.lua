-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗模块
-------------------------------------------------------------------------------------------------------
AdventureBattle = class("AdventureBattleClass", Window)

local kZOrderInMap_StanddyRole  = 0
local kZOrderInMap_MoveRole     = 10000 
local kZOrderInMap_Effect       = 2000000       
local kZOrderInMap_Hurt         = 3000000       
local kZOrderInMap_sp_effect    = 4000000

-- -- 播放音效
-- playEffectMusic = function(musicIndex)
--     -- 播放音效
--     pushEffect(formatMusicFile("effect", musicIndex))
-- end
    
function AdventureBattle:ctor()
    self.super:ctor()
    self.roots = {}

    self.currentRoundIndex = 0
    self.currentRoundAttackIndex = 0
    self.roundData = nil

    self._map = nil

    app.load("client.battle.fight.FightEnum")
    app.load("client.battle.fight.FightRecorder")
    app.load("client.adventure.battle.AdventureBattleMap")
    app.load("client.adventure.battle.AdventureBattleUI")
    app.load("client.adventure.battle.AdventureBattleOpening")

    -- Initialize adventure battle state machine.
    local function init_adventure_battle_terminal()
        -- 开始战斗
            local adventure_battle_start_fight_terminal = {
            _name = "adventure_battle_start_fight",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if executeMissionExt(mission_mould_battle, touch_off_mission_start_battle, 
                    "" .. _ED._scene_npc_id.."v" .. self.currentRoundIndex, nil) == false then
                    instance:startFight()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 返回战斗
        local fight_attack_logic_round_running_adventure_terminal = {
            _name = "fight_attack_logic_round_running_adventure",
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

          -- 跳过战斗
        local adventure_battle_jump_fight_terminal = {
            _name = "adventure_battle_jump_fight",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("adventure_battle_execute_battle_over")
                instance:battleOver()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        -- 更新UI的回合显示
        local adventure_battle_update_ui_fight_round_terminal = {
            _name = "adventure_battle_update_ui_fight_round",
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

        -- 角色攻击技能名称动画绘制完毕
        local adventure_battle_execute_skill_name_effect_over_terminal = {
            _name = "adventure_battle_execute_skill_name_effect_over",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:executeSkillNameEffectOver()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 执行攻击
        local adventure_battle_execute_attack_terminal = {
            _name = "adventure_battle_execute_attack",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:executeAttack()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗结算
        local adventure_battle_execute_battle_over_terminal = {
            _name = "adventure_battle_execute_battle_over",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("adventure_battle_execute_battle_over")
                instance:battleOver()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_battle_start_fight_terminal)
        state_machine.add(fight_attack_logic_round_running_adventure_terminal)
        state_machine.add(adventure_battle_update_ui_fight_round_terminal)
        state_machine.add(adventure_battle_execute_skill_name_effect_over_terminal)
        state_machine.add(adventure_battle_execute_attack_terminal)
        state_machine.add(adventure_battle_execute_battle_over_terminal)
        state_machine.add(adventure_battle_jump_fight_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle state machine.
    init_adventure_battle_terminal()
end

function AdventureBattle:startFight()
    -->__crint("开始战斗")
    self:nextRound()
end

function AdventureBattle:nextRound()
    if self.currentRoundIndex >= _ED.attackData.roundCount then
        -- self:battleOver()
        state_machine.excute("adventure_battle_map_draw_battle_over", 0, zstring.tonumber(_ED.attackData.isWin))
        return
    end
    -->__crint("回合攻击开始")
    self.currentRoundAttackIndex = 1
    self.currentSkillInfluenceStartIndex = 1
    self.currentRoundIndex = self.currentRoundIndex + 1
    if self.currentRoundIndex == 3 then
        state_machine.excute("adventure_Battle_ui_update_junp_fight", 0, 0)
    end


    state_machine.excute("adventure_battle_ui_update_round", 0, self.currentRoundIndex)

    self:nextAttack()
end

function AdventureBattle:nextAttack()
    local _roundData = _ED.attackData.roundData[self.currentRoundIndex]
    if _roundData == nil or self.currentRoundAttackIndex > _roundData.curAttackCount then
        self:nextRound()
        return
    end
    -->__crint("攻击开始")
    local attData = _roundData.roundAttacksData[self.currentRoundAttackIndex]

    self.currentRoundAttackIndex = self.currentRoundAttackIndex + 1
    
    local attacker              = attData.attacker                              -- = npos(list)             --回合1出手方标识(0:我方 1:对方)
    local attackerPos           = attData.attackerPos                           -- = npos(list)             --出手方位置(1-6)
    local linkAttackerPos       = attData.linkAttackerPos                       --是否有合体技(>0表示有.且表示合体的对象)
    local attackMovePos         = tonumber(attData.attackMovePos)               -- = npos(list)             --移动到的位置(0-8)
    local skillMouldId          = tonumber(attData.skillMouldId)                -- = npos(list)             --技能模板id
    local skillInfluenceCount   = tonumber(attData.skillInfluenceCount)         -- = tonumber(npos(list))   -- 技能效用数量

    local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
    
    -- skill data
    local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)                      -- 技能类型(0:普通 1:怒气)
    local skillProperty = dms.atoi(skillElementData, skill_mould.skill_property)                    -- 技能属性(0:物理 1:法术)
    local skillReleasePosition = dms.atoi(skillElementData, skill_mould.skill_release_position)
    local skillInfluenceId = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")[1]
    local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)

    self.attData = attData

    self.attacker = zstring.tonumber(attacker)
    self.attackerPos = zstring.tonumber(attackerPos)
    self.currentSkillInfluenceStartIndex = 1
    self.skillInfluenceCount = skillInfluenceCount
    self.skillElementData = skillElementData
    self.skillInfluenceElementData = skillInfluenceElementData

    -- 绘制攻击的技能名称特效
    self:executeAttackSkillNameEffect()

    -- 启动场景特效
    local tempString = ""..dms.atos(self.skillInfluenceElementData, skill_influence.scene_effect)
    local scene_effect = zstring.tonumber(zstring.split(tempString, ",")[1])
    if scene_effect >= 0 then
        state_machine.excute("adventure_battle_map_draw_blink", 0, scene_effect)
    end
end

function AdventureBattle:executeAttackSkillNameEffect()
    -->__crint("绘制攻击的技能名称特效", self.attacker)
    state_machine.excute("adventure_battle_map_draw_attack_skill_name_effect", 0, {self.attacker, self.skillElementData, self.skillInfluenceElementData, self.attackerPos})
end

function AdventureBattle:executeSkillNameEffectOver()
    -- 检查是否有技能特效
    local skillProperty = dms.atoi(self.skillElementData, skill_mould.skill_property)    -- 技能属性(0:物理 1:法术)
    self:executeAttackSkillEffectBegan()
end

function AdventureBattle:executeAttackSkillEffectBegan()
    local forepart_lighting_effect_id = dms.atoi(self.skillInfluenceElementData, skill_influence.forepart_lighting_effect_id)
    -->__crint("攻击前段技能特效：", forepart_lighting_effect_id)
    if forepart_lighting_effect_id > 0 then
        local armatureEffect = self:createEffect(forepart_lighting_effect_id)
        armatureEffect._invoke = AdventureBattle.executeAttackSkillEffectOver
        armatureEffect._self = self
        state_machine.excute("adventure_battle_map_draw_effect", 0, {self.attacker, armatureEffect})
    else
        -- 移动到发动攻击的目标的
        self:executeHeroMoveToTarget()
    end

    local forepart_lighting_sound_effect_id = dms.atoi(self.skillInfluenceElementData, skill_influence.forepart_lighting_sound_effect_id)
    if forepart_lighting_sound_effect_id >= 0 then
        playEffectMusic(forepart_lighting_sound_effect_id)
    end
end

function AdventureBattle.executeAttackSkillEffectOver(armatureBack)
    local _self = armatureBack._self
    -- 移动到发动攻击的目标的
    _self:executeHeroMoveToTarget()

    AdventureBattle.deleteEffectFile(armatureBack)

    -->__crint("攻击前段光效绘制结束")
end

function AdventureBattle:executeHeroMoveToTarget()
    -->__crint("移动到被攻击角色", self.attacker)
    state_machine.excute("adventure_battle_map_move_attacker", 0, self.attacker)
end

function AdventureBattle:executeAttack()
    -->__crint("执行角色攻击")
    self:executeAttacking()
end

function AdventureBattle:executeAttacking()
    -->__crint("执行角色攻击中")
    if self.skillInfluenceCount <= 0 then
        state_machine.excute("adventure_battle_map_draw_miss", 0, (self.attacker + 1) % 2)
    end
    if self.currentSkillInfluenceStartIndex <= self.skillInfluenceCount then
        local recal = self:executeAttackInfluence(self.attData.skillInfluences[self.currentSkillInfluenceStartIndex])
        if recal == 2 then
            self.currentSkillInfluenceStartIndex = self.currentSkillInfluenceStartIndex + 1
            self:executeAttacking()
        end
    else
        self:executeHeroMoveToOriginTarget()
    end
end

function AdventureBattle:executeAttackInfluence(skf)
    -->__crint("执行角色攻击效用")
    -- 执行被攻击中段
    local attackInfluencedCount = 0
    local _skf = skf
    local skillInfluenceId  = tonumber(_skf.skillInfluenceId)                   -- = npos(list) --效用1ID
    local influenceType = _skf.influenceType        -- 效用类型(0:攻击 1:反击)
    local attackerType = _skf.attackerType          -- 效用发动者(出手方标识 0:我方 1:对方)
    local attackerPos = _skf.attackerPos            -- 效用发动者位置
    local currPosTile = nil
    if attackerType == "1" then
        
    else
        
    end
    local skillInfluenceId = skillInfluenceId
    local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
    self.skillInfluenceElementData = skillInfluenceElementData
    -- -- 加载技能效用
    -- local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
    -- local skillCategory = dms.atoi(skillInfluenceElementData, skill_influence.skill_category)
    -- local lightingEffectDrawMethod = dms.atoi(skillInfluenceElementData, skill_influence.lighting_effect_draw_method)
    -- local attackSection = dms.atoi(skillInfluenceElementData, skill_influence.attack_section)
    -- local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, influenceType, skill_influence.posterior_lighting_effect_id)     -- dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_effect_id)
    -- local is_vibrate = dms.atoi(skillInfluenceElementData, skill_influence.is_vibrate)

    _skf._attackSection = attackSection
                
    -- self:executeEffectSkilling() --无需中断光效
    
    local erole = {}
    for w = 1, _skf.defenderCount do
        local _def = _skf._defenders[w]
        local defender = tonumber(_def.defender)            -- = npos(list)         --承受方1的标识(0:我方 1:对方)
        local defenderPos = tonumber(_def.defenderPos)      -- = npos(list)         --承受方1的位置
        local restrainState = _def.restrainState            -- = npos(list)         --相克状态(0,无克制 1,有克制,2被克制)
        local defenderST = _def.defenderST                  -- = npos(list)         --承受方1的作用效果(0伤害1加血2345思维属性)
        local stValue = _def.stValue                        -- = npos(list)         --承受方1的作用值
        local stRound = _def.stRound                        -- = npos(list)         --承受方1的持续回合数
        local defState = _def.defState                      -- = npos(list)         --承受方1的承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格)
        local defAState = _def.defAState                    -- = npos(list)         --承受方1生存状态(0:存活 1:死亡 2:反击)
        
        if defState == "0" or defState == "2" then
            if defenderST == "0" then -- 减血
                state_machine.excute("adventure_battle_ui_update_hp_progress", 0, {defender, -1 * tonumber(stValue), self.skillInfluenceElementData})
            elseif defenderST == "1" then -- 加血
                state_machine.excute("adventure_battle_ui_update_hp_progress", 0, {defender, tonumber(stValue), self.skillInfluenceElementData})
            elseif defenderST == "2" or defenderST == "3" or defenderST == "4" or defenderST == "5" then
                state_machine.excute("adventure_battle_ui_update_change_fight_info",0,{defenderST,stValue,defender})
                -->__crint("无效的攻击效用。")
            end
        elseif defState == "1" then
            state_machine.excute("adventure_battle_map_draw_miss", 0, defender)
        end
        self:executeAttackSkillEffectEnd(defender) --无需中断光效
    end
end

function AdventureBattle.deleteEffectFile(armatureBack)
    -- 删除光效
    armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns
    if armatureBack._LastsCountTurns <= 0 then
        local fileName = armatureBack._fileName
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

-- 加载光效资源文件
-- effect_6006.ExportJson
function AdventureBattle:loadEffectFile(fileIndex)
    local fileName = string.format("effect/effect_%d.ExportJson", fileIndex)
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    local armatureName = string.format("effect_%d", fileIndex)
    return armatureName, fileName
end

function AdventureBattle:createEffect(fileIndex)
    -- 创建光效
    local armatureName, fileName = self:loadEffectFile(fileIndex)
    local armature = ccs.Armature:create(armatureName)
    armature._fileName = fileName

    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    local _tcamp = 0
    local _armatureIndex = 0 -- frameListCount * _tcamp
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    armature:getAnimation():setSpeedScale(1.0 / __fight_recorder_action_time_speed)
    
    local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
    armature._duration = duration / 60.0
    return armature
end

function AdventureBattle:executeEffectSkilling()
    -->__crint("绘制攻击特效")
    local backPad = self
    local skillInfluenceElementData = self.skillInfluenceElementData
    local posterior_lighting_effect_id = getCampEffectId(skillInfluenceElementData, self.attacker, skill_influence.posterior_lighting_effect_id)
    if posterior_lighting_effect_id >= 0 then       
        local armatureEffect = self:createEffect(backPad, posterior_lighting_effect_id, self.attacker)
        armatureEffect._self = self
        armatureEffect._invoke = self.executeEffectSkillingOver
        -- armatureEffect:getAnimation():setFrameEventCallFunc(onFrameEvent)
    else
        self:executeHeroMoveToOriginTarget()
    end
    local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
    if posterior_lighting_sound_effect_id >= 0 then
        playEffectMusic(posterior_lighting_sound_effect_id)
    end
end

function AdventureBattle.executeEffectSkillingOver(armatureBack)
    -->__crint("绘制攻击特效结束")
    local _self = armatureBack._self
    deleteEffectFile(armatureBack)
    _self:executeHeroMoveToOriginTarget()
end

function AdventureBattle:executeAttackSkillEffectEnd(defender)
    local bear_lighting_effect_id = dms.atoi(self.skillInfluenceElementData, skill_influence.bear_lighting_effect_id)
    if bear_lighting_effect_id >= 0 then
        local armatureEffect = self:createEffect(bear_lighting_effect_id)
        armatureEffect._self = self
        armatureEffect._invoke = AdventureBattle.executeAttackSkillEffectEndOver

        state_machine.excute("adventure_battle_map_draw_effect", 0, {defender, armatureEffect})

        local is_vibrate = dms.atoi(self.skillInfluenceElementData, skill_influence.is_vibrate)
        if is_vibrate == 1 then
            state_machine.excute("adventure_battle_map_draw_shake", 0, 0)
        end

        -- local frameListCount = math.floor(armatureEffect:getAnimation():getAnimationData():getMovementCount())
        -- self.byAttackEffectIndex = self.byAttackEffectIndex % frameListCount
        -- armatureEffect:getAnimation():playWithIndex(self.byAttackEffectIndex)
        -- self.byAttackEffectIndex = self.byAttackEffectIndex + 1

        -- local size = self:getContentSize()
        -- armatureEffect:setPosition(cc.p(size.width / 2, 0))
        -- if self.roleCamp == 1 then
        --     armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
        -- end
        -- self:addChild(armatureEffect)
    else
        self:executeHeroMoveToOriginTarget()
    end

    local bear_sound_effect_id = dms.atoi(self.skillInfluenceElementData, skill_influence.bear_sound_effect_id)
    if bear_sound_effect_id >= 0 then
        playEffectMusic(bear_sound_effect_id)
    end
end

function AdventureBattle.executeAttackSkillEffectEndOver(armatureBack)
    -->__crint("绘制攻击特效结束")
    local _self = armatureBack._self
    AdventureBattle.deleteEffectFile(armatureBack)
    _self:executeHeroMoveToOriginTarget()
end

function AdventureBattle:executeHeroMoveToOriginTarget()
    -->__crint("角色移回原点")
    if (self.currentSkillInfluenceStartIndex < self.skillInfluenceCount) then
        self.currentSkillInfluenceStartIndex = self.currentSkillInfluenceStartIndex + 1
        self:executeAttacking()
        return
    end
    self:nextAttack()
end

function AdventureBattle:battleOver()
    -->__crint("战斗结束")
    if _ED.attackData.isWin == "0" then -- 失败的
        app.load("client.adventure.battle.AdventureBattleLose")
        fwin:open(AdventureBattleLose:new():init(), fwin._ui) 
    else -- 胜利的
        app.load("client.adventure.battle.AdventureBattleVictory")
        fwin:open(AdventureBattleVictory:new():init(), fwin._ui)
    end
end

function AdventureBattle:init()
    fwin:open(AdventureBattleMap:new():init(), fwin._background)
    fwin:open(AdventureBattleUI:new():init(), fwin._ui)
    fwin:open(AdventureBattleOpening:new():init(), fwin._view)
	return self
end

function AdventureBattle:onEnterTransitionFinish()
	
end

function AdventureBattle:onExit()
    state_machine.remove("adventure_battle_start_fight")
    state_machine.remove("fight_attack_logic_round_running_adventure")
    state_machine.remove("adventure_battle_update_ui_fight_round")
    state_machine.remove("adventure_battle_execute_skill_name_effect_over")
    state_machine.remove("adventure_battle_execute_attack")
    state_machine.remove("adventure_battle_execute_battle_over")
    state_machine.remove("adventure_battle_jump_fight")
end