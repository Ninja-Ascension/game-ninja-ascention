--[[ ----------------------------------------------------------------------------
-- 全民福利界面
--]] ----------------------------------------------------------------------------
CommonOrderWelfare = class("CommonOrderWelfareClass", Window)

-- 打开窗口
local common_order_welfare_window_open_terminal = {
    _name = "common_order_welfare_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("CommonOrderWelfareClass") then
            fwin:open(CommonOrderWelfare:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local common_order_welfare_window_close_terminal = {
    _name = "common_order_welfare_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CommonOrderWelfareClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(common_order_welfare_window_open_terminal)
state_machine.add(common_order_welfare_window_close_terminal)
state_machine.init()

-- 构造器
function CommonOrderWelfare:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.curType = 0      -- 当前类型

    app.load("client.activity.common_order.CommonOrderWelfareList")
    -- Initialize common_order_welfare page state machine.
    local function init_common_order_welfare_terminal()
        -- 打开角色创建窗口
        local common_order_welfare_open_terminal = {
            _name = "common_order_welfare_open",
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
        local common_order_welfare_close_terminal = {
            _name = "common_order_welfare_close",
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
        local common_order_welfare_show_terminal = {
            _name = "common_order_welfare_show",
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
        local common_order_welfare_hide_terminal = {
            _name = "common_order_welfare_hide",
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

        -- 领取奖励后刷新界面
        local common_order_welfare_update_terminal = {
            _name = "common_order_welfare_update",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 刷新界面
                if nil ~= instance then
                    instance:updateDraw()
                    fwin:addService({
                        callback = function ( params )
                            state_machine.excute("notification_center_update", 0, "push_notification_common_warorder_welfare_reward_push")
                        end,
                        delay = 0,
                    })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(common_order_welfare_open_terminal)
        state_machine.add(common_order_welfare_close_terminal)
        state_machine.add(common_order_welfare_show_terminal)
        state_machine.add(common_order_welfare_hide_terminal)
        state_machine.add(common_order_welfare_update_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_common_order_welfare_terminal()
end

-- 对全民福利任务状态进行排序
function CommonOrderWelfare:sortListItems(welfareInfo, welfareState)
    local unCompleteItems = {}          -- 未完成
    local canReceiveItems = {}          -- 可领取
    local receivedItems = {}            -- 已领取
    local result = {}                   -- 返回结果
    local UNCOMPLETE = 0                -- 未完成code
    local CANRECEIVE = 1                -- 可以领取code
    local REDCIVED = 2                  -- 已领取code
    for i, v in ipairs(welfareInfo) do
        local tempInfo = {}
        local info = zstring.split(v, ",")
        tempInfo.needNum = tonumber(info[1])
        tempInfo.rewardIdx = tonumber(info[2])
        tempInfo.state = welfareState[i]
        tempInfo.welfareID = i

        if tempInfo.state == UNCOMPLETE then
            table.insert(unCompleteItems, tempInfo)
        elseif tempInfo.state == CANRECEIVE then
            table.insert(canReceiveItems, tempInfo)
        elseif tempInfo.state == REDCIVED then
            table.insert(receivedItems, tempInfo)
        end
    end

    for i, v in ipairs(canReceiveItems) do
        table.insert(result, v)
    end

    for i, v in ipairs(unCompleteItems) do
        table.insert(result, v)
    end

    for i, v in ipairs(receivedItems) do
        table.insert(result, v)
    end

    return result
end

-- 获取任务索引
function CommonOrderWelfare:getPlayConfigIndex()
    local playConfigIndex = 0
    if self.curType == 1 then
        playConfigIndex = 271
    elseif self.curType == 2 then
        playConfigIndex = 272
    elseif self.curType == 3 then
        playConfigIndex = 273
    elseif self.curType == 4 then
        playConfigIndex = 274
    end
    return playConfigIndex
end

function CommonOrderWelfare:updateDraw()
    local user_order_info = _ED.active_activity[185].user_order_info
    if user_order_info == nil then
        return false
    end

    self.ListView_welfare:removeAllItems()
    local welfareAllString = user_order_info.welfareTaskInfo[self.curType]
    local welfareState = welfareAllString.taskState
    local welfareCounts = welfareAllString.allCounts
    self.Text_allcounts:setString(welfareCounts)

    local index = self:getPlayConfigIndex()
    
    local welfareString = dms.string(dms["play_config"], index, play_config.param)
    local welfareInfo = zstring.split(welfareString, "|")

    welfareInfo = self:sortListItems(welfareInfo, welfareState)
        
    for i, v in ipairs(welfareInfo) do
        local cell = state_machine.excute("common_order_welfare_list_window_tab_cell_create", 0, {v, self.curType})
        self.ListView_welfare:addChild(cell)
    end
    self.ListView_welfare:jumpToTop()
    self.ListView_welfare:requestRefreshView()
end

-- 对象初始化
function CommonOrderWelfare:init(params)
    self.curType = params.type
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function CommonOrderWelfare:onUpdate(dt)

end


function CommonOrderWelfare:onEnterTransitionFinish()
    -- 加载ChristmasRomanceShopWindow界面资源.
    -- res.activity.christmas_romance.common_order_welfare = res/activity/christmas_romance/common_order_welfare.csb
    local csbNode = csb.createNode("activity/passport/passport_main_welfare.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 全民福利列表
    self.ListView_welfare = ccui.Helper:seekWidgetByName(root, "ListView_1")

    -- 总购买次数
    self.Text_allcounts = ccui.Helper:seekWidgetByName(root, "Text_2_0")

     -- 关闭界面
     self.Button_close =
     fwin:addTouchEventListener(
     ccui.Helper:seekWidgetByName(root, "Button_1"),
     nil,
     {
         terminal_name = "common_order_welfare_window_close",
         terminal_state = 0,
         isPressedActionEnabled = true,
     },
     nil,
     0
    )
    self:updateDraw()

end

function CommonOrderWelfare:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("common_order_welfare_open")
    state_machine.remove("common_order_welfare_close")
    state_machine.remove("common_order_welfare_show")
    state_machine.remove("common_order_welfare_hide")
    state_machine.remove("common_order_welfare_update")
    
end

function CommonOrderWelfare:close()
    -- window event : close.
end

function CommonOrderWelfare:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
