GameComonTitle = class("GameComonTitleClass", Window)

function GameComonTitle:ctor()
    self.super:ctor()
    


end

function GameComonTitle:onEnterTransitionFinish()
 

	
	local csbpublic_information = csb.createNode("duplicate/public_information_2.csb")
	self:addChild(csbpublic_information)

	local public_informationRoot 	= csbpublic_information:getChildByName("root")

	--最上面

	local public_information_exp 		= ccui.Helper:seekWidgetByName(public_informationRoot, "Label_528_2")
		public_information_exp:setString(100)
	local public_information_enery 		= ccui.Helper:seekWidgetByName(public_informationRoot, "Label_55831")
		public_information_enery:setString(100)
    local public_information_silver 		= ccui.Helper:seekWidgetByName(public_informationRoot, "Label_529_1")
		public_information_silver:setString(100)
	local public_information_gold 		= ccui.Helper:seekWidgetByName(public_informationRoot, "Label_528_1")
		public_information_gold:setString(100)

	
end

function GameComonTitle:onExit()

	

end