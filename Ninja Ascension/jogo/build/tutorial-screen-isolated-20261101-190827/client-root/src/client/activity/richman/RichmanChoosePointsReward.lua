-- ----------------------------------------------------------------------------------------------------
-- 说明：选择积分奖励界面
-------------------------------------------------------------------------------------------------------
RichmanChoosePointsReward = class("RichmanChoosePointsRewardClass", Window)

local richman_choose_points_reward_window_open_terminal = {
    _name = "richman_choose_points_reward_window_open",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RichmanChoosePointsRewardClass") then
            fwin:open(RichmanChoosePointsReward:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local richman_choose_points_reward_window_close_terminal = {
    _name = "richman_choose_points_reward_window_close",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RichmanChoosePointsRewardClass") then
            fwin:close(fwin:find("RichmanChoosePointsRewardClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(richman_choose_points_reward_window_open_terminal)
state_machine.add(richman_choose_points_reward_window_close_terminal)
state_machine.init()

function RichmanChoosePointsReward:ctor()
    self.super:ctor()

    self.roots = {}

    self.DicePropInfo = nil
    self.index = 0
    self.curChooseIdx = -1

    app.load("client.activity.richman.RichmanChoosePointsRewardList")

    local function init_richman_choose_points_reward_terminal()
        -- 打开角色创建窗口
        local richman_choose_points_reward_open_terminal = {
            _name = "richman_choose_points_reward_open",
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
        local richman_choose_points_reward_close_terminal = {
            _name = "richman_choose_points_reward_close",
            _init = function(terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("richman_choose_points_reward_window_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示窗口
        local richman_choose_points_reward_show_terminal = {
            _name = "richman_choose_points_reward_show",
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
        local richman_choose_points_reward_hide_terminal = {
            _name = "richman_choose_points_reward_hide",
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

        -- 选择奖励
        local richman_choose_points_reward_idx_terminal = {
            _name = "richman_choose_points_reward_idx",
            _init = function(terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 选择奖励
                if nil ~= instance then
                    local cellIndex = params[1]
                    local scoreRewardIndex = params[2]
                    local optionSelectIndex = params[3]

                    self.cellIndex = cellIndex
                    self.scoreRewardIndex = scoreRewardIndex
                    self.optionSelectIndex = optionSelectIndex

                    instance:updateChooseIdx(cellIndex)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 确认选择奖励
        local richman_choose_points_reward_confirm_terminal = {
            _name = "richman_choose_points_reward_confirm",
            _init = function(terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    -- 积分奖励索引
                    local scoreRewardIndex = self.scoreRewardIndex
                    -- 选择奖励下标
                    local optionSelectIndex = self.optionSelectIndex
                    
                    if optionSelectIndex == nil or optionSelectIndex <= 0 then
                        TipDlg.drawTextDailog(tipStringInfo_richman[2])
                        return
                    end
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("richman_main_update_points_reward", 0, nil)
                            state_machine.excute("richman_choose_points_reward_close", 0, nil)
                        end
                    end
                    protocol_command.monopoly_change_achieve_reward.param_list = scoreRewardIndex .. "\r\n" .. optionSelectIndex
                    NetworkManager:register(protocol_command.monopoly_change_achieve_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(richman_choose_points_reward_open_terminal)
        state_machine.add(richman_choose_points_reward_close_terminal)
        state_machine.add(richman_choose_points_reward_show_terminal)
        state_machine.add(richman_choose_points_reward_hide_terminal)
        state_machine.add(richman_choose_points_reward_idx_terminal)
        state_machine.add(richman_choose_points_reward_confirm_terminal)
        state_machine.init()
    end
    -- call func init richman_reward record state machine.
    init_richman_choose_points_reward_terminal()
end

function RichmanChoosePointsReward:updateDrawScrollView()
    self.ScrollView_1:removeAllChildren(true)

    -- 所有奖励列表
    local allScoreRewardList = self._userDataInfo.allScoreRewardList
    -- 可选奖励奖池下标
    local optionSelectPoolList = self._userDataInfo.optionSelectPoolList
    -- 当前点击的下标
    local index = self.index
    -- 积分奖励总兑换次数
    local allPointsRewardCountsInfo = self._userDataInfo.allPointsRewardCountsInfo
    -- 积分奖励剩余兑换次数
    local remainPointsRewardCountsInfo = self._userDataInfo.remainPointsRewardCountsInfo

    local optionSelectPoolMap = {}
    local exchangeCountsMap = {}
    for i, v in ipairs(optionSelectPoolList) do
        optionSelectPoolMap[v] = true
        exchangeCountsMap[v] = {allCounts = allPointsRewardCountsInfo[i], remainCounts = remainPointsRewardCountsInfo[i]}
    end

    local optionalRewardPoolIndexMap, userSelectIndex, scoreRewardIndex = self:getOptionSelectPropInfo()

    -- 可选奖励内容
    local cellList = {}
    local cellIndex = 1
    for i, propInfo in pairs(allScoreRewardList) do
        if optionSelectPoolMap[i] == true then
            local optionSelectIndex = optionalRewardPoolIndexMap[i]
            local canSelect = optionSelectIndex ~= nil
            local cell = state_machine.excute("richman_choose_points_reward_list_create", 0, {rewardPoolIndex = i, cellIndex = cellIndex, scoreRewardIndex = scoreRewardIndex, propInfo = propInfo, canSelect = canSelect, optionSelectIndex = optionSelectIndex, exchangeCountsInfo = exchangeCountsMap[i]})
            table.insert(cellList, cell)

            cellIndex = cellIndex + 1
        end
    end

    addNodeToScrollView({targetScrollView = self.ScrollView_1, nodeList = cellList, columns = 4})
end

function RichmanChoosePointsReward:getOptionSelectPropInfo()
    local index = self.index
    local everyStageNum = self._userDataInfo.everyStageNums
    local pointRewardsInfo = self._userDataInfo.pointRewardsInfo

    local curUnreceiveIdx = 0
    for i, v in ipairs(pointRewardsInfo) do
        if v.rewardState == 0 or v.rewardState == 1 then
            curUnreceiveIdx = i
            break
        end
    end

    -- 当前处于第几阶段
    local curStage = math.ceil(curUnreceiveIdx / everyStageNum)
    if curStage == 0 then
        curStage = math.ceil(#pointRewardsInfo / everyStageNum)
    end
    -- 当前阶段积分奖励数据
    local tempIndex = 1
    local curStagePointsRewadList = {}
    for i, v in ipairs(pointRewardsInfo) do
        if i > (curStage - 1) * everyStageNum and i <= curStage * everyStageNum then
            curStagePointsRewadList[tempIndex] = {data = v, scoreIndex = i}
            tempIndex = tempIndex + 1
        end
    end

    local optionalRewardPoolIndexMap = {}
    local userSelectIndex = 0
    local scoreRewardIndex = nil

    local data = curStagePointsRewadList[index].data
    if data ~= nil then
        userSelectIndex = data.chooseIdx

        local tempOptionalRewardPoolIndexMap = {}
        for i, v in ipairs(data.rewardIdxInfo) do
            tempOptionalRewardPoolIndexMap[v] = i
        end
        optionalRewardPoolIndexMap = tempOptionalRewardPoolIndexMap

        scoreRewardIndex = curStagePointsRewadList[index].scoreIndex
    end

    return optionalRewardPoolIndexMap, userSelectIndex, scoreRewardIndex
end

function RichmanChoosePointsReward:updateChooseIdx(curChooseIdx)
    local cellItems = self.ScrollView_1:getChildren()
    if #cellItems ~= 0 then
        for i, v in ipairs(cellItems) do
            if curChooseIdx == i then
                v:updateChoose(true)
            else
                v:updateChoose(false)
            end
        end
    end
end

function RichmanChoosePointsReward:onUpdateDraw()
    local root = self.roots[1]
    -- 绘制奖励内容列表
    self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
    self:updateDrawScrollView()
end

-- 对象初始化
function RichmanChoosePointsReward:init(params)
    -- 从1-4
    self.index = params
    self._userDataInfo = _ED.active_activity[187].activity_data
    return self
end

function RichmanChoosePointsReward:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/dafuweng/dafuweng_jiangli.csb")
    local root = csbNode:getChildByName("root")
    self:addChild(csbNode)
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {
        terminal_name = "richman_choose_points_reward_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, nil, 0)

    -- 确认选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {
        terminal_name = "richman_choose_points_reward_confirm",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, nil, 0)

    self:onUpdateDraw()
end

function RichmanChoosePointsReward:onExit()
    state_machine.remove("richman_choose_points_reward_open")
    state_machine.remove("richman_choose_points_reward_close")
    state_machine.remove("richman_choose_points_reward_show")
    state_machine.remove("richman_choose_points_reward_hide")
    state_machine.remove("richman_choose_points_reward_idx")
    state_machine.remove("richman_choose_points_reward_confirm")

end

function RichmanChoosePointsReward:close()
    -- window event : close.

end

function RichmanChoosePointsReward:destroy(window)
    -- window event : destroy.

end
