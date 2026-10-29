-- ------------------------------------------------------------------------------------------------------------
--  说明：军团城市列表
-- ------------------------------------------------------------------------------------------------------------
LegionCityList = class("LegionCityListClass", Window)

--打开界面
local legion_city_list_open_terminal = {
    _name = "legion_city_list_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionCityList:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_list_open_terminal)
state_machine.init()

function LegionCityList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self.recording = 0

    self._is_show_sort = false
    self._text_time = nil

    self._last_state = -1       -- 0：未开启，1：已开启

    self._from_type = 0

    app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    local function init_legion_city_list_terminal()
        local legion_city_list_show_terminal = {
            _name = "legion_city_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:setVisible(true)
                    panel:refreshListView()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_list_hide_terminal = {
            _name = "legion_city_list_hide",
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

        local legion_city_list_update_list_info_terminal = {
            _name = "legion_city_list_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel._is_show_sort = false
                    panel:onUpdateDraw(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_list_show_sort_panel_terminal = {
            _name = "legion_city_list_show_sort_panel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params._datas.panel
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel._is_show_sort = not panel._is_show_sort
                    panel:showSortPanel()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_list_close_sort_panel_terminal = {
            _name = "legion_city_list_close_sort_panel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params._datas.panel
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel._is_show_sort = false
                    panel:showSortPanel()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local legion_city_list_show_update_sort_terminal = {
            _name = "legion_city_list_show_update_sort",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params._datas.panel
                local sort_index = params._datas.sort
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel._is_show_sort = false
                    panel:onUpdateDraw(sort_index)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_list_show_terminal)
        state_machine.add(legion_city_list_hide_terminal)
        state_machine.add(legion_city_list_update_list_info_terminal)
        state_machine.add(legion_city_list_show_sort_panel_terminal)
        state_machine.add(legion_city_list_show_update_sort_terminal)
        state_machine.add(legion_city_list_close_sort_panel_terminal)
        state_machine.init()
    end
    init_legion_city_list_terminal()
end

function LegionCityList:refreshListView()
    if self._list_view ~= nil then
        self._list_view:jumpToTop()
        self._list_view:requestRefreshView()
    end
end

function LegionCityList:updateState()
    if self._last_state > 0 then
        return
    end
    local root = self.roots[1]
    local Text_leagion_city_battle_open_time_n = ccui.Helper:seekWidgetByName(root, "Text_leagion_city_battle_open_time_n")
    local Text_leagion_city_battle_open_time = ccui.Helper:seekWidgetByName(root, "Text_leagion_city_battle_open_time")

    local Panel_legion_city_bar = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_bar")
    local Panel_legion_city_sp = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_sp")
    local ListView_legion_city_list = ccui.Helper:seekWidgetByName(root, "ListView_legion_city_list")
    local Image_legion_city_list_bg = ccui.Helper:seekWidgetByName(root, "Image_legion_city_list_bg")
    local ListView_legion_city_list_sp = ccui.Helper:seekWidgetByName(root, "ListView_legion_city_list_sp")
    local Image_legion_city_list_bg_sp = ccui.Helper:seekWidgetByName(root, "Image_legion_city_list_bg_sp")

    -- 城市战是否到达开服天数开启
    local is_open = true
    self._tick_time = 0
    if self._from_type == 1 then
        local open_day = dms.int(dms["fun_open_condition"], 244, fun_open_condition.open_day)
        if open_day > 1 then
            local open_sec = open_day * 86400
            local time = tonumber(_ED.system_time) - tonumber(_ED.open_server_time)/1000 + (os.time()-tonumber(_ED.native_time))
            if open_sec > time then
                is_open = false
                self._tick_time = open_sec - time
            end
        end
    end

    local current_state = 0 
    if is_open == true then
        current_state = 1
    end

    if current_state ~= self._last_state then
        self._last_state = current_state
        if current_state == 0 then      -- 未开启
            Panel_legion_city_bar:setPositionY(0)
            Text_leagion_city_battle_open_time_n:setVisible(true)
            Text_leagion_city_battle_open_time:setVisible(true)
            ListView_legion_city_list:setVisible(true)
            Image_legion_city_list_bg:setVisible(true)
            ListView_legion_city_list_sp:setVisible(false)
            Image_legion_city_list_bg_sp:setVisible(false)

            self._list_view = ListView_legion_city_list
            ListView_legion_city_list_sp:removeAllItems()

            Text_leagion_city_battle_open_time_n:setString(getRedAlertTimeActivityFormat(self._tick_time))
            self._text_time = Text_leagion_city_battle_open_time_n
        else
            local posY = Panel_legion_city_sp:getContentSize().height - Panel_legion_city_bar:getContentSize().height
            Panel_legion_city_bar:setPositionY(posY)

            Text_leagion_city_battle_open_time_n:setVisible(false)
            Text_leagion_city_battle_open_time:setVisible(false)
            ListView_legion_city_list:setVisible(false)
            Image_legion_city_list_bg:setVisible(false)
            ListView_legion_city_list_sp:setVisible(true)
            Image_legion_city_list_bg_sp:setVisible(true)

            self._list_view = ListView_legion_city_list_sp
            ListView_legion_city_list:removeAllItems()
        end
    end
end

function LegionCityList:showSortPanel()
    local root = self.roots[1]
    local Panel_legion_city_list_choose = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_list_choose")
    local Image_legion_city_list_choose_x = ccui.Helper:seekWidgetByName(root, "Image_legion_city_list_choose_x")
    Panel_legion_city_list_choose:setVisible(self._is_show_sort)
    Image_legion_city_list_choose_x:setVisible(self._is_show_sort)
end

function LegionCityList:onUpdateDraw(sort_index)
    local root = self.roots[1]

    self:updateState()
    self._list_view:jumpToTop()

    local open_state = 0
    if self._from_type == 2 then
        if _ED.mould_function_push_info["16"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["16"].state)
        end
    else
        if _ED.mould_function_push_info["14"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["14"].state)
        end
    end

    local result = {}
    local first_list = {}
    local second_list = {}
    if self._from_type == 1 then
        if _ED.world_city_info ~= nil and _ED.world_city_info.city_info ~= nil then
            for k, v in pairs(_ED.world_city_info.city_info) do
                if tonumber(v.city_type) == 3000 then
                    table.insert(result, v)
                end
            end
        end
    else
        if _ED.world_city_info ~= nil and _ED.world_city_info.city_info ~= nil then
            for k, v in pairs(_ED.world_city_info.city_info) do
                if tonumber(v.city_type) == 3002 then
                    table.insert(result, v)
                end
            end
        end
    end

    for k, v in pairs(result) do
        v.sort_type = dms.int(dms["world_city_mould"], v.city_id, world_city_mould.sort_type)
        v.level = dms.int(dms["world_city_mould"], v.city_id, world_city_mould.level)
        local capture_time = dms.int(dms["world_city_mould"], v.city_id, world_city_mould.capture_time)
        if v.sort_type == (sort_index - 1) then
            table.insert(first_list, v)
        else
            table.insert(second_list, v)
        end
        if tonumber(v.state) < 0 then
            v.state_sort = -1
        else
            if v.union_id > 0 then
                v.state_sort = 1 
            else
                v.state_sort = 0
            end
        end
    end

    -- 排序
    local function sortFunction(a, b)
        if tonumber(a.state_sort) > tonumber(b.state_sort)
            or tonumber(a.state_sort) == tonumber(b.state_sort) and a.sort_type < b.sort_type 
            or tonumber(a.state_sort) == tonumber(b.state_sort) and a.sort_type == b.sort_type and a.level > b.level
            then
            return true
        end
        return false
    end
    table.sort(first_list, sortFunction)
    table.sort(second_list, sortFunction)

    result = {}
    for k, v in pairs(first_list) do
        table.insert(result, v)
    end
    for k, v in pairs(second_list) do
        table.insert(result, v)
    end

    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("legion_city_list_cell_update_info", 0, {cell = v, _info = result[k], index = k})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("legion_city_list_cell_create", 0, {i, result[i]})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

    self:showSortPanel()
end

function LegionCityList:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
        if self._tick_time < 0 then
            self._tick_time = 0 
            self:updateState()
        end
    end

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

function LegionCityList:onInitUI()
    local root = self.roots[1]
    local Text_legion_city_list_t_1 = ccui.Helper:seekWidgetByName(root,"Text_legion_city_list_t_1")
    local Text_legion_city_list_t_3 = ccui.Helper:seekWidgetByName(root,"Text_legion_city_list_t_3")
    if self._from_type == 2 then
        local posy_tables = {}
        for i = 1, 7 do 
            local Button_legion_city_list_choose = ccui.Helper:seekWidgetByName(root,"Button_legion_city_list_choose_"..i)
            local posY = Button_legion_city_list_choose:getPositionY()
            if i == 2 or i == 7 then
                Button_legion_city_list_choose:setVisible(false)
            end
            table.insert(posy_tables, posY)
        end
        for i = 3, 6 do
            local Button_legion_city_list_choose = ccui.Helper:seekWidgetByName(root,"Button_legion_city_list_choose_"..i)
            Button_legion_city_list_choose:setPositionY(posy_tables[i - 1])
        end

        Text_legion_city_list_t_1:setString(world_city_tip_str[57])
        Text_legion_city_list_t_3:setString(world_city_tip_str[55])
    else
        Text_legion_city_list_t_1:setString(world_city_tip_str[56])
        Text_legion_city_list_t_3:setString(world_city_tip_str[17])
    end
end

function LegionCityList:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_city_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onInitUI()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_list_choose"), nil, 
    {
        terminal_name = "legion_city_list_show_sort_panel",
        terminal_state = 0,
        panel = self,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_legion_city_list_choose_x"), nil, 
    {
        terminal_name = "legion_city_list_close_sort_panel",
        terminal_state = 0,
        panel = self,
    },
    nil,1)

    for i = 1, 7 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_list_choose_"..i), nil, 
        {
            terminal_name = "legion_city_list_show_update_sort",
            terminal_state = 0,
            sort = i,
            panel = self,
        },
        nil,1)
    end

    self:onUpdateDraw(0)
end

function LegionCityList:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionCityList:onExit()
    state_machine.remove("legion_city_list_show")
    state_machine.remove("legion_city_list_hide")
    state_machine.remove("legion_city_list_update_list_info")
    state_machine.remove("legion_city_list_show_sort_panel")
    state_machine.remove("legion_city_list_show_update_sort")
    state_machine.remove("legion_city_list_close_sort_panel")
end