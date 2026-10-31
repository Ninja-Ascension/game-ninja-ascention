----------------------------------------------------------------------------------------------------
-- 说明：主线副本列表元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
PlotGroupCopyCell = class("PlotGroupCopyCellClass", Window)
 
function PlotGroupCopyCell:ctor()
	app.load("client.cells.copy.plot_copy_cell")
    self.super:ctor()
	self.roots = {}
	self.sceneIds = 0   			--传入关卡ID
end

function PlotGroupCopyCell:onUpdateDraw()
	local count = table.getn(self.sceneIds)
	--描绘单个ID对应的图
	for i = 1,count do
		local sceneId = self.sceneIds[i]
		if sceneId > 0 then
			local cell 	= PlotCopyCell:createCell()
			cell:init(sceneId, i)
			local panel =ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pve_"..i)
			panel:addChild(cell)
		end
	end
end

function PlotGroupCopyCell:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode("duplicate/pve_bg.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)

	self:onUpdateDraw()
end

function PlotGroupCopyCell:init(sceneIds)
	self.sceneIds = sceneIds
end

function PlotGroupCopyCell:onExit()

end

function PlotGroupCopyCell:createCell()
	local cell = PlotGroupCopyCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end