--[[ ----------------------------------------------------------------------------
-- 规则界面
--]] ----------------------------------------------------------------------------
CommandWorldRule = class("CommandWorldRuleClass", Window)

-- 打开窗口
local command_world_rule_window_open_terminal = {
	_name = "command_world_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CommandWorldRuleClass") then
			fwin:open(CommandWorldRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_rule_window_close_terminal = {
	_name = "command_world_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_rule_window_open_terminal)
state_machine.add(command_world_rule_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorldRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure rule page state machine.
	local function init_command_world_rule_terminal()
		-- 打开角色创建窗口
		local command_world_rule_open_terminal = {
			_name = "command_world_rule_open",
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
		local command_world_rule_close_terminal = {
			_name = "command_world_rule_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_rule_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_rule_show_terminal = {
			_name = "command_world_rule_show",
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
		local command_world_rule_hide_terminal = {
			_name = "command_world_rule_hide",
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

		state_machine.add(command_world_rule_open_terminal)
		state_machine.add(command_world_rule_close_terminal)
		state_machine.add(command_world_rule_show_terminal)
		state_machine.add(command_world_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init secret treasure rule state machine.
	init_command_world_rule_terminal()
end

-- 对象初始化
function CommandWorldRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CommandWorldRule:onUpdateDraw()
	local root = self.roots[1]

end

function CommandWorldRule:onEnterTransitionFinish()
	-- 加载CommandWorldRuleWindow界面资源.
	-- res.activity.command_world.command_world_rule = res/activity/command_world/command_world_rule.csb
	local csbNode = csb.createNode("activity/command_world/command_world_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "command_world_rule_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CommandWorldRule:onExit()
	-- 释放CommandWorldRuleWindow界面资源.
	state_machine.remove("command_world_rule_open")
	state_machine.remove("command_world_rule_close")
	state_machine.remove("command_world_rule_show")
	state_machine.remove("command_world_rule_hide")
end

function CommandWorldRule:close()
	-- window event : close.
	
end

function CommandWorldRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
