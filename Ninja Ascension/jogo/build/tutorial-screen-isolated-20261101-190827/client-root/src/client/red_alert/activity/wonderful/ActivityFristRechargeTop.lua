-----------------------------
--首冲/二冲/三冲(活动类型2)
-----------------------------
ActivityFristRechargeTop = class("ActivityFristRechargeTopClass", Window)
-- 打开
local activity_frist_recharge_top_window_open_terminal = {
    _name = "activity_frist_recharge_top_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        if config_csb.activity.wonderful.activity_frist_recharge_top ~= nil then
            if nil == fwin:find("ActivityFristRechargeTopClass") then
                _ED._push_top_up = 0
                fwin:open(ActivityFristRechargeTop:new():init(params), fwin._windows)
                return true
            end
        end       
        return false
    end,
    _terminal = nil,
    _terminals = nil
}
-- 关闭
local activity_frist_recharge_top_window_close_terminal = {
    _name = "activity_frist_recharge_top_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ActivityFristRechargeTopClass"))   
        state_machine.excute("main_window_login_popup_banner_open", 0, 0)  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_frist_recharge_top_window_open_terminal)
state_machine.add(activity_frist_recharge_top_window_close_terminal)
state_machine.init()

function ActivityFristRechargeTop:ctor()
    self.super:ctor()
    self.roots = {}

    self._currentIndex = 1

    local function init_activity_frist_recharge_top_terminal()
        -- 充值
		local activity_frist_recharge_top_goto_terminal = {
            _name = "activity_frist_recharge_top_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("recharge_dialog_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 领取
        local activity_frist_recharge_top_get_reward_terminal = {
            _name = "activity_frist_recharge_top_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 恭喜获得
                        state_machine.excute("reward_obtain_window_open",0,{1002})
                    end
                    -- 移除活动列表里的首冲活动页
                    state_machine.excute("wonderful_remove_page",0,{2})
                    -- 如果已领取三冲奖励移除该活动按钮
                    _ED._push_top_up = 1
                    if tonumber(instance._currentIndex) == 3 then 
                        _ED.activity_info["2"] = nil
                    end
                    -- 刷新主界面按钮状态
                    state_machine.excute("home_button_activity_update_button_state", 0, nil)
                    -- 关闭界面
                    state_machine.excute("activity_frist_recharge_top_window_close", 0, nil)
                end
                local currentIndex = instance._currentIndex - 1
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["2"].activity_id .. "\r\n2\r\n0\r\n"..currentIndex
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新按钮状态
        local activity_frist_recharge_top_recharge_success_terminal = {
            _name = "activity_frist_recharge_top_recharge_success",
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

        -- 刷新页面
        local activity_frist_recharge_top_update_terminal = {
            _name = "activity_frist_recharge_top_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onInit()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_frist_recharge_top_goto_terminal)
        state_machine.add(activity_frist_recharge_top_get_reward_terminal)
        state_machine.add(activity_frist_recharge_top_recharge_success_terminal)
        state_machine.add(activity_frist_recharge_top_update_terminal)
        state_machine.init()
    end
    
    init_activity_frist_recharge_top_terminal()
end

function ActivityFristRechargeTop:onUpdate( dt )

end

-- 按钮状态
function ActivityFristRechargeTop:onUpdateDraw()
    local root = self.roots[1]
    -- 如果该活动存在,活动已完成显示领取按钮、未完成显示充值按钮
    if _ED.activity_info["2"] ~= nil then
        if tonumber(_ED.activity_info["2"].activity_data[1][self._currentIndex].achieve_state) == 1 then 
            ccui.Helper:seekWidgetByName(root, "Button_recharge"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_get"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Button_recharge"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Button_get"):setVisible(false)
        end
    end
end

function ActivityFristRechargeTop:onEnterTransitionFinish()

end

function ActivityFristRechargeTop:onInit( )
    self:removeAllChildren(true)
    self.roots = {}
    local csbItem = nil
    -- 如果首冲未完成显示首冲界面，完成了显示二冲界面，如果二冲完成了显示三冲界面
    if tonumber(_ED.activity_info["2"].activity_data[1][1].achieve_state) < 2 then
        csbItem = csb.createNode(config_csb.activity.wonderful.activity_frist_recharge_top)
        self._currentIndex = 1
    elseif tonumber(_ED.activity_info["2"].activity_data[1][2].achieve_state) < 2 then
        csbItem = csb.createNode(config_csb.activity.wonderful.activity_frist_recharge_top_2)
        self._currentIndex = 2
    elseif tonumber(_ED.activity_info["2"].activity_data[1][3].achieve_state) < 2 then
        csbItem = csb.createNode(config_csb.activity.wonderful.activity_frist_recharge_top_3)
        self._currentIndex = 3
    end
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
    -- 充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge"), nil, 
    {
        terminal_name = "activity_frist_recharge_top_goto", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_get"), nil, 
    {
        terminal_name = "activity_frist_recharge_top_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "activity_frist_recharge_top_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,

    }, nil, 0)

	self:onUpdateDraw()
end

function ActivityFristRechargeTop:init(params)
    if nil ~= params then
        self._zorder = params._zorder
    end
	self:onInit()
    return self
end

function ActivityFristRechargeTop:onExit()
    state_machine.remove("activity_frist_recharge_top_goto")
    state_machine.remove("activity_frist_recharge_top_get_reward")
    state_machine.remove("activity_frist_recharge_top_recharge_success")
    state_machine.remove("activity_frist_recharge_top_update")
end
