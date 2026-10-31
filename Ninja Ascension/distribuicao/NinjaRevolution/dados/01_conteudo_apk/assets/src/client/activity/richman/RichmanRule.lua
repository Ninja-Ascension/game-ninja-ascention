--[[ ----------------------------------------------------------------------------
-- 规则界面
--]] ----------------------------------------------------------------------------
RichmanRule = class("RichmanRuleClass", Window)

-- 打开窗口
local rich_man_rule_window_open_terminal = {
    _name = "rich_man_rule_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RichmanRuleClass") then
            fwin:open(RichmanRule:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local rich_man_rule_window_close_terminal = {
    _name = "rich_man_rule_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RichmanRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rich_man_rule_window_open_terminal)
state_machine.add(rich_man_rule_window_close_terminal)
state_machine.init()

-- 构造器
function RichmanRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
   

    -- Initialize rich_man_rule page state machine.
    local function init_rich_man_rule_terminal()
        -- 打开角色创建窗口
        local rich_man_rule_open_terminal = {
            _name = "rich_man_rule_open",
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
        local rich_man_rule_close_terminal = {
            _name = "rich_man_rule_close",
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
        local rich_man_rule_show_terminal = {
            _name = "rich_man_rule_show",
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
        local rich_man_rule_hide_terminal = {
            _name = "rich_man_rule_hide",
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

        state_machine.add(rich_man_rule_open_terminal)
        state_machine.add(rich_man_rule_close_terminal)
        state_machine.add(rich_man_rule_show_terminal)
        state_machine.add(rich_man_rule_hide_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_rich_man_rule_terminal()
end

-- 对象初始化
function RichmanRule:init(params)
  
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end


function RichmanRule:onEnterTransitionFinish()
    
    local csbNode = csb.createNode("utils/common_popup_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)


    -- 关闭规则界面
    self.Button_rule =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "rich_man_rule_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    self.Text_rule = ccui.Helper:seekWidgetByName(root, "Text_1")
    local text = tipStringInfo_richman[9]
    self.Text_rule:setString(text)
end

function RichmanRule:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("rich_man_rule_open")
    state_machine.remove("rich_man_rule_close")
    state_machine.remove("rich_man_rule_show")
    state_machine.remove("rich_man_rule_hide")
end

function RichmanRule:close()
    -- window event : close.
end

function RichmanRule:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
