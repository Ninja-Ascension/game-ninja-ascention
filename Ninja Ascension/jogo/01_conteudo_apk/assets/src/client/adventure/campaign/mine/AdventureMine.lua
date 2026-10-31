-- ----------------------------------------------------------------------------------------------------
-- 说明：矿山
-------------------------------------------------------------------------------------------------------
AdventureMine = class("AdventureMineClass", Window)
AdventureMine.__isCanClick = true
AdventureMine.__map_screen_rect = {left = -695359, top = 78024, right = -503996, bottom = -17210}
AdventureMine.__player_position = cc.p(0, 0)
AdventureMine.__current_position = cc.p(0, 0)
    
function AdventureMine:ctor()
    self.super:ctor()
    self.roots = {}
    self.touches = {}

    self.controllerLayer = nil
    self.controllerSize = nil
    self.controllerStartPosition = nil
    self.controllerStartUpdatePosition = nil
    self.currentInnerContainerAnchor = nil
    self.currentInnerContainerOrigin = nil
    self.mapViewSize = nil
    self.focusCell = nil 

    self.data_map = {}
    self.free_map = {}
    self.used_map = {}
    self.view_rect = {x=0, y=0, rx=0, ry=0, width=0, height=0}
    self.locationBossIndex = 0 
    self.mine_center_pos = {}
	
	-- self.aaa = {}
	-- self.cca = {}
 --    self.cta = {}
    self.centerCellX = 0
    self.centerCellY = 0
	self.map_actual_point = {}
	self.old_coordinates_x = 0
	self.old_coordinates_y = 0
	
    self.lastInnerContainerPosY = 0
    self.lastInnerContainerPosX = 0

    self._enemyBossRoadPaths = {}
    self._enemyUserPath = nil       -- 敌军来袭玩家进攻路径
    self._path_list = {}

    app.load("client.adventure.campaign.mine.AdventureMineExploit")
    app.load("client.adventure.cells.mine.adventure_mine_tile_cell")
    app.load("client.adventure.campaign.mine.AdventureMineBubble")
    app.load("client.red_alert_time.worldMap.redAlertTimeSmallMap")

    -- Initialize adventure mine state machine.
    local function init_adventure_mine_terminal()
        -- 新手指引的点击矿区
        local adventure_mine_cell_exploit_terminal = {
            _name = "adventure_mine_cell_exploit",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                   
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_mine_reset_update_draw_terminal = {
            _name = "adventure_mine_reset_update_draw",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    self.controllerStartPosition.x = instance.controllerStartUpdatePosition.x
                    self.controllerStartPosition.y = instance.controllerStartUpdatePosition.y
                    self.currentInnerContainerOrigin.x = instance.controllerStartUpdatePosition.x
                    self.currentInnerContainerOrigin.y = instance.controllerStartUpdatePosition.y
                    cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_coord"), "" .. instance.controllerStartUpdatePosition.x .. "," .. instance.controllerStartUpdatePosition.y)
                    cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_anchor"), "" .. self.currentInnerContainerAnchor.x .. "," .. self.currentInnerContainerAnchor.y)
                    cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_scale"), "" .. 1)
                    self.controllerLayer:setScale(1)
                    self.controllerLayer:setPosition(cc.p(self.controllerStartPosition.x,self.controllerStartPosition.y))

                    _ED.adventure_mine.boss_mineral = nil
                    _ED.adventure_mine.boss_mineral = {}
                    state_machine.excute("adventure_mine_manager_mine_boss_count_update",0,0)
                    instance:formatMineData()
                    instance:initMineTiles()
                    instance.focusCell = nil 
                    instance.currentInnerContainerPosY = instance.currentInnerContainerPosY + 80
                    instance.currentInnerContainerPosX = instance.currentInnerContainerPosX + 80
                    instance.beginTileX = instance.beginTileX - 10
                    instance:onUpdate(1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --重置BOSS
        local adventure_mine_reset_boss_update_draw_terminal = {
            _name = "adventure_mine_reset_boss_update_draw",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    self.locationBossIndex = 0
                    instance:onUpdateResetBossMineData()
                    instance.currentInnerContainerPosX = instance.currentInnerContainerPosX + 80
                    instance.currentInnerContainerPosY = instance.currentInnerContainerPosY + 80
                    instance.beginTileX = instance.beginTileX - 10
                    instance:onUpdate(1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
       -- boss 气泡
        local adventure_mine_boss_bubble_draw_terminal = {
            _name = "adventure_mine_boss_bubble_draw",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateBubbleDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local adventure_mine_location_boss_terminal = {
            _name = "adventure_mine_location_boss",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:locationBoss()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         local adventure_mine_reset_add_draw_terminal = {
            _name = "adventure_mine_reset_add_draw",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:addformatMineData()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
	   --记录上次挖的cell
        local adventure_mine_exploit_open_success_terminal = {
            _name = "adventure_mine_exploit_open_success",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance.focusCell = params.node
                    instance.focusCell:retain()
                        
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --本地挖矿数据更新
        local adventure_mine_change_ed_data_terminal = {
            _name = "adventure_mine_change_ed_data",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:changeMinedata(tonumber(params.x),tonumber(params.y),params.type,params.update)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_mine_reset_update_draw_basics_terminal = {
            _name = "adventure_mine_reset_update_draw_basics",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("adventure_mine_manager_update_basics", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗胜利后要刷新数据
        local adventure_mine_battle_victory_update_terminal = {
            _name = "adventure_mine_battle_victory_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil then 
                    instance:onUpdateBattleBossVictory(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 记录坐标
        local adventure_mine_record_view_position_terminal = {
            _name = "adventure_mine_record_view_position",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                    local size = {width = 1200000, height = 18240}
                    local sx = -1 * size.width / 2
                    local sy = -1 * size.height

                    -- _ED.world_map.position_coordinates_x = 600
                    -- _ED.world_map.position_coordinates_y = 600
					local x = 0
                    local y = 0
					local updatePlayerPosition = false
					if params ~= 0 and (params[2] ~= nil or params[2] ~= "") then
						-- x = _ED.cca[zstring.tonumber(params[2])][zstring.tonumber(params[1])].x - 600
						-- y = _ED.cca[zstring.tonumber(params[2])][zstring.tonumber(params[1])].y - 1

                        local cmx = zstring.tonumber(params[1])
                        local cmy = zstring.tonumber(params[2])
                        if cmy == 600 then
                            if cmx == 1 then
                                cmx = 2
                            end 
                            cmy = 599
                        end

						local ccax, ccay = cc.dms_init_world_map_get(1, cmx, cmy)
						x = ccax - 600
						y = ccay - 1
                        updatePlayerPosition = true
					else
						-- x = _ED.cca[_ED.world_map.position_coordinates_y][_ED.world_map.position_coordinates_x].x - 600
						-- y = _ED.cca[_ED.world_map.position_coordinates_y][_ED.world_map.position_coordinates_x].y - 1
						local ccax, ccay = cc.dms_init_world_map_get(1, _ED.world_map.position_coordinates_x, _ED.world_map.position_coordinates_y)
						x = ccax - 600
						y = ccay - 1
                        updatePlayerPosition = true
					end
                    
                    local px = 0
                    local py = 0
                    local offx = 0
                    local offy = 0
                    offx = -(_ED.mine_tile_width/2) * x
                    offy = (_ED.mine_tile_height/2) * (x % 2)
                    px = sx - (x * _ED.mine_tile_width + offx) + fwin._width / 2
                    py = sy + (y * _ED.mine_tile_height - _ED.mine_tile_height + offy) - _ED.mine_tile_height + fwin._height-- + app.baseOffsetY / 2 -- + (fwin._height - app.baseOffsetY) - (fwin._height - app.baseOffsetY) / 2 / 160

                    if x%2 == 0 then
                        py = py + app.baseOffsetY / 2 + 60
                    else
                        py = py + app.baseOffsetY / 2 - 60
                    end
                    px = math.min(px, AdventureMine.__map_screen_rect.right)
                    px = math.max(px, AdventureMine.__map_screen_rect.left)

                    py = math.min(py, AdventureMine.__map_screen_rect.top)
                    py = math.max(py, AdventureMine.__map_screen_rect.bottom)


                    local cellY = self.controllerSize.height + (py - 960 + _ED.mine_tile_width) + 80 
                    local mod = cellY % _ED.mine_tile_height
                    cellY = cellY - mod
                    local cellX =  math.abs(px) + _ED.mine_tile_width - self.controllerSize.width / 2
                    local mod1 = cellX % _ED.mine_tile_height
                    cellX = cellX - mod1
                    -- print(cellY, cellX, pos.x, pos.y, self.controllerSize.width, self.controllerSize.height)
                    -- print(pos.x, pos.y)

                    cellX = math.floor(cellX/_ED.mine_tile_height)
                    cellY = math.floor(cellY/_ED.mine_tile_height)
                    
                    local size2 = self.controllerSize
                    local sx2 = size2.width / 2
                    local sy2 = size2.height
                    local offx2 = 0
                    local offy2 = 0
                    offx2 = -(_ED.mine_tile_width/2) * cellX
                    offy2 = (_ED.mine_tile_height/2) * (cellX % 2)
                    AdventureMine.__current_position.x = sx2 + cellX * _ED.mine_tile_width + offx2
                    AdventureMine.__current_position.y = sy2 - cellY * _ED.mine_tile_height - _ED.mine_tile_height + offy2

                    -- print("adventure_mine_record_view_position:", _ED.world_map.position_coordinates_x, _ED.world_map.position_coordinates_y, x, y, px, py)
                    cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_coord"), "" .. px .. "," .. py)
                    if true == updatePlayerPosition then
                        local offx = 0
                        local offy = 0
                        offx = -(_ED.mine_tile_width/2) * x
                        offy = (_ED.mine_tile_height/2) * (x % 2)
                        -- print(offy)
                        -- if zstring.tonumber(self.tileType) == 1 then
                        --  print(x, y, tonumber(y) * 160 - 160)
                        -- end
						if self.old_coordinates_x ~= _ED.world_map.position_coordinates_x and self.old_coordinates_y ~= _ED.world_map.position_coordinates_y then
							AdventureMine.__player_position.x = -1 * sx + x * _ED.mine_tile_width + offx -_ED.mine_tile_width/2
							AdventureMine.__player_position.y = -1 * sy - y * _ED.mine_tile_height - _ED.mine_tile_height + offy-48 +_ED.mine_tile_height
							self.old_coordinates_x = _ED.world_map.position_coordinates_x
							self.old_coordinates_y = _ED.world_map.position_coordinates_y
						end
						-- if AdventureMine.__player_position.x == 0 and AdventureMine.__player_position.y == 0 then
							-- AdventureMine.__player_position.x = -1 * sx + x * 320 + offx
							-- AdventureMine.__player_position.y = -1 * sy - y * 160 - 160 + offy-48
						-- end
                    end
					if params ~= 0 and (params[2] ~= nil or params[2] ~= "") then
						state_machine.excute("adventure_mine_manager_update_basics",0,{x = zstring.tonumber(params[1]), y = zstring.tonumber(params[2])})
					end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新坐标
        local adventure_mine_update_view_position_terminal = {
            _name = "adventure_mine_update_view_position",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                    local mineCoordData = cc.UserDefault:getInstance():getStringForKey(getKey("mine_data_coord"))
                    if mineCoordData == nil or #mineCoordData > 0 then
                        local coord_xy = zstring.split(mineCoordData, ",")
                        if coord_xy[1] ~= nil and coord_xy[2] ~= nil then
                            instance.controllerLayer:setPosition(cc.p(coord_xy[1], coord_xy[2]))

                            -- instance.controllerStartPosition.x = tonumber(coord_xy[1])
                            -- instance.controllerStartPosition.y = tonumber(coord_xy[2])

                            -- instance.currentInnerContainerPosX = instance.controllerStartPosition.x + 80
                            -- instance.currentInnerContainerPosY = instance.controllerStartPosition.y + 80
                            -- print("adventure_mine_update_view_position:", coord_xy[1], coord_xy[2])

                            -- instance.currentInnerContainerOrigin = cc.p(instance.controllerLayer:getPosition())

                            instance.controllerStartPosition = cc.p(instance.controllerLayer:getPosition())

                            instance.currentInnerContainerOrigin = cc.p(instance.controllerLayer:getPosition())

                            -- print(" ---111Jinlai le zuobiao.",instance.controllerStartPosition.x,instance.controllerStartPosition.y)
                            -- print(" ---111jinlai le selce , ",instance.controllerLayer:getScale())
                            -- print(" ---111jinlai le andor , ",instance.controllerLayer:getAnchorPoint().x,instance.controllerLayer:getAnchorPoint().y)
                            
                            instance.currentInnerContainerPosY = instance.controllerStartPosition.y + 80
                            instance.currentInnerContainerPosX = instance.controllerStartPosition.x + 80
							
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新地图
        local adventure_mine_update_map_draw_terminal = {
            _name = "adventure_mine_update_map_draw",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                    -- if #instance.touches > 0 then
                    --     return true
                    -- end
                    if _ED.world_map ~= nil and _ED.world_map.world_map_info_list ~= nil then
                        for i, v in pairs(instance.used_map) do
                            if nil ~= v.tileType and v.tileType >= 0 then
                                local mx = 599 + v.tileX + 1
                                local my = v.tileY + 1
                                -- print(my, mx, v.tileType, v.tileX, v.tileY)
    							local ta = {}
    							local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
    							ta.x = ta_x
    							ta.y = ta_y
    							if ta.x > -1 and ta.y > -1 then
                                    local info = _ED.world_map.world_map_info_list[ta.x .. "," .. ta.y]
                                    -- if nil ~= info then
                                        -- debug.print_r(info)
                                    -- end
                                    if nil ~= info and info._need_update == true then
                                        v.info = info
                                        info._need_update = false
                                        v:updateMapTileEx()
                                    end
                                end
                            end
                        end
                    end
					-- state_machine.excute("red_alert_time_mine_update_world_info", 0, "red_alert_time_mine_update_world_info.")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 地图cell闪烁
        local adventure_mine_cell_focus_blink_terminal = {
            _name = "adventure_mine_cell_focus_blink",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params == nil then
                    return
                end
                local tileX = params[1]
                local tileY = params[2]
				local cell = instance.controllerLayer:getChildByName("cell_"..tonumber(tileX).."_"..tonumber(tileY))
                if cell == nil then
                    return
                end
				local sprite = nil
                if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                    if nil ~= cell.__blink_sprite then
                        sprite = cell.__blink_sprite
                    elseif nil ~= cell.__mine_sprite then
                        sprite = cell.__mine_sprite
                    elseif nil ~= cell.__tile_sprite then
                        sprite = cell.__tile_sprite
                    end
                else
    				if ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_mine").__blink_sprite == nil then
    					sprite = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_mine")._sprite
    				else
    					sprite = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_mine").__blink_sprite
    				end
                end
				function blinkInCallback(sender)
			 		sender:setColor(cc.c3b(130, 130, 130))
			 	end

			 	function blinkOutCallback(sender)
			 		sender:setColor(cc.c3b(255, 255, 255))
					_ED.world_map_focus = nil
			 	end
				if sprite~= nil then
					sprite:runAction(cc.Sequence:create(
							cc.CallFunc:create(blinkInCallback),
							cc.DelayTime:create(0.1),
							cc.CallFunc:create(blinkOutCallback),
							cc.DelayTime:create(0.1),
							cc.CallFunc:create(blinkInCallback),
							cc.DelayTime:create(0.1),
							cc.CallFunc:create(blinkOutCallback)
							))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新地图
        local adventure_mine_draw_army_info_terminal = {
            _name = "adventure_mine_draw_army_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self:drawArmyInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		 -- 移动
        local adventure_mine_force_mobile_terminal = {
            _name = "adventure_mine_force_mobile",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local startingPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(params[1]).."_"..tonumber(params[2]))
				local endPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(params[3]).."_"..tonumber(params[4]))
				local m_time = getWorldTwopointMovementTime(tonumber(params[1]),tonumber(params[2]),tonumber(params[3]),tonumber(params[4]))
				local s_x = 0
				local s_y = 0
				local e_x = 0
				local e_y = 0
                local ccsx, ccsy = cc.dms_init_world_map_get(1, zstring.tonumber(params[1]), zstring.tonumber(params[2]))
                _x = ccsx - 600
                _y = ccsy - 1
                local ccex, ccey = cc.dms_init_world_map_get(1, zstring.tonumber(params[3]), zstring.tonumber(params[4]))
                x_x = ccex - 600
                y_y = ccey - 1

				
				if self.map_actual_point[""..params[1].."_"..params[2]] ~= nil then
					s_x = tonumber(self.map_actual_point[""..params[1].."_"..params[2]][1])
					s_y = tonumber(self.map_actual_point[""..params[1].."_"..params[2]][2])
				else
					-- if startingPoint == nil then
						local size = {width = 1200000, height = 18240}
						local sx = -1 * size.width / 2
						local sy = -1 * size.height
						local offx = 0
                        local offy = 0
                        offx = -(_ED.mine_tile_width/2) * _x
                        offy = (_ED.mine_tile_height/2) * (_x % 2)
                        s_x = -1 * sx + _x * _ED.mine_tile_width + offx
                        s_y = -1 * sy - _y * _ED.mine_tile_height - _ED.mine_tile_height + offy
					-- else
						-- s_x = startingPoint:getPositionX()
						-- s_y = startingPoint:getPositionY()
					-- end
					self.map_actual_point[""..params[1].."_"..params[2]] = {
						s_x,
						s_y,
					}
				end
				if self.map_actual_point[""..params[3].."_"..params[4]] ~= nil then
					e_x = tonumber(self.map_actual_point[""..params[3].."_"..params[4]][1])
					e_y = tonumber(self.map_actual_point[""..params[3].."_"..params[4]][2])
				else
					-- if endPoint == nil then
						local size = {width = 1200000, height = 18240}
						local sx = -1 * size.width / 2
						local sy = -1 * size.height
						local offx = 0
                        local offy = 0
                        offx = -(_ED.mine_tile_width/2) * x_x
                        offy = (_ED.mine_tile_height/2) * (x_x % 2)
						
                        e_x = -1 * sx + x_x * _ED.mine_tile_width + offx
                        e_y = -1 * sy - y_y * _ED.mine_tile_height - _ED.mine_tile_height + offy
					-- else
						-- e_x = endPoint:getPositionX()
						-- e_y = endPoint:getPositionY()
					-- end
					
					self.map_actual_point[""..params[3].."_"..params[4]] = {
						e_x,
						e_y,
					}
				end
				local cells = params[5]
				if cells._path == nil then
					--0攻击移动，1回城移动，2攻击，3加速返回，4请求撤离，5驻守状态，6协防移动，7协防中，8打玩家移动，9校验
					-- print("cells.m_object._event_type=="..cells.m_object._event_type)
					local local_time = (tonumber(cells.m_object._start_time)/1000+tonumber(cells.m_object._complete_time))-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                    if tonumber(cells.m_object._event_type) == 0 or tonumber(cells.m_object._event_type) == 6 or tonumber(cells.m_object._event_type) == 8 then
						cells._path = instance:createPathTexture(instance.controllerLayer,s_x,s_y,e_x,e_y,tonumber(cells.m_object._complete_time), local_time,cells.m_object,params[6], true)
					elseif tonumber(cells.m_object._event_type) == 1 or tonumber(cells.m_object._event_type) == 18 then
						cells._path = instance:createPathTexture(instance.controllerLayer,e_x,e_y,s_x,s_y,tonumber(cells.m_object._complete_time),local_time,cells.m_object,params[6], false)
					elseif tonumber(cells.m_object._event_type) == 11 then	
						--print(e_x,e_y,s_x,s_y)
						cells._path = instance:createPathTexture(instance.controllerLayer,e_x,e_y,s_x,s_y,tonumber(cells.m_object._complete_time), local_time,cells.m_object,params[6],true)
					end
				end
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 创建路径
        local adventure_mine_create_road_path_terminal = {
            _name = "adventure_mine_create_road_path",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = params[1]
                local moveType = params[2]
                local startingPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(params[3]).."_"..tonumber(params[4]))
                local endPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(params[5]).."_"..tonumber(params[6]))
                local isRebel = false
                local isHelpUnion = false
                if info._target_type == 1000 then
                    isRebel = true
                elseif info._target_type == 0 then
                    if info._event_type == 6
                        or info._event_type == 13
                        or info._event_type == 15
                        or info._event_type == 18 
                        then
                        isHelpUnion = true
                    end
                end
                local m_time = getWorldTwopointMovementTime(tonumber(params[3]),tonumber(params[4]),tonumber(params[5]),tonumber(params[6]), isRebel, isHelpUnion)
                local s_x = 0
                local s_y = 0
                local e_x = 0
                local e_y = 0
                local ccsx, ccsy = cc.dms_init_world_map_get(1, zstring.tonumber(params[3]), zstring.tonumber(params[4]))
                local _x = ccsx - 600
                local _y = ccsy - 1
                local ccex, ccey = cc.dms_init_world_map_get(1, zstring.tonumber(params[5]), zstring.tonumber(params[6]))
                local x_x = ccex - 600
                local y_y = ccey - 1

                
                if self.map_actual_point[""..params[3].."_"..params[4]] ~= nil then
                    s_x = tonumber(self.map_actual_point[""..params[3].."_"..params[4]][1])
                    s_y = tonumber(self.map_actual_point[""..params[3].."_"..params[4]][2])
                else
                    local size = {width = 1200000, height = 18240}
                    local sx = -1 * size.width / 2
                    local sy = -1 * size.height
                    local offx = 0
                    local offy = 0
                    offx = -(_ED.mine_tile_width/2) * _x
                    offy = (_ED.mine_tile_height/2) * (_x % 2)
                    s_x = -1 * sx + _x * _ED.mine_tile_width + offx
                    s_y = -1 * sy - _y * _ED.mine_tile_height - _ED.mine_tile_height + offy

                    self.map_actual_point[""..params[3].."_"..params[4]] = {
                        s_x,
                        s_y,
                    }
                end
                if self.map_actual_point[""..params[5].."_"..params[6]] ~= nil then
                    e_x = tonumber(self.map_actual_point[""..params[5].."_"..params[6]][1])
                    e_y = tonumber(self.map_actual_point[""..params[5].."_"..params[6]][2])
                else
                    local size = {width = 1200000, height = 18240}
                    local sx = -1 * size.width / 2
                    local sy = -1 * size.height
                    local offx = 0
                    local offy = 0
                    offx = -(_ED.mine_tile_width/2) * x_x
                    offy = (_ED.mine_tile_height/2) * (x_x % 2)
                    
                    e_x = -1 * sx + x_x * _ED.mine_tile_width + offx
                    e_y = -1 * sy - y_y * _ED.mine_tile_height - _ED.mine_tile_height + offy
                    
                    self.map_actual_point[""..params[5].."_"..params[6]] = {
                        e_x,
                        e_y,
                    }
                end
                local path = nil
                --0攻击移动，1回城移动，2攻击，3加速返回，4请求撤离，5驻守状态，6协防移动，7协防中，8打玩家移动，9校验
                local local_time = (tonumber(info._start_time)/1000+tonumber(info._complete_time))-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                if tonumber(info._event_type) == 0 or tonumber(info._event_type) == 6 or tonumber(info._event_type) == 8 or tonumber(info._event_type) == 19 then
                    path = instance:createTankRoadPath(instance.controllerLayer,s_x,s_y,e_x,e_y,tonumber(info._complete_time),local_time,info,moveType,true)
                elseif tonumber(info._event_type) == 1 or tonumber(info._event_type) == 18 or tonumber(info._event_type) == 23 then
                    path = instance:createTankRoadPath(instance.controllerLayer,e_x,e_y,s_x,s_y,tonumber(info._complete_time),local_time,info,moveType,false)
                elseif tonumber(info._event_type) == 11 then
                    path = instance:createTankRoadPath(instance.controllerLayer,e_x,e_y,s_x,s_y,tonumber(info._complete_time),local_time,info,moveType,true)
                end
                return path
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 全世界移动事件
        local adventure_mine_world_all_attack_event_path_info_terminal = {
            _name = "adventure_mine_world_all_attack_event_path_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("新路线")
                if nil == _ED.world_map then
                    return
                end
                local info = params[1]
                local moveType = params[2]
                
                self._path_list = self._path_list or {}

                local path = self._path_list[info._key]
                if path ~= nil then
                    if table.nums(self._path_list) >= 50 then
                        return
                    end
                    if info._event_type ~= path._event_type then
                        self._path_list[path._info._key] = nil
                        path:removeFromParent(true)
                        if 10 == info._event_type then
                            return nil
                        end
                    else
                        return nil
                    end
                end

                -- local startingPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(params[3]).."_"..tonumber(params[4]))
                -- local endPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(params[5]).."_"..tonumber(params[6]))
                -- local isRebel = false
                -- local isHelpUnion = false
                -- if info._target_type == 1000 then
                --     isRebel = true
                -- elseif info._target_type == 0 then
                --     if info._event_type == 6
                --         or info._event_type == 13
                --         or info._event_type == 15
                --         or info._event_type == 18 
                --         then
                --         isHelpUnion = true
                --     end
                -- end
                -- local m_time = getWorldTwopointMovementTime(tonumber(params[3]),tonumber(params[4]),tonumber(params[5]),tonumber(params[6]), isRebel, isHelpUnion)
                local s_x = 0
                local s_y = 0
                local e_x = 0
                local e_y = 0
                local ccsx, ccsy = cc.dms_init_world_map_get(1, zstring.tonumber(params[3]), zstring.tonumber(params[4]))
                local _x = ccsx - 600
                local _y = ccsy - 1
                local ccex, ccey = cc.dms_init_world_map_get(1, zstring.tonumber(params[5]), zstring.tonumber(params[6]))
                local x_x = ccex - 600
                local y_y = ccey - 1
                
                if self.map_actual_point[""..params[3].."_"..params[4]] ~= nil then
                    s_x = tonumber(self.map_actual_point[""..params[3].."_"..params[4]][1])
                    s_y = tonumber(self.map_actual_point[""..params[3].."_"..params[4]][2])
                else
                    local size = {width = 1200000, height = 18240}
                    local sx = -1 * size.width / 2
                    local sy = -1 * size.height
                    local offx = 0
                    local offy = 0
                    offx = -(_ED.mine_tile_width/2) * _x
                    offy = (_ED.mine_tile_height/2) * (_x % 2)
                    s_x = -1 * sx + _x * _ED.mine_tile_width + offx
                    s_y = -1 * sy - _y * _ED.mine_tile_height - _ED.mine_tile_height + offy

                    self.map_actual_point[""..params[3].."_"..params[4]] = {
                        s_x,
                        s_y,
                    }
                end
                if self.map_actual_point[""..params[5].."_"..params[6]] ~= nil then
                    e_x = tonumber(self.map_actual_point[""..params[5].."_"..params[6]][1])
                    e_y = tonumber(self.map_actual_point[""..params[5].."_"..params[6]][2])
                else
                    local size = {width = 1200000, height = 18240}
                    local sx = -1 * size.width / 2
                    local sy = -1 * size.height
                    local offx = 0
                    local offy = 0
                    offx = -(_ED.mine_tile_width/2) * x_x
                    offy = (_ED.mine_tile_height/2) * (x_x % 2)
                    
                    e_x = -1 * sx + x_x * _ED.mine_tile_width + offx
                    e_y = -1 * sy - y_y * _ED.mine_tile_height - _ED.mine_tile_height + offy
                    
                    self.map_actual_point[""..params[5].."_"..params[6]] = {
                        e_x,
                        e_y,
                    }
                end

                info._s_x = s_x
                info._s_y = s_y
                info._e_x = e_x
                info._e_y = e_y

                -- 校验是否在窗口内
                local startPosition = instance.controllerLayer:convertToWorldSpaceAR(cc.p(s_x, s_y))
                local endPosition = instance.controllerLayer:convertToWorldSpaceAR(cc.p(e_x, e_y))
                startPosition.x = startPosition.x / app.scaleFactor
                startPosition.y = startPosition.y / app.scaleFactor
                endPosition.x = endPosition.x / app.scaleFactor
                endPosition.y = endPosition.y / app.scaleFactor
                local r = segmentsRect(startPosition, endPosition, cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY))
                if r == false then
                    return nil
                end
                path = instance:drawWorldAttackPath(instance.controllerLayer, info, moveType)
                return path
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--小地图刷新
		local adventure_mine_small_map_update_terminal = {
            _name = "adventure_mine_small_map_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if true then
                    return
                end
				local s_x = 0
				local s_y = 0
				local e_x = 0
				local e_y = 0
				local startingPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(_ED.world_map.position_coordinates_x).."_"..tonumber(_ED.world_map.position_coordinates_y))
				if self.map_actual_point["".._ED.world_map.position_coordinates_x.."_".._ED.world_map.position_coordinates_y] ~= nil then
					s_x = tonumber(self.map_actual_point["".._ED.world_map.position_coordinates_x.."_".._ED.world_map.position_coordinates_y][1])
					s_y = tonumber(self.map_actual_point["".._ED.world_map.position_coordinates_x.."_".._ED.world_map.position_coordinates_y][2])
				else
					if startingPoint ~= nil then
						s_x = startingPoint:getPositionX()
						s_y = startingPoint:getPositionY()
						self.map_actual_point["".._ED.world_map.position_coordinates_x.."_".._ED.world_map.position_coordinates_y] ={
							s_x,
							s_y,
						}
					end
				end
				local locationPoint = nil
				if params==nil or params == "" or params == 0 then
					if tonumber(instance.centerCellX) == 0 or tonumber(instance.centerCellY) == 0 then
						instance.centerCellX = _ED.world_map.position_coordinates_x
						instance.centerCellY = _ED.world_map.position_coordinates_y
					end
					locationPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(instance.centerCellX).."_"..tonumber(instance.centerCellY))
					if self.map_actual_point[""..instance.centerCellX.."_"..instance.centerCellY] ~= nil then
						e_x = tonumber(self.map_actual_point[""..instance.centerCellX.."_"..instance.centerCellY][1])
						e_y = tonumber(self.map_actual_point[""..instance.centerCellX.."_"..instance.centerCellY][2])
					else
						if locationPoint ~= nil then
							e_x = locationPoint:getPositionX()
							e_y = locationPoint:getPositionY()
							self.map_actual_point[""..instance.centerCellX.."_"..instance.centerCellY] ={
								e_x,
								e_y,
							}
						end
					end
				else
					locationPoint = instance.controllerLayer:getChildByName("cell_"..tonumber(params.x).."_"..tonumber(params.y))
					if self.map_actual_point[""..params.x.."_"..params.y] ~= nil then
						e_x = tonumber(self.map_actual_point[""..params.x.."_"..params.y][1])
						e_y = tonumber(self.map_actual_point[""..params.x.."_"..params.y][2])
					else
						e_x = locationPoint:getPositionX()
						e_y = locationPoint:getPositionY()
						self.map_actual_point[""..params.x.."_"..params.y] ={
							e_x,
							e_y,
						}
					end
					-- local cell = instance.controllerLayer:getChildByName("cell_"..tonumber(params.x).."_"..tonumber(params.y))
					-- if cell ~= nil and cell.info ~= nil and ( tonumber(cell.info._type) <= 5 or tonumber(cell.info._type) == 0 ) then
						_ED.world_map_focus = {params.x, params.y}
					-- end
				end
				
				state_machine.excute("red_alert_time_mine_positioning_small_update", 0, {s_x,s_y,e_x,e_y})
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		 --攻击刷新
        local adventure_mine_attack_update_terminal = {
            _name = "adventure_mine_attack_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.currentInnerContainerPosX = instance.currentInnerContainerPosX + 80
				instance.currentInnerContainerPosY = instance.currentInnerContainerPosY + 80
				instance.beginTileX = instance.beginTileX - 10
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--攻击
        local adventure_mine_attack_request_terminal = {
            _name = "adventure_mine_attack_request",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
				local function requesrAttack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- state_machine.excute("adventure_mine_force_mobile", 0, {_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,instance.attack_point_x,instance.attack_point_y})
						state_machine.excute("red_alert_time_mine_event_queue_refresh_the_interface_list", 0, 0)
						if fwin:find("redAlertTimeMineDetectResultClass") ~= nil then
							state_machine.excute("red_alert_time_mine_detect_result_close", 0, 0)
						end
						if fwin:find("redAlertTimeMineResourcePointOperationInterfaceClass") ~= nil then
							state_machine.excute("red_alert_time_mine_resource_point_operation_interface_close", 0, 0)
						end
						if fwin:find("redAlertTimeMineBaseOperationInterfaceClass") ~= nil then
							state_machine.excute("red_alert_time_mine_base_operation_interface_close", 0, 0)
						end
                        if fwin:find("MailInvestigationInfoClass") ~= nil then
                            state_machine.excute("mail_investigation_info_close", 0, 0)
                        end
                        if fwin:find("MailRebelInvestigationInfoClass") ~= nil then
                            state_machine.excute("mail_rebel_investigation_info_close", 0, 0)
                        end
                        if fwin:find("MailPresentationInfoClass") ~= nil then
                            state_machine.excute("mail_presentation_info_window_close", 0, 0)
                        end
                        if fwin:find("LegionCityInforAttackClass") ~= nil then
                            state_machine.excute("legion_city_infor_attack_window_close", 0, 0)
                        end
						state_machine.excute("formation_window_close", 0, 0)
                        TipDlg.drawTextDailog(red_alert_time_str[238])
					end
				end
				local attack_cell = params[2]
				if tonumber(attack_cell._userId) == tonumber(_ED.user_info.user_id) then
					TipDlg.drawTextDailog(tipStringInfo_consumption_info[11])
					if fwin:find("redAlertTimeMineDetectResultClass") ~= nil then
						state_machine.excute("red_alert_time_mine_detect_result_close", 0, 0)
					end
					if fwin:find("redAlertTimeMineResourcePointOperationInterfaceClass") ~= nil then
						state_machine.excute("red_alert_time_mine_resource_point_operation_interface_close", 0, 0)
					end
					if fwin:find("redAlertTimeMineBaseOperationInterfaceClass") ~= nil then
						state_machine.excute("red_alert_time_mine_base_operation_interface_close", 0, 0)
					end
					return
				end
				local m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,attack_cell._x,attack_cell._y)
				local the_number_of_war = 0
				if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
					for i, v in pairs(_ED.world_map.target_event_info) do
						if tonumber(v._event_type) < 10 
                            or (tonumber(v._event_type) >= 19 and tonumber(v._event_type) <= 23) then
							the_number_of_war = the_number_of_war + 1
						end
					end
				end
				local playTheQueue = dms.element(dms["base_consume"], 81)
				local nCount = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
				if the_number_of_war >= nCount then
					TipDlg.drawTextDailog(tipStringInfo_consumption_info[12])
					return
				end
                if zstring.tonumber(_ED.user_info.user_food) <= 0 
                    and zstring.tonumber(params[1]) ~= 19
                    then
                    TipDlg.drawTextDailog(tipStringInfo_consumption_info[28])
                    return
                end
                if attack_cell._type == 0 then
                    checkPlayEffect(45) 
                else
                    checkPlayEffect(44) 
                end
                local attack_formation = params[5]
                local formation_info = getAFormationInfo(attack_formation)
                if zstring.tonumber(params[1]) == 6 
                    or zstring.tonumber(params[1]) >= 19 
                    then
                    local shipFightNumber = 0
                    local soldierFight = ""
                    local datas = zstring.split(formation_info, "!")
                    local ship_info = zstring.split(datas[2], "|")
                    local index = 0
                    for i, v in pairs(ship_info) do
                        index = index + 1
                        local v_info = zstring.split(v, ",")
                        if tonumber(v_info[3]) ~= 0 then
                            for i,ship in pairs(_ED.user_ship) do
                                if tonumber(ship.ship_id) == tonumber(v_info[1]) then
                                    if tonumber(v_info[7]) ~= nil then
                                        shipFightNumber = shipFightNumber + getShipFightNumber(ship,tonumber(v_info[3]),_ED.user_ship[""..v_info[6]], index)
                                        if index == 1 then
                                            soldierFight = getShipFightNumber(ship,1,_ED.user_ship[""..v_info[6]], index)
                                        else
                                            soldierFight = soldierFight..","..getShipFightNumber(ship,1,_ED.user_ship[""..v_info[6]], index)
                                        end
                                    else
                                        shipFightNumber = shipFightNumber + getShipFightNumber(ship,tonumber(v_info[3]), nil, index)
                                        if index == 1 then
                                            soldierFight = getShipFightNumber(ship, 1, nil, index)
                                        else
                                            soldierFight = soldierFight..","..getShipFightNumber(ship, 1, nil, index)
                                        end
                                    end
                                end
                            end
                        else
                            if index == 1 then
                                soldierFight = "0"
                            else
                                soldierFight = soldierFight..",0"
                            end   
                        end
                    end
                    formation_info = formation_info.."!"..(math.floor(shipFightNumber)).."!"..soldierFight
                end
                if zstring.tonumber(params[4]) > 0 then
                    local max_times = dms.int(dms["rebel_haunt_config"], 9, rebel_haunt_config.param)
                    if tonumber(_ED.user_rebel_haunt_user_info.today_kill_count) == max_times then
                        TipDlg.drawTextDailog(tipStringInfo_campaign_info[51])
                        return
                    end
                    protocol_command.world_add_target_event.param_list = zstring.tonumber(params[1]) .. "\r\n" ..attack_cell._x.."\r\n" ..attack_cell._y.."\r\n"..m_times.."\r\n0".."\r\n"..formation_info.."\r\n"..zstring.tonumber(params[3]).."\r\n"..zstring.tonumber(params[4])
                else
                    protocol_command.world_add_target_event.param_list = zstring.tonumber(params[1]) .. "\r\n" ..attack_cell._x.."\r\n" ..attack_cell._y.."\r\n"..m_times.."\r\n0".."\r\n"..formation_info.."\r\n"..zstring.tonumber(params[3])
                end
				
				--print("protocol_command.world_add_target_event.param_list =="..protocol_command.world_add_target_event.param_list )
                NetworkManager:register(protocol_command.world_add_target_event.code, nil, nil, nil, nil, requesrAttack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--保护罩时间结束校验时间
        local adventure_mine_update_cover_terminal = {
            _name = "adventure_mine_update_cover",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- local cell = params._datas.cells
				--当前状态没改变，但是时间到了需要校验
				local function requesrUpdateCoverCheck(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_mine_update_map_draw", 0, 0)
					end
				end
				NetworkManager:register(protocol_command.gain_limit_check.code, nil, nil, nil, nil, requesrUpdateCoverCheck, false, nil)	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--播放动画前获取cell
        local adventure_mine_get_cells_obj_terminal = {
            _name = "adventure_mine_get_cells_obj",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print(cells,self.roots)
				local cells = instance.controllerLayer:getChildByName("cell_"..tonumber(params[1]).."_"..tonumber(params[2]))
				if cells ~= nil and cells.roots ~= nil then
					cells:was_hit_animation()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新玩家基地
        local adventure_mine_update_user_city_terminal = {
            _name = "adventure_mine_update_user_city",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.world_map ~= nil and _ED.world_map.position_coordinates_x ~= nil and _ED.world_map.position_coordinates_y ~= nil then
                    local cells = instance.controllerLayer:getChildByName("cell_".._ED.world_map.position_coordinates_x.."_".._ED.world_map.position_coordinates_y)
                    if cells ~= nil and cells.roots ~= nil then
                        cells:updateMapTileEx()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 资源清理
        local adventure_mine_clear_terminal = {
            _name = "adventure_mine_clear",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i, v in pairs(instance.used_map) do
                    v:unload()
                    -- v:removeFromParent(true)
                    table.insert(instance.free_map, v)
                    instance.used_map[i] = nil
                end
                if instance._path_list ~= nil then
                    for i, v in pairs(instance._path_list) do
                        if v ~= nil and v:getParent() ~= nil then
                            v:removeFromParent(true)
                        end
                    end
                end
                instance._path_list = {}
                if instance._enemyBossRoadPaths ~= nil 
                    and table.nums(instance._enemyBossRoadPaths) > 0 
                    then
                    for k,v in pairs(instance._enemyBossRoadPaths) do
                        if v ~= nil and v:getParent() ~= nil then
                            v:removeFromParent(true)
                        end
                    end
                    instance._enemyBossRoadPaths = {}
                end
                if instance._enemyUserPath ~= nil then
                    instance._enemyUserPath:removeFromParent(true)
                    instance._enemyUserPath = nil
                end
                _ED.enemyBossRoadPathInfo = {}
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_mine_enemy_boss_change_state_terminal = {
            _name = "adventure_mine_enemy_boss_change_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.enemyBossRoadPathInfo == nil or table.nums(_ED.enemyBossRoadPathInfo) == 0 then
                    local end_info = zstring.split(zstring.split(dms.string(dms["enemy_boss_config"], 14, enemy_boss_config.param), "|")[1], ",")
                    local end_pos_x = tonumber(end_info[1])
                    local end_pos_y = tonumber(end_info[2])
                    local s_x, s_y, e_x, e_y = 0, 0, 0, 0

                    local ccex, ccey = cc.dms_init_world_map_get(1, zstring.tonumber(end_pos_x), zstring.tonumber(end_pos_y))
                    local x_x = ccex - 600
                    local y_y = ccey - 1
                    
                    if instance.map_actual_point[""..end_pos_x.."_"..end_pos_y] ~= nil then
                        e_x = tonumber(instance.map_actual_point[""..end_pos_x.."_"..end_pos_y][1])
                        e_y = tonumber(instance.map_actual_point[""..end_pos_x.."_"..end_pos_y][2])
                    else
                        local size = {width = 1200000, height = 18240}
                        local sx = -1 * size.width / 2
                        local sy = -1 * size.height
                        local offx = 0
                        local offy = 0
                        offx = -(_ED.mine_tile_width/2) * x_x
                        offy = (_ED.mine_tile_height/2) * (x_x % 2)
                        
                        e_x = -1 * sx + x_x * _ED.mine_tile_width + offx
                        e_y = -1 * sy - y_y * _ED.mine_tile_height - _ED.mine_tile_height + offy
                        
                        instance.map_actual_point[""..end_pos_x.."_"..end_pos_y] = {e_x, e_y}
                    end
                    for i=1,15 do
                        s_x, s_y = 0, 0
                        local baseX, baseY = math.random(122, 322), math.random(122, 322)
                        local ccsx, ccsy = cc.dms_init_world_map_get(1, zstring.tonumber(baseX), zstring.tonumber(baseY))
                        local _x = ccsx - 600
                        local _y = ccsy - 1
                        if instance.map_actual_point[""..baseX.."_"..baseY] ~= nil then
                            s_x = tonumber(instance.map_actual_point[""..baseX.."_"..baseY][1])
                            s_y = tonumber(instance.map_actual_point[""..baseX.."_"..baseY][2])
                        else
                            local size = {width = 1200000, height = 18240}
                            local sx = -1 * size.width / 2
                            local sy = -1 * size.height
                            local offx = 0
                            local offy = 0
                            offx = -(_ED.mine_tile_width/2) * _x
                            offy = (_ED.mine_tile_height/2) * (_x % 2)
                            s_x = -1 * sx + _x * _ED.mine_tile_width + offx
                            s_y = -1 * sy - _y * _ED.mine_tile_height - _ED.mine_tile_height + offy

                            instance.map_actual_point[""..baseX.."_"..baseY] = {s_x, s_y}
                        end
                        local info = {_s_x = s_x, _s_y = s_y, _e_x = e_x, _e_y = e_y}
                        _ED.enemyBossRoadPathInfo[""..s_x.."-"..s_y] = info
                    end
                end
                local isOpen = false
                if _ED.mould_function_push_info["4"] ~= nil 
                    and zstring.tonumber(_ED.mould_function_push_info["4"].state) == 1
                    then
                    isOpen = true
                end
                if _ED.user_enemy_strike_boss_info ~= nil 
                    and zstring.tonumber(_ED.user_enemy_strike_boss_info.state) == 1
                    then
                    isOpen = true
                end
                -- isOpen = true
                if isOpen == false then
                    if table.nums(instance._enemyBossRoadPaths) > 0 then
                        for k,v in pairs(instance._enemyBossRoadPaths) do
                            if v ~= nil and v:getParent() ~= nil then
                                v:removeFromParent(true)
                            end
                        end
                        instance._enemyBossRoadPaths = {}
                    end
                    if instance._enemyUserPath ~= nil then
                        instance._enemyUserPath:removeFromParent(true)
                        instance._enemyUserPath = nil
                    end
                    _ED.enemyBossRoadPathInfo = {}
                elseif table.nums(instance._enemyBossRoadPaths) == 0 then
                    for k,v in pairs(_ED.enemyBossRoadPathInfo) do
                        local startPosition = instance.controllerLayer:convertToWorldSpaceAR(cc.p(v._s_x, v._s_y))
                        local endPosition = instance.controllerLayer:convertToWorldSpaceAR(cc.p(v._e_x, v._e_y))
                        startPosition.x = startPosition.x / app.scaleFactor
                        startPosition.y = startPosition.y / app.scaleFactor
                        endPosition.x = endPosition.x / app.scaleFactor
                        endPosition.y = endPosition.y / app.scaleFactor
                        local r = segmentsRect(startPosition, endPosition, cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY))
                        if r == false then
                        else
                            local path = instance:createEnemyBossTankRoadPath(instance.controllerLayer, v._s_x, v._s_y, v._e_x, v._e_y, 1, 0, v)
                            path._info = v
                            instance._enemyBossRoadPaths[""..k] = path
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_mine_enemy_boss_user_path_terminal = {
            _name = "adventure_mine_enemy_boss_user_path",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local state = params[1]         -- 0：移除路径，1：创建路径
                if instance._enemyUserPath ~= nil then
                    instance._enemyUserPath:removeFromParent(true)
                    instance._enemyUserPath = nil
                end
                if _ED.user_enemy_strike_boss_info ~= nil 
                    and _ED.user_enemy_strike_boss_info.state == 0 
                    then
                elseif state == 1 then
                    local end_info = zstring.split(zstring.split(dms.string(dms["enemy_boss_config"], 14, enemy_boss_config.param), "|")[1], ",")
                    local end_pos_x = tonumber(end_info[1])
                    local end_pos_y = tonumber(end_info[2])
                    local s_x, s_y, e_x, e_y = 0, 0, 0, 0

                    local ccex, ccey = cc.dms_init_world_map_get(1, zstring.tonumber(end_pos_x), zstring.tonumber(end_pos_y))
                    local x_x = ccex - 600
                    local y_y = ccey - 1
                    
                    if instance.map_actual_point[""..end_pos_x.."_"..end_pos_y] ~= nil then
                        e_x = tonumber(instance.map_actual_point[""..end_pos_x.."_"..end_pos_y][1])
                        e_y = tonumber(instance.map_actual_point[""..end_pos_x.."_"..end_pos_y][2])
                    else
                        local size = {width = 1200000, height = 18240}
                        local sx = -1 * size.width / 2
                        local sy = -1 * size.height
                        local offx = 0
                        local offy = 0
                        offx = -(_ED.mine_tile_width/2) * x_x
                        offy = (_ED.mine_tile_height/2) * (x_x % 2)
                        
                        e_x = -1 * sx + x_x * _ED.mine_tile_width + offx
                        e_y = -1 * sy - y_y * _ED.mine_tile_height - _ED.mine_tile_height + offy
                        
                        instance.map_actual_point[""..end_pos_x.."_"..end_pos_y] = {e_x, e_y}
                    end

                    s_x, s_y = 0, 0
                    local baseX, baseY = _ED.world_map.position_coordinates_x, _ED.world_map.position_coordinates_y
                    local ccsx, ccsy = cc.dms_init_world_map_get(1, zstring.tonumber(baseX), zstring.tonumber(baseY))
                    local _x = ccsx - 600
                    local _y = ccsy - 1
                    if instance.map_actual_point[""..baseX.."_"..baseY] ~= nil then
                        s_x = tonumber(instance.map_actual_point[""..baseX.."_"..baseY][1])
                        s_y = tonumber(instance.map_actual_point[""..baseX.."_"..baseY][2])
                    else
                        local size = {width = 1200000, height = 18240}
                        local sx = -1 * size.width / 2
                        local sy = -1 * size.height
                        local offx = 0
                        local offy = 0
                        offx = -(_ED.mine_tile_width/2) * _x
                        offy = (_ED.mine_tile_height/2) * (_x % 2)
                        s_x = -1 * sx + _x * _ED.mine_tile_width + offx
                        s_y = -1 * sy - _y * _ED.mine_tile_height - _ED.mine_tile_height + offy

                        instance.map_actual_point[""..baseX.."_"..baseY] = {s_x, s_y}
                    end
                    local path = instance:createEnemyBossTankRoadPath(instance.controllerLayer, s_x, s_y, e_x, e_y, 1, 1)
                    instance._enemyUserPath = path
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mine_change_ed_data_terminal)
        state_machine.add(adventure_mine_exploit_open_success_terminal)
        state_machine.add(adventure_mine_reset_update_draw_terminal)
        state_machine.add(adventure_mine_reset_add_draw_terminal)
        state_machine.add(adventure_mine_reset_update_draw_basics_terminal)
        state_machine.add(adventure_mine_battle_victory_update_terminal)
        state_machine.add(adventure_mine_reset_boss_update_draw_terminal)
        state_machine.add(adventure_mine_location_boss_terminal)
        state_machine.add(adventure_mine_cell_exploit_terminal)
        
        state_machine.add(adventure_mine_boss_bubble_draw_terminal)
        state_machine.add(adventure_mine_record_view_position_terminal)
        state_machine.add(adventure_mine_update_view_position_terminal)
        state_machine.add(adventure_mine_update_map_draw_terminal)
        state_machine.add(adventure_mine_cell_focus_blink_terminal)
        state_machine.add(adventure_mine_draw_army_info_terminal)
        state_machine.add(adventure_mine_force_mobile_terminal)
        state_machine.add(adventure_mine_create_road_path_terminal)
        state_machine.add(adventure_mine_world_all_attack_event_path_info_terminal)
        state_machine.add(adventure_mine_attack_update_terminal)
        state_machine.add(adventure_mine_attack_request_terminal)
        state_machine.add(adventure_mine_small_map_update_terminal)
		state_machine.add(adventure_mine_update_cover_terminal)
		state_machine.add(adventure_mine_get_cells_obj_terminal)
        state_machine.add(adventure_mine_update_user_city_terminal)
        state_machine.add(adventure_mine_clear_terminal)
        state_machine.add(adventure_mine_enemy_boss_change_state_terminal)
        state_machine.add(adventure_mine_enemy_boss_user_path_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mine state machine.
    init_adventure_mine_terminal()

    state_machine.lock("adventure_mine_world_all_attack_event_path_info")
end

function AdventureMine:init()
    -- cc.UserDefault:getInstance():setStringForKey(getKey("mine_data"), "")
    -- cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_anchor"), "")
    -- cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_scale"), "")
    -- cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_coord"), "")
    self:onInit()
    -- self:initMineData()
    return self
end

function AdventureMine:initMineTiles()
    
end

function AdventureMine:drawWorldAttackPath(controllerLayer, info, moveType)
    local path = nil
    --0攻击移动，1回城移动，2攻击，3加速返回，4请求撤离，5驻守状态，6协防移动，7协防中，8打玩家移动，9校验
    local local_time = (tonumber(info._start_time)/1000+tonumber(info._complete_time))-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
    if tonumber(info._event_type) == 0 or tonumber(info._event_type) == 6 or tonumber(info._event_type) == 8 or tonumber(info._event_type) == 19 then
        path = self:createTankRoadPath(controllerLayer,info._s_x,info._s_y,info._e_x,info._e_y,tonumber(info._complete_time),local_time,info,moveType,true)
    elseif tonumber(info._event_type) == 1 or tonumber(info._event_type) == 18 or tonumber(info._event_type) == 23 then
        path = self:createTankRoadPath(controllerLayer,info._s_x,info._s_y,info._e_x,info._e_y,tonumber(info._complete_time),local_time,info,moveType,false)
    elseif tonumber(info._event_type) == 11 then
        path = self:createTankRoadPath(controllerLayer,info._s_x,info._s_y,info._e_x,info._e_y,tonumber(info._complete_time),local_time,info,moveType,true)
    end
    if path == nil then
        return
    end
    self._path_list[info._key] = path
    
    if local_time < 0 then
        local_time = 1.5
    end

    path:runAction(cc.Sequence:create(cc.DelayTime:create(local_time), cc.CallFunc:create(function( sender )
        local eventType = sender._info._event_type
        protocol_command.refresh_world_target_event.param_list = sender._info._key

        if _ED.world_map ~= nil and _ED.world_map.all_target_event_info ~= nil then
            _ED.world_map.all_target_event_info[sender._info._key] = nil
        end

        sender._map._path_list[sender._info._key] = nil

        sender:removeFromParent(true)
        
        if 10 ~= eventType then
            NetworkManager:register(protocol_command.refresh_world_target_event.code, nil, nil, nil, nil, nil, false, nil)
        end
    end)))

    path._map = self
    path._info = info
    path._event_type = info._event_type
    return path
end

function AdventureMine:createTankRoadPath(map, sx, sy, dx, dy, m_time, m_stime, info, moveType,isover)
    app.load("client.red_alert.battle.battle_macros")
    local s = math.sqrt((dx - sx) * (dx - sx) + (dy - sy) *(dy - sy))
    local parent = cc.Node:create()
    map:addChild(parent, 900001)

    local layerbg = ccui.Layout:create()
    layerbg:setAnchorPoint(cc.p(0, 0.5))
    layerbg:setContentSize(cc.size(s, 16))

    local layer = cc.Node:create()
    layer:setAnchorPoint(cc.p(0, 0))
    layer:setPositionY(8)
    layer:setContentSize(cc.size(s, 16))

    local arrow_type = 1
    if tonumber(info._user_info) == tonumber(_ED.user_info.user_id) then
        if tonumber(info._event_type) == 11 then
            arrow_type = 2
        else
            arrow_type = 1
        end
    else
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            arrow_type = 4
        else
            if tonumber(info._attack_union_id) == tonumber(_ED.union.union_info.union_id) then
                arrow_type = 3
            elseif tonumber(info._beAttack_union_id) == tonumber(_ED.union.union_info.union_id) then
                arrow_type = 2
            else
                arrow_type = 4
            end
        end
    end

    local nCount = s / 1020 + 3
    local mx = -1020
    for i = 1, nCount do
        local arrow = cc.Sprite:create(config_res.images.ui.share.world_locking_arrow_route[arrow_type])
        layer:addChild(arrow)

        arrow:setPositionX(mx)
        arrow._mx = mx
        mx = mx + 1020
    end
    layer:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(12, 8)), cc.CallFunc:create(function ( sender ) sender:setPositionX(0) end))))
    layerbg:addChild(layer)
    layerbg:setClippingEnabled(true)

    local angle = CC_POSITIONS_TO_DEGREES(cc.p(sx, sy), cc.p(dx, dy))
    layerbg:setRotation(angle - 90)
    layerbg:setPosition(cc.p(sx, sy))
    parent:addChild(layerbg,100)

    local at = angle
    if at < 0 then
        at = at - 7.5
    else
        at = at + 7.5
    end

    local actionIndex = math.modf(at / (360.0 / 16.0))
    if actionIndex <= 0 then
        -- actionIndex = -1 * actionIndex + 13
        actionIndex = 8 + actionIndex + 8
    end
    if actionIndex > 15 then
        actionIndex = 0
    end

    local attack_time = 0
    if tonumber(info._event_type) == 0 
        or tonumber(info._event_type) == 8 
        or tonumber(info._event_type) == 11 
        or tonumber(info._event_type) == 19 
        then
        attack_time = 6
    end

    -- local tank = cc.Sprite:create("images/ui/world_route_tank/world_route_tank_".. actionIndex .. ".png")
    -- parent:addChild(tank, 100)

    local tank = self:createSprite(parent, actionIndex, 0)
    -- if angle~= 0 and angle~= 90 and angle~= 180 and angle~= 270 and andle~=360 then
    --     if angle < 0 then
    --         tank:setRotation(7.5)
    --     else
    --         tank:setRotation(-7.5)
    --     end    
    -- end

    tank.m_time = m_time
    tank.m_stime = m_stime
    tank.dx = dx
    tank.dy = dy

    local function moveEndCallBack(sender)
        if _ED.world_map.world_map_info_list ~= nil then
            local info1 = _ED.world_map.world_map_info_list[info._dx .. "," .. info._dy]
            if info1 == nil or (info1._type < 0 or (info1._type > 5 and info1._type < 1000)) then
                isover = false
            end
        end
        if isover == true then
            if __lua_project_id == __lua_project_red_alert_time then
                sender._nextAction = _enum_spine_tank_frame_index.animation_attack-1
            else
                local baseAnimationCount = 0
                local ta_x, ta_y = cc.dms_init_world_map_get(1, info._dx, info._dy)
                ta_x, ta_y = cc.dms_init_world_map_get(2, ta_x, ta_y)
                if ta_x > 0 and ta_y > 0 then
                    local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
                    if zstring.tonumber(pic_index) == 0 then
                        baseAnimationCount = 4
                    else
                        baseAnimationCount = 0
                    end
                end
                local angel = CC_POSITIONS_TO_DEGREES(cc.p(sx, sy), cc.p(dx, dy)) - 90
                if angel > 0 and angel <= 90 then
                    sender._nextAction = _enum_spine_tank_frame_index.animation_attack1
                elseif angel > 90 and angel <= 180 then
                    sender._nextAction = _enum_spine_tank_frame_index.animation_attack4
                elseif angel <= 0 and angel > -90 then
                    sender._nextAction = _enum_spine_tank_frame_index.animation_attack2
                else
                    sender._nextAction = _enum_spine_tank_frame_index.animation_attack3
                end
                sender._nextAction = sender._nextAction + baseAnimationCount - 1
                sender:getAnimation():playWithIndex(sender._nextAction)
            end
        end
    end

    tank._path_layer = layerbg
    tank._parent = parent
    tank:setPosition(cc.p(sx + (dx - sx)*((m_time - m_stime) / m_time), sy + (dy - sy)*((m_time - m_stime) / m_time)))

    if m_stime - attack_time > 0 then
        tank:runAction(cc.Sequence:create(cc.MoveTo:create(m_stime - attack_time, cc.p(dx, dy)), cc.CallFunc:create(moveEndCallBack)))
    else
        tank:setPosition(cc.p(dx, dy))
        moveEndCallBack(tank)
    end

    local targetArrow = cc.Sprite:create("images/ui/share/world_locking_position.png")
    targetArrow:setPosition(cc.p(dx, dy))
    targetArrow:runAction(
        cc.RepeatForever:create(
            cc.Sequence:create(
                cc.EaseSineOut:create(cc.MoveBy:create(0.8, cc.p(0, 30))), 
                cc.EaseSineOut:create(cc.MoveBy:create(0.8, cc.p(0, -30)))
            )
        )
    )
    if isover == true then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_world_attack)
        local targetArrow = ccs.Armature:create("effect_world_attack")
        targetArrow:getAnimation():playWithIndex(0)
        targetArrow:setPosition(cc.p(dx, dy))
        parent:addChild(targetArrow, 100)
        tank._target_arrow = targetArrow
    end
    return parent
end

function AdventureMine:createEnemyBossTankRoadPath(map, sx, sy, dx, dy, m_time, path_type, info)
    app.load("client.red_alert.battle.battle_macros")
    local s = math.sqrt((dx - sx) * (dx - sx) + (dy - sy) *(dy - sy))
    local parent = cc.Node:create()
    map:addChild(parent, 900001)

    local layerbg = ccui.Layout:create()
    layerbg:setAnchorPoint(cc.p(0, 0.5))
    layerbg:setContentSize(cc.size(s, 16))

    local layer = cc.Node:create()
    layer:setAnchorPoint(cc.p(0, 0))
    layer:setPositionY(8)
    layer:setContentSize(cc.size(s, 16))

    local nCount = s / 1020 + 3
    local mx = -1020
    for i = 1, nCount do
        local arrow = nil
        if arrow == nil then
            if zstring.tonumber(path_type) == 0 then
                --其他路径
                arrow = cc.Sprite:create(config_res.images.ui.share.world_locking_arrow_route[4])
            else
                --玩家路径
                arrow = cc.Sprite:create(config_res.images.ui.share.world_locking_arrow_route[1])
            end
        end
        layer:addChild(arrow)

        arrow:setPositionX(mx)
        arrow._mx = mx
        mx = mx + 1020
    end

    layer:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(12, 8)), cc.CallFunc:create(function ( sender ) sender:setPositionX(0) end))))
    layerbg:addChild(layer)
    layerbg:setClippingEnabled(true)

    local angle = CC_POSITIONS_TO_DEGREES(cc.p(sx, sy), cc.p(dx, dy))
    layerbg:setRotation(angle - 90)
    layerbg:setPosition(cc.p(sx, sy))
    parent:addChild(layerbg,100)

    local at = angle
    if at < 0 then
        at = at - 7.5
    else
        at = at + 7.5
    end

    local actionIndex = math.modf(at / (360.0 / 16.0))
    if actionIndex <= 0 then
        actionIndex = 8 + actionIndex + 8
    end
    if actionIndex > 15 then
        actionIndex = 0
    end

    local tank = self:createSprite(parent, actionIndex, 0)

    tank.m_time = m_time
    tank.sx = sx
    tank.sy = sy
    tank.dx = dx
    tank.dy = dy

    local function moveEndCallBack(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            sender:setPosition(cc.p(sender.sx, sender.sy))
            if path_type == 1 then      -- 玩家路径
                state_machine.excute("adventure_mine_enemy_boss_user_path", 0, {0})
            end
        end
    end

    local function playActionCallBack(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local baseAnimationCount = 0
            -- local ta_x, ta_y = cc.dms_init_world_map_get(1, dx, dy)
            -- ta_x, ta_y = cc.dms_init_world_map_get(2, ta_x, ta_y)
            -- if ta_x > 0 and ta_y > 0 then
            --     local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
            --     if zstring.tonumber(pic_index) == 0 then
            --         baseAnimationCount = 4
            --     else
            --         baseAnimationCount = 0
            --     end
            -- end
            local angel = CC_POSITIONS_TO_DEGREES(cc.p(sx, sy), cc.p(dx, dy)) - 90
            if angel > 0 and angel <= 90 then
                sender._nextAction = _enum_spine_tank_frame_index.animation_attack1
            elseif angel > 90 and angel <= 180 then
                sender._nextAction = _enum_spine_tank_frame_index.animation_attack4
            elseif angel <= 0 and angel > -90 then
                sender._nextAction = _enum_spine_tank_frame_index.animation_attack2
            else
                sender._nextAction = _enum_spine_tank_frame_index.animation_attack3
            end
            sender:getAnimation():playWithIndex(sender._nextAction + baseAnimationCount - 1)
        end
    end

    tank._path_layer = layerbg
    tank._parent = parent
    tank:setPosition(cc.p(sx, sy))
    local time = s / 200
    if path_type == 1 then
        local time_info = zstring.split(dms.string(dms["enemy_boss_config"], 2, enemy_boss_config.param), ",")
        time = _ED.user_enemy_strike_info.once_attack_cd/1000 + tonumber(time_info[1]) - (os.time() + _ED.time_add_or_sub)
        if __lua_project_id == __lua_project_pacific_rim then
            if time >= 5 then
                tank:runAction(cc.Sequence:create(cc.MoveTo:create(time - 5, cc.p(dx, dy)), cc.CallFunc:create(playActionCallBack), cc.DelayTime:create(5), cc.CallFunc:create(moveEndCallBack)))
            else
                tank:runAction(cc.Sequence:create(cc.MoveTo:create(time, cc.p(dx, dy)), cc.CallFunc:create(moveEndCallBack)))
            end
        else
            tank:runAction(cc.Sequence:create(cc.MoveTo:create(time, cc.p(dx, dy)), cc.CallFunc:create(moveEndCallBack)))
        end
    else
        tank:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(time, cc.p(dx, dy)), cc.CallFunc:create(moveEndCallBack))))
    end
    return parent
end

function AdventureMine:createPathTexture(map, sx, sy, dx, dy, m_time, m_stime, info, moveType,isover)
    app.load("client.red_alert.battle.battle_macros")
    local s = math.sqrt((dx - sx) * (dx - sx) + (dy - sy) *(dy - sy))
	local parent = cc.Node:create()
	map:addChild(parent, 900001)

    local layerbg = ccui.Layout:create()
    layerbg:setAnchorPoint(cc.p(0, 0.5))
    layerbg:setContentSize(cc.size(s, 16))

    local layer = cc.Node:create()
    layer:setAnchorPoint(cc.p(0, 0))
    layer:setPositionY(8)
    layer:setContentSize(cc.size(s, 16))

    local arrow_type = 1
    if tonumber(info._user_info) == tonumber(_ED.user_info.user_id) then
        if tonumber(info._event_type) == 11 then
            arrow_type = 2
        else
            arrow_type = 1
        end
    else
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            arrow_type = 4
        else
            if tonumber(info._attack_union_id) == tonumber(_ED.union.union_info.union_id) then
                arrow_type = 3
            elseif tonumber(info._beAttack_union_id) == tonumber(_ED.union.union_info.union_id) then
                arrow_type = 2
            else
                arrow_type = 4
            end
        end
    end

    local nCount = s / 12 + 2
    local mx = -12
    for i = 1, nCount do
		local arrow = cc.Sprite:create(config_res.images.ui.share.world_locking_arrow_route[arrow_type])
        layer:addChild(arrow)

        arrow:setPositionX(mx)
        arrow._mx = mx
        mx = mx + 12
    end
    layer:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(12, 8)), cc.CallFunc:create(function ( sender ) sender:setPositionX(0) end))))
    layerbg:addChild(layer)
    layerbg:setClippingEnabled(true)

    local angle = CC_POSITIONS_TO_DEGREES(cc.p(sx, sy), cc.p(dx, dy))
    layerbg:setRotation(angle - 90)
    layerbg:setPosition(cc.p(sx, sy))
    parent:addChild(layerbg,100)


    local at = angle
    if at < 0 then
        at = at - 7.5
    else
        at = at + 7.5
    end

    local actionIndex = math.modf(at / (360.0 / 16.0))
    if actionIndex <= 0 then
        -- actionIndex = -1 * actionIndex + 13
        actionIndex = 8 + actionIndex + 8
    end
	if actionIndex > 15 then
		actionIndex = 0
	end

    local matX = math.abs(dx - sx)
    local matY = math.abs(dy - sy)
    local xx = s/matX
    local yy = s/matY

    --出生的时间固定值 
    --出生的距离固定值
    --算出出生后的x，y
    --起始点的x，y
    --结束点的x，y
    --知道角度
    --总距离
    --三角函数
    --先得到出生时间可到达的位置x，y
    local Positi = 50
    local born_x1 = Positi/xx
    local born_y1 = Positi/yy

    if dx - sx > 0 then
        born_x1 = sx + born_x1
    else
        born_x1 = sx - born_x1
    end
    if dy - sy > 0 then
        born_y1 = sy + born_y1
    else
        born_y1 = sy - born_y1
    end

    local born_s = 190
    local born_time = 15

    born_x = born_s/xx
    born_y = born_s/yy
    -- local born_x = born_s*math.cos(math.rad(angle%45))
    -- local born_y = born_s*math.sin(math.rad(angle%45))
    if dx - sx > 0 then
        born_x = sx + born_x
    else
        born_x = sx - born_x
    end
    if dy - sy > 0 then
        born_y = sy + born_y
    else
        born_y = sy - born_y
    end

    local attack_time = 6

    if tonumber(info._event_type) == 6 then
        attack_time = -10000
    end
    -- local tank = cc.Sprite:create("images/ui/world_route_tank/world_route_tank_".. actionIndex .. ".png")
    -- parent:addChild(tank,100)
    local tank = nil
    tank = self:createSprite(parent,actionIndex,0)
    -- if angle~= 0 and angle~= 90 and angle~= 180 and angle~= 270 and andle~=360 then
    --     if angle < 0 then
    --         tank:setRotation(7.5)
    --     else
    --         tank:setRotation(-7.5)
    --     end    
    -- end
    tank.m_time = m_time
    tank.m_stime = m_stime
    tank.dx = dx
    tank.dy = dy
    -- tank._nextAction = actionIndex * 2
    function blinkInCallback1()
        csb.animationChangeToAction(tank, actionIndex * 2 + 1, actionIndex * 2 + 1, false)
    end 
    function blinkOutCallback3(sender)
        if _ED.world_map.world_map_info_list ~= nil then
            local info = _ED.world_map.world_map_info_list[info._dx .. "," .. info._dy]
            if info == nil or (info._type < 0 or (info._type > 5 and info._type < 1000)) then
                isover = false
            end
        end
        if isover == true then
            sender._nextAction = _enum_spine_tank_frame_index.animation_attack-1
        else
            -- sender._parent:removeFromParent(true)
            -- sender._cells._path = nil
        end
    end
    function blinkOutCallback4(sender)
        -- sender._parent:removeFromParent(true)
        -- sender._cells._path = nil
    end
    if math.floor(m_time) - math.floor(m_stime) <= 1 then
        tank:setPosition(cc.p(sx + (dx - sx)*((m_time - m_stime) / m_time), sy + (dy - sy)*((m_time - m_stime) / m_time)))

        if s < born_s then
            tank:runAction(cc.Sequence:create(
                            cc.MoveTo:create(0, cc.p(born_x1, born_y1)),
                            cc.MoveTo:create((born_time), cc.p(born_x, born_y)),
                            -- cc.CallFunc:create(blinkInCallback1),
                            cc.MoveTo:create((m_time - born_time - attack_time), cc.p(born_x, born_y)),
                            cc.CallFunc:create(blinkOutCallback3)
                            ))
        else
            tank:runAction(cc.Sequence:create(
                            cc.MoveTo:create(0, cc.p(born_x1, born_y1)),
                            cc.MoveTo:create((born_time), cc.p(born_x, born_y)),
                            -- cc.CallFunc:create(blinkInCallback1),
                            cc.MoveTo:create((m_time - born_time - attack_time), cc.p(dx, dy)),
                            cc.CallFunc:create(blinkOutCallback3)
                            ))
        end
    else
        if m_time - m_stime >  born_time then     --大于出生时间
            blinkInCallback1()
            tank:setPosition(cc.p(sx + (dx - sx)*((m_time - m_stime) / m_time), sy + (dy - sy)*((m_time - m_stime) / m_time)))
            tank:runAction(cc.Sequence:create(
                        cc.MoveTo:create((m_time - (m_time - m_stime) - attack_time), cc.p(dx, dy)),
                        cc.CallFunc:create(blinkOutCallback3)
                        ))
        elseif m_time - m_stime < born_time then  --小于出生时间
            blinkInCallback1()
            tank:setPosition(cc.p(born_x, born_y))
            tank:runAction(cc.Sequence:create(
                        cc.MoveTo:create((m_time - born_time - attack_time), cc.p(dx, dy)),
                        cc.CallFunc:create(blinkOutCallback3)
                        ))
        elseif m_stime == m_time - born_time then  --等于出生时间
            blinkInCallback1()
            tank:setPosition(cc.p(born_x, born_y))
            tank:runAction(cc.Sequence:create(
                        cc.MoveTo:create((m_time - born_time - attack_time), cc.p(dx, dy)),
                        cc.CallFunc:create(blinkOutCallback3)
                        ))
        elseif m_time - born_time - m_stime < attack_time then  --小于攻击时间
            tank:setPosition(cc.p(dx, dy))
            blinkOutCallback4(tank)
        elseif m_time - born_time - m_stime > attack_time then  --大于攻击时间
            blinkInCallback1()
            tank:setPosition(cc.p(sx + (dx - sx)*((m_time - m_stime) / m_time), sy + (dy - sy)*((m_time - m_stime) / m_time)))
            tank:runAction(cc.Sequence:create(
                        cc.MoveTo:create((m_time - born_time - attack_time), cc.p(dx, dy)),
                        cc.CallFunc:create(blinkOutCallback3)
                        ))
        elseif m_time - born_time - m_stime == attack_time then  --等于攻击时间   
            tank:setPosition(cc.p(dx, dy))
            blinkOutCallback3(tank)
        else
            blinkInCallback1()
            tank:setPosition(cc.p(sx + (dx - sx)*((m_time - m_stime) / m_time), sy + (dy - sy)*((m_time - m_stime) / m_time)))
            tank:runAction(cc.Sequence:create(
                        cc.MoveTo:create((m_time - born_time - attack_time), cc.p(dx, dy)),
                        cc.CallFunc:create(blinkOutCallback3)
                        ))
        end    
    end    

    -- tank:setPosition(cc.p(sx + (dx - sx)*((m_time - m_stime) / m_time), sy + (dy - sy)*((m_time - m_stime) / m_time)))
    

    

    -- tank:runAction(cc.Sequence:create(cc.MoveTo:create(m_time, cc.p(dx, dy)), cc.CallFunc:create(function (sender)
    --     --sender._path_layer:removeFromParent(true)
    --     -- sender._target_arrow:removeFromParent(true)
    --     -- sender:removeFromParent(true)
    --     tank._parent:removeFromParent(true)
    --     cells._path = nil
    -- end)))
    tank._path_layer = layerbg
	tank._parent = parent
    -- local targetArrow = cc.Sprite:create("images/ui/share/world_locking_position.png")
    -- targetArrow:setPosition(cc.p(dx, dy))
    -- targetArrow:runAction(
    --         cc.RepeatForever:create(
    --                 cc.Sequence:create(
    --                         cc.EaseSineOut:create(cc.MoveBy:create(0.8, cc.p(0, 30))), 
    --                         cc.EaseSineOut:create(cc.MoveBy:create(0.8, cc.p(0, -30)))
    --                     )
    --             )
    --     )
    if isover == true then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_world_attack)
        local targetArrow = ccs.Armature:create("effect_world_attack")
        targetArrow:getAnimation():playWithIndex(0)
        targetArrow:setPosition(cc.p(dx, dy))
        parent:addChild(targetArrow,100)
        tank._target_arrow = targetArrow
    end
	return parent
end

function AdventureMine:createSprite(parent,index,diff)
    -- 创建精灵绘图 sprite = skeletonNode
    local jsonFile = "sprite/spirte_attack.json"
    local atlasFile = "sprite/spirte_attack.atlas"

    local armature = sp.spine(jsonFile, atlasFile, 1, 0, nil, true, nil)
    -- armature:addAnimation(0, _spine_tank_animation_names[2], true)
    armature.animationNameList = _spine_tank_animation_names
    sp.initArmature(armature, true)  
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature._invoke = nil
    armature:setTag(999)
    parent:addChild(armature,100)
    local actionIndex = 0  
    if diff == 1 then
        actionIndex = index * 2 + 1
    else
        actionIndex = index * 2
    end
    csb.animationChangeToAction(armature, actionIndex, actionIndex, true)
    armature._invoke = function ( armatureBase )
        if nil ~= armatureBase then
            local actionIndex = armatureBase._actionIndex % 2
            if armatureBase._actionIndex >= _enum_spine_tank_frame_index.animation_attack-1 then
                armatureBase:setPosition(cc.p(armatureBase.dx, armatureBase.dy))
            else
                if actionIndex == 0 then
                elseif actionIndex == 1 then
                    if true ~= armatureBase._moving then
                        armatureBase._moving = true
                        -- armatureBase:runAction(cc.Sequence:create(cc.MoveTo:create(armatureBase.m_time, cc.p(armatureBase.dx, armatureBase.dy)), cc.CallFunc:create(function (sender)
                        --     armatureBase._nextAction = _enum_spine_tank_frame_index.animation_attack-1
                        -- end)))
                        armatureBase._path_layer = layerbg
                    end
                end
            end
        end
    end
    local function drawFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
        local armature = bone:getArmature()
        if evt == "change1" then
            csb.animationChangeToAction(armature, index * 2 + 1, index * 2 + 1, false)
        elseif evt == "end" then
            -- armature._parent:removeFromParent(true)
        end
    end
    armature:getAnimation():setFrameEventCallFunc(drawFrameEvent)
    return armature
end    

-- 绘制地图事件信息
function AdventureMine:drawArmyInfo()
    for i, v in pairs(_ED.world_map.target_event_info) do
        if true ~= v._isDraw then
            v._isDraw = true
            local tank = cc.Sprite:create("images/ui/world_route_tank/world_route_tank_0.png")

            -- local ca = _ED.cca[v._sy][v._sx]
			local ca = {}
			local ccax, ccay = cc.dms_init_world_map_get(1, v._sx, v._sy)
			ca.x = ccax
			ca.y = ccay
            -- debug.print_r(ca)
        end
    end
end


--绘制气泡 
function AdventureMine:onUpdateBubbleDraw(data)
    if self.controllerLayer == nil then 
        return
    end
    local childName = "".. data.node.tileX .. "," .. data.node.tileY .. "bubble"
    if data.isOpen == true then 
        --打开 
        local child = self.controllerLayer:getChildByName(childName)
        if child ~= nil then 
        else
            local msg = dms.string(dms["npc"], data.node.boss_id, npc.sign_msg)
            
            local cell = AdventureMineBubble:createCell()
            cell:init(data.node,msg)
            cell:setName(childName)
            self.controllerLayer:addChild(cell,15)
        end
    else
        local child = self.controllerLayer:getChildByName(childName)
        if child ~= nil then 
            self.controllerLayer:removeChildByName(childName)
        end
    end
end

function AdventureMine:addformatMineData()
    local size = self.controllerSize
    local sx = size.width / 2
    local sy = size.height
    local isNewBoss = false
    if _ED.adventure_mine.add_mineral ~= nil then
        for i, v in pairs(_ED.adventure_mine.add_mineral) do
            local x = v.x
            local y = v.y
            local tileType = v._type
            -- local cell = AdventureMineTileCell:createCell()
            -- if x ~= nil and y ~= nil and tileType ~= nil then
            --     cell:init(self.controllerLayer, x, y, tileType, sx, sy)
            --     table.insert(self.allItems,cell)
            --     self.controllerLayer:addChild(cell)
            --     cell:reload()
            -- end

            if x ~= nil and y ~= nil and tileType ~= nil then
                local title = {_controllerLayer = self.controllerLayer, _x = x, _y = y, _tileType = tileType, _sx = sx, _sy = sy, _drawIndex = 0, _focus = nil, _alived = false}
                self.data_map["" .. y .. "," .. x] = title
                local resource_type = dms.int(dms["mine_grid"], tileType, mine_grid.resource_type)
        
                if resource_type == 2  or resource_type == 3 then 
                    table.insert(_ED.adventure_mine.boss_mineral, {x = x, y = y, _type = tileType})
                    isNewBoss = true
                end
                self:createMineTile(title)
                if tonumber(y) > tonumber(_ED.adventure_mine.mine_depth) then 
                    _ED.adventure_mine.mine_depth = tonumber(y)
                end
            end     
        end
    end
    
    self.focusCell = nil
    state_machine.excute("adventure_mine_manager_mine_zabing_level", 0, nil)
    state_machine.excute("adventure_mine_reset_update_draw_basics", 0, nil)
    if isNewBoss == true then 
        self:sortBossFunc()
        state_machine.excute("adventure_mine_manager_mine_boss_count_update", 0, nil)
    end
end

function AdventureMine:sortBossFunc()
         -- 排序算法 有点问题
    -- local sortFunc = function( cell1, cell2 )
    --     if tonumber(cell2._type) < tonumber(cell1._type) then 
    --         return true
    --     elseif tonumber(cell2.y) < tonumber(cell1.y) then 
    --         return true
    --     else 
    --         return false
    --     end
    -- end

    -- if #_ED.adventure_mine.boss_mineral > 1 then 
    --     table.sort(_ED.adventure_mine.boss_mineral, sortFunc)
    -- end 
end

function AdventureMine:createMineTile(tile)
    local cell = table.remove(self.free_map, 1, 1)
    if cell == nil then
        cell = AdventureMineTileCell:createCell()
        cell:init(tile._controllerLayer, tile._x, tile._y, tile._tileType, tile._sx, tile._sy, 1)
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			local mx = 599 + tile._x + 1
			local my = tile._y + 1
			if my >= 1 then
				-- local ta = _ED.cta[my][mx]
				-- if _ED.cta[my] ~= nil and ta ~= nil then
					-- cell:setName("cell".. "_".. ta.x .. "_" .. ta.y)
				-- end
				local ta = {}
				local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
				ta.x = ta_x
				ta.y = ta_y
				if ta.x > -1 and ta.y > -1 then
					cell:setName("cell".. "_".. ta.x .. "_" .. ta.y)
				end
			end
		else
			cell:setName("cell".. "_".. tile._x .. "_" .. tile._y)
		end
        cell:retain()
        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            self.controllerLayer:addChild(cell)
        end
    else
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            cell:reset(tile._controllerLayer, tile._x, tile._y, tile._tileType, tile._sx, tile._sy, nil)
			local mx = 599 + tile._x + 1
			local my = tile._y + 1
			if my >= 1 then
				-- local ta = _ED.cta[my][mx]
				-- if _ED.cta[my] ~= nil and ta ~= nil then
					-- cell:setName("cell".. "_".. ta.x .. "_" .. ta.y)
				-- end
				local ta = {}
				local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
				ta.x = ta_x
				ta.y = ta_y
				-- debug.print_r(ta)
				if ta.x > -1 and ta.y > -1 then
					cell:setName("cell".. "_".. ta.x .. "_" .. ta.y)
				end
			end
		else
            cell:init(tile._controllerLayer, tile._x, tile._y, tile._tileType, tile._sx, tile._sy, nil)
			cell:setName("cell".. tile._x .. "_" .. tile._y)
		end
        cell:reload()
    end
    self.used_map["" .. tile._y .. "," .. tile._x] = cell

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
    else
        self.controllerLayer:addChild(cell)
    end
	-- self.map_actual_point[]
	local m_mx = 599 + tile._x + 1
	local m_my = tile._y + 1
	if m_my >= 1 then
		-- local ta = _ED.cta[m_my][m_mx]
		-- if _ED.cta[m_my] ~= nil and ta ~= nil then
			-- self.map_actual_point[""..ta.x.."_"..ta.y] = {
				-- cell:getPositionX(),
				-- cell:getPositionY(),
			-- }
		-- end
		local ta = {}
		local ta_x, ta_y = cc.dms_init_world_map_get(2, m_mx, m_my)
		ta.x = ta_x
		ta.y = ta_y
		if ta.x > -1 and ta.y > -1 then
			self.map_actual_point[""..ta.x.."_"..ta.y] = {
				cell:getPositionX(),
				cell:getPositionY(),
			}
		end
	end
    cell.__tile = tile
    tile._cell = cell
    tile._alived = true

    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
    else
        if tile._focus ~= nil
            then
            tile._focus = cell
            self.focusCell = cell
            local params = { node = tile._focus, iswakuang = (tile._exploit == true)}
            state_machine.excute("adventure_mine_exploit_open", 0, params)
        elseif 
            tile._x ~= 0 
            and (tile._y) ~= 0 
            and (tile._x + 0) == _ED.adventure_mine.current_mine.x 
            and (tile._y) == _ED.adventure_mine.current_mine.y 
            then
            tile._focus = cell
            self.focusCell = cell
            state_machine.excute("adventure_mine_exploit_open", 0,  { node = tile._focus, iswakuang = false})
        end
    end
end

function AdventureMine:onUpdateResetBossMineData()
    if _ED.adventure_mine.reset_boss_mineral ~= nil then
        for i, v in pairs(_ED.adventure_mine.reset_boss_mineral) do
            local x = v.x
            local y = v.y
            local tileType = v._type
            if x ~= nil and y ~= nil and tileType ~= nil then
               -- debug.print_r(self.data_map["" .. (y) .. "," .. x])
                local cellData = self.data_map["" .. (y) .. "," .. x]
                if cellData ~= nil then 
                    cellData._tileType = tileType  
                end
            end     
        end
    end
end

function AdventureMine:locationBoss()
    self.locationBossIndex = self.locationBossIndex + 1

    if self.locationBossIndex > #_ED.adventure_mine.boss_mineral then
        self.locationBossIndex = 1
    end
    if #_ED.adventure_mine.boss_mineral > 0 then 
        local cell = _ED.adventure_mine.boss_mineral[self.locationBossIndex]
        
        if self.mine_center_pos ~= nil and cell ~= nil then 
            local size = self.controllerSize
            local sx = size.width / 2
            local sy = size.height
            local winSize = self:getContentSize() --cc.Director:getInstance():getWinSize();
            
            local beginPos = cc.p(sx + cell.x * 60, sy - (cell.y) * 60 - 60)
            local endPos = cc.p(sx + self.mine_center_pos._x * 60, sy - self.mine_center_pos._y * 60 - 60)

            local  diff = cc.p(endPos.x - beginPos.x  ,endPos.y - beginPos.y)
            diff.x =  diff.x-- /app.scaleFactor 
            diff.y =  diff.y-- /app.scaleFactor

            local currentPos = cc.p(self.controllerLayer:getPosition())
            local pos = cc.pAdd(currentPos, diff)
        
            local controllerLayerCurrSize = cc.size(self.controllerLayer:getBoundingBox().width, self.controllerLayer:getBoundingBox().height)

            -- 边界控制，约束pos的位置
            pos.x = math.min(pos.x, controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)
            pos.x = math.max(pos.x, -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)

            pos.y = math.min(pos.y, controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)
            pos.y = math.max(pos.y, -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)

            -- 重设self.controllerLayer位置
            self.controllerLayer:setPosition(pos)

            -- 更新原点位置
            if pos.x >= controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x 
                or pos.x <= -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x then
                diff.x = 0
            end
             
            if pos.y >= controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y 
                or pos.y <= -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y then
                diff.y = 0
            end

            self.currentInnerContainerOrigin = cc.pAdd(self.currentInnerContainerOrigin, diff)
        end
    end
end

function AdventureMine:onUpdateBattleBossVictory(pos)
    
    for i,v in pairs(_ED.adventure_mine.boss_mineral) do
        if tonumber(v.x) == tonumber(pos.x) and tonumber(v.y) == tonumber(pos.y) then
            
            table.remove(_ED.adventure_mine.boss_mineral,i)
        end
    end
   self:sortBossFunc()
   state_machine.excute("adventure_mine_manager_mine_boss_count_update", 0, nil)
end

function AdventureMine:initMineView()
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        local batch0 = cc.SpriteBatchNode:create("map/world_npc/world_surface_3.png", 100);
        self.controllerLayer:addChild(batch0, -2, 1)
        self.controllerLayer._batch0 = batch0
        self.controllerLayer._texture0 = batch0:getTexture()

        local batch1 = cc.SpriteBatchNode:create("map/world_npc/world_surface_1.png", 100);
        self.controllerLayer:addChild(batch1, -2, 1)
        self.controllerLayer._batch1 = batch1
        self.controllerLayer._texture1 = batch1:getTexture()

        local batch2 = cc.SpriteBatchNode:create("map/world_npc/world_surface_2.png", 100);
        self.controllerLayer:addChild(batch2, -2, 1)
        self.controllerLayer._batch2 = batch2
        self.controllerLayer._texture2 = batch2:getTexture()

        self.controllerLayer._batch_tiles = self.controllerLayer._batch_tiles or {}
        for i, element in pairs(dms["world_mine_mould"]) do
            local mine_type = dms.atoi(element, world_mine_mould.mine_type)
            if mine_type > 5 then
                local pic = dms.atos(element, world_mine_mould.pic)
                local fileName = string.format("map/base_npc/map_%s.png", pic)
                local batch = cc.SpriteBatchNode:create(fileName, 10)
                batch:retain()
                -- self.controllerLayer:addChild(batch, -1, 1)
                self.controllerLayer._batch_tiles[pic] = batch
            end
        end
    end

    local rect = self.controllerLayer:getBoundingBox()
    local posX = rect.x
    local posY = rect.y
    -- if self.currentInnerContainerPosX == posX and self.currentInnerContainerPosY == posY then
    --     return
    -- end

    local size = self.controllerSize
    local sx = size.width / 2
    local sy = size.height

    self.currentInnerContainerPosY = posY
    self.currentInnerContainerPosX = posX
    local viewSize = self.viewSize
    local viewPosition = cc.p(-1 * rect.x, -1 * rect.y)
    local scale = self.controllerLayer:getScale()
    local viewRect = {
        x = viewPosition.x, 
        y = viewPosition.y, 
        rx = viewPosition.x + viewSize.width, 
        ry = viewPosition.y + viewSize.height
    }

    local itemSize = cc.size(_ED.mine_tile_width, _ED.mine_tile_height)
    self.view_rect.x = viewRect.x - 4 * itemSize.width * scale
    self.view_rect.y = viewRect.y - 4 * itemSize.height * scale
    self.view_rect.rx = viewRect.rx + 5 * itemSize.width * scale
    self.view_rect.ry = viewRect.ry + 8 * itemSize.height * scale
    self.view_rect.width = self.view_rect.rx - self.view_rect.x
    self.view_rect.height = self.view_rect.ry - self.view_rect.y

    -- local beginTileX = math.floor((self.view_rect.x - rect.width / 2) / itemSize.width * scale)
    -- local beginTileY = -1 * math.floor((self.view_rect.ry - rect.height) / itemSize.height * scale)
    -- local endTileX = math.floor((self.view_rect.rx - rect.width / 2) / itemSize.width * scale)
    -- local endTileY = -1 * math.floor((self.view_rect.y - rect.height) / itemSize.height * scale)

    local beginTileX = math.floor((self.view_rect.x - rect.width / 2) / (itemSize.width * scale))
    local beginTileY = -1 * math.floor((self.view_rect.ry - rect.height) / (itemSize.height * scale))
    local endTileX = math.floor((self.view_rect.rx - rect.width / 2) / (itemSize.width * scale))
    local endTileY = -1 * math.floor((self.view_rect.y - rect.height) / (itemSize.height * scale))

    self.beginTileX = beginTileX
    self.beginTileY = beginTileY
    self.endTileX = endTileX
    self.endTileY = endTileY
    self.mine_center_pos = {}
    self.mine_center_pos = {_x = math.floor((endTileX - beginTileX)/2) + beginTileX-1 ,_y = math.floor((endTileY - beginTileY)/2) + beginTileY}
    local ncount = 0
    for y = beginTileY, endTileY do
        for x = beginTileX, endTileX do
            local tile = self.data_map["" .. y .. "," .. x]
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                if nil == tile then
					local tileType = -1
					if y + 1 <= 1199 and y + 1 > 0 then
                        if x + 1>=-599 and x + 1<= 600 then
                            -- tileType = _ED.aaa[y + 1][599+x + 1]
                            tileType = cc.dms_init_world_map_get(0, 599+x + 1, y + 1)
                        end
                    end
                    -- if y + 1 <= 17 and y + 1 > 0 then
                    --     if x + 1>=-8 and x + 1<= 8 then
                    --         tileType = _ED.aaa[y + 1][8+x + 1]
                    --     end
                    -- end
                    tile = {_controllerLayer = self.controllerLayer, _x = x, _y = y, _tileType = tileType, _sx = sx, _sy = sy, _drawIndex = drawIndex, _focus = tfocus, _alived = false}
                    self.data_map["" .. (y) .. "," .. x] = tile
                end
            end
            -- print(tile, "=====:::", "" .. y .. "," .. x)
            if tile ~= nil then
                self:createMineTile(tile)
                ncount = ncount + 1
            end
        end
    end
end

function AdventureMine:formatMineData()
    self.controllerLayer:removeAllChildren(true)
    self.controllerLayer:setPosition(self.controllerStartPosition)
    self.controllerLayer:setAnchorPoint(self.currentInnerContainerAnchor)
    _ED.adventure_mine.mine_tile = {}
    local size = self.controllerSize
    local sx = size.width / 2
    local sy = size.height
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then

    else
    	if _ED.adventure_mine.mine_data == nil or _ED.adventure_mine.mine_data == "" then
    		return
    	end
        local lineData = zstring.split(_ED.adventure_mine.mine_data, "|")
        local focus = nil
        local drawIndex = 1
        self.data_map = {}
        _ED.adventure_mine.boss_mineral = {}
        _ED.adventure_mine.mine_depth = #lineData
        for y, v in pairs(lineData) do
            local coordInfos = zstring.split(v, ",")
            for _, m in pairs(coordInfos) do
                local tileInfo = zstring.split(m, ":")
                local x = tileInfo[1]
                local tileType = tileInfo[2]
                -- local cell = AdventureMineTileCell:createCell()
                -- if x ~= nil and y ~= nil and tileType ~= nil then
                --     cell:init(self.controllerLayer, x, y-1, tileType, sx, sy, drawIndex)

                --     table.insert(self.allItems,cell)
                --     self.controllerLayer:addChild(cell)
                --     drawIndex = drawIndex + 1
                
                --     if x ~= 0 
                --         and (y - 1) ~= 0 
                --         and (x + 0) == _ED.adventure_mine.current_mine.x 
                --         and (y - 1) == _ED.adventure_mine.current_mine.y 
                --         then
                --         focus = cell
                --         -- print(x, (y - 1), _ED.adventure_mine.current_mine.x, _ED.adventure_mine.current_mine.y)
                --     end
                -- else
                -- end

                if x ~= nil and y ~= nil and tileType ~= nil then
                    -- self.data_map["" .. (y-1)] = self.data_map["" .. (y-1)] or {}
                    -- local tfocus = nil
                    if x ~= 0 
                        and (y - 1) ~= 0 
                        and (x + 0) == _ED.adventure_mine.current_mine.x 
                        and (y - 1) == _ED.adventure_mine.current_mine.y 
                        and zstring.tonumber(tileType) == zstring.tonumber(_ED.adventure_mine.current_mine.mineral_type)
                        and (zstring.tonumber(tileType) == 6 or zstring.tonumber(tileType) == 7 or zstring.tonumber(tileType) == 8 or zstring.tonumber(tileType) == 9 or zstring.tonumber(tileType) == 10)
                        then
                       self:onAutoPickMine(tileType)
                    end
                    -- print("----::LLL>>" .. (y-1) .. "," .. x)
                    self.data_map["" .. (y-1) .. "," .. x] = {_controllerLayer = self.controllerLayer, _x = x, _y = y-1, _tileType = tileType, _sx = sx, _sy = sy, _drawIndex = drawIndex, _focus = tfocus, _alived = false}
                    local resource_type = dms.int(dms["mine_grid"], tileType, mine_grid.resource_type)
                    if resource_type == 2 or resource_type == 3 then
                        
                        local bossCell = {x = x, y = y-1, _type = tileType}
                       
                        table.insert(_ED.adventure_mine.boss_mineral, bossCell)
                    end
                    drawIndex = drawIndex + 1
                end
            end
        end
        self:sortBossFunc()
    end
    self:initMineView()
    -- debug.print_r(self.data_map)
    -- state_machine.excute("adventure_mine_exploit_open", 0, focus)
end

function AdventureMine:onAutoPickMine(tileType)

    local function responseMineExploitCallback(response)

        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if _ED.adventure_mine.mine_data ~= "-1" then
                cc.UserDefault:getInstance():setStringForKey(getKey("mine_data"), _ED.adventure_mine.mine_data or "")
            end
            getSceneReward(57) -- 清除拾取奖励
            _ED.adventure_mine.current_mine.y = 0 
            _ED.adventure_mine.current_mine.x = 0 
            if self.data_map == nil then 
                return
            end
            local cellData = self.data_map["" .. _ED.adventure_mine.current_mine.y  .. "," .. _ED.adventure_mine.current_mine.x]
            if cellData ~= nil then 
                cellData._tileType = "0"
                cellData._focus = nil
                cellData._exploit = false
            end
        end
    end
    protocol_command.mineral_pick.param_list = "" .. _ED.adventure_mine.current_mine.x .. "\r\n" .. _ED.adventure_mine.current_mine.y .. "\r\n" .. "0"
    NetworkManager:register(protocol_command.mineral_pick.code, nil, nil, nil, nil, responseMineExploitCallback, false, nil)
    
end

function AdventureMine:initMineData()
    local mineData = cc.UserDefault:getInstance():getStringForKey(getKey("mine_data"))
    local mode = 0
    if mineData == nil or #mineData == 0 then
        mode = 1
    end
    mode = 1

    self.mineData = mineData

    local function responseMineInitCallback(response)
        -- print(response.resouce)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            -- 保存矿区的数据
            if _ED.adventure_mine.mine_data ~= "-1" then
                cc.UserDefault:getInstance():setStringForKey(getKey("mine_data"), _ED.adventure_mine.mine_data or "")
            end
            if response.node ~= nil and response.node.roots ~= nil then
                if _ED.adventure_mine.mine_data == "-1" then
                    _ED.adventure_mine.mine_data = response.node.mineData
                    -- print(_ED.adventure_mine.mine_data)
                end
                response.node.mineData = nil
                response.node:formatMineData()
                response.node:initMineTiles()
                response.node.currentInnerContainerPosY = 0
                response.node.currentInnerContainerPosX = 0
                response.node:onUpdate(1)
            end
        
            state_machine.excute("adventure_mine_reset_update_draw_basics", 0, nil)
        end
    end
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self.mineData = nil
		self:formatMineData()
		self:initMineTiles()
		self.currentInnerContainerPosY = 0
		self.currentInnerContainerPosX = 0
		self:onUpdate(1)
	else
		protocol_command.mineral_init.param_list = ""..mode
		NetworkManager:register(protocol_command.mineral_init.code, nil, nil, nil, self, responseMineInitCallback, false, nil)
	end
end

--修改本地存储数据
function AdventureMine:changeMinedata(x,y,type,update)
    local size = self.controllerSize
    local sx = size.width / 2
    local sy = size.height
    local cellData = {_controllerLayer = self.controllerLayer, _x = x, _y = y, _tileType = type, _sx = sx, _sy = sy, _drawIndex = 0, _focus = tfocus, _alived = false}
    self.data_map["" .. (y) .. "," .. x] = cellData
    if update == nil then 
        self:createMineTile(cellData)
    end
end

function AdventureMine:onUpdate(dt)
    if self.controllerLayer ~= nil then
        -- if #self.touches > 0 or true == self._update_cell then
        --     return
        -- end
        local rect = self.controllerLayer:getBoundingBox()
        local posX = rect.x
        local posY = rect.y
        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            if (self.currentInnerContainerPosX == posX and self.currentInnerContainerPosY == posY )or 
                (self.currentInnerContainerPosX < posX + 80 and self.currentInnerContainerPosY < posY + 160) and 
                (self.currentInnerContainerPosX > posX - 80 and self.currentInnerContainerPosY > posY - 160)
                then
                return
            end
        else
            if (self.currentInnerContainerPosX == posX and self.currentInnerContainerPosY == posY )or 
                (self.currentInnerContainerPosX < posX + 45 and self.currentInnerContainerPosY < posY + 45) and 
                (self.currentInnerContainerPosX > posX - 45 and self.currentInnerContainerPosY > posY - 45)
                then
                return
            end
        end

        self.currentInnerContainerPosY = posY
        self.currentInnerContainerPosX = posX
        local viewSize = self.viewSize
        local viewPosition = cc.p(-1 * rect.x, -1 * rect.y)
        local scale = self.controllerLayer:getScale()
        local viewRect = {
            x = viewPosition.x, 
            y = viewPosition.y, 
            rx = viewPosition.x + viewSize.width / scale, 
            ry = viewPosition.y + viewSize.height / scale
        }

        local itemSize = cc.size(_ED.mine_tile_width, _ED.mine_tile_height)
        self.view_rect.x = viewRect.x - itemSize.width * scale
        self.view_rect.y = viewRect.y - itemSize.height * scale
        self.view_rect.rx = viewRect.rx + 1 * itemSize.width * scale 
        self.view_rect.ry = viewRect.ry + 4 * itemSize.height * scale
        self.view_rect.width = self.view_rect.rx - self.view_rect.x
        self.view_rect.height = self.view_rect.ry - self.view_rect.y

        -- local beginTileX = math.floor((self.view_rect.x - rect.width / 2) / (itemSize.width * scale))
        -- local beginTileY = -1 * math.floor((self.view_rect.ry - rect.height) / (itemSize.height * scale))
        -- local endTileX = math.floor((self.view_rect.rx - rect.width / 2) / (itemSize.width * scale))
        -- local endTileY = -1 * math.floor((self.view_rect.y - rect.height) / (itemSize.height * scale))

        local beginTileX = 0
        local beginTileY = 0
        local endTileX = 0
        local endTileY = 0

        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            beginTileX = math.floor((self.view_rect.x - rect.width / 2) / (itemSize.width / 2 * scale))
            beginTileY = -1 * math.floor((self.view_rect.ry - rect.height) / (itemSize.height * scale))
            endTileX = math.floor((self.view_rect.rx - rect.width / 2) / (itemSize.width / 2 * scale))
            endTileY = -1 * math.floor((self.view_rect.y - rect.height) / (itemSize.height * scale))
        else
            beginTileX = math.floor((self.view_rect.x - rect.width / 2) / (itemSize.width * scale))
            beginTileY = -1 * math.floor((self.view_rect.ry - rect.height) / (itemSize.height * scale))
            endTileX = math.floor((self.view_rect.rx - rect.width / 2) / (itemSize.width * scale))
            endTileY = -1 * math.floor((self.view_rect.y - rect.height) / (itemSize.height * scale))
        end

        local size = self.controllerSize
        local sx = size.width / 2
        local sy = size.height

        if beginTileX ~= self.beginTileX or beginTileY ~= self.beginTileY then
            self.beginTileX = beginTileX
            self.beginTileY = beginTileY
            self.endTileX = endTileX
            self.endTileY = endTileY
            for i, v in pairs(self.used_map) do
                v.__tile._alived = false
            end
            local newTiles = {}
            local  index  = 0    
            self.mine_center_pos = {_x = math.floor((endTileX - beginTileX)/2) + beginTileX-1 ,_y = math.floor((endTileY - beginTileY)/2) + beginTileY}
        
			
            for y = beginTileY, endTileY do

                for x = beginTileX, endTileX do  

                    local dataTile = self.data_map["" .. y .. "," .. x]
                    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                        if nil == dataTile then
							local tileType = -1
                            if y + 1 <= 1199 and y + 1 > 0 then
                                if x + 1>=-599 and x + 1<= 600 then
                                    local mx = 599+x + 1
                                    local my = y + 1
                                    -- tileType = _ED.aaa[y + 1][599+x + 1]
                                    tileType = cc.dms_init_world_map_get(0, 599+x + 1, y + 1)
                                    -- -- debug.print_r(_ED.cta[mx .. "," .. my])
                                    -- print(599+x + 1, y +)
                                    -- if 35 == 599+x + 1 and 307 == y + 1 then
                                    --     print(_ED.cta[mx .. "," .. my][1], _ED.cta[mx .. "," .. my][2])
                                    -- end
                                end
                            end
                            -- if y + 1 <= 17 and y + 1 > 0 then
                            --     if x + 1>=-8 and x + 1<= 8 then
                            --         tileType = _ED.aaa[y + 1][8+x + 1]
                            --     end
                            -- end
                            local tile = {_controllerLayer = self.controllerLayer, _x = x, _y = y, _tileType = tileType, _sx = sx, _sy = sy, _drawIndex = drawIndex, _focus = tfocus, _alived = false}
                            self.data_map["" .. (y) .. "," .. x] = tile
                            dataTile = tile
                        end
                    end
                    if dataTile ~= nil then
                        index = index + 1
                        local mineTile = self.used_map["" .. y .. "," .. x]
                        if mineTile == nil then
                            table.insert(newTiles, dataTile)
                        elseif dataTile._tileType ~= mineTile.tileType then 
                            table.insert(newTiles, dataTile)
                        else
                            dataTile._alived = true
                        end
                    end
                end
            end

            -- if #self.touches == 0 or #self.touches > 300 then
                for i, v in pairs(self.used_map) do
                    if v.__tile._alived == false then
                        v:unload()
                        -- v:removeFromParent(true)
                        table.insert(self.free_map, v)
                        self.used_map[i] = nil
                    end
                end
            -- end
            for i, v in pairs(newTiles) do
                self:createMineTile(v)
            end
            -- print("self.used_map", table.nums(self.used_map), #self.touches)
        end
		
		if _ED.factor_info ~= nil then
			local local_time = -100
			for i, v in pairs(_ED.factor_info) do
				if tonumber(v.factor_type) == 68 then
					local_time = (v.factor_start_time+v.factor_cd_time)-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
					break
				end
			end
			if local_time ~= -100 then
				local_time = local_time - dt
				if local_time <= -1 then
					local_time = -100
					state_machine.excute("adventure_mine_update_cover",0,0)
				end
			end
		end
    end
    
    -- if self.controllerLayer ~= nil then
    --     -- local size = self.mapViewSize --ccui.Helper:seekWidgetByName(root, "Panel_1")
    --     -- local posX, posY = self.controllerLayer:getPosition()
    --     -- local anchor = cc.p(self.controllerLayer:getAnchorPoint())
    --     -- posX = posX - size.width * anchor.x
    --     -- posY = posY - size.height * anchor.y
    --     -- print("------------------")
    --     -- debug.print_r(self.controllerLayer:getBoundingBox())
    --     -- print(posX, posY)
    --     local rect = self.controllerLayer:getBoundingBox()
    --     local posX = rect.x
    --     local posY = rect.y
    --     if self.currentInnerContainerPosX == posX and self.currentInnerContainerPosY == posY then
    --         return
    --     end

    --     self.currentInnerContainerPosY = posY
    --     self.currentInnerContainerPosX = posX
    --     local viewSize = self.viewSize
    --     local viewPosition = cc.p(-1 * rect.x, -1 * rect.y)
    --     local scale = self.controllerLayer:getScale()
    --     local viewRect = {
    --         x = viewPosition.x, 
    --         y = viewPosition.y, 
    --         rx = viewPosition.x + viewSize.width, 
    --         ry = viewPosition.y + viewSize.height
    --     }

    --     -- debug.print_r(viewRect)
    --     -- print("****************")
    --     local items = self.allItems
    --     if items[1] == nil then
    --         return
    --     end
    --     local reloadCount = 0
    --     local unloadCount = 0
    --     local itemSize = items[1]:getContentSize()
    --     for i, v in pairs(items) do
    --         if v ~= nil then 
    --             local tempX, tempY = v:getPosition()
    --             tempX = tempX * scale
    --             tempY = tempY * scale
    --             if tempX >= viewRect.x - itemSize.width * scale  and tempX <= viewRect.rx + 1 * itemSize.width * scale
    --                 and tempY >= viewRect.y - itemSize.height * scale and tempY <= viewRect.ry + 1 * itemSize.height * scale
    --                 then
    --                 v:reload()
    --             else
    --                 v:unload()
    --             end
    --         end 
    --     end
    -- end
end

function AdventureMine:onEnterTransitionFinish()
    --cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_coord"), "" .. -599680.0 .. "," .. -17276)
    if missionIsOver() == false then
        --新手指引的时候防止黑屏
        self.controllerLayer:setPosition(cc.p(self.controllerStartUpdatePosition.x,self.controllerStartUpdatePosition.y))
        self.controllerLayer:setAnchorPoint(cc.p(self.currentInnerContainerAnchor.x,self.currentInnerContainerAnchor.y))
        self.controllerLayer:setScale(1)
        cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_anchor"), "" .. self.controllerLayer:getAnchorPoint().x .. "," .. self.controllerLayer:getAnchorPoint().y)
        cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_scale"), "" .. self.controllerLayer:getScale())
        cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_coord"), "" .. self.controllerStartUpdatePosition.x .. "," .. self.controllerStartUpdatePosition.y)
    end
    --self.currentInnerContainerPosX = self.currentInnerContainerPosX + 80
    --self.currentInnerContainerPosY = self.currentInnerContainerPosY + 80
    --self.beginTileX = self.beginTileX - 10
    self:onUpdate(1)
    self:registerOnNodeEvent(self)
    self:registerOnNoteUpdate(self, 0)
   -- print(self.focusCell)
    state_machine.excute("adventure_mine_exploit_open", 0, { node = self.focusCell,iswakuang = true})
    state_machine.unlock("adventure_mine_world_all_attack_event_path_info")
      -- self.controllerLayer:setPosition(-599680.00, -17275.69)

    -- local winSize = cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY)
    -- local _camera = cc.Camera:createPerspective(60, winSize.width / winSize.height, 1, 500)
    -- _camera:setCameraFlag(cc.CameraFlag.USER1)
    -- -- _camera:setCameraFlag(cc.CameraFlag.USER8)
    -- _camera:setPosition3D(cc.vec3(0, 10, 50))
    -- -- self:setCameraMask(cc.CameraFlag.USER1)
    -- _camera:lookAt(cc.vec3(0, 0, 0), cc.vec3(0.0, 1.0, 0.0))
    -- self:addChild(_camera)
    -- -- self:setCameraMask(cc.CameraFlag.USER1)
    -- self:setCameraMask(2);

    -- -- local bgsprite = cc.Sprite:create("map/world_npc/world_surface_1.png")
    -- -- bgsprite:setPosition(cc.p(200, 400))
    -- -- self:addChild(bgsprite)

    -- local billboard = cc.BillBoard:create("map/world_npc/world_surface_1.png")
    -- billboard:setScale(0.2)
    -- billboard:setPosition3D(cc.vec3(200.0, 400.0, 150.0))
    -- self:addChild(billboard)
end

function AdventureMine:onInit()
    local csbAdventureMine = nil
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		csbAdventureMine = csb.createNode(config_csb.world_map.mine_bg)
	else
		csbAdventureMine = csb.createNode("campaign/Mining/wakuang_map_bg.csb")
	end
    local root = csbAdventureMine:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMine)
	-- _ED.aaa,_ED.cca,_ED.cta = self:initcoord(600)
	-- debug.print_r(_ED.aaa[600][10]) 
	-- debug.print_r(_ED.cca[300][300])
	-- debug.print_r(_ED.cta[301][600])
	-- print("-------------------------------")
	-- print(cc.dms_init_world_map_get(0, 10, 600))
	-- print(cc.dms_init_world_map_get(1, 300, 300))
	-- print(cc.dms_init_world_map_get(2, 600, 301))
	-- print("+++++++++++++++++++++++++++++++++++++")

    local layer = ccui.Helper:seekWidgetByName(root, "Panel_wakuang")
    layer:setSwallowTouches(false)
    -- layer:ignoreAnchorPointForPosition(true)
    self.mapViewSize = layer:getContentSize()
    --print(" 可见区域:",self.mapViewSize.width,self.mapViewSize.height)

    self.currentInnerContainerAnchor = layer:getAnchorPoint()

    -- local layer1 = cc.LayerGradient:create(cc.c4b(255,0,0,255), cc.c4b(0,255,0,255), cc.p(0.9, 0.9))
    -- layer1:setContentSize(root:getContentSize())
    -- layer:addChild(layer1, -1)
    -- self.bgLayer1 = layer1

    local listener = cc.EventListenerTouchAllAtOnce:create()

    listener:registerScriptHandler(function(touches, event)
        if _ED.current_window_in_main_city == true then
            return
        end
        state_machine.excute("world_input_window_close", 0, 0)
        -- print("began")
        for i, v in pairs(touches) do
            table.insert(self.touches, v)
            v:retain()
        end
        -- if nil == self._touch_pos then
            self._touch_pos = cc.p(self.controllerLayer:getPosition())
        -- end
       -- print("---缩放比例:",app.scaleFactor)
        -- if #self.touches == 2 then
        --     -- local scale = self.controllerLayer:getScale()
        --     -- local currentPosition = cc.p(self.controllerLayer:getPosition())
        --     -- local currentAnchor = cc.p(self.controllerLayer:getAnchorPoint())
        --     -- local basePosition = cc.p(currentPosition.x - self.mapViewSize.width * scale * currentAnchor.x, currentPosition.y - self.mapViewSize.height * scale * currentAnchor.y)
        --     -- local touchOenPosition = self.touches[1]:getPreviousLocation() 
        --     -- local touchTwoPosition = self.touches[2]:getPreviousLocation()
        --     -- local screenPosition = cc.p(touchOenPosition.x + (touchTwoPosition.x - touchOenPosition.x) / 2, touchOenPosition.y + (touchTwoPosition.y - touchOenPosition.y) / 2)
        --     -- local targetPosition = cc.p(basePosition.x - screenPosition.x, basePosition.y - screenPosition.y)
        --     -- local targetAnchor = cc.p(math.abs(targetPosition.x) / self.mapViewSize.width * scale, math.abs(targetPosition.y) / self.mapViewSize.height * scale)
        --     -- self.currentInnerContainerPosX = currentPosition.x + self.mapViewSize.width * scale * (targetAnchor.x - currentAnchor.x)
        --     -- self.currentInnerContainerPosY = currentPosition.y + self.mapViewSize.height * scale * (targetAnchor.y - currentAnchor.y)
        --     -- self.controllerLayer:setAnchorPoint(targetAnchor)
        --     -- self.controllerLayer:setPosition(cc.p(self.currentInnerContainerPosX, self.currentInnerContainerPosY))

        --     local scale = root:getScale()
        --     local currentPosition = cc.p(self.controllerLayer:getPosition())
        --     local touchOenPosition = self.touches[1]:getPreviousLocation() 
        --     local touchTwoPosition = self.touches[2]:getPreviousLocation()
        --     local screenPosition = cc.p(touchOenPosition.x + (touchTwoPosition.x - touchOenPosition.x) / 2, touchOenPosition.y + (touchTwoPosition.y - touchOenPosition.y) / 2)
            
        --     root:setPosition(screenPosition)
        --     -- self.controllerLayer:setPosition(cc.p(currentPosition.x - screenPosition.x / scale, currentPosition.y - screenPosition.y / scale))
        -- end

                if #self.touches == 1 then
            -- local scale = self.controllerLayer:getScale()
            -- local currentPosition = cc.p(self.controllerLayer:getPosition())
            -- local currentAnchor = cc.p(self.controllerLayer:getAnchorPoint())
            -- local basePosition = cc.p(currentPosition.x - self.mapViewSize.width * scale * currentAnchor.x, currentPosition.y - self.mapViewSize.height * scale * currentAnchor.y)
            -- local touchOenPosition = self.touches[1]:getPreviousLocation() 
            -- local touchTwoPosition = self.touches[2]:getPreviousLocation()
            -- local screenPosition = cc.p(touchOenPosition.x + (touchTwoPosition.x - touchOenPosition.x) / 2, touchOenPosition.y + (touchTwoPosition.y - touchOenPosition.y) / 2)
            -- local targetPosition = cc.p(basePosition.x - screenPosition.x, basePosition.y - screenPosition.y)
            -- local targetAnchor = cc.p(math.abs(targetPosition.x) / self.mapViewSize.width * scale, math.abs(targetPosition.y) / self.mapViewSize.height * scale)
            -- self.currentInnerContainerPosX = currentPosition.x + self.mapViewSize.width * scale * (targetAnchor.x - currentAnchor.x)
            -- self.currentInnerContainerPosY = currentPosition.y + self.mapViewSize.height * scale * (targetAnchor.y - currentAnchor.y)
            -- self.controllerLayer:setAnchorPoint(targetAnchor)
            -- self.controllerLayer:setPosition(cc.p(self.currentInnerContainerPosX, self.currentInnerContainerPosY))

            local scale = root:getScale()
            --local currentPosition = cc.p(self.controllerLayer:getPosition())

            local touchOenPosition = self.touches[1]:getLocation()
            --touchOenPosition:con 
            local pos = self.controllerLayer:convertTouchToNodeSpace(self.touches[1])
            -- print("当前容器的点....",currentPosition.x,currentPosition.y)
            -- print("点击的坐标点....",touchOenPosition.x,touchOenPosition.y)
            -- print("----转换的坐标点",pos.x,pos.y)
            -- pos.y = math.floor(pos.y -  pos.y%60)
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                -- -- local originPosition = self.controllerSize.

                -- -- debug.print_r({self._screen_size, self.controllerSize})

                -- local cellY = self.controllerSize.height - pos.y - 160 
                -- local mod = cellY%160
                -- cellY = cellY - mod
                -- local cellX =  math.abs(pos.x) - self.controllerSize.width/2
                -- local mod1 = cellX%160
                -- cellX = cellX - mod1

                -- self.centerCellX = math.floor(cellX/160)
                -- self.centerCellY = math.floor(cellY/160)
                -- state_machine.excute("adventure_mine_manager_update_basics",0,{x = self.centerCellX, y = self.centerCellY})
            else
                local cellY = self.controllerSize.height - pos.y - 60 
                local mod = cellY%60
                cellY = cellY - mod
                local cellX =  math.abs(pos.x) - self.controllerSize.width/2
                local mod1 = cellX%60
                cellX = cellX - mod1
                
                state_machine.excute("adventure_mine_manager_update_basics",0,{x = math.floor(cellX/60),y = math.floor(cellY/60)})
            end
            AdventureMine.__isCanClick = true
        end
    end, cc.Handler.EVENT_TOUCHES_BEGAN)

    listener:registerScriptHandler(function(touches, event)
        if _ED.current_window_in_main_city == true then
            return
        end
        local winSize = self:getContentSize() --cc.Director:getInstance():getWinSize();
        if #self.touches == 2 then-- 多点进行缩放
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                return
            end
            -- 得到当前两触摸点
            local point1 = self.touches[1]:getLocation();
            local point2 = self.touches[2]:getLocation();

            -- 计算两点之间得距离
            local currDistance = cc.pGetDistance(point1, point2) -- point1.distance(point2);

            -- 计算两触摸点上一时刻之间得距离
            local prevDistance = cc.pGetDistance(self.touches[1]:getPreviousLocation(), self.touches[2]:getPreviousLocation()) -- touches[0]->getPreviousLocation().distance(touches[1]->getPreviousLocation());

            -- 两触摸点与原点的差向量，pointVec1和pointVec2是相对于self.controllerLayer的位置
            local pointVec1 = cc.pSub(point1, self.currentInnerContainerOrigin)
            local pointVec2 = cc.pSub(point2, self.currentInnerContainerOrigin)

            -- 两触摸点的相对中点
            local relMidx = (pointVec1.x + pointVec2.x) / 2
            local relMidy = (pointVec1.y + pointVec2.y) / 2

            -- 计算self.controllerLayer的锚点
            local anchorX = relMidx / self.controllerLayer:getBoundingBox().width
            local anchorY = relMidy / self.controllerLayer:getBoundingBox().height

            -- 相对屏幕的中点
            local absMidx = (point2.x + point1.x) / 2
            local absMidy = (point2.y + point1.y) / 2

            -- 缩放时，为了避免出现空白的区域，需要做以下的边界处理。 
            -- 当self.controllerLayer快要进入到屏幕时，修改self.controllerLayer的位置（既absMidx和absMidy）。
            if self.currentInnerContainerOrigin.x > 0 then
                absMidx = absMidx - self.currentInnerContainerOrigin.x
            end

            if self.currentInnerContainerOrigin.x < -self.controllerLayer:getBoundingBox().width + winSize.width then
                absMidx = absMidx - self.controllerLayer:getBoundingBox().width + winSize.width - self.currentInnerContainerOrigin.x
            end

            if self.currentInnerContainerOrigin.y > 0 then
                absMidy = absMidy - self.currentInnerContainerOrigin.y
            end

            if self.currentInnerContainerOrigin.y < -self.controllerLayer:getBoundingBox().height + winSize.height then
                absMidy = absMidy - self.controllerLayer:getBoundingBox().height + winSize.height - self.currentInnerContainerOrigin.y
            end

            -- 重设self.controllerLayer锚点和位置
            self.controllerLayer:setAnchorPoint(cc.p(anchorX, anchorY))
            self.controllerLayer:setPosition(cc.p(absMidx, absMidy))

            -- 根据两触摸点前后的距离计算缩放倍率
            local scale = self.controllerLayer:getScale() * ( currDistance / prevDistance)

            -- 控制缩放倍率在1～2倍之间，最小倍率不能太小，不让背景将不能填充满整个屏幕。
            scale = math.min(2, math.max(0.75, scale))

            self.controllerLayer:setScale(scale)

            -- 更新原点位置
            self.currentInnerContainerOrigin = cc.pSub(cc.p(absMidx, absMidy), cc.p(self.controllerLayer:getBoundingBox().width * anchorX, self.controllerLayer:getBoundingBox().height * anchorY))
            AdventureMine.__isCanClick = false
            -- debug.print_r(self.currentInnerContainerOrigin)
        elseif #self.touches == 1 then-- 单点进行移动
            -- 单点时，touches中只有一个Touch对象，所以通过touches[0]就可以得到触摸对象
            local touch = self.touches[1]

            -- 计算滑动过程中的滑动增量
            local diff = touch:getDelta()
            if __lua_project_id == __lua_project_pacific_rim then
                diff.x =  diff.x / app.scaleFactor * 1.4
                diff.y =  diff.y / app.scaleFactor * 1.4
            else
                diff.x =  diff.x / app.scaleFactor
                diff.y =  diff.y / app.scaleFactor
            end
            -- if diff.x <= 3 and diff.y <= 3 and diff.x >= -3 and diff.y >= -3 then 
            --     return
            -- end

            -- diff.x = diff.x * 2
            -- diff.y = diff.y * 2
            
            --debug.print_r(diff)

            -- 得到当前self.controllerLayer的位置
            local currentPos = cc.p(self.controllerLayer:getPosition())

            -- 得到滑动后self.controllerLayer应该所在的位置
            local pos = cc.pAdd(currentPos, diff)
            
            -- 得到此刻self.controllerLayer的尺寸
            local controllerLayerCurrSize = cc.size(self.controllerLayer:getBoundingBox().width, self.controllerLayer:getBoundingBox().height)

            -- 边界控制，约束pos的位置
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                pos.x = math.min(pos.x, AdventureMine.__map_screen_rect.right)
                pos.x = math.max(pos.x, AdventureMine.__map_screen_rect.left)

                pos.y = math.min(pos.y, AdventureMine.__map_screen_rect.top)
                pos.y = math.max(pos.y, AdventureMine.__map_screen_rect.bottom)
            else
                pos.x = math.min(pos.x, controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)
                pos.x = math.max(pos.x, -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)

                pos.y = math.min(pos.y, controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)
                pos.y = math.max(pos.y, -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)
            end

            local canMove = true
            if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
                local cellY = self.controllerSize.height + (pos.y - 960 + _ED.mine_tile_width) + 80 
                local mod = cellY % _ED.mine_tile_height
                cellY = cellY - mod
                local cellX =  math.abs(pos.x) + _ED.mine_tile_width - self.controllerSize.width / 2
                local mod1 = cellX % _ED.mine_tile_height
                cellX = cellX - mod1
                -- print(cellY, cellX, pos.x, pos.y, self.controllerSize.width, self.controllerSize.height)
                -- print(pos.x, pos.y)

                cellX = math.floor(cellX/_ED.mine_tile_height)
                cellY = math.floor(cellY/_ED.mine_tile_height)
                
                local size = self.controllerSize
                local sx = size.width / 2
                local sy = size.height
                local offx = 0
                local offy = 0
                offx = -(_ED.mine_tile_width/2) * cellX
                offy = (_ED.mine_tile_height/2) * (cellX % 2)
                -- print(offy)
                -- if zstring.tonumber(self.tileType) == 1 then
                --  print(x, y, tonumber(y) * 160 - 160)
                -- end
                AdventureMine.__current_position.x = sx + cellX * _ED.mine_tile_width + offx
                AdventureMine.__current_position.y = sy - cellY * _ED.mine_tile_height - _ED.mine_tile_height + offy

                if cellY + 1 <= 1199 and cellY + 1 > 0 then
                    if cellX + 1>=-599 and cellX + 1<= 599 then
                        local mx = 599 + cellX + 1
                        local my = cellY + 1
                        -- local ta = _ED.cta[my][mx]
                        local ta = {}
                        local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
                        ta.x = ta_x
                        ta.y = ta_y
                        -- if nil ~= ta then
                        if ta.x > 0 or ta.y > 0 
                            -- or (mx <= 1 and diff.x < 0) 
                            then
                            self.centerCellX = ta.x
                            self.centerCellY = ta.y
                            state_machine.excute("adventure_mine_manager_update_basics",0,{x = self.centerCellX, y = self.centerCellY})
                            state_machine.excute("adventure_mine_small_map_update",0,0)
                        else
                            -- print("---------------------------------")
                            canMove = false
                            if nil == self._tip_time or self._tip_time + 2 < os.time() then
                                self._tip_time = os.time()
                                TipDlg.drawTextDailog(red_alert_all_str[297], cc.Sequence:create(cc.DelayTime:create(0.5), cc.MoveBy:create(0.5, cc.p(0, 100))))
                            end
                        end
                    else
                        -- print("---------------------------------")
                        canMove = false
                        if nil == self._tip_time or self._tip_time + 2 < os.time() then
                            self._tip_time = os.time()
                            TipDlg.drawTextDailog(red_alert_all_str[297], cc.Sequence:create(cc.DelayTime:create(0.5), cc.MoveBy:create(0.5, cc.p(0, 100))))
                        end
                    end
                else
                    -- print("---------------------------------")
                    canMove = false
                    if nil == self._tip_time or self._tip_time + 2 < os.time() then
                        self._tip_time = os.time()
                        TipDlg.drawTextDailog(red_alert_all_str[297], cc.Sequence:create(cc.DelayTime:create(0.5), cc.MoveBy:create(0.5, cc.p(0, 100))))
                    end
                end
                if AdventureMine.__isCanClick == true then
                    if math.abs(pos.x - self._touch_pos.x) > 20 or math.abs(pos.y - self._touch_pos.y) > 20 then
                        AdventureMine.__isCanClick = false
                    end
                end
            end

            if canMove then
                -- 重设self.controllerLayer位置
                self.controllerLayer:setPosition(pos)
                -- print(pos.x, pos.y, pos.x + self.controllerSize.width / 2, pos.y + self.controllerSize.height)

                -- 更新原点位置
                if pos.x >= controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x 
                    or pos.x <= -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x then
                    diff.x = 0
                end
                 
                if pos.y >= controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y 
                    or pos.y <= -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y then
                    diff.y = 0
                end

                self.currentInnerContainerOrigin = cc.pAdd(self.currentInnerContainerOrigin, diff)
            end
            -- debug.print_r(self.currentInnerContainerOrigin)
        end

        -- -- if(#touches > 1) then
        -- if #self.touches > 1 then
        --     -- 缩放地图
        --     local distance1 = cc.pGetDistance(self.touches[1]:getPreviousLocation(), self.touches[2]:getPreviousLocation())
        --     local distance2 = cc.pGetDistance(self.touches[1]:getLocation(), self.touches[2]:getLocation())

        --     local scale = root:getScale() * ( distance2 / distance1)
        --     scale = math.min(2, math.max(0.5, scale))

        --     root:setScale(scale)
        -- else
        --     -- 移动地图
        --     local touch = touches[1]
        --     local location = touch:getLocation()
        --     local previousLocation = touch:getPreviousLocation()
        --     local newPos = cc.pSub(previousLocation, location)
        --     local xx, yy = self.controllerLayer:getPosition()
        --     local mp = cc.p(xx - newPos.x, yy - newPos.y)
        --     mp.x = math.max(self.viewSize.width - self.controllerSize.width, math.min(0, mp.x))
        --     mp.y = math.max(self.viewSize.height - self.controllerSize.height, math.min(0, mp.y))
        --     -- print(self.controllerLayer:getPosition(), xx, yy, mp.x, mp.y)
        --     self.controllerLayer:setPosition(mp)
        --     self.controllerLayer:getPositionY()
        --     --print(location.x,location.y,newPos.x,newPos.y,mp.x,mp.y)
        -- end
    end, cc.Handler.EVENT_TOUCHES_MOVED)

    listener:registerScriptHandler(function(touches, event)
        AdventureMine.__isCanClick = true
		if _ED.current_window_in_main_city == true then
			return
		end
        for m, n in pairs(self.touches) do
            n:release()
        end
        self.touches = {}
        cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_anchor"), "" .. self.controllerLayer:getAnchorPoint().x .. "," .. self.controllerLayer:getAnchorPoint().y)
        cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_scale"), "" .. self.controllerLayer:getScale())
        cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_coord"), "" .. self.currentInnerContainerOrigin.x .. "," .. self.currentInnerContainerOrigin.y)
        local pos = cc.p(self.controllerLayer:getPosition())
        -- print("记录的点:",self.currentInnerContainerOrigin.x,self.currentInnerContainerOrigin.y, pos.x, pos.y)
        if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            if nil ~= self._touch_pos then
                if (math.abs(pos.x - self._touch_pos.x) + math.abs(pos.y - self._touch_pos.y)) > 120 
                    or (math.abs(pos.x - self.lastInnerContainerPosX) + math.abs(pos.y - self.lastInnerContainerPosY)) > 120 
                    then
                    self.lastInnerContainerPosX = pos.x
                    self.lastInnerContainerPosY = pos.y
                    self._touch_pos = nil
                    self._update_cell = true
                    fwin:addService({
                            callback = function ( params )
                                if #params.touches > 0 then
                                    return
                                end

                                local function responseWorldMapArenaInfoRefreshCallBack(response)
                                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                        if response.node ~= nil and response.node.roots ~= nil then 
                                            -- print("更新地图", #response.node.touches)
                                            response.node._update_cell = false

                                            -- if #response.node.touches == 0 then
                                            --     response.node.currentInnerContainerPosY = response.node.currentInnerContainerPosY + 80
                                            --     response.node.currentInnerContainerPosX = response.node.currentInnerContainerPosX + 160
                                            --     response.node:onUpdate(1)
                                            -- end
                                            
                                            if nil ~= response.node._path_list then
                                                for i, v in pairs(response.node._path_list) do
                                                    local startPosition = response.node.controllerLayer:convertToWorldSpaceAR(cc.p(v._info._s_x, v._info._s_y))
                                                    local endPosition = response.node.controllerLayer:convertToWorldSpaceAR(cc.p(v._info._e_x, v._info._e_y))
                                                    startPosition.x = startPosition.x / app.scaleFactor
                                                    startPosition.y = startPosition.y / app.scaleFactor
                                                    endPosition.x = endPosition.x / app.scaleFactor
                                                    endPosition.y = endPosition.y / app.scaleFactor
                                                    local r = segmentsRect(startPosition, endPosition, cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY))
                                                    if r == false then
                                                        response.node._path_list[v._info._key] = nil
                                                        -- print("删除")
                                                        v:removeFromParent(true)
                                                        return nil
                                                    end
                                                end
                                            end

                                            if nil ~= _ED.world_map.all_target_event_info then
                                                for i, v in pairs(_ED.world_map.all_target_event_info) do
                                                    if table.nums(response.node._path_list) >= 50 then
                                                        return
                                                    end
                                                    if nil ~= v._s_x and nil == response.node._path_list[v._key] then
                                                        local startPosition = response.node.controllerLayer:convertToWorldSpaceAR(cc.p(v._s_x, v._s_y))
                                                        local endPosition = response.node.controllerLayer:convertToWorldSpaceAR(cc.p(v._e_x, v._e_y))
                                                        startPosition.x = startPosition.x / app.scaleFactor
                                                        startPosition.y = startPosition.y / app.scaleFactor
                                                        endPosition.x = endPosition.x / app.scaleFactor
                                                        endPosition.y = endPosition.y / app.scaleFactor
                                                        local r = segmentsRect(startPosition, endPosition, cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY))
                                                        if r ~= false then
                                                            -- print("新增")
                                                            response.node:drawWorldAttackPath(response.node.controllerLayer, v, 1)
                                                        end
                                                    end
                                                end
                                            end

                                            if nil ~= response.node._enemyBossRoadPaths then
                                                for k, v in pairs(response.node._enemyBossRoadPaths) do
                                                    local startPosition = response.node.controllerLayer:convertToWorldSpaceAR(cc.p(v._info._s_x, v._info._s_y))
                                                    local endPosition = response.node.controllerLayer:convertToWorldSpaceAR(cc.p(v._info._e_x, v._info._e_y))
                                                    startPosition.x = startPosition.x / app.scaleFactor
                                                    startPosition.y = startPosition.y / app.scaleFactor
                                                    endPosition.x = endPosition.x / app.scaleFactor
                                                    endPosition.y = endPosition.y / app.scaleFactor
                                                    local r = segmentsRect(startPosition, endPosition, cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY))
                                                    if r == false then
                                                        response.node._enemyBossRoadPaths[k] = nil
                                                        -- print("删除")
                                                        v:removeFromParent(true)
                                                        return nil
                                                    end
                                                end
                                            end

                                            if nil ~= _ED.enemyBossRoadPathInfo then
                                                for k, v in pairs(_ED.enemyBossRoadPathInfo) do
                                                    if nil ~= v._s_x and nil == response.node._enemyBossRoadPaths[k] then
                                                        local startPosition = response.node.controllerLayer:convertToWorldSpaceAR(cc.p(v._s_x, v._s_y))
                                                        local endPosition = response.node.controllerLayer:convertToWorldSpaceAR(cc.p(v._e_x, v._e_y))
                                                        startPosition.x = startPosition.x / app.scaleFactor
                                                        startPosition.y = startPosition.y / app.scaleFactor
                                                        endPosition.x = endPosition.x / app.scaleFactor
                                                        endPosition.y = endPosition.y / app.scaleFactor
                                                        local r = segmentsRect(startPosition, endPosition, cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY))
                                                        if r ~= false then
                                                            -- print("新增")
                                                            local path = response.node:createEnemyBossTankRoadPath(response.node.controllerLayer, v._s_x, v._s_y, v._e_x, v._e_y, 1, 0, v)
                                                            path._info = v
                                                            response.node._enemyBossRoadPaths[""..k] = path
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                protocol_command.world_map_arena_info_refresh.param_list = "" .. params.centerCellX .. "\r\n" .. params.centerCellY
                                NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, self, responseWorldMapArenaInfoRefreshCallBack, false, nil)
                            end,
                            -- delay = 0.1,
                            params = self
                        })
                end
            end
        end
    end, cc.Handler.EVENT_TOUCHES_ENDED)

    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    self.controllerLayer = layer
    self.controllerStartUpdatePosition = cc.p(self.controllerLayer:getPosition())
    -- debug.print_r(self.controllerStartUpdatePosition)
    

    -- cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_anchor"), "")
    -- cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_scale"), "")
    -- cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_coord"), "")

    self.viewSize = self.controllerLayer:getParent():getContentSize()
    self.controllerSize = self.controllerLayer:getContentSize()

    if _ED.world_map ~= nil and _ED.world_map.position_coordinates_x ~= nil and _ED.world_map.position_coordinates_y ~= nil then
        state_machine.excute("adventure_mine_record_view_position", 0, 0)
    end

    --cc.UserDefault:getInstance():setStringForKey(getKey("mine_data_coord"), "" .. -599680.0 .. "," .. -17276)
    local mineCoordData = cc.UserDefault:getInstance():getStringForKey(getKey("mine_data_coord"))
    if mineCoordData == nil or #mineCoordData > 0 then
        local coord_xy = zstring.split(mineCoordData, ",")
        if coord_xy[1] ~= nil and coord_xy[2] ~= nil then
            self.controllerLayer:setPosition(cc.p(coord_xy[1], coord_xy[2]))
            -- print(coord_xy[1], coord_xy[2])
        end
    end

    local mineAnchorData = cc.UserDefault:getInstance():getStringForKey(getKey("mine_data_anchor"))
    if mineAnchorData == nil or #mineAnchorData > 0 then
        local anchor_xy = zstring.split(mineAnchorData, ",")
        if anchor_xy[1] ~= nil and anchor_xy[2] ~= nil then
            self.controllerLayer:setAnchorPoint(cc.p(anchor_xy[1], anchor_xy[2]))
            -- print(anchor_xy[1], anchor_xy[2])
        end
    end

    local mineScaleData = cc.UserDefault:getInstance():getStringForKey(getKey("mine_data_scale"))
    if mineScaleData == nil or #mineScaleData > 0 then
        self.controllerLayer:setScale(mineScaleData)
        -- print(mineScaleData)
    end

    -- print(" ---111Jinlai le zuobiao.",self.controllerStartPosition.x,self.controllerStartPosition.y)
    -- print(" ---111jinlai le selce , ",self.controllerLayer:getScale())
    -- print(" ---111jinlai le andor , ",self.controllerLayer:getAnchorPoint().x,self.controllerLayer:getAnchorPoint().y)

    self.controllerStartPosition = cc.p(self.controllerLayer:getPosition())

    self.currentInnerContainerOrigin = cc.p(self.controllerLayer:getPosition())
    
    self.currentInnerContainerPosY = self.controllerStartPosition.y
    self.currentInnerContainerPosX = self.controllerStartPosition.x

    self.lastInnerContainerPosY = self.currentInnerContainerPosY
    self.lastInnerContainerPosX = self.currentInnerContainerPosX

    self:initMineData()


end

function AdventureMine:initcoord(width)
    local w = width
    local size = w * 2 - 1;
    local cw = math.floor(size / 2)
    local a = {}
    for i = 1, size do
        a[i] = {}
        for j = 1, size do
            a[i][j] = 0
        end
    end

    local ca = {}
    for i = 1, w do
        ca[i] = {}
        -- for j = 1, size do
        --     ca[i][j] = {}
        -- end
    end

    local ta = {}
    for i = 1, size do
        ta[i] = {}
        -- for j = 1, size do
        --     ta[i][j] = 0
        -- end
    end

    local b = 0
    for n = 1, w do
        local idx = w + n - 1
        local line = 1
        for i = 1, w do
            a[line + b][idx] = 1
            ca[w - n + 1][w - i + 1] = {x = idx, y = line + b}
            -- ta[idx .. "," .. (line + b)] = {x = w - i + 1, y = w - n + 1}
            ta[(line + b)][idx] = {x = w - i + 1, y = w - n + 1}
            -- if "12,567" == "" .. (w - i + 1) .. "," .. (w - n + 1) then
            --     print(w - i + 1, w - n + 1, idx .. "," .. (line + b))
            -- end
            if (w - idx) % 2 == 0 then
                line = line + 1
            end
            idx = idx - 1
        end
        if (n - 1) % 2 == 0 then
            b = b + 1
        end
    end

    -- local line = 1
    -- local i = 1
    -- while (i <= len) do
    --     local idx = 1
    --     local j = 1
    --     local s = len - i
    --     while (j <= s) do
    --         a[line][idx] = 0
    --         j = j + 1
    --         idx = idx + 1
    --     end

    --     local k = 1
    --     s = 2 * i - 1
    --     while (k <= s) do
    --         a[line][idx] = 1
    --         k = k + 1
    --         idx = idx + 1
    --     end

    --     j = 1
    --     s = len - i
    --     while (j <=s) do
    --         a[line][idx] = 0
    --         j = j + 1
    --         idx = idx + 1
    --     end
    --     line = line + 1
    --     i = i + 1
    -- end

    -- i = 1
    -- while (i <= len - 1) do
    --     local idx = 1
    --     local j = 1
    --     local s = i
    --     while (j <= s) do
    --         a[line][idx] = 0
    --         j = j + 1
    --         idx = idx + 1
    --     end

    --     local k = size - 1
    --     s = 2 * i - 1
    --     while (k > s) do
    --         a[line][idx] = 1
    --         k = k - 1
    --         idx = idx + 1
    --     end

    --     j = idx - 1
    --     s = size - 1
    --     while (j <= s) do
    --         a[line][idx] = 0
    --         j = j + 1
    --         idx = idx + 1
    --     end
    --     line = line + 1
    --     i = i + 1
    -- end

    -- line = 1
    -- i = size - 1
    -- while (i >= cw) do
    --     local pos = 0
    --     local js = cw - (size - (i + 1))
    --     local j = 0
    --     while (j < w) do
    --         ca[line][pos + 1] = {x = js + j, y = i - pos}
    --         pos = pos + 1
    --         j = j + 1
    --     end
    --     line = line + 1
    --     i = i - 1
    -- end

    -- for i, v in pairs(a) do
    --     local str = ""
    --     for m, n in pairs(v) do
    --         str = str .. n
    --     end
    --     print(str)
    -- end

    -- for i, v in pairs(ca) do
    --     local str = ""
    --     for m, n in pairs(v) do
    --         str = str .. "(x=" .. n.x .. ",y=" ..  n.y .. ")"
    --     end
    --     print(str)
    -- end

    -- debug.print_r(ca)
    return a, ca, ta
end

function AdventureMine:onExit()
    -- state_machine.remove("adventure_mine_reset_update_draw")
    -- state_machine.remove("adventure_mine_reset_add_draw")
    -- state_machine.remove("adventure_mine_reset_update_draw_basics")
    if fwin:find("redAlertTimeMineEventQueueClass") ~= nil then
        state_machine.excute("red_alert_time_mine_pause_refresh", 0, false)
        state_machine.excute("red_alert_time_mine_event_queue_struck_pause_refresh", 0, false)
    end
end