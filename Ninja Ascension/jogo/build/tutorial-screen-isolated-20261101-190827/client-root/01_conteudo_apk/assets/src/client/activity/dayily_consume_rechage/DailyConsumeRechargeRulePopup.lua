--[[ ----------------------------------------------------------------------------
-- 每日累充弹窗文本界面--小
--]] ----------------------------------------------------------------------------
DailyConsumeRechargeRulePopup = class("DailyConsumeRechargeRulePopupClass", Window)

-- 打开窗口
local daily_consume_recharge_rule_popup_window_open_terminal = {
    _name = "daily_consume_recharge_rule_popup_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("DailyConsumeRechargeRulePopupClass") then
            fwin:open(DailyConsumeRechargeRulePopup:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local daily_consume_recharge_rule_popup_window_close_terminal = {
    _name = "daily_consume_recharge_rule_popup_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("DailyConsumeRechargeRulePopupClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(daily_consume_recharge_rule_popup_window_open_terminal)
state_machine.add(daily_consume_recharge_rule_popup_window_close_terminal)
state_machine.init()

-- 构造器
function DailyConsumeRechargeRulePopup:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.titleType = 0          -- 标题类型
    self.textID = 0             -- 文本内容ID

    -- Initialize daily_consume_recharge_rule_popup page state machine.
    local function init_daily_consume_recharge_rule_popup_terminal()
        -- 打开角色创建窗口
        local daily_consume_recharge_rule_popup_open_terminal = {
            _name = "daily_consume_recharge_rule_popup_open",
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
        local daily_consume_recharge_rule_popup_close_terminal = {
            _name = "daily_consume_recharge_rule_popup_close",
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
        local daily_consume_recharge_rule_popup_show_terminal = {
            _name = "daily_consume_recharge_rule_popup_show",
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
        local daily_consume_recharge_rule_popup_hide_terminal = {
            _name = "daily_consume_recharge_rule_popup_hide",
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

        state_machine.add(daily_consume_recharge_rule_popup_open_terminal)
        state_machine.add(daily_consume_recharge_rule_popup_close_terminal)
        state_machine.add(daily_consume_recharge_rule_popup_show_terminal)
        state_machine.add(daily_consume_recharge_rule_popup_hide_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_daily_consume_recharge_rule_popup_terminal()
end

function DailyConsumeRechargeRulePopup:onUpdateDraw()
   
    -- 内容文本
    local textString = tipStringInfo_rule_text[1]

    self.Text_1:setString(textString)
end

-- 对象初始化
function DailyConsumeRechargeRulePopup:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function DailyConsumeRechargeRulePopup:onEnterTransitionFinish()

    local csbNode = csb.createNode("utils/common_popup_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭界面
    self.Button_rule = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, {
        terminal_name = "daily_consume_recharge_rule_popup_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, nil, 0)

    -- 内容文本
    self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    
    self:onUpdateDraw()
end

function DailyConsumeRechargeRulePopup:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("daily_consume_recharge_rule_popup_open")
    state_machine.remove("daily_consume_recharge_rule_popup_close")
    state_machine.remove("daily_consume_recharge_rule_popup_show")
    state_machine.remove("daily_consume_recharge_rule_popup_hide")
    
end

function DailyConsumeRechargeRulePopup:close()
    -- window event : close.
end

function DailyConsumeRechargeRulePopup:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
