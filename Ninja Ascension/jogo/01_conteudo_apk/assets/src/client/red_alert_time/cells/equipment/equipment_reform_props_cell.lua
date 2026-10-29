----------------------------------------------------------------------------------------------------
-- 说明：改造消耗道具cell
-------------------------------------------------------------------------------------------------------
EquipmentReformPropsCell = class("EquipmentReformPropsCellClass", Window)
EquipmentReformPropsCell.__size = nil

local equipment_reform_props_cell_create_terminal = {
    _name = "equipment_reform_props_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EquipmentReformPropsCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_reform_props_cell_create_terminal)
state_machine.init()

function EquipmentReformPropsCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._prop_id = 0
    self._count = 0
    self._max_count = 0

    local function init_equipment_reform_props_cell_terminal()

    end
    init_equipment_reform_props_cell_terminal()           
end

function EquipmentReformPropsCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)

    local cell = nil
    local use_of_ship = dms.int(dms["prop_mould"], self._prop_id, prop_mould.use_of_ship)
    if use_of_ship > 0 then
        cell = state_machine.excute("props_icon_create_cell",0,{9,8,self._prop_id,1, -1, true})
    else
        cell = state_machine.excute("props_icon_create_cell",0,{6,1,self._prop_id,1, -1, true})
    end
    Panel_props_icon:addChild(cell)

    local Text_props_equ = ccui.Helper:seekWidgetByName(root, "Text_props_equ")
    local fontSize = Text_props_equ:getFontSize()
    Text_props_equ:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false) 
    local color = color_Type[6]
    if tonumber(self._count) >= tonumber(self._max_count) then
        color = color_Type[1]
    end
    local str1 = ""..exChangeNumToString(self._count)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color[1],color[2],color[3]),255, str1, "fonts/simhei.ttf",fontSize)
    _richText:pushBackElement(re1)  
    local str2 = "/"..exChangeNumToString(self._max_count)
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, str2, "fonts/simhei.ttf",fontSize)
    _richText:pushBackElement(re2)

    _richText:setContentSize(cc.size(root:getContentSize().width,fontSize))
    _richText:formatTextExt()
    _richText:setAnchorPoint(cc.p(0.5, 0.5))
    _richText:setPosition(cc.p(Text_props_equ:getPositionX() + Text_props_equ:getContentSize().width / 2,Text_props_equ:getContentSize().height))
    Text_props_equ:addChild(_richText)
end

function EquipmentReformPropsCell:onEnterTransitionFinish()

end

function EquipmentReformPropsCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.equipment.equipment_reform_paops_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if EquipmentReformPropsCell.__size == nil then
        EquipmentReformPropsCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function EquipmentReformPropsCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_reform_paops_cell, self.roots[1])
end

function EquipmentReformPropsCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function EquipmentReformPropsCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.equipment.equipment_reform_paops_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function EquipmentReformPropsCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    local Text_props_equ = ccui.Helper:seekWidgetByName(root, "Text_props_equ")
    
    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Text_props_equ:setString("")
        Text_props_equ:removeAllChildren(true)
    end
end

function EquipmentReformPropsCell:init(params)
    self._prop_id = params[1]
    self._count = params[2]
    self._max_count = params[3]

    self:onInit()
    self:setContentSize(EquipmentReformPropsCell.__size)
end

