-- ----------------------------------------------------------------------------------------------------
-- 说明：商城
-------------------------------------------------------------------------------------------------------

Shop = class("ShopClass", Window)

local shop_window_open_terminal = {
    _name = "shop_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local shop_page = params.shop_page
        local _shop = Shop:new()
        _shop:init(0, shop_page)
        fwin:open(_shop, fwin._view)
        _shop.close_terminal_name = params.close_terminal_name
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

local shop_window_close_terminal = {
    _name = "shop_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ShopClass"))
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        	state_machine.excute("menu_show_event", 0, "menu_show_event.")
            state_machine.excute("home_show_event", 0, "home_show_event.")
        else
	        fwin:close(fwin:find("UserInformationShopClass"))
	    end
        fwin:close(fwin:find("ShopPropBuyListViewClass"))
        fwin:close(fwin:find("SmShopTabClass"))
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(shop_window_open_terminal)
state_machine.add(shop_window_close_terminal)
state_machine.init()

function Shop:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.group = {
		_recruit = nil,
		_prop = nil,
		_vip = nil,
		_recharge = nil
	}
	
	self.currentSelectPanel = 0

	self.runState = 0
	self.close_terminal_name = nil
	
	-- Initialize shop page state machine.
    local function init_shop_terminal()
	
		--界面管理器
		local shop_manager_terminal = {
            _name = "shop_manager",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
					-- hide shop child window
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
		
		--招募
		local shop_ship_recruit_terminal = {
            _name = "shop_ship_recruit",
            _init = function (terminal) 
                app.load("client.shop.recruit.HeroRecruitListView")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.currentSelectPanel = 1
				if instance.group._recruit == nil then
					instance.group._recruit = HeroRecruitListView:new()
					if __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge
						then
						instance.group._recruit:onInit(ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_di"))
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ui"):addChild(instance.group._recruit)
						table.insert(instance.roots, instance.group._recruit.root)
					else
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							if __lua_project_id == __lua_project_l_naruto then
								fwin:open(instance.group._recruit, fwin._view)
							else
								instance.group._recruit:onInit(ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_chouka"))
								ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_chouka"):addChild(instance.group._recruit)
								table.insert(instance.roots, instance.group._recruit.root)
							end
						else
							fwin:open(instance.group._recruit, fwin._view)
						end
					end
				end
				if __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then
					state_machine.excute("shop_change_ui_layer_state", 0, true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_di"):removeAllChildren(true)
					if instance.group._prop ~= nil then
						instance.group._prop:setVisible(false)
					end
					if instance.group._vip ~= nil then
						instance.group._vip:setVisible(false)
					end
					state_machine.excute("hero_recruit_list_action_show", 0, nil)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_0"):setVisible(false)
				end
				instance.group._recruit:setVisible(true)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
					-- state_machine.lock("notification_center_update")
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20002"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20002_0"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20001"):setVisible(true)
					
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_tavern"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_packs"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_props"):setHighlighted(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
		--道具购买
		local shop_prop_buy_terminal = {
            _name = "shop_prop_buy",
            _init = function (terminal) 
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		app.load("client.l_digital.shop.SmShopPropBuyListView")
            	else
                	app.load("client.shop.ShopPropBuyListView")
                end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.currentSelectPanel = 2
				if instance.group._prop == nil then
					instance.group._prop = ShopPropBuyListView:new()
					if __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge
						then
						instance.group._prop:onInit()
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ui"):addChild(instance.group._prop)
						table.insert(instance.roots, instance.group._prop.root)
					else
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
							if zstring.tonumber(self.pages) > 0 then
								instance.group._prop:init(zstring.tonumber(self.pages))
							end
						end
						
						fwin:open(instance.group._prop, fwin._view)
					end
				end
				if __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then
					state_machine.excute("shop_change_ui_layer_state", 0, true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_di"):removeAllChildren(true)
					if instance.group._recruit ~= nil then
						instance.group._recruit:setVisible(false)
					end
					if instance.group._vip ~= nil then
						instance.group._vip:setVisible(false)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_0"):setVisible(true)
				end
				instance.group._prop:setVisible(true)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20002_0"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20002"):setVisible(true)
					
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_tavern"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_packs"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_props"):setHighlighted(true)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--VIP礼包购买
		local shop_vip_buy_terminal = {
            _name = "shop_vip_buy",
            _init = function (terminal) 
                app.load("client.shop.ShopVIPPropBuyListView")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.currentSelectPanel = 3
				if instance.group._vip == nil then
					instance.group._vip = ShopVIPPropBuyListView:new()
					if __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge
						then
						instance.group._vip:onInit()
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ui"):addChild(instance.group._vip)
						table.insert(instance.roots, instance.group._vip.root)
					else
						fwin:open(instance.group._vip, fwin._view)
					end
				end
				if __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then
					state_machine.excute("shop_change_ui_layer_state", 0, true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_di"):removeAllChildren(true)
					if instance.group._recruit ~= nil then
						instance.group._recruit:setVisible(false)
					end
					if instance.group._prop ~= nil then
						instance.group._prop:setVisible(false)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_0"):setVisible(true)
				end
				instance.group._vip:setVisible(true)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20002"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20002_0"):setVisible(true)
					
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_tavern"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_packs"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_props"):setHighlighted(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--充值界面
		local shop_recharge_terminal = {
            _name = "shop_recharge",
            _init = function (terminal) 
                app.load("client.shop.recharge.RechargeDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- for i, v in pairs(instance.group) do
					-- if v ~= nil then
						-- v:setVisible(false)
					-- end
				-- end
				--> print("shop_recharge_terminal shop_recharge_terminal shop_recharge_terminal")
				-- if instance.group._recharge == nil then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	            	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
	            	or __lua_project_id == __lua_project_l_naruto 
	            	then
		            if funOpenDrawTip(181) == true then
		                return
		            end
		        end
					local rd = RechargeDialog:new()
					rd:init(instance.currentSelectPanel)
					fwin:open(rd, fwin._windows)
				-- end
				-- instance.group._recharge:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回home界面
		local shop_return_home_close_terminal = {
            _name = "shop_return_home_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if fwin:find("HeroIconListViewClass") ~= nil then
					fwin:find("HeroIconListViewClass"):setVisible(true)
				end

            	if nil ~= instance.close_terminal_name then
            		state_machine.excute(instance.close_terminal_name, 0, 0)
            		return false
            	end
            	local pages = 0
	            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if zstring.tonumber(instance.pages) == 5 then
						if zstring.tonumber(instance.pages) == 5 then
							pages = 5
						end
					elseif zstring.tonumber(instance.pages) == 3 then
						state_machine.excute("shop_window_close",0,"shop_window_close.")
						return
					end
				end

				if pages ~= 5 then
					fwin:cleanView(fwin._view) 
					fwin:close(instance)
				end

				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					state_machine.unlock("notification_center_update")
					--武将强化推送
					state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
					state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
			       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
			       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
			       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
			   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_accumlate_rechargeable")
			   		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_seven_days_activity")
					state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_all_target")
					state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_page_push")
					state_machine.excute("notification_center_update", 0, "push_notification_new_everydays_recharge")
					state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_accumlate_consumption")
					state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
					state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_daily_page_button")
			       	state_machine.excute("notification_center_update", 0, "push_notification_center_new_shop")
					state_machine.excute("notification_center_update", 0, "push_notification_center_sm_chest_store")
					state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit")
					state_machine.excute("notification_center_update", 0, "push_notification_center_shop_small_building")
					state_machine.excute("notification_center_update", 0, "push_notification_center_shop_large_building")
			    end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					if fwin:find("RechargeDialogClass") ~= nil then
						fwin:find("RechargeDialogClass"):setVisible(true)
					end
				end

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

	            if pages ~= 5 then
					state_machine.excute("menu_back_home_page", 0, "") 
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						state_machine.excute("menu_clean_page_state", 0, "") 
					end
				end

				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					if pages == 5 then
      					state_machine.excute("shop_window_close", 0, "shop_window_close")
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local shop_change_ui_layer_state_terminal = {
            _name = "shop_change_ui_layer_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ui"):setVisible(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local shop_insert_heroRecruitGeneral_root_terminal = {
            _name = "shop_insert_heroRecruitGeneral_root",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	table.insert(instance.roots, params)
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(shop_manager_terminal)
		state_machine.add(shop_ship_recruit_terminal)
		state_machine.add(shop_prop_buy_terminal)
		state_machine.add(shop_vip_buy_terminal)
		state_machine.add(shop_recharge_terminal)
		state_machine.add(shop_return_home_close_terminal)
		state_machine.add(shop_change_ui_layer_state_terminal)
		state_machine.add(shop_insert_heroRecruitGeneral_root_terminal)
        state_machine.init()
    end
    
    -- call func init shop state machine.
    init_shop_terminal()
end

function Shop:onUpdate(dt) 
    if self.runState == 1 then
        state_machine.unlock("menu_manager_change_to_page", 0, "")
        self.runState = self.runState + 1
    end
    if self.runState == 0 then
        self.runState = self.runState + 1
    end
end

function Shop:onEnterTransitionFinish()
	local csbShop_1 = csb.createNode("shop/shop_1.csb")
	local root = csbShop_1:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbShop_1)
	app.load("client.player.UserInformationShop") 					--顶部用户信息
	local userinfo = UserInformationShop:new()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		userinfo._rootWindows = self
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		fwin:open(userinfo,fwin._windows)
	else
		fwin:open(userinfo,fwin._ui)
	end

    if fwin:find("HeroIconListViewClass") ~= nil then
		fwin:find("HeroIconListViewClass"):setVisible(false)
	end

	-- 
	local setPressedActionEnabled = true
	if __lua_project_id == __lua_project_rouge then
		setPressedActionEnabled = false
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if self.currentSelectPanel == 1 then
			ccui.Helper:seekWidgetByName(root, "Image_shop"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_chouka"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root, "Image_shop"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_chouka"):setVisible(false)
		end
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_red_alert 
		then
		setPressedActionEnabled = false
		-------招募界面的一些按钮屏蔽
		local chongzhi1 = ccui.Helper:seekWidgetByName(root, "Button_recharge")
		local chongzhi2 = ccui.Helper:seekWidgetByName(root, "Button_recharge_copy")
		if self.currentSelectPanel == 1 then
			local Button_props = ccui.Helper:seekWidgetByName(root, "Button_props")
			local Button_packs = ccui.Helper:seekWidgetByName(root, "Button_packs")
			local Image_but_bg = ccui.Helper:seekWidgetByName(root, "Image_but_bg")
			Button_props:setVisible(false)
			Button_packs:setVisible(false)
			Image_but_bg:setVisible(false)
			chongzhi1:setVisible(true)
			chongzhi2:setVisible(false)
		else
			chongzhi1:setVisible(false)
			chongzhi2:setVisible(true)
		end
	elseif __lua_project_id == __lua_project_yugioh then 
		local Panel_shop = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
		Panel_shop:removeAllChildren(true)
		local animation1 = "0animation_standby"
		local jsonFile1 = "sprite/spirte_battle_card_101.json"
		local atlasFile1 = "sprite/spirte_battle_card_101.atlas"
		if cc.FileUtils:getInstance():isFileExist(jsonFile1) == true then
			local animate1= sp.spine(jsonFile1, atlasFile1, 1, 0, animation1, true, nil)
			Panel_shop:addChild(animate1)
		end
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tavern"), 	nil, 
	{
		terminal_name = "shop_manager", 	
		next_terminal_name = "shop_ship_recruit",
		current_button_name = "Button_tavern", 	
		but_image = "recruit", 		
		terminal_state = 0, 
		isPressedActionEnabled = setPressedActionEnabled
	}, 
	nil, 0)
	
	-- 
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_props"), 		nil, 
	{
		terminal_name = "shop_manager", 	
		next_terminal_name = "shop_prop_buy", 	
		current_button_name = "Button_props", 	
		but_image = "prop", 	
		terminal_state = 0, 
		isPressedActionEnabled = setPressedActionEnabled
	}, 
	nil, 0)
	
	--
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_packs"), 		nil, 
	{
		terminal_name = "shop_manager", 	
		next_terminal_name = "shop_vip_buy",	
		current_button_name = "Button_packs",  	
		but_image = "vip", 	
		terminal_state = 0, 
		isPressedActionEnabled = setPressedActionEnabled
	}, 
	nil, 0)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_vip_package",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_packs"),
	_invoke = nil,
	_interval = 1,})
	
	--礼包
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge"), 	nil, 
	{
		terminal_name = "shop_recharge", 	
		-- next_terminal_name = "shop_recharge", 	
		-- current_button_name = "Button_recharge",		
		-- but_image = "recharge",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		---返回主页
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_copy"), 	nil, 
		{
			terminal_name = "shop_recharge", 	
			-- next_terminal_name = "shop_recharge", 	
			-- current_button_name = "Button_recharge",		
			-- but_image = "recharge",	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)

		local return_home = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop_back"), nil, 
		{
			terminal_name = "shop_return_home_close", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil, 2)
	end
end
function Shop:init(shop_type,pages)
	self.currentSelectPanel = shop_type
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self.pages = pages or nil
	end
end
function Shop:onExit()
	state_machine.remove("shop_manager")
	state_machine.remove("shop_ship_recruit")
	state_machine.remove("shop_prop_buy")
	state_machine.remove("shop_vip_buy")
	state_machine.remove("shop_recharge")
	state_machine.remove("shop_change_ui_layer_state")
	state_machine.remove("shop_insert_heroRecruitGeneral_root")
	
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

function Shop:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end