--------------------------------------------------------------------------------------------------------------
--  说明：阵容防守
--------------------------------------------------------------------------------------------------------------
FormationDefend = class("FormationDefendClass", Window)

--打开界面
local formation_defend_open_terminal = {
	_name = "formation_defend_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = FormationDefend:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local formation_defend_close_terminal = {
	_name = "formation_defend_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationDefendClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local formation_choose_max_fighting_formation_terminal = {
    _name = "formation_choose_max_fighting_formation",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("formation_window_close", 0, 0)
        if 1 == params[1] then
            if __lua_project_id == __lua_project_pacific_rim then
                state_machine.excute("formation_window_open",0,{_datas = {form_type = 3, next_terminal = "formation_defend_add_defender_formation_info", next_terminal_params = params[2]}})
                -- state_machine.excute("formation_defend_add_defender_formation_info", 0, params[2])
            else
                state_machine.excute("pve_attack_begin_fight", 0, 0)
            end
        else
            state_machine.excute("pve_attack_close", 0, 0)
            missionChooseMaxFighting(params)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local formation_choose_reset_formation_terminal = {
    _name = "formation_choose_reset_formation",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- protocol_command.formation_save.param_list = "" .. 1 .. "\r\n" .. "0,0,0,0,0,0,0|0,0,0,0,0,0,0|0,0,0,0,0,0,0|0,0,0,0,0,0,0|0,0,0,0,0,0,0|0,0,0,0,0,0,0"
        -- NetworkManager:register(protocol_command.formation_save.code, nil, nil, nil, nil, nil, false, nil)
        _ED.attack_formation = nil
        cc.UserDefault:getInstance():setStringForKey(getKey("attack_formation"), "")
        _ED.attack_city_formation = nil
        cc.UserDefault:getInstance():setStringForKey(getKey("attack_city_formation"), "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

function missionChooseMaxFighting( params )
    local result = {}
    local leaders = {}
    for k,v in pairs(_ED.user_ship) do
        if v.captain_type ~= 3 then
            local last_count = zstring.tonumber(v.current_count)
            -- if self._form_type == 16 or self._form_type == 17 then
            --     last_count = zstring.tonumber(v.city_current_count)
            -- end 
            local index = 0
            while last_count > 0 and index < 6 do
                last_count = last_count - tonumber(_ED.user_info.soldier)
                if last_count >= 0 then
                    table.insert(result, {ship = v, count = tonumber(_ED.user_info.soldier)})
                else
                    table.insert(result, {ship = v, count = last_count + tonumber(_ED.user_info.soldier)})
                end
                index = index + 1
            end
        else
            if zstring.tonumber(v.current_count) > 0 then
                table.insert(leaders, {ship = v})
            end
        end
    end
    local function sortTank(a, b)
        local order_a = dms.int(dms["ship_mould"], a.ship.ship_template_id, ship_mould.base_mould_priority)
        local order_b = dms.int(dms["ship_mould"], b.ship.ship_template_id, ship_mould.base_mould_priority)
        return order_a > order_b
    end
    table.sort(result, sortTank)
    function sortLoad( a, b )
        return tonumber(getShipFightNumber(a.ship, tonumber(a.count))) > tonumber(getShipFightNumber(b.ship, tonumber(b.count)))
    end
    table.sort(result, sortLoad)

    local function sortLeader(a, b)
        return tonumber(getLeaderFighting(a.ship)) > tonumber(getLeaderFighting(b.ship))
    end
    table.sort(leaders, sortLeader)

    local formation_info = {}
    for k,v in pairs(result) do
        if k > 6 then
            break
        end
        table.insert(formation_info, {ship_id = v.ship.ship_id, count = v.count})
    end
    for k,v in pairs(leaders) do
        if k > 6 then
            break
        end
        if formation_info[k] ~= nil then
            formation_info[k].leader_id = v.ship.ship_id
        end
    end

    -- local reduce_count = {}
    -- for k, v in pairs(formation_info) do
    --     local ship_id = zstring.tonumber(v.ship_id)
    --     local count = zstring.tonumber(v.count)
    --     local leader_id = zstring.tonumber(v.leader_id)
    --     if ship_id > 0 then
    --         local current_count = 0
    --         for k1, v1 in pairs(_ED.user_ship) do
    --             if zstring.tonumber(v1.ship_id) == ship_id then
    --                 current_count = zstring.tonumber(v1.current_count)
    --                 break
    --             end
    --         end
    --         local reduce = zstring.tonumber(reduce_count[""..ship_id])
    --         local max_count = current_count - reduce
    --         if count > max_count then
    --             count = max_count
    --         end
    --     end
    --     v.count = count
    --     reduce_count[""..ship_id] = zstring.tonumber(reduce_count[""..ship_id]) + count
    --     if count <= 0 then
    --         formation_info[k] = {ship_id = 0, count = 0, leader_id = 0}
    --     else
    --         if leader_id > 0 then
    --             for k1, v1 in pairs(_ED.user_ship) do
    --                 if zstring.tonumber(v1.ship_id) == leader_id then
    --                     if tonumber(v1.current_count) <= 0 then
    --                         formation_info[k].leader_id = 0
    --                     end
    --                 end
    --             end
    --         end
    --     end
    -- end

    if type(params[1]) == "table" then
        if missionIsOver() == false then
            local tformation_info = {}
            for m, n in pairs(params[1]) do
                if n <= 0 then
                    tformation_info[m] = nil
                end
            end
            for i, v in pairs(formation_info) do
                local ship_id = v.ship_id
                local ship = _ED.user_ship[""..ship_id]
                for m, n in pairs(params[1]) do
                    if tonumber(ship.ship_base_template_id) == tonumber(n) then
                        tformation_info[m] = v
                        params[1][m] = 0
                        break
                    end
                end
            end
            formation_info = tformation_info
        end
    end

    if type(params[2]) == "table" then
        _ED._scene_npc_id = params[2][1]
        _ED._current_scene_id = params[2][2]
        _ED._battle_init_type = dms.int(dms["pve_scene"], _ED._current_scene_id, pve_scene.scene_type)
    end

    local att_str = ""
    for i=1,6 do
        local ship = nil
        local choose_count = 0
        local ship_id = 0
        local leader = nil
        if formation_info ~= nil and formation_info[i] ~= nil then
            ship_id = formation_info[i].ship_id
            local leader_id = formation_info[i].leader_id
            if zstring.tonumber(ship_id) > 0 then
                ship = _ED.user_ship[""..ship_id]
                choose_count = formation_info[i].count
                if zstring.tonumber(leader_id) > 0 then
                    leader = _ED.user_ship[""..leader_id]
                end
            end
        end

        if ship == nil then
            if i == 1 then
                att_str = att_str.."0,0,0,0,0,0,0"
            else
                att_str = att_str.."|0,0,0,0,0,0,0"
            end
        else
            local leader_info = ""
            if leader == nil then
                leader_info = "0,0"
            else
                leader_info = leader.ship_id..","..leader.ship_template_id
            end
            if i == 1 then
                att_str = att_str..ship.ship_id..","..ship.ship_template_id..","..choose_count..","..ship.attack_speed..","..choose_count..","..leader_info
            else
                att_str = att_str.."|"..ship.ship_id..","..ship.ship_template_id..","..choose_count..","..ship.attack_speed..","..choose_count..","..leader_info
            end
        end
    end
    state_machine.excute("adventure_mine_request_battle_field_init", 0, {_ED._battle_init_type, _ED._current_scene_id, _ED._scene_npc_id, "1", 0, att_str})
end

state_machine.add(formation_defend_open_terminal)
state_machine.add(formation_defend_close_terminal)
state_machine.add(formation_choose_max_fighting_formation_terminal)
state_machine.add(formation_choose_reset_formation_terminal)
state_machine.init()

function FormationDefend:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    --(1: 防守部队，    2：世界部队出征，3：pve部队出征，4：军团切磋, 5：军团切磋挑战
    -- 6: 军团副本出征，7：叛军出没,     8:远征，        9：极限挑战, 10:敌军来袭
    -- 11:战地争霸防守      12：守卫战防守   13：守卫战进攻, 14：军团争霸, 15:阵营对决, 
    -- 16:城市战进攻, 17:城市战防守，18：城市战部队兑换, 19: 工厂进攻，20：工厂防守)
    self._form_type = 0
	self._pve_operating_type = 0
    self._choose_formation = {}
    self._choose_leaders = {}

    self._isLightFight = nil
	
	self.attack_point_x = 0  --世界攻击的坐标
	self.attack_point_y = 0

    self._current_formation_index = 0

    self._is_save = true     -- true显示保存部队，否则显示撤离部队
    self._tankCellTab = {}
    self._tankLightList = {}
    self._leaderCellTab = {}
    self._leaderLightList = {}

    self._last_fight_number = nil
    self._current_fight_number = nil

    self._last_formation_info = nil

    self._arena_info = nil
    self._investigate_cell = nil

    app.load("client.red_alert_time.player.PlayerEnergyAdd")

    local function init_formation_defend_terminal()
        local formation_defend_show_terminal = {
            _name = "formation_defend_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_hide_terminal = {
            _name = "formation_defend_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_update_info_terminal = {
            _name = "formation_defend_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_choose_tanke_terminal = {
            _name = "formation_defend_choose_tanke",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                if instance._choose_formation[""..index].ship == nil then
                    state_machine.excute("formation_choose_troop_window_open", 0, {index, instance._choose_formation, instance._form_type})
                else
                    local info = {}
                    info.choose_formation_index = index
                    info.choose_ship = nil
                    info.choose_ship_count = 0
                    state_machine.excute("formation_defend_update_once_tank_info", 0, info)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_update_once_tank_info_terminal = {
            _name = "formation_defend_update_once_tank_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params.choose_formation_index
                local choose_ship = params.choose_ship
                local choose_ship_count = params.choose_ship_count
                instance._choose_formation[""..index].ship = choose_ship
                instance._choose_formation[""..index].choose_count = choose_ship_count
                instance:updateChooseInfo(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_choose_leader_terminal = {
            _name = "formation_defend_choose_leader",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(157, false) == true then
                    TipDlg.drawTextDailog(red_alert_time_str[86])
                    return
                end
                local index = params._datas.index
                if instance._choose_leaders[""..index].ship == nil then
                    state_machine.excute("formation_leader_choose_window_open", 0, {index, instance._choose_leaders})
                else
                    local info = {}
                    info.choose_formation_index = index
                    info.choose_ship = nil
                    state_machine.excute("formation_defend_update_once_leader_info", 0, info)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_update_once_leader_info_terminal = {
            _name = "formation_defend_update_once_leader_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params.choose_formation_index
                local choose_ship = params.choose_ship
                instance._choose_leaders[""..index].ship = choose_ship
                instance:updateChooseLeader(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_auto_choose_tanke_terminal = {
            _name = "formation_defend_auto_choose_tanke",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- TODO...auto choose formation tank
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_save_terminal = {
            _name = "formation_defend_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 需要消耗能量
                if instance._form_type == 2
                    or instance._form_type == 3
                    or instance._form_type == 7
                    or instance._form_type == 16
                    or instance._form_type == 17
                    or instance._form_type == 19
                    or instance._form_type == 20
                    then

                    local need_energy = true
                    if instance._form_type == 3 then
                        if _ED._battle_init_type == battle_enum._fight_type._fight_type_15
                            or (_ED._battle_init_type == battle_enum._fight_type._fight_type_1 and tonumber(_ED.parts_supply_remakes_times) > 0)
                            then
                            need_energy = false
                        end
                    end
                    if need_energy == true and tonumber(_ED.user_info.user_food) <= 0 then
                        state_machine.excute("player_energy_add_open", 0, "")
                        return
                    end
                end

                if instance._is_save == false           -- 撤离部队
                    and (instance._form_type == 1 or instance._form_type == 4)
                    then         
                    instance._choose_formation = {}
                    instance._choose_leaders = {}
                end

                if instance._form_type == 10        -- 克隆部队
                    or instance._form_type == 11
                    or instance._form_type == 9
                    or instance._form_type == 4
                    then
                    local formation_info = {}
                    for i = 1, 6 do
                        local info = {}
                        local tank_info = instance._choose_formation[""..i]
                        local leader = instance._choose_leaders[""..i]
                        if tank_info ~= nil and tank_info.ship ~= nil then
                            info.ship_id = tank_info.ship.ship_id
                            info.count = tank_info.choose_count
                        end
                        if leader ~= nil and leader.ship ~= nil then
                            info.leader_id = leader.ship.ship_id
                        end
                        formation_info[i] = info
                    end
                    formation_info = instance:adjustFormation(formation_info)
                    instance:updateFormation(formation_info)
                end

                local can_save = false
                local str = ""
                local att_str = ""
                for i = 1, 6 do
                    local info = instance._choose_formation[""..i]
                    local leader = instance._choose_leaders[""..i]
                    if info == nil or info.ship == nil then
                        if i == 1 then
                            str = str.."0,0,0,0,0,0,0"
                            att_str = att_str.."0,0,0,0,0,0,0"
                        else
                            str = str.."|0,0,0,0,0,0,0"
                            att_str = att_str.."|0,0,0,0,0,0,0"
                        end
                    else
						local ship_info = _ED.user_ship[""..info.ship.ship_id]
						local leader_info = ""
						if leader == nil or leader.ship == nil then
                            leader_info = "0,0"
                        else
                            leader_info = leader.ship.ship_id..",".._ED.user_ship[""..leader.ship.ship_id].ship_template_id
                        end
                        if i == 1 then
                            str = str..info.ship.ship_id..","..info.choose_count
                            att_str = att_str..info.ship.ship_id..","..info.ship.ship_template_id..","..info.choose_count..","..ship_info.attack_speed..","..info.choose_count..","..leader_info
                        else
                            str = str.."|"..info.ship.ship_id..","..info.choose_count
                            att_str = att_str.."|"..info.ship.ship_id..","..info.ship.ship_template_id..","..info.choose_count..","..ship_info.attack_speed..","..info.choose_count..","..leader_info
                        end
                        can_save = true
                        if leader == nil or leader.ship == nil then
                            str = str..",0,0"
                        else
                            str = str..","..leader.ship.ship_id..",".._ED.user_ship[""..leader.ship.ship_id].ship_template_id
                        end
                    end
                end
                if can_save == false and instance._is_save ~= false then
                    TipDlg.drawTextDailog(formation_type_string[14])
                    return
                end

                local function responseFormationCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if response.node._form_type == 1 then
                                response.node._last_formation_info = _ED.formation["1"][1]
                                response.node:updateFormation(_ED.formation["1"][1])
                                response.node:updateSaveButtonState()
                                if can_save == false then       
                                    TipDlg.drawTextDailog(formation_type_string[11])    
                                else
                                    checkPlayEffect(73) 
                                    TipDlg.drawTextDailog(formation_type_string[9])
                                end
                            else
                                response.node:saveFormation(0)                -- 保存进攻阵型
                            end
                        end
                    end
                end
                
                if instance._form_type == 1 then
                    protocol_command.formation_save.param_list = instance._form_type.."\r\n"..att_str
                    NetworkManager:register(protocol_command.formation_save.code, nil, nil, nil, instance, responseFormationCallback, false, nil)
                elseif instance._form_type == 2 then
					instance:saveFormation(0)                -- 保存进攻阵型
                    if tonumber(instance.world_attack_type) > 0 then
                        state_machine.excute("adventure_mine_attack_request", 0, {instance.playersOrmine,instance.attack_cell,instance.isForce,instance.world_attack_type, _ED.attack_formation})
                    else
                        state_machine.excute("adventure_mine_attack_request", 0, {instance.playersOrmine,instance.attack_cell,instance.isForce, 0, _ED.attack_formation})
                    end
                elseif instance._form_type == 3 then
					if tonumber(instance._pve_operating_type) == -1 then
						--扫荡
						local old_formation = {}
                        if _ED._battle_init_type == battle_enum._fight_type._fight_type_15 then
                            if getArmorPveAttackTimes() <= 0 then
                                state_machine.excute("pve_armor_buy_times_open", 0, "")
                                return
                            end
                        else
                            if tonumber(_ED.user_info.user_food) <= 0 then
                                state_machine.excute("player_energy_add_open", 0, "")
                                return
                            end
                        end
						
						local fight_type = _ED._battle_init_type
						local scene_id = _ED._current_scene_id
						local npc_id = _ED._scene_npc_id
						local difficulty = _ED._npc_difficulty_index
						instance:saveFormation(0) 
						
						for i,v in pairs(_ED.attack_formation) do
							if tonumber(v.ship_id) ~= 0 then
								local is_same = false
								for j,w in pairs(old_formation) do
									if w.ship_id == v.ship_id then
										is_same = true
									end
								end
								if is_same == false then
									v.ship_count = _ED.user_ship[v.ship_id].ship_count
									table.insert(old_formation, v)
								end
							end
						end
						_ED.sweep_request_info = {fight_type = fight_type, scene_id = scene_id, npc_id = npc_id, difficulty = difficulty, att_str = att_str}
						state_machine.excute("pve_raid_open",0,{_datas = {scene_id=scene_id, npc_id = npc_id, old_formation = old_formation, fight_type = fight_type}})
					else
						local fight_type = _ED._battle_init_type
						local scene_id = _ED._current_scene_id
						local npc_id = _ED._scene_npc_id
						local difficulty = _ED._npc_difficulty_index
						instance:saveFormation(0) 
						state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, difficulty, 0, att_str})
					end
                elseif instance._form_type == 4 then
                    local function sureChangeFormation(_instance, sure_number)
                        local function responseCallback( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("legion_pk_list_update_list_info", 0, nil)
                                state_machine.excute("formation_window_close", 0, nil)
                                if can_save == false then       
                                    TipDlg.drawTextDailog(formation_type_string[43])    
                                else
                                    TipDlg.drawTextDailog(formation_type_string[27])
                                end
                            end
                        end
                        if sure_number == 0 then
                            protocol_command.union_contest_formation_change.param_list = att_str
                            NetworkManager:register(protocol_command.union_contest_formation_change.code, nil, nil, nil, instance, responseCallback, false, nil)
                        end
                    end

                    if self._current_fight_number < self._last_fight_number then
                        local tip = ConfirmTip:new()
                        tip:init(instance, sureChangeFormation, formation_type_string[38])
                        fwin:open(tip,fwin._windows) 
                    else
                        sureChangeFormation(instance, 0)
                    end
                elseif instance._form_type == 5 then
                    state_machine.lock("formation_defend_save")
                    local fight_type = _ED._battle_init_type
                    local scene_id = _ED._current_scene_id
                    local npc_id = _ED._legion_pk_defender_id
                    local difficulty = 0
                    instance:saveFormation(0) 
                    state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, difficulty, 0, att_str})
                elseif instance._form_type == 6 then
                    local fight_type = _ED._battle_init_type
                    local scene_id = _ED._current_scene_id
                    local npc_id = _ED._scene_npc_id
                    local difficulty = _ED._npc_difficulty_index
                    local use_props = _ED._npc_use_props
                    local npc_formation_info = _ED._npc_formation_info
                    instance:saveFormation(0) 
                    state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, difficulty, npc_formation_info, att_str, use_props})
                elseif instance._form_type == 7 
                    or instance._form_type == 8
                    then
                    instance:saveFormation(0)
                    local fight_type = _ED._battle_init_type
                    local scene_id = _ED._current_scene_id
                    local npc_id = _ED._scene_npc_id
                    local difficulty = _ED._npc_difficulty_index
                    state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, difficulty, 0,att_str})
                elseif instance._form_type == 9 then
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            -- state_machine.excute("formation_window_close", 0, nil)
                            TipDlg.drawTextDailog(formation_type_string[27])
                        end
                    end
                    protocol_command.extreme_formation_change.param_list = att_str
                    NetworkManager:register(protocol_command.extreme_formation_change.code, nil, nil, nil, instance, responseCallback, false, nil)
                elseif instance._form_type == 10 then
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(formation_type_string[27])
                        end
                    end
                    protocol_command.enemy_boss_formation_change.param_list = att_str
                    NetworkManager:register(protocol_command.enemy_boss_formation_change.code, nil, nil, nil, instance, responseCallback, false, nil)
                elseif instance._form_type == 11 then
                    local function sureChangeFormation(_instance, sure_number)
                        local all_fight_number = 0
                        if instance._choose_formation ~= nil then
                            for k, info in pairs(instance._choose_formation) do
                                if info.ship ~= nil then
                                    all_fight_number = all_fight_number + getShipFightNumber(info.ship, info.choose_count, instance._choose_leaders[k].ship, k)
                                end
                            end
                        end
                        if sure_number == 0 then
                            local function responseCallback( response )
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                        response.node._last_fight_number = response.node._current_fight_number
                                    end
                                    TipDlg.drawTextDailog(formation_type_string[27])
                                    state_machine.excute("arena_dearon_tab_update_formation_fight", 0, math.ceil(all_fight_number))
                                end
                            end
                            protocol_command.arena_launch_formation_change.param_list = "0".."\r\n"..att_str.."\r\n"..math.ceil(all_fight_number)
                            NetworkManager:register(protocol_command.arena_launch_formation_change.code, nil, nil, nil, instance, responseCallback, false, nil)
                        end
                    end

                    if self._current_fight_number < self._last_fight_number then
                        local tip = ConfirmTip:new()
                        tip:init(instance, sureChangeFormation, formation_type_string[38])
                        fwin:open(tip,fwin._windows) 
                    else
                        sureChangeFormation(instance, 0)
                    end
                elseif instance._form_type == 12 then
                    -- -- 刷新
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(formation_type_string[27])
                            state_machine.excute("guard_battle_guard_list_update_list", 0, "")
                            state_machine.excute("formation_window_close", 0, "")
                        end
                    end
                    protocol_command.guard_formation_save.param_list = att_str
                    NetworkManager:register(protocol_command.guard_formation_save.code, nil, nil, nil, instance, responseCallback, false, nil)

                elseif instance._form_type == 13 then
                    local fight_type = _ED._battle_init_type
                    local scene_id = _ED._current_scene_id
                    local npc_id = _ED._scene_npc_id
                    local difficulty = _ED._npc_difficulty_index
                    instance:saveFormation(0) 
                    local enemy_info = _ED.guard_battle_list_info[""..npc_id]
                    if enemy_info == nil then
                        TipDlg.drawTextDailog(red_alert_time_str[298])
                        state_machine.excute("formation_window_close", 0, "")
                    else
                        state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, difficulty, 0, att_str})
                    end
                elseif instance._form_type == 14 then
                    local all_fight_number = 0
                    if instance._choose_formation ~= nil then
                        for k, info in pairs(instance._choose_formation) do
                            if info.ship ~= nil then
                                all_fight_number = all_fight_number + getShipFightNumber(info.ship, info.choose_count, instance._choose_leaders[k].ship, k)
                            end
                        end
                    end
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(formation_type_string[34])
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:updateDraw()
                            end
                        end
                    end
                    protocol_command.union_craft_signup.param_list = att_str.."\r\n"..math.ceil(all_fight_number)
                    NetworkManager:register(protocol_command.union_craft_signup.code, nil, nil, nil, instance, responseCallback, false, nil)
                elseif instance._form_type == 15 then
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if _ED.camp_pk_user_info.state == 1 then
                                TipDlg.drawTextDailog(formation_type_string[47])
                            else
                                TipDlg.drawTextDailog(formation_type_string[48])
                            end
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:updateDraw()
                            end
                            state_machine.excute("camp_pk_challge_update_info", 0, nil)
                        end
                    end
                    local all_fight_number = 0
                    if instance._choose_formation ~= nil then
                        for k, info in pairs(instance._choose_formation) do
                            if info.ship ~= nil then
                                all_fight_number = all_fight_number + getShipFightNumber(info.ship, info.choose_count, instance._choose_leaders[k].ship, k)
                            end
                        end
                    end
                    protocol_command.camp_duel_signup.param_list = att_str.."\r\n"..math.ceil(all_fight_number).."\r\n".._ED.camp_pk_user_info.state
                    NetworkManager:register(protocol_command.camp_duel_signup.code, nil, nil, nil, instance, responseCallback, false, nil)
                elseif instance._form_type == 16 
                    or instance._form_type == 17 
                    then
                    instance:saveFormation(0)
                    state_machine.excute("adventure_mine_attack_request", 0, {"19", instance.attack_cell, 0, 0, _ED.attack_city_formation})
                elseif instance._form_type == 19 
                    or instance._form_type == 20 
                    then
                    instance:saveFormation(0)
                    state_machine.excute("adventure_mine_attack_request", 0, {"19", instance.attack_cell, 0, 0, _ED.attack_formation})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_max_fighting_terminal = {
            _name = "formation_defend_max_fighting",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self._isLightFight == true then
                    instance:chooseMaxLoadShip()
                else
                    instance:chooseMaxFightingShip(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_max_load_terminal = {
            _name = "formation_defend_max_load",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance:autoChooseLeader() == true then
                    TipDlg.drawTextDailog(formation_type_string[54])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 保存阵型
        local formation_defend_save_formation_terminal = {
            _name = "formation_defend_save_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params[1]
                local formation_name = params[2]
                if instance:saveFormation(index, formation_name) == true then
                    TipDlg.drawTextDailog(string.format(formation_type_string[16], index))
                else
                    TipDlg.drawTextDailog(formation_type_string[15])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 套用阵型
        local formation_defend_load_formation_terminal = {
            _name = "formation_defend_load_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params
                instance._current_formation_index = index
                local formation = _ED.default_formation[""..index]
                instance:updateFormation(formation)
                TipDlg.drawTextDailog(formation_type_string[36])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_update_factor_terminal = {
            _name = "formation_defend_update_factor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateFactor()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_add_defender_formation_info_terminal = {
            _name = "formation_defend_add_defender_formation_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED._battle_init_type = dms.int(dms["pve_scene"], params[2], pve_scene.scene_type) 
                _ED._current_scene_id = params[2]
                _ED._scene_npc_id = params[1]
                _ED._npc_difficulty_index = "1"
                instance:addDefendFormationInfo(params[1], params[2], _ED._battle_init_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local formation_defend_add_arena_formation_info_terminal = {
            _name = "formation_defend_add_arena_formation_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addArenaFormationInfo(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_add_expedition_formation_info_terminal = {
            _name = "formation_defend_add_expedition_formation_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addExpditionFormationInfo(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_add_guard_formation_info_terminal = {
            _name = "formation_defend_add_guard_formation_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addGuardFormationInfo(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_add_legion_formation_info_terminal = {
            _name = "formation_defend_add_legion_formation_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addLegionFormationInfo(params[1], params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_pve_sweep_terminal = {
            _name = "formation_defend_pve_sweep",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local last_operating_type = instance._pve_operating_type
                instance._pve_operating_type = -1
                state_machine.excute("formation_defend_save", 0, "")
                instance._pve_operating_type = last_operating_type
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_defend_update_formation_terminal = {
            _name = "formation_defend_update_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local formation_info = {}
                for i = 1, 6 do
                    local info = {}
                    local tank_info = instance._choose_formation[""..i]
                    local leader = instance._choose_leaders[""..i]
                    if tank_info ~= nil and tank_info.ship ~= nil then
                        info.ship_id = tank_info.ship.ship_id
                        info.count = tank_info.choose_count
                    end
                    if leader ~= nil and leader.ship ~= nil then
                        info.leader_id = leader.ship.ship_id
                    end
                    formation_info[i] = info
                end
                instance:updateFormation(formation_info)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示侦查阵型
        local formation_defend_add_investigate_formation_info_terminal = {
            _name = "formation_defend_add_investigate_formation_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params[1]
                local is_invest = params[2] or false
                instance._investigate_cell = cells
                if is_invest == true then
                    instance:addInvestigateFormationInfo(true)
                else
                    local leave_time = 0
                    if zstring.tonumber(_ED.world_investigate_end_time) > 0 then
                        leave_time = _ED.world_investigate_end_time - (os.time() - _ED.world_investigate_start_time)
                    end
                    if leave_time > 0 then
                        local function requestReconnaissance(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    instance:addInvestigateFormationInfo(true)
                                end
                            end
                        end
                        protocol_command.world_look_mine_info.param_list = cells.info._x.."\r\n"..cells.info._y.."\r\n".."0"
                        NetworkManager:register(protocol_command.world_look_mine_info.code, nil, nil, nil, instance, requestReconnaissance, false, nil)
                    else
                        instance:addInvestigateFormationInfo(false)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 侦查
        local formation_defend_investigate_terminal = {
            _name = "formation_defend_investigate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = instance._investigate_cell
                local isForce = 0
                local m_type = 0
                if tonumber(cells.info._type) == 0 then
                    m_type = 2
                elseif tonumber(cells.info._type) == 1000 then
                    m_type = 3
                else
                    m_type = 1
                end
                if m_type == 2 then
                    if tonumber(cells.info._shield_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) > 0 then
                        local propMoulds = dms.int(dms["prop_config"], 25, prop_config.param)
                        for i,v in pairs(_ED.user_prop) do
                            if tonumber(v.user_prop_template) == propMoulds then
                                cells.from_type = 1
                                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cells, m_type = 9}})
                                return
                            end
                        end 
                        TipDlg.drawTextDailog(tipStringInfo_consumption_info[17])
                        return
                    end
                end

                state_machine.excute("red_alert_time_mine_reconnaissance_open",0,{_datas = {cells = cells ,m_type = m_type, isForce = 0, from_type = 1}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_defend_show_terminal)
        state_machine.add(formation_defend_hide_terminal)
        state_machine.add(formation_defend_update_info_terminal)
        state_machine.add(formation_defend_choose_tanke_terminal)
        state_machine.add(formation_defend_update_once_tank_info_terminal)
        state_machine.add(formation_defend_choose_leader_terminal)
        state_machine.add(formation_defend_update_once_leader_info_terminal)
        state_machine.add(formation_defend_auto_choose_tanke_terminal)
        state_machine.add(formation_defend_save_terminal)
        state_machine.add(formation_defend_max_fighting_terminal)
        state_machine.add(formation_defend_max_load_terminal)
        state_machine.add(formation_defend_save_formation_terminal)
        state_machine.add(formation_defend_load_formation_terminal)
        state_machine.add(formation_defend_update_factor_terminal)
        state_machine.add(formation_defend_add_defender_formation_info_terminal)
        state_machine.add(formation_defend_add_arena_formation_info_terminal)
        state_machine.add(formation_defend_add_expedition_formation_info_terminal)
        state_machine.add(formation_defend_add_guard_formation_info_terminal)
        state_machine.add(formation_defend_add_legion_formation_info_terminal)
        state_machine.add(formation_defend_pve_sweep_terminal)
        state_machine.add(formation_defend_update_formation_terminal)
        state_machine.add(formation_defend_add_investigate_formation_info_terminal)
        state_machine.add(formation_defend_investigate_terminal)
        state_machine.init()
    end
    
    init_formation_defend_terminal()
end

-- 刷新增益状态
function FormationDefend:updateFactor()
    local root = self.roots[1]
    local fatcor_state = {0, 0, 0, 0, 0, 0}
    for k, v in pairs(_ED.factor_info) do 
        local build_buff_id = tonumber(v.build_buff_id)
        if build_buff_id == 7 then          -- 减伤
            fatcor_state[1] = 1
        elseif build_buff_id == 6 then      -- 加伤
            fatcor_state[2] = 1
        elseif build_buff_id == 8 then      -- 行军速度
            fatcor_state[3] = 1
        end
    end

    for i = 1, 3 do
        local Image_form_gain_icon_0 = ccui.Helper:seekWidgetByName(root,"Image_form_gain_icon_0_"..i)
        local Image_form_gain_icon = ccui.Helper:seekWidgetByName(root,"Image_form_gain_icon_"..i)
        if fatcor_state[i] > 0 then         -- 有增益
            Image_form_gain_icon_0:setVisible(false)
            Image_form_gain_icon:setVisible(true)
        else
            Image_form_gain_icon_0:setVisible(true)
            Image_form_gain_icon:setVisible(false)
        end
    end
end

function FormationDefend:autoChooseLeader( ... )
    local isHaveTank = false
    for i=1,6 do
        local info = self._choose_formation[""..i]
        if info ~= nil and info.ship ~= nil then
            isHaveTank = true
            break
        end
    end
    if isHaveTank == false then
        TipDlg.drawTextDailog(formation_type_string[53])
        return false
    end

    local leaders = {}
    for k,v in pairs(_ED.user_ship) do
        local last_count = zstring.tonumber(v.current_count)
        if v.captain_type == 3 then
            if self._form_type == 8 then
                last_count = last_count - zstring.tonumber(v.expedition_lose_count)
            elseif self._form_type == 14 then
                last_count = last_count + zstring.tonumber(v.union_fight_count)
            end
            if last_count > 0 then
                table.insert(leaders, {ship = v})
            end
        end
    end
    if self._isLightFight == true then
        local function sortLeaderFighting(a, b)
            return tonumber(getLeaderFighting(a.ship)) > tonumber(getLeaderFighting(b.ship))
        end
        table.sort(leaders, sortLeaderFighting)
    else
        local function sortLeaderLoad(a, b)
            if tonumber(a.ship.ship_type) > tonumber(b.ship.ship_type)
                or tonumber(a.ship.ship_type) == tonumber(b.ship.ship_type) and tonumber(a.ship.ship_level) > tonumber(b.ship.ship_level) 
                or tonumber(a.ship.ship_type) == tonumber(b.ship.ship_type) and tonumber(a.ship.ship_level) == tonumber(b.ship.ship_level) and tonumber(a.ship.ship_template_id) < tonumber(b.ship.ship_template_id)
                then
                return true
            end
            return false
        end
        table.sort(leaders, sortLeaderLoad)
    end

    local baseFormation = {}
    for k,v in pairs(self._choose_formation) do
        baseFormation[tonumber(k)] = v
    end

    local chooseLeaderIndex = 1
    local choose_formation = {}
    for k,v in pairs(baseFormation) do
        if v ~= nil and v.ship ~= nil and tonumber(v.choose_count) > 0 then
            choose_formation[tonumber(k)] = {ship_id = v.ship.ship_id, count = v.choose_count}
            if leaders[chooseLeaderIndex] ~= nil then
                choose_formation[tonumber(k)].leader_id = leaders[chooseLeaderIndex].ship.ship_id
                chooseLeaderIndex = chooseLeaderIndex + 1
            end
        else
            choose_formation[tonumber(k)] = {ship_id = 0, count = 0, leader_id = 0}
        end
    end
    self:updateFormation(choose_formation)
    return true
end

function FormationDefend:chooseMaxFightingShip( params )
    local result = {}
    local leaders = {}
    for k,v in pairs(_ED.user_ship) do
        local last_count = zstring.tonumber(v.current_count)
        if v.captain_type ~= 3 then
            if self._form_type == 16 or self._form_type == 17 then
                last_count = zstring.tonumber(v.city_current_count)
            end 
            if self._form_type == 8 then
                last_count = last_count - zstring.tonumber(v.expedition_lose_count)
            elseif self._form_type == 14 then
                last_count = last_count + zstring.tonumber(v.union_fight_count)
            end
            local index = 0
            while last_count > 0 and index < 6 do
                last_count = last_count - tonumber(_ED.user_info.soldier)
                if last_count >= 0 then
                    table.insert(result, {ship = v, count = tonumber(_ED.user_info.soldier)})
                else
                    table.insert(result, {ship = v, count = last_count + tonumber(_ED.user_info.soldier)})
                end
                index = index + 1
            end
        else
            if self._form_type == 8 then
                last_count = last_count - zstring.tonumber(v.expedition_lose_count)
            elseif self._form_type == 14 then
                last_count = last_count + zstring.tonumber(v.union_fight_count)
            end
            if last_count > 0 then
                table.insert(leaders, {ship = v})
            end
        end
    end
    local function sortTank(a, b)
        local order_a = dms.int(dms["ship_mould"], a.ship.ship_template_id, ship_mould.base_mould_priority)
        local order_b = dms.int(dms["ship_mould"], b.ship.ship_template_id, ship_mould.base_mould_priority)
        return order_a > order_b
    end
    table.sort(result, sortTank)
    function sortLoad( a, b )
        return tonumber(getShipFightNumber(a.ship, tonumber(a.count))) > tonumber(getShipFightNumber(b.ship, tonumber(b.count)))
    end
    table.sort(result, sortLoad)

    local function sortLeader(a, b)
        return tonumber(getLeaderFighting(a.ship)) > tonumber(getLeaderFighting(b.ship))
    end
    table.sort(leaders, sortLeader)

    local choose_formation = {}
    for k,v in pairs(result) do
        if k > 6 then
            break
        end
        table.insert(choose_formation, {ship_id = v.ship.ship_id, count = v.count})
    end
    for k,v in pairs(leaders) do
        if k > 6 then
            break
        end
        if choose_formation[k] ~= nil then
            choose_formation[k].leader_id = v.ship.ship_id
        end
    end
    self._isLightFight = true
    self:updateFormation(choose_formation, params)
end

function FormationDefend:chooseMaxLoadShip( ... )
    local result = {}
    local leaders = {}
    for k,v in pairs(_ED.user_ship) do
        if v.captain_type ~= 3 then
            local last_count = tonumber(v.current_count)
            if self._form_type == 16 or self._form_type == 17 then
                last_count = zstring.tonumber(v.city_current_count)
            end 
            if self._form_type == 8 then
                last_count = last_count - zstring.tonumber(v.expedition_lose_count)
            elseif self._form_type == 14 then
                last_count = last_count + zstring.tonumber(v.union_fight_count)
            end
            local index = 0
            while last_count > 0 and index < 6 do
                last_count = last_count - tonumber(_ED.user_info.soldier)
                if last_count >= 0 then
                    table.insert(result, {ship = v, attack_speed = tonumber(v.attack_speed), count = tonumber(_ED.user_info.soldier)})
                else
                    table.insert(result, {ship = v, attack_speed = tonumber(v.attack_speed), count = last_count + tonumber(_ED.user_info.soldier)})
                end
                index = index + 1
            end
        else
            if zstring.tonumber(v.current_count) > 0 then
                table.insert(leaders, {ship = v})
            end
        end
    end
    local function sortTank(a, b)
        local order_a = dms.int(dms["ship_mould"], a.ship.ship_template_id, ship_mould.base_mould_priority)
        local order_b = dms.int(dms["ship_mould"], b.ship.ship_template_id, ship_mould.base_mould_priority)
        return order_a > order_b
    end
    table.sort(result, sortTank)
    function sortLoad( a, b )
        return tonumber(a.attack_speed) * tonumber(a.count) > tonumber(b.attack_speed) * tonumber(b.count)
    end
    table.sort(result, sortLoad)

    local function sortLeader(a, b)
        if tonumber(a.ship.ship_type) > tonumber(b.ship.ship_type)
            or tonumber(a.ship.ship_type) == tonumber(b.ship.ship_type) and tonumber(a.ship.ship_level) > tonumber(b.ship.ship_level) 
            or tonumber(a.ship.ship_type) == tonumber(b.ship.ship_type) and tonumber(a.ship.ship_level) == tonumber(b.ship.ship_level) and tonumber(a.ship.ship_template_id) < tonumber(b.ship.ship_template_id)
            then
            return true
        end
        return false
    end
    table.sort(leaders, sortLeader)

    local choose_formation = {}
    for k,v in pairs(result) do
        if k > 6 then
            break
        end
        table.insert(choose_formation, {ship_id = v.ship.ship_id, count = v.count})
    end
    for k,v in pairs(leaders) do
        if k > 6 then
            break
        end
        if choose_formation[k] ~= nil then
            choose_formation[k].leader_id = v.ship.ship_id
        end
    end
    self._isLightFight = false
    self:updateFormation(choose_formation)
end

function FormationDefend:updateOtherInfo( ... )
    local root = self.roots[1]
    local Text_troops_t = ccui.Helper:seekWidgetByName(root, "Text_troops_t")
    local Text_troops_fight_t = ccui.Helper:seekWidgetByName(root, "Text_troops_fight_t")
    local Text_troops_load_t = ccui.Helper:seekWidgetByName(root, "Text_troops_load_t")
    local Text_troops_parts_add = ccui.Helper:seekWidgetByName(root, "Text_troops_parts_add")
    local Text_troops_leader_t = ccui.Helper:seekWidgetByName(root, "Text_troops_leader_t")
    local Text_troops_arrival_t = ccui.Helper:seekWidgetByName(root, "Text_troops_arrival_t")
    local Text_form_n = ccui.Helper:seekWidgetByName(root, "Text_form_n")
    Text_troops_t:setString(string.format(formation_type_string[3], tonumber(_ED.user_info.soldier)))

    Text_troops_parts_add:setString(string.format(formation_type_string[6], 0))
    Text_troops_leader_t:setString(string.format(formation_type_string[7], 0))
    if self._form_type == 1 or self._form_type == 3 then
        Text_troops_arrival_t:setString("")
    elseif self._form_type == 2 
        or self._form_type == 17 
        or self._form_type == 16 
        or self._form_type == 19
        or self._form_type == 20 
        then
        local m_times = 0
        if self.attack_cell ~= nil then
            if self.attack_cell._type == 1000 then
                m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,self.attack_cell._x,self.attack_cell._y, true)
            elseif self.attack_cell._type == 3000 or self.attack_cell._type == 3001 then
                m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,self.attack_cell._x,self.attack_cell._y)
            else
                local isHelpUnion = false
                if zstring.tonumber(_ED.user_info.user_id) ~= zstring.tonumber(self.attack_cell._userId) then
                    if _ED.union.union_info == nil 
                        or _ED.union.union_info == {} 
                        or _ED.union.union_info.union_id == nil 
                        or _ED.union.union_info.union_id == "" 
                        or tonumber(_ED.union.union_info.union_id) == 0 
                        or tonumber(_ED.union.union_info.union_id) ~= zstring.tonumber(self.attack_cell._union_id)
                        then
                        isHelpUnion = false
                    else
                        isHelpUnion = true
                    end
                end
                m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,self.attack_cell._x,self.attack_cell._y, nil, isHelpUnion)
            end
        end
        Text_troops_arrival_t:setString(string.format(formation_type_string[8], exChangeTimeToString(m_times)))
    end

    -- 更新战斗力，载重
    local all_fight_number = 0
    local all_load_number = 0
    if self._choose_formation ~= nil then
        for k, info in pairs(self._choose_formation) do
            if info.ship ~= nil then
                all_fight_number = all_fight_number + getShipFightNumber(info.ship, info.choose_count, self._choose_leaders[k].ship, k)
                all_load_number = all_load_number + tonumber(info.ship.attack_speed) * info.choose_count
            end
        end
    end
    Text_troops_fight_t:setScale(1)
    Text_troops_load_t:setScale(1)

    local text_scale = 1.2

    local color_select = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
    local color_un_select = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    if __lua_project_id == __lua_project_pacific_rim then
        color_select = cc.c3b(color_Type[32][1],color_Type[32][2],color_Type[32][3])
    end

    Text_troops_fight_t:setString(string.format(formation_type_string[4], exChangeNumToString(math.ceil(all_fight_number))))
    Text_troops_load_t:setString(string.format(formation_type_string[5], exChangeNumToString(all_load_number)))
    local Button_formation_fight = ccui.Helper:seekWidgetByName(root, "Button_formation_fight")
    if self._isLightFight == nil then
        Button_formation_fight:setTitleText(formation_type_string[51])
    else
        if self._isLightFight == true then
            Button_formation_fight:setTitleText(formation_type_string[52])
            Text_troops_fight_t:setColor(color_select)
            Text_troops_load_t:setColor(color_un_select)
            Text_troops_fight_t:setScale(text_scale)
        else
            Button_formation_fight:setTitleText(formation_type_string[51])
            Text_troops_fight_t:setColor(color_un_select)
            Text_troops_load_t:setColor(color_select)
            Text_troops_load_t:setScale(text_scale)
        end
    end
    local Button_text_formation_fight = ccui.Helper:seekWidgetByName(root, "Button_text_formation_fight")
    if Button_text_formation_fight ~= nil then
        Button_text_formation_fight:setString(Button_formation_fight:getTitleText())
        Button_formation_fight:setTitleText("")
    end
    self._current_fight_number = math.ceil(all_fight_number)
    if self._last_fight_number == nil then
        self._last_fight_number = self._current_fight_number
    end

    if self._current_formation_index == 0 then
        Text_form_n:setString(formation_type_string[37])
    else
        local formatrion_name = cc.UserDefault:getInstance():getStringForKey(getKey("formation_name"..self._current_formation_index))
        Text_form_n:setString(formatrion_name)
    end

    self:updateSaveButtonState()
end

-- 更新撤离和保存按钮状态
function FormationDefend:updateSaveButtonState()
    local root = self.roots[1]
    local Button_formation_save = ccui.Helper:seekWidgetByName(root, "Button_formation_save")
    local Button_text_formation_save = ccui.Helper:seekWidgetByName(root, "Button_text_formation_save")
    if self._form_type == 1 then
        if self._choose_formation ~= nil then
            self._is_save = false
            local defend_formation = self._last_formation_info      -- 防守部队
            local null_pos_count = 0                                -- 未设置部队位置个数
            for k, v in pairs(self._choose_formation) do
                if v.ship ~= nil then
                    local pos = tonumber(k)
                    if defend_formation[pos] == nil or tonumber(defend_formation[pos].ship_id) == 0 then
                        self._is_save = true
                        break
                    end
                    local ship_id = tonumber(v.ship.ship_id)
                    if ship_id ~= tonumber(defend_formation[pos].ship_id) then
                        self._is_save = true
                        break
                    elseif tonumber(v.choose_count) ~= tonumber(defend_formation[pos].count) then
                        self._is_save = true
                        break
                    end

                    if tonumber(defend_formation[pos].leader_id) > 0 then
                        if self._choose_leaders[""..pos] ~= nil and self._choose_leaders[""..pos].ship ~= nil
                            and tonumber(defend_formation[pos].leader_id) ~= tonumber(self._choose_leaders[""..pos].ship.ship_id) then
                            self._is_save = true
                            break
                        end
                    else
                        if self._choose_leaders[""..pos] ~= nil and self._choose_leaders[""..pos].ship ~= nil then
                            self._is_save = true
                            break
                        end
                    end
                else
                    null_pos_count = null_pos_count + 1
                end
            end
            if null_pos_count == 6 then             -- 没有设置一个部队
                self._is_save = true
            end
        end

        -- 刷新按钮状态
        if self._is_save == true then
            Button_formation_save:setTitleText(formation_type_string[12])
        else
            Button_formation_save:setTitleText(formation_type_string[23])
        end
        if Button_text_formation_save ~= nil then
            Button_text_formation_save:setString(Button_formation_save:getTitleText())
            Button_formation_save:setTitleText("")
        end
    end
end

function FormationDefend:updateChooseInfo( formation_index )
    local root = self.roots[1]
    local ship = self._choose_formation[""..formation_index].ship
    local choose_count = self._choose_formation[""..formation_index].choose_count
    local cell = self._tankCellTab[formation_index]
    cell:updateAllInfo(formation_index, ship, choose_count)
    self:updateOtherInfo()
end

function FormationDefend:updateChooseLeader( formation_index )
    local root = self.roots[1]
    local ship = self._choose_leaders[""..formation_index].ship
    local cell = self._leaderCellTab[formation_index]
    cell:updateAllInfo(formation_index, ship)
    self:updateOtherInfo()
end

function FormationDefend:updateDraw()
    local root = self.roots[1]
    self:loadFormation()

    -- 隐藏自动补兵（未开发）
    local Text_troops_automatic = ccui.Helper:seekWidgetByName(root, "Text_troops_automatic")
    local Text_troops_automatic_state = ccui.Helper:seekWidgetByName(root, "Text_troops_automatic_state")
    local CheckBox_creeps = ccui.Helper:seekWidgetByName(root, "CheckBox_creeps")
    Text_troops_automatic:setVisible(false)
    Text_troops_automatic_state:setVisible(false)
    CheckBox_creeps:setVisible(false)

    local Button_formation_save = ccui.Helper:seekWidgetByName(root, "Button_formation_save")
    local Button_text_formation_save = ccui.Helper:seekWidgetByName(root, "Button_text_formation_save")
    if self._form_type == 1 then
        Button_formation_save:setTitleText(formation_type_string[12])
    elseif self._form_type == 2 or self._form_type == 3 then
		if tonumber(self._pve_operating_type) == -1 then
			Button_formation_save:setTitleText(formation_type_string[24])
		else
			Button_formation_save:setTitleText(formation_type_string[13])
            -- 协防
            if self.attack_cell ~= nil then
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    or tonumber(self.attack_cell._type) ~= 0 
                    or tonumber(_ED.union.union_info.union_id) ~= zstring.tonumber(self.attack_cell._union_id)
                    then
                    Button_formation_save:setTitleText(formation_type_string[13])
                else
                    Button_formation_save:setTitleText(formation_type_string[39])
                end
            end
        end
    elseif self._form_type == 4 then
        Button_formation_save:setTitleText(formation_type_string[12])
        Text_troops_automatic:setVisible(true)
        Text_troops_automatic:setString(formation_type_string[44])
        Text_troops_automatic:setFontSize(22)
        Text_troops_automatic:setPositionX(320)
        Text_troops_automatic_state:setVisible(false)
        CheckBox_creeps:setVisible(false)
    elseif self._form_type == 5 
        or self._form_type == 6
        or self._form_type == 7
        or self._form_type == 8
        or self._form_type == 13
        or self._form_type == 16
        or self._form_type == 19
        then
        Button_formation_save:setTitleText(formation_type_string[13])
    elseif self._form_type == 9 
        or self._form_type == 10 then
        Button_formation_save:setTitleText(formation_type_string[28])
        Text_troops_automatic:setVisible(true)
        Text_troops_automatic:setString(formation_type_string[29])
        Text_troops_automatic_state:setVisible(false)
        CheckBox_creeps:setVisible(false)
    elseif self._form_type == 11 then
        Button_formation_save:setTitleText(formation_type_string[28])
        Text_troops_automatic:setVisible(true)
        Text_troops_automatic:setString(formation_type_string[30])
        Text_troops_automatic:setPositionX(320)
        Text_troops_automatic_state:setVisible(false)
        CheckBox_creeps:setVisible(false)
    elseif self._form_type == 12 then
        Button_formation_save:setTitleText(formation_type_string[12])
        Text_troops_automatic:setVisible(true)
        Text_troops_automatic:setString(formation_type_string[31])
        Text_troops_automatic_state:setVisible(false)
        CheckBox_creeps:setVisible(false)
    elseif self._form_type == 14 then
        Button_formation_save:setTitleText(formation_type_string[12])
        Text_troops_automatic:setString("")
        Text_troops_automatic_state:setVisible(false)
        CheckBox_creeps:setVisible(false)
    elseif self._form_type == 15 then
        if tonumber(_ED.camp_pk_user_info.state) == 0 then
            Button_formation_save:setTitleText(formation_type_string[49])
        else
            Button_formation_save:setTitleText(formation_type_string[50])
        end
        Text_troops_automatic:setString("")
        Text_troops_automatic_state:setVisible(false)
        CheckBox_creeps:setVisible(false)
    elseif self._form_type == 17 
        or self._form_type == 20 
        then
        Button_formation_save:setTitleText(formation_type_string[56])
        Text_troops_automatic:setVisible(true)
        Text_troops_automatic:setString("")
        Text_troops_automatic_state:setVisible(false)
        CheckBox_creeps:setVisible(false)
    end
    if Button_text_formation_save ~= nil then
        Button_text_formation_save:setString(Button_formation_save:getTitleText())
        Button_formation_save:setTitleText("")
    end
    local formation_info = {}
    if self._form_type == 1 and _ED.formation["1"] ~= nil then        -- 防守
        formation_info = _ED.formation["1"][1]
    elseif self._form_type == 2 
        or self._form_type == 3 
        or self._form_type == 5
        or self._form_type == 6 
        or self._form_type == 7
        or self._form_type == 8 
        or self._form_type == 13
        or self._form_type == 19
        or self._form_type == 20
        then    -- 进攻
        formation_info = _ED.attack_formation
    elseif self._form_type == 16
        or self._form_type == 17
        then
        formation_info = _ED.attack_city_formation
    elseif self._form_type == 4 
        then
        local formation_tabs = zstring.split(_ED.union.user_union_info.play_formation_info, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = tonumber(info_tabs[1])
            info.count = tonumber(info_tabs[3])
            info.leader_id = tonumber(info_tabs[6])
            table.insert(formation_info, info)
        end
    elseif self._form_type == 9 
        then
        local formation_tabs = zstring.split(_ED.user_extreme_info.formation_info, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = tonumber(info_tabs[1])
            info.count = tonumber(info_tabs[3])
            info.leader_id = tonumber(info_tabs[6])
            table.insert(formation_info, info)
        end
    elseif self._form_type == 10 then
        local formation_tabs = zstring.split(_ED.user_enemy_strike_info.formation_info, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = tonumber(info_tabs[1])
            info.count = tonumber(info_tabs[3])
            info.leader_id = tonumber(info_tabs[6])
            table.insert(formation_info, info)
        end
    elseif self._form_type == 11 
        then
        local formation_tabs = zstring.split(_ED.arena_info.arena_formation, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = tonumber(info_tabs[1])
            info.count = tonumber(info_tabs[3])
            info.leader_id = tonumber(info_tabs[6])
            table.insert(formation_info, info)
        end
    elseif self._form_type == 12 then
        formation_info = {}
        local defend_formation = ""
        local user_info = _ED.guard_battle_list_info["".._ED.user_info.user_id]
        if user_info ~= nil and tonumber(user_info.user_type) == 0 then
            defend_formation = user_info.formation_info
        end
        local formation_tabs = zstring.split(defend_formation, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = tonumber(info_tabs[1])
            info.count = tonumber(info_tabs[3])
            info.leader_id = tonumber(info_tabs[6])
            table.insert(formation_info, info)
        end
    elseif self._form_type == 14 then
        self._choose_formation = {}
        self._choose_leaders = {}
        local formation_tabs = zstring.split(_ED.union.union_hegemony_info.formation_info, "|")
        for k,v in pairs(_ED.user_ship) do
            if v ~= nil then
                v.union_fight_count = 0
            end
        end
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = zstring.tonumber(info_tabs[1])
            info.count = zstring.tonumber(info_tabs[3])
            info.leader_id = zstring.tonumber(info_tabs[6])
            table.insert(formation_info, info)
            local ship = _ED.user_ship[""..info.ship_id]
            local leader = _ED.user_ship[""..info.leader_id]
            self._choose_formation[""..k] = {ship = ship, choose_count = info.count}
            self._choose_leaders[""..k] = {ship = leader}
            if ship ~= nil then
                ship.union_fight_count = zstring.tonumber(ship.union_fight_count) + info.count
                ship.union_fight_count = math.min(ship.union_fight_count, ship.battle_ship_count)
            end
            if leader ~= nil then
                leader.union_fight_count = zstring.tonumber(leader.union_fight_count) + 1
                leader.union_fight_count = math.min(leader.union_fight_count, leader.battle_ship_count)
            end
        end
    elseif self._form_type == 15 then
        local formation_tabs = zstring.split(_ED.camp_pk_user_info.formation_info, "|")
        for k, v in pairs(formation_tabs) do
            local info = {}
            local info_tabs = zstring.split(v, ",")
            info.ship_id = tonumber(info_tabs[1])
            info.count = tonumber(info_tabs[3])
            info.leader_id = tonumber(info_tabs[6])
            table.insert(formation_info, info)
        end
    end
    self._last_formation_info = formation_info

    self:updateFormation(formation_info)
    self:updateFactor()
end

function FormationDefend:updateFormation(formation_info, params)
    local root = self.roots[1]
    -- 克隆部队
    if self._form_type == 4
        or self._form_type == 9
        or self._form_type == 10        
        or self._form_type == 11
        then
    else
        formation_info = self:adjustFormation(formation_info)

        if type(params) == "table" then
            -- if missionIsOver() == false and #formation_info == 1 then
            --     table.insert(formation_info, 1, nil)
            -- end
            if missionIsOver() == false then
                local tformation_info = {}
                for m, n in pairs(params) do
                    if n <= 0 then
                        tformation_info[m] = nil
                    end
                end
                for i, v in pairs(formation_info) do
                    local ship_id = v.ship_id
                    local ship = _ED.user_ship[""..ship_id]
                    for m, n in pairs(params) do
                        if ship.ship_base_template_id == n then
                            tformation_info[m] = v
                            params[m] = 0
                            break
                        end
                    end
                end
                formation_info = tformation_info
            end
        end
    end

    self._tankCellTab = {}
    self._leaderCellTab = {}
    local padCardsTable = {}
    local leaderCardsTable = {}
    local began_heroSprite = nil
    local began_hero_position = nil
    local change_heroSprite = nil
    local began_hero_ZOrder = nil
    local began_pos = nil
    local end_pos = nil
    local changedHero = nil
    local beganHero = nil

    local function moveFormationHero(heroSprite, changedPad, pos, move_type)
        if heroSprite == nil then
            return
        end
        local xx, yy = heroSprite:getPosition()
        local e_position = fwin:convertToWorldSpace(heroSprite, cc.p(0, 0)) -- heroSprite:convertToWorldSpace(cc.p(0, 0))
        e_position = changedPad:convertToNodeSpace(cc.p(e_position.x, e_position.y))
        heroSprite:setPosition(cc.p(e_position.x, e_position.y))
        
        heroSprite:retain()
        heroSprite:removeFromParent(false)
        changedPad:addChild(heroSprite)
        heroSprite:release()
        heroSprite:setTag(changedPad:getTag())
        
        began_hero_position = cc.p(0, 0)
        heroSprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, began_hero_position)))

        if move_type == 2 then
            self:updateChooseLeader(pos)
        else
            self:updateChooseInfo(pos)
        end
    end
    
    local function formationTouchListener(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        local move_type = sender.move_type

        if eventType == ccui.TouchEventType.began then
            if move_type == 1 then
                state_machine.excute("formation_tank_head_cell_set_selected", 0, {sender, true})
            else
                state_machine.excute("formation_leader_head_cell_set_selected", 0, {sender, true})
            end
            local info_list = self._tankCellTab
            if move_type == 2 then
                info_list = self._leaderCellTab
            end
            for pos, heroCard in pairs(info_list) do
                local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
                if (bPosition.x > 0 and bPosition.x < heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height) then
                    began_pos = pos
                    began_heroSprite = heroCard
                    local tempX, tempY  = heroCard:getPosition()
                    began_hero_position = cc.p(tempX, tempY)
                    began_hero_ZOrder = heroCard:getLocalZOrder()
                    local parent_node = began_heroSprite:getParent()
                    beganHero = parent_node 
                    parent_node:reorderChild(began_heroSprite, 100)
                    parent_node:getParent():reorderChild(parent_node, 100)
                end
            end
        elseif eventType == ccui.TouchEventType.moved then
            if began_pos == nil then
                return
            end
            if nil ~= began_heroSprite then
                began_heroSprite:setPosition(cc.p((__mpoint.x - __spoint.x) / app.scaleFactor + began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_hero_position.y))

                local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
                local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y))
                local index = 0
                local info_list = padCardsTable
                local state_list = self._tankLightList
                if move_type == 2 then
                    info_list = leaderCardsTable
                    state_list = self._leaderLightList
                end
                for pos, card_hero in pairs(info_list) do
                    if card_hero:getTag() ~= began_heroSprite:getTag() then
                        local bPosition = card_hero:convertToNodeSpaceAR(e_position)
                        if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
                            index = pos
                        end
                    end
                end
                for k,v in pairs(state_list) do
                    if k == index then
                        v:setVisible(true)
                    else
                        v:setVisible(false)
                    end
                end
            end
        elseif eventType == ccui.TouchEventType.canceled then
            if move_type == 1 then
                state_machine.excute("formation_tank_head_cell_set_selected", 0, {sender, false})
            else
                state_machine.excute("formation_leader_head_cell_set_selected", 0, {sender, false})
            end
            if began_pos == nil then
                return
            end
            if nil ~= began_heroSprite then
                began_heroSprite:setPosition(cc.p(began_hero_position.x, began_hero_position.y))
            end
        elseif eventType == ccui.TouchEventType.ended
            or eventType == ccui.TouchEventType.canceled then
            if move_type == 1 then
                state_machine.excute("formation_tank_head_cell_set_selected", 0, {sender, false})
            else
                state_machine.excute("formation_leader_head_cell_set_selected", 0, {sender, false})
            end
            if began_pos == nil then
                return
            end
            local info_list = padCardsTable
            local state_list = self._tankLightList
            local cell_list = self._tankCellTab
            if move_type == 2 then
                info_list = leaderCardsTable
                state_list = self._leaderLightList
                cell_list = self._leaderCellTab
            end
            if math.abs(__spoint.x - __epoint.x) <= 5 and math.abs(__spoint.y - __epoint.y) <= 5 then
                if move_type == 2 then
                    state_machine.excute("formation_defend_choose_leader", 0, {_datas = {index = began_pos}})
                else
                    state_machine.excute("formation_defend_choose_tanke", 0, {_datas = {index = began_pos}})
                end
            else
                local isChanged = false
                local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
                local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y)) -- began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
                -- if eventType == ccui.TouchEventType.ended then
                    for pos, card_hero in pairs(info_list) do
                        if card_hero:getTag() ~= began_heroSprite:getTag() then
                            local bPosition = card_hero:convertToNodeSpaceAR(e_position)
                            if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
                                isChanged = true
                                changedHero = card_hero
                                end_pos = pos
                                change_heroSprite = cell_list[end_pos]
                                break
                            end
                        end
                    end
                -- end
                if isChanged == false then
                    began_hero_position = cc.p(0, 0)
                    began_heroSprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, began_hero_position)))
                    local parent_node = began_heroSprite:getParent() 
                    parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
                else
                    if move_type == 2 then
                        self._leaderCellTab[began_pos] = change_heroSprite
                        self._leaderCellTab[end_pos] = began_heroSprite

                        local beginInfo = self._choose_leaders[""..began_pos]
                        local endInfo = self._choose_leaders[""..end_pos]
                        self._choose_leaders[""..end_pos] = beginInfo
                        self._choose_leaders[""..began_pos] = endInfo
                    else
                        self._tankCellTab[began_pos] = change_heroSprite
                        self._tankCellTab[end_pos] = began_heroSprite

                        local beginInfo = self._choose_formation[""..began_pos]
                        local endInfo = self._choose_formation[""..end_pos]
                        self._choose_formation[""..end_pos] = beginInfo
                        self._choose_formation[""..began_pos] = endInfo
                    end
                    moveFormationHero(began_heroSprite, changedHero, end_pos, move_type)
                    moveFormationHero(change_heroSprite, beganHero, began_pos, move_type)
                end
                for pos, card_hero in pairs(info_list) do
                    local parent_node = card_hero:getParent() 
                    parent_node:reorderChild(card_hero, 0)
                    parent_node:getParent():reorderChild(parent_node, pos)
                end
                for k,v in pairs(state_list) do
                    v:setVisible(false)
                end
            end
        end
    end

    for i=1,6 do
        local ship = nil
        local choose_count = 0
        local ship_id = 0
        local leader = nil
        if formation_info ~= nil and formation_info[i] ~= nil then
            ship_id = formation_info[i].ship_id
            local leader_id = formation_info[i].leader_id
            if zstring.tonumber(ship_id) > 0 then
                ship = _ED.user_ship[""..ship_id]
                choose_count = formation_info[i].count
                if zstring.tonumber(leader_id) > 0 then
                    leader = _ED.user_ship[""..leader_id]
                end
            end
        end

        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
        Panel_formation_tank:removeAllChildren(true)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
        Panel_formation_leader:removeAllChildren(true)
        self._choose_formation[""..i] = {ship = ship, choose_count = choose_count}
        self._choose_leaders[""..i] = {ship = leader}

        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, choose_count,1, true})
        Panel_formation_tank:addChild(cell)
        table.insert(padCardsTable, Panel_formation_tank)
        table.insert(self._tankCellTab, cell)
        cell:setTag(Panel_formation_tank:getTag())
        cell:setName("formation_tank")
        cell.move_type = 1
        cell:addTouchEventListener(formationTouchListener)

        local cell1 = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, leader, 1, 1})
        Panel_formation_leader:addChild(cell1)
        table.insert(leaderCardsTable, Panel_formation_leader)
        table.insert(self._leaderCellTab, cell1)
        cell1:setTag(Panel_formation_leader:getTag())
        cell1:setName("formation_leader")
        cell1.move_type = 2
        cell1:addTouchEventListener(formationTouchListener)
    end

    self:updateOtherInfo()
end

-- 保存阵型
function FormationDefend:saveFormation(index, formation_name)
    local can_save = false
    local str = ""
    local formation = {}
    for i = 1, 6 do
        local info = self._choose_formation[""..i]
        local leader = self._choose_leaders[""..i]
        local formation_info = {}
        if info == nil or info.ship == nil or tonumber(info.ship.captain_type) == 3 then
            if i == 1 then
                str = str.."0,0"
            else
                str = str.."|0,0"
            end
            formation_info.ship_id = 0
            formation_info.count = 0
            formation_info.leader_id = 0
        else
            if i == 1 then
                str = str..info.ship.ship_id..","..info.choose_count
            else
                str = str.."|"..info.ship.ship_id..","..info.choose_count
            end
            formation_info.ship_id = info.ship.ship_id
            formation_info.count = info.choose_count
            if leader == nil or leader.ship == nil or tonumber(leader.ship.captain_type) ~= 3 then
                str = str..",0"
                formation_info.leader_id = 0
            else
                str = str..","..leader.ship.ship_id
                formation_info.leader_id = leader.ship.ship_id
            end
            can_save = true
        end
        table.insert(formation, formation_info)
    end
    if can_save == false then
        return false
    end
    if index == 0 then          -- 保存进攻阵型
        if self._form_type == 16 or self._form_type == 17 then
            cc.UserDefault:getInstance():setStringForKey(getKey("attack_city_formation"), str)
            _ED.attack_city_formation = formation
        else
            cc.UserDefault:getInstance():setStringForKey(getKey("attack_formation"), str)
            _ED.attack_formation = formation
        end
    else                        -- 阵型管理阵型
        if formation_name ~= nil and formation_name ~= "" then
            cc.UserDefault:getInstance():setStringForKey(getKey("formation_name"..index), formation_name)
            cc.UserDefault:getInstance():setStringForKey(getKey("formation"..index), str)
            _ED.default_formation[""..index] = formation
        end
    end
    return true
end

-- 加载保存的阵型
function FormationDefend:loadFormation()
    -- 阵型管理保存的阵型
    if _ED.default_formation == nil then
        _ED.default_formation = {}
        local max_formation_count = dms.int(dms["base_consume"], 82, base_consume.vip_0_value + tonumber(_ED.vip_grade)) -- 可保存最大阵型数量
        for i = 1, max_formation_count do
            local formation_name = "formation"..i
            local formation_str = cc.UserDefault:getInstance():getStringForKey(getKey(formation_name))
            if formation_str ~= nil and formation_str ~= "" then
                local formation_tabs = zstring.split(formation_str, "|")
                local formation = {}
                for j = 1, 6 do
                    local formation_info = zstring.split(formation_tabs[j], ",")
                    local info = {}
                    info.ship_id = formation_info[1]
                    info.count = formation_info[2]
                    info.leader_id = formation_info[3]
                    table.insert(formation, info)
                end
                _ED.default_formation[""..i] = formation
            end
        end
    end

    -- 攻击阵型
    if _ED.attack_formation == nil then
        local formation_name = "attack_formation"
        local formation_str = cc.UserDefault:getInstance():getStringForKey(getKey(formation_name))
        if formation_str ~= nil and formation_str ~= "" then
            local formation_tabs = zstring.split(formation_str, "|")
            local formation = {}
            for j = 1, 6 do
                local formation_info = zstring.split(formation_tabs[j], ",")
                local info = {}
                info.ship_id = formation_info[1]
                info.count = formation_info[2]
                info.leader_id = formation_info[3]
                table.insert(formation, info)
            end
            _ED.attack_formation = formation
        end
    end

    -- 城市战攻击阵型
    if _ED.attack_city_formation == nil then
        local formation_name = "attack_city_formation"
        local formation_str = cc.UserDefault:getInstance():getStringForKey(getKey(formation_name))
        if formation_str ~= nil and formation_str ~= "" then
            local formation_tabs = zstring.split(formation_str, "|")
            local formation = {}
            for j = 1, 6 do
                local formation_info = zstring.split(formation_tabs[j], ",")
                local info = {}
                info.ship_id = formation_info[1]
                info.count = formation_info[2]
                info.leader_id = formation_info[3]
                table.insert(formation, info)
            end
            _ED.attack_city_formation = formation
        end
    end
end

-- 调整阵型带兵数量，去掉损耗和已出征的部队
function FormationDefend:adjustFormation(formation_info)
    local reduce_count = {}                 -- ship_id 对应已上阵的数量
    if formation_info == nil then
        return {}
    end
    for k, v in pairs(formation_info) do
        local ship_id = zstring.tonumber(v.ship_id)
        local count = zstring.tonumber(v.count)
        local leader_id = zstring.tonumber(v.leader_id)
        if ship_id > 0 then
            local current_count = 0
            local isFindUserShip = false
            for k1, v1 in pairs(_ED.user_ship) do
                if zstring.tonumber(v1.captain_type) ~= 3 and zstring.tonumber(v1.ship_id) == ship_id then
                    isFindUserShip = true
                    current_count = zstring.tonumber(v1.current_count)
                    if self._form_type == 16 or self._form_type == 17 then
                        current_count = zstring.tonumber(v1.city_current_count)
                    end 
                    if self._form_type == 8 then
                        current_count = current_count - zstring.tonumber(v1.expedition_lose_count)
                    elseif self._form_type == 14 then
                        current_count = current_count + zstring.tonumber(v1.union_fight_count)
                    end
                    break
                end
            end
            local reduce = zstring.tonumber(reduce_count[""..ship_id])
            local max_count = current_count - reduce
            if count > max_count then
                count = max_count
            end
            if isFindUserShip == false then
                count = 0
            end
        else
            count = 0
        end
        v.count = count
        reduce_count[""..ship_id] = zstring.tonumber(reduce_count[""..ship_id]) + count
        if count <= 0 then
            formation_info[k] = {ship_id = 0, count = 0, leader_id = 0}
        else
            if leader_id > 0 then
                local current_count = 0
                for k1, v1 in pairs(_ED.user_ship) do
                    if zstring.tonumber(v1.captain_type) == 3 and zstring.tonumber(v1.ship_id) == leader_id then
                        current_count = zstring.tonumber(v1.current_count)
                        if self._form_type == 8 then
                            current_count = current_count - zstring.tonumber(v1.expedition_lose_count)
                        elseif self._form_type == 14 then
                            current_count = current_count + zstring.tonumber(v1.union_fight_count)
                        end
                        if current_count <= 0 then
                            formation_info[k].leader_id = 0
                        end
                    end
                end
            end
        end
    end
    return formation_info
end

-- 自动补兵
function FormationDefend:autoAddTank( formation_info )
    local reduce_count = {}
    for k, v in pairs(formation_info) do
        local ship_id = zstring.tonumber(v.ship_id)
        local count = zstring.tonumber(v.count)
        if ship_id > 0 then
            local current_count = 0
            for k1, v1 in pairs(_ED.user_ship) do
                if zstring.tonumber(v1.ship_id) == ship_id then
                    current_count = zstring.tonumber(v1.current_count)
                    if self._form_type == 16 or self._form_type == 17 then
                        current_count = zstring.tonumber(v1.city_current_count)
                    end 
                    break
                end
            end
            local reduce = zstring.tonumber(reduce_count[""..ship_id])
            -- 当前仓库拥有的剩余兵量
            local max_count = current_count - reduce
            if max_count > 0 then
                -- 当前坦克需要补充的兵量
                local auto_add_count = tonumber(_ED.user_info.soldier) - count
                if auto_add_count > 0 then
                    if auto_add_count > max_count then
                        count = count + max_count
                        reduce_count[""..ship_id] = zstring.tonumber(reduce_count[""..ship_id]) + max_count
                    else
                        count = count + auto_add_count
                        reduce_count[""..ship_id] = zstring.tonumber(reduce_count[""..ship_id]) + auto_add_count
                    end
                end
            end
        end
        v.count = count
        if count <= 0 then
            formation_info[k] = {ship_id = 0, count = 0, leader_id = 0}
        end
    end
    return formation_info
end

function FormationDefend:addDefendFormationInfo( npcId, sceneId, sceneType )
    local root = self.roots[1]
    local environment_formation1 = dms.string(dms["npc"], npcId, npc.environment_formation1)
    local formation_info = dms.element(dms["environment_formation"], npcId)
    local combat_force = dms.atos(formation_info, environment_formation.combat_force)
    local seat_one = dms.atoi(formation_info, environment_formation.seat_one)
    local seat_two = dms.atoi(formation_info, environment_formation.seat_two)
    local seat_three = dms.atoi(formation_info, environment_formation.seat_three)
    local seat_four = dms.atoi(formation_info, environment_formation.seat_four)
    local seat_five = dms.atoi(formation_info, environment_formation.seat_five)
    local seat_six = dms.atoi(formation_info, environment_formation.seat_six)
    local seat_info = {seat_one,seat_two,seat_three,seat_four,seat_five,seat_six}
    local seat_one_nums = dms.int(dms["environment_ship"], seat_one, environment_ship.level)
    local seat_two_nums = dms.int(dms["environment_ship"], seat_two, environment_ship.level)
    local seat_three_nums = dms.int(dms["environment_ship"], seat_three, environment_ship.level)
    local seat_four_nums = dms.int(dms["environment_ship"], seat_four, environment_ship.level)
    local seat_five_nums = dms.int(dms["environment_ship"], seat_five, environment_ship.level)
    local seat_six_nums = dms.int(dms["environment_ship"], seat_six, environment_ship.level)
    local seat_nums_info = {seat_one_nums,seat_two_nums,seat_three_nums,seat_four_nums,seat_five_nums,seat_six_nums}
    local have_num = 0
    for i=1,6 do
        local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
        local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
        Panel_enemy_tank:removeAllChildren(true)
        Panel_enemy_leader:removeAllChildren(true)
        have_num = have_num + zstring.tonumber(seat_nums_info[i])
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, seat_info[i], seat_nums_info[i], 2})
        Panel_enemy_tank:addChild(cell)
        local cell1 = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, nil, 3, 2})
        Panel_enemy_leader:addChild(cell1)
    end
    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    Panel_pve_attack_box:setVisible(true)
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
    Panel_collection_tab:setVisible(false)
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")
    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
    Text_fight_t:setString(formation_type_string[55])
    Text_fight_n:setString(combat_force)

    local Button_pve_sweep = ccui.Helper:seekWidgetByName(root, "Button_pve_sweep")
    Button_pve_sweep:setVisible(true)

    -- 获得奖励
    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
    Text_get_reward:removeAllChildren(true)
    local rewardFontSize = Text_get_reward:getFontSize()

    local on_hook_reward = dms.int(dms["npc"], npcId, npc.on_hook_reward)
    local wait_time = dms.string(dms["npc"], npcId, npc.wait_time)
    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 

    -- 有几率获得
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    local Text_get_n = ccui.Helper:seekWidgetByName(root,"Text_get_n")
    Text_get_t:setVisible(false)
    Text_get_n:removeAllChildren(true)
    Text_get_n:setPositionX(Text_get_t:getPositionX())
    local nFontSize = Text_get_n:getFontSize()

    local _richText_3 = ccui.RichText:create()
    _richText_3:ignoreContentAdaptWithSize(false) 
    local re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[284], "fonts/simhei.ttf",nFontSize)
    _richText_3:pushBackElement(re1)  
    local drop_library = dms.int(dms["npc"], npcId, npc.drop_library)
    local add_numbers = {}
    if drop_library > 0 then
        reward_items = dms.string(dms["scene_reward"], drop_library, scene_reward.reward_items)
        reward_items = zstring.split(reward_items,"|")
        for i,reward in ipairs(reward_items) do
            local reward_tab = zstring.split(reward,",")
            local prop_item = tonumber(reward_tab[1])
            local prop_type = tonumber(reward_tab[2])
            local prop_quality = dms.int(dms["prop_mould"], prop_item, prop_mould.prop_quality)
            local prop_name = dms.string(dms["prop_mould"], prop_item, prop_mould.prop_name)
            if prop_type == 7 then
                prop_quality = dms.int(dms["equipment_mould"], prop_item, equipment_mould.grow_level)
                prop_name = dms.string(dms["equipment_mould"], prop_item, equipment_mould.equipment_name)
            end
            local data = {prop_name,prop_quality}
            table.insert(add_numbers,data)
        end
        for i,v in pairs(add_numbers) do
            local re1 = nil 
            local re2 = nil
            re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[v[2]+1][1],color_Type[v[2]+1][2],color_Type[v[2]+1][3]),255, v[1], "fonts/simhei.ttf",nFontSize)
            _richText_3:pushBackElement(re1)  
            if i == #add_numbers then
                re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,"","fonts/simhei.ttf",nFontSize)
                _richText_3:pushBackElement(re2)
            else
                re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,"、","fonts/simhei.ttf",nFontSize)
                _richText_3:pushBackElement(re2)
            end
        end
        _richText_3:setContentSize(cc.size(Text_get_n:getContentSize().width + Text_get_t:getContentSize().width,nFontSize))
        _richText_3:setPosition(cc.p(_richText_3:getContentSize().width/2,_richText_3:getContentSize().height/2))
        -- Text_get_n:addChild(_richText_3)
    end

    if sceneType == battle_enum._fight_type._fight_type_1 then
        if verifySupportLanguage(_lua_release_language_en) == true then
            Text_get_t:setVisible(false)
        else
            Text_get_t:setVisible(false)
            Text_get_t:setPositionY(284)
            Text_get_n:setPositionY(284)
        end
        Button_pve_sweep:setVisible(false)
        Text_fight_t:setString(tipString_legion_info[43])
        Text_fight_n:setString(have_num)
        local datas = dms.string(dms["pve_scene"], sceneId, pve_scene.brief_introduction)
        local texts_info = zstring.split(datas, "/r/n")
        local index = 0
        for i=1,#texts_info do
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)
            _richText2:setContentSize(cc.size(Text_get_reward:getContentSize().width, 0))
            _richText2:setAnchorPoint(cc.p(0, 0))
            local char_str = texts_info[i]
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            config_res.font.font_name, 
            rewardFontSize,
            chat_rich_text_color)
            _richText2:formatTextExt()
            local rsize = _richText2:getContentSize()
            _richText2:setPositionY(Text_get_reward:getContentSize().height-index)
            -- _richText2:setPositionX(400 - 0.5 * fontSize)
            Text_get_reward:addChild(_richText2)
            index = index + rsize.height
        end
    elseif self._scene_type == battle_enum._fight_type._fight_type_15 then
        if verifySupportLanguage(_lua_release_language_en) == true then
            Text_get_t:setVisible(false)
        else
            Text_get_t:setVisible(false)
            Text_get_t:setPositionY(284)
            Text_get_n:setPositionY(284)
        end
        local datas = dms.string(dms["pve_scene"], sceneId, pve_scene.brief_introduction)
        local texts_info = zstring.split(datas, "/r/n")
        local index = 0
        for i=1,#texts_info do
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)
            _richText2:setContentSize(cc.size(Text_get_reward:getContentSize().width, 0))
            _richText2:setAnchorPoint(cc.p(0, 0))
            local char_str = texts_info[i]
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            config_res.font.font_name, 
            rewardFontSize,
            chat_rich_text_color)
            _richText2:formatTextExt()
            local rsize = _richText2:getContentSize()
            _richText2:setPositionY(Text_get_reward:getContentSize().height-index)
            -- _richText2:setPositionX(400 - 0.5 * fontSize)
            Text_get_reward:addChild(_richText2)
            index = index + rsize.height
        end
    else
        local wdatas = zstring.split(dms.string(dms["world_config"], 17 , world_config.param), "|")
        local additionOne = zstring.split(wdatas[1],",")
        local additionTwo = zstring.split(wdatas[2],",")
        local m_addition = 0
        if tonumber(_ED.user_info.user_grade) < tonumber(_ED.world_level) then
            if tonumber(_ED.world_level) - tonumber(_ED.user_info.user_grade) >= tonumber(math.max(additionOne[1],additionTwo[1])) then
                m_addition = math.max(additionOne[2],additionTwo[2])*100
            else
                m_addition = math.min(additionOne[2],additionTwo[2])*100
            end
        end

        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[17], "fonts/simhei.ttf",rewardFontSize)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, wait_time, "fonts/simhei.ttf",rewardFontSize)
        _richText_2:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " "..red_alert_time_str[18], "fonts/simhei.ttf",rewardFontSize)
        _richText_2:pushBackElement(re3)
        local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, exChangeNumToString(math.floor(on_hook_reward*((100+_ED.battle_exp_factor)/100))), "fonts/simhei.ttf",rewardFontSize)
        _richText_2:pushBackElement(re4)
        local playTheQueue = dms.element(dms["base_consume"], 90)
        local nCount = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
        local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, ""..string.format(red_alert_time_str[99],_ED.vip_grade, nCount)..red_alert_time_str[100], "fonts/simhei.ttf",rewardFontSize)
        if nCount ~= 0 then
             _richText_2:pushBackElement(re5)
        end
        _richText_2:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
        Text_get_reward:addChild(_richText_2)
        Text_get_n:addChild(_richText_3)
    end
end

function FormationDefend:addArenaFormationInfo( info )
    local root = self.roots[1]
    self._arena_info = info
    local shipData = zstring.split(info.ship_moulds, "|")
    local ship_number = 0
    for i = 1, #shipData do
        local infos = zstring.split(shipData[i], ",")
        if tonumber(infos[3]) > 0 then
            ship_number = ship_number + tonumber(infos[3])
        end
    end
    
    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    Panel_pve_attack_box:setVisible(true)
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
    Panel_collection_tab:setVisible(false)
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")
    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
    Text_fight_t:setString(tipString_legion_info[42])
    Text_fight_n:setString(info.user_fight)

    -- 获得奖励
    local get_reward = zstring.split(dms.string(dms["arena_config"], 14, arena_config.param), ",")
    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
    local rewardFontSize = Text_get_reward:getFontSize()

    local colors = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    local color_2 = cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3])
    local _richText_3 = ccui.RichText:create()
    _richText_3:ignoreContentAdaptWithSize(false) 
    
    local re3_1 = ccui.RichElementText:create(1, colors,255, arena_tip_text[15], config_res.font.font_name,rewardFontSize)
    _richText_3:pushBackElement(re3_1)  
    --临时的0
    local re3_2 = ccui.RichElementText:create(1, color_2,255, string.format(arena_tip_text[16],get_reward[1]), config_res.font.font_name,rewardFontSize)
    _richText_3:pushBackElement(re3_2)  
    _richText_3:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2+6))
    _richText_3:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
    Text_get_reward:addChild(_richText_3)
    
    local _richText_4 = ccui.RichText:create()
    _richText_4:ignoreContentAdaptWithSize(false) 
    local rank = tonumber(_ED.arena_info.rank) - tonumber(info.user_rank)
    if rank <= 0 then
        rank = 0
    end
    local re4_1 = ccui.RichElementText:create(1, colors,255, arena_tip_text[17], config_res.font.font_name,rewardFontSize)
    _richText_4:pushBackElement(re4_1)  
    local re4_2 = ccui.RichElementText:create(1, color_2,255, "+"..rank, config_res.font.font_name,rewardFontSize)
    _richText_4:pushBackElement(re4_2)  
    _richText_4:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2-16))
    _richText_4:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
    Text_get_reward:addChild(_richText_4)
    

    -- 有几率获得
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    Text_get_t:setString(arena_tip_text[18])
    local Text_get_n = ccui.Helper:seekWidgetByName(root,"Text_get_n")
    Text_get_n:removeAllChildren(true)
    local reward_info = zstring.split(dms.string(dms["arena_config"], 18, arena_config.param), ",")
    local scene_reward_id = tonumber(reward_info[1])
    local prop_info = zstring.split(dms.string(dms["scene_reward"], scene_reward_id, scene_reward.reward_items), "|")
    local info = zstring.split(prop_info[1], ",")
    local prop_id = tonumber(info[1])
    local prop_name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
    local quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)
    Text_get_n:setString(prop_name)
    Text_get_n:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_get_n:setPositionX(Text_get_t:getPositionX() + Text_get_t:getContentSize().width)
    Text_get_n:setPositionY(Text_get_t:getPositionY())
    Text_get_n:setContentSize(cc.size(Text_get_n:getContentSize().width,Text_get_t:getContentSize().height))

    for i=1,6 do
        local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
        local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
        Panel_enemy_tank:removeAllChildren(true)
        Panel_enemy_leader:removeAllChildren(true)
        
        local infos = zstring.split(shipData[i], ",")
        local ship = {}
        ship.ship_template_id = infos[2]
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, infos[3],3})
        Panel_enemy_tank:addChild(cell)

        local leader_head = nil
        if tonumber(infos[6]) > 0 then
            leader_head = {}
            leader_head.captain_name = dms.string(dms["ship_mould"], tonumber(infos[7]), ship_mould.captain_name)
            leader_head.ship_type = dms.string(dms["ship_mould"], tonumber(infos[7]), ship_mould.ship_type)
            leader_head.ship_template_id = infos[7]
        end
        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,leader_head,1, 2})
        Panel_enemy_leader:addChild(cell)
    end
end

function FormationDefend:addExpditionFormationInfo( npcIndex )
    local root = self.roots[1]
    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    Panel_pve_attack_box:setVisible(true)
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
    Panel_collection_tab:setVisible(false)
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
    local rewardFontSize = Text_get_reward:getFontSize()
    Text_get_t:setVisible(false)
    
    local current_enemy_formation = zstring.split(_ED.user_expedition_info.current_enemy_formation, "|")
    local have_count = 0
    for i=1,6 do
        local current_enemy_info = zstring.split(current_enemy_formation[i], ",")
        if tonumber(current_enemy_info[3]) > 0 then
            have_count = have_count + current_enemy_info[3]
        end
        local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
        local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
        Panel_enemy_tank:removeAllChildren(true)
        Panel_enemy_leader:removeAllChildren(true)

        local info_ship = {ship_template_id = current_enemy_info[2]}
        local leader = {ship_template_id = current_enemy_info[7]}
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, info_ship, current_enemy_info[3], 3})
        Panel_enemy_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, leader, 2, 2})
        Panel_enemy_leader:addChild(cell)
    end
    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")
    Text_fight_t:setString(tipString_legion_info[43])
    Text_fight_n:setString(have_count)

    Text_get_reward:setString("")
    Text_get_reward:removeAllChildren(true)

    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_campaign_info[38], "fonts/simhei.ttf",rewardFontSize)
    _richText_2:pushBackElement(re1)

    for i= 1, dms.count(dms["expedition_reward"]) do
        local expedition_reward_info = dms.element(dms["expedition_reward"], i)
        local level = dms.atoi(expedition_reward_info, expedition_reward.level)
        if level == tonumber(_ED.user_info.user_grade) then
            local score_info = dms.atos(expedition_reward_info, expedition_reward.score_info)
            score_info = zstring.split(score_info, "|")
            for k,v in pairs(score_info) do
                if k == npcIndex then
                    local info = zstring.split(v, ",")
                    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 255, reward_prop_list[tonumber(info[2])], "fonts/simhei.ttf",rewardFontSize)
                    _richText_2:pushBackElement(re2)
                    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]), 255, "+"..info[3], "fonts/simhei.ttf", rewardFontSize)
                    _richText_2:pushBackElement(re3)
                end
            end
            local reward_info = dms.atos(expedition_reward_info, expedition_reward.reward_info)
            reward_info = zstring.split(reward_info, ",")
            for k,v in pairs(reward_info) do
                if k == npcIndex then
                    local reward_items = zstring.split(dms.string(dms["scene_reward"], v, scene_reward.reward_items), ",")
                    local reward_name = dms.string(dms["prop_mould"], reward_items[1], prop_mould.prop_name)
                    local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 255, "，"..reward_name, "fonts/simhei.ttf", rewardFontSize)
                    _richText_2:pushBackElement(re4)
                end
            end
        end
    end
    _richText_2:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2))
    _richText_2:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
    Text_get_reward:addChild(_richText_2)
end

function FormationDefend:addGuardFormationInfo( npcIndex )
    local root = self.roots[1]

    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    Panel_pve_attack_box:setVisible(true)
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
    Panel_collection_tab:setVisible(false)
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    Text_get_t:setVisible(false)
    local current_enemy_formation = zstring.split(self._info_data.formation_info, "|")
    local have_count = 0
    for i=1,6 do
        local current_enemy_info = zstring.split(current_enemy_formation[i], ",")
        if tonumber(current_enemy_info[3]) > 0 then
            have_count = have_count + current_enemy_info[3]
        end
        local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
        local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
        Panel_enemy_tank:removeAllChildren(true)
        Panel_enemy_leader:removeAllChildren(true)

        local info_ship = {ship_template_id = current_enemy_info[2]}
        local leader = {ship_template_id = current_enemy_info[7]}
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, info_ship, current_enemy_info[3], 3})
        Panel_enemy_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,leader,2, 2})
        Panel_enemy_leader:addChild(cell)
    end

    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")
    Text_fight_t:setString(tipString_legion_info[43])
    Text_fight_n:setString(have_count)

    if _ED.guard_battle_user_info ~= nil and tonumber(_ED.guard_battle_user_info.battle_type) == 0 then
        -- Button_attack:setVisible(false)
    else
        -- Button_attack:setVisible(true)
    end
end

function FormationDefend:addLegionFormationInfo( info, nType )
    local root = self.roots[1]
    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    Panel_pve_attack_box:setVisible(true)
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
    Panel_collection_tab:setVisible(false)
    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")

    local play_formation_info = nil
    if nType <= 0 then
        play_formation_info = zstring.split(info.play_formation_info, "|")
    else
        play_formation_info = zstring.split(info, "|")
    end
    for i=1,6 do
        local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
        local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
        Panel_enemy_tank:removeAllChildren(true)
        Panel_enemy_leader:removeAllChildren(true)

        local choose_count = 0
        local info_ship = nil
        local leader = nil
        if play_formation_info[i] ~= nil then
            local formation_info = zstring.split(play_formation_info[i], ",")
            choose_count = tonumber(formation_info[3])
            info_ship = {ship_template_id = formation_info[2]}
            leader = {ship_template_id = formation_info[7]}
        end
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, info_ship, choose_count, 3})
        Panel_enemy_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, leader, 2, 2})
        Panel_enemy_leader:addChild(cell)
    end

    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    if nType <= 0 then
        Text_fight_t:setString(tipString_legion_info[42])
        Text_fight_n:setString(exChangeNumToString(info.formation_capactity))
    else
        Text_fight_t:setString("")
        Text_fight_n:setString("")
    end
end

function FormationDefend:addInvestigateFormationInfo(is_invest)
    local root = self.roots[1]
    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    Panel_pve_attack_box:setVisible(true)
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
    Panel_collection_tab:setVisible(false)
    local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
    local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")
    local Panel_world_res_spy = ccui.Helper:seekWidgetByName(root, "Panel_world_res_spy")
    if Panel_world_res_spy ~= nil then
        if is_invest == false then
            Panel_world_res_spy:setVisible(true)
        else
            Panel_world_res_spy:setVisible(false)
        end
    end

    if is_invest == false then
        Panel_pve_attack_box:setVisible(false)
    else
        local ship_number = 0
        if zstring.tonumber(_ED.world_map.investigate_info._type) > 0 and zstring.tonumber(_ED.world_map.investigate_info._user_id) <= 0 then
            local m_environment_formation_id = dms.int(dms["npc"],zstring.tonumber(_ED.world_map.investigate_info._npc_id),npc.environment_formation1)
            local m_environment_formationMould = dms.element(dms["environment_formation"], m_environment_formation_id)
            local environment_ship_ids = {}
            for i=1, 6 do
                table.insert(environment_ship_ids, dms.atoi(m_environment_formationMould, environment_formation.seat_one + i - 1))
            end
            local m_ship_info = {}
            for i, v in pairs(environment_ship_ids) do
                if v > 0 then
                    table.insert(m_ship_info, dms.element(dms["environment_ship"], v))
                end
            end
            for i = 1, 6 do
                local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
                local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
                Panel_enemy_tank:removeAllChildren(true)
                Panel_enemy_leader:removeAllChildren(true)

                local formation_count = 0
                local ship_mould_id = nil

                if m_ship_info[i] ~= nil then
                    if zstring.tonumber(_ED.world_map.investigate_info._type) == 1000 then  --叛军
                        formation_count = _ED.world_map.investigate_info.formation_count[i]
                    else
                        formation_count = dms.atoi(m_ship_info[i], environment_ship.level)
                    end
                    if formation_count > 0 then
                        ship_mould_id = environment_ship_ids[i]
                    end
                end
                local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship_mould_id, formation_count, 2})
                Panel_enemy_tank:addChild(cell)
                local cell1 = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, nil, 3, 2})
                Panel_enemy_leader:addChild(cell1)
                ship_number = ship_number + formation_count
            end
        else
            local info_s = zstring.split(_ED.world_map.investigate_info._formation_info, "!")
            local play_formation_info = zstring.split(info_s[2], "|")
            for i=1,6 do
                local Panel_enemy_tank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_tank_"..i)
                local Panel_enemy_leader = ccui.Helper:seekWidgetByName(root, "Panel_enemy_leader_"..i)
                Panel_enemy_tank:removeAllChildren(true)
                Panel_enemy_leader:removeAllChildren(true)

                local choose_count = 0
                local info_ship = nil
                local leader = nil
                if play_formation_info[i] ~= nil then
                    local formation_info = zstring.split(play_formation_info[i], ",")
                    choose_count = tonumber(formation_info[3])
                    info_ship = {ship_template_id = formation_info[2]}
                    if tonumber(formation_info[3]) > 0 then
                        leader = {ship_template_id = formation_info[7]}
                    end
                end
                local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, info_ship, choose_count, 3})
                Panel_enemy_tank:addChild(cell)
                local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, leader, 2, 2})
                Panel_enemy_leader:addChild(cell)
                ship_number = ship_number + choose_count
            end
        end

        local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
        local Text_fight_t = ccui.Helper:seekWidgetByName(root, "Text_fight_t")
        Text_fight_t:setString(tipString_legion_info[43])
        Text_fight_n:setString(ship_number)
    end
end

--初始化
function FormationDefend:onInit()
    local csbItem = csb.createNode(string.format(config_csb.formation.formation_tab, "1"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_attack_box")
    if Panel_pve_attack_box ~= nil then
        Panel_pve_attack_box:setVisible(false)
    end
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
    if Panel_collection_tab ~= nil then
        Panel_collection_tab:setVisible(true)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation"), nil, 
    {
        terminal_name = "formation_manage_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_load"), nil, 
    {
        terminal_name = "formation_defend_max_load", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_fight"), nil, 
    {
        terminal_name = "formation_defend_max_fighting", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_save"), nil, 
    {
        terminal_name = "formation_defend_save", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_creeps"), nil, 
    {
        terminal_name = "formation_defend_auto_choose_tanke", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_equ"), nil, 
    {
        terminal_name = "equipment_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_leader"), nil, 
    {
        terminal_name = "armor_window_open", 
        terminal_state = 0, 
        touch_black = true,
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_sweep"), nil, 
    {
        terminal_name = "formation_defend_pve_sweep", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_res_spy"), nil, 
    {
        terminal_name = "formation_defend_investigate", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    for i=1,6 do
        local Image_form_tank_hook = ccui.Helper:seekWidgetByName(root, "Image_form_tank_hook_"..i)
        table.insert(self._tankLightList, Image_form_tank_hook)
        local Image_form_leader_hook = ccui.Helper:seekWidgetByName(root, "Image_form_leader_hook_"..i)
        table.insert(self._leaderLightList, Image_form_leader_hook)
    end

    if self._form_type == 7 
        or self._form_type == 10
        or self._form_type == 11
        or self._form_type == 14
        then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_form_gain"), nil, 
        {
            terminal_name = "base_reserve_window_open", 
            terminal_state = 0,
        }, nil, 1)
    else
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_form_gain"), nil, 
        {
            terminal_name = "formation_change_page", 
            terminal_state = 0, 
            _page = 4,
        }, nil, 1)
    end

    self:updateDraw()
end

function FormationDefend:onEnterTransitionFinish()

end

function FormationDefend:init(param)
    self._rootWindows = param[1]
    self._form_type = param[2]

	self.attack_cell = param[3]
	self.playersOrmine = param[4]
	self._pve_operating_type = param[5]
	self.isForce = param[6] or 0
    self.world_attack_type = param[7] or 0
	self:onInit()
    return self
end

function FormationDefend:onExit()
    state_machine.remove("formation_defend_show")
    state_machine.remove("formation_defend_hide")
    state_machine.remove("formation_defend_update_info")
    state_machine.remove("formation_defend_choose_tanke")
    state_machine.remove("formation_defend_update_once_tank_info")
    state_machine.remove("formation_defend_choose_leader")
    state_machine.remove("formation_defend_update_once_leader_info")
    state_machine.remove("formation_defend_auto_choose_tanke")
    state_machine.remove("formation_defend_save")
    state_machine.remove("formation_defend_max_fighting")
    state_machine.remove("formation_defend_max_load")
    state_machine.remove("formation_defend_save_formation")
    state_machine.remove("formation_defend_load_formation")
    state_machine.remove("formation_defend_update_factor")
    state_machine.remove("formation_defend_add_defender_formation_info")
    state_machine.remove("formation_defend_add_arena_formation_info")
    state_machine.remove("formation_defend_add_expedition_formation_info")
    state_machine.remove("formation_defend_add_guard_formation_info")
    state_machine.remove("formation_defend_add_legion_formation_info")
    state_machine.remove("formation_defend_pve_sweep")
    state_machine.remove("formation_defend_update_formation")
    state_machine.remove("formation_defend_add_investigate_formation_info")
    state_machine.remove("formation_defend_investigate")
end