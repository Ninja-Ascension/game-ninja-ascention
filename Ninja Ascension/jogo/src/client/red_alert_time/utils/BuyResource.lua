-----------------------------
--购买资源
-----------------------------
BuyResource = class("BuyResourceClass", Window)

local buy_resource_window_open_terminal = {
    _name = "buy_resource_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(61) == true then
            return
        end
        local _window = fwin:find("BuyResourceClass")
        if nil == _window then
            local resource_type = params._datas.resource_type
            fwin:open(BuyResource:new():init(resource_type), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local buy_resource_window_close_terminal = {
    _name = "buy_resource_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuyResourceClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(buy_resource_window_open_terminal)
state_machine.add(buy_resource_window_close_terminal)
state_machine.init()

function BuyResource:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self.resource_type = nil  -- 1 体力 2 -- 军粮
    self.max_times = nil
    self.now_times = nil
    self.select_times = nil
    self.need_gem = nil
    self.buy_resource_data_table = {}
    -- Initialize BuyResource state machine.
    local function init_buy_resource_terminal()

        --购买
        local buy_resource_sure_terminal = {
            _name = "buy_resource_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseBuyResourceCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.canBuyNumberString ~= nil then
                            response.node.now_times = zstring.tonumber(_ED.food_ready_buy_times)
                            response.node:canBuyNumberString()
                            state_machine.excute("buy_resource_close",0,"")
                        end
                    end
                end

                if zstring.tonumber(instance.need_gem) > tonumber(_ED.user_info.user_gold) then
                    -- print("======宝石不够")
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end
                if instance.now_times >= instance.max_times then
                    TipDlg.drawTextDailog(red_alert_all_str[39])
                    return
                end
                                
                if instance.resource_type == 1 then
                     protocol_command.basic_consumption.param_list = "".."59".."\r\n" .. instance.select_times
                     NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil,instance, responseBuyResourceCallback, false, nil)
                elseif  instance.resource_type == 2 then
                    -- provisions_buy
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --加一
        local buy_resource_add_one_terminal = {
            _name = "buy_resource_add_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.select_times >= instance.max_times - instance.now_times then
                    return
                end
                instance.select_times = instance.select_times + 1
                instance:setBuyNumberString()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --减一
        local buy_resource_remove_one_terminal = {
            _name = "buy_resource_remove_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.select_times == 1 then
                    return
                end
                instance.select_times = instance.select_times - 1
                instance:setBuyNumberString()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --关闭界面
        local buy_resource_close_terminal = {
            _name = "buy_resource_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onWindowClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(buy_resource_sure_terminal)
        state_machine.add(buy_resource_add_one_terminal)
        state_machine.add(buy_resource_remove_one_terminal)
        state_machine.add(buy_resource_close_terminal) 
        state_machine.init()
    end
    
    -- call func init BuyResource state machine.
    init_buy_resource_terminal()
end

function BuyResource:initDatas( )
    local max_times = dms.int(dms["base_consume"],59,base_consume.vip_0_value + tonumber(_ED.vip_grade))
    self.max_times = max_times
    self.now_times = zstring.tonumber(_ED.food_ready_buy_times)
    self.select_times = 1
    self.need_gem = 0

    local pirates_config_str = dms.string(dms["shop_config"],4,shop_config.param)
    local pirates_config_tab = zstring.split(pirates_config_str,"|")
    for i,v in pairs(pirates_config_tab) do
        local times_str = v
        local times_str_tab = zstring.split(v,",")
        local times_tab = 
        {
            times = times_str_tab[1],
            need_gems = times_str_tab[2],
            add_food = times_str_tab[3]
        }
        table.insert(self.buy_resource_data_table,times_tab)
    end
end

function BuyResource:setBuyNumberString()
    local root = self.roots[1]
    local Text_buy_power_number = ccui.Helper:seekWidgetByName(root,"Text_buy_power_number")
    Text_buy_power_number:setString(self.select_times)
    local Text_get_power = ccui.Helper:seekWidgetByName(root,"Text_get_power")
    local Text_consume_power = ccui.Helper:seekWidgetByName(root,"Text_consume_power")

    local will_add_food = 0
    local will_need_gem = 0
    local add_times = 0
    for i,v in pairs(self.buy_resource_data_table) do
        if add_times == self.select_times then
            break
        end
        if i > self.now_times then
            will_add_food = v.add_food + will_add_food
            will_need_gem = v.need_gems + will_need_gem
            add_times = add_times + 1            
        end
    end
    self.need_gem = will_need_gem
    Text_get_power:setString(will_add_food)
    Text_consume_power:setString(will_need_gem)
    -- debug.print_r(self.buy_resource_data_table)
end

function BuyResource:canBuyNumberString()
    local root = self.roots[1]
    local Text_buy_power_time = ccui.Helper:seekWidgetByName(root,"Text_buy_power_time")
    Text_buy_power_time:setString(self.now_times .. "/" ..  self.max_times)
end

function BuyResource:onUpdateDraw()
    local root = self.roots[1]
    
end

function BuyResource:onEnterTransitionFinish()

end

-- 关闭购买界面
function BuyResource:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("buy_resource_window_close", 0, "")
        end
    end)
end

function BuyResource:onInit( )
    local csbItem = csb.createNode(config_csb.utils.buy_resource)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.utils.buy_resource)
    table.insert(self.actions, action)
    action:setTimeSpeed(app.getTimeSpeed())
    action:play("window_open", false)
    csbItem:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then

        end  
    end)

    local Button_power_add = ccui.Helper:seekWidgetByName(root,"Button_power_add") 
    local Button_power_subtract = ccui.Helper:seekWidgetByName(root,"Button_power_subtract") 
    local Button_buy_power_close = ccui.Helper:seekWidgetByName(root,"Button_buy_power_close")
    local Button_buy_power = ccui.Helper:seekWidgetByName(root,"Button_buy_power")
    -- 关闭
    fwin:addTouchEventListener(Button_buy_power_close, nil, 
    {
        terminal_name = "buy_resource_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_buy_power_out") , nil, 
    {
        terminal_name = "buy_resource_close", 
        terminal_state = 0, 
    }, nil, 0)
    -- 加一
    fwin:addTouchEventListener(Button_power_add, nil, 
    {
        terminal_name = "buy_resource_add_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 减一
    fwin:addTouchEventListener(Button_power_subtract, nil, 
    {
        terminal_name = "buy_resource_remove_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    -- buy
    fwin:addTouchEventListener(Button_buy_power, nil, 
    {
        terminal_name = "buy_resource_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    self:initDatas()
    self:setBuyNumberString()
    self:canBuyNumberString()
	self:onUpdateDraw()	
end

function BuyResource:init(resource_type)
    self.resource_type = resource_type
    -- print("==resource_type==",resource_type)
	self:onInit()
    return self
end

function BuyResource:onExit()
    state_machine.remove("buy_resource_sure")
    state_machine.remove("buy_resource_add_one")
    state_machine.remove("buy_resource_remove_one")
    state_machine.remove("buy_resource_close")
end
