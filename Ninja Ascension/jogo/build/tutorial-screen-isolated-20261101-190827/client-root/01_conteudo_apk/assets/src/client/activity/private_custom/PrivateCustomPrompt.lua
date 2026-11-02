--[[ ----------------------------------------------------------------------------
-- 私人订制主界面
--]] ----------------------------------------------------------------------------
PrivateCustomPrompt = class("PrivateCustomPromptClass", Window)

-- 打开窗口
local private_custom_prompt_window_open_terminal = {
	_name = "private_custom_prompt_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("PrivateCustomPromptClass") then
			fwin:open(PrivateCustomPrompt:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local private_custom_prompt_window_close_terminal = {
	_name = "private_custom_prompt_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("PrivateCustomPromptClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(private_custom_prompt_window_open_terminal)
state_machine.add(private_custom_prompt_window_close_terminal)
state_machine.init()

-- 构造器
function PrivateCustomPrompt:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize private custom prompt page state machine.
	local function init_private_custom_prompt_terminal()
		-- 打开角色创建窗口
		local private_custom_prompt_open_terminal = {
			_name = "private_custom_prompt_open",
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
		local private_custom_prompt_close_terminal = {
			_name = "private_custom_prompt_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("private_custom_prompt_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local private_custom_prompt_show_terminal = {
			_name = "private_custom_prompt_show",
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
		local private_custom_prompt_hide_terminal = {
			_name = "private_custom_prompt_hide",
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

		-- 点击确认
		local private_custom_prompt_sure_terminal = {
			_name = "private_custom_prompt_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local gear = instance._gear
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							-- 刷新红点
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 170)
							-- 领取完刷新界面
							state_machine.excute("private_custom_refesh_windows", 0, nil)
							-- 关闭本界面
							state_machine.excute("private_custom_prompt_close", 0, nil)
						end
					end
					protocol_command.private_custom_reward_get.param_list = "" .. gear
					NetworkManager:register(protocol_command.private_custom_reward_get.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(private_custom_prompt_open_terminal)
		state_machine.add(private_custom_prompt_close_terminal)
		state_machine.add(private_custom_prompt_show_terminal)
		state_machine.add(private_custom_prompt_hide_terminal)
		state_machine.add(private_custom_prompt_sure_terminal)
		state_machine.init()
	end
	-- call func init private custom prompt state machine.
	init_private_custom_prompt_terminal()
end

-- 对象初始化
function PrivateCustomPrompt:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function PrivateCustomPrompt:onInit(params)
	self._gear = params.gear
end

function PrivateCustomPrompt:onUpdateDraw()
	local root = self.roots[1]

end

function PrivateCustomPrompt:onEnterTransitionFinish()
	-- 加载PrivateCustomPromptWindow界面资源.
	-- res.activity.private_custom.private_custom_prompt = res/activity/private_custom/private_custom_prompt.csb
	local csbNode = csb.createNode("activity/private_custom/private_custom_prompt.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定
	self.Button_ok = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil,
	{
		terminal_name = "private_custom_prompt_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "private_custom_prompt_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "private_custom_prompt_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function PrivateCustomPrompt:onExit()
	-- 释放PrivateCustomPromptWindow界面资源.
	state_machine.remove("private_custom_prompt_open")
	state_machine.remove("private_custom_prompt_close")
	state_machine.remove("private_custom_prompt_show")
	state_machine.remove("private_custom_prompt_hide")
	state_machine.remove("private_custom_prompt_sure")
end

function PrivateCustomPrompt:close()
	-- window event : close.
	
end

function PrivateCustomPrompt:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
