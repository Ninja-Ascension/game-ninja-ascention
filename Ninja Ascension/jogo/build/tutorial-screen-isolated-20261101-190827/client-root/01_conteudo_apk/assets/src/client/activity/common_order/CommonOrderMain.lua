--[[ ----------------------------------------------------------------------------
-- 常规战令主界面
--]] ----------------------------------------------------------------------------
CommonOrderMain = class("CommonOrderMainClass", Window)

-- 打开窗口
local common_order_main_window_open_terminal = {
    _name = "common_order_main_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("CommonOrderMainClass") then
            fwin:open(CommonOrderMain:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local common_order_main_window_close_terminal = {
    _name = "common_order_main_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CommonOrderMainClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(common_order_main_window_open_terminal)
state_machine.add(common_order_main_window_close_terminal)
state_machine.init()

-- 构造器
function CommonOrderMain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.curType = 0                -- 当前战令类型
    self.curStageNums = 0           -- 当前类型的阶段数
    self.curStage = 0               -- 当前战令阶段
    self.finalRewardIndex = 0       -- 奖励跳转idx
    self.MAXBOTTOMNUMS = 4          -- 下面列表最能容下多少cell

    self.isChangeBottomList = false

    self.typeInfo = {}              -- 所有类型的信息
    self.curStageInfo = {}          -- 当前阶段信息
    self.userOrderInfo = {}         -- 玩家战令数据
    self.ButtonTypeList = {}
    self.ButtonStageList = {}
    self.curAdvancedList = {}       -- 进阶奖励内容
   
    app.load("client.activity.common_order.CommonOrderRewardList")
    app.load("client.activity.common_order.CommonOrderTypeTab")
    app.load("client.activity.common_order.CommonOrderTypeTabList")
    app.load("client.activity.common_order.CommonOrderStageTab")
    app.load("client.activity.common_order.CommonOrderWelfare")
    app.load("client.activity.common_order.CommonOrderBuyEnter.lua")
    app.load("client.activity.common_order.CommonOrderActivationEnter.lua")
    app.load("client.activity.common_order.CommonOrderRule")
	app.load("client.utils.CurrencyIcon")
    -- Initialize common_order_main page state machine.
    local function init_common_order_main_terminal()
        -- 打开角色创建窗口
        local common_order_main_open_terminal = {
            _name = "common_order_main_open",
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
        local common_order_main_close_terminal = {
            _name = "common_order_main_close",
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
        local common_order_main_show_terminal = {
            _name = "common_order_main_show",
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
        local common_order_main_hide_terminal = {
            _name = "common_order_main_hide",
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

        -- 购买进阶卡
        local common_order_main_buy_card_terminal = {
            _name = "common_order_main_buy_card",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 购买进阶卡
                if nil ~= instance then
                    local cell = params._datas.cell
                    local isActivation, activationProp = cell:checkUserProp()
                    if isActivation ~= true then
                        state_machine.excute("common_order_buy_enter_window_open", 0, {allRewardInfo = cell.curAdvancedList, type = cell.curType, stage = cell.curStage})
                    else
                        state_machine.excute("common_order_activation_enter_window_open", 0, {type = cell.curType, stage = cell.curStage, propInfo = activationProp})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开全民福利
        local common_order_main_open_welfare_terminal = {
            _name = "common_order_main_open_welfare",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 打开全民福利
                if nil ~= instance then
                    local curType = instance.curType
                    state_machine.excute("common_order_welfare_window_open", 0, {type = curType})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换类型
        local common_order_main_change_type_terminal = {
            _name = "common_order_main_change_type",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 切换类型
                if nil ~= instance then
                    local curType = params._datas.curType
                    instance.curStageNums = params._datas.stageNums

                    instance:updateLeftUI(curType, 1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换阶段
        local common_order_main_change_stage_terminal = {
            _name = "common_order_main_change_stage",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 切换阶段
                if nil ~= instance then
                    local curStage = params._datas.curStage

                    instance:updateBottomUI(curStage)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开规则界面
        local common_order_main_open_rule_terminal = {
            _name = "common_order_main_open_rule",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 打开规则界面
                if nil ~= instance then
                    state_machine.excute("common_orderr_rule_window_open", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取奖励后刷新界面
        local common_order_main_refresh_rewards_state_terminal = {
            _name = "common_order_main_refresh_rewards_state",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 领取奖励后刷新界面
                if nil ~= instance then
                    local mindex = params._datas.rewardIdx
                    local rewardType = params._datas.rewardType

                    local warOrderType = instance.curType
                    local warOrderStage = instance.curStage

                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd,fwin._ui)
                                -- 领取后的刷新
                                instance:refreshReward()
                        end
                    end
                    protocol_command.normal_war_order_get_reward.param_list = warOrderType .. "\r\n" .. warOrderStage .. "\r\n" .. rewardType.. "\r\n" .. mindex
				    NetworkManager:register(protocol_command.normal_war_order_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买/激活战令进阶卡后刷新
        local common_order_main_activation_warorder_terminal = {
            _name = "common_order_main_activation_warorder",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 领取奖励后刷新界面
                if nil ~= instance then
                   instance:updateUIState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭所有窗口
        local common_order_main_close_allInterface_terminal = {
            _name = "common_order_main_close_allInterface",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 关闭所有窗口
                if nil ~= instance then
                    fwin:close(fwin:find("CommonOrderBuyEnterClass"))
                    fwin:close(fwin:find("CommonOrderActivationEnterClass"))
                    fwin:close(fwin:find("CommonOrderWelfareClass"))
                    fwin:close(fwin:find("CommonOrderRuleClass"))
                    if self:checkAllRewardsReceived() == true then
                        _ED.active_activity[185].user_order_info = nil
                        state_machine.excute("home_update_top_activity_info_state", 0, nil)
                    else
                        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 185)
                    end
                    
                    state_machine.excute("common_order_main_window_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(common_order_main_open_terminal)
        state_machine.add(common_order_main_close_terminal)
        state_machine.add(common_order_main_show_terminal)
        state_machine.add(common_order_main_hide_terminal)
        state_machine.add(common_order_main_buy_card_terminal)
        state_machine.add(common_order_main_open_welfare_terminal)
        state_machine.add(common_order_main_change_type_terminal)
        state_machine.add(common_order_main_change_stage_terminal)
        state_machine.add(common_order_main_open_rule_terminal)
        state_machine.add(common_order_main_refresh_rewards_state_terminal)
        state_machine.add(common_order_main_activation_warorder_terminal)
        state_machine.add(common_order_main_close_allInterface_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_common_order_main_terminal()
end

function CommonOrderMain:onUpdate(dt)
    if self.ListView_reward ~= nil and #(self.ListView_reward:getItems()) > 0 then
        local posX = self.ListView_reward:getInnerContainer():getPositionX()
        if posX == self.listview_ContainerPosX then
            return
        end
        self.listview_ContainerPosY = posX
		local items = self.ListView_reward:getItems()
		if items[1] == nil then
			return
		end
        local size = self.ListView_reward:getContentSize()
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempX = v:getPositionX() + posX
			if tempX + itemSize.width + itemSize.width < 0 or tempX > size.width + itemSize.width / 2 then
				v:unload()
			else
				v:reload()
			end
		end
    end
end

-- 判断奖励是否全都被领取
function CommonOrderMain:checkAllRewardsReceived()
    -- 如果全被领取则为true，有奖励未被领取为false
    local isAllReceived = true
    
    if self.userOrderInfo ~= nil then
        -- 所有的全民福利奖励
        local welfareAllInfo = self.userOrderInfo.welfareTaskInfo
        if welfareAllInfo ~= nil then
            for k, welfareTypeInfo in pairs(welfareAllInfo) do
                local welfareState = welfareTypeInfo.taskState
                isAllReceived = self:getRewardState(welfareState)

                if isAllReceived == false then
                    return false
                end

            end
        end

        -- 所有的成就奖励
        local warOrderTypeInfo = self.userOrderInfo.warOrderTypeInfo
        if warOrderTypeInfo ~= nil then
            for i, typeInfo in pairs(warOrderTypeInfo) do
                local type = typeInfo.curType
                local stageNums = typeInfo.stageNums
                for j = 1, stageNums do
                    local stageInfo = self.userOrderInfo.warOrderStageInfo[type][j]
                    
                    local normalStateInfo = stageInfo.normalRewardState
                    isAllReceived = self:getRewardState(normalStateInfo)
                    if isAllReceived == false then
                        return false
                    end

                    local advanceStateInfo = stageInfo.advancedRewardState
                    isAllReceived = self:getRewardState(advanceStateInfo)
                    if isAllReceived == false then
                        return false
                    end

                end
            end
        end
    end

    return true
end

-- 返回奖励是否已全部被领取
function CommonOrderMain:getRewardState(stateInfo)
    local isReceived = true
    for i, state in ipairs(stateInfo) do
        -- 2：已领取状态    
        if state ~= 2 then
            isReceived = false
            break
        end
    end
    return isReceived
end

-- 刷新界面状态
function CommonOrderMain:updateUIState()
    -- 奖励
    self:refreshReward()
    -- 购买按钮
    self:updateDisplayBuyButton()
    self:updateDrawAdvanceLock()
end

-- 领取奖励后刷新界面
function CommonOrderMain:refreshReward()
    self:initUserData()
    self:updateDrawNewRewardState()
    self:updateRedDot()
end

-- 只刷新奖励状态
function CommonOrderMain:updateDrawNewRewardState()
    local allItems = self.ListView_reward:getItems()
    local normalStateInfo = self.curStageInfo.normalRewardState
    local advancedStateInfo = self.curStageInfo.advancedRewardState

    for i, v in ipairs(allItems) do
        v:onUpdateRewardState({normalState = normalStateInfo[i], advanceState = advancedStateInfo[i]})
    end
end

-- 检测玩家是否拥有该道具
function CommonOrderMain:checkUserProp()
    local state = false
    local propInfo = {}
    if self.curType == 1 then
        propInfo = dms.string(dms["play_config"], 267, play_config.param)
    elseif self.curType == 2 then
        propInfo = dms.string(dms["play_config"], 268, play_config.param)
    elseif self.curType == 3 then
        propInfo = dms.string(dms["play_config"], 269, play_config.param)
    elseif self.curType == 4 then
        propInfo = dms.string(dms["play_config"], 270, play_config.param)
    end
    local propID = tonumber(zstring.split(propInfo, ",")[2])
    return tonumber(getPropAllCountByMouldId(propID)) > 0, propInfo
end

function CommonOrderMain:updateDrawAdvanceLock()
    if self.curStageInfo.isActivated == 0 then
        self.Image_lock_advance:setVisible(true)
    else
        self.Image_lock_advance:setVisible(false)
    end
end

function CommonOrderMain:initUserData()
    local userdata = _ED.active_activity[185].user_order_info
    if userdata ~= nil then
        self.userOrderInfo = userdata
    end
end

-- 判断购买进阶战令按钮是否显示
function CommonOrderMain:updateDisplayBuyButton()
    local isActivated = self.curStageInfo.isActivated
    if isActivated == 0 then
        self.Button_buy_Card:setVisible(true)
        local ishaveActivationProp, activationProp = self:checkUserProp()
        -- 若有激活道具
        if ishaveActivationProp == true then
            self.Text_5:setVisible(true)
            self.Text_1:setVisible(false)
            self.Panel_1:setVisible(true)
            
            local activationPropInfo = zstring.split(activationProp, ",", function ( value ) return tonumber(value) end)
            local icon_index = setThePropsIcon(activationPropInfo[2])[1]
            local iconPicPath = string.format("images/ui/props/props_%d.png", icon_index)
            local costNums = activationPropInfo[3]

            self.Text_5:setString(_string_piece_info[152]..costNums)
            self.Panel_1:setBackGroundImage(iconPicPath)
        else
            self.Text_5:setVisible(false)
            self.Panel_1:setVisible(false)
            self.Text_1:setVisible(true)

            local money = self:getCurStagePrice()
            self.Text_1:setString(_string_piece_info[217]..money)
        end
    else
        self.Button_buy_Card:setVisible(false)
    end
end

function CommonOrderMain:getRewardData()
    local stageInfo = dms.searchs(dms["pass_mould"], pass_mould.type, self.curType, pass_mould.stage, self.curStage)
    local achieveString = dms.atos(stageInfo[1], pass_mould.achieve)
    local achieveInfo = zstring.split(achieveString, ",", function ( value ) return tonumber(value) end)
    return achieveInfo
end

-- 获取当前阶段战令的价格
function CommonOrderMain:getCurStagePrice()
    local warOrderInfo = dms.searchs(dms["pass_mould"], pass_mould.type, self.curType, pass_mould.stage, self.curStage)
    local giftID = dms.atoi(warOrderInfo[1], pass_mould.giftID)
    local gearID = dms.int(dms["recharge_gear_mould"],giftID, recharge_gear_mould.gearID)
    local money = dms.string(dms["top_up_goods"], gearID, top_up_goods.money)
    return money
end

-- function CommonOrderMain:updateDrawPrice()
--     local money = self:getCurStagePrice()
--     self.Text_1:setString(_string_piece_info[217]..money)
-- end

function CommonOrderMain:updateDrawBackImg()
    local root = self.roots[1]
    local Panel_img = ccui.Helper:seekWidgetByName(root, "Panel_copywriting")
    local resPath = string.format("image/activity/passport/activity_passport_copywriting_%d.png", self.curType)
    Panel_img:removeBackGroundImage()
	Panel_img:setBackGroundImage(resPath)
end

function CommonOrderMain:updateBottomUI(stage)
    if stage ~= nil then
        self.curStage = stage
    end
    for i, v in ipairs(self.ButtonStageList) do
        if v.stage == self.curStage then
            v.Button_stage:setTouchEnabled(false)
            v.Button_stage:setHighlighted(true)
        else
            v.Button_stage:setTouchEnabled(true)
            v.Button_stage:setHighlighted(false)
        end
    end
    self.curStageInfo = self.userOrderInfo.warOrderStageInfo[self.curType][self.curStage]
    self:updateDrawReward()
    -- self:updateDrawPrice()
    self:updateDisplayBuyButton()
    self:updateDrawAdvanceLock()
    self:updateDrawBackImg()
end

function CommonOrderMain:updateLeftUI(type, stage)
    if type ~= nil and stage ~= nil then
        self.curType = type
        self.curStage = stage
    end
    for i, v in ipairs(self.ButtonTypeList) do
        local Text_dark = v.Text_type_1
        local Text_light = v.Text_type_2
        local Button_tab = ccui.Helper:seekWidgetByName(v, "Button_paging_tab_1")
        if v.curType == self.curType then
            Text_dark:setVisible(false)
            Text_light:setVisible(true)
            Button_tab:setTouchEnabled(false)
            Button_tab:setHighlighted(true)
        else
            Text_dark:setVisible(true)
            Text_light:setVisible(false)
            Button_tab:setTouchEnabled(true)
            Button_tab:setHighlighted(false)
        end
    end
    self:initDrawBottom()
    self:updateBottomUI()
    self:updateRedDot()
end

-- 刷新红点状态
function CommonOrderMain:updateRedDot()
    fwin:addService({
		callback = function ( params )
			state_machine.excute("notification_center_update", 0, "push_notification_common_warorder_welfare_reward_push")
            state_machine.excute("notification_center_update", 0, "push_notification_common_warorder_type_reward_can_receive_push")
		end,
		delay = 0,
	})
end

-- 初始化红点
function CommonOrderMain:drawRedDot()
    -- 全民福利红点
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_common_warorder_welfare_reward_push",
	_widget = self.Button_national_welfare,
	_invoke = nil,
	_interval = 0.5,})

    -- 左侧类型标签红点
    for i, Button_cell in ipairs(self.ButtonTypeList) do
        local Image_1 =  ccui.Helper:seekWidgetByName(Button_cell, "Image_1")
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_common_warorder_type_reward_can_receive_push",
        _widget = Image_1,
        _invoke = nil,
        _interval = 0.5,
        _buttonType = Button_cell.curType})
    end
end

-- 获取当前战令的类型和阶段
function CommonOrderMain:getCurType()
    return self.curType
end

-- 绘制奖励内容
function CommonOrderMain:updateDrawReward()
    self.ListView_reward:removeAllItems()
    local achieveInfo = self:getRewardData()
    local normalStateInfo = self.curStageInfo.normalRewardState
    local advancedStateInfo = self.curStageInfo.advancedRewardState
    -- debug.print_r(normalStateInfo, "=======normalStateInfo")
    -- local normalStateInfo = {0, 0, 0, 0, 1, 1}
    -- local advancedStateInfo = {0, 0, 0, 0, 1, 1}
    local firstUncompleteIdx = 0
    for i, v in ipairs(normalStateInfo) do
        if normalStateInfo[i] == 1 or advancedStateInfo[i] == 1 then
            self.finalRewardIndex = i
        end
        if firstUncompleteIdx == 0 then
            if normalStateInfo[i] == 0 and advancedStateInfo[i] == 0 then
                firstUncompleteIdx = i
            end
        end
    end
    self.curAdvancedList = {}
    -- debug.print_r(achieveInfo, '=======achieveInfo')
    for i, v in ipairs(achieveInfo) do
        local rewardCell = state_machine.excute("common_order_reward_list_create", 0, {achieveID = v, index = i, normalState = normalStateInfo[i], advanceState = advancedStateInfo[i]})
        local rewardString = dms.string(dms["achieve"], v, achieve.reward_value)
        local advanceRewardInfo = zstring.split(rewardString, "!")[2]
        local rewardAdvanced = zstring.split(advanceRewardInfo, "|")
        for j, k in ipairs(rewardAdvanced) do
            table.insert(self.curAdvancedList, k)
        end
        self.ListView_reward:addChild(rewardCell)
    end
    local MAXITEMNUMS = 6
    local jumpIdx = self.finalRewardIndex
    if self.finalRewardIndex == 0 then
        if firstUncompleteIdx ~= 0 then
            jumpIdx = firstUncompleteIdx
        end
    end
    if jumpIdx > MAXITEMNUMS then
        local subIdx = table.nums(normalStateInfo) - MAXITEMNUMS
        
        if jumpIdx >= subIdx then
            jumpIdx = subIdx
        end
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.01), cc.CallFunc:create(function ( sender )
            listviewPositioningMoves(self.ListView_reward, jumpIdx, 0, true)
        end)}))
    else
        self.ListView_reward:jumpToLeft()
    end
    self.ListView_reward:requestRefreshView()
    self.listview_ContainerPosX = self.ListView_reward:getInnerContainer():getPositionX()
end

-- 绘制下边阶段列表
function CommonOrderMain:initDrawBottom()
    local root = self.roots[1]
    local ListView_stage1 = ccui.Helper:seekWidgetByName(root, "ListView_3")
    ListView_stage1:removeAllItems()
    self.isChangeBottomList = false
    -- local stageInfo = self.userOrderInfo.warOrderStageInfo[self.curType]
    -- local stageInfo = {{isActivated = 0, normalRewardState = {0,0,0,0,0}, advancedRewardState = {0,0,0,0,1}}, {isActivated = 0, normalRewardState = {0,0,0,0,0}, advancedRewardState = {0,0,0,0,1}}}
    -- local stageNums = self.typeInfo[]
    self.curStage = 0
    self.ButtonStageList = {}
    for i = 1, self.curStageNums do
        local cell = state_machine.excute("common_order_stage_tab_window_tab_cell_create", 0, {stage = i})
        ListView_stage1:addChild(cell)
        local Button_stage_tab = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell, "Button_1"), nil,
		{
			terminal_name = "common_order_main_change_stage",
			terminal_state = 0,
			isPressedActionEnabled = true,
			curStage = i,
		}, nil, 0)
        table.insert(self.ButtonStageList, cell)
        self.curStage = self.curStage + 1
    end
    -- print(self.curType, "==========", self.curStage, "==========")
    self.curStageInfo = self.userOrderInfo.warOrderStageInfo[self.curType][self.curStage]
    ListView_stage1:requestRefreshView()

    -- 滚动到最后一个
    fwin:addService(
        {
            callback = function(params)
                params:jumpToRight()
            end,
            delay = 0.01,
            params = ListView_stage1
        }
    )

    self.isChangeBottomList = true
    
    if self.curStageNums < self.MAXBOTTOMNUMS then
        self.Image_left_scroll:setVisible(false)
        self.Image_right_scroll:setVisible(false)
    else
        self.Image_left_scroll:setVisible(false)
        self.Image_right_scroll:setVisible(true)
        local function scrollViewEvent(sender, evenType)
            if self.isChangeBottomList == true then
                self.Image_left_scroll:setVisible(true)
                self.Image_right_scroll:setVisible(true)
                if evenType == ccui.ScrollviewEventType.bounceLeft then
                    --滚动视图滚动到左边界并且开始回弹时发出的事件
                    self.Image_left_scroll:setVisible(false)
                    self.Image_right_scroll:setVisible(true)
                elseif evenType == ccui.ScrollviewEventType.bounceRight then
                    --滚动视图滚动到左边界并且开始回弹时发出的事件
                    self.Image_right_scroll:setVisible(false)
                    self.Image_left_scroll:setVisible(true)
                end
        
                -- if evenType == ccui.ScrollviewEventType.bounceRight then
                --     --滚动视图滚动到左边界并且开始回弹时发出的事件
                --     self.Image_right_scroll:setVisible(false)
                --     self.Image_left_scroll:setVisible(true)
                -- end
            end
        end
        ListView_stage1:addScrollViewEventListener(scrollViewEvent)
    end

end

-- 初始化当前的类型和当前的阶段数
function CommonOrderMain:initCurTypeInfo()
    self.typeInfo = self.userOrderInfo.warOrderTypeInfo
    for i, v in pairs(self.typeInfo) do
        if self.curStageNums == 0 and self.curType == 0 then
            self.curStageNums = v.stageNums
            self.curType = v.curType
            break
        end
    end
end

-- 绘制左边类型列表
function CommonOrderMain:initDrawLeft()
    self.Panel_common_paging:removeAllChildren()
    self.ButtonTypeList = {}

    local leftPanel = state_machine.excute("common_order_type_tab_window_create", 0, nil)
    self.Panel_common_paging:addChild(leftPanel)

    local ListView_tab = leftPanel.ListView_paging_tab
    ListView_tab:removeAllItems()

    for i, v in pairs(self.typeInfo) do

        local cell = state_machine.excute("common_order_type_tab_list_create", 0, v)
        ListView_tab:addChild(cell)
        table.insert(self.ButtonTypeList, cell)

        local Image_1 = ccui.Helper:seekWidgetByName(cell, "Image_1")
		Image_1:setVisible(false)

        local Button_type_tab = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell, "Button_paging_tab_1"), nil,
		{
			terminal_name = "common_order_main_change_type",
			terminal_state = 0,
			isPressedActionEnabled = true,
			curType = v.curType,
            stageNums = v.stageNums,
		}, nil, 0)

    end
    ListView_tab:jumpToTop()
    ListView_tab:requestRefreshView()
end


function CommonOrderMain:showCurrencyUI()
	-- 货币显示（金币、体力、钻石）
	local root = self.roots[1]
	local cell = state_machine.excute("currency_icon_create", 0, {propType = 2, propID = nil})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_1"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_1"):addChild(cell)

    cell = state_machine.excute("currency_icon_create", 0, {propType = 12, propID = nil})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_2"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_2"):addChild(cell)

	cell = state_machine.excute("currency_icon_create", 0, {propType = 1, propID = nil})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_3"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_3"):addChild(cell)

end

function CommonOrderMain:onUpdateDraw()
    local root = self.roots[1]
    -- 类型按钮列表
    self.Panel_common_paging = ccui.Helper:seekWidgetByName(root, "Panel_common_paging_1")
    -- 阶段按钮列表
    self.ListView_stage = ccui.Helper:seekWidgetByName(root, "ListView_3")
    -- 奖励绘制列表
    self.ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_2")
    -- 进阶奖励锁图案
    self.Image_lock_advance = ccui.Helper:seekWidgetByName(root, "Image_10")
    -- 阶段右滑按钮提示
    self.Image_right_scroll = ccui.Helper:seekWidgetByName(root, "Button_5_0")
    -- 阶段左滑按钮提示
    self.Image_left_scroll = ccui.Helper:seekWidgetByName(root, "Button_5")
    -- 进阶道具消耗数量文本
    self.Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
    -- 进阶价格文本
    self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 进阶道具消耗图标容器
    self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    self.Image_left_scroll:setVisible(false)
    self.Image_right_scroll:setVisible(false)

    self:initCurTypeInfo()
    self:initDrawLeft()
    self:updateLeftUI()
    self:showCurrencyUI()
    -- local allNums = 
end

function CommonOrderMain:drawButton()
    local root = self.roots[1]

    -- 购买进阶卡
    self.Button_buy_Card =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_3"),
        nil,
        {
            terminal_name = "common_order_main_buy_card",
            terminal_state = 0,
            isPressedActionEnabled = true,
            cell = self,
        },
        nil,
        0
    )

    -- 打开全民福利界面
    self.Button_national_welfare =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_4"),
        nil,
        {
            terminal_name = "common_order_main_open_welfare",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    -- 关闭界面
    self.Button_close =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "common_order_main_close_allInterface",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    -- 打开规则界面
    self.Button_rule =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_1"),
        nil,
        {
            terminal_name = "common_order_main_open_rule",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )
end

-- 对象初始化
function CommonOrderMain:init(params)
  
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function CommonOrderMain:onUpdate(dt)
    if self.ListView_reward ~= nil and #(self.ListView_reward:getItems()) > 0 then
        local posX = self.ListView_reward:getInnerContainer():getPositionX()
        if posX == self.listview_ContainerPosX then
            return
        end
        self.listview_ContainerPosY = posX
		local items = self.ListView_reward:getItems()
		if items[1] == nil then
			return
		end
        local size = self.ListView_reward:getContentSize()
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempX = v:getPositionX() + posX
			if tempX + itemSize.width + itemSize.width < 0 or tempX > size.width + itemSize.width / 2 then
				v:unload()
			else
				v:reload()
			end
		end
    end
end


function CommonOrderMain:onEnterTransitionFinish()
    -- 加载ChristmasRomanceShopWindow界面资源.
    local csbNode = csb.createNode("activity/passport/passport_main_changgui.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:initUserData()
    self:drawButton()
    self:onUpdateDraw()
    self:drawRedDot()

   
end

function CommonOrderMain:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("common_order_main_open")
    state_machine.remove("common_order_main_close")
    state_machine.remove("common_order_main_show")
    state_machine.remove("common_order_main_hide")
    state_machine.remove("common_order_main_buy_card")
    state_machine.remove("common_order_main_open_welfare")
    state_machine.remove("common_order_main_change_type")
    state_machine.remove("common_order_main_change_stage")
    state_machine.remove("common_order_main_open_rule")
    state_machine.remove("common_order_main_refresh_rewards_state")
    state_machine.remove("common_order_main_activation_warorder")
    state_machine.remove("common_order_main_close_allInterface")
end

function CommonOrderMain:close()
    -- window event : close.
end

function CommonOrderMain:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
