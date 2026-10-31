----------------------------------------------------------------------------------------------------
-- 说明：装备选择信息列(重生)
-------------------------------------------------------------------------------------------------------
EquipChooseForRebornCell = class("EquipChooseForRebornCellClass", Window)

EquipChooseForRebornCell.__size = nil

function EquipChooseForRebornCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipInstance = nil	
	
    local function init_equip_choose_list_cell_terminal()
		local equip_choose_for_reborn_terminal = {
			_name = "equip_choose_for_reborn",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("equip_reborn_show_equip_info", 0, {_datas = {cell = params._datas.cell}})
				state_machine.excute("equip_choose_reborn_close", 0, "equip_choose_reborn_close.")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(equip_choose_for_reborn_terminal)
        state_machine.init()
    end
	
    init_equip_choose_list_cell_terminal()
end


function EquipChooseForRebornCell:onEnterTransitionFinish()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
	else
		self:onInit()
	end
end

function EquipChooseForRebornCell:onExit()

end

function EquipChooseForRebornCell:onInit( ... )
	local csbEquipChooseForRebornCell = csb.createNode("refinery/refinery_zhuangbei_cs_list.csb")
	local root = csbEquipChooseForRebornCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	local Panel_tre_cs = ccui.Helper:seekWidgetByName(root, "Panel_tre_cs")
	local MySize = Panel_tre_cs:getContentSize()
	self:setContentSize(MySize)

	if EquipChooseForRebornCell.__size == nil then
	 	EquipChooseForRebornCell.__size = MySize
	end
	
	app.load("client.cells.equip.equip_icon_new_cell")
	local treasure_mould = self.equipInstance.user_equiment_template
	local treasure_data = dms.element(dms["equipment_mould"], treasure_mould)
	local treasure_type = dms.atoi(treasure_data, equipment_mould.equipment_type)
	local treasure_color = dms.atoi(treasure_data, equipment_mould.grow_level)
	local treasure_level = self.equipInstance.user_equiment_grade
	
	-- 图标
	local treasure_icon = EquipIconNewCell:createCell()
	treasure_icon:init(9,self.equipInstance)
	ccui.Helper:seekWidgetByName(root, "Panel_props"):addChild(treasure_icon)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_bg_1"), nil, 
		{
			terminal_name = "treasure_icon_new_cell_show_treasure_info", 
			terminal_state = 0, 
			_equip = self.equipInstance
		}, 
		nil, 0)
	end
	
	-- 等级
	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(root, "Text_2"):setString(_string_piece_info[6]..treasure_level)
	else
		ccui.Helper:seekWidgetByName(root, "Text_2"):setString(treasure_level.._string_piece_info[6])
	end
	
	-- 名称
	local name_text = ccui.Helper:seekWidgetByName(root, "Label_717_0")
	name_text:setString(self.equipInstance.user_equiment_name)
	name_text:setColor(cc.c3b(color_Type[treasure_color+1][1],color_Type[treasure_color+1][2],color_Type[treasure_color+1][3]))
	
	-- 类型
	local type_text = ccui.Helper:seekWidgetByName(root, "Label_shuxin")
	type_text:setColor(cc.c3b(color_Type[treasure_color+1][1],color_Type[treasure_color+1][2],color_Type[treasure_color+1][3]))

	-- 创建宝物的基础属性Liat
	local valueLabel1 = ccui.Helper:seekWidgetByName(root, "Label_property_1")
	local valueLabel2 = ccui.Helper:seekWidgetByName(root, "Label_property_3")
	local valueLabelList = { valueLabel1, valueLabel2 }
	
	
	--ccui.Helper:seekWidgetByName(root, "Label_property_3_0"):setString(_string_piece_info[45] .. self.equipInstance.equiment_refine_level.._string_piece_info[46])
	
	-- 显示属性
	local baseValue = dms.string(dms["equipment_mould"], self.equipInstance.user_equiment_template, equipment_mould.initial_value)
	local valueList = zstring.split(baseValue, "|")
	local addValueTable = zstring.split(self.equipInstance.growup_value, "|")
	
	for i, v in pairs(valueList) do
		local attributeList = zstring.split(valueList[i], ",")
		local typeIndex = tonumber(attributeList[1]) + 1
		
		--判断是否追加百分比符号---------------------------------------------------------------------------
		local addPercent = ""
		if typeIndex >= 5 and typeIndex <= 18 then
			addPercent = "%"
		elseif typeIndex >= 34 and typeIndex <= 35 then
			addPercent = "%"
		end
		
		--判断附加属性的type
		local finalValue = math.floor(attributeList[2])
		for c, t in pairs(addValueTable) do
			local addAttributeList = zstring.split(t, ",")
			if addAttributeList[1] + 1 == typeIndex then
				finalValue = finalValue + math.floor(addAttributeList[2] * self.equipInstance.user_equiment_grade)
			end
		end
		
		--显示数据
		valueLabelList[i]:setString(string_equiprety_name[typeIndex] .. finalValue .. addPercent)
		--self:setTextOutline(valueLabelList[i])
		if (i == 2) then break end
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Wear"), nil, 
	{
		terminal_name = "equip_choose_for_reborn", 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function EquipChooseForRebornCell:init(equipInstance)
	self.equipInstance = equipInstance
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		self:onInit()
	end
end

function EquipChooseForRebornCell:createCell()
	local cell = EquipChooseForRebornCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end