-----------------------------
-- 洗炼规则
-----------------------------
EquipmentClearRule = class("EquipmentClearRuleClass", Window)
--打开
local equipment_clear_rule_window_open_terminal = {
    _name = "equipment_clear_rule_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        fwin:open(EquipmentClearRule:new():init(index), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local equipment_clear_rule_window_close_terminal = {
    _name = "equipment_clear_rule_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentClearRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_clear_rule_window_open_terminal)
state_machine.add(equipment_clear_rule_window_close_terminal)
state_machine.init()

function EquipmentClearRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_equipment_clear_rule_terminal()
        --显示界面
        local equipment_clear_rule_window_show_terminal = {
            _name = "equipment_clear_rule_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
        --隐藏界面
        local equipment_clear_rule_window_hide_terminal = {
            _name = "equipment_clear_rule_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_clear_rule_window_show_terminal)
        state_machine.add(equipment_clear_rule_window_hide_terminal)
        state_machine.init()
    end

    init_equipment_clear_rule_terminal()
end 

function EquipmentClearRule:onUpdateDraw()
    local root = self.roots[1]
end

function EquipmentClearRule:onHide( )
    self:setVisible(false)
end

function EquipmentClearRule:onShow( )
    self:setVisible(true)
end

function EquipmentClearRule:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment_clear_rule)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.legion.legion_rule)
    table.insert(self.actions, action)
    csbItem:runAction(action)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "equipment_clear_rule_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

    self:onUpdateDraw()
end

function EquipmentClearRule:init()
	self:onInit()
    return self
end

function EquipmentClearRule:onExit()  
    
    state_machine.remove("equipment_clear_rule_window_show")
    state_machine.remove("equipment_clear_rule_window_hide")
end