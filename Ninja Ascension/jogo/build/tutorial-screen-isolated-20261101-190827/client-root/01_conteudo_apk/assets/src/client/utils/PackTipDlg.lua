-- ----------------------------------------------------------------------------------------------------
-- 说明：包裹满了的提示
-- 创建时间	2015/5/7
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PackTipDlg = class("PackTipDlgClass", Window)
    
function PackTipDlg:ctor()
    self.super:ctor()
	self.roots = {}
	self.action = nil
	self.types = nil
    -- Initialize ConfirmDlg state machine.
    local function init_pack_tip_dlg_terminal()
		-- 返回
        local pack_tip_dlg_to_close_terminal = {
            _name = "pack_tip_dlg_to_close",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.action:play("window_close", false)
				instance.action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "window_close_over" then
						fwin:close(instance)
					end
				end)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 武将出售
        local pack_tip_dlg_to_hero_sell_terminal = {
            _name = "pack_tip_dlg_to_hero_sell",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("pack_tip_dlg_to_close", 0,"") 
				state_machine.excute("menu_clean_page_state", 0,"") 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					if fwin:find("HeroStorageClass") ~= nil then
						fwin:close(fwin:find("HeroStorageClass"))
					end
				end				
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
				fwin:open(HeroSell:new(), fwin._ui)
				if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					state_machine.excute("menu_show_event", 0, "")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 装备出售
        local pack_tip_dlg_to_equip_sell_terminal = {
            _name = "pack_tip_dlg_to_equip_sell",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
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
				state_machine.excute("pack_tip_dlg_to_close", 0,"") 
				state_machine.excute("menu_clean_page_state", 0,"")
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
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
				fwin:open(EquipSell:new(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 装备强化
        local pack_tip_dlg_to_equip_level_up_terminal = {
            _name = "pack_tip_dlg_to_equip_level_up",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("pack_tip_dlg_to_close", 0,"") 
				state_machine.excute("menu_clean_page_state", 0,"") 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
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
					state_machine.excute("equip_expansion_action_start", 0, 
						{
							_datas = {
								terminal_name = "equip_expansion_action_start", 
								next_terminal_name = "general", 
								but_image = "Image_home", 	
								terminal_state = 0, 
								cell = self,
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
		
		-- 武将升级
        local pack_tip_dlg_to_hero_level_up_terminal = {
            _name = "pack_tip_dlg_to_hero_level_up",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            		or __lua_project_id == __lua_project_red_alert 
            		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
            		then
            		if fwin:find("ActivityWindowClass") ~= nil then
            			state_machine.excute("activity_window_hide",0,"")
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
				state_machine.excute("pack_tip_dlg_to_close", 0,"") 
				state_machine.excute("menu_clean_page_state", 0,"") 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					if fwin:find("HeroStorageClass") ~= nil then
						fwin:close(fwin:find("HeroStorageClass"))
					end
				end				
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
				state_machine.excute("ship_expansion_action_start", 0, 
					{
						_datas = {
							terminal_name = "ship_expansion_action_start", 
							next_terminal_name = "general", 
							but_image = "Image_home", 	
							terminal_state = 0, 
							cell = self,
							isPressedActionEnabled = true
						}
					}
				)
				if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					state_machine.excute("menu_show_event", 0, "")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--装备分解
		local pack_tip_dlg_to_equip_refinery_terminal = {
            _name = "pack_tip_dlg_to_equip_refinery",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                	or __lua_project_id == __lua_project_red_alert 
                	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                	then
                    local isopen,tip = getFunopenLevelAndTip(10)
                    if isopen == true then
						state_machine.excute("pack_tip_dlg_to_close", 0,"") 
						state_machine.excute("menu_clean_page_state", 0,"") 
						fwin:open(RefiningFurnace:new(), fwin._view)
						state_machine.excute("refining_furnace_manager", 0, 
							{
								_datas = {
									terminal_name = "refining_furnace_manager",     
									next_terminal_name = "refining_furnace_show_equip_resolve_view", 
									current_button_name = "Button_zbfj",    
									but_image = "",     
									terminal_state = 0,
									isPressedActionEnabled = false
								}
							}
						)
						state_machine.excute("activity_window_hide",0,"")
                    else
                        TipDlg.drawTextDailog(tip)
                    end
                else            
					state_machine.excute("pack_tip_dlg_to_close", 0,"") 
					state_machine.excute("menu_clean_page_state", 0,"") 
					fwin:open(RefiningFurnace:new(), fwin._view)
					state_machine.excute("refining_furnace_manager", 0, 
						{
							_datas = {
								terminal_name = "refining_furnace_manager",     
								next_terminal_name = "refining_furnace_show_equip_resolve_view", 
								current_button_name = "Button_zbfj",    
								but_image = "",     
								terminal_state = 0,
								isPressedActionEnabled = false
							}
						}
					)
					state_machine.excute("activity_window_hide",0,"")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pack_tip_dlg_to_close_terminal)
        state_machine.add(pack_tip_dlg_to_hero_sell_terminal)
        state_machine.add(pack_tip_dlg_to_equip_sell_terminal)
        state_machine.add(pack_tip_dlg_to_equip_level_up_terminal)
        state_machine.add(pack_tip_dlg_to_hero_level_up_terminal)
		state_machine.add(pack_tip_dlg_to_equip_refinery_terminal)
        state_machine.init()
    end
    
    -- call func init ConfirmDlg state machine.
    init_pack_tip_dlg_terminal()
end

function PackTipDlg:onUpdateDraw()
	local root = self.roots[1]
	local heroPanel = ccui.Helper:seekWidgetByName(root, "Panel_12")
	local equipPanel = ccui.Helper:seekWidgetByName(root, "Panel_12_0")
	local tip = ccui.Helper:seekWidgetByName(root, "Text_203")
	
	
	if self.types == 4 then
		local tipStr = _pack_fill_tip.heroPackTip
		heroPanel:setVisible(true)
		tip:setString(tipStr)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then
			equipPanel:setVisible(false)
		end
	elseif self.types == 2 then
		local tipStr = _pack_fill_tip.equipPackTip
		equipPanel:setVisible(true)
		tip:setString(tipStr)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then
			heroPanel:setVisible(false)
		end
	end
	
end

function PackTipDlg:onEnterTransitionFinish()
    local csbPackTipDlg = csb.createNode("utils/prompt_hero.csb")
    self:addChild(csbPackTipDlg)
	
	local root = csbPackTipDlg:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("utils/prompt_hero.csb")
    csbPackTipDlg:runAction(action)
	action:play("window_open", false)
	self.action = action
	
	self:onUpdateDraw()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_287"), nil, 
	{
		terminal_name = "pack_tip_dlg_to_close", 
		terminal_state = 0,
	}, nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_013"), nil, 
	{
		terminal_name = "pack_tip_dlg_to_hero_sell", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_013_6"), nil, 
	{
		terminal_name = "pack_tip_dlg_to_equip_sell", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_013_0_8"), nil, 
		{
			terminal_name = "pack_tip_dlg_to_equip_refinery", 
			terminal_state = 0,
			isPressedActionEnabled = true
		}, nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_013_0_8"), nil, 
		{
			terminal_name = "pack_tip_dlg_to_equip_level_up", 
			terminal_state = 0,
			isPressedActionEnabled = true
		}, nil, 0)
	end	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_013_0"), nil, 
	{
		terminal_name = "pack_tip_dlg_to_hero_level_up", 
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 0)
	
end

function PackTipDlg:init(types)
	self.types = types
end

function PackTipDlg:onExit()
	state_machine.remove("pack_tip_dlg_to_close")
	state_machine.remove("pack_tip_dlg_to_hero_sell")
	state_machine.remove("pack_tip_dlg_to_equip_sell")
	state_machine.remove("pack_tip_dlg_to_equip_level_up")
	state_machine.remove("pack_tip_dlg_to_hero_level_up")
	state_machine.remove("pack_tip_dlg_to_equip_refinery")
end