ActivityGroupBuyPopUp = class("ActivityGroupBuyPopUpClass", Window)

-- 打开窗口
local activity_group_buy_pop_up_open_terminal = {
    _name = "activity_group_buy_pop_up_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityGroupBuyPopUpClass") then
            fwin:open(ActivityGroupBuyPopUp:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local activity_group_buy_pop_up_close_terminal = {
    _name = "activity_group_buy_pop_up_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityGroupBuyPopUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_pop_up_open_terminal)
state_machine.add(activity_group_buy_pop_up_close_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuyPopUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_pop_up_terminal()
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_pop_up_terminal()
end

-- 对象初始化
function ActivityGroupBuyPopUp:init(_reward)
    self._reward = _reward
    return self
end

function ActivityGroupBuyPopUp:updateDraw()
    -- 奖励容器
    self.ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")

    -- 绘制奖励
    local cells = DrawHandle.drawIcons(self._reward)
    self.ListView_1:removeAllItems()
    for i = 1, #cells do
        self.ListView_1:addChild(cells[i])
    end
    self.ListView_1:requestRefreshView()
end

function ActivityGroupBuyPopUp:buttonAddClickEvent()
    -- 关闭按钮
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "activity_group_buy_pop_up_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function ActivityGroupBuyPopUp:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/group_buy/group_buy_pop_up.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:buttonAddClickEvent()
    self:updateDraw()
end

function ActivityGroupBuyPopUp:onExit()
end
