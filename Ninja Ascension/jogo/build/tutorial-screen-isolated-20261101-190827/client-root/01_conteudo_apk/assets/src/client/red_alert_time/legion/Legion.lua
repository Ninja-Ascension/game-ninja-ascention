--------------------------------------------------------------------------------------------------------------
--  说明：工会
--------------------------------------------------------------------------------------------------------------
Legion = class("LegionClass", Window)

--打开界面
local legion_window_open_terminal = {
	_name = "legion_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.lock("legion_window_open", 0, 0)
        local function responseCallbackUnion(response)
            state_machine.unlock("legion_window_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                    state_machine.excute("home_map_update_build", 0, "")
                    state_machine.excute("legion_reward_window_window_open", 0, "")
                else
                    if fwin:find("LegionClass") == nil then
                        fwin:open(Legion:new():init(params), fwin._ui)
                    end
                end
            end
        end
        _ED.union.union_list_info = nil
        protocol_command.union_init.param_list = "0"
        NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseCallbackUnion, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local legion_window_close_terminal = {
	_name = "legion_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionClass"))
        state_machine.excute("home_map_update_build", 0, "")
        state_machine.excute("main_window_update_gold_info", 0, nil)
        state_machine.excute("home_map_update_prodcution_state", 0, {2})
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)

        cacher.removeAllTextures()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--退出或者被踢出清空数据
local legion_clean_all_data_terminal = {
    _name = "legion_clean_all_data",
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
        _ED.union.union_message_number = 0
        _ED._can_receive_count = 0

        local send_info = _ED.send_information
        _ED.send_information = {}
        for k, v in pairs(send_info) do
            if tonumber(v.information_type) ~= 3 
                and tonumber(v.information_type) ~= 10 
                then
                table.insert(_ED.send_information,v)
            end
        end

        -- 清除切磋战报
        _ED.city_resource_battle_report[24] = nil
        _ED.city_resource_battle_report[10001] = nil

        -- 清除军团争霸战报
        _ED.city_resource_battle_report[10003] = nil
        _ED.city_resource_battle_report[10004] = nil
        _ED.city_resource_battle_report[207] = nil

        -- 清除兄弟同享推送
        _ED.mould_function_push_info["11"] = nil

        -- 清除城市战数据
        if  _ED.world_city_info ~= nil then
            _ED.world_city_info.my_info = nil
        end

        state_machine.excute("notification_center_update", 0, "push_notification_mine_treasure_push")
        state_machine.excute("notification_center_update", 0, "push_notification_brothers_personal")
        state_machine.excute("red_alert_time_center_update_push", 0, 57)

        state_machine.excute("red_alert_time_clear_legion_info", 0, "")
        state_machine.excute("red_alert_time_button_update_chat_info", 0, "")
        state_machine.excute("home_map_update_prodcution_state", 0, {2})
        state_machine.excute("home_map_change_home_build_legion_info", 0, "")
        state_machine.excute("legion_window_close", 0, nil)
        state_machine.excute("main_window_update_top_button", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_window_open_terminal)
state_machine.add(legion_window_close_terminal)
state_machine.add(legion_clean_all_data_terminal)
state_machine.init()

function Legion:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._infoPanel = nil
    self._eventPanel = nil
    self._memberPanel = nil
    self._conPanel = nil
    
    app.load("client.red_alert_time.legion.LegionInfomation")
    app.load("client.red_alert_time.legion.LegionEvent")
    app.load("client.red_alert_time.legion.LegionMember")
    app.load("client.red_alert_time.legion.LegionConRanks")
    app.load("client.red_alert_time.legion.LegionApplicationConfirmation")
    app.load("client.red_alert_time.legion.LegionMemberInfor")
    app.load("client.red_alert_time.legion.LegionShop")
    app.load("client.red_alert_time.legion.LegionShopListview")
    app.load("client.red_alert_time.legion.LegionActive")
    app.load("client.red_alert_time.legion.LegionPK")
    app.load("client.red_alert_time.legion.LegionManage")
    app.load("client.red_alert_time.legion.LegionTechnologyDonate")
    app.load("client.red_alert_time.legion.LegionTechnologyInfor")
    app.load("client.red_alert_time.legion.LegionPve")
    app.load("client.red_alert_time.legion.LegionTechnologyUp")
    app.load("client.red_alert_time.legion.LegionTechnologyUpRes")
    app.load("client.red_alert_time.legion.LegionPveAttackInfor")
    app.load("client.red_alert_time.legion.LegionWelfare")
    app.load("client.red_alert_time.legion.LegionWelfareReward")
    app.load("client.red_alert_time.legion.LegionWelfareGlory")
    app.load("client.red_alert_time.legion.LegionWelfareWindow")
    app.load("client.red_alert_time.legion.LegionWelfareDistributionWindow")
    app.load("client.red_alert_time.legion.LegionImpeachmentWindow")
    app.load("client.red_alert_time.legion.LegionShopHelp")
    app.load("client.red_alert_time.legion.LegionActiveHelp")
    app.load("client.red_alert_time.legion.LegionMemberVsHelp")
    app.load("client.red_alert_time.legion.LegionPveHelp")
    app.load("client.red_alert_time.legion.LegionHegemony")
    app.load("client.red_alert_time.legion.LegionSetAttackHelp")
    app.load("client.red_alert_time.legion.LegionSetAttackHelpInfor")
    app.load("client.red_alert_time.legion.LegionMailWrite")
    app.load("client.red_alert_time.legion.LegionChatsView")
    app.load("client.red_alert_time.legion.LegionExitPrompt")
    app.load("client.red_alert_time.legion.LegionMemberManage")
    app.load("client.red_alert_time.legion.LegionCity")

    app.load("client.red_alert_time.cells.legion.legion_event_cell")
    app.load("client.red_alert_time.cells.legion.legion_people_cell")
    app.load("client.red_alert_time.cells.legion.legion_cotribution_rank_cell")
    app.load("client.red_alert_time.cells.legion.legion_application_confirmation_cell")
    app.load("client.red_alert_time.cells.legion.legion_shop_cell")
    app.load("client.red_alert_time.cells.legion.legion_technology_donate_cell")
    app.load("client.red_alert_time.cells.legion.legion_technology_donate_lock_cell")
    app.load("client.red_alert_time.cells.legion.legion_pve_chapter_cell")
    app.load("client.red_alert_time.cells.legion.legion_welfare_cell")
    app.load("client.red_alert_time.cells.legion.legion_welfare_window_cell")
    app.load("client.red_alert_time.cells.legion.legion_welfare_glory_cell")
    app.load("client.red_alert_time.cells.legion.legion_welfare_distribution_window_cell")

    app.load("client.red_alert_time.battle.battle_enum")

    local function init_legion_terminal()
        local legion_change_page_terminal = {
            _name = "legion_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(legion_change_page_terminal)   
        state_machine.init()
    end
    init_legion_terminal()
end

function Legion:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_legion_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_legion_tab_box")
    local Button_legion_infor = ccui.Helper:seekWidgetByName(root, "Button_legion_infor")
    local Button_legion_event = ccui.Helper:seekWidgetByName(root, "Button_legion_event")
    local Button_legion_pepole_list = ccui.Helper:seekWidgetByName(root, "Button_legion_pepole_list")
    local Button_contribution_rank = ccui.Helper:seekWidgetByName(root, "Button_contribution_rank")
    if page == self._current_page then
        if page == 1 then
            Button_legion_infor:setHighlighted(true)
        elseif page == 2 then
            Button_legion_event:setHighlighted(true)
        elseif page == 3 then
            Button_legion_pepole_list:setHighlighted(true)
        else
            Button_contribution_rank:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_legion_infor:setHighlighted(false)
    Button_legion_event:setHighlighted(false)
    Button_legion_pepole_list:setHighlighted(false)
    Button_contribution_rank:setHighlighted(false)
    state_machine.excute("legion_infomation_hide", 0, nil)
    state_machine.excute("legion_event_hide", 0, nil)
    if __lua_project_id == __lua_project_pacific_rim then
        state_machine.excute("legion_member_manage_hide", 0, nil)
    else
        state_machine.excute("legion_member_hide", 0, nil)
        state_machine.excute("legion_con_ranks_hide", 0, nil)
    end
    if page == 1 then
        Button_legion_infor:setHighlighted(true)
        if self._infoPanel == nil then
            self._infoPanel = state_machine.excute("legion_infomation_window_open", 0, {Panel_legion_tab_box})
        else
            state_machine.excute("legion_infomation_show", 0, nil)
        end
    elseif page == 2 then
        Button_legion_event:setHighlighted(true)
        if self._eventPanel == nil then
            self._eventPanel = state_machine.excute("legion_event_window_open", 0, {Panel_legion_tab_box})
        else
            state_machine.excute("legion_event_show", 0, nil)
        end
    elseif page == 3 then
        Button_legion_pepole_list:setHighlighted(true)
        if __lua_project_id == __lua_project_pacific_rim then
            if self._memberPanel == nil then
                self._memberPanel = state_machine.excute("legion_member_manage_window_open", 0, {Panel_legion_tab_box})
            else
                state_machine.excute("legion_member_manage_show", 0, nil)
            end
        else
            if self._memberPanel == nil then
                self._memberPanel = state_machine.excute("legion_member_window_open", 0, {Panel_legion_tab_box})
            else
                state_machine.excute("legion_member_show", 0, nil)
            end
        end
    else
        Button_contribution_rank:setHighlighted(true)
        if self._conPanel == nil then
            self._conPanel = state_machine.excute("legion_con_ranks_window_open", 0, {Panel_legion_tab_box})
        else
            state_machine.excute("legion_con_ranks_show", 0, nil)
        end
    end
end

function Legion:updateChatView()
    local root = self.roots[1]
    local Panel_legion_chat_view = ccui.Helper:seekWidgetByName(root, "Panel_legion_chat_view")
    Panel_legion_chat_view:removeAllChildren(true)
    state_machine.excute("legion_chats_view_open", 0, {Panel_legion_chat_view, 3})
end

function Legion:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_close"), nil, 
    {
        terminal_name = "legion_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_infor"), nil, 
    {
        terminal_name = "legion_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_event"), nil, 
    {
        terminal_name = "legion_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_pepole_list"), nil, 
    {
        terminal_name = "legion_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    if __lua_project_id == __lua_project_pacific_rim then
        if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_legion_apply",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_legion_pepole_list"),
                _invoke = nil,
                _interval = 0.2,})
        end
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_contribution_rank"), nil, 
    {
        terminal_name = "legion_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)
    
    protocol_command.union_message.param_list = _ED.union.union_info.union_id.."\r\n".._ED.union.union_info.union_camp
    NetworkManager:register(protocol_command.union_message.code, nil, nil, nil, nil, nil, false, nil)

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
    self:updateChatView()
end

function Legion:onEnterTransitionFinish()

end

function Legion:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function Legion:onExit()
    state_machine.remove("legion_change_page")
end