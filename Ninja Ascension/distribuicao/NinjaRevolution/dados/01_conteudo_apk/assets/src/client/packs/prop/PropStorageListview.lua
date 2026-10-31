PropStorageListview = class("PropPageClass", Window)	

function PropStorageListview:ctor()
    self.super:ctor()
	
	self.roots = {}
	
    -- Initialize prop_page page state machine.
    local function init_prop_page_terminal()
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_prop_page_terminal()
end

function PropStorageListview:onEnterTransitionFinish()
	local csbPropStorage = csb.createNode("list/list_equipment_Wear.csb")
    self:addChild(csbPropStorage)
	local root = csbPropStorage:getChildByName("root")
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_generals_equipment")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
end



function PropStorageListview:onExit()

	-- state_machine.remove("prop_page_use_materials")
	-- state_machine.remove("Prop_Page_chick")

end
