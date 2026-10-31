-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物副本结束奖励结算界面
-------------------------------------------------------------------------------------------------------
BattleFieldFightReward = class("BattleFieldFightRewardClass", Window)

function BattleFieldFightReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.rewardList = nil
	app.load("client.battle.BattleLevelUp")
end	

function BattleFieldFightReward:onEnterTransitionFinish()

	local csbvictory = csb.createNode("battle/victory_in_battle_2.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	local bTouch = false
	local action = csb.createTimeline("battle/victory_in_battle_2.csb")
	
	self.rewardList = getSceneReward(38)
    csbvictory:runAction(action)
	local reward = getSceneReward(65)
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	local quality = dms.int(dms["ship_mould"],_ED._attack_battle_field_template,ship_mould.ship_type) + 1
	nameText:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	nameText:setString(_ED._attack_battle_field_name)
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Text_7 = ccui.Helper:seekWidgetByName(root, "Text_7")
	Text_5:setString("0")
	Text_7:setString("0")
	for k,v in pairs(reward.show_reward_list) do
		if zstring.tonumber(v.prop_type) == 33 then 
			Text_5:setString(""..v.item_value)
		end
		if zstring.tonumber(v.prop_type) == 6 then 
			Text_7:setString(""..v.item_value)
		end
	end
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_win_over" then
		elseif str == "over" then
            bTouch = true
		elseif str == "show" then
	
         end
    end)

	playEffect(formatMusicFile("effect", 9996))
	
	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended and bTouch == true then
			
			fwin:close(instance)
			fwin:close(fwin:find("BattleSceneClass"))
			fwin:removeAll()
			app.load("client.home.Menu")
			fwin:open(Menu:new(), fwin._taskbar)
			app.load("client.campaign.battlefield.BattleField")
			state_machine.excute("battle_field_window_open",0,"")
			
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_2"):addTouchEventListener(backPlotScene)
	local win_show_panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local win_show_armature = win_show_panel:getChildByName("ArmatureNode_2")

	draw.initArmature(win_show_armature, nil, -1, 0, 1)
	csb.animationChangeToAction(win_show_armature, 0, 1, false)
end

function BattleFieldFightReward:init(fight_type)
	self._fight_type = fight_type
end

function BattleFieldFightReward:onExit()

end
-- END
-- ----------------------------------------------------------------------------------------------------