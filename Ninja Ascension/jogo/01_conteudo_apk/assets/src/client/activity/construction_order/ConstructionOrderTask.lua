--[[ ----------------------------------------------------------------------------
-- 任务界面
--]] ----------------------------------------------------------------------------
ConstructionOrderTask = class("ConstructionOrderTaskClass", Window)

-- 打开窗口
local construction_order_task_window_open_terminal = {
    _name = "construction_order_task_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ConstructionOrderTaskClass") then
            fwin:open(ConstructionOrderTask:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local construction_order_task_window_close_terminal = {
    _name = "construction_order_task_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ConstructionOrderTaskClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_task_window_open_terminal)
state_machine.add(construction_order_task_window_close_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderTask:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.taskString = nil

    self.curType = 1
    self.totalTime = 0
    self.deltaTime = 1

    self.ListView_task = nil

    app.load("client.activity.construction_order.ConstructionOrderTaskList")
    -- Initialize construction_order_task page state machine.
    local function init_construction_order_task_terminal()
        -- 打开角色创建窗口
        local construction_order_task_open_terminal = {
            _name = "construction_order_task_open",
            _init = function(terminal)
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
        local construction_order_task_close_terminal = {
            _name = "construction_order_task_close",
            _init = function(terminal)
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
        local construction_order_task_show_terminal = {
            _name = "construction_order_task_show",
            _init = function(terminal)
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
        local construction_order_task_hide_terminal = {
            _name = "construction_order_task_hide",
            _init = function(terminal)
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
        
        -- 切换任务类型
        local construction_order_task_change_type_terminal = {
            _name = "construction_order_task_change_type",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 切换任务类型
                if nil ~= instance then
                    local type = params._datas.curType
                    instance:onUpdateDraw(type)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_task_open_terminal)
        state_machine.add(construction_order_task_close_terminal)
        state_machine.add(construction_order_task_show_terminal)
        state_machine.add(construction_order_task_hide_terminal)
        state_machine.add(construction_order_task_change_type_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_construction_order_task_terminal()
end

function ConstructionOrderTask:getWeekTaskInfo(taskID)
    local itemInfo = {}
end

function ConstructionOrderTask:getItemTaskInfo(taskID, stateNum)
    
    local itemInfo = {}
    itemInfo.taskID = taskID
    local taskInfo = dms.atos(dms["achieve"], taskID)
    itemInfo.descText = dms.atos(taskInfo, achieve.descript)
    itemInfo.taskType = dms.atof(taskInfo, achieve.achive_type)
    itemInfo.rewardValue = dms.atos(taskInfo, achieve.reward_value)
    itemInfo.curPro = stateNum
    itemInfo.allPro = dms.atof(taskInfo, achieve.param2)
    if itemInfo.taskType == 1 then
        itemInfo.state = stateNum
    else
        if stateNum >= itemInfo.allPro then
            itemInfo.state = 1
        else
            itemInfo.state = 0
        end
    end
    return itemInfo
end

function ConstructionOrderTask:updateUI()
    if self.curType == 1 then
        self.Button_task_dayily:setTouchEnabled(true)
        self.Button_task_dayily:setHighlighted(false)
        self.Button_task_week:setTouchEnabled(false)
        self.Button_task_week:setHighlighted(true)
        self.Text_week:setVisible(true)
        self.Text_day:setVisible(false)
    elseif self.curType == 2 then
        self.Button_task_dayily:setTouchEnabled(false)
        self.Button_task_dayily:setHighlighted(true)
        self.Button_task_week:setTouchEnabled(true)
        self.Button_task_week:setHighlighted(false)
        self.Text_week:setVisible(false)
        self.Text_day:setVisible(true)
    end
end

-- 获取排序后的任务信息
function ConstructionOrderTask:getTaskInfo()
    local user_order_info = _ED.active_activity[186].user_order_info
    if user_order_info == nil then
        return false
    end

    local runTasks = {}             -- 进行中的任务
    local finishedTasks = {}        -- 已完成的任务
    local dayAchieveInfo = {}       -- 日常任务
    local weekAchieveInfo = {}      -- 周任务

    local result = {}

    local achieveInfo = zstring.split(self.taskString, "!")
    local weekAchieve = zstring.split(achieveInfo[2], ',', function ( value ) return tonumber(value) end)
    local dayAchieve = zstring.split(achieveInfo[1], ',', function ( value ) return tonumber(value) end)

    local dayStateInfo = user_order_info.dayAchieveState
    local weekStateInfo = user_order_info.weekAchieveState
    -- local dayStateInfo = {0,0,1,1,0,0,0,0}
    -- local weekStateInfo = {0,0,0,300,0,0,0,0,0,300,0,0,0}

    if self.curType == 2 then
        
        for i, v in ipairs(dayAchieve) do
            dayAchieveInfo[i] = self:getItemTaskInfo(v, dayStateInfo[i])
            
            -- dayAchieveInfo[i].taskID = v
            
            -- local taskInfo = dms.atos(dms["achieve"], taskID)
            -- local descText = dms.atos(taskInfo, achieve.descript)
            -- local taskType = dms.atos(taskInfo, achieve.achive_type)
            -- local rewardValue = dms.atos(taskInfo, achieve.reward_value)
            -- dayAchieveInfo[i].curPro = dayStateInfo[i]
            -- if taskType == 3 then
            --     dayAchieveInfo[i].state = dayStateInfo[i]
            -- else
            --     dayAchieveInfo[i].curPro = dayStateInfo[i]
            -- end

            
            if dayAchieveInfo[i].state == 0 then
                table.insert(runTasks, dayAchieveInfo[i])
            else
                table.insert(finishedTasks, dayAchieveInfo[i])
            end
        end
    end
    if self.curType == 1 then
        for i, v in ipairs(weekAchieve) do

            weekAchieveInfo[i] = self:getItemTaskInfo(v, weekStateInfo[i])
            if weekAchieveInfo[i].state == 0 then
                table.insert(runTasks, weekAchieveInfo[i])
            else
                table.insert(finishedTasks, weekAchieveInfo[i])
            end
        end
    end

    for i, v in ipairs(runTasks) do
        table.insert(result, v)
    end

    for i, v in ipairs(finishedTasks) do
        table.insert(result, v)
    end
    return result
end

-- 绘制倒计时
function ConstructionOrderTask:updateDrawTaskTime()
    -- self._taskEndTime = 2000000000000
	if self.Text_time == nil or self._taskEndTime == nil then
        return
    end
    local surplus_time = (self._taskEndTime - (os.time() + _ED.time_add_or_sub) * 1000)
    self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
    
end

function ConstructionOrderTask:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.floor((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .. _string_piece_info[231]
    end
    if _hourTime < 10 then
        timeString = timeString .. "0" .. _hourTime .. ":"
    else
        timeString = timeString .. _hourTime .. ":"
    end

    if _minutesTime < 10 then
        timeString = timeString .. "0" .. _minutesTime .. ":"
    else
        timeString = timeString .. _minutesTime .. ":"
    end

    if _secondsTime < 10 then
        timeString = timeString .. "0" .. _secondsTime
    else
        timeString = timeString .. _secondsTime
    end
    return timeString
end

function ConstructionOrderTask:onUpdateDraw(type)
    if type ~= nil then
        self.curType = type
    end
    
    self.Image_time:setVisible(self.curType == 1)
    
    self:updateUI()
    self.ListView_task_day:removeAllItems()
    self.ListView_task_week:removeAllItems()
    self.ListView_task_week:setVisible(false)
    self.ListView_task_day:setVisible(false)
    if self.curType == 1 then
        
        self:updateDrawTaskTime()

        self.ListView_task_week:setVisible(true)
        self.ListView_task = self.ListView_task_week
    elseif self.curType == 2 then
        self.ListView_task_day:setVisible(true)
        self.ListView_task = self.ListView_task_day
    end
    local result = self:getTaskInfo()
    for i, v in ipairs(result) do
        local cell = state_machine.excute("construction_order_task_list_create", 0, {info = v, index = i})
        self.ListView_task:addChild(cell)
    end

    self.ListView_task:jumpToTop()
    self.ListView_task:requestRefreshView()
    self.listViewPosY = self.ListView_task:getInnerContainer():getPositionY()
end

-- 对象初始化
function ConstructionOrderTask:init(params)
    self.taskString = params[1]
    -- result = zstring.split(taskString, ",", function ( value ) return tonumber(value) end)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function ConstructionOrderTask:onUpdate(dt)
    if self.curType == 1 then
        self.totalTime = self.totalTime + dt
        if self.totalTime >= self.deltaTime then
            self:updateDrawTaskTime()
            self.totalTime = 0
        end
    end
    if self.ListView_task ~= nil then
		local size = self.ListView_task:getContentSize()
		local posY = self.ListView_task:getInnerContainer():getPositionY()
        if self.listViewPosY== posY then
            return
        end
        self.listViewPosY = posY
		local items = self.ListView_task:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height/ 2 + itemSize.height < 0 or tempY > size.height + itemSize.height/ 2 then
				v:unload()
			else
				v:reload()
			end
		end

	end
end

function ConstructionOrderTask:updateDrawDot()
    fwin:addService({
		callback = function ( params )
			state_machine.excute("notification_center_update", 0, "push_notification_construction_warorder_update_task_push")
		end,
		delay = 0,
	})
end


function ConstructionOrderTask:onEnterTransitionFinish()
    -- 加载ChristmasRomanceShopWindow界面资源.
    -- res.activity.christmas_romance.construction_order_task = res/activity/christmas_romance/construction_order_task.csb
    local csbNode = csb.createNode("activity/passport/passport_main_jianhao_task.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 每周任务列表
    self.ListView_task_week = ccui.Helper:seekWidgetByName(root, "ListView_1_0")
    -- 每日任务列表
    self.ListView_task_day = ccui.Helper:seekWidgetByName(root, "ListView_1")
    

    -- 关闭任务界面按钮
    self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "construction_order_task_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

    -- 每日任务界面
    self.Button_task_dayily = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_day"), nil,
	{
		terminal_name = "construction_order_task_change_type",
		terminal_state = 0,
		isPressedActionEnabled = true,
        curType = 2,
	}, nil, 0)

    -- 每周任务界面
    self.Button_task_week = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_week"), nil,
	{
		terminal_name = "construction_order_task_change_type",
		terminal_state = 0,
		isPressedActionEnabled = true,
        curType = 1,
	}, nil, 0)

    -- 每周任务文本
    self.Text_week = ccui.Helper:seekWidgetByName(root, "Text_week_2")
    
    -- 每日任务文本
    self.Text_day = ccui.Helper:seekWidgetByName(root, "Text_day_2")

    -- 倒计时
    self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time_0")

    self.Image_time = ccui.Helper:seekWidgetByName(root, "Image_time")
    local user_order_info = _ED.active_activity[186].user_order_info
    if user_order_info ~= nil then
        self._taskEndTime = user_order_info.weekEndTime
    end
    
    self:onUpdateDraw()
    self:updateDrawDot()

end

function ConstructionOrderTask:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("construction_order_task_open")
    state_machine.remove("construction_order_task_close")
    state_machine.remove("construction_order_task_show")
    state_machine.remove("construction_order_task_hide")
    state_machine.remove("construction_order_task_change_type")
    
end

function ConstructionOrderTask:close()
    -- window event : close.
end

function ConstructionOrderTask:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
