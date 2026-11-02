FightRoundOne = class("FightRoundOneClass", Window)

function FightRoundOne:ctor()
    self.super:ctor()
    self.roots = {}

    self._currentRountCount = 0
    self._totalRoundCount = 0


    -- Initialize fight round page state machine.
    local function init_fight_one_round_terminal()
        -- 动画加速控制
        local fight_round_one_action_time_speed_terminal = {
            _name = "fight_round_one_action_time_speed",
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
        state_machine.add(fight_round_one_action_time_speed_terminal)
        state_machine.init()
    end

    -- call func init fight round state machine.
    init_fight_one_round_terminal()
end

function FightRoundOne:init()
    return self
end

function FightRoundOne:setTimeSpeed()
    
end


function FightRoundOne:onEnterTransitionFinish()
    local csbBattleReady = csb.createNode("battle/battle_ready_1.csb")
    local root = csbBattleReady:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbBattleReady)

    -- 播放回合开始的特效
	local armaturePanel = ccui.Helper:seekWidgetByName(root, "Panel_zdks")
	local armature = armaturePanel:getChildByName("ArmatureNode_zdks")
	-- draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
    armature._invoke = function(armatureBack)
        fwin:close(self)
        -- state_machine.excute("fight_attack_round_start", 0, "")
        if state_machine.excute("fight_attack_check_boss_instro",0,0) == false then
            state_machine.excute("fight_attack_round_start", 0, "")
            -- state_machine.excute("fight_role_controller_notification_skeep_fight", 0, 0)
        end
    end
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    -- armature:getAnimation():playWithIndex(0, 0, 0)
    csb.animationChangeToAction(armature, 0, 0, false)
end

function FightRoundOne:onExit()
	state_machine.remove("fight_round_one_action_time_speed")
end
