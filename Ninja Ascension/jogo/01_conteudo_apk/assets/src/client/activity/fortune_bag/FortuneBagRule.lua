--[[ ----------------------------------------------------------------------------
-- 提示界面
--]] ----------------------------------------------------------------------------
FortuneBagRule = class("FortuneBagRuleClass", Window)

-- 打开窗口
local fortune_bag_rule_window_open_terminal = {
	_name = "fortune_bag_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FortuneBagRuleClass") then
			fwin:open(FortuneBagRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fortune_bag_rule_window_close_terminal = {
	_name = "fortune_bag_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FortuneBagRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_rule_window_open_terminal)
state_machine.add(fortune_bag_rule_window_close_terminal)
state_machine.init()

-- 构造器
function FortuneBagRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fortune bag rule page state machine.
	local function init_fortune_bag_rule_terminal()
		-- 打开角色创建窗口
		local fortune_bag_rule_open_terminal = {
			_name = "fortune_bag_rule_open",
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
		local fortune_bag_rule_close_terminal = {
			_name = "fortune_bag_rule_close",
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
		local fortune_bag_rule_show_terminal = {
			_name = "fortune_bag_rule_show",
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
		local fortune_bag_rule_hide_terminal = {
			_name = "fortune_bag_rule_hide",
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

		state_machine.add(fortune_bag_rule_open_terminal)
		state_machine.add(fortune_bag_rule_close_terminal)
		state_machine.add(fortune_bag_rule_show_terminal)
		state_machine.add(fortune_bag_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init fortune bag rule state machine.
	init_fortune_bag_rule_terminal()
end

-- 对象初始化
function FortuneBagRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FortuneBagRule:onUpdateDraw()
	local root = self.roots[1]

	-- 规则文本
	self.Text_rule_01 = ccui.Helper:seekWidgetByName(root, "Text_rule_01")

end

function FortuneBagRule:onEnterTransitionFinish()
	-- 加载FortuneBagRuleWindow界面资源.
	-- res.activity.fortune_bag.fortune_bag_rule = res/activity/fortune_bag/fortune_bag_rule.csb
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "fortune_bag_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function FortuneBagRule:onExit()
	-- 释放FortuneBagRuleWindow界面资源.
	state_machine.remove("fortune_bag_rule_open")
	state_machine.remove("fortune_bag_rule_close")
	state_machine.remove("fortune_bag_rule_show")
	state_machine.remove("fortune_bag_rule_hide")
end

function FortuneBagRule:close()
	-- window event : close.
	
end

function FortuneBagRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
