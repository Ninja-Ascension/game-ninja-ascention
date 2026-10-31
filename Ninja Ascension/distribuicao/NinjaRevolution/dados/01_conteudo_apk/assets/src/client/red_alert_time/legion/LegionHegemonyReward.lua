-- ---------------------------
-- 军团争霸-奖励
-- ---------------------------
LegionHegemonyReward = class("LegionHegemonyRewardClass", Window)

local legion_hegemony_reward_window_open_terminal = {
    _name = "legion_hegemony_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = LegionHegemonyReward:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_hegemony_reward_window_open_terminal)
state_machine.init()

function LegionHegemonyReward:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._victor_panel = nil
    self._legion_panel = nil

    local function init_legion_hegemony_reward_terminal()
        -- 显示界面
        local legion_hegemony_reward_show_terminal = {
            _name = "legion_hegemony_reward_show",
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

        -- 隐藏界面
        local legion_hegemony_reward_hide_terminal = {
            _name = "legion_hegemony_reward_hide",
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

        -- 切换页面
        local legion_hegemony_reward_change_page_terminal = {
            _name = "legion_hegemony_reward_change_page",
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

        -- 刷新页面
        local legion_hegemony_reward_update_list_view_terminal = {
            _name = "legion_hegemony_reward_update_list_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateListview()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(legion_hegemony_reward_show_terminal)  
        state_machine.add(legion_hegemony_reward_hide_terminal)
        state_machine.add(legion_hegemony_reward_change_page_terminal)
        state_machine.add(legion_hegemony_reward_update_list_view_terminal)
        state_machine.init()
    end
    init_legion_hegemony_reward_terminal()
end

function LegionHegemonyReward:onHide()
    self:setVisible(false)
end

function LegionHegemonyReward:onShow()
    self:setVisible(true)
end

function LegionHegemonyReward:updateListview()
    if self._victor_panel ~= nil then
        state_machine.excute("legion_hegemony_report_listview_update_draw", 0, self._victor_panel)
    end
    if self._legion_panel ~= nil then
        state_machine.excute("legion_hegemony_report_listview_update_draw", 0, self._legion_panel)
    end

    self:updateUserInfo()
end

function LegionHegemonyReward:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_hegemony_reward_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_hegemony_reward_tab_box")

    local Button_hegemony_straight_reward = ccui.Helper:seekWidgetByName(root, "Button_hegemony_straight_reward")
    local Button_hegemony_legion_reward = ccui.Helper:seekWidgetByName(root, "Button_hegemony_legion_reward")
    if page == self._current_page then
        if page == 1 then
            Button_hegemony_straight_reward:setHighlighted(true)
        elseif page == 2 then
            Button_hegemony_legion_reward:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_hegemony_straight_reward:setHighlighted(false)
    Button_hegemony_legion_reward:setHighlighted(false)

    state_machine.excute("legion_hegemony_report_listview_window_hide", 0, self._victor_panel)
    state_machine.excute("legion_hegemony_report_listview_window_hide", 0, self._legion_panel)
    if page == 1 then
        Button_hegemony_straight_reward:setHighlighted(true)
        if self._victor_panel == nil then
            self._victor_panel = state_machine.excute("legion_hegemony_report_listview_window_open", 0, {Panel_hegemony_reward_tab_box, 4})
        else
            state_machine.excute("legion_hegemony_report_listview_window_show", 0, self._victor_panel)
        end
    elseif page == 2 then
        Button_hegemony_legion_reward:setHighlighted(true)
        if self._legion_panel == nil then
            self._legion_panel = state_machine.excute("legion_hegemony_report_listview_window_open", 0, {Panel_hegemony_reward_tab_box, 5})
        else
            state_machine.excute("legion_hegemony_report_listview_window_show", 0, self._legion_panel)
        end
    end

    self:updateUserInfo()
end

function LegionHegemonyReward:updateUserInfo()
    local root = self.roots[1]
    local page = self._current_page
    local Text_hegemony_rank_me_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_rank_me_n")
    local Text_hegemony_people_me_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_people_me_t")
    local Text_hegemony_people_me_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_people_me_n")
    local Text_hegemony_fight_me_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_me_t")
    local Text_hegemony_fight_me_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_me_n")
    Text_hegemony_people_me_t:setVisible(false)
    Text_hegemony_people_me_n:setString("")

    if page == 1 then
        Text_hegemony_fight_me_t:setString(red_alert_time_str[149]..":")

        local info_data = nil
        if _ED.union.union_union_hegemony_rank_list ~= nil and _ED.union.union_union_hegemony_rank_list["0"] ~= nil then
            for k, v in pairs(_ED.union.union_union_hegemony_rank_list["0"]) do
                if tonumber(v.id) == tonumber(_ED.user_info.user_id) then
                    info_data = v
                    break
                end
            end
        end

        if info_data == nil then
            Text_hegemony_rank_me_n:setString(red_alert_time_str[1])
            Text_hegemony_fight_me_n:setString("0")
        else
            Text_hegemony_rank_me_n:setString(info_data.rank)
            Text_hegemony_fight_me_n:setString(exChangeNumToString(info_data.fight_number))
        end
    elseif page == 2 then
        Text_hegemony_people_me_t:setVisible(true)
        Text_hegemony_fight_me_t:setString(red_alert_time_str[152]..":")

        local info_data = nil
        if _ED.union.union_union_hegemony_rank_list ~= nil and _ED.union.union_union_hegemony_rank_list["1"] ~= nil then
            for k, v in pairs(_ED.union.union_union_hegemony_rank_list["1"]) do
                if tonumber(v.id) == tonumber(_ED.union.union_info.union_id) then
                    info_data = v
                    break
                end
            end
        end

        if info_data == nil then
            Text_hegemony_rank_me_n:setString(red_alert_time_str[1])
            Text_hegemony_people_me_n:setString("0")
            Text_hegemony_fight_me_n:setString("0")
        else
            Text_hegemony_rank_me_n:setString(info_data.rank)
            Text_hegemony_people_me_n:setString(info_data.number)
            Text_hegemony_fight_me_n:setString(exChangeNumToString(info_data.fight_number))
        end
    end

end

function LegionHegemonyReward:onEnterTransitionFinish()

end

function LegionHegemonyReward:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_hegemony_tab, 4))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_straight_reward"), nil, 
    {
        terminal_name = "legion_hegemony_reward_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_legion_reward"), nil, 
    {
        terminal_name = "legion_hegemony_reward_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_reward_infor"), nil, 
    {
        terminal_name = "legion_hegemony_help_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
        infor_type = 2,
    }, nil, 1)

    self.lastState = tonumber(_ED.union.union_hegemony_info.state)

    if _ED.union.union_union_hegemony_rank_list == nil 
        or table.nums(_ED.union.union_union_hegemony_rank_list["1"]) <= 0
        then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:changeSelectPage(1)
                end
            end
        end
        protocol_command.union_craft_rank_list_get.param_list = ""
        NetworkManager:register(protocol_command.union_craft_rank_list_get.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        self:changeSelectPage(1)
    end
end

function LegionHegemonyReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function LegionHegemonyReward:onExit()
    state_machine.remove("legion_hegemony_reward_show")
    state_machine.remove("legion_hegemony_reward_hide")
    state_machine.remove("legion_hegemony_reward_change_page")
    state_machine.remove("legion_hegemony_reward_update_list_view")
end
