----------------------------------------------------------------------------------------------------
-- 说明：矿山瓦片
----------------------------------------------------------------------------------------------------
AdventureMineTileCell = class("AdventureMineTileCellClass", Window)
AdventureMineTileCell.__size = cc.size(60, 60)
AdventureMineTileCell.lastTimeNode = nil

-- 底图
AdventureMineTileCell._bg_sprite_t0 = {} 
AdventureMineTileCell._bg_sprite_t1 = {} 
AdventureMineTileCell._bg_sprite_t2 = {} 

-- 主城
AdventureMineTileCell._city_armature = {}

-- 保护罩
AdventureMineTileCell._shelter_armature = {}

--等级背景
AdventureMineTileCell._mine_level_bg = {}

--等级
AdventureMineTileCell._mine_level = {}

--名称背景
AdventureMineTileCell._mine_name_bg = {}

-- 军团名背景
AdventureMineTileCell._union_name_bg = {}

-- 军团名文本
AdventureMineTileCell._union_name = {}

-- 城市名背景
AdventureMineTileCell._city_name_bg = {}

--名称
AdventureMineTileCell._mine_name = {}

--军团icon
AdventureMineTileCell._mine_legion_icon = {}

--繁荣度进度条背景
AdventureMineTileCell._mine_glories_bg = {}

--繁荣度进度条
AdventureMineTileCell._mine_pragress = {}

--废墟旗帜
AdventureMineTileCell._mine_occupied = {}


-- 叛军
AdventureMineTileCell._rebel_haunt_armature = {}

--叛军hp
AdventureMineTileCell._rebel_hp_bg = {}
AdventureMineTileCell._rebel_hp = {}

-- 世界boss
AdventureMineTileCell._boss_armature = {}

-- npc
AdventureMineTileCell._mine_armatures = {} 

--矿点的等级
AdventureMineTileCell._mine_quality_level_bg = {} 
--矿点的无品质等级底
AdventureMineTileCell._mine_quality_bg = {} 
--矿点的品质
AdventureMineTileCell._mine_quality = {} 
--占领旗帜
AdventureMineTileCell._mine_my_capture = {}
AdventureMineTileCell._mine_un_capture = {}

-- 矿点类型图标
AdventureMineTileCell._mine_icon = {}

-- 海面动画
AdventureMineTileCell._world_sea_animation = {}
-- 边缘动画
AdventureMineTileCell._world_edge_animation = {}
-- 边缘隔离动画
AdventureMineTileCell._world_edge_layer_animation = {}

-- 装饰
AdventureMineTileCell._tile_sprites = {} 

-- 城市点
AdventureMineTileCell._world_city_armature = {} 

-- 城市点防守人数icon
AdventureMineTileCell._city_defender_icon = {}

-- 工厂等级icon
AdventureMineTileCell._city_factory_level_icon = {}

--教学特殊处理
AdventureMineTileCell.__teach_x = -2 
AdventureMineTileCell.__teach_y = 4 

function AdventureMineTileCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.parent = nil
	self.tileX = 0
	self.tileY = 0
	self.tileType = -1
	self.resource_type = -1
	self.boss_id = -1
	self.schedulerOverID = nil
	self.schedulerStartID = nil
	self.start_bubble_time = 0 
	self.start_bubble_over = 0 
	self.start_play = false
	self.over_play = false
	self.move_close_bubble = false

	app.load("client.adventure.campaign.mine.AdventureMineExploitConfirm")
	app.load("client.adventure.campaign.mine.AdventureMine")
	
	-- Initialize adventure mine tile cell state machine.
	local function init_adventure_mine_tile_cell_terminal()
        -- 开采
        
        local adventure_mine_tile_cell_exploit_terminal = {
            _name = "adventure_mine_tile_cell_exploit",
            _init = function (terminal)
            	app.load("client.adventure.reward.AdventureTipReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
					if cell.tileY == 0 then
						return
					end
					if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
						return false
					end
					_ED.mine_depth_x = cell.tileX
					_ED.mine_deotg_y = cell.tileY-1
					local resoure_type = dms.int(dms["mine_grid"], cell.tileType, mine_grid.resource_type) 
					if resoure_type == 0 and dms.int(dms["mine_grid"], cell.tileType, mine_grid.need_lv) == -1 and dms.int(dms["mine_grid"], cell.tileType, mine_grid.need_explosive_num) == -1 then	
						TipDlg.drawTextDailog(_string_piece_info[414])
						return false
					end
					-- if dms.int(dms["mine_grid"], cell.tileType, mine_grid.need_lv) ~= 999 and zstring.tonumber(cell.tileType) > 0 and dms.int(dms["mine_grid"], cell.tileType, mine_grid.need_lv) > zstring.tonumber(_ED.adventure_lv) then
					-- 	TipDlg.drawTextDailog(_string_piece_info[415])
					-- 	return
					-- end
					if zstring.tonumber(cell.tileType) > 0 and  dms.int(dms["mine_grid"], cell.tileType, mine_grid.min_cd) < 0 and dms.int(dms["mine_grid"], cell.tileType, mine_grid.resource_type) <= 1 then
						if _ED.adventure_mine.current_mine.x ~= 0 or _ED.adventure_mine.current_mine.y ~= 0 then
							TipDlg.drawTextDailog(_string_piece_info[416])
		
							return false
						end
						fwin:open(AdventureMineExploitConfirm:new():init(0,cell,cell.tileType), fwin._ui)
						-- local function responseMineExploitCallback(response)
							-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- if _ED.adventure_mine.mine_data ~= "-1" then
									-- cc.UserDefault:getInstance():setStringForKey(getKey("mine_data"), _ED.adventure_mine.mine_data or "")
								-- end
								-- state_machine.excute("adventure_mine_reset_add_draw", 0, "adventure_mine_reset_add_draw.")
								-- cell.tileType = _ED.adventure_mine.current_mine.mineral_type
								-- cell:updateDraw()
							-- end
						-- end
						-- protocol_command.mineral_explore.param_list = "" .. cell.tileX .. "\r\n" .. cell.tileY .. "\r\n" .. "1"
						-- NetworkManager:register(protocol_command.mineral_explore.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
						
					else
						if cell.tileType == "0" then
							
						else
							if _ED.adventure_mine.current_mine.x ~= 0 or _ED.adventure_mine.current_mine.y ~= 0 then
								if _ED.adventure_mine.current_mine.mining_cd > 0  then 
									TipDlg.drawTextDailog(_string_piece_info[418])
								else 
									TipDlg.drawTextDailog(_string_piece_info[416])
								end
								return false
							end
							
							local resource_type = dms.int(dms["mine_grid"], cell.tileType, mine_grid.resource_type)

							if resource_type >1 then
								local selectSceneId = 0
								local selectNpcId = 0
								local battleScene = zstring.split(dms.string(dms["pirates_config"], 318, pirates_config.param), ",")
								local battleselectNpc = {} --zstring.split(dms.string(dms["pirates_config"], 319, pirates_config.param), ",")
								local parts = zstring.split(dms.string(dms["pirates_config"], 319, pirates_config.param), ",")
								for _, part in pairs(parts) do
									local start_end = zstring.split(part, "-")
									for i = tonumber(start_end[1]), tonumber(start_end[2]) do
										table.insert(battleselectNpc, i)
									end
								end
								if resource_type == 2 then
									selectSceneId = zstring.tonumber(battleScene[1])
									local levelNpc = zstring.tonumber(_ED._mine_monster_zabing_lv)+1
									if levelNpc >= 260 then 
										levelNpc = 260
									end
									selectNpcId = zstring.tonumber(battleselectNpc[levelNpc])
								elseif resource_type == 3 then
									selectSceneId = zstring.tonumber(battleScene[2])
									local parts = zstring.split(_ED._mine_monster_boss_lv, "|")
									for _, part in pairs(parts) do
										local xyNpc = zstring.split(part, ",")
										if (zstring.tonumber(xyNpc[1]) == zstring.tonumber(cell.tileX) and zstring.tonumber(xyNpc[2]) == zstring.tonumber(cell.tileY)) then
											selectNpcId = xyNpc[3]
										end
									end
								elseif resource_type == 6 then
									app.load("client.adventure.campaign.mine.event.AdventureMineEventNpcDlg")

									fwin:open(AdventureMineEventNpcDlg:new():init(2,cell), fwin._ui)

									return true
								elseif resource_type == 7 then
									app.load("client.adventure.duplicate.event.AdventureDuplicateEventBossDlg")
									fwin:open(AdventureDuplicateEventBossDlg:new():init(2,cell), fwin._view)
									return true
								elseif resource_type == 4 then
									if (zstring.tonumber(_ED.adventure_mine.current_mine.mine_time) + zstring.tonumber(_ED.adventure_mine.current_mine.mining_cd)+1) - os.time() <= 0 then
										local function responseMineBoxCallback(response)
											-- print(response.resouce)
											AdventureMineTileCell.lastTimeNode = nil
											if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
												if response.node ~= nil and response.node.roots ~= nil then
													
													response.node.__tile._exploit = true
													response.node.__tile._focus = response.node
        
													local reward = getSceneReward(57)
						
													if reward ~= nil then 
														fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
													end
													state_machine.excute("adventure_mine_exploit_open", 0, {node = response.node , iswakuang = true})
													state_machine.excute("adventure_mine_reset_add_draw", 0, "adventure_mine_reset_add_draw.")
													state_machine.excute("adventure_mine_exploit_open_success", 0, {node = response.node })
										
												end
											end
										end
										AdventureMineTileCell.lastTimeNode = cell
										protocol_command.mineral_explore.param_list = "" .. cell.tileX .. "\r\n" .. cell.tileY .. "\r\n" .. "0"
										NetworkManager:register(protocol_command.mineral_explore.code, nil, nil, nil, cell, responseMineBoxCallback, false, nil)
									end
									return true
								end
								
								if AdventureMineTileCell.lastTimeNode ~= nil and AdventureMineTileCell.lastTimeNode == "3" then 
									-- 防止玩家快速点击后,挖矿的那一个动画没有结束,无法刷新
									TipDlg.drawTextDailog(_string_piece_info[419])
									return false
								end
								-- print("zhandou")
								app.load("client.adventure.duplicate.AdventureDuplicateBattleDlg")
								fwin:open(AdventureDuplicateBattleDlg:new():init(selectSceneId, selectNpcId, 0, 2, cell), fwin._ui)
							else
								if (zstring.tonumber(_ED.adventure_mine.current_mine.mine_time) + zstring.tonumber(_ED.adventure_mine.current_mine.mining_cd)+1) - os.time() <= 0 then
									local function responseMineExploitCallback(response)
										-- print(response.resouce)
										AdventureMineTileCell.lastTimeNode = nil
										if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
											if response.node ~= nil and response.node.roots ~= nil then
												response.node.__tile._exploit = true

												response.node.__tile._focus = response.node
												state_machine.excute("adventure_mine_manager_mine_boss_action", 0, 0)
												state_machine.excute("adventure_mine_exploit_open", 0, {node = response.node , iswakuang = true})
												state_machine.excute("adventure_mine_reset_add_draw", 0, "adventure_mine_reset_add_draw.")
												state_machine.excute("adventure_mine_exploit_open_success", 0, {node = response.node })
												local cell_cd = dms.int(dms["mine_grid"], response.node.tileType, mine_grid.min_cd)
												local resource_type = dms.int(dms["mine_grid"], response.node.tileType, mine_grid.resource_type)
												if  cell_cd == 1 and resource_type == 1 then 
													getSceneReward(57) 
												end
											end
										end
									end
									AdventureMineTileCell.lastTimeNode = cell
									protocol_command.mineral_explore.param_list = "" .. cell.tileX .. "\r\n" .. cell.tileY .. "\r\n" .. "0"
									NetworkManager:register(protocol_command.mineral_explore.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
								end
							end
						end
					end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        -- 闪烁
        local adventure_mine_focus_blink_terminal = {
            _name = "adventure_mine_focus_blink",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.lock("red_alert_time_mine_cell_click")
            	local cell = params
            	if cell == nil then
            		state_machine.unlock("red_alert_time_mine_cell_click")
            	end
            	local sprite = nil
				-- if cell._openType == 1 then
				-- 	sprite = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_mine")._sprite
				-- elseif cell._openType == 2 then
				-- 	sprite = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_mine").__blink_sprite
				-- end
				if nil ~= cell.__blink_sprite then
					sprite = cell.__blink_sprite
				elseif nil ~= cell.__mine_sprite then
					sprite = cell.__mine_sprite
				elseif nil ~= cell.__tile_sprite then
					sprite = cell.__tile_sprite
				end
			 	function blinkInCallback(sender)
			 		sender:setColor(cc.c3b(130, 130, 130))
			 	end

			 	function blinkOutCallback(sender)
			 		sender:setColor(cc.c3b(255, 255, 255))
			 	end
				
				function openEedAlertTimeMine()
					if cell ~= nil and cell.info ~= nil then
						local function excuteClick( cell )
							if cell._openType == 1 then
								-- debug.print_r(cell.info)
								state_machine.excute("red_alert_time_mine_resource_point_operation_interface_open", 0, {_datas = {cell = cell}})
							elseif cell._openType == 2 then
								if zstring.tonumber(cell.info._shield_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) < 0 then
									local _glories = zstring.tonumber(cell.info._glories)
								    if cell.info._online_state == 1 then
										local s_time = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(cell.info._boom_restore_time)/1000
									    _glories = getBoomReplyalgorithm(zstring.tonumber(cell.info._glories),zstring.tonumber(cell.info._max_boom),s_time)
								    end
									local boom_state = 0
								    local boom_bar = zstring.tonumber(_glories)/zstring.tonumber(cell.info._max_boom)
								    for i= 1, dms.count(dms["build_boom_lose"]) do
								        local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
								        if boom_bar >= tonumber(boom_proportion) then
								            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
								            break
								        end
								    end
								    -- local talentTime = tonumber(cell.info._talent_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
								    -- if talentTime<= 0 then
								    -- 	sprite:getAnimation():playWithIndex(boom_state)
								    -- end
								 --    local ccax, ccay = cc.dms_init_world_map_get(1, zstring.tonumber(cell.info._x), zstring.tonumber(cell.info._y))
									-- x = ccax - 600
									-- y = ccay - 1
									-- local ceng = y*_ED.mine_tile_width + x
								 --    local size = cell.__blink_sprite:getContentSize()
								 --    cell:updateDrawUserCityInfo(size,ceng,_glories,boom_state)
								end
								state_machine.excute("red_alert_time_mine_base_operation_interface_open", 0, {_datas = {cell = cell}})
							elseif cell._openType == 3 then
								state_machine.excute("rebel_haunt_attack_open", 0, {_datas = {cell = cell}})
							elseif cell._openType == 4 then
								app.load("client.red_alert_time.campaign.EnemyStrikeWorldBox")
								state_machine.excute("enemy_strike_world_box_open", 0, nil)
							elseif cell._openType == 5 then
								app.load("client.red_alert_time.legion.LegionCityInforAttack")
								state_machine.excute("legion_city_infor_attack_window_open", 0, {cell.info._mould_id, cell.info})
							end
						end
						if cell._openType == 1
							or cell._openType == 2
							or cell._openType == 3 
							then
		                    local function responseCallBack(response)
		                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		                        	if response.node ~= nil and response.node.roots ~= nil then
			                            excuteClick(response.node)
			                        end
		                        end
		                    end
		                    protocol_command.world_check_investigate_end_time.param_list = cell.info._x .. "\r\n" .. cell.info._y
		                    NetworkManager:register(protocol_command.world_check_investigate_end_time.code, nil, nil, nil, cell, responseCallBack, false, nil)
						else
							excuteClick(cell)
						end
						cell:updateMapTileEx()
					end
					state_machine.unlock("red_alert_time_mine_cell_click")
				end
				if cell._openType == 3 
					or cell._openType == 4 
					or cell._openType == 5 
					then
					openEedAlertTimeMine()
				else
					if sprite == nil or sprite.runAction == nil then
						state_machine.unlock("red_alert_time_mine_cell_click")
						return
					end
					sprite:runAction(cc.Sequence:create(
						-- cc.DelayTime:create(0.1),
						cc.CallFunc:create(blinkInCallback),
						cc.DelayTime:create(0.1),
						cc.CallFunc:create(blinkOutCallback),
						-- cc.DelayTime:create(0.1),
						-- cc.CallFunc:create(blinkInCallback),
						-- cc.DelayTime:create(0.1),
						-- cc.CallFunc:create(blinkOutCallback),
						cc.CallFunc:create(openEedAlertTimeMine)
						))
				end
				fwin:addService({
						callback = function ( params )
							state_machine.unlock("red_alert_time_mine_cell_click")
						end,
						delay = 0.6,
						params = self
					})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--地块动画
		local adventure_mine_plots_animation_terminal = {
            _name = "adventure_mine_plots_animation",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.lock("red_alert_time_mine_cell_click")
            	local cell = params
				local sprite=cc.Sprite:create("images/ui/share/click_locking.png");
				sprite:setAnchorPoint(cc.p(0.5,0.5))
				sprite:setTag(500)
				cell:addChild(sprite)
			 	function blinkInCallback(sender)
			 		-- sender.CCFadeTo:create(0, 10)
					local fadeIn = cc.FadeTo:create(0.1, 0)
					local fadeOut = cc.FadeTo:create(0.2, 255)
					sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeIn, fadeOut)))
			 	end

			 	function blinkOutCallback(sender)
			 		-- sender:setColor(cc.c3b(255, 255, 255))
					-- sender.CCFadeTo:create(1, 10)
					local fadeIn = cc.FadeTo:create(0.1, 255)
					local fadeOut = cc.FadeTo:create(0.2, 0)
					sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeIn, fadeOut)))
			 	end
				
				function openEedAlertTimeMine()
					local param =zstring.split(dms.string(dms["world_config"], 7 , world_config.param),"|")
					local datas = zstring.split(param[1],",")
					for i,v in pairs(_ED.user_prop) do
						if tonumber(v.user_prop_template) == tonumber(datas[1]) then
							state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 8}})
							if cell:getChildByTag(500) ~= nil then 
								cell:removeChildByTag(500)
							end 
							state_machine.unlock("red_alert_time_mine_cell_click")
							return
						end
					end
					state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 1}})
					if cell:getChildByTag(500) ~= nil then 
						cell:removeChildByTag(500)
					end 
					state_machine.unlock("red_alert_time_mine_cell_click")
				end

			 	sprite:runAction(cc.Sequence:create(
			 		cc.DelayTime:create(0.1),
			 		cc.CallFunc:create(blinkInCallback),
			 		cc.DelayTime:create(0.1),
			 		cc.CallFunc:create(blinkOutCallback),
			 		cc.DelayTime:create(0.1),
			 		cc.CallFunc:create(blinkInCallback),
					cc.CallFunc:create(openEedAlertTimeMine)
			 		))
					
					fwin:addService({
						callback = function ( params )
							state_machine.unlock("red_alert_time_mine_cell_click")
						end,
						delay = 0.6,
						params = self
					})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local red_alert_time_mine_cell_click_terminal = {
			_name = "red_alert_time_mine_cell_click",
			_init = function (terminal) 
				app.load("client.red_alert_time.worldMap.redAlertTimeMineBaseOperationInterface")
				app.load("client.red_alert_time.worldMap.redAlertTimeMineResourcePointOperationInterface")
				app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
				app.load("client.red_alert_time.campaign.RebelHauntAttack")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("world_input_window_close", 0, 0)
				if zstring.tonumber(params._datas.cell.tileType) > 0 then
					local x_x = zstring.tonumber(params._datas.cell.tileX)
					local y_y = zstring.tonumber(params._datas.cell.tileY)
					local mx = 599 + x_x + 1
					local my = y_y + 1
					-- local ta = _ED.cta[my][mx]
					local ta = {}
					local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
					ta.x = ta_x
					ta.y = ta_y
					local m_info = _ED.world_map.world_map_info_list[ta.x .. "," .. ta.y]
					if m_info ~= nil then
						-- 叛军
						if m_info._type == 1000 then
							-- state_machine.excute("rebel_haunt_attack_open", 0, {m_info})
							if tonumber(m_info._now_hp) > 0 then
								params._datas.cell._openType = 3
								state_machine.excute("adventure_mine_focus_blink", 0, params._datas.cell)
							else
								state_machine.excute("adventure_mine_plots_animation", 0, params._datas.cell)
							end
						elseif m_info._type >= 1 and m_info._type <= 5 then
							--资源
							params._datas.cell._openType = 1
							state_machine.excute("adventure_mine_focus_blink", 0, params._datas.cell)
						elseif m_info._type == 0 then
							--玩家
							params._datas.cell._openType = 2
							state_machine.excute("adventure_mine_focus_blink", 0, params._datas.cell)
						elseif m_info._type == 2000 then
							params._datas.cell._openType = 4
							state_machine.excute("adventure_mine_focus_blink", 0, params._datas.cell)
						elseif m_info._type == 3000
							or m_info._type == 3001 
							or m_info._type == 3002 
							then
							params._datas.cell._openType = 5
							state_machine.excute("adventure_mine_focus_blink", 0, params._datas.cell)	
						else
							-- state_machine.excute("red_alert_time_mine_warm_tips_open", 0, params._datas.cell)
							state_machine.excute("adventure_mine_plots_animation", 0, params._datas.cell)
							
						end
					else
						-- state_machine.excute("red_alert_time_mine_warm_tips_open", 0, params._datas.cell)
						state_machine.excute("adventure_mine_plots_animation", 0, params._datas.cell)
					end
					-- if m_info ~= nil and zstring.tonumber(m_info._type) > 1 and zstring.tonumber(m_info._id) ~= -1 then
					-- 	--资源
					-- 	state_machine.excute("red_alert_time_mine_resource_point_operation_interface_open", 0, {_datas = {cell = params._datas.cell,}})
					-- elseif m_info ~= nil and zstring.tonumber(m_info._type) == 0 then
					-- 	--玩家
					-- 	state_machine.excute("red_alert_time_mine_base_operation_interface_open", 0, {_datas = {cell = params._datas.cell,}})
					-- else
					-- 	--空地
					-- end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		--矿点被攻击的动画
		local red_alert_time_mine_cell_was_hit_terminal = {
			_name = "red_alert_time_mine_cell_was_hit",
			_init = function (terminal) 
		
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("adventure_mine_get_cells_obj", 0, {params[1],params[2]})
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(adventure_mine_tile_cell_exploit_terminal)
		state_machine.add(adventure_mine_focus_blink_terminal)
		state_machine.add(red_alert_time_mine_cell_click_terminal)
		state_machine.add(adventure_mine_plots_animation_terminal)
		state_machine.add(red_alert_time_mine_cell_was_hit_terminal)
        state_machine.init()
	end

	-- call func init adventure mine tile cell state machine.
	init_adventure_mine_tile_cell_terminal()
end

function AdventureMineTileCell:onEnterTransitionFinish()
	--AdventureMineTileCell.lastTimeNode = nil
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self:registerOnNoteUpdate(self, 2)
	else
		if self.resource_type == 7 then 
	 		self:registerOnNoteUpdate(self, 0)
	 	else
	 		self:unregisterOnNoteUpdate(self, 0)
		end
	end

	-- if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	-- 	local root = self.roots[1]
	-- 	if root == nil then 
	-- 		return false
	-- 	end
	-- 	local tile = ccui.Helper:seekWidgetByName(root, "Panel_mine")
	-- 	local size = tile:getContentSize()
	-- 	local pos = cc.p(tile:getPosition())

	-- 	if nil ~= self._bg_sprite then
	-- 		self._bg_sprite:removeFromParent(true)
	-- 		self._bg_sprite = nil
	-- 	end

	-- 	local bgsprite = null

	-- 	if zstring.tonumber(self.tileType) == 0 then
	-- 		-- bg:setBackGroundImage("map/world_npc/world_surface_3.png")
	-- 		bgsprite = cc.Sprite:create("map/world_npc/world_surface_3.png")
	-- 	else
	-- 		if zstring.tonumber(self.tileX)%2==0 then
	-- 			-- bg:setBackGroundImage("map/world_npc/world_surface_1.png")
	-- 			bgsprite = cc.Sprite:create("map/world_npc/world_surface_1.png")
	-- 		else
	-- 			-- bg:setBackGroundImage("map/world_npc/world_surface_2.png")
	-- 			bgsprite = cc.Sprite:create("map/world_npc/world_surface_2.png")
	-- 		end
	-- 	end
	-- 	bgsprite:setPosition(pos)
	-- 	self:getParent():addChild(bgsprite, -1)
	-- 	tile._bg_sprite = bgsprite
	-- end
end

function AdventureMineTileCell:onUpdate(dt)
	if self.info ~= nil 
		and (self.info._type == 3000
		or self.info._type == 3001
		or self.info._type == 3002
		)
		then
		if self.__rebel_hp ~= nil then
			if self.info._progress_tick_time ~= 0 then
				local add_time = (os.time() - self.info._progress_start_time)
	            local current_time = tonumber(self.info._progress)
	            local percent = 0
	            if self.info._union_name == self.info._progress_union_name then
	                current_time = current_time - add_time * self.info._add_time_speed
	                percent = (self.__capture_time - current_time) * 100 / self.__capture_time
	            else
	                current_time = current_time - add_time / self.__less_percent
	                percent = current_time * 100 / self.__capture_time
	            end
				percent = math.ceil(percent)
				if percent >= 100 then
					percent = 100
				elseif percent <= 0 then
					percent = 0
				end
				self.__rebel_hp:setPercent(percent)
				if self.__city_progress_name ~= nil then
					self.__city_progress_name:setString(percent.."%")
				end
			end
		end
	end
	if __lua_project_id == __lua_project_red_alert_time
		or __lua_project_id == __lua_project_pacific_rim
		then
		return
	end

	if AdventureMine.__isCanClick == false then 
		if self.move_close_bubble == false then 
			self.move_close_bubble = true
			state_machine.excute("adventure_mine_boss_bubble_draw",0 ,{node = self,isOpen = false})	
		end
		self.start_bubble_time = 0 
		self.start_bubble_over = 0 
		self.start_play = false
		self.over_play = false	
		return
	end
	self.move_close_bubble = false
	self.start_bubble_time = dt + self.start_bubble_time 
	if self.start_bubble_time > 5 and self.start_play  == false then 
		self.start_play = true
		self.over_play = false
		self.start_bubble_time = 0 
		self.start_bubble_over = 0 
		state_machine.excute("adventure_mine_boss_bubble_draw",0 ,{node = self,isOpen = true})	
	end
	self.start_bubble_over = self.start_bubble_over + dt
	if self.start_bubble_over >= 10 and self.over_play == false and self.start_play == true then 
		self.over_play = true
		self.start_bubble_time = 0 
		self.start_play = false
		state_machine.excute("adventure_mine_boss_bubble_draw",0 ,{node = self,isOpen = false})	
	end
end

--正常形象读取
function AdventureMineTileCell:normalShowDraw(boom_state,ceng)
	--清除之前的基地资源
	if zstring.tonumber(self.__blink_sprite._pic) > 0 then
		self.__blink_sprite:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_armatures[self.__blink_sprite._pic], self.__blink_sprite)
		self.__blink_sprite = nil
		self.__blink_sprite = table.remove(AdventureMineTileCell._city_armature, 1, 1)
		if nil == self.__blink_sprite then
			local fileName = "map/base_npc/spirte_beattacked.ExportJson"
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
			local sprite = ccs.Armature:create("spirte_beattacked")
			sprite:retain()
			-- table.insert(AdventureMineTileCell._city_armature, sprite)
			self.__blink_sprite = sprite
		end
		if nil == self.__blink_sprite._parent then
			self.parent:addChild(self.__blink_sprite,ceng)
			self.__blink_sprite._parent = self.parent
		end
		local pos = cc.p(self:getPosition())
		self.__blink_sprite:setPosition(pos)
	end

	local level_Info = self.info._level
	 if tonumber(self.info._userId) == tonumber(_ED.user_info.user_id) then
		level_Info = _ED.user_info.user_grade
	else
		local max_id = dms.int(dms["arena_config"],10,arena_config.param)
		if tonumber(self.info._userId) <= max_id then
			level_Info = dms.string(dms["world_config"], 20 , world_config.param)
		end
	end
	local pic = zstring.split(dms.string(dms["user_experience_param"], level_Info, user_experience_param.base_pic),",")
	if __lua_project_id == __lua_project_pacific_rim then
		local mx = 599 + self.tileX + 1
		local my = self.tileY + 1
		local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
		if ta_x > 0 and ta_y > 0 then
			local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
			if pic_index == 0 then
				self.__blink_sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]) + 17)
			else
				self.__blink_sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]))
			end
		end
	else
		self.__blink_sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]))
	end
end

function AdventureMineTileCell:updateDrawAllComponents(boom_state,ceng)
	--城池形象变更
	if self.info._type == 2000
		or self.info._type == 3000
		or self.info._type == 3001
		or self.info._type == 3002
		then
		return
	end
	if nil ~= self.__blink_sprite 
		and self.info._type ~= 1000 
		then
		-- local build_ids = nil
		-- local picData = nil
		-- local talentTime = nil
		self.__blink_sprite:setScale(1)
		if self.info.talent ~= nil and self.info.talent ~="" then
			-- build_ids = zstring.split(dms.string(dms["talent_mould"],tonumber(self.info._talent_id), talent_mould.base_additional), "|")
			-- picData = zstring.split(build_ids[1], ",")
			for i, v in pairs(self.info._talent_end_time) do
				local talentTime = tonumber(v)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
				if talentTime <=0 then
					NetworkManager:register(protocol_command.gain_limit_check.code, nil, nil, nil, nil, nil, false, nil)
				end
			end
			for i, v in pairs(self.info._talent_sta_time) do
				if (self._talent_sta_time == nil) and (i=="70" or i=="83") then
					self._talent_sta_time = tonumber(v)
				elseif i=="70" or i=="83" then
					if tonumber(v) > self._talent_sta_time then
						self._talent_sta_time = tonumber(v)
					end
				end
			end
		end
		if self.info._talent_id["70"] ~= nil and self._talent_sta_time == tonumber(self.info._talent_sta_time["70"]) then
			local talentTime = tonumber(self.info._talent_end_time["70"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
			if talentTime > 0 then
				--清除之前的基地资源
				if zstring.tonumber(self.__blink_sprite._pic) > 0 then
					self.__blink_sprite:removeFromParent(true)
					table.insert(AdventureMineTileCell._mine_armatures[self.__blink_sprite._pic], self.__blink_sprite)
					self.__blink_sprite = nil
					self.__blink_sprite = table.remove(AdventureMineTileCell._city_armature, 1, 1)
					if nil == self.__blink_sprite then
						local fileName = "map/base_npc/spirte_beattacked.ExportJson"
						ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
						local sprite = ccs.Armature:create("spirte_beattacked")
						sprite:retain()
						-- table.insert(AdventureMineTileCell._city_armature, sprite)
						self.__blink_sprite = sprite
					end
					if nil == self.__blink_sprite._parent then
						self.parent:addChild(self.__blink_sprite,ceng)
						self.__blink_sprite._parent = self.parent
					end
					local pos = cc.p(self:getPosition())
					self.__blink_sprite:setPosition(pos)
				end
				local build_ids = zstring.split(dms.string(dms["talent_mould"],tonumber(self.info._talent_id["70"]), talent_mould.base_additional), "|")
				local picData = zstring.split(build_ids[1], ",")
				if __lua_project_id == __lua_project_pacific_rim then
					local mx = 599 + self.tileX + 1
					local my = self.tileY + 1
					local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
					if ta_x > 0 and ta_y > 0 then
						local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
						if pic_index == 0 then
							self.__blink_sprite:getAnimation():playWithIndex(tonumber(picData[2]) + 17)
						else
							self.__blink_sprite:getAnimation():playWithIndex(tonumber(picData[2]))
						end
					end
				else
					self.__blink_sprite:getAnimation():playWithIndex(tonumber(picData[2]))
				end
			else
				self:normalShowDraw(boom_state,ceng)
			end
		elseif self.info._talent_id["83"] ~= nil and self._talent_sta_time == tonumber(self.info._talent_sta_time["83"]) then	
			local talentTime = tonumber(self.info._talent_end_time["83"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
			if talentTime > 0 then
				local build_ids = zstring.split(dms.string(dms["talent_mould"],tonumber(self.info._talent_id["83"]), talent_mould.base_additional), "|")
				local picData = zstring.split(build_ids[1], ",")
				--清除之前的基地资源
				self.__blink_sprite:removeFromParent(true)
				table.insert(AdventureMineTileCell._city_armature, self.__blink_sprite)
				self.__blink_sprite = nil
				--加载绘制基地形象矿点形象资源
				local element = dms.element(dms["world_mine_mould"], tonumber(picData[2]))
				local pic = dms.atos(element, world_mine_mould.pic)
				local sprite = nil
				local size = nil
				AdventureMineTileCell._mine_armatures[pic] = AdventureMineTileCell._mine_armatures[pic] or {}
				self.__blink_sprite = table.remove(AdventureMineTileCell._mine_armatures[pic], 1, 1)
				if nil == self.__blink_sprite then
					local effect_paths = string.format(config_res.images.ui.home.home_build_effect, tonumber(pic))
			        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
					self.__blink_sprite = ccs.Armature:create("home_build_"..pic)
					self.__blink_sprite:retain()
				end
				self.__blink_sprite._pic = pic
				self.__blink_sprite:setScale(0.75)
				local pos = cc.p(self:getPosition())
				pos.y = pos.y + AdventureMineTileCell.__size.height/2 - 18

				local armature_index = dms.atoi(element, world_mine_mould.armature_index)
				if __lua_project_id == __lua_project_pacific_rim then
					local mx = 599 + self.tileX + 1
					local my = self.tileY + 1
					local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
					if ta_x > 0 and ta_y > 0 then
						local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
						if pic_index == 0 then
							self.__blink_sprite:getAnimation():playWithIndex(armature_index + 4)
						else
							self.__blink_sprite:getAnimation():playWithIndex(armature_index)
						end
					end
				else
					self.__blink_sprite:getAnimation():playWithIndex(armature_index)
				end
				self.__blink_sprite:setAnchorPoint(cc.p(0.5, 0.5))
				self.parent:addChild(self.__blink_sprite,ceng)
				self.__blink_sprite._parent = self.parent	
				self.__blink_sprite:setPosition(pos)
			else
				self:normalShowDraw(boom_state,ceng)
			end
		else
			self:normalShowDraw(boom_state,ceng)
		end
	end

	--防护罩
	if nil ~= self.__shelter_sprite then
		if zstring.tonumber(self.info._shield_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) <= 0 then
			self.__shelter_sprite:removeFromParent(true)
			table.insert(AdventureMineTileCell._shelter_armature, self.__shelter_sprite)
			self.__shelter_sprite._parent = nil
			self.__shelter_sprite = nil
		end
	end
	--军团icon
	local have_legion_icon = false
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
        have_legion_icon = false
    else
		if tonumber(self.info._userId) == tonumber(_ED.user_info.user_id) or 
			(tonumber(self.info._union_id)~=-1 and tonumber(self.info._union_id) == tonumber(_ED.union.union_info.union_id))
			then
			have_legion_icon = true
		else
	        have_legion_icon = false
		end	
    end
    if have_legion_icon == false then
		if nil ~= self.__mine_legion_icon then
			self.__mine_legion_icon:removeFromParent(true)
			table.insert(AdventureMineTileCell._mine_legion_icon, self.__mine_legion_icon)
			self.__mine_legion_icon = nil
		end
	end

	--繁荣度
	if self.__mine_pragress ~= nil then
		local glories = zstring.tonumber(self.info._glories)/zstring.tonumber(self.info._max_boom)*100
	    local _glories = zstring.tonumber(self.info._glories)
	    if self.info._online_state == 1 then
			local s_time = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self.info._boom_restore_time)/1000
	    	_glories = getBoomReplyalgorithm(zstring.tonumber(self.info._glories),zstring.tonumber(self.info._max_boom),s_time)
	    end
	    if tonumber(self.info._userId) == tonumber(_ED.user_info.user_id) then
			_glories = zstring.tonumber(_ED.user_info.booming)
			self.info._max_boom = zstring.tonumber(_ED.user_info.forage)
		end
		local boom_state = 0
	    local boom_bar = zstring.tonumber(_glories)/zstring.tonumber(self.info._max_boom)
	    for i= 1, dms.count(dms["build_boom_lose"]) do
	        local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
	        if boom_bar >= tonumber(boom_proportion) then
	            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
	            break
	        end
	    end
		local glories = zstring.tonumber(_glories)/zstring.tonumber(self.info._max_boom)*100
		self.__mine_pragress:setPercent(glories)
		if boom_state == 2 then
			self.__mine_pragress:loadTexture("images/ui/share/loading_boom_bar_2.png")
		elseif boom_state == 1 then
			self.__mine_pragress:loadTexture("images/ui/share/loading_boom_bar_1.png")
		else
			self.__mine_pragress:loadTexture("images/ui/share/loading_boom_bar.png")
		end
	end
	--废墟旗帜
	if self.__mine_occupied ~= nil then
		if boom_state ~= 2 then
			self.__mine_occupied:removeFromParent(true)
			table.insert(AdventureMineTileCell._mine_occupied, self.__mine_occupied)
			self.__mine_occupied = nil
		end
	end
	-- 叛军hp
	if self.__rebel_hp_bg ~= nil then
		if tonumber(self.info._now_hp) > 0 then
			local percent = (self.info._now_hp * 100 / self.info._max_hp)
			self.__rebel_hp:setPercent(percent)
		else
			self.__rebel_hp_bg:removeFromParent(true)
			table.insert(AdventureMineTileCell._rebel_hp_bg, self.__rebel_hp_bg)
			self.__rebel_hp_bg = nil

			self.__rebel_hp:removeFromParent(true)
			table.insert(AdventureMineTileCell._rebel_hp, self.__rebel_hp)
			self.__rebel_hp = nil
		end
	end
	--矿点的富矿标识
	if self.__mine_quality ~= nil then
		local element = dms.element(dms["world_mine_mould"], self.info._mould_id)
		local mine_type = dms.atoi(element, world_mine_mould.mine_type)
		local mine_quelity_level_up_param = dms.atos(element, world_mine_mould.quelity_level_up_param)
		local per_minute_sub_exp = dms.atoi(element, world_mine_mould.per_minute_sub_quelity_level_up_exp)
		local richOreValue = zstring.split(mine_quelity_level_up_param ,",")
		local quality_id = tonumber(self.info._quality)
		local quality_level_up_exp = self.info._quality_level_up_exp
		if tonumber(self.info._userId) == -1 then
			local m_times = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self.info._mining_time)/1000
			if m_times > 0 then
				quality_level_up_exp = self.info._quality_level_up_exp - math.floor(math.floor(m_times/60)*per_minute_sub_exp)
				if quality_level_up_exp <= 0 then
					quality_level_up_exp = 0
				end
			end
			local isVariety = false
			for i=1, #richOreValue do
				if self.info._quality_level_up_exp >= tonumber(richOreValue[i]) then
					quality_id = i
					isVariety = true
				end
			end
			if quality_id>=3 then
				quality_id=3
			end
			if isVariety == false then
				quality_id = 0
			end
		elseif tonumber(self.info._userId) > 0 then	
			--有富矿隐藏数据
			if self.info.talent ~= "" and self.info.talent ~= nil then
				if self.info._talent_id["76"] ~= nil then
					local talentTime = tonumber(self.info._talent_end_time["76"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
					if talentTime > 0 then
						quality_id = 0
					end
				end
			end
		end

		--疯狂矿工,隐藏富矿
		if _ED.activity_info["87"] ~= nil then
	        local timesData = zstring.split(_ED.activity_info["87"].activity_add_state, ",")
	        local activity_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
	        if activity_times > 0 then
	            quality_id = 0
	        end
	    end

		if quality_id <= 0 then
			if self.__mine_quality ~= nil then
				self.__mine_quality:removeFromParent(true)
				table.insert(AdventureMineTileCell._mine_quality[zstring.tonumber(self.__mine_quality.pic)], self.__mine_quality)
				self.__mine_quality = nil
				if self.__mine_quality_level_bg ~= nil then
					self.__mine_quality_level_bg:setContentSize(cc.size(self.__mine_quality_level_bg._m_width, self.__mine_quality_level_bg:getContentSize().height))
					self.__mine_quality_level_bg:removeFromParent(true)
					table.insert(AdventureMineTileCell._mine_quality_level_bg[zstring.tonumber(self.__mine_quality_level_bg.pic)], self.__mine_quality_level_bg)
					self.__mine_quality_level_bg = nil
				end
			end
		else
			if self.__mine_quality_bg ~= nil then
				self.__mine_quality_bg:setContentSize(cc.size(self.__mine_quality_bg._m_width, self.__mine_quality_bg:getContentSize().height))
				self.__mine_quality_bg:removeFromParent(true)
				table.insert(AdventureMineTileCell._mine_quality_bg, self.__mine_quality_bg)
				self.__mine_quality_bg = nil
			end
		end	
	end
	--矿点占领标识
	if self.__mine_my_capture ~= nil then
		if zstring.tonumber(self.info._userId) ~= zstring.tonumber(_ED.user_info.user_id) then
			self.__mine_my_capture:removeFromParent(true)
			table.insert(AdventureMineTileCell._mine_my_capture, self.__mine_my_capture)
			self.__mine_my_capture = nil
		end
	end
	if self.__mine_un_capture ~= nil then
		if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            or zstring.tonumber(_ED.union.union_info.union_id) ~= zstring.tonumber(self.info._union_id)
            then
            self.__mine_un_capture:removeFromParent(true)
			table.insert(AdventureMineTileCell._mine_un_capture, self.__mine_un_capture)
			self.__mine_un_capture = nil
        end        
	end
end

function AdventureMineTileCell:updateDrawMineLevel(size,ceng)
	local pos = cc.p(self:getPosition())
	local element = dms.element(dms["world_mine_mould"], self.info._mould_id)
	local mine_type = dms.atoi(element, world_mine_mould.mine_type)
	local mine_quelity_level_up_param = dms.atos(element, world_mine_mould.quelity_level_up_param)
	local per_minute_sub_exp = dms.atoi(element, world_mine_mould.per_minute_sub_quelity_level_up_exp)
	local richOreValue = zstring.split(mine_quelity_level_up_param ,",")
	local quality_id = tonumber(self.info._quality)
	local quality_level_up_exp = self.info._quality_level_up_exp
	if tonumber(self.info._userId) == -1 then
		local m_times = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self.info._mining_time)/1000
		if m_times > 0 then
			quality_level_up_exp = self.info._quality_level_up_exp - math.floor(math.floor(m_times/60)*per_minute_sub_exp)
			if quality_level_up_exp <= 0 then
				quality_level_up_exp = 0
			end
		end
		local isVariety = false
		for i=1, #richOreValue do
			if quality_level_up_exp >= tonumber(richOreValue[i]) then
				quality_id = i
				isVariety = true
			end
		end
		if quality_id>=3 then
			quality_id=3
		end
		if isVariety == false then
			quality_id = 0
		end
	elseif tonumber(self.info._userId) > 0 then
		--有富矿隐藏数据
		if self.info.talent ~= "" and self.info.talent ~= nil then
			if self.info._talent_id["76"] ~= nil then
				local talentTime = tonumber(self.info._talent_end_time["76"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
				if talentTime > 0 then
					quality_id = 0
				end
			end
		end
	end

	--疯狂矿工,隐藏富矿
	if _ED.activity_info["87"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["87"].activity_add_state, ",")
        local activity_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if activity_times > 0 then
            quality_id = 0
        end
    end

	local lsize = nil
	if 1 <= mine_type and mine_type <= 5 then
		local strLevel = dms.atos(element, world_mine_mould.level)
		if self.__mine_quality ~= nil and quality_id~= zstring.tonumber(self.__mine_quality.pic) then
			self.__mine_quality:removeFromParent(true)
			table.insert(AdventureMineTileCell._mine_quality[zstring.tonumber(self.__mine_quality.pic)], self.__mine_quality)
			self.__mine_quality = nil
			if self.__mine_quality_level_bg ~= nil then
				self.__mine_quality_level_bg:setContentSize(cc.size(self.__mine_quality_level_bg._m_width, self.__mine_quality_level_bg:getContentSize().height))
				self.__mine_quality_level_bg:removeFromParent(true)
				table.insert(AdventureMineTileCell._mine_quality_level_bg[zstring.tonumber(self.__mine_quality_level_bg.pic)], self.__mine_quality_level_bg)
				self.__mine_quality_level_bg = nil
			end
		end
		if self.__mine_quality_bg ~= nil and quality_id~= zstring.tonumber(self.__mine_quality_bg.pic) then
			self.__mine_quality_bg:setContentSize(cc.size(self.__mine_quality_bg._m_width, self.__mine_quality_bg:getContentSize().height))
			self.__mine_quality_bg:removeFromParent(true)
			table.insert(AdventureMineTileCell._mine_quality_bg, self.__mine_quality_bg)
			self.__mine_quality_bg = nil
		end
		if zstring.tonumber(quality_id) > 0 then
			if self.__mine_quality_level_bg == nil then
				if AdventureMineTileCell._mine_quality_level_bg[quality_id] ~= nil then
					self.__mine_quality_level_bg = table.remove(AdventureMineTileCell._mine_quality_level_bg[quality_id], 1, 1)
				end
				if self.__mine_quality_level_bg~= nil then
					self.__mine_quality_level_bg.pic = quality_id
				end
				if nil == self.__mine_quality_level_bg then
					local mineLevelBg = ccui.ImageView:create("images/ui/share/res_lv_bg_"..quality_id..".png")
					mineLevelBg._m_width = mineLevelBg:getContentSize().width
					mineLevelBg:retain()
					self.__mine_quality_level_bg = mineLevelBg
					self.__mine_quality_level_bg.pic = quality_id
				end
				if nil ~= self.__mine_quality_level_bg then
					self.__mine_quality_level_bg:setAnchorPoint(cc.p(0.5, 0.5))
					self.__mine_quality_level_bg:setPosition(cc.p(self:getPositionX(), self:getPositionY()+(AdventureMineTileCell.__size.height)))
					self.parent:addChild(self.__mine_quality_level_bg,ceng)
					-- lsize = self.__mine_quality_level_bg:getContentSize()
					
				end
			end
		else
			if self.__mine_quality_bg == nil then
				self.__mine_quality_bg = table.remove(AdventureMineTileCell._mine_quality_bg, 1, 1)
				if nil == self.__mine_quality_bg then
					local mineBg = ccui.ImageView:create("images/ui/home/build_name_bg.png")
					mineBg._m_width = mineBg:getContentSize().width
					mineBg:retain()
					self.__mine_quality_bg = mineBg
				end
				if nil ~= self.__mine_quality_bg then
					self.__mine_quality_bg:setAnchorPoint(cc.p(0.5, 0.5))
					self.__mine_quality_bg:setPosition(cc.p(self:getPositionX(), self:getPositionY()+(AdventureMineTileCell.__size.height)))
					self.parent:addChild(self.__mine_quality_bg,ceng)
					self.__mine_quality_bg.pic = quality_id
					-- lsize = self.__mine_quality_level_bg:getContentSize()
				end
			end
		end
		if self.__mine_level == nil then
			self.__mine_level = table.remove(AdventureMineTileCell._mine_level, 1, 1) 
			if nil == self.__mine_level then
				local mineLevel = cc.Label:createWithTTF("", config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
				mineLevel:retain()
				self.__mine_level = mineLevel
			end
			if nil ~= self.__mine_level then
				self.__mine_level:setAnchorPoint(cc.p(0.5, 0.5))
				self.__mine_level:setPosition(cc.p(self:getPositionX(), self:getPositionY()+(AdventureMineTileCell.__size.height)))
				self.parent:addChild(self.__mine_level,ceng+1)
			end
		end

		if self.__mine_level ~= nil then
			self.__mine_level:setString(strLevel)
		end
		if quality_id > 0 then
			if self.__mine_quality == nil then
				if AdventureMineTileCell._mine_quality[quality_id] ~= nil then
					self.__mine_quality = table.remove(AdventureMineTileCell._mine_quality[quality_id], 1, 1)
				end
				if nil == self.__mine_quality then
					local mi_quality = cc.Sprite:create("images/ui/share/res_arrow_"..quality_id..".png")
					mi_quality:retain()
					self.__mine_quality = mi_quality	
				end
				self.__mine_quality.pic = quality_id	
				if self.__mine_quality ~= nil then
					self.parent:addChild(self.__mine_quality,ceng)
					self.__mine_quality:setPosition(cc.p(self:getPositionX()+self.__mine_quality:getContentSize().width*3/2, self:getPositionY()+(AdventureMineTileCell.__size.height) + 5))
				end
			end
		end
		if zstring.tonumber(self.info._userId) == zstring.tonumber(_ED.user_info.user_id) then
			if self.__mine_my_capture == nil then
				self.__mine_my_capture = table.remove(AdventureMineTileCell._mine_my_capture, 1, 1)
				if nil == self.__mine_my_capture then
					local my_capture = cc.Sprite:create("map/base_npc/map_501.png")
        			my_capture:retain()
        			self.__mine_my_capture = my_capture
				end
				if self.__mine_my_capture ~= nil then
					self.parent:addChild(self.__mine_my_capture,ceng)
					self.__mine_my_capture:setPosition(cc.p(self:getPositionX()+self:getContentSize().width-self.__mine_my_capture:getContentSize().width
						,self:getPositionY()-self:getContentSize().height/2))
				end
			end
		else
			if _ED.union.union_info == nil 
                or _ED.union.union_info == {} 
                or _ED.union.union_info.union_id == nil 
                or _ED.union.union_info.union_id == "" 
                or tonumber(_ED.union.union_info.union_id) == 0 
                or zstring.tonumber(_ED.union.union_info.union_id) ~= zstring.tonumber(self.info._union_id)
                then
	        else
	        	if self.__mine_un_capture == nil then
	        		self.__mine_un_capture = table.remove(AdventureMineTileCell._mine_un_capture, 1, 1)
	        		if nil == self.__mine_un_capture then
	        			local un_capture = cc.Sprite:create("map/base_npc/map_502.png")
				        un_capture:retain()
				        self.__mine_un_capture = un_capture
	        		end
	        		if self.__mine_un_capture ~= nil then
	        			self.parent:addChild(self.__mine_un_capture,ceng)
	        			self.__mine_un_capture:setPosition(cc.p(self:getPositionX()+self:getContentSize().width-self.__mine_un_capture:getContentSize().width
						,self:getPositionY()-self:getContentSize().height/2))
	        		end
	        	end
	        end
		end

		-- 绘制资源类型标识
		if __lua_project_id == __lua_project_pacific_rim then
			if nil ~= self.__mine_icon and self.__mine_icon.mine_type ~= mine_type then
				self.__mine_icon:setScaleX(1)
				self.__mine_icon:removeFromParent(true)
				table.insert(AdventureMineTileCell._mine_icon[self.__mine_icon.mine_type], self.__mine_icon)
				self.__mine_icon = nil
			end
			local width = nil
			if self.__mine_quality_level_bg ~= nil then
				width = self.__mine_quality_level_bg._m_width
				self.__mine_quality_level_bg:setScale9Enabled(true)
				self.__mine_quality_level_bg:setContentSize(cc.size(width * 2, self.__mine_quality_level_bg:getContentSize().height))
			elseif self.__mine_quality_bg ~= nil then
				width = self.__mine_quality_bg._m_width
				self.__mine_quality_bg:setScale9Enabled(true)
				self.__mine_quality_bg:setContentSize(cc.size(width * 2, self.__mine_quality_bg:getContentSize().height))
			end

			local offset = width / 2 - 3
			if self.__mine_level ~= nil then
				self.__mine_level:setPositionX(self:getPositionX() - offset)
			end
			if self.__mine_quality ~= nil then
				self.__mine_quality:setPositionX(self:getPositionX()+self.__mine_quality:getContentSize().width*3/2 + offset)
			end

			if self.__mine_icon == nil then
				if AdventureMineTileCell._mine_icon[mine_type] ~= nil then
					self.__mine_icon = table.remove(AdventureMineTileCell._mine_icon[mine_type], 1, 1)
				end
				if nil == self.__mine_icon then
					local mineIcon = ccui.ImageView:create(config_res.images.ui.home._ui_res_type_small_icon[mine_type], 1)
					mineIcon.mine_type = mine_type
					mineIcon:retain()
					self.__mine_icon = mineIcon
				end
				if nil ~= self.__mine_icon then
					self.__mine_icon:setScale(0.7)
					self.__mine_icon:setAnchorPoint(cc.p(0.5, 0.5))
					self.__mine_icon:setPosition(cc.p(self:getPositionX() + offset, self:getPositionY()+(AdventureMineTileCell.__size.height)))
					self.parent:addChild(self.__mine_icon,ceng+1)
				end
			end
		end
	end

	-- local root = self.roots[1]
	-- if root == nil then 
	-- 	return false
	-- end

	-- local element = dms.element(dms["world_mine_mould"], self.info._mould_id)
	-- local mine_type = dms.atoi(element, world_mine_mould.mine_type)
	-- local mine_quelity_level_up_param = dms.atos(element, world_mine_mould.quelity_level_up_param)
	-- local richOreValue = zstring.split(mine_quelity_level_up_param ,",")
	-- local quality_id = 0
	-- for i=1, #richOreValue do
	-- 	if self.info._quality_level_up_exp > tonumber(richOreValue[i]) then
	-- 		quality_id = i
	-- 	end
	-- end
	-- if quality_id>=3 then
	-- 	quality_id=3
	-- end
	
	-- if 1 <= mine_type and mine_type <= 5 then
	-- 	local strLevel = dms.atos(element, world_mine_mould.level)

	-- 	if zstring.tonumber(self.info._userId) == -1 then
	-- 		-- if tonumber(self.info._mining_time)~= 0 then
	-- 			-- local local_time = ((tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - (tonumber(self.info._mining_time)/1000))/60
	-- 			-- if local_time >= 1 then
	-- 				-- local element = dms.element(dms["world_mine_mould"], self.info._mould_id)
	-- 				-- local sub = dms.atoi(element, world_mine_mould.per_minute_sub_quelity_level_up_exp)
	-- 				-- local quelity_level = dms.atos(element, world_mine_mould.quelity_level_up_param)
	-- 				-- local quelity_info = zstring.split(quelity_level,",") 
	-- 				-- local nowexp = zstring.tonumber(self.info._quality_level_up_exp) - local_time*sub
	-- 				-- if nowexp < tonumber(quelity_info[1]) then
	-- 					-- --白
	-- 					-- self.info._quality = "0"
	-- 				-- elseif nowexp >= tonumber(quelity_info[1]) and nowexp < tonumber(quelity_info[2]) then
	-- 					-- --绿
	-- 					-- self.info._quality = "1"
	-- 				-- elseif nowexp >= tonumber(quelity_info[2]) and nowexp < tonumber(quelity_info[3]) then
	-- 					-- --蓝
	-- 					-- self.info._quality = "2"
	-- 				-- elseif nowexp >= tonumber(quelity_info[3]) then
	-- 					-- --紫
	-- 					-- self.info._quality = "3"
	-- 				-- end
	-- 			-- end
	-- 		-- end	
	-- 	end
		
	-- 	local tile = ccui.Helper:seekWidgetByName(root, "Panel_mine")
	-- 	local levelBg = nil
	-- 	if zstring.tonumber(self.info._quality) > 0 then
	-- 		levelBg = cc.Sprite:create("images/ui/share/res_lv_bg_"..quality_id..".png")
	-- 	else
	-- 		levelBg = cc.Sprite:create("images/ui/home/build_name_bg.png")
	-- 	end

	-- 	local lsize = levelBg:getContentSize()

	-- 	-- 绘制资源类型标识
	-- 	-- local typeBg = cc.Sprite:create("images/ui/home/build_name_bg.png")
	-- 	-- local typeIcon = cc.Sprite:create(config_res.images.ui.home._ui_res_type_small_icon[mine_type])
	-- 	-- typeBg:setPosition(cc.p(-1 * lsize.width/2 + 3 , (size.height*0.75 + lsize.height) / 2-22))
	-- 	-- typeIcon:setPosition(cc.p(lsize.width / 2, lsize.height / 2))
	-- 	-- typeIcon:setScale(typeBg:getContentSize().height / typeIcon:getContentSize().height - 0.1)
	-- 	-- typeBg:addChild(typeIcon)
	-- 	-- tile:addChild(typeBg)

	-- 	-- levelBg:setPosition(cc.p(lsize.width/2, (size.height*0.75 + lsize.height) / 2-22))
	-- 	levelBg:setPosition(cc.p(tile:getContentSize().width/2-lsize.width, tile:getContentSize().height / 2+lsize.height))
	-- 	tile:addChild(levelBg,999)

	-- 	local level = cc.Label:createWithTTF(strLevel, config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
	-- 	level:setPosition(cc.p(lsize.width / 2, lsize.height / 2))
	-- 	levelBg:addChild(level)

	-- 	if zstring.tonumber(self.info._quality) > 0 then
	-- 		local mi_quality = cc.Sprite:create("images/ui/share/res_arrow_"..self.info._quality..".png")
	-- 		local qu_size = mi_quality:getContentSize()
	-- 		mi_quality:setPosition(cc.p((lsize.width ), (size.height*0.75 + lsize.height) / 2-22))
	-- 		mi_quality:setTag(500)
	-- 		tile:addChild(mi_quality)
	-- 	else
	-- 		if tile:getChildByTag(500) ~= nil then 
	-- 			tile:removeChildByTag(500)
	-- 		end
	-- 	end
			
	-- 	if zstring.tonumber(self.info._userId) == zstring.tonumber(_ED.user_info.user_id) then
	-- 		local mi_occupied = cc.Sprite:create("map/base_npc/map_501.png")
	-- 		local occ_size = mi_occupied:getContentSize()
	-- 		mi_occupied:setPosition(cc.p((lsize.width), -(lsize.height)))
	-- 		mi_occupied:setTag(1000)
	-- 		tile:addChild(mi_occupied)
	-- 	else
	-- 		if tile:getChildByTag(1000) ~= nil then 
	-- 			tile:removeChildByTag(1000)
	-- 		end

	-- 		if _ED.union.union_info == nil 
 --                or _ED.union.union_info == {} 
 --                or _ED.union.union_info.union_id == nil 
 --                or _ED.union.union_info.union_id == "" 
 --                or tonumber(_ED.union.union_info.union_id) == 0 
 --                or zstring.tonumber(_ED.union.union_info.union_id) ~= zstring.tonumber(self.info._union_id)
 --                then
	-- 			if tile:getChildByTag(2000) ~= nil then 
	-- 				tile:removeChildByTag(2000)
	-- 			end
 --            else
	-- 			local mi_occupied = cc.Sprite:create("map/base_npc/map_502.png")
	-- 			local occ_size = mi_occupied:getContentSize()
	-- 			mi_occupied:setPosition(cc.p((lsize.width), -(lsize.height)))
	-- 			mi_occupied:setTag(2000)
	-- 			tile:addChild(mi_occupied)
 --            end
	-- 	end
	-- end
end	

function AdventureMineTileCell:updateDrawUserCityInfo(size,stage,_glories,boom_state)
	local pos = cc.p(self:getPosition())
	--防护罩动画
	local isOpenShield = false
	if zstring.tonumber(self.info._shield_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) > 0 then
		isOpenShield = true
	end
	if isOpenShield == true then
		if nil == self.__shelter_sprite then
			self.__shelter_sprite = table.remove(AdventureMineTileCell._shelter_armature, 1, 1)
			if nil == self.__shelter_sprite then
				local fileName = "images/ui/effice/effect_shield/effect_shield.ExportJson"
			    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
			    self.__shelter_sprite = ccs.Armature:create("effect_shield")
		        self.__shelter_sprite:getAnimation():playWithIndex(0)
		        self.__shelter_sprite:retain()
			end
		end
		if nil ~= self.__shelter_sprite and self.__shelter_sprite._parent == nil then
			self.parent:addChild(self.__shelter_sprite,stage)
			self.__shelter_sprite._parent = self
			self.__shelter_sprite:setPosition(pos)
		end
	end

	local lsize = nil
	local nssize = nil
	local nsize = nil
	--名称
	if self.__mine_name_bg == nil then
		self.__mine_name_bg = table.remove(AdventureMineTileCell._mine_name_bg, 1, 1)
		if nil == self.__mine_name_bg then
			local mineNameBg = ccui.ImageView:create("images/ui/home/build_name_bg.png")
			mineNameBg._m_width = mineNameBg:getContentSize().width
			mineNameBg:retain()
			self.__mine_name_bg = mineNameBg
		end
		if nil ~= self.__mine_name_bg then
			self.parent:addChild(self.__mine_name_bg,stage)
			self.__mine_name_bg:setPosition(pos)
			nsize = self.__mine_name_bg:getContentSize()
		end
	end
	
	if self.__mine_name == nil then
		self.__mine_name = table.remove(AdventureMineTileCell._mine_name, 1, 1)
		if nil == self.__mine_name then
			local mineName = cc.Label:createWithTTF("", config_res.font.font_name, 16 / CC_CONTENT_SCALE_FACTOR())
			mineName:retain()
			self.__mine_name = mineName
		end
		if nil ~= self.__mine_name then
			self.__mine_name:setAnchorPoint(cc.p(0.5, 0.5))
			self.__mine_name_bg:addChild(self.__mine_name)
			self.__mine_name:setPosition(cc.p(self.__mine_name_bg:getContentSize().width/2,self.__mine_name_bg:getContentSize().height/2))
		end
	end
	if nil ~= self.__mine_name then
		if isContentZh_TW() == true then
	        local ttfConfig = {}
	        ttfConfig.fontFilePath = ""
	        self.__mine_name:setTTFConfig(ttfConfig)
	        self.__mine_name:setSystemFontSize(16)
	    end
		if tonumber(self.info._userId) == tonumber(_ED.user_info.user_id) then
			self.__mine_name:setString(_ED.user_info.user_name)
			self.__mine_name:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
		else
			self.__mine_name:setString(self.info._nickname)
			if _ED.union.union_info == nil 
	            or _ED.union.union_info == {} 
	            or _ED.union.union_info.union_id == nil 
	            or _ED.union.union_info.union_id == "" 
	            or tonumber(_ED.union.union_info.union_id) == 0 
	            or tonumber(_ED.union.union_info.union_id) ~= zstring.tonumber(self.info._union_id)
	            then
	            self.__mine_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	        else
				self.__mine_name:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
	        end
		end
		nssize = self.__mine_name:getContentSize()
	end

	--等级
	if self.__mine_level_bg == nil then
		self.__mine_level_bg = table.remove(AdventureMineTileCell._mine_level_bg, 1, 1)
		if nil == self.__mine_level_bg then
			local mineLevelBg = cc.Sprite:create("images/ui/home/build_name_bg.png")
			mineLevelBg._m_width = mineLevelBg:getContentSize().width
			mineLevelBg:retain()
			self.__mine_level_bg = mineLevelBg
		end
		if nil ~= self.__mine_level_bg then
			self.__mine_level_bg:setAnchorPoint(cc.p(0.5, 0.5))
			self.parent:addChild(self.__mine_level_bg,stage)
			self.__mine_level_bg:setPosition(pos)
			lsize = self.__mine_level_bg:getContentSize()
		end
	end
	if self.__mine_level == nil then
		self.__mine_level = table.remove(AdventureMineTileCell._mine_level, 1, 1) 
		if nil == self.__mine_level then
			local mineLevel = cc.Label:createWithTTF("", config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
			mineLevel:retain()
			self.__mine_level = mineLevel
		end
		if nil ~= self.__mine_level then
			self.__mine_level:setAnchorPoint(cc.p(0.5, 0.5))
			self.__mine_level_bg:addChild(self.__mine_level)
			self.__mine_level:setPosition(cc.p(self.__mine_level_bg:getContentSize().width/2,self.__mine_level_bg:getContentSize().height/2))
		end
		if nil ~= self.__mine_level then
			local level_Info = self.info._level
			if tonumber(self.info._userId) == tonumber(_ED.user_info.user_id) then
				level_Info = _ED.user_info.user_grade
			else
				local max_id = dms.int(dms["arena_config"],10,arena_config.param) 
				if tonumber(self.info._userId) <= max_id then
					level_Info = dms.string(dms["world_config"], 20 , world_config.param)
				end
			end
			self.__mine_level:setString(level_Info)
		end
		if nil ~= self.__mine_name_bg then
			nsize.width = self.__mine_name_bg._m_width + nssize.width - 18
			self.__mine_name_bg:setScale9Enabled(true)
			self.__mine_name_bg:setContentSize(nsize)
			
			self.__mine_name:setPosition(cc.p(nsize.width / 2, nsize.height / 2))
			if nil ~= self.__mine_level_bg then
				self.__mine_name_bg:setPosition(cc.p(self:getPositionX()+(lsize.width) / 2 - 2, self:getPositionY()+(size.height + nsize.height) / 3 - 5))
				self.__mine_level_bg:setPosition(cc.p(self:getPositionX()+(-1 * (nsize.width) / 2) + 2, self.__mine_name_bg:getPositionY()))
			end
		end
	end
	
	--军团名称
	if self.info._union_name ~= "" then
		if self.__city_union_name_bg == nil then
			self.__city_union_name_bg = table.remove(AdventureMineTileCell._city_name_bg, 1, 1)
			if nil == self.__city_union_name_bg then
				local mineNameBg = ccui.ImageView:create("images/ui/share/world_map_fight_name.png")
				mineNameBg._m_width = mineNameBg:getContentSize().width
				mineNameBg:retain()
				self.__city_union_name_bg = mineNameBg
			end
			if nil ~= self.__city_union_name_bg then
				self.parent:addChild(self.__city_union_name_bg,stage)
				self.__city_union_name_bg:setPosition(pos)
			end
		end
		
		if self.__union_name == nil then
			self.__union_name = table.remove(AdventureMineTileCell._union_name, 1, 1)
			if nil == self.__union_name then
				local mineName = cc.Label:createWithTTF("", config_res.font.font_name, 16 / CC_CONTENT_SCALE_FACTOR())
				mineName:retain()
				self.__union_name = mineName
			end
			if nil ~= self.__union_name then
				self.__union_name:setAnchorPoint(cc.p(0.5, 0.5))
				self.__city_union_name_bg:addChild(self.__union_name)
				self.__union_name:setPosition(cc.p(self.__city_union_name_bg:getContentSize().width/2,self.__city_union_name_bg:getContentSize().height/2))
			end
		end
		if nil ~= self.__union_name then
			if isContentZh_TW() == true then
		        local ttfConfig = {}
		        ttfConfig.fontFilePath = ""
		        self.__union_name:setTTFConfig(ttfConfig)
		        self.__union_name:setSystemFontSize(16)
		    end
			self.__union_name:setString(self.info._union_name)
			if _ED.union.union_info == nil 
	            or _ED.union.union_info == {} 
	            or _ED.union.union_info.union_id == nil 
	            or _ED.union.union_info.union_id == "" 
	            or tonumber(_ED.union.union_info.union_id) == 0 
	            or tonumber(_ED.union.union_info.union_id) ~= zstring.tonumber(self.info._union_id)
	            then
	            self.__union_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	        else
				self.__union_name:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
	        end
			if self.__city_union_name_bg ~= nil then
				self.__city_union_name_bg:setScale9Enabled(true)

				local union_width = self.__union_name:getContentSize().width + 30
				local name_width = self.__mine_name_bg:getContentSize().width + self.__mine_level_bg:getContentSize().width
				local width =0
				if union_width > name_width then
					width = union_width
					local level_posX = self:getPositionX() - (width - self.__mine_level_bg:getContentSize().width) / 2
					local name_width = (width - self.__mine_level_bg:getContentSize().width)
					local name_posX = level_posX + self.__mine_level_bg:getContentSize().width / 2 + name_width / 2

					self.__mine_level_bg:setPositionX(level_posX + 2)
					self.__mine_name_bg:setPositionX(name_posX - 2)
					self.__mine_name_bg:setContentSize(cc.size(name_width, self.__mine_name_bg:getContentSize().height))
					self.__mine_name:setPositionX(name_width / 2)
				else
					width = name_width
				end

				self.__city_union_name_bg:setContentSize(cc.size(width + 20, self.__city_union_name_bg:getContentSize().height))
				self.__union_name:setPosition(cc.p(self.__city_union_name_bg:getContentSize().width / 2, self.__city_union_name_bg:getContentSize().height / 2))
				self.__city_union_name_bg:setPosition(cc.p(self:getPositionX(), self.__mine_name_bg:getPositionY() + self.__mine_name_bg:getContentSize().height / 2 + 11))
			end
		end
	else
		if nil ~= self.__union_name then
			self.__union_name:removeFromParent(true)
			table.insert(AdventureMineTileCell._union_name, self.__union_name)
			self.__union_name = nil
		end
		if nil ~= self.__city_union_name_bg then
			self.__city_union_name_bg:setContentSize(cc.size(self.__city_union_name_bg._m_width,self.__city_union_name_bg:getContentSize().height))
			self.__city_union_name_bg:removeFromParent(true)
			table.insert(AdventureMineTileCell._city_name_bg, self.__city_union_name_bg)
			self.__city_union_name_bg = nil
		end
	end

	-- --军团icon
	-- if self.__mine_legion_icon == nil then
	-- 	self.__mine_legion_icon = table.remove(AdventureMineTileCell._mine_legion_icon, 1, 1) 
	-- 	if nil == self.__mine_legion_icon then
	-- 		local mineLogoImage = cc.Sprite:create("images/ui/legion/legion_icon_world.png")
	-- 		 mineLogoImage:retain()
	-- 		 self.__mine_legion_icon = mineLogoImage
	-- 	end
	-- 	if self.__mine_legion_icon ~= nil then
	-- 		if nsize ~= nil then
	-- 			self.parent:addChild(self.__mine_legion_icon,stage)
	-- 			self.__mine_legion_icon:setPosition(cc.p(self:getPositionX()+(-1 * (nsize.width) / 2 - self.__mine_legion_icon:getContentSize().width + 5), 
	-- 			self:getPositionY()+(size.height + lsize.height) / 3))
	-- 		end
	-- 	end
	-- end
	--繁荣度
	if self.__mine_glories_bg == nil then
		self.__mine_glories_bg = table.remove(AdventureMineTileCell._mine_glories_bg, 1, 1) 
		if nil == self.__mine_glories_bg then
			local mineGloriesBg = ccui.ImageView:create("images/ui/home/parrss_loading_bg.png")
			mineGloriesBg:retain()
			self.__mine_glories_bg = mineGloriesBg
		end
		if self.__mine_glories_bg ~= nil then
			self.__mine_glories_bg:setScale9Enabled(true)
			self.__mine_glories_bg:setPosition(cc.p( self:getPositionX(), self:getPositionY()+(size.height + lsize.height) / 4 - 5))
			self.parent:addChild(self.__mine_glories_bg,stage)
		end
	end
	if self.__mine_pragress == nil then
		self.__mine_pragress = table.remove(AdventureMineTileCell._mine_pragress, 1, 1) 
		if nil == self.__mine_pragress then
			local minePragress = ccui.LoadingBar:create()
			minePragress:retain()
			self.__mine_pragress = minePragress
		end
		if self.__mine_pragress ~= nil then
			local glories = zstring.tonumber(_glories)/zstring.tonumber(self.info._max_boom)*100
			self.__mine_pragress:setPercent(glories)
			-- self.__mine_pragress:setPosition(cc.p( self:getPositionX(), self:getPositionY()+(size.height + lsize.height) / 4 - 5))
			self.__mine_glories_bg:addChild(self.__mine_pragress)
		end
	end
	if self.__mine_pragress ~= nil then
		if boom_state == 2 then
			self.__mine_pragress:loadTexture("images/ui/share/loading_boom_bar_2.png")
		elseif boom_state == 1 then
			self.__mine_pragress:loadTexture("images/ui/share/loading_boom_bar_1.png")
		else
			self.__mine_pragress:loadTexture("images/ui/share/loading_boom_bar.png")
		end
		self.__mine_glories_bg:setContentSize(self.__mine_pragress:getContentSize())
		self.__mine_pragress:setPosition(cc.p(self.__mine_glories_bg:getContentSize().width/2, self.__mine_glories_bg:getContentSize().height/2))
	end
	--废墟旗帜
	if self.__mine_occupied == nil then
		if boom_state == 2 then
			self.__mine_occupied = table.remove(AdventureMineTileCell._mine_occupied, 1, 1)
			if nil == self.__mine_occupied then
				local mi_occupied = cc.Sprite:create("map/base_npc/map_503.png")
				mi_occupied:retain()
				self.__mine_occupied = mi_occupied
			end
			if self.__mine_occupied ~= nil then
				self.__mine_occupied:setPosition(cc.p(self:getPositionX()-self:getContentSize().width+self.__mine_occupied:getContentSize().width*3/2
						,self:getPositionY()-self:getContentSize().height/2))
				self.parent:addChild(self.__mine_occupied,stage)
			end
		end
	end
end	

function AdventureMineTileCell:updateDrawRebelHaunt(size,stage)
	local lsize = nil
	local nssize = nil
	local nsize = nil
	local pos = cc.p(self:getPosition())
	--名称
	if self.__mine_name_bg == nil then
		self.__mine_name_bg = table.remove(AdventureMineTileCell._mine_name_bg, 1, 1)
		if nil == self.__mine_name_bg then
			local mineNameBg = ccui.ImageView:create("images/ui/home/build_name_bg.png")
			mineNameBg._m_width = mineNameBg:getContentSize().width
			mineNameBg:retain()
			self.__mine_name_bg = mineNameBg
		end
		if nil ~= self.__mine_name_bg then
			self.parent:addChild(self.__mine_name_bg,stage)
			self.__mine_name_bg:setPosition(pos)
			nsize = self.__mine_name_bg:getContentSize()
		end
	end
	
	if self.__mine_name == nil then
		self.__mine_name = table.remove(AdventureMineTileCell._mine_name, 1, 1)
		if nil == self.__mine_name then
			local mineName = cc.Label:createWithTTF("", config_res.font.font_name, 16 / CC_CONTENT_SCALE_FACTOR())
			mineName:retain()
			self.__mine_name = mineName
		end
		if nil ~= self.__mine_name then
			self.__mine_name:setAnchorPoint(cc.p(0.5, 0.5))
			self.__mine_name_bg:addChild(self.__mine_name)
			self.__mine_name:setPosition(cc.p(self.__mine_name_bg:getContentSize().width/2,self.__mine_name_bg:getContentSize().height/2))
		end
	end
	if nil ~= self.__mine_name then
		local npcId = dms.int(dms["rebel_haunt_mould"], self.info._mould_id, rebel_haunt_mould.npc_mould_id)
		local npcName = dms.string(dms["npc"], npcId, npc.npc_name)
		self.__mine_name:setString(npcName)
		if self.info._nickname == _ED.user_info.user_name then
			self.__mine_name:setColor(cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]))
		else
			self.__mine_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))	
		end
		nssize = self.__mine_name:getContentSize()
	end

	--等级
	if self.__mine_level_bg == nil then
		self.__mine_level_bg = table.remove(AdventureMineTileCell._mine_level_bg, 1, 1)
		if nil == self.__mine_level_bg then
			local mineLevelBg = cc.Sprite:create("images/ui/home/build_name_bg.png")
			mineLevelBg._m_width = mineLevelBg:getContentSize().width
			mineLevelBg:retain()
			self.__mine_level_bg = mineLevelBg
		end
		if nil ~= self.__mine_level_bg then
			self.__mine_level_bg:setAnchorPoint(cc.p(0.5, 0.5))
			self.parent:addChild(self.__mine_level_bg,stage)
			self.__mine_level_bg:setPosition(pos)
			lsize = self.__mine_level_bg:getContentSize()
		end
	end
	if self.__mine_level == nil then
		self.__mine_level = table.remove(AdventureMineTileCell._mine_level, 1, 1) 
		if nil == self.__mine_level then
			local mineLevel = cc.Label:createWithTTF("", config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
			mineLevel:retain()
			self.__mine_level = mineLevel
		end
		if nil ~= self.__mine_level then
			self.__mine_level:setAnchorPoint(cc.p(0.5, 0.5))
			self.__mine_level_bg:addChild(self.__mine_level)
			self.__mine_level:setPosition(cc.p(self.__mine_level_bg:getContentSize().width/2,self.__mine_level_bg:getContentSize().height/2))
		end
		if nil ~= self.__mine_level then
			self.__mine_level:setString(_ED.world_level)
		end
		if nil ~= self.__mine_name_bg then
			nsize.width = self.__mine_name_bg._m_width + nssize.width - 18
			self.__mine_name_bg:setScale9Enabled(true)
			self.__mine_name_bg:setContentSize(nsize)
			
			self.__mine_name:setPosition(cc.p(nsize.width / 2, nsize.height / 2))
			if nil ~= self.__mine_level_bg then
				self.__mine_level_bg:setPosition(cc.p(self:getPositionX()+(-1 * (nsize.width) / 2) + 2, self:getPositionY()+(size.height + lsize.height) / 3))
				self.__mine_name_bg:setPosition(cc.p(self:getPositionX()+(lsize.width) / 2 - 2, self:getPositionY()+(size.height + nsize.height) / 3))
			end
		end
	end
	
	--hp
	if self.__rebel_hp_bg == nil then
		self.__rebel_hp_bg = table.remove(AdventureMineTileCell._rebel_hp_bg, 1, 1) 
		if nil == self.__rebel_hp_bg then
			local rebelHpBg = ccui.ImageView:create("images/ui/share/pve_hp_loadingbar_bg1.png")
			rebelHpBg:retain()
			self.__rebel_hp_bg = rebelHpBg
		end
		if self.__rebel_hp_bg ~= nil then
			self.__rebel_hp_bg:setScale9Enabled(true)
			self.__rebel_hp_bg:setPosition(cc.p( self:getPositionX(), self:getPositionY()+(size.height*0.6 + lsize.height) / 2 + 20))
			self.parent:addChild(self.__rebel_hp_bg,stage)
		end
	end
	if self.__rebel_hp == nil then
		self.__rebel_hp = table.remove(AdventureMineTileCell._rebel_hp, 1, 1) 
		if nil == self.__rebel_hp then
			local rebelHpBar = ccui.LoadingBar:create()
			rebelHpBar:retain()
			self.__rebel_hp = rebelHpBar
		end
		if self.__rebel_hp ~= nil then
			self.__rebel_hp:loadTexture("images/ui/share/pve_hp_loadingbar_1.png")
			-- self.__rebel_hp:setScale9Enabled(true)
			self.__rebel_hp:setPosition(cc.p(self.__rebel_hp_bg:getContentSize().width/2, self.__rebel_hp_bg:getContentSize().height/2))
			self.__rebel_hp_bg:addChild(self.__rebel_hp)
			local percent = (self.info._now_hp * 100 / self.info._max_hp)
			self.__rebel_hp:setPercent(percent)	
		end
	else
		local percent = (self.info._now_hp * 100 / self.info._max_hp)
		self.__rebel_hp:setPercent(percent)	
	end
end

function AdventureMineTileCell:updateWorldCityInfo( size,stage )
	local lsize = nil
	local nssize = nil
	local nsize = nil
	local pos = cc.p(self:getPosition())
	-- 活动开启状态
	local open_state = 0
	local protect_time = 0
    if self.info._type == 3002 then
        if _ED.mould_function_push_info["16"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["16"].state)
        end
        protect_time = dms.int(dms["world_city_config"], 27, world_city_config.param)
    else
        if _ED.mould_function_push_info["14"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["14"].state)
        end
        protect_time = dms.int(dms["world_city_config"], 8, world_city_config.param)
    end

	--防护罩动画
	local isOpenShield = false
	if self.info._type == 3000 or self.info._type == 3001 then
		if self.info._city_state == -1 
			or (self.info._capture_start_time > 0 
				and self.info._capture_start_time + self.info._capture_cd_time > tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
			then
			isOpenShield = true
		end
	else
		if open_state == 1
			or self.info._city_state == -1
			or (zstring.tonumber(self.info._capture_start_time) > 0 
			and tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time) - self.info._capture_start_time < protect_time
			and tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time) - self.info._capture_start_time > 0)
			then
			isOpenShield = true
		end
	end
	if isOpenShield == true then
		if nil == self.__shelter_sprite then
			self.__shelter_sprite = table.remove(AdventureMineTileCell._shelter_armature, 1, 1)
			if nil == self.__shelter_sprite then
				local fileName = "images/ui/effice/effect_shield/effect_shield.ExportJson"
			    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
			    self.__shelter_sprite = ccs.Armature:create("effect_shield")
		        self.__shelter_sprite:getAnimation():playWithIndex(0)
		        self.__shelter_sprite:retain()
			end
		end
		if nil ~= self.__shelter_sprite and self.__shelter_sprite._parent == nil then
			self.parent:addChild(self.__shelter_sprite,stage)
			self.__shelter_sprite._parent = self
			self.__shelter_sprite:setPosition(pos)
		end
	elseif nil ~= self.__shelter_sprite then
		self.__shelter_sprite:removeFromParent(true)
		table.insert(AdventureMineTileCell._shelter_armature, self.__shelter_sprite)
		self.__shelter_sprite._parent = nil
		self.__shelter_sprite = nil
	end

	--名称
	if self.__mine_name_bg == nil then
		self.__mine_name_bg = table.remove(AdventureMineTileCell._mine_name_bg, 1, 1)
		if nil == self.__mine_name_bg then
			local mineNameBg = ccui.ImageView:create("images/ui/home/build_name_bg.png")
			mineNameBg._m_width = mineNameBg:getContentSize().width
			mineNameBg:retain()
			self.__mine_name_bg = mineNameBg
		end
		if nil ~= self.__mine_name_bg then
			self.parent:addChild(self.__mine_name_bg,stage)
			nsize = self.__mine_name_bg:getContentSize()
			-- self.__mine_name_bg:setPosition(cc.p(self:getPositionX(), self:getPositionY() - 10))
			self.__mine_name_bg:setPosition(cc.p(self:getPositionX(), self:getPositionY()+size.height*0.3 + 3))
		end
	end
	
	if self.__mine_name == nil then
		self.__mine_name = table.remove(AdventureMineTileCell._mine_name, 1, 1)
		if nil == self.__mine_name then
			local mineName = cc.Label:createWithTTF("", config_res.font.font_name, 16 / CC_CONTENT_SCALE_FACTOR())
			mineName:retain()
			self.__mine_name = mineName
		end
		if nil ~= self.__mine_name then
			self.__mine_name:setAnchorPoint(cc.p(0.5, 0.5))
			self.__mine_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))	
			self.__mine_name_bg:addChild(self.__mine_name)
			self.__mine_name:setPosition(cc.p(self.__mine_name_bg:getContentSize().width/2,self.__mine_name_bg:getContentSize().height/2))
		end
	end
	if nil ~= self.__mine_name then
		local name = dms.string(dms["world_city_mould"], self.info._mould_id, world_city_mould.name)
		self.__mine_name:setString(name)
		nssize = self.__mine_name:getContentSize()
	end

	--等级
	if self.__mine_level_bg == nil then
		self.__mine_level_bg = table.remove(AdventureMineTileCell._mine_level_bg, 1, 1)
		if nil == self.__mine_level_bg then
			local mineLevelBg = cc.Sprite:create("images/ui/home/build_name_bg.png")
			mineLevelBg._m_width = mineLevelBg:getContentSize().width
			mineLevelBg:retain()
			self.__mine_level_bg = mineLevelBg
		end
		if nil ~= self.__mine_level_bg then
			self.__mine_level_bg:setAnchorPoint(cc.p(0.5, 0.5))
			self.parent:addChild(self.__mine_level_bg,stage)
			self.__mine_level_bg:setPosition(cc.p(self:getPositionX(), self:getPositionY()+size.height*0.3))
			lsize = self.__mine_level_bg:getContentSize()
		end
	end
	if self.__mine_level == nil then
		self.__mine_level = table.remove(AdventureMineTileCell._mine_level, 1, 1) 
		if nil == self.__mine_level then
			local mineLevel = cc.Label:createWithTTF("", config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
			mineLevel:retain()
			self.__mine_level = mineLevel
		end
		if nil ~= self.__mine_level then
			self.__mine_level:setAnchorPoint(cc.p(0.5, 0.5))
			self.__mine_level_bg:addChild(self.__mine_level)
			self.__mine_level:setPosition(cc.p(self.__mine_level_bg:getContentSize().width/2,self.__mine_level_bg:getContentSize().height/2))
		end
		if nil ~= self.__mine_level then
			local level = dms.int(dms["world_city_mould"], self.info._mould_id, world_city_mould.level)
			local capture_time = dms.int(dms["world_city_mould"], self.info._mould_id, world_city_mould.capture_time)
			local less_percent = dms.float(dms["world_city_config"], 7, world_city_config.param)
			self.__capture_time = capture_time
			self.__less_capture_time = self.__capture_time * less_percent
			self.__less_percent = less_percent
			self.__mine_level:setString(level)
		end
		if nil ~= self.__mine_name_bg then
			nsize.width = self.__mine_name_bg._m_width + nssize.width - 18
			self.__mine_name_bg:setScale9Enabled(true)
			self.__mine_name_bg:setContentSize(nsize)
			
			self.__mine_name:setPosition(cc.p(nsize.width / 2, nsize.height / 2))
			if nil ~= self.__mine_level_bg then
				-- self.__mine_name_bg:setPosition(cc.p(self:getPositionX()+(lsize.width) / 2 - 2, self:getPositionY() - 10))
				self.__mine_name_bg:setPosition(cc.p(self:getPositionX()+(lsize.width) / 2 - 2, self:getPositionY()+size.height*0.3 + 3))
				self.__mine_level_bg:setPosition(cc.p(self:getPositionX()+(-1 * (nsize.width) / 2) + 2, self.__mine_name_bg:getPositionY()))
			end
		end
	end

	if (open_state == 2 and (self.info._type == 3000 or self.info._type == 3001) and self.info._union_name ~= "")
		or (open_state == 0 and self.info._type == 3002 and self.info._union_name ~= "")
		then
		local local_time = tonumber(self.info._progress)
        local add_time = 0
        if self.info._progress_tick_time ~= 0 then
        	add_time = (os.time() - self.info._progress_start_time)
        end
        local percent = 0
        if self.info._union_name == self.info._progress_union_name then
            local_time = local_time - add_time * self.info._add_time_speed
            percent = (self.__capture_time - local_time) * 100 / self.__capture_time
        else
            local_time = local_time - add_time / self.__less_percent
            percent = local_time * 100 / self.__capture_time
        end
		percent = math.ceil(percent)
		if percent >= 100 then
			percent = 100
		elseif percent <= 0 then
			percent = 0
		end

		if percent < 100
			or self.info._union_name ~= self.info._progress_union_name
			then
			if self.__rebel_hp_bg == nil then
				self.__rebel_hp_bg = table.remove(AdventureMineTileCell._rebel_hp_bg, 1, 1) 
				if nil == self.__rebel_hp_bg then
					local rebelHpBg = ccui.ImageView:create("images/ui/share/pve_hp_loadingbar_bg1.png")
					rebelHpBg:retain()
					self.__rebel_hp_bg = rebelHpBg
				end
				if self.__rebel_hp_bg ~= nil then
					local height = 26
					if lsize ~= nil then
						height = lsize.height
					end
					self.__rebel_hp_bg:setScale9Enabled(true)
					self.__rebel_hp_bg:setPosition(cc.p( self:getPositionX(), self:getPositionY()+(size.height*0.6 + height) / 2 - 30))
					self.parent:addChild(self.__rebel_hp_bg,stage)
				end
			end
			if self.__rebel_hp == nil then
				self.__rebel_hp = table.remove(AdventureMineTileCell._rebel_hp, 1, 1) 
				if nil == self.__rebel_hp then
					local rebelHpBar = ccui.LoadingBar:create()
					rebelHpBar:retain()
					self.__rebel_hp = rebelHpBar
				end
				if self.__rebel_hp ~= nil then
					self.__rebel_hp:loadTexture("images/ui/share/pve_hp_loadingbar_1.png")
					self.__rebel_hp:setPosition(cc.p(self.__rebel_hp_bg:getContentSize().width/2, self.__rebel_hp_bg:getContentSize().height/2))
					self.__rebel_hp_bg:addChild(self.__rebel_hp)
				end
			end
			if self.__rebel_hp ~= nil then
				if self.__city_progress_name == nil then
					self.__city_progress_name = table.remove(AdventureMineTileCell._mine_name, 1, 1)
					if nil == self.__city_progress_name then
						local mineName = cc.Label:createWithTTF("", config_res.font.font_name, 16 / CC_CONTENT_SCALE_FACTOR())
						mineName:retain()
						self.__city_progress_name = mineName
					end
					if nil ~= self.__city_progress_name then
						self.__city_progress_name:setAnchorPoint(cc.p(0.5, 0.5))
						self.__rebel_hp_bg:addChild(self.__city_progress_name)
						self.__city_progress_name:setPosition(cc.p(self.__rebel_hp_bg:getContentSize().width/2, self.__rebel_hp_bg:getContentSize().height/2))
					end
				end
				
				self.__rebel_hp:setPercent(percent)

				if self.__city_progress_name ~= nil then
					self.__city_progress_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
					self.__city_progress_name:setString(percent.."%")
				end
			end
		end
	end
	if self.info._type == 3000 or self.info._type == 3001 then
		if self.info._total_num > 0 then
			if self.__city_defender_icon == nil then
				self.__city_defender_icon = table.remove(AdventureMineTileCell._city_defender_icon, 1, 1) 
				if nil == self.__city_defender_icon then
					local mineLogoImage = cc.Sprite:create("images/ui/share/world_map_fight.png")
					mineLogoImage:retain()
					self.__city_defender_icon = mineLogoImage
				end
				if self.__city_defender_icon ~= nil then
					self.parent:addChild(self.__city_defender_icon, stage)
					if self.__rebel_hp_bg ~= nil then
						self.__city_defender_icon:setPosition(cc.p(self.__rebel_hp_bg:getPositionX(), 
							self.__rebel_hp_bg:getPositionY() - (self.__city_defender_icon:getContentSize().height)/2 - 3))
					else
						self.__city_defender_icon:setPosition(cc.p(self:getPositionX(), 
							self.__mine_name_bg:getPositionY() - (self.__city_defender_icon:getContentSize().height)/2 - 23))
					end
				end
			end
			if self.__city_defender_name == nil then
				self.__city_defender_name = table.remove(AdventureMineTileCell._mine_name, 1, 1)
				if nil == self.__city_defender_name then
					local mineName = cc.Label:createWithTTF("", config_res.font.font_name, 16 / CC_CONTENT_SCALE_FACTOR())
					mineName:retain()
					self.__city_defender_name = mineName
				end
				if nil ~= self.__city_defender_name then
					self.__city_defender_name:setAnchorPoint(cc.p(0.5, 0.5))
					self.__city_defender_icon:addChild(self.__city_defender_name)
					self.__city_defender_name:setPosition(cc.p(self.__city_defender_icon:getContentSize().width - 7, self.__city_defender_icon:getContentSize().height - 22))
				end
			end
			if self.__city_defender_name ~= nil then
				self.__city_defender_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
				self.__city_defender_name:setString(self.info._total_num)
			end
		end
	end


	--占领军团名称
	if self.info._progress_union_name ~= "" or self.info._union_name ~= "" then
		if self.__city_union_name_bg == nil then
			self.__city_union_name_bg = table.remove(AdventureMineTileCell._city_name_bg, 1, 1)
			if nil == self.__city_union_name_bg then
				local mineNameBg = ccui.ImageView:create("images/ui/share/world_map_fight_name.png")
				mineNameBg._m_width = mineNameBg:getContentSize().width
				mineNameBg:retain()
				self.__city_union_name_bg = mineNameBg
			end
			if nil ~= self.__city_union_name_bg then
				self.__city_union_name_bg:setScale9Enabled(true)
				local width = 132
				if self.__rebel_hp_bg ~= nil then
					width = self.__rebel_hp_bg:getContentSize().width
				end
				self.__city_union_name_bg:setContentSize(cc.size(width, self.__city_union_name_bg:getContentSize().height))
				self.parent:addChild(self.__city_union_name_bg,stage)
				-- self.__city_union_name_bg:setPosition(cc.p(self:getPositionX(), self:getPositionY()+size.height*0.3 + 3))
				self.__city_union_name_bg:setPosition(cc.p(self:getPositionX(), self.__mine_name_bg:getPositionY() + self.__mine_name_bg:getContentSize().height / 2 + 11))
			end
		end
		
		if self.__city_union_name == nil then
			self.__city_union_name = table.remove(AdventureMineTileCell._mine_name, 1, 1)
			if nil == self.__city_union_name then
				local mineName = cc.Label:createWithTTF("", config_res.font.font_name, 16 / CC_CONTENT_SCALE_FACTOR())
				mineName:retain()
				self.__city_union_name = mineName
			end
			if nil ~= self.__city_union_name then
				self.__city_union_name:setAnchorPoint(cc.p(0.5, 0.5))
				self.__city_union_name_bg:addChild(self.__city_union_name)
				self.__city_union_name:setPosition(cc.p(self.__city_union_name_bg:getContentSize().width/2,self.__city_union_name_bg:getContentSize().height/2))
				if isContentZh_TW() == true then
			        local ttfConfig = {}
			        ttfConfig.fontFilePath = ""
			        self.__city_union_name:setTTFConfig(ttfConfig)
			        self.__city_union_name:setSystemFontSize(16)
			    end
			end
		end
		if self.__city_union_name ~= nil then
			self.__city_union_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
			if self.info._progress_union_name ~= "" then
				self.__city_union_name:setString(self.info._progress_union_name)
			else
				self.__city_union_name:setString(self.info._union_name)
			end
		end

		if self.__city_union_name_bg ~= nil then
			self.__city_union_name_bg:setScale9Enabled(true)

			local union_width = self.__city_union_name:getContentSize().width + 30
			local name_width = self.__mine_name_bg:getContentSize().width + self.__mine_level_bg:getContentSize().width
			local width =0
			if union_width > name_width then
				width = union_width
				local level_posX = self:getPositionX() - (width - self.__mine_level_bg:getContentSize().width) / 2
				local name_width = (width - self.__mine_level_bg:getContentSize().width)
				local name_posX = level_posX + self.__mine_level_bg:getContentSize().width / 2 + name_width / 2

				self.__mine_level_bg:setPositionX(level_posX + 2)
				self.__mine_name_bg:setPositionX(name_posX - 2)
				self.__mine_name_bg:setContentSize(cc.size(name_width, self.__mine_name_bg:getContentSize().height))
				self.__mine_name:setPositionX(name_width / 2)
			else
				width = name_width
			end

			self.__city_union_name_bg:setContentSize(cc.size(width + 20, self.__city_union_name_bg:getContentSize().height))
			self.__city_union_name:setPosition(cc.p(self.__city_union_name_bg:getContentSize().width / 2, self.__city_union_name_bg:getContentSize().height / 2))
			self.__city_union_name_bg:setPosition(cc.p(self:getPositionX(), self.__mine_name_bg:getPositionY() + self.__mine_name_bg:getContentSize().height / 2 + 11))
		end
	end

	-- 工厂等级
	local factory_level = tonumber(self.info._factory_level)
	if nil ~= self.__factory_level_icon and (self.__factory_level_icon.factory_level ~= factory_level or self.info._type ~= 3002) then
		self.__factory_level_icon:removeFromParent(false)
		table.insert(AdventureMineTileCell._city_factory_level_icon[self.__factory_level_icon.factory_level], self.__factory_level_icon)
		self.__factory_level_icon = nil
	end
	if self.info._type == 3002 then
		if self.__factory_level_icon == nil then
			if AdventureMineTileCell._city_factory_level_icon[factory_level] ~= nil then
				self.__factory_level_icon = table.remove(AdventureMineTileCell._city_factory_level_icon[factory_level], 1, 1)
			end
		end
		if nil == self.__factory_level_icon then
			local level_icon = cc.Sprite:create(string.format(config_res.images.ui.legion.legion_city_forcaty, factory_level))
			level_icon.factory_level = factory_level
			level_icon:retain()
			self.__factory_level_icon = level_icon
		end
		if nil ~= self.__factory_level_icon then
			self.__factory_level_icon:setPosition(cc.p(self.__mine_name_bg:getPositionX() + self.__mine_name_bg:getContentSize().width / 2 + self.__factory_level_icon:getContentSize().width / 2, self.__mine_name_bg:getPositionY()))
			self.parent:addChild(self.__factory_level_icon,stage)
		end
	end
end

function AdventureMineTileCell:was_hit_animation()
	if self.info == nil then
		return
	end
	-- 爆炸动画
	local function changeActionCallback(armatureBack)
		if armatureBack ~= nil and armatureBack:getParent() ~= nil then
			armatureBack:removeFromParent(true)
		end
	end
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_boom/effect_boom.ExportJson")
	local armature = ccs.Armature:create("effect_boom")
	draw.initArmature(armature, nil, -1, 0, 1)
	armature._invoke = changeActionCallback
	armature:getAnimation():playWithIndex(0)
	local pos = cc.p(self:getPosition())
	armature:setPosition(pos)
	self.parent:addChild(armature,900001)

	checkPlayEffect(52)
	if self.__rebel_hp ~= nil and tonumber(self.info._now_hp) > 0 then
		local percent = (self.info._now_hp * 100 / self.info._max_hp)
		self.__rebel_hp:setPercent(percent)
	end
	-- 叛军死亡动画
	if zstring.tonumber(self.info._type) == 1000 
		and tonumber(self.info._now_hp) == 0
		then
		local function actionCallback(armatureBack)
			if armatureBack ~= nil and armatureBack:getParent() ~= nil then
				armatureBack:removeFromParent(true)
			end
		end		
	    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_dankeng)
	    local dankeng_armature = ccs.Armature:create("effect_dankeng")
	    draw.initArmature(dankeng_armature, nil, -1, 0, 1)
    	dankeng_armature._invoke = actionCallback
	    dankeng_armature:getAnimation():playWithIndex(0)
	    dankeng_armature:setPosition(0,0)
	    self:addChild(dankeng_armature,200)

	    _ED.world_map.world_map_info_list[self.info._x .. "," .. self.info._y]._death = true
	   	_ED.world_map.world_map_info_list[self.info._x .. "," .. self.info._y]._type = -1
	    local info = _ED.world_map.world_map_info_list[self.info._x .. "," .. self.info._y]
	   	self:unload()
	   	self.info = info
	   	self.tileType = 1
	   	self:updateMapTileEx()
	end
end

function AdventureMineTileCell:updateBossInfo( ... )
	if _ED.user_enemy_strike_boss_info ~= nil 
        and _ED.user_enemy_strike_boss_info.state == 0 
        and self.info == nil
        then
        self.__enemyBoss_sprite:getAnimation():playWithIndex(0)
    else
        local boss_index = 1
	    for k,v in pairs(self.info.boss_info) do
	        if v.total_hp > 0 and v.total_hp > v.current_hp then
	            boss_index = k
	        end
	        if v.current_hp == 0 then
	            boss_index = k + 1
	        end
	    end
	    if boss_index >= 6 then
	        boss_index = 0
	    end
    	self.__enemyBoss_sprite:getAnimation():playWithIndex(boss_index)
	end
end

function AdventureMineTileCell:updateBgSpriteEx( pos )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("map/world/effect_sea.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("map/world/effect_edge.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("map/world/effect_edge_1.ExportJson")
	if self._bg_sprite_normal ~= nil then
		table.insert(AdventureMineTileCell._world_sea_animation, self._bg_sprite_normal)
		self._bg_sprite_normal:removeFromParent(true)
		self._bg_sprite_normal = nil
	end
	if self._bg_sprite ~= nil then
		self._bg_sprite:removeFromParent(true)
		self._bg_sprite = nil
	end
	if self._bg_edge_sprite ~= nil then
		table.insert(AdventureMineTileCell._world_edge_animation, self._bg_edge_sprite)
		self._bg_edge_sprite:removeFromParent(true)
		self._bg_edge_sprite = nil
	end
	if self._layer_edge_sprite_1 ~= nil then
		table.insert(AdventureMineTileCell._world_edge_layer_animation, self._layer_edge_sprite_1)
		self._layer_edge_sprite_1:removeFromParent(true)
		self._layer_edge_sprite_1 = nil
	end
	if self._layer_edge_sprite_2 ~= nil then
		table.insert(AdventureMineTileCell._world_edge_layer_animation, self._layer_edge_sprite_2)
		self._layer_edge_sprite_2:removeFromParent(true)
		self._layer_edge_sprite_2 = nil
	end
	if zstring.tonumber(self.tileType) < 0 then
		self._bg_edge_sprite = table.remove(AdventureMineTileCell._world_edge_animation, 1, 1)
		if self._bg_edge_sprite == nil then
			self._bg_edge_sprite = ccs.Armature:create("effect_edge")
            self._bg_edge_sprite:getAnimation():playWithIndex(0)
            self._bg_edge_sprite:retain()
		end
		if self._bg_edge_sprite ~= nil then
			self.parent:addChild(self._bg_edge_sprite, -4)
			self._bg_edge_sprite:setPosition(pos)
		end
	else
		local mx = 599 + self.tileX + 1
		local my = self.tileY + 1
		local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
		if ta_x > 0 and ta_y > 0 then
			local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
			if zstring.tonumber(ta_x) == 600
				or zstring.tonumber(ta_x) == 1
				or zstring.tonumber(ta_y) == 600
				or zstring.tonumber(ta_y) == 1
				then
				self._layer_edge_sprite_1 = table.remove(AdventureMineTileCell._world_edge_layer_animation, 1, 1)
				if self._layer_edge_sprite_1 == nil then
					self._layer_edge_sprite_1 = ccs.Armature:create("effect_edge_1")
		            self._layer_edge_sprite_1:getAnimation():playWithIndex(0)
		            self._layer_edge_sprite_1:retain()
				end
				if self._layer_edge_sprite_1 ~= nil then
					self.parent:addChild(self._layer_edge_sprite_1, 0)
					self._layer_edge_sprite_1:setPosition(pos)
				end
				if zstring.tonumber(ta_x) == 600 then
					if self._layer_edge_sprite_1 ~= nil then
						self._layer_edge_sprite_1:getAnimation():playWithIndex(1)
					end
					if zstring.tonumber(ta_y) == 600 
						or zstring.tonumber(ta_y) == 1
						then
						self._layer_edge_sprite_2 = table.remove(AdventureMineTileCell._world_edge_layer_animation, 1, 1)
						if self._layer_edge_sprite_2 == nil then
							self._layer_edge_sprite_2 = ccs.Armature:create("effect_edge_1")
				            self._layer_edge_sprite_2:getAnimation():playWithIndex(0)
				            self._layer_edge_sprite_2:retain()
						end
						if self._layer_edge_sprite_2 ~= nil then
							self.parent:addChild(self._layer_edge_sprite_2, 0)
							self._layer_edge_sprite_2:setPosition(pos)
						end
						if zstring.tonumber(ta_y) == 600 then
							if self._layer_edge_sprite_2 ~= nil then
								self._layer_edge_sprite_2:getAnimation():playWithIndex(0)
							end
						else
							if self._layer_edge_sprite_2 ~= nil then
								self._layer_edge_sprite_2:getAnimation():playWithIndex(2)
							end
						end
					end
				elseif zstring.tonumber(ta_x) == 1 then
					if self._layer_edge_sprite_1 ~= nil then
						self._layer_edge_sprite_1:getAnimation():playWithIndex(3)
					end
					if zstring.tonumber(ta_y) == 600 
						or zstring.tonumber(ta_y) == 1
						then
						self._layer_edge_sprite_2 = table.remove(AdventureMineTileCell._world_edge_layer_animation, 1, 1)
						if self._layer_edge_sprite_2 == nil then
							self._layer_edge_sprite_2 = ccs.Armature:create("effect_edge_1")
				            self._layer_edge_sprite_2:getAnimation():playWithIndex(0)
				            self._layer_edge_sprite_2:retain()
						end
						if self._layer_edge_sprite_2 ~= nil then
							self.parent:addChild(self._layer_edge_sprite_2, 0)
							self._layer_edge_sprite_2:setPosition(pos)
						end
						if zstring.tonumber(ta_y) == 600 then
							if self._layer_edge_sprite_2 ~= nil then
								self._layer_edge_sprite_2:getAnimation():playWithIndex(0)
							end
						else
							if self._layer_edge_sprite_2 ~= nil then
								self._layer_edge_sprite_2:getAnimation():playWithIndex(2)
							end
						end
					end
				elseif zstring.tonumber(ta_y) == 600 then
					if self._layer_edge_sprite_1 ~= nil then
						self._layer_edge_sprite_1:getAnimation():playWithIndex(0)
					end
				elseif zstring.tonumber(ta_y) == 1 then
					if self._layer_edge_sprite_1 ~= nil then
						self._layer_edge_sprite_1:getAnimation():playWithIndex(2)
					end
				end
			end
			self._bg_sprite_normal = table.remove(AdventureMineTileCell._world_sea_animation, 1, 1)
			if self._bg_sprite_normal == nil then
				self._bg_sprite_normal = ccs.Armature:create("effect_sea")
	            self._bg_sprite_normal:getAnimation():playWithIndex(0)
	            self._bg_sprite_normal:retain()
			end
			if self._bg_sprite_normal ~= nil then
				self.parent:addChild(self._bg_sprite_normal, -4)
				self._bg_sprite_normal:setPosition(pos)
			end

			if zstring.tonumber(pic_index) == 0 then
			else
				local path_index = math.ceil(pic_index / 32)
				pic_index = math.floor(pic_index % 32)
				if pic_index == 0 then
					pic_index = 32
				end
				local col = math.ceil(pic_index / 4)
				local row = math.floor(pic_index % 4)
				if row == 0 then
					row = 4
				end
				self._bg_sprite = cc.Sprite:create("map/world/1dk"..path_index..".png", cc.rect((row - 1) * 240, (col - 1) * 120, 240, 120))
			end

			if self._bg_sprite ~= nil then
				self.parent:addChild(self._bg_sprite, -3)
				self._bg_sprite:setPosition(pos)
			end
		end
	end
end

function AdventureMineTileCell:updateBgSprite(tile, pos)
	if __lua_project_id == __lua_project_pacific_rim then
		self:updateBgSpriteEx(pos)
		return
	end
	-- if nil == self._bg_sprite then
		local str = ""
		local batch = nil
		local tex = nil
		local spx = nil
		local idx = 0
		if zstring.tonumber(self.tileType) < 0 then
			str = "map/world_npc/world_surface_3.png"
			-- spx = table.remove(AdventureMineTileCell._bg_sprite_t0, 1, 1)
			idx = 0
			batch = self.parent._batch0
			tex = self.parent._texture0
		else
			if zstring.tonumber(self.tileX)%2==0 then
				str = "map/world_npc/world_surface_1.png"
				-- spx = table.remove(AdventureMineTileCell._bg_sprite_t1, 1, 1)
				idx = 1
				batch = self.parent._batch1
				tex = self.parent._texture1
			else
				str = "map/world_npc/world_surface_2.png"
				-- spx = table.remove(AdventureMineTileCell._bg_sprite_t2, 1, 1)
				idx = 2
				batch = self.parent._batch2
				tex = self.parent._texture2
			end
		end
		if nil == self._bg_sprite 
			or self._bg_sprite._idx ~= idx
			then
			if idx == 0 then
				spx = table.remove(AdventureMineTileCell._bg_sprite_t0, 1, 1)
			elseif idx == 1 then
				spx = table.remove(AdventureMineTileCell._bg_sprite_t1, 1, 1)
			elseif idx == 2 then
				spx = table.remove(AdventureMineTileCell._bg_sprite_t2, 1, 1)
			end
		end
		if nil == spx then
			self._bg_sprite = cc.Sprite:createWithTexture(tex)
			self._bg_sprite._idx = idx
			batch:addChild(self._bg_sprite, -2)
			self._bg_sprite:retain()
		else
			self._bg_sprite = spx
			-- batch:addChild(self._bg_sprite, -2)
		end
	-- end
	if nil ~= self._bg_sprite then
		self._bg_sprite:setPosition(pos)
	end
	
	-- if nil == self._bg_sprite then
	-- 	self._bg_sprite = cc.Sprite:create()
	-- 	self.parent:addChild(self._bg_sprite, -2)
	-- end

	-- local str = ""
	-- if zstring.tonumber(self.tileType) <= 0 then
	-- 	str = "map/world_npc/world_surface_3.png"
	-- else
	-- 	if zstring.tonumber(self.tileX)%2==0 then
	-- 		str = "map/world_npc/world_surface_1.png"
	-- 	else
	-- 		str = "map/world_npc/world_surface_2.png"
	-- 	end
	-- end
	-- if self._bg_sprite._texture ~= str then
	-- 	self._bg_sprite:setTexture(str)
	-- 	self._bg_sprite._texture = str
	-- end
	-- self._bg_sprite:setPosition(pos)
end

function AdventureMineTileCell:updateMapTileEx1()
end
function AdventureMineTileCell:updateMapTileEx()
	if nil ~= self.info then
		local isUpdateFadeIn = false
		local ccax, ccay = cc.dms_init_world_map_get(1, zstring.tonumber(self.info._x), zstring.tonumber(self.info._y))
		local x = ccax - 600
		local y = ccay - 1
		local ceng = y*_ED.mine_tile_width + x
		local boom_state = 0

		if nil ~= self.olf_info_type and self.olf_info_type ~= self.info._type then
			if self.olf_info_type == 0 
				or self.info._type == 0
				or self.info.olf_info_type == 3000
				or self.info._type == 3000
				or self.info.olf_info_type == 3001
				or self.info._type == 3001
				or self.info.olf_info_type == 3002
				or self.info._type == 3002
				then
				self:removeObjects()
			else

			end
		elseif self.olf_info_type == self.info._type 
			and (self.info._type == 3000 or self.info._type == 3001 or self.info._type == 3002)
			then
			self:removeObjects()
		end
		self.olf_info_type = self.info._type

		if self.info._type == 0 then
			local glories = zstring.tonumber(self.info._glories)/zstring.tonumber(self.info._max_boom)*100
			local _glories = zstring.tonumber(self.info._glories)
		    if self.info._online_state == 1 then
				local s_time = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self.info._boom_restore_time)/1000
		    	_glories = getBoomReplyalgorithm(zstring.tonumber(self.info._glories),zstring.tonumber(self.info._max_boom),s_time)
		    end
			if tonumber(self.info._userId) == tonumber(_ED.user_info.user_id) then
				_glories = zstring.tonumber(_ED.user_info.booming)
				self.info._max_boom = zstring.tonumber(_ED.user_info.forage)
			end
		    local boom_bar = zstring.tonumber(_glories)/zstring.tonumber(self.info._max_boom)
		    for i, v in pairs(dms["build_boom_lose"]) do
		        local boom_proportion = dms.atos(v, build_boom_lose.boom_proportion)
		        if boom_bar >= tonumber(boom_proportion) then
		            boom_state = dms.atoi(v, build_boom_lose.boom_state)
		            break
		        end
		    end
			if nil == self.__blink_sprite then
				self.__blink_sprite = table.remove(AdventureMineTileCell._city_armature, 1, 1)
				if nil == self.__blink_sprite then
					local fileName = "map/base_npc/spirte_beattacked.ExportJson"
					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
					local sprite = ccs.Armature:create("spirte_beattacked")
					sprite:retain()
					-- table.insert(AdventureMineTileCell._city_armature, sprite)
					self.__blink_sprite = sprite
				end
				if nil == self.__blink_sprite._parent then
					self.parent:addChild(self.__blink_sprite,ceng)
					self.__blink_sprite._parent = self.parent
					isUpdateFadeIn = true
				else
					isUpdateFadeIn = false	
				end
				local pos = cc.p(self:getPosition())
				self.__blink_sprite:setPosition(pos)
			end
			local size = self.__blink_sprite:getContentSize()
			--绘制基地附加信息
			self:updateDrawUserCityInfo(size,ceng+1,_glories,boom_state)	
		elseif self.info._type == 1000 then
			if tonumber(self.info._now_hp) > 0 then
				if nil == self.__haunt_sprite then
					local icon = dms.int(dms["rebel_haunt_mould"], self.info._mould_id, rebel_haunt_mould.icon)
					if AdventureMineTileCell._rebel_haunt_armature[icon] ~= nil then
						self.__haunt_sprite = table.remove(AdventureMineTileCell._rebel_haunt_armature[icon], 1, 1)
					end
					if nil == self.__haunt_sprite then
						local fileName = string.format("sprite/spirte_battle_card_%d.ExportJson", icon)
						if true == cc.FileUtils:getInstance():isFileExist(fileName) then
							ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
							local bgtsprite = ccs.Armature:create(string.format("spirte_battle_card_%d", icon))
							bgtsprite:getAnimation():playWithIndex(0)
							bgtsprite:retain()
							self.__haunt_sprite = bgtsprite
							AdventureMineTileCell._rebel_haunt_armature[icon] = AdventureMineTileCell._rebel_haunt_armature[icon] or {}
        					-- table.insert(AdventureMineTileCell._rebel_haunt_armature[self.__haunt_sprite._pic], bgtsprite)
						end
					end
					self.__haunt_sprite._pic = icon
					if nil == self.__haunt_sprite._parent then
						self.parent:addChild(self.__haunt_sprite,ceng)
						self.__haunt_sprite._parent = self.parent
						isUpdateFadeIn = true
					else
						isUpdateFadeIn = false	
					end
					-- self.__haunt_sprite:setAnchorPoint(cc.p(0.5, 0.5))
					self.__haunt_sprite:setPosition(cc.p(self:getPositionX(),self:getPositionY()+AdventureMineTileCell.__size.height/2))
				end
				local size = self.__haunt_sprite:getContentSize()
				self:updateDrawRebelHaunt(size,ceng+1)
			elseif tonumber(self.info._now_hp) <= 0 then
				self:was_hit_animation()
			end
		elseif self.info._type == 2000 then
			local mx = 599 + self.tileX + 1
			local my = self.tileY + 1
			local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
			local base_info = zstring.split(zstring.split(dms.string(dms["enemy_boss_config"], 14, enemy_boss_config.param), "|")[1], ",")
			if zstring.tonumber(self.info._x) == zstring.tonumber(base_info[1]) 
				and zstring.tonumber(self.info._y) == zstring.tonumber(base_info[2])
				then
				if self.__enemyBoss_sprite == nil then
					self.__enemyBoss_sprite = table.remove(AdventureMineTileCell._boss_armature, 1, 1)
					if nil == self.__enemyBoss_sprite then
						ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boss)
						self.__enemyBoss_sprite = ccs.Armature:create("effect_boss")
						self.__enemyBoss_sprite:getAnimation():playWithIndex(0)
						self.__enemyBoss_sprite:retain()
						-- self.parent:addChild(self.__enemyBoss_sprite, ceng)
						-- self.__enemyBoss_sprite._parent = self.parent
						AdventureMineTileCell._boss_armature = AdventureMineTileCell._boss_armature or {}
					end
				end
				if nil == self.__enemyBoss_sprite._parent then
					self.parent:addChild(self.__enemyBoss_sprite, ceng)
					self.__enemyBoss_sprite._parent = self.parent
					self.__enemyBoss_sprite:setPosition(cc.p(self:getPositionX(), self:getPositionY()+AdventureMineTileCell.__size.height/2))
				end
				self:updateBossInfo()
			end
		elseif self.info._type == 3000 
			or self.info._type == 3001
			or self.info._type == 3002
			then
			if nil == self.__world_city_sprite then
				local armatureIndex = dms.int(dms["world_city_mould"], self.info._mould_id, world_city_mould.armature_index)
				self.__world_city_sprite = table.remove(AdventureMineTileCell._world_city_armature, 1, 1)
				if nil == self.__world_city_sprite then
					local fileName = config_res.map.world_npc.effice_city
					if true == cc.FileUtils:getInstance():isFileExist(fileName) then
						ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
						local bgtsprite = ccs.Armature:create("effice_city")
						bgtsprite:getAnimation():playWithIndex(armatureIndex - 1)
						bgtsprite:retain()
						self.__world_city_sprite = bgtsprite
						AdventureMineTileCell._world_city_armature = AdventureMineTileCell._world_city_armature or {}
					end
				end
				if nil == self.__world_city_sprite._parent then
					self.parent:addChild(self.__world_city_sprite,ceng)
					self.__world_city_sprite._parent = self.parent
					isUpdateFadeIn = true
				else
					isUpdateFadeIn = false	
				end
				self.__world_city_sprite:getAnimation():playWithIndex(armatureIndex - 1)
				self.__world_city_sprite:setPosition(cc.p(self:getPositionX(),self:getPositionY()+AdventureMineTileCell.__size.height/2))
			end
			local size = self.__world_city_sprite:getContentSize()
			self:updateWorldCityInfo(size, ceng+1)
		elseif self.info._type > 0 then
			-- if "0" ~= self.info._bg_pix then
			-- 	local fileName = string.format("map/base_npc/map_%s.png", self.info._bg_pix)
			-- 	if true == cc.FileUtils:getInstance():isFileExist(fileName) then
			-- 		local bgtsprite = cc.Sprite:create(fileName)
			-- 		bgtsprite:setPosition(pos)
			-- 		self.parent:addChild(bgtsprite, -1)
			-- 	end
			-- end

			local pos = cc.p(self:getPosition())

			local element = dms.element(dms["world_mine_mould"], self.info._mould_id)
			local pic = dms.atos(element, world_mine_mould.pic)
			local sprite = nil
			local size = nil
			if self.info._type <= 5 then
				if nil == self.__mine_sprite then
					AdventureMineTileCell._mine_armatures[pic] = AdventureMineTileCell._mine_armatures[pic] or {}
					self.__mine_sprite = table.remove(AdventureMineTileCell._mine_armatures[pic], 1, 1)
					if nil == self.__mine_sprite then
						local effect_paths = string.format(config_res.images.ui.home.home_build_effect, tonumber(pic))
				        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
						self.__mine_sprite = ccs.Armature:create("home_build_"..pic)
						self.__mine_sprite:retain()
						self.__mine_sprite._pic = pic
					end

					self.__mine_sprite:setScale(0.75)
				end
				
				pos.y = pos.y + AdventureMineTileCell.__size.height/2-18
				local armature_index = dms.atoi(element, world_mine_mould.armature_index)
				draw.initArmature(self.__mine_sprite, nil, -1, 0, 1)
				if __lua_project_id == __lua_project_pacific_rim then
					local mx = 599 + self.tileX + 1
					local my = self.tileY + 1
					local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
					if ta_x > 0 and ta_y > 0 then
						local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
						if pic_index == 0 then
							self.__mine_sprite:getAnimation():playWithIndex(armature_index + 4)
						else
							self.__mine_sprite:getAnimation():playWithIndex(armature_index)
						end
					end
				else
					self.__mine_sprite:getAnimation():playWithIndex(armature_index)
				end
				
				if nil == self.__mine_sprite._parent then
					self.__mine_sprite:setAnchorPoint(cc.p(0.5, 0.5))
					self.parent:addChild(self.__mine_sprite,ceng)
					self.__mine_sprite._parent = self.parent
					isUpdateFadeIn = true
				else
					isUpdateFadeIn = false	
				end
				self.__mine_sprite:setPosition(pos)
				size = self.__mine_sprite:getContentSize()
				self:updateDrawMineLevel(size,ceng+1)
			else
				if nil == self.__tile_sprite then
					AdventureMineTileCell._tile_sprites[pic] = AdventureMineTileCell._tile_sprites[pic] or {}
					self.__tile_sprite = table.remove(AdventureMineTileCell._tile_sprites[pic], 1, 1)
					if nil == self.__tile_sprite then
						local batch = self.parent._batch_tiles[pic]
						self.__tile_sprite = cc.Sprite:createWithTexture(batch:getTexture())
						self.parent:addChild(self.__tile_sprite, -2)
						self.__tile_sprite:retain()
						self.__tile_sprite._pic = pic
						isUpdateFadeIn = true
					else
						-- local batch = self.parent._batch_tiles[pic]
						self.parent:addChild(self.__tile_sprite, -2)
						isUpdateFadeIn = false
					end
					pos.y = pos.y + AdventureMineTileCell.__size.height / 2 - 18
					self.__tile_sprite:setPosition(pos)
					size = self.__tile_sprite:getContentSize()
				end
			end
		end

		if self.info ~= nil and (self.info._need_update == true or isUpdateFadeIn == true) then
			local sprite = nil
			if nil ~= self.__blink_sprite then
				sprite = self.__blink_sprite
			elseif nil ~= self.__mine_sprite then
				sprite = self.__mine_sprite
			elseif nil ~= self.__tile_sprite then
				sprite = self.__tile_sprite
			end

			if nil ~= sprite then
				sprite:setOpacity(0)
				sprite:runAction(cc.FadeIn:create(0.3))
			end

			if nil ~= self.__shelter_sprite then
				self.__shelter_sprite:setOpacity(0)
				self.__shelter_sprite:runAction(cc.FadeIn:create(0.3))
			end

			function blinkOutCallback(sender)
				if nil == sender.info then
					return
				end
				if _ED.world_map_focus ~= nil and tonumber(_ED.world_map_focus[1]) == tonumber(sender.info._x) and tonumber(_ED.world_map_focus[2]) == tonumber(sender.info._y) then
					if nil ~= sprite then
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
					end
				end
			end
			self:stopAllActions()
			self:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.4),
				cc.CallFunc:create(blinkOutCallback)
				))

		end
		if self.info~= nil then
			self:updateDrawAllComponents(boom_state,ceng)
		end
	end
	if nil == self._bg_sprite then
		self:updateBgSprite(tile, cc.p(self:getPosition()))
	end
end

function AdventureMineTileCell:updateMapTile()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return
	end

	local root = self.roots[1]
	if root == nil then 
		return false
	end
	local tile = ccui.Helper:seekWidgetByName(root, "Panel_mine")
	local isUpdateFadeIn = false
	self._tile = tile
	if tile._sprite== nil then
		isUpdateFadeIn = true
	end
	tile:removeAllChildren(true)
	tile._sprite = nil
	
	-- local bgsprite = nil

	-- if zstring.tonumber(self.tileType) == 0 then
	-- 	-- bg:setBackGroundImage("map/world_npc/world_surface_3.png")
	-- 	bgsprite = cc.Sprite:create("map/world_npc/world_surface_3.png")
	-- else
	-- 	if zstring.tonumber(self.tileX)%2==0 then
	-- 		-- bg:setBackGroundImage("map/world_npc/world_surface_1.png")
	-- 		bgsprite = cc.Sprite:create("map/world_npc/world_surface_1.png")
	-- 	else
	-- 		-- bg:setBackGroundImage("map/world_npc/world_surface_2.png")
	-- 		bgsprite = cc.Sprite:create("map/world_npc/world_surface_2.png")
	-- 	end
	-- end
	-- tile:addChild(bgsprite)

	local size = tile:getContentSize()
	local posx, posy = self:getPosition()
	local pos = cc.p(tile:getPosition())
	pos.x = posx
	pos.y = posy
	
	-- if nil ~= self._bg_sprite then
	-- 	self._bg_sprite:removeFromParent(true)
	-- 	self._bg_sprite = nil
	-- end

	-- if nil == tile._sprite then
	-- 	local bgsprite = nil
	-- 	if zstring.tonumber(self.tileType) <= 0 then
	-- 		-- bg:setBackGroundImage("map/world_npc/world_surface_3.png")
	-- 		bgsprite = cc.Sprite:create("map/world_npc/world_surface_3.png")
	-- 	else
	-- 		if zstring.tonumber(self.tileX)%2==0 then
	-- 			-- bg:setBackGroundImage("map/world_npc/world_surface_1.png")
	-- 			bgsprite = cc.Sprite:create("map/world_npc/world_surface_1.png")
	-- 		else
	-- 			-- bg:setBackGroundImage("map/world_npc/world_surface_2.png")
	-- 			bgsprite = cc.Sprite:create("map/world_npc/world_surface_2.png")
	-- 		end
	-- 	end
	-- 	bgsprite:setPosition(pos)
	-- 	self.parent:addChild(bgsprite, -2)
	-- 	self._bg_sprite = bgsprite
	-- end
	self:updateBgSprite(tile, pos)

	if nil ~= self.info then
		if nil ~= tile._sprite then
			tile._sprite:removeFromParent(true)
		end
		tile._sprite = nil
		local ccax, ccay = cc.dms_init_world_map_get(1, zstring.tonumber(self.info._x), zstring.tonumber(self.info._y))
		x = ccax - 600
		y = ccay - 1
		local ceng = y*_ED.mine_tile_width + x
		if self.info._type == 0 then
			local pic = 3
			local sprite = nil
			local glories = zstring.tonumber(self.info._glories)/zstring.tonumber(self.info._max_boom)*100
			local _glories = zstring.tonumber(self.info._glories)
		    if self.info._online_state == 1 then
				local s_time = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self.info._boom_restore_time)/1000
			    _glories = getBoomReplyalgorithm(zstring.tonumber(self.info._glories),zstring.tonumber(self.info._max_boom),s_time)
		    end
			local boom_state = 0
		    local boom_bar = zstring.tonumber(_glories)/zstring.tonumber(self.info._max_boom)
		    for i= 1, dms.count(dms["build_boom_lose"]) do
		        local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
		        if boom_bar >= tonumber(boom_proportion) then
		            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
		            break
		        end
		    end


			local fileName = "map/base_npc/spirte_beattacked.ExportJson"
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
			local sprite = ccs.Armature:create("spirte_beattacked")
			if tonumber(self.info._talent_id) <= 0 then
				local level_Info = self.info._level
				local max_id = dms.int(dms["arena_config"],10,arena_config.param)
				if tonumber(self.info._userId) <= max_id then
					level_Info = dms.string(dms["world_config"], 20 , world_config.param)
				end
				local pic = zstring.split(dms.string(dms["user_experience_param"], level_Info, user_experience_param.base_pic),",")
				-- sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]))
				for i, v in pairs(baseImageAnimation) do
					if tonumber(v) == tonumber(pic[boom_state+1]) then
						if __lua_project_id == __lua_project_pacific_rim then
							local mx = 599 + self.tileX + 1
							local my = self.tileY + 1
							local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
							if ta_x > 0 and ta_y > 0 then
								local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
								if pic_index == 0 then
									sprite:getAnimation():playWithIndex(i + 16)
								else
									sprite:getAnimation():playWithIndex(i-1)
								end
							end
						else
							sprite:getAnimation():playWithIndex(i-1)
						end
						break
					end
				end
				
				-- if glories < 31 then
				-- 	sprite:getAnimation():playWithIndex(2)
				-- elseif glories < 77 and glories > 31 then
				-- 	sprite:getAnimation():playWithIndex(1)
				-- else
				-- 	sprite:getAnimation():playWithIndex(0)
				-- end
			else
				local build_ids = zstring.split(dms.string(dms["talent_mould"], tonumber(self.info._talent_id), talent_mould.base_additional), "|")
				local picData = zstring.split(build_ids[1], ",")
				local talentTime = tonumber(self.info._talent_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
				if tonumber(picData[1]) == 70 and talentTime > 0 then
					if tonumber(picData[2]) == 401 
					or tonumber(picData[2]) == 402 
					or tonumber(picData[2]) == 403 
					or tonumber(picData[2]) == 404 
					or tonumber(picData[2]) == 405 then
						for i, v in pairs(baseImageAnimation) do
							if tonumber(v) == tonumber(picData[2]) then
								if __lua_project_id == __lua_project_pacific_rim then
									local mx = 599 + self.tileX + 1
									local my = self.tileY + 1
									local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
									if ta_x > 0 and ta_y > 0 then
										local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
										if pic_index == 0 then
											sprite:getAnimation():playWithIndex(i + 16)
										else
											sprite:getAnimation():playWithIndex(i-1)
										end
									end
								else
									sprite:getAnimation():playWithIndex(i-1)
								end
								break
							end
						end
					else
						sprite = nil
						sprite = cc.Sprite:create(string.format("map/base_npc/map_%d.png", picData[2]))
					end
				else
					if __lua_project_id == __lua_project_pacific_rim then
						local mx = 599 + self.tileX + 1
						local my = self.tileY + 1
						local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
						if ta_x > 0 and ta_y > 0 then
							local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
							if pic_index == 0 then
								sprite:getAnimation():playWithIndex(boom_state + 17)
							else
								sprite:getAnimation():playWithIndex(boom_state)
							end
						end
					else
						sprite:getAnimation():playWithIndex(boom_state)
					end
					-- if glories < 31 then
					-- 	sprite:getAnimation():playWithIndex(2)
					-- elseif glories < 77 and glories > 31 then
					-- 	sprite:getAnimation():playWithIndex(1)
					-- else
					-- 	sprite:getAnimation():playWithIndex(0)
					-- end
				end
			end
			-- setTexture换图的方法
			tile:addChild(sprite,ceng)
			-- sprite:setAnchorPoint(cc.p(0.5, 0.5))
			-- sprite:setPosition(cc.p(320, 160))
			tile._sprite = sprite
			self:updateDrawUserCityInfo(sprite:getContentSize(),ceng,_glories,boom_state)
			tile.__blink_sprite = sprite
		elseif self.info._type == 1000 then
			if tonumber(self.info._now_hp) > 0 then
				local icon = dms.int(dms["rebel_haunt_mould"], self.info._mould_id, rebel_haunt_mould.icon)
				local fileName = string.format("sprite/spirte_battle_card_%d.ExportJson", icon)
				if true == cc.FileUtils:getInstance():isFileExist(fileName) then
					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
					local bgtsprite = ccs.Armature:create(string.format("spirte_battle_card_%d", icon))
					bgtsprite:getAnimation():playWithIndex(0)
					-- bgtsprite:setPosition(pos)
					-- bgtsprite:setScale(0.75)
					-- setTexture换图的方法
					tile:addChild(bgtsprite,ceng)
					-- bgtsprite:setAnchorPoint(cc.p(0.5, 0.5))
					bgtsprite:setPositionY(tile:getContentSize().height/2)
					tile._sprite = bgtsprite
					--debug.print_r(self.info)
					self:updateDrawRebelHaunt(bgtsprite:getContentSize(),ceng)
					tile.__blink_sprite = bgtsprite
				end
			end
		elseif self.info._type > 0 then
			if "0" ~= self.info._bg_pix then
				local fileName = string.format("map/base_npc/map_%s.png", self.info._bg_pix)
				if true == cc.FileUtils:getInstance():isFileExist(fileName) then
					local bgtsprite = cc.Sprite:create(fileName)
					bgtsprite:setPosition(pos)
					self.parent:addChild(bgtsprite, -1)
				end
			end

			local element = dms.element(dms["world_mine_mould"], self.info._mould_id)
			local pic = dms.atos(element, world_mine_mould.pic)
			local sprite = nil
			if self.info._type <= 5 then
				local armature_index = dms.atoi(element, world_mine_mould.armature_index)
				local effect_paths = string.format(config_res.images.ui.home.home_build_effect, tonumber(pic))
		        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
				local armature = ccs.Armature:create("home_build_"..pic)
				draw.initArmature(armature, nil, -1, 0, 1)
				if __lua_project_id == __lua_project_pacific_rim then
					local mx = 599 + self.tileX + 1
					local my = self.tileY + 1
					local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
					if ta_x > 0 and ta_y > 0 then
						local pic_index = zstring.tonumber(_ED.world_map_info[601 - zstring.tonumber(ta_x)][601 - zstring.tonumber(ta_y)])
						if pic_index == 0 then
							armature:getAnimation():playWithIndex(armature_index + 4)
						else
							armature:getAnimation():playWithIndex(armature_index)
						end
					end
				else
					armature:getAnimation():playWithIndex(armature_index)
				end
				armature:setPosition(0,tile:getContentSize().height/2)
				armature:setScale(0.75)
				sprite = armature
			else
				sprite = cc.Sprite:create(string.format("map/base_npc/map_%s.png", pic))
			end
			if nil ~= tile._sprite then
				tile._sprite:removeFromParent(true)
			end

			tile:addChild(sprite,ceng)
			sprite:setAnchorPoint(cc.p(0.5, 0.5))
			sprite:setPositionY(tile:getContentSize().height/2-18)
			-- sprite:setPosition(cc.p(320, 160))
			tile._sprite = sprite
			self:updateDrawMineLevel(sprite:getContentSize())
		elseif self.info._type < 0 then
			if "0" ~= self.info._bg_pix then
				local fileName = string.format("map/base_npc/map_%s.png", self.info._bg_pix)
				if true == cc.FileUtils:getInstance():isFileExist(fileName) then
					local bgtsprite = cc.Sprite:create(fileName)
					bgtsprite:setPosition(pos)
					self.parent:addChild(bgtsprite, -1)
				end
			end
		end
		if nil ~= tile._sprite then
			local mx = 599 + self.tileX + 1
			local my = self.tileY + 1
			local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
			if self.info._need_update == true or isUpdateFadeIn == true then
				tile._sprite:setOpacity(0)
				tile._sprite:runAction(cc.FadeIn:create(0.2))
			end
			function blinkOutCallback(sender)
				if _ED.world_map_focus ~= nil and tonumber(_ED.world_map_focus[1]) == tonumber(ta_x) and tonumber(_ED.world_map_focus[2]) == tonumber(ta_y) then
					state_machine.excute("adventure_mine_cell_focus_blink", 0, _ED.world_map_focus)
				end
			end
			tile._sprite:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.2),
				cc.CallFunc:create(blinkOutCallback)
				))
		end
		state_machine.unlock("red_alert_time_mine_cell_click")
	end
end

function AdventureMineTileCell:updateDraw()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return
	end

	local root = self.roots[1]
	if root == nil then 
		return false
	end
	self.start_bubble_time = 0 
	self.start_bubble_over = 0 
	self.start_play = false
	self.over_play = false
	self.move_close_bubble = false
	local tile = ccui.Helper:seekWidgetByName(root, "Panel_mine")

	local role = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
	role:removeBackGroundImage()
	tile:removeAllChildren(true)
	tile:removeBackGroundImage()

	self._tile = tile
	self._role = role

	-- if dms.int(dms["mine_grid"], self.tileType+1, mine_grid.resource_type) == 2 then
		-- tile:setBackGroundImage("map/mine/monster_1.png")
	-- elseif dms.int(dms["mine_grid"], self.tileType+1, mine_grid.resource_type) == 3 the
		-- tile:setBackGroundImage("map/mine/monster_2.png")
	-- else
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		tile._sprite = nil
		
		-- local bg = ccui.Helper:seekWidgetByName(root, "Panel_bg")
		-- bg:removeAllChildren(true)
		-- local sprite = null

		-- if zstring.tonumber(self.tileType) == 0 then
		-- 	-- bg:setBackGroundImage("map/world_npc/world_surface_3.png")
		-- 	sprite = cc.Sprite:create("map/world_npc/world_surface_3.png")
		-- else
		-- 	if zstring.tonumber(self.tileX)%2==0 then
		-- 		-- bg:setBackGroundImage("map/world_npc/world_surface_1.png")
		-- 		sprite = cc.Sprite:create("map/world_npc/world_surface_1.png")
		-- 	else
		-- 		-- bg:setBackGroundImage("map/world_npc/world_surface_2.png")
		-- 		sprite = cc.Sprite:create("map/world_npc/world_surface_2.png")
		-- 	end
		-- end
		-- tile:addChild(sprite, -1000)

		if nil == self.info and nil ~= _ED.world_map then
			if nil ~= self.tileType and self.tileType >= 0 then
                local mx = 599 + self.tileX + 1
                local my = self.tileY + 1
                -- local ta = _ED.cta[my][mx]
				local ta = {}
				local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
				ta.x = ta_x
				ta.y = ta_y
                -- if nil ~= ta then
				if ta.x > -1 and ta.y > -1 then
	                -- print(self.tileX, self.tileY, 599 + self.tileX + 1, self.tileY + 1, _ED.cta[my][mx].x, _ED.cta[my][mx].y)
	                local info = _ED.world_map.world_map_info_list[ta.x .. "," .. ta.y]
	                -- if nil ~= info then
	                --     debug.print_r(info)
	                -- end
	                if nil ~= info then
	                    if self.info == nil or (self.info._type ~= info._type or self.info._id ~= info._id) then
	                        self.info = info
	                    end
	                end
	            end
            end
		end

		-- if nil ~= self.info then
			self:updateMapTile()
		-- end
	else
		local resource_type = dms.int(dms["mine_grid"], self.tileType, mine_grid.resource_type)
	
		self.resource_type = resource_type
		if zstring.tonumber(self.tileType) == 0 then
			tile:setBackGroundImage("map/mine/tile_0.png")
		else
			if resource_type == 2 then
				tile:setBackGroundImage("map/mine/monster_1.png")
			elseif resource_type == 3 then
				tile:setBackGroundImage("map/mine/monster_2.png")
			else
				if dms.int(dms["mine_grid"], self.tileType, mine_grid.get_item_id) > 0 then
					if _ED.adventure_mine.current_mine ~= nil and tonumber(_ED.adventure_mine.current_mine.x) == tonumber(self.tileX) and tonumber(_ED.adventure_mine.current_mine.y) == tonumber(self.tileY) and tonumber(_ED.adventure_mine.current_mine.mining_cd) == 0 then 
						tile:setBackGroundImage("map/mine/tile_0.png")
					else
						if  resource_type == 4 then 
							local picIndex = dms.int(dms["mine_grid"], self.tileType, mine_grid.pic_index)
							tile:setBackGroundImage("map/mine/packs_"..picIndex..".png")		
						else
							local picIndex = dms.int(dms["mine_grid"], self.tileType, mine_grid.pic_index)
							tile:setBackGroundImage("map/mine/mine_"..picIndex..".png")
						end
						
					end
				else
					if zstring.tonumber(self.tileY) == 0 then
						if zstring.tonumber(self.tileType) ~= 0 then
							tile:setBackGroundImage("map/mine/top.png")
						else
							tile:setBackGroundImage("map/mine/top_1.png")
						end
					else
						
						if resource_type == 6 then
							--Npc
							local npc_data = _ED.mine_random_npc_cells["" .. self.tileX .. "," .. (self.tileY)]
							if npc_data == nil then 
							else
								role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", npc_data._headPic))
							end
							tile:setBackGroundImage("map/mine/tile_1.png")
							
						elseif resource_type == 7 then 
							--boss
							local boss_data = _ED.mine_random_boss_cells["" .. self.tileX .. "," .. self.tileY]
							if boss_data == nil then 
								--self.boss_id = -1 
								self.boss_id = 2144 
							else
								local picIndex = dms.int(dms["npc"], boss_data._id, npc.base_pic)
								self.boss_id = tonumber(boss_data._id)
								
								role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
							end
							tile:setBackGroundImage("map/mine/tile_1.png")

						else
							local picIndex = dms.int(dms["mine_grid"], self.tileType, mine_grid.pic_index)

							tile:setBackGroundImage("map/mine/tile_"..picIndex..".png")
						end
						
					end
				end
			end
		end
	end
end

-- function AdventureMineTileCell:onInitBubble()
-- 	--if self.resource_type == 7 then 
-- 	if tonumber(self.tileX) == 1 and tonumber(self.tileY) == 10 then 

-- 		print("----kkkk.....")
-- 		self.boss_id = 2144
-- 		if self.boss_id ~= -1 then
-- 			print("----调用开始......")
-- 			local scheduler = cc.Director:getInstance():getScheduler()  
		
-- 			self.schedulerStartID  = scheduler:scheduleScriptFunc(function ()
--       			state_machine.excute("adventure_mine_boss_bubble_draw",0 ,{node = self,isOpen = true})	
--           		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerStartID)
--    			end,5.0,false)

-- 			self.schedulerOverID = scheduler:scheduleScriptFunc(function ()
--       			state_machine.excute("adventure_mine_boss_bubble_draw",0 ,{node = self,isOpen = false})	
--           		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerOverID)
--           		self:onInitBubble()
--    			end,15,false)
--    			print(self.schedulerStartID,self.schedulerOverID)
-- 		end
-- 	end
-- end

function AdventureMineTileCell:onInit()
	-- local csbAdventureMineTileCell = csb.createNode("campaign/Mining/wakuang_item.csb")
	self.roots = {}
 	local root = nil
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		-- root = cacher.clone(config_csb.world_map.mine_item_cell, "root")
		-- self:setTouchEnabled(true)
		-- self:setSwallowTouches(false)

		local function formationTouchListener(sender, eventType)
			local isMoving = false
			if eventType == ccui.TouchEventType.began then
				isMoving = false
				pushEffect(formatMusicFile("button", 1))
				AdventureMine.__isCanClick = true
			elseif eventType == ccui.TouchEventType.moved then 
				isMoving = true
			elseif eventType == ccui.TouchEventType.ended 
				or eventType == ccui.TouchEventType.canceled 
				then 
				if AdventureMine.__isCanClick == true then 
					if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
						state_machine.excute("red_alert_time_mine_cell_click",0,{_datas = {cell = self }})
					else
						state_machine.excute("adventure_mine_tile_cell_exploit",0,{_datas = {cell = self }})
					end
				end
			else
				if isMoving == false then 
					if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
						state_machine.excute("red_alert_time_mine_cell_click",0,{_datas = {cell = self }})
					else
						state_machine.excute("adventure_mine_tile_cell_exploit",0,{_datas = {cell = self }})
					end
				end
			end
		end

		local buttonlayer = ccui.Layout:create()
   	 	buttonlayer:setAnchorPoint(cc.p(0.5, 0.5))
    	buttonlayer:setContentSize(cc.size(120, 120))
    	buttonlayer:setTouchEnabled(true)
		buttonlayer:setSwallowTouches(false)
    	self:addChild(buttonlayer)
    	-- buttonlayer:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
		buttonlayer:addTouchEventListener(formationTouchListener)
		self:updateBgSprite(self._tile, cc.p(self:getPosition()))
		return
	else
		root = cacher.clone("campaign/Mining/wakuang_item.csb", "root")
	end
    table.insert(self.roots, root)
    root:removeFromParent(false)
 	self:addChild(root)
 	root:setSwallowTouches(false)
 	if AdventureMineTileCell.__size == nil then
		AdventureMineTileCell.__size = root:getContentSize()
	end
	self:setContentSize(AdventureMineTileCell.__size)
 	root:setSwallowTouches(false)
	self:updateDraw()
 	
 	--self:onInitBubble()
 	local wakuangButton = root:getChildByName("Button_wakuang")
 	wakuangButton:setSwallowTouches(false)
 	-- 开采
    -- fwin:addTouchEventListener(root, nil, 
    -- {
    --     terminal_name = "adventure_mine_tile_cell_exploit", 
    --     terminal_state = 0,
    --     cell = self,
    --     isPressedActionEnabled = false
    -- }, 
    -- nil, 0)
	local isMoving = false
	--教学特殊处理
	if zstring.tonumber(self.tileX) == AdventureMineTileCell.__teach_x and zstring.tonumber(self.tileY) == AdventureMineTileCell.__teach_y  then 
		 
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			fwin:addTouchEventListener(wakuangButton,       nil, 
			{
				terminal_name = "red_alert_time_mine_cell_click",  
				terminal_state = 0,
				touch_scale = false,
				touch_scale_xy = 1,
				touch_black = true,
				cell = self
			}, 
			nil, 0)
		else
			fwin:addTouchEventListener(wakuangButton,       nil, 
			{
				terminal_name = "adventure_mine_tile_cell_exploit",         
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end
	else
		-- 点击时移动不挖矿
	     -- 这个地方如果只是侦听按钮的移动,会太敏感导致不能正常点击  isMoving 太敏感了.
		local function formationTouchListener(sender, eventType)
		
			if eventType == ccui.TouchEventType.began then
				isMoving = false
				pushEffect(formatMusicFile("button", 1))
				AdventureMine.__isCanClick = true
			elseif eventType == ccui.TouchEventType.moved then 
				isMoving = true
			elseif eventType == ccui.TouchEventType.ended 
				or eventType == ccui.TouchEventType.canceled 
				then 
				if AdventureMine.__isCanClick == true then 
					if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
						state_machine.excute("red_alert_time_mine_cell_click",0,{_datas = {cell = self }})
					else
						state_machine.excute("adventure_mine_tile_cell_exploit",0,{_datas = {cell = self }})
					end
				end
			else
				if isMoving == false then 
					if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
						state_machine.excute("red_alert_time_mine_cell_click",0,{_datas = {cell = self }})
					else
						state_machine.excute("adventure_mine_tile_cell_exploit",0,{_datas = {cell = self }})
					end
				end
			end
		end
		wakuangButton:addTouchEventListener(formationTouchListener)
	end
end

function AdventureMineTileCell:onExit()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	else
		cacher.freeRef("campaign/Mining/wakuang_item.csb", self.roots[1])
		self.roots = {}
	end
end

function AdventureMineTileCell:reset(parent, x, y, type, sx, sy, drawIndex)
	self.parent = parent
	self.tileX = x
	self.tileY = y
	self.tileType = type
	
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local offx = 0
		local offy = 0
		offx = -(_ED.mine_tile_width/2) * x
		offy = (_ED.mine_tile_height/2) * (x % 2)
		-- print(offy)
		-- if zstring.tonumber(self.tileType) == 1 then
		-- 	print(x, y, tonumber(y) * 160 - 160)
		-- end
		local pos = cc.p(sx + x * _ED.mine_tile_width + offx, sy - y * _ED.mine_tile_height - _ED.mine_tile_height + offy)
		self:setPosition(pos)

		self:updateBgSprite(self._tile, pos)
	else
		self:setPosition(cc.p(sx + x * _ED.mine_tile_width, sy - y * _ED.mine_tile_height - _ED.mine_tile_height))
	end
	return self
end

function AdventureMineTileCell:init(parent, x, y, type, sx, sy, drawIndex)
	self.parent = parent
	self.tileX = x
	self.tileY = y
	self.tileType = type
	
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local offx = 0
		local offy = 0
		offx = -(_ED.mine_tile_width/2) * x
		offy = (_ED.mine_tile_height/2) * (x % 2)
		-- print(offy)
		-- if zstring.tonumber(self.tileType) == 1 then
		-- 	print(x, y, tonumber(y) * 160 - 160)
		-- end
		self:setPosition(cc.p(sx + x * _ED.mine_tile_width + offx, sy - y * _ED.mine_tile_height - _ED.mine_tile_height + offy))
		self:onInit()
	else
		self:setPosition(cc.p(sx + x * _ED.mine_tile_width, sy - y * _ED.mine_tile_height - _ED.mine_tile_height))

		if drawIndex ~= nil and drawIndex < 200 then
			self:onInit()
		end
	end

	self:setContentSize(AdventureMineTileCell.__size)
	return self
end

function AdventureMineTileCell:removeObjects()
	if nil ~= self._bg_sprite then
		-- self._bg_sprite:removeFromParent(true)
		if self._bg_sprite._idx == 0 then
			table.insert(AdventureMineTileCell._bg_sprite_t0, self._bg_sprite)
		elseif self._bg_sprite._idx == 1 then
			table.insert(AdventureMineTileCell._bg_sprite_t1, self._bg_sprite)
		else
			table.insert(AdventureMineTileCell._bg_sprite_t2, self._bg_sprite)
		end
		self._bg_sprite = nil
	end
	if nil ~= self.__shelter_sprite then
		self.__shelter_sprite:removeFromParent(true)
		table.insert(AdventureMineTileCell._shelter_armature, self.__shelter_sprite)
		self.__shelter_sprite._parent = nil
		self.__shelter_sprite = nil
	end

	if nil ~= self.__blink_sprite then
		self.__blink_sprite:removeFromParent(true)
		if self.info._type == 0 then
			if zstring.tonumber(self.__blink_sprite._pic) > 0 then
				table.insert(AdventureMineTileCell._mine_armatures[self.__blink_sprite._pic], self.__blink_sprite)
			else
				table.insert(AdventureMineTileCell._city_armature, self.__blink_sprite)
			end
		end
		self.__blink_sprite._parent = nil
		self.__blink_sprite = nil
	end
	
	if nil ~= self.__haunt_sprite then
		self.__haunt_sprite:removeFromParent(true)
		AdventureMineTileCell._rebel_haunt_armature[self.__haunt_sprite._pic] = AdventureMineTileCell._rebel_haunt_armature[self.__haunt_sprite._pic] or {}
		table.insert(AdventureMineTileCell._rebel_haunt_armature[self.__haunt_sprite._pic], self.__haunt_sprite)
		self.__haunt_sprite._parent = nil
		self.__haunt_sprite = nil
	end

	if nil ~= self.__world_city_sprite then
		self.__world_city_sprite:removeFromParent(true)
		AdventureMineTileCell._world_city_armature = AdventureMineTileCell._world_city_armature or {}
		table.insert(AdventureMineTileCell._world_city_armature, self.__world_city_sprite)
		self.__world_city_sprite._parent = nil
		self.__world_city_sprite = nil
	end

	if nil ~= self.__enemyBoss_sprite then
		self.__enemyBoss_sprite:removeFromParent(true)
		AdventureMineTileCell._boss_armature = AdventureMineTileCell._boss_armature or {}
		table.insert(AdventureMineTileCell._boss_armature, self.__enemyBoss_sprite)
		self.__enemyBoss_sprite._parent = nil
		self.__enemyBoss_sprite = nil
	end

	if nil ~= self.__mine_name then
		local ttfConfig = {}
        ttfConfig.fontFilePath = config_res.font.font_name
        ttfConfig.fontSize = 16
        self.__mine_name:setTTFConfig(ttfConfig)
		self.__mine_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		self.__mine_name:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_name, self.__mine_name)
		self.__mine_name = nil
	end

	if nil ~= self.__city_progress_name then
		self.__city_progress_name:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_name, self.__city_progress_name)
		self.__city_progress_name = nil
	end

	if nil ~= self.__city_union_name then
		self.__city_union_name:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_name, self.__city_union_name)
		self.__city_union_name = nil
	end

	if nil ~= self.__union_name then
		self.__union_name:removeFromParent(true)
		table.insert(AdventureMineTileCell._union_name, self.__union_name)
		self.__union_name = nil
	end
	if nil ~= self.__union_name_bg then
		self.__union_name_bg:setContentSize(cc.size(self.__union_name_bg._m_width,self.__union_name_bg:getContentSize().height))
		self.__union_name_bg:removeFromParent(true)
		table.insert(AdventureMineTileCell._union_name_bg, self.__union_name_bg)
		self.__union_name_bg = nil
	end

	if nil ~= self.__mine_name_bg then
		self.__mine_name_bg:setContentSize(cc.size(self.__mine_name_bg._m_width,self.__mine_name_bg:getContentSize().height))
		self.__mine_name_bg:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_name_bg, self.__mine_name_bg)
		self.__mine_name_bg = nil
	end

	if nil ~= self.__mine_level then
		self.__mine_level:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_level, self.__mine_level)
		self.__mine_level = nil
	end

	if nil ~= self.__mine_icon then
		self.__mine_icon:setScaleX(1)
		self.__mine_icon:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_icon[self.__mine_icon.mine_type], self.__mine_icon)
		self.__mine_icon = nil
	end

	if nil ~= self.__city_union_name_bg then
		self.__city_union_name_bg:setContentSize(cc.size(self.__city_union_name_bg._m_width,self.__city_union_name_bg:getContentSize().height))
		self.__city_union_name_bg:removeFromParent(true)
		table.insert(AdventureMineTileCell._city_name_bg, self.__city_union_name_bg)
		self.__city_union_name_bg = nil
	end

	if nil ~= self.__factory_level_icon then
		self.__factory_level_icon:removeFromParent(true)
		table.insert(AdventureMineTileCell._city_factory_level_icon[self.__factory_level_icon.factory_level], self.__factory_level_icon)
		self.__factory_level_icon = nil
	end

	if nil ~= self.__mine_level_bg then
		self.__mine_level_bg:setContentSize(cc.size(self.__mine_level_bg._m_width,self.__mine_level_bg:getContentSize().height))
		self.__mine_level_bg:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_level_bg, self.__mine_level_bg)
		self.__mine_level_bg = nil
	end

	if nil ~= self.__mine_legion_icon then
		self.__mine_legion_icon:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_legion_icon, self.__mine_legion_icon)
		self.__mine_legion_icon = nil
	end

	if nil ~= self.__mine_glories_bg then
		self.__mine_glories_bg:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_glories_bg, self.__mine_glories_bg)
		self.__mine_glories_bg = nil
	end
	if nil ~= self.__mine_pragress then
		self.__mine_pragress:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_pragress, self.__mine_pragress)
		self.__mine_pragress = nil
	end

	if nil ~= self.__mine_occupied then
		self.__mine_occupied:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_occupied, self.__mine_occupied)
		self.__mine_occupied = nil
	end	

	if nil ~= self.__rebel_hp then
		self.__rebel_hp:removeFromParent(true)
		table.insert(AdventureMineTileCell._rebel_hp, self.__rebel_hp)
		self.__rebel_hp = nil
	end
	
	if nil ~= self.__rebel_hp_bg then
		self.__rebel_hp_bg:removeFromParent(true)
		table.insert(AdventureMineTileCell._rebel_hp_bg, self.__rebel_hp_bg)
		self.__rebel_hp_bg = nil
	end
	
	if nil ~= self.__city_defender_name then
		self.__city_defender_name:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_name, self.__city_defender_name)
		self.__city_defender_name = nil
	end

	if nil ~= self.__city_defender_icon then
		self.__city_defender_icon:removeFromParent(true)
		table.insert(AdventureMineTileCell._city_defender_icon, self.__city_defender_icon)
		self.__city_defender_icon = nil
	end

	if nil ~= self.__mine_quality then
		self.__mine_quality:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_quality[zstring.tonumber(self.__mine_quality.pic)], self.__mine_quality)
		self.__mine_quality = nil
	end

	if nil ~= self.__mine_quality_level_bg then
		self.__mine_quality_level_bg:setContentSize(cc.size(self.__mine_quality_level_bg._m_width, self.__mine_quality_level_bg:getContentSize().height))
		self.__mine_quality_level_bg:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_quality_level_bg[zstring.tonumber(self.__mine_quality_level_bg.pic)], self.__mine_quality_level_bg)
		self.__mine_quality_level_bg = nil
	end

	if nil ~= self.__mine_quality_bg then
		self.__mine_quality_bg:setContentSize(cc.size(self.__mine_quality_bg._m_width, self.__mine_quality_bg:getContentSize().height))
		self.__mine_quality_bg:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_quality_bg, self.__mine_quality_bg)
		self.__mine_quality_bg = nil
	end

	if nil ~= self.__mine_my_capture then
		self.__mine_my_capture:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_my_capture, self.__mine_my_capture)
		self.__mine_my_capture = nil
	end

	if nil ~= self.__mine_un_capture then
		self.__mine_un_capture:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_un_capture, self.__mine_un_capture)
		self.__mine_un_capture = nil
	end

	if nil ~= self.__mine_sprite then
		self.__mine_sprite:removeFromParent(true)
		table.insert(AdventureMineTileCell._mine_armatures[self.__mine_sprite._pic], self.__mine_sprite)
		self.__mine_sprite._parent = nil
		self.__mine_sprite = nil
	end

	if nil ~= self.__tile_sprite then
		self.__tile_sprite:removeFromParent(true)
		table.insert(AdventureMineTileCell._tile_sprites[self.__tile_sprite._pic], self.__tile_sprite)
		self.__tile_sprite._parent = nil
		self.__tile_sprite = nil
	end
	if self._bg_sprite_normal ~= nil then
		self._bg_sprite_normal:removeFromParent(true)
		table.insert(AdventureMineTileCell._world_sea_animation, self._bg_sprite_normal)
		self._bg_sprite_normal = nil
	end
	if self._bg_edge_sprite ~= nil then
		self._bg_edge_sprite:removeFromParent(true)
		table.insert(AdventureMineTileCell._world_edge_animation, self._bg_edge_sprite)
		self._bg_edge_sprite = nil
	end
	if self._layer_edge_sprite_1 ~= nil then
		self._layer_edge_sprite_1:removeFromParent(true)
		table.insert(AdventureMineTileCell._world_edge_layer_animation, self._layer_edge_sprite_1)
		self._layer_edge_sprite_1 = nil
	end
	if self._layer_edge_sprite_2 ~= nil then
		self._layer_edge_sprite_2:removeFromParent(true)
		table.insert(AdventureMineTileCell._world_edge_layer_animation, self._layer_edge_sprite_2)
		self._layer_edge_sprite_2 = nil
	end
end

function AdventureMineTileCell:reload()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return
	end
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	if self._exploit ~= nil then
        self._exploit:removeFromParent(true)
        self._exploit = nil
    end
    self.info = nil
	-- self:onInit()
	self:updateDraw()
end

function AdventureMineTileCell:unload()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self:removeObjects()
		if nil ~= self.info then
			self.info._need_update = true
		end
		self.info = nil
		self.tileType = -1
		self.olf_info_type = nil
		return
	end
	local root = self.roots[1]
	if root == nil then
		return
	end
	self.info = nil
	self.tileType = -1
	self._role:removeBackGroundImage()
	self._tile:removeAllChildren(true)
	self._tile:removeBackGroundImage()
	self._tile._sprite = nil
	root:stopAllActions()

	-- self:unregisterOnNoteUpdate(self)
	-- -- print("----删除......")
	-- -- state_machine.excute("adventure_mine_boss_bubble_draw",0 ,{node = self,isOpen = false})
	-- if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
	-- 	cacher.freeRef(config_csb.world_map.mine_item_cell, root)
	-- else
	-- 	cacher.freeRef("campaign/Mining/wakuang_item.csb", root)
	-- end
	
	-- -- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- -- ListViewDraw:removeAllItems()
	-- root:stopAllActions()
	-- root:removeFromParent(false)
	-- self.roots = {}

	-- if nil ~= self._bg_sprite then
	-- 	self._bg_sprite:removeFromParent(true)
	-- 	self._bg_sprite = nil
	-- end
end


function AdventureMineTileCell:createCell()
	local cell = AdventureMineTileCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

