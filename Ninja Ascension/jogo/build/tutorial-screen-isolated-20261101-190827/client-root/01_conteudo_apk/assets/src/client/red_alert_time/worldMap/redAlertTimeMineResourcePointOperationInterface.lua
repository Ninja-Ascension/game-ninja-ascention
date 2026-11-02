-- ----------------------------------------------------------------------------------------------------
-- 说明：世界矿点操作
-------------------------------------------------------------------------------------------------------
redAlertTimeMineResourcePointOperationInterface = class("redAlertTimeMineResourcePointOperationInterfaceClass", Window)

local red_alert_time_mine_resource_point_operation_interface_open_terminal = {
    _name = "red_alert_time_mine_resource_point_operation_interface_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("redAlertTimeMineResourcePointOperationInterfaceClass")
        if nil == _homeWindow then
            fwin:open(redAlertTimeMineResourcePointOperationInterface:new():init(params._datas.cell), fwin._dview)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_resource_point_operation_interface_close_terminal = {
    _name = "red_alert_time_mine_resource_point_operation_interface_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("redAlertTimeMineResourcePointOperationInterfaceClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("redAlertTimeMineResourcePointOperationInterfaceClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_resource_point_operation_interface_open_terminal)
state_machine.add(red_alert_time_mine_resource_point_operation_interface_close_terminal)
state_machine.init()
    
function redAlertTimeMineResourcePointOperationInterface:ctor()
    self.super:ctor()
    self.roots = {}
    self._cell = nil
    self.mine_y = 0
    self.mine_x = 0

    self._text_time = nil
    self._leave_time = 0
    
    self._activity_type = 0
    app.load("client.red_alert_time.worldMap.redAlertTimeMinehelpInfo")
    app.load("client.red_alert_time.worldMap.redAlertTimeMineCollectionSelection")
    app.load("client.red_alert_time.worldMap.redAlertTimeMineReconnaissance")

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    
    local function init_red_alert_time_mine_resource_point_operation_interface_terminal()
        -- 刷新界面
        local red_alert_time_mine_resource_point_operation_interface_update_terminal = {
            _name = "red_alert_time_mine_resource_point_operation_interface_update",
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
        
        --收藏和取消收藏的操作
        local red_alert_time_mine_resource_point_operation_collection_or_cancel_terminal = {
            _name = "red_alert_time_mine_resource_point_operation_collection_or_cancel",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._cell.collection_type == 0 then
                    local function requesrDeletecoordinate(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                TipDlg.drawTextDailog(friends_tip_string[11])
								_ED.world_map.coord_collent[""..response.node._cell.recording_type][response.node._cell.info._type.."," .. response.node._cell.info._id] = nil
                                state_machine.excute("red_alert_time_mine_resource_point_operation_interface_update", 0, 0)
                            end
                        end
                    end
                    local element = dms.element(dms["world_mine_mould"], instance._cell.info._mould_id)
                    local mine_name = dms.atos(element, world_mine_mould.name)
                    local mine_level = dms.atos(element, world_mine_mould.level)
                    protocol_command.world_coord_collect.param_list = "0" .. "\r\n" .. "" .. instance._cell.recording_type .. "-" ..instance._cell.info._type .. "," .. instance._cell.info._id .."\r\n"..mine_name.."|"..mine_level.."|"..instance._cell.info._x..","..instance._cell.info._y
					NetworkManager:register(protocol_command.world_coord_collect.code, nil, nil, nil, instance, requesrDeletecoordinate, false, nil)
                else
                    state_machine.excute("red_alert_time_mine_collection_selection_open", 0, {_datas={m_type = 1, cells = instance._cell}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 进攻
        local red_alert_time_mine_resource_point_operation_interface_attack_terminal = {
            _name = "red_alert_time_mine_resource_point_operation_interface_attack",
            _init = function (terminal)
                app.load("client.red_alert_time.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local show_tip = false
                if __lua_project_id == __lua_project_red_alert_time then
                    local level = dms.int(dms["world_config"], 23, world_config.param)
                    if tonumber(_ED.user_info.user_grade) < level then
                        local mine_level = dms.int(dms["world_mine_mould"], instance._cell.info._mould_id, world_mine_mould.level)
                        local level_info = zstring.split(dms.string(dms["world_config"], 24, world_config.param), "|")
                        for k, v in pairs(level_info) do
                            local info = zstring.split(v, ",")
                            if tonumber(_ED.user_info.user_grade) >= tonumber(info[1]) and tonumber(_ED.user_info.user_grade) <= tonumber(info[2]) then
                                if mine_level > tonumber(info[3]) then
                                    show_tip = true
                                end
                                break
                            end
                        end
                    end
                end

                local function sureFight(ins, sure_number)
                    if sure_number == 0 then
                        if __lua_project_id == __lua_project_pacific_rim then
                            state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance._cell.info ,playersOrmine = 0,
                                next_terminal = "formation_defend_add_investigate_formation_info", next_terminal_params = {instance._cell, false}}})
                        else
                            state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance._cell.info ,playersOrmine = 0}})
                        end
                        state_machine.excute("red_alert_time_mine_resource_point_operation_interface_close",0,0)
                    end
                end
                if show_tip == true then
                    local tip = ConfirmTip:new()
                    tip:init(instance, sureFight, red_alert_time_str[303])
                    fwin:open(tip,fwin._windows) 
                    local Button_3_6 = ccui.Helper:seekWidgetByName(tip.roots[1], "Button_3_6")
                    if Button_3_6 ~= nil then
                        Button_3_6:setTitleText(red_alert_time_str[304])
                    end
                    local Button_4_8 = ccui.Helper:seekWidgetByName(tip.roots[1], "Button_4_8")
                    if Button_4_8 ~= nil then
                        Button_4_8:setTitleText(mail_tip_text[60])
                    end
                else
                    sureFight(instance, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 打开分享
        local red_alert_time_mine_resource_point_operation_interface_open_share_terminal = {
            _name = "red_alert_time_mine_resource_point_operation_interface_open_share",
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
        
        -- 关闭分享
        local red_alert_time_mine_resource_point_operation_interface_close_share_terminal = {
            _name = "red_alert_time_mine_resource_point_operation_interface_close_share",
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
        
        -- 分享到军团
        local red_alert_time_mine_resource_point_operation_interface_share_world_terminal = {
            _name = "red_alert_time_mine_resource_point_operation_interface_share_world",
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
                    state_machine.excute("red_alert_time_mine_resource_point_operation_interface_close_share", 0, 0)            
                    TipDlg.drawTextDailog(game_share_tip_text[2])
                    return
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("red_alert_time_mine_resource_point_operation_interface_close_share", 0, 0) 
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("red_alert_time_mine_resource_point_operation_interface_close_share", 0, 0)
                            TipDlg.drawTextDailog(game_share_tip_text[1])
                        end 
                    end
                end

                local element = dms.element(dms["world_mine_mould"], instance._cell.info._mould_id)
                local mine_quelity_level_up_param = dms.atos(element, world_mine_mould.quelity_level_up_param)
                local per_minute_sub_exp = dms.atoi(element, world_mine_mould.per_minute_sub_quelity_level_up_exp)
                local richOreValue = zstring.split(mine_quelity_level_up_param ,",")
                local quality_id = tonumber(instance._cell.info._quality)
                local quality_level_up_exp = instance._cell.info._quality_level_up_exp
                if tonumber(instance._cell.info._userId) == -1 then
                    local m_times = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(instance._cell.info._mining_time)/1000
                    if m_times > 0 then
                        quality_level_up_exp = instance._cell.info._quality_level_up_exp - math.floor(math.floor(m_times/60)*per_minute_sub_exp)
                        if quality_level_up_exp <= 0 then
                            quality_level_up_exp = 0
                        end
                    end
                    local isVariety = false
                    for i=1, #richOreValue do
                        if quality_level_up_exp >= tonumber(richOreValue[i]) then
                            quality_id = i
                            isVariety = true
                        end
                    end
                    if quality_id>=3 then
                        quality_id=3
                    end
                    if isVariety == false then
                        quality_id = 0
                    end
                end
                
                local datas = dms.string(dms["message_share"], 1, message_share.content)
                local mine_info = dms.atos(element, world_mine_mould.name).."["..instance.mine_x..","..instance.mine_y.."]"
                mine_info = "|"..quality_id.."|"..mine_info
                local data1 =  string.gsub(datas, "!x@", mine_info)
                datas = data1
                -- local paramsInfo = mine_info
                local paramsInfo = "8-1-"..instance._cell.info._mould_id.."-"..quality_id.."-"..instance.mine_x.."-"..instance.mine_y..","..mine_info
                local str = chat_section[1]..dms.string(dms["message_share"], 1, message_share.jump_type).."|"..instance.mine_x..","..instance.mine_y
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n14\r\n0\r\n1\r\n" .. zstring.exchangeTo(paramsInfo)
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=instance, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 全名狂欢活动规则
        local red_alert_time_mine_resource_point_operation_interface_activity_rule_terminal = {
            _name = "red_alert_time_mine_resource_point_operation_interface_activity_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 侦查
        local red_alert_time_mine_resource_point_operation_interface_investigate_terminal = {
            _name = "red_alert_time_mine_resource_point_operation_interface_investigate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                if instance._leave_time > 0 then
                    state_machine.excute("red_alert_time_mine_reconnaissance_investigate", 0, {cells, 0})
                else
                    state_machine.excute("red_alert_time_mine_reconnaissance_open",0,{_datas = {cells = cells ,m_type = 1}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_mine_resource_point_operation_interface_update_terminal)
        state_machine.add(red_alert_time_mine_resource_point_operation_collection_or_cancel_terminal)
        state_machine.add(red_alert_time_mine_resource_point_operation_interface_attack_terminal)
        state_machine.add(red_alert_time_mine_resource_point_operation_interface_open_share_terminal)
        state_machine.add(red_alert_time_mine_resource_point_operation_interface_close_share_terminal)
        state_machine.add(red_alert_time_mine_resource_point_operation_interface_share_world_terminal)
        state_machine.add(red_alert_time_mine_resource_point_operation_interface_activity_rule_terminal)
        state_machine.add(red_alert_time_mine_resource_point_operation_interface_investigate_terminal)
    
        state_machine.init()
    end
    
    init_red_alert_time_mine_resource_point_operation_interface_terminal()
    
end

function redAlertTimeMineResourcePointOperationInterface:init(cell)
    self._cell = cell
    self:onInit()
    return self
end

function redAlertTimeMineResourcePointOperationInterface:updateColllectionState()
    local root = self.roots[1]
    local Button_res_collection = ccui.Helper:seekWidgetByName(root,"Button_res_collection")
    Button_res_collection:setTitleText(tipStringInfo_consumption_info[21]) 
    self._cell.collection_type = 1
    for i=1,3 do
        if _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..i]~= nil then
            for j, v in pairs(_ED.world_map.coord_collent[""..i]) do
                local m_info = zstring.split(j, ",")
                if zstring.tonumber(m_info[2]) == zstring.tonumber(self._cell.info._id) then
                    ccui.Helper:seekWidgetByName(self.roots[1],"Button_res_collection"):setTitleText(tipStringInfo_consumption_info[22]) 
                    self._cell.collection_type = 0
                    self._cell.recording_type = i
                    return
                end
            end
        end
    end
end

function redAlertTimeMineResourcePointOperationInterface:onUpdateDraw()
    local root = self.roots[1]
    self:updateColllectionState()

    local Button_world_map_res_act = ccui.Helper:seekWidgetByName(root,"Button_world_map_res_act")
    Button_world_map_res_act:setVisible(false)
    self._activity_type = 0
    -- 全名狂欢活动标志
    if _ED.activity_info ~= nil and _ED.activity_info["84"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["84"].activity_add_state, ",")
        local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if leave_times > 0 then
            Button_world_map_res_act:setVisible(true)
            self._activity_type = 84
        end
    end

    -- 狂欢时刻活动标志
    if _ED.activity_info ~= nil and _ED.activity_info["130"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["130"].activity_add_state, ",")
        local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if leave_times > 0 then
            Button_world_map_res_act:setVisible(true)
            self._activity_type = 130
        end
    end

    -- 火力驱动活动标志
    if _ED.activity_info ~= nil and _ED.activity_info["117"] ~= nil then
        local other_info = zstring.split(_ED.activity_info["117"].activity_add_state, "!")
        local timesData = zstring.split(other_info[1], ",")
        local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if leave_times > 0 then
            local start_time = tonumber(timesData[1]/1000)
            local current_time = os.time() + _ED.time_add_or_sub
            local open_info = zstring.split(other_info[2], "|")
            open_info = zstring.split(open_info[2], ",")        -- 世界行军加速
            if (current_time - start_time) > (tonumber(open_info[1])) * 3600 then
                Button_world_map_res_act:setVisible(true)
                self._activity_type = 117
            end
        end
    end

    self:updateInvestigateInfo()
end

function redAlertTimeMineResourcePointOperationInterface:updateInvestigateInfo()
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

function redAlertTimeMineResourcePointOperationInterface:onUpdate(dt)
    if self._text_time ~= nil and self._leave_time > 0 then
        self._leave_time = self._leave_time - dt
        self._text_time:setString(exChangeTimeToString(self._leave_time))
        if self._leave_time <= 0 then
            self._text_time = nil
            self:updateInvestigateInfo()
        end
    end
end

function redAlertTimeMineResourcePointOperationInterface:onInit()
    local csbredAlertTimeMineResourcePointOperationInterface = csb.createNode(config_csb.resource_point_operation_interface)
    local root = csbredAlertTimeMineResourcePointOperationInterface:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineResourcePointOperationInterface)
    local element = dms.element(dms["world_mine_mould"], self._cell.info._mould_id)

    --资源点名称
    local Text_res_icon_name_lv = ccui.Helper:seekWidgetByName(root,"Text_res_icon_name_lv")
    local mine_name = dms.atos(element, world_mine_mould.name)
    local mine_quelity_level_up_param = dms.atos(element, world_mine_mould.quelity_level_up_param)
    local per_minute_sub_exp = dms.atoi(element, world_mine_mould.per_minute_sub_quelity_level_up_exp)
    local richOreValue = zstring.split(mine_quelity_level_up_param ,",")
    local quality_id = tonumber(self._cell.info._quality)
    local quality_level_up_exp = self._cell.info._quality_level_up_exp
    local real_quality = quality_id             -- 实际矿产品质
    if tonumber(self._cell.info._userId) == -1 then
        local m_times = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self._cell.info._mining_time)/1000
        if m_times > 0 then
            quality_level_up_exp = self._cell.info._quality_level_up_exp - math.floor(math.floor(m_times/60)*per_minute_sub_exp)
            if quality_level_up_exp <= 0 then
                quality_level_up_exp = 0
            end
        end
        local isVariety = false
        for i=1, #richOreValue do
            if quality_level_up_exp >= tonumber(richOreValue[i]) then
                quality_id = i
                isVariety = true
            end
        end
        if quality_id>=3 then
            quality_id=3
        end
        if isVariety == false then
            quality_id = 0 
        end
        real_quality = quality_id
    elseif tonumber(self._cell.info._userId) > 0 then   
        --有富矿隐藏数据
        if self._cell.info.talent ~= "" and self._cell.info.talent ~= nil then
            if self._cell.info._talent_id["76"] ~= nil then
                local talentTime = tonumber(self._cell.info._talent_end_time["76"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                if talentTime > 0 then
                    quality_id = 0
                end
            end
        end
    end
    --疯狂矿工,隐藏富矿
    if _ED.activity_info["87"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["87"].activity_add_state, ",")
        local activity_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if activity_times > 0 then
            quality_id = 0
        end
    end
    
    local mine_level = dms.atoi(element, world_mine_mould.level)
    Text_res_icon_name_lv:setString(mine_name.." "..friends_tip_string[12]..mine_level)
    Text_res_icon_name_lv:setColor(cc.c3b(color_Type[zstring.tonumber(quality_id)+1][1],color_Type[zstring.tonumber(quality_id)+1][2],color_Type[zstring.tonumber(quality_id)+1][3]))
    --推荐战力
    local Text_rec_fight_n = ccui.Helper:seekWidgetByName(root,"Text_rec_fight_n")
    local recommend_combat_effectiveness = dms.atoi(element, world_mine_mould.recommend_combat_effectiveness)
    Text_rec_fight_n:setString(exChangeNumToString(recommend_combat_effectiveness))
    
    
    --产量
    local Text_yield_n = ccui.Helper:seekWidgetByName(root,"Text_yield_n")
    Text_yield_n:setString(""..100+50*zstring.tonumber(real_quality).."%")
    Text_yield_n:setColor(cc.c3b(color_Type[zstring.tonumber(real_quality)+1][1],color_Type[zstring.tonumber(real_quality)+1][2],color_Type[zstring.tonumber(real_quality)+1][3]))
    --坐标
    local Text_coordinate_n = ccui.Helper:seekWidgetByName(root,"Text_coordinate_n")
    local mx = 599 + self._cell.tileX + 1
    local my = self._cell.tileY + 1
    -- local ta = _ED.cta[my][mx]
    local ta = {}
    local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
    ta.x = ta_x
    ta.y = ta_y
    Text_coordinate_n:setString(ta.x..","..ta.y)
    self.mine_y = ta.y
    self.mine_x = ta.x
    
    --抵达时间
    local Text_arr_time_n = ccui.Helper:seekWidgetByName(root,"Text_arr_time_n")
    local m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,ta.x,ta.y)
    Text_arr_time_n:setString(exChangeTimeToString(m_times))
    
    
    --图标
    local Panel_res_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_build_icon")
    
    local pic = dms.atos(element, world_mine_mould.pic)
    -- local sprite = cc.Sprite:create(string.format("map/base_npc/map_%s.png", pic))
    
    local armature_index = dms.atoi(element, world_mine_mould.armature_index)
    local effect_paths = string.format(config_res.images.ui.home.home_build_effect, tonumber(pic))
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    local armature = ccs.Armature:create("home_build_"..pic)
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():playWithIndex(armature_index)
    armature:setPosition(0,Panel_res_build_icon:getContentSize().height/2)
    sprite = armature
    Panel_res_build_icon:addChild(sprite)
    sprite:setAnchorPoint(cc.p(0.5, 0.5))
    sprite:setPosition(cc.p(Panel_res_build_icon:getContentSize().width/2,Panel_res_build_icon:getContentSize().height/2))
    if verifySupportLanguage(_lua_release_language_en) == true then
        Panel_res_build_icon:removeAllChildren(true)
        Panel_res_build_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic))
    end
    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_infor_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_resource_point_operation_interface_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_resource_point_operation_interface_close",
        terminal_state = 0,
    },
    nil,3)
    
    --分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share"), nil, 
    {
        terminal_name = "",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    -- 打开帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help_infor"), nil, 
    {
        terminal_name = "red_alert_time_mine_help_info_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --收藏
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_collection"), nil, 
    {
        terminal_name = "red_alert_time_mine_resource_point_operation_collection_or_cancel",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        m_type = 1,
        cells = self._cell,
    },
    nil,1)
    
    --侦察
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_spy"), nil, 
    {
        terminal_name = "red_alert_time_mine_resource_point_operation_interface_investigate",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        cells = self._cell,
    },
    nil,1)
    
    --进攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_attack"), nil, 
    {
        terminal_name = "red_alert_time_mine_resource_point_operation_interface_attack",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_map_res_act"), nil, 
    {
        terminal_name = "red_alert_time_mine_resource_point_operation_interface_activity_rule",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)
    
    --分享打开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share"), nil, 
    {
        terminal_name = "red_alert_time_mine_resource_point_operation_interface_open_share",
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
        terminal_name = "red_alert_time_mine_resource_point_operation_interface_close_share", 
        terminal_state = 0, 
    }, nil, 1)
    
    --分享到军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share_legion_chat"), nil, 
    {
        terminal_name = "red_alert_time_mine_resource_point_operation_interface_share_world",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function redAlertTimeMineResourcePointOperationInterface:onExit()
    state_machine.remove("red_alert_time_mine_resource_point_operation_interface_update")
    state_machine.remove("red_alert_time_mine_resource_point_operation_collection_or_cancel")
    state_machine.remove("red_alert_time_mine_resource_point_operation_interface_attack")
    state_machine.remove("red_alert_time_mine_resource_point_operation_interface_open_share")
    state_machine.remove("red_alert_time_mine_resource_point_operation_interface_close_share")
    state_machine.remove("red_alert_time_mine_resource_point_operation_interface_share_world")
    state_machine.remove("red_alert_time_mine_resource_point_operation_interface_activity_rule")
    state_machine.remove("red_alert_time_mine_resource_point_operation_interface_investigate")
end