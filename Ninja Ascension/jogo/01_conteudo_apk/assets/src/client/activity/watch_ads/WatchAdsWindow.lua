-- 观看广告主界面
WatchAdsWindow = class("WatchAdsWindowClass", Window)

local watch_ads_window_open_terminal = {
    _name = "watch_ads_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("WatchAdsWindowClass") == nil then
            fwin:open(WatchAdsWindow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local watch_ads_window_close_terminal = {
    _name = "watch_ads_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if params and params._datas and params._datas.mObj then
            state_machine.lock("watch_ads_window_close")
            params._datas.mObj.actions[1]:play("window_close", false)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(watch_ads_window_open_terminal)
state_machine.add(watch_ads_window_close_terminal)
state_machine.init()

function WatchAdsWindow:ctor()
    self.super:ctor()

    self.roots = {}
    self.actions = {}
    self._day_reward_info = nil -- 每日奖励
    self._day_max_tence = 0 -- 每日奖励最大次数
    self._total_reward_info = {} -- 累计奖励
    app.load("client.cells.utils.resources_icon_cell")

    local function init_watch_ads_window_terminal()
        -- 请求打开广告
        local watch_ads_window_click_open_ads_page_terminal = {
            _name = "watch_ads_window_click_open_ads_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("watch_ads_window_click_open_ads_page", 0, "")
                local function responseOpenCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 拉起广告界面
                        PullAdWindow()
                        state_machine.unlock("watch_ads_window_click_open_ads_page", 0, "")
                    else
                        state_machine.unlock("watch_ads_window_click_open_ads_page", 0, "")
                    end
                end
                -- 发送用户请求点击广告
                protocol_command.user_advertisement_click.param_list = "1"
                NetworkManager:register(protocol_command.user_advertisement_click.code, nil, nil, nil, instance, responseOpenCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 广告返回结果成功
        local watch_ads_window_result_success_page_terminal = {
            _name = "watch_ads_window_result_success_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 是否还能领取每日奖励
                if instance and instance:canReward() then
                    local function responseAdsCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil then
                                local rewardInfo = getSceneReward(7) 
                                if rewardInfo ~= nil then
                                    app.load("client.reward.DrawRareReward")
                                    local getRewardWnd = DrawRareReward:new()
                                    getRewardWnd:init(nil, rewardInfo)
                                    fwin:open(getRewardWnd, fwin._ui)
                                end
                                state_machine.excute("watch_ads_cell_can_see",0,"")
                                response.node:onUpdateDraw()
                            end
                        end
                    end
                    protocol_command.user_advertisement_finish.param_list = "1"
                    NetworkManager:register(protocol_command.user_advertisement_finish.code, nil, nil, nil, instance, responseAdsCallback, false, nil)
                else
                    local function showConfirmTip(instance)
                    end
                    app.load("client.utils.ConfirmTip")
                    local tipsWindow = ConfirmTip:new()
                    tipsWindow:init(nil, showConfirmTip, tipStringInfo_watch_ads_text[9], nil, nil, nil, nil)
                    fwin:open(tipsWindow, fwin._ui)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(watch_ads_window_click_open_ads_page_terminal)
        state_machine.add(watch_ads_window_result_success_page_terminal)
        state_machine.init()
    end
    init_watch_ads_window_terminal()
end

-- 是否还能领取每日奖励
function WatchAdsWindow:canReward()
    return _ED.user_advertisement_info.day_common_tence < self._day_max_tence
end

function WatchAdsWindow:handleData()
    self._total_reward_info = {}
    -- 每日奖励和最大次数
    local dayInfo = dms.searchs(dms["ad_reward"], ad_reward_mould.type, 1)
    self._day_reward_info = zstring.split(dayInfo[1][ad_reward_mould.reward], ":")
    self._day_max_tence = tonumber(dayInfo[1][ad_reward_mould.limitTence])
    -- 总奖励
    local totalInfo = dms.searchs(dms["ad_reward"], ad_reward_mould.type, 3)
    for k, v in ipairs(totalInfo) do
        local tempInfo = {}
        tempInfo.tence = tonumber(v[ad_reward_mould.aimTence])
        tempInfo.reward = zstring.split(v[ad_reward_mould.reward],"|")
        table.insert(self._total_reward_info, tempInfo)
    end
end

-- 每日观看奖励
function WatchAdsWindow:showDayReward()
    local root = self.roots[1]

    local Text_unachieved = ccui.Helper:seekWidgetByName(root, "Text_unachieved")
    local Text_complete = ccui.Helper:seekWidgetByName(root, "Text_complete")
    local curTotalTence = _ED.user_advertisement_info.total_tence
    local curAimInfo = nil 
    for i,v in ipairs(self._total_reward_info) do
        if curTotalTence < v.tence then 
            Text_unachieved:setVisible(true)
            Text_complete:setVisible(false)
            curAimInfo = v
            break
        end
    end
    if curAimInfo == nil then 
        -- 已完成所有奖励,显示最后的奖励,并标注已完成状态
        curAimInfo = self._total_reward_info[#self._total_reward_info]
        Text_unachieved:setVisible(false)
        Text_complete:setVisible(true)
    end
    -- 剩余累计觀看次数
    local cutTence = curAimInfo.tence - curTotalTence
    cutTence = cutTence < 0 and 0 or cutTence
    local Text_tip_3 = ccui.Helper:seekWidgetByName(root, "Text_tip_3")
    Text_tip_3:setString(string.format(tipStringInfo_watch_ads_text[3],cutTence..""))
    -- 累计奖励
    for i=1,2 do
        local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon_"..i)
        Panel_icon:removeAllChildren(true)
        
        if curAimInfo.reward[i] ~= nil then 
            Panel_icon:addChild(DrawHandle.drawIcon(curAimInfo.reward[i]))
            Panel_icon:setVisible(true)
        else
            Panel_icon:setVisible(false)
        end
    end

    -- 刷新时间
    local Text_tip_2 = ccui.Helper:seekWidgetByName(root, "Text_tip_2")
    Text_tip_2:setString(tipStringInfo_watch_ads_text[4])

    -- 每次奖励
    local curIdx = 1
    if _ED.user_advertisement_info.day_common_tence >= self._day_max_tence then
        curIdx = self._day_max_tence
    else
        curIdx = _ED.user_advertisement_info.day_common_tence + 1
    end
    local curRewardList = zstring.split(self._day_reward_info[curIdx],"|")
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
    ScrollView_1:removeAllChildren(true)

    local innerPanel = ScrollView_1:getInnerContainer()
    innerPanel:setContentSize(ScrollView_1:getContentSize())
    innerPanel:setPosition(cc.p(0, 0))
    innerPanel:removeAllChildren(true)

    local sSize = innerPanel:getContentSize()

    local sHeight = sSize.height
    local sWidth = sSize.width
    local number = #curRewardList
    local tWidth = 0
    local curCellWidth = 0

    for i, v in ipairs(curRewardList) do
        local rewardIcon = DrawHandle.drawIcon(v)
        local cellWidth = rewardIcon:getContentSize().width
        curCellWidth = cellWidth
        if i == 1 then
            tWidth = 0
        else
            tWidth = tWidth + cellWidth
        end
        rewardIcon:setPosition(cc.p((ScrollView_1:getContentSize().width / 2 - ((cellWidth / 2) * number)) + tWidth, 0))
        ScrollView_1:addChild(rewardIcon)
    end
    local totalCell = curCellWidth * number
    if totalCell < ScrollView_1:getContentSize().width then
        totalCell = ScrollView_1:getContentSize().width
    end
    innerPanel:setContentSize(totalCell, ScrollView_1:getContentSize().height)

    ScrollView_1:jumpToTop()
end

-- 显示累计奖励
function WatchAdsWindow:showTotalReward()
end

function WatchAdsWindow:onUpdateDraw()
    self:showDayReward()
    self:showTotalReward()
end

function WatchAdsWindow:init(params)
    self:onInit()
    return self
end

function WatchAdsWindow:onInit()
    local csbItem = csb.createNode("utils/sm_advertisement.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    local action = csb.createTimeline("utils/sm_advertisement.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)
    action:setFrameEventCallFunc(
        function(frame)
            if nil == frame then
                return
            end
            local str = frame:getEvent()
            if str == "close" then
                state_machine.unlock("watch_ads_window_close")
                fwin:close(self)
            end
        end
    )

    self:handleData()
    self:onUpdateDraw()
    self:drawBtn()
end

function WatchAdsWindow:drawBtn()
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "watch_ads_window_close",
            terminal_state = 0,
            touch_black = true,
            mObj = self,
        },
        nil,
        3
    )

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_look"),
        nil,
        {
            terminal_name = "watch_ads_window_click_open_ads_page",
            terminal_state = 0,
            touch_black = true
        },
        nil,
        3
    )
end

function WatchAdsWindow:onEnterTransitionFinish()
end

function WatchAdsWindow:onExit()
    state_machine.remove("watch_ads_window_click_open_ads_page")
    state_machine.remove("watch_ads_window_result_success_page")
end
