----------------------------------------------------------------------------------------------------
-- 说明：宝物的小图标绘制
-------------------------------------------------------------------------------------------------------
TreasureIconNewCell = class("TreasureIconNewCellClass", Window)

function TreasureIconNewCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.currentTreasure = nil		-- 当前要绘制的装备实例数据对对象
	self.types = nil
	self.isName = nil
	local function init_treasure_icon_new_cell_terminal()
		-- 设计在装备界面，点击装备小图像需要处理的逻辑
		local treasure_icon_new_cell_show_info_terminal = {
            _name = "treasure_icon_new_cell_show_info",
            _init = function (terminal) 
               app.load("client.packs.equipment.EquipInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 设计在装备界面，点击装备小图像后的响应逻辑
            	local equip = params._datas._equip

            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    				local tcp = TreasureControllerPanel:new()
					tcp:setCurrentTreasure(params._datas._equip)
					fwin:open(tcp, fwin._view)
            	else
					local equipInformation = EquipInformation:new()
					equipInformation:init(equip)
					fwin:open(equipInformation, fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 点击宝物出售需要处理的逻辑
		local treasure_icon_new_cell_show_treasure_info_terminal = {
            _name = "treasure_icon_new_cell_show_treasure_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.equipment.EquipFragmentInfomation")
				local prop = params._datas._equip.user_equiment_template
				local FragmentInformation = EquipFragmentInfomation:new()
				FragmentInformation:init(prop,nil,3)
				fwin:open(FragmentInformation, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- state_machine.init()
		state_machine.add(treasure_icon_new_cell_show_info_terminal)	
		state_machine.add(treasure_icon_new_cell_show_treasure_info_terminal)	
	end
	init_treasure_icon_new_cell_terminal()
end

function TreasureIconNewCell:onUpdateDraw()
	local root = self.roots[1]
	
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	Image_2:setSwallowTouches(false)
	
	--获取数据
	local item_mouldid = self.currentTreasure.user_equiment_template --宝物的模板id
	local picIndex = dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.pic_index)
	local quality = dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.grow_level) + 1
	--获取美术资源
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	--打入图片
	Panel_prop:setBackGroundImage(getPropsPath(picIndex))
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		else
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
		end
	end
	Panel_prop:setSwallowTouches(false)
	local equipByShip = nil
	local ship = fundShipWidthId(self.currentTreasure.ship_id)
	if ship ~= nil then
		-- equipByShip = ship.captain_name
		local captain_type = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.captain_type)
			if captain_type == 0 then
				equipByShip = _ED.user_info.user_name
				if ___is_open_leadname == true then
					local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
					Text_3:setFontName("")
					Text_3:setFontSize(Text_3:getFontSize())
				end
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
		local Image_yichuandai = ccui.Helper:seekWidgetByName(root, "Image_yichuandai")
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			Image_yichuandai:setVisible(false)
			Image_yichuandai:setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
		end
		ccui.Helper:seekWidgetByName(root, "Text_3"):setString(ship_name)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString(" ")
		end
	end
	if self.isName == true then
		if verifySupportLanguage(_lua_release_language_en) == true then
			ccui.Helper:seekWidgetByName(root, "Label_l-order_level"):setString(_string_piece_info[6]..self.currentTreasure.user_equiment_grade)
		else
			ccui.Helper:seekWidgetByName(root, "Label_l-order_level"):setString(self.currentTreasure.user_equiment_grade.._string_piece_info[6])
		end
	end
	
end

function TreasureIconNewCell:onEnterTransitionFinish()
	-- local csbItem = csb.createNode("icon/item_big.csb")
	-- local root = csbItem:getChildByName("root")
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
		if root._x == nil then
			root._x = 0
		end
		if root._y == nil then
			root._x = 0
		end
	else
		local csbItem = csb.createNode("icon/item_big.csb")
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end
	
	--开始绘制icon
	self:onUpdateDraw()
	if self.types == 2 then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "treasure_icon_new_cell_show_treasure_info", terminal_state = 0, _equip = self.currentTreasure}, nil, 0)
	else
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "treasure_icon_new_cell_show_info", terminal_state = 0, _equip = self.currentTreasure}, nil, 0)
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
						state_machine.excute("treasure_icon_new_cell_show_info", 0, {_datas = {_equip = self.currentTreasure}})
					end
				end
			end
		seat_expansion_on_button:addTouchEventListener(headLayerTouchEvent)
	end
end

function TreasureIconNewCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
		if root._x ~= nil then
	    	root:setPositionX(root._x)
	    end
	    if root._y ~= nil then
	    	root:setPositionY(root._y)
	    end
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function TreasureIconNewCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
	    cacher.freeRef("icon/item.csb", root)
	end
end

function TreasureIconNewCell:init(value,types,isName)
	self.currentTreasure = value
	self.types = types
	self.isName = isName
end

function TreasureIconNewCell:createCell()
	local cell = TreasureIconNewCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

