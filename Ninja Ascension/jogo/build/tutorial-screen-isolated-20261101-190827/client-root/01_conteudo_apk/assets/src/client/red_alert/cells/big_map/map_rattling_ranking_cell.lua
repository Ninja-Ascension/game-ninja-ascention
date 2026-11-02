MapRattlingRankingCell = class("MapRattlingRankingCellClass", Window)
MapRattlingRankingCell.__size = nil

local map_rattling_ranking_create_cell_terminal = {
    _name = "map_rattling_ranking_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MapRattlingRankingCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattling_ranking_create_cell_terminal)
state_machine.init()

function MapRattlingRankingCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil
    self._type = 0
    self._tick_time = 0

    app.load("client.red_alert.cells.hero.hero_icon_cell")
    app.load("client.red_alert.cells.all_resources_cell")

    local function init_map_rattling_ranking_cell_terminal()
        local map_rattling_ranking_cell_go_terminal = {
            _name = "map_rattling_ranking_cell_go",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local city_id = cell._info.city_id
                local resource_id = cell._info.resource_mould_id
                local resource_index = 1--cell._info._resource_index
                local id = cell._info.resource_id
                state_machine.excute("map_rattling_window_close", 0, nil)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local info = _ED.city_resource_hold_resource_infos[1]
                        local function responseCallback1( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("map_rattling_window_open", 0, {info.city_id, info.mould_id, 1})
                                state_machine.excute("map_rattling_ranking_window_close", 0, nil)
                            end
                        end
                        protocol_command.city_resource_hold_get_resource_users.param_list = info.city_id.."\r\n"..info.id
                        NetworkManager:register(protocol_command.city_resource_hold_get_resource_users.code, nil, nil, nil, response.node, responseCallback1, false, nil)
                    end
                end
                protocol_command.city_resource_hold_get_city_resource.param_list = city_id
                NetworkManager:register(protocol_command.city_resource_hold_get_city_resource.code, nil, nil, nil, cell, responseCallback, false, nil)

                -- if tonumber(_ED.city_world_map_id_backup) == tonumber(city_id) then
                --     state_machine.excute("map_rattling_window_open", 0, {city_id, resource_id, 1})
                -- else
                --     _ED.city_resource_invite_goto_info = {city_id = city_id, resource_id = resource_id, resource_index = 1, id = id}
                --     local function responsemapmoveto(response)
                --         if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --             state_machine.excute("national_war_map_move_my_pos",0,{tonumber(city_id)})
                --         end
                --     end
                --     protocol_command.city_resource_hold_move_to_city.param_list = tonumber(city_id)
                --     NetworkManager:register(protocol_command.city_resource_hold_move_to_city.code, nil, nil, nil, nil, responsemapmoveto, false, nil)
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_rattling_ranking_cell_go_terminal)
        state_machine.init()
    end
    init_map_rattling_ranking_cell_terminal()
end

function MapRattlingRankingCell:onUpdateDraw()
    local root = self.roots[1]
    
    local Panel_have = ccui.Helper:seekWidgetByName(root,"Panel_have")
    local Panel_have_air = ccui.Helper:seekWidgetByName(root,"Panel_have_air")
    local Panel_head = ccui.Helper:seekWidgetByName(root,"Panel_head")
    local Text_rec_n = ccui.Helper:seekWidgetByName(root,"Text_rec_n")
    local Text_rec_s_n = ccui.Helper:seekWidgetByName(root,"Text_rec_s_n")
    local Text_fight_n = ccui.Helper:seekWidgetByName(root,"Text_fight_n")
    local Text_7 = ccui.Helper:seekWidgetByName(root,"Text_7")
    local Text_legion_n = ccui.Helper:seekWidgetByName(root,"Text_legion_n")
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")

    local Text_build_name = ccui.Helper:seekWidgetByName(root,"Text_build_name")
    local Text_time_n = ccui.Helper:seekWidgetByName(root,"Text_time_n")
    local Text_rec_name = ccui.Helper:seekWidgetByName(root,"Text_rec_name")

    Panel_head:removeAllChildren(true)
    Panel_have:setVisible(false)
    Panel_have_air:setVisible(false)
    Panel_props_icon:removeBackGroundImage()
    self._tick_time = 0
    local distribute = dms.string(dms["city_resource_mould"], self._info.resource_mould_id, city_resource_mould.distribute)
    local resourceType = dms.int(dms["city_resource_mould"], self._info.resource_mould_id, city_resource_mould.resourceType)
    local quality = dms.int(dms["city_resource_mould"], self._info.resource_mould_id, city_resource_mould.quality)
    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould], self._info.city_id, warfare_map_mould.city_name)
    if tonumber(self._info.user_id) == 0 then
        Panel_have_air:setVisible(true)
        Text_build_name:setString(city_name)
        Text_rec_name:setString(distribute)
        self._tick_time = self._info.end_time/1000 - (os.time() + _ED.time_add_or_sub)
        Text_time_n:setString(self:formatTimeString(self._tick_time))

        local speed = dms.int(dms["city_resource_mould"], self._info.resource_mould_id, city_resource_mould.speed)
        local prop = {}
        prop.item_value = speed * math.floor(self._tick_time/3600)
        prop.prop_type = resourceType
        prop.prop_item = -1

        Panel_head:addChild(state_machine.excute("all_resource_create_cell",0,{2,prop,prop,1,0,false,false}))
        Text_build_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        Text_rec_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    else
        Panel_have:setVisible(true)
        Text_7:setString(self._info.userName)
        local user_data = {
            user_level = self._info.userLevel,
            user_sex = self._info.userGender,
            user_camp = self._info.userCamp
        }
        local head_icon = state_machine.excute("user_head_icon_create",0,{user_data,1})
        Panel_head:addChild(head_icon)
        if self._info.unionName ~= "" then
            Text_legion_n:setString(self._info.unionName)
        else
            Text_legion_n:setString(red_alert_all_str[152])
        end

        Text_fight_n:setString(self._info.userFighting)

        if self._info.canGetResource ~= "" then
            local reward = zstring.split(self._info.canGetResource, ",")
            Text_rec_s_n:setString(reward[3])
            if tonumber(reward[2]) == 33 then
                Panel_props_icon:setBackGroundImage(config_res.images.ui.props.props_4019)
            elseif tonumber(reward[2]) == 1 then
                Panel_props_icon:setBackGroundImage(config_res.images.ui.props.props_4002)
            elseif tonumber(reward[2]) == 2 then
                Panel_props_icon:setBackGroundImage(config_res.images.ui.props.props_4001)
            else
                Panel_props_icon:setBackGroundImage(config_res.images.ui.props.props_4008)
            end
        else
            Text_rec_s_n:setString("0")
        end

        local official = dms.int(dms["arena_reward_param"], self._info.userOfficialRankId,
            arena_reward_param.arena_official)
        if official ~= nil then
            Text_rec_n:setString(red_alert_officer[official])
            local color_table = red_alert_officer_color[official]
            Text_rec_n:setColor(cc.c3b(color_table[1], color_table[2], color_table[3]))
        else
            Text_rec_n:setString("")
        end
    end
end

function MapRattlingRankingCell:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function MapRattlingRankingCell:onUpdate( dt )
    if self._tick_time ~= nil then
        if self._tick_time <= 0 then
            self._tick_time = 0
            self:unregisterOnNoteUpdate(self)
        else
            self._tick_time = self._tick_time - dt
        end
        local Text_time_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_time_n")
        if Text_time_n ~= nil then
            Text_time_n:setString(self:formatTimeString(self._tick_time))
        end
    end
end

function MapRattlingRankingCell:onEnterTransitionFinish()

end

--初始化列表
function MapRattlingRankingCell:onInit( )
    local root = cacher.createUIRef(config_csb.cells.big_map.map_ranking_cell, "root")
    root:removeFromParent(false)
    self:addChild(root)
	
	table.insert(self.roots, root)

    if MapRattlingRankingCell.__size == nil then
        MapRattlingRankingCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
    {
        terminal_name = "map_rattling_ranking_cell_go",
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

	self:onUpdateDraw()
end

function MapRattlingRankingCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
    self:registerOnNoteUpdate(self, 0.1)
end

function MapRattlingRankingCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:unregisterOnNoteUpdate(self, 0.1)
    local Panel_head = ccui.Helper:seekWidgetByName(root,"Panel_head")
    Panel_head:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.big_map.map_ranking_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function MapRattlingRankingCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._type = params[3]
    if self._index ~= nil and self._index < 6 then
        self:onInit()
    end
    self:setContentSize(MapRattlingRankingCell.__size)
    return self
end

function MapRattlingRankingCell:onExit()
    local Panel_head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_head")
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.big_map.map_ranking_cell, self.roots[1])
end
