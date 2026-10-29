--[[ ----------------------------------------------------------------------------
-- 忘记密码
--]] ----------------------------------------------------------------------------
AccountSysForgetPassword = class("AccountSysForgetPasswordClass", Window)

-- 打开窗口
local account_sys_forget_password_window_open_terminal = {
	_name = "account_sys_forget_password_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("AccountSysForgetPasswordClass") then
			fwin:open(AccountSysForgetPassword:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local account_sys_forget_password_window_close_terminal = {
	_name = "account_sys_forget_password_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AccountSysForgetPasswordClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(account_sys_forget_password_window_open_terminal)
state_machine.add(account_sys_forget_password_window_close_terminal)
state_machine.init()

-- 构造器
function AccountSysForgetPassword:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_account_sys_forget_password_terminal()
		-- 打开角色创建窗口
		local account_sys_forget_password_open_terminal = {
			_name = "account_sys_forget_password_open",
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
		local account_sys_forget_password_close_terminal = {
			_name = "account_sys_forget_password_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("account_sys_forget_password_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local account_sys_forget_password_show_terminal = {
			_name = "account_sys_forget_password_show",
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
		local account_sys_forget_password_hide_terminal = {
			_name = "account_sys_forget_password_hide",
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

		state_machine.add(account_sys_forget_password_open_terminal)
		state_machine.add(account_sys_forget_password_close_terminal)
		state_machine.add(account_sys_forget_password_show_terminal)
		state_machine.add(account_sys_forget_password_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_account_sys_forget_password_terminal()
end

-- 对象初始化
function AccountSysForgetPassword:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function AccountSysForgetPassword:onUpdateDraw()
	local root = self.roots[1]

end

function AccountSysForgetPassword:onEnterTransitionFinish()
	-- 加载AccountSysForgetPasswordWindow界面资源.
	local csbNode = csb.createNode("login/register/register_prompt_10.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = ccui.Helper:seekWidgetByName(root, "Button_close")
	self.Button_close = fwin:addTouchEventListener(self.Button_close, nil,
	{
		terminal_name = "account_sys_forget_password_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	self.Text_yx = ccui.Helper:seekWidgetByName(root, "Text_yx")
	if account_sys_manager_tips[11] ~= nil then
		self.Text_yx:setString(account_sys_manager_tips[11])
		self.Text_yx:setVisible(true)
	else
		self.Text_yx:setVisible(false)
	end
	

	self:onUpdateDraw()
end

function AccountSysForgetPassword:onExit()
	-- 释放AccountSysForgetPasswordWindow界面资源.
	state_machine.remove("account_sys_forget_password_open")
	state_machine.remove("account_sys_forget_password_close")
	state_machine.remove("account_sys_forget_password_show")
	state_machine.remove("account_sys_forget_password_hide")
end

function AccountSysForgetPassword:close()
	-- window event : close.
	
end

function AccountSysForgetPassword:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
