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
            register_type="0",              --注册类型
            platform_account=params.platformInfo,       --游戏账号
            nickname="Guest",                   --注册昵称
            password="123456",                  --注册密码
            is_registered = false }
        _ED.user_platform = {}
        _ED.default_user = platformloginInfo.platform_account
        _ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
        fwin:close(fwin:find("ConnectingViewClass"))
        fwin:close(fwin:find("platformSDKLoginMoveClass"))
        -- 登录成功后的处理
        state_machine.excute("log_in_your_own_account_system", 0, "log_in_your_own_account_system.")

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
            platform_id="",             --平台id
            register_type="",               --注册类型
            platform_account="",        --游戏账号
            nickname="",                    --注册昵称
            password="",                    --注册密码
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
        mRecharge_index_local = m_reqcharge_info.rechargeIndex

        -- 存储服务器订单编号
        if _ED.recharge_result.recharge_id ~= nil then
            writeKey("mRecharge_server_order", "".._ED.recharge_result.recharge_id)
        end

        _ED.curRechargeType = tonumber(_ED.curRechargeType)

        if _ED.curRechargeType == nil then
            _ED.curRechargeType = tonumber(m_sPayMould)
        end
       
        -- RECARGA POR NAVEGADOR (variante l_dragonball).
        --
        -- El SDK t4 que atendia PLATFORMRECHARGE ya no viaja en el APK:
        -- `handlePlatformRequest` acaba en `app.lua_bridge:call` y lo unico
        -- que sale es el dialogo de Google Play «no se ha podido encontrar
        -- el elemento que intentabas comprar». Este juego no tiene
        -- facturacion de Google; se cobra en la web de pagos (PayPal,
        -- Wompi y Xsolla, `tools/pagos/`).
        --
        -- El pedido del C2S 69 YA quedo anotado antes de llegar aqui, y al
        -- volver del navegador basta con pulsar otra vez un paquete: ese
        -- mismo C2S 69 barre y acredita lo que la pasarela haya marcado
        -- pagado (`fury_login_session:pending_top_up_parsers/1`). Aqui solo
        -- hay que llevar al jugador a la pagina.
        --
        -- La direccion sale de `payUrl` (configs/app.config). Para pruebas
        -- locales `tools/configure_client_local.ps1` la reescribe al PC.
        --
        -- Si no esta, se usa la de produccion TAL CUAL, sin deducirla del
        -- `url` del servidor de juego. Deducirla no vale: la web de pagos
        -- vive en https://fury.ryzengames.com (nginx del VPS, certificado de
        -- Let's Encrypt), no en el host:puerto del servidor de juego, y de
        -- una IP no sale un dominio.
        --
        -- Esta rama es la que salva al APK que YA esta instalado: su
        -- app.config no lleva `payUrl` y NO se puede dar por hecho que una
        -- actualizacion en caliente lo cambie, porque app.config se lee en
        -- `app.lua` antes de que las rutas de busqueda incluyan la carpeta
        -- donde cae lo descargado. El fichero Lua si se recarga (`app.reload`
        -- en AssetsUpdate.lua:67), asi que la URL buena tiene que estar aqui.
        --
        -- `role_id` ata lo que se pague al personaje correcto y `gear` abre
        -- la pagina directamente en el escalon que se acaba de pulsar.
        -- LA PAGINA DE FURY, CON EL PEDIDO YA HECHO.
        --
        -- Antes se abria `index.php?role_id=..&gear=..`, que es la pagina
        -- GENERICA del portal: pedia elegir personaje -enseñando los de
        -- todos los jugadores-, volvia a preguntar que paquete cuando el
        -- jugador ya lo habia elegido dentro del juego, y sacaba un boton
        -- de pago de PRUEBA. Reportado por Victor jugando.
        --
        -- La pagina de Fury es `webpay/fury.php` y solo necesita el
        -- NUMERO DE PEDIDO: de el saca el escalon, el precio y el
        -- personaje, asi que no hay nada que elegir ni nada que teclear.
        -- El pedido lo acaba de crear el servidor (C2S 69) y esta unas
        -- lineas mas arriba, en `_ED.recharge_result.recharge_id`.
        --
        -- `payUrl` de app.config se respeta SOLO si alguien la ha
        -- reescrito para pruebas locales
        -- (`tools/configure_client_local.ps1`); si apunta al portal de
        -- produccion se ignora, porque la buena es esta.
        local pedido = nil
        if _ED.recharge_result ~= nil
            and _ED.recharge_result.recharge_id ~= nil then
            pedido = tostring(_ED.recharge_result.recharge_id)
        end

        local payUrl = app.configJson.payUrl
        if payUrl == nil or payUrl == ""
            or string.find(payUrl, "ryzengames.com", 1, true) ~= nil then
            -- Ninja Revolution (2-oct): su propia pagina; nunca la de Fury, que acredita
            -- en el servidor de Fury. Mientras no exista, no se puede pagar (beta cerrada).
            -- NinjaAscension: never the original company's payment page.
            payUrl = (tostring(app.configJson.url or ""):gsub("/iniServer.*$", "")) .. "/pagamento"
        end

        -- Y EN QUE IDIOMA ESTA JUGANDO, para que la pagina de pago no sea
        -- el unico sitio del juego que no habla su idioma. Si llega uno
        -- que la pagina no conoce, ella misma cae al ingles.
        local idioma = cc.UserDefault:getInstance():getStringForKey("current_language", "")
        if idioma == nil or idioma == "" or idioma == "0" then
            idioma = m_curr_choose_language
        end

        if pedido ~= nil and pedido ~= "" and pedido ~= "0" then
            payUrl = payUrl .. "?order_id=" .. pedido
            if idioma ~= nil and idioma ~= "" and idioma ~= "0" then
                payUrl = payUrl .. "&lang=" .. tostring(idioma)
            end
        else
            -- Sin pedido no hay nada que cobrar: se cae a la forma vieja
            -- para no dejar al jugador en una pagina muerta, y la pagina
            -- de Fury ya sabe decir «abre la recarga desde dentro del
            -- juego» en vez de aceptar un pedido inventado.
            payUrl = payUrl .. "?role_id=" .. _ED.user_info.user_id ..
                "&gear=" .. m_reqcharge_info.rechargeIndex
        end
        -- Es `cocos2d::Application::openURL`, del propio motor (esta en
        -- libjts.so como `lua_cocos2dx_Application_openURL`), no del SDK.
        -- Es lo mismo que usa el icono de YouTube de la ciudad
        -- (activity/fans_extension/FansExtensionWindow.lua:65-67).
        if cc.Application:getInstance().openURL then
            cc.Application:getInstance():openURL(payUrl)
        end

		if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
			jttd.facebookAPPeventSlogger("7")
		end
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
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
			if state_machine.find("platform_check_the_order_to_refresh_the_list") ~= nil then
				state_machine.excute("platform_check_the_order_to_refresh_the_list", 0, "platform_check_the_order_to_refresh_the_list.")
			end
		else
			local function responseGetServerListCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("refresh_single_recharge_interface_list", 0, 0)
                    m_reqcharge_info.prevRechargeIndex = nil
                    cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "-1")
                    cc.UserDefault:getInstance():flush()
                end
            end
            
            _ED.recharge_result.recharge_id = _ED.recharge_result.recharge_id or m_reqcharge_info.prevRechargeIndex
            protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n"..OperatorNameConfig[app.configJson.OperatorName].."_"..app.configJson.PackageName.."\r\n"..m_platform_app_ptext            
            NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--渠道接入状态机（支付成功app）
local platform_the_success_of_payment_app_terminal = {
    _name = "platform_the_success_of_payment_app",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local rechargeCell = params._rechargeCell
		local value = m_platform_app_value
		local pText = m_platform_app_ptext
        local specialpid = cc.UserDefault:getInstance():getStringForKey("paySpecialpid")
		local function responseGetServerListCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "-1")
                cc.UserDefault:getInstance():flush()
                for i=1, 6 do
                    handlePlatformRequest(0, VERIFY_RECEIPT_SOUCCESS, ""..value)
                end
				state_machine.excute("refresh_single_recharge_interface_list", 0, {_rechargeCell = response.node})
			end
			fwin:close(fwin:find("ConnectingViewClass"))
		end
		if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
		and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
			if pText~="" then
				local met = "p"
				met = met..value
				local vzs = zstring.split(""..cc.UserDefault:getInstance():getStringForKey(met), "|")
				cc.UserDefault:getInstance():flush()
				if _ED.selected_server ~= vzs[3] then
                    handlePlatformRequest(0, VERIFY_RECEIPT_SOUCCESS, ""..value)
					return
				end
                local iDentity = tonumber(value)+1
                local specialpid = cc.UserDefault:getInstance():getStringForKey("paySpecialpid")
                cc.UserDefault:getInstance():flush()
                if zstring.tonumber(specialpid) == 10 then
                    iDentity = 10
                end
				if table.getn(vzs) > 1 then
					protocol_command.vali_top_up_order_number.param_list = ""..vzs[1].."\r\n"..iDentity.."\r\n".."AppStore".."\r\n"..pText
				else
					protocol_command.vali_top_up_order_number.param_list = "".._ED.user_info.user_id.."\r\n"..iDentity.."\r\n".."AppStore".."\r\n"..pText
				end
				if rechargeCell~=nil then
					NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
				else
					NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
				end
			end
			NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
		end
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
		handlePlatformRequest(0, CC_GAME_DAYA_TRACKING, _ED.user_info.user_id.."|".._ED.user_info.user_name.."|".._ED.user_info.user_grade.."|".._ED.selected_server.."|".._ED.all_servers[_ED.selected_server].server_name.."|".._ED.user_info.user_gold)
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
		handlePlatformRequest(0, CC_ROLE_CREATION, params.names)
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
		handlePlatformRequest(0, CC_ROLE_UPGRADE, _ED.user_info.user_name.."|".._ED.user_info.user_grade)
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
        if params._datas == nil or params._datas == "" then
            handlePlatformRequest(0, CC_SHARE_REQUEST, _share_text)
        else
            handlePlatformRequest(0, CC_SHARE_REQUEST, params._datas._shareId.."|"..params._datas._shareStr)
        end
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
state_machine.add(platform_the_success_of_payment_app_terminal)
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