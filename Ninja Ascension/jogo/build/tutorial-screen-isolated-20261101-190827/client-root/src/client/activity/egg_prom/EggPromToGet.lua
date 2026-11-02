--[[ ----------------------------------------------------------------------------
-- 购买道具
--]] ----------------------------------------------------------------------------
EggPromToGet = class("EggPromToGetClass", Window)

-- 打开窗口
local egg_prom_to_get_window_open_terminal = {
	_name = "egg_prom_to_get_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("EggPromToGetClass") then
			fwin:open(EggPromToGet:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local egg_prom_to_get_window_close_terminal = {
	_name = "egg_prom_to_get_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggPromToGetClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_to_get_window_open_terminal)
state_machine.add(egg_prom_to_get_window_close_terminal)
state_machine.init()

-- 构造器
function EggPromToGet:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._select_num = 0
	self._max_select_num = 0
	self._remainTimes = 0

	-- load lua files.

	-- Initialize egg prom tips2 page state machine.
	local function init_egg_prom_to_get_terminal()
		-- 打开角色创建窗口
		local egg_prom_to_get_open_terminal = {
			_name = "egg_prom_to_get_open",
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
		local egg_prom_to_get_close_terminal = {
			_name = "egg_prom_to_get_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("egg_prom_to_get_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local egg_prom_to_get_show_terminal = {
			_name = "egg_prom_to_get_show",
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
		local egg_prom_to_get_hide_terminal = {
			_name = "egg_prom_to_get_hide",
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

		-- 设置最小
		local egg_prom_to_get_set_min_terminal = {
			_name = "egg_prom_to_get_set_min",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				 instance:setSelectNum(1)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 设置最大
		local egg_prom_to_get_set_max_terminal = {
			_name = "egg_prom_to_get_set_max",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				 instance:setSelectNum(self._max_select_num)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 购买道具
		local egg_prom_to_get_prop_terminal = {
			_name = "egg_prom_to_get_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 购买道具数量
				local select_num = instance._select_num
				local unit_price = instance._unit_price
				local remainTimes = instance._remainTimes

				if remainTimes <= 0 then
					TipDlg.drawTextDailog(tipStringInfo_activity_egg_dance[1])
					return true
				end

				local totalPrice = unit_price * select_num
				if totalPrice > tonumber(_ED.user_info.user_gold) then
					TipDlg.drawTextDailog(tipStringInfo_activity_egg_dance[2])
					return true
				end

				state_machine.excute("egg_prom_tips1_window_open", 0 , {totalPrice, select_num})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 拖动滑动条
		local egg_prom_to_get_use_update_terminal = {
			_name = "egg_prom_to_get_use_update",
			_init = function (terminal) 

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local Slider_number_xz = instance.Slider_number_xz
				local select_num = math.ceil(tonumber(Slider_number_xz:getPercent()) * instance._max_select_num / 100)
				instance:setSelectNum(select_num)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(egg_prom_to_get_open_terminal)
		state_machine.add(egg_prom_to_get_close_terminal)
		state_machine.add(egg_prom_to_get_show_terminal)
		state_machine.add(egg_prom_to_get_hide_terminal)
		state_machine.add(egg_prom_to_get_set_min_terminal)
		state_machine.add(egg_prom_to_get_set_max_terminal)
		state_machine.add(egg_prom_to_get_prop_terminal)
		state_machine.add(egg_prom_to_get_use_update_terminal)
		state_machine.init()
	end
	-- call func init egg prom tips2 state machine.
	init_egg_prom_to_get_terminal()
end

-- 对象初始化
function EggPromToGet:init(params)
	local activityData = _ED.active_activity[171]
	local eggPromData = activityData.eggPromData
	self._remainTimes = tonumber(eggPromData.buyPropRemainNumber)

	-- 购买一个道具所需要的金币
	self._unit_price = tonumber(eggPromData.buyPropCostGold)
	self._max_select_num = self:getMaxSelectNum()
	return self
end

function EggPromToGet:getMaxSelectNum()
	return self._remainTimes
end

function EggPromToGet:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end
    local percent = math.floor(self._select_num / self._max_select_num*100)
    self:updateSliderInfo(percent)
end

function EggPromToGet:updateSliderInfo(percent)
	if self._max_select_num > 0 and self._select_num == 0 then
		self._select_num = 1
	end
	self.Slider_number_xz:setPercent(percent)
	-- 数量
	local Text_quantity = self.Text_quantity
	Text_quantity:setString(self._select_num.."/"..self._max_select_num)
	-- 限购为0 隐藏控件
	if self._max_select_num == 0 then
		Text_quantity:setVisible(false)
	end

	-- 总价
	local Text_packs_sell_price_n = self.Text_packs_sell_price_n
	local totalPrice = self._unit_price * self._select_num
	if tonumber(totalPrice) > 1000000 then
		Text_packs_sell_price_n:setString(math.floor(totalPrice / 1000) .. string_equiprety_name[40])
	else
		Text_packs_sell_price_n:setString(totalPrice)
	end
end

function EggPromToGet:updateUI()
	local Text_packs_sell_n = self.Text_packs_sell_n
	Text_packs_sell_n:setString(self._remainTimes)

	-- 滑动选择
	local Slider_number_xz = self.Slider_number_xz
	local function percentChangedEvent(sender,eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			state_machine.excute("egg_prom_to_get_use_update", 0, {sender:getPercent()})
		end
	end
	Slider_number_xz:addEventListener(percentChangedEvent)
end

function EggPromToGet:onUpdateDraw()
	local root = self.roots[1]

	-- 限购数
	self.Text_packs_sell_n = ccui.Helper:seekWidgetByName(root, "Text_packs_sell_n")

	-- 当前购买进度
	self.Text_quantity = ccui.Helper:seekWidgetByName(root, "Text_quantity")

	-- 售价
	self.Text_packs_sell_price_n = ccui.Helper:seekWidgetByName(root, "Text_packs_sell_price_n")

	-- 可拖动进度条
	self.Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")

	self:setSelectNum(1)
	self:updateUI()
end

function EggPromToGet:onEnterTransitionFinish()
	-- 加载EggPromToGetWindow界面资源.
	-- res.activity.egg_prom.egg_prom_to_get = res/activity/egg_prom/egg_prom_to_get.csb
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_to_get.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 最小个数
	self.Button_min = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_min"), nil,
	{
		terminal_name = "egg_prom_to_get_set_min",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 最大个数
	self.Button_max = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_max"), nil,
	{
		terminal_name = "egg_prom_to_get_set_max",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 购买
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil,
	{
		terminal_name = "egg_prom_to_get_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "egg_prom_to_get_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function EggPromToGet:onExit()
	-- 释放EggPromToGetWindow界面资源.
	state_machine.remove("egg_prom_to_get_open")
	state_machine.remove("egg_prom_to_get_close")
	state_machine.remove("egg_prom_to_get_show")
	state_machine.remove("egg_prom_to_get_hide")
	state_machine.remove("egg_prom_to_get_set_min")
	state_machine.remove("egg_prom_to_get_set_max")
	state_machine.remove("egg_prom_to_get_prop")
	state_machine.remove("egg_prom_to_get_use_update")
end

function EggPromToGet:close()
	-- window event : close.
	
end

function EggPromToGet:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
