-- ----------------------------------------------------------------------------------------------------
-- 说明：数码冒险活动副本规则界面
-------------------------------------------------------------------------------------------------------
ActivityDuplicateRuleWindow = class("ActivityDuplicateRuleWindowClass", Window)

local activity_duplicate_rule_window_open_terminal = {
    _name = "activity_duplicate_rule_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityDuplicateRuleWindowClass") then
            fwin:open(ActivityDuplicateRuleWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_duplicate_rule_window_close_terminal = {
    _name = "activity_duplicate_rule_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityDuplicateRuleWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_duplicate_rule_window_open_terminal)
state_machine.add(activity_duplicate_rule_window_close_terminal)
state_machine.init()

function ActivityDuplicateRuleWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._current_page_index = 1
end

function ActivityDuplicateRuleWindow:init(params)
    self._current_page_index = tonumber(params)
    self:onInit()
    return self
end
function ActivityDuplicateRuleWindow:onEnterTransitionFinish()

end

function ActivityDuplicateRuleWindow:onInit()
    local fileName = string.format("campaign/maoxian_rule_%d.csb",self._current_page_index)
    local csbNode = csb.createNode(fileName)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "activity_duplicate_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)
end

function ActivityDuplicateRuleWindow:onExit()
    
end
