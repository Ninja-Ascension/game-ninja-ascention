-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面4
-------------------------------------------------------------------------------------------------------
HeroPatchInformationPageFour = class("HeroPatchInformationPageFourClass", Window)

function HeroPatchInformationPageFour:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipId = nil
	self.types = nil
	app.load("client.cells.ship.ship_head_new_cell")
    local function init_hero_patch_information_page_four_terminal()

        state_machine.init()
    end
    init_hero_patch_information_page_four_terminal()
end

function HeroPatchInformationPageFour:onUpdateDraw()
	local root = self.roots[1]
	
	local Panel_icons = ccui.Helper:seekWidgetByName(root, "Panel_icons")				 --武将头像
	local Text_leixin = ccui.Helper:seekWidgetByName(root, "Text_leixin")				 --武将类型
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")				 	 --武将名字
	local Text_19 = ccui.Helper:seekWidgetByName(root, "Text_19")						 --武将羁绊1
	local Text_20 = ccui.Helper:seekWidgetByName(root, "Text_20")						 --武将羁绊2
	local Text_21 = ccui.Helper:seekWidgetByName(root, "Text_21")						 --武将羁绊3
	local Text_19_0 = ccui.Helper:seekWidgetByName(root, "Text_19_0")					 --武将羁绊4
	local Text_20_0 = ccui.Helper:seekWidgetByName(root, "Text_20_0")					 --武将羁绊5
	local Text_21_0 = ccui.Helper:seekWidgetByName(root, "Text_21_0")					 --武将羁绊6
	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")					 --滑动层
	ListView_1:removeAllItems()
	local my_label = {
		Text_19,
		Text_20,
		Text_21,
		Text_19_0,
		Text_20_0,
		Text_21_0,
	}
	
	local dataId = 0
	if self.types == 2 then
		dataId = self.shipId
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], dataId, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
	        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], dataId, ship_mould.captain_name)]
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
			ship_name = word_info[3]
	        Text_name:setString(ship_name)
	    else
			Text_name:setString(dms.string(dms["ship_mould"], dataId, ship_mould.captain_name))
		end
		local colortype = dms.int(dms["ship_mould"], dataId, ship_mould.ship_type)
		Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	elseif self.types == 3 then
		dataId = self.shipId
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], dataId, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
	        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], dataId, ship_mould.captain_name)]
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
			ship_name = word_info[3]
	        Text_name:setString(ship_name)
	    else
			Text_name:setString(dms.string(dms["ship_mould"], dataId, ship_mould.captain_name))
		end
		local colortype = dms.int(dms["ship_mould"], dataId, ship_mould.ship_type)
		Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	else
		dataId = dms.int(dms["prop_mould"], self.shipId.user_prop_template, prop_mould.use_of_ship)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], dataId, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
	        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], dataId, ship_mould.captain_name)]
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
			ship_name = word_info[3]
	        Text_name:setString(ship_name)
	    else
			Text_name:setString(dms.string(dms["ship_mould"], dataId, ship_mould.captain_name))
		end
		local colortype = dms.int(dms["prop_mould"], self.shipId.user_prop_template, prop_mould.prop_quality)
		Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	end
	local cell = ShipHeadNewCell:createCell()
	cell:init(nil, cell.enum_type._SHOW_SHIP_NOT_CHOOSE, dataId)
	Panel_icons:removeAllChildren(true)
	Panel_icons:addChild(cell)

	local heroType = dms.int(dms["ship_mould"], dataId, ship_mould.capacity)
	if heroType == 0 then
	elseif heroType == 1 then
		Text_leixin:setString(_string_piece_info[58])
	elseif heroType == 2 then
		Text_leixin:setString(_string_piece_info[59])
	elseif heroType == 3 then
		Text_leixin:setString(_string_piece_info[60])
	elseif heroType == 4 then
		Text_leixin:setString(_string_piece_info[61])
	end
	
	local fate_relationship_mould_id = dms.string(dms["ship_mould"], dataId, ship_mould.relationship_id)

	local data = zstring.zsplit(fate_relationship_mould_id,",")
	local skill_describe = nil
	local skill_name = nil
	local skill_id = nil
	local fIndex = 1
	local person = {}
	local num = 1
	for i, v in pairs(data) do

		if nil == my_label[i] then
			break
		end
		skill_name = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
		my_label[i]:setString(skill_name)
		if __lua_project_id == __lua_project_warship_girl_b then
			my_label[i]:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
		end
		skill_describe = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_describe)
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need1_type) == 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need1)
			if str > 0 and tonumber(str) ~= tonumber(dataId) then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,0)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need2_type) == 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need2)
			if str > 0 and tonumber(str) ~= tonumber(dataId) then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,0)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need3_type) == 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need3)
			if str > 0 and tonumber(str) ~= tonumber(dataId) then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,0)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need4_type) == 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need4)
			if str > 0 and tonumber(str) ~= tonumber(dataId) then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,0)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need5_type) == 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need5)
			if str > 0 and tonumber(str) ~= tonumber(dataId) then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,0)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need6_type) == 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need6)
			if str > 0 and tonumber(str) ~= tonumber(dataId) then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,0)
				ListView_1:addChild(cell)
			end
		end
		
	end
	
	for i, v in pairs(data) do
		if nil == my_label[i] then
			break
		end
		
		skill_name = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
		my_label[i]:setString(skill_name)
		my_label[i]:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
		skill_describe = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_describe)
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need1_type) > 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need1)
			if str > 0 then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,1)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need2_type) > 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need2)
			if str > 0 then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,1)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need3_type) > 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need3)
			if str > 0 then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,1)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need4_type) > 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need4)
			if str > 0 then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,1)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need5_type) > 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need5)
			if str > 0 then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,1)
				ListView_1:addChild(cell)
			end
		end
		if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need6_type) > 0 then
			local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need6)
			if str > 0 then
				local cell = HeroPatchInformationPageFourChild:createCell()
				cell:init(str,skill_name,skill_describe,1)
				ListView_1:addChild(cell)
			end
		end
		
	end
	
end

function HeroPatchInformationPageFour:onEnterTransitionFinish()
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
	local csbHeroPatchInformationPageFour= csb.createNode("packs/Fragmentation_information_yf.csb")
	
    self:addChild(csbHeroPatchInformationPageFour)
	local root = csbHeroPatchInformationPageFour:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function HeroPatchInformationPageFour:onLoad( ... )
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
		local csbHeroPatchInformationPageFour= csb.createNode("packs/Fragmentation_information_yf.csb")
	
	    self:addChild(csbHeroPatchInformationPageFour)
		local root = csbHeroPatchInformationPageFour:getChildByName("root")
		table.insert(self.roots, root)
		
		self:onUpdateDraw()
	end
end

function HeroPatchInformationPageFour:onExit()

end

function HeroPatchInformationPageFour:init(shipId, types)
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

function HeroPatchInformationPageFour:createCell()
	local cell = HeroPatchInformationPageFour:new()
	cell:registerOnNodeEvent(cell)
	return cell
end