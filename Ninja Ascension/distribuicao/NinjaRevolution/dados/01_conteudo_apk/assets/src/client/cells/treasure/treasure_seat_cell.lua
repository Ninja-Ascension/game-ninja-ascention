---------------------------------
---说明：宝物仓库信息选项卡界面
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureSeatCell = class("TreasureSeatCellClass", Window)
TreasureSeatCell.__size = nil
   
function TreasureSeatCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.treasureInstance = nil
	app.load("client.cells.treasure.treasure_icon_new_cell")
	-- 属性类型定义
	self.influence_type = {
		"生命",--0（固定值）		
		"攻击",--1（固定值）		
		"物防",--2（固定值）		
		"灵防",--3（固定值）		
		"生命",--4 百分比		
		"攻击",--5 百分比		
		"物防",--6 百分比		
		"灵防",--7 百分比		
		"暴击率",--8 百分比		
		"抗暴率",--9 百分比		
		"格挡率",--10 百分比		
		"破击率",--11 百分比		
		"命中率",--12 百分比		
		"闪避率",--13 百分比		
		"物理免伤",--14 百分比		
		"灵压免伤",--15 百分比		
		"治疗率",--16 百分比		
		"被治疗率",--17 百分比		
		"最终伤害",--18（固定值）		
		"最终减伤",--19（固定值）		
		"初始怒气",--20（固定值）		
		"体质",--21（固定值）		
		"力量",--22（固定值）		
		"灵力",--23（固定值）		
		"物理攻击",--24（固定值）		
		"灵压攻击",--25（固定值）		
		"治疗值",--26（固定值）		
		"被治疗值",--27（固定值）		
		"灼烧伤害",--28（固定值）		
		"中毒伤害",--29（固定值）		
		"灼烧免伤",--30（固定值）		
		"中毒免伤",--31（固定值）		
		"经验",--32（固定值）		
		"最终伤害",--33 百分比		
		"最终减伤"--34 百分比
	}
	
	app.load("client.cells.treasure.treasure_icon_cell")
	
    -- Initialize HeroSeat state machine.
    local function init_treasure_seat_terminal()
	
		
    end
    
    -- call func init hom state machine.
    init_treasure_seat_terminal()
end

function TreasureSeatCell:onUpdatePanel()
	
	local root = self.roots[1]
	local currentTreasure = self.treasureInstance
	--> print("TreasureName：", self.treasureInstance.user_equiment_name)
	
	-- 宝物名字
	local textTreasureName = ccui.Helper:seekWidgetByName(root, "Label_717_0")
	textTreasureName:setString(currentTreasure.user_equiment_name)
	
	-- 重新设置宝物的名字颜色
	local quality = dms.int(dms["equipment_mould"], currentTreasure.user_equiment_template, equipment_mould.grow_level) + 1
	self:setTextLabelColor(textTreasureName, quality)
	self:setTextOutline(textTreasureName) --进行文字描边
	
	--加载Icon图片cell
	local iconLayer = ccui.Helper:seekWidgetByName(root, "Panel_props")
	iconLayer:removeAllChildren(true)
	local tic = TreasureIconNewCell.createCell()
	tic:init(self.treasureInstance)
	iconLayer:addChild(tic);
	
	if __lua_project_id ==__lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_list_1"), nil, 
		{
			terminal_name = "treasure_icon_new_cell_show_info", 
			_equip = self.treasureInstance
		}, 
		nil, 0)
	end
	-- 获取宝物等级
	local textLv = ccui.Helper:seekWidgetByName(root, "Text_2")
	if verifySupportLanguage(_lua_release_language_en) == true then
		textLv:setString(_string_piece_info[6]..currentTreasure.user_equiment_grade)
	else
		textLv:setString(currentTreasure.user_equiment_grade .. _string_piece_info[6])
	end
	--self:setTextOutline(textLv)
	
	-- 宝物类型 到底是【攻击】型还是【防御】型
	local treasureType = currentTreasure.equipment_type
	local textTreasureType = ccui.Helper:seekWidgetByName(root, "Label_property_4")
	local typeNameStr -- 类型名称
	
	if tonumber(treasureType) == 4 then
		typeNameStr = tipStringInfo_treasure_seat_str[1]
	elseif tonumber(treasureType) == 5 then
		typeNameStr = tipStringInfo_treasure_seat_str[2]
	end
	textTreasureType:setString(typeNameStr)
	self:setTextOutline(textTreasureType)
	
	-- 设置宝物类型名称的颜色
	self:setTextLabelColor(textTreasureType, quality)
	
	-- 创建宝物的基础属性Liat
	local valueLabel1 = ccui.Helper:seekWidgetByName(root, "Label_property")
	local valueLabel2 = ccui.Helper:seekWidgetByName(root, "Label_property_3")
	local valueLabelList = { valueLabel1, valueLabel2 }
	valueLabel1:setString("")
	valueLabel2:setString("")
	
	-- 显示属性
	local baseValue = dms.string(dms["equipment_mould"], currentTreasure.user_equiment_template, equipment_mould.initial_value)
	local valueList = zstring.split(currentTreasure.user_equiment_ability, "|")
	local addValueTable = zstring.split(currentTreasure.user_equiment_ability, "|")
	
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
		local finalValue = string.format("%.1f",attributeList[2])
		for c, t in pairs(addValueTable) do
			local addAttributeList = zstring.split(t, ",")
			if addAttributeList[1] + 1 == typeIndex then
				finalValue = finalValue
			end
		end
		
		--显示数据
		valueLabelList[i]:setString(_influence_type[typeIndex] .. " + " .. finalValue .. addPercent)
		--self:setTextOutline(valueLabelList[i])
		if (i == 2) then break end
	end
	
	-- 显示装备者
	-- currentTreasure.ship_id = 2819
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if currentTreasure.ship_id ~= 0 then
			local textEquipShipName = ccui.Helper:seekWidgetByName(root, "Label_725_0")
			textEquipShipName:setString(self:getShipName(currentTreasure.ship_id))
		else
			textEquipShipName:setString(" ")
		end
	end	
end

--设置文本描边
function TreasureSeatCell:setTextOutline(text)
	text:enableOutline(cc.c4b(120, 120, 120, 255), 1)
end

--根据装备者shipip获取模板名称
function TreasureSeatCell:getShipName(equipShipID)
	local returnName = ""
	for i, hero in pairs(_ED.user_ship) do
		if tonumber(hero.ship_id) == tonumber(equipShipID) then
			local captain_type = dms.string(dms["ship_mould"], hero.ship_template_id, ship_mould.captain_type)
			local name = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], hero.ship_template_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(hero.evolution_status, "|")
				local evo_mould_id = evo_info[tonumber(ship_evo[1])]
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				name = word_info[3]
			else
				name = dms.string(dms["ship_mould"], hero.ship_template_id, ship_mould.captain_name)
			end
			
			if tonumber(captain_type) == 0 then
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					returnName = " "..tipStringInfo_treasure_seat_str[3].. _ED.user_info.user_name 
				else
					returnName = _ED.user_info.user_name.." "..tipStringInfo_treasure_seat_str[3]  
				end
				if ___is_open_leadname == true then
					local Label_725_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Label_725_0")
					Label_725_0:setFontName("")
					Label_725_0:setFontSize(Label_725_0:getFontSize())
				end
			else
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					returnName = " "..tipStringInfo_treasure_seat_str[3].. name 
				else
					returnName = name.." "..tipStringInfo_treasure_seat_str[3].." " 
				end
			end
		end
	end
	return returnName
end

--设置文本的颜色
function TreasureSeatCell:setTextLabelColor(label, quality)
	label:setColor(cc.c3b(
		tipStringInfo_quality_color_Type[quality][1],
		tipStringInfo_quality_color_Type[quality][2],
		tipStringInfo_quality_color_Type[quality][3]
	))
end

function TreasureSeatCell:onEnterTransitionFinish()

end

function TreasureSeatCell:onInit()
 --    local csbTreasureSeatCell = csb.createNode("list/list_equipment_1.csb")
	-- local root = csbTreasureSeatCell:getChildByName("root")
	-- root:removeFromParent(true)
 --    self:addChild(root)
	-- table.insert(self.roots, root)


	local root = cacher.createUIRef("list/list_equipment_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("list/list_equipment_1.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	
	local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_generals_equipment")
	local panelSize = panel:getContentSize()

	local refineLevel = ccui.Helper:seekWidgetByName(root, "Text_30102")
	refineLevel:setString("")
	
	-- 调用自己的更新函数
	self:onUpdatePanel()
	self:setContentSize(panelSize)
	if TreasureSeatCell.__size == nil then
		TreasureSeatCell.__size = panelSize
	end
	
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

	--帮美术处理 界面中显示123的问题
	local bugText = ccui.Helper:seekWidgetByName(self.roots[1], "Label_property_2")
	bugText:setString("")

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
						state_machine.excute("treasure_expansion_action_start", 0, {_datas = {cell = self}})
					end
				end
			end
		end
	expandButton:addTouchEventListener(headLayerTouchEvent)
	
	--宝物扩展界面展开
	local seat_expansion_on_button = ccui.Helper:seekWidgetByName(root, "Button_xia")
	fwin:addTouchEventListener(seat_expansion_on_button, nil, 
	{
		terminal_name = "treasure_expansion_action_start", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true,
		currentTreasure = self.treasureInstance
	}, 
	nil, 0)
	
	--宝物扩展界面关闭
	local seat_expansion_off_button = ccui.Helper:seekWidgetByName(root, "Button_shou")
	fwin:addTouchEventListener(seat_expansion_off_button, nil, 
	{
		terminal_name = "treasure_expansion_action_start", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	--宝物不能显示升星属性
	for i=1,5 do
		local startImage = ccui.Helper:seekWidgetByName(root, "Image_o_"..i)
		if startImage ~= nil then
			startImage:setVisible(false)
		end
	end
end


function TreasureSeatCell:onExit()
	-- state_machine.remove("treasure_seat_expansion_on")
	-- state_machine.remove("treasure_seat_expansion_off")
	local root = self.roots[1]
	if root ~= nil then
		cacher.freeRef("list/list_equipment_1.csb", self.roots[1])
	end
end


function TreasureSeatCell:init(value, index)
	--> print("TreasureSeatCell:init", value)
	self.treasureInstance = value

	if index ~= nil and index < 7 then
		self:onInit()
	end

	self:setContentSize(TreasureSeatCell.__size)
	return self
end

function TreasureSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TreasureSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_equipment_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function TreasureSeatCell:createCell()
	local cell = TreasureSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end