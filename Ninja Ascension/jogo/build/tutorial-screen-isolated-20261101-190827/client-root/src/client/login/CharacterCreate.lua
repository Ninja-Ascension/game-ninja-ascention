-- ----------------------------------------------------------------------------------------------------
-- 说明：角色创建界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------


CharacterCreate = class("CharacterCreateClass", Window)

function CharacterCreate:ctor()
    self.super:ctor()
	self.roots = {}
	
	app.load("client.cells.character_create_choose_cell")
	app.load("client.login.Character")
	
	self.selectIndex = -1
	
    -- Initialize CharacterCreate page state machine.
    local function init_CharacterCreate_terminal()
		
		-- local characterCreate_click_make_boy_terminal = {
            -- _name = "characterCreate_click_make_boy",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- instance._role_action:play("Button_autobot_untouch", false)
				-- instance._role_action:play("Button_decepticons_touch", false)
				-- -- state_machine.excute("character_create_change_name", 0, "character_create_change_name.")
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- local characterCreate_click_make_girl_terminal = {
            -- _name = "characterCreate_click_make_girl",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
				-- instance._role_action:play("Button_decepticons_untouch", false)
				-- instance._role_action:play("Button_autobot_touch", false)
				-- -- state_machine.excute("character_create_change_name", 0, "character_create_change_name.")
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		local character_create_show_login_terminal = {
            _name = "character_create_show_home",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
				instance:detachWithIME()
				local roleName = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_2052*11")
				local roleNameTextFieldString = roleName:getString()
				if roleNameTextFieldString == nil or #roleNameTextFieldString == 0 then
					TipDlg.drawTextDailog(_string_piece_info[315])
					return
				end
				if #roleNameTextFieldString > 18 then
					TipDlg.drawTextDailog(_string_piece_info[314])
					return
				end
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
						cacher.removeAllTextures()
						-- cacher.addTextureAsync(texture_cache_load_images)

						if missionIsOver() == false then
							--> print("角色创建完毕，进入事件中。")
							executeNextEvent(nil, false)
						else
							fwin:close(instance)
							app.load("client.home.Menu")
							
							if __lua_project_id == __lua_project_adventure then
								app.load("client.adventure.login.AdventureLoginLoading")
								_ED.adventure_create_character = true
						    	fwin:open(AdventureLoginLoading:new():init(), fwin._taskbar)
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
							else
								fwin:open(Menu:new(), fwin._taskbar)
								state_machine.excute("menu_manager", 0, 
									{
										_datas = {
											terminal_name = "menu_manager", 	
											next_terminal_name = "menu_show_home_page", 	
											current_button_name = "Button_home",
											but_image = "Image_home", 		
											terminal_state = 0, 
											touch_scale = true
										}
									}
								)
							end
						end		
						if __lua_project_id == __lua_project_adventure then
						else
							app.load("client.formation.Formation")
							state_machine.excute("formation_open_instance_window", 0, {_datas = {}})
							
							
							app.load("client.duplicate.pve.PVEStage")
							state_machine.excute("page_stage_open_instance_window", 0, {sceneID = 1, sceneType = 1})	
						end	
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
				if __lua_project_id == __lua_project_adventure then
					local headImageIndex = tonumber(self.selectIndex)
					str = str .. headImageIndex .."\r\n"--用户头像标识符
				else
					if self.selectIndex  == 0 then
						str = str .."11".."\r\n"--用户头像标识符
					elseif self.selectIndex  == 1 then
						str = str .."6".."\r\n"--用户头像标识符
					elseif self.selectIndex  == 2 then
						str = str .."1".."\r\n"--用户头像标识符
					elseif self.selectIndex  == 3 then
						str = str .."16".."\r\n"--用户头像标识符
					end
				end
				
				local camp = tonumber(self.selectIndex)+1
				str = str ..camp .."\r\n"
				
				local gender = 2
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
					-- if CharacterCreateClass.isNameOk == false then
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
						local roleName = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_2052*11")
						roleName:setString(zstring.exchangeFrom(_ED.current_random_name))
					end
				end
				instance:detachWithIME()
				
				local _sendIndex = 0
				if instance.selectIndex == 0 or instance.selectIndex == 2 then
					_sendIndex = 0
				elseif instance.selectIndex == 1 or instance.selectIndex == 3 then
					_sendIndex = 1
				end
				
				protocol_command.get_random_name.param_list = _sendIndex
				local server = _ED.all_servers[_ED.selected_server]
				NetworkManager:register(protocol_command.get_random_name.code, server.server_link, nil, nil, nil, responseChangeNameCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local character_cell_unselected_all_terminal = {
            _name = "character_cell_unselected_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local choose_pad_list = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_choose_rols")
				for i, v in pairs(choose_pad_list:getItems()) do
					state_machine.excute("character_cell_unselected", 0, {_datas = {_cell = v}})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local character_list_refresh_terminal = {
            _name = "character_list_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local choose_pad_list = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_choose_rols")
				choose_pad_list:requestRefreshView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local Q_character_change_terminal = {
            _name = "Q_character_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local root = instance.roots[1]
				local QGirl_show_pad = ccui.Helper:seekWidgetByName(root, "Panel_rols")
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
					-- if ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_21_nan"):isVisible() == true then
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_21_nan"):setVisible(false)
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_22_nv"):setVisible(true)
					-- else
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_22_nv"):setVisible(false)
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_21_nan"):setVisible(true)
					-- end
					if instance.selectIndex == 0 then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_22_nv"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_21_nan"):setVisible(true)
					elseif instance.selectIndex == 1 then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_21_nan"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_22_nv"):setVisible(true)
					end
				else
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge then
						QGirl_show_pad:removeBackGroundImage()
						QGirl_show_pad:removeAllChildren(true)
						local PicIndex = 501
						if zstring.tonumber(instance.selectIndex) == 0 then
							PicIndex = 501
						elseif zstring.tonumber(instance.selectIndex) == 1 then 
							PicIndex = 503
						elseif zstring.tonumber(instance.selectIndex) == 2 then 
							PicIndex = 511
						elseif zstring.tonumber(instance.selectIndex) == 3 then 
							PicIndex = 513
						end
						QGirl_show_pad:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", PicIndex))
					elseif __lua_project_id == __lua_project_yugioh then
						QGirl_show_pad:removeAllChildren(true)
						local PicIndex = 501
						if zstring.tonumber(instance.selectIndex) == 0 then
							PicIndex = 501
						elseif zstring.tonumber(instance.selectIndex) == 1 then 
							PicIndex = 503
						elseif zstring.tonumber(instance.selectIndex) == 2 then 
							PicIndex = 511
						elseif zstring.tonumber(instance.selectIndex) == 3 then 
							PicIndex = 513
						end
						local jsonFile = string.format("sprite/spirte_battle_card_%s.json", PicIndex)
			            local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", PicIndex)
			            app.load("client.battle.fight.FightEnum")
			            local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
			                spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

			            spArmature:setPosition(cc.p(QGirl_show_pad:getContentSize().width/2, 0))
			            spArmature.animationNameList = spineAnimations
			            sp.initArmature(spArmature, true)
			            QGirl_show_pad:addChild(spArmature)
					else
						local _character = Character:createCell()
						_character:init(instance.selectIndex)
						QGirl_show_pad:removeAllChildren(true)
						QGirl_show_pad:addChild(_character)
						_character:setContentSize(QGirl_show_pad:getContentSize())
						_character:setAnchorPoint(cc.p(0.5, 0.5))
						_character:setPosition(cc.p(QGirl_show_pad:getPosition()))						
					end

				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local character_selectIndex_change_terminal = {
            _name = "character_selectIndex_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.selectIndex = params
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
					if instance.selectIndex == 0 then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_role_xinxi_1"):setVisible(true)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_role_xinxi_2"):setVisible(false)
					elseif instance.selectIndex == 1 then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_role_xinxi_1"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_role_xinxi_2"):setVisible(true)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local character_list_role_info_refresh_terminal = {
            _name = "character_list_role_info_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:updateRoleInfo(params.index, params.selected)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local character_create_choose_role_with_page_view_terminal = {
            _name = "character_create_choose_role_with_page_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:chooseRoleWithPageView(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
    	}

		-- state_machine.add(characterCreate_click_make_boy_terminal)
		
		state_machine.add(character_list_role_info_refresh_terminal)
		state_machine.add(character_create_show_login_terminal)
		state_machine.add(character_create_change_name_terminal)
		state_machine.add(character_cell_unselected_all_terminal)
		state_machine.add(character_list_refresh_terminal)
		state_machine.add(Q_character_change_terminal)
		state_machine.add(character_selectIndex_change_terminal)
		state_machine.add(character_create_choose_role_with_page_view_terminal)
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_CharacterCreate_terminal()
end

function CharacterCreate:detachWithIME()
	local root = self.roots[1]
	local roleName = ccui.Helper:seekWidgetByName(root, "TextField_2052*11")
	roleName:didNotSelectSelf()
end

function CharacterCreate:updateRoleInfo(index, selected)
	local root = self.roots[1]
	local roleName = ccui.Helper:seekWidgetByName(root, string.format("Panel_sm_%d", index))
	roleName:setVisible(selected == true and true or false)
	
	if selected == true then
		cc.SimpleAudioEngine:getInstance():stopAllEffects()
		local music = {99,100,101,102}
		
		if __lua_project_id == __lua_project_koone then
			music = {100,99,101,102}
		end
		
		playEffectExt(formatMusicFile("effect", music[index]))
	end
end

function CharacterCreate:chooseRoleWithPageView(params)
	local root = self.roots[1]
	local terminal_state = params._datas.terminal_state
	local pageView = ccui.Helper:seekWidgetByName(root, "PageView_choose_rols")
	local Button_left = ccui.Helper:seekWidgetByName(root, "Button_left")
	local Button_right = ccui.Helper:seekWidgetByName(root, "Button_right")
	local pageIndex = pageView:getCurPageIndex()
	local pages = pageView:getPages()
	local pageCount = #pages
	if terminal_state == 0 then
		pageIndex = math.max(0, pageIndex - 1)
	else
		pageIndex = math.min(pageCount - 1, pageIndex + 1)
	end
	pageView:scrollToPage(pageIndex)
	if pageIndex == 0 then
		Button_left:setOpacity(130)
	else
		Button_left:setOpacity(255)
	end

	if pageIndex == (pageCount - 1) then
		Button_right:setOpacity(130)
	else
		Button_right:setOpacity(255)
	end
	self.selectIndex = pageIndex
end

-- function CharacterCreate:addEditBox(_TextField)
-- 	local editBoxSize = _TextField:getContentSize() -- cc.size(480, 60)
-- 	debug.print_r(editBoxSize)
-- 	local TTFShowEditReturn = _TextField
--     local EditName = nil
--     local EditPassword = nil
--     local EditEmail = nil
	
-- 	local function editBoxTextEventHandle(strEventName,pSender)
-- 		local edit = pSender
-- 		local strFmt 
-- 		if strEventName == "began" then
-- 			-- strFmt = string.format("editBox %p DidBegin !", edit)
-- 			-- print(strFmt)
-- 			print("editBox DidBegin !", edit)
-- 		elseif strEventName == "ended" then
-- 			-- strFmt = string.format("editBox %p DidEnd !", edit)
-- 			-- print(strFmt)
-- 			print("editBox DidEnd !", edit)
-- 		elseif strEventName == "return" then
-- 			-- strFmt = string.format("editBox %p was returned !",edit)
-- 			-- if edit == EditName then
-- 			-- 	TTFShowEditReturn:setString("Name EditBox return !")
-- 			-- elseif edit == EditPassword then
-- 			-- 	TTFShowEditReturn:setString("Password EditBox return !")
-- 			-- elseif edit == EditEmail then
-- 			-- 	TTFShowEditReturn:setString("Email EditBox return !")
-- 			-- end
-- 			TTFShowEditReturn:setString(edit:getText())
-- 			-- print(strFmt)
-- 			print("editBox was returned !",edit)
-- 		elseif strEventName == "changed" then
-- 			-- strFmt = string.format("editBox %p TextChanged, text: %s ", edit, edit:getText())
-- 			-- print(strFmt)
-- 			print("editBox TextChanged, text:  ", edit, edit:getText())
-- 		end
-- 	end
--     -- top
--     EditName = ccui.EditBox:create(editBoxSize, "effect/effice_1500.png")
--     EditName:setPosition(cc.p(0, 0))
--     EditName:setAnchorPoint(cc.p(0, 0))
--     local targetPlatform = cc.Application:getInstance():getTargetPlatform()
--  --    if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform then
-- 	--    EditName:setFontName("Paint Boy")
-- 	-- else
-- 	-- 	EditName:setFontName("fonts/Paint Boy.ttf")
-- 	-- end
--     EditName:setFontSize(_TextField:getFontSize())
--     EditName:setFontColor(cc.c3b(255,0,0))
--     EditName:setPlaceHolder("请输入昵称:")
--     EditName:setPlaceholderFontColor(cc.c3b(255,255,255))
--     EditName:setMaxLength(16)
--     EditName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
-- 	--Handler
-- 	EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
--     _TextField:addChild(EditName)
--     _TextField:setTouchEnabled(false)
--     EditName:setTouchEnabled(true)
-- end

function CharacterCreate:onEnterTransitionFinish()

    local csbCharacterCreate = csb.createNode("login/character_creation.csb")
	-- local action = csb.createTimeline("login/character_creation.csb")
    -- csbCharacterCreate:runAction(action)
	--action:gotoFrameAndPlay(0, action:getDuration(), false)
	-- self._role_action = action
    self:addChild(csbCharacterCreate)
	-- print("=============================")
	local root = csbCharacterCreate:getChildByName("root")
	table.insert(self.roots, root)
	self.root = root
	self.selectIndex = 0
	-- local select = ccui.Helper:seekWidgetByName(root, "Panel_select")
	-- local createName = ccui.Helper:seekWidgetByName(root, "Panel_give_name")
	local roleName = ccui.Helper:seekWidgetByName(root, "Panel_10"):getChildByName("TextField_2052*11")

 --    local function textFieldEvent(sender, eventType)
 --        if eventType == ccui.TextFiledEventType.attach_with_ime then
 --            local textField = sender
 --            local screenSize = cc.Director:getInstance():getWinSize()
 --            local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
 --            -- scene:runAction(cc.MoveTo:create(0.225, cc.p(0, (588) / 2 * app.scaleFactor)))
 --            -- textField:runAction(cc.MoveTo:create(0.225,cc.p(screenSize.width / 2.0, screenSize.height / 2.0 + textField:getContentSize().height / 2.0)))
 --            -- self._displayValueLabel:setString("attach with IME")
 --        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
 --            local textField = sender
 --            local screenSize = cc.Director:getInstance():getWinSize()
 --            local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
 --            -- scene:runAction(cc.MoveTo:create(0.225, cc.p(0, 0)))
 --            -- textField:runAction(cc.MoveTo:create(0.175, cc.p(screenSize.width / 2.0, screenSize.height / 2.0)))
 --            --self._displayValueLabel:setString("detach with IME")
 --        elseif eventType == ccui.TextFiledEventType.insert_text then
 --            --self._displayValueLabel:setString("insert words")
 --        elseif eventType == ccui.TextFiledEventType.delete_backward then
 --            --self._displayValueLabel:setString("delete word")
 --        end
 --    end

 --    fwin._framewindow:setUserObject(ccui.Helper:seekWidgetByName(root, "Button_next"))
 --    roleName:setUserObject(fwin._framewindow)
	
	-- local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	-- if cc.PLATFORM_OS_IPHONE == targetPlatform
	-- 	-- or cc.PLATFORM_OS_ANDROID == targetPlatform
	-- 	or cc.PLATFORM_OS_IPAD == targetPlatform
	-- 	then
 --    	roleName:addEventListener(textFieldEvent)
 --    elseif cc.PLATFORM_OS_ANDROID == targetPlatform then
 --    	self:addEditBox(roleName)
	-- end
	local maxLength = dms.int(dms["pirates_config"], 320, pirates_config.param)
	draw:addEditBox(roleName, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_next"), maxLength, cc.KEYBOARD_RETURNTYPE_DONE)
	if __lua_project_id == __lua_project_adventure then
		roleName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end

	-- local function chooseBoyCallback(sender, eventType)
		-- if eventType == ccui.TouchEventType.ended and self.selectIndex ~= 0 then
			-- ccui.Helper:seekWidgetByName(root, "Button_decepticons"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(true)
			-- ccui.Helper:seekWidgetByName(root, "Button_autobot"):setVisible(true)
			-- ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(false)
			-- state_machine.excute("characterCreate_click_make_boy", 0, "")
			-- self.selectIndex = 0
		-- end
	-- end
	
	-- local function chooseGirlCallback(sender, eventType)
		-- if eventType == ccui.TouchEventType.ended  and self.selectIndex ~= 1 then
			-- ccui.Helper:seekWidgetByName(root, "Button_decepticons"):setVisible(true)
			-- ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(root, "Button_autobot"):setVisible(false)
			-- ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(true)
			-- state_machine.excute("characterCreate_click_make_girl", 0, "")
			-- self.selectIndex = 1
		-- end
	-- end
	
	-- local function changeHeroCallback(sender, eventType)
		-- if eventType == ccui.TouchEventType.ended then
			-- if self.selectIndex == 1 then
				-- chooseBoyCallback(Button_boy, ccui.TouchEventType.ended)
			-- elseif self.selectIndex == 0 then
				-- chooseGirlCallback(Button_girl, ccui.TouchEventType.ended)
			-- end
		-- end
	-- end
	
	--local Button_boy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_decepticons"), nil, {func_string = [[state_machine.excute("characterCreate_click_make_boy", 0, "click home_button.'")]]}, nil, 0)
	-- local Button_boy = ccui.Helper:seekWidgetByName(root, "Button_decepticons")
	-- Button_boy:addTouchEventListener(chooseBoyCallback)
	
	-- local Button_girl = ccui.Helper:seekWidgetByName(root, "Button_autobot")
	-- Button_girl:addTouchEventListener(chooseGirlCallback)
	
	-- local panel_7 = ccui.Helper:seekWidgetByName(root, "Panel_7")
	-- panel_7:addTouchEventListener(changeHeroCallback)
	-- local Button_girl = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_autobot"), nil, {func_string = [[state_machine.excute("characterCreate_click_make_girl", 0, "click home_button.'")]]}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_659_0"), nil, {terminal_name = "character_create_change_name", terminal_state = 0, touch_scale = true, 
									isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"), nil, {terminal_name = "character_create_show_home", terminal_state = 0, touch_scale = true, 
									isPressedActionEnabled = true}, nil, 0)
	
	if __lua_project_id == __lua_project_adventure then
		-- 添加角色
		app.load("client.adventure.utils.AdventureSprite")
		for i = 1, 4 do
			local armature = AdventureSprite:create(500 + i - 1, 9) 
			armature:getAnimation():playWithIndex(0)
			ccui.Helper:seekWidgetByName(root, "Panel_role_".. i .. "" .. i .. ""):addChild(armature)
		end

		self.selectIndex = 0
		local Button_left = ccui.Helper:seekWidgetByName(root, "Button_left")
		Button_left:setOpacity(130)
        fwin:addTouchEventListener(Button_left,       nil, 
        {
            terminal_name = "character_create_choose_role_with_page_view",      
            terminal_state = 0, 
            isPressedActionEnabled = false
        }, 
        nil, 0)

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right"),       nil, 
        {
            terminal_name = "character_create_choose_role_with_page_view",      
            terminal_state = 1, 
            isPressedActionEnabled = false
        }, 
        nil, 0)
		state_machine.excute("character_create_change_name", 0, "character_create_change_name.")
	else
		-- ccui.Helper:seekWidgetByName(root, "Button_decepticons"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(false)
		-- state_machine.excute("characterCreate_click_make_boy", 0, "characterCreate_click_make_boy.")
		
		-- action:gotoFrameAndPlay(5, 28, false)
		state_machine.excute("character_create_change_name", 0, "character_create_change_name.")

		-- self.selectIndex = -1
		-- chooseBoyCallback(Button_boy, ccui.TouchEventType.ended)
		
		---------------------------------------------------------------------------
		
		-- self.selectIndex 决定最终选择角色向性
		local choose_pad_list = ccui.Helper:seekWidgetByName(root, "ListView_choose_rols")
		choose_pad_list:setItemsMargin(4.8)
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			or __lua_project_id == __lua_project_rouge
			then			--龙虎门项目控制
			for i=1, 2 do
				local boolean = i == 1 and true or false
				local cell = CharacterCreateChooseCell:createCell()
				cell:init(i, boolean)
				choose_pad_list:addChild(cell)
			end
		else
			for i=1, 4 do
				local boolean = i == 1 and true or false
				local cell = CharacterCreateChooseCell:createCell()
				cell:init(i, boolean)
				choose_pad_list:addChild(cell)
			end
		end
		
		
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
		
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_1321.ExportJson")
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_56.ExportJson")
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_1.ExportJson")
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_1376.ExportJson")
		
		state_machine.excute("Q_character_change", 0, "")
	end
end

function CharacterCreate:onUpdate(dt)
	-- if self.selectIndex == 0 then
		-- ccui.Helper:seekWidgetByName(self.root, "Button_decepticons"):setFocused(true)
	-- else
		-- ccui.Helper:seekWidgetByName(self.root, "Button_autobot"):setFocused(true)
	-- end
end

function CharacterCreate:onExit()
	-- state_machine.remove("characterCreate_click_make_boy")
	state_machine.remove("character_list_role_info_refresh")
	state_machine.remove("character_create_show_home")
	state_machine.remove("character_create_change_name")
	state_machine.remove("character_cell_unselected_all")
	state_machine.remove("character_list_refresh")
	state_machine.remove("Q_character_change")
	state_machine.remove("character_selectIndex_change")
	state_machine.remove("character_create_choose_role_with_page_view")

end