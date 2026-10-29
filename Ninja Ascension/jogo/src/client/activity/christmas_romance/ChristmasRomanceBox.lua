--[[ ----------------------------------------------------------------------------
-- 圣诞奇缘主界面
--]] ----------------------------------------------------------------------------
ChristmasRomanceBox = class("ChristmasRomanceBoxClass", Window)

-- 打开窗口
local christmas_romance_box_window_open_terminal = {
    _name = "christmas_romance_box_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ChristmasRomanceBoxClass") then
            fwin:open(ChristmasRomanceBox:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local christmas_romance_box_window_close_terminal = {
    _name = "christmas_romance_box_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ChristmasRomanceBoxClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(christmas_romance_box_window_open_terminal)
state_machine.add(christmas_romance_box_window_close_terminal)
state_machine.init()

-- 构造器
function ChristmasRomanceBox:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._type = nil
    self._rewardData = nil
    -- load lua files.

    -- Initialize christmas romance box page state machine.
    local function init_christmas_romance_box_terminal()
        -- 打开角色创建窗口
        local christmas_romance_box_open_terminal = {
            _name = "christmas_romance_box_open",
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
        local christmas_romance_box_close_terminal = {
            _name = "christmas_romance_box_close",
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
        local christmas_romance_box_show_terminal = {
            _name = "christmas_romance_box_show",
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
        local christmas_romance_box_hide_terminal = {
            _name = "christmas_romance_box_hide",
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

        -- 点击领取
        local christmas_romance_box_click_confirm_terminal = {
            _name = "christmas_romance_box_click_confirm",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params then
                    local mCell = params._datas.m_cell
                    local type = mCell._type
                    local reward = mCell._rewardData
                    state_machine.excute("christmas_romance_turntable_get_box_reward", 0, {type, reward})
                    state_machine.excute("christmas_romance_box_window_close", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(christmas_romance_box_open_terminal)
        state_machine.add(christmas_romance_box_close_terminal)
        state_machine.add(christmas_romance_box_show_terminal)
        state_machine.add(christmas_romance_box_hide_terminal)
        state_machine.add(christmas_romance_box_click_confirm_terminal)

        state_machine.init()
    end
    -- call func init christmas romance box state machine.
    init_christmas_romance_box_terminal()
end

-- 对象初始化
function ChristmasRomanceBox:init(params)
    self._type = params[1]
    self._rewardData = params[2]
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function ChristmasRomanceBox:onUpdateDraw()
    local root = self.roots[1]
    self.Button_confirm = ccui.Helper:seekWidgetByName(root, "Button_confirm")
    self.Button_confirm:setVisible(false)
    -- 獎勵容器列表
    self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
    self.ListView_2:removeAllItems()
    
    local rewards = self._rewardData.reward

    local cellWidth = 0
    for i, v in ipairs(rewards) do
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
    for i, v in ipairs(_tables) do
        tpx = v.roots[1]:getContentSize().width
        v.roots[1]:setPositionX(v.roots[1]:getPositionX() + (x - tpx * #_tables) /2)
    end
end

function ChristmasRomanceBox:addResourcesIconCell(propData)
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

function ChristmasRomanceBox:onEnterTransitionFinish()
    -- 加载ChristmasRomanceBoxWindow界面资源.
    -- res.activity.christmas_romance.christmas_romance_box = res/activity/christmas_romance/christmas_romance_box.csb
    local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_box.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 确定按钮
    self.Button_confirm =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_confirm"),
        nil,
        {
            terminal_name = "christmas_romance_box_click_confirm",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_cell = self
        },
        nil,
        0
    )

    -- 关闭
    self.Button_closed =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "christmas_romance_box_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function ChristmasRomanceBox:onExit()
    -- 释放ChristmasRomanceBoxWindow界面资源.
    state_machine.remove("christmas_romance_box_open")
    state_machine.remove("christmas_romance_box_close")
    state_machine.remove("christmas_romance_box_show")
    state_machine.remove("christmas_romance_box_hide")
    state_machine.remove("christmas_romance_box_click_confirm")
end

function ChristmasRomanceBox:close()
    -- window event : close.
end

function ChristmasRomanceBox:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
