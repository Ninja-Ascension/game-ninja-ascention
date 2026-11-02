ActivityGroupBuyRule = class("ActivityGroupBuyRuleClass", Window)

-- 打开窗口
local activity_group_buy_rule_open_terminal = {
    _name = "activity_group_buy_rule_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityGroupBuyRuleClass") then
            fwin:open(ActivityGroupBuyRule:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local activity_group_buy_rule_close_terminal = {
    _name = "activity_group_buy_rule_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityGroupBuyRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_rule_open_terminal)
state_machine.add(activity_group_buy_rule_close_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuyRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_rule_terminal()
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_rule_terminal()
end

-- 对象初始化
function ActivityGroupBuyRule:init()
    return self
end

function ActivityGroupBuyRule:buttonAddClickEvent()
    -- 关闭按钮
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"),
        nil,
        {
            terminal_name = "activity_group_buy_rule_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function ActivityGroupBuyRule:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/group_buy/group_buy_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:buttonAddClickEvent()
end

function ActivityGroupBuyRule:onExit()
end
