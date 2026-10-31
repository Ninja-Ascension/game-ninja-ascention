-- ----------------------------------------------------------------------------------------------------
-- 说明：主界面英雄转动
-- 创建时间	2015-03-09
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HomeHero = class("HomeHeroClass", Window)

HomeHero.init_flag = false -- 当前界面创建标识
HomeHero.touch_type = nil
HomeHero.last_selected_hero = nil

function HomeHero:ctor()
    self.super:ctor()   
    self.roots = {}
    self.actions = {}
    -- self.updateCount = 0

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        self._view = fwin._frameview
    end

	-- 将背景起始坐标和第一个武将的起始坐标做绑定
	self.background_image_old_pos_x = 0
	
	self.hero_old_pos_x = 0
	
	self.cells = {}
	
	self.offset_percent = 1
	
	self.bust_index_args = {}
	
	self.panelHero = {}
	
	-- 武将层容器 所在景距
	self._enum_lens_type = {
		_NEAR_LENS = 1,
		_MIDDLE_LENS = 2,
		_FAR_LENS = 3
	}
	
	self.heroes_camera_info = {
		{1, 2},
		{3, 6},
		{4, 5}
	}
	
	-- 当前景距
	self.current_lens_type = self._enum_lens_type._NEAR_LENS
	
	-- 当前界面
	self._enum_window_type = {
		_HOME = 1,
		_FORMATION = 2,
	}
	
	self.binding_window = self._enum_window_type._HOME
	
	self.init_binding_window = nil
	
	-- 当前武将位置(默认在阵型第一个--主角)
	self.current_formetion_index = 1
	
	self.isFirstOpen = true

	-- 长按0.5s触发效果
	self.EFFECT_TIME = 0.5

	-- 序列动作
	self._showEffectAction = nil

	-- 是否执行end事件
	self._isExcuteEndEvent = true
	
	app.load("client.cells.ship.ship_body_for_home_cell")
	
    -- Initialize HomeHero page state machine.
    local function init_home_hero_terminal()
	
		local move_hero_terminal = {
            _name = "move_hero",
            _init = function (terminal)               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if terminal._state == 0 then--往右滑动
					for i = 1, 6 do
						local cell = terminal.heroCardsTable[i]
						local temp = terminal.penelTabel[(i+terminal.index)%6 + 1]
						local tempScale = terminal.penelTabel[(i+terminal.index)%6+ 1]:getScale()
						terminal.createAction(cell, cc.p(temp:getPositionX() , temp:getPositionY()), tempScale)
					end
					terminal.index = (terminal.index + 1)%6
					terminal.changeLevel(terminal.heroCardsTable, terminal.index)
				elseif terminal._state == 1 then--往左滑动
					for i = 1, 6 do
						local cell = terminal.heroCardsTable[i]
						local s = (i+terminal.index - 1)%6
						if s == 0 then
							local temp = terminal.penelTabel[6]
							local tempScale = terminal.penelTabel[6]:getScale()
							terminal.createAction(cell, cc.p(temp:getPositionX() , temp:getPositionY()), tempScale)
						elseif s > 0 then
							local temp = terminal.penelTabel[s]
							local tempScale = terminal.penelTabel[s]:getScale()
							terminal.createAction(cell, cc.p(temp:getPositionX() , temp:getPositionY()), tempScale)
						end
					end
					terminal.index = (terminal.index- 1) %6
					terminal.changeLevel(terminal.heroCardsTable, terminal.index)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
			heroCardsTable = {},
			penelTabel = {},
			index = 0,
			createAction = function (_uObj, _pos, _scale)
				local move1  = cc.MoveTo:create(0.5, _pos)
				local scaleTo = cc.ScaleTo:create(0.5, _scale)
				_uObj:stopAllActions()
				_uObj:runAction(move1)
				_uObj:runAction(scaleTo)
			end,
			changeLevel = function	(tabel, index)
				for i = 1,6 do
					local level = math.abs((i + index)%6)
					if level == 0 then
						level = 1
					end
					if level == 1 then
						tabel[i]:setLocalZOrder(3)
					elseif level == 2 or level == 6 then
						tabel[i]:setLocalZOrder(2)
					elseif level == 3 or level == 5 then
						tabel[i]:setLocalZOrder(1)
					elseif level == 4 then 
						tabel[i]:setLocalZOrder(0)
					end
				end
			end
        }
	
		local home_hero_touch_move_terminal = {
            _name = "home_hero_touch_move",
            _init = function (terminal)               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local __spoint = params:getTouchBeganPosition()
				local __epoint = params:getTouchEndPosition()
				if __spoint.x - __epoint.x > 15  then--左移
					state_machine.excute("move_hero", 1,"")
				elseif __epoint.x - __spoint.x > 15 then--右移
					state_machine.excute("move_hero", 0,"")
				elseif math.abs(__epoint.x - __spoint.x) < 5 then
					state_machine.excute("menu_manager", 0, "")
					fwin:open(Formation:new(), fwin._view) 
					local csbMenu = fwin:find("MenuClass"):getChildByTag(100000)
					local root = csbMenu:getChildByName("root")
					local Image = ccui.Helper:seekWidgetByName(root, "Image_line-uo")
					Image:setVisible(true)
					state_machine.find("menu_manager").old_page = 2
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_hero_update_draw_hero_move_terminal = {
            _name = "home_hero_update_draw_hero_move",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDrawHeroMove(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_hero_camera_controller_terminal = {
            _name = "home_hero_camera_controller",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end

            	if terminal.last_terminal_name ~= params._datas.next_terminal_name then
            		if terminal.camera_actions == nil then
            			terminal.camera_actions = params._datas.camera_actions
            			return
            		end
					
					if params._datas._not_play == false then
					
					else
						instance.actions[1]:play(terminal.camera_actions[params._datas.camera_index], false)
					end	
					
            		terminal.camera_actions = params._datas.camera_actions

					instance.current_lens_type = params._datas.camera_index
					
					instance.actions[1]:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str ~= nil then
							-- 视角动画播放结束
						end
					end)
					
					-- terminal.page_name = params._datas.but_image

					-- terminal.last_terminal_name = params._datas.next_terminal_name
     --                state_machine.excute("menu_manager_change_to_page", 0, params)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
    	}

    	local home_hero_camera_controller_change_view_terminal = {
            _name = "home_hero_camera_controller_change_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
    	}
		
		-- 点击主面武将的响应事件处理
		local home_hero_into_formation_page_terminal = {
            _name = "home_hero_into_formation_page",
            _init = function (terminal) 
                app.load("client.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local formetion_index = params._datas._formetion_index
				if instance.binding_window == instance._enum_window_type._HOME then
					if __lua_project_id == __lua_project_gragon_tiger_gate 
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
						or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						if tonumber(_ED.user_formetion_status[formetion_index]) == 0 or _ED.user_formetion_status[formetion_index] == "" then
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								-- 判断是否有可上阵角色
								if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
								else
									local formation_count = 0
									local total_count = 0
									for i = 1, 6 do
										if tonumber(_ED.user_formetion_status[i]) ~= nil and tonumber(_ED.user_formetion_status[i]) > 0 then
											formation_count = formation_count + 1
										end
									end
									for k, v in pairs(_ED.user_ship) do
										total_count = total_count + 1
									end
									if formation_count >= total_count then
										return false
									end
								end
							end

							local addIndex = -1
							for i=2, 7 do
								if zstring.tonumber(_ED.formetion[i]) == 0 then
									addIndex = i - 1
									break
								end
							end					
							state_machine.excute("open_add_ship_window", 0, {_index = formetion_index, _type = 1, _shipId = -1})
							return true
						end
					end

					local canResponse = false
					
					-- 取消角色近、中、远三层锁定状态的处理
					-- for i, v in pairs(instance.heroes_camera_info[instance.current_lens_type]) do
					-- 	if v == formetion_index then
					-- 		canResponse = true
					-- 		break
					-- 	end	
					-- end
					
					-- if canResponse == false then
					-- 	return false
					-- end	
				
					instance.current_formetion_index = formetion_index
				
					HomeHero.init_flag = true
				
					state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = params._datas._heroInstance, _touch_type = "hero", _enter_type = "home"}})
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
						state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
					end
					-- state_machine.excute("home_hero_binding_window_change", 0, instance._enum_window_type._FORMATION)
					return true
				elseif instance.binding_window == instance._enum_window_type._FORMATION then
					-- 只能响应当前显示武将的切换
					if instance.current_formetion_index ~= formetion_index then
						return false
					end
					
					local direction = params._datas._direction
					local heroInstance = params._datas._heroInstance
					
					if heroInstance ~= nil and heroInstance.ship_id == "0" and direction == nil then
						-- 上阵响应
						local addIndex = -1
						for i=2, 7 do
							if zstring.tonumber(_ED.formetion[i]) == 0 then
								addIndex = i - 1
								break
							end
						end
						state_machine.excute("open_add_ship_window", 0, {_index = formetion_index, _type = 1, _shipId = -1})
					end
					
					if direction == nil then
						return false
					end
					
					state_machine.excute("home_hero_action_switch_in_formation", 0, 
					{
						_direction = direction, 
						_start_index = formetion_index,
						_size = 1
					})
					return true
				end
				
                return false
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 首页、阵容之间切换的武将放大缩小动画管理
		local home_hero_action_scale_between_home_and_formation_terminal = {
            _name = "home_hero_action_scale_between_home_and_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local action = instance.actions[1]
				
				-- 根据instance.current_formetion_index 来决定哪个角色的动画
				-- params._speed为动画播放倍数，当等于 -1 则直接跳到结束帧
				
				if params._to == instance._enum_window_type._FORMATION then
					 -- print("进入阵容",instance.current_formetion_index)
					
					if params._from == nil then
						-- print("直接 进入阵容 -- 无动画")
						
						-- 停留在角色放大的结束帧
						local action_name = "line_role_" .. instance.current_formetion_index
						action:play(action_name, false)
						
						state_machine.excute("formation_play_into_action", 0, "")
						
						HomeHero.init_flag = true
						
					elseif params._from == instance._enum_window_type._HOME then
						 -- print("放大 进入阵容",instance.current_formetion_index)
						
						if HomeHero.touch_type == "menu" then
							-- _frame_func
							 -- print("先切换镜头")
							local temp_current_lens_type = instance._enum_lens_type._NEAR_LENS
							for i, v in pairs(instance.heroes_camera_info) do
								for m, n in pairs(v) do
									if n == instance.current_formetion_index then
										temp_current_lens_type = i
									end
								end
							end
							
							local temp_camera_actions = nil
							
							if instance.current_lens_type == instance._enum_lens_type._NEAR_LENS then
								temp_camera_actions = {"", "Button_view_2_j_z_touch", "Button_view_3_j_y_touch"}
							elseif instance.current_lens_type == instance._enum_lens_type._MIDDLE_LENS then
								temp_camera_actions = {"Button_view_1_z_j_touch", "", "Button_view_3_z_y_touch"}
							elseif instance.current_lens_type == instance._enum_lens_type._FAR_LENS then
								temp_camera_actions = {"Button_view_1_y_j_touch", "Button_view_2_y_z_touch", ""}
							end
							if temp_camera_actions[temp_current_lens_type] ~= "" then
								instance.actions[1]:play(temp_camera_actions[temp_current_lens_type], false)
								local bFrameEvent = false
								instance.actions[1]:setFrameEventCallFunc(function (frame)
									if nil == frame then
										return
									end

									local str = frame:getEvent()
									if str == temp_camera_actions[temp_current_lens_type] .. "_over" then
										local action_name = "home_line_" .. instance.current_formetion_index
										action:play(action_name, false)
										action:setFrameEventCallFunc(function (frame)
											if nil == frame then
												return
											end

											local str = frame:getEvent()
											if str == "home_line_" .. "over_" .. instance.current_formetion_index then
												state_machine.excute("formation_play_into_action", 0, "")
											end
										end)
										
										-- bFrameEvent = true
										-- if bFrameEvent == true then
											 -- action:setFrameEventCallFunc(function (frame)
												-- if nil == frame then
													-- return
												-- end

												-- local str = frame:getEvent()
												-- if str ~= nil then
													-- -- 视角动画播放结束
												-- end
											-- end)
										-- end
									end
								end)
							else
								local action_name = "home_line_" .. instance.current_formetion_index
								action:play(action_name, false)
								action:setFrameEventCallFunc(function (frame)
									if nil == frame then
										return
									end

									local str = frame:getEvent()
									if str == "home_line_" .. "over_" .. instance.current_formetion_index then
										state_machine.excute("formation_play_into_action", 0, "")
									end
								end)
							end
							HomeHero.last_selected_hero = {ship_id = _ED.user_formetion_status[instance.current_formetion_index], index = instance.current_formetion_index}
							-- print("home_line_" .. instance.current_formetion_index)
						else
							-- print("直接放大","home_line_" .. instance.current_formetion_index)
							local action_name = "home_line_" .. instance.current_formetion_index
							action:play(action_name, false)
							action:setFrameEventCallFunc(function (frame)
								if nil == frame then
									return
								end

								local str = frame:getEvent()
								if str == "home_line_" .. "over_" .. instance.current_formetion_index then
									state_machine.excute("formation_play_into_action", 0, "")
								end
							end)
							
							HomeHero.last_selected_hero = {ship_id = _ED.user_formetion_status[instance.current_formetion_index], index = instance.current_formetion_index}
						end
					end
				
				elseif params._to == instance._enum_window_type._HOME then
					 -- print("进入主页",instance.current_formetion_index)
					
					if params._from == nil then
						 -- print("直接 进入主页 -- 无动画",instance.current_formetion_index)
						
						-- 停留在近景
						
						HomeHero.init_flag = true
						
					elseif params._from == instance._enum_window_type._FORMATION then
						 -- print("缩小 进入主页",instance.current_formetion_index)
						
						local action_name = "line_home_" .. instance.current_formetion_index
						action:play(action_name, false)
						
						-- 修改景距，调用 home_hero_camera_controller 状态机,但是不播放该状态机动画
						local temp_current_lens_type = instance._enum_lens_type._NEAR_LENS
						for i, v in pairs(instance.heroes_camera_info) do
							for m, n in pairs(v) do
								if n == instance.current_formetion_index then
									temp_current_lens_type = i
								end
							end
						end
						
						local temp_camera_actions = nil
						
						if temp_current_lens_type == instance._enum_lens_type._NEAR_LENS then
							temp_camera_actions = {"", "Button_view_2_j_z_touch", "Button_view_3_j_y_touch"}
						elseif temp_current_lens_type == instance._enum_lens_type._MIDDLE_LENS then
							temp_camera_actions = {"Button_view_1_z_j_touch", "", "Button_view_3_z_y_touch"}
						elseif temp_current_lens_type == instance._enum_lens_type._FAR_LENS then
							temp_camera_actions = {"Button_view_1_y_j_touch", "Button_view_2_y_z_touch", ""}
						end
						
						state_machine.excute("home_hero_camera_controller", 0, 
							{
								_datas = 
								{
									terminal_name = "home_hero_camera_controller", 	
									next_terminal_name = "home_hero_camera_controller_" .. temp_current_lens_type, 			
									current_button_name = "Button_view_" .. temp_current_lens_type, 	
									camera_index = temp_current_lens_type,	
									_not_play = false,
									but_image = "", 	
									terminal_state = 0, 
									camera_actions = temp_camera_actions,
									isPressedActionEnabled = true
								}
							}
						)
					end
				end  
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 阵容中武将切换动画管理
		local home_hero_action_switch_in_formation_terminal = {
            _name = "home_hero_action_switch_in_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		if instance == nil or instance.roots == nil then
            			return
            		end
            	end
				local action = instance.actions[1]
				
				local direction = params._direction 		-- 滑动方向
				local start_index = params._start_index		-- 起始武将索引
				local size = params._size					-- 滑动武将数量，最大为5
			
				if size < 1 then
					return false
				end	
			
				if direction == "L" then
					-- 播放动画
					local end_index = start_index == 6 and 1 or start_index + 1
					if instance.panelHero[end_index].shipId == "-1" and size == 1 and params._unlock ~= true then
						 -- print("被锁住了")
						return false
					end	
					
					if start_index + size <= 6 then
						instance.current_formetion_index = start_index + size
					else
						instance.current_formetion_index = start_index + size - 6
					end
					
					local finalFunc = function()
						-- 改变武将阵容信息
						state_machine.excute("formation_hero_info_change", 0, {_ED.user_formetion_status[instance.current_formetion_index], instance.current_formetion_index})
					end
					
					if size > 1 then
						-- finalFunc = nil
					end
					
					local oneActionPlay = nil
					
					oneActionPlay = function()
						local action_name = string.format("line_%d_%d", start_index, end_index)
						if size == 1 then
							if finalFunc ~= nil then
								finalFunc()
							end
							
							return
						end
						
						size = size - 1
						start_index = start_index + 1 <= 6 and start_index + 1 or 1
						end_index = start_index + 1 <= 6 and start_index + 1 or 1
							
						oneActionPlay()
					end
					
					oneActionPlay()
					
				elseif direction == "R" then
					-- 播放动画
					local end_index = start_index == 1 and 6 or start_index - 1
					
					if instance.panelHero[end_index].shipId == "-1" and size == 1 and params._unlock ~= true then
						 -- print("被锁住了")
						return false
					end	
					
					if start_index - size <= 0 then
						instance.current_formetion_index = start_index - size + 6
					else
						instance.current_formetion_index = start_index - size
					end
					
					local finalFunc = function()
						-- 改变武将阵容信息
						state_machine.excute("formation_hero_info_change", 0, {_ED.user_formetion_status[instance.current_formetion_index], instance.current_formetion_index})
					end
					
					if size > 1 then
						-- finalFunc = nil
					end
					
					local oneActionPlay = nil
					
					oneActionPlay = function()
						local action_name = string.format("line_%d_%d", start_index, end_index)
						if size == 1 then
							if finalFunc ~= nil then
								finalFunc()
							end
							
							return
						end
						
						size = size - 1
						start_index = start_index - 1 > 0 and start_index - 1 or 6
						end_index = end_index - 1 > 0 and end_index - 1 or 6
							
						oneActionPlay()
					end
					
					oneActionPlay()
					
				end
				
				HomeHero.last_selected_hero = {ship_id = _ED.user_formetion_status[instance.current_formetion_index], index = instance.current_formetion_index}
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 与该界面绑定的界面切换操作
		local home_hero_binding_window_change_terminal = {
            _name = "home_hero_binding_window_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local new_binding_window = params
				
				if instance.binding_window == new_binding_window then
					 -- print("false",new_binding_window)
					return false
				else
					instance.binding_window = new_binding_window
					 -- print("true",new_binding_window)
					if instance.binding_window == instance._enum_window_type._HOME then
						-- 显示近中远3个景距按钮
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_226"):setVisible(true)
						
						 -- print("切换到主页")
						
						local temp_from = nil
						local temp_to = nil
						local temp_speed = nil
						
						if HomeHero.init_flag == false then
							-- instance.init_flag = true
							
							temp_from = nil
							temp_to = instance._enum_window_type._HOME
							temp_speed = 1
						else
							temp_from = instance._enum_window_type._FORMATION
							temp_to = instance._enum_window_type._HOME
							temp_speed = 1
						end
						
						-- state_machine.excute("home_hero_action_scale_between_home_and_formation", 0 , 
						-- {
							-- _from = temp_from,
							-- _to = temp_to,
							-- _speed = temp_speed,
						-- })
					elseif  instance.binding_window == instance._enum_window_type._FORMATION then
						-- 隐藏近中远3个景距按钮
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_226"):setVisible(false)
						
						 -- print("切换到阵容")
						
						local temp_from = nil
						local temp_to = nil
						local temp_speed = nil
						
						if HomeHero.init_flag == false then
							-- instance.init_flag = true
							
							temp_from = nil
							temp_to = instance._enum_window_type._FORMATION
							temp_speed = 1
						else
							temp_from = instance._enum_window_type._HOME
							temp_to = instance._enum_window_type._FORMATION
							temp_speed = 1
						end
						
						-- state_machine.excute("home_hero_action_scale_between_home_and_formation", 0 , 
						-- {
							-- _from = temp_from,
							-- _to = temp_to,
							-- _speed = _speed,
						-- })
					end
				end	
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 上阵
		local home_hero_choice_hero_battle_request_terminal = {
            _name = "home_hero_choice_hero_battle_request",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local requestInfo = zstring.zsplit(params, "|")
				local shipId = requestInfo[1] --战船id
				local formationIndex = instance.current_formetion_index
				local heroPad = instance.panelHero[formationIndex]
				
				local real_pos = tonumber(requestInfo[3])
				if real_pos ~= -1 and real_pos ~= formationIndex then
					-- 镜头转换
					
					local last_index = formationIndex
					local now_index = real_pos
					
					local direction = now_index - last_index > 0 and "L" or "R"
					local size = math.abs(now_index - last_index)
					if last_index == 6 and now_index == 1 then
						direction = "L"
						size = 1
					elseif last_index == 1 and now_index == 6 then
						direction = "R"
						size = 1
					end	
					
					state_machine.excute("home_hero_action_switch_in_formation", 0, 
					{
						_direction = direction, 
						_start_index = last_index,
						_size = size
					})
					
					formationIndex = real_pos
					heroPad = instance.panelHero[formationIndex]
				end
				
				if _ED.user_ship[shipId] ~= nil then
					local _ship_mould_id = _ED.user_ship[shipId].ship_template_id
					local temp_bust_index = 0
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						----------------------新的数码的形象------------------------
						--进化形象
						local evo_image = dms.string(dms["ship_mould"], _ship_mould_id, ship_mould.fitSkillTwo)
						local evo_info = zstring.split(evo_image, ",")
						--进化模板id
						local ship_evo = zstring.split(_ED.user_ship[shipId].evolution_status, "|")
						local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[shipId])
						--新的形象编号
						temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
					else
						temp_bust_index = dms.int(dms["ship_mould"], _ship_mould_id, ship_mould.bust_index)
					end
					table.insert(instance.bust_index_args, temp_bust_index)
					
					if zstring.tonumber(shipId) > 0 then 
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_lock_".. formationIndex):setVisible(false)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								--进化形象
							local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.fitSkillTwo)
							local evo_info = zstring.split(evo_image, ",")
							--进化模板id
							local ship_evo = zstring.split(_ED.user_ship[shipId].evolution_status, "|")
							local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[shipId])
							local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
							local word_info = dms.element(dms["word_mould"], name_mould_id)
							name = word_info[3]
							if getShipNameOrder(tonumber(_ED.user_ship[shipId].Order)) > 0 then
								name = name.." +"..getShipNameOrder(tonumber(_ED.user_ship[shipId].Order))
							end
							local quality = shipOrEquipSetColour(tonumber(_ED.user_ship[shipId].Order))
							color_R = tipStringInfo_quality_color_Type[quality][1]
							color_G = tipStringInfo_quality_color_Type[quality][2]
							color_B = tipStringInfo_quality_color_Type[quality][3]
							

							--画武将的名称和星级
							--名称
							local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_".. i)
							Text_name:setString(name.." ".."Lv.".._ED.user_ship[shipId].ship_grade)

							Text_name:setColor(cc.c3b(color_R, color_G, color_B))
							--攻防
							local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_".. i)
							Panel_strengthen_stye:removeBackGroundImage()
						    local camp_preference = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.camp_preference)
						    if camp_preference> 0 and camp_preference <=3 then
						        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
						    end

						    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
								local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv_".. i)
								local Panel_strengthen_stye_lv = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_lv_".. i)
								Panel_strengthen_stye_lv:removeBackGroundImage()
								Panel_strengthen_stye_lv:setBackGroundImage(string.format("images/ui/icon/type_icon_lv_%d.png", camp_preference))
								Text_name:setString(name)
								Text_lv:setString("Lv.".._ED.user_ship[shipId].ship_grade)
							end
							--星星
							local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_".. i)
							Panel_star:removeAllChildren(true)
							neWshowShipStar(Panel_star,tonumber(_ED.user_ship[shipId].StarRating))
                            require('home_hero_labels').safeApply(root,i,_ED.user_ship[shipId])

							local Panel_234_add = ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i)
							Panel_234_add:setVisible(true)
							local Panel_zhenwei_dh = ccui.Helper:seekWidgetByName(root, "Panel_zhenwei_dh_".. i)
							if Panel_zhenwei_dh.animation ~= nil then
								Panel_zhenwei_dh.animation:removeFromParent(true)
							end
							local jsonFile = "sprite/spirte_zhuchengkapaidi.json"
					        local atlasFile = "sprite/spirte_zhuchengkapaidi.atlas"
					        Panel_zhenwei_dh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
					        Panel_zhenwei_dh:addChild(Panel_zhenwei_dh.animation)
					    else    
							ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_234_add_".. formationIndex):setVisible(false)
						end
						local panel_size = heroPad:getContentSize()

						-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
						
						-- local armature = ccs.Armature:create("spirte_" .. temp_bust_index)
						-- armature:getAnimation():playWithIndex(0)
					
						-- heroPad:removeAllChildren(true)
						-- heroPad:addChild(armature)
						
						-- -- armature:setAnchorPoint(cc.p(0.5, 0.5))
						
						
						-- -- armature:setPosition(cc.p(panel_size.width, panel_size.height/2))
						-- -- armature:setContentSize(panel_size)
						-- armature:setPosition(cc.p(panel_size.width/2, 0))

						heroPad:removeAllChildren(true)
						require('home_hero_base_effect').add(heroPad)
						draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), heroPad, nil, nil, cc.p(0.5, 0))
						if animationMode == 1 then
							app.load("client.battle.fight.FightEnum")
							local shipSpine = sp.spine_sprite(heroPad, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
							-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						 --        shipSpine:setScaleX(-1)
						 --    end
						else
							draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", heroPad, -1, nil, nil, cc.p(0.5, 0))
						end
						
						local function heroTouchEvent(sender, eventType)
							local __spoint = sender:getTouchBeganPosition()
							local __mpoint = sender:getTouchMovePosition()
							local __epoint = sender:getTouchEndPosition()
						
							if eventType == ccui.TouchEventType.began then
							
							elseif eventType == ccui.TouchEventType.ended 
								or eventType == ccui.TouchEventType.canceled 
								then
							  	sender._one_called = false
								if __epoint.x - __spoint.x > 8 and instance.binding_window == instance._enum_window_type._FORMATION then
									-- left向左切换武将
									sender._one_called = true
									state_machine.excute("home_hero_into_formation_page", 0, {_datas = {_heroInstance = _ED.user_ship[shipId], _formetion_index = formationIndex, _direction = "L"}})
								elseif __spoint.x - __epoint.x > 8 and instance.binding_window == instance._enum_window_type._FORMATION then
									-- right向右切换武将
									sender._one_called = true
									state_machine.excute("home_hero_into_formation_page", 0, {_datas = {_heroInstance = _ED.user_ship[shipId], _formetion_index = formationIndex, _direction = "R"}})
								elseif eventType == ccui.TouchEventType.ended then
									sender._one_called = true
									state_machine.excute("home_hero_into_formation_page", 0, {_datas = {_heroInstance = _ED.user_ship[shipId], _formetion_index = formationIndex}})
								end	
							end
						end	
						heroPad:addTouchEventListener(heroTouchEvent)
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							heroPad.callback = heroTouchEvent
						end
					end
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
					state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
    	}
		
		-- 重绘首页角色
		local home_hero_refresh_draw_terminal = {
            _name = "home_hero_refresh_draw",
            _init = function (terminal)               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local win = fwin:find("HomeHeroClass")
				if nil ~= win then
					win:onUpdateDraw()
				end
				-- instance:onHeroesDraw()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
				-- 重绘主角
		local home_hero_main_refresh_draw_terminal = {
            _name = "home_hero_main_refresh_draw",
            _init = function (terminal)               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local win = fwin:find("HomeHeroClass")
				if nil ~= win then
					win:onMainHeroesDraw()
				end
				-- instance:onHeroesDraw()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
				-- 上阵信息显示
		local home_hero_main_tip_show_terminal = {
            _name = "home_hero_main_tip_show",
            _init = function (terminal)               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	            	local previousShip = {
						ship_id = -1,
						ship_courage = 0,
						ship_health = 0,
						ship_intellect = 0,
						ship_quick = 0,
					}

	            	local ship = params.ship
	            	if ship == nil then
	            		return
	            	end
	            	instance:showPropertyChangeTipInfo(previousShip,ship,nil,true)
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local home_hero_hide_event_terminal = {
            _name = "home_hero_hide_event",
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
		
		-- 显示界面
        local home_hero_show_event_terminal = {
            _name = "home_hero_show_event",
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

        -- 修改背景图
        local home_hero_change_backGroudImage_terminal = {
            _name = "home_hero_change_backGroudImage",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateBackGroud()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 修改背景图
        local home_hero_find_target_with_mission_terminal = {
            _name = "home_hero_find_target_with_mission",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:findTargetWithMission(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开神秘商店
        local home_open_secret_shop_terminal = {
            _name = "home_open_secret_shop",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:openSecretShop(params)
                return false
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 播放角色特殊效果
		local home_hero_show_special_effect_terminal = {
            _name = "home_hero_show_special_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- DSC项目
            	if __lua_project_id == __lua_project_l_digital then
	            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil and params ~= nil then
	    				local ship_mould_id = params.ship_mould_id
						local shipSpine = params.shipSpine

						-- print("ship_mould_id = ", ship_mould_id, " shipSpine = ", shipSpine)
						local canPlaySpecialEffect = instance:canPlaySpecialAnimation(ship_mould_id)
						if canPlaySpecialEffect == true then
							self._isExcuteEndEvent = false

							if shipSpine ~= nil then
								local function changeActionCallback(armatureBack)
									armatureBack._invoke = nil
									-- print("动画播放结束")
								end

								shipSpine._invoke = changeActionCallback
								csb.animationChangeToAction(shipSpine, _enum_animation_l_frame_index.animation_new_skill_30_dingdian, _enum_animation_l_frame_index.animation_standby, false)
							end
						end
            		end
            	end
                return false
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 处理彩蛋领奖
		local home_hero_easter_egg_get_reward_terminal = {
            _name = "home_hero_easter_egg_get_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				if _ED.active_activity[191] ~= nil then 
					local shipId = params.ship_mould_id
					local eventInfo = dms.searchs(dms["easter_event_mould"], easter_egg_mould.cd, shipId)
					if eventInfo then 
						-- 是cd事件
						local eggInfo = eventInfo[1]
						local eventId = eggInfo[easter_egg_mould.ID]
						local maxGet = tonumber(eggInfo[easter_egg_mould.limit])
						local haveGet = tonumber(_ED.active_activity[191].activity_info["" .. eventId].haveGet)
						-- 彩蛋是否开放
						app.load("client.activity.easter_egg.EasterEggHandle")
						local curDay = EasterEggHandle.getEasterEggDays()
						local showData = zstring.split(dms.string(dms["activity_config"], 124, activity_config.param), "|")
						for i, v in ipairs(showData) do
							if i <= curDay then 
								local info = zstring.split(v, ",")
								for k, val in ipairs(info) do
									if tonumber(val) == tonumber(eventId) and haveGet < maxGet then
										self._isExcuteEndEvent = false
										local canGet = true
										local lastGet = tonumber(_ED.active_activity[191].activity_info["" .. eventId].haveTime)
										if lastGet ~= -1 then 
											local cutTime = math.floor((((os.time() + _ED.time_add_or_sub) * 1000) - lastGet)/1000)
											local limit = dms.int(dms["activity_config"], 126, activity_config.param)
											if cutTime < limit then 
												canGet = false
												TipDlg.drawTextDailog(tipStringInfo_easter_egg_tips[1])
											end
										end
										if canGet then 
											local function refrushShipCallback()
												-- 上阵界面刷新
												state_machine.excute("home_hero_refresh_draw", 0, "")
											end
											EasterEggHandle.showEasterEggReward(eventId,refrushShipCallback)
										end
										return 
									end
								end
							end
						end
					end
				end
            	
                return false
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(move_hero_terminal)
		state_machine.add(home_hero_touch_move_terminal)
        state_machine.add(home_hero_update_draw_hero_move_terminal)
		state_machine.add(home_hero_show_special_effect_terminal)
		state_machine.add(home_hero_easter_egg_get_reward_terminal)
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
			state_machine.add(home_hero_camera_controller_terminal)
			state_machine.add(home_hero_camera_controller_change_view_terminal)
			state_machine.add(home_hero_into_formation_page_terminal)
			state_machine.add(home_hero_action_scale_between_home_and_formation_terminal)
			state_machine.add(home_hero_action_switch_in_formation_terminal)
			state_machine.add(home_hero_binding_window_change_terminal)
			state_machine.add(home_hero_choice_hero_battle_request_terminal)
			state_machine.add(home_hero_refresh_draw_terminal)
			state_machine.add(home_hero_main_refresh_draw_terminal)
			state_machine.add(home_hero_main_tip_show_terminal)
			state_machine.add(home_hero_hide_event_terminal)
			state_machine.add(home_hero_show_event_terminal)
			state_machine.add(home_hero_change_backGroudImage_terminal)
			state_machine.add(home_hero_find_target_with_mission_terminal)
			state_machine.add(home_open_secret_shop_terminal)
		end
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_home_hero_terminal()

end

function HomeHero:updateBackGroud()
	local root = self.roots[1]
	local Panel_home_bg = ccui.Helper:seekWidgetByName(root, "Panel_home_bg")
	if Panel_home_bg ~= nil then
		Panel_home_bg:removeBackGroundImage()
		local backGround = cc.UserDefault:getInstance():getStringForKey(getKey("backGroundImage"))
		if backGround == nil or backGround == "" then
			backGround = 1
			writeKey("backGroundImage", 1)
		end
		Panel_home_bg:setBackGroundImage(string.format("images/ui/bg/home_bg_%d.png",backGround))
	end
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		local Panel_dh_bg = ccui.Helper:seekWidgetByName(root, "Panel_dh_bg")
		if Panel_dh_bg ~= nil then
		    if Panel_dh_bg.animation ~= nil then
		        Panel_dh_bg.animation:removeFromParent(true)
		    end
		    local jsonFile = "sprite/spirte_zc.json"
		    local atlasFile = "sprite/spirte_zc.atlas"
		    Panel_dh_bg.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		    Panel_dh_bg:addChild(Panel_dh_bg.animation)
		end
	-- end
end

function HomeHero:findTargetWithMission(params)
	-- local shipMouldId = params
	-- for i, v in pairs(self.panelHero) do
	-- 	local shipId = tonumber(v.shipId)
	-- 	if nil ~= shipId and shipId > 0 then
	-- 		local ship = _ED.user_ship[v.shipId]
	-- 		if nil ~= ship and ship.ship_template_id == shipMouldId then
	-- 			return v
	-- 		end
	-- 	end
	-- end

	local ids = zstring.split(params, ",", function ( value )
		return tonumber(value)
	end)
	for i, v in pairs(ids) do
		local target = self.panelHero[v]
		local shipId = tonumber(target.shipId)
		if nil ~= shipId and shipId > 0 then
			return target
		end
	end
	return nil
end

function HomeHero:openSecretShop(changeAction)
	-- self.Panel_em_donghua:setVisible(false)
	-- self.Panel_mysterious_shop:setVisible(true)
	-- -- csb.animationChangeToAction(self.ArmatureNode_mysterious_shop, 1, 0, false)
	
	if nil ~= _ED.secret_shop_info then
		local currentTime = (_ED.system_time + (os.time() - _ED.native_time))
		if _ED.secret_shop_info.end_time > currentTime then
			self.Panel_mysterious_shop:setVisible(true)
			self.Panel_em_donghua:setVisible(false)
			self:runAction(cc.Sequence:create({
					cc.DelayTime:create(_ED.secret_shop_info.end_time - currentTime),
					cc.CallFunc:create(function ( sender )
						_ED.secret_shop_info = nil
						sender.Panel_mysterious_shop:setVisible(false)
						sender.Panel_em_donghua:setVisible(true)
					end)
				}))

			if (true == changeAction and _ED.secret_shop_info_time ~= _ED.secret_shop_info.end_time) then
				csb.animationChangeToAction(self.ArmatureNode_mysterious_shop, 1, 0, false)
				print(self.ArmatureNode_mysterious_shop._nextAction, self.ArmatureNode_mysterious_shop._actionIndex)
			end
			_ED.secret_shop_info_time = _ED.secret_shop_info.end_time
		else
			_ED.secret_shop_info = nil
		end
	end
	-- Fury: sin escaparate el barco se esconde, igual que al cumplirse el
	-- plazo. Con la ciudad tapada (`fwin:cover` la pausa) el DelayTime de
	-- arriba no corre; al volver de una mazmorra (LDuplicateWindow:destroy)
	-- la rama de caducado borraba el escaparate y dejaba el barco tocable.
	if nil == _ED.secret_shop_info and nil ~= self.Panel_mysterious_shop then
		self.Panel_mysterious_shop:setVisible(false)
		if nil ~= self.Panel_em_donghua then
			self.Panel_em_donghua:setVisible(true)
		end
	end
end

function HomeHero:onHide()
	for i, v in pairs(self.roots) do
		v:setVisible(false)
	end
end

function HomeHero:onShow()
	for i, v in pairs(self.roots) do
		v:setVisible(true)
	end
end

function HomeHero:updateDrawHeroMove(_opacity)
    local root = self.roots[1]
    local pageView = ccui.Helper:seekWidgetByName(root, "PageView_huadong")
    local pages = pageView:getPages()
    for i, v in pairs(pages) do
    	v.roots[1]:setOpacity(_opacity)
    end
end

function HomeHero:onMainHeroesDraw()
	local root = self.roots[1]

	local nCount = 0 
		
	for i, v in pairs(self.bust_index_args) do
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_" .. v .. ".ExportJson")
	end	

	for i = 1, 6 do
		local shipId = _ED.user_formetion_status[i]
		if zstring.tonumber(shipId) > 0 then 
			nCount = nCount + 1
		end
		local isupdate = false
		if _ED.user_ship[shipId] ~= nil then
			if tonumber(_ED.user_ship[shipId].captain_type) == 0 then
				isupdate = true
			end
		end
			
		if isupdate == true then
			self.panelHero[i].shipId = shipId
			if _ED.user_ship[shipId] ~= nil then
				local _ship_mould_id = _ED.user_ship[shipId].ship_template_id
				local temp_bust_index = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					----------------------新的数码的形象------------------------
					--进化形象
					local evo_image = dms.string(dms["ship_mould"], _ship_mould_id, ship_mould.fitSkillTwo)
					local evo_info = zstring.split(evo_image, ",")
					--进化模板id
					local ship_evo = zstring.split(_ED.user_ship[shipId].evolution_status, "|")
					local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[shipId])
					--新的形象编号
					temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				else
					temp_bust_index = dms.int(dms["ship_mould"], _ship_mould_id, ship_mould.bust_index)
				end
				table.insert(self.bust_index_args, temp_bust_index)
				
				if zstring.tonumber(shipId) > 0 then 
					ccui.Helper:seekWidgetByName(self.roots[1], "Image_lock_".. i):setVisible(false)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						--进化形象
						local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.fitSkillTwo)
						local evo_info = zstring.split(evo_image, ",")
						--进化模板id
						local ship_evo = zstring.split(_ED.user_ship[shipId].evolution_status, "|")
						local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[shipId])
						local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
						local word_info = dms.element(dms["word_mould"], name_mould_id)
						name = word_info[3]
						if getShipNameOrder(tonumber(_ED.user_ship[shipId].Order)) > 0 then
							name = name.." +"..getShipNameOrder(tonumber(_ED.user_ship[shipId].Order))
						end
						local quality = shipOrEquipSetColour(tonumber(_ED.user_ship[shipId].Order))
						color_R = tipStringInfo_quality_color_Type[quality][1]
						color_G = tipStringInfo_quality_color_Type[quality][2]
						color_B = tipStringInfo_quality_color_Type[quality][3]
						

						--画武将的名称和星级
						--名称
						local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_".. i)
						Text_name:setString(name.." ".."Lv.".._ED.user_ship[shipId].ship_grade)
						
						Text_name:setColor(cc.c3b(color_R, color_G, color_B))
						--攻防
						local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_".. i)
						Panel_strengthen_stye:removeBackGroundImage()
					    local camp_preference = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.camp_preference)
					    if camp_preference> 0 and camp_preference <=3 then
					        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
					    end

					    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv_".. i)
							local Panel_strengthen_stye_lv = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_lv_".. i)
							Panel_strengthen_stye_lv:removeBackGroundImage()
							Panel_strengthen_stye_lv:setBackGroundImage(string.format("images/ui/icon/type_icon_lv_%d.png", camp_preference))
							Text_name:setString(name)
							Text_lv:setString("Lv.".._ED.user_ship[shipId].ship_grade)
						end
						--星星
						local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_".. i)
						Panel_star:removeAllChildren(true)
						neWshowShipStar(Panel_star,tonumber(_ED.user_ship[shipId].StarRating))
                            require('home_hero_labels').safeApply(root,i,_ED.user_ship[shipId])


						local Panel_234_add = ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i)
						Panel_234_add:setVisible(true)
						local Panel_zhenwei_dh = ccui.Helper:seekWidgetByName(root, "Panel_zhenwei_dh_".. i)
						if Panel_zhenwei_dh.animation ~= nil then
							Panel_zhenwei_dh.animation:removeFromParent(true)
						end
						local jsonFile = "sprite/spirte_zhuchengkapaidi.json"
				        local atlasFile = "sprite/spirte_zhuchengkapaidi.atlas"
				        Panel_zhenwei_dh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				        Panel_zhenwei_dh:addChild(Panel_zhenwei_dh.animation)
				    else    
						ccui.Helper:seekWidgetByName(self.roots[1], "Panel_234_add_".. i):setVisible(false)
					end
					local panel_size = self.panelHero[i]:getContentSize()

					self.panelHero[i]:removeAllChildren(true)

					require('home_hero_base_effect').add(self.panelHero[i])
					draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), self.panelHero[i], nil, nil, cc.p(0.5, 0))
					if animationMode == 1 then
						app.load("client.battle.fight.FightEnum")
						local shipSpine = sp.spine_sprite(self.panelHero[i], temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
						-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					 --        shipSpine:setScaleX(-1)
					 --    end
					else
						draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", self.panelHero[i], -1, nil, nil, cc.p(0.5, 0))
					end
					
				end
			end
		end
	end	
	
	if --ru == false and 
		nCount > 0 then
		local openCount = zstring.tonumber(_ED.user_info.user_fight)
		local can_add_ship = true			-- 是否有可上阵的数码兽
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			openCount = 6
			if __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 then
				can_add_ship = false
			end
			local ship_count = 0
			for k, v in pairs(_ED.user_ship) do
				ship_count = ship_count + 1
			end
			if ship_count > nCount then
				can_add_ship = true
			end
		end
		local openCountDraw = 0
		
		for i = 1, 6 do
			local shipId = _ED.user_formetion_status[i]
			if shipId == "0" then
				if openCountDraw < openCount - nCount then
					-- 无武将上阵
					openCountDraw = openCountDraw + 1
					
					self.panelHero[i]:removeAllChildren(true)
					self.panelHero[i].shipId = "0"
					
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_".. i)
						Text_name:setString("")
						local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_".. i)
						Panel_strengthen_stye:removeBackGroundImage()
						local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_".. i)
						Panel_star:removeAllChildren(true)
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv_".. i)
							local Panel_strengthen_stye_lv = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_lv_".. i)
							Panel_strengthen_stye_lv:removeBackGroundImage()
							Text_lv:setString("")
						end

						local Panel_234_add = ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i)
						if can_add_ship == true then
							Panel_234_add:setVisible(true)
							local Panel_zhenwei_dh = ccui.Helper:seekWidgetByName(root, "Panel_zhenwei_dh_".. i)
							if Panel_zhenwei_dh.animation ~= nil then
								Panel_zhenwei_dh.animation:removeFromParent(true)
							end
							local jsonFile = "sprite/spirte_zhucheng_kongdi.json"
					        local atlasFile = "sprite/spirte_zhucheng_kongdi.atlas"
					        Panel_zhenwei_dh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
					        Panel_zhenwei_dh:addChild(Panel_zhenwei_dh.animation)
					    else
					    	Panel_234_add:setVisible(false)
					    end
				    else
						ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i):setVisible(true)
					end
					
					
					local function heroTouchEvent(sender, eventType)
						local __spoint = sender:getTouchBeganPosition()
						local __mpoint = sender:getTouchMovePosition()
						local __epoint = sender:getTouchEndPosition()
					
						if eventType == ccui.TouchEventType.began then
						
						elseif eventType == ccui.TouchEventType.ended or 
						  eventType == ccui.TouchEventType.canceled then
						  	sender._one_called = true
							if __epoint.x - __spoint.x > 8 and self.binding_window == self._enum_window_type._FORMATION then
								-- left向左切换武将
								state_machine.excute("home_hero_into_formation_page", 0, 
								  {_datas = {_heroInstance = {ship_id = "0", index = i}, _formetion_index = i, _direction = "L"}})
							elseif __spoint.x - __epoint.x > 8 and self.binding_window == self._enum_window_type._FORMATION then
								-- right向右切换武将
								state_machine.excute("home_hero_into_formation_page", 0, 
								  {_datas = {_heroInstance = {ship_id = "0", index = i}, _formetion_index = i, _direction = "R"}})
							elseif eventType == ccui.TouchEventType.ended then
								state_machine.excute("home_hero_into_formation_page", 0, 
								  {_datas = {_heroInstance = {ship_id = "0", index = i}, _formetion_index = i}})
							end	
						end
					end	
					self.panelHero[i]:addTouchEventListener(heroTouchEvent)
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						self.panelHero[i].callback = heroTouchEvent
					end					
				else
					-- 上阵位未开启
					self.panelHero[i]:removeAllChildren(true)
					self.panelHero[i].shipId = "-1"
					
					ccui.Helper:seekWidgetByName(root, "Image_lock_".. i):setVisible(true)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_".. i)
						Text_name:setString("")
						local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_".. i)
						Panel_strengthen_stye:removeBackGroundImage()
						local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_".. i)
						Panel_star:removeAllChildren(true)
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv_".. i)
							local Panel_strengthen_stye_lv = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_lv_".. i)
							Panel_strengthen_stye_lv:removeBackGroundImage()
							Text_lv:setString("")
						end

						local Panel_234_add = ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i)
						Panel_234_add:setVisible(true)
						local Panel_zhenwei_dh = ccui.Helper:seekWidgetByName(root, "Panel_zhenwei_dh_".. i)
						if Panel_zhenwei_dh.animation ~= nil then
							Panel_zhenwei_dh.animation:removeFromParent(true)
						end
						local jsonFile = "sprite/spirte_zhucheng_kongdi.json"
				        local atlasFile = "sprite/spirte_zhucheng_kongdi.atlas"
				        Panel_zhenwei_dh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				        Panel_zhenwei_dh:addChild(Panel_zhenwei_dh.animation)
				    end    
				end
			end
		end
	end
end


function HomeHero:onHeroesDraw()
	local root = self.roots[1]
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
		-- or __lua_project_id == __lua_project_l_naruto 
		-- then
    	-- return
    -- end
	local nCount = 0 
		
	for i, v in pairs(self.bust_index_args) do
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_" .. v .. ".ExportJson")
	end	
	-- local ru = false
	for i = 1, 6 do
		local shipId = _ED.user_formetion_status[i]
		if zstring.tonumber(shipId) > 0 then 
			nCount = nCount + 1
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			-- Naruto Spine actors can be retained when only another slot changes.
			if __lua_project_id ~= __lua_project_l_naruto then self.panelHero[i].shipId = "-1" end
		end
		
		local hero = _ED.user_ship[shipId]
		local renderKey = hero and table.concat({tostring(shipId), tostring(hero.evolution_status), tostring(hero.ship_skin_info), tostring(hero.Order), tostring(hero.StarRating), tostring(hero.ship_grade)}, "|") or tostring(shipId)
		local appearanceChanged = __lua_project_id == __lua_project_l_naruto and self.panelHero[i]._localRenderKey ~= renderKey
		if self.panelHero[i].shipId ~= shipId or appearanceChanged then
			self.panelHero[i]._localRenderKey = renderKey
			-- if ru == false and self.panelHero[i].shipId ~= nil then
			-- 	ru = self.panelHero[i].shipId == nil and false or true
			-- end

			self.panelHero[i].shipId = shipId
			if _ED.user_ship[shipId] ~= nil then
				local _ship_mould_id = _ED.user_ship[shipId].ship_template_id
				local temp_bust_index = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					----------------------新的数码的形象------------------------
					--进化形象
					local evo_image = dms.string(dms["ship_mould"], _ship_mould_id, ship_mould.fitSkillTwo)
					local evo_info = zstring.split(evo_image, ",")
					--进化模板id
					local ship_evo = zstring.split(_ED.user_ship[shipId].evolution_status, "|")
					local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[shipId])
					--新的形象编号
					temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				else
					temp_bust_index = dms.int(dms["ship_mould"], _ship_mould_id, ship_mould.bust_index)
				end
				table.insert(self.bust_index_args, temp_bust_index)
				if zstring.tonumber(shipId) > 0 then 
					ccui.Helper:seekWidgetByName(self.roots[1], "Image_lock_".. i):setVisible(false)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

						--进化形象
						local evo_image = dms.string(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.fitSkillTwo)
						local evo_info = zstring.split(evo_image, ",")
						--进化模板id
						local ship_evo = zstring.split(_ED.user_ship[shipId].evolution_status, "|")
						local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[shipId])
						local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
						local word_info = dms.element(dms["word_mould"], name_mould_id)
						name = word_info[3]
						if getShipNameOrder(tonumber(_ED.user_ship[shipId].Order)) > 0 then
							name = name.." +"..getShipNameOrder(tonumber(_ED.user_ship[shipId].Order))
						end
						local quality = shipOrEquipSetColour(tonumber(_ED.user_ship[shipId].Order))
						color_R = tipStringInfo_quality_color_Type[quality][1]
						color_G = tipStringInfo_quality_color_Type[quality][2]
						color_B = tipStringInfo_quality_color_Type[quality][3]
						

						--画武将的名称和星级
						--名称
						local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_".. i)
						Text_name:setString(name.." ".."Lv.".._ED.user_ship[shipId].ship_grade)
						
						Text_name:setColor(cc.c3b(color_R, color_G, color_B))
						--攻防
						local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_".. i)
						Panel_strengthen_stye:removeBackGroundImage()
					    local camp_preference = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.camp_preference)
					    if camp_preference> 0 and camp_preference <=3 then
					        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
					    end
					    local pokemon_high_param = dms.searchs(dms["role_high"], pokemon_high.hero_fight_state_id, tonumber(temp_bust_index))
					    --宝可梦单独调整
					    if (__lua_project_id == __lua_project_l_pokemon 
					    	or __lua_project_id == __lua_project_onepiece 
					    	or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					    	or __lua_project_id == __lua_project_l_naruto) and pokemon_high_param then

							if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) then
					    		local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv_".. i)
								local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_".. i)
								local Panel_strengthen_stye_lv = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_lv_".. i)
								
								Panel_strengthen_stye_lv:removeBackGroundImage()
								Panel_strengthen_stye_lv:setBackGroundImage(string.format("images/ui/icon/type_icon_lv_%d.png", camp_preference))
								Text_name:setString(name)
								Text_lv:setString("Lv.".._ED.user_ship[shipId].ship_grade)
							end

							local Panel_role_name = ccui.Helper:seekWidgetByName(root, "Panel_role_name_".. i)
							if i == 1 then
								Panel_role_name:setPositionY(197 + tonumber(pokemon_high_param[1][3]))
								if __lua_project_id == __lua_project_onepiece then
									Panel_role_name:setPositionY(181 + tonumber(pokemon_high_param[1][3]))
								end

								if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
									Text_name:setPositionY(-25 - tonumber(pokemon_high_param[1][3]))
								end
							elseif i == 2 then
								Panel_role_name:setPositionY(173 + tonumber(pokemon_high_param[1][3]))
								if __lua_project_id == __lua_project_onepiece then
									Panel_role_name:setPositionY(130 + tonumber(pokemon_high_param[1][3]))
								end
								if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
									Text_name:setPositionY(-25 - tonumber(pokemon_high_param[1][3]))
								end
							elseif i == 3 then
								Panel_role_name:setPositionY(149 + tonumber(pokemon_high_param[1][3]))
								if __lua_project_id == __lua_project_onepiece then
									Panel_role_name:setPositionY(120 + tonumber(pokemon_high_param[1][3]))
								end
								if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
									Text_name:setPositionY(-25 - tonumber(pokemon_high_param[1][3]))
								end
							elseif i == 4 then
								Panel_role_name:setPositionY(174 + tonumber(pokemon_high_param[1][3]))
								if __lua_project_id == __lua_project_onepiece then
									Panel_role_name:setPositionY(118 + tonumber(pokemon_high_param[1][3]))
								end
								if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
									Text_name:setPositionY(-25 - tonumber(pokemon_high_param[1][3]))
								end
							elseif i == 5 then
								Panel_role_name:setPositionY(192 + tonumber(pokemon_high_param[1][3]))
								if __lua_project_id == __lua_project_onepiece then
									Panel_role_name:setPositionY(140 + tonumber(pokemon_high_param[1][3]))
								end
								if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
									Text_name:setPositionY(-29 - tonumber(pokemon_high_param[1][3]))
								end
							elseif i == 6 then
								Panel_role_name:setPositionY(210 + tonumber(pokemon_high_param[1][3]))
								if __lua_project_id == __lua_project_onepiece then
									Panel_role_name:setPositionY(181 + tonumber(pokemon_high_param[1][3]))
								end
								if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
									Text_name:setPositionY(-33 - tonumber(pokemon_high_param[1][3]))
								end
							end
						end
						--星星
						local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_".. i)
						Panel_star:removeAllChildren(true)
						neWshowShipStar(Panel_star,tonumber(_ED.user_ship[shipId].StarRating))
                            require('home_hero_labels').safeApply(root,i,_ED.user_ship[shipId])

						local Panel_234_add = ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i)
						Panel_234_add:setVisible(true)
						local Panel_zhenwei_dh = ccui.Helper:seekWidgetByName(root, "Panel_zhenwei_dh_".. i)
						if Panel_zhenwei_dh.animation ~= nil then
							Panel_zhenwei_dh.animation:removeFromParent(true)
						end
						local jsonFile = "sprite/spirte_zhuchengkapaidi.json"
				        local atlasFile = "sprite/spirte_zhuchengkapaidi.atlas"
				        Panel_zhenwei_dh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				        Panel_zhenwei_dh:addChild(Panel_zhenwei_dh.animation)
				    else    
						ccui.Helper:seekWidgetByName(self.roots[1], "Panel_234_add_".. i):setVisible(false)
					end
					local panel_size = self.panelHero[i]:getContentSize()

					-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
					
					-- local armature = ccs.Armature:create("spirte_" .. temp_bust_index)
					-- armature:getAnimation():playWithIndex(0)
					
					-- self.panelHero[i]:removeAllChildren(true)
					-- self.panelHero[i]:addChild(armature)
					
					-- -- nCount = nCount + 1
					
					-- -- armature:setAnchorPoint(cc.p(0.5, 0.5))
					
					
					-- -- armature:setPosition(cc.p(panel_size.width, panel_size.height/2))
					-- -- armature:setContentSize(panel_size)
					-- armature:setPosition(cc.p(panel_size.width/2, 0))

					self.panelHero[i]:removeAllChildren(true)

					require('home_hero_base_effect').add(self.panelHero[i])
					draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), self.panelHero[i], nil, nil, cc.p(0.5, 0))

					local shipSpine = nil

					if animationMode == 1 then
						app.load("client.battle.fight.FightEnum")
						shipSpine = sp.spine_sprite(self.panelHero[i], temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					        shipSpine:setScaleX(-1)
					    end

					    shipSpine.animationNameList = spineAnimations
					    sp.initArmature(shipSpine, true)
					    csb.animationChangeToAction(shipSpine, 0, 0, true)
					    shipSpine:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
					else
						draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", self.panelHero[i], -1, nil, nil, cc.p(0.5, 0))
					end
                    if shipSpine then
                        require('home_hero_labels').positionAbove(root,i,shipSpine,28)
                    end

					-- 彩蛋活动增加气泡显示
					self:showEasterEggPop(_ship_mould_id,self.panelHero[i])
					
					local _self = self
					local function heroTouchEvent(sender, eventType)
						local __spoint = sender:getTouchBeganPosition()
						local __mpoint = sender:getTouchMovePosition()
						local __epoint = sender:getTouchEndPosition()

						if fwin._close_touch_end_event == true then
							return
						end
					
						if eventType == ccui.TouchEventType.began then
							_self:stopAllActions()
							_self._showEffectAction = nil
							_self._isExcuteEndEvent = true
							local seq = cc.Sequence:create(
								cc.DelayTime:create(_self.EFFECT_TIME),
								cc.CallFunc:create(function(sender) 
									state_machine.excute("home_hero_show_special_effect", 0, {ship_mould_id = _ship_mould_id, shipSpine = shipSpine})
									state_machine.excute("home_hero_easter_egg_get_reward", 0, {ship_mould_id = _ship_mould_id})
								end))
							_self._showEffectAction = _self:runAction(seq)
						elseif eventType == ccui.TouchEventType.ended or 
						  eventType == ccui.TouchEventType.canceled then
						  	sender._one_called = true
							if __epoint.x - __spoint.x > 8 and self.binding_window == self._enum_window_type._FORMATION then
								-- left向左切换武将
								state_machine.excute("home_hero_into_formation_page", 0, 
								  {_datas = {_heroInstance = _ED.user_ship[shipId], _formetion_index = i, _direction = "L"}})
							elseif __spoint.x - __epoint.x > 8 and self.binding_window == self._enum_window_type._FORMATION then
								-- right向右切换武将
								state_machine.excute("home_hero_into_formation_page", 0, 
								  {_datas = {_heroInstance = _ED.user_ship[shipId], _formetion_index = i, _direction = "R"}})
							elseif eventType == ccui.TouchEventType.ended then
								if _self._isExcuteEndEvent == true then
									_self:stopAllActions()
									_self._showEffectAction = nil
									_self._isExcuteEndEvent = true
									state_machine.excute("home_hero_into_formation_page", 0, {_datas = {_heroInstance = _ED.user_ship[""..shipId], _formetion_index = i}})
								end
							end	
						end
					end	
					self.panelHero[i]:addTouchEventListener(heroTouchEvent)
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						self.panelHero[i].callback = heroTouchEvent
					end						
				end
			end
		end
	end	
	
	if --ru == false and 
		nCount > 0 then
		local openCount = zstring.tonumber(_ED.user_info.user_fight)
		local can_add_ship = true			-- 是否有可上阵的数码兽
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			openCount = 6
			if __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 then
				can_add_ship = false
			end
			local ship_count = 0
			for k, v in pairs(_ED.user_ship) do
				ship_count = ship_count + 1
			end
			if ship_count > nCount then
				can_add_ship = true
			end
		end
		local openCountDraw = 0
		
		for i = 1, 6 do
			local shipId = _ED.user_formetion_status[i]
			if shipId == "0" then
				if openCountDraw < openCount - nCount then
					-- 无武将上阵
					openCountDraw = openCountDraw + 1
					
					self.panelHero[i]:removeAllChildren(true)
					self.panelHero[i].shipId = "0"
					
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_".. i)
						Text_name:setString("")
						local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_".. i)
						Panel_strengthen_stye:removeBackGroundImage()
						local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_".. i)
						Panel_star:removeAllChildren(true)
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv_".. i)
							local Panel_strengthen_stye_lv = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_lv_".. i)
							Panel_strengthen_stye_lv:removeBackGroundImage()
							Text_lv:setString("")
						end

						local Panel_234_add = ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i)
						if can_add_ship == true then
							Panel_234_add:setVisible(true)
							local Panel_zhenwei_dh = ccui.Helper:seekWidgetByName(root, "Panel_zhenwei_dh_".. i)
							if Panel_zhenwei_dh.animation ~= nil then
								Panel_zhenwei_dh.animation:removeFromParent(true)
							end
							local jsonFile = "sprite/spirte_zhucheng_kongdi.json"
					        local atlasFile = "sprite/spirte_zhucheng_kongdi.atlas"
					        Panel_zhenwei_dh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
					        Panel_zhenwei_dh:addChild(Panel_zhenwei_dh.animation)
					    else
					    	Panel_234_add:setVisible(false)
					    end
				    else    
						ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i):setVisible(true)
					end
					
					local function heroTouchEvent(sender, eventType)
						local __spoint = sender:getTouchBeganPosition()
						local __mpoint = sender:getTouchMovePosition()
						local __epoint = sender:getTouchEndPosition()
					
						if eventType == ccui.TouchEventType.began then
						
						elseif eventType == ccui.TouchEventType.ended or 
						  eventType == ccui.TouchEventType.canceled then
						  	sender._one_called = true
							if __epoint.x - __spoint.x > 8 and self.binding_window == self._enum_window_type._FORMATION then
								-- left向左切换武将
								state_machine.excute("home_hero_into_formation_page", 0, 
								  {_datas = {_heroInstance = {ship_id = "0", index = i}, _formetion_index = i, _direction = "L"}})
							elseif __spoint.x - __epoint.x > 8 and self.binding_window == self._enum_window_type._FORMATION then
								-- right向右切换武将
								state_machine.excute("home_hero_into_formation_page", 0, 
								  {_datas = {_heroInstance = {ship_id = "0", index = i}, _formetion_index = i, _direction = "R"}})
							elseif eventType == ccui.TouchEventType.ended then
								state_machine.excute("home_hero_into_formation_page", 0, 
								  {_datas = {_heroInstance = {ship_id = "0", index = i}, _formetion_index = i}})
							end	
						end
					end	
					self.panelHero[i]:addTouchEventListener(heroTouchEvent)
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						self.panelHero[i].callback = heroTouchEvent
					end						
				else
					-- 上阵位未开启
					self.panelHero[i]:removeAllChildren(true)
					self.panelHero[i].shipId = "-1"
					
					ccui.Helper:seekWidgetByName(root, "Image_lock_".. i):setVisible(true)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_".. i)
						Text_name:setString("")
						local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_".. i)
						Panel_strengthen_stye:removeBackGroundImage()
						local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star_".. i)
						Panel_star:removeAllChildren(true)
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv_".. i)
							local Panel_strengthen_stye_lv = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye_lv_".. i)
							Panel_strengthen_stye_lv:removeBackGroundImage()
							Text_lv:setString("")
						end

						local Panel_234_add = ccui.Helper:seekWidgetByName(root, "Panel_234_add_".. i)
						Panel_234_add:setVisible(true)
						local Panel_zhenwei_dh = ccui.Helper:seekWidgetByName(root, "Panel_zhenwei_dh_".. i)
						if Panel_zhenwei_dh.animation ~= nil then
							Panel_zhenwei_dh.animation:removeFromParent(true)
						end
						local jsonFile = "sprite/spirte_zhucheng_kongdi.json"
				        local atlasFile = "sprite/spirte_zhucheng_kongdi.atlas"
				        Panel_zhenwei_dh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
				        Panel_zhenwei_dh:addChild(Panel_zhenwei_dh.animation)
				    end 
				end
			end
		end
	end
end

function HomeHero:onUpdateDraw()
    local root = self.roots[1]
    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    -- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
    	-- or __lua_project_id == __lua_project_l_naruto 
    	-- then
    	-- return
    -- end
	-- self.hero_old_pos_x = self.cells[1]:getPositionX()
	-- self.background_image_old_pos_x = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_33"):getPositionX()
	
	
	-- local heroes_max_counts = 6
	-- local bg_width = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_33"):getContentSize().width
	-- local page_width = ccui.Helper:seekWidgetByName(self.roots[1], "PageView_huadong"):getContentSize().width
	-- self.offset_percent = (bg_width / page_width - 1) / (heroes_max_counts - 1)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local Panel_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_1")
        if Panel_dh_1 ~= nil then
	        if Panel_dh_1.animation ~= nil then
	            Panel_dh_1.animation:removeFromParent(true)
	        end
	        local jsonFile = "sprite/spirte_zc.json"
	        local atlasFile = "sprite/spirte_zc.atlas"
	        Panel_dh_1.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	        Panel_dh_1:addChild(Panel_dh_1.animation)
	    end
    end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self.panelHero = {
			ccui.Helper:seekWidgetByName(root, "Panel_role_01"),
			ccui.Helper:seekWidgetByName(root, "Panel_role_02"),
			ccui.Helper:seekWidgetByName(root, "Panel_role_03"),
			ccui.Helper:seekWidgetByName(root, "Panel_role_04"),
			ccui.Helper:seekWidgetByName(root, "Panel_role_05"),
			ccui.Helper:seekWidgetByName(root, "Panel_role_06"),
		
		}
		self:onHeroesDraw()
		
		for i, v in ipairs(self.panelHero) do
			if v.shipId == getUserMould() then
				self.current_formetion_index = i
				break
			end	
		end
		
		local function cameraTouchEvent(sender, eventType)
			-- 取消了主页近景中景远景的切换
			-- local __spoint = sender:getTouchBeganPosition()
			-- local __mpoint = sender:getTouchMovePosition()
			-- local __epoint = sender:getTouchEndPosition()
		
			-- if eventType == ccui.TouchEventType.began then
			
			-- elseif eventType == ccui.TouchEventType.ended or 
			--   eventType == ccui.TouchEventType.canceled then
			-- 	if __epoint.x - __spoint.x > 8 and self.binding_window == self._enum_window_type._HOME then
			-- 		-- left向左滑动
			-- 		self.current_lens_type = self.current_lens_type + 1
					
			-- 		if self.current_lens_type > 3 then
			-- 			self.current_lens_type = self.current_lens_type - 3
			-- 		end
					
			-- 		local temp_camera_actions = {"Button_view_1_y_j_touch", "Button_view_2_j_z_touch", "Button_view_3_z_y_touch"}
			-- 		self.actions[1]:play(temp_camera_actions[self.current_lens_type], false)
			-- 	elseif __spoint.x - __epoint.x > 8 and self.binding_window == self._enum_window_type._HOME then
			-- 		-- right向右滑动
			-- 		self.current_lens_type = self.current_lens_type - 1
					
			-- 		if self.current_lens_type < 1 then
			-- 			self.current_lens_type = self.current_lens_type + 3
			-- 		end
					
			-- 		local temp_camera_actions = {"Button_view_1_z_j_touch", "Button_view_2_y_z_touch", "Button_view_3_j_y_touch"}
			-- 		self.actions[1]:play(temp_camera_actions[self.current_lens_type], false)	
			-- 	end	
			-- end
		end	
		-- local switch_camera_panel = ccui.Helper:seekWidgetByName(root, "Panel_226")
		-- switch_camera_panel:addTouchEventListener(cameraTouchEvent)
		-- switch_camera_panel:setSwallowTouches(false)
		
		-- state_machine.excute("home_hero_binding_window_change", 0, self.init_binding_window)
		
	else
		local pageView = ccui.Helper:seekWidgetByName(root, "PageView_huadong")
		for i = 2, 6 do
			local shipId = _ED.user_formetion_status[i]
			if zstring.tonumber(shipId) > 0 then 
				local cell = ShipBodyForHomeCell:createCell()
				cell:init(_ED.user_ship[shipId])
				table.insert(self.cells, cell) 
				pageView:addPage(cell)
				-- if i == 1 then
					-- state_machine.excute("push_infomation_home_update_draw_hero_intro", 0, _ED.user_ship[shipId].ship_template_id)
				-- end
			end
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if self.isFirstOpen == true then
			self.isFirstOpen = false
			for i , v in pairs(self.panelHero) do
				state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_home_hero_icon",
		        _widget = ccui.Helper:seekWidgetByName(root, string.format("Panel_role_name_%d", i)),
		        _button = v,
		        _index = i,
		        _invoke = nil,
		        _interval = 0.5,})
		    end
		else
			state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
		end
	end
end

function HomeHero:addCameraFrameAtcion()
	-- Button_view_2_j_z_touch    近景切中景      Button_view_2_j_z_touch_over结束帧
	-- Button_view_2_y_z_touch    远景切中景     Button_view_2_y_z_touch_over结束帧
	-- Button_view_3_j_y_touch    近景切远景       Button_view_3_j_y_touch_over结束帧
	-- Button_view_3_z_y_touch    中景切远景      Button_view_3_z_y_touch_over结束帧
	-- Button_view_1_y_j_touch     远景切近景      Button_view_1_y_j_touch_over结束帧
	-- Button_view_1_z_j_touch     中景切近景      Button_view_1_z_j_touch_over结束帧 
	local root = self.roots[1]
	local action = csb.createTimeline("home/home_juese.csb")
	action:setTimeSpeed(app.getTimeSpeed())
	table.insert(self.actions, action)
    root:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str ~= nil then
        	-- 视角动画播放结束
        end
    end)

   --  local jsonFile = ""
   --  local atlasFile = ""
   --  local panel = nil
   --  for i=1,3 do
	  --   jsonFile = string.format("images/ui/effice/effect_zhuye/effect_zhuye_%d.json", i - 1)
	  --   atlasFile = string.format("images/ui/effice/effect_zhuye/effect_zhuye_%d.atlas", i - 1)
	  --   panel = ccui.Helper:seekWidgetByName(root, "Panel_bg_donghua_"..i)
	  --   if panel ~= nil then
	  --   	panel:removeAllChildren(true)
	  --   	if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
			--     local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			--     sp.initArmature(animation, true)
			--     panel:addChild(animation)
			-- end
	  --   end
   --  end

    -- ccui.Helper:seekWidgetByName(root, "Panel_bg_donghua_2")
    -- ccui.Helper:seekWidgetByName(root, "Panel_bg_donghua_3")


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_view_1"), 	nil, 
	{
		terminal_name = "home_hero_camera_controller", 	
		next_terminal_name = "home_hero_camera_controller_1", 			
		current_button_name = "Button_view_1", 	
		camera_index = self._enum_lens_type._NEAR_LENS,
		but_image = "", 	
		terminal_state = 0, 
		camera_actions = {"", "Button_view_2_j_z_touch", "Button_view_3_j_y_touch"},
		isPressedActionEnabled = true
	}, 
	nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_view_2"), 	nil, 
	{
		terminal_name = "home_hero_camera_controller", 	
		next_terminal_name = "home_hero_camera_controller_2", 			
		current_button_name = "Button_view_2", 	
		camera_index = self._enum_lens_type._MIDDLE_LENS,
		but_image = "", 	
		terminal_state = 0, 
		camera_actions = {"Button_view_1_z_j_touch", "", "Button_view_3_z_y_touch"},
		isPressedActionEnabled = true
	}, 
	nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_view_3"), 	nil, 
	{
		terminal_name = "home_hero_camera_controller", 	
		next_terminal_name = "home_hero_camera_controller_3", 			
		current_button_name = "Button_view_3", 
		camera_index = self._enum_lens_type._FAR_LENS,	
		but_image = "", 	
		terminal_state = 0, 
		camera_actions = {"Button_view_1_y_j_touch", "Button_view_2_y_z_touch", ""},
		isPressedActionEnabled = true
	}, 
	nil, 0)

	state_machine.excute("home_hero_camera_controller", 0, 
		{
			_datas = 
			{
				terminal_name = "home_hero_camera_controller", 	
				next_terminal_name = "home_hero_camera_controller_1", 			
				current_button_name = "Button_view_1", 	
				camera_index = self._enum_lens_type._NEAR_LENS,	
				but_image = "", 	
				terminal_state = 0, 
				camera_actions = {"", "Button_view_2_j_z_touch", "Button_view_3_j_y_touch"},
				isPressedActionEnabled = true
			}
		}
	)
	self:onUpdateDraw()
end

function HomeHero:cameraController(_type)

end

function HomeHero:init(_enum_binding_window)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		if _enum_binding_window == nil then
			_enum_binding_window = self._enum_window_type._HOME
		end
		self.init_binding_window = _enum_binding_window
	end
	return self
end

function HomeHero:onEnterTransitionFinish()
	-- local csbHomeBG = csb.createNode("home/home_bg.csb")
    -- self:addChild(csbHomeBG)
	local csbHomeHero = csb.createNode("home/home_juese.csb")
	local root = csbHomeHero:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbHomeHero)

    -- Center the home formation more comfortably in the widescreen PC view.
    local platform = cc.Application:getInstance():getTargetPlatform()
    local isMobile = platform == cc.PLATFORM_OS_ANDROID or platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD
    if not isMobile then
        local shift = 80
        for i = 1, 6 do
            for _, prefix in ipairs({"Panel_role_0", "Panel_role_name_", "Panel_zhenwei_dh_"}) do
                local node = ccui.Helper:seekWidgetByName(root, prefix .. i)
                if node then node:setPositionX(node:getPositionX() - shift) end
            end
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    	self:updateBackGroud()


	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
	        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
	        then
		    local Panel_shu_donghua = ccui.Helper:seekWidgetByName(root, "Panel_shu_donghua")
		    if nil ~= Panel_shu_donghua then
		        local jsonFile = "images/ui/effice/effect_zhuchenggx5/effect_zhuchenggx5.json"
		        local atlasFile = "images/ui/effice/effect_zhuchenggx5/effect_zhuchenggx5.atlas"
		        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		        Panel_shu_donghua:addChild(animation)
		    end

			self.Panel_em_donghua = ccui.Helper:seekWidgetByName(root, "Panel_em_donghua")
		    if nil ~= self.Panel_em_donghua then
		        local jsonFile = "images/ui/effice/effect_zhuchenggx6/effect_zhuchenggx6.json"
		        local atlasFile = "images/ui/effice/effect_zhuchenggx6/effect_zhuchenggx6.atlas"
		        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		        self.Panel_em_donghua:addChild(animation)
		    end

		    -- 神秘商店
		    self.Panel_mysterious_shop = ccui.Helper:seekWidgetByName(root, "Panel_mysterious_shop")
		    if nil ~= self.Panel_mysterious_shop then
		    	self.Panel_animation = ccui.Helper:seekWidgetByName(root, "Panel_animation")
		    	local jsonFile = "sprite/effect_zhuchenggx7.json"
		        local atlasFile = "sprite/effect_zhuchenggx7.atlas"
		        self.ArmatureNode_mysterious_shop = sp.spine(jsonFile, atlasFile, 1, 0, "animation2", true, nil)
		        self.ArmatureNode_mysterious_shop.animationNameList = {"animation2","animation1"}
		        sp.initArmature(self.ArmatureNode_mysterious_shop, true)
				-- self.ArmatureNode_mysterious_shop = self.Panel_mysterious_shop:getChildByName("ArmatureNode_mysterious_shop")
			 --    draw.initArmature(self.ArmatureNode_mysterious_shop, nil, -1, 0, 1)
    			self.ArmatureNode_mysterious_shop:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
				self.ArmatureNode_mysterious_shop._invoke = function ( armatureBack )
					local armature = armatureBack
					if armature ~= nil then
						local actionIndex = armature._actionIndex
					end
				end
				self.ArmatureNode_mysterious_shop._actionIndex = 0
	            self.ArmatureNode_mysterious_shop._nextAction = 0

	            self.Panel_animation:addChild(self.ArmatureNode_mysterious_shop)
				-- self.ArmatureNode_mysterious_shop:getAnimation():playWithIndex(0)

				app.load("client.shop.SecretShop")

				self:openSecretShop(false)

	            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_mysterious_shop"), 	nil, 
				{
					-- terminal_name = "home_open_secret_shop",
					terminal_name = "secret_shop_window_open",
					terminal_state = 0,
					isPressedActionEnabled = true
				}, 
				nil, 0)
	        end
		end
    end
    -- 在龙虎门的项目中，添加界面近景、中景、远景的视角动画
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
    	self:addCameraFrameAtcion()
	else	
		-- local rootHomeHero = csbHomeHero:getChildByName("root")
		-- local Image = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(rootHomeHero, "Panel_21"), nil, {terminal_name = "home_hero_touch_move", terminal_state = 0}, nil, 0)

		-- local Iconimage = nil
		-- local head = false
		-- for i = 1,6 do
			-- if head ~= true then
				-- local csbHero = csb.createNode("formation/line_up_list.csb")
				-- local rootHero = csbHero:getChildByName("root")
				-- Iconimage = ccui.Helper:seekWidgetByName(rootHero, "Image_2")
				-- Iconimage:removeFromParent(true)
				-- head = true
			-- else
				-- if _ED.formetion[i] ~= "0" then
					-- local csbHero = csb.createNode("formation/line_up_list.csb")
					-- local rootHero = csbHero:getChildByName("root")
					-- Iconimage = ccui.Helper:seekWidgetByName(rootHero, "Image_"..(i + 9))
					-- Iconimage:removeFromParent(true)
				-- else
					-- local csbHero = csb.createNode("formation/line_up_list.csb")
					-- local rootHero = csbHero:getChildByName("root")
					-- Iconimage = ccui.Helper:seekWidgetByName(rootHero, "Image_5")
					-- Iconimage:removeFromParent(true)
				-- end
			-- end
			-- local m = ccui.Helper:seekWidgetByName(rootHomeHero, "Panel_1033_"..i)
			-- table.insert(state_machine.find("move_hero").penelTabel, i, m)
			-- local n = ccui.Helper:seekWidgetByName(rootHomeHero, "Panel_21")
			-- n:addChild(Iconimage)
			-- Iconimage:setPosition(m:getPosition())
			-- Iconimage:setScale(m:getScale())
			-- table.insert(state_machine.find("move_hero").heroCardsTable, i, Iconimage)
		-- end
		-- state_machine.find("move_hero").index = 0
		-- state_machine.find("move_hero").changeLevel(state_machine.find("move_hero").heroCardsTable, state_machine.find("move_hero").index)
		
		local pageView = ccui.Helper:seekWidgetByName(root, "PageView_huadong")
		local function pageViewEvent(sender, eventType)
			if eventType == ccui.PageViewEventType.turning then
				local pageView = sender
				local pageInfo = string.format("page %d " , pageView:getCurPageIndex() + 1)
				local shipId = _ED.user_formetion_status[pageView:getCurPageIndex() + 1]
				local currentPage = pageView:getPage(pageView:getCurPageIndex())
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					state_machine.excute("push_infomation_home_update_draw_hero_intro", 0, _ED.user_ship[shipId])
				else
					state_machine.excute("push_infomation_home_update_draw_hero_intro", 0, _ED.user_ship[shipId].ship_template_id)
				end

				if ___is_open_laster == true then
					state_machine.excute("home_baoyi_button", 0, {_datas={_shipId = _ED.user_ship[shipId].ship_template_id,_currentPage = currentPage}})
				end
				state_machine.excute("ship_body_for_home_cell_armature_play", 0, currentPage)
				state_machine.excute("home_hero_update_draw_hero_move", 0, 255)
			end
		end 

		pageView:addEventListener(pageViewEvent)
		
		local shipId = _ED.user_formetion_status[1]
		if zstring.tonumber(shipId) > 0 then 
			local cell = ShipBodyForHomeCell:createCell()
			cell:init(_ED.user_ship[shipId])
			table.insert(self.cells, cell) 
			pageView:addPage(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				state_machine.excute("push_infomation_home_update_draw_hero_intro", 0, _ED.user_ship[shipId])
			else
				state_machine.excute("push_infomation_home_update_draw_hero_intro", 0, _ED.user_ship[shipId].ship_template_id)
			end

			if ___is_open_laster == true then
				state_machine.excute("home_baoyi_button", 0, {_datas={_shipId = _ED.user_ship[shipId].ship_template_id,_currentPage = cell}})
			end
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self:updateBackGroud()
	end
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)    
end

-- function HomeHero:onUpdate(dt)
	-- local first_hero_offset_x = self.cells[1]:getPositionX() - self.hero_old_pos_x
	
	-- local bg_offset_x = self.background_image_old_pos_x + first_hero_offset_x * self.offset_percent
	-- ccui.Helper:seekWidgetByName(self.roots[1], "Panel_33"):setPositionX(bg_offset_x)
	
    -- self.updateCount = self.updateCount + 1
    -- if self.updateCount == 1 then
    	-- local root = self.roots[1]
	    -- local pageView = ccui.Helper:seekWidgetByName(root, "PageView_huadong")
	    -- local function pageViewEvent(sender, eventType)
	        -- if eventType == ccui.PageViewEventType.turning then
	            -- local pageView = sender
	            -- local pageInfo = string.format("page %d " , pageView:getCurPageIndex() + 1)
	            -->  -- print("pageInfo", pageInfo)
	        -- end
	    -- end 

	    -- pageView:addEventListener(pageViewEvent)

	    -- app.load("client.cells.ship.ship_body_for_home_cell")
		-- for i = 2, 7 do
			-- local shipId = _ED.formetion[i]
			-- if tonumber(shipId) > 0 then
				-- local cell = ShipBodyForHomeCell:createCell()
				-- cell:init(_ED.user_ship[shipId])
				-- pageView:insertPage(cell, 0)
			-- end
		-- end
    -- end
-- end

function HomeHero:close( ... )
	local Panel_dh_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dh_bg")
	if Panel_dh_bg ~= nil then
        Panel_dh_bg:removeAllChildren(true)
	end
	local Panel_shu_donghua = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shu_donghua")
    if nil ~= Panel_shu_donghua then
        Panel_shu_donghua:removeAllChildren(true)
    end
	for i=1,6 do
		local Panel_zhenwei_dh = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_zhenwei_dh_".. i)
		if Panel_zhenwei_dh ~= nil then
			Panel_zhenwei_dh:removeAllChildren(true)
		end
		local Panel_role = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_0".. i)
		if Panel_role ~= nil then
			Panel_role:removeAllChildren(true)
		end

		local Panel_role_name = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_name_".. i)
		if Panel_role_name ~= nil then
			Panel_role_name:setPositionY(0)
		end
	end
end

function HomeHero:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		for i, v in pairs(self.bust_index_args) do
			ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_" .. v .. ".ExportJson")
		end
		
		state_machine.remove("home_hero_camera_controller")
		state_machine.remove("home_hero_camera_controller_change_view")
		state_machine.remove("home_hero_into_formation_page")
		state_machine.remove("home_hero_action_scale_between_home_and_formation")
		state_machine.remove("home_hero_action_switch_in_formation")
		state_machine.remove("home_hero_binding_window_change")
		state_machine.remove("home_hero_choice_hero_battle_request")
		state_machine.remove("home_hero_refresh_draw_terminal")
		state_machine.remove("home_hero_main_refresh_draw")
		state_machine.remove("home_hero_main_tip_show")
		state_machine.remove("home_hero_hide_event")
		state_machine.remove("home_hero_show_event")
		state_machine.remove("home_open_secret_shop")
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.remove("home_hero_change_backGroudImage")
	end
	
	HomeHero.init_flag = false -- 当前界面创建标识
	HomeHero.touch_type = nil
	HomeHero.last_selected_hero = nil
	state_machine.remove("move_hero")
	state_machine.remove("home_hero_touch_move")
	state_machine.remove("home_hero_find_target_with_mission")
end

-- 显示属性变更的提示信息
function HomeHero:showPropertyChangeTipInfo(previousShip,ship,temp,ker)
	-- 计算两次换将之后的属性差
	-- instance:showPropertyChangeTipInfo(previousShip,nil,nil,true)
	local ship_courage = 0
	local ship_health = 0
	local ship_intellect = 0
	local ship_quick = 0
	if zstring.tonumber(previousShip.ship_id) == -1 then
		ship_courage = zstring.tonumber(ship.ship_courage)
		ship_health = zstring.tonumber(ship.ship_health)
		ship_intellect = zstring.tonumber(ship.ship_intellect)
		ship_quick = zstring.tonumber(ship.ship_quick)
	else
		ship_courage = zstring.tonumber(ship.ship_courage) - zstring.tonumber(previousShip.ship_courage)
		ship_health = zstring.tonumber(ship.ship_health) - zstring.tonumber(previousShip.ship_health)
		ship_intellect = zstring.tonumber(ship.ship_intellect) - zstring.tonumber(previousShip.ship_intellect)
		ship_quick = zstring.tonumber(ship.ship_quick) - zstring.tonumber(previousShip.ship_quick)
			
	end
	
	
	if ship.gongji == ship_courage and ship.shengming == ship_health and ship.waigong == ship_intellect and  ship.neigong == ship_quick then
		ship.shengming = 0
		ship.gongji = 0
		ship.waigong = 0
		ship.neigong = 0			
		return
	end
	
	local textData = {}
	-----------------------强化大师的判断
	local shipId = previousShip.ship_id
				
	local equips_id = {}

	local tempShip = _ED.user_ship[shipId]
	local ship_equips = {}
	if tempShip ~= nil then
		ship_equips = _ED.user_ship[shipId].equipment
	end

	for i, v in pairs(ship_equips) do
		if v.user_equiment_id ~= "0" then
			local tempType = zstring.tonumber(v.equipment_type)
			
			if tempType < 4 then
				equips_id[tempType] = v.user_equiment_id
			end
		end	
	end
	local status = true
	for i = 1, 4 do
		if equips_id[i - 1] == nil then
			status = false
		end
	end
	--------------------------------缘分激活提示(更换伙伴时触发)
	if ker == true then
		local fettersNumber = 0
		local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], ship.ship_base_template_id, ship_mould.relationship_id), ",")
		local inStates = {}
		local ter = 1
		local name = nil
		for i, v in pairs(_ED.user_ship) do
			if zstring.tonumber(v.formation_index) > 0 or zstring.tonumber(v.little_partner_formation_index) > 0 then
				if zstring.tonumber(v.ship_id) ~= zstring.tonumber(_ED.into_formation_ship_id) then
					inStates[ter] = v.ship_base_template_id
					ter = ter + 1
				end
			end
		end
		
		local getPersonName = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], ship.ship_base_template_id, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        local ship_evo = zstring.split(ship.evolution_status, "|")
	        local evo_mould_id = smGetSkinEvoIdChange(ship)
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
        	getPersonName = word_info[3]
	    else
			if tonumber(ship.captain_type) == 0 then
				getPersonName = _ED.user_info.user_name
			else
				getPersonName = dms.string(dms["ship_mould"], ship.ship_base_template_id, ship_mould.captain_name)
			end
		end
		
		if myRelatioInfo ~= nil then
			for k,w in pairs(myRelatioInfo) do
				local num = 1
				local person = {}
				local shipName = {}
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) == 0 then
					if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
						person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
						shipName[num] = dms.string(dms["ship_mould"], person[num], ship_mould.captain_name)
						num = num + 1
					end
				end
				
				local sss = 0
				for j,r in pairs(person) do
					for i, v in pairs(inStates) do
						if zstring.tonumber(r) == zstring.tonumber(v) then
							sss = sss + 1
							break
						end
					end
				end
				if table.getn(person)-1 == sss and table.getn(person) - 1 > 0 and sss > 0 then
					fettersNumber = fettersNumber + 1
					
					name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
					for i,v in pairs(shipName) do
						for j,k in pairs(_ED.user_ship) do
							if zstring.tonumber(k.little_partner_formation_index) <= 0 then
								if zstring.tonumber(k.ship_base_template_id) == person[i] then
										local myRelatioInfo2 = zstring.zsplit(dms.string(dms["ship_mould"], k.ship_base_template_id, ship_mould.relationship_id), ",")
										local shipHaveRela = false
										for i,v in pairs(myRelatioInfo2) do
											local name2 = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
											if name2 == name then
												shipHaveRela = true
											end
										end
										if shipHaveRela == true then
											table.insert(textData, {nameOne = v, nameTwo = name})
										end
									break
								end
							end
						end
					end
				end
			end
			
			-- local item = 1
			-- local equip = {}
			-- for i, v in pairs (_ED.user_ship) do
			-- 	if zstring.tonumber(v.ship_id) == zstring.tonumber(_ED.into_formation_ship_id) then
			-- 		for j, k in pairs(v.equipment) do
			-- 			equip[item] = zstring.tonumber(k.user_equiment_template)
			-- 			item = item + 1
			-- 		end
			-- 	end
			-- end
			
			--装备缘分激活
			-- for k,w in pairs(myRelatioInfo) do
			-- 	local num = 1
			-- 	local relationEquip = {}
			-- 	if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= 0  then
			-- 		if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
			-- 			relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
			-- 			num = num + 1
			-- 		end
			-- 	end
			-- 	if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= 0  then
			-- 		if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
			-- 			relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
			-- 			num = num + 1
			-- 		end
			-- 	end
			-- 	if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= 0  then
			-- 		if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
			-- 			relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
			-- 			num = num + 1
			-- 		end
			-- 	end
			-- 	if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= 0  then
			-- 		if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
			-- 			relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
			-- 			num = num + 1
			-- 		end
			-- 	end
			-- 	if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= 0  then
			-- 		if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
			-- 			relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
			-- 			num = num + 1
			-- 		end
			-- 	end
			-- 	if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= 0  then
			-- 		if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
			-- 			relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
			-- 			num = num + 1
			-- 		end
			-- 	end
				
			-- 	local sss = 0
			-- 	for j,r in pairs(relationEquip) do
			-- 		for i, v in pairs(equip) do
			-- 			if zstring.tonumber(r) == zstring.tonumber(v) then
			-- 				sss = sss + 1
			-- 				break
			-- 			end
			-- 		end
			-- 	end
				
			-- 	if table.getn(relationEquip) == sss and table.getn(relationEquip) > 0 and sss > 0 then
			-- 		fettersNumber = fettersNumber + 1
					
			-- 		name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
			-- 		for i,v in pairs(relationEquip) do
			-- 			for j,e in pairs(_ED.user_equiment) do
			-- 				if zstring.tonumber(e.user_equiment_template) == v then
			-- 					table.insert(textData, {nameOne = getPersonName , nameTwo = name})
			-- 					break
			-- 				end
			-- 			end
			-- 		end
			-- 	end
			-- end
		end
	elseif ker ~= nil then
		local getPersonName = nil
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], ship.ship_base_template_id, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        local ship_evo = zstring.split(ship.evolution_status, "|")
	        local evo_mould_id = smGetSkinEvoIdChange(ship)
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
        	getPersonName = word_info[3]
	    else
			if tonumber(ship.captain_type) == 0 then
				getPersonName = _ED.user_info.user_name
			else
				getPersonName = dms.string(dms["ship_mould"], ship.ship_base_template_id, ship_mould.captain_name)
			end
		end
		local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], ship.ship_base_template_id, ship_mould.relationship_id), ",")
		for k,w in pairs(myRelatioInfo) do
			local num = 1
			local relationEquip = {}
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= 0  then
				if zstring.tonumber(dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)) > 0 then
					relationEquip[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
					num = num + 1
				end
			end
			
			
			name = dms.string(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_name)
			for i,v in pairs(relationEquip) do
				if zstring.tonumber(_ED.user_equiment[ker].user_equiment_template) == v then
					table.insert(textData, {nameOne =  getPersonName, nameTwo = name})
					break
				end
			end
		end
	end
	

	table.insert(textData, {property = _property[2], value = ship_courage})
	table.insert(textData, {property = _property[1], value = ship_health})
	table.insert(textData, {property = _property[3], value = ship_intellect})
	table.insert(textData, {property = _property[4], value = ship_quick})
	app.load("client.cells.utils.property_change_tip_info_cell") 
	local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
	local str = tipStringInfo_hero_change_Type[6]
	-- state_machine.excute("Lformation_ship_cell_play_hero_animation",0,{"begin"})
	tipInfo:init(11,str, textData)	
	fwin:open(tipInfo, fwin._view)
		--动画播完后 需要清零原先的属性变化
	previousShip.ship_courage=0
	previousShip.ship_health=0
	previousShip.ship_intellect=0
	previousShip.ship_quick=0
end

-- 显示属性变更的提示信息
function HomeHero:canPlaySpecialAnimation(ship_mould_id)
	local info = dms.string(dms["play_config"], 292, play_config.param)
	info = info and info or ""
	info = zstring.split(info, ",", tonumber)

	for _, v in pairs(info) do
		if tonumber(ship_mould_id) == v then
			return true
		end
	end
	return false
end

-- 彩蛋活动增加气泡显示
function HomeHero:showEasterEggPop(shipId,sender)
	if _ED.active_activity[191] ~= nil then 
		local eventInfo = dms.searchs(dms["easter_event_mould"], easter_egg_mould.cd, shipId)
		if eventInfo then 
			-- 是cd事件
			local eggInfo = eventInfo[1]
			local eventId = tonumber(eggInfo[easter_egg_mould.ID])
			local haveGet = tonumber(_ED.active_activity[191].activity_info["" .. eventId].haveGet)
			-- 彩蛋是否开放
			app.load("client.activity.easter_egg.EasterEggHandle")
			local curDay = EasterEggHandle.getEasterEggDays()
			local showData = zstring.split(dms.string(dms["activity_config"], 124, activity_config.param), "|")
			for i, v in ipairs(showData) do
				if i <= curDay then 
					local info = zstring.split(v, ",")
					for k, val in ipairs(info) do
						if tonumber(val) == eventId and haveGet <= 0 then
							-- 未领取过,展示气泡
							app.load("client.activity.easter_egg.EasterEggWindow")
							local cell = state_machine.excute("easter_egg_window_open",0,{eggInfo = eggInfo})
							sender:addChild(cell)
							return 
						end
					end
				end
			end
		end
	end
end
