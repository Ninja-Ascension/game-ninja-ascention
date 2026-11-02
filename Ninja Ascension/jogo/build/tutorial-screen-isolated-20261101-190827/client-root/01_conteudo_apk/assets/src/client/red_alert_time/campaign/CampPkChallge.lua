--------------------------------------------------------------------------------------------------------------
--  说明：阵营对决-挑战
--------------------------------------------------------------------------------------------------------------
CampPkChallge = class("CampPkChallgeClass", Window)

--打开界面
local camp_pk_challge_open_terminal = {
    _name = "camp_pk_challge_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = CampPkChallge:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(camp_pk_challge_open_terminal)
state_machine.init()

function CampPkChallge:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._tick_time = 0
    self._Text_camp_pk_sign_up_time_n = nil

    self._reconnect_count = 0
    self._reconnect_time = 0

    local function init_camp_pk_challge_terminal()
        local camp_pk_challge_show_terminal = {
            _name = "camp_pk_challge_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_challge_hide_terminal = {
            _name = "camp_pk_challge_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_challge_join_terminal = {
            _name = "camp_pk_challge_join",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(_ED.camp_pk_info.state) ~= 1 then
                    TipDlg.drawTextDailog(red_alert_campaign_pk_str[4])
                    return
                end
                state_machine.excute("formation_window_open", 0, {_datas = {form_type = 15}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_challge_open_rule_terminal = {
            _name = "camp_pk_challge_open_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,122)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_challge_enter_battle_terminal = {
            _name = "camp_pk_challge_enter_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(_ED.camp_pk_info.state) == 0 
                    or zstring.tonumber(_ED.camp_pk_info.state) == 1
                    then
                    TipDlg.drawTextDailog(red_alert_campaign_pk_str[5])
                    return
                end
                if zstring.tonumber(_ED.camp_pk_user_info.state) == 0 then
                    TipDlg.drawTextDailog(red_alert_campaign_pk_str[6])
                    return
                end
                state_machine.excute("camp_pk_battle_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_challge_update_info_terminal = {
            _name = "camp_pk_challge_update_info",
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

        local camp_pk_challge_change_state_request_terminal = {
            _name = "camp_pk_challge_change_state_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                    end
                end
                protocol_command.camp_duel_init.param_list = ""
                NetworkManager:register(protocol_command.camp_duel_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_challge_show_terminal)
        state_machine.add(camp_pk_challge_hide_terminal)
        state_machine.add(camp_pk_challge_join_terminal)
        state_machine.add(camp_pk_challge_open_rule_terminal)
        state_machine.add(camp_pk_challge_enter_battle_terminal)
        state_machine.add(camp_pk_challge_update_info_terminal)
        state_machine.add(camp_pk_challge_change_state_request_terminal)
        state_machine.init()
    end
    
    init_camp_pk_challge_terminal()
end

function CampPkChallge:updateDraw()
    local root = self.roots[1]
    local Text_camp_pk_sign_up = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_sign_up")
    local Text_camp_pk_sign_up_people_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_sign_up_people_n")
    local Text_camp_pk_sign_up_time_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_sign_up_time_n")
    local Text_camp_pk_sign_up_people = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_sign_up_people")
    local Text_camp_pk_sign_up_time = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_sign_up_time")
    local Panel_camp_pk_settlement_1 = ccui.Helper:seekWidgetByName(root, "Panel_camp_pk_settlement_1")
    local Panel_camp_pk_settlement_2 = ccui.Helper:seekWidgetByName(root, "Panel_camp_pk_settlement_2")
    local Text_camp_pk_player_state_1 = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_player_state_1")
    local Text_camp_pk_player_state_2 = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_player_state_2")
    local Button_camp_pk_sign_up = ccui.Helper:seekWidgetByName(root, "Button_camp_pk_sign_up")
    local Button_camp_pk_in_battle = ccui.Helper:seekWidgetByName(root, "Button_camp_pk_in_battle")
    local Button_text_camp_pk_sign_up = ccui.Helper:seekWidgetByName(root, "Button_text_camp_pk_sign_up")
    Button_camp_pk_sign_up:setBright(true)
    Button_camp_pk_in_battle:setBright(true)
    Button_camp_pk_in_battle:setTouchEnabled(true)
    Text_camp_pk_sign_up:setString("")
    Text_camp_pk_sign_up:removeAllChildren(true)
    Text_camp_pk_sign_up_people_n:setString("")
    Text_camp_pk_sign_up_time_n:setString("")
    Text_camp_pk_player_state_1:setString("")
    Text_camp_pk_player_state_2:setString("")
    Text_camp_pk_sign_up_time:setString("")
    Panel_camp_pk_settlement_1:removeBackGroundImage()
    Panel_camp_pk_settlement_2:removeBackGroundImage()
    Text_camp_pk_sign_up_people_n:setString(_ED.camp_pk_info.join_number)
    self._tick_time = 0
    self._Text_camp_pk_sign_up_time_n = Text_camp_pk_sign_up_time_n
    if tonumber(_ED.camp_pk_info.win_info) == 0 then
        Panel_camp_pk_settlement_1:setBackGroundImage("images/ui/combat/camp_pk_vs_text_1.png")
        Panel_camp_pk_settlement_2:setBackGroundImage("images/ui/combat/camp_pk_vs_text_2.png")
    elseif tonumber(_ED.camp_pk_info.win_info) == 1 then
        Panel_camp_pk_settlement_1:setBackGroundImage("images/ui/combat/camp_pk_vs_text_2.png")
        Panel_camp_pk_settlement_2:setBackGroundImage("images/ui/combat/camp_pk_vs_text_1.png")
    end
    if tonumber(_ED.camp_pk_user_info.camp_state) == 0 then
        Text_camp_pk_player_state_1:setString(red_alert_campaign_pk_str[19])
        Text_camp_pk_player_state_2:setString(red_alert_campaign_pk_str[18])
    elseif tonumber(_ED.camp_pk_user_info.camp_state) == 1 then
        Text_camp_pk_player_state_1:setString(red_alert_campaign_pk_str[18])
        Text_camp_pk_player_state_2:setString(red_alert_campaign_pk_str[19])
    end
    local fontSize = Text_camp_pk_sign_up:getFontSize()
    if tonumber(_ED.camp_pk_info.state) == 0 then
        Button_camp_pk_sign_up:setBright(false)
        Button_camp_pk_in_battle:setBright(false)
        if Button_text_camp_pk_sign_up ~= nil then
            Button_camp_pk_sign_up:setTitleText(tipStringInfo_campaign_info[28])
        end
        if tonumber(_ED.camp_pk_info.win_info) == -1 then
            Text_camp_pk_sign_up:setString(red_alert_campaign_pk_str[5])
            Button_camp_pk_sign_up:setTitleText(formation_type_string[49])
        else
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false) 
            local color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
            local re1 = ccui.RichElementText:create(1, color, 255, red_alert_campaign_pk_str[12]..",", "fonts/simhei.ttf", fontSize)
            _richText:pushBackElement(re1)
            if tonumber(_ED.camp_pk_info.win_info) == 0 then
                color = cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3])
                local re1 = ccui.RichElementText:create(1, color, 255, red_alert_campaign_pk_str[9], "fonts/simhei.ttf", fontSize)
                _richText:pushBackElement(re1)
            else
                color = cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])
                local re1 = ccui.RichElementText:create(1, color, 255, red_alert_campaign_pk_str[10], "fonts/simhei.ttf", fontSize)
                _richText:pushBackElement(re1)
            end
            color = cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3])
            local re13 = ccui.RichElementText:create(1, color, 255, red_alert_campaign_pk_str[13], "fonts/simhei.ttf", fontSize)
            _richText:pushBackElement(re13)
            _richText:setContentSize(cc.size(400, 55))
            _richText:setPosition(cc.p(60,0))
            Text_camp_pk_sign_up:addChild(_richText)
        end
    elseif _ED.camp_pk_info.state == 1 then
        Text_camp_pk_sign_up:setString(red_alert_campaign_pk_str[14])
        Text_camp_pk_sign_up_time:setString(red_alert_campaign_pk_str[15])
        self._tick_time = _ED.camp_pk_info.end_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        Text_camp_pk_sign_up_time_n:setString(exChangeNumTimeString(self._tick_time, 2))
        Button_camp_pk_in_battle:setBright(false)
        if tonumber(_ED.camp_pk_user_info.state) == 0 then
            Button_camp_pk_sign_up:setTitleText(formation_type_string[49])
        else
            Button_camp_pk_sign_up:setTitleText(tipStringInfo_campaign_info[28])
        end
    elseif _ED.camp_pk_info.state == 2 then
        Text_camp_pk_sign_up:setString(red_alert_campaign_pk_str[16])
        self._tick_time = _ED.camp_pk_info.end_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        Text_camp_pk_sign_up_time_n:setString(exChangeNumTimeString(self._tick_time, 3))
        Text_camp_pk_sign_up_time:setString(red_alert_campaign_pk_str[17])
        Button_camp_pk_sign_up:setBright(false)
        if tonumber(_ED.camp_pk_user_info.state) == 0 then
            Button_camp_pk_sign_up:setTitleText(formation_type_string[49])
        else
            Button_camp_pk_sign_up:setTitleText(tipStringInfo_campaign_info[28])
        end
    else
        Button_camp_pk_sign_up:setBright(false)
        if tonumber(_ED.camp_pk_user_info.state) == 0 then
            Button_camp_pk_sign_up:setTitleText(formation_type_string[49])
        else
            Button_camp_pk_sign_up:setTitleText(tipStringInfo_campaign_info[28])
        end
        Text_camp_pk_sign_up:setString(red_alert_campaign_pk_str[20])
        Text_camp_pk_sign_up_time:setString("")
        self._tick_time = 0--_ED.camp_pk_info.end_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        Text_camp_pk_sign_up_time_n:setString(exChangeNumTimeString(self._tick_time, 2))
    end
    if Button_text_camp_pk_sign_up ~= nil then
        Button_text_camp_pk_sign_up:setString(Button_camp_pk_sign_up:getTitleText())
        Button_camp_pk_sign_up:setTitleText("")
    end

    self._reconnect_count = 0
    self._reconnect_time = 0
end

function CampPkChallge:onUpdate( dt )
    -- self._tick_time = self._tick_time - dt
    self._tick_time = _ED.camp_pk_info.end_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
    if self._tick_time <= 0 then
        self._Text_camp_pk_sign_up_time_n:setString("")
        if self._tick_time <= -1 and (_ED.camp_pk_info.state == 1 or _ED.camp_pk_info.state == 2) then
            if self._reconnect_count <= 2 then
                if self._reconnect_time <= 0 then
                    self._reconnect_count = self._reconnect_count + 1
                    self._reconnect_time = 3
                    state_machine.excute("camp_pk_challge_change_state_request", 0, "")
                else
                    self._reconnect_time = self._reconnect_time - dt
                end
            end
        end
    else
        if _ED.camp_pk_info.state == 1 or _ED.camp_pk_info.state == 2 then
            self._Text_camp_pk_sign_up_time_n:setString(exChangeNumTimeString(self._tick_time, 2))
        end
    end
end

--初始化
function CampPkChallge:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.camp_pk_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_pk_infor"), nil, 
    {
        terminal_name = "camp_pk_challge_open_rule", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_pk_sign_up"), nil, 
    {
        terminal_name = "camp_pk_challge_join", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_pk_in_battle"), nil, 
    {
        terminal_name = "camp_pk_challge_enter_battle", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:updateDraw()
end

function CampPkChallge:onEnterTransitionFinish()

end

function CampPkChallge:init(param)
    self._rootWindows = param[1]
    self:onInit()
    return self
end

function CampPkChallge:onExit()
    state_machine.remove("camp_pk_challge_show")
    state_machine.remove("camp_pk_challge_hide")
    state_machine.remove("camp_pk_challge_join")
    state_machine.remove("camp_pk_challge_open_rule")
    state_machine.remove("camp_pk_challge_enter_battle")
    state_machine.remove("camp_pk_challge_update_info")
    state_machine.remove("camp_pk_challge_change_state_request")
end