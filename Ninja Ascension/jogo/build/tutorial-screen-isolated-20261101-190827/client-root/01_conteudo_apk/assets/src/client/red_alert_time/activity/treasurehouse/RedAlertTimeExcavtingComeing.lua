-----------------------------
--挖掘机来袭
-----------------------------
RedAlertTimeExcavtingComeing = class("RedAlertTimeExcavtingComeingClass", Window)

local red_alert_time_excavting_comeing_window_open_terminal = {
    _name = "red_alert_time_excavting_comeing_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeExcavtingComeingClass") then
            fwin:open(RedAlertTimeExcavtingComeing:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_excavting_comeing_window_close_terminal = {
    _name = "red_alert_time_excavting_comeing_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeExcavtingComeingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_excavting_comeing_window_open_terminal)
state_machine.add(red_alert_time_excavting_comeing_window_close_terminal)
state_machine.init()

function RedAlertTimeExcavtingComeing:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0
    self._turntable_panel = nil
    self._rule_panel = nil
    self.m_times = 0
    self.m_reset_times = 0
    self._label_close_text = nil
    self._label_reset_text = nil
    self._is_end = false
    --load lua file
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeExcavtingComeingCollection")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeExcavtingComeingExchange")
    -- Initialize red_alert_time_excavting_comeing state machine.
    local function init_red_alert_time_excavting_comeing_terminal()
        -- 切换界面
        local red_alert_time_excavting_comeing_change_page_terminal = {
            _name = "red_alert_time_excavting_comeing_change_page",
            _init = function (terminal) 
            end,
            _inited = false,
              _instance = self,
            _tate = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 规则
        local red_alert_time_excavting_comeing_rule_open_terminal = {
            _name = "red_alert_time_excavting_comeing_rule_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_excavting_comeing_change_page_terminal)
        state_machine.add(red_alert_time_excavting_comeing_rule_open_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_excavting_comeing state machine.
    init_red_alert_time_excavting_comeing_terminal()
end

function RedAlertTimeExcavtingComeing:onUpdateDraw()
    local root = self.roots[1]

    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")

    local Text_snatch_rebel_haunt_title = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_title")
    Text_snatch_rebel_haunt_title:setString(self._activity_type.activity_title)

    local Text_snatch_rebel_haunt_p_1 = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_p_1")
    Text_snatch_rebel_haunt_p_1:setString(self._activity_type.activity_dec)

    -- 结束和关闭倒计时
    self._is_end = false
    if ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))) < 0 then
        self._is_end = true
    end
    local time_str = activity_str_tip[93]
    if self._is_end == false then
        self.m_times = ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    else
        self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        time_str = activity_str_tip[179]
    end

    local Text_snatch_rebel_haunt_time_1 = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_time_1")
    Text_snatch_rebel_haunt_time_1:removeAllChildren(true)
    Text_snatch_rebel_haunt_time_1:setString("")
    local font_size = Text_snatch_rebel_haunt_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_snatch_rebel_haunt_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_snatch_rebel_haunt_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_snatch_rebel_haunt_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_snatch_rebel_haunt_time_1:addChild(time_int)
    self._label_close_text = time_int
    self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))

    -- 重置时间
    local Text_snatch_rebel_haunt_time_2 = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_time_2")
    Text_snatch_rebel_haunt_time_2:removeAllChildren(true)
    Text_snatch_rebel_haunt_time_2:setString("")
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    local time_info_2 = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_snatch_rebel_haunt_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_snatch_rebel_haunt_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_snatch_rebel_haunt_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_snatch_rebel_haunt_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_snatch_rebel_haunt_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_snatch_rebel_haunt_time_2:addChild(time_int_2)
    self._label_reset_text = time_int_2
    self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
end

function RedAlertTimeExcavtingComeing:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_snatch_rebel_haunt_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_snatch_rebel_haunt_tab_box")
    local Button_snatch_rebel_haunt = ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt")
    local Button_snatch_rebel_haunt_pack = ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_pack")
    if page == self._current_page then
        if page == 1 then
            Button_snatch_rebel_haunt:setHighlighted(true)
        elseif page == 2 then
            Button_snatch_rebel_haunt_pack:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_snatch_rebel_haunt:setHighlighted(false)
    Button_snatch_rebel_haunt_pack:setHighlighted(false)
    state_machine.excute("red_alert_time_excavting_comeing_collection_hide", 0, nil)
    state_machine.excute("red_alert_time_excavting_comeing_exchange_hide", 0, nil)
    if page == 1 then
        Button_snatch_rebel_haunt:setHighlighted(true)
        if self._turntable_panel == nil then
            self._turntable_panel = state_machine.excute("red_alert_time_excavting_comeing_collection_open", 0, {Panel_snatch_rebel_haunt_tab_box,self._activity_type.activity_type})
        else
            state_machine.excute("red_alert_time_excavting_comeing_collection_show", 0, nil)
        end
    elseif page == 2 then
        Button_snatch_rebel_haunt_pack:setHighlighted(true)
        if self._rule_panel == nil then
            self._rule_panel = state_machine.excute("red_alert_time_excavting_comeing_exchange_open", 0, {Panel_snatch_rebel_haunt_tab_box,self._activity_type.activity_type})
        else
            state_machine.excute("red_alert_time_excavting_comeing_exchange_show", 0, nil)
        end
    end

    self:onUpdateDraw()
end

function RedAlertTimeExcavtingComeing:onEnterTransitionFinish()

end

function RedAlertTimeExcavtingComeing:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.excavting_comeing)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_snatch_rebel_haunt_close"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    -- 歼灭叛军
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    -- 军火库
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_pack"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_snatch_rebel_haunt_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_rule_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:changeSelectPage(1)
end

function RedAlertTimeExcavtingComeing:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_text ~= nil then
            self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end

    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self._is_end == false then
                self:onUpdateDraw()
                state_machine.excute("red_alert_time_excavting_comeing_collection_updata", 0, "")
            else
                state_machine.excute("red_alert_time_center_find",0,"red_alert_time_excavting_comeing_window_close")
            end
        end
    end
end

function RedAlertTimeExcavtingComeing:init(params)
    self._activity_type = params[1]
    self:onInit()
    return self
end

function RedAlertTimeExcavtingComeing:onExit()
    state_machine.remove("red_alert_time_excavting_comeing_change_page")
    state_machine.remove("red_alert_time_excavting_comeing_rule_open")
end
