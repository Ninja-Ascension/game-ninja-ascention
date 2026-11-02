-- ----------------------------------------------------------------------------------------------------
-- 说明：龙虎门阵容界面
-------------------------------------------------------------------------------------------------------
FormationTigerGate = class("FormationTigerGateClass", Window)
local g_formationTigerGate = nil

FormationTigerGate.__userHeroFontName = nil

local formation_page_go_to_child_terminal = {
	_name = "formation_page_go_to_child",
	_init = function (terminal)

	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local shipMouldId = params[1]
		local ship = fundShipWidthTemplateId(shipMouldId)
		state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = ship, _touch_type = "hero", _enter_type = "home"}})
		state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
		fwin:addService({
            callback = function ( params )
				
            	if params[2] == 0 then
				
            	elseif params[2] == 1 then
					state_machine.excute("formation_go_to_hero_evolution", 0, 0)
				elseif params[2] == 2 then
					state_machine.excute("formation_go_to_hero_herodevelop", 0, 0)
				elseif params[2] == 3 then
					state_machine.excute("formation_go_to_hero_herodevelop", 0, 0)
				elseif params[2] == 4 then
					state_machine.excute("formation_go_to_hero_herodevelop", 0, 0)
				end
            end,
            delay = 0,
            params = params
        })
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local formation_tiger_gate_back_terminal = {
	_name = "formation_tiger_gate_back",
	_init = function (terminal)

	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effice_digimon_qh/effice_digimon_qh.ExportJson")
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson")
		state_machine.excute("formation_back_to_home_page", 0, 0)
		state_machine.excute("hero_develop_page_close", 0, 0)
		-- eg: state_machine.excute("formation_tiger_gate_back", 0, 0)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(formation_page_go_to_child_terminal)
state_machine.add(formation_tiger_gate_back_terminal)
state_machine.init()

function FormationTigerGate:ctor()
	self.super:ctor()
	self.roots = {}

	self.ship = nil
	self.shipIds = {}
	self.levelUpBefore = {}
	self.masterStrengthenlv = {}
	self.headListView = nil
	self._current_cell = nil
	self.roleAnimations = {}
	self.relationship_ids = {}

	self.shipEquipPos = {}

	self.sortedHeroes = nil
	self.heroindex = nil
	self.heronumber = nil
	self.enter_type = nil

	self.isUpdateShowShip = true
	self.equipIconArray = {}

	self._bust_index = 1 -- 初始数码形象索引

	self._current_page = 1
    self._equip = nil
    self._material = nil
    self.m_equip_index = 1

    self.ship_shengji = nil
    self.ship_tupo = nil
    self.ship_peiyang = nil
    self.ship_tianming = nil
    self.ship_douhun = nil
    self.ship_special = nil
	self.mega = nil
	self.fight_spirit = nil
	-- 布阵按钮的X位置
	self.formationBtnPosX = nil
	
	local function init_formation_terminal()
		-- 阵型变更
		local formation_page_formation_change_terminal = {
			_name = "formation_page_formation_change",
			_init = function (terminal)
				app.load("client.formation.FormationChange") 
				app.load("client.home.HomeHero")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
                    protocol_command.education_change.param_list = "521"
                    if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
                        NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
                    end
                end
				local formationChangeWindow = FormationChange:new()
				fwin:open(formationChangeWindow, fwin._windows)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 阵型特殊变更
		local formation_page_teshu_formation_change_terminal = {
			_name = "formation_page_teshu_formation_change",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local index = 0
				local function responseChoiceHeroBattleCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("formation_back_to_home_page", 0, 0)
						_ED.user_formetion_status[index] = "0"
               			_ED.formetion[index + 1] = "0"
					end
				end
				
				for i = 2, 7 do
					if zstring.tonumber(_ED.formetion[i]) > 0 then 
						if zstring.tonumber(_ED.formetion[i]) == zstring.tonumber(instance.ship.ship_id) then
							index = i - 1
						end
					end
				end
				local str = ""
				str = str..instance.ship.ship_id.."\r\n"
				str = str..index.."\r\n"	--放入阵型位置 (1 ~ 21)
				str = str.."-1\r\n"	--战船ID
				str = str.."0"
				-- str = str.."1"	--阵型ID
				protocol_command.formation_change.param_list = str
				NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, nil, responseChoiceHeroBattleCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--点击头像刷新阵容
		local formation_change_to_ship_page_view_terminal = {
			_name = "formation_change_to_ship_page_view",
			_init = function (terminal)
			
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				local formation = fwin:find("FormationTigerGateClass")
				if nil == formation or formation.roots == nil then
					return
				end
				-- TODO...
				--[[ formation:init(params)
				formation:drawShipPageView()
				formation:updateDrawShipInfo()
				formation:updateDrawEquipments()]]
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		--点击武将当前装备打开装备信息界面
		local open_ship_current_equip_window_terminal = {
			_name = "open_ship_current_equip_window",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				--打开装备信息前缓存数据先
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if fwin:find("HeroStorageClass") ~= nil then
						fwin:close(fwin:find("HeroStorageClass"))
					end
				end
				state_machine.excute("formation_property_change_before",0,"")
				if tonumber(params._equip.equipment_type) >= 4 then
					state_machine.excute("formation_cell_on_hide",0,"formation_cell_on_hide")
					app.load("client.packs.treasure.TreasureControllerPanel")
					local tcp = TreasureControllerPanel:new()
					tcp:setCurrentTreasure(params._equip,"formation")
					fwin:open(tcp, fwin._view)
				else
					state_machine.excute("formation_cell_on_hide",0,"formation_cell_on_hide")
					app.load("client.packs.equipment.EquipStrengthenRefineStrorage")
					local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
 					equipStrengthenRefineStrorageWindow:init(params._equip, "1", nil, "formation")
 					fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 点击阵容小头像上面的加号按钮的跳转
		local open_add_ship_window_terminal = {
			_name = "open_add_ship_window",
			_init = function (terminal)
				app.load("client.packs.hero.HeroFormationChoiceWear")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				local shipId = -1
				if params._index == nil then
					params._index = params._datas._index
				end
				if params._type == nil then
					params._type = params._datas._type
				end
				state_machine.excute("hero_formation_choice_wear_window_open", 0, {params._index, params._type, shipId})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 点击装备上面的加号按钮的跳转
		local open_add_ship_equip_window_terminal = {
			_name = "open_add_ship_equip_window",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
			 --点击事件
			 if instance.ship ~= nil then
				local isYes = false
				for i,v in pairs(_ED.user_equiment) do
					if zstring.tonumber(v.ship_id) == 0 and zstring.tonumber(v.equipment_type) == zstring.tonumber(params) then
						isYes = true
					end
				end
				if isYes == true then
					app.load("client.packs.equipment.EquipFormationChoiceWear")
					local EquipFormationChoiceWearWindow = EquipFormationChoiceWear:new()
					EquipFormationChoiceWearWindow:init(params,instance.ship)
					fwin:open(EquipFormationChoiceWearWindow, fwin._ui)
				else
					local id = nil
					if zstring.tonumber(params) == 0 then
						id = 1
					elseif zstring.tonumber(params) == 1 then
						id = 3
					elseif zstring.tonumber(params) == 2 then
						id = 4
					elseif zstring.tonumber(params) == 3 then
						id = 2
					elseif zstring.tonumber(params) == 4 then
						id = 37
					elseif zstring.tonumber(params) == 5 then
						id = 39
					end
					app.load("client.packs.hero.HeroPatchInformationPageGetWay")
					local fightWindow = HeroPatchInformationPageGetWay:new()
					fightWindow:init(id,1)
					fwin:open(fightWindow, fwin._windows)
				end
			else
				TipDlg.drawTextDailog(_All_tip_string_info_description._lackHeadtip)
			end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
			
		-- 点击小伙伴小头像上面的加号按钮的跳转
		local open_add_partner_ship_window_terminal = {
			_name = "open_add_partner_ship_window",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				app.load("client.packs.hero.HeroFormationChoiceWear")
				state_machine.excute("hero_formation_choice_wear_window_open", 0, {params,2})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 响应缘分效果按钮
		local response_fate_effect_terminal = {
			_name = "response_fate_effect",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_3"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_3_0"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_63"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_card"):setVisible(false)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 响应缘分效果返回按钮
		local response_fate_effect_return_terminal = {
			_name = "response_fate_effect_return",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_3"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_3_0"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_63"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_card"):setVisible(true)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 请求穿戴当前武将的装备
		local current_ship_equip_wear_request_terminal = {
			_name = "current_ship_equip_wear_request",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local previousShip = {
					ship_id = 1,
					ship_courage = 0,
					ship_health = 0,
					ship_intellect = 0,
					ship_quick = 0,
				}
				local pship = instance.ship
				if type(pship) == "table" then
					previousShip = {
						ship_id = pship.ship_id,
						ship_courage = pship.ship_courage,
						ship_health = pship.ship_health,
						ship_intellect = pship.ship_intellect,
						ship_quick = pship.ship_quick,
					}
				end
				local function responseWearEquipCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					local requestInfo = zstring.zsplit(params, "|")
					state_machine.excute("equip_strengthen_refine_strorage_to_update_draw_button",0,"")
					state_machine.excute("treasure_refine_update_button",0,"")	
					state_machine.excute("equip_icon_listview_update_listview",0,_ED.user_equiment[requestInfo[2]])
					state_machine.excute("treasure_icon_listview_update_listview",0,_ED.user_equiment[requestInfo[2]])
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if fwin:find("EquipStrengthenRefineStrorageClass") ~= nil then
							state_machine.excute("equip_strengthen_refine_strorage_to_close_all",0,"")
							state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = _ED.user_ship[requestInfo[1]]}})
							state_machine.excute("hero_develop_page_show_nowpage",0,"")
						end
						if fwin:find("TreasureControllerPanelClass") ~= nil then
							state_machine.excute("treasure_refine_close_all",0,"")
							state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = _ED.user_ship[requestInfo[1]]}})
							state_machine.excute("hero_develop_page_show_nowpage",0,"")
						end

						local formation = fwin:find("FormationTigerGateClass")
						if nil == formation then
							return
						end
						
						instance:updateDrawEquipments()

						local ser = zstring.zsplit(params, "|")

						instance:showPropertyChangeTipInfoOfEquipment(previousShip,3,ser[3],response.node)
					end
				end
				local requestInfo = zstring.zsplit(params, "|")
				local str = ""
				str = str..requestInfo[1].."\r\n"--佩戴船只ID
				str = str..requestInfo[2].."\r\n"--装备ID
				str = str..requestInfo[3]		--装备位标识
				protocol_command.equipment_adorn.param_list = str
				NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, requestInfo[2], responseWearEquipCallback, false, nil)
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 进入更换装备界面
		local open_replacement_ship_equip_window_terminal = {
			_name = "open_replacement_ship_equip_window",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				local ship = params._datas._self.ship
		 		local equipType = params._datas._self.equipType
		 		local equip = params._datas._self.equipmentInstance
		 		if ship ~= nil then
					app.load("client.packs.equipment.EquipFormationChoiceWear")
					local EquipFormationChoiceWearWindow = EquipFormationChoiceWear:new()
					EquipFormationChoiceWearWindow:init(equipType,ship)
					fwin:open(EquipFormationChoiceWearWindow, fwin._ui)
				else
					TipDlg.drawTextDailog(_All_tip_string_info_description._lackHeadtip)
				end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 请求当前武将的装备卸下
		local replacement_or_unload_ship_equip_wear_request_terminal = {
			_name = "replacement_or_unload_ship_equip_wear_request",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
		 		local ship = params._datas._self.ship
		 		local types = params._datas._self.equipType
		 		local equip = params._datas._self.equipmentInstance
				local previousShip = {
					ship_id = 1,
					ship_courage = 0,
					ship_health = 0,
					ship_intellect = 0,
					ship_quick = 0,
				}
				local pship = ship
				if type(pship) == "table" then
					previousShip = {
						ship_id = pship.ship_id,
						ship_courage = pship.ship_courage,
						ship_health = pship.ship_health,
						ship_intellect = pship.ship_intellect,
						ship_quick = pship.ship_quick,
					}
				end
				local function responseWearEquipCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					state_machine.excute("equip_strengthen_refine_strorage_to_update_draw_button",0,"")
					state_machine.excute("treasure_refine_update_button",0,"")	
					state_machine.excute("equip_icon_listview_update_listview",0,equip)
					state_machine.excute("treasure_icon_listview_update_listview",0,equip)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						instance:updateDrawEquipments()
						if fwin:find("EquipStrengthenRefineStrorageClass") ~= nil then
							state_machine.excute("equip_strengthen_refine_strorage_to_close_all",0,"")
							state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = response.node }})
							state_machine.excute("hero_develop_page_show_nowpage",0,"")	
						end	
						if fwin:find("TreasureControllerPanelClass") ~= nil then
							state_machine.excute("treasure_refine_close_all",0,"")	
							state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = response.node }})	
							state_machine.excute("hero_develop_page_show_nowpage",0,"")
						end
						instance:showPropertyChangeTipInfoOfEquipment(previousShip,2)
					end
				end
				local str = ""
				str = str..ship.ship_id.."\r\n"--佩戴船只ID
				str = str.."0".."\r\n"--装备ID
				str = str..types		--装备位标识
				protocol_command.equipment_adorn.param_list = str
				NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, ship, responseWearEquipCallback, false, nil)
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 请求上阵小伙伴
		local choice_hero_partners_request_terminal = {
			_name = "choice_hero_partners_request",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
			 --点击事件
				local requestInfo = zstring.zsplit(params, "|")
				local shipID = zstring.tonumber(requestInfo[1])
				local shipLocation = zstring.tonumber(requestInfo[2])
				local function responseChoiceHeroPartnersCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()					
					local formation = fwin:find("FormationTigerGateClass")
					if nil == formation then
						return
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						response.node:updateDrawEquipments()
						response.node:updateDrawShipInfo()
						response.node:updateDrawPartnerView()
						if shipLocation > 0 then
							response.node:activateLot(shipID)
						end
						--外面有人关掉了menu栏--这里的处理是临时的
						fwin:open(Menu:new(), fwin._taskbar)
						smFightingChange()
					end
				end
				
				local str = ""
				str = str..requestInfo[1].."\r\n"--战船id
				str = str..requestInfo[2]--上阵位置
				protocol_command.companion_change.param_list = str
				NetworkManager:register(protocol_command.companion_change.code, nil, nil, nil, instance, responseChoiceHeroPartnersCallback, false, nil)
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 请求更换武将or上阵
		local choice_hero_battle_request_terminal = {
			_name = "choice_hero_battle_request",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				--- 记录更换前的将ship
				local previousShip = {
					ship_id = -1,
					ship_courage = 0,
					ship_health = 0,
					ship_intellect = 0,
					ship_quick = 0,
				}
				--点击事件
				local requestInfo = zstring.zsplit(params, "|")
				local change_types = 1
				local index = tonumber(requestInfo[2])
				if tonumber(_ED.formetion[index+1]) == 0 then
					change_types = 6
				end
				local changeIndex = instance._current_cell._index
				local function responseChoiceHeroBattleCallback(response)
					_ED.changeHeroStart = false
					--_ED.baseFightingCount = calcTotalFormationFight()
					local formation = fwin:find("FormationTigerGateClass")
					if nil == formation then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							local _ship = fundShipWidthId(requestInfo[1])
							state_machine.excute("home_hero_main_tip_show",0,{ ship = _ship })
							state_machine.excute("home_hero_refresh_draw", 0, "")
							state_machine.excute("hero_develop_page_update_for_icon",0,_ship)
							state_machine.excute("formation_sort_and_get_index",0,"")
							state_machine.excute("hero_icon_listview_update_all_icon",0,ship)
							smFightingChange()
						end
						return 
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local ship = fundShipWidthId(requestInfo[1])
						response.node:init(ship)
						response.node:removeOffFormationRoleAni(changeIndex)
						response.node:drawHeadQueue(ship)
						response.node:showPropertyChangeTipInfo(previousShip,change_types,nil,true)
						-- response.node:updateDrawPartnerView()
						state_machine.excute("hero_develop_page_update_for_icon",0,ship)
						state_machine.excute("formation_sort_and_get_index",0,"")
						state_machine.excute("home_hero_refresh_draw", 0, 0)
						state_machine.excute("hero_icon_listview_update_all_icon",0,ship)
						smFightingChange()
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							state_machine.excute("formation_property_change_equip_info",0,"")
						end

						--更换英雄之后，页面index跟着刷新
						local homeherowindow = fwin:find("HomeHeroClass")							
						local for_index = tonumber(requestInfo[2])
						local formetion_index = 0
						local f_shipid =_ED.formetion[for_index + 1]

						for i ,v in pairs(_ED.user_formetion_status) do
							if f_shipid == v then
								formetion_index = i
								break
							end
						end
						homeherowindow.current_formetion_index = formetion_index

						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_evo")
							if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
								state_machine.excute("sm_role_strengthen_tab_special_attributes_change_ship",0,ship.ship_id)
								state_machine.excute("sm_role_strengthen_tab_special_attributes_update_draw",0,"")
							end
							if fwin:find("SmRoleStrengthenTabUpgradeClass") ~= nil then
								if tonumber(ship.ship_id) ~= tonumber(fwin:find("SmRoleStrengthenTabUpgradeClass").ship_id) then
									state_machine.excute("sm_role_strengthen_tab_up_grade_change_ship",0,ship.ship_id)
									state_machine.excute("sm_role_strengthen_tab_up_grade_update_draw",0,"")
								end
							end
							if fwin:find("SmRoleStrengthenTabUpProductClass") ~= nil then
								state_machine.excute("sm_role_strengthen_tab_up_product_change_ship",0,ship.ship_id)
								state_machine.excute("sm_role_strengthen_tab_up_product_update_draw",0,"")
							end
							if fwin:find("SmRoleStrengthenTabRisingStarClass") ~= nil then
								state_machine.excute("sm_role_strengthen_tab_rising_star_change_ship",0,ship.ship_id)
								state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw",0,"")
							end
							if fwin:find("SmRoleStrengthenTabSkillClass") ~= nil then
								state_machine.excute("sm_role_strengthen_tab_skill_update_draw",0,{ship.ship_id})
							end
							if fwin:find("SmRoleStrengthenTabFightingSpiritClass") ~= nil then
								state_machine.excute("sm_role_strengthen_tab_fighting_spirit_update_draw",0,{ship.ship_id})
							end
							if fwin:find("SmRoleStrengthenTabFightSpiritClass") ~= nil then
								state_machine.excute("sm_role_strengthen_tab_fight_spirit_change_ship",0,ship.ship_id)
							end

							state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_evolution_page_tip")
							state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_up_grade_star_page_tip")
						end

					end
				end

				if zstring.tonumber(requestInfo[2]) > 0 then
					local str = ""
					str = str..requestInfo[1].."\r\n"--战船id
					str = str .. requestInfo[2].."\r\n"--上阵位置
					str = str.."1".."\r\n"--上阵位置
					if _ED.whetherReplaceFightSpirit then
						str = str .. "1"
					else
						str = str .. "0"
					end
					local pship = instance.ship
					
					if type(pship) == "table" then
						previousShip = {
							ship_id = pship.ship_id,
							ship_courage = pship.ship_courage,
							ship_health = pship.ship_health,
							ship_intellect = pship.ship_intellect,
							ship_quick = pship.ship_quick,
						}
					end
					
					_ED.changeHeroStart = true
					protocol_command.formation_change.param_list = str
					NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, instance, responseChoiceHeroBattleCallback, false, nil)
				end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 请求更换武将
		local replacement_battle_hero_request_terminal = {
			_name = "replacement_battle_hero_request",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
			    if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
			        protocol_command.education_change.param_list = "532"
			        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
			            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
			        end
			    end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					instance.isUpdateShowShip = true
				end
				local shipId = instance.ship.ship_id
				local index = 0
				for i = 2, 7 do
					if zstring.tonumber(_ED.formetion[i]) > 0 then 
						if zstring.tonumber(_ED.formetion[i]) == zstring.tonumber(instance.ship.ship_id) then
							app.load("client.packs.hero.HeroFormationChoiceWear")
							state_machine.excute("hero_formation_choice_wear_window_open", 0, {i - 1, nil, shipId})
							return
						end
					end
				end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local formation_cell_on_show_terminal = {
			_name = "formation_cell_on_show",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				local st = fwin:find("FormationTigerGateClass")
				if st ~= nil then
					st:setVisible(true)
					fwin:find("HeroIconListViewClass"):setVisible(true)
				end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local formation_cell_on_hide_terminal = {
			_name = "formation_cell_on_hide",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				local st = fwin:find("FormationTigerGateClass")
				if st ~= nil then
					st:setVisible(false)
					fwin:find("HeroIconListViewClass"):setVisible(false)
				end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local formation_show_strengthen_master_terminal = {
            _name = "formation_show_strengthen_master",
            _init = function (terminal) 
                app.load("client.formation.StrengthenMaster")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if (instance._current_cell and instance._current_cell.ship and 
					type(instance._current_cell.ship) == "table" and
					instance._current_cell.ship.ship_id) then

					local shipId = instance._current_cell.ship.ship_id
					local equips_id = {}
					local ship_equips = _ED.user_ship[shipId].equipment
					
					for i, v in pairs(ship_equips) do
						if v.user_equiment_id ~= "0" then
							local tempType = zstring.tonumber(v.equipment_type)
							
							if tempType < 4 and i <= 4 then
								equips_id[tempType] = v.user_equiment_id
							end
						end	
					end
					
					for i = 1, 4 do
						if equips_id[i - 1] == nil then
							TipDlg.drawTextDailog(_strengthen_master_info[5])
							return
						end
					end
					
					local strengthen_master_layer = StrengthenMaster:new()
					strengthen_master_layer:init(shipId)
					fwin:open(strengthen_master_layer, fwin._ui)
					
					state_machine.excute("strengthen_master_manager", 0, 
						{
							_datas = {
								terminal_name = "strengthen_master_manager", 	
								next_terminal_name = "strengthen_master_show_equip_strengthen_view",	
								current_button_name = "Button_02",  	
								but_image = "", 	
								terminal_state = 0, 
								isPressedActionEnabled = false
							}
						}
					)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--换将发生属性变更了
		local formation_property_change_tip_info_terminal = {
            _name = "formation_property_change_tip_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 显示变更动画
				instance:updateDrawShipInfoAction(params)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--武将属性发生变更的动画(武将升级,突破==)
		local formation_property_change_by_level_up_terminal = {
            _name = "formation_property_change_by_level_up",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 显示变更动画
				local pship = instance.ship
				if type(pship) == "table" then
					instance:showPropertyChangeTipInfo(instance.levelUpBefore,4) 
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--缓存属性
		local formation_property_change_before_terminal = {
            _name = "formation_property_change_before",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 显示变更动画
				local pship = instance.ship
				if type(pship) == "table" then
					instance.levelUpBefore = {
						ship_id = pship.ship_id,
						ship_courage = pship.ship_courage,
						ship_health = pship.ship_health,
						ship_intellect = pship.ship_intellect,
						ship_quick = pship.ship_quick,
					}
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--刷新武将装备
		local formation_property_change_equip_info_terminal = {
            _name = "formation_property_change_equip_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateDrawEquipments()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
					then
		    		state_machine.excute("formation_switch_paging_information",0,{_datas = {_page = instance._current_page,m_index = instance.m_equip_index}})
		        end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--其他界面调用阵容复位
		local formation_other_interface_reset_terminal = {
            _name = "formation_other_interface_reset",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- instance:otherInterfaceReset(params._index)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 返回动画
		local formation_back_to_home_activity_terminal = {
			_name = "formation_back_to_home_activity",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:find("HeroIconListViewClass"):setVisible(false)
				instance.actions[1]:play("animation_close", false)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 返回
		local formation_back_to_home_page_terminal = {
			_name = "formation_back_to_home_page",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if fwin:find("HomeClass") == nil then
			            state_machine.excute("menu_manager", 0, 
			                {
			                    _datas = {
			                        terminal_name = "menu_manager",     
			                        next_terminal_name = "menu_show_home_page", 
			                        current_button_name = "Button_home",
			                        but_image = "Image_home",       
			                        terminal_state = 0, 
			                        _needOpenHomeHero = true,
			                        isPressedActionEnabled = true
			                    }
			                }
			            )
			        end

			        -- 如果在进阶-获得途径里进行扫荡，并开启了神秘商店，则关闭当前界面进入主城时刷新神秘商店的显示
			        state_machine.excute("home_open_secret_shop", 0, true)
			       
			        state_machine.excute("menu_back_home_page", 0, "")
					instance.isUpdateShowShip = true
		    		state_machine.excute("sm_model_open_layout_refresh_draw", 0, "")
		    		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			    		if _ED.login_popup_banner ~= false then
				    		local missionShip = fundShipWidthTemplateId(13)
				    		if __lua_project_id == __lua_project_l_naruto then
				    			if missionShip ~= nil and tonumber(missionShip.StarRating) >= 2 then
					    			-- state_machine.excute("menu_window_login_popup_banner", 0, true)
			    					_ED.login_popup_banner = false
					    		end
				    		else
					    		if missionShip ~= nil and tonumber(zstring.split(missionShip.evolution_status,"|")[1]) >= 2 then
					    			_ED.login_popup_banner = false
					    			-- state_machine.excute("menu_window_login_popup_banner", 0, true)
					    		end
					    	end
			    		end
		    		end
		    		self:destroy()
		   	 	end
				instance:playCloseAction()
				state_machine.excute("hero_develop_page_close",0,"")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		--升级、突破、培养 按钮响应
		local formation_click_hero_Level_up_page_terminal = {
            _name = "formation_click_hero_Level_up_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local arena_grade=dms.int(dms["fun_open_condition"], 33, fun_open_condition.level)
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					local cell = instance.types
					state_machine.excute("return_to_the_squad_screen", 0, "return_to_the_squad_screen")
					state_machine.excute("hero_information_close", 0, "hero_information_close")
					if fwin:find("HeroDevelopClass") ~= nil then
		    			fwin:close(fwin:find("HeroDevelopClass"))
		    		end
					local layer = HeroDevelop:new()
					layer:init(params._datas._ship_id, cell)
					fwin:open(layer, fwin._viewdialog)
					state_machine.excute("hero_storage_hide_window", 0)
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],33, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		-- 更改武将信息
		local formation_hero_info_change_terminal = {
			_name = "formation_hero_info_change",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local ship_id = params[1]
				-- print("==============",instance.enter_type)
				-- instance:changeSelectHeroInfo()
				if instance.enter_type == "pack" then
					instance:init(instance.ship)
					instance:updateDrawShipInfo()
					instance:updateDrawEquipments()
					instance:drawShipPageView(instance.ship)
					instance:updateCamper()
					state_machine.excute("hero_develop_page_update_for_icon",0,instance.ship)
				else
					for i, v in pairs(instance._dataCell) do
						if type(v._ship) == "table" and v._ship.ship_id == ship_id 
						 or v._ship == -1 and tonumber(ship_id) == 0 and v._indexadd == instance:getFormationPos("0", 1) then
						 	instance._current_cell = v
						 	instance:changeSelectHeroInfo()
						 	state_machine.excute("hero_develop_page_update_for_icon",0,instance.ship)
						 	break
						end
					end
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
						state_machine.excute("sm_role_strengthen_tab_special_attributes_change_ship",0,ship_id)
						state_machine.excute("sm_role_strengthen_tab_special_attributes_update_draw",0,"")
					end
					if fwin:find("SmRoleStrengthenTabUpgradeClass") ~= nil then
						if tonumber(ship_id) ~= tonumber(fwin:find("SmRoleStrengthenTabUpgradeClass").ship_id) then
							state_machine.excute("sm_role_strengthen_tab_up_grade_change_ship",0,ship_id)
							state_machine.excute("sm_role_strengthen_tab_up_grade_update_draw",0,"")
						end
					end
					if fwin:find("SmRoleStrengthenTabUpProductClass") ~= nil then
						state_machine.excute("sm_role_strengthen_tab_up_product_change_ship",0,ship_id)
						state_machine.excute("sm_role_strengthen_tab_up_product_update_draw",0,"")
					end
					if fwin:find("SmRoleStrengthenTabRisingStarClass") ~= nil then
						state_machine.excute("sm_role_strengthen_tab_rising_star_change_ship",0,ship_id)
						state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw",0,"")
					end
					if fwin:find("SmRoleStrengthenTabSkillClass") ~= nil then
						state_machine.excute("sm_role_strengthen_tab_skill_update_draw",0,{ship_id})
					end
					if fwin:find("SmRoleStrengthenTabFightingSpiritClass") ~= nil then
						state_machine.excute("sm_role_strengthen_tab_fighting_spirit_update_draw",0,{ship_id})
					end
					if fwin:find("SmRoleStrengthenTabFightSpiritClass") ~= nil then
						state_machine.excute("sm_role_strengthen_tab_fight_spirit_change_ship",0,ship_id)
					end

					state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_evolution_page_tip")
					state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_up_grade_star_page_tip")
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}	
		
		-- 布阵后处理
		local formation_hero_cell_index_update_terminal = {
			_name = "formation_hero_cell_index_update",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:updateDataCellIndex()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}	
		-- 时装
		local formation_hero_wear_click_terminal = {
			_name = "formation_hero_wear_click",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local isOpen  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 2, fun_open_condition.level)
				if isOpen == true then
				--to do  没开启，暂时显示未开启
					app.load("client.packs.fashion.FashionDevelop")
					state_machine.excute("fashion_develop_open", 0,{_datas= {_pageType = 1}})
				else
					TipDlg.drawTextDailog(_function_unopened_tip_string)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}	
		
		local formation_hero_partners_show_or_hidden_terminal = {
			_name = "formation_hero_partners_show_or_hidden",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local _show=params._datas._show
				if _show == true then
					instance:updateDrawPartnerView()
				end				
				instance:showHeroPartners(_show)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		--点击强化
		local formation_go_to_hero_herodevelop_terminal = {
            _name = "formation_go_to_hero_herodevelop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)			
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		instance:openHeroDevelop()
            	end	
				-- local ship = instance._current_cell.ship
				-- if ship == nil then
				-- 	return
				-- end
				-- app.load("client.formation.HeroInformation")
				-- state_machine.excute("hero_information_open_window", 0, ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        		-- 去技能更换
		local formation_go_to_change_pack_terminal = {
			_name = "formation_go_to_change_pack",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
                local _level = tonumber(dms.string(dms["fun_open_condition"],54, fun_open_condition.level))
                local user_level = tonumber(_ED.user_info.user_grade)
                if user_level >= _level then
                    app.load("client.learingskills.LearingSkillsDevelop")
                    state_machine.excute("learing_skills_develop_open",0,{2,2})
                else
                    local text = dms.string(dms["fun_open_condition"],54, fun_open_condition.tip_info)
                    TipDlg.drawTextDailog(text)
                end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		local formation_update_skill_icon_terminal = {
			_name = "formation_update_skill_icon",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:updateDrawSkillIcon(params)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		local formation_update_all_hero_terminal = {
			_name = "formation_update_all_hero",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:drawShipPageView()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		--
		local formation_go_to_hero_reloship_terminal = {
            _name = "formation_go_to_hero_reloship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)				
				local ship = instance.ship
				if ship == nil then
					return
				end
				local button_type = params._datas.button_type
				local relationName= dms.string(dms["fate_relationship_mould"], instance.relationship_ids[button_type], fate_relationship_mould.relation_name)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local name_datas = dms.element(dms["word_mould"], zstring.tonumber(relationName))
    				relationName = name_datas[3]
				end
				instance:gotoGetRelation(relationName)
				-- app.load("client.packs.hero.HeroPatchInformation")
				-- local hpi = HeroPatchInformation:new()
				-- hpi:init(ship, 3)
				-- fwin:open(hpi, fwin._windows)
			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }		
		
		local formation_play_equip_show_terminal = {
			_name = "formation_play_equip_show",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				instance.actions[1]:play("window_open",false)
				-- state_machine.excute("hero_develop_page_show_equip",0,"")
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		local formation_play_equip_hide_terminal = {
			_name = "formation_play_equip_hide",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				else
					if instance ~= nil and instance.roots[1] ~= nil and instance.actions ~= nil and instance.actions[1] ~= nil then
						instance.actions[1]:play("window_close",false)
					end
				end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local formation_turn_page_terminal = {
			_name = "formation_turn_page",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				instance:turnPage(params._datas.types)
				state_machine.excute("hero_icon_listview_set_index",0,instance.ship)
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		local formation_set_type_terminal = {
			_name = "formation_set_type",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					state_machine.excute("hero_information_open_window", 0, {params[2],params[1]})
				end
				instance.enter_type = params[1]
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					instance.ship = params[2]
				end
				-- instance:init(params[2])
				-- print("=================================",instance.enter_type)
				state_machine.excute("formation_sort_and_get_index",0,"")
				-- instance:init(instance.ship)
				
				instance:updateDrawShipInfo()
				instance:updateDrawEquipments()
				instance:drawShipPageView(instance.ship)
				instance:updateCamper()
				app.load("client.formation.HeroInformation")
				-- state_machine.excute("hero_information_open_window", 0, {instance.ship,instance.enter_type})
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				else
					state_machine.excute("hero_information_open_window", 0, {instance.ship,instance.enter_type})
				end
				
				-- print("======init======",instance.ship.captain_name)

			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		local formation_sort_and_get_index_terminal = {
		    _name = "formation_sort_and_get_index",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
				instance.sortedHeroes = instance:getSortedHeroes()
				-- print("==============",#instance.sortedHeroes)
				instance:getHeroIndex()	
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
		--一键强化装备
		local formation_to_one_key_equipment_terminal = {
		    _name = "formation_to_one_key_equipment",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	state_machine.lock("formation_to_one_key_equipment")
				local previousShip = {
					ship_id = 1,
					ship_courage = 0,
					ship_health = 0,
					ship_intellect = 0,
					ship_quick = 0,
				}
				local pship = instance.ship
				if type(pship) == "table" then
					previousShip = {
						ship_id = pship.ship_id,
						ship_courage = pship.ship_courage,
						ship_health = pship.ship_health,
						ship_intellect = pship.ship_intellect,
						ship_quick = pship.ship_quick,
					}
				end

		    	local function responseCallback( response )
		    		_ED.baseFightingCount = calcTotalFormationFight()
		    		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		    			-- print("==============强化成功")
			    		if response.node ~= nil and response.node.roots ~= nil and response.node.updateDrawEquipments ~= nil then
			    			instance:updateDrawEquipments()		
			    			instance:showChangeTipInfoStrenghEquipment(previousShip,2)
			    			state_machine.unlock("formation_to_one_key_equipment")
			    		end
		    		else
		    			state_machine.unlock("formation_to_one_key_equipment")
		    		end
                end
                -- print("==============强化请求",instance.ship.ship_id,instance.ship.captain_name)
                protocol_command.equipment_one_key_escalate.param_list = ""..instance.ship.ship_id
                NetworkManager:register(protocol_command.equipment_one_key_escalate.code, nil, nil, nil, instance, responseCallback, false, nil)
		    	
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
		--外部刷新英雄
		local formation_set_ship_terminal = {
		    _name = "formation_set_ship",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	local ship = params
		    	if params == nil or params == "" or params == 1 then
		    		ship = instance.ship
		    	end
		    	if zstring.tonumber(instance.ship.ship_id) == zstring.tonumber(ship.ship_id) then
		    		local evo_image = dms.string(dms["ship_mould"], instance.ship.ship_template_id, ship_mould.fitSkillTwo)
					local evo_info = zstring.split(evo_image, ",")
		    		local ship_evo1 = zstring.split(instance.ship.evolution_status, "|")
					local evo_mould_id1 = smGetSkinEvoIdChange(instance.ship)
					local ship_evo2 = zstring.split(ship.evolution_status, "|")
					local evo_mould_id2= smGetSkinEvoIdChange(ship)
					if tonumber(evo_mould_id1) == tonumber(evo_mould_id2) then
						instance.isUpdateShowShip = false
					else
						instance.isUpdateShowShip = true
					end
					if params == 1 then
						instance.isUpdateShowShip = true
					end
				else
					instance.isUpdateShowShip = true
		    	end
		    	instance:init(ship)
		    	state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_strengthen_button")
		    	local shipid = ship.ship_id
		    	state_machine.excute("formation_hero_info_change",0,{shipid}) 
		    	state_machine.excute("formation_sort_and_get_index",0,"")
		    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		    		state_machine.excute("formation_switch_paging_information",0,{_datas = {_page = instance._current_page,m_index = instance.m_equip_index}})
			    	state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_evo")
			    	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_evo")
			    	
					state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_formation")
				    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equip_upgrade")
					state_machine.excute("notification_center_update",0,"push_notification_center_formation_equip_awake")
					-- 装备淬炼推送
					state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_harden_page_tips")
				 --   state_machine.excute("notification_center_update",0,"push_notification_center_formation_mega")
				   
				    if fwin:find("HeroStorageClass") ~= nil then
				    	state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_upgrade")
				    	state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_awake")
				    end
		        end
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--刷新属性
		local formation_update_ship_info_terminal = {
		    _name = "formation_update_ship_info",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	if params ~= nil and params.isChange == true then
		    		instance.isUpdateShowShip = true
		    	end
		    	instance:updateDrawShipInfo()
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
	
		--觉醒
		local formation_go_to_hero_awaken_terminal = {
		    _name = "formation_go_to_hero_awaken",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	if instance:checkHeroCanAwaken() == true then 
		    		local shipId = instance.ship.ship_id
		    		instance:playCloseAction()
					state_machine.excute("hero_develop_page_close",0,"")
					
		    		app.load("client.packs.hero.HeroAwakenPage")
					local awakenWindow = HeroAwakenPage:new()
					awakenWindow:init(shipId)
					fwin:open(awakenWindow, fwin._view)
		    	end
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--超进化
		local formation_go_to_mega_terminal = {
		    _name = "formation_go_to_mega",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		        state_machine.excute("mega_window_open",0,nil)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--新的武将形象绘制动画
		local formation_hero_develop_play_hero_animation_terminal = {
            _name = "formation_hero_develop_play_hero_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots[1] ~= nil and instance.changeHeroAnimation then
            		instance:changeHeroAnimation(params)
            	end
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --进化
		local formation_go_to_hero_evolution_terminal = {
		    _name = "formation_go_to_hero_evolution",
		    _init = function (terminal)
		    	app.load("client.packs.hero.GeneralsEvoChainWindow")
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	_ED.previous_ship_evo_window = "FormationTigerGateClass"
		    	fwin:find("HeroIconListViewClass"):setVisible(false)
		    	state_machine.excute("generals_evo_chain_window_open",0,{instance.ship})
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		local formation_go_to_open_rebrith_terminal = {
            _name = "formation_go_to_open_rebrith",
            _init = function (terminal)
                app.load("client.packs.hero.SmRoleInfomationRebirth")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_role_infomation_rebirth_window_open",0,{instance.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_go_to_open_fashion_terminal = {
            _name = "formation_go_to_open_fashion",
            _init = function (terminal)
            	app.load("client.packs.hero.SmRoleFashion")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- if true then
             --        TipDlg.drawTextDailog(_wait_open_tip)
             --        return
             --    end
                state_machine.excute("sm_role_fashion_window_open", 0, {instance.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_go_to_open_matrix_terminal = {
            _name = "formation_go_to_open_matrix",
            _init = function (terminal)
            	app.load("client.l_digital.cultivate.matrix.AlloyMatrixWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- if true then
             --        TipDlg.drawTextDailog(_wait_open_tip)
             --        return
             --    end
                state_machine.excute("alloy_matrix_window_open", 0, {instance.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
	-- 打开究极潜力
        local formation_go_to_open_energy_terminal = {
            _name = "formation_go_to_open_energy",
            _init = function (terminal)
            	app.load("client.packs.hero.SmRoleEnergy")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local evo_image = dms.string(dms["ship_mould"], instance.ship.ship_template_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				local ship_evo = zstring.split(instance.ship.evolution_status, "|")
				local evolutionLevel = tonumber(ship_evo[1])
            	local evo_mould_id = evo_info[evolutionLevel]
            	-- print("打开究极潜力:" .. evo_mould_id)

				local ship_evo_mould_field12 = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.field12)
				if ship_evo_mould_field12 ~= nil and ship_evo_mould_field12 ~= "-1" then
					local ship_evo_mould_field12_talentInfos = zstring.split(ship_evo_mould_field12, ",")
					state_machine.excute("sm_role_energy_window_open", 0, {ship_evo_mould_field12_talentInfos})
				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

		--新武将信息界面
		local formation_go_to_hero_data_info_terminal = {
		    _name = "formation_go_to_hero_data_info",
		    _init = function (terminal)
		    	app.load("client.formation.HeroInformation")
                app.load("client.packs.hero.SmRoleInformation")
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	--fwin:find("HeroIconListViewClass"):setVisible(false)
		    	state_machine.excute("sm_role_information_open",0,{instance.ship.ship_template_id,1})
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--切换武将进化形象动画按钮-left
		local formation_change_hero_sprite_info_left_terminal = {
		    _name = "formation_change_hero_sprite_info_left",
		    _init = function (terminal)

		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	instance._bust_index = instance._bust_index - 1
		    	instance:newFormationShowShipChange(instance._bust_index)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--切换武将进化形象动画按钮-right
		local formation_change_hero_sprite_info_right_terminal = {
		    _name = "formation_change_hero_sprite_info_right",
		    _init = function (terminal)

		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	instance._bust_index = instance._bust_index + 1
		    	instance:newFormationShowShipChange(instance._bust_index)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--随机播放角色动作
		local formation_change_hero_sprite_info_play_animation_terminal = {
		    _name = "formation_change_hero_sprite_info_play_animation",
		    _init = function (terminal)

		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	-- instance._bust_index = instance._bust_index
		    	local ship = fundShipWidthId(instance.ship.ship_id)
		    	local ship_evo = zstring.split(ship.evolution_status, "|")
				instance._bust_index = tonumber(ship_evo[1])
		    	instance:newFormationShowShipChange(instance._bust_index)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--刷新装备推送
		local formation_update_equip_icon_push_terminal = {
		    _name = "formation_update_equip_icon_push",
		    _init = function (terminal)

		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil and instance.equipIconArray ~= nil then
			    	for i ,v in pairs(instance.equipIconArray) do
			    		state_machine.excute("equip_icon_cell_update_push",0,v)
			    	end
		    	end
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--切换阵容其中的一页
		local formation_switch_paging_information_terminal = {
		    _name = "formation_switch_paging_information",
		    _init = function (terminal)
		    	app.load("client.packs.equipment.SmEquipmentTabUpProduct")
    			app.load("client.packs.equipment.SmEquipmentTabAwakening")
    			app.load("client.packs.hero.SmRoleStrengthenTabUpProduct")
    			app.load("client.packs.hero.SmRoleStrengthenTabUpgrade")
    			app.load("client.packs.hero.SmRoleStrengthenTabRisingStar")
    			app.load("client.packs.hero.SmRoleStrengthenTabSkill")
    			app.load("client.packs.hero.SmRoleStrengthenTabFightingSpirit")
    			app.load("client.packs.hero.SmRoleStrengthenTabSpecialAttributes")
				app.load("client.formation.mega.MegaWindow")
				app.load("client.packs.EquipStorage.SmEquipmentQunenchingHandle")
				app.load("client.packs.EquipStorage.SmEquipmentQianghuaTab3Window1")
				app.load("client.packs.hero.SmRoleStrengthenTabFightSpirit")
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
                if instance._current_page == 10 then
                	state_machine.excute("formation_showOrHide_Text_role_fight", 0, {_datas = {isHide = true}})
               	else
               		state_machine.excute("formation_showOrHide_Text_role_fight", 0, {_datas = {isHide = false}})
                end
		    	if params._datas.m_index ~= nil then
		    		instance.m_equip_index = tonumber(params._datas.m_index)
		    		ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_13265"):setVisible(false)
				    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_line_qianghua"):setVisible(false)
				    ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_role_up_text"):setVisible(false)
		    		for i=1,6 do
						local Image_equ_props_hook = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_equ_props_hook_"..i)
						Image_equ_props_hook:setVisible(false)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_equ_props_hook_"..instance.m_equip_index):setVisible(true)
		    		if instance._current_page == 2 then
		    			state_machine.excute("sm_equipment_tab_up_product_change_ship",0,instance.equipInfo[tonumber(instance.m_equip_index)])
		    		elseif instance._current_page == 3 then
						state_machine.excute("sm_equipment_tab_awakening_change_ship",0,instance.equipInfo[tonumber(instance.m_equip_index)])
					elseif instance._current_page == 10 then
						-- 淬炼
		    			state_machine.excute("sm_equipment_qianghua_tab3_window1_change_ship",0,instance.equipInfo[tonumber(instance.m_equip_index)])
		    		else 
		    			instance._current_page = -1
		    			instance:changeSelectPage(params._datas._page)
		    		end
		    	else
		    		instance._current_page = -1
		    		instance:changeSelectPage(params._datas._page)
		    	end
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--绘制操作成功后的特效
        local sm_role_formation_strengthen_tab_play_control_effect_terminal = {
            _name = "sm_role_formation_strengthen_tab_play_control_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
	                -- local Panel_sjdh_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_sjdh_2")
	                -- draw.createEffect("effice_digimon_qh", "images/ui/effice/effice_digimon_qh/effice_digimon_qh.ExportJson", Panel_sjdh_2, 1, 100)
					-- Panel_sjdh_2:removeAllChildren(true)
					-- local effice_digimon_qh = ccs.Armature:create("effice_digimon_qh")
					-- effice_digimon_qh:removeFromParent(true)
					-- effice_digimon_qh:getAnimation():playWithIndex(0)
					-- Panel_sjdh_2:addChild(effice_digimon_qh,100)
					-- effice_digimon_qh:setPositionX((Panel_sjdh_2:getContentSize().width - effice_digimon_qh:getContentSize().width)/2+effice_digimon_qh:getContentSize().width/2)
					
					if instance._effice_digimon_qh == nil then
                        local Panel_sjdh_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_sjdh_2")
                        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_digimon_qh/effice_digimon_qh.ExportJson")
                        instance._effice_digimon_qh = ccs.Armature:create("effice_digimon_qh")
                        Panel_sjdh_2:addChild(instance._effice_digimon_qh)
                        instance._effice_digimon_qh:setPositionX((Panel_sjdh_2:getContentSize().width - instance._effice_digimon_qh:getContentSize().width)/2+instance._effice_digimon_qh:getContentSize().width/2)
                        -- instance._effice_digimon_qh:setPosition(cc.p(Panel_sjdh_2:getContentSize().width / 2, Panel_sjdh_2:getContentSize().height / 2))
                    end
                    local function changeActionCallback( armatureBack ) 
                        if armatureBack ~= nil and armatureBack:getParent() ~= nil then
	                    	armatureBack:setVisible(false)
	                    end
                    end
                    instance._effice_digimon_qh:setVisible(true)
                    instance._effice_digimon_qh._invoke = changeActionCallback
                    instance._effice_digimon_qh._actionIndex = 0
                    instance._effice_digimon_qh:getAnimation():playWithIndex(0)
				end
                local shipInfo = _ED.user_ship[""..instance.ship.ship_id]
                if shipInfo == nil then
                    return
                end
                shipInfo = getShipByTalent(shipInfo)
                --战力
               	local Text_role_fight = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_role_fight")
				Text_role_fight:setString(shipInfo.hero_fight)
				--等级 
				local Text_3_5 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_3_5")
				Text_3_5:setString(shipInfo.ship_grade)
                --攻击
                local Text_3_6 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_3_6")
                Text_3_6:setString(shipInfo.ship_courage)
                --生命
                local Text_3_7 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_3_7")
                Text_3_7:setString(shipInfo.ship_health)
                --防御
                local Text_3_8 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_3_8")
                Text_3_8:setString(shipInfo.ship_intellect)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 是否隐藏战力
		local formation_showOrHide_Text_role_fight_terminal = {
		    _name = "formation_showOrHide_Text_role_fight",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	local root = instance.roots[1]
		    	if root then
		    		local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
			    	if params._datas.isHide == true then
			    		Panel_1:setVisible(false)
			    	else
			    		Panel_1:setVisible(true)
			    	end

		    	end

		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		-- 神兽技能配置
		local formation_open_animal_skill_ui_terminal = {
			_name = "formation_open_animal_skill_ui",
			_init = function (terminal)
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkill")
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillIconCell")
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillTip")
				app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillTipCell")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_skill_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(formation_hero_wear_click_terminal)
		state_machine.add(formation_page_formation_change_terminal)
		state_machine.add(formation_change_to_ship_page_view_terminal)
		state_machine.add(open_add_ship_window_terminal)
		state_machine.add(open_add_ship_equip_window_terminal)
		state_machine.add(open_add_partner_ship_window_terminal)
		state_machine.add(open_ship_current_equip_window_terminal)
		state_machine.add(response_fate_effect_terminal)
		state_machine.add(response_fate_effect_return_terminal)
		state_machine.add(current_ship_equip_wear_request_terminal)
		state_machine.add(choice_hero_battle_request_terminal)
		state_machine.add(replacement_battle_hero_request_terminal)
		state_machine.add(replacement_or_unload_ship_equip_wear_request_terminal)
		state_machine.add(open_replacement_ship_equip_window_terminal)
		state_machine.add(choice_hero_partners_request_terminal)
		state_machine.add(formation_cell_on_show_terminal)
		state_machine.add(formation_cell_on_hide_terminal)
		state_machine.add(formation_show_strengthen_master_terminal)
		state_machine.add(formation_property_change_tip_info_terminal)
		state_machine.add(formation_property_change_by_level_up_terminal)
		state_machine.add(formation_property_change_before_terminal)
		state_machine.add(formation_property_change_equip_info_terminal)
		state_machine.add(formation_other_interface_reset_terminal)
		state_machine.add(formation_go_to_hero_awaken_terminal)
		state_machine.add(formation_go_to_mega_terminal)
		
		
		state_machine.add(formation_back_to_home_page_terminal)
		state_machine.add(formation_click_hero_Level_up_page_terminal)
		state_machine.add(formation_hero_info_change_terminal)
		state_machine.add(formation_hero_cell_index_update_terminal)
		state_machine.add(formation_hero_partners_show_or_hidden_terminal)
		state_machine.add(formation_go_to_hero_herodevelop_terminal)
		state_machine.add(formation_go_to_change_pack_terminal)
		state_machine.add(formation_update_skill_icon_terminal)
		state_machine.add(formation_update_all_hero_terminal)
		state_machine.add(formation_go_to_hero_reloship_terminal)
		state_machine.add(formation_play_equip_show_terminal)
		state_machine.add(formation_play_equip_hide_terminal)
		state_machine.add(formation_turn_page_terminal)
		state_machine.add(formation_set_type_terminal)
		state_machine.add(formation_sort_and_get_index_terminal)
		state_machine.add(formation_to_one_key_equipment_terminal)
		state_machine.add(formation_set_ship_terminal)
		state_machine.add(formation_update_ship_info_terminal)
		state_machine.add(formation_hero_develop_play_hero_animation_terminal)
		state_machine.add(formation_go_to_hero_evolution_terminal)
		state_machine.add(formation_go_to_hero_data_info_terminal)
		state_machine.add(formation_change_hero_sprite_info_left_terminal)
		state_machine.add(formation_change_hero_sprite_info_right_terminal)
		state_machine.add(formation_change_hero_sprite_info_play_animation_terminal)
		state_machine.add(formation_update_equip_icon_push_terminal)
		state_machine.add(formation_switch_paging_information_terminal)
		state_machine.add(formation_back_to_home_activity_terminal)
		state_machine.add(formation_page_teshu_formation_change_terminal)
		state_machine.add(sm_role_formation_strengthen_tab_play_control_effect_terminal)
		state_machine.add(formation_go_to_open_rebrith_terminal)
		state_machine.add(formation_go_to_open_fashion_terminal)
		state_machine.add(formation_go_to_open_energy_terminal)
		state_machine.add(formation_showOrHide_Text_role_fight_terminal)
		state_machine.add(formation_go_to_open_matrix_terminal)
		
		state_machine.add(formation_open_animal_skill_ui_terminal)

		state_machine.init()
	end 

	init_formation_terminal()
end

function FormationTigerGate:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_xinxi = ccui.Helper:seekWidgetByName(root, "Panel_xinxi")

    state_machine.excute("formation_showOrHide_Text_role_fight", 0, {_datas = {isHide = false}})

    local Panel_packs_props = ccui.Helper:seekWidgetByName(root, "Panel_equ_tab")
    local Button_zhenrong = ccui.Helper:seekWidgetByName(root, "Button_zhenrong")
    local Button_line_shengji = ccui.Helper:seekWidgetByName(root, "Button_line_shengji")    --进阶
    local Button_line_tupo = ccui.Helper:seekWidgetByName(root, "Button_line_tupo")    --升级
    local Button_line_peiyang = ccui.Helper:seekWidgetByName(root, "Button_line_peiyang")    --升星
    local Button_line_tianming = ccui.Helper:seekWidgetByName(root, "Button_line_tianming")    --技能
    local Button_line_douhun = ccui.Helper:seekWidgetByName(root, "Button_line_douhun")    --斗魂
    local Button_line_chaojinhua = ccui.Helper:seekWidgetByName(root, "Button_line_chaojinhua")    --超进化
	local Button_line_zhanhun = ccui.Helper:seekWidgetByName(root, "Button_line_zhanhun")    --战魂

    if page == self._current_page then
        if page == 1 then
            Button_zhenrong:setHighlighted(true)
            ccui.Helper:seekWidgetByName(root, "Panel_13265"):setVisible(true)
	    	ccui.Helper:seekWidgetByName(root, "Button_line_qianghua"):setVisible(true)
	    	ccui.Helper:seekWidgetByName(root, "Panel_role_up_text"):setVisible(true)
	    	for i=1,6 do
				local Image_equ_props_hook = ccui.Helper:seekWidgetByName(root, "Image_equ_props_hook_"..i)
				Image_equ_props_hook:setVisible(false)
			end
        elseif page == 4 then
        	Button_line_shengji:setHighlighted(true)
        elseif page == 5 then
        	Button_line_tupo:setHighlighted(true)
        elseif page == 6 then
        	Button_line_peiyang:setHighlighted(true)
        elseif page == 7 then
        	Button_line_tianming:setHighlighted(true)
        elseif page == 8 then
        	Button_line_douhun:setHighlighted(true)
        elseif page == 9 then
			Button_line_chaojinhua:setHighlighted(true)	
		elseif page == 10 then
			Button_line_zhanhun:setHighlighted(true)	
        end
        return
    end

    if page == 2 then
    	if self.m_equip_index < 5 then
            if funOpenDrawTip(96) == true then
                return
            end
        else
            if funOpenDrawTip(159) == true then
                return
            end
        end
    end
    if page == 3 then 
    	if funOpenDrawTip(99) == true then
            return
        end
    end

    if page == 4 then
    	if funOpenDrawTip(100) == true then
            return
        end
    end

    if page == 5 then
    	if funOpenDrawTip(101) == true then
            return
        end
    end

    if page == 6 then
    	if funOpenDrawTip(102) == true then
            return
        end
    end

    if page == 7 then
    	if funOpenDrawTip(103) == true then
            return
        end
    end

    if page == 8 then
    	if funOpenDrawTip(104) == true then
            return
        end
	end
	
	if page == 10 then 
		if funOpenDrawTip(201) == true then
            return
        end
	end

    self._current_page = page
    Button_zhenrong:setHighlighted(false)
	
    if Button_line_shengji ~= nil then
	    Button_line_shengji:setHighlighted(false)
	end
	if Button_line_tupo ~= nil then
	    Button_line_tupo:setHighlighted(false)
	end
	if Button_line_peiyang ~= nil then
	    Button_line_peiyang:setHighlighted(false)
	end
	if Button_line_tianming ~= nil then
	    Button_line_tianming:setHighlighted(false)
	end
	if Button_line_douhun ~= nil then
	    Button_line_douhun:setHighlighted(false)
	end
	if Button_line_chaojinhua ~= nil then
	    Button_line_chaojinhua:setHighlighted(false)
	end
	if Button_line_zhanhun ~= nil then
	    Button_line_zhanhun:setHighlighted(false)
	end

    ccui.Helper:seekWidgetByName(root, "Panel_13265"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Button_line_qianghua"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Panel_role_up_text"):setVisible(false)
    for i=1,6 do
		local Image_equ_props_hook = ccui.Helper:seekWidgetByName(root, "Image_equ_props_hook_"..i)
		Image_equ_props_hook:setVisible(false)
	end
    -- state_machine.excute("sm_equipment_tab_up_product_hide", 0, nil)
	-- state_machine.excute("sm_equipment_tab_awakening_hide", 0, nil)
	-- 淬炼
	-- state_machine.excute("sm_equipment_qianghua_tab3_window1_hide", 0, nil)
    -- state_machine.excute("sm_role_strengthen_tab_up_product_hide", 0, nil)
    state_machine.excute("sm_role_strengthen_tab_up_grade_hide", 0, nil)
    state_machine.excute("sm_role_strengthen_tab_up_product_hide", 0, nil)
    state_machine.excute("sm_role_strengthen_tab_up_grade_hide", 0, nil)
    -- state_machine.excute("sm_role_strengthen_tab_rising_star_hide", 0, nil)
    fwin:close(fwin:find("SmRoleStrengthenTabRisingStarClass"))
	state_machine.excute("sm_role_strengthen_tab_skill_hide", 0, nil)
	-- 斗魂
	state_machine.excute("sm_role_strengthen_tab_fighting_spirit_hide", 0, nil)
	--战魂
	state_machine.excute("sm_role_strengthen_tab_fight_spirit_hide", 0, nil)
    --隐藏特别的属性界面
    state_machine.excute("sm_role_strengthen_tab_special_attributes_hide", 0, nil)

    if _ED.mega_info  then
		self:updateDrawShipInfo()
	end
    if page == 1 then
        Panel_xinxi:setVisible(true)
        state_machine.excute("mega_window_close",0,nil)
        Button_zhenrong:setHighlighted(true)
        Button_zhenrong:setTouchEnabled(false)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end
		
		ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_13265"):setVisible(true)
    	ccui.Helper:seekWidgetByName(root, "Button_line_qianghua"):setVisible(true)
    	ccui.Helper:seekWidgetByName(root, "Panel_role_up_text"):setVisible(true)

    	if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
	        protocol_command.education_change.param_list = "520"
	        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
	            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
	        end
	    end
	elseif page == 2 then
		Panel_xinxi:setVisible(true)
		state_machine.excute("mega_window_close",0,nil)
        Button_zhenrong:setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end
    	
		if self._equip == nil then
            self._equip = state_machine.excute("sm_equipment_tab_up_product_open", 0, {Panel_packs_props})
        else
        	if fwin:find("SmEquipmentTabUpProductClass") ~= nil then
	            state_machine.excute("sm_equipment_tab_up_product_display", 0, nil)
	        else
	        	self._equip = nil
	        	self._equip = state_machine.excute("sm_equipment_tab_up_product_open", 0, {Panel_packs_props})
	        end
        end
        ccui.Helper:seekWidgetByName(root, "Image_equ_props_hook_"..self.m_equip_index):setVisible(true)
        state_machine.excute("sm_equipment_tab_up_product_change_ship",0,self.equipInfo[tonumber(self.m_equip_index)])
		
		if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
	        protocol_command.education_change.param_list = "527"
	        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
	            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
	        end
	    end
	elseif page == 3 then
		Panel_xinxi:setVisible(true)
		state_machine.excute("mega_window_close",0,nil)
		ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
        Button_zhenrong:setTouchEnabled(true)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end
        if self._material == nil then
            self._material = state_machine.excute("sm_equipment_tab_awakening_open", 0, {Panel_packs_props})
        else
        	if fwin:find("SmEquipmentTabAwakeningClass") ~= nil then
	            state_machine.excute("sm_equipment_tab_awakening_display", 0, nil)
	        else
	        	self._material = nil
	        	self._material = state_machine.excute("sm_equipment_tab_awakening_open", 0, {Panel_packs_props})
	        end
        end
		ccui.Helper:seekWidgetByName(root, "Image_equ_props_hook_"..self.m_equip_index):setVisible(true)
        state_machine.excute("sm_equipment_tab_awakening_change_ship",0,self.equipInfo[tonumber(self.m_equip_index)])
    	
    	if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
	        protocol_command.education_change.param_list = "528"
	        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
	            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
	        end
	    end

    elseif page == 4 then
    	Panel_xinxi:setVisible(true)
    	state_machine.excute("mega_window_close",0,nil)
    	ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
    	Button_line_shengji:setHighlighted(true)
        Button_zhenrong:setTouchEnabled(true)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(false)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end
	    --特殊界面添加
	    if self.ship_special == nil then
	    	self.ship_special = state_machine.excute("sm_role_strengthen_tab_special_attributes_open",0,{Panel_packs_props,self.ship.ship_id})
	    else
	    	if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
		    	state_machine.excute("sm_role_strengthen_tab_special_attributes_display",0,"")
		    else
		    	self.ship_shengji =state_machine.excute("sm_role_strengthen_tab_special_attributes_open",0,{Panel_packs_props,self.ship.ship_id})
		    end
	    end

	    if self.ship_shengji == nil then
	    	fwin:close(fwin:find("SmRoleStrengthenTabUpProductClass"))
	    	self.ship_shengji = state_machine.excute("sm_role_strengthen_tab_up_product_open",0,{Panel_packs_props,self.ship.ship_id})
	    else
	    	if fwin:find("SmRoleStrengthenTabUpProductClass") ~= nil then
		    	state_machine.excute("sm_role_strengthen_tab_up_product_display",0,"")
		    else
		    	self.ship_shengji = state_machine.excute("sm_role_strengthen_tab_up_product_open",0,{Panel_packs_props,self.ship.ship_id})
		    end
	    end

	    if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
	        protocol_command.education_change.param_list = "522"
	        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
	            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
	        end
	    end

    elseif page == 5 then
    	Panel_xinxi:setVisible(true)
    	state_machine.excute("mega_window_close",0,nil)
    	ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
    	Button_line_tupo:setHighlighted(true)
        Button_zhenrong:setTouchEnabled(true)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(false)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end
	    --特殊界面添加
	    if self.ship_special == nil then
	    	self.ship_special = state_machine.excute("sm_role_strengthen_tab_special_attributes_open",0,{Panel_packs_props,self.ship.ship_id})
	    else
	    	if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
		    	state_machine.excute("sm_role_strengthen_tab_special_attributes_display",0,"")
		    else
		    	self.ship_shengji =state_machine.excute("sm_role_strengthen_tab_special_attributes_open",0,{Panel_packs_props,self.ship.ship_id})
		    end
	    end
	    self.ship_shengji = nil

	    if self.ship_tupo == nil then
	    	fwin:close(fwin:find("SmRoleStrengthenTabUpgradeClass"))
	    	self.ship_tupo = state_machine.excute("sm_role_strengthen_tab_up_grade_open",0,{Panel_packs_props,self.ship.ship_id})
	    else
	    	if fwin:find("SmRoleStrengthenTabUpgradeClass") ~= nil then
		    	state_machine.excute("sm_role_strengthen_tab_up_grade_display",0,"")
		    else
		    	self.ship_tupo = state_machine.excute("sm_role_strengthen_tab_up_grade_open",0,{Panel_packs_props,self.ship.ship_id})
		    end
	    end

	    if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
	        protocol_command.education_change.param_list = "525"
	        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
	            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
	        end
	    end
	    
    elseif page == 6 then
    	Panel_xinxi:setVisible(true)
    	state_machine.excute("mega_window_close",0,nil)
    	ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
    	Button_line_peiyang:setHighlighted(true)
        Button_zhenrong:setTouchEnabled(true)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(false)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end
	    if self.ship_peiyang == nil then
	    	state_machine.excute("sm_role_strengthen_tab_rising_star_open",0,{Panel_packs_props,self.ship.ship_id,self.ship.ship_template_id})
	    else
	    	if fwin:find("SmRoleStrengthenTabRisingStarClass") ~= nil then
		    	state_machine.excute("sm_role_strengthen_tab_rising_star_display",0,"")
		    else
		    	state_machine.excute("sm_role_strengthen_tab_rising_star_open",0,{Panel_packs_props,self.ship.ship_id})
		    end
	    end

	   	if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
	        protocol_command.education_change.param_list = "523"
	        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
	            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
	        end
	    end
    elseif page == 7 then
    	Panel_xinxi:setVisible(true)
    	state_machine.excute("mega_window_close",0,nil)
    	ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
    	Button_line_tianming:setHighlighted(true)
        Button_zhenrong:setTouchEnabled(true)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(false)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end
	    if self.ship_tianming == nil then
	    	fwin:close(fwin:find("SmRoleStrengthenTabSkillClass"))
	    	self.ship_tianming = state_machine.excute("sm_role_strengthen_tab_skill_open",0,{Panel_packs_props,self.ship.ship_id})
	    else
	    	if fwin:find("SmRoleStrengthenTabSkillClass") ~= nil then
		    	state_machine.excute("sm_role_strengthen_tab_skill_display",0,"")
		    else
		    	self.ship_tianming = state_machine.excute("sm_role_strengthen_tab_skill_open",0,{Panel_packs_props,self.ship.ship_id})
		    end
	    end

	   	if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
	        protocol_command.education_change.param_list = "524"
	        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
	            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
	        end
	    end
    elseif page == 8 then
    	Panel_xinxi:setVisible(true)
    	state_machine.excute("mega_window_close",0,nil)
    	ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
    	Button_line_douhun:setHighlighted(true)
        Button_zhenrong:setTouchEnabled(true)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(false)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end
	    if self.ship_douhun == nil then
	    	fwin:close(fwin:find("SmRoleStrengthenTabFightingSpiritClass"))
	    	self.ship_douhun = state_machine.excute("sm_role_strengthen_tab_fighting_spirit_open",0,{Panel_packs_props,self.ship.ship_id})
	    else
	    	if fwin:find("SmRoleStrengthenTabFightingSpiritClass") ~= nil then
		    	state_machine.excute("sm_role_strengthen_tab_fighting_spirit_display",0,"")
		    else
		    	self.ship_douhun = state_machine.excute("sm_role_strengthen_tab_fighting_spirit_open",0,{Panel_packs_props,self.ship.ship_id})
		    end
	    end

	   	if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
	        protocol_command.education_change.param_list = "526"
	        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
	            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
	        end
	    end
    elseif page == 9 then
    	Panel_xinxi:setVisible(false)
    	ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
    	if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(false)
		end
    	Button_line_chaojinhua:setHighlighted(true)
        Button_zhenrong:setTouchEnabled(true)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(true)
		end

		state_machine.excute("megapreview_close",0,nil)
		state_machine.excute("mega_window_close",0,nil)
		state_machine.excute("mega_window_open",0,{self.ship})
	elseif page == 10 then
		-- 战魂隐藏战力显示
		state_machine.excute("formation_showOrHide_Text_role_fight", 0, {_datas = {isHide = true}})
		
		Panel_xinxi:setVisible(true)
    	state_machine.excute("mega_window_close",0,nil)
    	ccui.Helper:seekWidgetByName(root, "Panel_anniu"):setVisible(false)
    	if Button_line_zhanhun ~= nil then
		    Button_line_zhanhun:setTouchEnabled(false)
		end
    	Button_line_zhanhun:setHighlighted(true)
        Button_zhenrong:setTouchEnabled(true)
        if Button_line_shengji ~= nil then
	        Button_line_shengji:setTouchEnabled(true)
	    end
	    if Button_line_tupo ~= nil then
		    Button_line_tupo:setTouchEnabled(true)
		end
		if Button_line_peiyang ~= nil then
		    Button_line_peiyang:setTouchEnabled(true)
		end
		if Button_line_tianming ~= nil then
		    Button_line_tianming:setTouchEnabled(true)
		end
		if Button_line_douhun ~= nil then
		    Button_line_douhun:setTouchEnabled(true)
		end
		if Button_line_chaojinhua ~= nil then
		    Button_line_chaojinhua:setTouchEnabled(true)
		end

		if self.fight_spirit == nil then
			local _homeWindow = fwin:find("SmRoleStrengthenTabFightSpiritClass")
			if nil ~= _homeWindow then
				fwin:close(fwin:find("SmRoleStrengthenTabFightSpiritClass"))
			end
			self.fight_spirit = state_machine.excute("sm_role_strengthen_tab_fight_spirit_open",0,{Panel_packs_props,self.ship.ship_id})
		else
			if fwin:find("SmRoleStrengthenTabFightSpiritClass") ~= nil then
		    	state_machine.excute("sm_role_strengthen_tab_fight_spirit_display",0,"")
		    else
		    	self.fight_spirit = state_machine.excute("sm_role_strengthen_tab_fight_spirit_open",0,{Panel_packs_props,self.ship.ship_id})
		    end
	    end
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_formation")
	    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equip_upgrade")
	    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equip_awake")
	 --   state_machine.excute("notification_center_update",0,"push_notification_center_formation_mega")
	    
	    state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_evolution_page_tip")
	    state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_up_grade_star_page_tip")
	    if fwin:find("HeroStorageClass") ~= nil then
	    	state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_upgrade")
	    	state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_awake")
		end
		-- 装备淬炼推送
		state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_harden_page_tips") 
	end
end

function FormationTigerGate:turnPage(types)
	if types == "left" then
		if self.heroindex == 1 then
			self.heroindex = self.heronumber
		else
			self.heroindex = self.heroindex - 1
		end
		self.ship = self.sortedHeroes[self.heroindex]
	elseif types == "right" then
		if self.heroindex == self.heronumber then
			self.heroindex = 1
		else
			self.heroindex = self.heroindex + 1
		end
		self.ship = self.sortedHeroes[self.heroindex]
	end
	state_machine.excute("formation_hero_info_change",0,{self.ship.ship_id})
end
function FormationTigerGate:gotoGetRelation(name)
	local shipmouldId = nil
	local isUser = false
	if tonumber(self.ship.captain_type) == 0 then
		shipmouldId =  self.ship.ship_template_id
		isUser = true
	else
		shipmouldId =  self.ship.ship_base_template_id
	end
	local fate_relationship_mould_id = dms.string(dms["ship_mould"], shipmouldId, ship_mould.relationship_id)
	local data = zstring.zsplit(fate_relationship_mould_id,",")
	local skill_name = nil
	local ship_temp = nil
	app.load("client.packs.hero.HeroPatchInformationPageGetWay")
	for i, v in pairs(data) do
		skill_name = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local name_datas = dms.element(dms["word_mould"], zstring.tonumber(skill_name))
			skill_name = name_datas[3]
		end
		if skill_name == name then
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need1_type) == 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need1)
				if str > 0 and tonumber(str) ~= tonumber(shipmouldId) then
	  				local temp = nil
	  				if isUser == false then
	  					temp = fundShipWidthBaseTemplateId(str)
	  				else
	  					temp = fundShipWidthTemplateId(str)
	  				end
	  				if temp == nil then
		  				local cell = HeroPatchInformationPageGetWay:createCell()
		  				cell:init(str)
		 				fwin:open(cell, fwin._windows)
		 				return
		 			else
		 				if ship_temp == nil then
		 					ship_temp = str
		 				end
		 			end
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need2_type) == 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need2)
				if str > 0 and tonumber(str) ~= tonumber(shipmouldId) then
	  				local temp = nil
	  				if isUser == false then
	  					temp = fundShipWidthBaseTemplateId(str)
	  				else
	  					temp = fundShipWidthTemplateId(str)
	  				end
	  				if temp == nil then
		  				local cell = HeroPatchInformationPageGetWay:createCell()
		  				cell:init(str)
		 				fwin:open(cell, fwin._windows)
		 				return
		 			else
		 				if ship_temp == nil then
		 					ship_temp = str
		 				end		
		 			end	
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need3_type) == 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need3)
				if str > 0 and tonumber(str) ~= tonumber(shipmouldId) then
	  				local temp = nil
	  				if isUser == false then
	  					temp = fundShipWidthBaseTemplateId(str)
	  				else
	  					temp = fundShipWidthTemplateId(str)
	  				end
	  				if temp == nil then
		  				local cell = HeroPatchInformationPageGetWay:createCell()
		  				cell:init(str)
		 				fwin:open(cell, fwin._windows)
		 				return
		 			else
		 				if ship_temp == nil then
		 					ship_temp = str
		 				end			 				
		 			end	
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need4_type) == 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need4)
				if str > 0 and tonumber(str) ~= tonumber(shipmouldId) then
	  				local temp = nil
	  				if isUser == false then
	  					temp = fundShipWidthBaseTemplateId(str)
	  				else
	  					temp = fundShipWidthTemplateId(str)
	  				end
	  				if temp == nil then
		  				local cell = HeroPatchInformationPageGetWay:createCell()
		  				cell:init(str)
		 				fwin:open(cell, fwin._windows)
		 				return
		 			else
		 				if ship_temp == nil then
		 					ship_temp = str
		 				end			 				
		 			end	
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need5_type) == 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need5)
				if str > 0 and tonumber(str) ~= tonumber(shipmouldId) then
	  				local temp = nil
	  				if isUser == false then
	  					temp = fundShipWidthBaseTemplateId(str)
	  				else
	  					temp = fundShipWidthTemplateId(str)
	  				end
	  				if temp == nil then
		  				local cell = HeroPatchInformationPageGetWay:createCell()
		  				cell:init(str)
		 				fwin:open(cell, fwin._windows)
		 				return
		 			else
		 				if ship_temp == nil then
		 					ship_temp = str
		 				end			 				
		 			end	
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need6_type) == 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need6)
				if str > 0 and tonumber(str) ~= tonumber(shipmouldId) then
	  				local temp = nil
	  				if isUser == false then
	  					temp = fundShipWidthBaseTemplateId(str)
	  				else
	  					temp = fundShipWidthTemplateId(str)
	  				end
	  				if temp == nil then
		  				local cell = HeroPatchInformationPageGetWay:createCell()
		  				cell:init(str)
		 				fwin:open(cell, fwin._windows)
		 				return
		 			else
		 				if ship_temp == nil then
		 					ship_temp = str
		 				end			 				
		 			end	
				end
			end
		end
	end

	for i, v in pairs(data) do
		skill_name = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local name_datas = dms.element(dms["word_mould"], zstring.tonumber(skill_name))
			skill_name = name_datas[3]
		end
		if skill_name == name then
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need1_type) > 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need1)
				if str > 0 then	
					local cell = HeroPatchInformationPageGetWay:createCell()
	  				cell:init(str,1)
	 				fwin:open(cell, fwin._windows)
	 				return	 				
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need2_type) > 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need2)
				if str > 0 then
					local cell = HeroPatchInformationPageGetWay:createCell()
	  				cell:init(str,1)
	 				fwin:open(cell, fwin._windows)
	 				return
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need3_type) > 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need3)
				if str > 0 then
	  				local cell = HeroPatchInformationPageGetWay:createCell()
	  				cell:init(str,1)
	 				fwin:open(cell, fwin._windows)
	 				return
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need4_type) > 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need4)
				if str > 0 then
	  				local cell = HeroPatchInformationPageGetWay:createCell()
	  				cell:init(str,1)
	 				fwin:open(cell, fwin._windows)
	 				return
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need5_type) > 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need5)
				if str > 0 then
	  				local cell = HeroPatchInformationPageGetWay:createCell()
	  				cell:init(str,1)
	 				fwin:open(cell, fwin._windows)
	 				return
				end
			end
			if dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need6_type) > 0 then
				local str = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_need6)
				if str > 0 then
	  				local cell = HeroPatchInformationPageGetWay:createCell()
	  				cell:init(str,1)
	 				fwin:open(cell, fwin._windows)
	 				return
				end
			end
		end
	end

	if ship_temp ~= nil then
		local cell = HeroPatchInformationPageGetWay:createCell()
		cell:init(ship_temp)
		fwin:open(cell, fwin._windows)
	end	
end
function FormationTigerGate:init(ship)
	self.ship = ship
	if self.ship ~= nil then
		self.masterStrengthenlv[1],self.masterStrengthenlv[2],self.masterStrengthenlv[3],self.masterStrengthenlv[4] = self:Mason(self.ship.ship_id)
	end
end

function FormationTigerGate:createShipHead(ship,objectType)
	local cell = ShipIconCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function FormationTigerGate:createShipHeadIcon(ship,objectType)
	local cell = ShipHeadCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function FormationTigerGate:createEquipHead(objectType,ship)
	local cell = EquipIconCell:createCell()
	if tonumber(ship.m_index) > 4 then
		if funOpenDrawTip(159, false) == true then
			ship.isShowLv = false
		end
	else
		if funOpenDrawTip(96, false) == true then
			ship.isShowLv = false
		end
	end
	cell:init(objectType,ship)
	return cell
end

function FormationTigerGate:createLockAction(objectType,data)
	local cell = FormationLockActionCell:createCell()	
	cell:init(objectType,data)
	return cell
end

function FormationTigerGate:createAddActionCell(objectType,data,tipsType)
	local cell = AddActionCellCell:createCell()
	cell:init(objectType,data,tipsType)
	return cell
end

function FormationTigerGate:createAddandLockCell(objectType,data, num)
	local cell = AddAndLockCell:createCell()
	cell:init(objectType,data,num)
	return cell
end

function FormationTigerGate:createShipPartnerPlace(objectType)
	local cell = FormationPartnerPlaceCell:createCell()
	cell:init(objectType)
	return cell
end

function FormationTigerGate:createPartnerScroll(objectType)
	local cell = FormationPartnerInfoListCell:createCell()
	cell:init(objectType)
	return cell
end

function FormationTigerGate:openHeroDevelop()
	app.load("client.packs.hero.HeroDevelop")
	if fwin:find("HeroDevelopClass") ~= nil then
		state_machine.excute("formation_set_ship",0,self.ship)
		return
		-- fwin:close(fwin:find("HeroDevelopClass"))
	end
	local heroDevelopWindow = HeroDevelop:new()
	if self.ship == -1 then
		self.ship = _ED.user_ship[_ED.user_formetion_status[1]]
		enter_type = "learn"
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self.ship.shengming = zstring.tonumber(self.ship.ship_health)
		self.ship.gongji = zstring.tonumber(self.ship.ship_courage)
		self.ship.waigong = zstring.tonumber(self.ship.ship_intellect)
		self.ship.neigong = zstring.tonumber(self.ship.ship_quick)
	end
	
	if enter_type ~= "learn" and enter_type ~= "pack" then
		enter_type = "formation"
	end
	for i,v in pairs(_ED.user_formetion_status) do
		if zstring.tonumber(v) == tonumber(self.ship.ship_id) then
			enter_type = "formation"
		end
	end

	g_formationTigerGate:setVisible(false)
	fwin:find("HeroIconListViewClass"):setVisible(false)
	heroDevelopWindow:init(self.ship.ship_id, enter_type)
	fwin:open(heroDevelopWindow, fwin._viewdialog)
	if __lua_project_id == __lua_project_l_naruto then
		fwin:close(fwin:find("FormationTigerGateClass"))
		fwin:close(fwin:find("HeroIconListViewClass"))
	end
end

function FormationTigerGate:changeSelectHeroInfo()
	for k,v in pairs(self._dataCell) do
		if v ~= nil and v.roots ~= nil and v.roots[1] ~= nil and v.choose ~= nil then
			v.choose:setVisible(false)
		end
	end
	-- if self._current_cell ~= nil and self._current_cell.choose ~= nil then
		-- self:init(self._current_cell.ship)
		-- self._current_cell.choose:setVisible(true)
		self:updateDrawShipInfo()
		self:updateDrawEquipments()
		-- self:checkHaveRoleAnimation()
		self:drawShipPageView()
		self:updateCamper()
		local root = self.roots[1]
		if root == nil then 
			return
		end
		local jxPanel = ccui.Helper:seekWidgetByName(root, "juexing_rukou")
		jxPanel:setVisible(false)

		if self.ship ~= nil then
			local ship_template_id = self.ship.ship_template_id
			local captain_type =  dms.int(dms["ship_mould"], ship_template_id, ship_mould.captain_type)
			local requirement = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould2) --能否觉醒
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				jxPanel:setVisible(true)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				else
					local awakenLevel = self.ship.awakenLevel -- 觉醒等级
					local start = math.floor(awakenLevel/10)
					local level = math.floor(awakenLevel%10)
					for i=1,6 do
						local index = i -1
						local starImage = ccui.Helper:seekWidgetByName(root,"juexingxing_"..index )
						starImage:setVisible(false)
						if i<= start then 
							starImage:setVisible(true)
						end
					end
				end
			else
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				else
					if tonumber(captain_type) ~= 0 and requirement == -1 then
						--不能觉醒
						jxPanel:setVisible(false)
					else
						jxPanel:setVisible(true)
						local awakenLevel = self.ship.awakenLevel -- 觉醒等级
						local start = math.floor(awakenLevel/10)
						local level = math.floor(awakenLevel%10)
						for i=1,6 do
							local index = i -1
							local starImage = ccui.Helper:seekWidgetByName(root,"juexingxing_"..index )
							starImage:setVisible(false)
							if i<= start then 
								starImage:setVisible(true)
							end
						end

					end
				end
			end
		end
	-- end
end

function FormationTigerGate:updateCamper()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		return
	end
	local Panel_zhenyin = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_zhenyin")
	if self.ship == nil then
		Panel_zhenyin:setVisible(false)
		return
	end
	local camp = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.camp_preference)
	if camp == 0 then
		Panel_zhenyin:setVisible(false)
	else
		Panel_zhenyin:setVisible(true)
		Panel_zhenyin:removeBackGroundImage()
		Panel_zhenyin:setBackGroundImage(string.format("images/ui/quality/leixing_%d.png", camp))
	end

end
-- 检测缓存上阵的角色动画
function FormationTigerGate:checkHaveRoleAnimation()
	local roleAnimationLayer = nil
	local findIndex = 0
	for k,v in pairs(self.roleAnimations) do
		if v ~= nil then
			v:setVisible(false)
			if tonumber(k) == tonumber(self._current_cell._index) then
				roleAnimationLayer = v
			end
		end
	end
	if roleAnimationLayer == nil then
		local resultLayer = nil
		self:drawShipPageView()
		self.roleAnimations[""..self._current_cell._index] =  resultLayer
	else
		roleAnimationLayer:setVisible(true)
	end
end

--检测英雄是否可以觉醒
function FormationTigerGate:checkHeroCanAwaken()
	local ship_template_id = self.ship.ship_template_id
	local isOpen = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level) <= zstring.tonumber(self.ship.ship_grade)
	local ship_type =  dms.int(dms["ship_mould"], ship_template_id, ship_mould.ship_type)
	local captain_type =  dms.int(dms["ship_mould"], ship_template_id, ship_mould.captain_type)
	local requirement = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould2) --能否觉醒
	if isOpen == true then
	else
		TipDlg.drawTextDailog(_awaken_tipString_info[8])
		return false
	end
	if tonumber(captain_type) ~= 0 and requirement == -1 then
		TipDlg.drawTextDailog(_awaken_tipString_info[19])
		return
	end

	--计算是否满级
	local requirement = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould2)
	local grouds = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, requirement)
	local awaken_info = nil
	if grouds ~= nil then 
        for i, v in pairs(grouds) do
            if tonumber(v[3]) == tonumber(self.ship.awakenLevel) then
               awaken_info = v 
               break
            end
        end
	end
	if awaken_info ~= nil and zstring.tonumber(awaken_info[4]) == -1 then 
		--满级
		TipDlg.drawTextDailog(_awaken_tipString_info[10])
		return false
	else
		return true
	end
	return true
end

-- 移除下阵的角色动画
function FormationTigerGate:removeOffFormationRoleAni( index )
	if index == nil then
		return
	end
	local roleAnimationLayer = self.roleAnimations[""..index]
	if roleAnimationLayer ~= nil and roleAnimationLayer:getParent() ~= nil then
		roleAnimationLayer:removeFromParent(true)
	end
end

function FormationTigerGate:initFormationRoleAnimation( cell )
	if true then
		return
	end
	-- if cell.ship ~= nil then
		resultLayer = self:drawShipPageView(cell.ship)
		self.roleAnimations[""..cell._index] = resultLayer
		resultLayer:setVisible(false)
	-- end
end

function FormationTigerGate:Mason(shipId)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		return
	end
	local grade1 = nil		--装备强化
	local grade2 = nil		--装备精炼
	local grade3 = nil		--宝物强化
	local grade4 = nil		--宝物精炼
	local nums1 = nil
	local nums2 = nil
	local nums3 = nil
	local nums4 = nil
	local ship_equips = _ED.user_ship[shipId].equipment
	for i, v in pairs(ship_equips) do
		if i <= 4 then
			if grade1 == nil then
				grade1 = zstring.tonumber(v.user_equiment_grade)
			end
			if grade1 > zstring.tonumber(v.user_equiment_grade) then
				grade1 = zstring.tonumber(v.user_equiment_grade)
			end
			if grade2 == nil then
				grade2 = zstring.tonumber(v.equiment_refine_level)
			end
			if grade2 > zstring.tonumber(v.equiment_refine_level) then
				grade2 = zstring.tonumber(v.equiment_refine_level)
			end
		elseif i <= 6 and i > 4 then
			if v.user_equiment_grade ~= nil then
				if grade3 == nil then
					grade3 = zstring.tonumber(v.user_equiment_grade)
				end
				if grade3 > zstring.tonumber(v.user_equiment_grade) then
					grade3 = zstring.tonumber(v.user_equiment_grade)
				end
				if grade4 == nil then
					grade4 = zstring.tonumber(v.equiment_refine_level)
				end
				if grade4 > zstring.tonumber(v.equiment_refine_level) then
					grade4 = zstring.tonumber(v.equiment_refine_level)
				end
			end
		end
	end
	local strengthen_master_data1 = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 0)
	local strengthen_master_data2 = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 1)
	local strengthen_master_data3 = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 2)
	local strengthen_master_data4 = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 3)

	for i, v in ipairs(strengthen_master_data1) do
		local need_level = dms.atoi(v, strengthen_master_info.need_level)
		if zstring.tonumber(grade1) >= need_level then
			nums1 = dms.atoi(v, strengthen_master_info.master_level)
		end
	end
	
	for i, v in ipairs(strengthen_master_data2) do
		local need_level = dms.atoi(v, strengthen_master_info.need_level)
		if zstring.tonumber(grade2) >= need_level then
			nums2 = dms.atoi(v, strengthen_master_info.master_level)
		end
	end
	
	for i, v in ipairs(strengthen_master_data3) do
		local need_level = dms.atoi(v, strengthen_master_info.need_level)
		if zstring.tonumber(grade3) >= need_level then
			nums3 = dms.atoi(v, strengthen_master_info.master_level)
		end
	end
	
	for i, v in ipairs(strengthen_master_data4) do
		local need_level = dms.atoi(v, strengthen_master_info.need_level)
		if zstring.tonumber(grade4) >= need_level then
			nums4 = dms.atoi(v, strengthen_master_info.master_level)
		end
	end
	return nums1, nums2, nums3, nums4
end

-- 小伙伴上阵只激活缘分
function FormationTigerGate:activateLot(shipID)

	local textData = {}
	local ship_base_template_id = fundShipWidthId(""..shipID).ship_base_template_id
	
	local fettersNumber = 0
	local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], ship_base_template_id, ship_mould.relationship_id), ",")
	local inStates = {}
	local ter = 1
	local name = nil
	for i, v in pairs(_ED.user_ship) do
		if zstring.tonumber(v.formation_index) > 0 then
			if zstring.tonumber(v.ship_id) ~= zstring.tonumber(_ED.into_formation_ship_id) then
				inStates[ter] = v.ship_base_template_id
				ter = ter + 1
			end
		end
	end
	
	local getPersonName = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], ship_base_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
		local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[shipID])
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		getPersonName = word_info[3]
	else
		getPersonName = dms.string(dms["ship_mould"], ship_base_template_id, ship_mould.captain_name)
	end
	
	
	if myRelatioInfo ~= nil then
		for k,w in pairs(myRelatioInfo) do
			local num = 1
			local person = {}
			local shipName = {}
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) == 0 then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
					shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) == 0 then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
					shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) == 0 then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
					shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) == 0 then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
					shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) == 0 then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
					shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) == 0 then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
					shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
					num = num + 1
				end
			end
			
			local sss = 0
			for j,r in pairs(person) do
				for i, v in pairs(inStates) do
					if zstring.tonumber(r) == zstring.tonumber(v) then
						sss = sss + 1
						break
					end
				end
			end
			if table.getn(person)-1 == sss and table.getn(person) - 1 > 0 and sss > 0 then
				fettersNumber = fettersNumber + 1
				
				name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
					name = name_datas[3]
				end
				for i,v in pairs(shipName) do
					for j,k in pairs(_ED.user_ship) do
						if zstring.tonumber(k.little_partner_formation_index) <= 0 then
							if zstring.tonumber(k.ship_base_template_id) == person[i] then
								table.insert(textData, {nameOne = v, nameTwo = name})
								break
							end
						end
					end
				end
			end
		end
		app.load("client.cells.utils.property_change_tip_info_cell") 
		local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
		local str = ""
		tipInfo:init(1,str, textData)	
		fwin:open(tipInfo, fwin._view)
	end
end
-- 显示属性变更的提示信息
function FormationTigerGate:showPropertyChangeTipInfo(previousShip,types,temp,ker)
	-- 计算两次换将之后的属性差

	local ship_courage = 0
	local ship_health = 0
	local ship_intellect = 0
	local ship_quick = 0
	if zstring.tonumber(previousShip.ship_id) == -1 then
		ship_courage = zstring.tonumber(self.ship.ship_courage)
		ship_health = zstring.tonumber(self.ship.ship_health)
		ship_intellect = zstring.tonumber(self.ship.ship_intellect)
		ship_quick = zstring.tonumber(self.ship.ship_quick)
	else
		ship_courage = zstring.tonumber(self.ship.ship_courage) - zstring.tonumber(previousShip.ship_courage)
		ship_health = zstring.tonumber(self.ship.ship_health) - zstring.tonumber(previousShip.ship_health)
		ship_intellect = zstring.tonumber(self.ship.ship_intellect) - zstring.tonumber(previousShip.ship_intellect)
		ship_quick = zstring.tonumber(self.ship.ship_quick) - zstring.tonumber(previousShip.ship_quick)
			
	end
	
	
	if self.ship.gongji == ship_courage and self.ship.shengming == ship_health and self.ship.waigong == ship_intellect and  self.ship.neigong == ship_quick then
		self.ship.shengming = 0
		self.ship.gongji = 0
		self.ship.waigong = 0
		self.ship.neigong = 0			
		return
	end
	
	local textData = {}
	-----------------------强化大师的判断
	local shipId = previousShip.ship_id
				
	local equips_id = {}

	local tempShip = _ED.user_ship[shipId]
	local ship_equips = {}
	if tempShip ~= nil then
		ship_equips = _ED.user_ship[shipId].equipment
	end

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
	--------------------------------缘分激活提示(更换伙伴时触发)
	if ker == true then
		local fettersNumber = 0
		local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.relationship_id), ",")
		local inStates = {}
		local ter = 1
		local name = nil
		for i, v in pairs(_ED.user_ship) do
			if zstring.tonumber(v.formation_index) > 0 or zstring.tonumber(v.little_partner_formation_index) > 0 then
				if zstring.tonumber(v.ship_id) ~= zstring.tonumber(_ED.into_formation_ship_id) then
					inStates[ter] = v.ship_base_template_id
					ter = ter + 1
				end
			end
		end
		
		local getPersonName = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = smGetSkinEvoIdChange(self.ship)
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			getPersonName = word_info[3]
		else
			if tonumber(self.ship.captain_type) == 0 then
				getPersonName = _ED.user_info.user_name
			else
				getPersonName = dms.string(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.captain_name)
			end
		end
		
		if myRelatioInfo ~= nil then
			for k,w in pairs(myRelatioInfo) do
				local num = 1
				local person = {}
				local shipName = {}
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				
				local sss = 0
				for j,r in pairs(person) do
					for i, v in pairs(inStates) do
						if zstring.tonumber(r) == zstring.tonumber(v) then
							sss = sss + 1
							break
						end
					end
				end
				if table.getn(person)-1 == sss and table.getn(person) - 1 > 0 and sss > 0 then
					fettersNumber = fettersNumber + 1
					
					name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
						name = name_datas[3]
					end
					for i,v in pairs(shipName) do
						for j,k in pairs(_ED.user_ship) do
							if zstring.tonumber(k.little_partner_formation_index) <= 0 then
								if zstring.tonumber(k.ship_base_template_id) == person[i] then
										local myRelatioInfo2 = zstring.zsplit(dms.string(dms["ship_mould"], k.ship_base_template_id, ship_mould.relationship_id), ",")
										local shipHaveRela = false
										for i,v in pairs(myRelatioInfo2) do
											local name2 = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
											if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
												local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name2))
												name2 = name_datas[3]
											end
											if name2 == name then
												shipHaveRela = true
											end
										end
										if shipHaveRela == true then
											table.insert(textData, {nameOne = v, nameTwo = name})
										end
									break
								end
							end
						end
					end
				end
			end
			
			local item = 1
			local equip = {}
			for i, v in pairs (_ED.user_ship) do
				if zstring.tonumber(v.ship_id) == zstring.tonumber(_ED.into_formation_ship_id) then
					for j, k in pairs(v.equipment) do
						equip[item] = zstring.tonumber(k.user_equiment_template)
						item = item + 1
					end
				end
			end
			
			--装备缘分激活
			for k,w in pairs(myRelatioInfo) do
				local num = 1
				local relationEquip = {}
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
						num = num + 1
					end
				end
				
				local sss = 0
				for j,r in pairs(relationEquip) do
					for i, v in pairs(equip) do
						if zstring.tonumber(r) == zstring.tonumber(v) then
							sss = sss + 1
							break
						end
					end
				end
				
				if table.getn(relationEquip) == sss and table.getn(relationEquip) > 0 and sss > 0 then
					fettersNumber = fettersNumber + 1
					
					name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
						name = name_datas[3]
					end
					for i,v in pairs(relationEquip) do
						for j,e in pairs(_ED.user_equiment) do
							if zstring.tonumber(e.user_equiment_template) == v then
								table.insert(textData, {nameOne = getPersonName , nameTwo = name})
								break
							end
						end
					end
				end
			end
		end
	elseif ker ~= nil then
		local getPersonName = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = smGetSkinEvoIdChange(self.ship)
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			getPersonName = word_info[3]
		else
			if tonumber(self.ship.captain_type) == 0 then
				getPersonName = _ED.user_info.user_name
			else
				getPersonName = dms.string(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.captain_name)
			end
		end
		local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.relationship_id), ",")
		for k,w in pairs(myRelatioInfo) do
			local num = 1
			local relationEquip = {}
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
					num = num + 1
				end
			end
			
			
			name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
				name = name_datas[3]
			end
			for i,v in pairs(relationEquip) do
				if zstring.tonumber(_ED.user_equiment[ker].user_equiment_template) == v then
					table.insert(textData, {nameOne =  getPersonName, nameTwo = name})
					break
				end
			end
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		status = false
	end
	if status == true then
		local nums1,nums2,nums3,nums4 = self:Mason(shipId)
		if zstring.tonumber(temp) ~= 4 and zstring.tonumber(temp) ~= 5 then
			if zstring.tonumber(nums1)>zstring.tonumber(self.masterStrengthenlv[1]) then
				self.masterStrengthenlv[1] = nums1
				table.insert(textData, {property = _strengthen_master_info[10], value = nums1, add = _strengthen_master_info[14] })
			end
			if zstring.tonumber(nums2)>zstring.tonumber(self.masterStrengthenlv[2]) then
				self.masterStrengthenlv[2] = nums2
				table.insert(textData, {property = _strengthen_master_info[11], value = nums2, add = _strengthen_master_info[14] })
			end
		end
		
		if nums3 ~= nil and nums4 ~= nil then
			if zstring.tonumber(nums3)>zstring.tonumber(self.masterStrengthenlv[3]) then
				self.masterStrengthenlv[3] = nums3
				table.insert(textData, {property = _strengthen_master_info[12], value = nums3, add = _strengthen_master_info[14] })
			end
			if zstring.tonumber(nums4)>zstring.tonumber(self.masterStrengthenlv[4]) then
				self.masterStrengthenlv[4] = nums4
				table.insert(textData, {property = _strengthen_master_info[13], value = nums4, add = _strengthen_master_info[14] })
			end
			table.insert(textData, {property = _property[2], value = ship_courage})
			table.insert(textData, {property = _property[1], value = ship_health})
			table.insert(textData, {property = _property[3], value = ship_intellect})
			table.insert(textData, {property = _property[4], value = ship_quick})
		else
			table.insert(textData, {property = _property[2], value = ship_courage})
			table.insert(textData, {property = _property[1], value = ship_health})
			table.insert(textData, {property = _property[3], value = ship_intellect})
			table.insert(textData, {property = _property[4], value = ship_quick})
		end
		
	else
		table.insert(textData, {property = _property[2], value = ship_courage})
		table.insert(textData, {property = _property[1], value = ship_health})
		table.insert(textData, {property = _property[3], value = ship_intellect})
		table.insert(textData, {property = _property[4], value = ship_quick})
	end
	
	
	app.load("client.cells.utils.property_change_tip_info_cell") 
	local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()

	local str = ""
	if types == 1 then
		str = tipStringInfo_hero_change_Type[1]
		-- local shipid = tonumber(self.ship.ship_template_id)
		-- local soundid = dms.string(dms["ship_mould"], shipid, ship_mould.sound_index)
		-- playEffectExt(formatMusicFile("effect", soundid))		
		-- state_machine.excute("Lformation_ship_cell_play_hero_animation",0,{"begin"})
	elseif types == 2 then
		-- str = tipStringInfo_hero_change_Type[4]
	elseif types == 3 then
		-- str = tipStringInfo_hero_change_Type[5]
	elseif types == 6 then -- 上阵英雄成功
		str = tipStringInfo_hero_change_Type[6]
		-- local shipid = tonumber(self.ship.ship_template_id)
		-- local soundid = dms.string(dms["ship_mould"], shipid, ship_mould.sound_index)
		-- playEffectExt(formatMusicFile("effect", soundid))			
		-- state_machine.excute("Lformation_ship_cell_play_hero_animation",0,{"begin"})
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		tipInfo:init(1,str, textData,false)
	else
		tipInfo:init(1,str, textData)	
	end
	fwin:open(tipInfo, fwin._view)
		--动画播完后 需要清零原先的属性变化
	previousShip.ship_courage=0
	previousShip.ship_health=0
	previousShip.ship_intellect=0
	previousShip.ship_quick=0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("formation_property_change_tip_info",0,"")
	end
end

local function createLHeroCardCell(ship,tpyes,index)
	local cardLayout = LformationChangeHeroCell:createCell()
	cardLayout:init(ship,tpyes,index)
	return cardLayout
end

-- 绘制阵容界面中所有的武将，包含未装备武将位置的显示
function FormationTigerGate:drawShipPageView(createShip)
	-- local root = self.roots[1]
	-- local last_index = 1
	-- local HomeHeroWnd = fwin:find("HomeHeroClass")
	-- if HomeHeroWnd ~= nil then
	-- 	last_index = HomeHeroWnd.current_formetion_index
	-- end
	
	-- local heroPanel = ccui.Helper:seekWidgetByName(root, "Panel_1_4")
	
	-- heroPanel:removeChild(heroPanel._nodeChild, true)
	-- local cell = nil
	-- if createShip ~= nil then
	-- 	cell = createLHeroCardCell(createShip, 1, last_index)
	-- else
	-- 	cell = createLHeroCardCell(self.ship, 1, last_index)
	-- end
	-- local panel_size = heroPanel:getContentSize()
	-- heroPanel:addChild(cell)
	-- heroPanel._nodeChild = cell
	-- return cell
end

--新项目的绘制装备方法（24，25项目）
function FormationTigerGate:updateEquipDraw()
	local root = self.roots[1]
	local shop_equip_position = {
		ccui.Helper:seekWidgetByName(root, "Panel_17_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_4"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_5"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_6")
	}
	for i=1, 6 do
		local equipPlaceInfo = shop_equip_position[i]
		if __lua_project_id == __lua_project_l_digital then
			local parentNode = equipPlaceInfo:getParent()
			if #self.shipEquipPos == 6 then
				parentNode:setPosition(cc.p(self.shipEquipPos[i][1] , self.shipEquipPos[i][2]))
			else
				table.insert(self.shipEquipPos ,{parentNode:getPositionX() ,parentNode:getPositionY()})
			end
		end
		equipPlaceInfo:removeAllChildren(true)
	end
	if self.ship ~= nil then
		--武将装备数据(等级|品质|经验|星级|模板)
		local shipEquip = zstring.split(self.ship.equipInfo, "|")

		--初始装备
		local equipAll = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.treasureSkill)
		local equipData = zstring.split(shipEquip[5], ",")

		local equipStar = zstring.split(shipEquip[4], ",")
		self.equipInfo = {}

		local suitDistance = 0
		if __lua_project_id == __lua_project_l_digital then
			-- DSC重塑
			suitDistance = self:updateDrawInstance()
			-- 小米11pro的偏移处理
			if (tonumber(app.screenSize.width) == 3063 and tonumber(app.screenSize.height) == 1440) and cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
				suitDistance = suitDistance - 140
			end
			if suitDistance < 0 then
				suitDistance = 0
			end
		end
		for i=1, 6 do
			local equipPlaceInfo = shop_equip_position[i]
			local equipMouldId = equipData[i]
			local equip = {}
			--装备模板id
			if tonumber(equipStar[i]) == 0 then
				local equipMouldData = zstring.split(equipAll, ",")
				equip.user_equiment_template = equipMouldData[i]
			else
				equip.user_equiment_template = equipMouldId
			end
			
			--装备等级
			local equipLevelData = zstring.split(shipEquip[1], ",")
			equip.user_equiment_grade = equipLevelData[i]
			--所属战船
			equip.ship_id = self.ship.ship_id
			equip.m_index = i
			local cell = self:createEquipHead(1,equip)
			
			equipPlaceInfo:addChild(cell)
			self.equipIconArray[i] = cell
			
			if __lua_project_id == __lua_project_l_digital then
				local parentNode = equipPlaceInfo:getParent()
				self:moveDistance(suitDistance , i , parentNode)
			else
				cell:setPosition(cell:getPositionX()-2.5,cell:getPositionY()-3)
			end
			local starts = zstring.split(shipEquip[4], ",")
			neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_star"), tonumber(starts[tonumber(i)]))
			self.equipInfo[i] = equip
		end
	end

end

-- DSC重塑
function FormationTigerGate:moveDistance(distance , index , node)
	if index % 2 == 1 then
		node:setPosition(node:getPositionX() + distance , node:getPositionY()-3)
	elseif index % 2 == 0 then
		node:setPosition(node:getPositionX() - distance , node:getPositionY()-3)
	end
end
-- DSC重塑
function FormationTigerGate:updateDrawInstance()
	local root = self.roots[1]

	local father = ccui.Helper:seekWidgetByName(root, "Panel_xinxi")

	local role = ccui.Helper:seekWidgetByName(root, "Panel_1_4")

	local equipLeft = ccui.Helper:seekWidgetByName(root, "Panel_17_2")

	local director = cc.Director:getInstance()
	local glView = director:getOpenGLView()

	local pos1 = fwin:convertToWorldSpaceAR(root , cc.p(role:getPositionX() , role:getPositionY()))
	local pos2 = fwin:convertToWorldSpaceAR(root , cc.p(equipLeft:getPositionX() , equipLeft:getPositionY()))
	local frameScreen = tonumber(glView:getFrameSize().width) / tonumber(glView:getFrameSize().height)
	local designScreen = tonumber(app.designSize.width) / tonumber(app.designSize.height)
	local scale = frameScreen / designScreen
	if scale < 1 then
		scale = 1
	end

	local result = (pos1.x - pos2.x) * (scale - 1)
	return result
end

-- 更新当前武将的所有装备绘图
function FormationTigerGate:updateDrawEquipments()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self:updateEquipDraw()
		return
	end
	local root = self.roots[1]
	local shop_equip_position = {
		ccui.Helper:seekWidgetByName(root, "Panel_17_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_4"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_5"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_6")
	}

	--绘制武将装备位上的装备
	for i=1, 6 do
		local equipPlaceInfo = shop_equip_position[i]
		equipPlaceInfo:removeChild(equipPlaceInfo._nodeChild, true)
		equipPlaceInfo:removeBackGroundImage()
		equipPlaceInfo._nodeChild = nil
	end
	
	local status = false
	local status2 = false
	if zstring.tonumber(_ED.user_info.user_grade) < 15 then
		for i=1, 6 do
			local equipPlaceInfo = shop_equip_position[i]
			if i <= 4 then
				if zstring.tonumber(_ED.user_info.user_grade) < 5 then
					equipPlaceInfo:removeChild(equipPlaceInfo._nodeChild, true)
					equipPlaceInfo._nodeChild = nil
					equipPlaceInfo:setBackGroundImage("images/ui/quality/lock_baowu.png")
					status = true
					
					local function changeTipCallback2(sender, eventType)
						if eventType == ccui.TouchEventType.ended then
							if zstring.tonumber(_ED.user_info.user_grade) < 5 then
								TipDlg.drawTextDailog(_string_piece_info[343])
							end
						end	
					end
					
					shop_equip_position[1]:addTouchEventListener(changeTipCallback2)
					shop_equip_position[3]:addTouchEventListener(changeTipCallback2)
					shop_equip_position[2]:addTouchEventListener(changeTipCallback2)
					shop_equip_position[4]:addTouchEventListener(changeTipCallback2)
				else
					equipPlaceInfo:removeBackGroundImage()
				end
			else
				equipPlaceInfo:removeChild(equipPlaceInfo._nodeChild, true)
				equipPlaceInfo._nodeChild = nil
				equipPlaceInfo:setBackGroundImage("images/ui/quality/lock_baowu.png")
				
				local function changeTipCallback(sender, eventType)
					if eventType == ccui.TouchEventType.ended then
						if zstring.tonumber(_ED.user_info.user_grade) < 15 then
							TipDlg.drawTextDailog(_string_piece_info[329])
						end
					end
				end
				
				status2 = true
			end
		end
	end

	if self.ship == nil or self.ship == 0 then
		for i=1, 6 do
			if i <= 4 and status == false then
				local equipPlaceInfo = shop_equip_position[i]
				local addcell = self:createAddActionCell(1,i-1,self.queue.shiptype[zstring.tonumber(self._current_cell._index)])
				equipPlaceInfo:addChild(addcell)
				equipPlaceInfo._nodeChild = addcell
			elseif i > 4 and i <= 6 and status2 == false then
				local equipPlaceInfo = shop_equip_position[i]
				local addcell = self:createAddActionCell(1,i-1,self.queue.shiptype[zstring.tonumber(self._current_cell._index)])
				equipPlaceInfo:addChild(addcell)
				equipPlaceInfo._nodeChild = addcell
			end
		end
		return
	end
	for i, equip in pairs(self.ship.equipment) do
		local equipPlaceInfo = shop_equip_position[i]
		if i <= 4 and status == false then
			if zstring.tonumber(equip.ship_id) > 0 then
				local cell = self:createEquipHead(1,equip)
				equipPlaceInfo:addChild(cell)
				cell:setPosition(cell:getPositionX()-2.5,cell:getPositionY()-3)
				equipPlaceInfo._nodeChild = cell
			else
				------------------------------------------------------------
				if i<=6 then
					local addcell = self:createAddActionCell(1,i-1,self.queue.shiptype[zstring.tonumber(self._current_cell._index)])
					equipPlaceInfo:addChild(addcell)
					equipPlaceInfo._nodeChild = addcell
				end
				----------------------end---------------------------------------------------------
			end
		elseif i > 4 and i <= 6 and status2 == false then
			if zstring.tonumber(equip.ship_id) > 0 then
				local cell = self:createEquipHead(1,equip)
				equipPlaceInfo:addChild(cell)
				cell:setPosition(cell:getPositionX()-2.5,cell:getPositionY()-3)
				equipPlaceInfo._nodeChild = cell
			else
				------------------------------------------------------------
				if i<=6 then
					local addcell = self:createAddActionCell(1,i-1,self.queue.shiptype[zstring.tonumber(self._current_cell._index)])
					equipPlaceInfo:addChild(addcell)
					equipPlaceInfo._nodeChild = addcell
				end
				----------------------end---------------------------------------------------------
			end
		end
	end
end

-- 更新当前武将的所有基础属性的帧动画
function FormationTigerGate:updateDrawShipInfoAction(params)
	if self.ship ~= nil then
		local root = self.roots[1]
		local shipAttribute={
			"Text_3_5",--等级
			"Text_3_6",--攻击
			"Text_3_7",--生命
			"Text_3_8",--物防
			"Text_3_9",--法防
			"Text_41",--名称
		}
		if fwin:find("FormationTigerGateClass") == nil then
			return
		end
		local currShip = self.ship
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			currShip = getShipByTalent(self.ship)
		end

		local ship_courage_text = ccui.Helper:seekWidgetByName(root, shipAttribute[2])
		local ship_health_text = ccui.Helper:seekWidgetByName(root, shipAttribute[3])
		local ship_intellect_text = ccui.Helper:seekWidgetByName(root, shipAttribute[4])
		local ship_quick_text = ccui.Helper:seekWidgetByName(root, shipAttribute[5])


		local old_ship_courage 	= zstring.tonumber(ship_courage_text:getString())
		local old_ship_health	= zstring.tonumber(ship_health_text:getString())
		local old_ship_intellect	= zstring.tonumber(ship_intellect_text:getString())
		local old_ship_quick 	= 0
		if __lua_project_id == __lua_project_gragon_tiger_gate then
			old_ship_quick = zstring.tonumber(ship_quick_text:getString())
		end
		
		if type(old_ship_courage) ~= "number" then
			old_ship_courage = 0
		end
		
		if type(old_ship_health) ~= "number" then
			old_ship_health = 0
		end
		
		if type(old_ship_intellect) ~= "number" then
			old_ship_intellect = 0
		end
		
		if type(old_ship_quick) ~= "number" then
			old_ship_quick = 0
		end
		
		local ship_level_text = ccui.Helper:seekWidgetByName(root, shipAttribute[1])
		local old_ship_leveltext = ship_level_text:getString()
		local array = zstring.split(old_ship_leveltext,"/")
		local old_ship_level = array[1]
		local change_ship_level = math.floor((zstring.tonumber(currShip.ship_grade) - old_ship_level)*0.1)
		
		local change_ship_courage 	= math.floor((zstring.tonumber(currShip.ship_courage) - old_ship_courage)*0.1)
		local change_ship_health	= math.floor((zstring.tonumber(currShip.ship_health) - old_ship_health)*0.1)
		local change_ship_intellect	= math.floor((zstring.tonumber(currShip.ship_intellect) - old_ship_intellect)*0.1)
		local change_ship_quick 	= math.floor((zstring.tonumber(currShip.ship_quick) - old_ship_quick)*0.1)
		
		--动画帧-----------------------------------------------------
		-- self.action = csb.createTimeline("formation/line_up.csb")
		-- self.action:play("text_up_dh", false)
		-- self.roots[1]:runAction(self.action)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			ship_courage_text:setString(currShip.ship_courage)
			ship_health_text:setString(currShip.ship_health)
			ship_intellect_text:setString(currShip.ship_intellect)
			if ship_quick_text ~= nil then
				ship_quick_text:setString(currShip.ship_quick)
			end
			ship_level_text:setString(currShip.ship_grade)
		end
	
		local function addTextNum(_ship_courage, _ship_health, _ship_intellect, _ship_quick,_ship_level)
			ship_courage_text:setString(_ship_courage)
			ship_health_text:setString(_ship_health)
			ship_intellect_text:setString(_ship_intellect)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				ship_level_text:setString(_ship_level)
			else
				ship_quick_text:setString(_ship_quick)
				ship_level_text:setString(_ship_level.."/".._ED.user_info.user_grade)
				self:updateDrawShipInfo()
			end
		end
		
		local function playOver( ... )
			old_ship_courage 	= old_ship_courage + change_ship_courage
			old_ship_health 	= old_ship_health + change_ship_health
			old_ship_intellect 	= old_ship_intellect + change_ship_intellect
			old_ship_quick 		= old_ship_quick + change_ship_quick

			old_ship_level = old_ship_level + change_ship_level

			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			else
				addTextNum(old_ship_courage, old_ship_health, old_ship_intellect, old_ship_quick,old_ship_level)
			end
		end

		local scale_ani = cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1),cc.CallFunc:create(playOver)) 
		local scale_h = cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1))
		local scale_i = cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1))
		local scale_q = cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1))
		-- local scale_l = cc.Sequence:create(cc.ScaleTo:create(0.1,1.5),cc.ScaleTo:create(0.1,1),cc.CallFunc:create(playOver)) 
		if fwin:find("FormationTigerGateClass") ~= nil then
			ship_courage_text:runAction(scale_ani)
			ship_health_text:runAction(scale_h)
			ship_intellect_text:runAction(scale_i)
			-- ship_level_text:runAction(scale_l)
			if ship_quick_text ~= nil then
				ship_quick_text:runAction(scale_q)
			end
		end
		-- local findex = 1
		-- self.action:setFrameEventCallFunc(function (frame)
		-- 	if nil == frame then
		-- 		return
		-- 	end
		-- 	local str = frame:getEvent()
		-- 	local ffeventName = string.format("text_up_1%d", findex)
		-- 	if str == "over" then
		-- 		self:updateDrawShipInfo()
		-- 	elseif str == ffeventName then
		-- 		if findex == 10 then
		-- 			if fwin:find("FormationTigerGateClass") ~= nil and self.ship ~= nil then
		-- 				addTextNum(self.ship.ship_courage, self.ship.ship_health, self.ship.ship_intellect, self.ship.ship_quick,self.ship.ship_grade)
		-- 			end
		-- 		else	
		-- 			old_ship_courage 	= old_ship_courage + change_ship_courage
		-- 			old_ship_health 	= old_ship_health + change_ship_health
		-- 			old_ship_intellect 	= old_ship_intellect + change_ship_intellect
		-- 			old_ship_quick 		= old_ship_quick + change_ship_quick

		-- 			old_ship_level = old_ship_level + change_ship_level

		-- 			addTextNum(old_ship_courage, old_ship_health, old_ship_intellect, old_ship_quick,old_ship_level)
		-- 		end
		-- 		findex = findex + 1
		-- 	end
		-- end)



		self:updateDrawShipInfo()
	else
		self:updateDrawShipInfo()
	end
end

-- 更新当前武将的所有基础属性
function FormationTigerGate:updateDrawShipInfo()
	local root = self.roots[1]
	local shipAttribute = {
		ccui.Helper:seekWidgetByName(root, "Text_3_5"),--等级
		ccui.Helper:seekWidgetByName(root, "Text_3_6"),--攻击
		ccui.Helper:seekWidgetByName(root, "Text_3_7"),--生命
		ccui.Helper:seekWidgetByName(root, "Text_3_8"),--物防
		ccui.Helper:seekWidgetByName(root, "Text_3_9"),--法防
		ccui.Helper:seekWidgetByName(root, "Text_41"),--名称
		ccui.Helper:seekWidgetByName(root, "Text_65"),--阶位
	}
	local Button_5 = ccui.Helper:seekWidgetByName(root, "Button_5")
	local Button_5_0 = ccui.Helper:seekWidgetByName(root, "Button_5_0")
	local Button_5_1 = ccui.Helper:seekWidgetByName(root, "Button_5_1")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	local Button_change_skills = ccui.Helper:seekWidgetByName(root, "Button_change_skills")
	local Button_line_qianghua = ccui.Helper:seekWidgetByName(root, "Button_line_qianghua")
	if self.ship ~= nil then
		local currShip = self.ship
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			currShip = getShipByTalent(_ED.user_ship[self.ship.ship_id])
		end
		local hero_name = currShip.captain_name
		local hero_grade = currShip.ship_grade
		local name = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], currShip.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(currShip.evolution_status, "|")

			-- 显示隐藏究极潜力
			local evolutionLevel = tonumber(ship_evo[1])
			local Button_energy = ccui.Helper:seekWidgetByName(root, "Button_energy")
			if evolutionLevel == 4 then
				Button_energy:setVisible(true)
			else
				Button_energy:setVisible(false)				
			end

			local evo_mould_id = smGetSkinEvoIdChange(currShip)
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]
			if getShipNameOrder(tonumber(currShip.Order)) > 0 then
				name = name.." +"..getShipNameOrder(tonumber(currShip.Order))
			end
		else
			name = dms.string(dms["ship_mould"], currShip.ship_template_id, ship_mould.captain_name)
		end
		local rankLevelFront = dms.string(dms["ship_mould"], currShip.ship_template_id, ship_mould.initial_rank_level)
		if FormationTigerGate.__userHeroFontName == nil then
			FormationTigerGate.__userHeroFontName = shipAttribute[6]:getFontName()
		end
		if zstring.tonumber(currShip.captain_type) == 0 then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			else
				name = _ED.user_info.user_name
				hero_grade = _ED.user_info.user_grade
			end
			if ___is_open_leadname == true then
				shipAttribute[6]:setFontName("")
				shipAttribute[6]:setFontSize(shipAttribute[6]:getFontSize())
			end
		else
			shipAttribute[6]:setFontName(FormationTigerGate.__userHeroFontName)
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			shipAttribute[1]:setString(hero_grade)
		else
			shipAttribute[1]:setString(hero_grade.."/".._ED.user_info.user_grade)
		end
		shipAttribute[2]:setString(currShip.ship_courage)
		shipAttribute[3]:setString(currShip.ship_health)
		shipAttribute[4]:setString(currShip.ship_intellect)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Text_role_fight = ccui.Helper:seekWidgetByName(root, "Text_role_fight")
			Text_role_fight:setString(currShip.hero_fight)
			if shipAttribute[5] ~= nil then				
				shipAttribute[5]:setVisible(false)
			end
		else
			if shipAttribute[5] ~= nil then
				shipAttribute[5]:setString(currShip.ship_quick)
			end
		end
		shipAttribute[6]:setString(name)
		if zstring.tonumber(rankLevelFront) > 0 then
			shipAttribute[7]:setString("+"..rankLevelFront)
		else
			shipAttribute[7]:setString("")
		end

		local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
		local color_R = 0
		local color_G = 0
		local color_B = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			quality = shipOrEquipSetColour(tonumber(self.ship.Order))
			color_R = tipStringInfo_quality_color_Type[quality][1]
			color_G = tipStringInfo_quality_color_Type[quality][2]
			color_B = tipStringInfo_quality_color_Type[quality][3]
		else
			color_R = tipStringInfo_quality_color_Type[quality][1]
			color_G = tipStringInfo_quality_color_Type[quality][2]
			color_B = tipStringInfo_quality_color_Type[quality][3]
		end
		shipAttribute[6]:setColor(cc.c3b(color_R, color_G, color_B))
		shipAttribute[7]:setColor(cc.c3b(color_R, color_G, color_B))
		local isleadtype = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type)
		if zstring.tonumber(isleadtype) > 0 then
			if Button_5_0 ~= nil then
				Button_5_0:setVisible(false)
			end
			Button_5_1:setVisible(true)
			if Button_change_skills ~= nil then
				Button_change_skills:setVisible(false)
			end
		else
			Panel_14:setVisible(true)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				Button_5_1:setVisible(true)
			else
				Button_5_0:setVisible(true)
				Button_5_1:setVisible(false)
				Button_change_skills:setVisible(true)
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
			Button_line_qianghua:setVisible(true)
		end
		if Button_5 ~= nil then
			Button_5:setVisible(true)
		end
	else
		Button_line_qianghua:setVisible(false)
		if Button_5 ~= nil then
			Button_5:setVisible(false)
		end
		Button_5_1:setVisible(false)
		if Button_5_0 ~= nil then
			Button_5_0:setVisible(false)
		end
		if Button_change_skills ~= nil then
			Button_change_skills:setVisible(false)
		end
		for i=1,7 do
			if shipAttribute[i] ~= nil then
				shipAttribute[i]:setString(" ")
			end
		end
	end
	if self.ship ~= nil then
		if zstring.tonumber(self.ship.formation_index) > 0 then
		else
			Button_5_1:setVisible(false) -- 替换
			if Button_5 ~= nil then
				Button_5:setVisible(false) -- 强化大师
			end
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		-- 	Button_line_qianghua:setVisible(false)
		-- else
			if Button_line_qianghua:isVisible() == true then
				Button_line_qianghua:setVisible(true) -- 现在又要了
			else
				Button_line_qianghua:setVisible(false) -- 现在又要了
			end
		-- end
	else
		Button_line_qianghua:setVisible(false) -- 现在不要了	
	end
	local shipRelation = {}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		shipRelation={
			"Text_27",--缘分1
			"Text_27_0",--缘分2
			"Text_27_1",--缘分3
			"Text_27_2",--缘分4
			"Text_27_3",--缘分5
			"Text_27_4",--缘分6
		}
	else
		shipRelation={
			"Text_27",--缘分1
			"Text_27_2",--缘分2
			"Text_27_0",--缘分3
			"Text_27_3",--缘分4
			"Text_27_1",--缘分5
			"Text_27_4",--缘分6
		}
	end
	local list = {}
	if self.ship ~= nil then
		-- 缘分过滤
		for i = 1 ,table.getn(self.ship.relationship) do
			list[i] = self.ship.relationship[i]
		end
		local function sort_is_activited(a, b)
			if zstring.tonumber(a.is_activited) > zstring.tonumber(b.is_activited) then
				return true
			end
			return false
		end
		table.sort(list, sort_is_activited)
	end
	-- 对缘分过滤
	self.relationship_ids = {}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		for i=1,6 do
			ccui.Helper:seekWidgetByName(root, shipRelation[i]):setString("")
			if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then 
				-- DSC重塑
				ccui.Helper:seekWidgetByName(root, shipRelation[i]):setColor(cc.c3b(tipStringInfo_color_type_assemble[4][1],tipStringInfo_color_type_assemble[4][2],tipStringInfo_color_type_assemble[4][3]))
			else
				ccui.Helper:seekWidgetByName(root, shipRelation[i]):setColor(the_color_of_the_fetters[1])
			end
		end
		local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.relationship_id), ",")
		for i, v in pairs(myRelatioInfo) do
			local relationshipLabel = ccui.Helper:seekWidgetByName(root, shipRelation[i])
			local relationName= dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
			local name_datas = dms.element(dms["word_mould"], zstring.tonumber(relationName))
			relationName = name_datas[3]
			relationshipLabel:setString(relationName)
			local ship_list = {}
			local activation_list = {}
			for j=1, 6 do
				local needId = dms.int(dms["fate_relationship_mould"], v, j+4+(j-1)*2-j)
				if needId > 0 then
					local needType = dms.int(dms["fate_relationship_mould"], v, j+4+(j-1)*2-j+1)
					if needType == 0 then
	        			--数码兽
	        			local evo_image = dms.string(dms["ship_mould"], needId, ship_mould.fitSkillTwo)
	                    local evo_info = zstring.split(evo_image, ",")
	                    local needShip = fundShipWidthTemplateId(needId)
	                    if needShip ~= nil then
	                    	table.insert(activation_list, 1)
	                    end
	            		table.insert(ship_list, 1)
	    			elseif needType == 1 then
	        			--装备
	        			--武将装备数据(等级|品质|经验|星级|模板)
	                    local shipEquip = zstring.split(self.ship.equipInfo, "|")
	                    --初始装备
	                    local equipAll = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.treasureSkill)
	                    local equipData = zstring.split(shipEquip[5], ",")
	                    local equipStar = zstring.split(shipEquip[4], ",")
	                    
                    	local isSame = false
	                    for x=1, 6 do
	                        local equipMouldId = equipData[x]
	                        --装备模板id
	                        local equipMid = 0
	                        if tonumber(equipStar[x]) == 0 then
	                            local equipMouldData = zstring.split(equipAll, ",")

	                            equipMid = tonumber(equipMouldData[x])
	                        else
	                            equipMid = tonumber(equipMouldId)
	                        end
	                        if needId == equipMid then
	                            isSame = true
	                            break
	                        end
	                    end
                        table.insert(ship_list, 1)
                        if isSame == true then
                            table.insert(activation_list, 1)
                        end
	    			elseif needType == 2 then  
	                    --皮肤
	                    table.insert(ship_list, 1)
	                end 
				end
			end
			local colors = nil
			if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then 
				-- DSC重塑
				if #ship_list == 0 or (#ship_list ~= 0 and #ship_list ~= #activation_list)then
					colors = cc.c3b(tipStringInfo_color_type_assemble[4][1],tipStringInfo_color_type_assemble[4][2],tipStringInfo_color_type_assemble[4][3])
				else
					if #ship_list == #activation_list then
						colors = cc.c3b(tipStringInfo_color_type_assemble[3][1],tipStringInfo_color_type_assemble[3][2],tipStringInfo_color_type_assemble[3][3])
					end
				end
			else
				if #ship_list == 0 then
					colors = the_color_of_the_fetters[1]
				else
					if #ship_list == #activation_list then
						colors = the_color_of_the_fetters[2]
					else
						colors = the_color_of_the_fetters[1]
					end
				end
			end
	        relationshipLabel:setColor(colors)
		end
	else
		for i=1, 6 do
			local Image_yuanfen = ccui.Helper:seekWidgetByName(root,"Image_yuanfen_"..i.."_0")
			local relationshipLabel = ccui.Helper:seekWidgetByName(root, shipRelation[i])
			if self.ship ~= nil then
				local relationship = nil
				relationship = list[i]
				if relationship ~= nil then
					if zstring.tonumber(self.ship.relationship_count) > 6 then
						if list[i+6] ~= nil and zstring.tonumber(list[i+6].is_activited) == 1 then
							relationship = list[i+6]
						end
					end
					if zstring.tonumber(self.ship.captain_type) == 0 then
						local relationName= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_name)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							local name_datas = dms.element(dms["word_mould"], zstring.tonumber(relationName))
							relationName = name_datas[3]
						end
						relationshipLabel:setString(relationName)
					else
						local relationName= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_name)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							local name_datas = dms.element(dms["word_mould"], zstring.tonumber(relationName))
							relationName = name_datas[3]
						end
						relationshipLabel:setString(relationName)
					end
					
					if zstring.tonumber(relationship.is_activited) == 1 then
						relationshipLabel:setColor(cc.c3b(formation_relationship_color_Type_two[2][1],formation_relationship_color_Type_two[2][2],formation_relationship_color_Type_two[2][3]))
						if Image_yuanfen ~= nil then
							Image_yuanfen:setVisible(true)
						end
					else
						relationshipLabel:setColor(cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]))
						if Image_yuanfen ~= nil then
							Image_yuanfen:setVisible(false)
						end
					end
				else
					relationshipLabel:setString(" ")
				end
				if relationship ~= nil then
					local relationName= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_name)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local name_datas = dms.element(dms["word_mould"], zstring.tonumber(relationName))
						relationName = name_datas[3]
					end
					table.insert(self.relationship_ids,relationship.relationship_id)
				end
			else
				relationshipLabel:setString(" ")
			end
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		local number = #self.relationship_ids
		for i=1 , 6 do
			local Image_yuanfen = ccui.Helper:seekWidgetByName(root, "Image_yuanfen_"..i)
			local images_light = ccui.Helper:seekWidgetByName(root, "Image_yuanfen_"..i.."_1")	
			local images_panel = ccui.Helper:seekWidgetByName(root, "Image_yuanfen_"..i.."_0")
			if i > number then
				Image_yuanfen:setVisible(false)
				images_light:setVisible(false)
				images_panel:setVisible(false)
			else
				Image_yuanfen:setVisible(true)
				images_light:setVisible(true)
				images_panel:setVisible(true)
				fwin:addTouchEventListener(Image_yuanfen, nil, 
				{
					terminal_name = "formation_go_to_hero_reloship", 
					terminal_state = 0, 
					button_type = i,
					isPressedActionEnabled = true,
				},
				nil,0)		
			end
		end	
		--总缘分数
		local relationshipOpenCount = 0
		for i = 1, 6 do
			local shipId = _ED.user_formetion_status[i]
			if zstring.tonumber(shipId) > 0 then
				for j=1,zstring.tonumber(_ED.user_ship[shipId].relationship_count) do
					local relationship = _ED.user_ship[shipId].relationship[j]
					if relationship~=nil then
						if zstring.tonumber(relationship.is_activited) == 1 then
							relationshipOpenCount = relationshipOpenCount + 1
						end
					end
				end
			end
		end
		
		ccui.Helper:seekWidgetByName(root, "Text_52"):setString(relationshipOpenCount)
	end
	
	local type_pad = ccui.Helper:seekWidgetByName(root, "Panel_7_0")
	local ability_text = ccui.Helper:seekWidgetByName(root, "Text_101_0_0")
	if self.ship ~= nil then
		-- 类型
		local type_data = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.capacity)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
			type_pad:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", type_data))
		end
		
		-- 资质
		local ability_data = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ability)
		-- ability_text:setString(ability_data)
		ability_text:setString(getAbilityFromBaMen(self.ship,ability_data))
		
		
	else
		type_pad:removeBackGroundImage()
		ability_text:setString(" ")
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self:newFormationShowShip()
	end

	self:updateChangeFormationButtonState()
	-- Fury: boton «Mejoras» tambien en la ficha de la formacion (tocar un heroe en la ciudad o
	-- entrar por Formacion); antes solo salia en SmRoleStrengthenTab (Victor, 30-sep).
	pcall(function() app.load("client.packs.hero.FuryHeroExtras") FuryHeroExtras.attach(self) end)
end

function FormationTigerGate:loadEffectFile(fileIndex)
    local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    local armatureName = string.format("effice_%d", fileIndex)
    return armatureName, fileName
end

function FormationTigerGate:createEffect(fileIndex, fileNameFormat)
    -- 创建光效
    local armature = nil
    if animationMode == 1 then
        -- armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        -- armature.animationNameList = spineAnimations
        -- sp.initArmature(armature, true)
        armature = sp.spine_effect(fileIndex, effectAnimations[1], false, nil, nil, nil, nil, nil, nil, fileNameFormat)
        armature.animationNameList = effectAnimations
        sp.initArmature(armature, true)
    else
        local armatureName, fileName = self:loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end
    -- table.insert(self.animationList, {fileName = fileName, armature = armature})
    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    -- local _tcamp = zstring.tonumber(""..self.roleCamp)
    local _armatureIndex = 0 -- frameListCount * _tcamp
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    -- armature:getAnimation():setSpeedScale(1.0 / __fight_recorder_action_time_speed)
    
    local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
    armature._duration = duration / 60.0
    return armature
end

local function checkFrameEvent(events, mode)
    if events ~= n and #events > 0 then
        for i, v in pairs(events) do
            if v == mode then
                return true
            end
        end
    end
    return false
end

local function deleteEffectFile(armatureBack)
    if armatureBack == nil then
        return
    end
    -- 删除光效
    armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns
    if armatureBack._LastsCountTurns <= 0 then
        local fileName = armatureBack._fileName
        -- print("deleteEffectFile-----------", FightRole.animationList)
        -- for i,v in ipairs(FightRole.animationList) do
        --     if v ~= nil and v.fileName == fileName then
        --         table.remove(FightRole.animationList, ""..i)
        --     end
        -- end
        if m_tOperateSystem == 5 then
            if fileName ~= nil then
                CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
            end
        end
            if armatureBack.getParent ~= nil then
                if armatureBack:getParent() ~= nil then
                    if armatureBack.removeFromParent ~= nil then
                        armatureBack:removeFromParent(true)
                    end
                end
            end
        if m_tOperateSystem == 5 then
            -- draw.cleanMemory()
            -- draw.cleanCacheMemory()
            -- CCArmatureDataManager:purge()
            
            CCSpriteFrameCache:purgeSharedSpriteFrameCache()
            CCTextureCache:sharedTextureCache():removeUnusedTextures()
        end
    end
end

local function onFrameEventRole(bone,evt,originFrameIndex,currentFrameIndex)
    local armature = bone:getArmature()
    local _self = armature._self

    local frameEvents = zstring.split(evt, "_")
    if checkFrameEvent(frameEvents, "union") == true then -- 启动角色镜头聚焦
		-- print("start union effect!")
        local effectIds = zstring.split(frameEvents[2], ",")
        for i, v in pairs(effectIds) do
			-- print("create union effect:", v)
            local armatureEffect = _self:createEffect(v, "sprite/effect_")
            armatureEffect._self = _self
            armatureEffect._invoke = deleteEffectFile

            local map = armature -- _self:getParent()
            map:addChild(armatureEffect)

            -- local sx, sy = _self:getPosition()
            -- armatureEffect:setPosition(cc.p(sx, sy))
            -- if _self.roleCamp == 1 then
                -- armatureEffect:setScaleX(-1 * armatureEffect:getScaleX())
            -- end
        end
    end
end

--新项目的绘制形象方法（24，25项目）
function FormationTigerGate:newFormationShowShip()
	local root = self.roots[1]
	if self.ship == nil then
		return
	end
	local Panel_1_4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_1_4")
	-- Panel_1_4:setTouchEnabled(false)
	
	self._bust_index = 1

	if self.armature_hero ~= nil then
		self.armature_hero._invoke = nil	
		self.armature_hero = nil
	end
	if self.armature_effic ~= nil then
		self.armature_effic._invoke = nil
		self.armature_effic = nil
	end
	if self.normal_armature_effic ~= nil then
		self.normal_armature_effic._invoke = nil
		self.normal_armature_effic = nil
	end

	self.animation_index,self.effic_id = self:getSkillAnimationIndex()		

	local ship = fundShipWidthId(self.ship.ship_id)
	local quality = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.ship_type)
	----------------------新的数码的形象------------------------
	--进化形象
	local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	--进化模板id
	local ship_evo = zstring.split(ship.evolution_status, "|")
	local evo_mould_id = smGetSkinEvoIdChange(ship)
	--新的形象编号
	local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
	if self.isUpdateShowShip == true then
		Panel_1_4:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_1_4, nil, nil, cc.p(0.5, 0))
		app.load("client.battle.fight.FightEnum")
		local armature_hero = sp.spine_sprite(Panel_1_4, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
			Panel_1_4:removeAllChildren(true)
		    Panel_1_4:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", temp_bust_index))
		end
		armature_hero:setScaleX(-1)
		self.armature_hero = armature_hero
		armature_hero.animationNameList = spineAnimations
		sp.initArmature(self.armature_hero, true)
	    local function changeActionCallback( armatureBack )
			-- if self.play_index == 14 then
			-- 	if self ~= nil and self.roots ~= nil then
			-- 		state_machine.excute("formation_hero_develop_play_hero_animation",0,self.animation_index)
			-- 	end
			-- elseif self.play_index == 38 then
			-- 	if self ~= nil and self.roots ~= nil then
			-- 		state_machine.excute("formation_hero_develop_play_hero_animation",0,14)
			-- 	end
			-- elseif self.play_index == self.animation_index then
			-- 	if self ~= nil and self.roots ~= nil then
			-- 		state_machine.excute("formation_hero_develop_play_hero_animation",0,0)
			-- 	end
			-- end	
	    end
	    local actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
	    local actionIndexs = {
	    	_enum_animation_l_frame_index.animation_standby,
	    	-- _enum_animation_l_frame_index.animation_skill_attacking,
	    	-- _enum_animation_l_frame_index.animation_power_skill_attacking,
	    	-- _enum_animation_l_frame_index.animation_new_skill_13_jueji
		}
		actionIndex = actionIndexs[math.random(1, #actionIndexs)]

	    armature_hero._self = self
	    armature_hero:getAnimation():setFrameEventCallFunc(onFrameEventRole)
	    armature_hero._invoke = changeActionCallback
	    armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	    csb.animationChangeToAction(self.armature_hero, actionIndex, 0, false)
	    armature_hero._nextAction = 0

	    local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
	    Panel_strengthen_stye:removeBackGroundImage()
	    local camp_preference = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.camp_preference)
	    if camp_preference> 0 and camp_preference <=3 then
	        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
	    end

	    local Panel_constellation_star_icon = ccui.Helper:seekWidgetByName(root, "Panel_constellation_star_icon")
	    if Panel_constellation_star_icon ~= nil then
	    	Panel_constellation_star_icon:removeBackGroundImage()
	    	local constellation_type = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.hero_gender)
		    if tonumber(constellation_type) and tonumber(constellation_type) ~= 0 then
		    	if Panel_constellation_star_icon ~= nil then
		    		Panel_constellation_star_icon:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/xz_sx_icon_%d.png", tonumber(constellation_type)))
		    	end
		    end
	    end
	    -- local constellation_type = 1
	    -- for i=1,#dms["constellation_mould"] do
	    -- 	local constellation_info = dms.element(dms["constellation_mould"], i)
	    -- 	local all_ships = dms.atos(constellation_info, constellation_mould.constellation_ship_id)
	    -- 	for i,v in ipairs(zstring.split(all_ships, ",")) do
	    -- 		if zstring.tonumber(ship.ship_template_id) == zstring.tonumber(v) then
	    -- 			constellation_type = constellation_info[constellation_mould.constellation_ship_type]
	    -- 			break
	    -- 		end
	    -- 	end
	    -- end
	    
		-- if self.effic_id ~= nil then
		-- 	local armature_effic = sp.spine_effect(self.effic_id, effectAnimations[1], false, nil, nil, nil)	
		-- 	self.armature_effic = armature_effic
		-- 	sp.initArmature(self.armature_effic, false)
		-- 	armature_effic.animationNameList = effectAnimations
		-- 	self.armature_effic:setVisible(false)
		-- 	armature_hero:addChild(armature_effic)
		--     local function changeActionEfficCallback( armatureBack )	
		-- 		armatureBack:setVisible(false)
		--     end
		--     armature_effic._invoke = changeActionEfficCallback
		--     armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)			    		
		-- end

		-- if self.normal_effic_id ~= nil then
		-- 	local normal_armature_effic = sp.spine_effect(self.normal_effic_id, effectAnimations[1], false, nil, nil, nil)	
		-- 	self.normal_armature_effic = normal_armature_effic
		-- 	sp.initArmature(self.normal_armature_effic, false)
		-- 	normal_armature_effic.animationNameList = effectAnimations
		-- 	self.normal_armature_effic:setVisible(false)
		-- 	armature_hero:addChild(normal_armature_effic)
		--     local function changeActionEfficCallback( armatureBack )	
		-- 		armatureBack:setVisible(false)
		--     end
		--     normal_armature_effic._invoke = changeActionEfficCallback
		--     normal_armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)	
		-- end

		local shipid = tonumber(ship.ship_template_id)
		local soundid = dms.string(dms["ship_mould"], shipid, ship_mould.sound_index)
		playEffectExt(formatMusicFile("effect", soundid))
	end
	-- state_machine.excute("formation_hero_develop_play_hero_animation",0,"begin")
	--战斗力
	local Text_all_fight_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_all_fight_n")
	local allfight = 0
	for i = 2, 7 do
		local shipId = _ED.formetion[i]
		if zstring.tonumber(shipId) > 0 then
			local currShip = getShipByTalent(_ED.user_ship[""..shipId])
			local hero_fight = tonumber(currShip.hero_fight)
			allfight = allfight + hero_fight
		end
	end
	Text_all_fight_n:setString(allfight)

	for i=1,7 do
		local Image_star = ccui.Helper:seekWidgetByName(self.roots[1], "Image_star_"..i)
		Image_star:setVisible(false)
	end
	local StarRating = tonumber(ship.StarRating)
    if StarRating > 0 and StarRating <= 7 then
        for i=1, StarRating do
            local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
            Image_star:setVisible(true)
        end
    end

    local Panel_role_up_text = ccui.Helper:seekWidgetByName(root, "Panel_role_up_text")
    Panel_role_up_text:removeBackGroundImage()
    local level_groun_icon = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.level_groun_icon)
   	Panel_role_up_text:setBackGroundImage(string.format("images/ui/text/sm_role_up_%d.png", level_groun_icon))
end

--新项目的绘制形象方法（24，25项目）
function FormationTigerGate:newFormationShowShipChange(evoIndex)
	local root = self.roots[1]
	if self.ship == nil then
		return
	end
	local Panel_1_4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_1_4")
	-- Panel_1_4:setTouchEnabled(false)
	
	local ship = fundShipWidthId(self.ship.ship_id)
	----------------------新的数码的形象------------------------
	--进化形象
	local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	evoIndex = evoIndex or 1
	evoIndex = (evoIndex - 1) % #evo_info + 1
	evoIndex = math.abs(evoIndex)
	--进化模板id
	local ship_evo = zstring.split(ship.evolution_status, "|")
	local evo_mould_id = smGetSkinEvoIdChange(ship)
	--新的形象编号
	local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
	if self.isUpdateShowShip == true then
		Panel_1_4:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_1_4, nil, nil, cc.p(0.5, 0))
		app.load("client.battle.fight.FightEnum")
		local armature_hero = sp.spine_sprite(Panel_1_4, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		armature_hero:setScaleX(-1)
		self.armature_hero = armature_hero
		armature_hero.animationNameList = spineAnimations
		sp.initArmature(self.armature_hero, true)
	    local function changeActionCallback( armatureBack )
			
	    end

	    local actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
	    local actionIndexs = {
	    	_enum_animation_l_frame_index.animation_standby,
	    	_enum_animation_l_frame_index.animation_skill_attacking,
	    	_enum_animation_l_frame_index.animation_power_skill_attacking,
	    	-- _enum_animation_l_frame_index.animation_new_skill_13_jueji
		}
		actionIndex = actionIndexs[math.random(1, #actionIndexs)]

	    armature_hero._self = self
	    armature_hero:getAnimation():setFrameEventCallFunc(onFrameEventRole)
	    armature_hero._invoke = changeActionCallback
	    armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	    csb.animationChangeToAction(self.armature_hero, actionIndex, 0, false)

	    -- local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
	    -- Panel_strengthen_stye:removeBackGroundImage()
	    -- local camp_preference = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.camp_preference)
	    -- if camp_preference> 0 and camp_preference <=3 then
	    --     Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
	    -- end

		-- if self.effic_id ~= nil then
		-- 	local armature_effic = sp.spine_effect(self.effic_id, effectAnimations[1], false, nil, nil, nil)	
		-- 	self.armature_effic = armature_effic
		-- 	sp.initArmature(self.armature_effic, false)
		-- 	armature_effic.animationNameList = effectAnimations
		-- 	self.armature_effic:setVisible(false)
		-- 	armature_hero:addChild(armature_effic)
		--     local function changeActionEfficCallback( armatureBack )	
		-- 		armatureBack:setVisible(false)
		--     end
		--     armature_effic._invoke = changeActionEfficCallback
		--     armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)			    		
		-- end

		-- if self.normal_effic_id ~= nil then
		-- 	local normal_armature_effic = sp.spine_effect(self.normal_effic_id, effectAnimations[1], false, nil, nil, nil)	
		-- 	self.normal_armature_effic = normal_armature_effic
		-- 	sp.initArmature(self.normal_armature_effic, false)
		-- 	normal_armature_effic.animationNameList = effectAnimations
		-- 	self.normal_armature_effic:setVisible(false)
		-- 	armature_hero:addChild(normal_armature_effic)
		--     local function changeActionEfficCallback( armatureBack )	
		-- 		armatureBack:setVisible(false)
		--     end
		--     normal_armature_effic._invoke = changeActionEfficCallback
		--     normal_armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)	
		-- end

		local shipid = tonumber(ship.ship_template_id)
		local soundid = dms.string(dms["ship_mould"], shipid, ship_mould.sound_index)
		playEffectExt(formatMusicFile("effect", soundid))
	end
end

function FormationTigerGate:changeHeroAnimation(play_type)
	if play_type == "begin" then
		self.play_index = 38 
	else
		self.play_index = tonumber(play_type)
	end
	if self.armature_hero == nil then
		return
	end

	-- print("==============",self.play_index,self.armature_effic)
	if self.armature_effic ~= nil and self.play_index == self.animation_index then
		self.armature_effic:setVisible(true)
		csb.animationChangeToAction(self.armature_effic, 0,0, false)
	end	
	local ship = fundShipWidthId(self.shipId)
	if self.normal_armature_effic ~= nil and self.play_index == 38 and self.play_index == 14 and tonumber(ship.captain_type) == 0 then
		self.normal_armature_effic:setVisible(true)
		csb.animationChangeToAction(self.normal_armature_effic, 0,0, false)
	end

	csb.animationChangeToAction(self.armature_hero, self.play_index, self.play_index, false)
end

function FormationTigerGate:getSkillAnimationIndex()
	if self.ship == nil then
		-- print("===================111111111111")
		return
	end

	local ship = fundShipWidthId(self.ship.ship_id)
	if ship == nil then
		-- print("===================2222222222222")
		return
	end
	if tonumber(ship.captain_type) ~= 0 then
		return 15,nil
	end	

	for j,k in pairs(_ED.user_ship) do
		if tonumber(k.captain_type) == 0 then
			--学艺技能
			for i , v in pairs(_ED.user_skill_equipment) do
			   if tonumber(v.equip_state) == 1 then
			   		local skillEquipment = dms.element(dms["skill_equipment_mould"],v.skill_equipment_base_mould)
			   		local skill_mould_id = dms.atoi(skillEquipment,skill_equipment_mould.skill_equipment_base_mould)
			   		local health_affects = dms.string(dms["skill_mould"],skill_mould_id,skill_mould.health_affect)
			   		-- print("============",health_affects)
			   		local health_affect = zstring.split(health_affects, ",")
			   		-- print("============",health_affect)
			   		
					-- debug.print_r(health_affect)
			   		for i,v in pairs(health_affect) do
			   			local skill_influenceID = tonumber(health_affect[i])
			   			local skill_category = dms.int(dms["skill_influence"], skill_influenceID, skill_influence.skill_category)
			   			if (tonumber(skill_category) == 0 or tonumber(skill_category) == 1) then
							local after_actions = dms.int(dms["skill_influence"],skill_influenceID,skill_influence.after_action)
			   				local effic_id = dms.int(dms["skill_influence"],skill_influenceID,skill_influence.posterior_lighting_effect_id)			   				
			   				-- print("==========",after_actions,effic_id)
			   				return after_actions,effic_id
			   			end
			   		end
			   end
			end
		end
	end
	return 15,nil
end

-- 更新小伙伴界面的所有伙伴信息的绘制(援军)
function FormationTigerGate:updateDrawPartnerView()
	local root = self.roots[1]
	-- 上阵小伙伴头像位
	local heroPartnerPlace = {
		ccui.Helper:seekWidgetByName(root, "Panel_40"),
		ccui.Helper:seekWidgetByName(root, "Panel_40_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_40_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_40_0"),
		ccui.Helper:seekWidgetByName(root, "Panel_40_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_40_4"),
	}
	local heroPartnerNamePlace = {
		ccui.Helper:seekWidgetByName(root, "Text_43"),
		ccui.Helper:seekWidgetByName(root, "Text_43_1"),
		ccui.Helper:seekWidgetByName(root, "Text_43_3"),
		ccui.Helper:seekWidgetByName(root, "Text_43_0"),
		ccui.Helper:seekWidgetByName(root, "Text_43_2"),
		ccui.Helper:seekWidgetByName(root, "Text_43_4"),
	}
	-- 上阵小伙伴羁绊位
	local partnershipPlace = {
		ccui.Helper:seekWidgetByName(root, "Panel_46"),
		ccui.Helper:seekWidgetByName(root, "Panel_46_0"),
		ccui.Helper:seekWidgetByName(root, "Panel_46_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_46_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_46_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_46_4"),
	}
	local partnerScrollView = ccui.Helper:seekWidgetByName(root, "ListView_4")
	partnerScrollView:removeAllItems()

	local heroPlace = nil
	for i=1, 6 do
		heroPlace = heroPartnerPlace[i]
		heroPlace:removeChild(heroPlace._nodeChild, true)
		heroPlace._nodeChild = nil
		heroPartnerNamePlace[i]:setString(" ")

		local shipPlace = partnershipPlace[i]
		shipPlace:removeChild(shipPlace._nodeChild, true)
		shipPlace._nodeChild = nil

		local shipId = _ED.user_formetion_status[i]
		local shipInfo = _ED.user_ship[shipId]
		if zstring.tonumber(shipId) > 0 then
			local cell = self:createShipPartnerPlace(shipInfo)
			shipPlace._nodeChild = cell
			shipPlace:addChild(cell)

			if dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.relationship_id) ~= "" then
				local cell = self:createPartnerScroll(shipInfo)
				partnerScrollView:addChild(cell)
			end
		end
	end

	for i, v in pairs(_ED.little_companion_state) do
		heroPlace = heroPartnerPlace[i]
		if heroPlace ~= nil then
			local heroName = heroPartnerNamePlace[i]
			if heroPlace ~= nil then
				if zstring.tonumber(v) > 0 then--有武将
					local cell = self:createShipHeadIcon(fundShipWidthId(v),7)
					heroPlace._nodeChild = cell
					heroPlace:addChild(cell)
					heroName:setString(fundShipWidthId(v).captain_name)
					local quality = dms.int(dms["ship_mould"], fundShipWidthId(v).ship_template_id, ship_mould.ship_type)+1
					heroName:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				elseif zstring.tonumber(v) == -1 then--未开启
					local lockcell = self:createLockAction(1,i)
					heroPlace._nodeChild = lockcell
					heroPlace:addChild(lockcell)
				else--开启了没武将
					local addcell = self:createAddActionCell(3,i)
					heroPlace._nodeChild = addcell
					heroPlace:addChild(addcell)
				end
			end
		end
	end
	
	partnerScrollView:requestRefreshView()
end

function FormationTigerGate:showHeroPartners(_show)
	if _show == true then
		state_machine.excute("hero_develop_page_hidden_nowpage",0,"")
	else
		state_machine.excute("hero_develop_page_show_nowpage",0,"")
	end
	local root = self.roots[1]
	local xiaohuobanPanelMain = ccui.Helper:seekWidgetByName(root, "Panel_122")
	xiaohuobanPanelMain:setVisible(_show)
	state_machine.excute("response_fate_effect_return",0,"")
end

function FormationTigerGate:UpdateButtonDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	if #self._m_button_list_y > 1 then
		local Button_zhenrong = ccui.Helper:seekWidgetByName(root, "Button_zhenrong")
		local Button_line_shengji = ccui.Helper:seekWidgetByName(root, "Button_line_shengji")
		local Button_line_peiyang = ccui.Helper:seekWidgetByName(root, "Button_line_peiyang")
		local Button_line_tianming = ccui.Helper:seekWidgetByName(root, "Button_line_tianming")
		local Button_line_tupo = ccui.Helper:seekWidgetByName(root, "Button_line_tupo")
		local Button_line_douhun = ccui.Helper:seekWidgetByName(root, "Button_line_douhun")
		local Button_line_chaojinhua = ccui.Helper:seekWidgetByName(root, "Button_line_chaojinhua")
		local Button_line_zhanhun = ccui.Helper:seekWidgetByName(root, "Button_line_zhanhun")

		local index = 1
		--根据功能进行排序和显示
		if Button_line_shengji ~= nil then
			if funOpenDrawTip(100,false) == true then
				Button_line_shengji:setVisible(false)
			else
				Button_line_shengji:setVisible(true)
				index = index + 1
				Button_line_shengji:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_line_peiyang ~= nil then
			if funOpenDrawTip(102,false) == true then
				Button_line_peiyang:setVisible(false)
			else
				Button_line_peiyang:setVisible(true)
				index = index + 1
				Button_line_peiyang:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_line_tianming ~= nil then
			if funOpenDrawTip(103,false) == true then
				Button_line_tianming:setVisible(false)
			else
				Button_line_tianming:setVisible(true)
				index = index + 1
				Button_line_tianming:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_line_tupo ~= nil then
			if funOpenDrawTip(101,false) == true then
				Button_line_tupo:setVisible(false)
			else
				Button_line_tupo:setVisible(true)
				index = index + 1
				Button_line_tupo:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_line_zhanhun ~= nil then
			if funOpenDrawTip(201,false) == true then
				Button_line_zhanhun:setVisible(false)
			else
				Button_line_zhanhun:setVisible(true)
				index = index + 1
				Button_line_zhanhun:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_line_douhun ~= nil then
			if funOpenDrawTip(104,false) == true then
				Button_line_douhun:setVisible(false)
			else
				Button_line_douhun:setVisible(true)
				index = index + 1
				Button_line_douhun:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_line_chaojinhua ~= nil then
			if funOpenDrawTip(189,false) == true then
				Button_line_chaojinhua:setVisible(false)
			else
				Button_line_chaojinhua:setVisible(true)
				index = index + 1
				Button_line_chaojinhua:setPositionY(self._m_button_list_y[index])
			end
		end
	end
end

-- 改变更换/布阵按钮的状态和位置
function FormationTigerGate:updateChangeFormationButtonState()
	local root = self.roots[1]

	local formationIsFull = JudgeFormetionLineIsFull()

	if __lua_project_id == __lua_project_l_digital then
		-- 更换
		local Button_5_1 = ccui.Helper:seekWidgetByName(root, "Button_5_1")
		-- 布阵
		local Button_2 = ccui.Helper:seekWidgetByName(root, "Button_2")

		if Button_5_1 ~= nil and Button_2 ~= nil then
			if self.formationBtnPosX == nil then
				self.formationBtnPosX = Button_2:getPositionX()
			end

			local midPosX = self.formationBtnPosX - (self.formationBtnPosX - Button_5_1:getPositionX()) / 2

			if formationIsFull == false then
				Button_5_1:setVisible(false)
				Button_2:setPositionX(midPosX)
			else
				Button_5_1:setVisible(true)
				Button_2:setPositionX(self.formationBtnPosX)
			end
		end
	end
end

function FormationTigerGate:onEnterTransitionFinish()
	local root = self.roots[1]
	local csbFormation = root:getParent()
	self.actions = {}
	local action = csb.createTimeline("formation/line_up.csb")
	table.insert(self.actions, action)
	csbFormation:runAction(action)
	if fwin:find("PathGrowthClass") then
		fwin:close(fwin:find("PathGrowthClass"))
	end
	if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
        protocol_command.education_change.param_list = "520"
        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
        end
    end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		local file_path = "images/ui/effice/effect_line/effect_line.ExportJson"
		local armature_name = "effect_line"
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(file_path)
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_armatureNode")
		panel:removeAllChildren(true)
		local cell = ccs.Armature:create(armature_name)
		cell:getAnimation():playWithIndex(0)
		panel:addChild(cell)
		action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "open" then
	        	fwin:find("HeroIconListViewClass"):setVisible(true)
				
				-- iphone刘海适配
				local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
				if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
					if Image_1 then 
						Image_1:setPositionX(Image_1:getPositionX()+80)
					end
				end
	        elseif str == "close" then
	            state_machine.excute("formation_back_to_home_page", 0, 0)
	            if tonumber(_ED.npc_max_state[8]) == 1 and tonumber(_ED.npc_max_state[9]) == -1 then
	            	executeMissionExt(mission_mould_tuition, touch_off_mission_back, "gc1", nil, true, "gc666", false)
	            elseif tonumber(_ED.npc_max_state[10]) == 1 and tonumber(_ED.npc_max_state[11]) == -1 then
	            	executeMissionExt(mission_mould_tuition, touch_off_mission_back, "gc2", nil, true, "gc666", false)
				end
	        end
	        
	    end)
	    local Panel_effect_bg = ccui.Helper:seekWidgetByName(root, "Panel_effect_bg")
	    if Panel_effect_bg ~= nil then
	    	Panel_effect_bg:removeAllChildren(true)
			local jsonFile = "images/ui/effice/effect_zhenrong/effect_zhenrong.json"
			local atlasFile = "images/ui/effice/effect_zhenrong/effect_zhenrong.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		    Panel_effect_bg:addChild(animation)
	    end
	end
	-- action:setFrameEventCallFunc(function (frame)
 --        if nil == frame then
 --            return
 --        end
 --        local str = frame:getEvent()
 --        if str == "window_open_over" then

	-- 		-- TODO...

	-- 		-- app.load("client.formation.HeroInformation")
	-- 		-- state_machine.excute("hero_information_open_window", 0, self.ship)
 --        elseif str == "window_close_over" then
 --            self:onClose()
 --        end
 --    end)
	app.load("client.player.UserInformationHeroStorage")
	if fwin:find("UserInformationHeroStorageClass") == nil then
		fwin:open(UserInformationHeroStorage:new(), fwin._ui)
	end
	-- local shipid = tonumber(self.ship.ship_template_id)
	-- local soundid = dms.string(dms["ship_mould"], shipid, ship_mould.sound_index)
	-- playEffectExt(formatMusicFile("effect", soundid))				
	-- state_machine.excute("Lformation_ship_cell_play_hero_animation",0,{"begin"})
	-- 返回
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zr_back"), nil, 
		{	
			terminal_name = "formation_back_to_home_activity", 
			terminal_state = 0,
			isPressedActionEnabled = true}, 
		nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zr_back"), nil, 
		{	
			terminal_name = "formation_back_to_home_page", 
			terminal_state = 0,
			isPressedActionEnabled = true}, 
		nil, 0)
	end
	-- 时装
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_0"), nil, 
	{
		terminal_name = "formation_hero_wear_click", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)
	-- 强化
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_line_qianghua"), nil, 
	{
		terminal_name = "formation_go_to_hero_herodevelop", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_ship_strengthen_button",
			_widget = ccui.Helper:seekWidgetByName(root,"Button_line_qianghua"),
			_invoke = nil,
			_interval = 0.5,})
		state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_strengthen_button")
	end
	-- 强化大师
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, 
	{
		terminal_name = "formation_show_strengthen_master",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)
	-- 替换
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_1"), nil, 
	{
		terminal_name = "replacement_battle_hero_request",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)
	-- 布阵
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "formation_page_formation_change", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)

	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.MythicalAnimals)
	if fun_is_open == true then
		local Button_animals = ccui.Helper:seekWidgetByName(root, "Button_animals")
		Button_animals:setVisible(false)

		app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsHandle")
		local animalsInfo = MythicalAnimalsHandle.getAllMythicalAnimalsInfo()
		if table.nums(animalsInfo) > 0 then
			Button_animals:setVisible(true)
			-- 神兽技能配置
			fwin:addTouchEventListener(Button_animals, nil, 
			{
				terminal_name = "formation_open_animal_skill_ui", 
				terminal_state = 0,
				isPressedActionEnabled = true
			}, nil, 0)
		end
	end

	local Button_xiazhen = ccui.Helper:seekWidgetByName(root, "Button_xiazhen")
	if Button_xiazhen ~= nil then
		if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			Button_xiazhen:setVisible(false)
		else
			Button_xiazhen:setVisible(true)
			fwin:addTouchEventListener(Button_xiazhen, nil, 
			{
				terminal_name = "formation_page_teshu_formation_change", 
				terminal_state = 0,
				isPressedActionEnabled = true
			}, nil, 0)
		end
	end
	-- 援军
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_yuanjun"), nil, 
	{
		terminal_name = "formation_hero_partners_show_or_hidden", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_show = true
	},
	nil,0)
	-- 关闭援军
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_xhb_back"), nil, 
	{
		terminal_name = "formation_hero_partners_show_or_hidden", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_show = false
	},
	nil,0)
	-- 缘分返回
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_0"), nil, 
	{
		terminal_name = "response_fate_effect_return", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)
	-- 缘分
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
	{
		terminal_name = "response_fate_effect", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)

	fwin:addTouchEventListener( ccui.Helper:seekWidgetByName(root, "Button_change_skills"), nil, 
	{
		terminal_name = "formation_go_to_change_pack", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)
	-- action:play("window_open", false)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_r"), nil, 
	{
		terminal_name = "formation_turn_page", 
		terminal_state = 0,
		types = "right",
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_l"), nil, 
	{
		terminal_name = "formation_turn_page", 
		terminal_state = 0,
		types = "left",
		isPressedActionEnabled = true
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_17"), nil, 
	{
		terminal_name = "formation_to_one_key_equipment", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	local awakenButton = ccui.Helper:seekWidgetByName(root, "Button_juexing_rukou")
	--觉醒
	fwin:addTouchEventListener(awakenButton, nil, 
	{
		terminal_name = "formation_go_to_hero_awaken", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	-- local requirement = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.base_mould2) --能否觉醒
	-- if requirement ~= -1 then 
	-- 	--可以觉醒
	-- 	awakenButton:setTouchEnabled(true)
	-- 	awakenButton:setVisible(true)
	-- else
	-- 	awakenButton:setVisible(false)
	-- end
	self:updateDrawSkillIcon()

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		--进化
		local Button_evo = ccui.Helper:seekWidgetByName(self.roots[1], "Button_evo")
		if Button_evo ~= nil then
			fwin:addTouchEventListener(Button_evo, nil, 
			{
				terminal_name = "formation_go_to_hero_evolution", 
				terminal_state = 0,
				-- ship = self.ship,
				isPressedActionEnabled = true
			}, 
			nil, 0)
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_ship_evo",
				_widget = Button_evo,
				_invoke = nil,
				_interval = 0.5,})
		-- state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_evo")
		end

		local Button_rebirth = ccui.Helper:seekWidgetByName(root,"Button_rebirth")
		local Button_fashion = ccui.Helper:seekWidgetByName(root,"Button_fashion")
		local Button_matrix = ccui.Helper:seekWidgetByName(root,"Button_matrix")
		if Button_rebirth ~= nil then
			if funOpenDrawTip(175, false) == false then
				Button_rebirth:setVisible(true)
			else
				Button_rebirth:setVisible(false)
			end
		    fwin:addTouchEventListener(Button_rebirth, nil, 
		    {
		        terminal_name = "formation_go_to_open_rebrith",
		        terminal_state = 0,
		        isPressedActionEnabled = true
		    },
		    nil,0)
		end
		--皮肤入口
		if Button_fashion ~= nil then
			if funOpenDrawTip(176, false) == false then
				Button_fashion:setVisible(true)
			else
				Button_fashion:setVisible(false)
			end
		    fwin:addTouchEventListener(Button_fashion, nil, 
		    {
		        terminal_name = "formation_go_to_open_fashion",
		        terminal_state = 0,
		        isPressedActionEnabled = true
		    },
		    nil,0)
		end

		--合金入口
		if Button_matrix ~= nil then
			if funOpenDrawTip(126, false) == false then
				Button_matrix:setVisible(true)
			else
				Button_matrix:setVisible(false)
			end
		    fwin:addTouchEventListener(Button_matrix, nil, 
		    {
		        terminal_name = "formation_go_to_open_matrix",
		        terminal_state = 0,
		        isPressedActionEnabled = true
		    },
		    nil,0)
		end
		
		-- 究极潜力
		local Button_energy = ccui.Helper:seekWidgetByName(root, "Button_energy")
		if Button_energy then
			Button_energy:setVisible(false)
			fwin:addTouchEventListener(Button_energy, nil, 
		    {
		        terminal_name = "formation_go_to_open_energy",
		        terminal_state = 0,
		        isPressedActionEnabled = true
		    },
		    nil, 0)
		end

		--武将信息
		local Panel_info = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_info")
		if Panel_info ~= nil then
			fwin:addTouchEventListener(Panel_info, nil, 
			{
				terminal_name = "formation_go_to_hero_data_info", 
				terminal_state = 0,
				-- ship = self.ship,
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end
		local Button_tip = ccui.Helper:seekWidgetByName(self.roots[1], "Button_tip")
		if Button_tip ~= nil then
			fwin:addTouchEventListener(Button_tip, nil, 
			{
				terminal_name = "formation_go_to_hero_data_info", 
				terminal_state = 0,
				-- ship = self.ship,
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end

		--切换武将进化形象动画按钮-left
		local Button_arrow_change_left = ccui.Helper:seekWidgetByName(self.roots[1], "Button_arrow_change_left")
		if Button_arrow_change_left ~= nil then
			fwin:addTouchEventListener(Button_arrow_change_left, nil, 
			{
				terminal_name = "formation_change_hero_sprite_info_left", 
				terminal_state = 0,
				-- ship = self.ship,
				isPressedActionEnabled = true
			}, 
			nil, 0)
			Button_arrow_change_left:setVisible(false)
		end

		--切换武将进化形象动画按钮-right
		local Button_arrow_change_right = ccui.Helper:seekWidgetByName(self.roots[1], "Button_arrow_change_right")
		if Button_arrow_change_right ~= nil then
			fwin:addTouchEventListener(Button_arrow_change_right, nil, 
			{
				terminal_name = "formation_change_hero_sprite_info_right", 
				terminal_state = 0,
				-- ship = self.ship,
				isPressedActionEnabled = true
			}, 
			nil, 0)
			Button_arrow_change_right:setVisible(false)
		end

		-- 随机播放动画
		local Panel_1_4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_1_4")
		if Panel_1_4 ~= nil then
			fwin:addTouchEventListener(Panel_1_4, nil, 
			{
				terminal_name = "formation_change_hero_sprite_info_play_animation", 
				terminal_state = 0,
				-- ship = self.ship,
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end

		local Button_zhenrong = ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhenrong")
		if Button_zhenrong ~= nil then
			if Button_zhenrong._y == nil then
				Button_zhenrong._y = Button_zhenrong:getPositionY()
			end
			fwin:addTouchEventListener(Button_zhenrong, nil, 
			{
				terminal_name = "formation_switch_paging_information", 
				terminal_state = 0,
				_page = 1
			}, 
			nil, 0)
			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_ship_formation",
			-- 	_widget = Button_zhenrong,
			-- 	_invoke = nil,
			-- 	_interval = 0.5,})
		end

		--超进化
        local Button_chaojinhua = ccui.Helper:seekWidgetByName(self.roots[1], "Button_line_chaojinhua")
		if Button_chaojinhua ~= nil then
			if Button_chaojinhua._y == nil then
				Button_chaojinhua._y = Button_chaojinhua:getPositionY()
			end
			fwin:addTouchEventListener(Button_chaojinhua, nil, 
			{
				terminal_name = "formation_switch_paging_information", 
				terminal_state = 0,
				_page = 9
			}, 
			nil, 0)
			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_mega",
			-- 	_widget = Button_chaojinhua,
			-- 	_invoke = nil,
			-- 	_interval = 0.5,})
		end

		--战魂
		local Button_line_zhanhun = ccui.Helper:seekWidgetByName(self.roots[1], "Button_line_zhanhun")
		if Button_line_zhanhun ~= nil then
			if Button_line_zhanhun._y == nil then
				Button_line_zhanhun._y = Button_line_zhanhun:getPositionY()
			end
			fwin:addTouchEventListener(Button_line_zhanhun, nil, 
			{
				terminal_name = "formation_switch_paging_information", 
				terminal_state = 0,
				_page = 10
			}, 
			nil, 0)
		end
	

		--进阶
		local Button_line_shengji = ccui.Helper:seekWidgetByName(self.roots[1], "Button_line_shengji")
		if Button_line_shengji ~= nil then
			if Button_line_shengji._y == nil then
				Button_line_shengji._y = Button_line_shengji:getPositionY()
			end
			fwin:addTouchEventListener(Button_line_shengji, nil, 
			{
				terminal_name = "formation_switch_paging_information", 
				terminal_state = 0,
				_page = 4
			}, 
			nil, 0)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_evolution_page_tip",
				_widget = Button_line_shengji,
				_invoke = nil,
				_interval = 0.5,})
			end
		end
		--升级
		local Button_line_tupo = ccui.Helper:seekWidgetByName(self.roots[1], "Button_line_tupo")
		if Button_line_tupo ~= nil then
			if Button_line_tupo._y == nil then
				Button_line_tupo._y = Button_line_tupo:getPositionY()
			end
			fwin:addTouchEventListener(Button_line_tupo, nil, 
			{
				terminal_name = "formation_switch_paging_information", 
				terminal_state = 0,
				_page = 5
			}, 
			nil, 0)
		end
		--升星
		local Button_line_peiyang = ccui.Helper:seekWidgetByName(self.roots[1], "Button_line_peiyang")
		if Button_line_peiyang ~= nil then
			if Button_line_peiyang._y == nil then
				Button_line_peiyang._y = Button_line_peiyang:getPositionY()
			end
			fwin:addTouchEventListener(Button_line_peiyang, nil, 
			{
				terminal_name = "formation_switch_paging_information", 
				terminal_state = 0,
				_page = 6
			}, 
			nil, 0)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_up_grade_star_page_tip",
				_widget = Button_line_peiyang,
				_invoke = nil,
				_interval = 0.5,})
			end
		end

		--技能
		local Button_line_tianming = ccui.Helper:seekWidgetByName(self.roots[1], "Button_line_tianming")
		if Button_line_tianming ~= nil then
			if Button_line_tianming._y == nil then
				Button_line_tianming._y = Button_line_tianming:getPositionY()
			end
			fwin:addTouchEventListener(Button_line_tianming, nil, 
			{
				terminal_name = "formation_switch_paging_information", 
				terminal_state = 0,
				_page = 7
			}, 
			nil, 0)
			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equip_awake",
			-- 	_widget = Button_line_shengji,
			-- 	_invoke = nil,
			-- 	_interval = 0.5,})
		end

		--斗魂
		local Button_line_douhun = ccui.Helper:seekWidgetByName(self.roots[1], "Button_line_douhun")
		if Button_line_douhun ~= nil then
			if Button_line_douhun._y == nil then
				Button_line_douhun._y = Button_line_douhun:getPositionY()
			end
			fwin:addTouchEventListener(Button_line_douhun, nil, 
			{
				terminal_name = "formation_switch_paging_information", 
				terminal_state = 0,
				_page = 8
			}, 
			nil, 0)
			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equip_awake",
			-- 	_widget = Button_line_shengji,
			-- 	_invoke = nil,
			-- 	_interval = 0.5,})
		end

		--记录10个按钮的位置
		self._m_button_list_y = {}
		if Button_zhenrong ~= nil then
			table.insert(self._m_button_list_y, Button_zhenrong._y)
		end
		if Button_line_shengji ~= nil then
			table.insert(self._m_button_list_y, Button_line_shengji._y)
		end
		if Button_line_peiyang ~= nil then
			table.insert(self._m_button_list_y, Button_line_peiyang._y)
		end
		if Button_line_tianming ~= nil then
			table.insert(self._m_button_list_y, Button_line_tianming._y)
		end
		if Button_line_tupo ~= nil then
			table.insert(self._m_button_list_y, Button_line_tupo._y)
		end
		if Button_line_zhanhun ~= nil then
			table.insert(self._m_button_list_y, Button_line_zhanhun._y)
		end
		if Button_line_douhun ~= nil then
			table.insert(self._m_button_list_y, Button_line_douhun._y)
		end
		if Button_chaojinhua ~= nil then
			table.insert(self._m_button_list_y, Button_chaojinhua._y)
		end   
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			if Button_line_shengji ~= nil then
				self:UpdateButtonDraw()
			end
			self:changeSelectPage(1)
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_digimon_qh/effice_digimon_qh.ExportJson")
	end
end
function FormationTigerGate:updateDrawSkillIcon(pic_id)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		return
	end
	local Panel_skills_icon = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_skills_icon")
	Panel_skills_icon:removeBackGroundImage()
	if pic_id ~= nil then
		local skills_picIndex = dms.int(dms["skill_equipment_mould"],pic_id,skill_equipment_mould.pic)
		Panel_skills_icon:setBackGroundImage(string.format("images/ui/skills_props/skills_props_%d.png",skills_picIndex))
	else
		local skill_id = 1
        for i , v in pairs(_ED.user_skill_equipment) do  
        	if tonumber(v.equip_state) ==  1 then
        		skill_id = tonumber(v.skill_equipment_base_mould)
            	break
        	end
        end 
        local skills_picIndex = dms.int(dms["skill_equipment_mould"],skill_id,skill_equipment_mould.pic)
		Panel_skills_icon:setBackGroundImage(string.format("images/ui/skills_props/skills_props_%d.png",skills_picIndex))
	end
end
function FormationTigerGate:onClose()
	state_machine.unlock("formation_back_to_home_page", 0, "")
	state_machine.unlock("formation_back_to_home_activity", 0, "")
	fwin:close(self)
	cacher.destoryRefPools()
	cacher.removeAllTextures()

	state_machine.excute("menu_clean_page_state", 0, "") 
	state_machine.excute("menu_back_home_page", 0, "") 
	state_machine.excute("home_hero_refresh_draw", 0, "")
	state_machine.excute("prop_warehouse_update_draw_page", 0, nil)
end

function FormationTigerGate:playCloseAction()
	local action = self.actions[1]
    if fwin:find("UserInformationHeroStorageClass") ~= nil then
		fwin:close(fwin:find("UserInformationHeroStorageClass"))
	end
    self:onClose()

	if _ED.lduplicate_window_go_fotmation_info ~= nil 
		and _ED.lduplicate_window_go_fotmation_info.sceneType ~= nil 
		and _ED.lduplicate_window_go_fotmation_info.sceneId ~= nil 
		and zstring.tonumber(_ED.lduplicate_window_go_fotmation_info.sceneId) > 0
		and zstring.tonumber(_ED.lduplicate_window_go_fotmation_info.sceneType) > 0
		then
		state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
        {
            _type    = _ED.lduplicate_window_go_fotmation_info.sceneType, 
            _sceneId = _ED.lduplicate_window_go_fotmation_info.sceneId
        })
	end
	_ED.lduplicate_window_go_fotmation_info = {}
	-- action:play("window_close", false)
end

function FormationTigerGate:onLoad()
	local csbFormation = csb.createNode("formation/line_up.csb")
	self:addChild(csbFormation)

	local root = csbFormation:getChildByName("root")
	table.insert(self.roots, root)

	self.headListView = ccui.Helper:seekWidgetByName(root, "ListView_2")
	
	self:onInit()
end

function FormationTigerGate:onInit()
	app.load("client.cells.utils.add_and_lock_cell")
	app.load("client.cells.ship.ship_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.ship.ship_body_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.ship.ship_partner_cell")
	app.load("client.cells.formation.formation_lock_action_cell")
	app.load("client.cells.utils.add_action_cell")
	app.load("client.cells.formation.formation_partner_place_cell")
	app.load("client.cells.formation.formation_partner_info_list_cell")
	app.load("client.cells.utils.selected_cursor")
	app.load("client.packs.hero.HeroDevelop")
	app.load("client.cells.formation.Lformation_change_hero_cell")
	app.load("client.packs.EquipStorage.SmEquipmentQunenchingHandle")
    app.load("client.packs.EquipStorage.SmEquipmentQianghuaTab3Window1")

	self:drawHeadQueue()
	-- self:updateDrawPartnerView()
end

function FormationTigerGate:onExit()
	if self.bust_index_args ~= nil then 
		for i, v in pairs(self.bust_index_args) do
			ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_" .. v .. ".ExportJson")
		end
	end
	state_machine.remove("formation_update_equip_icon_push")
end

function FormationTigerGate:getFormationPos(_tempShipId, _open_index)
	_open_index = _open_index or 0

	local temp_open_index = 0
	for i = 1, 6 do
		if _ED.user_formetion_status[i] == _tempShipId then
			if tonumber(_tempShipId) ~= 0 then
				return i
			else
				temp_open_index = temp_open_index + 1
			
				if temp_open_index == _open_index then
					return i
				end
			end
		end
	end
	
	return nil
end

function FormationTigerGate:updateDataCellIndex()
	local drawOpenCount = 1
	for i, v in ipairs(self._dataCell) do
		if v._ship == -1 then
			v._indexadd = self:getFormationPos("0", drawOpenCount)
			drawOpenCount = drawOpenCount + 1
		elseif v._ship == -2 then
			
		else
			v._indexadd = self:getFormationPos(v.ship.ship_id)
		end
	end
end

function FormationTigerGate:drawHeadQueue(_ship_instance)
	self.headListView:removeAllItems()
	self.queue = {
		shipid = {},
		shiptype = {},
	}
	local nCount = 0
	local tCount = 6
	local openCount = zstring.tonumber(_ED.user_info.user_fight)
	local shipId = 0
	local shipType = 0

	local info = {}
	local old_info = {}
	for k,v in pairs(_ED.user_formetion_status) do
		if tonumber(v) > 0 then
			table.insert(info, v)
		else
			table.insert(old_info, v)
		end
	end
	for k,v in pairs(old_info) do
		table.insert(info, v)
	end

	for i = 1, tCount do
		shipId = info[i]
		if zstring.tonumber(shipId) > 0 then
			shipType = 1
			table.insert(self.queue.shipid, shipId)
			table.insert(self.queue.shiptype, shipType)
			nCount = nCount + 1
		else
			break
		end
	end
	
	shipId = 0
	shipType = 0
	for i = nCount + 1, openCount do
		table.insert(self.queue.shipid, shipId)
		table.insert(self.queue.shiptype, shipType)
		nCount = nCount + 1
	end
	
	shipType = -1
	for i = nCount + 1, tCount do
		table.insert(self.queue.shipid, shipId)
		table.insert(self.queue.shiptype, shipType)
		nCount = nCount + 1
	end

	local shiptype = self.queue.shiptype
	local shipid = self.queue.shipid
	local sCount = #self.queue.shiptype
	self._dataCell = {}
	local drawOpenCount = 1
	for i = 1, sCount do
		local cell = nil
		local shipType = shiptype[i]
		local shipId = shipid[i]
		if shipType == 1 then										--有武将上阵
			cell = self:createShipHead(_ED.user_ship[shipId],1)
			cell._ship = _ED.user_ship[shipId]
			cell._indexadd = self:getFormationPos(shipId)
			cell.ship = _ED.user_ship[shipId]
			cell._index = i
		elseif shipType == 0 then									--无武将上阵
			cell = self:createAddandLockCell(2,0)
			cell._indexadd = self:getFormationPos("0", drawOpenCount)
			cell._ship = -1
			cell._index = i
			drawOpenCount = drawOpenCount + 1
		elseif shipType == -1 then									--上阵位未开启
			cell = self:createAddandLockCell(3, 0, i)				--传入当前位置
			cell._indexadd = i-1
			cell._ship = -2
			cell._index = i
		end
		if cell ~= nil then 
			table.insert(self._dataCell, cell)
			self.headListView:pushBackCustomItem(cell)
			cell:setTouchEnabled(false)
			self:initFormationRoleAnimation(cell)
			local clickPanel = nil
			if shipType == 1 then
				clickPanel = cell.panelFour
			elseif shipType == 0 then
				clickPanel = cell.panelTwo
			end

			if clickPanel ~= nil then
				local function clickPanelTouchEvent(sender, eventType)
					local __spoint = sender:getTouchBeganPosition()
					local __mpoint = sender:getTouchMovePosition()
					local __epoint = sender:getTouchEndPosition()
				
					if eventType == ccui.TouchEventType.began then
					elseif eventType == ccui.TouchEventType.ended or 
					  eventType == ccui.TouchEventType.canceled and
					  math.abs(__epoint.y - __spoint.y) < 8 then
					  	sender._one_called = true
						-- local last_index = 1
						-- local HomeHeroWnd = fwin:find("HomeHeroClass")
						
						-- if HomeHeroWnd ~= nil then
						-- 	last_index = HomeHeroWnd.current_formetion_index
						-- end
						-- local now_index = cell._indexadd
						
						-- local direction = now_index - last_index > 0 and "L" or "R"
						-- local size = math.abs(now_index - last_index)
						-- if last_index == 6 and now_index == 1 then
						-- 	direction = "L"
						-- 	size = 1
						-- elseif last_index == 1 and now_index == 6 then
						-- 	direction = "R"
						-- 	size = 1
						-- end	
						-- if size > 0 then
							-- state_machine.excute("home_hero_action_switch_in_formation", 0, 
							-- {
							-- 	_direction = direction, 
							-- 	_start_index = last_index,
							-- 	_size = size
							-- })
						-- end
						if sender._self ~= nil then
							sender._self._current_cell = sender.cell
							sender._self:changeSelectHeroInfo()
							-- if self ~= nil and self.ship ~= nil then
							-- 	local shipid = tonumber(self.ship.ship_template_id)
							-- 	local soundid = dms.string(dms["ship_mould"], shipid, ship_mould.sound_index)
							-- 	playEffectExt(formatMusicFile("effect", soundid))	
							-- end
							-- state_machine.excute("Lformation_ship_cell_play_hero_animation",0,{"begin"})
						end
					end	
				end
				clickPanel.callback = clickPanelTouchEvent
				clickPanel.cell = cell
				clickPanel._self = self
				clickPanel:addTouchEventListener(clickPanelTouchEvent)
			end
		end
	end
	
	-- if HomeHero.last_selected_hero ~= nil and HomeHero.touch_type == "menu" then
	-- 	_ship_instance = HomeHero.last_selected_hero
	-- end
	
	if _ship_instance ~= nil then
		for i, v in pairs(self._dataCell) do
			if type(v._ship) == "table" and v._ship.ship_id == _ship_instance.ship_id then
				self._current_cell = v
				break
			elseif v._ship == -1 and tonumber(_ship_instance.ship_id) == 0 and v._indexadd == self:getFormationPos("0", 1) then
				self._current_cell = v
				break
			end
		end
	end
	if self._current_cell == nil then
		self._current_cell = self._dataCell[1]
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		self:changeSelectHeroInfo()
	end
end

if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	local formation_open_instance_window_terminal = {
	    _name = "formation_open_instance_window",
	    _init = function (terminal)
	    end,
	    _inited = false,
	    _instance = self,
	    _state = 0,
	    _invoke = function(terminal, instance, params)
	    	local ship = params._datas._shipInstance
	    	local types = params._datas._enter_type 
	    	-- print("============",ship)
			if ship == nil then
				for i = 2, 7 do
					local shipId = _ED.formetion[i]
					if zstring.tonumber(shipId) > 0 then
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
							ship = _ED.user_ship[_ED.formetion[i]]
						else
							local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
							if zstring.tonumber(isleadtype) == 0 then
								ship = _ED.user_ship[_ED.formetion[i]]
							end
						end
					end
				end
			end
			
			-- print("===0000000000000=====",ship.captain_name)
			if g_formationTigerGate == nil then
				g_formationTigerGate = FormationTigerGate:new()
				g_formationTigerGate:onLoad()
				g_formationTigerGate:retain()
		        if ship ~= nil then
		            g_formationTigerGate:init(ship)
		        end
		        return true
		    else
		    	g_formationTigerGate:setVisible(true)
		    	if ship == nil then
		    		g_formationTigerGate._current_cell = g_formationTigerGate._dataCell[1]
		    	else
					for i, v in pairs(g_formationTigerGate._dataCell) do
						if type(v._ship) == "table" and v._ship.ship_id == ship.ship_id 
						 or v._ship == -1 and tonumber(ship.ship_id ) == 0 and v._indexadd == g_formationTigerGate:getFormationPos("0", 1) then
						 	g_formationTigerGate._current_cell = v
						 	break
						end
					end
		    	end
		    	-- g_formationTigerGate:changeSelectHeroInfo()
		    	g_formationTigerGate:drawHeadQueue(ship)
		    	state_machine.unlock("menu_manager_change_to_page", 0, "")
			end
			fwin:open(g_formationTigerGate, fwin.__windows)
			state_machine.excute("formation_set_type",0,{types,ship})
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			    if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
				else
					fwin:find("HeroIconListViewClass"):setVisible(false)
				end
				g_formationTigerGate.actions[1]:play("animation_open", false)
			end
			state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_evo")
        	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_evo")
			if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
				state_machine.excute("sm_role_strengthen_tab_special_attributes_change_ship",0,ship.ship_id)
				state_machine.excute("sm_role_strengthen_tab_special_attributes_update_draw",0,"")
			end
			if fwin:find("SmRoleStrengthenTabUpgradeClass") ~= nil then
				if tonumber(ship.ship_id) ~= tonumber(fwin:find("SmRoleStrengthenTabUpgradeClass").ship_id) then
					state_machine.excute("sm_role_strengthen_tab_up_grade_change_ship",0,ship.ship_id)
					state_machine.excute("sm_role_strengthen_tab_up_grade_update_draw",0,"")
				end
			end
			if fwin:find("SmRoleStrengthenTabUpProductClass") ~= nil then
				state_machine.excute("sm_role_strengthen_tab_up_product_change_ship",0,ship.ship_id)
				state_machine.excute("sm_role_strengthen_tab_up_product_update_draw",0,"")
			end
			if fwin:find("SmRoleStrengthenTabRisingStarClass") ~= nil then
				state_machine.excute("sm_role_strengthen_tab_rising_star_change_ship",0,ship.ship_id)
				state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw",0,"")
			end
			if fwin:find("SmRoleStrengthenTabSkillClass") ~= nil then
				state_machine.excute("sm_role_strengthen_tab_skill_update_draw",0,{ship.ship_id})
			end
			if fwin:find("SmRoleStrengthenTabFightingSpiritClass") ~= nil then
				state_machine.excute("sm_role_strengthen_tab_fighting_spirit_update_draw",0,{ship.ship_id})
			end
			if fwin:find("SmRoleStrengthenTabFightSpiritClass") ~= nil then
				state_machine.excute("sm_role_strengthen_tab_fight_spirit_change_ship",0,ship.ship_id)
			end

			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_evolution_page_tip")
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_up_grade_star_page_tip")
	        return true
	    end,
	    _terminal = nil,
	    _terminals = nil
	}
	local formation_release_instance_window_terminal = {
	    _name = "formation_release_instance_window",
	    _init = function (terminal)
	    end,
	    _inited = false,
	    _instance = self,
	    _state = 0,
	    _invoke = function(terminal, instance, params)
			if g_formationTigerGate ~= nil then
				fwin:close(g_formationTigerGate)
				g_formationTigerGate:release()
			end
			g_formationTigerGate = nil
	        return true
	    end,
	    _terminal = nil,
	    _terminals = nil
	}
	state_machine.add(formation_open_instance_window_terminal)
	state_machine.add(formation_release_instance_window_terminal)

	state_machine.init()
end
function FormationTigerGate:getHeroIndex( ... )
	for i,v in pairs(self.sortedHeroes) do
		-- print("=============",self.ship.captain_name,v.captain_name)
		if self.ship == v then
			self.heroindex = i		
		end
	end
end

function FormationTigerGate:getSortedHeroes()
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end
	local showFormation = false
	-- debug.print_r(self.ship)
	-- print("==========",self.enter_type,zstring.tonumber(self.ship.formation_index))
	-- if self.enter_type ~= "pack" then
	-- 	showFormation = true
	-- end
	if zstring.tonumber(self.ship.formation_index) > 0  then
		showFormation = true
	else
		showFormation = false
	end
	 -- print("=============",showFormation)
	local tSortedHeroes = {}
	-- 上阵武将数组
	local arrBusyHeroes = {}
	-- 各星级武将数组
	local arrStarLevelHeroesWhite = {}--白
	local arrStarLevelHeroesGreen = {}--绿
	local arrStarLevelHeroesKohlrabiblue= {}--蓝
	local arrStarLevelHeroesPurple = {}--紫
	local arrStarLevelHeroesOrange = {}--橙
	local arrStarLevelHeroesRed = {}--红
	local arrStarLevelHeroesGold = {}--金
	local arrStarLevelHeroesExp = {}--经验人
	-- 主角放在第一位
	for i, ship in pairs(_ED.user_ship) do
		if ship.ship_id ~= nil then
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			
			-- if dms.atoi(shipData, ship_mould.captain_type) == 0 then
			-- 	tSortedHeroes[1] = ship
			-- else

			if zstring.tonumber(ship.formation_index) > 0 then
				table.insert(arrBusyHeroes, ship)
			elseif dms.atoi(shipData, ship_mould.captain_type) == 2 then
				table.insert(arrStarLevelHeroesExp, ship)
			else
				if dms.atoi(shipData, ship_mould.ship_type) == 0 then
					table.insert(arrStarLevelHeroesWhite, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
					table.insert(arrStarLevelHeroesGreen, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
					table.insert(arrStarLevelHeroesKohlrabiblue, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
					table.insert(arrStarLevelHeroesPurple, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
					table.insert(arrStarLevelHeroesOrange, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
					table.insert(arrStarLevelHeroesRed, ship)
				elseif dms.atoi(shipData,ship_mould.ship_type) == 6 then
					table.insert(arrStarLevelHeroesGold, ship)			
				end 
			end
		end
	end

	table.sort(arrBusyHeroes, fightingCapacity)
	table.sort(arrStarLevelHeroesWhite, fightingCapacity)
	table.sort(arrStarLevelHeroesGreen, fightingCapacity)
	table.sort(arrStarLevelHeroesKohlrabiblue, fightingCapacity)
	table.sort(arrStarLevelHeroesPurple, fightingCapacity)
	table.sort(arrStarLevelHeroesOrange, fightingCapacity)
	table.sort(arrStarLevelHeroesRed, fightingCapacity)
	table.sort(arrStarLevelHeroesGold, fightingCapacity)
	table.sort(arrStarLevelHeroesExp, fightingCapacity)
	-- 把已排序好的上阵武将加入到 武将排序数组中
	local hero_number = 0
	if showFormation == true then

		for i=1, #arrBusyHeroes do
			table.insert(tSortedHeroes, arrBusyHeroes[i])
			hero_number = hero_number + 1
		end
	else
		for i=1, #arrStarLevelHeroesGold do
			table.insert(tSortedHeroes, arrStarLevelHeroesGold[i])
			hero_number = hero_number + 1
		end	
		for i=1, #arrStarLevelHeroesRed do
			table.insert(tSortedHeroes, arrStarLevelHeroesRed[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesOrange do
			table.insert(tSortedHeroes, arrStarLevelHeroesOrange[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesPurple do
			table.insert(tSortedHeroes, arrStarLevelHeroesPurple[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesKohlrabiblue do
			table.insert(tSortedHeroes, arrStarLevelHeroesKohlrabiblue[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesGreen do
			table.insert(tSortedHeroes, arrStarLevelHeroesGreen[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesWhite do
			table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesExp do
			table.insert(tSortedHeroes, arrStarLevelHeroesExp[i])
			hero_number = hero_number + 1
		end
	end
	self.heronumber = hero_number
	-- print("============",self.heronumber)
	return tSortedHeroes
end
function FormationTigerGate:showPropertyChangeTipInfoOfEquipment(previousShip,types,temp,ker)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		local ship_courage = 0
		local ship_health = 0
		local ship_intellect = 0
		local ship_quick = 0

		local now_courage = 0
		local now_health = 0
		local now_intellect = 0
		local now_quick = 0
		--
		 app.load("client.battle.report.FormulaUtil")
		 local _FormulaUtil = FormulaUtil:new()
		 local ship_temp = {}
		 local zhanli = _FormulaUtil:computeFormationFirstStrike(_ED.user_formetion_status,ship_temp)
		 zhanli = math.floor(zhanli)
		 _ED.user_info.fight_capacity = zhanli
		 --debug.print_r(ship_temp)
		 for i ,v in pairs(ship_temp) do
		 	if v.ship_id == previousShip.ship_id then
		 		now_courage = math.floor(v.courage + 0.5)
		 		now_health = math.floor(v.power + 0.5)
		 		now_intellect = math.floor(v.intellect + 0.5)
		 		now_quick =math.floor(v.nimable + 0.5)
		 	end
		 end
		if self.ship.ship_id == previousShip.ship_id then
			self.ship.ship_courage =now_courage
			self.ship.ship_health = now_health
			self.ship.ship_intellect = now_intellect
			self.ship.ship_quick =now_quick
		else
			_ED.user_ship[previousShip.ship_id].ship_courage = now_courage
			_ED.user_ship[previousShip.ship_id].ship_health = now_health
			_ED.user_ship[previousShip.ship_id].ship_intellect = now_intellect
			_ED.user_ship[previousShip.ship_id].ship_quick =now_quick
		end 


		ship_courage = zstring.tonumber(now_courage) - zstring.tonumber(previousShip.ship_courage)
		ship_health = zstring.tonumber(now_health) - zstring.tonumber(previousShip.ship_health)
		ship_intellect = zstring.tonumber(now_intellect) - zstring.tonumber(previousShip.ship_intellect)
		ship_quick = zstring.tonumber(now_quick) - zstring.tonumber(previousShip.ship_quick)

		local textData = {}
		-----------------------强化大师的判断
		local shipId = previousShip.ship_id
					
		local equips_id = {}

		local tempShip = _ED.user_ship[shipId]
		local ship_equips = {}
		if tempShip ~= nil then
			ship_equips = _ED.user_ship[shipId].equipment
		end

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
		--------------------------------缘分激活提示(更换伙伴时触发)
		if ker == true then
			local fettersNumber = 0
			local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.relationship_id), ",")
			local inStates = {}
			local ter = 1
			local name = nil
			for i, v in pairs(_ED.user_ship) do
				if zstring.tonumber(v.formation_index) > 0 or zstring.tonumber(v.little_partner_formation_index) > 0 then
					if zstring.tonumber(v.ship_id) ~= zstring.tonumber(_ED.into_formation_ship_id) then
						inStates[ter] = v.ship_base_template_id
						ter = ter + 1
					end
				end
			end
			
			local getPersonName = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[previousShip.ship_id].ship_template_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(_ED.user_ship[previousShip.ship_id].evolution_status, "|")
				local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[previousShip.ship_id])
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				getPersonName = word_info[3]
			else
				if tonumber(_ED.user_ship[previousShip.ship_id].captain_type) == 0 then
					getPersonName = _ED.user_info.user_name
				else
					getPersonName = dms.string(dms["ship_mould"], _ED.user_ship[previousShip.ship_id].ship_template_id, ship_mould.captain_name)
				end
			end
			
			if myRelatioInfo ~= nil then
				
				local item = 1
				local equip = {}
				for i, v in pairs (_ED.user_ship) do
					if zstring.tonumber(v.ship_id) == zstring.tonumber(_ED.into_formation_ship_id) then
						for j, k in pairs(v.equipment) do
							equip[item] = zstring.tonumber(k.user_equiment_template)
							item = item + 1
						end
					end
				end
				
				--装备缘分激活
				for k,w in pairs(myRelatioInfo) do
					local num = 1
					local relationEquip = {}
					if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= 0  then
						if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
							relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
							num = num + 1
						end
					end
					if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= 0  then
						if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
							relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
							num = num + 1
						end
					end
					if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= 0  then
						if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
							relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
							num = num + 1
						end
					end
					if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= 0  then
						if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
							relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
							num = num + 1
						end
					end
					if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= 0  then
						if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
							relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
							num = num + 1
						end
					end
					if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= 0  then
						if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
							relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
							num = num + 1
						end
					end
					
					local sss = 0
					for j,r in pairs(relationEquip) do
						for i, v in pairs(equip) do
							if zstring.tonumber(r) == zstring.tonumber(v) then
								sss = sss + 1
								break
							end
						end
					end
					
					if table.getn(relationEquip) == sss and table.getn(relationEquip) > 0 and sss > 0 then
						fettersNumber = fettersNumber + 1
						
						name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
							name = name_datas[3]
						end
						for i,v in pairs(relationEquip) do
							for j,e in pairs(_ED.user_equiment) do
								if zstring.tonumber(e.user_equiment_template) == v then
									table.insert(textData, {nameOne = getPersonName , nameTwo = name})
									break
								end
							end
						end
					end
				end
			end
		elseif ker ~= nil then
			local getPersonName = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[previousShip.ship_id].ship_base_template_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(_ED.user_ship[previousShip.ship_id].evolution_status, "|")
				local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[previousShip.ship_id])
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				getPersonName = word_info[3]
			else
				if tonumber(_ED.user_ship[previousShip.ship_id].captain_type) == 0 then
					getPersonName = _ED.user_info.user_name
				else
					getPersonName = dms.string(dms["ship_mould"], _ED.user_ship[previousShip.ship_id].ship_base_template_id, ship_mould.captain_name)
				end
			end
			local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], _ED.user_ship[previousShip.ship_id].ship_base_template_id, ship_mould.relationship_id), ",")
			for k,w in pairs(myRelatioInfo) do
				local num = 1
				local relationEquip = {}
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= 0  then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
						relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
						num = num + 1
					end
				end
				
				
				name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
					name = name_datas[3]
				end
				for i,v in pairs(relationEquip) do
					if zstring.tonumber(_ED.user_equiment[ker].user_equiment_template) == v then
						table.insert(textData, {nameOne =  getPersonName, nameTwo = name})
						break
					end
				end
			end
		end
		
		if status == true then
			local nums1,nums2,nums3,nums4 = self:Mason(shipId)
			if zstring.tonumber(temp) ~= 4 and zstring.tonumber(temp) ~= 5 then
				if zstring.tonumber(nums1)>zstring.tonumber(self.masterStrengthenlv[1]) then
					self.masterStrengthenlv[1] = nums1
					table.insert(textData, {property = _strengthen_master_info[10], value = nums1, add = _strengthen_master_info[14] })
				end
				if zstring.tonumber(nums2)>zstring.tonumber(self.masterStrengthenlv[2]) then
					self.masterStrengthenlv[2] = nums2
					table.insert(textData, {property = _strengthen_master_info[11], value = nums2, add = _strengthen_master_info[14] })
				end
			end
			
			if nums3 ~= nil and nums4 ~= nil then
				if zstring.tonumber(nums3)>zstring.tonumber(self.masterStrengthenlv[3]) then
					self.masterStrengthenlv[3] = nums3
					table.insert(textData, {property = _strengthen_master_info[12], value = nums3, add = _strengthen_master_info[14] })
				end
				if zstring.tonumber(nums4)>zstring.tonumber(self.masterStrengthenlv[4]) then
					self.masterStrengthenlv[4] = nums4
					table.insert(textData, {property = _strengthen_master_info[13], value = nums4, add = _strengthen_master_info[14] })
				end
				table.insert(textData, {property = _property[2], value = ship_courage})
				table.insert(textData, {property = _property[1], value = ship_health})
				table.insert(textData, {property = _property[3], value = ship_intellect})
				table.insert(textData, {property = _property[4], value = ship_quick})
			else
				table.insert(textData, {property = _property[2], value = ship_courage})
				table.insert(textData, {property = _property[1], value = ship_health})
				table.insert(textData, {property = _property[3], value = ship_intellect})
				table.insert(textData, {property = _property[4], value = ship_quick})
			end
			
		else
			table.insert(textData, {property = _property[2], value = ship_courage})
			table.insert(textData, {property = _property[1], value = ship_health})
			table.insert(textData, {property = _property[3], value = ship_intellect})
			table.insert(textData, {property = _property[4], value = ship_quick})
		end
		
		app.load("client.cells.utils.property_change_tip_info_cell") 
		local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()

		local str = ""
		if types == 1 then
			str = tipStringInfo_hero_change_Type[1]
		elseif types == 2 then
			-- str = tipStringInfo_hero_change_Type[4]
		elseif types == 3 then
			-- str = tipStringInfo_hero_change_Type[5]
		elseif types == 6 then -- 上阵英雄成功
			str = tipStringInfo_hero_change_Type[6]
		end
		tipInfo:init(1,str, textData)	
		fwin:open(tipInfo, fwin._view)

		--动画播完后 需要清零原先的属性变化
		previousShip.ship_courage=0
		previousShip.ship_health=0
		previousShip.ship_intellect=0
		previousShip.ship_quick=0
		_ED.baseFightingCount = calcTotalFormationFight()	
	end
end

function FormationTigerGate:showChangeTipInfoStrenghEquipment(previousShip,types)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		local ship_courage = 0
		local ship_health = 0
		local ship_intellect = 0
		local ship_quick = 0

		local now_courage = 0
		local now_health = 0
		local now_intellect = 0
		local now_quick = 0

		for i ,v in pairs(_ED.user_ship) do
			if v.ship_id == previousShip.ship_id then
				now_courage = v.ship_courage
				now_health = v.ship_health
				now_intellect = v.ship_intellect
				now_quick = v.ship_quick
			end
		end
		if self.ship.ship_id == previousShip.ship_id then
			self.ship.ship_courage = now_courage
			self.ship.ship_health = now_health
			self.ship.ship_intellect = now_intellect
			self.ship.ship_quick = now_quick
		else
			_ED.user_ship[previousShip.ship_id].ship_courage = now_courage
			_ED.user_ship[previousShip.ship_id].ship_health = now_health
			_ED.user_ship[previousShip.ship_id].ship_intellect = now_intellect
			_ED.user_ship[previousShip.ship_id].ship_quick =now_quick
		end 


		ship_courage = zstring.tonumber(now_courage) - zstring.tonumber(previousShip.ship_courage)
		ship_health = zstring.tonumber(now_health) - zstring.tonumber(previousShip.ship_health)
		ship_intellect = zstring.tonumber(now_intellect) - zstring.tonumber(previousShip.ship_intellect)
		ship_quick = zstring.tonumber(now_quick) - zstring.tonumber(previousShip.ship_quick)

		local textData = {}
		-----------------------强化大师的判断
		local shipId = previousShip.ship_id
					
		local equips_id = {}

		local tempShip = _ED.user_ship[shipId]
		local ship_equips = {}
		if tempShip ~= nil then
			ship_equips = _ED.user_ship[shipId].equipment
		end

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
			local nums1,nums2,nums3,nums4 = self:Mason(shipId)
			if zstring.tonumber(nums1)>zstring.tonumber(self.masterStrengthenlv[1]) then
				self.masterStrengthenlv[1] = nums1
				table.insert(textData, {property = _strengthen_master_info[10], value = nums1, add = _strengthen_master_info[14] })
			end
			if zstring.tonumber(nums2)>zstring.tonumber(self.masterStrengthenlv[2]) then
				self.masterStrengthenlv[2] = nums2
				table.insert(textData, {property = _strengthen_master_info[11], value = nums2, add = _strengthen_master_info[14] })
			end
			
			if nums3 ~= nil and nums4 ~= nil then
				if zstring.tonumber(nums3)>zstring.tonumber(self.masterStrengthenlv[3]) then
					self.masterStrengthenlv[3] = nums3
					table.insert(textData, {property = _strengthen_master_info[12], value = nums3, add = _strengthen_master_info[14] })
				end
				if zstring.tonumber(nums4)>zstring.tonumber(self.masterStrengthenlv[4]) then
					self.masterStrengthenlv[4] = nums4
					table.insert(textData, {property = _strengthen_master_info[13], value = nums4, add = _strengthen_master_info[14] })
				end
				table.insert(textData, {property = _property[2], value = ship_courage})
				table.insert(textData, {property = _property[1], value = ship_health})
				table.insert(textData, {property = _property[3], value = ship_intellect})
				table.insert(textData, {property = _property[4], value = ship_quick})
			else
				table.insert(textData, {property = _property[2], value = ship_courage})
				table.insert(textData, {property = _property[1], value = ship_health})
				table.insert(textData, {property = _property[3], value = ship_intellect})
				table.insert(textData, {property = _property[4], value = ship_quick})
			end
			
		else
			table.insert(textData, {property = _property[2], value = ship_courage})
			table.insert(textData, {property = _property[1], value = ship_health})
			table.insert(textData, {property = _property[3], value = ship_intellect})
			table.insert(textData, {property = _property[4], value = ship_quick})
		end
		
		app.load("client.cells.utils.property_change_tip_info_cell") 
		local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()

		local str = ""
		if types == 1 then
			str = tipStringInfo_hero_change_Type[1]
		elseif types == 2 then
			-- str = tipStringInfo_hero_change_Type[4]
		elseif types == 3 then
			-- str = tipStringInfo_hero_change_Type[5]
		elseif types == 6 then -- 上阵英雄成功
			str = tipStringInfo_hero_change_Type[6]
		end
		tipInfo:init(1,str, textData)	
		fwin:open(tipInfo, fwin._view)

		--动画播完后 需要清零原先的属性变化
		previousShip.ship_courage=0
		previousShip.ship_health=0
		previousShip.ship_intellect=0
		previousShip.ship_quick=0
		_ED.baseFightingCount = calcTotalFormationFight()	
	end
end

function FormationTigerGate:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end