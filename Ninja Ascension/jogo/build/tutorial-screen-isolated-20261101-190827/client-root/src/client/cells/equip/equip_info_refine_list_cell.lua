----------------------------------------------------------------------------------------------------
-- 说明：装备信息界面下滑列(精炼)
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipInfoRefineListCell = class("EquipInfoRefineListCellClass", Window)
 
function EquipInfoRefineListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self.cell = nil	
	self.types = nil
    local function equip_info_refine_list_cell_terminal()
		local equip_info_to_refine_lists_cell_terminal = {
            _name = "equip_info_to_refine_lists_cell",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureControllerPanel")
				app.load("client.packs.treasure.TreasureRefinePanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
				if tonumber(params._datas._equip.equipment_type) <= 3 then				--区分装备宝物(跳转到不同界面)
					if tonumber(_ED.user_info.user_grade) >= 30 then
						local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
						equipStrengthenRefineStrorageWindow:init(params._datas._equip,"2",self.cell)
						fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
						state_machine.excute("equip_information_to_close", 0, "equip_information_to_close.")
					else
						TipDlg.drawTextDailog(_string_piece_info[54])
					end
				else
					if tonumber(_ED.user_info.user_grade) >= 40 then
						--精炼等级
						if tonumber(params._datas._equip.equiment_refine_level) < 50 then 
							state_machine.excute("treasure_storage_hide_treasure_storages", 0, "click treasure_storage_hide_treasure_storages.")
							local tcp = TreasureControllerPanel:new()
							tcp:setCurrentTreasure(params._datas._equip)
							fwin:open(tcp, fwin._view)
							state_machine.excute("equip_information_to_close", 0, "equip_information_to_close.")
							state_machine.excute("treasure_controller_manager", 0, 
								{
									_datas = {
										terminal_name = "treasure_controller_manager", 	
										next_terminal_name = "treasure_strengthen_to_refine",	
										current_button_name = "Button_pieces_equipment",  	
										but_image = "", 	
										terminal_state = 0, 
										openWinId = 46,
										isPressedActionEnabled = false
									}
								}
							)
						else
							TipDlg.drawTextDailog(_string_piece_info[90])
						end
					else
						TipDlg.drawTextDailog(_string_piece_info[242])
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_info_to_refine_lists_cell_from_fromation_terminal = {
            _name = "equip_info_to_refine_lists_cell_from_fromation",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureControllerPanel")
				app.load("client.packs.treasure.TreasureRefinePanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
				if tonumber(params._datas._equip.equipment_type) <= 3 then				--区分装备宝物(跳转到不同界面)
					if tonumber(_ED.user_info.user_grade) >= 30 then
						local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							equipStrengthenRefineStrorageWindow:init(params._datas._equip,"2",params._datas._cell,"formation")
						else
							equipStrengthenRefineStrorageWindow:init(params._datas._equip,"2",nil,"formation")
						end
						fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
						state_machine.excute("equip_information_to_close", 0, "equip_information_to_close.")
						state_machine.excute("formation_cell_on_hide", 0, "formation_cell_on_hide.")
						state_machine.excute("equip_formation_choice_hide", 0, "equip_formation_choice_hide.")
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
							state_machine.excute("home_hide_event", 0, "home_hide_event.")
						end
					else
						TipDlg.drawTextDailog(_string_piece_info[54])
					end
				else

					if tonumber(_ED.user_info.user_grade) >= 40 then
						if tonumber(params._datas._equip.equiment_refine_level) < 50 then 
							state_machine.excute("treasure_storage_hide_treasure_storages", 0, "click treasure_storage_hide_treasure_storages.")
							local tcp = TreasureControllerPanel:new()
							tcp:setCurrentTreasure(params._datas._equip, "formation")
							fwin:open(tcp, fwin._view)
							state_machine.excute("equip_information_to_close", 0, "equip_information_to_close.")
							state_machine.excute("formation_cell_on_hide", 0, "formation_cell_on_hide.")
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
								state_machine.excute("home_hide_event", 0, "home_hide_event.")
							end
							state_machine.excute("equip_formation_choice_hide", 0, "equip_formation_choice_hide.")
							state_machine.excute("treasure_controller_manager", 0, 
								{
									_datas = {
										terminal_name = "treasure_controller_manager", 	
										next_terminal_name = "treasure_strengthen_to_refine",	
										current_button_name = "Button_pieces_equipment",  	
										but_image = "", 	
										terminal_state = 0, 
										openWinId = 46,
										isPressedActionEnabled = false
									}
								}
							)
						else

							TipDlg.drawTextDailog(_string_piece_info[90])
						end
					else
						TipDlg.drawTextDailog(_string_piece_info[242])
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(equip_info_to_refine_lists_cell_terminal)
		state_machine.add(equip_info_to_refine_lists_cell_from_fromation_terminal)
        state_machine.init()
    end
	
    
    equip_info_refine_list_cell_terminal()
end


function EquipInfoRefineListCell:onEnterTransitionFinish()
    local csbEquipInfoRefineListCell = csb.createNode("packs/EquipStorage/equipment_information_list_2.csb")
	local root = csbEquipInfoRefineListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	local refineLevel = ccui.Helper:seekWidgetByName(root, "Text_3")
	local describe = ccui.Helper:seekWidgetByName(root, "Text_4")
	local number = ccui.Helper:seekWidgetByName(root, "Text_5")
	local describeTwo = ccui.Helper:seekWidgetByName(root, "Text_4_0")
	local numberTwo = ccui.Helper:seekWidgetByName(root, "Text_5_0")
	
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local refining_max_level = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.refining_max_level)
		if refining_max_level >= 0 then 
			refineLevel:setString(self.equipmentInstance.equiment_refine_level .. "/" .. refining_max_level)
		else
			refineLevel:setString(self.equipmentInstance.equiment_refine_level .. "/" .. 50)
		end
		
	else
		refineLevel:setString(self.equipmentInstance.equiment_refine_level .. "/" .. 50)
	end
	
	

	local LabelList = {
		describe,
		describeTwo,
	}
	local lableNode = {
		number,
		numberTwo,
	}
	local refiningGrowValue = dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.refining_grow_value)
	local myLevel = tonumber(self.equipmentInstance.equiment_refine_level)
	if myLevel == 0 then
		local temp = zstring.split(refiningGrowValue,"|")
		for i,v in ipairs(temp) do
			local Keyvalues = zstring.split(v,",")
			if  table.getn(Keyvalues) > 1  then 
				LabelList[i]:setString(string_equiprety_name[tonumber(Keyvalues[1])+1])
				if tonumber(Keyvalues[1]) >= 4 and tonumber(Keyvalues[1]) <= 17 then
					lableNode[i]:setString(0 .."%")
				else
					lableNode[i]:setString(0)
				end
			end
		end
	else
		local temb = zstring.split(self.equipmentInstance.equiment_refine_param,"|")
		
		for i,v in ipairs(temb) do
			local Keyvalue = zstring.split(v,",")
			if  table.getn(Keyvalue) > 1  then 
				LabelList[i]:setString(string_equiprety_name[tonumber(Keyvalue[1])+1])
				if tonumber(Keyvalue[1]) >= 4 and tonumber(Keyvalue[1]) <= 17 then
					lableNode[i]:setString(Keyvalue[2].."%")
				else
					lableNode[i]:setString(Keyvalue[2])
				end
			end
		end
	end
	if self.types == 2 then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jl"), nil, 
		{
			terminal_name = "equip_info_to_refine_lists_cell_from_fromation", 
			terminal_state = 0, 
			_equip = self.equipmentInstance,
			_cell = self.cell, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jl"), nil, 
		{
			terminal_name = "equip_info_to_refine_lists_cell", 
			terminal_state = 0, 
			_equip = self.equipmentInstance, 
			_cell = self.cell, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
end


function EquipInfoRefineListCell:onExit()
	--state_machine.remove("equip_info_refine_list")
end

function EquipInfoRefineListCell:init(equipmentInstance, cell, types)
	self.equipmentInstance = equipmentInstance
	self.cell = cell
	self.types =types
end

function EquipInfoRefineListCell:createCell()
	local cell = EquipInfoRefineListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end