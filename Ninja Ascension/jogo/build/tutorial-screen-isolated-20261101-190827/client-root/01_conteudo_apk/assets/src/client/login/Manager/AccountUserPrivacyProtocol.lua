
AccountUserPrivacyProtocol = class("AccountUserPrivacyProtocolClass", Window)

local account_user_privacy_protocol_open_terminal = {
    _name = "account_user_privacy_protocol_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("AccountUserPrivacyProtocolClass"))
        fwin:open(AccountUserPrivacyProtocol:new(), fwin._display_log)
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

local account_user_privacy_protocol_close_terminal = {
    _name = "account_user_privacy_protocol_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("AccountUserPrivacyProtocolClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(account_user_privacy_protocol_open_terminal)
state_machine.add(account_user_privacy_protocol_close_terminal)
state_machine.init()
    
function AccountUserPrivacyProtocol:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	
    local function init_account_user_privacy_protocol_terminal()
        --同意
        local account_user_privacy_protocol_sure_terminal = {
            _name = "account_user_privacy_protocol_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                cc.UserDefault:getInstance():setStringForKey("platform_user_privacy_protocol", "yes")
                state_machine.excute("account_user_privacy_protocol_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --拒绝
        local account_user_privacy_protocol_cancle_terminal = {
            _name = "account_user_privacy_protocol_cancle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local targetPlatform = cc.Application:getInstance():getTargetPlatform()
                if cc.PLATFORM_OS_IPHONE == targetPlatform
                    or cc.PLATFORM_OS_IPAD == targetPlatform
                    -- or cc.PLATFORM_OS_WINDOWS == targetPlatform
                    then
                    state_machine.excute("account_user_privacy_protocol_close", 0, nil)
                else
                    handlePlatformRequest(0, CC_GAME_EXIT_DETERMINE, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --查看详情
        local account_user_privacy_protocol_more_info_terminal = {
            _name = "account_user_privacy_protocol_more_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                app.load("client.login.Manager.AccountUserPrivacyProtocolMore")
                state_machine.excute("account_user_privacy_protocol_more_open", 0, index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(account_user_privacy_protocol_sure_terminal)
        state_machine.add(account_user_privacy_protocol_cancle_terminal)
        state_machine.add(account_user_privacy_protocol_more_info_terminal)
        state_machine.init()
    end
    
    init_account_user_privacy_protocol_terminal()
end

function AccountUserPrivacyProtocol:onUpdataDraw()
	local root = self.roots[1]
end

function AccountUserPrivacyProtocol:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("login/register/register_prompt_6.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_start"),nil, 
    {
        terminal_name = "account_user_privacy_protocol_sure",
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),nil, 
    {
        terminal_name = "account_user_privacy_protocol_cancle",
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    for i=1,2 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Text_"..i),nil, 
        {
            terminal_name = "account_user_privacy_protocol_more_info",
            terminal_state = 0, 
            isPressedActionEnabled = true,
            index = i
        },
        nil, 0)
    end
end

function AccountUserPrivacyProtocol:onExit()
end
