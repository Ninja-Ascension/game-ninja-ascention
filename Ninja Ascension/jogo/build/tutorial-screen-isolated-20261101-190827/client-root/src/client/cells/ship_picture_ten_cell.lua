----------------------------------------------------------------------------------------------------
-- 说明：
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ShipPictureTenCell = class("ShipPictureTenCellClass", Window)

function ShipPictureTenCell:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.ship = nil
	self.shipInstance = nil
	self.colortype = 0
	self.ship_index = 0
end

function ShipPictureTenCell:onEnterTransitionFinish()
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
		picIndex_name = dms.string(dms["ship_mould"], self.shipInstance.random_patch_id, ship_mould.captain_name)
	end
	local picIndex_pic = dms.int(dms["ship_mould"], self.shipInstance.random_patch_id, ship_mould.All_icon)
	local colortype = dms.int(dms["ship_mould"], self.shipInstance.random_patch_id,ship_mould.ship_type)
	
	self.colortype = colortype
	
	local csbFormation = csb.createNode("shop/shop_wujiang2.csb")
    self:addChild(csbFormation)
	local action = csb.createTimeline("shop/shop_wujiang2.csb") 
	local colortype = self.colortype
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
		if str == "exit" then
			if colortype >= 3 then
				state_machine.excute("hero_recruit_success_ten_play_high_quality_action", 0, nil)
			else
				state_machine.excute("hero_recruit_success_ten_add_cell", 0, nil)
			end
		end
    end)
	csbFormation:runAction(action)
	action:play("windowopen1", false)
	
	local csbFormation_root = csbFormation:getChildByName("root")

	
	local panel = ccui.Helper:seekWidgetByName(csbFormation_root, "Panel_wujiang")
	local Text_name = ccui.Helper:seekWidgetByName(csbFormation_root, "Text_name")
	
	panel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png",picIndex_pic))
	Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	Text_name:setString(picIndex_name)
	
end

function ShipPictureTenCell:onExit()
	
end

function ShipPictureTenCell:init(shipInstance, _index)
	self.shipInstance = shipInstance
	self.ship_index = _index
end

function ShipPictureTenCell:createCell()
	local cell = ShipPictureTenCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end