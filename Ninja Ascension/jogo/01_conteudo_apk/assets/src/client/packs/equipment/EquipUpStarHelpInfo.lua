-- ----------------------------------------------------------------------------------------------------
-- 说明：升星说明
-------------------------------------------------------------------------------------------------------

EquipUpStarHelpInfo = class("EquipUpStarHelpInfoClass", Window)
   
function EquipUpStarHelpInfo:ctor()
    self.super:ctor()
	self.roots = {}
end

function EquipUpStarHelpInfo:onUpdateDraw()
	local root = self.roots[1]
end

function EquipUpStarHelpInfo:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("packs/EquipStorage/equipment_strengthen_bangzhu.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)		
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		func_string = [[fwin:close(fwin:find("EquipUpStarHelpInfoClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)	
	
end


function EquipUpStarHelpInfo:onExit()
end
