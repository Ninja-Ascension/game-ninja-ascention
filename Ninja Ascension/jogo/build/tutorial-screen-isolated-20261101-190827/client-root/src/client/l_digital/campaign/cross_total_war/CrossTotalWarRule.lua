--[[ ----------------------------------------------------------------------------
-- 规则
--]] ----------------------------------------------------------------------------
CrossTotalWarRule = class("CrossTotalWarRuleClass", Window)

-- 打开窗口
local cross_total_war_rule_window_open_terminal = {
	_name = "cross_total_war_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarRuleClass") then
			fwin:open(CrossTotalWarRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_rule_window_close_terminal = {
	_name = "cross_total_war_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_rule_window_open_terminal)
state_machine.add(cross_total_war_rule_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cross total war rule page state machine.
	local function init_cross_total_war_rule_terminal()
		-- 打开角色创建窗口
		local cross_total_war_rule_open_terminal = {
			_name = "cross_total_war_rule_open",
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
		local cross_total_war_rule_close_terminal = {
			_name = "cross_total_war_rule_close",
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
		local cross_total_war_rule_show_terminal = {
			_name = "cross_total_war_rule_show",
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
		local cross_total_war_rule_hide_terminal = {
			_name = "cross_total_war_rule_hide",
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

		state_machine.add(cross_total_war_rule_open_terminal)
		state_machine.add(cross_total_war_rule_close_terminal)
		state_machine.add(cross_total_war_rule_show_terminal)
		state_machine.add(cross_total_war_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war rule state machine.
	init_cross_total_war_rule_terminal()
end

-- 对象初始化
function CrossTotalWarRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CrossTotalWarRule:onUpdateDraw()
	local root = self.roots[1]

	-- 规则列表
	self.ListView_rule = ccui.Helper:seekWidgetByName(root, "ListView_rule")

end

function CrossTotalWarRule:onEnterTransitionFinish()
	-- 加载CrossTotalWarRuleWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_rule = res/campaign/cross_total_war/cross_total_war_rule.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "cross_total_war_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CrossTotalWarRule:onExit()
	-- 释放CrossTotalWarRuleWindow界面资源.
	state_machine.remove("cross_total_war_rule_open")
	state_machine.remove("cross_total_war_rule_close")
	state_machine.remove("cross_total_war_rule_show")
	state_machine.remove("cross_total_war_rule_hide")
end

function CrossTotalWarRule:close()
	-- window event : close.
	
end

function CrossTotalWarRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
