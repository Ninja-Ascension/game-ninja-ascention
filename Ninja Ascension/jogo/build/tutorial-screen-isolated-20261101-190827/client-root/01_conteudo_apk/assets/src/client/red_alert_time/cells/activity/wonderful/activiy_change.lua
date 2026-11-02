--------------------------------------------------------------------------------------------------------------
--  说明：杂货铺单个道具icon
--------------------------------------------------------------------------------------------------------------
ActiviyChange = class("ActiviyChangeClass", Window)
ActiviyChange.__size = nil

--创建cell
local activiy_change_create_cell_terminal = {
    _name = "activiy_change_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local prop_data = params[1]
        local index = params[2]
        local cell = ActiviyChange:new()
        cell:init(prop_data,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activiy_change_create_cell_terminal)
state_machine.init()

function ActiviyChange:ctor()
	self.super:ctor()
	self.roots = {}
    -- 道具数据
    self._prop_data = prop_data

    self._index = index
end



function ActiviyChange:updateDraw()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local Image_change = ccui.Helper:seekWidgetByName(root,"Image_change")
    Image_change:setVisible(false)

    local cell = nil
    if tonumber(self._prop_data.prop_type) == 6 then    
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(self._prop_data.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(self._prop_data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,self._prop_data,self._prop_data,9,0,true,true})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,self._prop_data,self._prop_data,9,0,true,true})
        end  
    elseif tonumber(self._prop_data.prop_type) == 34 then    
        cell = state_machine.excute("all_resource_create_cell",0,{5,self._prop_data,self._prop_data,9,0,true,true})
    else
        cell = state_machine.excute("all_resource_create_cell",0,{2,self._prop_data,self._prop_data,9,0,true,true})
    end
    Panel_props_icon:addChild(cell)
    if tonumber(self._index) == 1 then
        Image_change:setVisible(true)
    end
end

function ActiviyChange:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.activiy_change, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if ActiviyChange.__size == nil then
        ActiviyChange.__size = root:getContentSize()
    end

	self:updateDraw()

end

function ActiviyChange:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function ActiviyChange:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.activity.wonderful.activiy_change, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function ActiviyChange:init(prop_data,index)
    self._prop_data = prop_data
    self._index = index
    self:onInit()
    self:setContentSize(ActiviyChange.__size)
    return self
end

function ActiviyChange:onExit()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.activiy_change, self.roots[1])
end