-----------------------------
-- 资源点邀请
-----------------------------
MapRattlingInvite = class("MapRattlingInviteClass", Window)

local map_rattling_invite_window_open_terminal = {
    _name = "map_rattling_invite_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("MapRattlingInviteClass")
        if nil == _Window then
            fwin:open(MapRattlingInvite:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local map_rattling_invite_window_close_terminal = {
    _name = "map_rattling_invite_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MapRattlingInviteClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattling_invite_window_open_terminal)
state_machine.add(map_rattling_invite_window_close_terminal)
state_machine.init()

function MapRattlingInvite:ctor()
    self.super:ctor()
    self.roots = {}

    self._city_id = 0
    self._resource_id = 0
    self._resource_index = 0

    -- load lua file
    app.load("client.red_alert_time.cells.big_map.map_rattling_invite_cell")
    local function init_map_rattling_invite_terminal()
        local map_rattling_invite_change_state_terminal = {
            _name = "map_rattling_invite_change_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw(params._datas.state)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local map_rattling_invite_request_invite_terminal = {
            _name = "map_rattling_invite_request_invite",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.city_resource_hold_resource_infos == nil 
                    or instance._resource_index == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[252])
                    return
                end
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                local id = _ED.city_resource_hold_resource_infos[tonumber(instance._resource_index)].id
                protocol_command.city_resource_hold_init_invite.param_list = instance._city_id..","..instance._resource_id..","..instance._resource_index..","..id
                NetworkManager:register(protocol_command.city_resource_hold_init_invite.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_rattling_invite_change_state_terminal)
        state_machine.add(map_rattling_invite_request_invite_terminal)
        state_machine.init()
    end
    init_map_rattling_invite_terminal()
end

function MapRattlingInvite:onUpdateDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()

    if _ED.city_resource_invites ~= nil then
        local function sortfunction( a,b )
            return tonumber(a.time) > tonumber(b.time)  
        end
        table.sort( _ED.city_resource_invites, sortfunction )
        for k,v in pairs(_ED.city_resource_invites) do
            local cell = state_machine.excute("map_rattling_invite_create_cell", 0, {i, v, self._city_id, self._resource_id, self._resource_index})
            ListView_1:addChild(cell)
        end
        ListView_1:requestRefreshView()
        ListView_1:jumpToTop()
    end
end

function MapRattlingInvite:onEnterTransitionFinish()

end

function MapRattlingInvite:onInit( )
    local csbItem = csb.createNode(config_csb.big_map.map_rattling_invite)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "map_rattling_invite_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_injion"), nil, 
    {
        terminal_name = "map_rattling_invite_request_invite", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_right_1"), nil, 
    -- {
    --     terminal_name = "map_rattling_invite_change_state", 
    --     terminal_state = 0, 
    --     touch_scale = true,
    --     touch_scale_xy = 0.95,
    --     state = 0,
    -- }, nil, 0)

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_right_2"), nil, 
    -- {
    --     terminal_name = "map_rattling_invite_change_state", 
    --     terminal_state = 0, 
    --     touch_scale = true,
    --     touch_scale_xy = 0.95, 
    --     state = 1,
    -- }, nil, 0)

	self:onUpdateDraw()	
end


function MapRattlingInvite:init(params)
    self._city_id = params[1]
    self._resource_id = params[2]
    self._resource_index = params[3]
	self:onInit()
    return self
end

function MapRattlingInvite:onExit()
    state_machine.remove("map_rattling_invite_change_state")
    state_machine.remove("map_rattling_invite_request_invite")
end
