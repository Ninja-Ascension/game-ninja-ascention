--[[ ----------------------------------------------------------------------------
-- 规则页面
--]] ----------------------------------------------------------------------------
EggPromRule = class("EggPromRuleClass", Window)

-- 打开窗口
local egg_prom_rule_window_open_terminal = {
	_name = "egg_prom_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("EggPromRuleClass") then
			fwin:open(EggPromRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local egg_prom_rule_window_close_terminal = {
	_name = "egg_prom_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggPromRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_rule_window_open_terminal)
state_machine.add(egg_prom_rule_window_close_terminal)
state_machine.init()

-- 构造器
function EggPromRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize egg prom rule page state machine.
	local function init_egg_prom_rule_terminal()
		-- 打开角色创建窗口
		local egg_prom_rule_open_terminal = {
			_name = "egg_prom_rule_open",
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
		local egg_prom_rule_close_terminal = {
			_name = "egg_prom_rule_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("egg_prom_rule_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local egg_prom_rule_show_terminal = {
			_name = "egg_prom_rule_show",
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
		local egg_prom_rule_hide_terminal = {
			_name = "egg_prom_rule_hide",
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

		state_machine.add(egg_prom_rule_open_terminal)
		state_machine.add(egg_prom_rule_close_terminal)
		state_machine.add(egg_prom_rule_show_terminal)
		state_machine.add(egg_prom_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init egg prom rule state machine.
	init_egg_prom_rule_terminal()
end

-- 对象初始化
function EggPromRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function EggPromRule:onUpdateDraw()
	local root = self.roots[1]

end

function EggPromRule:onEnterTransitionFinish()
	-- 加载EggPromRuleWindow界面资源.
	-- res.activity.egg_prom.egg_prom_rule = res/activity/egg_prom/egg_prom_rule.csb
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "egg_prom_rule_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function EggPromRule:onExit()
	-- 释放EggPromRuleWindow界面资源.
	state_machine.remove("egg_prom_rule_open")
	state_machine.remove("egg_prom_rule_close")
	state_machine.remove("egg_prom_rule_show")
	state_machine.remove("egg_prom_rule_hide")
end

function EggPromRule:close()
	-- window event : close.
	
end

function EggPromRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
