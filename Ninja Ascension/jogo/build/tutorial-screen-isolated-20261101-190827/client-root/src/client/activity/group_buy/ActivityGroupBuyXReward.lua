ActivityGroupBuyXReward = class("ActivityGroupBuyXRewardClass", Window)

-- 打开窗口
local activity_group_buy_x_reward_open_terminal = {
    _name = "activity_group_buy_x_reward_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityGroupBuyXRewardClass") then
            fwin:open(ActivityGroupBuyXReward:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local activity_group_buy_x_reward_close_terminal = {
    _name = "activity_group_buy_x_reward_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityGroupBuyXRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_x_reward_open_terminal)
state_machine.add(activity_group_buy_x_reward_close_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuyXReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    -- 活动数据
    self.activity_datas = nil

    -- 列表容器
    self.ListView_1 = nil

    self.item_infos = {}

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------
    app.load("client.activity.group_buy.ActivityGroupBuyXRewardCell")
    app.load("client.activity.group_buy.ActivityGroupBuyMineReward")
    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_x_reward_terminal()
        -- 全服团购按钮
        local activity_group_buy_x_reward_to_person_reward_terminal = {
            _name = "activity_group_buy_x_reward_to_person_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("activity_group_buy_x_reward_close", 0, nil)
                state_machine.excute("activity_group_buy_mine_reward_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新数据
        local activity_group_buy_x_reward_refresh_all_terminal = {
            _name = "activity_group_buy_x_reward_refresh_all",
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

        state_machine.add(activity_group_buy_x_reward_refresh_all_terminal)
        state_machine.add(activity_group_buy_x_reward_to_person_reward_terminal)
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_x_reward_terminal()
end

-- 对象初始化
function ActivityGroupBuyXReward:init()
    local activity_datas = _ED.active_activity[176].activityAllData.activity_server_group_buy_info
    if activity_datas ~= nil then
        self.activity_datas = activity_datas
    end
    return self
end

function ActivityGroupBuyXReward:buttonAddClickEvent()
    -- 关闭按钮
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "activity_group_buy_x_reward_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 个人团购奖励按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_mine"),
        nil,
        {
            terminal_name = "activity_group_buy_x_reward_to_person_reward",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function ActivityGroupBuyXReward:createItem()
    self.item_infos = {}
    self.ListView_1:removeAllItems()
    local datas = self.activity_datas.info
    local target_is_get = {}
    local target_no_get = {}
    local target_get = {}
    local target = {}

    for k, v in pairs(datas) do
        if v.status == 1 then
            table.insert(target_is_get, v)
        elseif v.status == 0 then
            table.insert(target_no_get, v)
        elseif v.status == 2 then
            table.insert(target_get, v)
        end
    end

    for i, v in ipairs(target_is_get) do
        table.insert(target, v)
    end

    for i, v in ipairs(target_no_get) do
        table.insert(target, v)
    end

    for i, v in ipairs(target_get) do
        table.insert(target, v)
    end

    if target ~= nil and table.nums(target) > 0 then
        for k, data in pairs(target) do
            table.insert(self.item_infos, {_data = data})
        end

        self:asyncCreateItem()
    end
end

function ActivityGroupBuyXReward:asyncCreateItem()
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
                            self:createCell(cell_info._data)
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

function ActivityGroupBuyXReward:createCell(_data)
    local root = self.roots[1]
    local cell = ActivityGroupBuyXRewardCell:createCell()
    cell:init(_data)
    self.ListView_1:addChild(cell)
    self.ListView_1:requestRefreshView()
end

function ActivityGroupBuyXReward:updateAll()
    self:init()
    self:onUpdateDraw()
    self:createItem()
    self:redNotification()
end

function ActivityGroupBuyXReward:onUpdateDraw()
    local root = self.roots[1]

    if self.activity_datas ~= nil then
        -- 团购礼包购买次数
        self.Text_buy = ccui.Helper:seekWidgetByName(root, "Text_buy")
        self.Text_buy:setString(string.format(tipStringInfo_activity_group_buy[10], self.activity_datas.totalNumber))

        -- 列表
        self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    end
end

-- 红点推送检测
function ActivityGroupBuyXReward:checkNotification()
    local success = false
    local datas = _ED.active_activity[176].activityAllData.activity_person_group_buy_info

    for k, v in pairs(datas.info) do
        if v.status == 1 then
            success = true
            break
        end
    end

    return success
end

-- 红点推送
function ActivityGroupBuyXReward:redNotification()
    local Image_red = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red")
    Image_red:setVisible(self:checkNotification())
end

function ActivityGroupBuyXReward:onEnterTransitionFinish()
    -- 加载ActivityGroupBuy界面资源.
    local csbNode = csb.createNode("activity/group_buy/group_buy_x_reward.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:buttonAddClickEvent()
    self:updateAll()
end

function ActivityGroupBuyXReward:onExit()
    state_machine.remove("activity_group_buy_x_reward_refresh_all")
    state_machine.remove("activity_group_buy_x_reward_to_person_reward")
end

function ActivityGroupBuyXReward:close()
end

function ActivityGroupBuyXReward:destroy(window)
end
