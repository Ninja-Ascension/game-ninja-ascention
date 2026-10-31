LoginLoading = class("LoginLoadingClass", Window)

function LoginLoading:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.totalNum = 5
	self.basePosX = 0
	self.isLoadPng = false
	self.isLoadPlist = false
	self.isLoadCacher = false
	self.isLoadActivity = false
	self.isLoadFormation = false
	self.isBeginLoad = false
	self.selectIndex = 0

	app.load('client.utils.DrawHandle')
	local function init_login_loading_terminal()

		local character_create_show_home_terminal = {
            _name = "character_create_show_home",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("character_create_show_home", 0, 0)
				local function responseEnterGame(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						NetworkManager:registerUrl(_ED.all_servers[_ED.selected_server].server_link)
						updateDefaultServerFile()

						local writeInfo = cc.UserDefault:getInstance():getStringForKey("server")
						local server  = cc.UserDefault:getInstance():getStringForKey("server")
						local estr = "esgg"..server
						cc.UserDefault:getInstance():setStringForKey(estr, "0")
						local estrTwo = "esggp"..server
						cc.UserDefault:getInstance():setStringForKey(estrTwo, "0")
						cc.UserDefault:getInstance():flush()

						app.load("client.utils.texture_cache")

						app.load("configs.csb.config")

						state_machine.excute("platform_the_roles_tracking", 0, "platform_the_roles_tracking.")


						jttd.NewAPPeventSlogger("2|".._ED.user_info.user_id)
						jttd.NewAPPeventSlogger("3|1")
						jttd.facebookAPPeventSlogger("2")
						if app.configJson.OperatorName == "cayenne" then
							jttd.facebookAPPeventSlogger("2|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id)
						end
						if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then

						end
					end
				end

				local function responseStartGame(response)
            		state_machine.unlock("character_create_show_home", 0, 0)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local str = getPlatform().."\r\n"
						str = str ..getHardwareType().."\r\n"
						str = str .._ED.user_platform[_ED.default_user].platform_account.."\r\n"
						str = str .._ED.user_platform[_ED.default_user].password.."\r\n"
						str = str ..getApplicationName().."\r\n"
						str = str .._ED.selected_server
						protocol_command.login_init.param_list = str
						protocol_command.login_init_again.param_list = str
						local server = _ED.all_servers[_ED.selected_server]
						m_first_role = true
						jttd.NewAPPeventSlogger("1")
						if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
							jttd.facebookAPPeventSlogger("15|".._ED.default_user)
							jttd.facebookAPPeventSlogger("5|".._ED.default_user)
							jttd.facebookAPPeventSlogger("4|".._ED.default_user)
							jttd.facebookAPPeventSlogger("1")
						end

						NetworkManager:register(protocol_command.login_init.code, server.server_link, nil, nil, response.node, responseEnterGame, false, nil)

						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							local function callbackRoleTime( response )
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									state_machine.excute("platform_the_role_establish", 0, { names = zstring.exchangeTo(_ED.current_random_name)})
									state_machine.excute("platform_the_roles_tracking", 0, "platform_the_roles_tracking.")
								end
							end
							NetworkManager:register(protocol_command.user_create_time.code, nil, nil, nil, self, callbackRoleTime, false, nil)
						else
							state_machine.excute("platform_the_role_establish", 0, { names = zstring.exchangeTo(_ED.current_random_name)})
						end


					end

				end

				local user_info = _ED.user_platform[_ED.default_user]



				local str = user_info.platform_account.."\r\n"
				str = str..user_info.password.."\r\n"
				str = str..getVersion().."\r\n"
				local userName = zstring.exchangeTo(_ED.current_random_name)
				str = str..userName.."\r\n"

				if self.selectIndex  == 0 then
					str = str .."1".."\r\n"
				else
					str = str .."6".."\r\n"
				end

				local camp = tonumber(self.selectIndex)+1
				str = str ..camp .."\r\n"

				local gender = tonumber(self.selectIndex)+1
				str = str ..gender.."\r\n"

				str = str ..getApplicationName().."\r\n"
				str = str .._ED.selected_server.."\r\n"
				str = str .."".."\r\n"
				protocol_command.register_game_account.param_list = str

				local server = _ED.all_servers[_ED.selected_server]
				if #_ED.current_random_name > 18 then


					return
				elseif #_ED.current_random_name < 1 then


					return
				end











				NetworkManager:register(protocol_command.register_game_account.code, server.server_link, nil, nil, params, responseStartGame, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local login_loading_change_name_terminal = {
            _name = "login_loading_change_name",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseChangeNameCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							state_machine.excute("character_create_show_home", 0, response.node)
						end
					end
				end
				protocol_command.get_random_name.param_list = self.selectIndex
				local server = _ED.all_servers[_ED.selected_server]
				NetworkManager:register(protocol_command.get_random_name.code, server.server_link, nil, nil, params, responseChangeNameCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(character_create_show_home_terminal)
		state_machine.add(login_loading_change_name_terminal)
        state_machine.init()
    end

    init_login_loading_terminal()
end

function LoginLoading:init(  )




















	if _ED.user_info.user_id == "" or tonumber(_ED.user_info.user_id) == 0 or ("l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience == "l1e0") then
		self._unload = true
		app.load("client.cells.utils.sm_item_icon_cell")
		app.load("client.home.Menu")
		app.load("client.battle.landscape.FightLoading")

		app.load("client.utils.texture_cache")

		app.load("configs.csb.config")




		local fightLoadingCell = FightLoadingCell:new():init(0)
		fightLoadingCell:onAddLoginLoading()
		fwin:open(fightLoadingCell, fwin._windows)
		fwin._current_music = nil
		fwin._stop_music = true
		playBgm(formatMusicFile("background", 3))
	else
		local currHomeBgm = readKey("m_curr_home_bgm")
		playBgm(formatMusicFile("background", tonumber(currHomeBgm)))
		self:onInit()
	end
	return self
end

function LoginLoading:onInit( ... )
	if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
	cacher.destoryRefPools()
	fwin:reset(nil)
	cacher.cleanSystemCacher()
	cacher.cleanActionTimeline()
	checkTipBeLeave()
	cacher.removeAllTextures()
	cacher.remvoeUnusedArmatureFileInfoes()


    local csbBattleLoadingCell = csb.createNode("utils/donghua_loading.csb")
	local root = csbBattleLoadingCell:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbBattleLoadingCell)

	self.Text_loading_01 = ccui.Helper:seekWidgetByName(root, "Text_loading_01")
	self.Text_loading_02 = ccui.Helper:seekWidgetByName(root, "Text_loading_02")
	self.Text_loading_01:setString(_string_piece_info[376])
	self.Text_loading_02:setString("5/100")

	self.Panel_loading_ing = ccui.Helper:seekWidgetByName(root, "Panel_loading_ing")
	self.basePosX = self.Panel_loading_ing:getPositionX()

	self.loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_112")

	local width = self.loadingBar:getContentSize().width
    self.Panel_loading_ing:setPositionX(self.basePosX + width * self.totalNum/100)

	if tipStringInfo_loading_notice_info ~= nil then
		local count = #tipStringInfo_loading_notice_info
		local id = 1 + math.floor(math.random() * count)
		if id > count then
	        id = count
	    end
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		    if tonumber(_ED.scene_current_state[1]) >= 0 then
		    	if tonumber(_ED.npc_state[1]) <= 0 then
		    		id = 1
				elseif tonumber(_ED.npc_state[2]) <= 0 then
					id = 2
				elseif tonumber(_ED.npc_state[3]) <= 0 then
					id = 3
				end
		    end
		end
	    ccui.Helper:seekWidgetByName(root, "Text_tishi"):setString(tipStringInfo_loading_notice_info[id])
	end

	local action = csb.createTimeline("utils/donghua_loading.csb")
    table.insert(self.actions, action)

    self:unregisterOnNoteUpdate(self)

    csbBattleLoadingCell:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_close_over" then
        	fwin:close(self)

        end
    end)
    action:play("window_open", false)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
		local random = math.ceil(math.random(0, 3))
		if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			random = math.ceil(math.random(0, 6))
		end
	 	if tonumber(_ED.scene_current_state[1]) >= 0 then
	    	if tonumber(_ED.npc_state[1]) <= 0 then
	    		random = 0
			elseif tonumber(_ED.npc_state[2]) <= 0 then
				random = 2
			elseif tonumber(_ED.npc_state[3]) <= 0 then
				random = 3
			end
	    end
	    Image_1:loadTexture(string.format("images/ui/battle/kaichang/zy_%s.png", random))
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		function blinkOutCallback(sender)
			self.isBeginLoad = true
		end
		self:runAction(cc.Sequence:create(
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(blinkOutCallback)
                        ))
	else
		local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
		Panel_donghua:setVisible(true)
		local ArmatureNode_2 = Panel_donghua:getChildByName("ArmatureNode_2")
	    local animation = ArmatureNode_2:getAnimation()

	    local function changeActionCallback( armatureBack )
	        local _self = armatureBack._self
	        local actionIndex = armatureBack._actionIndex
	        armatureBack:pause()
	        if actionIndex == 0 then
	        	_self.isBeginLoad = true
	        elseif actionIndex == 2 then
	        	Panel_donghua:setVisible(false)
	        end
	    end

	    local random = math.ceil(math.random(1, 3))

	    local kcIcon = ccs.Skin:create(string.format("images/ui/battle/kaichang/zy_%s.png", random))
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
		    ArmatureNode_2:getBone("Layer1"):addDisplay(kcIcon, 0)
		end
	    ArmatureNode_2._invoke = changeActionCallback
	    ArmatureNode_2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	    ArmatureNode_2._self = self

	    csb.animationChangeToAction(ArmatureNode_2, 0, 0, false)

	end
end

function LoginLoading:onUpdate( dt )
	if self.isBeginLoad == false or self._unload == true then
		return
	end
	if self.totalNum >= 100 then
		self:loadingSuccess()
		return
	else
		self:checkLoginLoading(nil, true)
	end

	local width = self.loadingBar:getContentSize().width
    self.Panel_loading_ing:setPositionX(self.basePosX + width * self.totalNum/100)

	self.loadingBar:setPercent(self.totalNum)
	self.Text_loading_02:setString(self.totalNum.."/100")
end

function LoginLoading:checkLoginLoading( baseWindow, loginIn )
	if self.totalNum == 8 and loginIn == false then
		if nil ~= baseWindow then
			baseWindow._unload = true
			if _ED.user_info.user_id == "" or tonumber(_ED.user_info.user_id) == 0 then
				state_machine.excute("login_loading_change_name", 0, baseWindow)
			else
				if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then

				end
			end
		end
	elseif self.totalNum >= 20 and self.totalNum <= 30 and self.isLoadPng == false then


		NetworkAdaptor.XMLHttpRequest.open_auto_reconnect = true
		if nil ~= NetworkAdaptor.LuaSocket.url then
            NetworkAdaptor.intSocket()
        end
	elseif self.totalNum >= 35 and self.totalNum <= 40 and self.isLoadPlist == false then
		self:loadingPlist()
	elseif self.totalNum >= 50 and self.totalNum <= 65 and self.isLoadCacher == false then
		self:loadingCacherCsb()
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
			for i,v in pairs(_ED.user_ship) do
				setShipPushData(v.ship_id,0,-1)
			end
		end

	elseif self.totalNum >= 70 and self.totalNum <= 75 and self.isLoadActivity == false then
		self:loadingActivity()
	elseif self.totalNum >= 85 and self.totalNum <= 90 and self.isLoadFormation == false then
		self:loadingFormation()
	end
	self.totalNum = self.totalNum + 1
end

function LoginLoading:loadingShipData( ... )
	for i= 1 ,4 do
		_ED.all_ship_mould[i] = dms.searchs(dms["ship_mould"], ship_mould.camp_preference, i)
	end
end
function LoginLoading:loadingSuccess( ... )
	if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
		jttd.facebookAPPeventSlogger("2")
	end
	self:requestSomeInitData()
	self:unregisterOnNoteUpdate(self)
	app.load("client.home.Menu")
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
	fwin:__show(fwin._frameview)
    self:closeUi()
    fwin._current_music = nil
end

function LoginLoading:closeUi( ... )
	local action = self.actions[1]
    action:play("window_close", false)
    local root = self.roots[1]
    self.Panel_loading_ing:setVisible(false)
    local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
	local ArmatureNode_2 = Panel_donghua:getChildByName("ArmatureNode_2")
	if ArmatureNode_2 ~= nil then
		ArmatureNode_2:resume()
	    csb.animationChangeToAction(ArmatureNode_2, 2, 2, false)

    end
end

function LoginLoading:loadingPng( ... )
	self.isLoadPng = true
	local function loaded( ... )

	end
	local _pic = {
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
	}
	local textureCache = cc.Director:getInstance():getTextureCache()
	for k,v in pairs(_pic) do

		textureCache:addImageAsync(v, loaded, nil, false, true)
	end
end
if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
	then
	LoginLoading._plist = {
		{
			_png = "images/ui/home/home.png",
			_plist = "images/ui/home/home.plist"
		}
	}
	localData_list_new_load_next()
else
	LoginLoading._plist = {
		{
			_png = "images/ui/home/home.png",
			_plist = "images/ui/home/home.plist"
		},
		{
			_png = "images/ui/play/wonderful_activity/seven_day/seven_day.png",
			_plist = "images/ui/play/wonderful_activity/seven_day/seven_day.plist"
		},
		{
			_png = "images/ui/play/wonderful_activity/wonderful_activity.png",
			_plist = "images/ui/play/wonderful_activity/wonderful_activity.plist"
		},
		{
			_png = "images/ui/play/wonderful_activity/wonderful_activity_1.png",
			_plist = "images/ui/play/wonderful_activity/wonderful_activity_1.plist"
		}
	}
end
function LoginLoading.load_plist()

	for k,v in pairs(LoginLoading._plist) do
		cc.SpriteFrameCache:getInstance():addSpriteFrames(v._plist)
	end
end

function LoginLoading:loadingPlist( ... )
	self.isLoadPlist = true
	local function loaded( ... )

	end
























end

function LoginLoading:loadingCacherCsb( ... )
	self.isLoadCacher = true
	csbCacher.destoryRefPools()

	local totalCount = #csb_cacher_path
	local index = 1
	local function delatEnd( sender )
		if index > totalCount then
			self:stopAllActionsByTag(100)
			return
		end
		local info = csb_cacher_path[index]
		for j=1, tonumber(info[3]) do
			csbCacher.createUIRef(info[2], "root")
		end

		index = index + 1
		if index > totalCount then
			self:stopAllActionsByTag(100)
		end
	end
	delatEnd()
	local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.02), cc.CallFunc:create(delatEnd)))
	self:runAction(action)
	action:setTag(100)


end

function LoginLoading:loadingActivity( ... )
	self.isLoadActivity = true
	app.load("client.activity.ActivityWindow")
	state_machine.excute("activity_window_open", 0, {nil, "DailySignIn"})
	state_machine.excute("activity_window_hide", 0, nil)
	fwin._current_music = nil
end

function LoginLoading:loadingFormation( ... )



	self.isLoadFormation = true
	app.load("client.formation.FormationTigerGate")
	state_machine.excute("formation_open_instance_window", 0, {_datas = {}})
	fwin._current_music = nil
end

function LoginLoading:onEnterTransitionFinish()

end

function LoginLoading:onExit()

end

function LoginLoading:loadArmature( ... )
	local path = "images/ui/effice/effect_kaichang/effect_kaichang.ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
end

function LoginLoading:unLoadArmature( ... )
	local path = "images/ui/effice/effect_kaichang/effect_kaichang.ExportJson"
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(path)
end

function LoginLoading:requestSomeInitData( ... )
	NetworkManager:register(protocol_command.ship_purify_init.code, nil, nil, nil, nil, nil, false, nil)
	local function responseInitCallback(response)
	end
	protocol_command.email_init.param_list = "-1" .."\r\n".."1" .."\r\n" ..  "30"
	NetworkManager:register(protocol_command.email_init.code, nil, nil, nil, nil, responseInitCallback, false, nil)
	local function responseUnionLInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then







		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseUnionLInitCallback, false, nil)
	else
		local userlevel = tonumber(_ED.user_info.user_grade)
	    local openautolevel = tonumber(dms.string(dms["fun_open_condition"], 11, fun_open_condition.level))
	    if userlevel >= openautolevel then
			NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseUnionLInitCallback, false, nil)
		end

		local userlevel = tonumber(_ED.user_info.user_grade)
	    local openautolevel = tonumber(dms.string(dms["fun_open_condition"], 55, fun_open_condition.level))
	    if userlevel >= openautolevel then
			local function responseCaptureCallback(response)
			end
			NetworkManager:register(protocol_command.map_scattered_init.code, nil, nil, nil, nil, responseCaptureCallback, false, nil)
	    end

	    local isOpen_warcrft = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 57, fun_open_condition.level)
		if isOpen_warcrft == true and _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
			local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
			protocol_command.warcraft_info_refrush.param_list = currentServerNumber
			NetworkManager:register(protocol_command.warcraft_info_refrush.code, _ED.union_fight_url, nil, nil, nil, nil, false, nil)
		end
	end
end