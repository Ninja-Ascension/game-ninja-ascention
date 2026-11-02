-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双战斗结束失败界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TrialTowerBattleLose = class("TrialTowerBattleLoseClass", Window)

function TrialTowerBattleLose:ctor()
	self.super:ctor()
	self.roots = {}
	 -- Initialize TrialTowerBattleLose page state machine.
    local function init_terminal()
		-- 点击后返回
		local trial_tower_battle_lose_back_activity_terminal = {
            _name = "trial_tower_battle_lose_back_activity",
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
		local trial_tower_battle_lose_open_hero_shop_terminal = {
            _name = "trial_tower_battle_lose_open_hero_shop",
            _init = function (terminal) 
                 app.load("client.shop.Shop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(fwin:find("FightUIClass"))
				fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					local _shop = Shop:new()
					_shop:init(1)
					fwin:open(_shop, fwin._view)
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
					if fwin:find("MenuClass") == nil then
						fwin:open(Menu:new(), fwin._taskbar)
					end
				else
					fwin:open(Shop:new(), fwin._view)
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
					
					if fwin:find("MenuClass") == nil then
						fwin:open(Menu:new(), fwin._taskbar)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--跳转到 武将培养
		local trial_tower_battle_lose_open_hero_foster_terminal = {
            _name = "trial_tower_battle_lose_open_hero_foster",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				fwin:close(fwin:find("BattleSceneClass"))
				fwin:close(fwin:find("HeroListViewClass"))
				fwin:close(fwin:find("FightUIClass"))
				fwin:close(instance)
			
				fwin:removeAll()
				
				app.load("client.home.Menu")
				fwin:open(Menu:new(), fwin._taskbar)

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
		local trial_tower_battle_lose_open_equip_foster_terminal = {
            _name = "trial_tower_battle_lose_open_equip_foster",
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
			
				fwin:removeAll()
				app.load("client.home.Menu")
				fwin:open(Menu:new(), fwin._taskbar)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
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
		local trial_tower_battle_lose_open_recharge_terminal = {
            _name = "trial_tower_battle_lose_open_recharge",
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

		--推荐阵容
		local trial_tower_battle_lose_open_recommend_formation_terminal = {
            _name = "trial_tower_battle_lose_open_recommend_formation",
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
		
		state_machine.add(trial_tower_battle_lose_open_recharge_terminal)
		state_machine.add(trial_tower_battle_lose_back_activity_terminal)
		state_machine.add(trial_tower_battle_lose_open_hero_shop_terminal)
		state_machine.add(trial_tower_battle_lose_open_hero_foster_terminal)
		state_machine.add(trial_tower_battle_lose_open_equip_foster_terminal)
		state_machine.add(trial_tower_battle_lose_open_recommend_formation_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_terminal()
end	

function TrialTowerBattleLose:gotoOriginScene()
	fwin:close(self)
	fwin:close(fwin:find("BattleSceneClass"))
	fwin:removeAll()
	fwin:open(Menu:new(), fwin._taskbar)

	-- state_machine.excute("menu_manager", 0, 
			-- {
				-- _datas = {
					-- terminal_name = "menu_manager", 	
					-- next_terminal_name = "menu_show_campaign", 
					-- current_button_name = "Button_activity",
					-- but_image = "Image_activity", 		
					-- terminal_state = 0, 
					-- isPressedActionEnabled = true
				-- }
			-- }
		-- )
	local trialTower = TrialTower:new()
	trialTower:init(4)
	fwin:open(trialTower, fwin._view)	
	
	-- terminal_name = "menu_manager", 	
		-- next_terminal_name = "menu_show_campaign", 		
		-- current_button_name = "Button_activity", 		
		-- but_image = "Image_activity",	
	
end

function TrialTowerBattleLose:onEnterTransitionFinish()
	--run\res\cocostudio\battle\combat_failure_2.csb
	local csbvictory = csb.createNode("battle/combat_failure_2.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	
	local bTouch = false
	local action = csb.createTimeline("battle/combat_failure_2.csb")
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
	
	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended and bTouch == true then
			self:gotoOriginScene()
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_2"):addTouchEventListener(backPlotScene)
	
	
	----------------------------------------------------------------------------------
	--0408新增修改:增加失败界面到其他界面的跳转
	----------------------------------------------------------------------------------	
	local hero_shop_return_func_string = nil
	local hero_foster_return_func_string = nil
	local equip_foster_return_func_string = nil
	local recharge_return_func_string = nil

	-- 目前这里数据传递的都是0,pve的.待数据处理完毕,再打开类型过滤
	--if self._fight_type == _enum_fight_type._fight_type_11 then
		hero_shop_return_func_string = [[state_machine.excute("trial_tower_battle_lose_open_hero_shop", 0, "click trial_tower_battle_lose_open_hero_shop.'")]]
		hero_foster_return_func_string = [[state_machine.excute("trial_tower_battle_lose_open_hero_foster", 0, "click trial_tower_battle_lose_open_hero_foster.'")]]
		equip_foster_return_func_string = [[state_machine.excute("trial_tower_battle_lose_open_equip_foster", 0, "click trial_tower_battle_lose_open_equip_foster.'")]]
		recharge_return_func_string = [[state_machine.excute("trial_tower_battle_lose_open_recharge", 0, "click trial_tower_battle_lose_open_recharge.'")]]
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
			terminal_name = "trial_tower_battle_lose_open_recommend_formation",
			isPressedActionEnabled = true,
		}, 
		nil, 0)
	end
	--找过关条件
	local layerCount = tonumber(_ED.three_kingdoms_view.current_floor)			-- 第几层
	local currentIndex = tonumber(_ED.three_kingdoms_view.current_npc_pos)		--当前挑战位置 --打败之后这就成-1了--所以得取旧数据
	local npcList = dms.string(dms["three_kingdoms_config"], tonumber(layerCount), three_kingdoms_config.npc_id)
	local datas = zstring.split(npcList , ",")  	
	local npcMID = tonumber(datas[currentIndex+1])
	
	
	local achievementIndex = dms.string(dms["npc"], npcMID, npc.get_star_condition)	--通关条件-从npc取找成就模板
	local GuanqiaCondition = dms.string(dms["achievement_mould"], achievementIndex, achievement_mould.achievement_describe)
	ccui.Helper:seekWidgetByName(root, "Text_4_0"):setString(tipStringInfo_trialTower[15]..GuanqiaCondition)
end	

function TrialTowerBattleLose:init(_fight_type)
	--> print("传进来的战斗类型是------------------",_fight_type)
	self._fight_type = _fight_type
end

function TrialTowerBattleLose:onExit()
	
end
-- END
-- ----------------------------------------------------------------------------------------------------