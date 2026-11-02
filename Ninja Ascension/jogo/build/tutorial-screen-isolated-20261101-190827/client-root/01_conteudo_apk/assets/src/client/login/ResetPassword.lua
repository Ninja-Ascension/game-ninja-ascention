ResetPassword = class("ResetPasswordClass", Window)
    
function ResetPassword:ctor()
    self.super:ctor()
    
	
	local function responseSearchUserPlatform(_cObj, _tJsd)
			local pNode = tolua.cast(_cObj, "CCNode")
			local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
			-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() == true then
				--LuaClasses["LoginClass"]:updateDrawUserId()

			-- end		
		end
		
	local function requestSearchUserPlatform()
			--Sender(protocol_command.search_user_platform.code, nil, nil, nil, nil, responseSearchUserPlatform)
			responseSearchUserPlatform()
	end		
	
	

    -- Initialize ResetPassword page state machine.
    local function init_RestPassword_terminal()
		--返回游戏
        local rest_password_return_login_terminal = {
            _name = "rest_password_return_login",
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
		
		
		--修改密码
        local rest_password_rest_userinfo_password_terminal = {
            _name = "rest_userinfo_password",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				ResetPassword._userName 		 = self._inputUserName:getString()
				ResetPassword._password 		 = self._inputPassword:getString()
				ResetPassword._newPassword 		 = self._inputNewPassword:getString()
				ResetPassword._newPasswordAffirm = self._inputNewPasswordAffirm:getString()
								
				local function responseResetPassword(_cObj, _tJsd)
						local pNode = tolua.cast(_cObj, "CCNode")
						local pDataInterpreter = tolua.cast(_tJsd, "CCNetworkDataInterpreter")
						-- if pDataInterpreter ~= nil and pDataInterpreter:isSucceed() then
							-- self:removeFromParentAndCleanup(true)
							requestSearchUserPlatform()
							fwin:close(instance)
							
						-- end	
				end
				--protocol_command.modify_platform_password.param_list = ResetPassword._userName.."\r\n"..ResetPassword._password.."\r\n"..ResetPassword._newPassword.."\r\n"..ResetPassword._newPasswordAffirm
				--Sender(protocol_command.modify_platform_password.code, nil, nil, nil, nil, responseResetPassword)
				responseResetPassword()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
        state_machine.add(rest_password_return_login_terminal)
        state_machine.add(rest_password_rest_userinfo_password_terminal)
        state_machine.init()
    end
    
    -- call func init ResetPassword state machine.
    init_RestPassword_terminal()
end

function ResetPassword:onEnterTransitionFinish()

        
    local csbrestpassword = csb.createNode("login/ResetPassword.csb")
    self:addChild(csbrestpassword)
	
	local root = csbrestpassword:getChildByName("root")
	
	local return_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "return_button"), nil, {func_string = [[state_machine.excute("rest_password_return_login", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	
	self._inputUserName = ccui.Helper:seekWidgetByName(root, "TextField_1")			--账号
	self._inputPassword = ccui.Helper:seekWidgetByName(root, "TextField_2")			--旧密码
	self._inputNewPassword = ccui.Helper:seekWidgetByName(root, "TextField_3")		--新密码
	self._inputNewPasswordAffirm = ccui.Helper:seekWidgetByName(root, "TextField_4")--确认新密码
	
	local Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {func_string = [[state_machine.excute("rest_userinfo_password", 0, "click user_info.'")]], 
									isPressedActionEnabled = true}, nil, 0)

end



function ResetPassword:onExit()
	state_machine.remove("rest_password_return_login")
	state_machine.remove("rest_userinfo_password")
end
-- return ResetPassword:new()