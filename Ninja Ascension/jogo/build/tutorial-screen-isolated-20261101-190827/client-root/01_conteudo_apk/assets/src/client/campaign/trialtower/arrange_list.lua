ArrangeList = class("ArrangeListClass", Window)
    
function ArrangeList:ctor()
    self.super:ctor()
    

	
    -- Initialize ArrangeList page state machine.
    local function init_trial_tower_terminal()
	
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

function ArrangeList:onEnterTransitionFinish()

    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_list_list.csb")	
	local root = csbCampaign:getChildByName("root")
	root:removeFromParent(false)
    self:addChild(root)
	ccui.Helper:seekWidgetByName(root, "Text_1"):setString("")

	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_20")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
end


function ArrangeList:onExit()
	
	
	-- state_machine.remove("ArrangeList_back_activity")
	-- state_machine.remove("trial_tower_init_treasure")
end


function ArrangeList:init()

end

function ArrangeList:createCell()
	local cell = ArrangeList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end