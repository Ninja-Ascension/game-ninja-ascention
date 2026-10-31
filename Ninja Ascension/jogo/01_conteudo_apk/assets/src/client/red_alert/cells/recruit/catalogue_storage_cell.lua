CatalogueStorageCell = class("CatalogueStorageClass", Window)
CatalogueStorageCell.__size = nil

local catalogue_storage_cell_create_terminal = {
    _name = "catalogue_storage_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CatalogueStorageCell:new():init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(catalogue_storage_cell_create_terminal)
state_machine.init()

function CatalogueStorageCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_ids = {}
end

function CatalogueStorageCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    Panel_icon:removeAllChildren(true)
    for k,v in pairs(self.ship_ids) do
        if v ~= nil then
            local cell = state_machine.excute("hero_icon_create_cell",0,{v.ship_mould_id,7,1,true})
            cell:setAnchorPoint(cc.p(0,1))
            Panel_icon:addChild(cell)
            cell:setPosition(cc.p(10 + (k - 1)*(cell:getContentSize().width + 20), 0))
        end
    end
end

function CatalogueStorageCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.recruit.catalogue_storage_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CatalogueStorageCell.__size == nil then
        CatalogueStorageCell.__size = root:getContentSize()
    end

    self:setContentSize(CatalogueStorageCell.__size)
    if self.ship_ids ~= nil then
        self:onUpdateDraw()
    end
end

function CatalogueStorageCell:init(params)
    if params == nil then
        self.ship_ids = nil
        self:onInit()
    else
        self.ship_ids = params[1]
        if params[2] ~= nil and params[2] < 4 then
           self:onInit()
        end
        self:setContentSize(CatalogueStorageCell.__size)
    end
    return self
end

function CatalogueStorageCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CatalogueStorageCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    Panel_icon:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.recruit.catalogue_storage_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function CatalogueStorageCell:onExit()
    local Panel_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_icon")
    if Panel_icon ~= nil then
        Panel_icon:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.recruit.catalogue_storage_cell, self.roots[1])
end