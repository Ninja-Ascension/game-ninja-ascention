--[[ ----------------------------------------------------------------------------
-- 限时祈福宝箱奖励
--]] ----------------------------------------------------------------------------
PrayActivityBoxTip = class("PrayActivityBoxTipClass", Window)
PrayActivityBoxTip.__size = nil

-- 打开窗口
local activity_pray_box_tip_create_terminal = {
    _name = "activity_pray_box_tip_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PrayActivityBoxTipClass") then
            fwin:open(PrayActivityBoxTip:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local activity_pray_box_tip_close_terminal = {
    _name = "activity_pray_box_tip_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PrayActivityBoxTipClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_pray_box_tip_create_terminal)
state_machine.add(activity_pray_box_tip_close_terminal)
state_machine.init()

-- 构造器
function PrayActivityBoxTip:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._mIndex = nil
    self._rewardInfos = nil
    self._state = nil
    -- load lua files.

    -- Initialize sm luck draw record list page state machine.
    local function init_activity_pray_box_tip_terminal()
        local pray_activity_pray_box_tip_get_reward_terminal = {
            _name = "pray_activity_pray_box_tip_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= params then
                    state_machine.lock("pray_activity_pray_box_tip_get_reward")
                    local mCell = params._datas.m_cell
                  
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd, fwin._ui)

                                state_machine.excute("pray_activity_window_refush_box", 0, "")
                                state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 180)
                                fwin:addService(
                                    {
                                        callback = function(params)
                                            state_machine.excute("notification_center_update", 0, "push_notification_limit_pray_page_push")
                                        end,
                                        delay = 0
                                    }
                                )
                                state_machine.excute("activity_pray_box_tip_close", 0, "")
                            end
                        end
                        state_machine.unlock("pray_activity_pray_box_tip_get_reward")
                    end

                    protocol_command.limit_blessing_get_blessing_reward.param_list = "" .. mCell._aim
                    NetworkManager:register(protocol_command.limit_blessing_get_blessing_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pray_activity_pray_box_tip_get_reward_terminal)
        state_machine.init()
    end
    -- call func init sm luck draw record list state machine.
    init_activity_pray_box_tip_terminal()
end

-- 对象初始化
function PrayActivityBoxTip:init(params)
    self._mIndex = params.mIndex
    self._rewardInfos = params.rewardInfos
    self._state = params.state
    self._aim = params.aim
    self:onInit(params)
    self:setContentSize(PrayActivityBoxTip.__size)
    return self
end

function PrayActivityBoxTip:onUpdateDraw()
    local root = self.roots[1]
    if tonumber(self._state) == 1 then
        self.Button_go:setTouchEnabled(true)
        self.Button_go:setBright(true)
    else
        self.Button_go:setTouchEnabled(false)
        self.Button_go:setBright(false)
    end
    self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
    self.ListView_2:removeAllItems()
    local cellWidth = 0
    for k, v in pairs(self._rewardInfos) do
        local reward = zstring.split(v, ",")
        local cell = self:addResourcesIconCell(reward)
        self.ListView_2:addChild(cell)
        if cellWidth == 0 then
            cellWidth = cell:getContentSize().width
        end
    end
    self.ListView_2:jumpToTop()
    self.ListView_2:requestRefreshView()

    local tpx = cellWidth
    --每个奖励框大小
    local x = self.ListView_2:getContentSize().width
    local _tables = self.ListView_2:getItems()
    for i, v in pairs(_tables) do
        tpx = v.roots[1]:getContentSize().width
        v.roots[1]:setPositionX(v.roots[1]:getPositionX() + (x - tpx * #_tables) /2)
    end
end

function PrayActivityBoxTip:addResourcesIconCell(propData)
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

function PrayActivityBoxTip:onEnterTransitionFinish()
end

function PrayActivityBoxTip:onInit(params)
    local csbNode = csb.createNode("activity/Pray/Pray_tip_box.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    if PrayActivityBoxTip.__size == nil then
        PrayActivityBoxTip.__size = root:getContentSize()
    end

    self.Button_go =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_go"),
        nil,
        {
            terminal_name = "pray_activity_pray_box_tip_get_reward",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_cell = self
        },
        nil,
        0
    )

    self.Button_closed =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "activity_pray_box_tip_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function PrayActivityBoxTip:onExit()
    state_machine.remove("pray_activity_pray_box_tip_get_reward")
end
