-- ----------------------------------------------------------------------------------------------------
-- 说明：渠道的登录界面
-------------------------------------------------------------------------------------------------------

platformSDKLoginTencent = class("platformSDKLoginTencentClass", Window)
    
function platformSDKLoginTencent:ctor()
    self.super:ctor()
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
    -- Initialize platformSDKLoginTencent state machine.
    local function init_platform_sdk_login_tencent_terminal()
		local platform_sdk_wx_login_terminal = {
            _name = "platform_sdk_wx_login",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("platform_manager_login", 0, { messageType = LOGIN ,messageText = "2"})
				cc.UserDefault:getInstance():setStringForKey("tencentType", "2")
				cc.UserDefault:getInstance():flush()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local platform_sdk_qq_login_terminal = {
            _name = "platform_sdk_qq_login",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("platform_manager_login", 0, { messageType = 10 ,messageText = "1"})
				cc.UserDefault:getInstance():setStringForKey("tencentType", "1")
				cc.UserDefault:getInstance():flush()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		state_machine.add(platform_sdk_wx_login_terminal)	
		state_machine.add(platform_sdk_qq_login_terminal)	
        state_machine.init()
    end
    -- call func init hom state machine.
    init_platform_sdk_login_tencent_terminal()
end

function platformSDKLoginTencent:onEnterTransitionFinish()
    local loginTencent = csb.createNode("login/login_qq.csb")
	local root = loginTencent:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(loginTencent)
	
	local wxlogin = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_102_wx"), nil, {terminal_name = "platform_sdk_wx_login", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local qqlogin = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_102_qq"), nil, {terminal_name = "platform_sdk_qq_login", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	handlePlatformRequest(0, CHECK_USER, "")
	-- if m_sUin~=nil and m_sUin~="" then
		-- fwin:close(fwin:find("platformSDKLoginTencentClass"))
	-- end
end

function platformSDKLoginTencent:onExit()
	-- state_machine.remove("platform_sdk_wx_login")
	-- state_machine.remove("platform_sdk_qq_login")
end

