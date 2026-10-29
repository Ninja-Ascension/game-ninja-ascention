-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面3
-------------------------------------------------------------------------------------------------------
HeroPatchInformationPageThree = class("HeroPatchInformationPageThreeClass", Window)

function HeroPatchInformationPageThree:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipId = nil
	self.types = nil
	app.load("client.cells.ship.ship_head_new_cell")
    local function init_hero_patch_information_page_three_terminal()
	
        state_machine.init()
    end
    init_hero_patch_information_page_three_terminal()
end

function HeroPatchInformationPageThree:onUpdateDraw()
	local root = self.roots[1]
	
	local Panel_3087 = ccui.Helper:seekWidgetByName(root, "Panel_3087") -- 4人合击
	local Panel_3088 = ccui.Helper:seekWidgetByName(root, "Panel_3088") -- 2人合击
	
	-- 公用
	local Text_26 = ccui.Helper:seekWidgetByName(root, "Text_26") 				 --合击技能描述
	
	-- 2人合击控件
	local Panel_26 = ccui.Helper:seekWidgetByName(root, "Panel_26") 			 --合击之当前武将
	local Text_28 = ccui.Helper:seekWidgetByName(root, "Text_28") 				 --合击之当前武将名字
	local Panel_26_0 = ccui.Helper:seekWidgetByName(root, "Panel_26_0") 		 --合击之武将2
	local Text_28_0 = ccui.Helper:seekWidgetByName(root, "Text_28_0") 			 --合击之武将2名字
	
	-- 4人合击控件
	local Panel_26_2 = ccui.Helper:seekWidgetByName(root, "Panel_26_2") 		 --合击之当前武将
	local Text_28_1 = ccui.Helper:seekWidgetByName(root, "Text_28_1") 			 --合击之当前武将名字
	local Panel_26_0_1 = ccui.Helper:seekWidgetByName(root, "Panel_26_0_1") 	 --合击之武将2
	local Text_28_0_1 = ccui.Helper:seekWidgetByName(root, "Text_28_0_1") 		 --合击之武将2名字
	local Panel_26_1 = ccui.Helper:seekWidgetByName(root, "Panel_26_1") 	 	 --合击之武将3
	local Text_28_2 = ccui.Helper:seekWidgetByName(root, "Text_28_2") 		 	 --合击之武将3名字
	local Panel_26_0_0 = ccui.Helper:seekWidgetByName(root, "Panel_26_0_0") 	 --合击之武将4
	local Text_28_0_0 = ccui.Helper:seekWidgetByName(root, "Text_28_0_0") 		 --合击之武将4名字
	
	-- 最终使用
	local hero_panel_1 = nil
	local hero_panel_2 = nil
	local hero_text_1 = nil
	local hero_text_2 = nil
	
	local dataId = 0
	if self.types == 2 then
		dataId = self.shipId
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			dataId = dms.int(dms["ship_mould"], self.shipId, ship_mould.base_mould)
		end
	else
		dataId = dms.int(dms["prop_mould"], self.shipId.user_prop_template, prop_mould.use_of_ship)
	end
	--合击技
	local zoariumSkill = dms.int(dms["ship_mould"], dataId, ship_mould.zoarium_skill)
	if zoariumSkill ~= nil and zoariumSkill > 0 then
		local skillType = dms.int(dms["skill_mould"], zoariumSkill, skill_mould.skill_quality)
		-- if skillType == 2 then
			local skillName = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.skill_name)
			local skillDec = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.skill_describe)
			local person = zstring.zsplit(dms.string(dms["skill_mould"], zoariumSkill, skill_mould.release_mould), ",")
			-- print("person",dms.string(dms["skill_mould"], zoariumSkill, skill_mould.release_mould))
			Text_26:setString("["..skillName.."]".." "..skillDec)
			
			if #person > 2 then
				Panel_3087:setVisible(true)
				Panel_3088:setVisible(false)
				
				hero_panel_1 = Panel_26_2
				hero_panel_2 = Panel_26_0_1
				hero_text_1 = Text_28_1
				hero_text_2 = Text_28_0_1
			else
				Panel_3087:setVisible(false)
				Panel_3088:setVisible(true)
				
				hero_panel_1 = Panel_26
				hero_panel_2 = Panel_26_0
				hero_text_1 = Text_28
				hero_text_2 = Text_28_0
			end
			
			local str = 1
			for i, v in pairs(person) do
				if tonumber(v) > 0 then
					if tonumber(v) == tonumber(dataId) then
						-- 当前武将 dataId 为当前武将模板
					
						local cell = ShipHeadNewCell:createCell()
						cell:init(nil, cell.enum_type._SHOW_SHIP_GETWAY, v, {isCurrentShip = true})
						hero_panel_1:removeAllChildren(true)
						hero_panel_1:addChild(cell)
						local name = nil
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						        --进化形象
						        local evo_image = dms.string(dms["ship_mould"], v, ship_mould.fitSkillTwo)
						        local evo_info = zstring.split(evo_image, ",")
						        --进化模板id
						        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
						        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v, ship_mould.captain_name)]
						        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
						        local word_info = dms.element(dms["word_mould"], name_mould_id)
								name = word_info[3]
						    else
								name = dms.string(dms["ship_mould"], v, ship_mould.captain_name)
							end
						local quality = dms.int(dms["ship_mould"], v, ship_mould.ship_type)+1
						hero_text_1:setString(name)
						hero_text_1:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
					else
						str = str + 1
						if str == 2 then
							local cell = ShipHeadNewCell:createCell()
							cell:init(nil, cell.enum_type._SHOW_SHIP_GETWAY, v)
							hero_panel_2:removeAllChildren(true)
							hero_panel_2:addChild(cell)
							local name = nil
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						        --进化形象
						        local evo_image = dms.string(dms["ship_mould"], v, ship_mould.fitSkillTwo)
						        local evo_info = zstring.split(evo_image, ",")
						        --进化模板id
						        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
						        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v, ship_mould.captain_name)]
						        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
						        local word_info = dms.element(dms["word_mould"], name_mould_id)
								name = word_info[3]
						    else
								name = dms.string(dms["ship_mould"], v, ship_mould.captain_name)
							end
							local quality = dms.int(dms["ship_mould"], v, ship_mould.ship_type)+1
							hero_text_2:setString(name)
							hero_text_2:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
						elseif str == 3 then
							local cell = ShipHeadNewCell:createCell()
							cell:init(nil, cell.enum_type._SHOW_SHIP_GETWAY, v)
							Panel_26_1:removeAllChildren(true)
							Panel_26_1:addChild(cell)
							local name = nil
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						        --进化形象
						        local evo_image = dms.string(dms["ship_mould"], v, ship_mould.fitSkillTwo)
						        local evo_info = zstring.split(evo_image, ",")
						        --进化模板id
						        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
						        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v, ship_mould.captain_name)]
						        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
						        local word_info = dms.element(dms["word_mould"], name_mould_id)
								name = word_info[3]
						    else
								name = dms.string(dms["ship_mould"], v, ship_mould.captain_name)
							end
							local quality = dms.int(dms["ship_mould"], v, ship_mould.ship_type)+1
							Text_28_2:setString(name)
							Text_28_2:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
						elseif str == 4 then
							local cell = ShipHeadNewCell:createCell()
							cell:init(nil, cell.enum_type._SHOW_SHIP_GETWAY, v)
							Panel_26_0_0:removeAllChildren(true)
							Panel_26_0_0:addChild(cell)
							local name = nil
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						        --进化形象
						        local evo_image = dms.string(dms["ship_mould"], v, ship_mould.fitSkillTwo)
						        local evo_info = zstring.split(evo_image, ",")
						        --进化模板id
						        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
						        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v, ship_mould.captain_name)]
						        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
						        local word_info = dms.element(dms["word_mould"], name_mould_id)
								name = word_info[3]
						    else
								name = dms.string(dms["ship_mould"], v, ship_mould.captain_name)
							end
							local quality = dms.int(dms["ship_mould"], v, ship_mould.ship_type)+1
							Text_28_0_0:setString(name)
							Text_28_0_0:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
						end
					end
				end
			end
		-- end
	end
	
	
	
end

function HeroPatchInformationPageThree:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		return
	end
	local csbHeroPatchInformationPageThree= csb.createNode("packs/Fragmentation_information_hj.csb")
	
    self:addChild(csbHeroPatchInformationPageThree)
	local root = csbHeroPatchInformationPageThree:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function HeroPatchInformationPageThree:onLoad( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local csbHeroPatchInformationPageThree= csb.createNode("packs/Fragmentation_information_hj.csb")
		
	    self:addChild(csbHeroPatchInformationPageThree)
		local root = csbHeroPatchInformationPageThree:getChildByName("root")
		table.insert(self.roots, root)
		
		self:onUpdateDraw()
	end
end

function HeroPatchInformationPageThree:onExit()
	
end

function HeroPatchInformationPageThree:init(shipId, types)
	self.shipId = shipId
	self.types = types
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		self:setContentSize(HeroPatchInformation.__size)
	end
end

function HeroPatchInformationPageThree:createCell()
	local cell = HeroPatchInformationPageThree:new()
	cell:registerOnNodeEvent(cell)
	return cell
end