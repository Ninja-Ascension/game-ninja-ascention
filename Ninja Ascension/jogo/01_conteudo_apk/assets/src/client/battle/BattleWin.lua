-- ----------------------------------------------------------------------------------------------------
-- 说明：抢夺胜利
-- 创建时间2014-03-14 23:18
-- 作者：李文鋆
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
require "script/transformers/activity/plunder/PlunderSnatchList"

local BattleVictoryAwardsClass = CreateClass("BattleVictoryAwardsClass", LuaClass)
BattleVictoryAwardsClass.__index = BattleVictoryAwardsClass
BattleVictoryAwardsClass._uiLayer= nil
BattleVictoryAwardsClass._widget = nil
BattleVictoryAwardsClass._layer = nil
BattleVictoryAwardsClass._rewardCell = {}
BattleVictoryAwardsClass._cellInfo = nil
BattleVictoryAwardsClass._isGet = false
BattleVictoryAwardsClass._isAcquire = false



function BattleVictoryAwardsClass:init()

	BattleVictoryAwardsClass._uiLayer = TouchGroup:create()
	self:addChild(BattleVictoryAwardsClass._uiLayer)
	
	local size = draw.size()
	
	BattleVictoryAwardsClass._widget = GUIReader:shareReader():widgetFromJsonFile("interface/battle_victory_awards.json")
	BattleVictoryAwardsClass._uiLayer:addWidget(BattleVictoryAwardsClass._widget)

	
	local action1 = ActionManager:shareManager():getActionByName("battle_victory_awards.json","Animation0")
	action1:play()
	action1:setLoop(true)
	
	local action2 = ActionManager:shareManager():getActionByName("battle_victory_awards.json","Animation1")
	action2:play()
	action2:setLoop(false)
	
	local rewardList = nil
	if BattleVictoryAwardsClass.battle_init_type == 10 then
		rewardList = getSceneReward(2)
	elseif BattleVictoryAwardsClass.battle_init_type == 11 then
		rewardList = getSceneReward(13)
	elseif BattleVictoryAwardsClass.battle_init_type == 12 then
		rewardList = getSceneReward(20)
		
	end
	---------------------------------------------------------------------------------------------------------------
	--关闭按钮
	local function returnCallback(sender,eventType)
		if eventType == ccs.TouchEventType.ended then
			if BattleVictoryAwardsClass._isGet == true then
				--self:removeFromParentAndCleanup(true)
				if BattleVictoryAwardsClass.battle_init_type == 10 then
					LuaClasses["MainWindowClass"].closeWindow(LuaClasses["BattleVictoryAwardsClass"])
					LuaClasses["MainWindowClass"].Draw()
					if BattleVictoryAwardsClass._isAcquire == true then
						LuaClasses["MainWindowClass"].openWindow(LuaClasses["PlunderStorageClass"])
						-- LuaClasses["PlunderStorageClass"].gotoPage()
					else
						--LuaClasses["MainWindowClass"].openWindow(LuaClasses["PlunderStorageClass"])
						--LuaClasses["PlunderStorageClass"].gotoPage()
						--LuaClasses["PlunderStorageClass"]._layer:setVisible(false)
						LuaClasses["MainWindowClass"].openWindow(LuaClasses["PlunderSnatchListClass"])
					end
				elseif BattleVictoryAwardsClass.battle_init_type == 11 then
					LuaClasses["MainWindowClass"].closeWindow(LuaClasses["PVpLoseClass"])
					LuaClasses["MainWindowClass"].Draw()
					require "script/transformers/activity/Arena/ArenaStorage"
					LuaClasses["MainWindowClass"].openWindow(LuaClasses["ArenaStorageClass"])
					local str = ""
					if getRewardValueWithType(rewardList, 14) == nil or getRewardValueWithType(rewardList, 14) == "0" then
						str = str .. _string_piece_info[128].. "\r\n"
					else
						str = str .. _string_piece_info[129].. getRewardValueWithType(rewardList, 14) .. "\r\n"
					end
					str = str .. _string_piece_info[27] .. getRewardValueWithType(rewardList, 3).._All_tip_string_info._reputation
					TipDlg.drawTextDailog(str)
				elseif BattleVictoryAwardsClass.battle_init_type == 12 then
					--LuaClasses["MainWindowClass"].closeWindow(LuaClasses["PVpLoseClass"])
					LuaClasses["MainWindowClass"].changeToWindow()
					LuaClasses["MainWindowClass"].Draw()
					require "script/transformers/activity/duel/DuelStorage"
					LuaClasses["MainWindowClass"].openWindow(LuaClasses["DuelStorageClass"])
					local str = ""
					
					
					if LuaClasses["DuelStorageClass"]._FightType == true then
						str = str .. _string_piece_info[130] .. getRewardValueWithType(rewardList, 16) .. _string_piece_info[131]
					else
						str = str .. _string_piece_info[132] .. getRewardValueWithType(rewardList, 16) .. _string_piece_info[131]
					end
					
					TipDlg.drawTextDailog(str)
				elseif PVpLoseClass.battle_init_type == 13 then
					getSceneReward(20)
					
					require "script/transformers/play/union/UnionMembers"
					LuaClasses["MainWindowClass"].changeToWindow()
					LuaClasses["MainWindowClass"].openWindow(LuaClasses["UnionMembersClass"])
				elseif PVpLoseClass.battle_init_type == 14 then
					getSceneReward(20)
					
					require "script/jtx/play/mine/MineManager"
					draw.clear()
					LuaClasses["MainWindowClass"].resetData()
					require "script/jtx/play/mine/MineManager"
					fwin:open(LuaClasses["MineManagerClass"]:create()) 
				end
			end
		elseif eventType == ccs.TouchEventType.began then
			playEffect(formatMusicFile("button", 2))		--加入按钮音效	
		end
	end
	local returnButton = tolua.cast(BattleVictoryAwardsClass._uiLayer:getWidgetByName("Button_determine"),"Button")
	returnButton:addTouchEventListener(returnCallback)
	--END	
	---------------------------------------------------------------------------------------------------------------	
	
	---------------------------------------------------------------------------------------------------------------
	--绘制
	--我方名字
	draw.label(BattleVictoryAwardsClass._uiLayer, "Label_name_1", _ED._attack_people_name)
	--对方名称
	draw.label(BattleVictoryAwardsClass._uiLayer, "Label_name0_1", _ED._defense_people_name)
	--我方战力
	draw.label(BattleVictoryAwardsClass._uiLayer,"Label_3862_1",_ED._attack_people_fight_capacity)
	--对方战力
	draw.label(BattleVictoryAwardsClass._uiLayer,"Label_3862_0_1",_ED._defense_people_fight_capacity)
	--奖励金钱
	draw.label(BattleVictoryAwardsClass._uiLayer,"Label_funds_value_1",getRewardValueWithType(rewardList, 1))
	--奖励经验
	draw.label(BattleVictoryAwardsClass._uiLayer,"Label_exp_value_1",getRewardValueWithType(rewardList, 8))
	--燃料
	draw.label(BattleVictoryAwardsClass._uiLayer,"Label_endurance_value_1",-2)
	--绘制抢夺的信息
	--ImageView_3865
	
	
	local expCount = tonumber(LuaClasses["BattleSceneClass"]._lastExp)/tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp)*100
	local rewardExpCount = tonumber(getRewardValueWithType(rewardList, 8))/tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp)*100
	local isLevelup = false
	local function update(delta)
		require "script/transformers/activity/plunder/PlunderSnatchList"
		local theGrade_qiangduo=tonumber(LuaClasses["PlunderSnatchListClass"]._CurrentGrade)
		require "script/transformers/activity/Arena/ArenaStorage"
		local theGrade_jingjichang=tonumber(LuaClasses["ArenaStorageClass"]._CurrentGrade)
		require "script/transformers/activity/duel/DuelStorage"
		local theGrade_biwu=tonumber(LuaClasses["DuelStorageClass"]._CurrentGrade)
		if theGrade_qiangduo~=nil then 
			local a=tonumber(_ED.user_info.user_grade)
			if a>theGrade_qiangduo then 
					require "script/transformers/battle/BattleLevelUp"	
					 LuaClasses["BattleLevelUpClass"]._rewardInfo = getSceneReward(3)
					 if LuaClasses["BattleLevelUpClass"]._rewardInfo ~= nil then
						LuaClasses["BattleLevelUpClass"].Draw(scene)
					 end
			end 
		elseif theGrade_jingjichang~=nil then 
			local b=tonumber(_ED.user_info.user_grade)
			if b>theGrade_jingjichang then 
					require "script/transformers/battle/BattleLevelUp"	
					 LuaClasses["BattleLevelUpClass"]._rewardInfo = getSceneReward(3)
					 if LuaClasses["BattleLevelUpClass"]._rewardInfo ~= nil then
						LuaClasses["BattleLevelUpClass"].Draw(scene)
					 end
			end 
		elseif theGrade_biwu~=nil then 
			local c=tonumber(_ED.user_info.user_grade)
			if c>theGrade_biwu then 
				require "script/transformers/battle/BattleLevelUp"	
				LuaClasses["BattleLevelUpClass"]._rewardInfo = getSceneReward(3)
				if LuaClasses["BattleLevelUpClass"]._rewardInfo ~= nil then
				LuaClasses["BattleLevelUpClass"].Draw(scene)
				end
			end 
		end 
		-- local sc = 3
		-- if (100-expCount)< 3 then
			-- sc = 100-expCount
		-- end
		-- if rewardExpCount < sc then
			-- sc = rewardExpCount
		-- end
		-- rewardExpCount = rewardExpCount - sc
		
		-- if rewardExpCount<sc then
			-- expCount = tonumber(_ED.user_info.user_experience)/tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp)*100
		-- else
			-- expCount = expCount + sc
		-- end
        -- if expCount >= 100 then
			-- isLevelup = true
            -- expCount = 0
			-- rewardExpCount = rewardExpCount * tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp) / tonumber(_ED.user_info.user_grade_need_experience)
		-- end
		
		-- if tonumber(_ED.user_info.user_experience) == 0 and rewardExpCount > 0 then
			-- isLevelup = true
		-- end
		-- if (tonumber(LuaClasses["BattleSceneClass"]._lastExp)+getRewardValueWithType(rewardList, 8))/tonumber(LuaClasses["BattleSceneClass"]._lastNeedExp)*100 >= 100 then
			-- isLevelup = true
		-- end
		
		-- if rewardExpCount <= 0 then
			-- self:unscheduleUpdate()
			-- if isLevelup == true then
				-- require "script/transformers/battle/BattleLevelUp"	
				----levelLabelAtlas:setStringValue(_ED.user_info.user_grade)
				-- LuaClasses["BattleLevelUpClass"]._rewardInfo = getSceneReward(3)
				-- if LuaClasses["BattleLevelUpClass"]._rewardInfo ~= nil then
					-- LuaClasses["BattleLevelUpClass"].Draw(scene)
				-- end
			-- end
		-- end
    end

    self:scheduleUpdateWithPriorityLua(update, 0)

	if BattleVictoryAwardsClass.battle_init_type == 10 then
		if tonumber(getRewardValueWithType(rewardList, 6)) == 1 then
			BattleVictoryAwardsClass._isAcquire = true
			draw.setVisible(BattleVictoryAwardsClass._uiLayer, "ImageView_grab", true)
			for i, item in pairs(rewardList.show_reward_list) do
				if item.prop_item >= 0 then
					local propDate = elementAt(propMould, item.prop_item)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						draw.label(BattleVictoryAwardsClass._uiLayer,"Label_3881_1", setThePropsIcon(item.prop_item)[2])
					else
						draw.label(BattleVictoryAwardsClass._uiLayer,"Label_3881_1", propDate:atos(prop_mould.prop_name))
					end
					break
				end
			end
		else
			draw.setVisible(BattleVictoryAwardsClass._uiLayer, "ImageView_3865", true)
		end
	end
	--画抽取奖励
	local rewardPlace = {
		"Panel_3882",
		"Panel_3890",
		"Panel_3897",
	}
	
	local rewardIndex = 0
	local openIndex = 0
	local function openCard()
		if openIndex == 0 then
			for i=1,_ED._snatch_fight_reward_count do
				local function visibleInfo()
					if i == rewardIndex then
						draw.setVisible(BattleVictoryAwardsClass._rewardCell[rewardIndex], "ImageView_reward_box_"..i, false)
						draw.setVisible(BattleVictoryAwardsClass._rewardCell[rewardIndex], "ImageView_3884", true)
						draw.setVisible(BattleVictoryAwardsClass._rewardCell[rewardIndex], "ImageView_3885", true)
						--tolua.cast(cardInfo,"CCSprite"):stopAllActions()
					else
						draw.setVisible(BattleVictoryAwardsClass._rewardCell[i], "ImageView_reward_box_"..i, false)
						draw.setVisible(BattleVictoryAwardsClass._rewardCell[i], "ImageView_3885", true)
					end
				end
				draw.setVisible(BattleVictoryAwardsClass._rewardCell[i], "ImageView_3883", true)
				draw.setVisible(BattleVictoryAwardsClass._rewardCell[i], "Panel_18000", true)
				draw.setVisible(BattleVictoryAwardsClass._rewardCell[i], "Panel_18235", true)
				draw.setVisible(BattleVictoryAwardsClass._rewardCell[i], "ImageView_3884", false)
				draw.setVisible(BattleVictoryAwardsClass._rewardCell[i], "ImageView_3885", false)
				local cardInfo = BattleVictoryAwardsClass._rewardCell[i]:getWidgetByName("ImageView_3883")
				tolua.cast(cardInfo,"CCSprite"):stopAllActions()
				cardInfo:setScaleX(0)
				if i == rewardIndex then
					local array1 = CCArray:createWithCapacity(10)
					array1:addObject(CCScaleTo:create(0.5/2, 1, 1))
					array1:addObject(CCCallFuncN:create(visibleInfo))
					local orbit1 = CCSequence:create(array1)
					cardInfo:runAction(orbit1)
				else
					local array2 = CCArray:createWithCapacity(10)
					array2:addObject(CCActionInterval:create(1))
					array2:addObject(CCScaleTo:create(0.5/2, 1, 1))
					array2:addObject(CCCallFuncN:create(visibleInfo))
					local orbit2 = CCSequence:create(array2)
					cardInfo:runAction(orbit2)
				end
				if _ED._snatch_fight_reward[i].fight_reward_extraction_state == "1" then
					draw.label(BattleVictoryAwardsClass._rewardCell[rewardIndex],"Label_3886_1",_ED._snatch_fight_reward[i].fight_reward_name)
					local cellQuality = tonumber(_ED._snatch_fight_reward[i].fight_reward_quality)+1
					local lableName = BattleVictoryAwardsClass._rewardCell[rewardIndex]:getWidgetByName("Label_3886_1")
					if __lua_project_id==__lua_project_all_star then 
						if tonumber(_ED._snatch_fight_reward[i].fight_reward)==6 then 
							local s,e= string.find(_ED._snatch_fight_reward[i].fight_reward_name,"灵魂")
							if s~=nil and s>0  then
								lableName:setColor(ccc3(color_Type_role[cellQuality][1],color_Type_role[cellQuality][2],color_Type_role[cellQuality][3]))
							else
								lableName:setColor(ccc3(color_Type[cellQuality][1],color_Type[cellQuality][2],color_Type[cellQuality][3]))
							end
						else
							lableName:setColor(ccc3(color_Type[cellQuality][1],color_Type[cellQuality][2],color_Type[cellQuality][3]))
						end 
					else
						lableName:setColor(ccc3(color_Type[cellQuality][1],color_Type[cellQuality][2],color_Type[cellQuality][3]))
					end 
					lableName:setStroke(ccc3(0, 0, 0), 1)
					local rewardPlaces = BattleVictoryAwardsClass._rewardCell[rewardIndex]:getWidgetByName("Panel_3889")
					rewardPlaces:addChild(draw.drawPVPFightRewardCell(_ED._snatch_fight_reward[i]))
				else
					local placeIndex = i
					if i==rewardIndex then
						placeIndex = 1
					end	
					draw.label(BattleVictoryAwardsClass._rewardCell[placeIndex],"Label_3886_1",_ED._snatch_fight_reward[i].fight_reward_name)
					local cellQuality = tonumber(_ED._snatch_fight_reward[i].fight_reward_quality)+1
					local lableName = BattleVictoryAwardsClass._rewardCell[placeIndex]:getWidgetByName("Label_3886_1")
					if __lua_project_id==__lua_project_all_star then 
						if tonumber(_ED._snatch_fight_reward[i].fight_reward)==6 then 
							local s= string.find(_ED._snatch_fight_reward[i].fight_reward_name,"灵魂")
							if s~=nil and s>0  then
								lableName:setColor(ccc3(color_Type_role[cellQuality][1],color_Type_role[cellQuality][2],color_Type_role[cellQuality][3]))
							else
								lableName:setColor(ccc3(color_Type[cellQuality][1],color_Type[cellQuality][2],color_Type[cellQuality][3]))
							end
						else
							lableName:setColor(ccc3(color_Type[cellQuality][1],color_Type[cellQuality][2],color_Type[cellQuality][3]))
						end 
					else
						lableName:setColor(ccc3(color_Type[cellQuality][1],color_Type[cellQuality][2],color_Type[cellQuality][3]))
					end 
					lableName:setStroke(ccc3(0, 0, 0), 1)
					local rewardPlaces = BattleVictoryAwardsClass._rewardCell[placeIndex]:getWidgetByName("Panel_3889")
					rewardPlaces:addChild(draw.drawPVPFightRewardCell(_ED._snatch_fight_reward[i]))
				end
			end
			openIndex = openIndex + 1
		end
	end
	
	local function extractRewardCallback(sender,eventType)
		if eventType == ccs.TouchEventType.ended then
			rewardIndex = sender._index
			for i=1,_ED._snatch_fight_reward_count do
				local extract = BattleVictoryAwardsClass._rewardCell[i]:getWidgetByName("ImageView_reward_box_"..i)
				extract:setTouchEnabled(false)
				tolua.cast(extract,"CCSprite"):stopAllActions()
				if i == rewardIndex then
					BattleVictoryAwardsClass._cellInfo = BattleVictoryAwardsClass._rewardCell[i]
					local array1 = CCArray:createWithCapacity(10)
					array1:addObject(CCScaleTo:create(0.5/2, 0, 1))
					array1:addObject(CCCallFuncN:create(openCard))
					local orbit1 = CCSequence:create(array1)
					extract:runAction(orbit1)
				else
					BattleVictoryAwardsClass._cellInfo = BattleVictoryAwardsClass._rewardCell[i]
					local array = CCArray:createWithCapacity(10)
					array:addObject(CCActionInterval:create(1))
					array:addObject(CCScaleTo:create(0.5/2, 0, 1))
					array:addObject(CCCallFuncN:create(openCard))
					local orbit = CCSequence:create(array)
					extract:runAction(orbit)
				end	
			end
			BattleVictoryAwardsClass._isGet = true
		elseif eventType == ccs.TouchEventType.began then
			playEffect(formatMusicFile("button", 2))		--加入按钮音效	
		end
	end
	for i=1,_ED._snatch_fight_reward_count do
		draw.load("interface/battle_victory_awards_0.json")
		local rewardInfo = draw.create("Panel_3882")--GUIReader:shareReader():widgetFromJsonFile("interface/battle_victory_awards_0.json")
		local rewardPlace = BattleVictoryAwardsClass._uiLayer:getWidgetByName(rewardPlace[i])
		BattleVictoryAwardsClass._rewardCell[i] = rewardInfo
		rewardPlace:addChild(rewardInfo)
		draw.delete()
		--local actionReward1 = ActionManager:shareManager():getActionByName("battle_victory_awards_0.json","Animation0")
		--actionReward1:play()
		draw.setVisible(rewardInfo, "Panel_18000", false)
		if i==1 then
			local extractButton = rewardInfo:getWidgetByName("ImageView_reward_box")
			extractButton:setName("ImageView_reward_box_"..i)
			local array1 = CCArray:createWithCapacity(10)
			array1:addObject(CCScaleTo:create(0.125, 0.8))
			array1:addObject(CCScaleTo:create(0.125, 1))
			array1:addObject(CCActionInterval:create(0.25))
			array1:addObject(CCActionInterval:create(0.25))
			local seq1 = CCSequence:create(array1)
			extractButton:runAction(CCRepeatForever:create(seq1))
			extractButton._index = i
			extractButton:addTouchEventListener(extractRewardCallback)
		elseif i==2 then
			local extractButton = rewardInfo:getWidgetByName("ImageView_reward_box")
			extractButton:setName("ImageView_reward_box_"..i)
			local array2 = CCArray:createWithCapacity(10)
			array2:addObject(CCActionInterval:create(0.25))
			array2:addObject(CCScaleTo:create(0.125, 0.8))
			array2:addObject(CCScaleTo:create(0.125, 1))
			array2:addObject(CCActionInterval:create(0.25))
			local seq2 = CCSequence:create(array2)
			extractButton:runAction(CCRepeatForever:create(seq2))
			extractButton._index = i
			extractButton:addTouchEventListener(extractRewardCallback)
		elseif i==3 then
			local extractButton = rewardInfo:getWidgetByName("ImageView_reward_box")
			extractButton:setName("ImageView_reward_box_"..i)
			local array3 = CCArray:createWithCapacity(10)
			array3:addObject(CCActionInterval:create(0.25))
			array3:addObject(CCActionInterval:create(0.25))
			array3:addObject(CCScaleTo:create(0.125, 0.8))
			array3:addObject(CCScaleTo:create(0.125, 1))
			local seq3 = CCSequence:create(array3)
			extractButton:runAction(CCRepeatForever:create(seq3))
			extractButton._index = i
			extractButton:addTouchEventListener(extractRewardCallback)
		end
		
	end
	--
	--END
	---------------------------------------------------------------------------------------------------------------
end	

function BattleVictoryAwardsClass.create()
	local layer = LuaClasses["BattleVictoryAwardsClass"].super.extend(BattleVictoryAwardsClass, CCLayer:create())
    layer:init()
    return layer
end

function BattleVictoryAwardsClass.backCallback()
	
end


function BattleVictoryAwardsClass.closeCallback()
	BattleVictoryAwardsClass._layer:removeFromParentAndCleanup(true)
	BattleVictoryAwardsClass._layer = nil
end

function BattleVictoryAwardsClass.initData(sender)
	BattleVictoryAwardsClass.battle_init_type = sender
end	

function BattleVictoryAwardsClass.Draw()
	BattleVictoryAwardsClass._isGet = false
	BattleVictoryAwardsClass._isAcquire = false
	BattleVictoryAwardsClass._layer = BattleVictoryAwardsClass.create()
	draw.graphics(BattleVictoryAwardsClass._layer)
end

BattleVictoryAwardsClass._draw = BattleVictoryAwardsClass.Draw
BattleVictoryAwardsClass._back = BattleVictoryAwardsClass.backCallback
BattleVictoryAwardsClass._close = BattleVictoryAwardsClass.closeCallback
-- END
-- ----------------------------------------------------------------------------------------------------
