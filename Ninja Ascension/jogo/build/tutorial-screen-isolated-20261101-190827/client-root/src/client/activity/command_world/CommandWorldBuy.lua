--[[ ----------------------------------------------------------------------------
-- 道具购买界面
--]] ----------------------------------------------------------------------------
CommandWorldBuy = class("CommandWorldBuyClass", Window)

-- 打开窗口
local command_world_buy_window_open_terminal = {
	_name = "command_world_buy_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CommandWorldBuyClass") then
			fwin:open(CommandWorldBuy:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_buy_window_close_terminal = {
	_name = "command_world_buy_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldBuyClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_buy_window_open_terminal)
state_machine.add(command_world_buy_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorldBuy:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._buyPropNum = 1

	-- load lua files.

	-- Initialize command world buy page state machine.
	local function init_command_world_buy_terminal()
		-- 打开角色创建窗口
		local command_world_buy_open_terminal = {
			_name = "command_world_buy_open",
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
		local command_world_buy_close_terminal = {
			_name = "command_world_buy_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_buy_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_buy_show_terminal = {
			_name = "command_world_buy_show",
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
		local command_world_buy_hide_terminal = {
			_name = "command_world_buy_hide",
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

		-- 道具减10
		local command_world_buy_reduce_ten_terminal = {
			_name = "command_world_buy_reduce_ten",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local tempBuyPropNum = instance._buyPropNum - 10
					if tempBuyPropNum > 0 then
						instance._buyPropNum = tempBuyPropNum
					else
						instance._buyPropNum = 1
					end
					instance:updateBuyCount()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 道具减1
		local command_world_buy_reduce_one_terminal = {
			_name = "command_world_buy_reduce_one",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local tempBuyPropNum = instance._buyPropNum - 1
					if tempBuyPropNum > 0 then
						instance._buyPropNum = tempBuyPropNum
						instance:updateBuyCount()
					else
						TipDlg.drawTextDailog(tipStringInfo_command_world[8])
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 道具加10
		local command_world_buy_add_ten_terminal = {
			_name = "command_world_buy_add_ten",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					if instance._remainTimes > 0 then
						local tempBuyPropNum = instance._buyPropNum + 10
						if tempBuyPropNum >= instance._remainTimes then
							instance._buyPropNum = instance._remainTimes
						else
							instance._buyPropNum = tempBuyPropNum
						end
						instance:updateBuyCount()
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 道具加1
		local command_world_buy_add_one_terminal = {
			_name = "command_world_buy_add_one",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local tempBuyPropNum = instance._buyPropNum + 1
					if tempBuyPropNum <= instance._remainTimes then
						instance._buyPropNum = tempBuyPropNum
						instance:updateBuyCount()
					else
						TipDlg.drawTextDailog(tipStringInfo_command_world[7])
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 道具可购买最大化
		local command_world_buy_set_max_terminal = {
			_name = "command_world_buy_set_max",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					if instance._remainTimes > 0 then
						instance._buyPropNum = instance._remainTimes
						instance:updateBuyCount()
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 购买
		local command_world_buy_sure_terminal = {
			_name = "command_world_buy_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local data = params._datas.data

					local exchangeType = data.exchangeType
					local index = data.index
					local buyPropNum = instance._buyPropNum

					local needProp = instance._needProp
					local havePropCount = self._havePropCount
					
					if tonumber(needProp[3]) * buyPropNum > havePropCount then
						TipDlg.drawTextDailog(tipStringInfo_command_world[9])
						return true
					end

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							-- 刷新商店
							state_machine.excute("command_world_shop_refresh_shop", 0, nil)
							-- 刷新主界面
							state_machine.excute("command_world_refresh_ui", 0, true)

							-- 刷新红点
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 174)
							-- 刷新右侧按钮红点
							state_machine.excute("command_word_update_right_red_dot", 0, nil)

							state_machine.excute("command_world_buy_close", 0, nil)
						end
					end
					protocol_command.activity_orders_world_exchange.param_list = "" .. exchangeType .. "\r\n" .. index .."\r\n" .. buyPropNum
					NetworkManager:register(protocol_command.activity_orders_world_exchange.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(command_world_buy_open_terminal)
		state_machine.add(command_world_buy_close_terminal)
		state_machine.add(command_world_buy_show_terminal)
		state_machine.add(command_world_buy_hide_terminal)
		state_machine.add(command_world_buy_sure_terminal)
		state_machine.add(command_world_buy_reduce_ten_terminal)
		state_machine.add(command_world_buy_reduce_one_terminal)
		state_machine.add(command_world_buy_add_ten_terminal)
		state_machine.add(command_world_buy_add_one_terminal)
		state_machine.add(command_world_buy_set_max_terminal)
		state_machine.init()
	end
	-- call func init command world buy state machine.
	init_command_world_buy_terminal()
end

-- 对象初始化
function CommandWorldBuy:init(params)
	self._data = params
	return self
end

-- 获得最大可购买次数
function CommandWorldBuy:getMaxBuyTimes(needPropCount, remainTimes)
	local count = self._havePropCount
	local tempTimes = math.floor(count / needPropCount)
	local maxRemainTimes = tempTimes > remainTimes and remainTimes or tempTimes
	return maxRemainTimes
end

function CommandWorldBuy:udpateUI()
	local data = self._data

	local exchangePropStr = zstring.splits(data.exchangeProp, "|", ",")
	local exchangeProp = exchangePropStr[1]

	local cell = self:addResourcesIconCell(exchangeProp)
	self.Panel_packs_props_icon:removeAllChildren(true)
	self.Panel_packs_props_icon:addChild(cell)

	local exchangePropId = tonumber(exchangeProp[2])

	local name = getItemNameAndQuality(exchangeProp)[1]
	self.Text_packs_props_name:setString(name)

	local quality = getItemNameAndQuality(exchangeProp)[2]
	self.Text_packs_props_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

	-- 所拥有商店物品数量
	local count_1 = getPropAllCountByMouldId(exchangePropId)
	self.Text_packs:setString(count_1)

	local remainTimes = tonumber(data.maxNumber) - tonumber(data.currentNumber)
	self.Text_buy:setString(remainTimes)

	-- 消耗图标的显示
	local costPropDatas = zstring.splits(dms.string(dms["activity_config"], 76, activity_config.param), "|", ",")

	local needPropStr = zstring.splits(data.needProp, "|", ",")
	local needPropType = tonumber(needPropStr[1][1])
	local needPropId = tonumber(needPropStr[1][2])
	local needPropCount = tonumber(needPropStr[1][3])

	local needProp = {needPropType, needPropId, needPropCount}

	for i, v in ipairs(self.Image) do
		if i <= 3 and tonumber(costPropDatas[i][2]) == needPropId then
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
	if needPropType == 2 then
		self.Image[4]:setVisible(true)
	end

	-- 拥有兑换道具的数量
	local count_2 = 0
	if needPropType == 2 then
		count_2 = _ED.user_info.user_gold
		-- 拥有道具数量
		self._havePropCount = tonumber(count_2)
		if tonumber(count_2) > 1000000 then
			count_2 = math.floor(count_2 / 1000) .. string_equiprety_name[40]
		end
	else
		count_2 = getPropAllCountByMouldId(needPropId)
		-- 拥有道具数量
		self._havePropCount = tonumber(count_2)
	end
	self.Text_own:setString(count_2)

	-- 所需一个兑换道具
	self._needProp = needProp
	-- 剩余次数
	self._remainTimes = self:getMaxBuyTimes(needPropCount, remainTimes)
end

function CommandWorldBuy:updateBuyCount()
	local buyPropNum = self._buyPropNum
	self.Text_packs_use_n:setString(buyPropNum)

	local unit_price = self._needProp[3]
	local totalPrice = unit_price * buyPropNum
	self.Text_price:setString(totalPrice)
end


function CommandWorldBuy:addResourcesIconCell(propData)
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

function CommandWorldBuy:onUpdateDraw()
	local root = self.roots[1]

	-- 道具图标
	self.Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")

	-- 道具名称
	self.Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")

	-- 道具持有数
	self.Text_packs_props = ccui.Helper:seekWidgetByName(root, "Text_packs_props")

	-- 道具购买数量
	self.Text_packs_use_n = ccui.Helper:seekWidgetByName(root, "Text_packs_use_n")

	self.Text_packs = ccui.Helper:seekWidgetByName(root, "Text_packs")

	self.Text_buy = ccui.Helper:seekWidgetByName(root, "Text_buy")

	self.Image_xiaren = ccui.Helper:seekWidgetByName(root, "Image_xiaren")
	self.Image_zhongren = ccui.Helper:seekWidgetByName(root, "Image_zhongren")
	self.Image_shangren = ccui.Helper:seekWidgetByName(root, "Image_shangren")
	self.Image_zuanshi = ccui.Helper:seekWidgetByName(root, "Image_zuanshi")

	self.Image = {}
	table.insert(self.Image, self.Image_xiaren)
	table.insert(self.Image, self.Image_zhongren)
	table.insert(self.Image, self.Image_shangren)
	table.insert(self.Image, self.Image_zuanshi)

	-- 道具价格
	self.Text_price = ccui.Helper:seekWidgetByName(root, "Text_price")

	-- 拥有数值
	self.Text_own = ccui.Helper:seekWidgetByName(root, "Text_own")

	-- 可购买次数
	self.Text_buy = ccui.Helper:seekWidgetByName(root, "Text_buy")

	self:udpateUI()
	self:updateBuyCount()
end

function CommandWorldBuy:onEnterTransitionFinish()
	-- 加载CommandWorldBuyWindow界面资源.
	-- res.activity.command_world.command_world_buy = res/activity/command_world/command_world_buy.csb
	local csbNode = csb.createNode("activity/command_world/command_world_buy.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 道具减十
	self.Button_minus = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_minus"), nil,
	{
		terminal_name = "command_world_buy_reduce_ten",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 道具减十
	self.Button_plus = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_plus"), nil,
	{
		terminal_name = "command_world_buy_add_ten",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 道具减一
	self.Button_jian = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jian"), nil,
	{
		terminal_name = "command_world_buy_reduce_one",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 道具加一
	self.Button_jia = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jia"), nil,
	{
		terminal_name = "command_world_buy_add_one",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 道具可购买最大化
	self.Button_max = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_max"), nil,
	{
		terminal_name = "command_world_buy_set_max",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 购买按钮
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil,
	{
		terminal_name = "command_world_buy_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
		data = self._data,
	}, nil, 0)	

	-- 取消按钮
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "command_world_buy_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "command_world_buy_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CommandWorldBuy:onExit()
	-- 释放CommandWorldBuyWindow界面资源.
	state_machine.remove("command_world_buy_open")
	state_machine.remove("command_world_buy_close")
	state_machine.remove("command_world_buy_show")
	state_machine.remove("command_world_buy_hide")
	state_machine.remove("command_world_buy_sure")
	state_machine.remove("command_world_buy_reduce_ten")
	state_machine.remove("command_world_buy_reduce_one")
	state_machine.remove("command_world_buy_add_one")
	state_machine.remove("command_world_buy_set_max")
end

function CommandWorldBuy:close()
	-- window event : close.
	
end

function CommandWorldBuy:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
