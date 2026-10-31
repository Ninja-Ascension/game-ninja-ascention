--[[ ----------------------------------------------------------------------------
-- 规则窗口
--]] ----------------------------------------------------------------------------
NewCGSkip = class("NewCGSkipClass", Window)

-- 打开窗口
local new_cg_skip_window_open_terminal = {
	_name = "new_cg_skip_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("NewCGSkipClass") then
			fwin:open(NewCGSkip:new():init(params), fwin._system)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local new_cg_skip_window_close_terminal = {
	_name = "new_cg_skip_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("NewCGSkipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_cg_skip_window_open_terminal)
state_machine.add(new_cg_skip_window_close_terminal)
state_machine.init()

-- 构造器
function NewCGSkip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 删除光效的回调函数
	self.deleteEffectCallback = nil

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_new_cg_skip_terminal()
		-- 打开角色创建窗口
		local new_cg_skip_open_terminal = {
			_name = "new_cg_skip_open",
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
		local new_cg_skip_close_terminal = {
			_name = "new_cg_skip_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local windowLock = fwin:find("WindowLockClass")
                if windowLock == nil then
                    fwin:open(WindowLock:new():init(), fwin._windows)
                end

				if instance ~= nil then
					if instance.deleteEffectCallback ~= nil and instance.armatureBack ~= nil then
						instance.deleteEffectCallback(instance.armatureBack)
					end

					state_machine.excute("new_cg_skip_window_close", 0, 0)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local new_cg_skip_show_terminal = {
			_name = "new_cg_skip_show",
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
		local new_cg_skip_hide_terminal = {
			_name = "new_cg_skip_hide",
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

		state_machine.add(new_cg_skip_open_terminal)
		state_machine.add(new_cg_skip_close_terminal)
		state_machine.add(new_cg_skip_show_terminal)
		state_machine.add(new_cg_skip_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_new_cg_skip_terminal()
end

-- 对象初始化
function NewCGSkip:init(params)
	self.deleteEffectCallback = params.deleteEffectCallback
	self.armatureBack = params.armatureBack
	return self
end

function NewCGSkip:onUpdateDraw()
	local root = self.roots[1]
end

function NewCGSkip:onEnterTransitionFinish()
	-- 加载NewCGSkipWindow界面资源.
	-- res.events_interpretation.new_event_cg_skip = res/events_interpretation/new_event_cg_skip.csb
	local csbNode = csb.createNode("events_interpretation/new_event_cg_skip.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	local function trigger_onTouchEvent(sender, eventType)
		local donateType = sender:getTag()
		if eventType == ccui.TouchEventType.began then
			
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			state_machine.excute("new_cg_skip_close", 0, 0)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_1"):addTouchEventListener(trigger_onTouchEvent)

	self:onUpdateDraw()
end

function NewCGSkip:onExit()
	-- 释放NewCGSkipWindow界面资源.
	state_machine.remove("new_cg_skip_open")
	state_machine.remove("new_cg_skip_close")
	state_machine.remove("new_cg_skip_show")
	state_machine.remove("new_cg_skip_hide")
end

function NewCGSkip:close()
	-- window event : close.
	
end

function NewCGSkip:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
