----------------------------------------------------------------------------------------------------
-- 说明：军团占领城市列表cell
-------------------------------------------------------------------------------------------------------
LegionCityOccupyCell = class("LegionCityOccupyCellClass", Window)
LegionCityOccupyCell.__size = nil

local legion_city_occupy_cell_create_terminal = {
    _name = "legion_city_occupy_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LegionCityOccupyCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_occupy_cell_create_terminal)
state_machine.init()

function LegionCityOccupyCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil
    self._coord = nil

    self._text_time = 0
    self._end_time = 0

    local function init_legion_city_occupy_cell_terminal()
        local legion_city_occupy_cell_update_info_terminal = {
            _name = "legion_city_occupy_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params.cell
                local index = params.index
                cell._info = params._info
                cell._coord = nil
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

        local legion_city_occupy_cell_look_info_terminal = {
            _name = "legion_city_occupy_cell_look_info",
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

        local legion_city_occupy_cell_attack_terminal = {
            _name = "legion_city_occupy_cell_attack",
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
        
        state_machine.add(legion_city_occupy_cell_update_info_terminal)
        state_machine.add(legion_city_occupy_cell_look_info_terminal)
        state_machine.add(legion_city_occupy_cell_attack_terminal)
        state_machine.init()
    end
    init_legion_city_occupy_cell_terminal()         
end

function LegionCityOccupyCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_city_icon = ccui.Helper:seekWidgetByName(root,"Panel_city_icon")
    local Text_occupy_city_state = ccui.Helper:seekWidgetByName(root,"Text_occupy_city_state")
    local Text_city_type = ccui.Helper:seekWidgetByName(root,"Text_city_type")
    local Text_city_occupy_rec_time = ccui.Helper:seekWidgetByName(root,"Text_city_occupy_rec_time")
    local Button_city_occupy_infor = ccui.Helper:seekWidgetByName(root,"Button_city_occupy_infor")

    local city_data = dms.element(dms["world_city_mould"], self._info.city_id)
    local name = dms.atos(city_data, world_city_mould.name)
    local level = dms.atoi(city_data, world_city_mould.level)
    local pic = dms.atoi(city_data, world_city_mould.pic)
    local sort_type = dms.atoi(city_data, world_city_mould.sort_type)
    local city_type = dms.atoi(city_data, world_city_mould.city_type)
    local position = dms.atos(city_data, world_city_mould.position)

    local position_info = zstring.split(position, ",")
    self._coord = {tonumber(position_info[1]), tonumber(position_info[2])}

    -- 城市图标
    Panel_city_icon:removeBackGroundImage()
    Panel_city_icon:setBackGroundImage(string.format(config_res.images.ui.legion.legion_city_icon, pic))

    -- 城市名称
    Text_occupy_city_state:setString(name)

    Text_city_type:setString(world_city_tip_str[5 + sort_type])

    -- 回收时间
    self._end_time = 0
    if self._info.city_type == 3002 then
        if _ED.mould_function_push_info["16"] ~= nil then
            self._end_time = tonumber(_ED.mould_function_push_info["16"].params) / 1000 + _ED.mould_function_push_info["16"].start_time
        end
    else
        -- 城市回收时间计算
        local cd_time = dms.int(dms["world_city_config"], 33, world_city_config.param)
        self._end_time = self._info.capture_start_time + cd_time
    end
    local tick_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    Text_city_occupy_rec_time:setString(world_city_tip_str[27]..exChangeTimeToString(tick_time))
    self._text_time = Text_city_occupy_rec_time

    if city_type == 3002 then
        Text_city_type:setString(world_city_tip_str[58])
        Button_city_occupy_infor:setTitleText(world_city_tip_str[59])
    else
        Button_city_occupy_infor:setTitleText(world_city_tip_str[12])
    end
end

function LegionCityOccupyCell:onUpdate()
    if self._text_time ~= nil then
        local tick_time = self._end_time - (os.time() + _ED.time_add_or_sub)
        self._text_time:setString(world_city_tip_str[27]..exChangeTimeToString(tick_time))
    end
end

function LegionCityOccupyCell:onEnterTransitionFinish()

end

function LegionCityOccupyCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_city_occupy_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LegionCityOccupyCell.__size == nil then
        LegionCityOccupyCell.__size = root:getContentSize()
    end

    -- 城市属性
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_city_occupy_infor"), nil, 
    {
        terminal_name = "legion_city_occupy_cell_look_info",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    },
    nil,1)

    -- 驻军
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_city_occupy_garrison"), nil, 
    {
        terminal_name = "legion_city_occupy_cell_attack",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function LegionCityOccupyCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_occupy_cell, self.roots[1])
end

function LegionCityOccupyCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
    self:registerOnNoteUpdate(self, 0.5)
end

function LegionCityOccupyCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_occupy_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCityOccupyCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_city_icon = ccui.Helper:seekWidgetByName(root,"Panel_city_icon")
    local Text_occupy_city_state = ccui.Helper:seekWidgetByName(root,"Text_occupy_city_state")
    local Text_city_type = ccui.Helper:seekWidgetByName(root,"Text_city_type")
    local Text_city_occupy_rec_time = ccui.Helper:seekWidgetByName(root,"Text_city_occupy_rec_time")
    if Panel_city_icon ~= nil then
        Panel_city_icon:removeBackGroundImage()
        Text_occupy_city_state:setString("")
        Text_city_type:setString("")
        Text_city_occupy_rec_time:setString("")
    end
    self:unregisterOnNoteUpdate(self)
end

function LegionCityOccupyCell:init(params)
    self._index = params[1]
    self._info = params[2]

    if self._index <= 8 then
       self:onInit()
    end
    self:setContentSize(LegionCityOccupyCell.__size)
end

