-- ------------------------------------------------------------------------------------------------------------
--  说明：城市属性
-- ------------------------------------------------------------------------------------------------------------
LegionCityInforAttack = class("LegionCityInforAttackClass", Window)

--打开界面
local legion_city_infor_attack_window_open_terminal = {
    _name = "legion_city_infor_attack_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        if zstring.tonumber(_ED.world_city_auto_open_state) == 1 
            and zstring.tonumber(params[2]._city_state) == -1
            then
            TipDlg.drawTextDailog(_wait_open_tip)
            return
        end
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 then
            TipDlg.drawTextDailog(red_alert_time_str[158])
            return
        end
        local city_id = params[1]
        if zstring.tonumber(_ED.world_city_auto_open_state) == 0 then
            local open_day = dms.int(dms["world_city_mould"], city_id, world_city_mould.open_day)
            if open_day > 1 then
                local open_sec = open_day * 86400
                local time = tonumber(_ED.system_time) - tonumber(_ED.open_server_time)/1000 + (os.time()-tonumber(_ED.native_time))
                if open_sec > time then
                    local tick_time = open_sec - time
                    TipDlg.drawTextDailog(string.format(world_city_tip_str[28], exChangeTimeToString(tick_time)))
                    return
                end
            end
        end
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionCityInforAttackClass") == nil then
                    local _win = LegionCityInforAttack:new()
                    _win:init(params)
                    fwin:open(_win,fwin._ui)
                end
            end
        end

        protocol_command.world_city_detail_get.param_list = ""..city_id
        NetworkManager:register(protocol_command.world_city_detail_get.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_infor_attack_window_close_terminal = {
    _name = "legion_city_infor_attack_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityInforAttackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_infor_attack_window_open_terminal)
state_machine.add(legion_city_infor_attack_window_close_terminal)
state_machine.init()

function LegionCityInforAttack:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._mould_id = 0
    self._info = nil

    self.world_map_info = nil

    self._text_time = nil
    self._loading_bar = nil

    self._local_time = 0
    self._capture_time = 0
    self._less_percent = 0

    self._occupy_text_time = nil

    self.collection_type = 0
    self.recording_type = 0
    self.info = nil

    app.load("client.red_alert_time.legion.LegionCityInfor")
    app.load("client.red_alert_time.legion.LegionCityOccupyGarrison")
    app.load("client.red_alert_time.legion.LegionCityRuleInfor")
    app.load("client.red_alert_time.legion.LegionCityFactoryInfor")

    app.load("client.red_alert_time.cells.legion.legion_city_infor_attack_cell")

    app.load("client.red_alert_time.worldMap.redAlertTimeMineCollectionSelection")

     -- Initialize alert_home state machine.
    local function init_legion_city_infor_attack_window_terminal()
        local legion_city_infor_attack_look_info_terminal = {
            _name = "legion_city_infor_attack_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._info.city_type == 3000 then
                    state_machine.excute("legion_city_infor_window_open", 0, {instance._info.city_id, 2})
                elseif instance._info.city_type == 3001 then
                    state_machine.excute("legion_city_infor_window_open", 0, {instance._info.city_id, 3})
                else
                    state_machine.excute("legion_city_factory_infor_window_open", 0, {instance._info.city_id, 2})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_infor_attack_garrison_set_terminal = {
            _name = "legion_city_infor_attack_garrison_set",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if funOpenDrawTip(244) == true then
                    return
                end 
                if tonumber(_ED.union.user_union_info.union_post) >= 3 then       -- 普通成员，没有权限
                    TipDlg.drawTextDailog(tipString_legion_info[13])
                    return
                end
                state_machine.excute("legion_city_occupy_garrison_open", 0, {instance._info.city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_infor_attack_update_draw_terminal = {
            _name = "legion_city_infor_attack_update_draw",
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

        local legion_city_infor_attack_go_attack_terminal = {
            _name = "legion_city_infor_attack_go_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if funOpenDrawTip(244) == true then
                    return
                end 
                local form_type = params._datas.form_type
                local attack_cell = params._datas.attack_cell


                local open_state = 0
                if instance._city_type == 3000 or instance._city_type == 3001 then
                    if _ED.mould_function_push_info["14"] ~= nil then
                        open_state = tonumber(_ED.mould_function_push_info["14"].state)
                    end
                    if open_state == 1 then
                        TipDlg.drawTextDailog(world_city_tip_str[30])
                        return
                    end
                    if open_state == 0 and instance._city_type == 3001 then
                        TipDlg.drawTextDailog(world_city_tip_str[29])
                        return
                    end
                    if open_state == 0 and instance._city_type == 3000 and tonumber(instance._info.union_id) <= 0 then
                        TipDlg.drawTextDailog(world_city_tip_str[32])
                        return
                    end
                else
                    if _ED.mould_function_push_info["16"] ~= nil then
                        open_state = tonumber(_ED.mould_function_push_info["16"].state)
                    end
                    if open_state > 0 then
                        TipDlg.drawTextDailog(world_city_tip_str[62])
                        return
                    end
                end
                if instance._city_type == 3002 then
                    form_type = form_type + 3
                end
                state_machine.excute("formation_window_open", 0, {_datas = {form_type = form_type, attack_cell = attack_cell}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_infor_attack_look_rule_terminal = {
            _name = "legion_city_infor_attack_look_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._info.city_type == 3002 then
                    state_machine.excute("legion_city_rule_infor_window_open", 0, {_datas = {infor_type = 6}})
                else
                    state_machine.excute("legion_city_rule_infor_window_open", 0, {_datas = {infor_type = 3}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --分享打开
        local legion_city_infor_attack_share_open_terminal = {
            _name = "legion_city_infor_attack_share_open",
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
        
        --分享关闭
        local legion_city_infor_attack_share_close_terminal = {
            _name = "legion_city_infor_attack_share_close",
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
        local legion_city_infor_attack_share_chats_terminal = {
            _name = "legion_city_infor_attack_share_chats",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(params._datas.chat_type) == 14 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("legion_city_infor_attack_share_close", 0, 0)         
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("legion_city_infor_attack_share_close", 0, 0) 
                    return
                end 

                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("legion_city_infor_attack_share_close", 0, 0)
                            TipDlg.drawTextDailog(game_share_tip_text[1])
                        end 
                    end
                end

                local paramsInfo = "9-1-"..instance.info._mould_id
                local str = chat_section[1]..dms.string(dms["message_share"], 1, message_share.jump_type).."|"..instance.info._x..","..instance.info._y
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n3\r\n"..paramsInfo
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --收藏
        local legion_city_infor_attack_collection_terminal = {
            _name = "legion_city_infor_attack_collection",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.collection_type == 0 then
                    local function requesrDeletecoordinate(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                TipDlg.drawTextDailog(friends_tip_string[11])
                                _ED.world_map.coord_collent[""..response.node.recording_type][response.node.info._type.."," .. response.node.info._id] = nil
                                state_machine.excute("legion_city_infor_attack_update_draw", 0, 0)
                            end
                        end
                    end
                    local city_data = dms.element(dms["world_city_mould"], self.info._mould_id)
                    local name = dms.atos(city_data, world_city_mould.name)
                    local level = dms.atoi(city_data, world_city_mould.level)
                    protocol_command.world_coord_collect.param_list = "0" .. "\r\n" .. "" .. instance.recording_type .. "-" ..instance.info._type .. "," .. instance.info._id .."\r\n"..name.."|"..level.."|"..instance.info._x..","..instance.info._y
                    NetworkManager:register(protocol_command.world_coord_collect.code, nil, nil, nil, instance, requesrDeletecoordinate, false, nil)
                else
                    state_machine.excute("red_alert_time_mine_collection_selection_open", 0, {_datas={m_type = 1, cells = instance}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --收藏刷新
        local legion_city_infor_attack_collection_update_terminal = {
            _name = "legion_city_infor_attack_collection_update",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateCollectionState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_infor_attack_look_info_terminal)
        state_machine.add(legion_city_infor_attack_garrison_set_terminal)
        state_machine.add(legion_city_infor_attack_update_draw_terminal)
        state_machine.add(legion_city_infor_attack_go_attack_terminal)
        state_machine.add(legion_city_infor_attack_look_rule_terminal)
        state_machine.add(legion_city_infor_attack_share_open_terminal)
        state_machine.add(legion_city_infor_attack_share_close_terminal)
        state_machine.add(legion_city_infor_attack_share_chats_terminal)
        state_machine.add(legion_city_infor_attack_collection_terminal)
        state_machine.add(legion_city_infor_attack_collection_update_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_city_infor_attack_window_terminal()
end

-- 显示信息
function LegionCityInforAttack:onUpdateDraw()
    local root = self.roots[1]
    local Text_legion_city_infor_title = ccui.Helper:seekWidgetByName(root, "Text_legion_city_infor_title")
    local Text_legion_city_infor_title_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_city_infor_title_0")
    local Text_legion_city_infor_title_0_0_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_city_infor_title_0_0_0")
    local Panel_legion_city_infor_city = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_infor_city")

    self._info = _ED.world_city_info.detail_info[""..self._mould_id]

    local city_data = dms.element(dms["world_city_mould"], self._info.city_id)
    local name = dms.atos(city_data, world_city_mould.name)
    local level = dms.atoi(city_data, world_city_mould.level)
    local pic = dms.atoi(city_data, world_city_mould.pic)

    -- 城市图标
    Panel_legion_city_infor_city:removeBackGroundImage()
    Panel_legion_city_infor_city:setBackGroundImage(string.format(config_res.images.ui.legion.legion_city_icon, pic))

    -- 城市名称
    Text_legion_city_infor_title:setString(name)

    -- 城市等级
    Text_legion_city_infor_title_0:setString(friends_tip_string[12]..level)

    -- 占领军团
    if tonumber(self._info.progress_union_id) > 0 then
        Text_legion_city_infor_title_0_0_0:setString(self._info.progress_union_name)
    elseif tonumber(self._info.union_id) > 0 then
        Text_legion_city_infor_title_0_0_0:setString(self._info.union_name)
    else
        Text_legion_city_infor_title_0_0_0:setString(tipStringInfo_rank_str[6])
    end

    -- 城市状态
    local is_open = false
    if self._info.city_type == 3002 then
        if _ED.mould_function_push_info["16"] ~= nil then
            if tonumber(_ED.mould_function_push_info["16"].state) == 0 then
                is_open = true
            end
        end
    else
        if _ED.mould_function_push_info["14"] ~= nil then
            if tonumber(_ED.mould_function_push_info["14"].state) == 2 then
                is_open = true
            end
        end
    end

    self._city_state = 0
    if tonumber(self._info.state) == -1 then
        self._city_state = -1
    else
        if is_open == true then
            if (tonumber(self._info.state) == 2 and self._info.union_id > 0 and self._info.union_id == self._info.progress_union_id and tonumber(self._info.progress) == 0) then
                self._city_state = 2
            elseif self._info.union_id > 0 then
                self._city_state = 1
            else
                self._city_state = 0
            end
        end
    end
    
    self:onUpdateShieldState()
    self:onUpdateOccupyState()
    self:onUpdateCityInfo()
    self:onUpdateButtonState()

    self:onUpdateDefenceInfo()
    self:onUpdateCollectionState()
end

function LegionCityInforAttack:onUpdateShieldState()
    local root = self.roots[1]
    local Panel_legion_city_infor_city = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_infor_city")
    local Text_legion_city_occupation = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupation")
    Panel_legion_city_infor_city:removeAllChildren(true)
    Text_legion_city_occupation:setVisible(true)
    Text_legion_city_occupation:setString("")
    Text_legion_city_occupation:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))

    self._occupy_text_time = nil
    local is_open_shield = false
    if self._city_type == 3000 or self._city_type == 3001 then
        local leave_time = self._info.capture_start_time + self._info.capture_cd_time - (os.time() + _ED.time_add_or_sub)
        if leave_time > 0 then
            is_open_shield = true

            Text_legion_city_occupation:setString(world_city_tip_str[71]..exChangeNumToString(leave_time))
            Text_legion_city_occupation:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
            self._occupy_text_time = Text_legion_city_occupation
        else
            Text_legion_city_occupation:setString(world_city_tip_str[72])
        end
    end

    if is_open_shield == true then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_shield/effect_shield.ExportJson")
        local armature = ccs.Armature:create("effect_shield")
        armature:getAnimation():playWithIndex(0)
        armature:setAnchorPoint(cc.p(0.5,0.5))
        armature:setPosition(cc.p(Panel_legion_city_infor_city:getContentSize().width/2,Panel_legion_city_infor_city:getContentSize().height/2))
        Panel_legion_city_infor_city:addChild(armature)
    end 
end 

function LegionCityInforAttack:onUpdateCollectionState()
    local root = self.roots[1]
    -- 收藏
    local position = dms.string(dms["world_city_mould"], self._info.city_id, world_city_mould.position)
    self.info = _ED.world_map.world_map_info_list[position]

    local Button_legion_city_collection = ccui.Helper:seekWidgetByName(root,"Button_legion_city_collection")
    self.collection_type = 1
    for i=1,3 do
        if _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..i]~= nil then
            for j, v in pairs(_ED.world_map.coord_collent[""..i]) do
                local m_info = zstring.split(j, ",")
                if zstring.tonumber(m_info[2]) == zstring.tonumber(self.info._id) then
                    self.collection_type = 0
                    self.recording_type = i
                    break
                end
            end
        end
    end
    if self.collection_type == 0 then
        Button_legion_city_collection:setHighlighted(true)
    else
        Button_legion_city_collection:setHighlighted(false)
    end
end

-- 占领进度状态
function LegionCityInforAttack:onUpdateOccupyState()
    local root = self.roots[1]
    local Panel_legion_city_boom = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_boom")
    Panel_legion_city_boom:setVisible(false)
    
    self._text_time = nil
    self._loading_bar = nil
    self._local_time = 0

    if self._city_state ~= 1 then
        return
    end

    Panel_legion_city_boom:setVisible(true)
    local Text_legion_city_occupy_boom_t = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_boom_t")
    local LoadingBar_city_occupy_boom = ccui.Helper:seekWidgetByName(root, "LoadingBar_city_occupy_boom")
    local Text_city_occupy_boom_n = ccui.Helper:seekWidgetByName(root, "Text_city_occupy_boom_n")

    Text_legion_city_occupy_boom_t:setString(world_city_tip_str[19])

    local capture_time = dms.int(dms["world_city_mould"], self._info.city_id, world_city_mould.capture_time)
    local less_percent = dms.float(dms["world_city_config"], 7, world_city_config.param)
    self._capture_time = capture_time
    self._less_percent = less_percent

    local local_time = tonumber(self._info.progress)
    local add_time = (os.time() - self._info.progress_start_time)
    local current_time = local_time
    local percent = 0
    if self._info.union_name == self._info.progress_union_name then
        current_time = current_time - add_time * self._info.add_time_speed
        percent = (self._capture_time - current_time) * 100 / self._capture_time
    else
        current_time = current_time - add_time / self._less_percent
        percent = current_time * 100 / self._capture_time
        current_time = self._capture_time - current_time
    end

    if percent >= 100 then
        percent = 100
    elseif percent <= 0 then
        percent = 0
    end
    if current_time >= self._capture_time then
        current_time = self._capture_time
    elseif current_time <= 0 then
        current_time = 0 
    end

    LoadingBar_city_occupy_boom:setPercent(percent)
    if tonumber(percent) == 100 then
        Text_city_occupy_boom_n:setString(world_city_tip_str[20])
        LoadingBar_city_occupy_boom:setPercent(100)
    else
        Text_city_occupy_boom_n:setString(exChangeTimeToString(current_time))

        if tonumber(self._info.progress_tick_time) > 0 then
            self._text_time = Text_city_occupy_boom_n
            self._loading_bar = LoadingBar_city_occupy_boom
            self._local_time = local_time
        end
    end
end

-- 城市信息
function LegionCityInforAttack:onUpdateCityInfo()
    local root = self.roots[1]
    local Panel_legion_city_res = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_res")
    local Panel_legion_city_un_occupy = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_un_occupy")
    local Panel_legion_city_factory = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_factory")

    Panel_legion_city_res:setVisible(false)
    Panel_legion_city_un_occupy:setVisible(false)
    Panel_legion_city_factory:setVisible(false)

    self._factory_text_time = nil
    self._factory_loading_bar = nil
    self._factory_max_level = 0
    self._factory_max_time = 0

    if self._city_type == 3000 and self._city_state ~= 1 then
        Panel_legion_city_res:setVisible(true)
        local resource_info = dms.string(dms["world_city_mould"], self._info.city_id, world_city_mould.resource_info)
        -- 资源产量
        local res_info = zstring.split(resource_info, "|")
        for i = 1, 5 do
            local Text_legion_city_occupy_res_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_res_n_"..i)
            local Image_legion_city_occupy_icon = ccui.Helper:seekWidgetByName(root, "Image_legion_city_occupy_icon_"..i)
            local Text_legion_city_occupy_res = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_res_"..i)
            local out_put = 0
            local info = zstring.split(res_info[i], ",")
            out_put = zstring.tonumber(info[2]) * 3600
            Text_legion_city_occupy_res_n:setString(exChangeNumToString(out_put)..world_city_tip_str[3])
            Text_legion_city_occupy_res:setString(reward_prop_list[tonumber(info[1])]..":")
            local pic_index = 1
            for k, v in pairs(tank_from_prop_used_ids) do
                if v == tonumber(tonumber(info[1])) then
                    pic_index = k
                    break
                end
            end
            Image_legion_city_occupy_icon:loadTexture(config_res.images.ui.home._ui_res_type_small_icon[pic_index], 1)
        end
    elseif self._city_type == 3001 then
        Panel_legion_city_un_occupy:setVisible(true)
        -- 加成buff
        local buff_info = zstring.split(dms.string(dms["world_city_mould"], self._info.city_id, world_city_mould.buff_info), "|")
        local Text_legion_city_un_occupy_add = ccui.Helper:seekWidgetByName(root, "Text_legion_city_un_occupy_add")
        local Text_legion_city_un_occupy_add_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_un_occupy_add_n")
        local buff_1 = zstring.split(buff_info[1], ",")

        Text_legion_city_un_occupy_add_n:setString("+"..buff_1[2].."%")
    elseif self._city_type == 3002 and self._city_state ~= 1 then
        Panel_legion_city_factory:setVisible(true)
        -- 占领状态
        local LoadingBar_legion_city_factory_lv = ccui.Helper:seekWidgetByName(root, "LoadingBar_legion_city_factory_lv")
        local Text_legion_city_factory_lv_time_t = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_lv_time_t")
        local Text_legion_city_factory_lv_time_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_lv_time_n")
        local Panel_legion_city_factory_lv = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_factory_lv")
        for i = 1, 5 do
            local Text_legion_city_factory_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_lv_"..i)
            Text_legion_city_factory_lv:setString(friends_tip_string[12]..i)
        end

        -- 工厂等级
        local level = tonumber(self._info.factory_level)
        Panel_legion_city_factory_lv:removeBackGroundImage()
        Panel_legion_city_factory_lv:setBackGroundImage(string.format(config_res.images.ui.legion.legion_city_forcaty, level))

        LoadingBar_legion_city_factory_lv:loadTexture(string.format(config_res.images.ui.legion.legion_city_factory_pass, level))
        self._factory_max_time = dms.int(dms["world_city_config"], 28, world_city_config.param)      -- 升级需要时间
        self._factory_max_level = 5             -- 最大等级

        local current_time = 0
        if level < self._factory_max_level and self._city_state == 2 then
            current_time = os.time() + _ED.time_add_or_sub - self._info.factory_start_time
            current_time = math.min(current_time, self._factory_max_time)

            self._factory_text_time = Text_legion_city_factory_lv_time_n
            self._factory_loading_bar = LoadingBar_legion_city_factory_lv
        end
        local leave_time = self._factory_max_time - current_time
        local percent = (current_time * 100 / self._factory_max_time + (level - 1) * 100) / (self._factory_max_level - 1)
        LoadingBar_legion_city_factory_lv:setPercent(percent)

        if level < self._factory_max_level then
            Text_legion_city_factory_lv_time_t:setString(world_city_tip_str[53])
            Text_legion_city_factory_lv_time_n:setString(exChangeTimeToString(leave_time))
        else
            Text_legion_city_factory_lv_time_t:setString(world_city_tip_str[54])
            Text_legion_city_factory_lv_time_n:setString(tipStringInfo_union_str[70])
        end
    end
end

-- 按钮状态
function LegionCityInforAttack:onUpdateButtonState()
    local root = self.roots[1]
    local Button_legion_occupy_attack = ccui.Helper:seekWidgetByName(root, "Button_legion_occupy_attack")
    local Button_legion_occupy_garrison = ccui.Helper:seekWidgetByName(root, "Button_legion_occupy_garrison")
    local Button_legion_occupy_garrison_set = ccui.Helper:seekWidgetByName(root, "Button_legion_occupy_garrison_set")
    local Button_legion_city_occupy_infor = ccui.Helper:seekWidgetByName(root, "Button_legion_city_occupy_infor")
    Button_legion_city_occupy_infor:setVisible(false)

    local is_attack = false
    local have_defence = true
    for k, v in pairs(self._info.defencer_list) do
        if tonumber(v.nType) < 0 then
            have_defence = false
            break
        end
    end

    if have_defence == false or tonumber(self._info.union_id) ~= tonumber(_ED.union.union_info.union_id) then
        is_attack = true
    else
        is_attack = false
    end

    if is_attack == true then
        Button_legion_occupy_attack:setVisible(true)
        Button_legion_occupy_garrison:setVisible(false)
        Button_legion_occupy_garrison_set:setVisible(false)
    else
        Button_legion_occupy_attack:setVisible(false)
        Button_legion_occupy_garrison:setVisible(true)
        Button_legion_occupy_garrison_set:setVisible(true)
    end

    if self._info.city_type == 3002 then
        Button_legion_occupy_garrison_set:setVisible(false)
        Button_legion_city_occupy_infor:setVisible(true)
    end
end

-- 刷新守军信息
function LegionCityInforAttack:onUpdateDefenceInfo()
    local root = self.roots[1]

    local ScrollView_legion_city_defend = ccui.Helper:seekWidgetByName(root, "ScrollView_legion_city_defend")
    ScrollView_legion_city_defend:removeAllChildren(true)

    local scroll_size = ScrollView_legion_city_defend:getContentSize()
    local cell_size = nil

    local result = self._info.defencer_list
    local items = {}
    for k, v in pairs(result) do
        local cell = state_machine.excute("legion_city_infor_attack_cell_create", 0, {k, v})
        ScrollView_legion_city_defend:addChild(cell)
        table.insert(items, cell)

        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end

    local count = #items
    local height = 0
    if cell_size ~= nil then
        height = math.ceil(count / 2) * cell_size.height
    end
    if height > scroll_size.height then
        ScrollView_legion_city_defend:getInnerContainer():setContentSize(cc.size(scroll_size.width, height))
    else
        height = scroll_size.height
    end

    for k, v in pairs(items) do
        local row = math.floor((k - 1) % 2)
        local col = math.ceil(k / 2)
        local posX = scroll_size.width * row / 2
        local posY = height - col * cell_size.height
        v:setPosition(cc.p(posX, posY))
    end

    ScrollView_legion_city_defend:jumpToTop()
end

function LegionCityInforAttack:onUpdate()
    local open_state = 0
    if self._info.city_type == 3000 or self._info.city_type == 3001 then
        if _ED.mould_function_push_info["14"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["14"].state)
        end
    else
        if _ED.mould_function_push_info["16"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["16"].state)
        end
    end

    if ((self._info.city_type == 3000 or self._info.city_type == 3001) and open_state == 2)
        or (self._info.city_type == 3002 and open_state == 0)
        then
        if self._text_time ~= nil then
            local current_time = 0
            if self._info.progress_tick_time ~= 0 then
                local add_time = (os.time() - self._info.progress_start_time)
                local current_time = self._local_time
                local percent = 0
                if self._info.union_name == self._info.progress_union_name then
                    current_time = current_time - add_time * self._info.add_time_speed
                    percent = (self._capture_time - current_time) * 100 / self._capture_time
                else
                    current_time = current_time - add_time / self._less_percent
                    percent = current_time * 100 / self._capture_time
                    current_time = self._capture_time - current_time
                end
                if percent >= 100 then
                    percent = 100
                elseif percent <= 0 then
                    percent = 0
                end
                if current_time >= self._capture_time then
                    current_time = self._capture_time
                elseif current_time <= 0 then
                    current_time = 0 
                end
                self._loading_bar:setPercent(percent)
                if percent < 100 then
                    self._text_time:setString(exChangeTimeToString(current_time))
                else
                    self._text_time:setString(world_city_tip_str[20])
                end 
            end
        end
    end

    if self._info.city_type == 3002 and self._factory_text_time ~= nil then
        local current_time = os.time() + _ED.time_add_or_sub - self._info.factory_start_time
        local leave_time = self._factory_max_time - current_time
        local percent = (current_time * 100 / self._factory_max_time + (self._info.factory_level - 1) * 100) / (self._factory_max_level - 1)
        self._factory_loading_bar:setPercent(percent)
        self._factory_text_time:setString(exChangeTimeToString(leave_time))

        -- if leave_time < 0 then
        --     self:onUpdateDraw()
        -- end
    end

    if self._info.city_type == 3000 or self._info.city_type == 3001 then
        if self._occupy_text_time ~= nil then
            local leave_time = self._info.capture_start_time + self._info.capture_cd_time - (os.time() + _ED.time_add_or_sub)
            self._occupy_text_time:setString(world_city_tip_str[71]..exChangeTimeToString(leave_time))
            if leave_time <= 0 then
                self:onUpdateDraw()
            end
        end
    end
end

--初始化界面
function LegionCityInforAttack:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_infor_attack)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self._info = _ED.world_city_info.detail_info[""..self._mould_id]
    self._city_type = self._info.city_type

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leigon_city_infor_colse"), nil, 
    {
        terminal_name = "legion_city_infor_attack_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_infor_attack_window_close", 
        terminal_state = 0, 
    }, nil, 3)   

    -- 据点信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_occupy_infor"), nil, 
    {
        terminal_name = "legion_city_infor_attack_look_info",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- 进攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_occupy_attack"), nil, 
    {
        terminal_name = "legion_city_infor_attack_go_attack",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        form_type = 16,
        attack_cell = self.world_map_info,
    },
    nil,1)

    -- 帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_infor"), nil, 
    {
        terminal_name = "legion_city_infor_attack_look_rule",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- 驻防
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_occupy_garrison"), nil, 
    {
        terminal_name = "legion_city_infor_attack_go_attack",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        form_type = 17,
        attack_cell = self.world_map_info,
    },
    nil,1)

    -- 驻防设置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_occupy_garrison_set"), nil, 
    {
        terminal_name = "legion_city_infor_attack_garrison_set",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- 收藏
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_collection"), nil, 
    {
        terminal_name = "legion_city_infor_attack_collection",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- 分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_share"), nil, 
    {
        terminal_name = "legion_city_infor_attack_share_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1) 
    
    local Panel_share_close = ccui.Helper:seekWidgetByName(root,"Panel_share_close")
    if Panel_share_close ~= nil then
        Panel_share_close:setSwallowTouches(false)
    end
    -- 分享关闭
    fwin:addTouchEventListener(Panel_share_close, nil, 
    {
        terminal_name = "legion_city_infor_attack_share_close", 
        terminal_state = 0, 
    }, nil, 1)  
    
    -- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "legion_city_infor_attack_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "legion_city_infor_attack_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1) 

    self:onUpdateDraw()
end

--初始化
function LegionCityInforAttack:init(params)
    self._mould_id = params[1]
    self.world_map_info = params[2]
    self:onInit()
end

--移除状态机
function LegionCityInforAttack:onExit()
    state_machine.remove("legion_city_infor_attack_look_info")
    state_machine.remove("legion_city_infor_attack_garrison_set")
    state_machine.remove("legion_city_infor_attack_update_draw")
    state_machine.remove("legion_city_infor_attack_go_attack")
    state_machine.remove("legion_city_infor_attack_look_rule")
    state_machine.remove("legion_city_infor_attack_share_open")
    state_machine.remove("legion_city_infor_attack_share_close")
    state_machine.remove("legion_city_infor_attack_share_chats")
    state_machine.remove("legion_city_infor_attack_collection")
    state_machine.remove("legion_city_infor_attack_collection_update")
end