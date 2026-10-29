----------------------------------------------------------------------------------------------------
-- 说明：装备信息界面下滑列(强化)
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipInfoStrengthenListCell = class("EquipInfoStrengthenListCellClass", Window)
 
 app.load("client.packs.equipment.EquipStrengthenRefineStrorage")
 
function EquipInfoStrengthenListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self.cell = nil	
	self.types = nil
    local function equip_info_strengthen_list_cell_terminal()
		local equip_info_strengthen_list_terminal = {
            _name = "equip_info_strengthen_list",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureStrengthenPanel")
				app.load("client.packs.treasure.TreasureControllerPanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(params._datas._equip.equipment_type) <= 3 then				--区分装备宝物(跳转到不同界面)
					if tonumber(params._datas._equip.user_equiment_grade) < tonumber(_ED.user_info.user_grade*2) then
						local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
						equipStrengthenRefineStrorageWindow:init(params._datas._equip, "1", self.cell)
						fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
						state_machine.excute("equip_information_to_close", 0, "equip_information_to_close.")
					else
						TipDlg.drawTextDailog(_string_piece_info[30])
					end
				else
					if tonumber(_ED.user_info.user_grade) >= 15 then
						if tonumber(params._datas._equip.user_equiment_grade) < 80 then 
							state_machine.excute("treasure_storage_hide_treasure_storages", 0, "click treasure_storage_hide_treasure_storages.")
							local tcp = TreasureControllerPanel:new()
							tcp:setCurrentTreasure(params._datas._equip)
							fwin:open(tcp, fwin._view)
							state_machine.excute("equip_information_to_close", 0, "equip_information_to_close.")
							state_machine.excute("treasure_controller_manager", 0, 
								{
									_datas = {
										terminal_name = "treasure_controller_manager", 	
										next_terminal_name = "treasure_refine_to_strengthen",	
										current_button_name = "Button_equipment",  	
										but_image = "", 	
										terminal_state = 0, 
										openWinId = 8,
										isPressedActionEnabled = false
									}
								}
							)
						else
							TipDlg.drawTextDailog(_string_piece_info[90])
						end
					else
						TipDlg.drawTextDailog(_string_piece_info[104])
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_info_strengthen_list_in_formation_terminal = {
            _name = "equip_info_strengthen_list_in_formation",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureStrengthenPanel")
				app.load("client.packs.treasure.TreasureControllerPanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(params._datas._equip.equipment_type) <= 3 then				--区分装备宝物(跳转到不同界面)
					if tonumber(params._datas._equip.user_equiment_grade) < tonumber(_ED.user_info.user_grade*2) then
						local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
						equipStrengthenRefineStrorageWindow:init(params._datas._equip, "1",nil,"formation")
						fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
						state_machine.excute("equip_information_to_close", 0, "equip_information_to_close.")
						state_machine.excute("formation_cell_on_hide", 0, "formation_cell_on_hide.")
						state_machine.excute("equip_formation_choice_hide", 0, "equip_formation_choice_hide.")
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
							state_machine.excute("home_hide_event", 0, "home_hide_event.")
						end
					else
						TipDlg.drawTextDailog(_string_piece_info[30])
					end
				else
					if tonumber(_ED.user_info.user_grade) >= 15 then
						if tonumber(params._datas._equip.user_equiment_grade) < 80 then 
							state_machine.excute("treasure_storage_hide_treasure_storages", 0, "click treasure_storage_hide_treasure_storages.")
							local tcp = TreasureControllerPanel:new()
							tcp:setCurrentTreasure(params._datas._equip,"formation")
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
										next_terminal_name = "treasure_refine_to_strengthen",	
										current_button_name = "Button_equipment",  	
										but_image = "", 	
										terminal_state = 0, 
										openWinId = -1,
										isPressedActionEnabled = false
									}
								}
							)
						else
							TipDlg.drawTextDailog(_string_piece_info[90])
						end
					else
						TipDlg.drawTextDailog(_string_piece_info[104])
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_info_strengthen_list_terminal)
		state_machine.add(equip_info_strengthen_list_in_formation_terminal)
        state_machine.init()
    end
    
    equip_info_strengthen_list_cell_terminal()
end


function EquipInfoStrengthenListCell:onEnterTransitionFinish()
    local csbEquipInfoStrengthenListCell = csb.createNode("packs/EquipStorage/equipment_information_list_1.csb")
	local root = csbEquipInfoStrengthenListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	local level = ccui.Helper:seekWidgetByName(root, "Text_3")
	local describe = ccui.Helper:seekWidgetByName(root, "Text_4")
	local number = ccui.Helper:seekWidgetByName(root, "Text_5")
	
	local equipInfunce = zstring.split(self.equipmentInstance.user_equiment_ability, "|")
	local equipInfunceStr = zstring.split(equipInfunce[1], ",")
	
	describe:setString(_equiprety_name[equipInfunceStr[1]+1])
	number:setString("+"..equipInfunceStr[2])
	
	if #equipInfunce > 1 then
		local describe_0 = ccui.Helper:seekWidgetByName(root, "Text_4_0")
		local number_0 = ccui.Helper:seekWidgetByName(root, "Text_5_0")
	
		equipInfunceStr = zstring.split(equipInfunce[2], ",")
		
		describe_0:setString(_equiprety_name[equipInfunceStr[1]+1])
		
		if tonumber(equipInfunceStr[1]) >= 4 and tonumber(equipInfunceStr[1]) <= 17 then
			number_0:setString("+"..equipInfunceStr[2].."%")
		else
			number_0:setString("+"..equipInfunceStr[2])
		end
	end
	
	level:setString(self.equipmentInstance.user_equiment_grade .. "/" .. _ED.user_info.user_grade*2)
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then 
		if tonumber(self.equipmentInstance.equipment_type) <= 3 then				
		else
			--宝物等级上限80固定死
			level:setString(self.equipmentInstance.user_equiment_grade .. "/" .. 80)
		end
	end

	if self.types == 2 then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qh"), nil, 
		{
			terminal_name = "equip_info_strengthen_list_in_formation", 
			terminal_state = 0, 
			_equip = self.equipmentInstance, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qh"), nil, 
		{
			terminal_name = "equip_info_strengthen_list", 
			terminal_state = 0, 
			_equip = self.equipmentInstance, 
			isPressedActionEnabled = true
			-- func_string = [[state_machine.excute("equip_info_strengthen_list", 0, "click equip_info_strengthen_list.'")]]
		}, 
		nil, 0)
	end
end


function EquipInfoStrengthenListCell:onExit()
	-- state_machine.remove("equip_info_strengthen_list")
end

function EquipInfoStrengthenListCell:init(equipmentInstance,cell,types)
	self.equipmentInstance = equipmentInstance
	self.cell = cell
	self.types = types
end

function EquipInfoStrengthenListCell:createCell()
	local cell = EquipInfoStrengthenListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end