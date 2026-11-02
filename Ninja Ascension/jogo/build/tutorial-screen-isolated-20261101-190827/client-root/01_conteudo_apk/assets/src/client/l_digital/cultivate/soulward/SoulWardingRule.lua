-- ----------------------------------------------------------------------------------------------------
-- 说明：灵魂守卫规则界面
-------------------------------------------------------------------------------------------------------
SoulWardingRule = class("SoulWardingRuleClass", Window)

local soul_warding_rule_open_terminal = {
    _name = "soul_warding_rule_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SoulWardingRuleClass") == nil then           
            fwin:open(SoulWardingRule:new():init(params),fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local soul_warding_rule_close_terminal = {
    _name = "soul_warding_rule_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SoulWardingRuleClass") then
            fwin:close(fwin:find("SoulWardingRuleClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(soul_warding_rule_open_terminal)
state_machine.add(soul_warding_rule_close_terminal)
state_machine.init()

function SoulWardingRule:ctor()
    self.super:ctor()
    self.roots = {}
end

function SoulWardingRule:init(params)
    return self
end


function SoulWardingRule:onUpdate(dt)
end

function SoulWardingRule:onEnterTransitionFinish()
    local csbNode = csb.createNode("cultivate/soul_warding_help.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "soul_warding_rule_close", 
        isPressedActionEnabled = true,
    },
    nil, 0)
    self:registerOnNoteUpdate(self, 1)
end

function SoulWardingRule:onExit()
  
end 
