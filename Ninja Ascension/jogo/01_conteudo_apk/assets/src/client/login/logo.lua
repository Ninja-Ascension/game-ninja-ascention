Logo = class("LogoClass", Window)

function Logo:ctor()
    self.super:ctor()
    self.roots = {}
    self.exitLogo = false
    self.videoPlayer = nil
    self.waitTime = 3
	self.isMp4 = true
	app.load("configs.res.config")
    app.load("client.operation.Config")
    dms.load("data/mould/sound_effect_param.txt")
    -- Initialize logo page state machine.
    local function init_logo_terminal()
        local logo_check_assets_terminal = {
            _name = "logo_check_assets",
            _init = function (terminal)
                -- local terminal = state_machine.find("logo_check_assets")
                -- terminal._instance:scheduler("1", terminal._instance.inAssetsManagerExPage, 1, false)
                -- terminal._instance:addTimer(terminal._instance.inAssetsManagerExPage, 0, 10.6, false, nil)
				
                fwin:initAsyncImg("effect/effice_1500.png")

				app.load("data.TipStringInfo")
				app.load("client.utils.TipDraw")
				-- app.load("client.loader.LocalDatas")
				app.load("client.protocol.ProtocolParser")
                app.load("client.protocol.ProtocolCommander")
				app.load("client.loader.EnvironmentDatas")
				-- app.load("client.player.UserTopInfoA")
				
                NetworkProtocol.protocol_commands = protocol_command
                NetworkProtocol.protocol_parses = protocol_parse
				
				NetworkManager:registerUrl(app.configJson.url, app.configJson.wsurl)
				app.load("client.network.ConnectingView")
				app.load("client.network.ReconnectView")
				app.load("client.network.NetworkErrorDialog")
				app.load("client.network.ProtocolErrorDialog")
                NetworkView:register(ConnectingView:new(), nil, NetworkErrorDialog:new(), ProtocolErrorDialog:new())
                NetworkManager:registerKeepAlive(protocol_command.keep_alive.code, 180*2)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local targetPlatform = cc.Application:getInstance():getTargetPlatform()
				if targetPlatform == cc.PLATFORM_OS_WINDOWS and false then
                 --   localData()
					-- app.load("client.operation.Config")
					-- app.load("client.utils.shortcut")
					-- show game AssetsManagerEx page view.
					-- fwin:addBorder(nil) -- add frame window border.          
					fwin:reset()
					app.load("client.login.AssetsManager")
					-- app.load("client.loader.LocalDatas")
					-- localData_attack_logic()
					-- app.load("client.battle.BattleScene")
					-- app.load("client.mission.Mission")
					-- app.load("client.mission.tuition.TuitionController")
					
					-- fwin:open(AssetsManager:new(), fwin._view)
					
					-- terminal._state = 1 -- To login
					
					-- show game login page view.
					-- fwin:addBorder(nil) -- add frame window border.
					-- fwin:reset()
					app.load("client.login.login")
					fwin:open(Login:new(), fwin._view)
				else
					jttd.facebookAPPeventSlogger("51")
					instance:removeAllChildren(true)
                    -- app.load("client.utils.shortcut")
					-- app.load("client.operation.Config")
					app.load("client.assets.AssetsManager")
					-- app.load("client.loader.LocalDatas")
					-- localData_attack_logic()
					-- app.load("client.battle.BattleScene")
					fwin:open(AssetsManager:new(), fwin._background)
				end
				if fwin._x > 0 or fwin._y > 0 then
                	fwin:addBorder(csb.createNode("utils/adaptive_keep_out.csb"))
            	end
				return true
				
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local logo_activate_app_terminal = {
            _name = "logo_activate_app",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseActivateAppCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
					end
                end
                NetworkManager:register(protocol_command.activate_app.code, nil, nil, nil, nil, responseActivateAppCallback, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
				
		-- local open_exit_game_view_terminal = {
            -- _name = "open_exit_game_view",
            -- _init = function (terminal)
				-- app.load("client.utils.ExitGameView")
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				 -------------
				-- state_machine.excute("open_exit_game_view", 0, "event open_exit_game_view.")
				-------------------
				
				-- fwin:open(ExitGameView:new(), fwin._ui)
				-- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		local logo_stop_video_terminal = {
            _name = "logo_stop_video",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.videoPlayer ~= nil then
                	self.videoPlayer:stop()
                	self.videoPlayer = nil
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- state_machine.add(open_exit_game_view_terminal)
        state_machine.add(logo_check_assets_terminal)
		state_machine.add(logo_activate_app_terminal)
		state_machine.add(logo_stop_video_terminal)
        state_machine.init()
    end
    init_logo_terminal()
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
    	--默认播放一次,解决视频播放中,不点击屏幕,导致进入游戏会没有音效
    	ccexp.AudioEngine:play2d(formatMusicFile("button", 1), false, 0.01)
    end
end

function Logo:onUpdate (dt)
	if self.exitLogo == true then
		if platform_extras ~= "" then
			self.exitLogo = false
			state_machine.excute("logo_check_assets", 0, "change to 'AssetsManagerEx'")
		end
	end
	if self.videoPlayer ~= nil then
		self.waitTime = self.waitTime - dt
		if self.waitTime < 0 then
			if self.videoPlayer.isPlaying ~= nil and self.videoPlayer:isPlaying() == false then
				app.load("client.operation.Config")
				self.exitLogo = true
				sener:setVisible(false)
				self.videoPlayer = nil
			end
		end
	end
end

function Logo:onEnterTransitionFinish()
	local function addLogoCsb( ... )
	    local csbLogo = csb.createNode("login/logo.csb")
	    local root = csbLogo:getChildByName("root")
		table.insert(self.roots, root)
		-- 停止视频
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1"), nil, 
		{
			terminal_name = "logo_stop_video", 
	        terminal_state = 0, 
	        isPressedActionEnabled = false
		}, 
		nil, 0)

	    local action = csb.createTimeline("login/logo.csb")
	    self.action = action
	    -- action:setTimeSpeed(app.getTimeSpeed())
	    csbLogo:runAction(action)
	    action:gotoFrameAndPlay(0, action:getDuration(), false)
	    action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()

	        if str == "open" then
				state_machine.excute("logo_activate_app", 0, "logo_activate_app.")
	        elseif str == "exit" then
				if
				cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS and
						cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX
				and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
					if #_lua_release_language_param > 1 then
						local _current_language = cc.UserDefault:getInstance():getStringForKey("current_language", "")
						if _current_language ~= "" then
							m_curr_choose_language = _current_language
							app.setSearchPaths(_current_language)
						else
							-- Primera apertura: el idioma del movil que ya eligio setDefaultLanguage
							-- (solo si existe en multiLanguage); antes se pisaba con el primero de la lista.
							local primero = _lua_release_language_param[1]
							if m_curr_choose_language ~= nil and m_curr_choose_language ~= ""
								and config_res ~= nil and config_res.multiLanguage ~= nil
								and config_res.multiLanguage[m_curr_choose_language] ~= nil then
								primero = m_curr_choose_language
							end
							cc.UserDefault:getInstance():setStringForKey("current_language", primero)
							m_curr_choose_language = primero
							cc.UserDefault:getInstance():flush()
							app.setSearchPaths(primero)
						end
					else
						local _current_language = cc.UserDefault:getInstance():getStringForKey("current_language", "")
						if _current_language ~= "" then
							m_curr_choose_language = _current_language
							app.setSearchPaths(_current_language)
						else
							m_curr_choose_language = app.configJson.ReleaseLanguage
						end
					end
					-- 播放视频
					if self.isMp4 == false then
						app.load("client.operation.Config")
						self.exitLogo = true
					else
						local targetPlatforms = cc.Application:getInstance():getTargetPlatform()
						if __lua_project_id == __lua_project_gragon_tiger_gate 
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
							or (__lua_project_id == __lua_project_l_pokemon and app.configJson.ReleaseLanguage ~= "en")
							or (__lua_project_id == __lua_project_l_pokemon and app.configJson.ReleaseLanguage == "en"
								and (cc.PLATFORM_OS_IPHONE == targetPlatforms or cc.PLATFORM_OS_IPAD == targetPlatforms))
							or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
							or __lua_project_id == __lua_project_red_alert 
							or __lua_project_id == __lua_project_red_alert_time 
							or __lua_project_id == __lua_project_pacific_rim
							or __lua_project_id == __lua_project_warship_girl_b 
							or __lua_project_id == __lua_project_digimon_adventure 
							or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh 
							then
							local targetPlatform = cc.Application:getInstance():getTargetPlatform()
							if cc.PLATFORM_OS_IPHONE == targetPlatform
								or cc.PLATFORM_OS_ANDROID == targetPlatform
								or cc.PLATFORM_OS_IPAD == targetPlatform
								then
								local videoFullPath = cc.FileUtils:getInstance():fullPathForFilename("video/video.mp4")
								if cc.FileUtils:getInstance():isFileExist(videoFullPath) == true then
									local function onVideoEventCallback(sener, eventType)
										if eventType == ccexp.VideoPlayerEvent.PLAYING then
											-- print("PLAYING")
										elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
											-- print("PAUSED")
											app.load("client.operation.Config")
											self.exitLogo = true
											sener:setVisible(false)
											self.videoPlayer = nil
										elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
											-- print("STOPPED")
											app.load("client.operation.Config")
											self.exitLogo = true
											sener:setVisible(false)
											self.videoPlayer = nil
										elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
											-- print("COMPLETED")
											sener:stop()
											self.videoPlayer = nil
											if cc.PLATFORM_OS_ANDROID == targetPlatform then
												app.load("client.operation.Config")
												self.exitLogo = true
												sener:setVisible(false)
												self.videoPlayer = nil
											end
										end
									end
									if __lua_project_id == __lua_project_digimon_adventure 
										or __lua_project_id == __lua_project_naruto 
										or __lua_project_id == __lua_project_pokemon 
										or __lua_project_id == __lua_project_rouge 
										or __lua_project_id == __lua_project_yugioh 
										or __lua_project_id == __lua_project_warship_girl_b 
										then
										if ___is_open_video == false then 
											app.load("client.operation.Config")
											self.exitLogo = true
											return
										end
									end						    
									local videoPlayer = ccexp.VideoPlayer:create()
									local layerSize = self:getContentSize()
									videoPlayer:setAnchorPoint(cc.p(0, 0))
									local widgetSize = app.screenSize
									if __lua_project_id == __lua_project_warship_girl_a 
										or __lua_project_id == __lua_project_warship_girl_b 
										or __lua_project_id == __lua_project_digimon_adventure 
										or __lua_project_id == __lua_project_naruto 
										or __lua_project_id == __lua_project_pokemon 
										or __lua_project_id == __lua_project_rouge 
										or __lua_project_id == __lua_project_yugioh 
										then
										videoPlayer:setPosition(cc.p(app.baseOffsetX/2, layerSize.height/17))
										videoPlayer:setContentSize(cc.size(layerSize.width - app.baseOffsetX, layerSize.height - app.baseOffsetY))
									else
										videoPlayer:setPosition(cc.p(0, 0))
										-- videoPlayer:setContentSize(cc.size(layerSize.width - app.baseOffsetX, layerSize.height))
										videoPlayer:setContentSize(cc.size(layerSize.width, layerSize.height))
									end
									videoPlayer:addEventListener(onVideoEventCallback)
									self:addChild(videoPlayer, -1)
									self.videoPlayer = videoPlayer

									videoPlayer:setFileName(videoFullPath)   
									videoPlayer:play()
									-- videoPlayer:setFullScreenEnabled(true)
								else
									app.load("client.operation.Config")
									self.exitLogo = true
								end
							else
								app.load("client.operation.Config")
								self.exitLogo = true
							end
						else
							app.load("client.operation.Config")
							self.exitLogo = true
						end
					end
				else
					if #_lua_release_language_param > 1 then
						local _current_language = cc.UserDefault:getInstance():getStringForKey("current_language", "")
						if _current_language ~= "" then
							m_curr_choose_language = _current_language
							app.setSearchPaths(_current_language)
						else
							-- Primera apertura sin video: el idioma del movil, igual que la rama con video.
							local primero = _lua_release_language_param[1]
							if m_curr_choose_language ~= nil and m_curr_choose_language ~= ""
								and config_res ~= nil and config_res.multiLanguage ~= nil
								and config_res.multiLanguage[m_curr_choose_language] ~= nil then
								primero = m_curr_choose_language
							end
							cc.UserDefault:getInstance():setStringForKey("current_language", primero)
							m_curr_choose_language = primero
							cc.UserDefault:getInstance():flush()
							app.setSearchPaths(primero)
						end
					else
						local _current_language = cc.UserDefault:getInstance():getStringForKey("current_language", "")
						if _current_language ~= "" then
							m_curr_choose_language = _current_language
							app.setSearchPaths(_current_language)
						else
							m_curr_choose_language = app.configJson.ReleaseLanguage
							cc.UserDefault:getInstance():setStringForKey("current_language", m_curr_choose_language)
							cc.UserDefault:getInstance():flush()
							--debug.print_r(m_curr_choose_language,"m_curr_choose_language1111111111111=")
						end
					end
					state_machine.excute("logo_check_assets", 0, "change to 'AssetsManagerEx'")
				end
	        end
	    end)
	    -- assert(action:IsAnimationInfoExists("in") == true, "in animation didn't exist")
	    -- action:play("in", true)
	    self:addChild(csbLogo)
    end

 --    -- app.load("client.operation.Config")  
	-- local function responseGetServerListCallback(response)
 --        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 		local isPs = false
 --        	local result = cc.FileUtils:getInstance():isFileExist("language/ps/data/TipStringInfo.lua")
 --        	if _ED.all_servers ~= nil and table.nums(_ED.all_servers) == 1 then
 --            	for i,v in pairs(_ED.all_servers) do
 --            		if v ~= nil and zstring.tonumber(v.server_number)%1000 == 999 then
 --                		if result == true then
 --                    		app.setSearchPaths("ps")
	-- 						self.isMp4 = false
	-- 						isPs = true
 --                		end
 --            		end
 --        		end
 --        		addLogoCsb()
 --        	else
 --        		addLogoCsb()
	-- 		end
	-- 		if isPs == false then
	-- 			self:setSysLanguage()	--设置系统语言
	-- 			self:setDefaultLanguage() --设置默认语言
	-- 		end
	-- 	else
	-- 		if response.node._request_count < 2 then
	-- 			response.node._request_count = response.node._request_count + 1
	-- 			NetworkView:reconnectErase(nil)
 --    			NetworkManager:register(protocol_command.new_get_server_list.code, app.configJson.url, nil, nil, self, responseGetServerListCallback, false, nil)
	-- 		end
	-- 	end
	-- end
	-- --启动
	-- self._request_count = 0
	-- NetworkView:reconnectErase(nil)

	-- NetworkManager:register(protocol_command.new_get_server_list.code, app.configJson.url, nil, nil, self, responseGetServerListCallback, false, nil)
	-- -- jttd.myDataSubmitted("1","")


	-- 去除多余的 new_get_server_list 请求
	addLogoCsb()

	self:setSysLanguage()	--设置系统语言
	self:setDefaultLanguage() --设置默认语言
end
--设置系统语言
function Logo:setSysLanguage()
	local systemLanguage = tonumber(cc.Application:getInstance():getCurrentLanguage())
	-- El respaldo era CHINO SIMPLIFICADO: un movil en turco, indonesio o
	-- cualquier idioma que el motor no sabe nombrar entraba al juego en
	-- chino. El respaldo bueno es el INGLES, que es la base del juego.
	local languageStr = _lua_release_language_en
	if systemLanguage == cc.LANGUAGE_ENGLISH then
		languageStr = _lua_release_language_en
	elseif systemLanguage == cc.LANGUAGE_CHINESE then
		languageStr = _lua_release_language_zh_CN
	elseif systemLanguage == cc.LANGUAGE_FRENCH then
		languageStr = _lua_release_language_fr
	elseif systemLanguage == cc.LANGUAGE_ITALIAN then
		languageStr = _lua_release_language_it
	elseif systemLanguage == cc.LANGUAGE_GERMAN then
		languageStr = _lua_release_language_de
	elseif systemLanguage == cc.LANGUAGE_SPANISH then
		languageStr = _lua_release_language_es
	elseif systemLanguage == cc.LANGUAGE_RUSSIAN then
		-- Decia `_be` (bielorruso), que no es un idioma de este juego: un
		-- movil en ruso no encontraba carpeta y caia al ingles.
		languageStr = _lua_release_language_ru
	elseif systemLanguage == cc.LANGUAGE_KOREAN then
		languageStr = _lua_release_language_ko
	elseif systemLanguage == cc.LANGUAGE_JAPANESE then
		languageStr = _lua_release_language_ja
	elseif systemLanguage == cc.LANGUAGE_HUNGARIAN then
		languageStr = _lua_release_language_hu
	elseif systemLanguage == cc.LANGUAGE_PORTUGUESE then
		-- La carpeta que existe es `pt_BR`, no `pt`.
		languageStr = _lua_release_language_pt_BR
	elseif systemLanguage == cc.LANGUAGE_ARABIC then
		languageStr = _lua_release_language_ar
	end
	-- LOS CUATRO QUE EL MOTOR NO SABE NOMBRAR.
	--
	-- `getCurrentLanguage()` devuelve un enum de DOCE idiomas y nada mas.
	-- Turco, indonesio y filipino no estan en esa lista, asi que caen en
	-- el respaldo (ingles); y el chino no distingue simplificado de
	-- tradicional. Asi que se afina en dos pasos.
	--
	-- PASO 1: pedir el codigo ISO de verdad. Algunas versiones del motor
	-- exponen `getCurrentLanguageCode()`, que devuelve "tr", "id", "fil",
	-- "zh-Hant"... Va dentro de `pcall` A PROPOSITO: si este binario no
	-- lo trae, no pasa nada y se sigue con el paso 2. No se puede
	-- comprobar de otra forma -el .so viene despojado y no se puede
	-- inspeccionar-, asi que se intenta y se acepta que falle.
	local ok, code = pcall(function()
		return cc.Application:getInstance():getCurrentLanguageCode()
	end)
	if ok and type(code) == "string" and code ~= "" then
		code = string.lower(code)
		local porIso = {
			["tr"] = _lua_release_language_tr,
			["id"] = _lua_release_language_id,
			["in"] = _lua_release_language_id,   -- Android viejo dice "in"
			["fil"] = _lua_release_language_fil,
			["tl"] = _lua_release_language_fil,   -- tagalo
			["pt"] = _lua_release_language_pt_BR,
			["ru"] = _lua_release_language_ru,
			["es"] = _lua_release_language_es,
			["fr"] = _lua_release_language_fr,
			["de"] = _lua_release_language_de,
			["ko"] = _lua_release_language_ko,
			["vi"] = _lua_release_language_vi,
			["en"] = _lua_release_language_en,
		}
		-- El chino se decide por la ETIQUETA, que es lo unico fiable:
		-- "zh-hant", "zh-tw" y "zh-hk" son tradicional; el resto,
		-- simplificado.
		if string.sub(code, 1, 2) == "zh" then
			if string.find(code, "hant", 1, true)
				or string.find(code, "tw", 1, true)
				or string.find(code, "hk", 1, true)
				or string.find(code, "mo", 1, true) then
				languageStr = _lua_release_language_zh_TW
			else
				languageStr = _lua_release_language_zh_CN
			end
		else
			-- Primero la etiqueta entera ("fil"), luego las dos primeras
			-- letras ("tr" de "tr-TR").
			local elegido = porIso[code] or porIso[string.sub(code, 1, 2)]
			if elegido ~= nil then
				languageStr = elegido
			end
		end
	else
		-- PASO 2: sin codigo ISO, el enum ya ha dejado ENGLISH para todo
		-- lo que no conoce. Se desempata por HUSO HORARIO, que si esta
		-- disponible en Lua puro: Turquia +3, Indonesia +7, Filipinas +8.
		--
		-- Solo se aplica cuando el enum dijo ENGLISH, o sea cuando NO
		-- sabe: un movil de verdad en ingles (Reino Unido +0/+1, EEUU
		-- -5/-8, India +5:30) nunca cae en estos husos, asi que no se le
		-- cambia el idioma a nadie que lo tenga bien puesto.
		if languageStr == _lua_release_language_en then
			local okHuso, horas = pcall(function()
				return os.difftime(os.time(), os.time(os.date("!*t"))) / 3600
			end)
			if okHuso and type(horas) == "number" then
				horas = math.floor(horas + 0.5)
				if horas == 3 then
					languageStr = _lua_release_language_tr
				elseif horas == 7 then
					languageStr = _lua_release_language_id
				elseif horas == 8 then
					languageStr = _lua_release_language_fil
				end
			end
		end
	end

	m_system_default_language = languageStr
	--debug.print_r(m_system_default_language,"系统默认得到的m_system_default_language=")
end
--设置默认语言
function Logo:setDefaultLanguage()
	local currentLanguage = cc.UserDefault:getInstance():getStringForKey("current_language","0")
	--debug.print_r(currentLanguage,"当前选择的语言=")
	if currentLanguage == "0" then
		local configLanguage = app.configJson.ReleaseLanguage
		if #_lua_release_language_param > 1 then
			configLanguage = _lua_release_language_param[1]
		end
		-- EL IDIOMA DEL MOVIL MANDA LA PRIMERA VEZ.
		--
		-- Antes, la primera partida SIEMPRE arrancaba en el idioma de
		-- `ReleaseLanguage` aunque el telefono estuviera en otro: el
		-- juego ya detectaba el idioma del sistema (`setSysLanguage`,
		-- que corre justo antes de esta) y no hacia nada con el.
		--
		-- Solo se acepta si ese idioma EXISTE de verdad en
		-- `config_res.multiLanguage`; si no, se deja el de siempre y el
		-- respaldo final sigue siendo el ingles. Asi anadir un idioma
		-- nuevo lo activa solo, y quitarlo no deja a nadie sin carpeta.
		--
		-- Solo vale para la PRIMERA vez: en cuanto el jugador elige uno,
		-- `current_language` deja de ser "0" y su eleccion manda siempre.
		if m_system_default_language ~= nil
			and config_res ~= nil and config_res.multiLanguage ~= nil
			and config_res.multiLanguage[m_system_default_language] ~= nil then
			configLanguage = m_system_default_language
		end
		--debug.print_r(configLanguage,"默认配置的语言=")
		if configLanguage == nil or configLanguage == "" or configLanguage == "0" then
			configLanguage = _lua_release_language_en
		end
		cc.UserDefault:getInstance():setStringForKey("assets_download_url_"..configLanguage, "1")
--		cc.UserDefault:getInstance():setStringForKey("current_language", configLanguage)
		cc.UserDefault:getInstance():flush()
		currentLanguage = configLanguage
	end
	m_curr_choose_language = currentLanguage
	--debug.print_r(currentLanguage,"111111111111当前选择的语言=")
	local res_config_multiLanguage = config_res.multiLanguage
	local configJson = app.configJson
	if configJson.MultiLanguage and res_config_multiLanguage then
		table.merge(res_config_multiLanguage,configJson.MultiLanguage) --兼容app.config配置多语言
	end
	configJson.MultiLanguage = res_config_multiLanguage
end
function Logo:inAssetsManagerExPage()
    state_machine.excute("logo_check_assets", 0, "change to 'AssetsManagerEx'")
end

function Logo:onExit()
	self.videoPlayer = nil
	state_machine.remove("logo_check_assets")
	state_machine.remove("logo_activate_app")
	state_machine.remove("logo_stop_video")
end

return Logo:new()