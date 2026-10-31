-- -------------------------------------------------------
-- 说明：98元破冰(活动类型19)
----------------------------------------------------------
ActivityPopRecharge = class("ActivityPopRechargeClass", Window)

local activity_pop_recharge_window_open_terminal = {
    _name = "activity_pop_recharge_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if config_csb.activity.wonderful.activity_pop_recharge ~= nil then
            if nil == fwin:find("ActivityPopRechargeClass") then
                if _ED.activity_info["19"] ~= nil then
                    if tonumber(_ED.activity_info["19"].activity_data[1][1].achieve_state) ~= 2 then
                        local panel = ActivityPopRecharge:new():init(params)
                        fwin:open(panel)
                        return panel
                    end
                end
            end
        end     
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_pop_recharge_window_close_terminal = {
    _name = "activity_pop_recharge_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ActivityPopRechargeClass")) 
        state_machine.excute("main_window_login_popup_banner_open", 0, 0)   
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_pop_recharge_window_open_terminal)
state_machine.add(activity_pop_recharge_window_close_terminal)
state_machine.init()

function ActivityPopRecharge:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_activity_pop_recharge_terminal()
		local activity_pop_recharge_goto_terminal = {
            _name = "activity_pop_recharge_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _drawTypes = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 2)
                m_reqcharge_info.rechargeIndex = _drawTypes[1][1]
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
                            state_machine.excute("platform_request_for_payment", 0, params)
                            return
                        end
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("activity_pop_recharge_recharge_success", 0, nil)
                            end
                        end
                        protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
                        NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseCallback, false, nil)
                    end
                end
                protocol_command.request_top_up_order_number.param_list = ""..m_reqcharge_info.rechargeIndex.."\r\n"..m_sPayMould
                NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_pop_recharge_get_reward_terminal = {
            _name = "activity_pop_recharge_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{1019})
                    end
                    -- state_machine.excute("activity_pop_recharge_window_close", 0, nil)
                    state_machine.excute("wonderful_open_remove_page", 0, {19})
                    _ED.activity_info["19"] = nil
                    state_machine.excute("home_button_activity_update_button_state", 0, nil)
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["19"].activity_id .. "\r\n19\r\n0\r\n0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_pop_recharge_recharge_success_terminal = {
            _name = "activity_pop_recharge_recharge_success",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(activity_pop_recharge_goto_terminal)
        state_machine.add(activity_pop_recharge_get_reward_terminal)
        state_machine.add(activity_pop_recharge_recharge_success_terminal)
        state_machine.init()
    end
    
    init_activity_pop_recharge_terminal()
end

function ActivityPopRecharge:onUpdate( dt )
    if _ED.server_review == "1" then
        return
    end
    local time = tonumber(_ED.activity_info["19"].activity_add_state)
    time = time/1000 - os.time()
    if time <= 0 then
        self:unregisterOnNoteUpdate(self)
        -- state_machine.excute("activity_pop_recharge_window_close", 0, nil)
        state_machine.excute("wonderful_open_remove_page", 0, {19})
    end
    local time = math.modf(time)
    local hour = math.floor(time/ (60 * 60))
    time = time - (hour * 60 * 60)
    local minute = math.floor(time / 60)
    time = time - minute * 60
    local second = time % 60
    if self._time_ui ~= nil then
        self._time_ui:setString(string.format("%02d:%02d:%02d", hour, minute, second))
    end
end

function ActivityPopRecharge:onUpdateDraw()
    local root = self.roots[1]
    if _ED.activity_info["19"] ~= nil then
        if tonumber(_ED.activity_info["19"].activity_data[1][1].achieve_state) == 0 then
            ccui.Helper:seekWidgetByName(root, "Button_charge"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Button_get"):setVisible(false)
        elseif tonumber(_ED.activity_info["19"].activity_data[1][1].achieve_state) == 1 then
            ccui.Helper:seekWidgetByName(root, "Button_charge"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_get"):setVisible(true)
        end
    end
end

function ActivityPopRecharge:onEnterTransitionFinish()

end

function ActivityPopRecharge:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.activity_pop_recharge)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_charge"), nil, 
    {
        terminal_name = "activity_pop_recharge_goto", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_get"), nil, 
    {
        terminal_name = "activity_pop_recharge_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    -- {
    --     terminal_name = "activity_pop_recharge_window_close", 
    --     terminal_state = 0,
    --     touch_scale = true,
    --     touch_scale_xy = 0.95, 
    -- }, nil, 0)
    self._time_ui = ccui.Helper:seekWidgetByName(root, "Text_time_over_v")

	self:onUpdateDraw()

    if _ED.server_review == "1" then
        self._time_ui:setVisible(false)
        local Image_time_over = ccui.Helper:seekWidgetByName(root, "Image_time_over")
        if nil ~= Image_time_over then
            Image_time_over:setVisible(false)
        end
    end
end

function ActivityPopRecharge:init(params)
    if nil ~= params[1] then
        self._zorder = params[1]._zorder
    end
    local rootWindow = params[2]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function ActivityPopRecharge:onExit()
    state_machine.remove("activity_pop_recharge_goto")
    state_machine.remove("activity_pop_recharge_get_reward")
    state_machine.remove("activity_pop_recharge_recharge_success")
end
