--[[ ----------------------------------------------------------------------------
-- 获取界面
--]] ----------------------------------------------------------------------------
SecretTreasureTask = class("SecretTreasureTaskClass", Window)

-- 打开窗口
local secret_treasure_task_window_open_terminal = {
	_name = "secret_treasure_task_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasureTaskClass") then
			fwin:open(SecretTreasureTask:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_task_window_close_terminal = {
	_name = "secret_treasure_task_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasureTaskClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_task_window_open_terminal)
state_machine.add(secret_treasure_task_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasureTask:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure task page state machine.
	local function init_secret_treasure_task_terminal()
		-- 打开角色创建窗口
		local secret_treasure_task_open_terminal = {
			_name = "secret_treasure_task_open",
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
		local secret_treasure_task_close_terminal = {
			_name = "secret_treasure_task_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_task_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_task_show_terminal = {
			_name = "secret_treasure_task_show",
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
		local secret_treasure_task_hide_terminal = {
			_name = "secret_treasure_task_hide",
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
		local secret_treasure_task_refresh_terminal = {
			_name = "secret_treasure_task_refresh",
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

		state_machine.add(secret_treasure_task_open_terminal)
		state_machine.add(secret_treasure_task_close_terminal)
		state_machine.add(secret_treasure_task_show_terminal)
		state_machine.add(secret_treasure_task_hide_terminal)
		state_machine.add(secret_treasure_task_refresh_terminal)
		state_machine.init()
	end
	-- call func init secret treasure task state machine.
	init_secret_treasure_task_terminal()
end

-- 对象初始化
function SecretTreasureTask:init(params)
	return self
end

function SecretTreasureTask:updateUI()
	self.propID = SecretTreasureHandle.getSecretCostPropID()
	
	local picIndex = dms.int(dms["prop_mould"], self.propID, prop_mould.pic_index)
	self.Image_props:loadTexture(string.format("images/ui/props/props_%d.png", picIndex))

	self:updatePropNum()
	self:updateGetList()
end

function SecretTreasureTask:updatePropNum()
	local havePropNum = getPropAllCountByMouldId(self.propID)
	self.Text_props:setString(havePropNum)
end

function SecretTreasureTask:getSortTask()
	local taskInfo = SecretTreasureHandle.getSecretTaskInfo()
	local sortTaskInfos = {}

	local canGetReward = {}
	local canGoShake = {}
	local haveGotReward = {}

	for _, v in pairs(taskInfo) do
		if tonumber(v.rewardStatus) == 0 then
			table.insert(canGoShake, v)
		elseif tonumber(v.rewardStatus) == 1 then
			table.insert(canGetReward, v)
		elseif tonumber(v.rewardStatus) == 2 then
			table.insert(haveGotReward, v)
		end
	end

	local function sortFunc(a, b)
		local aSort = tonumber(a.index)
		local bSort = tonumber(b.index)

		return aSort < bSort
	end

	table.sort(canGetReward, sortFunc)
	table.sort(canGoShake, sortFunc)
	table.sort(haveGotReward, sortFunc)


	for _, v in ipairs(canGetReward) do
		table.insert(sortTaskInfos, v)
	end

	for _, v in ipairs(canGoShake) do
		table.insert(sortTaskInfos, v)
	end

	for _, v in ipairs(haveGotReward) do
		table.insert(sortTaskInfos, v)
	end

	return sortTaskInfos
end

function SecretTreasureTask:updateGetList()
	local ListView_task = self.ListView_task
	ListView_task:removeAllItems()

	local tasks = self:getSortTask()
	for _, v in ipairs(tasks) do
		local cell = state_machine.excute("secret_treasure_task_list_create", 0, v)
		ListView_task:addChild(cell)
	end

	-- for i = 1, 8 do
	-- 	local cell = state_machine.excute("secret_treasure_task_list_create", 0, v)
	-- 	ListView_task:addChild(cell)
	-- end

	ListView_task:jumpToTop()
	ListView_task:requestRefreshView()
end

function SecretTreasureTask:onUpdateDraw()
	local root = self.roots[1]

	-- 列表
	self.ListView_task = ccui.Helper:seekWidgetByName(root, "ListView_task")

	-- 道具图标
	self.Image_props = ccui.Helper:seekWidgetByName(root, "Image_props")

	-- 999/999
	self.Text_props = ccui.Helper:seekWidgetByName(root, "Text_props")

	self:updateUI()
end

function SecretTreasureTask:onEnterTransitionFinish()
	-- 加载SecretTreasureTaskWindow界面资源.
	-- res.activity.secret_treasure.secret_treasure_task = res/activity/secret_treasure/secret_treasure_task.csb
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_task.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "secret_treasure_task_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SecretTreasureTask:onExit()
	-- 释放SecretTreasureTaskWindow界面资源.
	state_machine.remove("secret_treasure_task_open")
	state_machine.remove("secret_treasure_task_close")
	state_machine.remove("secret_treasure_task_show")
	state_machine.remove("secret_treasure_task_hide")
	state_machine.remove("secret_treasure_task_refresh")
end

function SecretTreasureTask:close()
	-- window event : close.
	
end

function SecretTreasureTask:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
