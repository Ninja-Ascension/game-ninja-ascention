-- ----------------------------------------------------------------------------------------------------
-- 说明：挖矿主界面
-------------------------------------------------------------------------------------------------------
AdventureMineManager = class("AdventureMineManagerClass", Window)

app.load("client.red_alert.battle.battle_macros")

function segmentsIntr(a, b, c, d)
    -- /** 1 解线性方程组, 求线段交点. **/  
    -- // 如果分母为0 则平行或共线, 不相交  
    local denominator = (b.y - a.y)*(d.x - c.x) - (a.x - b.x)*(c.y - d.y);  
    if (denominator==0) then
        return false
    end
   
    -- // 线段所在直线的交点坐标 (x , y)      
    local x = ( (b.x - a.x) * (d.x - c.x) * (c.y - a.y)   
                + (b.y - a.y) * (d.x - c.x) * a.x   
                - (d.y - c.y) * (b.x - a.x) * c.x ) / denominator ;  
    local y = -( (b.y - a.y) * (d.y - c.y) * (c.x - a.x)   
                + (b.x - a.x) * (d.y - c.y) * a.y   
                - (d.x - c.x) * (b.y - a.y) * c.y ) / denominator;  
  
    -- /** 2 判断交点是否在两条线段上 **/  
    if (  
        -- // 交点在线段1上  
        (x - a.x) * (x - b.x) <= 0 and (y - a.y) * (y - b.y) <= 0  
        -- // 且交点也在线段2上  
         and (x - c.x) * (x - d.x) <= 0 and (y - c.y) * (y - d.y) <= 0  
        ) then
  
        -- // 返回交点p  
        return {x = x, y = y}  
    end
    -- //否则不相交  
    return false
end

function segmentsRect(startPosition, endPosition, size)
    if startPosition.x >= 0 and startPosition.x <= size.width 
        and startPosition.y >= 0 and startPosition.y <= size.height
        and endPosition.x >= 0 and endPosition.x <= size.width 
        and endPosition.y >= 0 and endPosition.y <= size.height 
        then
        return true
    end
    local r = segmentsIntr({x = size.width, y = 0}, {x = size.width, y = size.height}, startPosition, endPosition)
    if r == false then
        r = segmentsIntr({x = 0, y = 0}, {x = size.width, y = 0}, startPosition, endPosition)
    end

    if r == false then
        r = segmentsIntr({x = 0, y = 0}, {x = 0, y = size.height}, startPosition, endPosition)
    end

    if r == false then
        r = segmentsIntr({x = 0, y = size.height}, {x = size.width, y = size.height}, startPosition, endPosition)
    end
    return r
end

function multiply(p1x, p1y, p2x, p2y, p0x, p0y)
    return ((p1x - p0x) * (p2y - p0y) - (p2x - p0x) * (p1y - p0y))
end

-- 确定两条线段是否相交
function intersect(uax, uay, ubx, uby, vax, vay, vbx, vby)
    return ((math.max(uax, ubx) >= math.min(vax, vbx)) 
            and (math.max(vax, vbx) >= math.min(uax, ubx))
            and (math.max(uay, uby) >= math.min(vay, vby))
            and (math.max(vay, vby) >= math.min(uay, uby)) --  （以两线段为对角线的矩形是否相交）
            and (multiply(vax, vay, ubx, uby, uax, uay) * multiply(ubx, uby, vbx, vby, uax, uay) >= 0)
            and (multiply(uax, uay, vbx, vby, vax, vay) * multiply(vbx, vby, ubx, uby, vax, vay) >= 0))--（是否相互跨立）  
end

function intersectrect(sx, sy, ex, ey, left, top, right, bottom)
    if (intersect(sx, sy, ex, ey, left, top, left, bottom)
            or intersect(sx, sy, ex, ey, left, bottom, right, bottom)
            or intersect(sx, sy, ex, ey, right, bottom, right, top)
            or intersect(sx, sy, ex, ey, right, top, left, top)) then
        return true;
    end
    return false;
end

local adventure_mine_manager_open_terminal = {
    _name = "adventure_mine_manager_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local needCreateWindow = params
        local currentWindow = terminal.advertureMineManagerWindow
        if needCreateWindow == true then
            if currentWindow ~= nil then
                fwin:close(currentWindow)
                currentWindow:release()
                terminal.advertureMineManagerWindow = nil
                currentWindow = nil
            end
            terminal.advertureMineManagerWindow = AdventureMineManager:new():init()
            terminal.advertureMineManagerWindow:retain()
        else
			_ED.current_window_in_main_city = false
            if currentWindow == nil then
                state_machine.excute("adventure_mine_manager_open", 0, true)
            else
                if nil ~= _ED.user_info
                    and nil ~= _ED.user_info.user_grade
                    and zstring.tonumber(_ED.user_info.user_grade) >= 5 
                    then
                    local mineWindow = fwin:find("AdventureMineManagerClass")
                    if mineWindow ~= nil then
                        mineWindow:setVisible(true)
                        mineWindow:resume()
                        mineWindow._is_pause = false

                        if nil ~= mineWindow._minePage then
                            mineWindow._minePage:resume()
                            mineWindow._minePage._is_pause = false
                        end

                        state_machine.excute("red_alert_time_mine_open_mine_object", 0, 0)
                    else
                        mineWindow = currentWindow
                        fwin:open(mineWindow, fwin._background)
                        mineWindow:setVisible(true)
                        mineWindow:resume()
                        mineWindow._is_pause = false

                        if nil ~= mineWindow._minePage then
                            mineWindow._minePage:resume()
                            mineWindow._minePage._is_pause = false
                        end
                        state_machine.excute("red_alert_time_mine_open_mine_object", 0, 0)
                        if fwin:find("HomeButtonClass") ~= nil then
                            state_machine.excute("home_button_window_update_map_state", 0, true)
                        end
                    end
                    state_machine.excute("red_alert_time_mine_update_rebels_state", 0, nil)
                    state_machine.excute("red_alert_time_mine_update_city_energy_info", 0, "")
                end
            end
            if nil ~= _ED.user_info
                and nil ~= _ED.user_info.user_grade
                and zstring.tonumber(_ED.user_info.user_grade) >= 5 then
                state_machine.excute("red_alert_time_mine_update_world_info", 0, "red_alert_time_mine_update_world_info.")
                state_machine.excute("adventure_mine_enemy_boss_change_state", 0, nil)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_mine_manager_hide_terminal = {
    _name = "adventure_mine_manager_hide",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local mineWindow = fwin:find("AdventureMineManagerClass")
        if mineWindow ~= nil then
            mineWindow:setVisible(false)
            mineWindow:pause()
            mineWindow._is_pause = true

            if nil ~= mineWindow._minePage then
                mineWindow._minePage:pause()
                mineWindow._minePage._is_pause = true
            end

			NetworkManager:register(protocol_command.world_exit.code, nil, nil, nil, nil, nil, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_mine_manager_reload_action_terminal = {
    _name = "adventure_mine_manager_reload_action",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local tterminal = state_machine.find("adventure_mine_manager_open")
        if tterminal ~= nil and tterminal.advertureMineManagerWindow then
            local csbAdventureManger = tterminal.advertureMineManagerWindow._csbAdventureManger
            if nil ~= csbAdventureManger then
                csbAdventureManger:stopAllActions()

                local action = csb.createTimeline(config_csb.world_map.mine_manger)
                tterminal.advertureMineManagerWindow.actions = {}
                table.insert(tterminal.advertureMineManagerWindow.actions, action)
                csbAdventureManger:runAction(action)
                state_machine.excute("adventure_mine_clear", 0, 0)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_mine_manager_open_terminal)
state_machine.add(adventure_mine_manager_hide_terminal)
state_machine.add(adventure_mine_manager_reload_action_terminal)
state_machine.init()

function AdventureMineManager:ctor()
    self.super:ctor()
    self.roots = {}
    self.Text_reset = nil
    self.Text_reset_time = nil
    self.interval = 0
    self.LoadingBar = nil
    self.needUpdateMineRefreshCd = false
    self.LoadingBar_refresh_time = 0
    self.LoadingBar_surplus_time = 0
    self.LoadingBar_next_time = 0
    self.LoadingBar_number = 0
    self.Text_nj = nil
    self.Text_position = nil
    self.Text_dj = nil
    self.batch_item_name = nil
    self.batch_item_consumeCount = nil
    self.reset_boss_Panel = nil
    self.reset_boss_Button = nil
    self.boss_tip_Panel = nil
    self.boss_tip_show_Panel = nil
    self.boss_count_Text = nil
    self.Image_tip_direction = nil
    self.Text_tip_level = nil
    self.ArmatureNode_boss = nil
    self.action = nil
	
	self.Panel_num_input = nil
	
	self.newInputCoordinateX = 0
	self.newInputCoordinateY = 0
	
	self.actions = {}
	self.actionsOpen = false

    self.Button_map_arrow = nil
	self.Text_map_location = nil
	
	self.current_coordinate_x = 0
	self.current_coordinate_y = 0

    self.Text_coordinate_x = nil
    self.Text_coordinate_y = nil

    -- Initialize adventure mine manager state machine.
    local function init_adventure_mine_manager_terminal()
        -- 恢复耐力
        local adventure_mine_manager_recover_endurance_terminal = {
            _name = "adventure_mine_manager_recover_endurance",
            _init = function (terminal) 
                app.load("client.adventure.campaign.mine.AdventureMinePackage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseMineExploitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 默认显示矿工包
                        fwin:open(AdventureMinePackage:new():init(2), fwin._view)
                    end
                end
                NetworkManager:register(protocol_command.get_mineral_prop_list.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置矿区
        local adventure_mine_manager_reset_mine_terminal = {
            _name = "adventure_mine_manager_reset_mine",
            _init = function (terminal) 
                app.load("client.adventure.campaign.mine.AdventureMineReset")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMineReset:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 矿区工坊
        local adventure_mine_manager_mine_hook_terminal = {
            _name = "adventure_mine_manager_mine_hook",
            _init = function (terminal) 
                app.load("client.adventure.campaign.mine.AdventureMineWorkshop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseMineExploitCallback(response)
                    -- print(response.resouce)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureMineWorkshop:new():init(), fwin._view)
                    end
                end
                NetworkManager:register(protocol_command.mineral_workspace_init.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

      -- 刷新矿区BOSS状态
        local adventure_mine_manager_mine_reset_boss_terminal = {
            _name = "adventure_mine_manager_mine_reset_boss",
            _init = function (terminal) 
                app.load("client.adventure.campaign.mine.AdventureMineResetBossDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMineResetBossDialog:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新BOSS数量
        local adventure_mine_manager_mine_boss_count_update_terminal = {
            _name = "adventure_mine_manager_mine_boss_count_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateBossCount()
                instance:onUpdateZabingLevel()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 弹出批量购买炸弹框
        local adventure_mine_manager_open_batch_buy_bomb_terminal = {
            _name = "adventure_mine_manager_open_batch_buy_bomb",
            _init = function (terminal) 
                app.load("client.adventure.shop.AdventureShopBatch")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureShopBatch:new():init({mould_name = instance.batch_item_name ,original_cost = instance.batch_item_consumeCount ,shop_prop_instance = 303},1), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 资源仓库
        local adventure_mine_manager_mine_package_terminal = {
            _name = "adventure_mine_manager_mine_package",
            _init = function (terminal) 
                app.load("client.adventure.campaign.mine.AdventureMinePackage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseMineExploitCallback(response)
                    -- print(response.resouce)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureMinePackage:new():init(1), fwin._view)
                    end
                end
                NetworkManager:register(protocol_command.get_mineral_prop_list.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

       --有BOSS杂兵的时候挖矿播放动画
        local adventure_mine_manager_mine_boss_action_terminal = {
            _name = "adventure_mine_manager_mine_boss_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新炸弹数量
        local adventure_mine_manager_mine_update_bomb_terminal = {
            _name = "adventure_mine_manager_mine_update_bomb",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateBombText()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 更新提示
        local adventure_mine_manager_mine_zabing_level_terminal = {
            _name = "adventure_mine_manager_mine_zabing_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateZabingLevel()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local adventure_mine_manager_update_basics_terminal = {
            _name = "adventure_mine_manager_update_basics",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params.x ~= nil and params.y ~= nil then 
                    --单点后,刷新坐标
                    self:updateDrawTitleCellPosition(params.x,params.y)
					self.current_coordinate_x = params.x
					self.current_coordinate_y = params.y
                else
                    self:updateDrawBasics()    
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_mine_manager_props_reconnaissance_terminal = {
            _name = "adventure_mine_manager_props_reconnaissance",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("PropsShopPacksClass") ~= nil then
                    state_machine.excute("props_shop_packs_window_close", 0, 0)
                end
                state_machine.excute("adventure_mine_update_view_position", 0, 0)
                state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
                _ED.world_map_focus = {instance.current_coordinate_x, instance.current_coordinate_y}
                state_machine.excute("adventure_mine_cell_focus_blink", 0, _ED.world_map_focus)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		--世界等级说明
		local red_alert_time_mine_box_info_terminal = {
            _name = "red_alert_time_mine_box_info",
            _init = function (terminal)
				app.load("client.red_alert_time.worldMap.redAlertTimeMineWorldInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --进入到世界等级说明里
				if __lua_project_id == __lua_project_pacific_rim then
                    state_machine.excute("world_map_play_infor_window_open", 0, {_datas = {_page = 4}})
                else
                    state_machine.excute("red_alert_time_mine_world_information_open", 0, 0)
                end
				state_machine.excute("world_input_window_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--世界定位
		local red_alert_time_mine_locate_yourself_terminal = {
            _name = "red_alert_time_mine_locate_yourself",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --世界定位
				state_machine.excute("adventure_mine_record_view_position", 0, 0)
				state_machine.excute("adventure_mine_update_view_position", 0, 0)
				state_machine.excute("world_input_window_close", 0, 0)

                local function responseWorldMapArenaInfoRefreshCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then 
                            state_machine.excute("adventure_mine_small_map_update",0,0)
                        end
                    end
                end
				protocol_command.world_map_arena_info_refresh.param_list = "" .. _ED.world_map.position_coordinates_x .. "\r\n" .. _ED.world_map.position_coordinates_y
				NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, self, responseWorldMapArenaInfoRefreshCallBack, false, nil)
				
				
				state_machine.excute("adventure_mine_manager_update_basics",0,{x = _ED.world_map.position_coordinates_x, y = _ED.world_map.position_coordinates_y})
				
				_ED.world_map_focus = {_ED.world_map.position_coordinates_x, _ED.world_map.position_coordinates_y}
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--世界收藏
		local red_alert_time_mine_open_social_collection_terminal = {
            _name = "red_alert_time_mine_open_social_collection",
            _init = function (terminal)
				app.load("client.red_alert_time.chat.SocialPlatforms")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --世界收藏
				state_machine.excute("world_input_window_close", 0, 0)
				state_machine.excute("game_social_platforms_open", 0, {_datas = {page = 4}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--世界搜索
		local red_alert_time_mine_search_for_coordinate_terminal = {
            _name = "red_alert_time_mine_search_for_coordinate",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --世界世界搜索
				state_machine.excute("adventure_mine_record_view_position", 0, {self.newInputCoordinateX,self.newInputCoordinateY})
				state_machine.excute("adventure_mine_update_view_position", 0, 0)
				state_machine.excute("world_input_window_close", 0, 0)
				
				local function responseMapArenaInfoRefreshCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local m_point = {}
						m_point.x = self.newInputCoordinateX
						m_point.y = self.newInputCoordinateY
						state_machine.excute("adventure_mine_small_map_update",0,m_point)
						instance.current_coordinate_x = self.newInputCoordinateX
						instance.current_coordinate_y = self.newInputCoordinateY
					end
				end
				
				protocol_command.world_map_arena_info_refresh.param_list = "" .. self.newInputCoordinateX .. "\r\n" .. self.newInputCoordinateY
				NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, self, responseMapArenaInfoRefreshCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--附近的人
		local red_alert_time_mine_view_nearby_terminal = {
            _name = "red_alert_time_mine_view_nearby",
            _init = function (terminal)
				app.load("client.red_alert_time.worldMap.redAlertTimeMineViewNearby")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --附近的人
				if zstring.tonumber(instance.current_coordinate_x) == 0 then
					instance.current_coordinate_x = _ED.world_map.position_coordinates_x
				end
				if zstring.tonumber(instance.current_coordinate_y) == 0 then
					instance.current_coordinate_y = _ED.world_map.position_coordinates_y
				end
				state_machine.excute("red_alert_time_mine_view_nearby_open", 0, {instance.current_coordinate_x,instance.current_coordinate_y,params})
				state_machine.excute("world_input_window_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--坐标输入
		local red_alert_time_mine_open_input_digital_terminal = {
            _name = "red_alert_time_mine_open_input_digital",
            _init = function (terminal)
				-- app.load("client.red_alert_time.cells.player.input_digital_window")
                app.load("client.red_alert_time.world.WorldInputWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("world_input_window_close", 0, "")
                local coord_x = zstring.tonumber(instance.Text_coordinate_x:getString())
                local coord_y = zstring.tonumber(instance.Text_coordinate_y:getString())
                state_machine.excute("world_input_window_open", 0, {params._datas.coordinate_type, coord_x, coord_y})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--清除坐标界面
		local red_alert_time_mine_close_input_digital_terminal = {
            _name = "red_alert_time_mine_close_input_digital",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.Panel_num_input:removeAllChildren(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--坐标刷新
		local red_alert_time_mine_input_digital_coordinate_update_terminal = {
            _name = "red_alert_time_mine_input_digital_coordinate_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateCoordinate(params[1],params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--开关小地图
		
		local red_alert_time_mine_open_and_end_small_map_terminal = {
            _name = "red_alert_time_mine_open_and_end_small_map",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("world_input_window_close", 0, 0)
				if instance.actionsOpen == false then
					instance:openSmallMap("open_little_map","open_little_map_over")
					instance.actionsOpen = true
				else
					instance:openSmallMap("close_little_map","close_little_map_over")
					instance.actionsOpen = false
				end
				
				state_machine.excute("adventure_mine_small_map_update",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--小地图定位
		local red_alert_time_mine_positioning_small_terminal = {
            _name = "red_alert_time_mine_positioning_small",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("red_alert_time_mine_positioning_small")
				local positioning_info = {
					{x=100 ,y=100},
					{x=100 ,y=300},
					{x=100 ,y=500},
					{x=300 ,y=100},
					{x=300 ,y=300},
					{x=300 ,y=500},
					{x=500 ,y=100},
					{x=500 ,y=300},
					{x=500 ,y=500},
				}
				local posX = positioning_info[zstring.tonumber(params._datas.m_point)].x
				local posY = positioning_info[zstring.tonumber(params._datas.m_point)].y
				state_machine.excute("adventure_mine_record_view_position", 0, {posX,posY})
				state_machine.excute("adventure_mine_update_view_position", 0, 0)
				state_machine.excute("world_input_window_close", 0, 0)
				
				local function responseMapArenaInfoRefreshCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_mine_small_map_update",0,positioning_info[zstring.tonumber(params._datas.m_point)])
						instance.current_coordinate_x = posX
						instance.current_coordinate_y = posY
                    else
                        state_machine.unlock("red_alert_time_mine_positioning_small")
					end
				end
				
				protocol_command.world_map_arena_info_refresh.param_list = "" .. posX .. "\r\n" .. posY
				NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, self, responseMapArenaInfoRefreshCallBack, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--小地图刷新
		local red_alert_time_mine_positioning_small_update_terminal = {
            _name = "red_alert_time_mine_positioning_small_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:SmallMapRefresh(params[1],params[2],params[3],params[4])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新世界主界面信息
		local red_alert_time_mine_update_world_info_terminal = {
            _name = "red_alert_time_mine_update_world_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateWorldRank()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新世界玩家资源信息
		local red_alert_time_mine_update_players_resources_terminal = {
            _name = "red_alert_time_mine_update_players_resources",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
    				instance:updatePlayersResources()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_update_rebels_state_terminal = {
            _name = "red_alert_time_mine_update_rebels_state",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateRebelsButton()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local red_alert_time_mine_open_mine_object_terminal = {
            _name = "red_alert_time_mine_open_mine_object",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.roots[2] == nil then
                    if tonumber(_ED.user_info.user_grade) >= 5 then
                        local world_map_open = cc.UserDefault:getInstance():getStringForKey(getKey("world_map_open"))
                        if world_map_open == nil or world_map_open == "" then
                            -- app.load("client.adventure.campaign.mine.AdventureMine")
                            -- instance:onUpdateBackGround()
                            state_machine.excute("red_alert_time_mine_locate_yourself",0,0)
                        
                            app.load("client.red_alert_time.big_map.WorldMapPlayInfor")
                            state_machine.excute("world_map_play_infor_window_open", 0, nil)
                            cc.UserDefault:getInstance():setStringForKey(getKey("world_map_open"), "open")
                            cc.UserDefault:getInstance():flush()
                        end
                    end
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_open_play_infor_window_terminal = {
            _name = "red_alert_time_mine_open_play_infor_window",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local world_map_play_infor = cc.UserDefault:getInstance():getStringForKey(getKey("world_map_play_infor"))
                if world_map_play_infor == nil or world_map_play_infor == "" then
                    cc.UserDefault:getInstance():setStringForKey(getKey("world_map_play_infor"), "open")
                    cc.UserDefault:getInstance():flush()
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Image_world_player_infor"):setVisible(true)
                    instance.roots[1]:getChildByName("Panel_top"):getChildByName("ArmatureNode_world_player_infor"):setVisible(false)
                end
                app.load("client.red_alert_time.big_map.WorldMapPlayInfor")
                state_machine.excute("world_map_play_infor_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_update_city_energy_info_terminal = {
            _name = "red_alert_time_mine_update_city_energy_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateCityEnergy()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_update_city_shop_time_terminal = {
            _name = "red_alert_time_mine_update_city_shop_time",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateCityShopTime(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_update_city_user_info_terminal = {
            _name = "red_alert_time_mine_update_city_user_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateWorldUserInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mine_manager_mine_update_bomb_terminal)
        state_machine.add(adventure_mine_manager_recover_endurance_terminal)
        state_machine.add(adventure_mine_manager_reset_mine_terminal)
        state_machine.add(adventure_mine_manager_mine_hook_terminal)
        state_machine.add(adventure_mine_manager_mine_package_terminal)
        state_machine.add(adventure_mine_manager_update_basics_terminal)
        state_machine.add(adventure_mine_manager_open_batch_buy_bomb_terminal)
        state_machine.add(adventure_mine_manager_mine_reset_boss_terminal)
        state_machine.add(adventure_mine_manager_mine_boss_count_update_terminal)
        state_machine.add(adventure_mine_manager_mine_zabing_level_terminal)
        state_machine.add(adventure_mine_manager_mine_boss_action_terminal)
        state_machine.add(red_alert_time_mine_box_info_terminal)
        state_machine.add(red_alert_time_mine_update_world_info_terminal)
        state_machine.add(red_alert_time_mine_locate_yourself_terminal)
        state_machine.add(red_alert_time_mine_open_social_collection_terminal)
        state_machine.add(red_alert_time_mine_search_for_coordinate_terminal)
        state_machine.add(red_alert_time_mine_view_nearby_terminal)
        state_machine.add(red_alert_time_mine_open_input_digital_terminal)
        state_machine.add(red_alert_time_mine_close_input_digital_terminal)
        state_machine.add(red_alert_time_mine_input_digital_coordinate_update_terminal)
        state_machine.add(red_alert_time_mine_open_and_end_small_map_terminal)
        state_machine.add(red_alert_time_mine_positioning_small_terminal)
        state_machine.add(red_alert_time_mine_update_players_resources_terminal)
        state_machine.add(red_alert_time_mine_positioning_small_update_terminal)
        state_machine.add(adventure_mine_manager_props_reconnaissance_terminal)
        state_machine.add(red_alert_time_mine_update_rebels_state_terminal)
        state_machine.add(red_alert_time_mine_open_mine_object_terminal)
        state_machine.add(red_alert_time_mine_open_play_infor_window_terminal)
        state_machine.add(red_alert_time_mine_update_city_energy_info_terminal)
        state_machine.add(red_alert_time_mine_update_city_shop_time_terminal)
        state_machine.add(red_alert_time_mine_update_city_user_info_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mine manager state machine.
    init_adventure_mine_manager_terminal()

    self:onInit()
end

function AdventureMineManager:init()
    -- if nil ~= _ED.user_info
    --     and nil ~= _ED.user_info.user_grade
    --     and zstring.tonumber(_ED.user_info.user_grade) >= 5 then
        app.load("client.adventure.campaign.mine.AdventureMine")
        self:onUpdateBackGround()
    -- end
	return self
end

function AdventureMineManager:playAction()
    if self ~= nil and self.roots ~= nil and self.action ~= nil then 
        if #_ED.adventure_mine.boss_mineral > 0 then
            self.action:play("animation_boss", false)
        end
    end
end

function AdventureMineManager:onUpdateBackGround()
    local minePage = AdventureMine:new():init()
    minePage._screen_size = self.Button_map_arrow_pb._size
    minePage:registerOnNodeEvent(minePage)
    minePage:registerOnNoteUpdate(minePage, 0)
    self:addChild(minePage,0)
    self._minePage = minePage
    --新手指引特殊处理,需要选中单个小矿
    table.insert(self.roots, minePage.roots[1])
end

if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
else
    function AdventureMineManager:onUpdate(dt)
        if _ED.adventure_mine.current_mine ~= nil   then
            self.interval = tonumber(_ED.adventure_mine.current_mine.refresh_time)
            self.needUpdateMineRefreshCd = true
            self:updateMineRefreshCd()
        end

        if self.interval > 0 then
            local interval = (_ED.adventure_mine.current_mine.refresh_time + _ED.adventure_mine.mine_start_time) - os.time() --(_ED.adventure_mine.current_mine.refresh_time + _ED.native_time) - os.time() --
            if self.interval ~= interval then
                self.interval = interval
                self:updateMineRefreshCd()
            end
        end

        --_ED._system_current_fuel_time -- 系统当前时间  
        --_ED._last_fuel_recover_time = npos(list)        -- 上次燃料恢复时间
        --_ED._next_fuel_recover_time = npos(list)        -- 下次燃料恢复时间
        
    	if __lua_project_id ~= __lua_project_red_alert_time then
    		if self.LoadingBar_refresh_time == 0 then
    			self.LoadingBar_number = tonumber(_ED.user_info.endurance)
    			self.Text_nj:setString(_ED.user_info.endurance.."/".._ED.user_info.max_endurance)
    			self.LoadingBar_refresh_time = (_ED._next_fuel_recover_time - _ED._last_fuel_recover_time) / 1000

    			self.LoadingBar_surplus_time = (_ED._next_fuel_recover_time - _ED._system_current_fuel_time) / 1000
    			self.LoadingBar_next_time = os.time() + self.LoadingBar_surplus_time 
    		end
    		self:UpdateMineDurableLoadingBar()
    		
        end
    	-- if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
    	-- 	state_machine.excute("red_alert_time_mine_update_players_resources", 0, true)
    	-- end
    end
end

-- 刷新耐久进度条
function AdventureMineManager:UpdateMineDurableLoadingBar()
        local parent = math.max(0, math.min(100,(self.LoadingBar_next_time - os.time()) / self.LoadingBar_refresh_time * 100))
        if parent <=  0    then
            self.LoadingBar_last_time = os.time()
            self.LoadingBar_next_time = os.time() + self.LoadingBar_refresh_time
            self.LoadingBar_number = self.LoadingBar_number + 1
            self.Text_nj:setString(self.LoadingBar_number.."/".._ED.user_info.max_endurance)
            _ED.user_info.endurance = self.LoadingBar_number
            if self.LoadingBar_number <= tonumber(_ED.user_info.max_endurance)   then
            
                if self.LoadingBar_number == tonumber(_ED.user_info.max_endurance)  then
                    self.LoadingBar:setPercent(0)
                    self.LoadingBar_refresh_time = 0 
                end
            end
        end

        if tonumber(_ED.user_info.endurance) >= tonumber(_ED.user_info.max_endurance)   then
            self.LoadingBar:setPercent(0)
            self.LoadingBar_refresh_time = 0 
        else
            self.LoadingBar:setPercent(100 - parent) 
        end
end

function AdventureMineManager:updateDrawRLInfo( ... )

    -- function segmentsIntr(a, b, c, d)
  
    --     --//线段ab的法线N1  
    --     local nx1 = (b.y - a.y), ny1 = (a.x - b.x);  
      
    --     --//线段cd的法线N2  
    --     local nx2 = (d.y - c.y), ny2 = (c.x - d.x);  
          
    --     --//两条法线做叉乘, 如果结果为0, 说明线段ab和线段cd平行或共线,不相交  
    --     local denominator = nx1*ny2 - ny1*nx2;  
    --     if (denominator==0) then
    --         return false;  
    --     end
          
    --     --//在法线N2上的投影  
    --     local distC_N2=nx2 * c.x + ny2 * c.y;  
    --     local distA_N2=nx2 * a.x + ny2 * a.y-distC_N2;  
    --     local distB_N2=nx2 * b.x + ny2 * b.y-distC_N2;  
      
    --     --// 点a投影和点b投影在点c投影同侧 (对点在线段上的情况,本例当作不相交处理);  
    --     if ( distA_N2*distB_N2>=0  ) then
    --         return false;  
    --     end
          
    --     --//  
    --     --//判断点c点d 和线段ab的关系, 原理同上  
    --     --//  
    --     --//在法线N1上的投影  
    --     local distA_N1=nx1 * a.x + ny1 * a.y;  
    --     local distC_N1=nx1 * c.x + ny1 * c.y-distA_N1;  
    --     local distD_N1=nx1 * d.x + ny1 * d.y-distA_N1;  
    --     if ( distC_N1*distD_N1>=0  ) then
    --         return false;  
    --     end
      
    --     --//计算交点坐标  
    --     local fraction= distA_N2 / denominator;  
    --     local dx= fraction * ny1
    --     local dy= -fraction * nx1;  
    --     return { x: a.x + dx , y: a.y + dy };  
    -- end

    -- function segmentsIntr(a, b, c, d)
    --     -- // 三角形abc 面积的2倍  
    --     local area_abc = (a.x - c.x) * (b.y - c.y) - (a.y - c.y) * (b.x - c.x);  
      
    --     -- // 三角形abd 面积的2倍  
    --     local area_abd = (a.x - d.x) * (b.y - d.y) - (a.y - d.y) * (b.x - d.x);   
      
    --     -- // 面积符号相同则两点在线段同侧,不相交 (对点在线段上的情况,本例当作不相交处理);  
    --     if ( area_abc*area_abd>=0 ) then
    --         return false;  
    --     end
      
    --     -- // 三角形cda 面积的2倍  
    --     local area_cda = (c.x - a.x) * (d.y - a.y) - (c.y - a.y) * (d.x - a.x);  
    --     -- // 三角形cdb 面积的2倍  
    --     -- // 注意: 这里有一个小优化.不需要再用公式计算面积,而是通过已知的三个面积加减得出.  
    --     local area_cdb = area_cda + area_abc - area_abd ;  
    --     if (  area_cda * area_cdb >= 0 ) then
    --         return false;  
    --     end
      
    --     -- //计算交点坐标  
    --     local t = area_cda / ( area_abd- area_abc );  
    --     local dx= t*(b.x - a.x)
    --     local dy= t*(b.y - a.y);  
    --     return { x= a.x + dx , y= a.y + dy };  
    -- end

    local size = self.Button_map_arrow_pb._size -- self.Button_map_arrow:getParent():getContentSize()
    -- debug.print_r(size)

    local center = cc.p(size.width / 2, size.height / 2)
    local vector = cc.p(center.x + AdventureMine.__player_position.x - AdventureMine.__current_position.x, center.y + AdventureMine.__player_position.y - AdventureMine.__current_position.y)

    local r = segmentsIntr({x = size.width, y = 0}, {x = size.width, y = size.height}, center, {x = vector.x, y = vector.y})
    if r == false then
        r = segmentsIntr({x = 0, y = 0}, {x = size.width, y = 0}, center, {x = vector.x, y = vector.y})
    end

    if r == false then
        r = segmentsIntr({x = 0, y = 0}, {x = 0, y = size.height}, center, {x = vector.x, y = vector.y})
    end

    if r == false then
        r = segmentsIntr({x = 0, y = size.height}, {x = size.width, y = size.height}, center, {x = vector.x, y = vector.y})
    end
    
    -- debug.print_r({r, vector, size, AdventureMine.__player_position, AdventureMine.__current_position})

    local angle = CC_POSITIONS_TO_DEGREES(center, vector)
    self.Button_map_arrow:setRotation(angle + 90)
    self.Button_map_arrow:setPosition(center)
	
	-- print(self.Button_map_arrow:getRotation())
	if tonumber(self.Button_map_arrow:getRotation()) > 116 and tonumber(self.Button_map_arrow:getRotation()) < 270 then
		-- local actions = {}
		-- table.insert(actions, cc.DelayTime:create(0))
		-- local seq = cc.Sequence:create(actions)
		-- self.Button_map_arrow:runAction(seq)
		self.Button_map_arrow:setScaleY(-1)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_map_location"):setScaleX(-1)
	else
		self.Button_map_arrow:setScaleY(1)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_map_location"):setScaleX(1)
	end
	
	local position_info = self.Text_position:getString()
	local x_info = zstring.split(position_info, "X:")
	local x_info_pos = zstring.split(x_info[2], " ")
	local x_x = x_info_pos[1]
	local y_info = zstring.split(position_info, "Y:")
	local y_y = y_info[2]
    local movePos = math.ceil((getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,x_x,y_y)-120)/20)
	self.Text_map_location:setString(movePos.."km")

    -- local sangle = 90 - angle
    -- tan = y / x
    -- local a = math.tan(sangle) * (size.width / 2)
    -- print("-------->>>:", math.tan(sangle), (90 - self._angle), a)
    if r ~= false then
        self.Button_map_arrow:setPosition(r)
        if tonumber(movePos) > 0 then
            self.Button_map_arrow:setVisible(true)
        else
            self.Button_map_arrow:setVisible(false)
        end
    else
        self.Button_map_arrow:setVisible(false)
    end
	if tonumber(_ED.world_map.position_coordinates_x) == tonumber(x_x) and tonumber(_ED.world_map.position_coordinates_y) == tonumber(y_y) then
		self.Button_map_arrow:setVisible(false)
	end
end

function AdventureMineManager:onUpdateBossCount()
    local boss_number = #_ED.adventure_mine.boss_mineral
    if boss_number > 0 then
        self.reset_boss_Panel:setVisible(true)
        self.reset_boss_Button:setVisible(true)
        self.boss_count_Text:setString("" .. boss_number)
    else
        self.reset_boss_Panel:setVisible(false)
        self.reset_boss_Button:setVisible(false)
    end
end

function AdventureMineManager:onUpdateMineTip()
    local bossIndex = -1
    local root = self.roots[1]
    local boss_min = 1
    local boss_max = 1
    -- 这个地方需要优化,应该有search方法
    --查找BOSS
    for i=1,15 do
        local tip_mould = dms.element(dms["mine_tip"], i)
        local tipType =  dms.atoi(tip_mould, mine_tip.tip_type)
        if tipType == 0 then 
            local condition = dms.atos(tip_mould, mine_tip.condition_param)
            local conditionArr = zstring.split(condition,",")
            if #conditionArr == 2 then 
                if tonumber(conditionArr[1]) <= 3 and tonumber(conditionArr[2]) >= 3 then 
                    bossIndex = i
                    local bossArr = zstring.split(dms.atos(tip_mould, mine_tip.show_param),"|")
                    boss_min  = tonumber(bossArr[1])
                    boss_max = tonumber(bossArr[2])
                    break
                end
            end
        end
    end
    --查找盒子
    local boxIndex = -1
    for i=8,15 do
        local tip_mould = dms.element(dms["mine_tip"], i)
        local tipType =  dms.atoi(tip_mould, mine_tip.tip_type)
        if tipType == 1 then 
            local condition = dms.atos(tip_mould, mine_tip.condition_param)
            local conditionArr = zstring.split(condition,",")
            if #conditionArr == 2 then 
                if tonumber(conditionArr[1]) <= tonumber(_ED.adventure_mine.mine_depth) and tonumber(conditionArr[2]) >= _ED.adventure_mine.mine_depth then 
                    boxIndex = i
                    
                    break
                end
            end
        end
    end

    if bossIndex ~= -1 then
        local boss_mould =  dms.element(dms["mine_tip"], bossIndex)
        local max_boss = zstring.split(dms.atos(boss_mould, mine_tip.condition_max),"|")
        
        local Panel1 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Panel_boss_1")
        local Panel2 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Panel_boss_2")  
        local Text_name1 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_boss_name_1")        
        local Text_name2 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_boss_name_2")   
        local Text_info1 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_dj_c1")   
        local Text_info2 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_dj_c2") 
        
        local headPic1 = dms.int(dms["npc"], boss_min, npc.base_pic)
        local headPic2 = dms.int(dms["npc"], boss_max, npc.base_pic)
        Panel1:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", headPic1))
        Panel2:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", headPic2))
        Text_name1:setString(dms.string(dms["npc"], boss_min, npc.npc_name))
        Text_name2:setString(dms.string(dms["npc"], boss_max, npc.npc_name))
        local info1 = string.format(_string_piece_info[426],"" .. max_boss[1])
        local info2 = string.format(_string_piece_info[426],"" .. max_boss[2])
        Text_info1:setString("(" .. _ED._mine_monster_zabing_lv .. "/" .. max_boss[1] +1 .. ")" .. info1 )
        Text_info2:setString("(" .. _ED._mine_monster_zabing_lv .. "/" .. max_boss[2] +1 .. ")" .. info2 )
        Panel1:removeAllChildren(true)
        Panel2:removeAllChildren(true)
    end
    
    if boxIndex ~= -1  then 
        local box_mould =  dms.element(dms["mine_tip"], boxIndex)
        local max_box = zstring.split(dms.atos(box_mould, mine_tip.condition_max),"|")
        local showArr = zstring.split(dms.atos(box_mould, mine_tip.show_param),"|")
        local boxInfo1 = zstring.split(showArr[1],"-")
        local boxInfo2 = zstring.split(showArr[2],"-")

        local Panel1 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Panel_hezi_1")
        local Panel2 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Panel_hezi_2")   
        local Text_name1 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_box_name_1")        
        local Text_name2 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_box_name_2") 
        local Text_info1 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_dj_c3")   
        local Text_info2 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_dj_c4")               
        local props_id1 = tonumber(boxInfo1[2])
        local props_id2 = tonumber(boxInfo2[2])
        local quality1 = dms.int(dms["prop_mould"], props_id1, prop_mould.prop_quality)
        local quality2 = dms.int(dms["prop_mould"], props_id2, prop_mould.prop_quality)
        local TextFind1 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_box_found")  
        local TextFind2 = ccui.Helper:seekWidgetByName(self.boss_tip_show_Panel, "Text_box_found_0")  
        if tonumber(boxInfo1[1]) == 0 then  -- 已经发现
            TextFind1:setString(_string_piece_info[428])
            TextFind1:setColor(cc.c3b(66,211,66))
        else --未发现
            TextFind1:setString(_string_piece_info[429])
            TextFind1:setColor(cc.c3b(255,165,0))
        end
        if tonumber(boxInfo2[1]) == 0 then  -- 已经发现
            TextFind2:setString(_string_piece_info[428])
            TextFind2:setColor(cc.c3b(66,211,66))
        else --未发现
            TextFind2:setString(_string_piece_info[429])
            TextFind2:setColor(cc.c3b(255,165,0))
        end
        local info1 = string.format(_string_piece_info[427],"" .. max_box[1])
        local info2 = string.format(_string_piece_info[427],"" .. max_box[2])
        Text_info1:setString("(" .. _ED.adventure_mine.mine_depth .. "/" .. tonumber(max_box[1]) .. ")" .. info1 )
        Text_info2:setString("(" .. _ED.adventure_mine.mine_depth .. "/" .. tonumber(max_box[2]) .. ")" .. info2 )

        Text_name1:setString(dms.string(dms["prop_mould"], props_id1, prop_mould.prop_name))
        Text_name1:setColor(cc.c3b(hero_name_color_Type[quality1+1][1],hero_name_color_Type[quality1+1][2],hero_name_color_Type[quality1+1][3]))           
        Text_name2:setString(dms.string(dms["prop_mould"], props_id2, prop_mould.prop_name))
        Text_name2:setColor(cc.c3b(hero_name_color_Type[quality2+1][1],hero_name_color_Type[quality2+1][2],hero_name_color_Type[quality2+1][3]))
        Panel1:removeAllChildren(true)
        Panel2:removeAllChildren(true)
        Panel1:setBackGroundImage(string.format("images/ui/props/porps_%d.png", dms.int(dms["prop_mould"], props_id1, prop_mould.pic_index)))
        Panel2:setBackGroundImage(string.format("images/ui/props/porps_%d.png", dms.int(dms["prop_mould"], props_id2, prop_mould.pic_index)))
    end

end

-- 刷新重置矿区定时器
function AdventureMineManager:updateMineRefreshCd()
    if self.needUpdateMineRefreshCd == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
    if interval <= 0 then
        self.Text_reset:setVisible(true)
        self.Text_reset_time:setVisible(false)
        self.needUpdateMineRefreshCd = false
    else
        self.Text_reset:setVisible(false)
        self.Text_reset_time:setVisible(true)
        self.interval = math.max(0, self.interval)
        local timeTabel = formatTime(self.interval)
        local day = timeTabel.day
        local hours = timeTabel.hour + day*24
        local str = hours
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)
        self.Text_reset_time:setString(str)

    end
end


function AdventureMineManager:updateDrawBasics()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_dj"):setString(_ED.adventure_lv)
	self.Text_nj:setString(_ED.user_info.endurance.."/".._ED.user_info.max_endurance)
    self.LoadingBar_number = tonumber(_ED.user_info.endurance)
	local targetNumber = 0
	for i, v in pairs(_ED.user_prop) do
		if zstring.tonumber(v.user_prop_template) == 303 then
			targetNumber = zstring.tonumber(v.prop_number)
			break	
		end
	end
	ccui.Helper:seekWidgetByName(root, "Text_5"):setString("x"..targetNumber)
	if _ED.mine_depth_x == 0 and _ED.mine_deotg_y == 0 then
		local mineData = zstring.split(cc.UserDefault:getInstance():getStringForKey(getKey("mine_data")), "|")
		local mine_x = 0

		for y, v in pairs(mineData) do
			local coordInfos = zstring.split(v, ",")
			for _, m in pairs(coordInfos) do
				local tileInfo = zstring.split(m, ":")
				if y==#mineData then
					mine_x = tileInfo[1]
					break
				end
			end
		end
		self.Text_position:setString("X:"..mine_x.." Y:"..(#mineData-1))
	else
		self.Text_position:setString("X:".._ED.mine_depth_x.." Y:".._ED.mine_deotg_y)
	end
    self:onUpdateBossCount()
end

function AdventureMineManager:updateDrawTitleCellPosition(x,y)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        self.Text_position:setString("X:".. x .." Y:".. y)
        self.Text_position_bg:stopAllActions()
		function blinkOutCallback1(sender)
		
		end
	
        self.Text_position_bg:runAction(cc.Sequence:create(
                    cc.MoveTo:create(0.3, cc.p(self.Text_position_bg._pos.x, self.Text_position_bg._pos.y - self.Text_position_bg._size.height - 36)),
                    cc.DelayTime:create(0.5),
                    cc.MoveTo:create(0.3, cc.p(self.Text_position_bg._pos.x, self.Text_position_bg._pos.y)),
					cc.CallFunc:create(blinkOutCallback1)
                )
            )

        -- 公里数
        if 0 ~= zstring.tonumber(AdventureMine.__current_position.x) or 0 ~= zstring.tonumber(AdventureMine.__current_position.y) then
            self:updateDrawRLInfo()
        end
	else
		self.Text_position:setString("X:".. x .." Y:".. y) 
	end

    if __lua_project_id == __lua_project_pacific_rim then
        self.Text_coordinate_x:setString(x)
        self.Text_coordinate_y:setString(y)
    end
end

function AdventureMineManager:onUpdateZabingLevel()
    self.Text_tip_level:setString(string.format(red_alert_time_str[33],_ED._mine_monster_zabing_lv))
end

function AdventureMineManager:onUpdateBombText()
    local root = self.roots[1]
    local targetNumber = 0
    for i, v in pairs(_ED.user_prop) do
        if zstring.tonumber(v.user_prop_template) == 303 then
            targetNumber = zstring.tonumber(v.prop_number)
            break   
        end
    end
    ccui.Helper:seekWidgetByName(root, "Text_5"):setString("x"..targetNumber)
end

function AdventureMineManager:onInit()
    local  root =  nil
    local csbAdventureManger = nil
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		csbAdventureManger = csb.createNode(config_csb.world_map.mine_manger)
	else
		csbAdventureManger = csb.createNode("campaign/Mining/wakuang.csb")
	end
    root = csbAdventureManger:getChildByName("root")
	
	table.insert(self.roots, root)
    self:addChild(csbAdventureManger,3)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        self._csbAdventureManger = csbAdventureManger
        local action = csb.createTimeline(config_csb.world_map.mine_manger)
        table.insert(self.actions, action)
        csbAdventureManger:runAction(action)
        
		-- self:updateWorldRank()

        self.Text_position = ccui.Helper:seekWidgetByName(root, "Text_world_x_y")
        self.Text_position_bg = self.Text_position:getParent()
        self.Text_position_bg._pos = cc.p(self.Text_position_bg:getPosition())
        self.Text_position_bg._size = self.Text_position_bg:getContentSize()
		self.Panel_num_input = ccui.Helper:seekWidgetByName(root, "Panel_num_input")
	else
		self.Text_reset  = ccui.Helper:seekWidgetByName(root, "Text_reset")
		self.Text_reset_time = ccui.Helper:seekWidgetByName(root, "Text_reset_time")
		self.Text_nj = ccui.Helper:seekWidgetByName(root, "Text_nj")

		
		
		--else

		self.Text_dj = ccui.Helper:seekWidgetByName(root, "Text_dj")
		self.boss_count_Text =ccui.Helper:seekWidgetByName(root, "Text_boss_num")
		
		--end
		self.Text_position = ccui.Helper:seekWidgetByName(root, "Text_coor")
		self.reset_boss_Panel = ccui.Helper:seekWidgetByName(root, "Panel_boss")
		self.reset_boss_Button = ccui.Helper:seekWidgetByName(root, "Button_boss")
		self.reset_boss_Panel:setVisible(false)
		self.reset_boss_Button:setVisible(false)
		self.boss_tip_Panel = ccui.Helper:seekWidgetByName(root, "Panel_boss_tips")
		self.boss_tip_Panel:setVisible(true)
		self.boss_tip_show_Panel = ccui.Helper:seekWidgetByName(root, "Panel_3")
		self.boss_tip_show_Panel:setVisible(false)
		self.Image_tip_direction = ccui.Helper:seekWidgetByName(self.boss_tip_Panel, "Image_7")
		self.Image_tip_direction:setRotation(90)
		self.Text_tip_level = ccui.Helper:seekWidgetByName(self.boss_tip_Panel, "Text_dj_boss")
		local function formationTouchListener(sender, eventType)
			if eventType == ccui.TouchEventType.began then
				self:onUpdateMineTip()
				self.boss_tip_show_Panel:setVisible(true)
				 self.Image_tip_direction:setRotation(270)
			   
			elseif eventType == ccui.TouchEventType.moved then 
			   
			elseif eventType == ccui.TouchEventType.ended then 
				self.Image_tip_direction:setRotation(90)
			   self.boss_tip_show_Panel:setVisible(false)
			else 
				self.Image_tip_direction:setRotation(90)
				self.boss_tip_show_Panel:setVisible(false)
			end
		end
		self:onUpdateZabingLevel()
		self.boss_tip_Panel:addTouchEventListener(formationTouchListener)

		-- self.ArmatureNode_boss = ccui.Helper:seekWidgetByName(self.reset_boss_Panel, "ArmatureNode_1")
		--draw.initArmature(self.ArmatureNode_boss, nil, -1, 0, 1)
		--csb.animationChangeToAction(self.ArmatureNode_boss, 0, 0, false)
		-- 显示锄头耐久回复倒计时进度条
	
		self.LoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
		local datas = dms.element(dms["prop_mould"], 303)
		self.batch_item_name = dms.atos(datas, prop_mould.prop_name)
		local config = zstring.split(dms.string(dms["pirates_config"], 325, pirates_config.param), "|")
		local ids_array = zstring.split(config[1], ",")
		local index = -1
		for k,v in pairs(ids_array) do
			if tonumber(v) == 303 then 
				index = k
				break
			end
		end
		if index ~= -1  then 
			local consume_array = zstring.split(config[2], ",")
			self.batch_item_consumeCount = tonumber(consume_array[index])
		else
			self.batch_item_consumeCount = 0
		end
	end
    -- 恢复耐力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hoe"), nil, 
    {
        terminal_name = "adventure_mine_manager_recover_endurance", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 重置矿区
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reset"), nil, 
    {
        terminal_name = "adventure_mine_manager_reset_mine", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 重置boss
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boss"), nil, 
    {
        terminal_name = "adventure_mine_manager_mine_reset_boss", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 定位BOSS
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_boss"), nil, 
    {
        terminal_name = "adventure_mine_location_boss", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 批量购买炸弹
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_9"), nil, 
    {

        terminal_name = "adventure_mine_manager_open_batch_buy_bomb", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 矿区工坊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gongfang"), nil, 
    {
        terminal_name = "adventure_mine_manager_mine_hook", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        app.load("client.red_alert_time.big_map.WorldMapPlayInfor")
		-- 矿区工坊
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_world_player_infor"), nil, 
        {
            terminal_name = "red_alert_time_mine_open_play_infor_window", 
            terminal_state = 0,
            cell = self,
            isPressedActionEnabled = true
        }, 
        nil, 0)
	else
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_mining",
			_widget = ccui.Helper:seekWidgetByName(root, "Button_gongfang"),
			_invoke = nil,
			_isHome = false,
			_interval = 0.5,})
	end
    
    -- 资源仓库
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cangku"), nil, 
    {
        terminal_name = "adventure_mine_manager_mine_package", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	----------------------------------红警世界--------------------------------------------------------------
	--世界等级说明进入
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_box"), nil, 
	{
		terminal_name = "red_alert_time_mine_box_info", 
		terminal_state = 0,
		isPressedActionEnabled = false
	}, 
	 nil, 0)
	 
	--世界定位
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_location"), nil, 
	{
		terminal_name = "red_alert_time_mine_locate_yourself", 
		terminal_state = 0,
        touch_black = true,
	}, 
	 nil, 0)
	 
	--世界收藏
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collection"), nil, 
	{
		terminal_name = "red_alert_time_mine_open_social_collection", 
		terminal_state = 0,
        touch_black = true,
	}, 
	 nil, 0)
	 
	--世界搜索按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_1"), nil, 
	{
		terminal_name = "red_alert_time_mine_search_for_coordinate", 
		terminal_state = 0,
        touch_black = true,
	}, 
	 nil, 0)
	--附近的人
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_map_search"), nil, 
	{
		terminal_name = "red_alert_time_mine_view_nearby", 
		terminal_state = 0,
        touch_black = true,
	}, 
	 nil, 0)
	 
	 --x的坐标输入
	 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_coordinate_x"), nil, 
	{
		terminal_name = "red_alert_time_mine_open_input_digital", 
		terminal_state = 0,
		coordinate_type = 0,
        touch_black = true,
	}, 
	 nil, 0)
	 
	 --y的坐标输入
	 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_coordinate_y"), nil, 
	{
		terminal_name = "red_alert_time_mine_open_input_digital", 
		terminal_state = 0,
		coordinate_type = 1,
        touch_black = true,
	}, 
	 nil, 0)
	 
	--世界箭头定位
	self.Button_map_arrow = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_map_arrow"), nil, 
	{
		terminal_name = "red_alert_time_mine_locate_yourself", 
		terminal_state = 0,
        touch_black = true,
	}, 
	nil, 0)
	self.Text_map_location = ccui.Helper:seekWidgetByName(root, "Text_map_location")
    self.Button_map_arrow_pb = self.Button_map_arrow:getParent()
    self.Button_map_arrow_pb._size = self.Button_map_arrow_pb:getContentSize()
    self.Button_map_arrow_pb._size.height = self.Button_map_arrow_pb._size.height + (-1 * app.baseOffsetY)
    self.Button_map_arrow_pb:setContentSize(self.Button_map_arrow_pb._size)
    self.Button_map_arrow:setVisible(false)
    -- debug.print_r(self.Button_map_arrow_pb._size)

	--资源按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_res_infor"), nil, 
	{
		terminal_name = "base_reserve_window_open", 
		terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 1,
        touch_black = true,
        page_index = 1,
	}, 
	nil, 0)
	 
	
	--小地图打开
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_map_location"), nil, 
	{
		terminal_name = "red_alert_time_mine_open_and_end_small_map", 
		terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 1,
        touch_black = true,
	}, 
	 nil, 0)
	 
	 --小地图定位
	 for i=1, 9 do 
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_little_map_click_"..i), nil, 
		{
			terminal_name = "red_alert_time_mine_positioning_small", 
			terminal_state = 0,
			m_point = i
		}, 
		 nil, 0)
	 end
	
    -- 叛军按钮
    if ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt") ~= nil then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt"), nil, 
        {
            terminal_name = "main_window_open_rebels_window",
            terminal_state = 0,
            touch_black = true,
        },
        nil,1)
    end

    -- 城市战能量购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_energe"), nil, 
    {
        terminal_name = "main_window_buy_city_energy",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    -- 城市战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_battle"), nil, 
    {
        terminal_name = "legion_city_formation_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    -- 城市商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_shop"), nil, 
    {
        terminal_name = "legion_city_shop_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    -- 城市战小地图
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_map_small"), nil, 
    {
        terminal_name = "red_alert_time_small_map_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

	 -----------------------------------------end--------------------------------------------------------------
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		-- local world_map_play_infor = cc.UserDefault:getInstance():getStringForKey(getKey("world_map_play_infor"))
  --       if world_map_play_infor == nil or world_map_play_infor == "" then
  --           ccui.Helper:seekWidgetByName(root,"Image_world_player_infor"):setVisible(false)
  --           root:getChildByName("Panel_top"):getChildByName("ArmatureNode_world_player_infor"):setVisible(true)
  --       else
  --           ccui.Helper:seekWidgetByName(root, "Image_world_player_infor"):setVisible(true)
  --           root:getChildByName("Panel_top"):getChildByName("ArmatureNode_world_player_infor"):setVisible(false)
  --       end
	else
		local reward = getSceneReward(15)
		if reward ~= nil then
			app.load("client.adventure.reward.AdventureTipReward")
			fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
			reward = nil
		end
	end
end

function AdventureMineManager:checkEnduranceNum()
    --_ED._system_current_fuel_time -- 系统当前时间  
    --_ED._last_fuel_recover_time = npos(list)        -- 上次燃料恢复时间
    --_ED._next_fuel_recover_time = npos(list)        -- 下次燃料恢复时间
    local current_time = os.time()
    local current_server_time = _ED.system_time + (current_time - _ED.native_time) --当前服务器时间
    if zstring.tonumber(current_server_time) > (_ED._next_fuel_recover_time/1000) then 
        --已经超过了
        local off_time = current_server_time - _ED._next_fuel_recover_time /1000

        local off_counts = math.floor(off_time/((_ED._next_fuel_recover_time - _ED._last_fuel_recover_time)/1000))

        self.LoadingBar_number = tonumber(_ED.user_info.endurance)
        self.LoadingBar_number = self.LoadingBar_number + off_counts
    else
        self.LoadingBar_number = tonumber(_ED.user_info.endurance)

        self.Text_nj:setString(_ED.user_info.endurance.."/".._ED.user_info.max_endurance)
        self.LoadingBar_refresh_time = (_ED._next_fuel_recover_time - _ED._last_fuel_recover_time) / 1000

        self.LoadingBar_surplus_time = (_ED._next_fuel_recover_time - _ED._system_current_fuel_time) / 1000
        self.LoadingBar_next_time = current_time + self.LoadingBar_surplus_time 
    end
end

function AdventureMineManager:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return
	end
    --胜利后会掉落奖励
    local reward = getSceneReward(15)
    if reward ~= nil then
        app.load("client.adventure.reward.AdventureTipReward")
        fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
        reward = nil
    end
    --炎魔 挖矿事件奖励
    local reward1 = getSceneReward(57)
    if reward1 ~= nil then

        app.load("client.adventure.reward.AdventureTipReward")
        fwin:open(AdventureTipReward:new():init(reward1), fwin._ui)
        reward1 = nil
    end
    self.action = csb.createTimeline("campaign/Mining/wakuang.csb")
    self.roots[1]:runAction(self.action)
	if __lua_project_id ~= __lua_project_red_alert_time then
		self:checkEnduranceNum()
	end
    self.needUpdateMineRefreshCd = false
    self:onUpdateBombText()
    
     -- 刷新商店
    local function responseShopViewCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if self ~= nil and self.roots ~= nil then 
                local reward = getSceneReward(60)
                if reward ~= nil then
                    app.load("client.adventure.reward.AdventureTipReward")
                    fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
                    reward = nil
                end
            end
            
        end
    end
    
    NetworkManager:register(protocol_command.mineral_reward_gain_all.code, nil, nil, nil, nil, responseShopViewCallBack, false, nil)
    --print("---onEnterTransitionFinish:",_ED.user_info.endurance)
    self.Text_nj:setString(_ED.user_info.endurance.."/".._ED.user_info.max_endurance)
    self.Text_dj:setString(_ED.adventure_lv)
    state_machine.excute("adventure_push_info_open",0,2)
end

function AdventureMineManager:updateWorldRank()
	local root = self.roots[1]
	--世界等级
	local Text_word_lv_n = ccui.Helper:seekWidgetByName(root, "Text_word_lv_n")
	if _ED.world_map == nil or _ED.world_level == nil or _ED.world_level == "" then
		Text_word_lv_n:setString("0")
	else
		Text_word_lv_n:setString(_ED.world_level)
	end
	---x,y的坐标
	local Text_coordinate_x = ccui.Helper:seekWidgetByName(root, "Text_coordinate_x")
	local Text_coordinate_y = ccui.Helper:seekWidgetByName(root, "Text_coordinate_y")
    self.Text_coordinate_x = Text_coordinate_x
    self.Text_coordinate_y = Text_coordinate_y
	
	if _ED.world_map == nil or _ED.world_map.position_coordinates_x == nil or _ED.world_map.position_coordinates_x == "" then
		Text_coordinate_x:setString("0")
	else
		if self.newInputCoordinateX == 0 then
			Text_coordinate_x:setString(_ED.world_map.position_coordinates_x)
			self.newInputCoordinateX = _ED.world_map.position_coordinates_x
		end
	end
	if _ED.world_map == nil or _ED.world_map.position_coordinates_y == nil or _ED.world_map.position_coordinates_y == "" then
		Text_coordinate_y:setString("0")
	else
		if self.newInputCoordinateY == 0 then
			Text_coordinate_y:setString(_ED.world_map.position_coordinates_y)
			self.newInputCoordinateY = _ED.world_map.position_coordinates_y
		end
	end
	self:updatePlayersResources()
end

function AdventureMineManager:updatePlayersResources()
	local root = self.roots[1]
	
	--铁矿
	local Text_iron_ore_n = ccui.Helper:seekWidgetByName(root, "Text_iron_ore_n")
	local LoadingBar_iron_ore = ccui.Helper:seekWidgetByName(root,"LoadingBar_iron_ore")    
	if _ED.user_info.user_iron == nil or _ED.user_info.user_iron == "" then
		Text_iron_ore_n:setString(exChangeNumToString(0))
		LoadingBar_iron_ore:setPercent(0)
	else
		Text_iron_ore_n:setString(exChangeNumToString(_ED.user_info.user_iron))
		LoadingBar_iron_ore:setPercent(_ED.user_info.user_iron / _ED.user_info.user_iron_max *100)
	end
	
	-- 石油
    local Text_petroeum_n = ccui.Helper:seekWidgetByName(root,"Text_petroeum_n")
    local LoadingBar_petroeum = ccui.Helper:seekWidgetByName(root,"LoadingBar_petroeum")    
	if _ED.user_info.oil_field == nil or _ED.user_info.oil_field == "" then
		Text_petroeum_n:setString(exChangeNumToString(0))
		LoadingBar_petroeum:setPercent(0)
	else
		Text_petroeum_n:setString(exChangeNumToString(_ED.user_info.oil_field))
		LoadingBar_petroeum:setPercent(_ED.user_info.oil_field / _ED.user_info.oil_field_max *100)
	end

    -- 铅矿
    local Text_lead_ore_n = ccui.Helper:seekWidgetByName(root,"Text_lead_ore_n")
    local LoadingBar_lead_ore = ccui.Helper:seekWidgetByName(root,"LoadingBar_lead_ore")    
	if _ED.user_info.exploits == nil or _ED.user_info.exploits == "" then
		Text_lead_ore_n:setString(exChangeNumToString(0))
		LoadingBar_lead_ore:setPercent(0)
	else
		Text_lead_ore_n:setString(exChangeNumToString(_ED.user_info.exploits))
		LoadingBar_lead_ore:setPercent(_ED.user_info.exploits / _ED.user_info.exploits_max *100)
	end

    -- 钛矿
    local Text_titanium_ore_n = ccui.Helper:seekWidgetByName(root,"Text_titanium_ore_n")
    local LoadingBar_titanium_ore = ccui.Helper:seekWidgetByName(root,"LoadingBar_titanium_ore")    
	if _ED.user_info.tiger_shaped == nil or _ED.user_info.tiger_shaped == "" then
		Text_titanium_ore_n:setString(exChangeNumToString(0))
		LoadingBar_titanium_ore:setPercent(0)
	else
		Text_titanium_ore_n:setString(exChangeNumToString(_ED.user_info.tiger_shaped))
		LoadingBar_titanium_ore:setPercent(_ED.user_info.tiger_shaped / _ED.user_info.tiger_shaped_max *100)
	end

    -- 宝石
    local Text_gemstone_n = ccui.Helper:seekWidgetByName(root,"Text_gemstone_n")
    local LoadingBar_gemstone = ccui.Helper:seekWidgetByName(root,"LoadingBar_gemstone")    
	if _ED.user_info.user_silver == nil or _ED.user_info.user_silver == "" then
		Text_gemstone_n:setString(exChangeNumToString(0))
		LoadingBar_gemstone:setPercent(0)
	else
		Text_gemstone_n:setString(exChangeNumToString(_ED.user_info.user_silver))
		LoadingBar_gemstone:setPercent(_ED.user_info.user_silver / _ED.user_info.user_silver_max *100)
	end
end

function AdventureMineManager:updateWorldUserInfo( ... )
    if __lua_project_id == __lua_project_pacific_rim then
        local root = self.roots[1]
        local LoadingBar_player_exp = ccui.Helper:seekWidgetByName(root,"LoadingBar_player_exp")
        local Text_player_lv = ccui.Helper:seekWidgetByName(root,"Text_player_lv")
        local LoadingBar_player_energy = ccui.Helper:seekWidgetByName(root,"LoadingBar_player_energy")
        local Text_player_energy_n = ccui.Helper:seekWidgetByName(root,"Text_player_energy_n")

        Text_player_lv:setString(_ED.user_info.user_grade)
        if zstring.tonumber(_ED.user_info.user_experience) == 0 then
            LoadingBar_player_exp:setPercent(0)
        else
            local persent_exp = zstring.tonumber(_ED.user_info.user_experience) * 100 / zstring.tonumber(_ED.user_info.user_grade_need_experience)
            LoadingBar_player_exp:setPercent(persent_exp)
        end

        Text_player_energy_n:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food)
        local persent_energy = zstring.tonumber(_ED.user_info.user_food) * 100 / zstring.tonumber(_ED.user_info.max_user_food)
        LoadingBar_player_energy:setPercent(persent_energy)
    end
end

function AdventureMineManager:SmallMapRefresh(x,y,dx,dy)
    if true then
        return
    end
	--主角x，主角y，定位x，定位y
	local root = self.roots[1]
	--定点坐标
	local Image_rock_location = ccui.Helper:seekWidgetByName(root,"Image_rock_location")
	local rock_x = 0
	local rock_y = (dy+29920)/315+74+Image_rock_location:getContentSize().height*3/2
	if dx >= 60000 then
		rock_x = (dx-600000)/310.5+232
	else
		rock_x = (600000-dx)/310.5+232
	end
	Image_rock_location:setPosition(cc.p(rock_x, rock_y))
	
	--主角基地坐标
	local Image_palyer_location = ccui.Helper:seekWidgetByName(root,"Image_palyer_location")
	local palyer_x = 0
	local palyer_y = (y+29920)/315+74+Image_palyer_location:getContentSize().height
	if x >= 60000 then
		palyer_x = (x-600000)/310.5+232
	else
		palyer_x = (600000-x)/310.5+232
	end
	Image_palyer_location:setPosition(cc.p(palyer_x, palyer_y))
    state_machine.unlock("red_alert_time_mine_positioning_small")
end

function AdventureMineManager:updateCoordinate(coordinate_x,coordinate_y)
	local root = self.roots[1]
	local Text_coordinate_x = ccui.Helper:seekWidgetByName(root, "Text_coordinate_x")
	local Text_coordinate_y = ccui.Helper:seekWidgetByName(root, "Text_coordinate_y")
	if coordinate_x == nil then
		Text_coordinate_x:setString(self.newInputCoordinateX)
	else
		Text_coordinate_x:setString(coordinate_x)
		self.newInputCoordinateX = coordinate_x
	end
	
	if coordinate_y == nil then
		Text_coordinate_y:setString(self.newInputCoordinateY)
	else
		Text_coordinate_y:setString(coordinate_y)
		self.newInputCoordinateY = coordinate_y
	end
	
end

function AdventureMineManager:updateRebelsButton()
    local root = self.roots[1]
    local Button_rebel_haunt = ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt")
    Button_rebel_haunt:setVisible(false)
    if _ED.mould_function_push_info["5"] ~= nil then
        if  tonumber(_ED.mould_function_push_info["5"].state) ~= 0 then
            -- checkPlayEffect(72)
            Button_rebel_haunt:setVisible(true)
        else
            Button_rebel_haunt:setVisible(false)     
        end
    end
end

function AdventureMineManager:updateCityEnergy()
    -- local root = self.roots[1]
    -- local Panel_legion_city_energe = ccui.Helper:seekWidgetByName(root,"Panel_legion_city_energe") 
    -- local Text_legion_city_energe_n = ccui.Helper:seekWidgetByName(root,"Text_legion_city_energe_n")

    -- local Text_legion_city_shop_time_n = ccui.Helper:seekWidgetByName(root,"Text_legion_city_shop_time_n")
    -- local Image_2_0 = ccui.Helper:seekWidgetByName(root,"Image_2_0")

    -- if Panel_legion_city_energe ~= nil then
    --     Panel_legion_city_energe:setVisible(false)

    --     local shop_state = 0
    --     local push_info = _ED.mould_function_push_info["15"]
    --     local end_time = 0
    --     if push_info ~= nil then
    --         shop_state = tonumber(push_info.state)
    --         end_time = tonumber(push_info.params) / 1000 + push_info.start_time
    --     end

    --     if shop_state == 0 then
    --         Panel_legion_city_energe:setVisible(false)
    --     else
    --         Panel_legion_city_energe:setVisible(true)
    --         if shop_state == 1 then
    --             Text_legion_city_shop_time_n:setString(tipStringInfo_campaign_info[26])
    --         else
    --             local leave_time = end_time - (os.time() + _ED.time_add_or_sub)
    --             Text_legion_city_shop_time_n:setString(getRedAlertTimeFormat(leave_time))
    --         end
    --     end

    --     local open_state = 0
    --     if _ED.mould_function_push_info["14"] ~= nil then
    --         open_state = tonumber(_ED.mould_function_push_info["14"].state)
    --     end

    --     local Button_legion_city_battle = ccui.Helper:seekWidgetByName(root,"Button_legion_city_battle") 
    --     local Button_legion_city_energe = ccui.Helper:seekWidgetByName(root,"Button_legion_city_energe") 
    --     local Text_legion_city_energe_t = ccui.Helper:seekWidgetByName(root,"Text_legion_city_energe_t") 
    --     local Text_legion_city_energe_n = ccui.Helper:seekWidgetByName(root,"Text_legion_city_energe_n") 
    --     local Image_2 = ccui.Helper:seekWidgetByName(root,"Image_2") 

    --     if open_state == 2 and _ED.world_city_info ~= nil and _ED.world_city_info.my_info ~= nil then
    --         Panel_legion_city_energe:setVisible(true)
    --         Text_legion_city_energe_n:setString("".._ED.world_city_info.my_info.energy)

    --         Button_legion_city_battle:setVisible(true)
    --         Button_legion_city_energe:setVisible(true)
    --         Text_legion_city_energe_t:setVisible(true)
    --         Text_legion_city_energe_n:setVisible(true)
    --         Image_2:setVisible(true)
    --     else
    --         Button_legion_city_battle:setVisible(false)
    --         Button_legion_city_energe:setVisible(false)
    --         Text_legion_city_energe_t:setVisible(false)
    --         Text_legion_city_energe_n:setVisible(false)
    --         Image_2:setVisible(false)
    --     end
    -- end
end

function AdventureMineManager:updateCityShopTime(leave_time)
    -- local root = self.roots[1]
    -- local Text_legion_city_shop_time_n = ccui.Helper:seekWidgetByName(root,"Text_legion_city_shop_time_n")
    -- Text_legion_city_shop_time_n:setString(getRedAlertTimeFormat(leave_time))
end

function AdventureMineManager:openSmallMap(actionStart, actionEnd)
	self.actions[1]:play(actionStart, false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == actionEnd then
			--打开结束
        end
        
    end)
end

function AdventureMineManager:onResume( window )
    if nil ~= self._minePage then
        self._minePage:resume()
        self._minePage._is_pause = false
    end
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        state_machine.excute("red_alert_time_mine_update_players_resources", 0, true)
    end
end

function AdventureMineManager:onPause( window )
    if nil ~= self._minePage then
        self._minePage:pause()
        self._minePage._is_pause = true
    end
end

function AdventureMineManager:onExit()
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
    else
        state_machine.excute("adventure_push_info_close",0,0)
        -- state_machine.remove("adventure_mine_manager_recover_endurance")
        -- state_machine.remove("adventure_mine_manager_reset_mine")
        -- state_machine.remove("adventure_mine_manager_mine_hook")
        -- state_machine.remove("adventure_mine_manager_mine_package")
    end
end