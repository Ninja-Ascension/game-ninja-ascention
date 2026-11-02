-- ------------------------------------------------------------------------------------------------------------
--  慷慨馈赠
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeLargesseGive = class("RedAlertTimeLargesseGiveClass", Window)

local red_alert_time_largesse_give_window_open_terminal = {
	_name = "red_alert_time_largesse_give_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeLargesseGiveClass") == nil then
        	fwin:open(RedAlertTimeLargesseGive:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local red_alert_time_largesse_give_window_close_terminal = {
	_name = "red_alert_time_largesse_give_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeLargesseGiveClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(red_alert_time_largesse_give_window_open_terminal)
state_machine.add(red_alert_time_largesse_give_window_close_terminal)
state_machine.init()

function RedAlertTimeLargesseGive:ctor()
	self.super:ctor()
	self.roots = {}
	-- 1.充值红包  2.慷慨排行  3.排行奖励
	self._list_type = 1
	self._store_tab = {}
	self._activity_type = nil
	
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLargesseGiveHotBuy")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLargesseGiveBuy")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLargesseGiveShop")

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecretRank")
	
	local function init_red_alert_time_largesse_give_terminal()
		local red_alert_time_largesse_give_change_store_page_terminal = {
			_name = "red_alert_time_largesse_give_change_store_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
		        instance._list_type = params._datas.index
                instance:changeStorePage()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(red_alert_time_largesse_give_change_store_page_terminal)
		state_machine.init()
	end
	init_red_alert_time_largesse_give_terminal()
end

function RedAlertTimeLargesseGive:updateDraw()
	local root = self.roots[1]
	self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
	--活动名
	local Text_recharge_bonus_name = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_name")    
	Text_recharge_bonus_name:setString(self._activity_type.activity_title)
end

function RedAlertTimeLargesseGive:changeStorePage()
	local root = self.roots[1]
	self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
	local Button_discount_store_hot_buy = ccui.Helper:seekWidgetByName(root,"Button_discount_store_hot_buy")
	local Button_discount_store_buy = ccui.Helper:seekWidgetByName(root,"Button_discount_store_buy")
	local Button_discount_store_shop = ccui.Helper:seekWidgetByName(root,"Button_discount_store_shop")
	local Panel_largesse_give_tab = ccui.Helper:seekWidgetByName(root,"Panel_largesse_give_tab")
	Button_discount_store_hot_buy:setHighlighted(false)
    Button_discount_store_hot_buy:setTouchEnabled(true)
    Button_discount_store_buy:setHighlighted(false)
    Button_discount_store_buy:setTouchEnabled(true)
    Button_discount_store_shop:setHighlighted(false)
    Button_discount_store_shop:setTouchEnabled(true)
  
    for k,v in pairs(self._store_tab) do
    	v:setVisible(false)
    end
    if self._list_type ==1 then
    	Button_discount_store_hot_buy:setHighlighted(true)
    	Button_discount_store_hot_buy:setTouchEnabled(false)
    	
    	if self._store_tab[""..self._list_type] == nil then
	    	local hot_buy_tab = state_machine.excute("red_alert_time_largesse_give_hot_buy_window_open", 0, {Panel_largesse_give_tab, self._activity_type})
	    	self._store_tab[""..self._list_type] = hot_buy_tab
	    else
	    	state_machine.excute("red_alert_time_largesse_give_hot_buy_show", 0, nil)
	    end	    
    elseif self._list_type ==2 then
    	Button_discount_store_buy:setHighlighted(true)
    	Button_discount_store_buy:setTouchEnabled(false)

    	if self._store_tab[""..self._list_type] == nil then
	    	local hot_buy_tab = state_machine.excute("red_alert_time_secret_rank_open", 0, {Panel_largesse_give_tab, self._activity_type})
	    	self._store_tab[""..self._list_type] = hot_buy_tab
	    else
	    	state_machine.excute("red_alert_time_secret_rank_show", 0, nil)
	    end
    elseif self._list_type ==3 then
    	Button_discount_store_shop:setHighlighted(true)
    	Button_discount_store_shop:setTouchEnabled(false)

    	if self._store_tab[""..self._list_type] == nil then
	    	local hot_buy_tab = state_machine.excute("red_alert_time_largesse_give_shop_window_open", 0, {Panel_largesse_give_tab, self._activity_type})
	    	self._store_tab[""..self._list_type] = hot_buy_tab
	    else
	    	state_machine.excute("red_alert_time_largesse_give_shop_show", 0, nil)
	    end
    end
end	

function RedAlertTimeLargesseGive:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.largesse_give)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_close"), nil, 
    {
        terminal_name = "red_alert_time_largesse_give_window_close", 
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    --充值红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_discount_store_hot_buy"), nil, 
    {
        terminal_name = "red_alert_time_largesse_give_change_store_page", 
        terminal_state = 0,
        touch_black = true,
        index = 1,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_largesse_get_reward",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_discount_store_hot_buy"),
        _invoke = nil,
        _interval = 0.3,})
    --慷慨排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_discount_store_buy"), nil, 
    {
        terminal_name = "red_alert_time_largesse_give_change_store_page", 
        terminal_state = 0,
        touch_black = true,
        index = 2,
    },
    nil,1)
    --排行奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_discount_store_shop"), nil, 
    {
        terminal_name = "red_alert_time_largesse_give_change_store_page", 
        terminal_state = 0,
        touch_black = true,
        index = 3,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_largesse_give_rank",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_discount_store_shop"),
        _invoke = nil,
        _interval = 0.3,})

    self:updateDraw()
    self:changeStorePage()
end

function RedAlertTimeLargesseGive:init(params)
	self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeLargesseGive:onExit()
    state_machine.remove("red_alert_time_largesse_give_change_store_page")
end