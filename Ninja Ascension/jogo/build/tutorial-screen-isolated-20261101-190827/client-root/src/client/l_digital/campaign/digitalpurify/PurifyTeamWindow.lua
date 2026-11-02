-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化队伍界面
-------------------------------------------------------------------------------------------------------
PurifyTeamWindow = class("PurifyTeamWindowClass", Window)

local purify_team_window_open_terminal = {
    _name = "purify_team_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:open(PurifyTeamWindow:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local purify_team_window_close_terminal = {
    _name = "purify_team_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("PurifyTeamWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(purify_team_window_open_terminal)
state_machine.add(purify_team_window_close_terminal)
state_machine.init()

function PurifyTeamWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- load luf file
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.utils.resources_icon_cell")

    -- var
    self._formation_info = {}
    self._formation_ships = {}

    self.name_mould_id = 0
    
    -- Initialize purify team page state machine.
    local function init_purify_team_terminal()

        local purify_team_window_open_player_info_window_terminal = {
            _name = "purify_team_window_open_player_info_window",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local memberInfo = params._datas.member_info
                if params._datas.member_myself == true then
                    app.load("client.l_digital.campaign.digitalpurify.PurifyHeroListWindow")
                    state_machine.excute("purify_hero_list_window_open", 0, 0)
                else
                    -- app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                    -- local roleInstance = {}
                    -- roleInstance.arame = memberInfo.union_name
                    -- roleInstance.template = zstring.split(memberInfo.formation_info, "@")
                    -- roleInstance.icon = memberInfo.head_pic
                    -- roleInstance.name = memberInfo.nickname
                    -- roleInstance.level = memberInfo.level
                    -- roleInstance.rank = memberInfo.user_rank or 0
                    -- roleInstance.force = memberInfo.user_force or 0
                    -- roleInstance.vip = memberInfo.vip_level
                    -- roleInstance.speed = memberInfo.user_speed or 0
                    -- state_machine.excute("sm_arena_player_info_window_open",0,roleInstance)

                    local function responseShowUserInfoCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            -- local datainfo = cells.activity
                            -- datainfo.icon = cells.activity.user_head
                            -- datainfo.name = cells.activity.user_name
                            -- datainfo.level = cells.activity.user_level
                            -- datainfo.rank = cells.activity.order_value
                            -- datainfo.force = cells.activity.user_fighting
                            -- datainfo.vip = cells.activity.vip_grade
                            -- datainfo.template = {}
                            -- datainfo.template[1] = _ED.chat_user_info.formation
                            -- datainfo.arame = "?"

                            if nil ~= response.node and nil ~= response.node._datas then
                                local memberInfo = response.node._datas.member_info

                                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
                                local roleInstance = {}
                                roleInstance.user_id = _ED.chat_user_info.user_id
                                roleInstance.arame = _ED.chat_user_info.army
                                roleInstance.template = {_ED.chat_user_info.formation} -- zstring.split(memberInfo.formation_info, "@")
                                roleInstance.icon = memberInfo.head_pic
                                roleInstance.name = memberInfo.nickname
                                roleInstance.level = memberInfo.level
                                roleInstance.rank = nil -- memberInfo.user_rank or 0
                                roleInstance.force = _ED.chat_user_info.fighting or 0
                                roleInstance.vip = memberInfo.vip_level
                                -- roleInstance.speed = _ED.chat_user_info.speed or 0
                                state_machine.excute("sm_arena_player_info_window_open", 0, roleInstance)
                            end
                        end
                    end
                    
                    protocol_command.see_user_info.param_list = memberInfo.user_id
                    NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, params, responseShowUserInfoCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local purify_team_window_change_hero_team_terminal = {
            _name = "purify_team_window_change_hero_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDigitalPurifyTeamChangeHeroCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            return
                        end
                        response.node:onUpdateDraw()
                    end
                end

                local shipId = params
                protocol_command.ship_purify_team_manager.param_list = "6\r\n" .. _ED.digital_purify_info._team_info.team_type .. "\r\n" .. shipId .. "\r\n"
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyTeamChangeHeroCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local purify_team_window_member_kick_out_team_terminal = {
            _name = "purify_team_window_member_kick_out_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDigitalPurifyTeamMemberKickOutCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            return
                        end
                        response.node:onUpdateDraw()
                    end
                end

                local memberInfo = params._datas.member_info
                protocol_command.ship_purify_team_manager.param_list = "8\r\n" .. _ED.digital_purify_info._team_info.team_type .. "\r\n" .. _ED.digital_purify_info._team_info.team_key .. "\r\n" .. memberInfo.user_id .. "\r\n"
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyTeamMemberKickOutCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --世界邀请
        local purify_team_window_world_invitation_team_terminal = {
            _name = "purify_team_window_world_invitation_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local teamNumber = 0
                for i , v in pairs(_ED.digital_purify_info._team_info.members) do
                    if tonumber(v.user_id) ~= -1 then
                        teamNumber = teamNumber + 1
                    end
                end
                if teamNumber >= 5 then
                    TipDlg.drawTextDailog(_new_interface_text[119])
                    return
                end
                if _ED.purify_team_send_world_message_times > 0 then
                    TipDlg.drawTextDailog(_new_interface_text[122])
                    return
                end
                local team_type = _ED.digital_purify_info._team_info.team_type
                local team_key = _ED.digital_purify_info._team_info.team_key
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_new_interface_text[121])
                        _ED.purify_team_send_world_message_times = 60--这里以后改成读表
                    end
                end
                local paramsInfo = instance.name_mould_id.."|"..team_type..","..team_key..","..instance.m_data[2]
                protocol_command.send_message.param_list = "\r\n19\r\n0\r\n47\r\n"..paramsInfo
                -- Se ESPERA la respuesta: el cartel de exito solo sale si el
                -- servidor confirma. Antes se llamaba al callback a mano en
                -- esta misma linea, o sea que prometia sin haber mandado.
                NetworkManager:socketRequest(protocol_command.send_message.code, instance, responseSendMessageCallback)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --公会邀请
        local purify_team_window_legion_invitation_team_terminal = {
            _name = "purify_team_window_legion_invitation_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local teamNumber = 0
                for i , v in pairs(_ED.digital_purify_info._team_info.members) do
                    if tonumber(v.user_id) ~= -1 then
                        teamNumber = teamNumber + 1
                    end
                end
                if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[69])
                    return
                end
                if teamNumber >= 5 then
                    TipDlg.drawTextDailog(_new_interface_text[119])
                    return
                end

                if _ED.purify_team_send_union_message_times > 0 then
                    TipDlg.drawTextDailog(_new_interface_text[122])
                    return
                end

                local team_type = _ED.digital_purify_info._team_info.team_type
                local team_key = _ED.digital_purify_info._team_info.team_key
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_new_interface_text[121])
                        _ED.purify_team_send_union_message_times = 60--这里以后改成读表
                    end
                end
                local paramsInfo = instance.name_mould_id.."|"..team_type..","..team_key..","..instance.m_data[2]
                protocol_command.send_message.param_list = "\r\n20\r\n0\r\n47\r\n"..paramsInfo
                -- Se ESPERA la respuesta: el cartel de exito solo sale si el
                -- servidor confirma. Antes se llamaba al callback a mano en
                -- esta misma linea, o sea que prometia sin haber mandado.
                NetworkManager:socketRequest(protocol_command.send_message.code, instance, responseSendMessageCallback)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local purify_team_window_exit_team_terminal = {
            _name = "purify_team_window_exit_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDigitalPurifyTeamExitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.digital_purify_info._team_info = {}
                        if response.node == nil or response.node.roots == nil then
                            return
                        end
                        state_machine.excute("purify_choice_window_open", 0, response.node._rootWindows)
                        state_machine.excute("purify_team_window_close", 0, 0)
                    end
                end
                protocol_command.ship_purify_team_manager.param_list = "2\r\n" .. _ED.digital_purify_info._team_info.team_type .. "\r\n"
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyTeamExitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local purify_team_window_refresh_team_terminal = {
            _name = "purify_team_window_refresh_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDigitalPurifyTeamRefreshCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            return
                        end
                        if nil ~= _ED.digital_purify_info then
                            if nil ~= _ED.digital_purify_info._team_info 
                                and nil ~= _ED.digital_purify_info._team_info.team_type
                                and _ED.digital_purify_info._team_info.team_type < 0  
                                then
                                state_machine.excute("purify_choice_window_open", 0, response.node._rootWindows)
                                state_machine.excute("purify_team_window_close", 0, 0)
                            else
                                response.node:onUpdateDraw()
                            end
                        end
                    end
                end

                protocol_command.ship_purify_team_manager.param_list = "3\r\n" .. _ED.digital_purify_info._team_info.team_type .. "\r\n".._ED.digital_purify_info._team_info.team_key
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyTeamRefreshCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        local purify_team_window_formation_change_back_terminal = {
            _name = "purify_team_window_formation_change_back",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("purify_team_window_update_draw", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        local purify_team_window_formation_change_request_terminal = {
            _name = "purify_team_window_formation_change_request",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDigitalPurifyFormationChangeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            local purify_user_ship = {}
                            for i,v in pairs(instance._formation_info) do
                                if tonumber(v) ~= -1 then
                                    for j,w in pairs(_ED.purify_user_ship) do
                                        if tonumber(v) == tonumber(w.add_position) then
                                            purify_user_ship[i-1] = w 
                                            break
                                        end
                                    end
                                end
                            end
                            _ED.purify_user_ship = purify_user_ship
                            return
                        end
                    end
                end
                
                protocol_command.ship_purify_team_manager.param_list = "9\r\n" .. _ED.digital_purify_info._team_info.team_type .. "\r\n" .. _ED.digital_purify_info._team_info.team_key .. "\r\n" .. zstring.concat(params, ",")
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyFormationChangeCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local purify_team_window_formation_change_terminal = {
            _name = "purify_team_window_formation_change",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.formation.FormationChange")
                state_machine.excute("formation_change_window_open", 0, {
                    "purify_team_window_launch_team", 
                    "purify_team_window_formation_change_request", 
                    "purify_team_window_formation_change_back", 
                    2, --[[formation_type]]
                    instance._formation_info,
                    instance._formation_ships
                    })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local purify_team_window_launch_team_terminal = {
            _name = "purify_team_window_launch_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.purify_formation_info = instance._formation_info
                instance:fight()
                -- local function responseBattleStartCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         --> print("数据回来了 啦啦啦啦。。。战斗结果是：", _ED.attackData.isWin)
                --         if response.node == nil or response.node.roots == nil then
                --             return
                --         end
                --         app.load("client.battle.report.BattleReport")
                --         app.load("client.battle.BattleStartEffect")
                        
                --         _ED.user_info.last_user_grade = _ED.user_info.user_grade
                --         _ED.user_info.last_user_experience = _ED.user_info.user_experience
                --         _ED.user_info.last_user_grade_need_experience = _ED.user_info.user_grade_need_experience
                        
                --         fwin:cleanView(fwin._windows)
                --         fwin:freeAllMemeryPool()
                --         local bse = BattleStartEffect:new()
                --         bse:init(_enum_fight_type._fight_type_53)
                --         fwin:open(bse, fwin._windows)
                --     end
                -- end

                -- local scene = dms.searchs(dms["pve_scene"], pve_scene.scene_type, "53")
                -- instance._scene = scene
                -- instance._scene_id = scene[1][1]
                -- instance._npc_id = instance.m_data[3]
                -- instance.currentSceneType = 53

                -- _ED._current_scene_id = instance._scene_id
                -- _ED._scene_npc_id = instance._npc_id
                -- _ED._npc_difficulty_index = 1
                -- -- print(_ED._current_scene_id, _ED._scene_npc_id, _ED._npc_difficulty_index, pve_scene.scene_type)
                -- -- protocol_command.ship_purify_team_launch.param_list = "" .. _ED.digital_purify_info._team_info.team_type .. "\r\n" .. instance.currentSceneType .."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
                -- protocol_command.ship_purify_team_launch.param_list = "" .. _ED.digital_purify_info._team_info.team_type .. "\r\n" .. zstring.concat(instance._formation_info, ",")
                -- NetworkManager:register(protocol_command.ship_purify_team_launch.code, nil, nil, nil, instance, responseBattleStartCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    

        local purify_team_window_privilege_team_terminal = {
            _name = "purify_team_window_privilege_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDigitalPurifyTeamPrivilegeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            return
                        end

                        local CheckBox_tip_3 = ccui.Helper:seekWidgetByName(response.node.roots[1], "CheckBox_tip_3")
                        CheckBox_tip_3:setSelected(_ED.digital_purify_info._team_info.join_state == 0)
                    end
                end

                protocol_command.ship_purify_team_manager.param_list = "7\r\n" .. _ED.digital_purify_info._team_info.team_type .. "\r\n" .. _ED.digital_purify_info._team_info.team_key .. "\r\n"
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyTeamPrivilegeCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local purify_team_window_update_draw_terminal = {
            _name = "purify_team_window_update_draw",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if nil ~= _ED.digital_purify_info then
                        if nil ~= _ED.digital_purify_info._team_info 
                            and nil ~= _ED.digital_purify_info._team_info.team_type
                            and _ED.digital_purify_info._team_info.team_type < 0  
                            then
                            state_machine.excute("purify_choice_window_open", 0, instance._rootWindows)
                            state_machine.excute("purify_team_window_close", 0, 0)
                        else
                            instance:onUpdateDraw()
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(purify_team_window_open_player_info_window_terminal)
        state_machine.add(purify_team_window_change_hero_team_terminal)
        state_machine.add(purify_team_window_member_kick_out_team_terminal)
        state_machine.add(purify_team_window_world_invitation_team_terminal)
        state_machine.add(purify_team_window_legion_invitation_team_terminal)
        state_machine.add(purify_team_window_exit_team_terminal)
        state_machine.add(purify_team_window_refresh_team_terminal)
        state_machine.add(purify_team_window_formation_change_back_terminal)
        state_machine.add(purify_team_window_formation_change_request_terminal)
        state_machine.add(purify_team_window_formation_change_terminal)
        state_machine.add(purify_team_window_launch_team_terminal)
        state_machine.add(purify_team_window_privilege_team_terminal)
        state_machine.add(purify_team_window_update_draw_terminal)

        state_machine.init()
    end
    
    -- call func init purify team state machine.
    init_purify_team_terminal()
end

function PurifyTeamWindow:init( params )
    self._rootWindows = params
    self.m_data = _ED.digital_purify_info._heros[_ED.digital_purify_info._team_info.team_type + 1]
    return self
end

function PurifyTeamWindow:onUpdate(dt)

end

function PurifyTeamWindow:fight()

    -- 战斗请求
    local function responseBattleInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            --state_machine.excute("page_stage_fight_data_deal", 0, 0)
        
            cacher.removeAllTextures()
            
            fwin:cleanView(fwin._windows)
            cc.Director:getInstance():purgeCachedData()
            
            local bse = BattleStartEffect:new()
            bse:init(53)
            fwin:open(bse, fwin._windows)
        end
    end

    local function launchBattle()
        app.load("client.battle.fight.FightEnum")
        local fightType = state_machine.excute("fight_get_current_fight_type", 0, nil)
        local function responseBattleStartCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                app.load("client.battle.report.BattleReport")
                app.load("client.battle.BattleStartEffect")
                local resultBuffer = {}
                if _ED._fightModule == nil then
                    _ED._fightModule = FightModule:new()
                end
                _ED.attackData = {
                    roundCount = _ED._fightModule.totalRound,
                    roundData ={}
                }
                if _ED._scene_npc_id == nil or _ED._scene_npc_id == "" or tonumber(_ED._scene_npc_id) == 0 then
                    _ED._scene_npc_id = _ED._scene_npc_copy_net_id
                end
                local fightType = 0
                fightType = _enum_fight_type._fight_type_53
                
                -- _ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
                _ED._fightModule:initPurifyFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)

                local orderList = {}
                _ED._fightModule:initFightOrder(_ED.user_info, orderList)
                
                responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
            else
                _ED._current_scene_id = ""
                _ED._scene_npc_id = ""
                _ED.trial_scene_npc_id = ""
                _ED._npc_difficulty_index = ""
                _ED.trial_star_Magnification = 1
            end
        end
        responseBattleStartCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
    end

    local shipMouldId = self.m_data[2]
    local ship = fundShipWidthTemplateId(shipMouldId)
    local pos = 0
    if ship ~= nil then
        local ship_evo = zstring.split(ship.evolution_status, "|")
        pos = tonumber(ship_evo[1]) - 1
        -- if nil == self.m_data[3 + pos] or tonumber(self.m_data[3 + pos]) <= 0 then
        --     pos = 0
        -- end
    end
    if pos > 0 then
        if tonumber(self.m_data[6]) == -1 then
            pos = pos - 1
        end
    end
    local scene = dms.searchs(dms["pve_scene"], pve_scene.scene_type, "53")
    self._scene = scene
    self._scene_id = scene[1][1]
    self._npc_id = self.m_data[3 + pos]
    self.currentSceneType = 53

    _ED._current_scene_id = self._scene_id
    _ED._scene_npc_id = self._npc_id
    _ED._npc_difficulty_index = 1

    launchBattle()
end

function PurifyTeamWindow:onUpdateDraw()
    local root = self.roots[1]
    local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
    if Panel_dh ~= nil then
        Panel_dh:removeAllChildren(true)
    end
    local shipMouldId = self.m_data[2]

    local ship = fundShipWidthTemplateId(shipMouldId)
    local shipInitGroup = 1
    local havhHero = false
    if ship ~= nil then
        local ship_evo = zstring.split(ship.evolution_status, "|")
        shipInitGroup = tonumber(ship_evo[1])
        havhHero = true
    else
        shipInitGroup = dms.int(dms["ship_mould"], tonumber(shipMouldId), ship_mould.captain_name)
    end

    local evo_image = dms.string(dms["ship_mould"], tonumber(shipMouldId), ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    local shipEvoMouldId = tonumber(evo_info[shipInitGroup])
    --敌方英雄不按照皮肤绘制
    _ED.purify_team_name = shipEvoMouldId
    if ship then shipEvoMouldId = smGetSkinEvoIdChange(ship) end
    local picIndex = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.form_id)
    
    _ED._purify_choice_rold_pic_index = picIndex

    local name_mould_id = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.name_index)
    local shipName = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
    
    local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name")
    Text_digimon_name:setString(shipName)
    self.name_mould_id = name_mould_id

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        local armature_hero = sp.spine_sprite(Panel_dh, picIndex, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        armature_hero:setScaleX(-1)
        self.armature_hero = armature_hero
        armature_hero.animationNameList = spineAnimations
        sp.initArmature(self.armature_hero, true)
        local function changeActionCallback( armatureBack )
            -- if self.play_index == 14 then
            --  if self ~= nil and self.roots ~= nil then
            --      state_machine.excute("formation_hero_develop_play_hero_animation",0,self.animation_index)
            --  end
            -- elseif self.play_index == 38 then
            --  if self ~= nil and self.roots ~= nil then
            --      state_machine.excute("formation_hero_develop_play_hero_animation",0,14)
            --  end
            -- elseif self.play_index == self.animation_index then
            --  if self ~= nil and self.roots ~= nil then
            --      state_machine.excute("formation_hero_develop_play_hero_animation",0,0)
            --  end
            -- end  
        end
        local actionIndex = _enum_animation_l_frame_index.animation_standby

        armature_hero._self = self
        -- armature_hero:getAnimation():setFrameEventCallFunc(onFrameEventRole)
        armature_hero._invoke = changeActionCallback
        armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(self.armature_hero, actionIndex, 0, false)
        armature_hero._nextAction = 0
    else
        local Panel_digimon_animation = ccui.Helper:seekWidgetByName(root, "Panel_digimon_animation")
        if Panel_digimon_animation ~= nil then
            Panel_digimon_animation:removeBackGroundImage()
            Panel_digimon_animation:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
        end
    end

    local CheckBox_tip_3 = ccui.Helper:seekWidgetByName(root, "CheckBox_tip_3")
    local Text_tip_3 = ccui.Helper:seekWidgetByName(root, "Text_tip_3")
    CheckBox_tip_3:setVisible(false)
    Text_tip_3:setVisible(false)

    local captain = false
    local myselfCompleted = false
    local myselMemberInfo = nil
    for i, v in pairs(_ED.digital_purify_info._team_info.members) do
        local memberInfo = v
        if memberInfo.user_id == zstring.tonumber(_ED.user_info.user_id)  then
            if memberInfo.member_type == 1 then
                CheckBox_tip_3:setVisible(true)
                Text_tip_3:setVisible(true)
                captain = true
                if memberInfo.complete_count >= 3 then
                    myselfCompleted = true
                end
            elseif memberInfo.member_type ~= 1 then
                if memberInfo.complete_count >= 3 then
                    myselfCompleted = true
                end
            end
            myselMemberInfo = memberInfo
            break
        end
    end

    local myselFormationInfos = zstring.split(myselMemberInfo.formation_info, "@")
    self._formation_info = zstring.split(myselFormationInfos[3], ",")
    if #self._formation_info == 6 then
        table.insert(self._formation_info, "6")
    end
    if #self._formation_info > 7 then
        self._formation_info = {"-1", "1", "2", "3", "4", "5", "6"}
    end
    local completeTotalCount = 0
    _ED.purify_user_ship = {}
    self._formation_ships = {}
    for i = 1, 5 do
        local Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player_" .. i)
        local Panel_player_head = ccui.Helper:seekWidgetByName(root, "Panel_player_head_" .. i)
        local Image_no_people = ccui.Helper:seekWidgetByName(root, "Image_no_people_" .. i)
        local Text_name = ccui.Helper:seekWidgetByName(Panel_player, "Text_name_" .. i)
        local Text_wait = ccui.Helper:seekWidgetByName(Panel_player, "Text_wait_" .. i)
        local Text_number = ccui.Helper:seekWidgetByName(Panel_player, "Text_number_" .. i)
        local Button_kick = ccui.Helper:seekWidgetByName(root, "Button_kick_" .. i)
        local Button_change = ccui.Helper:seekWidgetByName(root, "Button_change_" .. i)
        local Image_dz = ccui.Helper:seekWidgetByName(root, "Image_dz_".. i)
        local memberInfo = _ED.digital_purify_info._team_info.members[i]

        Panel_player_head:removeAllChildren(true)
        if Image_dz then
            Image_dz:setVisible(false)
        end
        if memberInfo.user_id > 0 then
            -- 头像
            local formationInfos = zstring.split(memberInfo.formation_info, "@")
            local maxCombatForce = 0
            local maxCombatForceHero = nil
            if #formationInfos == 1 then
                local formationInfo = zstring.splits(formationInfos[1], "!", ":")
                for _, v in pairs(formationInfo) do
                    local combatForce = tonumber(v[6])
                    if combatForce > maxCombatForce then
                        maxCombatForceHero = v
                        maxCombatForce = combatForce
                    end
                end
            else
                maxCombatForceHero = zstring.split(formationInfos[2], ":")
            end
            self._formation_ships["" .. i] = {
                ship_template_id = maxCombatForceHero[1],
                evolution_status = maxCombatForceHero[3],
                Order = maxCombatForceHero[5],
                ship_grade = maxCombatForceHero[2],
                hero_fight = maxCombatForceHero[6],
                skin_id = maxCombatForceHero[11]
            }

            --模板id:等级:进阶数据:星级:品阶:战力:实例ID:速度:斗魂:技能等级：皮肤id
            local cell = HeroIconListCell:createCell()
            local ship = {}
            ship.ship_template_id = maxCombatForceHero[1]
            ship.evolution_status = maxCombatForceHero[3]
            ship.Order = maxCombatForceHero[5]
            ship.StarRating = maxCombatForceHero[4]
            ship.ship_grade = maxCombatForceHero[2]
            ship.ship_id = -1
            ship.skin_id = maxCombatForceHero[11]
            cell:init(ship, 1, true)
            Panel_player_head:addChild(cell)

            local Panel_prop = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
            Panel_prop:setTouchEnabled(false)


            Image_no_people:setVisible(false)
            Text_name:setVisible(true)
            Text_number:setVisible(true)
            Text_wait:setVisible(false)

            Button_kick:setVisible(false)

            Text_name:setString(memberInfo.nickname)
            local max_count = zstring.split(dms.string(dms["play_config"], 20, play_config.param), ",")[2]
            Text_number:setString(string.format(_new_interface_text[212], "" .. memberInfo.complete_count, ""..max_count))

            local color = nil
            if memberInfo.complete_count <= 0 then
                color = cc.c3b(255, 0, 0)
                Text_number:setColor(color)
            elseif memberInfo.complete_count >= 3 then
                completeTotalCount = completeTotalCount + 1
            end

            local memberMyself = false
            if memberInfo.user_id == zstring.tonumber(_ED.user_info.user_id) then
                Button_change:setVisible(true)
                memberMyself = true
                -- 更换参战角色
                fwin:addTouchEventListener(Button_change, nil, 
                {
                    terminal_name = "purify_team_window_open_player_info_window", 
                    terminal_state = 0,
                    isPressedActionEnabled = true,
                    member_info = memberInfo,
                    member_myself = memberMyself
                },
                nil,0)
            elseif captain and memberInfo.member_type ~= 1 and memberInfo.complete_count <= 0 then
                -- 踢除成员
                fwin:addTouchEventListener(Button_kick, nil, 
                {
                    terminal_name = "purify_team_window_member_kick_out_team", 
                    terminal_state = 0,
                    isPressedActionEnabled = true,
                    member_info = memberInfo,
                    member_myself = memberMyself
                },
                nil,0)
                Button_kick:setVisible(true)
                Button_kick:setTouchEnabled(true)
            end

            if tonumber(memberInfo.member_type) == 1 then
                if Image_dz then
                    Image_dz:setVisible(true)
                end
            end

            -- 更换参战角色
            fwin:addTouchEventListener(Panel_player_head, nil, 
            {
                terminal_name = "purify_team_window_open_player_info_window", 
                terminal_state = 0,
                isPressedActionEnabled = true,
                member_info = memberInfo,
                member_myself = memberMyself
            },
            nil,0)
            Panel_player_head:setTouchEnabled(true)

            --净化战船属性
            --生命,攻击,防御,暴击率,暴击加成,抗暴率,格挡率,格挡加成,破格挡率,伤害加成,伤害减免,皮肤ID
            local attributes = zstring.split(memberInfo.ship_attributes, ",")
            local purifyusership ={}
            purifyusership.ship_template_id = maxCombatForceHero[1]
            purifyusership.evolution_status = maxCombatForceHero[3]
            purifyusership.Order = maxCombatForceHero[5]
            purifyusership.StarRating = maxCombatForceHero[4]
            purifyusership.ship_grade = maxCombatForceHero[2]
            purifyusership.ship_health = attributes[1]
            purifyusership.ship_courage = attributes[2]
            purifyusership.ship_intellect = attributes[3]
            purifyusership.crit_add = attributes[4]
            purifyusership.crit_hurt_add = attributes[5]
            purifyusership.uncrit_add = attributes[6]
            purifyusership.parry_add = attributes[7]
            purifyusership.parry_unhurt_add = attributes[8]
            purifyusership.unparry_add = attributes[9]
            purifyusership.hurt_add = attributes[10]
            purifyusership.unhurt_add = attributes[11]
            purifyusership.skillPoint = 0
            purifyusership.initial_sp_increase = 0
            purifyusership.ship_wisdom = tonumber(maxCombatForceHero[8])
            purifyusership.battle_m_types = 53
            purifyusership.hero_fight = maxCombatForceHero[6]
            purifyusership.add_position = i
            purifyusership.ship_fighting_spirit = maxCombatForceHero[9]
            purifyusership.skillLevel = maxCombatForceHero[10]
            purifyusership.property_values = attributes[12]
            purifyusership.skin_id = maxCombatForceHero[11]
            purifyusership.ship_id = nil
            if memberInfo.user_id == zstring.tonumber(_ED.user_info.user_id) then
                local myShipInfo = getShipByTemplateId(maxCombatForceHero[1])
                purifyusership.ship_id = myShipInfo.ship_id
            end

            _ED.purify_user_ship[i] = purifyusership

        else
            Panel_player_head:setTouchEnabled(false)

            Image_no_people:setVisible(true)
            Text_name:setVisible(false)
            Text_number:setVisible(false)
            Text_wait:setVisible(true)

            Button_change:setVisible(false)

            Button_kick:setVisible(false)
            Button_kick:setTouchEnabled(false)
            _ED.purify_user_ship[i] = nil
        end
    end

    local purify_user_ship = {}
    for i,v in pairs(self._formation_info) do
        if tonumber(v) ~= -1 then
            for j,w in pairs(_ED.purify_user_ship) do
                if tonumber(v) == tonumber(w.add_position) then
                    purify_user_ship[i-1] = w 
                    break
                end
            end
        end
    end
    _ED.purify_user_ship = purify_user_ship

    -- 完成的人数
    local Text_player_n = ccui.Helper:seekWidgetByName(root, "Text_player_n")
    Text_player_n:setString("" .. completeTotalCount)

    local rewardMultiple = completeTotalCount - 2
    if rewardMultiple < 0 then
        rewardMultiple = 0
    end

    local rewardInfo = zstring.splits(dms.string(dms["play_config"], 19, pirates_config.param), "|", ",")

    local Panel_reward_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_1")
    Panel_reward_1:removeAllChildren(true)
    local cell = ResourcesIconCell:createCell()
    cell:init(13, tonumber(rewardInfo[1][3]) * rewardMultiple, tonumber(shipMouldId),nil,nil,true,true,1,{shipStar = 0})
    Panel_reward_1:addChild(cell)

    local Text_reward_n_1 = ccui.Helper:seekWidgetByName(root, "Text_reward_n_1")
    local rewardShipCount = tonumber(rewardInfo[1][3]) * rewardMultiple
    Text_reward_n_1:setString("x" .. rewardShipCount)

    local Text_reward_n_2 = ccui.Helper:seekWidgetByName(root, "Text_reward_n_2")
    local rewardGoldCount = tonumber(rewardInfo[2][3]) * rewardMultiple
    Text_reward_n_2:setString("x" .. rewardGoldCount)

    local Button_world_invitation = ccui.Helper:seekWidgetByName(root, "Button_world_invitation")
    local Button_legion_invitation = ccui.Helper:seekWidgetByName(root, "Button_legion_invitation")
    local Button_go_away = ccui.Helper:seekWidgetByName(root, "Button_go_away")
    local Button_refresh = ccui.Helper:seekWidgetByName(root, "Button_refresh")
    local Button_battle_start = ccui.Helper:seekWidgetByName(root, "Button_battle_start")
    local Image_over = ccui.Helper:seekWidgetByName(root, "Image_over")
    if true == myselfCompleted then
        Image_over:setVisible(true)
        
        -- Button_world_invitation:setVisible(false)
        -- Button_legion_invitation:setVisible(false)
        Button_go_away:setVisible(false)
        Button_refresh:setVisible(false)
        Button_battle_start:setVisible(false)

        CheckBox_tip_3:setVisible(false)
        Text_tip_3:setVisible(false)
    else
        Image_over:setVisible(false)

        Button_world_invitation:setVisible(true)
        Button_legion_invitation:setVisible(true)
        if myselMemberInfo.complete_count > 0 then
            Button_go_away:setVisible(false)
        else
            Button_go_away:setVisible(true)
        end
        Button_refresh:setVisible(true)
        Button_battle_start:setVisible(true)
    end
end

function PurifyTeamWindow:onEnterTransitionFinish()
    local csbPurifyTeamWindow = csb.createNode("campaign/DigitalPurify/digital_purify_tab_2.csb")
    self:addChild(csbPurifyTeamWindow)
    local root = csbPurifyTeamWindow:getChildByName("root")
    table.insert(self.roots, root)

    -- 打开规则窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil, 
    {
        func_string = [[state_machine.excute("purify_help_window_open", 0, 0)]], 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 世界邀请
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_invitation"), nil, 
    {
        terminal_name = "purify_team_window_world_invitation_team", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)

    -- 公会邀请
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_invitation"), nil, 
    {
        terminal_name = "purify_team_window_legion_invitation_team", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)

    -- 退出队伍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go_away"), nil, 
    {
        terminal_name = "purify_team_window_exit_team", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)

    -- 刷新队伍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh"), nil, 
    {
        terminal_name = "purify_team_window_refresh_team", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)

    -- 战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_battle_start"), nil, 
    {
        terminal_name = "purify_team_window_formation_change", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_purify_duplicate",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_battle_start"),
        _invoke = nil,
        _interval = 0.5,})

    -- 队伍加入权限设置
    local CheckBox_tip_3 = ccui.Helper:seekWidgetByName(root, "CheckBox_tip_3")
    fwin:addTouchEventListener(CheckBox_tip_3, nil, 
    {
        terminal_name = "purify_team_window_privilege_team", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0):setSelected(_ED.digital_purify_info._team_info.join_state == 0)
    CheckBox_tip_3:setVisible(false)

    -- 添加背景光效
    local Panel_digimon_animation = ccui.Helper:seekWidgetByName(root, "Panel_digimon_animation")
    -- 创建光效
    local armature = nil
    if animationMode == 1 then
        -- armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        -- armature.animationNameList = spineAnimations
        -- sp.initArmature(armature, true)
        armature = sp.spine_effect("sprite_heisechilun", effectAnimations[1], false, nil, nil, nil, nil, nil, nil, "sprite/")
        armature.animationNameList = effectAnimations
        sp.initArmature(armature, true)
    else
        local armatureName, fileName = self:loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end
    -- table.insert(self.animationList, {fileName = fileName, armature = armature})
    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    -- local _tcamp = zstring.tonumber(""..self.roleCamp)
    local _armatureIndex = 0 -- frameListCount * _tcamp
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    Panel_digimon_animation:addChild(armature)
    armature:setPositionX(Panel_digimon_animation:getContentSize().width / 2)

    self:onUpdateDraw()
end

function PurifyTeamWindow:onExit()
    state_machine.remove("purify_team_window_open_player_info_window")
    state_machine.remove("purify_team_window_change_hero_team")
    state_machine.remove("purify_team_window_member_kick_out_team")
    state_machine.remove("purify_team_window_world_invitation_team")
    state_machine.remove("purify_team_window_legion_invitation_team")
    state_machine.remove("purify_team_window_exit_team")
    state_machine.remove("purify_team_window_refresh_team")
    state_machine.remove("purify_team_window_formation_change_back")
    state_machine.remove("purify_team_window_formation_change_request")
    state_machine.remove("purify_team_window_formation_change")
    state_machine.remove("purify_team_window_launch_team")
    state_machine.remove("purify_team_window_privilege_team")
end
