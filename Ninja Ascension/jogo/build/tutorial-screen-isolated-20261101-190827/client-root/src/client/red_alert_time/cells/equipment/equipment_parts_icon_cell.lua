----------------------------------------------------------------------------------------------------
-- 说明：配件装备cell
-------------------------------------------------------------------------------------------------------
EquipmentPartsIconCell = class("EquipmentPartsIconCellClass", Window)

local equipment_parts_icon_cell_create_terminal = {
    _name = "equipment_parts_icon_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EquipmentPartsIconCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_parts_icon_cell_create_terminal)
state_machine.init()

function EquipmentPartsIconCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._type = 0
    self._index = 0
    self._isLock = true
    self._openLevel = 0

    local function init_equipment_parts_icon_cell_terminal()
        local equipment_parts_icon_cell_click_terminal = {
            _name = "equipment_parts_icon_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local equip = cell:getEquipment()
                if cell._isLock == true then
                    TipDlg.drawTextDailog(string.format(red_alert_time_str[37], cell._openLevel))
                elseif equip == nil then
                    TipDlg.drawTextDailog(red_alert_time_str[38])
                else
                    if __lua_project_id == __lua_project_pacific_rim then
                        state_machine.excute("equipment_strengthen_reform_window_open", 0, {_datas = {page_index = 1, equipment_id = equip.equip_id}})
                    else
                        state_machine.excute("equipment_parts_infor_window_open", 0, {equip})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(equipment_parts_icon_cell_click_terminal)
        state_machine.init()
    end
    init_equipment_parts_icon_cell_terminal()           
end

function EquipmentPartsIconCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_equi_parts_type_icon = ccui.Helper:seekWidgetByName(root, "Panel_equi_parts_type_icon")
    local Text_parte_open_lv = ccui.Helper:seekWidgetByName(root, "Text_parte_open_lv")
    local Image_parts_rock = ccui.Helper:seekWidgetByName(root, "Image_parts_rock")
    local picIndex = 1
    if self._type == 2 then
        picIndex = 2
    end
    Panel_equi_parts_type_icon:removeBackGroundImage()
    Panel_equi_parts_type_icon:setBackGroundImage(string.format(config_res.images.ui.equipment.equipment_parts, picIndex, self._index))
    if self._isLock == true then
        Image_parts_rock:setVisible(true)
        Text_parte_open_lv:setString(string.format(red_alert_time_str[33], self._openLevel))
    else
        Image_parts_rock:setVisible(false)
        Text_parte_open_lv:setString("")
    end
end

function EquipmentPartsIconCell:getEquipment()
    local equip = nil
    for k, v in pairs(_ED.user_equiment) do
        if tonumber(v.influence_type) == self._type 
            and tonumber(v.equipment_type) == self._index 
            and tonumber(v.is_equiped) == 0 
            then
            if equip == nil then
                equip = v
            else
                if tonumber(v.grow_level) > tonumber(equip.grow_level) then
                    equip = v
                elseif tonumber(v.grow_level) == tonumber(equip.grow_level) 
                    and tonumber(v.rank_up_level) > tonumber(equip.rank_up_level) 
                    then
                    equip = v
                elseif tonumber(v.grow_level) == tonumber(equip.grow_level) 
                    and tonumber(v.rank_up_level) == tonumber(equip.rank_up_level) 
                    and tonumber(v.upgrade_level) > tonumber(equip.upgrade_level) 
                    then
                    equip = v
                end
            end
        end
    end
    return equip
end

function EquipmentPartsIconCell:onEnterTransitionFinish()

end

function EquipmentPartsIconCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.equipment.equipment_parts_icon_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "root"), nil, 
    {
        terminal_name = "equipment_parts_icon_cell_click", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)  

    local widget = ccui.Helper:seekWidgetByName(root, "root")
    if widget._nodeChild ~= nil then
        widget:removeChild(widget._nodeChild, true)
        widget._nodeChild = nil
        widget._istips = false
    end
    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
    if self._isLock == false then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment_parts_icon",
        _widget = ccui.Helper:seekWidgetByName(root, "root"),
        _invoke = nil,
        _type = self._type,
        _index = self._index,
        _interval = 0.2,})
    end

    self:onUpdateDraw()
end

function EquipmentPartsIconCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_parts_icon_cell, self.roots[1])
end

function EquipmentPartsPageCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function EquipmentPartsPageCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_parts_icon_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function EquipmentPartsIconCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_equi_parts_type_icon = ccui.Helper:seekWidgetByName(root, "Panel_equi_parts_type_icon")
    local Text_parte_open_lv = ccui.Helper:seekWidgetByName(root, "Text_parte_open_lv")
    local Image_parts_rock = ccui.Helper:seekWidgetByName(root, "Image_parts_rock")

    if Panel_equi_parts_type_icon ~= nil then
        Panel_equi_parts_type_icon:removeBackGroundImage()
        Text_parte_open_lv:setString("")
        Image_parts_rock:setVisible(false)
    end
end

function EquipmentPartsIconCell:init(params)
    self._type = params[1]
    self._index = params[2]
    self._isLock = params[3]
    self._openLevel = params[4]
    self:onInit()
end

