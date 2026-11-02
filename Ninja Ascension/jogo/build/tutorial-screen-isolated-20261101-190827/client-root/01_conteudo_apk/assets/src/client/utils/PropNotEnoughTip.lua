--[[ ----------------------------------------------------------------------------
-- 道具不足弹窗，点击跳转到不同界面和功能
--]] ----------------------------------------------------------------------------
PropNotEnoughTip = class("PropNotEnoughTipClass", Window)

-- 打开窗口
local prop_not_enough_tip_window_open_terminal = {
	_name = "prop_not_enough_tip_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("PropNotEnoughTipClass") then
			fwin:open(PropNotEnoughTip:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local prop_not_enough_tip_window_close_terminal = {
	_name = "prop_not_enough_tip_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("PropNotEnoughTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(prop_not_enough_tip_window_open_terminal)
state_machine.add(prop_not_enough_tip_window_close_terminal)
state_machine.init()

-- 构造器
function PropNotEnoughTip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize egg prom tips1 page state machine.
	local function init_prop_not_enough_tip_terminal()
		-- 打开角色创建窗口
		local prop_not_enough_tip_open_terminal = {
			_name = "prop_not_enough_tip_open",
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
		local prop_not_enough_tip_close_terminal = {
			_name = "prop_not_enough_tip_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("prop_not_enough_tip_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local prop_not_enough_tip_show_terminal = {
			_name = "prop_not_enough_tip_show",
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
		local prop_not_enough_tip_hide_terminal = {
			_name = "prop_not_enough_tip_hide",
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

		-- 前往
		local prop_not_enough_tip_buy_prop_terminal = {
			_name = "prop_not_enough_tip_buy_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					if instance._openWindowTerminalName ~= nil then
						state_machine.excute(instance._openWindowTerminalName, 0, instance._openWindowTerminalParams)
					end

					if instance._needCloseWindowTerminalName ~= nil then
						state_machine.excute(instance._needCloseWindowTerminalName, 0, instance._needCloseWindowTerminalParams)
					end

					state_machine.excute("prop_not_enough_tip_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(prop_not_enough_tip_open_terminal)
		state_machine.add(prop_not_enough_tip_close_terminal)
		state_machine.add(prop_not_enough_tip_show_terminal)
		state_machine.add(prop_not_enough_tip_hide_terminal)
		state_machine.add(prop_not_enough_tip_buy_prop_terminal)
		state_machine.init()
	end
	-- call func init egg prom tips1 state machine.
	init_prop_not_enough_tip_terminal()
end

-- 对象初始化
function PropNotEnoughTip:init(params)
	-- 点击确定按钮 需要打开的界面
	self._openWindowTerminalName = params.openWindowTerminalName
	self._openWindowTerminalParams = params.openWindowTerminalParams
	-- 点击确定按钮 需要关闭的界面
	self._needCloseWindowTerminalName = params.needCloseWindowTerminalName
	self._needCloseWindowTerminalParams = params.needCloseWindowTerminalParams

	return self
end

function PropNotEnoughTip:onUpdateDraw()
	local root = self.roots[1]

end

function PropNotEnoughTip:onEnterTransitionFinish()
	-- 加载PropNotEnoughTipWindow界面资源.
	-- res.activity.egg_prom.egg_prom_tips_2 = res/activity/egg_prom/egg_prom_tips_2.csb
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_tips_2.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 购买
	self.Button_to_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_to_get"), nil,
	{
		terminal_name = "prop_not_enough_tip_buy_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消
	self.Button_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil,
	{
		terminal_name = "prop_not_enough_tip_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "prop_not_enough_tip_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function PropNotEnoughTip:onExit()
	-- 释放PropNotEnoughTipWindow界面资源.
	state_machine.remove("prop_not_enough_tip_open")
	state_machine.remove("prop_not_enough_tip_close")
	state_machine.remove("prop_not_enough_tip_show")
	state_machine.remove("prop_not_enough_tip_hide")
	state_machine.remove("prop_not_enough_tip_buy_prop")
end

function PropNotEnoughTip:close()
	-- window event : close.
	
end

function PropNotEnoughTip:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
