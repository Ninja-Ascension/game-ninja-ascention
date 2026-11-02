----------------------------------------------------------------------------------------------------
-- 说明：装甲阵位cell
-------------------------------------------------------------------------------------------------------
ArmorFormationCell = class("ArmorFormationCellClass", Window)
ArmorFormationCell.__size = nil

local armor_formation_cell_create_terminal = {
    _name = "armor_formation_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArmorFormationCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_formation_cell_create_terminal)
state_machine.init()

function ArmorFormationCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self.is_selected = false
    self.max_attr_index = 0

    local function init_armor_formation_cell_terminal()
        local armor_formation_cell_set_selected_terminal = {
            _name = "armor_formation_cell_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local selected = params[2]
                cell:setSelected(selected)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_formation_cell_set_hook_terminal = {
            _name = "armor_formation_cell_set_hook",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local hook = params[2]
                cell:setHook(hook)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_formation_cell_update_info_terminal = {
            _name = "armor_formation_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                cell._index = params[2]
                cell:reload()
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_formation_cell_update_draw_terminal = {
            _name = "armor_formation_cell_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local max_attr_index = params[2]
                cell.max_attr_index = max_attr_index
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_formation_cell_set_selected_terminal)   
        state_machine.add(armor_formation_cell_set_hook_terminal)   
        state_machine.add(armor_formation_cell_update_info_terminal)   
        state_machine.add(armor_formation_cell_update_draw_terminal)   
        state_machine.init()
    end
    init_armor_formation_cell_terminal()           
end

function ArmorFormationCell:setSelected(selected)
    local root = self.roots[1]
    local Button_armor_formation = ccui.Helper:seekWidgetByName(root, "Button_armor_formation")
    local Text_armor_formation_att = ccui.Helper:seekWidgetByName(root, "Text_armor_formation_att")
    self.is_selected = selected
    if selected == true then
        Button_armor_formation:setHighlighted(true)
        Text_armor_formation_att:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
    else
        Button_armor_formation:setHighlighted(false)
        Text_armor_formation_att:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
end

function ArmorFormationCell:setHook(hook)
    local root = self.roots[1]
    local Image_armor_formation_hook = ccui.Helper:seekWidgetByName(root, "Image_armor_formation_hook")
    if hook == true then
        Image_armor_formation_hook:setVisible(true)
    else
        Image_armor_formation_hook:setVisible(false)
    end
end

function ArmorFormationCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_armor_formation_att = ccui.Helper:seekWidgetByName(root, "Text_armor_formation_att")

    if self.max_attr_index <= 0 then
        Text_armor_formation_att:setString("")
    else
        Text_armor_formation_att:setString(armor_tip_str[9]..armor_attr_tip_str[self.max_attr_index])
    end
    self:setSelected(self.is_selected)
end

function ArmorFormationCell:onEnterTransitionFinish()

end

function ArmorFormationCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.armor.armor_formation_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if ArmorFormationCell.__size == nil then
        ArmorFormationCell.__size = size
    end

    local Button_armor_formation = ccui.Helper:seekWidgetByName(root, "Button_armor_formation")
    Button_armor_formation:setTouchEnabled(false) 

    local widget = ccui.Helper:seekWidgetByName(root, "Button_armor_formation")
    if widget._nodeChild ~= nil then
        widget:removeChild(widget._nodeChild, true)
        widget._nodeChild = nil
        widget._istips = false
    end
    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_armor_formation",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_armor_formation"),
        _invoke = nil,
        _formation_type = self._index,
        _interval = 0.2,})
    
    self:onUpdateDraw()
end

function ArmorFormationCell:onExit()
    self:unload()
end

function ArmorFormationCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ArmorFormationCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_formation_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ArmorFormationCell:clearUIInfo()
    local root = self.roots[1]
    local Text_armor_formation_att = ccui.Helper:seekWidgetByName(root, "Text_armor_formation_att")
    local Image_armor_formation_hook = ccui.Helper:seekWidgetByName(root, "Image_armor_formation_hook")
    local Button_armor_formation = ccui.Helper:seekWidgetByName(root, "Button_armor_formation")
    if Text_armor_formation_att ~= nil then
        Text_armor_formation_att:setString("")
        Text_armor_formation_att:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Image_armor_formation_hook:setVisible(false)
        Button_armor_formation:setHighlighted(false)
    end

end

function ArmorFormationCell:init(params) 
    self._index = params[1]
    self:onInit()
    self:setContentSize(ArmorFormationCell.__size)
    self:setTouchEnabled(true)
end

