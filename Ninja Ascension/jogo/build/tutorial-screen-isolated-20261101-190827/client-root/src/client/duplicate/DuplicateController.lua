-- ----------------------------------------------------------------------------------------------------
-- -- 说明：副本界面PageView
-- -------------------------------------------------------------------------------------------------------

DuplicateController = nil

local is2003 = false
local is2002 = false
if __lua_project_id == __lua_project_warship_girl_a 
or __lua_project_id == __lua_project_warship_girl_b 
or __lua_project_id == __lua_project_digimon_adventure 
or __lua_project_id == __lua_project_naruto 
or __lua_project_id == __lua_project_pokemon 
or __lua_project_id == __lua_project_rouge 
or __lua_project_id == __lua_project_yugioh 
or __lua_project_id == __lua_project_koone
or __lua_project_id == __lua_project_red_alert_time 
or __lua_project_id == __lua_project_pacific_rim 
then
	if dev_version >= 2003 then
		is2003 = true
	end
	if dev_version >= 2002 then
		is2002 = true
	end
end
							
if is2002 == true then
	DuplicateController = class("DuplicateControllerClass", Window)

	function DuplicateController:ctor()
		self.super:ctor()

		-- 定义封装类中的变量
		self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
		
		self.sceneID = -1			--当前的关卡id
		self.npcIndex = -1			--npcIndex
		self.copyId = -1 			--NPC的ID号，目前用于日常活动副本 
		
		self.sceneNameText = nil
		self.sceneChapterText = nil
		self.currentPageType = 1    -- 1 普通2精英 3 日常 4 名将
		self.currentSceneType = 0  -- 0 普通1精英 9名将 pve_scene.scene_type
		self.currentCopyPadTile = nil
		
		if _ED._last_page_type ~= 1 then
			_ED._current_scene_id = 0
			_ED._current_seat_index = -1
		end
		
		app.load("client.duplicate.pve.PVEMapInformation") 					--顶部用户信息
		
		-- 初始化武将小像事件响应需要使用的状态机
		local function init_duplicate_page_controller_terminal()
			-- 主界面的管理器
			local duplicate_controller_manager_terminal = {
				_name = "duplicate_controller_manager",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					if true == params._datas.isClear then
						_ED._last_page_type = 0
						_ED._current_scene_id = 0
						_ED._current_seat_index = -1
					end

					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_warship_girl_b
						or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
						or __lua_project_id == __lua_project_yugioh 
						then 
						--精英副本判断条件
						if params._datas.next_terminal_name == "duplicate_controller_elite_copy_page" then 

							local user_grade=dms.int(dms["fun_open_condition"], 26, fun_open_condition.level)
							if user_grade > zstring.tonumber(_ED.user_info.user_grade) then
								TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 26, fun_open_condition.tip_info))
								return true
							end
						end

					end
					if terminal.last_terminal_name ~= params._datas.next_terminal_name then
						-- -- hide child window
		 --        		for i, v in pairs(instance.group) do
						-- 	if v ~= nil then
						-- 		v:setVisible(false)
						-- 	end
						-- end
						if state_machine.excute(params._datas.next_terminal_name, 0, params) == true then
							terminal.last_terminal_name = params._datas.next_terminal_name
						else
							return false
						end
						
					end
					--_ED._current_seat_index = -1
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

			--强制关闭【副本】主界面
			local duplicate_page_controller_close_terminal = {
				_name = "duplicate_page_controller_close",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					state_machine.excute("page_stage_general_close", 0, "event page_stage_general_close.")
					fwin:close(instance)
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			--打开【副本】主界面
			local duplicate_page_controller_open_terminal = {
				_name = "duplicate_page_controller_open",
				_init = function (terminal)
					-- app.load("client.player.UserInformationForDuplicate")
					app.load("client.duplicate.pve.PVEStage")
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					--todo------------------------
					fwin:close(fwin:find("PVEStageClass"))
					state_machine.excute("pve_raid_select_close", 0, "")
					state_machine.excute("pve_daily_activity_copy_close", 0, "")
					local pveStage = PVEStage:new()
					pveStage:init(instance.sceneID)
					fwin:open(pveStage, fwin._background)
					instance:onInitInfo()
					--显示场景数据
					state_machine.excute("page_stage_update_information", 0, { sceneID = instance.sceneID, npcIndex = instance.npcIndex,currentPageType = instance.currentPageType })
					
					-- --state_machine.excute("page_view_calc_scroll_position", 0, "event page_view_calc_scroll_position.")

					state_machine.excute("duplicate_controller_copy_page", 0, "")
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			--跳转副本场景
			local duplicate_page_controller_change_scene_terminal = {
				_name = "duplicate_page_controller_change_scene",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					--todo------------------------
					instance.sceneID = params._datas.sceneID
					instance.npcIndex = -1
					
					--if zstring.tonumber(_ED._current_scene_id) == 0 then
						_ED._current_scene_id = params._datas.sceneID
					--end
					
					_ED._current_seat_index = -1
					local sceneType = dms.int(dms["pve_scene"], instance.sceneID, pve_scene.scene_type) 
					instance:changeToPage(params._datas.currentPageType or instance.currentPageType, sceneType)
					-- instance:updateCurrentCopyInfo()
					instance:onInitInfo()
					state_machine.excute("page_stage_update_information", 0, { sceneID = instance.sceneID, npcIndex = instance.npcIndex ,currentPageType = instance.currentPageType,isGotoNPC = params._datas.isGotoNPC})
					state_machine.excute("pve_raid_select_close", 0, "event pve_raid_select_close.")
					
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			--打开选择【副本】弹窗
			local duplicate_select_raid_panel_terminal = {
				_name = "duplicate_select_raid_panel",
				_init = function (terminal)
					--app.load("client.duplicate.pve.PVERaidSelectPanel")
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					--fwin:open(PVERaidSelectPanel:new():init(instance.currentPageType, instance.currentSceneType), fwin._view)
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 关闭副本界面
			local duplicate_controller_window_close_terminal = {
				_name = "duplicate_controller_window_close",
				_init = function (terminal)

				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					state_machine.excute("home_button_window_show", 0, nil)
					fwin:close(fwin:find("DuplicateControllerClass"))
					fwin:close(fwin:find("PVEStageClass"))
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			--更新已选择的关卡
			local duplicate_update_selected_data_terminal = {
				_name = "duplicate_update_selected_data",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					if instance.currentPageType == 4 then
						instance.copyId = params[1]
					else
						instance.sceneID = params.sceneID			--当前的关卡id
						instance.npcIndex = params.npcIndex			--npcIndex 

						_ED._duplicate_sceneID = instance.sceneID
						_ED._duplicate_npcIndex = math.max(instance.npcIndex - 1,-1)
						
					end
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 名将副本
			local duplicate_select_hight_copy_panel_terminal = {
				_name = "duplicate_select_hight_copy_panel",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					return instance:gotoHightCopyWindow()
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 普通副本
			local duplicate_controller_copy_page_terminal = {
				_name = "duplicate_controller_copy_page",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					-- local sceneType = dms.int(dms["pve_scene"], _ED._current_scene_id, pve_scene.scene_type) 
					-- if sceneType == 9 then
						-- return instance:gotoHightCopyWindow()
					-- end
					return instance:gotoPlotCopyWindow()
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 精英副本
			local duplicate_controller_elite_copy_page_terminal = {
				_name = "duplicate_controller_elite_copy_page",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					return instance:gotoEliteCopyWindow()
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 日常活动副本
			local duplicate_select_daily_activity_copy_panel_terminal = {
				_name = "duplicate_select_daily_activity_copy_panel",
				_init = function (terminal)
					app.load("client.duplicate.pve.PVEDailyActivityCopy")
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					return instance:gotoDailyActivityCopyWindow()
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 切换页面状态
			local duplicate_controller_change_page_terminal = {
				_name = "duplicate_controller_change_page",
				_init = function (terminal)

				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					instance:changeToPage(params[1], params[2])
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 切换页面后更新绘制当前标题信息
			local duplicate_controller_update_draw_tile_info_terminal = {
				_name = "duplicate_controller_update_draw_tile_info",
				_init = function (terminal)

				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					instance:onInitInfo()
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 精英副本
			local duplicate_select_panel_elite_copy_terminal = {
				_name = "duplicate_select_panel_elite_copy",
				_init = function (terminal) 
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)

					local user_grade=dms.int(dms["fun_open_condition"], 26, fun_open_condition.level)
					if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_warship_girl_b
							or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
							or __lua_project_id == __lua_project_yugioh 
							then 
							instance:gotoEliteCopyWindow()
						else
							-- instance:init(2, 1)
							-- instance:onUpdateDraw()
						end
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 26, fun_open_condition.tip_info))
						return false
					end
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			
			-- 普通副本
			local duplicate_select_panel_plot_copy_terminal = {
				_name = "duplicate_select_panel_plot_copy",
				_init = function (terminal) 
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					instance:onInitInfo()
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			-- 精英普通菜单按钮选择
			local duplicate_select_menu_button_terminal = {
				_name = "duplicate_select_menu_button",
				_init = function (terminal) 
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					local index = params._datas.button_type
					if index == 2 then 
						--普通
						state_machine.excute("duplicate_controller_manager", 0, 
						{
							_datas = {
								terminal_name = "duplicate_controller_manager",     
								next_terminal_name = "duplicate_controller_copy_page",       
								current_button_name = "Button_ptfb_2",    
								but_image = "Image_copy",       
								terminal_state = 0, 
								isPressedActionEnabled = true,
								isClear = true
							}
						})
				
					else
						--精英
						state_machine.excute("duplicate_controller_manager", 0, 
						{
							_datas = {
								terminal_name = "duplicate_controller_manager",     
								next_terminal_name = "duplicate_controller_elite_copy_page",       
								current_button_name = "Button_jingyingbt",    

								terminal_state = 0, 
								isPressedActionEnabled = true,
								isClear = true
							}
						})
			
					end
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			state_machine.add(duplicate_select_panel_plot_copy_terminal)
			state_machine.add(duplicate_select_panel_elite_copy_terminal)
			state_machine.add(duplicate_controller_manager_terminal)
			state_machine.add(duplicate_page_controller_open_terminal)
			state_machine.add(duplicate_select_raid_panel_terminal)
			state_machine.add(duplicate_page_controller_close_terminal)
			state_machine.add(duplicate_page_controller_change_scene_terminal)
			state_machine.add(duplicate_update_selected_data_terminal)
			state_machine.add(duplicate_select_hight_copy_panel_terminal)
			state_machine.add(duplicate_controller_copy_page_terminal)
			state_machine.add(duplicate_select_daily_activity_copy_panel_terminal)
			state_machine.add(duplicate_controller_change_page_terminal)
			state_machine.add(duplicate_controller_update_draw_tile_info_terminal)
			state_machine.add(duplicate_controller_elite_copy_page_terminal)
			state_machine.add(duplicate_select_menu_button_terminal)
			state_machine.add(duplicate_controller_window_close_terminal)
			
			state_machine.init()
		end
		init_duplicate_page_controller_terminal()

		-- 
		self:onInit()
	end

	function DuplicateController:changeToPage(_currentPageType, _currentSceneType)
		self.currentPageType = _currentPageType
		self.currentSceneType = _currentSceneType
		_ED._last_page_type = self.currentPageType
	end

	function DuplicateController:gotoHightCopyWindow()
		local user_grade=dms.int(dms["fun_open_condition"], 18, fun_open_condition.level)
		if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
			
		else
			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 18, fun_open_condition.tip_info))
			return false
		end

		-- 判断副本开启状态
		local lastSceneId, firstScene = self:getOpenMaxSceneId(9)
		if lastSceneId < 0 then
			local dySceneDes = dms.atos(firstScene, pve_scene.open_condition_describe)
			TipDlg.drawTextDailog(dySceneDes)
			return
		end

		--> print("名将副本")
		fwin:close(fwin:find("PVEStageClass"))
		if self.currentPageType ~= 1 then
			_ED._current_scene_id = 0
			_ED._current_seat_index = -1
		end

		self:changeToPage(3, 9)
		self:updateCurrentCopyInfo()
		self:onInitInfo()
		-- fwin:open(PVEStage:new():init(self.sceneID,2), fwin._background)
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			state_machine.excute("lduplicate_window_manager", 0, {3})
		else
			state_machine.excute("page_stage_open_instance_window", 0, {sceneID = self.sceneID, sceneType = 2})
		end
		state_machine.excute("page_stage_update_information", 0, { sceneID = self.sceneID, npcIndex = -1, currentPageType = self.currentPageType})
		state_machine.excute("pve_raid_select_close", 0, "")
		state_machine.excute("pve_daily_activity_copy_close", 0, "")
		return true
	end

	--切换到普通副本
	function DuplicateController:gotoPlotCopyWindow()
		fwin:close(fwin:find("PVEStageClass"))
		state_machine.excute("pve_raid_select_close", 0, "")
		state_machine.excute("pve_daily_activity_copy_close", 0, "")
		if self.currentPageType ~= 1 then
			_ED._current_scene_id = 0
			_ED._current_seat_index = -1
		end

		if self.currentPageType == nil then
			self.currentPageType = 1
		end

		self:changeToPage(1, 0)
		self:updateCurrentCopyInfo()
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			-- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
			then
			state_machine.excute("lduplicate_window_manager", 0, {1})
		else
			state_machine.excute("page_stage_open_instance_window", 0, {sceneID = self.sceneID, sceneType = 1})
		end
		
		self:onInitInfo()
		-- --显示场景数据
		state_machine.excute("page_stage_update_information", 0, { sceneID = self.sceneID, npcIndex = self.npcIndex, currentPageType = self.currentPageType})
		return true
	end

	--切换到精英副本
	function DuplicateController:gotoEliteCopyWindow()
		fwin:close(fwin:find("PVEStageClass"))
		state_machine.excute("pve_raid_select_close", 0, "")
		state_machine.excute("pve_daily_activity_copy_close", 0, "")
		if self.currentPageType ~= 1 then
			_ED._current_scene_id = 0
			_ED._current_seat_index = -1
		end
		
		self:changeToPage(2, 1)
		self:updateCurrentCopyInfo()
		
		state_machine.excute("page_stage_open_instance_window", 0, {sceneID = self.sceneID, sceneType = 3})
	
		self:onInitInfo()
		-- --显示场景数据
		state_machine.excute("page_stage_update_information", 0, { sceneID = self.sceneID, npcIndex = self.npcIndex, currentPageType = self.currentPageType})
		return true
	end
	function DuplicateController:gotoDailyActivityCopyWindow()
		local user_grade=dms.int(dms["fun_open_condition"], 19, fun_open_condition.level)
		if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
			
		else
			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 19, fun_open_condition.tip_info))
			return false
		end
		--> print("日常活动副本")

		self:changeToPage(4, -1)
		self:updateCurrentCopyInfo()
		self:onInitInfo()
		fwin:close(fwin:find("PVEStageClass"))
		state_machine.excute("pve_raid_select_close", 0, "")
		if fwin:find("pveDailyActivityCopyWindow") == nil then
			fwin:open(PVEDailyActivityCopy:new():init(self.copyId), fwin._background)
		end
		return true
	end

	--刷新按钮
	function DuplicateController:onInitInfo()	
		local root = self.roots[1]

		if nil == fwin:find("DuplicateControllerClass") or nil == self.Button_putong or nil == self.Button_jingying or nil == self.principalLine then
			return 
		end
		
		self.Button_putong.isPush = true
		self.Button_ptfb_2.isPush = true
		self.Button_jingying.isPush = true
		self.Button_richang_6.isPush = true
		self.Button_mingjiang_4.isPush = true
		if self.currentPageType == 1 or self.currentPageType == 2 then
			self.principalLine:setVisible(self.currentPageType == 1 and true or false)
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
				or __lua_project_id == __lua_project_yugioh
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
				then 
				self.Button_jingying:setVisible(self.currentPageType == 2)
				self.Button_putong:setVisible(self.currentPageType == 1)
				self.Button_putong:setTouchEnabled(true)
			else
				self.Button_putong:setHighlighted(self.currentPageType == 1 and true or false)
				self.Button_jingying:setHighlighted(self.currentPageType == 2 and true or false)
			end
			
			if self.currentPageType == 1 then
				self.Button_putong.isPush = false
				self.Button_ptfb_2:setHighlighted(true)
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
					or __lua_project_id == __lua_project_yugioh
					then 
					self.Button_jinying_2:setVisible(false)
					self.Button_ptfb_2:setVisible(true)
					self.principalLine:setVisible(true)

				end
				
				self.Button_ptfb_2.isPush = false
			elseif self.currentPageType == 2 then
				self.Button_jingying.isPush = false
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_warship_girl_b
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
					or __lua_project_id == __lua_project_yugioh 
					then 
					self.Button_jinying_2:setHighlighted(true)
					self.Button_jinying_2.isPush = false
					self.Button_jinying_2:setVisible(true)
					self.Button_ptfb_2:setVisible(false)
					self.principalLine:setVisible(true)
				end
			end
			
		elseif self.currentPageType == 3 or self.currentPageType == 4 then
			self.principalLine:setVisible(false)
			self.Button_ptfb_2:setHighlighted(false)
			
			if self.currentPageType == 3 then
				self.Button_mingjiang_4:setHighlighted(true)
				self.Button_mingjiang_4.isPush = false
			elseif self.currentPageType == 4 then
				self.Button_richang_6:setHighlighted(true)
				self.Button_richang_6.isPush = false
			end
		end
		
	end

	function DuplicateController:getOpenMaxSceneId(currentSceneType)
		local lastSceneId = -1
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  then
			currentSceneType = 0
		end
		local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, currentSceneType)
		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				break
			end
			lastSceneId = tempSceneId
		end

		return lastSceneId, _scenes[1]
	end

	function DuplicateController:updateCurrentCopyInfo()
		--设置到最新最后的关卡
		-- self.sceneID = 1		--当前的关卡id
		-- self.npcIndex = -1		--npcIndex 
		local sCountCurrent = 0 --用于记录当前有多少条场景
		local function getOpenSceneList()
			for i = 1,table.getn(_ED.scene_current_state) do
				local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type) 
				--> print(_scene_type)
				if _scene_type == self.currentSceneType then
					if _ED.scene_current_state[i] == nil 
						or _ED.scene_current_state[i] == ""
						or tonumber(_ED.scene_current_state[i]) < 0 then
						return
					end
					sCountCurrent = sCountCurrent + 1
				end
			end
		end

		if tonumber(_ED._current_scene_id) == 0 or _ED._current_scene_id == "" or _ED._current_scene_id == nil or true then
			getOpenSceneList()
			self.sceneID = sCountCurrent
		else
			self.sceneID = _ED._current_scene_id
		end

		if tonumber(_ED._current_seat_index) == 0 or _ED._current_seat_index == "" or _ED._current_seat_index == nil then
			self.npcIndex = -1
		else
			self.npcIndex = _ED._current_seat_index
		end
		
		-- 07/01 修正新版副本的教学指引时屏蔽的
		if  missionIsOver() == false then
		--	_ED._current_scene_id = 0
		--	_ED._current_seat_index = -1
		end

		if self.currentPageType == 4 then
			self.copyId = zstring.tonumber(_ED._daily_copy_npc_id)
			if self.copyId <= 0 then
				self.copyId = 1
			end
			return
		else
			self.copyId = -1
			_ED._daily_copy_npc_id = -1
		end

		local lastSceneId = -1
		local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, self.currentSceneType)
		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				break
			end
			lastSceneId = tempSceneId
		end
		self.sceneID = lastSceneId
		self.npcIndex = -1


		-- 获取下一个场景的开启状态
		local function getNextSceneId(_sceneId)	
			local _scene_type = dms.int(dms["pve_scene"], _sceneId, pve_scene.scene_type)
			local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, _scene_type)
			local _prevSceneId = -1
			local _nextSceneId = -1
			if _scenes ~= nil then
				for i, v in pairs(_scenes) do
					local tempSceneId = dms.atoi(v, pve_scene.id)
					if _prevSceneId == sceneID then
						_nextSceneId = tempSceneId
						return _nextSceneId
					end
					_prevSceneId = tempSceneId
				end
			end
			return nil
		end

		local tempNextSceneId = getNextSceneId(_ED._current_scene_id)
		if tempNextSceneId ~= nil and tonumber(_ED._current_scene_id) > 0 and tonumber(_ED.scene_current_state[tempNextSceneId]) == 0 then
			self.sceneID = tempNextSceneId
			self.npcIndex = -1
		else
			if tonumber(_ED._current_scene_id) == 0 or _ED._current_scene_id == "" or _ED._current_scene_id == nil then
			else
				self.sceneID = _ED._current_scene_id
				--> print("_ED._current_scene_id",_ED._current_scene_id)
			end

			if tonumber(_ED._current_seat_index) == 0 or _ED._current_seat_index == "" or _ED._current_seat_index == nil then
				self.npcIndex = -1
			else
				self.npcIndex = _ED._current_seat_index
				--> print("_ED._current_seat_index",_ED._current_seat_index)
			end
		end
		
		local tIndex = 0
		local maxIndex = 0
		if self.npcIndex > -1 then
			local npcIds = {}
			local npcStates = {}
			local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(self.sceneID), pve_scene.npcs), ",")
			local sceneState = tonumber(_ED.scene_current_state[self.sceneID])
			if sceneState == nil then
				self.sceneID = lastSceneId
				sceneState = tonumber(_ED.scene_current_state[self.sceneID])
			end
			if sceneState ~= nil then
				for i = 1, table.getn(tempNpcIds) do
					local npcState = 0
					if sceneState + 1 == i then
						npcState = 1
					elseif sceneState + 2 == i then
						npcState = 2
						break
					elseif sceneState + 2 < i then
						break
					end
					tIndex = tIndex + 1
					npcIds[tIndex] = tempNpcIds[i]
					npcStates[tIndex] = npcState
				end
				if tIndex > 0 and npcStates[tIndex] == 1 and tIndex == self.npcIndex + 1 then
					self.npcIndex = -1
				end
				maxIndex = table.getn(tempNpcIds)
			else
				self.npcIndex = -1
			end
		end
		-- 解决自动开启下一场景后,跳入下一场景(屏蔽代码) 07/06-------------------------
		-- if tIndex >= maxIndex and  self.sceneID ~= lastSceneId then
			-- sceneState = tonumber(_ED.scene_current_state[lastSceneId])
			-- if sceneState == 0 then
				-- _ED._current_scene_id = lastSceneId
				
				-- ---
				-- local npcIds = {}
				-- local npcStates = {}
				-- local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(_ED._current_scene_id), pve_scene.npcs), ",")
				-- local sceneState = tonumber(_ED.scene_current_state[tonumber(_ED._current_scene_id)])
				-- local tIndex = 1
				-- for i = 1, table.getn(tempNpcIds) do
					-- local npcState = 0
					-- if sceneState + 1 == i then
						-- npcState = 1
					-- elseif sceneState + 2 == i then
						-- npcState = 2
					-- elseif sceneState + 2 < i then
						-- break
					-- end
					-- npcIds[tIndex] = tempNpcIds[i]
					-- npcStates[tIndex] = npcState
					-- tIndex = tIndex + 1
				-- end
				
				-- for i = 1, table.getn(npcIds) do
					-- if npcStates[i] >= 2 then
						
					-- else
						-- _ED._current_seat_index = i
					-- end
				-- end
				
				-- ---
				-- --> print("=== test change ===",_ED._current_scene_id,_ED._current_seat_index)
				
				-- self:updateCurrentCopyInfo()
			-- end
		-- end
		-- (屏蔽)-------------------------------------------------------------------------end
		--> print("=== A ===",self.sceneID,self.npcIndex)
	end

	function DuplicateController:onEnterTransitionFinish()
		if __lua_project_id ~= __lua_project_red_alert_time then
			-- 绘制用户的基础信息
			fwin:open(PVEMapInformation:new(), fwin._view)
		end
	end

	function DuplicateController:onInit()
	
		local csbPath = "duplicate/pve_icon.csb"
		
		if is2003 then
			csbPath = "duplicate/pve_icon_1.csb"
		end
		
		--显示控制界面
		local tmpCsb = csb.createNode(csbPath)
		local root = tmpCsb:getChildByName("root")
		table.insert(self.roots, root)
		self:addChild(tmpCsb)
		
		-- 主线 -> 普通,精英
		self.principalLine = ccui.Helper:seekWidgetByName(root, "Panel_1")

		
		-- 主界面的控制按钮
		-- 名将副本
		self.Button_mingjiang_4 = ccui.Helper:seekWidgetByName(root, "Button_mingjiang_4")
		fwin:addTouchEventListener(self.Button_mingjiang_4,          nil, 
		{
			terminal_name = "duplicate_controller_manager",     
			next_terminal_name = "duplicate_select_hight_copy_panel",     
			current_button_name = "Button_mingjiang_4",            
			but_image = "Image_hight_copy",       
			terminal_state = 0, 
			isPressedActionEnabled = true,
			isClear = true,
		}, nil, 0)
		local dySceneDesBool = false
		local lastSceneId, firstScene = self:getOpenMaxSceneId(9)
		if lastSceneId < 0 then
			dySceneDesBool = true 
		end
		
		if dms.int(dms["fun_open_condition"], 18, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade)
          and dySceneDesBool == false then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_mingjiang",
			_widget = self.Button_mingjiang_4,
			_invoke = nil,
			_interval = 0.5,})
		end	
		
		-- 主线副本
		self.Button_ptfb_2 = ccui.Helper:seekWidgetByName(root, "Button_ptfb_2")
		fwin:addTouchEventListener(self.Button_ptfb_2,            nil, 
		{
			terminal_name = "duplicate_controller_manager",     
			next_terminal_name = "duplicate_controller_copy_page",       
			current_button_name = "Button_ptfb_2",    
			but_image = "Image_copy",       
			terminal_state = 0, 
			isPressedActionEnabled = true,
			isClear = true,
		}, nil, 0)
		
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_ordinary_the_chest",
		_widget = self.Button_ptfb_2,
		_invoke = nil,
		_interval = 0.5,})
		
		-- 日常副本
		self.Button_richang_6 = ccui.Helper:seekWidgetByName(root, "Button_richang_6")
		fwin:addTouchEventListener(self.Button_richang_6 , nil, 
		{
			terminal_name = "duplicate_controller_manager",     
			next_terminal_name = "duplicate_select_daily_activity_copy_panel",      
			current_button_name = "Button_richang_6",
			but_image = "Image_daily_activity_copy",       
			terminal_state = 0, 
			isPressedActionEnabled = true,
			isClear = true,
		}, nil, 0)
		if dms.int(dms["fun_open_condition"], 19, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_richang",
			_widget = self.Button_richang_6,
			_invoke = nil,
			_interval = 0.5,})	
		end	

		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
			or __lua_project_id == __lua_project_yugioh
			then 
			--self.principalLine:setTouchEnabled(true)
			self.Button_jinying_2 = ccui.Helper:seekWidgetByName(root, "Button_jingyingbt")
			fwin:addTouchEventListener(self.Button_jinying_2,            nil, 
			{
				terminal_name = "duplicate_controller_manager",     
				next_terminal_name = "duplicate_controller_elite_copy_page",       
				current_button_name = "Button_jingyingbt",    
				terminal_state = 0, 
				isPressedActionEnabled = true,
				isClear = true,
			}, nil, 0)
				-- 普通副本焦点按钮Button_duplicate
			self.Button_putong = ccui.Helper:seekWidgetByName(root, "Button_putong")
			fwin:addTouchEventListener(self.Button_putong,          nil, 
			{
				terminal_name = "duplicate_select_menu_button",     
				button_type = 1,
				terminal_state = 0, 
				isPressedActionEnabled = true,
				isClear = true,
			}, nil, 0)

			-- 精英副本焦点按钮
			self.Button_jingying = ccui.Helper:seekWidgetByName(root, "Button_jingying")
			fwin:addTouchEventListener(self.Button_jingying,          nil, 
			{
				terminal_name = "duplicate_select_menu_button",     
				button_type = 2,
				current_button_name = "Button_ptfb_2",    
				terminal_state = 0, 
				isPressedActionEnabled = true,
			}, nil, 0)
		else
				-- 普通副本焦点按钮
			self.Button_putong = ccui.Helper:seekWidgetByName(root, "Button_putong")
			fwin:addTouchEventListener(self.Button_putong,          nil, 
			{
				terminal_name = "duplicate_select_panel_plot_copy", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_all_the_chest",
			_widget = ccui.Helper:seekWidgetByName(root, "Button_putong"),
			_invoke = nil,
			_interval = 0.5,})	

			-- 精英副本焦点按钮
			self.Button_jingying = ccui.Helper:seekWidgetByName(root, "Button_jingying")
			fwin:addTouchEventListener(self.Button_jingying,          nil, 
			{
				terminal_name = "duplicate_select_panel_elite_copy",      
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
		end

		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			-- 关闭按钮
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_close"),          nil, 
			{
				terminal_name = "duplicate_controller_window_close",      
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
		end
	end

	function DuplicateController:addTouchEventFunc(uiName, eventName, actionMode)
		local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
		fwin:addTouchEventListener(tmpArt, nil, 
		{
			terminal_name = eventName, 
			next_terminal_name = eventName, 
			but_image = "", 	
			terminal_state = 0, 
			isPressedActionEnabled = actionMode
		},
		nil, 0)
		return tmpArt
	end

	function DuplicateController:init(pageType, openScene, openNpc, copyId)	--开启的场景和NPCid
		-- self:changeToPage(pageType, -1)
		-- self.sceneID = openScene
		-- self.sceneID = openNpc
		-- self.sceneID = openScene			--当前的关卡id
		-- self.npcIndex = -1					--npcIndex
		-- self.copyId = copyId 				--NPC的ID号，目前用于日常活动副本 

		-- self:updateCurrentCopyInfo()
		return self
	end

	function DuplicateController:onExit()
		_ED._last_page_type = nil
		
		local menu = fwin:find("MenuClass")
		
		if nil ~= menu then
			menu:setVisible(true)
		end
		
		
		state_machine.remove("duplicate_select_panel_plot_copy")
		state_machine.remove("duplicate_select_panel_elite_copy")
		state_machine.remove("duplicate_controller_manager")
		state_machine.remove("duplicate_page_controller_open")
		state_machine.remove("duplicate_page_controller_close")
		state_machine.remove("duplicate_select_raid_panel")
		state_machine.remove("duplicate_page_controller_change_scene")
		state_machine.remove("duplicate_update_selected_data")
		state_machine.remove("duplicate_select_hight_copy_panel")
		state_machine.remove("duplicate_controller_copy_page")
		state_machine.remove("duplicate_select_daily_activity_copy_panel")
		state_machine.remove("duplicate_controller_update_draw_tile_info")
		state_machine.remove("duplicate_controller_window_close")
	end

	

else

	DuplicateController = class("DuplicateControllerClass", Window)

	function DuplicateController:ctor()
		self.super:ctor()

		-- 定义封装类中的变量
		self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
		
		self.sceneID = -1			--当前的关卡id
		self.npcIndex = -1			--npcIndex
		self.copyId = -1 			--NPC的ID号，目前用于日常活动副本 
		
		self.sceneNameText = nil
		self.sceneChapterText = nil
		self.currentPageType = 1
		self.currentSceneType = 0
		self.currentCopyPadTile = nil
		
		if _ED._last_page_type ~= 1 then
			_ED._current_scene_id = 0
			_ED._current_seat_index = -1
		end
		
		app.load("client.duplicate.pve.PVEMapInformation") 					--顶部用户信息
		
		-- 初始化武将小像事件响应需要使用的状态机
		local function init_duplicate_page_controller_terminal()
			-- 主界面的管理器
			local duplicate_controller_manager_terminal = {
				_name = "duplicate_controller_manager",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					if terminal.last_terminal_name ~= params._datas.next_terminal_name then
						-- -- hide child window
		 --        		for i, v in pairs(instance.group) do
						-- 	if v ~= nil then
						-- 		v:setVisible(false)
						-- 	end
						-- end
						if state_machine.excute(params._datas.next_terminal_name, 0, params) == true then
							terminal.last_terminal_name = params._datas.next_terminal_name
						else
							return false
						end
						
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

			--强制关闭【副本】主界面
			local duplicate_page_controller_close_terminal = {
				_name = "duplicate_page_controller_close",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					state_machine.excute("page_stage_general_close", 0, "event page_stage_general_close.")
					fwin:close(instance)
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			--打开【副本】主界面
			local duplicate_page_controller_open_terminal = {
				_name = "duplicate_page_controller_open",
				_init = function (terminal)
					-- app.load("client.player.UserInformationForDuplicate")
					app.load("client.duplicate.pve.PVEStage")
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					-- --todo------------------------
					-- fwin:close(fwin:find("PVEStageClass"))
					-- state_machine.excute("pve_raid_select_close", 0, "")
					-- state_machine.excute("pve_daily_activity_copy_close", 0, "")
					-- local pveStage = PVEStage:new()
					-- pveStage:init(instance.sceneID)
		--         	fwin:open(pveStage, fwin._background)
		--         	instance:onInitInfo()
					-- --显示场景数据
					-- state_machine.excute("page_stage_update_information", 0, { sceneID = instance.sceneID, npcIndex = instance.npcIndex })
					
					-- -- --state_machine.excute("page_view_calc_scroll_position", 0, "event page_view_calc_scroll_position.")

					state_machine.excute("duplicate_controller_copy_page", 0, "")
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			--跳转副本场景
			local duplicate_page_controller_change_scene_terminal = {
				_name = "duplicate_page_controller_change_scene",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					--todo------------------------
					instance.sceneID = params._datas.sceneID
					instance.npcIndex = -1
					_ED._current_scene_id = instance.sceneID
					_ED._current_seat_index = -1
					local sceneType = dms.int(dms["pve_scene"], instance.sceneID, pve_scene.scene_type) 
					instance:changeToPage(params._datas.currentPageType or instance.currentPageType, sceneType)
					-- instance:updateCurrentCopyInfo()
					instance:onInitInfo()
					state_machine.excute("page_stage_update_information", 0, { sceneID = instance.sceneID, npcIndex = instance.npcIndex })
					state_machine.excute("pve_raid_select_close", 0, "event pve_raid_select_close.")
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			--打开选择【副本】弹窗
			local duplicate_select_raid_panel_terminal = {
				_name = "duplicate_select_raid_panel",
				_init = function (terminal)
					app.load("client.duplicate.pve.PVERaidSelectPanel")
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					fwin:open(PVERaidSelectPanel:new():init(instance.currentPageType, instance.currentSceneType), fwin._view)
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 关闭副本界面
			local duplicate_controller_window_close_terminal = {
				_name = "duplicate_controller_window_close",
				_init = function (terminal)

				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					state_machine.excute("home_button_window_show", 0, nil)
					fwin:close(fwin:find("DuplicateControllerClass"))
					fwin:close(fwin:find("PVEStageClass"))
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			--更新已选择的关卡
			local duplicate_update_selected_data_terminal = {
				_name = "duplicate_update_selected_data",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					if instance.currentPageType == 4 then
						instance.copyId = params[1]
					else
						instance.sceneID = params.sceneID			--当前的关卡id
						instance.npcIndex = params.npcIndex			--npcIndex 

						_ED._duplicate_sceneID = instance.sceneID
						_ED._duplicate_npcIndex = math.max(instance.npcIndex - 1,-1)
						
					end
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 名将副本
			local duplicate_select_hight_copy_panel_terminal = {
				_name = "duplicate_select_hight_copy_panel",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					return instance:gotoHightCopyWindow()
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 普通副本
			local duplicate_controller_copy_page_terminal = {
				_name = "duplicate_controller_copy_page",
				_init = function (terminal)
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					return instance:gotoPlotCopyWindow()
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 日常活动副本
			local duplicate_select_daily_activity_copy_panel_terminal = {
				_name = "duplicate_select_daily_activity_copy_panel",
				_init = function (terminal)
					app.load("client.duplicate.pve.PVEDailyActivityCopy")
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					return instance:gotoDailyActivityCopyWindow()
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 切换页面状态
			local duplicate_controller_change_page_terminal = {
				_name = "duplicate_controller_change_page",
				_init = function (terminal)

				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					instance:changeToPage(params[1], params[2])
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			-- 切换页面后更新绘制当前标题信息
			local duplicate_controller_update_draw_tile_info_terminal = {
				_name = "duplicate_controller_update_draw_tile_info",
				_init = function (terminal)

				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					instance:onInitInfo()
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			state_machine.add(duplicate_controller_manager_terminal)
			state_machine.add(duplicate_page_controller_open_terminal)
			state_machine.add(duplicate_select_raid_panel_terminal)
			state_machine.add(duplicate_page_controller_close_terminal)
			state_machine.add(duplicate_page_controller_change_scene_terminal)
			state_machine.add(duplicate_update_selected_data_terminal)
			state_machine.add(duplicate_select_hight_copy_panel_terminal)
			state_machine.add(duplicate_controller_copy_page_terminal)
			state_machine.add(duplicate_select_daily_activity_copy_panel_terminal)
			state_machine.add(duplicate_controller_change_page_terminal)
			state_machine.add(duplicate_controller_update_draw_tile_info_terminal)
			state_machine.add(duplicate_controller_window_close_terminal)
			state_machine.init()
		end
		init_duplicate_page_controller_terminal()

		-- 
		self:onInit()
	end

	function DuplicateController:changeToPage(_currentPageType, _currentSceneType)
		self.currentPageType = _currentPageType
		self.currentSceneType = _currentSceneType
		_ED._last_page_type = self.currentPageType
	end

	function DuplicateController:gotoHightCopyWindow()
		local user_grade=dms.int(dms["fun_open_condition"], 18, fun_open_condition.level)
		if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
			
		else
			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 18, fun_open_condition.tip_info))
			return false
		end

		-- 判断副本开启状态
		local lastSceneId, firstScene = self:getOpenMaxSceneId(9)
		if lastSceneId < 0 then
			local dySceneDes = dms.atos(firstScene, pve_scene.open_condition_describe)
			TipDlg.drawTextDailog(dySceneDes)
			return
		end

		--> print("名将副本")
		fwin:close(fwin:find("PVEStageClass"))
		_ED._current_scene_id = 0

		self:changeToPage(3, 9)
		self:updateCurrentCopyInfo()
		
		-- fwin:open(PVEStage:new():init(self.sceneID,2), fwin._background)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			state_machine.excute("lduplicate_window_manager", 0, {3})
		else
			state_machine.excute("page_stage_open_instance_window", 0, {sceneID = self.sceneID, sceneType = 2})
		end

		state_machine.excute("page_stage_update_information", 0, { sceneID = self.sceneID, npcIndex = -1})
		state_machine.excute("pve_raid_select_close", 0, "")
		state_machine.excute("pve_daily_activity_copy_close", 0, "")
		return true
	end

	function DuplicateController:gotoPlotCopyWindow()
		-- state_machine.excute("duplicate_page_controller_open", 0, "")
		fwin:close(fwin:find("PVEStageClass"))
		state_machine.excute("pve_raid_select_close", 0, "")
		state_machine.excute("pve_daily_activity_copy_close", 0, "")
		if self.currentPageType ~= 1 then
			_ED._current_scene_id = 0
			_ED._current_seat_index = -1
		end

		self:changeToPage(1, 0)
		self:updateCurrentCopyInfo()
		-- fwin:open(PVEStage:new():init(self.sceneID,1), fwin._background)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then		
			state_machine.excute("lduplicate_window_manager", 0, {1})
		else
			state_machine.excute("page_stage_open_instance_window", 0, {sceneID = self.sceneID, sceneType = 1})
			state_machine.excute("page_stage_update_information", 0, { sceneID = self.sceneID, npcIndex = self.npcIndex})
		end
		--显示场景数据
		return true
	end

	function DuplicateController:gotoDailyActivityCopyWindow()
		local user_grade=dms.int(dms["fun_open_condition"], 19, fun_open_condition.level)
		if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
			
		else
			TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 19, fun_open_condition.tip_info))
			return false
		end
		--> print("日常活动副本")

		self:changeToPage(4, -1)
		self:updateCurrentCopyInfo()
		self:onInitInfo()
		fwin:close(fwin:find("PVEStageClass"))
		state_machine.excute("pve_raid_select_close", 0, {4})
		if fwin:find("pveDailyActivityCopyWindow") == nil then
			fwin:open(PVEDailyActivityCopy:new():init(self.copyId), fwin._background)
		end
		return true
	end

	function DuplicateController:onInitInfo()	
		local root = self.roots[1]

		if self.currentCopyPadTile ~= nil then
			self.currentCopyPadTile:setVisible(false)
			self.currentCopyPadTile = nil
		end
		self.sceneChapterText:setVisible(false)

		if self.currentPageType == 1 then
			self.currentCopyPadTile = ccui.Helper:seekWidgetByName(root, "Panel_putong_button")
			if self.currentCopyPadTile ~= nil then
				self.currentCopyPadTile:setVisible(true)
				--更新场景名称
				local name = dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.scene_name)
				self.sceneNameText:setString(name)
				--章节
				self.sceneChapterText:setString(_string_piece_info[97] .. tonumber(self.sceneID) .. _string_piece_info[98])
				self.sceneChapterText:setVisible(true)
			end
		elseif self.currentPageType == 2 then
			self.currentCopyPadTile = ccui.Helper:seekWidgetByName(root, "Panel_jingying_button")
			if self.currentCopyPadTile ~= nil then
				self.currentCopyPadTile:setVisible(true)

				local eliteTile = ccui.Helper:seekWidgetByName(root, "Text_jy_name")
				local eliteTileString = dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.scene_name)
				eliteTile:setString(eliteTileString)
			end
		elseif self.currentPageType == 3 then
			self.currentCopyPadTile = ccui.Helper:seekWidgetByName(root, "Panel_mingjian_button")
			if self.currentCopyPadTile ~= nil then
				self.currentCopyPadTile:setVisible(true)

				local greatTile = ccui.Helper:seekWidgetByName(root, "Text_mj_name")
				local greatTileString = dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.scene_name)
				greatTile:setString(greatTileString)
			end
		elseif self.currentPageType == 4 then
			self.currentCopyPadTile = ccui.Helper:seekWidgetByName(root, "Panel_richang_button")
			if self.currentCopyPadTile ~= nil then
				self.currentCopyPadTile:setVisible(true)
				local greatTile = ccui.Helper:seekWidgetByName(root, "Text_rc_name")
				local greatTileString = dms.string(dms["daily_instance_mould"], tonumber(self.copyId), daily_instance_mould.instance_name)
				greatTile:setString(greatTileString)
				greatTile:setVisible(true)
			end
		end
	end

	function DuplicateController:getOpenMaxSceneId(currentSceneType)
		local lastSceneId = -1
		local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, currentSceneType)
		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				break
			end
			lastSceneId = tempSceneId
		end

		return lastSceneId, _scenes[1]
	end

	function DuplicateController:updateCurrentCopyInfo()
		-- --设置到最新最后的关卡
		-- -- self.sceneID = 1		--当前的关卡id
		-- -- self.npcIndex = -1		--npcIndex 
		-- local sCountCurrent = 0 --用于记录当前有多少条场景

		-- local function getOpenSceneList()
		--     for i = 1,table.getn(_ED.scene_current_state) do
		--         local _scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type) --tonumber(elementAtToString(pveScene,i,pve_scene.scene_type))
		--         --> print(_scene_type)
		-- 		if _scene_type == self.currentSceneType then
		--             if _ED.scene_current_state[i] == nil 
		-- 				or _ED.scene_current_state[i] == ""
		--                 or tonumber(_ED.scene_current_state[i]) < 0 then
		-- 				return
		--             end
		--             sCountCurrent = sCountCurrent + 1
		--         end
		--     end
		-- end

		-- if tonumber(_ED._current_scene_id) == 0 or _ED._current_scene_id == "" or _ED._current_scene_id == nil or true then
		-- 	getOpenSceneList()
		-- 	self.sceneID = sCountCurrent
		-- else
		-- 	self.sceneID = _ED._current_scene_id
		-- end

		-- if tonumber(_ED._current_seat_index) == 0 or _ED._current_seat_index == "" or _ED._current_seat_index == nil then
		-- 	self.npcIndex = -1
		-- else
		-- 	self.npcIndex = _ED._current_seat_index
		-- end

		if  missionIsOver() == false then
			_ED._current_scene_id = 0
			_ED._current_seat_index = -1
		end

		if self.currentPageType == 4 then
			self.copyId = zstring.tonumber(_ED._daily_copy_npc_id)
			if self.copyId <= 0 then
				self.copyId = 1
			end

			-- self.currentSceneType = -1
			-- _ED._current_scene_id = -1
			-- local currentNpcId = zstring.tonumber(_ED._current_scene_id)
			-- self.sceneID = _ED._current_scene_id
			-- if currentNpcId > 0 then
			-- 	for i, v in pairs(dms["daily_instance_mould"]) do
			-- 		local tempNpcId = dms.atoi(v, daily_instance_mould.id)
			-- 		if tempNpcId == currentNpcId then
			-- 			_ED._current_scene_id = tempNpcId
			-- 			break
			-- 		end
			-- 	end
			-- end
			-- -- local currentNpcId = zstring.tonumber(_ED._current_scene_id)
			-- -- if currentNpcId > 0 then

			-- -- end 
			
			-- self.sceneID = _ED._current_scene_id
			-- if zstring.tonumber(self.sceneID) < 1 then
			-- 	_ED._current_scene_id = 1
			-- 	self.sceneID = 1
			-- end
			--> print(_ED._current_scene_id, self.sceneID)
			return
		else
			self.copyId = -1
			_ED._daily_copy_npc_id = -1
		end

		local lastSceneId = -1
		local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, self.currentSceneType)
		for i, v in pairs(_scenes) do
			local tempSceneId = dms.atoi(v, pve_scene.id)
			if _ED.scene_current_state[tempSceneId] == nil
				or _ED.scene_current_state[tempSceneId] == ""
				or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
				then
				break
			end
			lastSceneId = tempSceneId
		end
		self.sceneID = lastSceneId
		self.npcIndex = -1


		-- 获取下一个场景的开启状态
		local function getNextSceneId(_sceneId)	
			local _scene_type = dms.int(dms["pve_scene"], _sceneId, pve_scene.scene_type)
			local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, _scene_type)
			local _prevSceneId = -1
			local _nextSceneId = -1
			if _scenes ~= nil then
				for i, v in pairs(_scenes) do
					local tempSceneId = dms.atoi(v, pve_scene.id)
					if _prevSceneId == sceneID then
						_nextSceneId = tempSceneId
						return _nextSceneId
					end
					_prevSceneId = tempSceneId
				end
			end
			return nil
		end

		local tempNextSceneId = getNextSceneId(_ED._current_scene_id)
		if tempNextSceneId ~= nil and tonumber(_ED._current_scene_id) > 0 and tonumber(_ED.scene_current_state[tempNextSceneId]) == 0 then
			self.sceneID = tempNextSceneId
			self.npcIndex = -1
		else
			if tonumber(_ED._current_scene_id) == 0 or _ED._current_scene_id == "" or _ED._current_scene_id == nil then
			else
				self.sceneID = _ED._current_scene_id
				--> print("_ED._current_scene_id",_ED._current_scene_id)
			end

			if tonumber(_ED._current_seat_index) == 0 or _ED._current_seat_index == "" or _ED._current_seat_index == nil then
				self.npcIndex = -1
			else
				self.npcIndex = _ED._current_seat_index
				--> print("_ED._current_seat_index",_ED._current_seat_index)
			end
		end
		
		local tIndex = 0
		local maxIndex = 0
		if self.npcIndex > -1 then
			local npcIds = {}
			local npcStates = {}
			local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], zstring.tonumber(self.sceneID), pve_scene.npcs), ",")
			local sceneState = tonumber(_ED.scene_current_state[self.sceneID])
			if sceneState == nil then
				self.sceneID = lastSceneId
				sceneState = tonumber(_ED.scene_current_state[self.sceneID])
			end
			if sceneState ~= nil then
				for i = 1, table.getn(tempNpcIds) do
					local npcState = 0
					if sceneState + 1 == i then
						npcState = 1
					elseif sceneState + 2 == i then
						npcState = 2
						break
					elseif sceneState + 2 < i then
						break
					end
					tIndex = tIndex + 1
					npcIds[tIndex] = tempNpcIds[i]
					npcStates[tIndex] = npcState
				end
				if tIndex > 0 and npcStates[tIndex] == 1 and tIndex == self.npcIndex + 1 then
					self.npcIndex = -1
				end
				maxIndex = table.getn(tempNpcIds)
			else
				self.npcIndex = -1
			end
		end
		if tIndex >= maxIndex and  self.sceneID ~= lastSceneId then
			sceneState = tonumber(_ED.scene_current_state[lastSceneId])
			if sceneState == 0 then
				_ED._current_scene_id = lastSceneId
				
				---
				local npcIds = {}
				local npcStates = {}
				local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(_ED._current_scene_id), pve_scene.npcs), ",")
				local sceneState = tonumber(_ED.scene_current_state[tonumber(_ED._current_scene_id)])
				local tIndex = 1
				for i = 1, table.getn(tempNpcIds) do
					local npcState = 0
					if sceneState + 1 == i then
						npcState = 1
					elseif sceneState + 2 == i then
						npcState = 2
					elseif sceneState + 2 < i then
						break
					end
					npcIds[tIndex] = tempNpcIds[i]
					npcStates[tIndex] = npcState
					tIndex = tIndex + 1
				end
				
				for i = 1, table.getn(npcIds) do
					if npcStates[i] >= 2 then
						
					else
						_ED._current_seat_index = i
					end
				end
				
				---
				--> print("=== test change ===",_ED._current_scene_id,_ED._current_seat_index)
				
				self:updateCurrentCopyInfo()
			end
		end
		--> print("=== A ===",self.sceneID,self.npcIndex)
	end

	function DuplicateController:onEnterTransitionFinish()
		if __lua_project_id ~= __lua_project_red_alert_time then
			-- 绘制用户的基础信息
			fwin:open(PVEMapInformation:new(), fwin._view)
		end
	end

	function DuplicateController:onInit()
		--显示控制界面
		local tmpCsb = csb.createNode("duplicate/pve_tab.csb")
		local root = tmpCsb:getChildByName("root")
		table.insert(self.roots, root)
		self:addChild(tmpCsb)
		
		self.sceneNameText = ccui.Helper:seekWidgetByName(root, "Text_zj_name")
		self.sceneChapterText = ccui.Helper:seekWidgetByName(root, "Text_zj")
		
		-- 普通副本
		self:addTouchEventFunc("Button_ptfb", "duplicate_select_raid_panel", true)
		-- 名将副本
		self:addTouchEventFunc("Button_mingjiang", "duplicate_select_hight_copy_panel", true)
		-- 日常活动副本
		self:addTouchEventFunc("Button_richang", "duplicate_select_daily_activity_copy_panel", true)
		
		-- --开始绘制icon
		-- self:onInitInfo()
		
		-- -- 绘制用户的基础信息
		-- fwin:open(PVEMapInformation:new(), fwin._view)

		-- 主界面的控制按钮
		-- 普通副本焦点按钮
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ptfb"),          nil, 
		{
			terminal_name = "duplicate_select_raid_panel",      
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_all_the_chest",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_ptfb"),
		_invoke = nil,
		_interval = 0.5,})	

		-- 精英副本焦点按钮
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jingying"),          nil, 
		{
			terminal_name = "duplicate_select_raid_panel",      
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		-- 名将副本焦点按钮
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mingjian"),          nil, 
		{
			terminal_name = "duplicate_select_raid_panel",      
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		-- 名将副本
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mingjiang"),          nil, 
		{
			terminal_name = "duplicate_controller_manager",     
			next_terminal_name = "duplicate_select_hight_copy_panel",     
			current_button_name = "Button_mingjiang",            
			but_image = "Image_hight_copy",       
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		-- 普通副本
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_putong"),            nil, 
		{
			terminal_name = "duplicate_controller_manager",     
			next_terminal_name = "duplicate_controller_copy_page",       
			current_button_name = "Button_putong",    
			but_image = "Image_copy",       
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_ordinary_the_chest",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_putong"),
		_invoke = nil,
		_interval = 0.5,})

		-- 日常副本
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_richang"), nil, 
		{
			terminal_name = "duplicate_controller_manager",     
			next_terminal_name = "duplicate_select_daily_activity_copy_panel",      
			current_button_name = "Button_richang",
			but_image = "Image_daily_activity_copy",       
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			-- 关闭按钮
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_close"),          nil, 
			{
				terminal_name = "duplicate_controller_window_close",      
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
		end
	end

	function DuplicateController:addTouchEventFunc(uiName, eventName, actionMode)
		local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
		fwin:addTouchEventListener(tmpArt, nil, 
		{
			terminal_name = eventName, 
			next_terminal_name = eventName, 
			but_image = "", 	
			terminal_state = 0, 
			isPressedActionEnabled = actionMode
		},
		nil, 0)
		return tmpArt
	end

	function DuplicateController:init(pageType, openScene, openNpc, copyId)	--开启的场景和NPCid
		-- self:changeToPage(pageType, -1)
		-- self.sceneID = openScene
		-- self.sceneID = openNpc
		-- self.sceneID = openScene			--当前的关卡id
		-- self.npcIndex = -1					--npcIndex
		-- self.copyId = copyId 				--NPC的ID号，目前用于日常活动副本 

		-- self:updateCurrentCopyInfo()
		return self
	end

	function DuplicateController:onExit()
		_ED._last_page_type = nil
		state_machine.remove("duplicate_controller_manager")
		state_machine.remove("duplicate_page_controller_open")
		state_machine.remove("duplicate_page_controller_close")
		state_machine.remove("duplicate_select_raid_panel")
		state_machine.remove("duplicate_page_controller_change_scene")
		state_machine.remove("duplicate_update_selected_data")
		state_machine.remove("duplicate_select_hight_copy_panel")
		state_machine.remove("duplicate_controller_copy_page")
		state_machine.remove("duplicate_select_daily_activity_copy_panel")
		state_machine.remove("duplicate_controller_update_draw_tile_info")
		state_machine.remove("duplicate_controller_window_close")
		
	end

end
