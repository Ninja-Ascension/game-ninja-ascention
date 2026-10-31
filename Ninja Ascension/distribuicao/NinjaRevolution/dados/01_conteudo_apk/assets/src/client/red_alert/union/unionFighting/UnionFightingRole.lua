UnionFightingRole = class("UnionFightingRoleClass", Window)

local union_fighting_role_create_terminal = {
	_name = "union_fighting_role_create",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		return UnionFightingRole:new():init(params)
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_role_create_terminal)
state_machine.init()

function UnionFightingRole:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._enum_state = {
        _free = 0,
        _wait = 1,
        _attack = 2,
    }
    self._current_state = self._enum_state._free
    self._armature = nil
    self._row = 0
    self._isAttacker = false
    self._formation_index = 0
    self._headId = 0
    self._gender = "0"
    self._isWin = false
    self._hurt = 0
    self._fight_index = 0

    local function init_union_fight_role_terminal()
        local union_fight_role_update_draw_info_terminal = {
            _name = "union_fight_role_update_draw_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params[1]
                local roleInfo = params[2]
                role:updateDrawInfo(roleInfo)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_role_update_draw_role_move_terminal = {
            _name = "union_fight_role_update_draw_role_move",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params[1]
                local roleInfo = params[2]
                local moveToX = params[3]
                local moveToY = params[4]
                role:updateDrawRoleMove(roleInfo, moveToX, moveToY)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_role_update_draw_role_move_to_attack_terminal = {
            _name = "union_fight_role_update_draw_role_move_to_attack",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params[1]
                local roleInfo = params[2]
                role:updateDrawRoleMoveToAttack(roleInfo)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fight_role_update_draw_info_terminal)
        state_machine.add(union_fight_role_update_draw_role_move_terminal)
        state_machine.add(union_fight_role_update_draw_role_move_to_attack_terminal)
        state_machine.init()
    end
    init_union_fight_role_terminal()
end

function UnionFightingRole:updateDrawInfo(roleInfo)
    local root = self.roots[1]

    local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    Text_role_name:setString("")
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    Text_legion_name:setString("")
    if nil ~= roleInfo then
        Text_role_name:setString(roleInfo.user_name)
        Text_legion_name:setString(roleInfo.union_name)
        self:addMyRoleEffect(true)
    else
        self:addMyRoleEffect(false)
    end
end

function UnionFightingRole:updateDrawRoleMove(roleInfo, moveToX, moveToY)
    self:updateDrawInfo(roleInfo)

    self:setVisible(true)

    self._armature:getAnimation():playWithIndex(1)
    local mp = cc.p((self:getPositionX() - moveToX), (self:getPositionY() - moveToY))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / 300
    self:stopAllActions()
    self:runAction(cc.Sequence:create({cc.MoveTo:create(t, cc.p(moveToX, moveToY)), cc.CallFunc:create(function(sender)
        csb.animationChangeToAction(self._armature, 0, 0, false)
    end)}))
end

function UnionFightingRole:updateDrawRoleMoveToAttack(roleInfo)
    self:setVisible(true)
    local endPos = _union_fight_center_move_pos[self._formation_column]
    local changePos = _union_fight_center_move_pos[4]
    local endPosX = endPos[1]
    self._isWin = false
    self._role_info = roleInfo

    self._formation_row = 3
    self._formation_index = (self._formation_row - 1) * 3 + self._formation_column

    self._hurt = 0
    if self._isAttacker == true then
        if tonumber(roleInfo.result) == 1 then
            self._isWin = true
            self._hurt = roleInfo.defencer_damage
        else
            self._hurt = roleInfo.attacker_damage
        end
        endPosX = endPosX + changePos[1]
        self:updateDrawInfo({user_name = roleInfo.attacker_name, union_name = roleInfo.attacker_union_name})
    else
        if tonumber(roleInfo.result) == 0 then
            self._isWin = true
            self._hurt = roleInfo.attacker_damage
        else
            self._hurt = roleInfo.defencer_damage
        end
        endPosX = endPosX + changePos[2]
        self:updateDrawInfo({user_name = roleInfo.defender_name, union_name = roleInfo.defender_union_name})
    end
    self._armature:getAnimation():playWithIndex(1)
    local moveToX = endPosX
    local moveToY = self:getPositionY()
    local mp = cc.p((self:getPositionX() - moveToX), (self:getPositionY() - moveToY))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / 300
    self:stopAllActions()
    self:runAction(cc.Sequence:create({cc.MoveTo:create(t, cc.p(moveToX, moveToY)), cc.CallFunc:create(function(sender)
        csb.animationChangeToAction(self._armature, 2, 2, false)
        self._armature:getAnimation():setFrameEventCallFunc(function (bone, evt, originFrameIndex, currentFrameIndex)
            local armature = bone:getArmature()
            if evt == "hurt" and self._isWin == true and self._hurt ~= nil and tonumber(self._hurt) ~= nil and tonumber(self._hurt) > 0 then
                state_machine.excute("union_fighting_main_city_update_hurt", 0, {self._formation_column, self._hurt/3})
            end
        end)
    end)}))
end

function UnionFightingRole.changeActionCallbackEx(armatureBack)
    if armatureBack ~= nil then
        local actionIndex = armatureBack._actionIndex
        if actionIndex == 2 then
            if armatureBack._self._isWin == true then
                csb.animationChangeToAction(armatureBack, 6, 6, false)
            else
                csb.animationChangeToAction(armatureBack, 7, 7, false)
            end
        elseif actionIndex == 6
            or actionIndex == 7 
            then
            -- armatureBack._self:leaveFightScene()
            -- if armatureBack._self._isWin == true then
            --     state_machine.excute("union_fighting_main_reset_fight_role_info", 0, armatureBack._self._fight_index)
            -- end
            -- armatureBack._self._isWin = false
            -- armatureBack._self._fight_index = 0

            armatureBack._self:leaveFightSceneExt()
        end
    end
end

function UnionFightingRole:updateMySelfInfo( index, myIsAttacker, attacker )
    local root = self.roots[1]
    local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    Text_role_name:setString("")
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    Text_legion_name:setString("")
    if index == 1 and myIsAttacker == attacker then
        Text_role_name:setString(_ED.user_info.user_name)
        Text_legion_name:setString(_ED.union.union_info.union_name)
        self:addMyRoleEffect(true)
    else
        self:addMyRoleEffect(false)
    end
end

function UnionFightingRole:onInit(isMySelf)
    local csbNode = csb.createNode(config_csb.cells.big_map.map_legion_battle_cell)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    Text_role_name:setString("")
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    Text_legion_name:setString("")
    if isMySelf == true then
        Text_role_name:setString(_ED.user_info.user_name)
        Text_legion_name:setString(_ED.union.union_info.union_name)
        self:addMyRoleEffect(true)
    else
        self:addMyRoleEffect(false)
    end
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    Panel_role:removeAllChildren(true)

    local temp_bust_index = self._headId

    local armature = sp.spine_sprite(nil, temp_bust_index, _spine_union_role_animation_names[1], true, nil, nil, cc.p(0.5, 0))
    sp.initArmature(armature, true)    
    armature.animationNameList = _spine_union_role_animation_names
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature._invoke = self.changeActionCallbackEx
    armature._self = self
    Panel_role:addChild(armature)
    self._armature = armature

    local count = self._row + (self._formation_index - 1) * 3
    if self._isAttacker == true then
        self:setPosition(cc.p(_union_fight_left_move_pos[count][1], _union_fight_left_move_pos[count][2]))
    else
        armature:setScaleX(-1)
        self:setPosition(cc.p(_union_fight_right_move_pos[count][1], _union_fight_right_move_pos[count][2]))
    end
    if self._row == 1 then
        self:setLocalZOrder(90)
    elseif self._row == 2 then
        self:setLocalZOrder(80)
    else
        self:setLocalZOrder(100)
    end
end

function UnionFightingRole:addMyRoleEffect( isNeedAdd )
    local root = self.roots[1]
    local Panel_role_light = ccui.Helper:seekWidgetByName(root, "Panel_role_light")
    Panel_role_light:removeAllChildren(true)
    if isNeedAdd == true then
        local baseName = "effect/effect_guozhanjiaodi"
        local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        skeletonNode:setAnimation(0, "animation", true)
        Panel_role_light:addChild(skeletonNode)
    end
end

function UnionFightingRole:beginAttackMove(name, unionName, result, fightTeamIndex)
    local root = self.roots[1]
    self._current_state = self._enum_state._attack
    self._formation_index = 4
    self._fight_index = fightTeamIndex
    self._isWin = false
    local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    Text_role_name:setString(name)
    Text_legion_name:setString(unionName)
    local endPos = _union_fight_center_move_pos[fightTeamIndex]
    local changePos = _union_fight_center_move_pos[self._formation_index]
    local endPosX = endPos[1]
    if self._isAttacker == true then
        if tonumber(result) == 1 then
            self._isWin = true
        end
        endPosX = endPosX + changePos[1]
    else
        if tonumber(result) == 0 then
            self._isWin = true
        end
        endPosX = endPosX + changePos[2]
    end
    self._armature:getAnimation():playWithIndex(1)
    local mp = cc.p((self:getPositionX() - endPosX), (self:getPositionY() - endPos[2]))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / 300
    self:runAction(cc.Sequence:create({cc.MoveTo:create(t, cc.p(endPosX, endPos[2])), cc.CallFunc:create(function(sender)
        csb.animationChangeToAction(self._armature, 2, 2, false)
        self._armature:getAnimation():setFrameEventCallFunc(function (bone, evt, originFrameIndex, currentFrameIndex)
            local armature = bone:getArmature()
            if evt == "hurt" then
                state_machine.excute("union_fighting_main_city_update_hurt", 0, fightTeamIndex)
            end
        end)
    end)}))
end

function UnionFightingRole:attackEndMove( moveIndex )
    self._current_state = self._enum_state._wait
    self:setVisible(true)
    local endPos = {}
    if self._isAttacker == true then
        endPos = _union_fight_left_move_pos[moveIndex + (self._formation_index - 1) * 3]
    else
        endPos = _union_fight_right_move_pos[moveIndex + (self._formation_index - 1) * 3]
    end
    local movePosX = endPos[1]
    local movePosY = endPos[2]
    if self:getPositionX() == movePosX and self:getPositionY() == movePosY then
        return
    end

    -- print(self._isAttacker, self._formation_index, self._row)
    -- debug.print_r(endPos)
    self._armature:getAnimation():playWithIndex(1)

    local mp = cc.p((self:getPositionX() - movePosX), (self:getPositionY() - movePosY))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / 300
    self:runAction(cc.Sequence:create({cc.MoveTo:create(t, cc.p(movePosX, movePosY)), cc.CallFunc:create(function(sender)
        csb.animationChangeToAction(self._armature, 0, 0, false)
    end)}))
end

function UnionFightingRole:leaveFightScene( ... )
    self:setVisible(false)
    self._current_state = self._enum_state._free
    local endPos = {}
    if self._isAttacker == true then
        endPos = _union_fight_left_move_pos[self._row + 6]
    else
        endPos = _union_fight_right_move_pos[self._row + 6]
    end

    local movePosX = endPos[1]
    local movePosY = endPos[2]
    csb.animationChangeToAction(self._armature, 0, 0, false)
    self:setPosition(cc.p(movePosX, movePosY))
end

function UnionFightingRole:leaveFightSceneExt( ... )
    local root = self.roots[1]
    local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    Text_role_name:setString("")
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    Text_legion_name:setString("")
    
    csb.animationChangeToAction(self._armature, 0, 0, false)
    local camp = 0
    if self._isAttacker == false then
        camp = 1
    else
    end
    if self._isWin == true then
        if self._isAttacker == true then
            if tonumber(self._role_info.attacker_id) == tonumber(_ED.user_info.user_id) then
                show = true
            end
        else
            if tonumber(self._role_info.defender_id) == tonumber(_ED.user_info.user_id) then
                show = true
            end
        end
    end
    self._isWin = false
    self:setVisible(false)
    local count = self._formation_index
    if self._isAttacker == true then
        self:setPosition(cc.p(_union_fight_left_move_pos[count][1], _union_fight_left_move_pos[count][2]))
    else
        self:setPosition(cc.p(_union_fight_right_move_pos[count][1], _union_fight_right_move_pos[count][2]))
    end
    state_machine.excute("union_fighting_main_reset_fight_role_info", 0, {camp, self})
end

function UnionFightingRole:checkIsFree( ... )
    return self._current_state == self._enum_state._free
end

function UnionFightingRole:checkIsWait( ... )
    return self._current_state == self._enum_state._wait
end

function UnionFightingRole:checkIsAttack( ... )
    return self._current_state == self._enum_state._attack
end

function UnionFightingRole:onEnterTransitionFinish()
end

function UnionFightingRole:init(params)
    self._isAttacker = params[2]
    self._formation_index = math.ceil(params[3]/3)
    self._row = math.ceil(params[3]%3)
    if self._row == 0 then
        self._row = 3
    end
    local isMySelf = false
    if self._isAttacker == params[4] 
        and self._formation_index == 1
        then
        -- isMySelf = true
    end
    self._gender = params[5]
    if tonumber(self._gender) == 1 then
        self._headId = "1501_2"
    else
        self._headId = "1511_2"
    end
    self._headId = "1501_2"
    self:onInit(isMySelf)
    self._current_state = self._enum_state._wait
    if params[1] == nil then
        self:leaveFightScene()
    end
	return self
end

function UnionFightingRole:onExit()
	-- state_machine.remove("union_fight_attack_rank_cost_ok")
    -- state_machine.remove("union_fight_role_update_draw_info")
end
