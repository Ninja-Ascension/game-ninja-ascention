ActivityGroupBuyCell = class("ActivityGroupBuyCellClass", Window)
ActivityGroupBuyCell.__size = nil

-- 创建Cell实例
local activity_group_buy_cell_create_terminal = {
    _name = "activity_group_buy_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if ActivityGroupBuyCell then
            local cell = ActivityGroupBuyCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_cell_create_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuyCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------
    app.load("client.activity.group_buy.ActivityGroupBuyPopUp")
    app.load("client.activity.group_buy.ActivityGroupBuyBox")
    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_cell_terminal()
        -- 储值按钮
        local activity_group_buy_cell_onclick_recharge_terminal = {
            _name = "activity_group_buy_cell_onclick_recharge",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _activity_end_time = _ED.active_activity[176].activityAllData.activity_server_group_buy_info.realEndTime
                if _activity_end_time > 0 and _activity_end_time < sstime() then
                    TipDlg.drawTextDailog(tipStringInfo_activity_group_buy[14])
                else
                    local rechargeDimond = params._datas._self._data.needMoney
                    local function reCallback()
                        app.load("client.shop.recharge.RechargeDialog")
                        if fwin:find("RechargeDialogClass") == nil then
                            local Recharge = RechargeDialog:new()
                            Recharge:init(4)
                            fwin:open(Recharge, fwin._windows)
                        end
                    end
                    app.load("client.shop.recharge.RechargeVoucher")
                    RechargeVoucher.getCanUseVoucher({recharge_dimond = rechargeDimond},reCallback)

                    
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取按钮
        local activity_group_buy_cell_onclick_get_reward_terminal = {
            _name = "activity_group_buy_cell_onclick_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function call_back(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("activity_group_buy_refresh_all", 0, "")

                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end

                protocol_command.activity_group_buy_get_reward.param_list = "3" .. "\r\n" .. "-1" .. "\r\n" .. params._datas._self.cell_index
                NetworkManager:register(protocol_command.activity_group_buy_get_reward.code, nil, nil, nil, params._datas._self, call_back, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_group_buy_cell_onclick_get_reward_terminal)
        state_machine.add(activity_group_buy_cell_onclick_recharge_terminal)
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_cell_terminal()
end

-- 对象初始化
function ActivityGroupBuyCell:init(_data)
    if _data ~= nil then
        self._data = _data
    end

    self:onInit()
    self:setContentSize(ActivityGroupBuyCell.__size)

    return self
end

function ActivityGroupBuyCell:onInit()
    -- 加载ActivityGroupBuyCell界面资源.
    -- res.duplicate.pve_super_mopping_cell = duplicate/pve_super_mopping_cell.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("duplicate/pve_super_mopping_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/group_buy/group_buy_cell.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if ActivityGroupBuyCell.__size == nil then
        ActivityGroupBuyCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
    self:buttonAddClickEvent()
end

function ActivityGroupBuyCell:onUpdateDraw()
    local root = self.roots[1]

    -- 当前全服购买次数
    self.current_buy_time = self._data.totalNumber

    -- 全服最大购买次数
    local needNumbers = zstring.split(self._data.needNumber, ",")
    local max_number = 0
    local current_index = 0

    max_number = tonumber(needNumbers[1])

    for i, num in ipairs(needNumbers) do
        num = tonumber(num)
        if self.current_buy_time >= tonumber(needNumbers[#needNumbers]) then
            max_number = tonumber(needNumbers[#needNumbers])
            current_index = #needNumbers
            break
        else
            if i < #needNumbers then
                if self.current_buy_time >= num and self.current_buy_time < tonumber(needNumbers[i + 1]) then
                    max_number = tonumber(needNumbers[i + 1])
                    current_index = i
                    break
                end
            end
        end
    end

    self.current_max_buy_time = max_number

    local maxNum = tonumber(needNumbers[#needNumbers])

    -- 进度条差值
    self.current_loading_bar_value = self.current_buy_time / maxNum

    -- 标题文本内容
    self.current_title_msg = string.format(tipStringInfo_activity_group_buy[1], self._data.needMoney)

    -- 奖励数据
    self.current_reward_infos = self._data.reward

    -- 限购次数文本
    self.current_limit = self._data.todayRechargeNumber .. "/" .. self._data.limit

    -- 宝箱奖励数组
    self.box_rewards = self.box_rewards or {}
    local box_reward_str_infos = zstring.split(self._data.rewardEx, ";")
    for i, v in ipairs(box_reward_str_infos) do
        self.box_rewards[i] = zstring.splits(v, "|", ",")
    end

    -- 索引
    self.cell_index = self._data.index

    -- 宝箱状态
    self.box_reward_state = zstring.split(self._data.rewardStatus, ",")

    -----------------------------------------------------------------------------------------------------------------------------------------------------------

    -- 充值N钻石
    self.Text_recharge = ccui.Helper:seekWidgetByName(root, "Text_recharge")
    self.Text_recharge:setString(self.current_title_msg)

    -- 进度条
    self.LoadingBar_achievement = ccui.Helper:seekWidgetByName(root, "LoadingBar_achievement")
    self.LoadingBar_achievement:setPercent(self.current_loading_bar_value * 100)

    -- 进度条文本
    self.Text_buy = ccui.Helper:seekWidgetByName(root, "Text_buy")
    self.Text_buy:setString(self.current_buy_time .. "/" .. self.current_max_buy_time)

    -- 限购次数
    self.Text_limit = ccui.Helper:seekWidgetByName(root, "Text_limit")
    self.Text_limit:setString(self.current_limit)

    -- 重置类型
    self.Text_limit_0 = ccui.Helper:seekWidgetByName(root, "Text_limit_0")
    self.Text_limit_0:setString(self._data.resetType == 0 and tipStringInfo_activity_group_buy[12] or tipStringInfo_activity_group_buy[11])

    -- 奖励容器
    self.ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")

    -- 绘制奖励
    local cells = DrawHandle.drawIcons(self.current_reward_infos)
    self.ListView_reward:removeAllItems()
    for i = 1, #cells do
        self.ListView_reward:addChild(cells[i])
    end
    self.ListView_reward:requestRefreshView()

    -- 储值按钮
    self.Button_cz = ccui.Helper:seekWidgetByName(root, "Button_cz")

    -- 领取按钮
    self.Button_lq_0 = ccui.Helper:seekWidgetByName(root, "Button_lq_0")

    -- 进度条容器
    self.Panel_jd = ccui.Helper:seekWidgetByName(root, "Panel_jd")
    local panel_jd_size = self.Panel_jd:getContentSize()
    self.Panel_jd:removeAllChildren(true)
    for i, v in ipairs(needNumbers) do
        local percentage = tonumber(v) / maxNum
        local cell = ActivityGroupBuyBox:createCell()
        cell:init({posX = panel_jd_size.width * percentage, cell_index = self.cell_index, box_index = i - 1, box_reward_state = self.box_reward_state[i], reward = self.box_rewards[i]})
        self.Panel_jd:addChild(cell)
    end

    self:updateButtonState()
end

function ActivityGroupBuyCell:updateAll()
    local activity_info = _ED.active_activity[176].activityAllData.activity_top_up_info
    self._data = activity_info.info[tonumber(self.cell_index) + 1]
    if self._data ~= nil then
        self:onUpdateDraw()
        self:buttonAddClickEvent()
        self:redNotification()
    end
end

-- 红点推送检测
function ActivityGroupBuyCell:checkNotification()
    local success = self._data.canGetNumber > 0
    return success
end

-- 红点推送
function ActivityGroupBuyCell:redNotification()
    local Image_red_get_reward = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_get_reward")
    Image_red_get_reward:setVisible(self:checkNotification())
end

function ActivityGroupBuyCell:buttonAddClickEvent()
    local root = self.roots[1]

    -- 储值按钮
    fwin:addTouchEventListener(
        self.Button_cz,
        nil,
        {
            terminal_name = "activity_group_buy_cell_onclick_recharge",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _self = self
        },
        nil,
        0
    )

    -- 领取按钮
    fwin:addTouchEventListener(
        self.Button_lq_0,
        nil,
        {
            terminal_name = "activity_group_buy_cell_onclick_get_reward",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _self = self
        },
        nil,
        0
    )
end

function ActivityGroupBuyCell:updateButtonState()
    self.Button_cz:setTouchEnabled(self._data.todayRechargeNumber < self._data.limit)
    self.Button_cz:setBright(self._data.todayRechargeNumber < self._data.limit)

    self.Button_cz:setVisible(self._data.canGetNumber == 0)
    self.Button_lq_0:setVisible(self._data.canGetNumber > 0)
end

function ActivityGroupBuyCell:onEnterTransitionFinish()
end

function ActivityGroupBuyCell:createCell()
    local cell = ActivityGroupBuyCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function ActivityGroupBuyCell:onExit()
    -- 释放ActivityGroupBuyCell界面资源.
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/group_buy/group_buy_cell.csb", root)
    -- ]]
    state_machine.remove("activity_group_buy_cell_onclick_get_reward")
    state_machine.remove("activity_group_buy_cell_onclick_recharge")
end

function ActivityGroupBuyCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityGroupBuyCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/group_buy/group_buy_cell.csb", root)

    self.roots = {}
end
