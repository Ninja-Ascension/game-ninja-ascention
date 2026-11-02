-- ----------------------------------------------------------------------------------------------------
-- 说明：世界侦察结果
-------------------------------------------------------------------------------------------------------
redAlertTimeMineDetectResult = class("redAlertTimeMineDetectResultClass", Window)

local red_alert_time_mine_detect_result_open_terminal = {
    _name = "red_alert_time_mine_detect_result_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("redAlertTimeMineDetectResultClass")
        if nil == _homeWindow then
            fwin:open(redAlertTimeMineDetectResult:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_detect_result_close_terminal = {
    _name = "red_alert_time_mine_detect_result_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("redAlertTimeMineDetectResultClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("redAlertTimeMineDetectResultClass"))
        end
        _ED._help_defence_name = nil
        _ED._help_defence_level = nil
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_detect_result_open_terminal)
state_machine.add(red_alert_time_mine_detect_result_close_terminal)
state_machine.init()
    
function redAlertTimeMineDetectResult:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil
    self.m_Listview = nil
    self.is_union_member = false
    
    app.load("client.red_alert_time.cells.worldMap.world_mine_line_list_cell")

    local function init_red_alert_time_mine_detect_result_terminal()
        -- 定位
        local red_alert_time_mine_detect_result_location_terminal = {
            _name = "red_alert_time_mine_detect_result_location",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_mine_detect_result_close", 0, 0)
                state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
                state_machine.excute("adventure_mine_record_view_position", 0, {_ED.world_map.investigate_info._x,_ED.world_map.investigate_info._y})
                state_machine.excute("adventure_mine_update_view_position", 0, 0)

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("adventure_mine_cell_focus_blink", 0, {_ED.world_map.investigate_info._x,_ED.world_map.investigate_info._y})
                    end
                end
                
                protocol_command.world_map_arena_info_refresh.param_list = "" .. _ED.world_map.investigate_info._x .. "\r\n" .. _ED.world_map.investigate_info._y
                NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 进攻
        local red_alert_time_mine_detect_result_attack_terminal = {
            _name = "red_alert_time_mine_detect_result_attack",
            _init = function (terminal)
                app.load("client.red_alert_time.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.is_union_member == true then
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance.m_object.info ,playersOrmine = 6}})
                else
                    if __lua_project_id == __lua_project_pacific_rim then
                        state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance.m_object.info ,playersOrmine = 0,
                            next_terminal = "formation_defend_add_investigate_formation_info", next_terminal_params = {instance._cell, true}}})
                    else
                        state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance.m_object.info ,playersOrmine = 0}})
                    end
                end
                -- state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = self.m_object.info ,playersOrmine = 0}})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --保存
        local red_alert_time_mine_detect_result_save_terminal = {
            _name = "red_alert_time_mine_detect_result_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.isSave == false then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                TipDlg.drawTextDailog(mail_tip_text[15])
                                response.node:onUpdateButton()
                            end
                        end
                    end
                    protocol_command.battlefield_report_save.param_list = "10002".."\r\n".._ED.world_map.investigate_info._times
                    NetworkManager:register(protocol_command.battlefield_report_save.code, nil, nil, nil, instance, responseCallback, false, nil)
                else
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            --清除
                            for i, v in pairs(_ED.city_resource_battle_save_report) do
                                if tonumber(v.time) == tonumber(_ED.world_map.investigate_info._times) then
                                    _ED.city_resource_battle_save_report[i] = nil
                                end
                            end
                            TipDlg.drawTextDailog(mail_tip_text[26])
                            state_machine.excute("red_alert_time_mine_detect_result_close", 0, 0)
                        end
                    end
                    protocol_command.battlefield_report_save_delete.param_list = _ED.world_map.investigate_info._times
                    NetworkManager:register(protocol_command.battlefield_report_save_delete.code, nil, nil, nil, nil, responseCallback, false, nil)
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 删除
        local red_alert_time_mine_detect_result_delete_terminal = {
            _name = "red_alert_time_mine_detect_result_delete",
            _init = function (terminal)
                -- app.load("client.red_alert_time.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        for i, v in pairs(_ED.city_resource_battle_report[10002]) do
                            if tonumber(v.time) == tonumber(_ED.world_map.investigate_info._times) then
                                _ED.city_resource_battle_report[10002][i] = nil
                            end
                        end
                        state_machine.excute("mail_presentation_investigation_update_all",0,0)
                        state_machine.excute("red_alert_time_mine_detect_result_close",0,0)
                    end 
                end
                protocol_command.delete_message.param_list = "10002".."\r\n".._ED.world_map.investigate_info._times
                NetworkManager:register(protocol_command.delete_message.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_mine_detect_result_location_terminal)
        state_machine.add(red_alert_time_mine_detect_result_attack_terminal)
        state_machine.add(red_alert_time_mine_detect_result_save_terminal)
        state_machine.add(red_alert_time_mine_detect_result_delete_terminal)
    
        state_machine.init()
    end
    
    init_red_alert_time_mine_detect_result_terminal()
end

function redAlertTimeMineDetectResult:init(params)
    self.m_object = params
    self:onInit()
    return self
end

function redAlertTimeMineDetectResult:getTimeFormatYMDHMS( m_time )
    local temp = os.date("*t",m_time - _ED.GTM_Time)

    local m_month   = string.format("%02d", temp.month)
    local m_day     = string.format("%02d", temp.day)
    local m_hour    = string.format("%02d", temp.hour)
    local m_min     = string.format("%02d", temp.min)
    local m_sec     = string.format("%02d", temp.sec)


    local timeString = temp.year ..".".. m_month ..".".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec


    return timeString
end

function redAlertTimeMineDetectResult:onUpdateButton()
    local root = self.roots[1]
    self.isSave = false
    local Button_spy_presentation_save = ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_save")
    if _ED.city_resource_battle_save_report == nil or #_ED.city_resource_battle_save_report <= 1 then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    local Button_spy_presentation_save = ccui.Helper:seekWidgetByName(response.node.roots[1],"Button_spy_presentation_save")
                    for i,v in pairs(_ED.city_resource_battle_save_report) do
                        if tonumber(v.time) == tonumber(_ED.world_map.investigate_info._times) and tonumber(v.nType) == 10002 then
                            response.node.isSave = true
                        end 
                    end
                    if response.node.isSave == true then
                        Button_spy_presentation_save:setTitleText(mail_tip_text[23])
                    else
                        Button_spy_presentation_save:setTitleText(mail_tip_text[22])
                    end
                end
            end
        end
        NetworkManager:register(protocol_command.battlefield_report_save_get.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        for i,v in pairs(_ED.city_resource_battle_save_report) do
            if tonumber(v.time) == tonumber(_ED.world_map.investigate_info._times) and tonumber(v.nType) == 10002 then
                self.isSave = true
            end 
        end
        if self.isSave == true then
            Button_spy_presentation_save:setTitleText(mail_tip_text[23])
        else
            Button_spy_presentation_save:setTitleText(mail_tip_text[22])
        end
    end
end

function redAlertTimeMineDetectResult:onUpdateDraw()
    local root = self.roots[1]
    local Text_spy_t_n = ccui.Helper:seekWidgetByName(root,"Text_spy_t_n")--侦察了谁
    local Text_predatory_n = ccui.Helper:seekWidgetByName(root,"Text_predatory_n")--可以被掠夺多少
    local Text_spy_presentation_player = ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_player")--所有者
    local Text_spy_base = ccui.Helper:seekWidgetByName(root,"Text_spy_base")
    local Text_spy_base_n = ccui.Helper:seekWidgetByName(root,"Text_spy_base_n")--有无驻军
    local Text_spy_base_time = ccui.Helper:seekWidgetByName(root,"Text_spy_base_time")--时间
    Text_spy_base_time:setString(getTimeFormatYMDHMS(tonumber(_ED.world_map.investigate_info._times)/1000))
    Text_spy_base_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    Text_spy_t_n:removeAllChildren(true)
    if zstring.tonumber(_ED.world_map.investigate_info._type) > 0 then
        Text_spy_base:setString(mail_tip_text[5])
        ccui.Helper:seekWidgetByName(root,"Panel_res_spy_yield"):setVisible(true)
        local element = dms.element(dms["world_mine_mould"], _ED.world_map.investigate_info._mould_id)
        local mine_level = dms.atoi(element, world_mine_mould.level)
        local mine_name = dms.atos(element, world_mine_mould.name)
        -- 叛军
        if zstring.tonumber(_ED.world_map.investigate_info._type) == 1000 then
            Text_spy_base:setString(mail_tip_text[47])
            local investigate_info = _ED.world_map.investigate_info
            local rebel_name = dms.string(dms["npc"], investigate_info._npc_id, npc.npc_name)

            local _richText1 = ccui.RichText:create()
            _richText1:ignoreContentAdaptWithSize(false)
            local str = rebel_name.."["..investigate_info._x..","..investigate_info._y.."]"
            local re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]), 255, str, config_res.font.font_name,20)
            _richText1:pushBackElement(re1)
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_campaign_info[33], config_res.font.font_name,20)
            _richText1:pushBackElement(re2)
            local re3 =ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]), 255, tipStringInfo_campaign_info[34], config_res.font.font_name,20)
            _richText1:pushBackElement(re3)
            _richText1:setContentSize(cc.size(Text_spy_t_n:getContentSize().width,Text_spy_t_n:getContentSize().height))
            _richText1:setAnchorPoint(0,0.5)
            _richText1:setPosition(cc.p(-Text_spy_t_n:getContentSize().width/2,Text_spy_t_n:getContentSize().height/2))
            Text_spy_t_n:addChild(_richText1)

            Text_spy_base_n:setString(tipStringInfo_consumption_info[8])

            local Panel_spy_presentation_1 = ccui.Helper:seekWidgetByName(root,"Panel_spy_presentation_1")
            local Panel_spy_presentation_2 = ccui.Helper:seekWidgetByName(root,"Panel_spy_presentation_2")
            Panel_spy_presentation_1:removeFromParent(true)
            Panel_spy_presentation_2:removeFromParent(true)

            self:showAttackRebelReward()
        else
            --是否被人占领
            local textinfo = zstring.split(mail_tip_text[13], "!x@")
            if zstring.tonumber(_ED.world_map.investigate_info._user_id) > 0 then
                local _richText1 = ccui.RichText:create()
                _richText1:ignoreContentAdaptWithSize(false)
                local color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
                local re1 =ccui.RichElementText:create(1, color,255, _ED.world_map.investigate_info._nickname..friends_tip_string[12].._ED.world_map.investigate_info._level, config_res.font.font_name,18)
                _richText1:pushBackElement(re1)
                local color2 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
                local re2 =ccui.RichElementText:create(1, color2,255, textinfo[2], config_res.font.font_name,18)
                _richText1:pushBackElement(re2)
                if tonumber(_ED.world_map.investigate_info._quality) > 0 then
                    local quality = tonumber(_ED.world_map.investigate_info._quality)+1
                    color2 = cc.c3b(tipStringInfo_quality_color_Type[quality][1], tipStringInfo_quality_color_Type[quality][2], tipStringInfo_quality_color_Type[quality][3])
                end
                local re3 = ccui.RichElementText:create(1, color2,255, mine_name..string.format(red_alert_time_str[33],mine_level).."[".._ED.world_map.investigate_info._x..",".._ED.world_map.investigate_info._y.."]", config_res.font.font_name,18)
                _richText1:pushBackElement(re3)
                _richText1:setContentSize(cc.size(Text_spy_t_n:getContentSize().width,Text_spy_t_n:getContentSize().height))
                _richText1:setAnchorPoint(0,0.5)
                _richText1:setPosition(cc.p(-Text_spy_t_n:getContentSize().width/2,Text_spy_t_n:getContentSize().height/2))
                Text_spy_t_n:addChild(_richText1)
                
                local _richText2 = ccui.RichText:create()
                _richText2:ignoreContentAdaptWithSize(false)
                local player_re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_consumption_info[7], config_res.font.font_name,22)
                _richText2:pushBackElement(player_re1)
                local player_re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]),255, _ED.world_map.investigate_info._nickname.." LV.".._ED.world_map.investigate_info._level, config_res.font.font_name,22)
                _richText2:pushBackElement(player_re2)
                if (_ED.world_map.investigate_info._union_name ~= nil or _ED.world_map.investigate_info._union_name~= "" )
                    and #_ED.world_map.investigate_info._union_name > 1 then
                    local player_re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, "[".._ED.world_map.investigate_info._union_name.."]", config_res.font.font_name,22)
                    _richText2:pushBackElement(player_re3)
                end
                _richText2:setContentSize(cc.size(Text_spy_presentation_player:getContentSize().width,Text_spy_presentation_player:getContentSize().height))
                _richText2:setAnchorPoint(0,0.5)
                _richText2:setPosition(cc.p(-Text_spy_presentation_player:getContentSize().width/2,Text_spy_presentation_player:getContentSize().height/2))
                Text_spy_presentation_player:addChild(_richText2)
                
                Text_spy_base_n:setString(tipStringInfo_consumption_info[8])
                Text_predatory_n:setString(exChangeNumToString(zstring.tonumber(_ED.world_map.investigate_info._rob_count)))
            else
                if tonumber(_ED.world_map.investigate_info._quality) > 0 then
                    local quality = tonumber(_ED.world_map.investigate_info._quality)+1
                    Text_spy_t_n:setColor(cc.c3b(color_Type[quality][1], color_Type[quality][2], color_Type[quality][3]))
                end
                Text_spy_t_n:setString(mine_name..string.format(red_alert_time_str[33],mine_level).."[".._ED.world_map.investigate_info._x..",".._ED.world_map.investigate_info._y.."]")
                local _richText1 = ccui.RichText:create()
                _richText1:ignoreContentAdaptWithSize(false)
                local player_re = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_consumption_info[7], config_res.font.font_name,22)
                _richText1:pushBackElement(player_re)
                _richText1:setContentSize(cc.size(Text_spy_presentation_player:getContentSize().width,Text_spy_presentation_player:getContentSize().height))
                _richText1:setAnchorPoint(0,0.5)
                _richText1:setPosition(cc.p(-Text_spy_presentation_player:getContentSize().width/2,Text_spy_presentation_player:getContentSize().height/2))
                Text_spy_presentation_player:addChild(_richText1)
                -- Text_spy_presentation_player:setString(tipStringInfo_consumption_info[7])
                Text_spy_base_n:setString(tipStringInfo_consumption_info[9])
                Text_predatory_n:setString("0")
            end
            --产出的资源
            local Panel_res_spy_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_spy_icon")
            local mine_type = dms.atos(element, world_mine_mould.mine_type)
            local m_image = nil
            --临时资源路径，等资源定好了再换资源
            if zstring.tonumber(mine_type) == 1 then
                m_image = config_res.images.ui.home.icon_iron_ore
            elseif zstring.tonumber(mine_type) == 2 then
                m_image = config_res.images.ui.home.icon_petroeum
            elseif zstring.tonumber(mine_type) == 3 then
                m_image = config_res.images.ui.home.icon_lead_ore
            elseif zstring.tonumber(mine_type) == 4 then
                m_image = config_res.images.ui.home.icon_titanium_ore
            else
                m_image = config_res.images.ui.home.icon_gemstone
            end
            Panel_res_spy_icon:setBackGroundImage(m_image)
            
            --产量
            local Text_res_spy_yield_n = ccui.Helper:seekWidgetByName(root,"Text_res_spy_yield_n")
            local per_second_output = dms.atos(element, world_mine_mould.per_second_output)
            local second_info = zstring.split(per_second_output, ",")
            local bonus_value = 0
            for k, v in pairs(_ED.factor_info) do 
                if tonumber(v.factor_type) == 66 then
                    local build_ids = zstring.split(dms.string(dms["talent_mould"], tonumber(v.mould_id), talent_mould.base_additional), ",")
                    bonus_value = tonumber(build_ids[2])
                end
            end
            local Yield = zstring.tonumber(second_info[2])*((100+50*zstring.tonumber(_ED.world_map.investigate_info._quality)+bonus_value)/100)*3600
            Text_res_spy_yield_n:setString(exChangeNumToString(Yield).."/"..tipStringInfo_consumption_info[3])
            local Text_res_spy_quality_yield = ccui.Helper:seekWidgetByName(root,"Text_res_spy_quality_yield")
            -- print(_ED.world_map.investigate_info._quality)
            if tonumber(_ED.world_map.investigate_info._quality) == 0 then
                Text_res_spy_quality_yield:setString("")
            else
                Text_res_spy_quality_yield:setString(tipStringInfo_consumption_info[tonumber(_ED.world_map.investigate_info._quality)+3])
                local quality = tonumber(_ED.world_map.investigate_info._quality)+1
                Text_res_spy_quality_yield:setColor(cc.c3b(color_Type[quality][1], color_Type[quality][2], color_Type[quality][3]))
            end
        end
        
    else
        Text_spy_base:setString(mail_tip_text[6])
        ccui.Helper:seekWidgetByName(root,"Panel_res_spy_yield"):setVisible(false)
        local _richText1 = ccui.RichText:create()
        _richText1:ignoreContentAdaptWithSize(false)
        local color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
        local color2 = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
        local re1 =ccui.RichElementText:create(1, color2,255, _ED.world_map.investigate_info._nickname..friends_tip_string[12].._ED.world_map.investigate_info._level.."[".._ED.world_map.investigate_info._x..",".._ED.world_map.investigate_info._y.."]", config_res.font.font_name,18)
        _richText1:pushBackElement(re1)
        local re2 =ccui.RichElementText:create(1, color,255, tipStringInfo_campaign_info[33], config_res.font.font_name,18)
        _richText1:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, color2,255,tipStringInfo_campaign_info[34], config_res.font.font_name,18)
        _richText1:pushBackElement(re3)
        _richText1:setContentSize(cc.size(Text_spy_t_n:getContentSize().width,Text_spy_t_n:getContentSize().height))
        _richText1:setAnchorPoint(0,0.5)
        _richText1:setPosition(cc.p(-Text_spy_t_n:getContentSize().width/2,Text_spy_t_n:getContentSize().height/2))
        Text_spy_t_n:addChild(_richText1)
        local rob_count = tonumber(_ED.world_map.investigate_info._rob_iron_count) + tonumber(_ED.world_map.investigate_info._rob_oil_count)+tonumber(_ED.world_map.investigate_info._rob_lead_count)+tonumber(_ED.world_map.investigate_info._rob_titanium_count)+tonumber(_ED.world_map.investigate_info._rob_store_count)
        Text_predatory_n:setString(exChangeNumToString(rob_count))--这里有数据
        for i=1,5 do
            local Panel_predatory_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_predatory_res_icon_"..i)
            Panel_predatory_res_icon:setBackGroundImage("images/ui/icon/icon_1.png")
            local sprite = nil
            if i==1 then
                sprite = cc.Sprite:create(config_res.images.ui.home.icon_iron_ore)
            elseif i==2 then
                sprite = cc.Sprite:create(config_res.images.ui.home.icon_petroeum)
            elseif i==3 then
                sprite = cc.Sprite:create(config_res.images.ui.home.icon_lead_ore)
            elseif i==4 then
                sprite = cc.Sprite:create(config_res.images.ui.home.icon_titanium_ore)
            elseif i==5 then
                sprite = cc.Sprite:create(config_res.images.ui.home.icon_gemstone)
            end
            sprite:setAnchorPoint(cc.p(0.5,0.5))
            sprite:setPosition(cc.p((Panel_predatory_res_icon:getContentSize().width/2 ), (Panel_predatory_res_icon:getContentSize().height) / 2))
            Panel_predatory_res_icon:addChild(sprite)
        end
        --铁
        local Text_predatory_res_n_1 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_1")
        Text_predatory_res_n_1:setString(exChangeNumToString(tonumber(_ED.world_map.investigate_info._rob_iron_count)))
        --油
        local Text_predatory_res_n_2 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_2")
        Text_predatory_res_n_2:setString(exChangeNumToString(tonumber(_ED.world_map.investigate_info._rob_oil_count)))
        --铝
        local Text_predatory_res_n_3 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_3")
        Text_predatory_res_n_3:setString(exChangeNumToString(tonumber(_ED.world_map.investigate_info._rob_lead_count)))
        --钛
        local Text_predatory_res_n_4 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_4")
        Text_predatory_res_n_4:setString(exChangeNumToString(tonumber(_ED.world_map.investigate_info._rob_titanium_count)))
        --宝石
        local Text_predatory_res_n_5 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_5")
        Text_predatory_res_n_5:setString(exChangeNumToString(tonumber(_ED.world_map.investigate_info._rob_store_count)))
        --所属
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        local name_info = ""
        local level_info = ""
        if _ED._help_defence_name ~= nil then
            name_info = _ED._help_defence_name
            level_info = _ED._help_defence_level
        else
            name_info = _ED.world_map.investigate_info._nickname
            level_info = _ED.world_map.investigate_info._level
        end
        local player_re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]),255, name_info.." LV."..level_info, config_res.font.font_name,22)
        _richText:pushBackElement(player_re2)
        if (_ED.world_map.investigate_info._union_name ~= nil or _ED.world_map.investigate_info._union_name~= "" )
          and #_ED.world_map.investigate_info._union_name > 1 then
            local player_re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, "[".._ED.world_map.investigate_info._union_name.."]", config_res.font.font_name,22)
            _richText:pushBackElement(player_re3)
        end
        _richText:setPosition(cc.p(-Text_spy_presentation_player:getContentSize().width/2,Text_spy_presentation_player:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_spy_presentation_player:getContentSize().width,Text_spy_presentation_player:getContentSize().height))
        _richText:setAnchorPoint(0,0.5)
        Text_spy_presentation_player:addChild(_richText)

        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            or _ED.union.union_info.union_name ~= _ED.world_map.investigate_info._union_name
            then
            self.is_union_member = false
        else
            self.is_union_member = true
        end
        local Button_spy_attack = ccui.Helper:seekWidgetByName(root,"Button_spy_attack")
        if self.is_union_member == false then
            Button_spy_attack:setTitleText(formation_type_string[13])
            Button_spy_attack:setVisible(true)
        else
            Button_spy_attack:setTitleText(formation_type_string[39])
            Button_spy_attack:setVisible(true)
        end

        Text_spy_base_n:setString(tipStringInfo_consumption_info[9])
        local info_s = zstring.split(_ED.world_map.investigate_info._formation_info, "!")
        local forceData = zstring.split(info_s[2], "|")
        for i=1,table.nums(forceData) do
            local forceInfo = zstring.split(forceData[i], ",")
            if tonumber(forceInfo[5]) > 0 then
                Text_spy_base_n:setString(tipStringInfo_consumption_info[8])
                break
            end
        end
        if _ED._help_defence_name ~= nil then
            Text_spy_base_n:setString(tipStringInfo_consumption_info[27])
            Text_spy_base_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
    end
end

-- 攻击叛军奖励
function redAlertTimeMineDetectResult:showAttackRebelReward()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 8))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self.m_Listview:addChild(root)

    local Text_rebel_haunt_reward_n = ccui.Helper:seekWidgetByName(root,"Text_rebel_haunt_reward_n")
    local Text_rebel_haunt_kill_reward_n = ccui.Helper:seekWidgetByName(root,"Text_rebel_haunt_kill_reward_n")
    Text_rebel_haunt_reward_n:setString(tipStringInfo_campaign_info[36])
    -- 攻击奖励
    local prop_info = zstring.split(dms.string(dms["rebel_haunt_mould"], _ED.world_map.investigate_info._rebel_mould_id, rebel_haunt_mould.reward), ",")
    local prop_id = tonumber(prop_info[1])
    local prop_name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
    local prop_quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local color = cc.c3b(tipStringInfo_quality_color_Type[prop_quality+1][1],tipStringInfo_quality_color_Type[prop_quality+1][2],tipStringInfo_quality_color_Type[prop_quality+1][3])
    local re1 =ccui.RichElementText:create(1, color, 255, prop_name, config_res.font.font_name,22)
    _richText:pushBackElement(re1)
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_campaign_info[35], config_res.font.font_name,22)
    _richText:pushBackElement(re2)
    _richText:setContentSize(cc.size(Text_rebel_haunt_kill_reward_n:getContentSize().width,Text_rebel_haunt_kill_reward_n:getContentSize().height))
    _richText:setAnchorPoint(0,0.5)
    _richText:setPosition(cc.p(-Text_rebel_haunt_kill_reward_n:getContentSize().width/2,Text_rebel_haunt_kill_reward_n:getContentSize().height/2))
    Text_rebel_haunt_kill_reward_n:addChild(_richText)
end

function redAlertTimeMineDetectResult:onInit()
    local csbredAlertTimeMineDetectResult = csb.createNode(config_csb.world_map.spy_presentation)
    local root = csbredAlertTimeMineDetectResult:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineDetectResult)
    
    
    self.m_Listview = ccui.Helper:seekWidgetByName(root,"ListView_spy_presentation")
    local have_defence = false
    -- if _ED._help_defence_name ~= nil then
    --     have_defence = true
    -- end

    local cell = WorldMineLineListCell:createCell()
    cell:init(0, nil, have_defence)
    self.m_Listview:addChild(cell)
    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_detect_result_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    
    --查找
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_lookup"), nil, 
    {
        terminal_name = "red_alert_time_mine_detect_result_location",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --进攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_attack"), nil, 
    {
        terminal_name = "red_alert_time_mine_detect_result_attack",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    --保存
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_save"), nil, 
    {
        terminal_name = "red_alert_time_mine_detect_result_save",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --删除
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_delete"), nil, 
    {
        terminal_name = "red_alert_time_mine_detect_result_delete",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
    self:onUpdateButton()
end

function redAlertTimeMineDetectResult:onExit()
    state_machine.remove("red_alert_time_mine_detect_result_location")
    state_machine.remove("red_alert_time_mine_detect_result_attack")
    state_machine.remove("red_alert_time_mine_detect_result_save")
    state_machine.remove("red_alert_time_mine_detect_result_delete")
end