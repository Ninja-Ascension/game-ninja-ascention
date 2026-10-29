-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军侦察详情
-------------------------------------------------------------------------------------------------------
MailRebelInvestigationInfo = class("MailRebelInvestigationInfoClass", Window)

local mail_rebel_investigation_info_open_terminal = {
    _name = "mail_rebel_investigation_info_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("MailRebelInvestigationInfoClass")
        if nil == _homeWindow then
            fwin:open(MailRebelInvestigationInfo:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local mail_rebel_investigation_info_close_terminal = {
    _name = "mail_rebel_investigation_info_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MailRebelInvestigationInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_rebel_investigation_info_open_terminal)
state_machine.add(mail_rebel_investigation_info_close_terminal)
state_machine.init()
    
function MailRebelInvestigationInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil
    self.m_Listview = nil
    self.isSave = false
    
    app.load("client.red_alert_time.cells.worldMap.world_mine_line_list_cell")

    local function init_mail_rebel_investigation_info_terminal()
        -- 定位
        local mail_rebel_investigation_info_location_terminal = {
            _name = "mail_rebel_investigation_info_location",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local attachedInfo = zstring.split(instance.m_object.param, "|")
                local attachedOne = zstring.split(attachedInfo[2], ",")
                state_machine.excute("mail_rebel_investigation_info_close", 0, 0)
                state_machine.excute("mail_window_close", 0, 0)
                state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
                state_machine.excute("adventure_mine_record_view_position", 0, {tonumber(attachedOne[5]),tonumber(attachedOne[6])})
                state_machine.excute("adventure_mine_update_view_position", 0, 0)
                
                protocol_command.world_map_arena_info_refresh.param_list = "" .. tonumber(attachedOne[5]) .. "\r\n" ..  tonumber(attachedOne[6])
                NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, instance, nil, false, nil)
                _ED.world_map_focus = {attachedOne[5], attachedOne[6]}
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 进攻
        local mail_rebel_investigation_info_attack_terminal = {
            _name = "mail_rebel_investigation_info_attack",
            _init = function (terminal)
                app.load("client.red_alert_time.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.m_object.info = {}
                instance.m_object.info._mould_id = instance.m_object.mail_params.Defensive_side.mine_mould_id
                instance.m_object.info._x = instance.m_object.mail_params.Defensive_side.attack_print_x
                instance.m_object.info._y = instance.m_object.mail_params.Defensive_side.attack_print_y
                state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance.m_object.info ,playersOrmine = 0}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 删除
        local mail_rebel_investigation_info_delete_terminal = {
            _name = "mail_rebel_investigation_info_delete",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance.mType) ~= 10 then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                --清除
                                for i, v in pairs(_ED.city_resource_battle_report[tonumber(instance.m_object.nType)]) do
                                    if tonumber(v.time) == tonumber(instance.m_object.time) then
                                        _ED.city_resource_battle_report[tonumber(instance.m_object.nType)][i] = nil
                                    end
                                end
                                state_machine.excute("mail_presentation_investigation_update_all",0,0)
                                state_machine.excute("mail_rebel_investigation_info_close",0,0)
                            end
                        end 
                    end
                    protocol_command.delete_message.param_list = instance.m_object.nType.."\r\n"..instance.m_object.time
                    NetworkManager:register(protocol_command.delete_message.code, nil, nil, nil, instance, responseCallback, false, nil)
                else
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                --清除
                                for i, v in pairs(_ED.city_resource_battle_save_report) do
                                    if tonumber(v.time) == tonumber(instance.m_object.time) then
                                        _ED.city_resource_battle_save_report[i] = nil
                                    end
                                end
                                state_machine.excute("mail_save_the_box_update_draw",0,0)
                                state_machine.excute("mail_rebel_investigation_info_close",0,0)
                            end
                        end
                    end
                    protocol_command.battlefield_report_save_delete.param_list = instance.m_object.time
                    NetworkManager:register(protocol_command.battlefield_report_save_delete.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --保存
        local mail_rebel_investigation_info_save_terminal = {
            _name = "mail_rebel_investigation_info_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if instance.isSave == false then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                TipDlg.drawTextDailog(mail_tip_text[15])
                                response.node:onUpdateButton()
                            end
                        end
                    end
                    protocol_command.battlefield_report_save.param_list = instance.m_object.nType.."\r\n"..instance.m_object.time
                    NetworkManager:register(protocol_command.battlefield_report_save.code, nil, nil, nil, instance, responseCallback, false, nil)
                else
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                --清除
                                for i, v in pairs(_ED.city_resource_battle_save_report) do
                                    if tonumber(v.time) == tonumber(response.node.m_object.time) then
                                        _ED.city_resource_battle_save_report[i] = nil
                                    end
                                end
                                response.node:onUpdateButton()
                                TipDlg.drawTextDailog(mail_tip_text[26])
                            end
                        end
                    end
                    protocol_command.battlefield_report_save_delete.param_list = instance.m_object.time
                    NetworkManager:register(protocol_command.battlefield_report_save_delete.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(mail_rebel_investigation_info_location_terminal)
        state_machine.add(mail_rebel_investigation_info_attack_terminal)
        state_machine.add(mail_rebel_investigation_info_save_terminal)
        state_machine.add(mail_rebel_investigation_info_delete_terminal)
    
        state_machine.init()
    end
    
    init_mail_rebel_investigation_info_terminal()
end

function MailRebelInvestigationInfo:init(params)
    self.m_object = params[1]
    self.mType = params[3] or nil
    self:onInit()
    return self
end

function MailRebelInvestigationInfo:getTimeFormatYMDHMS( m_time )
    local temp = os.date("*t",getBaseGTM8Time(m_time))
    local m_month   = string.format("%02d", temp.month)
    local m_day     = string.format("%02d", temp.day)
    local m_hour    = string.format("%02d", temp.hour)
    local m_min     = string.format("%02d", temp.min)
    local m_sec     = string.format("%02d", temp.sec)
    local timeString = temp.year ..".".. m_month ..".".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec
    return timeString
end

function MailRebelInvestigationInfo:onUpdateButton()
    local root = self.roots[1]
    self.isSave = false
    local Button_spy_presentation_save = ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_save")
    if _ED.city_resource_battle_save_report == nil or #_ED.city_resource_battle_save_report <= 1 then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                for i,v in pairs(_ED.city_resource_battle_save_report) do
                    if tonumber(v.time) == tonumber(self.m_object.time) and tonumber(v.nType) == tonumber(self.m_object.nType) then
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
        NetworkManager:register(protocol_command.battlefield_report_save_get.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        for i,v in pairs(_ED.city_resource_battle_save_report) do
            if tonumber(v.time) == tonumber(self.m_object.time) and tonumber(v.nType) == tonumber(self.m_object.nType) then
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

function MailRebelInvestigationInfo:onUpdateDraw()
    local root = self.roots[1]
    local Text_spy_t_n = ccui.Helper:seekWidgetByName(root,"Text_spy_t_n")--侦察了谁
    local Text_spy_base = ccui.Helper:seekWidgetByName(root,"Text_spy_base")--侦察了什么
    local Text_predatory_n = ccui.Helper:seekWidgetByName(root,"Text_predatory_n")--可以被掠夺多少
    local Text_spy_presentation_player = ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_player")--所有者
    local Text_spy_base_n = ccui.Helper:seekWidgetByName(root,"Text_spy_base_n")--有无驻军
    local Text_spy_base_time = ccui.Helper:seekWidgetByName(root,"Text_spy_base_time")--时间
    Text_spy_base_time:setString(self:getTimeFormatYMDHMS(tonumber(self.m_object.time)/1000))
    local attachedInfo = zstring.split(self.m_object.param, "|")
    local attachedOne = zstring.split(attachedInfo[2], ",")
    local _richText1 = ccui.RichText:create()
    _richText1:ignoreContentAdaptWithSize(false)
    local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])

    local textinfo = zstring.split(mail_tip_text[13], "!x@")
    Text_spy_base:setString(mail_tip_text[29]..tipStringInfo_consumption_info[8]) 
    local re2 = ccui.RichElementText:create(1, color2,255, attachedOne[1].." "..friends_tip_string[12]..attachedOne[3]..string.format(mail_tip_text[10], attachedOne[5], attachedOne[6]), config_res.font.font_name,20)
    local re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
    local re4 = ccui.RichElementText:create(1, color2,255, textinfo[3], config_res.font.font_name,20)
    _richText1:pushBackElement(re2)
    _richText1:pushBackElement(re3)
    _richText1:pushBackElement(re4)
    _richText1:setContentSize(cc.size(Text_spy_t_n:getContentSize().width,Text_spy_t_n:getContentSize().height))
    _richText1:setAnchorPoint(0,0.5)
    _richText1:setPosition(cc.p(-Text_spy_t_n:getContentSize().width/2,Text_spy_t_n:getContentSize().height/2))
    Text_spy_t_n:addChild(_richText1)

    self:updateRewardInfo()
end

function MailRebelInvestigationInfo:updateRewardInfo( ... )
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 8))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self.m_Listview:addChild(root)

    local Text_rebel_haunt_reward_n = ccui.Helper:seekWidgetByName(root,"Text_rebel_haunt_reward_n")
    local Text_rebel_haunt_kill_reward_n = ccui.Helper:seekWidgetByName(root,"Text_rebel_haunt_kill_reward_n")
    Text_rebel_haunt_reward_n:setString(tipStringInfo_campaign_info[36])
    local attachedInfo = zstring.split(self.m_object.param, "|")
    local attachedTwo = zstring.split(attachedInfo[3], ",")
    -- 攻击奖励
    local prop_info = zstring.split(dms.string(dms["rebel_haunt_mould"], attachedTwo[4], rebel_haunt_mould.reward), ",")
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

function MailRebelInvestigationInfo:onInit()
    local csbMailInvestigationInfo = csb.createNode(config_csb.world_map.spy_presentation)
    local root = csbMailInvestigationInfo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbMailInvestigationInfo)
    
    self.m_Listview = ccui.Helper:seekWidgetByName(root,"ListView_spy_presentation")
    self.m_Listview:removeAllItems()
    self.m_Listview:jumpToTop()
    
    local cell = WorldMineLineListCell:createCell()
    cell:init(tonumber(self.m_object.nType),self.m_object,false)
    self.m_Listview:addChild(cell)
    self.m_Listview:setBounceBottomBoundary(0)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_close"), nil, 
    {
        terminal_name = "mail_rebel_investigation_info_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    
    --查找
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_lookup"), nil, 
    {
        terminal_name = "mail_rebel_investigation_info_location",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --进攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_attack"), nil, 
    {
        terminal_name = "mail_rebel_investigation_info_attack",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --保存
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_save"), nil, 
    {
        terminal_name = "mail_rebel_investigation_info_save",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    --删除
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_delete"), nil, 
    {
        terminal_name = "mail_rebel_investigation_info_delete",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    if tonumber(self.mType) == 10 then
        ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_save"):setVisible(false)
    end
    
    self:onUpdateDraw()
    self:onUpdateButton()
end

function MailRebelInvestigationInfo:onExit()
    state_machine.remove("mail_rebel_investigation_info_location")
    state_machine.remove("mail_rebel_investigation_info_attack")
    state_machine.remove("mail_rebel_investigation_info_save")
    state_machine.remove("mail_rebel_investigation_info_delete")
end