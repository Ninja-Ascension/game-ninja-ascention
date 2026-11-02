----------------------------------------------------------------------------------------------------
-- 说明：装备cell
-------------------------------------------------------------------------------------------------------
EquipmentPacksTabCell = class("EquipmentPacksTabCellClass", Window)
EquipmentPacksTabCell.__size = nil

local equipment_packs_tab_cell_create_terminal = {
    _name = "equipment_packs_tab_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EquipmentPacksTabCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_packs_tab_cell_create_terminal)
state_machine.init()

function EquipmentPacksTabCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    -- 道具信息
    self._info = nil 
    -- 道具类型 1:配件 2:碎片 3:材料
    self._type = 0

    app.load("client.red_alert_time.cells.equipment.equipment_packs_chip_cell")

    local function init_equipment_packs_tab_cell_terminal()

    end
    init_equipment_packs_tab_cell_terminal()           
end

function EquipmentPacksTabCell:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_equim_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_equim_icon")
    ScrollView_equim_icon:removeAllChildren(true)
    local size = ScrollView_equim_icon:getContentSize()
    for i,v in pairs(self._info) do
        local cell = nil
        if self._type == 1 then
            cell = state_machine.excute("props_icon_create_cell", 0, {8, 5, v.equip_id, 7, nil, true})
        elseif self._type == 2 then
            cell = state_machine.excute("equipment_packs_chip_cell_create", 0, {v.prop_id, v.prop})
        else
            cell = state_machine.excute("props_icon_create_cell",0,{6,1,v.prop_id,1,v.count})
        end
        ScrollView_equim_icon:addChild(cell) 
        cell:setAnchorPoint(cc.p(0, 1))
        cell:setPosition(cc.p(20 + (i - 1) * (size.width / 4), size.height))
    end
end

function EquipmentPacksTabCell:onEnterTransitionFinish()

end

function EquipmentPacksTabCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.equipment.equipment_packs_tab_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if EquipmentPacksTabCell.__size == nil then
        EquipmentPacksTabCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function EquipmentPacksTabCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_packs_tab_cell, self.roots[1])
end

function EquipmentPacksTabCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function EquipmentPacksTabCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_packs_tab_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function EquipmentPacksTabCell:clearUIInfo()
    local root = self.roots[1]
    local ScrollView_equim_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_equim_icon")

    if ScrollView_equim_icon ~= nil then
        ScrollView_equim_icon:removeAllChildren(true)
    end
end

function EquipmentPacksTabCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._type = params[3]
    if self._index <= 6 then
       self:onInit()
    end
    self:setContentSize(EquipmentPacksTabCell.__size)
end

