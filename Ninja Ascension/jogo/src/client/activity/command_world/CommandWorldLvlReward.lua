--[[ ----------------------------------------------------------------------------
-- 积分奖励界面
--]] ----------------------------------------------------------------------------
CommandWorldLvlReward = class("CommandWorldLvlRewardClass", Window)

-- 打开窗口
local command_world_lvl_reward_window_open_terminal = {
	_name = "command_world_lvl_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CommandWorldLvlRewardClass") then
			fwin:open(CommandWorldLvlReward:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_lvl_reward_window_close_terminal = {
	_name = "command_world_lvl_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldLvlRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_lvl_reward_window_open_terminal)
state_machine.add(command_world_lvl_reward_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorldLvlReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world lvl reward page state machine.
	local function init_command_world_lvl_reward_terminal()
		-- 打开角色创建窗口
		local command_world_lvl_reward_open_terminal = {
			_name = "command_world_lvl_reward_open",
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
		local command_world_lvl_reward_close_terminal = {
			_name = "command_world_lvl_reward_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_lvl_reward_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_lvl_reward_show_terminal = {
			_name = "command_world_lvl_reward_show",
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
		local command_world_lvl_reward_hide_terminal = {
			_name = "command_world_lvl_reward_hide",
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

		-- 
		local command_world_lvl_reward_refresh_terminal = {
			_name = "command_world_lvl_reward_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(command_world_lvl_reward_open_terminal)
		state_machine.add(command_world_lvl_reward_close_terminal)
		state_machine.add(command_world_lvl_reward_show_terminal)
		state_machine.add(command_world_lvl_reward_hide_terminal)
		state_machine.add(command_world_lvl_reward_refresh_terminal)
		state_machine.init()
	end
	-- call func init command world lvl reward state machine.
	init_command_world_lvl_reward_terminal()
end

-- 对象初始化
function CommandWorldLvlReward:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CommandWorldLvlReward:updateUI()
	self.ListView_1:removeAllItems()
	local sortData = self:getSortData()
	for i, v in ipairs(sortData) do
		local cell = state_machine.excute("command_world_lvl_reward_list_create", 0, {index = i, data = v})
		self.ListView_1:addChild(cell)
	end
	self.ListView_1_poy = self.ListView_1:getInnerContainer():getPositionY()
	self.ListView_1:jumpToTop()
	self.ListView_1:requestRefreshView()
end

function CommandWorldLvlReward:getSortData()
	local data = CommandWorldHandle.getCommandWorldUnionScoreRewardInfo()
	local scoreSectionStr = zstring.splits(dms.string(dms["activity_config"], 79, activity_config.param), "|", ",")

	local sortData = {}

	local status = zstring.split(data.status, ",")
	for i, v in ipairs(status) do
		table.insert(sortData, {index = i, rewardState = tonumber(v), level = tonumber(scoreSectionStr[i][1]), score = tonumber(scoreSectionStr[i][2])})
	end

	-- 可领取
	local temp1 = {}
	-- 未完成
	local temp2 = {}
	-- 已领取
	local temp3 = {}

	for _, v in ipairs(sortData) do
		if v.rewardState == 1 then
			table.insert(temp1, v)
		elseif v.rewardState == 0 then
			table.insert(temp2, v)
		else
			table.insert(temp3, v)
		end
	end

	table.sort(temp1, function(a, b)
		return tonumber(a.index) < tonumber(b.index)
	end)
	table.sort(temp2, function(a, b)
		return tonumber(a.index) < tonumber(b.index)
	end)
	table.sort(temp3, function(a, b)
		return tonumber(a.index) < tonumber(b.index)
	end)

	sortData = {}
	for _, v in ipairs(temp1) do
		table.insert(sortData, v)
	end
	for _, v in ipairs(temp2) do
		table.insert(sortData, v)
	end
	for _, v in ipairs(temp3) do
		table.insert(sortData, v)
	end

	return sortData
end

-- @onUpdate(dt)
-- function CommandWorldLvlReward:onUpdate(dt)
-- 	if self.ListView_1 ~= nil then
-- 		local size = self.ListView_1:getContentSize()
-- 		local posY = self.ListView_1:getInnerContainer():getPositionY()
-- 		if self.ListView_1_poy == posY then
-- 			return
-- 		end
-- 		self.ListView_1_poy = posY
-- 		local items = self.ListView_1:getItems()
-- 		if items[1] == nil then
-- 			return
-- 		end
-- 		local itemSize = items[1]:getContentSize()
-- 		for i, v in pairs(items) do
-- 			local tempY = v:getPositionY() + posY
-- 			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
-- 				v:unload()
-- 			else	
-- 				v:reload()				
-- 			end
-- 		end
-- 	end
-- end

function CommandWorldLvlReward:onUpdateDraw()
	local root = self.roots[1]

	-- 积分奖励容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateUI()
end

function CommandWorldLvlReward:onEnterTransitionFinish()
	-- 加载CommandWorldLvlRewardWindow界面资源.
	-- res.activity.command_world.command_world_lvl_reward = res/activity/command_world/command_world_lvl_reward.csb
	local csbNode = csb.createNode("activity/command_world/command_world_lvl_reward.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "command_world_lvl_reward_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CommandWorldLvlReward:onExit()
	-- 释放CommandWorldLvlRewardWindow界面资源.
	state_machine.remove("command_world_lvl_reward_open")
	state_machine.remove("command_world_lvl_reward_close")
	state_machine.remove("command_world_lvl_reward_show")
	state_machine.remove("command_world_lvl_reward_hide")
	state_machine.remove("command_world_lvl_reward_refresh")
end

function CommandWorldLvlReward:close()
	-- window event : close.
	
end

function CommandWorldLvlReward:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
