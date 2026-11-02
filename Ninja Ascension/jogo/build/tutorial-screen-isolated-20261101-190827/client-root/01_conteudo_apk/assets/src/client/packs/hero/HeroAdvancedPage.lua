-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将突破界面
-------------------------------------------------------------------------------------------------------
HeroAdvancedPage = class("HeroAdvancedPageClass", Window)
HeroAdvancedPage.__userHeroFontName = nil
function HeroAdvancedPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.shipId = 0        --当前武将Id
	self.ship = nil		--当前武将信息
	self.proAdvanced = {}	--突破石信息
	self.shipMouldFront = nil -- 进阶前模板ID
	self.shipMouldBack = nil  -- 进阶后模板ID
	self.materialData = nil
	self.keepOutPanel = {}	-- 遮挡层
	self.PanelCacheFightArmature = nil
	self.cacheFightArmature = nil
	--升阶前的船只属性给升阶成长用的
	-- 1：等级
	-- 2：生命
	-- 3：攻击
	-- 4：物防
	-- 5：法防
	self._advancedBefore = {}
	self._advancedBack = {}
	--需求武将表
	self.num = 0
	self.needMaterialShip ={}
	self.needShipPCount = 0
	--需求的道具表
	self.needMaterialProp ={}
	self.needPropCount = 0
	--需求的道具数量
	--需求的装备表
	self.needMaterialEquip1={}
	self.needMaterialEquip2={}

	self.needEquiPCount = 0
	self.types = nil
	self.shopmould = nil
	self.needCount = 0
	
	self.lock = false
	app.load("client.packs.hero.HeroAdvanceSuccess")
	app.load("client.cells.ship.ship_body_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.prop.prop_icon_cell")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		app.load("client.cells.formation.Lformation_change_hero_cell")
	end
    local function init_hero_advanced_page_terminal()
		
		--选择被强化武将
		local hero_advanced_page_choose_been_level_up_hero_terminal = {
            _name = "hero_advanced_page_choose_been_level_up_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("选择突破武将")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--突破
		local hero_advanced_page_advanced_hero_terminal = {
            _name = "hero_advanced_page_advanced_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
            		state_machine.lock("hero_advanced_page_advanced_hero")
            		state_machine.excute("hero_icon_list_view_lock",0,"")
            	end
				if nil == instance._advancedBefore or nil == instance._advancedBack or table.getn(instance._advancedBefore) < 1 or table.getn(instance._advancedBack) < 1 then
					instance:updateAdvancedInfo(true)
					state_machine.excute("hero_icon_list_view_unlock",0,"")
					state_machine.unlock("hero_advanced_page_advanced_hero")
					return
				end

				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					state_machine.lock("hero_advanced_page_advanced_hero")
				end
				if instance.lock == true then
					state_machine.excute("hero_icon_list_view_unlock",0,"")
					state_machine.unlock("hero_advanced_page_advanced_hero")
					return
				end	

				state_machine.excute("hero_advanced_page_set_lock", 0, true)
				local function responseAdvenceHeroCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil then
							return
						end
						
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert
							then
							state_machine.excute("formation_update_ship_info",0,"")						
							state_machine.excute("formation_sort_and_get_index",0,"")
							local this_window = fwin:find("HeroAdvancedPageClass")
							if this_window ~= nil and this_window.roots ~= nil then
								
							else
								if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
									state_machine.excute("hero_icon_list_view_unlock",0,"")
				            		state_machine.unlock("hero_advanced_page_advanced_hero")
				            	end
								--若是因为网络原因，请求返回时，窗口已被玩家销毁，直接返回
								return
							end
						elseif __lua_project_id == __lua_project_warship_girl_b 
							or __lua_project_id == __lua_project_digimon_adventure 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh 
							then 
							--刷新进化后形象
							state_machine.excute("formation_advanced_updata",0,"")

							local shipInfo = fundShipWidthId(instance.shipId)
							local ship_template_id = shipInfo.ship_template_id
							local requirement = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould2)
							local isOpen = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level) <= zstring.tonumber(shipInfo.ship_grade)
							local captain =  dms.int(dms["ship_mould"], ship_template_id, ship_mould.captain_type) == 0 
							--主角 红橙将可以觉醒
							if requirement ~= -1 or captain == true then
								if isOpen == true then 
									--刷新
									state_machine.excute("hero_awaken_page_check_updata_by_other_page",0,"")	
								end
							end
						end
						self.lock = false
						self.PanelCacheFightArmature:setVisible(true)
						local function changeActionCallback(armatureBack)
							local armature = armatureBack
							if armature ~= nil and response.node._isStop == false then
								-- TipDlg.drawTextDailog(_string_piece_info[92])
								local successPage = HeroAdvanceSuccess:new()
								successPage:init(response.node.ship, response.node._advancedBefore, response.node._advancedBack, response.node.keepOutPanel, response.node.shopmould)
								fwin:open(successPage, fwin._ui)
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
				            		state_machine.unlock("hero_advanced_page_advanced_hero")
				            		state_machine.excute("hero_icon_list_view_unlock",0,"")
				            	elseif __lua_project_id == __lua_project_warship_girl_b 
				            		or __lua_project_id == __lua_project_digimon_adventure 
				            		or __lua_project_id == __lua_project_pokemon 
									or __lua_project_id == __lua_project_rouge 
									or __lua_project_id == __lua_project_yugioh 
									then 
				            		state_machine.unlock("hero_advanced_page_advanced_hero")
				            	end
								-- local action = csb.createTimeline("packs/HeroStorage/generals_advanced.csb")
								-- action:play("advanced_ui_show", false)
								-- instance.roots[1]:runAction(action)
								-- action:setFrameEventCallFunc(function (frame)
									-- if nil == frame then
										-- return
									-- end
									
									-- local str = frame:getEvent()
									-- if str == "advanced_ui_show_go" then
										
									-- elseif str == "close" then
									-- end
									
									-- end)
	
								response.node:onUpdateDraw()
								state_machine.excute("hero_strengthen_page_check_updata_by_other_page", 0, "haha")
								state_machine.excute("hero_train_page_check_updata_by_other_page", 0, "haha")
								state_machine.excute("hero_list_view_update_cell", 0, response.node.shipId)
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									state_machine.excute("hero_develop_page_update",0,"check_tupo_is_top")--刷新信息界面信息	
								end

								-- deleteEffect(armature)
								response.node.PanelCacheFightArmature:setVisible(false)
								response.node._isStop = true
							end
						end
						if self.cacheFightArmature.isInited ~= true then
							draw.initArmature(self.cacheFightArmature, nil, 1, nil, nil)
							-- playEffect(formatMusicFile("effect", 9997))
						end
						
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
						else
							self.keepOutPanel[1]:setVisible(false)
							self.keepOutPanel[2]:setVisible(true)
						end
						self._isStop = false
						self.cacheFightArmature.isInited = true
						
						self.cacheFightArmature._invoke = nil
						self.cacheFightArmature._actionIndex = 0
						self.cacheFightArmature._nextAction = 0
						self.cacheFightArmature:getAnimation():playWithIndex(0)
						self.cacheFightArmature._invoke = changeActionCallback
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							if tonumber(_ED.user_ship[response.node.shipId].captain_type) == 0 then
								-- state_machine.excute("formation_update_all_hero",0,"")
								state_machine.excute("home_hero_main_refresh_draw",0,"")
							end
						end
					else
						instance.lock = false
						state_machine.excute("hero_icon_list_view_unlock",0,"")
						state_machine.unlock("hero_advanced_page_advanced_hero")

					end
				end
				if dms.atoi(self.shipMouldFront, ship_mould.grow_target_id) == -1 then
					TipDlg.drawTextDailog(_string_piece_info[91])
					instance.lock = false
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            		state_machine.excute("hero_icon_list_view_unlock",0,"")
	            	elseif __lua_project_id == __lua_project_warship_girl_b 
	            		or __lua_project_id == __lua_project_digimon_adventure 
	            		or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            	end
					return
				end
				local materialData = dms.element(dms["ship_grow_requirement"], tonumber(dms.atoi(self.shipMouldFront, ship_mould.required_material_id)))
				if materialData == nil 
					or (dms.atoi(self.shipMouldBack, ship_mould.ship_type) ~= dms.atoi(self.shipMouldFront, ship_mould.ship_type) 
					and dms.atoi(self.shipMouldFront, ship_mould.captain_type) ~= 0) then
					TipDlg.drawTextDailog(_string_piece_info[78])
					instance.lock = false
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            		state_machine.excute("hero_icon_list_view_unlock",0,"")
	            	elseif __lua_project_id == __lua_project_warship_girl_b 
	            		or __lua_project_id == __lua_project_digimon_adventure 
	            		or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            	end
					return
				end
				if dms.atoi(materialData, ship_grow_requirement.need_level) > tonumber(self.ship.ship_grade) then
					TipDlg.drawTextDailog(_string_piece_info[79]..(""..dms.atos(materialData, ship_grow_requirement.need_level)).._string_piece_info[16])
					instance.lock = false
	            	if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            		state_machine.excute("hero_icon_list_view_unlock",0,"")
	            	elseif __lua_project_id == __lua_project_warship_girl_b 
	            		or __lua_project_id == __lua_project_digimon_adventure 
	            		or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            	end				
					return
				end
				if dms.atoi(self.materialData ,ship_grow_requirement.need_silver) > tonumber(_ED.user_info.user_silver) then
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						state_machine.excute("shortcut_function_silver_to_get_open",0,1)
					else
						TipDlg.drawTextDailog(_string_piece_info[86])
					end
					instance.lock = false
	            	if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            		state_machine.excute("hero_icon_list_view_unlock",0,"")
	            	elseif __lua_project_id == __lua_project_warship_girl_b 
	            		or __lua_project_id == __lua_project_digimon_adventure 
	            		or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            	end				
					return
				end
				local needHero = ""
				local needNumber = 0
				if dms.atoi(materialData, ship_grow_requirement.need_same_card_count) > 0 then
					local shipCurrentData = dms.element(dms["ship_mould"], tonumber(self.ship.ship_template_id))
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						for i, v in pairs(_ED.user_ship) do
							if(self.ship.ship_id ~= v.ship_id) then
								local shipData = dms.element(dms["ship_mould"], tonumber(v.ship_template_id))
								if dms.atoi(shipCurrentData, ship_mould.base_mould_priority) == 0 then
									if zstring.tonumber(v.formation_index) == 0 
										and zstring.tonumber(v.little_partner_formation_index) == 0 
										and zstring.tonumber(v.ship_grade) == 1 
										and zstring.tonumber(v.ship_skillstren.skill_level) == 1 
										and zstring.tonumber(v.awakenLevel) == 0 
										then
										if dms.atoi(shipData, ship_mould.base_mould) == dms.atoi(shipCurrentData, ship_mould.base_mould) 
											and dms.atoi(shipData, ship_mould.initial_rank_level) == 0 then
											if v.inResourceFromation ~= true then
												if dms.atoi(shipCurrentData, ship_mould.ship_type) == dms.atoi(shipData, ship_mould.ship_type) then
													needNumber = needNumber + 1
													if needNumber == self.needCount then
														needHero = needHero..v.ship_id
													elseif needNumber < self.needCount then
														needHero = needHero..v.ship_id .. ","
													end
												end
											end	
										end
									end
								end
							end
						end						
					else
						for i, v in pairs(_ED.user_ship) do
							if(self.ship.ship_id ~= v.ship_id) then
								local shipData = dms.element(dms["ship_mould"], tonumber(v.ship_template_id))
								if dms.atoi(shipCurrentData, ship_mould.base_mould_priority) == 0 then
									if zstring.tonumber(v.formation_index) == 0 
										and zstring.tonumber(v.little_partner_formation_index) == 0 
										and zstring.tonumber(v.ship_grade) == 1 
										and zstring.tonumber(v.ship_skillstren.skill_level) == 1 
										and zstring.tonumber(v.awakenLevel) == 0
										and zstring.tonumber(v.ship_train_info.train_life) == 0
										and zstring.tonumber(v.ship_train_info.train_attack) == 0
										and zstring.tonumber(v.ship_train_info.train_physical_defence) == 0
										and zstring.tonumber(v.ship_train_info.train_skill_defence) == 0
										then
										if dms.atoi(shipData, ship_mould.base_mould) == dms.atoi(shipCurrentData, ship_mould.base_mould) 
											and dms.atoi(shipData, ship_mould.initial_rank_level) == 0 then
											-- if dms.atoi(shipCurrentData, ship_mould.ship_type) == 4 
											-- and dms.atoi(shipData, ship_mould.ship_type) == 3 
											-- or dms.atoi(shipCurrentData, ship_mould.ship_type) < 4 then
												if dms.atoi(shipCurrentData, ship_mould.ship_type) == dms.atoi(shipData, ship_mould.ship_type) then
													needNumber = needNumber + 1
													if needNumber == self.needCount then
														needHero = needHero..v.ship_id
													elseif needNumber < self.needCount then
														needHero = needHero..v.ship_id .. ","
													end
												end	
											-- end
										end
									end
								end
							end
						end
					end
					if needNumber == 0 then
						-- TipDlg.drawTextDailog(_string_piece_info[80])     --改造所需舰娘
						app.load("client.packs.hero.HeroPatchInformationPageGetWay")
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(self.ship.ship_base_template_id)
						fwin:open(cell, fwin._windows)
						instance.lock = false
		            	if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
		            		state_machine.excute("hero_icon_list_view_unlock",0,"")
		            		state_machine.unlock("hero_advanced_page_advanced_hero")
		            	elseif __lua_project_id == __lua_project_warship_girl_b 
		            		or __lua_project_id == __lua_project_digimon_adventure 
		            		or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh 
							then 
		            		state_machine.unlock("hero_advanced_page_advanced_hero")
		            	end						
						return
					end
				else
					needHero = ""
				end
				
				-- debug.print_r(needHero)
				local needPropInfo = ""
				if self.needPropCount == 0 then
					needPropInfo = ""
				else
					for i=1, self.needPropCount do
						if self.needMaterialProp[i] == nil then
							TipDlg.drawTextDailog(_string_piece_info[81])
							app.load("client.packs.hero.HeroPatchInformationPageGetWay")
							local cell = HeroPatchInformationPageGetWay:createCell()
							cell:init(2,2)
							fwin:open(cell, fwin._windows)
							instance.lock = false
			            	if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
			            		state_machine.excute("hero_icon_list_view_unlock",0,"")
			            		state_machine.unlock("hero_advanced_page_advanced_hero")
			            	elseif __lua_project_id == __lua_project_warship_girl_b 
			            		or __lua_project_id == __lua_project_digimon_adventure 
			            		or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge 
								or __lua_project_id == __lua_project_yugioh 
								then 
		            			state_machine.unlock("hero_advanced_page_advanced_hero")
		            		end						
							return
						end
						if i == self.needPropCount then
							needPropInfo = needPropInfo..self.needMaterialProp[i]
						else
							needPropInfo = needPropInfo..self.needMaterialProp[i]..","
						end
					end
				end
				
				local needEquipInfo = " "
				if self.needEquiPCount == 0 then
					needEquipInfo = " "
				else
					if dms.atoi(materialData, ship_grow_requirement.need_equipment1) > 0 and dms.atoi(materialData, ship_grow_requirement.need_equipment1_count)>0 then
						for i=1,dms.atoi(materialData, ship_grow_requirement.need_equipment1_count) do
							if self.needMaterialEquip1[i] == nil then
								TipDlg.drawTextDailog(_string_piece_info[82])
								instance.lock = false
				            	if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
				            		state_machine.excute("hero_icon_list_view_unlock",0,"")
				            		state_machine.unlock("hero_advanced_page_advanced_hero")
				            	elseif __lua_project_id == __lua_project_warship_girl_b 
				            		or __lua_project_id == __lua_project_digimon_adventure 
				            		or __lua_project_id == __lua_project_pokemon 
									or __lua_project_id == __lua_project_rouge 
									or __lua_project_id == __lua_project_yugioh 
									then 
				            		state_machine.unlock("hero_advanced_page_advanced_hero")
		            			end						
								return
							else
								needEquipInfo = needEquipInfo..self.needMaterialEquip1[i]..","
							end
						end
					end
					if dms.atoi(materialData, ship_grow_requirement.need_equipment2) > 0 and dms.atoi(materialData, ship_grow_requirement.need_equipment2_count)>0 then
						for i=1,dms.atoi(materialData, ship_grow_requirement.need_equipment2_count) do
							if self.needMaterialEquip2[i] == nil then
								TipDlg.drawTextDailog(_string_piece_info[82])
								instance.lock = false
				            	if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
				            		state_machine.excute("hero_icon_list_view_unlock",0,"")
				            		state_machine.unlock("hero_advanced_page_advanced_hero")
				            	elseif __lua_project_id == __lua_project_warship_girl_b 
				            		or __lua_project_id == __lua_project_digimon_adventure 
				            		or __lua_project_id == __lua_project_pokemon 
									or __lua_project_id == __lua_project_rouge 
									or __lua_project_id == __lua_project_yugioh 
									then 
				            		state_machine.unlock("hero_advanced_page_advanced_hero")
		            			end							
								return
							else
								needEquipInfo = needEquipInfo..self.needMaterialEquip2[i]..","
							end
						end
					end
				end
				if tonumber(self.userPropNumber) < tonumber(self.num) and tonumber(self.needPropCount) == 1 then
					app.load("client.packs.hero.HeroPatchInformationPageGetWay")
					local cell = HeroPatchInformationPageGetWay:createCell()
					cell:init(2,2)
					fwin:open(cell, fwin._windows)
					instance.lock = false
	            	if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
	            		state_machine.excute("hero_icon_list_view_unlock",0,"")
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            	elseif __lua_project_id == __lua_project_warship_girl_b 
	            		or __lua_project_id == __lua_project_digimon_adventure 
	            		or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
	            		state_machine.unlock("hero_advanced_page_advanced_hero")
	            	end					
					return
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					if tonumber(self.userPropNumber) < tonumber(self.num) then
						app.load("client.packs.hero.HeroPatchInformationPageGetWay")
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(2,2)
						fwin:open(cell, fwin._windows)
						instance.lock = false
		            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		            		state_machine.excute("hero_icon_list_view_unlock",0,"")
		            		state_machine.unlock("hero_advanced_page_advanced_hero")
		            	end						
						return
					end
				end
				protocol_command.ship_grow_up.param_list = ""..instance.shipId.."\r\n"..needHero.."\r\n"..needPropInfo.."\r\n"..needEquipInfo.."\r\n1"
				NetworkManager:register(protocol_command.ship_grow_up.code, nil, nil, nil, instance, responseAdvenceHeroCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--让其他类刷新本类信息
		local hero_advanced_page_check_updata_by_other_page_terminal = {
            _name = "hero_advanced_page_check_updata_by_other_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			    if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
					cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,instance.onUpdateDraw,self)
			    else
			    	if instance ~= nil and instance.roots ~= nil then 
			    		instance:onUpdateDraw(params)
			    	end
			    end				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	
		local hero_advanced_page_Success_data_refresh_terminal = {
            _name = "hero_advanced_page_Success_data_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				if nil ~= fwin:find("HeroAdvancedPageClass") then
					instance.shopmould = instance.ship.ship_template_id
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_advanced_page_set_lock_terminal = {
            _name = "hero_advanced_page_set_lock",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.lock = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
        state_machine.add(hero_advanced_page_choose_been_level_up_hero_terminal)	
        state_machine.add(hero_advanced_page_advanced_hero_terminal)	
        state_machine.add(hero_advanced_page_advanced_stone_terminal)	
        state_machine.add(hero_advanced_page_check_updata_by_other_page_terminal)	
        state_machine.add(hero_advanced_page_Success_data_refresh_terminal)	
        state_machine.add(hero_advanced_page_set_lock_terminal)	
        state_machine.init()
    end
    init_hero_advanced_page_terminal()
end


function HeroAdvancedPage:updateAdvancedInfo(isSendAdvanced)
	local function responseAdvenceHeroMathCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			
			if nil == fwin:find("HeroAdvancedPageClass") then
				return
			end
		
			if self._advancedBack == nil then
				self._advancedBack = {}
			end
		
			self._advancedBack[2] = _ED.add_ship_power  		--战船生命加成
			self._advancedBack[3] = _ED.add_ship_courage     	--战船攻击加成
			self._advancedBack[4] = _ED.add_ship_intellect 		--战船物防加成
			self._advancedBack[5] = _ED.add_ship_nimable     	--战船法防加成	
			
			local rankLevelBack = dms.atoi(self.shipMouldBack, ship_mould.initial_rank_level)  	--进阶hou的进阶等级
			local maxLevelBack = dms.atoi(self.shipMouldBack, ship_mould.rank_grow_up_limit)  	--进阶最大等级
			
			--进阶后属性
			if rankLevelBack ~= nil and maxLevelBack ~= nil and (rankLevelBack <= maxLevelBack) then
				local Text_gongji_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_1_1")
				local Text_shengming_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_1_1")
				local Text_wufang_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_1_1")
				local Text_mofang_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_mofang_1_1")

				Text_shengming_add:setString(self._advancedBefore[2] + self._advancedBack[2])
				Text_gongji_add:setString(self._advancedBefore[3] + self._advancedBack[3])
				Text_wufang_add:setString(self._advancedBefore[4] + self._advancedBack[4])
				Text_mofang_add:setString(self._advancedBefore[5] + self._advancedBack[5])
				
				Text_shengming_add:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))   -- 亮绿色
				Text_gongji_add:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))   -- 亮绿色
				Text_wufang_add:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))   -- 亮绿色
				Text_mofang_add:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))   -- 亮绿色
			end
			
			if true == isSendAdvanced then

				state_machine.excute("hero_advanced_page_advanced_hero", 0, {_datas = {shipId = self.shipId}}) 

			end
			
		end
	end
	protocol_command.view_ship_grow_up_additional.param_list = ""..self.shipId
	NetworkManager:register(protocol_command.view_ship_grow_up_additional.code, nil, nil, nil, nil, responseAdvenceHeroMathCallback, false, nil)
end

function HeroAdvancedPage:playShow( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.actions[1]:play("window_open",false)
	end
end
function HeroAdvancedPage:onUpdateDraw()
	local Text_1_money = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1_money")
	local Panel_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_10")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	elseif __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		then 
		Text_1_money:setColor(cc.c3b(255, 255, 255))
		Panel_10:removeAllChildren(true)
	else
		Text_1_money:setColor(cc.c3b(0, 0, 0))
		Panel_10:removeAllChildren(true)
	end

	self.ship = fundShipWidthId(self.shipId)
	self.shipMouldFront = dms.element(dms["ship_mould"], self.ship.ship_template_id)
	--武将全身像前
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		-- local shipCell = LformationChangeHeroCell:createCell()
		-- shipCell:init(self.ship)
		-- Panel_10:addChild(shipCell)
	else
		local shipCell = ShipBodyCell:createCell()
		shipCell:init(self.ship, 0)
		Panel_10:addChild(shipCell)
	end
		
	--进阶前属性 dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.initial_rank_level)
	local rankLevelFront = dms.atoi(self.shipMouldFront, ship_mould.initial_rank_level)  --进阶前的进阶等级
	local ship_name = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[""..self.shipId].ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(_ED.user_ship[""..self.shipId].evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
		ship_name = word_info[3].." +"..rankLevelFront
    else
		if dms.atoi(self.shipMouldFront, ship_mould.captain_type) == 0 then
			ship_name = _ED.user_info.user_name .." +"..rankLevelFront
		else
			ship_name = dms.atos(self.shipMouldFront, ship_mould.captain_name).." +"..rankLevelFront		--战船名称
		end
	end

	self._advancedBefore[1] = self.ship.ship_grade
	self._advancedBefore[2] = self.ship.ship_health
	self._advancedBefore[3] = self.ship.ship_courage
	self._advancedBefore[4] = self.ship.ship_intellect
	self._advancedBefore[5] = self.ship.ship_quick
	
	local Text_gongji = ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_0")
	local Text_shengming = ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_0")
	local Text_wufang = ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_0")
	local Text_mofang = ccui.Helper:seekWidgetByName(self.roots[1], "Text_mofang_0")
	local Text_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name")
	
	local ship_type = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
		if ___is_open_leadname == true then
			if HeroAdvancedPage.__userHeroFontName == nil then
				HeroAdvancedPage.__userHeroFontName = Text_name:getFontName()
			end
			if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then
				Text_name:setFontName("")
				Text_name:setFontSize(Text_name:getFontSize())-->设置字体大小
			else
				Text_name:setFontName(HeroAdvancedPage.__userHeroFontName)
			end
		end

		Text_name:setString(ship_name)
	end
	Text_shengming:setString(self._advancedBefore[2])
	Text_gongji:setString(self._advancedBefore[3])
	Text_wufang:setString(self._advancedBefore[4])
	Text_mofang:setString(self._advancedBefore[5])
	local Panel_xiaji = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xiaji")
	if Panel_xiaji ~= nil then 
		Panel_xiaji:setVisible(true)
	end
	local Button_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_1")
	--判断进阶是否到达上限 -1 为上限
	local Text_tupo = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupo")
	Text_tupo:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))

	local text_33 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_33")
	local Text_32 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_32")
	if text_33 ~= nil then 
		text_33:setVisible(true)
	end
	if Text_32 ~= nil then 
		Text_32:setVisible(true)
	end
	if Button_1 ~= nil then 
		Button_1:setTouchEnabled(true)
		Button_1:setColor(cc.c3b(255,255,255))
	end

	local Panel_4_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_0")
	Panel_4_0:removeAllChildren(true)
	local Text_38 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_38")
	Text_38:setString("")
	local item_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_38")
	item_name:setString("")
	
	local Image_5 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_5")
	local Text_tupodj_1=ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupodj_1")
	local Text_tupodj_2=ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupodj_2")
	local Text_tupo_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupo_2")
	local Text_tupo_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupo_1")
	local Text_tupo_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupo_0")
	if dms.atoi(self.shipMouldFront, ship_mould.grow_target_id) == -1 then
		Text_tupo:setVisible(false)
		-- print("============11")
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			if isTip ~= nil and isTip == false then 
				--从其他界面调用的刷新不能弹出提示
			else
				TipDlg.drawTextDailog(_string_piece_info[91])
			end
		end
		--满级
		if Panel_xiaji ~= nil then 
			Panel_xiaji:setVisible(false)
		end
		if Button_1 ~= nil then 
			Button_1:setTouchEnabled(false)
			Button_1:setColor(cc.c3b(150,150,150))
		end
		
		if text_33 ~= nil then 
			text_33:setVisible(false)
		end
		if Text_32 ~= nil then 
			Text_32:setVisible(false)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			Text_tupodj_1:setString(dms.atoi(self.shipMouldFront, ship_mould.rank_grow_up_limit))
			Text_tupodj_2:setString(_string_piece_info[91])
			Image_5:setVisible(false)
			Text_1_money:setString("")
			Text_tupo_2:setString("")
			Text_tupo_1:setString("")
			Text_tupo_0:setString("")
			Panel_4_0:setVisible(false)
		end
		return true
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			Image_5:setVisible(true)
			Panel_4_0:setVisible(true)
		end
		Text_tupo:setVisible(true)
	end
	self.shipMouldBack = dms.element(dms["ship_mould"], dms.atoi(self.shipMouldFront, ship_mould.grow_target_id))
	self.materialData = dms.element(dms["ship_grow_requirement"], dms.atoi(self.shipMouldFront, ship_mould.required_material_id))

	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local Text_tupodj_1=ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupodj_1")
		local Text_tupodj_2=ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupodj_2")
		local rankLevelBack = dms.atoi(self.shipMouldBack, ship_mould.initial_rank_level)
		Text_tupodj_1:setString(rankLevelBack - 1)
		Text_tupodj_2:setString(rankLevelBack)
	end
	
	-- -- ----------------------------------------------------------------------------------------------- 
	-- -- 进阶需求  dms.atoi(propData, prop_mould.id)  dms.element(dms["prop_mould"], dms.atoi(materialData, ship_grow_requirement.need_prop1))
	-- -- -----------------------------------------------------------------------------------------------
	-- -- 英雄

	local needNumber = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count)) > 0 then
			local shipCurrentData = dms.element(dms["ship_mould"], tonumber(self.ship.ship_template_id))	
			for i, v in pairs(_ED.user_ship) do
				if(self.ship.ship_id ~= v.ship_id) then
					local shipData = dms.element(dms["ship_mould"], tonumber(v.ship_template_id))
					if dms.atoi(shipCurrentData, ship_mould.base_mould_priority) == 0 then
						if zstring.tonumber(v.formation_index) == 0 and zstring.tonumber(v.little_partner_formation_index) == 0 then
							if dms.atoi(shipData, ship_mould.base_mould) == dms.atoi(shipCurrentData, ship_mould.base_mould) and dms.atoi(shipData, ship_mould.initial_rank_level) == 0 then
								
								if v.inResourceFromation ~= true then
									if dms.atoi(shipCurrentData, ship_mould.ship_type) == dms.atoi(shipData, ship_mould.ship_type) then
										needNumber = needNumber + 1
										--print("===========================",zstring.tonumber(v.formation_index), zstring.tonumber(v.little_partner_formation_index),v.inResourceFromation,v.captain_name,v.ship_id)
										if needNumber == 1 then
											local Panel_4_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_0")
												--这个地方龙虎们也是调用头像，不是动画
											Panel_4_0:removeAllChildren(true)
											local head = ShipHeadCell:createCell()
											head:init(nil, 13, v.ship_base_template_id)
											Panel_4_0:addChild(head)
										end
									end	
								end
							end
						end
					end
				end
			end
			if needNumber == 0 then
				local Panel_4_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_0")
				Panel_4_0:removeAllChildren(true)
				local head = ShipHeadCell:createCell()
				head:init(nil, 13, self.ship.ship_base_template_id)
				Panel_4_0:addChild(head)
			end
			local Text_38 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_38")
			--print("==============",needNumber.."/"..dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count))
			Text_38:setString(needNumber.."/"..dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count))
			self.needCount = dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count)
			local item_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_38"):setString(self.ship.captain_name)
			local colortype = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)+1
			item_name:setColor(cc.c3b(color_Type[colortype][1],color_Type[colortype][2],color_Type[colortype][3]))
			if tonumber(needNumber) < dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count) then
				Text_38:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))   -- 大红色
			else
				Text_38:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
			end	
		end		
	else
		if zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count)) > 0 then
			local shipCurrentData = dms.element(dms["ship_mould"], tonumber(self.ship.ship_template_id))	
			for i, v in pairs(_ED.user_ship) do
				if(self.ship.ship_id ~= v.ship_id) then
					local shipData = dms.element(dms["ship_mould"], tonumber(v.ship_template_id))
					if dms.atoi(shipCurrentData, ship_mould.base_mould_priority) == 0 then
						if zstring.tonumber(v.formation_index) == 0 
						and zstring.tonumber(v.little_partner_formation_index) == 0 
						and zstring.tonumber(v.ship_grade) == 1 
						and zstring.tonumber(v.ship_skillstren.skill_level) == 1 
						and zstring.tonumber(v.awakenLevel) == 0
						and zstring.tonumber(v.ship_train_info.train_life) == 0
						and zstring.tonumber(v.ship_train_info.train_attack) == 0
						and zstring.tonumber(v.ship_train_info.train_physical_defence) == 0
						and zstring.tonumber(v.ship_train_info.train_skill_defence) == 0
						then

							if dms.atoi(shipData, ship_mould.base_mould) == dms.atoi(shipCurrentData, ship_mould.base_mould) 
							and dms.atoi(shipData, ship_mould.initial_rank_level) == 0 then
								-- if dms.atoi(shipCurrentData, ship_mould.ship_type) == 4 
								-- and dms.atoi(shipData, ship_mould.ship_type) == 3 
								-- or dms.atoi(shipCurrentData, ship_mould.ship_type) < 4 then
									if dms.atoi(shipCurrentData, ship_mould.ship_type) == dms.atoi(shipData, ship_mould.ship_type) then
										needNumber = needNumber + 1
										if needNumber == 1 then
											local Panel_4_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_0")
												--这个地方龙虎们也是调用头像，不是动画
											Panel_4_0:removeAllChildren(true)
											local head = ShipHeadCell:createCell()
											head:init(nil, 13, v.ship_base_template_id)
											Panel_4_0:addChild(head)
										end
									end	
								-- end
							end
						end
					end
				end
			end
			if needNumber == 0 then
				local Panel_4_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_0")
				Panel_4_0:removeAllChildren(true)
				local head = ShipHeadCell:createCell()
				head:init(nil, 13, self.ship.ship_base_template_id)
				Panel_4_0:addChild(head)
			end
			local Text_38 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_38")
			Text_38:setString(needNumber.."/"..dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count))
			self.needCount = dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count)
			local item_name = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
		        --进化形象
		        local evo_image = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.fitSkillTwo)
		        local evo_info = zstring.split(evo_image, ",")
		        --进化模板id
		        local ship_evo = zstring.split(self.ship.evolution_status, "|")
		        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		        local word_info = dms.element(dms["word_mould"], name_mould_id)
    			captainName = word_info[3]
		        item_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_38"):setString(captainName)
		    else
				if __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					then 
					local base_ship_id = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.base_mould)
					local heroName = dms.string(dms["ship_mould"], base_ship_id, ship_mould.captain_name)
					item_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_38"):setString(heroName)
				else
					item_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_38"):setString(self.ship.captain_name)
				end
			end
			
			local colortype = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)+1
			item_name:setColor(cc.c3b(color_Type[colortype][1],color_Type[colortype][2],color_Type[colortype][3]))
			if tonumber(needNumber) < dms.atoi(self.materialData, ship_grow_requirement.need_same_card_count) then
				Text_38:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))   -- 大红色
			else
				Text_38:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
			end	
		end
	end

	-- -- 道具
	local tempMouldId = dms.atoi(self.materialData, ship_grow_requirement.need_prop1)
	if tempMouldId > 0 and zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_prop1_count)) > 0 then
		self.needPropCount = self.needPropCount + 1
	
		local propData = dms.element(dms["prop_mould"], dms.atoi(self.materialData, ship_grow_requirement.need_prop1))
		local propMouldId = dms.atos(propData, prop_mould.id)
		local userPropData = fundPropWidthId(propMouldId)

		local Panel_4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4")
		Panel_4:removeAllChildren(true)
		-- local mode = 10
		-- if userPropData == nil then
			-- userPropData = {mould_id = tempMouldId, goods_id = tempMouldId, prop_number = 0, sell_count = 0, }
			-- mode = 7
		-- else
			-- self.needMaterialProp[self.needPropCount] = userPropData.user_prop_id
		-- end
		-- 存入所需物品	
		if userPropData ~= nil then
			self.userPropNumber = tonumber(userPropData.prop_number)
			self.needMaterialProp[self.needPropCount] = userPropData.user_prop_id
		else
			self.userPropNumber = 0
		end
		-- 绘制该物品 突破石
		local shipAdvanceStone = PropIconCell:createCell()
		shipAdvanceStone:init(22, propMouldId,nil,nil,2)
		Panel_4:addChild(shipAdvanceStone)
		-- 数量
		local needCount = dms.atoi(self.materialData, ship_grow_requirement.need_prop1_count)
		local Text_tupo_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupo_0")
		Text_tupo_0:setString(self.userPropNumber.."/"..needCount)
		if tonumber(self.userPropNumber) < tonumber(needCount) then
			Text_tupo_0:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))   -- 大红色
		else
			Text_tupo_0:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))  
		end	
			
		self.num = needCount
	end
	
	if zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_prop2)) > 0 and zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_prop2_count)) > 0 then
		self.needPropCount = self.needPropCount + 1
	
		local propData = dms.element(dms["prop_mould"], dms.atoi(self.materialData, ship_grow_requirement.need_prop2))
		local propMouldId = dms.atos(propData, prop_mould.id)
		local userPropData = fundPropWidthId(propMouldId)

		if userPropData ~= nil then
			-- 存入所需物品
			self.needMaterialProp[self.needPropCount] = userPropData.user_prop_id	
			self.userPropNumber = tonumber(userPropData.prop_number)
		else		
		end
	end
	
	if zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_prop3)) > 0 and zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_prop3_count)) > 0 then
		self.needPropCount = self.needPropCount + 1
	
		local propData = dms.element(dms["prop_mould"], dms.atoi(self.materialData, ship_grow_requirement.need_prop3))
		local propMouldId = dms.atos(propData, prop_mould.id)
		local userPropData = fundPropWidthId(propMouldId)

		-- local Panel_4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4")
		if userPropData ~= nil then
			-- 存入所需物品
			self.needMaterialProp[self.needPropCount] = userPropData.user_prop_id	
			self.userPropNumber = tonumber(userPropData.prop_number)
		else		
		end
	end
	
	if zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_prop4)) > 0 and zstring.tonumber(dms.atoi(self.materialData, ship_grow_requirement.need_prop4_count)) > 0 then
		self.needPropCount = self.needPropCount + 1
	
		local propData = dms.element(dms["prop_mould"], dms.atoi(self.materialData, ship_grow_requirement.need_prop4))
		local propMouldId = dms.atos(propData, prop_mould.id)
		local userPropData = fundPropWidthId(propMouldId)

		-- local Panel_4 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4")
		if userPropData ~= nil then
			-- 存入所需物品
			self.needMaterialProp[self.needPropCount] = userPropData.user_prop_id	
			self.userPropNumber = tonumber(userPropData.prop_number)
		else		
		end
	end
	
	-- -- 装备
	local materialData = dms.element(dms["ship_grow_requirement"], tonumber(dms.atoi(self.shipMouldFront, ship_mould.required_material_id)))
	if zstring.tonumber(dms.atoi(materialData, ship_grow_requirement.need_equipment1)) > 0 and zstring.tonumber(dms.atoi(materialData, ship_grow_requirement.need_equipment1_count)) > 0 then
		local _needequipNumber = 0
		for i, v in pairs(_ED.user_equiment) do
			if tonumber(v.user_equiment_template) == dms.atoi(materialData, ship_grow_requirement.need_equipment1) and zstring.tonumber(v.ship_id)==0 then 
				_needequipNumber = _needequipNumber+1
				self.needMaterialEquip1[_needequipNumber] = v.user_equiment_id
			end
		end
		self.needEquiPCount = self.needEquiPCount + 1
	end
	
	if zstring.tonumber(dms.atoi(materialData, ship_grow_requirement.need_equipment2)) > 0 and zstring.tonumber(dms.atoi(materialData, ship_grow_requirement.need_equipment2_count)) > 0 then
		local _needequipNumber = 0
		for i, v in pairs(_ED.user_equiment) do
			if tonumber(v.user_equiment_template) == dms.atoi(materialData, ship_grow_requirement.need_equipment2) and zstring.tonumber(v.ship_id)==0 then 
				_needequipNumber = _needequipNumber+1
				self.needMaterialEquip2[_needequipNumber] = v.user_equiment_id
			end
		end
		self.needEquiPCount = self.needEquiPCount + 1
	end

	-- -- -----------------------------------------------------------------------------------------------
	-- -- 进阶需求~end
	-- -- -----------------------------------------------------------------------------------------------
	local needMoney = dms.atoi(self.materialData ,ship_grow_requirement.need_silver)		--突破所需钱币
	
	--进阶后属性
	local rankLevelBack = dms.atoi(self.shipMouldBack, ship_mould.initial_rank_level)  	--进阶hou的进阶等级
	local captainName = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[""..self.shipId].ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(_ED.user_ship[""..self.shipId].evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
    	captainName = word_info[3]
    else
		if dms.atoi(self.shipMouldBack, ship_mould.captain_type) == 0 then
			captainName = _ED.user_info.user_name
		else
			captainName = dms.atos(self.shipMouldBack, ship_mould.captain_name)
		end
	end
	local ship_name_add = captainName.." +"..rankLevelBack  					--战船名称
	
	self:updateAdvancedInfo()

	Text_1_money:setString(needMoney)
	if tonumber(needMoney) > tonumber(_ED.user_info.user_silver) then
		Text_1_money:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	else
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
			Text_1_money:setColor(cc.c3b(0, 0, 0))
		elseif __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			then 
			Text_1_money:setColor(cc.c3b(255, 255, 255))
		else
			Text_1_money:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		end
		
	end
	
	local maxLevelBack = dms.atoi(self.shipMouldFront,ship_mould.rank_grow_up_limit)
	if rankLevelBack <= maxLevelBack then
		--进阶后
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			local Panel_11 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_11")
			Panel_11:removeAllChildren(true)
			local Text_name_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_0")
			if ___is_open_leadname == true then
				if HeroAdvancedPage.__userHeroFontName == nil then
					HeroAdvancedPage.__userHeroFontName = Text_name_add:getFontName()
				end
				if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then
					Text_name_add:setFontName("")
					Text_name_add:setFontSize(Text_name:getFontSize())-->设置字体大小
				else
					Text_name_add:setFontName(HeroAdvancedPage.__userHeroFontName)
				end
			end
			Text_name_add:setString(ship_name_add)
			
			local ship_type = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
			Text_name_add:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
			
			--武将全身像后
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then			--龙虎门项目控制
				local shipCell = LformationChangeHeroCell:createCell()
				shipCell:init(self.ship)
				Panel_11:addChild(shipCell)
			elseif __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				then 
				local shipCell = ShipBodyCell:createCell()
				local ship_up_id = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.grow_target_id) 
				if ship_up_id == nil then 
					shipCell:init(self.ship, 0)
				else
					shipCell:init({ship_template_id = ship_up_id}, 0)
				end

				Panel_11:addChild(shipCell)
			else
				local shipCell = ShipBodyCell:createCell()
				shipCell:init(self.ship, 0)
				Panel_11:addChild(shipCell)
			end
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			self.keepOutPanel[1]:setVisible(true)
		end
	end
	-- 进阶后的属性描述 rankLevelBack
	if rankLevelBack <= maxLevelBack then
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xiaji"):setVisible(true)
		local talent_id = dms.atos(self.shipMouldBack, ship_mould.talent_id)  --进阶hou的进阶等级
		if talent_id ~= "" and talent_id ~= nil then
			local talent_id_ship = zstring.zsplit(talent_id, "|")				--进阶的表
			local talent = zstring.zsplit(talent_id_ship[rankLevelBack], ",")
			local talent_name = dms.string(dms["talent_mould"], talent[3], talent_mould.talent_name)
			local talent_describe = dms.string(dms["talent_mould"], talent[3], talent_mould.talent_describe)
			local Text_tupo_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupo_1")
			Text_tupo_1:setString(_string_piece_info[141]..talent_name)
			Text_tupo_1:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupo_2"):setString(talent_describe)
		end
		-- 进阶需要等级  Text_lv
		local ship_grade = _ED.user_ship[self.shipId].ship_grade
		local needLevel = dms.atos(self.materialData, ship_grow_requirement.need_level)
		local text_33 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_33")
		local Text_32 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_32")
		text_33:setString(ship_grade.."/"..needLevel)
		if tonumber(ship_grade) < tonumber(needLevel) then
			text_33:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))   -- 大红色
			Text_32:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))   -- 大红色
		else
			text_33:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))   -- 亮绿色
			Text_32:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))   -- 亮绿色
		end
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xiaji"):setVisible(false)
		TipDlg.drawTextDailog(_string_piece_info[91])
	end
	
	
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	-- 	local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)
	-- 	local lv =ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lv")
	-- 	local lan=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lan")
	-- 	local zi=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_zi")
	-- 	local cheng=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_cheng")
	-- 	local hong=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	-- 	if quality == 0 then
	-- 		--print("白色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 1 then
	-- 		--print("绿色")
	-- 		lv:setVisible(true)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 2 then
	-- 		--print("蓝色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(true)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 3 then
	-- 		--print("紫色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(true)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 4 then
	-- 		--print("橙色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(true)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 5 then
	-- 		--print("红色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(true)			
	-- 	end

	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local Text_tupodj_1=ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupodj_1")
		local Text_tupodj_2=ccui.Helper:seekWidgetByName(self.roots[1], "Text_tupodj_2")
		local rankLevelBack = dms.atoi(self.shipMouldBack, ship_mould.initial_rank_level)
		Text_tupodj_1:setString(rankLevelBack - 1)
		Text_tupodj_2:setString(rankLevelBack)
	end	
end

function HeroAdvancedPage:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_advanced.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if fwin:find("UserInformationHeroStorageClass") == nil then
			fwin:open(UserInformationHeroStorage:new(),fwin._ui)
		else
			fwin:close(fwin:find("UserInformationHeroStorageClass"))
			fwin:open(UserInformationHeroStorage:new(),fwin._ui)
		end
	end
	if self.types == "formation" then
		app.load("client.player.UserInformationHeroStorage")
		local seq = fwin:find("UserInformationHeroStorageClass")
		if seq == nil then
			fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		end
		state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
	end
	if fwin:find("UserInformationHeroStorageClass") == nil then
		if fwin:find("HeroFormationChoiceWearClass") ~= nil then
			fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		end
	end
	-- local action = csb.createTimeline("packs/HeroStorage/generals_advanced.csb")
	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- root:runAction(action)
	
	local action = csb.createTimeline("packs/HeroStorage/generals_advanced.csb")
	table.insert(self.actions,action)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		action:play("window_open", false)
	else
		action:play("advanced_ui_open",false)
	end	
	
	root:runAction(action)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		self.keepOutPanel = {
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_sj_qian"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Image_8")
		}
	end
	self.PanelCacheFightArmature = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_tpdh")
	-- self.PanelCacheFightArmature:setVisible(true)
	self.cacheFightArmature = self.PanelCacheFightArmature:getChildByName("ArmatureNode_5")
    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,self.onUpdateDraw,self)
    else
    	self:onUpdateDraw()
    end
	
	local Panel_10 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_10"), nil, {terminal_name = "hero_advanced_page_choose_been_level_up_hero", shipId = self.shipId}, nil, 0)
	local Panel_4 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4"), nil, {terminal_name = "hero_advanced_page_advanced_stone", shipId = self.shipId, touch_scale = true}, nil, 0)
	local Button_1 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"), nil, {terminal_name = "hero_advanced_page_advanced_hero", shipId = self.shipId, isPressedActionEnabled = true}, nil, 0)
end
function HeroAdvancedPage:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local Panel_10 = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_10")
		local Panel_4 = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_4")
		local Panel_4_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_0")
		if Panel_10 ~= nil then
			Panel_10:removeAllChildren(true)
		end
		if Panel_4 ~= nil then
			Panel_4:removeAllChildren(true)
		end
		if Panel_4_0 ~= nil then
			Panel_4_0:removeAllChildren(true)
		end
		cacher.destoryRefPools()
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		if self.types == "formation" then
			local seq = fwin:find("UserInformationHeroStorageClass")
			if seq ~= nil then
				fwin:close(seq)
			end
			
		end
		if fwin:find("UserInformationHeroStorageClass") ~= nil then
			if fwin:find("HeroFormationChoiceWearClass") ~= nil then
				fwin:close(fwin:find("UserInformationHeroStorageClass"))
			end
		end
	end
end
function HeroAdvancedPage:onExit()
	state_machine.remove("hero_advanced_page_Success_data_refresh")
	state_machine.remove("hero_advanced_page_choose_been_level_up_hero")
	state_machine.remove("hero_advanced_page_advanced_hero")
	state_machine.remove("hero_advanced_page_advanced_stone")
	state_machine.remove("hero_advanced_page_check_updata_by_other_page")
	state_machine.remove("hero_advanced_page_set_lock")
end

function HeroAdvancedPage:init(shipId, types)
	self.shipId = shipId
	self.shopmould = fundShipWidthId(self.shipId).ship_template_id
	self.types = types
end