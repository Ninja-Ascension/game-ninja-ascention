--------------------------------------------------------------------------------------------------------------
--  公会主界面
--------------------------------------------------------------------------------------------------------------
Union = class("UnionClass", Window)

--打开界面
local union_open_terminal = {
	_name = "union_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(70) == true then
            return
        end
		state_machine.excute("union_create_close", 0, "")
        if fwin:find("UnionJoinClass") ~= nil then
            state_machine.excute("union_join_close", 0, "")
        end
		fwin:open(Union:new():init(), fwin._view)
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")  
        state_machine.excute("duplicate_title_window_hide",0,"") 
        state_machine.excute("duplicate_map_window_hide",0,"")
        state_machine.excute("duplicate_manager_window_hide",0,"")
        state_machine.excute("seven_star_map_ui_window_hide",0,"")  
        if fwin:find("HeroRecruitClass")  ~= nil then
            state_machine.excute("hero_recruit_window_hide", 0, "")
            state_machine.excute("catalogue_storage_window_hide", 0, "")
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
--关闭界面
local union_close_terminal = {
	_name = "union_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionClass"))
        if fwin:find("NationalWarMapClass") ~= nil then 
            state_machine.excute("home_button_for_action_window_show",0,"")  
        elseif fwin:find("DuplicateManagerClass") ~= nil then
            if fwin:find("TaskClass") ~= nil then
                state_machine.excute("task_window_show",0,"") 
                state_machine.excute("player_resource_window_hide",0,"") 
                state_machine.excute("home_button_for_action_window_hide",0,"") 
                state_machine.excute("chat_view_window_hide",0,"")
                state_machine.excute("seven_star_map_ui_window_hide",0,"")
            else
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")  
                state_machine.excute("duplicate_map_window_show",0,"")   
                state_machine.excute("duplicate_manager_window_show",0,"")   
            end
        elseif fwin:find("SevenStarClass") ~= nil then
            state_machine.excute("seven_star_map_ui_window_show",0,"")
            state_machine.excute("duplicate_map_window_show",0,"")
            state_machine.excute("player_resource_window_hide",0,"")
            state_machine.excute("home_button_for_action_window_show",0,"")
        elseif fwin:find("DuplicateManagerClass") == nil and fwin:find("DuplicateMapClass") ~= nil then
            state_machine.excute("duplicate_map_window_show", 0, nil)
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")
        elseif fwin:find("HeroRecruitClass")  ~= nil then
            state_machine.excute("hero_recruit_window_show", 0, "")
            state_machine.excute("catalogue_storage_window_show", 0, "")
        elseif fwin:find("HeroMainClass") ~= nil then
            state_machine.excute("hero_main_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
        elseif fwin:find("PacksClass") ~= nil then
            state_machine.excute("packs_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
        else
            state_machine.excute("main_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
        end
        
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--退出或者被踢出清空数据
local union_the_meeting_place_clean_all_data_terminal = {
    _name = "union_the_meeting_place_clean_all_data",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.union.union_examine_list_sum = 0
        _ED.union.union_examine_list_info = {}
        _ED.union.union_find_list_sum = 0                  
        _ED.union.union_find_list_info = {}
        _ED.union.user_union_info = {}
        _ED.union.union_member_list_sum = 0
        _ED.union.union_member_list_info = {}
        _ED.union.union_info = {}
        _ED.union.union_message_number = {}
        local UnionWindow = fwin:find("UnionClass")
        if UnionWindow ~= nil then
            state_machine.excute("union_close", 0, nil)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_open_terminal)
state_machine.add(union_close_terminal)
state_machine.add(union_the_meeting_place_clean_all_data_terminal)
state_machine.init()

function Union:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.tickTime = 0
    app.load("client.red_alert.union.meeting.UnionTheMeetingPlace")
    app.load("client.red_alert.union.shop.UnionShop")
    app.load("client.red_alert.union.heaven.UnionHeaven")
    app.load("client.red_alert.union.unionFighting.UnionFightingMain")
    app.load("client.red_alert.union.rank.UnionRank")
    app.load("client.red_alert.union.teamFight.UnionTeamFight")
    app.load("client.red_alert.union.teamFight.UnionGetPhysicalFight")
    app.load("client.red_alert.notification.push_notification_union")
    app.load("client.red_alert.campaign.nationalwar.NationalTruceLoading")
    app.load("client.red_alert.battle.battle_enum")
    app.load("client.red_alert.union.unionFighting.UnionFightingReward")

    local function init_union_terminal()
		--刷新界面信息
		local union_refresh_info_terminal = {
            _name = "union_refresh_info",
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
		--返回主页
		local union_return_home_terminal = {
            _name = "union_return_home",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--点击军团商店
		local union_go_to_shop_terminal = {
            _name = "union_go_to_shop",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("union_shop_open", 0, {1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--点击封坛祭天
		local union_go_to_heaven_terminal = {
            _name = "union_go_to_heaven",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_heaven_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --阿希拉之战
        local union_go_to_axila_terminal = {
            _name = "union_go_to_axila",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_get_physical_fight_window_open", 0, nil)
                    end
                end 
                protocol_command.union_food_copy_init.param_list = _ED.union.user_union_info.union_id
                NetworkManager:register(protocol_command.union_food_copy_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --组队争霸
        local union_go_to_team_fight_terminal = {
            _name = "union_go_to_team_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_team_fight_window_open", 0, nil)
                    end
                end 
                protocol_command.union_endless_init.param_list = _ED.union.user_union_info.union_id
                NetworkManager:register(protocol_command.union_endless_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换主界面列表容器状态
        local union_change_right_list_view_state_terminal = {
            _name = "union_change_right_list_view_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                if root ~= nil then
                    ccui.Helper:seekWidgetByName(root, "ListView_city"):setVisible(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --工会占领
        local union_goto_big_map_terminal = {
            _name = "union_goto_big_map",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(123) == true then
                    return
                end
                if tonumber(_ED.union.union_info.union_grade) < dms.int(dms["union_config"], 30, union_config.param) then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[79])
                    return
                end
                if _ED.union_fight_city_state == 0 then
                    state_machine.excute("union_fighting_reward_open", 0, nil)
                    return
                end
                if fwin:find("NationalWarMapClass") == nil then
                    local function responseCallBack3( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1}})
                        end
                    end
                    local function responseCallBack2(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            _ED.personal_defender_battle_report_list = {}
                            for i, data in pairs(_ED.city_resource_battle_report) do
                                if tonumber(data.result) == 0 then
                                    table.insert(_ED.personal_defender_battle_report_list, data)
                                end
                            end
                            -- responseholdInit({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 1})
                            NetworkManager:register(protocol_command.city_resource_hold_init.code, nil, nil, nil, nil, responseCallBack3, false, nil) 
                        end
                    end
                    local function responseCallBack1(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_105 + 1000
                            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseCallBack2, false, nil)
                        end
                    end
                    protocol_command.user_stronghold_plunder_refresh.param_list = ""
                    NetworkManager:register(protocol_command.user_stronghold_plunder_refresh.code, nil, nil, nil, nil, responseCallBack1, false, nil)
                else
                    state_machine.excute("union_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local union_update_fight_state_terminal = {
            _name = "union_update_fight_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:changeUnionCapState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_refresh_info_terminal)
		state_machine.add(union_return_home_terminal)
		state_machine.add(union_go_to_shop_terminal)
		state_machine.add(union_go_to_heaven_terminal)
        state_machine.add(union_go_to_axila_terminal)
        state_machine.add(union_go_to_team_fight_terminal)
        state_machine.add(union_change_right_list_view_state_terminal)
        state_machine.add(union_goto_big_map_terminal)
        state_machine.add(union_update_fight_state_terminal)
        state_machine.init()
    end
	
    init_union_terminal()
end

function Union:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
    state_machine.excute("union_the_meeting_place_refresh", 0, nil)
end

function Union:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --关闭界面
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_22"), nil, 
    {
        terminal_name = "union_return_home", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	--公会商店
    local Button_24 = ccui.Helper:seekWidgetByName(root, "Button_24")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_24"), nil, 
    {
        terminal_name = "union_go_to_shop", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --公会建设
    local Button_25 = ccui.Helper:seekWidgetByName(root, "Button_25")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_25"), nil, 
    {
        terminal_name = "union_go_to_heaven", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --阿拉希之战
    local Button_29 = ccui.Helper:seekWidgetByName(root, "Button_29")
    fwin:addTouchEventListener(Button_29, nil, 
    {
        terminal_name = "union_go_to_axila",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --组队争霸
    local Button_29_2 = ccui.Helper:seekWidgetByName(root, "Button_29_2")
    fwin:addTouchEventListener(Button_29_2, nil, 
    {
        terminal_name = "union_go_to_team_fight", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --工会战
    local Button_29_5 = ccui.Helper:seekWidgetByName(root, "Button_29_5")
    fwin:addTouchEventListener(Button_29_5, nil, 
    {
        terminal_name = "union_goto_big_map", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    --组队争霸
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_union_team_fight",
    _widget = ccui.Helper:seekWidgetByName(root, "Panel_45_5"),
    _invoke = nil,
    _interval = 0.5,})  
    --阿拉希之战
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_union_axila",
    _widget = ccui.Helper:seekWidgetByName(root, "Panel_45_3"),
    _invoke = nil,
    _interval = 0.5,})  
    --公会建设
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_union_build",
    _widget = ccui.Helper:seekWidgetByName(root, "Panel_45_1"),
    _invoke = nil,
    _interval = 0.5,})  
    
    local function responseCallback( response )
    end
    -- if tonumber(_ED.union.union_member_list_sum) == nil then
        protocol_command.union_persion_list.param_list = _ED.union.union_info.union_id.."\r\n".._ED.union.union_info.union_camp
        NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback, false, nil)
    -- end
    -- local function responseCallback1( response )
    -- end
    -- if tonumber(_ED.union.union_message_number) == nil then
        protocol_command.union_message.param_list = _ED.union.union_info.union_id.."\r\n".._ED.union.union_info.union_camp
        NetworkManager:register(protocol_command.union_message.code, nil, nil, nil, nil, nil, false, nil)
    -- end
    if _ED.union ~= nil and _ED.union.union_info ~= nil and _ED.union.union_info.union_id ~= nil and _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
        protocol_command.unino_fight_init.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
        NetworkManager:register(protocol_command.unino_fight_init.code, _ED.union_fight_url, nil, nil, self, responseUnionFightCallback, false, nil)
    end
    local cell = UnionTheMeetingPlace:createCell()
    self:addChild(cell)

    self:changeUnionCapState()
end

function Union:changeUnionCapState( ... )
    local root = self.roots[1]
    local Button_29_5 = ccui.Helper:seekWidgetByName(root, "Button_29_5")
    local Text_get_in_3 = ccui.Helper:seekWidgetByName(root, "Text_get_in_3")
    local Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")
    local Text_time_2 = ccui.Helper:seekWidgetByName(root, "Text_time_2")
    local Text_time_3 = ccui.Helper:seekWidgetByName(root, "Text_time_3")
    local Text_time_4 = ccui.Helper:seekWidgetByName(root, "Text_time_4")
    Text_get_in_3:setString(tipStringInfo_union_str[98])--101
    Text_time_1:setVisible(false)
    Text_time_2:setVisible(false)
    Text_time_3:setVisible(false)
    Text_time_4:setVisible(false)
    -- Button_29_5:setTouchEnabled(true)
    if _ED.union_fight_city_state == 0 then
        Text_get_in_3:setString(tipStringInfo_union_str[98])
        Text_time_1:setVisible(true)
        -- Button_29_5:setTouchEnabled(false)
    elseif _ED.union_fight_city_state == 1 then
        Text_get_in_3:setString(tipStringInfo_union_str[99])
        Text_time_2:setVisible(true)
    elseif _ED.union_fight_city_state == 2 then
        Text_get_in_3:setString(tipStringInfo_union_str[100])
        Text_time_3:setVisible(true)
    elseif _ED.union_fight_city_state == 3 then
        Text_get_in_3:setString(tipStringInfo_union_str[101])
        Text_time_4:setVisible(true)
    end
end

function Union:onEnterTransitionFinish()
end

function Union:init()
	self:onInit()
	return self
end

function Union:onExit()
	state_machine.remove("union_refresh_info")
	state_machine.remove("union_return_home")
	state_machine.remove("union_go_to_shop")
	state_machine.remove("union_go_to_heaven")
	state_machine.remove("union_go_to_axila")
    state_machine.remove("union_go_to_team_fight")
    state_machine.remove("union_change_right_list_view_state")
    state_machine.remove("union_goto_big_map")
    state_machine.remove("union_update_fight_state")
end
