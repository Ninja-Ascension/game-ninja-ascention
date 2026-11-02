-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将列表界面
-- 创建时间:
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroStorage = class("HeroStorageClass", Window)

function HeroStorage:ctor()
    self.super:ctor()
	self.roots = {}
	self.group = {
		_heroListView = nil,
		_heroPatchListView = nil
	}
	
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.ship.ship_seat_cell")
	app.load("client.cells.ship.ship_fragment_seat_cell")
	app.load("client.cells.ship.hero_choose_list_cell")
	app.load("client.packs.hero.HeroListView")
	app.load("client.packs.hero.HeroSellChooseByQuality")
	app.load("client.packs.hero.HeroPatchListView")
	app.load("client.packs.hero.HeroSellTip")
	app.load("client.packs.hero.HeroSell")
	app.load("client.cells.ship.sm_ship_seat_cell")
	app.load("client.cells.ship.sm_ship_dividing_line")
	
    local function init_hero_storage_terminal()
		local hero_storage_manager_terminal = {
            _name = "hero_storage_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if terminal.last_terminal_name ~= params._datas.next_terminal_name then
					-- hide child window
            		for i, v in pairs(instance.group) do
						if v ~= nil then
							v:setVisible(false)
						end
					end
					
                    terminal.last_terminal_name = params._datas.next_terminal_name
            		state_machine.excute(params._datas.next_terminal_name, 0, params)
				end
				
				-- set select ui button is highlighted
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(false)
					terminal.select_button:setTouchEnabled(true)
				end
				terminal.page_name = params._datas.but_image
				if terminal.select_button == nil and params._datas.current_button_name ~= nil then
					terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				else
					terminal.select_button = params
				end
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(true)
					terminal.select_button:setTouchEnabled(false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回home界面
		local hero_storage_return_home_page_terminal = {
            _name = "hero_storage_return_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- close child window
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then
					if fwin:find("ActivityWindowClass") ~= nil then
		        			--fwin:find("ActivityWindowClass"):setVisible(true)
		        		end
					self:playCloseAction()
					-- if self.group._heroListView ~= nil then
					-- 	self.group._heroListView:playCloseAction()
					-- end
					-- if self.group._heroPatchListView ~= nil then
					-- 	self.group._heroPatchListView:playCloseAction()
					-- end
				else
					self:actionEndClose()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--武将
		local hero_storage_show_hero_storage_list_terminal = {
            _name = "hero_storage_show_hero_storage_list",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._heroListView == nil then
					instance.group._heroListView = HeroListView:new()
					fwin:open(instance.group._heroListView, fwin._background)
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					return
				end
				if instance.group._heroPatchListView == nil then
					instance.group._heroPatchListView = HeroPatchListView:new()
					instance.group._heroPatchListView:setVisible(false)
					fwin:open(instance.group._heroPatchListView, fwin._background)
				end
				if instance.group._heroPatchListView ~= nil then
					instance.group._heroListView:setVisible(true)
				end
				if __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_800001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_900001"):setVisible(true)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--武将碎片
		local hero_storage_show_hero_storage_patch_terminal = {
            _name = "hero_storage_show_hero_storage_patch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					return
				end
				if instance.group._heroPatchListView == nil then
					instance.group._heroPatchListView = HeroPatchListView:new()
					fwin:open(instance.group._heroPatchListView, fwin._background)
				end
				if instance.group._heroListView == nil then
					instance.group._heroListView = HeroListView:new()
					instance.group._heroListView:setVisible(false)
					fwin:open(instance.group._heroListView, fwin._background)
				end
				if instance.group._heroPatchListView ~= nil then
					instance.group._heroPatchListView:setVisible(true)
				end
				if __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					then 
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_900001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_800001"):setVisible(true)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_storage_hide_window_terminal = {
            _name = "hero_storage_hide_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_storage_show_window_terminal = {
            _name = "hero_storage_show_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow(params)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_storage_close_all_window_terminal = {
            _name = "hero_storage_close_all_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	for i, v in pairs(instance.group) do
					if v ~= nil then
						fwin:close(v)
					end
				end
				if fwin:find("HeroSellClass") ~= nil then
					fwin:close(fwin:find("HeroSellClass"))
				end
				if fwin:find("UserInformationHeroStorageClass") ~= nil then
					fwin:close(fwin:find("UserInformationHeroStorageClass"))
				end
				fwin:close(instance)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(hero_storage_manager_terminal)
		state_machine.add(hero_storage_return_home_page_terminal)
		state_machine.add(hero_storage_show_hero_storage_list_terminal)
		state_machine.add(hero_storage_show_hero_storage_patch_terminal)
		state_machine.add(hero_storage_hide_window_terminal)
		state_machine.add(hero_storage_show_window_terminal)
		state_machine.add(hero_storage_close_all_window_terminal)
        state_machine.init()
    end
    
    init_hero_storage_terminal()
end

function HeroStorage:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function HeroStorage:onShow(_data)
	for i, v in pairs(self.group) do
		if v == self.group._heroListView then
			v:setVisible(true)
			break
		end
	end
	self:setVisible(true)
	--state_machine.excute("hero_list_view_update_cell_by_sell", 0,_data)
end

function HeroStorage:onEnterTransitionFinish()
    local csbGeneralsList = csb.createNode("packs/HeroStorage/generals_list.csb")
	local root = csbGeneralsList:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsList)

    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_red_alert 
		then
    	Animations_PlayOpenMainUI({self}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN)
    elseif __lua_project_id == __lua_project_legendary_game then
		local action = csb.createTimeline("packs/HeroStorage/generals_list.csb")
	    csbGeneralsList:runAction(action)
	    self.m_action = action
	    self:playIntoAction()
	end
	
	app.load("client.player.UserInformationHeroStorage")
	-- fwin:open(UserInformationHeroStorage:new(), fwin._ui)
	local userInformationHeroStorage = UserInformationHeroStorage:new()
	userInformationHeroStorage._rootWindows = self
	fwin:open(userInformationHeroStorage,fwin._view)
	-- ccui.Helper:seekWidgetByName(root, "ImageView_5073_d"):setVisible(true)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "hero_storage_return_home_page", 	
		next_terminal_name = "",	
		current_button_name = "Button_back",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment"), nil, 
	{
		terminal_name = "hero_storage_manager", 	
		next_terminal_name = "hero_storage_show_hero_storage_list",	
		current_button_name = "Button_equipment",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pieces_equipment"), nil, 
	{
		terminal_name = "hero_storage_manager", 	
		next_terminal_name = "hero_storage_show_hero_storage_patch",	
		current_button_name = "Button_pieces_equipment",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_ship_warehouse_fragment",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_pieces_equipment"),
	_invoke = nil,
	_interval = 0.5,})
end

function HeroStorage:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self:actionEndClose()
	elseif __lua_project_id == __lua_project_legendary_game then
		self.m_action:play("window_over", false)
	end
end

function HeroStorage:playIntoAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_open", false)
		self.m_action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end
	        local str = frame:getEvent()
	        if str == "window_open_over" then
	        	
	        elseif str == "window_close_over" then
	            self:actionEndClose()
	        end
	    end)
	end
end

function HeroStorage:actionEndClose( ... )
	for i, v in pairs(self.group) do
		if v ~= nil then
			fwin:close(v)
		end
	end
	fwin:cleanView(fwin._view) 
	fwin:close(self)


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
end

function HeroStorage:onExit()
	state_machine.remove("hero_storage_manager")
	state_machine.remove("hero_storage_return_home_page")
	state_machine.remove("hero_storage_show_hero_storage_list")
	state_machine.remove("hero_storage_show_hero_storage_patch")
	state_machine.remove("hero_storage_hide_window")
	state_machine.remove("hero_storage_show_window")
	state_machine.remove("hero_storage_close_all_window")
end