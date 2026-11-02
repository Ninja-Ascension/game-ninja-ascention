-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸购买次数
-------------------------------------------------------------------------------------------------------
ArenaDearonNumberOfPurchases = class("ArenaDearonNumberOfPurchasesClass", Window)

local arena_dearon_number_of_purchases_open_terminal = {
    _name = "arena_dearon_number_of_purchases_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaDearonNumberOfPurchasesClass")
        if nil == _homeWindow then
    		fwin:open(ArenaDearonNumberOfPurchases:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_dearon_number_of_purchases_close_terminal = {
    _name = "arena_dearon_number_of_purchases_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaDearonNumberOfPurchasesClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaDearonNumberOfPurchasesClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_dearon_number_of_purchases_open_terminal)
state_machine.add(arena_dearon_number_of_purchases_close_terminal)
state_machine.init()
    
function ArenaDearonNumberOfPurchases:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self._select_num = 0
	self._max_select_num = 0
	
	local function init_arena_dearon_number_of_purchases_terminal()

		local arena_dearon_number_of_purchases_num_add_terminal = {
            _name = "arena_dearon_number_of_purchases_num_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num + 1
                if select_num > instance._max_select_num then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_dearon_number_of_purchases_num_mimus_terminal = {
            _name = "arena_dearon_number_of_purchases_num_mimus",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num - 1
                if select_num < 0 then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_dearon_number_of_purchases_over_update_terminal = {
			_name = "arena_dearon_number_of_purchases_over_update",
			_init = function (terminal) 
			
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local Slider_num = ccui.Helper:seekWidgetByName(instance.roots[1], "Slider_buy_num")
				local select_num = math.ceil(tonumber(Slider_num:getPercent()) * instance._max_select_num / 100)
				instance:setSelectNum(select_num)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		--购买次数
		local arena_dearon_number_of_purchases_over_buy_number_terminal = {
			_name = "arena_dearon_number_of_purchases_over_buy_number",
			_init = function (terminal) 
			
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
                if instance._select_num > instance._max_select_num then
                    instance._select_num = instance._max_select_num
                end
				local function responseCallback( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("arena_dearon_tab_update_attack", 0, 0) 
						state_machine.excute("arena_dearon_number_of_purchases_close", 0, 0) 
                        TipDlg.drawTextDailog(red_alert_time_str[184])
					end
				end

				protocol_command.buy_arena_launch_count.param_list = "0".."\r\n"..instance._select_num
				NetworkManager:register(protocol_command.buy_arena_launch_count.code, nil, nil, nil, self, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		
		state_machine.add(arena_dearon_number_of_purchases_over_update_terminal)
		state_machine.add(arena_dearon_number_of_purchases_over_buy_number_terminal)
		state_machine.add(arena_dearon_number_of_purchases_num_add_terminal)
		state_machine.add(arena_dearon_number_of_purchases_num_mimus_terminal)
		state_machine.init()
	end
	
	init_arena_dearon_number_of_purchases_terminal()
	
end

function ArenaDearonNumberOfPurchases:onUpdateDraw()
	local root = self.roots[1]
	
end

function ArenaDearonNumberOfPurchases:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end

    local percent = math.floor(self._select_num * 100 / self._max_select_num)
    self:updateSliderInfo(percent)
end

function ArenaDearonNumberOfPurchases:updateSliderInfo(percent)
    local root = self.roots[1]
    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_buy_num")
    --选择的次数
	local Text_buy_time_n = ccui.Helper:seekWidgetByName(root, "Text_buy_time_n")
    local Text_buy_time_p_2 = ccui.Helper:seekWidgetByName(root, "Text_buy_time_p_2")
    Text_buy_time_p_2:setString(string.format(red_alert_time_str[203], self._max_select_num))
	
	--消耗的金币
	local Text_consume_buy_time_n = ccui.Helper:seekWidgetByName(root, "Text_consume_buy_time_n")
    self._current_silder = percent

    if self._max_select_num > 0 and self._select_num == 0 then
        self._select_num = 1
    end

    local cost = zstring.split(dms.string(dms["arena_config"], 4, arena_config.param), ",")
    -- state_machine.excute("build_up_make_production_cell_update_level", 0, self._select_num)
    Text_buy_time_n:setString(self._select_num)
    local need_gold = 0
    for i=_ED.arena_info.buy_attack_count+1,_ED.arena_info.buy_attack_count+self._select_num do
        if i >= #cost then
            need_gold = need_gold + cost[#cost]
        else
            need_gold = need_gold + cost[i]
        end
    end

    Text_consume_buy_time_n:setString(need_gold)
    Slider_num:setPercent(self._current_silder)
end

function ArenaDearonNumberOfPurchases:init(params)
	self._params = params
    self:onInit()
    return self
end

function ArenaDearonNumberOfPurchases:onInit()
    local csbArenaDearonNumberOfPurchases = csb.createNode(config_csb.arena.arena_dearon_time_buy)
    local root = csbArenaDearonNumberOfPurchases:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaDearonNumberOfPurchases)
	
	--确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack_buy_time_sure"), nil, 
    {
        terminal_name = "arena_dearon_number_of_purchases_over_buy_number", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--取消
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack_buy_time_cancel"), nil, 
    {
        terminal_name = "arena_dearon_number_of_purchases_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_time_close"), nil, 
    {
        terminal_name = "arena_dearon_number_of_purchases_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "arena_dearon_number_of_purchases_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	
	-- 增加
	-- local Button_buy_minus = ccui.Helper:seekWidgetByName(root, "Button_buy_add")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_add"), nil, 
    {
        terminal_name = "arena_dearon_number_of_purchases_num_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 减少
	-- local Button_buy_minus = ccui.Helper:seekWidgetByName(root, "Button_buy_minus")
	-- local function buttonBuyMinusTouchListener(sender, eventType)
		-- print("eventType=="..eventType)
		-- if eventType == ccui.TouchEventType.began then
			-- state_machine.excute("arena_dearon_number_of_purchases_num_mimus",0,0)
		-- end
	-- end
	-- Button_buy_minus:addTouchEventListener(buttonBuyMinusTouchListener)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_minus"), nil, 
    {
        terminal_name = "arena_dearon_number_of_purchases_num_mimus", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--计算最大值
    local max_count = dms.int(dms["base_consume"], 92, base_consume.vip_0_value + tonumber(_ED.vip_grade))
	self._max_select_num = max_count - zstring.tonumber(_ED.arena_info.buy_attack_count)
	
	-- local Slider_buy_num
	-- 滑动选择
    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_buy_num")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("arena_dearon_number_of_purchases_over_update", 0, {sender:getPercent()})
        end
    end
    Slider_num:addEventListener(percentChangedEvent)
	
	
	self:setSelectNum(1)
end

function ArenaDearonNumberOfPurchases:onExit()
	state_machine.remove("arena_dearon_number_of_purchases_num_add")
    state_machine.remove("arena_dearon_number_of_purchases_num_mimus")
    state_machine.remove("arena_dearon_number_of_purchases_over_update")
    state_machine.remove("arena_dearon_number_of_purchases_over_buy_number")
end