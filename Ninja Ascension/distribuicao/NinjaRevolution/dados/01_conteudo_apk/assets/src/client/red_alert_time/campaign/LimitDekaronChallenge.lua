-- ------------------------------------------------------------------------------------------------------------
--  说明：极限挑战挑战
-- ------------------------------------------------------------------------------------------------------------
LimitDekaronChallenge = class("LimitDekaronChallengeClass", Window)

--打开界面
local limit_dekaron_challenge_open_terminal = {
    _name = "limit_dekaron_challenge_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LimitDekaronChallenge:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(limit_dekaron_challenge_open_terminal)
state_machine.init()

function LimitDekaronChallenge:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._last_npc_count = 0
    self._last_star_count = 0

    self._is_quick_battle = false   -- 快速激战

    app.load("client.red_alert_time.legion.LegionPKAttack")
    local function init_limit_dekaron_challenge_terminal()
        local limit_dekaron_challenge_show_terminal = {
            _name = "limit_dekaron_challenge_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local limit_dekaron_challenge_hide_terminal = {
            _name = "limit_dekaron_challenge_hide",
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
        
        local limit_dekaron_challenge_update_draw_terminal = {
            _name = "limit_dekaron_challenge_update_draw",
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

        local limit_dekaron_challenge_battle_rule_terminal = {
            _name = "limit_dekaron_challenge_battle_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,62)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local limit_dekaron_challenge_enter_battle_terminal = {
            _name = "limit_dekaron_challenge_enter_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isHaveSetFormation = false
                local formation_tabs = zstring.split(_ED.user_extreme_info.formation_info, "|")
                for k, v in pairs(formation_tabs) do
                    local info_tabs = zstring.split(v, ",")
                    if tonumber(info_tabs[1]) > 0 then
                        isHaveSetFormation = true
                        break
                    end
                end

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                if isHaveSetFormation == true then
                    NetworkManager:register(protocol_command.extreme_start.code, nil, nil, nil, instance, responseCallback, false, nil)
                else
                    TipDlg.drawTextDailog(formation_type_string[14])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local limit_dekaron_challenge_quick_battle_terminal = {
            _name = "limit_dekaron_challenge_quick_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.user_extreme_info.quick_battle == 1 then
                    instance._is_quick_battle = true
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                if fwin:find("FightClass") == nil then
                                    response.node:onUpdateDraw()
                                end
                                response.node._is_quick_battle = false
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.extreme_fast_battle.code, nil, nil, nil, instance, responseCallback, false, nil)
                else
                    instance._is_quick_battle = false
                    state_machine.excute("limit_dekarona_cell_dekaron", 0, {_datas = {index = 1}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local limit_dekaron_challenge_open_rule_terminal = {
            _name = "limit_dekaron_challenge_open_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,6)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(limit_dekaron_challenge_show_terminal)
        state_machine.add(limit_dekaron_challenge_hide_terminal)
        state_machine.add(limit_dekaron_challenge_update_draw_terminal)
        state_machine.add(limit_dekaron_challenge_battle_rule_terminal)
        state_machine.add(limit_dekaron_challenge_enter_battle_terminal)
        state_machine.add(limit_dekaron_challenge_quick_battle_terminal)
        state_machine.add(limit_dekaron_challenge_open_rule_terminal)
        state_machine.init()
    end
    init_limit_dekaron_challenge_terminal()
end

function LimitDekaronChallenge:onUpdateDraw()
    local root = self.roots[1]
    local attack_times = dms.int(dms["limit_challenge_config"],2,limit_challenge_config.param)
    local Panel_limit_dekaron_three = ccui.Helper:seekWidgetByName(root, "Panel_limit_dekaron_three")
    local Button_limit_dekaron_begin = ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_begin")
    local Text_limit_dekaron_best_infor = ccui.Helper:seekWidgetByName(root, "Text_limit_dekaron_best_infor")
    local Text_limit_dekaron_prompt = ccui.Helper:seekWidgetByName(root, "Text_limit_dekaron_prompt")
    local Text_limit_dekaron_infor = ccui.Helper:seekWidgetByName(root, "Text_limit_dekaron_infor")
    local Text_limit_dekaron_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_limit_dekaron_attribute_n")
    local Text_limit_dekaron_attribute_t = ccui.Helper:seekWidgetByName(root, "Text_limit_dekaron_attribute_t")
    local Button_limit_dekaron_help_infor = ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_help_infor")
    local Button_limit_dekaron_attack = ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_attack")
    Panel_limit_dekaron_three:removeAllChildren(true)
    Text_limit_dekaron_infor:removeAllChildren(true)
    Text_limit_dekaron_attribute_n:removeAllChildren(true)
    Text_limit_dekaron_prompt:setVisible(false)
    Text_limit_dekaron_best_infor:setString("")
    Text_limit_dekaron_best_infor:removeAllChildren(true)
    Text_limit_dekaron_attribute_t:setVisible(false)
    Button_limit_dekaron_attack:setVisible(false)
    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, _ED.user_extreme_info.best_npc_count, "fonts/simhei.ttf",20)
    _richText_2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[140], "fonts/simhei.ttf",20)
    _richText_2:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, _ED.user_extreme_info.best_star_count, "fonts/simhei.ttf",20)
    _richText_2:pushBackElement(re3)
    local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[139], "fonts/simhei.ttf",20)
    _richText_2:pushBackElement(re4)
    _richText_2:setPosition(cc.p(Text_limit_dekaron_best_infor:getContentSize().width/2,Text_limit_dekaron_best_infor:getContentSize().height/2))
    _richText_2:setContentSize(cc.size(Text_limit_dekaron_best_infor:getContentSize().width,20))
    Text_limit_dekaron_best_infor:addChild(_richText_2)

    local describe_1 = ""
    local describe_2 = ""
    local describe_3 = ""
    local describe_4 = ""
    local describe_5 = ""
    local describe_6 = ""
    local describe_7 = ""
    local quality_2 = 0
    if _ED.user_extreme_info.current_npc_count == 0 then
        if self._last_npc_count > 0 then
            state_machine.excute("limit_dekaron_settlement_reward_window_open", 0, {_ED.user_extreme_reward_info, self._last_npc_count - 1, self._last_star_count})
        end
        self._last_npc_count = 0
        self._last_star_count = 0
        _ED.user_extreme_reward_info = nil
        Button_limit_dekaron_begin:setVisible(true)
        Button_limit_dekaron_help_infor:setVisible(true)
        describe_1 = limit_dekaron_tip_daily[6]
        describe_2 = attack_times - _ED.user_extreme_info.reset_times
        describe_3 = "/"..attack_times
        quality_2 = 2
    else
        if self._last_npc_count == 0 then
            local action = self.actions[1]
            action:play("limit_dekaron_begion", false)
        end
        if self._is_quick_battle == false then
            if _ED.user_extreme_info.current_npc_count > 1 and self._last_npc_count < _ED.user_extreme_info.current_npc_count then
                TipDlg.drawTextDailog(string.format(red_alert_time_str[254], _ED.user_extreme_info.current_npc_count - 1, _ED.user_extreme_info.current_star_count - self._last_star_count))
            end
        else
            if _ED.user_extreme_info.quick_battle == 1 then         -- 快速激战成功
                TipDlg.drawTextDailog(string.format(limit_dekaron_tip_daily[14], _ED.user_extreme_info.current_npc_count - self._last_npc_count, _ED.user_extreme_info.current_star_count - self._last_star_count))
            else
                TipDlg.drawTextDailog(string.format(limit_dekaron_tip_daily[15], _ED.user_extreme_info.current_npc_count - self._last_npc_count, _ED.user_extreme_info.current_star_count - self._last_star_count))
            end
        end
        self._last_npc_count = _ED.user_extreme_info.current_npc_count
        self._last_star_count = _ED.user_extreme_info.current_star_count
        describe_1 = red_alert_time_str[136]
        describe_2 = _ED.user_extreme_info.current_npc_count - 1
        describe_3 = red_alert_time_str[137]
        describe_4 = _ED.user_extreme_info.current_star_count
        describe_5 = red_alert_time_str[138]
        describe_6 = _ED.user_extreme_info.surplus_star_count
        describe_7 = red_alert_time_str[139]
        quality_2 = 7
        Button_limit_dekaron_begin:setVisible(false)
        Button_limit_dekaron_help_infor:setVisible(false)
        Text_limit_dekaron_prompt:setVisible(true)
        local buff_info = zstring.split(_ED.user_extreme_info.buy_buff_info, ",")
        local isShowBuff = false
        local isShowAttack = false      -- 是否显示激战
        for k,v in pairs(buff_info) do
            if tonumber(v) > 0 then
                isShowBuff = true
            end
        end
        local cell = nil
        if isShowBuff == true then
            cell = state_machine.excute("limit_dekarona_buff_create_cell", 0, {buff_info})
            Text_limit_dekaron_prompt:setString(tipStringInfo_campaign_info[41])
            isShowAttack = false
        else
            Text_limit_dekaron_prompt:setString(tipStringInfo_campaign_info[40])
            checkPlayEffect(64)
            if _ED.user_extreme_info.challge_count == 1 then
                cell = state_machine.excute("limit_dekarona_boss_create_cell",0,{})
                isShowAttack = false
            else
                cell = state_machine.excute("limit_dekarona_create_cell",0,{})
                isShowAttack = true
            end
        end
        Panel_limit_dekaron_three:addChild(cell)

        Button_limit_dekaron_attack:setVisible(isShowAttack)
        if _ED.user_extreme_info.quick_battle == 1 then
            Button_limit_dekaron_attack:setTitleText(tipStringInfo_campaign_info[62])
        else
            Button_limit_dekaron_attack:setTitleText(tipStringInfo_campaign_info[61])
        end
    end

    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, describe_1, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_2][1],color_Type[quality_2][2],color_Type[quality_2][3]),255, describe_2, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, describe_3, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re3)
    local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, describe_4, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re4)
    local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, describe_5, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re5)
    local re6 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, describe_6, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re6)
    local re7 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, describe_7, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re7)
    _richText_1:setPosition(cc.p(Text_limit_dekaron_infor:getContentSize().width/2,Text_limit_dekaron_infor:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_limit_dekaron_infor:getContentSize().width,22))
    Text_limit_dekaron_infor:addChild(_richText_1)

    local add_buff_info = zstring.split(_ED.user_extreme_info.add_buff_info, "|")
    local count = 0
    for k,v in pairs(add_buff_info) do
        local attributes_info = zstring.split(v, ",")
        if tonumber(attributes_info[1]) >= 0 then
            count = count + 1
        end
    end
    local _richText_3 = ccui.RichText:create()
    _richText_3:ignoreContentAdaptWithSize(false)   
    for k,v in pairs(add_buff_info) do
        local re1 = nil 
        local re2 = nil
        local re3 = nil
        local attributes_info = zstring.split(v, ",")
        if tonumber(attributes_info[1]) >= 0 then
            Text_limit_dekaron_attribute_t:setVisible(true)
            re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_attribute[tonumber(attributes_info[1]) + 1].."+", "fonts/simhei.ttf",22)
            _richText_3:pushBackElement(re1) 
            re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, tonumber(attributes_info[2]),"fonts/simhei.ttf",22)
            _richText_3:pushBackElement(re2) 
            local dec = ""
            local is_handred = false
            for i,n in pairs(attribute_hundred) do
                if tonumber(attributes_info[1]) == n then
                    is_handred = true
                end
            end
            if is_handred == true then
                dec = dec .. "%"
            end
            if k ~= count then
                dec = dec .. ","
            end
            re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,dec,"fonts/simhei.ttf",22)
            _richText_3:pushBackElement(re3)
        end
    end
    _richText_3:setPosition(cc.p(Text_limit_dekaron_attribute_n:getContentSize().width/2,Text_limit_dekaron_attribute_n:getContentSize().height/2))
    _richText_3:setContentSize(cc.size(Text_limit_dekaron_attribute_n:getContentSize().width,22))
    Text_limit_dekaron_attribute_n:addChild(_richText_3)
end

function LimitDekaronChallenge:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.limit_dekarona_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(string.format(config_csb.campaign.limit_dekarona_tab, 1))
    table.insert(self.actions, action)
    root:runAction(action)

    self._last_npc_count = _ED.user_extreme_info.current_npc_count
    self._last_star_count = _ED.user_extreme_info.current_star_count
    if self._last_npc_count > 0 then
        action:play("limit_dekaron_begion", false)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_battle_rule"), nil, 
    {
        terminal_name = "limit_dekaron_challenge_battle_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_set_troops"), nil, 
    {
        terminal_name = "formation_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        form_type = 9,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_begin"), nil, 
    {
        terminal_name = "limit_dekaron_challenge_enter_battle", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_attack"), nil, 
    {
        terminal_name = "limit_dekaron_challenge_quick_battle", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_help_infor"), nil, 
    {
        terminal_name = "limit_dekaron_challenge_open_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
    
    self:onUpdateDraw()
end

function LimitDekaronChallenge:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LimitDekaronChallenge:onExit()
    state_machine.remove("limit_dekaron_challenge_show")
    state_machine.remove("limit_dekaron_challenge_hide")
    state_machine.remove("limit_dekaron_challenge_update_draw")
    state_machine.remove("limit_dekaron_challenge_battle_rule")
    state_machine.remove("limit_dekaron_challenge_enter_battle")
    state_machine.remove("limit_dekaron_challenge_quick_battle")
    state_machine.remove("limit_dekaron_challenge_open_rule")
end