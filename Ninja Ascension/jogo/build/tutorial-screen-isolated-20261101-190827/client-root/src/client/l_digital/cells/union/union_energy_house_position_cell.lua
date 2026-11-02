--------------------------------------------------------------------------------------------------------------
--  说明：能量屋的台子
--------------------------------------------------------------------------------------------------------------
unionEnergyHousePositionCell = class("unionEnergyHousePositionCellClass", Window)
unionEnergyHousePositionCell.__size = nil
function unionEnergyHousePositionCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.last = 0
	self.example = nil
	self.index = 0
	self.expText = nil
	app.load("client.l_digital.union.meeting.SmUnionEnergyHouseSelect")
	 -- Initialize union rank list cell state machine.
    local function init_union_energy_house_position_cell_terminal()
        local union_energy_house_position_cell_select_ship_terminal = {
            _name = "union_energy_house_position_cell_select_ship",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	state_machine.excute("sm_union_energy_house_select_open", 0, cell.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_energy_house_position_cell_accelerate_terminal = {
            _name = "union_energy_house_position_cell_accelerate",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	local function responseUnionCreateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    		response.node:updateNewInfo()
                    		response.node:updateDraw()
                    	end
                    	local add_silver = dms.int(dms["union_config"], 30, union_config.param)
                    	TipDlg.drawTextDailog(string.format(_new_interface_text[192], ""..add_silver))
                    end
                end
                local shipData = zstring.split(cell.training_info,",")
           		protocol_command.union_ship_train_help.param_list = cell.memberInfo.id.."\r\n".."0".."\r\n"..cell.index.."\r\n"..shipData[3]
                NetworkManager:register(protocol_command.union_ship_train_help.code, nil, nil, nil, cell, responseUnionCreateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_energy_house_position_cell_buy_cell_terminal = {
            _name = "union_energy_house_position_cell_buy_cell",
            _init = function (terminal)
               app.load("client.l_digital.union.meeting.SmUnionEnergyHouseTipsWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	state_machine.excute("sm_union_energy_house_tips_window_open", 0, cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --加经验动画
        local union_energy_house_position_cell_add_exp_show_terminal = {
            _name = "union_energy_house_position_cell_add_exp_show",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	params:showExpAdd(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_energy_house_position_cell_select_ship_terminal)
		state_machine.add(union_energy_house_position_cell_accelerate_terminal)
		state_machine.add(union_energy_house_position_cell_buy_cell_terminal)
		state_machine.add(union_energy_house_position_cell_add_exp_show_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_union_energy_house_position_cell_terminal()

end

function unionEnergyHousePositionCell:updateNewInfo()
	local member_id = tonumber(self.member_id)
	local index = self.index

	self.m_type = 0

	local memberInfo = nil
	local member_data = nil
	if member_id == tonumber(_ED.user_info.user_id) then
		self.m_type = 1
		member_data = _ED.union_personal_energy_info
	else
		self.m_type = 0

		for i, v in pairs(_ED.union.union_member_list_info) do
			if member_id == tonumber(v.id) then
				memberInfo = v
				break
			end
		end

		for i, v in pairs(_ED.union_member_energy_info) do
	        if member_id == tonumber(v.member_id) then
	            member_data = v.member_data
	        end
	    end
	end

    local my_data = zstring.split(member_data, "|")
    local openData = zstring.split(my_data[2],",")

	self.openData = tonumber(openData[index])
	self.training_info = my_data[2+index]
	self.count_info = my_data[1]

	self.memberInfo = memberInfo or nil
end

function unionEnergyHousePositionCell:showExpAdd( cell )
	if _ED.old_union_personal_energy_info ~= nil then
		cell:updateNewInfo()
		cell:updateDrawEX()
		local oldData = zstring.split(_ED.old_union_personal_energy_info,"|")
		local oldShipData = zstring.split(oldData[2 + cell.index],",")
		local shipData = zstring.split(cell.training_info,",")
		if tonumber(shipData[3]) ~= 0 and tonumber(shipData[3]) == tonumber(oldShipData[3]) then --同一战船 
			local Text_digimon_lv = ccui.Helper:seekWidgetByName(cell.roots[1], "Text_digimon_lv")
		    if self.m_type == 1 then
		    	-- por ship_id (shipData[3]), no por molde (shipData[4])
		    	local shipInfo = fundShipWidthId(""..shipData[3])
		    	if shipInfo ~= nil then
		    		shipData[5] = shipInfo.ship_grade
		    	end
		    end
	    	Text_digimon_lv:setString("Lv."..shipData[5])
			local addExp = tonumber(fundShipWidthId(""..shipData[3]).change_experience)
			if addExp ~= nil and addExp > 0 then
				fundShipWidthId(""..shipData[3]).change_experience = 0
				cell.expText:setString(string.format(_new_interface_text[8] , addExp))
				local function action1()
					cell.expText:setVisible(true)
				end
				local action2 = cc.MoveBy:create(0.8, cc.p(0, 80))
				local function action3()
					cell.expText:setVisible(false)
				end
				local action4 = cc.MoveBy:create(0.1, cc.p(0, -80))
				cell.expText:runAction(cc.Sequence:create(
					cc.CallFunc:create(action1),
					action2,
					cc.CallFunc:create(action3),
					action4))
			end
		end
	end
end

function unionEnergyHousePositionCell:updateDrawEX()
	local root = self.roots[1]
	local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")
	local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
	local Text_open_lv_info = ccui.Helper:seekWidgetByName(root, "Text_open_lv_info")
	local Panel_sz = ccui.Helper:seekWidgetByName(root, "Panel_sz")

	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")

	local param = zstring.split(dms.string(dms["union_config"], 24, union_config.param) ,"|")
	local openData = zstring.split(param[self.index],",")
	local level = 0
	if self.openData == 0 then
		if self.m_type == 1 then
			level = tonumber(_ED.user_info.user_grade)
		else
			level = self.memberInfo.level
		end
		if tonumber(level) >= tonumber(openData[1]) then
			--如果不要宝石就直接开
			if tonumber(openData[2]) == 0 then
				Image_add:setVisible(true)
				Image_lock:setVisible(false)
				Panel_digimon_icon:setVisible(true)
				if tonumber(self.m_type) == 1 then
					--进入选择
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
				    {
				        terminal_name = "union_energy_house_position_cell_select_ship", 
				        terminal_state = 0,
				        cell = self
				    }, 
				    nil, 0)
				end
			else
				Image_add:setVisible(false)
				Image_lock:setVisible(true)
				Text_open_lv_info:setString(string.format(_new_interface_text[64],zstring.tonumber(openData[2])))
				Panel_digimon_icon:setVisible(true)
				if tonumber(self.m_type) == 1 then
					--宝石解锁
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
				    {
				        terminal_name = "union_energy_house_position_cell_buy_cell", 
				        terminal_state = 0,
				        cell = self
				    }, 
				    nil, 0)
				end
			end
		else
			Image_add:setVisible(false)
			Image_lock:setVisible(true)
			Text_open_lv_info:setString(string.format(_new_interface_text[65],zstring.tonumber(openData[1])))	
			Panel_digimon_icon:setVisible(false)
		end
	elseif self.openData == 1 then
		Image_add:setVisible(true)
		Image_lock:setVisible(false)
		Panel_digimon_icon:setVisible(true)
		if tonumber(self.m_type) == 1 then
			--进入选择
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
		    {
		        terminal_name = "union_energy_house_position_cell_select_ship", 
		        terminal_state = 0,
		        cell = self
		    }, 
		    nil, 0)
		end
	end
	--加速次数,被加速次数|所有位置的开启状态|训练模板ID,训练上次结算时间,SHIP实例ID,实例模板ID,实例等级,实例当前经验,实例当前品级,实例进化编号|...
	local shipData = zstring.split(self.training_info,",")
	--形象
	
	local Button_js = ccui.Helper:seekWidgetByName(root,"Button_js")

	-- Panel_digimon_icon:removeAllChildren(true)
	if tonumber(shipData[3]) ~= 0 then
		Panel_sz:setVisible(true)
		Image_add:setVisible(false)
		Image_lock:setVisible(false)
		----------------------新的数码的形象------------------------
	    --进化形象
	 --    local evo_image = dms.string(dms["ship_mould"], shipData[4], ship_mould.fitSkillTwo)
	 --    local evo_info = zstring.split(evo_image, ",")
	    
	 --    --进化模板id
	 --    local evo_mould_id = evo_info[tonumber(shipData[8])]

	 --    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		-- local word_info = dms.element(dms["word_mould"], name_mould_id)
		-- local hero_name = word_info[3]
		-- --武将
		-- if getShipNameOrder(tonumber(shipData[7])) > 0 then
	 --        hero_name = hero_name.." +"..getShipNameOrder(tonumber(shipData[7]))
	 --    end
	 --    --新的形象编号
	 --    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
	    
	 --    -- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_hero_110, nil, nil, cc.p(0.5, 0))
	 --    local armature_hero = sp.spine_sprite(Panel_digimon_icon, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	 --    armature_hero:setScaleX(-1)
	 --    armature_hero.animationNameList = spineAnimations
	 --    sp.initArmature(armature_hero, true)

	 --    --名称
	 --    local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name")
	 --    Text_digimon_name:setString(hero_name)
	 --    local quality = 1
	 --    quality = shipOrEquipSetColour(tonumber(shipData[7]))
	 --    local color_R = tipStringInfo_quality_color_Type[quality][1]
	 --    local color_G = tipStringInfo_quality_color_Type[quality][2]
	 --    local color_B = tipStringInfo_quality_color_Type[quality][3]
	 --    Text_digimon_name:setColor(cc.c3b(color_R, color_G, color_B))

	    local Text_digimon_lv = ccui.Helper:seekWidgetByName(root, "Text_digimon_lv")
	    if self.m_type == 1 then
	    	-- por ship_id (shipData[3]), no por molde (shipData[4])
	    	local shipInfo = fundShipWidthId(""..shipData[3])
	    	if shipInfo ~= nil then
	    		shipData[5] = shipInfo.ship_grade
	    	end
	    end
	    Text_digimon_lv:setString("Lv."..shipData[5])

	    --经验
	   	local LoadingBar_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_exp")
	   	local Text_exp = ccui.Helper:seekWidgetByName(root, "Text_exp")

	   	--找到对应的战船升级的经验
	   	--先找模板里的资质
	   	local ability = dms.int(dms["ship_mould"], shipData[4], ship_mould.ability)
	   	--再找对应等级在ship_experience_param里的数据
	   	local needExp = dms.int(dms["ship_experience_param"], tonumber(shipData[5]) + 1, ability-13+3)
	   	if tonumber(shipData[6]) >= needExp then
	   		if tonumber(shipData[5]) >= tonumber(_ED.user_info.user_grade) then
	   			Text_exp:setString("MAX")
	   		else
	   			Text_exp:setString(shipData[6].."/"..needExp)
	   		end
	   		LoadingBar_exp:setPercent(100)
	   	else
	   		Text_exp:setString(shipData[6].."/"..needExp)
	   		LoadingBar_exp:setPercent(tonumber(shipData[6])/needExp*100)
	   	end

	   	if self.m_type == 1 then
	   		Button_js:setVisible(false)
		else
			local can_accelerate = true

			-- 是否有剩余次数
		    local my_data = zstring.split(_ED.union_personal_energy_info,"|")
		    local accelerate = zstring.split(my_data[1],",")
		    local param = zstring.split(dms.string(dms["union_config"], 25, union_config.param) ,",")
		    local leave_times = tonumber(param[1])-tonumber(accelerate[1])
		    if leave_times <= 0 then
		    	can_accelerate = false
		    end

		    -- 是否剩余被加速次数
		    local count_info = zstring.split(self.count_info, ",")
		    if  tonumber(param[2])-tonumber(count_info[2]) <= 0 then
		    	can_accelerate = false
		    end

		    -- 是否已满级
		    if tonumber(shipData[5]) >= level and tonumber(shipData[6]) >= tonumber(needExp) then
		    	can_accelerate = false
		    end

		    if can_accelerate == true then
		    	Button_js:setVisible(true)
		    else
		    	Button_js:setVisible(false)
		    end
		end
	else
		Panel_sz:setVisible(false)
	end
end

function unionEnergyHousePositionCell:updateDraw()
	local root = self.roots[1]
	local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")
	local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
	local Text_open_lv_info = ccui.Helper:seekWidgetByName(root, "Text_open_lv_info")
	local Panel_sz = ccui.Helper:seekWidgetByName(root, "Panel_sz")

	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")

	local param = zstring.split(dms.string(dms["union_config"], 24, union_config.param) ,"|")
	local openData = zstring.split(param[self.index],",")
	local level = 0
	if self.openData == 0 then
		if self.m_type == 1 then
			level = tonumber(_ED.user_info.user_grade)
		else
			level = self.memberInfo.level
		end
		if tonumber(level) >= tonumber(openData[1]) then
			--如果不要宝石就直接开
			if tonumber(openData[2]) == 0 then
				Image_add:setVisible(true)
				Image_lock:setVisible(false)
				Panel_digimon_icon:setVisible(true)
				if tonumber(self.m_type) == 1 then
					--进入选择
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
				    {
				        terminal_name = "union_energy_house_position_cell_select_ship", 
				        terminal_state = 0,
				        cell = self
				    }, 
				    nil, 0)
				end
			else
				Image_add:setVisible(false)
				Image_lock:setVisible(true)
				Text_open_lv_info:setString(string.format(_new_interface_text[64],zstring.tonumber(openData[2])))
				Panel_digimon_icon:setVisible(true)
				if tonumber(self.m_type) == 1 then
					--宝石解锁
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
				    {
				        terminal_name = "union_energy_house_position_cell_buy_cell", 
				        terminal_state = 0,
				        cell = self
				    }, 
				    nil, 0)
				end
			end
		else
			Image_add:setVisible(false)
			Image_lock:setVisible(true)
			Text_open_lv_info:setString(string.format(_new_interface_text[65],zstring.tonumber(openData[1])))	
			Panel_digimon_icon:setVisible(false)
		end
	elseif self.openData == 1 then
		Image_add:setVisible(true)
		Image_lock:setVisible(false)
		Panel_digimon_icon:setVisible(true)
		if tonumber(self.m_type) == 1 then
			--进入选择
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
		    {
		        terminal_name = "union_energy_house_position_cell_select_ship", 
		        terminal_state = 0,
		        cell = self
		    }, 
		    nil, 0)
		end
	end
	--加速次数,被加速次数|所有位置的开启状态|训练模板ID,训练上次结算时间,SHIP实例ID,实例模板ID,实例等级,实例当前经验,实例当前品级,实例进化编号|...
	local shipData = zstring.split(self.training_info,",")
	debug.print_r(self.training_info)
	--形象
	
	local Button_js = ccui.Helper:seekWidgetByName(root,"Button_js")

	Panel_digimon_icon:removeAllChildren(true)
	if tonumber(shipData[3]) ~= 0 then
		Panel_sz:setVisible(true)
		Image_add:setVisible(false)
		Image_lock:setVisible(false)
		----------------------新的数码的形象------------------------
	    --进化形象
	    local evo_image = dms.string(dms["ship_mould"], shipData[4], ship_mould.fitSkillTwo)
	    local evo_info = zstring.split(evo_image, ",")
	    
	    --进化模板id
	    local ships = _ED.user_ship["" .. shipData[3]]
	    local evo_mould_id = 0
	    if ships ~= nil then
		    local ship_evo = zstring.split(ships.evolution_status, "|")
			local evo_level = tonumber(ship_evo[1])
			evo_mould_id = smGetSkinEvoIdChange(ships)
		else
			evo_mould_id = evo_info[tonumber(shipData[8])]
		end
	    -- local evo_mould_id = evo_info[tonumber(shipData[8])]

	    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		local hero_name = word_info[3]
		--武将
		if getShipNameOrder(tonumber(shipData[7])) > 0 then
	        hero_name = hero_name.." +"..getShipNameOrder(tonumber(shipData[7]))
	    end
	    --新的形象编号
	    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
	    
	    -- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_hero_110, nil, nil, cc.p(0.5, 0))
	    local armature_hero = sp.spine_sprite(Panel_digimon_icon, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	    armature_hero:setScaleX(-1)
	    armature_hero.animationNameList = spineAnimations
	    sp.initArmature(armature_hero, true)

	    --名称
	    local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name")
	    Text_digimon_name:setString(hero_name)
	    local quality = 1
	    quality = shipOrEquipSetColour(tonumber(shipData[7]))
	    local color_R = tipStringInfo_quality_color_Type[quality][1]
	    local color_G = tipStringInfo_quality_color_Type[quality][2]
	    local color_B = tipStringInfo_quality_color_Type[quality][3]
	    Text_digimon_name:setColor(cc.c3b(color_R, color_G, color_B))

	    local Text_digimon_lv = ccui.Helper:seekWidgetByName(root, "Text_digimon_lv")
	    if self.m_type == 1 then
	    	-- por ship_id (shipData[3]), no por molde (shipData[4])
	    	local shipInfo = fundShipWidthId(""..shipData[3])
	    	if shipInfo ~= nil then
	    		shipData[5] = shipInfo.ship_grade
	    	end
	    end
	    Text_digimon_lv:setString("Lv."..shipData[5])

	    --经验
	   	local LoadingBar_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_exp")
	   	local Text_exp = ccui.Helper:seekWidgetByName(root, "Text_exp")

	   	--找到对应的战船升级的经验
	   	--先找模板里的资质
	   	local ability = dms.int(dms["ship_mould"], shipData[4], ship_mould.ability)
	   	--再找对应等级在ship_experience_param里的数据
	   	local needExp = dms.int(dms["ship_experience_param"], tonumber(shipData[5]) + 1, ability-13+3)
	   	if tonumber(shipData[6]) >= needExp then
	   		if tonumber(shipData[5]) >= tonumber(_ED.user_info.user_grade) then
	   			Text_exp:setString("MAX")
	   		else
	   			Text_exp:setString(shipData[6].."/"..needExp)
	   		end
	   		LoadingBar_exp:setPercent(100)
	   	else
	   		Text_exp:setString(shipData[6].."/"..needExp)
	   		LoadingBar_exp:setPercent(tonumber(shipData[6])/needExp*100)
	   	end

	   	if self.m_type == 1 then
	   		Button_js:setVisible(false)
		else
			local can_accelerate = true

			-- 是否有剩余次数
		    local my_data = zstring.split(_ED.union_personal_energy_info,"|")
		    local accelerate = zstring.split(my_data[1],",")
		    local param = zstring.split(dms.string(dms["union_config"], 25, union_config.param) ,",")
		    local leave_times = tonumber(param[1])-tonumber(accelerate[1])
		    if leave_times <= 0 then
		    	can_accelerate = false
		    end

		    -- 是否剩余被加速次数
		    local count_info = zstring.split(self.count_info, ",")
		    if  tonumber(param[2])-tonumber(count_info[2]) <= 0 then
		    	can_accelerate = false
		    end

		    -- 是否已满级
		    if tonumber(shipData[5]) >= level and tonumber(shipData[6]) >= tonumber(needExp) then
		    	can_accelerate = false
		    end

		    if can_accelerate == true then
		    	Button_js:setVisible(true)
		    else
		    	Button_js:setVisible(false)
		    end
		end
	else
		Panel_sz:setVisible(false)
	end
end

function unionEnergyHousePositionCell:onInit()

	local csbunionEnergyHousePositionCell= csb.createNode("legion/sm_legion_energy_house_position.csb")
    local root = csbunionEnergyHousePositionCell:getChildByName("root")
    table.insert(self.roots, root)
	
	 
    self:addChild(csbunionEnergyHousePositionCell)
	if unionEnergyHousePositionCell.__size == nil then
		unionEnergyHousePositionCell.__size = root:getChildByName("Panel_6"):getContentSize()
	end	
	if tonumber(self.m_type) == 1 then
		local param = zstring.split(dms.string(dms["union_config"], 24, union_config.param) ,"|")
		local openData = zstring.split(param[self.index],",")
		if self.openData == 0 then
			local level = 0
			if self.m_type == 1 then
				level = tonumber(_ED.user_info.user_grade)
			else
				level = self.memberInfo.level
			end
			if tonumber(level) >= tonumber(openData[1]) then
				--如果不要宝石就直接开
				if tonumber(openData[2]) == 0 then
					--进入选择
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
				    {
				        terminal_name = "union_energy_house_position_cell_select_ship", 
				        terminal_state = 0,
				        cell = self
				    }, 
				    nil, 0)
				else
					--宝石解锁
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
				    {
				        terminal_name = "union_energy_house_position_cell_buy_cell", 
				        terminal_state = 0,
				        cell = self
				    }, 
				    nil, 0)
				end
			end
		else
			--进入选择
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"), nil, 
		    {
		        terminal_name = "union_energy_house_position_cell_select_ship", 
		        terminal_state = 0,
		        cell = self
		    }, 
		    nil, 0)	
		end
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_js"), nil, 
	    {
	        terminal_name = "union_energy_house_position_cell_accelerate", 
	        terminal_state = 0,
	        isPressedActionEnabled = true,
	        cell = self
	    }, 
	    nil, 0)    
	end

	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")
	Panel_digimon_icon:setSwallowTouches(false)
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_open_lv_info"):getFontName()
    local ttfConfig = {}
    ttfConfig.fontFilePath=fontName
    ttfConfig.fontSize=24
	self.expText = cc.Label:createWithTTF(ttfConfig, "Green", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 180)
	self:addChild(self.expText)
	self.expText:setVisible(false)
	self.expText:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
	self.expText:setPosition(cc.p(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon"):getPosition()))

	self:updateNewInfo()
	self:updateDraw()
end

function unionEnergyHousePositionCell:onEnterTransitionFinish()

end

function unionEnergyHousePositionCell:init(index,member_id)
	self.index = tonumber(index)
	self.member_id = tonumber(member_id)

	self:onInit()
	self:setContentSize(unionEnergyHousePositionCell.__size)
	-- self:onInit()
	return self
end

function unionEnergyHousePositionCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function unionEnergyHousePositionCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_energy_house_position.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function unionEnergyHousePositionCell:onExit()
	cacher.freeRef("legion/sm_legion_energy_house_position.csb", self.roots[1])
end

function unionEnergyHousePositionCell:createCell()
	local cell = unionEnergyHousePositionCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
