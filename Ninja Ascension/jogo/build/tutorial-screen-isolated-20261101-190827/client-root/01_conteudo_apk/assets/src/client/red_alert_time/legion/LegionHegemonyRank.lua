-- ---------------------------
-- 军团争霸-排行
-- ---------------------------
LegionHegemonyRank = class("LegionHegemonyRankClass", Window)

local legion_hegemony_rank_window_open_terminal = {
    _name = "legion_hegemony_rank_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = LegionHegemonyRank:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_hegemony_rank_window_open_terminal)
state_machine.init()

function LegionHegemonyRank:ctor()
    self.super:ctor()
    self.roots = {}

    self.lastState = 0
    self._current_page = 0
    self._victor_panel = nil
    self._legion_panel = nil

    local function init_legion_hegemony_rank_terminal()
        -- 显示界面
        local legion_hegemony_rank_show_terminal = {
            _name = "legion_hegemony_rank_show",
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
        local legion_hegemony_rank_hide_terminal = {
            _name = "legion_hegemony_rank_hide",
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
        local legion_hegemony_rank_change_page_terminal = {
            _name = "legion_hegemony_rank_change_page",
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
        local legion_hegemony_rank_update_list_view_terminal = {
            _name = "legion_hegemony_rank_update_list_view",
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

        state_machine.add(legion_hegemony_rank_show_terminal)  
        state_machine.add(legion_hegemony_rank_hide_terminal)
        state_machine.add(legion_hegemony_rank_change_page_terminal)
        state_machine.add(legion_hegemony_rank_update_list_view_terminal)
        state_machine.init()
    end
    init_legion_hegemony_rank_terminal()
end

function LegionHegemonyRank:onHide()
    self:setVisible(false)
end

function LegionHegemonyRank:onShow()
    self:setVisible(true)
end

function LegionHegemonyRank:updateListview()
    if self._victor_panel ~= nil then
        state_machine.excute("legion_hegemony_rank_listview_update_draw", 0, self._victor_panel)
    end
    if self._legion_panel ~= nil then
        state_machine.excute("legion_hegemony_rank_listview_update_draw", 0, self._legion_panel)
    end

    self:updateUserInfo()
end

function LegionHegemonyRank:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_hegemony_rank_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_hegemony_rank_tab_box")

    local Button_hegemony_straight_rank = ccui.Helper:seekWidgetByName(root, "Button_hegemony_straight_rank")
    local Button_hegemony_legion_rank = ccui.Helper:seekWidgetByName(root, "Button_hegemony_legion_rank")
    if page == self._current_page then
        if page == 1 then
            Button_hegemony_straight_rank:setHighlighted(true)
        elseif page == 2 then
            Button_hegemony_legion_rank:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_hegemony_straight_rank:setHighlighted(false)
    Button_hegemony_legion_rank:setHighlighted(false)

    state_machine.excute("legion_hegemony_rank_listview_window_hide", 0, self._victor_panel)
    state_machine.excute("legion_hegemony_rank_listview_window_hide", 0, self._legion_panel)
    if page == 1 then
        Button_hegemony_straight_rank:setHighlighted(true)
        if self._victor_panel == nil then
            self._victor_panel = state_machine.excute("legion_hegemony_rank_listview_window_open", 0, {Panel_hegemony_rank_tab_box, 1})
        else
            state_machine.excute("legion_hegemony_rank_listview_window_show", 0, self._victor_panel)
        end
    elseif page == 2 then
        Button_hegemony_legion_rank:setHighlighted(true)
        if self._legion_panel == nil then
            self._legion_panel = state_machine.excute("legion_hegemony_rank_listview_window_open", 0, {Panel_hegemony_rank_tab_box, 2})
        else
            state_machine.excute("legion_hegemony_rank_listview_window_show", 0, self._legion_panel)
        end
    end

    self:updateUserInfo()
end

function LegionHegemonyRank:updateUserInfo()
    local root = self.roots[1]
    local page = self._current_page
    local Text_hegemony_name_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_name_t")
    local Text_hegemony_straight_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_straight_t")
    local Text_hegemony_fight_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_t")
    local Text_hegemony_rank_me_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_rank_me_n")
    local Text_hegemony_straight_me_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_straight_me_n")
    local Text_hegemony_fight_me_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_me_t")
    local Text_hegemony_fight_me_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_me_n")
    Text_hegemony_straight_me_n:setString("")
    Text_hegemony_straight_me_n:removeAllChildren(true)

    if page == 1 then
        Text_hegemony_name_t:setString(red_alert_time_str[147])
        Text_hegemony_straight_t:setString(red_alert_time_str[148])
        Text_hegemony_fight_t:setString(red_alert_time_str[149])
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

        local number = 0
        if info_data == nil then
            Text_hegemony_rank_me_n:setString(red_alert_time_str[1])
            Text_hegemony_fight_me_n:setString("0")
            number = 0
        else
            Text_hegemony_rank_me_n:setString(info_data.rank)
            Text_hegemony_fight_me_n:setString(exChangeNumToString(info_data.fight_number))
            number = info_data.number
        end

        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[153], "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, number, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_hegemony_straight_me_n:getContentSize().width/2,Text_hegemony_straight_me_n:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_hegemony_straight_me_n:getContentSize().width,18))
        Text_hegemony_straight_me_n:addChild(_richText)
    elseif page == 2 then
        Text_hegemony_name_t:setString(red_alert_time_str[150])
        Text_hegemony_straight_t:setString(red_alert_time_str[151])
        Text_hegemony_fight_t:setString(red_alert_time_str[152])
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

        local number = 0
        if info_data == nil then
            Text_hegemony_rank_me_n:setString(red_alert_time_str[1])
            Text_hegemony_fight_me_n:setString("0")
            number = 0
        else
            Text_hegemony_rank_me_n:setString(info_data.rank)
            Text_hegemony_fight_me_n:setString(exChangeNumToString(info_data.fight_number))
            number = info_data.number
        end

        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[151]..":", "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, number, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_hegemony_straight_me_n:getContentSize().width/2,Text_hegemony_straight_me_n:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_hegemony_straight_me_n:getContentSize().width,18))
        Text_hegemony_straight_me_n:addChild(_richText)
    end
end

function LegionHegemonyRank:onEnterTransitionFinish()

end

function LegionHegemonyRank:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_hegemony_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_straight_rank"), nil, 
    {
        terminal_name = "legion_hegemony_rank_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_legion_rank"), nil, 
    {
        terminal_name = "legion_hegemony_rank_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_rank_infor"), nil, 
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

function LegionHegemonyRank:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function LegionHegemonyRank:onExit()
    state_machine.remove("legion_hegemony_rank_show")
    state_machine.remove("legion_hegemony_rank_hide")
    state_machine.remove("legion_hegemony_rank_change_page")
    state_machine.remove("legion_hegemony_rank_update_list_view")
end
