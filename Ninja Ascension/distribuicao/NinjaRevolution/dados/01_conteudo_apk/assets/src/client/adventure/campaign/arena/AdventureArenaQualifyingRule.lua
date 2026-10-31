-- ----------------------------------------------------------------------------------------------------
-- 说明：排位规则
-------------------------------------------------------------------------------------------------------
AdventureArenaQualifyingRule = class("AdventureArenaQualifyingRuleClass", Window)
    
function AdventureArenaQualifyingRule:ctor()
    self.super:ctor()
    self.roots = {}
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_qualifying_rule_terminal()
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_qualifying_rule_terminal()
end

function AdventureArenaQualifyingRule:init()
	return self
end

function AdventureArenaQualifyingRule:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/guize_paiwei.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaQualifyingRuleClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
end

function AdventureArenaQualifyingRule:onExit()

end