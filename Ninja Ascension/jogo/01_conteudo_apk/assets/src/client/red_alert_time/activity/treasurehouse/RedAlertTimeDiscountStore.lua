-----------------------------
--折扣卖场
-----------------------------
RedAlertTimeDiscountStore = class("RedAlertTimeDiscountStoreClass", Window)

local red_alert_time_discount_store_window_open_terminal = {
    _name = "red_alert_time_discount_store_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local activity_info = _ED.activity_info[""..params[1].activity_type]
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("RedAlertTimeDiscountStoreClass") then
                    fwin:open(RedAlertTimeDiscountStore:new():init(params), fwin._ui)
                    return panel
                end 
            end
        end     
        protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_discount_store_window_close_terminal = {
    _name = "red_alert_time_discount_store_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.show_reward_list_group_ex = {}
        fwin:close(fwin:find("RedAlertTimeDiscountStoreClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_discount_store_window_open_terminal)
state_machine.add(red_alert_time_discount_store_window_close_terminal)
state_machine.init()

function RedAlertTimeDiscountStore:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil 
    self._current_page = 0
    self._transfer_panel = nil
    self._shop_panel = nil
    self.m_times = 0
    self.page_two_is_open = false
	
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDiscountStoreTransfer")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDiscountStoreFavorable")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDiscountStoreTicket")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDiscountStoreShop")
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_discount_store_shop_cell")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    app.load("client.red_alert_time.props.PropsBatchBuy")
	
    --load lua file
    -- Initialize red_alert_time_discount_store state machine.
    local function init_red_alert_time_discount_store_terminal()
    
        -- 切换界面
        local red_alert_time_discount_store_change_page_terminal = {
          _name = "red_alert_time_discount_store_change_page",
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
         --购买
        local red_alert_time_discount_store_transfer_buy_goods_terminal = {
            _name = "red_alert_time_discount_store_transfer_buy_goods",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local acitvity = _ED.activity_info[""..instance._activity_type.activity_type]
                local cell = params[1]
                local index = params[2]
                local page = params[3]
                local number = ""
                if params[4] ~= nil then
                    number = params[4]
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("props_batch_buy_window_close", 0, "")
                        checkRewardObtainDraw()
                        if page == 1 or page == 2 then
                            state_machine.excute("red_alert_time_discount_store_favorable_update", 0 , cell)
                        else
                            state_machine.excute("red_alert_time_discount_store_shop_cell_update_info", 0 , cell)
                        end
                    else
                        --购买失败则刷新商品
                        protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n"..(page -1).."\r\n".."0".."\r\n".."2"
                        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n"..(page - 1).."\r\n"..(index - 1).."\r\n".."0".."\r\n"..number
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_discount_store_transfer_buy_goods_terminal)
        state_machine.add(red_alert_time_discount_store_change_page_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_discount_store state machine.
    init_red_alert_time_discount_store_terminal()
end

function RedAlertTimeDiscountStore:showCurrentPage()
    state_machine.excute("red_alert_time_discount_store_transfer_hide", 0, nil)
    state_machine.excute("red_alert_time_discount_store_shop_hide", 0, nil)
    if self._current_page == 1 or self._current_page == 2 then
        state_machine.excute("red_alert_time_discount_store_transfer_show", 0, self._current_page)
    else
        state_machine.excute("red_alert_time_discount_store_shop_show", 0, nil)
    end
end

function RedAlertTimeDiscountStore:changeSelectPage( page )
    local root = self.roots[1]
    --标题
    ccui.Helper:seekWidgetByName(root, "Text_discount_store_tit"):setString(self._activity_type.activity_title)
    
    local Panel_discount_store_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_discount_store_tab_box")
    local Button_discount_store_hot_buy = ccui.Helper:seekWidgetByName(root, "Button_discount_store_hot_buy")
    local Button_discount_store_buy = ccui.Helper:seekWidgetByName(root, "Button_discount_store_buy")
    local Button_discount_store_shop = ccui.Helper:seekWidgetByName(root, "Button_discount_store_shop")
    if page == self._current_page then
        if page == 1 then
            Button_discount_store_hot_buy:setHighlighted(true)
        elseif page == 2 then
            Button_discount_store_buy:setHighlighted(true)
        elseif page == 3 then
            Button_discount_store_shop:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    --Button_discount_store:setHighlighted(false)
    Button_discount_store_hot_buy:setHighlighted(false)
    Button_discount_store_buy:setHighlighted(false)
    Button_discount_store_shop:setHighlighted(false)
    local function push_update( page )
        if discountStorePagePush(page) == true then
            local nextPushTime = _ED.treasure_discount_store_info[page - 1].reset_times/1000 - (os.time()-_ED.treasure_discount_store_info[page - 1].time) + os.time()
            cc.UserDefault:getInstance():setStringForKey(getKey("activity_id_"..self._activity_type.activity_type.."_"..page), nextPushTime)
            cc.UserDefault:getInstance():flush()
            state_machine.excute("notification_center_update", 0, "push_notification_mine_treasure_push")
            state_machine.excute("red_alert_time_center_update_push", 0, self._activity_type.activity_type)
            state_machine.excute("notification_center_update", 0, "push_notification_discount_store_page_push")
            state_machine.excute("treasure_discount_store_push_update",0,"treasure_discount_store_push_update.")
        end
    end
    local function open_page( page )
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    if page == 1 then
                        response.node._transfer_panel = state_machine.excute("red_alert_time_discount_store_transfer_open", 0, {Panel_discount_store_tab_box,response.node._activity_type})
                    elseif page == 2 then
                        response.node.page_two_is_open = true
                        state_machine.excute("red_alert_time_discount_store_transfer_show", 0, page)
                    else
                        response.node._shop_panel = state_machine.excute("red_alert_time_discount_store_shop_open", 0, {Panel_discount_store_tab_box,response.node._activity_type})
                    end
                    response.node:showCurrentPage()
                    push_update(page)
                end
            end
        end     
        protocol_command.draw_activity_reward.param_list = self._activity_type.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n"..(tonumber(page)-1).."\r\n".."0".."\r\n".."2"
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)
    end
    
    if page == 1 then
        Button_discount_store_hot_buy:setHighlighted(true)
        if self._transfer_panel == nil then
            self._transfer_panel = state_machine.excute("red_alert_time_discount_store_transfer_open", 0, {Panel_discount_store_tab_box,self._activity_type})
        else
            self:showCurrentPage()
            push_update(page)
        end
    elseif page == 2 then
        Button_discount_store_buy:setHighlighted(true)
        if self.page_two_is_open == false then
            open_page(2)
        else
            self:showCurrentPage()
            push_update(page)
        end
    elseif page == 3 then
        Button_discount_store_shop:setHighlighted(true)
        if self._shop_panel == nil then
            open_page(3)
        else
            self:showCurrentPage()
            push_update(page)
        end
    end
end

function RedAlertTimeDiscountStore:onEnterTransitionFinish()

end

function RedAlertTimeDiscountStore:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.discount_store)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_discount_store_close"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_hot_buy"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_discount_store_page_push",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_discount_store_hot_buy"),
    _invoke = nil,
    _index = 1,
    _interval = 0.3,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_buy"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_discount_store_page_push",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_discount_store_buy"),
    _invoke = nil,
    _index = 2,
    _interval = 0.3,})


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_shop"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_discount_store_page_push",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_discount_store_shop"),
    _invoke = nil,
    _index = 3,
    _interval = 0.3,})

    self:changeSelectPage(1)

    local timesData = zstring.split(self._activity_type.activity_add_state, ",")
    self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

end

function RedAlertTimeDiscountStore:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt

        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_discount_store_window_close")
        end
    end
end


function RedAlertTimeDiscountStore:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeDiscountStore:onExit()
    state_machine.remove("red_alert_time_discount_store_change_page")
    state_machine.remove("red_alert_time_discount_store_transfer_buy_goods")
end
