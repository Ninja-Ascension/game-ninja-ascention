----------------------------------------------------------------------------------------------------
-- 说明：账号悬浮窗
-------------------------------------------------------------------------------------------------------

AccountSysFloatingWindow = class("AccountSysFloatingWindowClass", Window)
    
function AccountSysFloatingWindow:ctor()
    self.super:ctor()
	self.roots = {}
	self.num = 0
	self.startTime = nil
	self.times = nil
    -- Initialize ChatStorage page state machine.
    local function init_account_sys_floating_window_terminal()
		--打开悬浮窗内容
		local account_sys_floating_open_terminal = {
            _name = "account_sys_floating_open",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	--左右移动
            	local Panel_register = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register")
            	local Image_1_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_2")
            	local Button_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1")

            	--如果坐标在上
            	if instance:getPositionY() < (fwin._height - app.baseOffsetY)/2 then
            		Panel_register:setPositionY(Panel_register._y+Image_1_2:getContentSize().height+Button_1:getContentSize().height)
            	else
            		Panel_register:setPositionY(Panel_register._y)
            	end

            	--如果坐标在左
            	if instance:getPositionX() > (fwin._width - app.baseOffsetX)/2 then
            		Panel_register:setPositionX(Panel_register._x-Image_1_2:getContentSize().width)
            	else
            		Panel_register:setPositionX(Panel_register._x)
            	end

            	if ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register"):isVisible() == false then
	            	ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register"):setVisible(true)
	            	if ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register_prompt_3") ~= nil then
		            	ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register_prompt_3"):setVisible(true)
		            end
	            	ccui.Helper:seekWidgetByName(instance.roots[1], "Text_3"):setString(m_account_sys_user_name)
                    -- La contrasena NO se ensena en claro (capturas, directos, alguien
                    -- mirando). Asteriscos fijos, no uno por letra, para no delatar
                    -- el largo; vacio si la cuenta no tiene. La copia de
                    -- AccountSysFloatingOneWindow.lua:49 ya ni la pintaba.
                    local clave = m_account_sys_user_password
                    if clave ~= nil and clave ~= "" then
                        clave = "******"
                    else
                        clave = ""
                    end
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_3_0"):setString(clave)
	            else
	            	ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register"):setVisible(false)
	            	if ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register_prompt_3") ~= nil then
		            	ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register_prompt_3"):setVisible(false)
		            end
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local account_sys_floating_switch_terminal = {
            _name = "account_sys_floating_switch",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local platformloginInfo = {
					platform_id="",
					register_type="",
					platform_account="",
					nickname="",		
					password="",
					is_registered = false
				}
				_ED.user_platform = {}
				_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
				_ED.default_user = platformloginInfo.platform_account
				m_sUin = ""
				handlePlatformRequest(0, LOGOUT, "")
				m_account_sys_floating_switch = true
				fwin:removeAll()
				fwin:reset(nil)
                protocol_command.search_user_platform.user_info_switch = true
				fwin:open(Login:new(), fwin._view)
				fwin:close(fwin:find("ConnectingViewClass"))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local account_sys_floating_reset_terminal = {
            _name = "account_sys_floating_reset",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	app.load("client.login.Manager.AccountSysResetPassword")
                state_machine.excute("account_sys_reset_password_open", 0, "account_sys_reset_password_open.")
                ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register"):setVisible(false)
                if ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register_prompt_3") ~= nil then
	                ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register_prompt_3"):setVisible(false)
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local account_sys_floating_hide_button_terminal = {
            _name = "account_sys_floating_hide_button",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register"):setVisible(false)
            	if ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register_prompt_3") ~= nil then
	            	ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_register_prompt_3"):setVisible(false)
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local account_sys_floating_open_GMMessage_terminal = {
            _name = "account_sys_floating_open_GMMessage",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local function responseGMCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.l_digital.player.SmPlayerSystemGMMessage")
                        state_machine.excute("sm_player_system_GM_message_page_open",0,"sm_player_system_GM_message_page_open.")
                        state_machine.excute("account_sys_floating_hide_button",0,"account_sys_floating_hide_button.")
                    end
                end
                NetworkManager:register(protocol_command.gm_message_init.code, nil, nil, nil, instance, responseGMCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
		
		state_machine.add(account_sys_floating_open_terminal)
		state_machine.add(account_sys_floating_switch_terminal)
		state_machine.add(account_sys_floating_reset_terminal)
		state_machine.add(account_sys_floating_hide_button_terminal)
		state_machine.add(account_sys_floating_open_GMMessage_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_account_sys_floating_window_terminal()
end

function AccountSysFloatingWindow:onUpdate(dt)
	-- NinjaAscension: no floating account button; account/logout live in
	-- Settings (Conta / Sair). The window stays alive for its terminals.
	self:setVisible(false)
	do return end
	-- El boton flotante vive en una capa por encima del juego, asi que se queda
	-- los toques de cualquier ventana que caiga debajo. Solo se ensena sobre la
	-- ciudad (HomeClass) o sobre el login (LoginClass); toda pantalla que cierra
	-- Home -- evento, cultivo, mazmorra, combate -- lo oculta.
	local function alaVista(clase)
		local ventana = fwin:find(clase)
		return ventana ~= nil and ventana:isVisible() == true
	end
	local sobreLaCiudad = alaVista("HomeClass") or alaVista("LoginClass")
	if sobreLaCiudad and fwin:find("AccountSysManagerClass") == nil and fwin:find("AccountSysRegisterClass") == nil and fwin:find("AccountSysResetPasswordClass") == nil then
		local times = math.ceil(os.time() - self.times)
		if times > 0 and self.startTime == times then
			self.startTime = times + 30
		end
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end

function AccountSysFloatingWindow:onEnterTransitionFinish()
    local csbAccountSysFloatingWindow = csb.createNode("login/register/register_prompt_3.csb")
    self:addChild(csbAccountSysFloatingWindow)
	local root = csbAccountSysFloatingWindow:getChildByName("root")
	table.insert(self.roots, root)
	self.times = os.time()
	self.startTime = math.ceil(os.time() - self.times) + 3
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Button_1"):getContentSize())
	
	ccui.Helper:seekWidgetByName(root, "Panel_20"):setVisible(true)

	local screenSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
	self.windowSize = screenSize
	local size = self:getContentSize()

	-- El boton solo puede quedarse pegado a un borde lateral: si se deja en medio
	-- de la pantalla acaba encima de los botones de las ventanas y les roba el
	-- toque. Vale para el arrastre y para la posicion guardada de antes.
	local bordeDerecho = (screenSize.width - size.width * app.scaleFactor) / app.scaleFactor
	local function pegarAlBorde(x)
		x = tonumber(x)
		if x == nil then
			return bordeDerecho
		end
		x = math.max(0, math.min(x, bordeDerecho))
		if x * 2 < bordeDerecho then
			return 0
		end
		return bordeDerecho
	end

	local function headLayerTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if ccui.TouchEventType.began == evenType then
			self.began_position = cc.p(self:getPosition())
		elseif evenType == ccui.TouchEventType.moved then
			local move_position = cc.p(self.began_position.x + (__mpoint.x - __spoint.x) / app.scaleFactor- fwin._x, self.began_position.y + (__mpoint.y - __spoint.y) / app.scaleFactor + 2*fwin._y)
			move_position.x = math.max(0, math.min(move_position.x, (screenSize.width - size.width * app.scaleFactor) / app.scaleFactor) - fwin._x)
			move_position.y = math.max(0, math.min(move_position.y, (screenSize.height - size.height * app.scaleFactor) / app.scaleFactor) - 2*fwin._y)
			self:setPosition(move_position)
			ccui.Helper:seekWidgetByName(root, "Panel_register"):setVisible(false)
			if ccui.Helper:seekWidgetByName(root, "Panel_register_prompt_3") ~= nil then
				ccui.Helper:seekWidgetByName(root, "Panel_register_prompt_3"):setVisible(false)
			end
		elseif ccui.TouchEventType.ended == evenType or
			ccui.TouchEventType.canceled == evenType then
			if math.abs( __epoint.y - __spoint.y) < 20 and math.abs( __epoint.x - __spoint.x) < 20 then
				state_machine.excute("account_sys_floating_open", 0, "account_sys_floating_open.'")
			end
			local currentAccount = ""
			local currentServerNumber = ""
			local saveKey = currentAccount..currentServerNumber.."accountSysFloating".."end"
			self:setPositionX(pegarAlBorde(self:getPositionX()))
			local x,y = self:getPosition()
			local str = x .. "," .. y .. "," .. "1"
			cc.UserDefault:getInstance():setStringForKey(saveKey, str)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_1"):addTouchEventListener(headLayerTouchEvent)
	local currentAccount = ""
	local currentServerNumber = ""
	local newPropTag = currentAccount..currentServerNumber.."accountSysFloating" .. "end"
	local data = cc.UserDefault:getInstance():getStringForKey(newPropTag)
	local temp = zstring.split(data, ",")
	if temp[1] ~= nil and temp[2] ~= nil then
		self:setPosition(cc.p(pegarAlBorde(temp[1]),temp[2]))
	else
		self:setPosition(cc.p(bordeDerecho,(screenSize.height/2 + size.height * app.scaleFactor) / app.scaleFactor))
	end
	if temp[3] == "1" then
		fwin:find("AccountSysFloatingWindowClass"):setVisible(true)
	elseif temp[3] == "2" then
		fwin:find("AccountSysFloatingWindowClass"):setVisible(true)
	end
	ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(true)

	--切换账号
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_switch"),nil, 
    {
        terminal_name = "account_sys_floating_switch",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --修改密码
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_modify"),nil, 
    {
        terminal_name = "account_sys_floating_reset",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --
    self.Panel_register_prompt_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_register_prompt_3"),nil, 
    {
        terminal_name = "account_sys_floating_hide_button",     
        terminal_state = 0
    },
    nil, 0)

    self.Panel_register_prompt_3:setVisible(false)
    local Button_contact_us = ccui.Helper:seekWidgetByName(root, "Button_contact_us")
    if Button_contact_us ~= nil then
	    if config_operation.gmMessageAndReply == true then
	    	if fwin:find("LoginClass") ~= nil then
	    		Button_contact_us:setVisible(false)
	    	else
		    	Button_contact_us:setVisible(true)
		    end
	    else
	    	Button_contact_us:setVisible(false)
	    end
	    fwin:addTouchEventListener(Button_contact_us,nil, 
	    {
	        terminal_name = "account_sys_floating_open_GMMessage",     
	        terminal_state = 0
	    },
	    nil, 0)
    end

    if fwin:find("AccountSysManagerClass") == nil and fwin:find("AccountSysRegisterClass") == nil and fwin:find("AccountSysResetPasswordClass") == nil then
    	self:setVisible(true)
    else
    	self:setVisible(false)
    end
    
    if __lua_project_id == __lua_project_onepiece then
        ccui.Helper:seekWidgetByName(root, "Button_switch"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_modify"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_contact_us"):setVisible(false)
    end

    if ccui.Helper:seekWidgetByName(self.roots[1], "Panel_register")._x == nil then
    	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_register")._x = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_register"):getPositionX()
    end

    if ccui.Helper:seekWidgetByName(self.roots[1], "Panel_register")._y == nil then
    	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_register")._y = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_register"):getPositionY()
    end
end

function AccountSysFloatingWindow:onExit()

end
