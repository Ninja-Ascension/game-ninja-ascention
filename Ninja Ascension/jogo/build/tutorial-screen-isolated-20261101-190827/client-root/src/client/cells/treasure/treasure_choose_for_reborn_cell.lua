----------------------------------------------------------------------------------------------------
-- 说明：宝物选择信息列(重生)
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TreasureChooseForRebornCell = class("TreasureChooseForRebornCellClass", Window)
 
function TreasureChooseForRebornCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.treasureInstance = nil	
	
    local function init_treasure_choose_list_cell_terminal()
		local treasure_choose_for_reborn_terminal = {
			_name = "treasure_choose_for_reborn",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("treasure_reborn_show_treasure_info", 0, {_datas = {cell = params._datas.cell}})
				state_machine.excute("treasure_choose_reborn_close", 0, "treasure_choose_reborn_close.")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(treasure_choose_for_reborn_terminal)
        state_machine.init()
    end
	
    init_treasure_choose_list_cell_terminal()
end


function TreasureChooseForRebornCell:onEnterTransitionFinish()
    local csbTreasureChooseForRebornCell = csb.createNode("refinery/refinery_gen_cs_list.csb")
	local root = csbTreasureChooseForRebornCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	local Panel_generals_cs = ccui.Helper:seekWidgetByName(root, "Panel_generals_cs")
	local MySize = Panel_generals_cs:getContentSize()
	self:setContentSize(MySize)
	
	app.load("client.cells.treasure.treasure_icon_new_cell")
	local treasure_mould = self.treasureInstance.user_equiment_template
	local treasure_data = dms.element(dms["equipment_mould"], treasure_mould)
	local treasure_type = dms.atoi(treasure_data, equipment_mould.equipment_type)
	local treasure_color = dms.atoi(treasure_data, equipment_mould.grow_level)
	local treasure_level = self.treasureInstance.user_equiment_grade
	
	-- 图标
	local treasure_icon = TreasureIconNewCell:createCell()
	treasure_icon:init(self.treasureInstance,2,true)
	ccui.Helper:seekWidgetByName(root, "Panel_props"):addChild(treasure_icon)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_bg_1"), nil, 
		{
			terminal_name = "treasure_icon_new_cell_show_treasure_info", 
			terminal_state = 0, 
			_equip = self.treasureInstance
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
	name_text:setString(self.treasureInstance.user_equiment_name)
	name_text:setColor(cc.c3b(color_Type[treasure_color+1][1],color_Type[treasure_color+1][2],color_Type[treasure_color+1][3]))
	
	-- 类型
	local type_text = ccui.Helper:seekWidgetByName(root, "Label_shuxin")
	type_text:setColor(cc.c3b(color_Type[treasure_color+1][1],color_Type[treasure_color+1][2],color_Type[treasure_color+1][3]))
	-- if treasure_type == 4 then
		-- type_text:setString(game_infomation_tip_str[7].._property[2]..game_infomation_tip_str[8])
	-- elseif treasure_type == 5 then
		-- type_text:setString(game_infomation_tip_str[7].._string_piece_info[96]..game_infomation_tip_str[8])
	-- end
	
	-- 创建宝物的基础属性Liat
	local valueLabel1 = ccui.Helper:seekWidgetByName(root, "Label_property_1")
	local valueLabel2 = ccui.Helper:seekWidgetByName(root, "Label_property_3")
	local valueLabelList = { valueLabel1, valueLabel2 }
	
	
	ccui.Helper:seekWidgetByName(root, "Label_property_3_0"):setString(_string_piece_info[45] .. self.treasureInstance.equiment_refine_level.._string_piece_info[46])
	
	-- 显示属性
	local baseValue = dms.string(dms["equipment_mould"], self.treasureInstance.user_equiment_template, equipment_mould.initial_value)
	local valueList = zstring.split(baseValue, "|")
	local addValueTable = zstring.split(self.treasureInstance.growup_value, "|")
	
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
				finalValue = finalValue + math.floor(addAttributeList[2] * self.treasureInstance.user_equiment_grade)
			end
		end
		
		--显示数据
		valueLabelList[i]:setString(string_equiprety_name[typeIndex] .. finalValue .. addPercent)
		--self:setTextOutline(valueLabelList[i])
		if (i == 2) then break end
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Wear"), nil, 
	{
		terminal_name = "treasure_choose_for_reborn", 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function TreasureChooseForRebornCell:onExit()

end

function TreasureChooseForRebornCell:init(treasureInstance)
	self.treasureInstance = treasureInstance
end

function TreasureChooseForRebornCell:createCell()
	local cell = TreasureChooseForRebornCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end