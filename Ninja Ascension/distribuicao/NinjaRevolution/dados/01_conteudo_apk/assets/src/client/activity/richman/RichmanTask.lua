--[[ ----------------------------------------------------------------------------
-- 获奖记录窗口
--]] ----------------------------------------------------------------------------
RichmanTask = class("RichmanTaskClass", Window)

-- 打开窗口
local richman_task_window_open_terminal = {
	_name = "richman_task_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RichmanTaskClass") then
			fwin:open(RichmanTask:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local richman_task_window_close_terminal = {
	_name = "richman_task_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RichmanTaskClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(richman_task_window_open_terminal)
state_machine.add(richman_task_window_close_terminal)
state_machine.init()

-- 构造器
function RichmanTask:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._noticeInfo = nil

	-- load lua files.
    app.load("client.activity.richman.RichmanTaskList")
	-- Initialize RichmanTask page state machine.
	local function init_richman_task_terminal()
		-- 打开角色创建窗口
		local richman_task_open_terminal = {
			_name = "richman_task_open",
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
		local richman_task_close_terminal = {
			_name = "richman_task_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("richman_task_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local richman_task_show_terminal = {
			_name = "richman_task_show",
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
		local richman_task_hide_terminal = {
			_name = "richman_task_hide",
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

		-- 领取奖励后刷新任务界面
		local richman_task_get_reward_update_terminal = {
			_name = "richman_task_get_reward_update",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 刷新任务界面
				if nil ~= instance then
					local function responseBuyPropCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots[1] ~= nil then
								app.load("client.reward.DrawRareReward")
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								fwin:open(getRewardWnd,fwin._ui)
								
								instance:updateDrawListview()

								instance:updateUserActivityParams()

								state_machine.excute("richman_main_update_dice_numbers", 0, nil)
								-- 刷新主界面任务红点
								state_machine.excute("richman_main_refresh_task_red_point", 0, nil)
							end
                        end
                    end
                    -- print(welfareID, "=====welfareID")
                    local achieveID = params._datas.achieveID
                    protocol_command.monopoly_get_task_reward.param_list = achieveID
                    NetworkManager:register(protocol_command.monopoly_get_task_reward.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
					
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(richman_task_open_terminal)
		state_machine.add(richman_task_close_terminal)
		state_machine.add(richman_task_show_terminal)
		state_machine.add(richman_task_hide_terminal)
		state_machine.add(richman_task_get_reward_update_terminal)
		state_machine.init()
	end
	
	init_richman_task_terminal()
end

-- 刷新用户activity_params的taskState信息
function RichmanTask:updateUserActivityParams()
	local userDataInfo = _ED.active_activity[187].activity_params
	if userDataInfo == nil then
		return
	end

	local activity_data = _ED.active_activity[187].activity_data
    if activity_data == nil then
        return
    end

	-- 协议数据
	local allTaskInfo = activity_data.achieveInfoList
	local taskStateMap = {}
	for i, v in ipairs(allTaskInfo) do
		local taskInfo = zstring.split(v, ",", tonumber)
		local id = tostring(taskInfo[1])
		local curPro = taskInfo[2]
		local taskState = taskInfo[3]

		taskStateMap[id] = curPro .. "," .. taskState
	end

	-- 用户数据
	local userDataInfo = json.decode(userDataInfo)
	for k, v in pairs(taskStateMap) do
		userDataInfo.taskState[k] = v
	end

	-- 更新
	userDataInfo = json.encode(userDataInfo)
	_ED.active_activity[187].activity_params = userDataInfo

	-- print("任务 updateUserActivityParams>>>>>>>>>>>>>>>>>>>")
	-- print("_ED.active_activity[187].activity_params = ", _ED.active_activity[187].activity_params)
end

-- 获取排序后的任务信息
function RichmanTask:getTaskInfo()
    local activity_data = _ED.active_activity[187].activity_data
    if activity_data == nil then
        return false
    end

	local unCompleteTasks = {}		-- 未完成任务
    local canReceiveTasks = {}      -- 可领取的任务
    local finishedTasks = {}        -- 已领取的任务

    local result = {}

    local function sortAchieveListFunc(a, b)
    	return a.id < b.id
    end

    local allTaskInfo = activity_data.achieveInfoList
	for i, v in ipairs(allTaskInfo) do
		local taskInfo = {}
		local tempInfo = zstring.split(v, ",", tonumber)
		
		taskInfo.achieveID = tempInfo[1]
		local curPro = tempInfo[2]
		taskInfo.taskState = tempInfo[3]
		local achieveInfo = dms.atos(dms["achieve"], taskInfo.achieveID)
		taskInfo.descText = dms.atos(achieveInfo, achieve.descript)
		taskInfo.taskType = dms.atof(achieveInfo, achieve.achive_type)
		taskInfo.rewardValue = dms.atos(achieveInfo, achieve.reward_value)
		taskInfo.allPro = dms.atof(achieveInfo, achieve.param2)
		taskInfo.id = dms.atof(achieveInfo, achieve.id)
		
		taskInfo.curPro = curPro >= taskInfo.allPro and taskInfo.allPro or curPro
		if taskInfo.taskState == 0 then
			table.insert(unCompleteTasks, taskInfo)
		elseif taskInfo.taskState == 1 then
			table.insert(canReceiveTasks, taskInfo)
		elseif taskInfo.taskState == 2 then
			table.insert(finishedTasks, taskInfo)
		end
	end

	table.sort(canReceiveTasks, sortAchieveListFunc)
    for i, v in ipairs(canReceiveTasks) do
        table.insert(result, v)
    end

    table.sort(unCompleteTasks, sortAchieveListFunc)
	for i, v in ipairs(unCompleteTasks) do
        table.insert(result, v)
    end

    table.sort(finishedTasks, sortAchieveListFunc)
    for i, v in ipairs(finishedTasks) do
        table.insert(result, v)
    end
    return result
end

function RichmanTask:updateDrawListview()
	self.ListView_1:removeAllItems()

	local allTaskInfo = self:getTaskInfo()
	for i, v in ipairs(allTaskInfo) do
		local cell = state_machine.excute("richman_task_list_create", 0, v)
		self.ListView_1:addChild(cell)
	end
	self.ListView_1:requestRefreshView()
	self.ListView_1:jumpToTop()
end

function RichmanTask:onUpdateDraw()
	local root = self.roots[1]

	 -- 任务列表
	 self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	 self:updateDrawListview()

end

-- 对象初始化
function RichmanTask:init(params)
	if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function RichmanTask:onEnterTransitionFinish()
	-- 加载LimPoolRecordWindow界面资源.
	local csbNode = csb.createNode("activity/dafuweng/dafuweng_task.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "richman_task_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RichmanTask:onExit()
	-- 释放LimPoolRecordWindow界面资源.
	state_machine.remove("richman_task_open")
	state_machine.remove("richman_task_close")
	state_machine.remove("richman_task_show")
	state_machine.remove("richman_task_hide")
	state_machine.remove("richman_task_get_reward_update")
	
end

function RichmanTask:close()
	-- window event : close.
	
end

function RichmanTask:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
