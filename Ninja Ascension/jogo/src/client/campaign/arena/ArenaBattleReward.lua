-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束奖励结算界面(竞技场)
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ArenaBattleReward = class("ArenaBattleRewardClass", Window)

function ArenaBattleReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.rewardList = nil
	app.load("client.battle.BattleLevelUp")
end	

function ArenaBattleReward:onEnterTransitionFinish()
	
	local csbvictory = csb.createNode("campaign/ArenaStorage/ArenaStorage_victory.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	local bTouch = false
	local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_victory.csb")
	--print("对手名字Arena.RoleName",Arena.RoleName)
	-- 获取13场景奖励
	self.rewardList = getSceneReward(13)
	
	-- 检查奖励是否有元宝
	local paimingreward = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		_ED.arena_gem_reward_number = getRewardValueWithType(self.rewardList, 2)
		paimingreward = getRewardValueWithType(self.rewardList, 14)
	else
		_ED.arena_gem_reward_number = getRewardValueWithType(self.rewardList, 2)
	end
	csbvictory:runAction(action)
	local function window_open_action_play()
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
			action:play("window_open", false)
		else	
			action:gotoFrameAndPlay(0, action:getDuration(), false)
		end	
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end
			
			local str = frame:getEvent()
			--> print("zzzzz-----------------------", str)
			if str == "over" then
				bTouch = true
				ccui.Helper:seekWidgetByName(root, "Text_15_3"):setString(getRewardValueWithType(self.rewardList, 3))
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					local newPaiming=_ED.arena_user_rank-paimingreward
					ccui.Helper:seekWidgetByName(root, "Text_are_vic_pingjia_0_1"):setString(_ED.arena_user_rank)
					ccui.Helper:seekWidgetByName(root, "Text_are_vic_pingjia_0_1_0"):setString(newPaiming)
					ccui.Helper:seekWidgetByName(root,"Text_are_vic_pingjia_0"):setString(Arena.RoleName)
					Arena.RoleName = nil
				end
			elseif str == "show" then
				local expLoadingButton = ccui.Helper:seekWidgetByName(root, "LoadingBar_1_2")
				local expCount = tonumber(BattleSceneClass._lastExp)/tonumber(BattleSceneClass._lastNeedExp)*100
				expLoadingButton:setPercent(expCount)
				--> print("exp", BattleSceneClass._lastExp, BattleSceneClass._lastNeedExp)
				local rewardExpCount = tonumber(getRewardValueWithType(self.rewardList, 8))/tonumber(BattleSceneClass._lastNeedExp)*100
				local isLevelup = false
				local levelLabel = ccui.Helper:seekWidgetByName(root, "Text_8_14")
				local function update(delta)
					local sc = 3
					if (100-expCount)< 3 then
						sc = 100-expCount
					end
					if rewardExpCount < sc then
						sc = rewardExpCount
					end
					rewardExpCount = rewardExpCount - sc
					
					if rewardExpCount<sc then
						expCount = tonumber(_ED.user_info.user_experience)/tonumber(BattleSceneClass._lastNeedExp)*100
					else
						expCount = expCount + sc
					end
					if expCount >= 100 then
						isLevelup = true
						expCount = 0
						rewardExpCount = rewardExpCount * tonumber(BattleSceneClass._lastNeedExp) / tonumber(_ED.user_info.user_grade_need_experience)
					end
					
					if tonumber(_ED.user_info.user_experience) == 0 and rewardExpCount > 0 then
						isLevelup = true
					end
					if (tonumber(BattleSceneClass._lastExp)+getRewardValueWithType(self.rewardList, 8))/tonumber(BattleSceneClass._lastNeedExp)*100 >= 100 then
						isLevelup = true
					end
					
					if rewardExpCount <= 0 then
						self:unscheduleUpdate()
						if isLevelup == true then
							--> print("open BattleLevelUp window!!!")
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								if fwin:find("BattleLevelUpClass") == nil then
									fwin:open(BattleLevelUp:new(), fwin._view)
									if verifySupportLanguage(_lua_release_language_en) == true then
										levelLabel:setString(_string_piece_info[6].._ED.user_info.user_grade)
									else
										levelLabel:setString(_ED.user_info.user_grade.._string_piece_info[6])
									end
								end
							else
								fwin:open(BattleLevelUp:new(), fwin._view) 
								if verifySupportLanguage(_lua_release_language_en) == true then
									levelLabel:setString(_string_piece_info[6].._ED.user_info.user_grade)
								else
									levelLabel:setString(_ED.user_info.user_grade.._string_piece_info[6])
								end
							end
						end

					end
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						if _ED.user_is_level_up == true then
							if fwin:find("BattleLevelUpClass") == nil then
								fwin:open(BattleLevelUp:new(), fwin._view)
								if verifySupportLanguage(_lua_release_language_en) == true then
									levelLabel:setString(_string_piece_info[6].._ED.user_info.user_grade)
								else
									levelLabel:setString(_ED.user_info.user_grade.._string_piece_info[6])
								end
							end
						end
					end
					if csbvictory ~= nil then
						expLoadingButton:setPercent(expCount)
					end
				end
				self:unscheduleUpdate()
				self:scheduleUpdateWithPriorityLua(update, 0)
					
				local function onNodeEvent(tag)
					if tag == "exit" then
						self:unscheduleUpdate()
					end
				end

				self:registerScriptHandler(onNodeEvent)
			elseif str == "battle_ganglv_1_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.1))
				end
			elseif str == "battle_ganglv_2_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.3))
				end
			elseif str == "battle_ganglv_3_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.5))
				end
			elseif str == "battle_ganglv_4_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.7))
				end
			elseif str == "battle_ganglv_5_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.9))
				end
			elseif str == "battle_ganglv_6_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*1))
				end
			elseif str == "battle_ganglv_7_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*1))
				end
			elseif str == "battle_exp_1_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7_12"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.1))
				end
			elseif str == "battle_exp_2_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7_12"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.3))
				end
			elseif str == "battle_exp_3_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7_12"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.5))
				end
			elseif str == "battle_exp_4_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7_12"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.7))
				end
			elseif str == "battle_exp_5_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7_12"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.9))
				end
			elseif str == "battle_exp_6_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7_12"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*1))
				end
			elseif str == "battle_exp_7_over" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_7_12"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*1))
				end
			end
		end)
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		local function overAnimationStartFunc()
			local function changeActionCallback(armatureBack)
				window_open_action_play()
			end		
			ccui.Helper:seekWidgetByName(root, "Panel_window_open"):setVisible(true)
			local Panel_nan_open = ccui.Helper:seekWidgetByName(root, "Panel_window_open")
			Panel_nan_open:setVisible(true)
			local ArmatureNode_1 = Panel_nan_open:getChildByName("ArmatureNode_2_2")
			draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
			ArmatureNode_1._invoke = nil
			ArmatureNode_1:getAnimation():playWithIndex(0, 0, 0)
			ArmatureNode_1._invoke = changeActionCallback
			-- window_open_action_play()
		end
		action:play("window_open_win", false)
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end

			local str = frame:getEvent()
			if str == "window_open_win_over" then
				overAnimationStartFunc()
			end
		end)	
	else
		window_open_action_play()
	end
	playEffect(formatMusicFile("effect", 9996))

	--翻牌
	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended and bTouch == true then
			fwin:close(self)
			-- app.load("client.battle.BattleWinCardLottery")
			-- local battleWinCardLottery = BattleWinCardLottery:new()
			-- --battleWinCardLottery:init()
			-- fwin:open(battleWinCardLottery, fwin._view) 
			
			app.load("client.battle.BattleWinCardLottery")
			local battleWinCardLottery = BattleWinCardLottery:new()
			--> print("battleWinCardLottery----------------",self._fight_type ,_enum_fight_type._fight_type_11)
			-- 取self._fight_type 全是nil.直接取_enum_fight_type._fight_type_11了
			battleWinCardLottery:init(_enum_fight_type._fight_type_11)
			fwin:open(battleWinCardLottery, fwin._view) 
		end
	end
	
	ccui.Helper:seekWidgetByName(root, "Panel_2"):addTouchEventListener(backPlotScene)
	
	local expCount = tonumber(BattleSceneClass._lastExp)/tonumber(BattleSceneClass._lastNeedExp)*100
	ccui.Helper:seekWidgetByName(root, "LoadingBar_1_2"):setPercent(expCount)
	
	local levelLabel = ccui.Helper:seekWidgetByName(root, "Text_8_14")
	if verifySupportLanguage(_lua_release_language_en) == true then
		if tonumber(BattleSceneClass._lastNeedExp) ~= tonumber(_ED.user_info.user_grade_need_experience) then
			levelLabel:setString(_string_piece_info[6]..(tonumber(_ED.user_info.user_grade)-1))
		else
			levelLabel:setString(_string_piece_info[6].._ED.user_info.user_grade)
		end
	else
		if tonumber(BattleSceneClass._lastNeedExp) ~= tonumber(_ED.user_info.user_grade_need_experience) then
			levelLabel:setString(""..(tonumber(_ED.user_info.user_grade)-1).._string_piece_info[6])
		else
			levelLabel:setString(_ED.user_info.user_grade.._string_piece_info[6])
		end
	end
	-- ----------------------------------------------
end

function ArenaBattleReward:init(_fight_type)
	--> print("ArenaBattleReward:init(_fight_type)----------------",_fight_type )
	self._fight_type = _fight_type
end

function ArenaBattleReward:onExit()

end
-- END
-- ----------------------------------------------------------------------------------------------------