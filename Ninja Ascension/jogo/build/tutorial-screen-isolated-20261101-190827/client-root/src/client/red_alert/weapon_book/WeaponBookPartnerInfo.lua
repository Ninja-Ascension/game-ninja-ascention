
WeaponBookPartnerInfo = class("WeaponBookPartnerInfoClass", Window)

local weapon_book_partner_info_window_open_terminal = {
    _name = "weapon_book_partner_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(WeaponBookPartnerInfo:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local weapon_book_partner_info_window_close_terminal = {
    _name = "weapon_book_partner_info_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponBookPartnerInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_partner_info_window_open_terminal)
state_machine.add(weapon_book_partner_info_window_close_terminal)
state_machine.init()

function WeaponBookPartnerInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._info = nil

    local function init_weapon_book_partner_info_terminal()
        local weapon_book_partner_info_active_terminal = {
            _name = "weapon_book_partner_info_active",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("weapon_book_partner_update_talent", 0, nil)
                --         state_machine.excute("weapon_book_partner_info_window_close", 0, nil)
                --     end
                -- end
                -- protocol_command.rider_horse.param_list = "0\r\n"..instance.ship.ship_id
                -- NetworkManager:register(protocol_command.rider_horse.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(weapon_book_partner_info_active_terminal)
        state_machine.init()
    end
    init_weapon_book_partner_info_terminal()
end

function WeaponBookPartnerInfo:onUpdateDraw()
    local root = self.roots[1]
    local Text_rule = ccui.Helper:seekWidgetByName(root, "Text_rule_"..self._index)
    local Text_rule_inner = ccui.Helper:seekWidgetByName(root, "Text_rule_inner_"..self._index) 
    Text_rule:setVisible(true)
    Text_rule_inner:setVisible(true)
end

function WeaponBookPartnerInfo:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_rule)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    -- local action = csb.createTimeline(config_csb.legion.legion_rule)
    -- table.insert(self.actions, action)
    -- csbItem:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "weapon_book_partner_info_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "weapon_book_partner_info_active", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- self:onUpdateDraw()
end

function WeaponBookPartnerInfo:init(params)
    self._info = params
	self:onInit()
    return self
end

function WeaponBookPartnerInfo:onExit()
    state_machine.remove("weapon_book_partner_info_active")
end