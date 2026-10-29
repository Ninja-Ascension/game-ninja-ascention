-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
LPVEGeneral = class("LPVEGeneralClass", Window)

function LPVEGeneral:ctor()
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
	
	--关卡宝箱按钮
	self.cacheTGBoxBtn = nil
	
	--TeasureDorp
	self.cacheTeasureDorpIcons = {}
	self.cacheBattlePropText = nil
	
	--设置是否可以点击按钮 主要针对扫荡 和 出战
	self.canClickBtn = false
	
	--更新状态所用的pageview_seat_cell实例
	self.tmpSeatCell = nil
	
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.battle.BattleStartEffect")
	app.load("client.duplicate.MoppingResults")
	
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.campaign.icon.arena_role_icon_cell")
	
    local function init_lpve_general_window_terminal()
		--关闭
		local lpve_general_close_terminal = {
            _name = "lpve_general_close",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local lpve_general_window_close_terminal = {
            _name = "lpve_general_window_close",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
		
			local obj = fwin:find("LPVEGeneralClass")
			if obj ~= nil then
				local action = obj.actions[1]
				if action ~= nil and action:IsAnimationInfoExists("window_close") == true then
					obj.actions[1]:play("window_close", false)
					state_machine.excute("lpve_general_close", 0, "lpve_general_close")
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
					
					
					if tonumber(surplusTimes) <= 0 then
						TipDlg.drawTextDailog(_string_piece_info[113])
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

					fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"lpve_stage_bottom_sweep_over_update_draw", instance}), fwin._ui)
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
		
		-- 出战
		local lclick_go_fight_general_terminal = {
            _name = "lclick_go_fight_general",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					if instance.canClickBtn == false then 
						return 
					end
					if instance.currentAttackTimes >= instance.maxAttackCount or tonumber(_ED.activity_pve_times[347]) == 0 then
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
							
							local bse = BattleStartEffect:new()
							bse:init(1)
							fwin:open(bse, fwin._windows)
						end
					end
					instance.currentNpcID = zstring.tonumber(instance.currentNpcID)
					_ED._current_scene_id = instance.currentSceneID
					_ED._scene_npc_id = instance.currentNpcID
					_ED._npc_difficulty_index = "1"
					app.load("client.battle.fight.FightEnum")

					local fightType = state_machine.excute("fight_get_current_fight_type", 0, nil)

                    local function responseBattleStartCallback(response)
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
							if _ED._scene_npc_id == nil or _ED._scene_npc_id == "" or tonumber(_ED._scene_npc_id) == 0 then
								_ED._scene_npc_id = _ED._scene_npc_copy_net_id
							end
							_ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, _enum_fight_type._fight_type_9, resultBuffer)
							local orderList = {}
							_ED._fightModule:initFightOrder(_ED.user_info, orderList)
							responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
						else
							_ED._current_scene_id = ""
							_ED._scene_npc_id = ""
							_ED._npc_difficulty_index = ""							
						end
					end
					_ED._scene_npc_copy_net_id = _ED._scene_npc_id
					protocol_command.battle_result_start.param_list = "".._enum_fight_type._fight_type_9.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
					NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
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
		
		state_machine.add(lpve_general_close_terminal)
		state_machine.add(lpve_general_window_close_terminal)
		state_machine.add(lpve_stage_bottom_sweep_over_update_draw_terminal)
		state_machine.add(lclick_battle_ten_terminal)
		state_machine.add(lclick_battle_ten_reset_terminal)
		state_machine.add(lclick_battle_ten_reset_update_draw_terminal)
		state_machine.add(lclick_go_fight_general_terminal)
		state_machine.add(lclick_open_formation_terminal)
        state_machine.init()
    end
    
    init_lpve_general_window_terminal()
end

function LPVEGeneral:init(_npcID, _sceneID, _bossFlag, _npcState)
	self.currentNpcID = _npcID
	
	self.currentSceneID = _sceneID
	self.currentSceneType = dms.int(dms["pve_scene"], self.currentSceneID, pve_scene.scene_type) 
	
	self.boss_flag = _bossFlag
	self.npcState = _npcState
end

--通用按钮点击事件添加
function LPVEGeneral:addTouchEventFunc(uiName, eventName, actionMode)
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

function LPVEGeneral:onUpdateDraw()
	local root = self.roots[1]
	
	if self.boss_flag == true then
		ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
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
	else
		ccui.Helper:seekWidgetByName(root, "Text_npc_name"):setString(dms.string(dms["npc"], self.currentNpcID, npc.npc_name))
	end
	
	-- 描述
	local npc_describe_text = ccui.Helper:seekWidgetByName(root, "Text_2_0")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local word_info = dms.element(dms["word_mould"], zstring.tonumber(dms.string(dms["npc"], self.currentNpcID, npc.sign_msg)))
        npc_describe_text:setString(word_info[3])
    else
		npc_describe_text:setString(dms.string(dms["npc"], self.currentNpcID, npc.sign_msg))
	end
	
	-- npc形象
	local npc_show_pad = ccui.Helper:seekWidgetByName(root, "Panel_1")
	npc_show_pad:removeAllChildren(true)
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
	
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. self.boss_display_index .. ".ExportJson")
	
	local armature = ccs.Armature:create("spirte_" .. self.boss_display_index)
	armature:getAnimation():playWithIndex(0)
	npc_show_pad:addChild(armature)
	
	armature:setPosition(cc.p(npc_show_pad:getContentSize().width/2, 0))
	
	local pIndex = dms.int(dms["npc"], self.currentNpcID, npc.npc_type)

	ccui.Helper:seekWidgetByName(root, "Panel_npc"):setBackGroundImage(string.format("images/ui/pve_sn/pve_tow_bg_%s.png", pIndex))
	ccui.Helper:seekWidgetByName(root, "Panel_npc"):setVisible(true)
	--显示体力
	self.attack_need_food = dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)
	self.cacheStrengthText:setString(self.attack_need_food)
	
	--猪脚等级
	local masterLv = tonumber(_ED.user_info.user_grade)
	
	--经验获得
	self.cacheExpText:setString(_string_piece_info[153] .. masterLv * 10 * dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)
	
	--银币获得
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
	
	local finalBattleTimes = totalAttackTimes - surplusAttackCount
	self.cacheBattleTenBtn:setVisible(finalBattleTimes > 0)
	self.cacheBattleTenResetBtn:setVisible(finalBattleTimes <= 0)
	
	ccui.Helper:seekWidgetByName(root, "Button_601"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Button_601_1"):setVisible(false)
	
	if (finalBattleTimes > 10) then finalBattleTimes = 10 end
	--更新扫荡上面的文字
	self.cacheBattleTimesText:setString(finalBattleTimes)
	
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
		ccui.Helper:seekWidgetByName(root, "Button_601"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_601_1"):setVisible(true)
	end
	
	if rewardID > 0 then
	-------------------------------------------------------------------
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
		
		-- if rewardMaxJade > 0 and rewardJade > 0 then
			-- self.cacheBattlePropText:setString(rewardJade .. "~" .. rewardMaxJade)
		-- end	
		
		if rewardMoney > 0 then
			local reward = ResourcesIconCell:createCell()
			reward:init(1, rewardMoney, -1)
			self.cacheTeasureDorpIcons[rewardTotal]:addChild(reward)
			rewardTotal = rewardTotal + 1
		end
		
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
end

function LPVEGeneral:onEnterTransitionFinish()
	local filePath = "duplicate/pve_duplicate_yx_tow.csb"
    local csbPVEnpc = csb.createNode(filePath)
    local root = csbPVEnpc:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVEnpc)
	local action = csb.createTimeline("duplicate/pve_duplicate_yx_tow.csb") 
    table.insert(self.actions, action )
    csbPVEnpc:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end	
        local str = frame:getEvent()
		if str == "window_open_over" then
		elseif str == "window_close_over" then
			state_machine.excute("lpve_general_window_close", 0, 0)
		end
    end)
	
	
	if action:IsAnimationInfoExists("window_open") == true then
		action:play("window_open", false)
	end
	
	-- 关闭
	self:addTouchEventFunc("Button_103", "lpve_general_window_close", true)
	
	-- 挑战
	self:addTouchEventFunc("Button_601", "lclick_go_fight_general", true)
	self:addTouchEventFunc("Button_601_1", "lclick_go_fight_general", true)
	
	--体力消耗
	local Text_2 = ccui.Helper:seekWidgetByName(root,"Text_2")
	local foot = dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)
	Text_2:setString(string.format("（每次消耗%d点体力）",foot))
	
	--首胜奖励
	local Text_4_0 = ccui.Helper:seekWidgetByName(root,"Text_4_0")
	local reward_table =  dms.element(dms["scene_reward"], dms.int(dms["npc"], self.currentNpcID, npc.first_reward))
	local baoshinumber = dms.atos(reward_table, scene_reward.reward_gold)
	Text_4_0:setString(baoshinumber)

	
	--经验获得
	local masterLv = tonumber(_ED.user_info.user_grade)
	local Text_4_0_0 = ccui.Helper:seekWidgetByName(root,"Text_4_0_0")
	local expnumber=_string_piece_info[153] .. masterLv * 10 * dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5
	Text_4_0_0:setString(expnumber)	
	--银币获得
	local Text_4_0_0_0 = ccui.Helper:seekWidgetByName(root, "Text_4_0_0_0")
	local money = dms.int(dms["grade_silver_reward"], masterLv, grade_silver_reward.silver)
	Text_4_0_0_0:setString(_string_piece_info[153] .. money* dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)/5)
	
	--掉落英魂
	local reward = ResourcesIconCell:createCell()
	reward:init(5, 0, -1)
	local yhPanel = ccui.Helper:seekWidgetByName(root, "Panel_30_1")
	yhPanel:removeAllChildren(true)
	yhPanel:addChild(reward)
	
	local rewardSoul = dms.atoi(reward_table, scene_reward.reward_gold)
	local shPanel = ccui.Helper:seekWidgetByName(root, "Panel_shenhun")
	local shText = ccui.Helper:seekWidgetByName(root, "Text_4_sh")
	shText:setString("")
	shPanel:setVisible(false)
	if rewardSoul > 0 then 
		shPanel:setVisible(true)
		local reward = ResourcesIconCell:createCell()
		reward:init(4, 0, -1)
		local yhPanel = ccui.Helper:seekWidgetByName(root, "Panel_30_1_0")
		yhPanel:removeAllChildren(true)
		yhPanel:addChild(reward)
		shText:setString("" .. rewardSoul)	
	end

	--英雄名字
	local Text_npc_name = ccui.Helper:seekWidgetByName(root,"Text_npc_name")
	local dmsname = dms.string(dms["npc"], self.currentNpcID, npc.npc_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(dmsname, "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        dmsname = name_info
	end
	--print(self.currentNpcID)
	Text_npc_name:setString(dmsname)
	
	--英魂奖励数目
	local Text_4_1_0_0_12 = ccui.Helper:seekWidgetByName(root,"Text_4_1_0_0_12")
	local table1 = dms.element(dms["scene_reward"], dms.int(dms["npc"], self.currentNpcID, npc.drop_library))
	local limitnumber = dms.atos(table1, scene_reward.reward_jade)
	local maxnumber = dms.atos(table1, scene_reward.reward_jade_max)
	--print("---",limitnumber,maxnumber)
	Text_4_1_0_0_12:setString(string.format("%s - %s",limitnumber,maxnumber))

	-- 神魂数量
	local Text_4_sh = ccui.Helper:seekWidgetByName(root,"Text_4_sh")
	local table1 = dms.element(dms["scene_reward"], dms.int(dms["npc"], self.currentNpcID, npc.drop_library))
	local limitnumber = dms.atos(table1, scene_reward.reward_soul)
	local maxnumber = dms.atos(table1, scene_reward.reward_soul_max)
	--print("---",limitnumber,maxnumber)
	Text_4_sh:setString(string.format("%s - %s",limitnumber,maxnumber))
	
	--剧情
	local Text_2_0 = ccui.Helper:seekWidgetByName(root,"Text_2_0")
	local _sign_msg = dms.string(dms["npc"], self.currentNpcID, npc.sign_msg)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local word_info = dms.element(dms["word_mould"], zstring.tonumber(_sign_msg))
        _sign_msg = word_info[3]
    end
	Text_2_0:setString(_sign_msg)

	--挑战消耗体力
	self.attack_need_food = dms.int(dms["npc"], self.currentNpcID, npc.attack_need_food)

	--挑战次数 
	local totalAttackTimes = dms.int(dms["npc"], self.currentNpcID, npc.daily_attack_count)
	local surplusAttackCount = _ED.npc_current_attack_count[tonumber(self.currentNpcID)]
	--self.cacheFightTimesText:setString((totalAttackTimes - surplusAttackCount) .. "/" .. totalAttackTimes)
	self.maxAttackCount = tonumber(totalAttackTimes)
	self.currentAttackTimes = tonumber(surplusAttackCount)
	-- print("----------------self.currentNpcID", self.currentNpcID)
	-- print("----------------surplusAttackCount",surplusAttackCount)
	-- print("----------------totalAttackTimes",totalAttackTimes)
	--self.cacheFightTimesText = ccui.Helper:seekWidgetByName(root, "Text_tzcishu_1")
	
	--挑战十次按钮
	--self.cacheBattleTenBtn = self:addTouchEventFunc("Button_501", "lclick_battle_ten", true)
	--self.cacheBattleTenResetBtn = self:addTouchEventFunc("Button_601_0", "lclick_battle_ten_reset", true)
	--self.cacheBattleTimesText = ccui.Helper:seekWidgetByName(root, "Text_10")
	-- self.cacheBattlePropText = ccui.Helper:seekWidgetByName(root, "Text_18_18")
	
	-- if self.currentSceneType == 9 then
		-- ccui.Helper:seekWidgetByName(root, "Panel_ptfb"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Panel_mjfb"):setVisible(true)
		-- self.cacheGoGoGoBtn = self:addTouchEventFunc("Button_chuzhan_4_4", "click_go_fight", true)
	-- end
	
	--添加布阵按钮事件
	self:addTouchEventFunc("Button_buzhen_0", "lclick_open_formation", true)
	self.canClickBtn = true
	--self:onUpdateDraw()
end

function LPVEGeneral:onExit()
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("sprite/spirte_" .. self.boss_display_index .. ".ExportJson")
	
	state_machine.remove("lpve_general_close")
	state_machine.remove("lpve_general_window_close")
	state_machine.remove("lpve_stage_bottom_sweep_over_update_draw")
	state_machine.remove("lclick_battle_ten")
	state_machine.remove("lclick_battle_ten_reset")
	state_machine.remove("lclick_battle_ten_reset_update_draw")
	state_machine.remove("lclick_go_fight_general")
	state_machine.remove("lclick_open_formation")
end
