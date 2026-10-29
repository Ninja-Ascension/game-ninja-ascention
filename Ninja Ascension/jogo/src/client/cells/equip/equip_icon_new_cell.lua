----------------------------------------------------------------------------------------------------
-- 说明：装备的小图标绘制
-------------------------------------------------------------------------------------------------------
EquipIconNewCell = class("EquipIconNewCellClass", Window)

function EquipIconNewCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_FROM_FORMATION_GOTO_EQUIPMENT_INFORMATION = 1,		-- 从阵容界面进入装备信息界面
		_SHOW_EQUIPMENT_INFORMATION = 2,					-- 查看装备信息
		_SHOW_EMBOITEMENT_INFORMATION = 3,					-- 查看套装信息(不能点击响应)
		_SHOW_EMBOITEMENT_GETWAY = 4,						-- 查看获取途径
		_SHOW_EMENT_BUY = 5,								-- 购买装备时查看信息
		_GO_TO_GET_EQUIP = 6,								-- 去获得装备(不能响应)
		_SHOW_EQUIPMENT_PATCH_INFORMATION = 7,				-- 查看碎片装备
		_SHOW_EQUIPMENT_INFORMATION_IN_FORMATION = 8,		-- 查看装备信息
		_SHOW_EQUIP_CHOOSE_REBORN = 9,		                -- 选择装备重生

	}
	self.equip = nil		-- 当前要绘制的装备实例数据对对象
	self.mould_id = nil
	self.shipData = nil   --穿戴装备的shipId
	self.is_active = false
	self.cell = nil
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_equip_icon_new_cell_terminal()
		
		-- 设计在阵容界面，点击武将小图像需要处理的逻辑
		local equip_icon_cell_change_ship_equip_new_terminal = {
            _name = "equip_icon_cell_change_ship_equip_new",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击武将装备小图像后的响应逻辑
            	local equip = params._datas._equip
				state_machine.excute("open_ship_current_equip_window", 0, equip)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 设计在装备界面，点击装备小图像需要处理的逻辑
		local equip_icon_cell_change_equip_storage_new_terminal = {
            _name = "equip_icon_cell_change_equip_storage_new",
            _init = function (terminal) 
              
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 设计在装备界面，点击装备小图像后的响应逻辑
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		app.load("client.packs.equipment.EquipStrengthenRefineStrorage")
	 				local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
					equipStrengthenRefineStrorageWindow:init(params._datas._equip, "1", params._datas._cell, "equip_list_tan")
	 				fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
            	else
            		app.load("client.packs.equipment.EquipInformation")
	            	local equip = params._datas._equip
					local equipInformation = EquipInformation:new()
					equipInformation:init(equip,params._datas._cell)
					fwin:open(equipInformation, fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 设计在道具购买界面，点击装备小图像需要处理的逻辑
		local equip_icon_cell_change_shop_buy_new_terminal = {
            _name = "equip_icon_cell_change_shop_buy_new",
            _init = function (terminal) 
               app.load("client.cells.prop.prop_information")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 设计在装备界面，点击装备小图像后的响应逻辑
				local cell = propInformation:new()
				cell:init(params._datas._equip,2)
				fwin:open(cell, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 点击装备出售需要处理的逻辑
		local equip_icon_new_cell_show_equip_info_terminal = {
            _name = "equip_icon_new_cell_show_equip_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.equipment.EquipFragmentInfomation")
				local prop = params._datas._equip.user_equiment_template
				local FragmentInformation = EquipFragmentInfomation:new()
				FragmentInformation:init(prop,nil,2)
				fwin:open(FragmentInformation, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 设计在装备界面，点击装备小图像需要处理的逻辑
		local equip_icon_cell_change_equip_storage_new_in_formation_terminal = {
            _name = "equip_icon_cell_change_equip_storage_new_in_formation",
            _init = function (terminal) 
               app.load("client.packs.equipment.EquipInSeeformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 设计在装备界面，点击装备小图像后的响应逻辑
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		--穿戴界面点击装备不响应
            	else
            		if fwin:find("EquipInSeeformationClass") ~= nil then
	            		fwin:close(fwin:find("EquipInSeeformationClass"))
	            	end
	            	local equip = params._datas._equip
					local equipInformation = EquipInSeeformation:new()
					equipInformation:init(equip,params._datas._cell)
					fwin:open(equipInformation, fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(equip_icon_cell_change_ship_equip_new_terminal)	
		state_machine.add(equip_icon_cell_change_equip_storage_new_terminal)	
		state_machine.add(equip_icon_cell_change_shop_buy_new_terminal)	
		state_machine.add(equip_icon_new_cell_show_equip_info_terminal)	
		state_machine.add(equip_icon_cell_change_equip_storage_new_in_formation_terminal)	
        state_machine.init()
	end
	init_equip_icon_new_cell_terminal()
end

function EquipIconNewCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	if Image_2 ~= nil then
		Image_2:setSwallowTouches(false)
	end
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	Panel_ditu:setVisible(true)

	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if item_order_level._x == nil then
		item_order_level._x = item_order_level:getPositionX()
	end
	ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
	-- images/ui/quality
	Panel_prop:setSwallowTouches(false)
	local picIndex = 0
	local quality = 0
	
	item_element={
		"prop_mould",
		"equipment_mould",
		"ship_mould",
	}
	
	local item_index = nil--物品图标索引
	local item_qulityindex = nil--物品品质索引
	local item_nameIndex = nil--物品名称索引
	local item_mouldid = nil--物品模板id

	item_index = equipment_mould.pic_index
	item_qulityindex = equipment_mould.grow_level
	item_nameIndex = equipment_mould.equipment_name
	if self.equip ~= nil and self.equip.user_equiment_template ~= nil then
		item_mouldid= self.equip.user_equiment_template
	else
		item_mouldid = self.mould_id
	end
	
	if self.current_type == self.enum_type._SHOW_EMENT_BUY then
		item_mouldid = self.equip.mould_id
	end
	
	picIndex = dms.int(dms["equipment_mould"], item_mouldid, item_index)
	quality = dms.int(dms["equipment_mould"], item_mouldid, item_qulityindex) + 1
	if self.equip.equipment_quality ~= nil then
		quality = self.equip.equipment_quality + 1
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	else
		Panel_prop:setBackGroundImage(getPropsPath(picIndex))
	end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self.panel_ditu = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", quality))
        if self.panel_ditu ~= nil then
	        self.panel_ditu:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
	        Panel_ditu:addChild(self.panel_ditu)
	    end
	elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))	
	else
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))	
	end
	
	-- Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))

	item_name:setString(dms.string(dms["equipment_mould"], item_mouldid, item_nameIndex))
	item_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	if Panel_num ~= nil then
		Panel_num:setBackGroundImage(string.format("images/ui/quality/level_%d.png", quality))
	end
	
	
	
	if self.equip ~= nil and self.equip.user_equiment_grade ~= nil then 
		if item_lv ~= nil then
			item_lv:setString(self.equip.user_equiment_grade)
		end
	end
	
	if self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION or
		self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION_IN_FORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		item_name:setString("")
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
			local equipByShip = nil
			local ship = fundShipWidthId(self.equip.ship_id)
			if ship ~= nil then
				local captain_type = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.captain_type)
				if captain_type == 0 then
					equipByShip = _ED.user_info.user_name
				else
					equipByShip = ship.captain_name
				end
				
				local rankLevelFront = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.initial_rank_level)  --进阶前的进阶等级
				local ship_name = nil
				if rankLevelFront ~= 0 then
					ship_name = equipByShip.." +"..rankLevelFront		--战船名称
				else
					ship_name = equipByShip
				end
				--print("----------true")
				ccui.Helper:seekWidgetByName(root, "Image_yichuandai"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_3"):setString(" ")
			else
				--print("----------false")
				ccui.Helper:seekWidgetByName(root, "Image_yichuandai"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_3"):setString(" ")
			end
		else
			local equipByShip = nil
			local ship = fundShipWidthId(self.equip.ship_id)
			if ship ~= nil then
				local captain_type = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.captain_type)
				if captain_type == 0 then
					equipByShip = _ED.user_info.user_name
				else
					equipByShip = ship.captain_name
				end
				
				local rankLevelFront = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.initial_rank_level)  --进阶前的进阶等级
				local ship_name = nil
				if rankLevelFront ~= 0 then
					ship_name = equipByShip.." +"..rankLevelFront		--战船名称
				else
					ship_name = equipByShip
				end
				ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
				local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
				Text_3:setString(ship_name)
				if ___is_open_leadname == true then
					Text_3:setFontName("")
					Text_3:setFontSize(Text_3:getFontSize())
				end
			end
		end
	end
	
	if self.current_type == self.enum_type._SHOW_EQUIP_CHOOSE_REBORN then 
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if verifySupportLanguage(_lua_release_language_en) == true then
			item_order_level:setString(_string_piece_info[6]..self.equip.user_equiment_grade)
		else
			item_order_level:setString(self.equip.user_equiment_grade .. _string_piece_info[6])
		end
		item_name:setString("")
		if item_lv ~= nil then
			item_lv:setString("")
		end
	end

	if self.current_type == self.enum_type._SHOW_EMBOITEMENT_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		local suit_id = dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.suit_id)
		if suit_id > 0 then
			if self.equip ~= nil then
				if tonumber(self.equip.ship_id) ~= 0 then
					self.is_active = true
					draw.createEffect("effect_4", "images/ui/effice/zhuangbeidonghua/effect_4.ExportJson", Panel_prop, -1, 10)
				end
			else
				for j,v in pairs(self.shipData.equipment) do
					if v ~= nil then
						local mouldId = zstring.tonumber(v.user_equiment_template)
						if mouldId > 0 then
							local temp_suit_id = dms.int(dms["equipment_mould"],mouldId,equipment_mould.suit_id)
							local equipTypes = dms.int(dms["equipment_mould"],mouldId,equipment_mould.equipment_type)
							if tonumber(mouldId) == tonumber(item_mouldid) then
								if suit_id == temp_suit_id then
									self.is_active = true
									draw.createEffect("effect_4", "images/ui/effice/zhuangbeidonghua/effect_4.ExportJson", Panel_prop, -1, 10)
									break
								end
							end
						end
					end
				end
			end
		end
	end
	
	if self.current_type == self.enum_type._SHOW_EMBOITEMENT_GETWAY then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		item_name:setString("")
	end
	
	if self.current_type == self.enum_type._SHOW_EMENT_BUY then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		item_name:setString("")
	end
	if self.current_type == self.enum_type._GO_TO_GET_EQUIP then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		item_name:setString("")
	end
	if self.current_type == self.enum_type._SHOW_EQUIPMENT_PATCH_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		item_name:setString("")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_new_cell_show_equip_info", terminal_state = 0, _equip = self.equip}, nil, 0)
	end
	if ccui.Helper:seekWidgetByName(root, "Image_o_1") ~= nil
		and ccui.Helper:seekWidgetByName(root, "Image_o_up_1") ~= nil
		then 
		self:showUpStarInfo(item_mouldid)
	end
end


--显示升星属性
function EquipIconNewCell:showUpStarInfo(item_mouldid)
	local root = self.roots[1]
	if root == nil then 
		return
	end

	--升星属性
	local imageName = ""
	for i=1,5 do
		ccui.Helper:seekWidgetByName(root, "Image_o_"..i):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_o_up_"..i):setVisible(false)
	end
	if self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION 
		or self.current_type == self.enum_type._SHOW_EQUIP_CHOOSE_REBORN 
		or self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION_IN_FORMATION
		then 
		--显示上面星星

		imageName = "Image_o_up_"
	end
	if self.current_type == self.enum_type._SHOW_EQUIPMENT_PATCH_INFORMATION then 
		--显示下面星星
		imageName = "Image_o_"
	end 
	
	local maxStar = dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.star_level)
	if imageName == "" or maxStar == nil or maxStar == -1 or self.equip == nil or self.equip.current_star_level == nil then 
		return
	end
	local currentStar = zstring.tonumber(self.equip.current_star_level)
	
	for i=1,5 do
		local startImage = ccui.Helper:seekWidgetByName(root, imageName ..i)
		startImage:setVisible(false)
		 
		if i <= currentStar then 
			startImage:setVisible(true)
		end
	end
	
end

--显示强化等级
function EquipIconNewCell:showGradeLevel()
	local root = self.roots[1]
	local levelText = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
	if levelText ~= nil then
		if verifySupportLanguage(_lua_release_language_en) == true then
			levelText:setString(_string_piece_info[6]..self.equip.user_equiment_grade)
		else
			levelText:setString(self.equip.user_equiment_grade.._string_piece_info[6])
		end
		levelText:setVisible(true)
	end
end

function EquipIconNewCell:isActive()
	return self.is_active
end

function EquipIconNewCell:onEnterTransitionFinish()
	local root = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		root = cacher.createUIRef("icon/item.csb", "root")
		root:removeFromParent(false)
		self:addChild(root)
		root:setColor(cc.c3b(255, 255, 255))
		table.insert(self.roots, root)
		self:onUpdateDraw()
	else
		local csbItem = csb.createNode("icon/item_big.csb")
		root = csbItem:getChildByName("root")
		root:removeFromParent(false)
		self:addChild(root)
		root:setColor(cc.c3b(255, 255, 255))
		table.insert(self.roots, root)
		self:onUpdateDraw()
	end

	if self.current_type == self.enum_type._FROM_FORMATION_GOTO_EQUIPMENT_INFORMATION then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_change_ship_equip_new", terminal_state = 0, _equip = self.equip}, nil, 0)
	elseif self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION then
		local seat_expansion_on_button = ccui.Helper:seekWidgetByName(root, "Panel_prop")
			local function headLayerTouchEvent(sender, evenType)
				local __spoint = sender:getTouchBeganPosition()
				local __mpoint = sender:getTouchMovePosition()
				local __epoint = sender:getTouchEndPosition()
				if ccui.TouchEventType.began == evenType then
					
				elseif evenType == ccui.TouchEventType.moved then
					
				elseif ccui.TouchEventType.ended == evenType or
					ccui.TouchEventType.canceled == evenType then
					--> print(math.abs( __epoint.y - __spoint.y))
					if math.abs( __epoint.y - __spoint.y) < 8 then
						state_machine.excute("equip_icon_cell_change_equip_storage_new", 0, {_datas = {_equip = self.equip, _cell = self.cell}})
					end
				end
			end
		seat_expansion_on_button:addTouchEventListener(headLayerTouchEvent)
	elseif self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION_IN_FORMATION then
		local seat_expansion_on_button = ccui.Helper:seekWidgetByName(root, "Panel_prop")
			local function headLayerTouchEvent(sender, evenType)
				local __spoint = sender:getTouchBeganPosition()
				local __mpoint = sender:getTouchMovePosition()
				local __epoint = sender:getTouchEndPosition()
				if ccui.TouchEventType.began == evenType then
					
				elseif evenType == ccui.TouchEventType.moved then
					
				elseif ccui.TouchEventType.ended == evenType or
					ccui.TouchEventType.canceled == evenType then
					--> print(math.abs( __epoint.y - __spoint.y))
					if math.abs( __epoint.y - __spoint.y) < 8 then
						state_machine.excute("equip_icon_cell_change_equip_storage_new_in_formation", 0, {_datas = {_equip = self.equip, _cell = self.cell}})
					end
				end
			end
		seat_expansion_on_button:addTouchEventListener(headLayerTouchEvent)
	elseif self.current_type == self.enum_type._SHOW_EMENT_BUY then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_change_shop_buy_new", terminal_state = 0, _equip = self.equip}, nil, 0)
	end
end

function EquipIconNewCell:onExit()
	-- state_machine.remove("equip_icon_cell_change_ship_equip")
	-- state_machine.remove("equip_icon_cell_change_equip_storage")
	-- state_machine.remove("equip_icon_cell_change_shop_buy")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        local root = self.roots[1]
        if root == nil then
            return
        end
        local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
        local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
        local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
        local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")
        local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
        if Panel_kuang ~= nil then
        	Panel_kuang:removeAllChildren(true)
        	Panel_kuang:removeBackGroundImage()
        end
        if Panel_prop ~= nil then
        	Panel_prop:removeAllChildren(true)
        	Panel_prop:removeBackGroundImage()
        	fwin:removeTouchEventListener(Panel_prop)
        end
        if Panel_ditu ~= nil then
        	Panel_ditu:removeAllChildren(true)
        	Panel_prop:removeBackGroundImage()
        end
        if Panel_num ~= nil then
        	Panel_num:removeAllChildren(true)
        	Panel_num:removeBackGroundImage()
        end
        if Panel_5 ~= nil then
        	Panel_5:removeAllChildren(true)
        	Panel_5:removeBackGroundImage()
        end

        local Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
        local Image_zhushou = ccui.Helper:seekWidgetByName(root, "Image_zhushou")
        local Image_tuijian = ccui.Helper:seekWidgetByName(root, "Image_tuijian") 
        local Image_bidiao = ccui.Helper:seekWidgetByName(root, "Image_bidiao")
        local Image_dangqian = ccui.Helper:seekWidgetByName(root, "Image_dangqian")
        local Image_yichuandai = ccui.Helper:seekWidgetByName(root, "Image_yichuandai")
        local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
        local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
        local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
        if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_4 ~= nil then
        	Image_4:setVisible(false)
        end
        if Image_zhushou ~= nil then
        	Image_zhushou:setVisible(false)
        end
        if Image_tuijian ~= nil then
        	Image_tuijian:setVisible(false)
        end
        if Image_bidiao ~= nil then
        	Image_bidiao:setVisible(false)
        end
        if Image_dangqian ~= nil then
        	Image_dangqian:setVisible(false)
        end
        if Image_yichuandai ~= nil then
        	Image_yichuandai:setVisible(false)
        end

        local Label_lorder_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
        local Label_name = ccui.Helper:seekWidgetByName(root, "Label_name")
        local Label_quantity = ccui.Helper:seekWidgetByName(root, "Label_quantity")
        local Label_shuxin =ccui.Helper:seekWidgetByName(root, "Label_shuxin")
        local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
        if Label_l_order_level ~= nil then
        	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
        	Label_lorder_level:setString("")
        end
        if Label_name ~= nil then
        	Label_name:setString("")
        	Label_name:setVisible(true)
        end
        if Label_quantity ~= nil then
        	Label_quantity:setString("")
        end
        if Label_shuxin ~= nil then
        	Label_shuxin:setString("")
        end
        if Text_1 ~= nil then
        	Text_1:setString("")
        end

        cacher.freeRef("icon/item.csb", root)
        root:stopAllActions()
        root:removeFromParent(false)
        self.roots = {}
    	
    end	
end

function EquipIconNewCell:init(interfaceType, equip, mould_id, shipData, _cell)
	self.current_type = interfaceType
	self.equip = equip
	self.mould_id = mould_id
	self.shipData = shipData
	self.cell = _cell
end

function EquipIconNewCell:createCell()
	local cell = EquipIconNewCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

