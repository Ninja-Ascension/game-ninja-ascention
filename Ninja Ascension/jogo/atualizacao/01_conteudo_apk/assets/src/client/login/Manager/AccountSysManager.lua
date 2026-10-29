-- ----------------------------------------------------------------------------------------------------
-- 说明：自己的账号管理界面
-------------------------------------------------------------------------------------------------------
AccountSysManager = class("AccountSysManagerClass", Window)
local account_sys_manager_open_terminal = {
    _name = "account_sys_manager_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("AccountSysManagerClass")
        if _window == nil then
            fwin:open(AccountSysManager:new(),fwin._ui)
        else
            state_machine.excute("account_sys_manager_update", 0, 0)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(account_sys_manager_open_terminal)
state_machine.init()

-- D12 (25-sep, decision de Victor, docs/systems/cuentas_token.md):
-- el dispositivo YA NO GUARDA LA CONTRASENA. Tras un 9002 bueno se guarda
-- el token que el servidor manda en el S2C 327 (ProtocolParser.lua:1197 lo
-- deja en `userLoginToken`) bajo "tok_local", y "pass_local" se vacia (asi
-- se limpia tambien la clave que guardaron las versiones anteriores). El
-- token viaja en el MISMO campo de la clave con el prefijo "@tk1:"; el
-- servidor lo revoca al cambiar la clave o desde la consola, y caduca.
ACCOUNT_SYS_TOKEN_PREFIX = "@tk1:"

function account_sys_valid_token(token)
    return type(token) == "string" and #token == 43
        and string.find(token, "^[%w%-_]+$") ~= nil
end

-- Tras un login de cuenta correcto: la cuenta y el token, nunca la clave.
function account_sys_remember_login(nameLocal)
    local ud = cc.UserDefault:getInstance()
    if nameLocal and nameLocal ~= "" then
        ud:setStringForKey("name_local", tostring(nameLocal))
    end
    if account_sys_valid_token(userLoginToken) then
        ud:setStringForKey("tok_local", userLoginToken)
    else
        ud:setStringForKey("tok_local", "")
    end
    ud:setStringForKey("pass_local", "")
    ud:flush()
end

-- Lo que va en el campo de la clave: lo escrito si hay algo; si no, el
-- token guardado de ESA cuenta.
function account_sys_login_secret(names, passwords)
    if passwords ~= nil and passwords ~= "" then
        return passwords
    end
    local ud = cc.UserDefault:getInstance()
    local token = ud:getStringForKey("tok_local", "")
    if account_sys_valid_token(token) and names == ud:getStringForKey("name_local", "") then
        return ACCOUNT_SYS_TOKEN_PREFIX .. token
    end
    return ""
end

-- Token rechazado (caducado o revocado): se olvida para no reintentarlo.
function account_sys_forget_token()
    cc.UserDefault:getInstance():setStringForKey("tok_local", "")
    cc.UserDefault:getInstance():flush()
end

function AccountSysManager:ctor()
    self.super:ctor()
   	self.actions = {}
    self.roots = {}

    app.load("client.login.Manager.AccountSysRegister")
    -- 账号
    self._nameLocal = ""
    -- 密码
    self._passwordLocal = ""

	
    local function init_sm_player_change_nick_name_terminal()
        --登陆
        local account_sys_manager_login_define_terminal = {
            _name = "account_sys_manager_login_define",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance == nil or instance.roots == nil or instance.roots[1] == nil then
                    return true
                end

                local account_name = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1")
                local account_password = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_2")
                local names = zstring.exchangeTo(account_name:getString())
                local passwords = zstring.exchangeTo(account_password:getString())
                -- NinjaAscension: the saved token only works for the automatic
                -- login (called with a string param); the Login button always
                -- needs name and password.
                if type(params) ~= "string" and (names == "" or passwords == "") then
                    TipDlg.drawTextDailog("Nome de usuário ou senha incorretos.")
                    return true
                end
                -- D12: campo vacio = el token guardado de esta cuenta.
                passwords = account_sys_login_secret(names, passwords)

                local function responseLogins(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            local _self = response.node
                            local nameLocal = _self._nameLocal
                            local passwordLocal = _self._passwordLocal

                            m_account_sys_user_name = nameLocal
                            m_account_sys_user_password = passwordLocal

                            -- D12: se guarda el token del 327, no la clave.
                            account_sys_remember_login(nameLocal)

                            app.load("client.login.Manager.AccountSysTips")
                            state_machine.excute("account_sys_tips_open", 0, account_sys_manager_tips[1])
                            state_machine.unlock("login_vali_register")
                            
                            -- state_machine.excute("log_in_verify_special_account", 0, 0)
                            fwin:close(fwin:find("platformSDKLoginMoveClass"))
                            fwin:close(fwin:find("AccountSysManagerClass"))
                        end
                    elseif response.RESPONSE_SUCCESS and response.node ~= nil then
                        -- D12: el token guardado ya no vale (-68: caducado,
                        -- revocado o clave cambiada). Se olvida, y la ventana
                        -- que el login automatico escondio (onUpdataDraw) vuelve
                        -- a verse para escribir la clave; si no, el jugador se
                        -- quedaba sin ventana y sin boton flotante.
                        local _self = response.node
                        local usado = _self._passwordLocal
                        if response.PROTOCOL_STATUS == -68 and type(usado) == "string"
                            and string.sub(usado, 1, #ACCOUNT_SYS_TOKEN_PREFIX) == ACCOUNT_SYS_TOKEN_PREFIX then
                            account_sys_forget_token()
                        end
                        if fwin:find("AccountSysManagerClass") == _self then
                            _self:setVisible(true)
                        end
                    end
                end
                if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
                    if app.configJson.OperationPlatformName == OperatorPlatforNameConfig[app.configJson.PackageName] then
                        protocol_command.platform_user_login.param_list = names.."\r\n"..passwords.."\r\n"..app.configJson.PackageName
                    end
                else
                    protocol_command.platform_user_login.param_list = names.."\r\n"..passwords.."\r\n"..""
                end

                instance._nameLocal = names
                instance._passwordLocal = passwords

                NetworkManager:register(protocol_command.platform_user_login.code, app.configJson.url, nil, nil, instance, responseLogins, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --注册
        local account_sys_manager_register_terminal = {
            _name = "account_sys_manager_register",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
	                instance:setVisible(false)
	                app.load("client.login.Manager.AccountSysRegister")
	                state_machine.excute("account_sys_register_open", 0, "account_sys_register_open.")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --自动登陆
        local account_sys_manager_login_automatic_terminal = {
            _name = "account_sys_manager_login_automatic",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local automatic = ccui.Helper:seekWidgetByName(instance.roots[1], "CheckBox_1")
                local m_boolen = automatic:isSelected()
                if m_boolen == true then
                    cc.UserDefault:getInstance():setStringForKey("account_automatic_login", "1")
                else
                    cc.UserDefault:getInstance():setStringForKey("account_automatic_login", "2")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭
        local account_sys_manager_close_terminal = {
            _name = "account_sys_manager_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local account_sys_manager_update_terminal = {
            _name = "account_sys_manager_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdataDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --进入账号找回
        local account_sys_manager_open_recovery_terminal = {
            _name = "account_sys_manager_open_recovery",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.login.Manager.AccountPasswordRecoveryWindow")
                state_machine.excute("account_password_recovery_window_open", 0, ".")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(account_sys_manager_login_define_terminal)
        state_machine.add(account_sys_manager_register_terminal)
        state_machine.add(account_sys_manager_close_terminal)
        state_machine.add(account_sys_manager_login_automatic_terminal)
        state_machine.add(account_sys_manager_update_terminal)
        state_machine.add(account_sys_manager_open_recovery_terminal)

        state_machine.init()
    end
    
    init_sm_player_change_nick_name_terminal()
end


function AccountSysManager:onUpdataDraw()
	local root = self.roots[1]
	local m_type = cc.UserDefault:getInstance():getStringForKey("account_automatic_login", "")
    if m_type==nil or m_type == "" then
        m_type = "1"
    end
    --2是选中1是未选中
    if tonumber(m_type) == 2 then
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setSelected(true)
    elseif tonumber(m_type) == 1 then
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setSelected(false)
    end
    local nameLocal = cc.UserDefault:getInstance():getStringForKey("name_local", "")
    local passLocal = cc.UserDefault:getInstance():getStringForKey("pass_local", "")
    if nameLocal and nameLocal ~= "" then 
        local account_name = ccui.Helper:seekWidgetByName(root, "TextField_1")
        local account_password = ccui.Helper:seekWidgetByName(root, "TextField_2")
        account_name:setString(nameLocal)
        account_password:setString(passLocal)

        if m_account_sys_floating_switch == false and tonumber(m_type) == 2 then
            if m_login_search_user == true then
            else
                self:setVisible(false)
                state_machine.excute("account_sys_manager_login_define", 0, "account_sys_manager_login_define.")
                m_login_search_user = true
            end
        else
            m_account_sys_floating_switch = false
        end
    
    else
        local account_name = ccui.Helper:seekWidgetByName(root, "TextField_1")
        local account_password = ccui.Helper:seekWidgetByName(root, "TextField_2")
        account_name:setString("")
        account_password:setString("")
    end
end

function AccountSysManager:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("login/register/register_prompt_1.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    --登陆
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_login"),nil, 
    {
        terminal_name = "account_sys_manager_login_define",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --注册
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_register"),nil, 
    {
        terminal_name = "account_sys_manager_register",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --自动登陆
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_1"),nil, 
    {
        terminal_name = "account_sys_manager_login_automatic",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    local Button_register_0 = ccui.Helper:seekWidgetByName(root, "Button_register_0")
    if Button_register_0 ~= nil then
        -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
            if app.configJson.OperatorName == "move" then
                Button_register_0:setVisible(true)
            else
                Button_register_0:setVisible(false)
            end
        -- else
            -- Button_register_0:setVisible(false)
        -- end
        -- 进入账号找回
        fwin:addTouchEventListener(Button_register_0,nil, 
        {
            terminal_name = "account_sys_manager_open_recovery",     
            terminal_state = 0, 
            isPressedActionEnabled = true
        },
        nil, 0)
    end
    local Button_close = ccui.Helper:seekWidgetByName(root, "Button_close")
    if Button_close ~= nil then
        fwin:addTouchEventListener(Button_close,nil, 
        {
            terminal_name = "account_sys_manager_close",     
            terminal_state = 0, 
            isPressedActionEnabled = true
        },
        nil, 0)
    end

    -- Salida de la ventana. register_prompt_1.csb NO declara ningun boton de
    -- cerrar (solo Button_login, Button_register y CheckBox_1), asi que al volver
    -- al login desde la partida esta ventana se quedaba puesta para siempre y
    -- tapaba el boton "Cambiar idiomas" del login, que es el UNICO sitio donde se
    -- cambia de idioma en esta variante.
    -- MEDIDO en LDPlayer (22-sep): quien se traga los toques NO es el Panel_13_3
    -- sino la ImageView Image_5_bg (1624x640) que lo cubre entera; con el oyente
    -- solo en Panel_13_3 no llegaba ni un evento. Por eso se engancha a los dos,
    -- al fondo visible primero. Tocar el fondo POR FUERA del marco Image_1_2
    -- (510x400) cierra, que es el mismo patron de MagicCardShop.lua:184
    -- (Panel_13_3) y QianNengSkillDescription.lua:130 (Image_5_bg).
    -- Entrar al juego sigue sin ser posible sin cuenta: login.lua:1685 deja
    -- bloqueado login_vali_register hasta que el login de cuenta responde bien
    -- (AccountSysManager.lua:82).
    local Image_1_2 = ccui.Helper:seekWidgetByName(root, "Image_1_2")
    if Image_1_2 ~= nil then
        local cerrarSiEsFuera = function (sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            local point = Image_1_2:convertToNodeSpace(sender:getTouchEndPosition())
            local size = Image_1_2:getContentSize()
            if point.x >= 0 and point.y >= 0
                and point.x <= size.width and point.y <= size.height then
                return
            end
            state_machine.excute("account_sys_manager_close", 0, "account_sys_manager_close.")
        end
        for i, nombre in pairs({"Image_5_bg", "Panel_13_3"}) do
            local fondo = ccui.Helper:seekWidgetByName(root, nombre)
            if fondo ~= nil then
                fondo:setTouchEnabled(true)
                fondo:addTouchEventListener(cerrarSiEsFuera)
            end
        end
    end

    --账号
    local Panel_Username = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_Username")
    local TextField_1 = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_1")
    local textField1 = draw:addEditBoxEx(TextField_1, account_sys_manager_tips[9], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_login"), 100, cc.KEYBOARD_RETURNTYPE_DONE)
    Panel_Username:addTouchEventListener(function ( sender, eventType )
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
    local Panel_Password = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_Password")
    local TextField_2 = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_2")
    local textField2 = draw:addEditBoxEx(TextField_2, account_sys_manager_tips[10], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_login"), 20, cc.KEYBOARD_RETURNTYPE_DONE, nil, nil, nil, nil, nil, cc.EDITBOX_INPUT_FLAG_PASSWORD)
    Panel_Password:addTouchEventListener(function ( sender, eventType )
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if textField2.touchDownAction ~= nil then
                textField2:touchDownAction(textField2, eventType)
            end
        end
    end)
    self:onUpdataDraw()
    jttd.facebookAPPeventSlogger("52")
    -- local function responseSearchCallback(response)
    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            
    --     else
    --         self:onUpdataDraw()
    --     end
    -- end
    -- NetworkManager:register(protocol_command.search_user_platform.code, app.configJson.url, nil, nil, nil, responseSearchCallback, false, nil)
end

function AccountSysManager:onExit()
end
