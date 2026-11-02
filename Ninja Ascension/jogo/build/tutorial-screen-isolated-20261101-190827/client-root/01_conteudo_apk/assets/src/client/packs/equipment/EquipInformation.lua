-- ----------------------------------------------------------------------------------------------------
-- 说明：装备信息界面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipInformation = class("EquipInformationClass", Window)
   
function EquipInformation:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self.cell = nil
	app.load("client.cells.equip.equip_info_suit_list_cell")					--装备信息列
	app.load("client.cells.equip.equip_info_strengthen_list_cell")			--装备信息列
	app.load("client.cells.equip.equip_info_refine_list_cell")				--装备信息列
	app.load("client.cells.equip.equip_info_describe_list_cell")				--装备信息列

    -- Initialize Home page state machine.
    local function init_equip_information_terminal()
		local equip_information_to_strengthen_terminal = {
            _name = "equip_information_to_strengthen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_information_to_refine_terminal = {
            _name = "equip_information_to_refine",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(EquipSellChooseByQuality:new(), fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_information_to_close_terminal = {
            _name = "equip_information_to_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--装备列表切换刷新
		local equip_information_change_equip_update_terminal = {
            _name = "equip_information_change_equip_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:updataDraw()		
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_information_to_strengthen_terminal)
		state_machine.add(equip_information_to_refine_terminal)
		state_machine.add(equip_information_to_close_terminal)
		state_machine.add(equip_information_change_equip_update_terminal)
        state_machine.init()
    end
    
    init_equip_information_terminal()
end

--红装光效显示设置
function EquipInformation:setRedVisible(isshow)
	local hong = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	if nil ~= hong then
		hong:setVisible(isshow)
	end
end

function EquipInformation:updataDraw()
	local root = self.roots[1]
	local AllIcon = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.All_icon)
	local equipType = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type)
	--> print()
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	Panel_3:setBackGroundImage("images/ui/quality/zb_leixing_"..equipType..".png")
	
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	local Text_23 =ccui.Helper:seekWidgetByName(root, "Text_23") 
	local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
	
	if ___is_open_leadname == true then
		Text_23:setFontName("")
		Text_23:setFontSize(Text_23:getFontSize())
	end
	Text_23:setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.trace_remarks))
	Panel_4:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", AllIcon))	
	Text_2:setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.rank_level))
	Text_3:setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name))
	local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level) + 1
	Text_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	Text_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	Text_3:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	
	
	local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
	Panel_5:setBackGroundImage("images/ui/quality/zb_grow_"..(tonumber(quality) - 1)..".png")
	
	local lv =ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lv")
	local lan=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lan")
	local zi=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_zi")
	local cheng=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_cheng")

	lv:setVisible(false)
	lan:setVisible(false)
	zi:setVisible(false)
	cheng:setVisible(false)
	self:setRedVisible(false)		
	if quality == 2 then
		lv:setVisible(true)
	elseif quality == 3 then
		lan:setVisible(true)
	elseif quality == 4 then
		zi:setVisible(true)
	elseif quality == 5 then
		cheng:setVisible(true)
	elseif quality == 6 then
		self:setRedVisible(true)			
	end

	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:removeAllItems()
	for i = 1, 6 do
		if i == 1 then
			local cell = EquipInfoStrengthenListCell:createCell()
			cell:init(self.equipmentInstance,self.cell)
			listView:addChild(cell)
		elseif i == 2 then
			local cell = EquipInfoRefineListCell:createCell()
			cell:init(self.equipmentInstance,self.cell)
			listView:addChild(cell)
		elseif i == 3 then 
			local maxStar = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.star_level)
			if maxStar ~= -1 then 
				app.load("client.cells.equip.equip_star_info_cell")				--升星
				local cell = EquipStarInfoCell:createCell()
				cell:init(self.equipmentInstance,"upStar",self.cell)
				listView:addChild(cell)
			end
		elseif i == 4 then 
			local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)

			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				or __lua_project_id == __lua_project_gragon_tiger_gate
				-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_yugioh
				then
				if quality == 5 then
					if equipType <= 3 then 
						app.load("client.cells.equip.equip_red_info_cell")				--红装信息
						local cell = EquipRedInfoCell:createCell()
						cell:init(self.equipmentInstance)
						listView:addChild(cell)
					else
						app.load("client.cells.treasure.treasure_red_info_cell")				--红宝信息
						local cell = TreasureRedInfoCell:createCell()
						cell:init(self.equipmentInstance)
						listView:addChild(cell)
					end
				end
			end
		elseif i == 5 then
			local suitId = dms.int(dms["equipment_mould"],self.equipmentInstance.user_equiment_template,equipment_mould.suit_id)
			if suitId > 0 then
				local cell = EquipInfoSuitListCell:createCell()
				cell:init(self.equipmentInstance)
				listView:addChild(cell)
			end
		elseif i == 6 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then			--龙虎门项目控制
			else
				local cell = EquipInfoDescribeListCell:createCell()
				cell:init(self.equipmentInstance)
				listView:addChild(cell)
			end
		end
	end
end
function EquipInformation:onEnterTransitionFinish()
    local csbEquipInformation = csb.createNode("packs/EquipStorage/equipment_information.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local action = csb.createTimeline("packs/EquipStorage/equipment_information.csb") 
		csbEquipInformation:runAction(action)
		action:play("tubiao_ing", true)
	end
	-- Panel_3  武器
	-- Button_1  关闭
	-- Panel_4   图片
	-- Panel_5   装备类型(紫装)
	-- Text_2	潜力值
	-- Text_3   名字
	-- ListView_1 滑动层
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--移到update去
		self:updataDraw()
	else
		local AllIcon = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.All_icon)
		local equipType = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type)

		ccui.Helper:seekWidgetByName(root, "Panel_3"):setBackGroundImage("images/ui/quality/zb_leixing_"..equipType..".png")

		ccui.Helper:seekWidgetByName(root, "Panel_4"):setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", AllIcon))
		ccui.Helper:seekWidgetByName(root, "Text_2"):setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.rank_level))
		ccui.Helper:seekWidgetByName(root, "Text_3"):setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name))
		local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level) + 1
		ccui.Helper:seekWidgetByName(root, "Text_2"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		ccui.Helper:seekWidgetByName(root, "Text_1"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		ccui.Helper:seekWidgetByName(root, "Text_3"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
		
		ccui.Helper:seekWidgetByName(root, "Panel_5"):setBackGroundImage("images/ui/quality/zb_grow_"..(tonumber(quality) - 1)..".png")
		
		for i = 1, 6 do
			if i == 1 then
				local cell = EquipInfoStrengthenListCell:createCell()
				cell:init(self.equipmentInstance,self.cell)
				listView:addChild(cell)
			elseif i == 2 then
				local cell = EquipInfoRefineListCell:createCell()
				cell:init(self.equipmentInstance,self.cell)
				listView:addChild(cell)
			elseif i == 3 then 
				local maxStar = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.star_level)
				if maxStar ~= -1 then 
					app.load("client.cells.equip.equip_star_info_cell")				--升星
					local cell = EquipStarInfoCell:createCell()
					cell:init(self.equipmentInstance,"upStar",self.cell)
					listView:addChild(cell)
				end
			elseif i == 4 then 
				local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_yugioh
					then 
					if quality == 5 then
						if equipType <= 3 then 
							app.load("client.cells.equip.equip_red_info_cell")				--红装信息
							local cell = EquipRedInfoCell:createCell()
							cell:init(self.equipmentInstance)
							listView:addChild(cell)
						else
							app.load("client.cells.treasure.treasure_red_info_cell")				--红宝信息
							local cell = TreasureRedInfoCell:createCell()
							cell:init(self.equipmentInstance)
							listView:addChild(cell)
						end
					end
				end
		
			elseif i == 5 then
				local suitId = dms.int(dms["equipment_mould"],self.equipmentInstance.user_equiment_template,equipment_mould.suit_id)
				if suitId > 0 then
					local cell = EquipInfoSuitListCell:createCell()
					cell:init(self.equipmentInstance)
					listView:addChild(cell)
				end
			elseif i == 6 then
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
				else
					local cell = EquipInfoDescribeListCell:createCell()
					cell:init(self.equipmentInstance)
					listView:addChild(cell)
				end
			end
		end
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		func_string = [[state_machine.excute("equip_information_to_close", 0, "click equip_information_to_close.'")]],
		isPressedActionEnabled = true
	}, nil, 2)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zb_xx_qh"), nil, 
		{
			terminal_name = "equip_info_strengthen_list", 
			terminal_state = 0, 
			_equip = self.equipmentInstance,
			_cell = self.cell, 
			isPressedActionEnabled = true
		}, nil, 2)
	
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zb_xx_jl"), nil, 
			{
				terminal_name = "equip_info_to_refine_lists_cell_from_fromation", 
				terminal_state = 0, 
				_equip = self.equipmentInstance, 
				_cell = self.cell,
				isPressedActionEnabled = true
			}, nil, 2)

		if equipType == 8 then --经验心法不能强化和精炼 屏蔽按钮
			local qianghuabut = ccui.Helper:seekWidgetByName(root, "Button_zb_xx_qh")
			local jianglianbut = ccui.Helper:seekWidgetByName(root, "Button_zb_xx_jl")
			qianghuabut:setTouchEnabled(false)
			qianghuabut:setBright(false)
			jianglianbut:setTouchEnabled(false)
			jianglianbut:setBright(false)
		end
	end
end


function EquipInformation:onExit()
	state_machine.remove("equip_information_to_strengthen")
	state_machine.remove("equip_information_to_refine")
	state_machine.remove("equip_information_to_close")
	state_machine.remove("equip_information_change_equip_update")

end

function EquipInformation:init(equipmentInstance,_cell)
	self.equipmentInstance = equipmentInstance
	self.cell = _cell
end
