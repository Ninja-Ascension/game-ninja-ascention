--[[ ----------------------------------------------------------------------------
-- 获取窗口
--]] ----------------------------------------------------------------------------
LimPoolToGet = class("LimPoolToGetClass", Window)

-- 打开窗口
local lim_pool_to_get_window_open_terminal = {
	_name = "lim_pool_to_get_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LimPoolToGetClass") then
			fwin:open(LimPoolToGet:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local lim_pool_to_get_window_close_terminal = {
	_name = "lim_pool_to_get_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LimPoolToGetClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_to_get_window_open_terminal)
state_machine.add(lim_pool_to_get_window_close_terminal)
state_machine.init()

-- 构造器
function LimPoolToGet:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._taskInfos = {}

	self._activityType = 0					-- 当前活动类型

	-- load lua files.
	app.load("client.activity.lim_pool.limpooltogetlist")

	-- Initialize lim pool to get page state machine.
	local function init_lim_pool_to_get_terminal()
		-- 打开角色创建窗口
		local lim_pool_to_get_open_terminal = {
			_name = "lim_pool_to_get_open",
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
		local lim_pool_to_get_close_terminal = {
			_name = "lim_pool_to_get_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_to_get_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local lim_pool_to_get_show_terminal = {
			_name = "lim_pool_to_get_show",
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
		local lim_pool_to_get_hide_terminal = {
			_name = "lim_pool_to_get_hide",
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

		-- 刷新界面
		local lim_pool_to_get_update_windows_terminal = {
			_name = "lim_pool_to_get_update_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 刷新窗口
				if nil ~= instance then
					-- 更新数据
					instance:updateTaskInfo()
					-- 刷新界面
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(lim_pool_to_get_open_terminal)
		state_machine.add(lim_pool_to_get_close_terminal)
		state_machine.add(lim_pool_to_get_show_terminal)
		state_machine.add(lim_pool_to_get_hide_terminal)
		state_machine.add(lim_pool_to_get_update_windows_terminal)
		state_machine.init()
	end
	-- call func init lim pool to get state machine.
	init_lim_pool_to_get_terminal()
end

-- 对象初始化
function LimPoolToGet:init(params)
	self._activityType = params[1]
	self:updateTaskInfo()
	return self
end

function LimPoolToGet:updateTaskInfo()
	self._taskInfos = _ED.active_activity[self._activityType].info.taskInfos
end

function LimPoolToGet:updatePropNum()
	local propID = 0
	if self._activityType == 168 then
		propID = dms.int(dms["activity_config"], 62, activity_config.param)
	elseif self._activityType == 188 then
		propID = dms.int(dms["activity_config"], 112, activity_config.param)
	end
	local havePropNum = getPropAllCountByMouldId(propID)
	self.Text_props:setString(havePropNum)
end

function LimPoolToGet:updateGetList()
	local ListView_to_get = self.ListView_to_get
	ListView_to_get:removeAllItems()

	local taskInfo = self:getSortList()
	for _, v in ipairs(taskInfo) do
		local cell = state_machine.excute("lim_pool_to_get_list_create", 0, {_taskData = v, _activityType = self._activityType})
		ListView_to_get:addChild(cell)
	end

	ListView_to_get:jumpToTop()
	ListView_to_get:requestRefreshView()
end

function LimPoolToGet:getSortList()
	-- 可领取＞可前往＞已领取==已完成，同等情况下按类型排序
	local taskData = self._taskInfos

	local sortTaskData = {}
	for _, v in pairs(taskData) do
		table.insert(sortTaskData, v)
	end

	table.sort(sortTaskData, function(a, b)
		-- 可领取
		local canGetRewardA = (a.getReward == 0 and a.taskStatus == 1) and 1000 or 900
		local canGetRewardB = (b.getReward == 0 and b.taskStatus == 1) and 1000 or 900

		-- 可前往
		local taskStatusA = (a.taskStatus == 0) and 100 or 90
		local taskStatusB = (b.taskStatus == 0) and 100 or 90

		-- 已领取
		local haveGetRewardA = (a.getReward == 1) and 10 or 9
		local haveGetRewardB = (b.getReward == 1) and 10 or 9
		
		local totalA = canGetRewardA + taskStatusA + haveGetRewardA
		local totalB = canGetRewardB + taskStatusB + haveGetRewardB

		if totalA == totalB then
			return tonumber(a.taskType) < tonumber(b.taskType)
		end
		
		return totalA >  totalB
	end)

	return sortTaskData
end

function LimPoolToGet:onUpdateDraw()
	local root = self.roots[1]

	-- 拥有忍者令数量
	self.Text_props = ccui.Helper:seekWidgetByName(root, "Text_props")

	-- 获取途径列表
	self.ListView_to_get = ccui.Helper:seekWidgetByName(root, "ListView_to_get")

	self:updatePropNum()
	self:updateGetList()
end

function LimPoolToGet:onEnterTransitionFinish()
	-- 加载LimPoolToGetWindow界面资源.
	-- res.activity.lim_pool.lim_pool_to_get = res/activity/lim_pool/lim_pool_to_get.csb
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_to_get.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "lim_pool_to_get_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function LimPoolToGet:onExit()
	-- 释放LimPoolToGetWindow界面资源.
	state_machine.remove("lim_pool_to_get_open")
	state_machine.remove("lim_pool_to_get_close")
	state_machine.remove("lim_pool_to_get_show")
	state_machine.remove("lim_pool_to_get_hide")
	state_machine.remove("lim_pool_to_get_update_windows")
end

function LimPoolToGet:close()
	-- window event : close.
	
end

function LimPoolToGet:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
