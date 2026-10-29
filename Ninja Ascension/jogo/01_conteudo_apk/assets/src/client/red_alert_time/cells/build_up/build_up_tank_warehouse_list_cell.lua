----------------------------------------------------------------------------------------------------
-- 说明：坦克仓库列表cell
-------------------------------------------------------------------------------------------------------
BuildUpTankWarehouseListCell = class("BuildUpTankWarehouseListCellClass", Window)
BuildUpTankWarehouseListCell.__size = nil

local build_up_tank_warehouse_list_cell_create_terminal = {
    _name = "build_up_tank_warehouse_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = BuildUpTankWarehouseListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_warehouse_list_cell_create_terminal)
state_machine.init()

function BuildUpTankWarehouseListCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0

    local function init_build_up_tank_warehouse_list_cell_terminal()
        local build_up_tank_warehouse_list_cell_update_list_info_terminal = {
            _name = "build_up_tank_warehouse_list_cell_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:updateListInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
  
        state_machine.add(build_up_tank_warehouse_list_cell_update_list_info_terminal)    
        state_machine.init()
    end
    init_build_up_tank_warehouse_list_cell_terminal()         
end

function BuildUpTankWarehouseListCell:updateListInfo()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    local items = ListView_1:getItems()
    for k, v in pairs(items) do
        state_machine.excute("build_up_tank_warehouse_cell_update_draw", 0, v)
    end
end

function BuildUpTankWarehouseListCell:onUpdateDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()

    for k, v in pairs(self._ship_list) do
        local cell = state_machine.excute("build_up_tank_warehouse_cell_create",0, {k, v.ship_mould_id})
        ListView_1:addChild(cell)
    end

    ListView_1:requestRefreshView()
end

function BuildUpTankWarehouseListCell:onEnterTransitionFinish()

end

function BuildUpTankWarehouseListCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_tank_warehouse_cell_0, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if BuildUpTankWarehouseListCell.__size == nil then
        BuildUpTankWarehouseListCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function BuildUpTankWarehouseListCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_warehouse_cell_0, self.roots[1])
end

function BuildUpTankWarehouseListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpTankWarehouseListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_warehouse_cell_0, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpTankWarehouseListCell:clearUIInfo()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    if ListView_1 ~= nil then
        ListView_1:removeAllItems()
    end
end

function BuildUpTankWarehouseListCell:init(params)
    self._index = params[1]
    self._ship_list = params[2]

    if self._index <= 7 then
       self:onInit()
    end
    self:setContentSize(BuildUpTankWarehouseListCell.__size)
end

