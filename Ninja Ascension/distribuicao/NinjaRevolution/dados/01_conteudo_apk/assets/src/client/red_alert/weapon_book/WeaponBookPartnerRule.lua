
WeaponBookPartnerRule = class("WeaponBookPartnerRuleClass", Window)

local weapon_book_partner_rule_window_open_terminal = {
    _name = "weapon_book_partner_rule_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(WeaponBookPartnerRule:new():init(), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local weapon_book_partner_rule_window_close_terminal = {
    _name = "weapon_book_partner_rule_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponBookPartnerRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_partner_rule_window_open_terminal)
state_machine.add(weapon_book_partner_rule_window_close_terminal)
state_machine.init()

function WeaponBookPartnerRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end

function WeaponBookPartnerRule:onUpdateDraw()
    local root = self.roots[1]
    local Text_rule = ccui.Helper:seekWidgetByName(root, "Text_rule_"..self._index)
    local Text_rule_inner = ccui.Helper:seekWidgetByName(root, "Text_rule_inner_"..self._index) 
    Text_rule:setVisible(true)
    Text_rule_inner:setVisible(true)
end

function WeaponBookPartnerRule:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_rule)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.legion.legion_rule)
    table.insert(self.actions, action)
    csbItem:runAction(action)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "weapon_book_partner_rule_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- self:onUpdateDraw()
end

function WeaponBookPartnerRule:init()
	self:onInit()
    return self
end

function WeaponBookPartnerRule:onExit()
end