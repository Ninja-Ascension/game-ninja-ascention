-- ----------------------------------------------------------------------------------------------------
-- 说明：世界的事件队列,协防
-------------------------------------------------------------------------------------------------------
redAlertTimeMineEventQueueDefense = class("redAlertTimeMineEventQueueDefenseClass", Window)

local red_alert_time_mine_event_queue_defense_open_terminal = {
    _name = "red_alert_time_mine_event_queue_defense_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = redAlertTimeMineEventQueueDefense:new():init(params[1],params[2],params[3])
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_event_queue_defense_close_terminal = {
    _name = "red_alert_time_mine_event_queue_defense_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineEventQueueDefenseClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineEventQueueDefenseClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_event_queue_defense_open_terminal)
state_machine.add(red_alert_time_mine_event_queue_defense_close_terminal)
state_machine.init()
    
function redAlertTimeMineEventQueueDefense:ctor()
    self.super:ctor()
    self.roots = {}
    self.local_time = 0
	self._params = nil
	self._current_page = 0
	self.ListView_attack_incoming = nil

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.worldMap.world_event_defense_list_cell")
    app.load("client.red_alert_time.legion.LegionSetAttackHelp")
    app.load("client.red_alert_time.chat.ChatFriendWindow")
	
	local function init_red_alert_time_mine_event_queue_defense_terminal()
	   --显示界面
        local red_alert_time_mine_event_queue_defense_show_terminal = {
            _name = "red_alert_time_mine_event_queue_defense_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏界面
        local red_alert_time_mine_event_queue_defense_hide_terminal = {
            _name = "red_alert_time_mine_event_queue_defense_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

		local red_alert_time_mine_event_queue_defense_update_terminal = {
            _name = "red_alert_time_mine_event_queue_defense_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_mine_event_queue_defense_show", 0, 0)
                -- instance:RefreshTheInterfaceList(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local red_alert_time_mine_event_queue_defense_update_two_terminal = {
            _name = "red_alert_time_mine_event_queue_defense_update_two",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isAdd = true
                local items = self.ListView_attack_incoming:getItems()
                local oldCell = nil
                for i, v in pairs(items) do
                    if tonumber(v.m_object._user_info) == tonumber(params._user_info) 
                        and tonumber(v.m_object._time) == tonumber(params._time)  
                        and tonumber(v.m_object._dx) == tonumber(params._dx)  
                        and tonumber(v.m_object._dy) == tonumber(params._dy)  
                        then
                        isAdd = false
                        oldCell = v
                        break
                    end
                end
                local cell = nil
                if isAdd == true then
    				cell = worldEventDefenseListCell:createCell()
    				state_machine.excute("world_defense_list_cell_change_update_draw", 0, {_datas = 
    					{_cell = cell, _object = params, _listType = page, _state = 1}
    					})
    				self.ListView_attack_incoming:insertCustomItem(cell, 0)
    				-- cell:release()
    				self.ListView_attack_incoming:requestRefreshView()
    				cell._list_view = self.ListView_attack_incoming
    				params._event_defense_cell = cell
    				cell._is_event = true
                else
                    if params._event_defense_cell ~= nil then
                        params._event_defense_cell:onUpdateDraw()
                        cell = params._event_defense_cell
                    end
                end
                state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
                if cell ~= nil then
				    state_machine.excute("adventure_mine_force_mobile",0,{params._dx,params._dy,params._sx,params._sy,cell,1})
                end
				-- state_machine.excute("home_button_window_world_damage_time",0,{1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_event_queue_defense_pause_refresh_terminal = {
            _name = "red_alert_time_mine_event_queue_defense_pause_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:pause_refresh(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_event_queue_defense_request_defense_terminal = {
            _name = "red_alert_time_mine_event_queue_defense_request_defense",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local datasInfo = params[1]
                local function requesrDefendCheck(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            
                        end 
                    end
                end
                protocol_command.world_request_help_defend.param_list = datasInfo.user_id
                NetworkManager:register(protocol_command.world_request_help_defend.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_mine_event_queue_defense_update_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_defense_update_two_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_defense_to_buy_terminal)
        state_machine.add(red_alert_time_mine_event_queue_defense_hide_terminal)
        state_machine.add(red_alert_time_mine_event_queue_defense_show_terminal)
        state_machine.add(red_alert_time_mine_event_queue_defense_pause_refresh_terminal)
		state_machine.add(red_alert_time_mine_event_queue_defense_request_defense_terminal)

		state_machine.init()
	end
	
	init_red_alert_time_mine_event_queue_defense_terminal()
	
end

function redAlertTimeMineEventQueueDefense:onHide()
    self:setVisible(false)
end

function redAlertTimeMineEventQueueDefense:onShow()
    self:setVisible(true)
end

function redAlertTimeMineEventQueueDefense:pause_refresh(isShow)
    state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
    local root = self.roots[1]
    for i, v in pairs(self.ListView_attack_incoming:getItems()) do
        if v._path ~= nil then
            v._path:removeFromParent(true)
            v._path = nil
        end
    end
    local items = self.ListView_attack_incoming:getItems()
    if #items > 0 then
        self.ListView_attack_incoming:removeAllItems()
        if isShow == true then
            self:RefreshTheInterfaceList()
        end
    end
end

function redAlertTimeMineEventQueueDefense:RefreshTheInterfaceList()
	local root = self.roots[1]
	local listDataCell = {} 

	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if tonumber(v._event_type) >= 13 and tonumber(v._event_type) < 18 then
				table.insert(listDataCell, v)
			end
		end
	end

	table.sort(listDataCell, function(c1, c2)

		if c1._time < c2._time then
			return true
		end
		return false
	end)
    self.ListView_attack_incoming:removeAllItems()
    if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
        for i, v in pairs(listDataCell) do
            -- if v._event_defense_cell == nil then
                state_machine.excute("red_alert_time_mine_event_queue_defense_update_two", 0, v)
            -- end
        end
    end

    self.ListView_attack_incoming:requestRefreshView()

    self._list_view = self.ListView_attack_incoming
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function redAlertTimeMineEventQueueDefense:onUpdate(dt)
    if self.ListView_attack_incoming:getItem(0) ~= nil then
        local cell = self.ListView_attack_incoming:getItem(0)
        if tonumber(cell.m_object._event_type) == 13 then
            if cell.local_time~= 0 then
                state_machine.excute("red_alert_time_mine_event_queue_refresh_button_defense", 0, exChangeTimeToString(cell.local_time))
            end
        elseif tonumber(cell.m_object._event_type) == 14 then
            if tonumber(cell.m_object._help_defend_state) == 0 then
                state_machine.excute("red_alert_time_mine_event_queue_refresh_button_defense", 0, red_alert_time_str[271])
            else
                state_machine.excute("red_alert_time_mine_event_queue_refresh_button_defense", 0, red_alert_time_str[272])
            end
        end
    end
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function redAlertTimeMineEventQueueDefense:init(params1,params2,params3)
	self._rootWindows = params1
	self._rootWindows._struck = self
	self._params = params2
	self._father_list = params3
    self:onInit()
    return self
end

function redAlertTimeMineEventQueueDefense:onInit()
    local csbredAlertTimeMineEventQueueDefense = csb.createNode(config_csb.cells.world.world_battle_infor_window_tab_3)
    local root = csbredAlertTimeMineEventQueueDefense:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineEventQueueDefense)
	
	self.ListView_attack_incoming = ccui.Helper:seekWidgetByName(root,"ListView_help_defense")

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_help_defense"), nil, 
    {
       terminal_name = "legion_set_attack_help_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_p_help_defense"), nil, 
    {
       terminal_name = "chat_friend_window_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        from_type = 5,
        _page = 2,
    },
    nil,1)


    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_help_defense_arrow_up")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_help_defense_arrow_down")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)
	
	self:RefreshTheInterfaceList()
	
end

function redAlertTimeMineEventQueueDefense:onExit()
	state_machine.remove("red_alert_time_mine_event_queue_defense_update")
    state_machine.remove("red_alert_time_mine_event_queue_defense_update_two")
	state_machine.remove("red_alert_time_mine_event_queue_defense_to_buy")
    state_machine.remove("red_alert_time_mine_event_queue_defense_hide")
    state_machine.remove("red_alert_time_mine_event_queue_defense_show")
    state_machine.remove("red_alert_time_mine_event_queue_defense_pause_refresh")
end