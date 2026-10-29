--[[ ----------------------------------------------------------------------------
-- 祈福规则
--]] ----------------------------------------------------------------------------
PrayActivityRule = class("PrayActivityRuleClass", Window)

-- 打开窗口
local pray_activity_rule_window_open_terminal = {
	_name = "pray_activity_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("PrayActivityRuleClass") then
			fwin:open(PrayActivityRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local pray_activity_rule_window_close_terminal = {
	_name = "pray_activity_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("PrayActivityRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(pray_activity_rule_window_open_terminal)
state_machine.add(pray_activity_rule_window_close_terminal)
state_machine.init()

-- 构造器
function PrayActivityRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize pray activity rule page state machine.
	local function init_pray_activity_rule_terminal()
		-- 打开角色创建窗口
		local pray_activity_rule_open_terminal = {
			_name = "pray_activity_rule_open",
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
		local pray_activity_rule_close_terminal = {
			_name = "pray_activity_rule_close",
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
		local pray_activity_rule_show_terminal = {
			_name = "pray_activity_rule_show",
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
		local pray_activity_rule_hide_terminal = {
			_name = "pray_activity_rule_hide",
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

		state_machine.add(pray_activity_rule_open_terminal)
		state_machine.add(pray_activity_rule_close_terminal)
		state_machine.add(pray_activity_rule_show_terminal)
		state_machine.add(pray_activity_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init pray activity rule state machine.
	init_pray_activity_rule_terminal()
end

-- 对象初始化
function PrayActivityRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function PrayActivityRule:onUpdateDraw()
	local root = self.roots[1]

	-- 规则显示滚动容器
	self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")

	-- 规则文本框
	self.Text_rule = ccui.Helper:seekWidgetByName(root, "Text_rule")

end

function PrayActivityRule:onEnterTransitionFinish()
	-- 加载PrayActivityRuleWindow界面资源.
	-- res.activity.Pray.Pray_rule = res/activity/Pray/Pray_rule.csb
	local csbNode = csb.createNode("activity/Pray/Pray_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 弹窗关闭按钮
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "pray_activity_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function PrayActivityRule:onExit()
	-- 释放PrayActivityRuleWindow界面资源.
	state_machine.remove("pray_activity_rule_open")
	state_machine.remove("pray_activity_rule_close")
	state_machine.remove("pray_activity_rule_show")
	state_machine.remove("pray_activity_rule_hide")
end

function PrayActivityRule:close()
	-- window event : close.
	
end

function PrayActivityRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
