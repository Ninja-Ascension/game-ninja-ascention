--------------------------------------------------------------------------------------------------------------
--  坦克生产生产页
--------------------------------------------------------------------------------------------------------------
BuildUpTankProductionProcEx = class("BuildUpTankProductionProcExClass", Window)

local build_up_tank_production_proc_ex_window_open_terminal = {
    _name = "build_up_tank_production_proc_ex_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = BuildUpTankProductionProcEx:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_production_proc_ex_window_open_terminal)
state_machine.init()

function BuildUpTankProductionProcEx:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._from_type = 0             -- 1：坦克工厂1,2：坦克工厂2,3：改造工厂
    self._tank_id = 0
    self._select_num = 0            -- 选择生产数量
    self._max_select_num = 100      -- 可选择最大生产数量
    self._current_silder = 100      -- 选择生产数量百分比
    self._need_time = 0             -- 生产一个单位所需时间

    self._list_view_size = nil

    app.load("client.red_alert_time.cells.build_up.build_up_tank_production_proc_cell")
    app.load("client.red_alert_time.cells.build_up.build_up_tank_reform_proc_cell")
    app.load("client.red_alert_time.cells.build_up.build_up_tank_factory_res_icon_cell")

    local function init_build_up_tank_production_proc_ex_terminal()
        -- 添加生产或改造数量
        local build_up_tank_production_proc_ex_change_num_add_terminal = {
            _name = "build_up_tank_production_proc_ex_change_num_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num + 1
                if select_num > instance._max_select_num then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 减少生产或改造数量
        local build_up_tank_production_proc_ex_change_num_mimus_terminal = {
            _name = "build_up_tank_production_proc_ex_change_num_mimus",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num - 1
                if select_num < 0 then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 滑块选择
        local build_up_tank_production_proc_ex_update_slider_terminal = {
            _name = "build_up_tank_production_proc_ex_update_slider",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local select_num = math.ceil(tonumber(params[2]) * params[1]._max_select_num / 100)
                params[1]:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 确定生产
        local build_up_tank_production_proc_ex_sure_product_terminal = {
            _name = "build_up_tank_production_proc_ex_sure_product",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(instance._from_type) == 3 and tonumber(_ED.home_build["11"].level) <= 0 then
                    TipDlg.drawTextDailog(red_alert_time_str[7])
                    return
                end
                if instance._select_num == 0 then
                    return
                end

                if instance:checkMaxProductionCount() == false then 
                    TipDlg.drawTextDailog(red_alert_all_str[306])
                    return
                end

                local factory_type = instance._from_type - 1
                local build_id = instance._from_type + 8
                local select_num = instance._select_num
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        TipDlg.drawTextDailog(red_alert_all_str[286])
                        state_machine.excute("home_map_update_prodcution_state", 0, {build_id})
                        state_machine.excute("build_up_tank_production_window_close",0,"")
                        state_machine.excute("build_up_tank_factory_in_production_update_draw",0,"")
                        -- state_machine.excute("build_up_reform_factory_production_update_draw",0,"")
                        state_machine.excute("build_up_tank_factory_change_page",0,{_datas = {index = 3}})
                        state_machine.excute("build_up_reform_factory_change_page",0,{_datas = {index = 3}})
                        checkPlayEffect(35)
                    end
                end
                protocol_command.factory_product.param_list = ""..factory_type.."\r\n"..instance._tank_id.."\r\n"..instance._select_num
                NetworkManager:register(protocol_command.factory_product.code, nil, nil, nil, instance, responseCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local build_up_tank_production_proc_ex_update_draw_terminal = {
            _name = "build_up_tank_production_proc_ex_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_production_proc_ex_update_tank_id_terminal = {
            _name = "build_up_tank_production_proc_ex_update_tank_id",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._tank_id = params
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_production_proc_ex_show_terminal = {
            _name = "build_up_tank_production_proc_ex_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_production_proc_ex_hide_terminal = {
            _name = "build_up_tank_production_proc_ex_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_tank_production_proc_ex_change_num_add_terminal)
        state_machine.add(build_up_tank_production_proc_ex_change_num_mimus_terminal)
        state_machine.add(build_up_tank_production_proc_ex_update_slider_terminal)
        state_machine.add(build_up_tank_production_proc_ex_sure_product_terminal)
        state_machine.add(build_up_tank_production_proc_ex_update_draw_terminal)
        state_machine.add(build_up_tank_production_proc_ex_update_tank_id_terminal)
        state_machine.add(build_up_tank_production_proc_ex_show_terminal)
        state_machine.add(build_up_tank_production_proc_ex_hide_terminal)
        state_machine.init()
    end
    init_build_up_tank_production_proc_ex_terminal()
end

function BuildUpTankProductionProcEx:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end

    if self._max_select_num == 0 then
        self:updateSliderInfo(100)
    else
        local percent = math.floor(self._select_num * 100 / self._max_select_num)
        self:updateSliderInfo(percent)
    end

    local root = self.roots[1]
    for k,v in pairs(ccui.Helper:seekWidgetByName(root, "ListView_demand"):getItems()) do
        v:updateSelectNum(self._tank_id, self._select_num)
    end
end

function BuildUpTankProductionProcEx:checkMaxProductionCount()
    local max_count = dms.int(dms["base_consume"], 78, base_consume.vip_0_value + tonumber(_ED.vip_grade)) -- 最大生产队列长度
    local ntype = self._from_type - 1
    local current_count = 0
    if _ED.production_info ~= nil and _ED.production_info[""..ntype] ~= nil then
        current_count = table.nums(_ED.production_info[""..ntype])
    end
    if current_count < max_count then
        return true
    else
        return false
    end
end

function BuildUpTankProductionProcEx:createPropUsedCell()
    local root = self.roots[1]
    local ListView_demand = ccui.Helper:seekWidgetByName(root, "ListView_demand")
    ListView_demand:removeAllItems()
    local maxCount = 0
    if self._from_type == 1 or self._from_type == 2 then
        maxCount = 4
    else
        maxCount = 5
    end
    for i=1, maxCount do
        local cell = state_machine.excute("build_up_tank_factory_res_icon_cell_create", 0, {i, self._from_type, self._tank_id, self._select_num})
        ListView_demand:addChild(cell)
    end
    ListView_demand:requestRefreshView()

    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    local Image_1_0 = ccui.Helper:seekWidgetByName(root, "Image_1_0")
    local itemsMargin = ListView_demand:getItemsMargin()
    local width = BuildUpTankFactoryResIconCell.__size.width * maxCount + itemsMargin * (maxCount - 1)
    local viewWidth = self._list_view_size.width * ListView_demand:getScaleX()
    if width <= viewWidth then
        ListView_demand:setContentSize(cc.size(width, self._list_view_size.height))
        Image_1:setVisible(false)
        Image_1_0:setVisible(false)
    else
        ListView_demand:setContentSize(self._list_view_size)
        Image_1:setVisible(true)
        Image_1_0:setVisible(true)
    end
end

function BuildUpTankProductionProcEx:updateDraw()
    local root = self.roots[1]

    local tank_grow_id = 0
    if self._from_type == 1 or self._from_type == 2 then        -- 生产
        tank_grow_id = dms.int(dms["ship_mould"], self._tank_id, ship_mould.ship_name)
    elseif self._from_type == 3 then                            -- 改造
        tank_grow_id = dms.int(dms["ship_mould"], self._tank_id, ship_mould.required_material_id)
    end
    local tank_grow_data = dms.element(dms["ship_grow_requirement"], tank_grow_id)
    self._need_time = dms.atoi(tank_grow_data, ship_grow_requirement.need_time)                         -- 需要时间

    -- 计算生产加速百分比
    local build_mould_id = self._from_type + 8                                   -- 工厂id
    local build_level = _ED.home_build[""..build_mould_id].level
    local build_produce = build_level * _ED.base_build_info[""..build_mould_id].add_get_speed * 100     -- 工厂生产速度
    local time_factor = 0
    if self._from_type == 1 or self._from_type == 2 then        -- 生产速度
        time_factor = _ED.production_time_factor
    elseif self._from_type == 3 then                            -- 改装速度
        time_factor = _ED.reform_time_factor
    end

    self._need_time = math.round(self._need_time / (1 + (build_produce + time_factor) / 100))

    -- 计算可生产或改造的最大数量
    local result_max_num = dms.int(dms["major_city_config"], 17, major_city_config.param)
    local tank_update_id = dms.atoi(tank_grow_data, ship_grow_requirement.need_ship_mould1)             -- 改造需要兵种
    local tank_update_count = dms.atoi(tank_grow_data, ship_grow_requirement.need_ship_mould1_count)    -- 改造需要兵种数量
    local need_iron = dms.atoi(tank_grow_data, ship_grow_requirement.need_iron)                         -- 需要铁矿
    local need_oil = dms.atoi(tank_grow_data, ship_grow_requirement.need_oil)                           -- 需要石油
    local need_lead = dms.atoi(tank_grow_data, ship_grow_requirement.need_lead)                         -- 需要铅矿
    local need_tita = dms.atoi(tank_grow_data, ship_grow_requirement.need_tita)                         -- 需要钛矿

    local max_nums = {0, 0, 0, 0}
    max_nums[1] = math.floor(tonumber(_ED.user_info.user_iron) / need_iron)
    max_nums[2] = math.floor(tonumber(_ED.user_info.oil_field) / need_oil)
    max_nums[3] = math.floor(tonumber(_ED.user_info.exploits) / need_lead)
    max_nums[4] = math.floor(tonumber(_ED.user_info.tiger_shaped) / need_tita)

    for i, num in pairs(max_nums) do
        if num < result_max_num then
            result_max_num = num
        end
    end
    if self._from_type == 3 then        -- 改造工厂，需要消耗前置坦克
        local have_tank_num = 0
        local tank_data = getShipByTemplateId(tank_update_id)
        if tank_data ~= nil then
            have_tank_num = tonumber(tank_data.current_count)
        end
        if have_tank_num < result_max_num then
            result_max_num = have_tank_num
        end
    end

    self._max_select_num = result_max_num

    local Button_sure = ccui.Helper:seekWidgetByName(root, "Button_sure")
    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_num")
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    local Text_num_n = ccui.Helper:seekWidgetByName(root, "Text_num_n")
    if self._max_select_num == 0 then
        Button_sure:setTouchEnabled(false)
        Button_sure:setBright(false)

        Text_time:setString(exChangeNumTimeString(self._need_time))
        Text_num_n:setString(1)
        Slider_num:setPercent(100)
    else
        Button_sure:setTouchEnabled(true)
        Button_sure:setBright(true)
    end
    self:setSelectNum(self._max_select_num)
end

function BuildUpTankProductionProcEx:updateSliderInfo(percent)
    local root = self.roots[1]

    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_num")
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    local Text_num_n = ccui.Helper:seekWidgetByName(root, "Text_num_n")

    if self._max_select_num == 0 then
        Slider_num:setPercent(100)
        return
    end

    Text_time:setString(exChangeNumTimeString(self._need_time * self._select_num))
    Text_num_n:setString(self._select_num)
    Slider_num:setPercent(percent)
end

function BuildUpTankProductionProcEx:onInit()
    local csbItem = csb.createNode(string.format(config_csb.cells.build_up.build_up_cell, 4))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local ListView_demand = ccui.Helper:seekWidgetByName(root, "ListView_demand")
    self._list_view_size = ListView_demand:getContentSize()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "build_up_tank_production_proc_ex_change_num_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_minus"), nil, 
    {
        terminal_name = "build_up_tank_production_proc_ex_change_num_mimus", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"), nil, 
    {
        terminal_name = "build_up_tank_production_proc_ex_sure_product", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_num")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("build_up_tank_production_proc_ex_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_num._self = self
    Slider_num:addEventListener(percentChangedEvent)

    self:createPropUsedCell()
end

function BuildUpTankProductionProcEx:onEnterTransitionFinish()
    
end

function BuildUpTankProductionProcEx:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function BuildUpTankProductionProcEx:onExit()
    state_machine.remove("build_up_tank_production_proc_ex_change_num_add")
    state_machine.remove("build_up_tank_production_proc_ex_change_num_mimus")
    state_machine.remove("build_up_tank_production_proc_ex_update_slider")
    state_machine.remove("build_up_tank_production_proc_ex_sure_product")
    state_machine.remove("build_up_tank_production_proc_ex_update_draw")
    state_machine.remove("build_up_tank_production_proc_ex_update_tank_id")
    state_machine.remove("build_up_tank_production_proc_ex_show")
    state_machine.remove("build_up_tank_production_proc_ex_hide")
end