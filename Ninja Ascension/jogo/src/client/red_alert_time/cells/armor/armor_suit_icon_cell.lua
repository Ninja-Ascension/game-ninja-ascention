----------------------------------------------------------------------------------------------------
-- 说明：装甲装备cell
-------------------------------------------------------------------------------------------------------
ArmorSuitIconCell = class("ArmorSuitIconCellClass", Window)

local armor_suit_icon_cell_create_terminal = {
    _name = "armor_suit_icon_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArmorSuitIconCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_suit_icon_cell_create_terminal)
state_machine.init()

function ArmorSuitIconCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._formation_type = 0
    self._armor_info = nil
    self._is_max_attr = false

    self._push_params = nil

    local function init_armor_suit_icon_cell_terminal()
        local armor_suit_icon_cell_click_terminal = {
            _name = "armor_suit_icon_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._armor_info == nil then
                    state_machine.excute("armor_install_window_open", 0, {cell._formation_type, cell._index, cell._armor_info})
                else
                    state_machine.excute("armor_infor_window_open", 0, {cell._formation_type, cell._index, cell._armor_info})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_suit_icon_cell_update_info_terminal = {
            _name = "armor_suit_icon_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                cell._armor_info = params[2]
                cell._is_max_attr = params[3]
                cell._formation_type = params[4]
                if cell._push_params ~= nil then
                    cell._push_params._formation_type = cell._formation_type
                end
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_suit_icon_cell_update_max_attr_color_terminal = {
            _name = "armor_suit_icon_cell_update_max_attr_color",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                cell._is_max_attr = params[2]
                cell:updateMaxAttrColor()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_suit_icon_cell_click_terminal)
        state_machine.add(armor_suit_icon_cell_update_info_terminal)
        state_machine.add(armor_suit_icon_cell_update_max_attr_color_terminal)
        state_machine.init()
    end
    init_armor_suit_icon_cell_terminal()           
end

function ArmorSuitIconCell:updateMaxAttrColor()
    local root = self.roots[1]
    local Text_armor_atti = ccui.Helper:seekWidgetByName(root, "Text_armor_atti")
    Text_armor_atti:setString(""..self._index.."."..armor_attr_tip_str[self._index])
    if self._is_max_attr == true then
        Text_armor_atti:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
    else
        Text_armor_atti:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
end

function ArmorSuitIconCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_armor_atti_icon = ccui.Helper:seekWidgetByName(root, "Panel_armor_atti_icon")
    Panel_armor_atti_icon:removeAllChildren(true)
    Panel_armor_atti_icon:removeBackGroundImage()

    if self._armor_info == nil then
        Panel_armor_atti_icon:setBackGroundImage(string.format(config_res.images.ui.armor.armor_props, self._index))
    else
        local equipment_mould_id = tonumber(self._armor_info.equipment_mould_id)
        local cell = state_machine.excute("props_icon_create_cell",0,{8, 3, equipment_mould_id, 15, nil, nil, self._armor_info})
        Panel_armor_atti_icon:addChild(cell)
    end

    self:updateMaxAttrColor()
end

function ArmorSuitIconCell:onEnterTransitionFinish()

end

function ArmorSuitIconCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.armor.armor_suit_icon_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_armor_atti_icon"), nil, 
    {
        terminal_name = "armor_suit_icon_cell_click", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1) 

    self._push_params =  { _terminal_name = "push_notification_armor_icon",
        _widget = ccui.Helper:seekWidgetByName(root, "root"),
        _invoke = nil,
        _formation_type = self._formation_type,
        _armor_type = self._index,
        _interval = 0.2,}

    state_machine.excute("push_notification_center_manager", 0, self._push_params)


    self:onUpdateDraw()
end

function ArmorSuitIconCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_suit_icon_cell, self.roots[1])
end

function ArmorSuitIconCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ArmorSuitIconCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_suit_icon_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ArmorSuitIconCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_armor_atti_icon = ccui.Helper:seekWidgetByName(root, "Panel_armor_atti_icon")
    local Text_armor_atti = ccui.Helper:seekWidgetByName(root, "Text_armor_atti")

    if Panel_armor_atti_icon ~= nil then
        Panel_armor_atti_icon:removeAllChildren(true)
        Panel_armor_atti_icon:removeBackGroundImage()
        Text_armor_atti:setString("")
        Text_armor_atti:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
end

function ArmorSuitIconCell:init(params)
    self._index = params[1]
    self._armor_info = params[2]
    self._is_max_attr = params[3]
    self._formation_type = params[4]
    self:onInit()
end

