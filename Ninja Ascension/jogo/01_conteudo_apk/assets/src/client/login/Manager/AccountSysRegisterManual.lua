-- ----------------------------------------------------------------------------------------------------
-- 说明：手动注册界面
-------------------------------------------------------------------------------------------------------
AccountSysRegisterManual = class("AccountSysRegisterManualClass", Window)
local account_sys_register_manual_open_terminal = {
    _name = "account_sys_register_manual_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("AccountSysRegisterManualClass")
        if _window == nil then
            fwin:open(AccountSysRegisterManual:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(account_sys_register_manual_open_terminal)
state_machine.init()
    
function AccountSysRegisterManual:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
    
    -- 账号
    self._nameLocal = ""
    -- 密码
    self._passwordLocal = ""

    local function init_sm_player_change_nick_name_terminal()

        --注册并登录按钮
        local account_sys_register_manual_login_define_terminal = {
            _name = "account_sys_register_manual_login_define",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance == nil or instance.roots == nil or instance.roots[1] == nil then
                    return true
                end
                
                if config_operation.userPrivacyProtocol == true then
                    local userPrivacyProtocol = cc.UserDefault:getInstance():getStringForKey("platform_user_privacy_protocol", "")
                    if userPrivacyProtocol == nil or userPrivacyProtocol == "" then
                        app.load("client.login.Manager.AccountUserPrivacyProtocol")
                        state_machine.excute("account_user_privacy_protocol_open", 0, "")
                        return
                    end
                end
                local userName = zstring.exchangeTo(ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_3"):getString())
                local userPassword = zstring.exchangeTo(ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_4"):getString())
                local confirmPassword = zstring.exchangeTo(ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_4_0"):getString())
                local str = ""
                str = str..userName.."\r\n"--用户名
                str = str..userPassword.."\r\n"
                str = str..confirmPassword.."\r\n"
                if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
                    if OperatorPlatforNameConfig[app.configJson.PackageName] then
                        str = str..app.configJson.PackageName
                    end
                else
                    str = str..""
                end

                local function responseRegister(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            local _self = response.node
                            local nameLocal = _self._nameLocal
                            local passwordLocal = _self._passwordLocal

                            m_account_sys_user_name = nameLocal
                            m_account_sys_user_password = passwordLocal

                            if nameLocal and nameLocal ~= "" then
                                cc.UserDefault:getInstance():setStringForKey("name_local", tostring(nameLocal))
                            end
                            -- D12: la clave NO se guarda en el dispositivo; el login
                            -- de justo despues la toma de memoria y guarda el token.

                            local loginTimes = cc.UserDefault:getInstance():getStringForKey("login_times", "0")
                            if loginTimes ~= nil and loginTimes ~= "" then
                                loginTimes = tonumber(loginTimes) + 1
                                cc.UserDefault:getInstance():setStringForKey("login_times", tostring(loginTimes))
                            end

                            cc.UserDefault:getInstance():flush()

                            state_machine.excute("account_sys_register_manual_login", 0, "account_sys_register_manual_login.")
                        end
                    end
                end

                instance._nameLocal = userName
                instance._passwordLocal = userPassword

                protocol_command.platform_user_register.param_list = str
                NetworkManager:register(protocol_command.platform_user_register.code, app.configJson.url, nil, nil, instance, responseRegister, false, nil)      
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --登陆
        local account_sys_register_manual_login_terminal = {
            _name = "account_sys_register_manual_login",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance == nil or instance.roots == nil or instance.roots[1] == nil then
                    return true
                end

                local nameLocal = cc.UserDefault:getInstance():getStringForKey("name_local", "")
                -- D12: la clave recien registrada, de memoria (la puso arriba la
                -- respuesta del registro), no de "pass_local".
                local passLocal = m_account_sys_user_password or ""

                local function responseLogins(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            -- D12: se guarda el token del 327, no la clave.
                            app.load("client.login.Manager.AccountSysManager")
                            account_sys_remember_login(nameLocal)
                            app.load("client.login.Manager.AccountSysTips")
                            state_machine.excute("account_sys_tips_open", 0, account_sys_manager_tips[1])
                            state_machine.unlock("login_vali_register")
                            if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
                                jttd.facebookAPPeventSlogger("3|".._ED.default_user)
                                jttd.facebookAPPeventSlogger("12")
                            end
                            -- 注册账号
                            jttd.myDataSubmitted("4",_ED.default_user..","..nameLocal)
                            if app.configJson.OperatorName == "move" then
                                cc.UserDefault:getInstance():setStringForKey("moveLofinType", "3")
                                cc.UserDefault:getInstance():flush()
                            end
                            -- state_machine.excute("log_in_verify_special_account", 0, 0)
                            fwin:close(fwin:find("platformSDKLoginMoveClass"))
                            fwin:close(fwin:find("AccountSysRegisterManualClass"))
                            fwin:close(fwin:find("AccountSysManagerClass"))
                        end
                    end
                end
                
                if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
                    if app.configJson.OperationPlatformName == OperatorPlatforNameConfig[app.configJson.PackageName] then
                        protocol_command.platform_user_login.param_list = nameLocal.."\r\n"..passLocal.."\r\n"..app.configJson.PackageName
                    end
                else
                    protocol_command.platform_user_login.param_list = nameLocal.."\r\n"..passLocal.."\r\n"..""
                end
                NetworkManager:register(protocol_command.platform_user_login.code, app.configJson.url, nil, nil, instance, responseLogins, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --关闭
        local account_sys_register_manual_close_terminal = {
            _name = "account_sys_register_manual_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("AccountSysManagerClass") then
                    fwin:find("AccountSysManagerClass"):setVisible(true)
                end
                if instance ~= nil then
                    fwin:close(instance)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换自动注册
        local account_sys_register_manual_open_auto_register_terminal = {
            _name = "account_sys_register_manual_open_auto_register",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("account_sys_register_open", 0, "")
                fwin:close(fwin:find("AccountSysRegisterManualClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(account_sys_register_manual_login_define_terminal)
        state_machine.add(account_sys_register_manual_login_terminal)
        state_machine.add(account_sys_register_manual_close_terminal)
        state_machine.add(account_sys_register_manual_open_auto_register_terminal)
        state_machine.init()
    end
    
    init_sm_player_change_nick_name_terminal()
end


function AccountSysRegisterManual:onUpdataDraw()
	local root = self.roots[1]
    local name = ""
    local password = ""
    
    local TextField_3 = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_3")
    local TextField_4 = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_4")
    local TextField_4_0 = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_4_0")
    if app.configJson.OperatorName == "move" then
    else
        TextField_3:setString(name)
        TextField_4:setString(password)
        TextField_4_0:setString(password)
    end
    local keyboard_type = nil
    if app.configJson.OperatorName == "move" then
        keyboard_type = cc.EDITBOX_INPUT_FLAG_PASSWORD
    else
        keyboard_type = cc.KEYBOARD_RETURNTYPE_DONE
    end
    --账号
    local Panel_Account = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_Account")
    local textField1 = draw:addEditBoxEx(TextField_3, account_sys_manager_tips[9], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_1077"), 100, cc.KEYBOARD_RETURNTYPE_DONE)
    Panel_Account:addTouchEventListener(function ( sender, eventType )
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if textField1.touchDownAction ~= nil then
                textField1:touchDownAction(textField1, eventType)
            end
        end
    end)
    --密码
    local Panel_Password_1_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_Password_1_1")
    local textField2 = draw:addEditBoxEx(TextField_4, account_sys_manager_tips[10], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_1077"), 100, cc.KEYBOARD_RETURNTYPE_DONE, nil, nil, nil, nil, nil, keyboard_type)
    Panel_Password_1_1:addTouchEventListener(function ( sender, eventType )
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if textField2.touchDownAction ~= nil then
                textField2:touchDownAction(textField2, eventType)
            end
        end
    end)
    local Panel_Password_2_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_Password_2_1")
    local textField3 = draw:addEditBoxEx(TextField_4_0, account_sys_manager_tips[12], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_1077"), 100, cc.KEYBOARD_RETURNTYPE_DONE, nil, nil, nil, nil, nil, keyboard_type)
    Panel_Password_2_1:addTouchEventListener(function ( sender, eventType )
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if textField3.touchDownAction ~= nil then
                textField3:touchDownAction(textField3, eventType)
            end
        end
    end)
end

function AccountSysRegisterManual:onEnterTransitionFinish()
    local csbUserInfo = csb.createNode("login/register/register_prompt_13.csb")
    self:addChild(csbUserInfo)
    local root = csbUserInfo:getChildByName("root")
    table.insert(self.roots, root)
    
    self:onUpdataDraw()

    --退出
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),nil, 
    {
        terminal_name = "account_sys_register_manual_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --注册
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1077"),nil, 
    {
        terminal_name = "account_sys_register_manual_login_define",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --切换自动注册
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zdcj"),nil, 
    {
        terminal_name = "account_sys_register_manual_open_auto_register",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)
end

function AccountSysRegisterManual:onExit()
end
