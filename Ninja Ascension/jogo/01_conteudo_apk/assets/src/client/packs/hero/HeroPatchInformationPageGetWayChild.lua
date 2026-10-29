-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面获取方法子界面
-------------------------------------------------------------------------------------------------------
HeroPatchInformationPageGetWayChild = class("HeroPatchInformationPageGetWayChildClass", Window)

function HeroPatchInformationPageGetWayChild:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipId = nil
	
end

function HeroPatchInformationPageGetWayChild:onUpdateDraw()
	local root = self.roots[1]
	
end

function HeroPatchInformationPageGetWayChild:onEnterTransitionFinish()
	local csbHeroPatchInformationPageGetWayChild= csb.createNode("packs/to_get_list.csb")
	
    self:addChild(csbHeroPatchInformationPageGetWayChild)
	local root = csbHeroPatchInformationPageGetWayChild:getChildByName("root")
	table.insert(self.roots, root)
	
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()
	
end

function HeroPatchInformationPageGetWayChild:onExit()
end

function HeroPatchInformationPageGetWayChild:init(shipId)
	self.shipId = shipId
end

function HeroPatchInformationPageGetWayChild:createCell()
	local cell = HeroPatchInformationPageGetWayChild:new()
	cell:registerOnNodeEvent(cell)
	return cell
end