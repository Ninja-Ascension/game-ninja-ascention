-- ----------------------------------------------------------------------------------------------------
-- 说明：商城Vip礼包预览标签
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopVIPPropShowCell = class("ShopVIPPropShowCellClass", Window)

function ShopVIPPropShowCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.cell = nil
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")
end

function ShopVIPPropShowCell:onUpdateDraw()
	local root = self.roots[1]
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_380")
	local panelName = ccui.Helper:seekWidgetByName(root, "Text_103")
	local panelDes = ccui.Helper:seekWidgetByName(root, "Text_258")
	
	if self.cell == nil then
	
	elseif self.cell[2] == "equip" then
		local equipId = self.cell[1]
		local quality = dms.int(dms["equipment_mould"], equipId, equipment_mould.grow_level) + 1
		panelName:setString(dms.string(dms["equipment_mould"], equipId, equipment_mould.equipment_name))
		panelName:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		panelDes:setString(dms.string(dms["equipment_mould"], equipId, equipment_mould.trace_remarks))
		local cell = EquipIconCell:createCell()
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			cell:init(15, nil, equipId)
		else
			cell:init(10, nil, equipId)
		end
		panelHead:addChild(cell)
	elseif self.cell[2] == "ship" then
		local shipId = self.cell[1]
		local quality = dms.int(dms["ship_mould"], shipId, ship_mould.ship_type) + 1
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], shipId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], shipId, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
    		panelName = word_info[3]
		else
			panelName:setString(dms.string(dms["ship_mould"], shipId, ship_mould.captain_name))
		end
		panelName:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		panelDes:setString(dms.string(dms["ship_mould"], shipId, ship_mould.introduce))
		local cell = ShipIconCell:createCell()
		cell:init(nil, 13, shipId)
		panelHead:addChild(cell)
	elseif self.cell[2] == "prop" then
		local propId = self.cell[1]
		local quality = dms.int(dms["prop_mould"], propId, prop_mould.prop_quality) + 1
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
       		panelName:setString(setThePropsIcon(propId)[2])
    	else
			panelName:setString(dms.string(dms["prop_mould"], propId, prop_mould.prop_name))
		end
		panelName:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            panelDes:setString(drawPropsDescription(propId))
        else
        	panelDes:setString(dms.string(dms["prop_mould"], propId, prop_mould.remarks))
        end
		
		local cell = PropIconCell:createCell()
		cell:init(24, ""..propId, self.cell[3])
		panelHead:addChild(cell)
	elseif self.cell[2] == "goldCount" then		--金币
		panelName:setString(_All_tip_string_info._crystalName)
		panelName:setColor(cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]))
		panelDes:setString(_All_tip_string_info_description._crystalNameDescription)
		local cell = propMoneyIcon:createCell()
		cell:init("2",self.cell[1])
		panelHead:addChild(cell)
	elseif self.cell[2] == "reputeCount" then
		panelName:setString(_All_tip_string_info._reputation)
		panelName:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
		panelDes:setString(_All_tip_string_info_description._reputationDescription)
		local cell = propMoneyIcon:createCell()
		cell:init("3",self.cell[1])
		panelHead:addChild(cell)
	elseif self.cell[2] == "sliverCount" then
		panelName:setString(_All_tip_string_info._fundName)
		panelName:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
		panelDes:setString(_All_tip_string_info_description._fundNameDescription)
		local cell = propMoneyIcon:createCell()
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			cell:init("1",self.cell[1])
		else
			cell:init("1",self.cell[1],_All_tip_string_info._fundName)
		end
		panelHead:addChild(cell)
	end
	
	
end

function ShopVIPPropShowCell:onEnterTransitionFinish()
	local csbShopVIPPropShowCell = csb.createNode("shop/package_preview_list.csb")
	local root = csbShopVIPPropShowCell:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbShopVIPPropShowCell)
	
	local panel_20 = ccui.Helper:seekWidgetByName(root, "Panel_20")
	local MySize = panel_20:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()
end

function ShopVIPPropShowCell:onExit()

end

function ShopVIPPropShowCell:init(prop)
	self.cell = prop
end

function ShopVIPPropShowCell:createCell()
	local cell = ShopVIPPropShowCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
