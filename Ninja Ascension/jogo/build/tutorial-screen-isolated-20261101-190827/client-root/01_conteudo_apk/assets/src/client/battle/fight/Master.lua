Master = class("MasterClass", Window)

function Master:ctor()
    self.super:ctor()
    self.roots = {}
    self.actionTimeSpeed = 1.0

    self._info = {}
    self._fightMap = nil 
    self._parentName = nil

    self._ready = false

    self._armature = nil
    self._spArmature = nil
    self._armatureAnger = nil  --怒气动画

    self._add_track = false
    self._interval = 0
    self._duration = 0.1
    self._fight_type = 0

    -- Initialize master page state machine.
    local function init_master_terminal()
        -- 创建兵种行步的痕迹
        local master_create_animation_move_track_terminal = {
            _name = "master_create_animation_move_track",
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
        local master_stop_animation_move_track_terminal = {
            _name = "master_stop_animation_move_track",
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

        state_machine.add(master_create_animation_move_track_terminal)
        state_machine.add(master_stop_animation_move_track_terminal)
        state_machine.init()
    end

    -- call func init master state machine.
    init_master_terminal()
end

function Master:changeHeroSpArmatureState( state )
    if self._spArmature ~= nil then
        self._spArmature:setVisible(state)
        if self._armature ~= nil then
            self._armature:setVisible(not state)
        end
    end
end

function Master:createArmatureMoveTrack( params, marmature)
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

function Master:stopArmatureMoveTrack( params )
    self._add_track = false
end

function Master:init(_info, _fightMap, _parentName,_boss_battle_card_num, _fightType)
    self._info = _info
    self._fightMap = _fightMap 
    self._parentName = _parentName
	self._boss_battle_card_num = _boss_battle_card_num
    self._fight_type = _fightType

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        self._fightParent = self._fightMap:rootAtIndex(1):getChildByName(self._parentName)
    else
        self._fightParent = ccui.Helper:seekWidgetByName(self._fightMap:rootAtIndex(1), self._parentName)
    end
    self._currentParent = self._fightParent
    
    self:registerOnNodeEvent(self)

    local camp_preference = 0
    if self._info._type == "1" then
        camp_preference = dms.int(dms["environment_ship"], self._info._mouldId, environment_ship.camp_preference)
    else
        camp_preference = dms.int(dms["ship_mould"], self._info._mouldId, ship_mould.camp_preference)
    end
    self._camp_preference = camp_preference
    
    self._currentParent:addChild(self)

    if __lua_project_id == __lua_project_digimon_adventure 
        -- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh  
        then 
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_62.ExportJson")
        self._armatureAnger = ccs.Armature:create("effice_62")
        self._armatureAnger:getAnimation():playWithIndex(0)
        self._armatureAnger:setPosition(self._fightParent:getContentSize().width/2,self._fightParent:getContentSize().height/2)
        self._armatureAnger:setName("angerEffect")
        self._armatureAnger:setVisible(false)
        self._currentParent:addChild(self._armatureAnger)
    end

    self._camp = "1"
    self._pos = self._info._pos
    self._currentParent._camp = "1"
    self._currentParent._pos = self._info._pos

    --> print("master datas:", _info, _fightMap, _parentName)
    return self
end

function Master:createWeaponArmature(armature_name)
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
    armature:getAnimation():playWithIndex(animation_standby)
    -- armature:setPosition(cc.p(self._currentParent:getContentSize().width/2, self._currentParent:getContentSize().height/2))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)

    armature._actionIndex =animation_standby
    armature._nextAction = animation_standby

    -- armature._invoke = battle_execute._attackChangeActionCallback
    return armature
end

function Master:createChildHero(index, armatureName, rootArmature)
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

function Master:onUpdate(dt)
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
function Master:drawPropertyAddEffect()
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

function Master:onEnterTransitionFinish()
    local size = self._currentParent:getContentSize()
    self:setContentSize(cc.size(size.width, size.height))
    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setPosition(cc.p(size.width/2, size.height/2))
    if self._armature ~= nil or self._info == nil  or self._info._head == nil then
        return
    end

    if self._fight_type == _enum_fight_type._fight_type_204 then
        -- self._fightParent:setPositionX(fwin._width / 2)
        -- 1号位 不动  
        -- 2号位 朝1号位方向移动0.5格    
        -- 3号位 朝1号位方向移动1格  
        -- 4号位 朝5号位方向移动0.5格    
        -- 5号位 不动  
        -- 6号位 朝5号位方向移动0.5格    
        local pos = tonumber(self._info._pos)
        if pos == 2 then
            self._fightParent:setPositionX(self._fightParent:getPositionX() - 80)
        elseif pos == 3 then
            self._fightParent:setPositionX(self._fightParent:getPositionX() - 160)
        elseif pos == 4 then
            self._fightParent:setPositionX(self._fightParent:getPositionX() + 80)
        elseif pos == 6 then
            self._fightParent:setPositionX(self._fightParent:getPositionX() - 40)
        end
    end

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
       self._info._master_type = "0" 
    end

	local armature_name = "spirte_battle_card"
    if __lua_project_id ~= __lua_project_rouge then
    	if self._info._master_type == "1" then -- boss
    		armature_name = string.format("boss_battle_card_%d",self._boss_battle_card_num)
        else
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                if self._info._type == "1" then
                    local sign_type = dms.int(dms["environment_ship"], self._info._mouldId, environment_ship.sign_type)
                    if sign_type == 1 then
                        self._boss_battle_card_num = dms.int(dms["environment_ship"], self._info._mouldId, environment_ship.sign_pic)
                    else 
                        self._boss_battle_card_num = dms.int(dms["environment_ship"], self._info._mouldId, environment_ship.bust_index)
                    end
                else
                    self._boss_battle_card_num = dms.int(dms["ship_mould"], self._info._mouldId, ship_mould.movement)
                end
                if self._boss_battle_card_num > 0 then
                    if __lua_project_id == __lua_project_pacific_rim then
                        self._boss_battle_card_num = self._boss_battle_card_num + 1
                    end
                    armature_name = string.format("spirte_battle_card_%d",self._boss_battle_card_num)
                end
            end
    	end
    end
    local armature = nil
    local useSpAni = false
    if __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
        then
        if self._info._master_type == "1" then
            useSpAni = true
        end
    end
    local armatureName = armature_name
    if useSpAni == true then
        local jsonFile = string.format("sprite/boss_battle_card_%s.json", self._boss_battle_card_num)
        local atlasFile = string.format("sprite/boss_battle_card_%s.atlas", self._boss_battle_card_num)
        
        armature = sp.spine(jsonFile, atlasFile, _tipstringinfo_fight_armature_scale, 0, 
            spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil)

        armature:setPosition(cc.p(self._currentParent:getContentSize().width/2, 0))

        armature.animationNameList = spineAnimations
        sp.initArmature(armature, true)
    else
        if __lua_project_id == __lua_project_pacific_rim then
            local sprite = sp.spine("sprite/"..armatureName .. ".json", "sprite/"..armatureName .. ".atlas", 1, 0, _spine_sprite_animation_names[1], true, nil)
            sprite:addAnimation(0, _spine_sprite_animation_names[2], true)

            -- spine动画初始化
            sp.initArmature(sprite, true)

            sprite.animationNameList = _spine_sprite_animation_names

            armature = sprite
        else
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/"..armature_name..".ExportJson")
            armature = ccs.Armature:create(armature_name)
        end

        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            local size = self._currentParent:getContentSize()

            armature._actionIndex = animation_moving
        
            armature._nextAction = animation_moving
           
            armature:getAnimation():playWithIndex(animation_moving)

            armature:setPosition(cc.p(size.width/2, size.height/2))

            if __lua_project_id == __lua_project_pacific_rim then
                self:setPosition(cc.p(380, 380))
            else
                self:setPosition(cc.p(0, 300))
            end

            self._add_track = true

            -- 入场动画
            if self._camp_preference == 2 then
                self:runAction(cc.Sequence:create(cc.MoveTo:create(2.0, cc.p(0, 0)), cc.CallFunc:create(function( sender)
                    --> print(sender._armature._nextAction, sender._armature._actionIndex)
                    if sender._armature._nextAction == _enum_animation_frame_index.animation_moving then
                        sender._armature._nextAction = _enum_animation_frame_index.animation_standby
                    end
                end)))
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
                    self:runAction(cc.Sequence:create(cc.EaseExponentialOut:create(cc.MoveTo:create(10, cc.p(0, 0))), cc.CallFunc:create(function( sender)
                        sender._armature._nextAction = _enum_animation_frame_index.animation_standby
                        if __lua_project_id == __lua_project_pacific_rim then
                            if nil ~= sender._armature._weapon then
                                sender._armature._weapon:getAnimation():playWithIndex(_enum_animation_frame_index.animation_standby)
                                sender._armature._weapon._nextAction = _enum_animation_frame_index.animation_standby
                            end
                        end
                    end)))
                end
            end
            self:drawPropertyAddEffect()

            self._track_y = self:getPositionY() + self._fightParent:getPositionY()
            self:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function ( sender )
                self._add_track = false
            end)))
        else
            armature:getAnimation():playWithIndex(_enum_animation_frame_index.animation_standby)
            armature:setPosition(cc.p(self._currentParent:getContentSize().width/2, self._currentParent:getContentSize().height/2))
        end
        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    end
    -- armature:setTag(roleTag)
    self._currentParent._armature = armature
    armature._posTile = self._currentParent
    self._currentParent.__start_pos = cc.p(self._currentParent:getPosition())
    self._currentParent._oldZOrder = self._currentParent:getLocalZOrder()
    self._currentParent._camp = "1"
    armature._camp = "1"
    armature._role = {}
    armature._pos = self._info._pos
    armature._role._id = self._info._id
    armature._role._mouldId = self._info._mouldId
    armature._role._type = self._info._type
	armature._role._name = self._info._name
    armature._role._hp = self._info._hp
    armature._role._sp = self._info._sp
    armature._role._quality = self._info._quality
    armature._brole = self._info
    armature._erole = {_type = self._info._type}

    armature._role._camp_preference = self._camp_preference

    armature:getAnimation():setSpeedScale(1.0/self.actionTimeSpeed)

    if __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim 
        then
        armature._invoke = battle_execute._attackChangeActionCallback
        armature._node = self

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
                local back_armature_name = string.format("spirte_battle_card_%d", (self._boss_battle_card_num - 1))
                local backSprite = sp.spine("sprite/"..back_armature_name .. ".json", "sprite/"..back_armature_name .. ".atlas", 1, 0, _spine_sprite_animation_names[1], true, nil)
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
                    childArmature:setScaleY(-1)
                end
            end
        else
            local weapon = self:createWeaponArmature(armature_name .. "_1")
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

    local function addDisplaySkin( ... )
        local role_names = {
            "role",
            "role_2",
            "role_3",
            "role_4",
        }
        -- 设置角色
        if armature._role._camp_preference == 2 then
        else
            local headId = self._info._head
            for i, v in pairs(role_names) do
                local heroIcon = ""
                if __lua_project_id == __lua_project_digimon_adventure 
                    or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
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
                    --> print(heroIcon, heroIcon1)
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
    if __lua_project_id == __lua_project_rouge then
        addDisplaySkin()
    else
        if self._info._master_type == "1" then -- boss
        else
            addDisplaySkin()
        end
    end
	---------------------------------------------------------------------------
	-- 新版UI
	---------------------------------------------------------------------------
    if __lua_project_id == __lua_project_red_alert_time 
        -- or __lua_project_id == __lua_project_pacific_rim 
        then
        armature:setScaleY(-1)
    end
    if zstring.tonumber(self._info._pos) ~= 102 then 
        local heroInfoWidget = HeroInfoUI:createCell()
        heroInfoWidget:init(armature)
        -- armature:getBone("hp"):addDisplay(heroInfoWidget, 0)
        if __lua_project_id == __lua_project_red_alert_time then
            self:addChild(heroInfoWidget, 2000000-1)
            heroInfoWidget:udpateMasterPosition()
        elseif __lua_project_id == __lua_project_pacific_rim then
            self:addChild(heroInfoWidget, 2000000-1)
        else
            self._currentParent:addChild(heroInfoWidget, 2000000-1)
        end

        heroInfoWidget:setAnchorPoint(cc.p(0.5, 0.5))

        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            if __lua_project_id == __lua_project_pacific_rim then
                heroInfoWidget:setScale(self._fightParent:getScale())
                heroInfoWidget:setPosition(cc.p(size.width/2, -1 * heroInfoWidget:getScale() * (size.height + 45)))
            else
                heroInfoWidget:setPosition(cc.p(size.width/2, (size.height + 45) + 54))
            end
            if self._fight_type == _enum_fight_type._fight_type_204 then
                if self._boss_battle_card_num < 0 then
                    heroInfoWidget:setPosition(cc.p(-100000, (size.height + 45) + 54))
                end
                armature._target_count = 3
            end
        else
            heroInfoWidget:setPosition(cc.p(size.width/2, size.height + heroInfoWidget:getContentSize().height*3/2))
        end
        
        armature._heroInfoWidget = heroInfoWidget
        armature._heroInfoWidget:showRoleName()
        armature._heroInfoWidget:showRoleType()
        armature._heroInfoWidget:showRoleSP()
        armature._heroInfoWidget:showControl(attack_logic.__hero_ui_visible)
    else
        armature:setVisible(false)
        local picIndex = dms.string(dms["ship_mould"], self._info._mouldId, ship_mould.All_icon)
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
	---------------------------------------------------------------------------
	

    self._armature = armature
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        self:addChild(armature)
        self.__angerParent = self  
        self._currentParent.__angerParent = self    
    else
        self._currentParent:addChild(armature)
        self._currentParent.__angerParent = self    
    end
    if self._fightParent._isShow == false then
        armature:setVisible(self._fightParent._isShow)
        armature._heroInfoWidget:controlLife(false, 10)
        armature._heroInfoWidget:showControl(false)
        armature._heroInfoWidget:controlLife(true, 10)
    end

    if __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
        then
        if self._info._master_type ~= "1" then
            local movementIndex = 0
            if armature._role._type == "0" then
                movementIndex = dms.string(dms["ship_mould"], self._info._mouldId, ship_mould.movement)
                if tonumber(movementIndex) > 0 then
                    for k,v in pairs(__fashion_animation_info) do
                        local animations = zstring.split(v[2], ",")
                        for i,id in ipairs(animations) do
                            if tonumber(id) == tonumber(self._info._head) then
                                movementIndex = v[1]
                                break
                            end
                        end
                    end
                end
            else
                local directing = dms.string(dms["environment_ship"], self._info._mouldId, environment_ship.directing)
                movementIndex = dms.string(dms["ship_mould"], directing, ship_mould.movement)
            end
            if tonumber(movementIndex) > 0 then
                local jsonFile = ""
                local atlasFile = ""
                if __lua_project_id == __lua_project_yugioh then
                    jsonFile = string.format("sprite/spirte_battle_card_%s.json", movementIndex)
                    atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", movementIndex)
                else
                    jsonFile = string.format("sprite/big_head_%s.json", movementIndex)
                    atlasFile = string.format("sprite/big_head_%s.atlas", movementIndex)
                end
                local spArmature = sp.spine(jsonFile, atlasFile, _tipstringinfo_fight_armature_scale, 0, 
                    spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil)

                spArmature:setPosition(cc.p(self._currentParent:getContentSize().width/2, 0))

                spArmature.animationNameList = spineAnimations
                sp.initArmature(spArmature, true)
                self._spArmature = spArmature
                self._currentParent._spArmature = spArmature
                self:addChild(spArmature)
                self:changeHeroSpArmatureState(true)
                spArmature._armature = armature
                armature._spArmature = spArmature
                -- armature._reset = function(armature)
                --     local actionIndex = armature._actionIndex
                --     showSpineAnimationStandby(armature, actionIndex)
                -- end
            end
        end
        if self._fightParent._isShow == false then
            if armature._spArmature ~= nil then
                armature._spArmature:setVisible(false)
            end
        end
    end
end

function Master:showAngerEffect(isShow)
    if __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        then
        if self._armatureAnger ~= nil then 
            if self._info._master_type == "1" then
                self._armatureAnger:setVisible(false)
            else
                self._armatureAnger:setVisible(isShow)
            end  
        end
    end
end

-- 宠物加层
function Master:showPetAddAnimation()

    --ship_moudl 61 --- pet_mould 4  ----  pet_train--2-  --当前阶级 ---
    local pet_id = dms.int(dms["ship_mould"], self._info._mouldId, ship_mould.base_mould2)
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
    local pet_formations = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
    local level = zstring.tonumber(self._info._train_level)
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
                    num:init(39,value,1)
                    self:addChild(num)
                end
                if info ~= nil and #info == 1 then 
                    --一种属性
                    local addAttribute = zstring.split("".. info[1],",")
                    num:init(addAttribute[1],addAttribute[2],1)
                    self._currentParent:addChild(num,100)
                end
            end
        end
    end
end

function Master:onExit()
    --> print("怪物死亡：", self._info._pos)
    -- state_machine.excute("fight_master_deathed", 0, 0)
end
