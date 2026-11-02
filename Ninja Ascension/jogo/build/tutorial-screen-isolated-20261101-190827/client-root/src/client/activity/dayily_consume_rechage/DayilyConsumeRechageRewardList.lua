--[[ ----------------------------------------------------------------------------
-- 奖励cell
--]] ----------------------------------------------------------------------------
DayilyConsumeRechageRewardList = class("DayilyConsumeRechageRewardListClass", Window)
DayilyConsumeRechageRewardList.__size = nil

-- 创建Cell实例
local dayily_consume_rechage_reward_list_create_terminal = {
    _name = "dayily_consume_rechage_reward_list_create",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if DayilyConsumeRechageRewardList then
            local cell = DayilyConsumeRechageRewardList:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(dayily_consume_rechage_reward_list_create_terminal)
state_machine.init()

-- 构造器
function DayilyConsumeRechageRewardList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._info = nil

    -- load lua files.

    -- Initialize daily consume recharge ranking list main page state machine.
    local function init_dayily_consume_rechage_reward_list_terminal()
        -- 前往
        local dayily_consume_rechage_reward_list_go_to_terminal = {
            _name = "dayily_consume_rechage_reward_list_go_to",
            _init = function(terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    state_machine.excute("shortcut_open_recharge_window", 0, nil)
                    state_machine.excute("dayily_consume_rechage_main_window_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(dayily_consume_rechage_reward_list_go_to_terminal)
        state_machine.init()
    end
    -- call func init daily consume recharge ranking list main state machine.
    init_dayily_consume_rechage_reward_list_terminal()
end

-- 对象初始化
function DayilyConsumeRechageRewardList:init(params)
    self.rewardInfo = params.rewardInfo
    self.index = params.index

    self:onInit(params)
    self:setContentSize(DayilyConsumeRechageRewardList.__size)
    return self
end

function DayilyConsumeRechageRewardList:onUpdateDraw()
    local root = self.roots[1]
    local activity = _ED.active_activity[self.activityType]
    local other_info = zstring.split(activity.activity_params, "|")
    local activity_params = other_info[1]
    local titleListText = ccui.Helper:seekWidgetByName(root, "Text_11")
    local titleListTextInfo = ""

    local tipProperty = nil
    local activityString = nil

    -- 多语言活动配置
    if tipStringInfo_activity_local_data_property then
        activityString = tipStringInfo_activity_local_data_property[tostring(self.activityType)]
    end
    if activityString and "" ~= activityString then
        tipProperty = string.format(tipStringInfo_activity_local_data_property[tostring(self.activityType)], tonumber(self.rewardInfo.activityInfo_need_day))
    end

    if nil ~= tipProperty then
        titleListTextInfo = tipProperty
    else
        titleListTextInfo = self.rewardInfo.activityInfo_name
    end
    titleListText:setString(titleListTextInfo)

    local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")
    local cost_type = nil

    if tonumber(activity_params) > tonumber(self.rewardInfo.activityInfo_need_day) then
        scheduleText:setString(self.rewardInfo.activityInfo_need_day .. "/" .. self.rewardInfo.activityInfo_need_day)
    else
        scheduleText:setString(activity_params .. "/" .. self.rewardInfo.activityInfo_need_day)
    end

    local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12") -- 领取	
    local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11") -- 充值
    local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13") -- 前往
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13") -- 已领取
    Button_11:setVisible(false)
    GetButton:setVisible(false)
    GetButton:setTouchEnabled(true)
    GetButton:setBright(true)
    Button_13:setVisible(false)
    Image_13:setVisible(false)
    scheduleText:setVisible(true)
    local isComplete = 0
    local max = 0

    isComplete = tonumber(activity_params)
    max = tonumber(activity.activity_Info[self.index].activityInfo_need_day)

    if isComplete < max then
        self.rewardState = 0

        Button_13:setVisible(true)
    elseif tonumber(self.rewardInfo.activityInfo_isReward) == 0 then
        self.rewardState = 1
        GetButton:setVisible(true)
        scheduleText:setString("")
    else
        self.rewardState = 2
        Image_13:setVisible(true)
        scheduleText:setString("")
    end
end

function DayilyConsumeRechageRewardList:updateRewardInfo()
    local root = self.roots[1]

    local index = 1

    local rewardIcons = DrawHandle.drawIcons(self.rewardInfo.activityInfo_reward_select)
    -- local curRewards = zstring.splits(self.rewardInfo.activityInfo_reward_select, "|", ",")

    local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
    ListViewDraw:removeAllItems()
    for k, cell in pairs(rewardIcons) do
        ListViewDraw:addChild(cell)
    end

    ListViewDraw:requestRefreshView()
end

function DayilyConsumeRechageRewardList:onEnterTransitionFinish()

end

function DayilyConsumeRechageRewardList:onInit(params)

    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/wonderful/landed_gifts_list.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    root:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())

    if DayilyConsumeRechageRewardList.__size == nil then
        DayilyConsumeRechageRewardList.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, {
        terminal_name = "dayily_consume_rechage_main_get_reward",
        terminal_state = 0,
        rewardIndex = self.index,
        isPressedActionEnabled = true
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, {
        terminal_name = "dayily_consume_rechage_reward_list_go_to",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, nil, 0)

    self.activityType = 106
    self:onUpdateDraw()
    self:updateRewardInfo()
end

function DayilyConsumeRechageRewardList:onExit()
    -- DayilyConsumeRechageRewardList.

    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/wonderful/landed_gifts_list.csb", root)
    -- ]]
end

function DayilyConsumeRechageRewardList:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function DayilyConsumeRechageRewardList:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/wonderful/landed_gifts_list.csb", root)

    self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
