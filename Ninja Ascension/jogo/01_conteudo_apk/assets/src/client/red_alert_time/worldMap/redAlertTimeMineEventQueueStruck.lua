-- ----------------------------------------------------------------------------------------------------
-- 说明：世界的事件队列,来袭
-------------------------------------------------------------------------------------------------------
redAlertTimeMineEventQueueStruck = class("redAlertTimeMineEventQueueStruckClass", Window)

local red_alert_time_mine_event_queue_struck_open_terminal = {
    _name = "red_alert_time_mine_event_queue_struck_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = redAlertTimeMineEventQueueStruck:new():init(params[1],params[2],params[3])
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_event_queue_struck_close_terminal = {
    _name = "red_alert_time_mine_event_queue_struck_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineEventQueueStruckClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineEventQueueStruckClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_event_queue_struck_open_terminal)
state_machine.add(red_alert_time_mine_event_queue_struck_close_terminal)
state_machine.init()
    
function redAlertTimeMineEventQueueStruck:ctor()
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
	
	app.load("client.red_alert_time.cells.worldMap.world_event_struck_list_cell")
	
	local function init_red_alert_time_mine_event_queue_struck_terminal()
	   --显示界面
        local red_alert_time_mine_event_queue_struck_show_terminal = {
            _name = "red_alert_time_mine_event_queue_struck_show",
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
        local red_alert_time_mine_event_queue_struck_hide_terminal = {
            _name = "red_alert_time_mine_event_queue_struck_hide",
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

		local red_alert_time_mine_event_queue_struck_update_terminal = {
            _name = "red_alert_time_mine_event_queue_struck_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_mine_event_queue_struck_show", 0, 0)
                -- instance:RefreshTheInterfaceList(1)
                state_machine.excute("red_alert_time_mine_event_queue_struck_pause_refresh", 0, true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local red_alert_time_mine_event_queue_struck_update_two_terminal = {
            _name = "red_alert_time_mine_event_queue_struck_update_two",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- local items = instance.ListView_world_attack:getItems()
				-- for i, v in pairs(items) do
					-- if v.m_object~= nil then
						-- state_machine.excute("world_event_struck_list_cell_update_list_info", 0, {v, params})
					-- end
				-- end
				local cell = worldEventStruckListCell:createCell()
				state_machine.excute("world_struck_list_cell_change_update_draw", 0, {_datas = 
					{_cell = cell, _object = params, _listType = page, _state = 1}
					})
				self.ListView_attack_incoming:insertCustomItem(cell, 0)
				-- cell:release()
				self.ListView_attack_incoming:requestRefreshView()
				cell._list_view = self.ListView_attack_incoming
				params._event_cell = cell
				cell._is_event = true
                state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
				state_machine.excute("adventure_mine_force_mobile",0,{params._dx,params._dy,params._sx,params._sy,cell,2})
				state_machine.excute("home_button_window_world_damage_time",0,{1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 保护罩购买
        local red_alert_time_mine_event_queue_struck_to_buy_terminal = {
            _name = "red_alert_time_mine_event_queue_struck_to_buy",
            _init = function (terminal)
				app.load("client.red_alert_time.props.PropsUse")
				app.load("client.red_alert_time.cells.props.props_use_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local info = {}
				info.id = 17
				local prop_ids_info = dms.string(dms["build_shop"], info.id, build_shop.prop_ids)
				local prop_data = zstring.split(prop_ids_info, ",")
				info.prop_ids = {
					prop_data[1],
					prop_data[2],
					prop_data[3],
				}
				state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 9})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_event_queue_struck_pause_refresh_terminal = {
            _name = "red_alert_time_mine_event_queue_struck_pause_refresh",
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
		
        state_machine.add(red_alert_time_mine_event_queue_struck_update_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_struck_update_two_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_struck_to_buy_terminal)
        state_machine.add(red_alert_time_mine_event_queue_struck_hide_terminal)
        state_machine.add(red_alert_time_mine_event_queue_struck_show_terminal)
		state_machine.add(red_alert_time_mine_event_queue_struck_pause_refresh_terminal)

		state_machine.init()
	end
	
	init_red_alert_time_mine_event_queue_struck_terminal()
	
end

function redAlertTimeMineEventQueueStruck:onHide()
    self:setVisible(false)
end

function redAlertTimeMineEventQueueStruck:onShow()
    self:setVisible(true)
end

function redAlertTimeMineEventQueueStruck:pause_refresh(isShow)
    local root = self.roots[1]
    state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
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

function redAlertTimeMineEventQueueStruck:RefreshTheInterfaceList()
	local root = self.roots[1]
	local items = self.ListView_attack_incoming:getItems()
	local posy = self.ListView_attack_incoming:getInnerContainer():getPositionY()
	local eventItem = {}
	for i, v in pairs(items) do
		if v._state == 1 then
			table.insert(eventItem, v)
		end
	end
	
	local cell =  nil
	local listDataCell = {} 
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if tonumber(v._event_type) > 10 and tonumber(v._event_type) < 13 then
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
	
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(listDataCell) do
	-- 		if nil == v._event_cell 
	-- 			and tonumber(v._event_type) > 10
				-- then
                state_machine.excute("red_alert_time_mine_event_queue_struck_update_two", 0, v)
 --                local cell = worldEventStruckListCell:createCell()
	-- 			state_machine.excute("world_struck_list_cell_change_update_draw", 0, {_datas = 
	-- 				{_cell = cell, _object = v, _listType = page, _state = 1}
	-- 				})
	-- 			checkPlayEffect(71)
	-- 			self.ListView_attack_incoming:insertCustomItem(cell, 0)
	-- 			-- cell:release()
	-- 			self.ListView_attack_incoming:requestRefreshView()
	-- 			cell._list_view = self.ListView_attack_incoming
	-- 			v._event_cell = cell
	-- 			cell._is_event = true
	-- 			state_machine.excute("adventure_mine_force_mobile",0,{v._sx,v._sy,v._dx,v._dy,cell,2})
	-- 			state_machine.excute("home_button_window_world_damage_time",0,{1})
				
	-- 			state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
                
			-- end	
		end
	end
    self._list_view = self.ListView_attack_incoming
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function redAlertTimeMineEventQueueStruck:onUpdate(dt)
    if self.ListView_attack_incoming:getItem(0) ~= nil then
        state_machine.excute("red_alert_time_mine_event_queue_refresh_button_struck", 0, exChangeTimeToString(self.ListView_attack_incoming:getItem(0).local_time))
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

function redAlertTimeMineEventQueueStruck:init(params1,params2,params3)
	self._rootWindows = params1
	self._rootWindows._struck = self
	self._params = params2
	self._father_list = params3
    self:onInit()
    return self
end

function redAlertTimeMineEventQueueStruck:onInit()
    local csbredAlertTimeMineEventQueueStruck = csb.createNode(config_csb.cells.world.world_battle_infor_window_tab_2)
    local root = csbredAlertTimeMineEventQueueStruck:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineEventQueueStruck)
	
	self.ListView_attack_incoming = ccui.Helper:seekWidgetByName(root,"ListView_attack_incoming")

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_base_defense"), nil, 
    {
       terminal_name = "formation_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        form_type = 1,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_open_base_protet"), nil, 
    {
        terminal_name = "red_alert_time_mine_event_queue_struck_to_buy",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_incoming_arrow_up")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_incoming_arrow_down")
    
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
	
	-- self:initDrawEventListView()
end

function redAlertTimeMineEventQueueStruck:onExit()
	state_machine.remove("red_alert_time_mine_event_queue_struck_update")
    state_machine.remove("red_alert_time_mine_event_queue_struck_update_two")
	state_machine.remove("red_alert_time_mine_event_queue_struck_to_buy")
    state_machine.remove("red_alert_time_mine_event_queue_struck_hide")
    state_machine.remove("red_alert_time_mine_event_queue_struck_show")
    state_machine.remove("red_alert_time_mine_event_queue_struck_pause_refresh")
end