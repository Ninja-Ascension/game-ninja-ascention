-- ----------------------------------------------------------------------------------------------------
-- 说明：世界基地操作
-------------------------------------------------------------------------------------------------------
redAlertTimeMineBaseOperationInterface = class("redAlertTimeMineBaseOperationInterfaceClass", Window)

local red_alert_time_mine_base_operation_interface_open_terminal = {
    _name = "red_alert_time_mine_base_operation_interface_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("redAlertTimeMineBaseOperationInterfaceClass")
        if nil == _homeWindow then
            fwin:open(redAlertTimeMineBaseOperationInterface:new():init(params._datas.cell), fwin._dview)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_base_operation_interface_close_terminal = {
    _name = "red_alert_time_mine_base_operation_interface_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("redAlertTimeMineBaseOperationInterfaceClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("redAlertTimeMineBaseOperationInterfaceClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_base_operation_interface_open_terminal)
state_machine.add(red_alert_time_mine_base_operation_interface_close_terminal)
state_machine.init()
    
function redAlertTimeMineBaseOperationInterface:ctor()
    self.super:ctor()
    self.roots = {}
    self._cell = nil
    self._isMy = true
    self.local_time = 0
    self.isOpenShield = false
    self.is_friend = false
    self.is_union_member = false

    self._text_time = nil
    self._leave_time = 0
    
    app.load("client.red_alert_time.worldMap.redAlertTimeMineCollectionSelection")
    app.load("client.red_alert_time.worldMap.redAlertTimeMineReconnaissance")
    app.load("client.red_alert_time.worldMap.redAlertTimeMineBattleTroopsInfor")
    
    local function init_red_alert_time_mine_base_operation_interface_terminal()
        -- 回基地
        local red_alert_time_mine_back_to_base_terminal = {
            _name = "red_alert_time_mine_back_to_base",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("home_button_select_page", 0, params)
                state_machine.excute("red_alert_time_mine_base_operation_interface_close", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 刷新界面
        local red_alert_time_mine_back_to_base_update_terminal = {
            _name = "red_alert_time_mine_back_to_base_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --收藏和取消收藏的操作
        local red_alert_time_mine_back_to_base_collection_or_cancel_terminal = {
            _name = "red_alert_time_mine_back_to_base_collection_or_cancel",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._cell.collection_type == 0 then
                    local function requesrDeletecoordinate(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(friends_tip_string[11])
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                _ED.world_map.coord_collent[""..response.node._cell.recording_type][response.node._cell.info._type.."," .. response.node._cell.info._id] = nil
                                state_machine.excute("red_alert_time_mine_back_to_base_update", 0, 0)
                            end
                        end
                    end
                    protocol_command.world_coord_collect.param_list = "0" .. "\r\n" .. "" .. instance._cell.recording_type .. "-" ..instance._cell.info._type .. "," .. instance._cell.info._id .."\r\n"..instance._cell.info._nickname.."|"..instance._cell.info._level.."|"..instance._cell.info._x..","..instance._cell.info._y
                    NetworkManager:register(protocol_command.world_coord_collect.code, nil, nil, nil, instance, requesrDeletecoordinate, false, nil)
                else
                    state_machine.excute("red_alert_time_mine_collection_selection_open", 0, {_datas={m_type = 3, cells = instance._cell}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 进攻
        local red_alert_time_mine_back_to_base_attack_terminal = {
            _name = "red_alert_time_mine_back_to_base_attack",
            _init = function (terminal)
                app.load("client.red_alert_time.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.is_union_member == true then
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance._cell.info ,playersOrmine = 6,isForce = params}})
                else
                    if __lua_project_id == __lua_project_pacific_rim then
                        state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance._cell.info ,playersOrmine = 0,isForce = params,
                            next_terminal = "formation_defend_add_investigate_formation_info", next_terminal_params = {instance._cell, false}}})
                    else
                        state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance._cell.info ,playersOrmine = 0,isForce = params}})
                    end
                end
                state_machine.excute("red_alert_time_mine_base_operation_interface_close",0,0)
                -- local function requesrAttack(response)
                    -- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- state_machine.excute("adventure_mine_force_mobile", 0, {_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,instance._cell.info._x,instance._cell.info._y})
                        -- state_machine.excute("red_alert_time_mine_event_queue_refresh_the_interface_list", 0, 0)
                        -- state_machine.excute("red_alert_time_mine_base_operation_interface_close", 0, 0)
                    -- end
                -- end
                -- local m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,instance._cell.info._x,instance._cell.info._y)
                
                -- protocol_command.world_add_target_event.param_list = "8" .. "\r\n" ..instance._cell.info._x.."\r\n" ..instance._cell.info._y.."\r\n"..m_times.."\r\n0"
                -- NetworkManager:register(protocol_command.world_add_target_event.code, nil, nil, nil, nil, requesrAttack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 保护罩购买
        local red_alert_time_mine_back_to_base_protective_cover_terminal = {
            _name = "red_alert_time_mine_back_to_base_protective_cover",
            _init = function (terminal)
                app.load("client.red_alert_time.props.PropsUse")
                app.load("client.red_alert_time.cells.props.props_use_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local resource_type = {40,39,38}
                -- local info = _ED.base_build_shop_info["9"][""..resource_type[1]]
                local info = {}
                info.id = 17
                local prop_ids_info = dms.string(dms["build_shop"], info.id, build_shop.prop_ids)
                local prop_data = zstring.split(prop_ids_info, ",")
                info.prop_ids = {
                    prop_data[1],
                    prop_data[2],
                    prop_data[3],
                }
                state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 9})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --时间结束校验时间
        local red_alert_time_mine_back_to_base_update_cover_terminal = {
            _name = "red_alert_time_mine_back_to_base_update_cover",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --当前状态没改变，但是时间到了需要校验
                local function requesrUpdateCoverCheck(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("red_alert_time_mine_back_to_base_update",0,0)
                        end 
                    end
                end
                NetworkManager:register(protocol_command.gain_limit_check.code, nil, nil, nil, instance, requesrUpdateCoverCheck, false, nil)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --操作前置
        local red_alert_time_mine_back_to_base_operation_front_terminal = {
            _name = "red_alert_time_mine_back_to_base_operation_front",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local operation_type = params._datas.operation_type

                for i, v in pairs(_ED.factor_info) do
                    if tonumber(v.factor_type) == 68 then
                        self.local_time = (v.factor_start_time+v.factor_cd_time)-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                        break
                    end
                end
                if tonumber(operation_type) == 2 then
                    if instance.is_union_member == true then
                        state_machine.excute("red_alert_time_mine_back_to_base_attack",0,0)
                        return
                    end
                end
                -- 1侦察2进攻
                if tonumber(cell.info._shield_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) > 0 then
                    if tonumber(operation_type) == 1 and instance._leave_time > 0 then
                        state_machine.excute("red_alert_time_mine_reconnaissance_investigate", 0, {cell, 1})
                    else
                        local propMoulds = dms.int(dms["prop_config"], 24+tonumber(operation_type), prop_config.param)
                        for i,v in pairs(_ED.user_prop) do
                            if tonumber(v.user_prop_template) == propMoulds then
                                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 8+tonumber(operation_type)}})
                                return
                            end
                        end 
                        TipDlg.drawTextDailog(tipStringInfo_consumption_info[16+tonumber(operation_type)])
                    end
                    return
                end
                if tonumber(operation_type) == 1 then
                    if instance._leave_time > 0 then
                        state_machine.excute("red_alert_time_mine_reconnaissance_investigate", 0, {cell, 0})
                    else
                        state_machine.excute("red_alert_time_mine_reconnaissance_open",0,{_datas = {cells = cell,m_type = 2}})
                    end
                elseif tonumber(operation_type) == 2 then
                    if instance.is_union_member == false then
                        if self.local_time > 0 then
                            state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 4}})
                            return
                        end
                        state_machine.excute("red_alert_time_mine_back_to_base_attack",0,0)
                    else
                        -- 协防
                        state_machine.excute("red_alert_time_mine_back_to_base_attack",0,0)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --私聊
        local red_alert_time_mine_back_to_base_private_chat_terminal = {
            _name = "red_alert_time_mine_back_to_base_private_chat",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_chat_sent_window_open",0,"")
                state_machine.excute("red_alert_time_chat_sent_change_to_person_chat", 0, {_datas = {user_data = {user_id = instance._cell.info._userId ,user_name = instance._cell.info._nickname }}})
                -- TipDlg.drawTextDailog("留下私聊的入口")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --写邮件
        local red_alert_time_mine_back_to_base_an_email_terminal = {
            _name = "red_alert_time_mine_back_to_base_an_email",
            _init = function (terminal)
                app.load("client.red_alert_time.mail.MailWriteAn")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("write_an_email_window_open", 0, {_datas={name=instance._cell.info._nickname,title=""}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --添加删除好友
        local red_alert_time_mine_back_to_base_friend_remove_terminal = {
            _name = "red_alert_time_mine_back_to_base_friend_remove",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.is_friend == true then
                    local function recruitDelBackCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                if fwin:find("SocialFriendTagClass") ~= nil then
                                    state_machine.excute("game_social_friend_tag_delete_friend", 0, response.node._cell.info._userId)
                                end
                                state_machine.excute("red_alert_time_mine_back_to_base_update", 0, 0)
                            end
                            TipDlg.drawTextDailog(friends_tip_string[4])
                        end
                    end
                    
                    protocol_command.friend_del.param_list = instance._cell.info._userId
                    NetworkManager:register(protocol_command.friend_del.code, nil, nil, nil, instance, recruitDelBackCallBack, false, nil)
                else
                    local function recruitDelBackCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                state_machine.excute("red_alert_time_mine_back_to_base_update", 0, 0)
                            end 
                            TipDlg.drawTextDailog(friends_tip_string[1])
                        end
                    end
                    if instance._cell.info._nickname == _ED.user_info.user_name then
                        TipDlg.drawTextDailog(friends_tip_string[7])
                        return
                    end
                    protocol_command.friend_request.param_list = instance._cell.info._nickname
                    NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitDelBackCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --分享
        local red_alert_time_mine_back_to_base_open_share_terminal = {
            _name = "red_alert_time_mine_back_to_base_open_share",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(true)
                Panel_share_close:setVisible(true)
                Animations_PlayOpenMainUI({Panel_share}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --关闭分享
        local red_alert_time_mine_back_to_base_close_share_terminal = {
            _name = "red_alert_time_mine_back_to_base_close_share",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(false)
                Panel_share_close:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --分享到聊天
        local red_alert_time_mine_back_to_base_share_chats_terminal = {
            _name = "red_alert_time_mine_back_to_base_share_chats",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                    state_machine.excute("red_alert_time_mine_back_to_base_close_share", 0, 0)          
                    TipDlg.drawTextDailog(game_share_tip_text[2])
                    return
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("red_alert_time_mine_back_to_base_close_share", 0, 0)          
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("red_alert_time_mine_back_to_base_close_share", 0, 0)
                            TipDlg.drawTextDailog(game_share_tip_text[1])
                        end 
                    end
                end
                local element = dms.element(dms["world_mine_mould"], instance._cell.info._mould_id)
                local datas = dms.string(dms["message_share"], 1, message_share.content)
                local mine_info = instance._cell.info._nickname.. friends_tip_string[12]..instance._cell.info._level.."["..instance._cell.info._x.."，"..instance._cell.info._y.."]"
                mine_info = "|2|"..mine_info
                local data1 =  string.gsub(datas, "!x@", mine_info)
                datas = data1
                -- local paramsInfo = mine_info
                local paramsInfo = "0-0,"..mine_info
                local str = chat_section[1]..dms.string(dms["message_share"], 1, message_share.jump_type).."|"..instance._cell.info._x..","..instance._cell.info._y
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n".."14".. "\r\n0\r\n1\r\n" .. zstring.exchangeTo(paramsInfo)
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=instance, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_mine_back_to_base_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_update_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_collection_or_cancel_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_attack_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_protective_cover_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_update_cover_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_operation_front_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_private_chat_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_friend_remove_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_open_share_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_close_share_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_share_chats_terminal)
        state_machine.add(red_alert_time_mine_back_to_base_an_email_terminal)
    
        state_machine.init()
    end
    
    init_red_alert_time_mine_base_operation_interface_terminal()
    
end

function redAlertTimeMineBaseOperationInterface:updateColllectionState()
    local root = self.roots[1]
    local Button_player_collection = ccui.Helper:seekWidgetByName(root,"Button_player_collection")
    Button_player_collection:setTitleText(tipStringInfo_consumption_info[21]) 
    self._cell.collection_type = 1
    for i=1,3 do
        if _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..i]~= nil then
            for j, v in pairs(_ED.world_map.coord_collent[""..i]) do
                local m_info = zstring.split(j, ",")
                if zstring.tonumber(m_info[2]) == zstring.tonumber(self._cell.info._id) then
                    ccui.Helper:seekWidgetByName(self.roots[1],"Button_player_collection"):setTitleText(tipStringInfo_consumption_info[22]) 
                    self._cell.collection_type = 0
                    self._cell.recording_type = i
                    return
                end
            end
        end
    end
end

function redAlertTimeMineBaseOperationInterface:updateDraw()
    local root = self.roots[1]
    if zstring.tonumber(_ED.user_info.user_id) ~= zstring.tonumber(self._cell.info._userId) then
        self._isMy = false
    else
        self._isMy = true
    end

    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        or tonumber(_ED.union.union_info.union_id) ~= zstring.tonumber(self._cell.info._union_id)
        then
        self.is_union_member = false
    else
        self.is_union_member = true
    end

    ccui.Helper:seekWidgetByName(root,"Button_help_infor_0"):setVisible(self._isMy)
    ccui.Helper:seekWidgetByName(root,"Button_help_infor_0_0"):setVisible(self._isMy)
    ccui.Helper:seekWidgetByName(root,"Text_player_boom_0"):setVisible(self._isMy)
    ccui.Helper:seekWidgetByName(root,"Text_player_boom_n_0"):setVisible(self._isMy)
    ccui.Helper:seekWidgetByName(root,"Button_back_base"):setVisible(self._isMy)
    
    if self._isMy == false then
        ccui.Helper:seekWidgetByName(root,"Button_player_attack"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_player_spy"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_player_collection"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_player_add_friend"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_player_chat"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_player_mail"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_arr_time"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_arr_time_n"):setVisible(true)

        if self.is_union_member == false then
            ccui.Helper:seekWidgetByName(root,"Button_player_attack"):setTitleText(formation_type_string[13])
            ccui.Helper:seekWidgetByName(root,"Button_player_attack"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root,"Button_player_attack"):setTitleText(formation_type_string[39])
            ccui.Helper:seekWidgetByName(root,"Button_player_attack"):setVisible(true)
        end
    else
        ccui.Helper:seekWidgetByName(root,"Button_player_attack"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_player_spy"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_player_collection"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_player_add_friend"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_player_chat"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_player_mail"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_arr_time"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_arr_time_n"):setVisible(false)
    end
    
    -- local element = dms.element(dms["world_mine_mould"], self._cell.info._mould_id)
    --名称+等级
    local nickname = self._cell.info._nickname
    local legion_name = self._cell.info._union_name
    local level_Info = self._cell.info._level
    if tonumber(self._cell.info._userId) == tonumber(_ED.user_info.user_id) then
        level_Info = _ED.user_info.user_grade
        nickname = _ED.user_info.user_name
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            legion_name = nil
        else
            legion_name = _ED.union.union_info.union_name
        end
    else
        local max_id = dms.int(dms["arena_config"],10,arena_config.param)
        if tonumber(self._cell.info._userId) <= max_id then
            level_Info = dms.string(dms["world_config"], 20 , world_config.param)
        end
    end
    local Text_player_name_lv= ccui.Helper:seekWidgetByName(root,"Text_player_name_lv")
    Text_player_name_lv:setString(nickname.." "..friends_tip_string[12]..level_Info) 
    --最大战斗力
    local Text_player_fight_n = ccui.Helper:seekWidgetByName(root,"Text_player_fight_n")
    Text_player_fight_n:setString(exChangeNumToString(tonumber(self._cell.info._combat_force)))
    
    --军团
    local Text_player_legion_n = ccui.Helper:seekWidgetByName(root,"Text_player_legion_n")
    if legion_name==nil or legion_name=="" then
        Text_player_legion_n:setString(activity_str_tip[18])
    else
        Text_player_legion_n:setString(legion_name)
    end
    
    
    --繁荣度
    local Text_player_boom_n = ccui.Helper:seekWidgetByName(root,"Text_player_boom_n")

    local _glories = 0
    local max_boom = 0
    if self._isMy == true then
        _glories = zstring.tonumber(_ED.user_info.booming)
        max_boom = zstring.tonumber(_ED.user_info.forage)
    else
        _glories = zstring.tonumber(self._cell.info._glories)
        if self._cell.info._online_state == 1 then
            local s_time = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self._cell.info._boom_restore_time)/1000
            _glories = getBoomReplyalgorithm(zstring.tonumber(self._cell.info._glories),zstring.tonumber(self._cell.info._max_boom),s_time)
        end
        max_boom = zstring.tonumber(self._cell.info._max_boom)
        _glories = math.min(_glories, max_boom)
    end
    
    Text_player_boom_n:setString(_glories.."/"..max_boom)
    local boom_state = 0
    local boom_bar = zstring.tonumber(_glories)/zstring.tonumber(max_boom)
    for i= 1, dms.count(dms["build_boom_lose"]) do
        local boom_proportion = tonumber(dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion))
        if boom_bar >= boom_proportion then
            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
            break
        end
    end
    local LoadingBar_boom_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_bar")
    local percentage = zstring.tonumber(_glories) / zstring.tonumber(max_boom)*100
    if boom_state == 0 then
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar.png")
    elseif boom_state == 1 then
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar_1.png")
    else
        LoadingBar_boom_bar:loadTexture("images/ui/share/loading_boom_bar_2.png")
    end
    LoadingBar_boom_bar:setPercent(percentage)
    
    if percentage == 100 then
        ccui.Helper:seekWidgetByName(root,"Button_help_infor_0"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_help_infor_0"):setBright(false)
    else
        ccui.Helper:seekWidgetByName(root,"Button_help_infor_0"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root,"Button_help_infor_0"):setBright(true)    
    end
    
    
    --坐标
    local Text_coordinate_n = ccui.Helper:seekWidgetByName(root,"Text_coordinate_n")
    Text_coordinate_n:setString(self._cell.info._x..","..self._cell.info._y)
    
    --图标
    local Panel_res_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_build_icon")
    
    -- local pic = dms.atos(element, world_mine_mould.pic)
    local sprite = nil

    if self._cell.info.talent == "" or self._cell.info.talent == nil then
        local fileName = "map/base_npc/spirte_beattacked.ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
        sprite = ccs.Armature:create("spirte_beattacked")
        local pic = zstring.split(dms.string(dms["user_experience_param"], level_Info, user_experience_param.base_pic),",")
        sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]))
    else
        -- local build_ids = zstring.split(dms.string(dms["talent_mould"], tonumber(self._cell.info._talent_id), talent_mould.base_additional), "|")
        -- local picData = zstring.split(build_ids[1], ",")
  --       local talentTime = tonumber(self._cell.info._talent_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        for i, v in pairs(self._cell.info._talent_sta_time) do
            if (self._talent_sta_time == nil) and (i=="70" or i=="83") then
                self._talent_sta_time = tonumber(v)
            elseif i=="70" or i=="83" then
                if tonumber(v) > self._talent_sta_time then
                    self._talent_sta_time = tonumber(v)
                end
            end
        end
        if self._cell.info._talent_id["70"] ~= nil and self._talent_sta_time == tonumber(self._cell.info._talent_sta_time["70"]) then
            local talentTime = tonumber(self._cell.info._talent_end_time["70"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
            if talentTime > 0 then
                local fileName = "map/base_npc/spirte_beattacked.ExportJson"
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
                sprite = ccs.Armature:create("spirte_beattacked")
                local build_ids = zstring.split(dms.string(dms["talent_mould"], tonumber(self._cell.info._talent_id["70"]), talent_mould.base_additional), "|")
                local picData = zstring.split(build_ids[1], ",")
                sprite:getAnimation():playWithIndex(tonumber(picData[2]))
            end
        elseif self._cell.info._talent_id["83"] ~= nil and self._talent_sta_time == tonumber(self._cell.info._talent_sta_time["83"]) then
            local talentTime = tonumber(self._cell.info._talent_end_time["83"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
            if talentTime > 0 then
                local build_ids = zstring.split(dms.string(dms["talent_mould"], tonumber(self._cell.info._talent_id["83"]), talent_mould.base_additional), "|")
                local picData = zstring.split(build_ids[1], ",")
                local element = dms.element(dms["world_mine_mould"], tonumber(picData[2]))
                local pic = dms.atos(element, world_mine_mould.pic)
                local armature_index = dms.atoi(element, world_mine_mould.armature_index)
                local effect_paths = string.format(config_res.images.ui.home.home_build_effect, tonumber(pic))
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
                local armature = ccs.Armature:create("home_build_"..pic)
                -- draw.initArmature(armature, nil, -1, 0, 1)
                armature:getAnimation():playWithIndex(armature_index)
                -- armature:setPosition(0,tile:getContentSize().height/2)
                armature:setScale(0.75)
                sprite = armature
            end
        end
        if sprite == nil then
            local fileName = "map/base_npc/spirte_beattacked.ExportJson"
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
            sprite = ccs.Armature:create("spirte_beattacked")
            local pic = zstring.split(dms.string(dms["user_experience_param"], level_Info, user_experience_param.base_pic),",")
            sprite:getAnimation():playWithIndex(tonumber(pic[boom_state+1]))
        end
    end
    -- local sprite = cc.Sprite:create(string.format("map/base_npc/map_%d.png", 301))
    sprite:setAnchorPoint(cc.p(0.5, 0.5))
    Panel_res_build_icon:addChild(sprite)
    sprite:setPosition(cc.p(Panel_res_build_icon:getContentSize().width/3,Panel_res_build_icon:getContentSize().height/2))

    self.is_friend = false
    for i, v in pairs(_ED.friend_info) do
        if tonumber(v.user_id) == tonumber(self._cell.info._userId) and tonumber(v.is_delete) < 1 then
            self.is_friend = true
        end
    end
    if self.is_friend == true then
        ccui.Helper:seekWidgetByName(root,"Button_player_add_friend"):setTitleText(friends_tip_string[5])
    else
        ccui.Helper:seekWidgetByName(root,"Button_player_add_friend"):setTitleText(friends_tip_string[6])
    end
    
    --防护罩
    local Text_player_boom_n_0 =  ccui.Helper:seekWidgetByName(root,"Text_player_boom_n_0")
    if self._isMy == true then
        Text_player_boom_n_0:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
        for i, v in pairs(_ED.factor_info) do
            if tonumber(v.factor_type) == 68 then
                self.local_time = (v.factor_start_time+v.factor_cd_time)-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                if self.local_time > 0 then
                    self.isOpenShield = true
                end
                break
            end
        end
        if self.isOpenShield == true then
            Text_player_boom_n_0:setString(exChangeNumToString(self.local_time))
            if Panel_res_build_icon:getChildByTag(999) ~= nil then 
                Panel_res_build_icon:removeChildByTag(999)
            end
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_shield/effect_shield.ExportJson")
            local armature = ccs.Armature:create("effect_shield")
            armature:getAnimation():playWithIndex(0)
            armature:setAnchorPoint(cc.p(0,0))
            armature:setPosition(20,40)
            armature:setTag(999)
            Panel_res_build_icon:addChild(armature)
        else
            Text_player_boom_n_0:setString(tipStringInfo_consumption_info[20])
            if Panel_res_build_icon:getChildByTag(999) ~= nil then 
                Panel_res_build_icon:removeChildByTag(999)
            end
        end
    else
        if tonumber(self._cell.info._shield_end_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) > 0 then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_shield/effect_shield.ExportJson")
            local armature = ccs.Armature:create("effect_shield")
            armature:getAnimation():playWithIndex(0)
            armature:setAnchorPoint(cc.p(0,0))
            armature:setPosition(20,40)
            armature:setTag(999)
            Panel_res_build_icon:addChild(armature)
        else
            if Panel_res_build_icon:getChildByTag(999) ~= nil then 
                Panel_res_build_icon:removeChildByTag(999)
            end
        end
    end
    
    --抵达时间
    local Text_arr_time_n = ccui.Helper:seekWidgetByName(root,"Text_arr_time_n")
    local isHelpUnion = false
    if self._isMy == false and self.is_union_member == true then 
        isHelpUnion = true
    end
    local m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,self._cell.info._x,self._cell.info._y, nil, isHelpUnion)
    Text_arr_time_n:setString(exChangeTimeToString(m_times))
    
    if self._isMy == false then
        self:updateColllectionState()
    end
    local Text_player_attack_p = ccui.Helper:seekWidgetByName(root,"Text_player_attack_p")
    Text_player_attack_p:removeAllChildren(true)
    if self._isMy == false then
        Text_player_attack_p:setPositionY(ccui.Helper:seekWidgetByName(root,"Text_player_boom_0"):getPositionY())
    end
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    local fontSize = Text_player_attack_p:getFontSize()
    if percentage < 25 then
        Text_player_attack_p:setVisible(true)
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        _richText2:setContentSize(cc.size(Text_player_attack_p:getContentSize().width, Text_player_attack_p:getContentSize().height))
        _richText2:setAnchorPoint(cc.p(0.5, 0.5))
        --local datas = string.gsub(red_alert_time_str[201],"!x@",nickname)
        --local char_str = string.gsub(datas,"!y@",self._cell.info._ruin_name)
  --       local char_str = string.format(red_alert_time_str[201],nickname,self._cell.info._ruin_name)
		-- local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		-- char_str, 
		-- cc.c3b(189, 206, 224),
		-- cc.c3b(189, 206, 224),
		-- 0, 
		-- 0, 
		-- config_res.font.font_name, 
		-- fontSize,
		-- chat_rich_text_color)

        --去字体
        local datas = string.split(red_alert_time_str[201],"!x@")
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]), 255, nickname, fontName,fontSize)
        _richText2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 255, datas[1], config_res.font.font_name,fontSize)
        _richText2:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]), 255, self._cell.info._ruin_name, fontName,fontSize)
        _richText2:pushBackElement(re3)  
        local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 255, datas[2], config_res.font.font_name,fontSize)
        _richText2:pushBackElement(re4)
        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        _richText2:setPositionY(Text_player_attack_p:getContentSize().height/2)
        _richText2:setPositionX(Text_player_attack_p:getContentSize().width)
        Text_player_attack_p:addChild(_richText2)
    else
        Text_player_attack_p:setVisible(false)
    end

    self:updateInvestigateInfo()
end

function redAlertTimeMineBaseOperationInterface:updateInvestigateInfo()
    local root = self.roots[1]
    -- 侦查剩余时间
    local Text_world_surplus_t = ccui.Helper:seekWidgetByName(root,"Text_world_surplus_t")
    local Text_world_surplus_n = ccui.Helper:seekWidgetByName(root,"Text_world_surplus_n")

    local leave_time = 0
    if zstring.tonumber(_ED.world_investigate_end_time) > 0 then
        leave_time = _ED.world_investigate_end_time - (os.time() - _ED.world_investigate_start_time)
    end
    if leave_time > 0 then
        Text_world_surplus_t:setVisible(true)
        Text_world_surplus_n:setVisible(true)

        Text_world_surplus_n:setString(exChangeTimeToString(leave_time))
    else
        Text_world_surplus_t:setVisible(false)
        Text_world_surplus_n:setVisible(false)
    end
    self._text_time = Text_world_surplus_n
    self._leave_time = leave_time
end

function redAlertTimeMineBaseOperationInterface:onUpdate(dt)
    if self._isMy == true then
        if self.isOpenShield == true and self.local_time ~= 0 then
            self.local_time = self.local_time - dt
            if self.local_time <= -1 then -- 客户端多一秒延时
                self.local_time = 0
                self.isOpenShield = false
                state_machine.excute("red_alert_time_mine_back_to_base_update_cover",0,0)
            end
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_player_boom_n_0"):setString(exChangeTimeToString(self.local_time))
        end
    end

    if self._text_time ~= nil and self._leave_time > 0 then
        self._leave_time = self._leave_time - dt
        self._text_time:setString(exChangeTimeToString(self._leave_time))
        if self._leave_time <= 0 then
            self._text_time = nil
            self:updateInvestigateInfo()
        end
    end
end

function redAlertTimeMineBaseOperationInterface:init(cell)
    self._cell = cell
    self:onInit()
    return self
end

function redAlertTimeMineBaseOperationInterface:onInit()
    local csbredAlertTimeMineBaseOperationInterface = csb.createNode(config_csb.base_operation_interface)
    local root = csbredAlertTimeMineBaseOperationInterface:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineBaseOperationInterface)
    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_infor_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_base_operation_interface_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_base_operation_interface_close",
        terminal_state = 0,
    },
    nil,3)
    
    --回基地
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back_base"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        select_page = 1,
        draw_text = false,
    },
    nil,1)
    
    --收藏
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_collection"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_collection_or_cancel",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        m_type = 2,
        cells = self._cell,
    },
    nil,1)
    
    --侦察
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_spy"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_operation_front",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        m_type = 2,
        cells = self._cell,
        operation_type = 1,
    },
    nil,1)
    
    --进攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_attack"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_operation_front",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cells = self._cell,
        operation_type = 2,
    },
    nil,1)
    
    --保护罩入口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help_infor_0_0"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_protective_cover",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --繁荣度购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help_infor_0"), nil, 
    {
        terminal_name = "player_info_boom_up_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    
    --添加好友
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_add_friend"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_friend_remove",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --私聊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_chat"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_private_chat",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_mail"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_an_email",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_open_share",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    --分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_close_share", 
        terminal_state = 0, 
    }, nil, 1)
    
    --分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share_legion_chat"), nil, 
    {
        terminal_name = "red_alert_time_mine_back_to_base_share_chats",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    
    if ccui.Helper:seekWidgetByName(root,"Text_player_attack_p")._y == nil then
        ccui.Helper:seekWidgetByName(root,"Text_player_attack_p")._y = ccui.Helper:seekWidgetByName(root,"Text_player_attack_p"):getPositionY()
    end
    ccui.Helper:seekWidgetByName(root,"Text_player_attack_p"):setPositionY(ccui.Helper:seekWidgetByName(root,"Text_player_attack_p")._y)
    
    
    self:updateDraw()
    
end

function redAlertTimeMineBaseOperationInterface:onExit()
    state_machine.remove("red_alert_time_mine_back_to_base")
    state_machine.remove("red_alert_time_mine_back_to_base_update")
    state_machine.remove("red_alert_time_mine_back_to_base_collection_or_cancel")
    state_machine.remove("red_alert_time_mine_back_to_base_attack")
    state_machine.remove("red_alert_time_mine_back_to_base_protective_cover")
    state_machine.remove("red_alert_time_mine_back_to_base_update_cover")
    state_machine.remove("red_alert_time_mine_back_to_base_operation_front")
    state_machine.remove("red_alert_time_mine_back_to_base_private_chat")
    state_machine.remove("red_alert_time_mine_back_to_base_an_email")
    state_machine.remove("red_alert_time_mine_back_to_base_friend_remove")
    state_machine.remove("red_alert_time_mine_back_to_base_open_share")
    state_machine.remove("red_alert_time_mine_back_to_base_close_share")
    state_machine.remove("red_alert_time_mine_back_to_base_share_chats")
end