--[[ ----------------------------------------------------------------------------
-- 夏日酷饮主界面
--]] ----------------------------------------------------------------------------
SummerDrink = class("SummerDrinkClass", Window)

-- 打开窗口
local summer_drink_window_open_terminal = {
	_name = "summer_drink_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SummerDrinkClass") then
			fwin:open(SummerDrink:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local summer_drink_window_close_terminal = {
	_name = "summer_drink_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SummerDrinkClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(summer_drink_window_open_terminal)
state_machine.add(summer_drink_window_close_terminal)
state_machine.init()

-- 构造器
function SummerDrink:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0

	self._activityEndTime = nil

	-- load lua files.
	app.load("client.activity.summer_drink.summerdrinkcell")
	app.load("client.activity.summer_drink.summerdrinkcell_0")
	app.load("client.activity.summer_drink.SummerDrinkHandle")
	app.load("client.activity.summer_drink.SummerDrinkReward")
	app.load("client.activity.summer_drink.SummerDrinkRule")
	app.load("client.activity.summer_drink.SummerDrinkTask")

	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")

	-- Initialize summer drink page state machine.
	local function init_summer_drink_terminal()
		-- 打开角色创建窗口
		local summer_drink_open_terminal = {
			_name = "summer_drink_open",
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
		local summer_drink_close_terminal = {
			_name = "summer_drink_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("summer_drink_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local summer_drink_show_terminal = {
			_name = "summer_drink_show",
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
		local summer_drink_hide_terminal = {
			_name = "summer_drink_hide",
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

		-- 规则
		local summer_drink_open_rule_terminal = {
			_name = "summer_drink_open_rule",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("summer_drink_rule_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 最终大奖
		local summer_drink_open_final_reward_terminal = {
			_name = "summer_drink_open_final_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local index = 24
				local state = SummerDrinkHandle.getTaskRewardState(index)
				-- 如果最终大奖可领取
				if state == 1 then
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							-- 刷新界面以及外部icon红点
							state_machine.excute("summer_drink_refresh_ui", 0, nil)
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 172)
						end
					end
					protocol_command.summer_cool_weal_get_reward.param_list = "" .. (index - 1)
					NetworkManager:register(protocol_command.summer_cool_weal_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				else
					state_machine.excute("summer_drink_reward_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面
		local summer_drink_refresh_ui_terminal = {
			_name = "summer_drink_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:onInit()
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(summer_drink_open_terminal)
		state_machine.add(summer_drink_close_terminal)
		state_machine.add(summer_drink_show_terminal)
		state_machine.add(summer_drink_hide_terminal)
		state_machine.add(summer_drink_open_rule_terminal)
		state_machine.add(summer_drink_open_final_reward_terminal)
		state_machine.add(summer_drink_refresh_ui_terminal)
		state_machine.init()
	end
	-- call func init summer drink state machine.
	init_summer_drink_terminal()
end

-- 对象初始化
function SummerDrink:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SummerDrink:onInit()
	-- 重置活动数据
	SummerDrinkHandle.restoreSummerDrinkData()
	SummerDrinkHandle.handleActivityData()
	SummerDrinkHandle.handleActivityRewardData()

	self._activityEndTime = _ED.active_activity[172].end_time
end

function SummerDrink:updateUI()
	self:updateIce()
	self:updateBox()
	self:updateIceNumberImage()
	self:showFinalRewardButtonEffect()
	self:updateActivityRemainTime()
end

function SummerDrink:updateIce()
	local showIcePanel = {}

	local Panel_ice_widget = self.Panel_ice_widget
	for i, v in ipairs(Panel_ice_widget) do
		v:removeAllChildren(true)

		if SummerDrinkHandle.getTaskRewardState(i) ~= 2 then
			local cell = state_machine.excute("summer_drink_cell_create", 0, i)
			v:addChild(cell)
		end
	end
end

function SummerDrink:updateBox()
	local Panel_box_widget = self.Panel_box_widget
	for i, v in ipairs(Panel_box_widget) do
		v:removeAllChildren(true)

		local cell = state_machine.excute("summer_drink_cell0_create", 0, i)
		v:addChild(cell)
	end
end

function SummerDrink:updateIceNumberImage()
	local Image_ice_widget = self.Image_ice_widget
	for i, v in ipairs(Image_ice_widget) do
		if SummerDrinkHandle.getTaskRewardState(i) == 2 then
			v:setVisible(false)
		else
			v:setVisible(true)
		end
	end
end

function SummerDrink:showFinalRewardButtonEffect()
	local Panel_reward_effect = self.Panel_reward_effect
	Panel_reward_effect:removeAllChildren(true)

	local state = SummerDrinkHandle.getTaskRewardState(24)
	if state == 1 then
		self.Image_reward:setVisible(false)

		local jsonFile = "images/ui/effice/effect_summer_drink/effect_summer_drink.json"
		local atlasFile = "images/ui/effice/effect_summer_drink/effect_summer_drink.atlas"

		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation5", true, nil)
		animation:setPosition(cc.p(Panel_reward_effect:getContentSize().width/2, Panel_reward_effect:getContentSize().height/2))
		Panel_reward_effect:addChild(animation)
	else
		self.Image_reward:setVisible(true)
	end
end

-- 倒计时
function SummerDrink:updateActivityRemainTime()
	if self.Text_time == nil or self._activityEndTime == nil then
		return
	end
	local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function SummerDrink:onUpdateDraw()
	local root = self.roots[1]

	-- 任务显示容器
	self.Panel_ice = ccui.Helper:seekWidgetByName(root, "Panel_ice")

	-- 倒计时
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	-- 冰块任务
	self.Panel_ice_widget = {}
	for i = 1, 15 do
		local widget = ccui.Helper:seekWidgetByName(root, "Panel_ice_"..i)
		table.insert(self.Panel_ice_widget, widget)
	end

	-- 数字底图
	self.Image_ice_widget = {}
	for i = 1, 15 do
		local widget = ccui.Helper:seekWidgetByName(root, "Image_ice_"..i)
		table.insert(self.Image_ice_widget, widget)
	end

	-- 行列任务
	self.Panel_box_widget = {}
	for i = 1, 8 do
		local widget = ccui.Helper:seekWidgetByName(root, "Panel_box_"..i)
		table.insert(self.Panel_box_widget, widget)
	end

	-- 最终大奖按钮光效
	self.Panel_reward_effect = ccui.Helper:seekWidgetByName(root, "Panel_reward_effect")

	-- 最终大奖按钮图片
	self.Image_reward = ccui.Helper:seekWidgetByName(root, "Image_reward")

	self:updateUI()
end

function SummerDrink:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateActivityRemainTime()
		self.totalTime = 0
	end
end

function SummerDrink:drawTime(_time)
	local timeString = ""
	local _dayTime = math.floor((_time / 1000) / 86400)
	local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
	local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
	local _secondsTime = math.floor((_time / 1000) % 60)
	if _dayTime > 0 then
		timeString = timeString .. _dayTime .._string_piece_info[231]
	end
	if _hourTime < 10 then
		timeString = timeString .. "0".._hourTime ..":"
	else
		timeString = timeString .. _hourTime ..":"
	end

	if _minutesTime < 10 then
		timeString = timeString .. "0".._minutesTime ..":"
	else
		timeString = timeString .. _minutesTime ..":"
	end

	if _secondsTime < 10 then
		timeString = timeString .. "0".._secondsTime 
	else
		timeString = timeString .. _secondsTime 
	end
	return timeString
end

function SummerDrink:onEnterTransitionFinish()
	-- 加载SummerDrinkWindow界面资源.
	-- res.activity.summer_drink.summer_drink = res/activity/summer_drink/summer_drink.csb
	local csbNode = csb.createNode("activity/summer_drink/summer_drink.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 规则按钮
	self.Button_task = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task"), nil,
	{
		terminal_name = "summer_drink_open_rule",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 最终奖励按钮
	self.Button_reward = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward"), nil,
	{
		terminal_name = "summer_drink_open_final_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "summer_drink_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SummerDrink:onExit()
	-- 释放SummerDrinkWindow界面资源.
	state_machine.remove("summer_drink_open")
	state_machine.remove("summer_drink_close")
	state_machine.remove("summer_drink_show")
	state_machine.remove("summer_drink_hide")
	state_machine.remove("summer_drink_open_rule")
	state_machine.remove("summer_drink_open_final_reward")
	state_machine.remove("summer_drink_refresh_ui")
end

function SummerDrink:close()
	-- window event : close.
	
end

function SummerDrink:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
