----------------------------------------------------------------------------------------------------
-- 说明：坦克仓库列表cell
-------------------------------------------------------------------------------------------------------
BuildUpTankWarehouseCell = class("BuildUpTankWarehouseCellClass", Window)
BuildUpTankWarehouseCell.__size = nil

local build_up_tank_warehouse_cell_create_terminal = {
    _name = "build_up_tank_warehouse_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = BuildUpTankWarehouseCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_warehouse_cell_create_terminal)
state_machine.init()

function BuildUpTankWarehouseCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._ship_mould_id = 0

    local function init_build_up_tank_warehouse_cell_terminal()
        local build_up_tank_warehouse_cell_look_info_terminal = {
            _name = "build_up_tank_warehouse_cell_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local info = {}
                info.tank_id = cell._ship_mould_id
                local ship = getShipByTemplateId(cell._ship_mould_id)
                state_machine.excute("build_up_tank_production_window_open", 0, {1, info, false, ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_warehouse_cell_update_draw_terminal = {
            _name = "build_up_tank_warehouse_cell_update_draw",
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
 
        state_machine.add(build_up_tank_warehouse_cell_look_info_terminal)    
        state_machine.add(build_up_tank_warehouse_cell_update_draw_terminal)    
        state_machine.init()
    end
    init_build_up_tank_warehouse_cell_terminal()         
end

function BuildUpTankWarehouseCell:onUpdateDraw()
    local root = self.roots[1]
    local Sprite_tank_icon = root:getChildByName("Sprite_tank_icon")
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_res_name = ccui.Helper:seekWidgetByName(root,"Text_res_name")
    local Text_have = ccui.Helper:seekWidgetByName(root,"Text_have")

    Panel_tank_icon:removeBackGroundImage()
    Text_res_name:setString("")
    Text_have:setString("")

    local tank_data = dms.element(dms["ship_mould"], self._ship_mould_id)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
    local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标
    local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质

    local count = 0
    local ship_data = getShipByTemplateId(self._ship_mould_id)
    if ship_data ~= nil then
        count = tonumber(ship_data.current_count)
    end

    Sprite_tank_icon:setTexture(string.format(config_res.images.ui.props.props, pic))

    if count > 0 then
        Text_have:setString(count)
        Text_res_name:setString(tank_name)
        Text_res_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
        display:ungray(Sprite_tank_icon)
        Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, 200 + quality))
        root:setTouchEnabled(true)
    else
        display:gray(Sprite_tank_icon)
        Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, 200))
        root:setTouchEnabled(false)
    end
end

function BuildUpTankWarehouseCell:onEnterTransitionFinish()

end

function BuildUpTankWarehouseCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_tank_warehouse_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if BuildUpTankWarehouseCell.__size == nil then
        BuildUpTankWarehouseCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "build_up_tank_warehouse_cell_look_info", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)

    self:onUpdateDraw()
end

function BuildUpTankWarehouseCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_warehouse_cell, self.roots[1])
end

function BuildUpTankWarehouseCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpTankWarehouseCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_warehouse_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpTankWarehouseCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Sprite_tank_icon = root:getChildByName("Sprite_tank_icon")
    local Text_res_name = ccui.Helper:seekWidgetByName(root,"Text_res_name")
    local Text_have = ccui.Helper:seekWidgetByName(root,"Text_have")

    if Panel_tank_icon ~= nil then
        Panel_tank_icon:removeBackGroundImage()
        display:ungray(Sprite_tank_icon)
        Text_res_name:setString("")
        Text_have:setString("")
    end
end

function BuildUpTankWarehouseCell:init(params)
    self._index = params[1]
    self._ship_mould_id = params[2]

    self:onInit()
    self:setContentSize(BuildUpTankWarehouseCell.__size)
end

