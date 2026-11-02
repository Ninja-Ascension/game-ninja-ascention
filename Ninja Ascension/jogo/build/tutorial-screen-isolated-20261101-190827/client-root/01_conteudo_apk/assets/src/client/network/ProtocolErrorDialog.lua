ProtocolErrorDialog = class("ProtocolErrorDialogClass", Window)

-- Las MISMAS condiciones con las que `onEnterTransitionFinish` reconecta y
-- reenvia la peticion (rama sin -5).
function fury_reintentara(request)
	if request == nil or request.protocol_datas == nil
		or _ED == nil or _ED.m_is_games ~= true
		or type(request.command) ~= "number" then
		return false
	end
	local code = request.protocol_datas[3]
	if code ~= "-3" and code ~= "-305" and code ~= "-306" then
		return false
	end
	return __lua_project_id == __lua_project_red_alert_time
		or __lua_project_id == __lua_project_pacific_rim
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
end

function ProtocolErrorDialog:ctor()
    self.super:ctor()
	self.request = nil
end

function ProtocolErrorDialog:onEnterTransitionFinish()
	if self.request~=nil and self.request.protocol_datas ~= nil 
		and (_ED ~= nil and _ED.m_is_games == true)
		and (self.request.protocol_datas[3] == "-3"
				or self.request.protocol_datas[3] == "-5"
				or self.request.protocol_datas[3] == "-305"
				or self.request.protocol_datas[3] == "-306"
			) then

		local str = ""..getVersion().."\r\n"
		str = str .. getApplicationName().."\r\n"
		str = str .. m_sOperationPlatformName.."\r\n"
		str = str .. getPlatformParam().."\r\n"

		-- cleanAllDataForAgainEnterGame()
		
		if __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
			or __lua_project_id == __lua_project_l_naruto 
			then
			-- NetworkAdaptor.reconnectSocket()
			-- -- local sendStr = NetworkProtocol.command_func(protocol_command.init_user_socket_service.code)
			-- -- NetworkAdaptor.socketSend(sendStr)
			if self.request.protocol_datas[3] == "-5" then
				state_machine.excute("logout_tip_window_open", 0, 0)
			else
				-- FURY: RECONECTAR SIN QUE EL JUGADOR TOQUE NADA.
				--
				-- El C2S 95 lleva ahora DELANTE del diagnostico de
				-- siempre el token que el servidor entrego en el S2C 327
				-- (`userLoginToken`, ProtocolParser.lua:1197) y el numero
				-- de servidor. Con esos dos campos el servidor puede
				-- volver a SENTAR la sesion de este jugador aunque la IP
				-- haya cambiado (wifi -> datos) o la sesion se haya
				-- muerto con el juego minimizado.
				--
				-- El `user_id` que ya viajaba NO sirve para esto: es
				-- publico (sale en la Arena y en las clasificaciones) y
				-- reatar por el dejaria robar la sesion de cualquiera.
				local server_number = ""
				if _ED.all_servers ~= nil and _ED.selected_server ~= nil
					and _ED.all_servers[_ED.selected_server] ~= nil then
					server_number = _ED.all_servers[_ED.selected_server].server_number
				end
				protocol_command.login_init_again.param_list =
					(userLoginToken == nil and "" or userLoginToken).."\r\n"
					..server_number.."\r\n"..str

				-- Y cuando vuelve bien, se cierra el cartel solo y se
				-- reenvia lo que el jugador habia pulsado. Eso es lo que
				-- le deja DONDE ESTABA en vez de en la pantalla de
				-- acceso; sin esto habria que darle a "continuar".
				local pending = self.request
				local function responseLoginInitAgain(response)
					-- El callback de la peticion se aparto en `reset` (ver
					-- `fury_reintentara`): corre UNA vez, con la respuesta del
					-- reenvio o, si la reconexion falla, con el fallo de antes.
					local handler = pending ~= nil and (pending.fury_handler or pending.handler) or nil
					if pending ~= nil then
						pending.fury_handler = nil
					end
					if not (response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0) then
						if pending ~= nil and handler ~= nil then
							handler(pending)
						end
						return
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("reconnect_view_window_close", 0, 0)
						NetworkView:reconnectErase(pending)
						-- El socket de juego saludo con el C2S 6101
						-- cuando todavia no habia sesion y se lo
						-- rechazaron: se vuelve a presentar.
						if NetworkAdaptor.socketIsOpen() == true then
							NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.init_user_socket_service.code))
						end
						if pending ~= nil and type(pending.command) == "number" then
							NetworkManager:register(pending.command,
													pending.url,
													pending.mode,
													pending.nType,
													pending.node,
													handler,
													pending.showWaitView,
													pending.timeOut,
													pending.unreconnect,
													pending.str,
													1)
						end
					end
				end
				NetworkManager:register(protocol_command.login_init_again.code, nil, nil, nil, nil, responseLoginInitAgain, false, nil)
				NetworkView:reconnectViewDisplay(self.request)
			end
		else
			protocol_command.login_init_again.param_list = str
			NetworkManager:register(protocol_command.login_init_again.code, nil, nil, nil, nil, nil, false, nil)
			NetworkView:reconnectViewDisplay(self.request)
		end
	end
	if self.request.protocol_datas[3] == "-4" then
		if config_operation.AccountManager == true then
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
			m_login_search_user = true
			if fwin:find("LoginClass") == nil then
				fwin:removeAll()
				fwin:reset(nil)
				fwin:open(Login:new(), fwin._view)
				fwin:close(fwin:find("ConnectingViewClass"))
			end
		end
	end

	if self.request.protocol_datas[3] ~= "-6" and self.request.protocol_datas[3] ~= "-21" and self.request.protocol_datas[3] ~= "-269" then
		local tipString = "";
		if #_lua_release_language_param > 1 then
			local str_index = ""..math.abs(zstring.tonumber(self.request.protocol_datas[3]))
			if _ED.errorCodeInfo ~= nil and _ED.errorCodeInfo[str_index] ~= nil then
				tipString = _ED.errorCodeInfo[str_index]
			else
				tipString = self.request.protocol_datas[4]
			end
		elseif __lua_project_id == __lua_project_adventure and zstring.tonumber(_game_platform_version_type) == 4 then  
			--在挖矿与冒险中 ,东南亚版本会取本地配置
			tipString = dms.string(dms["error_code"], math.abs(zstring.tonumber(self.request.protocol_datas[3])), error_code.infoCn)
		else
			-- tipString = self.request.protocol_datas[4]
			local str_index = ""..math.abs(zstring.tonumber(self.request.protocol_datas[3]))
			if _ED.errorCodeInfo ~= nil and _ED.errorCodeInfo[str_index] ~= nil then
				tipString = _ED.errorCodeInfo[str_index]
			else
				tipString = self.request.protocol_datas[4]
			end
		end

		if nil ~= self.request.protocol_datas[5] then
			tipString = string.format(tipString, self.request.protocol_datas[5])
		end

		-- 修改昵称，昵称太长的提示统一用弹窗
		if self.request.protocol_datas[3] == "-132" and fwin:find("SmPlayerChangeNickNameClass") ~= nil then
			app.load("client.l_digital.union.meeting.SmUnionTipsWindow")
            state_machine.excute("sm_union_tips_window_open", 0, {_new_interface_text[109], 2})
		else
			TipDlg.drawTextDailog(tipString)
		end
		
		
	-- else
		-- if self.request~=nil 
			-- and self.request.protocol_datas ~= nil 
			-- and self.request.protocol_datas[4] ~= nil 
			-- and self.request.protocol_datas[3] == "-54" then
				-- TipDlg.drawTextDailog(self.request.protocol_datas[4])
		-- end
	end
	if self.request.protocol_datas[3] == "-269" then
		handlePlatformRequest(0, LOGIN_AGAIN, "")
	end
	NetworkView:protocolErrorViewErase(self.request)
end

function ProtocolErrorDialog:onExit()

end

function ProtocolErrorDialog:reset(request)
	-- NetworkView:protocolErrorViewErase(self.request)
	self.request = request
	-- FURY: SI ESTE FALLO SE VA A REINTENTAR, SU CALLBACK NO CORRE AHORA.
	--
	-- `NetworkManager.updateRequestQueue` llama al callback de la peticion
	-- justo despues de abrir esta ventana (`parser_func` y luego `poll`), con
	-- el -3. Y `onEnterTransitionFinish` reconecta (C2S 95) y REENVIA la misma
	-- peticion con el MISMO callback: corria dos veces, primero con el fallo y
	-- luego con el exito. Los callbacks limpian su estado al fallar
	-- (`LPVENpc.lua:509-511` pone `_ED._scene_npc_id = ""`), asi que el exito
	-- del reenvio arrancaba el combate con el npc vacio y el cliente moria en
	-- `ClassInit.lua:160` (`ConfigDB.load("npc", "")`, VPS de Naruto, 2-oct
	-- 06:47, rol 2, tras el reinicio del servidor de las 06:17).
	-- Se aparta aqui, que es ANTES del `poll`; lo usa `responseLoginInitAgain`.
	if fury_reintentara(request) and request.handler ~= nil then
		request.fury_handler = request.handler
		request.handler = nil
	end
end
