-----------------------------
-- 资源点其他用户信息
-----------------------------
MapRattlingInfomation = class("MapRattlingInfomationClass", Window)

local map_rattling_infomation_window_open_terminal = {
    _name = "map_rattling_infomation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("MapRattlingInfomationClass")
        if nil == _Window then
            fwin:open(MapRattlingInfomation:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local map_rattling_infomation_window_close_terminal = {
    _name = "map_rattling_infomation_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MapRattlingInfomationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattling_infomation_window_open_terminal)
state_machine.add(map_rattling_infomation_window_close_terminal)
state_machine.init()

function MapRattlingInfomation:ctor()
    self.super:ctor()
    self.roots = {}

    self._info = nil
    self._resource_index = 0
    _ED.city_resource_battle_attack_additional = 0

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")

    local function init_map_rattling_infomation_terminal()
        local map_rattling_infomation_challenge_terminal = {
            _name = "map_rattling_infomation_challenge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.city_resource_user_info.robotCount) <= 0 then
                    state_machine.excute("map_rattling_buy_attack_times", 0, nil)
                    return
                end
                instance.send_type = params._datas.ntype
                if _ED.city_resource_user_info ~= nil 
                    and params._datas.ntype == 1 
                    and tonumber(_ED.city_resource_user_info.resource_hold_id) > 0 then
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureFight, string_map_rattling_info[11])
                    fwin:open(tip, fwin._windows)
                else
                    instance:sureFight(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_infomation_inspire_terminal = {
            _name = "map_rattling_infomation_inspire",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local need_gold = dms.int(dms["city_resource_hold_config"], 10, city_resource_hold_config.param)
                if zstring.tonumber(cost) <= zstring.tonumber(_ED.user_info.user_gold) then
                    instance:quxSureTip()
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

        local map_rattling_infomation_give_up_terminal = {
            _name = "map_rattling_infomation_give_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("map_rattling_update_info", 0, nil)
                        state_machine.excute("map_rattling_infomation_window_close", 0, nil)
                    end
                end
                protocol_command.city_resource_un_hold.param_list = instance._info.city_id.."\r\n"..instance._info.resource_id.."\r\n"..instance._info.id
                NetworkManager:register(protocol_command.city_resource_un_hold.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_infomation_update_times_terminal = {
            _name = "map_rattling_infomation_update_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateTimes()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_rattling_infomation_challenge_terminal)
        state_machine.add(map_rattling_infomation_inspire_terminal)
        state_machine.add(map_rattling_infomation_give_up_terminal)
        state_machine.add(map_rattling_infomation_update_times_terminal)
        state_machine.init()
    end
    init_map_rattling_infomation_terminal()
end

function MapRattlingInfomation:sureFight(sure_number)
    if sure_number == 0 then
        app.load("client.red_alert_time.battle.battle_enum")
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    protocol_command.battle_result_verify.param_list = response.node._info.city_id.."\r\n"..response.node._info.resource_id.."\r\n"..response.node._info.id.."\r\n".._ED.city_resource_user_position_info.userId.."\r\n"..response.node.send_type
                    app.load("client.red_alert_time.battle.battle_loading")
                    state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_23)
                end
            end
        end
        _ED.city_resource_battle_end_info = {self._info.city_id, self._info.resource_mould_id, self._resource_index}
        local scene_npc_tab = dms.string(dms["city_resource_hold_config"], 14, city_resource_hold_config.param)
        scene_npc_tab = zstring.split(scene_npc_tab, ",")
        local scene_id = scene_npc_tab[1]
        local npc_id = scene_npc_tab[2]
        _ED._current_scene_id = scene_id
        _ED._scene_npc_id = npc_id
        _ED._npc_difficulty_index = "1"
        _ED._battle_init_type = battle_enum._fight_type._fight_type_23
        _ED._battle_type_params = {_ED.city_resource_user_position_info.userId}
        protocol_command.battle_result_start.param_list = battle_enum._fight_type._fight_type_23.."\r\n"..self._info.city_id.."\r\n"..self._info.resource_id.."\r\n"..self._info.id.."\r\n".._ED.city_resource_user_position_info.userId.."\r\n"..self.send_type
        NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function MapRattlingInfomation:quxSureTip()
    local tip = ConfirmTip:new()
    local need_gold = dms.int(dms["city_resource_hold_config"], 10, city_resource_hold_config.param)
    tip:init(self, self.onUpdateSendInfo, string.format(string_map_rattling_info[4], need_gold))
    fwin:open(tip, fwin._ui)
end

function MapRattlingInfomation:onUpdateSendInfo(n)
    if n ~= 0 then
        return
    end
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                state_machine.excute("map_rattling_update_info", 0, nil)
                for k,v in pairs(_ED.city_resource_hold_resource_user_infos) do
                    if tonumber(v.id) == tonumber(response.node._info.id) then
                        response.node._info = v
                    end
                end
                response.node:onUpdateDraw()
                TipDlg.drawTextDailog(string_map_rattling_info[10])
            end
        end
    end
    protocol_command.city_resource_hold_encourage.param_list = self._info.city_id.."\r\n"..self._info.resource_id
    NetworkManager:register(protocol_command.city_resource_hold_encourage.code, nil, nil, nil, self, responseCallback, false, nil)
end

function MapRattlingInfomation:updateTimes( ... )
    local root = self.roots[1]
    local Text_spent_number = ccui.Helper:seekWidgetByName(root,"Text_spent_number")
    local init_count = dms.string(dms["city_resource_hold_config"], 6, city_resource_hold_config.param)
    Text_spent_number:setString(_ED.city_resource_user_info.robotCount.."/"..init_count)
end

function MapRattlingInfomation:onUpdateDraw()
    local root = self.roots[1]
    local Panel_header = ccui.Helper:seekWidgetByName(root,"Panel_header")
    local Text_level = ccui.Helper:seekWidgetByName(root,"Text_level")
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local Text_combat_unmber = ccui.Helper:seekWidgetByName(root,"Text_combat_unmber")
    local Text_resources = ccui.Helper:seekWidgetByName(root,"Text_resources")
    local Text_resources_number = ccui.Helper:seekWidgetByName(root,"Text_resources_number")
    local Text_spent_number = ccui.Helper:seekWidgetByName(root,"Text_spent_number")
    local Panel_resources_icon = ccui.Helper:seekWidgetByName(root,"Panel_resources_icon")
    Panel_resources_icon:removeBackGroundImage()
    local Text_legion_n = ccui.Helper:seekWidgetByName(root,"Text_legion_n")
    local Text_inspire_t = ccui.Helper:seekWidgetByName(root,"Text_inspire_t")

    local Panel_but_1 = ccui.Helper:seekWidgetByName(root,"Panel_but_1")
    local Panel_but_4 = ccui.Helper:seekWidgetByName(root,"Panel_but_4")
    Panel_but_1:setVisible(false)
    Panel_but_4:setVisible(false)
    Text_resources:setString("")
    Text_resources_number:setString("")
    Panel_resources_icon:removeBackGroundImage()

    local inspire_times = tonumber(_ED.city_resource_hold_resource_infos[self._resource_index].inspire_times)
    if tonumber(self._info.resource_level) == 1
        and inspire_times > 0 
        then
        local pre = dms.int(dms["city_resource_hold_config"], 11, city_resource_hold_config.param)
        Text_inspire_t:setString(string.format(string_map_rattling_info[5], inspire_times, inspire_times*pre.."%", inspire_times*pre.."%"))
        _ED.city_resource_battle_attack_additional = inspire_times*pre/100
    end

    if tonumber(self._info.user_id) == tonumber(_ED.user_info.user_id) then
        Panel_but_4:setVisible(true)
    else
        Panel_but_1:setVisible(true)
    end

    for i=1,3 do
        local Image_nationnal = ccui.Helper:seekWidgetByName(root,"Image_nationnal_"..i)
        Image_nationnal:setVisible(false)
    end
    local ListView_squad = ccui.Helper:seekWidgetByName(root,"ListView_squad")
    ListView_squad:removeAllItems()

    local user_data = {
        user_level = _ED.city_resource_user_position_info.userLevel,
        user_sex = _ED.city_resource_user_position_info.userGender,
        user_camp = _ED.city_resource_user_position_info.userCamp
    }
    local head_icon = state_machine.excute("user_head_icon_create",0,{user_data,1})
    Panel_header:removeAllChildren(true)
    Panel_header:addChild(head_icon)

    local init_count = dms.string(dms["city_resource_hold_config"], 6, city_resource_hold_config.param)
    Text_spent_number:setString(_ED.city_resource_user_info.robotCount.."/"..init_count)

    Text_name:setString(_ED.city_resource_user_position_info.userName)
    Text_combat_unmber:setString(_ED.city_resource_user_position_info.userFighting)
    local need_gold = dms.int(dms["city_resource_hold_config"], 10, city_resource_hold_config.param)
    if _ED.city_resource_user_position_info.unionName == "" then
        Text_legion_n:setString(string_map_rattling_info[1])
    else
        Text_legion_n:setString(_ED.city_resource_user_position_info.unionName)
    end
    local uesr_resources_number = dms.int(dms["city_resource_hold_config"], 8, city_resource_hold_config.param)
    if _ED.city_resource_user_position_info.canGetResource ~= "" then
        local reward_info = zstring.split(_ED.city_resource_user_position_info.canGetResource, ",")
        if reward_info ~= "" and #reward_info > 0 then
            if tonumber(_ED.city_resource_user_position_info.userId) == tonumber(_ED.user_info.user_id) then
                Text_resources:setString(string_map_rattling_info[13])
                Text_resources_number:setString(math.floor(reward_info[3]/(uesr_resources_number/100)))
            else
                Text_resources:setString(string_map_rattling_info[14])
                Text_resources_number:setString(reward_info[3])
            end
            if tonumber(reward_info[3]) == 0 then
                Text_resources_number:setString(string_map_rattling_info[1])
                Panel_resources_icon:removeBackGroundImage()
            end
            if tonumber(reward_info[2]) == 33 then
                Panel_resources_icon:setBackGroundImage(config_res.images.ui.props.props_4019)
            elseif tonumber(reward_info[2]) == 1 then
                Panel_resources_icon:setBackGroundImage(config_res.images.ui.props.props_4002)
            elseif tonumber(reward_info[2]) == 2 then
                Panel_resources_icon:setBackGroundImage(config_res.images.ui.props.props_4001)
            else
                Panel_resources_icon:setBackGroundImage(config_res.images.ui.props.props_4008)
            end
        end
    end

    local official = dms.int(dms["arena_reward_param"], _ED.city_resource_user_position_info.userInfoOfferId,
        arena_reward_param.arena_official)
    if official ~= nil then
        Text_level:setString(red_alert_officer[official])
        local color_table = red_alert_officer_color[official]
        Text_level:setColor(cc.c3b(color_table[1], color_table[2], color_table[3]))
    else
        Text_level:setString("")
    end

    local ships = zstring.split(_ED.city_resource_user_position_info.shipMouldIds, ",")
    for i,shipId in pairs(ships) do
        local cell = state_machine.excute("hero_icon_create_cell", 0, {shipId, 4, i})
        ListView_squad:addChild(cell)
    end
    ListView_squad:requestRefreshView()
end

function MapRattlingInfomation:onEnterTransitionFinish()

end

function MapRattlingInfomation:onInit( )
    local csbItem = csb.createNode(config_csb.big_map.map_rattling_player_information)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "map_rattling_infomation_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_challenge"), nil, 
    {
        terminal_name = "map_rattling_infomation_challenge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 0,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_inspire"), nil, 
    {
        terminal_name = "map_rattling_infomation_challenge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_give_up"), nil, 
    {
        terminal_name = "map_rattling_infomation_give_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
	self:onUpdateDraw()	
end

function MapRattlingInfomation:init(params)
    self._info = params[1]
    self._resource_index = params[2]
	self:onInit()
    return self
end

function MapRattlingInfomation:onExit()
    state_machine.remove("map_rattling_infomation_challenge")
    state_machine.remove("map_rattling_infomation_inspire")
    state_machine.remove("map_rattling_infomation_give_up")
    state_machine.remove("map_rattling_infomation_update_times")
end
