-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面获取方法
-------------------------------------------------------------------------------------------------------
HeroPatchInformationPageGetWay = class("HeroPatchInformationPageGetWayClass", Window)

function HeroPatchInformationPageGetWay:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipId = nil
	self.types = nil
	self.typeBtn = 1

	self.number_of_raids_max = 0
	self.raids_type = 0
	self.m_switch = false
	app.load("client.packs.equipment.EquipFragmentAcquire")
	app.load("client.cells.equip.equip_icon_new_cell")
	app.load("client.cells.ship.ship_head_new_cell")
	app.load("client.cells.prop.prop_icon_new_cell")
    local function init_hero_patch_information_page_get_way_terminal()
		--关闭
		local hero_patch_information_Page_get_way_close_terminal = {
            _name = "hero_patch_information_Page_get_way_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if fwin:find("FormationTigerGateClass") ~= nil then
                	state_machine.excute("formation_set_ship",0,"")
            	elseif fwin:find("HeroDevelopClass") ~= nil then
            		state_machine.excute("hero_develop_page_strength_to_update_ship",0,"")
                end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_patch_information_update_draw_terminal = {
            _name = "hero_patch_information_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local Text_3 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_3")	
				local number = 0
				if instance.types == nil then		--武将
					for i, v in pairs(_ED.user_ship) do
						if tonumber(v.ship_base_template_id) == tonumber(self.shipId) then
							number = number + 1
						end
					end
					Text_3:setString(number)
				elseif instance.types == 1 then		--装备	
					for i, v in pairs(_ED.user_equiment) do
						if tonumber(v.user_equiment_template) == tonumber(self.shipId) then
							number = number + 1
						end
					end
					Text_3:setString(number)
				elseif instance.types == 2 then		--道具
					for i, v in pairs(_ED.user_prop) do
						if tonumber(v.user_prop_template) == tonumber(self.shipId) then
							number = v.prop_number
						end
					end
					Text_3:setString(number)
				elseif self.types == 3 then		--时装
					for i, v in pairs(_ED.user_equiment) do
						if tonumber(v.user_equiment_template) == tonumber(self.shipId) then
							number = number + 1
						end
					end
					Text_3:setString(number)
				elseif self.types == 4 or self.types == 5 then -- 道具碎片，武将碎片
					for i, v in pairs(_ED.user_prop) do
						if tonumber(v.user_prop_template) == tonumber(self.shipId) then
							number = v.prop_number
						end
					end
					local getShip = dms.int(dms["prop_mould"], self.shipId, prop_mould.use_of_ship)
					local needNumber = dms.int(dms["prop_mould"], self.shipId, prop_mould.split_or_merge_count)
					if needNumber > 0 and getShip > 0 then
						local ships = fundShipWidthTemplateId(getShip)
						if ships ~= nil then
							local StarRating = tonumber(ships.StarRating)
							if StarRating >= 7 then
								Text_3:setString(number)
							else
								local base_mould2 = dms.int(dms["ship_mould"], tonumber(ships.ship_template_id), ship_mould.base_mould2)
							    local info = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, base_mould2, awaken_requirement.awake_level, StarRating)
							    local demandCount = info[1][awaken_requirement.need_same_card_count]
								Text_3:setString(number.."/"..demandCount)
							end
						else
							Text_3:setString(number.."/"..needNumber)
						end
					elseif needNumber > 0 then
						Text_3:setString(number.."/"..needNumber)
					end
				end
				if  _ED.auto_raids_inof and  _ED.auto_raids_inof[3] ~= nil and  _ED.auto_raids_inof[4] ~= nil then
					Text_3:setString(_ED.auto_raids_inof[3].."/".._ED.auto_raids_inof[4])
				end
				instance:onUpdateRaidSelection()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --扫荡选择
        local hero_patch_information_open_raid_selection_terminal = {
            _name = "hero_patch_information_open_raid_selection",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.m_switch == false then
					instance.m_switch = true
				else
					instance.m_switch = false
				end
				instance:onUpdateRaidSelection()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择扫荡类型
        local hero_patch_information_open_raid_selection_type_terminal = {
            _name = "hero_patch_information_open_raid_selection_type",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local page = params._datas._page
				if tonumber(page) == 1 then
					instance.raids_type = 0 --10
				elseif tonumber(page) == 2 then
					instance.raids_type = 1 -- 1
				else
					instance.raids_type = 2 -- 50
				end
				instance.m_switch = false
				instance:onUpdateRaidSelection()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_patch_information_Page_get_way_close_terminal)
		state_machine.add(hero_patch_information_update_draw_terminal)
		state_machine.add(hero_patch_information_open_raid_selection_terminal)
		state_machine.add(hero_patch_information_open_raid_selection_type_terminal)
        state_machine.init()
    end
    init_hero_patch_information_page_get_way_terminal()
end

--扫荡选择
function HeroPatchInformationPageGetWay:onUpdateRaidSelection()
	local root = self.roots[1]
	local Text_xzcs_n = ccui.Helper:seekWidgetByName(root, "Text_xzcs_n")

	local Text_number_1 = ccui.Helper:seekWidgetByName(root, "Text_number_1")
	-- local Text_number_2 = ccui.Helper:seekWidgetByName(root, "Text_number_2")
	local Text_number_3 = ccui.Helper:seekWidgetByName(root, "Text_number_3")
	local can_raid = false
	if self.types == 5 or self.types == 2 then
		-- if self.types == 2 then
			self.number_of_raids_max = 10
			local trace_address = dms.string(dms["prop_mould"], self.shipId, prop_mould.trace_address)
			if trace_address ~= nil and zstring.tonumber(trace_address) ~= -1 then
				local temp = zstring.split(trace_address, ",")
				for i, v in pairs(temp) do
					if tonumber(v) > 0 then 
						local genre = dms.int(dms["function_param"], v, function_param.genre)
						if genre == 11 or genre == 14 then
							can_raid = true
						end
						if genre == 14 then
							self.number_of_raids_max = 3
							break
						end
					end
				end
			else
				self.number_of_raids_max = 10
			end
		-- else
		-- 	self.number_of_raids_max = 3
		-- end
	else
		self.number_of_raids_max = 10
	end
	local Image_cs_3 = ccui.Helper:seekWidgetByName(root, "Image_cs_3")
	Image_cs_3:setVisible(false)
	self.typeBtn = 1
	if self.number_of_raids_max == 10 then
		Image_cs_3:setVisible(true)
		self.typeBtn = 10
	end
	if self.raids_type == 0 then --10
		Text_xzcs_n:setString(string.format(_new_interface_text[135],zstring.tonumber(self.number_of_raids_max)))
		self.typeBtn = 10
	elseif self.raids_type == 2 then
		Text_xzcs_n:setString(string.format(_new_interface_text[135],50))
	else
		Text_xzcs_n:setString(string.format(_new_interface_text[135],1))
	end
	-- debug.print_r(self.typeBtn,'self.typeBtn')
	-- debug.print_r(self.raids_type,'self.raids_type')
	-- debug.print_r(self.number_of_raids_max,'self.number_of_raids_max')
	Text_number_1:setString(string.format(_new_interface_text[135],zstring.tonumber(self.number_of_raids_max)))
	-- Text_number_2:setString(string.format(_new_interface_text[135],1))
	Text_number_3:setString(string.format(_new_interface_text[135],50))

	-- for i=1, 3 do
	-- 	local Image_xz = ccui.Helper:seekWidgetByName(root, "Image_xz_"..i)
	-- 	Image_xz:setVisible(false)
	-- 	if self.raids_type == i-1 then
	-- 		Image_xz:setVisible(true)
	-- 	end
	-- end

	if self.m_switch == false then
		ccui.Helper:seekWidgetByName(root, "Image_arrow_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_arrow_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_xzcs"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Image_arrow_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_arrow_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_xzcs"):setVisible(true)
	end

	local items = ccui.Helper:seekWidgetByName(root, "ListView_1"):getItems()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2  or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		items = ccui.Helper:seekWidgetByName(root, "ScrollView_to_get"):getChildren()
	end
	for i,v in pairs(items) do
		if self.raids_type == 0 then
			state_machine.excute("equip_fragment_acquire_refresh_the_control", 0, {v,self.number_of_raids_max,self.types,self.typeBtn})
		elseif self.raids_type == 2 then
			state_machine.excute("equip_fragment_acquire_refresh_the_control", 0, {v,50,self.types,self.typeBtn})
		else
			state_machine.excute("equip_fragment_acquire_refresh_the_control", 0, {v,1,self.types,self.typeBtn})
		end
	end

	local Button_xzcs = ccui.Helper:seekWidgetByName(root, "Button_xzcs")
	if can_raid == true then
		Button_xzcs:setVisible(false)
	else
		Button_xzcs:setVisible(false)
	end
end

function HeroPatchInformationPageGetWay:onUpdateDraw()
	local root = self.roots[1]
	local Panel_wj = ccui.Helper:seekWidgetByName(root, "Panel_3")				 --武将头像
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")				 --武将名字
	local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")				 --武将数量
	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local getWay = nil
	Panel_wj:removeAllChildren(true)
	ListView_1:removeAllItems()
	if self.types == nil then		--武将
		local cell = ShipHeadNewCell:createCell()
		cell:init(nil, cell.enum_type._SHOW_SHIP_NOT_CHOOSE, self.shipId)
		Panel_wj:addChild(cell)
		local name = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], self.shipId, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
	        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.shipId, ship_mould.captain_name)]
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]
	    else
			name = dms.string(dms["ship_mould"], self.shipId, ship_mould.captain_name)
		end
		local quality = dms.int(dms["ship_mould"], self.shipId, ship_mould.ship_type)+1
		Text_1:setString(name)
		Text_1:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		
		local number = 0
		for i, v in pairs(_ED.user_ship) do
			if tonumber(v.ship_base_template_id) == tonumber(self.shipId) then
				number = number + 1
			end
		end
		Text_3:setString(number)
		
		getWay = dms.string(dms["ship_mould"], self.shipId, ship_mould.trace_address)
	elseif self.types == 1 then		--装备
		local cell = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			cell = EquipIconCell:createCell()
			cell:init(cell.enum_type._EQUIP_SHOW, nil, self.shipId , nil)
		else 
			cell = EquipIconNewCell:createCell()
			cell:init(cell.enum_type._GO_TO_GET_EQUIP, nil, self.shipId)
		end
		Panel_wj:addChild(cell)
		
		local name = dms.string(dms["equipment_mould"], self.shipId, equipment_mould.equipment_name)
		local quality = dms.int(dms["equipment_mould"], self.shipId, equipment_mould.grow_level)+1

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			name = smEquipWordlFundByIndex(self.shipId , 1)
		end
		Text_1:setString(name)
		Text_1:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))


		local number = 0
		for i, v in pairs(_ED.user_equiment) do
			if tonumber(v.user_equiment_template) == tonumber(self.shipId) then
				number = number + 1
			end
		end
		Text_3:setString(number)
		
		getWay = dms.string(dms["equipment_mould"], self.shipId, equipment_mould.trace_address)
	elseif self.types == 2 then		--道具
		local cell = PropIconNewCell:createCell()
		cell:init(cell.enum_type._SHOW_EQUIP_INFO, self.shipId)
		Panel_wj:addChild(cell)
		
		local name = dms.string(dms["prop_mould"], self.shipId, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        name = setThePropsIcon(self.shipId)[2]
		end
		local quality = dms.int(dms["prop_mould"], self.shipId, prop_mould.prop_quality)+1
		Text_1:setString(name)
		Text_1:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		
		local number = 0
		for i, v in pairs(_ED.user_prop) do
			if tonumber(v.user_prop_template) == tonumber(self.shipId) then
				number = v.prop_number
			end
		end
		Text_3:setString(number)
		
		getWay = dms.string(dms["prop_mould"], self.shipId, prop_mould.trace_address)
	elseif self.types == 3 then		--时装
		app.load("client.cells.utils.resources_icon_cell")
		-- local cell = EquipIconNewCell:createCell()
		-- cell:init(cell.enum_type._GO_TO_GET_EQUIP, nil, self.shipId)
		local tempCell = ResourcesIconCell:createCell()
		tempCell:init(7, 0, self.shipId)
		Panel_wj:addChild(tempCell)
		-- tempCell:showName(self.shipId,7)

		local name = dms.string(dms["equipment_mould"], self.shipId, equipment_mould.equipment_name)
		local quality = dms.int(dms["equipment_mould"], self.shipId, equipment_mould.grow_level)+1
		Text_1:setString(name)
		Text_1:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		
		local number = 0
		for i, v in pairs(_ED.user_equiment) do
			if tonumber(v.user_equiment_template) == tonumber(self.shipId) then
				number = number + 1
			end
		end
		Text_3:setString(number)
		ccui.Helper:seekWidgetByName(root, "Text_121"):setString(_string_piece_info[365])
		getWay = dms.string(dms["equipment_mould"], self.shipId, equipment_mould.trace_address)
		-- 
	elseif self.types == 4 or self.types == 5 then -- 道具碎片，武将碎片

		local cell = PropIconNewCell:createCell()
		if self.types == 4 then 
			cell:init(cell.enum_type._SHOW_EQUIP_PATCH, self.shipId)
		else
			cell:init(cell.enum_type._SHOW_HERO_PATCH, self.shipId)
		end 	
		Panel_wj:removeAllChildren(true)
		Panel_wj:addChild(cell)
		
		local name = dms.string(dms["prop_mould"], self.shipId, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        name = setThePropsIcon(self.shipId)[2]
		end
		local quality = dms.int(dms["prop_mould"], self.shipId, prop_mould.prop_quality)+1
		Text_1:setString(name)
		Text_1:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		
		local number = 0
		for i, v in pairs(_ED.user_prop) do
			if tonumber(v.user_prop_template) == tonumber(self.shipId) then
				number = v.prop_number
			end
		end
		Text_3:setString(number)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local getShip = dms.int(dms["prop_mould"], self.shipId, prop_mould.use_of_ship)
			local needNumber = dms.int(dms["prop_mould"], self.shipId, prop_mould.split_or_merge_count)
			if needNumber > 0 and getShip > 0 then
				local ships = fundShipWidthTemplateId(getShip)
				if ships ~= nil then
					local StarRating = tonumber(ships.StarRating)
					if StarRating >= 7 then
						Text_3:setString(number)
					else
						local base_mould2 = dms.int(dms["ship_mould"], tonumber(ships.ship_template_id), ship_mould.base_mould2)
					    local info = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, base_mould2, awaken_requirement.awake_level, StarRating)
					    local demandCount = info[1][awaken_requirement.need_same_card_count]
						Text_3:setString(number.."/"..demandCount)
					end
				else
					Text_3:setString(number.."/"..needNumber)
				end
			elseif needNumber > 0 then
				Text_3:setString(number.."/"..needNumber)
			end
		end
		
		getWay = dms.string(dms["prop_mould"], self.shipId, prop_mould.trace_address)
	elseif self.types == 6 then 		-- 金币
		local cell = ResourcesIconCell:createCell()
	    cell:init(1, 0, -1, nil, nil, false, false, 0)
	    Panel_wj:addChild(cell)

	    local quality = 2
		Text_1:setString(_my_gane_name[1])
		Text_1:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

		Text_3:setString(_ED.user_info.user_silver)
		getWay = dms.string(dms["shop_config"], 9, shop_config.param)
	elseif self.types == 7 then 		-- 荣誉币
		local cell = ResourcesIconCell:createCell()
	    cell:init(3, 0, -1, nil, nil, false, false, 0)
	    Panel_wj:addChild(cell)
	    local quality = 2
		Text_1:setString(_All_tip_string_info._reputation)
		Text_1:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
		Text_3:setString(_ED.user_info.user_honour)
		ccui.Helper:seekWidgetByName(root, "Text_121"):setString(_new_interface_text[204])
	elseif self.types == 8 then 		-- 试炼币
		local cell = ResourcesIconCell:createCell()
	    cell:init(18, 0, -1, nil, nil, false, false, 0)
	    Panel_wj:addChild(cell)
	    local quality = 2
		Text_1:setString(_All_tip_string_info._glories)
		Text_1:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
		Text_3:setString(_ED.user_info.all_glories)
		ccui.Helper:seekWidgetByName(root, "Text_121"):setString(_new_interface_text[205])
	end

	if  _ED.auto_raids_inof and   _ED.auto_raids_inof[3] ~= nil and  _ED.auto_raids_inof[4] ~= nil then
		Text_3:setString(_ED.auto_raids_inof[3].."/".._ED.auto_raids_inof[4])
	end
	
	local derrInfo = nil
	if getWay ~= nil and zstring.tonumber(getWay) ~= -1 then
		local temp = zstring.split(getWay, ",")
		for i, v in pairs(temp) do
			if tonumber(v) > 0 then 
				local genre = dms.int(dms["function_param"], v, function_param.genre)
				if genre == 99 then
					derrInfo = dms.string(dms["function_param"], v, function_param.describe)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				        local describeInfo = ""
				        local describeData = zstring.split(derrInfo, "|")
				        for j, w in pairs(describeData) do
				            local word_info = dms.element(dms["word_mould"], zstring.tonumber(w))
				            describeInfo = describeInfo .. word_info[3]
				        end
				        
				        derrInfo = describeInfo
				    end
					break
				else
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						self:createScollView(temp)
						break
					else
						local cell = EquipFragmentAcquire:createCell()
						cell:init(v)
						ccui.Helper:seekWidgetByName(root, "ListView_1"):addChild(cell)
					end
				end
			else
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
				else
					ccui.Helper:seekWidgetByName(root, "Image_30325"):setVisible(false)
				end
			end
		end
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			ccui.Helper:seekWidgetByName(root, "Image_30325"):setVisible(false)
		end
	end


	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		--英雄碎片去获取，暂无途径的显示与无
		local Text_121 = ccui.Helper:seekWidgetByName(root,"Text_121")
		local numbers = #(ListView_1:getItems())
		--print("numbers",numbers)
		if numbers == 0 then
			Text_121:setVisible(true)
		else
			Text_121:setVisible(false)
		end
		
		if nil ~= derrInfo then
			Text_121:setString(derrInfo)
			Text_121:setVisible(true)
		else
			Text_121:setVisible(false)
		end

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			if numbers <= 3 then
				ListView_1:setTouchEnabled(false)
			end
		end
	elseif __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then
		local Text_121 = ccui.Helper:seekWidgetByName(root,"Text_121")
		local numbers = #(ListView_1:getItems())
		if numbers == 0 then
			Text_121:setVisible(true)
		else
			Text_121:setVisible(false)
		end 
	end
end

function HeroPatchInformationPageGetWay:createScollView(getWays)
	local m_ScrollView = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_to_get")
	m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/3
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	wPosition = sWidth/1
	end
    local Hlindex = 0
    local number = #getWays
    local m_number = math.ceil(number/3)
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	m_number = math.ceil(number/1)
    end
    cellHeight = m_number*172
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    local cell_height = 0
    for j, v in pairs(getWays) do
        local cell = EquipFragmentAcquire:createCell()
		cell:init(v)
        panel:addChild(cell)
        cell_height = cell:getContentSize().height
        tWidth = tWidth + wPosition
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        	if (index-1)%1 ==0 then
	            Hlindex = Hlindex+1
	            tWidth = 0
	            tHeight = sHeight - cell_height*Hlindex  
	        end
	        if index <= 1 then
	            tHeight = sHeight - cell_height
	        end
	    else
	        if (index-1)%3 ==0 then
	            Hlindex = Hlindex+1
	            tWidth = 0
	            tHeight = sHeight - cell_height*Hlindex  
	        end
	        if index <= 3 then
	            tHeight = sHeight - cell_height
	        end
	    end
        cell:setPosition(cc.p(tWidth,tHeight))
        index = index + 1
    end

    m_ScrollView:jumpToTop()
end

function HeroPatchInformationPageGetWay:onEnterTransitionFinish()
	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
		return
	end
	local csbHeroPatchInformationPageGetWay= csb.createNode("packs/to_get.csb")
	
    self:addChild(csbHeroPatchInformationPageGetWay)
	local root = csbHeroPatchInformationPageGetWay:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("hero_patch_information_Page_get_way_close", 0, "hero_patch_information_Page_get_way_close.'")]],isPressedActionEnabled = true}, nil, 2)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.raids_type = 3
		if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
			if fwin:find("SmRoleStrengthenTabRisingStarClass") ~= nil then
				self.raids_type = 0
			end
		end
		self:onUpdateRaidSelection()

		--打开扫荡选择
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_xzcs") , nil, 
		{
			terminal_name = "hero_patch_information_open_raid_selection", 
			terminal_state = 0,
			isPressedActionEnabled = true
		},
		nil, 0):setVisible(false)
		for i=1, 3 do
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_cs_"..i) , nil, 
			{
				terminal_name = "hero_patch_information_open_raid_selection_type", 
				terminal_state = 0,
				_page = i,
				isPressedActionEnabled = true
			},
			nil, 0)
		end
	end



end

function HeroPatchInformationPageGetWay:onExit()
	state_machine.remove("hero_patch_information_Page_get_way_close")
end

function HeroPatchInformationPageGetWay:init(shipId, types,existNumber,totalNumber)
	self.shipId = shipId
	self.types = types			-- nil 为武将  1 为装备    2 为道具  3 时装
	_ED.auto_raids_inof = {types,shipId,tonumber(existNumber),tonumber(totalNumber),tonumber(existNumber)}
end

function HeroPatchInformationPageGetWay:createCell()
	local cell = HeroPatchInformationPageGetWay:new()
	cell:registerOnNodeEvent(cell)
	return cell
end