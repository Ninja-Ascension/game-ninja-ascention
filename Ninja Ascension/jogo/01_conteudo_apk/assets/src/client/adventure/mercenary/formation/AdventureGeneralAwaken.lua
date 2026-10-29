-- ----------------------------------------------------------------------------------------------------
-- 说明：主角觉醒
-------------------------------------------------------------------------------------------------------
AdventureGeneralAwaken = class("AdventureGeneralAwakenClass", Window)
    
function AdventureGeneralAwaken:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure general awaken state machine.
    local function init_adventure_general_awaken_terminal()
        state_machine.init()
    end
    
    -- call func init adventure general awaken state machine.
    init_adventure_general_awaken_terminal()
end

function AdventureGeneralAwaken:init()
    return self
end

function AdventureGeneralAwaken:onEnterTransitionFinish()
    local csbAdventureGeneralAwaken = csb.createNode("packs/Mercenary/juexing_lead.csb")
    local root = csbAdventureGeneralAwaken:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureGeneralAwaken)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureGeneralAwakenClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureGeneralAwaken:onExit()
    
end
