--------------------------------------------------------------------------------------------------------------
--  说明：折扣卖场界面1,界面2
--------------------------------------------------------------------------------------------------------------
RedAlertTimeDiscountStoreTransfer = class("RedAlertTimeDiscountStoreTransferClass", Window)

--打开界面
local red_alert_time_discount_store_transfer_open_terminal = {
	_name = "red_alert_time_discount_store_transfer_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeDiscountStoreTransferClass") == nil then
    		fwin:open(RedAlertTimeDiscountStoreTransfer:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_discount_store_transfer_close_terminal = {
	_name = "red_alert_time_discount_store_transfer_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeDiscountStoreTransferClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_discount_store_transfer_open_terminal)
state_machine.add(red_alert_time_discount_store_transfer_close_terminal)
state_machine.init()

function RedAlertTimeDiscountStoreTransfer:ctor()
	self.super:ctor()
	self.roots = {}
    self._activity_type = nil
    self.m_times = 0
    self.time_text = nil
    self.m_reset_times_1 = 0 
    self.m_reset_times_2 = 0 
    self.text_reset_times = nil
    self.page = 1
    self._ticket_panel = nil
    self._one_favorable_panel = nil
    self._two_favorable_panel = nil
    self.bug_goods_time = 0
    self.wait_time = 0
    self.page_two_type = 0
    self.goods_updata_reset_time = 0
    self.page_two_updata_time = 0
	
    local function init_red_alert_time_discount_store_transfer_terminal()
        local red_alert_time_discount_store_transfer_show_terminal = {
            _name = "red_alert_time_discount_store_transfer_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                state_machine.excute("red_alert_time_discount_store_transfer_change_page",0,params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_discount_store_transfer_hide_terminal = {
            _name = "red_alert_time_discount_store_transfer_hide",
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
        -- 切换界面
        local red_alert_time_discount_store_transfer_change_page_terminal = {
            _name = "red_alert_time_discount_store_transfer_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.page = params
                instance:changePage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 规则
        local red_alert_time_discount_store_transfer_rule_open_terminal = {
            _name = "red_alert_time_discount_store_transfer_rule_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,103)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         -- 刷新
        local red_alert_time_discount_store_transfer_update_terminal = {
            _name = "red_alert_time_discount_store_transfer_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if params == 1 then
                        state_machine.excute("red_alert_time_discount_store_favorable_update" , 0 , instance._one_favorable_panel)
                    else
                        state_machine.excute("red_alert_time_discount_store_favorable_update" , 0 , instance._two_favorable_panel)
                    end
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_discount_store_transfer_update_terminal)
        state_machine.add(red_alert_time_discount_store_transfer_show_terminal)
        state_machine.add(red_alert_time_discount_store_transfer_hide_terminal)
        state_machine.add(red_alert_time_discount_store_transfer_change_page_terminal)
        state_machine.add(red_alert_time_discount_store_transfer_rule_open_terminal)
        state_machine.init()
    end
    init_red_alert_time_discount_store_transfer_terminal()
end

function RedAlertTimeDiscountStoreTransfer:changePage()
    local root = self.roots[1]
    local Panel_discount_store_box = ccui.Helper:seekWidgetByName(root, "Panel_discount_store_box")
    if self._one_favorable_panel ~= nil then
        self._one_favorable_panel:setVisible(false)
    end
    if self._two_favorable_panel ~= nil then
        self._two_favorable_panel:setVisible(false)
    end
    if self._ticket_panel ~= nil then
        self._ticket_panel:setVisible(false)
    end
    if self.page == 1 then
        if self._one_favorable_panel == nil then
            self._one_favorable_panel = state_machine.excute("red_alert_time_discount_store_favorable_open", 0, {self._activity_type,1})
            Panel_discount_store_box:addChild(self._one_favorable_panel)
        else
            self._one_favorable_panel:setVisible(true)
        end
        self.text_reset_times:getChildByTag(100):setVisible(true)
        if self.text_reset_times:getChildByTag(300) ~= nil then
            self.text_reset_times:getChildByTag(300):setVisible(false)
        end
    elseif self.page == 2 then
        self.m_reset_times_2 = ((tonumber(_ED.treasure_discount_store_info[1].reset_times)/1000)-(os.time()-_ED.treasure_discount_store_info[1].time))
        if self._two_favorable_panel == nil and self._ticket_panel == nil then
            local Text_discount_store_p = ccui.Helper:seekWidgetByName(root,"Text_discount_store_p")
            local font_size = Text_discount_store_p:getFontSize()
            local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
            reset_time_int:setName("reset_time_int")
            reset_time_int:setAnchorPoint(cc.p(0, 0.5))
            reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
            reset_time_int:setPositionX(Text_discount_store_p:getPositionX())
            reset_time_int:setPositionY(Text_discount_store_p:getContentSize().height / 2)
            reset_time_int:setTag(300)
            Text_discount_store_p:addChild(reset_time_int)
        end
        self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
        local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"|")
        local time_info = zstring.split(activity_add_state_arry[2],",")
        self.bug_goods_time = tonumber(time_info[4]) -- 购买时间
        self.wait_time = tonumber(time_info[5]) -- 等待时间
        self.page_two_updata_time = tonumber(time_info[2]) * 60
        self.goods_updata_reset_time = self.m_reset_times_2 - tonumber(time_info[5]) * 60
        if self.goods_updata_reset_time <= 0 then
            self.goods_updata_reset_time = self.goods_updata_reset_time + tonumber(time_info[2]) * 60
        end
        local function open_page( index )
            self.page_two_type = index
            if index == 1 or index == 3 then
                if self._ticket_panel == nil then
                    self._ticket_panel = state_machine.excute("red_alert_time_discount_store_ticket_open", 0, {self._activity_type, self.page_two_type})
                    Panel_discount_store_box:addChild(self._ticket_panel)
                else
                    self._ticket_panel:setVisible(true)
                end
            else
                if self._two_favorable_panel == nil then
                    self._two_favorable_panel = state_machine.excute("red_alert_time_discount_store_favorable_open", 0, {self._activity_type,2})
                    Panel_discount_store_box:addChild(self._two_favorable_panel)
                else
                    self._two_favorable_panel:setVisible(true)
                end
            end
        end
        local isHaveTicket = false
        local activity_add_state = zstring.split(activity_add_state_arry[1],",")
        if tonumber(activity_add_state[6]) == 1 then --已经抢过了
            isHaveTicket = true
        end
        if self.m_reset_times_2 > tonumber(self.wait_time + self.bug_goods_time) * 60 then
            if isHaveTicket == false then
                open_page(1)
            else
                open_page(2)
            end
        elseif self.m_reset_times_2 > tonumber(self.wait_time) * 60 then
            open_page(2)
        else
            open_page(3)
        end
        self.text_reset_times:getChildByTag(100):setVisible(false)
        self.text_reset_times:getChildByTag(300):setVisible(true)
    end
end

function RedAlertTimeDiscountStoreTransfer:updateDraw()
    local root = self.roots[1]
    --信息
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]

    local Text_discount_store_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_discount_store_infor_p_1")
	Text_discount_store_infor_p_1:setString(self._activity_type.activity_dec)
	-- 时间
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_arry[1],",")
    local time_str = activity_str_tip[93]
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    -- 关闭倒计时
    local Text_discount_store_time_t_1 = ccui.Helper:seekWidgetByName(root,"Text_discount_store_time_t_1")
    Text_discount_store_time_t_1:removeAllChildren(true)
    Text_discount_store_time_t_1:setString("")
    Text_discount_store_time_t_1:setVisible(true)
    local font_size = Text_discount_store_time_t_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_discount_store_time_t_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_discount_store_time_t_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_discount_store_time_t_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_discount_store_time_t_1:addChild(time_int)
    self.time_text = Text_discount_store_time_t_1

    --重置倒计时
    local Text_discount_store_p = ccui.Helper:seekWidgetByName(root,"Text_discount_store_p")
    self.m_reset_times_1 = ((tonumber(_ED.treasure_discount_store_info[0].reset_times)/1000)-(os.time()-_ED.treasure_discount_store_info[0].time))
    Text_discount_store_p:removeAllChildren(true)
    Text_discount_store_p:setString("")
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_discount_store_p:getPositionX())
    reset_time_int:setPositionY(Text_discount_store_p:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_discount_store_p:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[136], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_discount_store_p:getPositionX())
    reset_time_info:setPositionY(Text_discount_store_p:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_discount_store_p:addChild(reset_time_info)
    self.text_reset_times = Text_discount_store_p

    self:changePage()
end

--初始化
function RedAlertTimeDiscountStoreTransfer:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.discount_store_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_transfer_rule_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
     
    self:updateDraw()
end

function RedAlertTimeDiscountStoreTransfer:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.time_text ~= nil and self.time_text:getChildByTag(100) ~= nil then
            self.time_text:getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
    end
    if self.m_reset_times_1 > 0 then
        self.m_reset_times_1 = self.m_reset_times_1 - dt
        if self.text_reset_times ~= nil and self.text_reset_times:getChildByTag(100) ~= nil then
            self.text_reset_times:getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times_1))
        end
        if self.m_reset_times_1 <= 0 then
            self.m_reset_times_1 = 0
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("red_alert_time_discount_store_transfer_update",0,1)
                end
            end     
            protocol_command.draw_activity_reward.param_list = self._activity_type.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
            NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)
        end
    end
    if self.goods_updata_reset_time > 0 then
        self.goods_updata_reset_time = self.goods_updata_reset_time - dt
        if self.goods_updata_reset_time <= 0 then
            self.goods_updata_reset_time = self.goods_updata_reset_time + self.page_two_updata_time
        end
        if self.text_reset_times ~= nil and self.text_reset_times:getChildByTag(300) ~= nil then
            self.text_reset_times:getChildByTag(300):setString(getRedAlertTimeActivityFormat(self.goods_updata_reset_time))
        end
    end
    if self.m_reset_times_2 > 0 then
        self.m_reset_times_2 = self.m_reset_times_2 - dt
        if self.page_two_type == 1 and self.m_reset_times_2 < tonumber(self.wait_time + self.bug_goods_time) * 60 then
            self:changePage()
        elseif self.page_two_type == 2 and self.m_reset_times_2 < tonumber(self.wait_time) * 60 then
            self:changePage()
            state_machine.excute("red_alert_time_discount_store_ticket_update",0,3)
        end
        if self.m_reset_times_2 <= 0 then
            self.m_reset_times_2 = 0
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("red_alert_time_discount_store_transfer_update",0,2)
                    state_machine.excute("red_alert_time_discount_store_ticket_update",0,1)
                    self:changePage()
                end
            end     
            protocol_command.draw_activity_reward.param_list = self._activity_type.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."1".."\r\n".."0".."\r\n".."2"
            NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)
        end
    end
end

function RedAlertTimeDiscountStoreTransfer:onEnterTransitionFinish()

end

function RedAlertTimeDiscountStoreTransfer:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeDiscountStoreTransfer:onExit()
    state_machine.remove("red_alert_time_discount_store_transfer_show")
    state_machine.remove("red_alert_time_discount_store_transfer_hide")
    state_machine.remove("red_alert_time_discount_store_transfer_change_page")
    state_machine.remove("red_alert_time_discount_store_transfer_rule_open")
    state_machine.remove("red_alert_time_discount_store_transfer_update")
end