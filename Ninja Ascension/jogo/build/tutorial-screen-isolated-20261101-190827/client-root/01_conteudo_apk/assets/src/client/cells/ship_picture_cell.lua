----------------------------------------------------------------------------------------------------
-- 说明：
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ShipPictureCell = class("ShipPictureCellClass", Window)

function ShipPictureCell:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.ship = nil
	
	
end

function ShipPictureCell:onEnterTransitionFinish()
	local csbFormation = csb.createNode("shop/shop_wujiang1.csb")
    self:addChild(csbFormation)
	local action = csb.createTimeline("shop/shop_wujiang1.csb") 
	action:gotoFrameAndPlay(0, action:getDuration(), true)
	csbFormation:runAction(action)
	
	local csbFormation_root = csbFormation:getChildByName("root")
	local picIndex_name = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.shipInstance.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.shipInstance.evolution_status, "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		picIndex_name = word_info[3]
	else
		picIndex_name = dms.string(dms["ship_mould"], self.shipInstance.ship_template_id, ship_mould.captain_name)
	end
	
	local picIndex_pic = dms.int(dms["ship_mould"], self.shipInstance.ship_template_id, ship_mould.All_icon)
	local colortype = dms.string(dms["ship_mould"], self.shipInstance,ship_mould.ship_type)
	local TypeCurrent = tonumber(dms.string(dms["ship_mould"],self.shipInstance,ship_mould.capacity)) 
	--> print("leix=============",TypeCurrent)
	local panel = ccui.Helper:seekWidgetByName(csbFormation_root, "Panel_3")
	local Text_name = ccui.Helper:seekWidgetByName(csbFormation_root, "Text_name")
	local cardType = ccui.Helper:seekWidgetByName(csbFormation_root, "Panel_4")
	
	panel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png",picIndex_pic))
	Text_name:setString(picIndex_name)
	
	Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	
	local equipIconeType = nil
	if TypeCurrent == 1 then
		equipIconeType = string.format("images/ui/quality/leixing_0.png")
	elseif TypeCurrent ==2 then 
		equipIconeType = string.format("images/ui/quality/leixing_1.png")
	elseif TypeCurrent ==3 then
		equipIconeType = string.format("images/ui/quality/leixing_2.png")
	elseif TypeCurrent ==4 then
		equipIconeType = string.format("images/ui/quality/leixing_3.png")
	end
	cardType:setBackGroundImage(equipIconeType)
end

function ShipPictureCell:onExit()
	
end

function ShipPictureCell:init(shipInstance)
	cell.shipInstance = shipInstance
end

function ShipPictureCell:createCell(shipInstance)
	local cell = ShipPictureCell:new()
	cell.shipInstance = shipInstance
	cell:registerOnNodeEvent(cell)
	return cell
end