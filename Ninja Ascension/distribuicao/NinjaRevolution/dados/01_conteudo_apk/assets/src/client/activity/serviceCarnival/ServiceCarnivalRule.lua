--[[ ----------------------------------------------------------------------------
-- 规则
--]] ----------------------------------------------------------------------------
ServiceCarnivalRule = class("ServiceCarnivalRuleClass", Window)

-- 打开窗口
local service_carnival_rule_window_open_terminal = {
	_name = "service_carnival_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ServiceCarnivalRuleClass") then
			fwin:open(ServiceCarnivalRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local service_carnival_rule_window_close_terminal = {
	_name = "service_carnival_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ServiceCarnivalRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnival_rule_window_open_terminal)
state_machine.add(service_carnival_rule_window_close_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize service carnival rule page state machine.
	local function init_service_carnival_rule_terminal()
		-- 打开角色创建窗口
		local service_carnival_rule_open_terminal = {
			_name = "service_carnival_rule_open",
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
		local service_carnival_rule_close_terminal = {
			_name = "service_carnival_rule_close",
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
		local service_carnival_rule_show_terminal = {
			_name = "service_carnival_rule_show",
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
		local service_carnival_rule_hide_terminal = {
			_name = "service_carnival_rule_hide",
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

		state_machine.add(service_carnival_rule_open_terminal)
		state_machine.add(service_carnival_rule_close_terminal)
		state_machine.add(service_carnival_rule_show_terminal)
		state_machine.add(service_carnival_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init service carnival rule state machine.
	init_service_carnival_rule_terminal()
end

-- 对象初始化
function ServiceCarnivalRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ServiceCarnivalRule:onUpdateDraw()
	local root = self.roots[1]

end

function ServiceCarnivalRule:onEnterTransitionFinish()
	-- 加载ServiceCarnivalRuleWindow界面资源.
	-- res.activity.service_carnival.service_carnival_rule = res/activity/service_carnival/service_carnival_rule.csb
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "service_carnival_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ServiceCarnivalRule:onExit()
	-- 释放ServiceCarnivalRuleWindow界面资源.
	state_machine.remove("service_carnival_rule_open")
	state_machine.remove("service_carnival_rule_close")
	state_machine.remove("service_carnival_rule_show")
	state_machine.remove("service_carnival_rule_hide")
end

function ServiceCarnivalRule:close()
	-- window event : close.
	
end

function ServiceCarnivalRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
