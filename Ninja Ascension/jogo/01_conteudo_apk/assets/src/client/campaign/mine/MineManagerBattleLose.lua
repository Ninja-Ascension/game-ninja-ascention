-- ----------------------------------------------------------------------------------------------------
-- 说明：领地战斗结束失败界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerBattleLose = class("MineManagerBattleLoseClass", Window)

function MineManagerBattleLose:ctor()
	self.super:ctor()
	self.roots = {}
	 -- Initialize MineManagerBattleLose page state machine.
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
		
		state_machine.add(battle_lose_back_activity_terminal)
		state_machine.add(battle_lose_open_hero_shop_terminal)
		state_machine.add(battle_lose_open_hero_foster_terminal)
		state_machine.add(battle_lose_open_equip_foster_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_terminal()
end	

function MineManagerBattleLose:gotoOriginScene()
	fwin:close(self)
	fwin:close(fwin:find("BattleSceneClass"))
	fwin:removeAll()
	fwin:open(Menu:new(), fwin._taskbar)
	local view = MineManager:new()
	view:init(nil)
	fwin:open(view, fwin._view)	

end

function MineManagerBattleLose:onEnterTransitionFinish()

	local csbvictory = csb.createNode("campaign/MineManager/attack_combat_failure.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	
	local bTouch = false
	local action = csb.createTimeline("campaign/MineManager/attack_combat_failure.csb")
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
	ccui.Helper:seekWidgetByName(root, "Panel_211"):addTouchEventListener(backPlotScene)
	
	
	----------------------------------------------------------------------------------
	--0408新增修改:增加失败界面到其他界面的跳转
	----------------------------------------------------------------------------------	
	local hero_shop_return_func_string = nil
	local hero_foster_return_func_string = nil
	local equip_foster_return_func_string = nil

	hero_shop_return_func_string = [[state_machine.excute("battle_lose_open_hero_shop", 0, "click battle_lose_open_hero_shop.'")]]
	hero_foster_return_func_string = [[state_machine.excute("battle_lose_open_hero_foster", 0, "click battle_lose_open_hero_foster.'")]]
	equip_foster_return_func_string = [[state_machine.excute("battle_lose_open_equip_foster", 0, "click battle_lose_open_equip_foster.'")]]
	
	-- 去招募
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_2"), nil, {
		func_string = hero_shop_return_func_string,
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	
	-- 去武将培养
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2_4"), nil, {
		func_string = hero_foster_return_func_string,
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	
	-- 去装备培养
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), nil, {
		func_string = equip_foster_return_func_string,
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	
	
end	

function MineManagerBattleLose:init(_fight_type)
	--> print("传进来的战斗类型是------------------",_fight_type)
	self._fight_type = _fight_type
end

function MineManagerBattleLose:onExit()
	
end
-- END
-- ----------------------------------------------------------------------------------------------------