-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双 战斗结束奖励结算界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TrialTowerBattleReward = class("TrialTowerBattleRewardClass", Window)

function TrialTowerBattleReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.rewardList = nil
	app.load("client.battle.BattleLevelUp")
end	

function TrialTowerBattleReward:onEnterTransitionFinish()
	-- res\cocostudio\campaign\TrialTower\victory_in_battle_1.csb

	local csbvictory = csb.createNode("campaign/TrialTower/victory_in_battle_1.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	local bTouch = false
	local action = csb.createTimeline("campaign/TrialTower/victory_in_battle_1.csb")
	
	self.rewardList = getSceneReward(38)
	
    csbvictory:runAction(action)
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		action:play("window_open_win", false)
			local Panel_window_open = ccui.Helper:seekWidgetByName(root, "Panel_window_open")
			local ArmatureNode_open=Panel_window_open:getChildByName("ArmatureNode_open")
			draw.initArmature(ArmatureNode_open, nil, -1, 0, 1)
			ArmatureNode_open:getAnimation():playWithIndex(0, 0, 0)
			ArmatureNode_open:setVisible(false)
			
			ArmatureNode_open._invoke = function(armatureBack)
				armatureBack:setVisible(false)
				action:play("window_open", false)
				armatureBack._invoke=nil
			end
	else
		action:gotoFrameAndPlay(0, action:getDuration(), false)
    end
	action:setFrameEventCallFunc(function (frame)
	
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_win_over" then
		   if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local Panel_window_open = ccui.Helper:seekWidgetByName(root, "Panel_window_open")
				local ArmatureNode_open=Panel_window_open:getChildByName("ArmatureNode_open")
				ArmatureNode_open:setVisible(true)
				csb.animationChangeToAction(ArmatureNode_open, 0, 0, nil)
		   end
		elseif str == "over" then
            bTouch = true
			
			-- 显示暴击字样
			
			-- 是否显示双倍
			
			-- 是否显示 银币
			
			-- 是否显示 威名
			local isDouble 	= _ED.three_kingdoms_view_multiplying[1]
			local silver 	= _ED.three_kingdoms_view_multiplying[2]
			local honour 	= _ED.three_kingdoms_view_multiplying[3]
			
			if nil ~= isDouble and isDouble == 1 then 
				ccui.Helper:seekWidgetByName(root, "baoji_3"):setString(tipStringInfo_trialTower_multiplying[4])
			end
			
			
			if nil ~= silver and silver > 0 then 
				ccui.Helper:seekWidgetByName(root, "baoji_2"):setString(tipStringInfo_trialTower_multiplying[silver])
				ccui.Helper:seekWidgetByName(root, "baoji_2"):setColor(cc.c3b(
					tipStringInfo_trialTower_multiplying_color[silver][1], 
					tipStringInfo_trialTower_multiplying_color[silver][2], 
					tipStringInfo_trialTower_multiplying_color[silver][3])
				)
			
			end
			
			if nil ~= honour and honour > 0 then 
				ccui.Helper:seekWidgetByName(root, "baoji_1"):setString(tipStringInfo_trialTower_multiplying[honour])
				ccui.Helper:seekWidgetByName(root, "baoji_1"):setColor(cc.c3b(
					tipStringInfo_trialTower_multiplying_color[honour][1], 
					tipStringInfo_trialTower_multiplying_color[honour][2], 
					tipStringInfo_trialTower_multiplying_color[honour][3])
				)
			
			end
			
			
		elseif str == "show" then
			
		elseif str == "battle_ganglv_1_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 18)*0.1))
			end
		elseif str == "battle_ganglv_2_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 18)*0.3))
			end
		elseif str == "battle_ganglv_3_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 18)*0.5))
			end
		elseif str == "battle_ganglv_4_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 18)*0.7))
			end
		elseif str == "battle_ganglv_5_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 18)*0.9))
			end
		elseif str == "battle_ganglv_6_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 18)*1))
			end
		elseif str == "battle_ganglv_7_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5"):setString(math.floor(getRewardValueWithType(self.rewardList, 18)*1))
			end
		elseif str == "battle_exp_1_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 1)*0.1))
			end
		elseif str == "battle_exp_2_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 1)*0.3))
			end
		elseif str == "battle_exp_3_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 1)*0.5))
			end
		elseif str == "battle_exp_4_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 1)*0.7))
			end
		elseif str == "battle_exp_5_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 1)*0.9))
			end
		elseif str == "battle_exp_6_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 1)*1))
			end
		elseif str == "battle_exp_7_over" then
			if self.rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7"):setString(""..math.floor(getRewardValueWithType(self.rewardList, 1)*1))
			end
        end
    end)
	
	local sceneData = dms.element(dms["pve_scene"],_ED._current_scene_id)
	if (dms.atoi(sceneData, pve_scene.scene_type)==0) then
		_ED._fight_win_count = _ED._fight_win_count+1
	end
	
	playEffect(formatMusicFile("effect", 9996))
	
	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended and bTouch == true then
			
			fwin:close(instance)
			fwin:close(fwin:find("BattleSceneClass"))
			fwin:removeAll()
			app.load("client.home.Menu")
			fwin:open(Menu:new(), fwin._taskbar)
			
			-- state_machine.excute("menu_manager", 0, 
				-- {
					-- _datas = {
						-- terminal_name = "menu_manager", 	
						-- next_terminal_name = "menu_show_campaign", 
						-- current_button_name = "Button_activity",
						-- but_image = "Image_activity", 		
						-- terminal_state = 0, 
						-- isPressedActionEnabled = true
					-- }
				-- }
			-- )
			local trialTower = TrialTower:new()
			trialTower:init(3) -- 示意进入时的状态 
			fwin:open(trialTower, fwin._view)	
			
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_2"):addTouchEventListener(backPlotScene)
	

	--找过关条件
	local layerCount = tonumber(_ED.three_kingdoms_view.current_floor)			-- 第几层
	local currentIndex = tonumber(_ED.three_kingdoms_view.current_npc_pos)		--当前挑战位置
	
	if currentIndex == 0 then
		currentIndex = 2 
		layerCount = layerCount -1
	else
		currentIndex = currentIndex - 1 
	end

	local npcList = dms.string(dms["three_kingdoms_config"], tonumber(layerCount), three_kingdoms_config.npc_id)
	local datas = zstring.split(npcList , ",")  	
	local npcMID = tonumber(datas[currentIndex+1])
	local achievementIndex = dms.string(dms["npc"], npcMID, npc.get_star_condition)	--通关条件-从npc取找成就模板
	local GuanqiaCondition = dms.string(dms["achievement_mould"], achievementIndex, achievement_mould.achievement_describe)
	ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(tipStringInfo_trialTower[14]..GuanqiaCondition)
	
end


function TrialTowerBattleReward:init(fight_type)
	self._fight_type = fight_type
end

function TrialTowerBattleReward:onExit()

end
-- END
-- ----------------------------------------------------------------------------------------------------