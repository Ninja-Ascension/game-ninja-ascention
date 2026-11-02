
--[[ ----------------------------------------------------------------------------
-- 忍具说明
--]] ----------------------------------------------------------------------------
Silkbaghelp = class("SilkbaghelpClass", Window)

-- 打开窗口
local silkbaghelp_window_open_terminal = {
	_name = "silkbaghelp_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		
        if nil == fwin:find("SilkbaghelpClass") then
			fwin:open(Silkbaghelp:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local silkbaghelp_window_close_terminal = {
	_name = "silkbaghelp_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SilkbaghelpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(silkbaghelp_window_open_terminal)
state_machine.add(silkbaghelp_window_close_terminal)
state_machine.init()

-- 构造器
function Silkbaghelp:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	-- var

	-- load lua files.

	-- Initialize silkbaghelp page state machine.
	local function init_silkbaghelp_terminal()
		-- 打开角色创建窗口
		local silkbaghelp_open_terminal = {
			_name = "silkbaghelp_open",
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
		local silkbaghelp_close_terminal = {
			_name = "silkbaghelp_close",
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
		local silkbaghelp_show_terminal = {
			_name = "silkbaghelp_show",
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
		local silkbaghelp_hide_terminal = {
			_name = "silkbaghelp_hide",
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

		state_machine.add(silkbaghelp_open_terminal)
		state_machine.add(silkbaghelp_close_terminal)
		state_machine.add(silkbaghelp_show_terminal)
		state_machine.add(silkbaghelp_hide_terminal)
		state_machine.init()
	end
	-- call func init silkbaghelp state machine.
	init_silkbaghelp_terminal()
end

-- 对象初始化
function Silkbaghelp:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function Silkbaghelp:onUpdateDraw()
	local root = self.roots[1]

end

function Silkbaghelp:onEnterTransitionFinish()
	-- 加载SilkbaghelpWindow界面资源.
	-- res.cultivate.silk_bag_help = res/cultivate/silk_bag_help.csb
	local csbNode = csb.createNode("cultivate/silk_bag_help.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "silkbaghelp_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function Silkbaghelp:onExit()
	-- 释放SilkbaghelpWindow界面资源.
	state_machine.remove("silkbaghelp_open")
	state_machine.remove("silkbaghelp_close")
	state_machine.remove("silkbaghelp_show")
	state_machine.remove("silkbaghelp_hide")
end

function Silkbaghelp:close()
	-- window event : close.
	
end

function Silkbaghelp:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
