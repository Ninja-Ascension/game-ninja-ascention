----------------------------------------------------------------------------------------------------
-- 说明：玩家副本星级元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
PlotCopyStart = class("PlotCopyStartClass", Window)
 
function PlotCopyStart:ctor()
    self.super:ctor()
	self.roots = {}
	self.starInfo = {}  --玩家星数信息
	self.num = nil
end

function PlotCopyStart:onUpdateDraw()--Text_mingci
	local charts 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_mingci_1")
	local name 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_1")
	local start 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_star_1")
	if self.num > 3 then
		charts:setString(self.starInfo.order)
	else
		if self.num == 1 then
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_10_st_1"):setVisible(true)
		elseif self.num == 2 then
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_10_st_2"):setVisible(true)
		elseif self.num == 3 then
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_10_st_3"):setVisible(true)
		end
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_5_0"):setVisible(true)
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_6_0"):setVisible(true)
	end
	name:setString(self.starInfo.user_name)
	start:setString(self.starInfo.user_fighting)
	
end

function PlotCopyStart:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode("duplicate/pve_leaderboard_list.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)
	local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
	local panelSize = panel:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panelSize)
end

function PlotCopyStart:onExit()
end

function PlotCopyStart:init(starInfo,num)
	self.starInfo = starInfo
	self.num = num
end

function PlotCopyStart:createCell()
	local cell = PlotCopyStart:new()
	cell:registerOnNodeEvent(cell)
	return cell
end