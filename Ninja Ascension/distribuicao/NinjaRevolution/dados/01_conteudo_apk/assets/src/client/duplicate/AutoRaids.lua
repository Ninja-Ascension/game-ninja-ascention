--[[ ----------------------------------------------------------------------------
-- 查看他人信息
--]] ----------------------------------------------------------------------------
AutoRaids = class("AutoRaidsClass", Window)

-- 打开窗口
local auto_raids_window_open_terminal = {
	_name = "auto_raids_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("AutoRaidsClass") then
			fwin:open(AutoRaids:new():init(params), fwin._windows)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local auto_raids_window_close_terminal = {
	_name = "auto_raids_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("mopping_results_close", 0,'')
		fwin:close(fwin:find("AutoRaidsClass"))
		
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(auto_raids_window_open_terminal)
state_machine.add(auto_raids_window_close_terminal)
state_machine.init()

-- 构造器
function AutoRaids:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena enemy1 page state machine.
	local function init_auto_raids_terminal()
		-- 打开角色创建窗口
		local auto_raids_open_terminal = {
			_name = "auto_raids_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local auto_raids_close_terminal = {
			_name = "auto_raids_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local auto_raids_show_terminal = {
			_name = "auto_raids_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local auto_raids_hide_terminal = {
			_name = "auto_raids_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		local auto_raids_update_time_terminal = {
			_name = "auto_raids_update_time",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local addtime = tonumber(params._datas.addtime)
					instance.currentTime = instance.currentTime  + addtime
					--debug.print_r(instance.currentTime,'instance.currentTime')
					--debug.print_r(instance.maxTimeReal,'instance.maxTimeReal')
					if instance.currentTime > instance.maxTimeReal then
						instance.currentTime = instance.maxTimeReal
					end

					if instance.currentTime < instance.minTime then
						instance.currentTime = instance.minTime
					end

					instance:calTili(instance.currentTime)

					instance:updateTime()
				end

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local auto_raids_saodang_terminal = {
			_name = "auto_raids_saodang",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					-- if zstring.tonumber(instance.usedTlysNumRequest) > 0 then  
					-- 	local propid = 249
					-- 	local number = 0
					-- 	local propType = 0
					-- 	--debug.print_r(instance.bigUsed,'instance.bigUsed')
					-- 	--debug.print_r(instance.midUsed,'instance.midUsed')
					-- 	--debug.print_r(instance.smallUsed,'instance.smallUsed')
					-- 	if zstring.tonumber(instance.bigUsed) > 0 then
					-- 		propid = 249
					-- 		number = instance.bigUsed
					-- 		propType = 249
					-- 	elseif zstring.tonumber(instance.midUsed) > 0  then
					-- 		propid = 248
					-- 		number = instance.midUsed
					-- 		propType = 248
					-- 	elseif zstring.tonumber(instance.smallUsed) > 0  then
					-- 		propid = 247
					-- 		number = instance.smallUsed
					-- 		propType = 247
					-- 	end
					-- 	local function responseUsePropCallback(response)
					-- 		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
					-- 			if response.node == nil or response.node.roots == nil then 
					-- 				return
					-- 			end
					-- 			instance.usedTlysNumRequest = zstring.tonumber(instance.usedTlysNumRequest) - zstring.tonumber(number)
					-- 	--debug.print_r(instance.usedTlysNumRequest,'instance.usedTlysNumRequest')
								
					-- 			if zstring.tonumber(propType) == 249 then
					-- 				instance.bigUsed = 0
					-- 			elseif zstring.tonumber(propType) == 248 then
					-- 				instance.midUsed = 0
					-- 			elseif zstring.tonumber(propType) == 247  then
					-- 				instance.smallUsed = 0
					-- 			end
					-- 			state_machine.excute("auto_raids_saodang", instance, '')
					-- 		end
					-- 	end
					-- 	--debug.print_r(propid,'propid')
					-- 	--debug.print_r(number,'number')
					-- 	protocol_command.prop_use.param_list = fundPropWidthId(propid).user_prop_id.."\r\n" .. number
					-- 	NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, self, responseUsePropCallback,false, nil)
					-- else 
						local data = instance.data
						_ED.auto_raids_real_count = instance.currentTime
						_ED.auto_raids_source = true
						if tonumber(data[1]) == 1000 then
							if data[3] then
								data[3].sweepCount = tonumber(instance.currentTime)
								data[3].totalSweepCount = tonumber(instance.currentTime)
								data[3].totalInitialNumber = tonumber(instance.currentTime)
								data[3].canChangeSweepCount = tonumber(instance.currentTime)
								state_machine.excute("mopping_results_request_plot_copy_sweep", 0, data[3])
							end
						else
							fwin:open(MoppingResults:new():init(data[1], data[2], data[3], instance.currentTime, data[5], data[6],data[7],data[8],data[9]), fwin._windows)
						end
						fwin:close(fwin:find("AutoRaidsClass"))
					-- end

				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		
		
		state_machine.add(auto_raids_update_time_terminal)
		state_machine.add(auto_raids_saodang_terminal)

		state_machine.add(auto_raids_open_terminal)
		state_machine.add(auto_raids_close_terminal)
		state_machine.add(auto_raids_show_terminal)
		state_machine.add(auto_raids_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena enemy1 state machine.
	init_auto_raids_terminal()
end

-- 对象初始化
function AutoRaids:init(params)
	self.data = params
	

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function AutoRaids:calTili(currentTime)
	local current_food = dms.int(dms["npc"], self.data[2], npc.attack_need_food)
	if currentTime <= self.maxTime then
		self.usedTlysNum = 0
		self.needfood = 0
		self.bigUsed = 0
		self.midUsed = 0
		self.smallUsed = 0
	else
		local need = current_food*currentTime - zstring.tonumber(_ED.user_info.user_food)
		local bigYs = getPropAllCountByMouldId('249')*100
		local midYs = getPropAllCountByMouldId('248')*30
		local smallYs = getPropAllCountByMouldId('247')*10

		local bigUsed = 0
		local midUsed = 0
		local smallUsed = 0

		local left = 0
		local bigNum = math.modf( bigYs / need ) --取整数
		----debug.print_r(bigNum,'bigNum')
		-- local left = math.fmod( bigYs / need ) --取余数 
		if bigNum <= 0 then
			bigUsed = getPropAllCountByMouldId('249')
			left = need - bigYs

			local midNum = math.modf( midYs / left ) --取整数
			if midNum <= 0 then
				midUsed = getPropAllCountByMouldId('248')
				left = left - midYs

				smallUsed = math.modf( left/10 ) + 1

			else --中药水够
				midUsed = math.modf( left / 30 ) + 1
				smallUsed = 0
			end
		else --大药水够
			--debug.print_r(need,'need-274---')
			bigUsed = math.modf( need / 100 ) + 1
			if bigUsed > zstring.tonumber(getPropAllCountByMouldId('249')) then
				bigUsed = zstring.tonumber(getPropAllCountByMouldId('249'))
			end
			midUsed = 0
			smallUsed = 0
		end

		----debug.print_r(bigUsed,'bigUsed')
		----debug.print_r(midUsed,'midUsed')
		----debug.print_r(smallUsed,'smallUsed')

		self.usedTlysNum = bigUsed + midUsed + smallUsed
		self.bigUsed = bigUsed
		self.midUsed = midUsed
		self.smallUsed = smallUsed
		self.needfood =  bigUsed*100 + midUsed*30 + smallUsed*10
	end
end


function AutoRaids:updateTime()
	local current_food = dms.int(dms["npc"], self.data[2], npc.attack_need_food)
	
	self.Text_packs_use_n:setString(self.currentTime)
	self.Text_frequency:setString(current_food*self.currentTime..'/'..(zstring.tonumber(_ED.user_info.user_food)+self.needfood))
	self.usedTlysNumRequest = self.usedTlysNum
	self.Text_frequency_small:setString(self.smallUsed..'/'..self.smallTlysNum)
	self.Text_frequency_mid:setString(self.midUsed..'/'..self.midTlysNum)
	self.Text_frequency_big:setString(self.bigUsed..'/'..self.bigTlysNum)

end

function AutoRaids:onUpdateDraw()
	local root = self.roots[1]
	local Panel_wj = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")				 --武将头像
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")				 --武将名字
	local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_packs")				 --武将数量
	Panel_wj:removeAllChildren(true)
	self.types = _ED.auto_raids_inof[1]
	self.shipId =  _ED.auto_raids_inof[2]
	
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

	if  _ED.auto_raids_inof and  _ED.auto_raids_inof[3] ~= nil and  _ED.auto_raids_inof[4] ~= nil then
		Text_3:setString(_ED.auto_raids_inof[3].."/".._ED.auto_raids_inof[4])
	end
	

	
	self:updateTime()
	
	
end

function AutoRaids:onEnterTransitionFinish()
	-- 加载AutoRaidsWindow界面资源.
	-- res.campaign.team_arena.team_arena_enemy_1 = res/campaign/team_arena/team_arena_enemy_1.csb
	local csbNode = csb.createNode("duplicate/pve_auto_sweep.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self.Text_packs_use_n = ccui.Helper:seekWidgetByName(root, "Text_packs_use_n")
	self.Text_frequency = ccui.Helper:seekWidgetByName(root, "Text_frequency")
	self.Text_frequency_small = ccui.Helper:seekWidgetByName(root, "Text_frequency_small")
	self.Text_frequency_mid = ccui.Helper:seekWidgetByName(root, "Text_frequency_mid")
	self.Text_frequency_big = ccui.Helper:seekWidgetByName(root, "Text_frequency_big")


	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "auto_raids_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "auto_raids_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_saodang"), nil,
	{
		terminal_name = "auto_raids_saodang",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	

	self.Button_jian = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jian"), nil,
	{
		terminal_name = "auto_raids_update_time",
		terminal_state = 0,
		addtime = -1,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.Button_minus = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_minus"), nil,
	{
		terminal_name = "auto_raids_update_time",
		terminal_state = 0,
		addtime = -10,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.Button_jia = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jia"), nil,
	{
		terminal_name = "auto_raids_update_time",
		terminal_state = 0,
		addtime = 1,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.Button_plus = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_plus"), nil,
	{
		terminal_name = "auto_raids_update_time",
		terminal_state = 0,
		addtime = 10,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.CheckBox_skip = ccui.Helper:seekWidgetByName(root, "CheckBox_skip")
	self.checkBoxSelect = cc.UserDefault:getInstance():getBoolForKey(getKey("auto_raids"),true)
	self.CheckBox_skip:setSelected(self.checkBoxSelect)
    	
	local function selectedEvent(sender,eventType)
		if eventType == ccui.CheckBoxEventType.selected then
			self.checkBoxSelect = true
			cc.UserDefault:getInstance():setBoolForKey(getKey("auto_raids"),self.checkBoxSelect)
			self.maxTimeReal = self.maxTimeTotal
			if self.maxTimeReal > 100 then
				self.maxTimeReal = 100
			end
		elseif eventType == ccui.CheckBoxEventType.unselected then
			self.checkBoxSelect = false
			cc.UserDefault:getInstance():setBoolForKey(getKey("auto_raids"),self.checkBoxSelect)
			if self.currentTime > self.maxTime then
				self:initData()
				self:updateTime()
			else
				self.maxTimeReal = self.maxTime
				if self.maxTimeReal > 100 then
					self.maxTimeReal = 100
				end
			end
		end
	end
	self.CheckBox_skip:addEventListener(selectedEvent)

	self:initData()
	self:onUpdateDraw()
end


function AutoRaids:initData()
	local current_food = dms.int(dms["npc"], self.data[2], npc.attack_need_food)
	self.minTime = 1
	self.maxTime = math.floor(zstring.tonumber(_ED.user_info.user_food)/current_food)
	self.currentTime = self.maxTime
	self.needfood = 0
	self.usedTlysNum = 0
	self.smallTlysNum = getPropAllCountByMouldId('247')
	self.midTlysNum = getPropAllCountByMouldId('248')
	self.bigTlysNum = getPropAllCountByMouldId('249')
	self.maxTlysNum = self.smallTlysNum + self.midTlysNum + self.bigTlysNum
	self.maxTlFromYs = self.smallTlysNum*10 + self.midTlysNum*30 + self.bigTlysNum*100
	self.maxTimeTotal = math.floor((zstring.tonumber(_ED.user_info.user_food)+self.maxTlFromYs)/current_food)

	self.bigUsed = 0
	self.midUsed = 0
	self.smallUsed = 0

	if self.checkBoxSelect then
		self.maxTimeReal = self.maxTimeTotal
	else
		self.maxTimeReal = self.maxTime
	end
	if self.maxTimeReal > 100 then
		self.maxTimeReal = 100
	end
	if self.currentTime > 100 then
		self.currentTime = 100
	end
	--debug.print_r(self.checkBoxSelect,'self.checkBoxSelect')
	--debug.print_r(self.currentTime,'self.currentTime')
					--debug.print_r(self.maxTimeReal,'self.maxTimeReal')
end

function AutoRaids:onExit()
	-- 释放AutoRaidsWindow界面资源.
	state_machine.remove("auto_raids_open")
	state_machine.remove("auto_raids_close")
	state_machine.remove("auto_raids_show")
	state_machine.remove("auto_raids_hide")
	state_machine.remove("auto_raids_update_time")
	state_machine.remove("auto_raids_saodang")
	
	
end

function AutoRaids:close()
	-- window event : close.
	
end

function AutoRaids:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
