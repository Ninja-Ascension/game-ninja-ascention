--[[ ----------------------------------------------------------------------------
-- 幸运奇缘规则
--]] ----------------------------------------------------------------------------
ChristmasRomanceRule = class("ChristmasRomanceRuleClass", Window)

-- 打开窗口
local christmas_romance_rule_window_open_terminal = {
	_name = "christmas_romance_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ChristmasRomanceRuleClass") then
			fwin:open(ChristmasRomanceRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local christmas_romance_rule_window_close_terminal = {
	_name = "christmas_romance_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ChristmasRomanceRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(christmas_romance_rule_window_open_terminal)
state_machine.add(christmas_romance_rule_window_close_terminal)
state_machine.init()

-- 构造器
function ChristmasRomanceRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize christmas romance rule page state machine.
	local function init_christmas_romance_rule_terminal()
		-- 打开角色创建窗口
		local christmas_romance_rule_open_terminal = {
			_name = "christmas_romance_rule_open",
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
		local christmas_romance_rule_close_terminal = {
			_name = "christmas_romance_rule_close",
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

		-- 显示窗口
		local christmas_romance_rule_show_terminal = {
			_name = "christmas_romance_rule_show",
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
		local christmas_romance_rule_hide_terminal = {
			_name = "christmas_romance_rule_hide",
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

		state_machine.add(christmas_romance_rule_open_terminal)
		state_machine.add(christmas_romance_rule_close_terminal)
		state_machine.add(christmas_romance_rule_show_terminal)
		state_machine.add(christmas_romance_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init christmas romance rule state machine.
	init_christmas_romance_rule_terminal()
end

-- 对象初始化
function ChristmasRomanceRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ChristmasRomanceRule:onUpdateDraw()
	local root = self.roots[1]

end

function ChristmasRomanceRule:onEnterTransitionFinish()
	-- 加载ChristmasRomanceRuleWindow界面资源.
	-- res.activity.christmas_romance.christmas_romance_rule = res/activity/christmas_romance/christmas_romance_rule.csb
	local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "christmas_romance_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ChristmasRomanceRule:onExit()
	-- 释放ChristmasRomanceRuleWindow界面资源.
	state_machine.remove("christmas_romance_rule_open")
	state_machine.remove("christmas_romance_rule_close")
	state_machine.remove("christmas_romance_rule_show")
	state_machine.remove("christmas_romance_rule_hide")
end

function ChristmasRomanceRule:close()
	-- window event : close.
	
end

function ChristmasRomanceRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
