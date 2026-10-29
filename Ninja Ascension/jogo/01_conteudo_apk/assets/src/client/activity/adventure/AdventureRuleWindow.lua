-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险规则
-------------------------------------------------------------------------------------------------------
AdventureRuleWindow = class("AdventureRuleWindowClass", Window)

local adventure_rule_window_open_terminal = {
    _name = "adventure_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureRuleWindowClass") == nil then
            fwin:open(AdventureRuleWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_rule_window_close_terminal = {
    _name = "adventure_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("AdventureRuleWindowClass") then
            fwin:close(fwin:find("AdventureRuleWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_rule_window_open_terminal)
state_machine.add(adventure_rule_window_close_terminal)
state_machine.init()

function AdventureRuleWindow:ctor()
    self.super:ctor()
    self.roots = {}
end

function AdventureRuleWindow:init(params)
    return self
end

function AdventureRuleWindow:onUpdate(dt)
end

function AdventureRuleWindow:onUpdateDraw()
    local root = self.roots[1]
end


function AdventureRuleWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/adventure/adv_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil, 
    {
        terminal_name = "adventure_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function AdventureRuleWindow:onExit()

end
