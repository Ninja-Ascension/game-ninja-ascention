local is2006 = false
local is2005 = false
if __lua_project_id == __lua_project_warship_girl_a 
or __lua_project_id == __lua_project_warship_girl_b 
or __lua_project_id == __lua_project_koone 
then
    if dev_version >= 2006 then
        is2006 = true
    elseif dev_version >= 2005 then
        is2005 = true
    end
end

Hero = class("HeroClass", Window)
function Hero:ctor()
    self.super:ctor()
    self.roots = {}
    self.buffs = {}
    self.actionTimeSpeed = 1.0

    self._info = {}
    self._fightMap = nil 
    self._parentName = nil
    self._flyingParentName = nil
    self._nextGoFightParentName = nil

    self._flying = true

    self._flyingParent = nil
    self._fightParent = nil
    self._currentParent = nil
    self._nextGoFightParent = nil
    self._armatureAnger = nil

    self._ready = false

    self._armature = nil

    self._spArmature = nil
    self._playPetArmature = false  --是否播放过了宠物加成效果

    self._add_track = false
    self._interval = 0
    self._duration = 0.1

    app.load("client.battle.fight.HeroInfoUI")
    
    -- Initialize hero page state machine.
    local function init_hero_terminal()
        -- 入场完毕，准备进入战斗状态
        local hero_ready_to_fight_state_terminal = {
            _name = "hero_ready_to_fight_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local  hero = params
                if hero ~= nil and hero.readyToFight ~= nil then
                    hero:readyToFight()
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重新进入战斗状态
        local hero_reset_to_fight_state_terminal = {
            _name = "hero_reset_to_fight_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local  hero = params
                hero:resetToFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 添加Buff
        local hero_add_buff_state_terminal = {
            _name = "hero_add_buff_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local buffType = ""..zstring.tonumber(params.buffType)
                local roundCount = zstring.tonumber(params.roundCount)
                instance.addBuff(buffType)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示怒气特效
        local hero_show_anger_buff_state_terminal = {
            _name = "hero_show_anger_buff_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showAngerEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示怒气特效
        local hero_change_sp_armature_state_terminal = {
            _name = "hero_change_sp_armature_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeHeroSpArmatureState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 创建兵种行步的痕迹
        local hero_create_animation_move_track_terminal = {
            _name = "hero_create_animation_move_track",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:createArmatureMoveTrack(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 停止创建兵种行步的痕迹
        local hero_stop_animation_move_track_terminal = {
            _name = "hero_stop_animation_move_track",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:stopArmatureMoveTrack(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(hero_ready_to_fight_state_terminal)
        state_machine.add(hero_reset_to_fight_state_terminal)
        state_machine.add(hero_add_buff_state_terminal)
        state_machine.add(hero_show_anger_buff_state_terminal)
        if __lua_project_id == __lua_project_yugioh
            then
            state_machine.add(hero_change_sp_armature_state_terminal)
        end
        state_machine.add(hero_create_animation_move_track_terminal)
        state_machine.add(hero_stop_animation_move_track_terminal)
        state_machine.init()
    end

    -- call func init hero state machine.
    init_hero_terminal()
end

function Hero:init(_info, _fightMap, _parentName, _flyingParentName, _nextGoFightParentName,_fight_type)
    self._info = _info
    self._fightMap = _fightMap 
    self._parentName = _parentName
    self._nextGoFightParentName = _nextGoFightParentName
    if _flyingParentName == nil or _flyingParentName == "" then
        self._flying = false
    end
    self._flyingParentName = _flyingParentName

    local camp_preference = 0
    if self._info._type == "1" then
        camp_preference = dms.int(dms["environment_ship"], self._info._mouldId, environment_ship.camp_preference)
    else
        camp_preference = dms.int(dms["ship_mould"], self._info._mouldId, ship_mould.camp_preference)
    end

    self._camp_preference = camp_preference

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        self._fightParent = self._fightMap:rootAtIndex(1):getChildByName(self._parentName)
        self._currentParent = self._fightParent
    else
        self._fightParent = ccui.Helper:seekWidgetByName(self._fightMap:rootAtIndex(1), self._parentName)
    end
    if self._flying == true then
        self._flyingParent = ccui.Helper:seekWidgetByName(self._fightMap:rootAtIndex(1), self._flyingParentName)
        self._currentParent = self._flyingParent
    else
        self._currentParent = self._fightParent
    end
    if nil ~= self._nextGoFightParentName then
        self._nextGoFightParent = ccui.Helper:seekWidgetByName(self._fightMap:rootAtIndex(1), self._nextGoFightParentName)
        self:registerOnNodeEvent(self)
    end

    self._currentParent:addChild(self)

    if __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        then
        if self._flyingParentName ~= nil then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_62.ExportJson")
            self._armatureAnger = ccs.Armature:create("effice_62")
            self._armatureAnger:getAnimation():playWithIndex(0)
            self._armatureAnger:setPosition(self._nextGoFightParent:getContentSize().width/2,self._nextGoFightParent:getContentSize().height/2)
            self._armatureAnger:setName("angerEffect")
            self._armatureAnger:setVisible(false)
            self:addChild(self._armatureAnger)
        end
    end
    self._currentParent._scale = self._currentParent:getScale()

    self._fight_type = _fight_type
    
    self._camp = "0"
    self._pos = self._info._pos
    self._fightParent._camp = "0"
    self._fightParent._pos = self._info._pos

    self._fightParent._screenPositionX = self._fightParent:getPositionX()
    self._fightParent._screenPositionY = self._fightParent:getPositionY()
    -- local role = cc.Sprite:create("images/face/card_head/card_head_1.png")
    -- -- role:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
    -- role:setAnchorPoint(cc.p(0, 0))
    -- self:addChild(role, 10000)

    --> print("hero datas:", _info, _fightMap, _parentName, _flyingParentName, self._flying)
    return self
end

function Hero:changeHeroSpArmatureState( state )
    if self._spArmature ~= nil then
        self._spArmature:setVisible(state)
        if self._armature ~= nil then
            self._armature:setVisible(not state)
        end
    end
end

function Hero:createArmatureMoveTrack( params, marmature)
    local effectName = "effice_track_1001"
    if self._camp_preference == 2 then
        effectName = "effice_track_1101"
    else
        effectName = "effice_track_1001"
    end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/" .. effectName .. ".ExportJson")
    local armature = ccs.Armature:create(effectName)
    armature:getAnimation():playWithIndex(animation_standby)
    -- armature:setPosition(cc.p(self._currentParent:getContentSize().width/2, self._currentParent:getContentSize().height/2))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
    
    armature._actionIndex = animation_standby
    armature._nextAction = animation_standby

    armature._invoke = battle_execute._deleteEffectFile

    local px, py = self._currentParent:getPosition()
    local cx, cy = self:getPosition()

    if nil ~= marmature then
        local mx, my = marmature:getPosition()
        cx = cx + mx
        cy = cy + my
    end

    armature:setPosition(cc.p(px + cx, py + cy))
    self._currentParent:getParent():addChild(armature)

    self._add_track = true
end

function Hero:stopArmatureMoveTrack( params )
    self._add_track = false
end

function Hero:findBuff(_buffType)
    local buff = nil
    local index = "0"
    for i, v in pairs(self.buffs) do
        if i == _buffType then
            buff = v
        end
    end
    return buff
end

function Hero:addBuff(_buffType, _roundCount)
    local tempBuff = self:findBuff(_buffType)

    if tempBuff ~= nil then
        state_machine.excute("buff_effect_update", 0, {buffType = _buffType, buff = tempBuff, roundCount = _roundCount})
    else

    end
end

function Hero:showAngerEffect(isShow)
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        then
        if self._armatureAnger ~= nil and self._flyingParentName ~= nil and self._nextGoFightParent ~= nil then 
            self._armatureAnger:setVisible(isShow)
        end
    end
end

function Hero:cleanBuff(_buffType)
    local buff = self:findBuff(_buffType)

    if buff ~= nil then
        state_machine.excute("buff_effect_clean", 0, buff)
    end
end

function Hero:resetHeroInfo()
    local armature = self._armature
    armature._role = {}
    armature._role._id = self._info._id
    armature._role._hp = self._info._hp
    armature._role._sp = self._info._sp
    armature._role._quality = self._info._quality

    self._armature._invoke = nil
    armature._actionIndex = _enum_animation_frame_index.animation_move
    armature._nextAction = _enum_animation_frame_index.animation_moving
    armature:getAnimation():playWithIndex(_enum_animation_frame_index.animation_move)
    
    -- 准备去下一场战斗
    local function readyNextFightMoveOverFuncN(sender)
        self:retain()
        self:removeFromParent(false)
        self._nextGoFightParent:addChild(self)
        self:release()

        state_machine.excute("fight_hero_ready_next_fight_over", 0, 0)
    end
    local array = {}
    -- table.insert(array, cc.MoveTo:create(1 * __fight_recorder_action_time_speed, cc.p(self._fightParent._screenPositionX, self._fightParent._screenPositionY)))
    table.insert(array, cc.CallFunc:create(readyNextFightMoveOverFuncN))
    local seq = cc.Sequence:create(array)
    self._fightParent:runAction(seq)
    
    if __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_koone 
        then
        armature._heroInfoWidget:controlLife(false, 99)
        armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
        armature._heroInfoWidget:showRoleHP()
        armature._heroInfoWidget:showRoleSP()
    end
end

function Hero:resetToFight()
    local function resetOver_changeActionCallback(armatureBack)
        local armature = armatureBack
        --> print("---------", armature._actionIndex)
        if armature ~= nil then
            local actionIndex = armature._actionIndex
            if actionIndex == _enum_animation_frame_index.animation_moving then
                armature._nextAction = _enum_animation_frame_index.animation_move_end
            elseif actionIndex == _enum_animation_frame_index.animation_move_end then
                armature._nextAction = _enum_animation_frame_index.animation_standby
            elseif actionIndex == _enum_animation_frame_index.animation_standby then
                armature._invoke = nil
                -- 适配坐标
                local function readyNextFightMoveOverFuncN2(sender)
                    -- print("适配坐标结束，我方英雄准备结束。")
                    self:retain()
                    self:removeFromParent(false)
                    self._fightParent:addChild(self)
                    self:changeHeroSpArmatureState(true)
                    self:release()
                    state_machine.excute("fight_hero_fight_reset_over", 0, 0)
                end
                local array = {}
                if math.abs(app.baseOffsetY) > 1 then
                end
                -- table.insert(array, cc.MoveTo:create(0.5 * __fight_recorder_action_time_speed, cc.p(self._fightParent._screenPositionX, 0.1+self._fightParent._screenPositionY + app.baseOffsetY/2)))
                table.insert(array, cc.CallFunc:create(readyNextFightMoveOverFuncN2))
                local seq = cc.Sequence:create(array)
                self._fightParent:runAction(seq)
                
            end
        end
    end
    self._armature._invoke = resetOver_changeActionCallback
end

function Hero:readyToFight()
    self._fightParent:setPositionY(self._fightParent._screenPositionY + app.baseOffsetY/2)
    local currentPosition = cc.p(self:getPosition())
    local currentParentPosition = cc.p(self._currentParent:getPosition())
    local currentParentContentSize = self._currentParent:getContentSize()
    local currentParentCenter = cc.p(currentParentContentSize.width / 2, currentParentContentSize.height / 2)
    local currentParentScale = self._currentParent._scale
    local nextParentPosition = cc.p(self._fightParent:getPosition())
    local nextParentContentSize = self._fightParent:getContentSize()
    local nextParentCenter = cc.p(nextParentContentSize.width / 2, nextParentContentSize.height / 2)
    local nextParentScale = self._fightParent:getScale()

    local movePosition = cc.p(currentParentPosition.x + currentParentCenter.x * currentParentScale, currentParentPosition.y + currentParentCenter.y * currentParentScale)
    local targetPosition = cc.p(nextParentPosition.x + nextParentCenter.x * nextParentScale, nextParentPosition.y + nextParentCenter.y * nextParentScale)
    self:setPosition(movePosition)
    self._stopPosition = nextParentCenter

    self:retain()
    self:removeFromParent(false)
    local parentRoot = self._fightParent:getParent()
    self:setScale(currentParentScale)
    --> print("currentParentScale:", currentParentScale)
    --> print("nextParentScale:", nextParentScale)
    parentRoot:addChild(self)
    self:release()
    
    
    if true == is2005 then
        -- 去掉划水,直接定位到战斗位置
        self:setPosition(cc.p(self._stopPosition.x, self._stopPosition.y))
        self:runAction(cc.ScaleTo:create(0.5, nextParentScale))
    
        self:retain()
        self:removeFromParent(false)
        self._fightParent:addChild(self)
        self._currentParent = self._fightParent
        self:setPosition(cc.p(self._stopPosition.x, self._stopPosition.y))
        self:stopAllActions()
        self:setScale(1.0)
        self:release()
        self._ready = true
        self._armature._invoke = nil
        if self._fight_type  == _enum_fight_type._fight_type_104 then
            -- 创建 提升小动画 添加进来
            self:showPromoteAnimation()
        else
            state_machine.excute("fight_hero_fight_ready_over", 0, 0)
        end
    else
        local function readyOver_changeActionCallback(armatureBack)
            local armature = armatureBack
            --> print("---------", armature._actionIndex)
            if armature ~= nil then
                local actionIndex = armature._actionIndex
                if actionIndex == _enum_animation_frame_index.animation_moving then
                    armature._nextAction = _enum_animation_frame_index.animation_move_end
                elseif actionIndex == _enum_animation_frame_index.animation_move_end then
                    armature._nextAction = _enum_animation_frame_index.animation_standby
                elseif actionIndex == _enum_animation_frame_index.animation_standby then
                    armature._invoke = nil
                    if __lua_project_id == __lua_project_yugioh 
                        or __lua_project_id == __lua_project_pokemon 
                        then
                        if self._armature._isShow == false then
                        else
                            self:changeHeroSpArmatureState(true)
                        end
                    end
                    if self._fight_type  == _enum_fight_type._fight_type_104 then
                        -- 通知 外层 提示突破 
                        --state_machine.excute("fight_hero_fight_ready_over", 0, 0)
                        
                        -- 创建 提升小动画 添加进来
                        self:showPromoteAnimation()
                    else
                        state_machine.excute("fight_hero_fight_ready_over", 0, 0)
                    end
                end
            end
        end

        local function moveOverFuncN(sender)
            self:retain()
            self:removeFromParent(false)
            self._fightParent:addChild(self)
            self._currentParent = self._fightParent
            self:setPosition(cc.p(self._stopPosition.x, self._stopPosition.y))
            self:stopAllActions()
            self:setScale(1.0)
            self:release()
            self._ready = true

            self._armature._invoke = readyOver_changeActionCallback
        end
        local array = {}
        if math.abs(app.baseOffsetY) > 1 then
            
        end
        if __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
            or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_yugioh 
            then 
            self:setPosition(cc.p(self._stopPosition.x, self._stopPosition.y))
            self:setScale(nextParentScale)
            moveOverFuncN()
        else
            table.insert(array, cc.MoveTo:create(0.5, cc.p(targetPosition.x, 0.1+targetPosition.y)))
            table.insert(array, cc.CallFunc:create(moveOverFuncN))
            local seq = cc.Sequence:create(array)
            self:runAction(seq)
            self:runAction(cc.ScaleTo:create(0.5, nextParentScale))
        end
        
    end
end

-- 显示 突破提升动画(叛军时需要)
function Hero:showPromoteAnimation()
    -- 获取 所选的加成模式
    local multiple = {1,2.5}
    local index = tonumber(_ED.worldboss.selectIndex)
    if nil ~= index then
        -- 获取突破等级
        local ship = getPlayerShip(self._info._id)
        local hero_data = dms.element(dms["ship_mould"], self._info._mouldId)
        local rankLevelFront = dms.atoi(hero_data, ship_mould.initial_rank_level) + 1

        app.load("client.campaign.worldboss.WorldbossBattleTipNumber")
        
        local num = WorldbossBattleTipNumber:createCell()

        num:init(self._info._id, rankLevelFront, rankLevelFront * multiple[index], index)
        self:addChild(num)
    end
end

-- 宠物加层
function Hero:showPetAddAnimation()

    --ship_moudl 61 --- pet_mould 4  ----  pet_train--2-  --当前阶级 ---
    local pet_id = dms.int(dms["ship_mould"], _ED.user_ship["".._ED.formation_pet_id].ship_template_id, ship_mould.base_mould2)
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
    local pet_formations = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
    local level = zstring.tonumber(_ED.user_ship["".._ED.formation_pet_id].train_level)
    if pet_formations ~= nil then 
        --有阵型加成
        local addFormation = nil
        for k,v in pairs(pet_formations) do
            if level == zstring.tonumber(v[3]) then 
                addFormation = v
                break
            end
        end
        if addFormation == nil then 
            return
        end
        local pos = zstring.tonumber(self._pos)
        if pos ~= 102 then 
            local attribute = addFormation[5+pos]
            local lenghtAdd = string.len(attribute)
            if lenghtAdd > 2 then 
                --有属性，
                app.load("client.packs.pet.PetBattleTipNumber")
                self._playPetArmature = true
                local info = zstring.split("".. attribute,"|")
                local num = PetBattleTipNumber:createCell()
                if info ~= nil and #info == 2 then 
                    -- 两种属性必然为防御 物理防御，法术防御
                    local value = zstring.split("".. info[1],",")[2]
                    num:init(39,value,0)
                    self:addChild(num)
                end
                if info ~= nil and #info == 1 then 
                    --一种属性
                    local addAttribute = zstring.split("".. info[1],",")
                    num:init(addAttribute[1],addAttribute[2],0)
                    self:addChild(num)
                end
            end
        end
    end
end

function Hero:createWeaponArmature(armature_name)
    local armature = nil
    if __lua_project_id == __lua_project_pacific_rim then
        local sprite = sp.spine("sprite/"..armature_name .. ".json", "sprite/"..armature_name .. ".atlas", 1, 0, _spine_sprite_animation_names[1], true, nil)
        sprite:addAnimation(0, _spine_sprite_animation_names[2], true)

        -- spine动画初始化
        sp.initArmature(sprite, true)

        sprite.animationNameList = _spine_sprite_animation_names

        armature = sprite
    else
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/"..armature_name..".ExportJson")
        armature = ccs.Armature:create(armature_name)
    end
    armature:getAnimation():playWithIndex(_enum_animation_frame_index.animation_standby)
    -- armature:setPosition(cc.p(self._currentParent:getContentSize().width/2, self._currentParent:getContentSize().height/2))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)
    
    armature._actionIndex = animation_standby
    armature._nextAction = animation_standby

    -- armature._invoke = battle_execute._attackChangeActionCallback
    return armature
end

function Hero:createChildHero(index, armatureName, rootArmature)
    local armature = ccs.Armature:create(armatureName)
    armature._actionIndex = animation_moving
    armature._nextAction = animation_moving
    armature:getAnimation():playWithIndex(animation_moving)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature:setPosition(__metris_pos_o[index])
    self:addChild(armature, index)
    armature._child_tag = index
    rootArmature._child_list = rootArmature._child_list or {}
    table.insert(rootArmature._child_list, armature)
    
    -- armature._invoke = battle_execute._attackChangeActionCallback

    armature:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), 
        cc.MoveTo:create(1.5, __metris_pos_m[index]),
        cc.CallFunc:create(function ( sender )
            --> print(sender._nextAction, sender._actionIndex)
            if sender._nextAction == animation_moving then
                sender._nextAction = animation_standby
            end
        end)))
    return armature
end

function Hero:onUpdate(dt)
    if self._add_track == true then
        self._interval = self._interval + dt
        if self._interval >= self._duration then
            self._interval = 0
            local oy = self:getPositionY() + self._currentParent:getPositionY()
            if math.abs(oy - self._track_y) >= 20 then
                self._track_y = oy
                if self._camp_preference == 2 then
                    self:createArmatureMoveTrack(nil, self._armature)
                    for i, v in pairs(self._armature._child_list) do
                        self:createArmatureMoveTrack(nil, v)
                    end
                else
                    self:createArmatureMoveTrack()
                end
            end
        end
    end
end

-- 绘制属性提升动画
function Hero:drawPropertyAddEffect()
    if self._info._general_mould_id <= 0 then
        return
    end
    local sprite = cc.Sprite:createWithSpriteFrameName("images/ui/battle/shuxintisheng.png")
    sprite:setOpacity(0)

    local forwardIn = cc.FadeTo:create(1.2, 255)
    local backIn = cc.FadeTo:create(1.2, 0)
    local actionIn = cc.Sequence:create(cc.DelayTime:create(1.5), forwardIn, cc.DelayTime:create(0.03), backIn, cc.CallFunc:create(function ( sender )
        -- sender:removeFromParent(true)
    end))
    sprite:runAction(actionIn)

    local actionMoveTo = cc.Sequence:create(cc.DelayTime:create(1.5), cc.MoveTo:create(3.0, cc.p(0, 100)), cc.CallFunc:create(function ( sender )
        sender:removeFromParent(true)
    end))
    sprite:runAction(actionMoveTo)

    self:addChild(sprite, 100)
end

function Hero:onEnterTransitionFinish()
    if self._armature ~= nil or self._info == nil or self._info._head == nil then
        return
    end

    local size = self._currentParent:getContentSize()
    self:setContentSize(cc.size(size.width, size.height))
    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setPosition(cc.p(size.width/2, size.height/2))
    -- self:removeBackGroundImage()
    -- self:setBackGroundImage("images/face/card_head/card_head_1.png")

    -- armature table : {_actionIndex=0, _nextAction=0, _changing=false, _nextFunc = nil, _invoke = nil}
    local movementIndex = 0
    if zstring.tonumber(self._info._pos) == 101 or zstring.tonumber(self._info._pos) == 102 then
    else
        movementIndex = dms.int(dms["ship_mould"], self._info._mouldId, ship_mould.movement)
    end
    if __lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_rouge 
        then
        if dms.int(dms["ship_mould"], tonumber(self._info._mouldId), ship_mould.captain_type) == 0 then
            local fashionEquip, pic = getUserFashion()
            if fashionEquip ~= nil and pic ~= nil then
                movementIndex = 0
            end
        end
    end
    
    local armatureName = "spirte_battle_card"
    
    if __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        then
    else
        if movementIndex ~= nil and movementIndex > 0 and zstring.tonumber(self._info._pos) ~= 102 then
            armatureName = armatureName .."_".. movementIndex
        end
    end
    local armature = nil
    if __lua_project_id == __lua_project_pacific_rim then
        local sprite = sp.spine("sprite/"..armatureName .. ".json", "sprite/"..armatureName .. ".atlas", 1, 0, _spine_sprite_animation_names[1], true, nil)
        sprite:addAnimation(0, _spine_sprite_animation_names[2], true)

        -- spine动画初始化
        sp.initArmature(sprite, true)

        sprite.animationNameList = _spine_sprite_animation_names

        armature = sprite
    else
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/"..armatureName..".ExportJson")
        armature = ccs.Armature:create(armatureName)
    end
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        -- armature.actionIndex = _enum_animation_frame_index.animation_standby
        -- if true == is2005 then
        --     armature._nextAction = _enum_animation_frame_index.animation_standby
        -- else
        --     armature._nextAction = _enum_animation_frame_index.animation_standby
        -- end
       
        -- armature:getAnimation():playWithIndex(_enum_animation_frame_index.animation_standby)

        armature._actionIndex = animation_moving
        
        armature._nextAction = animation_moving
       
        armature:getAnimation():playWithIndex(animation_moving)

        armature:setPosition(cc.p(size.width/2, size.height/2))

        if __lua_project_id == __lua_project_pacific_rim then
            self:setPosition(cc.p(-380, -380))
        else
            self:setPosition(cc.p(0, -300))
        end
        
        self._add_track = true

        -- 入场动画
        if self._camp_preference == 2 then
            local joinAction = cc.Sequence:create(cc.MoveTo:create(2.0, cc.p(0, 0)), cc.CallFunc:create(function( sender)
                --> print(sender._armature._nextAction, sender._armature._actionIndex, _enum_animation_frame_index.animation_moving)
                if sender._armature._nextAction == _enum_animation_frame_index.animation_moving then
                    sender._armature._nextAction = _enum_animation_frame_index.animation_standby
                end
                self._join_action = nil
            end))
            self:runAction(joinAction)
            self._join_action = joinAction
        else
            if __lua_project_id == __lua_project_pacific_rim then
                local joinAction = cc.Sequence:create(cc.MoveTo:create(2, cc.p(0, 0)), cc.CallFunc:create(function( sender)
                    sender._armature._nextAction = _enum_animation_frame_index.animation_standby
                    if __lua_project_id == __lua_project_pacific_rim then
                        if nil ~= sender._armature._weapon then
                            sender._armature._weapon._nextAction = _enum_animation_frame_index.animation_standby
                            -- sender._armature._weapon:getAnimation():playWithIndex(_enum_animation_frame_index.animation_standby)
                        end
                    end
                    self._join_action = nil
                end))
                self:runAction(joinAction)
                self._join_action = joinAction
            else
                local joinAction = cc.Sequence:create(cc.EaseExponentialOut:create(cc.MoveTo:create(10, cc.p(0, 0))), cc.CallFunc:create(function( sender)
                    if __lua_project_id == __lua_project_pacific_rim then
                    else
                        sender._armature._nextAction = _enum_animation_frame_index.animation_standby
                    end
                    self._join_action = nil
                end))
                self:runAction(joinAction)
                self._join_action = joinAction
            end
        end
        self:drawPropertyAddEffect()
        self._track_y = self:getPositionY() + self._fightParent:getPositionY()
        self:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function ( sender )
            self._add_track = false
        end)))


        -- local joinAction = cc.Sequence:create(cc.MoveBy:create(3, cc.p(0, 200)), cc.MoveTo:create(2, cc.p(0, 0)), cc.CallFunc:create(function( sender)
        --     sender._armature._nextAction = _enum_animation_frame_index.animation_standby
        --     self._join_action = nil
        -- end))
        -- self:runAction(joinAction)
        -- self._join_action = joinAction

        -- armature:runAction(cc.Sequence:create(cc.EaseOut:create(cc.MoveTo:create(3, cc.p(size.width/2, size.height/2)), 1.2), cc.CallFunc:create(function( sender)
        --     sender._nextAction = _enum_animation_frame_index.animation_standby
        -- end)))
    else
        armature.actionIndex = _enum_animation_frame_index.animation_move
        if true == is2005 then
            armature._nextAction = _enum_animation_frame_index.animation_standby
        else
            armature._nextAction = _enum_animation_frame_index.animation_moving
        end
       
        armature:getAnimation():playWithIndex(_enum_animation_frame_index.animation_move)

        armature:setPosition(cc.p(size.width/2, size.height/2))
    end

    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    -- armature:setTag(roleTag)
    self._fightParent._armature = armature
    self._fightParent.__start_pos = cc.p(self._fightParent:getPosition())
    armature._posTile = self._fightParent
    self._fightParent._oldZOrder = self._fightParent:getLocalZOrder()
    self._fightParent._camp = "0"
    armature._camp = "0"
    armature._pos = self._info._pos
    armature._role = {}
    armature._role._id = self._info._id
    armature._role._mouldId = self._info._mouldId
    armature._role._original_mouldId = self._info._original_mouldId
    armature._role._type = self._info._type
    armature._role._name = self._info._name
    armature._role._hp = self._info._hp
    armature._role._sp = self._info._sp
    armature._role._quality = self._info._quality

    armature._role._camp_preference = self._camp_preference
    
    armature._isNew = true
    armature._brole = self._info
    armature._erole = {_type = "0"}
    
    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)

    if __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim 
        then
        armature._invoke = battle_execute._attackChangeActionCallback
        armature._node = self

        -- 绘制
        if armature._role._camp_preference == 2 then
            armature._child_tag = 1
            armature.__attack_count = 0
            if __lua_project_id == __lua_project_pacific_rim then
                armature:runAction(cc.Sequence:create(cc.DelayTime:create(2.0),
                    cc.CallFunc:create(function ( sender )
                        if sender._nextAction == animation_moving then
                            sender._nextAction = animation_standby
                        end
                    end)))
                local back_armatureName = "spirte_battle_card" .."_".. (movementIndex + 1)
                local backSprite = sp.spine("sprite/"..back_armatureName .. ".json", "sprite/"..back_armatureName .. ".atlas", 1, 0, _spine_sprite_animation_names[1], true, nil)
                backSprite:addAnimation(0, _spine_sprite_animation_names[2], true)

                -- spine动画初始化
                sp.initArmature(backSprite, true)

                backSprite.animationNameList = _spine_sprite_animation_names

                local back_armature = backSprite
                armature._back_armature = back_armature
                back_armature:setVisible(false)
                self:addChild(back_armature)
            else
                armature:setPosition(__metris_pos_o[1])
                armature:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), 
                    cc.MoveTo:create(1.5, __metris_pos_m[1]),
                    cc.CallFunc:create(function ( sender )
                        if sender._nextAction == animation_moving then
                            sender._nextAction = animation_standby
                        end
                    end)))
                for i = 2, 4 do
                    local childArmature = self:createChildHero(i, armatureName, armature)
                    childArmature._camp = armature._camp
                    childArmature._pos = armature._pos
                    childArmature._role = armature._role
                    childArmature._posTile = self._fightParent
                    childArmature._armature = childArmature
                    childArmature._node = self
                    childArmature.__attack_count = 0
                end
            end
        else
            local weapon = self:createWeaponArmature(armatureName .. "_1")
            weapon.__attack_count = 0
            armature._weapon = weapon
            armature._weapon._node = self
            armature:addChild(weapon, 100)
            if __lua_project_id == __lua_project_pacific_rim then
                weapon._actionIndex = animation_moving
        
                weapon._nextAction = animation_moving
               
                weapon:getAnimation():playWithIndex(animation_moving)
            end
        end

        if __lua_project_id == __lua_project_pacific_rim then
            local shadow = cc.Sprite:create("sprite/spirte_shadow.png")
            -- shadow:setTextureRect(cc.rect(0, 0, 193, 89))
            shadow:setAnchorPoint(cc.p(0.5, 0.5))
            shadow:setOpacity(100)
            shadow:setPosition(cc.p(size.width / 2, 0))
            self:addChild(shadow, -1)
            armature._shadow = shadow
        end
    end

    -- 设置角色
    if self._info._head ~= 0 then
        if armature._role._camp_preference == 2 then

        else
            local headId = self._info._head
            local role_names = {
                "role",
                "role_2",
                "role_3",
                "role_4",
            }
            for i, v in pairs(role_names) do
                local heroIcon  = ""
                if __lua_project_id == __lua_project_digimon_adventure 
                    or __lua_project_id == __lua_project_red_alert_time  
                    or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_yugioh 
                    then 
                    heroIcon = string.format("images/face/big_head/big_head_%s.png", headId)
                    if __lua_project_id == __lua_project_red_alert_time then
                        local heroIcon1 = string.format("images/face/big_head/big_head_%s_1.png", headId)
                        local roleIcon1 = ccs.Skin:create(heroIcon1)
                        armature._weapon:getBone(v):addDisplay(roleIcon1, 0)
                    end
                else
                    heroIcon = string.format("images/face/card_head/card_head_%s.png", headId)
                end
                if __lua_project_id == __lua_project_pacific_rim then
                else
                    local roleIcon = ccs.Skin:create(heroIcon)
                    armature:getBone(v):addDisplay(roleIcon, 0)
                end
                if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                    break
                end
            end
            if __lua_project_id == __lua_project_rouge then
                local roleIcon = ccs.Skin:create(string.format("images/ui/battle/card_quality_%s.png", self._info._quality))
                armature:getBone("card_1"):addDisplay(roleIcon, 0)
            end
        end
    end

    ---------------------------------------------------------------------------
    -- 新版UI
    ---------------------------------------------------------------------------
    if zstring.tonumber(self._info._pos) ~= 101 and zstring.tonumber(self._info._pos) ~= 102 then
        if __lua_project_id == __lua_project_warship_girl_b 
            or __lua_project_id == __lua_project_koone
            or __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
            or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_yugioh
            then
            local heroInfoWidget = HeroInfoUI:createCell()
            heroInfoWidget:init(armature)
            -- armature:getBone("hp"):addDisplay(heroInfoWidget, 0)
            
            -- armature:addChild(heroInfoWidget)
            if __lua_project_id == __lua_project_rouge then
                self._fightParent:addChild(heroInfoWidget, 2000000-1)
            elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                self:addChild(heroInfoWidget, 2000000-1)
            else
                self._fightParent:getParent():addChild(heroInfoWidget, 2000000-1)
            end
            
            -- local scaleX = self._fightParent:getScaleX()
            local scaleY = self._fightParent:getScaleY()
            
            -- local offsetX = self._fightParent:getContentSize().width * (scaleX - 1)
            local offsetY = self._fightParent:getContentSize().height * (scaleY)
            
            local xx, yy = self._fightParent:getPosition()
            xx = xx + self._fightParent:getContentSize().width * self._fightParent:getAnchorPoint().x
            yy = yy + self._fightParent:getContentSize().height * self._fightParent:getAnchorPoint().y + offsetY
            
            local xx1, yy1 = self._fightParent:getParent():getPosition()
            xx1 = xx1 + self._fightParent:getParent():getContentSize().width * self._fightParent:getParent():getAnchorPoint().x
            yy1 = yy1 + self._fightParent:getParent():getContentSize().height * self._fightParent:getParent():getAnchorPoint().y
            
            -- local xx2, yy2 = self._fightParent:getParent():getParent():getPosition()
            -- xx2 = xx2 + self._fightParent:getParent():getParent():getContentSize().width * self._fightParent:getParent():getParent():getAnchorPoint().x
            -- yy2 = yy2 + self._fightParent:getParent():getParent():getContentSize().height * self._fightParent:getParent():getParent():getAnchorPoint().y
            
            heroInfoWidget:setScale(self._fightParent:getScale())
            heroInfoWidget:setAnchorPoint(cc.p(0.5, 0.5))
            heroInfoWidget:setPosition(cc.p(xx + xx1 + size.width/2, 
                                        yy + yy1 + heroInfoWidget:getContentSize().height*3/2 + app.baseOffsetY))

            if __lua_project_id == __lua_project_rouge then
                heroInfoWidget:setPosition(cc.p(size.width/2, heroInfoWidget:getScale() * (size.height + heroInfoWidget:getContentSize().height*3/2)))
            elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                heroInfoWidget:setPosition(cc.p(size.width/2, -1 * heroInfoWidget:getScale() * (size.height + 45)))
            end

            armature._heroInfoWidget = heroInfoWidget
            armature._heroInfoWidget:showRoleName()
            armature._heroInfoWidget:showRoleType()
            armature._heroInfoWidget:showRoleSP()
            armature._heroInfoWidget:showControl(false)

        end
    end
    ---------------------------------------------------------------------------
    
    self._armature = armature
    if zstring.tonumber(self._info._pos) == 102 then 
        --战宠隐藏
        armature:setVisible(false)
        local picIndex = dms.string(dms["ship_mould"], _ED.user_ship["".._ED.formation_pet_id].ship_template_id, ship_mould.All_icon)
        local filePath = "effect/effice_"..picIndex..".ExportJson"
        if cc.FileUtils:getInstance():isFileExist(filePath) == true then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(filePath)
            local armatureName = "effice_" ..picIndex
            local armature1 = ccs.Armature:create(armatureName)
            armature1.actionIndex = 1
            armature1:getAnimation():playWithIndex(1)
            armature1:setPosition(cc.p(size.width/2, size.height/2))
            armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            self:addChild(armature1,1)
        end
    end
    self:addChild(armature)

    if __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
        then
        if dms.int(dms["ship_mould"], tonumber(self._info._mouldId), ship_mould.captain_type) == 0 then
            local fashionEquip, pic = getUserFashion(true)
            if fashionEquip ~= nil and pic ~= nil then
                movementIndex = pic
            end
        end
        if tonumber(movementIndex) > 0 then
            if __lua_project_id == __lua_project_yugioh then
                jsonFile = string.format("sprite/spirte_battle_card_%s.json", movementIndex)
                atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", movementIndex)
            else
                jsonFile = string.format("sprite/big_head_%s.json", movementIndex)
                atlasFile = string.format("sprite/big_head_%s.atlas", movementIndex)
            end
            local spArmature = sp.spine(jsonFile, atlasFile, _tipstringinfo_fight_armature_scale, 0, 
                spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

            spArmature:setPosition(cc.p(size.width/2, 0))
            
            spArmature.animationNameList = spineAnimations
            sp.initArmature(spArmature, true)
            self._spArmature = spArmature
            self._fightParent._spArmature = spArmature
            self:addChild(spArmature)
            --     self:changeHeroSpArmatureState(true)

            self._spArmature:setVisible(false)
            

            spArmature._armature = armature
            armature._spArmature = spArmature
            -- armature._reset = function(armature)
            --     local actionIndex = armature._actionIndex
            --     showSpineAnimationStandby(armature, actionIndex)
            -- end
        end
    end
end

function Hero:onExit()
    --> print("英雄死亡：", self._info._pos)
    --state_machine.excute("fight_hero_deathed", 0, 0)
end
