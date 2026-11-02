--------------------------------------------------------------------------------------------------------------
--  增益页面
--------------------------------------------------------------------------------------------------------------
BaseReserveTab = class("BaseReserveTabClass", Window)

local base_reserve_tab_window_open_terminal = {
    _name = "base_reserve_tab_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = BaseReserveTab:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

local base_reserve_tab_gain_check_time_terminal = {
    _name = "base_reserve_tab_gain_check_time",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local current_time = params
        if _ED.factor_info_changed ~= false then
            _ED.factor_info_changed = false

            _ED.factor_info_effect_list = {}            -- 生效的限时增益

            for k, v in pairs(_ED.factor_info) do
                local build_buff_id = tonumber(v.build_buff_id)
                if build_buff_id > 0 and _ED.base_build_buff[""..build_buff_id] ~= nil then
                    table.insert(_ED.factor_info_effect_list, v)
                end
            end
        end 

        for k, v in pairs(_ED.factor_info_effect_list) do
            local max_time = tonumber(v.factor_cd_time)
            local start_time = tonumber(v.factor_start_time)
            local leave_time = max_time - zstring.tonumber((current_time + _ED.time_add_or_sub - start_time))
            if leave_time < 0 then
                if tonumber(v.build_buff_id) == 24 then        -- 守卫战增益
                    NetworkManager:register(protocol_command.guard_check_gain_cd_time.code, nil, nil, nil, nil, nil, false, nil)
                else
                    NetworkManager:register(protocol_command.gain_limit_check.code, nil, nil, nil, nil, nil, false, nil)
                end
            end
        end
        return 
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(base_reserve_tab_window_open_terminal)
state_machine.add(base_reserve_tab_gain_check_time_terminal)
state_machine.init()

function BaseReserveTab:ctor()
    self.super:ctor()
    self.roots = {}

    -- 
    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_shop_arrow_down = nil
    self._Image_shop_arrow_up = nil

    self._last_page_index = 1

    self._list_refresh_view = false

    app.load("client.red_alert_time.cells.props.props_shop_packs_shop_cell")

    -- Initialize base_reserve_tab state machine.
    local function init_base_reserve_tab_terminal()
        -- 刷新界面
        local base_reserve_tab_update_draw_terminal = {
            _name = "base_reserve_tab_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = params
                if page ~= nil and page.roots ~= nil and page.roots[1] ~= nil then
                    local posY = page._list_view_poy
                    page:updateDraw()
                    if math.abs(posY) > math.abs(page._list_view_height) then
                        posY = page._list_view_height
                    end
                    page._list_view:getInnerContainer():setPositionY(posY)   
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local base_reserve_tab_show_terminal = {
            _name = "base_reserve_tab_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params
                if page ~= nil and page.roots ~= nil and page.roots[1] ~= nil then
                    page:setVisible(true)
                    page:refreshListView()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local base_reserve_tab_hide_terminal = {
            _name = "base_reserve_tab_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = params
                if page ~= nil and page.roots ~= nil and page.roots[1] ~= nil then
                    page:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(base_reserve_tab_update_draw_terminal) 
        state_machine.add(base_reserve_tab_show_terminal) 
        state_machine.add(base_reserve_tab_hide_terminal) 
        state_machine.init()
    end
    
    -- call func base_reserve_tab create state machine.
    init_base_reserve_tab_terminal()

end

function BaseReserveTab:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function BaseReserveTab:updateDraw()
    local root = self.roots[1]

    local ListView_base_reserve = ccui.Helper:seekWidgetByName(root, "ListView_base_reserve")
    ListView_base_reserve:jumpToTop()
    ListView_base_reserve:removeAllItems()

    if self._last_page_index == 1 then
        local build_count = {0, 0, 0, 0, 0}

        for k,v in pairs(_ED.home_build) do
            local build_mould_id = tonumber(v.build_mould_id)
            if build_mould_id == 22 then
                build_count[1] = build_count[1] + 1
            elseif build_mould_id == 23 then
                build_count[2] = build_count[2] + 1
            elseif build_mould_id == 24 then
                build_count[3] = build_count[3] + 1
            elseif build_mould_id >= 16 and build_mould_id <= 21 then  
                build_count[4] = build_count[4] + 1 
            elseif build_mould_id == 15 then
                build_count[5] = build_count[5] + 1
            end
        end
        
        local info ={
                {33, tipStringInfo_build_up_info[16], _ED.user_info.user_iron,    _ED.user_info.user_iron_max,    build_count[1], _ED.output_per_hour_iron,     _ED.warehouse_capacity_iron},
                {41, tipStringInfo_build_up_info[17], _ED.user_info.oil_field,    _ED.user_info.oil_field_max,    build_count[2], _ED.output_per_hour_oil,      _ED.warehouse_capacity_oil},
                {42, tipStringInfo_build_up_info[18], _ED.user_info.exploits,     _ED.user_info.exploits_max,     build_count[3], _ED.output_per_hour_exploits, _ED.warehouse_capacity_exploits},
                {43, tipStringInfo_build_up_info[19], _ED.user_info.tiger_shaped, _ED.user_info.tiger_shaped_max, build_count[4], _ED.output_per_hour_tiger,    _ED.warehouse_capacity_tiger},
                {1,  tipStringInfo_build_up_info[20], _ED.user_info.user_silver,  _ED.user_info.user_silver_max,  build_count[5], _ED.output_per_hour_silver,   _ED.warehouse_capacity_silver},
            }
        for i=1,5 do
            local cell = state_machine.excute("base_reserve_pack_create_cell",0, {i, info[i]})
            ListView_base_reserve:addChild(cell)
        end
    else
        local have_factor_buff = {}         -- 有增益生效
        local no_factor_buff = {}
        local buff_info = {}
        for k,v in pairs(_ED.factor_info) do
            buff_info[""..v.build_buff_id] = tonumber(v.factor_cd_time) + zstring.tonumber(buff_info[""..v.build_buff_id])
        end
        for k, v in pairs(_ED.base_build_buff) do
            if v.is_show > 0 and buff_info[""..k] == nil then
                table.insert(no_factor_buff, v)
            elseif buff_info[""..k] ~= nil then
                table.insert(have_factor_buff, v)
            end
        end

        function sortByCdTime(a, b)
            local factor_cd_time_1 = tonumber(buff_info[""..a.id])
            local factor_cd_time_2 = tonumber(buff_info[""..b.id])
            return factor_cd_time_1 > factor_cd_time_2
        end
        table.sort(have_factor_buff, sortByCdTime)

        function sortFunction(a, b)
            return a.id < b.id
        end
        table.sort(no_factor_buff, sortFunction)

        local index = 1

        -- 工厂增益
        if _ED.legion_occupy_factory_info ~= nil then
            for k, v in pairs(_ED.legion_occupy_factory_info) do
                local cell = state_machine.excute("base_reserve_factory_gain_cell_create", 0, {index, v})
                ListView_base_reserve:addChild(cell)
                index = index + 1
            end
        end

        for k, v in pairs(have_factor_buff) do
            local cell = state_machine.excute("base_reserve_gain_ing_cell_create", 0, {index, v})
            ListView_base_reserve:addChild(cell)
            index = index + 1
        end

        for k, v in pairs(no_factor_buff) do
            local cell = state_machine.excute("base_reserve_gain_cell_create", 0, {index, v})
            ListView_base_reserve:addChild(cell)
            index = index + 1
        end
    end

    self._list_view = ListView_base_reserve
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_refresh_view = true
end

function BaseReserveTab:onUpdate(dt)
    if self._list_view ~= nil then
        if self._list_refresh_view == true then
            self._list_refresh_view = false
            return
        end

        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
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

function BaseReserveTab:onInit()
    local csbItem = csb.createNode(config_csb.props.base_reserve_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function BaseReserveTab:onEnterTransitionFinish()
    
end

function BaseReserveTab:init(params)
    local rootWindow = params[1]
    self._last_page_index = params[2]

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function BaseReserveTab:onExit()

end