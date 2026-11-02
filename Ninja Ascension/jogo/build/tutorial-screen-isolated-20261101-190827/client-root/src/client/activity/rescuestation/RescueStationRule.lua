--[[ ----------------------------------------------------------------------------
-- 规则
--]] ----------------------------------------------------------------------------
RescueStationRule = class("RescueStationRuleClass", Window)

-- 打开窗口
local rescue_station_rule_window_open_terminal = {
	_name = "rescue_station_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationRuleClass") then
			fwin:open(RescueStationRule:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_rule_window_close_terminal = {
	_name = "rescue_station_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_rule_window_open_terminal)
state_machine.add(rescue_station_rule_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStationRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize rescue station rule page state machine.
	local function init_rescue_station_rule_terminal()
		-- 打开角色创建窗口
		local rescue_station_rule_open_terminal = {
			_name = "rescue_station_rule_open",
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
		local rescue_station_rule_close_terminal = {
			_name = "rescue_station_rule_close",
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
		local rescue_station_rule_show_terminal = {
			_name = "rescue_station_rule_show",
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
		local rescue_station_rule_hide_terminal = {
			_name = "rescue_station_rule_hide",
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

		state_machine.add(rescue_station_rule_open_terminal)
		state_machine.add(rescue_station_rule_close_terminal)
		state_machine.add(rescue_station_rule_show_terminal)
		state_machine.add(rescue_station_rule_hide_terminal)
		state_machine.init()
	end
	-- call func init rescue station rule state machine.
	init_rescue_station_rule_terminal()
end

-- 对象初始化
function RescueStationRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RescueStationRule:onUpdateDraw()
	local root = self.roots[1]

end

function RescueStationRule:onEnterTransitionFinish()
	-- 加载RescueStationRuleWindow界面资源.
	-- res.activity.rescue_station_rule = res/activity/rescue_station_rule.csb
	local csbNode = csb.createNode("activity/rescue_station/rescue_station_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_red_rule_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_rule_close"), nil,
	{
		terminal_name = "rescue_station_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RescueStationRule:onExit()
	-- 释放RescueStationRuleWindow界面资源.
	state_machine.remove("rescue_station_rule_open")
	state_machine.remove("rescue_station_rule_close")
	state_machine.remove("rescue_station_rule_show")
	state_machine.remove("rescue_station_rule_hide")
end

function RescueStationRule:close()
	-- window event : close.
	
end

function RescueStationRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
