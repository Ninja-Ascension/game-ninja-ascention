----------------------------------------------------------------------------------------------------
-- 说明：羁绊界面中，羁绊上面的小伙伴图标的绘制及逻辑处理
-------------------------------------------------------------------------------------------------------
FormationPartnerPlaceCell = class("FormationPartnerPlaceCellClass", Window)


function FormationPartnerPlaceCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.ship = nil
end

function FormationPartnerPlaceCell:onUpdateDraw()
	local root = self.roots[1]
	if self.ship ~= nil then
		local shipImage = ccui.Helper:seekWidgetByName(root, "Panel_41")
		local picIndex = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.All_icon)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local temp_bust_index = 0
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				----------------------新的数码的形象------------------------
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(self.ship.evolution_status, "|")
				local evo_mould_id = evo_info[tonumber(ship_evo[1])]
				--新的形象编号
				temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			else
				temp_bust_index = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.bust_index)
			end
			--print("shipId",shipId,_ship,temp_bust_index)
			local shipPanel = shipImage
			shipPanel:removeAllChildren(true)
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
			if animationMode == 1 then
				app.load("client.battle.fight.FightEnum")
				local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0)):setScaleX(-1)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
			        shipSpine:setScaleX(-1)
			    end
			else
				draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0)):setScaleX(-1)
			end
		else
			if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then
					local fashionEquip, pic = getUserFashion()
					if fashionEquip ~= nil and pic ~= nil then
						picIndex = pic
					end
				end
			end
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				shipImage:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex+1000))
			else
				shipImage:setBackGroundImage(string.format("images/face/card_head/card_head_%d.png", picIndex))	
			end
			
		end
		local _name = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
			then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			_name = word_info[3]
		else
			_name = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_name)
		end
		if tonumber(self.ship.captain_type) == 0 then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			else
				_name = _ED.user_info.user_name
			end
			if ___is_open_leadname == true then
		        local Text_28 = ccui.Helper:seekWidgetByName(root, "Text_28")
		        Text_28:setFontName("")
		        Text_28:setFontSize(Text_28:getFontSize())
		    end
		end
		
		ccui.Helper:seekWidgetByName(root, "Text_28"):setString(_name)
		ccui.Helper:seekWidgetByName(root, "Text_29"):setString("+"..dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.initial_rank_level))
		local relationshipOpenCount = 0
		if tonumber(self.ship.relationship_count) ~= 0 then
			for i=1, tonumber(self.ship.relationship_count) do
				local relationship = self.ship.relationship[i]
				if relationship~=nil then
					if tonumber(relationship.is_activited) == 1 then
						relationshipOpenCount = relationshipOpenCount + 1
					end
				end
			end
		end
		ccui.Helper:seekWidgetByName(root, "Text_31"):setString(relationshipOpenCount)
		local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
		ccui.Helper:seekWidgetByName(root, "Text_28"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		ccui.Helper:seekWidgetByName(root, "Text_29"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	end
end

function FormationPartnerPlaceCell:onEnterTransitionFinish()

end

function FormationPartnerPlaceCell:onInit()
	local filePath = "formation/line_up_icon.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function FormationPartnerPlaceCell:onExit()

end

function FormationPartnerPlaceCell:init(_ship)
	self.ship = _ship
	self:onInit()
end

function FormationPartnerPlaceCell:createCell()
	local cell = FormationPartnerPlaceCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

