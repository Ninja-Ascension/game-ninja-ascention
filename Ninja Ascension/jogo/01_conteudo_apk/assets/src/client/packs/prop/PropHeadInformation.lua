--点击道具头像显示的详细信息

PropHeadInformation = class("PropHeadInformationClass", Window)	

function PropHeadInformation:ctor()
    self.super:ctor()
	
	self.roots = {}
	
    -- Initialize prop_page page state machine.
    local function init_prop_page_terminal()
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_prop_page_terminal()
end

function PropHeadInformation:onEnterTransitionFinish()
	local csbPropStorage = csb.createNode("refinery/refinery_fenjiefanhuan_1.csb")
    self:addChild(csbPropStorage)
	local root = csbPropStorage:getChildByName("root")
	table.insert(self.roots, root)
	
	
end



function PropHeadInformation:onExit()

	-- state_machine.remove("prop_page_use_materials")
	-- state_machine.remove("Prop_Page_chick")

end
