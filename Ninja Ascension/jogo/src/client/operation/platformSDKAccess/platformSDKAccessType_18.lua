--渠道接入状态机（sdk初始化）
local platform_manager_sdk_init_terminal = {
    _name = "platform_manager_sdk_init",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		-- fwin:open(ConnectingView:new(), fwin._windows)
		handlePlatformRequest(0, params.messageType, params.messageText)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--渠道接入状态机（sdk初始化成功）
local platform_manager_sdk_init_success_terminal = {
    _name = "platform_manager_sdk_init_success",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if m_sUin == nil or m_sUin == "" then
			state_machine.excute("platform_manager_login_lose", 0, "platform_manager_login_lose.")
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--渠道接入状态机（打开sdk登录界面）
local platform_manager_open_sdk_interface_terminal = {
    _name = "platform_manager_open_sdk_interface",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--渠道接入状态机（登陆）
local platform_manager_login_terminal = {
    _name = "platform_manager_login",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		handlePlatformRequest(0, params.messageType, params.messageText)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--渠道接入状态机（登陆成功）
local platform_manager_login_success_terminal = {
    _name = "platform_manager_login_success",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local platformloginInfo = {
			platform_id=m_sOperationPlatformName,--平台id
			register_type="0", 				--注册类型
			platform_account=params.platformInfo,		--游戏账号
			nickname="Guest",					--注册昵称
			password="123456",					--注册密码
			is_registered = false }
		_ED.user_platform = {}
		_ED.default_user = platformloginInfo.platform_account
		_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
		fwin:close(fwin:find("ConnectingViewClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--渠道接入状态机（登陆失败）
local platform_manager_login_lose_terminal = {
    _name = "platform_manager_login_lose",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local platformloginInfo = {
			platform_id="",				--平台id
			register_type="", 				--注册类型
			platform_account="",		--游戏账号
			nickname="",					--注册昵称
			password="",					--注册密码
			is_registered = false
		}
		_ED.user_platform = {}
		_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
		_ED.default_user = platformloginInfo.platform_account
		fwin:close(fwin:find("ConnectingViewClass"))
		state_machine.excute("platform_manager_login", 0, { messageType = LOGIN ,messageText = ""})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--渠道接入状态机（请求支付）
local platform_request_for_payment_terminal = {
    _name = "platform_request_for_payment",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if m_channel_confirm == true then
			fwin:close(fwin:find("ConnectingViewClass"))
			TipDlg.drawTextDailog("该渠道暂时停止充值服务，请各位掌门见谅")
            state_machine.unlock("recharge_list_button")
			return
		end
        if state_machine.find("platform_check_the_order_to_refresh_the_list") ~= nil then
            state_machine.find("platform_check_the_order_to_refresh_the_list").platformParams = params
        end
		local money = dms.int(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.money)
		local goods_name = dms.string(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.goods_name)
		local game_money = dms.int(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.game_money)
		local goodsId = dms.string(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.id)
		local giveGold = nil
		if zstring.tonumber(_ED.recharge_precious_number) > 0 then
			giveGold = dms.int(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.get_of_bonus_gold)
		else
			giveGold = dms.int(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.get_of_first_gold)
		end
		local m_informUrlData = zstring.split(app.configJson.url,"iniServer")
		local m_informUrl = m_informUrlData[1].."pay/notifyPaPa.do"
		handlePlatformRequest(0, PLATFORMRECHARGE, _ED.recharge_result.recharge_id .."|"..money.."|"..goods_name..
		"|".._ED.user_info.user_gold.."|".._ED.vip_grade.."|".._ED.user_info.user_grade.."|".._ED.user_info.user_name..
		"|".._ED.user_info.user_id.."|".._ED.all_servers[_ED.selected_server].server_name.."|"..m_reqcharge_info.rechargeIndex..
		"|"..game_money.."|"..giveGold.."|"..goodsId.."|".._ED.all_servers[_ED.selected_server].server_number.."|"..m_informUrl)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--渠道接入状态机（支付成功）
local platform_the_success_of_payment_terminal = {
    _name = "platform_the_success_of_payment",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		--请求效验订单
		if state_machine.find("platform_check_the_order_to_refresh_the_list") ~= nil then
			state_machine.excute("platform_check_the_order_to_refresh_the_list", 0, "platform_check_the_order_to_refresh_the_list.")
		end
		if state_machine.find("lcheck_the_order_to_refresh_the_list") ~= nil then
			state_machine.excute("lcheck_the_order_to_refresh_the_list", 0, "lcheck_the_order_to_refresh_the_list.")
		end
		-- m_reqcharge_info = {}
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_the_roles_tracking_terminal = {
	_name = "platform_the_roles_tracking",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		handlePlatformRequest(0, CC_GAME_DAYA_TRACKING, _ED.user_info.user_id.."|".._ED.user_info.user_name.."|".._ED.user_info.user_grade.."|".._ED.selected_server.."|".._ED.all_servers[_ED.selected_server].server_name.."|".._ED.user_info.user_gold.."|".._ED.vip_grade)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_the_role_establish_terminal = {
	_name = "platform_the_role_establish",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		handlePlatformRequest(0, CC_ROLE_CREATION, params.names.."|".._ED.selected_server.."|".._ED.all_servers[_ED.selected_server].server_name.."|".._ED.user_info.user_id.."|".._ED.user_info.user_name)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_the_role_upgrade_terminal = {
	_name = "platform_the_role_upgrade",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		handlePlatformRequest(0, CC_GAME_DAYA_TRACKING, _ED.user_info.user_id.."|".._ED.user_info.user_name.."|".._ED.user_info.user_grade.."|".._ED.selected_server.."|".._ED.all_servers[_ED.selected_server].server_name.."|".._ED.user_info.user_gold.."|".._ED.vip_grade)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_the_score_start_terminal = {
	_name = "platform_the_score_start",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		handlePlatformRequest(0, CC_SCORE_START, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_the_score_start_terminal = {
	_name = "platform_the_score_start",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if __lua_project_id == __lua_project_adventure then
			handlePlatformRequest(0, CC_SCORE_START, "")
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


local platform_the_open_fans_page_terminal = {
	_name = "platform_the_open_fans_page",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if _fans_page_url ~= nil then
			handlePlatformRequest(0, CC_OPEN_FANS_PAGE, _fans_page_url)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_the_request_share_terminal = {
	_name = "platform_the_request_share",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		handlePlatformRequest(0, CC_SHARE_REQUEST, _share_text)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_the_share_success_terminal = {
	_name = "platform_the_share_success",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		protocol_command.share_game.param_list = "1"
		NetworkManager:register(protocol_command.share_game.code,nil,nil, nil, nil, nil, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local platform_push_request_terminal = {
	_name = "platform_push_request",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		-- params.pushid  本地推送的id
		-- params.delayTime  本地推送的延迟时间
		if _app_push_notification ~= nil and _app_push_notification ~= "" then
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if _ED.app_push_number[tonumber(params.pushid)] == nil or _ED.app_push_number[tonumber(params.pushid)] == "" then
					_ED.app_push_number[tonumber(params.pushid)] = {}
					_ED.app_push_number[tonumber(params.pushid)].number = 1
				else
					_ED.app_push_number[tonumber(params.pushid)].number = _ED.app_push_number[tonumber(params.pushid)].number + 1
				end
			end
			local str = ""
			if zstring.tonumber(params.delayTime) == 0 then
				if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local push_number_id = 0
					if params.push_number_id ~= nil and params.push_number_id ~= "" then
						push_number_id = _ED.app_push_number[tonumber(params.pushid)][tonumber(params.push_number_id)].pushid
					end
					if params.system_push_text == nil or params.system_push_text == "" then
						str = str.._app_push_notification[params.pushid][1].."|".._app_push_notification[params.pushid][2].."|".._app_push_notification[params.pushid][3].."|"..tonumber(params.pushid)*10+push_number_id
					else
						str = str.._app_push_notification[params.pushid][1].."|"..params.system_push_text.."|".._app_push_notification[params.pushid][3].."|"..tonumber(params.pushid)*10+push_number_id
					end
				else
					str = str.._app_push_notification[params.pushid][1].."|".._app_push_notification[params.pushid][2].."|".._app_push_notification[params.pushid][3].."|"..params.pushid
				end
			else
				--给一个时间如:153000,得到今天15:30:00的时间戳 
				function getPushIntervalByTimes( m_time )
					local temp = os.date("*t",m_time)

					local m_month 	= string.format("%02d", temp.month)
					local m_day 	= string.format("%02d", temp.day)
					local m_hour 	= string.format("%02d", temp.hour)
					local m_min 	= string.format("%02d", temp.min)
					local m_sec 	= string.format("%02d", temp.sec)


					local timeString = temp.year .."-".. m_month .."-".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec
					return m_hour,m_min,m_sec
				end
				local ph,pmi,ps = getPushIntervalByTimes(zstring.tonumber(params.delayTime))
				local delayDay = math.floor((zstring.tonumber(params.delayTime)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/3600/24)
				if delayDay < 0 then
					return
				end
				-- 1：转换时间为时分秒
				_app_push_notification[params.pushid][1] = ""
				-- 2：将转换的时间拼接成12-30-10的格式
				_app_push_notification[params.pushid][1] = ph.."-"..pmi.."-"..ps
				-- 3：将app_push_notification[params.pushid][1]替换成转换好的时间
				if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local push_number_id = 0
					if params.push_number_id ~= nil and params.push_number_id ~= "" then
						push_number_id = _ED.app_push_number[tonumber(params.pushid)][tonumber(params.push_number_id)].pushid
					end
					if params.system_push_text == nil or params.system_push_text == "" then
						str = str.._app_push_notification[params.pushid][1].."|".._app_push_notification[params.pushid][2].."|"..delayDay.."|"..tonumber(params.pushid)*10+push_number_id
					else
						str = str.._app_push_notification[params.pushid][1].."|"..params.system_push_text.."|"..delayDay.."|"..tonumber(params.pushid)*10+push_number_id
					end
				else
					str = str.._app_push_notification[params.pushid][1].."|".._app_push_notification[params.pushid][2].."|".._app_push_notification[params.pushid][3].."|"..params.pushid
				end
				
			end
			handlePlatformRequest(0, CC_GET_PUSH_NOTIFICATION, str)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--获取信号强度和网络延时
local platform_get_signal_strength_and_network_delay_time_ms_terminal = {
    _name = "platform_get_signal_strength_and_network_delay_time_ms",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if _ED.all_servers[_ED.selected_server] == nil then
        else
            local link = zstring.split(_ED.all_servers[_ED.selected_server].server_link,":")
            if _ED.signal_strength ~= 0 and _ED.network_delay_time_ms ~= 0 then
                local scheduler = cc.Director:getInstance():getScheduler()
                local schedulerID = nil
                if network_delay_update_times ~= nil then
                    schedulerID =  scheduler:scheduleScriptFunc(function ()
                        handlePlatformRequest(0, CC_GET_SIGNAL_AND_NETWORK, link[1])
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)      
                    end,network_delay_update_times,false) 
                else
                    schedulerID =  scheduler:scheduleScriptFunc(function ()
                        handlePlatformRequest(0, CC_GET_SIGNAL_AND_NETWORK, link[1])
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)      
                    end,300,false) 
                end
            else
                handlePlatformRequest(0, CC_GET_SIGNAL_AND_NETWORK, link[1])
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--本地推送的基础固定时间的
local platform_push_fixed_request_terminal = {
    _name = "platform_push_fixed_request_terminal",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local system_local_push_list = cc.UserDefault:getInstance():getStringForKey("system_local_push_list")
        if system_local_push_list == nil or system_local_push_list == "" then
            showId = {}
            system_local_push_list = ""
            for i, v in pairs(_app_push_notification) do
                if showId[tonumber(v[4])] == nil then
                    showId[tonumber(v[4])] = {}
                    showId[tonumber(v[4])].id = v[4]
                    showId[tonumber(v[4])].name = v[5]
                end
            end
            for i, v in pairs(showId) do
                if i == #showId then
                    system_local_push_list = system_local_push_list.."0"
                else
                    system_local_push_list = system_local_push_list.."0"..","
                end
            end
            cc.UserDefault:getInstance():setStringForKey("system_local_push_list", system_local_push_list)
            cc.UserDefault:getInstance():flush()
        end
        local push_list_info = zstring.split(system_local_push_list ,",")
        for i=1, #_app_push_notification do
            --print("qweqweqw=="..push_list_info[tonumber(_app_push_notification[i][4])])
            if tonumber(push_list_info[tonumber(_app_push_notification[i][4])]) == 0 then
                local _app_delayTime = 0
                if _app_push_notification[i][3] ~= "?" then
                    local t = os.time() + _ED.time_add_or_sub

                    function getTimeStamp(t)
                        return os.date("%Y|%m|%d",t)
                    end
                    local newTime = getTimeStamp(t)
                    local timeInfo = zstring.split(newTime, "|")
                    local pushTime = zstring.split(_app_push_notification[i][1], "-")
                    _app_delayTime = os.time({day=zstring.tonumber(timeInfo[3]), month=zstring.tonumber(timeInfo[2]), year=zstring.tonumber(timeInfo[1]), hour=zstring.tonumber(pushTime[1]), minute=zstring.tonumber(pushTime[2]), second=0}) - _ED.GTM_Time
                    -- _app_delayTime = 0
                    if tonumber(_app_push_notification[i][3]) == 5 or tonumber(_app_push_notification[i][3]) == 8 then
                        local isPush = false
                        local intervalData = {}
                        if tonumber(_app_push_notification[i][3]) == 5 then
                            intervalData = zstring.split(dms.string(dms["union_fight_config"], 5, union_fight_config.param), "|")[1]
                        elseif tonumber(_app_push_notification[i][3]) == 8 then
                            intervalData = zstring.split(dms.string(dms["camp_duel_config"], 1, camp_duel_config.param), "|")[1]
                        end
                        local server_time = _ED.system_time + (os.time() - _ED.native_time)
                        for i, v in pairs(intervalData) do
                            if zstring.tonumber(v) == zstring.tonumber(os.date("%w",zstring.tonumber(server_time) - _ED.GTM_Time)) then
                                isPush = true
                            end
                        end
                        if isPush == true then
                            state_machine.excute("platform_push_request", 0, { pushid = i , delayTime=_app_delayTime})
                        end
                    else
                        state_machine.excute("platform_push_request", 0, { pushid = i , delayTime=_app_delayTime})
                    end
                end
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- Add state to app state machine manager
state_machine.add(platform_manager_sdk_init_terminal)
state_machine.add(platform_manager_sdk_init_success_terminal)
state_machine.add(platform_manager_login_terminal)
state_machine.add(platform_manager_login_success_terminal)
state_machine.add(platform_manager_login_lose_terminal)
state_machine.add(platform_request_for_payment_terminal)
state_machine.add(platform_the_success_of_payment_terminal)
state_machine.add(platform_manager_open_sdk_interface_terminal)
state_machine.add(platform_the_roles_tracking_terminal)
state_machine.add(platform_the_role_establish_terminal)
state_machine.add(platform_the_role_upgrade_terminal)
state_machine.add(platform_the_score_start_terminal)
state_machine.add(platform_the_open_fans_page_terminal)
state_machine.add(platform_the_request_share_terminal)
state_machine.add(platform_the_share_success_terminal)
state_machine.add(platform_push_request_terminal)
state_machine.add(platform_get_signal_strength_and_network_delay_time_ms_terminal)
state_machine.add(platform_push_fixed_request_terminal)
-- ~end for jar-world platfom account manager state machine.
-- --------------------------------------------------------

-- Initialize all state machine for game platform account manager.
state_machine.init()
-- ~end
-- ----------------------------------------------------------------------------