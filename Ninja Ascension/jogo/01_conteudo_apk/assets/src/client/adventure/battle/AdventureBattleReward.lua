-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗奖励
-------------------------------------------------------------------------------------------------------
AdventureBattleReward = class("AdventureBattleRewardClass", Window)
    
function AdventureBattleReward:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure battle reward state machine.
    local function init_adventure_battle_reward_terminal()
        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_battle_reward_terminal()
end

function AdventureBattleReward:init()
	return self
end

function AdventureBattleReward:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("battle/battle_huodejiangli.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
end

function AdventureBattleReward:onExit()

end