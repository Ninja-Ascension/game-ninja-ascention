----------------------------------------------------------------------------------------------------
-- 说明：坦克工厂坦克icon
-------------------------------------------------------------------------------------------------------
BuildUpTankFactoryTankIconCell = class("BuildUpTankFactoryTankIconCellClass", Window)
BuildUpTankFactoryTankIconCell.__size = nil

local build_up_tank_factory_tank_icon_cell_create_terminal = {
    _name = "build_up_tank_factory_tank_icon_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = BuildUpTankFactoryTankIconCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_factory_tank_icon_cell_create_terminal)
state_machine.init()

function BuildUpTankFactoryTankIconCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._tank_id = 0
    local function init_build_up_tank_factory_tank_icon_cell_terminal()
    end
    init_build_up_tank_factory_tank_icon_cell_terminal()           
end

function BuildUpTankFactoryTankIconCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_big_tank = ccui.Helper:seekWidgetByName(root,"Panel_big_tank")
    local tank_data = dms.element(dms["ship_mould"], self._tank_id)
    local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标

    Panel_big_tank:removeBackGroundImage()
    Panel_big_tank:setBackGroundImage(string.format(config_res.images.ui.props.big_tank, pic))
end

function BuildUpTankFactoryTankIconCell:setSelected()

end

function BuildUpTankFactoryTankIconCell:onEnterTransitionFinish()

end

function BuildUpTankFactoryTankIconCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_tank_factory_tab_3_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
    if BuildUpTankFactoryTankIconCell.__size == nil then
        BuildUpTankFactoryTankIconCell.__size = root:getContentSize()
    end
    
    self:onUpdateDraw()
end

function BuildUpTankFactoryTankIconCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_factory_tab_3_cell, self.roots[1])
end

function BuildUpTankFactoryTankIconCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpTankFactoryTankIconCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_factory_tab_3_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpTankFactoryTankIconCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_big_tank = ccui.Helper:seekWidgetByName(root,"Panel_big_tank")
    if Panel_big_tank ~= nil then
        Panel_big_tank:removeBackGroundImage()
    end
end

function BuildUpTankFactoryTankIconCell:init(params) 
    self._tank_id = params[1]
    self:onInit()
    self:setContentSize(BuildUpTankFactoryTankIconCell.__size)
end

