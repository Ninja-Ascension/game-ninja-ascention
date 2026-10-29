-----------------------------
-- 资源点地图
-----------------------------
MapRattling = class("MapRattlingClass", Window)

local map_rattling_window_open_terminal = {
    _name = "map_rattling_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("MapRattlingClass")
        if nil == _Window then
            local window = MapRattling:new():init(params)
            if window ~= nil then
                fwin:open(window, fwin._ui)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local map_rattling_window_close_terminal = {
    _name = "map_rattling_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MapRattlingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattling_window_open_terminal)
state_machine.add(map_rattling_window_close_terminal)
state_machine.init()

function MapRattling:ctor()
    self.super:ctor()
    self.roots = {}

    self._city_id = 0
    self._resource_id = 0
    self._resource_index = 0
    self._city_resourceId = 0

    self._tick_time = 0
    self._isNeedTick = false

    self._refresh_tick_time = 4
    self._big_resource_id = 0

    _ED.city_resource_invite_goto_info = nil

    -- load lua file
    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert_time.big_map.MapRattlingInvite")
    app.load("client.red_alert_time.big_map.MapRattlingInfomation")
    app.load("client.red_alert_time.big_map.MapBuildInfor")
    app.load("client.red_alert_time.big_map.MapRattlingAttack")
    app.load("client.red_alert_time.big_map.MapRattlingBattleField")
    app.load("client.red_alert_time.cells.big_map.map_rattling_build_cell")
    
    local function init_map_rattling_terminal()
        local map_rattling_search_terminal = {
            _name = "map_rattling_search",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 没有资源点的时候提示未开启 
                if _ED.city_map_info == nil or table.nums(_ED.city_map_info) == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[136])
                    return
                end
                math.randomseed(os.time())
                local city_id = math.random(1, 100)
                while city_id ~= tonumber(instance._city_id) and _ED.city_map_info[""..city_id] == nil do
                    city_id = math.random(1, 100)
                end

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local info = _ED.city_resource_hold_resource_infos[1]
                        local function responseCallback1( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    response.node:resetAllInfo(info.city_id, info.mould_id, 1)
                                end
                            end
                        end
                        protocol_command.city_resource_hold_get_resource_users.param_list = info.city_id.."\r\n"..info.id
                        NetworkManager:register(protocol_command.city_resource_hold_get_resource_users.code, nil, nil, nil, response.node, responseCallback1, false, nil)
                    end
                end
                protocol_command.city_resource_hold_get_city_resource.param_list = city_id
                NetworkManager:register(protocol_command.city_resource_hold_get_city_resource.code, nil, nil, nil, instance, responseCallback, false, nil)

                -- _ED.city_resource_invite_goto_info = {city_id = instance._city_id, resource_id = instance._resource_id, resource_index = instance._resource_index, id = instance._city_resourceId}
                -- state_machine.excute("map_rattling_move_my_role_to_pos", 0, {instance._city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_update_info_terminal = {
            _name = "map_rattling_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_buy_attack_times_terminal = {
            _name = "map_rattling_buy_attack_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local costs = zstring.split(dms.string(dms["city_resource_hold_config"], 7, city_resource_hold_config.param), ",")
                if tonumber(_ED.city_resource_user_info.buyRobotCount) + 1 > #costs then
                    _ED.city_resource_user_info.buyRobotCount = #costs - 1
                end
                local cost = costs[tonumber(_ED.city_resource_user_info.buyRobotCount) + 1]
                if zstring.tonumber(cost) <= zstring.tonumber(_ED.user_info.user_gold) then
                    local tip = ConfirmTip:new()
                    local info = string.format(string_map_rattling_info[3], cost)
                    tip:init(instance, instance.sureBuy, info)
                    fwin:open(tip, fwin._windows)
                else
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = red_alert_all_str[185], 
                        _datas= 
                        {
                        }
                    })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_open_invite_terminal = {
            _name = "map_rattling_open_invite",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("map_rattling_invite_window_open", 0, {response.node._city_id, response.node._resource_id, response.node._resource_index})
                        end
                    end
                end
                NetworkManager:register(protocol_command.city_resource_hold_get_invites.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_open_battle_report_terminal = {
            _name = "map_rattling_open_battle_report",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.red_alert_time.battle.battle_enum")
                -- local function responseCallBack( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("map_rattle_battle_field_window_open", 0, nil)
                --     end
                -- end
                -- protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_23
                -- NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_move_my_role_to_pos_terminal = {
            _name = "map_rattling_move_my_role_to_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local city_id = params.city_id
                local resource_id = params.resource_id
                local resource_index = params.resource_index
                local id = params.id
                if tonumber(instance._city_id) == tonumber(city_id)
                    and tonumber(instance._resource_id) == tonumber(resource_id) then
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local info = _ED.city_resource_hold_resource_infos[1]
                        local function responseCallback1( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    response.node:resetAllInfo(info.city_id, info.mould_id, 1)
                                end
                            end
                        end
                        protocol_command.city_resource_hold_get_resource_users.param_list = city_id.."\r\n"..id
                        NetworkManager:register(protocol_command.city_resource_hold_get_resource_users.code, nil, nil, nil, response.node, responseCallback1, false, nil)
                    end
                end
                protocol_command.city_resource_hold_get_city_resource.param_list = city_id
                NetworkManager:register(protocol_command.city_resource_hold_get_city_resource.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_reqeust_refresh_resource_info_terminal = {
            _name = "map_rattling_reqeust_refresh_resource_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            if table.nums(_ED.city_resource_hold_resource_infos) == 0 then
                                state_machine.excute("map_rattling_window_close", 0, nil)
                                TipDlg.drawTextDailog(string_map_rattling_info[12])
                            else
                                response.node:onUpdateDraw()
                            end
                        end
                    end
                end
                
                protocol_command.city_resource_refrush.param_list = instance._city_id.."\r\n"..instance._city_resourceId
                NetworkManager:register(protocol_command.city_resource_refrush.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_rattling_search_terminal)
        state_machine.add(map_rattling_updatedraw_terminal)
        state_machine.add(map_rattling_update_info_terminal)
        state_machine.add(map_rattling_buy_attack_times_terminal)
        state_machine.add(map_rattling_open_invite_terminal)
        state_machine.add(map_rattling_open_battle_report_terminal)
        state_machine.add(map_rattling_move_my_role_to_pos_terminal)
        state_machine.add(map_rattling_reqeust_refresh_resource_info_terminal)
        state_machine.init()
    end
    init_map_rattling_terminal()
end

function MapRattling:resetAllInfo(city_id, resource_id, resource_index)
    self:unregisterOnNoteUpdate(self)
    self._city_id = city_id
    self._resource_id = resource_id
    self._resource_index = resource_index
    if self._resource_index == nil 
        or _ED.city_resource_hold_resource_infos == nil 
        or _ED.city_resource_hold_resource_infos[self._resource_index] == nil then
        return nil
    end
    self._city_resourceId = _ED.city_resource_hold_resource_infos[self._resource_index].id
    self:onUpdateDraw()
    self:registerOnNoteUpdate(self, 0.1)
end

function MapRattling:sureBuy(sure_number)
    local function responseCallBack( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:onUpdateDraw()
                state_machine.excute("map_rattling_infomation_update_times", 0, nil)
            end
        end
    end
    if sure_number == 0 then
        NetworkManager:register(protocol_command.city_resource_hold_buy_robot_count.code, nil, nil, nil, self, responseCallBack, false, nil)      
    end
end

function MapRattling:onUpdateDraw()
    cacher.addTextures(config_res.images_cached["map_rattling"])
    self:loadingEffect()
    local root = self.roots[1]
    local Text_evy_speed_n = ccui.Helper:seekWidgetByName(root,"Text_evy_speed_n")
    local Text_last_time_n = ccui.Helper:seekWidgetByName(root,"Text_last_time_n")
    local Panel_rec_icon = ccui.Helper:seekWidgetByName(root,"Panel_rec_icon")
    local Text_rec_name = ccui.Helper:seekWidgetByName(root,"Text_rec_name")
    local Text_attck_n = ccui.Helper:seekWidgetByName(root,"Text_attck_n")
    local Text_rec_infor = ccui.Helper:seekWidgetByName(root,"Text_rec_infor")
    for i=1,11 do
        local Panel_house = ccui.Helper:seekWidgetByName(root,"Panel_house_"..i)
        Panel_house:removeAllChildren(true)
    end
    local Panel_3 = ccui.Helper:seekWidgetByName(root,"Panel_3") -- 资源详情
    local Button_build_rank = ccui.Helper:seekWidgetByName(root,"Button_build_rank") -- 资源点
    local Panel_rattling_empty = ccui.Helper:seekWidgetByName(root,"Panel_rattling_empty") -- 前往搜索层
    local Button_search_1 = ccui.Helper:seekWidgetByName(root,"Button_search_1") -- 前往搜索按钮
    Panel_3:setVisible(true)
    Button_build_rank:setVisible(true)
    Panel_rattling_empty:setVisible(false)
    Button_search_1:setVisible(false)
    if tonumber(self._city_id) == 0 then
        Panel_3:setVisible(false)
        Button_build_rank:setVisible(false)
        Panel_rattling_empty:setVisible(true)
    Button_search_1:setVisible(true)
        return
    end
    if _ED.city_resource_hold_resource_user_infos ~= nil then
        for k,v in pairs(_ED.city_resource_hold_resource_user_infos) do
            local Panel_house = ccui.Helper:seekWidgetByName(root, "Panel_house_"..k)
            local cell = state_machine.excute("map_rattling_build_create_cell", 0, {k, v, self._resource_index})
            Panel_house:addChild(cell)
            if tonumber(v.resource_level) == 1 then
                self._big_resource_id = v.id
            end
        end
    end

    local city_resource_data = dms.element(dms["city_resource_mould"], self._resource_id)
    local resourceType = dms.atoi(city_resource_data, city_resource_mould.resourceType)
    local quality = dms.atoi(city_resource_data, city_resource_mould.quality)
    local resource_pic = dms.atoi(city_resource_data, city_resource_mould.resource_pic)
    local distributes = dms.atos(city_resource_data, city_resource_mould.distribute)
    local speed = dms.atoi(city_resource_data, city_resource_mould.speed)

    if resourceType == 33 then
        Panel_rec_icon:setBackGroundImage(config_res.images.ui.props.props_4019)
    elseif resourceType == 1 then
        Panel_rec_icon:setBackGroundImage(config_res.images.ui.props.props_4002)
    elseif resourceType == 2 then
        Panel_rec_icon:setBackGroundImage(config_res.images.ui.props.props_4001)
    else
        Panel_rec_icon:setBackGroundImage(config_res.images.ui.props.props_4008)
    end

    local resource_info = _ED.city_resource_hold_resource_infos[tonumber(self._resource_index)]
    -- if tonumber(resource_info.open_state) == 0 then
    --     self._tick_time = tonumber(resource_info.leave_time)
    -- else
    --     self._tick_time = resource_info.use_os_time
    -- end

    -- if tonumber(resource_info.open_state) == 1 then
    --     -- self:registerOnNoteUpdate(self, 0.1)
    --     self._isNeedTick = true
    -- else
    --     -- self:unregisterOnNoteUpdate(self, 0.1)
    --     self._isNeedTick = false
    -- end

    self._tick_time = resource_info.end_time/1000 - (os.time() + _ED.time_add_or_sub)
    self._isNeedTick = true

    Text_rec_name:setString(distributes)
    Text_rec_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    
    Text_evy_speed_n:setString(string.format(string_map_rattling_info[2], speed))
    local add_speed = dms.int(dms["city_resource_hold_config"], 5, city_resource_hold_config.param)
    Text_rec_infor:setString(string.format(string_map_rattling_info[8], add_speed.."%"))
    Text_last_time_n:setString(self:formatTimeString(self._tick_time))
    local init_count = dms.string(dms["city_resource_hold_config"], 6, city_resource_hold_config.param)
    Text_attck_n:setString(_ED.city_resource_user_info.robotCount.."/"..init_count)

    if tonumber(_ED.city_world_map_id_backup) == tonumber(self._city_id) then
        ccui.Helper:seekWidgetByName(root,"Button_search_1"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root,"Button_search_1"):setVisible(true)
    end
end

function MapRattling:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function MapRattling:onUpdate( dt )
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    if tonumber(self._city_id) == 0 then
        return
    end
    self._refresh_tick_time = self._refresh_tick_time - dt
    if self._refresh_tick_time <= 0 then
        self._refresh_tick_time = 5
        state_machine.excute("map_rattling_reqeust_refresh_resource_info", 0, nil)
    end
    if self._isNeedTick == false then
        return
    end
    if self._tick_time <= 0 then
        self._tick_time = 0
        self._isNeedTick = false
        -- self:unregisterOnNoteUpdate(self)
    else
        self._tick_time = self._tick_time - dt
    end
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_last_time_n"):setString(self:formatTimeString(self._tick_time))
end

function MapRattling:onEnterTransitionFinish()

end

function MapRattling:loadingEffect()
    -- 资源点收获动画加载
    for i, v in pairs(config_res.sprites_cached["map_rattling"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    local effect_paths = nil 
    for i, v in pairs(config_res.armatures_cached["map_rattling"]) do
        effect_paths = v
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    end
end

function MapRattling:onInit( )
    cacher.addTextures(config_res.images_cached["map_rattling"])
    self:loadingEffect()

    local csbItem = csb.createNode(config_csb.big_map.map_rattling)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "map_rattling_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_visite"), nil, 
    {
        terminal_name = "map_rattling_open_invite", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_grand"), nil, 
    {
        terminal_name = "map_rattling_open_battle_report", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_search_1"), nil, 
    -- {
    --     terminal_name = "map_rattling_search", 
    --     terminal_state = 0, 
    --     touch_scale = true,
    --     touch_scale_xy = 0.95, 
    -- }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attck_add"), nil, 
    {
        terminal_name = "map_rattling_buy_attack_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_build_rank"), nil, 
    {
        terminal_name = "map_rattling_ranking_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_search_1"), nil, 
    {
        terminal_name = "map_rattling_ranking_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end

function MapRattling:init(params)
    self._city_id = params[1]
    self._resource_id = params[2]
    self._resource_index = tonumber(params[3])
    if self._resource_index ~= 0 then
        if self._resource_index == nil 
            or _ED.city_resource_hold_resource_infos == nil 
            or _ED.city_resource_hold_resource_infos[self._resource_index] == nil then
            return nil
        end
        self._city_resourceId = _ED.city_resource_hold_resource_infos[self._resource_index].id
    end
    self:onInit()
    return self
end

function MapRattling:onLoad()

end

function MapRattling:onExit()
    state_machine.remove("map_rattling_search")
    state_machine.remove("map_rattling_update_info")
    state_machine.remove("map_rattling_buy_attack_times")
    state_machine.remove("map_rattling_open_invite")
    state_machine.remove("map_rattling_open_battle_report")
    state_machine.remove("map_rattling_move_my_role_to_pos")
    state_machine.remove("map_rattling_reqeust_refresh_resource_info")
end
