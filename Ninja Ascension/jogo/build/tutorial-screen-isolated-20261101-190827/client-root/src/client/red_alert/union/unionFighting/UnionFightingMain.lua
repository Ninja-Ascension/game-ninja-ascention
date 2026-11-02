UnionFightingMain = class("UnionFightingMainClass", Window)

local union_fighting_main_open_terminal = {
	_name = "union_fighting_main_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightingMainClass")
		if window == nil then
            local window = UnionFightingMain:new():init(params)
    		fwin:open(window, fwin._ui)
            state_machine.excute("national_war_map_window_hide", 0, nil)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_main_close_terminal = {
	_name = "union_fighting_main_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        _ED.union_fight_city_attack_result_list = {}
		fwin:close(fwin:find("UnionFightingMainClass"))
        state_machine.excute("national_war_map_window_show", 0, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_main_open_terminal)
state_machine.add(union_fighting_main_close_terminal)
state_machine.init()

function UnionFightingMain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._Button_attack = nil
    self.listview = nil
    self.listview_poy = nil

    self._mainCityInfo = nil
    self._tickTime = 0
    self._beginWaitTime = 0
    self._isNeedWaitAttackTimeEnd = false

    self._isBegined = false

    self.Text_battle_time_n = nil
    self.Text_stand_time_n = nil
    self.Panel_stand_mach = nil
    self.Panel_19 = nil
    self.Image_mach = nil

    self._attack_roles = {}
    self._defend_roles = {}

    self._attack_formation_roles = {}
    self._defend_formation_roles = {}

    self._attack_union_team_info_list = {}
    self._defend_union_team_info_list = {}

    self._myIsAttacker = false

    self._lastKillNums = 0

    -- 攻守双方角色缓存
    self._attacker_free_roles = {}
    self._defender_free_roles = {}
    self._attacker_roles = {}
    self._defender_roles = {}
    self._attacker_formation_roles = {{}, {}, {}}
    self._defender_formation_roles = {{}, {}, {}}
    self._is_update_draw = false
    self._is_start_attack = false
    self._draw_union_fight_city_round_battle_info_count = 0
    self._draw_union_fight_city_round_battle_info_wait_time = 15
    self._draw_union_fight_city_round_battle_info_wait_cd = 0

    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert.cells.union.union_fight_report_cell")
    app.load("client.red_alert.union.unionFighting.UnionFightingBegin")
    app.load("client.red_alert.union.unionFighting.UnionFightingResult")
    app.load("client.red_alert.union.unionFighting.UnionFightingBattleVic")
    app.load("client.red_alert.union.unionFighting.UnionFightingOneBattleResult")
    app.load("client.red_alert.union.unionFighting.UnionFightingRole")
    app.load("client.red_alert.union.unionFighting.UnionFightingLeftUnionTeam")
    app.load("client.red_alert.union.unionFighting.UnionFightingRightUnionTeam")
    app.load("client.red_alert.cells.union.union_fight_union_team_cell")
    app.load("client.red_alert.cells.battle.battle_ui_icon_cell")
    app.load("client.red_alert.union.unionFighting.UnionFightingFail")
    
    local function init_union_fight_main_terminal()
		local union_fighting_main_attack_terminal = {
            _name = "union_fighting_main_attack",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.union_fight_city_user_info.mach_wait_cd > 0 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[86])
                    return
                end
                if instance._isNeedWaitAttackTimeEnd == true then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[94])
                    return
                end
                if instance._myIsAttacker == false then
                    if #instance._attack_union_team_info_list == 0 then
                        TipDlg.drawTextDailog(tipStringInfo_union_str[117])
                        return
                    end
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.union_fighting_wait_attack = true
                        state_machine.excute("union_fighting_main_update_info", 0, "")
                    end
                end
                protocol_command.union_stronghold_fight.param_list = _ED.union.union_info.union_id.."\r\n"..instance._mainCityInfo.city_id
                NetworkManager:register(protocol_command.union_stronghold_fight.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_return_back_nationalMap_terminal = {
            _name = "union_fighting_main_return_back_nationalMap",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local nType = params._datas.ntype
                if nType == 1 then
                    state_machine.excute("union_fighting_main_close", 0, nil)
                else
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureBackFightUnion, tipStringInfo_union_str[112])
                    fwin:open(tip, fwin._windows)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_clean_attack_cd_terminal = {
            _name = "union_fighting_main_clean_attack_cd",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cost = 0
                local normal_costs = zstring.split(dms.string(dms["union_config"], 45, union_config.param), ",")
                if tonumber(_ED.union_fight_city_user_info.clear_attack_cd_times) + 1 >= table.nums(normal_costs) then
                    cost = normal_costs[table.nums(normal_costs)]
                else
                    cost = normal_costs[_ED.union_fight_city_user_info.clear_attack_cd_times + 1]
                end
                local tip = ConfirmTip:new()
                local info = string.format(tipStringInfo_union_str[95], ""..cost)
                tip:init(instance, instance.sureCleanAttackCD, info)
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_update_info_terminal = {
            _name = "union_fighting_main_update_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.updateDraw ~= nil then
                    instance._is_update_draw = true
                    --instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_update_one_result_terminal = {
            _name = "union_fighting_main_update_one_result",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isNeedTickOut = false
                for k,v in pairs(_ED.union_fight_city_round_battle_info) do
                    if v.isMyBattle == true then
                        if tonumber(v.result) == 0 then
                            if tonumber(v.attacker_id) == tonumber(_ED.user_info.user_id) then
                                isNeedTickOut = true
                            end
                        elseif tonumber(v.result) == 1 then
                            if tonumber(v.defender_id) == tonumber(_ED.user_info.user_id) then
                                isNeedTickOut = true
                            end
                        end
                    end
                end
                -- if isNeedTickOut == true then
                --     state_machine.excute("union_fighting_main_close", 0, nil)
                -- else
                -- instance:beginAttack(isNeedTickOut, params)
                instance._is_start_attack = true
                -- instance:beginAttackExt(isNeedTickOut, params)
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_city_result_terminal = {
            _name = "union_fighting_main_city_result",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_fighting_result_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_city_update_kill_nums_terminal = {
            _name = "union_fighting_main_city_update_kill_nums",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateKillNums()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_city_update_report_terminal = {
            _name = "union_fighting_main_city_update_report",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateBattleReport()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_city_update_state_terminal = {
            _name = "union_fighting_main_city_update_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union_fight_city_state) == 0 then
                    state_machine.excute("union_fighting_main_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_city_update_hurt_terminal = {
            _name = "union_fighting_main_city_update_hurt",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:playHurtAnimation(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_change_attack_state_terminal = {
            _name = "union_fighting_main_change_attack_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local tip = ConfirmTip:new()
                tip:init(instance, instance.sureChangeAttackState, tipStringInfo_union_str[109])
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_reset_fight_role_info_terminal = {
            _name = "union_fighting_main_reset_fight_role_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --instance:sortFormationIndex(params)
                instance:sortFormationIndexExt(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_main_change_fight_scene_info_terminal = {
            _name = "union_fighting_main_change_fight_scene_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and tonumber(_ED.union_fight_city_state) == 3 then
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node:updateDraw()
                            end
                        end
                    end
                    protocol_command.union_stronghold_init.param_list = _ED.union.union_info.union_id.."\r\n"..instance._mainCityInfo.city_id
                    NetworkManager:register(protocol_command.union_stronghold_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_fighting_main_attack_terminal)
        state_machine.add(union_fighting_main_return_back_nationalMap_terminal)
        state_machine.add(union_fighting_main_clean_attack_cd_terminal)
        state_machine.add(union_fighting_main_update_info_terminal)
        state_machine.add(union_fighting_main_update_one_result_terminal)
        state_machine.add(union_fighting_main_city_result_terminal)
        state_machine.add(union_fighting_main_city_update_kill_nums_terminal)
        state_machine.add(union_fighting_main_city_update_report_terminal)
        state_machine.add(union_fighting_main_city_update_state_terminal)
        state_machine.add(union_fighting_main_city_update_hurt_terminal)
        state_machine.add(union_fighting_main_change_attack_state_terminal)
        state_machine.add(union_fighting_main_reset_fight_role_info_terminal)
        state_machine.add(union_fighting_main_change_fight_scene_info_terminal)
        state_machine.init()
    end
    init_union_fight_main_terminal()
end

function UnionFightingMain:sureBackFightUnion(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("union_fighting_main_close", 0, nil)
        end
    end
    if sure_number == 0 then
        protocol_command.union_stronghold_retreat.param_list = _ED.union.union_info.union_id.."\r\n"..self._mainCityInfo.city_id
        NetworkManager:register(protocol_command.union_stronghold_retreat.code, nil, nil, nil, nil, responseCallback, false, nil)
    end
end

function UnionFightingMain:sureChangeAttackState(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("union_fighting_main_change_fight_scene_info", 0, nil)
        end
    end
    if sure_number == 0 then
        protocol_command.union_stronghold_battle_switch.param_list = _ED.union.union_info.union_id.."\r\n"..self._mainCityInfo.city_id
        NetworkManager:register(protocol_command.union_stronghold_battle_switch.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function UnionFightingMain:sureCleanAttackCD(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                -- response.node:updateDraw()
            end
        end
    end

    if sure_number == 0 then
        protocol_command.union_stronghold_clear_match_cd.param_list = _ED.union.union_info.union_id.."\r\n"..self._mainCityInfo.city_id
        NetworkManager:register(protocol_command.union_stronghold_clear_match_cd.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function UnionFightingMain:beginAttack( isNeedTickOut, params )
    local root = self.roots[1]
    local fightCount = #_ED.union_fight_city_round_battle_info
    for i,round_info in pairs(_ED.union_fight_city_round_battle_info) do
        local chooseAttack = nil
        local chooseDefend = nil
        if params == true then
            chooseAttack = self._attack_formation_roles[i][1]
            chooseDefend = self._defend_formation_roles[i][1]
        else
            if self._myIsAttacker == true then
                if fightCount == 3 and i == 1 then
                    chooseAttack = self._attack_formation_roles[i][2]
                    chooseDefend = self._defend_formation_roles[i][1]
                else
                    chooseAttack = self._attack_formation_roles[i + 1][1]
                    chooseDefend = self._defend_formation_roles[i + 1][1]
                end
            else
                if fightCount == 3 and i == 1 then
                    chooseAttack = self._attack_formation_roles[i][1]
                    chooseDefend = self._attack_formation_roles[i][2]
                else
                    chooseAttack = self._attack_formation_roles[i + 1][1]
                    chooseDefend = self._defend_formation_roles[i + 1][1]
                end
            end
        end
        chooseAttack:beginAttackMove(round_info.attacker_name, round_info.attacker_union_name, round_info.result, i)
        chooseDefend:beginAttackMove(round_info.defender_name, round_info.defender_union_name, round_info.result, i)

        if round_info.isMyBattle == true then
            if fwin:find("UnionFightingResultClass") == nil then
                state_machine.excute("union_fighting_one_battle_result_open", 0, {isNeedTickOut, round_info})
            end
            if isNeedTickOut == false then
                state_machine.excute("union_fighting_main_city_update_kill_nums")
            end
        end

        local function delayEndFuncN( sender )
            self:moveRoleAfterAttack(i)
        end
        local actions = {}
        table.insert(actions, cc.DelayTime:create(0.3))
        table.insert(actions, cc.CallFunc:create(delayEndFuncN))
        self:runAction(cc.Sequence:create(actions))
    end
end

function UnionFightingMain:sortFormationIndex( index )
    local function sortFun( a, b )
        return tonumber(a._formation_index) < tonumber(b._formation_index)
    end
    table.sort(self._attack_formation_roles[index], sortFun)
    table.sort(self._defend_formation_roles[index], sortFun)
    for k,v in pairs(self._attack_formation_roles[index]) do
        v._formation_index = k
        if index == 1 then
            v:updateMySelfInfo(k, self._myIsAttacker, true)
        end
    end
    for k,v in pairs(self._defend_formation_roles[index]) do
        v._formation_index = k
        if index == 1 then
            v:updateMySelfInfo(k, self._myIsAttacker, false)
        end
    end
    self:moveRoleAfterAttack(index)
end

function UnionFightingMain:moveRoleAfterAttack( index )
    local currentAttackCount = 0
    -- 当前占位队列人数
    for k,v in pairs(self._attack_formation_roles) do
        for k1,v1 in pairs(v) do
            if v1:checkIsWait() == true then
                currentAttackCount = currentAttackCount + 1
            end
        end 
    end
    local myUnionAttackCount = tonumber(_ED.union_fight_city_info.attacker_nums)
    local addRoleCount = myUnionAttackCount - currentAttackCount
    local attack_list = self._attack_formation_roles[index]
    -- 攻击队列需要补充人
    if addRoleCount > 0 then
        local moveIndex = 1
        for k,v in pairs(attack_list) do
            if v:checkIsAttack() ~= true then
                if v:checkIsFree() == true then
                    addRoleCount = addRoleCount - 1
                end
                v:attackEndMove(moveIndex)
                moveIndex = moveIndex + 1
                if addRoleCount == 0 then
                    break
                end
            end
        end
    -- 攻击队列不需要补充人
    elseif addRoleCount == 0 then
        local moveIndex = 1
        for k,v in pairs(attack_list) do
            if v:checkIsWait() == true then
                v:attackEndMove(moveIndex)
                moveIndex = moveIndex + 1
            end
        end
    else
        -- 攻击队列需要踢出人
        local leaveCount = 0
        for i=1,3 do
            local attackTeam = self._attack_formation_roles[4-i]
            for j=1,3 do
                local attackRole = attackTeam[4-j]
                if attackRole:checkIsWait() == true then
                    attackRole:leaveFightScene()
                    leaveCount = leaveCount + 1
                    break
                end
            end
            if leaveCount == currentAttackCount - myUnionAttackCount then
                break
            end
        end
    end
    local currentDefendCount = 0
    -- 当前占位队列人数
    for k,v in pairs(self._defend_formation_roles) do
        for k1,v1 in pairs(v) do
            if v1:checkIsWait() == true then
                currentDefendCount = currentDefendCount + 1
            end
        end 
    end
    local defendCount = tonumber(_ED.union_fight_city_info.defend_nums) + tonumber(_ED.union_fight_city_info.defend_npc_nums)
    addRoleCount = defendCount - currentDefendCount
    local defend_list = self._defend_formation_roles[index]
    -- 防守队列需要补充人
    if addRoleCount > 0 then
        local moveIndex = 1
        for k,v in pairs(defend_list) do
            if v:checkIsAttack() ~= true then
                if v:checkIsFree() == true then
                    addRoleCount = addRoleCount - 1
                end
                v:attackEndMove(moveIndex)
                moveIndex = moveIndex + 1
                if addRoleCount == 0 then
                    break
                end
            end
        end
    -- 防守队列不需要补充人
    elseif addRoleCount == 0 then
        local moveIndex = 1
        for k,v in pairs(defend_list) do
            if v:checkIsWait() == true then
                v:attackEndMove(moveIndex)
                moveIndex = moveIndex + 1
            end
        end
    else
        -- 防守队列需要踢出人
        local leaveCount = 0
        for i=1,3 do
            local defendTeam = self._defend_formation_roles[4-i]
            for j=1,3 do
                local defendRole = defendTeam[4-j]
                if defendRole:checkIsWait() == true then
                    defendRole:leaveFightScene()
                    leaveCount = leaveCount + 1
                    break
                end
            end
            if leaveCount == currentDefendCount - defendCount then
                break
            end
        end
    end
end

function UnionFightingMain:playHurtAnimation( params )
    local index = params[1]
    local hurt = math.ceil(params[2])
    local nodeNumber = csb.createNode(config_csb.battle.battle_text_1)
    local root = nodeNumber:getChildByName("root")
    local BitmapFontLabel_blood = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_blood")
    BitmapFontLabel_blood:setString(""..hurt)
    nodeNumber:setPosition(_union_fight_center_move_pos[index][1] + root:getContentSize().width/2, _union_fight_center_move_pos[index][2])
    self:addChild(nodeNumber)

    local action = csb.createTimeline(config_csb.battle.battle_text_1)
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

function UnionFightingMain:updateKillNums( isFrist )
    if self._lastKillNums == _ED.union_fight_city_user_info.total_kill_nums then
        return
    end
    self._lastKillNums = _ED.union_fight_city_user_info.total_kill_nums
    local root = self.roots[1]
    local Panel_injury = ccui.Helper:seekWidgetByName(root, "Panel_injury")
    Panel_injury:removeAllChildren(true)
    local armature = ccs.Armature:create("effect_lianjijiacheng")
    draw.initArmature(armature, nil, 1, 0, 1)
    local function changeActionCallback( armatureBack )
        -- armatureBack:removeFromParent(true)
        -- armatureBack:pause()
    end
    armature._invoke = changeActionCallback
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    local frist_number = 0
    local second_number = 0
    if _ED.union_fight_city_user_info.total_kill_nums > 9 then
        frist_number = math.floor(_ED.union_fight_city_user_info.total_kill_nums/10)
        second_number = _ED.union_fight_city_user_info.total_kill_nums%10
    else
        second_number = _ED.union_fight_city_user_info.total_kill_nums
    end
    if frist_number == 0 then
        frist_number = 10
    end
    local fristIconName = string.format("images/ui/play/big_map/lianjishuzi_%s.png", frist_number)
    local fristIcon = ccs.Skin:create(fristIconName)
    armature:getBone("shuzi_2"):addDisplay(fristIcon, 0)

    local secondIconName = string.format("images/ui/play/big_map/lianjishuzi_%s.png", second_number)
    local secondIcon = ccs.Skin:create(secondIconName)
    armature:getBone("shuzi_1"):addDisplay(secondIcon, 0)
    if isFrist == true then
        csb.animationChangeToAction(armature, 1, 1, false)
    else
        csb.animationChangeToAction(armature, 0, 0, false)
    end
    Panel_injury:addChild(armature)

    local sound = dms.int(dms["sound_effect_param"], 43, sound_effect_param.special_effect)
    if sound > 0 then
        playEffectMusic(sound)
    end
end

function UnionFightingMain:onUpdateDrawFormation()
    local root = self.roots[1]
    local ListView_battle_role = ccui.Helper:seekWidgetByName(root, "ListView_battle_role")
    ListView_battle_role:removeAllItems()
    local nCount = 0
    local width = 0
    for k,v in pairs(_ED.union_fight_city_my_formations) do
        if v ~= nil then
            local cell = state_machine.excute("battle_ui_icon_cell",0,{v})
            ListView_battle_role:addChild(cell)
            nCount = nCount + 1
            width = width + cell:getContentSize().width
        end
    end
    local listViewSize = ListView_battle_role:getContentSize()
    ListView_battle_role:setPositionX(self._ListView_battle_role_posX + (listViewSize.width - width) / 2)
end

function UnionFightingMain:updateDraw()
    self._mainCityInfo = _ED.union_stronghold_info_list[""..self._mainCityInfo.city_id]
	local root = self.roots[1]
    local Text_build_name_1 = ccui.Helper:seekWidgetByName(root, "Text_build_name_1")
    local Text_build_name_2 = ccui.Helper:seekWidgetByName(root, "Text_build_name_2")
    local Text_player_n_1 = ccui.Helper:seekWidgetByName(root, "Text_player_n_1")
    local Text_player_n_2 = ccui.Helper:seekWidgetByName(root, "Text_player_n_2")
    local Text_npc_n_2 = ccui.Helper:seekWidgetByName(root, "Text_npc_n_2")
    local Text_vs_t = ccui.Helper:seekWidgetByName(root, "Text_vs_t")
    self.Image_mach = ccui.Helper:seekWidgetByName(root, "Image_mach")
    self.Text_battle_time_n = ccui.Helper:seekWidgetByName(root, "Text_battle_time_n")
    self.Text_stand_time_n = ccui.Helper:seekWidgetByName(root, "Text_stand_time_n")
    self.Panel_stand_mach = ccui.Helper:seekWidgetByName(root, "Panel_stand_mach")
    self.Panel_19 = ccui.Helper:seekWidgetByName(root, "Panel_19")
    self.Image_mach:setVisible(false)
    self.Panel_19:setVisible(false)
    if tonumber(self._mainCityInfo.union_id) == 0 then
        local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self._mainCityInfo.city_id, warfare_map_mould.city_name)
        Text_build_name_2:setString(string.format(tipStringInfo_union_str[114], city_name))
    else
        Text_build_name_2:setString(self._mainCityInfo.union_name)
    end
    self.Text_battle_time_n:setString(self:formatTimeString(_ED.union_fight_city_info.attack_cd_time))
    self._tickTime = tonumber(_ED.union_fight_city_info.attack_cd_time)/1000
    self._beginWaitTime = tonumber(_ED.union_fight_city_info.begin_cd_time)/1000
    if self._beginWaitTime <= 0 then
        self.Panel_19:setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_retueat"):setVisible(true)
        self._isBegined = true
    else
        ccui.Helper:seekWidgetByName(root, "Button_retueat"):setVisible(false)
    end

    self._myIsAttacker = true

    ccui.Helper:seekWidgetByName(root, "Button_change"):setTouchEnabled(true)
    Text_vs_t:setString(tipStringInfo_union_str[110])
    -- for k,v in pairs(_ED.union_fight_city_info.defend_list) do
    --     if tonumber(v.union_id) == tonumber(_ED.union.union_info.union_id) then
    --         ccui.Helper:seekWidgetByName(root, "Button_change"):setTouchEnabled(false)
    --         Text_vs_t:setString(tipStringInfo_union_str[111])
    --     end
    -- end
    if tonumber(self._mainCityInfo.union_id) == tonumber(_ED.union.union_info.union_id) then
        self._myIsAttacker = false
    end

    local defend_role_list = {}
    local attack_other_list = {}
    local attack_role_list = {}
    local defend_npc_count = 0
    local attack_count = 0
    local attack_union_name = ""
    local leftList = {}
    local rightList = {}

    self._attack_union_team_info_list = {}
    self._defend_union_team_info_list = {}

    if self._myIsAttacker == true then
        for k,v in pairs(_ED.union_fight_city_info.defend_list) do
            if tonumber(v.union_id) == 0 then
                defend_npc_count = defend_npc_count + 1
                table.insert(self._defend_union_team_info_list, v)
            elseif tonumber(v.union_id) == tonumber(self._mainCityInfo.union_id) then
                table.insert(defend_role_list, v)
                table.insert(self._defend_union_team_info_list, v)
            elseif tonumber(v.union_id) == tonumber(_ED.union.union_info.union_id) then
                table.insert(attack_role_list, v)
                table.insert(self._attack_union_team_info_list, v)
            else
                table.insert(attack_other_list, v)
            end
        end
        for k,v in pairs(_ED.union_fight_city_info.attacker_list) do
            if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                if tonumber(v.attack_state) == 0 then
                    ccui.Helper:seekWidgetByName(root, "Button_change"):setTouchEnabled(true)
                    Text_vs_t:setString(tipStringInfo_union_str[110])
                else
                    ccui.Helper:seekWidgetByName(root, "Button_change"):setTouchEnabled(false)
                    Text_vs_t:setString(tipStringInfo_union_str[111])
                end
            end
            if tonumber(v.union_id) == tonumber(_ED.union.union_info.union_id) then
                table.insert(attack_role_list, v)
                table.insert(self._attack_union_team_info_list, v)
            else
                table.insert(attack_other_list, v)
            end
        end
        attack_count = #attack_role_list
        attack_union_name = _ED.union.union_info.union_name
    else
        ccui.Helper:seekWidgetByName(root, "Button_change"):setTouchEnabled(false)
        Text_vs_t:setString(tipStringInfo_union_str[111])
        for k,v in pairs(_ED.union_fight_city_info.defend_list) do
            if tonumber(v.union_id) == 0 then
                defend_npc_count = defend_npc_count + 1
                table.insert(self._defend_union_team_info_list, v)
            elseif tonumber(v.union_id) == tonumber(_ED.union.union_info.union_id) then
                table.insert(defend_role_list, v)
                table.insert(self._defend_union_team_info_list, v)
            else
                table.insert(attack_role_list, v)
                table.insert(self._attack_union_team_info_list, v)
            end
        end
        for k,v in pairs(_ED.union_fight_city_info.attacker_list) do
            table.insert(attack_role_list, v)
            table.insert(self._attack_union_team_info_list, v)
        end
        local record_attack_union_id = 0
        for k,v in pairs(attack_role_list) do
            if record_attack_union_id == 0 then
                record_attack_union_id = tonumber(v.union_id)
                attack_union_name = v.union_name
                attack_count = attack_count + 1
            elseif record_attack_union_id == tonumber(v.union_id) then
                attack_count = attack_count + 1
            end
        end
    end

    local function sortFun( a, b )
        return tonumber(a.union_id) > tonumber(b.union_id)
    end
    table.sort(self._defend_union_team_info_list, sortFun)

    rightList = defend_role_list
    if self._myIsAttacker == true then
        if #attack_role_list > 0 then
            if leftList[""..attack_role_list[1].union_id] == nil then
                leftList[""..attack_role_list[1].union_id] = {}
            end
            table.insert(leftList[""..attack_role_list[1].union_id], attack_role_list[1])
        end
        for k,v in pairs(attack_other_list) do
            if leftList[""..v.union_id] == nil then
                leftList[""..v.union_id] = {}
            end
            table.insert(leftList[""..v.union_id], v)
        end
    else
        for k,v in pairs(attack_role_list) do
            if leftList[""..v.union_id] == nil then
                leftList[""..v.union_id] = {}
            end
            table.insert(leftList[""..v.union_id], v)
        end
    end

    Text_player_n_2:setString(#defend_role_list)
    Text_build_name_1:setString(attack_union_name)
    Text_player_n_1:setString(attack_count)
    Text_npc_n_2:setString(defend_npc_count)

    self:updateOtherUnionTeam(leftList, rightList)
    self:onUpdateDrawFormation()
    -- 更新战场角色占位
    self:updateDrawBattleSceneFormation()
    if #self._attack_union_team_info_list == 0 then
        for row = 1, 2 do
            for column = 1, 3 do
                local tattacker = self._attacker_formation_roles[row][column]
                if nil ~= tattacker then
                    tattacker._formation_index = (row - 1) * 3 + column
                    tattacker._formation_row = row
                    tattacker._formation_column = column

                    self._attacker_formation_roles[row][column] = nil
                    tattacker:setVisible(false)
                    tattacker:setPosition(cc.p(_union_fight_left_move_pos[tattacker._formation_index][1], _union_fight_left_move_pos[tattacker._formation_index][2]))
                    for i, v in pairs(self._attacker_roles) do
                        if v == tattacker then
                            table.remove(self._attacker_roles, i, 1)
                            table.insert(self._attacker_free_roles, v)
                            break
                        end
                    end
                end
            end
        end
    end
end

function UnionFightingMain:updateOtherUnionTeam( leftList, rightList )
    local root = self.roots[1]
    local Panel_field = ccui.Helper:seekWidgetByName(root, "Panel_field")
    local Panel_field_0 = ccui.Helper:seekWidgetByName(root, "Panel_field_0")
    if Panel_field:getChildByName("list_panel") ~= nil then
        state_machine.excute("union_fighting_left_union_team_update_info", 0, leftList)
    else
        local left_team = state_machine.excute("union_fight_left_union_team_open", 0, leftList)
        left_team:setName("list_panel")
        Panel_field:addChild(left_team)
    end

    if Panel_field_0:getChildByName("list_panel") ~= nil then
        state_machine.excute("union_fighting_right_union_team_update_info", 0, rightList)
    else
        local right_team = state_machine.excute("union_fight_right_union_team_open", 0, rightList)
        right_team:setName("list_panel")
        Panel_field_0:addChild(right_team)
    end
end

function UnionFightingMain:changeUnionFightState( ... )
    local root = self.roots[1]
    local Panel_stand = ccui.Helper:seekWidgetByName(root, "Panel_stand")
    local Panel_battle = ccui.Helper:seekWidgetByName(root, "Panel_battle")
    local Text_battle_standy_time_n = ccui.Helper:seekWidgetByName(root, "Text_battle_standy_time_n")
    local Text_battle_time_n = ccui.Helper:seekWidgetByName(root, "Text_battle_time_n")
    if self._beginWaitTime <= 0 then
        Panel_battle:setVisible(true)
        Panel_stand:setVisible(false)
        Text_battle_time_n:setString(self:formatTimeString(self._tickTime))
    else
        Panel_battle:setVisible(false)
        Panel_stand:setVisible(true)
        Text_battle_standy_time_n:setString(self:formatTimeString(self._beginWaitTime))
    end
end

function UnionFightingMain:onUpdate( dt )
    if self._draw_union_fight_city_round_battle_info_wait_cd > 0 then
        self._draw_union_fight_city_round_battle_info_wait_cd = self._draw_union_fight_city_round_battle_info_wait_cd - dt
        if self._draw_union_fight_city_round_battle_info_wait_cd <= 0 then
            if self._draw_union_fight_city_round_battle_info_count > 0 then
                self._draw_union_fight_city_round_battle_info_count = 0
            end
        end
    end
    if self._draw_union_fight_city_round_battle_info_count <= 0 then
        if self._is_start_attack == true then
            self._is_start_attack = false
            self:beginAttackExt()
        end
    end

    if self._is_update_draw == true then
        self._is_update_draw = false
        self:updateDraw()
    end

    local root = self.roots[1]
    if root == nil then
        return
    end
    self._tickTime = self._tickTime - dt
    self._beginWaitTime = self._beginWaitTime - dt

    _ED.union_fight_city_user_info.attack_wait_cd = _ED.union_fight_city_user_info.attack_wait_cd - dt
    _ED.union_fight_city_user_info.mach_wait_cd = _ED.union_fight_city_user_info.mach_wait_cd - dt
    -- 战斗持续时间
    if self._tickTime <= 0 then
        self._tickTime = 0
    end
    -- 战场开启战斗时间
    if self._beginWaitTime <= 0 and self._isBegined == false then
        self._isBegined = true
        state_machine.excute("union_fighting_begin_open", 0, nil)
        self.Panel_19:setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_retueat"):setVisible(true)
    end
    -- 攻击匹配时间
    if _ED.union_fight_city_user_info.mach_wait_cd <= 0 then
        _ED.union_fight_city_user_info.mach_wait_cd = 0
    end
    -- 攻击冷却时间
    if _ED.union_fight_city_user_info.attack_wait_cd <= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_cool_time_n"):setColor(union_fight_report_color[6])
        self._isNeedWaitAttackTimeEnd = false
        ccui.Helper:seekWidgetByName(root, "Panel_battle_cool"):setVisible(false)
    else
        local Text_cool_time_n = ccui.Helper:seekWidgetByName(root, "Text_cool_time_n")
        if _ED.union_fight_city_user_info.attack_wait_cd >= 60 then
            Text_cool_time_n:setColor(union_fight_report_color[7])
            self._isNeedWaitAttackTimeEnd = true
        end
        ccui.Helper:seekWidgetByName(root, "Panel_battle_cool"):setVisible(true)
        Text_cool_time_n:setString(self:formatTimeString(_ED.union_fight_city_user_info.attack_wait_cd))
    end
    self:changeUnionFightState()
    if _ED.union_fight_city_user_info.mach_wait_cd > 0 then
        self.Panel_stand_mach:setVisible(true)
        self.Image_mach:setVisible(true)
        self.Text_stand_time_n:setString(self:formatTimeString(_ED.union_fight_city_user_info.mach_wait_cd))
        self._Button_attack:setColor(union_fight_report_color[8])
        self._Button_attack:setTouchEnabled(false)
    else
        self.Image_mach:setVisible(false)
        self.Panel_stand_mach:setVisible(false)
        self._Button_attack:setColor(union_fight_report_color[9])
        self._Button_attack:setTouchEnabled(true)
    end

    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function UnionFightingMain:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function UnionFightingMain:updateNpc()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self._attack_formation_roles = {{}, {}, {}}
    self._defend_formation_roles = {{}, {}, {}}

    self._attack_roles = {}
    self._defend_roles = {}
    local Panel_bg = ccui.Helper:seekWidgetByName(root, "Panel_bg")
    Panel_bg:removeAllChildren(true)

    for i=1, 9 do
        local attacker_role = _ED.union_fight_city_info.attacker_list[i]
        local defend_role = _ED.union_fight_city_info.defend_list[i]
        local gender = "1"
        if i == 1 or (i >= 5 and i <= 7) then
            if tonumber(_ED.user_info.user_gender) == 1 then
                gender = "1"
            else
                gender = "2"
            end
        else
            if tonumber(_ED.user_info.user_gender) == 1 then
                gender = "2"
            else
                gender = "1"
            end
        end
        local attack_role = state_machine.excute("union_fighting_role_create", 0, {attacker_role, true, i, self._myIsAttacker, gender})
        Panel_bg:addChild(attack_role)
        local defend_role = state_machine.excute("union_fighting_role_create", 0, {defend_role, false, i, self._myIsAttacker, gender})
        Panel_bg:addChild(defend_role)
        if i == 1 or i == 4 or i == 7 then
            table.insert(self._attack_formation_roles[1], attack_role)
            table.insert(self._defend_formation_roles[1], defend_role)
        elseif i == 2 or i == 5 or i == 8 then
            table.insert(self._attack_formation_roles[2], attack_role)
            table.insert(self._defend_formation_roles[2], defend_role)
        else
            table.insert(self._attack_formation_roles[3], attack_role)
            table.insert(self._defend_formation_roles[3], defend_role)
        end 
    end
end

-- 初始化战场角色
function UnionFightingMain:initBattleSceneRoles()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_bg = ccui.Helper:seekWidgetByName(root, "Panel_bg")
    Panel_bg:removeAllChildren(true)
    for i = 1, 9 do
        -- local attacker_info = _ED.union_fight_city_info.attacker_list[i]
        -- local defender_info = _ED.union_fight_city_info.defend_list[i]
        local attacker_info = self._attack_union_team_info_list[i]
        local defender_info = self._defend_union_team_info_list[i]
        local attacker = state_machine.excute("union_fighting_role_create", 0, {attacker_info, true, i, false, math.random(1, 2)})
        Panel_bg:addChild(attacker)

        local defender = state_machine.excute("union_fighting_role_create", 0, {defender_info, false, i, false, math.random(1, 2)})
        Panel_bg:addChild(defender)

        local row = math.modf((i - 1) / 3 + 1)
        local column = (i -  1) % 3 + 1

        attacker._formation_index = i
        attacker._formation_row = row
        attacker._formation_column = column

        defender._formation_index = i
        defender._formation_row = row
        defender._formation_column = column

        if row < 3 then
            if nil ~= attacker_info then
                self._attacker_formation_roles[row][column] = attacker
                table.insert(self._attacker_roles, attacker)
            else
                table.insert(self._attacker_free_roles, attacker)
            end
            if nil ~= defender_info then
                self._defender_formation_roles[row][column] = defender
                table.insert(self._defender_roles, defender)
            else
                table.insert(self._defender_free_roles, defender)
            end
        else
            table.insert(self._attacker_free_roles, attacker)
            table.insert(self._defender_free_roles, defender)
        end
    end

    -- 查找自己
    -- for i, v in pairs(_ED.union_fight_city_info.attacker_list) do
    for i, v in pairs(self._attack_union_team_info_list) do
        if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
            local attacker = self._attacker_formation_roles[1][1]
            state_machine.excute("union_fight_role_update_draw_info", 0, {attacker, v})
            break
        end
    end

    -- for i, v in pairs(_ED.union_fight_city_info.defend_list) do
    for i, v in pairs(self._defend_union_team_info_list) do
        if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
            local attacker = self._defender_formation_roles[1][1]
            state_machine.excute("union_fight_role_update_draw_info", 0, {attacker, v})
            break
        end
    end
end

-- 更新战场站位
function UnionFightingMain:updateDrawBattleSceneFormation()
    -- print("-=-=-=======updateDrawBattleSceneFormation===========")
    -- debug.print_r(self._attacker_formation_roles)
    -- debug.print_r(self._defender_formation_roles)
    -- print("防守方角色被移除33333", #self._defender_free_roles, #self._defender_roles)
    for row = 1, 2 do
        for column = 1, 3 do
            if nil == self._attacker_formation_roles[row][column] then
                local role = nil
                if row == 1 then
                    role = self._attacker_formation_roles[row + 1][column]
                end
                if nil == role then
                    -- role = table.remove(self._attacker_free_roles, 1)
                else
                    -- role:setPositionX(_union_fight_left_move_pos[3][1])
                    self._attacker_formation_roles[row + 1][column] = nil
                end
                if nil ~= role then
                    role._formation_index = (row - 1) * 3 + column
                    role._formation_row = row
                    role._formation_column = column
                    -- table.insert(self._attacker_roles, role)
                    self._attacker_formation_roles[row][column] = role
                    state_machine.excute("union_fight_role_update_draw_role_move", 0, {role, nil, _union_fight_left_move_pos[role._formation_index][1], _union_fight_left_move_pos[role._formation_index][2]})
                end
            end
            if nil == self._defender_formation_roles[row][column] then
                local role = nil
                if row == 1 then
                    role = self._defender_formation_roles[row + 1][column]
                end
                if nil == role then
                    -- role = table.remove(self._defender_free_roles, 1)
                else
                    -- role:setPositionX(_union_fight_right_move_pos[3][column])
                    self._defender_formation_roles[row + 1][column] = nil
                end
                if nil ~= role then
                    role._formation_index = (row - 1) * 3 + column
                    role._formation_row = row
                    role._formation_column = column
                    -- table.insert(self._defender_roles, role)
                    self._defender_formation_roles[row][column] = role
                    state_machine.excute("union_fight_role_update_draw_role_move", 0, {role, nil, _union_fight_right_move_pos[role._formation_index][1], _union_fight_right_move_pos[role._formation_index][2]})
                end
            end
        end
    end
    local attackerCount = #self._attacker_roles
    local defenderCount = #self._defender_roles
    -- print(attackerCount, defenderCount, #self._attack_union_team_info_list, #self._defend_union_team_info_list)
    local index = 1
    for row = 1, 2 do
        for column = 1, 3 do
            -- local attacker_info = _ED.union_fight_city_info.attacker_list[attackerCount + index]
            -- local defender_info = _ED.union_fight_city_info.defend_list[defenderCount + index]
            local attacker_info = self._attack_union_team_info_list[attackerCount + index]
            local defender_info = self._defend_union_team_info_list[defenderCount + index]
            if nil ~= attacker_info and nil == self._attacker_formation_roles[row][column] then
                local role = nil
                if row == 1 then
                    role = self._attacker_formation_roles[row + 1][column]
                end
                if nil == role then
                    role = table.remove(self._attacker_free_roles, 1)
                    if nil ~= role then
                        table.insert(self._attacker_roles, role)
                        role:setPositionY(_union_fight_left_move_pos[1][2])
                    end
                else
                    -- role:setPositionX(_union_fight_left_move_pos[3][1])
                    self._attacker_formation_roles[row + 1][column] = nil
                end
                if nil ~= role then
                    role._formation_index = (row - 1) * 3 + column
                    role._formation_row = row
                    role._formation_column = column
                    -- table.insert(self._attacker_roles, role)
                    self._attacker_formation_roles[row][column] = role
                    state_machine.excute("union_fight_role_update_draw_role_move", 0, {role, nil, _union_fight_left_move_pos[role._formation_index][1], _union_fight_left_move_pos[role._formation_index][2]})
                end
            end
            if nil ~= defender_info and nil == self._defender_formation_roles[row][column] then
                local role = nil
                if row == 1 then
                    role = self._defender_formation_roles[row + 1][column]
                end
                if nil == role then
                    role = table.remove(self._defender_free_roles, 1)
                    if nil ~= role then
                        table.insert(self._defender_roles, role)
                        role:setPositionY(_union_fight_right_move_pos[1][2])
                    end
                else
                    -- role:setPositionX(_union_fight_right_move_pos[3][column])
                    self._defender_formation_roles[row + 1][column] = nil
                end
                if nil ~= role then
                    role._formation_index = (row - 1) * 3 + column
                    role._formation_row = row
                    role._formation_column = column
                    -- table.insert(self._defender_roles, role)
                    self._defender_formation_roles[row][column] = role
                    state_machine.excute("union_fight_role_update_draw_role_move", 0, {role, nil, _union_fight_right_move_pos[role._formation_index][1], _union_fight_right_move_pos[role._formation_index][2]})
                end
            end
            index = index + 1
        end
    end

    -- print(#self._attacker_roles, #self._defender_roles, #self._attacker_free_roles, #self._defender_free_roles)

    -- local row = 1
    -- local column = 1
    -- if nil == self._attacker_formation_roles[row][column] then
    --     local role = nil
    --     if row == 1 then
    --         role = self._attacker_formation_roles[row + 1][column]
    --     end
    --     if nil == role then
    --         role = table.remove(self._attacker_free_roles, 1)
    --         if nil ~= role then
    --             table.insert(self._attacker_roles, role)
    --             role:setPositionY(_union_fight_left_move_pos[1][2])
    --         end
    --     else
    --         -- role:setPositionX(_union_fight_left_move_pos[3][1])
    --         self._attacker_formation_roles[row + 1][column] = nil
    --     end
    --     if nil ~= role then
    --         role._formation_index = (row - 1) * 3 + column
    --         role._formation_row = row
    --         role._formation_column = column
    --         -- table.insert(self._attacker_roles, role)
    --         self._attacker_formation_roles[row][column] = role
    --         state_machine.excute("union_fight_role_update_draw_role_move", 0, {role, nil, _union_fight_left_move_pos[role._formation_index][1], _union_fight_left_move_pos[role._formation_index][2]})
    --     end
    -- end
    -- if nil == self._defender_formation_roles[row][column] then
    --     local role = nil
    --     if row == 1 then
    --         role = self._defender_formation_roles[row + 1][column]
    --     end
    --     if nil == role then
    --         role = table.remove(self._defender_free_roles, 1)
    --         if nil ~= role then
    --             table.insert(self._defender_roles, role)
    --             role:setPositionY(_union_fight_right_move_pos[1][2])
    --         end
    --     else
    --         -- role:setPositionX(_union_fight_right_move_pos[3][column])
    --         self._defender_formation_roles[row + 1][column] = nil
    --     end
    --     if nil ~= role then
    --         role._formation_index = (row - 1) * 3 + column
    --         role._formation_row = row
    --         role._formation_column = column
    --         -- table.insert(self._defender_roles, role)
    --         self._defender_formation_roles[row][column] = role
    --         state_machine.excute("union_fight_role_update_draw_role_move", 0, {role, nil, _union_fight_right_move_pos[role._formation_index][1], _union_fight_right_move_pos[role._formation_index][2]})
    --     end
    -- end

    -- -- 查找自己
    -- -- for i, v in pairs(_ED.union_fight_city_info.attacker_list) do
    -- for i, v in pairs(self._attack_union_team_info_list) do
    --     if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
    --         local attacker = self._attacker_formation_roles[1][1]
    --         state_machine.excute("union_fight_role_update_draw_info", 0, {attacker, v})
    --         break
    --     end
    -- end

    -- -- for i, v in pairs(_ED.union_fight_city_info.defend_list) do
    -- for i, v in pairs(self._defend_union_team_info_list) do
    --     if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
    --         local attacker = self._defender_formation_roles[1][1]
    --         state_machine.excute("union_fight_role_update_draw_info", 0, {attacker, v})
    --         break
    --     end
    -- end
end

function UnionFightingMain:beginAttackExt()
    -- print("-=-=-=======beginAttackExt===========", #_ED.union_fight_city_round_battle_info)
    self._draw_union_fight_city_round_battle_info_count = 0
    self._draw_union_fight_city_round_battle_info_wait_cd = self._draw_union_fight_city_round_battle_info_wait_time
    local formationIndex = 1
    for i, v in pairs(_ED.union_fight_city_round_battle_info) do
        local attacker_info = v
        local defender_info = v
        local attackerIndex = formationIndex
        local defenderIndex = formationIndex
        if formationIndex == 1 and v.isMyBattle == false then
            if self._myIsAttacker == true then
                attackerIndex = attackerIndex + 3
            else
                defenderIndex = defenderIndex + 3
            end
        end
        local attacker = self._attacker_formation_roles[1][attackerIndex]
        local defender = self._defender_formation_roles[1][defenderIndex]
        if attacker == nil then
            attacker = table.remove(self._attacker_free_roles, 1)
            table.insert(self._attacker_roles, attacker)

            local tattacker = nil
            for c = 1, 2 do
                for r = 2, 3 do
                    if nil == tattacker then
                        tattacker = self._attacker_formation_roles[r][c]
                        if tattacker ~= nil then
                            self._attacker_formation_roles[1][2] = nil
                            attacker:setPosition(cc.p(tattacker:getPosition()))
                            tattacker:setVisible(false)
                        end
                    end
                end
            end

            for i, v in pairs(self._attacker_roles) do
                if v == tattacker then
                    table.remove(self._attacker_roles, i, 1)
                    table.insert(self._attacker_free_roles, v)
                    break
                end
            end
        end
        if defender == nil then
            defender = table.remove(self._defender_free_roles, 1)
            table.insert(self._defender_roles, defender)
            local tdefender = nil
            for c = 1, 2 do
                for r = 2, 3 do
                    if nil == tdefender then
                        tdefender = self._attacker_formation_roles[r][c]
                        if tdefender ~= nil then
                            self._attacker_formation_roles[1][2] = nil
                            attacker:setPosition(cc.p(tdefender:getPosition()))
                            tdefender:setVisible(false)
                        end
                    end
                end
            end

            for i, v in pairs(self._defender_roles) do
                if v == tdefender then
                    table.remove(self._defender_roles, i, 1)
                    table.insert(self._defender_free_roles, v)
                    break
                end
            end
        end
        state_machine.excute("union_fight_role_update_draw_role_move_to_attack", 0, {attacker, attacker_info})
        state_machine.excute("union_fight_role_update_draw_role_move_to_attack", 0, {defender, defender_info})
        self._attacker_formation_roles[1][attackerIndex] = nil
        self._defender_formation_roles[1][defenderIndex] = nil
        formationIndex = formationIndex + 1
        self._draw_union_fight_city_round_battle_info_count = self._draw_union_fight_city_round_battle_info_count + 2
    end
    self:updateDrawBattleSceneFormation()

    
    local isNeedTickOut = false
    for k,v in pairs(_ED.union_fight_city_round_battle_info) do
        if v.isMyBattle == true then
            if tonumber(v.result) == 0 then
                if tonumber(v.attacker_id) == tonumber(_ED.user_info.user_id) then
                    isNeedTickOut = true
                end
            elseif tonumber(v.result) == 1 then
                if tonumber(v.defender_id) == tonumber(_ED.user_info.user_id) then
                    isNeedTickOut = true
                end
            end
        end
        if v.isMyBattle == true then
            if fwin:find("UnionFightingResultClass") == nil then
                state_machine.excute("union_fighting_one_battle_result_open", 0, {isNeedTickOut, v})
            end
            if isNeedTickOut == false then
                state_machine.excute("union_fighting_main_city_update_kill_nums")
            end
        end
    end
    _ED.union_fight_city_round_battle_info = nil
end

function UnionFightingMain:sortFormationIndexExt(params)
    -- print("-=-=-=======sortFormationIndexExt===========", #_ED.union_fight_city_round_battle_info, params[1])
    self:removeAttacker(params[1], params[2])
end

function UnionFightingMain:removeAttacker(camp, role)
    self._draw_union_fight_city_round_battle_info_count = self._draw_union_fight_city_round_battle_info_count - 1
    if 0 == camp then
        for i, v in pairs(self._attacker_roles) do
            if v == role then
                -- print("攻击方角色被移除3", #self._attacker_free_roles, #self._attacker_roles)
                table.remove(self._attacker_roles, i, 1)
                table.insert(self._attacker_free_roles, v)
                -- print("攻击方角色被移除", #self._attacker_free_roles, #self._attacker_roles)
                break
            end
        end
    else
        for i, v in pairs(self._defender_roles) do
            if v == role then
                -- print("防守方角色被移除2", #self._defender_free_roles, #self._defender_roles)
                table.remove(self._defender_roles, i, 1)
                table.insert(self._defender_free_roles, v)
                -- print("防守方角色被移除", #self._defender_free_roles, #self._defender_roles)
                break
            end
        end
    end
    self:updateDrawBattleSceneFormation()

    -- 查找自己
    for i, v in pairs(_ED.union_fight_city_info.attacker_list) do
        if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
            local attacker = self._attacker_formation_roles[1][1]
            if nil ~= attacker then
                state_machine.excute("union_fight_role_update_draw_info", 0, {attacker, v})
            end
            break
        end
    end

    for i, v in pairs(_ED.union_fight_city_info.defend_list) do
        if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
            local defender = self._defender_formation_roles[1][1]
            if nil ~= defender then
                state_machine.excute("union_fight_role_update_draw_info", 0, {defender, v})
            end
            break
        end
    end

    if self._draw_union_fight_city_round_battle_info_count <= 0 then
        self._draw_union_fight_city_round_battle_info_count = 0
        self._draw_union_fight_city_round_battle_info_wait_cd = 0
        if _ED.union_fight_city_round_battle_info ~= nil then
            self._is_start_attack = true
        end
    end
end

function UnionFightingMain:updateBattleReport( ... )
    local root = self.roots[1]
    local ListView_battle_field = ccui.Helper:seekWidgetByName(root, "ListView_battle_field")
    ListView_battle_field:removeAllItems()
    
    if _ED.union_fight_city_report_list ~= nil then
        for k,v in pairs(_ED.union_fight_city_report_list) do
            local cell = state_machine.excute("union_fight_report_cell_create", 0, {v, k})
            ListView_battle_field:addChild(cell)
        end
        ListView_battle_field:requestRefreshView()
        self.listview = ListView_battle_field
        self.listview_poy = ListView_battle_field:getInnerContainer():getPositionY() 
        self.listview:getInnerContainer():setPositionY(500000)
    end
end

function UnionFightingMain:onInit()
    self:onLoad()

	local csbUnion = csb.createNode(config_csb.big_map.map_legion_battle)
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    -- local action = csb.createTimeline(config_csb.big_map.map_legion_battle)
    -- table.insert(self.actions, action)
    -- csbUnion:runAction(action)
    -- action:play("field_out", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "union_fighting_main_return_back_nationalMap", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        ntype = 1,
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_retueat"), nil, 
    {
        terminal_name = "union_fighting_main_return_back_nationalMap", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        ntype = 2,
    }, 
    nil, 0)

    self._Button_attack = ccui.Helper:seekWidgetByName(root, "Button_attack")
    fwin:addTouchEventListener(self._Button_attack, nil, 
    {
        terminal_name = "union_fighting_main_attack", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cool"), nil, 
    {
        terminal_name = "union_fighting_main_clean_attack_cd", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"), nil, 
    {
        terminal_name = "union_fighting_main_change_attack_state", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local ListView_battle_role = ccui.Helper:seekWidgetByName(root, "ListView_battle_role")
    self._ListView_battle_role_posX = ListView_battle_role:getPositionX()

	self:updateDraw()
    self:updateKillNums(true)
    -- self:updateNpc()
    self:updateBattleReport()
    self:initBattleSceneRoles()
end

function UnionFightingMain:onEnterTransitionFinish()
end

function UnionFightingMain:init(params)
    self._mainCityInfo = _ED.union_stronghold_info_list[""..params.city_id]
    self:onInit()
	return self
end

function UnionFightingMain:onLoad()
    local effect_paths = "images/ui/effice/effect_lianjijiacheng/effect_lianjijiacheng.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end

function UnionFightingMain:onExit()
    local effect_paths = "images/ui/effice/effect_lianjijiacheng/effect_lianjijiacheng.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
	state_machine.remove("union_fighting_main_attack")
    state_machine.remove("union_fighting_main_cancel_attack")
    state_machine.remove("union_fighting_main_clean_attack_cd")
    state_machine.remove("union_fighting_main_update_info")
    state_machine.remove("union_fighting_main_update_one_result")
    state_machine.remove("union_fighting_main_city_result")
    state_machine.remove("union_fighting_main_city_update_kill_nums")
    state_machine.remove("union_fighting_main_city_update_report")
    state_machine.remove("union_fighting_main_city_update_state")
    state_machine.remove("union_fighting_main_city_update_hurt")
    state_machine.remove("union_fighting_main_change_attack_state")
    state_machine.remove("union_fighting_main_reset_fight_role_info")
    state_machine.remove("union_fighting_main_change_fight_scene_info")
end
