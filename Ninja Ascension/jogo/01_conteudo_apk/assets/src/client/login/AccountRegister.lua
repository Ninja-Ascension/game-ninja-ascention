AccountRegister = class("AccountRegisterClass", Window)

function AccountRegister:ctor()
    self.super:ctor()
    
	local function responseLogin(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
			if __lua_project_id==__lua_project_all_star then
				executeMissionExt(mission_mould_plot, touch_off_mission_into_home, "0", nil, true, "0")
			else
				LuaClasses["CharacterCreateClass"]:Draw()
			end
		end
	end

	-- 请求登录账号
	local function requestLogin()
		AccountRegister._editName = inputUserName:getStringValue()
		AccountRegister._editPassword = inputPassword:getStringValue()
		--protocol_command.login_init.param_list = getPlatform().."\r\n"..getHardwareType().."\r\n".._ED.user_platform[_ED.default_user].platform_account.."\r\n".._ED.user_platform[_ED.default_user].password.."\r\n"..getApplicationName().."\r\n".._ED.selected_server
		--Sender(protocol_command.login_init.code, nil, nil, nil, nil, responseLogin, 1)
	end
	
	local function responseValiRegister(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
			-- local user_info = _ED.user_platform[_ED.default_user]
			-- if user_info ~= nil then
				-- if user_info.is_registered == true then
					-- requestLogin()
				-- else
					--进入第一次创建人物界面，这里先跳转为home界面
				fwin:reset(nil)
				
				app.load("client.home.home")
                fwin:open(Home:new(), fwin._screen) 
				-- end
			-- end
		-- end
	end		
	
	--请求验证账号是否注册
	local function requestValiRegister()
		--local server = _ED.all_servers[_ED.selected_server]
		--protocol_command.vali_register.param_list = _ED.user_platform[_ED.default_user].platform_account.."\r\n"..server.server_number.."\r\n"..getUserAccountPlatform().."\r\n"..getPlatform().."\r\n"
		--Sender(protocol_command.vali_register.code, server.server_link, nil, nil, nil, responseValiRegister, 1)
		responseValiRegister()
	end		
	
	local function responsePlatformLogin(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
			-- self:removeFromParentAndCleanup(true)
			requestValiRegister()
		-- end	
	end
	
	--请求平台登录
	local function requestPlatformLogin()
		--protocol_command.platform_login.param_list = AccountRegister._userName.."\r\n"..AccountRegister._password
		--Sender(protocol_command.platform_login.code, nil, nil, nil, nil, responsePlatformLogin)
		responsePlatformLogin()
	end
	
	local function responseRegister(_cObj, _tJsd)
		local pNode = tolua.cast(_cObj, "CCNode")
		local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
		-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
			-- self:removeFromParentAndCleanup(true)
			--注册成功后立即调用登录请求
			requestPlatformLogin()
		-- end	
	end
	
    -- Initialize AccountRegister page state machine.
    local function init_AccountRegister_terminal()
		--返回游戏
        local account_register_return_login_terminal = {
            _name = "account_return_login_game",
            _init = function (terminal) 

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

		--注册并登录按钮
        local account_register_loading_terminal = {
            _name = "account_register_loading_game",
            _init = function (terminal) 
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				AccountRegister._userName = self._inputUserName:getString()
				AccountRegister._password = self._inputPassword:getString()
				AccountRegister._confirmPassword = self._inputConfirmPassword:getString()
				AccountRegister._mail 			 = self._inputMail:getString()
				
				--> debug.log("", self._inputUserName:getString())
				--> debug.log("", self._inputPassword:getString())
				--> debug.log("", self._inputConfirmPassword:getString())
				--> debug.log("", self._inputMail:getString())
				
				local str = "0".."\r\n"
				str = str..AccountRegister._userName.."\r\n"--用户名
				str = str..AccountRegister._password.."\r\n"
				str = str..AccountRegister._confirmPassword.."\r\n"
				str = str..AccountRegister._mail.."\r\n"
				str = str.."Guest".."\r\n"
				str = str.."\r\n"
				--protocol_command.platform_manage.param_list = str
				if #AccountRegister._password < 6 then
					--TipDlg.drawTextDailog(_string_piece_info[202])
					--> print("password is  < 6")
					return
				elseif #AccountRegister._password > 31 then
					--TipDlg.drawTextDailog(_string_piece_info[204])
					--> print("password is  > 31")
					
					return
				elseif AccountRegister._confirmPassword ~= AccountRegister._password then
					--TipDlg.drawTextDailog(_string_piece_info[203])
					--> print("twice put is not same")
					return
				end
				--Sender(protocol_command.platform_manage.code, nil, nil, nil, nil, responseRegister)
				responseRegister()				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }		
        state_machine.add(account_register_return_login_terminal)
        state_machine.add(account_register_loading_terminal)
        state_machine.init()
    end
    
    -- call func init AccountRegister state machine.
    init_AccountRegister_terminal()
end

function AccountRegister:onEnterTransitionFinish()
    -- local topLayer = cc.LayerGradient:create(cc.c4b(255,0,0,255), cc.c4b(0,255,0,255), cc.p(0.9, 0.9))
    -- topLayer:setContentSize(cc.size(fwin._width, fwin._height))
    -- self:addChild(topLayer)
        
    local csbaccountregister = csb.createNode("login/AccountRegister.csb")
    self:addChild(csbaccountregister)
	
	local Panel_1 = csbaccountregister:getChildByName("Panel_1")
	local return_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(Panel_1, "return_button"), nil, {func_string = [[state_machine.excute("account_return_login_game", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 2)

	self._inputUserName = ccui.Helper:seekWidgetByName(Panel_1, "TextField_1")	--账号
	self._inputPassword = ccui.Helper:seekWidgetByName(Panel_1, "TextField_2")	--密码
	self._inputConfirmPassword = ccui.Helper:seekWidgetByName(Panel_1, "TextField_3")	--2次密码
	self._inputMail = ccui.Helper:seekWidgetByName(Panel_1, "TextField_4")				--邮箱
	
	--注册并登录按钮
	local Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(Panel_1, "Button_2"), nil, {func_string = [[state_machine.excute("account_register_loading_game", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	
	
end


function AccountRegister:onExit()
	state_machine.remove("account_return_login_game")
	state_machine.remove("account_register_loading_game")
end
-- return AccountRegister:new()