AccountManager = class("AccountManagerClass", Window)
    
function AccountManager:ctor()
    self.super:ctor()
 

	local function responseLogin(_cObj, _tJsd)
		-- local pNode = tolua.cast(_cObj, "CCNode")
		-- local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
			-- self:removeFromParentAndCleanup(true)
			-- LuaClasses["LoginClass"].updateDrawPlatformInfo()
			
		local user_info_account  = self._TextField_1:getString()
		local user_info_password = self._TextField_2:getString()	
 
 
		if user_info_account == "123" and user_info_password == "123" then
		
			fwin:close(instance)
			cacher.destoryRefPools()
			cacher.cleanSystemCacher()
			cacher.cleanActionTimeline()
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				checkTipBeLeave()
			end				
			cacher.remvoeUnusedArmatureFileInfoes()
			fwin:reset()
		
			app.load("client.login.login")
			fwin:open(Login:new(), fwin._screen)
		
		elseif user_info_account == "" or user_info_password =="" then
			--> print("用户名或密码不能为空")
		else
			--> print("用户名或密码错误")
		
		end
			
	end

	
	local function	requestLogin()
		local user_info_account  = self._TextField_1:getString()
		local user_info_password = self._TextField_2:getString()

		-- protocol_command.platform_login.param_list = user_info_account.."\r\n"..user_info_password._editPassword
		-- Sender(protocol_command.platform_login.code, nil, nil, nil, nil, responseLogin, 1)
		responseLogin()
	end
	
	
	
    -- Initialize AccountManager page state machine.
    local function init_AccountManager_terminal()
		--返回开机界面
        local account_manager_return_login_terminal = {
            _name = "account_manager_return_login",
            _init = function (terminal) 
                --app.load("client.AccountManager.PlatformManager")
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
		
		--修改密码
		local account_manager_reset_password_terminal = {
            _name = "account_manager_reset_password",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				app.load("client.login.ResetPassword")
				fwin:open(ResetPassword:new(),fwin._screen)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--账号注册
		local account_manager_register_account_terminal = {
            _name = "account_manager_register_account",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				app.load("client.login.AccountRegister")
				fwin:open(AccountRegister:new(),fwin._screen)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--删除账号和密码按钮X
		local account_manager_delete_account_password_terminal = {
            _name = "account_manager_delete_account_password",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self._TextField_1:setString("")
				self._TextField_2:setString("")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
		--登录游戏
		local account_manager_loading_game_terminal = {
            _name = "account_manager_loading_game",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				requestLogin()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
        state_machine.add(account_manager_return_login_terminal)
        state_machine.add(account_manager_reset_password_terminal)
        state_machine.add(account_manager_register_account_terminal)
        state_machine.add(account_manager_delete_account_password_terminal)
        state_machine.add(account_manager_loading_game_terminal)
        state_machine.init()
    end
    
    -- call func init AccountManager state machine.
    init_AccountManager_terminal()
end

function AccountManager:onEnterTransitionFinish()

        
    local csbaccount = csb.createNode("login/AccountManager.csb")
    self:addChild(csbaccount)
	
	local root = csbaccount:getChildByName("root")

	
	self._TextField_1 = ccui.Helper:seekWidgetByName(root, "TextField_1")
	self._TextField_2 = ccui.Helper:seekWidgetByName(root, "TextField_2")
	
	local return_load_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "return_load_button"), nil, {func_string = [[state_machine.excute("account_manager_return_login", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	local resetpassword_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "resetpassword_button"), nil, {func_string = [[state_machine.excute("account_manager_reset_password", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	local registeraccount_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "registeraccount_button"), nil, {func_string = [[state_machine.excute("account_manager_register_account", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	local load_game_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "load_game_button"), nil, {func_string = [[state_machine.excute("account_manager_loading_game", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 0)

	
	local delete_info_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "delete_info_button"), nil, {func_string = [[state_machine.excute("account_manager_delete_account_password", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 0)
   
    -- local user_info = _ED.user_platform[_ED.default_user]
	local user_info_account  = self._TextField_1:getString()
	local user_info_password = self._TextField_2:getString()
	
	-- if user_info ~= nil then
		-- self._TextField_1:setString(zstring.exchangeFrom(user_info.platform_account))
		-- self._TextField_2:setString(zstring.exchangeFrom(user_info.password))
	-- end
   
end



function AccountManager:onExit()
	state_machine.remove("account_manager_return_login")
	state_machine.remove("account_manager_reset_password")
	state_machine.remove("account_manager_register_account")
	state_machine.remove("account_manager_delete_account_password")
	state_machine.remove("account_manager_loading_game")
	
	
end
-- return AccountManager:new()