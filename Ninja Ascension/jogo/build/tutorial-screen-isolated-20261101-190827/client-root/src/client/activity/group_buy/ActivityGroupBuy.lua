--[[ ----------------------------------------------------------------------------
-- 超值团购活动
--]] ----------------------------------------------------------------------------

ActivityGroupBuy = class("ActivityGroupBuyClass", Window)

-- 打开窗口
local activity_group_buy_open_terminal = {
    _name = "activity_group_buy_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityGroupBuyClass") then
            fwin:open(ActivityGroupBuy:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local activity_group_buy_close_terminal = {
    _name = "activity_group_buy_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityGroupBuyClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_open_terminal)
state_machine.add(activity_group_buy_close_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuy:ctor()
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

    -- 开始刷新的时间点
    self.__elapsed = 1

    -- 刷新时间间隔
    self.__duration = 1

    self.item_infos = {}

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------
    app.load("client.activity.group_buy.ActivityGroupBuyCell0")
    app.load("client.activity.group_buy.ActivityGroupBuyCell")
    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_terminal()
        -- 团购礼包按钮
        local activity_group_buy_onclick_btn_1_terminal = {
            _name = "activity_group_buy_onclick_btn_1",
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

        -- 充值团购按钮
        local activity_group_buy_onclick_btn_2_terminal = {
            _name = "activity_group_buy_onclick_btn_2",
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

        -- 打开规则界面
        local activity_group_buy_open_rule_terminal = {
            _name = "activity_group_buy_open_rule",
            _init = function(terminal)
                app.load("client.activity.group_buy.ActivityGroupBuyRule")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("activity_group_buy_rule_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开奖励界面
        local activity_group_buy_open_main_reward_terminal = {
            _name = "activity_group_buy_open_main_reward",
            _init = function(terminal)
                app.load("client.activity.group_buy.ActivityGroupBuyMineReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("activity_group_buy_mine_reward_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新数据
        local activity_group_buy_refresh_all_terminal = {
            _name = "activity_group_buy_refresh_all",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateAll()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新红点
        local activity_group_buy_refresh_red_terminal = {
            _name = "activity_group_buy_refresh_red",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:redNotification()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_group_buy_onclick_btn_1_terminal)
        state_machine.add(activity_group_buy_onclick_btn_2_terminal)
        state_machine.add(activity_group_buy_open_rule_terminal)
        state_machine.add(activity_group_buy_open_main_reward_terminal)
        state_machine.add(activity_group_buy_refresh_all_terminal)
        state_machine.add(activity_group_buy_refresh_red_terminal)
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_terminal()
end

function ActivityGroupBuy:changeButtonViewState(button, page_index)
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

function ActivityGroupBuy:changeTo(page_index)
    local root = self.roots[1]
    if page_index == 0 then
        state_machine.excute("activity_group_buy_onclick_btn_1", 0, {_datas = {_button = ccui.Helper:seekWidgetByName(root, "Button_tglb")}})
    elseif page_index == 1 then
        state_machine.excute("activity_group_buy_onclick_btn_2", 0, {_datas = {_button = ccui.Helper:seekWidgetByName(root, "Button_cztg")}})
    end
end

-- 对象初始化
function ActivityGroupBuy:init()
    local activity_info = _ED.active_activity[176].activityAllData
    if activity_info ~= nil then
        self.activity_info = activity_info
    end
    return self
end

function ActivityGroupBuy:buttonAddClickEvent()
    -- 关闭按钮
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "activity_group_buy_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 团购礼包按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tglb"),
        nil,
        {
            terminal_name = "activity_group_buy_onclick_btn_1",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _button = ccui.Helper:seekWidgetByName(root, "Button_tglb")
        },
        nil,
        0
    )

    -- 充值团购按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_cztg"),
        nil,
        {
            terminal_name = "activity_group_buy_onclick_btn_2",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _button = ccui.Helper:seekWidgetByName(root, "Button_cztg")
        },
        nil,
        0
    )

    -- 规则按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_help"),
        nil,
        {
            terminal_name = "activity_group_buy_open_rule",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 奖励按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_rewards"),
        nil,
        {
            terminal_name = "activity_group_buy_open_main_reward",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function ActivityGroupBuy:createCell()
    -- La pestana nueva puede venir vacia (la de recarga lo esta) y entonces no
    -- se llama a asyncCreateItem: hay que parar aqui el pintado de la anterior.
    self:stopAllActions()
    self.item_infos = {}
    self.ListView_1:removeAllItems()
    local datas = self.page_index == 0 and self.activity_info.activity_group_gift_info.info or self.activity_info.activity_top_up_info
    if self.page_index == 0 then
        local target_is_get = {}
        local target_no_get = {}
        local target = {}

        for k, v in pairs(datas) do
            if tonumber(v.todayBuyNumber) >= tonumber(v.limit) then
                table.insert(target_is_get, v)
            else
                table.insert(target_no_get, v)
            end
        end

        for i, v in ipairs(target_no_get) do
            table.insert(target, v)
        end

        for i, v in ipairs(target_is_get) do
            table.insert(target, v)
        end

        datas = target
    end

    if datas ~= nil and table.nums(datas) > 0 then
        for k, data in pairs(datas) do
            table.insert(self.item_infos, {_data = data})
        end

        self:asyncCreateItem()
    end
end

function ActivityGroupBuy:asyncCreateItem()
    local temp_info_items = self.item_infos
    local length = #self.item_infos
    self:stopAllActions()
    self:runAction(
        cc.Sequence:create(
            {
                cc.DelayTime:create(0.01),
                cc.CallFunc:create(
                    function(sender)
                        if (length > 0) then
                            local cell_info = temp_info_items[1]
                            length = length - 1
                            table.remove(self.item_infos, 1)
                            self:createItem(cell_info._data)
                            if #self.item_infos <= 0 then
                                self.ListView_1:requestRefreshView()
                            end
                        end

                        if (length > 0) then
                            self:asyncCreateItem()
                        end
                    end
                )
            }
        )
    )
end

function ActivityGroupBuy:createItem(_data, page_index)
    local root = self.roots[1]
    local cell = nil
    if self.page_index == 0 then
        cell = ActivityGroupBuyCell0:createCell()
    elseif self.page_index == 1 then
        cell = ActivityGroupBuyCell:createCell()
    end
    cell:init(_data)
    self.ListView_1:addChild(cell)
end

function ActivityGroupBuy:updateAll()
    self:onUpdateDraw()
    self:createCell()
    self:redNotification()
end

function ActivityGroupBuy:onUpdateDraw()
    local root = self.roots[1]

    if self.activity_info ~= nil then
        -- 剩余时间
        self.Text_time_discount = ccui.Helper:seekWidgetByName(root, "Text_time_discount")
        self.Text_time_end_time = ccui.Helper:seekWidgetByName(root, "Text_time_end_time")
        self.Text_time_end_time:setVisible(false)

        -- 列表容器
        self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

        -- 标题
        self.Image_text_1 = ccui.Helper:seekWidgetByName(root, "Image_text_1")
        self.Image_text_2 = ccui.Helper:seekWidgetByName(root, "Image_text_2")
        self.Image_title_1 = ccui.Helper:seekWidgetByName(root, "Image_title_1")
        self.Image_title_2 = ccui.Helper:seekWidgetByName(root, "Image_title_2")

        self.Image_text_1:setVisible(false)
        self.Image_text_2:setVisible(false)
        self.Image_title_1:setVisible(false)
        self.Image_title_2:setVisible(false)
        if self.page_index == 0 then
            self.Image_text_2:setVisible(true)
            self.Image_title_2:setVisible(true)
        else
            self.Image_text_1:setVisible(true)
            self.Image_title_1:setVisible(true)
        end

        local Panel_tglbJugment = ccui.Helper:seekWidgetByName(root, "Panel_tglbJugment")
        local Text_use = ccui.Helper:seekWidgetByName(root, "Text_use")
        local Text_return = ccui.Helper:seekWidgetByName(root, "Text_return")
        Panel_tglbJugment:setVisible(false)
        if self.page_index == 0 then
            Panel_tglbJugment:setVisible(true)
            local datas = self.activity_info.activity_group_gift_info
            Text_use:setString(datas.totalMoney)
            Text_return:setString(datas.currentBackMoney)
        end
    end
end

-- 红点推送检测
function ActivityGroupBuy:checkNotification()
    local success_1 = false
    local success_2 = false
    local datas_1 = _ED.active_activity[176].activityAllData.activity_server_group_buy_info
    local datas_2 = _ED.active_activity[176].activityAllData.activity_person_group_buy_info

    for k, v in pairs(datas_1.info) do
        if v.status == 1 then
            success_1 = true
            break
        end
    end

    for k, v in pairs(datas_2.info) do
        if v.status == 1 then
            success_2 = true
            break
        end
    end

    local success = success_1 or success_2
    return success
end

-- 红点推送检测2
function ActivityGroupBuy:checkNotification2()
    local success = false
    for k, v in pairs(self.activity_info.activity_top_up_info) do
        if v.canGetNumber > 0 then
            success = true
            break
        end
    end

    return success
end

-- 红点推送
function ActivityGroupBuy:redNotification()
    local Image_red = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red")
    Image_red:setVisible(self:checkNotification())

    local Image_red_group_buy = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_group_buy")
    Image_red_group_buy:setVisible(self:checkNotification2())
end

function ActivityGroupBuy:onEnterTransitionFinish()
    -- 加载ActivityGroupBuy界面资源.
    local csbNode = csb.createNode("activity/group_buy/group_buy.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:buttonAddClickEvent()
    self:changeTo(self.page_index)

    fwin:close(fwin:find("UserTopInfoAClass"))
    app.load("client.player.UserTopInfoA")
    fwin:open(UserTopInfoA:new(), fwin._ui)
end

-- 倒计时
function ActivityGroupBuy:updateRemainTime()
    if self.Text_time_discount == nil then
        return
    end

    local endTime = _ED.active_activity[176].activityAllData.activity_server_group_buy_info.realEndTime
    if tonumber(endTime) > 0 then
        local diff_time = difftime(tonumber(endTime))
        local msg = diff_time < 0 and _string_piece_info[305] or formatTimeInterval(diff_time, {day = tipStringInfo_mine_info[4], hour = ":", minute = ":", second = ""}).info
        self.Text_time_discount:setString(msg)
    end
end

-- 倒计时活动结束时间
function ActivityGroupBuy:updateRemainEndTime()
    if self.Text_time_end_time == nil then
        return
    end

    local endTime = _ED.active_activity[176].end_time
    local endTime2 = _ED.active_activity[176].activityAllData.activity_server_group_buy_info.realEndTime
    if tonumber(endTime2) < sstime() then
        if tonumber(endTime) > 0 then
            self.Text_time_end_time:setVisible(true)
            local diff_time = difftime(tonumber(endTime))
            local msg = diff_time < 0 and _string_piece_info[305] or formatTimeInterval(diff_time, {day = tipStringInfo_mine_info[4], hour = ":", minute = ":", second = ""}).info
            self.Text_time_end_time:setString(msg)
        end
    else
        self.Text_time_end_time:setVisible(false)
    end
end

function ActivityGroupBuy:onUpdate(dt)
    if self.Text_time_discount ~= nil then
        self.__elapsed = self.__elapsed + dt
        if (self.__elapsed >= self.__duration) then
            self.__elapsed = self.__elapsed - self.__duration
            self:updateRemainTime()
            self:updateRemainEndTime()
        end
    end
end

function ActivityGroupBuy:onExit()
    state_machine.remove("activity_group_buy_onclick_btn_1")
    state_machine.remove("activity_group_buy_onclick_btn_2")
    state_machine.remove("activity_group_buy_open_rule")
    state_machine.remove("activity_group_buy_open_main_reward")
    state_machine.remove("activity_group_buy_refresh_all")
    state_machine.remove("activity_group_buy_refresh_red")
end

function ActivityGroupBuy:close()
    fwin:close(fwin:find("UserTopInfoAClass"))
end

function ActivityGroupBuy:destroy(window)
end
