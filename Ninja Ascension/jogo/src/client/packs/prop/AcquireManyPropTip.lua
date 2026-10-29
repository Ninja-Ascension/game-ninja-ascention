-- ----------------------------------------------------------------------------------------------------
-- 说明：获得多个道具提示
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

AcquireManyPropTipClass = class("AcquireManyPropTipClass", Window)
AcquireManyPropTipClass.__index = AcquireManyPropTipClass
AcquireManyPropTipClass._uiLayer= nil
AcquireManyPropTipClass._widget = nil
AcquireManyPropTipClass._widgetInfo = nil
AcquireManyPropTipClass._sceneTitle = nil 
AcquireManyPropTipClass._showReward = nil
AcquireManyPropTipClass._rewardCount = 0
AcquireManyPropTipClass._rewardcontainer = 0
AcquireManyPropTipClass._layer = nil

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

function AcquireManyPropTipClass:init()
	AcquireManyPropTipClass._uiLayer = TouchGroup:create()
	self:addChild(AcquireManyPropTipClass._uiLayer)
	-- 获得道具提示
	-- AcquireManyPropTipClass._widget = GUIReader:shareReader():widgetFromJsonFile("interface/use_jiesuan.json")
	-- AcquireManyPropTipClass._uiLayer:addWidget(AcquireManyPropTipClass._widget)
	
	-- 头像点击事件
	-- local function heroCallback(sender, eventType)
		-- if eventType == ccs.TouchEventType.ended then
			-- LuaClasses["AcquireManyPropTipClass"]._layer:setVisible(false)
			-- require "script/transformers/hero/HeroFragmentInformation"
			-- LuaClasses["HeroFragmentInformationClass"].initData(sender._shipMouldId)
			-- LuaClasses["MainWindowClass"].openWindow(LuaClasses["HeroFragmentInformationClass"])
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	-- local function treasureCallback(sender, eventType)
		-- if eventType == ccs.TouchEventType.ended then
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	-- local function equipmentCallback(sender, eventType)
		-- if eventType == ccs.TouchEventType.ended then
		-- elseif eventType == ccs.TouchEventType.began then
			-- playEffect(formatMusicFile("button", 1))		--加入按钮音效
		-- end
	-- end
	
	local function createRewardItem(rewardItem)
		local cell = nil
		local myReward = nil
		--如果是道具
		if tonumber(rewardItem.prop_type) ==6 and tonumber(rewardItem.item_value) > 0 then
			cell = draw.drawGoodsIconNew(rewardItem.prop_item, tonumber(rewardItem.item_value),3)
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			touchObject._mouldId = rewardItem.prop_item
			touchObject._number = tonumber(rewardItem.item_value)
			touchObject._type = tonumber(rewardItem.prop_type)
			--touchObject:addTouchEventListener(propInfoCallback)
			--[[
			local treasureMould = elementAt(propMould, tonumber(rewardItem.prop_item))--获取道具的模板
			--角色图
			local hareImageId = treasureMould:atoi(prop_mould.pic_index)
			local hareImage = string.format("images/ui/props/props_%s.png",hareImageId)
			draw.setImage("ImageView_1251_0_1", hareImage)
			cell = draw.create("Panel_prop_box")cell = draw.create("Panel_prop_box")cell = draw.create("Panel_prop_box")cell = draw.create("Panel_prop_box")cell = draw.create("Panel_prop_box")cell = draw.create("Panel_prop_box")
			draw.setVisible(cell,"ImageView_name_bg_0",true)
			local equipmentName = treasureMould:atos(equipment_mould.equipment_name)
			draw.label(cell,"Label_name",equipmentName)
			--]]
		--如果是装备
		elseif tonumber(rewardItem.prop_type) ==7 and tonumber(rewardItem.item_value) > 0 then
			cell = draw.drawGoodsIconNew(rewardItem.prop_item, tonumber(rewardItem.item_value),4)
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			touchObject._mouldId = rewardItem.prop_item
			--touchObject:addTouchEventListener(equipmentInfoCallback)
			--[[
			local equipmentMould = elementAt(equipmentMould, tonumber(rewardItem.prop_item))--获取装备的模板
			--角色图
			local hareImageId = equipmentMould:atoi(equipment_mould.pic_index)
			local hareImage = string.format("images/ui/props/props_%s.png",  hareImageId)
			draw.setImage("ImageView_1251_0_1", hareImage)
			cell = draw.create("Panel_prop_box")
			draw.setVisible(cell,"ImageView_name_bg_0",true)
			local equipmentName = equipmentMould:atos(equipment_mould.equipment_name)
			draw.label(cell,"Label_name",equipmentName)
			--]]
		--如果是武将
		elseif tonumber(rewardItem.prop_type) == 13 and tonumber(rewardItem.item_value) > 0 then
			local shipMouldList = elementAt(shipMoulds, tonumber(rewardItem.prop_item))
			if LuaClasses["RefiningFurnaceClass"] ~= nil and LuaClasses["RefiningFurnaceClass"]._searchWeight > 0 then
				cell = draw.drawGoodsIconNew(shipMouldList:atos(ship_mould.base_mould_two), tonumber(rewardItem.item_value),5)
			else
				cell = draw.drawGoodsIconNew(rewardItem.prop_item, tonumber(rewardItem.item_value),5)
			end
			local touchObject = cell:getWidgetByName("ImageView_equipment_1")
			if LuaClasses["RefiningFurnaceClass"] ~= nil and LuaClasses["RefiningFurnaceClass"]._searchWeight > 0 then
				touchObject._mouldId = shipMouldList:atoi(ship_mould.base_mould_two)
			else
				touchObject._mouldId = rewardItem.prop_item
			end
			touchObject._number = tonumber(rewardItem.item_value)
			touchObject._type = tonumber(rewardItem.prop_type)
			--touchObject:addTouchEventListener(propInfoCallback)
			--[[
			local heroMould = elementAt(shipMoulds, tonumber(rewardItem.prop_item))--获取武将的模板
			--角色图
			local hareImageId = heroMould:atoi(ship_mould.head_icon)
			local hareImage = string.format("images/ui/props/props_%s.png",  hareImageId)
			draw.setImage("ImageView_1251_0_1", hareImage)
			cell = draw.create("Panel_prop_box")
			draw.setVisible(cell,"ImageView_name_bg_0",true)
			local heroName = heroMould:atos(ship_mould.captain_name)
			draw.label(cell,"Label_name",heroName)
			--]]
		--如果是钱
		elseif tonumber(rewardItem.prop_type) == 1 and tonumber(rewardItem.item_value) > 0 then
			cell = draw.drawGoodsIconNew(calculateIconType(tonumber(rewardItem.item_value)),tonumber(rewardItem.item_value), 1)
			--角色图
			--[[
			local hareImage = string.format("images/ui/props/props_%s.png",4004)
			draw.setImage("ImageView_1251_0_1", hareImage)
			cell = draw.create("Panel_prop_box")
			draw.setVisible(cell,"ImageView_name_bg_0",true)
			draw.label(cell,"Label_name",rewardItem.item_value.._All_tip_string_info._fundName)
			--]]
		--如果是钻石
		elseif tonumber(rewardItem.prop_type) == 2 and tonumber(rewardItem.item_value) > 0 then
			cell = draw.drawGoodsIconNew(3015,tonumber(rewardItem.item_value), 1)
			--[[
			--角色图
			local hareImage = string.format("images/ui/props/props_%s.png",3014)
			draw.setImage("ImageView_1251_0_1", hareImage)
			cell = draw.create("Panel_prop_box")
			draw.setVisible(cell,"ImageView_name_bg_0",true)
			draw.label(cell,"Label_name",rewardItem.item_value.._All_tip_string_info._crystalName)
			--]]
		--如果是灵子
		elseif tonumber(rewardItem.prop_type) == 4 and tonumber(rewardItem.item_value) > 0 then
			cell = draw.drawGoodsIconNew(nil,rewardItem.item_value, 6)
			--[[
			--角色图
			local hareImage = string.format("images/ui/props/props_%s.png",4003)
			draw.setImage("ImageView_1251_0_1", hareImage)
			cell = draw.create("Panel_prop_box")
			draw.setVisible(cell,"ImageView_name_bg_0",true)
			draw.label(cell,"Label_name",rewardItem.item_value.._All_tip_string_info._steelSoulName)
			--]]
		end
		--cell:setSize(draw.drawPropCellIcon(rewardItem.prop_item):getSize())
		return cell
		
	end
	
	local function dropRewardListView()
		--GUIReader:shareReader():widgetFromCacheJsonFile("interface/congratulations_to_btain_list.json", "ImageView_981", 0)  --载入天降宝物列表元素ui
		local treasureListView = tolua.cast(AcquireManyPropTipClass._uiLayer:getWidgetByName("ScrollView_53486"),"ScrollView")--获取宝物掉落列表ui
		local cell = nil
		local myCount = AcquireManyPropTipClass._showReward.show_reward_item_count
		local _row = 4 
		myCount = math.ceil(myCount/_row)

		for i, v in pairs(AcquireManyPropTipClass._showReward.show_reward_list) do
			if (tonumber(v.prop_type) == 6 and tonumber(v.item_value) > 0) 
			or (tonumber(v.prop_type) == 7 and tonumber(v.item_value) > 0) 
			or (tonumber(v.prop_type) == 13 and tonumber(v.item_value) > 0) 
			or (tonumber(v.prop_type) == 1 and tonumber(v.item_value) > 0) 
			or (tonumber(v.prop_type) == 2 and tonumber(v.item_value) > 0) 
			or (tonumber(v.prop_type) == 4 and tonumber(v.item_value) > 0) then
				--draw.load("interface/props_icons.json")
				cell = createRewardItem(v)
				--treasureListView:pushBackCustomItem(cell)
				--一行4个
				local sSize = treasureListView:getSize().width / _row
				local itemOffsety = math.ceil(i/_row)
				if myCount == 1 then
					cell:setPosition(ccp((i-1)%_row*sSize+30,35+itemOffsety*(cell:getSize().height + 20)))
				else
					cell:setPosition(ccp((i-1)%_row*sSize+30,35+(myCount-itemOffsety)*(cell:getSize().height + 20)))
				end
				treasureListView:addChild(cell)
				--draw.delete()

			end
		end
		--treasureListView:setInnerContainerSize(CCSize(treasureListView:getSize().width, (cell:getSize().height + 15)* (j/5)))
		treasureListView:setInnerContainerSize(CCSize(treasureListView:getSize().width, (cell:getSize().height + 20)*myCount))
		--GUIReader:shareReader():widgetFromCacheJsonFile("interface/congratulations_to_btain_list.json", "ImageView_981", -1)  --释放天降宝物列表元素ui
		
		AcquireManyPropTipClass._showReward = nil
	end	
	
	local function backPlotScene(sender,eventType)
		if eventType == ccs.TouchEventType.ended then
			--self:removeFromParentAndCleanup(true)
			LuaClasses["MainWindowClass"].closeWindow(LuaClasses["AcquireManyPropTipClass"])
		elseif eventType == ccs.TouchEventType.began then
			playEffect(formatMusicFile("button", 2))		--加入按钮音效
		end
	end
	
	local confrimButton = tolua.cast(AcquireManyPropTipClass._uiLayer:getWidgetByName("Button_fork"),"Button")
	confrimButton:addTouchEventListener(backPlotScene)
	local leaveWindows = tolua.cast(AcquireManyPropTipClass._uiLayer:getWidgetByName("Button_determine"),"Button")
	leaveWindows:addTouchEventListener(backPlotScene)
	dropRewardListView()
	--local title = tolua.cast(AcquireManyPropTipClass._uiLayer:getWidgetByName("Label_970"),"ImageView")
	--local bottomFrame = AcquireManyPropTipClass._uiLayer:getWidgetByName("ImageView_bg")
	--local listFrame = AcquireManyPropTipClass._uiLayer:getWidgetByName("ImageView_979")
	--local rewardListView = AcquireManyPropTipClass._uiLayer:getWidgetByName("ListView_21689")
	--if AcquireManyPropTipClass._rewardCount > 1 then
	--	AcquireManyPropTipClass._rewardCount = 2
	--	AcquireManyPropTipClass._rewardcontainer = listFrame:getSize().height
	--end
	
	--bottomFrame:setSize(CCSizeMake(bottomFrame:getSize().width, bottomFrame:getSize().height+AcquireManyPropTipClass._rewardcontainer))
	
	--listFrame:setSize(CCSizeMake(listFrame:getSize().width, listFrame:getSize().height+AcquireManyPropTipClass._rewardcontainer))
	
	--rewardListView:setSize(CCSizeMake(rewardListView:getSize().width, rewardListView:getSize().height+AcquireManyPropTipClass._rewardcontainer))
	--rewardListView:setPosition(ccp(rewardListView:getPositionX(), rewardListView:getPositionY()-AcquireManyPropTipClass._rewardcontainer/2))
	confrimButton:setPosition(ccp(confrimButton:getPositionX(), confrimButton:getPositionY()+AcquireManyPropTipClass._rewardcontainer/2))
	leaveWindows:setPosition(ccp(leaveWindows:getPositionX(), leaveWindows:getPositionY()-AcquireManyPropTipClass._rewardcontainer/2))
	--title:setPosition(ccp(title:getPositionX(), title:getPositionY()+AcquireManyPropTipClass._rewardcontainer/2))
	
end	

function AcquireManyPropTipClass.create()
	local layer = LuaClasses["AcquireManyPropTipClass"].super.extend(AcquireManyPropTipClass, CCLayer:create())
    layer:init()
    return layer
end

function AcquireManyPropTipClass.backCallback()
	
end


function AcquireManyPropTipClass.closeCallback()
	if AcquireManyPropTipClass._layer ~= nil then
		AcquireManyPropTipClass._layer:removeFromParentAndCleanup(true)
		AcquireManyPropTipClass._layer = nil
	end
end

function AcquireManyPropTipClass.initData(scene)
	AcquireManyPropTipClass._showReward = scene
	
end	

function AcquireManyPropTipClass.Draw()
	AcquireManyPropTipClass._rewardCount = 0
	AcquireManyPropTipClass._rewardcontainer = 0
	if AcquireManyPropTipClass._layer == nil then
		AcquireManyPropTipClass._layer = AcquireManyPropTipClass.create()
		draw.graphics(AcquireManyPropTipClass._layer)
	end
end


AcquireManyPropTipClass._draw = AcquireManyPropTipClass.Draw
AcquireManyPropTipClass._back = AcquireManyPropTipClass.backCallback
AcquireManyPropTipClass._close = AcquireManyPropTipClass.closeCallback
-- END
-- ----------------------------------------------------------------------------------------------------
