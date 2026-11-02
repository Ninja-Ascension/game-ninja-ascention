CatalogueStorageTitleCell = class("CatalogueStorageTitleCellClass", Window)
CatalogueStorageTitleCell.__size = nil

local catalogue_storage_title_cell_create_terminal = {
    _name = "catalogue_storage_title_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CatalogueStorageTitleCell:new():init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(catalogue_storage_title_cell_create_terminal)
state_machine.init()

function CatalogueStorageTitleCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._title_index = 0
end

function CatalogueStorageTitleCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_catalogue_1 = ccui.Helper:seekWidgetByName(root, "Text_catalogue_1")
    Text_catalogue_1:setString(tipStringInfo_catalogue_info[self._title_index])
end

function CatalogueStorageTitleCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.recruit.catalogue_storage_t_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CatalogueStorageTitleCell.__size == nil then
        CatalogueStorageTitleCell.__size = root:getContentSize()
    end

    self:setContentSize(CatalogueStorageTitleCell.__size)
    if self._title_index ~= nil then
        self:onUpdateDraw()
    end
end

function CatalogueStorageTitleCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CatalogueStorageTitleCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.recruit.catalogue_storage_t_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function CatalogueStorageTitleCell:init(params)
    if params == nil then
        self._title_index = nil
        self:onInit()
    else
        self._title_index = params[1]
        if params[2] ~= nil and params[2] < 4 then
           self:onInit()
        end
    end
        self:setContentSize(CatalogueStorageTitleCell.__size)
    return self
end

function CatalogueStorageTitleCell:onExit()
    cacher.freeRef(config_csb.cells.recruit.catalogue_storage_t_cell, self.roots[1])
end