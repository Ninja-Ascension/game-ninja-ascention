FightRound = class("FightRoundClass", Window)

function FightRound:ctor()
    self.super:ctor()
    self.roots = {}

    self._currentRountCount = 0
    self._totalRoundCount = 0


    -- Initialize fight round page state machine.
    local function init_fight_round_terminal()
        -- 动画加速控制
        local fight_round_action_time_speed_terminal = {
            _name = "fight_round_action_time_speed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setTimeSpeed()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(fight_round_action_time_speed_terminal)
        state_machine.init()
    end

    -- call func init fight round state machine.
    init_fight_round_terminal()
end

function FightRound:init(currentRountCount, totalRoundCount)
    self._currentRountCount = currentRountCount
    self._totalRoundCount = totalRoundCount
    return self
end

function FightRound:setTimeSpeed()
    
end

function FightRound:updateDrawRountCount()
    local root = self.roots[1]

    local currentRountPanel = ccui.Helper:seekWidgetByName(root, "Panel_11")
    local totalRountPanel = ccui.Helper:seekWidgetByName(root, "Panel_12")
    currentRountPanel:setVisible(true)
    totalRountPanel:setVisible(true)
    currentRountPanel:removeBackGroundImage()
    totalRountPanel:removeBackGroundImage()

    local currentRountCount = math.min(5, self._currentRountCount)
    currentRountPanel:setBackGroundImage(string.format("images/ui/battle/boshu_%d.png", currentRountCount), 1)
    totalRountPanel:setBackGroundImage(string.format("images/ui/battle/boshu_%d.png", currentRountCount), 1)
end

function FightRound:onEnterTransitionFinish()
    local csbBattleReady = csb.createNode("battle/battle_ready.csb")
    local root = csbBattleReady:getChildByName("root")
    self:addChild(csbBattleReady)
    table.insert(self.roots, root)

    if __lua_project_id == __lua_project_l_naruto then
        if state_machine.excute("fight_attack_check_boss_instro",0,0) == false then
            local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
            local jsonFile = "sprite/effice_guochang.json"
            local atlasFile = "sprite/effice_guochang.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation" .. self._currentRountCount, true, nil)

            animation._self = self
            sp.initArmature(animation, false)
            local function changeActionCallback( armatureBack )
                armatureBack:setVisible(false)

                fwin:close(armatureBack._self)
                -- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 
                --     or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_213 
                --     then
                -- else
                    -- state_machine.excute("fight_attack_round_start", 0, "")
                    if state_machine.excute("fight_attack_check_boss_instro",0,0) == false then
                        state_machine.excute("fight_attack_round_start", 0, "")
                    end
                -- end
            end
            animation._invoke = changeActionCallback
            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            -- csb.animationChangeToAction(animation, 0, 1, false)
            Panel_2:addChild(animation)
        else
            fwin:addService({
                callback = function ( params )
                    fwin:close(params)
                end,
                delay = 0.6,
                params = self
            })
        end
    else
        self:updateDrawRountCount()

        local action = csb.createTimeline("battle/battle_ready.csb")
        action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)
        action:gotoFrameAndPlay(0, action:getDuration(), false)
        -- assert(action:IsAnimationInfoExists("in") == true, "in animation didn't exist")
        -- action:play("battle_ready_go", true)
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            --> print("FightRound str:", str)
            if str == "battle_ready_go_over" then
                --> print("关闭回合窗口。", self)
                fwin:close(self)
                -- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 
                --     or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_213
                --     then
                -- else
                    -- state_machine.excute("fight_attack_round_start", 0, "")
                    if state_machine.excute("fight_attack_check_boss_instro",0,0) == false then
                        state_machine.excute("fight_attack_round_start", 0, "")
                    end
                -- end
            end
        end)
        csbBattleReady:runAction(action)

        -- 播放回合开始的特效
        if __lua_project_id == __lua_project_gragon_tiger_gate 
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            or __lua_project_id == __lua_project_red_alert 
            or __lua_project_id == __lua_project_legendary_game 
            then
            local armaturePanel = ccui.Helper:seekWidgetByName(root, "Panel_2")
            local armature = armaturePanel:getChildByName("ArmatureNode_1")
            armature:getAnimation():playWithIndex(0, 0, 0)
            armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
        end
    end
    
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        playEffectMusic(9707)
    end
end

function FightRound:onExit()

end
