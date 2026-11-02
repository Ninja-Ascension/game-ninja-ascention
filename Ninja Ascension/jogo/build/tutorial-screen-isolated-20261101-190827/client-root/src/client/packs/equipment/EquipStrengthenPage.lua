----------------------------------------------------------------------------------------------------
-- 说明：装备强化页面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipStrengthenPage = class("EquipStrengthenPageClass", Window)
   
function EquipStrengthenPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self._cell = nil
	self._string_type = nil
	self.cacheFightArmature = nil
	self.is_stop = false
	self.is_stops = false
	self.grade = nil
	self.power = nil
	self.lastGrade = 0
	self.lastPower = 0

	app.load("client.cells.utils.property_change_tip_info_cell") 
    local function init_equip_strengthen_page_terminal()
		-- 强化一次
		local equip_strengthen_once_terminal = {
            _name = "equip_strengthen_once",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(_ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_grade) < tonumber(_ED.user_info.user_grade) * 2 then
					if tonumber(_ED.user_info.user_silver) < tonumber(instance.needCount) then
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.excute("shortcut_function_silver_to_get_open",0,1)
						else
							TipDlg.drawTextDailog(_string_piece_info[127])
						end
						return
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
	            		state_machine.lock("equip_icon_listview_set_index")
	            	end
					local Panel_tpdh = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_zb_qh")
					
					local grade1 = nil		--装备强化大师
					local nums1 = nil
					local shipId = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].ship_id
					if shipId ~= nil and tonumber(shipId) > 0 then
						local equips_id = {}
						local ship_equips = _ED.user_ship[shipId].equipment

						for i, v in pairs(ship_equips) do
							if v.user_equiment_id ~= "0" then
								local tempType = zstring.tonumber(v.equipment_type)
								
								if tempType < 4 then
									equips_id[tempType] = v.user_equiment_id
								end
							end	
						end
						local status = true
						for i = 1, 4 do
							if equips_id[i - 1] == nil then
								status = false
							end
						end
						
						if status == true then
							for i, v in pairs(ship_equips) do
								if i <= 4 then
									if grade1 == nil then
										grade1 = tonumber(v.user_equiment_grade)
									end
									if grade1 > tonumber(v.user_equiment_grade) then
										grade1 = tonumber(v.user_equiment_grade)
									end
									
								end
							end
							-- table.insert(textData, {property = _strengthen_master_info[10], value = grade1, add = _strengthen_master_info[14] })
						end
						local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 0)
						for i, v in ipairs(strengthen_master_data) do
							local need_level = dms.atoi(v, strengthen_master_info.need_level)
							if grade1 ~= nil and grade1 >= need_level then
								nums1 = dms.atoi(v, strengthen_master_info.master_level)
							end
						end
					end
					
					
					instance.lastGrade = instance:getGrade()
					instance.lastPower = instance:getPower()
					
					local function responseEquipmentEscalateCallback(response)
						_ED.baseFightingCount = calcTotalFormationFight()						
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node._datas == nil then
									state_machine.unlock("equip_icon_listview_set_index")
									return
							end
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								state_machine.excute("equip_icon_listview_update_listview",0,instance.equipmentInstance)	
								state_machine.excute("equip_list_view_show_equip_list_view_update_allcell",0,"")
							end
							if "strengthen_master" ~= response.node._datas._string_type then
								state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = response.node._datas._cell}})
								-- state_machine.excute("equip_list_view_del_and_insert_cell", 0, {_datas = {_cell = params._datas._cell}})
							end
							
							if self.cacheFightArmature == nil then
								self.cacheFightArmature = Panel_tpdh:getChildByName("ArmatureNode_2")
							end
							if self.cacheFightArmature.isInited ~= true then
								draw.initArmature(self.cacheFightArmature, nil, 1, nil, nil)
							end
							playEffect(formatMusicFile("effect", 9991))
							self.is_stop = false
							self.cacheFightArmature.isInited = true
							self.cacheFightArmature._invoke = nil
							self.cacheFightArmature._actionIndex = 0
							self.cacheFightArmature._nextAction = 0
							
							local function visibleCallback()
								Panel_tpdh:setVisible(false)
							end
							
							Panel_tpdh:setVisible(true)
							self.cacheFightArmature:getAnimation():playWithIndex(0)
							self.cacheFightArmature._invoke = visibleCallback
							
							local function changeActionCallback()
								local armature = self.cacheFightArmature
								if armature ~= nil and self.is_stop == false then
									-- local actionIndex = armature._actionIndex
									-- deleteEffect(armature)
									self.is_stop = true
									-- Panel_tpdh:setVisible(false)
									local name = {}
									local num = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_grade
									local power = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_ability
									local equipInfunce = zstring.split(power, "|")
									local equipInfunceStr = zstring.split(equipInfunce[1], ",")
									
									local tipInfo = PropertyChangeTipInfoAnimationCell:new()
									local str = ""
									local textData = {}
									----------------------------------------
									local grade2 = nil
									local nums2 = nil
									if nums1 ~= nil then
										for i, v in pairs(_ED.user_ship[shipId].equipment) do
											if i <= 4 then
												if grade2 == nil then
													grade2 = tonumber(v.user_equiment_grade)
												end
												if grade2 > tonumber(v.user_equiment_grade) then
													grade2 = tonumber(v.user_equiment_grade)
												end
											end
										end
										local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 0)
										for i, v in ipairs(strengthen_master_data) do
											local need_level = dms.atoi(v, strengthen_master_info.need_level)
											if grade2 >= need_level then
												nums2 = dms.atoi(v, strengthen_master_info.master_level)
											end
										end
										if nums1 ~= nums2 then
											if tonumber(num) - tonumber(instance.lastGrade) > 1 then
												name[1] = _string_piece_info[162]
												value = tonumber(num) - tonumber(instance.lastGrade)
												name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
												value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
												table.insert(textData, {property = _strengthen_master_info[10], value = nums2, add = _strengthen_master_info[14] })
												table.insert(textData, {property = _string_piece_info[163], value = 1})
												table.insert(textData, {property = name[1], value = value})
												table.insert(textData, {property = name[2], value = value2})
											else
												name[2] = _string_piece_info[162]
												value = tonumber(num) - tonumber(instance.lastGrade)
												name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
												value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
												table.insert(textData, {property = "", value = 1})
												table.insert(textData, {property = name[2], value = value})
												table.insert(textData, {property = name[3], value = value2})
											end
											tipInfo:init(5,str, textData)
												
											fwin:open(tipInfo, fwin._view)
										else
											if tonumber(num) - tonumber(instance.lastGrade) > 1 then
												name[1] = _string_piece_info[162]
												value = tonumber(num) - tonumber(instance.lastGrade)
												name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
												value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
												table.insert(textData, {property = _string_piece_info[163], value = 1})
												table.insert(textData, {property = name[1], value = value})
												table.insert(textData, {property = name[2], value = value2})
											else
												name[2] = _string_piece_info[162]
												value = tonumber(num) - tonumber(instance.lastGrade)
												name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
												value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
												table.insert(textData, {property = "", value = 1})
												table.insert(textData, {property = name[2], value = value})
												table.insert(textData, {property = name[3], value = value2})
											end
	
											tipInfo:init(5,str, textData)
											fwin:open(tipInfo, fwin._view)
										end
									else
										if tonumber(num) - tonumber(instance.lastGrade) > 1 then
											name[1] = _string_piece_info[162]
											value = tonumber(num) - tonumber(instance.lastGrade)
											name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
											value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
											table.insert(textData, {property = _string_piece_info[163], value = 1})
											table.insert(textData, {property = name[1], value = value})
											table.insert(textData, {property = name[2], value = value2})
										else
											name[2] = _string_piece_info[162]
											value = tonumber(num) - tonumber(instance.lastGrade)
											name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
											value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
											table.insert(textData, {property = "", value = 1})
											table.insert(textData, {property = name[2], value = value})
											table.insert(textData, {property = name[3], value = value2})
										end

										tipInfo:init(5,str, textData)
										fwin:open(tipInfo, fwin._view)
									end
									state_machine.unlock("equip_icon_listview_set_index")
									-----------------------------------------
									
									if "strengthen_master" ~= response.node._datas._string_type then
										-- state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = params._datas._cell}})
										-- state_machine.excute("equip_list_view_del_and_insert_cell", 0, {_datas = {_cell = params._datas._cell}})
									else
										state_machine.excute("strengthen_master_draw_equip_strengthen", 0, {_datas = {_cell = response.node._datas._cell}})	
										state_machine.excute("formation_property_change_equip_info", 0, "formation_property_change_equip_info.")
									end	
									-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
									-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
									-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
									-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
								else
									ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
									ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
									ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
									ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
								end
							end
							
							local actions = {}
							-- table.insert(actions, cc.DelayTime:create(0.5))
							table.insert(actions, cc.CallFunc:create(changeActionCallback))
							self:runAction(cc.Sequence:create(actions))
						else
							state_machine.unlock("equip_icon_listview_set_index")
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setBright(true)
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(true)
							end
						end
						if __lua_project_id == __lua_project_yugioh 
							or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_warship_girl_b 
							then
							state_machine.excute("formation_property_change_tip_info", 0, nil)
						end
					end
					
					
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(false)
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(false)
					end
					protocol_command.equipment_escalate.param_list = instance.equipmentInstance.user_equiment_id .. "\r\n" .. "0"  .."\r\n" .."0".. "\r\n-1"
					NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, params, responseEquipmentEscalateCallback,false)
				else
					TipDlg.drawTextDailog(_string_piece_info[30])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 强化五次
		local equip_strengthen_five_terminal = {
            _name = "equip_strengthen_five",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local arena_grade=dms.int(dms["fun_open_condition"], 35, fun_open_condition.level)
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					if tonumber(_ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_grade) < tonumber(_ED.user_info.user_grade) * 2 then
						if tonumber(_ED.user_info.user_silver) < tonumber(instance.needCount) then
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								TipDlg.drawTextDailog(_string_piece_info[127])
							end
							return
						end
						
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.lock("equip_icon_listview_set_index")
						end
						local Panel_tpdh = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_zb_qh")
						
						local grade1 = nil		--装备强化大师
						local nums = nil
						local shipId = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].ship_id
						if shipId ~= nil and tonumber(shipId) > 0 then
							local equips_id = {}
							local ship_equips = _ED.user_ship[shipId].equipment

							for i, v in pairs(ship_equips) do
								if v.user_equiment_id ~= "0" then
									local tempType = zstring.tonumber(v.equipment_type)
									
									if tempType < 4 then
										equips_id[tempType] = v.user_equiment_id
									end
								end	
							end
							local status = true
							for i = 1, 4 do
								if equips_id[i - 1] == nil then
									status = false
								end
							end
							
							if status == true then
								for i, v in pairs(ship_equips) do
									if i <= 4 then
										if grade1 == nil then
											grade1 = tonumber(v.user_equiment_grade)
										end
										if grade1 > tonumber(v.user_equiment_grade) then
											grade1 = tonumber(v.user_equiment_grade)
										end
										
									end
								end
								-- table.insert(textData, {property = _strengthen_master_info[10], value = grade1, add = _strengthen_master_info[14] })
							end
							local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 0)
							for i, v in ipairs(strengthen_master_data) do
								local need_level = dms.atoi(v, strengthen_master_info.need_level)
								if grade1 ~= nil and grade1 >= need_level then
									nums = dms.atoi(v, strengthen_master_info.master_level)
								end
							end
						end
						
						instance.lastGrade = instance:getGrade()
						instance.lastPower = instance:getPower()
						
						local function responseEquipmentEscalateCallback(response)
							_ED.baseFightingCount = calcTotalFormationFight()
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if response.node._datas == nil then
									state_machine.unlock("equip_icon_listview_set_index")
									return
								end
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									state_machine.excute("equip_icon_listview_update_listview",0,instance.equipmentInstance)	
									state_machine.excute("equip_list_view_show_equip_list_view_update_allcell",0,"")
								end
								if "strengthen_master" ~= response.node._datas._string_type then
									state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = response.node._datas._cell}})
									-- state_machine.excute("equip_list_view_del_and_insert_cell", 0, {_datas = {_cell = params._datas._cell}})
								end
								
								
								if self.cacheFightArmature == nil then
									self.cacheFightArmature = Panel_tpdh:getChildByName("ArmatureNode_2")
								end
								if self.cacheFightArmature.isInited ~= true then
									draw.initArmature(self.cacheFightArmature, nil, 1, nil, nil)
								end
								playEffect(formatMusicFile("effect", 9991))
								self.is_stop = false
								self.cacheFightArmature.isInited = true
								self.cacheFightArmature._invoke = nil
								self.cacheFightArmature._actionIndex = 0
								self.cacheFightArmature._nextAction = 0
								
								local function visibleCallback()
									Panel_tpdh:setVisible(false)
								end
								
								Panel_tpdh:setVisible(true)
								self.cacheFightArmature:getAnimation():playWithIndex(0)
								self.cacheFightArmature._invoke = visibleCallback
								
								local function changeActionCallback()
									local armature = self.cacheFightArmature
									if armature ~= nil and self.is_stop == false then
										-- local actionIndex = armature._actionIndex
										-- deleteEffect(armature)
										self.is_stop = true
										-- Panel_tpdh:setVisible(false)
										
										local name = {}
										local num = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_grade
										local power = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_ability
										local equipInfunce = zstring.split(power, "|")
										local equipInfunceStr = zstring.split(equipInfunce[1], ",")
										
										local tipInfo = PropertyChangeTipInfoAnimationCell:new()
										local str = ""
										local textData = {}
										----------------------------------------
										local grade2 = nil
										local nums2 = nil
										if grade1 ~= nil then
											for i, v in pairs(_ED.user_ship[shipId].equipment) do
												if i <= 4 then
													if grade2 == nil then
														grade2 = tonumber(v.user_equiment_grade)
													end
													if grade2 > tonumber(v.user_equiment_grade) then
														grade2 = tonumber(v.user_equiment_grade)
													end
												end
											end
											local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 0)
											for i, v in ipairs(strengthen_master_data) do
												local need_level = dms.atoi(v, strengthen_master_info.need_level)
												if grade2 >= need_level then
													nums2 = dms.atoi(v, strengthen_master_info.master_level)
												end
											end
											if nums ~= nums2 then
												if tonumber(num) - tonumber(instance.lastGrade) > 5 then
													name[1] = _string_piece_info[162]
													value = tonumber(num) - tonumber(instance.lastGrade)
													name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
													value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
													table.insert(textData, {property = _strengthen_master_info[10], value = nums2, add = _strengthen_master_info[14] })
													table.insert(textData, {property = _string_piece_info[163], value = 1})
													table.insert(textData, {property = name[1], value = value})
													table.insert(textData, {property = name[2], value = value2})
												else
													name[2] = _string_piece_info[162]
													value = tonumber(num) - tonumber(instance.lastGrade)
													name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
													value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
													table.insert(textData, {property = "", value = 1})
													table.insert(textData, {property = name[2], value = value})
													table.insert(textData, {property = name[3], value = value2})
												end
												tipInfo:init(5,str, textData)
												fwin:open(tipInfo, fwin._view)
											else
												if tonumber(num) - tonumber(self.grade) > 5 then
													name[1] = _string_piece_info[162]
													value = tonumber(num) - tonumber(instance.lastGrade)
													name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
													value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
													table.insert(textData, {property = _string_piece_info[163], value = 1})
													table.insert(textData, {property = name[1], value = value})
													table.insert(textData, {property = name[2], value = value2})
												else
													name[2] = _string_piece_info[162]
													value = tonumber(num) - tonumber(instance.lastGrade)
													name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
													value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
													table.insert(textData, {property = "", value = 1})
													table.insert(textData, {property = name[2], value = value})
													table.insert(textData, {property = name[3], value = value2})
												end
												tipInfo:init(5,str, textData)
												fwin:open(tipInfo, fwin._view)
											end
										else
											if tonumber(num) - tonumber(instance.lastGrade) > 5 then
												name[1] = _string_piece_info[162]
												value = tonumber(num) - tonumber(instance.lastGrade)
												name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
												value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
												table.insert(textData, {property = _string_piece_info[163], value = 1})
												table.insert(textData, {property = name[1], value = value})
												table.insert(textData, {property = name[2], value = value2})
											else
												name[2] = _string_piece_info[162]
												value = tonumber(num) - tonumber(instance.lastGrade)
												name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
												value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
												table.insert(textData, {property = "", value = 1})
												table.insert(textData, {property = name[2], value = value})
												table.insert(textData, {property = name[3], value = value2})
											end


											tipInfo:init(5,str, textData)
											fwin:open(tipInfo, fwin._view)
										end
										state_machine.unlock("equip_icon_listview_set_index")
										if "strengthen_master" ~= response.node._datas._string_type then
											-- state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = params._datas._cell}})
											-- state_machine.excute("equip_list_view_del_and_insert_cell", 0, {_datas = {_cell = params._datas._cell}})
										else
											state_machine.excute("strengthen_master_draw_equip_strengthen", 0, {_datas = {_cell = response.node._datas._cell}})	
											state_machine.excute("formation_property_change_equip_info", 0, "formation_property_change_equip_info.")
										end
										-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
										-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
										-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
										-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
									else
										ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
										ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
										ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
										ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
										if __lua_project_id == __lua_project_gragon_tiger_gate
											or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
											or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
											or __lua_project_id == __lua_project_red_alert 
											then
											ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setBright(true)
											ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(true)
										end
									end
								end
								
								local actions = {}
								-- table.insert(actions, cc.DelayTime:create(0.5))
								table.insert(actions, cc.CallFunc:create(changeActionCallback))
								self:runAction(cc.Sequence:create(actions))
							else
								state_machine.unlock("equip_icon_listview_set_index")
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setBright(true)
									ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(true)
								end
							end
							if __lua_project_id == __lua_project_yugioh 
								or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
								or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge 
								or __lua_project_id == __lua_project_warship_girl_b 
								then
								state_machine.excute("formation_property_change_tip_info", 0, nil)
							end
						end
						
						--ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(false)
						--ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(false)
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setBright(false)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(false)
						end							
						protocol_command.equipment_escalate.param_list = instance.equipmentInstance.user_equiment_id .. "\r\n" .. "0"  .."\r\n" .."1".. "\r\n-1"
						NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, params, responseEquipmentEscalateCallback,false)
					else
						TipDlg.drawTextDailog(_string_piece_info[30])
					end
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 35, fun_open_condition.tip_info))
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 关闭
		local equip_strengthen_close_terminal = {
            _name = "equip_strengthen_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("equip_strengthen_refine_strorage_back", 0, "equip_strengthen_refine_strorage_back.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local equip_strengthen_btn_restore_terminal = {
            _name = "equip_strengthen_btn_restore",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setBright(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(true)
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local equip_strengthen_update_terminal = {
            _name = "equip_strengthen_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				if type(params) == "table" then
					instance:onUpdateDrawTwo(params)
				else
					instance:onUpdateDrawTwo()
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        		-- 一键强化
		local equip_strengthen_all_terminal = {
            _name = "equip_strengthen_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local arena_grade=dms.int(dms["fun_open_condition"], 35, fun_open_condition.level)
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					if tonumber(_ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_grade) < tonumber(_ED.user_info.user_grade) * 2 then
						if tonumber(_ED.user_info.user_silver) < tonumber(instance.needCount) then
							--一键强化虽然只有龙虎门有，但是也做个判断，避免以后舰娘也开放一键强化
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								state_machine.excute("shortcut_function_silver_to_get_open",0,1)
							else
								TipDlg.drawTextDailog(_string_piece_info[127])
							end
							return
						end
						
						state_machine.lock("equip_icon_listview_set_index")
						local Panel_tpdh = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_zb_qh")
						
						local grade1 = nil		--装备强化大师
						local nums = nil
						local shipId = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].ship_id
						if shipId ~= nil and tonumber(shipId) > 0 then
							local equips_id = {}
							local ship_equips = _ED.user_ship[shipId].equipment

							for i, v in pairs(ship_equips) do
								if v.user_equiment_id ~= "0" then
									local tempType = zstring.tonumber(v.equipment_type)
									
									if tempType < 4 then
										equips_id[tempType] = v.user_equiment_id
									end
								end	
							end
							local status = true
							for i = 1, 4 do
								if equips_id[i - 1] == nil then
									status = false
								end
							end
							
							if status == true then
								for i, v in pairs(ship_equips) do
									if i <= 4 then
										if grade1 == nil then
											grade1 = tonumber(v.user_equiment_grade)
										end
										if grade1 > tonumber(v.user_equiment_grade) then
											grade1 = tonumber(v.user_equiment_grade)
										end
										
									end
								end
								-- table.insert(textData, {property = _strengthen_master_info[10], value = grade1, add = _strengthen_master_info[14] })
							end
							local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 0)
							for i, v in ipairs(strengthen_master_data) do
								local need_level = dms.atoi(v, strengthen_master_info.need_level)
								if grade1 ~= nil and grade1 >= need_level then
									nums = dms.atoi(v, strengthen_master_info.master_level)
								end
							end
						end
						
						instance.lastGrade = instance:getGrade()
						instance.lastPower = instance:getPower()
						
						local function responseEquipmentEscalateCallback(response)
							_ED.baseFightingCount = calcTotalFormationFight()
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

								if response.node._datas == nil then
									state_machine.unlock("equip_icon_listview_set_index")
									return
								end
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									state_machine.excute("equip_icon_listview_update_listview",0,instance.equipmentInstance)	
									state_machine.excute("equip_list_view_show_equip_list_view_update_allcell",0,"")
								end
								if "strengthen_master" ~= response.node._datas._string_type then
									state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = response.node._datas._cell}})
									-- state_machine.excute("equip_list_view_del_and_insert_cell", 0, {_datas = {_cell = params._datas._cell}})
								end
								
								
								if self.cacheFightArmature == nil then
									self.cacheFightArmature = Panel_tpdh:getChildByName("ArmatureNode_2")
								end
								if self.cacheFightArmature.isInited ~= true then
									draw.initArmature(self.cacheFightArmature, nil, 1, nil, nil)
								end
								playEffect(formatMusicFile("effect", 9991))
								self.is_stop = false
								self.cacheFightArmature.isInited = true
								self.cacheFightArmature._invoke = nil
								self.cacheFightArmature._actionIndex = 0
								self.cacheFightArmature._nextAction = 0
								
								local function visibleCallback()
									Panel_tpdh:setVisible(false)
								end
								
								Panel_tpdh:setVisible(true)
								self.cacheFightArmature:getAnimation():playWithIndex(0)
								self.cacheFightArmature._invoke = visibleCallback
								
								local function changeActionCallback()
									local armature = self.cacheFightArmature
									if armature ~= nil and self.is_stop == false then
										-- local actionIndex = armature._actionIndex
										-- deleteEffect(armature)
										self.is_stop = true
										-- Panel_tpdh:setVisible(false)
										
										local name = {}
										local num = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_grade
										local power = _ED.user_equiment[instance.equipmentInstance.user_equiment_id].user_equiment_ability
										local equipInfunce = zstring.split(power, "|")
										local equipInfunceStr = zstring.split(equipInfunce[1], ",")
										
										local tipInfo = PropertyChangeTipInfoAnimationCell:new()
										local str = ""
										local textData = {}
										----------------------------------------
										local grade2 = nil
										local nums2 = nil
										if grade1 ~= nil then
											for i, v in pairs(_ED.user_ship[shipId].equipment) do
												if i <= 4 then
													if grade2 == nil then
														grade2 = tonumber(v.user_equiment_grade)
													end
													if grade2 > tonumber(v.user_equiment_grade) then
														grade2 = tonumber(v.user_equiment_grade)
													end
												end
											end
											local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 0)
											for i, v in ipairs(strengthen_master_data) do
												local need_level = dms.atoi(v, strengthen_master_info.need_level)
												if grade2 >= need_level then
													nums2 = dms.atoi(v, strengthen_master_info.master_level)
												end
											end
											if nums ~= nums2 then
												if tonumber(num) - tonumber(instance.lastGrade) > 5 then
													name[1] = _string_piece_info[162]
													value = tonumber(num) - tonumber(instance.lastGrade)
													name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
													value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
													table.insert(textData, {property = _strengthen_master_info[10], value = nums2, add = _strengthen_master_info[14] })
													table.insert(textData, {property = _string_piece_info[163], value = 1})
													table.insert(textData, {property = name[1], value = value})
													table.insert(textData, {property = name[2], value = value2})
												else
													name[2] = _string_piece_info[162]
													value = tonumber(num) - tonumber(instance.lastGrade)
													name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
													value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
													table.insert(textData, {property = "", value = 1})
													table.insert(textData, {property = name[2], value = value})
													table.insert(textData, {property = name[3], value = value2})
												end


												tipInfo:init(5,str, textData)
												fwin:open(tipInfo, fwin._view)
											else
												if tonumber(num) - tonumber(self.grade) > 5 then
													name[1] = _string_piece_info[162]
													value = tonumber(num) - tonumber(instance.lastGrade)
													name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
													value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
													table.insert(textData, {property = _string_piece_info[163], value = 1})
													table.insert(textData, {property = name[1], value = value})
													table.insert(textData, {property = name[2], value = value2})
												else
													name[2] = _string_piece_info[162]
													value = tonumber(num) - tonumber(instance.lastGrade)
													name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
													value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
													table.insert(textData, {property = "", value = 1})
													table.insert(textData, {property = name[2], value = value})
													table.insert(textData, {property = name[3], value = value2})
												end
												tipInfo:init(5,str, textData)
												fwin:open(tipInfo, fwin._view)
											end
										else
											if tonumber(num) - tonumber(instance.lastGrade) > 5 then
												name[1] = _string_piece_info[162]
												value = tonumber(num) - tonumber(instance.lastGrade)
												name[2] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
												value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
												table.insert(textData, {property = _string_piece_info[163], value = 1})
												table.insert(textData, {property = name[1], value = value})
												table.insert(textData, {property = name[2], value = value2})
											else
												name[2] = _string_piece_info[162]
												value = tonumber(num) - tonumber(instance.lastGrade)
												name[3] = _equiprety_name[equipInfunceStr[1]+1] .. "+" 
												value2 = tonumber(equipInfunceStr[2]) - tonumber(instance.lastPower)
												table.insert(textData, {property = "", value = 1})
												table.insert(textData, {property = name[2], value = value})
												table.insert(textData, {property = name[3], value = value2})
											end

											tipInfo:init(5,str, textData)
											fwin:open(tipInfo, fwin._view)
										end
										state_machine.unlock("equip_icon_listview_set_index")
										if "strengthen_master" ~= response.node._datas._string_type then
											-- state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = params._datas._cell}})
											-- state_machine.excute("equip_list_view_del_and_insert_cell", 0, {_datas = {_cell = params._datas._cell}})
										else
											state_machine.excute("strengthen_master_draw_equip_strengthen", 0, {_datas = {_cell = response.node._datas._cell}})	
											state_machine.excute("formation_property_change_equip_info", 0, "formation_property_change_equip_info.")
										end
										-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
										-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
										-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
										-- ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
									else
										ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
										ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
										ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
										ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
										if __lua_project_id == __lua_project_gragon_tiger_gate
											or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
											or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
											or __lua_project_id == __lua_project_red_alert 
											then
											ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setBright(true)
											ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(true)
										end
									end
								end
								
								local actions = {}
								-- table.insert(actions, cc.DelayTime:create(0.5))
								table.insert(actions, cc.CallFunc:create(changeActionCallback))
								self:runAction(cc.Sequence:create(actions))
							else
								state_machine.unlock("equip_icon_listview_set_index")
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(true)
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(true)
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setBright(true)
								ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(true)
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert then
									ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setBright(true)
									ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(true)
								end
							end
						end
						if __lua_project_id == __lua_project_yugioh 
							or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_warship_girl_b 
							then
							state_machine.excute("formation_property_change_tip_info", 0, nil)
						end
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setTouchEnabled(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_11"):setTouchEnabled(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_12"):setBright(false)

						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_streng_5"):setTouchEnabled(false)
						end		
						protocol_command.equipment_escalate.param_list = instance.equipmentInstance.user_equiment_id .. "\r\n" .. "0"  .."\r\n" .."2".. "\r\n-1"
						NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, params, responseEquipmentEscalateCallback,false)
					else
						TipDlg.drawTextDailog(_string_piece_info[30])
					end
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 35, fun_open_condition.tip_info))
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        	--列表切换装备刷新
        local equip_strengthen_change_equip_update_terminal = {
            _name = "equip_strengthen_change_equip_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDraw()	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_strengthen_once_terminal)
		state_machine.add(equip_strengthen_five_terminal)
		state_machine.add(equip_strengthen_close_terminal)
		state_machine.add(equip_strengthen_update_terminal)
		state_machine.add(equip_strengthen_btn_restore_terminal)
		state_machine.add(equip_strengthen_all_terminal)
		state_machine.add(equip_strengthen_change_equip_update_terminal)	
        state_machine.init()
    end
    
    init_equip_strengthen_page_terminal()
end

function EquipStrengthenPage:getGrade()

	return _ED.user_equiment[self.equipmentInstance.user_equiment_id].user_equiment_grade
end

function EquipStrengthenPage:getPower()
	
	local power = _ED.user_equiment[self.equipmentInstance.user_equiment_id].user_equiment_ability
	local equipInfunce = zstring.split(power, "|")
	local equipInfunceStr = zstring.split(equipInfunce[1], ",")
	return equipInfunceStr[2]
end


function EquipStrengthenPage:updateAnimation(data)

		local root = self.roots[1]
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then			--龙虎门项目控制
			self:onUpdateDrawTwo()
		else
			local old_grade = zstring.tonumber(self.lastGrade)
			local old_power	= zstring.tonumber(self.lastPower)
			
			local add_grade = zstring.tonumber(data[2].value)
			local add_power	= zstring.tonumber(data[3].value)

			
			local change_grade 	=  math.floor(add_grade*0.1)
			local change_power	=  math.floor(add_power*0.1)

			self.strengthenNum = ccui.Helper:seekWidgetByName(root, "Text_7")
			self.describeNum =  ccui.Helper:seekWidgetByName(root, "Text_7_0")
			-- --动画帧-----------------------------------------------------
			self.action = csb.createTimeline("packs/EquipStorage/equipment_strengthen_1.csb")
			self.action:play("text_up", false)
			self.roots[1]:runAction(self.action)

			function addTextNum(grade, power)
				self.strengthenNum:setString(grade .. "/" .. _ED.user_info.user_grade*2)
				self.describeNum:setString("+"..power)
				if __lua_project_id == __lua_project_yugioh then
					self:onUpdateDrawTwo()
				end
			end

			local findex = 1
			self.action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end
				local str = frame:getEvent()
				local ffeventName = string.format("text_up_%d", findex)
				if str == "over" then
					self:onUpdateDrawTwo()
				elseif str == ffeventName then
					
						old_grade 	= old_grade + change_grade
						old_power 	= old_power + change_power

						addTextNum(old_grade, old_power)
					
					findex = findex + 1
				end
			end)
		end
end


function EquipStrengthenPage:onUpdateDrawTwo(data)

	if nil ~= data then
		self:updateAnimation(data)
	else

		local root = self.roots[1]
		local name = {}
		local num = _ED.user_equiment[self.equipmentInstance.user_equiment_id].user_equiment_grade
		local power = _ED.user_equiment[self.equipmentInstance.user_equiment_id].user_equiment_ability
		local equipInfunce = zstring.split(power, "|")
		local equipInfunceStr = zstring.split(equipInfunce[1], ",")
		
		local strengthenNum = ccui.Helper:seekWidgetByName(root, "Text_7")
		local nextStrengthenNum = ccui.Helper:seekWidgetByName(root, "Text_7_1")
		local describeNum = ccui.Helper:seekWidgetByName(root, "Text_7_0")
		local nextDescribeNum = ccui.Helper:seekWidgetByName(root, "Text_7_0_0")
		local money = ccui.Helper:seekWidgetByName(root, "Text_14")
		self.strengthenNum = strengthenNum
		self.describeNum = describeNum
		
		strengthenNum:setString(num .. "/" .. _ED.user_info.user_grade*2)
		nextStrengthenNum:setString((num + 1) .. "/" .. _ED.user_info.user_grade*2)

		describeNum:setString("+"..equipInfunceStr[2])
		local everyLevelAdd = zstring.split(self.equipmentInstance.growup_value,"|")
		local equipInfunceStrAdd = zstring.split(everyLevelAdd[1], ",")
		nextDescribeNum:setString("+" .. equipInfunceStrAdd[2]+equipInfunceStr[2])
		self.grade = self.equipmentInstance.user_equiment_grade
		self.power = equipInfunceStr[2]
		
		--绘制消耗银币 Label_0
		self.needCount = 0 
		local escalateData = zstring.split(dms.string(dms["equipment_level_requirement"], tonumber(self.equipmentInstance.user_equiment_grade)+2, equipment_level_requirement.need_silver),"|")
		
		for i,v in pairs(escalateData) do
			if dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level) + 1 == i then
				local escalateSlive = zstring.split(v,",")	
				for j,slive in pairs(escalateSlive) do
					if dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type) + 1 == j then
						self.needCount = slive
					end
				end
			end
		end
		money:setString(self.needCount)
		if tonumber(_ED.user_info.user_silver) < tonumber(self.needCount) then
			money:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		end
	end
end

--红装光效显示设置
function EquipStrengthenPage:setRedVisible(isshow)
	local hong = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	if nil ~= hong then
		hong:setVisible(isshow)
	end
end

function EquipStrengthenPage:onUpdateDraw()
	local root = self.roots[1]
	
	local name = ccui.Helper:seekWidgetByName(root, "Text_1")
	local allPic = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local strengthenNum = ccui.Helper:seekWidgetByName(root, "Text_7")
	local nextStrengthenNum = ccui.Helper:seekWidgetByName(root, "Text_7_1")
	local describe = ccui.Helper:seekWidgetByName(root, "Text_8")
	local describeNum = ccui.Helper:seekWidgetByName(root, "Text_7_0")
	local nextDescribe = ccui.Helper:seekWidgetByName(root, "Text_8_0")
	local nextDescribeNum = ccui.Helper:seekWidgetByName(root, "Text_7_0_0")
	local money = ccui.Helper:seekWidgetByName(root, "Text_14")
	
	local equipName = dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name)
	local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
	local picIndex = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.All_icon)
	local growValue = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_value)
	
	local equipInfunce = zstring.split(self.equipmentInstance.user_equiment_ability, "|")
	local equipInfunceStr = zstring.split(equipInfunce[1], ",")
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local lv =ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lv")
		local lan=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lan")
		local zi=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_zi")
		local cheng=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_cheng")
		lv:setVisible(false)
		lan:setVisible(false)
		zi:setVisible(false)
		cheng:setVisible(false)
		self:setRedVisible(false)
		if quality == 1 then							--绿色--注意 ：这里的 quality 和信息界面有差异
		--print("绿色")
			lv:setVisible(true)
		elseif quality == 2 then
		--print("蓝色")
			lan:setVisible(true)
		elseif quality == 3 then
		--print("紫色")
			zi:setVisible(true)
		elseif quality == 4 then
			cheng:setVisible(true)
		elseif quality == 5 then
			self:setRedVisible(true)		
		end
	end
	
	name:setString(equipName)
	name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	allPic:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", picIndex))
	describe:setString(_equiprety_name[equipInfunceStr[1]+1])
	describeNum:setString("+"..equipInfunceStr[2])
	strengthenNum:setString(self.equipmentInstance.user_equiment_grade .. "/" .. _ED.user_info.user_grade*2)
	nextStrengthenNum:setString((self.equipmentInstance.user_equiment_grade + 1) .. "/" .. _ED.user_info.user_grade*2)
	
	if (self.equipmentInstance.user_equiment_grade + 1) > _ED.user_info.user_grade*2 then
		nextStrengthenNum:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
	else
		nextStrengthenNum:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
	end
	nextDescribe:setString(_equiprety_name[equipInfunceStr[1]+1])
	local everyLevelAdd = zstring.split(self.equipmentInstance.growup_value,"|")
	local equipInfunceStrAdd = zstring.split(everyLevelAdd[1], ",")
	nextDescribeNum:setString("+" .. equipInfunceStrAdd[2]+equipInfunceStr[2])
	self.grade = self.equipmentInstance.user_equiment_grade
	self.power = equipInfunceStr[2]
	--绘制消耗银币 Label_0
	self.needCount = 0 
	local escalateData = zstring.split(dms.string(dms["equipment_level_requirement"], tonumber(self.equipmentInstance.user_equiment_grade)+2, equipment_level_requirement.need_silver),"|")
	
	for i,v in pairs(escalateData) do
		if dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level) + 1 == i then
			local escalateSlive = zstring.split(v,",")	
			for j,slive in pairs(escalateSlive) do
				if dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type) + 1 == j then
					self.needCount = slive
				end
			end
		end
	end
	money:setString(self.needCount)
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		if tonumber(_ED.user_info.user_silver) < tonumber(self.needCount) then
			money:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		end	
	else
		if tonumber(_ED.user_info.user_silver) < tonumber(self.needCount) then
			money:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		else
			money:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		end
	end
	fwin:addTouchEventListener(allPic, nil, {func_string = [[state_machine.excute("equip_strengthen_close", 0, "click equip_strengthen_close.'")]]}, nil, 0)
end

function EquipStrengthenPage:onEnterTransitionFinish()
    local csbEquipStrengthenPage = csb.createNode("packs/EquipStorage/equipment_strengthen_1.csb")
	local action = csb.createTimeline("packs/EquipStorage/equipment_strengthen_1.csb")
    csbEquipStrengthenPage:runAction(action)
	self:addChild(csbEquipStrengthenPage)
	action:play("window_open", false)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		action:play("tubiao_ing", true)
	end
	local root = csbEquipStrengthenPage:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
		app.load("client.player.EquipPlayerInfomation")
		if fwin:find("EquipPlayerInfomationClass") == nil then
			fwin:open(EquipPlayerInfomation:new(),fwin._windows)
		end
		if self._string_type == "formation" then
			state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
		end
		end
	else
		if self._string_type == "formation" then
			app.load("client.player.EquipPlayerInfomation")
			if fwin:find("EquipPlayerInfomationClass") == nil then
				fwin:open(EquipPlayerInfomation:new(),fwin._windows)
			end
			state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
		end
	end
	
	self:onUpdateDraw()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
		{
			terminal_name = "equip_strengthen_all", 
			terminal_state = 0, 
			_equip = self.equipmentInstance,  
			_cell = self._cell,
			_string_type = self._string_type,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_streng_5"), nil, 
		{
			terminal_name = "equip_strengthen_five", 
			terminal_state = 0, 
			_equip = self.equipmentInstance,  
			_cell = self._cell,
			_string_type = self._string_type,
			isPressedActionEnabled = true
		}, 
		nil, 0)	
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
		{
			terminal_name = "equip_strengthen_five", 
			terminal_state = 0, 
			_equip = self.equipmentInstance,  
			_cell = self._cell,
			_string_type = self._string_type,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end

	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), nil, 
	{
		terminal_name = "equip_strengthen_once", 
		terminal_state = 0, 
		_equip = self.equipmentInstance,  
		_cell = self._cell,
		_string_type = self._string_type,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function EquipStrengthenPage:close()
	--if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if self._string_type == "formation" then
			if fwin:find("EquipPlayerInfomationClass") ~= nil then
				fwin:close(fwin:find("EquipPlayerInfomationClass"))
			end
		end
	--end
	-- body
end

function EquipStrengthenPage:onExit()
	state_machine.remove("equip_strengthen_five")
	state_machine.remove("equip_strengthen_once")
	state_machine.remove("equip_strengthen_close")
	state_machine.remove("equip_strengthen_update")
	state_machine.remove("equip_strengthen_btn_restore")
	state_machine.remove("equip_strengthen_all")
	state_machine.remove("equip_strengthen_change_equip_update")
end

function EquipStrengthenPage:init(equipmentInstance,_cell,_string_type)
	self.equipmentInstance = equipmentInstance
	self._cell = _cell
	self._string_type = _string_type
end
