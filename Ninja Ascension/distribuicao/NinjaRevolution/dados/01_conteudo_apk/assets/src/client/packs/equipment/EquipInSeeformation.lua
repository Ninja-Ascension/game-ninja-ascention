-- ----------------------------------------------------------------------------------------------------
-- 说明：装备信息界面
-------------------------------------------------------------------------------------------------------

EquipInSeeformation = class("EquipInSeeformationClass", Window)
   
function EquipInSeeformation:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self.cell = nil

	fwin:close(fwin:find("EquipInSeeformationClass"))
	
    -- Initialize Home page state machine.
    local function init_see_equip_information_terminal()
		local equip_information_quality_request_terminal = {
            _name = "equip_information_quality_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				state_machine.excute("replacement_or_unload_ship_equip_wear_request", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_information_replacement_request_terminal = {
            _name = "equip_information_replacement_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				for i, equip in pairs(_ED.user_equiment) do
					if equip.user_equiment_id ~= nil then
						if dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.equipment_type) == tonumber(params._datas._equipType) then
							state_machine.excute("open_replacement_ship_equip_window", 0, params._datas._equipType)
							return
						end
					end
				end
				TipDlg.drawTextDailog(tip_online_time[2])
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
		
		state_machine.add(equip_information_replacement_request_terminal)
		state_machine.add(equip_information_to_close_terminal)
		state_machine.add(equip_information_quality_request_terminal)

        state_machine.init()
    end
    
    init_see_equip_information_terminal()
end

--红装光效显示设置
function EquipInSeeformation:setRedVisible(isshow)
	local hong = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	if nil ~= hong then
		hong:setVisible(isshow)
	end
end

function EquipInSeeformation:onUpdateDraw()
	local root = self.roots[1]
	-- Panel_3  武器
	-- Button_1  关闭
	-- Panel_4   图片
	-- Panel_5   装备类型(紫装)
	-- Text_2	潜力值
	-- Text_3   名字
	-- ListView_1 滑动层
	local AllIcon = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.All_icon)
	local equipType = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type)
	ccui.Helper:seekWidgetByName(root, "Panel_3"):setBackGroundImage(string.format("images/ui/quality/zb_leixing_%d.png", equipType))
	ccui.Helper:seekWidgetByName(root, "Panel_4"):setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", AllIcon))
	ccui.Helper:seekWidgetByName(root, "Text_2"):setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.rank_level))
	ccui.Helper:seekWidgetByName(root, "Text_3"):setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name))
	local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level) + 1
	ccui.Helper:seekWidgetByName(root, "Panel_5"):setBackGroundImage(string.format("images/ui/quality/zb_grow_%d.png", quality - 1))
	ccui.Helper:seekWidgetByName(root, "Text_2"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	ccui.Helper:seekWidgetByName(root, "Text_1"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	ccui.Helper:seekWidgetByName(root, "Text_3"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	
	for i = 1, 6 do
		if i == 1 then
			local cell = EquipInfoStrengthenListCell:createCell()
			cell:init(self.equipmentInstance,nil,2)
			listView:addChild(cell)
		elseif i == 2 then
			local cell = EquipInfoRefineListCell:createCell()
			cell:init(self.equipmentInstance,nil,2)
			listView:addChild(cell)
		elseif i == 3 then 
			local maxStar = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.star_level)

			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				or __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
				or __lua_project_id == __lua_project_yugioh
				then
				if maxStar ~= -1 then 
					app.load("client.cells.equip.equip_star_info_cell")				--升星
					local cell = EquipStarInfoCell:createCell()
					cell:init(self.equipmentInstance,"formationUpStar",self.cell)
					listView:addChild(cell)
				end
			end
		elseif i == 4 then 
			local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				or __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
				or __lua_project_id == __lua_project_yugioh
				then 
				if quality == 5 then
					if equipType <= 3 then 
						-- app.load("client.cells.equip.equip_red_info_cell")				--红装信息
						-- local cell = EquipRedInfoCell:createCell()
						-- cell:init(self.equipmentInstance)
						-- listView:addChild(cell)
					else
						-- app.load("client.cells.treasure.treasure_red_info_cell")				--红宝信息
						-- local cell = TreasureRedInfoCell:createCell()
						-- cell:init(self.equipmentInstance)
						-- listView:addChild(cell)
					end
				end
			end
		elseif i == 5 then
			if equipType<=3 then
				local cell = EquipInfoSuitListCell:createCell()
				cell:init(self.equipmentInstance)
				listView:addChild(cell)
			end
		elseif i == 6 then
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
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
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		ccui.Helper:seekWidgetByName(root, "Text_23"):setString(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.trace_remarks))
		if equipType>=4 then
			ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_5_0"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_5_0"):setVisible(false)
		end

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
	end
end

function EquipInSeeformation:onEnterTransitionFinish()
	app.load("client.cells.equip.equip_info_strengthen_list_cell")
	app.load("client.cells.equip.equip_info_refine_list_cell")
	app.load("client.cells.equip.equip_info_suit_list_cell")
	app.load("client.cells.equip.equip_info_describe_list_cell")
    local csbEquipInformation = csb.createNode("packs/EquipStorage/equipment_information_d.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local action = csb.createTimeline("packs/EquipStorage/equipment_information_d.csb") 
		csbEquipInformation:runAction(action)
		action:play("tubiao_ing", true)
	end
	
	local equipType = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type)
	local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
	for i,v in pairs(_ED.user_equiment) do
		if tonumber(v.ship_id) == 0 and tonumber(v.equipment_type) == equipType and dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) > quality then
			ccui.Helper:seekWidgetByName(root, "Panel_genghuan"):setVisible(true)
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				break
			end
		else
			ccui.Helper:seekWidgetByName(root, "Panel_genghuan"):setVisible(false)
		end
	end
	
	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "equip_information_to_close", terminal_state = 0,isPressedActionEnabled = true}, nil, 2)
	--卸下按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, {terminal_name = "equip_information_quality_request", terminal_state = 0, _equipid = "0" , _equipType = equipType, isPressedActionEnabled = true}, nil, 0)
	--更换按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, {terminal_name = "equip_information_replacement_request", terminal_state = 0, _equipid = self.equipmentInstance.user_equiment_id , _equipType = equipType, isPressedActionEnabled = true}, nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zb_xx_qh"), nil, 
			{
				terminal_name = "equip_info_strengthen_list_in_formation", 
				terminal_state = 0, 
				_equip = self.equipmentInstance, 
				isPressedActionEnabled = true
			}, nil, 0)
	
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zb_xx_jl"), nil, 
			{
				terminal_name = "equip_info_to_refine_lists_cell_from_fromation", 
				terminal_state = 0, 
				_equip = self.equipmentInstance, 
				isPressedActionEnabled = true
			}, nil, 0)
	
	end
	
end


function EquipInSeeformation:onExit()
	state_machine.remove("equip_information_replacement_request")
	state_machine.remove("equip_information_quality_request")
	state_machine.remove("equip_information_to_close")

end

function EquipInSeeformation:init(equipmentInstance,cell)
	self.equipmentInstance = equipmentInstance
	self.cell = cell

end
