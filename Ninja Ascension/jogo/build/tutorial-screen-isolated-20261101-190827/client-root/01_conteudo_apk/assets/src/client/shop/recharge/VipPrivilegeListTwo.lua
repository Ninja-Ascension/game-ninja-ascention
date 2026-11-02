-- ----------------------------------------------------------------------------------------------------
-- 说明：VIP权限list
-- 创建时间2015-05-05
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
VipPrivilegeListTwo = class("VipPrivilegeListTwoClass", Window)

function VipPrivilegeListTwo:ctor()
    self.super:ctor()
    self.roots = {}
    self.textNum = nil
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	local function init_vip_privilege_list_two_terminal()
		-- 点击跳转
		local vip_privilege_list_two_terminal = {
            _name = "vip_privilege_list_two",
            _init = function (terminal) 
                 app.load("client.shop.Shop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("vip_privilege_return_recharge",0,"")
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop",		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					local rechargeDialog = fwin:find("RechargeDialogClass")
					if rechargeDialog ~= nil and rechargeDialog.roots ~= nil then
						rechargeDialog:setVisible(false)
					end
				end
				state_machine.excute("shop_manager", 0, 
					{
						_datas = {
							terminal_name = "shop_manager", 	
							next_terminal_name = "shop_vip_buy",
							current_button_name = "Button_packs", 	
							but_image = "recruit", 		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(vip_privilege_list_two_terminal)
		state_machine.init()
	end
	init_vip_privilege_list_two_terminal()
end

function VipPrivilegeListTwo:onUpdateDraw()
	local root = self.roots[1]
	local vipGrade = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_11")
	vipGrade:setString(_string_piece_info[228]..self.textNum)
	ccui.Helper:seekWidgetByName(root, "Panel_814"):setVisible(true)	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		local Text_324_0 = ccui.Helper:seekWidgetByName(root, "Text_324_0")--折后价
		local Text_324_0_0 = ccui.Helper:seekWidgetByName(root, "Text_324_0_0")--原价	
		local _sale_price = _ED.return_vip_prop[self.textNum+1].sale_price
		local _original_cost = _ED.return_vip_prop[self.textNum+1].original_cost
		Text_324_0:setString(_sale_price)--折后价
		Text_324_0_0:setString(_original_cost)--原价
	end
	local panel = {
		ccui.Helper:seekWidgetByName(root, "Panel_31"),
		ccui.Helper:seekWidgetByName(root, "Panel_32"),
		ccui.Helper:seekWidgetByName(root, "Panel_33"),
		ccui.Helper:seekWidgetByName(root, "Panel_34"),
		ccui.Helper:seekWidgetByName(root, "Panel_35"),
	}
	local panelName = {
		ccui.Helper:seekWidgetByName(root, "Text_331"),
		ccui.Helper:seekWidgetByName(root, "Text_332"),
		ccui.Helper:seekWidgetByName(root, "Text_333"),
		ccui.Helper:seekWidgetByName(root, "Text_334"),
		ccui.Helper:seekWidgetByName(root, "Text_335"),
	}
	local number = 1
	local propId =  dms.int(dms["base_consume"], "48", tostring(self.textNum+4))
	local sliverCount = dms.int(dms["prop_mould"], propId, prop_mould.use_of_silver)   --(银币)金币
	
	local change_of_prop = dms.int(dms["prop_mould"], propId, prop_mould.change_of_prop) --道具1
	local number_one = dms.int(dms["prop_mould"], propId, prop_mould.split_or_merge_count)
	
	local use_of_prop = dms.int(dms["prop_mould"], propId, prop_mould.use_of_prop) --道具2
	local number_two = dms.int(dms["prop_mould"], propId, prop_mould.use_of_prop_count)
	
	local use_of_prop2 = dms.int(dms["prop_mould"], propId, prop_mould.use_of_prop2) --道具3
	local number_three = dms.int(dms["prop_mould"], propId, prop_mould.use_of_prop2_count)
	
	local use_of_prop3 = dms.int(dms["prop_mould"], propId, prop_mould.use_of_prop3) --道具4
	local number_four = dms.int(dms["prop_mould"], propId, prop_mould.use_of_prop3_count)
	
	local change_of_equipment = dms.int(dms["prop_mould"], propId, prop_mould.change_of_equipment) --装备1
	local number_five = dms.int(dms["prop_mould"], propId, prop_mould.change_of_equipment_count)
	
	local change_of_equipment2 = dms.int(dms["prop_mould"], propId, prop_mould.change_of_equipment2) --装备2
	local number_six = dms.int(dms["prop_mould"], propId, prop_mould.change_of_equipment2_count)
	
	local change_of_equipment3 = dms.int(dms["prop_mould"], propId, prop_mould.change_of_equipment3) --装备3
	local number_seven = dms.int(dms["prop_mould"], propId, prop_mould.change_of_equipment3_count)
	
	if change_of_equipment > 0 then
		if number <= 5 then
			local cell = EquipIconCell:createCell()
			cell:init(12,nil,change_of_equipment,nil,false,number_five)
			panel[number]:addChild(cell)
			local name = dms.string(dms["equipment_mould"], change_of_equipment, equipment_mould.equipment_name)
			local quality = dms.int(dms["equipment_mould"], change_of_equipment, equipment_mould.grow_level) + 1
			panelName[number]:setString(name)
			panelName[number]:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
		number = number + 1
	end
	
	if change_of_equipment2 > 0 then
		if number <= 5 then
			local cell = EquipIconCell:createCell()
			cell:init(12,nil,change_of_equipment2,nil,false,number_six)
			panel[number]:addChild(cell)
			local name = dms.string(dms["equipment_mould"], change_of_equipment2, equipment_mould.equipment_name)
			local quality = dms.int(dms["equipment_mould"], change_of_equipment2, equipment_mould.grow_level) + 1
			panelName[number]:setString(name)
			panelName[number]:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
		number = number + 1
	end
	
	if change_of_equipment3 > 0 then
		if number <= 5 then
			local cell = EquipIconCell:createCell()
			cell:init(12,nil,change_of_equipment3,nil,false,number_seven)
			panel[number]:addChild(cell)
			local name = dms.string(dms["equipment_mould"], change_of_equipment3, equipment_mould.equipment_name)
			local quality = dms.int(dms["equipment_mould"], change_of_equipment3, equipment_mould.grow_level) + 1
			panelName[number]:setString(name)
			panelName[number]:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
		number = number + 1
	end
	
	if change_of_prop > 0 then
		if number <= 5 then
			local cell = PropIconCell:createCell()
			cell:init(28,change_of_prop,number_one)
			panel[number]:addChild(cell)
			local name = dms.string(dms["prop_mould"], change_of_prop, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        name = setThePropsIcon(change_of_prop)[2]
		    end
			local quality = dms.int(dms["prop_mould"], change_of_prop, prop_mould.prop_quality) + 1
			panelName[number]:setString(name)
			panelName[number]:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
		number = number + 1
	end
	
	if use_of_prop > 0 then
		if number <= 5 then
			local cell = PropIconCell:createCell()
			cell:init(28,use_of_prop,number_two)
			panel[number]:addChild(cell)
			local name = dms.string(dms["prop_mould"], use_of_prop, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        name = setThePropsIcon(use_of_prop)[2]
		    end
			local quality = dms.int(dms["prop_mould"], use_of_prop, prop_mould.prop_quality) + 1
			panelName[number]:setString(name)
			panelName[number]:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
		number = number + 1
	end
	
	if use_of_prop2 > 0 then
		if number <= 5 then
			local cell = PropIconCell:createCell()
			cell:init(28,use_of_prop2,number_three)
			panel[number]:addChild(cell)
			local name = dms.string(dms["prop_mould"], use_of_prop2, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        name = setThePropsIcon(use_of_prop2)[2]
		    end
			local quality = dms.int(dms["prop_mould"], use_of_prop2, prop_mould.prop_quality) + 1
			panelName[number]:setString(name)
			panelName[number]:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
		number = number + 1
	end
	
	if use_of_prop3 > 0 then
		if number <= 5 then
			local cell = PropIconCell:createCell()
			cell:init(28,use_of_prop3,number_four)
			panel[number]:addChild(cell)
			local name = dms.string(dms["prop_mould"], use_of_prop3, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        name = setThePropsIcon(use_of_prop3)[2]
		    end
			local quality = dms.int(dms["prop_mould"], use_of_prop3, prop_mould.prop_quality) + 1
			panelName[number]:setString(name)
			panelName[number]:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
		number = number + 1
	end
	
	if sliverCount > 0 then
		if number <= 5 then
			local cell = propMoneyIcon:createCell()
			cell:init("1",sliverCount)
			panel[number]:addChild(cell)
			local name = _All_tip_string_info._fundName
			local quality = 1
			panelName[number]:setString(name)
			panelName[number]:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
		number = number + 1
	end
end

function VipPrivilegeListTwo:onEnterTransitionFinish()
	local csbVipPrivilegeListTwo = csb.createNode("player/vip_privileges_list_2.csb")
    self:addChild(csbVipPrivilegeListTwo)
	
	local root = csbVipPrivilegeListTwo:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_103"):getContentSize())
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		ccui.Helper:seekWidgetByName(root, "Panel_814"):setTouchEnabled(false)
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_814"), nil, {func_string = [[state_machine.excute("vip_privilege_list_two", 0, "click vip_privilege_list_two.'")]]}, nil, 0)
	
	self:onUpdateDraw()
end

function VipPrivilegeListTwo:onExit()
	state_machine.remove("vip_privilege_list_two")
end

function VipPrivilegeListTwo:init(textNum)
	self.textNum = textNum
end

function VipPrivilegeListTwo:createCell()
	local cell = VipPrivilegeListTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end