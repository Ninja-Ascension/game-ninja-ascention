-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE场景剧情(就是该场景的废话描述)
-------------------------------------------------------------------------------------------------------
PVEIntroduction = class("PVEIntroductionClass", Window)

function PVEIntroduction:ctor()
    self.super:ctor()
    self.roots = {}
	self.pveSceneID = 0				--场景ID

end

function PVEIntroduction:onUpdateInfo(pveSceneID)

	if nil == self.infoText then
		self:initCSD()
	end

	local info = dms.string(dms["pve_scene"], tonumber(pveSceneID), pve_scene.brief_introduction)
	self.infoText:setString(info)
end

function PVEIntroduction:init()
	
end

function PVEIntroduction:initCSD()
	local csbPVEIntroduction = csb.createNode("duplicate/pve_fubenmiaosu.csb")
	local root = csbPVEIntroduction:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVEIntroduction)
	self.infoText = ccui.Helper:seekWidgetByName(root, "Text_miaosu")
end

function PVEIntroduction:onEnterTransitionFinish()
	
end

function PVEIntroduction:onExit()
end

-- function PVEIntroduction:createCell()
	-- local cell = PVEIntroduction:new()
	-- cell:registerOnNodeEvent(cell)
	-- return cell
-- end
