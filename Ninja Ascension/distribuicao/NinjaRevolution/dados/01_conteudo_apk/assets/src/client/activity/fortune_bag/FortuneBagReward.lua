--[[ ----------------------------------------------------------------------------
-- 奖励预览界面
--]] ----------------------------------------------------------------------------
FortuneBagReward = class("FortuneBagRewardClass", Window)

-- 打开窗口
local fortune_bag_reward_window_open_terminal = {
	_name = "fortune_bag_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FortuneBagRewardClass") then
			fwin:open(FortuneBagReward:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fortune_bag_reward_window_close_terminal = {
	_name = "fortune_bag_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FortuneBagRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_reward_window_open_terminal)
state_machine.add(fortune_bag_reward_window_close_terminal)
state_machine.init()

-- 构造器
function FortuneBagReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._reward_preview = nil
	-- load lua files.
	app.load("client.activity.fortune_bag.fortunebagrewardlist1")
	app.load("client.activity.fortune_bag.fortunebagrewardlist2")
	app.load("client.activity.fortune_bag.fortunebagrewardlist4")

	-- Initialize fortune bag reward page state machine.
	local function init_fortune_bag_reward_terminal()
		-- 打开角色创建窗口
		local fortune_bag_reward_open_terminal = {
			_name = "fortune_bag_reward_open",
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
		local fortune_bag_reward_close_terminal = {
			_name = "fortune_bag_reward_close",
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
		local fortune_bag_reward_show_terminal = {
			_name = "fortune_bag_reward_show",
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
		local fortune_bag_reward_hide_terminal = {
			_name = "fortune_bag_reward_hide",
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

		state_machine.add(fortune_bag_reward_open_terminal)
		state_machine.add(fortune_bag_reward_close_terminal)
		state_machine.add(fortune_bag_reward_show_terminal)
		state_machine.add(fortune_bag_reward_hide_terminal)
		state_machine.init()
	end
	-- call func init fortune bag reward state machine.
	init_fortune_bag_reward_terminal()
end

-- 对象初始化
function FortuneBagReward:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FortuneBagReward:onInit(params)
	self._reward_preview = _ED.active_activity[169].init_params.allReward
end

function FortuneBagReward:onUpdateDraw()
	local root = self.roots[1]
	-- 稀有奖励
	local specialReward = self._reward_preview.specialReward
	-- 普通奖励
	local normalReward = self._reward_preview.normalReward
	-- 配对奖励
	local matchRewardList = self._reward_preview.matchRewardJSON
	-- 终极奖励
	local matchAllRewardEx = self._reward_preview.matchAllRewardEx
	-- 奖励预览子页面容器
	self.ListView_jhsms_rule = ccui.Helper:seekWidgetByName(root, "ListView_jhsms_rule")
	self.ListView_jhsms_rule:removeAllChildren(true)

	-- 处理稀有奖励
	local specilTextCell = state_machine.excute("fortune_bag_reward_list4_create",0,{tipStringInfo_activity_fortune_bag[4]})
	self.ListView_jhsms_rule:addChild(specilTextCell)
	local specialDatasA = zstring.split(specialReward.specialRewardA,"|")
	local len = #specialDatasA
	local lines = math.ceil(len/5)
	for i=1,lines do
		local cell = state_machine.excute("fortune_bag_reward_list2_create",0,{1,i,specialDatasA})
		self.ListView_jhsms_rule:addChild(cell)
	end

	local specialDatasB = zstring.split(specialReward.specialRewardB,"|")
	local len = #specialDatasB
	local lines = math.ceil(len/5)
	for i=1,lines do
		local cell = state_machine.excute("fortune_bag_reward_list2_create",0,{2,i,specialDatasB})
		self.ListView_jhsms_rule:addChild(cell)
	end

	-- 普通资源
	local normalTextCell = state_machine.excute("fortune_bag_reward_list4_create",0,{tipStringInfo_activity_fortune_bag[5]})
	self.ListView_jhsms_rule:addChild(normalTextCell)
	local normalDatas = zstring.split(normalReward,"|")
	local len = #normalDatas
	local lines = math.ceil(len/5)
	for i=1,lines do
		local cell = state_machine.excute("fortune_bag_reward_list2_create",0,{0,i,normalDatas})
		self.ListView_jhsms_rule:addChild(cell)
	end

	-- 配对奖励
	local matchTextCell = state_machine.excute("fortune_bag_reward_list4_create",0,{tipStringInfo_activity_fortune_bag[6]})
	self.ListView_jhsms_rule:addChild(matchTextCell)
	local matchRewards = self:sortListItems(matchRewardList)
	local matchCell = state_machine.excute("fortune_bag_reward_list1_create",0,{matchRewards})
	self.ListView_jhsms_rule:addChild(matchCell)

	matchAllRewardEx = zstring.split(matchAllRewardEx,"|")
	-- 奖励icon1
	self.Panel_fortune_bag_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_fortune_bag_icon_1")
	self.Panel_fortune_bag_icon_1:removeAllChildren(true)
	self.Panel_fortune_bag_icon_1:addChild(self:addResourcesIconCell(zstring.split(matchAllRewardEx[1],",")))
	-- 奖励icon2
	self.Panel_fortune_bag_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_fortune_bag_icon_2")
	self.Panel_fortune_bag_icon_2:removeAllChildren(true)
	self.Panel_fortune_bag_icon_2:addChild(self:addResourcesIconCell(zstring.split(matchAllRewardEx[2],",")))
end

-- 配对奖励排序
function FortuneBagReward:sortListItems(items)
	local result = {}

	for i=0,table.nums(items) - 1 do
		local index = "matchReward"..i
		local val = items[index]
		table.insert(result, val)
	end

	return result
end

-- 添加道具图标
function FortuneBagReward:addResourcesIconCell(propData)
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

function FortuneBagReward:onEnterTransitionFinish()
	-- 加载FortuneBagRewardWindow界面资源.
	-- res.activity.fortune_bag.fortune_bag_reward = res/activity/fortune_bag/fortune_bag_reward.csb
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag_reward.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fortune_bag_reward_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function FortuneBagReward:onExit()
	-- 释放FortuneBagRewardWindow界面资源.
	state_machine.remove("fortune_bag_reward_open")
	state_machine.remove("fortune_bag_reward_close")
	state_machine.remove("fortune_bag_reward_show")
	state_machine.remove("fortune_bag_reward_hide")
end

function FortuneBagReward:close()
	-- window event : close.
	
end

function FortuneBagReward:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
