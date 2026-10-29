--[[ ----------------------------------------------------------------------------
-- 购买弹窗
--]] ----------------------------------------------------------------------------
LimPoolBuy = class("LimPoolBuyClass", Window)

-- 打开窗口
local lim_pool_buy_window_open_terminal = {
	_name = "lim_pool_buy_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LimPoolBuyClass") then
			fwin:open(LimPoolBuy:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local lim_pool_buy_window_close_terminal = {
	_name = "lim_pool_buy_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LimPoolBuyClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_buy_window_open_terminal)
state_machine.add(lim_pool_buy_window_close_terminal)
state_machine.init()

-- 构造器
function LimPoolBuy:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._select_num = 0
	self._max_select_num = 0
	self._remainTimes = 0

	-- load lua files.

	-- Initialize lim pool buy page state machine.
	local function init_lim_pool_buy_terminal()
		-- 打开角色创建窗口
		local lim_pool_buy_open_terminal = {
			_name = "lim_pool_buy_open",
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
		local lim_pool_buy_close_terminal = {
			_name = "lim_pool_buy_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_buy_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local lim_pool_buy_show_terminal = {
			_name = "lim_pool_buy_show",
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
		local lim_pool_buy_hide_terminal = {
			_name = "lim_pool_buy_hide",
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
		local lim_pool_buy_set_min_terminal = {
			_name = "lim_pool_buy_set_min",
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
		local lim_pool_buy_set_max_terminal = {
			_name = "lim_pool_buy_set_max",
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
		local lim_pool_buy_prop_terminal = {
			_name = "lim_pool_buy_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 购买道具数量
				local select_num = instance._select_num
				local unit_price = instance._unit_price

				if unit_price * select_num > tonumber(_ED.user_info.user_gold) then
					TipDlg.drawTextDailog(tipStringInfo_activity_limit_pool[2])
					return true
				end

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(7)
						fwin:open(getRewardWnd, fwin._ui)

						-- 刷新道具
						state_machine.excute("lim_user_top_info_refresh_prop_count", 0, 0)

						-- 刷新红点
						state_machine.excute("lim_pool_refesh_red_dot", 0, 0)
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, instance._activityType)

						state_machine.excute("lim_pool_to_get_update_windows", 0, 0)
						state_machine.excute("lim_pool_buy_close", 0, 0)
					end
				end
				-- 金币购买道具
				if instance._activityType == 168 then
					protocol_command.time_limit_jackpot_buy_prop.param_list = "" .. select_num
					NetworkManager:register(protocol_command.time_limit_jackpot_buy_prop.code, nil, nil, nil, instance, responseCallback, false, nil)
				elseif instance._activityType == 188 then
					protocol_command.cross_time_limit_jackpot_buy_prop.param_list = "" .. select_num
					NetworkManager:register(protocol_command.cross_time_limit_jackpot_buy_prop.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 拖动滑动条
		local lim_pool_buy_use_update_terminal = {
			_name = "lim_pool_buy_use_update",
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

		state_machine.add(lim_pool_buy_open_terminal)
		state_machine.add(lim_pool_buy_close_terminal)
		state_machine.add(lim_pool_buy_show_terminal)
		state_machine.add(lim_pool_buy_hide_terminal)
		state_machine.add(lim_pool_buy_set_min_terminal)
		state_machine.add(lim_pool_buy_set_max_terminal)
		state_machine.add(lim_pool_buy_prop_terminal)
		state_machine.add(lim_pool_buy_use_update_terminal)

		state_machine.init()
	end
	-- call func init lim pool buy state machine.
	init_lim_pool_buy_terminal()
end

-- 对象初始化
function LimPoolBuy:init(params)
	self._activityType = params._activityType
	self._remainTimes = params.propBuyData.remainBuyTimes

	-- 购买一个道具所需要的金币
	self._unit_price = params.propBuyData.buyPropCost
	self._max_select_num = self:getMaxSelectNum()
	return self
end

function LimPoolBuy:getMaxSelectNum()
	return self._remainTimes
end

function LimPoolBuy:setSelectNum(select_num)
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

function LimPoolBuy:updateSliderInfo(percent)
	if self._max_select_num > 0 and self._select_num == 0 then
		self._select_num = 1
	end
	self.Slider_number_xz:setPercent(percent)
	-- 数量
	local Text_packs_use_n = self.Text_packs_use_n
	Text_packs_use_n:setString(self._select_num.."/"..self._max_select_num)

	-- 总价
	local Text_price = self.Text_price
	local totalPrice = self._unit_price * self._select_num
	if tonumber(totalPrice) > 1000000 then
		Text_price:setString(math.floor(totalPrice / 1000) .. string_equiprety_name[40])
	else
		Text_price:setString(totalPrice)
	end
end

function LimPoolBuy:updateUI()
	-- 道具图标
	local Panel_packs_props_icon = self.Panel_packs_props_icon
	Panel_packs_props_icon:removeAllChildren(true)

	local propID = 0
	if self._activityType == 168 then
		propID = dms.int(dms["activity_config"], 62, activity_config.param)
	elseif self._activityType == 188 then
		propID = dms.int(dms["activity_config"], 112, activity_config.param)
	end
	local propInfo = {6, propID, 1}
	local cell = self:addResourcesIconCell(propInfo)
	Panel_packs_props_icon:addChild(cell)

	-- 道具名称
	local Text_packs_props_name = self.Text_packs_props_name
	local name = setThePropsIcon(propID)[2]
	Text_packs_props_name:setString(name)

	local quality = dms.int(dms["prop_mould"], propID, prop_mould.prop_quality) + 1
	Text_packs_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1], tipStringInfo_quality_color_Type[quality][2], tipStringInfo_quality_color_Type[quality][3]))

	-- 拥有数量
	local Text_packs = self.Text_packs
	local havePropNum = getPropAllCountByMouldId(propID)
	Text_packs:setString(havePropNum)


	--当前拥有金币数量
	local Text_own = self.Text_own
	local user_gold = _ED.user_info.user_gold

	if tonumber(user_gold) > 1000000 then
		Text_own:setString(math.floor(user_gold / 1000) .. string_equiprety_name[40])
	else
		Text_own:setString(user_gold)
	end

	-- 剩余购买次数
	local Text_frequency = self.Text_frequency
	Text_frequency:setString(self._remainTimes)

	-- 滑动选择
	local Slider_number_xz = self.Slider_number_xz
	local function percentChangedEvent(sender,eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			state_machine.excute("lim_pool_buy_use_update", 0, {sender:getPercent()})
		end
	end
	Slider_number_xz:addEventListener(percentChangedEvent)
end

function LimPoolBuy:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function LimPoolBuy:onUpdateDraw()
	local root = self.roots[1]

	-- 忍者令拥有个数
	self.Text_packs = ccui.Helper:seekWidgetByName(root, "Text_packs")

	-- 道具名
	self.Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")

	-- 购买滑动条
	self.Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")

	-- 购买数量
	self.Text_packs_use_n = ccui.Helper:seekWidgetByName(root, "Text_packs_use_n")

	-- 剩余购买次数
	self.Text_frequency = ccui.Helper:seekWidgetByName(root, "Text_frequency")

	-- 需要金币数量
	self.Text_price = ccui.Helper:seekWidgetByName(root, "Text_price")

	-- 当前金币数量
	self.Text_own = ccui.Helper:seekWidgetByName(root, "Text_own")

	-- 忍者令道具图标
	self.Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")

	self:setSelectNum(self._max_select_num)
	self:updateUI()
end

function LimPoolBuy:onEnterTransitionFinish()
	-- 加载LimPoolBuyWindow界面资源.
	-- res.activity.lim_pool.lim_pool_buy = res/activity/lim_pool/lim_pool_buy.csb
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_buy.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 最小个数
	self.Button_min = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_min"), nil,
	{
		terminal_name = "lim_pool_buy_set_min",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 最大个数
	self.Button_max = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_max"), nil,
	{
		terminal_name = "lim_pool_buy_set_max",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 购买
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil,
	{
		terminal_name = "lim_pool_buy_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "lim_pool_buy_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function LimPoolBuy:onExit()
	-- 释放LimPoolBuyWindow界面资源.
	state_machine.remove("lim_pool_buy_open")
	state_machine.remove("lim_pool_buy_close")
	state_machine.remove("lim_pool_buy_show")
	state_machine.remove("lim_pool_buy_hide")
	state_machine.remove("lim_pool_buy_set_min")
	state_machine.remove("lim_pool_buy_set_max")
	state_machine.remove("lim_pool_buy_prop")
	state_machine.remove("lim_pool_buy_use_update")
end

function LimPoolBuy:close()
	-- window event : close.
	
end

function LimPoolBuy:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
