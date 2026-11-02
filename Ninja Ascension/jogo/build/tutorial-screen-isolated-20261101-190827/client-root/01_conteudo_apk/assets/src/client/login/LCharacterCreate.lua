-- ----------------------------------------------------------------------------------------------------
-- 说明：角色创建界面 -- 龙虎门
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
LCharacterCreate = class("LCharacterCreateClass", Window)

function LCharacterCreate:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.selectIndex = -1
	
    local function init_LCharacterCreate_terminal()
		
		local LCharacterCreate_click_make_boy_terminal = {
            _name = "LCharacterCreate_click_make_boy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function changeActionCallback(armatureBack)
					local instance = fwin:find("LCharacterCreateClass")
					if instance.boy._lock == true then
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nan_open"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nan_cs"):setVisible(true)
						csb.animationChangeToAction(instance.boy, 0, 0, nil)
						instance.boy_touch._invoke = nil
					end
				end
				instance.boy_touch._invoke = changeActionCallback
				-- instance._role_action:play("Button_autobot_untouch", false)
				-- instance._role_action:play("Button_decepticons_touch", false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nan_cs"):setVisible(false)
				instance._role_action:play("dj_qiehuan_2", false)
				instance._role_action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "dj_qiehuan_2_over" then
						
						local instance = fwin:find("LCharacterCreateClass")
						local Panel_nan_open = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nan_open")
						Panel_nan_open:setVisible(true)
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nan_cs"):setVisible(false)
						-- local ArmatureNode_1 = Panel_nan_open:getChildByName("ArmatureNode_nan_open")
						-- draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
						-- ArmatureNode_1._invoke = nil
						-- ArmatureNode_1:getAnimation():playWithIndex(0, 0, 0)
						-- ArmatureNode_1._invoke = changeActionCallback
						
						instance.boy._lock = false
						instance.girl._lock = true
						csb.animationChangeToAction(instance.boy_touch, 1, 1, nil)
					end
				end)
		
				
				-- state_machine.excute("character_create_change_name", 0, "character_create_change_name.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local LCharacterCreate_click_make_girl_terminal = {
            _name = "LCharacterCreate_click_make_girl",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function changeActionCallback(armatureBack)
					local instance = fwin:find("LCharacterCreateClass")
					if instance.girl._lock == true then
					else
						local instance = fwin:find("LCharacterCreateClass")
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nv_open"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nv_cs"):setVisible(true)
						csb.animationChangeToAction(instance.girl, 0, 0, nil)
						instance.girl_touch._invoke = nil
					end
				end
				instance.girl_touch._invoke = changeActionCallback
				-- instance._role_action:play("Button_decepticons_untouch", false)
				-- instance._role_action:play("Button_autobot_touch", false)
				instance._role_action:play("dj_qiehuan_1", false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nv_cs"):setVisible(false)
				instance._role_action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "dj_qiehuan_1_over" then
						local instance = fwin:find("LCharacterCreateClass")
						local Panel_nv_open = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nv_open")
						Panel_nv_open:setVisible(true)
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_nv_cs"):setVisible(false)
						-- local ArmatureNode_1 = Panel_nv_open:getChildByName("ArmatureNode_nv_open")
						-- draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
						-- ArmatureNode_1._invoke = nil
						-- ArmatureNode_1:getAnimation():playWithIndex(0, 0, 0)
						-- ArmatureNode_1._invoke = changeActionCallback
						instance.boy._lock = true
						instance.girl._lock = false
						csb.animationChangeToAction(instance.girl_touch, 1, 1, nil)
					end
				end)
				
				-- state_machine.excute("character_create_change_name", 0, "character_create_change_name.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local character_create_show_login_terminal = {
            _name = "character_create_show_home",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("character_create_show_home", 0, 0)
				instance:detachWithIME()
				local roleName = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_name_1")
				local roleNameTextFieldString = roleName:getString()
				if roleNameTextFieldString == nil or #roleNameTextFieldString == 0 then
					TipDlg.drawTextDailog(_string_piece_info[315])
					state_machine.unlock("character_create_show_home", 0, 0)
					return
				end
				if #roleNameTextFieldString > 18 then
					TipDlg.drawTextDailog(_string_piece_info[314])
					state_machine.unlock("character_create_show_home", 0, 0)
					return
				end
				
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
						cacher.removeAllTextures()

						executeNextEvent()
						if missionIsOver() == false then
							executeNextEvent(nil, false)
						else
							fwin:close(instance)
							if __lua_project_id == __lua_project_red_alert 
								or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
								then
								app.load("configs.csb.config")
  								app.load("client.red_alert.login.LoginLoading")
    							state_machine.excute("login_loading_window_open",0,"")
							else
								app.load("client.login.LoginLoading")
							    fwin:open(LoginLoading:new():init(), fwin._screen)
							end
							-- app.load("client.home.Menu")
							-- fwin:open(Menu:new(), fwin._taskbar)
							-- state_machine.excute("menu_manager", 0, 
							-- 	{
							-- 		_datas = {
							-- 			terminal_name = "menu_manager", 	
							-- 			next_terminal_name = "menu_show_home_page", 	
							-- 			current_button_name = "Button_home",
							-- 			but_image = "Image_home", 		
							-- 			terminal_state = 0, 
							-- 			touch_scale = true
							-- 		}
							-- 	}
							-- )
						end		

						-- app.load("client.formation.FormationTigerGate")
						-- state_machine.excute("formation_open_instance_window", 0, {_datas = {}})
						state_machine.excute("platform_the_roles_tracking", 0, "platform_the_roles_tracking.")
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
						NetworkManager:register(protocol_command.login_init.code, server.server_link, nil, nil, nil, responseEnterGame, false, nil)
						
						state_machine.excute("platform_the_role_establish", 0, { names = zstring.exchangeTo(roleName:getString())})
					end
				
				end
				
				local user_info = _ED.user_platform[_ED.default_user]
				
				
				
				local str = user_info.platform_account.."\r\n"--用户名
				str = str..user_info.password.."\r\n"--用户密码
				str = str..getVersion().."\r\n"--udid
				local userName = zstring.exchangeTo(roleName:getString())
				str = str..userName.."\r\n"--用户昵称
				
				if self.selectIndex  == 0 then
					str = str .."1".."\r\n"--用户头像标识符
				else
					str = str .."6".."\r\n"--用户头像标识符
				end
				
				local camp = tonumber(self.selectIndex)+1
				str = str ..camp .."\r\n"
				
				local gender = tonumber(self.selectIndex)+1
				str = str ..gender.."\r\n"--性别
				
				str = str ..getApplicationName().."\r\n"--应用名称
				str = str .._ED.selected_server.."\r\n"--服务器编号
				str = str .."".."\r\n"--邀请码
				protocol_command.register_game_account.param_list = str
				
				local server = _ED.all_servers[_ED.selected_server]
				if #roleName:getString() > 18 then
					-- TipDlg.drawTextDailog(_string_piece_info[117])
					--> debug.log(true,"user name can not be to0 long！")
					return
				elseif #roleName:getString() < 1 then
					-- TipDlg.drawTextDailog(_string_piece_info[118])
					--> debug.log(true,"user name can not to be nil")
					return
				end
				-- if m_sUserAccountPlatformName == "winner" then
					-- if LCharacterCreateClass.isNameOk == false then
						-- handlePlatformRequest(0, 10000, userName)
						-- return
					-- end
				-- else
					-- if zstring.checkNikenameChar(roleName:getString()) == true then
						-- TipDlg.drawTextDailog(_string_piece_info[119])
						-- return
					-- end
				-- end
				NetworkManager:register(protocol_command.register_game_account.code, server.server_link, nil, nil, nil, responseStartGame, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local character_create_change_name_terminal = {
            _name = "character_create_change_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function responseChangeNameCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							local roleName = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name_1")
							roleName:setString(zstring.exchangeFrom(_ED.current_random_name))
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								state_machine.excute("character_create_show_home", 0, "character_create_show_home.")
							end
						end
					end
				end
				instance:detachWithIME()
				protocol_command.get_random_name.param_list = self.selectIndex
				local server = _ED.all_servers[_ED.selected_server]
				NetworkManager:register(protocol_command.get_random_name.code, server.server_link, nil, nil, instance, responseChangeNameCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local character_create_show_text_terminal = {
            _name = "character_create_show_text",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local roleName = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name_1")
            	if roleName.editBox ~= nil then
            		roleName.editBox:setTouchEnabled(true)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(LCharacterCreate_click_make_boy_terminal)
		state_machine.add(LCharacterCreate_click_make_girl_terminal)
		state_machine.add(character_create_show_login_terminal)
		state_machine.add(character_create_change_name_terminal)
		state_machine.add(character_create_show_text_terminal)
	
        state_machine.init()
    end
    
    init_LCharacterCreate_terminal()
end

function LCharacterCreate:detachWithIME()
	local root = self.roots[1]
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_name_1")
	roleName:didNotSelectSelf()
end

function LCharacterCreate:onEnterTransitionFinish()

    local csbLCharacterCreate = csb.createNode("login/character_creation_x.csb")
	local action = csb.createTimeline("login/character_creation_x.csb")
    csbLCharacterCreate:runAction(action)
	self._role_action = action
    self:addChild(csbLCharacterCreate)
	
	local root = csbLCharacterCreate:getChildByName("root")
	table.insert(self.roots, root)
	self.root = root
	self.selectIndex = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		root:setVisible(false)
	end
	
	-- local function changeActionCallback(armatureBack)
	-- 	Panel_nan_open = ccui.Helper:seekWidgetByName(root, "Panel_nan_open"):setVisible(false)
 --        ccui.Helper:seekWidgetByName(root, "Panel_nan_cs"):setVisible(true)
 --    end
	
	-- local Panel_nan_open = ccui.Helper:seekWidgetByName(root, "Panel_nan_open")
	-- Panel_nan_open:setVisible(true)
	-- local ArmatureNode_1 = Panel_nan_open:getChildByName("ArmatureNode_nan_open")
	-- draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
	-- ArmatureNode_1._invoke = nil
	-- ArmatureNode_1:getAnimation():playWithIndex(0, 0, 0)
	-- ArmatureNode_1._invoke = changeActionCallback
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
		or __lua_project_id == __lua_project_l_naruto  
		then
	elseif __lua_project_id == __lua_project_gragon_tiger_gate 
		-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
		-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
		-- or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		local function changeActionCallback(armatureBack)
			Panel_nan_open = ccui.Helper:seekWidgetByName(root, "Panel_nan_open"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_nan_cs"):setVisible(true)
			csb.animationChangeToAction(self.boy, 0, 0, nil)
			armatureBack._invoke = nil
		end
		local Panel_nan_open = ccui.Helper:seekWidgetByName(root, "Panel_nan_open")
		Panel_nan_open:setVisible(true)
		self.boy_touch = sp.spine("images/ui/effice/effect_juesechuangjian/effect_nanzhu_open.json", 
			"images/ui/effice/effect_juesechuangjian/effect_nanzhu_open.atlas", 1, 0, effectAnimations[1], true, nil)
		self.boy_touch.animationNameList = effectAnimations
		sp.initArmature(self.boy_touch, true)
		self.boy_touch:getAnimation():playWithIndex(0, 0, 0)
		Panel_nan_open:removeAllChildren(true)
        Panel_nan_open:addChild(self.boy_touch)
    	self.boy_touch:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        self.boy_touch._invoke = changeActionCallback
        csb.animationChangeToAction(self.boy_touch, 1, 1, nil)

		local Panel_nan_cs = ccui.Helper:seekWidgetByName(root, "Panel_nan_cs")
		self.boy = sp.spine("images/ui/effice/effect_juesechuangjian/effect_nanzhu_open.json", 
			"images/ui/effice/effect_juesechuangjian/effect_nanzhu_open.atlas", 1, 0, effectAnimations[1], true, nil)
		self.boy.animationNameList = effectAnimations
		sp.initArmature(self.boy, true)
		self.boy:getAnimation():playWithIndex(0, 0, 0)
		Panel_nan_cs:removeAllChildren(true)
        Panel_nan_cs:addChild(self.boy)
    	self.boy:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        self.boy._invoke = nil

		local Panel_nv_open = ccui.Helper:seekWidgetByName(root, "Panel_nv_open")
		self.girl_touch = sp.spine("images/ui/effice/effect_juesechuangjian/effect_nvzhu_open.json", 
			"images/ui/effice/effect_juesechuangjian/effect_nvzhu_open.atlas", 1, 0, effectAnimations[1], true, nil)
		self.girl_touch.animationNameList = effectAnimations
		sp.initArmature(self.girl_touch, true)
		self.girl_touch:getAnimation():playWithIndex(0, 0, 0)
		Panel_nv_open:removeAllChildren(true)
        Panel_nv_open:addChild(self.girl_touch)
    	self.girl_touch:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        self.girl_touch._invoke = nil

		local Panel_nv_cs = ccui.Helper:seekWidgetByName(root, "Panel_nv_cs")
		self.girl = sp.spine("images/ui/effice/effect_juesechuangjian/effect_nvzhu_open.json", 
			"images/ui/effice/effect_juesechuangjian/effect_nvzhu_open.atlas", 1, 0, effectAnimations[1], true, nil)
		self.girl.animationNameList = effectAnimations
		sp.initArmature(self.girl, true)
		self.girl:getAnimation():playWithIndex(0, 0, 0)
		Panel_nv_cs:removeAllChildren(true)
        Panel_nv_cs:addChild(self.girl)
    	self.girl:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        self.girl._invoke = nil
	else
		local function changeActionCallback(armatureBack)
			Panel_nan_open = ccui.Helper:seekWidgetByName(root, "Panel_nan_open"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_nan_cs"):setVisible(true)
			csb.animationChangeToAction(self.boy, 0, 0, nil)
			armatureBack._invoke = nil
		end
		local Panel_nan_open = ccui.Helper:seekWidgetByName(root, "Panel_nan_open")
		Panel_nan_open:setVisible(true)
		self.boy_touch = Panel_nan_open:getChildByName("ArmatureNode_nan_open")
		draw.initArmature(self.boy_touch, nil, -1, 0, 1)
		self.boy_touch:getAnimation():playWithIndex(0, 0, 0)
		self.boy_touch._invoke = changeActionCallback

		local Panel_nan_cs = ccui.Helper:seekWidgetByName(root, "Panel_nan_cs")
		self.boy = Panel_nan_cs:getChildByName("ArmatureNode_nan_cs")
		draw.initArmature(self.boy, nil, -1, 0, 1)
		self.boy:getAnimation():playWithIndex(0, 0, 0)

		local Panel_nv_open = ccui.Helper:seekWidgetByName(root, "Panel_nv_open")
		self.girl_touch = Panel_nv_open:getChildByName("ArmatureNode_nv_open")
		draw.initArmature(self.girl_touch, nil, -1, 0, 1)
		self.girl_touch:getAnimation():playWithIndex(0, 0, 0)

		local Panel_nv_cs = ccui.Helper:seekWidgetByName(root, "Panel_nv_cs")
		self.girl = Panel_nv_cs:getChildByName("ArmatureNode_nv_cs")
		draw.initArmature(self.girl, nil, -1, 0, 1)
		self.girl:getAnimation():playWithIndex(0, 0, 0)
	end
	
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_name_1")
	draw:addEditBox(roleName, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_kaishi"), dms.int(dms["pirates_config"], 315, pirates_config.param), cc.KEYBOARD_RETURNTYPE_DONE)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		if roleName.editBox ~= nil then
			roleName.editBox:setTouchEnabled(false)
		end
	end

	local function chooseBoyCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended and self.selectIndex ~= 0 then
			-- ccui.Helper:seekWidgetByName(root, "Button_decepticons"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(true)
			-- ccui.Helper:seekWidgetByName(root, "Button_autobot"):setVisible(true)
			-- ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(false)
			state_machine.excute("LCharacterCreate_click_make_boy", 0, "")
			self.selectIndex = 0
		end
	end
	
	local function chooseGirlCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended and self.selectIndex ~= 1 then
			-- ccui.Helper:seekWidgetByName(root, "Button_decepticons"):setVisible(true)
			-- ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(root, "Button_autobot"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(true)
			state_machine.excute("LCharacterCreate_click_make_girl", 0, "")
			self.selectIndex = 1
		end
	end
	
	local function changeHeroCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.selectIndex == 1 then
				chooseBoyCallback(Button_boy, ccui.TouchEventType.ended)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					local soundid = user_voice_id[self.selectIndex+1]
					-- print("===============",soundid)
					playEffectExt(formatMusicFile("effect", soundid))								
					state_machine.excute("character_create_change_name", 0, "character_create_change_name.")
				end
			elseif self.selectIndex == 0 then
				chooseGirlCallback(Button_girl, ccui.TouchEventType.ended)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					local soundid = user_voice_id[self.selectIndex+1]
					-- print("===============",soundid)
					playEffectExt(formatMusicFile("effect", soundid))								
					state_machine.excute("character_create_change_name", 0, "character_create_change_name.")
				end
			end
		end
	end
	
	-- local Button_boy = ccui.Helper:seekWidgetByName(root, "Button_decepticons")
	-- Button_boy:addTouchEventListener(chooseBoyCallback)
	
	-- local Button_girl = ccui.Helper:seekWidgetByName(root, "Button_autobot")
	-- Button_girl:addTouchEventListener(chooseGirlCallback)
	
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	Panel_2:addTouchEventListener(changeHeroCallback)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_name"), nil, {terminal_name = "character_create_change_name", terminal_state = 0, touch_scale = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kaishi"), nil, {terminal_name = "character_create_show_home", terminal_state = 0, touch_scale = true}, nil, 0)
	
	-- ccui.Helper:seekWidgetByName(root, "Button_decepticons"):setVisible(false)
	-- ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(false)
	
	action:gotoFrameAndPlay(0, 0, false)
	state_machine.excute("character_create_change_name", 0, "character_create_change_name.")

	self.selectIndex = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		local soundid = user_voice_id[self.selectIndex+1]
		-- print("===============",soundid)
		playEffectExt(formatMusicFile("effect", soundid))
		local show_text = cc.Sequence:create({cc.DelayTime:create(0.3), cc.CallFunc:create(function(sender)
					state_machine.excute("character_create_show_text",0,"")						
			end)})
		self:runAction(show_text)			
	end		
	-- chooseBoyCallback(Button_boy, ccui.TouchEventType.ended)


end

function LCharacterCreate:onUpdate(dt)

end

function LCharacterCreate:onExit()
	state_machine.remove("LCharacterCreate_click_make_boy")
	state_machine.remove("LCharacterCreate_click_make_girl")
	state_machine.remove("character_create_show_home")
	state_machine.remove("character_create_change_name")
	state_machine.remove("character_create_show_text")
end
