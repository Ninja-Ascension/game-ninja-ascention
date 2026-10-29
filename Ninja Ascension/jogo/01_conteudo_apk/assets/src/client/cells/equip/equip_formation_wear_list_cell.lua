----------------------------------------------------------------------------------------------------
-- 说明：装备穿戴列表控件
-------------------------------------------------------------------------------------------------------
EquipFormationWearListCell = class("EquipFormationWearListCellClass", Window)
EquipFormationWearListCell.__size = nil
   
function EquipFormationWearListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equip = nil
	self.ship = nil
	app.load("client.cells.equip.equip_icon_new_cell")
    local function init_equip_formation_wear_list_cell_terminal()
		
		--穿戴当前武将身上的装备
		local wear_formation_current_ship_equip_terminal = {
            _name = "wear_formation_current_ship_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--穿戴当前武将身上的装备响应逻辑
            	state_machine.excute("request_wear_formation_equip", 0, params._datas._data)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(wear_formation_current_ship_equip_terminal)
        state_machine.init()
    end
    
    init_equip_formation_wear_list_cell_terminal()
end

function EquipFormationWearListCell:createEquipHead(equip,objectType)
	local cell = EquipIconNewCell:createCell()
	cell:init(equip,objectType)
	return cell
end

function EquipFormationWearListCell:onUpdateDraw()
	local root = self.roots[1]
	local picPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
	local picIndex = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.pic_index)
	local quality = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.grow_level) + 1
	-- 装备小头像
	local picCell = EquipFormationWearListCell:createEquipHead(8,self.equip)
	picPanel:removeAllChildren(true)
	picPanel:addChild(picCell)
	--装备名称
	local equipName = ccui.Helper:seekWidgetByName(root, "Label_717_0")
	equipName:setString(dms.string(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_name))
	equipName:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	-- 装备类型
	local equipType = ccui.Helper:seekWidgetByName(root, "Label_property_4")
	local Mytype = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_type)
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
	equipType:setString("")
	equipType:setString(str)
	equipType:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	--等级
	local equipLevel = ccui.Helper:seekWidgetByName(root, "Text_2")
	if verifySupportLanguage(_lua_release_language_en) == true then
		equipLevel:setString(_string_piece_info[6]..self.equip.user_equiment_grade)
	else
		equipLevel:setString(self.equip.user_equiment_grade.._string_piece_info[6])
	end
	
	--属性值
	local temp = zstring.zsplit(self.equip.user_equiment_ability, "|")
	local labelNodes = {
		"Label_property",
		"Label_property_3",
	}
	ccui.Helper:seekWidgetByName(root, labelNodes[1]):setString("")
	ccui.Helper:seekWidgetByName(root, labelNodes[2]):setString("")
	for i,v in pairs(temp) do
		if i> table.getn(temp) then
			break
		end
		local influenceType = zstring.split(v,",")
		if table.getn(influenceType) >= 2 then 
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if _pType+1 > 4 then
				if _pType > 18 and _pType < 24 then
					ccui.Helper:seekWidgetByName(root, labelNodes[i]):setString(string_equiprety_name[_pType+1].._pValue)
				else
					ccui.Helper:seekWidgetByName(root, labelNodes[i]):setString(string_equiprety_name[_pType+1].._pValue.."%")
				end
			else
				if _pType == 0 and tonumber(self.equip.refining_value_life) ~= nil and tonumber(self.equip.refining_value_life) >= 0 then
					ccui.Helper:seekWidgetByName(root, labelNodes[i]):setString(string_equiprety_name[_pType+1]..tonumber(_pValue) + tonumber(self.equip.refining_value_life))
				elseif _pType == 1 and tonumber(self.equip.refining_value_attack) ~= nil and tonumber(self.equip.refining_value_attack) >=0 then
					ccui.Helper:seekWidgetByName(root, labelNodes[i]):setString(string_equiprety_name[_pType+1]..tonumber(_pValue) + tonumber(self.equip.refining_value_attack))
				elseif _pType == 2 and tonumber(self.equip.refining_value_physical_defence) ~= nil and tonumber(self.equip.refining_value_physical_defence) >= 0 then
					ccui.Helper:seekWidgetByName(root, labelNodes[i]):setString(string_equiprety_name[_pType+1]..tonumber(_pValue) + tonumber(self.equip.refining_value_physical_defence))
				elseif _pType == 3 and tonumber(self.equip.refining_value_skill_defence) ~= nil and tonumber(self.equip.refining_value_skill_defence) >= 0 then
					ccui.Helper:seekWidgetByName(root, labelNodes[i]):setString(string_equiprety_name[_pType+1]..tonumber(_pValue) + tonumber(self.equip.refining_value_skill_defence))
				else
					ccui.Helper:seekWidgetByName(root, labelNodes[i]):setString(string_equiprety_name[_pType+1]..tonumber(_pValue))
				end
			end
		end
	end	

	--是否缘分激活
	local isrelatio = false
	--print("self.ship.ship_base_template_id:", self.ship.ship_base_template_id, self.equip.user_equiment_template)
	local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.relationship_id), ",")
	for k,w in pairs(myRelatioInfo) do
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1) == tonumber(self.equip.user_equiment_template) then
				isrelatio = true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2) == tonumber(self.equip.user_equiment_template) then
				isrelatio = true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3) == tonumber(self.equip.user_equiment_template) then
				isrelatio = true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4) == tonumber(self.equip.user_equiment_template) then
				isrelatio = true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5) == tonumber(self.equip.user_equiment_template) then
				isrelatio = true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6) == tonumber(self.equip.user_equiment_template) then
				isrelatio = true
			end
		end
	end
	
	
	if isrelatio == true then
		ccui.Helper:seekWidgetByName(root, "Text_Activation"):setString(_string_piece_info[47])
	else
		ccui.Helper:seekWidgetByName(root, "Text_Activation"):setString(" ")
	end
	
	--是否精炼
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if tonumber(self.equip.equiment_refine_level) >= 1 then
			ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_string_piece_info[45]..self.equip.equiment_refine_level.._string_piece_info[46])
		else
			ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString("")
		end
	else

		if tonumber(self.equip.equiment_refine_level) > 1 then
			ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_string_piece_info[45]..self.equip.equiment_refine_level.._string_piece_info[46])
		else
			ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString("")
		end
	end
	--装备按钮
	ccui.Helper:seekWidgetByName(root, "Panel_button_2"):setVisible(true)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_bg_1"), nil, 
		{
			terminal_name = "equip_icon_cell_change_equip_storage_new_in_formation", 
			terminal_state = 0, 
			_equip = self.equip, 
			_cell = nil
		}, 
		nil, 0)
	end
end

function EquipFormationWearListCell:onEnterTransitionFinish()
end

function EquipFormationWearListCell:onInit()
 --    local csbEquipListCell = csb.createNode("list/list_equipment_Wear_1.csb")
	-- -- self:addChild(csbEquipListCell)
	-- local root = csbEquipListCell:getChildByName("root")
	-- root:removeFromParent(false)
	-- self:addChild(root)
	-- table.insert(self.roots, root)

	local root = cacher.createUIRef("list/list_equipment_Wear_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("list/list_equipment_Wear_1.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	
	self:onUpdateDraw()
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_generals_equipment")
	if EquipFormationWearListCell.__size == nil then
		local MySize = PanelGeneralsEquipment:getContentSize()
		-- self:setContentSize(MySize)
		EquipFormationWearListCell.__size = MySize
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Wear"), nil, 
	{
		terminal_name = "wear_formation_current_ship_equip", 
		terminal_state = 0, 
		_data = self.ship.ship_id.."|"..self.equip.user_equiment_id,
		isPressedActionEnabled = true
	}, nil, 0)
	
	
end

function EquipFormationWearListCell:close( ... )
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
	end
end

function EquipFormationWearListCell:onExit()
	state_machine.remove("wear_formation_current_ship_equip")
	cacher.freeRef("list/list_equipment_Wear_1.csb", self.roots[1])
end

function EquipFormationWearListCell:init(_equip,_ship, drawIndex)
	self.equip = _equip
	self.ship = _ship	

	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end

	self:setContentSize(EquipFormationWearListCell.__size)
	return self
end


function EquipFormationWearListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EquipFormationWearListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local picPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_props")
	if picPanel ~= nil then
		picPanel:removeAllChildren(true)
	end
	cacher.freeRef("list/list_equipment_Wear_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function EquipFormationWearListCell:createCell()
	local cell = EquipFormationWearListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end