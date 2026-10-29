--------------------------------------------------------------------------------------------------------------
--  说明：七日狂欢
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSevenDayActivityTab = class("RedAlertTimeSevenDayActivityTabClass", Window)

--打开界面
local red_alert_time_seven_day_activity_tab_window_open_terminal = {
    _name = "red_alert_time_seven_day_activity_tab_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = RedAlertTimeSevenDayActivityTab:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_seven_day_activity_tab_window_open_terminal)
state_machine.init()

function RedAlertTimeSevenDayActivityTab:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._index = 0
    self._day_index = 0
    self._show_day = nil

    self._activity_type = 100
    self._current_day = 0

    self.m_times = 0
    self.m_reset_times = 0

    self._label_close_time = nil
    self._label_reset_time = nil

    local function init_red_alert_time_seven_day_activity_tab_terminal()
        local red_alert_time_seven_day_activity_tab_show_terminal = {
            _name = "red_alert_time_seven_day_activity_tab_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local panel = params[1]
                local show_day = params[2]
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    if panel._index ~= 5 and  zstring.tonumber(show_day) > 0 then
                        panel:changeSelectPage(show_day)
                    end
                    panel:setVisible(true)
                    panel:refreshListView()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_tab_hide_terminal = {
            _name = "red_alert_time_seven_day_activity_tab_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local panel = params
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_tab_update_terminal = {
            _name = "red_alert_time_seven_day_activity_tab_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panel = params[1]
                local update_day_index = params[2]
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    if update_day_index == 0 or panel._day_index == update_day_index then
                        panel:onUpdateDraw()
                        panel._list_view_poy = panel._list_view:getInnerContainer():getPositionY() + 1
                        panel:onUpdate(0)  
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_tab_change_page_terminal = {
            _name = "red_alert_time_seven_day_activity_tab_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local panel = params._datas.panel
                local page = params._datas.page
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    panel:changeSelectPage(tonumber(page))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_tab_rule_info_terminal = {
            _name = "red_alert_time_seven_day_activity_tab_rule_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,100)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_tab_select_day_terminal = {
            _name = "red_alert_time_seven_day_activity_tab_select_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local panel = params._datas.panel
                local page = params._datas.page
                if panel ~= nil and panel.roots ~= nil and panel.roots[1] ~= nil then
                    if page ~= 8 then
                        state_machine.excute("red_alert_time_seven_day_activity_change_page", 0, {_datas = {page = 1}})
                        state_machine.excute("red_alert_time_seven_day_activity_select_tab_page", 0, {1, page})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_seven_day_activity_tab_show_terminal)   
        state_machine.add(red_alert_time_seven_day_activity_tab_hide_terminal)
        state_machine.add(red_alert_time_seven_day_activity_tab_update_terminal)
        state_machine.add(red_alert_time_seven_day_activity_tab_change_page_terminal)
        state_machine.add(red_alert_time_seven_day_activity_tab_rule_info_terminal)
        state_machine.add(red_alert_time_seven_day_activity_tab_select_day_terminal)
        state_machine.init()
    end
    init_red_alert_time_seven_day_activity_tab_terminal()
end

function RedAlertTimeSevenDayActivityTab:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function RedAlertTimeSevenDayActivityTab:changeSelectPage(page)
    local root = self.roots[1]
    for i = 1, 8 do
        local Button_seven_day_activity = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_"..i)
        if Button_seven_day_activity ~= nil then
            if i == page then
                Button_seven_day_activity:setHighlighted(true)
            else
                Button_seven_day_activity:setHighlighted(false)
            end
        end
    end
    if page == self._day_index then
        return
    end
    self._day_index = page
    self:onUpdateDraw()
end

function RedAlertTimeSevenDayActivityTab:updateTimeInfo()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]

    local activity_add_state = activity_info.activity_add_state
    local time_info = zstring.split(zstring.split(activity_add_state, "!")[1], ",")
    local current_day = tonumber(time_info[4])
    self._current_day = current_day

    local Text_seven_day_activity_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_seven_day_activity_infor_p_1")
    Text_seven_day_activity_infor_p_1:setString(zstring.exchangeFrom(activity_info.activity_dec))

    local Text_seven_day_activity_time_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_time_n")
    Text_seven_day_activity_time_n:setString(string.format(activity_str_tip[115], current_day))
end

function RedAlertTimeSevenDayActivityTab:updateCountDownInfo()
    local root = self.roots[1]
    local activity_add_state = _ED.activity_info[""..self._activity_type].activity_add_state
    local timesData = zstring.split(zstring.split(activity_add_state, "!")[1], ",")

    local server_time = getCurrentGTM8Time()
    local leave_day = tonumber(timesData[5]) - tonumber(timesData[4])       -- 剩余天数
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    self.m_times = self.m_reset_times + leave_day * 24 * 3600

    -- 关闭倒计时
    local Text_consumption_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_consumption_act_time_1")
    Text_consumption_act_time_1:removeAllChildren(true)
    Text_consumption_act_time_1:setString("")
    local font_size = Text_consumption_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_consumption_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_consumption_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_consumption_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_consumption_act_time_1:addChild(time_int)
    self._label_close_time = time_int

    local Text_consumption_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_consumption_act_time_2")
    Text_consumption_act_time_2:removeAllChildren(true)
    Text_consumption_act_time_2:setString("")
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_consumption_act_time_2:getContentSize().width - 80)
    reset_time_int:setPositionY(Text_consumption_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_consumption_act_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[97], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_consumption_act_time_2:getContentSize().width - 80)
    reset_time_info:setPositionY(Text_consumption_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_consumption_act_time_2:addChild(reset_time_info)
    self._label_reset_time = reset_time_int
end

function RedAlertTimeSevenDayActivityTab:onUpdateDraw()
    local root = self.roots[1]
    self:updateTimeInfo()

    local ListView_seven_day = ccui.Helper:seekWidgetByName(root, "ListView_seven_day")

    local result = getSevenDayActivityRewardList(self._day_index, self._index)

    local items = ListView_seven_day:getItems()
    for k,v in pairs(items) do
        local params = {cell = v, index = k, day_index = self._day_index, current_day = self._current_day, info = result[k]}
        if self._index == 3 then
            state_machine.excute("red_alert_time_seven_day_activity_recharge_cell_update_info", 0, params)
        else
            state_machine.excute("red_alert_time_seven_day_activity_cell_update_info", 0, params)
        end
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_seven_day:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local params = {i, self._index, self._day_index, self._current_day, result[i]}
            local cell = nil
            if self._index == 3 then
                cell = state_machine.excute("red_alert_time_seven_day_activity_recharge_cell_create", 0, params)
            else
                cell = state_machine.excute("red_alert_time_seven_day_activity_cell_create", 0, params)
            end
            ListView_seven_day:addChild(cell)
        end
    end

    self._list_view = ListView_seven_day
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self:updateCountDownInfo()
end

function RedAlertTimeSevenDayActivityTab:onUpdate( dt )
    if self.m_reset_times > 0 and self._label_reset_time ~= nil then
        self.m_reset_times = self.m_reset_times - dt
        self._label_reset_time:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end
    if self.m_times > 0 and self._label_close_time ~= nil then
        self.m_times = self.m_times - dt
        self._label_close_time:setString(getRedAlertTimeActivityFormat(self.m_times))
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("main_window_update_top_button", 0, nil)
            state_machine.excute("red_alert_time_seven_day_activity_update_state", 0, "")
        end
    end

    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function RedAlertTimeSevenDayActivityTab:onInit(params)
    local csbItem = csb.createNode(config_csb.treasurehouse.seven_day_activity_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    for i = 1, 8 do
        if __lua_project_id == __lua_project_pacific_rim then
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_"..i), nil, 
            {
                terminal_name = "red_alert_time_seven_day_activity_tab_select_day", 
                terminal_state = 0, 
                panel = self,
                page = i,
            }, nil, 1)
        else
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_"..i), nil, 
            {
                terminal_name = "red_alert_time_seven_day_activity_tab_change_page", 
                terminal_state = 0, 
                panel = self,
                page = i,
            }, nil, 1)
        end
        if self._index ~= 5 then 
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_day_activity",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_"..i),
                _invoke = nil,
                _activity_index = self._index,
                _day = i,
                _interval = 0.2,})
        end
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seven_day_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_tab_rule_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_seven_day_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_seven_day_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)
    
    if self._index == 5 then
        self:changeSelectPage(8)
    elseif self._show_day ~= nil and self._show_day > 0 then
        self:changeSelectPage(self._show_day)
    else
        local activity_info = _ED.activity_info[""..self._activity_type]
        local activity_add_state = activity_info.activity_add_state
        local time_info = zstring.split(zstring.split(activity_add_state, "!")[1], ",")
        local current_day = tonumber(time_info[4])
        current_day = math.min(current_day, 7)

        self:changeSelectPage(current_day)
    end
end

function RedAlertTimeSevenDayActivityTab:onEnterTransitionFinish()

end

function RedAlertTimeSevenDayActivityTab:init(params)
    self._rootWindows = params[1]
    self._index = params[2]
    self._show_day = params[3]
    self:onInit()
    return self
end

function RedAlertTimeSevenDayActivityTab:onExit()

end