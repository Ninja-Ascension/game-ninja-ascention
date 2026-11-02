--[[ ----------------------------------------------------------------------------
-- 圣诞卷兑换确认框
--]] ----------------------------------------------------------------------------
ChristmasRomanceExchangeTip = class("ChristmasRomanceExchangeTipClass", Window)

-- 打开窗口
local christmas_romance_exchange_tip_window_open_terminal = {
	_name = "christmas_romance_exchange_tip_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ChristmasRomanceExchangeTipClass") then
			fwin:open(ChristmasRomanceExchangeTip:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local christmas_romance_exchange_tip_window_close_terminal = {
	_name = "christmas_romance_exchange_tip_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ChristmasRomanceExchangeTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(christmas_romance_exchange_tip_window_open_terminal)
state_machine.add(christmas_romance_exchange_tip_window_close_terminal)
state_machine.init()

-- 构造器
function ChristmasRomanceExchangeTip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._infos = nil
	-- load lua files.

	-- Initialize christmas romance exchange tip page state machine.
	local function init_christmas_romance_exchange_tip_terminal()
		-- 打开角色创建窗口
		local christmas_romance_exchange_tip_open_terminal = {
			_name = "christmas_romance_exchange_tip_open",
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
		local christmas_romance_exchange_tip_close_terminal = {
			_name = "christmas_romance_exchange_tip_close",
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
		local christmas_romance_exchange_tip_show_terminal = {
			_name = "christmas_romance_exchange_tip_show",
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
		local christmas_romance_exchange_tip_hide_terminal = {
			_name = "christmas_romance_exchange_tip_hide",
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

		-- 兑换
		local christmas_romance_exchange_tip_exchange_click_terminal = {
			_name = "christmas_romance_exchange_tip_exchange_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params then 
					state_machine.lock("christmas_romance_exchange_tip_exchange_click")
					local mInfos = params._datas.m_infos
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								app.load("client.reward.DrawRareReward")
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								fwin:open(getRewardWnd, fwin._ui)
								-- 刷新商店
								state_machine.excute("christmas_romance_shop_refrush",0,"")
								state_machine.excute("christmas_romance_top_info_refresh_prop_count", 0, nil)
								state_machine.excute("christmas_romance_exchange_tip_window_close",0,"")
							end
							state_machine.unlock("christmas_romance_exchange_tip_exchange_click")
						else
							state_machine.unlock("christmas_romance_exchange_tip_exchange_click")
						end
					end
					
					protocol_command.lucky_turntable_buy_prop.param_list = mInfos._type .. "\r\n" .. mInfos._infos.id .."\r\n".. "1"
					NetworkManager:register(protocol_command.lucky_turntable_buy_prop.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(christmas_romance_exchange_tip_open_terminal)
		state_machine.add(christmas_romance_exchange_tip_close_terminal)
		state_machine.add(christmas_romance_exchange_tip_show_terminal)
		state_machine.add(christmas_romance_exchange_tip_hide_terminal)
		state_machine.add(christmas_romance_exchange_tip_exchange_click_terminal)
		state_machine.init()
	end
	-- call func init christmas romance exchange tip state machine.
	init_christmas_romance_exchange_tip_terminal()
end

-- 对象初始化
function ChristmasRomanceExchangeTip:init(params)
	self._infos = params[1]
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ChristmasRomanceExchangeTip:onUpdateDraw()
	local root = self.roots[1]

	-- 消耗圣诞兑换卷数量
	self.Text_cost_number = ccui.Helper:seekWidgetByName(root, "Text_cost_number")
	self.Text_cost_number:setString(self._infos.prop.sale_percentage)
end

function ChristmasRomanceExchangeTip:onEnterTransitionFinish()
	-- 加载ChristmasRomanceExchangeTipWindow界面资源.
	-- res.activity.christmas_romance.christmas_romance_exchange_tip = res/activity/christmas_romance/christmas_romance_exchange_tip.csb
	local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_exchange_tip.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 取消
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "christmas_romance_exchange_tip_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 确认兑换
	self.Button_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil,
	{
		terminal_name = "christmas_romance_exchange_tip_exchange_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_infos = self._infos,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "christmas_romance_exchange_tip_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ChristmasRomanceExchangeTip:onExit()
	-- 释放ChristmasRomanceExchangeTipWindow界面资源.
	state_machine.remove("christmas_romance_exchange_tip_open")
	state_machine.remove("christmas_romance_exchange_tip_close")
	state_machine.remove("christmas_romance_exchange_tip_show")
	state_machine.remove("christmas_romance_exchange_tip_hide")
	state_machine.remove("christmas_romance_exchange_tip_exchange_click")
end

function ChristmasRomanceExchangeTip:close()
	-- window event : close.
	
end

function ChristmasRomanceExchangeTip:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
