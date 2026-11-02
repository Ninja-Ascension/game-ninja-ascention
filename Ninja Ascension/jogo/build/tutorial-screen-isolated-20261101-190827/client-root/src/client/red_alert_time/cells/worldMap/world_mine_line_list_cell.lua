-----------------------------
--世界侦察阵容
-----------------------------
WorldMineLineListCell = class("WorldMineLineListCellClass", Window)
WorldMineLineListCell.__size = nil

function WorldMineLineListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil
	self._types = 0
	self.have_defence = false
end

function WorldMineLineListCell:onEnterTransitionFinish()
	
end

function WorldMineLineListCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_formation_box_back = ccui.Helper:seekWidgetByName(root,"Panel_formation_box_back")
    local Panel_formation_box_front = ccui.Helper:seekWidgetByName(root,"Panel_formation_box_front")
    -- if self.m_object == nil then
	    Panel_formation_box_back:setPositionY(Panel_formation_box_front._y)
		Panel_formation_box_front:setPositionY(Panel_formation_box_back._y)
	-- end
	for i=1, 6 do
		local Panel_formation_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..i)
		local Panel_formation_position = ccui.Helper:seekWidgetByName(root,"Panel_formation_position_"..i)
		local Text_formation_tank_name = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i)
		local Text_formation_tank_n = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i)
		local Image_formation_tank_n_bg = ccui.Helper:seekWidgetByName(root,"Image_formation_tank_n_bg_"..i)
		local Panel_formation_leader_star = ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i)
		local Text_formation_n = ccui.Helper:seekWidgetByName(root,"Text_formation_n_"..i)
		local Text_formation_leader_n = ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i)
		local Text_formation_leader_name = ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i)

		Panel_formation_tank_icon:removeBackGroundImage()
		Panel_formation_position:removeBackGroundImage()
		Text_formation_tank_name:setString("")
		Text_formation_tank_n:setString("")
		Image_formation_tank_n_bg:setVisible(false)
		Panel_formation_leader_star:setVisible(true)
		Panel_formation_leader_star:removeBackGroundImage()
		Text_formation_n:setString(i)
		Text_formation_leader_n:setVisible(true)
		Text_formation_leader_n:setString(red_alert_time_str[217])
		Text_formation_leader_name:setVisible(true)
		Text_formation_leader_name:setString("")
	end

	if self.have_defence == true then
		local Text_spy_presentation_troops_n = ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_n")
		Text_spy_presentation_troops_n:setString(formation_type_string[57])
		for i = 1, 6 do
			local Text_formation_n = ccui.Helper:seekWidgetByName(root,"Text_formation_n_"..i)
			local Text_formation_leader_n = ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i)
			Text_formation_n:setString(formation_type_string[57])
			Text_formation_leader_n:setString(formation_type_string[57])
		end
	else
		if self._types ~= 0 then
			local attachedInfo = zstring.split(self.m_object.param, "|")
			local attachedOne = zstring.split(attachedInfo[2], ",")
			local attachedTwo = zstring.split(attachedInfo[3], ",")
			
			-- _ED.report_reward_info[4] = "0,13,5,500,5,0,0|0,13,5,500,5,0,0|0,13,5,500,5,0,0|0,13,5,500,5,0,0|0,13,5,500,5,0,0|0,13,5,500,5,0,0"
			local forceData = zstring.split(_ED.report_reward_info[4], "|")
			local ship_number = 0
			local m_environment_formationMould = nil
			local rebel_formation_count = {}
			if tonumber(attachedTwo[8]) == 0 then	--玩家
			elseif tonumber(attachedTwo[8]) == 5 then	--叛军
				local info = zstring.split(_ED.report_reward_info[4], ",")
				local environment_formation_id = dms.int(dms["npc"], tonumber(info[1]), npc.environment_formation1)
				m_environment_formationMould = dms.element(dms["environment_formation"], environment_formation_id)
				for i = 1, 6 do
					table.insert(rebel_formation_count, tonumber(info[i+1]))
				end
			else
				m_environment_formationMould = dms.element(dms["environment_formation"], tonumber(_ED.report_reward_info[4]))
			end
			
			for i=1, 6 do
				if tonumber(attachedTwo[8]) == 0 
					or tonumber(attachedTwo[8]) == 6
					or ((self._types == 200 or self._types == 1200) and tonumber(attachedInfo[1]) == 3) 			-- 协防类型
					then	--玩家
					local ship_info = zstring.split(forceData[i], ",")
					if tonumber(ship_info[3]) > 0 then
						local ships = nil
						local bust_index = 0
						local sign_msg = 0
						local name = ""
						local ship_type = 0
						ships = dms.element(dms["ship_mould"], tonumber(ship_info[2]))
						bust_index = dms.atoi(ships, ship_mould.bust_index)
						sign_msg = dms.atoi(ships, ship_mould.sign_msg)
						name = dms.atos(ships, ship_mould.captain_name)
						ship_type = dms.atoi(ships, ship_mould.ship_type)+1
						ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..i):setBackGroundImage(string.format(config_res.images.ui.props.tank, bust_index))
						ccui.Helper:seekWidgetByName(root,"Panel_formation_position_"..i):setBackGroundImage(string.format(config_res.images.ui.icon.icon, sign_msg+114))
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i):setString(name)
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i):setColor(cc.c3b(color_Type[ship_type][1], color_Type[ship_type][2], color_Type[ship_type][3]))
						local bg = ccui.Helper:seekWidgetByName(root,"Image_formation_tank_n_bg_"..i)
						bg:setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i):setString(ship_info[3])
						local nsize = bg:getContentSize()
						nsize.width = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i):getContentSize().width+1
						bg:setContentSize(nsize)
						ship_number = ship_number + tonumber(ship_info[3])
					end
					if tonumber(ship_info[3]) > 0 and tonumber(ship_info[7]) > 0 then
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setVisible(false)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setVisible(true)--画星星的
						local name = dms.string(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.captain_name)
						local quality = dms.int(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.ship_type)
						local initial_rank_level = dms.int(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.initial_rank_level)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setString(name)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
						ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setBackGroundImage(string.format(config_res.images.ui.icon.icon, initial_rank_level + 118))
					else
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setVisible(false)
						ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setVisible(false)--画星星的
					end
				else
					local ships = nil
					local bust_index = 0
					local sign_msg = 0
					local name = ""
					local ship_type = 0
					ships = dms.element(dms["environment_ship"], dms.atoi(m_environment_formationMould, environment_formation.seat_one + i - 1))
					ship_type = dms.atoi(ships, environment_ship.ship_type)+1
					bust_index = dms.atoi(ships, environment_ship.pic_index)
					sign_msg = dms.atoi(ships, environment_ship.camp_preference)
					name = dms.atos(ships, environment_ship.ship_name)

					local formation_count = 0
					if tonumber(attachedTwo[8]) == 5 then	--叛军
						formation_count = rebel_formation_count[i]
					else
						formation_count = dms.atoi(ships, environment_ship.level)
					end
					if formation_count > 0 then
						ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..i):setBackGroundImage(string.format(config_res.images.ui.props.tank, bust_index))
						ccui.Helper:seekWidgetByName(root,"Panel_formation_position_"..i):setBackGroundImage(string.format(config_res.images.ui.icon.icon, sign_msg+114))
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i):setString(name)
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i):setColor(cc.c3b(color_Type[ship_type][1], color_Type[ship_type][2], color_Type[ship_type][3]))
						local bg = ccui.Helper:seekWidgetByName(root,"Image_formation_tank_n_bg_"..i)
						bg:setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i):setString(formation_count)
						local nsize = bg:getContentSize()
						nsize.width = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i):getContentSize().width+1
						bg:setContentSize(nsize)
						ship_number = ship_number + formation_count
					end

					ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setVisible(true)
					ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
					ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setVisible(false)
					ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setVisible(false)--画星星的
				end
			end
			ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_n"):setString(ship_number)
		else
			if zstring.tonumber(_ED.world_map.investigate_info._type) > 0 then
				if zstring.tonumber(_ED.world_map.investigate_info._user_id) > 0 then
					-- _ED.world_map.investigate_info._formation_info = "12,235,100|987,320,200|0,0,0|0,0,0|0,0,0|0,0,0"
					local ship_number = 0
					local info_s = zstring.split(_ED.world_map.investigate_info._formation_info, "!")
					local formation_info = zstring.split(info_s[2], "|")
					for i=1, 6 do
						local ship_info = zstring.split(formation_info[i], ",")
						if tonumber(ship_info[3]) > 0 then
							local ships = dms.element(dms["ship_mould"], tonumber(ship_info[2]))
							ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..i):setBackGroundImage(string.format(config_res.images.ui.props.tank, dms.atoi(ships, ship_mould.bust_index)))
							ccui.Helper:seekWidgetByName(root,"Panel_formation_position_"..i):setBackGroundImage(string.format(config_res.images.ui.icon.icon, dms.atoi(ships, ship_mould.sign_msg)+114))
							ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i):setString(dms.atos(ships, ship_mould.captain_name))
							local ship_type = dms.atoi(ships, ship_mould.ship_type)+1
							ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i):setColor(cc.c3b(color_Type[ship_type][1], color_Type[ship_type][2], color_Type[ship_type][3]))
							local bg = ccui.Helper:seekWidgetByName(root,"Image_formation_tank_n_bg_"..i)
							bg:setVisible(true)
							ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i):setString(ship_info[3])
							local nsize = bg:getContentSize()
							nsize.width = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i):getContentSize().width+1
							bg:setContentSize(nsize)
							ship_number = ship_number + tonumber(ship_info[3])
						end
						if tonumber(ship_info[3]) > 0 and tonumber(ship_info[7]) > 0 then
							ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setVisible(false)
							ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setVisible(true)
							ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setVisible(true)--画星星的
							local name = dms.string(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.captain_name)
							local quality = dms.int(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.ship_type)
							local initial_rank_level = dms.int(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.initial_rank_level)
							ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setString(name)
							ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
							ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setBackGroundImage(string.format(config_res.images.ui.icon.icon, initial_rank_level + 118))
						else
							ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setVisible(true)
							ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
							ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setVisible(false)
							ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setVisible(false)--画星星的
						end
					end
					ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_n"):setString(ship_number)
				else
					local m_environment_formation_id = dms.int(dms["npc"],zstring.tonumber(_ED.world_map.investigate_info._npc_id),npc.environment_formation1)
					local m_environment_formationMould = dms.element(dms["environment_formation"], m_environment_formation_id)
					local environment_ship_ids = {}
					for i=1, 6 do
						table.insert(environment_ship_ids, dms.atoi(m_environment_formationMould, environment_formation.seat_one + i - 1))

						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setVisible(false)
						ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setVisible(false)
					end
					local m_ship_info = {}
					for i, v in pairs(environment_ship_ids) do
						if v > 0 then
							table.insert(m_ship_info, dms.element(dms["environment_ship"], v))
						end
					end
					local ship_number = 0
					for j, w in pairs(m_ship_info) do
						local formation_count = 0
						if zstring.tonumber(_ED.world_map.investigate_info._type) == 1000 then	--叛军
							formation_count = _ED.world_map.investigate_info.formation_count[j]
						else
							formation_count = dms.atoi(w, environment_ship.level)
						end
						if formation_count > 0 then
							ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..j):setBackGroundImage(string.format(config_res.images.ui.props.tank, dms.atoi(w, environment_ship.pic_index)))
							ccui.Helper:seekWidgetByName(root,"Panel_formation_position_"..j):setBackGroundImage(string.format(config_res.images.ui.icon.icon, dms.atoi(w, environment_ship.camp_preference)+114))
							ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..j):setString(dms.atos(w, environment_ship.ship_name))
							local ship_type = dms.atoi(w, environment_ship.ship_type)+1
							ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..j):setColor(cc.c3b(color_Type[ship_type][1], color_Type[ship_type][2], color_Type[ship_type][3]))
							local bg = ccui.Helper:seekWidgetByName(root,"Image_formation_tank_n_bg_"..j)
							bg:setVisible(true)
							ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..j):setString(formation_count)
							local nsize = bg:getContentSize()
							nsize.width = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..j):getContentSize().width+1
							bg:setContentSize(nsize)
							ship_number = ship_number + formation_count
						end
					end
					
					ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_n"):setString(ship_number)
				
				end
			else
				local ship_number = 0
				local info_s = zstring.split(_ED.world_map.investigate_info._formation_info, "!")
				local formation_info = zstring.split(info_s[2], "|")
				for i=1 , 6 do
					local ship_info = zstring.split(formation_info[i], ",")
					if tonumber(ship_info[3]) > 0 then
						local ships = dms.element(dms["ship_mould"], tonumber(ship_info[2]))
						ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..i):setBackGroundImage(string.format(config_res.images.ui.props.tank, dms.atoi(ships, ship_mould.bust_index)))
						ccui.Helper:seekWidgetByName(root,"Panel_formation_position_"..i):setBackGroundImage(string.format(config_res.images.ui.icon.icon, dms.atoi(ships, ship_mould.sign_msg)+114))
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i):setString(dms.atos(ships, ship_mould.captain_name))
						local ship_type = dms.atoi(ships, ship_mould.ship_type)+1
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i):setColor(cc.c3b(color_Type[ship_type][1], color_Type[ship_type][2], color_Type[ship_type][3]))
						local bg = ccui.Helper:seekWidgetByName(root,"Image_formation_tank_n_bg_"..i)
						bg:setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i):setString(ship_info[3])
						local nsize = bg:getContentSize()
						nsize.width = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i):getContentSize().width+1
						bg:setContentSize(nsize)
						ship_number = ship_number + tonumber(ship_info[3])
					end
					if tonumber(ship_info[3]) > 0 and tonumber(ship_info[7]) > 0 then
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setVisible(false)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setVisible(true)--画星星的
						local name = dms.string(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.captain_name)
						local quality = dms.int(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.ship_type)
						local initial_rank_level = dms.int(dms["ship_mould"], tonumber(ship_info[7]), ship_mould.initial_rank_level)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setString(name)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
						ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setBackGroundImage(string.format(config_res.images.ui.icon.icon, initial_rank_level + 118))
					else
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setVisible(true)
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i):setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
						ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i):setVisible(false)
						ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i):setVisible(false)--画星星的
					end
				end
				ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_n"):setString(ship_number)
			end
		end
	end
end

function WorldMineLineListCell:init(types,m_object,have_defence)
    -- if index ~= nil and index < 5 then
	self._types = types or 0
	self.m_object = m_object or nil
	self.have_defence = have_defence or false
	self:onInit()
    -- end
	self:setContentSize(WorldMineLineListCell.__size)
    return self
end

function WorldMineLineListCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.world.troops_formation_all_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if WorldMineLineListCell.__size == nil then
        WorldMineLineListCell.__size = root:getContentSize()
    end
	
	if ccui.Helper:seekWidgetByName(root,"Panel_formation_box_front")._y == nil then
		ccui.Helper:seekWidgetByName(root,"Panel_formation_box_front")._y = ccui.Helper:seekWidgetByName(root,"Panel_formation_box_front"):getPositionY()
	end
	if ccui.Helper:seekWidgetByName(root,"Panel_formation_box_back")._y == nil then
		ccui.Helper:seekWidgetByName(root,"Panel_formation_box_back")._y = ccui.Helper:seekWidgetByName(root,"Panel_formation_box_back"):getPositionY()
	end
	ccui.Helper:seekWidgetByName(root,"Panel_formation_box_front"):setPositionY(ccui.Helper:seekWidgetByName(root,"Panel_formation_box_front")._y)
	ccui.Helper:seekWidgetByName(root,"Panel_formation_box_back"):setPositionY(ccui.Helper:seekWidgetByName(root,"Panel_formation_box_back")._y)
	--
    -- fwin:addTouchEventListener(root , nil, 
    -- {
        -- terminal_name = "world_nearby_list_cell_positioning", 
        -- terminal_state = 0,
        -- touch_scale = false,
        -- touch_scale_xy = 0.95,
        -- touch_black = true, 
		-- cell = self,
    -- }, nil, 1)    
    
    self:onUpdateDraw() 
end

function WorldMineLineListCell:clearUIInfo( ... )
    local root = self.roots[1]
	if ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_n")~= nil then
		ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_n"):setString("")
		for i=1, 6 do
			local Panel_formation_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..i)
			local Panel_formation_position = ccui.Helper:seekWidgetByName(root,"Panel_formation_position_"..i)
			local Text_formation_tank_name = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..i)
			local Text_formation_tank_n = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..i)
			local Image_formation_tank_n_bg = ccui.Helper:seekWidgetByName(root,"Image_formation_tank_n_bg_"..i)
			local Panel_formation_leader_star = ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..i)
			local Text_formation_n = ccui.Helper:seekWidgetByName(root,"Text_formation_n_"..i)
			local Text_formation_leader_n = ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..i)
			local Text_formation_leader_name = ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..i)

			Panel_formation_tank_icon:removeBackGroundImage()
			Panel_formation_position:removeBackGroundImage()
			Text_formation_tank_name:setString("")
			Text_formation_tank_n:setString("")
			Image_formation_tank_n_bg:setVisible(false)
			Panel_formation_leader_star:setVisible(true)
			Panel_formation_leader_star:removeBackGroundImage()
			Text_formation_n:setString(i)
			Text_formation_leader_n:setVisible(true)
			Text_formation_leader_n:setString(red_alert_time_str[217])
			Text_formation_leader_name:setVisible(true)
			Text_formation_leader_name:setString("")
		end
	end
end

function WorldMineLineListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function WorldMineLineListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.troops_formation_all_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function WorldMineLineListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.troops_formation_all_cell, self.roots[1])
end

function WorldMineLineListCell:createCell()
	local cell = WorldMineLineListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end