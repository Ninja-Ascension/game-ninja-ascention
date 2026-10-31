--[[ ----------------------------------------------------------------------------
-- 主页列表项
--]] ----------------------------------------------------------------------------
PrivateCustomList = class("PrivateCustomListClass", Window)
PrivateCustomList.__size = nil

-- 创建Cell实例
local private_custom_list_create_terminal = {
	_name = "private_custom_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if PrivateCustomList then
			local cell = PrivateCustomList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(private_custom_list_create_terminal)
state_machine.init()

-- 构造器
function PrivateCustomList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._needControlWidget = {}
	self._info = nil

	-- load lua files.

	-- Initialize private custom list page state machine.
	local function init_private_custom_list_terminal()
		-- 跳转充值
		local private_custom_list_go_to_recharge_terminal = {
			_name = "private_custom_list_go_to_recharge",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local rechargeDimond = params._datas.info.gear
				local function reCallback()
					state_machine.excute("private_custom_jump_recharge", 0, nil)
				end
				app.load("client.shop.recharge.RechargeVoucher")
				RechargeVoucher.getCanUseVoucher({recharge_dimond = rechargeDimond},reCallback)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 领取奖励
		local private_custom_list_get_reward_terminal = {
			_name = "private_custom_list_get_reward",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local info = params._datas.info
					-- 判断可选奖励是否都选完
					local allSelected = instance:judgeOptionalRewardHaveSelected(info)

					if allSelected == true then
						state_machine.excute("private_custom_prompt_window_open", 0, {gear = info.gear})
					else
						TipDlg.drawTextDailog(tipStringInfo_activity_private_custom[1])
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(private_custom_list_go_to_recharge_terminal)
		state_machine.add(private_custom_list_get_reward_terminal)
	end
	-- call func init private custom list state machine.
	init_private_custom_list_terminal()
end

-- 对象初始化
function PrivateCustomList:init(params)
	self._info = params

	self:onInit(params)
	self:setContentSize(PrivateCustomList.__size)
	return self
end

function PrivateCustomList:updateUI()
    local rewardState = tonumber(self._info.state)
	
	self:hideButtonWidget()

	-- 未充值 0，可领取 1，已领取 2
	self:showButtonWidget(rewardState)

	local rechargeCoin = tonumber(self._info.gear)
	self.Text_11:setString(string.format(tipStringInfo_activity_private_custom[2], rechargeCoin))

	local haveRewardTimes = tonumber(self._info.finished)
	local maxRewardTimes = tonumber(self._info.canFinish)

	self.Text_13:setString((maxRewardTimes - haveRewardTimes) .. "/" .. maxRewardTimes)
	if rewardState == 2 then
		self.Text_13:setVisible(false)
	end

	self:updateList()
end

function PrivateCustomList:hideButtonWidget()
	for _, v in pairs(self._needControlWidget) do
		v:setVisible(false)
	end
end

function PrivateCustomList:showButtonWidget(rewardState)
	local widget = self._needControlWidget[rewardState]
	widget:setVisible(true)
end

function PrivateCustomList:updateList()
	local sortInfo = self:getPropSortInfo()

	self.ListView_item:removeAllItems()

	-- 如果都领完了 点击加号就不用弹出选择信息了
	local rewardState = tonumber(self._info.state)

	-- 每个档位奖励的数量
	local fixedRewardNum = self:getFixedRewardNum()
	local totalNum = fixedRewardNum + self:getOptionalRewardNum()

	for i = 1, totalNum do
		local info = sortInfo[i]
		local canClickItem = i > fixedRewardNum
		if rewardState == 2 then
			canClickItem = false
		end
		local cell = state_machine.excute("private_custom_item_create", 0, {info = info, buttonType = 1, index = i, canClickItem = canClickItem, gear = self._info.gear})
		self.ListView_item:addChild(cell)
	end

	self.ListView_item:requestRefreshView()
end

function PrivateCustomList:getPropSortInfo()
	local info = self._info

	local rewards = {}

	local fixedReward = zstring.splits(info.fixedReward, "|", ",")
	local optionalReward = zstring.splits(info.optionalReward, "|", ",")

	for _, v in pairs(fixedReward) do
		if v[1] and v[1] ~= "" then
			table.insert(rewards, v)
		end
	end

	for _, v in pairs(optionalReward) do
		table.insert(rewards, v)
	end

	return rewards
end

function PrivateCustomList:getFixedRewardNum()
	local info = self._info
	local fixedReward = zstring.splits(info.fixedReward, "|", ",")
	local length = info.fixedReward == "" and 0 or table.nums(fixedReward)

	return length
end

function PrivateCustomList:getOptionalRewardNum()
	local info = self._info
	local optionalReward = zstring.splits(info.optionalReward, "|", ",")
	local length = info.optionalReward == "" and 0 or table.nums(optionalReward)

	return length
end

function PrivateCustomList:judgeOptionalRewardHaveSelected(info)
	local allSelected = true
	local optionalReward = zstring.splits(info.optionalReward, "|", ",")
	for _, v in pairs(optionalReward) do
		if v == nil or tonumber(v[1]) <= 0 then
			allSelected = false
			break
		end
	end
	return allSelected
end

function PrivateCustomList:onUpdateDraw()
	local root = self.roots[1]

	-- 标题/项名称
	self.Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")

	-- 次数
	self.Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")

	-- 已领取，默认隐藏
	self.Image_collected = ccui.Helper:seekWidgetByName(root, "Image_collected")

	-- 奖励道具列表
	self.ListView_item = ccui.Helper:seekWidgetByName(root, "ListView_item")

	-- 需要控制显示隐藏的控件
	self._needControlWidget = {[0] = self.Button_charge, [1] = self.Button_collect, [2] = self.Image_collected}

	self:updateUI()
end

function PrivateCustomList:onEnterTransitionFinish()
	
end

function PrivateCustomList:onInit(params)
	-- 加载PrivateCustomListWindow界面资源.
	-- res.activity.private_custom.private_custom_list = res/activity/private_custom/private_custom_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/private_custom/private_custom_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/private_custom/private_custom_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if PrivateCustomList.__size == nil then
		PrivateCustomList.__size = root:getContentSize()
	end

	-- 储值
	self.Button_charge = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_charge"), nil,
	{
		terminal_name = "private_custom_list_go_to_recharge",
		terminal_state = 0,
		isPressedActionEnabled = true,
		info = self._info
	}, nil, 0)	

	-- 领取
	self.Button_collect = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collect"), nil,
	{
		terminal_name = "private_custom_list_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		info = self._info
	}, nil, 0)	

	self:onUpdateDraw()
end

function PrivateCustomList:onExit()
	-- 释放PrivateCustomListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/private_custom/private_custom_list.csb", root)
	-- ]]
end

function PrivateCustomList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PrivateCustomList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/private_custom/private_custom_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
