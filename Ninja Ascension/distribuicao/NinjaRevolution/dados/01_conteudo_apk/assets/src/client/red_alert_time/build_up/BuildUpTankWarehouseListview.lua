--------------------------------------------------------------------------------------------------------------
--  说明：坦克仓库列表
--------------------------------------------------------------------------------------------------------------
BuildUpTankWarehouseListview = class("BuildUpTankWarehouseListviewClass", Window)

--打开界面
local build_up_tank_warehouse_listview_window_open_terminal = {
    _name = "build_up_tank_warehouse_listview_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = BuildUpTankWarehouseListview:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_warehouse_listview_window_open_terminal)
state_machine.init()

function BuildUpTankWarehouseListview:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    local function init_build_up_tank_warehouse_listview_terminal()
        local build_up_tank_warehouse_listview_show_terminal = {
            _name = "build_up_tank_warehouse_listview_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_warehouse_listview_hide_terminal = {
            _name = "build_up_tank_warehouse_listview_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_warehouse_listview_update_terminal = {
            _name = "build_up_tank_warehouse_listview_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:updateListInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_tank_warehouse_listview_show_terminal)   
        state_machine.add(build_up_tank_warehouse_listview_hide_terminal)
        state_machine.add(build_up_tank_warehouse_listview_update_terminal)
        state_machine.init()
    end
    init_build_up_tank_warehouse_listview_terminal()
end

function BuildUpTankWarehouseListview:updateListInfo()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    local items = ListView_1:getItems()
    for k, v in pairs(items) do
        state_machine.excute("build_up_tank_warehouse_list_cell_update_list_info", 0, {v})
    end
end

function BuildUpTankWarehouseListview:onUpdateDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()

    local result = {}
    local show_quality = self._index - 1
    for i = 1, 100 do
        local order = dms.int(dms["ship_mould"], i, ship_mould.base_mould_priority)        -- 排序
        local quality = dms.int(dms["ship_mould"], i, ship_mould.capacity)     -- 品级
        local ship_type = dms.int(dms["ship_mould"], i, ship_mould.camp_preference)     -- 兵种
        if ship_type > 0 and order > 0 and show_quality == quality then
            local info = {}
            info.ship_mould_id = i
            info.order = order
            table.insert(result, info)
        end
    end

    local function sortFunction(a, b)
        return a.order < b.order
    end
    table.sort(result, sortFunction)

    local ship_list = {}
    local count = math.ceil(#result / 4)
    for i = 1, count do
        local index = (i - 1) * 4
        local ships = {}
        for j = 1, 4 do
            local info = result[j + index]
            if info ~= nil then
                table.insert(ships, info)
            end
        end
        table.insert(ship_list, ships)
    end

    for k, v in pairs(ship_list) do
        local cell = state_machine.excute("build_up_tank_warehouse_list_cell_create",0, {k, v})
        ListView_1:addChild(cell)
    end

    ListView_1:requestRefreshView()
    self._list_view = ListView_1
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function BuildUpTankWarehouseListview:onUpdate( dt )
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function BuildUpTankWarehouseListview:onInit(params)
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_warehouse_0)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    self:onUpdateDraw()
end

function BuildUpTankWarehouseListview:onEnterTransitionFinish()

end

function BuildUpTankWarehouseListview:init(params)
    self._rootWindows = params[1]
    self._index = params[2]
    self:onInit()
    return self
end

function BuildUpTankWarehouseListview:onExit()

end