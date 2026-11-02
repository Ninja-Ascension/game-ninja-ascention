ActivityGroupBuyMineRewardCell = class("ActivityGroupBuyMineRewardCellClass", Window)
ActivityGroupBuyMineRewardCell.__size = nil

-- 创建Cell实例
local activity_group_buy_mine_reward_cell_create_terminal = {
    _name = "activity_group_buy_mine_reward_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if ActivityGroupBuyMineRewardCell then
            local cell = ActivityGroupBuyMineRewardCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_mine_reward_cell_create_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuyMineRewardCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_mine_reward_cell_terminal()
        -- 领奖
        local activity_group_buy_mine_reward_cell_onclick_reward_btn_1_terminal = {
            _name = "activity_group_buy_mine_reward_cell_onclick_reward_btn_1",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function CallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- params._datas._self._data = _ED.active_activity[176].activityAllData.activity_person_group_buy_info.info[params._datas._self._data.index + 1]
                        -- params._datas._self:onUpdateDraw()

                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)

                        state_machine.excute("activity_group_buy_mine_reward_refresh_all", 0, '')
                        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 176)
                        state_machine.excute("activity_group_buy_refresh_red", 0, '')
                    end
                end

                protocol_command.activity_group_buy_get_reward.param_list = "2" .. "\r\n" .. "-1" .. "\r\n" .. params._datas._self._data.index
                NetworkManager:register(protocol_command.activity_group_buy_get_reward.code, nil, nil, nil, params._datas._self, CallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_group_buy_mine_reward_cell_onclick_reward_btn_1_terminal)
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_mine_reward_cell_terminal()
end

-- 对象初始化
function ActivityGroupBuyMineRewardCell:init(_data)
    if _data ~= nil then
        self._data = _data
    end

    self:onInit()
    self:setContentSize(ActivityGroupBuyMineRewardCell.__size)

    return self
end

function ActivityGroupBuyMineRewardCell:onInit()
    -- res.duplicate.pve_super_mopping_cell = duplicate/pve_super_mopping_cell.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("duplicate/pve_super_mopping_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/group_buy/group_buy_mine_reward_cell.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if ActivityGroupBuyMineRewardCell.__size == nil then
        ActivityGroupBuyMineRewardCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
    self:buttonAddClickEvent()
end

function ActivityGroupBuyMineRewardCell:onUpdateDraw()
    local root = self.roots[1]

    -- 领取按钮
    self.Button_lq = ccui.Helper:seekWidgetByName(root, "Button_lq")

    -- 领取按钮文本
    self.Text_lq = ccui.Helper:seekWidgetByName(root, "Text_lq")
    if self._data.status == 0 then
        self.Text_lq:setString(tipStringInfo_activity_group_buy[8])
    elseif self._data.status == 1 then
        self.Text_lq:setString(tipStringInfo_activity_group_buy[7])
    elseif self._data.status == 2 then
        self.Text_lq:setString(tipStringInfo_activity_group_buy[9])
    end

    -- 条件描述
    self.Text_task = ccui.Helper:seekWidgetByName(root, "Text_task")
    if self._data.achieveType == 0 then
        self.Text_task:setString(string.format(tipStringInfo_activity_group_buy[6], self._data.maxProgress))
    elseif self._data.achieveType == 1 then
        self.Text_task:setString(string.format(tipStringInfo_activity_group_buy[5], self._data.maxProgress))
    end

    -- 奖励容器
    self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

    -- 绘制奖励
    local reward_infos = self._data.reward
    local cells = DrawHandle.drawIcons(reward_infos)
    self.ListView_1:removeAllItems()
    for i = 1, #cells do
        self.ListView_1:addChild(cells[i])
    end
    self.ListView_1:requestRefreshView()

    self:updateButtonState()
end

function ActivityGroupBuyMineRewardCell:createCell()
    local cell = ActivityGroupBuyMineRewardCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function ActivityGroupBuyMineRewardCell:buttonAddClickEvent()
    -- 领取按钮
    local root = self.roots[1]
    fwin:addTouchEventListener(
        self.Button_lq,
        nil,
        {
            terminal_name = "activity_group_buy_mine_reward_cell_onclick_reward_btn_1",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _self = self
        },
        nil,
        0
    )
end

function ActivityGroupBuyMineRewardCell:updateButtonState()
    self.Button_lq:setTouchEnabled(self._data.status < 2)
    self.Button_lq:setBright(self._data.status == 1)

    self:redNotification()
end

-- 红点推送检测
function ActivityGroupBuyMineRewardCell:checkNotification()
    local success = false
    local status = self._data.status
    if status == 1 then
        success = true
    end
    return success
end

-- 红点推送
function ActivityGroupBuyMineRewardCell:redNotification()
    local Image_red = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red")

    Image_red:setVisible(self:checkNotification())
end

function ActivityGroupBuyMineRewardCell:onEnterTransitionFinish()
end

function ActivityGroupBuyMineRewardCell:onExit()
    -- 释放ActivityGroupBuyCell界面资源.
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/group_buy/group_buy_mine_reward_cell.csb", root)
    -- ]]

    state_machine.remove("activity_group_buy_mine_reward_cell_onclick_reward_btn_1")
end

function ActivityGroupBuyMineRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityGroupBuyMineRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/group_buy/group_buy_mine_reward_cell.csb", root)

    self.roots = {}
end
