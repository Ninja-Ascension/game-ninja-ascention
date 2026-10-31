--[[ ----------------------------------------------------------------------------
-- 半月礼规则界面
--]] ----------------------------------------------------------------------------
ActivityMonthGiftRule = class("ActivityMonthGiftRuleClass", Window)

-- 打开窗口
local activity_month_gift_rule_open_terminal = {
    _name = "activity_month_gift_rule_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityMonthGiftRuleClass") then
            fwin:open(ActivityMonthGiftRule:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local activity_month_gift_rule_close_terminal = {
    _name = "activity_month_gift_rule_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityMonthGiftRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_month_gift_rule_open_terminal)
state_machine.add(activity_month_gift_rule_close_terminal)
state_machine.init()

-- 构造器
function ActivityMonthGiftRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_month_gift_rule_terminal()
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_month_gift_rule_terminal()
end

-- 对象初始化
function ActivityMonthGiftRule:init()
    return self
end

function ActivityMonthGiftRule:onUpdateDraw()
    local root = self.roots[1]
end

function ActivityMonthGiftRule:buttonAddClickEvent()
    -- 关闭按钮
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "activity_month_gift_rule_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function ActivityMonthGiftRule:onEnterTransitionFinish()
    -- 加载ActivityMonthGiftRule界面资源.
    local csbNode = csb.createNode("activity/wonderful/activity_month_gift_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:onUpdateDraw()
    self:buttonAddClickEvent()
end

function ActivityMonthGiftRule:onUpdate(dt)
end

function ActivityMonthGiftRule:onExit()
end

function ActivityMonthGiftRule:close()
end

function ActivityMonthGiftRule:destroy(window)
end

-- ~END
-- ----------------------------------------------------------------------------
