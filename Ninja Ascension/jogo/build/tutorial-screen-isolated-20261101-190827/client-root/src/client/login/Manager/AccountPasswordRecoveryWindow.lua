--[[ ----------------------------------------------------------------------------
-- 
--]] ----------------------------------------------------------------------------
AccountPasswordRecoveryWindow = class("AccountPasswordRecoveryWindowClass", Window)

-- 打开窗口
local account_password_recovery_window_open_terminal = {
	_name = "account_password_recovery_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("AccountPasswordRecoveryWindowClass") then
			fwin:open(AccountPasswordRecoveryWindow:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local account_password_recovery_window_close_terminal = {
	_name = "account_password_recovery_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AccountPasswordRecoveryWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(account_password_recovery_window_open_terminal)
state_machine.add(account_password_recovery_window_close_terminal)
state_machine.init()

-- 构造器
function AccountPasswordRecoveryWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize linkage bind page state machine.
	local function init_account_password_recovery_terminal()
		-- 打开角色创建窗口
		local account_password_recovery_open_terminal = {
			_name = "account_password_recovery_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local account_password_recovery_close_terminal = {
			_name = "account_password_recovery_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("account_password_recovery_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local account_password_recovery_show_terminal = {
			_name = "account_password_recovery_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local account_password_recovery_hide_terminal = {
			_name = "account_password_recovery_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local account_password_recovery_request_bind_terminal = {
            _name = "account_password_recovery_request_bind",
            _init = function (terminal) 
            	
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local account_name = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1")
            	local names = zstring.exchangeTo(account_name:getString())
				local function responseRewardCallback (response)
			        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			        	TipDlg.drawTextDailog(_new_interface_text[308])
			        	state_machine.excute("account_password_recovery_close", 0, 0)
			        end
			    end
			    if names == nil then
			    	names = ""
			    end
			    protocol_command.find_password.param_list = names
			    NetworkManager:register(protocol_command.find_password.code, nil, nil, nil, instance, responseRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(account_password_recovery_open_terminal)
		state_machine.add(account_password_recovery_close_terminal)
		state_machine.add(account_password_recovery_show_terminal)
		state_machine.add(account_password_recovery_hide_terminal)
		state_machine.add(account_password_recovery_request_bind_terminal)
		state_machine.init()
	end
	-- call func init linkage bind state machine.
	init_account_password_recovery_terminal()
end

function AccountPasswordRecoveryWindow:init()
	return self
end

function AccountPasswordRecoveryWindow:onInit()

end

function AccountPasswordRecoveryWindow:onEnterTransitionFinish()
	-- -- 加载AccountPasswordRecoveryWindowWindow界面资源.
	-- -- res.activity.wonderful.limited_time_good_packs = res/activity/wonderful/limited_time_good_packs.csb
	local csbNode = csb.createNode("login/register/register_prompt_10.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	--确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_login"),nil, 
    {
        terminal_name = "account_password_recovery_request_bind",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_register"),nil, 
    {
        terminal_name = "account_password_recovery_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

	--账号
    local Panel_Username = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_Username")
    local TextField_1 = ccui.Helper:seekWidgetByName(self.roots[1], "TextField_1")
    local textField1 = draw:addEditBoxEx(TextField_1, account_sys_manager_tips[9], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_login"), 60, cc.KEYBOARD_RETURNTYPE_DONE)
    Panel_Username:addTouchEventListener(function ( sender, eventType )
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if textField1.touchDownAction ~= nil then
                textField1:touchDownAction(textField1, eventType)
            end
        end
    end)

end

function AccountPasswordRecoveryWindow:onExit()
	state_machine.remove("account_password_recovery_open")
	state_machine.remove("account_password_recovery_close")
	state_machine.remove("account_password_recovery_show")
	state_machine.remove("account_password_recovery_hide")
	state_machine.remove("account_password_recovery_request_bind")
end

function AccountPasswordRecoveryWindow:close()
	-- window event : close.
	
end

function AccountPasswordRecoveryWindow:destroy(window)
	-- window event : destroy.
	
end
-- ~END
-- ----------------------------------------------------------------------------
