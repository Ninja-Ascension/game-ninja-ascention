--[[ ----------------------------------------------------------------------------
-- 规则窗口
--]] ----------------------------------------------------------------------------
SummerDrinkRule = class("SummerDrinkRuleClass", Window)

-- 打开窗口
local summer_drink_rule_window_open_terminal = {
	_name = "summer_drink_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SummerDrinkRuleClass") then
			fwin:open(SummerDrinkRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local summer_drink_rule_window_close_terminal = {
	_name = "summer_drink_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SummerDrinkRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(summer_drink_rule_window_open_terminal)
state_machine.add(summer_drink_rule_window_close_terminal)
state_machine.init()

-- 构造器
function SummerDrinkRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_summer_drink_rule_terminal()
		-- 打开角色创建窗口
		local summer_drink_rule_open_terminal = {
			_name = "summer_drink_rule_open",
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
		local summer_drink_rule_close_terminal = {
			_name = "summer_drink_rule_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("summer_drink_rule_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local summer_drink_rule_show_terminal = {
			_name = "summer_drink_rule_show",
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
		local summer_drink_rule_hide_terminal = {
			_name = "summer_drink_rule_hide",
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

		state_machine.add(summer_drink_rule_open_terminal)
		state_machine.add(summer_drink_rule_close_terminal)
		state_machine.add(summer_drink_rule_show_terminal)
		state_machine.add(summer_drink_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_summer_drink_rule_terminal()
end

-- 对象初始化
function SummerDrinkRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SummerDrinkRule:onUpdateDraw()
	local root = self.roots[1]

end

function SummerDrinkRule:onEnterTransitionFinish()
	-- 加载SummerDrinkRuleWindow界面资源.
	-- res.activity.summer_drink.summer_drink_rule = res/activity/summer_drink/summer_drink_rule.csb
	local csbNode = csb.createNode("activity/summer_drink/summer_drink_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "summer_drink_rule_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SummerDrinkRule:onExit()
	-- 释放SummerDrinkRuleWindow界面资源.
	state_machine.remove("summer_drink_rule_open")
	state_machine.remove("summer_drink_rule_close")
	state_machine.remove("summer_drink_rule_show")
	state_machine.remove("summer_drink_rule_hide")
end

function SummerDrinkRule:close()
	-- window event : close.
	
end

function SummerDrinkRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
