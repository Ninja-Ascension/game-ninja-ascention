-- ------------------------------------------------------------------------------------------------------------
--  说明：学霸之战规则
-- ------------------------------------------------------------------------------------------------------------
SuperScholarRule = class("SuperScholarRuleClass", Window)

--打开界面
local super_scholar_rule_open_terminal = {
    _name = "super_scholar_rule_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = SuperScholarRule:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(super_scholar_rule_open_terminal)
state_machine.init()

function SuperScholarRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}         

    local function init_super_scholar_rule_terminal()
        local super_scholar_rule_show_terminal = {
            _name = "super_scholar_rule_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_rule_hide_terminal = {
            _name = "super_scholar_rule_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_rule_update_draw_terminal = {
            _name = "super_scholar_rule_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(super_scholar_rule_show_terminal)
        state_machine.add(super_scholar_rule_hide_terminal)
        state_machine.add(super_scholar_rule_update_draw_terminal)
        state_machine.init()
    end
    init_super_scholar_rule_terminal()
end


function SuperScholarRule:onUpdateDraw()
    local root = self.roots[1]

end

function SuperScholarRule:onUpdate()

end

function SuperScholarRule:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.super_scholar_tab, 4))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function SuperScholarRule:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function SuperScholarRule:onExit()
    state_machine.remove("super_scholar_rule_show")
    state_machine.remove("super_scholar_rule_hide")
    state_machine.remove("super_scholar_rule_update_draw")
end