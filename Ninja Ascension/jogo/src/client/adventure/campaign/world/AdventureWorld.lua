-- ----------------------------------------------------------------------------------------------------
-- 说明：世界冒险
-------------------------------------------------------------------------------------------------------
AdventureWorld = class("AdventureWorldClass", Window)
    
function AdventureWorld:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure arena state machine.
    local function init_adventure_arena_terminal()
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_terminal()
end

function AdventureWorld:init()
	return self
end

function AdventureWorld:onEnterTransitionFinish()
	local csbAdventureMine = csb.createNode("campaign/Mining/wakuang_map_bg.csb")
    local root = csbAdventureMine:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMine)
end

function AdventureWorld:onExit()

end