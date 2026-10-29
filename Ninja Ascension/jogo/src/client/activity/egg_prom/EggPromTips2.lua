--[[ ----------------------------------------------------------------------------
-- 道具不足弹窗
--]] ----------------------------------------------------------------------------
EggPromTips2 = class("EggPromTips2Class", Window)

-- 打开窗口
local egg_prom_tips2_window_open_terminal = {
	_name = "egg_prom_tips2_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("EggPromTips2Class") then
			fwin:open(EggPromTips2:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local egg_prom_tips2_window_close_terminal = {
	_name = "egg_prom_tips2_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggPromTips2Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_tips2_window_open_terminal)
state_machine.add(egg_prom_tips2_window_close_terminal)
state_machine.init()

-- 构造器
function EggPromTips2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize egg prom tips1 page state machine.
	local function init_egg_prom_tips2_terminal()
		-- 打开角色创建窗口
		local egg_prom_tips2_open_terminal = {
			_name = "egg_prom_tips2_open",
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
		local egg_prom_tips2_close_terminal = {
			_name = "egg_prom_tips2_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("egg_prom_tips2_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local egg_prom_tips2_show_terminal = {
			_name = "egg_prom_tips2_show",
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
		local egg_prom_tips2_hide_terminal = {
			_name = "egg_prom_tips2_hide",
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

		-- 前往(跳转特惠礼包)
		local egg_prom_tips2_buy_prop_terminal = {
			_name = "egg_prom_tips2_buy_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					if _ED.active_activity[152] ~= nil then
						app.load("client.activity.wonderful.ActivitySingleRecharge")
						state_machine.excute("activity_single_recharge_window_open", 0, 152)
					else
						state_machine.excute("shortcut_open_recharge_window", 0, "")
					end

					state_machine.excute("egg_prom_tips2_close", 0, nil)
					state_machine.excute("egg_prom_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(egg_prom_tips2_open_terminal)
		state_machine.add(egg_prom_tips2_close_terminal)
		state_machine.add(egg_prom_tips2_show_terminal)
		state_machine.add(egg_prom_tips2_hide_terminal)
		state_machine.add(egg_prom_tips2_buy_prop_terminal)
		state_machine.init()
	end
	-- call func init egg prom tips1 state machine.
	init_egg_prom_tips2_terminal()
end

-- 对象初始化
function EggPromTips2:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function EggPromTips2:onUpdateDraw()
	local root = self.roots[1]

end

function EggPromTips2:onEnterTransitionFinish()
	-- 加载EggPromTips2Window界面资源.
	-- res.activity.egg_prom.egg_prom_tips_2 = res/activity/egg_prom/egg_prom_tips_2.csb
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_tips_2.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 购买
	self.Button_to_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_to_get"), nil,
	{
		terminal_name = "egg_prom_tips2_buy_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消
	self.Button_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil,
	{
		terminal_name = "egg_prom_tips2_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "egg_prom_tips2_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function EggPromTips2:onExit()
	-- 释放EggPromTips2Window界面资源.
	state_machine.remove("egg_prom_tips2_open")
	state_machine.remove("egg_prom_tips2_close")
	state_machine.remove("egg_prom_tips2_show")
	state_machine.remove("egg_prom_tips2_hide")
	state_machine.remove("egg_prom_tips2_buy_prop")
end

function EggPromTips2:close()
	-- window event : close.
	
end

function EggPromTips2:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
