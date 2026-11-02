-- ----------------------------------------------------------------------------------------------------
-- 说明：资源点
-- ----------------------------------------------------------------------------------------------------
MapRattlingRanking = class("MapRattlingRankingClass", Window)

local map_rattling_ranking_window_open_terminal = {
	_name = "map_rattling_ranking_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)   
        if funOpenDrawTip(138) == true then
            return
        end   
        if fwin:find("MapRattlingRankingClass") == nil then
            fwin:open(MapRattlingRanking:new():init(),fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local map_rattling_ranking_window_close_terminal = {
	_name = "map_rattling_ranking_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MapRattlingRankingClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(map_rattling_ranking_window_open_terminal)
state_machine.add(map_rattling_ranking_window_close_terminal)
state_machine.init()

function MapRattlingRanking:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- load lua file
    app.load("client.red_alert_time.big_map.MapRattling")
    app.load("client.red_alert_time.big_map.MapRattlingRankingListView")
    app.load("client.red_alert_time.cells.big_map.map_rattling_ranking_cell")

    self._choose_type = 0
    self._panel_list_view = {}
    self._panel_info_data = {}
    self._last_page_null = 0
    self._last_page_resource = 0

    local function init_map_rattling_ranking_terminal()
        local map_rattling_ranking_change_terminal = {
            _name = "map_rattling_ranking_change",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateChangePage(params._datas.from_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local map_rattling_ranking_refresh_terminal = {
            _name = "map_rattling_ranking_refresh",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node._last_page_resource = tonumber(_ED.city_resource_rank_page)
                            response.node:onUpdateDraw(true)
                        end
                    end
                end
                choose_type = 5 - instance._choose_type
                instance._last_page_resource = instance._last_page_resource + 1
                protocol_command.city_resource_hold_list_refresh.param_list = "0\r\n"..choose_type.."\r\n"..instance._last_page_resource
                NetworkManager:register(protocol_command.city_resource_hold_list_refresh.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        
        local map_rattling_ranking_auto_attack_terminal = {
            _name = "map_rattling_ranking_auto_attack",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and table.nums(_ED.city_resource_rank_info) > 0 then
                            response.node._last_page_null = tonumber(_ED.city_resource_rank_page)
                            response.node:onUpdateDraw(true)
                        end
                    end
                end
                _ED.city_resource_rank_info = {}
                choose_type = 5 - instance._choose_type
                instance._last_page_null = instance._last_page_null + 1
                protocol_command.city_resource_hold_list_refresh.param_list = "1\r\n"..choose_type.."\r\n"..instance._last_page_null
                NetworkManager:register(protocol_command.city_resource_hold_list_refresh.code, nil, nil, nil, self, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(map_rattling_ranking_change_terminal)
        state_machine.add(map_rattling_ranking_refresh_terminal)
        state_machine.add(map_rattling_ranking_auto_attack_terminal)
        state_machine.init()
    end
    
    init_map_rattling_ranking_terminal()
end

function MapRattlingRanking:onInit()
    local csbItem = csb.createNode(config_csb.big_map.map_ranking)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ranking_close"), nil, 
    {
        terminal_name = "map_rattling_ranking_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     
    
    for i = 1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_top_"..i), nil, 
        {
            terminal_name = "map_rattling_ranking_change",
            from_type = i,
            terminal_state = 0, 
        }, nil, 0)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_refresh"), nil, 
    {
        terminal_name = "map_rattling_ranking_refresh",
        from_type = i,
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attack"), nil, 
    {
        terminal_name = "map_rattling_ranking_auto_attack",
        from_type = i,
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    state_machine.excute("map_rattling_ranking_change", 0, {_datas = {from_type = 1}})
end

function MapRattlingRanking:onEnterTransitionFinish()

end

function MapRattlingRanking:updateChangePage( choose_type )
    local root = self.roots[1]
    for i=1,4 do
        ccui.Helper:seekWidgetByName(root,"Button_rank_top_"..i):setHighlighted(false)
        ccui.Helper:seekWidgetByName(root,"Text_top_"..i):setColor(cc.c3b(red_alert_war_city_map_color[3][1], red_alert_war_city_map_color[3][2], red_alert_war_city_map_color[3][3]))
    end
    ccui.Helper:seekWidgetByName(root,"Button_rank_top_"..choose_type):setHighlighted(true)
    ccui.Helper:seekWidgetByName(root,"Text_top_"..choose_type):setColor(cc.c3b(red_alert_war_city_map_color[4][1], red_alert_war_city_map_color[4][2], red_alert_war_city_map_color[4][3]))
    if choose_type == self._choose_type then
        return
    end
    self._choose_type = choose_type
    if self._panel_list_view[""..self._choose_type] == nil then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    response.node:onUpdateDraw(false)
                end
            end
        end
        choose_type = 5 - self._choose_type
        protocol_command.city_resource_hold_list_refresh.param_list = "0\r\n"..choose_type.."\r\n0"
        NetworkManager:register(protocol_command.city_resource_hold_list_refresh.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        self:onUpdateDraw(false)
    end
end

function MapRattlingRanking:onUpdateDraw(isNeedClear)
    local Panel_listview_right = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_listview_right")
    for k,v in pairs(self._panel_list_view) do
        v:setVisible(false)
    end
    if self._panel_list_view[""..self._choose_type] == nil then
        self._panel_list_view[""..self._choose_type] = state_machine.excute("map_rattling_ranking_listview_window_open", 0, {Panel_listview_right, self._choose_type})
        self._panel_info_data[""..self._choose_type] = _ED.city_resource_rank_info
    end
    if isNeedClear == true then
        self._panel_info_data[""..self._choose_type] = _ED.city_resource_rank_info
        self._panel_list_view[""..self._choose_type]:updateDraw()
    end
    self._panel_list_view[""..self._choose_type]:setVisible(true)
end

function MapRattlingRanking:close()

end

function MapRattlingRanking:init()
	self:onInit()
    return self
end

--移除状态机
function MapRattlingRanking:onExit()
    state_machine.remove("map_rattling_ranking_change")
    state_machine.remove("map_rattling_ranking_refresh")
    state_machine.remove("map_rattling_ranking_auto_attack")
end