-- ----------------------------------------------------------------------------------------------------
-- 说明：渠道的充值界面
-------------------------------------------------------------------------------------------------------

platformSDKPayAladin = class("platformSDKPayAladinClass", Window)
    
function platformSDKPayAladin:ctor()
    self.super:ctor()
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self._datas = nil
    -- Initialize platformSDKLoginTencent state machine.
    local function init_platform_sdk_pay_aladin_terminal()
		local platform_sdk_app_pay_terminal = {
            _name = "platform_sdk_app_pay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, PLATFORMRECHARGE,self._datas.."|".."1")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local platform_sdk_google_pay_terminal = {
            _name = "platform_sdk_google_pay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, PLATFORMRECHARGE,self._datas.."|".."2")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local platform_sdk_cell_pay_terminal = {
            _name = "platform_sdk_cell_pay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, PLATFORMRECHARGE,self._datas.."|".."3")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local platform_sdk_true_pay_terminal = {
            _name = "platform_sdk_true_pay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, PLATFORMRECHARGE,self._datas.."|".."4")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local platform_sdk_hoppy_pay_terminal = {
            _name = "platform_sdk_hoppy_pay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, PLATFORMRECHARGE,self._datas.."|".."5")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local platform_sdk_sms_pay_terminal = {
            _name = "platform_sdk_sms_pay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, PLATFORMRECHARGE,self._datas.."|".."6")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		local platform_sdk_close_button_terminal = {
            _name = "platform_sdk_close_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("platformSDKPayAladinClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		state_machine.add(platform_sdk_app_pay_terminal)	
		state_machine.add(platform_sdk_google_pay_terminal)	
		state_machine.add(platform_sdk_cell_pay_terminal)	
		state_machine.add(platform_sdk_true_pay_terminal)	
		state_machine.add(platform_sdk_hoppy_pay_terminal)	
		state_machine.add(platform_sdk_sms_pay_terminal)	
		state_machine.add(platform_sdk_close_button_terminal)	
        state_machine.init()
    end
    -- call func init hom state machine.
    init_platform_sdk_pay_aladin_terminal()
end

function platformSDKPayAladin:onEnterTransitionFinish()
    local PayAladin = csb.createNode("shop/shop_chongzhi_window.csb")
	local root = PayAladin:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(PayAladin)
	
	local Button_app = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_app"), nil, {terminal_name = "platform_sdk_app_pay", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_google = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_google"), nil, {terminal_name = "platform_sdk_google_pay", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_call = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_call"), nil, {terminal_name = "platform_sdk_cell_pay", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_true = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_true"), nil, {terminal_name = "platform_sdk_true_pay", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_hoppy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hoppy"), nil, {terminal_name = "platform_sdk_hoppy_pay", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_sms = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sms"), nil, {terminal_name = "platform_sdk_sms_pay", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, {terminal_name = "platform_sdk_close_button", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
		ccui.Helper:seekWidgetByName(root, "Button_app"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_google"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Button_app"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_google"):setVisible(false)
	end
	if zstring.tonumber(_ED.server_review) == 1 then
		ccui.Helper:seekWidgetByName(root, "Button_call"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_true"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_hoppy"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_sms"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Button_call"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_true"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_hoppy"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_sms"):setVisible(true)
	end
end

function platformSDKPayAladin:init(data)
	self._datas = data
end

function platformSDKPayAladin:onExit()
	-- state_machine.remove("platform_sdk_wx_login")
	-- state_machine.remove("platform_sdk_qq_login")
end

