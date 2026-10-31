--[[ ----------------------------------------------------------------------------
-- 七日累充活动主界面
--]] ----------------------------------------------------------------------------
SevenDaysRechargeWindow = class("SevenDaysRechargeWindowClass", Window)

-- 打开窗口
local seven_days_recharge_window_open_terminal = {
    _name = "seven_days_recharge_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SevenDaysRechargeWindowClass") then
            fwin:open(SevenDaysRechargeWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local seven_days_recharge_window_close_terminal = {
    _name = "seven_days_recharge_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SevenDaysRechargeWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_days_recharge_window_open_terminal)
state_machine.add(seven_days_recharge_window_close_terminal)
state_machine.init()

-- 构造器
function SevenDaysRechargeWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.currentPage = 0
    self.activityInfos = nil
    -- load lua files.
    app.load("client.activity.seven_days_recharge.SevenDaysRechargeRewardList")
    app.load("client.activity.seven_days_recharge.SevenDaysRechargeRule")
    app.load("client.activity.seven_days_recharge.SevenDaysRechargeItem")
    -- Initialize seven days recharge page state machine.
    local function init_seven_days_recharge_terminal()
        -- 打开角色创建窗口
        local seven_days_recharge_open_terminal = {
            _name = "seven_days_recharge_open",
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
        local seven_days_recharge_close_terminal = {
            _name = "seven_days_recharge_close",
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
        local seven_days_recharge_show_terminal = {
            _name = "seven_days_recharge_show",
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
        local seven_days_recharge_hide_terminal = {
            _name = "seven_days_recharge_hide",
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
		
		-- 刷新当前界面
        local seven_days_recharge_refush_terminal = {
            _name = "seven_days_recharge_refush",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    instance:refushPage()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 切页
        local seven_days_recharge_change_page_terminal = {
            _name = "seven_days_recharge_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mPage = params._datas.m_page
                if nil ~= instance then
                    instance:changeToPage(mPage)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		-- 刷新红点
        local seven_days_recharge_change_red_plot_tip_page_terminal = {
            _name = "seven_days_recharge_change_red_plot_tip_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    instance:refushRedPlot()
                    fwin:addService({
						callback = function ( params )
							state_machine.excute("notification_center_update", 0, "push_notification_seven_days_recharge_page_push")
							state_machine.excute("notification_center_update", 0, "push_notification_seven_days_recharge_page_push")
						end,
						delay = 0,
					})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		

        state_machine.add(seven_days_recharge_open_terminal)
        state_machine.add(seven_days_recharge_close_terminal)
        state_machine.add(seven_days_recharge_show_terminal)
		state_machine.add(seven_days_recharge_hide_terminal)
		state_machine.add(seven_days_recharge_refush_terminal)
		state_machine.add(seven_days_recharge_change_page_terminal)
		state_machine.add(seven_days_recharge_change_red_plot_tip_page_terminal)
        state_machine.init()
    end
    -- call func init seven days recharge state machine.
    init_seven_days_recharge_terminal()
end

-- 对象初始化
function SevenDaysRechargeWindow:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function SevenDaysRechargeWindow:onUpdateDraw()
    local root = self.roots[1]

    -- 活动剩余时间
    self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

    -- 七日累充分页
    self.Panel_tab_1 = ccui.Helper:seekWidgetByName(root, "Panel_tab_1")
    self.Panel_tab_1:setVisible(false)
    -- 七日连充分页
    self.Panel_tab_2 = ccui.Helper:seekWidgetByName(root, "Panel_tab_2")
    self.Panel_tab_2:setVisible(false)

    -- 奖励展示界面
    self.ListView_reward_up = ccui.Helper:seekWidgetByName(root, "ListView_reward_up")
    -- 七日累充奖励列表容器
    self.ListView_comb_recharge_1 = ccui.Helper:seekWidgetByName(root, "ListView_comb_recharge_1")
    -- 七日累充奖励列表容器
	self.ListView_comb_recharge_1_0 = ccui.Helper:seekWidgetByName(root, "ListView_comb_recharge_1_0")
	
	 -- 连续充值天数
	 self.Text_timeNum = ccui.Helper:seekWidgetByName(root, "Text_timeNum")
     self.Text_timeNum:setString(self.activityInfos.task1.currentProgress.."")
     
     self.Text_timeNum_nowday = ccui.Helper:seekWidgetByName(root, "Text_timeNum_nowday")
     self.Text_timeNum_nowday:setString("/"..self.activityInfos.task1.totalProgress)

    -- 当前天数
	self.Text_timeNow = ccui.Helper:seekWidgetByName(root, "Text_timeNow")
	self.Text_timeNow:setString(string.format(tipStringInfo_seven_days_recharge_tips[5],self.activityInfos.activityDay..""))

    self.Image_tab_redplace = ccui.Helper:seekWidgetByName(root, "Image_tab_redplace")
    self.Image_tab_redplace_one = ccui.Helper:seekWidgetByName(root, "Image_tab_redplace_one")

	self:changeToPage(1)
	self:refushRedPlot()
end

function SevenDaysRechargeWindow:onUpdate(dt)
    if self.Text_time == nil and nil == self.activityInfos then
        return
    end

    local activity = self.activityInfos
    local surplus_time = (activity.endTime - ((os.time() + _ED.time_add_or_sub))*1000)
    self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function SevenDaysRechargeWindow:drawTime(_time)
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

function SevenDaysRechargeWindow:showExtReward()
    local listViewReward = self.ListView_reward_up
    listViewReward:removeAllItems()
    local extRewadData = dms.searchs(dms["top_up_consecutive_seven_days"], top_up_consecutive_seven_days_mould.ext_type, 1)

    local idx = 1
    for i, v in ipairs(extRewadData) do
        local infos = {}
        infos.days =  tonumber(dms.string(extRewadData, idx, top_up_consecutive_seven_days_mould.aim_val))
        local rewardDatas = dms.string(extRewadData, idx, top_up_consecutive_seven_days_mould.reward_contents)
        infos.propDatas = zstring.split(zstring.split(rewardDatas, "|")[1],",")

        local cell = state_machine.excute("seven_days_recharge_item_create", 0, {infos})
        listViewReward:addChild(cell)
        idx = idx + 1
    end

    listViewReward:jumpToTop()
    listViewReward:requestRefreshView()
end

function SevenDaysRechargeWindow:refushPage()
    self.activityInfos = _ED.seven_day_recharge_infos
	if self.currentPage == 1 then 
		self:showTabDays()
	else
		self:showTabRecharge()
	end
end

function SevenDaysRechargeWindow:changeToPage(page)
    local root = self.roots[1]
    if page == self.currentPage then
        return
    end
    self.activityInfos = _ED.seven_day_recharge_infos
    self.currentPage = page
    local listViewTab = nil
    self.Panel_tab_1:setVisible(false)
    self.Panel_tab_2:setVisible(false)
    if page == 1 then
        self.Button_tab_comb:setTouchEnabled(false)
        self.Button_tab_comb:setHighlighted(false)
        self.Button_tab_sum_one:setTouchEnabled(true)
        self.Button_tab_sum_one:setHighlighted(true)

		self.Panel_tab_1:setVisible(true)
		self:showExtReward()
        self:showTabDays()

    elseif page == 2 then
        self.Button_tab_comb:setTouchEnabled(true)
        self.Button_tab_comb:setHighlighted(true)
        self.Button_tab_sum_one:setTouchEnabled(false)
        self.Button_tab_sum_one:setHighlighted(false)

        self.Panel_tab_2:setVisible(true)
        self:showTabRecharge()
    end
end

function SevenDaysRechargeWindow:showTabDays()
    local listViewTab = self.ListView_comb_recharge_1
    listViewTab:removeAllItems()

    local totalProgress = tonumber(self.activityInfos.task1.totalProgress)
    local taskDatas = {}
    for i = 1, totalProgress do
        local tempData = self.activityInfos.task1[tostring(i - 1)]
        table.insert(taskDatas, tempData)
    end
    taskDatas = self:sortListItems(taskDatas)

    for i = 1, totalProgress do
        local daysInfos = taskDatas[i]
        daysInfos.mType = 0
        daysInfos.signDays = tonumber(self.activityInfos.task1.currentProgress)
        local cell = state_machine.excute("seven_days_recharge_reward_list_create", 0, {daysInfos})
        listViewTab:addChild(cell)
    end
    listViewTab:jumpToTop()
    listViewTab:requestRefreshView()
end

function SevenDaysRechargeWindow:showTabRecharge()
    local listViewTab = self.ListView_comb_recharge_1_0
    listViewTab:removeAllItems()
    local rechargeData = dms.searchs(dms["top_up_consecutive_seven_days"], top_up_consecutive_seven_days_mould.reward_type, 2)
    local totalProgress = tonumber(self.activityInfos.task2.totalProgress)
    local taskDatas = {}
    for i = 1, totalProgress do
        local tempData = self.activityInfos.task2[tostring(i - 1)]
        table.insert(taskDatas, tempData)
    end
    taskDatas = self:sortListItems(taskDatas)

    for i = 1, totalProgress do
        local rechargeInfos = taskDatas[i]
        rechargeInfos.mType = 1
        rechargeInfos.rechargeNums = tonumber(self.activityInfos.task2.currentProgress)
        local cell = state_machine.excute("seven_days_recharge_reward_list_create", 0, {rechargeInfos})
        listViewTab:addChild(cell)
    end

    listViewTab:jumpToTop()
    listViewTab:requestRefreshView()
end

function SevenDaysRechargeWindow:refushRedPlot()
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_days_recharge_page_push",
            _widget = self.Image_tab_redplace,
            _invoke = nil,
            _pageIndex = 1,
			_interval = 0.5,})

	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_days_recharge_page_push",
	_widget = self.Image_tab_redplace_one,
	_invoke = nil,
	_pageIndex = 2,
	_interval = 0.5,})

end

function SevenDaysRechargeWindow:sortListItems(items)
    local result = {}
    local closeItems = {} -- 已领取
    local drawItems = {} -- 可领取
    local unGetItems = {} -- 未达到

    for k, v in pairs(items) do
        if 1 == tonumber(v.status) then -- 可领取
            table.insert(drawItems, v)
        elseif 2 == tonumber(v.status) then -- 已领取
            table.insert(closeItems, v)
        else
            table.insert(unGetItems, v)
        end
    end
    for k, v in pairs(drawItems) do
        table.insert(result, v)
    end
    for k, v in pairs(unGetItems) do
        table.insert(result, v)
    end
    for k, v in pairs(closeItems) do
        table.insert(result, v)
    end

    return result
end

function SevenDaysRechargeWindow:onEnterTransitionFinish()
    -- 加载SevenDaysRechargeWindowWindow界面资源.
    local csbNode = csb.createNode("activity/sevenday_recharge/sevenday_recharge.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self.activityInfos = _ED.seven_day_recharge_infos
    -- 查看七日连充分页
    self.Button_tab_comb =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_comb"),
        nil,
        {
            terminal_name = "seven_days_recharge_change_page",
			terminal_state = 0,
			m_page = 1,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 查看七日累充分页
    self.Button_tab_sum_one =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_sum_one"),
        nil,
        {
            terminal_name = "seven_days_recharge_change_page",
			terminal_state = 0,
			m_page = 2,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 查看帮助
    self.Button_help =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_help"),
        nil,
        {
            terminal_name = "seven_days_recharge_rule_window_open",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 關閉
    self.Button_closed =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "seven_days_recharge_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function SevenDaysRechargeWindow:onExit()
    -- 释放SevenDaysRechargeWindowWindow界面资源.
    state_machine.remove("seven_days_recharge_open")
    state_machine.remove("seven_days_recharge_close")
    state_machine.remove("seven_days_recharge_show")
	state_machine.remove("seven_days_recharge_hide")
	state_machine.remove("seven_days_recharge_refush")
	state_machine.remove("seven_days_recharge_change_page")
	state_machine.remove("seven_days_recharge_change_red_plot_tip_page")
end

function SevenDaysRechargeWindow:close()
    -- window event : close.
end

function SevenDaysRechargeWindow:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
