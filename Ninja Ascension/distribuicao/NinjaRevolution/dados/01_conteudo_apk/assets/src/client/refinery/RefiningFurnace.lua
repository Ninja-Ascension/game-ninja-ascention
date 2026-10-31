-- ----------------------------------------------------------------------------------------------------
-- 说明：回收系统
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
RefiningFurnace = class("RefiningFurnaceClass", Window)

function RefiningFurnace:ctor()
    self.super:ctor()
    
	self.roots = {}
	self.group = {
		_heroResolveView = nil,
		_equipResolveView = nil,
		_heroRebornView = nil,
		_treasureRebornView = nil,
		_magicRebornView = nil,
		_magicResolveView = nil,
		_equipRebornView = nil,  -- 装备重生
		_petResolveView = nil, -- 宠物分解
		_petRebornView = nil -- 宠物重生
	}
	
	app.load("client.refinery.HeroRefineryIcon")
	app.load("client.refinery.EquipRefineryIcon")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.reward.DrawRareReward")
	app.load("client.refinery.ResolveReturnPreview")
    -- Initialize RefiningFurnace page state machine.
    local function init_refining_furnace_terminal()
		local refining_furnace_manager_terminal = {
            _name = "refining_furnace_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance == nil then
        			return
        		end
				if "refining_furnace_show_hero_resolve_view" ~= params._datas.next_terminal_name then
					if nil ~= state_machine.find("hero_resolve_clean") then
						state_machine.excute("hero_resolve_clean", 0, "hero_resolve_clean.")
					end
				end
				if "refining_furnace_show_equip_resolve_view" ~= params._datas.next_terminal_name then
					if nil ~= state_machine.find("equip_resolve_clean") then
						state_machine.excute("equip_resolve_clean", 0, "equip_resolve_clean.")
					end
				end
				if "refining_furnace_show_hero_reborn_view" ~= params._datas.next_terminal_name then
					if nil ~= state_machine.find("hero_reborn_init") then
						state_machine.excute("hero_reborn_init", 0, "hero_reborn_init.")
					end
				end
				if "refining_furnace_show_treasure_reborn_view" ~= params._datas.next_terminal_name then
					if nil ~= state_machine.find("treasure_reborn_init") then
						state_machine.excute("treasure_reborn_init", 0, "treasure_reborn_init.")
					end
				end
				if __lua_project_id == __lua_project_yugioh then 
					if "refining_furnace_show_magic_reborn_view" ~= params._datas.next_terminal_name then
						if nil ~= state_machine.find("magic_card_reborn_init") then
							state_machine.excute("magic_card_reborn_init", 0, "magic_card_reborn_init.")
						end
					end

					if "refining_furnace_show_magic_resolve_view" ~= params._datas.next_terminal_name then
						if nil ~= state_machine.find("magic_card_resolve_clean") then
							state_machine.excute("magic_card_resolve_clean", 0, "magic_card_resolve_clean.")
						end
					end
				else
					if "refining_furnace_show_equip_reborn_view" ~= params._datas.next_terminal_name then
						if nil ~= state_machine.find("equip_reborn_init") then
							state_machine.excute("equip_reborn_init", 0, "equip_reborn_init.")
						end
					end
				end

				if "refining_furnace_show_pet_reborn_view" == params._datas.next_terminal_name then
					if nil ~= state_machine.find("pet_reborn_init") then
						state_machine.excute("pet_reborn_init", 0, "pet_reborn_init.")
					end
				end

				if "refining_furnace_show_pet_resolve_view" == params._datas.next_terminal_name then

					if nil ~= state_machine.find("pet_resolve_init") then
						state_machine.excute("pet_resolve_init", 0, "pet_resolve_init.")
					end
				end
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
		local refining_furnace_return_home_page_terminal = {
            _name = "refining_furnace_return_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- close child window
				for i, v in pairs(instance.group) do
					if v ~= nil then
						fwin:close(v)
					end
				end
				if instance._covers ~= nil then
					fwin:cover(instance, nil, false)
					fwin:close(instance)
					fwin:close(fwin:find("ShopUserInformationClass"))
				else
					fwin:cleanView(fwin._view) 
					fwin:close(instance)
					cacher.destoryRefPools()
					cacher.cleanSystemCacher()
					cacher.removeAllTextures()
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						if fwin:find("HomeClass") == nil then
							cacher.cleanActionTimeline()
							checkTipBeLeave()
							fwin:removeAll()
						end
					end
					state_machine.excute("menu_back_home_page", 0, "") 
				end

				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					fwin:close(fwin:find("UserTopInfoAClass"))		
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--装备分解
        local refining_furnace_show_equip_resolve_view_terminal = {
            _name = "refining_furnace_show_equip_resolve_view",
            _init = function (terminal) 
                app.load("client.refinery.EquipChooseForResolve")
                app.load("client.refinery.EquipResolvePage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				if instance.group._equipResolveView == nil then
					instance.group._equipResolveView = EquipResolvePage:new()
					fwin:open(instance.group._equipResolveView, fwin._background)
				end
				instance.group._equipResolveView:setVisible(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
					__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24001"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23002"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23003"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--武将分解
        local refining_furnace_show_hero_resolve_view_terminal = {
            _name = "refining_furnace_show_hero_resolve_view",
            _init = function (terminal) 
                app.load("client.refinery.HeroChooseForResolve")
                app.load("client.refinery.HeroResolvePage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 				
				if instance.group._heroResolveView == nil then
					instance.group._heroResolveView = HeroResolvePage:new()
					fwin:open(instance.group._heroResolveView, fwin._background)
				end
				instance.group._heroResolveView:setVisible(true)

				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
					__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23001"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23002"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23003"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24001"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将重生
        local refining_furnace_show_hero_reborn_view_terminal = {
            _name = "refining_furnace_show_hero_reborn_view",
            _init = function (terminal) 
                app.load("client.refinery.HeroChooseForReborn")
                app.load("client.refinery.HeroRebornPage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._heroRebornView == nil then
					instance.group._heroRebornView = HeroRebornPage:new()
					fwin:open(instance.group._heroRebornView, fwin._background)
				end
				instance.group._heroRebornView:setVisible(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23002"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23003"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23001"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--宝物重生
        local refining_furnace_show_treasure_reborn_view_terminal = {
            _name = "refining_furnace_show_treasure_reborn_view",
            _init = function (terminal) 
                app.load("client.refinery.TreasureChooseForReborn")
                app.load("client.refinery.TreasureRebornPage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance.group._treasureRebornView == nil then
					instance.group._treasureRebornView = TreasureRebornPage:new()
					fwin:open(instance.group._treasureRebornView, fwin._background)
				end
				instance.group._treasureRebornView:setVisible(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
					__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23003"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23002"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local refining_furnace_hide_window_terminal = {
            _name = "refining_furnace_hide_window",
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
		
		local refining_furnace_show_window_terminal = {
            _name = "refining_furnace_show_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --魔陷卡分解
		local refining_furnace_show_magic_resolve_view_terminal = {
            _name = "refining_furnace_show_magic_resolve_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.refinery.MagicCardResolvePage")
				if instance.group._magicResolveView == nil then
					instance.group._magicResolveView = MagicCardResolvePage:new()
					fwin:open(instance.group._magicResolveView, fwin._background)
				end
				instance.group._magicResolveView:setVisible(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
					__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_yugioh then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23003"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23002"):setVisible(false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --魔陷卡重生
		local refining_furnace_show_magic_reborn_view_terminal = {
            _name = "refining_furnace_show_magic_reborn_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.refinery.MagicCardRebornPage")
				if instance.group._magicRebornView == nil then
					instance.group._magicRebornView = MagicCardRebornPage:new()
					fwin:open(instance.group._magicRebornView, fwin._background)
				end
				instance.group._magicRebornView:setVisible(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
					__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_yugioh then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23003"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23001"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_23002"):setVisible(false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --装备重生
		local refining_furnace_show_equip_reborn_view_terminal = {
            _name = "refining_furnace_show_equip_reborn_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.refinery.EquipRebornPage")
				if instance.group._equipRebornView  == nil then
					instance.group._equipRebornView = EquipRebornPage:new()
					fwin:open(instance.group._equipRebornView, fwin._background)
				end
				instance.group._equipRebornView:setVisible(true)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --战宠解雇
		local refining_furnace_show_pet_resolve_view_terminal = {
            _name = "refining_furnace_show_pet_resolve_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.refinery.PetResolvePage")
            	
				if instance.group._petResolveView  == nil then
					instance.group._petResolveView = PetResolvePage:new()
					fwin:open(instance.group._petResolveView, fwin._background)
				end
				instance.group._petResolveView:setVisible(true)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --战宠重生
		local refining_furnace_show_pet_reborn_view_terminal = {
            _name = "refining_furnace_show_pet_reborn_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.refinery.PetRebornPage")
            	if instance.group._petRebornView   == nil then
					instance.group._petRebornView = PetRebornPage:new()
					fwin:open(instance.group._petRebornView, fwin._background)
				end
				instance.group._petRebornView:setVisible(true)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(refining_furnace_manager_terminal)	
		state_machine.add(refining_furnace_return_home_page_terminal)	
		state_machine.add(refining_furnace_show_equip_resolve_view_terminal)
        state_machine.add(refining_furnace_show_hero_resolve_view_terminal)
        state_machine.add(refining_furnace_show_hero_reborn_view_terminal)
		state_machine.add(refining_furnace_show_treasure_reborn_view_terminal)
		state_machine.add(refining_furnace_hide_window_terminal)
		state_machine.add(refining_furnace_show_window_terminal)
		state_machine.add(refining_furnace_show_equip_reborn_view_terminal)
		if __lua_project_id == __lua_project_yugioh then 
			state_machine.add(refining_furnace_show_magic_resolve_view_terminal)
			state_machine.add(refining_furnace_show_magic_reborn_view_terminal)
		end
		state_machine.add(refining_furnace_show_pet_reborn_view_terminal)
		state_machine.add(refining_furnace_show_pet_resolve_view_terminal)
		state_machine.init()
	end
  
    init_refining_furnace_terminal()
end

function RefiningFurnace:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function RefiningFurnace:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function RefiningFurnace:onEnterTransitionFinish()
	local csbRefinery = csb.createNode("refinery/refinery.csb")
	self:addChild(csbRefinery)
	local root = csbRefinery:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if fwin:find("UserTopInfoAClass") == nil then
			app.load("client.player.UserTopInfoA")
			fwin:open(UserTopInfoA:new(), fwin._view)
		end
	else
		app.load("client.player.UserInformationShop")
		fwin:open(UserInformationShop:new(), fwin._view)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "btn-back"), nil, 
	{
		terminal_name = "refining_furnace_return_home_page", 	
		next_terminal_name = "",	
		current_button_name = "btn-back",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wjfj"), nil, 
	{
		terminal_name = "refining_furnace_manager", 	
		next_terminal_name = "refining_furnace_show_hero_resolve_view",	
		current_button_name = "Button_wjfj",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
		
	}, 
	nil, 0)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_recovery_ship",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_wjfj"),
	_invoke = nil,
	_interval = 0.5,})
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zbfj"), nil, 
	{
		terminal_name = "refining_furnace_manager", 	
		next_terminal_name = "refining_furnace_show_equip_resolve_view",	
		current_button_name = "Button_zbfj",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_recovery_equip",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_zbfj"),
	_invoke = nil,
	_interval = 0.5,})
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wjcs"), nil, 
	{
		terminal_name = "refining_furnace_manager", 	
		next_terminal_name = "refining_furnace_show_hero_reborn_view",	
		current_button_name = "Button_wjcs",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bwcs"), nil, 
	{
		terminal_name = "refining_furnace_manager", 	
		next_terminal_name = "refining_furnace_show_treasure_reborn_view",	
		current_button_name = "Button_bwcs",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)

	if __lua_project_id == __lua_project_yugioh then 
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cardfenjie"), nil, 
		{
			terminal_name = "refining_furnace_manager", 	
			next_terminal_name = "refining_furnace_show_magic_resolve_view",	
			current_button_name = "Button_cardfenjie",  	
			but_image = "", 	
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cardchongsheng"), nil, 
		{
			terminal_name = "refining_furnace_manager", 	
			next_terminal_name = "refining_furnace_show_magic_reborn_view",	
			current_button_name = "Button_cardchongsheng",  	
			but_image = "", 	
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0)
	end
	local Button_zbcs = ccui.Helper:seekWidgetByName(root, "Button_zbcs")
	if Button_zbcs ~= nil then
		--装备重生
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zbcs"), nil, 
		{
			terminal_name = "refining_furnace_manager", 	
			next_terminal_name = "refining_furnace_show_equip_reborn_view",	
			current_button_name = "Button_zbcs",  	
			but_image = "", 	
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0)
	end
	-------宠物
	local Button_petJG = ccui.Helper:seekWidgetByName(root, "Button_cwfj")
	if Button_petJG ~= nil then
	--宠物分解
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cwfj"), nil, 
		{
			terminal_name = "refining_furnace_manager", 	
			next_terminal_name = "refining_furnace_show_pet_resolve_view",	
			current_button_name = "Button_cwfj",  	
			but_image = "", 	
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0) 	
	end

	local Button_petJG = ccui.Helper:seekWidgetByName(root, "Button_cwcs")
	if Button_petJG ~= nil then
	--宠物重生
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cwcs"), nil, 
		{
			terminal_name = "refining_furnace_manager", 	
			next_terminal_name = "refining_furnace_show_pet_reborn_view",	
			current_button_name = "Button_cwcs",  	
			but_image = "", 	
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0) 	
	end
end

function RefiningFurnace:onExit()
	state_machine.remove("refining_furnace_manager")
	state_machine.remove("refining_furnace_return_home_page")
	state_machine.remove("refining_furnace_show_equip_resolve_view")
	state_machine.remove("refining_furnace_show_hero_resolve_view")
	state_machine.remove("refining_furnace_show_hero_reborn_view")
	state_machine.remove("refining_furnace_show_treasure_reborn_view")
	state_machine.remove("refining_furnace_show_pet_resolve_view")
	state_machine.remove("refining_furnace_show_pet_reborn_view")
	state_machine.remove("refining_furnace_show_equip_reborn_view")
	state_machine.remove("refining_furnace_hide_window")
	state_machine.remove("refining_furnace_show_window")
end
