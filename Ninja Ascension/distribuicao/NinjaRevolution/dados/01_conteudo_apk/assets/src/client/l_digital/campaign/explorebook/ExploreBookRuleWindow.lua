-- ----------------------------------------------------------------------------------------------------
-- 说明：图鉴规则
-------------------------------------------------------------------------------------------------------
ExploreBookRuleWindow = class("ExploreBookRuleWindowClass", Window)

local explore_book_rule_window_open_terminal = {
    _name = "explore_book_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:open(ExploreBookRuleWindow:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local explore_book_rule_window_close_terminal = {
    _name = "explore_book_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("ExploreBookRuleWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(explore_book_rule_window_open_terminal)
state_machine.add(explore_book_rule_window_close_terminal)
state_machine.init()

function ExploreBookRuleWindow:ctor()
    self.super:ctor()
    self.roots = {}
end

function ExploreBookRuleWindow:onUpdate(dt)

end

function ExploreBookRuleWindow:onUpdateDraw()

end

function ExploreBookRuleWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_book_rule.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "explore_book_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
end

function ExploreBookRuleWindow:init()

end

function ExploreBookRuleWindow:onExit()

end