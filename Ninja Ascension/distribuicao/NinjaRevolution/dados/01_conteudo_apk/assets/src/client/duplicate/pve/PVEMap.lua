-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE场景地图
-------------------------------------------------------------------------------------------------------
PVEMap = class("PVEMapClass", Window)

function PVEMap:ctor()
    self.super:ctor()
    self.roots = {}
	self.pveSceneID = 0				--场景ID
	self.npcIds = {}				--npcID组
	self.mapId = 0					--地图ID
	app.load("client.cells.npc.plot_npc_cell")
end

function PVEMap:onUpdateDraw()
	local root = self.roots[1]
	for i = 1,table.getn(self.npcIds) do
		local npcState = 0
		local sceneState = tonumber(_ED.scene_current_state[self.pveSceneID])
		if sceneState + 1 == i then
			npcState = 1
		elseif sceneState + 1 < i then
			break
		end
		local cell_npc = PlotNPCCell:createCell()
		cell_npc:init(self.npcIds[i], npcState)
		local Panel_coordinate = ccui.Helper:seekWidgetByName(root:getChildByName("Panel_map"), "Panel_coordinate_"..i)
		local headIcon = string.format("images/face/big_head/big_head_%s.png", i)
		Panel_coordinate:addChild(cell_npc)
		Panel_coordinate:setBackGroundImage(headIcon)
		local ScrollView = ccui.Helper:seekWidgetByName(root:getChildByName("Panel_map"), "ScrollView_13314_s")
		ScrollView:jumpToPercentVertical(100 - 100 / (table.getn(self.npcIds) - i + 1))
	end
end

function PVEMap:init(pveSceneID)
	local root = self.roots[1]
	self.pveSceneID = pveSceneID
	self.npcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.npcs), ",")
end

function PVEMap:onEnterTransitionFinish()
	self.mapId = zstring.tonumber(dms.string(dms["pve_scene"], tonumber(self.pveSceneID), pve_scene.scene_map_id))
	local mapStr = string.format("duplicate/map/pve_map_%d.csb", self.mapId)
	local csbPveMap = csb.createNode(mapStr)
	
	local root = csbPveMap:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPveMap)
	
    self:onUpdateDraw()
end

function PVEMap:onExit()
end