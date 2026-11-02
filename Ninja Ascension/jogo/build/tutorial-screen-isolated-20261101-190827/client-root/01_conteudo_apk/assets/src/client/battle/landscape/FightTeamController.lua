
local kZOrderInFightScene_StanddyRole  = 0
local kZOrderInFightScene_MoveRole     = 10000 
local kZOrderInFightScene_Effect       = 2000000       
local kZOrderInFightScene_Hurt         = 3000000       
local kZOrderInFightScene_sp_effect    = 4000000

FightTeamController = class("FightTeamControllerClass", Window)

function FightTeamController:ctor()
    self.super:ctor()
    self.roots = {}
    self.csbs = {}
    self.actions = {}
    self.attackerList = {}
    self.hurtList = {}
    self.hero = nil
    self.fitRoles = {}
    self.hurtTimes = 0
    self.skillInfluenceElementData = nil
    self.zoarium_skill_list = {}
    self.currentCsbIndex = 0
    self.isBeginPlay = false
    self.isCalcSp = false

    local function init_fight_team_controller_terminal()
        local update_fight_team_controller_data_terminal = {
            _name = "update_fight_team_controller_data",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fight_ui_change_battle_heti_state", 0, true)
                fwin:find("FightQTEControllerClass"):setVisible(false)
                instance.hero = params[1]
                instance:updateMaster(params[2], params[3], params[4])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local update_fight_team_controller_skeep_terminal = {
            _name = "update_fight_team_controller_skeep",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:skeepTeamFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(update_fight_team_controller_data_terminal)
        state_machine.add(update_fight_team_controller_skeep_terminal)
        
        state_machine.init()
    end

    init_fight_team_controller_terminal()
    -- self:checkHetiSkillCsb()
    self:onInit()
end

function FightTeamController:init()
    self:setVisible(false)
    return self
end

function FightTeamController:skeepTeamFight( ... )
    if self.hurtTimes > 0 then
        for i=1,self.hurtTimes do
            self:beginHurt()
        end
    end
    self:teamFightEnd()
end

function FightTeamController:checkHetiSkillCsb( ... )
    local function checkIsHaveSkillCsb( csbName )
        for k,v in pairs(self.zoarium_skill_list) do
             if ""..v == ""..csbName then
                return true
            end
        end
        return false
    end
    for i=2,7 do
        local ship = fundShipWidthId(_ED.formetion[i])
        if ship ~= nil then
            local ship_template_id = tonumber(ship.ship_template_id)
            if ship_template_id > 0 then
                local prime_mover = dms.int(dms["ship_mould"], ship_template_id, ship_mould.prime_mover)
                if tonumber(prime_mover) ~= 0 and prime_mover ~= "" and tonumber(prime_mover) ~= -1 then
                    local hetiCsb = dms.int(dms["ship_mould"], ship_template_id, ship_mould.screen_attack_effect)
                    if checkIsHaveSkillCsb(hetiCsb) == false then
                        table.insert(self.zoarium_skill_list, hetiCsb)
                    end
                end
            end
        end
    end
end

function FightTeamController:onInit()
    self.zoarium_skill_list = state_machine.excute("fight_get_zoarium_skill_list", 0, nil)
    for k,v in pairs(self.zoarium_skill_list) do
        local csbName = string.format("battle/battle_map_heng_role_hetiji_%s.csb", v)
        local csbFightTeamController = csb.createNode(csbName)
        csbFightTeamController:setAnchorPoint(cc.p(0.5, 0))
        local root = csbFightTeamController:getChildByName("root")
        csbFightTeamController:setPosition(cc.p(csbFightTeamController:getContentSize().width/2 - app.baseOffsetX/2, 0))
        table.insert(self.roots, root)
        table.insert(self.csbs, csbFightTeamController)
        root:setVisible(false)
        self:addChild(csbFightTeamController)
        local action = csb.createTimeline(csbName)
        table.insert(self.actions, action)
        csbFightTeamController:runAction(action)
    
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end
            if self.isBeginPlay == false then
                return
            end
            local str = frame:getEvent()
            if str == "jiao_hurt" then
                -- state_machine.excute("fight_role_controller_startup_comkill_progress", 0, self.hero)
                local bear_sound_effect_id = dms.atoi(self.skillInfluenceElementData, skill_influence.bear_sound_effect_id)
                if bear_sound_effect_id >= 0 then
                    playEffectMusic(bear_sound_effect_id)
                end
            elseif str == "next" then
                -- state_machine.excute("fight_role_controller_change_to_next_attack_role", 0, self.hero)
            elseif str == "hurt" then
                self.hurtTimes = self.hurtTimes - 1
                for i,v in pairs(self.hurtList) do
                    if v ~= nil and v.armature ~= nil then
                        v.armature:getAnimation():playWithIndex(5, 5, 0)
                    end
                end
                self:beginHurt()
            elseif str == "khurt" then
                self.hurtTimes = self.hurtTimes - 1
                for i,v in pairs(self.hurtList) do
                    if v ~= nil and v.armature ~= nil then
                        v.armature:getAnimation():playWithIndex(7, 7, 0)
                    end
                end
                self:beginHurt()
                if self.hurtTimes < 1 then
                    -- 合体技能比较特殊，处理完合体相关的技能后，处理其他技能效用
                    for roleIndex, role in pairs(self.fitRoles) do
                        if role ~= nil and role.parent ~= nil and role.add_fight_data ~= nil then
                            local attackSection = dms.atoi(self.skillInfluenceElementData, skill_influence.attack_section) or 1
                            if attackSection < 0 then
                                attackSection = 1
                            end
                            -- print("天赋技能数量：", #role.add_fight_data)
                            for i, v in pairs(role.add_fight_data) do
                                if v ~= nil then
                                    local skf = v.__skf
                                    local skillInfluenceId = skf.skillInfluenceId
                                    local defenderListEx = v.__defenderList
                                    for w = 1, zstring.tonumber(skf.defenderCount) do
                                        local _def = skf._defenders[w]
                                        local defender = _def.defender
                                        local defenderPos = tonumber(_def.defenderPos)
                                        local byAttackTarget = defenderListEx[""..defender.."t"..defenderPos]
                                        if byAttackTarget ~= nil and byAttackTarget.parent ~= nil then
                                            -- print("合体技能时，处理其他技能效用 ", _def.defenderST, skillInfluenceId)
                                            self:drawDamageNumber(byAttackTarget, _def.stValue, attackSection, _def.stRound, false, 1, _def)
                                            if (byAttackTarget.roleWaitDeath == true or byAttackTarget.fight_over == true) and byAttackTarget.sendDeathNotice == false then
                                                byAttackTarget.sendDeathNotice = true
                                                state_machine.excute("fight_role_controller_notification_role_death_for_last_kill", 0, {byAttackTarget, true})
                                            end
                                        end
                                    end
                                end
                            end
                            role.add_fight_data = {}
                        end
                    end
                end
            elseif str == "khurtend" then
                for i,v in pairs(self.hurtList) do
                    if v ~= nil and v.armature ~= nil then
                        v.armature:getAnimation():playWithIndex(0, 0, 0)
                    end
                end
            elseif str == "end" then
                self:teamFightEnd()
            end
        end)
    end
end

function FightTeamController:teamFightEnd( ... )
    state_machine.excute("fight_ui_change_battle_heti_state", 0, false)
    fwin:find("FightQTEControllerClass"):setVisible(true) 
    if self.hero == nil then     
        return
    end
    for i, v in pairs(self.hurtList) do
        if v ~= nil and v.armature ~= nil then
            if self.hero.roleCamp == 1 then
                v.armature:setSpeedScale(1.0/__fight_recorder_action_time_speed)
                v.armature:setScaleX(1)
            end
            v.armature:retain()
            v.armature:removeFromParent()
        end
    end
    if animationMode == 1 then
        for i, v in pairs(self.attackerList) do
            if v ~= nil and v.armature ~= nil then
                if self.hero.roleCamp == 1 then
                    v.armature:setSpeedScale(1.0/__fight_recorder_action_time_speed)
                    v.armature:setScaleX(-1)
                end
                v.armature:retain()
                v.armature:removeFromParent()
            end
        end
    end
    local root = self.roots[self.currentCsbIndex]
    root:setVisible(false)
    self:setVisible(false)
    local hero = self.hero
    local attackerList = self.attackerList
    local hurtList = self.hurtList
    self.hurtList = {}
    self.attackerList = {}
    self.hero = nil
    self.hurtIndex = 0
    self.fitRoles = {}
    self.isBeginPlay = false
    self.isCalcSp = false
    state_machine.excute("fight_role_controller_end_hetiSkill", 0, {hero, attackerList, hurtList})
end

local function removeFrameObjectFuncN(sender)
    sender:removeFromParent(true)
end

function FightTeamController:onEnterTransitionFinish()

end

function FightTeamController:updateMaster(shipEffect, fitRoles, skillInfluenceElementData)
    self:setVisible(true)
    self.hurtList = {}
    self.attackerList = {}
    self.fitRoles = fitRoles
    local csbIndex = 1
    local attackSection = dms.atoi(skillInfluenceElementData, skill_influence.attack_section) or 1
    if attackSection < 0 then
        attackSection = 1
    end
    self.hurtTimes = attackSection

    for k,v in pairs(self.zoarium_skill_list) do
        if tonumber(v) == tonumber(shipEffect) then
            csbIndex = k
        end
    end
    self.currentCsbIndex = csbIndex
    local function checkHaveSameRole( role, hurtList )
        for i,v in pairs(hurtList) do
            if v ~= nil and v == role then
                return true
            end
        end 
        return false
    end

    for roleIndex, role in pairs(fitRoles) do
        if role ~= nil and role.parent ~= nil and role.fight_fit_cacher_pool ~= nil then
            role.add_fight_data = {}
            for fitIndex, fit in pairs(role.fight_fit_cacher_pool) do
                if fit ~= nil then
                    if fit.__isTalent == true then
                        table.insert(role.add_fight_data, fit)
                    else 
                        for w = 1, zstring.tonumber(fit.__skf.defenderCount) do
                            local _def = fit.__skf._defenders[w]
                            local defender = _def.defender
                            local defenderPos = tonumber(_def.defenderPos)
                            local byAttackTarget = fit.__defenderList[""..defender.."t"..defenderPos]
                            if byAttackTarget ~= nil and byAttackTarget.parent ~= nil then
                                if tonumber(byAttackTarget.roleCamp) ~= role.roleCamp and checkHaveSameRole(byAttackTarget, self.hurtList) == false then
                                    table.insert(self.hurtList, byAttackTarget)
                                end
                            end
                        end
                    end
                end
            end
        end
        if animationMode == 1 then
            if role ~= nil and role.parent ~= nil then
                if checkHaveSameRole(role, self.attackerList) == false then
                    table.insert(self.attackerList, role)
                end
            end
        end
    end

    state_machine.excute("fight_role_controller_begin_hetiSkill", 0 , self.hurtList)
    local root = self.roots[csbIndex]
    root:setVisible(true)
    for i, v in pairs(self.hurtList) do
        if v ~= nil and v.armature ~= nil then
            local pos = v._info._pos
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_role_1_"..pos)
            panel:removeAllChildren(true)
            panel:addChild(v.armature)
            v.armature:setSpeedScale(1)
            v.armature:release()
        end
    end

    if animationMode == 1 then
        app.load("client.battle.fight.FightEnum")
        state_machine.excute("fight_role_controller_begin_hetiSkill", 0 , self.attackerList)
        local attData = self.hero.current_fight_data.__attData
        local fits = {}
        if attData ~= nil then
            local skillMouldId = tonumber(attData.skillMouldId)
            local skillMouldData = dms.element(dms["skill_mould"], skillMouldId)
            fits = zstring.split(dms.atos(skillMouldData, skill_mould.release_mould), ",")
        end
        for i, v in pairs(fits) do
            local panel = ccui.Helper:seekWidgetByName(root, "juese_"..i)
            for k,m in pairs(self.attackerList) do
                local ntype = m._info._type
                local mouldId = m._info._mouldId
                if tonumber(ntype) == 0 then
                    local base_mould = dms.int(dms["ship_mould"], mouldId, ship_mould.base_mould)
                    if tonumber(base_mould) == tonumber(v) then
                        panel:addChild(m.armature)
                        m.armature:setSpeedScale(1)
                        m.armature:release()
                        m.armature._actionIndex = _enum_animation_l_frame_index.animation_fit_skill_attacking
                        m.armature._nextAction = 0
                        -- m.armature:playWithIndex(_enum_animation_l_frame_index.animation_fit_skill_attacking)
                        csb.animationChangeToAction(m.armature, m.armature._actionIndex, m.armature._actionIndex, false)
                    end
                elseif tonumber(ntype) == 1 then
                    local zoarium_skill = dms.int(dms["environment_ship"], mouldId, environment_ship.directing)
                    if tonumber(zoarium_skill) ~= 0 and zoarium_skill ~= "" and tonumber(zoarium_skill) ~= -1 then
                        local base_mould = dms.int(dms["ship_mould"], zoarium_skill, ship_mould.base_mould)
                        if tonumber(base_mould) == tonumber(v) then
                            panel:addChild(m.armature)
                            panel:setVisible(true)
                            m.armature:getAnimation():setSpeedScale(1)
                            m.armature:release()
                            m.armature._actionIndex = _enum_animation_l_frame_index.animation_fit_skill_attacking
                            m.armature._nextAction = 0
                            -- m.armature:playWithIndex(_enum_animation_l_frame_index.animation_fit_skill_attacking)
                            csb.animationChangeToAction(m.armature, m.armature._actionIndex, m.armature._actionIndex, false)
                        end
                    end
                end
            end
        end
    end

    self:updateHetiSKillState(csbIndex)

    local csbFightTeamController = self.csbs[self.currentCsbIndex]
    local action = self.actions[csbIndex]
    action:play("heti_0", false)
    self.isBeginPlay = true
    csbFightTeamController:setScaleX(1)
    if self.hero.roleCamp == 1 then
        csbFightTeamController:setScaleX(-1)
        for k,v in pairs(self.hurtList) do
            v.armature:setScaleX(-1)
        end
        for k,v in pairs(self.attackerList) do
            v.armature:setScaleX(1)
        end
    else
        csbFightTeamController:setScaleX(1)
    end

    self.skillInfluenceElementData = skillInfluenceElementData
    local posterior_lighting_sound_effect_id = dms.atoi(skillInfluenceElementData, skill_influence.posterior_lighting_sound_effect_id)
    if posterior_lighting_sound_effect_id >= 0 then
        playEffectMusic(posterior_lighting_sound_effect_id)
    end
end

function FightTeamController:beginHurt(  )
    local hurtIndex = 1
    local function printAttackData(role, _skf, _defenderList, isCalcSp)
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
            local byAttackTarget = _defenderList[""..defender.."t"..defenderPos]

            if byAttackTarget ~= nil and byAttackTarget.parent ~= nil then
                if byAttackTarget.current_fight_data == nil then
                    byAttackTarget.current_fight_data = {}
                end
                byAttackTarget.current_fight_data.__def = _def
                byAttackTarget.current_fight_data.__bySkf = _skf
                byAttackTarget.current_fight_data.__attackArmature = self.hero.armature

                -- local skillInfluenceElementData = byAttackTarget.armature._sie_action
                local attackSection = dms.atoi(self.skillInfluenceElementData, skill_influence.attack_section) or 1
                if attackSection < 0 then
                    attackSection = 1
                end

                if tonumber(defender) ~= tonumber(role.roleCamp) then
                    hurtIndex = 2
                    self:drawDamageNumber(byAttackTarget, stValue, attackSection, stRound, isCalcSp, hurtIndex)
                    hurtIndex = hurtIndex + 1
                end

                if tonumber(defender) == 1 and defenderST == "0" and isCalcSp == false then
                    BattleSceneClass.bossDamage = BattleSceneClass.bossDamage + tonumber(stValue)
                    state_machine.excute("fight_total_attack_damage", 0, {BattleSceneClass.bossDamage})
                end

            else
                _defenderList[""..defender.."t"..defenderPos] = nil
            end

            if _defenderList ~= nil then
                for i, v in pairs(_defenderList) do
                    if v.fitKiller ~= nil and v.fitKiller == role then
                        v.fitKiller = nil
                        v.roleWaitDeath = true
                    end
                    -- if v.parent ~= nil then
                    --     if v.roleCamp ~= role.roleCamp then
                    --         v.parent:stopAllActionsByTag(2)
                    --     end
                    --     v.attackerCount = v.attackerCount + 1
                    --     v.fly_index = 0
                    -- end
                    if v ~= role then
                        v.attacker = role
                        if v.roleCamp ~= role.roleCamp then
                            -- v.roleByAttacking = true
                            if v.parent ~= nil then
                                -- v:waitByAttack()
                            end
                        end
                        v._hurtCount = nil
                    end
                end
            end
        end
    end
    for roleIndex, role in pairs(self.fitRoles) do
        if role ~= nil and role.parent ~= nil and role.fight_fit_cacher_pool ~= nil then
            for fitIndex, fit in pairs(role.fight_fit_cacher_pool) do
                printAttackData(role, fit.__skf, fit.__defenderList, self.isCalcSp)
            end
        end
    end
    if self.skillInfluenceElementData ~= nil then
        local bear_sound_effect_id = dms.atoi(self.skillInfluenceElementData, skill_influence.bear_sound_effect_id)
        if bear_sound_effect_id >= 0 then
            playEffectMusic(bear_sound_effect_id)
        end
    end
    self.isCalcSp = true
end

function FightTeamController:updateHetiSKillStateEX( csbIndex )
    local root = self.roots[csbIndex]
    local diguangxiao = ccui.Helper:seekWidgetByName(root, "diguangxiao")
    local juese_1 = ccui.Helper:seekWidgetByName(root, "juese_1")
    local juese_2 = ccui.Helper:seekWidgetByName(root, "juese_2")
    local juese_3 = ccui.Helper:seekWidgetByName(root, "juese_3")
    local mingcheng = ccui.Helper:seekWidgetByName(root, "mingcheng")
    if diguangxiao ~= nil then
        diguangxiao:removeAllChildren(true)
        diguangxiao:setVisible(true)
    end
    juese_1:setVisible(true)
    juese_2:setVisible(true)
    local fileIndex = self.zoarium_skill_list[csbIndex]
    local jsonFile = string.format("effect/heti_%d/digaungxiao.json", fileIndex)
    local atlasFile = string.format("effect/heti_%d/digaungxiao.atlas", fileIndex)
    if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        sp.initArmature(animation, true)
        diguangxiao:addChild(animation)
        animation:setSpeedScale(1)
    end

    if juese_3 ~= nil then
        juese_3:setVisible(true)
    end
    -- if mingcheng ~= nil then
        local function executeEffectEndOver(armatureBack)
            if armatureBack ~= nil and armatureBack.getParent ~= nil then
                armatureBack:removeFromParent(true)
            end
        end
        mingcheng:setScaleX(1)
        mingcheng:setVisible(true)
        local animation = sp.spine("effect/effice_shifang.json", "effect/effice_shifang.atlas", 1, 0, "animation", true, nil)
        animation.animationNameList = effectAnimations
        sp.initArmature(animation, true)
        animation:setSpeedScale(1)
        animation._invoke = executeEffectEndOver
        animation:setMovementEventCallFunc(changeAction_animationEventCallFunc)
        animation:playWithIndex(0)
        mingcheng:addChild(animation)
        if self.hero.roleCamp == 1 then
            animation:setScaleX(-1)
            animation:setPositionX(app.screenSize.width / app.scaleFactor)
        else
            animation:setScaleX(1)
        end
    -- end
end

function FightTeamController:updateHetiSKillState( csbIndex )
    if animationMode == 1 then
        self:updateHetiSKillStateEX(csbIndex)
        return
    end
    local root = self.roots[csbIndex]
    local diguangxiao = ccui.Helper:seekWidgetByName(root, "diguangxiao")
    local ArmatureNode_3 = diguangxiao:getChildByName("ArmatureNode_3")
    local animation_3 = ArmatureNode_3:getAnimation()
    local guangxiao_1 = ccui.Helper:seekWidgetByName(root, "guangxiao_1")
    local ArmatureNode_4 = guangxiao_1:getChildByName("ArmatureNode_4")
    local animation_4 = ArmatureNode_4:getAnimation()
    local juese_1 = ccui.Helper:seekWidgetByName(root, "juese_1")
    local ArmatureNode_5 = juese_1:getChildByName("ArmatureNode_5")
    local animation_5 = ArmatureNode_5:getAnimation()
    local juese_2 = ccui.Helper:seekWidgetByName(root, "juese_2")
    local ArmatureNode_6 = juese_2:getChildByName("ArmatureNode_6")
    local animation_6 = ArmatureNode_6:getAnimation()
    local juese_3 = ccui.Helper:seekWidgetByName(root, "juese_3")
    diguangxiao:setVisible(true)
    guangxiao_1:setVisible(true)
    juese_1:setVisible(true)
    juese_2:setVisible(true)
    ArmatureNode_3:resume()
    ArmatureNode_4:resume()
    ArmatureNode_5:resume()
    ArmatureNode_6:resume()
    animation_3:playWithIndex(0, 0, 0)
    animation_4:playWithIndex(0, 0, 0)
    animation_5:playWithIndex(0, 0, 0)
    animation_6:playWithIndex(0, 0, 0)
    if juese_3 ~= nil then
        juese_3:setVisible(true)
        local ArmatureNode_7 = juese_3:getChildByName("ArmatureNode_7")
        local animation_7 = ArmatureNode_7:getAnimation()
        ArmatureNode_7:resume()
        animation_7:playWithIndex(0, 0, 0)
    end
end

function FightTeamController:drawDamageNumber(beHurtRole, stValue, attackSection, stRound, isCalcSp, hurtIndex, def)
    local _value = math.floor(zstring.tonumber(stValue) / attackSection)
    if _value < 1 then
        _value = 1
    end
    local drawString = "" .. _value
    local armatureBase = beHurtRole.armature
    local armature = beHurtRole
    local size = beHurtRole:getContentSize()
    local _def = beHurtRole.current_fight_data.__def
    if def ~= nil then
        _def = def
    end
    local defenderST = _def.defenderST
    local tempX, tempY  = beHurtRole:getPosition()
    local widgetSize = beHurtRole:getContentSize()
    local defState = _def.defState
    local root = self.roots[self.currentCsbIndex]

    if defenderST == "5" and tonumber(stValue) ~= 0 then
        if isCalcSp == false then
            beHurtRole.buffList[defenderST] = stRound
            beHurtRole.is_dizziness = true
        end
    end
    
    armature._hurtCount = armature._hurtCount == nil and 0 or armature._hurtCount

    if defenderST == "0" or defenderST == "6" or defenderST == "9" or defenderST == "35" then
        if tonumber(drawString) > 0 then
            drawString = "-"..(zstring.tonumber(drawString) or 0)
        end
    elseif defenderST == "1" or defenderST == "31" then
        drawString = "+"..(zstring.tonumber(drawString) or 0)
    end
    
    if isCalcSp == false and (defenderST == "2" or defenderST == "3") and (armatureBase~= nil and armatureBase._role ~= nil) then
        armatureBase._role._sp = armatureBase._role._sp + ((defenderST == "2" and 1 or -1) * tonumber(stValue))
        if armatureBase._role._sp < 0 then
            armatureBase._role._sp = 0
        end
        armatureBase._heroInfoWidget:showRoleSP()
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = armatureBase._self._qte, status = "update"})
    end
    
    -- 增加相克状态
    -- local restrainState = _def.restrainState --npos(list) 相克状态(0,无克制 1,有克制,2被克制)
    -- if restrainState == "1" and armature._hurtCount == 0 then
    --     local armatureEffect = beHurtRole:createEffectCoverSkill(beHurtRole, 999, zstring.tonumber(armature._camp))
    --     armatureEffect._invoke = deleteEffectFile
    -- end
    
    local numberFilePath = nil
    -- 0:命中 1:闪避 2:暴击 3:格挡 4:暴击加挡格
    if defState == "0" or defState == "3" then
        if defenderST == "6" or
            defenderST == "9" or
            defenderST == "12" or
            defenderST == "23" or
            defenderST == "26" then
            if isCalcSp == false then
                beHurtRole.buffList[defenderST] = stRound
            end
        end
        -- 命中
        if defenderST == "1" or defenderST == "31" then
            if armatureBase._role._hp ~= nil and drawString ~= nil and drawString ~= "" and 
                (_def.stVisible ~= "1" or (_def.stVisible == "1" and defenderST == "1")) then
                numberFilePath = "images/ui/number/jiaxue.png"
            end
            armatureBase._role._hp = zstring.tonumber(armatureBase._role._hp) + zstring.tonumber(drawString)
            self:showRoleHP(armatureBase)
            -- state_machine.excute("fight_role_controller_update_hp_progress", 0, {beHurtRole.roleCamp, zstring.tonumber(drawString)})
        elseif defenderST == "2" 
            or defenderST == "3" 
            or defenderST == "4" 
            or defenderST == "5" 
            or defenderST == "7" 
            or defenderST == "8" 
            or defenderST == "10" 
            or defenderST == "11" 
            or defenderST == "12" 
            or defenderST == "13" 
            or defenderST == "14" 
            or defenderST == "15"
            or defenderST == "32"
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
            then
            if isCalcSp == false then
                local miss = cc.Sprite:createWithSpriteFrameName("images/ui/battle/".._battle_buff_effect_dictionary[zstring.tonumber(defenderST) + 1]..".png")
                miss:setAnchorPoint(cc.p(0.5, 0.5))
                local map = armatureBase:getParent():getParent()
                miss:setPosition(cc.p(map:getPositionX(), map:getPositionY() + size.height/4))
                root:addChild(miss, kZOrderInFightScene_Hurt)
                miss:setScale(1.2)
                if self.hero.roleCamp == 1 then
                    miss:setScaleX(-1)
                end
                local seq = cc.Sequence:create(
                    cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
                    cc.CallFunc:create(removeFrameObjectFuncN)
                )
                miss:runAction(seq)
            end
        else
            numberFilePath = "images/ui/number/xue.png"
            armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
            self:showRoleHP(armatureBase)

            -- state_machine.excute("fight_role_controller_update_hp_progress", 0, {beHurtRole.roleCamp, tonumber(drawString)})
            -- 绘制连击伤害
            if defenderST == "0" then
                state_machine.excute("draw_hit_damage_draw_hit_count", 0, {1, 0})
                state_machine.excute("draw_hit_damage_draw_hit_damage", 0, {math.abs(tonumber(drawString)), 0})
            end
        end
    elseif defState == "1" then
        if defenderST == "0" then
            -- 闪避
            if isCalcSp == false then
                local miss = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shanbi.png")
                miss:setAnchorPoint(cc.p(0.5, 0.5))
                local map = armatureBase:getParent():getParent()
                miss:setPosition(cc.p(map:getPositionX(), map:getPositionY() + size.height/4)) 
                root:addChild(miss, kZOrderInFightScene_Hurt)
                miss:setScale(1.2)
                if self.hero.roleCamp == 1 then
                    miss:setScaleX(-1)
                end
                local seq = cc.Sequence:create(
                    cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, 100 / CC_CONTENT_SCALE_FACTOR())),
                    cc.CallFunc:create(removeFrameObjectFuncN)
                )
                miss:runAction(seq)
            end
        end
    elseif defState == "2" or defState == "4" then
        if armature._hnb ~= true then
            if defenderST == "1" then
                numberFilePath = "images/ui/number/baoji.png"
            else
                numberFilePath = "images/ui/number/baoji.png"
            end
            --armature._hnb = true
            armatureBase._role._hp = armatureBase._role._hp + tonumber(drawString)
            self:showRoleHP(armatureBase)

            -- state_machine.excute("fight_role_controller_update_hp_progress", 0, {beHurtRole.roleCamp, tonumber(drawString)})
            -- 绘制连击伤害
            if defenderST == "0" then
                state_machine.excute("draw_hit_damage_draw_hit_count", 0, {1, 0})
                state_machine.excute("draw_hit_damage_draw_hit_damage", 0, {math.abs(tonumber(drawString)), 0})
            end
        end
    elseif defState == "3" then
    end
    
    if defenderST == "2" or defenderST == "3" then
        if _def.stVisible == "1" and defState ~= "1" and defState ~= "5" and isCalcSp == false then
            -- print("合体技能：：怒气动画", defenderST == "2" and "1" or "-1")
            local spSprite = cc.Sprite:createWithSpriteFrameName(string.format("images/ui/battle/%s.png", defenderST == "2" and "nuqijia" or "nuqijian"))
            spSprite:setAnchorPoint(cc.p(0.5, 0.5))
            local map = armatureBase:getParent():getParent()
            spSprite:setPosition(cc.p(map:getPositionX(), map:getPositionY() + size.height/4)) 
            root:addChild(spSprite, kZOrderInFightScene_Hurt)
            spSprite:setScale(1.2)
            if self.hero.roleCamp == 1 then
                spSprite:setScaleX(-1)
            end
            local seq = cc.Sequence:create(
                cc.MoveBy:create(1.2 * __fight_recorder_action_time_speed, cc.p(0, (defenderST == "2" and 1 or -1) * 100 / CC_CONTENT_SCALE_FACTOR())),
                cc.CallFunc:create(removeFrameObjectFuncN)
            )
            spSprite:runAction(seq)
        end
    end
    
    local labelAtlas = nil
    if numberFilePath ~= nil and drawString ~= nil then
        local isHaveCrit = false
        if defState == "2" or defState == "4" then
            isHaveCrit = true
        end
        -- local map = armatureBase:getParent()
        -- local tempDrawX = armatureBase:getPositionX()
        -- local tempDrawY = armatureBase:getPositionY() + size.height
        -- beHurtRole:drawAntNumber(map, drawString, numberFilePath, tempDrawX, tempDrawY, size, armature._hurtCount, isHaveCrit, self.hero.roleCamp == 1)
        local tempDrawX = armatureBase:getParent():getParent():getPositionX() + (hurtIndex - 2) * 80
        local tempDrawY = armatureBase:getParent():getParent():getPositionY() + size.height/2 + (hurtIndex - 2) * 45
        beHurtRole:drawAntNumber(root, drawString, numberFilePath, tempDrawX, tempDrawY, size, armature._hurtCount, isHaveCrit, self.hero.roleCamp == 1)
    end
    
    if defenderST == "0" then
        armature._hurtCount = armature._hurtCount + 1
    end
end

function FightTeamController:showRoleHP(armature)
    if armature ~= nil then
        armature._role._hp = armature._role._hp < 0 and 0 or armature._role._hp
        local percent = armature._role._hp/armature._brole._hp * 100
        percent = percent > 100 and 100 or percent
        
        armature._heroInfoWidget:showRoleHP()

        state_machine.excute("fight_role_controller_update_hp_progress", 0, nil)
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = armature._self._qte, status = "update"})
        
        if armature._role._hp == 0 then
            local function heroDeathFunc()
                armature._heroInfoWidget:controlLife(false, 9)
                armature._heroInfoWidget:showControl(false)
                armature._heroInfoWidget:controlLife(true, 9)
            end
            armature._heroInfoWidget:controlLife(false, 9)
            armature._heroInfoWidget:showControl(true)
            armature._heroInfoWidget:controlLife(true, 9)
            armature._heroInfoWidget:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(heroDeathFunc)))
        else
            armature._heroInfoWidget:controlLife(false, 8)
            armature._heroInfoWidget:keepShow(1.0)
        end 
    end
end

function FightTeamController:onExit()
    state_machine.remove("update_fight_team_controller_data")
    state_machine.remove("update_fight_team_controller_skeep")
end
