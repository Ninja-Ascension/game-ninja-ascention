GameComonMap = class("GameComonMapClass", Window)

function GameComonMap:ctor()
    self.super:ctor()
    


end

function GameComonMap:onEnterTransitionFinish()
    local csbPveMap = csb.createNode("duplicate/pve_map_1.csb")
	self:addChild(csbPveMap)

	local PveMapRoot 	= csbPveMap:getChildByName("Panel_2552")
		
	--图
	local csbPveMap_nums = zstring.split(dms.string(dms["pve_scene"], 1, pve_scene.npcs), ",")

	local npc_num = 6
	local treasure_Box = 1
	for j=1,npc_num do
		local n_npcPlace = string.format("Panel_coordinate_%s", j)
		--> debug.log(true,n_npcPlace)
		local Panel_pve_map_GuanKa = ccui.Helper:seekWidgetByName(PveMapRoot,n_npcPlace)
		local npc_icon = dms.string(dms["npc"], tonumber(csbPveMap_nums[j]), npc.head_pic)
		--> debug.log(true,npc_icon)
		Panel_pve_map_GuanKa:setBackGroundImage(string.format("images/ui/props/props_%s.png", tonumber(npc_icon)) )
	end
	
	for k=1,treasure_Box do
		local n_npcPlace = string.format("Panel_%s", k)
		--> debug.log(true,n_npcPlace)
		local Panel_pve_map_GuanKa = ccui.Helper:seekWidgetByName(PveMapRoot,n_npcPlace)
		local treasure_icon = dms.string(dms["npc"], tonumber(csbPveMap_nums[k]), npc.head_pic)
		--> debug.log(true,treasure_icon)
		Panel_pve_map_GuanKa:setBackGroundImage(string.format("images/ui/props/props_%d.png", tonumber(4017)) )
	end
	
	
	
	
end

function GameComonMap:onExit()

	

end