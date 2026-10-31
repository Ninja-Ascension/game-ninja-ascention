--------------------------------------------------------------------------------------------------------------
--  说明：超进化规则界面  
--------------------------------------------------------------------------------------------------------------
MegaRuleInfo = class("MegaRuleInfoClass", Window)

local megaruleinfo_open_terminal = {
    _name = "megaruleinfo_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaRuleInfoClass") == nil then           
            fwin:open(MegaRuleInfo:new():init(params), fwin._viewdialog)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local megaruleinfo_close_terminal = {
    _name = "megaruleinfo_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaRuleInfoClass") then
            fwin:close(fwin:find("MegaRuleInfoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(megaruleinfo_open_terminal)
state_machine.add(megaruleinfo_close_terminal)
state_machine.init()

function MegaRuleInfo:ctor()
    self.super:ctor()
    self.roots = {}   
end

function MegaRuleInfo:updateDraw()
    
end

function MegaRuleInfo:updateDrawInfo( )
   
end


function MegaRuleInfo:onUpdate(dt)
    
end

function MegaRuleInfo:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/sm_role_evolution_rule.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "megaruleinfo_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 0)
   
  --  self:updateDraw()
    -- self:updateDrawInfo()
end


function MegaRuleInfo:init(params)
   
    return self
end

function MegaRuleInfo:onExit()
    
end