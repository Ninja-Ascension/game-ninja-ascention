--[[ ----------------------------------------------------------------------------
-- 规则窗口
--]] ----------------------------------------------------------------------------
MythicalAnimalsRule = class("MythicalAnimalsRuleClass", Window)

-- 打开窗口
local mythical_animals_rule_window_open_terminal = {
	_name = "mythical_animals_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsRuleClass") then
			fwin:open(MythicalAnimalsRule:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_rule_window_close_terminal = {
	_name = "mythical_animals_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_rule_window_open_terminal)
state_machine.add(mythical_animals_rule_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_rule_terminal()
		-- 打开角色创建窗口
		local mythical_animals_rule_open_terminal = {
			_name = "mythical_animals_rule_open",
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
		local mythical_animals_rule_close_terminal = {
			_name = "mythical_animals_rule_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_rule_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_rule_show_terminal = {
			_name = "mythical_animals_rule_show",
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
		local mythical_animals_rule_hide_terminal = {
			_name = "mythical_animals_rule_hide",
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

		state_machine.add(mythical_animals_rule_open_terminal)
		state_machine.add(mythical_animals_rule_close_terminal)
		state_machine.add(mythical_animals_rule_show_terminal)
		state_machine.add(mythical_animals_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_rule_terminal()
end

-- 对象初始化
function MythicalAnimalsRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsRule:onUpdateDraw()
	local root = self.roots[1]

end

function MythicalAnimalsRule:onEnterTransitionFinish()
	-- 加载MythicalAnimalsRuleWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_rule = res/cultivate/Mythical_animals/mythical_animals_rule.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_rule_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule_closed"), nil,
	{
		terminal_name = "mythical_animals_rule_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function MythicalAnimalsRule:onExit()
	-- 释放MythicalAnimalsRuleWindow界面资源.
	state_machine.remove("mythical_animals_rule_open")
	state_machine.remove("mythical_animals_rule_close")
	state_machine.remove("mythical_animals_rule_show")
	state_machine.remove("mythical_animals_rule_hide")
end

function MythicalAnimalsRule:close()
	-- window event : close.
	
end

function MythicalAnimalsRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
