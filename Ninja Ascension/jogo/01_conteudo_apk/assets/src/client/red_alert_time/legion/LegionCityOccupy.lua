-- ------------------------------------------------------------------------------------------------------------
--  说明：军团城市列表
-- ------------------------------------------------------------------------------------------------------------
LegionCityOccupy = class("LegionCityOccupyClass", Window)

--打开界面
local legion_city_occupy_open_terminal = {
    _name = "legion_city_occupy_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionCityOccupy:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_occupy_open_terminal)
state_machine.init()

function LegionCityOccupy:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_vs_troops_arrow_down = nil
    self._Image_vs_troops_arrow_up = nil

    self._city_id = 0

    self.recording = 0
    self._text_time = nil
    self._tick_time = 0

    self._next_text_time = nil
    self._next_tick_time = 0

    app.load("client.red_alert_time.cells.legion.legion_city_occupy_cell")
    local function init_legion_city_occupy_terminal()
        local legion_city_occupy_show_terminal = {
            _name = "legion_city_occupy_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_occupy_hide_terminal = {
            _name = "legion_city_occupy_hide",
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

        local legion_city_occupy_update_list_info_terminal = {
            _name = "legion_city_occupy_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_occupy_get_reward_terminal = {
            _name = "legion_city_occupy_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.world_city_info.my_info.reward_state) == 1 then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:onUpdateDraw()
                            end
                            checkRewardObtainDraw()
                            state_machine.excute("main_window_update_resource", 0, "")
                            state_machine.excute("notification_center_update", 0, "push_notification_legion_city_reward")
                        end
                    end
                    protocol_command.world_city_bonus_draw.param_list = ""..instance._city_id
                    NetworkManager:register(protocol_command.world_city_bonus_draw.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_occupy_show_terminal)
        state_machine.add(legion_city_occupy_hide_terminal)
        state_machine.add(legion_city_occupy_update_list_info_terminal)
        state_machine.add(legion_city_occupy_get_reward_terminal)
        state_machine.init()
    end
    init_legion_city_occupy_terminal()
end

function LegionCityOccupy:refreshListView()
    if self._list_view ~= nil then
        self._list_view:jumpToTop()
        self._list_view:requestRefreshView()
    end
end

function LegionCityOccupy:onUpdateDraw()
    local root = self.roots[1]
    local ListView_legion_city_occupy = ccui.Helper:seekWidgetByName(root, "ListView_legion_city_occupy")
    ListView_legion_city_occupy:removeAllItems()
    ListView_legion_city_occupy:jumpToTop()
    self._list_view = ListView_legion_city_occupy

    local open_state = 0
    if _ED.mould_function_push_info["14"] ~= nil then
        open_state = tonumber(_ED.mould_function_push_info["14"].state)
    end

    local result = {}
    self._city_id = 0
    for k, v in pairs(_ED.world_city_info.city_info) do
        if (tonumber(v.state) == 2 and tonumber(v.progress_union_id) == tonumber(_ED.union.union_info.union_id)) then
            if tonumber(v.city_type) == 3002 then
                -- 占领工厂
                table.insert(result, v)
            elseif tonumber(v.city_type) == 3000 then
                -- 占领城市
                self._city_id = tonumber(v.city_id)
            end
        end
    end

    local city_info = nil
    if _ED.world_city_info.detail_info ~= nil then
        city_info = _ED.world_city_info.detail_info[""..self._city_id]
    end
    if city_info ~= nil then
        table.insert(result, city_info)
    end

    for k, v in pairs(result) do
        local cell = state_machine.excute("legion_city_occupy_cell_create", 0, {k, v})
        self._list_view:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

    local Text_legion_city_occupy_p = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_p")
    if #result == 0 then
        Text_legion_city_occupy_p:setVisible(true)
    else
        Text_legion_city_occupy_p:setVisible(false)
    end

    -- 城市资源
    local city_resource_info = ""
    if city_info ~= nil then
        city_resource_info = city_info.resource_info
    end
    local city_res_info = zstring.split(city_resource_info, "|")
    local member_count = dms.int(dms["world_city_config"], 9, world_city_config.param)
    for i = 1, 5 do
        local Text_legion_city_occupy_res_n_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_res_n_"..i.."_0")
        Text_legion_city_occupy_res_n_0:setString("0")
        local out_put = 0
        if city_res_info[i] ~= nil and city_res_info[i] ~= "" then
            local info = zstring.split(city_res_info[i], ",")
            out_put = zstring.tonumber(info[3])
        end
        Text_legion_city_occupy_res_n_0:setString(exChangeNumToString(out_put))
    end

    -- 下次倒计时
    local Text_legion_city_occupy_rec_time_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_rec_time_0")
    local Text_legion_city_occupy_rec_time_n_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_rec_time_n_0")
    self._next_text_time = nil
    self._next_tick_time = 0
    local max_update_time = dms.int(dms["world_city_config"], 37, world_city_config.param)
    if city_info == nil then
        Text_legion_city_occupy_rec_time_0:setVisible(false)
        Text_legion_city_occupy_rec_time_n_0:setVisible(false)
    else
        Text_legion_city_occupy_rec_time_0:setVisible(true)
        Text_legion_city_occupy_rec_time_n_0:setVisible(true)
        local add_time = os.time() + _ED.time_add_or_sub - city_info.reward_start_time
        local leave_time = max_update_time * (math.ceil(add_time / max_update_time)) - add_time
        self._next_tick_time = leave_time
        if leave_time <= 0 then
            self._next_tick_time = max_update_time + leave_time
        end
        Text_legion_city_occupy_rec_time_n_0:setString(exChangeTimeToString(self._next_tick_time))
        self._next_text_time = Text_legion_city_occupy_rec_time_n_0
    end

        -- 个人分红
    local Button_legion_city_occupy_rec = ccui.Helper:seekWidgetByName(root, "Button_legion_city_occupy_rec")
    if city_info == nil or tonumber(_ED.world_city_info.my_info.reward_state) ~= 1 then
        Button_legion_city_occupy_rec:setTouchEnabled(false)
        Button_legion_city_occupy_rec:setBright(false)
    else
        Button_legion_city_occupy_rec:setTouchEnabled(true)
        Button_legion_city_occupy_rec:setBright(true)
    end

    for i = 1, 5 do
        local res_info = zstring.split(_ED.world_city_info.my_info.resource_info, "|")
        for i = 1, 5 do
            local Text_legion_city_occupy_res_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_res_n_"..i)
            local out_put = 0
            if res_info[i] ~= nil and res_info[i] ~= "" and city_info ~= nil and city_info.reward_get_count < member_count and tonumber(_ED.world_city_info.my_info.reward_state) < 2 then
                local info = zstring.split(res_info[i], ",")
                out_put = zstring.tonumber(info[3])
            end
            Text_legion_city_occupy_res_n:setString(exChangeNumToString(out_put))
        end
    end

    -- 下次领取刷新
    local Text_legion_city_occupy_rec_time = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_rec_time")
    local Text_legion_city_occupy_rec_time_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_rec_time_n")
    self._text_time = nil
    self._tick_time = 0
    local max_get_time = dms.int(dms["world_city_config"], 38, world_city_config.param)
    if city_info == nil then
        Text_legion_city_occupy_rec_time:setVisible(false)
        Text_legion_city_occupy_rec_time_n:setVisible(false)
    else
        Text_legion_city_occupy_rec_time:setVisible(true)
        Text_legion_city_occupy_rec_time_n:setVisible(true)
        local add_time = os.time() + _ED.time_add_or_sub - city_info.reward_start_time
        local leave_time = max_update_time * (math.ceil(add_time / max_update_time)) - add_time
        if city_info.reward_cd_time == 0 then
            leave_time = leave_time + max_update_time
        end
        self._tick_time = leave_time
        if leave_time <= 0 then
            self._tick_time = max_get_time + leave_time
        end
        Text_legion_city_occupy_rec_time_n:setString(exChangeTimeToString(self._tick_time))
        self._text_time = Text_legion_city_occupy_rec_time_n
    end
end

function LegionCityOccupy:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then
        self._tick_time = self._tick_time - dt
        self._text_time:setString(exChangeTimeToString(self._tick_time))
        if self._tick_time <= 0 then
            self:onUpdateDraw()
        end
    end

    if self._next_text_time ~= nil and self._next_tick_time > 0 then
        self._next_tick_time = self._next_tick_time - dt
        self._next_text_time:setString(exChangeTimeToString(self._next_tick_time))
        if self._next_tick_time <= 0 then
            self:onUpdateDraw()
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

function LegionCityOccupy:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_city_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._city_id = 0

    for k, v in pairs(_ED.world_city_info.city_info) do
        if tonumber(v.city_type) == 3000 
            and tonumber(v.state) == 2
            and tonumber(v.progress_union_id) == tonumber(_ED.union.union_info.union_id) 
            then
            self._city_id = tonumber(v.city_id)
            break
        end
    end

    -- 帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_occupy_help_infor"), nil, 
    {
        terminal_name = "legion_city_active_info_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        _page = 3,
    },
    nil,1)

    -- 战报
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_occupy_record"), nil, 
    {
        terminal_name = "legion_city_record_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- 排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_occupy_record_rank"), nil, 
    {
        terminal_name = "legion_city_active_info_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        _page = 1,
    },
    nil,1)

    -- 个人分红说明
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_occupy_rule"), nil, 
    {
        terminal_name = "legion_city_rule_infor_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        infor_type = 4,
    },
    nil,1)

    -- 领取分红
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_occupy_rec"), nil, 
    {
        terminal_name = "legion_city_occupy_get_reward",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    if self._city_id > 0 then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:onUpdateDraw()
                end
            end
        end

        protocol_command.world_city_detail_get.param_list = ""..self._city_id
        NetworkManager:register(protocol_command.world_city_detail_get.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        self:onUpdateDraw()
    end
end

function LegionCityOccupy:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionCityOccupy:onExit()
    state_machine.remove("legion_city_occupy_show")
    state_machine.remove("legion_city_occupy_hide")
    state_machine.remove("legion_city_occupy_update_list_info")
    state_machine.remove("legion_city_occupy_get_reward")
end