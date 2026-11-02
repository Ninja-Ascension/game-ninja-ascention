--------------------------------------------------------------------------------------------------------------
--  装备强化
--------------------------------------------------------------------------------------------------------------
EquipmentStrengthenTab = class("EquipmentStrengthenTabClass", Window)

local equipment_strengthen_tab_window_open_terminal = {
    _name = "equipment_strengthen_tab_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentStrengthenTab:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_strengthen_tab_window_open_terminal)
state_machine.init()

function EquipmentStrengthenTab:ctor()
    self.super:ctor()
    self.roots = {}

    self._equipment_id = 0          -- 装备实例id

    self._tools_num = 0             -- 消耗工具箱数量
    self._max_tools_num = 0         -- 强化到100%需要的工具箱数量
    self._base_success_ratio = 0    -- 基础成功率
    self._tools_success_ratio = 0   -- 每个工具箱增肌成功率
    self._have_tools_num = 0        -- 拥有的工具箱数量

    self._is_have_gem = true        -- 是否拥有足够宝石
    self._is_max_level = false      -- 是否已强化到最大等级
    self._is_have_level = true      -- 是否满足强化需求等级

    self._is_wear = false

    self.m_times = 0

    -- Initialize equipment_strengthen_tab state machine.
    local function init_equipment_strengthen_tab_terminal()
        -- 强化
        local equipment_strengthen_tab_strengthen_terminal = {
            _name = "equipment_strengthen_tab_strengthen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_max_level == true then
                    TipDlg.drawTextDailog(red_alert_time_str[56])
                    return
                end
                if instance._is_have_level == false then
                    TipDlg.drawTextDailog(red_alert_time_str[53])
                    return
                end
                if instance._is_have_gem == false then
                    TipDlg.drawTextDailog(red_alert_time_str[58])
                    return
                end
                local strength_num = params._datas.strength_num         -- 强化次数
                local tools_num = instance._tools_num              -- 消耗工具数
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            local current_equipment = _ED.user_equiment[""..response.node._equipment_id]           -- 当前装备属性
                            response.node._tools_num = 0
                            response.node:updateDraw()
                            if strength_num == 1 then           -- 强化1次
                                local result = tonumber(_ED.equip_strength_result[1].result)
                                if result == 0 then
                                    TipDlg.drawTextDailog(red_alert_time_str[44])
                                    response.node:playLevelEffect()
                                    state_machine.excute("equipment_reform_tab_tab_update_draw", 0, "")
                                    checkPlayEffect(59)
                                elseif result == 1 then
                                    TipDlg.drawTextDailog(red_alert_time_str[52])
                                elseif result == 2 then
                                    TipDlg.drawTextDailog(red_alert_time_str[53])
                                else
                                    TipDlg.drawTextDailog(red_alert_time_str[54])
                                end
                                state_machine.excute("equipment_strengthen_reform_need_update", 0, "")
                            else                                -- 强化10次
                                state_machine.excute("equipment_strengthen_result_window_open", 0, current_equipment)
                                state_machine.excute("equipment_strengthen_reform_need_update", 0, "")
                                state_machine.excute("equipment_reform_tab_tab_update_draw", 0, "")
                                checkPlayEffect(59)
                            end
                        end
                    end
                end
                protocol_command.equipment_escalate.param_list = instance._equipment_id.."\r\n"..strength_num.."\r\n"..tools_num
                NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新成功率
        local equipment_strengthen_tab_change_tools_num_terminal = {
            _name = "equipment_strengthen_tab_change_tools_num",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local change_num = params._datas.change_num
                instance._tools_num = instance._tools_num + change_num
                if instance._tools_num < 0 then
                    instance._tools_num = 0
                elseif instance._tools_num > instance._max_tools_num then
                    if instance._tools_num <= instance._have_tools_num then
                        TipDlg.drawTextDailog(red_alert_time_str[219])
                    else
                        -- TipDlg.drawTextDailog(red_alert_time_str[220])
                    end
                    instance._tools_num = instance._max_tools_num
                end
                instance:updateSuccessRatio()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local equipment_strengthen_tab_update_draw_terminal = {
            _name = "equipment_strengthen_tab_update_draw",
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

        --分解
        local equipment_strengthen_tab_decompose_terminal = {
            _name = "equipment_strengthen_tab_decompose",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local equipment_info = _ED.user_equiment[""..instance._equipment_id]
                local equipments = {equipment_info}
                state_machine.excute("equipment_parts_decompose_window_open", 0, {1, equipments})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --装配
        local equipment_strengthen_tab_wear_terminal = {
            _name = "equipment_strengthen_tab_wear",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local wear_type = 0
                if self._is_wear == false then      -- 穿装备
                    wear_type = 1
                end
                local equipment_info = _ED.user_equiment[""..instance._equipment_id]
                local equipment_type = tonumber(equipment_info.influence_type)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateButtonState()
                        end
                        state_machine.excute("equipment_packs_tab_fitting_update_draw", 0, "")
                        state_machine.excute("equipment_parts_tab_update_draw_cell", 0, equipment_type)
                        if wear_type == 0 then
                            TipDlg.drawTextDailog(tipString_info_project_pacific_rim[7])
                        else
                            TipDlg.drawTextDailog(tipString_info_project_pacific_rim[6])
                        end
                    end
                end
                protocol_command.equipment_adorn.param_list = equipment_info.equip_id .."\r\n".. wear_type
                NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --分享打开
        local equipment_strengthen_tab_share_open_terminal = {
            _name = "equipment_strengthen_tab_share_open",
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
        local equipment_strengthen_tab_share_close_terminal = {
            _name = "equipment_strengthen_tab_share_close",
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
        local equipment_strengthen_tab_share_chats_terminal = {
            _name = "equipment_strengthen_tab_share_chats",
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
                        state_machine.excute("equipment_strengthen_tab_share_close", 0, 0)         
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("equipment_strengthen_tab_share_close", 0, 0) 
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("equipment_strengthen_tab_share_close", 0, "")
                        TipDlg.drawTextDailog(game_share_tip_text[1])
                    end
                end
                
                local equipment_info = _ED.user_equiment[""..instance._equipment_id]
                local equipment_mould_id = equipment_info.equipment_mould_id
                local share_id = dms.int(dms["equipment_mould"], equipment_mould_id, equipment_mould.influence_type)
                local share_position = dms.int(dms["equipment_mould"], equipment_mould_id, equipment_mould.equipment_type)
                if share_id == 1 then
                    share_position = share_position + 4
                elseif share_id == 2 then
                    share_position = share_position + 12
                elseif share_id == 3 then
                    share_position = share_position + 20
                else
                    share_position = share_position + 28
                end
                local datas = dms.string(dms["message_share"], share_position, message_share.content)
                local equip_name = dms.string(dms["equipment_mould"], equipment_mould_id, equipment_mould.equipment_name)        -- 名称
                local quality = dms.int(dms["equipment_mould"], equipment_mould_id, equipment_mould.grow_level)              -- 品质
                local mine_info = "|"..quality.."|"..equip_name
                local data1 =  string.gsub(datas, "!x@", mine_info)
                -- local paramsInfo = mine_info
                local paramsInfo = "5-1-"..equipment_mould_id..","..mine_info
                datas = ""--data1
                local str =datas..chat_section[1].."4".."|"..equipment_info.equipment_name..","..equipment_info.strength..","..equipment_info.upgrade_level
                    ..","..equipment_info.rank_up_level..","..equipment_info.influence_type..","..equipment_info.equipment_type.."+"..equipment_info.pic_index.."+"..equipment_info.attr
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n" .. share_position.."\r\n"..paramsInfo
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=instance, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新活动加层
        local equipment_strengthen_tab_update_activity_add_draw_terminal = {
            _name = "equipment_strengthen_tab_update_activity_add_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDrawActicityAdd()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(equipment_strengthen_tab_update_activity_add_draw_terminal)
        state_machine.add(equipment_strengthen_tab_strengthen_terminal)
        state_machine.add(equipment_strengthen_tab_change_tools_num_terminal)
        state_machine.add(equipment_strengthen_tab_update_draw_terminal)
        state_machine.add(equipment_strengthen_tab_decompose_terminal)
        state_machine.add(equipment_strengthen_tab_wear_terminal)
        state_machine.add(equipment_strengthen_tab_share_open_terminal)    
        state_machine.add(equipment_strengthen_tab_share_close_terminal)    
        state_machine.add(equipment_strengthen_tab_share_chats_terminal)  
        state_machine.init()
    end
    
    -- call func equipment_strengthen_tab create state machine.
    init_equipment_strengthen_tab_terminal()

end

function EquipmentStrengthenTab:updateDraw()
    local root = self.roots[1]

    local equipment_info = _ED.user_equiment[""..self._equipment_id]
    local equipment_mould_id = equipment_info.equipment_mould_id

    -- 配件图标和名称
    local Panel_parts_icon = ccui.Helper:seekWidgetByName(root, "Panel_parts_icon")
    local Text_parts_name = ccui.Helper:seekWidgetByName(root, "Text_parts_name")
    Text_parts_name:setString(equipment_info.equipment_name)
    Panel_parts_icon:removeAllChildren(true)
    local equip_cell = state_machine.excute("props_icon_create_cell", 0, {8, 4, self._equipment_id, 7})
    Panel_parts_icon:addChild(equip_cell)

    local equipment_data = dms.element(dms["equipment_mould"], equipment_mould_id)

    -- 最大强化等级
    local grow_value_info = zstring.split(dms.string(dms["equipment_mould"], equipment_mould_id, equipment_mould.grow_value), "|")
    local attr_info = zstring.split(grow_value_info[1], ",")
    local max_level = tonumber(attr_info[2])

    -- 显示成功率和消耗宝石数
    local current_level = equipment_info.upgrade_level

    if tonumber(current_level) < tonumber(max_level) then
        self._is_max_level = false
        local quality = equipment_info.grow_level
        local cost_gem = 0
        local success_ratio = 0
        if quality == 1 then        -- 绿色配件
            cost_gem = dms.int(dms["equipment_level_requirement"], current_level + 1, equipment_level_requirement.silver_amount)
            success_ratio = dms.int(dms["equipment_level_requirement"], current_level + 1, equipment_level_requirement.success_ratio)
        else
            local index = equipment_level_requirement.cost_gem_1 + (quality - 2) * 2
            cost_gem = dms.int(dms["equipment_level_requirement"], current_level + 1, index)
            success_ratio = dms.int(dms["equipment_level_requirement"], current_level + 1, index + 1)
        end

        local Panel_streng_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_streng_props_icon")
        local Text_streng_props_n = ccui.Helper:seekWidgetByName(root, "Text_streng_props_n")
        Panel_streng_props_icon:removeAllChildren(true)
        Text_streng_props_n:removeAllChildren(true)
        local cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, resource_prop_id[1], 1, _ED.user_info.user_silver})
        Panel_streng_props_icon:addChild(cell)

        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        local color = nil
        if tonumber(_ED.user_info.user_silver) < tonumber(cost_gem) then
            color = cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])
            self._is_have_gem = false
        else
            color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
            self._is_have_gem = true
        end
        local re1 = ccui.RichElementText:create(1, color ,255, exChangeNumToString(_ED.user_info.user_silver), "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..exChangeNumToString(cost_gem), "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_streng_props_n:getContentSize().width/2,Text_streng_props_n:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_streng_props_n:getContentSize().width,18))
        Text_streng_props_n:addChild(_richText)

        -- 需求等级
        local need_level = dms.int(dms["equipment_level_requirement"], current_level + 1, equipment_level_requirement.ship_level)
        if tonumber(_ED.user_info.user_grade) < need_level then
            self._is_have_level = false
        end

        -- vip等级增加成功率
        local vip_ratio = dms.int(dms["base_consume"],83,base_consume.vip_0_value + tonumber(_ED.vip_grade)) 
        self._base_success_ratio = success_ratio * (1 + vip_ratio / 100)
        local Text_streng_vip_prompt_1 = ccui.Helper:seekWidgetByName(root, "Text_streng_vip_prompt_1")
        Text_streng_vip_prompt_1:setString(string.format(red_alert_time_str[28], tonumber(_ED.vip_grade), ""..(self._base_success_ratio - success_ratio)))

        -- 工具箱消耗
        local tools_id = dms.int(dms["prop_config"], 14, prop_config.param)
        self._tools_success_ratio = dms.int(dms["equipment_level_requirement"], current_level + 1, equipment_level_requirement.stuff_amount)
        local Panel_consume_props = ccui.Helper:seekWidgetByName(root, "Panel_consume_props")
        Panel_consume_props:removeAllChildren(true)
        local cell_tool = state_machine.excute("props_icon_create_cell", 0, {6, 1, tools_id, 1})
        Panel_consume_props:addChild(cell_tool)

        local prop_count = 0 
        if fundPropWidthId(tools_id) ~= nil then 
            local token = fundPropWidthId(tools_id)
            prop_count = zstring.tonumber(token.prop_number)
        end
        local need_count = math.ceil((100 - self._base_success_ratio) / self._tools_success_ratio)
        self._max_tools_num = math.max(math.min(need_count, prop_count), 0)
        self._have_tools_num = prop_count


        -- 刷新按钮状态
        local Button_streng_ten = ccui.Helper:seekWidgetByName(root, "Button_streng_ten")
        local Button_streng = ccui.Helper:seekWidgetByName(root, "Button_streng")
        local Button_consume_p_minus = ccui.Helper:seekWidgetByName(root, "Button_consume_p_minus")
        local Button_consume_p_add = ccui.Helper:seekWidgetByName(root, "Button_consume_p_add")
        if self._is_have_level == false then
            Button_streng_ten:setBright(false)
            Button_streng:setBright(false)
            Button_consume_p_minus:setTouchEnabled(false)
            Button_consume_p_minus:setBright(false)
            Button_consume_p_add:setTouchEnabled(false)
            Button_consume_p_add:setBright(false)
        else
            Button_streng_ten:setBright(true)
            Button_streng:setBright(true)
            Button_consume_p_minus:setTouchEnabled(true)
            Button_consume_p_minus:setBright(true)
            Button_consume_p_add:setTouchEnabled(true)
            Button_consume_p_add:setBright(true)
        end

        self:updateSuccessRatio()
    else
        self._is_max_level = true
        local Panel_strengthen_list_2_box = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_list_2_box")
        local Panel_strengthen_list_3 = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_list_3")
        local Panel_strengthen_list_4 = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_list_4")
        local Text_strengthen_prompt = ccui.Helper:seekWidgetByName(root, "Text_strengthen_prompt")
        Panel_strengthen_list_2_box:setVisible(false)
        Panel_strengthen_list_3:setVisible(false)
        Panel_strengthen_list_4:setVisible(false)
        Text_strengthen_prompt:setVisible(true)
    end
    self:updateLevelInfo()
    self:updateButtonState()
    self:updateDrawActicityAdd()
end

function EquipmentStrengthenTab:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            self:updateDrawActicityAdd()
        end
    end
end

function EquipmentStrengthenTab:updateDrawActicityAdd()
    local root = self.roots[1]
    local Text_streng_vip_prompt_2 = ccui.Helper:seekWidgetByName(root, "Text_streng_vip_prompt_2")
    Text_streng_vip_prompt_2:setString("")
    Text_streng_vip_prompt_2:removeAllChildren(true)
    if _ED.activity_info["68"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["68"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[11][1],color_Type[11][2],color_Type[11][3]), 255, red_alert_time_str[266], "fonts/simhei.ttf",18)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]), 255, string.format(red_alert_time_str[267],(tonumber(timesData[4]) * 100)), "fonts/simhei.ttf",18)
            _richText:pushBackElement(re2)
            _richText:setPosition(cc.p(Text_streng_vip_prompt_2:getContentSize().width/2,Text_streng_vip_prompt_2:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_streng_vip_prompt_2:getContentSize().width,18))
            Text_streng_vip_prompt_2:addChild(_richText)
        else
            Text_streng_vip_prompt_2:setString(red_alert_time_str[266])
        end
    else
        Text_streng_vip_prompt_2:setString(red_alert_time_str[266])
    end
end

function EquipmentStrengthenTab:updateButtonState()
    local root = self.roots[1]
    local Button_parts_un = ccui.Helper:seekWidgetByName(root, "Button_parts_un")
    local Button_parts_decompose = ccui.Helper:seekWidgetByName(root, "Button_parts_decompose")

    local equipment_info = _ED.user_equiment[""..self._equipment_id]
    if tonumber(equipment_info.is_equiped) == 0 then      -- 未装备
        self._is_wear = false
    else
        self._is_wear = true
    end

    if Button_parts_un ~= nil then
        if self._is_wear == false then      -- 未装备
            Button_parts_un:setTitleText(red_alert_time_str[34])
        else
            Button_parts_un:setTitleText(red_alert_time_str[35])
        end
    end

    if Button_parts_decompose ~= nil then
        if self._is_wear == false then      -- 未装备
            Button_parts_decompose:setBright(true)
            Button_parts_decompose:setTouchEnabled(true)
        else
            Button_parts_decompose:setBright(false)
            Button_parts_decompose:setTouchEnabled(false)
        end
    end
end

function EquipmentStrengthenTab:playLevelEffect()
    local root = self.roots[1]
    local Panel_parts_icon = ccui.Helper:seekWidgetByName(root, "Panel_parts_icon")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_equipment_strengthen)
    local armature = ccs.Armature:create("effect_equipment_strengthen")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(Panel_parts_icon:getContentSize().width/2,Panel_parts_icon:getContentSize().height/2))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc) 
    Panel_parts_icon:addChild(armature)
    armature._invoke = function(armatureBack)
        armature:removeFromParent(true)
    end
end

function EquipmentStrengthenTab:updateLevelInfo()
    local root = self.roots[1]

    local equipment_info = _ED.user_equiment[""..self._equipment_id]
    local equipment_mould_id = equipment_info.equipment_mould_id

    local strength_level = tonumber(equipment_info.upgrade_level)         -- 当前强化等级
    local reform_level = tonumber(equipment_info.rank_up_level)                    -- 当前改造等级

    local next_strength_level = strength_level + 1
    local next_reform_level = reform_level

    -- 属性变化箭头
    for i = 1, 5 do
        local Panel_streng_state = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_" .. i)
        Panel_streng_state:removeBackGroundImage()
    end

    -- 强度和强化改造等级 
    local Text_streng_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_1") -- 当前强度
    local Text_streng_attribute_n_2 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_2") -- 当前强化等级
    local Text_streng_attribute_n_3 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_3") -- 当前强度
    Text_streng_attribute_n_1:setString(getEquipmentStrength(equipment_mould_id, strength_level, reform_level))
    Text_streng_attribute_n_2:setString(strength_level)
    Text_streng_attribute_n_3:setString(reform_level)

    local Text_streng_attribute_change_1 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_1") -- 下一级强度
    local Text_streng_attribute_change_2 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_2") -- 下一级强化等级
    local Text_streng_attribute_change_3 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_3") -- 下一级强度
    if self._is_max_level == false then
        local next_strength = getEquipmentStrength(equipment_mould_id, next_strength_level, next_reform_level)
        Text_streng_attribute_change_1:setString(next_strength)
        Text_streng_attribute_change_2:setString(next_strength_level)
        Text_streng_attribute_change_3:setString(next_reform_level)

        local Panel_streng_state_1 = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_1")
        local Panel_streng_state_2 = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_2")
        Panel_streng_state_1:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
        Panel_streng_state_2:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
    else
        Text_streng_attribute_change_1:setString("")
        Text_streng_attribute_change_2:setString("")
        Text_streng_attribute_change_3:setString("")
    end

    -- 属性加成
    local current_equipment_attr = getEquipmentAttr(equipment_mould_id, strength_level, reform_level)
    local next_equipment_attr = nil

    local initial_value_info = zstring.split(dms.string(dms["equipment_mould"], equipment_mould_id, equipment_mould.initial_value), "|")
    local attr_ids = {}
    for k, initial_value in pairs(initial_value_info) do
        local info = zstring.split(initial_value, ",")
        local attr = tonumber(info[1])
        table.insert(attr_ids, attr)
    end

    local Text_streng_attribute_4 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_4") -- 属性1名称
    local Text_streng_attribute_n_4 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_4") -- 属性1当前值
    local Text_streng_attribute_change_4 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_4") -- 属性1下一级值
    local Panel_streng_state_4 = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_4")
    Text_streng_attribute_change_4:setString("")

    local attr_id = attr_ids[1]             -- 属性1类型
    Text_streng_attribute_4:setString(red_alert_time_attribute[attr_id + 1] .. red_alert_time_str[29])
    local is_hundred = false
    for k, v in pairs(attribute_hundred) do
        if v == attr_id then
            is_hundred = true
            break
        end
    end
    if is_hundred == true then
        Text_streng_attribute_n_4:setString(current_equipment_attr[""..attr_id] .. "%")
    else
        Text_streng_attribute_n_4:setString(current_equipment_attr[""..attr_id])
    end

    if self._is_max_level == false then
        next_equipment_attr = getEquipmentAttr(equipment_mould_id, next_strength_level, next_reform_level)
        if is_hundred == true then
            Text_streng_attribute_change_4:setString(next_equipment_attr[""..attr_id] .. "%")
        else
            Text_streng_attribute_change_4:setString(next_equipment_attr[""..attr_id])
        end
        Panel_streng_state_4:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
    end

    local Text_streng_attribute_5 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_5") -- 属性2名称
    local Text_streng_attribute_n_5 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_n_5") -- 属性2当前值
    local Text_streng_attribute_change_5 = ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_5") -- 属性2下一级值
    local Panel_streng_state_5 = ccui.Helper:seekWidgetByName(root, "Panel_streng_state_5")
    Text_streng_attribute_change_5:setString("")

    if attr_ids[2] ~= nil then
        local attr_id_2 = attr_ids[2]             -- 属性2类型
        Text_streng_attribute_5:setString(red_alert_time_attribute[attr_id_2 + 1] .. red_alert_time_str[29])
        local is_hundred = false
        for k, v in pairs(attribute_hundred) do
            if v == attr_id_2 then
                is_hundred = true
                break
            end
        end
        if is_hundred == true then
            Text_streng_attribute_n_5:setString(current_equipment_attr[""..attr_id_2] .. "%")
        else
            Text_streng_attribute_n_5:setString(current_equipment_attr[""..attr_id_2])
        end

        if self._is_max_level == false then
            if is_hundred == true then
                Text_streng_attribute_change_5:setString(next_equipment_attr[""..attr_id_2] .. "%")
            else
                Text_streng_attribute_change_5:setString(next_equipment_attr[""..attr_id_2])
            end
            Panel_streng_state_5:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
        end
    else
        Text_streng_attribute_5:setString("")
        Text_streng_attribute_n_5:setString("")
        Text_streng_attribute_change_5:setString("")
    end

    for i = 1, 5 do
        local Text_streng_attribute_change =  ccui.Helper:seekWidgetByName(root, "Text_streng_attribute_change_"..i)
        local Panel_streng_state =  ccui.Helper:seekWidgetByName(root, "Panel_streng_state_"..i)
        local posX = string.len(Text_streng_attribute_change:getString()) * 10 + Text_streng_attribute_change:getPositionX()
        Panel_streng_state:setPositionX(posX + 5)
    end
end

-- 刷新工具箱数量和成功率
function EquipmentStrengthenTab:updateSuccessRatio()
    local root = self.roots[1]
    -- 总成功率
    local Text_success_n = ccui.Helper:seekWidgetByName(root, "Text_success_n")
    local Text_consume_props_n = ccui.Helper:seekWidgetByName(root, "Text_consume_props_n")
    Text_consume_props_n:setString(self._tools_num)

    local success_ratio = self._base_success_ratio + self._tools_num * self._tools_success_ratio
    if success_ratio > 100 then
        success_ratio = 100
    end
    Text_success_n:setString(success_ratio .. "%")
end

function EquipmentStrengthenTab:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_strengthen_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local ListView_strengthen = ccui.Helper:seekWidgetByName(root, "ListView_strengthen")
    if nil ~= ListView_strengthen.setBounceBottomBoundary then
        ListView_strengthen:setBounceBottomBoundary(0)
    end

    -- 强化10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_streng_ten"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_strengthen", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        strength_num = 10,
    }, nil, 1) 

    -- 强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_streng"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_strengthen", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        strength_num = 1,
    }, nil, 1) 

    -- 增加消耗品
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consume_p_add"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_change_tools_num", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        change_num = 1,
    }, nil, 1) 

    -- 减少消耗品
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consume_p_minus"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_change_tools_num", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        change_num = -1,
    }, nil, 1) 

    -- 分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_decompose"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_decompose", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 装配
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_un"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_wear", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 分享打开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_share_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  
    
    local Panel_share_close = ccui.Helper:seekWidgetByName(root,"Panel_share_close")
    if Panel_share_close ~= nil then
        Panel_share_close:setSwallowTouches(false)
    end
    -- 分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_share_close", 
        terminal_state = 0, 
    }, nil, 1)  
    
    -- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "equipment_strengthen_tab_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1)  

    self:updateDraw()
end

function EquipmentStrengthenTab:onEnterTransitionFinish()
    
end

function EquipmentStrengthenTab:init(params)
    local rootWindow = params[1]
    self._equipment_id = params[2]

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentStrengthenTab:onExit()
    state_machine.remove("equipment_strengthen_tab_strengthen")
    state_machine.remove("equipment_strengthen_tab_change_tools_num")
    state_machine.remove("equipment_strengthen_tab_update_draw")
    state_machine.remove("equipment_strengthen_tab_decompose")
    state_machine.remove("equipment_strengthen_tab_wear")
    state_machine.remove("equipment_strengthen_tab_share_open")
    state_machine.remove("equipment_strengthen_tab_share_close")
    state_machine.remove("equipment_strengthen_tab_share_chats")
    state_machine.remove("equipment_strengthen_tab_update_activity_add_draw")
end