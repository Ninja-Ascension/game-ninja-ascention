----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日任务的管理器
-------------------------------------------------------------------------------------------------------
OpenCarnivalWindow = class("OpenCarnivalWindowClass", Window)

local open_carnival_window_open_terminal = {
    _name = "open_carnival_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("OpenCarnivalWindowClass") then
            fwin:open(OpenCarnivalWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local open_carnival_window_close_terminal = {
    _name = "open_carnival_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("OpenCarnivalWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(open_carnival_window_open_terminal)
state_machine.add(open_carnival_window_close_terminal)
state_machine.init()

function OpenCarnivalWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self._total_day = 1 -- 配置总天数
    self._achieve_cfg = {} -- 成就配置信息
    self._name_cfg = {} -- 人物类型标签文本配置
    self._select_day = 0 -- 当前选择天数
    self._select_type = 0 -- 当前选择类型
    self._day_cell_list = nil -- 天数cell
    self._total_time = 1 -- 倒计时总时间

    self.Text_time_1 = nil -- 倒计时
    app.load("client.activity.open_carnival.OpenCarnivalDayCell")
    app.load("client.activity.open_carnival.OpenCarnivalTaskCell")
    app.load("client.activity.open_carnival.OpenCarnivalAchieveCell")
    app.load("client.activity.open_carnival.OpenCarnivalRule")
    app.load("client.cells.utils.resources_icon_cell")
    -- Initialize seven days activity for every day manager page state machine.
    local function init_open_carnival_window_terminal()
        -- 领取奖励
        local open_carnival_window_get_reward_terminal = {
            _name = "open_carnival_window_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("open_carnival_window_get_reward")
                local mDays = params._datas.m_day
                local mType = params._datas.m_type
                local mIdx = params._datas.m_idx

                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and response.node ~= nil and response.node.roots[1] ~= nil then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(47)
                        fwin:open(getRewardWnd, fwin._ui)
                        if mDays == instance._total_day then
                        else
                            -- 任务奖励刷新
                            instance:drawAchieve(true)
                            instance:drawDayRed()
                            instance:drawTypeRed()
                        end
                        -- 阶段奖励刷新
                        instance:drawRateReward()
                    end
                    state_machine.unlock("open_carnival_window_get_reward")
                end
                protocol_command.draw_activity_reward.param_list = "194" .. "\r\n" .. mDays .. "\r\n" .. mType .. "\r\n" .. mIdx
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseDrawWeekRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 天数切换
        local open_carnival_window_change_day_terminal = {
            _name = "open_carnival_window_change_day",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mDay = params._datas.m_day
                if instance ~= nil then
                    instance:drawDayList(mDay)
                    instance:drawAchieve()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 类型切换
        local open_carnival_window_change_type_terminal = {
            _name = "open_carnival_window_change_type",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mType = params._datas.m_type
                if instance ~= nil then
                    instance:drawTypeList(mType)
                    instance:drawAchieve()
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        -- 任务完成刷新
        local open_carnival_window_refrush_view_terminal = {
            _name = "open_carnival_window_refrush_view",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    -- 任务奖励刷新
                    instance:drawAchieve(true)
                    instance:drawDayRed()
                    instance:drawTypeRed()
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(open_carnival_window_get_reward_terminal)
        state_machine.add(open_carnival_window_change_day_terminal)
        state_machine.add(open_carnival_window_change_type_terminal)
        state_machine.add(open_carnival_window_refrush_view_terminal)
        state_machine.init()
    end

    -- call func init seven days activity for every day manager state machine.
    init_open_carnival_window_terminal()
end

function OpenCarnivalWindow:onUpdate(dt)
    if self._total_time ~= nil then
        self._total_time = self._total_time + dt
        if self._total_time > 1 then
            self._total_time = 0
            self:updateDrawActivityTime()
        end
    end
end

function OpenCarnivalWindow:updateDrawActivityTime()
    local root = self.roots[1]
    if root == nil or _ED.active_activity[194] == nil then
        return
    end
    local activity = _ED.active_activity[194]
    local current_time = _ED.system_time + (os.time() - _ED.native_time)
    local surplus_time = activity.activity_end_time / 1000 - current_time
    self.Text_time_1:setString(getRedAlertTimeActivityFormat(surplus_time))
    if surplus_time <= 0 then
        _ED.active_activity[194] = nil
        state_machine.excute("home_update_top_activity_info_state", 0, nil)
        fwin:addService({
            callback = function ( params )
                state_machine.excute("open_carnival_window_close", 0, nil)
            end,
            delay = 0.1,
        })
    end
end

function OpenCarnivalWindow:onEnterTransitionFinish()
end

function OpenCarnivalWindow:onUpdateDraw()
    local root = self.roots[1]
    -- 倒计时文字
    self.Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")
    -- 进度文字
    self.Text_rate = ccui.Helper:seekWidgetByName(root, "Text_rate")
    -- 进度条
    self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    -- 天数列表
    self.ListView_day = ccui.Helper:seekWidgetByName(root, "ListView_day")
    -- 任务列表
    self.ListView_task = ccui.Helper:seekWidgetByName(root, "ListView_task")
    -- 任务类型页签列表
    self.ListView_tab = ccui.Helper:seekWidgetByName(root, "ListView_tab")
    -- 进度奖励控件
    self.Panel_final_reward = {}
    self.Image_gray = {}
    self.Panel_final_effect = {}
    self.Text_final = {}
    for i = 1, 7 do
        self.Panel_final_reward[i] = ccui.Helper:seekWidgetByName(root, "Panel_final_reward_" .. i)
        self.Image_gray[i] = ccui.Helper:seekWidgetByName(root, "Image_gray_" .. i)
        self.Panel_final_effect[i] = ccui.Helper:seekWidgetByName(root, "Panel_final_effect_" .. i)
        self.Text_final[i] = ccui.Helper:seekWidgetByName(root, "Text_final_" .. i)
        fwin:addTouchEventListener(
            self.Panel_final_reward[i],
            nil,
            {
                terminal_name = "open_carnival_window_get_reward",
                terminal_state = 0,
                isPressedActionEnabled = true,
                m_day = self._total_day,
                m_type = 1,
                m_idx = i
            },
            nil,
            0
        )
    end
end

-- 可领取奖励动画
function OpenCarnivalWindow:showGetEffect(sender)
    local childs = sender:getChildren()
    if #childs < 1 then
        sender:removeAllChildren(true)
        local jsonFile = "sprite/sprite_wzkp.json"
        local atlasFile = "sprite/sprite_wzkp.atlas"
        if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
            local spineNode = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            spineNode:setPosition(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
            sender:addChild(spineNode)
        end
    end
    sender:setVisible(true)
end

-- 阶段奖励图标绘制
function OpenCarnivalWindow:drawRateRewardIcon()
    local rateConfigs = self._achieve_cfg[self._total_day][1] -- 阶段奖励配置信息
    for i, v in ipairs(rateConfigs) do
        local achieveId = v
        self.Panel_final_reward[i]:removeAllChildren(true)
        local tempReward = zstring.split(dms.string(dms["achieve"], achieveId, achieve.reward_value), "|")[1]
        local cell = DrawHandle.drawIcon(tempReward)
        self.Panel_final_reward[i]:addChild(cell)
    end
end

-- 阶段奖励绘制
function OpenCarnivalWindow:drawRateReward()
    local rateConfigs = self._achieve_cfg[self._total_day][1] -- 阶段奖励配置信息
    local rateInfo = _ED.active_activity[194].activity_init_info[self._total_day] -- 奖励状态
    local curNums = 0
    local aimNums = 0
    local aimList = {}
    local curStage = 0

    -- 奖励图标状态
    for i, v in ipairs(rateConfigs) do
        local rateData = rateInfo[v .. ""]
        local nowpersent = rateData.complete
        curNums = nowpersent
        local achieveId = v
        local dailyTaskMould = dms.element(dms["achieve"], achieveId)
        local param2 = dms.atoi(dailyTaskMould, achieve.param2)
        local maxpersent = param2
        
        aimNums = maxpersent
        aimList[i] = maxpersent
        self.Image_gray[i]:setVisible(false)
        self.Panel_final_effect[i]:setVisible(false)
        self.Panel_final_reward[i]:setTouchEnabled(false)
        if tonumber(rateData.status) == 2 then
            -- 已领取
            self.Image_gray[i]:setVisible(true)
            curStage = i
        elseif tonumber(rateData.status) == 1 then
            -- 可领取
            self:showGetEffect(self.Panel_final_effect[i])
            self.Panel_final_reward[i]:setTouchEnabled(true)
            curStage = i
        end
    end
    local curPercent = 0
    if curStage == #aimList then
        -- 全部达成
        curPercent = 1
    else
        local lastNum = 0
        if curStage > 0 then -- 阶段奖励已领取
            for i = 1, curStage do
                lastNum = aimList[i]
            end
        end
        
        local perPercent = 1 / #aimList -- 每个阶段的百分比
        local basePercent = perPercent * curStage
        local totalPoint = aimList[curStage + 1] - lastNum
        local curPoint = curNums - lastNum
        curPercent = basePercent + (perPercent * (curPoint / totalPoint))
    end

    -- 进度条绘制
    local percent = curPercent * 100
    self.LoadingBar_1:setPercent(percent)
    self.Text_rate:setString(curNums)

    for i,v in ipairs(self.Text_final) do 
        v:setString(aimList[i])
    end
end

-- 天数列表绘制
function OpenCarnivalWindow:drawDayList(curDay)
    if self._select_day == curDay then
        return
    end
    local totalDay = self._total_day - 1 -- 任务总天数
    self._select_day = curDay > totalDay and totalDay or curDay
    -- 按钮切换
    if self._day_cell_list == nil then
        self._day_cell_list = {}
        self.ListView_day:removeAllItems()
        for i = 1, totalDay do
            local cell = state_machine.excute("open_carnival_day_cell_create", 0, {i, self._select_day})
            self.ListView_day:addChild(cell)
            self._day_cell_list[i] = cell
        end
        self.ListView_day:jumpToTop()
        self.ListView_day:requestRefreshView()
    else
        for i, v in ipairs(self._day_cell_list) do
            local isSelect = i == self._select_day
            v:onRefrushBtn(isSelect)
        end
    end
    self:drawTypeList(1)
    self:drawTypeRed()
end

-- 天数红点绘制
function OpenCarnivalWindow:drawDayRed()
    local rewardInfo = _ED.active_activity[194].activity_init_info -- 奖励状态
    local openDay = _ED.active_activity[194].activity_cur_day
    for i, v in ipairs(self._day_cell_list) do
        local curTypeInfo = self._achieve_cfg[i]
        local totalType = #curTypeInfo
        local isShow = false
        local isFinish = true
        for m = 1, totalType do
            local dayConfigs = self._achieve_cfg[i][m]
            for n, achieveid in ipairs(dayConfigs) do
                local achieveInfo = rewardInfo[i][achieveid .. ""]
                if not isShow and openDay >= i and tonumber(achieveInfo.status) == 1 then
                    isShow = true
                end

                if isFinish and tonumber(achieveInfo.status) ~= 2 then
                    isFinish = false
                end
            end
            if isShow and not isFinish then
                break
            end
        end
        v:showRedTip(isShow)
        v:showFinishTip(isFinish)
    end
end

-- 任务类型列表绘制
function OpenCarnivalWindow:drawTypeList(curType)
    self._select_type = curType
    local curTypeInfo = self._achieve_cfg[self._select_day]
    local totalType = #curTypeInfo -- 任务类型总数
    local nameInfo = self._name_cfg[self._select_day] -- 任务类型名称
    -- 按钮切换
    self._type_cell_list = {}
    self.ListView_tab:removeAllItems()
    for i = 1, totalType do
        local cell = state_machine.excute("open_carnival_task_cell_create", 0, {i, self._select_type, nameInfo[i]})
        self.ListView_tab:addChild(cell)
        self._type_cell_list[i] = cell
    end
    self.ListView_tab:jumpToLeft()
    self.ListView_tab:requestRefreshView()
end

-- 任务类型红点绘制
function OpenCarnivalWindow:drawTypeRed()
    local rewardInfo = _ED.active_activity[194].activity_init_info -- 奖励状态
    local openDay = _ED.active_activity[194].activity_cur_day
    for i, v in ipairs(self._type_cell_list) do
        local dayConfigs = self._achieve_cfg[self._select_day][i]
        local isShow = false
        for n, achieveid in ipairs(dayConfigs) do
            local achieveInfo = rewardInfo[self._select_day][achieveid .. ""]
            if openDay >= self._select_day and tonumber(achieveInfo.status) == 1 then
                isShow = true
                break
            end
        end
        v:showRedTip(isShow)
    end
end

-- 成就任务列表绘制 isboolen:是否是刷新
function OpenCarnivalWindow:drawAchieve(isboolen)
    local curDay = self._select_day
    local curType = self._select_type
    local dayConfigs = self._achieve_cfg[curDay][curType] -- 当前天数当前类型奖励配置信息
    local dayInfo = _ED.active_activity[194].activity_init_info[curDay] -- 当天奖励状态
    local item_group = {}
    local listView = self.ListView_task
    listView:removeAllItems()
    for i, v in ipairs(dayConfigs) do
        local cell = state_machine.excute("open_carnival_achieve_cell_cell", 0, {{id = v, pageIndex = curType, drawIndex = i, dayIndex = curDay}})
        table.insert(item_group, cell)
    end
    item_group = self:sortListItems(item_group)
    local mm_index = 0
    for k, cell in pairs(item_group) do
        mm_index = mm_index + 1
        if isboolen ~= nil and isboolen == true then
            state_machine.excute("open_carnival_achieve_cell_set_number", 0, {cell, mm_index, isboolen})
            cell:setVisible(true)
        else
            state_machine.excute("open_carnival_achieve_cell_set_number", 0, {cell, mm_index})
            cell:setVisible(false)
            cell:setScale(1.3)
            cell:setAnchorPoint(cc.p(0.5, 0.5))
        end
        listView:addChild(cell)
    end
    listView:jumpToTop()
    listView:requestRefreshView()
end

function OpenCarnivalWindow:sortListItems(items)
    local result = {}
    local closeItems = {} -- 已完成
    local drawItems = {} -- 可领取
    local uncompItems = {} -- 未完成
    for k, v in pairs(items) do
        if tonumber(v.rewardState) == 0 then
            table.insert(uncompItems, v)
        elseif tonumber(v.rewardState) == 1 then
            table.insert(drawItems, v)
        else
            table.insert(closeItems, v)
        end
    end
    for k, v in pairs(drawItems) do
        table.insert(result, v)
    end
    for k, v in pairs(uncompItems) do
        table.insert(result, v)
    end
    for k, v in pairs(closeItems) do
        table.insert(result, v)
    end

    return result
end

-- 表数据获取
function OpenCarnivalWindow:handConfig()
    local counts = dms.count(dms["open_carnival_mould"])
    self._total_day = counts
    self._achieve_cfg = {} -- 成就配置
    self._name_cfg = {} -- 任务类型标签文本配置
    for i = 1, counts do
        local achieveIds = zstring.splits(dms.string(dms["open_carnival_mould"], i, open_carnival_mould.achieve_id), "|", ",")
        self._achieve_cfg[i] = achieveIds
        local nameCfg = dms.string(dms["open_carnival_mould"], i, open_carnival_mould.page_name)
        if nameCfg ~= "-1" then
            local nameIds = zstring.split(nameCfg, ",")
            self._name_cfg[i] = {}
            for k, v in ipairs(nameIds) do
                local word_info = dms.element(dms["word_mould"], v)
                local name = word_info[3]
                self._name_cfg[i][k] = name
            end
        end
    end
end

function OpenCarnivalWindow:onInit()
    local csbOpenCarnivalWindow = csb.createNode("activity/open_carnival/open_carnival.csb")
    local root = csbOpenCarnivalWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbOpenCarnivalWindow)

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "open_carnival_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_help"),
        nil,
        {
            terminal_name = "open_carnival_rule_window_open",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
    local activiyDay = _ED.active_activity[194].activity_cur_day
    self:handConfig()
    self:onUpdateDraw()
    self:drawRateRewardIcon()
    self:drawRateReward()
    self:drawDayList(activiyDay)
    self:drawAchieve()
    self:drawDayRed()
    self:drawTypeRed()
end

function OpenCarnivalWindow:init()
    if nil ~= self.onInit then
        self:onInit()
    end
    return self
end

function OpenCarnivalWindow:onExit()
    state_machine.remove("open_carnival_window_get_reward")
    state_machine.remove("open_carnival_window_change_day")
    state_machine.remove("open_carnival_window_change_type")
    state_machine.remove("open_carnival_window_refrush_view")
end
