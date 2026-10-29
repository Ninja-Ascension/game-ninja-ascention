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
        local open_Id = params.platformInfo

        if open_Id == nil or open_Id == "" then
            open_Id = cc.UserDefault:getInstance():getStringForKey("m_sdk_user_openID", "")
        end

		local platformloginInfo = {
			platform_id=m_sOperationPlatformName,--平台id
			register_type="0", 				--注册类型
			platform_account=open_Id,		--游戏账号
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
		local money = dms.string(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.money)
        local goods_name = dms.string(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.goods_name)
        local game_money = dms.string(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.game_money)
        local goodsId = dms.string(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.id)

        mRecharge_index_local = m_reqcharge_info.rechargeIndex


        -- 订单校验队列
        _ED.order_verification_queue = {}

        -- 存储服务器订单编号
        if _ED.recharge_result.recharge_id ~= nil then
            writeKey("mRecharge_server_order", "".._ED.recharge_result.recharge_id)
        end

        if RechargeTypeConfig[app.configJson.PackageName] == 1 then -- web充值
            -- DSC web充值 和 PMC web充值
            -- PASARELA DE TERCEROS RETIRADA (19-sep-2026).
            --
            -- Aqui se armaba a mano la direccion de appwebpay_page de
            -- pay.vlegames.com con el id de aplicacion, la cuenta de la
            -- plataforma, el nombre del jugador, su rol y su servidor, y
            -- se abria en el navegador. Este juego NO cobra por ahi: el
            -- camino vivo es `platformSDKAccessType_36.lua` -el que carga
            -- este paquete por `SdkNameConfig["t4"] = "t4-quick"`-, que
            -- abre la web de pagos propia con el numero de pedido.
            --
            -- Lo unico que se abre ahora es la direccion que mande el
            -- SERVIDOR en la respuesta del pedido (`webPayUrl`). Si no la
            -- manda no se abre nada: no queda destino de terceros al que
            -- caer.
            if _ED.recharge_result.webPayUrl then
                handlePlatformRequest(0, CC_OPEN_URL_LAYOUT, _ED.recharge_result.webPayUrl)
            end
        elseif RechargeTypeConfig[app.configJson.PackageName] == 0 then -- 官方充值
            if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
                handlePlatformRequest(0, PLATFORMRECHARGE,(tonumber(m_reqcharge_info.rechargeIndex) - 1))
            else
                local sendStr = PackageRechargeDatas[app.configJson.PackageName][tonumber(m_reqcharge_info.rechargeIndex)].."|"..app.configJson.PackageName.."|".._ED.recharge_result.recharge_id
                writeKey("mRecharge_info_to_suppoter", sendStr)

                -- 开始谷歌充值
                isStartGooglePay = true
                isStartPayFail = false

                -- 底层调起充值前打开转圈
                if nil == fwin:find("ConnectingViewClass") then
                    -- 开始谷歌充值转圈
                    isStartPayCircle = true
                    fwin:open(ConnectingView:new(), fwin._system)
                end

                fwin:addService({
                    callback = function ( params )
                        if isStartPayCircle == true then
                            isStartPayCircle = false
                            fwin:close(fwin:find("ConnectingViewClass"))
                            local function showConfirmTip(instance)
                                googlePayNetworkTipWindows = nil
                            end
                            
                            app.load("client.utils.ConfirmTip")
                            googlePayNetworkTipWindows = ConfirmTip:new()
                            googlePayNetworkTipWindows:init(instance, showConfirmTip, tipStringInfo_pay_tips[1], nil, nil, nil, nil)
                            fwin:open(googlePayNetworkTipWindows, fwin._windows)
                        end
                    end,
                    delay = 10,
                    params = nil
                })

                handlePlatformRequest(0, PLATFORMRECHARGE, sendStr)
            end
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
            _ED.order_verification_queue = _ED.order_verification_queue or {}

            -- purchase_info
            -- 档位|包名|充值订单号|华为inAppPurchaseData|华为inAppPurchaseDataSignature
            -- |华为inAppPurchaseData|华为inAppPurchaseDataSignature
            local purchaseInfo = params.purchase_info
            if purchaseInfo == nil then
                return
            end

            local inAppPurchaseData = nil

            local inAppPurchaseDataStr = zstring.split(purchaseInfo, "|")[4]
            if inAppPurchaseDataStr == nil or inAppPurchaseDataStr == "" then
                inAppPurchaseDataStr = zstring.split(purchaseInfo, "|")[2]
            end

            if inAppPurchaseDataStr ~= nil and inAppPurchaseDataStr ~= "" then
                inAppPurchaseData = json.decode(inAppPurchaseDataStr)          
            end

            if inAppPurchaseData ~= nil then
                -- 订单交易状态 -1：初始化 0：已购买 1：已取消 2：已退款
                if tonumber(inAppPurchaseData.purchaseState) == 0 then
                    -- 华为订单号
                    local orderId = inAppPurchaseData.orderId

                    -- 数据去重处理
                    local isRepeat = false
                    for _, v in pairs(_ED.order_verification_queue) do
                        if tonumber(orderId) == tonumber(v.inAppPurchaseData.orderId) then
                            isRepeat = true
                            break
                        end
                    end

                    if isRepeat == false then
                        table.insert(_ED.order_verification_queue, {inAppPurchaseData = inAppPurchaseData, inAppPurchaseDataStr = inAppPurchaseDataStr, verifyState = 0})
                    end
                end
            end

            -- 去校验订单
            state_machine.excute("platform_the_success_of_payment_app", 0, "platform_the_success_of_payment_app.")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


--渠道接入状态机（支付成功app，校验订单）
local platform_the_success_of_payment_app_terminal = {
    _name = "platform_the_success_of_payment_app",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local order_info = _ED.order_verification_queue[1]

        -- 校验状态 0：未校验 1：正在校验
        if order_info == nil or order_info.verifyState == 1 then
            return
        end

        -- 开始校验
        order_info.verifyState = 1
        local inAppPurchaseData = order_info.inAppPurchaseData
        local inAppPurchaseDataStr = order_info.inAppPurchaseDataStr

        state_machine.lock("recharge_list_button")
        fwin:open(ConnectingView:new(), fwin._windows)

        local userId = _ED.user_info.user_id
        -- 支付token
        local purchaseToken = inAppPurchaseData.purchaseToken or " "
        -- 华为订单号
        local orderId = inAppPurchaseData.orderId or " "
        -- 档位
        local productId = inAppPurchaseData.productId or " "
        -- 游戏订单号
        local server_order = inAppPurchaseData.developerPayload or " "

        local huaweiPurchaseInfo = productId.."|"..app.configJson.PackageName.."|"..server_order.."|"..purchaseToken.."|"..orderId


        local function responseGetServerListCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                state_machine.excute("refresh_single_recharge_interface_list", 0, 0)
                m_reqcharge_info.prevRechargeIndex = nil
                cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "-1")
                cc.UserDefault:getInstance():flush()

                if server_order ~= nil and server_order ~= "" then
                    writeKey("mRecharge_server_order", ""..server_order)
                end

                NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)

                handlePlatformRequest(0, SEND_PURCHASE_INFO, productId .. "|" .. inAppPurchaseDataStr)
            else
                -- TipDlg.drawTextDailog(tipStringInfo_pay_tips[3])
            end

            state_machine.unlock("recharge_list_button")
            fwin:close(fwin:find("ConnectingViewClass"))

            -- 校验完成，删除第一个校验的订单
            if _ED.order_verification_queue ~= nil then
                table.remove(_ED.order_verification_queue, 1)
            end
            -- 去校验下一个订单
            state_machine.excute("platform_the_success_of_payment_app", 0, "platform_the_success_of_payment_app.")
        end

        protocol_command.vali_top_up_order_number.param_list = ""..userId.."\r\n"..server_order.."\r\n"..app.configJson.OperatorName.."\r\n"..huaweiPurchaseInfo
        NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
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
-- ~end for jar-world platfom account manager state machine.
-- --------------------------------------------------------

-- Initialize all state machine for game platform account manager.
state_machine.init()
-- ~end
-- ----------------------------------------------------------------------------