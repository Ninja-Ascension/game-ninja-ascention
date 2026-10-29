-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束奖励结算界面(抢夺) --战斗类型 10
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PlunderBattleReward = class("PlunderBattleRewardClass", Window)

function PlunderBattleReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.rewardList = nil
	app.load("client.battle.BattleLevelUp")
	app.load("client.cells.prop.model_prop_icon_cell")
end	

function PlunderBattleReward:showReward()
----(2)             show_reward_list        :       table
---------(3)                1       :       table
-------------(4)            item_value      :       500
-------------(4)            prop_type       :       1
-------------(4)            prop_item       :       -1
---------(3)                2       :       table
-------------(4)            item_value      :       10
-------------(4)            prop_type       :       8
-------------(4)            prop_item       :       -1
---------(3)                3       :       table
-------------(4)            item_value      :       1
-------------(4)            prop_type       :       6
-------------(4)            prop_item       :       195
----(2)             show_reward_type        :       2
----(2)             show_reward_item_count  :       3
	
	local root = self.roots[1]

	-- Panel_qd_wu 显示没有获得碎片
	local Panel_qd_wu = ccui.Helper:seekWidgetByName(root, "Panel_qd_wu")
	
	-- Panel_qd_hd 显示获得碎片
	local Panel_qd_hd = ccui.Helper:seekWidgetByName(root, "Panel_qd_hd")
	
	-- Text_qd_pr 获得物品名
	local Text_qd_pr = ccui.Helper:seekWidgetByName(root, "Text_qd_pr")
	
	-- Panel_qd_pr_00 物品icon
	local Panel_qd_pr_00 = ccui.Helper:seekWidgetByName(root, "Panel_qd_pr_00")

	local patch = nil
	if self.rewardList ~= nil then
		patch = getRewardItemWithType(self.rewardList, 6)
	end
	
	
	Panel_qd_wu:setVisible(false)
	Panel_qd_hd:setVisible(false)
	if patch == nil then
		-- 没抢到
		Panel_qd_wu:setVisible(true)
	else
		-- 抢到了
		--找道具模板要数据
		Panel_qd_hd:setVisible(true)
		local propName =  dms.string(dms["prop_mould"], tonumber(patch.prop_item), prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        propName = setThePropsIcon(tonumber(patch.prop_item))[2]
		end
		Text_qd_pr:setString(propName)
		local quality		= dms.int(dms["prop_mould"], tonumber(patch.prop_item), prop_mould.prop_quality)+1
		Text_qd_pr:setColor(self:getColor(quality))
		
		local iconCell = ModelPropIconCell:createCell()
		local config = iconCell:createConfig()
		config.mouldId = tonumber(patch.prop_item)
		config.isDebris = true		
		config.count = 1

		iconCell:init(config)
		Panel_qd_pr_00:addChild(iconCell)
		Panel_qd_pr_00:setSwallowTouches(false)
		Panel_qd_pr_00:setTouchEnabled(false)
		
		
		-----------记录当前场景缓存数据
		app.load("client.utils.scene.SceneCacheData")
		local cacheName = SceneCacheNameEnum.PLUNDER
		local cacheData = SceneCacheData.read(cacheName)
		if nil == cacheData then
			cacheData = SceneCacheData.getInitExample(cacheName)
		end
		cacheData.rewardMouldId = tonumber(patch.prop_item)
	
		SceneCacheData.write(cacheName, cacheData, "showReward")

	end
end


function PlunderBattleReward:getColor(i)
	return cc.c3b(tipStringInfo_quality_color_Type[i][1],
		tipStringInfo_quality_color_Type[i][2],
		tipStringInfo_quality_color_Type[i][3])

end

function PlunderBattleReward:onEnterTransitionFinish()
	
	local csbvictory = csb.createNode("campaign/Snatch/snatch_victory.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	local bTouch = false
	local action = csb.createTimeline("campaign/Snatch/snatch_victory.csb")
	
	-- 获取2场景奖励
	self.rewardList = getSceneReward(2)
	
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
			if str == "over" then
				bTouch = true
				self:showReward()
			elseif str == "show" then
				local expLoadingButton = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
				local expCount = tonumber(BattleSceneClass._lastExp)/tonumber(BattleSceneClass._lastNeedExp)*100
				expLoadingButton:setPercent(expCount)
				--> print("exp", BattleSceneClass._lastExp, BattleSceneClass._lastNeedExp)
				local rewardExpCount = tonumber(getRewardValueWithType(self.rewardList, 8))/tonumber(BattleSceneClass._lastNeedExp)*100
				local isLevelup = false
				local levelLabel = ccui.Helper:seekWidgetByName(root, "Text_14")
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
							
							fwin:open(BattleLevelUp:new(), fwin._view) 
							if verifySupportLanguage(_lua_release_language_en) == true then
								levelLabel:setString(_string_piece_info[6].._ED.user_info.user_grade)
							else
								levelLabel:setString(_ED.user_info.user_grade.._string_piece_info[6])
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
			elseif str == "sn_up_11" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_gl_4"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.1))
				end
			elseif str == "sn_up_12" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_gl_4"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.3))
				end
			elseif str == "sn_up_13" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_gl_4"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.5))
				end
			elseif str == "sn_up_14" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_gl_4"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.7))
				end
			elseif str == "sn_up_15" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_gl_4"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*0.9))
				end
			elseif str == "sn_up_16" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_gl_4"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*1))
				end
			elseif str == "sn_up_17" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_gl_4"):setString(math.floor(getRewardValueWithType(self.rewardList, 1)*1))
				end
			elseif str == "sn_up_21" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_exp_5"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.1))
				end
			elseif str == "sn_up_22" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_exp_5"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.3))
				end
			elseif str == "sn_up_23" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_exp_5"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.5))
				end
			elseif str == "sn_up_24" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_exp_5"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.7))
				end
			elseif str == "sn_up_25" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_exp_5"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*0.9))
				end
			elseif str == "sn_up_26" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_exp_5"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*1))
				end
			elseif str == "sn_up_27" then
				if self.rewardList ~= nil then
					ccui.Helper:seekWidgetByName(root, "Text_exp_5"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 8)*1))
				end
			end
		end)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		local function overAnimationStartFunc()
			local function changeActionCallback(armatureBack)
				window_open_action_play()
			end		
			ccui.Helper:seekWidgetByName(root, "Panel_8"):setVisible(true)
			local Panel_nan_open = ccui.Helper:seekWidgetByName(root, "Panel_8")
			Panel_nan_open:setVisible(true)
			local ArmatureNode_1 = Panel_nan_open:getChildByName("ArmatureNode_2")
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
		if eventType == ccui.TouchEventType.ended then
		--if eventType == ccui.TouchEventType.ended and bTouch == true then
			fwin:close(self)
			-- app.load("client.battle.BattleWinCardLottery")
			-- local battleWinCardLottery = BattleWinCardLottery:new()
			-- --battleWinCardLottery:init()
			-- fwin:open(battleWinCardLottery, fwin._view) 
			
			app.load("client.battle.BattleWinCardLottery")
			local battleWinCardLottery = BattleWinCardLottery:new()
			--> print("battleWinCardLottery----------------",self._fight_type ,_enum_fight_type._fight_type_11)
			-- 取self._fight_type 全是nil.直接取_enum_fight_type._fight_type_11了
			battleWinCardLottery:init(_enum_fight_type._fight_type_10)
			fwin:open(battleWinCardLottery, fwin._view) 
			sender._one_called = true
		end
	end
	
	ccui.Helper:seekWidgetByName(root, "Panel_qdjs").callback = backPlotScene
	ccui.Helper:seekWidgetByName(root, "Panel_qdjs"):addTouchEventListener(backPlotScene)
	
	local expCount = tonumber(BattleSceneClass._lastExp)/tonumber(BattleSceneClass._lastNeedExp)*100
	ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent(expCount)
	
	local levelLabel = ccui.Helper:seekWidgetByName(root, "Text_14")
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

function PlunderBattleReward:init(_fight_type)
	--> print("PlunderBattleReward:init(_fight_type)----------------",_fight_type )
	self._fight_type = _fight_type
end

function PlunderBattleReward:onExit()

end
-- END
-- ----------------------------------------------------------------------------------------------------


	-- --用户免战cd时间
	-- _avoidFightTime = "",
	-- --抢夺战斗奖励数量
	-- _snatch_fight_reward_count = 0,
	-- --抢夺战斗奖励信息
	-- _snatch_fight_reward = {
		-- {
			-- fight_reward = "",	--奖励类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备) 
			-- fight_reward_name = "",	--奖励名称 
			-- fight_reward_count = "",--奖励数量 
			-- fight_rewar_icon = "",--奖励图片
			-- fight_reward_quality = "",--奖励品质
			-- fight_reward_extraction_state = "",--抽取状态(0:未抽中1:抽中)
		-- },
	-- },