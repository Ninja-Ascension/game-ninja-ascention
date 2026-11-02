-----
--角色创建
-----
CreateCharacter = class("CreateCharacterClass", Window)

local create_character_window_open_terminal = {
    _name = "create_character_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("CreateCharacterClass")
        if nil == _Window then
            fwin:open(CreateCharacter:new():init(), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local create_character_window_close_terminal = {
    _name = "create_character_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CreateCharacterClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(create_character_window_open_terminal)
state_machine.add(create_character_window_close_terminal)
state_machine.init()

function CreateCharacter:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.selectIndex = 0
    self.lastSelectButton = nil
    self.lastSelectRole = nil
    self.drawMode = 0
	
	self.isEnterGame = true

    NetworkManager:registerUrl(_ED.all_servers[_ED.selected_server].server_link, nil, _ED.all_servers[_ED.selected_server].server_link_rf)
    
    -- Initialize create_character page state machine.
    local function init_create_character_terminal()
     --    -
        local create_character_to_begin_game_terminal = {
            _name = "create_character_to_begin_game",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:detachWithIME()
                local roleName = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_create_character_name")
                local roleNameTextFieldString = roleName:getString()
                if checkUserNameLength(roleNameTextFieldString) ~= true then
                    return
                end
                
                if instance:filter_spec_chars(roleNameTextFieldString) == true then
                    TipDlg.drawTextDailog(_string_piece_info[119])
                    return
                end 

                state_machine.lock("create_character_to_begin_game")
                
                local function responseEnterGame(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_tips"):setVisible(true)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tip_bg"):setVisible(true)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Text_tip"):setVisible(true)
                        fwin:addService({
                            callback = function ( params )
                                _ED.first_login_game = true
                                NetworkManager:registerUrl(_ED.all_servers[_ED.selected_server].server_link, nil, _ED.all_servers[_ED.selected_server].server_link_rf)
                                updateDefaultServerFile()                    
                                local writeInfo = cc.UserDefault:getInstance():getStringForKey("server")
                                local server  = cc.UserDefault:getInstance():getStringForKey("server")
                                local estr = "esgg"..server
                                cc.UserDefault:getInstance():setStringForKey(estr, "0")
                                local estrTwo = "esggp"..server
                                cc.UserDefault:getInstance():setStringForKey(estrTwo, "0")
                                cc.UserDefault:getInstance():flush()

                                app.load("client.utils.texture_cache")
                                -- cacher.cleanSystemCacher()
                                cacher.removeAllTextures()

                                _ED.first_enter_game = true

                                fwin:close(params)

                                -- executeNextEvent()
                                if missionIsOver() == false then
                                    executeNextEvent(nil, false)
                                else
                                    app.load("configs.csb.config")
                                    if __lua_project_id == __lua_project_red_alert then
                                        app.load("client.red_alert_time.login.LoginLoading")
                                    else
                                        app.load("client.red_alert_time.login.LoginLoading")
                                    end
                                    state_machine.excute("login_loading_window_open",0,"")
                                end     
                                TipDlg.drawTextDailog(red_alert_time_str[256])
                                state_machine.unlock("create_character_to_begin_game")
                                state_machine.excute("platform_the_roles_tracking", 0, "platform_the_roles_tracking.")
                            end,
                            delay = 0.05,
                            params = instance
                        })
					else
                        state_machine.unlock("create_character_to_begin_game")
						self.isEnterGame = true
                    end
                end
                
                local function responseStartGame(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        for i,v in pairs(data_path) do
                            if type(v) == "table" then
                                for k,m in pairs(v) do
                                    dms.load(m)
                                end
                            elseif type(v) == "string" then
                                dms.load(v)
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
                        NetworkManager:register(protocol_command.login_init.code, server.server_link, nil, nil, nil, responseEnterGame, false, nil)        
                        state_machine.excute("platform_the_role_establish", 0, { names = zstring.exchangeTo(roleName:getString())})
                    else
                        state_machine.unlock("create_character_to_begin_game")
						self.isEnterGame = true
					end
                
                end
                
                local user_info = _ED.user_platform[_ED.default_user]
         
                local str = user_info.platform_account.."\r\n"--用户名
                str = str..user_info.password.."\r\n"--用户密码
                str = str..getVersion().."\r\n"--udid
                local userName = zstring.exchangeTo(roleName:getString())
                str = str..userName.."\r\n"--用户昵称
                
                if self.selectIndex  == 0 then
                    str = str .."1,0,0".."\r\n"--用户头像标识符
                else
                    str = str .."2,0,0".."\r\n"--用户头像标识符
                end
                
                local camp = tonumber(self.selectIndex)+1
                str = str ..camp .."\r\n"
                
                local gender = tonumber(self.selectIndex)+1
                str = str ..gender.."\r\n"--性别
                
                str = str ..getApplicationName().."\r\n"--应用名称
                str = str .._ED.selected_server.."\r\n"--服务器编号
                str = str .."".."\r\n"--邀请码
                protocol_command.register_game_account.param_list = str
                
                if userName == nil or userName == "" then
                    TipDlg.drawTextDailog(red_alert_all_str[32])
                end
                local server = _ED.all_servers[_ED.selected_server]
				if self.isEnterGame == true then
					self.isEnterGame = false
					NetworkManager:register(protocol_command.register_game_account.code, server.server_link, nil, nil, nil, responseStartGame, false, nil)
				else
                    state_machine.unlock("create_character_to_begin_game")
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local create_character_to_change_role_terminal = {
            _name = "create_character_to_change_role",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.drawMode == 0 then
                    if params._datas.select_index == 0 then
                        state_machine.excute("create_character_to_change_man", 0, 0)
                        checkPlayEffect(61,1)
                    else
                        state_machine.excute("create_character_to_change_women", 0, 0)
                        checkPlayEffect(62,1)
                    end
                else
                    instance:selectRole(params, params._datas.select_index)
                    state_machine.excute("create_character_change_name",0,"")
                    -- playEffectOld(formatMusicFile("effect", 10020))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        local create_character_to_change_man_terminal = {
            _name = "create_character_to_change_man",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.selectIndex = 0
                instance:playChangeToManAction()
                state_machine.excute("create_character_change_name",0,"")
                playEffectOld(formatMusicFile("effect", 10020))
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        local create_character_to_change_women_terminal = {
            _name = "create_character_to_change_women",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.selectIndex = 1
                instance:playChangeToWomenAction()
                state_machine.excute("create_character_change_name",0,"")
                playEffectOld(formatMusicFile("effect", 10019))
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }   


        local create_character_change_name_terminal = {
            _name = "create_character_change_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseChangeNameCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            local roleName = ccui.Helper:seekWidgetByName(response.node.roots[1], "TextField_create_character_name")
                            roleName:setString(zstring.exchangeFrom(_ED.current_random_name))
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

        state_machine.add(create_character_to_begin_game_terminal)
        state_machine.add(create_character_to_change_role_terminal)
        state_machine.add(create_character_to_change_man_terminal)
        state_machine.add(create_character_to_change_women_terminal)
        state_machine.add(create_character_change_name_terminal)
        state_machine.init()
    end
    
    -- call func init create_character state machine.
    init_create_character_terminal()
end

function CreateCharacter:filter_spec_chars(s)  
    local k = 1
    while k <= #s do
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2      
                end  
            end  
        else
            return true  
        end 
        k = k + 1 
    end  
    return false
end  

function CreateCharacter:detachWithIME()
    local root = self.roots[1]
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_create_character_name")
    roleName:didNotSelectSelf()
end

function CreateCharacter:onEnterTransitionFinish( ... )

end

function CreateCharacter:playChangeToManAction( ... )
    local root = self.roots[1]
    local action = self.actions[1]
    -- action:stop()
    action:play("create_character_1",false)
    local man = ccui.Helper:seekWidgetByName(root, "Button_create_man")
    local women = ccui.Helper:seekWidgetByName(root, "Button_create_women")
    man:setHighlighted(true)
    man:setTouchEnabled(false)
    women:setHighlighted(false)
    women:setTouchEnabled(true)
    local Panel_character = ccui.Helper:seekWidgetByName(root, "Panel_character")
    if Panel_character ~= nil then
        self._create_character_armature:stopAllActions()
        draw.initArmature(self._create_character_armature, nil, -1, 0, 1)
        self._create_character_armature:getAnimation():playWithIndex(0)
        self._create_character_armature._nextAction = 1
    end

    local Panel_create_man = ccui.Helper:seekWidgetByName(root, "Panel_create_man")
    if Panel_create_man ~= nil then
        Panel_create_man:removeAllChildren(true)
        local jsonPath = "sprite/spirte_nanzhu.json"
        local atlasPath = "sprite/spirte_nanzhu.atlas"
        -- local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_born", false, nil)
        -- animation:addAnimation(0, "animation", true)
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, null, false, nil)
        animation:addAnimation(0, "animation_born", false)
        animation:addAnimation(0, "animation", true)
        -- -- spine动画初始化
        -- sp.initArmature(animation, true)

        animation:setPosition(cc.p(Panel_create_man:getContentSize().width/2,Panel_create_man:getContentSize().height/2))
        Panel_create_man:addChild(animation)
    end
end

function CreateCharacter:playChangeToWomenAction( ... )
    local root = self.roots[1]
    local action = self.actions[1]
    -- action:stop()
    action:play("create_character_2",false)
    local man = ccui.Helper:seekWidgetByName(root, "Button_create_man")
    local women = ccui.Helper:seekWidgetByName(root, "Button_create_women")
    women:setHighlighted(true)
    women:setTouchEnabled(false)
    man:setHighlighted(false)
    man:setTouchEnabled(true)    
    
    local Panel_character = ccui.Helper:seekWidgetByName(root, "Panel_character")
    if Panel_character ~= nil then
        self._create_character_armature:stopAllActions()
        draw.initArmature(self._create_character_armature, nil, -1, 0, 1)
        self._create_character_armature:getAnimation():playWithIndex(2)
        self._create_character_armature._nextAction = 3
    end
    
    local Panel_create_woman = ccui.Helper:seekWidgetByName(root, "Panel_create_woman")
    if Panel_create_woman ~= nil then
        Panel_create_woman:removeAllChildren(true)
        local jsonPath = "sprite/spirte_nvzhu.json"
        local atlasPath = "sprite/spirte_nvzhu.atlas"
        -- local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_born", false, nil)
        -- animation:addAnimation(0, "animation", true)
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, null, false, nil)
        animation:addAnimation(0, "animation_born", false)
        animation:addAnimation(0, "animation", true)
        -- -- spine动画初始化
        -- sp.initArmature(animation, true)
        
        animation:setPosition(cc.p(Panel_create_woman:getContentSize().width/2,Panel_create_woman:getContentSize().height/2))
        Panel_create_woman:addChild(animation)
    end
end

function CreateCharacter:selectRole(button, selectIndex)
    self.selectIndex = selectIndex
    if self.lastSelectRole ~= nil then
        self.lastSelectRole:setVisible(false)
    end

    if self.lastSelectButton ~= nil then
        self.lastSelectButton:setHighlighted(false)
    end

    local selectWidgetName = nil
    if selectIndex == 0 then
        selectWidgetName = "Panel_create_man"
    else
        selectWidgetName = "Panel_create_woman"
    end

    local root = self.roots[1]
    self.lastSelectRole = ccui.Helper:seekWidgetByName(root, selectWidgetName)
    self.lastSelectRole:setVisible(true)

    self.lastSelectButton = button
    self.lastSelectButton:setHighlighted(true)
end

function CreateCharacter:onInit()  
	local csbItem = csb.createNode(config_csb.login.create_character)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)


    local action = csb.createTimeline(config_csb.login.create_character)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)

    csbItem:runAction(action)    

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_role_select)
    local Panel_character = ccui.Helper:seekWidgetByName(root, "Panel_character")
    if Panel_character ~= nil then
        self._create_character_armature = ccs.Armature:create("effect_role_select")
        self._create_character_armature:setPosition(cc.p(Panel_character:getContentSize().width/2, Panel_character:getContentSize().height/2))
        Panel_character:addChild(self._create_character_armature)
    end

    local nameData = zstring.split(dms.string(dms["user_config"],31,user_config.param),",")
    local Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")
    Text_tips:setString(string.format(red_alert_time_str[280], tonumber(nameData[1]), tonumber(nameData[2])))

    --begin gama
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_create_begin"),nil, 
    { 
        terminal_name = "create_character_to_begin_game", 
        cell = self,
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }
    ,nil, 0)

    --男
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_create_man"),nil, 
    { 
        terminal_name = "create_character_to_change_role", 
        cell = self,
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        select_index = 0,
    }
    ,nil, 3)   

    --女
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_create_women"),nil, 
    { 
        terminal_name = "create_character_to_change_role", 
        cell = self,
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        select_index = 1,
    }
    ,nil, 3) 
    --名字
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_create_character_name"),nil, 
    { 
        terminal_name = "create_character_change_name", 
        cell = self,
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,         
    }
    ,nil, 0)      
    if action:IsAnimationInfoExists("in") == true then
        self.drawMode = 1
        state_machine.lock("create_character_to_change_role")
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "open" then
                state_machine.unlock("create_character_to_change_role")
                local root = self.roots[1]
                state_machine.excute("create_character_to_change_role", 0, ccui.Helper:seekWidgetByName(root, "Button_create_man"))
            end
        end)
        action:stop()
        action:play("in", false)
    else
        local nameData = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
        local roleName = ccui.Helper:seekWidgetByName(root, "TextField_create_character_name")
        roleName = draw:addEditBoxEx(roleName, chat_sent_string[3], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_create_begin"), tonumber(nameData[2]), cc.KEYBOARD_RETURNTYPE_DONE)  
        self:playChangeToWomenAction()   
        self.selectIndex = 0
        self:playChangeToManAction()
        state_machine.excute("create_character_change_name", 0, "create_character_change_name.")
        playEffectOld(formatMusicFile("effect", 10020))
    end
end

function CreateCharacter:init( ... )
    self:onInit()
    return self
end

function CreateCharacter:onExit()
    state_machine.remove("create_character_to_begin_game")
    state_machine.remove("create_character_to_change_role")
    state_machine.remove("create_character_to_change_man")
    state_machine.remove("create_character_to_change_women")
    state_machine.remove("create_character_change_name")
    state_machine.remove("mission_open_game_world_map")
end
