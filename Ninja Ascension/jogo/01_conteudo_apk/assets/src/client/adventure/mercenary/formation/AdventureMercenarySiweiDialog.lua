-- ----------------------------------------------------------------------------------------------------
-- 说明：四维属性
-------------------------------------------------------------------------------------------------------
AdventureMercenarySiweiDialog = class("AdventureMercenarySiweiDialogClass", Window)
    
function AdventureMercenarySiweiDialog:ctor()
    self.super:ctor()
    self.roots = {}

	
    -- Initialize adventure battle formation state machine.
    local function init_adventure_battle_formation_terminal()
       
        state_machine.init()
    end
    
    -- call func init adventure battle formation state machine.
    init_adventure_battle_formation_terminal()
end

function AdventureMercenarySiweiDialog:init()
    return self
end

function AdventureMercenarySiweiDialog:onUpdateDraw()

end

function AdventureMercenarySiweiDialog:onEnterTransitionFinish()
    local csbAdventureBattleFormation = csb.createNode("packs/Mercenary/yongbing_siwei.csb")
    local root = csbAdventureBattleFormation:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleFormation)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenarySiweiDialogClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureMercenarySiweiDialog:onExit()
   
end
