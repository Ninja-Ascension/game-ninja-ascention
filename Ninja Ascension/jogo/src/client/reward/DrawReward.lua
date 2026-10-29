-- ----------------------------------------------------------------------------------------------------
-- 说明：绘制奖励的工具 
-- 创建时间2014-03-03 11:30
-- 作者：李文鋆
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
--绘制的获得的奖励界面
--参数一：奖励绘制的列表
-------------------------------------------------------------------------------------------------------
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
local function propInfoCallback(sender, eventType)
	if eventType == ccs.TouchEventType.ended then
		--local propType = sender._item:atoi(prop_mould.props_type)		--道具类型（0：普通，1：英雄碎片，2：宝箱和钥匙，3：爆竹，4：包裹类（多种），5：好感度礼物，6：VIP等级）
		if sender._type == 6 then
			require "script/transformers/prop/PropInformation"
			LuaClasses["PropInformationClass"].initData(sender._mouldId, sender._number)
			LuaClasses["MainWindowClass"].openWindow(LuaClasses["PropInformationClass"])
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
		require "script/transformers/equipment/FragmentEquipmentInformation"
		LuaClasses["FragmentEquipmentInformationClass"].initData(sender._mouldId)
		LuaClasses["MainWindowClass"].openWindow(LuaClasses["FragmentEquipmentInformationClass"])
	elseif eventType == ccs.TouchEventType.began then
		playEffect(formatMusicFile("button", 1))		--加入按钮音效
	end
end
--鬼道图标被点击事件
local function powerInfoCallback(sender, eventType)
	if eventType == ccs.TouchEventType.ended then
		require "script/jtx/play/power/PowerInformation"
		LuaClasses["PowerInformationClass"]:initData(sender._power, __power_ui_status_not)
		LuaClasses["MainWindowClass"].openWindow(LuaClasses["PowerInformationClass"])
	elseif eventType == ccs.TouchEventType.began then
		playEffect(formatMusicFile("button", 1))		--加入按钮音效
	end
end

function drawGetReward(rewardListView, _rewardType)
	--场景星级领取的奖励表
	local rewardInfo = getSceneReward(_rewardType == nil and 0 or _rewardType) 
	for i=1, tonumber(rewardInfo.show_reward_item_count) do
		local rewardList = rewardInfo.show_reward_list[i]
		-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数) 
		--如果有钱
		if tonumber(rewardList.prop_type) == 1 and tonumber(rewardList.item_value) > 0 then
			local cell = draw.drawGoodsIconNew(calculateIconType(tonumber(rewardList.item_value)),tonumber(rewardList.item_value), 1)
			rewardListView:pushBackCustomItem(cell)
		end
		--如果有宝石
		if tonumber(rewardList.prop_type) == 2 and tonumber(rewardList.item_value) > 0 then
			local cell = draw.drawGoodsIconNew(3015,tonumber(rewardList.item_value), 1)
			rewardListView:pushBackCustomItem(cell)
		end

		--如果有声望
		if tonumber(rewardList.prop_type) == 3 and tonumber(rewardList.item_value) > 0 then
			local cell = draw.drawGoodsIconNew(nil, tonumber(rewardList.item_value), 2)
			rewardListView:pushBackCustomItem(cell)
		end
		--如果有将魂
		if tonumber(rewardList.prop_type) == 4 and tonumber(rewardList.item_value) > 0 then
		--[[
			GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 0)
			--GUIReader:shareReader():setString("ImageView_1251_0_1", "fileNameData", "images/ui/props/props_4003.png")
			draw.setImage("ImageView_1251_0_1", "images/ui/props/props_4003.png")
			local GoldFrame = string.format("images/ui/quality/role_box_%d.png", 3)
			draw.setImage("ImageView_equipment_1", GoldFrame)--框
			cell = GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 1)
			local propNumber = tolua.cast(cell:getWidgetByName("Label_l-order_level"),"Label")
			propNumber:setText(rewardList.item_value)
			local propName = tolua.cast(cell:getWidgetByName("Label_name"),"Label")
			propName:setText("钢魂")		
		--]]	
			local cell = draw.drawGoodsIconNew(nil,rewardList.item_value, 6)
			rewardListView:pushBackCustomItem(cell)
			GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", -1)
		end
		--如果有魂玉
		if tonumber(rewardList.prop_type) == 5 and tonumber(rewardList.item_value) > 0 then
		--[[
			GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 0)
			GUIReader:shareReader():setString("ImageView_1251_0_1", "fileNameData", "images/ui/props/props_4002.png")
			local GoldFrame = string.format("images/ui/quality/role_box_%d.png",  3)
			draw.setImage("ImageView_equipment_1", GoldFrame)--框
			cell = GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", 1)
			local propNumber = tolua.cast(cell:getWidgetByName("Label_l-order_level"),"Label")
			propNumber:setText(rewardList.item_value)
			local propName = tolua.cast(cell:getWidgetByName("Label_name"),"Label")
			propName:setText("秘银")		
			--]]
			local cell = draw.drawGoodsIconNew(nil,rewardList.item_value, 7)
			rewardListView:pushBackCustomItem(cell)
			GUIReader:shareReader():widgetFromCacheJsonFile("interface/item.json", "Panel_prop_box", -1)
		end		
		--道具
		if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 then
			--cell = draw.drawGiftPropIcon(rewardList.prop_item, tonumber(rewardList.item_value))
			local cell = draw.drawGoodsIconNew(rewardList.prop_item, tonumber(rewardList.item_value),3)
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			touchObject._mouldId = rewardList.prop_item
			touchObject._number = tonumber(rewardList.item_value)
			touchObject._type = tonumber(rewardList.prop_type)
			touchObject:addTouchEventListener(propInfoCallback)
			rewardListView:pushBackCustomItem(cell)
		end	
		 --装备
		if tonumber(rewardList.prop_type) == 7 and tonumber(rewardList.item_value) > 0 then
			--cell = draw.drawGiftEquipIcon(rewardList.prop_item, tonumber(rewardList.item_value))
			local cell = draw.drawGoodsIconNew(rewardList.prop_item, tonumber(rewardList.item_value),4)
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			touchObject._mouldId = rewardList.prop_item
			touchObject:addTouchEventListener(equipmentInfoCallback)
			rewardListView:pushBackCustomItem(cell)
		end	
		--武将
		if tonumber(rewardList.prop_type) == 13 and tonumber(rewardList.item_value) > 0 then
			--cell = draw.drawGiftHeroIcon(rewardList.prop_item, tonumber(rewardList.item_value))
			local shipMouldList = elementAt(shipMoulds, tonumber(rewardList.prop_item))
			local cell = nil
			if LuaClasses["RefiningFurnaceClass"] ~= nil and LuaClasses["RefiningFurnaceClass"]._searchWeight > 0 then
				cell = draw.drawGoodsIconNew(shipMouldList:atos(ship_mould.base_mould_two), tonumber(rewardList.item_value),5)
			else
				cell = draw.drawGoodsIconNew(rewardList.prop_item, tonumber(rewardList.item_value),5)
			end
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			if LuaClasses["RefiningFurnaceClass"] ~= nil and LuaClasses["RefiningFurnaceClass"]._searchWeight > 0 then
				touchObject._mouldId = shipMouldList:atoi(ship_mould.base_mould_two)
			else
				touchObject._mouldId = rewardList.prop_item
			end
			touchObject._number = tonumber(rewardList.item_value)
			touchObject._type = tonumber(rewardList.prop_type)
			touchObject:addTouchEventListener(propInfoCallback)
			rewardListView:pushBackCustomItem(cell)
		end	
		--鬼道
		if tonumber(rewardList.prop_type) == 17 and tonumber(rewardList.item_value) > 0 then
			local cell = draw.drawGoodsIconNew(rewardList.prop_item, tonumber(rewardList.item_value),8)
			local powerTemplate = elementAt(powerMould, rewardList.prop_item)
				local power = {
					power_id = 0, -- 霸气id 
					power_mould_id = rewardList.prop_item, -- 霸气模板id 
					ship_id = 0, -- 伙伴id(没有为0) 
					tag_index = 0, -- 所在位置(0背包，1装备栏) 
					at_index = 0, -- 位置索引(从1开始) 
					level = 0, -- 等级
					total_exp = 0, -- 总经验
					power_mould = powerTemplate,-- 当前霸气模板实例
				}
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			touchObject._power = power
			touchObject:addTouchEventListener(powerInfoCallback)
			rewardListView:pushBackCustomItem(cell)
		end	
		
		--荣誉
		if tonumber(rewardList.prop_type) == 10 and tonumber(rewardList.item_value) > 0 then
			local cell = draw.drawGoodsIconNew(nil, tonumber(rewardList.item_value), 9)
			rewardListView:pushBackCustomItem(cell)
		end	
	end	
end

function drawActivityReward(rewardListView, _rewardType)
	--场景星级领取的奖励表
	local rewardInfo = _ED.active_activity[_rewardType].activity_Info
	for  i=1, tonumber(_ED.active_activity[_rewardType].activity_count) do	
		--如果有钱
		if tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_silver) > 0 then
			local cell = draw.drawGoodsIconNew(calculateIconType(tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_silver)),tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_silver), 1)
			--cell = draw.drawGoldIcon(calculateIconType(tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_silver)), tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_silver))
			rewardListView:pushBackCustomItem(cell)
		end
		--如果有宝石
		if tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_gold) > 0 then
			--cell = draw.drawGoldIcon(3015,tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_gold))
			local cell = draw.drawGoodsIconNew(3015,tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_gold), 1)
			rewardListView:pushBackCustomItem(cell)
		end

		--如果有声望
		if tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_honour) > 0 then
			local cell = draw.drawGoodsIconNew(nil,tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_honour), 2)
			--cell = draw.drawHonourIcon(tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_honour))
			rewardListView:pushBackCustomItem(cell)
		end
		
		--道具
		if zstring.tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_prop_count) > 0 then
			for j=1,tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_prop_count) do
				--cell = draw.drawGiftPropIcon(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_prop_info[j].propMould, tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_prop_info[j].propMouldCount))			
				local cell = draw.drawGoodsIconNew(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_prop_info[j].propMould, tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_prop_info[j].propMouldCount),3)
				local touchObject = cell:getWidgetByName("ImageView_equipment_1")
				touchObject._mouldId = _ED.active_activity[_rewardType].activity_Info[i].activityInfo_prop_info[j].propMould
				touchObject._number = tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_prop_info[j].propMouldCount)
				touchObject:addTouchEventListener(propInfoCallback)
				rewardListView:pushBackCustomItem(cell)
			end
		end

		 --装备
		if zstring.tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_equip_count) > 0 then
			for w=1,tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_equip_count) do
				local cell = draw.drawGoodsIconNew(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_equip_info[w].equipMould, tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_equip_info[w].equipMouldCount),4)
				--cell = draw.drawGiftEquipIcon(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_equip_info[w].equipMould, tonumber(_ED.active_activity[_rewardType].activity_Info[i].activityInfo_equip_info[w].equipMouldCount))
				local touchObject = cell:getWidgetByName("ImageView_equipment_1")
				touchObject._mouldId = _ED.active_activity[_rewardType].activity_Info[i].activityInfo_equip_info[w].equipMould
				touchObject:addTouchEventListener(equipmentInfoCallback)
				rewardListView:pushBackCustomItem(cell)
			end
		end
	end	
end
-- END
-- ----------------------------------------------------------------------------------------------------
