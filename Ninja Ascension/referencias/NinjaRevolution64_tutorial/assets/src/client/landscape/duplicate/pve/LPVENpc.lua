-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
LPVENpc = class("LPVENpcClass", Window)

function LPVENpc:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions={}
	self.currentNpcID = 0		--当前显示的关卡id
	self.currentSceneID = 0		--当前场景Id
	self.cacheAction = nil		--缓存面板动画
	

	self.currentSceneType = 0   -- 当前场景的类型
	
	self.maxAttackCount = 0			--总攻击次数
	self.currentAttackTimes = 0		--当前已经攻击次数
	
	self.boss_display_index = -1
	self.boss_flag = false
	self.npcState = 0			--npc攻击状态  0：打过  1：可攻击
	self.reward_pt_index = -1 -- 普通奖励下标
	
	--体力
	self.cacheStrengthText = nil
	
	--经验获得 Text_exp
	self.cacheExpText = nil
	
	--银币获得 Text_money
	self.cacheMoneyText = nil
	
	--挑战次数 Text_tzcs_0
	self.cacheFightTimesText = nil
	
	--挑战十次按钮 Button_sd10ci
	self.cacheBattleTenBtn = nil
	self.cacheBattleOenBtn = nil
	--挑战十次按钮 上面的文本
	self.cacheBattleTimesText = nil
	
	-- 挑战的重置
	self.cacheBattleTenResetBtn = nil
	
	--关卡宝箱按钮
	self.cacheTGBoxBtn = nil
	
	--TeasureDorp
	self.cacheTeasureDorpIcons = {}
	self.cacheEmTeasureDorpIcons = {}
	self.cacheEmSanXingDorpIcons = {}

	self.cacheBattlePropText = nil
	
	--设置是否可以点击按钮 主要针对扫荡 和 出战
	self.canClickBtn = false
	
	--更新状态所用的pageview_seat_cell实例
	self.tmpSeatCell = nil
	
	self.isTurn = false
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.battle.BattleStartEffect")
	app.load("client.duplicate.MoppingResults")
	
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.campaign.icon.arena_role_icon_cell")
	app.load("client.l_digital.cells.union.unionFighting.union_fighting_formation_icon")
	
    local function init_lpve_npc_window_terminal()
		--关闭
		local lpve_npc_close_terminal = {
            _name = "lpve_npc_close",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(instance)
            	fwin:close(fwin:find("UserTopInfoAClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local lpve_npc_window_close_terminal = {
            _name = "lpve_npc_window_close",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
					state_machine.excute("lpve_npc_close", 0, "lpve_npc_close")
				else
					local obj = fwin:find("LPVENpcClass")
					if obj ~= nil then
						local action = obj.actions[1]
						if action ~= nil and action:IsAnimationInfoExists("window_close") == true then
							-- obj.actions[1]:play("window_close", false)
							state_machine.excute("lpve_npc_close", 0, "lpve_npc_close")
						end
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 扫荡完成后更新界面信息
        local lpve_stage_bottom_sweep_over_update_draw_terminal = {
            _name = "lpve_stage_bottom_sweep_over_update_draw",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, instance.onUpdateDraw, instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 扫荡
		local lclick_battle_ten_terminal = {
            _name = "lclick_battle_ten",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local isThreeTimes = false
            	local isFiftyTimes = false 
            	if tonumber(params.times) == 3 then
            		isThreeTimes = true 
            	elseif tonumber(params.times) == 50 then
            		isFiftyTimes = true
            	end
				if TipDlg.drawStorageTipo() == false then
					local myLv = tonumber(_ED.user_info.user_grade)
					local myVip = tonumber(_ED.vip_grade)
					local funOpenId = 38
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						funOpenId = 111
						if isThreeTimes == true then
							funOpenId = 113
						elseif isFiftyTimes == true then
							funOpenId = 112
						end
					end
 					local needLv = dms.int(dms["fun_open_condition"], funOpenId, fun_open_condition.level)
					local needVip = dms.int(dms["fun_open_condition"], funOpenId, fun_open_condition.vip_level)

					if isFiftyTimes == true then
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
					local star = 0
					if zstring.tonumber(_ED.npc_state[tonumber(""..instance.currentNpcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..instance.currentNpcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..instance.currentNpcID)]) ~= 0 then
						star = tonumber(_ED.npc_max_state[tonumber(""..instance.currentNpcID)])
					else
						star = tonumber(_ED.npc_state[tonumber(""..instance.currentNpcID)])
					end
					
					if star < 3 then
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
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

					local currentNpcID = instance.currentNpcID							-- NPCID
					local DifficultyID = 1												-- 攻击下标
					local surplusTimes = 1--self.maxAttackCount - self.currentAttackTimes	-- 扫荡次数
					local elseContent  = "0"											-- 扫荡类型
					
					local totalAttackTimes = dms.int(dms["npc"], instance.currentNpcID, npc.daily_attack_count)
					local addTimes = 0
				    if instance.currentSceneType == 1 then
				        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
				            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
				        end
				    end
				    totalAttackTimes = totalAttackTimes + addTimes
					local surplusAttackCount = _ED.npc_current_attack_count[tonumber(instance.currentNpcID)]
					local finalBattleTimes = totalAttackTimes - surplusAttackCount
					local times = 10
					if isThreeTimes == true then
						times = 3
					elseif isFiftyTimes == true then
						times = 50
					end
					if (finalBattleTimes > times) then finalBattleTimes = times end
					surplusTimes = finalBattleTimes
					
					if tonumber(surplusTimes) <= 0 then
						-- TipDlg.drawTextDailog(_string_piece_info[113])
						state_machine.excute("lclick_buy_times", 0, "")
						return
					end

					if zstring.tonumber(instance.attack_need_food) * surplusTimes > zstring.tonumber(_ED.user_info.user_food) then
						surplusTimes = math.floor(zstring.tonumber(_ED.user_info.user_food)/zstring.tonumber(instance.attack_need_food))
					end
					
					-- 处理 开战时 体力不足 -----------------
					
					if zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(instance.attack_need_food) then
						app.load("client.cells.prop.prop_buy_prompt")
						
						local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
						local mid = zstring.tonumber(config[15])
						--print("abc",mid)
						local win = PropBuyPrompt:new()
						win:init(mid)
						fwin:open(win, fwin._ui)
						return
					end
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"lpve_stage_bottom_sweep_over_update_draw", instance},times,instance.currentSceneID,instance.currentSceneType), fwin._ui)
					else
						fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"lpve_stage_bottom_sweep_over_update_draw", instance}), fwin._ui)
					end
					
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 扫荡重置
		local lclick_battle_ten_reset_terminal = {
            _name = "lclick_battle_ten_reset",
            _init = function (terminal) 
            	app.load("client.duplicate.pve.PVEResetNPCAttackCount")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				if getPVENPCResidualCount(instance.currentNpcID) > 0 then
					local view = PVEResetNPCAttackCount:new():init(1, instance.currentNpcID, 0, 0, {"lclick_battle_ten_reset_update_draw", instance})
					fwin:open(view, fwin._windows)
				else
					TipDlg.drawTextDailog(_string_piece_info[252])
				end
					
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置完成，更新界面
        local lclick_battle_ten_reset_update_draw_terminal = {
            _name = "lclick_battle_ten_reset_update_draw",
            _init = function (terminal) 
            	
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, instance.onUpdateDraw, instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 扫荡
		local lclick_battle_sweep_terminal = {
            _name = "lclick_battle_sweep",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if TipDlg.drawStorageTipo() == false then
					local star = 0
					if zstring.tonumber(_ED.npc_state[tonumber(""..instance.currentNpcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..instance.currentNpcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..instance.currentNpcID)]) ~= 0 then
						star = tonumber(_ED.npc_max_state[tonumber(""..instance.currentNpcID)])
					else
						star = tonumber(_ED.npc_state[tonumber(""..instance.currentNpcID)])
					end
					
					if star < 3 then
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
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

					local currentNpcID = instance.currentNpcID							-- NPCID
					local DifficultyID = 1												-- 攻击下标
					local surplusTimes = 1--self.maxAttackCount - self.currentAttackTimes	-- 扫荡次数
					local elseContent  = "0"											-- 扫荡类型
					
					local totalAttackTimes = dms.int(dms["npc"], instance.currentNpcID, npc.daily_attack_count)
					local addTimes = 0
				    if instance.currentSceneType == 1 then
				        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
				            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
				        end
				    end
				    totalAttackTimes = totalAttackTimes + addTimes
					local surplusAttackCount = _ED.npc_current_attack_count[tonumber(instance.currentNpcID)]
					local finalBattleTimes = totalAttackTimes - surplusAttackCount
					if (finalBattleTimes > 1) then finalBattleTimes = 1 end
					surplusTimes = finalBattleTimes
					
					if tonumber(surplusTimes) <= 0 then
						-- TipDlg.drawTextDailog(_string_piece_info[113])
						state_machine.excute("lclick_buy_times", 0, "")
						return
					end
					
					-- 处理 开战时 体力不足 -----------------
					
					if zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(instance.attack_need_food) then
						app.load("client.cells.prop.prop_buy_prompt")
						
						local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
						local mid = zstring.tonumber(config[15])
						--print("abc",mid)
						local win = PropBuyPrompt:new()
						win:init(mid)
						fwin:open(win, fwin._ui)
						return
					end
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"lpve_stage_bottom_sweep_over_update_draw", instance},1,instance.currentSceneID,instance.currentSceneType), fwin._ui)
					else
						fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"lpve_stage_bottom_sweep_over_update_draw", instance}), fwin._ui)
					end
					
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 出战
		local lclick_go_fight_terminal = {
            _name = "lclick_go_fight",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("lclick_go_fight")
				if TipDlg.drawStorageTipo() == false then
					if instance.canClickBtn == false then return end

					local totalAttackTimes = dms.int(dms["npc"], instance.currentNpcID, npc.daily_attack_count)
					local addTimes = 0
				    if instance.currentSceneType == 1 then
				        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
				            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
				        end
				    end
				    totalAttackTimes = totalAttackTimes + addTimes
					local surplusAttackCount = _ED.npc_current_attack_count[tonumber(instance.currentNpcID)]
					local finalBattleTimes = totalAttackTimes - surplusAttackCount
					if (finalBattleTimes > 1) then finalBattleTimes = 1 end

					if tonumber(finalBattleTimes) <= 0 then
						-- TipDlg.drawTextDailog(_string_piece_info[113])
						state_machine.excute("lclick_buy_times", 0, "")
						state_machine.unlock("lclick_go_fight")
						return
					end
					
					-- 处理 开战时 体力不足 -----------------
					
					if zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(instance.attack_need_food) then
						app.load("client.cells.prop.prop_buy_prompt")
						
						local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
						local mid = zstring.tonumber(config[15])
						
						local win = PropBuyPrompt:new()
						win:init(mid)
						fwin:open(win, fwin._ui)
						state_machine.unlock("lclick_go_fight")
						return
					end
					
					-- 战斗请求
					local function responseBattleInitCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							--state_machine.excute("page_stage_fight_data_deal", 0, 0)
						
							cacher.removeAllTextures()
							
							fwin:cleanView(fwin._windows)
							cc.Director:getInstance():purgeCachedData()
							
							-- 记录上次战斗是否选择的最后的NPC
							LDuplicateWindow._infoDatas._isLastNpc = instance.npcState == 1 and true or false
							LDuplicateWindow._infoDatas._isNewNPCAction = false
							--debug.print_r(_ED.battleData,'_ED.battleData')
							--debug.print_r(_ED.attackData,'_ED.attackData')
							local bse = BattleStartEffect:new()
							bse:init(instance.currentSceneType)
							fwin:open(bse, fwin._windows)
							state_machine.unlock("lclick_go_fight")
						end
					end
					
					local function launchBattle()
						if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
							app.load("client.battle.report.BattleReport")
							local fightModule = FightModule:new()
							fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0)
							fightModule:doFight()
							
							responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
							
							-- 发送结果验证消息
							local starRank = 3						-- 星级 （临时）
							local strVarify = "verify string"		-- 校验码 （临时）
							local  resultVerifyParam = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n"
							resultVerifyParam = resultVerifyParam..starRank.."\r\n"..strVarify.."\r\n".."0"
							protocol_command.battle_result_verify.param_list = resultVerifyParam
							NetworkManager:register(protocol_command.battle_result_verify.code, nil, nil, nil, nil, nil, false, nil)
						else
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								app.load("client.battle.fight.FightEnum")
								local fightType = state_machine.excute("fight_get_current_fight_type", 0, nil)
								if fightType ~= _enum_fight_type._fight_type_10 and
                                    fightType ~= _enum_fight_type._fight_type_11 and 
                                    fightType ~= _enum_fight_type._fight_type_14 and 
                                    fightType ~= _enum_fight_type._fight_type_102 then

                                    -- FURY: el callback arranca el combate que se MANDO. Releer _ED al volver daba npc ""
                                    -- si algo lo vaciaba entretanto (ClassInit.lua:160 desde LPVENpc.lua:503).
                                    local enviadoEscena, enviadoNpc, enviadoDificultad = _ED._current_scene_id, _ED._scene_npc_id, _ED._npc_difficulty_index
                                    local function responseBattleStartCallback( response )
                                    	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                                    	app.load("client.battle.report.BattleReport")
											
											local resultBuffer = {}
											if _ED._fightModule == nil then
												_ED._fightModule = FightModule:new()
											end
											_ED.attackData = {
												roundCount = _ED._fightModule.totalRound,
												roundData ={}
											}
											_ED._current_scene_id, _ED._scene_npc_id, _ED._npc_difficulty_index = enviadoEscena, enviadoNpc, enviadoDificultad
											if _ED._scene_npc_id == nil or _ED._scene_npc_id == "" or tonumber(_ED._scene_npc_id) == 0 then
												_ED._scene_npc_id = _ED._scene_npc_copy_net_id
											end
											local fightType = 0
											if instance.currentSceneType ~= nil then
												fightType = instance.currentSceneType
											end
											if fightType == 1 then
												fightType = _enum_fight_type._fight_type_108
											end
											
											LDuplicateWindow._infoDatas._chapter = _ED._current_scene_id
											_ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
											local orderList = {}
											_ED._fightModule:initFightOrder(_ED.user_info, orderList)
											
											-- local protocalData = {}
											-- protocalData.resouce = table.concat(resultBuffer, "")
											-- NetworkProtocol.parser_func(protocalData)

											-- local result = {}
											-- _ED._fightModule:fight(_ED.user_info, result)
											-- protocalData = {}
											-- protocalData.resouce = table.concat(result, "")
											-- --print("protocalData.resouce",protocalData.resouce)
											-- local lists = lua_string_split_line(protocalData.resouce, "\r\n")
											-- local list = lua_string_splits(lists, " ")
											-- list.pos = 1
											-- parse_environment_fight(nil,nil,0,nil,list,0)
											if _ED.fileIsland then
												_ED.fileIsland.fileIslandFriendCellInfo_goBattle = self.isFileIsland or false
											end
											responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
										else
											state_machine.unlock("lclick_go_fight")
											_ED._current_scene_id = ""
											_ED._scene_npc_id = ""
											_ED._npc_difficulty_index = ""												
										end
                                    end
                                    local formationInfo = ""
                                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                    	_ED.battle_formetion_exp = {}
                                    	local user_infos = instance.currentSceneType == 15 and _ED.em_user_ship or _ED.user_formetion_status
                                    	for i, v in pairs(user_infos) do
    										if zstring.tonumber(v) > 0 then
    											table.insert(_ED.battle_formetion_exp, _ED.user_ship[""..v].exprience)
    										else
    											table.insert(_ED.battle_formetion_exp, 0)
    										end
    										local ship = _ED.user_ship[""..v]
    										if ship ~= nil then
    											if formationInfo == "" then
    												formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
    											else
    												formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
    											end
    										else
    											if formationInfo == "" then
    												formationInfo = "0,0,0,0"
    											else
    												formationInfo = formationInfo.."|".."0,0,0,0"
    											end
    										end
    									end
                                    end
                                    protocol_command.battle_result_start.param_list = "".._enum_fight_type._fight_type_0.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n0\r\n"..formationInfo
                                    NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
								else
									_ED._scene_npc_copy_net_id = _ED._scene_npc_id
									local battleFieldInitParam = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
									protocol_command.battle_field_init.param_list = battleFieldInitParam
									NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
								end
							else
								_ED._scene_npc_copy_net_id = _ED._scene_npc_id
								local  battleFieldInitParam = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
								protocol_command.battle_field_init.param_list = battleFieldInitParam
								NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
							end
						end
					end
					
					local function responseCampPreferenceCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							
							if _ED.camp_preference_info ~= nil and _ED.camp_preference_info.count > 0 then
								app.load("client.formation.FormationChangeMakeWar") 
								
								local makeWar = FormationChangeMakeWar:new()
								
								makeWar:init(launchBattle)
								
								fwin:open(makeWar, fwin._ui)
							else
								launchBattle()
							end
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						for i,v in pairs(_ED.scene_max_state) do
							if tonumber(v) == -1 then
								_ED._now_scene_count = i
								break
							end
						end
						for i,v in pairs(_ED.scene_max_state) do
							if i > 50 and tonumber(v) == -1 then
								_ED._now_hard_scene_count = i
								break
							end
						end
						-- print("===============",_ED._now_scene_count)
						instance.currentNpcID = zstring.tonumber(instance.currentNpcID)
						_ED.npc_last_state[instance.currentNpcID] = "".._ED.npc_state[instance.currentNpcID]

						_ED._current_scene_id = instance.currentSceneID
						_ED._scene_npc_id = instance.currentNpcID
						_ED._npc_difficulty_index = "1"
						launchBattle()
					else
					-- 启动出战事件
						instance.currentNpcID = zstring.tonumber(instance.currentNpcID)
						local sceneParam = "nc".._ED.npc_state[instance.currentNpcID]
						if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..instance.currentNpcID, nil, true, sceneParam, false) == false then
							_ED.npc_last_state[instance.currentNpcID] = "".._ED.npc_state[instance.currentNpcID]

							_ED._current_scene_id = instance.currentSceneID
							_ED._scene_npc_id = instance.currentNpcID
							_ED._npc_difficulty_index = "1"

							if __lua_project_id == __lua_project_warship_girl_a 
							or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
							or __lua_project_id == __lua_project_koone
							then
								-- -- 引入相克系统战斗前请求

								if missionIsOver() == false then
									launchBattle()
								else
									protocol_command.camp_preference.param_list = "".._ED._scene_npc_id.."\r\n".."0"
									NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, nil, responseCampPreferenceCallback, false, nil)
								end
							else
								launchBattle()
							end
						end
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 打开布阵
		local lclick_open_formation_terminal = {
            _name = "lclick_open_formation",
            _init = function (terminal)
				app.load("client.formation.FormationChange") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local formationChangeWindow = FormationChange:new()
				fwin:open(formationChangeWindow, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local lclick_buy_times_terminal = {
            _name = "lclick_buy_times",
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
	                            response.node:onUpdateDraw()
	                        end
                        end
                    end
	                protocol_command.basic_consumption.param_list = "22".."\r\n"..instance.currentNpcID
	                NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, instance, responseCallback, false, nil)
                end

                local buy_times = tonumber(_ED.npc_current_buy_count[tonumber(instance.currentNpcID)]) + 1
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
                tip:init(instance, sureFunc, string.format(_new_interface_text[210], tonumber(cost), tonumber(buy_times - 1)))
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取奖励
		local pve_npc_reward_box_get_terminal = {
            _name = "pve_npc_reward_box_get",
            _init = function (terminal)
				app.load("client.cells.prop.prop_icon_cell")
				app.load("client.duplicate.pve.PVERewardPreviewPanel")
				app.load("client.cells.utils.resources_icon_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local sceneId = instance.currentSceneID
				local lq_type = params._datas.lq_type
				local function responseDrawStarRewardCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	                            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	                            then
								app.load("client.reward.DrawRareReward")
								local getRewardWnd = DrawRareReward:new()
								if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								then
									getRewardWnd:init(7,nil,reworld_sorting)
								else
									getRewardWnd:init(7)
								end
								
								fwin:open(getRewardWnd, fwin._ui)
							else
								local boxId = response.node:checkBoxIDForNpcID(response.node.npcId)
								local previewWnd = PVERewardPreviewPanel:new()
								previewWnd:init(boxId)
								fwin:open(previewWnd, fwin._windows)
							end
							response.node:onUpdateDraw()
							if response.node.cell and response.node.cell.onUpdateDraw ~= nil then -- luaerror 9-oct: celda liberada
								response.node.cell:onUpdateDraw()
							end
						end
					end
				end
				--> print("领取奖励的索引", rewardIndex)
				protocol_command.draw_scene_npc_rewad.param_list = ""..sceneId .."\r\n" .. (instance.reward_pt_index - 1).."\r\n"..lq_type
				NetworkManager:register(protocol_command.draw_scene_npc_rewad.code, nil, nil, nil, instance, responseDrawStarRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(lpve_npc_close_terminal)
		state_machine.add(lpve_npc_window_close_terminal)
		state_machine.add(lpve_stage_bottom_sweep_over_update_draw_terminal)
		state_machine.add(lclick_battle_ten_terminal)
		state_machine.add(lclick_battle_ten_reset_terminal)
		state_machine.add(lclick_battle_ten_reset_update_draw_terminal)
		state_machine.add(lclick_battle_sweep_terminal)
		state_machine.add(lclick_go_fight_terminal)
		state_machine.add(lclick_open_formation_terminal)
		state_machine.add(lclick_buy_times_terminal)
		state_machine.add(pve_npc_reward_box_get_terminal)
        state_machine.init()
    end
    
    init_lpve_npc_window_terminal()
end

function LPVENpc:init(_npcID, _sceneID, _bossFlag, _npcState, isTurn, cell, isFileIsland)
	self.currentNpcID = _npcID
	
	self.currentSceneID = _sceneID
	self.currentSceneType = dms.int(dms["pve_scene"], self.currentSceneID, pve_scene.scene_type) 
	
	self.boss_flag = _bossFlag
	self.npcState = _npcState

	self.cell = cell
	self.isFileIsland = isFileIsland

	if self.isTurn == true then
		self:onInit()
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
		if self.currentSceneType == 1 then
			-- 防止因体力不足，引起的精英副本教学卡死
	        -- if missionIsOver() == false then
	        --     clearMission()
	        -- end
	        clearMission()
		end
	end
end

--通用按钮点击事件添加
function LPVENpc:addTouchEventFunc(uiName, eventName, actionMode)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		terminal_state = 0, 
		isPressedActionEnabled = actionMode
	},
	nil, 0)
	return tmpArt
end



function LPVENpc:onUpdateCall(dt)
	if nil ~= self._focus then
		self._interval = self._interval + dt
		if self._interval > 0.5 then
			local datas = self._focus._datas
			local focus = self._focus
			self._focus = nil
			self._interval = 0

			if datas.item_type == 1 
				or datas.item_type == 2
				then
				local cell = propMoneyInfo:new()
				cell:init("" .. datas.item_info, nil, focus)
				fwin:open(cell, fwin._windows)
			elseif datas.item_type == 6 then
				local cell = propInformation:new()
				cell:init(datas.item_info, 1, focus)
				fwin:open(cell, fwin._windows)
			end
		end
	end
end

function LPVENpc:addRewardButtonEvent(but, itemType, info)
	if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
    else
    	return
    end
    
	local function rewardTouchCallback(sender, eventType)
        if eventType == ccui.TouchEventType.began then
        	sender._self._focus = sender
        	sender._self._interval = 0
		elseif eventType == ccui.TouchEventType.moved then
		elseif eventType == ccui.TouchEventType.ended 
			or eventType == ccui.TouchEventType.canceled
			then
			sender._self._focus = nil
			sender._self._interval = 0

			local datas = sender._datas
			if datas.item_type == 1 
				or datas.item_type == 2
				then
				fwin:close(fwin:find("propMoneyInfoClass"))
			elseif datas.item_type == 6 then
				fwin:close(fwin:find("propInformationClass"))
			end
		end
    end
    but:addTouchEventListener(rewardTouchCallback)

    but._self = self
    but._datas = {
		terminal_name = "lpve_npc_reward_box_open_reward_preview_window", 
		terminal_state = 0,
		item_type = itemType,
		item_info = info,
		isPressedActionEnabled = true
	}
end

function LPVENpc:onUpdate(dt)
	if self.cacheFightTimesText ~= nil then
		local totalAttackTimes = dms.int(dms["npc"], self.currentNpcID, npc.daily_attack_count)
	    local addTimes = 0
	    if self.currentSceneType == 1 then
	        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
	            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
	        end
	    end
		local surplusAttackCount = _ED.npc_current_attack_count[tonumber(self.currentNpcID)]
		self.cacheFightTimesText:setString((totalAttackTimes + addTimes - surplusAttackCount) .. "/" .. (totalAttackTimes + addTimes))
		if self.Button_zengjiacishu ~= nil then
			if self.currentSceneType == 1 then
				if totalAttackTimes - surplusAttackCount + addTimes == 0 then
					self.Button_zengjiacishu:setVisible(true)
				else
					self.Button_zengjiacishu:setVisible(false)
				end
			end
		end
	end

	self:onUpdateCall(dt)
end

function LPVENpc:onUpdateDraw()
	local root = self.roots[1]
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
	else
		if self.boss_flag == true then
			ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
		end
	end
	local CurStar = 0
	if zstring.tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.currentNpcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)]) ~= 0 then
		CurStar = tonumber(_ED.npc_max_state[tonumber(""..self.currentNpcID)])
	else
		CurStar = tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)])
	end
	
	if CurStar == 1 then  
		ccui.Helper:seekWidgetByName(root, "Image_star_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_star_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_star_3"):setVisible(false)
	elseif CurStar == 2 then 
		ccui.Helper:seekWidgetByName(root, "Image_star_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_star_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_star_3"):setVisible(false)
	elseif CurStar == 3 then
		ccui.Helper:seekWidgetByName(root, "Image_star_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_star_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_star_3"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Image_star_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_star_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_star_3"):setVisible(false)
	end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(dms.string(dms["npc"], self.currentNpcID, npc.npc_name), "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        ccui.Helper:seekWidgetByName(root, "Text_npc_name"):setString(name_info)
        _ED.current_npc_battle_star = CurStar
    else
        ccui.Helper:seekWidgetByName(root, "Text_npc_name"):setString(dms.string(dms["npc"], self.currentNpcID, npc.npc_name))
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local Text_npc_story = ccui.Helper:seekWidgetByName(root, "Text_npc_story")
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        local word_info = dms.element(dms["word_mould"], zstring.tonumber(dms.string(dms["npc"], zstring.tonumber(self.currentNpcID), npc.sign_msg)))
	        Text_npc_story:setString(word_info[3])
	    else
	    	Text_npc_story:setString(dms.string(dms["npc"], zstring.tonumber(self.currentNpcID), npc.sign_msg))
	    end
		
	else
		-- 描述
		local npc_describe_text = ccui.Helper:seekWidgetByName(root, "Text_2_0")
		npc_describe_text:setString(dms.string(dms["npc"], self.currentNpcID, npc.sign_msg))
	end
	
	-- npc形象
	local npc_show_pad = ccui.Helper:seekWidgetByName(root, "Panel_1")
	
	local formation_count = dms.int(dms["npc"], self.currentNpcID, npc.formation_count)
	local environment_formation_data = dms.int(dms["npc"], self.currentNpcID, npc.environment_formation1 + formation_count - 1)
	
	for i = 0, 5 do
		local environment_ship_data = dms.int(dms["environment_formation"], environment_formation_data, environment_formation.seat_one + i)
		if environment_ship_data > 0 then
			local boss_flag = dms.int(dms["environment_ship"], environment_ship_data, environment_ship.sign_pic)
			if boss_flag == 1 then
				self.boss_display_index = dms.int(dms["environment_ship"], environment_ship_data, environment_ship.bust_index)
				break
			end
		end
	end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
		then
		npc_show_pad:removeAllChildren(true)
		if animationMode == 1 then
			-- app.load("client.battle.fight.FightEnum")
			-- local armature = sp.spine_sprite(npc_show_pad, self.boss_display_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			-- armature:setPosition(cc.p(npc_show_pad:getContentSize().width/2, 0))
		else
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. self.boss_display_index .. ".ExportJson")
			local armature = ccs.Armature:create("spirte_" .. self.boss_display_index)
			armature:getAnimation():playWithIndex(0)
			npc_show_pad:addChild(armature)
			armature:setPosition(cc.p(npc_show_pad:getContentSize().width/2, 0))
		end
	else
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. self.boss_display_index .. ".ExportJson")
		local armature = ccs.Armature:create("spirte_" .. self.boss_display_index)
		armature:getAnimation():playWithIndex(0)
		npc_show_pad:addChild(armature)
		armature:setPosition(cc.p(npc_show_pad:getContentSize().width/2, 0))
	end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local npc_pic = zstring.split(dms.string(dms["npc"], zstring.tonumber(self.currentNpcID), npc.head_pic),",")[2]
	    ccui.Helper:seekWidgetByName(root, "Panel_npc"):removeBackGroundImage()
	    ccui.Helper:seekWidgetByName(root, "Panel_npc"):setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", npc_pic))
	else
		local pIndex = dms.int(dms["npc"], self.currentNpcID, npc.npc_type)

		ccui.Helper:seekWidgetByName(root, "Panel_npc"):setBackGroundImage(string.format("images/ui/pve_sn/pve_tow_bg_%s.png", pIndex))
	end

	ccui.Helper:seekWidgetByName(root, "Panel_npc"):setVisible(true)
	--显示体力
	self.attack_need_food = dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)
	self.cacheStrengthText:setString(self.attack_need_food)
	
	--猪脚等级
	local masterLv = tonumber(_ED.user_info.user_grade)
	
	--经验获得
	if self.cacheExpText ~= nil then
		self.cacheExpText:setString(_string_piece_info[153] .. masterLv * 10 * dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)
	end
	--银币获得
	local money = dms.int(dms["grade_silver_reward"], masterLv, grade_silver_reward.silver)
	if self.cacheMoneyText ~= nil then
		self.cacheMoneyText:setString(_string_piece_info[153] .. money* dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)
	end
	
	-- 绘制挑战次数
	local totalAttackTimes = dms.int(dms["npc"], self.currentNpcID, npc.daily_attack_count)
	local surplusAttackCount = _ED.npc_current_attack_count[tonumber(self.currentNpcID)]
	local addTimes = 0
    if self.currentSceneType == 1 then
        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
        end
    end
	self.cacheFightTimesText:setString((totalAttackTimes + addTimes - surplusAttackCount) .. "/" .. (totalAttackTimes + addTimes))
	self.maxAttackCount = tonumber(totalAttackTimes)
	self.currentAttackTimes = tonumber(surplusAttackCount)
	if self.Button_zengjiacishu ~= nil then
		if self.currentSceneType == 1 then
			if totalAttackTimes - surplusAttackCount + addTimes == 0 then
				self.Button_zengjiacishu:setVisible(true)
			else
				self.Button_zengjiacishu:setVisible(false)
			end
		end
	end
	
	local myLv = tonumber(_ED.user_info.user_grade)
	local myVip = tonumber(_ED.vip_grade)
	local needLv = dms.int(dms["fun_open_condition"], 38, fun_open_condition.level)
	local needVip = dms.int(dms["fun_open_condition"], 38, fun_open_condition.vip_level)
	
	local finalBattleTimes = totalAttackTimes + addTimes - surplusAttackCount
	if self.cacheBattleTenBtn ~= nil then
		self.cacheBattleTenBtn:setVisible(finalBattleTimes > 0)
	end
	self.cacheBattleOenBtn:setVisible(finalBattleTimes > 0)
	if self.cacheBattleTenResetBtn ~= nil then
		self.cacheBattleTenResetBtn:setVisible(finalBattleTimes <= 0)
	end
	
	ccui.Helper:seekWidgetByName(root, "Button_601"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Button_601_1"):setVisible(false)
	
	if (finalBattleTimes > 10) then finalBattleTimes = 10 end
	--更新扫荡上面的文字
	if self.cacheBattleTimesText ~= nil then
		self.cacheBattleTimesText:setString(finalBattleTimes)
	end
	
	--清空icon panel原有的元素
	for i, v in pairs(self.cacheTeasureDorpIcons) do
		v:removeAllChildren(true)
	end

	--清空icon panel原有的元素
	for i, v in pairs(self.cacheEmTeasureDorpIcons) do
		v:removeAllChildren(true)
	end

	--清空icon panel原有的元素
	for i, v in pairs(self.cacheEmSanXingDorpIcons) do
		v:removeAllChildren(true)
	end
	
	--绘制奖励
	local rewardID = dms.int(dms["npc"], self.currentNpcID, npc.drop_library)
	local first_reward = dms.int(dms["npc"], self.currentNpcID, npc.first_reward)

	if tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)]) == 0 then
		if self.cacheBattleTenBtn ~= nil then
			self.cacheBattleTenBtn:setVisible(false)
		end
		self.cacheBattleOenBtn:setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_601"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_601_1"):setVisible(true)
	end

	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then   -- 1评审, 其他非
		self.cacheBattleTenBtn:setVisible(false)
	end

	if rewardID > 0 then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        	function drawRewardIcon( rewardInfoString , panel_icon)
        		local index = 1
		        local rewardTotal = 1
		        local isHaveActivity = false
		        local rewardInfoArr = zstring.split(rewardInfoString, "|")
		        if self.currentSceneType == 0 then
			        if _ED.active_activity[97] ~= nil and _ED.active_activity[97] ~= "" then
			            isHaveActivity = true
			        end
			    elseif self.currentSceneType == 1 then
	        		if _ED.active_activity[98] ~= nil and _ED.active_activity[98] ~= "" then
			            isHaveActivity = true
			        end
        		end
        		for i, v in pairs(rewardInfoArr) do
		            local info = zstring.split(v, ",")
		            if info[2] == "6" then
		                local cell = ResourcesIconCell:createCell()
		                local reawrdID = tonumber(info[1])
		                local rewardNum = tonumber(info[3])
		                cell:init(6, rewardNum, reawrdID,nil,nil,true,true)
		                -- cell:hideNameAndCount()
		                -- ListView_kill_reward:addChild(cell)
		                panel_icon[rewardTotal]:addChild(cell)

			            if isHaveActivity == true then
			            	if first_reward == 0 or (first_reward ~= 0 and CurStar ~= 0) then
			            		cell:setActivityDouble(true)
			            	end
			            end

		            elseif info[2] == "7" then
		                local reawrdID = tonumber(info[1])
		                local rewardNum = tonumber(info[3])
		                local tmpTable = {
		                    user_equiment_template = reawrdID,
		                    mould_id = reawrdID,
		                    user_equiment_grade = 1
		                }
		                
		                local eic = ResourcesIconCell:createCell()
		                -- eic:init(10, tmpTable, reawrdID, nil, false, rewardNum)
		                eic:init(7, rewardNum, reawrdID,nil,nil,true,true)
		                -- ListView_kill_reward:addChild(reward)
		                panel_icon[rewardTotal]:addChild(eic)
		                
		                if isHaveActivity == true then
			            	if first_reward == 0 or (first_reward ~= 0 and CurStar ~= 0) then
			            		cell:setActivityDouble(true)
			            	end
			            end
		           else
		                local cell = ResourcesIconCell:createCell()
		                cell:init(info[2], tonumber(info[3]), -1,nil,nil,true,true)
		                cell:showName(-1, tonumber(info[2]))
		                panel_icon[rewardTotal]:addChild(cell)
		                
		                if isHaveActivity == true then
			            	if first_reward == 0 or (first_reward ~= 0 and CurStar ~= 0) then
			            		cell:setActivityDouble(true)
			            	end
			            end
		            end
		            rewardTotal = rewardTotal + 1
		        end
        	end

        	

			if self.currentSceneType == 15 then
				local all_reward = dms.string(dms["pve_scene"], self.currentSceneID, pve_scene.design_reward)
				local all_npc = dms.string(dms["pve_scene"], self.currentSceneID, pve_scene.npcs)
				local temp_rewards = zstring.splits(all_reward, "|", ",")
				local temp_npcs = zstring.split(all_npc, ",")
				local rewardInfos = {}
				for i,v in ipairs(temp_npcs) do
					if tonumber(self.currentNpcID) == tonumber(v) then
						self.reward_pt_index = i
					end
				end
				for i=1,2 do
					local reward_id = temp_rewards[i][self.reward_pt_index]
					local rewardInfoString = dms.string(dms["scene_reward_ex"], reward_id, scene_reward_ex.show_reward)
					local panel_icon = i == 1 and self.cacheEmTeasureDorpIcons or self.cacheEmSanXingDorpIcons
					drawRewardIcon(rewardInfoString, panel_icon)
				end
			else
				local rewardInfoString = dms.string(dms["scene_reward_ex"], rewardID, scene_reward_ex.show_reward)
        		drawRewardIcon(rewardInfoString, self.cacheTeasureDorpIcons)
			end
	    else
		-------------------------------------------------------------------
			local rewardTotal = 1
			local rewardMoney = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_silver))
			local rewardGold = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_gold))
			local rewardHonor = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_honor))
			local rewardSoul = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul))
			local rewardJade = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade))
			local rewardItemListStr = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_preview)
			else
				rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_prop)
			end
			local rewardEquListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_equipment)
			local rewardShipListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_ship)
			local rewardMaxJade = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade_max))
			local rewardMaxSoul = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul_max))
			
			-- if rewardMaxJade > 0 and rewardJade > 0 then
				-- self.cacheBattlePropText:setString(rewardJade .. "~" .. rewardMaxJade)
			-- end	
			
			if rewardMoney > 0 then
				local reward = ResourcesIconCell:createCell()
				reward:init(1, rewardMoney, -1)
				self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
				rewardTotal = rewardTotal + 1

				local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
				self:addRewardButtonEvent(Panel_prop, 1, reward.current_type)
			end
			
			if rewardGold > 0 then
				local reward = ResourcesIconCell:createCell()
				reward:init(2, rewardGold, -1)
				self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
				rewardTotal = rewardTotal + 1

				local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
				self:addRewardButtonEvent(Panel_prop, 2, reward.current_type)
			end
			
			if rewardHonor > 0 then
				local reward = ResourcesIconCell:createCell()
				reward:init(3, rewardHonor, -1)
				self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
				rewardTotal = rewardTotal + 1
			end
			
			if rewardSoul > 0 then
				local reward = ResourcesIconCell:createCell()
				reward:init(4, rewardSoul, -1)
				self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
				rewardTotal = rewardTotal + 1
				
				-- ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_3_7_7"):setBackGroundImage(string.format("images/ui/props/props_%d.png", 4007))
				-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_18_18_18"):setString(rewardSoul)
			-- else
				-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_tl_1_0_12_12_12"):setString(" ")
				-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_20_20"):setString(" ")
			end
			
			if rewardJade~=nil and rewardJade > 0 then
				local reward = ResourcesIconCell:createCell()
				reward:init(5, rewardJade, -1)
				self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
				rewardTotal = rewardTotal + 1
			end
			
			--绘制道具
			if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
			------------------------------------------------------------
				local rewardProp = zstring.split(rewardItemListStr, "|")
				if table.getn(rewardProp) > 0 then
					for i,v in pairs(rewardProp) do
						local rewardPropInfo = zstring.split(v, ",")
						if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
							-- app.load("client.cells.prop.prop_icon_cell")
							local reward = nil 
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								reward = ResourcesIconCell:createCell()
								reward:init(6,0,tonumber(rewardPropInfo[2]),nil,nil,nil,true)
							else
								reward = PropIconCell:createCell()
								local reawrdID = tonumber(rewardPropInfo[2])
								local rewardNum = tonumber(rewardPropInfo[1])
								reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum}, nil, false)
							end
							self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
							rewardTotal = rewardTotal + 1
							
							-- if rewardTotal > 4 then
								-- break
							-- end
						end
					end
				end
			--------------------------------------------------------
			end
			
			--绘制装备
			if rewardEquListStr ~= nil and rewardEquListStr ~= 0 and rewardEquListStr ~= "" then
			------------------------------------------------------------
				local rewardProp = zstring.split(rewardEquListStr, "|")
				if table.getn(rewardProp) > 0 then
					for i,v in pairs(rewardProp) do
						local rewardPropInfo = zstring.split(v, ",")
						if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
							-- app.load("client.cells.prop.prop_icon_cell")
							-- local reward = ArenaRoleIconCell:createCell()
							local reawrdID = tonumber(rewardPropInfo[2])
							local rewardNum = tonumber(rewardPropInfo[1])
							
							local tmpTable = {
								user_equiment_template = reawrdID,
								mould_id = reawrdID,
								user_equiment_grade = 1
							}
							
							local eic = EquipIconCell:createCell()
							eic:init(10, tmpTable, reawrdID, nil, false)
							-- self.equipIconPanelArr[i]:addChild(eic)
							self.cacheTeasureDorpIcons[rewardTotal]:addChild(eic)
							rewardTotal = rewardTotal + 1
							
							-- if rewardTotal > 4 then
								-- break
							-- end
						end
					end
				end
			--------------------------------------------------------
			end
			
			--奖励武将 rewardShipListStr
			if rewardShipListStr ~= nil and rewardShipListStr ~= 0 and rewardShipListStr ~= "" then
			------------------------------------------------------------
				local rewardProp = zstring.split(rewardShipListStr, "|")
				if table.getn(rewardProp) > 0 then
					for i,v in pairs(rewardProp) do
						local rewardPropInfo = zstring.split(v, ",")
						if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
							-- app.load("client.cells.prop.prop_icon_cell")
							-- 等级,数量,id,概率
							local reward = ShipHeadCell:createCell()
							local reawrdID = tonumber(rewardPropInfo[3])
							local rewardLv = tonumber(rewardPropInfo[1])
							local rewardNums = tonumber(rewardPropInfo[2])
							reward:init(nil,13, reawrdID,rewardNums)
							self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
							rewardTotal = rewardTotal + 1
							
							-- if rewardTotal > 4 then
								-- break
							-- end
						end
					end
				end
			--------------------------------------------------------
			end
		end
	-------------------------------------------------------------------
	end
	
	self.canClickBtn = true
	
	if self.currentSceneType == 9 then
		-- local controlPad = ccui.Helper:seekWidgetByName(root, "Panel_mjfb")
		-- local fristRewardElement = dms.element(dms["scene_reward"], dms.int(dms["npc"], self.currentNpcID, npc.first_reward))
		-- local gold = dms.atos(fristRewardElement, scene_reward.reward_gold)
		-- -- 首胜奖励
		-- if gold ~= nil then
			-- ccui.Helper:seekWidgetByName(controlPad, "Text_4"):setString("".. gold)
		-- end
		
		-- ccui.Helper:seekWidgetByName(controlPad, "Text_8"):setString(_string_piece_info[153] .. masterLv * 10 * dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)

		-- local rewardList = zstring.split(dms.string(dms["npc"], self.currentNpcID, npc.difficulty_reward), "|")
		-- local rewardInfo = zstring.split(rewardList[1], ",")
		
		-- local money = dms.int(dms["grade_silver_reward"], masterLv, grade_silver_reward.silver)
		-- ccui.Helper:seekWidgetByName(controlPad, "Text_10"):setString(_string_piece_info[153] .. money* dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)

		-- -- 水雷魂
		-- local reward = ResourcesIconCell:createCell()
		-- reward:init(5, 0, -1)
		-- ccui.Helper:seekWidgetByName(controlPad, "Panel_4_3_7"):addChild(reward)
		-- --setBackGroundImage(string.format("images/ui/props/props_%d.png", 4008))

		-- -- 今天剩余的挑战
		-- ccui.Helper:seekWidgetByName(controlPad, "Text_16_0_18"):setString((totalAttackTimes - surplusAttackCount) .. "/" .. totalAttackTimes)
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
		if Text_2 ~= nil and self.currentSceneType == 1 then
			Text_2:setVisible(true)
			self.cacheFightTimesText:setVisible(true)
		end
		local Image_pve_type_1 = ccui.Helper:seekWidgetByName(root, "Image_pve_type_1")
		local Image_pve_type_2 = ccui.Helper:seekWidgetByName(root, "Image_pve_type_2")
		local Image_pve_type_3 = ccui.Helper:seekWidgetByName(root, "Image_pve_type_3")
		Image_pve_type_1:setVisible(false)
		Image_pve_type_2:setVisible(false)
		Image_pve_type_3:setVisible(false)
		if self.cacheBattleThreeBtn ~= nil then
			self.cacheBattleThreeBtn:setVisible(false)
		end
		self.cacheBattleTenBtn:setVisible(false)

		if self.cacheBattleFiftyBtn ~= nil then
			-- self.cacheBattleFiftyBtn:setVisible(false)
		end 
		if self.currentSceneType == 1 then  --精英
			Image_pve_type_2:setVisible(true)
			if self.cacheBattleThreeBtn ~= nil then
				self.cacheBattleThreeBtn:setVisible(true)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
					if self.cacheBattleFiftyBtn ~= nil then
						self.cacheBattleFiftyBtn:setVisible(false)
					end
					if funOpenDrawTip( 113,false) == false then
						self.cacheBattleThreeBtn:setVisible(true)
						if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then   -- 1评审, 其他非
							self.cacheBattleThreeBtn:setVisible(false)
						end

					else
						self.cacheBattleThreeBtn:setVisible(false)
					end
				end
			end
		elseif self.currentSceneType == 0 then
			Image_pve_type_1:setVisible(true)
			self.cacheBattleTenBtn:setVisible(true)
			if self.cacheBattleFiftyBtn ~= nil then
				self:showFiftyBtn()
				if funOpenDrawTip( 112,false) == false then
					if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then   -- 1评审, 其他非
						self.cacheBattleFiftyBtn:setVisible(false)
					end
				end
			end
		elseif self.currentSceneType == 15 then
			Image_pve_type_3:setVisible(false):setVisible(true)
			if self.cacheBattleFiftyBtn ~= nil then
				self.cacheBattleFiftyBtn:setVisible(false)
			end
		end
		self.cacheBattleOenBtn:setVisible(true)

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
			then
			if self.currentSceneType == 0 and  funOpenDrawTip( 111,false) == false then
				self.cacheBattleTenBtn:setVisible(true)
			else
				self.cacheBattleTenBtn:setVisible(false)
			end
		end

		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then   -- 1评审, 其他非
			self.cacheBattleTenBtn:setVisible(false)
		end

		--噩梦副本按钮显示
		if self.currentSceneType == 15 then
			local Button_em_pt_rec = ccui.Helper:seekWidgetByName(root, "Button_em_pt_rec")
			local Button_em_sx_rec = ccui.Helper:seekWidgetByName(root, "Button_em_sx_rec")
			local Image_pt_rec = ccui.Helper:seekWidgetByName(root, "Image_pt_rec")
			local Image_sx_rec = ccui.Helper:seekWidgetByName(root, "Image_sx_rec")

			--判断通关按钮状态
			local drawState = _ED.scene_draw_chest_npcs[tostring(self.currentNpcID)]
			if drawState == 1 then--已经领取
				Button_em_pt_rec:setVisible(false)
				Image_pt_rec:setVisible(true)
			else--没有领取
				Image_pt_rec:setVisible(false)
				if self.npcState  ~= nil and tonumber(self.npcState) ~= 1 and tonumber(self.npcState) ~= 2 then
					Button_em_pt_rec:setVisible(true)
					Button_em_pt_rec:setBright(true)
					Button_em_pt_rec:setTouchEnabled(true)
				else
					Button_em_pt_rec:setVisible(true)
					Button_em_pt_rec:setBright(false)
					Button_em_pt_rec:setTouchEnabled(false)
				end
			end

			--判断三星通关按钮状态
			local drawStateEm = _ED.scene_draw_sx_chest_npcs[tostring(self.currentNpcID)]
			if drawStateEm == 1 then--已经领取
				Button_em_sx_rec:setVisible(false)
				Image_sx_rec:setVisible(true)
			else--没有领取
				Image_sx_rec:setVisible(false)
				if CurStar >= 3 then
					Button_em_sx_rec:setVisible(true)
					Button_em_sx_rec:setBright(true)
					Button_em_sx_rec:setTouchEnabled(true)
				else
					Button_em_sx_rec:setVisible(true)
					Button_em_sx_rec:setBright(false)
					Button_em_sx_rec:setTouchEnabled(false)
				end
			end

		--屏蔽扫荡按钮
			--挑战3次按钮
			if self.cacheBattleThreeBtn ~= nil then
				self.cacheBattleThreeBtn:setVisible(false)
			end
			--扫荡50次按钮
			if self.cacheBattleFiftyBtn ~= nil then
				-- self.cacheBattleFiftyBtn:setVisible(false)
			end
			--挑战十次按钮
			self.cacheBattleTenBtn:setVisible(false)
			self.cacheBattleOenBtn:setVisible(false)
		end

		--噩梦副本场景开启条件
		function checkNpcData( sceneId , currentSceneType)
			if currentSceneType ~= 15 then return true end
			local need_grade = dms.int(dms["pve_scene"], sceneId, pve_scene.open_level)
			if zstring.tonumber(_ED.user_info.user_grade) < need_grade then
				return false
			end

			--获取当前打开的senceID
			local sceneid = 0
			_scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 15)
			for i, v in pairs(_scenes) do
				local tempSceneId = dms.atoi(v, pve_scene.id)
				if _ED.scene_current_state[tempSceneId] == nil
					or _ED.scene_current_state[tempSceneId] == ""
					or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
					then
					sceneid = tempSceneId - 1
					break
				end
			end

			local needOpenScene = zstring.split(dms.string(dms["pve_scene"], sceneid, pve_scene.by_open_scene), ",")
			for k,v in pairs(needOpenScene) do
				local npcCount = #(zstring.split(dms.string(dms["pve_scene"], v, pve_scene.npcs), ","))
				if zstring.tonumber(_ED.scene_current_state[tonumber(v)]) < npcCount then
					-- TipDlg.drawTextDailog(string.format(_new_interface_text[296],dms.string(dms["pve_scene"], tonumber(v), pve_scene.scene_name)))
					return false
				end
			end
			return true
		end

		--精英副本未开启显示
		local Panel_open = ccui.Helper:seekWidgetByName(root, "Panel_open")
		local Panel_no_open = ccui.Helper:seekWidgetByName(root, "Panel_no_open")
		Panel_open:setVisible(false)
		Panel_no_open:setVisible(false)
		if self.npcState == nil or (not checkNpcData(self.currentSceneID, self.currentSceneType)) then
			Panel_no_open:setVisible(true)
			local Text_kqtj_info_1 = ccui.Helper:seekWidgetByName(root, "Text_kqtj_info_1")
			local Text_kqtj_info_2 = ccui.Helper:seekWidgetByName(root, "Text_kqtj_info_2")
			local Text_kqtj2 = ccui.Helper:seekWidgetByName(root, "Text_kqtj2")
			Text_kqtj2:setVisible(false)
			Text_kqtj_info_2:setVisible(false)
			local openNpc1 = 0
			local openNpc2 = 0
			local npcName1 = _new_interface_text[139]
			local npcName2 = _new_interface_text[140]
			for i , v in pairs(dms["npc"]) do
				local unlock_npc = zstring.split(dms.atos(v , npc.unlock_npc),",")
				for j ,k in pairs(unlock_npc) do
					if tonumber(k) == tonumber(self.currentNpcID) then
						if openNpc1 == 0 then
							openNpc1 = i
						else
							openNpc2 = i
						end
					end
				end
			end
			local function getOpenTextById(npcId)
				--npc名称
				local name_info = ""
		        local name_data = zstring.split(dms.string(dms["npc"], npcId, npc.npc_name), "|")
		        for i, v in pairs(name_data) do
		            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
		            name_info = name_info..word_info[3]
		        end
		        --副本类型
		        local textScenceType = ""
				local npcScence = dms.int(dms["npc"], npcId, npc.scene_id)
				local scene_type = dms.int(dms["pve_scene"], npcScence, pve_scene.scene_type)
				if scene_type == 0 then
					textScenceType = _new_interface_text[142]
				elseif scene_type == 15 and (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece)  then
					textScenceType = _new_interface_text[317]
				else
					textScenceType = _new_interface_text[141]
				end
				--开启状态
				local open_type = false
				local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], npcScence, pve_scene.npcs), ",")
				local currIndex = 0
				for i , v in pairs(tempNpcIds) do
					if tonumber(v) == npcId then
						currIndex = i
						break
					end
				end
				local sceneState = tonumber(_ED.scene_current_state[npcScence])
				if currIndex <= sceneState then
					open_type = true
				end
				return textScenceType..name_info,open_type
			end
			--第一个
			local text1 , open_type1 = getOpenTextById(openNpc1)
			Text_kqtj_info_1:setString(npcName1..text1)
			if open_type1 == false then
				Text_kqtj_info_1:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
			end
			--第二个
			if openNpc2 ~= 0 then
				Text_kqtj2:setVisible(true)
				Text_kqtj_info_2:setVisible(true)
				local text2 , open_type2 = getOpenTextById(openNpc2)
				Text_kqtj_info_2:setString(npcName2..text2)
				if open_type2 == false then
					Text_kqtj_info_2:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
				end
			end
		else
			Panel_open:setVisible(true)
		end
	end
end

function LPVENpc:updatePassFormationInfo( ... )
	local root = self.roots[1]
	local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	if Panel_1 ~= nil then
		local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
		local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
		local Text_role_fight = ccui.Helper:seekWidgetByName(root, "Text_role_fight")
		Text_name:setString("")
		Text_role_fight:setString("")
		ListView_1:removeAllItems()

		local passInfo = _ED.copy_clear_user_info[""..self.currentNpcID]
		if passInfo == nil then
			Panel_1:setVisible(false)
		else
			Panel_1:setVisible(true)
			Text_name:setString(passInfo.userName)
			Text_role_fight:setString(passInfo.userFighting)
			for i=1, passInfo.formationCount do
				local ship = passInfo.formationInfo[i]
				local cell = state_machine.excute("union_fighting_formation_icon_create", 0, {ship, false, 0})
				ListView_1:addChild(cell)
			end
			ListView_1:requestRefreshView()
		end
	end
end

function LPVENpc:onEnterTransitionFinish()
	if self.isTurn == false then
		local filePath = "duplicate/pve_duplicate_tow.csb"
	    local csbPVEnpc = csb.createNode(filePath)
	    local root = csbPVEnpc:getChildByName("root")
		table.insert(self.roots, root)
	    self:addChild(csbPVEnpc)
		
		local action = csb.createTimeline("duplicate/pve_duplicate_tow.csb") 
	    table.insert(self.actions, action )
	    csbPVEnpc:runAction(action)
	    action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end	
	        local str = frame:getEvent()
			if str == "window_open_over" then
			elseif str == "window_close_over" then
				state_machine.excute("lpve_npc_window_close", 0, 0)
			end
	    end)
		
		if action:IsAnimationInfoExists("window_open_over") == true then
			action:play("window_open_over", false)
		end
		
		-- 关闭
		self:addTouchEventFunc("Button_103", "lpve_npc_window_close", true)
		
		-- 挑战
		self:addTouchEventFunc("Button_601", "lclick_go_fight", true)
		self:addTouchEventFunc("Button_601_1", "lclick_go_fight", true)
		
		--体力消耗
		self.cacheStrengthText = ccui.Helper:seekWidgetByName(root, "Text_4_0")
		
		--经验获得
		self.cacheExpText = ccui.Helper:seekWidgetByName(root, "Text_4_0_0")
		
		--银币获得
		self.cacheMoneyText = ccui.Helper:seekWidgetByName(root, "Text_4_0_0_0")
		
		--掉落宝物
		for i = 1, 4 do
			local tmpIcon = ccui.Helper:seekWidgetByName(root, "Panel_30_" .. i)
			table.insert(self.cacheTeasureDorpIcons, tmpIcon)
		end

		--噩梦副本奖励
		for i = 1, 3 do
			local tmpIcon = ccui.Helper:seekWidgetByName(root, "Panel_pt_" .. i)
			local tmpIcon1 = ccui.Helper:seekWidgetByName(root, "Panel_sx_" .. i)
			table.insert(self.cacheEmTeasureDorpIcons, tmpIcon)
			table.insert(self.cacheEmSanXingDorpIcons, tmpIcon1)
		end
		
		--挑战次数 
		self.cacheFightTimesText = ccui.Helper:seekWidgetByName(root, "Text_tzcishu_1")
		--挑战3次按钮
		local Button_shao3ci = ccui.Helper:seekWidgetByName(root, "Button_shao3ci")
		if Button_shao3ci ~= nil then
			Button_shao3ci.times = 3
			self.cacheBattleThreeBtn = self:addTouchEventFunc("Button_shao3ci", "lclick_battle_ten", true)
		end
		--扫荡50次按钮
		local Button_shao50ci = ccui.Helper:seekWidgetByName(root, "Button_shao50ci")
		if Button_shao50ci ~= nil then
			Button_shao50ci.times = 50
			self.cacheBattleFiftyBtn = self:addTouchEventFunc("Button_shao50ci", "lclick_battle_ten", true)
		end
		--挑战十次按钮
		self.cacheBattleTenBtn = self:addTouchEventFunc("Button_501", "lclick_battle_ten", true)
		self.cacheBattleOenBtn = self:addTouchEventFunc("Button_501_0", "lclick_battle_sweep", true)
		self.cacheBattleTenResetBtn = self:addTouchEventFunc("Button_601_0", "lclick_battle_ten_reset", true)
		self.cacheBattleTimesText = ccui.Helper:seekWidgetByName(root, "Text_10")
		-- self.cacheBattlePropText = ccui.Helper:seekWidgetByName(root, "Text_18_18")
		
		-- if self.currentSceneType == 9 then
			-- ccui.Helper:seekWidgetByName(root, "Panel_ptfb"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(root, "Panel_mjfb"):setVisible(true)
			-- self.cacheGoGoGoBtn = self:addTouchEventFunc("Button_chuzhan_4_4", "click_go_fight", true)
		-- end
		local img_di = ccui.Helper:seekWidgetByName(root, "Image_32")
		local panel_em = ccui.Helper:seekWidgetByName(root, "Panel_em_reward")
		local panel_pt = ccui.Helper:seekWidgetByName(root, "Panel_pt_reward")

		img_di:setVisible(self.currentSceneType ~= 15)
		panel_pt:setVisible(self.currentSceneType ~= 15)
		panel_em:setVisible(self.currentSceneType == 15)

		self.Button_zengjiacishu = ccui.Helper:seekWidgetByName(root, "Button_zengjiacishu")
		if self.Button_zengjiacishu ~= nil then
			self.Button_zengjiacishu:setVisible(false)
		end
		--添加布阵按钮事件
		self:addTouchEventFunc("Button_buzhen_0", "lclick_open_formation", true)
		
		self:onUpdateDraw()

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_tow_left"), nil, 
		{
			terminal_name = "lpvenpc_to_turn", 
			terminal_state = 0, 
			currentNpcID = self.currentNpcID ,
			turn_type = "left",
			isPressedActionEnabled = true
		}, 
		nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_tow_right"), nil, 
		{
			terminal_name = "lpvenpc_to_turn", 
			terminal_state = 0, 
			currentNpcID = self.currentNpcID ,
			turn_type = "right",
			isPressedActionEnabled = true
		}, 
		nil, 0)

		fwin:addTouchEventListener(self.Button_zengjiacishu, nil, 
		{
			terminal_name = "lclick_buy_times", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_em_pt_rec"), nil, 
		{
			terminal_name = "pve_npc_reward_box_get", 
			terminal_state = 0, 
			lq_type = 0,
			isPressedActionEnabled = true
		}, 
		nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_em_sx_rec"), nil, 
		{
			terminal_name = "pve_npc_reward_box_get", 
			terminal_state = 1, 
			lq_type = 1,
			isPressedActionEnabled = true
		}, 
		nil, 0)

		local function responseCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
					response.node:updatePassFormationInfo()
				end
			end
		end
		protocol_command.get_copy_clear_user_info.param_list = self.currentNpcID
		NetworkManager:register(protocol_command.get_copy_clear_user_info.code, nil, nil, nil, self, responseCallback, false, nil)

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			app.load("client.player.UserTopInfoA") 					--顶部用户信息
			fwin:close(fwin:find("UserTopInfoAClass"))
			local userinfo = UserTopInfoA:new()
			fwin:open(userinfo,fwin._ui)
		end

		self:checkTurnButtonState()
	end	
end

function LPVENpc:onInit()
	if self.isTurn == true then
		local filePath = "duplicate/pve_duplicate_tow.csb"
	    local csbPVEnpc = csb.createNode(filePath)
	    local root = csbPVEnpc:getChildByName("root")
		table.insert(self.roots, root)
	    self:addChild(csbPVEnpc)

		local action = csb.createTimeline("duplicate/pve_duplicate_tow.csb")
	    table.insert(self.actions, action )
	    csbPVEnpc:runAction(action)
	    action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end	
	        local str = frame:getEvent()
			if str == "window_open_over" then
			elseif str == "window_close_over" then
				state_machine.excute("lpve_npc_window_close", 0, 0)
			end
	    end)
		
		if action:IsAnimationInfoExists("window_open_over") == true then
			action:play("window_open_over", false)
		end
		
		-- 关闭
		self:addTouchEventFunc("Button_103", "lpve_npc_window_close", true)
		
		-- 挑战
		self:addTouchEventFunc("Button_601", "lclick_go_fight", true)
		self:addTouchEventFunc("Button_601_1", "lclick_go_fight", true)
		
		--体力消耗
		self.cacheStrengthText = ccui.Helper:seekWidgetByName(root, "Text_4_0")
		
		--经验获得
		self.cacheExpText = ccui.Helper:seekWidgetByName(root, "Text_4_0_0")
		
		--银币获得
		self.cacheMoneyText = ccui.Helper:seekWidgetByName(root, "Text_4_0_0_0")
		
		--掉落宝物
		for i = 1, 4 do
			local tmpIcon = ccui.Helper:seekWidgetByName(root, "Panel_30_" .. i)
			table.insert(self.cacheTeasureDorpIcons, tmpIcon)
		end
		
		--挑战次数 
		self.cacheFightTimesText = ccui.Helper:seekWidgetByName(root, "Text_tzcishu_1")
		--挑战3次按钮
		local Button_shao3ci = ccui.Helper:seekWidgetByName(root, "Button_shao3ci")
		if Button_shao3ci ~= nil then
			Button_shao3ci.times = 3
			self.cacheBattleThreeBtn = self:addTouchEventFunc("Button_shao3ci", "lclick_battle_ten", true)
		end
		--扫荡50次按钮
		local Button_shao50ci = ccui.Helper:seekWidgetByName(root, "Button_shao50ci")
		if Button_shao50ci ~= nil then
			Button_shao50ci.times = 50
			self.cacheBattleFiftyBtn = self:addTouchEventFunc("Button_shao50ci", "lclick_battle_ten", true)
		end
		--挑战十次按钮
		self.cacheBattleTenBtn = self:addTouchEventFunc("Button_501", "lclick_battle_ten", true)
		self.cacheBattleOenBtn = self:addTouchEventFunc("Button_501", "lclick_battle_sweep", true)
		self.cacheBattleTenResetBtn = self:addTouchEventFunc("Button_601_0", "lclick_battle_ten_reset", true)
		self.cacheBattleTimesText = ccui.Helper:seekWidgetByName(root, "Text_10")
		-- self.cacheBattlePropText = ccui.Helper:seekWidgetByName(root, "Text_18_18")
		
		-- if self.currentSceneType == 9 then
			-- ccui.Helper:seekWidgetByName(root, "Panel_ptfb"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(root, "Panel_mjfb"):setVisible(true)
			-- self.cacheGoGoGoBtn = self:addTouchEventFunc("Button_chuzhan_4_4", "click_go_fight", true)
		-- end
		self.Button_zengjiacishu = ccui.Helper:seekWidgetByName(root, "Button_zengjiacishu")
		self.Button_zengjiacishu:setVisible(false)
		--添加布阵按钮事件
		self:addTouchEventFunc("Button_buzhen_0", "lclick_open_formation", true)
		local button_left = ccui.Helper:seekWidgetByName(root,"Button_pve_tow_left")
		fwin:addTouchEventListener(button_left, nil, 
		{
			terminal_name = "lpvenpc_to_turn", 
			terminal_state = 0, 
			currentNpcID = self.currentNpcID ,
			turn_type = "left",
			isPressedActionEnabled = true
		}, 
		nil, 0)
		local button_right = ccui.Helper:seekWidgetByName(root,"Button_pve_tow_right")
		fwin:addTouchEventListener(button_right, nil, 
		{
			terminal_name = "lpvenpc_to_turn", 
			terminal_state = 0, 
			currentNpcID = self.currentNpcID ,
			turn_type = "right",
			isPressedActionEnabled = true
		}, 
		nil, 0)
		fwin:addTouchEventListener(self.Button_zengjiacishu, nil, 
		{
			terminal_name = "lclick_buy_times", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)

		local function responseCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
					response.node:updatePassFormationInfo()
				end
			end
		end
		protocol_command.get_copy_clear_user_info.param_list = self.currentNpcID
		NetworkManager:register(protocol_command.get_copy_clear_user_info.code, nil, nil, nil, self, responseCallback, false, nil)

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			app.load("client.player.UserTopInfoA") 					--顶部用户信息
			fwin:close(fwin:find("UserTopInfoAClass"))
			local userinfo = UserTopInfoA:new()
			fwin:open(userinfo,fwin._ui)
		end

		self:onUpdateDraw()
		self:checkTurnButtonState()
	end
end
function LPVENpc:checkTurnButtonState()
	local root = self.roots[1]
	local button_left = ccui.Helper:seekWidgetByName(root,"Button_pve_tow_left")
	local button_right = ccui.Helper:seekWidgetByName(root,"Button_pve_tow_right")
	local currentNpcID = self.currentNpcID
	local last_npc_id = dms.int(dms["npc"],currentNpcID,npc.last_npc_id)

	if last_npc_id == -1 or _ED.npc_state[last_npc_id] == "-1" then
		button_left:setVisible(false)
	end
	local next_npc_id = dms.int(dms["npc"],currentNpcID,npc.next_npc_id)
	if next_npc_id == -1 or _ED.npc_state[next_npc_id] == "-1" then
		button_right:setVisible(false)
	end
	

		-- print("=---------------------------------------------",last_npc_id,next_npc_id)
end

-- 控制扫荡五十次按钮的显示
function LPVENpc:showFiftyBtn()
	self.cacheBattleFiftyBtn:setVisible(true)
	local hadChallengeTimes = _ED.total_pass_level_counts

	if hadChallengeTimes ~= nil then
		local limitChallengeTimes = dms.int(dms["play_config"], 287, play_config.param)
		limitChallengeTimes = limitChallengeTimes and limitChallengeTimes or 0

		self.cacheBattleFiftyBtn:setVisible(hadChallengeTimes >= limitChallengeTimes)
	end
end

function LPVENpc:onExit()
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_" .. self.boss_display_index .. ".ExportJson")
	
	state_machine.remove("lpve_npc_close")
	state_machine.remove("lpve_npc_window_close")
	state_machine.remove("lpve_stage_bottom_sweep_over_update_draw")
	state_machine.remove("lclick_battle_ten")
	state_machine.remove("lclick_battle_ten_reset")
	state_machine.remove("lclick_battle_ten_reset_update_draw")
	state_machine.remove("lclick_battle_sweep")
	state_machine.remove("lclick_go_fight")
	state_machine.remove("lclick_open_formation")
	state_machine.remove("lclick_buy_times")
end
