-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束失败界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
BattleLose = class("BattleLoseClass", Window)

function BattleLose:ctor()
	self.super:ctor()
	self.roots = {}
	self.isPlunderChallenge = false --标记抢夺失败后,是回去还是离开
	 -- Initialize BattleLose page state machine.
    local function init_terminal()
		-- 点击后返回
		local battle_lose_back_activity_terminal = {
            _name = "battle_lose_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				-- fwin:open(Campaign:new(), fwin._view)
				-- fwin:close(instance)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--跳转到 武将商店招募
		local battle_lose_open_hero_shop_terminal = {
            _name = "battle_lose_open_hero_shop",
            _init = function (terminal) 
                 app.load("client.shop.Shop")
				 app.load("client.home.Menu")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(fwin:find("FightUIClass"))
				-- fwin:close(instance)
				
				-- cacher.removeAllObject(_object)
                cacher.removeAllTextures()
                fwin:reset(nil)
				-- fwin:removeAll()
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					local _shop = Shop:new()
					_shop:init(1)
					fwin:open(_shop, fwin._view)
					fwin:open(Menu:new(), fwin._taskbar)
					state_machine.excute("shop_manager", 0, 
						{
							_datas = {
								terminal_name = "shop_manager", 	
								next_terminal_name = "shop_ship_recruit",
								current_button_name = "Button_tavern", 	
								but_image = "recruit", 		
								terminal_state = 0, 
								shop_type = "zhaomu",
								isPressedActionEnabled = true
							}
						}
					)
				else	
					fwin:open(Shop:new(), fwin._view)
					fwin:open(Menu:new(), fwin._taskbar)
					state_machine.excute("shop_manager", 0, 
						{
							_datas = {
								terminal_name = "shop_manager", 	
								next_terminal_name = "shop_ship_recruit",
								current_button_name = "Button_tavern", 	
								but_image = "recruit", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--跳转到 武将培养
		local battle_lose_open_hero_foster_terminal = {
            _name = "battle_lose_open_hero_foster",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				fwin:close(fwin:find("BattleSceneClass"))
				fwin:close(fwin:find("HeroListViewClass"))
				fwin:close(fwin:find("FightUIClass"))
				fwin:close(instance)
			
				-- fwin:removeAll()
				-- cacher.removeAllObject(_object)
                cacher.removeAllTextures()
                fwin:reset(nil)
				-- fwin:removeAll()
				
				app.load("client.home.Menu")
				fwin:open(Menu:new(), fwin._taskbar)
				-- state_machine.excute("menu_manager", 0, 
					-- {
						-- _datas = {
							-- terminal_name = "menu_manager", 	
							-- next_terminal_name = "menu_show_duplicate", 
							-- current_button_name = "Button_duplicate",
							-- but_image = "Image_duplicate", 		
							-- terminal_state = 0, 
							-- isPressedActionEnabled = true
						-- }
					-- }
				-- )
					app.load("client.packs.hero.HeroStorage")
					fwin:open(HeroStorage:new(), fwin._view) 
					state_machine.excute("hero_storage_manager", 0, 
						{
							_datas = {
								terminal_name = "hero_storage_manager", 	
								next_terminal_name = "hero_storage_show_hero_storage_list",	
								current_button_name = "Button_equipment",  	
								but_image = "", 	
								terminal_state = 0, 
								isPressedActionEnabled = false
							}
						}
					)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--跳转到 装备培养
		local battle_lose_open_equip_foster_terminal = {
            _name = "battle_lose_open_equip_foster",
            _init = function (terminal) 
                app.load("client.packs.equipment.EquipStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("BattleSceneClass"))
				fwin:close(fwin:find("HeroListViewClass"))
				fwin:close(fwin:find("FightUIClass"))
				fwin:close(instance)
			
				-- fwin:removeAll()
				-- cacher.removeAllObject(_object)
                cacher.removeAllTextures()
                fwin:reset(nil)
				-- fwin:removeAll()
				app.load("client.home.Menu")
				fwin:open(Menu:new(), fwin._taskbar)
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
						if fwin:find("HomeClass") == nil then
			            	state_machine.excute("menu_manager", 0, 
								{
									_datas = {
										terminal_name = "menu_manager", 	
										next_terminal_name = "menu_show_home_page", 
										current_button_name = "Button_home",
										but_image = "Image_home", 		
										terminal_state = 0, 
										isPressedActionEnabled = true
									}
								}
							)
		           		end
						state_machine.excute("menu_back_home_page", 0, "") 
						state_machine.excute("menu_clean_page_state", 0, "") 
						app.load("client.packs.prop.PropStorage")
						fwin:open(PropStorage:new(), fwin._background)
						state_machine.excute("prop_storage_manager",0,
							{
							_datas = {
										terminal_name = "prop_storage_manager", 	
										next_terminal_name = "prop_equip_show_list", 			
										current_button_name = "Button_zhuangbei",
										but_image = "",         
										terminal_state = 0, 
										isPressedActionEnabled = false								
									 }
							}
						)
				else
					fwin:open(EquipStorage:new(), fwin._view) 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 充值
		local battle_lose_open_recharge_terminal = {
            _name = "battle_lose_open_recharge",
            _init = function (terminal) 
               app.load("client.shop.recharge.RechargeDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	            	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
	            	or __lua_project_id == __lua_project_l_naruto 
	            	then
		            if funOpenDrawTip(181) == true then
		                return
		            end
		        end
				fwin:open(RechargeDialog:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--跳转到 推荐阵容
		local battle_lose_open_recommend_formation_terminal = {
            _name = "battle_lose_open_recommend_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("BattleSceneClass"))
				fwin:close(fwin:find("FightUIClass"))
				fwin:close(instance)
                fwin:removeAll()
				app.load("client.home.Menu")
				fwin:open(Menu:new(), fwin._taskbar)

				if fwin:find("HomeClass") == nil then
			    	state_machine.excute("menu_manager", 0, 
						{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_home_page", 
								current_button_name = "Button_home",
								but_image = "Image_home", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
			    end
    
				state_machine.excute("menu_back_home_page", 0, "")
				app.load("client.formation.RecommendFormation")
                state_machine.excute("recommend_formation_window_open",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭窗口
		local battle_lose_close_terminal = {
            _name = "battle_lose_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				fwin:close(fwin:find("BattleSceneClass"))
				fwin:close(fwin:find("FightUIClass"))
				fwin:close(fwin:find("FightMapClass"))
				fwin:close(fwin:find("FightClass"))
				fwin:close(fwin:find("BattleRewardClass"))
				state_machine.excute("legion_pk_record_update_list_info", 0, nil)
				state_machine.excute("limit_dekaron_challenge_update_draw", 0, nil)
				state_machine.excute("enemy_strike_fight_update_hp_info", 0, {true})
				state_machine.excute("home_map_update_build", 0, nil)
                state_machine.excute("expedition_update_draw", 0, nil)
                state_machine.excute("main_window_update_userinfo", 0, nil)
                state_machine.excute("guard_battle_show_battle_result", 0, "")
		  --       state_machine.excute("home_button_window_show", 0, 0)
		  --       state_machine.excute("main_window_show", 0, 0)
				-- if zstring.tonumber(_ED._battle_init_type) == 0 then
				-- 	state_machine.excute("pve_manager_window_open", 0, "")
				-- 	state_machine.excute("pve_map_open", 0, {_ED._current_scene_id})
				-- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 维修部队
		local battle_lose_repair_troops_terminal = {
            _name = "battle_lose_repair_troops",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local idnex = params._datas.index
            	if idnex == 1 then
            		state_machine.excute("short_cut_go_to_other_window",0,{8})
            	elseif idnex == 2 then
            		state_machine.excute("short_cut_go_to_other_window",0,{2})
            	elseif idnex == 3 then
            		state_machine.excute("short_cut_go_to_other_window",0,{11})
            	elseif idnex == 4 then
            		state_machine.excute("short_cut_go_to_other_window",0,{3})
            	elseif idnex == 5 then
            		state_machine.excute("short_cut_go_to_other_window",0,{10})
            	elseif idnex == 6 then
            		state_machine.excute("short_cut_go_to_other_window",0,{12})
            	elseif idnex == 7 then
            		state_machine.excute("formation_window_open", 0, {_datas = {form_type = 3,page = 3}})
            	end	
            	state_machine.excute("battle_lose_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(battle_lose_open_recharge_terminal)
		state_machine.add(battle_lose_back_activity_terminal)
		state_machine.add(battle_lose_open_hero_shop_terminal)
		state_machine.add(battle_lose_open_hero_foster_terminal)
		state_machine.add(battle_lose_open_equip_foster_terminal)
		state_machine.add(battle_lose_open_recommend_formation_terminal)
		state_machine.add(battle_lose_close_terminal)
		state_machine.add(battle_lose_repair_troops_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_terminal()
end	

function BattleLose:gotoOriginScene()

		-- 根据当前战斗类型,获取将去哪个界面
	if self._fight_type == _enum_fight_type._fight_type_11 then ----jjc
		fwin:close(self)
		fwin:close(fwin:find("BattleSceneClass"))
		-- fwin:removeAll()
		-- cacher.removeAllObject(_object)
        cacher.removeAllTextures()
        fwin:reset(nil)
		-- fwin:removeAll()
		fwin:open(Menu:new(), fwin._taskbar)
		fwin:open(Arena:new(), fwin._view)	
	elseif self._fight_type == _enum_fight_type._fight_type_10 then ----抢夺
		self.isPlunderChallenge = true
		fwin:close(self)
		fwin:close(fwin:find("BattleSceneClass"))
		-- fwin:removeAll()
		-- cacher.removeAllObject(_object)
        cacher.removeAllTextures()
        fwin:reset(nil)
		-- fwin:removeAll()
		_ED.last_plunders_litter_page.open = 1
		fwin:open(Menu:new(), fwin._taskbar)
		fwin:open(Plunder:new(), fwin._view)
		state_machine.excute("plunder_update_page",0,"")
	elseif self._fight_type == _enum_fight_type._fight_type_106 then
		self.isPlunderChallenge = true
		fwin:close(self)
		fwin:close(fwin:find("BattleSceneClass"))

        cacher.destoryRefPools()
        cacher.cleanSystemCacher()
		cacher.cleanActionTimeline()
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			checkTipBeLeave()
		end
        cacher.removeAllTextures()
        fwin:reset(nil)

		app.load("client.home.Menu")
		fwin:open(Menu:new(), fwin._taskbar)

		app.load("client.captureResource.CaptureResourceMain")
		state_machine.excute("capture_resource_open", 0, nil)
	elseif self._fight_type == _enum_fight_type._fight_type_8 then
		self.isPlunderChallenge = true
		fwin:close(self)
		fwin:close(fwin:find("BattleSceneClass"))

        cacher.destoryRefPools()
        cacher.cleanSystemCacher()
		cacher.cleanActionTimeline()
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			checkTipBeLeave()
		end
        cacher.removeAllTextures()
        fwin:reset(nil)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        	app.load("client.l_digital.union.unionFighting.UnionFightingMain")
        else
			app.load("client.union.unionFighting.UnionFightingMain")
		end
        state_machine.excute("union_fighting_main_open", 0, true)
	elseif self._fight_type == _enum_fight_type._fight_type_107 then -- 排位赛
		fwin:close(self)
		fwin:close(fwin:find("BattleSceneClass"))

        cacher.destoryRefPools()
        cacher.cleanSystemCacher()
		cacher.cleanActionTimeline()
		
        cacher.removeAllTextures()
        fwin:reset(nil)

		app.load("client.home.Menu")
		fwin:open(Menu:new(), fwin._taskbar)
		app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftList")
		fwin:open(AdventureArenaWarcraftList:new(), fwin._view)
	elseif self._fight_type == _enum_fight_type._fight_type_109 then  --宠物副本
		fwin:close(self)
		fwin:close(fwin:find("BattleSceneClass"))
		-- fwin:removeAll()
		-- cacher.removeAllObject(_object)
        cacher.removeAllTextures()
        fwin:reset(nil)
		-- fwin:removeAll()
		fwin:open(Menu:new(), fwin._taskbar)
		app.load("client.campaign.battlefield.BattleField")
        state_machine.excute("battle_field_window_open",0,"")
	else
		-- 默认为 1
		fwin:close(instance)
		fwin:close(fwin:find("BattleSceneClass"))
		-- fwin:removeAll()
		-- cacher.removeAllObject(_object)
        cacher.removeAllTextures()
        fwin:reset(nil)
		-- fwin:removeAll()
		app.load("client.home.Menu")
		fwin:open(Menu:new(), fwin._taskbar)
		
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then
			state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
			{
				_type 	 = LDuplicateWindow._infoDatas._type, 
				_sceneId = LDuplicateWindow._infoDatas._chapter
			})
		else
			
			local is2002 = false
			if __lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim  
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_koone
			then
				if dev_version >= 2002 then
					is2002 = true
				end
			end
				
			
			if true == is2002 then
				if tonumber(_ED.battleData.battle_init_type) == 9 or tonumber(_ED.battleData.battle_init_type) == 10 then
					_ED._current_scene_id = _ED._duplicate_current_scene_id
					_ED._current_seat_index = _ED._duplicate_current_seat_index
					_ED._last_page_type = 2
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
						or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_yugioh 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge
						or __lua_project_id == __lua_project_warship_girl_b 
						then 
						--直接返回到究极副本中
						--没有关掉副本界面,所以不用再重新开启
						state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
					else
						state_machine.excute("menu_manager", 0, 
							{
								_datas = {
									terminal_name = "menu_manager", 	
									next_terminal_name = "menu_show_duplicate", 	
									current_button_name = "Button_duplicate", 	
									but_image = "Image_duplicate", 	
									terminal_state = 0, 
									isPressedActionEnabled = true
								}
							}
						)
						state_machine.unlock("menu_manager_change_to_page", 0, "")
						state_machine.excute("shortcut_open_duplicate_hight_copy_window", 0, nil)
					end
				else
					_ED._current_scene_id = _ED._duplicate_current_scene_id
					_ED._current_seat_index = _ED._duplicate_current_seat_index
					_ED._last_page_type = 1
					local scene_id = _ED._duplicate_current_scene_id --场景id
					if __lua_project_id == __lua_project_warship_girl_a 
						or __lua_project_id == __lua_project_warship_girl_b
 						or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
 						or __lua_project_id == __lua_project_naruto 
 						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh then
						local tentType = dms.string(dms["pve_scene"], scene_id, pve_scene.scene_type)
						if __lua_project_id == __lua_project_warship_girl_b 
							or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
							or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh then 
							--没有关掉副本界面,所以不用再重新开启
							state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
						else
							if tonumber(tentType) == 10 then 
								state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
							else
								state_machine.excute("menu_manager", 0, 
									{
										_datas = {
											terminal_name = "menu_manager", 	
											next_terminal_name = "menu_show_duplicate", 	
											current_button_name = "Button_duplicate", 	
											but_image = "Image_duplicate", 	
											terminal_state = 0, 
											isPressedActionEnabled = true
										}
									}
								)
								
								state_machine.excute("shortcut_open_duplicate_window", 0, nil)
							end
						end
					else
						state_machine.excute("menu_manager", 0, 
							{
								_datas = {
									terminal_name = "menu_manager", 	
									next_terminal_name = "menu_show_duplicate", 	
									current_button_name = "Button_duplicate", 	
									but_image = "Image_duplicate", 	
									terminal_state = 0, 
									isPressedActionEnabled = true
								}
							}
						)
						
						state_machine.excute("shortcut_open_duplicate_window", 0, nil)
					end	
				end

			else
				-- 定位到副本
				_ED._current_scene_id = _ED._duplicate_sceneID
				_ED._current_seat_index = _ED._duplicate_npcIndex
				_ED._last_page_type = 1
				
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_duplicate", 
							current_button_name = "Button_duplicate",
							but_image = "Image_duplicate", 		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
			end
			
		end
		--state_machine.excute("shortcut_open_duplicate_window", 0, nil)
	end
end

function BattleLose:onEnterTransitionFinish()
	local csbvictory = nil 
	if self.rewardList ~= nil and 
		__lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		csbvictory = csb.createNode("battle/combat_failure_2.csb")
	else
		csbvictory = csb.createNode("battle/combat_failure_1.csb")
	end
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	local bTouch = false
	local action = csb.createTimeline("battle/combat_failure_1.csb")
    csbvictory:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:setFrameEventCallFunc(function (frame)
		if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "over" then
            bTouch = true
		end	
	end)
	
	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vic_close"), nil, 
	{
        terminal_name = "battle_lose_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    -- 维修部队
    local Button_repair_troops = ccui.Helper:seekWidgetByName(root, "Button_repair_troops")
	fwin:addTouchEventListener(Button_repair_troops, nil, 
	{
        terminal_name = "battle_lose_repair_troops",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        index = 7,
    }, nil, 1)

	local isHaveRepairTank = false
	for k, v in pairs(_ED.user_ship) do
        if v.captain_type ~= 3 then
            if tonumber(v.lose_ship_count) > 0 then
            	isHaveRepairTank = true
            end
        end
    end
	if isHaveRepairTank == true then
		Button_repair_troops:setBright(true)
		Button_repair_troops:setTouchEnabled(true)
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_battle_reward_repair",
	    _widget = Button_repair_troops,
	    _invoke = nil,
	    _interval = 0.2,})
	else
		Button_repair_troops:setBright(false)
		Button_repair_troops:setTouchEnabled(false)
	end

    for i=1,6 do
	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight_up_"..i), nil, 
		{
	        terminal_name = "battle_lose_repair_troops",
	        terminal_state = 0,
	        touch_scale = true,
	        touch_scale_xy = 0.95, 
	        index = i,
	    }, nil, 1)
    end

	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended and bTouch == true then
			self:gotoOriginScene()
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	if nil ~= Panel_2 then
		Panel_2:addTouchEventListener(backPlotScene)
	end

	--等级
	local levelLabel = ccui.Helper:seekWidgetByName(root, "Text_8")
	if nil ~= levelLabel then
		if verifySupportLanguage(_lua_release_language_en) == true then
			levelLabel:setString(_string_piece_info[6].._ED.user_info.user_grade)
		else
			levelLabel:setString(_ED.user_info.user_grade.._string_piece_info[6])
		end
	end

	--经验
	local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
	if nil ~= LoadingBar_1 then
		local expCount = tonumber(BattleSceneClass._lastExp)/tonumber(BattleSceneClass._lastNeedExp)*100
		LoadingBar_1:setPercent(expCount)
	end
	
	----------------------------------------------------------------------------------
	--0408新增修改:增加失败界面到其他界面的跳转
	----------------------------------------------------------------------------------	
	local hero_shop_return_func_string = nil
	local hero_foster_return_func_string = nil
	local equip_foster_return_func_string = nil
	local recharge_return_func_string = nil
	
	--> print("当前的战斗类型是------------",self._fight_type ," -JJC是-", _enum_fight_type._fight_type_11)
	
	-- 目前这里数据传递的都是0,pve的.待数据处理完毕,再打开类型过滤
	--if self._fight_type == _enum_fight_type._fight_type_11 then
		hero_shop_return_func_string = [[state_machine.excute("battle_lose_open_hero_shop", 0, "click battle_lose_open_hero_shop.'")]]
		hero_foster_return_func_string = [[state_machine.excute("battle_lose_open_hero_foster", 0, "click battle_lose_open_hero_foster.'")]]
		equip_foster_return_func_string = [[state_machine.excute("battle_lose_open_equip_foster", 0, "click battle_lose_open_equip_foster.'")]]
		recharge_return_func_string = [[state_machine.excute("battle_lose_open_recharge", 0, "click battle_lose_open_recharge.'")]]
	--end

	-- 去招募
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {
		func_string = hero_shop_return_func_string,
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	
	-- 去武将培养
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {
		func_string = hero_foster_return_func_string,
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	
	-- 去装备培养
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {
		func_string = equip_foster_return_func_string,
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	
	
	-- 去充值
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, {
		func_string = recharge_return_func_string,
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	--推荐阵容
	local recommendFormationButton = ccui.Helper:seekWidgetByName(root, "Button_zrtj")
	if recommendFormationButton ~= nil then 
		fwin:addTouchEventListener(recommendFormationButton, nil, {
			terminal_name = "battle_lose_open_recommend_formation",
			isPressedActionEnabled = true,
		}, 
		nil, 0)
	end
	-- --- 为当前数值赋奖励	
	local reward = getSceneReward(13) -- 13竞技场
	if nil ~= reward then
		
		local Image_shengwang = ccui.Helper:seekWidgetByName(root, "Image_shengwang")
		if Image_shengwang~= nil then
			Image_shengwang:setVisible(true)
		end
		
		local Text_shengwang = ccui.Helper:seekWidgetByName(root, "Text_shengwang")
		if Text_shengwang~= nil then
			Text_shengwang:setVisible(true)
		end
		
		local Text_shengwang_1 = ccui.Helper:seekWidgetByName(root, "Text_shengwang_1")
		if Text_shengwang_1 ~= nil then
			Text_shengwang_1:setVisible(true)
		end
		
		for r = 1 , reward.show_reward_item_count do
			if tonumber(reward.show_reward_list[r].prop_type) == 8 then -- 经验
				ccui.Helper:seekWidgetByName(root, "Text_7"):setString(reward.show_reward_list[r].item_value)
				
			elseif tonumber(reward.show_reward_list[r].prop_type) == 3 then -- 声望
				if Text_shengwang_1 ~= nil then
					Text_shengwang_1:setString(reward.show_reward_list[r].item_value)
				end
				ccui.Helper:seekWidgetByName(root, "Text_5"):setString(reward.show_reward_list[r].item_value)
			
			
			end
		end
	end
	
	
	
	----------------------------------------------------------------------------------
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local Panel_lose = ccui.Helper:seekWidgetByName(root, "Panel_lose")
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_battle_lose/effect_battle_lose.ExportJson")
		local armature = ccs.Armature:create("effect_battle_lose")
		draw.initArmatureTwo(armature, nil, 1, 0, 1, 0)
		local function changeActionCallback( armatureBack )
			draw.initArmatureTwo(armature, nil, -1, 0, 1, 1)
		end
		armature._invoke = changeActionCallback
		armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		armature:setPosition(cc.p(Panel_lose:getContentSize().width/2,Panel_lose:getContentSize().height/2))
		Panel_lose:addChild(armature)
		--我方消耗
		local Text_me_loss_n = ccui.Helper:seekWidgetByName(root, "Text_me_loss_n")
		Text_me_loss_n:setString(string.format("%.0f", tonumber(_ED.fighting_loss.our_side_percentage)).."%")
		--敌方消耗
		local Text_enemy_loss_n = ccui.Helper:seekWidgetByName(root, "Text_enemy_loss_n")
		-- print("_ED.fighting_loss.the_enemy_percentage==".._ED.fighting_loss.the_enemy_percentage)
		-- if tonumber(_ED.fighting_loss.the_enemy_percentage) ~= 0 then
		Text_enemy_loss_n:setString(string.format("%.0f", tonumber(_ED.fighting_loss.the_enemy_percentage)).."%")--临时数据
		-- else
		-- 	Text_enemy_loss_n:setString("50%")--临时数据
		-- end
        if __lua_project_id == __lua_project_pacific_rim then
            stopBgm()
        end
        checkPlayEffect(47)
        local ListView_rew_icon = ccui.Helper:seekWidgetByName(root, "ListView_rew_icon")
        if ListView_rew_icon ~= nil then
			local listViewSize = ListView_rew_icon:getContentSize()
			local nCoount = 0
			local tWidth = 0
			local iemsMargin = ListView_rew_icon:getItemsMargin()
			if nil ~= self.rewardList then
				local result = {}
			    local result = {}
			    for i,v in pairs(self.rewardList.show_reward_list) do
			        if result[""..v.prop_type] == nil then
			            result[""..v.prop_type] = {}
			        end
			        if result[""..v.prop_type][""..v.prop_item] == nil then 
			            result[""..v.prop_type][""..v.prop_item] = {item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
			        end
			        result[""..v.prop_type][""..v.prop_item].item_value = tonumber(v.item_value) + tonumber(result[""..v.prop_type][""..v.prop_item].item_value)
			    end
			    local info = {}
			    for k,v in pairs(result) do
			        for k1,v1 in pairs(v) do
			        	if tonumber(v1.prop_type) ~= 47 then
			            	table.insert(info, v1)
			            end
			        end
			    end
				for i,v in pairs(info) do
					-- local reward_prop_id = 0
					local cell = nil
					local rewardType = tonumber(v.prop_type)
					local propItem = tonumber(v.prop_item)
					if propItem == -1 then
						if tonumber(resource_prop_id[rewardType]) ~= 3 then
							cell = state_machine.excute("props_icon_create_cell",0,{6, 1, resource_prop_id[rewardType], 1, v.item_value})
						end
					elseif rewardType == 6 then
						cell = state_machine.excute("props_icon_create_cell",0,{6, 1, propItem, 1, v.item_value})
					elseif rewardType == 7 then
						cell = state_machine.excute("props_icon_create_cell",0,{8, 14, propItem, 15, nil, true})
					elseif rewardType == 13 then
						cell = state_machine.excute("props_icon_create_cell",0,{6, 10, propItem, 3, v.item_value, true})
						ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
						ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
					end
					if nil ~= cell then
						ListView_rew_icon:addChild(cell)
						if nCoount > 0 then
							tWidth = tWidth + iemsMargin
						end
						nCoount = nCoount + 1
					end
				end

				tWidth = tWidth + PropsIconCell.__size.width * nCoount
				local viewWidth = listViewSize.width * ListView_rew_icon:getScaleX()
				if viewWidth > tWidth then
					ListView_rew_icon:setPositionX(ListView_rew_icon:getPositionX() + viewWidth / 2 - tWidth / 2+20)
					ListView_rew_icon:setTouchEnabled(false)
				end
			end
		end
	end
	
	
	-- BattleLose._uiLayer = TouchGroup:create()
	-- self:addChild(BattleLose._uiLayer)
	
	-- BattleLose._widget = GUIReader:shareReader():widgetFromJsonFile("interface/combat_failure.json")
	-- BattleLose._uiLayer:addWidget(BattleLose._widget)
	
	-- local action = ActionManager:shareManager():getActionByName("combat_failure.json","Animation0")
	-- action:play()
	-- action:setLoop(false)
	
	-- playEffect(formatMusicFile("effect", 9995))
	
	-- local size = draw.size()
	
	-- local function backPlotScene(sender, eventType)
		-- if eventType == ccs.TouchEventType.ended then
			-- stopBgm()
			-- release()
			-- if _ED.battleData.battle_init_type == 6  then
				-- LuaClasses["MainWindowClass"].closeWindow(LuaClasses["BattleRewardClass"])
				-- LuaClasses["MainWindowClass"].Draw()
				-- require "script/transformers/activity/TrialTower"
				-- if __lua_project_id==__lua_project_all_star then
					-- local mylist = {"9","21","22","23","24"}
					-- local musicIndex = math.random(1,5)
					-- playBgm(formatMusicFile("background", mylist[musicIndex]))
				-- end
				-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["TrialTowerClass"])
			-- else
				-- if LuaClasses["DuplicateClass"]._pageIndex == 2 or  LuaClasses["DuplicateClass"]._pageIndex == 3 then
					-- LuaClasses["MainWindowClass"].Draw()
				-- else
					-- LuaClasses["PlotSceneClass"].Draw()
				-- end
			-- end
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	-- local function weaponStrengthen(sender,eventType)
		-- if eventType ==ccs.TouchEventType.ended then
			-- stopBgm()
			-- release()
			-- LuaClasses["MainWindowClass"].initData("HeroStorageClass")
			-- if __lua_project_id==__lua_project_all_star then
				-- local mylist = {"9","21","22","23","24"}
				-- local musicIndex = math.random(1,5)
				-- playBgm(formatMusicFile("background", mylist[musicIndex]))
			-- end
			-- LuaClasses["MainWindowClass"].Draw()
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	-- local function equipStrengthen(sender,eventType)
		-- if eventType ==ccs.TouchEventType.ended then
			-- local funOpenData = elementAt(funOpenCondition, 3)
			-- if tonumber(_ED.user_info.user_grade) >= funOpenData:atoi(fun_open_condition.level) then
				-- stopBgm()
				-- release()
				-- LuaClasses["MainWindowClass"].initData("EquipmentStorageClass")
				-- if __lua_project_id==__lua_project_all_star then
					-- local mylist = {"9","21","22","23","24"}
					-- local musicIndex = math.random(1,5)
					-- playBgm(formatMusicFile("background", mylist[musicIndex]))
				-- end
				-- LuaClasses["MainWindowClass"].Draw()
			-- else
				-- TipDlg.drawTextDailog(funOpenData:atos(fun_open_condition.tip_info))
			-- end
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	-- local function developGeneral(sender,eventType)
		-- if eventType ==ccs.TouchEventType.ended then
			-- local funOpenData = elementAt(funOpenCondition, 15)
			-- if tonumber(_ED.user_info.user_grade) >= funOpenData:atoi(fun_open_condition.level) then
				-- stopBgm()
				-- release()
				-- LuaClasses["MainWindowClass"].initData("HeroCultivateClass")
				-- if __lua_project_id==__lua_project_all_star then
					-- local mylist = {"9","21","22","23","24"}
					-- local musicIndex = math.random(1,5)
					-- playBgm(formatMusicFile("background", mylist[musicIndex]))
				-- end
				-- LuaClasses["MainWindowClass"].Draw()
			-- else
				-- TipDlg.drawTextDailog(funOpenData:atos(fun_open_condition.tip_info))
			-- end
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	-- local function developPet(sender,eventType)
		-- if eventType ==ccs.TouchEventType.ended then
			-- TipDlg.drawFunctionUnopenedTip()
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	
	-- ----------------------------------------------------------------------------------------
	-- --战斗失败添加充值跳转
	-- local function skipPayButtonCallback(sender,eventType)
		-- if eventType ==ccs.TouchEventType.ended then
			-- stopBgm()
			-- release()
			-- LuaClasses["MainWindowClass"].initData("HomeClass")
			-- LuaClasses["MainWindowClass"].Draw()
			-- require "script/transformers/shop/RechargeWindow"
			-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["RechargeWindowClass"])
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	
	-- local skipPayButton = tolua.cast(BattleLose._uiLayer:getWidgetByName("Button_18619"),"Button")
	-- skipPayButton:addTouchEventListener(skipPayButtonCallback)
	-- -----------------------------------------------------------------------------------------
	
		-- --绘制星星的方法
	-- local function drawCellStar(cell,Maxcount,count)
		-- local startListView = ListView:create()
		-- local starImange = ImageView:create()
		-- startListView:setItemModel(starImange)
		-- for i=1,Maxcount do
			-- if count>=i then
				-- starImange:loadTexture("images/ui/state/o_stars.png")
			-- else
				-- starImange:loadTexture("images/ui/state/c_stars.png")
			-- end
			-- startListView:setDirection(ccs.ListViewDirection.horizontal)
			-- startListView:setSize(CCSizeMake(starImange:getSize().width * Maxcount,starImange:getSize().height))
			-- startListView:setPosition(ccp(-startListView:getSize().width/2+starImange:getSize().width/4,-starImange:getSize().height/2))
			-- startListView:pushBackDefaultItem()	
		-- end
		-- cell:addChild(startListView)
	-- end
	
	-- local confirmButton = tolua.cast(BattleLose._uiLayer:getWidgetByName("Button_1119"),"Button")
	-- confirmButton:addTouchEventListener(backPlotScene)
	-- local weaponStrengthenButton = tolua.cast(BattleLose._uiLayer:getWidgetByName("Button_1178"),"Button")
	-- weaponStrengthenButton:addTouchEventListener(weaponStrengthen)
	-- local equipStrengthenButton = tolua.cast(BattleLose._uiLayer:getWidgetByName("Button_1179"),"Button")
	-- equipStrengthenButton:addTouchEventListener(equipStrengthen)
	-- local developGeneralButton = tolua.cast(BattleLose._uiLayer:getWidgetByName("Button_1180"),"Button")
	-- developGeneralButton:addTouchEventListener(developGeneral)
	
	
	-- local fightLoseStar = BattleLose._uiLayer:getWidgetByName("ImageView_1086")
	
	-- local npcData = elementAt(NPC, tonumber(_ED._scene_npc_id))
	-- local maxStar = npcData:atoi(npc.difficulty_include_count)
	
	-- local npcCurStar = tonumber(_ED.npc_state[npcData:atoi(npc.id)])
	
	-- -- 更改为 用战场初始化信息 中场景类型来判定 绘制星星
	-- -- 6 为试炼 3为宝物经验
	-- local _battle_init_type = _ED.battleData.battle_init_type
	-- if _battle_init_type == 6 or _battle_init_type == 3 then
		-- npcCurStar = 0
		-- maxStar = 3
	-- end
	-- drawCellStar(fightLoseStar, maxStar, npcCurStar)
end	

function BattleLose:init(_fight_type)
	--> print("传进来的战斗类型是------------------",_fight_type)
	self._fight_type = _fight_type
	self.rewardList = getSceneReward(13)
	if tonumber(self._fight_type) == 107 then
		self.rewardList = getSceneReward(57)
	end
end

function BattleLose:onExit()
	if true ~= self.isPlunderChallenge then
		-- 如果不是要回到抢夺去.就清除抢夺的记录数据
		
		app.load("client.utils.scene.SceneCacheData")
		local cacheName = SceneCacheNameEnum.PLUNDER
		SceneCacheData.delete(cacheName)
	end
end
-- END
-- ----------------------------------------------------------------------------------------------------