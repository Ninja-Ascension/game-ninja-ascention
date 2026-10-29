-----------------------------
-- VIP奖励推送弹窗
-----------------------------
ActivityVipPush = class("ActivityVipPushClass", Window)

local activity_vip_push_window_open_terminal = {
    _name = "activity_vip_push_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        -- if nil == fwin:find("ActivityVipPushClass") then
            fwin:open(ActivityVipPush:new():init(params), fwin._windows)
        -- end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_vip_push_window_close_terminal = {
    _name = "activity_vip_push_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        -- fwin:close(fwin:find("ActivityVipPushClass"))    
        fwin:close(params._datas.instance)
        state_machine.excute("main_window_login_popup_banner_open", 0, 0) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_vip_push_window_open_terminal)
state_machine.add(activity_vip_push_window_close_terminal)
state_machine.init()

function ActivityVipPush:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._isSelectEd = false

    self._notification_type = nil
    
    self._addition_png = nil

    self._tracking = nil

    local function init_activity_vip_push_terminal()
		local activity_vip_push_choose_terminal = {
            _name = "activity_vip_push_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onSelectChoose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_vip_push_goto_terminal = {
            _name = "activity_vip_push_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local notification_type = params._datas.instance._notification_type
                state_machine.excute("activity_vip_push_window_close", 0, params)
                if 6 == notification_type then
                    state_machine.excute("recharge_dialog_window_open", 0, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_vip_push_goto_terminal)
		state_machine.add(activity_vip_push_choose_terminal)
        state_machine.init()
    end
    
    init_activity_vip_push_terminal()
end

function ActivityVipPush:onSelectChoose()
    local root = self.roots[1]
end

function ActivityVipPush:onEnterTransitionFinish()

end

function ActivityVipPush:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.activity_vip_push)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.activity.wonderful.activity_vip_push)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)

    if nil ~= self._addition_png and "" ~= self._addition_png then
        ccui.Helper:seekWidgetByName(root, "Panel_vip_get"):setBackGroundImage(self._addition_png)
    end

    local Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
    {
        terminal_name = "activity_vip_push_goto",
        terminal_state = 0,
        instance = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    if 0 == self._notification_type then
        Button_go:setVisible(false)
    end

    -- 关闭按钮
    local Button_close = ccui.Helper:seekWidgetByName(root,"Button_close")
    local Button_close_1 = ccui.Helper:seekWidgetByName(root,"Button_close_1")
    Button_close:setVisible(false)
    Button_close_1:setVisible(false)
    if 6 == self._notification_type then
        Button_close_1:setVisible(true)
    else
        Button_close:setVisible(true)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "activity_vip_push_window_close",
        terminal_state = 0,
        instance = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close_1"), nil, 
    {
        terminal_name = "activity_vip_push_window_close",
        terminal_state = 0,
        instance = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_1"), nil, 
    {
        terminal_name = "activity_vip_push_choose",
        terminal_state = 0,
        instance = self
    }, nil, 0)

end

function ActivityVipPush:init(params)
    self._notification_type = params[1]
    self._addition_png = params[2]
    self._tracking = params[3]
    local order = params[4]
    local server_date = os.date("%x", _ED.system_time)
    local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. self._notification_type), "")
    self._isSelectEd = save_date == server_date

    self._zorder = order
	self:onInit()
    return self
end

function ActivityVipPush:onExit()
    local root = self.roots[1]
    local CheckBox_1 = ccui.Helper:seekWidgetByName(root, "CheckBox_1")
    self._isSelectEd = CheckBox_1:isSelected()

    local save_date = ""
    if true == self._isSelectEd then
        save_date = os.date("%x", _ED.system_time)
    end
    cc.UserDefault:getInstance():setStringForKey(getKey("notification_popup_windows_" .. self._notification_type), save_date)

    state_machine.remove("activity_vip_push_goto")
    state_machine.remove("activity_vip_push_choose")
end
