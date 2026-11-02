-- ----------------------------------------------------------------------------------------------------
-- 说明：渠道的登录界面
-------------------------------------------------------------------------------------------------------

platformSDKLoginMove = class("platformSDKLoginMoveClass", Window)
    
function platformSDKLoginMove:ctor()
    self.super:ctor()
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
    -- Initialize platformSDKLoginMove state machine.
    local function init_platform_sdk_login_tencent_terminal()
		local platform_sdk_google_login_terminal = {
            _name = "platform_sdk_google_login",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("platform_manager_login", 0, { messageType = LOGIN ,messageText = "1"})
                -- state_machine.lock("platform_sdk_google_login", 0, "")
                -- state_machine.lock("platform_sdk_facebook_login", 0, "")
                -- state_machine.lock("platform_sdk_hotgame_login", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local platform_sdk_facebook_login_terminal = {
            _name = "platform_sdk_facebook_login",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("platform_manager_login", 0, { messageType = LOGIN ,messageText = "2"})
                -- state_machine.lock("platform_sdk_google_login", 0, "")
                -- state_machine.lock("platform_sdk_facebook_login", 0, "")
                -- state_machine.lock("platform_sdk_hotgame_login", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local platform_sdk_hotgame_login_terminal = {
            _name = "platform_sdk_hotgame_login",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.lock("platform_sdk_google_login", 0, "")
                -- state_machine.lock("platform_sdk_facebook_login", 0, "")
                -- state_machine.lock("platform_sdk_hotgame_login", 0, "")
                -- fwin:close(fwin:find("ConnectingViewClass"))
                cc.UserDefault:getInstance():setStringForKey("moveLofinType", "3")
                cc.UserDefault:getInstance():flush()
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
                                -- state_machine.lock("platform_sdk_google_login", 0, "")
                                -- state_machine.lock("platform_sdk_facebook_login", 0, "")
                                -- state_machine.lock("platform_sdk_hotgame_login", 0, "")
                            else
                                -- state_machine.lock("platform_sdk_google_login", 0, "")
                                -- state_machine.lock("platform_sdk_facebook_login", 0, "")
                                -- state_machine.lock("platform_sdk_hotgame_login", 0, "")
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
                                    -- state_machine.excute("account_sys_manager_open", 0, "account_sys_manager_open.")
                                    -- state_machine.lock("platform_sdk_google_login", 0, "")
                                    -- state_machine.lock("platform_sdk_facebook_login", 0, "")
                                    -- state_machine.lock("platform_sdk_hotgame_login", 0, "")
                                else
                                    -- state_machine.lock("platform_sdk_google_login", 0, "")
                                    -- state_machine.lock("platform_sdk_facebook_login", 0, "")
                                    -- state_machine.lock("platform_sdk_hotgame_login", 0, "")
                                end
                            end
                            self:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
                                NetworkManager:register(protocol_command.search_user_platform.code, app.configJson.url, nil, nil, nil, responseSearchCallback, false, nil)
                            end)}))
                        -- else
                        --  app.load("client.login.Manager.AccountSysManager")
                        --  state_machine.excute("account_sys_manager_open", 0, "account_sys_manager_open.")
                        --  protocol_command.search_user_platform.user_info_switch = nil
                        -- end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local platform_linkage_login_terminal = {
            _name = "platform_linkage_login",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                app.load("client.login.LinkageBindWindow")
                state_machine.excute("linkage_bind_window_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
		
		state_machine.add(platform_sdk_google_login_terminal)	
        state_machine.add(platform_sdk_facebook_login_terminal)   
        state_machine.add(platform_sdk_hotgame_login_terminal)  
		state_machine.add(platform_linkage_login_terminal)	
        state_machine.init()
    end
    -- call func init hom state machine.
    init_platform_sdk_login_tencent_terminal()
end

function platformSDKLoginMove:onEnterTransitionFinish()
    local loginTencent = csb.createNode("login/login_hot.csb")
	local root = loginTencent:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(loginTencent)
	
	local googlelogin = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_google"), nil, {terminal_name = "platform_sdk_google_login", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
    local fblogin = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_facebook"), nil, {terminal_name = "platform_sdk_facebook_login", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
    local hotgamelogin = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hotgame"), nil, {terminal_name = "platform_sdk_hotgame_login", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local LinkageButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_liandong"), nil, {terminal_name = "platform_linkage_login", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	handlePlatformRequest(0, CHECK_USER, "")
	
   if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
        local Text_facebook = ccui.Helper:seekWidgetByName(root, "Text_facebook")
        local Text_google = ccui.Helper:seekWidgetByName(root, "Text_google")
        local Text_BANDAI = ccui.Helper:seekWidgetByName(root, "Text_BANDAI")
        local Text_hotgame = ccui.Helper:seekWidgetByName(root, "Text_hotgame")
        LinkageButton:setVisible(false)
        Text_hotgame:setVisible(false)
        hotgamelogin:setVisible(false)
        Text_BANDAI:setVisible(false)
        googlelogin:setPositionY(googlelogin:getPositionY() - LinkageButton:getContentSize().height)
        Text_google:setPositionY(Text_google:getPositionY() - LinkageButton:getContentSize().height)
        fblogin:setPositionY(fblogin:getPositionY() - LinkageButton:getContentSize().height/2)
        Text_facebook:setPositionY(Text_facebook:getPositionY() - LinkageButton:getContentSize().height/2)
	else
		local Text_facebook = ccui.Helper:seekWidgetByName(root, "Text_facebook")
        local Text_google = ccui.Helper:seekWidgetByName(root, "Text_google")
        local Text_BANDAI = ccui.Helper:seekWidgetByName(root, "Text_BANDAI")
        local Text_hotgame = ccui.Helper:seekWidgetByName(root, "Text_hotgame")
        LinkageButton:setVisible(false)
        Text_hotgame:setVisible(false)
        googlelogin:setPositionY(googlelogin:getPositionY() - LinkageButton:getContentSize().height/2)
        Text_google:setPositionY(Text_google:getPositionY() - LinkageButton:getContentSize().height/2)
        fblogin:setPositionY(fblogin:getPositionY() - LinkageButton:getContentSize().height/2)
        Text_facebook:setPositionY(Text_facebook:getPositionY() - LinkageButton:getContentSize().height/2)
		hotgamelogin:setPositionY(hotgamelogin:getPositionY() - LinkageButton:getContentSize().height/2)
		Text_BANDAI:setPositionY(Text_BANDAI:getPositionY() - LinkageButton:getContentSize().height/2)
    end

    local moveLofinType = cc.UserDefault:getInstance():getStringForKey("moveLofinType","0")
    if moveLofinType ~= nil and moveLofinType ~= "0" and moveLofinType ~= "" then
        --fwin:open(ConnectingView:new(), fwin._windows)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
            if tonumber(moveLofinType) == 1 then
                state_machine.excute("platform_sdk_google_login", 0, "platform_sdk_google_login.")
            elseif tonumber(moveLofinType) == 2 then
                state_machine.excute("platform_sdk_facebook_login", 0, "platform_sdk_facebook_login.")
            elseif tonumber(moveLofinType) == 3 then
                state_machine.excute("platform_sdk_hotgame_login", 0, "platform_sdk_hotgame_login.")
            end
        end)}))
    end
	-- if m_sUin~=nil and m_sUin~="" then
		-- fwin:close(fwin:find("platformSDKLoginMoveClass"))
	-- end
end

function platformSDKLoginMove:onExit()
	-- state_machine.remove("platform_sdk_wx_login")
	-- state_machine.remove("platform_sdk_qq_login")
end

