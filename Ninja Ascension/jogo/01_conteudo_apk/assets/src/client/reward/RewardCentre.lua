-- ----------------------------------------------------------------------------------------------------
-- 说明：领取奖励中心后的界面
-- 创建时间2014-04-03 20:50
-- 作者：李文鋆
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

local RewardCentreTipClass = CreateClass("RewardCentreTipClass", LuaClass)
RewardCentreTipClass.__index = RewardCentreTipClass
RewardCentreTipClass._uiLayer= nil
RewardCentreTipClass._widget = nil
RewardCentreTipClass._widgetInfo = nil
RewardCentreTipClass._sceneTitle = nil 
RewardCentreTipClass._layer = nil
RewardCentreTipClass._rewardId = nil

local function calculateIconType(number)
	local iconid = 3009
	if number >=1 and number<=9999 then
		iconid = 3009
	elseif number>=10000 and number<=99999 then
		iconid = 3011
	elseif number >=100000 then
		iconid = 3013
	end
	return iconid
end

--奖励道具图标被点击事件
local function propInfoCallback(sender, eventType)		--道具类型（0：普通，1：英雄碎片，2：宝箱和钥匙，3：爆竹，4：包裹类（多种），5：好感度礼物，6：VIP等级）
	if eventType == ccs.TouchEventType.ended then
		if sender._type == 6 then
			local propData = elementAt(propMould, sender._mouldId)
			local propType = propData:atoi(prop_mould.props_type)
			if __lua_project_id == __lua_project_bleach then
				if propType == 7 then
					local userprop={
						user_prop_template=sender._mouldId,			--用户道具模版ID号
					}
					require "script/transformers/prop/PropUseTypeSeven"
					LuaClasses["PropUseTypeSevenClass"].initData(userprop, 2)
					LuaClasses["MainWindowClass"].openWindow(LuaClasses["PropUseTypeSevenClass"])
				elseif propType == 8 and propType == 9 then
				
				else
					require "script/transformers/prop/PropInformation"
					LuaClasses["PropInformationClass"].initData(sender._mouldId, sender._number)
					LuaClasses["MainWindowClass"].openWindow(LuaClasses["PropInformationClass"])
				end
			else
				if propType == 7 then
					local userprop={
						user_prop_template=sender._mouldId,			--用户道具模版ID号
					}
					require "script/transformers/prop/PropUseTypeSeven"
					LuaClasses["PropUseTypeSevenClass"].initData(userprop, 2)
					LuaClasses["MainWindowClass"].openWindow(LuaClasses["PropUseTypeSevenClass"])
				else
					require "script/transformers/prop/PropInformation"
					LuaClasses["PropInformationClass"].initData(sender._mouldId, sender._number)
					LuaClasses["MainWindowClass"].openWindow(LuaClasses["PropInformationClass"])
				end
			end
		elseif sender._type == 13 then
			if tonumber(sender._mouldId) > 0 then
				_ED._ship_info_type = 4
				-- OpenServiceRewardClass._layer:setVisible(false)
				require "script/transformers/hero/HeroFragmentInformationExt"
				LuaClasses["HeroFragmentInformationExtClass"].initData(sender._mouldId, nil)
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["HeroFragmentInformationExtClass"])
			end
		end
	elseif eventType == ccs.TouchEventType.began then
		playEffect(formatMusicFile("button", 1))		--加入按钮音效
	end
end
--装备图标被点击事件
local function equipmentInfoCallback(sender, eventType)
	if eventType == ccs.TouchEventType.ended then
		local equipData = elementAt(equipmentMould, sender._mouldId)
		local equipmentType = equipData:atoi(equipment_mould.equipment_type)
		if equipmentType == 6 or equipmentType == 7 then
			require "script/transformers/equipment/FashionEquipmentInformation"
			LuaClasses["FashionEquipmentInformationClass"].initData(sender._mouldId,false)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["FashionEquipmentInformationClass"])
		elseif equipmentType > 3 and equipmentType < 6 then		--宝物
			require "script/transformers/equipment/FragmentTreasureInformation"
			LuaClasses["FragmentTreasureInformationClass"].initData(nil,sender._mouldId)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["FragmentTreasureInformationClass"])
		else													--装备
			local equipmentSuitId = equipData:atoi(equipment_mould.suit_id)		--装备套装类型
			if tonumber(equipmentSuitId) == 0 then 		--非套装
				require "script/transformers/equipment/FragmentEquipmentInformation"
				LuaClasses["FragmentEquipmentInformationClass"].initData(equipData:atoi(equipment_mould.id))
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["FragmentEquipmentInformationClass"])
			else										--套装
				require "script/transformers/equipment/FragmentEmboitementInformation"
				LuaClasses["FragmentEmboitementInformationClass"].initData(equipData:atoi(equipment_mould.id))
				LuaClasses["MainWindowClass"].openWindow(LuaClasses["FragmentEmboitementInformationClass"])
			end
		end
	elseif eventType == ccs.TouchEventType.began then
		playEffect(formatMusicFile("button", 1))		--加入按钮音效
	end
end

--鬼道图标被点击事件
local function powerInfoCallback(sender, eventType)
	if eventType == ccs.TouchEventType.ended then
	local powerTemplate = elementAt(powerMould, sender._mouldId)
		local power = {
			power_id = 0, -- 霸气id 
			power_mould_id = sender._mouldId, -- 霸气模板id 
			ship_id = 0, -- 伙伴id(没有为0) 
			tag_index = 0, -- 所在位置(0背包，1装备栏) 
			at_index = 0, -- 位置索引(从1开始) 
			level = 0, -- 等级
			total_exp = 0, -- 总经验
			power_mould = powerTemplate,-- 当前霸气模板实例
		}
		require "script/jtx/play/power/PowerInformation"
		require "script/jtx/play/power/DrawPower"
		require "script/jtx/play/power/ChoosePower"
		require "script/jtx/play/power/ShowPower"
		LuaClasses["PowerInformationClass"]:initData(power, __power_ui_status_not)
		LuaClasses["MainWindowClass"].openWindow(LuaClasses["PowerInformationClass"])
	end
end

function RewardCentreTipClass:init()
	RewardCentreTipClass._uiLayer = TouchGroup:create()
	self:addChild(RewardCentreTipClass._uiLayer)
	
	if RewardCentreTipClass._rewardId == nil then
		RewardCentreTipClass._rewardId = 7
	end
	-- 奖励获得界面
	self._widget = draw.getWidget("interface/congratulations_to_btain_0.json")
	RewardCentreTipClass._uiLayer:addWidget(self._widget)
	
	draw.setVisible(RewardCentreTipClass._uiLayer, "ScrollView_53486", true)
	local rewardScrollView = tolua.cast(RewardCentreTipClass._uiLayer:getWidgetByName("ScrollView_53486"),"ScrollView")
	local rewardPlace = RewardCentreTipClass._uiLayer:getWidgetByName("Panel_53603")
	--画奖励的信息
	local rewardInfo = getSceneReward(RewardCentreTipClass._rewardId)
	local rewardNumber = 0

	
	for sgn, v in pairs(_ED.show_reward_list_group) do
	end
	
	for i=1, tonumber(rewardInfo.show_reward_item_count) do
		--如果有钱
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 1 then
			cell = draw.drawGoldIcon(calculateIconType(tonumber(rewardInfo.show_reward_list[i].item_value)), tonumber(rewardInfo.show_reward_list[i].item_value))
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
		end
		--如果有宝石
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 2 then
			cell = draw.drawGoldIcon(3015,tonumber(rewardInfo.show_reward_list[i].item_value))
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
		end

		--如果有声望
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 3 then
			cell = draw.drawHonourIcon(rewardInfo.show_reward_list[i].item_value)
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
		end
		--如果有将魂
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 4 then
			GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 0)
			--GUIReader:shareReader():setString("ImageView_1251_0_1", "fileNameData", "images/ui/props/props_4003.png")
			draw.setImage("ImageView_1251_0_1", "images/ui/props/props_4003.png")
			local GoldFrame = string.format("images/ui/quality/role_box_%d.png", 3)
			draw.setImage("ImageView_equipment_1", GoldFrame)--框
			cell = GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 1)
			local propNumber = tolua.cast(cell:getWidgetByName("Label_l-order_level"),"Label")
			--propNumber:setText(rewardInfo.show_reward_list[i].item_value)
			draw.text(propNumber,rewardInfo.show_reward_list[i].item_value)
			local propName = tolua.cast(cell:getWidgetByName("Label_name"),"Label")
			--propName:setText(_All_tip_string_info._steelSoulName)		
			draw.text(propName,_All_tip_string_info._steelSoulName)
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
			GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", -1)
		end
		--如果有魂玉
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 5 then
			GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 0)
			GUIReader:shareReader():setString("ImageView_1251_0_1", "fileNameData", "images/ui/props/props_4002.png")
			local GoldFrame = string.format("images/ui/quality/role_box_%d.png",  3)
			draw.setImage("ImageView_equipment_1", GoldFrame)--框
			cell = GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 1)
			local propNumber = tolua.cast(cell:getWidgetByName("Label_l-order_level"),"Label")
			--propNumber:setText(rewardInfo.show_reward_list[i].item_value)
			draw.text(propNumber,rewardInfo.show_reward_list[i].item_value)
			local propName = tolua.cast(cell:getWidgetByName("Label_name"),"Label")
			--propName:setText(_All_tip_string_info._soulJadeName)	
			draw.text(propName,_All_tip_string_info._soulJadeName)
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
			GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", -1)
		end		
		--道具
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 6 then
			cell = draw.drawGiftPropIcon(rewardInfo.show_reward_list[i].prop_item, tonumber(rewardInfo.show_reward_list[i].item_value))	
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			touchObject._mouldId = rewardInfo.show_reward_list[i].prop_item
			touchObject._number = tonumber(rewardInfo.show_reward_list[i].item_value)
			touchObject._type = tonumber(rewardInfo.show_reward_list[i].prop_type)
			touchObject:addTouchEventListener(propInfoCallback)
			rewardNumber = rewardNumber + 1			
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
		end
		 --装备
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 7 then
			cell = draw.drawGiftEquipIcon(rewardInfo.show_reward_list[i].prop_item, tonumber(rewardInfo.show_reward_list[i].item_value))
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			touchObject._mouldId = rewardInfo.show_reward_list[i].prop_item
			touchObject:addTouchEventListener(equipmentInfoCallback)
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
		end	
		--武将
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 13 then
			cell = draw.drawGiftHeroIcon(rewardInfo.show_reward_list[i].prop_item)
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			touchObject._mouldId = rewardInfo.show_reward_list[i].prop_item
			touchObject._number = 1
			touchObject._type = tonumber(rewardInfo.show_reward_list[i].prop_type)
			touchObject:addTouchEventListener(propInfoCallback)
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
		end	
		--鬼道
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 17 then
			cell = draw.drawPowerIcon(rewardInfo.show_reward_list[i].prop_item)
			local touchObject = cell:getWidgetByName("ImageView_4192")
			touchObject._mouldId = rewardInfo.show_reward_list[i].prop_item
			touchObject._number = 1
			touchObject._type = tonumber(rewardInfo.show_reward_list[i].prop_type)
			touchObject:addTouchEventListener(powerInfoCallback)
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
		end
		--如果有声望
		if tonumber(rewardInfo.show_reward_list[i].prop_type) == 18 then
			cell = draw.drawCreditIcon(rewardInfo.show_reward_list[i].item_value)
			rewardNumber = rewardNumber + 1
			local itemOffsety = math.ceil(rewardNumber/4)-1
			cell:setPosition(ccp(cell:getPositionX()+10+((rewardNumber-1)%4)*56,rewardPlace:getSize().height-cell:getSize().height-tonumber(itemOffsety)*60))
			rewardPlace:addChild(cell)
		end
		--如果有将魂
	end
	
	local imageOne = RewardCentreTipClass._uiLayer:getWidgetByName("ImageView_bg")
	local imageOneSize = imageOne:getSize()
	local imageTwo = RewardCentreTipClass._uiLayer:getWidgetByName("ImageView_979")
	local imageTwoSize = imageTwo:getSize()
	local placeInfo = (math.ceil(rewardNumber/4)-1)*60
	rewardPlace:setPosition(ccp(rewardPlace:getPositionX(),rewardPlace:getPositionY()+placeInfo))
	rewardScrollView:setInnerContainerSize(CCSize(rewardScrollView:getSize().width, rewardScrollView:getSize().height+placeInfo))
	
	local function leaveWindows(sender, eventType)
		if eventType == ccs.TouchEventType.ended then
			LuaClasses["MainWindowClass"].closeWindow(LuaClasses["RewardCentreTipClass"])
		elseif eventType == ccs.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end	
	local confirm = tolua.cast(RewardCentreTipClass._uiLayer:getWidgetByName("Button_fork"),"Button")
	confirm:addTouchEventListener(leaveWindows)
	local closeWindows = tolua.cast(RewardCentreTipClass._uiLayer:getWidgetByName("Button_determine"),"Button")
	closeWindows:addTouchEventListener(leaveWindows)

end	

function RewardCentreTipClass.create()
	local layer = LuaClasses["RewardCentreTipClass"].super.extend(RewardCentreTipClass, CCLayer:create())
    layer:init()
    return layer
end



function RewardCentreTipClass.backCallback()
	
end

function RewardCentreTipClass.closeCallback()
	RewardCentreTipClass._rewardId = nil
	if RewardCentreTipClass._layer~=nil then
		RewardCentreTipClass._layer:removeFromParentAndCleanup(true)
		RewardCentreTipClass._layer = nil
	end
end

function RewardCentreTipClass.initData(id)
	RewardCentreTipClass._rewardId = id
end

function RewardCentreTipClass.Draw()
	RewardCentreTipClass._layer = RewardCentreTipClass.create()
	draw.graphics(RewardCentreTipClass._layer)
end

RewardCentreTipClass._draw = RewardCentreTipClass.Draw
RewardCentreTipClass._back = RewardCentreTipClass.backCallback
RewardCentreTipClass._close = RewardCentreTipClass.closeCallback
-- END
-- ----------------------------------------------------------------------------------------------------
