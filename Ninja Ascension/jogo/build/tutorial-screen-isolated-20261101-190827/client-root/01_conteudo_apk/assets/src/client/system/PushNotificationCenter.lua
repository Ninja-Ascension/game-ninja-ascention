-- ----------------------------------------------------------------------------------------------------
-- 说明：推送通知中心
-- 创建时间2014-05-02 13:39
-- 作者：周义文
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

PushNotificationCenterClass = CreateClass("PushNotificationCenterClass", LuaClass)
PushNotificationCenterClass.__index = PushNotificationCenterClass
PushNotificationCenterClass._uiLayer= nil
PushNotificationCenterClass._widget = nil
PushNotificationCenterClass._sceneTitle = nil

PushNotificationCenterClass._firstRechargeRewardIsDraw = true
PushNotificationCenterClass._dinnerInit = true
PushNotificationCenterClass._rewardCenterInit = true
PushNotificationCenterClass._loginSignUpListener = true
PushNotificationCenterClass._secretShopInit = true
PushNotificationCenterClass._divineInit = true
PushNotificationCenterClass._cumulativeRecharge = true
PushNotificationCenterClass._accumulateReward = true
PushNotificationCenterClass._timeLimitLeader = true
PushNotificationCenterClass._cumulativeConsumption = true
PushNotificationCenterClass._initializeStore = true
PushNotificationCenterClass._newEmail = true
PushNotificationCenterClass._CanComposeHero= true
PushNotificationCenterClass._CanComposeEqument= true


-- 动画效果
function cleanNotiticationEffectWidget(padWidget)
	if padWidget ~= nil then
		local tipPad = padWidget:getChildByTag(1)
		if tipPad ~= nil then
			padWidget:removeChildByTag(1)
		end
		return tipPad
	end
	return nil
end

function  createNotiticationEffectWidget(padWidget, effectName)
	if padWidget ~= nil then
		local tipPad = padWidget:getChildByTag(1)
		if tipPad == nil then
			local effect = createEffect(effectName, "images/ui/effice/"..effectName..".ExportJson", padWidget, -1, 10)
			effect:setTag(1)
			local size = padWidget:getContentSize()
			effect:setPosition(ccp(size.width/2, size.height/2))
		end	
		return true
	end
	return false
end

-- 文字角标
function cleanNotiticationWidget(padWidget)
	if padWidget ~= nil then
		local tipPad = padWidget:getChildByTag(1)
		if tipPad ~= nil then
			if __lua_project_id ==__lua_project_all_star 
				or __lua_project_id == __lua_king_of_adventure then 
				if tipPad._notivicationNumber==nil then 
					return 
				end 
			end 
			tipPad._notivicationNumber = tipPad._notivicationNumber - 1
			if tipPad._notivicationNumber > 0 then
				draw.label(tipPad, "Label_466", tipPad._notivicationNumber)
			else
				padWidget:removeChildByTag(1)
			end
		end	
		return true
	end
	return false
end

function createNotiticationWidget(padWidget,number)
	if padWidget ~= nil then
		local tipPad = padWidget:getChildByTag(1)
		if tipPad == nil then
			
			tipPad = draw.drawTag(1)
			if number ~= nil then
				tipPad._notivicationNumber = number
				draw.label(tipPad, "Label_466", tipPad._notivicationNumber)
			else
				tipPad._notivicationNumber = 1
			end
			padWidget:addChild(tipPad)
			tipPad:setTag(1)
			local size = padWidget:getContentSize()
			tipPad:setPosition(ccp(size.width*3/7, size.height/4))
		else
			--对占星做特殊处理
			if padWidget:getName() == "Button_86409" then
				tipPad._notivicationNumber = zstring.tonumber(""..number)
			else
			    if  number == nil then
                     number = 1
				end	
				if tipPad._notivicationNumber ~= nil then
				   tipPad._notivicationNumber = tipPad._notivicationNumber + zstring.tonumber(""..number)
				end   
			end
			if tipPad._notivicationNumber ~= nil then
			   draw.label(tipPad, "Label_466", tipPad._notivicationNumber)
			end
		end
		return tipPad
	end
	return nil
end

function checkSecretShopRefreshTime(updateWrite)
	if _ED.secret_shop_init_info == nil or _ED.secret_shop_init_info.os_time == nil
		or _ED.secret_shop_init_info.refresh_time == nil then
		return false
	end
	
	local t = _ED.secret_shop_init_info.os_time + _ED.secret_shop_init_info.refresh_time/1000 - 3
	local currentAccount = _ED.user_platform[_ED.default_user].platform_account
	local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	local ssr = currentAccount..currentServerNumber.."ssr"
	local ot = cc.UserDefault:getInstance():getStringForKey(ssr)
	if ot == nil or ot == "" then
		cc.UserDefault:getInstance():setStringForKey(ssr, ""..t)
		cc.UserDefault:getInstance():flush()
		return false
	end
	if zstring.tonumber(ot) ~= nil then
		ot = zstring.tonumber(ot) + 2 * 60 * 60
		if ot < t then
			if updateWrite == true then
				cc.UserDefault:getInstance():setStringForKey(ssr, ""..t)
				cc.UserDefault:getInstance():flush()
			end
			return true
		end
		CCUserDefault:sharedUserDefault():flush()
	end
	return false
end

function writeSecretShopRefreshTime()
	if checkSecretShopRefreshTime() == false then
		if _ED.secret_shop_init_info == nil or _ED.secret_shop_init_info.os_time == nil
			or _ED.secret_shop_init_info.refresh_time == nil then
			return
		end
	
		local t = _ED.secret_shop_init_info.os_time + _ED.secret_shop_init_info.refresh_time/1000 - 2 * 60 * 60
		local currentAccount = _ED.user_platform[_ED.default_user].platform_account
		local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
		local ssr = currentAccount..currentServerNumber.."ssr"
		cc.UserDefault:getInstance():setStringForKey(ssr, ""..t)
		cc.UserDefault:getInstance():flush()
	end
end

-- ----------------------------------------------------------------------------------------------------
-- 封装key

-- 获取加好前缀整理的key,用于读写
function getKey(key)
	local currentAccount = _ED.user_platform[_ED.default_user].platform_account
	local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	local cKey = currentAccount..currentServerNumber..key
	return cKey
end
 
function writeKey(key, value)
	local ccdf = cc.UserDefault:sharedUserDefault()
	if ccdf ~= nil then
		ccdf:setStringForKey(getKey(key), ""..value)
		ccdf:flush()
	end
end

function readKey(key)
	local cKey = cc.UserDefault:getInstance():getStringForKey(getKey(key))
	return cKey
end
-- END	~封装key
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 英雄合成提示
local function notificationHero()
	local mKey = "local_can_compose_hero_cont"
	
	if PushNotificationCenterClass._CanComposeHero == false or 
		LuaClasses["HomeClass"]._uiLayer == nil then
		return
	end
	PushNotificationCenterClass._CanComposeHero = false
	
	
	local CanComposeCount = 0
	for i, v in pairs(_ED.user_prop) do
		local propData = elementAt(propMould,v.user_prop_template)
		 if propData:atoi(prop_mould.storage_page_index) == 5 then
				if tonumber(v.prop_number) >= propData:atoi(prop_mould.split_or_merge_count) then
				     CanComposeCount = CanComposeCount + 1
				end
	    end
	end
	
	if __lua_project_id == __lua_king_of_adventure then
	else
		local packButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_pack"), "Button")
		if packButton ~= nil then
			if CanComposeCount > 0 then
				createNotiticationWidget(packButton, CanComposeCount)
			else 
				cleanNotiticationWidget(packButton)
			end
		end
	end

	if __lua_project_id==__lua_project_all_star or __lua_project_id==__lua_project_superhero 
		or __lua_project_id == __lua_king_of_adventure then 
		local warriorButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_warrior_0"), "Button")
		if warriorButton ~= nil then
			if CanComposeCount > 0 then
				createNotiticationWidget(warriorButton,CanComposeCount)
			else 
				cleanNotiticationWidget(warriorButton)
			end
		end
	end 
	writeKey(mKey, CanComposeCount)
end


-- END	英雄合成
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 装备合成提示
local function notificationEqument()
	local mKey = "local_can_compose_equment_cont"
	
	if PushNotificationCenterClass._CanComposeEqument == false or 
		LuaClasses["HomeClass"]._uiLayer == nil then
		return
	end
	PushNotificationCenterClass._CanComposeEqument = false
	
	
	local CanComposeEqumentCount = 0
	for i, v in pairs(_ED.user_prop) do
		local propData = elementAt(propMould,v.user_prop_template)
		if propData:atoi(prop_mould.storage_page_index) == 3 then
			if tonumber(v.prop_number) >= propData:atoi(prop_mould.split_or_merge_count) then
				 CanComposeEqumentCount = CanComposeEqumentCount + 1
			end
		end
	end

	if __lua_project_id == __lua_king_of_adventure then
	else
		local packButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_pack"), "Button")
		if packButton ~= nil then
			if CanComposeEqumentCount > 0 then
				createNotiticationWidget(packButton, CanComposeEqumentCount)
			else 
				cleanNotiticationWidget(packButton)
			end
		end
	end

	if __lua_project_id==__lua_project_all_star or __lua_project_id==__lua_project_superhero 
		or __lua_project_id == __lua_king_of_adventure then 
		local equipmentButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_equipment_0"), "Button")
		if equipmentButton ~= nil then
			if CanComposeEqumentCount > 0 then
				-- createNotiticationWidget(packButton, CanComposeEqumentCount)
				createNotiticationWidget(equipmentButton,CanComposeEqumentCount)
			else 
				-- cleanNotiticationWidget(packButton)
				cleanNotiticationWidget(equipmentButton)
			end
		end
	end 
	writeKey(mKey, CanComposeEqumentCount)
end


-- END	装备合成
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 新邮件推送
local function notificationNewEmail()
	local mKey = "local_no_read_mail_cont"
	
	if PushNotificationCenterClass._newEmail == false or 
		LuaClasses["HomeClass"]._uiLayer == nil then
		return
	end
	PushNotificationCenterClass._newEmail = false
	
	local unreadEMailCount = 0 

	if _ED.no_read_mail_cont ~= nil and zstring.tonumber(_ED.no_read_mail_cont) > 0  then
		unreadEMailCount = zstring.tonumber(_ED.no_read_mail_cont)
	elseif _ED.no_read_mail_cont ~= nil and zstring.tonumber(_ED.no_read_mail_cont) == -1  then
		unreadEMailCount = 0 
	else
		local localCont = readKey(mKey)
		if localCont == nil or localCont == "" then
			localCont = "0"
		end 
		unreadEMailCount = zstring.tonumber(localCont)
	end 
	
	
	local emailButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_mail"), "Button")
	if emailButton ~= nil then
		if unreadEMailCount > 0 then
			createNotiticationEffectWidget(emailButton, "effect_3")
			if __lua_project_id==__lua_project_all_star then
				local each_Button1=tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_each"),"Button")
				createNotiticationEffectWidget(each_Button1, "effect_3")
				emailButton=tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_mail_0"), "Button")
				createNotiticationEffectWidget(emailButton, "effect_3")
			end
			if __lua_project_id==__lua_project_superhero then 
				local each_Button=tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_each"),"Button")
				createNotiticationEffectWidget(each_Button, "effect_3")
				emailButton=tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_mail_0"), "Button")
				createNotiticationEffectWidget(emailButton, "effect_3")
			end
			if __lua_project_id == __lua_king_of_adventure then
				local packButton=tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_pack"),"Button")
				createNotiticationEffectWidget(packButton, "effect_3")
				emailButton=tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_mail_0"), "Button")
				createNotiticationEffectWidget(emailButton, "effect_3")
			end
		else 
			cleanNotiticationEffectWidget(emailButton)
			if __lua_project_id == __lua_king_of_adventure then
				local packButton=tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_pack"),"Button")
				cleanNotiticationEffectWidget(packButton)
			end
		end
	end
	writeKey(mKey, unreadEMailCount)
end
-- END	~新邮件推送
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 精彩活动-首充奖励
local function notificationFirstRechargeRewardIsDraw()
	local targetLayer = nil
	if __lua_project_id == __lua_project_superhero 
		or __lua_project_id == __lua_project_koone then
		targetLayer = LuaClasses["MainWindowClass"]._uiLayer
	else
		targetLayer = LuaClasses["HomeClass"]._uiLayer
	end
	
	if PushNotificationCenterClass._firstRechargeRewardIsDraw == false or 
		targetLayer == nil then
		return
	end
	PushNotificationCenterClass._firstRechargeRewardIsDraw = false
	if zstring.tonumber(_ED.recharge_rmb_number) >0 and _ED.active_activity[4] ~= nil and tonumber(_ED.active_activity[4].activity_id) == 0 then
		local wonderfulActivityButton = tolua.cast(targetLayer:getWidgetByName("Button_exciting_activities"), "Button")
		createNotiticationWidget(wonderfulActivityButton)
		writeKey("fiRe", "1")
	else
		writeKey("fiRe", "0")
	end
end
-- END	~精彩活动-首充奖励
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 精彩活动-成长计划
local function notificationAccumulateReward()
	local targetLayer = nil
	if __lua_project_id == __lua_project_superhero 
		or __lua_project_id == __lua_project_koone then
		targetLayer = LuaClasses["MainWindowClass"]._uiLayer
	else
		targetLayer = LuaClasses["HomeClass"]._uiLayer
	end
	
	if PushNotificationCenterClass._accumulateReward == false or 
		targetLayer == nil then
		return
	end
	PushNotificationCenterClass._accumulateReward = false
	writeKey("aceRe", "0")
	
	local wonderfulActivityButton = tolua.cast(targetLayer:getWidgetByName("Button_exciting_activities"), "Button")
	if _ED.active_activity[27] ~= nil and zstring.tonumber(_ED.active_activity[27].activity_isReward) == 3 then
		local activity = _ED.active_activity[27]
		for i, v in pairs(activity.activity_Info) do
			if tonumber(v.activityInfo_isReward) == 0 then
				if tonumber(_ED.user_info.user_grade) >= tonumber(v.activityInfo_need_day) then
					createNotiticationWidget(wonderfulActivityButton)
					writeKey("aceRe", "1")
					return
				end
			end
		end
	end
end
-- END	~精彩活动-成长计划
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 精彩活动-限时领袖
local function notificationTimeLimitLeader()
	local targetLayer = nil
	if __lua_project_id == __lua_project_superhero 
		or __lua_project_id == __lua_project_koone then
		targetLayer = LuaClasses["MainWindowClass"]._uiLayer
	else
		targetLayer = LuaClasses["HomeClass"]._uiLayer
	end
	
	if PushNotificationCenterClass._timeLimitLeader == false or 
		targetLayer == nil then
		return
	end
	PushNotificationCenterClass._timeLimitLeader = false
	writeKey("ltdTe", "0")
	
	local wonderfulActivityButton = tolua.cast(targetLayer:getWidgetByName("Button_exciting_activities"), "Button")
	if _ED.active_activity[25] ~= nil then
		local activity = _ED.active_activity[25]
		if tonumber(_ED.limit_bounty_init_info.bounty_free_state) ~= 1 then
			createNotiticationWidget(wonderfulActivityButton)
			writeKey("ltdTe", "1")
			return
		end
	end
end
-- END	~精彩活动-限时领袖
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 精彩活动-累计充值
local function notificationCumulativeRecharge()
	local targetLayer = nil
	if __lua_project_id == __lua_project_superhero 
		or __lua_project_id == __lua_project_koone then
		targetLayer = LuaClasses["MainWindowClass"]._uiLayer
	else
		targetLayer = LuaClasses["HomeClass"]._uiLayer
	end
	
	if PushNotificationCenterClass._cumulativeRecharge == false or 
		targetLayer == nil then
		return
	end
	PushNotificationCenterClass._cumulativeRecharge = false
	writeKey("aclerd", "0")
	local wonderfulActivityButton = tolua.cast(targetLayer:getWidgetByName("Button_exciting_activities"), "Button")
	if _ED.active_activity[7] ~= nil then
		local activity = _ED.active_activity[7]
		for i, v in pairs(activity.activity_Info) do
			if tonumber(v.activityInfo_isReward) == 0 then
				if tonumber(activity.total_recharge_count) >= tonumber(v.activityInfo_need_day) then
					createNotiticationWidget(wonderfulActivityButton)
					writeKey("aclerd", "1")
					return
				end
			end
		end
	end
end
-- END	~精彩活动-累计充值
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 精彩活动-累计消费
local function notificationCumulativeConsumption()
	local targetLayer = nil
	if __lua_project_id == __lua_project_superhero 
		or __lua_project_id == __lua_project_koone then
		targetLayer = LuaClasses["MainWindowClass"]._uiLayer
	else
		targetLayer = LuaClasses["HomeClass"]._uiLayer
	end
	
	if PushNotificationCenterClass._cumulativeConsumption == false or 
		targetLayer == nil then
		return
	end
	PushNotificationCenterClass._cumulativeConsumption = false
	writeKey("CieCoion", "0")
	local wonderfulActivityButton = tolua.cast(targetLayer:getWidgetByName("Button_exciting_activities"), "Button")
	if _ED.active_activity[17] ~= nil then
		local activity = _ED.active_activity[17]
		for i, v in pairs(activity.activity_Info) do
			if tonumber(v.activityInfo_isReward) == 0 then
				if tonumber(activity.total_recharge_count) >= tonumber(v.activityInfo_need_day) then
					createNotiticationWidget(wonderfulActivityButton)
					writeKey("CieCoion", "1")
					return
				end
			end
		end
	end
end
-- END	~精彩活动-累计消费
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 推送吃鸡
local function notificationDinnerInit()
	local targetLayer = nil
	if __lua_project_id == __lua_project_superhero 
		or __lua_project_id == __lua_project_koone then
		targetLayer = LuaClasses["MainWindowClass"]._uiLayer
	else
		targetLayer = LuaClasses["HomeClass"]._uiLayer
	end
	
	if PushNotificationCenterClass._dinnerInit == false  or 
		targetLayer == nil then
		return
	end
	
	local function notification()
		if targetLayer ~= nil then
			if tonumber(_ED._add_enger) > 0 then
				local wonderfulActivityButton = tolua.cast(targetLayer:getWidgetByName("Button_exciting_activities"), "Button")
				if createNotiticationWidget(wonderfulActivityButton) ~= nil then
					cc.UserDefault:getInstance():setStringForKey("canAdd", "1")
					writeKey("aEn", "1")
				end
			else
				cc.UserDefault:getInstance():setStringForKey("canAdd", "0")
			end
		end
	end
	
	local function responseAddEnergyStateCallback(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
			notification()
		end
	end
	
	PushNotificationCenterClass._dinnerInit = false
	writeKey("aEn", "0")
	if tonumber(_ED._add_enger) > 0 then
		notification()
	else
		Sender(protocol_command.dinner_init.code, nil, nil, nil, nil, responseAddEnergyStateCallback,-1)
	end
end
-- END	~吃鸡
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 领奖中心
local function notificationRewardCenter()
	if PushNotificationCenterClass._rewardCenterInit == false  or 
		LuaClasses["HomeClass"]._uiLayer == nil then
		return
	end
	
	local function notification()
		if LuaClasses["HomeClass"]._uiLayer ~= nil then
			LuaClasses["HomeClass"]._isRewardInitialize = false
			for i, v in pairs(_ED._reward_centre) do
				if v._reward_centre_id ~= nil then
					local rewardCentreButton = LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Panel_430")
					
					if rewardCentreButton ~= nil and rewardCentreButton.setVisible ~= nil then
						
					   rewardCentreButton:setVisible(true)
					   
					   if __lua_project_id == __lua_king_of_adventure then
							local rewardButton = LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_each")
							if rewardButton:getChildByTag(2) == nil then
								local tag = draw.drawTag() 
								rewardButton:addChild(tag)
								tag:setTag(2)
								local size = rewardButton:getContentSize()
								tag:setPosition(ccp(size.width*3/7, size.height/4))
							end
						end
					end
				end
			end
		end
	end
	
	local function responseRewardCentreCallback(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
			notification()
		end
	end
	--初始化领奖中心
	if PushNotificationCenterClass._rewardCenterInit == true then
		PushNotificationCenterClass._rewardCenterInit = false
		if _ED._reward_centre == nil or table.getn(_ED._reward_centre) <=0 then
			PushNotificationCenterClass.startTime = PushNotificationCenterClass.startTime or os.time()
			if (PushNotificationCenterClass.startTime  + 3) > os.time() then
				PushNotificationCenterClass._rewardCenterInit = true
				return
			end
			
			PushNotificationCenterClass.startTime = nil

			_ED._reward_centre = nil
			_ED._reward_centre = {}
			Sender(protocol_command.reward_center_init.code, nil, nil, nil, nil, responseRewardCentreCallback,-1)
		else
			notification()
		end
	end
end
-- END	~领奖中心
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 登陆签到
local function notificationLoginSignUp()
	if PushNotificationCenterClass._loginSignUpListener == false 
		or LuaClasses["HomeClass"]._uiLayer == nil then
		return
	end
	
	PushNotificationCenterClass._loginSignUpListener = false
	
	-- 绘制可签到的标识
	local activeItem = _ED.active_activity[24]									--活动实例
	if activeItem ~= nil 
		and zstring.tonumber(activeItem.activity_isReward) == 0 then
		local GiftBagAll = activeItem.activity_count								--记录用户等级礼包的总数量
		local activityLoginDay = zstring.tonumber(activeItem.activity_login_day)			--记录用户已连续登陆的天数
		local activityReward = activeItem.activity_Info[activityLoginDay+1]
		
		-- 是否有可领取的登陆签到奖励
		if activityReward ~= nil and zstring.tonumber(activityReward.activityInfo_isReward) == 0 then
			local signUpWindowButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_registration"), "Button")
			createNotiticationWidget(signUpWindowButton)

			if __lua_project_id == __lua_king_of_adventure then
				local rewardButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_each"), "Button")
				createNotiticationWidget(rewardButton)
			end
		end
	end
end
-- END	~登陆签到
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 神秘商店
local function notificationSecretShop()
	if PushNotificationCenterClass._secretShopInit == false  or 
		LuaClasses["HomeClass"]._uiLayer == nil then
		return
	end
	
	local function notification()
		if checkSecretShopRefreshTime() == false then
			writeSecretShopRefreshTime()
		else
			if LuaClasses["HomeClass"]._uiLayer ~= nil then
				if __lua_project_id ==__lua_project_all_star then
					local wonderfulActivityButton = tolua.cast(LuaClasses["MainWindowClass"]._uiLayer:getWidgetByName("Button_exciting_activities"), "Button")
					createNotiticationWidget(wonderfulActivityButton)
					writeKey("msrysp", "1")
				else	
					local wonderfulActivityButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_exciting_activities"), "Button")
					createNotiticationWidget(wonderfulActivityButton)
					writeKey("msrysp", "1")
				end	
				return true
			end
		end
		-- LuaClasses["HomeClass"].shopTime(0)
		return false
	end
	
	local function responseInitCallback(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
			notification()
		end
	end
	
	PushNotificationCenterClass._secretShopInit = false
	writeKey("msrysp", "0")
	if notification() == false then
		Sender(protocol_command.secret_shop_init.code, nil, nil, nil, nil, responseInitCallback,-1)
	end
end
-- END	~神秘商店
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 占星
local function notificationDivine()
	if PushNotificationCenterClass._divineInit == false  or 
		LuaClasses["HomeClass"]._uiLayer == nil then
		return
	end
	
	local function notification()
		if LuaClasses["HomeClass"]._uiLayer ~= nil then	
			local funOpenData = elementAt(funOpenCondition, 23)
			if funOpenData ~= nil and funOpenData:atoi(fun_open_condition.level) ~= nil then
				if zstring.tonumber(_ED.user_info.user_grade) >= funOpenData:atoi(fun_open_condition.level) then
					if LuaClasses["HomeClass"]._uiLayer ~= nil then
						if tonumber(_ED._astrology_list._as_remian_count) > 0 --[[and tonumber(_ED.user_info.user_grade) >= 35]] then
							
							local astrologyAltarButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_zhanxingtan"), "Button")
							if astrologyAltarButton:getChildByTag(1) == nil then
								local tag = draw.drawTag() 
								astrologyAltarButton:addChild(tag)
								tag:setTag(1)
								local size = astrologyAltarButton:getContentSize()
								tag:setPosition(ccp(size.width*3/7, size.height/4))
							end
							
							if __lua_project_id == __lua_king_of_adventure then
								local packButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_pack"), "Button")
								if packButton:getChildByTag(2) == nil then
									local tag = draw.drawTag() 
									packButton:addChild(tag)
									tag:setTag(2)
									local size = packButton:getContentSize()
									tag:setPosition(ccp(size.width*3/7, size.height/4))
								end
							end
							
							return 1
						else
							local astrologyAltarButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_zhanxingtan"), "Button")
							astrologyAltarButton:removeChildByTag(1)
							
							if __lua_project_id == __lua_king_of_adventure then
								local packButton = tolua.cast(LuaClasses["HomeClass"]._uiLayer:getWidgetByName("Button_pack"), "Button")
								packButton:removeChildByTag(2)
							end
						end
					end
					return 0
				end
			end
		end
		return -1
	end
	
	local function responseAstrologInitCallback(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
			notification()
		end
	end
	
	PushNotificationCenterClass._divineInit = false
	if notification() == 0 then
		Sender(protocol_command.divine_init.code, nil, nil, nil, nil, responseAstrologInitCallback,-1)
	end
end
-- END	~占星
-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- 初始化商店

local function responseShopVipViewCallback(_cObj, _tJsd)
	local pNode = tolua.cast(_cObj, "CCNode")
	local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
	if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
	end
end	

local function responseShopViewCallback(_cObj, _tJsd)
	local pNode = tolua.cast(_cObj, "CCNode")
	local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
	if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
	end
end		

local function initializeStore()
	if PushNotificationCenterClass._initializeStore == false then
		return
	end
	if _ED.return_number == nil or _ED.return_number == "" then
		--showConnecting()
		protocol_command.shop_view.param_list = 0
		Sender(protocol_command.shop_view.code, nil, nil, nil, nil, responseShopViewCallback,-1)
		return
	end
	if _ED.return_vip_number == nil or _ED.return_vip_number == "" then
		protocol_command.shop_view.param_list = 1
		Sender(protocol_command.shop_view.code, nil, nil, nil, nil, responseShopVipViewCallback,-1)
		return
	end
	if (_ED.return_number ~= nil and _ED.return_number ~= "" and _ED.return_vip_number ~= nil and _ED.return_vip_number ~= "") then
		PushNotificationCenterClass._initializeStore = false
		--hideConnecting()
	end
end
-- END	~初始化商店
-- ----------------------------------------------------------------------------------------------------

function PushNotificationCenterClass.resetAllPush()
	PushNotificationCenterClass._firstRechargeRewardIsDraw = true
	PushNotificationCenterClass._dinnerInit = true
	PushNotificationCenterClass._rewardCenterInit = true
	PushNotificationCenterClass._loginSignUpListener = true
	PushNotificationCenterClass._secretShopInit = true
	PushNotificationCenterClass._divineInit = true
	PushNotificationCenterClass._cumulativeRecharge = true
	PushNotificationCenterClass._accumulateReward = true
	PushNotificationCenterClass._timeLimitLeader = true
	PushNotificationCenterClass._cumulativeConsumption = true
	PushNotificationCenterClass._initializeStore = true
	PushNotificationCenterClass._newEmail = true
	PushNotificationCenterClass._CanComposeHero = true
	PushNotificationCenterClass._CanComposeEqument = true
end

function PushNotificationCenterClass:init()
	-- PushNotificationCenterClass._uiLayer = TouchGroup:create()
	-- self:addChild(PushNotificationCenterClass._uiLayer)
	
	-- local size = draw.size()
	
	-- PushNotificationCenterClass._widget = GUIReader:shareReader():widgetFromJsonFile("interface/generals_strengthen.json")
	-- PushNotificationCenterClass._uiLayer:addWidget(PushNotificationCenterClass._widget)
	
	local scheduler = CCDirector:sharedDirector():getScheduler()
	local schedulerEntry = nil
	
	local function pushListener()
	    notificationHero()
		notificationEqument()
		notificationNewEmail()
		notificationFirstRechargeRewardIsDraw()
		notificationDinnerInit()
		notificationRewardCenter()
		notificationLoginSignUp()
		notificationSecretShop()
		notificationDivine()
		notificationCumulativeRecharge()
		notificationTimeLimitLeader()
		notificationAccumulateReward()
		notificationCumulativeConsumption()
		initializeStore()
	end
	
	local function step(dt)
		if missionIsOver() == true then
			pushListener()
		end
	end
	
	local function onNodeEvent(event)
		if event == "enter" then	
			schedulerEntry = scheduler:scheduleScriptFunc(step, 1.5, false)
		elseif event == "exit" then
			if schedulerEntry ~= nil then
				scheduler:unscheduleScriptEntry(schedulerEntry)
				schedulerEntry = nil
			end
			PushNotificationCenterClass.resetAllPush()	
		end
	end
	local node = tolua.cast(self, "CCNode")
	node:registerScriptHandler(onNodeEvent)
end	

function PushNotificationCenterClass.create()
	local layer = LuaClasses["PushNotificationCenterClass"].super.extend(PushNotificationCenterClass, CCLayer:create())
    layer:init()
    return layer
end

function PushNotificationCenterClass.Draw()
	draw.graphics(PushNotificationCenterClass.create())
end
-- END
-- ----------------------------------------------------------------------------------------------------
