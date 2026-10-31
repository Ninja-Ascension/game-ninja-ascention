-- ----------------------------------------------------------------------------------------------------
-- 说明：世界的事件队列,行军
-------------------------------------------------------------------------------------------------------
redAlertTimeMineEventQueueMarch = class("redAlertTimeMineEventQueueMarchClass", Window)

local red_alert_time_mine_event_queue_march_open_terminal = {
    _name = "red_alert_time_mine_event_queue_march_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = redAlertTimeMineEventQueueMarch:new():init(params[1],params[2],params[3])
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_event_queue_march_close_terminal = {
    _name = "red_alert_time_mine_event_queue_march_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineEventQueueMarchClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineEventQueueMarchClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_event_queue_march_open_terminal)
state_machine.add(red_alert_time_mine_event_queue_march_close_terminal)
state_machine.init()
    
function redAlertTimeMineEventQueueMarch:ctor()
    self.super:ctor()
    self.roots = {}
	self._params = nil
	self._current_page = 0
	self.ListView_world_attack = nil

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.worldMap.world_event_list_cell")
	app.load("client.red_alert_time.cells.worldMap.world_event_no_list_cell")
	
	local function init_red_alert_time_mine_event_queue_march_terminal()
		
        --显示界面
        local red_alert_time_mine_event_queue_march_show_terminal = {
            _name = "red_alert_time_mine_event_queue_march_show",
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
        local red_alert_time_mine_event_queue_march_hide_terminal = {
            _name = "red_alert_time_mine_event_queue_march_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onHide()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

		local red_alert_time_mine_event_queue_march_update_terminal = {
            _name = "red_alert_time_mine_event_queue_march_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_mine_event_queue_march_show", 0, 0)
                instance:RefreshTheInterfaceList(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local red_alert_time_mine_event_queue_march_update_two_terminal = {
            _name = "red_alert_time_mine_event_queue_march_update_two",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local items = instance.ListView_world_attack:getItems()
				for i, v in pairs(items) do
					if v.m_object~= nil then
						if v.m_object._update == true then
							state_machine.excute("world_nearby_list_cell_update_list_info", 0, {v, params})
						end
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_event_queue_march_get_list_cells_terminal = {
            _name = "red_alert_time_mine_event_queue_march_get_list_cells",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local items = instance.ListView_world_attack:getItems()
                return items
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_event_queue_march_stick_top_terminal = {
            _name = "red_alert_time_mine_event_queue_march_stick_top",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self.ListView_world_attack:jumpToTop()
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_pause_refresh_terminal = {
            _name = "red_alert_time_mine_pause_refresh",
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
		
        state_machine.add(red_alert_time_mine_event_queue_march_update_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_march_update_two_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_march_get_list_cells_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_march_stick_top_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_march_show_terminal) 
        state_machine.add(red_alert_time_mine_event_queue_march_hide_terminal) 
        state_machine.add(red_alert_time_mine_pause_refresh_terminal) 
	
		state_machine.init()
	end
	
	init_red_alert_time_mine_event_queue_march_terminal()
	
end

function redAlertTimeMineEventQueueMarch:pause_refresh(isShow)
    local root = self.roots[1]
    for i, v in pairs(self.ListView_world_attack:getItems()) do
        if v._path ~= nil then
            v._path:removeFromParent(true)
            v._path = nil
        end
    end
    self.ListView_world_attack:removeAllItems()
    if isShow == true then
        self:initDrawEventListView()
        self:RefreshTheInterfaceList(1)
    end
end

function redAlertTimeMineEventQueueMarch:onHide()
    self:setVisible(false)
end

function redAlertTimeMineEventQueueMarch:onShow()
    self:setVisible(true)
end

function redAlertTimeMineEventQueueMarch:RefreshTheInterfaceList(page)
	local root = self.roots[1]
	-- self.ListView_world_attack = ccui.Helper:seekWidgetByName(root,"ListView_world_attack")
	-- self.ListView_world_attack:removeAllItems()
	-- self.ListView_world_attack:jumpToTop()
	local items = self.ListView_world_attack:getItems()
	local posy = self.ListView_world_attack:getInnerContainer():getPositionY()
	
	self._father_list._first_event_cell = nil
	
	local eventItem = {}
	local nilItem = {}
	local closeItem = {}
	
	for i, v in pairs(items) do
		-- v:retain()
		if v._state == 1 then
			if nil == self.ListView_world_attack._first_event_cell then
				self.ListView_world_attack._first_event_cell = v
			end
			if nil == self._father_list._first_event_cell then
				self._father_list._first_event_cell = v
			end
			table.insert(eventItem, v)
		elseif v._state == 0 then
			table.insert(nilItem, v)
		elseif v._state == -1 then
			table.insert(closeItem, v)
		end
	end
	-- self._if_data_available = false
	local a_index = 0
	local cell =  nil
	self.isShow = false
	
	local listDataCell = {} 
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if nil == v._event_cell 
                and (tonumber(v._event_type) < 10 or tonumber(v._event_type) == 18)
                then
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
	
	-- debug.print(listDataCell)
	
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(listDataCell) do
			if nil == v._event_cell 
                and tonumber(v._event_type) ~= 10 
				and tonumber(v._event_type) ~= 11 
				and tonumber(v._event_type) ~= 12
                and tonumber(v._event_type) ~= 13 
                and tonumber(v._event_type) ~= 14 
                and tonumber(v._event_type) ~= 15 
                and tonumber(v._event_type) ~= 17 
				then
				-- self._if_data_available = true
				cell = table.remove(nilItem, 1, 1)
				cell:retain()
				self.ListView_world_attack:removeItem(self.ListView_world_attack:getIndex(cell))
				cell:removeFromParent(true)
				state_machine.excute("world_nearby_list_cell_change_update_draw", 0, {_datas = 
					{_cell = cell, _object = v, _listType = page, _state = 1}
					})
				self.ListView_world_attack:insertCustomItem(cell, 0)
				cell:release()
				self.ListView_world_attack:requestRefreshView()
				
				v._event_cell = cell
				cell._is_event = true
				
				if nil == self.ListView_world_attack._first_event_cell then
					self.ListView_world_attack._first_event_cell = cell
				end
				if nil == self._father_list._first_event_cell then
					self._father_list._first_event_cell = cell
				end
				state_machine.excute("adventure_mine_force_mobile",0,{v._sx,v._sy,v._dx,v._dy,cell,1})
				state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
				a_index = a_index + 1
				self.isShow = true
			end
		end
	end

    self._list_view = self.ListView_world_attack
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function redAlertTimeMineEventQueueMarch:initDrawEventListView()
	local root = self.roots[1]
	self.ListView_world_attack = ccui.Helper:seekWidgetByName(root,"ListView_world_attack")
	
	local playTheQueue = dms.element(dms["base_consume"], 81)
	local nCount = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
	-- local nCount = 5
	for i=1, 8 do
		local cell = WorldEventListCell:createCell()
		if nCount >= i then
			cell:init(nil, 1, 0, i)
		else
			cell:init(nil, 1, -1, i)
		end
		cell._is_index = i
		cell._is_nil = true
		cell._list_view = self.ListView_world_attack
		self.ListView_world_attack:addChild(cell)
	end
	
	self.ListView_world_attack:requestRefreshView()
    self._list_view = self.ListView_world_attack
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function redAlertTimeMineEventQueueMarch:onUpdate(dt)
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
        -- self._list_view_poy = posY
        -- local items = self._list_view:getItems()
        -- if items[1] == nil then
        --     return
        -- end
        -- local itemSize = items[1]:getContentSize()
        -- for i, v in pairs(items) do
        --     local tempY = v:getPositionY() + posY
        --     if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
        --         v:unload()
        --     else
        --         v:reload()
        --     end
        -- end
    end
end

function redAlertTimeMineEventQueueMarch:init(params1,params2,params3)
	self._rootWindows = params1
	self._rootWindows._march = self
	self._params = params2
	self._father_list = params3
    self:onInit()
    return self
end

function redAlertTimeMineEventQueueMarch:onInit()
    local csbredAlertTimeMineEventQueueMarch = csb.createNode(config_csb.cells.world.world_battle_infor_window_tab_1)
    local root = csbredAlertTimeMineEventQueueMarch:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineEventQueueMarch)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_world_attack_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_world_attack_arrow_up")
    
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
	
	self:initDrawEventListView()
	self:RefreshTheInterfaceList(1)
end

function redAlertTimeMineEventQueueMarch:onExit()
    state_machine.remove("red_alert_time_mine_event_queue_march_update") 
    state_machine.remove("red_alert_time_mine_event_queue_march_update_two") 
    state_machine.remove("red_alert_time_mine_event_queue_march_get_list_cells") 
    state_machine.remove("red_alert_time_mine_event_queue_march_stick_top") 
    state_machine.remove("red_alert_time_mine_event_queue_march_show") 
    state_machine.remove("red_alert_time_mine_event_queue_march_hide") 
    state_machine.remove("red_alert_time_mine_pause_refresh") 
end