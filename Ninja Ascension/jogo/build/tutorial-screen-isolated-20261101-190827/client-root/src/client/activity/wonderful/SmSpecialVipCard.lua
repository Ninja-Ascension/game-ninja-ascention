--[[ ----------------------------------------------------------------------------
-- 特权卡的界面
--]] ----------------------------------------------------------------------------
SmSpecialVipCard = class("SmSpecialVipCardClass", Window)

-- 打开窗口
local sm_special_vip_card_window_open_terminal = {
	_name = "sm_special_vip_card_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmSpecialVipCardClass") then
			fwin:open(SmSpecialVipCard:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_special_vip_card_window_close_terminal = {
	_name = "sm_special_vip_card_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmSpecialVipCardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_special_vip_card_window_open_terminal)
state_machine.add(sm_special_vip_card_window_close_terminal)
state_machine.init()

-- 构造器
function SmSpecialVipCard:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0

	-- 活动数据信息
	self._info = {}
	self._extraInfo = {}
	self._endTime = nil
	self._activityEndTime = nil

	-- load lua files.
	app.load("client.activity.wonderful.SmSpecialVipCardPreview")
	app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.reward.DrawRareReward")
    app.load("client.cells.prop.prop_money_icon")

	-- Initialize sm special vip card page state machine.
	local function init_sm_special_vip_card_terminal()
		-- 打开角色创建窗口
		local sm_special_vip_card_open_terminal = {
			_name = "sm_special_vip_card_open",
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
		local sm_special_vip_card_close_terminal = {
			_name = "sm_special_vip_card_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:close(fwin:find("SmSpecialVipCardClass"))
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local sm_special_vip_card_show_terminal = {
			_name = "sm_special_vip_card_show",
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
		local sm_special_vip_card_hide_terminal = {
			_name = "sm_special_vip_card_hide",
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

		-- 去充值/领取奖励
		local sm_special_vip_card_sure_terminal = {
			_name = "sm_special_vip_card_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 去充值
				local isBuyCard = instance._extraInfo.isBuyCard
				if isBuyCard == 0 then
					local rechargeDimond = dms.string(dms["top_up_goods"], tonumber(instance._extraInfo.rechargeMoneyStall), top_up_goods.game_money)
                    local function reCallback()
                        state_machine.excute("shortcut_open_recharge_window", 0, "")
						state_machine.excute("sm_special_vip_card_close", 0, "")
                    end
                    app.load("client.shop.recharge.RechargeVoucher")
                    RechargeVoucher.getCanUseVoucher({recharge_dimond = rechargeDimond},reCallback)
				else
					-- 调领取协议
					local function responseGetRewardListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							-- 已领奖
							instance._extraInfo.isGetFirstReward = 1
							-- 领取完刷新界面
							instance:onUpdateDraw()
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 163)
						end
					end
					NetworkManager:register(protocol_command.privilege_card_get_reward.code, nil, nil, nil, instance, responseGetRewardListCallback, false, nil)
				end

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开奖励预览
		local sm_special_vip_card_open_reward_preview_terminal = {
			_name = "sm_special_vip_card_open_reward_preview",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("sm_special_vip_card_preview_window_open", 0, "")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(sm_special_vip_card_open_terminal)
		state_machine.add(sm_special_vip_card_close_terminal)
		state_machine.add(sm_special_vip_card_show_terminal)
		state_machine.add(sm_special_vip_card_hide_terminal)
		state_machine.add(sm_special_vip_card_sure_terminal)
		state_machine.add(sm_special_vip_card_open_reward_preview_terminal)
		state_machine.init()
	end
	-- call func init sm special vip card state machine.
	init_sm_special_vip_card_terminal()
end

-- 对象初始化
function SmSpecialVipCard:init(params)
	self._info = _ED.active_activity[163]
	self._extraInfo	= _ED.active_activity[163].info
	self._endTime = self._extraInfo.end_time
	self._activityEndTime = self._info.end_time
	return self
end

function SmSpecialVipCard:onUpdateDraw()
	local root = self.roots[1]

	-- 特权规则列表
	self.ListView_tequan_rule = ccui.Helper:seekWidgetByName(root, "ListView_tequan_rule")

	-- 首次购买奖励容器
	self.ListView_tequan_scgm = ccui.Helper:seekWidgetByName(root, "ListView_tequan_scgm")

	-- 每日奖励容器
	self.ListView_tequan_mrjl = ccui.Helper:seekWidgetByName(root, "ListView_tequan_mrjl")

	-- 花费金额
	self.Image_jq = ccui.Helper:seekWidgetByName(root, "Image_jq")

	-- 特权剩余时间
	self.Text_tequan_time_1 = ccui.Helper:seekWidgetByName(root, "Text_tequan_time_1")

	self.Text_tequan_time_t = ccui.Helper:seekWidgetByName(root, "Text_tequan_time_t")

	-- 活动剩余时间
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

	-- 奖励列表
	self:drawFirstRewardList()

	self:drawDailyRewardList()

	-- 按钮文本
	self:updateRewardBtnText()

	-- 按钮状态
	self:updateRewardBtnState()

	-- 倒计时
	-- 未购买特权卡
	if self._endTime == nil then
		self.Text_tequan_time_t:setVisible(false)
		self.Text_tequan_time_1:setVisible(false)
	else
		self.Text_tequan_time_t:setVisible(true)
		self.Text_tequan_time_1:setVisible(true)
	end

	self:updateRemainTime()
	self:updateActivityRemainTime()
end

function SmSpecialVipCard:drawFirstRewardList()
	local ListView_tequan_scgm = self.ListView_tequan_scgm

	ListView_tequan_scgm:removeAllItems()

	local firstBuyReward = zstring.splits(self._extraInfo.firstBuyReward, "|", ",")

	for _, v in pairs(firstBuyReward) do
		local cell = self:addResourcesIconCell(v)
		ListView_tequan_scgm:addChild(cell)
	end

	ListView_tequan_scgm:jumpToLeft()
	ListView_tequan_scgm:requestRefreshView()
end

function SmSpecialVipCard:drawDailyRewardList()
	local ListView_tequan_mrjl = self.ListView_tequan_mrjl

	ListView_tequan_mrjl:removeAllItems()

	local everyDayReward = zstring.splits(self._extraInfo.everyDayReward, "|", ",")

	for _, v in pairs(everyDayReward) do
		local cell = self:addResourcesIconCell(v)
		ListView_tequan_mrjl:addChild(cell)
	end

	ListView_tequan_mrjl:jumpToLeft()
	ListView_tequan_mrjl:requestRefreshView()
end

function SmSpecialVipCard:addResourcesIconCell(propData)
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

function SmSpecialVipCard:updateRewardBtnText()
	-- 充值 领取 已领取
	local btnImg = self.Image_jq
	local imgIndex = dms.string(dms["top_up_goods"], tonumber(self._extraInfo.rechargeMoneyStall), top_up_goods.game_money)
	btnImg:loadTexture(string.format("images/ui/text/sm_hd/sm_special_%s.png", imgIndex))
	
	local isBuyCard = self._extraInfo.isBuyCard
	local isGetFirstReward = self._extraInfo.isGetFirstReward
	if isBuyCard > 0 then
		if isGetFirstReward == 0 then
			btnImg:loadTexture("images/ui/text/sm_hd/sm_special_lq.png")
		else
			btnImg:loadTexture("images/ui/text/sm_hd/sm_special_ylq.png")
		end
	end
end

function SmSpecialVipCard:updateRewardBtnState()
	-- 充值 领取 / 已领取
	local btn = self.Button_jq

	local isGetReward = self._extraInfo.isGetFirstReward
	if isGetReward > 0 then
		btn:setBright(false)
		btn:setTouchEnabled(false)
	else
		btn:setBright(true)
		btn:setTouchEnabled(true)
	end
end

function SmSpecialVipCard:updateRemainTime()
	if self.Text_tequan_time_1 == nil or self._endTime == nil then
		return
	end
	local surplus_time = (self._endTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_tequan_time_1:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function SmSpecialVipCard:updateActivityRemainTime()
	if self.Text_2 == nil or self._activityEndTime == nil then
		return
	end
	local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_2:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function SmSpecialVipCard:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateRemainTime()
		self:updateActivityRemainTime()
		self.totalTime = 0
	end
end

function SmSpecialVipCard:drawTime(_time)
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

function SmSpecialVipCard:onEnterTransitionFinish()
	-- 加载SmSpecialVipCardWindow界面资源.
	-- res.activity.wonderful.sm_special_vip_card = res/activity/wonderful/sm_special_vip_card.csb
	local csbNode = csb.createNode("activity/wonderful/sm_special_vip_card.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 花费金额
	self.Button_jq = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jq"), nil,
	{
		terminal_name = "sm_special_vip_card_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 奖励预览
	self.Button_preview = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_preview"), nil,
	{
		terminal_name = "sm_special_vip_card_open_reward_preview",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "sm_special_vip_card_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SmSpecialVipCard:onExit()
	-- 释放SmSpecialVipCardWindow界面资源.
	state_machine.remove("sm_special_vip_card_open")
	state_machine.remove("sm_special_vip_card_close")
	state_machine.remove("sm_special_vip_card_show")
	state_machine.remove("sm_special_vip_card_hide")
	state_machine.remove("sm_special_vip_card_sure")
	state_machine.remove("sm_special_vip_card_open_reward_preview")
end

function SmSpecialVipCard:close()
	-- window event : close.
	
end

function SmSpecialVipCard:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
