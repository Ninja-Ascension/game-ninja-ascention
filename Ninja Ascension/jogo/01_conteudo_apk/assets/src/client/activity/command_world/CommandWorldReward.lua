--[[ ----------------------------------------------------------------------------
-- 排行奖励界面
--]] ----------------------------------------------------------------------------
CommandWorldReward = class("CommandWorldRewardClass", Window)

-- 打开窗口
local command_world_reward_window_open_terminal = {
	_name = "command_world_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CommandWorldRewardClass") then
			fwin:open(CommandWorldReward:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_reward_window_close_terminal = {
	_name = "command_world_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_reward_window_open_terminal)
state_machine.add(command_world_reward_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorldReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world reward page state machine.
	local function init_command_world_reward_terminal()
		-- 打开角色创建窗口
		local command_world_reward_open_terminal = {
			_name = "command_world_reward_open",
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
		local command_world_reward_close_terminal = {
			_name = "command_world_reward_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_reward_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_reward_show_terminal = {
			_name = "command_world_reward_show",
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
		local command_world_reward_hide_terminal = {
			_name = "command_world_reward_hide",
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

		local command_world_change_tab_button_terminal = {
			_name = "command_world_change_tab_button",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local tabType = params._datas._tabType

					-- 清除排行数据
					CommandWorldHandle.clearCommandWorldRankInfo()

					-- 如果跨服排行没有开启
					if tabType == 1 then
						if instance:getCrossServerRankIsOpen() == false then
							fwin:addService({callback = function ( params )
									local _self = params
									_self:updateRankList(tabType)
								end,
								delay = 0.1,
								params = instance
							})
							return true
						end
					end

					-- 请求排行榜信息0本服 1跨服
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots[1] ~= nil then
								response.node:updateRankList(tabType)
							end
						end
					end
					protocol_command.activity_orders_world_get_order.param_list = "" .. tabType
					NetworkManager:register(protocol_command.activity_orders_world_get_order.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(command_world_reward_open_terminal)
		state_machine.add(command_world_reward_close_terminal)
		state_machine.add(command_world_reward_show_terminal)
		state_machine.add(command_world_reward_hide_terminal)
		state_machine.add(command_world_change_tab_button_terminal)
		state_machine.init()
	end
	-- call func init command world reward state machine.
	init_command_world_reward_terminal()
end

-- 对象初始化
function CommandWorldReward:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CommandWorldReward:updateUI()
	self:updateRankList(0)
end

-- 跨服排行是否开启
function CommandWorldReward:getCrossServerRankIsOpen()
	local singleServerEndTime = CommandWorldHandle.getCommandWorldSingleServerEndTime()
	local surplus_time = (singleServerEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	return surplus_time < 0
end

function CommandWorldReward:updateRankList(tabType)
	self.Button_bf:setBright(tabType == 0)
	self.Button_kf:setBright(tabType == 1)

	self.Image_1:setVisible(tabType == 0)
	self.Image_1_0:setVisible(tabType == 1)

	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local isCrossServer = tabType == 1
	local count = CommandWorldHandle.getCommandWorldRankCount(isCrossServer)
	for i = 1, count do
		local cell = state_machine.excute("command_world_reward_cell_create", 0, {index = i, rankType = tabType})
		ListView_1:addChild(cell)
	end

	self.ListView_1_poy = self.ListView_1:getInnerContainer():getPositionY()

	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()

	local myRankData = CommandWorldHandle.getCommandWorldMyRankInfo()
	local myRankNumber = myRankData.myRankNumber
	local myselfScore = myRankData.myselfScore

	if tonumber(myRankNumber) ~= -1 then
		self.Text_1_0:setString(myRankNumber)
	else
		self.Text_1_0:setString(tipStringInfo_command_world[6])
	end
	
	self.Text_2_0:setString(myselfScore)
end

function CommandWorldReward:onUpdateDraw()
	local root = self.roots[1]

	-- 
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 我的排名
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	-- 积分数值
	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")

	-- 领取公会奖励限制
	self.Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")

	self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	
	self.Image_1_0 = ccui.Helper:seekWidgetByName(root, "Image_1_0")

	self:updateUI()
end

-- @onUpdate(dt)
function CommandWorldReward:onUpdate(dt)
	if self.ListView_1 ~= nil then
		local size = self.ListView_1:getContentSize()
		local posY = self.ListView_1:getInnerContainer():getPositionY()
		if self.ListView_1_poy == posY then
			return
		end
		self.ListView_1_poy = posY
		local items = self.ListView_1:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
				v:unload()
			else	
				v:reload()				
			end
		end
	end
end

function CommandWorldReward:onEnterTransitionFinish()
	-- 加载CommandWorldRewardWindow界面资源.
	-- res.activity.command_world.command_world_reward = res/activity/command_world/command_world_reward.csb
	local csbNode = csb.createNode("activity/command_world/command_world_reward.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

		-- 本服排名
	self.Button_bf = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bf"), nil,
	{
		terminal_name = "command_world_change_tab_button",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_tabType = 0
	}, nil, 0)	

	-- 跨服排名
	self.Button_kf = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf"), nil,
	{
		terminal_name = "command_world_change_tab_button",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_tabType = 1
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "command_world_reward_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CommandWorldReward:onExit()
	-- 释放CommandWorldRewardWindow界面资源.
	state_machine.remove("command_world_reward_open")
	state_machine.remove("command_world_reward_close")
	state_machine.remove("command_world_reward_show")
	state_machine.remove("command_world_reward_hide")
end

function CommandWorldReward:close()
	-- window event : close.
	
end

function CommandWorldReward:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
