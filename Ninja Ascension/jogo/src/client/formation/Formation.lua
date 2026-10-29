 -- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的阵容界面
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
Formation = class("FormationClass", Window)
local FormationCamp = Formation
local g_formation = nil
Formation.__userHeroFontName = nil

local init_formation_coords = nil
if __lua_project_id == __lua_project_yugioh then
	init_formation_coords = {
		{1, 0,				320,		180 + 517},
		{2, -17.14,			410,		192 + 517},
		{3,	-34.28,			493.44,		231.7 + 517},
		{4,	-51.42,			562.22,		292.27 + 517},
		{5,	-68.11,			613.85,		373.57 + 517},
		{6,	-85.25,			633.32,		462.06 + 517},
		{7,	-102.4,			627.44,		552.98 + 517}
	}
end

function Formation:ctor()
	self.super:ctor()
	self.roots = {}
	self.fresh = true

	self.ship = nil
	self.shipArray={}
	self.pageView = nil
	self.headPageView = nil
	self.formationPosition = nil
	self.listview = nil
	self.lead = nil
	self.listViewMoveX = 0
	self.listviewX = 0
	self.indexlest = 0
	self.listDirection = 0
	self.xuanzhong = 0
	self.heroCells = {}
	self.levelUpBefore = {}
	self.masterStrengthenlv={}
	self.runState = 0
	self.headListView = nil
	self._beforeCell = nil
	self._lastStatus = 0
	self._max_hero_counts = 6

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
				local formationChangeWindow = FormationChange:new()
				fwin:open(formationChangeWindow, fwin._windows)
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
				local formation = fwin:find("FormationClass")
				if nil == formation then
					return
				end
				formation.pageView:scrollToPage(0)
				formation.pageView:update(10)
				for i, v in pairs(self.shipArray) do
					if v~=0 and zstring.tonumber(v.ship_id) == zstring.tonumber(params.ship_id) then
						formation.headPageView:scrollToPage(i-1)
						formation.headPageView:update(10)
					end
				end
				
				formation:init(params)
				formation:updateDrawChanageShipPageView()
				formation:updateDrawShipInfo()
				formation:updateDrawEquipments()
				formation:getshipFormationPosition()
				formation:selectedPad()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		--点击武将形象打开武将信息界面
		local open_formation_head_info_terminal = {
			_name = "open_formation_head_info",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
			 --点击事件
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
			 --点击事件
			-- app.load("client.packs.equipment.EquipInformation") 
			-- local equip = params._datas._equip
			-- local equipInformation = EquipInformation:new()
			-- equipInformation:init(equip)
			-- fwin:open(equipInformation, fwin._ui)
			
			--打开装备信息前缓存数据先
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				state_machine.excute("formation_property_change_before",0,"")
			end
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				if tonumber(params.equipment_type) >= 4 then
					state_machine.excute("formation_cell_on_hide",0,"formation_cell_on_hide")
					app.load("client.packs.treasure.TreasureControllerPanel")
					local tcp = TreasureControllerPanel:new()
					tcp:setCurrentTreasure(params,"formation")
					fwin:open(tcp, fwin._view)
				else
					state_machine.excute("formation_cell_on_hide",0,"formation_cell_on_hide")
					app.load("client.packs.equipment.EquipStrengthenRefineStrorage")
					local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
 					equipStrengthenRefineStrorageWindow:init(params, "1", nil, "formation")
 					fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
				end
			else
				app.load("client.packs.equipment.EquipInSeeformation")
				local equipSeeInformation = EquipInSeeformation:new()
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					or __lua_project_id == __lua_project_yugioh
					then 
					if params._equip ~= nil then 
						equipSeeInformation:init(params._equip,params._cell)
					else
						equipSeeInformation:init(params)
					end
				else
					equipSeeInformation:init(params)
				end
				
				fwin:open(equipSeeInformation, fwin._ui)
			end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 点击阵容小头像上面的援军按钮的跳转
		local jump_formation_partner_info_terminal = {
			_name = "jump_formation_partner_info",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
			 --点击事件
			instance.pageView:scrollToPage(1)
			instance.pageView:update(10)
			instance:selectedPad()
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
				--点击事件
				if params.pet ~= nil then 
					--宠物
					app.load("client.packs.pet.PetFormationChoiceWear")
	        		local petChooseWindow = PetFormationChoiceWear:new()
	         		petChooseWindow:init(2)
	         		fwin:open(petChooseWindow, fwin._windows)
					return
				end
				local shipId = -1 -- instance.moveLayer._current_cell._ship.ship_id
				local heroFormationChoiceWearWindow = HeroFormationChoiceWear:new()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
					if params._index == nil then
						params._index = params._datas._index
					end
					if params._type == nil then
						params._type = params._datas._type
					end
				end
				heroFormationChoiceWearWindow:init(params._index, params._type, shipId)
				fwin:open(heroFormationChoiceWearWindow, fwin._ui)
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
					--TipDlg.drawTextDailog("判断是否有可以装备的装备，有就进入装备穿戴选择界面。")
				else
					-- TipDlg.drawTextDailog("判断是否有可以装备的装备，无就进入装备获取途径界面")
					-- TipDlg.drawTextDailog("没有装备，在这时需要绘制装备获得途径的界面。")
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
					-- local fightWindow = EquipAcquire:new()
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
			 --点击事件
				--print("-----小伙伴要更换了----------------------------------------------------------")
				app.load("client.packs.hero.HeroFormationChoiceWear")
				local HeroFormationChoiceWearWindow = HeroFormationChoiceWear:new()
				HeroFormationChoiceWearWindow:init(params,2)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					fwin:open(HeroFormationChoiceWearWindow, fwin._view)
				else
					fwin:open(HeroFormationChoiceWearWindow, fwin._ui)	
				end
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
			 --点击事件
			ccui.Helper:seekWidgetByName(instance.roots[1], "Button_3"):setVisible(false)
			ccui.Helper:seekWidgetByName(instance.roots[1], "Button_3_0"):setVisible(true)
			ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_63"):setVisible(true)
			ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_card"):setVisible(false)	
			instance.headLayer:setTouchEnabled(true)
			
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
			 --点击事件
			ccui.Helper:seekWidgetByName(instance.roots[1], "Button_3"):setVisible(true)
			ccui.Helper:seekWidgetByName(instance.roots[1], "Button_3_0"):setVisible(false)
			ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_63"):setVisible(false)
			ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_card"):setVisible(true)	
			instance.headLayer:setTouchEnabled(true)			
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
			 --点击事件
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
					local requestInfo = nil
					_ED.baseFightingCount = calcTotalFormationFight()
					local formation = fwin:find("FormationClass")
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						requestInfo = zstring.zsplit(params, "|")
						state_machine.excute("equip_strengthen_refine_strorage_to_update_draw_button",0,"")
						state_machine.excute("treasure_refine_update_button",0,"")	
						state_machine.excute("equip_icon_listview_update_listview",0,_ED.user_equiment[requestInfo[2]])
						state_machine.excute("treasure_icon_listview_update_listview",0,_ED.user_equiment[requestInfo[2]])
					else
						if nil == formation then
							return
						end
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						local formation = fwin:find("FormationClass")
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							if fwin:find("EquipStrengthenRefineStrorageClass") ~= nil then
								state_machine.excute("equip_strengthen_refine_strorage_to_close_all",0,"")
								state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = _ED.user_ship[requestInfo[1]]}})
							end
							if fwin:find("TreasureControllerPanelClass") ~= nil then
								state_machine.excute("treasure_refine_close_all",0,"")
								state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = _ED.user_ship[requestInfo[1]]}})
							end
						end
						if nil == formation then
							return
						end
						
						instance:updateDrawEquipments()
						-- if instance.ship == nil then
							-- instance:updateDrawShipInfo()
						-- end
						local ser = zstring.zsplit(params, "|")
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							instance:showPropertyChangeTipInfoOfEquipment(previousShip,3,ser[3],response.node)
						else
							instance:showPropertyChangeTipInfo(previousShip,3,ser[3],response.node)
						end
						--instance:showPropertyChangeTipInfo(previousShip,3,ser[3],response.node)
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
			 --点击事件
			 	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			 		local ship = params._datas._self.ship
			 		local equipType = params._datas._self.equipType
			 		local equip = params._datas._self.equipmentInstance
			 		-- print("装备在身，装备名,位置在",ship.captain_name,equip.user_equiment_name,equipType)
			 		if ship ~= nil then
						app.load("client.packs.equipment.EquipFormationChoiceWear")
						local EquipFormationChoiceWearWindow = EquipFormationChoiceWear:new()
						EquipFormationChoiceWearWindow:init(equipType,ship)
						fwin:open(EquipFormationChoiceWearWindow, fwin._ui)
					else
						TipDlg.drawTextDailog(_All_tip_string_info_description._lackHeadtip)
					end
			 	else
				 	if instance.ship ~= nil then
						app.load("client.packs.equipment.EquipFormationChoiceWear")
						local EquipFormationChoiceWearWindow = EquipFormationChoiceWear:new()
						EquipFormationChoiceWearWindow:init(params,instance.ship)
						fwin:open(EquipFormationChoiceWearWindow, fwin._ui)
					else
						TipDlg.drawTextDailog(_All_tip_string_info_description._lackHeadtip)
					end
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
			 --点击事件
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
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
						local formation = fwin:find("FormationClass")
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							state_machine.excute("equip_strengthen_refine_strorage_to_update_draw_button",0,"")
							state_machine.excute("treasure_refine_update_button",0,"")	
							state_machine.excute("equip_icon_listview_update_listview",0,equip)
							state_machine.excute("treasure_icon_listview_update_listview",0,equip)
						else
							if nil == formation then
								return
							end
						end
						
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							instance:updateDrawEquipments()
							-- if instance.ship == nil then
								-- instance:updateDrawShipInfo()
							-- end
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								if fwin:find("EquipStrengthenRefineStrorageClass") ~= nil then
									state_machine.excute("equip_strengthen_refine_strorage_to_close_all",0,"")
									state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = response.node }})	
								end	
								if fwin:find("TreasureControllerPanelClass") ~= nil then
									state_machine.excute("treasure_refine_close_all",0,"")	
									state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = response.node }})	
								end	
								instance:showPropertyChangeTipInfoOfEquipment(previousShip,2)
							else
								instance:showPropertyChangeTipInfo(previousShip,2)
							end
							--instance:showPropertyChangeTipInfo(previousShip,2)
						end
					end
					local str = ""
					str = str..ship.ship_id.."\r\n"--佩戴船只ID
					str = str.."0".."\r\n"--装备ID
					str = str..types		--装备位标识
					protocol_command.equipment_adorn.param_list = str
					NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, ship, responseWearEquipCallback, false, nil)
				else
					local types = params._datas._equipType
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
						local formation = fwin:find("FormationClass")
						if nil == formation then
							return
						end
						
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							
							instance:updateDrawEquipments()
							-- if instance.ship == nil then
								-- instance:updateDrawShipInfo()
							-- end

							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								instance:showPropertyChangeTipInfoOfEquipment(previousShip,2)
							else
								instance:showPropertyChangeTipInfo(previousShip,2)
							end
							--instance:showPropertyChangeTipInfo(previousShip,2)
						end
					end
					local str = ""
					str = str..instance.ship.ship_id.."\r\n"--佩戴船只ID
					str = str..params._datas._equipid.."\r\n"--装备ID
					str = str..params._datas._equipType		--装备位标识
					protocol_command.equipment_adorn.param_list = str
					NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, nil, responseWearEquipCallback, false, nil)
				end

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
					local formation = fwin:find("FormationClass")
					if nil == formation then
						return
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						instance:updateDrawEquipments()
						instance:updateDrawShipInfo()
						instance:updateDrawPartnerView()
						if shipLocation > 0 then
							instance:activateLot(shipID)
						end
						--外面有人关掉了menu栏--这里的处理是临时的
						fwin:open(Menu:new(), fwin._taskbar)
					end
				end
				
				local str = ""
				str = str..requestInfo[1].."\r\n"--战船id
				str = str..requestInfo[2]--上阵位置
				protocol_command.companion_change.param_list = str
				NetworkManager:register(protocol_command.companion_change.code, nil, nil, nil, nil, responseChoiceHeroPartnersCallback, false, nil)
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
				
				local params_ex = nil
				
				local change_types = 1
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
					local function getFormationPos(_tempShipId)
						for i = 1, 6 do
							if _ED.user_formetion_status[i] == _tempShipId then
								return i
							end
						end
						
						return nil
					end
					
					-- local real_pos = getFormationPos(HomeHero.last_selected_hero.ship_id) or -1
					-- params_ex = requestInfo[1] .. "|" .. requestInfo[2] .. "|" .. real_pos
					
					local index = tonumber(requestInfo[2])
					if tonumber(_ED.formetion[index+1]) == 0 then
						change_types = 6
					end
				end
				
				local function responseChoiceHeroBattleCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					local formation = fwin:find("FormationClass")
					if nil == formation then
						return
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local ship = fundShipWidthId(requestInfo[1])
						instance:init(ship)
						instance:drawShipPageView()
						-- instance:updateDrawShipInfo()
						instance:updateDrawPartnerView()
						instance:drawShipHeadListView()
						instance:showPropertyChangeTipInfo(previousShip,change_types,nil,true)
						-- self.shipArray[zstring.tonumber(requestInfo[2])] = fundShipWidthId(requestInfo[1])
						-- instance:drawShipHeadListView()
						-- instance:drawShipPageView()
						-- instance:updateDrawPartnerView()
						-- instance:selectedPad()
						
						-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						-- 	state_machine.excute("home_hero_choice_hero_battle_request", 0, params_ex)
						-- end
						state_machine.excute("home_hero_refresh_draw", 0, 0)
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							--更换英雄之后，页面index跟着刷新
							--local formetion_index = requestInfo[2]
							local homeherowindow = fwin:find("HomeHeroClass")							
							local for_index = tonumber(requestInfo[2])
							--debug.print_r(_ED.formetion)
							--debug.print_r(_ED.user_formetion_status)
							local formetion_index = 0
							local f_shipid =_ED.formetion[for_index + 1]

							for i ,v in pairs(_ED.user_formetion_status) do
								if f_shipid == v then
									formetion_index = i
									-- print("--------",formetion_index)
									break
								end
							end
							-- _ED.formetion[tonumber(requestInfo[2])]
							homeherowindow.current_formetion_index = formetion_index
						end
					end
				end

				if zstring.tonumber(requestInfo[2]) > 0 then
					local str = ""
					str = str..requestInfo[1].."\r\n"--战船id
					str = str .. requestInfo[2].."\r\n"--上阵位置
					str = str.."1"
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
					
					protocol_command.formation_change.param_list = str
					NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, nil, responseChoiceHeroBattleCallback, false, nil)
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
			 --点击事件
				local shipId = nil
				
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
					shipId = instance.ship.ship_id
				else
					shipId = instance.moveLayer._current_cell._ship.ship_id
				end	
				
				app.load("client.packs.hero.HeroFormationChoiceWear")
				local HeroFormationChoiceWearWindow = HeroFormationChoiceWear:new()
				HeroFormationChoiceWearWindow:init(params._datas._data,nil,shipId)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					fwin:open(HeroFormationChoiceWearWindow, fwin._view)	
				else
					fwin:open(HeroFormationChoiceWearWindow, fwin._ui)	
				end
			return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local run_action_cell_terminal = {
			_name = "run_action_cell",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params) 
			 --点击事件
				--state_machine.excute("run_action_cell", 0, self.listview:getItem(7)._ship)
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
				local st = fwin:find("FormationClass")
				if st ~= nil then
					st:setVisible(true)
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
				local st = fwin:find("FormationClass")
				if st ~= nil then
					st:setVisible(false)
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
            	local booltemp = false
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		booltemp = true
            	end
            	if  (params._datas._moveLayer and 
					params._datas._moveLayer._current_cell and 
					params._datas._moveLayer._current_cell._ship and 
					type(params._datas._moveLayer._current_cell._ship) == "table" and
					params._datas._moveLayer._current_cell._ship.ship_id) or booltemp == true then

					local shipId = nil
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						shipId=self.ship.ship_id
					else
						shipId=params._datas._moveLayer._current_cell._ship.ship_id
					end
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
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						fwin:open(strengthen_master_layer, fwin._ui)
					else
						fwin:open(strengthen_master_layer, fwin._viewdialog)
					end
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
				instance:otherInterfaceReset(params._index)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--播放进入动画
		local formation_play_into_action_terminal = {
            _name = "formation_play_into_action",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:playIntoAction()
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
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					instance:playCloseAction()
				else
					-- state_machine.excute("menu_show_event", 0, "")
					-- state_machine.excute("home_show_event", 0, "")
					-- state_machine.excute("user_information_show_event", 0, "")
					-- state_machine.excute("menu_back_home_page", 0, "")
					fwin:close(instance)
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						cacher.removeAllTextures()
						fwin:reset(nil)
					end
					state_machine.excute("menu_back_home_page", 0, "") 
					state_machine.excute("home_hero_refresh_draw", 0, "")
					
					-- local menu_manager_terminal = state_machine.find("menu_manager", 0, "")
					-- if menu_manager_terminal ~= nil then
						-- menu_manager_terminal.last_terminal_name = "menu_show_home_page"
					-- end
					
					-- local menu_manager_change_to_page_terminal = state_machine.find("menu_manager_change_to_page", 0, "")
					-- if menu_manager_change_to_page_terminal ~= nil then
						-- menu_manager_change_to_page_terminal.last_terminal_name = "menu_show_home_page"
					-- end
					
					-- local home_hero_wnd = fwin:find("HomeHeroClass")
					-- if home_hero_wnd ~= nil then
						-- state_machine.excute("home_hero_binding_window_change", 0, home_hero_wnd._enum_window_type._HOME)
					-- end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 武将信息（属性、详情切换）
		local formation_hero_info_manager_terminal = {
            _name = "formation_hero_info_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end

                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 武将信息属性
		local formation_hero_info_attributes_terminal = {
			_name = "formation_hero_info_attributes",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local root = self.roots[1]
				local attributes_page = ccui.Helper:seekWidgetByName(root, "Panel_0")
				local details_page = ccui.Helper:seekWidgetByName(root, "Panel_7")
				attributes_page:setVisible(true)
				details_page:setVisible(false)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 武将信息详情
		local formation_hero_info_details_terminal = {
			_name = "formation_hero_info_details",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local root = self.roots[1]
				local attributes_page = ccui.Helper:seekWidgetByName(root, "Panel_0")
				local details_page = ccui.Helper:seekWidgetByName(root, "Panel_7")
				attributes_page:setVisible(false)
				details_page:setVisible(true)
				
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
					local layer = HeroDevelop:new()
					layer:init(params._datas._ship_id, cell)
					fwin:open(layer, fwin._viewdialog)
					state_machine.excute("hero_storage_hide_window", 0)
					state_machine.excute("hero_develop_page_manager", 0, 
						{
							_datas = {
								terminal_name = "hero_develop_page_manager", 	
								next_terminal_name = "hero_develop_page_open_strengthen_page",	
								current_button_name = "Button_shengji",  	
								but_image = "", 	
								terminal_state = 0, 
								shipId = params._datas._ship_id,
								openWinId = 33,
								isPressedActionEnabled = false
							}
						}
					)
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],33, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local formation_click_hero_break_page_terminal = {
            _name = "formation_click_hero_break_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local arena_grade=dms.int(dms["fun_open_condition"], 34, fun_open_condition.level)
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					local cell = instance.types
					state_machine.excute("return_to_the_squad_screen", 0, "return_to_the_squad_screen")
					state_machine.excute("hero_information_close", 0, "hero_information_close")
					local layer = HeroDevelop:new()
					layer:init(params._datas._ship_id, cell)
					fwin:open(layer, fwin._viewdialog)
					state_machine.excute("hero_storage_hide_window", 0)
					state_machine.excute("hero_develop_page_manager", 0, 
						{
							_datas = {
								terminal_name = "hero_develop_page_manager", 	
								next_terminal_name = "hero_develop_page_open_advanced",	
								current_button_name = "Button_tupo",  	
								but_image = "", 	
								terminal_state = 0, 
								shipId = params._datas._ship_id,
								openWinId = 34,
								isPressedActionEnabled = false
							}
						}
					)
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],34, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local formation_click_hero_develop_page_terminal = {
            _name = "formation_click_hero_develop_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local arena_grade=dms.int(dms["fun_open_condition"], 3, fun_open_condition.level)
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					local cell = instance.types
					state_machine.excute("return_to_the_squad_screen", 0, "return_to_the_squad_screen")
					state_machine.excute("hero_information_close", 0, "hero_information_close")
					local layer = HeroDevelop:new()
					layer:init(params._datas._ship_id, cell)
					fwin:open(layer, fwin._viewdialog)
					state_machine.excute("hero_storage_hide_window", 0)
					state_machine.excute("hero_develop_page_manager", 0, 
						{
							_datas = {
								terminal_name = "hero_develop_page_manager", 	
								next_terminal_name = "hero_develop_page_open_train_page",	
								current_button_name = "Button_peiyang",  	
								but_image = "", 	
								terminal_state = 0, 
								shipId = params._datas._ship_id,
								openWinId = 3,
								isPressedActionEnabled = false
							}
						}
					)
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],3, fun_open_condition.tip_info))
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
				local find_first_open = false
				for i, v in pairs(instance._dataCell) do
					if type(v._ship) == "table" and v._ship.ship_id == ship_id 
					 or v._ship == -1 and tonumber(ship_id) == 0 and v._indexadd == instance:getFormationPos("0", 1)
					 and find_first_open == false then
						find_first_open = true
						v.choose:setVisible(true)
						instance:changeScelecedHeroCell2(v)
					else
						v.choose:setVisible(false)
					end
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("Lformation_ship_cell_play_hero_animation",0,"begin")
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
				if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
					and ___is_open_fashion == true
					 then
           			
					local isOpen  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 2, fun_open_condition.level)
					if isOpen == true then
					--to do  没开启，暂时显示未开启
						app.load("client.packs.fashion.FashionDevelop")
						state_machine.excute("fashion_develop_open", 0,{_datas= {_pageType = 1}})

						-- TipDlg.drawTextDailog(_function_unopened_tip_string)
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 2, fun_open_condition.tip_info))
						-- TipDlg.drawTextDailog(_function_unopened_tip_string)
					end
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
				--print("---------",params._datas._show)
					local _show=params._datas._show
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
				local _self = params._datas._self
				local ship = _self.ship
				if ship == nil then
					return
				end
				app.load("client.formation.HeroInformation")
				state_machine.excute("hero_information_open_window", 0, ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 时装界面返回更新
        local formation_updata_fashion_terminal = {
            _name = "formation_updata_fashion",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateDrawChanageShipPageView()
				instance:updateDrawShipInfoAction()
				instance:drawShipHeadListView()
				instance:updateDrawPartnerView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 英雄信息更新
        local formation_advanced_updata_terminal = {
            _name = "formation_advanced_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:drawShipPageView()
				instance:drawShipHeadListView()
				local petInfo = nil
				--驯养了一个宠物
				if type(params) == "table" then 
					local typeTip = params[1] 
					local petId = params[2]
					local previousShip = {}
					local perAdd = dms.int(dms["pirates_config"], 328, pirates_config.param)
					if typeTip == "upPet" then 
						--上阵 更换
						if petId > 0 then 
							--更换
							local prePetId = instance.ship.pet_equip_id
		            		local pet = _ED.user_ship[""..prePetId]
		            		petInfo = _ED.user_ship[""..petId]
							previousShip.ship_id = 0
		        			previousShip.ship_courage = tonumber(pet.ship_courage)
		        			previousShip.ship_health = tonumber(pet.ship_health)
		        			previousShip.ship_intellect = tonumber(pet.ship_intellect)
		        			previousShip.ship_quick = tonumber(pet.ship_quick)
						else
							--上阵
							local prePetId = _ED.user_ship[""..instance.ship.ship_id].pet_equip_id
		            		local pet = _ED.user_ship[""..prePetId]
							previousShip.ship_id = 1 
		        			previousShip.ship_courage =  math.floor(tonumber(pet.ship_courage)*perAdd/100)
		        			previousShip.ship_health = math.floor(tonumber(pet.ship_health)*perAdd/100)
		        			previousShip.ship_intellect = math.floor(tonumber(pet.ship_intellect)*perAdd/100)
		        			previousShip.ship_quick = math.floor(tonumber(pet.ship_quick)*perAdd/100)
						end
					elseif typeTip == "downPet" then 
						--下阵
	            		local pet = _ED.user_ship[""..petId]
						previousShip.ship_id = -1 
	        			previousShip.ship_courage = -math.floor(tonumber(pet.ship_courage)*perAdd/100)
	        			previousShip.ship_health = -math.floor(tonumber(pet.ship_health)*perAdd/100)
	        			previousShip.ship_intellect = -math.floor(tonumber(pet.ship_intellect)*perAdd/100)
	        			previousShip.ship_quick = -math.floor(tonumber(pet.ship_quick)*perAdd/100)
					end
					instance:showPetPropertyChangeTipInfo(previousShip,petInfo)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--强化入口--点击后弹出气泡 (强化大师，一键强化·)
		local formation_show_strengthen_enter_terminal = {
            _name = "formation_show_strengthen_enter",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:showStrengthenMenu()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --一键强化
    	local formation_show_strengthen_once_terminal = {
            _name = "formation_show_strengthen_once",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

            	if instance.ship == nil or zstring.tonumber(instance.ship.ship_id) < 0 then 
            		return
            	end
				state_machine.lock("formation_show_strengthen_once")
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
		    		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		    	
			    		if response.node ~= nil and response.node.roots ~= nil then
			    			response.node:updateDrawEquipments(true)

			    			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
			    				response.node:showPropertyChangeTipInfoOfEquipment(previousShip,2)
			    			end	
			    			
			    			state_machine.unlock("formation_show_strengthen_once")
			    		end
		    		else
		    			state_machine.unlock("formation_show_strengthen_once")
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

		--弹出更换宠物
		local formation_hero_change_pet_terminal = {
            _name = "formation_hero_change_pet",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.pet.PetFormationChoiceWear")
        		local petChooseWindow = PetFormationChoiceWear:new()
        		petChooseWindow:init(2)
        		fwin:open(petChooseWindow, fwin._windows)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更新战宠数据
		local formation_pet_update_data_terminal = {
            _name = "formation_pet_update_data",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil then
					instance:updateDrawShipInfo()
            		
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
		--更换宠物成功后刷新
		-- ！！！这个地方需要优化
		local formation_hero_change_pet_update_terminal = {
            _name = "formation_hero_change_pet_update",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--params -1 下阵  1更新头像 2上阵 0 更换
            	if instance ~= nil and instance.roots ~= nil then
            		if params == 1 then
            		    --更新宠物头像  不需要刷新其他的
            			instance:onUpdateDrawPetChange()
            			return
            		end

            		local previousShip = {}
            		local ship = _ED.user_ship["".._ED.formation_pet_id]
            		if params == -1 then 
            			--下阵
            			previousShip.ship_id = -1 
            			previousShip.ship_courage = -zstring.tonumber(instance.ship.ship_courage)
            			previousShip.ship_health = -zstring.tonumber(instance.ship.ship_health)
            			previousShip.ship_intellect = -zstring.tonumber(instance.ship.ship_intellect)
            			previousShip.ship_quick = -zstring.tonumber(instance.ship.ship_quick)
            		elseif params == 2 then 
            			--上阵
            			previousShip.ship_id = 1 
            			previousShip.ship_courage = ship.ship_courage
            			previousShip.ship_health = ship.ship_health
            			previousShip.ship_intellect = ship.ship_intellect
            			previousShip.ship_quick = ship.ship_quick
            		else
            			--更换
            			previousShip.ship_id = 0 
            			previousShip.ship_courage = ship.ship_courage
            			previousShip.ship_health = ship.ship_health
            			previousShip.ship_intellect = ship.ship_intellect
            			previousShip.ship_quick = ship.ship_quick
            		end
            		instance:showPetPropertyChangeTipInfo(previousShip)
					instance:init(ship)
					instance:drawShipPageView()
					if ship == nil then 
						--
						if params == -1 then
							--阵容中下阵
							instance:onUpdatedrawPetDown()
						else
							--普通下阵
							instance:drawHeadQueue()
						end
					else
						instance:drawShipHeadListView()
					end
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --驯养战宠
		local formation_pet_equip_terminal = {
            _name = "formation_pet_equip",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if type(instance.ship) == "table" then 
            		--有英雄
            		local petId = zstring.tonumber(instance.ship.pet_equip_id)
            		if petId == 0 then 
            			--无战宠需要弹出列表
            			local maxOpenNum , currentCount = getPetOpenMaxAndCount()
						if currentCount < maxOpenNum then 
							--可以上阵 弹出列表
							app.load("client.packs.pet.PetFormationChoiceWear")
		   	        		local petChooseWindow = PetFormationChoiceWear:new()
		  	         		petChooseWindow:init(4,instance.ship)
			         		fwin:open(petChooseWindow, fwin._windows)
			         	else
			         		TipDlg.drawTextDailog(_pet_tipString_info[26])
						end
            		else
            			--有战宠弹出宠物信息
            			app.load("client.packs.pet.PetTrainSeeInfo")
            			state_machine.excute("pet_train_see_info_window_open",0,instance.ship)
            		end
        		else
        			TipDlg.drawTextDailog(_All_tip_string_info_description._lackHeadtip)
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(formation_hero_wear_click_terminal)
		state_machine.add(formation_page_formation_change_terminal)
		state_machine.add(formation_change_to_ship_page_view_terminal)
		state_machine.add(open_formation_head_info_terminal)
		state_machine.add(jump_formation_partner_info_terminal)
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
		state_machine.add(run_action_cell_terminal)
		state_machine.add(formation_cell_on_show_terminal)
		state_machine.add(formation_cell_on_hide_terminal)
		state_machine.add(formation_show_strengthen_master_terminal)
		state_machine.add(formation_property_change_tip_info_terminal)
		state_machine.add(formation_property_change_by_level_up_terminal)
		state_machine.add(formation_property_change_before_terminal)
		state_machine.add(formation_property_change_equip_info_terminal)
		state_machine.add(formation_other_interface_reset_terminal)
		state_machine.add(formation_play_into_action_terminal)
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
			and ___is_open_fashion == true
			 then
			state_machine.add(formation_updata_fashion_terminal)
		end
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			state_machine.add(formation_advanced_updata_terminal)
			state_machine.add(formation_show_strengthen_enter_terminal)
			state_machine.add(formation_show_strengthen_once_terminal)
		elseif __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
			state_machine.add(formation_back_to_home_page_terminal)
			state_machine.add(formation_hero_info_manager_terminal)
			state_machine.add(formation_hero_info_attributes_terminal)
			state_machine.add(formation_hero_info_details_terminal)
			state_machine.add(formation_click_hero_Level_up_page_terminal)
			state_machine.add(formation_click_hero_break_page_terminal)
			state_machine.add(formation_click_hero_develop_page_terminal)
			state_machine.add(formation_hero_info_change_terminal)
			state_machine.add(formation_hero_cell_index_update_terminal)
			state_machine.add(formation_hero_partners_show_or_hidden_terminal)
			state_machine.add(formation_go_to_hero_herodevelop_terminal)
		end
		state_machine.add(formation_hero_change_pet_terminal)
		state_machine.add(formation_hero_change_pet_update_terminal)
		state_machine.add(formation_pet_update_data_terminal)
		state_machine.add(formation_pet_equip_terminal)
		state_machine.init()
	end 

	init_formation_terminal()
end

function Formation:init(ship)
	self.ship = ship

	if self.ship~= nil then
		self.masterStrengthenlv[1],self.masterStrengthenlv[2],self.masterStrengthenlv[3],self.masterStrengthenlv[4] = self:Mason(self.ship.ship_id)
	end
end

function Formation:createShipHead(ship,objectType)
	local cell = ShipIconCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function Formation:createShipHeadIcon(ship,objectType)
	local cell = ShipHeadCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function Formation:createShipBody(ship,objectType,types,temp,_ship,	_lastStatus)
	local cell = ShipBodyCell:createCell()
	cell:init(ship,objectType,types,temp,_ship,_lastStatus)
	return cell
end

function Formation:createEquipHead(objectType,ship)
	local cell = EquipIconCell:createCell()
	cell:init(objectType,ship)
	return cell
end

function Formation:createPartnerCell()
	local cell = ShipPartnerCell:createCell()	
	cell:init()
	return cell
end

function Formation:createLockAction(objectType,data)
	local cell = FormationLockActionCell:createCell()	
	cell:init(objectType,data)
	return cell
end

function Formation:createAddActionCell(objectType,data,tipsType,isHaveShip)
	local cell = AddActionCellCell:createCell()
	cell:init(objectType,data,tipsType,isHaveShip)
	return cell
end

function Formation:createAddandLockCell(objectType,data, num)
	local cell = AddAndLockCell:createCell()
	cell:init(objectType,data,num)
	return cell
end

--战宠图标
function Formation:createPetCell(ship,objectType)
	app.load("client.cells.pet.pet_icon_cell")
	local cell = PetIconCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function Formation:createShipPartnerPlace(objectType)
	local cell = FormationPartnerPlaceCell:createCell()
	cell:init(objectType)
	return cell
end

function Formation:createPartnerScroll(objectType)
	local cell = FormationPartnerInfoListCell:createCell()
	cell:init(objectType)
	return cell
end

function Formation:Mason(shipId)
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
function Formation:activateLot(shipID)
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
	getPersonName = dms.string(dms["ship_mould"], ship_base_template_id, ship_mould.captain_name)
	
	
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
function Formation:showPropertyChangeTipInfo(previousShip,types,temp,ker)
	-- 计算两次换将之后的属性差

	-- previousShip = {
		-- ship_courage = pship.ship_courage,--攻击
		-- ship_health = pship.ship_health,--生命
		-- ship_intellect = pship.ship_intellect,--物防
		-- ship_quick = pship.ship_quick,--法防
	-- }
	
	local ship_courage = 0
	local ship_health = 0
	local ship_intellect = 0
	local ship_quick = 0
	--print("previousShip.ship_id",previousShip.ship_id)
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
		-- print("",ship_courage,ship_health,ship_intellect,ship_quick)		
		-- print("self.ship.ship_courage，previousShip.ship_courage",self.ship.ship_courage, zstring.tonumber(previousShip.ship_courage))
		-- print("self.ship.ship_health，previousShip.ship_health",self.ship.ship_health, zstring.tonumber(previousShip.ship_health))		
		-- print("self.ship.ship_intellect,previousShip.ship_intellect",self.ship.ship_intellect, zstring.tonumber(previousShip.ship_intellect))	
		-- print("self.ship.ship_quick，previousShip.ship_quick",self.ship.ship_quick, zstring.tonumber(previousShip.ship_quick))	
				
	end
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	-- print(self.ship.gongji,self.ship.shengming ,self.ship.waigong,self.ship.neigong)
	-- print(ship_courage,ship_health,ship_intellect,ship_quick)
		if self.ship.gongji == ship_courage and self.ship.shengming == ship_health and self.ship.waigong == ship_intellect and  self.ship.neigong == ship_quick then
			self.ship.shengming = 0
			self.ship.gongji = 0
			self.ship.waigong = 0
			self.ship.neigong = 0			
			return
		end
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
		if tonumber(self.ship.captain_type) == 0 then
			getPersonName = _ED.user_info.user_name
		else
			getPersonName = dms.string(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.captain_name)
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
					for i,v in pairs(shipName) do
						for j,k in pairs(_ED.user_ship) do
							if zstring.tonumber(k.little_partner_formation_index) <= 0 then
								if zstring.tonumber(k.ship_base_template_id) == person[i] then
									if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
										local myRelatioInfo2 = zstring.zsplit(dms.string(dms["ship_mould"], k.ship_base_template_id, ship_mould.relationship_id), ",")
										local shipHaveRela = false
										for i,v in pairs(myRelatioInfo2) do
											local name2 = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
											if name2 == name then
												shipHaveRela = true
											end
										end
										if shipHaveRela == true then
											table.insert(textData, {nameOne = v, nameTwo = name})
										end
									else
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
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
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
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			state_machine.excute("Lformation_ship_cell_play_hero_animation",0,"begin")
		end
	elseif types == 2 then
		-- str = tipStringInfo_hero_change_Type[4]
	elseif types == 3 then
		-- str = tipStringInfo_hero_change_Type[5]
	elseif types == 6 then -- 上阵英雄成功
		str = tipStringInfo_hero_change_Type[6]
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			state_machine.excute("Lformation_ship_cell_play_hero_animation",0,"begin")
		end
	elseif types == 7 then  -- 上阵宠物成功
		str = tipStringInfo_hero_change_Type[6]
	end
	tipInfo:init(1,str, textData)	
	fwin:open(tipInfo, fwin._view)
	if __lua_project_id ==__lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		--动画播完后 需要清零原先的属性变化
		previousShip.ship_courage=0
		previousShip.ship_health=0
		previousShip.ship_intellect=0
		previousShip.ship_quick=0
	end
end

-- 显示宠物属性变更的提示信息
function Formation:showPetPropertyChangeTipInfo(previousShip,pet)
	-- 计算两次换将之后的属性差
	local ship_courage = 0
	local ship_health = 0
	local ship_intellect = 0
	local ship_quick = 0
	if zstring.tonumber(previousShip.ship_id) == -1
		or zstring.tonumber(previousShip.ship_id) == 1 
	 then
		--下阵 上阵
		ship_courage = zstring.tonumber(previousShip.ship_courage)
		ship_health = zstring.tonumber(previousShip.ship_health)
		ship_intellect = zstring.tonumber(previousShip.ship_intellect)
		ship_quick = zstring.tonumber(previousShip.ship_quick)
	else
		--更换
		if pet ~= nil then 
			--跟换驯养
			local perAdd = dms.int(dms["pirates_config"], 328, pirates_config.param)
			ship_courage = math.floor(tonumber(previousShip.ship_courage - zstring.tonumber(pet.ship_courage))*perAdd/100)
			ship_health = math.floor(tonumber(previousShip.ship_health - zstring.tonumber(pet.ship_health))*perAdd/100)
			ship_intellect = math.floor(tonumber(previousShip.ship_intellect - zstring.tonumber(pet.ship_intellect))*perAdd/100)
			ship_quick = math.floor(tonumber(previousShip.ship_quick - zstring.tonumber(pet.ship_quick))*perAdd/100)
		else
			if self.ship ~= nil then 
				ship_courage = zstring.tonumber(previousShip.ship_courage) - zstring.tonumber(self.ship.ship_courage)
				ship_health = zstring.tonumber(previousShip.ship_health) - zstring.tonumber(self.ship.ship_health)
				ship_intellect = zstring.tonumber(previousShip.ship_intellect) - zstring.tonumber(self.ship.ship_intellect)
				ship_quick = zstring.tonumber(previousShip.ship_quick) - zstring.tonumber(self.ship.ship_quick)
			end	
		end
	end
	local textData = {}			
	local equips_id = {}

	table.insert(textData, {property = _property[2], value = ship_courage})
	table.insert(textData, {property = _property[1], value = ship_health})
	table.insert(textData, {property = _property[3], value = ship_intellect})
	table.insert(textData, {property = _property[4], value = ship_quick})
	app.load("client.cells.utils.property_change_tip_info_cell") 
	local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
	local str =  _pet_tipString_info[19]
	tipInfo:init(1,str, textData)	
	fwin:open(tipInfo, fwin._view)
end

--初始化选中框
function Formation:createSelectedCursor()
	local cell = SelectedCursor:createCell()
	cell:init()
	return cell
end

function Formation:chanageToShipPageView(pageViewIndex)
	
end

function Formation:selectedPad()

end

-- 绘制武将小图像列表：主角、其它上阵武将、上阵位的开启状态及小伙伴入口
function Formation:drawShipHeadListView()
	self:drawScrollView()
end

local function createLHeroCardCell(ship,tpyes,index)
	local cardLayout = LformationChangeHeroCell:createCell()
	cardLayout:init(ship,tpyes,index)
	return cardLayout
end

-- 绘制阵容界面中所有的武将，包含未装备武将位置的显示
function Formation:drawShipPageView()
	local root = self.roots[1]
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then				--龙虎门项目控制
		-- ccui.Helper:seekWidgetByName(root, "Panel_1_4"):removeAllChildren(true)
		local last_index = 1
		local HomeHeroWnd = fwin:find("HomeHeroClass")
		if HomeHeroWnd ~= nil then
			last_index = HomeHeroWnd.current_formetion_index
		end
		-- if self.ship~= nil and self.ship~="" then
			-- local heroCard = createLHeroCardCell(self.ship,last_index)
			-- ccui.Helper:seekWidgetByName(root, "Panel_1_4"):addChild(heroCard)
		-- else
			-- -测试代码方便可以上阵
			-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1_4"), nil, 
			-- {
				-- terminal_name = "open_add_ship_window",
				-- terminal_state = 0,
				-- _index = last_index, 
				-- _type = 1, 
				-- _shipId = -1,
			-- }, 
			-- nil, 0)
			
		-- end	
		local heroPanel = ccui.Helper:seekWidgetByName(root, "Panel_1_4")
		
		heroPanel:removeChild(heroPanel._nodeChild, true)
		local cell = nil
		-- if self.ship == nil then
			-- 可上阵位置的黑影显示
			-- local cell = self:createShipBody(self.ship,1,nil,self.moveLayer._current_cell._index,self.moveLayer._current_cell._ship,self._lastStatus)
			-- heroPanel:addChild(cell)
			-- heroPanel._nodeChild = cell
			-- self.heroCell = cell
			-- ccui.Helper:seekWidgetByName(cell, "Panel_dh"):setTouchEnabled(false)
			-- heroPanel:setTouchEnabled(false)
			local cell = createLHeroCardCell(self.ship,1,last_index)
			local panel_size = heroPanel:getContentSize()
			heroPanel:addChild(cell)
			heroPanel._nodeChild = cell
			self.heroCell = cell
			heroPanel.roots = cell.roots
		-- else
			-- if self.bust_index_args == nil then
				-- self.bust_index_args = {}
			-- end	
		
			-- local _ship_mould_id = self.ship.ship_template_id
			-- local temp_bust_index = dms.int(dms["ship_mould"], _ship_mould_id, ship_mould.bust_index)
			-- table.insert(self.bust_index_args, temp_bust_index)
			
			-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
			
			-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
			-- cell:getAnimation():playWithIndex(0)
			
			-- cell:setAnchorPoint(cc.p(0.5, 0.5))
			
			-- local panel_size = heroPanel:getContentSize()
			
			-- cell:setPosition(cc.p(panel_size.width, panel_size.height/2))
			-- cell:setContentSize(panel_size)
			
			-- heroPanel:addChild(cell)
			-- heroPanel._nodeChild = cell
			-- self.heroCell = cell
			-- fwin:addTouchEventListener(heroPanel, nil, {terminal_name = "open_formation_head_info", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
		-- end
	else
		self.headPageView = ccui.Helper:seekWidgetByName(root, "PageView_2")

		local heroPanel = ccui.Helper:seekWidgetByName(root, "Panel_92")
		
		heroPanel:removeChild(heroPanel._nodeChild, true)
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			local cell = nil
			if self.ship == nil then
				-- 可上阵位置的黑影显示
				local cell = self:createShipBody(self.ship,1,nil,self.moveLayer._current_cell._index,self.moveLayer._current_cell._ship,self._lastStatus)
				heroPanel:addChild(cell)
				heroPanel._nodeChild = cell
				self.heroCell = cell
				ccui.Helper:seekWidgetByName(cell, "Panel_dh"):setTouchEnabled(false)
			else
				if self.bust_index_args == nil then
					self.bust_index_args = {}
				end	
			
				local _ship_mould_id = self.ship.ship_template_id
				
				local temp_bust_index = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					----------------------新的数码的形象------------------------
					--进化形象
					local evo_image = dms.string(dms["ship_mould"], _ship_mould_id, ship_mould.fitSkillTwo)
					local evo_info = zstring.split(evo_image, ",")
					--进化模板id
					local ship_evo = zstring.split(self.ship.evolution_status, "|")
					local evo_mould_id = evo_info[tonumber(ship_evo[1])]
					--新的形象编号
					temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				else
					temp_bust_index = dms.int(dms["ship_mould"], _ship_mould_id, ship_mould.bust_index)
				end
				table.insert(self.bust_index_args, temp_bust_index)
				
				-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
				
				-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
				-- cell:getAnimation():playWithIndex(0)
				
				-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
				
				-- local panel_size = heroPanel:getContentSize()
				
				-- -- cell:setPosition(cc.p(panel_size.width, panel_size.height/2))
				-- -- cell:setContentSize(panel_size)
				-- cell:setPosition(cc.p(panel_size.width / 2, 0))
				
				-- heroPanel:addChild(cell)

				local shipPanel = heroPanel
				-- shipPanel:removeAllChildren(true)
				draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
				if animationMode == 1 then
					app.load("client.battle.fight.FightEnum")
					local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				        shipSpine:setScaleX(-1)
				    end
				else
					draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
				end


				heroPanel._nodeChild = cell
				self.heroCell = cell
			end
		else
			local cell = self:createShipBody(self.ship,1,nil,self.moveLayer._current_cell._index,self.moveLayer._current_cell._ship,self._lastStatus)
			heroPanel:addChild(cell)
			heroPanel._nodeChild = cell
			self.heroCell = cell
			if __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then 
				ccui.Helper:seekWidgetByName(cell, "Panel_image"):setTouchEnabled(false)
			else
				ccui.Helper:seekWidgetByName(cell, "Panel_dh"):setTouchEnabled(false)
			end
			
		end
		
		if self.ship == nil then
			ccui.Helper:seekWidgetByName(root, "Image_73"):setVisible(false)
		else
			ccui.Helper:seekWidgetByName(root, "Image_73"):setVisible(true)
		end
	end
end



-- 更新当前武将的所有装备绘图
function Formation:updateDrawEquipments(isPlayAction)
	local root = self.roots[1]
	local shop_equip_position = {
		"Panel_17_1",
		"Panel_17_4",
		"Panel_17_2",
		"Panel_17_5",
		"Panel_17_3",
		"Panel_17_6",
	}
	
		
	--绘制武将装备位上的装备
	for i=1, 6 do
		local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
		equipPlaceInfo:removeChild(equipPlaceInfo._nodeChild, true)
		equipPlaceInfo._nodeChild = nil
	end
	
	local status = false
	local status2 = false
	if zstring.tonumber(_ED.user_info.user_grade) < 15 then
		for i=1, 6 do
			if i <= 4 then
				if zstring.tonumber(_ED.user_info.user_grade) < 6 then
					local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
					equipPlaceInfo:removeChild(equipPlaceInfo._nodeChild, true)
					equipPlaceInfo._nodeChild = nil
					equipPlaceInfo:setBackGroundImage("images/ui/quality/lock_baowu.png")
					status = true
					
					local function changeTipCallback2(sender, eventType)
						if eventType == ccui.TouchEventType.ended then
							if zstring.tonumber(_ED.user_info.user_grade) < 6 then
								TipDlg.drawTextDailog(_string_piece_info[343])
							end
						end	
					end
					
					ccui.Helper:seekWidgetByName(root, "Panel_17_1"):addTouchEventListener(changeTipCallback2)
					ccui.Helper:seekWidgetByName(root, "Panel_17_2"):addTouchEventListener(changeTipCallback2)
					ccui.Helper:seekWidgetByName(root, "Panel_17_4"):addTouchEventListener(changeTipCallback2)
					ccui.Helper:seekWidgetByName(root, "Panel_17_5"):addTouchEventListener(changeTipCallback2)
				else
					local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
					equipPlaceInfo:removeBackGroundImage()
				end
			else
				local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
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
				
				ccui.Helper:seekWidgetByName(root, "Panel_89"):addTouchEventListener(changeTipCallback)
				ccui.Helper:seekWidgetByName(root, "Panel_90"):addTouchEventListener(changeTipCallback)
				status2 = true
			end
		end
	else
		for i=1, 6 do
			local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
			equipPlaceInfo:removeBackGroundImage()
		end
	end

	if self.ship == nil or self.ship == 0 then
		for i=1, 6 do
			if i <= 4 and status == false then
				local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
				local addcell = self:createAddActionCell(1,i-1,
					self.queue.shiptype[zstring.tonumber(self.moveLayer._current_cell._index)],false)
				equipPlaceInfo:addChild(addcell)
				equipPlaceInfo._nodeChild = addcell
			elseif i > 4 and i <= 6 and status2 == false then
				local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
				local addcell = self:createAddActionCell(1,i-1,self.queue.shiptype[zstring.tonumber(self.moveLayer._current_cell._index)],false)
				equipPlaceInfo:addChild(addcell)
				equipPlaceInfo._nodeChild = addcell
			end
		end
		return
	end
	local equipNumber = 0
	for i, equip in pairs(self.ship.equipment) do
		local equipPlaceInfo = ccui.Helper:seekWidgetByName(root, shop_equip_position[i])
		if i <= 4 and status == false then
			if zstring.tonumber(equip.ship_id) > 0 then
				local cell = self:createEquipHead(1,equip)
				equipPlaceInfo:addChild(cell)
				cell:setPosition(cell:getPositionX()-2.5,cell:getPositionY()-3)
				equipPlaceInfo._nodeChild = cell
				equipNumber = equipNumber + 1
			else
				------------------------------------------------------------
				if i<=6 then
					local addcell = self:createAddActionCell(1,i-1,self.queue.shiptype[zstring.tonumber(self.moveLayer._current_cell._index)])
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
					local addcell = self:createAddActionCell(1,i-1,self.queue.shiptype[zstring.tonumber(self.moveLayer._current_cell._index)])
					equipPlaceInfo:addChild(addcell)
					equipPlaceInfo._nodeChild = addcell
				end
				----------------------end---------------------------------------------------------
			end
		end
	end
	
	--播放一键强化动画  数码宝贝
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		if isPlayAction ~= nil and isPlayAction == true then 
			if equipNumber <= 0 then  return end
				local parentPanel = {
					"Panel_81",
					"Panel_82",
					"Panel_84",
					"Panel_86",
					"Panel_88",
					"Panel_90",
				}
				for i=1,4 do
					local equip = self.ship.equipment[i]
					if equip ~= nil and zstring.tonumber(equip.ship_id) > 0 then
						local armationPanel = ccui.Helper:seekWidgetByName(root, parentPanel[i])
						local ArmatureNode_1 = armationPanel:getChildByName("ArmatureNode_4"..i)
				    	draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
				    	csb.animationChangeToAction(ArmatureNode_1, 0, 0, false)
						ArmatureNode_1:setVisible(true)
				    	ArmatureNode_1._invoke = function(armatureBack)
				        if armatureBack:isVisible() == true then
				            armatureBack:setVisible(false)
				            self:updateDrawShipInfo()	
				        end
    				end
				end
			end
		end
	end
end

-- 更新当前武将的所有基础属性的帧动画
function Formation:updateDrawShipInfoAction(params)
	if __lua_project_id == __lua_project_yugioh then
		local root = self.roots[1]
		local Panel_shuxing = ccui.Helper:seekWidgetByName(root, "Panel_shuxing")
		local Panel_zhongzu = ccui.Helper:seekWidgetByName(root, "Panel_zhongzu")
		Panel_shuxing:removeBackGroundImage()
		Panel_zhongzu:removeBackGroundImage()
	end
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
		local ship_courage_text = ccui.Helper:seekWidgetByName(root, shipAttribute[2])
		local ship_health_text = ccui.Helper:seekWidgetByName(root, shipAttribute[3])
		local ship_intellect_text = ccui.Helper:seekWidgetByName(root, shipAttribute[4])
		local ship_quick_text = ccui.Helper:seekWidgetByName(root, shipAttribute[5])

		local old_ship_courage 	= zstring.tonumber(ship_courage_text:getString())
		local old_ship_health	= zstring.tonumber(ship_health_text:getString())
		local old_ship_intellect	= zstring.tonumber(ship_intellect_text:getString())
		local old_ship_quick 	= zstring.tonumber(ship_quick_text:getString())

		if __lua_project_id == __lua_project_yugioh then
			local Panel_shuxing = ccui.Helper:seekWidgetByName(root, "Panel_shuxing")
			local Panel_zhongzu = ccui.Helper:seekWidgetByName(root, "Panel_zhongzu")
			Panel_shuxing:removeBackGroundImage()
			Panel_zhongzu:removeBackGroundImage()
			local faction_id = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.faction_id)
			local attribute_id = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.attribute_id)
			Panel_shuxing:setBackGroundImage(string.format("images/ui/quality/shuxing_%s.png", attribute_id))
			Panel_zhongzu:setBackGroundImage(string.format("images/ui/quality/zhongzu_%s.png", faction_id))
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
		local ship_levels=nil 
		local ship_level_text=nil
		local change_ship_level=nil
		local old_ship_leveltext=nil
		local old_ship_level=nil
		local arrry={}
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			ship_level_text = ccui.Helper:seekWidgetByName(root, shipAttribute[1])
			old_ship_leveltext	= ship_level_text:getString()
			array= zstring.split(old_ship_leveltext,"/")
			old_ship_level=array[1]
			change_ship_level 	= math.floor((zstring.tonumber(self.ship.ship_grade) - old_ship_level)*0.1)
		end
		
		local change_ship_courage 	= math.floor((zstring.tonumber(self.ship.ship_courage) - old_ship_courage)*0.1)
		local change_ship_health	= math.floor((zstring.tonumber(self.ship.ship_health) - old_ship_health)*0.1)
		local change_ship_intellect	= math.floor((zstring.tonumber(self.ship.ship_intellect) - old_ship_intellect)*0.1)
		local change_ship_quick 	= math.floor((zstring.tonumber(self.ship.ship_quick) - old_ship_quick)*0.1)
		
		--动画帧-----------------------------------------------------
		self.action = csb.createTimeline("formation/line_up.csb")
		self.action:play("text_up_dh", false)
		self.roots[1]:runAction(self.action)
		local function addTextNum(_ship_courage, _ship_health, _ship_intellect, _ship_quick,_ship_level)
			ship_courage_text:setString(_ship_courage)
			ship_health_text:setString(_ship_health)
			ship_intellect_text:setString(_ship_intellect)
			ship_quick_text:setString(_ship_quick)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				ship_level_text:setString(_ship_level.."/".._ED.user_info.user_grade)
			end
		end
		
		local findex = 1
		self.action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end
			local str = frame:getEvent()
			local ffeventName = string.format("text_up_1%d", findex)
			if str == "over" then
				self:updateDrawShipInfo()
			elseif str == ffeventName then
				if findex == 10 then
					if fwin:find("FormationClass") ~= nil and self.ship ~= nil then
						addTextNum(self.ship.ship_courage, self.ship.ship_health, self.ship.ship_intellect, self.ship.ship_quick,self.ship.ship_grade)
					end
				else	
					old_ship_courage 	= old_ship_courage + change_ship_courage
					old_ship_health 	= old_ship_health + change_ship_health
					old_ship_intellect 	= old_ship_intellect + change_ship_intellect
					old_ship_quick 		= old_ship_quick + change_ship_quick
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						old_ship_level = old_ship_level +change_ship_level
					else
						old_ship_level = nil
					end

					addTextNum(old_ship_courage, old_ship_health, old_ship_intellect, old_ship_quick,old_ship_level)
				end
				findex = findex + 1
			end
		end)
	else
		self:updateDrawShipInfo()
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:updateDrawShipInfo()
	end
end


-- 更新当前武将的所有基础属性
function Formation:updateDrawShipInfo()
	local root = self.roots[1]
	local shipAttribute={
		"Text_3_5",--等级
		"Text_3_6",--攻击
		"Text_3_7",--生命
		"Text_3_8",--物防
		"Text_3_9",--法防
		"Text_41",--名称
		"Text_65",--阶位
	}
	if __lua_project_id == __lua_project_yugioh then
		local Panel_shuxing = ccui.Helper:seekWidgetByName(root, "Panel_shuxing")
		local Panel_zhongzu = ccui.Helper:seekWidgetByName(root, "Panel_zhongzu")
		Panel_shuxing:removeBackGroundImage()
		Panel_zhongzu:removeBackGroundImage()
	end
	if self.ship ~= nil then
		local hero_name = self.ship.captain_name
		local hero_grade = self.ship.ship_grade
		local name = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]
		else
			name = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_name)
			if zstring.tonumber(self.ship.captain_type) == 0 then
				name = _ED.user_info.user_name
				hero_grade = _ED.user_info.user_grade
			end
		end
		local rankLevelFront = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.initial_rank_level)
		local ship_type = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type)
		
		
			
		if __lua_project_id == __lua_project_yugioh then
			local Panel_shuxing = ccui.Helper:seekWidgetByName(root, "Panel_shuxing")
			local Panel_zhongzu = ccui.Helper:seekWidgetByName(root, "Panel_zhongzu")
			Panel_shuxing:removeBackGroundImage()
			Panel_zhongzu:removeBackGroundImage()
			local faction_id = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.faction_id)
			local attribute_id = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.attribute_id)
			Panel_shuxing:setBackGroundImage(string.format("images/ui/quality/shuxing_%s.png", attribute_id))
			Panel_zhongzu:setBackGroundImage(string.format("images/ui/quality/zhongzu_%s.png", faction_id))
		end

		ccui.Helper:seekWidgetByName(root, shipAttribute[1]):setString(hero_grade.."/".._ED.user_info.user_grade)
		ccui.Helper:seekWidgetByName(root, shipAttribute[2]):setString(self.ship.ship_courage)
		ccui.Helper:seekWidgetByName(root, shipAttribute[3]):setString(self.ship.ship_health)
		ccui.Helper:seekWidgetByName(root, shipAttribute[4]):setString(self.ship.ship_intellect)
		ccui.Helper:seekWidgetByName(root, shipAttribute[5]):setString(self.ship.ship_quick)
		if ___is_open_leadname == true then
			if Formation.__userHeroFontName == nil then
				Formation.__userHeroFontName = ccui.Helper:seekWidgetByName(root, shipAttribute[6]):getFontName()
			end
			if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then
				ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setFontName("")
				ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setFontSize(ccui.Helper:seekWidgetByName(root, shipAttribute[6]):getFontSize())-->设置字体大小
			else
				ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setFontName(Formation.__userHeroFontName)
			end
		end
		ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setString(name)
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b) then
			local posX = ccui.Helper:seekWidgetByName(root, shipAttribute[7]):getPositionX() - ccui.Helper:seekWidgetByName(root, shipAttribute[6]):getPositionX()
			local wid = ccui.Helper:seekWidgetByName(root, shipAttribute[6]):getContentSize().width
			if wid/2 > posX then
				ccui.Helper:seekWidgetByName(root, shipAttribute[7]):setPosition(cc.p(ccui.Helper:seekWidgetByName(root, shipAttribute[7]):getPositionX()+(wid/2-posX),ccui.Helper:seekWidgetByName(root, shipAttribute[7]):getPositionY()))
			else
			end 
		end
		if zstring.tonumber(rankLevelFront) > 0 and ship_type ~= 3 then
			--宠物不显示+等级
			ccui.Helper:seekWidgetByName(root, shipAttribute[7]):setString("+"..rankLevelFront)
		else
			ccui.Helper:seekWidgetByName(root, shipAttribute[7]):setString("")
		end
		
		local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
		ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		ccui.Helper:seekWidgetByName(root, shipAttribute[7]):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		local isleadtype = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type)
		
		
		if zstring.tonumber(isleadtype) > 0 then
			if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
				and ___is_open_fashion == true
				 then
				ccui.Helper:seekWidgetByName(root, "Panel_14"):setVisible(false)
			end
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				ccui.Helper:seekWidgetByName(root, "Button_change_skills"):setVisible(false)
			end
			ccui.Helper:seekWidgetByName(root, "Button_5_0"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_5_1"):setVisible(true)
		else
			if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
				and ___is_open_fashion == true 
				 then
				ccui.Helper:seekWidgetByName(root, "Panel_14"):setVisible(true)
			end
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				ccui.Helper:seekWidgetByName(root, "Button_change_skills"):setVisible(true)
			end
			ccui.Helper:seekWidgetByName(root, "Panel_14"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_5_0"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_5_1"):setVisible(false)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local Button_line_qianghua = ccui.Helper:seekWidgetByName(root, "Button_line_qianghua")
			Button_line_qianghua:setVisible(true)
		end
		ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(true)
		-------宠物刷新
		
		if ship_type == 3 then 
			local currentLevel =  dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.initial_rank_level)
			for i=1,5 do
				local starImage = ccui.Helper:seekWidgetByName(root, "Image_x_".. i)
				starImage:setVisible(false)
				if i <= currentLevel then 
					starImage:setVisible(true)
				end
			end
			local Text_skill1 = ccui.Helper:seekWidgetByName(root, "Text_pum_pet")
			local Text_skill2 = ccui.Helper:seekWidgetByName(root, "Text_jim_pet")
			local skill_id1 = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.skill_mould)
			local skill_id2 = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.deadly_skill_mould)
			Text_skill1:setString(dms.string(dms["skill_mould"],skill_id1,skill_mould.skill_name))
			Text_skill2:setString(dms.string(dms["skill_mould"],skill_id2,skill_mould.skill_name))

			local pet_id = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.base_mould2)
		    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
		    ccui.Helper:seekWidgetByName(root, "Text_zl"):setString("".. self.ship.hero_fight)
		    local pet_formations = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
		    for i=1,6 do
		    	local image = ccui.Helper:seekWidgetByName(root, "Image_zw_"..i .. "_0")
		    	image:setVisible(false)	
		    	local formationText = ccui.Helper:seekWidgetByName(root, "Text_zw"..i)
		    	formationText:setString("")
		    end
		    local level = zstring.tonumber(self.ship.train_level)
		    if pet_formations ~= nil then
		        --有阵型加成
		        local addFormation = nil
		        for k,v in pairs(pet_formations) do
		            if level == zstring.tonumber(v[3]) then 
		                addFormation = v
		                break
		            end
		        end
		        if addFormation == nil then 
		            return
		        end
		        local formations = {}
		        local counts = 0
		        for i=1,6 do
		        	local image = ccui.Helper:seekWidgetByName(root, "Image_zw_"..i .. "_0")
		    		local attribute = addFormation[5+i]
		            local lenghtAdd = string.len(attribute)
		            local value = 1
		            local index = 1
		            if lenghtAdd > 2 then 
		            	image:setVisible(true)
			        	local info = zstring.split("".. attribute,"|")
			        	if info ~= nil and #info == 2 then
			        		--两种属性 必然是防御 物理防御，法术防御
			        		index = 40
			        		value = zstring.tonumber(zstring.split(""..info[1],",")[2])
		              	end
			         	if info ~= nil and #info == 1 then 
		                    --一种属性
		                    local addAttribute = zstring.split("".. info[1],",")
		                    index = zstring.tonumber(addAttribute[1]) + 1
		                    value = zstring.tonumber(addAttribute[2])
		               	end
		                counts = counts + 1
			            local formationText = ccui.Helper:seekWidgetByName(root, "Text_zw"..counts)
			            formationText:setString("" .._pet_tipString_info[13] .. i .. " " .. string_equiprety_name[index] .. value..string_equiprety_name_vlua_type[index])
		        	end
			    end
		    end
		end
	else
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
			and ___is_open_fashion == true
			 then
			ccui.Helper:seekWidgetByName(root, "Panel_14"):setVisible(false)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local Button_line_qianghua = ccui.Helper:seekWidgetByName(root, "Button_line_qianghua")
			Button_line_qianghua:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_change_skills"):setVisible(false)
		end
		ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_5_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_5_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, shipAttribute[1]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[2]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[3]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[4]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[5]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[6]):setString(" ")
		ccui.Helper:seekWidgetByName(root, shipAttribute[7]):setString(" ")

		local Text_skill1 = ccui.Helper:seekWidgetByName(root, "Text_pum_pet")
		local Text_skill2 = ccui.Helper:seekWidgetByName(root, "Text_jim_pet")
		if Text_skill1 ~= nil then 
			Text_skill1:setString("")
		end
		if Text_skill2 ~= nil then 
			Text_skill2:setString("")
		end
	end
	
	local shipRelation={
		"Text_27",--缘分1
		"Text_27_2",--缘分2
		"Text_27_0",--缘分3
		"Text_27_3",--缘分4
		"Text_27_1",--缘分5
		"Text_27_4",--缘分6
	}
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
	for i=1, 6 do
		local relationshipLabel = ccui.Helper:seekWidgetByName(root, shipRelation[i])
		if self.ship ~= nil then
			local relationship = nil
			-- if zstring.tonumber(self.ship.relationship_count) > 6 then
				-- relationship = self.ship.relationship[i+6]
			-- else
				relationship = list[i]
			-- end
			if relationship ~= nil then
				if zstring.tonumber(self.ship.relationship_count) > 6 then
					if list[i+6] ~= nil and zstring.tonumber(list[i+6].is_activited) == 1 then
						relationship = list[i+6]
					end
				end
				if zstring.tonumber(self.ship.captain_type) == 0 then
					-- if zstring.tonumber(self.ship.ship_type) >= 3 then
						-- relationship = self.ship.relationship[i+6]
						-- local relationName= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_name)
						-- relationshipLabel:setString(relationName)
					-- else
						local relationName= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_name)
						relationshipLabel:setString(relationName)
					-- end
				else
					local relationName= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_name)
					relationshipLabel:setString(relationName)
				end
				
				if zstring.tonumber(relationship.is_activited) == 1 then
					relationshipLabel:setColor(cc.c3b(formation_relationship_color_Type_two[2][1],formation_relationship_color_Type_two[2][2],formation_relationship_color_Type_two[2][3]))
				else
					relationshipLabel:setColor(cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]))
				end
			else
				relationshipLabel:setString(" ")
			end
		else
			relationshipLabel:setString(" ")
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
	
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
	-- else
		ccui.Helper:seekWidgetByName(root, "Text_52"):setString(relationshipOpenCount)
	-- end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		-- local panel = ccui.Helper:seekWidgetByName(root, "Panel_7")
		-- panel:removeAllChildren(true)
		-- app.load("client.formation.FormationSeeHeroIn")
		-- local heroInfo = FormationSeeHeroIn:createCell()
		-- heroInfo:init(self.ship)
		-- panel:addChild(heroInfo)
		-- ccui.Helper:seekWidgetByName(root, "Button_5_1"):setVisible(false)
		
		local type_pad = ccui.Helper:seekWidgetByName(root, "Panel_7_0")
		local ability_text = ccui.Helper:seekWidgetByName(root, "Text_101_0_0")
		local intro_text = ccui.Helper:seekWidgetByName(root, "Text_xinxijieshao")
		if self.ship ~= nil then
			-- 类型
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			else
				local type_data = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.capacity)
				type_pad:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", type_data))
			end
			-- 资质
			local ability_data = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ability)
			ability_text:setString(ability_data)
			
			-- 介绍
			local intro_data = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.introduce)
			intro_text:setString(intro_data)
		else
			type_pad:removeBackGroundImage()
			ability_text:setString(" ")
			intro_text:setString(" ")
		end
		
		self:responseFormationHeroDevelop()
	end
	
	
end

-- 更新当前宠物属性
function Formation:updateDrawPetInfo()
	local root = self.roots[1]
	local ship = _ED.user_ship["" .. _ED.formation_pet_id]
	if root == nil or ship == nil then 
		return
	end  
end

-- 当武将发生变更后，更新阵容界面的武将列表及武将全身像的绘图，并更新武将的装备及属性显示
function Formation:updateDrawShipChange()

end

-- 切换所选择的武将，并更新阵容的绘图
function Formation:updateDrawChanageShipPageView()
	self:drawShipPageView()
end

-- 更新小伙伴界面的所有伙伴信息的绘制
function Formation:updateDrawPartnerView()
	local root = self.roots[1]
	
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
	-- else
		-- 上阵小伙伴头像位
		local heroPartnerPlace = {
			"Panel_40",
			"Panel_40_1",
			"Panel_40_3",
			"Panel_40_0",
			"Panel_40_2",
			"Panel_40_4",
		}
		local heroPartnerNamePlace = {
			"Text_43",
			"Text_43_1",
			"Text_43_3",
			"Text_43_0",
			"Text_43_2",
			"Text_43_4",
		}
		
		for i=1, 6 do
			local heroPlace = ccui.Helper:seekWidgetByName(root, heroPartnerPlace[i])
			heroPlace:removeChild(heroPlace._nodeChild, true)
			heroPlace._nodeChild = nil
			local heroName = ccui.Helper:seekWidgetByName(root, heroPartnerNamePlace[i])
			heroName:setString(" ")
		end
		for i, v in pairs(_ED.little_companion_state) do
			if heroPartnerPlace[i] ~= nil then
				local heroPlace = ccui.Helper:seekWidgetByName(root, heroPartnerPlace[i])
				
				local heroName = ccui.Helper:seekWidgetByName(root, heroPartnerNamePlace[i])
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
		-- 上阵小伙伴羁绊位
		local partnershipPlace = {
			"Panel_46",
			"Panel_46_0",
			"Panel_46_1",
			"Panel_46_2",
			"Panel_46_3",
			"Panel_46_4",
		}
		for i=1, 6 do
			local shipPlace = ccui.Helper:seekWidgetByName(root, partnershipPlace[i])
			shipPlace:removeChild(shipPlace._nodeChild, true)
			shipPlace._nodeChild = nil
		end
		
		for i = 1, 6 do
			local shipId = _ED.user_formetion_status[i]
			if zstring.tonumber(shipId) > 0 then
				local cell = self:createShipPartnerPlace(_ED.user_ship[shipId])
				local shipPlace = ccui.Helper:seekWidgetByName(root, partnershipPlace[i])
				shipPlace._nodeChild = cell
				shipPlace:addChild(cell)
			end
		end
		
		--上阵所有伙伴的羁绊信息
		local partnerScrollView = ccui.Helper:seekWidgetByName(root, "ListView_4")
		partnerScrollView:removeAllItems()
		for i = 1, 6 do
			local shipId = _ED.user_formetion_status[i]
			local shipInfo = _ED.user_ship[shipId]
			if zstring.tonumber(shipId) > 0 and dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.relationship_id) ~= "" then
				local cell = self:createPartnerScroll(shipInfo)
				partnerScrollView:addChild(cell)
			end
		end
		partnerScrollView:requestRefreshView()
	-- end

end

-- 当小伙伴发生变更后，更新整个小伙伴界面的绘图
function Formation:updateDrawPartnerChange()

end

-- 更新阵容界面的小伙伴的缘分信息的显示
function Formation:updateDrawParnterFateInfo()

end

--响应强化大师的按钮
function Formation:responseStrengthenTheMaster()
	if self.moveLayer and 
		self.moveLayer._current_cell and 
		self.moveLayer._current_cell._ship and 
		type(self.moveLayer._current_cell._ship) == "table" and
		self.moveLayer._current_cell._ship.ship_id then
		
	
		local root = self.roots[1]
		--fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, {terminal_name = "", terminal_state = 0, _data = self.data}, nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, 
		{
			terminal_name = "formation_show_strengthen_master",
			terminal_state = 0,
			_moveLayer = self.moveLayer,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			--强化大师
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_15"), nil, 
			{
				terminal_name = "formation_show_strengthen_enter",
				terminal_state = 0,
				_moveLayer = self.moveLayer,
				isPressedActionEnabled = true
			}, 
			nil, 0)	
			--一键强化
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_14"), nil, 
			{
				terminal_name = "formation_show_strengthen_once",
				terminal_state = 0,
				_moveLayer = self.moveLayer,
				isPressedActionEnabled = true
			}, 
			nil, 0)	
		end
		
	
	end
end

--响应时装的按钮
function Formation:responseLatestFashion()
	local root = self.roots[1]
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_0"), nil, {terminal_name = "formation_hero_wear_click", terminal_state = 0, _data = self.data, isPressedActionEnabled = true}, nil, 0)
end

--响应切换武将的按钮
function Formation:responseReplacementHead()
	local root = self.roots[1]
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		for i = 2, 7 do
			if zstring.tonumber(_ED.formetion[i]) > 0 then 
				if zstring.tonumber(_ED.formetion[i]) == zstring.tonumber(self.ship.ship_id) then
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_1"), nil, {terminal_name = "replacement_battle_hero_request", terminal_state = 0, _data = i-1, isPressedActionEnabled = true}, nil, 0)
					return
				end
			end
		end
	else
		for i = 2, 7 do
			if zstring.tonumber(_ED.formetion[i]) > 0 then 
				if zstring.tonumber(_ED.formetion[i]) == zstring.tonumber(self.moveLayer._current_cell._ship.ship_id) then
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5_1"), nil, {terminal_name = "replacement_battle_hero_request", terminal_state = 0, _data = i-1, isPressedActionEnabled = true}, nil, 0)
					return
				end
			end
		end
	end	
end

--响应布阵的按钮
function Formation:responseArray()
	local root = self.roots[1]
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {terminal_name = "formation_page_formation_change", terminal_state = 0, _data = self.data, isPressedActionEnabled = true}, nil, 0)
end

--响应缘分效果按钮
function Formation:responseFateEffect()
	local root = self.roots[1]
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {terminal_name = "response_fate_effect", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
end

--响应缘分效果返回按钮
function Formation:responseFateEffectReturn()
	local root = self.roots[1]
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_0"), nil, {terminal_name = "response_fate_effect_return", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
end

--响应阵容的返回按钮
function Formation:responseFormationReturn()
	local root = self.roots[1]
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zr_back"), nil, 
	{
		terminal_name = "formation_back_to_home_page", 
		terminal_state = 0,
		isPressedActionEnabled = true}, 
	nil, 0)
end

--响应武将信息的属性按钮 和 详情按钮
function Formation:responseFormationHeroInfoChange()
	local root = self.roots[1]
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shuxin"), nil, 
	{
		terminal_name = "formation_hero_info_manager", 
        next_terminal_name = "formation_hero_info_attributes",     
        current_button_name = "Button_shuxin",
		terminal_state = 0,
		isPressedActionEnabled = true}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xiangqin"), nil, 
	{
		terminal_name = "formation_hero_info_manager", 
        next_terminal_name = "formation_hero_info_details",     
        current_button_name = "Button_xiangqin",
		terminal_state = 0,
		isPressedActionEnabled = true}, 
	nil, 0)
	
	state_machine.excute("formation_hero_info_manager", 0, 
		{
			_datas = {
				terminal_name = "formation_hero_info_manager",     
				next_terminal_name = "formation_hero_info_attributes",       
				current_button_name = "Button_shuxin",    
				terminal_state = 0, 
				isPressedActionEnabled = true
			}
		}
	)
end

--响应突破、培养、升级按钮
function Formation:responseFormationHeroDevelop()
	local root = self.roots[1]
	local Button_tupo = ccui.Helper:seekWidgetByName(root, "Button_tupo")
	local Button_peiyang = ccui.Helper:seekWidgetByName(root, "Button_peiyang")
	local Button_shengji = ccui.Helper:seekWidgetByName(root, "Button_shengji")
	Button_shengji:setBright(true)
	Button_shengji:setTouchEnabled(true)
	Button_tupo:setBright(true)
	Button_tupo:setTouchEnabled(true)
	
	Button_tupo:setVisible(true)
	Button_peiyang:setVisible(true)
	Button_shengji:setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Image_15"):setVisible(true)
	
	if self.ship ~= nil then
		if tonumber(self.ship.captain_type) ~= 0 then
			-- Button_shengji:setVisible(true)
			Button_shengji:setBright(true)
			Button_shengji:setTouchEnabled(true)
		else
			-- Button_shengji:setVisible(false)
			Button_shengji:setBright(false)
			Button_shengji:setTouchEnabled(false)
		end
		
		if tonumber(self.ship.ship_grade) >= tonumber(_ED.user_info.user_grade) then
			Button_shengji:setBright(false)
			Button_shengji:setTouchEnabled(false)
		end
		
		if tonumber(self.ship.ship_template_id) == 1148 or tonumber(self.ship.ship_template_id) == 1149 or
			 tonumber(self.ship.ship_template_id) == 1150 then
			Button_tupo:setBright(false)
			Button_tupo:setTouchEnabled(false)
		end
		
		if dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.grow_target_id) == -1 then
			Button_tupo:setBright(false)
			Button_tupo:setTouchEnabled(false)
		end
		
		
		fwin:addTouchEventListener(Button_tupo, nil, 
		{
			terminal_name = "formation_click_hero_break_page", 
			terminal_state = 0,
			_ship_id = self.ship.ship_id,
			isPressedActionEnabled = true}, 
		nil, 0)
		
		fwin:addTouchEventListener(Button_shengji, nil, 
		{
			terminal_name = "formation_click_hero_Level_up_page", 
			terminal_state = 0,
			_ship_id = self.ship.ship_id,
			isPressedActionEnabled = true}, 
		nil, 0)
		
		fwin:addTouchEventListener(Button_peiyang, nil, 
		{
			terminal_name = "formation_click_hero_develop_page", 
			terminal_state = 0,
			_ship_id = self.ship.ship_id,
			isPressedActionEnabled = true}, 
		nil, 0)
		
	else
		Button_tupo:setVisible(false)
		Button_peiyang:setVisible(false)
		Button_shengji:setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_15"):setVisible(false)
	end
end

function Formation:getshipFormationPosition()
	local root = self.roots[1]
	if self.ship~=nil then
		for i = 1, 6 do
			if zstring.tonumber(_ED.user_formetion_status[i]) > 0 then 
				if zstring.tonumber(_ED.user_formetion_status[i]) == zstring.tonumber(self.ship.ship_id) then
					self.formationPosition = i
					self:responseReplacementHead()
					return
				end
			end
		end
	end
end

--刷新小头像光标
function Formation:updateTheCursor()

end

--滑动到小伙伴页
function Formation:slideBuddy()

end


function Formation:updateAllPage()
	
end

function Formation:onUpdate(dt)
	if __lua_project_id == __lua_project_yugioh then
		return
	end

	if self.moveLayer == nil then
		return
	end
	
	local mx = self.moveLayer:getPositionX()
	local cell_width = self.moveLayer.cell_width
	local firstCell = self.heroCells[1]
	local cellCount = table.getn(self.heroCells)
	local lastCell = self.heroCells[cellCount]

	local currentCell = self.moveLayer._current_cell
	if currentCell._is_selected == true then
		if mx - cell_width + ((currentCell.startX) + cell_width / 2) < 0 then
			local swapCell = self.heroCells[1]
			table.remove(self.heroCells, "1")
			table.insert(self.heroCells, swapCell)
			swapCell.startX = lastCell.startX + cell_width
			swapCell:setPositionX(swapCell.startX)	
			
			self.moveLayer._current_cell._is_selected = false
			-- self.moveLayer._current_cell:setPositionY(self.moveLayer._current_cell._basePosition.y)
			self.moveLayer._current_cell:setScalePanel(1)
			self.moveLayer._current_cell = self.heroCells[self.bfCount]
			self.moveLayer._current_cell._is_selected = true
			-- self.moveLayer._current_cell:setPositionY(self.moveLayer._current_cell._basePosition.y - 50)
			self.moveLayer._current_cell:setScalePanel(1.2)
			
			self.moveLayer.startX = self.moveLayer.startX - cell_width
		elseif mx - cell_width + ((currentCell.startX) + cell_width / 2) > cell_width then
			local swapCell = self.heroCells[cellCount]
			table.remove(self.heroCells, ""..cellCount)
			table.insert(self.heroCells, 1, swapCell)
			swapCell.startX = firstCell.startX - cell_width
			swapCell:setPositionX(swapCell.startX)	
			
			self.moveLayer._current_cell._is_selected = false
			-- self.moveLayer._current_cell:setPositionY(self.moveLayer._current_cell._basePosition.y)
			self.moveLayer._current_cell:setScalePanel(1)
			self.moveLayer._current_cell = self.heroCells[self.bfCount]
			self.moveLayer._current_cell._is_selected = true
			-- self.moveLayer._current_cell:setPositionY(self.moveLayer._current_cell._basePosition.y - 50)
			self.moveLayer._current_cell:setScalePanel(1.2)
			
			self.moveLayer.startX = self.moveLayer.startX + cell_width
		end
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
	else
		if self._selected == true then
			self.moveLayer._current_cell:setScalePanel(1.2)
		else
			--self.moveLayer._current_cell:setScalePanel(1)
		end
	end

	if self.runState == 1 then
		state_machine.unlock("menu_manager_change_to_page", 0, "")
		self.runState = self.runState + 1
	end
	if self.runState == 0 then
		self.runState = self.runState + 1
	end
end



-- 更新绘制小伙伴和角色形象的page显示
function Formation:updateHeroPageView(value)
	local root = self.roots[1]
	local xiaohuobanPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	xiaohuobanPanel._basePosition = {xiaohuobanPanel:getPosition()}
	local heroPanel = ccui.Helper:seekWidgetByName(root, "Panel_4")
	heroPanel._basePosition = {xiaohuobanPanel:getPosition()}
	local heroPanel96 = ccui.Helper:seekWidgetByName(root, "Panel_96")
	local zcPanel = ccui.Helper:seekWidgetByName(root, "Panel_zhanchong")
	local zcEquipPanel = ccui.Helper:seekWidgetByName(root, "Panel_zc")

	local Panel_1 = heroPanel:getChildByName("Panel_1")
	if zcPanel ~= nil then 
		zcPanel:setVisible(false)
	end
	if Panel_1 ~= nil then 
		Panel_1:setVisible(true)
	end
	if zcEquipPanel ~= nil then 
		zcEquipPanel:setVisible(false)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		heroPanel96._basePosition = {xiaohuobanPanel:getPosition()}
	end

	local _ship = nil
	if nil == value then
		value = self.gaoliangIndex
	end
	if type(value) == "table" then
		_ship = value
	elseif type(value) == "number" then
		_ship = _ED.user_ship[_ED.user_formetion_status[index]]
	else
		_ship = value._ship
	end
	if _ship == -3 then
		self:init(nil)
		self:getshipFormationPosition()
		
		xiaohuobanPanel:setVisible(true)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
			xiaohuobanPanel:setPosition( xiaohuobanPanel._basePosition)
		end
		heroPanel:setVisible(false)
		heroPanel96:setVisible(false)
		
		heroPanel:setPosition(cc.p(-1000, 0))
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
		heroPanel96:setPosition(cc.p(-1000, 0))
		end		
		ccui.Helper:seekWidgetByName(root, "Panel_107"):setVisible(false)
	elseif _ship == -1 or _ship == -2 then
		self:init(nil)
		if zcEquipPanel ~= nil then 
			--显示战宠驯养
			self:onUpdateDrawPetEquip(_ship)
		end
		self:updateDrawChanageShipPageView()
		self:getshipFormationPosition()
		
		xiaohuobanPanel:setVisible(false)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
			xiaohuobanPanel:setPosition(cc.p(-1000, 0))
		end
		heroPanel:setVisible(true)
		heroPanel96:setVisible(true)
		heroPanel:setPosition(heroPanel._basePosition)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
			heroPanel96:setPosition(heroPanel96._basePosition)
		end
		ccui.Helper:seekWidgetByName(root, "Panel_107"):setVisible(true)
	elseif _ship == -4 or _ship == -6 then 
		--战宠
		heroPanel96:setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_107"):setVisible(false)
		local starPanel = ccui.Helper:seekWidgetByName(root, "Panel_xing")
		heroPanel:setVisible(true)
		heroPanel:setPosition(heroPanel._basePosition)
		zcPanel:setVisible(true)
		xiaohuobanPanel:setVisible(false)
		Panel_1:setVisible(false)
		local Panel_you = ccui.Helper:seekWidgetByName(root, "Panel_you")
		Panel_you:setVisible(false)
		starPanel:setVisible(false)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
			xiaohuobanPanel:setPosition(cc.p(-1000, 0))
		end
		if _ED.formation_pet_id ~= nil and _ED.formation_pet_id ~= 0 then 
			local ship = _ED.user_ship["".._ED.formation_pet_id] 
			if ship ~= nil then 
				self:init(ship)
				Panel_you:setVisible(true)
				starPanel:setVisible(true)
			end
		else
			self:init(nil)
		end
		self:updateDrawChanageShipPageView()
		ccui.Helper:seekWidgetByName(root, "Button_tihuan"):setVisible(true)
	else
		if zcEquipPanel ~= nil then 
			--显示战宠驯养
			self:onUpdateDrawPetEquip(_ship)
		end
		self:init(_ship)
		self:updateDrawChanageShipPageView()
		self:getshipFormationPosition()
		xiaohuobanPanel:setVisible(false)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
			xiaohuobanPanel:setPosition(cc.p(-1000, 0))
		end
		heroPanel:setVisible(true)
		heroPanel96:setVisible(true)
		heroPanel:setPosition(heroPanel._basePosition)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else
			heroPanel96:setPosition(heroPanel96._basePosition)
		end
		ccui.Helper:seekWidgetByName(root, "Panel_107"):setVisible(true)
	end

end
function Formation:showHeroPartners(_show)
	local root = self.roots[1]
	local xiaohuobanPanelMain = ccui.Helper:seekWidgetByName(root, "Panel_122")
	local xiaohuobanPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	xiaohuobanPanelMain:setVisible(_show)
	xiaohuobanPanel:setVisible(_show)
	state_machine.excute("response_fate_effect_return",0,"")
end
function Formation:onEnterTransitionFinish()
	local root = self.roots[1]
	local csbFormation = root:getParent()
	self.actions = {}
	local action = csb.createTimeline("formation/line_up.csb")
	table.insert(self.actions, action)
	csbFormation:runAction(action)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:responseLatestFashion()
		
		local Button_yuanjun = ccui.Helper:seekWidgetByName(root,"Button_yuanjun")
		fwin:addTouchEventListener(Button_yuanjun, nil, 
		{
			terminal_name = "formation_hero_partners_show_or_hidden", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_show = true
		},
		nil,0)
		
		local close_yuanjun = ccui.Helper:seekWidgetByName(root,"Button_xhb_back")
		fwin:addTouchEventListener(close_yuanjun, nil, 
		{
			terminal_name = "formation_hero_partners_show_or_hidden", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_show = false
		},
		nil,0)


		local Button_line_qianghua = ccui.Helper:seekWidgetByName(root,"Button_line_qianghua")
		fwin:addTouchEventListener(Button_line_qianghua, nil, 
		{
			terminal_name = "formation_go_to_hero_herodevelop", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_self = self,
			_show = true
		},
		nil,0)

		local Button_change_skills = ccui.Helper:seekWidgetByName(root, "Button_change_skills")
		app.load("client.learingskills.learingskillsEquipDevelop")
		fwin:addTouchEventListener(Button_change_skills, nil, 
		{
			terminal_name = "learing_skills_equip_develop_open", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
		},
		nil,0)
	end
	
	local menuPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_35")
	if menuPanel ~= nil then 
		menuPanel:setVisible(false)
	end

	state_machine.excute("formation_play_into_action", 0, "")
	if self.fresh == true then
		self.fresh = false
	end
	
	local changePet = ccui.Helper:seekWidgetByName(root,"Button_tihuan")
	if changePet ~= nil then 
		changePet:setVisible(true)
		fwin:addTouchEventListener(changePet, nil, 
		{
			terminal_name = "formation_hero_change_pet", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_show = true
		},
		nil,0)
	end
	--战宠驯养
	local zcEquipPanel = ccui.Helper:seekWidgetByName(root,"Panel_pet_icon")
	
	if zcEquipPanel ~= nil then
		zcEquipPanel:setTouchEnabled(true)
		fwin:addTouchEventListener(zcEquipPanel, nil, 
		{
			terminal_name = "formation_pet_equip", 
			terminal_state = 0,
			isPressedActionEnabled = true,
			_show = true
		},
		nil,0)
	end
	--跑马灯
	if  __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon
		then
        if ___is_open_push_info ~= false then
            app.load("client.home.WarshipGirlPushInfo")
            state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=0}})
        end
    end
end

function Formation.onImageLoaded(texture)
	
end

function Formation:onArmatureDataLoad(percent)
	
end

--更新战宠驯养显示
function Formation:onUpdateDrawPetEquip(ship)
	local root = self.roots[1]
	local zcEquipPanel = ccui.Helper:seekWidgetByName(root, "Panel_zc")
	zcEquipPanel:setVisible(true)
	local petPanel = ccui.Helper:seekWidgetByName(root, "Panel_pet_icon")
	petPanel:removeAllChildren(true)
	local fun_id = 60
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        fun_id = 64
    end
	local isOpen_petEquip = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level)
	if isOpen_petEquip then 
		--开启功能
		if type(ship) == "table" and  zstring.tonumber(ship.pet_equip_id) > 0 then 
			--驯的宠物
			local cell = PetIconCell:createCell()
			cell:init(_ED.user_ship[""..ship.pet_equip_id],4)
			petPanel:addChild(cell)
		end
	else
		--未开启
		zcEquipPanel:setVisible(false)
	end	
end

function Formation:onArmatureDataLoadEx(percent)
	if percent >= 1 then
		if self._load_over == false then
			self._load_over = true

			local csbFormation = csb.createNode("formation/line_up.csb")
			self:addChild(csbFormation)

			local root = csbFormation:getChildByName("root")
			table.insert(self.roots, root)
			
			-- self.actions = {}
			-- local action = csb.createTimeline("formation/line_up.csb")
			-- table.insert(self.actions, action)
			-- csbFormation:runAction(action)

			self:onInit()
		end
	end
end

function Formation:onClose()
	state_machine.unlock("formation_back_to_home_page", 0, "")
	fwin:close(self)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- cacher.removeAllTextures()
		-- -- fwin:reset(nil)
		-- fwin:freeAllMemeryPool()
	end
	state_machine.excute("menu_clean_page_state", 0, "") 
	state_machine.excute("menu_back_home_page", 0, "") 
	state_machine.excute("home_hero_refresh_draw", 0, "")
end

function Formation:playCloseAction()
	local action = self.actions[1]
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if fwin:find("UserInformationHeroStorageClass") ~= nil then
			fwin:close(fwin:find("UserInformationHeroStorageClass"))
		end
	end
	action:play("window_close", false)
end

function Formation:playIntoAction()
	local action = self.actions[1]
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		action:play("window_open", false)
		action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "window_open_over" then
	        	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					app.load("client.player.UserInformationHeroStorage")
					if fwin:find("UserInformationHeroStorageClass") == nil then
						fwin:open(UserInformationHeroStorage:new(),fwin._ui)
					end
					state_machine.excute("Lformation_ship_cell_play_hero_animation",0,"begin")
				end
	        elseif str == "window_close_over" then
	            self:onClose()
	        end
	    end)
	else
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			--action:gotoFrameAndPlay(0, "kongjian_tonch", false)
			action:play("kongjian_tonch", false)
		else
			action:gotoFrameAndPlay(0, action:getDuration(), false)
		end
		

	end
end

function Formation:onLoad()


	-- local effect_paths = {
	-- 	"images/ui/effice/effect_9/effect_9.ExportJson",
	-- 	"images/ui/effice/effect_10/effect_10.ExportJson",
	-- 	"images/ui/effice/effect_13/effect_13.ExportJson",
	-- 	"images/ui/effice/effect_14/effect_14.ExportJson",
	-- }
	-- for i, v in pairs(effect_paths) do
	-- 	local fileName = v
	-- 	ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
	-- end


	local csbFormation = csb.createNode("formation/line_up.csb")
	self:addChild(csbFormation)

	local root = csbFormation:getChildByName("root")
	table.insert(self.roots, root)
	
	-- self.actions = {}
	-- local action = csb.createTimeline("formation/line_up.csb")
	-- table.insert(self.actions, action)
	-- csbFormation:runAction(action)

	self:onInit()
	
	-- local csbFormation = csb.createNode("formation/line_up.csb")
	-- self:addChild(csbFormation)

	-- local root = csbFormation:getChildByName("root")
	-- table.insert(self.roots, root)

	-- local action = csb.createTimeline("formation/line_up.csb")
	-- table.insert(self.actions, action)
	-- csbFormation:runAction(action)
end

function Formation:onInit()		

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
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		app.load("client.cells.formation.Lformation_change_hero_cell")
	end
	-- local csbFormation = csb.createNode("formation/line_up.csb")
	-- self:addChild(csbFormation)
	
	-- local root = csbFormation:getChildByName("root")
	-- table.insert(self.roots, root)
	
	-- local action = csb.createTimeline("formation/line_up.csb")
	-- csbFormation:runAction(action)
	-- action:gotoFrameAndPlay(0, action:getDuration(), false)

	-- state_machine.excute("formation_play_into_action", 0, "")
	
	self:createLight()
	
	self:drawShipHeadListView()
	self:drawShipPageView()
	self:updateDrawEquipments()
	self:updateDrawShipInfo()
	self:updateDrawPartnerView()
	self:updateDrawParnterFateInfo()
	
	self:responseLatestFashion()
	self:responseArray()
	self:responseFateEffect()
	self:responseFateEffectReturn()
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		self:responseFormationReturn()
		self:responseFormationHeroInfoChange()
	end
	
	self:getshipFormationPosition()
	self:selectedPad()
	self:slideBuddy()
end

function Formation:onExit()
	-- state_machine.remove("formation_page_formation_change")
	-- state_machine.remove("formation_change_to_ship_page_view")
	-- state_machine.remove("open_formation_head_info")
	-- state_machine.remove("jump_formation_partner_info")
	-- state_machine.remove("open_add_ship_window")
	-- state_machine.remove("open_add_ship_equip_window")
	-- state_machine.remove("open_add_partner_ship_window")
	-- state_machine.remove("open_ship_current_equip_window")
	-- state_machine.remove("response_fate_effect")
	-- state_machine.remove("response_fate_effect_return")
	-- state_machine.remove("current_ship_equip_wear_request")
	-- state_machine.remove("choice_hero_battle_request")
	-- state_machine.remove("replacement_battle_hero_request")
	-- state_machine.remove("replacement_or_unload_ship_equip_wear_request")
	-- state_machine.remove("open_replacement_ship_equip_window")
	-- state_machine.remove("choice_hero_partners_request")
	-- state_machine.remove("run_action_cell")
	-- state_machine.remove("formation_show_strengthen_master")
	-- state_machine.remove("formation_property_change_tip_info")
	-- state_machine.remove("formation_property_change_by_level_up")
	-- state_machine.remove("formation_property_change_before")
	-- state_machine.remove("formation_property_change_equip_info")
	-- state_machine.remove("formation_play_into_action")
	--state_machine.remove("formation_hero_wear_click")
	--state_machine.remove("formation_hero_partners_show_or_hidden")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		if self.bust_index_args ~= nil then 
			for i, v in pairs(self.bust_index_args) do
				ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_" .. v .. ".ExportJson")
			end
		end	
	end
	if  __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto  
		or __lua_project_id == __lua_project_pokemon
		then  
        if ___is_open_push_info ~= false then
            state_machine.excute("warship_girl_push_info_close",0,"")
        end
    end
end



function Formation:drawScrollView()
	if self.moveLayer and self.moveLayer._current_cell then
		self:updateCurrentView()
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		
		else
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3"):setVisible(false)
		end
		self:drawHeadQueue()
	end
end

--宠物下阵更新头像
function Formation:onUpdatedrawPetDown()
	local tCell = self.moveLayer._current_cell
	local tIndex = tCell._index
	local tempCells = {}
	
	local table_heros = self.heroCells 
	
	local _newCell = nil
	for n, t in pairs(table_heros) do
		local cell = t
		if cell._index == tIndex then
			local cellParent = cell:getParent()
				
			local newCell = self:createPetCell(0,2)
			newCell.ship = nil
			newCell._indexadd = cell._indexadd
			newCell.startX = cell.startX
			newCell._index = cell._index
			newCell._ship = -6
			newCell._basePosition = cell._basePosition
			newCell:setPosition(cc.p(cell:getPosition()))

			cellParent:addChild(newCell)
			if tCell == cell then
				newCell:setScalePanel(1.2)
				newCell._is_selected = true
				self.moveLayer._current_cell = newCell
				self.moveLayer._params = {_index = newCell._indexadd, _type = 1, _shipId = -1,pet = true}
				self:updateHeroPageView(newCell)
				tCell = nil
			end
			cellParent:removeChild(cell)
			_newCell = newCell
			table.insert(tempCells, newCell)
		else
			table.insert(tempCells, cell)
		end
	end
	self.heroCells = tempCells
	self:changeScelecedHeroCell()
end

--布阵时换宠更新头像
function Formation:onUpdateDrawPetChange()
	local tCell = self.moveLayer._current_cell
	local tIndex = tCell._index
	local tempCells = {}
	
	local table_heros = self.heroCells 

	if _ED.formation_pet_id == 0 then 
		return
	end
	local _newCell = nil
	for n, t in pairs(table_heros) do
		local cell = t
		if cell._ship == -4 
			or cell._ship == -5
			or cell._ship == -6
		then
			local cellParent = cell:getParent()
			local shipId = "".._ED.formation_pet_id
			local newCell = self:createPetCell(_ED.user_ship[shipId], 1)
				
			newCell._ship = -4
			newCell.ship = _ED.user_ship[shipId]
			newCell._indexadd = cell._indexadd
			newCell.startX = cell.startX
			newCell._index = cell._index
			newCell._basePosition = cell._basePosition
			newCell:setPosition(cc.p(cell:getPosition()))
			cellParent:addChild(newCell)
			cellParent:removeChild(cell)
			
			_newCell = newCell
			table.insert(tempCells, newCell)
		else
			table.insert(tempCells, cell)
		end
	end
	self.heroCells = tempCells
end

function Formation:updateCurrentView()
	-- local cell = self.moveLayer._current_cell
	-- if cell._ship == -1 then
		-- local shipId = _ED.user_formetion_status[cell._indexadd]
		-- if zstring.tonumber(shipId) > 0 then
			-- local newCell = self:createShipHead(_ED.user_ship[shipId], 1)
			-- newCell._ship = _ED.user_ship[shipId]
			-- newCell.ship = _ED.user_ship[shipId]
			-- newCell._indexadd = cell._indexadd
			
			-- newCell.startX = cell.startX
			-- newCell._basePosition = cell._basePosition
			
			-- newCell:setPosition(cc.p(cell:getPosition()))
			
			-- local cellParent = cell:getParent()
			-- for i, v in pairs(self.heroCells) do
				-- if v == cell then
					-- self.heroCells[i] = newCell
					--> print("----------------")
					-- return
				-- end
			-- end
			-- cellParent:removeChild(self.moveLayer._current_cell)
			-- cellParent:addChild(newCell)
			-- self.moveLayer._current_cell = newCell
			-- self.moveLayer._current_cell:setScalePanel(1.2)
		-- end
	-- end
	-- self:updateHeroPageView(self.moveLayer._current_cell)
	-- self:updateDrawShipInfo()
	-- self:updateDrawEquipments()
	-- self:onUpdate(0)
	

	-- -- b
	-- local cell = self.moveLayer._current_cell
	-- local cellParent = cell:getParent()
	
	-- local shipId = self.ship.ship_id
	-- local newCell = self:createShipHead(_ED.user_ship[shipId], 1)
	-- newCell._ship = _ED.user_ship[shipId]
	-- newCell.ship = _ED.user_ship[shipId]
	-- newCell._indexadd = cell._indexadd
	-- newCell.startX = cell.startX
	-- newCell._basePosition = cell._basePosition
	-- newCell:setPosition(cc.p(cell:getPosition()))

	
	-- for i, v in pairs(self.heroCells) do
	-- 	if v == cell then
	-- 		self.heroCells[i] = newCell
	-- 	end
	-- end
	
	-- cellParent:addChild(newCell)
	-- newCell:setScalePanel(1.2)
	-- self.moveLayer._current_cell = newCell
	-- cellParent:removeChild(cell)
	local tCell = self.moveLayer._current_cell
	local tIndex = tCell._index
	local tempCells = {}
	
	local table_heros = self.heroCells 
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		tIndex = self._beforeCell._index
		table_heros = self._dataCell
	end	
	
	local _newCell = nil
	for n, t in pairs(table_heros) do
		local cell = t
		if cell._index == tIndex then
			local cellParent = cell:getParent()
			local shipId = self.ship.ship_id
			local captain_type = dms.int(dms["ship_mould"],_ED.user_ship[shipId].ship_template_id,ship_mould.captain_type)
			
			local newCell = nil
			if captain_type == 3 then 
				--宠物
				newCell = self:createPetCell(_ED.user_ship[""..shipId],1)
				newCell._ship = -4
			else
				newCell = self:createShipHead(_ED.user_ship[shipId], 1)
				newCell._ship = _ED.user_ship[shipId]
			end
			newCell.ship = _ED.user_ship[shipId]
			newCell._indexadd = cell._indexadd
			newCell.startX = cell.startX
			newCell._index = cell._index
			newCell._basePosition = cell._basePosition
			newCell:setPosition(cc.p(cell:getPosition()))

			if __lua_project_id == __lua_project_yugioh then
				newCell:setAnchorPoint(cell:getAnchorPoint())
			end
			
			
			-- for i, v in pairs(self.heroCells) do
			-- 	if v == cell then
			-- 		--self.heroCells["".. i] = newCell
			-- 		table.remove(self.heroCells, i)
			-- 		table.insert(self.heroCells, i, newCell)
			-- 		break
			-- 	end
			-- end
			
			
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
				self.headListView:removeItem(tIndex - 1)
				self.headListView:insertCustomItem(newCell, tIndex - 1)
			else
				cellParent:addChild(newCell)
				if tCell == cell then
					newCell:setScalePanel(1.2)
					newCell._is_selected = true
					self.moveLayer._current_cell = newCell
					tCell = nil
				end
				cellParent:removeChild(cell)
			end
			_newCell = newCell
			table.insert(tempCells, newCell)
		else
			table.insert(tempCells, cell)
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self._dataCell = tempCells
		self:changeScelecedHeroCell2(_newCell)
		
		local function fourOpenTouchEvent(sender, eventType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
		
			if eventType == ccui.TouchEventType.began then
			elseif eventType == ccui.TouchEventType.ended or 
			  eventType == ccui.TouchEventType.canceled and
			  math.abs(__epoint.y - __spoint.y) < 8 then
				local last_index = 1 
				
				local HomeHeroWnd = fwin:find("HomeHeroClass")
				if HomeHeroWnd ~= nil then
					last_index = HomeHeroWnd.current_formetion_index
				end
				-- for i, v in pairs(self._dataCell) do
					-- if v.choose:isVisible() == true then
						-- last_index = v._index
					-- end
				-- end
				
				for i, v in pairs(self._dataCell) do
					if sender == v.panelFour then
						v.choose:setVisible(true)
					else
						v.choose:setVisible(false)
					end
				end
				self:changeScelecedHeroCell2(_newCell)
				
				local now_index = _newCell._indexadd
				
				local direction = now_index - last_index > 0 and "L" or "R"
				local size = math.abs(now_index - last_index)
				if last_index == 6 and now_index == 1 then
					direction = "L"
					size = 1
				elseif last_index == 1 and now_index == 6 then
					direction = "R"
					size = 1
				end	
				
				if size > 0 then
					state_machine.excute("home_hero_action_switch_in_formation", 0, 
					{
						_direction = direction, 
						_start_index = last_index,
						_size = size
					})
				end	
			end
		end
		_newCell.panelFour:addTouchEventListener(fourOpenTouchEvent)		--武将头像
		_newCell.choose:setVisible(true)	
	else
		
		self.heroCells = tempCells
		self:changeScelecedHeroCell()
	end
	-- local cccIndex = 0
	-- for i, v in pairs(self.heroCells) do
	-- 	cccIndex = cccIndex + 1
	--> print("cccIndex:", cccIndex)
	-- end

	-- self:updateHeroPageView(self.moveLayer._current_cell)
	-- self:updateDrawShipInfo()
	-- self:updateDrawEquipments()
	-- self:onUpdate(0)
end


function Formation:changeScelecedHeroCell()
	self._selected = true
	self:onUpdate(0)
	if self.moveLayer._last_cell ~= self.moveLayer._current_cell then
		self:updateHeroPageView(self.moveLayer._current_cell)
		self:updateDrawShipInfo()
		self:updateDrawEquipments()

		if __lua_project_id == __lua_project_yugioh then
			if self.moveLayer._last_cell ~= nil and self.moveLayer._last_cell.setScalePanel ~= nil then
				self.moveLayer._last_cell:setScalePanel(1)
				self.moveLayer._last_cell._is_selected = false
			end

			self.moveLayer._current_cell:setScalePanel(1.2)
			self.moveLayer._current_cell._is_selected = true
		end
		self.moveLayer._last_cell = self.moveLayer._current_cell
	end
end

function Formation:createLight()
	local root =self.roots[1]
	self.targetPad = ccui.Helper:seekWidgetByName(self.roots[1], "Image_60")
	local imageX,imageY = self.targetPad:getPosition()
	self.targetPad._basePosition = cc.p(imageX, imageY)
end

function Formation:hideLight()
	self.targetPad:setPositionX(-9000)
	self:responseStrengthenTheMaster()
end

function Formation:showLight()
	self.targetPad:setPositionX(self.targetPad._basePosition.x)
end

function Formation.changeScelecedHeroCellMoveDistanceXEndFunN(sender)
	sender._formationWindows:hideLight()
end

function Formation.changeScelecedHeroCellMoveEndFunN(sender)
	if sender._basePosition ~= nil then
		sender._basePosition.x = sender:getPositionX()
	end
	sender._formationWindows:changeScelecedHeroCell()
end

function Formation.changeScelecedHeroCellMoveEndFunN2(sender)
	Formation.changeScelecedHeroCellMoveEndFunN(sender)
	state_machine.excute("open_add_ship_window", 0, sender._params)
end

function Formation:moveDistanceX()
	
	local cell = self.moveLayer._current_cell --= self.heroCells[2]
	
	local nowworldX = fwin:convertToWorldSpace(self.moveLayer, cc.p(cell:getPositionX(), cell:getPositionY())).x -- self.moveLayer:convertToWorldSpace(cc.p(cell:getPositionX(), cell:getPositionY())).x
	
	local moveDistanceX = nowworldX - self.moveLayer.startWorldX

	local seq = cc.Sequence:create(
				cc.CallFunc:create(self.changeScelecedHeroCellMoveDistanceXEndFunN),
				cc.MoveTo:create(0.25, cc.p(self.moveLayer:getPositionX() - moveDistanceX, self.moveLayer:getPositionY()))
			)
			self.moveLayer:stopAllActions()
			self.moveLayer:runAction(seq)
end

function Formation:otherInterfaceReset(toindex)
	if __lua_project_id == __lua_project_yugioh then
		if toindex ~= 0 then
			local mIdx = 0
			for i, v in pairs(self.headLayer.cells) do
				if v._ship == self.ship then
					mIdx = i
					break
				end
			end
			local currentCell = self.heroCells[mIdx]
			mIdx = mIdx - toindex
			if mIdx > 0 then
				if currentCell ~= nil then
					currentCell._is_selected = true
					currentCell:setScalePanel(1.0)
				end
				if self.heroCells[mIdx] ~= nil then
					currentCell = self.heroCells[mIdx]
					self.moveLayer._current_cell = currentCell
					self.moveLayer._current_cell._is_selected = true
					self.moveLayer._current_cell:setScalePanel(1.2)
					local Panel_xuanze = self.moveLayer:getChildByName("Panel_xuanze")
					Panel_xuanze:setRotation((mIdx - 1) * 17.14)
					self:changeScelecedHeroCell()
				end
			end
		end
	else
		local ph = toindex
		if ph ~= 0 then
			local mx = ph * self.moveLayer.cell_width
			local seq = cc.Sequence:create(
			cc.MoveTo:create(0.25 * math.abs(ph) / 3, cc.p(self.moveLayer:getPositionX() + mx , self.moveLayer:getPositionY())),
				cc.CallFunc:create(self.changeScelecedHeroCellMoveEndFunN)
			)
			self.moveLayer:stopAllActions()
			self.moveLayer:runAction(seq)
			self._moved = false
			return
		end
	end
end

function Formation:changeScelecedHeroCell2(cell)
	self._selected = true
	
	self:onUpdate(0)
	-- if self._beforeCell ~= cell then
		self:updateHeroPageView(cell)
		self:updateDrawShipInfo()
		self:updateDrawEquipments()
	-- end
	
	self._beforeCell = cell
end

function Formation:getFormationPos(_tempShipId, _open_index)
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

function Formation:updateDataCellIndex()
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

--阵容中下阵宠物
function Formation:drawHeadQueue(_ship_instance)
	---------------------------------------------------------------------------
	-- 龙虎门
	---------------------------------------------------------------------------
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self.headListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_2")
		self.headListView:removeAllItems()
		local queue = {
			shiptype = {},
			shipid = {},
		}
		local nCount = 0
		local tCount = 6
		local openCount = zstring.tonumber(_ED.user_info.user_fight)
		for i = 1, 6 do
			local shipType = 0
			local shipId = _ED.user_formetion_status[i]
			if zstring.tonumber(shipId) > 0 then 
				shipType = 1
				table.insert(queue.shipid, shipId)
				table.insert(queue.shiptype, shipType)
				nCount = nCount + 1
			else
				break
			end
		end
		
		
		for i = nCount + 1, openCount do
			table.insert(queue.shipid, shipId)
			table.insert(queue.shiptype, 0)
			nCount = nCount + 1
		end
		
		for i = nCount + 1, tCount do
			table.insert(queue.shipid, shipId)
			table.insert(queue.shiptype, -1)
			nCount = nCount + 1
		end
		
		table.insert(queue.shipid, shipId)
		-- table.insert(queue.shiptype, -2)
		
		self.queue = queue

		local shiptype = queue.shiptype
		local shipid = queue.shipid
		
		
		
		local cwidth = 0
		self._dataCell = {}
		local total_width = 0
		local sCount = #queue.shiptype
		self.bfCount = sCount
		local shipCount = 0
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
				shipCount = shipCount + 1
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
			-- elseif shipType == -2 then									--小伙伴
				-- cell = self:createAddandLockCell(1)
				-- cell._indexadd = i-1
				-- cell._ship = -3
				-- cell._index = i
			end
			if cell then 
				table.insert(self._dataCell, cell)
				self.headListView:pushBackCustomItem(cell)
				cell:setTouchEnabled(false)
				
				-- local button_01 = ccui.Helper:seekWidgetByName(root, "Panel_2")
				if cell.panelOne ~= nil then
					-- local function oneOpenTouchEvent(sender, eventType)
						-- local __spoint = sender:getTouchBeganPosition()
						-- local __mpoint = sender:getTouchMovePosition()
						-- local __epoint = sender:getTouchEndPosition()
					
						-- if eventType == ccui.TouchEventType.began then
						-- elseif eventType == ccui.TouchEventType.ended or 
						  -- eventType == ccui.TouchEventType.canceled and
						  -- math.abs(__epoint.y - __spoint.y) < 8 then
							-- self._lastStatus = 1
							-- for i, v in pairs(self._dataCell) do
								-- if sender == v.panelOne then
									-- v.choose:setVisible(true)
								-- else
									-- v.choose:setVisible(false)
								-- end
							-- end
							-- self:changeScelecedHeroCell2(cell)
						-- end
					-- end
					local function twoOpenTouchEvent(sender, eventType)
						local __spoint = sender:getTouchBeganPosition()
						local __mpoint = sender:getTouchMovePosition()
						local __epoint = sender:getTouchEndPosition()
					
						if eventType == ccui.TouchEventType.began then
						elseif eventType == ccui.TouchEventType.ended or 
						  eventType == ccui.TouchEventType.canceled and
						  math.abs(__epoint.y - __spoint.y) < 8 then
							local last_index = 1 
							sender._one_called = true
							local HomeHeroWnd = fwin:find("HomeHeroClass")
							if HomeHeroWnd ~= nil then
								last_index = HomeHeroWnd.current_formetion_index
							end
							
							-- for i, v in pairs(self._dataCell) do
								-- if v.choose:isVisible() == true then
									-- last_index = v._index
								-- end
							-- end
						  
							self._lastStatus = 2
							-- for i, v in pairs(self._dataCell) do
								-- if sender == v.panelTwo then
									-- v.choose:setVisible(true)
								-- else
									-- v.choose:setVisible(false)
								-- end
							-- end
							-- self:changeScelecedHeroCell2(cell)
							
							local now_index = cell._indexadd
							
							local direction = now_index - last_index > 0 and "L" or "R"
							local size = math.abs(now_index - last_index)
							if last_index == 6 and now_index == 1 then
								direction = "L"
								size = 1
							elseif last_index == 1 and now_index == 6 then
								direction = "R"
								size = 1
							end	
							
							if size > 0 then
								state_machine.excute("home_hero_action_switch_in_formation", 0, 
								{
									_direction = direction, 
									_start_index = last_index,
									_size = size
								})
							end	
							sender._one_called = true
						end
					end
					cell.panelTwo.callback = twoOpenTouchEvent
					-- cell.panelOne:addTouchEventListener(oneOpenTouchEvent)		--援军
					cell.panelTwo:addTouchEventListener(twoOpenTouchEvent)		--可上阵
				end
				
				if cell.panelFour ~= nil then
					local function fourOpenTouchEvent(sender, eventType)
						local __spoint = sender:getTouchBeganPosition()
						local __mpoint = sender:getTouchMovePosition()
						local __epoint = sender:getTouchEndPosition()
					
						if eventType == ccui.TouchEventType.began then
						elseif eventType == ccui.TouchEventType.ended or 
						  eventType == ccui.TouchEventType.canceled and
						  math.abs(__epoint.y - __spoint.y) < 8 then
							local last_index = 1 
							sender._one_called = true
							local HomeHeroWnd = fwin:find("HomeHeroClass")
							
							if HomeHeroWnd ~= nil then
								last_index = HomeHeroWnd.current_formetion_index
							end
							
							-- for i, v in pairs(self._dataCell) do
								-- if v.choose:isVisible() == true then
									-- last_index = v._index
								-- end
							-- end
						  
							-- for i, v in pairs(self._dataCell) do
								-- if sender == v.panelFour then
									-- v.choose:setVisible(true)
								-- else
									-- v.choose:setVisible(false)
								-- end
							-- end
							-- self:changeScelecedHeroCell2(cell)
							
							local now_index = cell._indexadd
							
							local direction = now_index - last_index > 0 and "L" or "R"
							local size = math.abs(now_index - last_index)
							if last_index == 6 and now_index == 1 then
								direction = "L"
								size = 1
							elseif last_index == 1 and now_index == 6 then
								direction = "R"
								size = 1
							end	
							if size > 0 then
								state_machine.excute("home_hero_action_switch_in_formation", 0, 
								{
									_direction = direction, 
									_start_index = last_index,
									_size = size
								})
							end	
							self.moveLayer._current_cell = sender.cell
							sender._one_called = true
						end	
					end
					cell.panelFour.callback = fourOpenTouchEvent
					cell.panelFour.cell = cell
					cell.panelFour:addTouchEventListener(fourOpenTouchEvent)		--武将头像
				end
			end
		end

		for i, v in pairs(self._dataCell) do
			if v and v._ship == self.ship then
				v.choose:setVisible(true)
			end
		end
		
		-- self._dataCell[1].choose:setVisible(true)
	end
	---------------------------------------------------------------------------
	
	self.headLayer = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_95")
	self.moveLayer = ccui.Helper:seekWidgetByName(self.headLayer, "Panel_98")
	local lx, ly = self.moveLayer:getPosition()
	self.moveLayer._basePosition = {x = lx, y = ly}
	self.Panel_o_room = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_o_room") 
	self.headLayer:setTouchEnabled(true)
	self.headLayer:setSwallowTouches(false)
	self.moveLayer._formationWindows = self
	self.headLayer._formationWindows = self

	local Panel_xuanze = self.moveLayer:getChildByName("Panel_xuanze")
	if __lua_project_id == __lua_project_yugioh then
		Panel_xuanze._formationWindows = self
	end

	if self.heroCells ~= nil then
		for i, v in pairs(self.heroCells) do
			if v ~= nil then
				v:removeFromParent(true)
			end
		end
		self.heroCells = {}
	end
	
	local now_current_cell = nil
	self._moved = false
	self._sup = 0
	self._mbf = false
	local function headLayerTouchEvent_YuGiOh(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if ccui.TouchEventType.began == evenType then

		elseif evenType == ccui.TouchEventType.moved then
			if math.abs(__mpoint.x - __spoint.x) > 20 then
				self._moved = true
			end
		elseif ccui.TouchEventType.ended == evenType or
			ccui.TouchEventType.canceled == evenType then
			if self._moved then
				self._moved = false
				local flag = 1
				if __mpoint.x > __spoint.x then
					flag = -1
				else
					flag = 1
				end

				local cIndex = 0
				local cCell = nil
				for i, v in pairs(self.heroCells) do
					if v == self.moveLayer._current_cell then
						cIndex = i
						break
					end
				end

				cIndex = cIndex + flag
				if self.heroCells[cIndex] ~= nil then
					self.moveLayer._current_cell = self.heroCells[cIndex]
					local seq = cc.Sequence:create(
						cc.RotateTo:create(0.25, (cIndex - 1) * 17.14),
						cc.CallFunc:create(self.changeScelecedHeroCellMoveEndFunN)
					)
					Panel_xuanze:stopAllActions()
					Panel_xuanze:runAction(seq)
				end
			else
				local _ship = self.moveLayer._current_cell._ship
				if type(_ship) == "table" then -- 换将
					state_machine.excute("ship_body_cell_show_ship_information", 0, {_datas = {_ship = _ship}})
				elseif _ship == -1 then -- 新将 
					local cIndex = 0
					local cCell = nil
					for i, v in pairs(self.heroCells) do
						if v == self.moveLayer._current_cell then
							cIndex = i
							break
						end
					end
					
					local pCount = 1
					local pXX = 0
					while true do
						local tCell = self.heroCells[cIndex - pCount]
						if tCell == nil then
							break
						end
						if tCell._ship == -1 then
							cCell = tCell
							pXX = pXX - self.headLayer.cell_width
						else
							break
						end
						pCount = pCount + 1
					end
					if cCell ~= self.moveLayer._current_cell then
						-- local seq = cc.Sequence:create(
							-- cc.MoveTo:create(0.25, cc.p(self.moveLayer.startX - pXX + self.moveLayer.cell_width, self.moveLayer:getPositionY())),
							-- cc.CallFunc:create(self.changeScelecedHeroCellMoveEndFunN2)
						-- )
						-- self.moveLayer:stopAllActions()
						-- self.moveLayer:runAction(seq)
						local addIndex = -1
						for i=2, 7 do
							if zstring.tonumber(_ED.formetion[i]) == 0 then
								addIndex = i - 1
								break
							end
						end
						self.moveLayer._current_cell._indexadd = addIndex
						self.moveLayer._params = {_index = addIndex, _type = 1, _shipId = -1}
						self._moved = false
						self.changeScelecedHeroCellMoveEndFunN2(self.moveLayer)
					end
				end
			end
		end
	end
	local function headLayerTouchEvent(sender, evenType)
		if __lua_project_id == __lua_project_yugioh then
			headLayerTouchEvent_YuGiOh(sender, evenType)
			return
		end
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if ccui.TouchEventType.began == evenType then
			self._mbf = false
			self._moved = false
			
			for i, v in pairs(self.heroCells) do
				local size = v:getContentSize()
				local touchToNode = v:convertToNodeSpace(__spoint)
				if touchToNode.x >= 0 and touchToNode.x <= size.width 
					and touchToNode.y >= (size.height - size.height / 4) and touchToNode.y <= size.height 
					then
					self._mbf = true
					return
				end
			end
		elseif evenType == ccui.TouchEventType.moved then
			if math.abs(__mpoint.x - __spoint.x) > 20 then
				if self._moved == false then
					self._selected = false
					self._moved = true
					self._sup = __mpoint.x - __spoint.x
					self.moveLayer:stopAllActions()
					self.moveLayer._basePosition.x =  self.moveLayer:getPositionX()
					self.moveLayer:setPositionX(self.moveLayer._basePosition.x + (__mpoint.x - __spoint.x) - self._sup)
				end
				if self._mbf == true then
					self.moveLayer:setPositionX(self.moveLayer._basePosition.x + (__mpoint.x - __spoint.x - self._sup))
				else
					-- self.moveLayer:setPositionX(self.moveLayer._basePosition.x + 
					-- 	-- (__mpoint.x - __spoint.x - self._sup) * self.moveLayer.cell_width / app.screenSize.height / app.scaleFactor * 5)
					-- 	(__mpoint.x - __spoint.x - self._sup) * 3 / 10)
					local mxx = (__mpoint.x - __spoint.x - self._sup) * 3 / 10
					if (math.abs(mxx) - self.moveLayer.cell_width) > 0 then
						if mxx > 0 then
							mxx = self.moveLayer.cell_width
						else
							mxx = -1 * self.moveLayer.cell_width
						end
					end
					self.moveLayer:setPositionX(self.moveLayer._basePosition.x + mxx)
				end
			end
		elseif ccui.TouchEventType.ended == evenType or
			ccui.TouchEventType.canceled == evenType then
			if self._moved == true then
				local index = 0
				if self.moveLayer._current_cell._ship == -2 or self.moveLayer._current_cell._ship == -5 then
					index = self._max_hero_counts -self.moveLayer._current_cell._indexadd
				end
				local seq = cc.Sequence:create(
					cc.MoveTo:create(0.25, cc.p(self.moveLayer.startX + self.moveLayer.cell_width - index*self.moveLayer.cell_width, self.moveLayer:getPositionY())),
					cc.CallFunc:create(self.changeScelecedHeroCellMoveEndFunN)
				)
				self.moveLayer:stopAllActions()
				self.moveLayer:runAction(seq)
				-- self._moved = false
			end
			self._sup = 0
			if true
				-- self.moveLayer._last_cell == self.moveLayer._current_cell 
				then
				if ccui.TouchEventType.ended == evenType and self._moved == false then
					for i, v in pairs(self.heroCells) do
						local size = v:getContentSize()
						local touchToNode = v:convertToNodeSpace(__epoint)
						if touchToNode.x >= 0 and touchToNode.x <= size.width 
							and touchToNode.y >= (size.height - size.height / 4) and touchToNode.y <= size.height 
							then
							-- self.moveLayer.startX = self.moveLayer.startX -1 * self.moveLayer.cell_width * 4/5
							-- self.moveLayer:setPositionX(self.moveLayer.startX)
							-- self:onUpdate(0)
							for h, j in pairs(self.heroCells) do
								if j == self.moveLayer._current_cell then
									local index = h
									if v._ship == -2 or v._ship == -5 then
										index = h-(self._max_hero_counts-v._indexadd)
									end
									local ph = index - i
									if ph ~= 0 then
										local mx = ph * self.moveLayer.cell_width
										local seq = cc.Sequence:create(
										cc.MoveTo:create(0.25 * math.abs(ph) / 3, cc.p(self.moveLayer:getPositionX() + mx , self.moveLayer:getPositionY())),
											cc.CallFunc:create(self.changeScelecedHeroCellMoveEndFunN)
										)
										self.moveLayer:stopAllActions()
										self.moveLayer:runAction(seq)
										self._moved = false
										return
									end
								end
							end
						end
					end
				end
				
				if math.abs( __epoint.x - __spoint.x) < 20 then
					sender._one_called = true
					local _ship = self.moveLayer._current_cell._ship
					if type(_ship) == "table" or _ship == -4 then -- 换将 换宠物
						state_machine.excute("ship_body_cell_show_ship_information", 0, {_datas = {_ship = _ship}})
					elseif _ship == -1 or _ship == -6 then -- 新将 新宠
						local cIndex = 0
						local cCell = nil
						for i, v in pairs(self.heroCells) do
							if v == self.moveLayer._current_cell then
								cIndex = i
								break
							end
						end
						
						local pCount = 1
						local pXX = 0

						while true do
							local tCell = self.heroCells[cIndex - pCount]
							if tCell == nil then
								break
							end
							if type(tCell._ship) == "number" and 
							zstring.tonumber(tCell._ship) == zstring.tonumber(_ship) then -- if tCell._ship == -1 then
								cCell = tCell
								pXX = pXX - self.headLayer.cell_width
							else
								break
							end
							pCount = pCount + 1
						end
						if cCell ~= self.moveLayer._current_cell then
							local seq = cc.Sequence:create(
								cc.MoveTo:create(0.25, cc.p(self.moveLayer.startX - pXX + self.moveLayer.cell_width, self.moveLayer:getPositionY())),
								cc.CallFunc:create(self.changeScelecedHeroCellMoveEndFunN2)
							)
							self.moveLayer:stopAllActions()
							self.moveLayer:runAction(seq)
							local addIndex = -1
							for i=2, 7 do
								if zstring.tonumber(_ED.formetion[i]) == 0 then
									addIndex = i - 1
									break
								end
							end
						
							self.moveLayer._current_cell._indexadd = addIndex
							if _ship == -6 then 
								--宠物
								self.moveLayer._params = {_index = addIndex, _type = 1, _shipId = -1,pet = true}
							else
								self.moveLayer._params = {_index = addIndex, _type = 1, _shipId = -1}
							end
							
							self._moved = false
						end
					end
				end
				now_current_cell = nil
			end
		end
	end
	self.headLayer.callback = headLayerTouchEvent
	self.headLayer:addTouchEventListener(headLayerTouchEvent)
	local Panel_xuanze = self.moveLayer:getChildByName("Panel_xuanze")
	if __lua_project_id == __lua_project_yugioh then
		local Panel_huadong = self.moveLayer:getChildByName("Panel_huadong")
		Panel_huadong:addTouchEventListener(headLayerTouchEvent)
	end	
	
	local function Panel_o_roomTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
			
		elseif evenType == ccui.TouchEventType.moved then
			
		end
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
	
	else
		self.Panel_o_room:addTouchEventListener(Panel_o_roomTouchEvent)
	end
		
	local queue = {
		shiptype = {},
		shipid = {},
	}
	
	local nCount = 0
	local tCount = 6
	local openCount = zstring.tonumber(_ED.user_info.user_fight)
	for i = 1, 6 do
		local shipType = 0
		local shipId = _ED.user_formetion_status[i]
		if zstring.tonumber(shipId) > 0 then 
			shipType = 1
			table.insert(queue.shipid, shipId)
			table.insert(queue.shiptype, shipType)
			nCount = nCount + 1
		else
			break
		end
	end
	
	for i = nCount + 1, openCount do
		table.insert(queue.shipid, -1)
		table.insert(queue.shiptype, 0)
		nCount = nCount + 1
	end
	
	for i = nCount + 1, tCount do
		table.insert(queue.shipid, -1)
		table.insert(queue.shiptype, -1)
		nCount = nCount + 1
	end
	--战宠
	local pet_grade = dms.int(dms["fun_open_condition"], 54, fun_open_condition.level)
	if pet_grade ~= -1 then
		self._max_hero_counts = 7
		if pet_grade <= zstring.tonumber(_ED.user_info.user_grade) then
			--开启
			if _ED.formation_pet_id == 0 or _ED.formation_pet_id == nil then 
				--未上阵
				table.insert(queue.shipid, 0)
				table.insert(queue.shiptype, -5)
			else
				table.insert(queue.shipid, _ED.formation_pet_id )
				table.insert(queue.shiptype, -3)
			end	
		else
			--未开启
			table.insert(queue.shipid, 0)
			table.insert(queue.shiptype, -4)
		end
	end
	table.insert(queue.shipid, shipId)
	table.insert(queue.shiptype, -2)
	self.queue = queue

	local shiptype = queue.shiptype
	local shipid = queue.shipid
	
	local cwidth = 0
	local dataCell = {}
	local total_width = 0
	local sCount = #queue.shiptype

	self.bfCount = sCount
	local shipCount = 0
	local wlCount = 3
	if __lua_project_id == __lua_project_yugioh then
		wlCount = 1
	end
	for j = 1, wlCount do
		for i = 1, sCount do
			local cell = nil
			local shipType = shiptype[i]
			local shipId = shipid[i]
			if shipType == 1 then										--有武将上阵
				cell = self:createShipHead(_ED.user_ship[shipId],1)
				cell._ship = _ED.user_ship[shipId]
				cell._indexadd = i-1
				cell.ship = _ED.user_ship[shipId]
				shipCount = shipCount + 1
				cell._index = i
			elseif shipType == 0 then									--无武将上阵
				cell = self:createAddandLockCell(2,0)
				cell._indexadd = i-1
				cell._ship = -1
				cell._index = i
			elseif shipType == -1 then									--上阵位未开启
				cell = self:createAddandLockCell(3, 0, i)				--传入当前位置
				cell._indexadd = i-1
				cell._ship = -2
				cell._index = i
			elseif shipType == -2 then									--小伙伴
				cell = self:createAddandLockCell(1)
				cell._indexadd = i-1
				cell._ship = -3
				cell._index = i
			elseif shipType == -3 then 						      --战宠
				cell = self:createPetCell(_ED.user_ship[""..shipId],1)
				cell._indexadd = i-1
				cell._ship = -4
				cell._index = i
				cell.ship = _ED.user_ship[""..shipId]
			elseif shipType == -4 then                        --战宠未开启 
				cell = self:createPetCell(0,3)
				cell._indexadd = i-1
				cell._ship = -5
				cell._index = i
			elseif shipType == -5 then  
				cell = self:createPetCell(0,2) 				  --战宠未上阵
				cell._indexadd = i-1
				cell._ship = -6
				cell._index = i
			end
			if cell then 
				table.insert(dataCell, cell)
				if __lua_project_id == __lua_project_yugioh then
					cell:setAnchorPoint(cc.p(0.5, 1))
					local __parent = Panel_xuanze:getChildByName("Panel_role_card_" .. i)
					__parent:addChild(cell)
					local __size = __parent:getContentSize()
					cell:setPosition(cc.p(__size.width/2, __size.height))

					cwidth = cell:getContentSize().width
					cheight = cell:getContentSize().height
					cell.startX = total_width - sCount * cwidth + cwidth
					cell._basePosition = cc.p(cell.startX, 0)
					total_width = total_width + cwidth
				else
					self.moveLayer:addChild(cell)
					cwidth = cell:getContentSize().width
					cheight = cell:getContentSize().height
					cell.startX = total_width - sCount * cwidth + cwidth
					cell._basePosition = cc.p(cell.startX, 0)
					cell:setPosition(cell._basePosition)
					total_width = total_width + cwidth
				end

				self.headLayer.cell_width = cwidth
				self.moveLayer.cell_width = cwidth

				cell:setTouchEnabled(false)
				-- cell:addTouchEventListener(touchEvent)
				-- cell:setSwallowTouches(false)
				
				cell._index = i
			end
		end
	end

	self.headLayer.cells = dataCell
	self.moveLayer.cells = dataCell
	self.heroCells = dataCell
	local cellCount = table.getn(self.heroCells)

	local currentCell = nil
	if __lua_project_id == __lua_project_yugioh then
		currentCell = self.heroCells[1]
	else
		currentCell = self.heroCells[self.bfCount]
	end
	self.moveLayer._current_cell = currentCell
	self.moveLayer._current_cell._is_selected = true
	self.moveLayer._current_cell:setScalePanel(1.2)
		
	-- dataCell[2]._is_selected = true
	self._selected = true
	-- self.moveLayer._current_cell = dataCell[2]
	--self.moveLayer._current_cell:setPositionY(self.moveLayer._current_cell._basePosition.y - 50)
	-- self.moveLayer._current_cell:setScalePanel(1.2)
	self.moveLayer.startX = 0
	self.moveLayer:setPositionX(self.moveLayer.startX)
	self:onUpdate(0)
	
	if __lua_project_id == __lua_project_yugioh then
		if  missionIsOver() == false and zstring.tonumber(_ED.user_info.user_grade) < 7 then
			local mIdx = 0
			for i, v in pairs(self.headLayer.cells) do
				if v._ship == -1 then
					mIdx = i
					break
				end
			end
			
			if mIdx > 0 then
				if currentCell ~= nil then
					currentCell._is_selected = true
					currentCell:setScalePanel(1.0)
				end
				if self.heroCells[mIdx] ~= nil then
					currentCell = self.heroCells[mIdx]
					self.moveLayer._current_cell = currentCell
					self.moveLayer._current_cell._is_selected = true
					self.moveLayer._current_cell:setScalePanel(1.2)
					Panel_xuanze:setRotation((mIdx - 1) * 17.14)
				end
			end
		end
	else
		if  missionIsOver() == false and zstring.tonumber(_ED.user_info.user_grade) < 7 then
			local mIdx = 0
			for i, v in pairs(self.headLayer.cells) do
				if v._ship == -1 then
					mIdx = i
					break
				end
			end
			for h, j in pairs(self.heroCells) do
				if j == self.moveLayer._current_cell then
					local ph = h - mIdx
					if ph ~= 0 then
						local mx = ph * self.moveLayer.cell_width
						local seq = cc.Sequence:create(
						cc.MoveTo:create(0.25 * math.abs(ph) / 3, cc.p(self.moveLayer:getPositionX() + mx , self.moveLayer:getPositionY())),
							cc.CallFunc:create(self.changeScelecedHeroCellMoveEndFunN)
						)
						self.moveLayer:stopAllActions()
						self.moveLayer:runAction(seq)
						self._moved = false
						return
					end
				end
			end

		end
	end
	
	---------------------------------------------------------------------------
	-- 选择指定人物进入阵容
	---------------------------------------------------------------------------
	if HomeHero.last_selected_hero ~= nil and HomeHero.touch_type == "menu" then
		_ship_instance = HomeHero.last_selected_hero
	end
	
	if _ship_instance ~= nil then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then
			local find_first_open = false
			for i, v in pairs(self._dataCell) do
				if type(v._ship) == "table" and v._ship.ship_id == _ship_instance.ship_id then
					v.choose:setVisible(true)
					self:changeScelecedHeroCell2(v)
				elseif v._ship == -1 and tonumber(_ship_instance.ship_id) == 0 and v._indexadd == self:getFormationPos("0", 1)
				  and find_first_open == false then
					find_first_open = true
					v.choose:setVisible(true)
					self:changeScelecedHeroCell2(v)
				else
					v.choose:setVisible(false)
				end
			end
		elseif __lua_project_id == __lua_project_yugioh then

		else
			local mIdx = 0
			for i, v in pairs(self.headLayer.cells) do
				if type(v._ship) == "table" and v._ship.ship_id  == _ship_instance.ship_id then
					mIdx = i
					break
				end
			end
			
			for h, j in pairs(self.heroCells) do
				if j == self.moveLayer._current_cell then
					local ph = h - mIdx
					if ph ~= 0 then
						local mx = ph * self.moveLayer.cell_width
						local seq = cc.Sequence:create(
						cc.MoveTo:create(0.25 * math.abs(ph) / 3, cc.p(self.moveLayer:getPositionX() + mx , self.moveLayer:getPositionY())),
							cc.CallFunc:create(self.changeScelecedHeroCellMoveEndFunN)
						)
						self.moveLayer:stopAllActions()
						self.moveLayer:runAction(seq)
						self._moved = false
						return
					end
				end
			end
		end	
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game then
			self:updateHeroPageView(self.moveLayer._current_cell)
			self.moveLayer._last_cell = self.moveLayer._current_cell
			self:updateDrawShipInfo()
			self:updateDrawEquipments()
		end
	end
	---------------------------------------------------------------------------
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game then
	
	else
		self:updateHeroPageView(self.moveLayer._current_cell)
		self.moveLayer._last_cell = self.moveLayer._current_cell
		
		self:updateDrawShipInfo()
		self:updateDrawEquipments()
	end	
	
	self.moveLayer.startWorldX = fwin:convertToWorldSpace(self.moveLayer, cc.p(self.moveLayer._current_cell:getPositionX(), self.moveLayer._current_cell:getPositionY())).x -- self.moveLayer:convertToWorldSpace(cc.p(self.moveLayer._current_cell:getPositionX(), self.moveLayer._current_cell:getPositionY())).x

	self:hideLight()
	
	self:responseStrengthenTheMaster()
end

if __lua_project_id ~= __lua_project_gragon_tiger_gate and __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_naruto  then
	local formation_open_instance_window_terminal = {
	    _name = "formation_open_instance_window",
	    _init = function (terminal)
	    end,
	    _inited = false,
	    _instance = self,
	    _state = 0,
	    _invoke = function(terminal, instance, params)
	    	local ship = params._datas._shipInstance
			if ship == nil then
				for i = 2, 7 do
					local shipId = _ED.formetion[i]
					if zstring.tonumber(shipId) > 0 then
						local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
						if zstring.tonumber(isleadtype) == 0 then
							-- formation:init(_ED.user_ship[_ED.formetion[i]])
							ship = _ED.user_ship[_ED.formetion[i]]
						end
					end
				end
			end
			
			--local formation = cacher.getObject("FormationClass")
			if g_formation == nil then
				g_formation = FormationCamp:new()
				g_formation._load_over = false
				g_formation:onLoad()
				-- cacher.addObject(formation)
				g_formation:retain()

		        if ship ~= nil then
		            g_formation:init(ship)
		   --      else
					-- for i = 2, 7 do
					-- 	local shipId = _ED.formetion[i]
					-- 	if zstring.tonumber(shipId) > 0 then
					-- 		local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
					-- 		if zstring.tonumber(isleadtype) == 0 then
					-- 			formation:init(_ED.user_ship[_ED.formetion[i]])
					-- 		end
					-- 	end
					-- end
		        end
		        return true
		    else
		    	g_formation:setVisible(true)
				g_formation:updateDrawPartnerView()
		    	g_formation:drawHeadQueue(ship)
		    	state_machine.unlock("menu_manager_change_to_page", 0, "")
			end
			if __lua_project_id == __lua_project_yugioh then
				local Panel_xuanze = g_formation.moveLayer:getChildByName("Panel_xuanze")
				Panel_xuanze:setRotation(0)
			end
			fwin:open(g_formation, fwin._view)
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
			if g_formation ~= nil then
				fwin:close(g_formation)
				g_formation:release()
			end
			g_formation = nil
	        return true
	    end,
	    _terminal = nil,
	    _terminals = nil
	}
	state_machine.add(formation_open_instance_window_terminal)
	state_machine.add(formation_release_instance_window_terminal)
	state_machine.init()
end

function Formation:showPropertyChangeTipInfoOfEquipment(previousShip,types,temp,ker)

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
	 		now_courage = _ED.user_ship[v.ship_id].ship_courage
	 		now_health = _ED.user_ship[v.ship_id].ship_health
	 		now_intellect = _ED.user_ship[v.ship_id].ship_intellect
	 		now_quick = _ED.user_ship[v.ship_id].ship_quick
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
			local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[previousShip.ship_id].ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(_ED.user_ship[previousShip.ship_id].evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
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
			local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[previousShip.ship_id].ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(_ED.user_ship[previousShip.ship_id].evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
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
		local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], _ED.user_ship[previousShip.ship_id].ship_template_id, ship_mould.relationship_id), ",")
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
end

--显示强化菜单
function Formation:showStrengthenMenu()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local menuPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_35")
	local isShow = menuPanel:isVisible()
	if isShow == true then 
		menuPanel:setVisible(false)
	else
		--
		local action = self.actions[1]
		if action ~= nil then 
			menuPanel:setVisible(true)
			action:play("qianghua", false)
		end
	end
end