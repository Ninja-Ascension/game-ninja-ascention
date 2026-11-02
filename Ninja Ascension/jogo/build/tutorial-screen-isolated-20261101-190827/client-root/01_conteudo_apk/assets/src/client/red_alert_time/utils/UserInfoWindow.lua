-----------------------------
--用户信息
-----------------------------
UserInfoWindow = class("UserInfoWindowClass", Window)

local user_info_window_open_terminal = {
    _name = "user_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UserInfoWindowClass"))
        if nil == fwin:find("UserInfoWindowClass") then
            local user_id = params._datas.user_id
            local server_link = params._datas.server_link
            local show_chat = params._datas.show_chat
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(UserInfoWindow:new():init(server_link, show_chat), fwin._windows)
                end
            end
            protocol_command.get_other_user_info.param_list = user_id
            NetworkManager:register(protocol_command.get_other_user_info.code, server_link, nil, nil, nil, responseCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local user_info_window_close_terminal = {
    _name = "user_info_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UserInfoWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(user_info_window_open_terminal)
state_machine.add(user_info_window_close_terminal)
state_machine.init()

function UserInfoWindow:ctor()
    self.super:ctor()
    self.roots = {}

    self._user_data = nil           -- 玩家数据信息
    self._server_link = nil         -- 玩家服务器地址
    self._show_chat = nil           -- 是否显示私聊按钮
    
    --load lua file
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroMain")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroAttributes")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroFetters")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroMainGrowUp")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroMainSkillsUp")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroMainStarUp")
    app.load("client.red_alert_time.other_players_information.other_players_equipstorage.OtherPlayersEquipment")
    app.load("client.red_alert_time.other_players_information.other_players_equipstorage.other_players_equipment_gem_input_cell")
    app.load("client.red_alert_time.other_players_information.other_players_racecourse.OtherPlayersRacecourseRide")
    app.load("client.red_alert_time.other_players_information.other_players_god_weaponry.OtherPlayersGodWeaponry")
    -- Initialize user_info_window state machine.
    local function init_user_info_window_terminal()
        --显示界面
        local user_info_window_show_terminal = {
            _name = "user_info_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --隐藏界面
        local user_info_window_hide_terminal = {
            _name = "user_info_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --英雄
        local user_info_window_look_play_hero_info_terminal = {
            _name = "user_info_window_look_play_hero_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("other_players_hero_main_window_open",0,nil) 
                        end
                    end
                end
                _ED.other_user_ship = {}
                _ED.other_user_equiment = {}
                _ED.other_user_gems = {}
                _ED.other_horses = {}
                _ED.other_horse_spirits = {}
                protocol_command.get_other_user_ship_info.param_list = instance._user_data.user_id
                NetworkManager:register(protocol_command.get_other_user_ship_info.code, instance._server_link, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --装备
        local user_info_window_look_play_equip_info_terminal = {
            _name = "user_info_window_look_play_equip_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("other_players_equipment_window_open",0,"") 
                    end
                end
                _ED.other_user_equiment = {}
                _ED.other_user_ship = {}
                _ED.other_user_gems = {}
                _ED.other_horses = {}
                _ED.other_horse_spirits = {}
                protocol_command.get_other_user_equip_info.param_list = instance._user_data.user_id
                NetworkManager:register(protocol_command.get_other_user_equip_info.code, instance._server_link, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 珍兽
        local user_info_window_look_play_racecourse_info_terminal = {
            _name = "user_info_window_look_play_racecourse_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("other_players_racecourse_ride_window_open",0,"") 
                    end
                end
                _ED.other_user_equiment = {}
                _ED.other_user_ship = {}
                _ED.other_user_gems = {}
                _ED.other_horses = {}
                _ED.other_horse_spirits = {}
                protocol_command.get_other_user_horse_info.param_list = instance._user_data.user_id
                NetworkManager:register(protocol_command.get_other_user_horse_info.code, instance._server_link, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 神兵
        local user_info_window_look_play_god_weaponry_info_terminal = {
            _name = "user_info_window_look_play_god_weaponry_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("other_players_god_weaponry_window_open",0,nil) 
                        end
                    end
                end
                _ED.other_user_ship = {}
                _ED.other_user_equiment = {}
                _ED.other_user_gems = {}
                _ED.other_horses = {}
                _ED.other_horse_spirits = {}
                protocol_command.get_other_user_ship_info.param_list = instance._user_data.user_id
                NetworkManager:register(protocol_command.get_other_user_ship_info.code, instance._server_link, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --私聊
        local user_info_window_chat_person_terminal = {  
            _name = "user_info_window_chat_person",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._user_data.user_id == _ED.user_info.user_id then
                    TipDlg.drawTextDailog(red_alert_all_str[191])
                    return
                end
                state_machine.excute("chat_sent_window_open",0,"")
                state_machine.excute("chat_sent_change_to_person_chat",0,params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(user_info_window_show_terminal)
        state_machine.add(user_info_window_hide_terminal)
        state_machine.add(user_info_window_look_play_hero_info_terminal)
        state_machine.add(user_info_window_look_play_equip_info_terminal)
        state_machine.add(user_info_window_look_play_racecourse_info_terminal)
        state_machine.add(user_info_window_look_play_god_weaponry_info_terminal)
        state_machine.add(user_info_window_chat_person_terminal)
        state_machine.init()
    end
    
    -- call func init set_window state machine.
    init_user_info_window_terminal()
end

function UserInfoWindow:onHide()
    self:setVisible(false)
end

function UserInfoWindow:onShow()
    self:setVisible(true)
end
function UserInfoWindow:onEnterTransitionFinish()

end

function UserInfoWindow:onUpdateDraw()
    local root = self.roots[1]
    --玩家等级性别
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_player_icon")
    local head_icon = state_machine.excute("user_head_icon_create",0,{self._user_data})
    Panel_player_icon:addChild(head_icon)

    --玩家官阶
    local Text_player_grade = ccui.Helper:seekWidgetByName(root,"Text_player_grade")
    local arena_official = dms.int(dms["arena_reward_param"],self._user_data.user_arena_id,arena_reward_param.arena_official)
    if arena_official ~= nil then --如果有官阶显示官阶
        Text_player_grade:setString(red_alert_officer[arena_official])
        local color_table = red_alert_officer_color[arena_official]
        Text_player_grade:setColor(cc.c3b(color_table[1],color_table[2],color_table[3]))
    else    --如果没有官阶不显示
        Text_player_grade:setString("")
    end
    --玩家名称
    local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name")
    Text_player_name:setString(self._user_data.user_name)
    --战斗力
    local Text_player_fighting_namber = ccui.Helper:seekWidgetByName(root,"Text_player_fighting_namber")
    Text_player_fighting_namber:setString(self._user_data.user_fight)
    --帮盟
    local Text_player_legion_name = ccui.Helper:seekWidgetByName(root,"Text_player_legion_name")
    if _ED.other_user_info.union_name == "" then --如果未加入帮盟
        Text_player_legion_name:setString(red_alert_all_str[157])
    else    --如果加入帮盟显示帮盟名称
        Text_player_legion_name:setString("【".._ED.other_user_info.union_name.."】")
    end

    -- 显示跨服信息时隐藏私聊
    -- local Button_chat = ccui.Helper:seekWidgetByName(root,"Button_chat")
    -- if self._show_chat ~= nil then
    --     Button_chat:setVisible(self._show_chat)
    -- end
end

function UserInfoWindow:init(server_link, show_chat)
    self._user_data = _ED.other_user_info
    self._server_link = server_link
    self._show_chat = show_chat
	self:onInit()
    return self
end

function UserInfoWindow:onInit( )
    local csbItem = csb.createNode(config_csb.rank.ranking_payer_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_player") , nil, 
    {
        terminal_name = "user_info_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_player_look") , nil, 
    {
        terminal_name = "user_info_window_close", 
        terminal_state = 0, 
    }, nil, 0)    
    -- 查看英雄
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_role") , nil, 
    {
        terminal_name = "user_info_window_look_play_hero_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
        -- 查看装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_equipment") , nil, 
    {
        terminal_name = "user_info_window_look_play_equip_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 私聊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chat") , nil, 
    {
        terminal_name = "user_info_window_chat_person", 
        terminal_state = 0, 
        user_data = self._user_data,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 查看珍兽
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_racecourse") , nil, 
    {
        terminal_name = "user_info_window_look_play_racecourse_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 查看神兵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_god_weaponry") , nil, 
    {
        terminal_name = "user_info_window_look_play_god_weaponry_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    self:onUpdateDraw() 
end

function UserInfoWindow:onExit()
    state_machine.remove("user_info_window_show")
    state_machine.remove("user_info_window_hide")
    state_machine.remove("user_info_window_look_play_hero_info")
    state_machine.remove("user_info_window_look_play_equip_info")
    state_machine.remove("user_info_window_chat_person")
    state_machine.remove("user_info_window_look_play_racecourse_info")
    state_machine.remove("user_info_window_look_play_god_weaponry_info")
end
