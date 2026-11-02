--[[ ----------------------------------------------------------------------------
-- 祈福活动
-- 任务列表及礼包列表
--]] ----------------------------------------------------------------------------
PrayActivityListCell = class("PrayActivityListCellClass", Window)
PrayActivityListCell.__size = nil

-- 创建Cell实例
local pray_activity_list_cell_create_terminal = {
    _name = "pray_activity_list_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if PrayActivityListCell then
            local cell = PrayActivityListCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pray_activity_list_cell_create_terminal)
state_machine.init()

-- 构造器
function PrayActivityListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._mType = nil -- 1:任务  2:礼包
    self._mInfo = nil
    self._taskInfo = nil -- 配置表任务信息
    self._remainBuyTimes = nil
    self._buyPropCost = nil
    self._buyInfo = nil
    -- load lua files.

    -- Initialize pray activity list cell page state machine.
    local function init_pray_activity_list_cell_terminal()
        local pray_activity_list_cell_jump_windows_terminal = {
            _name = "pray_activity_list_cell_jump_windows",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mCell = params._datas.m_cell
                instance:jumpToWindows(mCell._taskInfo, mCell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pray_activity_list_cell_get_reward_terminal = {
            _name = "pray_activity_list_cell_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= params then
                    state_machine.lock("pray_activity_list_cell_get_reward")
                    local mType = params._datas.m_type
                    local mInfo = params._datas.m_info
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd, fwin._ui)

                                state_machine.excute("pray_activity_window_refush_view", 0, "")
                            end
                        end
                        state_machine.unlock("pray_activity_list_cell_get_reward")
                    end
                    if mType == 1 then
                        -- 任务
                        protocol_command.limit_blessing_get_task_reward.param_list = "" .. mInfo.taskId
                        NetworkManager:register(protocol_command.limit_blessing_get_task_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                    elseif mType == 2 then
                        if tonumber(mInfo.canFinish) > 0 and tonumber(mInfo.state) == 0 then
                            -- 跳转充值
                            state_machine.excute("shortcut_open_recharge_window", 0, "")
                            state_machine.excute("pray_activity_window_close", 0, "")
                        else
                            local haveSelectReward = zstring.split(mInfo.chooseReward, "|")
                            for i, v in ipairs(haveSelectReward) do
                                if tonumber(v) == -1 then
                                     -- 提示选择奖励
                                    TipDlg.drawTextDailog(tipStringInfo_limit_pray_activity_tips[9])
                                    state_machine.unlock("pray_activity_list_cell_get_reward")
                                    return 
                                end
                            end

                            -- 礼包
                            protocol_command.limit_blessing_get_spree_reward.param_list = "" .. mInfo.gear
                            NetworkManager:register(protocol_command.limit_blessing_get_spree_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pray_activity_list_cell_jump_windows_terminal)
        state_machine.add(pray_activity_list_cell_get_reward_terminal)
        state_machine.init()
    end
    -- call func init pray activity list cell state machine.
    init_pray_activity_list_cell_terminal()
end

-- 对象初始化
function PrayActivityListCell:init(params)
    self._mType = params.mType
    self._mInfo = params.mInfo
    self:onInit(params)
    self:setContentSize(PrayActivityListCell.__size)
    return self
end

function PrayActivityListCell:onUpdateDraw()
    local root = self.roots[1]

    -- 超值礼包列表容器
    self.Panel_buy_list = ccui.Helper:seekWidgetByName(root, "Panel_buy_list")

    self.Panel_Good = {}
    for i = 1, 4 do
        table.insert(self.Panel_Good, ccui.Helper:seekWidgetByName(root, "Panel_" .. i))
    end
    -- 稀有物品框动画显示
    self.Panel_1_effect = ccui.Helper:seekWidgetByName(root, "Panel_1_effect")

    -- 价格输入文本框
    self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

    -- 活跃任务列表容器
    self.Panel_task_list = ccui.Helper:seekWidgetByName(root, "Panel_task_list")

    -- 任务名称
    self.Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")
    self.Text_activity_name = ccui.Helper:seekWidgetByName(root, "Text_activity_name")
    self.Text_received = ccui.Helper:seekWidgetByName(root, "Text_received")

    -- 每日图片
    self.Image_title = ccui.Helper:seekWidgetByName(root, "Image_title")
    -- 每期图片
    self.Image_title_2 = ccui.Helper:seekWidgetByName(root, "Image_title_2")
    -- 礼包限购次数
    self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
    -- 领取光效
    self.Panel_effect_buy = ccui.Helper:seekWidgetByName(root, "Panel_effect_buy")

    if self._mType == 1 then
        self:showTaskView()
    else
        self:showBagView()
    end
end

function PrayActivityListCell:showTaskView()
    self._taskInfo = dms.searchs(dms["activity_limit_blessing_task_mould"], activity_limit_pray_task_mould.task_type, self._mInfo.taskId)[1]
    local buyInfo = _ED.active_activity[180].activity_data.buyInfo
    local taskInfo = self._taskInfo
    local taskData = self._mInfo
    self.Panel_buy_list:setVisible(false)
    self.Panel_task_list:setVisible(true)

    local taskType = tonumber(taskInfo[2])
    local title = dms.element(dms["word_mould"], taskInfo[4])[3]
    local content = dms.element(dms["word_mould"], taskInfo[5])[3]

    local nowProgress = taskData.taskGetTimes
    local totalProgress = taskData.taskMaxTimes
    local buyPropCost = buyInfo.consumeNum
    local getCostPropCount = buyInfo.getPropNum
    local buyMaxTime = buyInfo.maxTimes

    local haveGetReward = taskData.state == 2
    local canGetReward = taskData.state == 1

    self.Button_go:setVisible(false)
    self.Button_receive:setVisible(false)
    self.Text_received:setVisible(false)
    
    -- 已领取
    if haveGetReward then
        self.Text_received:setVisible(true)
    elseif canGetReward then
        self.Button_receive:setVisible(true)
    else
        self.Button_go:setVisible(true)
    end

    -- 登录有礼
    if taskType == 1 then
        content = string.format(content, "" .. getCostPropCount)
    elseif taskType == 2 or taskType == 3 or taskType == 4 then -- 主线 试练塔 精英关卡
        content = string.format(content, "" .. taskInfo[3], "" .. getCostPropCount)
    elseif taskType == 5 then -- 金币购买
        local remainTimes = buyMaxTime - nowProgress
        self._remainBuyTimes = remainTimes
        self._buyPropCost = buyPropCost
        self._buyInfo = buyInfo
        content = string.format(content, buyPropCost, remainTimes)
    end

    self.Text_title:setString(title)
    self.Text_activity_name:setString(content)
end

function PrayActivityListCell:playAnimations(sender)
    sender:removeAllChildren()
    local jsonFile = "images/ui/effice/effect_xianshiqiyuan_buttonbuy/effect_buttonbuy.json"
    local atlasFile = "images/ui/effice/effect_xianshiqiyuan_buttonbuy/effect_buttonbuy.atlas"
    local aniName = "animation"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
    animation:setPosition(cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2))
    sender:addChild(animation)
end

function PrayActivityListCell:showBagView()
    self.Panel_buy_list:setVisible(true)
    self.Panel_task_list:setVisible(false)
    local bagInfo = self._mInfo
    self.Image_title:setVisible(false)
    self.Image_title_2:setVisible(false)
    if tonumber(bagInfo.resetType) == 0 then 
        self.Image_title_2:setVisible(true)
    else
        self.Image_title:setVisible(true)
    end
    self.Text_2:setVisible(true)
    self.Text_2:setString(string.format(tipStringInfo_limit_pray_activity_tips[8],bagInfo.finished,bagInfo.canFinish))
    self.Panel_effect_buy:setVisible(false)
    self.Panel_effect_buy:removeAllChildren(true)
    for i = 1, 4 do
        self.Panel_Good[i]:removeAllChildren(true)
        if i > 1 then
            self.Panel_Good[i]:setVisible(false)
        end
    end
    local index = 1
    local fixedReward = string.split(bagInfo.fixedReward, ",")

    local fixedCell = self:addResourcesIconCell(fixedReward)
    self.Panel_Good[index]:addChild(fixedCell)
    index = index + 1
    local haveSelectReward = zstring.split(bagInfo.chooseReward, "|")

    local tipStr = ""
    local isCanChange = false
    self.Button_buy:setTouchEnabled(true)
    self.Button_buy:setBright(true)
    self.Button_buy_2:setVisible(false)
    self.Button_buy:setVisible(false)
    if tonumber(bagInfo.canFinish) > 0 then
        if tonumber(bagInfo.state) == 0 then
            self.Button_buy:setVisible(true)
            tipStr = string.format(tipStringInfo_limit_pray_activity_tips[6], bagInfo.gear)
            isCanChange = true
        elseif tonumber(bagInfo.state) == 1 then
            self.Button_buy_2:setVisible(true)
            tipStr = tipStringInfo_limit_pray_activity_tips[7]
            isCanChange = true
            self.Text_2:setVisible(false)
            self.Panel_effect_buy:setVisible(true)
            self:playAnimations(self.Panel_effect_buy)
        elseif tonumber(bagInfo.state) == 2 then
            self.Button_buy:setVisible(true)
            tipStr = tipStringInfo_limit_pray_activity_tips[1]
            self.Button_buy:setTouchEnabled(false)
            self.Button_buy:setBright(false)
        end
    else
        self.Button_buy:setVisible(true)
        tipStr = tipStringInfo_limit_pray_activity_tips[1]
        self.Button_buy:setTouchEnabled(false)
        self.Button_buy:setBright(false)
    end
    self.Text_1:setString(tipStr)

    for i, v in ipairs(haveSelectReward) do
        self.Panel_Good[index]:setVisible(true)
        local cell = state_machine.excute("pray_activity_goods_cell_create", 0, {mType = 2, mInfo = {mIndex = i, rewardInfo = bagInfo, isCanChange = isCanChange}})
        self.Panel_Good[index]:addChild(cell)
        index = index + 1
    end
end

function PrayActivityListCell:jumpToWindows(taskInfo, mCell)
    local taskJumpType = tonumber(taskInfo[6])

    -- 1.主线 2.精英 3.试炼塔 -1.批量兑换购买祈福值
    if taskJumpType == 1 then
        state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 288, _datas = {}})
    elseif taskJumpType == 2 then
        state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 289, _datas = {}})
    elseif taskJumpType == 3 then
        state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 298, _datas = {}})
    elseif taskJumpType == -1 then
        self:goToExchange(taskInfo, mCell)
    end
end

-- 批量兑换购买祈福值
function PrayActivityListCell:goToExchange(taskInfo, mCell)
    local prop = {}
    local propID = dms.string(dms["activity_config"], 84, activity_config.param)

    local all_money = _ED.user_info.user_gold
    local tip = union_red_envelopes_tips[2]

    if tonumber(all_money) < tonumber(mCell._buyInfo.consumeNum) then
        TipDlg.drawTextDailog(string.format(_new_interface_text[93], tip))
        return
    end

    local max_num = mCell._remainBuyTimes
    local had_num = tonumber(all_money)
    local need_num = tonumber(mCell._buyInfo.consumeNum)
    local may_num = math.floor(had_num / need_num)
    prop.prop_number = may_num > max_num and max_num or may_num
    prop.mould_id = tonumber(propID)
    prop.type = 6

    local prop_info = dms.element(dms["prop_mould"], prop.mould_id)
    if prop.mould_name == nil then
        prop.mould_name = setThePropsIcon(prop.mould_id)[2]
    end
    if prop.prop_quality == nil then
        prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
    end
    prop.mould_remarks = drawPropsDescription(prop.mould_id)
    mCell.prop = prop
    mCell.form_cell = "pray_activity_list_cell"

    app.load("client.packs.prop.ComExchange")
    state_machine.excute("com_exchange_use_open", 0, mCell)
end

function PrayActivityListCell:onEnterTransitionFinish()
end

function PrayActivityListCell:onInit(params)
    -- 加载PrayActivityListCellWindow界面资源.
    -- res.activity.Pray.Pray_list = res/activity/Pray/Pray_list.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/Pray/Pray_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/Pray/Pray_list.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if PrayActivityListCell.__size == nil then
        PrayActivityListCell.__size = root:getContentSize()
    end

    -- 超值礼包购买按钮
    self.Button_buy =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_buy"),
        nil,
        {
            terminal_name = "pray_activity_list_cell_get_reward",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_type = self._mType,
            m_info = self._mInfo
        },
        nil,
        0
    )
    -- 超值礼包领取按钮
    self.Button_buy_2 = 
            fwin:addTouchEventListener(
            ccui.Helper:seekWidgetByName(root, "Button_buy_2"),
            nil,
            {
                terminal_name = "pray_activity_list_cell_get_reward",
                terminal_state = 0,
                isPressedActionEnabled = true,
                m_type = self._mType,
                m_info = self._mInfo
            },
            nil,
            0
    )

    -- 任务列表前往按钮
    self.Button_go =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_go"),
        nil,
        {
            terminal_name = "pray_activity_list_cell_jump_windows",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_cell = self
        },
        nil,
        0
    )

    -- 任务列表领取按钮
    self.Button_receive =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_receive"),
        nil,
        {
            terminal_name = "pray_activity_list_cell_get_reward",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_type = self._mType,
            m_info = self._mInfo
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function PrayActivityListCell:addResourcesIconCell(propData)
    local cell = ResourcesIconCell:createCell()
    local rewardType = tonumber(propData[1])
    if 13 == rewardType then
        local extraTable = {}
        if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
            extraTable.shipStar = tonumber(propData[4])
        else
            extraTable.shipStar = 0
        end
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
    else
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1)
    end
    return cell
end

function PrayActivityListCell:onExit()
    -- 释放PrayActivityListCellWindow界面资源.

    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/Pray/Pray_list.csb", root)
    -- ]]
end

function PrayActivityListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PrayActivityListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/Pray/Pray_list.csb", root)

    self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
