-- ----------------------------------------------------------------------------------------------------
-- 说明：每日累计充值界面
-------------------------------------------------------------------------------------------------------
DayilyConsumeRechageMain = class("DayilyConsumeRechageMainClass", Window)
local dayily_consume_rechage_main_window_open_terminal = {
    _name = "dayily_consume_rechage_main_window_open",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("DayilyConsumeRechageMainClass") then
            local panel = DayilyConsumeRechageMain:new():init(params)
            fwin:open(panel, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local dayily_consume_rechage_main_window_close_terminal = {
    _name = "dayily_consume_rechage_main_window_close",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil ~= fwin:find("DayilyConsumeRechageMainClass") then
            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 106)
            fwin:close(fwin:find("DayilyConsumeRechageMainClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(dayily_consume_rechage_main_window_open_terminal)
state_machine.add(dayily_consume_rechage_main_window_close_terminal)
state_machine.init()

function DayilyConsumeRechageMain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.dailySignRewardIndex = 0       -- 每日签到奖励下标
    self.activityType = 0

    app.load("client.activity.dayily_consume_rechage.DayilyConsumeRechageRewardList")
    app.load("client.activity.dayily_consume_rechage.DailyConsumeRechargeRulePopup")
    local function init_dayily_consume_rechage_main_terminal()
        -- 显示界面
        local dayily_consume_rechage_main_display_terminal = {
            _name = "dayily_consume_rechage_main_display",
            _init = function(terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmSmokedEggsWindowWindow = fwin:find("DayilyConsumeRechageMainClass")
                if SmSmokedEggsWindowWindow ~= nil then
                    SmSmokedEggsWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local dayily_consume_rechage_main_hide_terminal = {
            _name = "dayily_consume_rechage_main_hide",
            _init = function(terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmSmokedEggsWindowWindow = fwin:find("DayilyConsumeRechageMainClass")
                if SmSmokedEggsWindowWindow ~= nil then
                    SmSmokedEggsWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领奖并刷新界面
        local dayily_consume_rechage_main_get_reward_terminal = {
            _name = "dayily_consume_rechage_main_get_reward",
            _init = function(terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    if TipDlg.drawStorageTipo() == false then
                        local rewardIndex = params._datas.rewardIndex
                        rewardIndex = rewardIndex == nil and instance.dailySignRewardIndex or rewardIndex
                        local function responseGetServerListCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    instance:onUpdateDraw()
                                end

                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd,fwin._ui)
                            end
                        end
                        local activityId = _ED.active_activity[instance.activityType].activity_id
                        protocol_command.get_activity_reward.param_list = "" .. activityId .. "\r\n" .. (tonumber(rewardIndex) - 1) .. "\r\n1"
                        NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                        return true
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(dayily_consume_rechage_main_display_terminal)
        state_machine.add(dayily_consume_rechage_main_hide_terminal)
        state_machine.add(dayily_consume_rechage_main_get_reward_terminal)
        state_machine.init()
    end
    init_dayily_consume_rechage_main_terminal()
end

function DayilyConsumeRechageMain:sortListItems(items)
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

function DayilyConsumeRechageMain:onUpdateDraw()
    local root = self.roots[1]
    self.activityType = 106
    local activity = _ED.active_activity[self.activityType]
    if activity ~= nil then
        local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
        -- 倒计时文本
        self._Text_32 = ccui.Helper:seekWidgetByName(root, "Text_32")
        if titleText ~= nil then
            titleText:setString(activity.activity_describe)
        end
        local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")

        self._end_time = tonumber(activity.end_time) / 1000

        rewardListView:removeAllItems()
        self.cacheListView = rewardListView

        local item_group = {}
        local infoLength = table.nums(activity.activity_Info)
        for i = 1, infoLength - 1 do
            local cell = nil
            cell = state_machine.excute("dayily_consume_rechage_reward_list_create", 0, {rewardInfo = activity.activity_Info[i], index = i})
            
            table.insert(item_group, cell)
        end
        -- 最后一个为每日签到奖励
        self:updateSignDailyButton(activity.activity_Info[infoLength])
        item_group = self:sortListItems(item_group)
        for k, cell in pairs(item_group) do
            self.cacheListView:addChild(cell)
        end
        self.cacheListView:requestRefreshView()
    end
end

-- 每日签到
function DayilyConsumeRechageMain:updateSignDailyButton(stateInfo)
    local activity = _ED.active_activity[self.activityType]
    local currPoint = zstring.tonumber(zstring.split(activity.activity_params, "|")[1])
    local max = tonumber(stateInfo.activityInfo_need_day)

    self.Button_4:setVisible(tonumber(stateInfo.activityInfo_isReward) == 0)
    self.dailySignRewardIndex = tonumber(stateInfo.index)

    local isShow = (currPoint >= max) and tonumber(stateInfo.activityInfo_isReward) == 0
    self:updateSignDailyRedDot(isShow)
end

function DayilyConsumeRechageMain:updateSignDailyRedDot(isShow)
    local widget = self.Button_4
    if isShow then
        if widget._istips == nil or widget._istips == false then
            local ball = cc.Sprite:create("images/ui/bar/tips.png")
            ball:setAnchorPoint(cc.p(1, 1))
            ball:setPosition(cc.p(widget:getContentSize().width-ball:getContentSize().width*0.5, widget:getContentSize().height-ball:getContentSize().height*0.5))
            widget:addChild(ball)
            widget._nodeChild = ball
            widget._istips = true
        end
    else
        if widget._istips == true then
            widget:removeChild(widget._nodeChild, true)
            widget._nodeChild = nil
            widget._istips = false
        end
    end 
end

function DayilyConsumeRechageMain:onUpdate(dt)
    if self._Text_32 ~= nil then
        local surplus_time = self._end_time - (os.time() + _ED.time_add_or_sub)
        self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time))
    end
end

function DayilyConsumeRechageMain:init(params)
    self:onInit()
    return self
end

function DayilyConsumeRechageMain:onInit()
    local csbNode = csb.createNode("activity/wonderful/daily_recharge.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 每日奖励领取按钮
    self.Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, {
        terminal_name = "dayily_consume_rechage_main_get_reward",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, nil, 0)

    -- 规则按钮
    self.Button_rule = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil, {
        terminal_name = "daily_consume_recharge_rule_popup_window_open",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    -- 关闭
    self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, {
        terminal_name = "dayily_consume_rechage_main_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, nil, 0)

    self:onUpdateDraw()

end

function DayilyConsumeRechageMain:onExit()
    state_machine.remove("dayily_consume_rechage_main_display")
    state_machine.remove("dayily_consume_rechage_main_hide")
    state_machine.remove("dayily_consume_rechage_main_get_reward")

end
