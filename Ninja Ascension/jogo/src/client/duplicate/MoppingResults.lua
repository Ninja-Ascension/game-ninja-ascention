----------------------------------------------------------------------------------------------------
-- 说明：Pve界面 扫荡成功的信息窗口
-------------------------------------------------------------------------------------------------------
MoppingResults = class("MoppingResultsClass", Window)
MoppingResults.__npcId = 0
function MoppingResults:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.interfaceType = 0
	self.npcId = 0
	self.difficultyIndex = 0
	self.sweepCount = 0
	self.totalSweepCount = 0
	self.sweepType = 0
	self.state_machine_info = nil
	self.cacheBattleTenBtn = nil
	self.cacheBattleTenResetBtn = nil
	self._enum_type = {
		_SWEEP_PLOT_COPY = 1   -- 主线副本扫荡
	}
	app.load("client.campaign.worldboss.BetrayArmyNpcArrival")
	app.load("client.cells.duplicate.mopping_result_cell")
	app.load("client.cells.duplicate.mopping_result_end_cell")
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

	self.delayOve = 0
	self.rewardMerge = nil

	self.sweep_overs = false

	self.sweep_up = false

	-- 扫荡数据绘图列表
    self.item_infos = {}

    -- 扫荡生成一条的时间
    self.create_time = 0

    -- 是否是快速
    self.is_quick = false

	_ED.battleData = nil
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_mopping_results_terminal()

		-- 扫荡完成
		local mopping_results_close_terminal = {
            _name = "mopping_results_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- if instance.sweepCount ~= instance.totalSweepCount and instance.state_machine_info[1] ~= nil and instance.state_machine_info[2] ~= nil then
            		state_machine.excute(instance.state_machine_info[1], 0, instance.state_machine_info[2])
            	-- end
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_red_alert then
			        -- instance.actions[1]:setTimeSpeed(app.getTimeSpeed())
			    end
			    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					fwin:close(instance)
				else
					instance.actions[1]:play("window_close", false)
				end
				if __lua_project_id == __lua_project_yugioh then 
					--扫荡后检测是否有魔陷商店人
					state_machine.excute("duplicate_pve_secondary_scene_check_magic_shop", 0, 0)
				end
				if zstring.tonumber(_ED.user_info.last_user_grade) ~= zstring.tonumber(_ED.user_info.user_grade) then
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						-- _ED.user_info.last_user_grade = _ED.user_info.user_grade
						self.sweep_up = true
						if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, false, nil, false) == false then
							
						end
					    if missionIsOver() == false then
					        local windowLock = fwin:find("WindowLockClass")
					        if windowLock == nil then
					            fwin:open(WindowLock:new():init(), fwin._windows)
					        end
					    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					    		fwin:close(fwin:find("MoppingResultsClass"))
								-- 回到主页
					    		fwin:close(fwin:find("BattleSceneClass"))
				                cacher.removeAllTextures()
				                fwin:reset(nil)
								-- fwin:removeAll()
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
			                                    _needOpenHomeHero = true,
			                                    isPressedActionEnabled = true
			                                }
			                            }
			                        )
			                    end
			                    state_machine.excute("menu_back_home_page", 0, "")
                    			state_machine.excute("home_change_open_atrribute", 0, false)

								-- state_machine.excute("explore_window_open", 0, 0)
								-- state_machine.excute("explore_window_open_fun_window", 0, nil)
								executeNextEvent(nil, true)
								return
							else
								executeNextEvent(nil, true)
					    	end
					    end
					end		
				end
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 扫荡结束更新界面
		local mopping_results_request_plot_copy_sweep_over_update_draw_terminal = {
            _name = "mopping_results_request_plot_copy_sweep_over_update_draw",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if nil ~= fwin:find("MoppingResultsClass") then
					params:plotCopySweepOverUpdateDraw()
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						state_machine.excute("lpve_scene_updeteinfo",0,"")
					end
				end
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 扫荡结算更新界面
		local mopping_results_request_plot_copy_sweep_update_draw_terminal = {
            _name = "mopping_results_request_plot_copy_sweep_update_draw",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local Mopwindow = fwin:find("MoppingResultsClass")
				if nil ~= Mopwindow and Mopwindow.roots ~= nil then
					params:plotCopySweepUpdateDraw()
				end
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求主线副本扫荡
		local mopping_results_request_plot_copy_sweep_terminal = {
            _name = "mopping_results_request_plot_copy_sweep",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 检查教学 
				if zstring.tonumber(_ED.user_info.last_user_grade) ~= zstring.tonumber(_ED.user_info.user_grade) then
					self.sweep_up = true
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					else
						app.load("client.battle.BattleLevelUp")
						local win = fwin:find("BattleLevelUpClass")
						if nil ~= win then
							fwin:close(win)
						end
						fwin:close(fwin:find("MoppingResultsClass"))
						fwin:open(BattleLevelUp:new(), fwin._windows)
					end
					if __lua_project_id == __lua_project_yugioh then 
						if missionIsOver() == true then 
							--升级也需要检测是否有魔陷商人
							state_machine.excute("duplicate_pve_secondary_scene_check_magic_shop", 0, 0)
						end
					end


					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						-- _ED.user_info.last_user_grade = _ED.user_info.user_grade
						if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, false, nil, false) == false then
							
						end
					    if missionIsOver() == false then
					        local windowLock = fwin:find("WindowLockClass")
					        if windowLock == nil then
					            fwin:open(WindowLock:new():init(), fwin._windows)
					        end
					    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					    		fwin:close(fwin:find("MoppingResultsClass"))
								-- 回到主页
					    		fwin:close(fwin:find("BattleSceneClass"))
				                cacher.removeAllTextures()
				                fwin:reset(nil)
								-- fwin:removeAll()
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
			                                    _needOpenHomeHero = true,
			                                    isPressedActionEnabled = true
			                                }
			                            }
			                        )
			                    end
			                    state_machine.excute("menu_back_home_page", 0, "")
                    			state_machine.excute("home_change_open_atrribute", 0, false)

								-- state_machine.excute("explore_window_open", 0, 0)
								-- state_machine.excute("explore_window_open_fun_window", 0, nil)
								executeNextEvent(nil, true)
								return
							else
								executeNextEvent(nil, true)
					    	end
					    end
					end			
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					else
						return
					end
				end
			
				local function responsePlotCopySweepCallback(response)
					if nil == fwin:find("MoppingResultsClass") then
						return
					end
					
					if instance ~= nil and instance.roots ~= nil then
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_touch"):setVisible(true)
							local t = instance.delayOve + 1
							if instance.delayOve < 0 then
								t = 0
							elseif instance.delayOve == 0 then
								t = 0
							end

							instance:upload_fileIslandFriendTaskExecute()

							if zstring.tonumber(_ED.user_info.last_user_grade) ~= zstring.tonumber(_ED.user_info.user_grade) then
								if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
									self.sweep_up = true
									if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, false, nil, false) == false then
									end
								    if missionIsOver() == false then
								        local windowLock = fwin:find("WindowLockClass")
								        if windowLock == nil then
								            fwin:open(WindowLock:new():init(), fwin._windows)
								        end
								    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								    		fwin:close(fwin:find("MoppingResultsClass"))
											-- 回到主页
								    		fwin:close(fwin:find("BattleSceneClass"))
							                cacher.removeAllTextures()
							                fwin:reset(nil)
											-- fwin:removeAll()
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
						                                    _needOpenHomeHero = true,
						                                    isPressedActionEnabled = true
						                                }
						                            }
						                        )
						                    end
						                    state_machine.excute("menu_back_home_page", 0, "")
			                    			state_machine.excute("home_change_open_atrribute", 0, false)
			                    			self.sweep_up = false
											app.load("client.battle.BattleLevelUp")
											local win = fwin:find("BattleLevelUpClass")
											if nil ~= win then
												fwin:close(win)
											end
											fwin:open(BattleLevelUp:new(), fwin._windows)
											_ED.user_info.last_user_grade = _ED.user_info.user_grade
											executeNextEvent(nil, true)
											return
										else
											executeNextEvent(nil, true)
								    	end
								    end
								end			
							end
							if t == 0 then
								state_machine.excute("mopping_results_mopup_merge_reward", 0, "")
								state_machine.excute("mopping_results_request_plot_copy_sweep_update_draw", 0, instance)
							else
								instance:runAction(cc.Sequence:create({cc.DelayTime:create(t), cc.CallFunc:create(function ( sender )

									state_machine.excute("mopping_results_mopup_merge_reward", 0, "")
									state_machine.excute("mopping_results_request_plot_copy_sweep_update_draw", 0, instance)
								end)}))
							end
							-- state_machine.excute("mopping_results_request_plot_copy_sweep_update_draw", 0, instance)
						else
							ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_touch"):setVisible(false)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_again"):setVisible(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1"):setVisible(true)
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_sd_gb"):setVisible(true)
							state_machine.excute("mopping_results_request_plot_copy_sweep_over_update_draw", 0, instance)
						end
					end
				end
				
				if TipDlg.drawStorageTipo() == false then
                    if
                        __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                            __lua_project_id == __lua_project_onepiece or
                            __lua_project_id == __lua_project_l_naruto
                     then
                        if instance.delayOve == -1 then
                            -- --debug.print_r(_ED.auto_raids_inof,'_ED.auto_raids_inof')
                            -- --- 加速后
                            -- -- protocol_command.sweep.param_list = "" .. instance.npcId .."\r\n".. instance.difficultyIndex .."\r\n".. 1 .."\r\n".. instance.sweepType.."\r\n"..instance.currentSceneID
                            -- instance.sweep_overs = true
                            -- local Consumption = instance.totalSweepCount - instance.sweepCount
                            -- local totalAttackTimes = dms.int(dms["npc"], instance.npcId, npc.daily_attack_count)
                            -- local addTimes = 0
                            -- if zstring.tonumber(self.currentSceneType) == 1 then
                            --     if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
                            --         addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
                            --     end
                            -- end
                            -- totalAttackTimes = totalAttackTimes + addTimes
                            -- local surplusAttackCount = _ED.npc_current_attack_count[tonumber(instance.npcId)]
                            -- local finalBattleTimes = totalAttackTimes - surplusAttackCount
                            -- if instance.sweepCount > finalBattleTimes then
                            --     instance.sweepCount = finalBattleTimes
                            -- end
                            -- if _ED.auto_raids_source == nil or _ED.auto_raids_source == false then
                            --     local current_food = dms.int(dms["npc"], instance.npcId, npc.attack_need_food)
                            --     if zstring.tonumber(_ED.user_info.user_food) < current_food * instance.sweepCount then
                            --         instance.sweepCount = math.floor(zstring.tonumber(_ED.user_info.user_food) / current_food)
                            --     end
                            -- end
                            -- if instance.sweepCount <= 0 then
                            --     ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
                            --     ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(true)
                            --     ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
                            --     ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(true)
                            --     -- state_machine.excute("mopping_results_request_plot_copy_sweep_over_update_draw", 0, instance)
                            --     return
                            -- end
                        else
                            if
                                _ED.auto_raids_inof and _ED.auto_raids_inof[2] and _ED.auto_raids_inof[3] and _ED.auto_raids_inof[4] and _ED.auto_raids_inof[5] and
                                    _ED.auto_raids_inof[5] < _ED.auto_raids_inof[4]
                             then
                                --- 道具不足的时候
                                local num = -1
                                -- instance.totalSweepCount = instance.sweepCount
                                local need_count = _ED.auto_raids_inof[4] - _ED.auto_raids_inof[3]
                                if need_count > 0 then
                                    num = _ED.auto_raids_inof[4] - _ED.auto_raids_inof[3]
                                end

                                if num >= 0 then
                                    local cs = 6 .. "," .. _ED.auto_raids_inof[2] .. "," .. num
                                    protocol_command.sweep.param_list =
                                        "" ..
                                        instance.npcId ..
                                            "\r\n" .. instance.difficultyIndex .. "\r\n" .. instance.sweepCount .. "\r\n" .. instance.sweepType .. "\r\n" .. instance.currentSceneID .. "\r\n" .. cs
                                else
                                    protocol_command.sweep.param_list =
                                        "" .. instance.npcId .. "\r\n" .. instance.difficultyIndex .. "\r\n" .. instance.sweepCount .. "\r\n" .. instance.sweepType .. "\r\n" .. instance.currentSceneID
                                end
                            else
                                protocol_command.sweep.param_list =
                                    "" .. instance.npcId .. "\r\n" .. instance.difficultyIndex .. "\r\n" .. instance.sweepCount .. "\r\n" .. instance.sweepType .. "\r\n" .. instance.currentSceneID
                            end
                        end
                    else
                        protocol_command.sweep.param_list = "" .. instance.npcId .. "\r\n" .. instance.difficultyIndex .. "\r\n" .. instance.sweepCount .. "\r\n" .. instance.sweepType
                    end
                    NetworkManager:register(protocol_command.sweep.code, nil, nil, nil, instance, responsePlotCopySweepCallback, false, nil)
                else
                    state_machine.excute("mopping_results_request_plot_copy_sweep_over_update_draw", 0, instance)
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 扫荡重置
		local mopping_results_reset_terminal = {
            _name = "mopping_results_reset",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:resetMopup()
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 继续扫荡
		local mopping_results_mopup_terminal = {
            _name = "mopping_results_mopup",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance.delayOve = 0
				instance:launchMopup()
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 扫荡over动画
		local mopping_results_mopup_over_add_terminal = {
            _name = "mopping_results_mopup_over_add",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:addOver()
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 扫荡加速
		local mopping_results_mopup_accelerate_terminal = {
            _name = "mopping_results_mopup_accelerate",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- instance.delayOve = -1
                -- if
                --     __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                --         __lua_project_id == __lua_project_onepiece or
                --         __lua_project_id == __lua_project_l_naruto
                --  then
                --     state_machine.excute("mopping_result_cell_accelerate", 0, "")
                -- end
                self.create_time = 0
                self.is_quick = true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 合并额外奖励
		local mopping_results_mopup_merge_reward_terminal = {
            _name = "mopping_results_mopup_merge_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local rewar_list = {}
				if instance.rewardMerge == nil then
					instance.rewardMerge = getSceneReward(70)
				else
					local rewarData= getSceneReward(70)	
					if rewarData ~= nil then
						for i = 1, tonumber(rewarData.show_reward_item_count) do
							local rewardList = rewarData.show_reward_list[i]
							table.insert(rewar_list, rewardList)
						end
					end
					if instance.rewardMerge ~= nil then
						for i = 1, tonumber(instance.rewardMerge.show_reward_item_count) do
							local rewards = instance.rewardMerge.show_reward_list[i]
							
							for j, v in pairs(rewar_list) do
								if tonumber(rewards.prop_type) == tonumber(v.prop_type) and tonumber(rewards.prop_item) == tonumber(v.prop_item) then
									instance.rewardMerge.show_reward_list[i].item_value = tonumber(instance.rewardMerge.show_reward_list[i].item_value) + tonumber(v.item_value) 
								end
							end
							local same = false
							for j, v in pairs(rewar_list) do
								if tonumber(rewards.prop_type) ~= tonumber(v.prop_type) then
								else
									same = true
								end
								if same == false then
									instance.rewardMerge.show_reward_item_count = tonumber(instance.rewardMerge.show_reward_item_count) + 1
									instance.rewardMerge.show_reward_list[tonumber(instance.rewardMerge.show_reward_item_count)] = {}
									instance.rewardMerge.show_reward_list[tonumber(instance.rewardMerge.show_reward_item_count)] = v
								end
							end
						end	
					end
				end
            end,
            _terminal = nil,
            _terminals = nil
        }

        local mopping_results_mopup_buy_times_terminal = {
            _name = "mopping_results_mopup_buy_times",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.utils.ConfirmTip")
                local function sureFunc(sender, sure_number)
                    if sure_number ~= 0 then
                        return
                    end
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then

	                        end
                        end
                    end
	                protocol_command.basic_consumption.param_list = "22".."\r\n"..MoppingResults.__npcId
	                NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, instance, responseCallback, false, nil)
                end

                local buy_times = tonumber(_ED.npc_current_buy_count[tonumber(MoppingResults.__npcId)]) + 1
                local total_reset_times = dms.int(dms["base_consume"], 22, base_consume.vip_0_value + tonumber(_ED.vip_grade))
                if buy_times > total_reset_times then
                	app.load("client.utils.SmResetDuplicateTip")
                	state_machine.excute("sm_reset_duplicate_tip_open", 0, nil)
                	-- TipDlg.drawTextDailog(_new_interface_text[211])
                	return
                end
                local reset_info = zstring.split(dms.string(dms["copy_config"], 1, copy_config.param), ",")
                local cost = reset_info[buy_times]
                local tip = ConfirmTip:new()
                tip:init(instance, sureFunc, string.format(_new_interface_text[210], cost, buy_times - 1))
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(mopping_results_show_results_terminal)
		state_machine.add(mopping_results_close_terminal)
		state_machine.add(mopping_results_request_plot_copy_sweep_over_update_draw_terminal)
		state_machine.add(mopping_results_request_plot_copy_sweep_update_draw_terminal)
		state_machine.add(mopping_results_request_plot_copy_sweep_terminal)
		state_machine.add(mopping_results_mopup_over_add_terminal)
		state_machine.add(mopping_results_mopup_accelerate_terminal)
		state_machine.add(mopping_results_mopup_merge_reward_terminal)
		state_machine.add(mopping_results_mopup_terminal)
		state_machine.add(mopping_results_mopup_buy_times_terminal)
		if __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then 
			state_machine.add(mopping_results_reset_terminal)
		end

        state_machine.init()
	end
	
	init_mopping_results_terminal()
end

function MoppingResults:init(interfaceType, npcId, difficultyIndex, sweepCount, sweepType, state_machine_info, m_type, currentSceneID, currentSceneType)
	self.interfaceType = interfaceType
	self.npcId = npcId
	self.difficultyIndex = difficultyIndex
	self.sweepCount = sweepCount
	self.totalSweepCount = sweepCount
	self.totalInitialNumber = sweepCount
	self.canChangeSweepCount = sweepCount
	if _ED.auto_raids_real_count == nil then
		_ED.auto_raids_real_count = sweepCount
	end

	
	self.sweepType = sweepType
	self.state_machine_info = state_machine_info
	self.m_type = tonumber(m_type)
	self.currentSceneType = currentSceneType
	MoppingResults.__npcId = npcId
	_ED.user_info.last_user_grade = _ED.user_info.user_grade

	_ED.user_info.last_user_food = _ED.user_info.user_food
	_ED.user_info.last_endurance = _ED.user_info.endurance

	self.currentSceneID = currentSceneID or nil

	return self
end

--重置
function MoppingResults:plotCopySweepOverUpdateDraw()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(true)
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(true)
	else
		if _ED.rebel_army_mould_id ~= "" and _ED.rebel_army_mould_id ~= nil then
			local BetrayArmyPve = BetrayArmyNpcArrival:new()
			BetrayArmyPve:init()
			fwin:open(BetrayArmyPve, fwin._ui)
		end
	end
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_876"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)

	if __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		self:updateBattleTimes()
	end

end

function MoppingResults:addOver()
    local isHaveActivity = false
    if zstring.tonumber(self.currentSceneType) == 0 then
        if _ED.active_activity[97] ~= nil and _ED.active_activity[97] ~= "" then
            isHaveActivity = true
        end
    elseif zstring.tonumber(self.currentSceneType) == 1 then
        if _ED.active_activity[98] ~= nil and _ED.active_activity[98] ~= "" then
            isHaveActivity = true
        end
    end
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_sd_01")
    local endCell = MoppingResultEndCell:createCell()

    endCell:init(self.rewardMerge, isHaveActivity, self.currentSceneType, self.npcId)
    listView:addChild(endCell)
    listView:getInnerContainer():setPositionY(endCell:getContentSize().height)
    listView:refreshView()

    if _ED.secret_shop_open ~= nil and _ED.secret_shop_open == true then
        app.load("client.shop.SecretShopOpenTip")
        state_machine.excute("secret_shop_open_tip_window_open", 0, 0)
        _ED.secret_shop_open = false
    end
end

function MoppingResults:getTabelLength(table)
    if table ~= nil then
        return #table
    end

    return 0
end

function MoppingResults:asyncCreateItem()
    local temp_info_items = self.item_infos
    local length = #self.item_infos
    self:stopAllActions()
    self:runAction(
        cc.Sequence:create(
            {
                cc.DelayTime:create(self.create_time),
                cc.CallFunc:create(
                    function(sender)
                        if (length > 0) then
                            local cell_info = temp_info_items[1]
                            length = length - 1
                            table.remove(self.item_infos, 1)
                            local t = 0
                            local reward_equipment_item = cell_info.sweep_reward.reward_equipment_item
                            local reward_matrix_item = cell_info.sweep_reward.reward_matrix_item
                            local reward_prop_item = cell_info.sweep_reward.reward_prop_item
                            local reward_ship_item = cell_info.sweep_reward.reward_ship_item
                            local reward_length =
                                self:getTabelLength(reward_equipment_item) + self:getTabelLength(reward_matrix_item) + self:getTabelLength(reward_prop_item) + self:getTabelLength(reward_ship_item)

                            t = 0.25 + 0.25 * (reward_length - 1)

                            if self.is_quick == false then
                                self.create_time = t
                            end

                            self:createCell(cell_info.times, cell_info.sweep_reward, cell_info.isHaveActivity)
                        end

                        if (length > 0) then
                            self:asyncCreateItem()
                        end

                        if (length == 0) then
                            self.is_quick = false
                            if
                                __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or
                                    __lua_project_id == __lua_project_onepiece or
                                    __lua_project_id == __lua_project_l_naruto
                             then
                                local t = self.delayOve / 2
                                if self.delayOve == -1 then
                                    t = 0
                                end
                                self:stopAllActions()
                                self:runAction(
                                    cc.Sequence:create(
                                        {
                                            cc.DelayTime:create(t),
                                            cc.CallFunc:create(
                                                function(sender)
                                                    playEffect(formatMusicFile("effect", 9980))
                                                    state_machine.excute("mopping_results_mopup_over_add", 0, "")
                                                    ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
                                                    ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(true)
                                                    ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
                                                    ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(true)
                                                    if self.sweep_up == true then
                                                        self.sweep_up = false
                                                        app.load("client.battle.BattleLevelUp")
                                                        local win = fwin:find("BattleLevelUpClass")
                                                        if nil ~= win then
                                                            fwin:close(win)
                                                        end
                                                        fwin:open(BattleLevelUp:new(), fwin._windows)
                                                        _ED.user_info.last_user_grade = _ED.user_info.user_grade
                                                    end
                                                end
                                            )
                                        }
                                    )
                                )
                            end
                            state_machine.excute("mopping_results_request_plot_copy_sweep_over_update_draw", 0, self)
                        end
                    end
                )
            }
        )
    )
end

function MoppingResults:createCell(times, sweep_reward, isHaveActivity)
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_sd_01")
    local cell = MoppingResultCell:createCell()
    cell:init(times, sweep_reward, isHaveActivity)

    if
        __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or
            __lua_project_id == __lua_project_l_pokemon or
            __lua_project_id == __lua_project_onepiece or
            __lua_project_id == __lua_project_l_naruto or
            __lua_project_id == __lua_project_red_alert
     then
        listView:addChild(cell)
        listView:getInnerContainer():setPositionY(cell:getContentSize().height)
    else
        listView:insertCustomItem(cell, 0)
    end

    listView:refreshView()
end

function MoppingResults:plotCopySweepUpdateDraw()
    -- local root = self.roots[1]
    -- local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_sd_01")
    local isHaveActivity = false
    if zstring.tonumber(self.currentSceneType) == 0 then
        if _ED.active_activity[97] ~= nil and _ED.active_activity[97] ~= "" then
            isHaveActivity = true
        end
    elseif zstring.tonumber(self.currentSceneType) == 1 then
        if _ED.active_activity[98] ~= nil and _ED.active_activity[98] ~= "" then
            isHaveActivity = true
        end
    end

    for n = 1, #_ED.sweep_reward do
        if _ED.sweep_reward[n] ~= nil then
            local data = {times = self.totalInitialNumber - self.sweepCount + n, sweep_reward = _ED.sweep_reward[n], isHaveActivity = isHaveActivity}
            table.insert(self.item_infos, data)
        end
    end

    self:asyncCreateItem()
end

function MoppingResults:onUpdateDraw()
    local isHaveActivity = false
    if zstring.tonumber(self.currentSceneType) == 0 then
        if _ED.active_activity[97] ~= nil and _ED.active_activity[97] ~= "" then
            isHaveActivity = true
        end
    elseif zstring.tonumber(self.currentSceneType) == 1 then
        if _ED.active_activity[98] ~= nil and _ED.active_activity[98] ~= "" then
            isHaveActivity = true
        end
    end
    for n = 1, #_ED.sweep_reward do
        if _ED.sweep_reward[n] ~= nil then
            local cell = MoppingResultCell:createCell()
            if _ED.auto_raids_real_count ~= nil then
                _ED.auto_raids_real_count = _ED.auto_raids_real_count - 1
            end

            cell:init(n, _ED.sweep_reward[n], isHaveActivity)
            ccui.Helper:seekWidgetByName(self.roots[1], "ListView_sd_01"):addChild(cell)
        end
    end
end

function MoppingResults:onUpdate()
	
end

function MoppingResults:onEnterTransitionFinish()
	local csbMoppingResults = csb.createNode("duplicate/mopping_results.csb")
	local root = csbMoppingResults:getChildByName("root")
	table.insert(self.roots, root)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		state_machine.lock("notification_center_update")
	end
	--加速层，默认隐藏
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(false)

    local action = csb.createTimeline("duplicate/mopping_results.csb")
    table.insert(self.actions, action)
    csbMoppingResults:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
        	fwin:close(self)
        	-- 处理角色升级
        	if zstring.tonumber(_ED.user_info.last_user_grade) ~= zstring.tonumber(_ED.user_info.user_grade) then
        		app.load("client.battle.BattleLevelUp")
				local win = fwin:find("BattleLevelUpClass")
				if nil ~= win then
					fwin:close(win)
				end
				fwin:open(BattleLevelUp:new(), fwin._windows)

        	end
        end
    end)
    if __lua_project_id == __lua_project_gragon_tiger_gate 
    	or __lua_project_id == __lua_project_red_alert 
    	then
        action:setTimeSpeed(app.getTimeSpeed())
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
	    action:play("window_open", false)
	end

    self:addChild(csbMoppingResults)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"), nil, 
	{
		terminal_name = "mopping_results_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"), nil, 
	{
		terminal_name = "mopping_results_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then 
		self.cacheBattleTenBtn = ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd")
		self.cacheBattleTenResetBtn = ccui.Helper:seekWidgetByName(self.roots[1], "Button_cz_1")
		fwin:addTouchEventListener(self.cacheBattleTenBtn , nil, 
		{
			terminal_name = "mopping_results_mopup", terminal_state = 0,
			isPressedActionEnabled = true
		},
		nil, 2)
		fwin:addTouchEventListener(self.cacheBattleTenResetBtn, nil, 
		{
			terminal_name = "mopping_results_reset", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil, 2)
		local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_sd_01")
		listView:removeAllItems()

	end

	--加速
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch") , nil, 
	{
		terminal_name = "mopping_results_mopup_accelerate", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 0)

	--再次扫荡
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_again") , nil, 
	{
		terminal_name = "mopping_results_mopup", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 0)
	


	state_machine.excute("mopping_results_request_plot_copy_sweep", 0, self)
end


-- 重置
function MoppingResults:resetMopup()

	if getPVENPCResidualCount(self.npcId) > 0 then
		app.load("client.duplicate.pve.PVEResetNPCAttackCount")
		local view = PVEResetNPCAttackCount:new():init(1, self.npcId, 0, 0, {"click_battle_ten_reset_update_draw", self})
		fwin:open(view, fwin._windows)
	else
		TipDlg.drawTextDailog(_string_piece_info[252])
	end
end

--刷新按钮
function MoppingResults:updateBattleTimes()

-- 绘制挑战次数
	local totalAttackTimes = dms.int(dms["npc"], MoppingResults.__npcId, npc.daily_attack_count)
	local addTimes = 0
	if zstring.tonumber(self.currentSceneType) == 1 then
	    if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
	        addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
	    end
	end
	totalAttackTimes = totalAttackTimes + addTimes
	local surplusAttackCount = _ED.npc_current_attack_count[tonumber(MoppingResults.__npcId)]

	
	local finalBattleTimes = totalAttackTimes - surplusAttackCount

	self.cacheBattleTenBtn:setVisible(finalBattleTimes > 0)
	self.cacheBattleTenResetBtn:setVisible(finalBattleTimes <= 0)
	if __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then 
		if  totalAttackTimes < 10 then 
			--有些副本的挑战次数是5
			local timesText = ccui.Helper:seekWidgetByName(self.roots[1],"BitmapFontLabel_1")
			if verifySupportLanguage(_lua_release_language_en) == true then
				timesText:setString(_string_piece_info[358]..finalBattleTimes)
			else
				timesText:setString(_string_piece_info[358]..finalBattleTimes .. _string_piece_info[70])
			end
		end

		if self.totalSweepCount <= totalAttackTimes then 
			self.totalSweepCount = totalAttackTimes
			--在挑战次数不足的时候进来扫荡再一次重置 需要重新设置总挑战数
			if self.m_type ~= nil then
				if self.totalSweepCount >= self.m_type then 
					self.totalSweepCount = self.m_type
				end
			else
				if self.totalSweepCount >= 10 then 
					self.totalSweepCount = 10
				end
			end
		end
	end
end

-- 扫荡
function MoppingResults:launchMopup()
	if TipDlg.drawStorageTipo() == false then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			self.rewardMerge = nil
			local funOpenId = 110
			if tonumber(self.m_type) == 1 then
				funOpenId = 110
			elseif tonumber(self.m_type) == 3 then
				funOpenId = 113
			elseif tonumber(self.m_type) == 10 then
				funOpenId = 111
			elseif tonumber(self.m_type) == 50 then
				funOpenId = 112
			else
				funOpenId = 197
			end
			local myLv = tonumber(_ED.user_info.user_grade)
			local myVip = tonumber(_ED.vip_grade)
			local needLv = dms.int(dms["fun_open_condition"], funOpenId, fun_open_condition.level)
			local needVip = dms.int(dms["fun_open_condition"], funOpenId, fun_open_condition.vip_level)
			if funOpenId == 112 or funOpenId == 197 then
				if myLv < needLv and myVip < needVip then
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], funOpenId, fun_open_condition.tip_info))
					return
				end
			else
				if myLv < needLv or myVip < needVip then
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], funOpenId, fun_open_condition.tip_info))
					return
				end
			end
		else
			local myLv = tonumber(_ED.user_info.user_grade)
			local myVip = tonumber(_ED.vip_grade)
			local needLv = dms.int(dms["fun_open_condition"], 38, fun_open_condition.level)
			local needVip = dms.int(dms["fun_open_condition"], 38, fun_open_condition.vip_level)
			if myLv < needLv or myVip < needVip then
				TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 38, fun_open_condition.tip_info))
				return
			end
		end

		-- 处理 开战时 体力不足 -----------------
		
		local current_food = dms.int(dms["npc"], MoppingResults.__npcId, npc.attack_need_food)
		if zstring.tonumber(_ED.user_info.user_food) < current_food then
			app.load("client.cells.prop.prop_buy_prompt")
			
			local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
			local mid = zstring.tonumber(config[15])
			
			local win = PropBuyPrompt:new()
			win:init(mid)
			fwin:open(win, fwin._ui)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(true)
			return
		end
		
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(false)
		local star = tonumber(_ED.npc_state[tonumber("".. MoppingResults.__npcId )])
		
		if star < 3 then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				TipDlg.drawTextDailog(star == 0 and _string_piece_info[327] or _string_piece_info[328])
				return
			else
				if star == 0 then
					TipDlg.drawTextDailog(_string_piece_info[327])
					return
				else
					TipDlg.drawTextDailog(_string_piece_info[328])
					return
				end
			end
		end

		local currentNpcID =  MoppingResults.__npcId							-- NPCID
		local DifficultyID = 1												-- 攻击下标
		local surplusTimes = 1--self.maxAttackCount - self.currentAttackTimes	-- 扫荡次数
		local elseContent  = "0"											-- 扫荡类型
		
		local totalAttackTimes = dms.int(dms["npc"],  MoppingResults.__npcId, npc.daily_attack_count)
		local addTimes = 0
	    if zstring.tonumber(self.currentSceneType) == 1 then
	        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
	            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
	        end
	    end
	    totalAttackTimes = totalAttackTimes + addTimes
		local surplusAttackCount = _ED.npc_current_attack_count[tonumber( MoppingResults.__npcId)]
		local finalBattleTimes = totalAttackTimes - surplusAttackCount
		if self.m_type ~= nil then
			if (finalBattleTimes > self.m_type) then finalBattleTimes = self.m_type end
		else
			if (finalBattleTimes > 10) then finalBattleTimes = 10 end
		end
		surplusTimes = finalBattleTimes
		
		-- 如果攻击次数不够的情况下
		if tonumber(surplusTimes) <= 0 then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_touch"):setVisible(false)
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_again"):setVisible(true)
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"):setVisible(true)
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_sd_gb"):setVisible(true)
			end
			-- TipDlg.drawTextDailog(_string_piece_info[113])
			state_machine.excute("mopping_results_mopup_buy_times", 0, "")
			return
		end
		
		local root = self.roots[1] 
		if root == nil then 
			return
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			self.sweepCount = surplusTimes
			local current_food = dms.int(dms["npc"], MoppingResults.__npcId, npc.attack_need_food)
			if zstring.tonumber(_ED.user_info.user_food) < current_food*self.sweepCount then
				self.sweepCount = math.floor(zstring.tonumber(_ED.user_info.user_food)/current_food)
			end
			self.totalSweepCount = self.sweepCount
			self.totalInitialNumber = self.sweepCount
		else
			self.sweepCount = 10
		end
		
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then 
			if self.m_type ~= nil then
				if totalAttackTimes < self.m_type then 
					self.sweepCount = totalAttackTimes
				end
			else
				if totalAttackTimes < 10 then 
					self.sweepCount = totalAttackTimes
				end
			end
		end
		local listView = ccui.Helper:seekWidgetByName(root, "ListView_sd_01")
		listView:removeAllItems()

		--------debug.print_r(funOpenId,'funOpenId')

		if self.m_type == 1000 then
			state_machine.excute("auto_raids_window_open", 0, {1000,self.npcId,self})
		else
			state_machine.excute("mopping_results_request_plot_copy_sweep", 0, self)
		end

		-- -- 打开扫荡界面
		-- fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"pve_challenge_principal_sweep_over_update_draw", self}), fwin._window)
		-- -- 关闭自己
		-- fwin:close(self)
	end

end

function MoppingResults:close()
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	-- 	if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, true, nil, false) == false then
			
	-- 	end
	--     if missionIsOver() == false then
	--         local windowLock = fwin:find("WindowLockClass")
	--         if windowLock == nil then
	--             fwin:open(WindowLock:new():init(), fwin._windows)
	--         end
	--     end			
	-- end
	local _level = dms.string(dms["fun_open_condition"],71, fun_open_condition.level)
	if tonumber(_ED.user_info.user_grade) ==  tonumber(_level) then
		local screenSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
		local currentAccount = _ED.user_platform[_ED.default_user].platform_account
		local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
		local saveKey = currentAccount..currentServerNumber.."chatViewDialog".."end"
		local x,y = 0,(screenSize.height/2 + 100 * app.scaleFactor) / app.scaleFactor
		local str = x .. "," .. y .. "," .. "1"
		cc.UserDefault:getInstance():setStringForKey(saveKey, str)
		app.load("client.chat.ChatHomeView")
		state_machine.excute("chat_show_self",0,"chat_show_self")
	end
end

function MoppingResults:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        state_machine.unlock("notification_center_update")

        state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
		state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
       	state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_evolution_button")
       	state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_up_grade_button")
       	if fwin:find("SmEquipmentQianghuaClass") ~= nil then
	       	state_machine.excute("sm_equipment_qianghua_update_hero_icon_push",0,"sm_equipment_qianghua_update_hero_icon_push.")
	       	state_machine.excute("sm_equipment_qianghua_update_equip_icon_push",0,"sm_equipment_qianghua_update_equip_icon_push.")
	       	state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_up_grade")
	    end
       	state_machine.excute("hero_develop_page_updata_hero_icon_push",0,"hero_develop_page_updata_hero_icon_push.")
       	state_machine.excute("sm_role_strengthen_tab_rising_stars_update_golds",0,"sm_role_strengthen_tab_rising_stars_update_golds.")
       	state_machine.excute("sm_role_strengthen_tab_up_product_update_draw",0,"sm_role_strengthen_tab_up_product_update_draw.")

       	--商店推送
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_shop") 
		state_machine.excute("notification_center_update", 0, "push_notification_center_sm_chest_store")

		-- 刷新七天乐的主城icon红点
		state_machine.excute("notification_center_update", 0, "push_notification_7happy_home_push")
	end
	state_machine.remove("mopping_results_close")
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if fwin:find("LPVESceneClass") ~= nil then
			state_machine.excute("lpve_scene_updeteinfo",0,"")
		end
		state_machine.excute("lpve_main_scene_updeteinfo",0,"")
	else
		if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, true, nil, false) == false then
			
		end
	    if missionIsOver() == false then
	        local windowLock = fwin:find("WindowLockClass")
	        if windowLock == nil then
	            fwin:open(WindowLock:new():init(), fwin._windows)
	        end
	    end		
	end

	state_machine.remove("mopping_results_async_create_item")
end

-- 上传文件岛好友任务完成情况
function MoppingResults:upload_fileIslandFriendTaskExecute()
	if tonumber(self.currentSceneType) ==  0 then
	    local function callback(response)
	        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	            local taskInfo = _ED.fileIsland.taskInfo
	            if taskInfo then
	                -- 我的任务
	                local taskInfo1 = {}

	                for i = 1, #taskInfo.mySingleTaskInfo do
	                    local data = taskInfo.mySingleTaskInfo[i]
	                    if data.curProgress == 0 then
	                        local configId = data.configId
	                        local configdata = dms.element(dms["file_island_friend_task"], configId)
	                        local npcNum = dms.atos(configdata, file_island_friend_task.npcNum)
	                        if tonumber(data.selfChallengeTimes) < tonumber(npcNum) then
	                            table.insert(taskInfo1, data)
	                        end
	                    end
	                end

	                for i = 1, #taskInfo.myJoinTaskInfo do
	                    local data = taskInfo.myJoinTaskInfo[i]
	                    data.isMyJoinTaskInfo = true
	                    local configId = data.configId
	                    local configdata = dms.element(dms["file_island_friend_task"], configId)
	                    local npcNum = dms.atos(configdata, file_island_friend_task.friend_npcNum)
	                    if tonumber(data.friendChallengeTimes) < tonumber(npcNum) then
	                        table.insert(taskInfo1, data)
	                    end
	                end

	                for i = 1, #taskInfo.myMultiTaskInfo do
	                    local data = taskInfo.myMultiTaskInfo[i]
	                    if data.curProgress == 0 then
	                        local configId = data.configId
	                        local configdata = dms.element(dms["file_island_friend_task"], configId)
	                        local npcNum = dms.atos(configdata, file_island_friend_task.npcNum)
	                        if tonumber(data.selfChallengeTimes) < tonumber(npcNum) then
	                            table.insert(taskInfo1, data)
	                        end
	                    end
	                end

	                local task = {}
	                for i = 1, #taskInfo1 do
	                    local configId = taskInfo1[i].configId
	                    local configdata = dms.element(dms["file_island_friend_task"], configId)
	                    local npcId = dms.atos(configdata, file_island_friend_task.npcId)
	                    if taskInfo1[i].isMyJoinTaskInfo == true then
	                    	npcId = dms.atos(configdata, file_island_friend_task.friend_npcId)
	                    end

	                    local finderUid = taskInfo1[i].uid
	                    local taskId = taskInfo1[i].taskId

	                    local t = {}
	                    t.npcId = npcId
	                    t.attackCount = 0
	                    table.insert(task, t)
	                end

	                local formation_count = dms.int(dms["npc"], tonumber(self.npcId), npc.formation_count)
	                for i = 1, formation_count do
	                    local environmentIndex = npc.environment_formation1 + i - 1
	                    local environmentId = dms.int(dms["npc"], tonumber(self.npcId), environmentIndex)
	                    for j = 1, 6 do
	                        local environment_shipIndex = environment_formation.seat_one + j - 1
	                        local environment_shipId = dms.int(dms["environment_formation"], environmentId, environment_shipIndex)
	                        if environment_shipId ~= 0 then
	                            local shipId = dms.int(dms["environment_ship"], environment_shipId, environment_ship.directing)
	                            for k = 1, #task do
	                                local t = task[k]
	                                if tonumber(t.npcId) == shipId then
	                                    t.attackCount = t.attackCount + 1
	                                end
	                            end
	                        end
	                    end
	                end

	                local function callback_fileIslandFriendTaskExecute(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                        state_machine.excute("fileIsland_friends_refresh_list", 0, "")
	                    end
	                end

	                local map = {}
	                for k = 1, #task do
	                    local t = task[k]
	                    if t.attackCount ~= 0 then
	                    	local sweepCount = tonumber(self.sweepCount) + 1 
	                        map[t.npcId] = t.attackCount * sweepCount
	                    end
	                end

	                local t = {}
	                for k, v in pairs(map) do
	                    local temp = {}
	                    temp.npcId = k
	                    temp.attackCount = v
	                    table.insert(t, temp)
	                end

	                if #t ~= 0 then
	                    local str = json.encode(t)
	                    protocol_command.fileIslandFriendTaskExecute.param_list = str
	                    NetworkManager:register(protocol_command.fileIslandFriendTaskExecute.code, nil, nil, nil, nil, callback_fileIslandFriendTaskExecute, false, nil)
	                end
	            end
	        
	        end
	    end

	    _ED.fileIsland = _ED.fileIsland or {}
	    protocol_command.fileIslandTaskInfo.param_list = ""
	    NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, callback, false, nil)

	end

end