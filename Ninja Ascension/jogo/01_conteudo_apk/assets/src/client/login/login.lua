Login = class("LoginClass", Window)
-- Fury: reloj con decimales para las trazas de la precarga (socket.core va
-- dentro de libjts.so); si no estuviera, os.time().
local fury_ok_reloj, fury_socket_core = pcall(require, "socket.core")
local fury_ahora = (fury_ok_reloj and type(fury_socket_core) == "table" and fury_socket_core.gettime) or os.time

-- Fury (2-oct): GAME START A LA PRIMERA. Con t4-quick, login_vali_register
-- gastaba el primer toque en el login del SDK (m_sdk_login_success == false):
-- pedia LOGIN, el adaptador local (ThirdpartySupporter.lua, local_sdk_adapter)
-- devolvia LOGIN_SUCCESS medio segundo despues y eso solo refrescaba la lista
-- de servidores; habia que volver a pulsar (y una tercera vez si el segundo
-- toque caia antes de ese medio segundo). Con el adaptador no hay SDK que
-- esperar: la cuenta ya la autentico el S2C 327 (m_sUin). El 327 ya hace lo
-- que hacia ese LOGIN_SUCCESS (usuario de plataforma y lista de servidores).
-- Sin 327 (m_sUin vacio) no se toca nada: sigue mandando la ventana de cuenta.
function fury_sdk_local_listo()
	if app.configJson.local_sdk_adapter == true and m_sUin ~= nil and m_sUin ~= "" then
		m_sdk_init_success = true
		m_sdk_login_success = true
	end
end

local server_state_closed_m1 		= -1	-- -1 关闭
local server_state_fluent_0 		= 0		-- 0 流畅
local server_state_new_1 			= 1		-- 1 新服
local server_state_maintain_2 		= 2		-- 2 维护
local server_state_recommend_3 		= 3		-- 3 推荐
local server_state_crowd_4 			= 4		-- 4 拥挤
local server_state_gremito_5 		= 5		-- 5 爆满 

app.load("client.player.UserTopInfoA")
app.load("configs.operation.config")

math.randomseed(tostring(os.time()):reverse():sub(1, 6))

function Login:ctor()
	local newWork = NetworkManager:peek()
	if newWork~= nil then
		newWork.queue = {}
	end
	cacher.remvoeUnusedArmatureFileInfoes()
	cc.Director:getInstance():purgeCachedData()
	
    self.super:ctor()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	
	self.roots = {}
	self.announcePage_state = 0
	self._isLoadLocalDataComplete = false
	self._isClickLoginEnterGame = false
	self.ArmatureNode_starting_up = nil
	self.ArmatureNode_playing = nil
	
	self.isShowData = true
	
	self.islogin = true

	-- 将系统语言设置为玩家选择的语言
	-- m_system_default_language = m_curr_choose_language
	
	fwin._bg_music_indexs = {}
	fwin._last_music = -1
	fwin._current_music = nil

	--活动缓存重置
	_ED.welcome_money = nil
	_ED.variety_shop_exchang_times = nil
	NetworkAdaptor.XMLHttpRequest.open_auto_reconnect = false
	-- 关闭SOCKET LINK
	NetworkAdaptor.socketClose()

	NetworkManager:registerKeepAlive(0, -1)

	table.clear(NetworkManager.queue)
		
	-- 解锁网络通讯序列号
	NetworkProtocol.lock = false
	-- if __lua_project_id == __lua_project_warship_girl_a 
	-- 	or __lua_project_id == __lua_project_warship_girl_b 
	-- 	or __lua_project_id == __lua_project_digimon_adventure 
	-- 	or __lua_project_id == __lua_project_naruto 
	-- 	or __lua_project_id == __lua_project_pokemon 
	-- 	or __lua_project_id == __lua_project_rouge 
	-- 	or __lua_project_id == __lua_project_yugioh 
	-- 	then
		app.unload("data.TipStringInfo")
	    app.unload("client.protocol.ProtocolCommander")
	    app.unload("client.protocol.ProtocolCommanderCopy")
	    app.unload("client.protocol.ProtocolCommanderCopyEx")
	    app.unload("client.protocol.ProtocolParser")
	    app.unload("client.protocol.ProtocolParserCopy")
	    app.unload("client.protocol.ProtocolParserCopyEx")
		app.unload("frameworks.external.utils.AudioUtil")

		app.load("data.TipStringInfo")
	    app.load("client.protocol.ProtocolCommander")
		app.load("client.protocol.ProtocolParser")
		app.load("frameworks.external.utils.AudioUtil")
		
	    NetworkProtocol.protocol_commands = protocol_command
	    NetworkProtocol.protocol_parses = protocol_parse
	-- end

	app.unload("configs.res.config")

	-- 重新加载配置文件
	app.unload("configs.platformConfig.config")
	app.load("configs.platformConfig.config")
	-- 充值文件
	if app.configJson.OperatorName == "huawei" then
		app.unload("client.operation.platformSDKAccess.platformSDKAccessType_35")
		app.load("client.operation.platformSDKAccess.platformSDKAccessType_35")
	elseif (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then 
		app.unload("client.operation.platformSDKAccess.platformSDKAccessType_36")
		app.load("client.operation.platformSDKAccess.platformSDKAccessType_36")
	else
		app.unload("client.operation.platformSDKAccess.platformSDKAccessType_0")
		app.load("client.operation.platformSDKAccess.platformSDKAccessType_0")
	end

	-- 打点文件
	app.unload("client.operation.jttd")
	app.load("client.operation.jttd")

	app.load("client.login.ServerManager")
	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		then
		if __lua_project_id == __lua_project_red_alert then
			app.load("configs.battle.config")
			app.load("client.red_alert.login.ServerManagers")
		else
			app.load("client.red_alert_time.login.ServerManagers")
			app.load("configs.operation.config")

			if true == config_operation._open_server_redirect_or_forward then
				NetworkProtocol.open_server_redirect_or_forward = true
			end
		end
		app.load("configs.csb.config")
		app.load("configs.sprite.config")
		app.load("client.loader.formula")
		app.load("configs.res.config")
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		app.load("configs.csb.config")
		app.load("configs.sprite.config")
		app.load("configs.res.config")
		app.load("client.utils.LoginOfOtherTip")
	end
	if #_lua_release_language_param > 1 then
		app.unload("data.TipStringInfo")
	end
	app.load("data.TipStringInfo")
	app.load("client.notification.push_notification_manager")
	app.load("client.login.PlatformManager")
	app.load("client.utils.Loading")
	app.load("client.utils.ActionUtils")
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
		or __lua_project_id == __lua_project_l_naruto
		then
		app.load("client.red_alert_time.utils.ServerPrompt")
		handlePlatformRequest(0, CC_SENT_INPUT_INFO, chat_sent_string[18]) --输入框确认信息
	end
	if __lua_project_id == __lua_project_adventure 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		initialize_ed()
	end

	--提前载入error_code数据
	if #_lua_release_language_param > 1 then
		addErrorInfor()
	else
		--混服用到的载入error_code数据
		addErrorCodeInfo()
	end

	if __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then
		cleanAllDataForAgainEnterGame()
	end
	
	if _ED ~= nil then
		_ED.m_is_games = false
	end
	if resetMission ~= nil then
		-- 重现登陆时,重置教学
		resetMission()
	end

	-- 校验用户数据全服是否完成
	self._wait_user_data_combine_interval = 5
	
    -- Initialize login page state machine.
    local function init_login_terminal()
		-- 登陆游戏平台账号
        local login_platform_account_terminal = {
            _name = "login_platform_account",
            _init = function (terminal) 
                -- app.load("client.login.PlatformManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	-- math.randomseed(os.time())
            	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
            	local rpc = cc.UserDefault:getInstance():getStringForKey("def_platform_account", "")
            	if rpc == nil or rpc == "" then
            		rpc = ""
	            	for i=1, 18 do
	            		local c = math.random(1, 9)
	            		rpc = rpc .. c
	            	end
	            	cc.UserDefault:getInstance():setStringForKey("def_platform_account", rpc)
            	end
            	
				if app.configJson.platform_account ~= nil and app.configJson.platform_account ~= "" then
					rpc = app.configJson.platform_account
				end
				local platformloginInfo = {
					platform_id=app.configJson.UserAccountPlatformName,				--平台id
					register_type="0", 						--注册类型
					platform_account=rpc,					--游戏账号
					nickname="Guest",						--注册昵称
					password="123456",						--注册密码
					is_registered = false
				}	
				_ED.user_platform = {}
				_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
				_ED.default_user = platformloginInfo.platform_account
				instance:updatePlatformAccountLoginStatus()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--获取服务器列表
		local login_get_server_list_terminal = {
            _name = "login_get_server_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
                    		return
                    	end
						response.node:initCurrentSelectedServer()
						if _ED.all_servers[_ED.selected_server] == nil then
							_ED.selected_server = ""
							response.node:initCurrentSelectedServer()
						end
						response.node:updateSelectedServer()
						
						for i, v in pairs(_ED.all_servers) do
							if zstring.tonumber(v.server_type) == -1 
							and zstring.tonumber(v.server_number)%1000 == 999 then
								self.isShowData = false
							end
						end
						-- android渠道请求初始化
						-- if app.configJson.UserAccountPlatformName == "play800-android" or app.configJson.UserAccountPlatformNam == "uc" 
						-- or app.configJson.UserAccountPlatformNam == "duoku" or app.configJson.UserAccountPlatformNam == "360" then
							if (cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID and app.configJson.OperatorName == "88box")
							or (cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID and app.configJson.OperatorName == "pocket") then
							else
								handlePlatformRequest(0, CC_INIT_PLATFORM_PARAM, "")
								if app.configJson.OperatorName == "tencent" then
									state_machine.excute("platform_manager_open_sdk_interface", 0, "platform_manager_open_sdk_interface.")
								end
								if app.assets_update_url ~= nil then
									_ED.cdn_local_resource_group_ids = _ED.cdn_local_resource_group_ids or {}
									local nCount = table.nums(dms["patch_res"]) or 0 --table.nums(dms["patch_res"])
									if nCount > 0 then
										for i = 1, nCount do
											local groupId = dms.string(dms["patch_res"], i, 2)
											table.insert(_ED.cdn_local_resource_group_ids, groupId)
										end
										
										local m_platformUpdate = cc.UserDefault:getInstance():getStringForKey("platformUpdateId", "")
										
										_ED.cdn_download_resource_group_ids = _ED.cdn_download_resource_group_ids or {}
										local ids = zstring.split(m_platformUpdate, "|")
										nCount = table.nums(ids)
										for i = 1, nCount do
											table.insert(_ED.cdn_download_resource_group_ids, ids[i])
										end
										
										local currentDownloadGroupId = nil
										nCount = #_ED.cdn_local_resource_group_ids
										for i = 1, nCount do
											local v = _ED.cdn_local_resource_group_ids[i]
											local lnCount = #_ED.cdn_download_resource_group_ids
											local downloadGroupId = v
											for l = 1, lnCount do
												if v == _ED.cdn_download_resource_group_ids[l] then
													downloadGroupId = nil
													break
												end
											end
											if nil ~= downloadGroupId then
												currentDownloadGroupId = downloadGroupId
												break
											end
										end
										
										if nil ~= currentDownloadGroupId then
											if app.assets_update_url ~= nil then
												handlePlatformRequest(0, CHECK_CDN_DOWNLOAD_RESOURCES, currentDownloadGroupId.."|"
																			..app.patch_path .."|" 
																			.. app.assets_update_url .."|"
																			..cc.FileUtils:getInstance():fullPathForFilename("data/mould/patch_res.cdn"))
											end							
										end
									end
								end
							end
						-- end
					else
						state_machine.excute("login_get_server_list", 0, 0)
					end
                end
                terminal.responseCount = terminal.responseCount or 0
                terminal.responseCount = terminal.responseCount + 1
                if terminal.responseCount > 100 then
                    terminal.responseCount = 0
                    return false
                end
                NetworkView:reconnectErase(nil)
                NetworkManager:register(protocol_command.new_get_server_list.code, app.configJson.url, nil, nil, instance, responseGetServerListCallback, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--服务器选择
        local login_select_server_terminal = {
            _name = "login_select_server",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local server = _ED.all_servers[_ED.selected_server]
				if server ~= nil and server ~= "" then
					if __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
						then
						state_machine.excute("server_managers_window_open",0,"")
					else
						fwin:open(ServerManager:new(), fwin._screen) 
					end
				else
					state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--检测是否是首次登陆
		local login_check_first_terminal = {
            _name = "login_check_first",
			_init = function (terminal)
				-- if config_res.chooseLanguage ~= nil then
				-- 	app.load("client.login.ChooseLanguageFirst")
				-- end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- local isLoginFirst = cc.UserDefault:getInstance():getStringForKey("login_first","0")
				-- if isLoginFirst == "0" then
				-- 	local sysLanguage = m_system_default_language
				-- 	local isHadLanguage =  instance:isHadLanguage() --判断是否有 系统默认语言 下载包
				-- 	if sysLanguage ~= _lua_release_language_en and isHadLanguage then
				-- 		fwin:open(ChooseLanguageFirst:new():init(), fwin._ui)
				-- 		cc.UserDefault:getInstance():setStringForKey("login_first", "1")
				-- 		cc.UserDefault:getInstance():flush()
				-- 	else
				-- 		state_machine.excute("login_vali_register", 0, "login_vali_register")
				-- 	end
				-- else
				-- 	state_machine.excute("login_vali_register", 0, "login_vali_register")
				-- end
				-- Fury (1-oct): sin cuenta iniciada login_vali_register sigue
				-- bloqueado (linea 1700) y GAME START no hacia nada; si el jugador
				-- habia cerrado la ventana de cuenta tocando fuera, se quedaba sin
				-- barra de servidor hasta reiniciar el juego. Se le reabre la ventana.
				local vali = state_machine.find("login_vali_register")
				if vali ~= nil and vali._lock == true then
					if fwin:find("AccountSysManagerClass") == nil then
						app.load("client.login.Manager.AccountSysManager")
						state_machine.excute("account_sys_manager_open", 0, "account_sys_manager_open.")
					end
					return true
				end
				state_machine.excute("login_vali_register", 0, "login_vali_register")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--校验用户
        local login_vali_register_terminal = {
            _name = "login_vali_register",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fury_sdk_local_listo()
            	if app.configJson.OperatorName == "huawei" or (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then
					if m_sdk_init_success == false then -- 授权失败，重新初始化sdk
            			state_machine.excute("platform_manager_sdk_init", 0, { messageType = ENTERED_THE_GAME ,messageText = ""})
            			return
            		elseif m_sdk_login_success == false then -- 登录失败，重新拉起登录框
            			state_machine.excute("platform_manager_login", 0, { messageType = LOGIN ,messageText = ""})
            			return
            		end
            	end

				-- Fury: tambien espera a la precarga de las tablas (Login:precargar);
				-- mientras, ensena el avance y onUpdate vuelve a llamar al acabar.
				if true ~= instance._isLoadLocalDataComplete or true ~= instance:precargaHecha() then
					if true ~= instance._isClickLoginEnterGame then
						instance._precargaEsperaDesde = fury_ahora()
					end
					instance._isClickLoginEnterGame = true
					instance:mostrarPrecarga()
					return
				end
				instance._precargaEsperaDesde = nil
				instance._isClickLoginEnterGame = false
				-- instance._isLoadLocalDataComplete = nil
				
				local function responseValiRegisterCallback(response)
					state_machine.unlock("login_vali_register")
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if _ED.wait_user_data_combine == true then
							return false
						end
						state_machine.excute("connecting_view_window_close", 0, 0)
						local function unlockserverstate(_checkType)
							if server_state_tip_str ~= nil then
								local tv = _ED.all_servers[_ED.selected_server]
								local tempType = math.floor(zstring.tonumber(tv.server_type))
								if _checkType == 1 and tempType ~= 2 then
									return false
								end
								local tipcon = server_state_tip_str[tempType + 2]
								if tipcon ~= nil and tipcon[1] ~= nil and tipcon[1] == 1 then
									if tipcon[2] ~= nil and tipcon[2] ~= "" then
										TipDlg.drawTextDailog(tipcon[2])
										return true
									end
								end
							end
							return false
						end

						local function checkUserLogin()
							local user_info = _ED.user_platform[_ED.default_user]
							if user_info ~= nil then
								local user_server_state = nil 
								if _ED._pus ~= nil then
									user_server_state = _ED._pus[_ED.default_user]
								end
								if user_info.is_registered == true or
									(user_server_state ~= nil and user_server_state.sst[_ED.selected_server] ~= nil
										and user_server_state.sst[_ED.selected_server]._user_accis == true)then
									if unlockserverstate(1) == true then
										return
									end
									
									self.islogin = false
									if __lua_project_id == __lua_project_gragon_tiger_gate 
										-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
										-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
										then
										Loading.loading(
											{ 
												_pic = {
													"images/ui/play/wonderful_activity/build_discount_bg.png",
													"images/ui/play/wonderful_activity/shouchong_slots_1.png",
													"images/ui/play/wonderful_activity/seven_day/text_1.png",
													"images/ui/play/wonderful_activity/seven_day/text_2.png",
													"images/ui/play/wonderful_activity/seven_day/text_3.png",
													"images/ui/play/wonderful_activity/seven_day/text_4.png",
													"images/ui/play/wonderful_activity/seven_day/text_5.png",
													"images/ui/play/wonderful_activity/seven_day/text_6.png",
													"images/ui/play/wonderful_activity/seven_day/text_7.png",
													"images/ui/play/wonderful_activity/seven_day/text_8.png",
													"images/ui/play/wonderful_activity/seven_day/text_9.png",
													"images/ui/play/wonderful_activity/seven_day/text_10.png",
													"images/ui/play/wonderful_activity/seven_day/text_11.png",
													"images/ui/play/wonderful_activity/seven_day/text_12.png",
													"images/ui/play/wonderful_activity/seven_day/text_13.png",
													"images/ui/play/wonderful_activity/seven_day/text_14.png",
													"images/ui/play/wonderful_activity/seven_day/text_15.png",
													"images/ui/play/wonderful_activity/seven_day/text_16.png",
													"images/ui/home/head_1.png",
													"images/ui/home/head_2.png",
													"images/ui/home/head_3.png",
													"images/ui/home/head_4.png",
													"images/ui/home/head_5.png",
													"images/ui/home/head_6.png",
													"images/ui/home/head_7.png",
													"images/ui/home/head_8.png",
													"images/ui/home/head_9.png",
													"images/ui/home/head_10.png",
													"images/ui/home/head_11.png",
													"images/ui/home/home_add_bg.png",
													"images/ui/home/wanjia_cg_head_1.png",
													"images/ui/home/wanjia_cg_head_2.png",
													"images/ui/slots/jt_paper3_di.png",
													"images/ui/slots/jt_paper3.png",
													"images/ui/bar/bar_11.png",
													},
												_plist = {
													{
														_png = {"images/ui/home/home.png"}, 
														_plist = {"images/ui/home/home.plist"}
													},
													{
														_png = {"images/ui/play/wonderful_activity/seven_day/seven_day.png"}, 
														_plist = {"images/ui/play/wonderful_activity/seven_day/seven_day.plist"}
													},
													{
														_png = {"images/ui/play/wonderful_activity/wonderful_activity.png"}, 
														_plist = {"images/ui/play/wonderful_activity/wonderful_activity.plist"}
													},
													{
														_png = {"images/ui/play/wonderful_activity/wonderful_activity_1.png"}, 
														_plist = {"images/ui/play/wonderful_activity/wonderful_activity_1.plist"}
													},
													{
														_png = {"images/ui/play/wonderful_activity/wonderful_activity_2.png"}, 
														_plist = {"images/ui/play/wonderful_activity/wonderful_activity_2.plist"}
													},
													{
														_png = {"images/ui/play/wonderful_activity/wonderful_activity_3.png"}, 
														_plist = {"images/ui/play/wonderful_activity/wonderful_activity_3.plist"}
													}
												}, 
												_ui = {}
											},
											nil,
											{"login_enter_game", 0, "login_enter_game."})
									elseif __lua_project_id == __lua_project_red_alert 
										or __lua_project_id == __lua_project_red_alert_time 
										or __lua_project_id == __lua_project_pacific_rim 
										or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
										or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
										then
										state_machine.excute("login_enter_game", 0, "login_enter_game.")
									else
										Loading.loading(
											{ 
												_pic = {}, 
												_plist = {
													{
														_png = {"images/ui/home/home.png"}, 
														_plist = {"images/ui/home/home.plist"}
													},
													{
														_png = {"images/ui/play/wonderful_activity/wonderful_he_1.png"}, 
														_plist = {"images/ui/play/wonderful_activity/wonderful_he_1.plist"}
													},
													{
														_png = {"images/ui/play/wonderful_activity/wonderful_he_2.png"}, 
														_plist = {"images/ui/play/wonderful_activity/wonderful_he_2.plist"}
													}
												}, 
												_ui = {}
											},
											nil,
											{"login_enter_game", 0, "login_enter_game."})
									end
								else
									if unlockserverstate() == true then
										return
									end

				                    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
					                	app.load("client.utils.texture_cache")
					                	fwin:removeAll()
										cacher.destorySystemCacher(nil)
				                    	fwin:addService({
							                callback = function ( params )
												app.load("client.red_alert_time.utils.ShortCut")
												app.load("client.red_alert_time.login.LoginLoading")
            									app.load("client.red_alert_time.login.CreateCharacter")
							                	state_machine.excute("login_loading_window_open",0,true)
												-- if executeMissionExt(mission_mould_plot, touch_off_mission_into_home, "0", nil, true, "0") == false then
												-- 	if executeMissionExt(mission_mould_plot, touch_off_mission_into_home, "0", nil, true, "l1e0") == false then
												-- 		state_machine.excute("login_character_create", 0, "login_character_create.")
												-- 	end
												-- end
												-- state_machine.excute("login_character_create", 0, "login_character_create.")
							                end,
							                params = nil
							            })
				                    else
										fwin:cleanView(fwin._frameview)
										fwin:cleanView(fwin._background)
					                    fwin:cleanView(fwin._view)
					                    fwin:cleanView(fwin._viewdialog)
					                    fwin:cleanView(fwin._ui)
					                    fwin:cleanView(fwin._windows)
										if executeMissionExt(mission_mould_plot, touch_off_mission_into_home, "0", nil, true, "0") == false then
											if executeMissionExt(mission_mould_plot, touch_off_mission_into_home, "0", nil, true, "l1e0") == false then
												state_machine.excute("login_character_create", 0, "login_character_create.")
											end
										end
									end
								end
							end
						end
						checkUserLogin()
						--背景音乐
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							dms.unload("data/mould/sound_effect_param.txt")
							dms.load("data/mould/sound_effect_param.txt")
							local bgm_array = zstring.split(dms.string(dms["user_config"], 11 ,user_config.param),",")
							for i , v in pairs(bgm_array) do
								local homeBgm = dms.int(dms["sound_effect_param"] , tonumber(v) , sound_effect_param.sound_effect)
								_ED.init_home_bgm[i] = homeBgm
							end
							local currHomeBgm = readKey("m_curr_home_bgm")
							if currHomeBgm == nil or currHomeBgm == "" then
								writeKey("m_curr_home_bgm",_ED.init_home_bgm[1])
								cc.UserDefault:getInstance():flush()
							elseif tonumber(currHomeBgm) ~= tonumber(_ED.init_home_bgm[1]) then
								-- local total_bgm = dms.searchs(dms["sound_effect_param"], sound_effect_param.sound_effect, _ED.init_home_bgm[1])
								-- for i , v in pairs(total_bgm) do
								-- 	local x = dms.string(dms["sound_effect_param"] , tonumber(v[1]) , sound_effect_param.sound_effect)
								-- 	local data = dms.element(dms["sound_effect_param"] , tonumber(v[1]))
								-- 	data[sound_effect_param.sound_effect] = ""..currHomeBgm
								-- end
								local data = dms.element(dms["sound_effect_param"], tonumber(bgm_array[1]))
								data[sound_effect_param.sound_effect] = ""..currHomeBgm
							end
						end
						_ED.m_is_games = true
					else
						state_machine.excute("connecting_view_window_close", 0, 0)
						self.islogin = true
					end
                end
				local platform_account = ""
				if platform_account == nil 
					or platform_account == "" then
					if _ED.default_user ~= nil and _ED.default_user ~= "" and _ED.user_platform ~= nil and _ED.user_platform[_ED.default_user] ~= nil then
						platform_account = _ED.user_platform[_ED.default_user].platform_account
					end
				end
				local server = _ED.all_servers[_ED.selected_server]
				if server ~= nil and server ~= "" then
					if platform_account == "" or platform_account == nil then
						if (cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID and app.configJson.OperatorName == "88box")
						or (cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID and app.configJson.OperatorName == "pocket") then
							handlePlatformRequest(0, CC_INIT_PLATFORM_PARAM, "")
						else
							if m_loading_start == true then
								state_machine.excute("platform_manager_login", 0, { messageType = LOGIN ,messageText = ""})
								m_loading_start = false
							end
						end
						
						return
					end
					if self.islogin == true then
						if __lua_project_id == __lua_project_red_alert_time 
							or __lua_project_id == __lua_project_pacific_rim 
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
							or __lua_project_id == __lua_project_l_naruto
							then
							local function responseEnterCallback( response )
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									state_machine.lock("login_vali_register")
									NetworkManager:registerUrl(_ED.all_servers[_ED.selected_server].server_link, nil, _ED.all_servers[_ED.selected_server].server_link_rf)
									if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
									or __lua_project_id == __lua_project_l_naruto then
										protocol_command.vali_register.param_list = platform_account.."\r\n"..server.server_number.."\r\n"..getUserAccountPlatform().."\r\n"..getPlatform().."\r\n"
									else
										protocol_command.vali_register.param_list = platform_account.."\r\n"..server.server_number.."\r\n"..getPlatform().."\r\n"..getUserAccountPlatform().."\r\n"
									end
									NetworkManager:register(protocol_command.vali_register.code, server.server_link, nil, nil, nil, responseValiRegisterCallback, false, nil)
								end
							end
							if zstring.tonumber(_ED.all_servers[_ED.selected_server].server_type) == 2 then
								local function responseCallback(response)
									if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
										if zstring.tonumber(_ED.server_maintenance_time) > 0 then
											state_machine.excute("server_prompt_create", 0, {_ED.server_maintenance_title, _ED.server_maintenance_info, _ED.server_maintenance_time})
										else
											responseEnterCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
										end
									end
								end
								protocol_command.get_server_maintenance_info.param_list = m_curr_choose_language
								NetworkManager:register(protocol_command.get_server_maintenance_info.code, app.configJson.url, nil, nil, nil, responseCallback, false, nil)
							else
								local function responseCallback(response)
									if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
										if zstring.tonumber(_ED.server_open_time) > 0 then
											state_machine.excute("server_prompt_create", 0, {_ED.server_open_title, _ED.server_open_info, _ED.server_open_time})
										else
											responseEnterCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
										end
									end
								end
								if zstring.tonumber(_ED.all_servers[_ED.selected_server].server_open_time) > 0 then
									protocol_command.get_server_open_info.param_list = m_curr_choose_language.."\r\n"..server.server_number
									NetworkManager:register(protocol_command.get_server_open_info.code, app.configJson.url, nil, nil, nil, responseCallback, false, nil)
								else
									responseEnterCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
								end
							end
							-- 注释无用的 new_get_server_list 请求
							-- state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
						else
							protocol_command.vali_register.param_list = platform_account.."\r\n"..server.server_number.."\r\n"..getUserAccountPlatform().."\r\n"..getPlatform().."\r\n"
							NetworkManager:register(protocol_command.vali_register.code, server.server_link, nil, nil, nil, responseValiRegisterCallback, false, nil)
						end
					end
				else
					state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	
		
		--进入游戏
        local login_enter_game_terminal = {
            _name = "login_enter_game",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.unlock("login_enter_game")
            	state_machine.unlock("login_vali_register")
    			if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            		fwin:open(ConnectingView:new(), fwin._windows)
            	end
            	
				local function responseLoginInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if OperatorNameConfig[app.configJson.OperatorName] == "t4" or app.configJson.OperatorName == "t4game" then
							jttd.facebookAPPeventSlogger("4|".._ED.default_user)
							jttd.facebookAPPeventSlogger("18|".._ED.user_info.user_id)
							jttd.facebookAPPeventSlogger("11")
						end
						fwin:close(fwin:find("ConnectingViewClass"))
						cacher.removeAllObject()
						NetworkManager:registerUrl(_ED.all_servers[_ED.selected_server].server_link, nil, _ED.all_servers[_ED.selected_server].server_link_rf)
						updateDefaultServerFile()
						fwin:removeAll()
						app.load("client.home.Menu")

						app.load("client.utils.texture_cache")

						cacher.removeAllTextures()
						-- cacher.addTextureAsync(texture_cache_load_images)

						-- 重现登陆时,重置教学
						resetMission()
						jttd.NewAPPeventSlogger("2|".._ED.user_info.user_id)
						if __lua_project_id == __lua_project_adventure then
						    ---- lc　2015-10-23 --- 修改佣兵卡顿问题 
						    ---- 优化方案,在游戏首次进入后 实现加载所有英雄的本地数据  get_typed_base_ship_moulds这个函数耗死比较长
						 --    app.load("client.loader.formula")
						 --    app.load("client.adventure.campaign.mine.AdventureMineManager")
						 	app.load("client.adventure.login.AdventureLoginLoading")
						 	_ED.adventure_create_character = false 
						    fwin:open(AdventureLoginLoading:new():init(), fwin._taskbar)
						 --    state_machine.excute("adventure_mine_manager_open", 0, true)
		 
    			-- 			local typed_ship_mould_array = get_typed_base_ship_moulds()

       --   					app.load("client.adventure.mercenary.handbook.AdventureMercenaryHeroHandbook")
      	-- 					state_machine.excute("adventure_mercenary_hero_handbook_open", 0, false)
                		
							-- fwin:open(Menu:new():init(true), fwin._taskbar)
							-- state_machine.excute("menu_manager", 0, 
							-- 	{
							-- 		_datas = {
							-- 			terminal_name = "menu_manager", 	
							-- 			next_terminal_name = "menu_show_home_page", 
							-- 			current_button_name = "Button_daditu",
							-- 			but_image = "Image_daditu", 		
							-- 			terminal_state = 0, 
							-- 			isPressedActionEnabled = true
							-- 		}
							-- 	}
							-- )
						elseif __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
							app.load("client.login.LoginLoading")
						    fwin:open(LoginLoading:new():init(), fwin._screen)
							if OperatorNameConfig[app.configJson.OperatorName] == "t4" or app.configJson.OperatorName == "t4game" then
								jttd.facebookAPPeventSlogger("1")
							end
							if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
								local function callbackRoleTime( response )
									if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
										state_machine.excute("platform_the_roles_tracking", 0, "platform_the_roles_tracking.")
									end
								end
						    	NetworkManager:register(protocol_command.user_create_time.code, nil, nil, nil, self, callbackRoleTime, false, nil)
						    else
						    	NetworkManager:register(protocol_command.user_create_time.code, nil, nil, nil, self, nil, false, nil)
							end
						elseif __lua_project_id == __lua_project_red_alert 
							-- or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
							then
							fwin._bg_music_index = tonumber(_ED.user_info.user_force)
							if fwin._bg_music_index == 0 then
								fwin._bg_music_index = 1
							end
							if __lua_project_id == __lua_project_red_alert then
								app.load("client.red_alert.login.LoginLoading")
							else
								app.load("client.red_alert_time.login.LoginLoading")
							end
							if executeMissionExt(mission_mould_plot, touch_off_mission_into_home, "0", nil, false, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
								state_machine.excute("login_loading_window_open",0,"")
							else
								executeNextEvent(nil, true)
							end
						elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
							fwin._bg_music_index = tonumber(_ED.user_info.user_force)
							if fwin._bg_music_index == 0 then
								fwin._bg_music_index = 1
							end
							app.load("client.red_alert_time.login.LoginLoading")
							state_machine.excute("login_loading_window_open",0,"")
						else
							csbCacher.load()
							-- app.load("client.activity.ActivityWindow")
							-- state_machine.excute("activity_window_open", 0, {nil, "DailySignIn"})
							-- state_machine.excute("activity_window_hide", 0, nil)
							fwin:open(Menu:new(), fwin._taskbar)
							state_machine.excute("menu_manager", 0, 
								{
									_datas = {
										terminal_name = "menu_manager", 	
										next_terminal_name = "menu_show_home_page", 
										current_button_name = "Button_home",
										but_image = "Image_home", 		
										terminal_state = 0, 
										isPressedActionEnabled = true
									}
								}
							)
							app.load("client.formation.Formation")
							state_machine.excute("formation_open_instance_window", 0, {_datas = {}})
							
							app.load("client.duplicate.pve.PVEStage")
							state_machine.excute("page_stage_open_instance_window", 0, {sceneID = 1, sceneType = 1, isInit = true})
							
							if __lua_project_id == __lua_project_warship_girl_b 
								or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
								or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge 
								or __lua_project_id == __lua_project_yugioh
								then
								local function responseUnionInitCallback(response)
									if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
										local function responseUnionFightCallback(response)
										end
										if _ED.union ~= nil and _ED.union.union_info ~= nil and _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
											protocol_command.unino_fight_init.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
											NetworkManager:register(protocol_command.unino_fight_init.code, _ED.union_fight_url, nil, nil, self, responseUnionFightCallback, false, nil)
										end
									end
								end
								if ___is_open_union == true then
									NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, self, responseUnionInitCallback, false, nil)
								end

								--排位赛
						 		local isOpen_warcrft = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 53, fun_open_condition.level)
						 		if isOpen_warcrft == true and _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then 
						 			local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
						 			protocol_command.warcraft_info_refrush.param_list = currentServerNumber
						 			NetworkManager:register(protocol_command.warcraft_info_refrush.code, _ED.union_fight_url, nil, nil, nil, nil, false, nil)
						 		end

						 		-- 请求角色创建时间
								NetworkManager:register(protocol_command.user_create_time.code, nil, nil, nil, self, nil, false, nil)
								
								local function responseBountyInitCallback(response)
	
								end
								if ___is_open_bounty == true then
									NetworkManager:register(protocol_command.partner_bounty_init.code, nil, nil, nil, self, responseBountyInitCallback, false, nil)
								end
								-- local function responseMarqueeInitCallback(response)
	
								-- end
								-- NetworkManager:register(protocol_command.marquee_init.code, nil, nil, nil, self, responseMarqueeInitCallback, false, nil)
							end
						end
						
						app.load("client.utils.scene.SceneCacheData")
						SceneCacheData.deleteAll()
						
						-- 读取战斗倍数记录
						local kname = "userFightSpeed" 
						_ED.user_set_fight_recorder_action_time_speed = readKey(kname)
						--
						state_machine.excute("platform_the_roles_tracking", 0, "platform_the_roles_tracking.")
					else
						self.islogin = true
					end
				end

				-- Red de seguridad: con la precarga hecha (Login:precargar) cada dms.load
				-- devuelve la tabla ya cargada y esto no cuesta nada.
				if nil ~= data_path then
					for i,v in pairs(data_path) do
						if type(v) == "table" then
							for k,m in pairs(v) do
								dms.load(m)
							end
						elseif type(v) == "string" then
							dms.load(v)
					    end
					end
				end
				--添加error_code
                if #_lua_release_language_param > 1 then
                    addErrorCodeInfo()
                end
				local str = getPlatform().."\r\n"
				str = str ..getHardwareType().."\r\n"
				str = str .._ED.user_platform[_ED.default_user].platform_account.."\r\n"
				str = str .._ED.user_platform[_ED.default_user].password.."\r\n"
				str = str ..getApplicationName().."\r\n"
				str = str .._ED.selected_server
				protocol_command.login_init.param_list = str
				protocol_command.login_init_again.param_list = str
				local server = _ED.all_servers[_ED.selected_server]

				if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            		state_machine.lock("login_enter_game")
            		state_machine.lock("login_vali_register")
            	end
				NetworkManager:register(protocol_command.login_init.code, server.server_link, nil, nil, nil, responseLoginInitCallback, false, nil)
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 创建角色
		local login_character_create_terminal = {
            _name = "login_character_create",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- fwin:reset(nil)	
				fwin:removeAll()
				
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					-- cacher.removeAllObject()
					-- NetworkManager:registerUrl(_ED.all_servers[_ED.selected_server].server_link, nil, _ED.all_servers[_ED.selected_server].server_link_rf)
					-- updateDefaultServerFile()
					-- fwin:removeAll()
					-- app.load("client.home.Menu")

					-- app.load("client.utils.texture_cache")

					-- cacher.removeAllTextures()
					-- -- cacher.addTextureAsync(texture_cache_load_images)

					-- -- 重现登陆时,重置教学
					-- resetMission()

					app.load("client.login.LoginLoading")
					fwin:open(LoginLoading:new():init(), fwin._screen)
					-- app.load("client.login.LCharacterCreate")
					-- fwin:open(LCharacterCreate:new(), fwin._view) 
				elseif __lua_project_id == __lua_project_gragon_tiger_gate  or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
					app.load("client.login.LCharacterCreate")
					fwin:open(LCharacterCreate:new(), fwin._view) 
				elseif __lua_project_id == __lua_project_red_alert then
					app.load("client.red_alert.login.CreateCharacter")
					state_machine.excute("create_character_window_open",0,"")
				elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
					app.load("client.red_alert_time.login.CreateCharacter")
					state_machine.excute("create_character_window_open",0,"")
				else
					app.load("client.login.CharacterCreate")
					fwin:open(CharacterCreate:new(), fwin._view) 
				end
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 公告时UI的隐藏和关闭公告显示
		local login_ui_control_terminal = {
            _name = "login_ui_control",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				ccui.Helper:seekWidgetByName(root, "Panel_below"):setVisible(params)
				if __lua_project_id == __lua_project_adventure then 
					instance:onPlayLoginArmature(params)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		local login_announce_show_open_teminal ={
			_name = "login_announce_show_open",
            _init = function (terminal)
                app.load("client.system.AnnouncePage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_red_alert then
					app.load("client.red_alert.game_announcement.GameAnnouncement")
					state_machine.excute("game_announcement_window_open",0,"")
				elseif __lua_project_id == __lua_project_red_alert_time 
					or __lua_project_id == __lua_project_pacific_rim 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
					or __lua_project_id == __lua_project_l_naruto 
					then
					app.load("client.red_alert_time.game_announcement.GameAnnouncement")
					state_machine.excute("game_announcement_window_open",0,"")
				else
					fwin:close(fwin:find("AnnouncePageClass"))
					fwin:open(AnnouncePage:new())
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		local login_change_account_terminal = {
            _name = "login_change_account",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
					and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
					and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
					handlePlatformRequest(0, LOGOUT, "")
				else
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
					fwin:removeAll()
					fwin:reset(nil)
					fwin:open(Login:new(), fwin._view)
					fwin:close(fwin:find("ConnectingViewClass"))
					_ED.m_is_games = false
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--注销账号
        local tencent_account_cancellation_terminal = {
            _name = "tencent_account_cancellation",
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
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --登陆自己的账户系统
        local log_in_your_own_account_system_terminal = {
            _name = "log_in_your_own_account_system",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- state_machine.unlock("login_vali_register")
				-- cc.UserDefault:getInstance():setStringForKey("moveLofinType", "3")
    --             cc.UserDefault:getInstance():flush()
				-- fwin:close(fwin:find("platformSDKLoginMoveClass"))
                -- return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --验证是否是特殊账号
        local log_in_verify_special_account_terminal = {
            _name = "log_in_verify_special_account",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
     --        	local moveLofinType = cc.UserDefault:getInstance():getStringForKey("moveLofinType","0")
     --        	if zstring.tonumber(moveLofinType) == 3 then
					-- local function responseLinkageCheckCallback (response)
				 --        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				 --        	if zstring.tonumber(_ED.linkage_check_serverid) ~= -1 then
				 --        		_ED.all_servers["".._ED.linkage_check_serverid] = nil
				 --        		instance:initCurrentSelectedServer()
					-- 			instance:updateSelectedServer()
				 --        	end
				 --        end
				 --        state_machine.unlock("log_in_verify_special_account")
				 --    end
				 --    state_machine.lock("log_in_verify_special_account")
				 --    protocol_command.linkage_check_server.param_list = m_account_sys_user_name
				 --    NetworkManager:register(protocol_command.linkage_check_server.code, app.configJson.url, nil, nil, instance, responseLinkageCheckCallback, false, nil)
					-- state_machine.excute("login_vali_register", 0, "login_vali_register.")
				-- end
                -- return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(login_announce_show_open_teminal)
        state_machine.add(login_platform_account_terminal)
        state_machine.add(login_get_server_list_terminal)
        state_machine.add(login_select_server_terminal)
        state_machine.add(login_vali_register_terminal)
        state_machine.add(login_enter_game_terminal)
		state_machine.add(login_character_create_terminal)
		state_machine.add(login_ui_control_terminal)
		state_machine.add(login_change_account_terminal)
		state_machine.add(tencent_account_cancellation_terminal)
		state_machine.add(log_in_your_own_account_system_terminal)
		state_machine.add(log_in_verify_special_account_terminal)
		state_machine.add(login_check_first_terminal)
        state_machine.init()
    end
    
    -- call func init login state machine.
    init_login_terminal()
end
--判断是否有 系统默认语言 下载包
function Login:isHadLanguage()
	if config_res.chooseLanguage ~= nil then
		for k, v in pairs(config_res.chooseLanguage) do
			if v.name == m_system_default_language then
				return true
			end
		end
	end
	return false
end

function Login:initCurrentSelectedServer()
	if _ED.selected_server ~= nil and _ED.selected_server == "" and _ED.all_def_servers ~= nil then
		if _ED.all_def_servers[_ED.selected_server] == nil then
			_ED.selected_server = ""
			for i, v in pairs(_ED.all_def_servers) do
				if _ED.selected_server == "" then
					_ED.selected_server = v.server_number
					--break
				else
					local currentSvrType = ""
					local tempType = math.floor(zstring.tonumber(v.server_type))
					if _ED.selected_server == "" then
						currentSvrType = tempType
					else
						currentSvrType = math.floor(zstring.tonumber(_ED.all_servers[_ED.selected_server].server_type))
					end
					if tempType == server_state_new_1 then -- 1 新服
						_ED.selected_server = v.server_number
					elseif tempType == server_state_recommend_3 
						and 
						(currentSvrType ~= server_state_new_1)
					then -- 3 推荐
						_ED.selected_server = v.server_number
					elseif tempType == server_state_fluent_0 
						and
						(currentSvrType ~= server_state_new_1 
						and currentSvrType ~= server_state_recommend_3)
					then -- 0 流畅
						_ED.selected_server = v.server_number
					elseif tempType == server_state_crowd_4 
						and
						(currentSvrType ~= server_state_new_1 
						and currentSvrType ~= server_state_recommend_3
						and currentSvrType ~= server_state_fluent_0)
					then -- 4 拥挤
						_ED.selected_server = v.server_number
					elseif tempType == server_state_gremito_5
						and
						(currentSvrType ~= server_state_new_1 
						and currentSvrType ~= server_state_recommend_3
						and currentSvrType ~= server_state_fluent_0
						and currentSvrType ~= server_state_crowd_4) 
					then -- 5 爆满
						_ED.selected_server = v.server_number
					elseif tempType == server_state_maintain_2 
						and
						(currentSvrType ~= server_state_new_1 
						and currentSvrType ~= server_state_recommend_3
						and currentSvrType ~= server_state_fluent_0
						and currentSvrType ~= server_state_crowd_4
						and currentSvrType ~= server_state_gremito_5) 
					then -- 2 维护
						_ED.selected_server = v.server_number
					elseif tempType == server_state_closed_m1 
						and
						(currentSvrType ~= server_state_new_1 
						and currentSvrType ~= server_state_recommend_3
						and currentSvrType ~= server_state_fluent_0
						and currentSvrType ~= server_state_crowd_4
						and currentSvrType ~= server_state_gremito_5
						and currentSvrType ~= server_state_maintain_2) 
					then -- -1 关闭
						_ED.selected_server = v.server_number
					end
				end
			end
		end
	end
end

function Login:updatePlatformAccountLoginStatus()
	-- local serverNameLabel1 = ccui.Helper:seekWidgetByName(self.roots[1], "Label_user_id2")
	-- local serverNameLabel2 = ccui.Helper:seekWidgetByName(self.roots[1], "Label_user_id1")
	-- serverNameLabel1:setVisible(false)
	-- serverNameLabel2:setVisible(false)
	-- if _ED.default_user ~= nil and _ED.default_user ~= "" then
		-- serverNameLabel1:setVisible(true)
		-- serverNameLabel2:setVisible(false)
	-- else
		-- serverNameLabel2:setVisible(true)
		-- serverNameLabel1:setVisible(false)
	-- end
end

function Login:updateSelectedServer()
	if _ED.selected_server == nil or _ED.all_servers[_ED.selected_server] == nil then
		return
	end
	local serverNameLabel = ccui.Helper:seekWidgetByName(self.roots[1], "Label_server_name")
	local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_36759")
	serverNameLabel:setString(_ED.all_servers[_ED.selected_server].server_name)
	
	state_machine.excute("platform_the_get_servers_info", 0, {_ED.selected_server,_ED.all_servers[_ED.selected_server].server_name})
	if panel ~= nil then
		if tonumber(_ED.all_servers[_ED.selected_server].server_type) == -1 then
			
		elseif tonumber(_ED.all_servers[_ED.selected_server].server_type) == 0 then
			panel:setBackGroundImage("images/ui/state/server_status_0.png")
		elseif tonumber(_ED.all_servers[_ED.selected_server].server_type) == 1 then
			panel:setBackGroundImage("images/ui/state/server_status_1.png")
		elseif tonumber(_ED.all_servers[_ED.selected_server].server_type) == 2 then
			panel:setBackGroundImage("images/ui/state/server_status_2.png")
		elseif tonumber(_ED.all_servers[_ED.selected_server].server_type) == 3 then
			panel:setBackGroundImage("images/ui/state/server_status_3.png")
		elseif tonumber(_ED.all_servers[_ED.selected_server].server_type) == 4 then
			panel:setBackGroundImage("images/ui/state/server_status_4.png")
		elseif tonumber(_ED.all_servers[_ED.selected_server].server_type) == 5 then
			panel:setBackGroundImage("images/ui/state/server_status_5.png")
		end
	end
end

function Login:onPlayLoginArmature(isStarting)
	if zstring.tonumber(_game_platform_version_type) == 1 or zstring.tonumber(_game_platform_version_type) == 4 then 
		local root = self.roots[1]
		local loginPanel = ccui.Helper:seekWidgetByName(root, "Panel_login")
		self.ArmatureNode_starting_up = loginPanel:getChildByName("ArmatureNode_8") 
		self.ArmatureNode_playing = loginPanel:getChildByName("ArmatureNode_1") 
	 	draw.initArmature(self.ArmatureNode_starting_up, nil, -1, 0, 1)
		csb.animationChangeToAction(self.ArmatureNode_starting_up, 0, 0, false)
		draw.initArmature(self.ArmatureNode_playing, nil, -1, 0, 1)
		csb.animationChangeToAction(self.ArmatureNode_playing, 0, 0, false)
		if isStarting == true then 
			self.ArmatureNode_playing:setVisible(false)  
			self.ArmatureNode_starting_up:setVisible(true)	
			self.ArmatureNode_starting_up._invoke = function(armatureBack)        
				if armatureBack:isVisible() == true then 
					armatureBack:setVisible(false)
			    	draw.initArmature(self.ArmatureNode_playing, nil, -1, 0, 1)
					csb.animationChangeToAction(self.ArmatureNode_playing, 0, 0, false)
			    	self.ArmatureNode_playing:setVisible(true)  
				end
			end 
		else
			self.ArmatureNode_playing:setVisible(true)  
			self.ArmatureNode_starting_up:setVisible(false)	
		end
	end
end

function Login:onEnterTransitionFinish()

	local csbLogin = csb.createNode("login/login.csb")
    self:addChild(csbLogin)
	
	local action = csb.createTimeline("login/login.csb")
    csbLogin:runAction(action)
	self.action = action
    --action:gotoFrameAndPlay(0, action:getDuration(), false)
    
	local root = csbLogin:getChildByName("root")
	table.insert(self.roots, root)

	--强制更新最新版本
	if __lua_project_id == __lua_project_l_digital and tonumber(app.configJson.version) < 1.554
	and cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID  
	and (verifySupportLanguage(_lua_release_language_ko) == true or verifySupportLanguage("Ko") == true)
	then
		app.load("client.utils.ForceUpdate")
		state_machine.excute("sm_force_update_window_open", 0, "")
	end
	


	if __lua_project_id == __lua_project_adventure then
		if zstring.tonumber(_game_platform_version_type) == 1 or zstring.tonumber(_game_platform_version_type) == 4 then 
			ccui.Helper:seekWidgetByName(root, "Text_no"):setString("Version" .. app.configJson.version)
			
			local loginPanel = ccui.Helper:seekWidgetByName(root, "Panel_login")
			self.ArmatureNode_starting_up = loginPanel:getChildByName("ArmatureNode_8") 
			self.ArmatureNode_playing = loginPanel:getChildByName("ArmatureNode_1") 
		 	draw.initArmature(self.ArmatureNode_starting_up, nil, -1, 0, 1)
	    	csb.animationChangeToAction(self.ArmatureNode_starting_up, 0, 0, false)

	    	draw.initArmature(self.ArmatureNode_playing, nil, -1, 0, 1)
	    	csb.animationChangeToAction(self.ArmatureNode_playing, 0, 0, false)
	    	self.ArmatureNode_playing:setVisible(true)  
	    	self.ArmatureNode_starting_up:setVisible(false)
	    end
	end

	local Button_AntiAddction = ccui.Helper:seekWidgetByName(root, "Button_fangchenmi")
	if Button_AntiAddction ~= nil then
		Button_AntiAddction:setVisible(true)
		app.load("client.utils.AntiAddctionLoginIn")
		fwin:addTouchEventListener(Button_AntiAddction, nil, 
		{
			terminal_name = "anti_addction_loginin_open",  
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	local changeLanguageStr = ""	--切换语言
	local currentLanguageStr = ""	--当前语言:
	local languageTextStr = ""	--简体中文
	local SelectTextStr = ""	--选择
	m_curr_choose_language = cc.UserDefault:getInstance():getStringForKey("current_language")
	--debug.print_r(m_curr_choose_language,"m_curr_choose_language===============")
	local curLanguage = m_curr_choose_language
	if config_res.multiLanguage then
		local languageConfig = config_res.multiLanguage[curLanguage]
		--debug.print_r(languageConfig,"languageConfig===============")
		if languageConfig then
			languageTextStr = languageConfig.languageText
			SelectTextStr = languageConfig.chooseWord
		end
		-- «Idioma actual:» y «Cambiar idiomas» en el idioma ELEGIDO en el juego
		-- (current_language), no en el del movil; el del movil solo si el elegido
		-- no tiene ficha.
		local sysLanguageConfig = languageConfig or config_res.multiLanguage[m_system_default_language]
		if sysLanguageConfig then
			changeLanguageStr = sysLanguageConfig.changeLanguage
			currentLanguageStr = sysLanguageConfig.currentLanguage
		end
	end

	local Button_change_language = ccui.Helper:seekWidgetByName(root, "Button_change_language")
	local Text_change_t = ccui.Helper:seekWidgetByName(root, "Text_change_t")
	local Text_cur_language = ccui.Helper:seekWidgetByName(root, "Text_1")

	if __lua_project_id == __lua_project_l_digital then
		local Panel_change_language = ccui.Helper:seekWidgetByName(root, "Panel_change_language")

		if Panel_change_language ~= nil then
			Panel_change_language:setVisible(true)
		end

		Button_change_language = ccui.Helper:seekWidgetByName(root, "Button_language")
		Text_change_t = ccui.Helper:seekWidgetByName(root, "Text_change_language_1")
		Text_cur_language = ccui.Helper:seekWidgetByName(root, "Text_language_1")
	end

	--debug.print_r(Button_change_language,"Button_change_language===============")
	if Button_change_language ~= nil then
		Button_change_language:setVisible(true)
		app.load("client.login.ChooseLanguagePopup")
		fwin:addTouchEventListener(Button_change_language, nil,
		{
			terminal_name = "choose_language_popup_open",
			terminal_state = 0,
			isPressedActionEnabled = true
		},
		nil, 0)
		Button_change_language:setTitleText(changeLanguageStr)
	end

	if Text_change_t ~= nil then
		--debug.print_r(languageTextStr,"languageTextStr===============")
		Text_change_t:setString(languageTextStr)
	end
	if Text_cur_language ~= nil then
		Text_cur_language:setString(currentLanguageStr)
	end

	playBgm(formatMusicFile("background", 1))
	
	if __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_naruto
		then 
		local bgEffectPanel = ccui.Helper:seekWidgetByName(root, "Panel_1")
		local loginEffectPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
		bgEffectPanel:removeAllChildren(true)
		loginEffectPanel:removeAllChildren(true)
		local animationName = "animation"
    	local jsonFile = "images/ui/effice/effect_1/effect_1.json"
    	local atlasFile = "images/ui/effice/effect_1/effect_1.atlas"

    	if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
	        local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
	       	bgEffectPanel:addChild(animation)
    	end
    	animationName = "animation"
    	jsonFile = "images/ui/effice/effect_2/effect_2.json"
    	atlasFile = "images/ui/effice/effect_2/effect_2.atlas"
    	if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
	        local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
	       	loginEffectPanel:addChild(animation)
    	end
	end

	local Panel_login = ccui.Helper:seekWidgetByName(root, "Panel_login")
	if nil ~= Panel_login then
		local animationName = "animation"
		local jsonFile = "images/ui/effice/effect_kaijidh/effect_kaijidh.json"
		local atlasFile = "images/ui/effice/effect_kaijidh/effect_kaijidh.atlas"
		if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
			Panel_login:addChild(animation)
		end
	end

	if __lua_project_id == __lua_project_pacific_rim then
		local Panel_Armature = ccui.Helper:seekWidgetByName(root, "Panel_Armature")
		Panel_Armature:removeAllChildren(true)
		local animationName = "animation"
    	local jsonFile = "images/ui/effice/effice_begin_effect/effice_begin_effect.json"
    	local atlasFile = "images/ui/effice/effice_begin_effect/effice_begin_effect.atlas"
    	if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
	        local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
	       	Panel_Armature:addChild(animation)
    	end
	end

	_ED.selected_server = cc.UserDefault:getInstance():getStringForKey("defserver")
	-- 账号登陆
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_user_id"), nil, {func_string = [[state_machine.excute("login_platform_account", 0, "login_platform_account")]]}, nil, 0)

	-- 进入到服务器选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_8_0"), nil, {func_string = [[state_machine.excute("login_select_server", 0, "login_select_server")]],touch_scale = true}, nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then
		local Button_gonggao = ccui.Helper:seekWidgetByName(root, "Button_gonggao")
		Button_gonggao:setVisible(false)
		fwin:addTouchEventListener(Button_gonggao, nil, 
		{
			terminal_name = "login_announce_show_open",  
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
		if __lua_project_id == __lua_project_gragon_tiger_gate then
			local bg = ccui.Helper:seekWidgetByName(root, "Panel_login")
			bg:addChild(sp.spine("images/ui/atlas/kaiji_001.json", "images/ui/atlas/kaiji_001.atlas", 1, 0, "kaiji_001", true, nil))
		end
	end

	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then 
		--开始游戏
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_play"), nil, 
		{
			func_string = [[state_machine.excute("login_vali_register", 0, "login_vali_register")]], 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	else
		--开始游戏
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_play"), nil, 
		{
			-- func_string = [[state_machine.excute("login_vali_register", 0, "login_vali_register")]],
			terminal_name = "login_check_first",
			terminal_state = 0,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	

	

	local Image_8_1 = ccui.Helper:seekWidgetByName(root, "Image_8_1")
	if Image_8_1 ~= nil then
		fwin:addTouchEventListener(Image_8_1, nil, 
		{
			func_string = [[state_machine.excute("login_change_account", 0, "login_change_account")]], 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end

	if ccui.Helper:seekWidgetByName(root, "Image_8") ~= nil then
		ccui.Helper:seekWidgetByName(root, "Image_8"):setVisible(false)
	end
	local serverNameLabel = ccui.Helper:seekWidgetByName(self.roots[1], "Label_server_name")
	--serverNameLabel:enableOutline(cc.c4b(255,0,0,255), 2)
	--serverNameLabel:enableShadow(cc.c4b(255,0,0,255), cc.size(2, -2))
	--serverNameLabel:enableGlow(cc.c4b(255,0,0,255))
	
	serverNameLabel:setString(_string_piece_info[1])

	local serverNameLabel1 = ccui.Helper:seekWidgetByName(root, "Label_user_id2")
	local serverNameLabel2 = ccui.Helper:seekWidgetByName(root, "Label_user_id1")
	if serverNameLabel1 ~= nil then
		serverNameLabel1:setVisible(false)
	end
	if serverNameLabel2 ~= nil then
		serverNameLabel2:setVisible(false)
	end
	
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if app.configJson.UserAccountPlatformName == "jar-world" 
		or  app.configJson.UserAccountPlatformName == "jar-world-android" 
		or app.configJson.UserAccountPlatformName == "jar-world-ios" 
		or targetPlatform == cc.PLATFORM_OS_WINDOWS
		or targetPlatform == cc.PLATFORM_OS_MAC
		then
		--如果打开了自己的登陆系统
		if config_operation.AccountManager == true then
		else
			state_machine.excute("login_platform_account", 0, "login_platform_account.")
		end
	end
	
	--注销账号
	local Button_zhuxiao = ccui.Helper:seekWidgetByName(root, "Button_zhuxiao")
	if Button_zhuxiao~=nil then
		fwin:addTouchEventListener(Button_zhuxiao, nil, 
		{
			func_string = [[state_machine.excute("tencent_account_cancellation", 0, "tencent_account_cancellation")]], 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	
	-- android渠道请求初始化
	-- if app.configJson.UserAccountPlatformName == "play800-android" or app.configJson.UserAccountPlatformNam == "uc" 
	-- or app.configJson.UserAccountPlatformNam == "duoku" or app.configJson.UserAccountPlatformNam == "360" then
		-- handlePlatformRequest(0, CC_INIT_PLATFORM_PARAM, "")
	-- end
		
	-- state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
	
	app.load("client.cells.prop.hero_shop_list_cell")

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		app.load("client.formation.FormationTigerGate")
		state_machine.excute("formation_release_instance_window", 0, nil)
	end
	
	-- local itemCell = HeroShopListCell:createCell()
	-- itemCell:init({user_prop_template = 1, mould_id = 1, prop_number = 2, buy_type = 1, picel = 20,})
	-- self:addChild(itemCell)

	function cc.blendFunc(_src, _dst)
		return {src = _src, dst = _dst}
	end

	-- -- local background = cc.Sprite:create("images/effice_10.png")
 -- --    background:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
 -- --    background:setAnchorPoint(cc.p(0, 0))
 -- --    self:addChild(background, 10000)

 -- -- 	local grossini = cc.Sprite:create("images/effice_10.png")

	-- -- self:addChild(grossini, 1000)

	-- local armature = draw.createEffect("effice_1", "effect/effice_1.ExportJson", self, 10, 100)
	-- armature:setPosition(cc.p(320, 220))
	-- local t = armature:getBoneDic()
	-- for i, v in pairs(t) do
	--> print(i, v)
	-- end
	-- display:gray(self)
	--开机动画
	if config_res ~= nil and
		config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
	else
		local Panel_anmi_1 = ccui.Helper:seekWidgetByName(root, "Panel_anmi_1")
		if Panel_anmi_1 ~= nil then 
			Panel_anmi_1:removeAllChildren(true)
			local jsonPath = "images/ui/effice/effect_1/effect_1.json"
		    local atlasPath = "images/ui/effice/effect_1/effect_1.atlas"
		    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
		    animation:setPosition(cc.p(Panel_anmi_1:getContentSize().width/2,Panel_anmi_1:getContentSize().height/2))
		    Panel_anmi_1:addChild(animation)
		end
	end
	local Panel_anmi_2 = ccui.Helper:seekWidgetByName(root, "Panel_anmi_2")
	if Panel_anmi_2 ~= nil then 
		Panel_anmi_2:removeAllChildren(true)
		local jsonPath = "images/ui/effice/effect_2/effect_2.json"
	    local atlasPath = "images/ui/effice/effect_2/effect_2.atlas"
	    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
	    animation:setPosition(cc.p(Panel_anmi_2:getContentSize().width/2,Panel_anmi_2:getContentSize().height/2))
	    Panel_anmi_2:addChild(animation)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		ccui.Helper:seekWidgetByName(root, "Image_8_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_36759"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Label_select"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Label_server_name"):setVisible(false)
	end
	local Label_select = ccui.Helper:seekWidgetByName(root, "Label_select")
	if Label_select then
		Label_select:setString(SelectTextStr)
	end
	if config_operation.userPrivacyProtocol ~= nil and config_operation.userPrivacyProtocol == true then
		local userPrivacyProtocol = cc.UserDefault:getInstance():getStringForKey("platform_user_privacy_protocol", "")
		if userPrivacyProtocol == nil or userPrivacyProtocol == "" or userPrivacyProtocol == "ok" then
			app.load("client.login.Manager.AccountUserPrivacyProtocol")
			state_machine.excute("account_user_privacy_protocol_open", 0, "")
		end
	end
	--如果打开了自己的登陆系统
	if app.configJson.OperatorName ~= "move" then
		if config_operation.AccountManager == true then
			state_machine.lock("login_vali_register")
			app.load("client.login.Manager.AccountSysFloatingWindow")
			if fwin:find("AccountSysFloatingWindowClass") == nil then
	            local cell = AccountSysFloatingWindow:new()
	            fwin:open(cell,fwin._taskbar)
	        end
			--获取设备最后一次登陆的账号信息
			if m_login_search_user == false then
				local function responseSearchCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						--获取之后的处理
						-- fwin:close(fwin:find("AccountSysManagerClass"))
						local automatic = cc.UserDefault:getInstance():getStringForKey("platform_account_Automatic_login", "")
						if automatic == nil or automatic == "" then
							--如果不是自动登陆的话打开账号管理界面
							app.load("client.login.Manager.AccountSysManager")
							state_machine.excute("account_sys_manager_open", 0, "account_sys_manager_open.")
						else
							--如果是自动登陆的话就登陆
							state_machine.excute("log_in_your_own_account_system", 0, "log_in_your_own_account_system.")
						end
					end
				end
				app.load("client.login.Manager.AccountSysManager")
				state_machine.excute("account_sys_manager_open", 0, "account_sys_manager_open.")
				NetworkManager:register(protocol_command.search_user_platform.code, app.configJson.url, nil, nil, nil, responseSearchCallback, false, nil)
			else
				-- fwin:close(fwin:find("AccountSysManagerClass"))
				-- if protocol_command.search_user_platform.user_info_switch == nil or protocol_command.search_user_platform.user_info_switch == false then
					local function responseSearchCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							app.load("client.login.Manager.AccountSysManager")
							state_machine.excute("account_sys_manager_open", 0, "account_sys_manager_open.")
						end
					end
					self:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
						NetworkManager:register(protocol_command.search_user_platform.code, app.configJson.url, nil, nil, nil, responseSearchCallback, false, nil)
					end)}))
				-- else
				-- 	app.load("client.login.Manager.AccountSysManager")
				-- 	state_machine.excute("account_sys_manager_open", 0, "account_sys_manager_open.")
				-- 	protocol_command.search_user_platform.user_info_switch = nil
				-- end
			end
		end
	end
end

function Login:load_next()
	dms.load("data/configs/user_config.txt")
	dms.load("data/mould/sound_effect_param.txt")
	dms.load("data/mould/fun_open_condition.txt")

	return true
end

-- Fury: precarga POR TANDAS de las tablas de data_path (las mismas que
-- login_enter_game cargaba de golpe al pulsar GAME START, 4 s de mediana con la
-- pantalla congelada). Se cargan mientras el jugador esta en la pantalla de
-- login, `presupuesto` segundos por fotograma (al menos una tabla). dms.load
-- guarda cada tabla por nombre: nada se duplica. El estado es de esta ventana:
-- al cambiar de idioma por ChooseLanguagePopup el cliente vacia dms
-- (localData_list_new_unload_next) y abre otro Login, que precarga de cero.
-- Si el idioma cambia sin eso, se recargan en sitio con la ruta nueva.
function Login:precargar(presupuesto)
	local p = self._precarga
	if p == nil then
		p = { lista = {}, i = 1, idioma = m_curr_choose_language, t0 = fury_ahora(), fotogramas = 0 }
		if nil ~= data_path then
			for _, v in pairs(data_path) do
				if type(v) == "table" then
					for _, m in pairs(v) do
						table.insert(p.lista, m)
					end
				elseif type(v) == "string" then
					table.insert(p.lista, v)
				end
			end
		end
		self._precarga = p
	end
	if m_curr_choose_language ~= nil and m_curr_choose_language ~= "" and m_curr_choose_language ~= p.idioma then
		p.idioma = m_curr_choose_language
		p.i = 1
		p.recargar = true
	end
	if p.i > #p.lista then
		return true
	end
	local reloj = fury_ahora
	local fin = reloj() + presupuesto
	-- Con os.time() (segundos enteros) el presupuesto no sirve: tope de tablas.
	local tope = (reloj == os.time) and math.max(1, math.floor(presupuesto * 200)) or nil
	local cargadas = 0
	p.fotogramas = p.fotogramas + 1
	repeat
		local ruta = p.lista[p.i]
		p.i = p.i + 1 -- antes de cargar: una tabla rota no atasca la precarga
		if true == p.recargar then
			dms.unload(ruta)
		end
		dms.load(ruta)
		cargadas = cargadas + 1
		-- AssetsManager deja word_mould formateada (dms.format) antes del login.
		if true == p.recargar and stripExtension(strippath(ruta)) == "word_mould" then
			dms.format("word_mould", 2)
		end
	until p.i > #p.lista or reloj() >= fin or (tope ~= nil and cargadas >= tope)
	if p.i > #p.lista then
		p.recargar = nil
		return true
	end
	return false
end

function Login:precargaHecha()
	return self._precarga ~= nil and self._precarga.i > #self._precarga.lista
end

function Login:precargaPorcentaje()
	local p = self._precarga
	if p == nil or #p.lista == 0 then
		return 0
	end
	return math.floor((p.i - 1) * 100 / #p.lista)
end

-- Avance de la precarga tras pulsar GAME START: la ruedecita de siempre
-- (ConnectingView) y el porcentaje encima. Se quita al acabar (onUpdate).
function Login:mostrarPrecarga()
	if self._precargaEtiqueta == nil or tolua.isnull(self._precargaEtiqueta) then
		state_machine.excute("connecting_view_window_open", 0, 0)
		local vista = fwin:find("ConnectingViewClass")
		local size = cc.Director:getInstance():getWinSize()
		local etiqueta = cc.Label:createWithSystemFont("", "", 28)
		etiqueta:setPosition(cc.p(size.width / 2, size.height / 2 - 70))
		if vista ~= nil then
			vista:addChild(etiqueta, 100)
		else
			self:addChild(etiqueta, 100)
		end
		self._precargaEtiqueta = etiqueta
	end
	self._precargaEtiqueta:setString(self:precargaPorcentaje() .. "%")
end

function Login:ocultarPrecarga()
	if self._precargaEtiqueta ~= nil then
		if not tolua.isnull(self._precargaEtiqueta) then
			self._precargaEtiqueta:removeFromParent()
		end
		self._precargaEtiqueta = nil
		state_machine.excute("connecting_view_window_close", 0, 0)
	end
end

function Login:onUpdate(dt)
	-- Fury: 10 ms por fotograma mientras se mira la pantalla; 100 ms si el
	-- jugador ya pulso GAME START y espera (el porcentaje se refresca igual).
	local precargaHecha = self:precargar(true == self._isClickLoginEnterGame and 0.1 or 0.01)
	if precargaHecha == true then
		self:ocultarPrecarga()
	elseif true == self._isClickLoginEnterGame then
		self:mostrarPrecarga()
	end
	if self.action ~= nil then
		self.action:gotoFrameAndPlay(0, self.action:getDuration(), false)
		self.action = nil

		-- 注释无用代码！！！！！！
		-- if app.configJson.UserAccountPlatformName ~= "jar-world" and app.configJson.UserAccountPlatformNam ~= "uc" and app.configJson.UserAccountPlatformNam ~= "tencent" then
		-- 	state_machine.excute("platform_manager_open_sdk_interface", 0, "platform_manager_open_sdk_interface.")
		-- end
		-- if app.configJson.UserAccountPlatformName == "play800-android" or app.configJson.UserAccountPlatformNam == "uc" then
			-- handlePlatformRequest(0, CC_INIT_PLATFORM_PARAM, "")
		-- end

		if app.configJson.OperatorName == "huawei" or (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then
			if m_sdk_init_success == false then
				state_machine.excute("platform_manager_sdk_init", 0, { messageType = ENTERED_THE_GAME ,messageText = ""})
			elseif m_sdk_login_success == false then
				state_machine.excute("platform_manager_login", 0, { messageType = LOGIN ,messageText = ""})
			else
				state_machine.excute("platform_manager_login_success", 0, { platformInfo = "" })
				state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
			end
		else
			-- 通知底层初始化谷歌支付相关
			handlePlatformRequest(0, ENTERED_THE_GAME, "")
			state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
		end
	end
	self:updatePlatformAccountLoginStatus()
	--登录成功打开公告
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
	or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
	or __lua_project_id == __lua_project_koone
	or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
	or __lua_project_id == __lua_project_red_alert
	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
	or __lua_project_id == __lua_project_adventure
	then
		local isShowData = true
		local isGetServers = false --防止还未获取到服务器就进去了
		for i, v in pairs(_ED.all_servers) do
			isGetServers = true
			if zstring.tonumber(v.server_number)%1000 == 999 then
				isShowData = false
			end
		end
		if isGetServers == false then
			return
		end
		if isShowData == true then
			if app.configJson.urlForAnnounce ~= nil then 
				if self.announcePage_state == 0 then
					self.announcePage_state = 1
				end	
				
				if self.announcePage_state == 1 then
					if _ED.default_user ~= nil and _ED.default_user ~= "" and 
					  _ED.user_platform[_ED.default_user] ~= nil and _ED.user_platform[_ED.default_user] ~= "" then
						self.announcePage_state = 2
						-- if app.configJson.PayOperatorName == "app" then
							-- local server_review = cc.UserDefault:getInstance():getStringForKey("server_review", "1")
							-- if server_review == "1" then
								-- return
							-- end
						-- end
						local function responseSystemNotice(response)
							-- La pantalla de login ya no esta (peer vacio): no hay boton ni aviso que abrir.
							if self.roots == nil then return end
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if __lua_project_id == __lua_project_adventure then 
									app.load("client.adventure.system.notice.AdventureNotice")
									fwin:open(AdventureNotice:new():init(1))
								else 
									app.load("client.system.AnnouncePage")
									if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
										local Button_gonggao = ccui.Helper:seekWidgetByName(self.roots[1], "Button_gonggao")
										Button_gonggao:setVisible(true)
									elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
										if #_lua_release_language_param > 1 then
											local Button_gonggao = ccui.Helper:seekWidgetByName(self.roots[1], "Button_gonggao")
											Button_gonggao:setVisible(true)
										end
									end
									if __lua_project_id == __lua_project_red_alert then
										app.load("client.red_alert.game_announcement.GameAnnouncement")
										state_machine.excute("game_announcement_window_open",0,"")
									elseif __lua_project_id == __lua_project_red_alert_time 
										or __lua_project_id == __lua_project_pacific_rim 
										or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
										or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
										or __lua_project_id == __lua_project_l_naruto 
										then
										app.load("client.red_alert_time.game_announcement.GameAnnouncement")
										state_machine.excute("game_announcement_window_open",0,"")
									else
										fwin:close(fwin:find("AnnouncePageClass"))
										fwin:open(AnnouncePage:new())
									end
									protocol_command.get_system_notice.isShow = true
								end
							else
								state_machine.excute("login_ui_control", 0, true)	
							end
						end
						if protocol_command.get_system_notice.isShow == nil or protocol_command.get_system_notice.isShow == false then
							state_machine.excute("login_ui_control", 0, false)
							if #_lua_release_language_param > 1 then
								local _current_language = cc.UserDefault:getInstance():getStringForKey("current_language", "")
								if _current_language ~= "" then
									m_curr_choose_language = _current_language
									app.setSearchPaths(_current_language)
								else
									cc.UserDefault:getInstance():setStringForKey("current_language", "zh_TW")
									m_curr_choose_language = "zh_TW"
									cc.UserDefault:getInstance():flush()
								end
							else
								local _current_language = cc.UserDefault:getInstance():getStringForKey("current_language", "")
								if _current_language ~= "" then
									m_curr_choose_language = _current_language
								else
									m_curr_choose_language = app.configJson.ReleaseLanguage
								end
							end
							NetworkManager:register(protocol_command.get_system_notice.code, app.configJson.urlForAnnounce, nil, nil, nil, responseSystemNotice, false, nil)
						end
					end
				end	
			end	
		end	
	end

	if false == self._isLoadLocalDataComplete then
		-- self._isLoadLocalDataComplete  = localData_list_load_next()
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			self._isLoadLocalDataComplete = self:load_next()
		else
			self._isLoadLocalDataComplete  = localData_list_load_next()
		end
	elseif true == self._isLoadLocalDataComplete then
		if true == self._isClickLoginEnterGame and true == precargaHecha then
			state_machine.excute("login_vali_register", 0, "login_vali_register.")
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if ccui.Helper:seekWidgetByName(self.roots[1], "Image_8_0"):isVisible() == false then
				ccui.Helper:seekWidgetByName(self.roots[1], "Image_8_0"):setVisible(true)
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_36759"):setVisible(true)
				ccui.Helper:seekWidgetByName(self.roots[1], "Label_select"):setVisible(true)
				ccui.Helper:seekWidgetByName(self.roots[1], "Label_server_name"):setVisible(true)
			end
		end
	else
		if true == _ED.wait_user_data_combine then
			self._wait_user_data_combine_interval = self._wait_user_data_combine_interval - dt
			if self._wait_user_data_combine_interval < 0 then
				_ED.wait_user_data_combine = false
				state_machine.excute("login_vali_register", 0, "login_vali_register.")
			end
		end
	end
end

-- function Login:openGameAnnouncement()
-- 	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
-- 	or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
-- 	or __lua_project_id == __lua_project_koone
-- 	or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
-- 	or __lua_project_id == __lua_project_red_alert
-- 	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
-- 	or __lua_project_id == __lua_project_adventure
-- 	then
-- 		local isShowData = true
-- 		local isGetServers = false --防止还未获取到服务器就进去了
-- 		for i, v in pairs(_ED.all_servers) do
-- 			isGetServers = true
-- 			if zstring.tonumber(v.server_number)%1000 == 999 then
-- 				isShowData = false
-- 			end
-- 		end
-- 		if isGetServers == false then
-- 			return
-- 		end
-- 		if isShowData == true then
-- 			if app.configJson.urlForAnnounce ~= nil then 
-- 				if self.announcePage_state == 0 then
-- 					self.announcePage_state = 1
-- 				end	
				
-- 				if self.announcePage_state == 1 then
-- 					if _ED.default_user ~= nil and _ED.default_user ~= "" and 
-- 					  _ED.user_platform[_ED.default_user] ~= nil and _ED.user_platform[_ED.default_user] ~= "" then
-- 						self.announcePage_state = 2
-- 						-- if app.configJson.PayOperatorName == "app" then
-- 							-- local server_review = cc.UserDefault:getInstance():getStringForKey("server_review", "1")
-- 							-- if server_review == "1" then
-- 								-- return
-- 							-- end
-- 						-- end
-- 						local function responseSystemNotice(response)
-- 							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
-- 								if __lua_project_id == __lua_project_adventure then 
-- 									app.load("client.adventure.system.notice.AdventureNotice")
-- 									fwin:open(AdventureNotice:new():init(1))
-- 								else
-- 									app.load("client.system.AnnouncePage")
-- 									if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
-- 										local Button_gonggao = ccui.Helper:seekWidgetByName(self.roots[1], "Button_gonggao")
-- 										Button_gonggao:setVisible(true)
-- 									elseif __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
-- 										if #_lua_release_language_param > 1 then
-- 											local Button_gonggao = ccui.Helper:seekWidgetByName(self.roots[1], "Button_gonggao")
-- 											Button_gonggao:setVisible(true)
-- 										end
-- 									end
-- 									if __lua_project_id == __lua_project_red_alert then
-- 										app.load("client.red_alert.game_announcement.GameAnnouncement")
-- 										state_machine.excute("game_announcement_window_open",0,"")
-- 									elseif __lua_project_id == __lua_project_red_alert_time 
-- 										or __lua_project_id == __lua_project_pacific_rim 
-- 										or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
-- 										or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
-- 										or __lua_project_id == __lua_project_l_naruto 
-- 										then
-- 										app.load("client.red_alert_time.game_announcement.GameAnnouncement")
-- 										state_machine.excute("game_announcement_window_open",0,"")
-- 									else
-- 										fwin:close(fwin:find("AnnouncePageClass"))
-- 										fwin:open(AnnouncePage:new())
-- 									end
-- 									protocol_command.get_system_notice.isShow = true
-- 								end
-- 							else
-- 								state_machine.excute("login_ui_control", 0, true)	
-- 							end
-- 						end
-- 						if protocol_command.get_system_notice.isShow == nil or protocol_command.get_system_notice.isShow == false then
-- 							state_machine.excute("login_ui_control", 0, false)
-- 							NetworkManager:register(protocol_command.get_system_notice.code, app.configJson.urlForAnnounce, nil, nil, nil, responseSystemNotice, false, nil)
-- 						end
-- 					end
-- 				end
-- 			else
-- 				state_machine.excute("login_ui_control", 0, true)
-- 			end	
-- 		end	
-- 	end
-- end

function Login:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then
		cacher.destoryRefPools()
		cacher.cleanActionTimeline()
		checkTipBeLeave()		
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
	end
end

function Login:onExit()
	self:ocultarPrecarga()
	state_machine.remove("login_announce_show_open")
	state_machine.remove("login_platform_account")
	state_machine.remove("login_get_server_list")
	state_machine.remove("login_select_server")
	state_machine.remove("login_vali_register")
	state_machine.remove("login_enter_game")
	state_machine.remove("login_ui_control")
	state_machine.remove("login_change_account")
	state_machine.remove("tencent_account_cancellation")
	state_machine.remove("login_check_first")
	state_machine.excute("main_window_login_popup_banner", 0, nil)
	-- state_machine.remove("login_character_create")
end