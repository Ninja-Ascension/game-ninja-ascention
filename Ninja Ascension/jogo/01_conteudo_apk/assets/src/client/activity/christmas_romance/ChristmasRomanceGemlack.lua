--[[ ----------------------------------------------------------------------------
-- 钻石不足确认框
--]] ----------------------------------------------------------------------------
ChristmasRomanceGemlack = class("ChristmasRomanceGemlackClass", Window)

-- 打开窗口
local christmas_romance_gemlack_window_open_terminal = {
	_name = "christmas_romance_gemlack_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ChristmasRomanceGemlackClass") then
			fwin:open(ChristmasRomanceGemlack:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local christmas_romance_gemlack_window_close_terminal = {
	_name = "christmas_romance_gemlack_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ChristmasRomanceGemlackClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(christmas_romance_gemlack_window_open_terminal)
state_machine.add(christmas_romance_gemlack_window_close_terminal)
state_machine.init()

-- 构造器
function ChristmasRomanceGemlack:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize christmas romance gemlack page state machine.
	local function init_christmas_romance_gemlack_terminal()
		-- 打开角色创建窗口
		local christmas_romance_gemlack_open_terminal = {
			_name = "christmas_romance_gemlack_open",
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
		local christmas_romance_gemlack_close_terminal = {
			_name = "christmas_romance_gemlack_close",
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
		local christmas_romance_gemlack_show_terminal = {
			_name = "christmas_romance_gemlack_show",
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
		local christmas_romance_gemlack_hide_terminal = {
			_name = "christmas_romance_gemlack_hide",
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

		-- 跳转充值
		local christmas_romance_gemlack_jump_top_terminal = {
			_name = "christmas_romance_gemlack_jump_top",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 提示跳转充值
				state_machine.excute("shortcut_open_recharge_window", 0, "")
				state_machine.excute("christmas_romance_gemlack_window_close", 0, "")
				state_machine.excute("christmas_romance_window_close", 0, "")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(christmas_romance_gemlack_open_terminal)
		state_machine.add(christmas_romance_gemlack_close_terminal)
		state_machine.add(christmas_romance_gemlack_show_terminal)
		state_machine.add(christmas_romance_gemlack_hide_terminal)
		state_machine.add(christmas_romance_gemlack_jump_top_terminal)

		
		state_machine.init()
	end
	-- call func init christmas romance gemlack state machine.
	init_christmas_romance_gemlack_terminal()
end

-- 对象初始化
function ChristmasRomanceGemlack:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ChristmasRomanceGemlack:onUpdateDraw()
	local root = self.roots[1]
	self.Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
	self.Text_tip:setVisible(false)
end

function ChristmasRomanceGemlack:onEnterTransitionFinish()
	-- 加载ChristmasRomanceGemlackWindow界面资源.
	-- res.activity.christmas_romance.christmas_romance_gemlack = res/activity/christmas_romance/christmas_romance_gemlack.csb
	local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_gemlack.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 取消
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "christmas_romance_gemlack_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 前往
	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "christmas_romance_gemlack_jump_top",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "christmas_romance_gemlack_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ChristmasRomanceGemlack:onExit()
	-- 释放ChristmasRomanceGemlackWindow界面资源.
	state_machine.remove("christmas_romance_gemlack_open")
	state_machine.remove("christmas_romance_gemlack_close")
	state_machine.remove("christmas_romance_gemlack_show")
	state_machine.remove("christmas_romance_gemlack_hide")
	state_machine.remove("christmas_romance_gemlack_jump_top")

	
end

function ChristmasRomanceGemlack:close()
	-- window event : close.
	
end

function ChristmasRomanceGemlack:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
