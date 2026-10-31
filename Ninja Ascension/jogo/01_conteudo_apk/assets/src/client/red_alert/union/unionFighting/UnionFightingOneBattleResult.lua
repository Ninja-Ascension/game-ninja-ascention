UnionFightingOneBattleResult = class("UnionFightingOneBattleResultClass", Window)

local union_fighting_one_battle_result_open_terminal = {
    _name = "union_fighting_one_battle_result_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("union_fighting_one_battle_result_close", 0, nil)
        _ED.union_fight_city_attack_result_list = _ED.union_fight_city_attack_result_list or {}
        local isNeedTickOut = params[1]
        local result_info = params[2]
        local battleInfo = _ED.union_fight_city_attack_result_list[result_info.attacker_id.."v"..result_info.defender_id]
        if nil ~= battleInfo then
            _ED.union_fight_city_attack_result_list[result_info.attacker_id.."v"..result_info.defender_id] = nil
            fwin:open(UnionFightingOneBattleResult:new():init(battleInfo, isNeedTickOut), fwin._ui)
        else
            battleInfo = _ED.union_fight_city_attack_result_list[result_info.attacker_id.."v"..result_info.defender_npc_id]
            if battleInfo ~= nil then
                _ED.union_fight_city_attack_result_list[result_info.attacker_id.."v"..result_info.defender_npc_id] = nil
                fwin:open(UnionFightingOneBattleResult:new():init(battleInfo, isNeedTickOut), fwin._ui)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local union_fighting_one_battle_result_close_terminal = {
    _name = "union_fighting_one_battle_result_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionFightingOneBattleResultClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_one_battle_result_open_terminal)
state_machine.add(union_fighting_one_battle_result_close_terminal)
state_machine.init()

function UnionFightingOneBattleResult:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua file
    app.load("client.red_alert.cells.battle.battle_ui_icon_cell")

    self._result_info = nil
    self._isNeedTickOut = false

    local function init_union_fighting_one_battle_result_terminal()
        local union_fighting_one_battle_result_close_click_terminal = {
            _name = "union_fighting_one_battle_result_close_click",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.union_fight_city_result ~= nil then
                    state_machine.excute("union_fighting_result_open", 0, nil)
                else
                    if instance._isNeedTickOut == true then
                        state_machine.excute("union_fighting_main_close")
                        state_machine.excute("union_fighting_fail_open", 0, nil)
                    end
                end
                state_machine.excute("union_fighting_one_battle_result_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_one_battle_result_close_click_terminal)
    end
    init_union_fighting_one_battle_result_terminal()
end

function UnionFightingOneBattleResult:onUpdateDraw( ... )
    local root = self.roots[1]
    local Panel_settlement_role_l = ccui.Helper:seekWidgetByName(root, "Panel_settlement_role_l")
    local Panel_settlement_role_r = ccui.Helper:seekWidgetByName(root, "Panel_settlement_role_r")
    local ListView_role_head_l = ccui.Helper:seekWidgetByName(root, "ListView_role_head_l")
    local ListView_role_head_r = ccui.Helper:seekWidgetByName(root, "ListView_role_head_r")
    local Text_role_name_l = ccui.Helper:seekWidgetByName(root, "Text_role_name_l")
    local Text_role_lv_l = ccui.Helper:seekWidgetByName(root, "Text_role_lv_l")
    local Text_role_fight_l = ccui.Helper:seekWidgetByName(root, "Text_role_fight_l")
    local Text_role_name_r = ccui.Helper:seekWidgetByName(root, "Text_role_name_r")
    local Text_role_lv_r = ccui.Helper:seekWidgetByName(root, "Text_role_lv_r")
    local Text_role_fight_r = ccui.Helper:seekWidgetByName(root, "Text_role_fight_r")

    if self._isNeedTickOut == true then
        ccui.Helper:seekWidgetByName(root, "Panel_win"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_fail"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_win"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_fail"):setVisible(false)
    end

    local width = 0
    local ships = nil
    if tonumber(self._result_info.attacker_id) == tonumber(_ED.user_info.user_id) then
        Text_role_name_l:setString(self._result_info.attacker_name)
        Text_role_lv_l:setString(self._result_info.attacker_level)
        Text_role_fight_l:setString(self._result_info.attacker_combat_force)

        Text_role_name_r:setString(self._result_info.defender_name)
        Text_role_lv_r:setString(self._result_info.defender_level)
        Text_role_fight_r:setString(self._result_info.defender_combat_force)
    else
        Text_role_name_l:setString(self._result_info.defender_name)
        Text_role_lv_l:setString(self._result_info.defender_level)
        Text_role_fight_l:setString(self._result_info.defender_combat_force)

        Text_role_name_r:setString(self._result_info.attacker_name)
        Text_role_lv_r:setString(self._result_info.attacker_level)
        Text_role_fight_r:setString(self._result_info.attacker_combat_force)
    end

    local attackAnimationName = ""
    if tonumber(self._result_info.attacker_id) == tonumber(_ED.user_info.user_id) then
        ships = self._result_info.attacker_ships
        if tonumber(self._result_info.attacker_gender) == 1 then
            attackAnimationName = "images/face/big_head/big_head_1"
        else
            attackAnimationName = "images/face/big_head/big_head_2"
        end
    else
        ships = self._result_info.defender_ships
        if tonumber(self._result_info.defender_gender) == 1 then
            attackAnimationName = "images/face/big_head/big_head_1"
        else
            attackAnimationName = "images/face/big_head/big_head_2"
        end
    end

    local animation = sp.spine(attackAnimationName..".json", attackAnimationName..".atlas", 1, 0, nil, false, nil)
    animation:addAnimation(0, "animation", true)
    animation:setPosition(cc.p(Panel_settlement_role_l:getContentSize().width/2,Panel_settlement_role_l:getContentSize().height/2))
    Panel_settlement_role_l:addChild(animation)
    for i, v in pairs(ships) do   
        local lessHp = v.lessHp
        v.lessHp = lessHp + v.loseHp
        local cell = state_machine.excute("battle_ui_icon_cell",0,{v})
        v.lessHp = lessHp
        local tcell = cell
        state_machine.excute("battle_ui_icon_cell_update_hp", 0, {cell = tcell, role = nil, shipId = nil, hp = v.lessHp, maxHp = v.maxHp, animation = true, delayTime = 0.5})
        ListView_role_head_l:addChild(cell)
        width = width + cell:getContentSize().width
    end
    ListView_role_head_l:setPositionX(ListView_role_head_l:getPositionX() + (ListView_role_head_l:getContentSize().width - width) / 2)

    local defendAnimationName = ""
    width = 0
    if tonumber(self._result_info.attacker_id) == tonumber(_ED.user_info.user_id) then
        ships = self._result_info.defender_ships
        if tonumber(self._result_info.defender_gender) == 1 then
            defendAnimationName = "images/face/big_head/big_head_1"
        else
            defendAnimationName = "images/face/big_head/big_head_2"
        end
    else
        ships = self._result_info.attacker_ships
        if tonumber(self._result_info.attacker_gender) == 1 then
            defendAnimationName = "images/face/big_head/big_head_1"
        else
            defendAnimationName = "images/face/big_head/big_head_2"
        end
    end
    local animation1 = sp.spine(defendAnimationName..".json", defendAnimationName..".atlas", 1, 0, nil, false, nil)
    animation1:addAnimation(0, "animation", true)
    animation1:setPosition(cc.p(Panel_settlement_role_r:getContentSize().width/2,Panel_settlement_role_r:getContentSize().height/2))
    Panel_settlement_role_r:addChild(animation1)

    for i, v in pairs(ships) do
        local lessHp = v.lessHp
        v.lessHp = lessHp + v.loseHp
        local cell = state_machine.excute("battle_ui_icon_cell",0,{v})
        local tcell = cell
        v.lessHp = lessHp
        state_machine.excute("battle_ui_icon_cell_update_hp", 0, {cell = tcell, role = nil, shipId = nil, hp = v.lessHp, maxHp = v.maxHp, animation = true, delayTime = 0.5})
        ListView_role_head_r:addChild(cell)
        width = width + cell:getContentSize().width
    end
    ListView_role_head_r:setPositionX(ListView_role_head_r:getPositionX() + (ListView_role_head_r:getContentSize().width - width) / 2)
end

function UnionFightingOneBattleResult:onInit(params)
    local csbNode = csb.createNode(config_csb.big_map.map_legion_settlement_battle)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local action = csb.createTimeline(config_csb.big_map.map_legion_settlement_battle)
    -- action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)

    csbNode:runAction(action)
    action:play("window_open", false)

    local Panel_settlement = ccui.Helper:seekWidgetByName(root, "Panel_settlement")
    local ArmatureNode_effice = Panel_settlement:getChildByName("ArmatureNode_effice")
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_over" then
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_settlement_sure"), nil, 
            {
                terminal_name = "union_fighting_one_battle_result_close_click", 
                terminal_state = 0,
                isPressedActionEnabled = true
            }, 
            nil, 0)
        elseif str == "play" then
            local animation = ArmatureNode_effice:getAnimation()
            local animationEventCallFunc = function()
                ArmatureNode_effice:setVisible(false)
            end 
            animation:playWithIndex(0, 0, 0)
            animation:setMovementEventCallFunc(animationEventCallFunc)
        end
    end)

    self:onUpdateDraw()
    
end

function UnionFightingOneBattleResult:onEnterTransitionFinish()
end

function UnionFightingOneBattleResult:init(result_info, isNeedTickOut)
    self._result_info = result_info
    self._isNeedTickOut = isNeedTickOut
    self:onInit()
    return self
end

function UnionFightingOneBattleResult:onExit()
    state_machine.remove("union_fighting_one_battle_result_close_click")
end
