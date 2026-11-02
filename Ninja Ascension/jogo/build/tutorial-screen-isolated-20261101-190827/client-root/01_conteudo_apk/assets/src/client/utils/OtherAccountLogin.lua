OtherAccountLogin = class("OtherAccountLoginClass", Window)

local other_account_login_window_open_terminal = {
    _name = "other_account_login_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil ~= fwin:find("ReconnectViewClass") then
            return false
        end
        if _ED.user_info ~= nil and _ED.user_info.user_id ~= "" then
        	fwin:close("OtherAccountLoginClass")
        	fwin:open(OtherAccountLogin:new():init(params), fwin._system)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local other_account_login_window_close_terminal = {
    _name = "other_account_login_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close("OtherAccountLoginClass")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_account_login_window_open_terminal)
state_machine.add(other_account_login_window_close_terminal)
state_machine.init()

function OtherAccountLogin:ctor()
    self.super:ctor()
    local function init_other_account_login_terminal()
		-- 界面确定按钮
        local other_account_login_tip_ok_terminal = {
            _name = "other_account_login_tip_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local platformloginInfo = {
					platform_id="",
					register_type="",
					platform_account="",
					nickname="",		
					password="",
					is_registered = false
					}
				_ED.user_platform = {}
				_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
				_ED.default_user = platformloginInfo.platform_account
				fwin:removeAll()
				cacher.destoryRefPools()
				cacher.cleanSystemCacher()
				cacher.cleanActionTimeline()
				
				checkTipBeLeave()

				cacher.remvoeUnusedArmatureFileInfoes()
				fwin:reset(nil)
				fwin:open(Login:new(), fwin._view)
				state_machine.excute("other_account_login_window_close", 0, nil)
				_ED.m_is_games = false
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(other_account_login_tip_ok_terminal)
        state_machine.init()
    end
    init_other_account_login_terminal()
end

function OtherAccountLogin:onEnterTransitionFinish()
    local csbLoginOfOtherTip = csb.createNode("utils/prompt_5.csb")
    self:addChild(csbLoginOfOtherTip)
	
	local root = csbLoginOfOtherTip:getChildByName("root")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), nil, {
		terminal_name = "other_account_login_tip_ok", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
	}, nil, 0)
end

function OtherAccountLogin:init(params)
    return self
end

function OtherAccountLogin:onExit()
	state_machine.remove("other_account_login_tip_ok")
end