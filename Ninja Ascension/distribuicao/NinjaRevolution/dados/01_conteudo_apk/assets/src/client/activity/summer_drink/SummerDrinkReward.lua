--[[ ----------------------------------------------------------------------------
-- 最终大奖奖励预览界面
--]] ----------------------------------------------------------------------------
SummerDrinkReward = class("SummerDrinkRewardClass", Window)

-- 打开窗口
local summer_drink_reward_window_open_terminal = {
	_name = "summer_drink_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SummerDrinkRewardClass") then
			fwin:open(SummerDrinkReward:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local summer_drink_reward_window_close_terminal = {
	_name = "summer_drink_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SummerDrinkRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(summer_drink_reward_window_open_terminal)
state_machine.add(summer_drink_reward_window_close_terminal)
state_machine.init()

-- 构造器
function SummerDrinkReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.cells.prop.sm_hero_information")

	-- Initialize summer drink reward page state machine.
	local function init_summer_drink_reward_terminal()
		-- 打开角色创建窗口
		local summer_drink_reward_open_terminal = {
			_name = "summer_drink_reward_open",
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
		local summer_drink_reward_close_terminal = {
			_name = "summer_drink_reward_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("summer_drink_reward_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local summer_drink_reward_show_terminal = {
			_name = "summer_drink_reward_show",
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
		local summer_drink_reward_hide_terminal = {
			_name = "summer_drink_reward_hide",
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

		-- 查看详情
		local summer_drink_reward_hero_introduce_terminal = {
			_name = "summer_drink_reward_hero_introduce",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local propData = params._datas.propData
					instance:openIntroduceUI(propData)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(summer_drink_reward_open_terminal)
		state_machine.add(summer_drink_reward_close_terminal)
		state_machine.add(summer_drink_reward_show_terminal)
		state_machine.add(summer_drink_reward_hide_terminal)
		state_machine.add(summer_drink_reward_hero_introduce_terminal)
		state_machine.init()
	end
	-- call func init summer drink reward state machine.
	init_summer_drink_reward_terminal()
end

-- 对象初始化
function SummerDrinkReward:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SummerDrinkReward:updateUI()
	-- 最终大奖
	local index = 24
	local rewards = SummerDrinkHandle.getTaskReward(index)

	self.ListView_1:removeAllItems()
	self.Panel_1:removeAllChildren(true)

	local rewardCount = table.nums(rewards)
	local propType = tonumber(rewards[1][1])

	-- 奖励只有一个并且是英雄
	if rewardCount == 1 and propType == 13 then
		self.Panel_1:setTouchEnabled(true)
		-- 查看详情
		fwin:addTouchEventListener(self.Panel_1, nil,
		{
			terminal_name = "summer_drink_reward_hero_introduce",
			terminal_state = 0,
			isPressedActionEnabled = true,
			propData = rewards[1],
		}, nil, 0)

		self:addHeroImage(rewards[1])
	else
		self.Panel_1:setTouchEnabled(false)
		self:updateRewardList(rewards)
	end	
end

function SummerDrinkReward:openIntroduceUI(propData)
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end

		local cell = smHeroInformation:new()
		cell:init(tonumber(propData[2]), self.Panel_1, extraTable)
		fwin:open(cell, fwin._windows)
	end
end

function SummerDrinkReward:addHeroImage(reward)
	local shipMouldID = tonumber(reward[2])

	local pic = SummerDrinkHandle.getHeadIndex(shipMouldID)
	local headSp = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", pic))
	headSp:setAnchorPoint(0.5, 0.5)
	headSp:setPosition(cc.p(self.Panel_1:getContentSize().width/2, self.Panel_1:getContentSize().height/2))
	-- headSp:setScale(0.8)
	self.Panel_1:addChild(headSp)
end

function SummerDrinkReward:updateRewardList(rewards)
	-- 道具奖励
	for _, v in pairs(rewards) do
		local cell = self:addResourcesIconCell(v)
		self.ListView_1:addChild(cell)
	end

	self.ListView_1:jumpToTop()
	self.ListView_1:requestRefreshView()
end

function SummerDrinkReward:addResourcesIconCell(propData)
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

function SummerDrinkReward:onUpdateDraw()
	local root = self.roots[1]

	-- 道具奖励
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 角色奖励
	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")

	self:updateUI()
end

function SummerDrinkReward:onEnterTransitionFinish()
	-- 加载SummerDrinkRewardWindow界面资源.
	-- res.activity.summer_drink.summer_drink_reward = res/activity/summer_drink/summer_drink_reward.csb
	local csbNode = csb.createNode("activity/summer_drink/summer_drink_reward.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "summer_drink_reward_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
end

function SummerDrinkReward:onExit()
	-- 释放SummerDrinkRewardWindow界面资源.
	state_machine.remove("summer_drink_reward_open")
	state_machine.remove("summer_drink_reward_close")
	state_machine.remove("summer_drink_reward_show")
	state_machine.remove("summer_drink_reward_hide")
	state_machine.remove("summer_drink_reward_hero_introduce")
end

function SummerDrinkReward:close()
	-- window event : close.
	
end

function SummerDrinkReward:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
