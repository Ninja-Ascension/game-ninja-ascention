--[[ ----------------------------------------------------------------------------
-- 半月礼活动
--]] ----------------------------------------------------------------------------

ActivityMonthGift = class("ActivityMonthGiftClass", Window)

-- 打开窗口
local activity_month_gift_open_terminal = {
    _name = "activity_month_gift_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityMonthGiftClass") then
            fwin:open(ActivityMonthGift:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local activity_month_gift_close_terminal = {
    _name = "activity_month_gift_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityMonthGiftClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_month_gift_open_terminal)
state_machine.add(activity_month_gift_close_terminal)
state_machine.init()

-- 构造器
function ActivityMonthGift:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    -- 活动数据
    self.activity_info = nil

    -- 索引
    self.page_index = 0

    -- 当前选中的按钮数据
    self.current_button = nil

    -- 剩余时间lab
    self.Text_month_time = nil

    -- 开始刷新的时间点
    self.__elapsed = 1

    -- 刷新时间间隔
    self.__duration = 1

    -- 等级是否足够
    self.is_enough_lv = false

    -- 天数是否足够
    self.is_enough_login_days = false

    -- 是否已经过期
    self.activity_is_over = false
    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_month_gift_terminal()
        -- 页签按钮1
        local activity_month_gift_onclick_btn_1_terminal = {
            _name = "activity_month_gift_onclick_btn_1",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self.page_index = 0
                self:changeButtonViewState(params._datas._button, self.page_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 页签按钮2
        local activity_month_gift_onclick_btn_2_terminal = {
            _name = "activity_month_gift_onclick_btn_2",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self.page_index = 1
                self:changeButtonViewState(params._datas._button, self.page_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 页签按钮3
        local activity_month_gift_onclick_btn_3_terminal = {
            _name = "activity_month_gift_onclick_btn_3",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self.page_index = 2
                self:changeButtonViewState(params._datas._button, self.page_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 页签按钮4
        local activity_month_gift_onclick_btn_4_terminal = {
            _name = "activity_month_gift_onclick_btn_4",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self.page_index = 3
                self:changeButtonViewState(params._datas._button, self.page_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开规则界面
        local activity_month_gift_open_rule_terminal = {
            _name = "activity_month_gift_open_rule",
            _init = function(terminal)
                app.load("client.activity.wonderful.ActivityMonthGiftRule")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("activity_month_gift_rule_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取奖励
        local activity_month_gift_get_reward_terminal = {
            _name = "activity_month_gift_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.activity_is_over == true then
                    TipDlg.drawTextDailog(tipStringInfo_activity_month_gift_word[8])
                else
                    if self.is_enough_lv == true and self.is_enough_login_days == true then
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd, fwin._ui)

                                state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 175)
                                self:updateAll()
                            end
                        end

                        protocol_command.half_the_ritual_get_reward.param_list = "" .. self.page_index .. "\r\n"
                        NetworkManager:register(protocol_command.half_the_ritual_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                    elseif self.is_enough_lv == false and self.is_enough_login_days == true then
                        TipDlg.drawTextDailog(tipStringInfo_activity_month_gift_word[6])
                    elseif self.is_enough_lv == true and self.is_enough_login_days == false then
                        TipDlg.drawTextDailog(tipStringInfo_activity_month_gift_word[5])
                    elseif self.is_enough_lv == false and self.is_enough_login_days == false then
                        TipDlg.drawTextDailog(tipStringInfo_activity_month_gift_word[4])
                    end
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_month_gift_onclick_btn_1_terminal)
        state_machine.add(activity_month_gift_onclick_btn_2_terminal)
        state_machine.add(activity_month_gift_onclick_btn_3_terminal)
        state_machine.add(activity_month_gift_onclick_btn_4_terminal)
        state_machine.add(activity_month_gift_open_rule_terminal)
        state_machine.add(activity_month_gift_get_reward_terminal)
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_month_gift_terminal()
end

-- 对象初始化
function ActivityMonthGift:init()
    local activity_info = _ED.active_activity[175].activityInitData
    if activity_info ~= nil then
        self.activity_info = activity_info
    end
    return self
end

-- 倒计时
function ActivityMonthGift:updateRemainTime()
    if self.Text_month_time == nil then
        return
    end

    local dayInfo = self.activity_info.dayInfo
    local endTime = dayInfo[self.page_index + 1].endTime
    if tonumber(endTime) > 0 then
        local diff_time = difftime(tonumber(endTime))
        self.activity_is_over = diff_time < 0
        local msg = diff_time < 0 and _string_piece_info[305] or formatTimeInterval(diff_time, {day = tipStringInfo_mine_info[4], hour = ":", minute = ":", second = ""}).info
        self.Text_month_time:setString(msg)
    end
end

-- 红点推送
function ActivityMonthGift:checkNotification(page_index)
    local success = false
    local dayInfo = self.activity_info.dayInfo
    local status = dayInfo[page_index].status
    if status == 1 then
        success = true
    end
    return success
end

-- 红点推送
function ActivityMonthGift:redNotification()
    local pics = {
        red_pic_1 = {pic_info = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_1"), page_index = 1},
        red_pic_2 = {pic_info = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_2"), page_index = 2},
        red_pic_3 = {pic_info = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_3"), page_index = 3},
        red_pic_4 = {pic_info = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_4"), page_index = 4}
    }

    for k, pic in pairs(pics) do
        pic.pic_info:setVisible(self:checkNotification(pic.page_index))
    end
end

function ActivityMonthGift:updateAll()
    self:init()
    self:onUpdateDraw()
    self:updateButtonState()
    self:redNotification()
end

function ActivityMonthGift:onUpdateDraw()
    local root = self.roots[1]

    if self.activity_info ~= nil then
        local dayInfo = self.activity_info.dayInfo

        -- 领取级别
        local needLevel = dayInfo[self.page_index + 1].needLevel
        local Text_level = ccui.Helper:seekWidgetByName(self.roots[1], "Text_level")
        Text_level:setString(needLevel)

        -- 奖励绘图
        local reward_str = dayInfo[self.page_index + 1].rewardInfo
        local ListView_2 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_2")
        ListView_2:removeAllItems()
        if #reward_str > 0 then
            local cells = DrawHandle.drawIcons(reward_str)
            for i = 1, #cells do
                ListView_2:addChild(cells[i])
            end
            ListView_2:requestRefreshView()
        end

        -- 累计登陆
        local Text_days = ccui.Helper:seekWidgetByName(self.roots[1], "Text_days")
        local currentLoginDay = dayInfo[self.page_index + 1].currentLoginDay
        Text_days:setString(string.format(tipStringInfo_activity_month_gift_word[1], tonumber(currentLoginDay)))

        -- 剩余时间
        local Text_month_time = ccui.Helper:seekWidgetByName(root, "Text_month_time")
        self.Text_month_time = Text_month_time

        -- 底图
        local Panel_month_gift_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_month_gift_bg")
        Panel_month_gift_bg:setBackGroundImage(string.format("images/ui/text/sm_hd/monthGift/monthGiftBG_%s.png", self.page_index + 1))

        -- 领取按钮文字
        local Text_go = ccui.Helper:seekWidgetByName(self.roots[1], "Text_go")
        local status = dayInfo[self.page_index + 1].status
        Text_go:setString(status == 2 and tipStringInfo_activity_month_gift_word[3] or tipStringInfo_activity_month_gift_word[2])
        local dayInfo = self.activity_info.dayInfo
        local endTime = dayInfo[self.page_index + 1].endTime
        if tonumber(endTime) > 0 then
            local diff_time = difftime(tonumber(endTime))
            if diff_time < 0 then
                Text_go:setString(tipStringInfo_activity_month_gift_word[7])
            end
        end

        -- 需要的天数
        local needDay = dayInfo[self.page_index + 1].needDay
        local Text_need_days = ccui.Helper:seekWidgetByName(self.roots[1], "Text_need_days")
        Text_need_days:setString("/" .. string.format(tipStringInfo_activity_month_gift_word[1], tonumber(needDay)))
    end
end

function ActivityMonthGift:updateButtonState()
    local dayInfo = self.activity_info.dayInfo
    local status = dayInfo[self.page_index + 1].status
    local Button_collect = ccui.Helper:seekWidgetByName(self.roots[1], "Button_collect")
    Button_collect:setTouchEnabled(status < 2)
    Button_collect:setBright(status == 1)

    local needDay = dayInfo[self.page_index + 1].needDay
    local hasLogin = self.activity_info.hasLogin
    self.is_enough_login_days = hasLogin >= needDay

    local user_level = tonumber(_ED.user_info.user_grade)
    local needLevel = dayInfo[self.page_index + 1].needLevel
    self.is_enough_lv = user_level >= needLevel
end

function ActivityMonthGift:buttonAddClickEvent()
    -- 关闭按钮
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "activity_month_gift_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 页签按钮1
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_1"),
        nil,
        {
            terminal_name = "activity_month_gift_onclick_btn_1",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _button = ccui.Helper:seekWidgetByName(root, "Button_tab_1")
        },
        nil,
        0
    )

    -- 页签按钮2
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_2"),
        nil,
        {
            terminal_name = "activity_month_gift_onclick_btn_2",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _button = ccui.Helper:seekWidgetByName(root, "Button_tab_2")
        },
        nil,
        0
    )

    -- 页签按钮3
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_3"),
        nil,
        {
            terminal_name = "activity_month_gift_onclick_btn_3",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _button = ccui.Helper:seekWidgetByName(root, "Button_tab_3")
        },
        nil,
        0
    )

    -- 页签按钮4
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_4"),
        nil,
        {
            terminal_name = "activity_month_gift_onclick_btn_4",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _button = ccui.Helper:seekWidgetByName(root, "Button_tab_4")
        },
        nil,
        0
    )

    -- 规则按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_rule"),
        nil,
        {
            terminal_name = "activity_month_gift_open_rule",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 领取按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_collect"),
        nil,
        {
            terminal_name = "activity_month_gift_get_reward",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function ActivityMonthGift:changeButtonViewState(button, page_index)
    button:setHighlighted(true)

    if button == self.current_button then
        return
    end

    if self.current_button ~= nil then
        self.current_button:setHighlighted(false)
    end
    self.current_button = button

    self:updateAll()
end

function ActivityMonthGift:changeTo(page_index)
    local root = self.roots[1]
    if page_index == 0 then
        state_machine.excute("activity_month_gift_onclick_btn_1", 0, {_datas = {_button = ccui.Helper:seekWidgetByName(root, "Button_tab_1")}})
    elseif page_index == 1 then
        state_machine.excute("activity_month_gift_onclick_btn_2", 0, {_datas = {_button = ccui.Helper:seekWidgetByName(root, "Button_tab_2")}})
    elseif page_index == 2 then
        state_machine.excute("activity_month_gift_onclick_btn_3", 0, {_datas = {_button = ccui.Helper:seekWidgetByName(root, "Button_tab_3")}})
    elseif page_index == 3 then
        state_machine.excute("activity_month_gift_onclick_btn_4", 0, {_datas = {_button = ccui.Helper:seekWidgetByName(root, "Button_tab_4")}})
    end
end

function ActivityMonthGift:onEnterTransitionFinish()
    -- 加载ActivityMonthGift界面资源.
    local csbNode = csb.createNode("activity/wonderful/activity_month_gift.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:updateAll()
    self:buttonAddClickEvent()

    self:changeTo(self.page_index)
end

function ActivityMonthGift:onUpdate(dt)
    if self.Text_month_time ~= nil then
        self.__elapsed = self.__elapsed + dt
        if (self.__elapsed >= self.__duration) then
            self.__elapsed = self.__elapsed - self.__duration
            self:updateRemainTime()
        end
    end
end

function ActivityMonthGift:onExit()
    state_machine.remove("activity_month_gift_onclick_btn_1")
    state_machine.remove("activity_month_gift_onclick_btn_2")
    state_machine.remove("activity_month_gift_onclick_btn_3")
    state_machine.remove("activity_month_gift_onclick_btn_4")
    state_machine.remove("activity_month_gift_open_rule")
    state_machine.remove("activity_month_gift_get_reward")
end

function ActivityMonthGift:close()
end

function ActivityMonthGift:destroy(window)
end

-- ~END
-- ----------------------------------------------------------------------------
