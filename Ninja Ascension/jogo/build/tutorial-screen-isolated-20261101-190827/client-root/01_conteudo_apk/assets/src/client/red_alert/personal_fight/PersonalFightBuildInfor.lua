-----------------------------
-- 个人战敌方信息
-----------------------------
PersonalFightBuildInfor = class("PersonalFightBuildInforClass", Window)

local personal_fight_build_infor_open_terminal = {
	_name = "personal_fight_build_infor_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local index = params.index
        local function requestInfo( info, isBattleField )
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(PersonalFightBuildInfor:new():init(info, isBattleField),fwin._ui)
                end
            end
            protocol_command.user_stronghold_plunder_view.param_list = info.user_id .. "\r\n" .. info.user_server_number .. "\r\n" .. info.current_server_number
            NetworkManager:register(protocol_command.user_stronghold_plunder_view.code, nil, nil, nil, nil, responseCallback, false, nil)
        end

        if index ~= nil then
            requestInfo(_ED.presonal_fighting_map_info[index], false)
        else
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    requestInfo(_ED.presonal_fighting_map_other_info, true)
                end
            end
            protocol_command.user_stronghold_plunder_search.param_list = params.userId .. "\r\n" .. params.user_server_number .. "\r\n" .. params.current_server_number
            NetworkManager:register(protocol_command.user_stronghold_plunder_search.code, nil, nil, nil, nil, responseCallback, false, nil)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local personal_fight_build_infor_close_terminal = {
	_name = "personal_fight_build_infor_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PersonalFightBuildInforClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(personal_fight_build_infor_open_terminal)
state_machine.add(personal_fight_build_infor_close_terminal)
state_machine.init()

function PersonalFightBuildInfor:ctor()
	self.super:ctor()
	self.roots = {}

    self._chooseCityId = 0

    self._isBattleField = false

    app.load("client.red_alert.cells.battle.battle_ui_icon_cell")
    app.load("client.red_alert.cells.hero.hero_icon_cell")
    app.load("client.utils.ConfirmTip")

    local function init_personal_fight_build_infor_terminal()
        local personal_fight_build_infor_fight_terminal = {
            _name = "personal_fight_build_infor_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local attack_times = 0              -- 复仇或掠夺次数,-1已复仇或已掠夺，>=0 挑战次数
                if instance._isBattleField == true then -- 复仇状态
                    attack_times = tonumber(instance._info.be_attack_times)
                else                                -- 掠夺状态
                    attack_times = tonumber(instance._info.user_state)
                end
                -- 获取攻击次数对应消耗显示
                local cost = 0
                if attack_times == 0 then -- 第一次攻击消耗铜币
                    cost = dms.string(dms["user_stronghold_config"], 6, user_stronghold_config.info)
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureFight, string.format(red_alert_all_str[231], cost))
                    fwin:open(tip, fwin._ui)
                else    -- 第二次往后消耗元宝
                    local costs = zstring.split(dms.string(dms["user_stronghold_config"], 17, user_stronghold_config.info), ",")
                    if attack_times + 1 >= table.nums(costs) then 
                        cost = tonumber(costs[table.nums(costs)])
                    else
                        cost = costs[attack_times + 1]
                    end
                    if zstring.tonumber(cost) <= zstring.tonumber(_ED.user_info.user_gold) then
                        local tip = ConfirmTip:new()
                        tip:init(instance, instance.sureFight, string.format(red_alert_all_str[248], cost))
                        fwin:open(tip, fwin._ui)
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
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local personal_fight_build_infor_get_information_terminal = {
            _name = "personal_fight_build_infor_get_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local need_gold = dms.int(dms["user_stronghold_config"], 5, user_stronghold_config.info)
                if zstring.tonumber(need_gold) <= zstring.tonumber(_ED.user_info.user_gold) then
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.onUpdateSendInfo, string.format(red_alert_all_str[228], need_gold))
                    fwin:open(tip, fwin._ui)
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

        state_machine.add(personal_fight_build_infor_fight_terminal)
        state_machine.add(personal_fight_build_infor_get_information_terminal)
        state_machine.init()
    end

    init_personal_fight_build_infor_terminal()
end

function PersonalFightBuildInfor:onUpdateSendInfo(n)
    if n ~= 0 then
        return
    end
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                -- _ED.presonal_fighting_map_info[response.node._index].is_have_info = 1
                -- response.node:updateDraw()
            end
        end
    end
    protocol_command.user_stronghold_plunder_view.param_list = self._info.user_id .. "\r\n" .. self._info.user_server_number .. "\r\n" .. self._info.current_server_number
    NetworkManager:register(protocol_command.user_stronghold_plunder_view.code, nil, nil, nil, self, responseCallback, false, nil)
end

function PersonalFightBuildInfor:sureFight(sure_number)
    if sure_number == 0 then
        app.load("client.red_alert.battle.battle_enum")
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    protocol_command.battle_result_verify.param_list = response.node._info.user_id
                    app.load("client.red_alert.battle.battle_loading")
                    state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_105)
                end
            end
        end
        local scene_npc_tab = dms.string(dms["user_stronghold_config"], 7, user_stronghold_config.info)
        scene_npc_tab = zstring.split(scene_npc_tab, ",")
        local scene_id = scene_npc_tab[1]
        local npc_id = scene_npc_tab[2]
        local battle_field = "0"
        if self._isBattleField == true then
            battle_field = "1"
        end
        _ED._current_scene_id = scene_id
        _ED._scene_npc_id = npc_id
        _ED._npc_difficulty_index = "1"
        _ED._battle_init_type = battle_enum._fight_type._fight_type_105
        _ED._battle_type_params = {self._info.user_id, self._info.user_server_number, self._info.current_server_number, battle_field}
        protocol_command.battle_result_start.param_list = battle_enum._fight_type._fight_type_105.."\r\n"..self._info.user_id.."\r\n"..self._info.user_server_number.."\r\n"..self._info.current_server_number.."\r\n"..battle_field
        NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function PersonalFightBuildInfor:updateDraw()
    local root = self.roots[1]
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_player_icon")
    local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name")
    local Text_player_legion_name = ccui.Helper:seekWidgetByName(root,"Text_player_legion_name")
    local ListView_battle_ui = ccui.Helper:seekWidgetByName(root,"ListView_battle_ui")
    local Text_17 = ccui.Helper:seekWidgetByName(root,"Text_17")
    local Panel_attack = ccui.Helper:seekWidgetByName(root,"Panel_attack")
    local Text_attack_gold_n = ccui.Helper:seekWidgetByName(root,"Text_attack_gold_n")
    local Text_look_gem_n = ccui.Helper:seekWidgetByName(root,"Text_look_gem_n")
    local Text_attack_gold_n_0 = ccui.Helper:seekWidgetByName(root,"Text_attack_gold_n_0")
    local Panel_look_infor = ccui.Helper:seekWidgetByName(root,"Panel_look_infor")
    local Text_score = ccui.Helper:seekWidgetByName(root,"Text_res_icon_n_5")               --玩家积分信息
    local Image_2_1 = ccui.Helper:seekWidgetByName(root,"Image_2_1")                        -- 铜币icon
    local Image_gem_icon = ccui.Helper:seekWidgetByName(root,"Image_gem_icon")              -- 元宝icon
    local Text_yfc = ccui.Helper:seekWidgetByName(root,"Text_yfc")
    Image_2_1:setVisible(false)
    Image_gem_icon:setVisible(false)
    Panel_player_icon:removeAllChildren(true)
    Text_player_name:setString("")
    Text_score:setString("")
    Text_player_legion_name:setString("")
    ListView_battle_ui:removeAllItems()
    Text_17:setVisible(true)
    Panel_attack:setVisible(true)
    Panel_look_infor:setVisible(false)
    Text_yfc:setVisible(false)

    local attack_times = 0              -- 复仇或掠夺次数,-1已复仇或已掠夺，>=0 挑战次数
    if self._isBattleField == true then -- 复仇状态
        attack_times = tonumber(self._info.be_attack_times)
    else                                -- 掠夺状态
        attack_times = tonumber(self._info.user_state)
    end

    -- 获取攻击次数对应消耗显示
    local cost = 0
    if attack_times == 0 then -- 第一次攻击消耗铜币
        cost = dms.string(dms["user_stronghold_config"], 6, user_stronghold_config.info)
        Image_2_1:setVisible(true)
    else    -- 第二次往后消耗元宝
        local costs = zstring.split(dms.string(dms["user_stronghold_config"], 17, user_stronghold_config.info), ",")
        if attack_times + 1 >= table.nums(costs) then 
            cost = tonumber(costs[table.nums(costs)])
        else
            cost = costs[attack_times + 1]
        end
        Image_gem_icon:setVisible(true)
    end
    Text_attack_gold_n:setString(cost)
    Text_look_gem_n:setString(dms.string(dms["user_stronghold_config"], 5, user_stronghold_config.info))
    Text_attack_gold_n_0:setString(cost)
    for i=1,4 do
        local Text_res_icon_n = ccui.Helper:seekWidgetByName(root,"Text_res_icon_n_"..i)
        Text_res_icon_n:setString("")
    end

    local user_data = {
        user_level = self._info.user_level,
        user_sex = self._info.user_gender,
        user_camp = 1
    }
    local headCell = state_machine.excute("user_head_icon_create", 0, {user_data, 5})
    Panel_player_icon:addChild(headCell)

    -- 显示积分
    Text_score:setString("0")

    if tonumber(self._info.user_fighting) > tonumber(_ED.user_info.fighter_capacity) then
        -- 个人争夺战其他战力比自己高的颜色
        Text_player_legion_name:setColor(cc.c3b(red_alert_war_city_map_color[6][1], red_alert_war_city_map_color[6][2], red_alert_war_city_map_color[6][3]))
        Text_player_name:setColor(cc.c3b(red_alert_war_city_map_color[6][1], red_alert_war_city_map_color[6][2], red_alert_war_city_map_color[6][3]))
        if attack_times >= 0 then
            Text_score:setString("3")
        end
    else
        -- 个人争夺战其他战力比自己低的颜色
        Text_player_legion_name:setColor(cc.c3b(red_alert_war_city_map_color[8][1], red_alert_war_city_map_color[8][2], red_alert_war_city_map_color[8][3]))
        Text_player_name:setColor(cc.c3b(red_alert_war_city_map_color[8][1], red_alert_war_city_map_color[8][2], red_alert_war_city_map_color[8][3]))
        if attack_times >= 0 then
            Text_score:setString("2")
        end
    end

    -- 显示已复仇状态
    if self._isBattleField == true and attack_times == -1 then
        Text_yfc:setVisible(true)
        Panel_attack:setVisible(false)
    end

    local server_number = 0
    local server_info = _ED.all_servers[""..self._info.user_server_number]
    if server_info ~= nil and server_info.server_code ~= nil and tonumber(server_info.server_code) ~= nil then
        server_number = server_info.server_code
    end
    local server_flag = ""
    if server_info ~= nil and server_info.server_flag ~= nil then
        server_flag = server_info.server_flag
    end
    -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
    --     if server_info ~= nil and server_info.server_code ~= nil then
    --         Text_player_name:setString(self._info.user_name.."("..server_info.server_code..")")
    --     else
    --         Text_player_name:setString(self._info.user_name)
    --     end
    -- else
    --     Text_player_name:setString(string.format(red_alert_all_str[239], self._info.user_name, server_number))
    -- end
    Text_player_name:setString(string.format(red_alert_all_str[239], self._info.user_name, server_flag, server_number))
    
    if _ED.presonal_fighting_infomation ~= nil then
        local more_info = _ED.presonal_fighting_infomation[""..self._info.user_id]
        if more_info ~= nil then
            Text_17:setVisible(false)
            Text_player_legion_name:setString(self._info.user_fighting)
            
            for k,v in pairs(more_info.formation_list) do
                local cell = state_machine.excute("battle_ui_icon_cell",0,{v})
                state_machine.excute("battle_ui_icon_cell_update_hp", 0, {cell = cell, role = nil, shipId = nil, hp = v.lessHp, maxHp = v.maxHp})
                ListView_battle_ui:addChild(cell)
            end

            local isHaveResource = false
            for k,v in pairs(more_info.resource_list) do
                local Text_res_icon_n = ccui.Helper:seekWidgetByName(root,"Text_res_icon_n_"..k)
                Text_res_icon_n:setString(0)
                if tonumber(v.resource_id) > 0 and tonumber(v.resource_time) > 0 then
                    local update_id = dms.int(dms["build_mould"], v.resource_id, build_mould.update_id)
                    -- 仓库保护值
                    local mould_id = dms.int(dms["build_mould"],more_info.storage_build_mould_id,build_mould.update_id)
                    local storage_info = _ED.build_escalate_info[""..mould_id]
                    local max_volumn_teams = storage_info[""..more_info.storage_build_mould_level].max_volumn_teams
                    max_volumn_teams = zstring.split(max_volumn_teams, ",")

                    local info = _ED.build_escalate_info[""..update_id][""..v.resource_level]
                    local max_volumn = zstring.tonumber(info.max_volumn)
                    local output_count = zstring.tonumber(info.output_count)
                    local output_time = zstring.tonumber(info.output_time)
                    local output_deviation = zstring.tonumber(v.output_deviation)
                    local current_count = math.floor((os.time() + _ED.time_add_or_sub - tonumber(v.resource_time))/output_time * output_count)
                    if current_count >= max_volumn then
                        current_count = max_volumn
                    end
                    current_count = current_count - output_deviation - max_volumn_teams[k]
                    if current_count <= 0 then
                        current_count = 0
                    end
                    isHaveResource = true
                    Text_res_icon_n:setString(current_count)
                end
            end
            if isHaveResource == false and attack_times >= 0 then
                local resources = zstring.split(dms.string(dms["user_stronghold_config"], 8, user_stronghold_config.info), ",")
                for k,v in pairs(resources) do
                    if tonumber(v) > 0 then
                        ccui.Helper:seekWidgetByName(root,"Text_res_icon_n_"..k):setString(v)
                    end
                end
            end
            if self._isBattleField == true then
                for i=1,4 do
                    ccui.Helper:seekWidgetByName(root,"Text_res_icon_n_"..i):setString(red_alert_all_str[251])
                end
            end
        end
    end
end

function PersonalFightBuildInfor:onInit()
    local csbItem = csb.createNode(config_csb.palyer_build.palyer_build_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_player"), nil, 
    {
        terminal_name = "personal_fight_build_infor_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_infor"), nil, 
    {
        terminal_name = "personal_fight_build_infor_get_information",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attack"), nil, 
    {
        terminal_name = "personal_fight_build_infor_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attack_1"), nil, 
    {
        terminal_name = "personal_fight_build_infor_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)

    self:updateDraw()
end

function PersonalFightBuildInfor:onEnterTransitionFinish()
    
end

function PersonalFightBuildInfor:init(info, isBattleField)
    self._info = info
    self._isBattleField = isBattleField
	self:onInit()
    return self
end

function PersonalFightBuildInfor:onExit()
    state_machine.remove("personal_fight_build_infor_fight")
    state_machine.remove("personal_fight_build_infor_get_information")
end