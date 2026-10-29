--[[ ----------------------------------------------------------------------------
-- 跳转下一层确认界面
--]] ----------------------------------------------------------------------------
SecretTreasurePrompt_3 = class("SecretTreasurePrompt_3Class", Window)

-- 打开窗口
local secret_treasure_prompt_3_window_open_terminal = {
	_name = "secret_treasure_prompt_3_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasurePrompt_3Class") then
			fwin:open(SecretTreasurePrompt_3:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_prompt_3_window_close_terminal = {
	_name = "secret_treasure_prompt_3_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasurePrompt_3Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_prompt_3_window_open_terminal)
state_machine.add(secret_treasure_prompt_3_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasurePrompt_3:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure rule page state machine.
	local function init_secret_treasure_prompt_3_terminal()
		-- 打开角色创建窗口
		local secret_treasure_prompt_3_open_terminal = {
			_name = "secret_treasure_prompt_3_open",
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
		local secret_treasure_prompt_3_close_terminal = {
			_name = "secret_treasure_prompt_3_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_prompt_3_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_prompt_3_show_terminal = {
			_name = "secret_treasure_prompt_3_show",
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
		local secret_treasure_prompt_3_hide_terminal = {
			_name = "secret_treasure_prompt_3_hide",
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

		local secret_treasure_prompt_3_sure_terminal = {
			_name = "secret_treasure_prompt_3_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("secret_treasure_go_to_next_floor", 0, nil)
					state_machine.excute("secret_treasure_prompt_3_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(secret_treasure_prompt_3_open_terminal)
		state_machine.add(secret_treasure_prompt_3_close_terminal)
		state_machine.add(secret_treasure_prompt_3_show_terminal)
		state_machine.add(secret_treasure_prompt_3_hide_terminal)
		state_machine.add(secret_treasure_prompt_3_sure_terminal)
		state_machine.init()
	end
	-- call func init secret treasure rule state machine.
	init_secret_treasure_prompt_3_terminal()
end

-- 对象初始化
function SecretTreasurePrompt_3:init(params)

	return self
end

function SecretTreasurePrompt_3:onUpdateDraw()
	local root = self.roots[1]
	self.Text_consume_power_0 = ccui.Helper:seekWidgetByName(root, "Text_consume_power_0")

	local isTurnAllCard = SecretTreasureHandle.getSecretAllCardTurn()

	local str = isTurnAllCard and tipStringInfo_activity_secret_treasure[5] or tipStringInfo_activity_secret_treasure[6]
	self.Text_consume_power_0:setString(str)
end

function SecretTreasurePrompt_3:onEnterTransitionFinish()
	-- 加载SecretTreasurePrompt_3Window界面资源.
	-- res.activity.secret_treasure.secret_treasure_prompt_3 = res/activity/secret_treasure/secret_treasure_prompt_3.csb
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_prompt_3.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "secret_treasure_prompt_3_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "secret_treasure_prompt_3_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "secret_treasure_prompt_3_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_self = self
	}, nil, 0)

	self:onUpdateDraw()
end

function SecretTreasurePrompt_3:onExit()
	-- 释放SecretTreasurePrompt_3Window界面资源.
	state_machine.remove("secret_treasure_prompt_3_open")
	state_machine.remove("secret_treasure_prompt_3_close")
	state_machine.remove("secret_treasure_prompt_3_show")
	state_machine.remove("secret_treasure_prompt_3_hide")
end

function SecretTreasurePrompt_3:close()
	-- window event : close.
	
end

function SecretTreasurePrompt_3:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
