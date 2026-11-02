------------------------------------
-- 坦克生产，制造消耗列表
------------------------------------
BuildUpTankProductionProcCell = class("BuildUpTankProductionProcCellClass", Window)

local build_up_tank_production_proc_cell_create_terminal = {
    _name = "build_up_tank_production_proc_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local from_type = params[1]
        local tank_info = params[2]
        local cell = BuildUpTankProductionProcCell:new()
        cell:init(from_type, tank_info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_tank_production_proc_cell_create_terminal)
state_machine.init()

function BuildUpTankProductionProcCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 1:坦克工厂1,2：坦克工厂2,3：改造工厂, 4：制造工厂
    self._from_type = from_type
    -- 
    self._tank_info = tank_info
    -- 生产数量
    self._select_num = 0

    -- load lua file
    app.load("client.red_alert_time.build_up.BuildUpHeadquarters")
    app.load("client.red_alert_time.props.PropsUse")
    local function init_build_up_tank_production_proc_cell_terminal()
        local build_up_tank_production_proc_cell_open_window_terminal = {
            _name = "build_up_tank_production_proc_cell_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local index = params._datas.index
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
        
        local build_up_tank_production_proc_cell_update_terminal = {
            _name = "build_up_tank_production_proc_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params ~= nil then
                    instance._select_num = params
                end
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(build_up_tank_production_proc_cell_update_terminal)
        state_machine.add(build_up_tank_production_proc_cell_open_window_terminal)
        state_machine.init()
    end

    init_build_up_tank_production_proc_cell_terminal()
end

-- 升级需求
function BuildUpTankProductionProcCell:updateDraw()
    local root = self.roots[1]
    for i=1,5 do
        local Panel_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_"..i)
        Panel_res_icon:removeBackGroundImage()
    end
    
    local tank_data = dms.element(dms["ship_mould"], self._tank_info.tank_id)
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
    local tank_update_id = dms.atoi(tank_grow_data, ship_grow_requirement.need_ship_mould1)             -- 改造需要兵种
    local tank_update_count = dms.atoi(tank_grow_data, ship_grow_requirement.need_ship_mould1_count)    -- 改造需要兵种数量
    local need_iron = dms.atoi(tank_grow_data, ship_grow_requirement.need_iron)                         -- 需要铁矿
    local need_oil = dms.atoi(tank_grow_data, ship_grow_requirement.need_oil)                           -- 需要石油
    local need_lead = dms.atoi(tank_grow_data, ship_grow_requirement.need_lead)                         -- 需要铅矿
    local need_tita = dms.atoi(tank_grow_data, ship_grow_requirement.need_tita)                         -- 需要钛矿
    local need_time = dms.atoi(tank_grow_data, ship_grow_requirement.need_time)                         -- 需要时间

    if self._from_type == 1 or self._from_type == 2 then        -- 生产
        for i=1,4 do
            local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_"..i)
            local Panel_res_infor_interactive = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_"..i)
            local Image_list_bg = ccui.Helper:seekWidgetByName(root,"Image_list_bg_"..i)
            local Panel_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_"..i)
            local Button_add = ccui.Helper:seekWidgetByName(root,"Button_add_"..i)
            Text_stye_name:setString(tipStringInfo_build_up[i+1])
            Panel_res_infor_interactive:setVisible(true)
            Image_list_bg:setVisible(true)
            Panel_res_icon:setVisible(true)
            Button_add:setVisible(true)
        end

        local Panel_res_infor_interactive_5 = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_5")
        Panel_res_infor_interactive_5:setVisible(false)

        -- 铁矿
        local Text_stye_name_1 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_1")
        local Panel_res_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_1")
        Panel_res_icon_1:setBackGroundImage(config_res.images.ui.home.icon_iron_ore)
        local Text_demand_n_1 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_1")
        need_iron = need_iron * self._select_num
        Text_demand_n_1:setString(exChangeNumToString(need_iron))
        local Text_have_n_1 = ccui.Helper:seekWidgetByName(root,"Text_have_n_1")
        Text_have_n_1:setString(exChangeNumToString(_ED.user_info.user_iron))

        -- 资源不足时显示红色
        if tonumber(need_iron) > tonumber(_ED.user_info.user_iron) then
            Text_demand_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_1:setString("×"..exChangeNumToString(_ED.user_info.user_iron))
            Text_stye_name_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        -- 石油
        local Text_stye_name_2 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_2")
        local Panel_res_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_2")
        Panel_res_icon_2:setBackGroundImage(config_res.images.ui.home.icon_petroeum)
        local Text_demand_n_2 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_2")
        need_oil = need_oil * self._select_num
        Text_demand_n_2:setString(exChangeNumToString(need_oil))
        local Text_have_n_2 = ccui.Helper:seekWidgetByName(root,"Text_have_n_2")
        Text_have_n_2:setString(exChangeNumToString(_ED.user_info.oil_field))

        -- 资源不足时显示红色
        if tonumber(need_oil) > tonumber(_ED.user_info.oil_field) then
            Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_2:setString("×"..exChangeNumToString(_ED.user_info.oil_field))
            Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        -- 铅矿
        local Text_stye_name_3 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_3")
        local Panel_res_icon_3 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_3")
        Panel_res_icon_3:setBackGroundImage(config_res.images.ui.home.icon_lead_ore)
        local Text_demand_n_3 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_3")
        need_lead = need_lead * self._select_num
        Text_demand_n_3:setString(exChangeNumToString(need_lead))
        local Text_have_n_3 = ccui.Helper:seekWidgetByName(root,"Text_have_n_3")
        Text_have_n_3:setString(exChangeNumToString(_ED.user_info.exploits))

        -- 资源不足时显示红色
        if tonumber(need_lead) > tonumber(_ED.user_info.exploits) then
            Text_demand_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_3:setString("×"..exChangeNumToString(_ED.user_info.exploits))
            Text_stye_name_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        -- 钛矿
        local Text_stye_name_4 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_4")
        Text_stye_name_4:setString(tipStringInfo_build_up[7])
        local Panel_res_icon_4 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_4")
        Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_titanium_ore)
        local Text_demand_n_4 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_4")
        need_lead = need_tita * self._select_num
        Text_demand_n_4:setString(exChangeNumToString(need_lead))
        local Text_have_n_4 = ccui.Helper:seekWidgetByName(root,"Text_have_n_4")
        Text_have_n_4:setString(exChangeNumToString(_ED.user_info.tiger_shaped))

        -- 资源不足时显示红色
        if tonumber(need_lead) > tonumber(_ED.user_info.tiger_shaped) then
            Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_4:setString("×"..exChangeNumToString(_ED.user_info.tiger_shaped))
            Text_stye_name_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end
    elseif self._from_type == 3 then        -- 改造
        for i=1,5 do
            local Text_stye_name = ccui.Helper:seekWidgetByName(root,"Text_stye_name_"..i)
            local Panel_res_infor_interactive = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_"..i)
            local Image_list_bg = ccui.Helper:seekWidgetByName(root,"Image_list_bg_"..i)
            local Panel_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_"..i)
            local Button_add = ccui.Helper:seekWidgetByName(root,"Button_add_"..i)
            Text_stye_name:setString(tipStringInfo_build_up[i])
            Panel_res_infor_interactive:setVisible(true)
            Image_list_bg:setVisible(true)
            Panel_res_icon:setVisible(true)
            Button_add:setVisible(true)
        end

        local Panel_res_infor_interactive_1 = ccui.Helper:seekWidgetByName(root,"Panel_res_infor_interactive_1")
        Panel_res_infor_interactive_1:setTouchEnabled(false)

        local tank_name = dms.string(dms["ship_mould"], tank_update_id, ship_mould.captain_name)        -- 名称
        local pic = dms.int(dms["ship_mould"], tank_update_id, ship_mould.All_icon)                    -- 图标

        local Button_add_1 = ccui.Helper:seekWidgetByName(root,"Button_add_1")
        Button_add_1:setVisible(false)
        local Text_stye_name_1 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_1")
        Text_stye_name_1:setString(tank_name)
        local Panel_tank_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon_1")
        Panel_tank_icon_1:removeBackGroundImage()
        Panel_tank_icon_1:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
        local Text_demand_n_1 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_1")
        tank_update_count = tank_update_count * self._select_num
        Text_demand_n_1:setString(exChangeNumToString(tank_update_count))
        local Text_have_n_1 = ccui.Helper:seekWidgetByName(root,"Text_have_n_1")
        local have_tank_num = 0
        local tank_data = getShipByTemplateId(tank_update_id)
        if tank_data ~= nil then
            have_tank_num = tonumber(tank_data.current_count)
        end
        Text_have_n_1:setString(exChangeNumToString(have_tank_num))

        -- 资源不足时显示红色
        if tonumber(self._select_num) > tonumber(have_tank_num) then
            Text_demand_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_1:setString("×"..exChangeNumToString(have_tank_num))
            Text_stye_name_1:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        -- 铁矿
        local Text_stye_name_2 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_2")
        local Panel_res_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_2")
        Panel_res_icon_2:setBackGroundImage(config_res.images.ui.home.icon_iron_ore)
        local Text_demand_n_2 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_2")
        need_iron = need_iron * self._select_num
        Text_demand_n_2:setString(exChangeNumToString(need_iron))
        local Text_have_n_2 = ccui.Helper:seekWidgetByName(root,"Text_have_n_2")
        Text_have_n_2:setString(exChangeNumToString(_ED.user_info.user_iron))

        -- 资源不足时显示红色
        if tonumber(need_iron) > tonumber(_ED.user_info.user_iron) then
            Text_demand_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_2:setString("×"..exChangeNumToString(_ED.user_info.user_iron))
            Text_stye_name_2:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        -- 石油
        local Text_stye_name_3 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_3")
        local Panel_res_icon_3 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_3")
        Panel_res_icon_3:setBackGroundImage(config_res.images.ui.home.icon_petroeum)
        local Text_demand_n_3 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_3")
        need_oil = need_oil * self._select_num
        Text_demand_n_3:setString(exChangeNumToString(need_oil))
        local Text_have_n_3 = ccui.Helper:seekWidgetByName(root,"Text_have_n_3")
        Text_have_n_3:setString(exChangeNumToString(_ED.user_info.oil_field))

        -- 资源不足时显示红色
        if tonumber(need_oil) > tonumber(_ED.user_info.oil_field) then
            Text_demand_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_3:setString("×"..exChangeNumToString(_ED.user_info.oil_field))
            Text_stye_name_3:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_3:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        -- 铅矿
        local Text_stye_name_4 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_4")
        local Panel_res_icon_4 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_4")
        Panel_res_icon_4:setBackGroundImage(config_res.images.ui.home.icon_lead_ore)
        local Text_demand_n_4 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_4")
        need_lead = need_lead * self._select_num
        Text_demand_n_4:setString(exChangeNumToString(need_lead))
        local Text_have_n_4 = ccui.Helper:seekWidgetByName(root,"Text_have_n_4")
        Text_have_n_4:setString(exChangeNumToString(_ED.user_info.exploits))

        -- 资源不足时显示红色
        if tonumber(need_lead) > tonumber(_ED.user_info.exploits) then
            Text_demand_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_4:setString("×"..exChangeNumToString(_ED.user_info.exploits))
            Text_stye_name_4:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_4:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        -- 钛矿
        local Text_stye_name_5 = ccui.Helper:seekWidgetByName(root,"Text_stye_name_5")
        Text_stye_name_5:setString(tipStringInfo_build_up[7])
        local Panel_res_icon_5 = ccui.Helper:seekWidgetByName(root,"Panel_res_icon_5")
        Panel_res_icon_5:setBackGroundImage(config_res.images.ui.home.icon_titanium_ore)
        local Text_demand_n_5 = ccui.Helper:seekWidgetByName(root,"Text_demand_n_5")
        need_lead = need_tita * self._select_num
        Text_demand_n_5:setString(exChangeNumToString(need_lead))
        local Text_have_n_5 = ccui.Helper:seekWidgetByName(root,"Text_have_n_5")
        Text_have_n_5:setString(exChangeNumToString(_ED.user_info.tiger_shaped))

        -- 资源不足时显示红色
        if tonumber(need_lead) > tonumber(_ED.user_info.tiger_shaped) then
            Text_demand_n_5:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_5:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
            Text_have_n_5:setString("×"..exChangeNumToString(_ED.user_info.exploits))
            Text_stye_name_5:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        else
            Text_demand_n_5:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_have_n_5:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_stye_name_5:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

    end
end


function BuildUpTankProductionProcCell:onUpdate(dt)
   
end

function BuildUpTankProductionProcCell:onInit()
    local csbItem = csb.createNode(string.format(config_csb.cells.build_up.build_up_cell, 1))
    local csbRoot = csbItem:getChildByName("root")
    local root = csbRoot:getChildByName("Panel_high_lv_box")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root) 

    -- 对应资源点击响应
    for i=1,5 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_res_infor_interactive_"..i), nil, 
        {
            terminal_name = "build_up_tank_production_proc_cell_open_window", 
            terminal_state = 0, 
            cell = self, 
            index = i, 
            touch_black = true,
        }, nil, 1)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_"..i), nil, 
        {
            terminal_name = "build_up_tank_production_proc_cell_open_window", 
            terminal_state = 0, 
            cell = self, 
            index = i,  
            touch_black = true,
        }, nil, 1)
    end
    

    self:updateDraw()
end

function BuildUpTankProductionProcCell:onEnterTransitionFinish()
end

function BuildUpTankProductionProcCell:init(from_type, tank_info)
    self._from_type = from_type
    self._tank_info = tank_info
    
    self:onInit()
end

function BuildUpTankProductionProcCell:onExit()

end