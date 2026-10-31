-----------------------------
-- 神兵副本挑战次数购买
-----------------------------
GodWeaponryBuyTimes = class("GodWeaponryBuyTimesClass", Window)

local god_weaponry_buy_times_window_open_terminal = {
    _name = "god_weaponry_buy_times_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("GodWeaponryBuyTimesClass")
        if nil == _Window then
            fwin:open(GodWeaponryBuyTimes:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local god_weaponry_buy_times_window_close_terminal = {
    _name = "god_weaponry_buy_times_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GodWeaponryBuyTimesClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(god_weaponry_buy_times_window_open_terminal)
state_machine.add(god_weaponry_buy_times_window_close_terminal)
state_machine.init()

function GodWeaponryBuyTimes:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.current_times = 1

    local function init_god_weaponry_buy_times_terminal()
		local god_weaponry_buy_terminal = {
            _name = "god_weaponry_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --判断宝石是否足够
                if zstring.tonumber(instance._need_gem) > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end
                --判断是否还有剩余次数
                if instance._now_times >= instance._max_times then
                    TipDlg.drawTextDailog(red_alert_all_str[39])
                    return
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then    
                        state_machine.excute("god_weaponry_buy_times_window_close",0,"")
                        state_machine.excute("god_weaponry_duplicate_infor_update_draw",0,"")
                        state_machine.excute("god_weaponry_duplicate_update_draw",0,"")
                    end
                end

                protocol_command.buy_super_equipment_copy_attack_count.param_list = instance.current_times
                NetworkManager:register(protocol_command.buy_super_equipment_copy_attack_count.code, nil, nil, nil,nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local god_weaponry_change_times_terminal = {
            _name = "god_weaponry_change_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.current_times = instance.current_times + params._datas.add_times
                if instance.current_times >= instance._max_times - instance._now_times then
                    instance.current_times = instance._max_times - instance._now_times
                end
                if instance.current_times < 1 then
                    instance.current_times = 1
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(god_weaponry_buy_terminal)
        state_machine.add(god_weaponry_change_times_terminal)	
        state_machine.init()
    end
    
    init_god_weaponry_buy_times_terminal()
end

function GodWeaponryBuyTimes:onUpdateDraw()
    local root = self.roots[1]
    local Text_spend_v = ccui.Helper:seekWidgetByName(root, "Text_spend_v")
    local Text_can_buy_v = ccui.Helper:seekWidgetByName(root, "Text_can_buy_v")
    local Text_today_buy_time_v = ccui.Helper:seekWidgetByName(root, "Text_today_buy_time_v")
    Text_can_buy_v:setString(self.current_times)
    Text_today_buy_time_v:setString(self._now_times .. "/" ..  self._max_times)
    local will_need_gem = 0
    local add_times = 0

    for i,v in pairs(self._copy_config_str) do
        if add_times == self.current_times then
            break
        end
        if i > self._now_times then
            will_need_gem = self._copy_config_str[i] + will_need_gem
            add_times = add_times + 1            
        end
    end
    self._need_gem = will_need_gem
    Text_spend_v:setString(will_need_gem)
end

function GodWeaponryBuyTimes:onEnterTransitionFinish()
    
end

function GodWeaponryBuyTimes:onInit( )
    local csbItem = csb.createNode(config_csb.god_weaponry.god_weaponry_buy_time)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "god_weaponry_buy_times_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_buy_time"), nil, 
    {
        terminal_name = "god_weaponry_buy_times_window_close", 
        terminal_state = 0, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil, 
    {
        terminal_name = "god_weaponry_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduction_0"), nil, 
    {
        terminal_name = "god_weaponry_change_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        add_times = 1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduction"), nil, 
    {
        terminal_name = "god_weaponry_change_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        add_times = -1,
    }, nil, 0)

    self:initDatas()
    self:onUpdateDraw()
end

--初始化部分数据
function GodWeaponryBuyTimes:initDatas()
    local max_times = dms.int(dms["base_consume"],77,base_consume.vip_0_value + tonumber(_ED.vip_grade))
    self._max_times = max_times
    self._now_times = zstring.tonumber(_ED.weaponry_buy_attack_times)
    self.current_times = 1
    self._need_gem = 0

    local copy_config_str = dms.string(dms["copy_config"],7,copy_config.param)
    copy_config_str = zstring.split(copy_config_str,",")
    self._copy_config_str = copy_config_str
end

function GodWeaponryBuyTimes:init()
	self:onInit()
    return self
end

function GodWeaponryBuyTimes:onExit()
    state_machine.remove("god_weaponry_buy")
    state_machine.remove("god_weaponry_change_times")
end
