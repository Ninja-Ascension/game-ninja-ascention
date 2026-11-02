-----------------------------
--诸神排行
-----------------------------
SmCultivateConstellationRule = class("SmCultivateConstellationRuleClass", Window)
SmCultivateConstellationRule.__size = nil

local sm_cultivate_constellation_rule_open_terminal = {
    _name = "sm_cultivate_constellation_rule_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmCultivateConstellationRuleClass") == nil then
            fwin:open(SmCultivateConstellationRule:new():init(params), fwin._ui)      
        end
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local sm_cultivate_constellation_rule_close_terminal = {
    _name = "sm_cultivate_constellation_rule_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmCultivateConstellationRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_constellation_rule_open_terminal)
state_machine.add(sm_cultivate_constellation_rule_close_terminal)
state_machine.init()

function SmCultivateConstellationRule:ctor()
    self.super:ctor()
    self.roots = {}

end

function SmCultivateConstellationRule:onUpdateDraw()
    local root = self.roots[1]
   
end

function SmCultivateConstellationRule:onUpdate(dt)
    
end

function SmCultivateConstellationRule:onEnterTransitionFinish()

end

function SmCultivateConstellationRule:onInit( )
    local csbItem = csb.createNode("cultivate/constellation_rule.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule_closed"), nil, 
    {
        terminal_name = "sm_cultivate_constellation_rule_close", 
        terminal_state = 0, 
    }, nil, 0)

    if SmCultivateConstellationRule.__size == nil then
        SmCultivateConstellationRule.__size = root:getContentSize()
    end
    self:setContentSize(SmCultivateConstellationRule.__size)
end

function SmCultivateConstellationRule:init()    
    self:onInit()
    return self
end

function SmCultivateConstellationRule:onExit()
end
