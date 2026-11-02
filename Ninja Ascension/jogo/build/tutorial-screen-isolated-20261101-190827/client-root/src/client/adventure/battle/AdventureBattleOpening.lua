-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗开场动画
-------------------------------------------------------------------------------------------------------
AdventureBattleOpening = class("AdventureBattleOpeningClass", Window)
    
function AdventureBattleOpening:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure battle opening state machine.
    local function init_adventure_battle_opening_terminal()
        state_machine.init()
    end
    
    -- call func init adventure battle opening state machine.
    init_adventure_battle_opening_terminal()
end

function AdventureBattleOpening:init()
	return self
end

function AdventureBattleOpening:onEnterTransitionFinish()
	local csbAdventureBattleOpening = csb.createNode("battle/battle_donghua.csb")
    local root = csbAdventureBattleOpening:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleOpening)

    local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
    local armature = panel:getChildByName("ArmatureNode_1")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():playWithIndex(0, 0, 0)
    armature._invoke = function(armatureBack)
        state_machine.excute("adventure_battle_start_fight", 0, 0)
        fwin:close(fwin:find("AdventureBattleOpeningClass"))
    end
end

function AdventureBattleOpening:onExit()

end