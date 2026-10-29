HeroPiecePreviewIconCell = class("HeroPiecePreviewIconCellClass", Window)
HeroPiecePreviewIconCell.__size = nil

local hero_piece_preview_icon_cell_create_terminal = {
    _name = "hero_piece_preview_icon_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = HeroPiecePreviewIconCell:new():init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_piece_preview_icon_cell_create_terminal)
state_machine.init()

function HeroPiecePreviewIconCell:ctor()
    self.super:ctor()
    self.roots = {}
    -- 碎片信息
    self._data = nil 
end

function HeroPiecePreviewIconCell:onUpdateDraw()
    local root = self.roots[1]
    -- 碎片icon绘制
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local cell = nil
    if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(self._data.prop_item), prop_mould.change_of_equipment))> 0 
        or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(self._data.prop_item), prop_mould.use_of_ship)) > 0  then
        cell = state_machine.excute("all_resource_create_cell",0,{3,self._data,self._data,9,0,false,true})
        if tonumber(self._data.prop_type) == 7 then 
            cell = state_machine.excute("all_resource_create_cell",0,{2,self._data,self._data,9,0,false,true})
        end
    else
        cell = state_machine.excute("all_resource_create_cell",0,{2,self._data,self._data,9,0,false,true})
    end  
    Panel_props_icon:addChild(cell)
    -- 碎片名字
    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
    local prop_name = dms.string(dms["prop_mould"], self._data.prop_item, prop_mould.prop_name)
    Text_props_name:setString(prop_name)
end

function HeroPiecePreviewIconCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.recruit.hero_piece_preview_icon_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if HeroPiecePreviewIconCell.__size == nil then
        HeroPiecePreviewIconCell.__size = root:getContentSize()
    end

    self:setContentSize(HeroPiecePreviewIconCell.__size)
    if self._data ~= nil then
        self:onUpdateDraw()
    end
end

function HeroPiecePreviewIconCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function HeroPiecePreviewIconCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.recruit.hero_piece_preview_icon_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function HeroPiecePreviewIconCell:init(params)
    self._data = params[1]
    self:onInit()
    self:setContentSize(HeroPiecePreviewIconCell.__size)
    return self
end

function HeroPiecePreviewIconCell:onExit()
    cacher.freeRef(config_csb.cells.recruit.hero_piece_preview_icon_cell, self.roots[1])
end