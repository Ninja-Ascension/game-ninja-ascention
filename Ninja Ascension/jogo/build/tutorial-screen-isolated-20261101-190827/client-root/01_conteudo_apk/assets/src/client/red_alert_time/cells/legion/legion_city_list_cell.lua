----------------------------------------------------------------------------------------------------
-- 说明：军团城市列表cell
-------------------------------------------------------------------------------------------------------
LegionCityListCell = class("LegionCityListCellClass", Window)
LegionCityListCell.__size = nil

local legion_city_list_cell_create_terminal = {
    _name = "legion_city_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LegionCityListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_list_cell_create_terminal)
state_machine.init()

function LegionCityListCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil
    self._coord = nil

    self._text_time = nil
    self._tick_time = 0

    local function init_legion_city_list_cell_terminal()
        local legion_city_list_cell_update_info_terminal = {
            _name = "legion_city_list_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params.cell
                local index = params.index
                cell._info = params._info
                self._coord = nil
                if cell._info ~= nil then
                    if index <= 8 then
                        cell:reload()
                        cell:onUpdateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_list_cell_look_info_terminal = {
            _name = "legion_city_list_cell_look_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params._datas.cell
                if cell._info.city_type == 3002 then
                    state_machine.excute("legion_city_factory_infor_window_open", 0, {cell._info.city_id, 1})
                else
                    state_machine.excute("legion_city_infor_window_open", 0, {cell._info.city_id, 1})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_list_cell_attack_terminal = {
            _name = "legion_city_list_cell_attack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)   
                if funOpenDrawTip(210) == true then
                    return
                end         
                local cell = params._datas.cell
                if tonumber(cell._info.state) < 0 then
                    TipDlg.drawTextDailog(world_city_tip_str[31])
                    return
                end
                if cell._coord ~= nil then
                    local coord = cell._coord
                    state_machine.excute("legion_city_close", 0, "")
                    state_machine.excute("legion_window_close", 0, "")
                    state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
                    state_machine.excute("adventure_mine_record_view_position", 0, coord)
                    state_machine.excute("adventure_mine_update_view_position", 0, 0)

                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("adventure_mine_cell_focus_blink", 0, _ED.world_map_focus)
                        end
                    end
                    
                    _ED.world_map_focus = coord
                    protocol_command.world_map_arena_info_refresh.param_list = "" .. coord[1] .. "\r\n" ..  coord[2]
                    NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(legion_city_list_cell_update_info_terminal)
        state_machine.add(legion_city_list_cell_look_info_terminal)
        state_machine.add(legion_city_list_cell_attack_terminal)
        state_machine.init()
    end
    init_legion_city_list_cell_terminal()         
end

function LegionCityListCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_city_sign = ccui.Helper:seekWidgetByName(root, "Panel_city_sign")
    local Text_city_name = ccui.Helper:seekWidgetByName(root, "Text_city_name")
    local Text_city_occupy_name = ccui.Helper:seekWidgetByName(root, "Text_city_occupy_name")
    local Text_city_lv = ccui.Helper:seekWidgetByName(root, "Text_city_lv")
    Panel_city_sign:removeBackGroundImage()

    local Button_city_attack = ccui.Helper:seekWidgetByName(root, "Button_city_attack")
    local Button_city_res_yield = ccui.Helper:seekWidgetByName(root, "Button_city_res_yield")
    Button_city_attack:setBright(true)

    local city_data = dms.element(dms["world_city_mould"], self._info.city_id)
    local name = dms.atos(city_data, world_city_mould.name)
    local level = dms.atoi(city_data, world_city_mould.level)
    local pic = dms.atoi(city_data, world_city_mould.pic)
    local position = dms.atos(city_data, world_city_mould.position)
    local sort_type = dms.atos(city_data, world_city_mould.sort_type)
    local capture_time = dms.atoi(city_data, world_city_mould.capture_time)

    local position_info = zstring.split(position, ",")
    self._coord = {tonumber(position_info[1]), tonumber(position_info[2])}

    -- 图标
    Panel_city_sign:setBackGroundImage(string.format(config_res.images.ui.legion.legion_city_sign_icon, sort_type))

    Text_city_name:setString(name)
    Text_city_lv:setString(friends_tip_string[12]..level)

    local open_state = 0
    if self._info.city_type == 3002 then
        if _ED.mould_function_push_info["16"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["16"].state)
        end
    else
        if _ED.mould_function_push_info["14"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["14"].state)
        end
    end

    self._tick_time = 0
    self._text_time = nil

    local  Text_city_factory_time_t = ccui.Helper:seekWidgetByName(root, "Text_city_factory_time_t")
    local  Text_city_factory_time_n = ccui.Helper:seekWidgetByName(root, "Text_city_factory_time_n")
    Text_city_factory_time_t:setVisible(false)
    Text_city_factory_time_n:setVisible(false)
    local color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    local is_unoccupy = false
    if tonumber(self._info.state) < 0 then
        Text_city_occupy_name:setString(world_city_tip_str[1])
        if tonumber(self._info.state) < 0 then
            Button_city_attack:setBright(false)
        end
    else
        if self._info.city_type == 3002 then
            Button_city_res_yield:setTitleText(world_city_tip_str[55])
            local occupy_state = 0
            if (tonumber(self._info.state) == 2 and self._info.union_id > 0 and self._info.union_id == self._info.progress_union_id and tonumber(self._info.progress) == 0) then
                occupy_state = 1
            end

            if open_state == 1 then
                -- 回收中
                Text_city_occupy_name:setString(world_city_tip_str[1])
                color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
            elseif occupy_state == 0 and self._info.union_id <= 0 then
                -- 无人占领
                Text_city_occupy_name:setString(world_city_tip_str[5])
                color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
                is_unoccupy = true
            elseif occupy_state == 0 and self._info.union_id > 0 then
                -- 争夺中
                Text_city_occupy_name:setString(world_city_tip_str[2])
                color = cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])
            else
                if self._info.union_id == _ED.union.union_info.union_id then
                -- 玩家自己的工厂
                    Text_city_occupy_name:setString(self._info.union_name)
                    color = cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3])
                else
                    Text_city_occupy_name:setString(self._info.union_name)
                    color = cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3])
                end

                -- 倒计时
                Text_city_factory_time_t:setVisible(true)
                Text_city_factory_time_n:setVisible(true)

                Text_city_factory_time_t:setString(world_city_tip_str[73])
                Text_city_factory_time_t:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
                Text_city_factory_time_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
                local time_info = zstring.split(dms.string(dms["world_city_config"], 26, world_city_config.param), "|")
                local week = tonumber(time_info[1])
                time_info = zstring.split(time_info[2], ",")
                local start_time = zstring.split(time_info[2], ":")
                if week == 0 then
                    week = 7
                end

                local server_time = getCurrentGTM8Time()
                local server_week = tonumber(os.date("%w", os.time() + _ED.time_add_or_sub))
                local day_count = week - server_week
                local leave_time = (tonumber(start_time[1]) - server_time.hour) * 3600 + (tonumber(start_time[2]) - server_time.min) * 60 + (tonumber(start_time[3]) - server_time.sec)
                self._tick_time = day_count * 86400 + leave_time
                if self._tick_time < 0 then
                    self._tick_time = self._tick_time + 7 * 86400
                end
                Text_city_factory_time_n:setString(exChangeTimeToString(self._tick_time))
                self._text_time = Text_city_factory_time_n
            end
        else
            Button_city_res_yield:setTitleText(world_city_tip_str[17])
            local occupy_state = 0
            if (tonumber(self._info.state) == 2 and self._info.union_id > 0 and self._info.union_id == self._info.progress_union_id and tonumber(self._info.progress) == 0) then
                occupy_state = 1
            end

            if occupy_state == 0 and self._info.union_id <= 0 then
                -- 无人占领
                Text_city_occupy_name:setString(world_city_tip_str[5])
                color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
                is_unoccupy = true
            elseif occupy_state == 0 and self._info.union_id > 0 then
                -- 争夺中
                Text_city_occupy_name:setString(world_city_tip_str[2])
                color = cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])
            else
                if self._info.union_id == _ED.union.union_info.union_id then
                -- 玩家自己的工厂
                    Text_city_occupy_name:setString(self._info.union_name)
                    color = cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3])
                else
                    Text_city_occupy_name:setString(self._info.union_name)
                    color = cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3])
                end
            end


            local leave_time = self._info.capture_start_time + self._info.capture_cd_time - (os.time() + _ED.time_add_or_sub)
            if leave_time > 0 then
                -- 倒计时
                Text_city_factory_time_t:setVisible(true)
                Text_city_factory_time_n:setVisible(true)

                Text_city_factory_time_t:setString(world_city_tip_str[71])
                Text_city_factory_time_n:setString(exChangeNumToString(leave_time))
                Text_city_factory_time_t:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                Text_city_factory_time_n:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                self._tick_time = leave_time
                self._text_time = Text_city_factory_time_n
            end
        end
    end
    Text_city_name:setColor(color)
    Text_city_lv:setColor(color)
    Text_city_occupy_name:setColor(color)

    if is_unoccupy == true then
        Text_city_occupy_name:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
    end
end

function LegionCityListCell:onUpdate(dt)
    if self._text_time ~= nil then
        self._tick_time = self._tick_time - dt
        self._text_time:setString(exChangeTimeToString(self._tick_time))
        if self._tick_time < 0 then
            self._tick_time = 0
            self:onUpdateDraw()
        end
    end
end

function LegionCityListCell:onEnterTransitionFinish()

end

function LegionCityListCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_city_list_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LegionCityListCell.__size == nil then
        LegionCityListCell.__size = root:getContentSize()
    end

    -- 资源产量
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_city_res_yield"), nil, 
    {
        terminal_name = "legion_city_list_cell_look_info",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    },
    nil,1)

    -- 攻打
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_city_attack"), nil, 
    {
        terminal_name = "legion_city_list_cell_attack",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function LegionCityListCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_list_cell, self.roots[1])
end

function LegionCityListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
    self:registerOnNoteUpdate(self, 0.5)
end

function LegionCityListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_list_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCityListCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_city_sign = ccui.Helper:seekWidgetByName(root, "Panel_city_sign")
    local Text_city_name = ccui.Helper:seekWidgetByName(root, "Text_city_name")
    local Text_city_occupy_name = ccui.Helper:seekWidgetByName(root, "Text_city_occupy_name")
    local Text_city_lv = ccui.Helper:seekWidgetByName(root, "Text_city_lv")
    if Panel_city_sign ~= nil then
        Panel_city_sign:removeBackGroundImage()
        Text_city_name:setString("")
        Text_city_occupy_name:setString("")
        Text_city_lv:setString("")
    end
    self:unregisterOnNoteUpdate(self)
end

function LegionCityListCell:init(params)
    self._index = params[1]
    self._info = params[2]

    if self._index <= 8 then
       self:onInit()
    end
    self:setContentSize(LegionCityListCell.__size)
end

