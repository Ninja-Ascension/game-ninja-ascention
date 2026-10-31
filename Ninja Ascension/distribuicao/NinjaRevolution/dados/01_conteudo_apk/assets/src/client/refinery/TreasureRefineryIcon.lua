----------------------------------------------------------------------------------------------------
-- 说明：宝物升级图标绘制 -- （宝物）
-------------------------------------------------------------------------------------------------------
TreasureRefineryIcon = class("TreasureRefineryIconClass", Window)

function TreasureRefineryIcon:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}
	self.current_type = 0
	self.mould_id = nil
	self.instance_id = nil
end

function TreasureRefineryIcon:onUpdateDraw()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local equip_data = dms.element(dms["equipment_mould"], self.mould_id)
		local equip_icon = dms.atoi(equip_data, equipment_mould.pic_index)
		local icon_panel = ccui.Helper:seekWidgetByName(root, "Panel_106")
		local Panel_pizhik = ccui.Helper:seekWidgetByName(root, "Panel_pizhik")
		local quality = dms.atoi(equip_data, equipment_mould.grow_level)
		--print("quality,",quality)
		icon_panel:setBackGroundImage(string.format("images/ui/props/props_%d.png", equip_icon))
		Panel_pizhik:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png",quality+1))
	else
		local equip_data = dms.element(dms["equipment_mould"], self.mould_id)
		local equip_icon = dms.atoi(equip_data, equipment_mould.All_icon)
		local icon_panel = ccui.Helper:seekWidgetByName(root, "Panel_106")
		icon_panel:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", equip_icon))
	end
end

function TreasureRefineryIcon:onEnterTransitionFinish()
	local csbItem = csb.createNode("packs/TreasureStorage/treasure_strengthen_o.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
	root:setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Panel_baowu_kj"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Panel_106"):setSwallowTouches(false)
	local cancel_button = ccui.Helper:seekWidgetByName(root, "Button_baowu_gb")
		fwin:addTouchEventListener(cancel_button, nil, 
		{
			terminal_name = "treasure_resolve_cancel_one", 	
			terminal_state = 0, 
			_equiment_id = self.instance_id,
			isPressedActionEnabled = true
		}, 
		nil, 2)
end

function TreasureRefineryIcon:onExit()
	
end

function TreasureRefineryIcon:init(interfaceType, mouldId, instanceId)
	self.current_type = interfaceType
	self.mould_id = mouldId
	self.instance_id = instanceId
end

function TreasureRefineryIcon:createCell()
	local cell = TreasureRefineryIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end