----------------------------------------------------------------------------------------------------
-- 说明：配件装备
-------------------------------------------------------------------------------------------------------
EquipmentPartsPageCell = class("EquipmentPartsPageCellClass", Window)
EquipmentPartsPageCell.__size = nil

local equipment_parts_page_cell_create_terminal = {
    _name = "equipment_parts_page_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EquipmentPartsPageCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_parts_page_cell_create_terminal)
state_machine.init()

function EquipmentPartsPageCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil

    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
    local function init_equipment_parts_page_cell_terminal()
        --刷新
        local equipment_parts_page_cell_update_draw_terminal = {
            _name = "equipment_parts_page_cell_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(equipment_parts_page_cell_update_draw_terminal)
        state_machine.init()
    end
    init_equipment_parts_page_cell_terminal()           
end

function EquipmentPartsPageCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_tank_type_icon = ccui.Helper:seekWidgetByName(root, "Panel_tank_type_icon")
    local Text_parts_type_name = ccui.Helper:seekWidgetByName(root, "Text_parts_type_name")
    Panel_tank_type_icon:removeBackGroundImage()
    Panel_tank_type_icon:setBackGroundImage(string.format(config_res.images.ui.equipment.equipment_tank_type, self._index))
    Text_parts_type_name:setString(tipStringInfo_tank_type_info[self._index])

    local wear_equip = {}
    for k,v in pairs(_ED.user_equiment) do
        if v.influence_type == self._index and v.armor_type == 0 then
            if tonumber(v.is_equiped) == 1 then
                wear_equip[""..v.equipment_type] = v
            end
        end
    end

    local need_level_info = zstring.split(dms.string(dms["equipment_config"], 7, equipment_config.param), "|")
    local lockInfo = {}
    local need_levels = zstring.split(need_level_info[self._index], ",")
    for k, v in pairs(need_levels) do
        table.insert(lockInfo, tonumber(v))
    end

    for i = 1, 8 do
        local Panel_equipment_parts = ccui.Helper:seekWidgetByName(root, "Panel_equipment_parts_"..i)
        Panel_equipment_parts:removeAllChildren(true)
        -- 已穿戴
        if wear_equip[""..i] ~= nil then
            cell = state_machine.excute("props_icon_create_cell", 0, {8, 5, wear_equip[""..i].equip_id, 7})
            Panel_equipment_parts:addChild(cell)
            Panel_equipment_parts.roots = cell.roots
        else
            -- 解锁但未穿戴
            if tonumber(_ED.user_info.user_grade) >= tonumber(lockInfo[i]) then
                local cell = state_machine.excute("equipment_parts_icon_cell_create", 0, {self._index, i, false, lockInfo[i]})
                Panel_equipment_parts:addChild(cell)
                Panel_equipment_parts.roots = cell.roots
            else
                -- 未解锁
                local cell = state_machine.excute("equipment_parts_icon_cell_create", 0, {self._index, i, true, lockInfo[i]})
                Panel_equipment_parts:addChild(cell)
                Panel_equipment_parts.roots = cell.roots
            end
        end
    end
end

function EquipmentPartsPageCell:onEnterTransitionFinish()

end

function EquipmentPartsPageCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.equipment.equipment_parts_page_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if EquipmentPartsPageCell.__size == nil then
        EquipmentPartsPageCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function EquipmentPartsPageCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_parts_page_cell, self.roots[1])
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
    cacher.freeRef(config_csb.cells.equipment.equipment_parts_page_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function EquipmentPartsPageCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_tank_type_icon = ccui.Helper:seekWidgetByName(root, "Panel_tank_type_icon")
    local Text_parts_type_name = ccui.Helper:seekWidgetByName(root, "Text_parts_type_name")
    if Panel_tank_type_icon ~= nil then
        Panel_tank_type_icon:removeBackGroundImage()
        Text_parts_type_name:setString("")
        for i = 1, 8 do
            local Panel_equipment_parts = ccui.Helper:seekWidgetByName(root, "Panel_equipment_parts_"..i)
            Panel_equipment_parts:removeAllChildren(true)
        end
    end
end

function EquipmentPartsPageCell:init(params)
    self._index = params[1]
    if self._index <= 2 then
       self:onInit()
    end
    self:setContentSize(EquipmentPartsPageCell.__size)
end

