----------------------------------------------------------------------------------------------------
-- 说明：Pve界面 底部信息界面
-------------------------------------------------------------------------------------------------------
PVEStageBottomCell = class("PVEStageBottomCellClass", Window)

function PVEStageBottomCell:ctor()
    self.super:ctor()
	
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.battle.BattleStartEffect")
	app.load("client.duplicate.MoppingResults")
	app.load("client.duplicate.pve.PVENpcRewardBox")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.campaign.icon.arena_role_icon_cell")
	
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	self.currentNpcID = 0		--当前显示的关卡id
	self.currentSceneID = 0		--当前场景Id
	self.cacheAction = nil		--缓存面板动画
	

	self.currentSceneType = 0   -- 当前场景的类型
	
	self.maxAttackCount = 0			--总攻击次数
	self.currentAttackTimes = 0		--当前已经攻击次数
	
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
	--挑战十次按钮 上面的文本
	self.cacheBattleTimesText = nil
	
	-- 挑战的重置
	self.cacheBattleTenResetBtn = nil
	
	--出击出击出击 啪啪啪 Button_chuzhan
	self.cacheGoGoGoBtn = nil
	
	--关卡宝箱按钮
	self.cacheTGBoxBtn = nil
	
	--TeasureDorp
	self.cacheTeasureDorpIcons = {}
	self.cacheBattlePropText = nil
	
	--设置是否可以点击按钮 主要针对扫荡 和 出战
	self.canClickBtn = false
	
	--更新状态所用的pageview_seat_cell实例
	self.tmpSeatCell = nil
	
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_pve_bottom_info_panel_terminal()
		
		-- update information
		local pve_bottom_update_information_terminal = {
            _name = "pve_bottom_update_information",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--> print("click_battle_ten Click")
				-- instance:playAction("open")
				--> print("pve_bottom_update_information pve_bottom_update_information zzzzzz")
				instance.currentNpcID = params.npcID
				instance.currentSceneID = params.sceneID
				instance.tmpSeatCell = params.seatCell
				-- instance:onUpdateDraw()
				cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, instance.onUpdateDraw, instance)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--更新宝箱领取状态
		local pve_bottom_update_box_state_terminal = {
            _name = "pve_bottom_update_box_state",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--判断以及更新NPC宝箱状态
				if instance ~= nil and instance.roots ~= nil then
					instance:checkBoxState()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- play action
		local pve_bottom_play_action_terminal = {
            _name = "pve_bottom_play_action",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params == "open" then
					instance.canClickBtn = false
				end
				instance:playAction(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- NPC宝箱领取
		local pve_bottom_npc_box_click_terminal = {
            _name = "pve_bottom_npc_box_click",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if zstring.tonumber(instance.currentNpcID) <= 0 then
					return
				end
				
				local prb = PVENpcRewardBox:new()
				prb:init(instance.currentSceneID, instance.currentNpcID, instance.tmpSeatCell)
				fwin:open(prb, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 扫荡完成后更新界面信息
        local pve_stage_bottom_sweep_over_update_draw_terminal = {
            _name = "pve_stage_bottom_sweep_over_update_draw",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- instance:onUpdateDraw()
				cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, instance.onUpdateDraw, instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 扫荡
		local click_battle_ten_terminal = {
            _name = "click_battle_ten",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local myLv = tonumber(_ED.user_info.user_grade)
					local myVip = tonumber(_ED.vip_grade)
					local needLv = dms.int(dms["fun_open_condition"], 38, fun_open_condition.level)
					local needVip = dms.int(dms["fun_open_condition"], 38, fun_open_condition.vip_level)
					if myLv < needLv or myVip < needVip then
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 38, fun_open_condition.tip_info))
						return
					end
					local star = tonumber(_ED.npc_state[tonumber(""..instance.currentNpcID)])
					
					if star < 3 then
						if star == 0 then
							TipDlg.drawTextDailog(_string_piece_info[327])
							return
						else
							TipDlg.drawTextDailog(_string_piece_info[328])
							return
						end
					end

					local currentNpcID = instance.currentNpcID							-- NPCID
					local DifficultyID = 1												-- 攻击下标
					local surplusTimes = 1--self.maxAttackCount - self.currentAttackTimes	-- 扫荡次数
					local elseContent  = "0"											-- 扫荡类型
					
					local totalAttackTimes = dms.int(dms["npc"], instance.currentNpcID, npc.daily_attack_count)
					local surplusAttackCount = _ED.npc_current_attack_count[tonumber(instance.currentNpcID)]
					local finalBattleTimes = totalAttackTimes - surplusAttackCount
					if (finalBattleTimes > 10) then finalBattleTimes = 10 end
					surplusTimes = finalBattleTimes
					
					--> print("ttttttttttttttttttttttttttttttttttttttttttttt", surplusTimes)
					
					if tonumber(surplusTimes) <= 0 then
						TipDlg.drawTextDailog(_string_piece_info[113])
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
							return
						end

					-- 打开扫荡界面
					
						-- if tonumber(_ED.npc_max_state[tonumber(""..self.currentNpcID)]) == tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)]) then
						-- if tonumber(_ED.environment_formetion_state) == 3 then
							fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"pve_stage_bottom_sweep_over_update_draw", instance}), fwin._ui)
						-- else
							-- TipDlg.drawTextDailog(_string_piece_info[328])
						-- end
						

					-- local function responseBattleTenCallback(response)
					-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					-- 		local moppingResultsPage = MoppingResults:new()
					-- 		fwin:open(moppingResultsPage, fwin._view)
							
					-- 		--更新扫荡次数
					-- 		surplusAttackCount = _ED.npc_current_attack_count[tonumber(instance.currentNpcID)]
					-- 		instance.cacheFightTimesText:setString(surplusAttackCount .. "/" .. totalAttackTimes)
					-- 	end
					-- end
		--         	--> print("click_battle_ten Click")
					-- if instance.canClickBtn == false then 
					-- 	return
					-- else
					-- 	protocol_command.sweep.param_list = ""..currentNpcID.."\r\n"..DifficultyID.."\r\n"..surplusTimes.."\r\n"..elseContent
					-- 	NetworkManager:register(protocol_command.sweep.code, nil, nil, nil, nil, responseBattleTenCallback, true, nil)
					-- end
					-- --测试一下动画灭
					-- -- self:testAnimation()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 扫荡重置
		local click_battle_ten_reset_terminal = {
            _name = "click_battle_ten_reset",
            _init = function (terminal) 
            	app.load("client.duplicate.pve.PVEResetNPCAttackCount")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				if getPVENPCResidualCount(instance.currentNpcID) > 0 then
					local view = PVEResetNPCAttackCount:new():init(1, instance.currentNpcID, 0, 0, {"click_battle_ten_reset_update_draw", instance})
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
        local click_battle_ten_reset_update_draw_terminal = {
            _name = "click_battle_ten_reset_update_draw",
            _init = function (terminal) 
            	
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- instance:onUpdateDraw()
				cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, instance.onUpdateDraw, instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 出战
		local click_go_fight_terminal = {
            _name = "click_go_fight",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					--> print("click_go_go_go Click")
					if instance.canClickBtn == false then return end
					-- TipDlg.drawTextDailog(_string_piece_info[113])
					if instance.currentAttackTimes >= instance.maxAttackCount then
						TipDlg.drawTextDailog(_string_piece_info[113])
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
						return
					end
					
					---[[
					--DOTO 战斗请求
					local function responseBattleInitCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("page_stage_fight_data_deal", 0, 0)
						
						
							-- cacher.removeAllObject(_object)
							cacher.removeAllTextures()
							
							fwin:cleanView(fwin._windows)
							-- fwin:freeAllMemeryPool()
							cc.Director:getInstance():purgeCachedData()
							local bse = BattleStartEffect:new()
							bse:init(1)
							fwin:open(bse, fwin._windows)
							-- state_machine.excute("battle_start_play_start_effect", 0, 1)
							-- BattleSceneClass.Draw()
							-- state_machine.excute("page_stage_fight_animation", 0, 0)

							-- cacher.removeAllObject(_object)
							-- cacher.removeAllTextures()
							-- fwin:reset(nil)
							-- cc.Ref:printLeaks()
							-- fwin._printLeaks = true
						end
					end
					
					local function launchBattle()
						if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
							app.load("client.battle.report.BattleReport")
							local fightModule = FightModule:new()
							fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0)
							fightModule:doFight()
							
							responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
						else
							local  battleFieldInitParam = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
							protocol_command.battle_field_init.param_list = battleFieldInitParam
							NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
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
                return true
				--]]
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 副本星级排行榜
		local pve_bottom_copy_star_ranklist_click_terminal = {
            _name = "pve_bottom_copy_star_ranklist_click",
            _init = function (terminal) 
            	app.load("client.duplicate.pve.PVESceneStarChart")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local star = PVESceneStarChart:new()
				star:init()
				fwin:open(star, fwin._windows)
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 名将副本切换
		local pve_stage_bottom_cell_change_types_terminal = {
            _name = "pve_stage_bottom_cell_change_types",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if params == 1 then		--主线
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ptfb"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_mjfb"):setVisible(false)
					instance.cacheGoGoGoBtn = instance:addTouchEventFunc("Button_chuzhan", "click_go_fight", true)
				elseif params == 2 then	--名将
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ptfb"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_mjfb"):setVisible(true)
					instance.cacheGoGoGoBtn = instance:addTouchEventFunc("Button_chuzhan_4_4", "click_go_fight", true)
				end
				
				instance:updateView(params)
				
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(pve_stage_bottom_sweep_over_update_draw_terminal)
		state_machine.add(click_battle_ten_terminal)
		state_machine.add(click_battle_ten_reset_update_draw_terminal)
		state_machine.add(click_battle_ten_reset_terminal)
		state_machine.add(click_go_fight_terminal)
		state_machine.add(pve_bottom_update_information_terminal)
		state_machine.add(pve_bottom_play_action_terminal)
		state_machine.add(pve_bottom_npc_box_click_terminal)
		state_machine.add(pve_bottom_update_box_state_terminal)
		state_machine.add(pve_bottom_copy_star_ranklist_click_terminal)
		state_machine.add(pve_stage_bottom_cell_change_types_terminal)
        state_machine.init()
	end
	
	init_pve_bottom_info_panel_terminal()
end


function PVEStageBottomCell:updateView(params)
	if params == 1 then		--主线
		self.cacheTGBoxBtn = self:addTouchEventFunc("Button_guanq_box", "pve_bottom_npc_box_click", true)
		self.canDraw = ccui.Helper:seekWidgetByName(self.roots[1], "Image_lingqu")
		self.disDraw = ccui.Helper:seekWidgetByName(self.roots[1], "Image_yilingqu")
	elseif params == 2 then	--名将
		self.cacheTGBoxBtn = self:addTouchEventFunc("Button_guanq_box_6_6", "pve_bottom_npc_box_click", true)
		self.canDraw = ccui.Helper:seekWidgetByName(self.roots[1], "Image_lingqu_10_12")
		self.disDraw = ccui.Helper:seekWidgetByName(self.roots[1], "Image_yilingqu_12_14")
	end

	self:checkBoxState()
end

--播放动画
function PVEStageBottomCell:playAction(actionName)
	--> print("asdasdasdasdasdasdasdasdasdasda", actionName)
	if self.cacheAction ~= nil then
		self.cacheAction:play(actionName, false)
	end
end

function PVEStageBottomCell:onUpdateDraw()
	if self.currentNpcID == -1 or self.currentNpcID == -10 then return end

	--> print("current Npc ID: ", self.currentNpcID)
	
	-- self.pass_ccustoms_num = _ED.npc_state[tonumber(""..npcId)]		-- 通关星数	
	-- local quality = dms.int(dms["npc"], npcId, npc.base_pic)
	-- local color = tipStringInfo_quality_color_Type[quality]
	-- self.npc_name_color    = cc.c4b(color[1],color[2],color[3],255) -- cc.c4b(255,0,0,255)							-- npc人物的品质--difficulty_include_count base_pic
	-- self.npc_name	   = dms.string(dms["npc"], npcId, npc.npc_name)     	-- npc人物名字
	-- self.npc_attack_state  = state												-- npc攻击状态  0：打过  1：可攻击
	-- self.npc_pic = dms.string(dms["npc"], npcId, npc.head_pic)
	--> print("tttttttttttttttttttttttttttttttttttttttttttt", self.currentNpcID)
	-- local rewardList = zstring.split(dms.string(dms["npc"], self.currentNpcID, npc.difficulty_reward), "|")
	-- local difficulty = dms.string(dms["npc"], self.currentNpcID, npc.difficulty_include_count)
	--> print("zzzzzzzzzzzzzz'z'z'zzzzzzzzzzzzzzzzzzzzzzzz", rewardList[0])
	-- local rewardInfo = zstring.split(rewardList[1], ",")
	
	--显示体力 attack_need_food
	self.attack_need_food = dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)
	self.cacheStrengthText:setString(self.attack_need_food)
	
	--猪脚等级
	local masterLv = tonumber(_ED.user_info.user_grade)
	
	--经验获得 Text_exp
	self.cacheExpText:setString(_string_piece_info[153] .. masterLv * 10 * dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)
	
	--银币获得 Text_money
	local money = dms.int(dms["grade_silver_reward"], masterLv, grade_silver_reward.silver)
	self.cacheMoneyText:setString(_string_piece_info[153] .. money* dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)
	
	
	
	-- 绘制挑战次数
	local totalAttackTimes = dms.int(dms["npc"], self.currentNpcID, npc.daily_attack_count)
	local surplusAttackCount = _ED.npc_current_attack_count[tonumber(self.currentNpcID)]
	self.cacheFightTimesText:setString((totalAttackTimes - surplusAttackCount) .. "/" .. totalAttackTimes)
	self.maxAttackCount = tonumber(totalAttackTimes)
	self.currentAttackTimes = tonumber(surplusAttackCount)
	
	local myLv = tonumber(_ED.user_info.user_grade)
	local myVip = tonumber(_ED.vip_grade)
	local needLv = dms.int(dms["fun_open_condition"], 38, fun_open_condition.level)
	local needVip = dms.int(dms["fun_open_condition"], 38, fun_open_condition.vip_level)
	
	--> print("....................", myLv, myVip)
	
	-- if myLv < needLv or myVip < needVip then
	-- 	-- self.cacheBattleTimesText:setVisible(false)
	-- 	self.cacheBattleTenBtn:setVisible(false)
	-- else
		local finalBattleTimes = totalAttackTimes - surplusAttackCount
		self.cacheBattleTenBtn:setVisible(finalBattleTimes > 0)
		self.cacheBattleTenResetBtn:setVisible(finalBattleTimes <= 0)
		if (finalBattleTimes > 10) then finalBattleTimes = 10 end
		--更新扫荡上面的文字
		self.cacheBattleTimesText:setString(finalBattleTimes .. _string_piece_info[70])
	-- end
	
	--清空icon panel原有的元素
	for i, v in pairs(self.cacheTeasureDorpIcons) do
		for c, t in pairs(v:getChildren()) do
			v:removeChild(t)
		end
	end
	
	--绘制奖励
	local rewardID = dms.int(dms["npc"], self.currentNpcID, npc.drop_library)
	
	if tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)]) == 0 then
		self.cacheBattleTenBtn:setVisible(false)
	end
	
	--> print("rewardID-------------------------------------", rewardID)
	
	if rewardID > 0 then
	-------------------------------------------------------------------
		-- local rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_prop)
		local rewardTotal = 1
		local rewardMoney = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_silver))
		local rewardGold = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_gold))
		local rewardHonor = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_honor))
		local rewardSoul = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul))
		local rewardJade = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade))
		local rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_prop)
		local rewardEquListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_equipment)
		local rewardShipListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_ship)
		local rewardMaxJade = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade_max))
		local rewardMaxSoul = zstring.tonumber(dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul_max))
		
		if rewardMaxJade > 0 and rewardJade > 0 then
			self.cacheBattlePropText:setString(rewardJade .. "~" .. rewardMaxJade)
		end	
		
		if rewardMoney > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(1, rewardMoney, -1)
			self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
			rewardTotal = rewardTotal + 1
		end
		
		--> print("gggggggggggggggggggggggggggggggggggggggggg", rewardGold)
		if rewardGold > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(2, rewardGold, -1)
			self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
			rewardTotal = rewardTotal + 1
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
			
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4_3_7_7"):setBackGroundImage(string.format("images/ui/props/props_%d.png", 4007))
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_18_18_18"):setString(rewardSoul)
		else
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_tl_1_0_12_12_12"):setString(" ")
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_20_20"):setString(" ")
		end
		
		-- if rewardTotal > 4 then
			-- return
		-- end
		
		if rewardJade~=nil and rewardJade > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(5, rewardJade, -1)
			self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
			rewardTotal = rewardTotal + 1
		end
		
		-- if rewardTotal > 4 then
			-- return
		-- end
		
		--> print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh", rewardItemListStr)
		
		--绘制道具
		if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
		------------------------------------------------------------
			local rewardProp = zstring.split(rewardItemListStr, "|")
			--> print("ggggggggggggggggggggggggggggggggggggggg", table.getn(rewardProp))
			if table.getn(rewardProp) > 0 then
				for i,v in pairs(rewardProp) do
					local rewardPropInfo = zstring.split(v, ",")
					--> print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", #rewardPropInfo)
					-- if rewardPropInfo == "" or rewardPropInfo == nil then break end
					if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
						-- app.load("client.cells.prop.prop_icon_cell")
						local reward = PropIconCell:createCell()
						local reawrdID = tonumber(rewardPropInfo[2])
						local rewardNum = tonumber(rewardPropInfo[1])
						reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum}, nil, false)
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
	-------------------------------------------------------------------
	end
	
	self.canClickBtn = true
	self:playAction("close")
	
	--判断以及更新NPC宝箱状态
	self:checkBoxState()

	-- if self.currentSceneType == 9 then
		local root = self.roots[1]
		local controlPad = ccui.Helper:seekWidgetByName(root, "Panel_mjfb")
		local fristRewardElement = dms.element(dms["scene_reward"], dms.int(dms["npc"], self.currentNpcID, npc.first_reward))
		local gold = dms.atos(fristRewardElement, scene_reward.reward_gold)
		-- 首胜奖励
		if gold ~= nil then
			ccui.Helper:seekWidgetByName(controlPad, "Text_4"):setString("".. gold)
		end
		
		ccui.Helper:seekWidgetByName(controlPad, "Text_8"):setString(_string_piece_info[153] .. masterLv * 10 * dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)

		local rewardList = zstring.split(dms.string(dms["npc"], self.currentNpcID, npc.difficulty_reward), "|")
		local rewardInfo = zstring.split(rewardList[1], ",")
		
		local money = dms.int(dms["grade_silver_reward"], masterLv, grade_silver_reward.silver)
		ccui.Helper:seekWidgetByName(controlPad, "Text_10"):setString(_string_piece_info[153] .. money* dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)

		-- 水雷魂
		local reward = ResourcesIconCell:createCell()
		reward:init(5, 0, -1)
		ccui.Helper:seekWidgetByName(controlPad, "Panel_4_3_7"):removeAllChildren(true)
		ccui.Helper:seekWidgetByName(controlPad, "Panel_4_3_7"):addChild(reward)
		--setBackGroundImage(string.format("images/ui/props/props_%d.png", 4008))

		-- 今天剩余的挑战
		ccui.Helper:seekWidgetByName(controlPad, "Text_16_0_18"):setString((totalAttackTimes - surplusAttackCount) .. "/" .. totalAttackTimes)
	-- end
	-- ccui.Helper:seekWidgetByName(controlPad, "Text_16_0_18"):setString((totalAttackTimes - surplusAttackCount) .. "/" .. totalAttackTimes)
	
	
	---------------------------------------------------------------------------
	-- 龙虎门星数、关卡名增加
	---------------------------------------------------------------------------
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		local CurStar = 0
		if zstring.tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.currentNpcID)]) 
		  and zstring.tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)]) ~= 0 then
			CurStar = tonumber(_ED.npc_max_state[tonumber(""..self.currentNpcID)])
		else
			CurStar = tonumber(_ED.npc_state[tonumber(""..self.currentNpcID)])
		end
		if CurStar == 1 then  
			ccui.Helper:seekWidgetByName(root, "Image_1_01"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_1_02"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_1_03"):setVisible(false)
		elseif CurStar == 2 then 
			ccui.Helper:seekWidgetByName(root, "Image_1_01"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_1_02"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_1_03"):setVisible(false)
		elseif CurStar == 3 then
			ccui.Helper:seekWidgetByName(root, "Image_1_01"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_1_02"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_1_03"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root, "Image_1_01"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_1_02"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_1_03"):setVisible(false)
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        local name_info = ""
	        local name_data = zstring.split(dms.string(dms["npc"], self.currentNpcID, npc.npc_name), "|")
	        for i, v in pairs(name_data) do
	            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
	            name_info = name_info..word_info[3]
	        end
	        ccui.Helper:seekWidgetByName(root, "Text_104"):setString(name_info)
	    else
	    	ccui.Helper:seekWidgetByName(root, "Text_104"):setString(dms.string(dms["npc"], self.currentNpcID, npc.npc_name))
	    end
	end
	---------------------------------------------------------------------------
end

--判断NPC宝箱状态
function PVEStageBottomCell:checkBoxState()
	local npcIdListStr = dms.string(dms["pve_scene"], self.currentSceneID, pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")
	local checkResult = self:checkNpcTableForNpcID(npcIDTable, self.currentNpcID)
	local drawState = _ED.scene_draw_chest_npcs[self.currentNpcID]
	if self.cacheTGBoxBtn ~= nil and self.canDraw ~= nil and self.disDraw ~= nil then
		if checkResult == true then
			-----------------------------------------------------------------
			self.canDraw:setVisible(false)
			self.disDraw:setVisible(false)
		
			--已经领取
			if drawState == 1 then
				self.disDraw:setVisible(true)
			else--没有领取
				self.canDraw:setVisible(true)
				self.cacheTGBoxBtn:setTouchEnabled(true)
				self.cacheTGBoxBtn._data = self.currentNpcID
				state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_control_box",
				_widget = self.cacheTGBoxBtn,
				_invoke = nil,
				_interval = 0.5,})
			end
			self.cacheTGBoxBtn:setVisible(true)
			-----------------------------------------------------------------
		else
			self.cacheTGBoxBtn:setVisible(false)
		end
	end
end

--检测table中是否包含传入的NPCid
function PVEStageBottomCell:checkNpcTableForNpcID(npcIDTable, npcID)
	for i, v in pairs(npcIDTable) do
		if tonumber(v) == tonumber(npcID) then
			return true
		end
	end
	return false
end

function PVEStageBottomCell:createMount(name,pt)
    local armature = ccs.Armature:create(name)
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(pt)
    self:addChild(armature)
    return armature
end

function PVEStageBottomCell:onEnterTransitionFinish()
	self.tmpCsb:stopAllActions()
	local action = csb.createTimeline("duplicate/pve_fbxx_1.csb")
	self.tmpCsb:runAction(action)
	self.cacheAction = action
	
	-- local battleAnimCsb = csb.createNode("battle/battle_donghua.csb")
	-- local battleAnim = ccui.Helper:seekWidgetByName(battleAnimCsb, "ArmatureNode_1")
	-- self:addChild(battleAnim)
	
	
	-- local armature = ccs.Armature:create("HeroAnimation")
    -- armature:getAnimation():play("attack")
    -- armature:getAnimation():setSpeedScale(0.5)
	
	-- action:gotoFrameAndStop(10)
	-- action:play("open", false)
	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	--监听动画事件
	action:setFrameEventCallFunc(
		function (frame)
		--
			if nil == frame then
				return
			end

			local event = frame:getEvent()
			if event == "open_over" then
				--> print("open_over")
			elseif event == "close_over" then 
				self.canClickBtn = true
			end
		--
		end
	)
end

function PVEStageBottomCell:onInit()
	local tmpCsb = csb.createNode("duplicate/pve_fbxx_1.csb")
	self.tmpCsb = tmpCsb
	local root = tmpCsb:getChildByName("root")
	-- root:removeFromParent(false)
	self:addChild(tmpCsb)
	table.insert(self.roots, root)
	
	-- local action = csb.createTimeline("duplicate/pve_fbxx_1.csb")
	-- tmpCsb:runAction(action)
	-- self.cacheAction = action
	
	-- -- local battleAnimCsb = csb.createNode("battle/battle_donghua.csb")
	-- -- local battleAnim = ccui.Helper:seekWidgetByName(battleAnimCsb, "ArmatureNode_1")
	-- -- self:addChild(battleAnim)
	
	
	-- -- local armature = ccs.Armature:create("HeroAnimation")
 --    -- armature:getAnimation():play("attack")
 --    -- armature:getAnimation():setSpeedScale(0.5)
	
	-- -- action:gotoFrameAndStop(10)
	-- -- action:play("open", false)
	-- -- action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	-- --监听动画事件
	-- action:setFrameEventCallFunc(
	-- 	function (frame)
	-- 	--
	-- 		if nil == frame then
	-- 			return
	-- 		end

	-- 		local event = frame:getEvent()
	-- 		if event == "open_over" then
	-- 			--> print("open_over")
	-- 		elseif event == "close_over" then 
	-- 			self.canClickBtn = true
	-- 		end
	-- 	--
	-- 	end
	-- )
	
	--体力消耗 Text_tl_1_1
	self.cacheStrengthText = ccui.Helper:seekWidgetByName(root, "Text_tl_1_1")
	
	--经验获得 Text_exp
	self.cacheExpText = ccui.Helper:seekWidgetByName(root, "Text_exp")
	
	--银币获得 Text_money
	self.cacheMoneyText = ccui.Helper:seekWidgetByName(root, "Text_money")
	
	--掉落宝物 Panel_4 Panel_4_0 Panel_4_1 Panel_4_2 Panel_4_3
	local tmpIcon = ccui.Helper:seekWidgetByName(root, "Panel_4")
	table.insert(self.cacheTeasureDorpIcons, tmpIcon)
	for i = 0, 3 do
		tmpIcon = ccui.Helper:seekWidgetByName(root, "Panel_4_" .. i)
		table.insert(self.cacheTeasureDorpIcons, tmpIcon)
	end
	
	--挑战次数 Text_tzcs_0
	self.cacheFightTimesText = ccui.Helper:seekWidgetByName(root, "Text_tzcs_0")
	
	--挑战十次按钮 Button_sd10ci
	-- self.cacheBattleTenBtn = ccui.Helper:seekWidgetByName(root, "Button_sd10ci")
	self.cacheBattleTenBtn = self:addTouchEventFunc("Button_sd10ci", "click_battle_ten", true)
	self.cacheBattleTenResetBtn = self:addTouchEventFunc("Button_chongzhi", "click_battle_ten_reset", true)
	self.cacheBattleTimesText = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_cishu")
	self.cacheBattlePropText = ccui.Helper:seekWidgetByName(root, "Text_18_18")
	--出击出击出击 啪啪啪 Button_chuzhan
	-- self.cacheGoGoGoBtn = ccui.Helper:seekWidgetByName(root, "Button_chuzhan")
	self.cacheGoGoGoBtn = self:addTouchEventFunc("Button_chuzhan", "click_go_fight", true)
	
	--关卡宝箱
	self.cacheTGBoxBtn = self:addTouchEventFunc("Button_guanq_box_6_6", "pve_bottom_npc_box_click", true)
	-- ccui.Helper:seekWidgetByName(root, "Button_guanq_box")

	--副本星级排行榜
	local copyStarRanklistButton = self:addTouchEventFunc("Button_paihangbang", "pve_bottom_copy_star_ranklist_click", true)
	
	-- self:createMount("ArmatureNode_1", cc.p(0, 0))
	-- self.armature = ccs.Armature:create("battle/battle_donghua.csb")
    -- self.armature:getAnimation():playWithIndex(0)
    -- self.armature:setPosition(cc.p(VisibleRect:left().x + 70, VisibleRect:left().y))
    -- self.armature:setScale(1.2)
    -- self:addChild(self.armature)
	--开始绘制
	-- self:onUpdateDraw()

	if self.currentSceneType == 9 then
		ccui.Helper:seekWidgetByName(root, "Panel_ptfb"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_mjfb"):setVisible(true)
		self.cacheGoGoGoBtn = self:addTouchEventFunc("Button_chuzhan_4_4", "click_go_fight", true)
		-- self.cacheBattleTenResetBtn = self:addTouchEventFunc("Button_chongzhi", "click_battle_ten_reset", true)
	end
	
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
	or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
	or __lua_project_id == __lua_project_koone
	then
		--添加布阵按钮事件
		self:addTouchEventFunc("Button_buzhen", "page_view_open_formation", true)
	end	
end


--通用按钮点击事件添加
function PVEStageBottomCell:addTouchEventFunc(uiName, eventName, actionMode)
	local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	fwin:addTouchEventListener(tmpArt, nil, 
	{
		terminal_name = eventName, 
		next_terminal_name = "", 
		but_image = "",
		terminal_state = 0, 
		isPressedActionEnabled = actionMode
	},
	nil, 0)
	return tmpArt
end


function PVEStageBottomCell:onExit()
	self.roots = nil
	self.cacheAction = nil
	-- state_machine.remove("pve_stage_bottom_sweep_over_update_draw")
	-- state_machine.remove("click_battle_ten")
	-- state_machine.remove("click_battle_ten_reset_update_draw")
	-- state_machine.remove("click_battle_ten_reset")
	-- state_machine.remove("click_go_fight")
	-- state_machine.remove("pve_bottom_update_information")
	-- state_machine.remove("pve_bottom_play_action")
	-- state_machine.remove("pve_bottom_npc_box_click")
	-- state_machine.remove("pve_bottom_update_box_state")
	-- state_machine.remove("pve_bottom_copy_star_ranklist_click")
end

function PVEStageBottomCell:init(_sceneId)
	self.currentSceneID = _sceneId
	self.currentSceneType = dms.int(dms["pve_scene"], self.currentSceneID, pve_scene.scene_type) 

	self:onInit()
end

function PVEStageBottomCell:createCell()
	local cell = PVEStageBottomCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

