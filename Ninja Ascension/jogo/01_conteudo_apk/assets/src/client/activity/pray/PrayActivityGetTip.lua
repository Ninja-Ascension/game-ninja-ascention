--[[ ----------------------------------------------------------------------------
-- 祈福规则
--]] ----------------------------------------------------------------------------
PrayActivityGetTip = class("PrayActivityGetTipClass", Window)

-- 打开窗口
local pray_activity_get_tip_window_open_terminal = {
    _name = "pray_activity_get_tip_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PrayActivityGetTipClass") then
            fwin:open(PrayActivityGetTip:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local pray_activity_get_tip_window_close_terminal = {
    _name = "pray_activity_get_tip_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PrayActivityGetTipClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pray_activity_get_tip_window_open_terminal)
state_machine.add(pray_activity_get_tip_window_close_terminal)
state_machine.init()

-- 构造器
function PrayActivityGetTip:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var

    -- load lua files.

    -- Initialize pray activity rule page state machine.
    local function init_pray_activity_get_tip_terminal()
        -- 打开角色创建窗口
        local pray_activity_get_tip_open_terminal = {
            _name = "pray_activity_get_tip_open",
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
        local pray_activity_get_tip_close_terminal = {
            _name = "pray_activity_get_tip_close",
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
        local pray_activity_get_tip_show_terminal = {
            _name = "pray_activity_get_tip_show",
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
        local pray_activity_get_tip_hide_terminal = {
            _name = "pray_activity_get_tip_hide",
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

        local pray_activity_get_tip_change_page_terminal = {
            _name = "pray_activity_get_tip_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= params then
                    local mPage = params._datas.m_page
                    if fwin:find("HeroRecruitSuccessClass") ~= nil then
                        fwin:close(fwin:find("HeroRecruitSuccessClass"))
                    end

                    if fwin:find("HeroRecruitSuccessTenClass") ~= nil then
                        fwin:close(fwin:find("HeroRecruitSuccessTenClass"))
                    end
                    state_machine.excute("pray_activity_window_change_page", 0, {_datas = {m_page = mPage}})
                    state_machine.excute("pray_activity_get_tip_window_close", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pray_activity_get_tip_open_terminal)
        state_machine.add(pray_activity_get_tip_close_terminal)
        state_machine.add(pray_activity_get_tip_show_terminal)
        state_machine.add(pray_activity_get_tip_hide_terminal)
        state_machine.add(pray_activity_get_tip_change_page_terminal)
        state_machine.init()
    end
    -- call func init pray activity rule state machine.
    init_pray_activity_get_tip_terminal()
end

-- 对象初始化
function PrayActivityGetTip:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function PrayActivityGetTip:onUpdateDraw()
end

function PrayActivityGetTip:onEnterTransitionFinish()
    -- 加载PrayActivityGetTipWindow界面资源.
    -- res.activity.Pray.Pray_tip = res/activity/Pray/Pray_tip.csb
    local csbNode = csb.createNode("activity/Pray/Pray_tip.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 弹窗关闭按钮
    self.Button_closed =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "pray_activity_get_tip_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self.Button_go =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_go"),
        nil,
        {
            terminal_name = "pray_activity_get_tip_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 2
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function PrayActivityGetTip:onExit()
    -- 释放PrayActivityGetTipWindow界面资源.
    state_machine.remove("pray_activity_get_tip_open")
    state_machine.remove("pray_activity_get_tip_close")
    state_machine.remove("pray_activity_get_tip_show")
    state_machine.remove("pray_activity_get_tip_hide")
    state_machine.remove("pray_activity_get_tip_change_page")
end

function PrayActivityGetTip:close()
    -- window event : close.
end

function PrayActivityGetTip:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
