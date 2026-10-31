--[[ ----------------------------------------------------------------------------
-- 幸运转盘
--]] ----------------------------------------------------------------------------
ChristmasRomanceTurntable = class("ChristmasRomanceTurntableClass", Window)

-- 打开窗口
local christmas_romance_turntable_window_open_terminal = {
    _name = "christmas_romance_turntable_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ChristmasRomanceTurntableClass") then
            fwin:open(ChristmasRomanceTurntable:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local christmas_romance_turntable_window_close_terminal = {
    _name = "christmas_romance_turntable_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ChristmasRomanceTurntableClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(christmas_romance_turntable_window_open_terminal)
state_machine.add(christmas_romance_turntable_window_close_terminal)
state_machine.init()

-- 构造器
function ChristmasRomanceTurntable:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.deltaTime = 1
    self.totalTime = 0
    self.lightList = {}
    self.isPlayOne = false
    self.isPlayTen = false
    self.lastBeginRound = 1
    self._activityEndTime = nil
    self._activityInfos = nil
    self._page = 0 -- 1:钻石转盘 2:幸运转盘
    -- load lua files.
    app.load("client.activity.christmas_romance.ChristmasRomanceGemlack")
    app.load("client.activity.christmas_romance.ChristmasRomancePromt")
    app.load("client.activity.christmas_romance.ChristmasRomanceBox")
    app.load("client.activity.christmas_romance.ChristmasRomanceItem")
    -- Initialize christmas romance turntable
    local function init_christmas_romance_turntable_terminal()
        -- 打开角色创建窗口
        local christmas_romance_turntable_open_terminal = {
            _name = "christmas_romance_turntable_open",
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
        local christmas_romance_turntable_close_terminal = {
            _name = "christmas_romance_turntable_close",
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
        local christmas_romance_turntable_show_terminal = {
            _name = "christmas_romance_turntable_show",
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
        local christmas_romance_turntable_hide_terminal = {
            _name = "christmas_romance_turntable_hide",
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

        -- 领取宝箱奖励
        local christmas_romance_turntable_get_box_reward_terminal = {
            _name = "christmas_romance_turntable_get_box_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params then
                    local mType = params[1]
                    local info = params[2]

                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                -- 领取宝箱
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd, fwin._ui)

                                state_machine.excute("christmas_romance_turntable_refush_box", 0, "")
                                state_machine.excute("christmas_romance_top_info_refresh_prop_count", 0, nil)
                                fwin:addService(
                                    {
                                        callback = function(params)
                                            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 181)
                                            state_machine.excute("notification_center_update", 0, "push_notification_christmas_romance_page_push")
                                        end,
                                        delay = 0
                                    }
                                )
                            end
                        end
                    end
                    protocol_command.lucky_turntable_open_chest.param_list = (mType - 1) .. "\r\n" .. info.id
                    NetworkManager:register(protocol_command.lucky_turntable_open_chest.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 跳过动画
        local christmas_romance_turntable_anim_stop_terminal = {
            _name = "christmas_romance_turntable_anim_stop",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:clearRound()
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(7)
                fwin:open(getRewardWnd, fwin._ui)
                instance.lastBeginRound = instance.rewardsToIndex[tonumber( _ED.active_activity[181].activity_data.hitList[1])]
                instance.isPlayOne = false
                instance.isPlayTen = false
                instance.Image_touch_skip:setVisible(false)
                state_machine.unlock("christmas_romance_turntable_click_extract", 0, "")
                instance:stateResetUpdate(true)
                instance:extractRefresh()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切页
        local christmas_romance_turntable_change_page_terminal = {
            _name = "christmas_romance_turntable_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.isPlayOne or instance.isPlayTen then
                    return
                end
                if nil ~= instance and nil ~= params then
                    local mPage = params._datas.m_page
                    instance:changePage(mPage)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击抽取
        local christmas_romance_turntable_click_extract_terminal = {
            _name = "christmas_romance_turntable_click_extract",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance and params then
                    if instance:haveActivityEnd() then
                        -- 活动结束
                        TipDlg.drawTextDailog(tipStringInfo_christmas_romance_activity_tips[6])
                        return
                    end
                    state_machine.lock("christmas_romance_turntable_click_extract")
                    local times = params._datas.m_times
                    local mCell = params._datas.m_cell
                    local mType = mCell._page
                    if not instance:haveEnoughProp(mType, times) then
                        if mType == 1 then
                            state_machine.excute("christmas_romance_gemlack_window_open", 0, "")
                        else
                            -- 幸运抽奖券不足
                            TipDlg.drawTextDailog(tipStringInfo_christmas_romance_activity_tips[1])
                        end
                        state_machine.unlock("christmas_romance_turntable_click_extract")
                        return true
                    end

                    -- instance:stateResetUpdate(false)

                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                -- 开始抽奖
                                instance.Image_touch_skip:setVisible(true)
                                if fwin:find("ChristmasRomancePromtClass") then
                                    state_machine.excute("christmas_romance_promt_window_close", 0, "")
                                end
                                if times == 1 then
                                    instance:playOneRound(mType)
                                else
                                    instance:playTenRound()
                                end

                                state_machine.excute("christmas_romance_turntable_refush_red", 0, "")
                                state_machine.excute("christmas_romance_top_info_refresh_prop_count", 0, nil)
                                fwin:addService(
                                    {
                                        callback = function(params)
                                            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 181)
                                            state_machine.excute("notification_center_update", 0, "push_notification_christmas_romance_page_push")
                                        end,
                                        delay = 0
                                    }
                                )
                            else
                                state_machine.unlock("christmas_romance_turntable_click_extract")
                            end
                        else
                            state_machine.unlock("christmas_romance_turntable_click_extract")
                        end
                    end
                    local function extractCallback()
                        protocol_command.lucky_turntable_draw.param_list = (mType - 1) .. "\r\n" .. times
                        NetworkManager:register(protocol_command.lucky_turntable_draw.code, nil, nil, nil, instance, responseCallback, false, nil)
                    end
                    -- 是否选择二次提示
                    if not instance:getSkipState(mType) then
                        -- 弹窗确认
                        state_machine.excute("christmas_romance_promt_window_open", 0, {mTurnType = mType, mCallBack = extractCallback, mTimes = times})
                        state_machine.unlock("christmas_romance_turntable_click_extract")
                    else
                        extractCallback()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 幸运转盘重置
        local christmas_romance_turntable_reset_terminal = {
            _name = "christmas_romance_turntable_reset",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.isPlayOne or instance.isPlayTen then
                    return
                end
                state_machine.lock("christmas_romance_turntable_reset")
                if instance:haveActivityEnd() then
                    -- 活动结束
                    TipDlg.drawTextDailog(tipStringInfo_christmas_romance_activity_tips[6])
                    state_machine.unlock("christmas_romance_turntable_reset")
                    return
                end
                if not instance:haveResetTence() then
                    -- 重置次数不足
                    TipDlg.drawTextDailog(tipStringInfo_christmas_romance_activity_tips[4])
                    state_machine.unlock("christmas_romance_turntable_reset")
                    return
                end
                if not instance:haveResetProp() then
                    -- 重置道具不足
                    TipDlg.drawTextDailog(tipStringInfo_christmas_romance_activity_tips[5])
                    state_machine.unlock("christmas_romance_turntable_reset")
                    return
                end
                state_machine.unlock("christmas_romance_turntable_reset")

                local function callback()
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                -- 重置
                                fwin:close(fwin:find("ChristmasRomancePromtClass"))
                                TipDlg.drawTextDailog(tipStringInfo_christmas_romance_activity_tips[7])
                                response.node:drawPageLuckyUI()
                                response.node:drawAllReward(false, 2)
                            end
                        end
                    end
                    protocol_command.lucky_turntable_flash.param_list = ""
                    NetworkManager:register(protocol_command.lucky_turntable_flash.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                state_machine.excute("christmas_romance_promt_window_open", 0, {mTurnType = 3, mCallBack = callback})                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 红点刷新
        local christmas_romance_turntable_refush_red_terminal = {
            _name = "christmas_romance_turntable_refush_red",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance:refushExactRed()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 宝箱刷新
        local christmas_romance_turntable_refush_box_terminal = {
            _name = "christmas_romance_turntable_refush_box",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance:drawBoxView(instance._page)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(christmas_romance_turntable_open_terminal)
        state_machine.add(christmas_romance_turntable_close_terminal)
        state_machine.add(christmas_romance_turntable_show_terminal)
        state_machine.add(christmas_romance_turntable_hide_terminal)
        state_machine.add(christmas_romance_turntable_change_page_terminal)
        state_machine.add(christmas_romance_turntable_click_extract_terminal)
        state_machine.add(christmas_romance_turntable_reset_terminal)
        state_machine.add(christmas_romance_turntable_anim_stop_terminal)
        state_machine.add(christmas_romance_turntable_get_box_reward_terminal)
        state_machine.add(christmas_romance_turntable_refush_red_terminal)
        state_machine.add(christmas_romance_turntable_refush_box_terminal)
        state_machine.init()
    end
    -- call func init christmas romance turntable state machine.
    init_christmas_romance_turntable_terminal()
end

-- 对象初始化
function ChristmasRomanceTurntable:init(params)
    self._page = params
    self._activityInfos = _ED.active_activity[181].activity_data
    self._activityEndTime = _ED.active_activity[181].activity_data.romanceEndTime
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function ChristmasRomanceTurntable:onInit(params)
    -- 加载ChristmasRomanceTurntableWindow界面资源.
    -- res.cultivate.Mythical_animals.christmas_romance_turntable = res/activity/christmas_romance/christmas_romance_turntable.csb
    local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_turntable.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local idResources = state_machine.excute("christmas_romance_get_resources_id")
    if idResources > 0 then
        local newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_bg.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Image_13"):loadTexture(newPath)
        end

        newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_title1.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Image_title_1"):loadTexture(newPath)
        end
    end

    self:drawBtn()
    self:onUpdateDraw()
    self:changePage()
    self:refushExactRed()
    self:drawPageRed()
end

function ChristmasRomanceTurntable:onUpdateDraw()
    local root = self.roots[1]

    -- 道具图
    self.Panel_treasure_icon = {}
    for i = 1, 16 do
        self.Panel_treasure_icon[i] = ccui.Helper:seekWidgetByName(root, "Panel_treasure_icon_" .. i)
    end

    -- 转盘光效
    self.Panel_light_effect = {}
    -- 已领取标识
    self.Image_done = {}
    for i = 1, 16 do
        self.Panel_light_effect[i] = ccui.Helper:seekWidgetByName(root, "Panel_light_effect_" .. i)
        self.Image_done[i] = ccui.Helper:seekWidgetByName(root, "Image_done_" .. i)
    end

    -- 钻石转盘组
    self.Panel_gem_draw = ccui.Helper:seekWidgetByName(root, "Panel_gem_draw")

    -- 幸运转盘组
    self.Panel_juan_draw = ccui.Helper:seekWidgetByName(root, "Panel_juan_draw")

    -- 十连抽消耗数量
    self.Text_darw_ten_gem_n = ccui.Helper:seekWidgetByName(root, "Text_darw_ten_gem_n")

    -- 单抽消耗数量
    self.Text_darw_one_gem_n = ccui.Helper:seekWidgetByName(root, "Text_darw_one_gem_n")

    -- 活动倒计时
    self.Text_turntime_time = ccui.Helper:seekWidgetByName(root, "Text_turntime_time")
    self:updateActivityRemainTime()

    -- 累计奖品列表
    self.ScrollView_rewardlist_2 = ccui.Helper:seekWidgetByName(root, "ScrollView_rewardlist_2")

    -- 累计抽取数量
    self.Text_draw_num_1 = ccui.Helper:seekWidgetByName(root, "Text_draw_num_1")

    -- 刷新按钮红点
    self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")

    -- 剩余刷新次数
    self.Text_refresh_time_n = ccui.Helper:seekWidgetByName(root, "Text_refresh_time_n")

    -- 刷新券图标
    self.Image_refresh = ccui.Helper:seekWidgetByName(root, "Image_refresh")

    -- 刷新券数量
    self.Text_refesh_num = ccui.Helper:seekWidgetByName(root, "Text_refesh_num")
end

function ChristmasRomanceTurntable:changePage(pageIdx)
    if pageIdx and pageIdx == self._page then
        return
    end
    if pageIdx then
        self._page = pageIdx
    end
    local curPage = self._page
    self.Button_gold_turnable:setTouchEnabled(true)
    self.Button_gold_turnable:setHighlighted(false)
    self.Button_gem_turnable:setTouchEnabled(true)
    self.Button_gem_turnable:setHighlighted(false)
    self.Panel_gem_draw:setVisible(false)
    self.Panel_juan_draw:setVisible(false)
    if curPage == 1 then
        self:drawPageDimond()
        self.Panel_gem_draw:setVisible(true)
        self.Button_gold_turnable:setTouchEnabled(false)
        self.Button_gold_turnable:setHighlighted(true)
    elseif curPage == 2 then
        self:drawPageLucky()
        self.Panel_juan_draw:setVisible(true)
        self.Button_gem_turnable:setTouchEnabled(false)
        self.Button_gem_turnable:setHighlighted(true)
    end
end

function ChristmasRomanceTurntable:stateResetUpdate(state)
    if self._page == 2 then
        if state then
            local totalReset = self:getResetTimes()
            local haveReset = tonumber(_ED.active_activity[181].activity_data.resetTimes)
            local surpReset = totalReset - haveReset
            if surpReset > 0 then 
                self.Button_refresh_reward:setTouchEnabled(true)
                self.Button_refresh_reward:setBright(true)
            end
        else
            self.Button_refresh_reward:setTouchEnabled(false)
            self.Button_refresh_reward:setBright(false)
        end
    end
end

function ChristmasRomanceTurntable:clearRound()
    for i, item in ipairs(self.lightList) do
        item.animation:setVisible(false)
        item.animation._invoke = nil
        item:stopAllActions()
    end
end

function ChristmasRomanceTurntable:playOneRound(mType)
    local rewardList = self._activityInfos.rewardsDiamond
    if mType == 2 then
        rewardList = self._activityInfos.rewardsLucky
    end
    self:clearRound()
    local round = 2
    local rewardIndex = self.rewardsToIndex[tonumber(self._activityInfos.hitList[1])]
    local num = table.nums(self.lightList) * round + rewardIndex
    local allTime = 0
    local function changeActionCallbackZore(anim0)
        for i = self.lastBeginRound, num do
            local index = i % table.nums(self.lightList) == 0 and table.nums(self.lightList) or i % table.nums(self.lightList)
            if mType == 2 and i ~= self.lastBeginRound and tonumber(self._activityInfos.lastRewardState[index]) == 0 then
            else
                local curNode = self.lightList[index]
                local time = 0
                if (i > self.lastBeginRound and i <= self.lastBeginRound + 4) or i >= num - 4 then
                    time = 0.2
                else
                    time = 0.05
                end
                allTime = allTime + time
                curNode:runAction(
                    cc.Sequence:create(
                        cc.DelayTime:create(allTime),
                        cc.CallFunc:create(
                            function()
                                curNode.animation:setVisible(true)
                                if i == num then
                                    --播放中奖动画
                                    self.lastBeginRound = rewardIndex

                                    local function tempActionCallback(anim_temp)
                                        if anim_temp then
                                            anim_temp._invoke = nil
                                            anim_temp:removeFromParent(true)
                                        end
                                    end
                                    local jsonFile = "images/ui/effice/effect_jlmbb/effect_jlmbb.json"
                                    local atlasFile = "images/ui/effice/effect_jlmbb/effect_jlmbb.atlas"
                                    local animation3 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
                                    animation3.animationNameList = {"animation"}
                                    sp.initArmature(animation3, false)
                                    animation3._invoke = tempActionCallback
                                    animation3:setPosition(cc.p(curNode:getContentSize().width / 2, curNode:getContentSize().height / 2))
                                    curNode:addChild(animation3)
                                    animation3:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                                    csb.animationChangeToAction(curNode.animation, 0, 0, false)

                                    local function changeActionCallbackTwo(anim1)
                                        if self.isPlayOne then
                                            app.load("client.reward.DrawRareReward")
                                            local getRewardWnd = DrawRareReward:new()
                                            getRewardWnd:init(7)
                                            fwin:open(getRewardWnd, fwin._ui)
                                            self.isPlayOne = false
                                            self:clearRound()
                                            self.Image_touch_skip:setVisible(false)
                                            state_machine.unlock("christmas_romance_turntable_click_extract")
                                            self:stateResetUpdate(true)
                                            self:extractRefresh()
                                        end
                                        anim1._invoke = nil
                                    end
                                    self.isPlayOne = true
                                    curNode.animation._invoke = changeActionCallbackTwo
                                    curNode.animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                                    csb.animationChangeToAction(curNode.animation, 2, 2, false)
                                else
                                    local function changeActionCallbackOne(anima)
                                        if anima then
                                            anima:setVisible(false)
                                            anima._invoke = nil
                                        end
                                    end
                                    curNode.animation._invoke = changeActionCallbackOne
                                    curNode.animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                                    csb.animationChangeToAction(curNode.animation, 1, 1, false)
                                end
                            end
                        )
                    )
                )
            end
        end
        anim0._invoke = nil
    end

    self.lightList[self.lastBeginRound].animation:setVisible(true)
    self.lightList[self.lastBeginRound].animation._invoke = changeActionCallbackZore
    self.lightList[self.lastBeginRound].animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(self.lightList[self.lastBeginRound].animation, 0, 0, false)
end

function ChristmasRomanceTurntable:playTenRound()
    local rewardList = self._activityInfos.rewardsDiamond
    self:clearRound()
    local ids = {}
    for i, v in ipairs(self._activityInfos.hitList) do
        table.insert(ids, self.rewardsToIndex[tonumber(v)])
    end
    
    local playIds = {}
    local allRoundIds = {}
    local count = 1
    allRoundIds[count] = {}
    for i, v in ipairs(ids) do
        if table.containValue(allRoundIds[count], v) then
            table.sort(
                allRoundIds[count],
                function(a, b)
                    return a < b
                end
            )
            count = count + 1
            allRoundIds[count] = {}
        end
        table.insert(allRoundIds[count], v)
    end
    table.insert(allRoundIds, 1, {})
    self.allRoundIds = allRoundIds
    local sortHandle = function (a,b)
        return a < b
    end
    for i,v in ipairs(self.allRoundIds) do
        table.sort(self.allRoundIds[i],sortHandle)
    end
    local function changeActionCallbackZore(anim0)
        self:playRound(1, self.lastBeginRound)
        self.lastBeginRound = ids[#ids]
        anim0._invoke = nil
        anim0:setVisible(false)
    end
    self.lightList[self.lastBeginRound].animation:setVisible(true)
    self.lightList[self.lastBeginRound].animation._invoke = changeActionCallbackZore
    self.lightList[self.lastBeginRound].animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(self.lightList[self.lastBeginRound].animation, 0, 0, false)
end

function ChristmasRomanceTurntable:playRound(round, index)
    local curNode = self.lightList[index]
    local time = 0.01

    local curRound = self.allRoundIds[round]
    if table.containValue(curRound, index) then
        time = 1
    end
    self.isPlayTen = true
    curNode.animation:setVisible(true)

    if table.containValue(curRound, index) then
        local function tempActionCallback1(anima_temp)
            if anima_temp then
                anima_temp._invoke = nil
                anima_temp:removeFromParent(true)
            end
        end

        local jsonFile = "images/ui/effice/effect_jlmbb/effect_jlmbb.json"
        local atlasFile = "images/ui/effice/effect_jlmbb/effect_jlmbb.atlas"
        local animation4 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
        animation4.animationNameList = {"animation"}
        sp.initArmature(animation4, false)
        animation4._invoke = tempActionCallback1
        animation4:setPosition(cc.p(curNode:getContentSize().width / 2, curNode:getContentSize().height / 2))
        curNode:addChild(animation4)
        animation4:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(curNode.animation, 0, 0, false)

        local function changeActionCallbackTwo(anim1)
            if round == #self.allRoundIds and index == curRound[#curRound] then
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(7)
                fwin:open(getRewardWnd, fwin._ui)
                self:clearRound()
                self.isPlayTen = false
                self.Image_touch_skip:setVisible(false)
                state_machine.unlock("christmas_romance_turntable_click_extract")
                self:extractRefresh()
            end
            anim1._invoke = nil
            anim1:setVisible(false)
        end

        curNode.animation._invoke = changeActionCallbackTwo
        curNode.animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(curNode.animation, 2, 2, false)
    else
        local function changeActionCallbackOne(anima)
            anima._invoke = nil
            anima:setVisible(false)
        end
        curNode.animation._invoke = changeActionCallbackOne
        curNode.animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(curNode.animation, 1, 1, false)
    end

    if round == #self.allRoundIds and index == curRound[#curRound] then
    else
        curNode:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(time),
                cc.CallFunc:create(
                    function()
                        index = index + 1
                        local curIndex = index % 16
                        curIndex = curIndex == 0 and 16 or curIndex

                        if index <= 16 then
                            self:playRound(round, curIndex)
                        else
                            round = round + 1
                            if round <= #self.allRoundIds then
                                self:playRound(round, 1)
                            else
                            end
                        end
                    end
                )
            )
        )
    end
end

--绘制奖励
function ChristmasRomanceTurntable:drawAllReward(isRefresh, mType)
    self._activityInfos = _ED.active_activity[181].activity_data
    local root = self.roots[1]
    local rewardList = self._activityInfos.rewardsDiamond
    if mType == 2 then
        rewardList = self._activityInfos.rewardsLucky
    end
    self.rewardsToIndex = {}
    if not isRefresh then
        self.lightList = {}
    end
    for i, v in ipairs(rewardList) do
        local Panel_light_effect = self.Panel_light_effect[i]
        local Image_done = self.Image_done[i]

        local Panel_treasure_icon = self.Panel_treasure_icon[i]
        Panel_treasure_icon:removeAllChildren(true)

        local reward = zstring.split(v, ",")
        local cell = self:addResourcesIconCell(reward)
        cell:setGrayState(false)
        Image_done:setVisible(false)
        if mType == 2 and tonumber(self._activityInfos.rewardsState[i]) == 0 then
            cell:setGrayState(true)
            Image_done:setVisible(true)
        end
        Panel_treasure_icon:addChild(cell)

        if not isRefresh then
            Panel_light_effect:removeAllChildren(true)
            local jsonFile = "images/ui/effice/effect_jlmba/effect_jlmba.json"
            local atlasFile = "images/ui/effice/effect_jlmba/effect_jlmba.atlas"
            local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", false, nil)
            animation2.animationNameList = {"animation1", "animation2", "animation3"}
            sp.initArmature(animation2, false)
            animation2._invoke = changeActionCallbackOne
            animation2:setPosition(cc.p(Panel_light_effect:getContentSize().width / 2, Panel_light_effect:getContentSize().height / 2))
            Panel_light_effect:addChild(animation2)
            animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            animation2:setVisible(false)
            Panel_light_effect.animation = animation2
            Panel_light_effect:setVisible(true)
        end
        Panel_light_effect.index = i
        self.rewardsToIndex[i] = i
        table.insert(self.lightList, Panel_light_effect)
    end
end

-- 抽取后的刷新
function ChristmasRomanceTurntable:extractRefresh()
    if self._page == 2 then
        -- 是否重置幸运转盘
        self:isResetRomance()
    end
    self:drawBoxView(self._page)
    if self._page == 1 then
    else
    end
end

-- 钻石转盘
function ChristmasRomanceTurntable:drawPageDimond()
    self:drawPageDimondUI()
    -- 奖励设置
    self:drawAllReward(false, 1)
    -- 宝箱设置
    self:drawBoxView(1)
end

-- 钻石转盘UI
function ChristmasRomanceTurntable:drawPageDimondUI()
    self._activityInfos = _ED.active_activity[181].activity_data
    local infos = self._activityInfos
    -- 消耗
    self.Text_darw_one_gem_n:setString(self:getConsumeDiamond(1) .. "")
    self.Text_darw_ten_gem_n:setString(self:getConsumeDiamond(10) .. "")
    -- 跳过
    local skipFlag = false
    local skipResult = self:getSkipState(1)
    if skipResult == nil then
        self:setSkipState(self._page, 0)
    else
        skipFlag = skipResult
    end
    self.CheckBox_cost:setSelected(skipFlag)
end

-- 幸运转盘
function ChristmasRomanceTurntable:drawPageLucky()
    self:drawPageLuckyUI()
    -- 奖励设置
    self:drawAllReward(false, 2)
    -- 宝箱设置
    self:drawBoxView(2)
end

-- 幸运转盘UI
function ChristmasRomanceTurntable:drawPageLuckyUI()
    self._activityInfos = _ED.active_activity[181].activity_data
    local infos = self._activityInfos
    -- 跳过
    local skipFlag = false
    local skipResult = self:getSkipState(2)
    if skipResult == nil then
        self:setSkipState(self._page, 0)
    else
        skipFlag = skipResult
    end
    self.CheckBox_cost:setSelected(skipFlag)
    -- 重置状态
    local totalReset = self:getResetTimes()
    local haveReset = tonumber(infos.resetTimes)
    local surpReset = totalReset - haveReset
    self.Text_refresh_time_n:setString(haveReset .. "/" .. totalReset)
    self:stateResetUpdate(surpReset > 0)

    local propStr = dms.string(dms["activity_config"], 94, activity_config.param)
    local prop = zstring.split(propStr, ",")
    local havePropNum = tonumber(getPropAllCountByMouldId(prop[2]))

    if havePropNum > 10000 then
        self.Text_refesh_num:setString(math.floor(havePropNum / 1000) .. string_equiprety_name[40])
    else
        self.Text_refesh_num:setString(havePropNum)
    end
end

-- 宝箱
function ChristmasRomanceTurntable:drawBoxView(mType)
    self._activityInfos = _ED.active_activity[181].activity_data
    self.ScrollView_rewardlist_2:removeAllItems()
    local boxList = nil
    if mType == 1 then
        boxList = self._activityInfos.boxDiamondList
        self.Text_draw_num_1:setString(self._activityInfos.boxScoreDiamond)
    else
        boxList = self._activityInfos.boxLuckyList
        self.Text_draw_num_1:setString(self._activityInfos.boxScoreLucky)
    end

    for i = 1, #boxList do
        if mType == 1 then
            boxList[i].state = tonumber(self._activityInfos.userOpenCostChest[i])
        elseif mType == 2 then
            boxList[i].state = tonumber(self._activityInfos.userLuckyChest[i])
        end

        local cell = state_machine.excute("christmas_romance_item_create", 0, {mType, boxList[i]})
        self.ScrollView_rewardlist_2:addChild(cell)
    end
    self.ScrollView_rewardlist_2:jumpToTop()
    self.ScrollView_rewardlist_2:requestRefreshView()
end

-- 道具是否足够
function ChristmasRomanceTurntable:haveEnoughProp(mType, mTimes)
    if mType == 1 then
        local needNum = self:getConsumeDiamond(mTimes)
        return tonumber(_ED.user_info.user_gold) >= needNum
    elseif mType == 2 then
        local propID, havePropNum = self:getConsumeProp()
        return havePropNum >= 1
    end
end

-- 是否可以重置道具
function ChristmasRomanceTurntable:haveResetProp()
    local propID = zstring.split(dms.string(dms["activity_config"], 94, activity_config.param), ",")[2]
    local havePropNum = tonumber(getPropAllCountByMouldId(propID))
    return havePropNum > 0
end

-- 是否可以重置次数
function ChristmasRomanceTurntable:haveResetTence()
    local totalReset = self:getResetTimes()
    local haveReset = tonumber(self._activityInfos.resetTimes)
    local surpReset = totalReset - haveReset
    return surpReset > 0
end

-- 钻石抽奖消耗
function ChristmasRomanceTurntable:getConsumeDiamond(mTimes)
    local needData = nil
    if mTimes == 1 then
        needData = dms.string(dms["activity_config"], 87, activity_config.param)
    elseif mTimes == 10 then
        needData = dms.string(dms["activity_config"], 88, activity_config.param)
    end
    local needNum = tonumber(zstring.split(needData, ",")[3])
    return needNum
end

-- 幸运抽奖消耗
function ChristmasRomanceTurntable:getConsumeProp()
    local propID = zstring.split(dms.string(dms["activity_config"], 91, activity_config.param), ",")[2]
    local havePropNum = tonumber(getPropAllCountByMouldId(propID))
    return propID, havePropNum
end

-- 总重置数量
function ChristmasRomanceTurntable:getResetTimes()
    local totalTimes = dms.string(dms["activity_config"], 93, activity_config.param)
    return totalTimes
end

-- 是否跳过二次确认弹框
function ChristmasRomanceTurntable:getSkipState(mType)
    local openState = false
    if mType == 1 then
        openState = cc.UserDefault:getInstance():getStringForKey("christmas_romance_dimond_skip_state", "")
    else
        openState = cc.UserDefault:getInstance():getStringForKey("christmas_romance_lucky_skip_state", "")
    end
    if openState == "" then
        return nil
    end
    if openState ~= "" and tonumber(openState) == 1 then
        return true
    end
    return false
end

-- 设置跳过状态
function ChristmasRomanceTurntable:setSkipState(mType, mState)
    local ccdf = cc.UserDefault:getInstance()
    if mType == 1 then
        if ccdf ~= nil then
            ccdf:setStringForKey("christmas_romance_dimond_skip_state", mState.."")
            ccdf:flush()
        end
    else
        if ccdf ~= nil then
            ccdf:setStringForKey("christmas_romance_lucky_skip_state", mState.."")
            ccdf:flush()
        end
    end
end

-- 可选框更新
function ChristmasRomanceTurntable:updateSelect()
    local isSelected = self.CheckBox_cost:isSelected()
    if isSelected == false then
        self:setSkipState(self._page, 1)
    else
        self:setSkipState(self._page, 0)
    end
end

-- 是否重置幸运转盘
function ChristmasRomanceTurntable:isResetRomance()
    local infos = _ED.active_activity[181].activity_data
    local stateRomance = infos.rewardsState
    local flag = true
    for i, v in ipairs(stateRomance) do
        if tonumber(v) == 0 then
            flag = false
        end
    end

    if flag then
        self:drawPageLuckyUI()
    end
    self:drawAllReward(false, 2)
end

-- 抽奖红点刷新
function ChristmasRomanceTurntable:refushExactRed()
    self._activityInfos = _ED.active_activity[181].activity_data
    if self:haveActivityEnd() then
        self:changeRedDotShowState(self.Button_darw_one, false)
    else
        self:changeRedDotShowState(self.Button_darw_one, self:haveEnoughProp(2, 1))
    end
end

function ChristmasRomanceTurntable:changeRedDotShowState(widget, isShow)
    if widget._istips == true then
        widget:removeChild(widget._nodeChild, true)
        widget._nodeChild = nil
        widget._istips = false
    end

    if isShow then
        if widget._istips == nil or widget._istips == false then
            local ball = cc.Sprite:create("images/ui/bar/tips.png")
            ball:setAnchorPoint(cc.p(0.7, 0.7))
            ball:setPosition(cc.p(widget:getContentSize().width, widget:getContentSize().height))
            widget:addChild(ball)
            widget._nodeChild = ball
            widget._istips = true
        end
    end
end

-- 页签红点刷新
function ChristmasRomanceTurntable:drawPageRed()
    for i = 1, 2 do
        state_machine.excute(
            "push_notification_center_manager",
            0,
            {
                _terminal_name = "push_notification_christmas_romance_page_push",
                _widget = self._showRedBtnList[i],
                _invoke = nil,
                _pageIndex = i + 2,
                _interval = 0.5
            }
        )
    end
end

function ChristmasRomanceTurntable:onUpdate(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime >= self.deltaTime then
        self:updateActivityRemainTime()
        self.totalTime = 0
    end
end

function ChristmasRomanceTurntable:updateActivityRemainTime()
    if self.Text_turntime_time == nil or self._activityEndTime == nil then
        return
    end
    local surplus_time = (self._activityEndTime - (os.time() + _ED.time_add_or_sub) * 1000)
    self.Text_turntime_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

-- 活动是否结束
function ChristmasRomanceTurntable:haveActivityEnd()
    local surplus_time = (self._activityEndTime - (os.time() + _ED.time_add_or_sub) * 1000)
    return surplus_time < 0
end

function ChristmasRomanceTurntable:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.floor((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .. _string_piece_info[231]
    end
    if _hourTime < 10 then
        timeString = timeString .. "0" .. _hourTime .. ":"
    else
        timeString = timeString .. _hourTime .. ":"
    end

    if _minutesTime < 10 then
        timeString = timeString .. "0" .. _minutesTime .. ":"
    else
        timeString = timeString .. _minutesTime .. ":"
    end

    if _secondsTime < 10 then
        timeString = timeString .. "0" .. _secondsTime
    else
        timeString = timeString .. _secondsTime
    end
    return timeString
end

function ChristmasRomanceTurntable:addResourcesIconCell(propData)
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

function ChristmasRomanceTurntable:drawBtn()
    local root = self.roots[1]
    -- 停止动画
    self.Image_touch_skip =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Image_touch_skip"),
        nil,
        {
            terminal_name = "christmas_romance_turntable_anim_stop",
            isPressedActionEnabled = true
        },
        nil,
        0
    )
    self.Image_touch_skip:setVisible(false)
    self.Image_touch_skip:setTouchEnabled(true)
    -- 转盘规则
    self.Button_rule =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_rule"),
        nil,
        {
            terminal_name = "christmas_romance_rule_window_open",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 抽取一次
    self.Button_darw_one =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_darw_one"),
        nil,
        {
            terminal_name = "christmas_romance_turntable_click_extract",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_times = 1,
            m_cell = self
        },
        nil,
        0
    )

    -- 抽取十次
    self.Button_darw_ten =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_darw_ten"),
        nil,
        {
            terminal_name = "christmas_romance_turntable_click_extract",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_times = 10,
            m_cell = self
        },
        nil,
        0
    )

    -- 普通转盘抽取一次
    self.Button_darw_one_gem =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_darw_one_gem"),
        nil,
        {
            terminal_name = "christmas_romance_turntable_click_extract",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_times = 1,
            m_cell = self
        },
        nil,
        0
    )

    -- 刷新累计獎勵
    self.Button_refresh_reward =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_refresh_reward"),
        nil,
        {
            terminal_name = "christmas_romance_turntable_reset",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 钻石转盘按钮
    self.Button_gold_turnable =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_gold_turnable"),
        nil,
        {
            terminal_name = "christmas_romance_turntable_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 1
        },
        nil,
        0
    )

    -- 普通转盘按钮
    self.Button_gem_turnable =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_gem_turnable"),
        nil,
        {
            terminal_name = "christmas_romance_turntable_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 2
        },
        nil,
        0
    )

    -- 关闭窗口
    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "christmas_romance_turntable_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self._showRedBtnList = {
        self.Button_gold_turnable,
        self.Button_gem_turnable
    }
    local function onOpenTouchEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            self:updateSelect()
        end
    end
    -- 不提示选择
    self.CheckBox_cost = ccui.Helper:seekWidgetByName(root, "CheckBox_cost")
    self.CheckBox_cost:addTouchEventListener(onOpenTouchEvent)
end

function ChristmasRomanceTurntable:onEnterTransitionFinish()
    -- 顶部道具信息
    state_machine.excute("christmas_romance_top_info_open", 0, {rootWindows = self, openType = 1})
end

function ChristmasRomanceTurntable:onExit()
    -- 释放ChristmasRomanceTurntableWindow界面资源.
    state_machine.remove("christmas_romance_turntable_open")
    state_machine.remove("christmas_romance_turntable_close")
    state_machine.remove("christmas_romance_turntable_show")
    state_machine.remove("christmas_romance_turntable_hide")
    state_machine.remove("christmas_romance_turntable_change_page")
    state_machine.remove("christmas_romance_turntable_click_extract")
    state_machine.remove("christmas_romance_turntable_reset")
    state_machine.remove("christmas_romance_turntable_anim_stop")
    state_machine.remove("christmas_romance_turntable_get_box_reward")
    state_machine.remove("christmas_romance_turntable_refush_red")
    state_machine.remove("christmas_romance_turntable_refush_box")
end

function ChristmasRomanceTurntable:close()
    -- window event : close.
end

function ChristmasRomanceTurntable:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
