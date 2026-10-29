----------------------------------------------------------------------------------------------------
-- 说明：坦克工厂坦克
-------------------------------------------------------------------------------------------------------
BuildUpTankFactoryTankCell = class("BuildUpTankFactoryTankCellClass", Window)
BuildUpTankFactoryTankCell.__size = nil

local build_up_tank_factory_tank_cell_create_terminal = {
    _name = "build_up_tank_factory_tank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = BuildUpTankFactoryTankCell:new()
        local index = params[1]
        local from_type = params[2]
        local tank_info = params[3]
        cell:init(index, from_type, tank_info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_factory_tank_cell_create_terminal)
state_machine.init()

function BuildUpTankFactoryTankCell:ctor()
    self.super:ctor()
    self.roots = {}     

    -- var
    -- 排行索引
    self._index = 0

    self._select = false
    self._can_production = false        -- 是否可生产

    app.load("client.red_alert_time.build_up.BuildUpTankProduction")

    local function init_build_up_tank_factory_tank_cell_terminal()
        
        local build_up_tank_factory_tank_cell_click_terminal = {
            _name = "build_up_tank_factory_tank_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local tank_data = nil
                if cell._from_type < 0 then
                    tank_data = getShipByTemplateId(self._tank_info.tank_id)
                end
                state_machine.excute("build_up_tank_production_window_open", 0, {cell._from_type, cell._tank_info, cell._can_production, tank_data})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(build_up_tank_factory_tank_cell_click_terminal)       
        state_machine.init()
    end
    init_build_up_tank_factory_tank_cell_terminal()           
end

function BuildUpTankFactoryTankCell:onUpdateDraw()
    if self._index == 0 then
        return
    end

    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_tank_num = ccui.Helper:seekWidgetByName(root,"Text_tank_num")
    local Panel_tank_type = ccui.Helper:seekWidgetByName(root,"Panel_tank_type")
    local Text_tank_name = ccui.Helper:seekWidgetByName(root,"Text_tank_name")
    local Text_have_lv = ccui.Helper:seekWidgetByName(root,"Text_have_lv")
    local Image_num_bg = ccui.Helper:seekWidgetByName(root,"Image_num_bg")
    local Image_tank_rock = ccui.Helper:seekWidgetByName(root,"Image_tank_rock")

    local tank_data = dms.element(dms["ship_mould"], self._tank_info.tank_id)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
    local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标
    local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质
    local boatyard_level = dms.atoi(tank_data, ship_mould.boatyard_level)    -- 需要工厂等级
    local range = dms.atoi(tank_data, ship_mould.sign_msg)                   -- 攻击范围

    Text_tank_name:setString(tank_name)
    Text_tank_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

    local count = 0
    if self._tank_info.count ~= nil then
        count = self._tank_info.count
    else
        local tank_data = getShipByTemplateId(self._tank_info.tank_id)
        if tank_data ~= nil then
            count = tonumber(tank_data.current_count)
        end
    end

    Panel_tank_icon:removeBackGroundImage()
    Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
    Text_tank_num:setString(count)
    Panel_tank_type:removeBackGroundImage()
    Panel_tank_type:setBackGroundImage(string.format(config_res.images.ui.icon.icon, range + 114))

    local size = Image_num_bg:getContentSize()
    local len = string.len(""..count)
    local width = len * 10 + 10
    Image_num_bg:setContentSize(cc.size(width, size.height))

    if self._from_type > 0 then
        local cur_level = 0
        if self._from_type == 1 then    -- 坦克工厂1
            if _ED.home_build["9"] ~= nil then
                cur_level = _ED.home_build["9"].level
            end
        elseif self._from_type == 2 then    -- 坦克工厂2
            if _ED.home_build["10"] ~= nil then
                cur_level = _ED.home_build["10"].level
            end
        elseif self._from_type == 3 then    -- 改造工厂
            if _ED.home_build["9"] ~= nil then
                cur_level = _ED.home_build["9"].level
            end
            if _ED.home_build["10"] ~= nil 
                and cur_level < _ED.home_build["10"].level then
                cur_level = _ED.home_build["10"].level
            end
        end

        if boatyard_level <= cur_level then
            Text_have_lv:setVisible(false)
            self._can_production = true
        else
            Text_have_lv:setVisible(true)
            Text_have_lv:setString(string.format(red_alert_all_str[271], boatyard_level))
            self._can_production = false
        end
        if Image_tank_rock ~= nil then 
            if boatyard_level <= cur_level then
                Image_tank_rock:setVisible(false)
            else
                Image_tank_rock:setVisible(true)
            end
        end
    else
        Text_have_lv:setVisible(false)
        self._can_production = false
        if Image_tank_rock ~= nil then 
            Image_tank_rock:setVisible(false)
        end
    end
end

function BuildUpTankFactoryTankCell:setSelected()

end

function BuildUpTankFactoryTankCell:onEnterTransitionFinish()

end

function BuildUpTankFactoryTankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_tank_factory_cell_1, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if BuildUpTankFactoryTankCell.__size == nil then
        BuildUpTankFactoryTankCell.__size = size
    end

    -- 点击响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_tank_icon"), nil, 
    {
        terminal_name = "build_up_tank_factory_tank_cell_click", 
        terminal_state = 0,
        cell = self,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BuildUpTankFactoryTankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_factory_cell_1, self.roots[1])

end

function BuildUpTankFactoryTankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpTankFactoryTankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_factory_cell_1, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpTankFactoryTankCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_tank_num = ccui.Helper:seekWidgetByName(root,"Text_tank_num")
    local Panel_tank_type = ccui.Helper:seekWidgetByName(root,"Panel_tank_type")
    local Text_tank_name = ccui.Helper:seekWidgetByName(root,"Text_tank_name")
    local Text_have_lv = ccui.Helper:seekWidgetByName(root,"Text_have_lv")

    if Panel_tank_icon ~= nil then
        Panel_tank_icon:removeBackGroundImage()
        Panel_tank_type:removeBackGroundImage()
        Text_tank_name:setString("")
        Text_tank_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_tank_num:setString("")
        Text_have_lv:setString("")
    end
end

function BuildUpTankFactoryTankCell:init(index, from_type, tank_info) 
    self._index = index
    self._from_type = from_type
    self._tank_info = tank_info
    self:onInit()
    self:setContentSize(BuildUpTankFactoryTankCell.__size)
end

