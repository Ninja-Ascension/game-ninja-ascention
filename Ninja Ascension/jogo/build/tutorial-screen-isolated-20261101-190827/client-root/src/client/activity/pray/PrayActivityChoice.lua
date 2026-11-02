--[[ ----------------------------------------------------------------------------
-- 祈福活动
-- 道具选择弹窗
--]] ----------------------------------------------------------------------------
PrayActivityChoice = class("PrayActivityChoiceClass", Window)

-- 打开窗口
local pray_activity_choice_window_open_terminal = {
    _name = "pray_activity_choice_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PrayActivityChoiceClass") then
            fwin:open(PrayActivityChoice:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local pray_activity_choice_window_close_terminal = {
    _name = "pray_activity_choice_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PrayActivityChoiceClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pray_activity_choice_window_open_terminal)
state_machine.add(pray_activity_choice_window_close_terminal)
state_machine.init()

-- 构造器
function PrayActivityChoice:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._mType = 0 -- 1:祈福 2:礼包
    self._mPos = 0 -- 可选奖励位置
    self._curSelectIdx = nil -- 当前选择奖励下标
    -- load lua files.
    app.load("client.activity.pray.pray_activityw_select_cell")
    -- Initialize pray activity choice page state machine.
    local function init_pray_activity_choice_terminal()
        -- 打开角色创建窗口
        local pray_activity_choice_open_terminal = {
            _name = "pray_activity_choice_open",
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
        local pray_activity_choice_close_terminal = {
            _name = "pray_activity_choice_close",
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
        local pray_activity_choice_show_terminal = {
            _name = "pray_activity_choice_show",
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
        local pray_activity_choice_hide_terminal = {
            _name = "pray_activity_choice_hide",
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

        -- 当前选择奖励
        local pray_activity_choice_select_award_terminal = {
            _name = "pray_activity_choice_select_award",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    local curSelectIdx = params.mIndex
                    instance:onRefreshView(curSelectIdx)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击确定保存信息
        local pray_activity_choice_click_ok_terminal = {
            _name = "pray_activity_choice_click_ok",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= params then
                    state_machine.lock("pray_activity_choice_click_ok")
                    local mPos = params._datas.m_pos
                    local mCell = params._datas.m_cell
                    local mselectId = mCell._curSelectIdx
                    if mselectId == nil then 
                        state_machine.unlock("pray_activity_choice_click_ok")
                        return 
                    end
                    local mType = mCell._mType

                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                -- 刷新主界面
                                state_machine.excute("pray_activity_window_refush_view", 0, {mType = mType})
                                state_machine.excute("pray_activity_choice_window_close", 0, "")
                            end
                        end
                        state_machine.unlock("pray_activity_choice_click_ok")
                    end
                    if mType == 1 then
                        protocol_command.limit_blessing_set.param_list = mPos .. "\r\n" .. mselectId
                        NetworkManager:register(protocol_command.limit_blessing_set.code, nil, nil, nil, instance, responseCallback, false, nil)
                    else
                        protocol_command.limit_blessing_set_spree_reward.param_list = mCell._awardInfo.gear .. "\r\n" .. mPos .. "\r\n" .. mselectId
                        NetworkManager:register(protocol_command.limit_blessing_set_spree_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pray_activity_choice_open_terminal)
        state_machine.add(pray_activity_choice_close_terminal)
        state_machine.add(pray_activity_choice_show_terminal)
        state_machine.add(pray_activity_choice_hide_terminal)
        state_machine.add(pray_activity_choice_click_ok_terminal)
        state_machine.add(pray_activity_choice_select_award_terminal)
        state_machine.init()
    end
    -- call func init pray activity choice state machine.
    init_pray_activity_choice_terminal()
end

-- 对象初始化
function PrayActivityChoice:init(params)
    self._mPos = params.mPos
    self._mType = params.mType
    self._awardInfo = params.awardInfo
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function PrayActivityChoice:onUpdateDraw()
    local root = self.roots[1]

    -- 道具弹窗功能显示容器
    self.Panel_function = ccui.Helper:seekWidgetByName(root, "Panel_function")

    -- 道具框显示容器
    self.Panel_item_red = ccui.Helper:seekWidgetByName(root, "Panel_item_red")

    -- 普通道具框滚动容器
    self.ScrollView_item_bule = ccui.Helper:seekWidgetByName(root, "ScrollView_item_bule")

    -- 大奖显示控件
    self.Image_choice_title = ccui.Helper:seekWidgetByName(root, "Image_choice_title")
    self.Image_choice_title:setVisible(false)
end

function PrayActivityChoice:showScorlListOne(curSelectIdx)
    if self._mPos == 1 then 
        self.Image_choice_title:setVisible(true)
    end
    local activityInfo = self._awardInfo
    local selectState = activityInfo.wishState
    if curSelectIdx then
        self._curSelectIdx = curSelectIdx
    else
        self._curSelectIdx = selectState ~= -1 and selectState or nil
    end

    local listInfo = activityInfo.wishReward
    local mScorllView = self.ScrollView_item_bule
    mScorllView:removeAllChildren(true)
    local horizontalNumber = 5
    local panel = mScorllView:getInnerContainer()
    panel:setContentSize(mScorllView:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = mScorllView:getInnerContainerSize()

    local tHeight = 0
    local cellHeight = 0

    local wPosition = sWidth / horizontalNumber
    local tWidth = 0
    local Hlindex = 0
    local number = #listInfo
    local m_number = math.ceil(number / horizontalNumber)
    cellHeight = m_number * (mScorllView:getContentSize().width / horizontalNumber)
    sHeight = math.max(sHeight, cellHeight)

    panel:setContentSize(mScorllView:getContentSize().width, sHeight)
	local index = 1
	local selectRewardInfo = nil
    for i, v in ipairs(listInfo) do
        local isSelect = false
        if self._curSelectIdx and self._curSelectIdx == i then
			isSelect = true
			selectRewardInfo = v
        end

        local cell = state_machine.excute("pray_activity_goods_cell_create", 0, {mType = 3, mInfo = {mIndex = i, rewardInfo = v, isSelect = isSelect,mPos = self._mPos}})
        panel:addChild(cell)
        tWidth = tWidth + wPosition
        if (index - 1) % horizontalNumber == 0 then
            Hlindex = Hlindex + 1
            tWidth = 0
            tHeight = sHeight - wPosition * Hlindex
        end
        if index <= horizontalNumber then
            tHeight = sHeight - wPosition
        end
        index = index + 1
        cell:setPosition(cc.p(tWidth, tHeight))
    end

	mScorllView:jumpToTop()
	self.Panel_item_red:removeAllChildren(true)
    local cell = state_machine.excute("pray_activity_goods_cell_create", 0, {mType = 1, mInfo = {mIndex = self._mPos, notClick = true, tempRewardInfo = selectRewardInfo}})
    self.Panel_item_red:addChild(cell)
end

function PrayActivityChoice:showScorlListTwo(curSelectIdx)
    local activityInfo = self._awardInfo
    local selectState = tonumber(zstring.split(activityInfo.chooseReward, "|")[self._mPos])
    if curSelectIdx then
        if self._curSelectIdx == curSelectIdx then 
            return 
        end
        self._curSelectIdx = curSelectIdx
    else
        self._curSelectIdx = selectState ~= -1 and selectState or nil
    end

    local listInfo = zstring.split(activityInfo.optionalReward[self._mPos],"|")
    local mScorllView = self.ScrollView_item_bule
    mScorllView:removeAllChildren(true)
    local horizontalNumber = 5
    local panel = mScorllView:getInnerContainer()
    panel:setContentSize(mScorllView:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = mScorllView:getInnerContainerSize()

    local tHeight = 0
    local cellHeight = 0

    local wPosition = sWidth / horizontalNumber
    local tWidth = 0
    local Hlindex = 0
    local number = #listInfo
    local m_number = math.ceil(number / horizontalNumber)
    cellHeight = m_number * (mScorllView:getContentSize().width / horizontalNumber)
    sHeight = math.max(sHeight, cellHeight)

    panel:setContentSize(mScorllView:getContentSize().width, sHeight)
    local index = 1
    local selectRewardInfo = nil
    for i, v in ipairs(listInfo) do
        local isSelect = false
        if self._curSelectIdx and self._curSelectIdx == i then
            isSelect = true
            selectRewardInfo = v
        end

        local cell = state_machine.excute("pray_activity_goods_cell_create", 0, {mType = 3, mInfo = {mIndex = i, rewardInfo = v, isSelect = isSelect}})
        panel:addChild(cell)
        tWidth = tWidth + wPosition
        if (index - 1) % horizontalNumber == 0 then
            Hlindex = Hlindex + 1
            tWidth = 0
            tHeight = sHeight - wPosition * Hlindex
        end
        if index <= horizontalNumber then
            tHeight = sHeight - wPosition
        end
        index = index + 1
        cell:setPosition(cc.p(tWidth, tHeight))
    end
    mScorllView:jumpToTop()

    self.Panel_item_red:removeAllChildren(true)
    local cell = state_machine.excute("pray_activity_goods_cell_create", 0, {mType = 2, mInfo = {mIndex = self._mPos, notClick = true, tempRewardInfo = selectRewardInfo}})
    self.Panel_item_red:addChild(cell)
end

function PrayActivityChoice:onRefreshView(curSelectIdx)
    if self._mType == 1 then
        self:showScorlListOne(curSelectIdx)
    elseif self._mType == 2 then
        self:showScorlListTwo(curSelectIdx)
    end
end

function PrayActivityChoice:onEnterTransitionFinish()
    -- 加载PrayActivityChoiceWindow界面资源.
    -- res.activity.Pray.Pray_choice = res/activity/Pray/Pray_choice.csb
    local csbNode = csb.createNode("activity/Pray/Pray_choice.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 道具选择按钮
    self.Button_choice =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_choice"),
        nil,
        {
            terminal_name = "pray_activity_choice_click_ok",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_pos = self._mPos,
            m_cell = self
        },
        nil,
        0
    )

    -- 道具取消按钮
    self.Button_cancel =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_cancel"),
        nil,
        {
            terminal_name = "pray_activity_choice_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 弹窗关闭按钮
    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "pray_activity_choice_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
    self:onRefreshView()
end

function PrayActivityChoice:onExit()
    -- 释放PrayActivityChoiceWindow界面资源.
    state_machine.remove("pray_activity_choice_open")
    state_machine.remove("pray_activity_choice_close")
    state_machine.remove("pray_activity_choice_show")
    state_machine.remove("pray_activity_choice_hide")
    state_machine.remove("pray_activity_choice_click_ok")
    state_machine.remove("pray_activity_choice_select_award")
end

function PrayActivityChoice:close()
    -- window event : close.
end

function PrayActivityChoice:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
