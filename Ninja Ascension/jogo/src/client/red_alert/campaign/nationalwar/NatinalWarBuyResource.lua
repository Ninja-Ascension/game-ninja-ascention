-----------------------------
--购买粮草资源
-----------------------------
NatinalWarBuyResource = class("NatinalWarBuyResourceClass", Window)

local natinal_war_buy_resource_window_open_terminal = {
    _name = "natinal_war_buy_resource_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _window = fwin:find("NatinalWarBuyResourceClass")
        if nil == _window then
            fwin:open(NatinalWarBuyResource:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local natinal_war_buy_resource_window_close_terminal = {
    _name = "natinal_war_buy_resource_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NatinalWarBuyResourceClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(natinal_war_buy_resource_window_open_terminal)
state_machine.add(natinal_war_buy_resource_window_close_terminal)
state_machine.init()

function NatinalWarBuyResource:ctor()
    self.super:ctor()
    self.roots = {}
    self.select_times = 1
    self.need_gem = 100
    self.one_time_need_gem = nil
    -- Initialize BuyResource state machine.
    local function init_natinal_war_buy_resource_terminal()

        --购买
        local natinal_war_buy_resource_sure_terminal = {
            _name = "natinal_war_buy_resource_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseBuyResourceCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[44])
                        state_machine.excute("natinal_war_buy_resource_window_close",0,"")
                    end
                end

                if zstring.tonumber(instance.need_gem) > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end
                -- print("===========",instance.select_times)
                protocol_command.provisions_buy.param_list = ""..instance.select_times
                NetworkManager:register(protocol_command.provisions_buy.code, nil, nil, nil,instance, responseBuyResourceCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --加一
        local natinal_war_buy_resource_add_one_terminal = {
            _name = "natinal_war_buy_resource_add_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.select_times = instance.select_times + 1
                instance:setBuyNumberString()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --减一
        local natinal_war_buy_resource_remove_one_terminal = {
            _name = "natinal_war_buy_resource_remove_one",
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
        state_machine.add(natinal_war_buy_resource_sure_terminal)
        state_machine.add(natinal_war_buy_resource_add_one_terminal)
        state_machine.add(natinal_war_buy_resource_remove_one_terminal)
        state_machine.init()
    end
    
    -- call func init BuyResource state machine.
    init_natinal_war_buy_resource_terminal()
end

function NatinalWarBuyResource:onUpdateDraw()
    local root = self.roots[1]
    local Text_buy_power_title = ccui.Helper:seekWidgetByName(root,"Text_buy_power_title")
    Text_buy_power_title:setString(red_alert_all_str[70])
    local Text_buy_power_2 = ccui.Helper:seekWidgetByName(root,"Text_buy_power_2")
    Text_buy_power_2:setVisible(false)
    local Text_buy_power_time = ccui.Helper:seekWidgetByName(root,"Text_buy_power_time")
    Text_buy_power_time:setVisible(false)
    local Text_buy_power_t = ccui.Helper:seekWidgetByName(root,"Text_buy_power_t")
    Text_buy_power_t:setString(red_alert_all_str[71])
    local Text_buy_power_4 = ccui.Helper:seekWidgetByName(root,"Text_buy_power_4")
    Text_buy_power_4:setString(red_alert_all_str[72])
    -- 313 国战购买x粮草需要钻石数                313 1000,100
    local one_time_need_gem = nil
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        one_time_need_gem = dms.string(dms["pirates_config"],317,pirates_config.param)
    else
        one_time_need_gem = dms.string(dms["pirates_config"],313,pirates_config.param)
    end
    one_time_need_gem = zstring.split(one_time_need_gem,",")
    self.one_time_need_gem = tonumber(one_time_need_gem[2])
    self.one_time_add = tonumber(one_time_need_gem[1])

end

function NatinalWarBuyResource:setBuyNumberString()
    local root = self.roots[1]
    local Text_buy_power_number = ccui.Helper:seekWidgetByName(root,"Text_buy_power_number")
    Text_buy_power_number:setString(self.select_times)
    local Text_consume_power = ccui.Helper:seekWidgetByName(root,"Text_consume_power") -- 需要消耗
    local Text_get_power = ccui.Helper:seekWidgetByName(root,"Text_get_power") -- 获得
    self.need_gem = self.select_times*self.one_time_need_gem
    Text_get_power:setString(self.one_time_add*self.select_times)
    Text_consume_power:setString(self.need_gem)
end

function NatinalWarBuyResource:onEnterTransitionFinish()

end

function NatinalWarBuyResource:onInit( )
    local csbItem = csb.createNode(config_csb.utils.buy_resource)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.utils.buy_resource)
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
        terminal_name = "natinal_war_buy_resource_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 加一
    fwin:addTouchEventListener(Button_power_add, nil, 
    {
        terminal_name = "natinal_war_buy_resource_add_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 减一
    fwin:addTouchEventListener(Button_power_subtract, nil, 
    {
        terminal_name = "natinal_war_buy_resource_remove_one", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    -- buy
    fwin:addTouchEventListener(Button_buy_power, nil, 
    {
        terminal_name = "natinal_war_buy_resource_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
	self:onUpdateDraw()	
    self:setBuyNumberString()
end

function NatinalWarBuyResource:init()
	self:onInit()
    return self
end

function NatinalWarBuyResource:onExit()
    state_machine.remove("natinal_war_buy_resource_sure")
    state_machine.remove("natinal_war_buy_resource_add_one")
    state_machine.remove("natinal_war_buy_resource_remove_one")
end
