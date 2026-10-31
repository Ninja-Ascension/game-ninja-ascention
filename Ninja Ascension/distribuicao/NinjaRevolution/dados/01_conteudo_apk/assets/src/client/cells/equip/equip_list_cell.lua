----------------------------------------------------------------------------------------------------
-- 说明：装备仓库装备信息列
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipListCell = class("EquipListCellClass", Window)
EquipListCell.__size = nil
   
function EquipListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	
    local function init_equip_list_cell_terminal()
		-- local equip_list_expand_page_terminal = {
            -- _name = "equip_list_expand_page",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xia"):setVisible(false)
				-- -- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_shou"):setVisible(true)
				
				-- local EquipStrengthenRefineStrorage = EquipStrengthenRefineStrorage:createCell()
				-- EquipStrengthenRefineStrorage:init(instance.equipmentInstance)
				-- fwin:open(EquipStrengthenRefineStrorage, fwin._view)
				
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		local equip_list_update_page_terminal = {
            _name = "equip_list_update_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params ~= nil and params._datas._cell ~= nil and params._datas._cell.roots ~= nil and params._datas._cell.onUpdateDraw ~= nil then
					params._datas._cell:onUpdateDraw()
					 -- print(params._datas._cell.equipmentInstance.user_equiment_name)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(equip_list_update_page_terminal)
		-- state_machine.add(equip_list_recover_page_terminal)
        state_machine.init()
    end
    
    init_equip_list_cell_terminal()
end

function EquipListCell:onUpdateDraw()
	local root = self.roots[1]
	local name = ccui.Helper:seekWidgetByName(root, "Label_717_0")
	local equipType = ccui.Helper:seekWidgetByName(root, "Label_property_4")
	equipType:setString("")
	local equipBy = ccui.Helper:seekWidgetByName(root, "Label_725_0")
	local equipLevel = ccui.Helper:seekWidgetByName(root, "Text_2")
	local refineLevel = ccui.Helper:seekWidgetByName(root, "Text_30102")
	refineLevel:setString("")
	-- local refineLevelPic = ccui.Helper:seekWidgetByName(root, "Image_6")
	local picPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
	
	ccui.Helper:seekWidgetByName(root, "Image_13"):setVisible(false)
	
	ccui.Helper:seekWidgetByName(root, "Label_property_2"):setString("")
	local Mytype = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type)
	local str = nil
	if Mytype == 0 then
		str = "[" .. _string_piece_info[7] .. "]"
	elseif Mytype == 1 then
		str = "[" .. _string_piece_info[9] .. "]"
	elseif Mytype == 2 then
		str = "[" .. _string_piece_info[8] .. "]"
	elseif Mytype == 3 then
		str = "[" .. _string_piece_info[10] .. "]"
	end
	
	-- local equipByShip = nil
	-- local ship = fundShipWidthId(self.equipmentInstance.ship_id)
	-- if ship ~= nil then
		-- equipByShip = ship.captain_name
	-- end
	
	-- user_equiment_ability 用户装备能力值
	local temp = zstring.zsplit(self.equipmentInstance.user_equiment_ability, "|")
	local labelNodes = {
		"Label_property",
		"Label_property_3",
	}

	local valueLabel1 = ccui.Helper:seekWidgetByName(root, "Label_property")
	local valueLabel2 = ccui.Helper:seekWidgetByName(root, "Label_property_3")
	local valueLabelList = { valueLabel1, valueLabel2 }
	valueLabel1:setString("")
	valueLabel2:setString("")
	
	for i,v in pairs(temp) do
		if i> 2 then
			break
		end
		local influenceType = zstring.split(v,",")
		if table.getn(influenceType) >= 2 then 
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if _pType+1 > 4 then
				if _pType > 18 and _pType < 24 then
					valueLabelList[i]:setString(string_equiprety_name[_pType+1].._pValue)
				else
					valueLabelList[i]:setString(string_equiprety_name[_pType+1].._pValue.."%")
				end
			else
				if _pType == 0 and tonumber(self.equipmentInstance.refining_value_life) ~= nil and tonumber(self.equipmentInstance.refining_value_life) >= 0 then
					valueLabelList[i]:setString(string_equiprety_name[_pType+1]..tonumber(_pValue) + tonumber(self.equipmentInstance.refining_value_life))
				elseif _pType == 1 and tonumber(self.equipmentInstance.refining_value_attack) ~= nil and tonumber(self.equipmentInstance.refining_value_attack) >=0 then
					valueLabelList[i]:setString(string_equiprety_name[_pType+1]..tonumber(_pValue) + tonumber(self.equipmentInstance.refining_value_attack))
				elseif _pType == 2 and tonumber(self.equipmentInstance.refining_value_physical_defence) ~= nil and tonumber(self.equipmentInstance.refining_value_physical_defence) >= 0 then
					valueLabelList[i]:setString(string_equiprety_name[_pType+1]..tonumber(_pValue) + tonumber(self.equipmentInstance.refining_value_physical_defence))
				elseif _pType == 3 and tonumber(self.equipmentInstance.refining_value_skill_defence) ~= nil and tonumber(self.equipmentInstance.refining_value_skill_defence) >= 0 then
					valueLabelList[i]:setString(string_equiprety_name[_pType+1]..tonumber(_pValue) + tonumber(self.equipmentInstance.refining_value_skill_defence))
				else
					valueLabelList[i]:setString(string_equiprety_name[_pType+1]..tonumber(_pValue))
				end
			end
		end
	end	
	if self.equipmentInstance ~= nil then
		name:setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name))
		equipType:setString(str)
		if verifySupportLanguage(_lua_release_language_en) == true then
			equipLevel:setString(_string_piece_info[6]..self.equipmentInstance.user_equiment_grade)
		else
			equipLevel:setString(self.equipmentInstance.user_equiment_grade .. _string_piece_info[6])
		end
		-- if equipByShip ~= nil then
			-- equipBy:setString(equipByShip .. _string_piece_info[11])
		-- end
		local colortype = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
		name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
		equipType:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	end
	
	-- local picCell = FormationCarHeadCell:createCell(self.equipmentInstance,"2")
	-- picPanel:addChild(picCell)
	picPanel:removeAllChildren(true)
	app.load("client.cells.equip.equip_icon_new_cell")
	local picCell = EquipIconNewCell:createCell()
	picCell:init(picCell.enum_type._SHOW_EQUIPMENT_INFORMATION, self.equipmentInstance,nil,nil,self)
	picPanel:addChild(picCell)
	--> print(self.equipmentInstance.equiment_refine_level,self.equipmentInstance.user_equiment_name,refineLevelPic,refineLevel,"self.equipmentInstance.equiment_refine_level--------------------")
	if tonumber(self.equipmentInstance.equiment_refine_level) > 0 then
		-- refineLevelPic:setVisible(true)
		refineLevel:setString(_string_piece_info[45] .. self.equipmentInstance.equiment_refine_level .. _string_piece_info[46])
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制	
		local equipByShip = nil
		local ship = fundShipWidthId(self.equipmentInstance.ship_id)
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
			ccui.Helper:seekWidgetByName(root, "Label_725_0"):setString(_string_piece_info[5]..ship_name)
		else
			ccui.Helper:seekWidgetByName(root, "Label_725_0"):setString(" ")
		end
	end

	--升星属性
	for i=1,5 do
		local startImage = ccui.Helper:seekWidgetByName(root, "Image_o_"..i)
		if startImage ~= nil then
			startImage:setVisible(false)
			-- if maxStar ~= -1 then 

			-- 	if startIndex == 2 then 
			-- 		if i >= startIndex and i <= currentStar + 1 then 
			-- 			startImage:setVisible(true)
			-- 		end
			-- 	else
			-- 		if i <= currentStar then 
			-- 			startImage:setVisible(true)
			-- 		end
			-- 	end
			-- end
		end
	end
end

function EquipListCell:onEnterTransitionFinish()

end

function EquipListCell:onInit()
 --    local csbEquipListCell = csb.createNode("list/list_equipment_1.csb")
	-- self:addChild(csbEquipListCell)
	-- local root = csbEquipListCell:getChildByName("root")
	-- table.insert(self.roots, root)

	local root = cacher.createUIRef("list/list_equipment_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	local expansion_pad = ccui.Helper:seekWidgetByName(root, "Panel_xiala")
 	if expansion_pad._pos == nil then
 		expansion_pad._pos = cc.p(expansion_pad:getPosition())
 	else
 		expansion_pad:removeAllChildren(true)
 		expansion_pad:setPosition(expansion_pad._pos)
 	end

 	local expansion_pad_parent = expansion_pad:getParent()
 	if expansion_pad_parent._pos == nil then
 		expansion_pad_parent._pos = cc.p(expansion_pad_parent:getPosition())
 	else
 		expansion_pad_parent:setPosition(expansion_pad_parent._pos)
 	end
	
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else 
		local action = csb.createTimeline("list/list_equipment_1.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
    end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		ccui.Helper:seekWidgetByName(root, "Button_xia"):setSwallowTouches(false)
		ccui.Helper:seekWidgetByName(root, "Button_shou"):setSwallowTouches(false)
	end
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_generals_equipment")
	local MySize = PanelGeneralsEquipment:getContentSize()
	-- self:setContentSize(MySize)
	if EquipListCell.__size == nil then
		EquipListCell.__size = MySize
		-- self:setContentSize(panelSize)
	end
	

	
	-- local expandButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xia"), nil, {func_string = [[state_machine.excute("equip_list_expand_page", 0, "click equip_list_expand_page.'")]]}, nil, 0)
	-- local recoverButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shou"), nil, {func_string = [[state_machine.excute("equip_list_recover_page", 0, "click equip_list_recover_page.'")]]}, nil, 0)

	--扩展界面展开                                                                                     
	local expandButton = ccui.Helper:seekWidgetByName(root, "Panel_but_xy")
	expandButton:setSwallowTouches(false)
	
		local function headLayerTouchEvent(sender, evenType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
			if ccui.TouchEventType.began == evenType then
				
			elseif evenType == ccui.TouchEventType.moved then
				
			elseif ccui.TouchEventType.ended == evenType or
				ccui.TouchEventType.canceled == evenType then
				if math.abs( __epoint.y - __spoint.y) < 8 then
					if fwin:find("EquipInformationClass") == nil then
						state_machine.excute("equip_expansion_action_start", 0, {_datas = {cell = self}})
					end
				end
			end
		end
	expandButton:addTouchEventListener(headLayerTouchEvent)
	
	--扩展界面回收                                                                               
	local recoverButton = ccui.Helper:seekWidgetByName(root, "Button_shou")
	fwin:addTouchEventListener(recoverButton, nil, 
	{
		terminal_name = "equip_expansion_action_start", 
		next_terminal_name = "general", 
		but_image = "Image_home", 	
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	local recoverButtonTwo = ccui.Helper:seekWidgetByName(root, "Button_xia")
	fwin:addTouchEventListener(recoverButtonTwo, nil, 
	{
		terminal_name = "equip_expansion_action_start", 
		next_terminal_name = "general", 
		but_image = "Image_home", 	
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_list_1"), nil, 
		{
			terminal_name = "equip_icon_cell_change_equip_storage_new", 
			_equip = self.equipmentInstance,
			_cell = self
		}, 
		nil, 0)
	end
	
	self:onUpdateDraw()
end

function EquipListCell:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
        or __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
        or __lua_project_id == __lua_project_warship_girl_b 
        then
		local picPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_props")
		picPanel:removeAllChildren(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_list_1"), nil, 
		"", 
		nil, 0)
		
		if ccui.Helper:seekWidgetByName(root, "Label_725_0") ~=nil then
			ccui.Helper:seekWidgetByName(root, "Label_725_0"):setString(" ")
		end
	end
end

function EquipListCell:onExit()
	-- state_machine.remove("equip_list_update_page")
	-- state_machine.remove("equip_list_recover_page")
	local root = self.roots[1]
	if root ~= nil then
		cacher.freeRef("list/list_equipment_1.csb", self.roots[1])
	end
end

function EquipListCell:init(equipmentInstance, index)
	self.equipmentInstance = equipmentInstance

	if index ~= nil and index < 7 then
		self:onInit()
	end

	self:setContentSize(EquipListCell.__size)
	return self
end

function EquipListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EquipListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local picPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
	if picPanel ~= nil then
		picPanel:removeAllChildren(true)
	end
	cacher.freeRef("list/list_equipment_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function EquipListCell:createCell()
	local cell = EquipListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end