-----------------------------
--VIP特权
-----------------------------
VipPrivilegeRedAlert = class("VipPrivilegeRedAlertClass", Window)
--打开
local vip_privilege_red_alert_window_open_terminal = {
    _name = "vip_privilege_red_alert_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(98) == true then
            return
        end 
        cc.UserDefault:getInstance():setStringForKey(getKey("red_alert_time_vip_reward_push_state"), "0")
        state_machine.excute("notification_center_update", 0, "push_notification_privilege_packs")
        local panel = nil
        if nil == fwin:find("VipPrivilegeRedAlertClass") then
            panel = VipPrivilegeRedAlert:new():init(params)
            fwin:open(panel)
        end
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local vip_privilege_red_alert_window_close_terminal = {
    _name = "vip_privilege_red_alert_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("VipPrivilegeRedAlertClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(vip_privilege_red_alert_window_open_terminal)
state_machine.add(vip_privilege_red_alert_window_close_terminal)
state_machine.init()

function VipPrivilegeRedAlert:ctor()
    self.super:ctor()
    self.roots = {}

    self._choose_page = 0
    self._vipPanel = nil
    self._shopPanel = nil
    self._welfarePanel = nil

    app.load("client.red_alert_time.recharge.VipLevelInfo")
    app.load("client.red_alert_time.recharge.VipShopInfo")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeVipGift")

    local function init_vip_privilege_red_alert_terminal()
        local vip_privilege_red_alert_change_state_terminal = {
            _name = "vip_privilege_red_alert_change_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changePage(params._datas.page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_privilege_red_alert_change_vip_title_terminal = {
            _name = "vip_privilege_red_alert_change_vip_title",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._choose_page = 0
                instance:changePage(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(vip_privilege_red_alert_change_state_terminal)
        state_machine.add(vip_privilege_red_alert_change_vip_title_terminal)
        state_machine.init()
    end
    init_vip_privilege_red_alert_terminal()
end 

function VipPrivilegeRedAlert:changePage( page )
    local root = self.roots[1]
    local Panel_vip_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_vip_tab_box")
    local Button_collection_xy_all = ccui.Helper:seekWidgetByName(root, "Button_collection_xy_all")
    local Button_collection_xy_res = ccui.Helper:seekWidgetByName(root, "Button_collection_xy_res")
    local Button_welfare = ccui.Helper:seekWidgetByName(root, "Button_welfare")
    if self._choose_page == page then
        if page == 1 then
            Button_collection_xy_all:setHighlighted(true)
        elseif page == 2 then
            Button_collection_xy_res:setHighlighted(true)
        else
            Button_welfare:setHighlighted(true)
        end
        return
    end
    Button_collection_xy_all:setHighlighted(false)
    Button_collection_xy_res:setHighlighted(false)
    Button_welfare:setHighlighted(false)
    self._choose_page = page
    state_machine.excute("vip_level_info_hide", 0, nil)
    state_machine.excute("vip_shop_info_hide", 0, nil)
    state_machine.excute("red_alert_time_vip_gift_hide", 0, nil)
    if page == 1 then
        Button_collection_xy_all:setHighlighted(true)
        if self._vipPanel == nil then
            self._vipPanel = state_machine.excute("vip_level_info_open", 0, {Panel_vip_tab_box})
        else
            state_machine.excute("vip_level_info_show", 0, nil)
        end
    elseif page == 2 then
        Button_collection_xy_res:setHighlighted(true)
        if self._shopPanel == nil then
            self._shopPanel = state_machine.excute("vip_shop_info_open", 0, {Panel_vip_tab_box})
        else
            state_machine.excute("vip_shop_info_show", 0, nil)
        end
    elseif page == 3 then
        Button_welfare:setHighlighted(true)
        if self._welfarePanel == nil then
            self._welfarePanel = state_machine.excute("red_alert_time_vip_gift_open", 0, {Panel_vip_tab_box})
        else
            state_machine.excute("red_alert_time_vip_gift_show", 0, nil)
        end
    end
end

function VipPrivilegeRedAlert:onUpdateDraw()
    
end

function VipPrivilegeRedAlert:onInit()
    local csbItem = csb.createNode(config_csb.shop.vip_privilege)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collection_xy_all"), nil, 
    {
        terminal_name = "vip_privilege_red_alert_change_state", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        page = 1, 
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collection_xy_res"), nil, 
    {
        terminal_name = "vip_privilege_red_alert_change_state", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        page = 2, 
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_privilege_packs_internal",
    _widget = ccui.Helper:seekWidgetByName(root,"Button_collection_xy_res"),
    _m_type = 0,
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_welfare"), nil, 
    {
        terminal_name = "vip_privilege_red_alert_change_state", 
        terminal_state = 0, 
        page = 3, 
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_vip_privilege_gift",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_welfare"),
        _m_type = 0,
        _invoke = nil,
        _interval = 0.2,})

    self:changePage(1)
end


function VipPrivilegeRedAlert:init(params)
    self._rootWindows = params[1]
	self:onInit()
    return self
end

function VipPrivilegeRedAlert:onExit()
    state_machine.remove("vip_privilege_red_alert_to_receive")
    state_machine.remove("vip_privilege_red_alert_change_vip_title")
    state_machine.remove("vip_privilege_red_alert_refresh")
end