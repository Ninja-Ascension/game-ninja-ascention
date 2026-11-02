-- ----------------------------------------------------------------------------------------------------
-- 说明：连胜利规则
-------------------------------------------------------------------------------------------------------
AdventureArenaStraightExplain = class("AdventureArenaStraightExplainClass", Window)
    
function AdventureArenaStraightExplain:ctor()
    self.super:ctor()
    self.roots = {}
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_qualifying_rule_terminal()
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_qualifying_rule_terminal()
end

function AdventureArenaStraightExplain:init()
	return self
end

function AdventureArenaStraightExplain:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/guize_liansheng.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaStraightExplainClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
end

function AdventureArenaStraightExplain:onExit()

end