----------------------------------------------------------------------------------------------------
-- 说明：坦克工厂资源icon
-------------------------------------------------------------------------------------------------------
BuildUpTankFactoryResIconCell = class("BuildUpTankFactoryResIconCellClass", Window)
BuildUpTankFactoryResIconCell.__size = nil

local build_up_tank_factory_res_icon_cell_create_terminal = {
    _name = "build_up_tank_factory_res_icon_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = BuildUpTankFactoryResIconCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_factory_res_icon_cell_create_terminal)
state_machine.init()

function BuildUpTankFactoryResIconCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._from_type = 0
    self._index = 0
    self._tank_id = 0
    self._select_num = 0

    local function init_build_up_tank_factory_res_icon_cell_terminal()
        local build_up_tank_factory_res_icon_cell_click_terminal = {
            _name = "build_up_tank_factory_res_icon_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local index = cell._index
                local resource_type = {33,41,42,43}
                if cell._from_type == 1 or cell._from_type == 2 then        -- 坦克工厂
                    local info = _ED.base_build_shop_info["1"][""..resource_type[index]]
                    state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                else
                    local info = _ED.base_build_shop_info["1"][""..resource_type[index-1]]
                    state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_tank_factory_res_icon_cell_click_terminal)       
        state_machine.init()
    end
    init_build_up_tank_factory_res_icon_cell_terminal()           
end

function BuildUpTankFactoryResIconCell:updateSelectNum( tankId, index )
    self._tank_id = tankId
    self._select_num = index
    self:onUpdateDraw()
end

function BuildUpTankFactoryResIconCell:onUpdateDraw()
    if self._tank_id == 0 then
        self:setVisible(false)
        return
    end
    self:setVisible(true)
    local root = self.roots[1]
    local Panel_res_icon_4 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_4")
    local Text_demand_n_4 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_4")

    local tank_data = dms.element(dms["ship_mould"], self._tank_id)
    local tank_grow_id = 0
    if self._from_type == 1 or self._from_type == 2 then        -- 生产
        tank_grow_id = dms.atoi(tank_data, ship_mould.ship_name)
    elseif self._from_type == 3 then                            -- 改造
        tank_grow_id = dms.atoi(tank_data, ship_mould.required_material_id)
    end

    if tank_grow_id == 0 then
        return
    end
    local tank_grow_data = dms.element(dms["ship_grow_requirement"], tank_grow_id)

    if self._from_type == 1 or self._from_type == 2 then        -- 生产
        if self._index == 1 then
            local need_iron = dms.atoi(tank_grow_data, ship_grow_requirement.need_iron)
            -- 铁矿
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_iron_ore)
            need_iron = need_iron * self._select_num
            Text_demand_n_4:setString(exChangeNumToString(need_iron).."/"..exChangeNumToString(_ED.user_info.user_iron))

            -- 资源不足时显示红色
            if tonumber(need_iron) > tonumber(_ED.user_info.user_iron) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        elseif self._index == 2 then
            local need_oil = dms.atoi(tank_grow_data, ship_grow_requirement.need_oil)
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_petroeum)
            need_oil = need_oil * self._select_num
            Text_demand_n_4:setString(exChangeNumToString(need_oil).."/"..exChangeNumToString(_ED.user_info.oil_field))

            -- 资源不足时显示红色
            if tonumber(need_oil) > tonumber(_ED.user_info.oil_field) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        elseif self._index == 3 then
            local need_lead = dms.atoi(tank_grow_data, ship_grow_requirement.need_lead)
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_lead_ore)
            need_lead = need_lead * self._select_num
            Text_demand_n_4:setString(exChangeNumToString(need_lead).."/"..exChangeNumToString(_ED.user_info.exploits))

            -- 资源不足时显示红色
            if tonumber(need_lead) > tonumber(_ED.user_info.exploits) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        elseif self._index == 4 then
            local need_tita = dms.atoi(tank_grow_data, ship_grow_requirement.need_tita)
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_titanium_ore)
            need_tita = need_tita * self._select_num
            Text_demand_n_4:setString(exChangeNumToString(need_tita).."/"..exChangeNumToString(_ED.user_info.tiger_shaped))

            -- 资源不足时显示红色
            if tonumber(need_tita) > tonumber(_ED.user_info.tiger_shaped) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        end
    elseif self._from_type == 3 then        -- 改造
        if self._index == 1 then
            local tank_update_id = dms.atoi(tank_grow_data, ship_grow_requirement.need_ship_mould1)
            local tank_update_count = dms.atoi(tank_grow_data, ship_grow_requirement.need_ship_mould1_count)

            local Panel_res_infor_interactive_4 = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_4")
            Panel_res_infor_interactive_4:setTouchEnabled(false)

            local pic = dms.int(dms["ship_mould"], tank_update_id, ship_mould.All_icon)                    -- 图标
            Panel_res_icon_4:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))

            tank_update_count = tank_update_count * self._select_num
            local have_tank_num = 0
            local tank_data = getShipByTemplateId(tank_update_id)
            if tank_data ~= nil then
                have_tank_num = tonumber(tank_data.current_count)
            end
            Text_demand_n_4:setString(exChangeNumToString(tank_update_count).."/"..exChangeNumToString(have_tank_num))

            -- 资源不足时显示红色
            if tonumber(self._select_num) > tonumber(have_tank_num) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        elseif self._index == 2 then
            local need_iron = dms.atoi(tank_grow_data, ship_grow_requirement.need_iron)
            -- 铁矿
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_iron_ore)
            need_iron = need_iron * self._select_num
            Text_demand_n_4:setString(exChangeNumToString(need_iron).."/"..exChangeNumToString(_ED.user_info.user_iron))

            -- 资源不足时显示红色
            if tonumber(need_iron) > tonumber(_ED.user_info.user_iron) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        elseif self._index == 3 then
            local need_oil = dms.atoi(tank_grow_data, ship_grow_requirement.need_oil)
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_petroeum)
            need_oil = need_oil * self._select_num
            Text_demand_n_4:setString(exChangeNumToString(need_oil).."/"..exChangeNumToString(_ED.user_info.oil_field))

            -- 资源不足时显示红色
            if tonumber(need_oil) > tonumber(_ED.user_info.oil_field) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        elseif self._index == 4 then
            local need_lead = dms.atoi(tank_grow_data, ship_grow_requirement.need_lead)
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_lead_ore)
            need_lead = need_lead * self._select_num
            Text_demand_n_4:setString(exChangeNumToString(need_lead).."/"..exChangeNumToString(_ED.user_info.exploits))

            -- 资源不足时显示红色
            if tonumber(need_lead) > tonumber(_ED.user_info.exploits) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        elseif self._index == 5 then
            local need_tita = dms.atoi(tank_grow_data, ship_grow_requirement.need_tita)
            Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_titanium_ore)
            need_tita = need_tita * self._select_num
            Text_demand_n_4:setString(exChangeNumToString(need_tita).."/"..exChangeNumToString(_ED.user_info.tiger_shaped))

            -- 资源不足时显示红色
            if tonumber(need_tita) > tonumber(_ED.user_info.tiger_shaped) then
                Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            else
                Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
        end
    end
end

function BuildUpTankFactoryResIconCell:setSelected()

end

function BuildUpTankFactoryResIconCell:onEnterTransitionFinish()

end

function BuildUpTankFactoryResIconCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_cell_4_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
    if BuildUpTankFactoryResIconCell.__size == nil then
        BuildUpTankFactoryResIconCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_4"), nil, 
    {
        terminal_name = "build_up_tank_factory_res_icon_cell_click", 
        terminal_state = 0,
        cell = self,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BuildUpTankFactoryResIconCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_cell_4_cell, self.roots[1])
end

function BuildUpTankFactoryResIconCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpTankFactoryResIconCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_cell_4_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpTankFactoryResIconCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_res_icon_4 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_4")
    local Text_demand_n_4 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_4")
    if Panel_res_icon_4 ~= nil then
        Panel_res_icon_4:removeBackGroundImage()
        Text_demand_n_4:setString("")
    end
end

function BuildUpTankFactoryResIconCell:init(params) 
    self._index = params[1]
    self._from_type = params[2]
    self._tank_id = params[3]
    self._select_num = params[4]
    self:onInit()
    self:setContentSize(BuildUpTankFactoryResIconCell.__size)
end

