ArrangeList = class("ArrangeListClass", Window)
    
function ArrangeList:ctor()
    self.super:ctor()
    self.roots = {}
	self.stats = nil
	self.arrange={
	
	}
	
	
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
    self:addChild(csbCampaign)
	
	
	ccui.Helper:seekWidgetByName(root, "Text_1"):setString(self.stats.name)
	ccui.Helper:seekWidgetByName(root, "Text_2"):setString(self.stats.star..tipStringInfo_trialTower[4])
	
	
	local Sprite_one = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Sprite_1")
	local Sprite_two = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Sprite_2")
	local Sprite_three = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Sprite_3")
	local Sprite_four = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Sprite_4")
	local one_image = ccui.Helper:seekWidgetByName(root, "Image_1st")
	local one_image1 = ccui.Helper:seekWidgetByName(root, "Image_1st_1")
	local two_image = ccui.Helper:seekWidgetByName(root, "Image_4st")
	local two_image1 = ccui.Helper:seekWidgetByName(root, "Image_4st_1")
	local other = ccui.Helper:seekWidgetByName(root, "Text_7")
	
	
	if self.arrange == 0 then
		Sprite_four:setVisible(true)
	elseif self.arrange == 1 then
		Sprite_one:setVisible(true)
		one_image :setVisible(true)
		one_image1:setVisible(true)
	elseif self.arrange == 2 then
		Sprite_two:setVisible(true)
		one_image :setVisible(true)
		one_image1:setVisible(true)
	elseif self.arrange == 3 then
		Sprite_three:setVisible(true)
		one_image :setVisible(true)
		one_image1:setVisible(true)
	else
		two_image :setVisible(true)
		two_image1:setVisible(true)
		other:setString(self.arrange)
		other:enableOutline(cc.c4b(0,0,0,255), 2)
	end
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_20")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
end


function ArrangeList:onExit()
	
	
	-- state_machine.remove("ArrangeList_back_activity")
	-- state_machine.remove("trial_tower_init_treasure")
end


function ArrangeList:init(status,arrange)
	self.stats = status
	--> print("=======================",self.stats.name)
	self.arrange= arrange
end

function ArrangeList:createCell()
	local cell = ArrangeList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end