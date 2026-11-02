-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将各种强化界面
-------------------------------------------------------------------------------------------------------
HeroDevelop = class("HeroDevelopClass", Window)

function HeroDevelop:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.group = {
		_information = nil,
		_strengthen = nil,
		_advanced = nil,
		_train = nil,
		_skill_stren = nil,
		_awaken = nil
		
	}
	self.types = nil
	app.load("client.player.UserInformationHeroStorage")	
	app.load("client.formation.mega.MegaWindow")
	app.load("client.packs.EquipStorage.SmEquipmentQunenchingHandle")
    app.load("client.packs.EquipStorage.SmEquipmentQianghuaTab3Window1")
	self.shipId = "1"                   --当前武将ID
	self.pageshowindex = 6 -- 1 信息 2 升级 3 突破 4 培养 5 境界 6 装备

	self.armature_effic = nil
	self.normal_armature_effic = nil
	self.animation_index = nil
	self.effic_id = nil
	self.normal_effic_id = nil
	self.armature_hero = nil
	self.isAwaken = false -- 是否可以觉醒

	self.isUpdateShowShip = true
	self.shipEquipPos = {}	--	装备位置保存

	self.m_type = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.equipIconArray = {}
		self.m_equip_index = 1
		app.load("client.cells.utils.multiple_list_view_cell")
	end

    local function init_hero_develop_page_terminal()
		local hero_develop_page_manager_terminal = {
            _name = "hero_develop_page_manager",
            _init = function (terminal) 
                 app.load("client.packs.hero.HeroSkillStrenLevelTip")
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
            		if instance == nil then
            			return
            		end
            		local funopenid = params._datas.openWinId
            		if funOpenDrawTip(funopenid) == true then
            			return
            		end
            		-- if funopenid ~= -1 then
            		-- 	local isopen ,tip = getFunopenLevelAndTip(funopenid)
            		-- 	if isopen == false then
            		-- 		TipDlg.drawTextDailog(tip)
            		-- 		return
            		-- 	end
            		-- end

            		if instance.pageshowindex == 6 then
            			state_machine.excute("formation_play_equip_hide",0,"")
            		end
            	end

				-- set select ui button is highlighted
				local arena_grade=dms.int(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.level)
				if arena_grade == nil or arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					local mynum = 0
					local myShip = fundShipWidthId(instance.shipId)

					if _ED.hero_skillstren_info.hero_id ~= nil and
						tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(instance.shipId) then
						mynum = _ED.hero_skillstren_info.value
					else
						mynum = myShip.ship_skillstren.skill_value
					end
					
					if fwin:find("HeroSkillStrenPageClass") ~= nil and 
						params._datas.next_terminal_name ~= "hero_develop_page_open_skill_stren_page" and 
						tonumber(mynum) ~= 0 then
						if fwin:find("HeroSkillStrenPageClass").status == true then
							local cell = HeroSkillStrenLevelTip:new()
							cell:init(params._datas.next_terminal_name,terminal.select_button,instance.shipId)
							fwin:open(cell, fwin._windows)
							return
						end
					end
					
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						if params._datas.current_button_name == "Button_tianming_child" then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_tianming"):setHighlighted(true)
						else
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_tianming"):setHighlighted(false)
						end
					end
					if terminal.last_terminal_name ~= params._datas.next_terminal_name then
						for i, v in pairs(instance.group) do
							if v ~= nil then
								v:setVisible(false)
							end
						end
						terminal.last_terminal_name = params._datas.next_terminal_name
						state_machine.excute(params._datas.next_terminal_name, 0, params)
					end
					if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
						terminal.select_button:setHighlighted(false)
						terminal.select_button:setTouchEnabled(true)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							terminal.select_button = nil
						end
					end
					
					if terminal.select_button == nil and params._datas.current_button_name ~= nil then
						terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
						if params._datas.current_button_name == "Button_xinxi" then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xinxi"):setVisible(true)
						elseif params._datas.current_button_name == "Button_shengji" then
							if _ED.mega_info  then
							    local ship  = fundShipWidthId(instance.shipId)
				            	if fwin:find("SmRoleStrengthenTabClass") ~= nil then
									state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship.ship_id,instance.m_type})
								end
						    end 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(true)
							end
						elseif params._datas.current_button_name == "Button_tupo" then
						    if _ED.mega_info  then
							    local ship  = fundShipWidthId(instance.shipId)
				            	if fwin:find("SmRoleStrengthenTabClass") ~= nil then
									state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship.ship_id,instance.m_type})
								end
						    end 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(true)
							end
						elseif params._datas.current_button_name == "Button_peiyang" then 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(true)
							end
						elseif params._datas.current_button_name == "Button_tianming" then 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(true)
							end
						elseif params._datas.current_button_name == "Button_juexing" then 
						elseif params._datas.current_button_name == "Button_xiangqin" then 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_xq"):setVisible(true)
							end
							-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(true)
						end
					else
						terminal.select_button = params
						if params == "Button_xinxi" then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xinxi"):setVisible(true)
						elseif params == "Button_shengji" then
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(true)	
							end
						elseif params == "Button_tupo" then 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(true)
							end
						elseif params == "Button_peiyang" then 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(true)
							end
						elseif params == "Button_tianming" then 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(true)
							end
						elseif params == "Button_juexing" then 
							-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(true)
						elseif params._datas.current_button_name == "Button_xiangqin" then 
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								ccui.Helper:seekWidgetByName(instance.roots[1], "Image_xq"):setVisible(true)
							end
						end
					end
					if __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(false)
					end
					if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
						terminal.select_button:setHighlighted(true)
						terminal.select_button:setTouchEnabled(false)
					end
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
					else
						if tonumber(_ED.user_ship[""..instance.shipId].ship_grade) >= tonumber(_ED.user_info.user_grade) then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_shengji"):setBright(false)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_shengji"):setTouchEnabled(false)
						end
					end
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_yugioh
						then 
						--英雄是否可以觉醒
						if instance.isAwaken == false then 
	
						end
					end
					
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.tip_info))
				end


				if __lua_project_id == __lua_project_gragon_tiger_gate
					-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					local Button_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xinxi")
					if nil ~= Button_xinxi then
		            	if instance.pageshowindex == 6 then
		            		ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xinxi"):setVisible(true)
		            	else
		            		ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xinxi"):setVisible(false)
		            	end
		            end

		            local Button_xiangqin = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xiangqin")
		            if nil ~= Button_xiangqin then
		            	if instance.pageshowindex == 1 then
		            		ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xiangqin"):setHighlighted(true)
		            	else
		            		ccui.Helper:seekWidgetByName(instance.roots[1], "Button_xiangqin"):setHighlighted(false)
		            	end
		            end
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--关闭当前窗口
		local hero_develop_page_close_terminal = {
            _name = "hero_develop_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_red_alert then
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
	                        })
	                end
	                -- state_machine.excute("menu_back_home_page", 0, "")
	                -- state_machine.excute("menu_clean_page_state", 0, "")
            		
            		if fwin:find("FormationTigerGateClass") ~= nil then
	            		fwin:find("FormationTigerGateClass"):setVisible(true)
						fwin:find("HeroIconListViewClass"):setVisible(true)
					end
					if fwin:find("HeroStrengthenPageClass") ~= nil then
	            		fwin:close(fwin:find("HeroStrengthenPageClass"))
	            	end
	            	if fwin:find("HeroAdvancedPageClass") ~= nil then
	            		fwin:close(fwin:find("HeroAdvancedPageClass"))
	            	end
	            	if fwin:find("HeroTrainPageClass") ~= nil then
	            		fwin:close(fwin:find("HeroTrainPageClass"))
	            	end
	            	if fwin:find("HeroSkillStrenPageClass") ~= nil then
	            		fwin:close(fwin:find("HeroSkillStrenPageClass"))
	            	end
                    if fwin:find("MegaWindowClass") ~= nil then
	            		fwin:close(fwin:find("MegaWindowClass"))
	            	end

	            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		            	if _ED.ship_warehouse_enter == true then
		            		state_machine.excute("home_click_generals",0,"")
		            	else
		            		if __lua_project_id == __lua_project_l_naruto then
			            		if self.types == "formation" then
			            			local f_index = 1
			            			for i,v in pairs(_ED.user_formetion_status) do
			            				if tonumber(v) == tonumber(self.shipId) then
			            					f_index = i
			            					break
			            				end
			            			end
			            			state_machine.excute("home_hero_into_formation_page", 0, 
										  {_datas = {_heroInstance = _ED.user_ship["".._ED.user_formetion_status[f_index]], _formetion_index = f_index}})
			            		end
			            	end
		            	end
		            	_ED.ship_warehouse_enter = false
		            	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effice_digimon_qh/effice_digimon_qh.ExportJson")
		            	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson")
	            	end

            		fwin:close(fwin:find("HeroDevelopClass"))
            		--刷新武将列表界面武将强化推送
       				state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
       				state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       				state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       				state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       				--state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_icon")
       				state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")
        			state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_strengthen_button")
        			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				        if fwin:find("FormationTigerGateClass") ~= nil then
					        state_machine.excute("formation_update_ship_info", 0, {isChange = true})
					    end
				        state_machine.unlock("notification_center_update")
				        if _ED.active_activity[42] ~= nil then
				            state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_seven_days_activity")
				            state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_all_target")
				            state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_page_push")
				            state_machine.excute("notification_center_update", 0, "push_notification_new_everydays_recharge")
				            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 42)
				        end
				        --商店推送
				        state_machine.excute("notification_center_update", 0, "push_notification_center_new_shop") 
				        state_machine.excute("notification_center_update", 0, "push_notification_center_sm_chest_store")
				        --武将强化推送
				        state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
				        
				        --state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_strength_icon")
				        state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_evolution_page_tip")
				        state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_up_grade_star_page_tip")
				        state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_evolution_button")
				        state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_up_grade_button")
				        state_machine.excute("sm_equipment_qianghua_update_hero_icon_push",0,"sm_equipment_qianghua_update_hero_icon_push.")
				        state_machine.excute("hero_develop_page_updata_hero_icon_push",0,"hero_develop_page_updata_hero_icon_push.")
	        			state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_evo")
	        			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_evo")
						state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_formation")
					    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equip_upgrade")
					    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equip_awake")
				    	state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_upgrade")
				    	state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_awake")
        			end
            	else
	            	if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
	            		if instance == nil then
	            			return
	            		end
	            	end
					local mynum = 0
					local myShip = fundShipWidthId(instance.shipId)
					if _ED.hero_skillstren_info.hero_id ~= nil and
						tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(instance.shipId) then
						mynum = _ED.hero_skillstren_info.value
					else
						mynum = myShip.ship_skillstren.skill_value
					end
					if fwin:find("HeroSkillStrenPageClass") ~= nil and tonumber(mynum) ~= 0 then
						if fwin:find("HeroSkillStrenPageClass").status == true then
							local cell = HeroSkillStrenLevelTip:new()
							cell:init(nil,nil,instance.shipId,2)
							fwin:open(cell, fwin._windows)
							return
						end
					end
					local ser = false
					if instance.types == "formation" then
						ser = true
					end
					for i, v in pairs(instance.group) do
						if v ~= nil then
							fwin:close(v)
						end
					end
					
					fwin:close(fwin:find("HeroDevelopClass"))
					-- print("2*-*-*-*-*-*-*-*-*-*-*-*",params)
					state_machine.excute("hero_storage_show_window", 0, params)
					-- local hWnd = fwin:find("HeroStorageClass")
					-- if hWnd ~= nil then 
						-- hWnd.group._heroPatchListView:setVisible(false) 
					-- end
					if ser == true then
						state_machine.excute("formation_property_change_by_level_up", 0, "")
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then
						state_machine.excute("hero_icon_listview_close",0,"")
						fwin:uncovers(nil)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 武将信息
        local hero_develop_page_open_hero_information_page_terminal = {
            _name = "hero_develop_page_open_hero_information_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.group._information == nil then
					app.load("client.formation.HeroInformation")
					instance.group._information = HeroInformation:new()
					instance.group._information:init(fundShipWidthId(instance.shipId))
					fwin:open(instance.group._information, fwin._view) 
				end
				
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(false)
				end
				instance.group._information:setVisible(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					self.pageshowindex = 1
					state_machine.excute("hero_formation_update",0,"")
					-- state_machine.excute("hero_icon_list_view_get_developpage",0,1)
					-- state_machine.excute("formation_change_page_index",0,1)
					instance:onUpdateDrawTitle()
					instance.group._information:playShow()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
    	}

		--1.升级 
		local hero_develop_page_open_strengthenpage_terminal = {
            _name = "hero_develop_page_open_strengthen_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end

            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

            		state_machine.excute("sm_role_strengthen_tab_display",0,"")
            		state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
            		state_machine.excute("sm_role_strengthen_tab_fighting_spirit_hide",0,"")
            		state_machine.excute("sm_role_strengthen_tab_open_up_product",0,"")
            		ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110"):setVisible(true)
            		instance.m_type = 1
            		instance:updatePagePush()
            		state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,true)
            	else
					if instance.group._strengthen == nil then
						app.load("client.packs.hero.HeroStrengthenPage")
						instance.group._strengthen = HeroStrengthenPage:new()
						instance.group._strengthen:init(instance.shipId,instance.types)
						fwin:open(instance.group._strengthen, fwin._view)
					end
					if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(false)
					else
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
						else
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(true)	
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(false)
					end
					instance.group._strengthen:setVisible(true)
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						self.pageshowindex = 2
						-- state_machine.excute("hero_strengthen_page_check_updata_by_other_page",0,"")
						-- state_machine.excute("hero_icon_list_view_get_developpage",0,2)	
						state_machine.excute("formation_change_page_index",0,2)
						instance:onUpdateDrawTitle()
						instance.group._strengthen:playShow()
					end
				end
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 2.突破
		local hero_develop_page_open_advanced_terminal = {
            _name = "hero_develop_page_open_advanced",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		instance.m_type = 2
            		instance:updatePagePush()
            		state_machine.excute("sm_role_strengthen_tab_display",0,"")
            		state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
            		state_machine.excute("sm_role_strengthen_tab_fighting_spirit_hide",0,"")
            		state_machine.excute("sm_role_strengthen_tab_open_up_grade",0,"")
            		ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110"):setVisible(true)
            		state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,true)
            	else
					if instance.group._advanced == nil then
						app.load("client.packs.hero.HeroAdvancedPage")
						instance.group._advanced = HeroAdvancedPage:new()
						instance.group._advanced:init(instance.shipId,instance.types)
						fwin:open(instance.group._advanced, fwin._view)
					end
					
					instance.group._advanced:setVisible(true)
					if __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(false)
					else
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
						else
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(true)
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(false)
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						self.pageshowindex = 3
						state_machine.excute("hero_advanced_page_check_updata_by_other_page",0,"")
						-- state_machine.excute("hero_icon_list_view_get_developpage",0,3)
						-- state_machine.excute("formation_change_page_index",0,3)
						instance:onUpdateDrawTitle()
						instance.group._advanced:playShow()
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--3.培养
		local hero_develop_page_open_train_terminal = {
            _name = "hero_develop_page_open_train_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		state_machine.excute("sm_role_strengthen_tab_display",0,"")
            		state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
            		state_machine.excute("sm_role_strengthen_tab_fighting_spirit_hide",0,"")
            		state_machine.excute("sm_role_strengthen_tab_open_rising_star",0,"")
            		ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110"):setVisible(true)
            		instance.m_type = 3
            		instance:updatePagePush()
            		state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,false)
            	else
					if instance.group._train == nil then
						app.load("client.packs.hero.HeroTrainPage")
						instance.group._train = HeroTrainPage:new()
						instance.group._train:init(instance.shipId,instance.types)
						fwin:open(instance.group._train, fwin._view)
					end
					instance.group._train:setVisible(true)
					if __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(false)
					else
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
						else
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(true)
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(false)
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						self.pageshowindex = 4
						state_machine.excute("hero_train_page_check_updata_by_other_page",0,"")
						-- state_machine.excute("hero_icon_list_view_get_developpage",0,4)
						-- state_machine.excute("formation_change_page_index",0,4)
						instance:onUpdateDrawTitle()
						instance.group._train:playShow()
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--5.天命
		local hero_develop_page_open_skill_stren_terminal = {
            _name = "hero_develop_page_open_skill_stren_page",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroSkillStrenPage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						state_machine.excute("sm_role_strengthen_tab_open_rising_skill",0,"")

						
						
            		else
            			local Panel_role_streng_tab = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_role_streng_tab")
	            		app.load("client.packs.hero.SmRoleStrengthenTabSkill")
						state_machine.excute("sm_role_strengthen_tab_skill_open",0,{Panel_role_streng_tab,instance.shipId})
						state_machine.excute("sm_role_strengthen_tab_hide",0,"")
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110"):setVisible(false)
            		end


            		state_machine.excute("sm_role_strengthen_tab_fighting_spirit_hide",0,"")
					state_machine.excute("sm_role_strengthen_tab_skill_display",0,"")
					instance.m_type = 4
					instance:updatePagePush()
						state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,false)
            	else
					--> print(instance.group._skill_stren,"instance.group._skill_stren--------------")
					if instance.group._skill_stren == nil then
						instance.group._skill_stren = HeroSkillStrenPage:new()
						instance.group._skill_stren:init(instance.shipId,instance.types)
						fwin:open(instance.group._skill_stren, fwin._view)
					end
					fwin:find("HeroSkillStrenPageClass").status = true
					instance.group._skill_stren:setVisible(true)
					if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(false)
					else
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
						else
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(true)		
						end
					end
					
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(false)
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						self.pageshowindex = 5
						state_machine.excute("hero_skill_stren_page_check_updata_by_other_page",0,"")
						-- state_machine.excute("hero_icon_list_view_get_developpage",0,5)
						-- state_machine.excute("formation_change_page_index",0,5)
						
						instance:onUpdateDrawTitle()
						instance.group._skill_stren:playShow()
					end
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--5.觉醒
		local hero_develop_page_open_juexin_terminal = {
            _name = "hero_develop_page_open_juexin",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		
            	else
	            	if __lua_project_id == __lua_project_digimon_adventure 
	            		or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
	            		or __lua_project_id == __lua_project_warship_girl_b 
	            		or __lua_project_id == __lua_project_yugioh 
	            		then 
	            		if instance.group._awaken  == nil then
							app.load("client.packs.hero.HeroAwakenPage")
							instance.group._awaken = HeroAwakenPage:new()
							instance.group._awaken:init(instance.shipId,instance.types)
							fwin:open(instance.group._awaken, fwin._view)
						end
						instance.group._awaken:setVisible(true)
	            	else
						TipDlg.drawTextDailog(_function_unopened_tip_string)
					end
					-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(true)
					-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(false)
					-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(false)
					-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(false)
					-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--6.改变按钮状态
		local hero_develop_page_change_button_terminal = {
            _name = "hero_develop_page_change_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				ccui.Helper:seekWidgetByName(self.roots[1], params):setBright(false)
				ccui.Helper:seekWidgetByName(self.roots[1], params):setTouchEnabled(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

				--7.用于人物升级，境界升级，突破之后,培养之后的信息刷新
		local hero_develop_page_update_terminal = {
            _name = "hero_develop_page_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--print("去刷新")
            	state_machine.excute("hero_formation_update",0,"")
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
	            	if params.params == "check_tupo_is_top" then
		            	if dms.int(dms["ship_mould"], _ED.user_ship[""..instance.shipId].ship_template_id, ship_mould.grow_target_id) == -1 then
							local Button_tupo = ccui.Helper:seekWidgetByName(self.roots[1], "Button_tupo")
							Button_tupo:setBright(false)
							Button_tupo:setTouchEnabled(false)
						end
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

				--8.英雄头像点击后的刷新
		local hero_develop_page_update_for_icon_terminal = {
            _name = "hero_develop_page_update_for_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local ship = params
            	if ship == nil then
            		return
            	end
            	for i ,v in pairs(instance.group) do 
            		if v ~= nil and v.init ~= nil and v == instance.group._information then
            			v:init(ship)	
            		elseif v ~= nil and v.init ~= nil and v == instance.group._strengthen then
            			v:init(ship.ship_id,instance.types)
            		elseif v ~= nil and v.init ~= nil and v == instance.group._advanced then
            			v:init(ship.ship_id,instance.types)
            		elseif v ~= nil and v.init ~= nil and v == instance.group._train then
            			v:init(ship.ship_id,instance.types)
            		elseif v ~= nil and v.init ~= nil and v == instance.group._skill_stren then
            			v:init(ship.ship_id,instance.types)
            		end
            	end
            	if zstring.tonumber(instance.shipId) == zstring.tonumber(ship.ship_id) then
		    		local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
					local evo_info = zstring.split(evo_image, ",")

		    		local ship_evo1 = zstring.split(_ED.user_ship[""..instance.shipId].evolution_status, "|")
					local evo_mould_id1 = evo_info[tonumber(ship_evo1[1])]
					local ship_evo2 = zstring.split(ship.evolution_status, "|")
					local evo_mould_id2= evo_info[tonumber(ship_evo2[1])]
					if tonumber(evo_mould_id1) == tonumber(evo_mould_id2) then
						instance.isUpdateShowShip = false
					else
						instance.isUpdateShowShip = true	
					end
				else
					instance.isUpdateShowShip = true	
		    	end
				instance:init(ship.ship_id,instance.types)
				if instance.pageshowindex == 1 then
					state_machine.excute("hero_formation_update",0,"")
				elseif instance.pageshowindex == 2 then
					state_machine.excute("hero_strengthen_grade_change_of_icon",0,"")
					state_machine.excute("hero_strengthen_page_check_updata_by_other_page",0,"")
				elseif instance.pageshowindex == 3 then
					state_machine.excute("hero_advanced_page_check_updata_by_other_page",0,"")
				elseif instance.pageshowindex == 4 then
					state_machine.excute("hero_train_page_check_updata_by_other_page",0,"")
				elseif instance.pageshowindex == 5 then	
					state_machine.excute("hero_skill_stren_page_check_updata_by_other_page",0,"")
				end  
				instance:onUpdateDrawButton()
 	           	instance:onUpdateDrawHero()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
				--7.刷新角色
		local hero_develop_update_hero_terminal = {
            _name = "hero_develop_update_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--print("去刷新")
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	            	instance.isUpdateShowShip = true	
	            end
            	local Panel_hero_110 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110")
            	Panel_hero_110:setVisible(true)
            	instance:onUpdateDrawHero()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
				--7.隐藏英雄
		local hero_develop_hero_hide_terminal = {
            _name = "hero_develop_hero_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--print("去刷新")
            	local Panel_hero_110 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110")
            	Panel_hero_110:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        				--7.隐藏英雄
		local hero_develop_hero_show_terminal = {
            _name = "hero_develop_hero_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--print("去刷新")
            	local Panel_hero_110 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110")
            	Panel_hero_110:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
              --8、隐藏所有培养线，显示装备
		local hero_develop_page_show_equip_terminal = {
            _name = "hero_develop_page_show_equip",
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
            		state_machine.excute("formation_play_equip_show",0,"")
            		instance.pageshowindex = 6 
            		instance:onUpdateDrawTitle()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        --隐藏当前
        local hero_develop_page_hidden_nowpage_terminal = {
            _name = "hero_develop_page_hidden_nowpage",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:setVisible(false)
            	if instance.pageshowindex == 1 then
					instance.group._information:setVisible(false)
            	elseif instance.pageshowindex == 2 then
            		instance.group._strengthen:setVisible(false)
            	elseif instance.pageshowindex == 3 then
            		instance.group._advanced:setVisible(false)
            	elseif instance.pageshowindex == 4 then
            		instance.group._train:setVisible(false)
            	elseif instance.pageshowindex == 5 then
            		instance.group._skill_stren:setVisible(false)
            	elseif instance.pageshowindex == 6 then
            	end
            	fwin:find("HeroIconListViewClass"):setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
                --显示当前
        local hero_develop_page_show_nowpage_terminal = {
            _name = "hero_develop_page_show_nowpage",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:setVisible(true)
            	if instance.pageshowindex == 1 then
					instance.group._information:setVisible(true)
            	elseif instance.pageshowindex == 2 then
            		instance.group._strengthen:setVisible(true)
            	elseif instance.pageshowindex == 3 then
            		instance.group._advanced:setVisible(true)
            	elseif instance.pageshowindex == 4 then
            		instance.group._train:setVisible(true)
            	elseif instance.pageshowindex == 5 then
            		instance.group._skill_stren:setVisible(true)
            	elseif instance.pageshowindex == 6 then
            	end    
            	if fwin:find("HeroIconListViewClass") ~= nil then
            		fwin:find("HeroIconListViewClass"):setVisible(true)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

		local hero_develop_play_hero_animation_terminal = {
            _name = "hero_develop_play_hero_animation",
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

		local hero_develop_update_skill_terminal = {
            _name = "hero_develop_update_skill",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.getSkillAnimationIndex ~= nil then
	            	instance.animation_index,instance.effic_id = instance:getSkillAnimationIndex()
	            	instance:onUpdateDrawHero()
	            end
            end,
            _terminal = nil,
            _terminals = nil
        } 

        ---武将升级后刷新觉醒状态
		local hero_develop_page_strength_to_awaken_terminal = {
            _name = "hero_develop_page_strength_to_awaken",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then 
            		instance:updateRefreshAwakenButtonStates()
        		end
            	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

		---点击武将刷新界面
		local hero_develop_page_strength_to_update_ship_terminal = {
            _name = "hero_develop_page_strength_to_update_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local ship = params
            	if params == nil or params == "" or params == 1 then
            		ship = fundShipWidthId(instance.shipId)
            	end
            	if fwin:find("SmRoleStrengthenTabClass") ~= nil then
					state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship.ship_id,instance.m_type})
				end
				if fwin:find("SmRoleStrengthenTabSkillClass") ~= nil then
					state_machine.excute("sm_role_strengthen_tab_skill_update_draw",0,{ship.ship_id})
				end
				if fwin:find("SmRoleStrengthenTabFightingSpiritClass") ~= nil then
					state_machine.excute("sm_role_strengthen_tab_fighting_spirit_update_draw",0,{ship.ship_id})
				end
            	if zstring.tonumber(instance.shipId) == zstring.tonumber(ship.ship_id) then
		    		local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
					local evo_info = zstring.split(evo_image, ",")

		    		local ship_evo1 = zstring.split(_ED.user_ship[""..instance.shipId].evolution_status, "|")
					local evo_mould_id1 = evo_info[tonumber(ship_evo1[1])]
					local ship_evo2 = zstring.split(ship.evolution_status, "|")
					local evo_mould_id2= evo_info[tonumber(ship_evo2[1])]
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
				instance.shipId = ship.ship_id
				instance:onUpdateDrawHero()
				if instance.m_type == 6  then
					state_machine.excute("sm_role_strengthen_tab_open_equip_up",0,instance.equipInfo[tonumber(instance.m_equip_index)])
				elseif instance.m_type == 7 then
					state_machine.excute("sm_role_strengthen_tab_open_equip_awakening",0,instance.equipInfo[tonumber(instance.m_equip_index)])
				elseif instance.m_type == 8 then
				    state_machine.excute("mega_window_close",0,nil)
			        local ship = fundShipWidthId(instance.shipId)
					state_machine.excute("mega_window_open",0,{ship}) 
				elseif instance.m_type == 9 then
					state_machine.excute("sm_role_strengthen_tab_open_equip_harden",0,instance.equipInfo[tonumber(instance.m_equip_index)])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        		    	
        ---设置头像高亮
		local hero_develop_page_strength_to_highlighted_terminal = {
            _name = "hero_develop_page_strength_to_highlighted",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:setIndex(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --头像变更
		local hero_develop_page_strength_to_update_all_icon_terminal = {
            _name = "hero_develop_page_strength_to_update_all_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if not params or params == "" then
            		params = fundShipWidthId(instance.shipId)
            	end
            	instance:onUpdateAllIcon(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新头像推送
		local hero_develop_page_updata_hero_icon_push_terminal = {
            _name = "hero_develop_page_updata_hero_icon_push",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local listview = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_qianghua_juese")
				local items = listview:getItems()
            	for i , v in pairs(items) do
            		state_machine.excute("hero_icon_list_cell_hero_develop_hero_icon_push_updata",0,v)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开斗魂界面
		local hero_develop_page_open_fighting_spirit_terminal = {
            _name = "hero_develop_page_open_fighting_spirit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            		state_machine.excute("sm_role_strengthen_tab_open_rising_fighting_spirit",0,"")
            	else
            		app.load("client.packs.hero.SmRoleStrengthenTabFightingSpirit")
		            local Panel_role_streng_tab = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_role_streng_tab")
					state_machine.excute("sm_role_strengthen_tab_fighting_spirit_open",0,{Panel_role_streng_tab,instance.shipId})
					state_machine.excute("sm_role_strengthen_tab_hide",0,"")
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110"):setVisible(false)
            	end
				state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
				state_machine.excute("sm_role_strengthen_tab_fighting_spirit_display",0,"")
        		instance.m_type = 5
        		instance:updatePagePush()
        		state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开装备强化
		local hero_develop_page_open_equip_up_terminal = {
            _name = "hero_develop_page_open_equip_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	state_machine.excute("sm_role_strengthen_tab_open_equip_up",0,instance.equipInfo[tonumber(instance.m_equip_index)])
            	state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
				state_machine.excute("sm_role_strengthen_tab_fighting_spirit_display",0,"")
        		instance.m_type = 6
        		instance:updatePagePush()
        		state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开装备界面
		local hero_develop_open_sm_equipment_qianghua_terminal = {
            _name = "hero_develop_open_sm_equipment_qianghua",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		local ship = _ED.user_ship[""..instance.shipId]
        		instance:openEquipDevelop(ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--打开装备觉醒
		local hero_develop_page_open_equip_awakening_terminal = {
            _name = "hero_develop_page_open_equip_awakening",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	state_machine.excute("sm_role_strengthen_tab_open_equip_awakening",0,instance.equipInfo[tonumber(instance.m_equip_index)])
            	state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
				state_machine.excute("sm_role_strengthen_tab_fighting_spirit_display",0,"")
        		instance.m_type = 7
        		instance:updatePagePush()
        		state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		--打开装备淬炼
		local hero_develop_page_open_equip_harden_terminal = {
            _name = "hero_develop_page_open_equip_harden",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	state_machine.excute("sm_role_strengthen_tab_open_equip_harden",0,instance.equipInfo[tonumber(instance.m_equip_index)])
            	state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
				state_machine.excute("sm_role_strengthen_tab_fighting_spirit_display",0,"")
        		instance.m_type = 9
        		instance:updatePagePush()
        		state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开超进化
        local hero_develop_page_open_mega_terminal = {
            _name = "hero_develop_page_open_mega",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
            	if Panel_xinxi then
                   Panel_xinxi:setVisible(false)
                end
                local ship = fundShipWidthId(instance.shipId)
				state_machine.excute("mega_window_close",0,nil)
		        state_machine.excute("mega_window_open",0,{ship}) 
                state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
				state_machine.excute("sm_role_strengthen_tab_fighting_spirit_display",0,"")
        		instance.m_type = 8
        		instance:updatePagePush()
	            state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开战魂
        local hero_develop_page_open_fight_spirit_terminal = {
            _name = "hero_develop_page_open_fight_spirit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local Panel_xinxi = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xinxi")
                if Panel_xinxi then
                   Panel_xinxi:setVisible(true)
                   state_machine.excute("mega_window_close",0,nil)
                end
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		state_machine.excute("sm_role_strengthen_tab_display",0,"")
            		state_machine.excute("sm_role_strengthen_tab_skill_hide",0,"")
            		state_machine.excute("sm_role_strengthen_tab_fighting_spirit_hide",0,"")
            		state_machine.excute("sm_role_strengthen_tab_open_fight_spirit",0,{types = instance.types})
            		ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_hero_110"):setVisible(true)
            		instance.m_type = 10
            		instance:updatePagePush()
            		state_machine.excute("sm_role_strengthen_tab_hide_the_display",0,false)
            	else
					if instance.group._train == nil then
						app.load("client.packs.hero.HeroTrainPage")
						instance.group._train = HeroTrainPage:new()
						instance.group._train:init(instance.shipId,instance.types)
						fwin:open(instance.group._train, fwin._view)
					end
					instance.group._train:setVisible(true)
					if __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then 
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(false)
					else
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
						else
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_peiyang"):setVisible(true)
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_gaizhao"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shengji"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_hexin"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_ergai"):setVisible(false)
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						self.pageshowindex = 4
						state_machine.excute("hero_train_page_check_updata_by_other_page",0,"")
						-- state_machine.excute("hero_icon_list_view_get_developpage",0,4)
						-- state_machine.excute("formation_change_page_index",0,4)
						instance:onUpdateDrawTitle()
						instance.group._train:playShow()
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 返回动画
		local hero_develop_back_to_home_activity_terminal = {
			_name = "hero_develop_back_to_home_activity",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance.actions[1]:play("animation_close", false)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--装备选择
		local hero_develop_back_to_switch_equip_terminal = {
		    _name = "hero_develop_back_to_switch_equip",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	instance.m_equip_index = tonumber(params._datas.m_index)
	    		for i=1,6 do
					local Image_equ_props_hook = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_equ_props_hook_"..i)
					Image_equ_props_hook:setVisible(false)
				end
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_equ_props_hook_"..instance.m_equip_index):setVisible(true)
	    		if instance.m_type == 6 then
	    			state_machine.excute("hero_develop_page_open_equip_up",0,"")
	    		elseif instance.m_type == 7 then
					state_machine.excute("hero_develop_page_open_equip_awakening",0,"")
				elseif instance.m_type == 9 then 
					state_machine.excute("hero_develop_page_open_equip_harden",0,"")
	    		else
	    			state_machine.excute("hero_develop_page_manager",0,{_datas = {next_terminal_name = "hero_develop_page_open_equip_up", 			
					current_button_name = "Button_qianghua", 	
					but_image = "", 	
					shipId = self.shipId,
					terminal_state = 0, 
					openWinId = 96,
					isPressedActionEnabled = tempIsPressedActionEnabled}})
	    		end
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--刷新特定装备
		local hero_develop_back_to_update_specific_equip_terminal = {
		    _name = "hero_develop_back_to_update_specific_equip",
		    _init = function (terminal)
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
		    	local m_e_index = 0
		    	if zstring.tonumber(params) > 0 then
		    		m_e_index = zstring.tonumber(params)
		    	end
		    	local root = instance.roots[1]
				local shop_equip_position = {
					ccui.Helper:seekWidgetByName(root, "Panel_17_1"),
					ccui.Helper:seekWidgetByName(root, "Panel_17_2"),
					ccui.Helper:seekWidgetByName(root, "Panel_17_5"),
					ccui.Helper:seekWidgetByName(root, "Panel_17_3"),
					ccui.Helper:seekWidgetByName(root, "Panel_17_4"),
					ccui.Helper:seekWidgetByName(root, "Panel_17_6")
				}
				for i=1, 6 do
					local equipPlaceInfo = shop_equip_position[i]
					if m_e_index == 0 or m_e_index == i then
						equipPlaceInfo:removeAllChildren(true)
					end
				end
				local ship = fundShipWidthId(instance.shipId)
				if ship ~= nil then
					--武将装备数据(等级|品质|经验|星级|模板)
					local shipEquip = zstring.split(ship.equipInfo, "|")

					--初始装备
					local equipAll = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.treasureSkill)
					local equipData = zstring.split(shipEquip[5], ",")

					local equipStar = zstring.split(shipEquip[4], ",")
					for i=1, 6 do
						if m_e_index == 0 or m_e_index == i then
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
							equip.ship_id = instance.shipId
							equip.m_index = i
							local cell = instance:createEquipHead(21,equip)
							equipPlaceInfo:addChild(cell)
							instance.equipIconArray[i] = cell
							cell:setPosition(cell:getPositionX()-2.5,cell:getPositionY()-3)
							local starts = zstring.split(shipEquip[4], ",")
							neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_star"), tonumber(starts[tonumber(i)]))
							instance.equipInfo[i] = equip
						end
					end
				end

		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--升级后的特效
        local hero_develop_back_to_play_control_effect_terminal = {
            _name = "hero_develop_back_to_play_control_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
    --         	local Panel_sjdh_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_sjdh_2")
    --         	Panel_sjdh_2:removeAllChildren(true)
    --          --    draw.createEffect("effice_digimon_qh", "images/ui/effice/effice_digimon_qh/effice_digimon_qh.ExportJson", Panel_sjdh_2, 1, 100)
	   --          local effice_digimon_qh = ccs.Armature:create("effice_digimon_qh")
	   --          effice_digimon_qh:removeFromParent(true)
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
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(hero_develop_page_manager_terminal)	
        state_machine.add(hero_develop_page_close_terminal)	
        state_machine.add(hero_develop_page_open_hero_information_page_terminal)
        state_machine.add(hero_develop_page_open_strengthenpage_terminal)
        state_machine.add(hero_develop_page_open_advanced_terminal)
        state_machine.add(hero_develop_page_open_train_terminal)
        state_machine.add(hero_develop_page_open_skill_stren_terminal)
        state_machine.add(hero_develop_page_open_juexin_terminal)
        state_machine.add(hero_develop_page_change_button_terminal)
        state_machine.add(hero_develop_page_update_terminal)
        state_machine.add(hero_develop_page_update_for_icon_terminal)
        state_machine.add(hero_develop_update_hero_terminal)
        state_machine.add(hero_develop_hero_hide_terminal)
        state_machine.add(hero_develop_page_show_equip_terminal)
        state_machine.add(hero_develop_page_hidden_nowpage_terminal)
        state_machine.add(hero_develop_page_show_nowpage_terminal)
        state_machine.add(hero_develop_play_hero_animation_terminal)
        state_machine.add(hero_develop_update_skill_terminal)
        state_machine.add(hero_develop_hero_show_terminal)
        state_machine.add(hero_develop_page_strength_to_awaken_terminal)
        state_machine.add(hero_develop_page_strength_to_update_ship_terminal)
        state_machine.add(hero_develop_page_strength_to_highlighted_terminal)
        state_machine.add(hero_develop_page_strength_to_update_all_icon_terminal)
        state_machine.add(hero_develop_page_updata_hero_icon_push_terminal)
        state_machine.add(hero_develop_page_open_fighting_spirit_terminal)
        state_machine.add(hero_develop_page_open_equip_up_terminal)
        state_machine.add(hero_develop_page_open_equip_awakening_terminal)
        state_machine.add(hero_develop_back_to_home_activity_terminal)
        state_machine.add(hero_develop_back_to_switch_equip_terminal)
        state_machine.add(hero_develop_back_to_update_specific_equip_terminal)
        state_machine.add(hero_develop_back_to_play_control_effect_terminal)
		state_machine.add(hero_develop_page_open_mega_terminal)
		state_machine.add(hero_develop_page_open_equip_harden_terminal)
		state_machine.add(hero_develop_open_sm_equipment_qianghua_terminal)
		state_machine.add(hero_develop_page_open_fight_spirit_terminal)
     
        state_machine.init()
    end
    init_hero_develop_page_terminal()
end

function HeroDevelop:openEquipDevelop(ship)
	if fwin:find("HeroIconListViewClass") == nil then
		app.load("client.packs.hero.HeroIconListView")
	   	state_machine.excute("hero_icon_listview_open",0,ship)
	   	fwin:find("HeroIconListViewClass"):setVisible(false)
   	end

   	--武将装备数据(等级|品质|经验|星级|模板)
	local shipEquip = zstring.split(ship.equipInfo, "|")
	local equipData = zstring.split(shipEquip[5], ",")
	local equipStar = zstring.split(shipEquip[4], ",")
	local equipMouldId = equipData[1]
	local equip = {}
	--装备模板id
	--初始装备
	local equipAll = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.treasureSkill)
	if tonumber(equipStar[1]) == 0 then
		local equipMouldData = zstring.split(equipAll, ",")
		equip.user_equiment_template = equipMouldData[1]
	else
		equip.user_equiment_template = equipMouldId
	end
	--装备等级
	local equipLevelData = zstring.split(shipEquip[1], ",")
	equip.user_equiment_grade = equipLevelData[1]
	--所属战船
	equip.ship_id = ship.ship_id
	equip.m_index = 1
	equip.isPacks = true

	app.load("client.packs.equipment.SmEquipmentQianghua")
	state_machine.excute("sm_equipment_qianghua_open",0,equip)
end

function HeroDevelop:onUpdateAllIcon(m_ship)
	self:shipListDraw()
	self.listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_qianghua_juese")
	local items = self.listView:getItems()
	for i,v in pairs(items) do
		if v.ship == m_ship then
			v:setSelected(true)
			v.ishow = true
			self.lastcell = v
			v:onUpdateDraw()
			break
		end
	end
	-- self:firstIconIndex(m_ship)
	-- self.listview:requestRefreshView()
end

function HeroDevelop:setIndex(cell)
	if self.lastcell ~= nil then
		self.lastcell.ishow = false
		if self.lastcell.setSelected ~= nil then
			self.lastcell:setSelected(false)
		end
	end
	cell:setSelected(true)
	cell.ishow = true
	self.lastcell = cell
end

function HeroDevelop:firstIconIndex(ship)
	--todo 设置第一次的底框 和listvew位置
	local root = self.roots[1]
	self.listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_qianghua_juese")
	local items = self.listView:getItems()
	local index = 1
	local itemsnumber = #items
	local height = 0
	for i,v in pairs(items) do
		if v.ship == ship then
			v:setSelected(true)
			v.ishow = true
			self.lastcell = v
			index = i 
			height = v:getContentSize().height
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				height = v.roots[1]:getContentSize().height
			end
			break
		end
	end
	self.listView:getInnerContainer():setPositionY((index-1)*height)
end

function HeroDevelop:getSortedHeroes()
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end
	--上阵
	local tSortedHeroes = {}
	--未上阵
	local arrBusyHeroes = {}
	--全部
	local allHeroes = {}
	for j, q in pairs(_ED.user_ship) do
		if zstring.tonumber(q.formation_index) > 0 then
			table.insert(tSortedHeroes, q)
		else
			table.insert(arrBusyHeroes, q)
		end
	end	
	table.sort(tSortedHeroes, fightingCapacity)
	table.sort(arrBusyHeroes, fightingCapacity)
	for i=1, #tSortedHeroes do
		table.insert(allHeroes, tSortedHeroes[i])
	end

	if __lua_project_id == __lua_project_l_naruto
		then
		if self.types == "formation" then
		else
			for i=1, #arrBusyHeroes do
				table.insert(allHeroes, arrBusyHeroes[i])
			end
		end
	else
		for i=1, #arrBusyHeroes do
			table.insert(allHeroes, arrBusyHeroes[i])
		end
	end

	return allHeroes
end

function HeroDevelop:shipListDraw()

	local root = self.roots[1]
	self.listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_qianghua_juese")
	self.listView:removeAllItems()
	app.load("client.cells.ship.hero_icon_list_cell")
	local addmouldId = {}
	local push_type = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		push_type = 2
	end
	for i, v in pairs(self:getSortedHeroes()) do
		local cell = HeroIconListCell:createCell()
		if zstring.tonumber(v.formation_index) > 0 then
			cell:init(v, i,true,0,push_type)
			-- cell:init(v, i,true)
		else
			cell:init(v, i,false,0,push_type)
			-- cell:init(v, i,false)
		end
		if #addmouldId == 0 then
			table.insert(addmouldId, v.ship_template_id)
			-- cell.roots[1]:setPositionY(-15)
			self.listView:addChild(cell)
		else
			local isAdd = true
			for j,q in pairs(addmouldId) do
				if tonumber(v.ship_template_id) == tonumber(q) then
					isAdd = false
				end
			end
			if isAdd == true then
				table.insert(addmouldId, v.ship_template_id)
				-- cell.roots[1]:setPositionY(-15)
				self.listView:addChild(cell)
			end
		end
		
	end
	self.listView:requestRefreshView()
end

function HeroDevelop:changeHeroAnimation(play_type)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if play_type == "begin" then
			self.play_index = 14--38 
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
		if self.normal_armature_effic ~= nil and --[[self.play_index == 38 and]] self.play_index == 14 and tonumber(ship.captain_type) == 0 then
			self.normal_armature_effic:setVisible(true)
			csb.animationChangeToAction(self.normal_armature_effic, 0,0, false)
		end

		csb.animationChangeToAction(self.armature_hero, self.play_index, self.play_index, false)
	end
end
function HeroDevelop:onUpdateDraw()
end

function HeroDevelop:getSkillAnimationIndex()
	if self.shipId == nil then
		-- print("===================111111111111")
		return
	end

	local ship = fundShipWidthId(self.shipId)
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

function HeroDevelop:loadEffectFile(fileIndex)
    local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    local armatureName = string.format("effice_%d", fileIndex)
    return armatureName, fileName
end

function HeroDevelop:createEffect(fileIndex, fileNameFormat)
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

local function onFrameEventRole(bone,evt,originFrameIndex,currentFrameIndex)
    local armature = bone:getArmature()
    local _self = armature._self
    local frameEvents = zstring.split(evt, "_")
    if checkFrameEvent(frameEvents, "union") == true then -- 启动角色镜头聚焦
		-- print("start union effect!")
        local effectIds = zstring.split(frameEvents[2], ",")
        for i, v in pairs(effectIds) do
        	local function deleteEffectFile(armatureBack)
			    if armatureBack == nil then
			        return
			    end
			    -- 删除光效
			    armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns
			    if armatureBack._LastsCountTurns <= 0 then
			        local fileName = armatureBack._fileName
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
			            CCSpriteFrameCache:purgeSharedSpriteFrameCache()
			            CCTextureCache:sharedTextureCache():removeUnusedTextures()
			        end
			    end
			end
			-- print("create union effect:", v)
            local armatureEffect = _self:createEffect(v, "sprite/effect_")
            armatureEffect._self = _self
            armatureEffect._invoke = deleteEffectFile

            local map = armature -- _self:getParent()
            map:addChild(armatureEffect)
        end
    end
end

function HeroDevelop:createEquipHead(objectType,ship)
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

--新项目的绘制装备方法（24，25项目）
function HeroDevelop:updateEquipDraw()
	local root = self.roots[1]
	local shop_equip_position = {
		ccui.Helper:seekWidgetByName(root, "Panel_17_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_5"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_4"),
		ccui.Helper:seekWidgetByName(root, "Panel_17_6")
	}
	for i=1, 6 do
		local equipPlaceInfo = shop_equip_position[i]
		equipPlaceInfo:removeAllChildren(true)
		if __lua_project_id == __lua_project_l_digital then
			local parentNode = equipPlaceInfo:getParent()
			if #self.shipEquipPos == 6 then
				parentNode:setPosition(cc.p(self.shipEquipPos[i][1] , self.shipEquipPos[i][2]))
			else
				table.insert(self.shipEquipPos ,{parentNode:getPositionX() ,parentNode:getPositionY()})
			end
		end
	end
	local ship = fundShipWidthId(self.shipId)
	if ship ~= nil then
		--武将装备数据(等级|品质|经验|星级|模板)
		local shipEquip = zstring.split(ship.equipInfo, "|")

		--初始装备
		local equipAll = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.treasureSkill)
		local equipData = zstring.split(shipEquip[5], ",")

		local equipStar = zstring.split(shipEquip[4], ",")
		self.equipInfo = {}

		local suitDistance = 0
		if __lua_project_id == __lua_project_l_digital then
			-- DSC重塑
			suitDistance = self:updateDrawInstance()
			-- 小米11pro的偏移处理
			if (app.screenSize.width == 3063 and app.screenSize.height == 1440) and cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
				suitDistance = suitDistance - 100
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
			equip.ship_id = self.shipId
			equip.m_index = i
			local cell = self:createEquipHead(1,equip)
			equipPlaceInfo:addChild(cell)
			self.equipIconArray[i] = cell

			if __lua_project_id == __lua_project_l_digital then
				-- DSC重塑
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
	for i=1,6 do
		local Image_equ_props_hook = ccui.Helper:seekWidgetByName(self.roots[1], "Image_equ_props_hook_"..i)
		Image_equ_props_hook:setVisible(false)
	end
	if __lua_project_id == __lua_project_l_digital then
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_equ_props_hook_"..self.m_equip_index):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_equ_props_hook_"..self.m_equip_index):setVisible(true)
	end
end

function HeroDevelop:onUpdateDrawHero()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local root = self.roots[1]
		local Panel_hero_110 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_110")
		Panel_hero_110:setTouchEnabled(false)

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
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else 
			Panel_hero_110:removeAllChildren(true)
		end
		self.animation_index,self.effic_id = self:getSkillAnimationIndex()		

		local ship = fundShipWidthId(self.shipId)
		local quality = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.ship_type)
		local temp_bust_index = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			----------------------新的数码的形象------------------------
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(ship.evolution_status, "|")
			local evo_mould_id = smGetSkinEvoIdChange(ship)
			
			--新的形象编号
			temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
		else
			temp_bust_index = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.bust_index)
		end
		if self.isUpdateShowShip == true then
			Panel_hero_110:removeAllChildren(true)
			if self.isLineEffice == true then
				local file_path = "images/ui/effice/effect_line/effect_line.ExportJson"
				local armature_name = "effect_line"
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(file_path)
				local cell = ccs.Armature:create(armature_name)
				cell:getAnimation():playWithIndex(0)
				cell:setPositionX(Panel_hero_110:getPositionX()-Panel_hero_110:getContentSize().width/2)
				Panel_hero_110:addChild(cell)
				self.isLineEffice = false
			end
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_hero_110, nil, nil, cc.p(0.5, 0))
			app.load("client.battle.fight.FightEnum")
			local armature_hero = sp.spine_sprite(Panel_hero_110, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				armature_hero:setScaleX(-1)
			end
			self.armature_hero = armature_hero
			armature_hero.animationNameList = spineAnimations
			sp.initArmature(self.armature_hero, true)
		    local function changeActionCallback( armatureBack )	
				if self.play_index == 14 then
					if self ~= nil and self.roots ~= nil then
						state_machine.excute("hero_develop_play_hero_animation",0,self.animation_index)
					end
				elseif self.play_index == 38 then
					if self ~= nil and self.roots ~= nil then
						state_machine.excute("hero_develop_play_hero_animation",0,14)
					end	
				elseif self.play_index == self.animation_index then
					if self ~= nil and self.roots ~= nil then
						state_machine.excute("hero_develop_play_hero_animation",0,0)
					end
				end	
		    end

		    armature_hero._self = self
	    	armature_hero:getAnimation():setFrameEventCallFunc(onFrameEventRole)
		    armature_hero._invoke = changeActionCallback
		    armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		    csb.animationChangeToAction(self.armature_hero, actionIndex, 0, false)
	    	armature_hero._nextAction = 0

	    	if self.effic_id ~= nil then
				local armature_effic = sp.spine_effect(self.effic_id, effectAnimations[1], false, nil, nil, nil)	
				self.armature_effic = armature_effic
				sp.initArmature(self.armature_effic, false)
				armature_effic.animationNameList = effectAnimations
				self.armature_effic:setVisible(false)
				armature_hero:addChild(armature_effic)
			    local function changeActionEfficCallback( armatureBack )	
					armatureBack:setVisible(false)
			    end
			    armature_effic._invoke = changeActionEfficCallback
			    armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)			    		
	    	end

	    	if self.normal_effic_id ~= nil then
				local normal_armature_effic = sp.spine_effect(self.normal_effic_id, effectAnimations[1], false, nil, nil, nil)	
				self.normal_armature_effic = normal_armature_effic
				sp.initArmature(self.normal_armature_effic, false)
				normal_armature_effic.animationNameList = effectAnimations
				self.normal_armature_effic:setVisible(false)
				armature_hero:addChild(normal_armature_effic)
			    local function changeActionEfficCallback( armatureBack )	
					armatureBack:setVisible(false)
			    end
			    normal_armature_effic._invoke = changeActionEfficCallback
			    normal_armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)	
	    	end

			local shipid = tonumber(ship.ship_template_id)
			local soundid = dms.string(dms["ship_mould"], shipid, ship_mould.sound_index)
			playEffectExt(formatMusicFile("effect", soundid))
		end
    	state_machine.excute("hero_develop_play_hero_animation",0,"begin")
		-- local lv =ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lv")
		-- local lan=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lan")
		-- local zi=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_zi")
		-- local cheng=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_cheng")
		-- local hong=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_hong")
		-- if quality == 0 then
		-- 	--print("白色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(false)
		-- elseif quality == 1 then
		-- 	--print("绿色")
		-- 	lv:setVisible(true)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(false)
		-- elseif quality == 2 then
		-- 	--print("蓝色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(true)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(false)
		-- elseif quality == 3 then
		-- 	--print("紫色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(true)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(false)
		-- elseif quality == 4 then
		-- 	--print("橙色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(true)
		-- 	hong:setVisible(false)
		-- elseif quality == 5 then
		-- 	--print("红色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(true)			
		-- end	
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) or __lua_project_id == __lua_project_l_naruto then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) then
			self:updateEquipDraw()
		end
		self:updatePagePush()
    	state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_evolution_button")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_up_grade_button")
	end
end

function HeroDevelop:updatePagePush()
	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_evolution_page_tip")
    state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_up_grade_star_page_tip")
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
    	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_evo")
    	state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_upgrade")
		state_machine.excute("notification_center_update",0,"push_notification_center_develop_equip_awake")
		-- 装备淬炼推送
		state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_harden_page_tips") 
    end
end
function HeroDevelop:onUpdateDrawTitle( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		local Panel_title_name = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_title_name")
		Panel_title_name:removeBackGroundImage()
		Panel_title_name:setBackGroundImage("images/ui/text/line_tab_title_"..self.pageshowindex..".png")
	end
end

function HeroDevelop:onUpdateDrawButton() 
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local Button_shengji = ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji")
		local Button_tupo = ccui.Helper:seekWidgetByName(self.roots[1], "Button_tupo")
		local Button_peiyang = ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang")
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			Button_shengji:setTouchEnabled(true)
			if self.pageshowindex == 2 then
				Button_shengji:setHighlighted(false)
				Button_shengji:setBright(true)
				Button_shengji:setHighlighted(true)
			else
				Button_shengji:setBright(true)
			end
		else
			if tonumber(_ED.user_ship[""..self.shipId].ship_base_template_id) == 1 
				or tonumber(_ED.user_ship[""..self.shipId].ship_grade) >= tonumber(_ED.user_info.user_grade) then
				Button_shengji:setBright(false)
				Button_shengji:setTouchEnabled(false)
				Button_shengji:setHighlighted(false)
			else
				Button_shengji:setTouchEnabled(true)
				if self.pageshowindex == 2 then
					Button_shengji:setHighlighted(false)
					Button_shengji:setBright(true)
					Button_shengji:setHighlighted(true)
				else
					Button_shengji:setBright(true)
				end
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			if tonumber(_ED.user_ship[""..self.shipId].ship_template_id) == 1148 or tonumber(_ED.user_ship[""..self.shipId].ship_template_id) == 1149 or
				 tonumber(_ED.user_ship[""..self.shipId].ship_template_id) == 1150 then
				Button_tupo:setBright(false)
				Button_tupo:setTouchEnabled(false)
				Button_tupo:setHighlighted(false)
			else
				Button_tupo:setTouchEnabled(true)

				if self.pageshowindex == 3 then
					Button_tupo:setHighlighted(true)
				else
					Button_tupo:setBright(true)
				end
			end
			
			if dms.int(dms["ship_mould"], _ED.user_ship[""..self.shipId].ship_template_id, ship_mould.grow_target_id) == -1 then
				Button_tupo:setBright(false)
				Button_tupo:setTouchEnabled(false)
				Button_tupo:setHighlighted(false)
			else
				Button_tupo:setTouchEnabled(true)
				if self.pageshowindex == 3 then
					Button_tupo:setHighlighted(true)
				else
					Button_tupo:setBright(true)
				end
			end
		end
	end
end


--检测英雄是否可以觉醒
function HeroDevelop:checkHeroCanAwaken()
	local ship_template_id = _ED.user_ship[""..self.shipId].ship_template_id
	local isOpen = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level) <= zstring.tonumber(_ED.user_ship[""..self.shipId].ship_grade)
	local captain =  dms.int(dms["ship_mould"], ship_template_id, ship_mould.captain_type) == 0 
	local requirement = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould2) --能否觉醒
	--主角 红橙将可以觉醒
	if captain == true or requirement ~= -1 then
		if isOpen == true then 
			--级别够了
		else
			return false
		end
	else
		return false
	end
	--计算是否满级
	local requirement = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould2)
	local grouds = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, requirement)
	local awaken_info = nil
	if grouds ~= nil then 
        for i, v in pairs(grouds) do
            if tonumber(v[3]) == tonumber(_ED.user_ship[""..self.shipId].awakenLevel) then
               awaken_info = v 
               break
            end
        end
	end
	if awaken_info ~= nil and zstring.tonumber(awaken_info[4]) == -1 then 
		--满级
		return false
	else
		return true
	end
	return true
end

function HeroDevelop:updateRefreshAwakenButtonStates()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self.isAwaken = self:checkHeroCanAwaken()
end

function HeroDevelop:UpdateButtonDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	if #self._m_button_list_y > 1 then
		local Button_shengji = ccui.Helper:seekWidgetByName(root, "Button_shengji")
		local Button_peiyang = ccui.Helper:seekWidgetByName(root, "Button_peiyang")
		local Button_tianming = ccui.Helper:seekWidgetByName(root, "Button_tianming")
		local Button_tupo = ccui.Helper:seekWidgetByName(root, "Button_tupo")
		local Button_douhun = ccui.Helper:seekWidgetByName(root, "Button_douhun")
		local Button_chaojinhua = ccui.Helper:seekWidgetByName(root, "Button_chaojinhua")
		local Button_zhanhun = ccui.Helper:seekWidgetByName(root, "Button_zhanhun")
		local index = 0
		--根据功能进行排序和显示
		if Button_shengji ~= nil then
			if funOpenDrawTip(100,false) == true then
				Button_shengji:setVisible(false)
			else
				Button_shengji:setVisible(true)
				index = index + 1
				Button_shengji:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_peiyang ~= nil then
			if funOpenDrawTip(102,false) == true then
				Button_peiyang:setVisible(false)
			else
				Button_peiyang:setVisible(true)
				index = index + 1
				Button_peiyang:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_tianming ~= nil then
			if funOpenDrawTip(103,false) == true then
				Button_tianming:setVisible(false)
			else
				Button_tianming:setVisible(true)
				index = index + 1
				Button_tianming:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_tupo ~= nil then
			if funOpenDrawTip(101,false) == true then
				Button_tupo:setVisible(false)
			else
				Button_tupo:setVisible(true)
				index = index + 1
				Button_tupo:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_zhanhun ~= nil then
			if funOpenDrawTip(201,false) == true then
				Button_zhanhun:setVisible(false)
			else
				Button_zhanhun:setVisible(true)
				index = index + 1
				Button_zhanhun:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_douhun ~= nil then
			if funOpenDrawTip(104,false) == true then
				Button_douhun:setVisible(false)
			else
				Button_douhun:setVisible(true)
				index = index + 1
				Button_douhun:setPositionY(self._m_button_list_y[index])
			end
		end
		if Button_chaojinhua ~= nil then
			if funOpenDrawTip(189,false) == true then
				Button_chaojinhua:setVisible(false)
			else
				Button_chaojinhua:setVisible(true)
				index = index + 1
				Button_chaojinhua:setPositionY(self._m_button_list_y[index])
			end
		end
	end
end

-- DSC重塑
function HeroDevelop:updateDrawInstance()
	local root = self.roots[1]

	local role = ccui.Helper:seekWidgetByName(root, "Panel_hero_110")
	local equipLeft = ccui.Helper:seekWidgetByName(root, "Panel_17_2")

	local director = cc.Director:getInstance()
	local glView = director:getOpenGLView()

	local pos1 = fwin:convertToWorldSpaceAR( root, cc.p(role:getPositionX() , role:getPositionY()))
	local pos2 = fwin:convertToWorldSpaceAR( root, cc.p(equipLeft:getPositionX() , equipLeft:getPositionY()))
	local frameScreen = tonumber(glView:getFrameSize().width) / tonumber(glView:getFrameSize().height)
	local designScreen = tonumber(app.designSize.width) / tonumber(app.designSize.height)
	local scale = frameScreen / designScreen
	if scale < 1 then
		scale = 1
	end

	local result = ((pos1.x - pos2.x) * (scale - 1))
	return result
end

-- DSC重塑
function HeroDevelop:moveDistance(distance , index , node)
	if index == 1 or index == 2 or index == 4 then
		node:setPosition(node:getPositionX() + distance , node:getPositionY()-3)
	else
		node:setPosition(node:getPositionX() - distance , node:getPositionY()-3)
	end
end

function HeroDevelop:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_qianghua.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(true)
	table.insert(self.roots, root)
    self:addChild(root)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		local action = csb.createTimeline("packs/HeroStorage/generals_qianghua.csb")
		table.insert(self.actions, action)
		local csbFormation = root:getParent()
		csbFormation:runAction(action)
		self.isLineEffice = true
		local file_path = "images/ui/effice/effect_line/effect_line.ExportJson"
		local armature_name = "effect_line"
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(file_path)
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_hero_110")
		local cell = ccs.Armature:create(armature_name)
		cell:getAnimation():playWithIndex(0)
		panel:addChild(cell)
		action:play("animation_open", false)
		action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "open" then
	        elseif str == "close" then
	            state_machine.excute("hero_develop_page_close", 0, 0)
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
	    if fwin:find("PathGrowthClass") then
			fwin:close(fwin:find("PathGrowthClass"))
		end
	end
    self:onUpdateDraw()
    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,self.onUpdateDrawHero,self)
	end
    local tempIsPressedActionEnabled = true
    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
    	tempIsPressedActionEnabled = false
   	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_red_alert 
		then
		self:onUpdateDrawTitle()
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			local Button_fanhui = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_fanhui"), nil, 
			{
				terminal_name = "hero_develop_back_to_home_activity", 
				shipId = self.shipId,
				isPressedActionEnabled = true
			}, 
			nil, 2)
		else
			local Button_fanhui = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_fanhui"), nil, 
			{
				terminal_name = "hero_develop_page_close", 
				shipId = self.shipId,
				isPressedActionEnabled = true
			}, 
			nil, 2)
		end
		
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then

		local Button_xiangqin = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_xiangqin"), nil, 
		{
			terminal_name = "hero_develop_page_manager", 	
			next_terminal_name = "hero_develop_page_open_hero_information_page", 			
			current_button_name = "Button_xiangqin", 	
			but_image = "", 	
			shipId = self.shipId,
			terminal_state = 0, 
			openWinId = -1,
			isPressedActionEnabled = tempIsPressedActionEnabled
		}, 
		nil, 0)
		-- print("========",self.types)
		if self.types == "pack" then
			if Button_xiangqin ~= nil then
				Button_xiangqin:setVisible(true)
			end
			if Button_zhuangbei ~= nil then
				Button_zhuangbei:setVisible(false)
			end
		end
	end
	local Button_xinxi = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_xinxi"), nil, 
	{
		terminal_name = "hero_develop_page_manager", 	
		next_terminal_name = "hero_develop_page_open_hero_information_page", 			
		current_button_name = "Button_xinxi", 	
		but_image = "", 	
		shipId = self.shipId,
		terminal_state = 0, 
		openWinId = -1,
		isPressedActionEnabled = tempIsPressedActionEnabled
	}, 
	nil, 0)
	local features_1_id = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		features_1_id = 100
	else
		features_1_id = 33
	end
	if ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji")._y == nil then
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji"):getPositionY()
	end
	local Button_shengji = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji"), nil, 
	{
		terminal_name = "hero_develop_page_manager", 	
		next_terminal_name = "hero_develop_page_open_strengthen_page", 			
		current_button_name = "Button_shengji", 	
		but_image = "", 	
		shipId = self.shipId,
		terminal_state = 0, 
		openWinId = features_1_id,
		isPressedActionEnabled = tempIsPressedActionEnabled
	}, 
	nil, 0)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_evolution_page_tip",
		_widget = ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji"),
		_invoke = nil,
		_interval = 0.5,})
	end
	

	local features_2_id = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		features_2_id = 101
	else
		features_2_id = 34
	end
	if ccui.Helper:seekWidgetByName(self.roots[1], "Button_tupo")._y == nil then
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_tupo")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Button_tupo"):getPositionY()
	end
	local Button_tupo = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_tupo"), nil, 
	{
		terminal_name = "hero_develop_page_manager", 	
		next_terminal_name = "hero_develop_page_open_advanced", 			
		current_button_name = "Button_tupo", 	
		but_image = "", 	
		shipId = self.shipId,
		terminal_state = 0, 
		openWinId = features_2_id,
		isPressedActionEnabled = tempIsPressedActionEnabled
	},
	nil, 0)
	
	local features_3_id = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		features_3_id = 102
	else
		features_3_id = 3
	end
	if ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang")._y == nil then
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang"):getPositionY()
	end
	local Button_peiyang = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang"), nil, 
	{
		terminal_name = "hero_develop_page_manager", 	
		next_terminal_name = "hero_develop_page_open_train_page", 			
		current_button_name = "Button_peiyang", 	
		but_image = "", 	
		shipId = self.shipId,
		terminal_state = 0, 
		openWinId = features_3_id,
		isPressedActionEnabled = tempIsPressedActionEnabled
	}, 
	nil, 0)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_up_grade_star_page_tip",
		_widget = ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang"),
		_invoke = nil,
		_interval = 0.5,})
	end
	
	local features_4_id = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		features_4_id = 103
	else
		features_4_id = 4
	end
	if ccui.Helper:seekWidgetByName(self.roots[1], "Button_tianming")._y == nil then
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_tianming")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Button_tianming"):getPositionY()
	end
	local Button_tianming = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_tianming"), nil, 
	{
		terminal_name = "hero_develop_page_manager", 	
		next_terminal_name = "hero_develop_page_open_skill_stren_page", 			
		current_button_name = "Button_tianming", 	
		but_image = "", 	
		shipId = self.shipId,
		terminal_state = 0, 
		openWinId = features_4_id,
		isPressedActionEnabled = tempIsPressedActionEnabled
	}, 
	nil, 0)
	
	local Button_chaojinhua = ccui.Helper:seekWidgetByName(self.roots[1], "Button_chaojinhua")
	if Button_chaojinhua then
		--超进化
		if ccui.Helper:seekWidgetByName(self.roots[1], "Button_chaojinhua")._y == nil then
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_chaojinhua")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Button_chaojinhua"):getPositionY()
		end
		Button_chaojinhua = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_chaojinhua"), nil, 
		{
			terminal_name = "hero_develop_page_manager", 	
			next_terminal_name = "hero_develop_page_open_mega", 			
			current_button_name = "Button_chaojinhua", 	
			but_image = "", 	
			shipId = self.shipId,
			terminal_state = 0, 
			openWinId = 189,
			isPressedActionEnabled = tempIsPressedActionEnabled
		}, 
		nil, 0)
	else
		-- Button_chaojinhua = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_chaojinhua"), nil, 
		-- {
		-- 	terminal_name = "hero_develop_page_manager", 	
		-- 	next_terminal_name = "hero_develop_page_open_juexin", 			
		-- 	current_button_name = "Button_chaojinhua", 	
		-- 	but_image = "", 	
		-- 	shipId = self.shipId,
		-- 	terminal_state = 0, 
		-- 	openWinId = 6,
		-- 	isPressedActionEnabled = tempIsPressedActionEnabled
		-- }, 
		-- nil, 0)
	end

	local Button_zhanhun = ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanhun")
	if Button_zhanhun then
		--战魂
		if ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanhun")._y == nil then
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanhun")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanhun"):getPositionY()
		end
		Button_zhanhun = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanhun"), nil, 
		{
			terminal_name = "hero_develop_page_manager", 	
			next_terminal_name = "hero_develop_page_open_fight_spirit", 			
			current_button_name = "Button_zhanhun", 	
			but_image = "", 	
			shipId = self.shipId,
			terminal_state = 0, 
			openWinId = 201,
			isPressedActionEnabled = tempIsPressedActionEnabled
		}, 
		nil, 0)
	else
		-- Button_zhanhun = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanhun"), nil, 
		-- {
		-- 	terminal_name = "hero_develop_page_manager", 	
		-- 	next_terminal_name = "hero_develop_page_open_juexin", 			
		-- 	current_button_name = "Button_zhanhun", 	
		-- 	but_image = "", 	
		-- 	shipId = self.shipId,
		-- 	terminal_state = 0, 
		-- 	openWinId = 6,
		-- 	isPressedActionEnabled = tempIsPressedActionEnabled
		-- }, 
		-- nil, 0)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		if tonumber(_ED.user_ship[""..self.shipId].ship_base_template_id) == 1 then
			Button_shengji:setBright(false)
			Button_shengji:setTouchEnabled(false)
		end
		if tonumber(_ED.user_ship[""..self.shipId].ship_template_id) == 1148 or tonumber(_ED.user_ship[""..self.shipId].ship_template_id) == 1149 or
			 tonumber(_ED.user_ship[""..self.shipId].ship_template_id) == 1150 then
			Button_tupo:setBright(false)
			Button_tupo:setTouchEnabled(false)
		end
		
		if dms.int(dms["ship_mould"], _ED.user_ship[""..self.shipId].ship_template_id, ship_mould.grow_target_id) == -1 then
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				Button_tupo:setBright(false)
				Button_tupo:setTouchEnabled(false)
			end
		end
	end
	
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_yugioh
		then 
		self.isAwaken = self:checkHeroCanAwaken()
	end

	local id = dms.int(dms["ship_mould"], _ED.user_ship[""..self.shipId].ship_template_id, ship_mould.cultivate_property_id)
	local maxOne = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_life)					--生命培养上限
	local maxTwo = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_attack)				--攻击培养上限
	local maxThree = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_physical_defence)		--物防培养上限
	local maxFour = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_skill_defence)
	if tonumber(_ED.user_ship[""..self.shipId].ship_train_info.train_life) == maxOne and tonumber(_ED.user_ship[""..self.shipId].ship_train_info.train_attack) == maxTwo and
		tonumber(_ED.user_ship[""..self.shipId].ship_train_info.train_physical_defence) == maxThree and tonumber(_ED.user_ship[""..self.shipId].ship_train_info.train_skill_defence) == maxFour then
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			--这里设置成能点击，进去之后店培养再有提示
		else
			Button_peiyang:setBright(false)
			Button_peiyang:setTouchEnabled(false)
		end
	end
	local Button_qianghua_back = ccui.Helper:seekWidgetByName(self.roots[1], "Button_qianghua_back")
	if Button_qianghua_back ~= nil then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			fwin:addTouchEventListener(Button_qianghua_back, nil, 
			{
				terminal_name = "hero_develop_back_to_home_activity", 
				shipId = self.shipId,
				isPressedActionEnabled = true
			}, 
			nil, 2)
		else
			fwin:addTouchEventListener(Button_qianghua_back, nil, 
			{
				terminal_name = "hero_develop_page_close", 
				shipId = self.shipId,
				isPressedActionEnabled = true
			}, 
			nil, 2)
		end
	end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		--临时隐藏
		if ccui.Helper:seekWidgetByName(self.roots[1], "Button_douhun")._y == nil then
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_douhun")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Button_douhun"):getPositionY()
		end
		local Button_douhun = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_douhun"), nil, 
		{
			terminal_name = "hero_develop_page_manager", 	
			next_terminal_name = "hero_develop_page_open_fighting_spirit", 			
			current_button_name = "Button_douhun", 	
			but_image = "", 	
			shipId = self.shipId,
			terminal_state = 0, 
			openWinId = 104,
			isPressedActionEnabled = tempIsPressedActionEnabled
		}, 
		nil, 0)

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) then
			--记录7个按钮的位置
			self._m_button_list_y = {}
			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji") ~= nil then
				table.insert(self._m_button_list_y, ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji")._y)
			end
			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang") ~= nil then
				table.insert(self._m_button_list_y, ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang")._y)
			end
			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_tianming") ~= nil then
				table.insert(self._m_button_list_y, ccui.Helper:seekWidgetByName(self.roots[1], "Button_tianming")._y)
			end
			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_tupo") ~= nil then
				table.insert(self._m_button_list_y, ccui.Helper:seekWidgetByName(self.roots[1], "Button_tupo")._y)
			end
			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanhun") ~= nil then
				table.insert(self._m_button_list_y, ccui.Helper:seekWidgetByName(self.roots[1], "Button_zhanhun")._y)
			end
			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_douhun") ~= nil then
				table.insert(self._m_button_list_y, ccui.Helper:seekWidgetByName(self.roots[1], "Button_douhun")._y)
			end
			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_chaojinhua") ~= nil then
				table.insert(self._m_button_list_y, ccui.Helper:seekWidgetByName(self.roots[1], "Button_chaojinhua")._y)
			end
			
			if ccui.Helper:seekWidgetByName(self.roots[1], "Button_shengji") ~= nil then
				self:UpdateButtonDraw()
			end
		end
		self:shipListDraw()
		self:firstIconIndex(fundShipWidthId(self.shipId))
		self:onUpdateDrawHero()

		local Panel_role_streng_tab = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_streng_tab")
		--打开对应2级界面下的2级界面
		app.load("client.packs.hero.SmRoleStrengthenTab")
		state_machine.excute("sm_role_strengthen_tab_open",0,{Panel_role_streng_tab,self.shipId})
		if zstring.tonumber(self._m_type) == 0 then
			state_machine.excute("hero_develop_page_manager",0,{_datas = {next_terminal_name = "hero_develop_page_open_strengthen_page", 			
			current_button_name = "Button_shengji", 	
			but_image = "", 	
			shipId = self.shipId,
			terminal_state = 0, 
			openWinId = 33,
			isPressedActionEnabled = tempIsPressedActionEnabled}})
		else
			state_machine.excute("hero_develop_page_manager",0,{_datas = {next_terminal_name = "hero_develop_page_open_equip_up", 			
			current_button_name = "Button_qianghua", 	
			but_image = "", 	
			shipId = self.shipId,
			terminal_state = 0, 
			openWinId = 96,
			isPressedActionEnabled = tempIsPressedActionEnabled}})
		end
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_digimon_qh/effice_digimon_qh.ExportJson")
	end
	app.load("client.player.UserInformationHeroStorage")
	-- fwin:open(UserInformationHeroStorage:new(), fwin._ui)
	local userInformationHeroStorage = UserInformationHeroStorage:new()
	userInformationHeroStorage._rootWindows = self
	fwin:open(userInformationHeroStorage,fwin._view)
end
function HeroDevelop:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local Panel_hero_110 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_110")
		Panel_hero_110:removeAllChildren(true)
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local Panel_role_streng_tab = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_streng_tab")
		Panel_role_streng_tab:removeAllChildren(true)
	end
	state_machine.excute("prop_warehouse_update_draw_page", 0, nil)
end
function HeroDevelop:onExit()
	state_machine.remove("hero_develop_page_manager")
	state_machine.remove("hero_develop_page_close")
	state_machine.remove("hero_develop_page_open_hero_information_page")
	state_machine.remove("hero_develop_page_open_strengthen_page")
	state_machine.remove("hero_develop_page_open_advanced")
	state_machine.remove("hero_develop_page_open_train_page")
	state_machine.remove("hero_develop_page_open_skill_stren_page")
	state_machine.remove("hero_develop_page_open_juexin")
	state_machine.remove("hero_develop_page_change_button")
	state_machine.remove("hero_develop_page_update")
	state_machine.remove("hero_develop_page_update_for_icon")
    state_machine.remove("hero_develop_update_hero")
    state_machine.remove("hero_develop_hero_hide")	
    state_machine.remove("hero_develop_page_show_equip")
    state_machine.remove("hero_develop_page_hidden_nowpage")
    state_machine.remove("hero_develop_page_show_nowpage")    
    state_machine.remove("hero_develop_play_hero_animation")
    state_machine.remove("hero_develop_update_skill")
    state_machine.remove("hero_develop_hero_show")
    state_machine.remove("hero_develop_page_strength_to_highlighted")
    state_machine.remove("hero_develop_page_updata_hero_icon_push")
end

function HeroDevelop:init(shipId, types, m_type)
	self.shipId = shipId
	self.types = types
	if m_type == nil then
		self._m_type = 0
	else
		self._m_type = m_type
	end
	-- print("=============",shipId)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.animation_index,self.effic_id = self:getSkillAnimationIndex()
		if self.effic_id ~= nil then
	        if tonumber(_ED.user_info.user_gender) == 1 then --男默认技能
	            self.normal_effic_id = user_skill_effic_id[1]
	        elseif tonumber(_ED.user_info.user_gender) == 2 then 
	            self.normal_effic_id = user_skill_effic_id[2]
	        end
		end
	end
end

function HeroDevelop:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end