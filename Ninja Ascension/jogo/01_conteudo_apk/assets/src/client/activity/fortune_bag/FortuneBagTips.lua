--[[ ----------------------------------------------------------------------------
-- 提示界面
--]] ----------------------------------------------------------------------------
FortuneBagTips = class("FortuneBagTipsClass", Window)

-- 打开窗口
local fortune_bag_tips_window_open_terminal = {
	_name = "fortune_bag_tips_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("FortuneRecruitOneClass") ~= nil then
			fwin:close(fwin:find("FortuneRecruitOneClass"))
		end

		if fwin:find("FortuneRecruitTenClass") ~= nil then
			fwin:close(fwin:find("FortuneRecruitTenClass"))
		end
		if nil == fwin:find("FortuneBagTipsClass") then
			fwin:open(FortuneBagTips:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fortune_bag_tips_window_close_terminal = {
	_name = "fortune_bag_tips_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FortuneBagTipsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_tips_window_open_terminal)
state_machine.add(fortune_bag_tips_window_close_terminal)
state_machine.init()

-- 构造器
function FortuneBagTips:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fortune bag tips page state machine.
	local function init_fortune_bag_tips_terminal()
		-- 打开角色创建窗口
		local fortune_bag_tips_open_terminal = {
			_name = "fortune_bag_tips_open",
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
		local fortune_bag_tips_close_terminal = {
			_name = "fortune_bag_tips_close",
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
		local fortune_bag_tips_show_terminal = {
			_name = "fortune_bag_tips_show",
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
		local fortune_bag_tips_hide_terminal = {
			_name = "fortune_bag_tips_hide",
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

		-- 跳转特惠礼包
		local fortune_bag_tips_jump_windows_terminal = {
			_name = "fortune_bag_tips_jump_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)

				if fwin:find("FortuneRecruitOneClass") ~= nil then
					fwin:close(fwin:find("FortuneRecruitOneClass"))
				end

				if fwin:find("FortuneRecruitTenClass") ~= nil then
					fwin:close(fwin:find("FortuneRecruitTenClass"))
				end

				if _ED.active_activity[152] ~= nil then
					app.load("client.activity.wonderful.ActivitySingleRecharge")
					state_machine.excute("activity_single_recharge_window_open", 0, 152)
				elseif _ED.active_activity[145] ~= nil then
					app.load("client.l_digital.activity.wonderful.SmRechargeReturnRewardNew")
					state_machine.excute("sm_recharge_return_reward_new_open", 0, 145)
				else
					state_machine.excute("shortcut_open_recharge_window", 0, "")
				end
				
				state_machine.excute("fortune_bag_tips_window_close", 0, 0)
				state_machine.excute("fortune_bag_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fortune_bag_tips_open_terminal)
		state_machine.add(fortune_bag_tips_close_terminal)
		state_machine.add(fortune_bag_tips_show_terminal)
		state_machine.add(fortune_bag_tips_hide_terminal)
		state_machine.add(fortune_bag_tips_jump_windows_terminal)
		state_machine.init()
	end
	-- call func init fortune bag tips state machine.
	init_fortune_bag_tips_terminal()
end

-- 对象初始化
function FortuneBagTips:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FortuneBagTips:onUpdateDraw()
	local root = self.roots[1]

end

function FortuneBagTips:onEnterTransitionFinish()
	-- 加载FortuneBagTipsWindow界面资源.
	-- res.activity.fortune_bag.fortune_bag_tips = res/activity/fortune_bag/fortune_bag_tips.csb
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag_tips.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 点击跳转进入特惠礼包界面
	self.Button_to_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_to_get"), nil,
	{
		terminal_name = "fortune_bag_tips_jump_windows",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 点击关闭按钮返回活动主界面
	self.Button_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil,
	{
		terminal_name = "fortune_bag_tips_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fortune_bag_tips_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function FortuneBagTips:onExit()
	-- 释放FortuneBagTipsWindow界面资源.
	state_machine.remove("fortune_bag_tips_open")
	state_machine.remove("fortune_bag_tips_close")
	state_machine.remove("fortune_bag_tips_show")
	state_machine.remove("fortune_bag_tips_hide")
end

function FortuneBagTips:close()
	-- window event : close.
	
end

function FortuneBagTips:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
