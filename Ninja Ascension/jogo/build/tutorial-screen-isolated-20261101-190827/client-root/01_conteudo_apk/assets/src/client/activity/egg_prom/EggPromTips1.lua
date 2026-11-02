--[[ ----------------------------------------------------------------------------
-- 购买确认提示
--]] ----------------------------------------------------------------------------
EggPromTips1 = class("EggPromTips1Class", Window)

-- 打开窗口
local egg_prom_tips1_window_open_terminal = {
	_name = "egg_prom_tips1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("EggPromTips1Class") then
			fwin:open(EggPromTips1:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local egg_prom_tips1_window_close_terminal = {
	_name = "egg_prom_tips1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggPromTips1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_tips1_window_open_terminal)
state_machine.add(egg_prom_tips1_window_close_terminal)
state_machine.init()

-- 构造器
function EggPromTips1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.cost_gold_num = 0

	-- load lua files.

	-- Initialize egg prom tips1 page state machine.
	local function init_egg_prom_tips1_terminal()
		-- 打开角色创建窗口
		local egg_prom_tips1_open_terminal = {
			_name = "egg_prom_tips1_open",
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
		local egg_prom_tips1_close_terminal = {
			_name = "egg_prom_tips1_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("egg_prom_tips1_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local egg_prom_tips1_show_terminal = {
			_name = "egg_prom_tips1_show",
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
		local egg_prom_tips1_hide_terminal = {
			_name = "egg_prom_tips1_hide",
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

		-- 确认购买
		local egg_prom_tips1_sure_terminal = {
			_name = "egg_prom_tips1_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							-- 刷新红点
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 171)
							-- 刷新界面
							state_machine.excute("egg_prom_refresh", 0, nil)
							
							state_machine.excute("egg_prom_to_get_close", 0, nil)
							state_machine.excute("egg_prom_tips1_close", 0, nil)
						end
					end
					-- 金币购买道具
					protocol_command.egg_frenzy_bug_prop.param_list = "" .. instance.select_num
					NetworkManager:register(protocol_command.egg_frenzy_bug_prop.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(egg_prom_tips1_open_terminal)
		state_machine.add(egg_prom_tips1_close_terminal)
		state_machine.add(egg_prom_tips1_show_terminal)
		state_machine.add(egg_prom_tips1_hide_terminal)
		state_machine.add(egg_prom_tips1_sure_terminal)
		state_machine.init()
	end
	-- call func init egg prom tips1 state machine.
	init_egg_prom_tips1_terminal()
end

-- 对象初始化
function EggPromTips1:init(params)
	self.cost_gold_num = params[1]
	self.select_num = params[2]
	return self
end

function EggPromTips1:updateUI()
	self.Text_gold_n:setString(self.cost_gold_num)
end

function EggPromTips1:onUpdateDraw()
	local root = self.roots[1]

	-- 花费金币数
	self.Text_gold_n = ccui.Helper:seekWidgetByName(root, "Text_gold_n")

	self:updateUI()
end

function EggPromTips1:onEnterTransitionFinish()
	-- 加载EggPromTips1Window界面资源.
	-- res.activity.egg_prom.egg_prom_tips_1 = res/activity/egg_prom/egg_prom_tips_1.csb
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_tips_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 购买
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil,
	{
		terminal_name = "egg_prom_tips1_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 取消
	self.Button_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil,
	{
		terminal_name = "egg_prom_tips1_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "egg_prom_tips1_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function EggPromTips1:onExit()
	-- 释放EggPromTips1Window界面资源.
	state_machine.remove("egg_prom_tips1_open")
	state_machine.remove("egg_prom_tips1_close")
	state_machine.remove("egg_prom_tips1_show")
	state_machine.remove("egg_prom_tips1_hide")
	state_machine.remove("egg_prom_tips1_sure")
end

function EggPromTips1:close()
	-- window event : close.
	
end

function EggPromTips1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
