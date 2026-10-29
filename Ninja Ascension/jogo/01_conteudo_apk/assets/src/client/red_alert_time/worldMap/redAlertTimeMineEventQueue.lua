-- ----------------------------------------------------------------------------------------------------
-- 说明：世界的事件队列
-- 0;//攻击移动到目标
-- 1;//返回中
-- 2;//攻击
-- 3;//加速返回
-- 4;//辙离
-- 5;//驻守
-- 6;//协防移动
-- 7;//协防中
-- 9;//校验前后端数据同步
-- 10;//清除
-- 11;//被攻击移动
-- 12;//攻击者返回中
-- 13;//被协防移动
-- 14;//被协防中
-- 15;//被协防返回中
-- 16;//协防辙离
-- 17;//协防遣散
-- 18;//协防返回中
-------------------------------------------------------------------------------------------------------
redAlertTimeMineEventQueue = class("redAlertTimeMineEventQueueClass", Window)
redAlertTimeMineEventQueue._march_index = 0
redAlertTimeMineEventQueue._struck_index = 0
redAlertTimeMineEventQueue._defense_index = 0
local red_alert_time_mine_event_queue_open_terminal = {
    _name = "red_alert_time_mine_event_queue_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineEventQueueClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMineEventQueue:new():init(), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local red_alert_time_mine_event_queue_close_terminal = {
	_name = "red_alert_time_mine_event_queue_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("redAlertTimeMineEventQueueClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(red_alert_time_mine_event_queue_open_terminal)
state_machine.add(red_alert_time_mine_event_queue_close_terminal)
state_machine.init()
    
function redAlertTimeMineEventQueue:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self.actionsOpen = false
	self.isShow = false
	self._current_page = 0
	self._if_data_available = false
	self.listItems = nil
	self.isOpen = true
	self.ListView_world_attack = nil
	self._current_march = nil
	self._current_struck = nil
	self._current_defense = nil
	self._march_point = nil
	self._struck_point = nil
	self._force_number = 0
	self._struck_number = 0
	self._defense_number = 0
	self.march_index = 0
	self.struck_index = 0
	self.defense_index = 0
	self.Text_distance_n_march = nil
	self.Text_distance_n_struck = nil
	self.Text_distance_n_defense = nil
	self.Button_world_attack_state_march = nil
	self.Button_world_attack_state_struck = nil
	self.Button_world_attack_state_defense = nil
	self.page_type = 0
	
	
	app.load("client.red_alert_time.cells.worldMap.world_event_list_cell")
	app.load("client.red_alert_time.cells.worldMap.world_event_no_list_cell")
	app.load("client.red_alert_time.worldMap.redAlertTimeMineEventQueueMarch")
	app.load("client.red_alert_time.worldMap.redAlertTimeMineEventQueueStruck")
	app.load("client.red_alert_time.worldMap.redAlertTimeMineEventQueueDefense")
	
	local function init_red_alert_time_mine_event_queue_terminal()
		
		-- 
        local red_alert_time_mine_event_queue_updte_draw_list_view_terminal = {
            _name = "red_alert_time_mine_event_queue_updte_draw_list_view",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.isOpen = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--显示
        local red_alert_time_mine_event_queue_show_terminal = {
            _name = "red_alert_time_mine_event_queue_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onShow()
				state_machine.excute("red_alert_time_mine_event_queue_refresh_the_interface_list", 0, 0)
				self.isOpen = false
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏
        local red_alert_time_mine_event_queue_hide_terminal = {
            _name = "red_alert_time_mine_event_queue_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
				self.isOpen = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--动画播放
        local red_alert_time_mine_event_queue_animation_terminal = {
            _name = "red_alert_time_mine_event_queue_animation",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("world_input_window_close", 0, 0)
				if instance.actionsOpen == false then
					instance:showAnimation("world_attack_window_open","world_attack_window_open_over")
					instance.actionsOpen = true
					
					-- if self.march_index > 0
					if self.struck_index == 2 and self.march_index == 3 and self.defense_index == 1 then
						if tonumber(params._datas._index) == 1 then
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 3}})
						elseif tonumber(params._datas._index) == 2 then
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 2}})
						else
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 1}})
						end
					elseif self.struck_index ==2 and self.march_index == 1 then
						if tonumber(params._datas._index) == 1 then
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 2}})
						else
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 1}})
						end
					elseif self.struck_index == 2 and self.defense_index == 1 then
						if tonumber(params._datas._index) == 1 then
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 3}})
						else
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 2}})
						end
					elseif self.march_index == 2 and self.defense_index == 1 then
						if tonumber(params._datas._index) == 1 then
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 3}})
						else
							state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 1}})
						end		
					elseif self.defense_index == 1 then
						state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 3}})
					elseif self.struck_index == 1 then
						state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 2}})
					elseif self.march_index == 1 then
						state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas={_page = 1}})		
					end
					ccui.Helper:seekWidgetByName(instance.roots[1],"Button_world_attack_window"):setVisible(true)
				else
					instance:showAnimation("world_attack_window_close","world_attack_window_close_over")
					instance.actionsOpen = false
					ccui.Helper:seekWidgetByName(instance.roots[1],"Button_world_attack_window"):setVisible(false)
				end
				state_machine.excute("red_alert_time_mine_event_queue_march_stick_top", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--翻页
        local red_alert_time_mine_event_queue_page_terminal = {
            _name = "red_alert_time_mine_event_queue_page",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:changeSelectPage(zstring.tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新界面
        local red_alert_time_mine_event_queue_refresh_the_interface_list_terminal = {
            _name = "red_alert_time_mine_event_queue_refresh_the_interface_list",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- instance:RefreshTheInterfaceList(self._current_page)
				local isXJ = false
				local isLX = false
				local isXF = false

                if _ED.world_map ~= nil and _ED.world_map.target_event_info ~= nil then
    				for i, v in pairs(_ED.world_map.target_event_info) do
    					if tonumber(v._event_type) ~= 10 then
    						if tonumber(v._event_type)<10 or tonumber(v._event_type) == 18 then
    							isXJ = true
    						end
    						if tonumber(v._event_type) >10 and tonumber(v._event_type) < 13 then
    							isLX = true
    						end
    						if tonumber(v._event_type) >= 13 and tonumber(v._event_type) < 18 then
    							isXF = true
    						end
    					end
    				end 
                end
				local index_p = instance._current_page
				if isXJ == true then
					state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas = {_page = 1}})
				end
				if isLX == true then
					state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas = {_page = 2}})
				end
				if isXF == true then
					state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas = {_page = 3}})
				end
				state_machine.excute("red_alert_time_mine_event_queue_page", 0, {_datas = {_page = index_p}})
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新行军button
        local red_alert_time_mine_event_queue_refresh_button_terminal = {
            _name = "red_alert_time_mine_event_queue_refresh_button",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新来袭button
		local red_alert_time_mine_event_queue_refresh_button_struck_terminal = {
            _name = "red_alert_time_mine_event_queue_refresh_button_struck",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateDrawStruck(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新协防button
		local red_alert_time_mine_event_queue_refresh_button_defense_terminal = {
            _name = "red_alert_time_mine_event_queue_refresh_button_defense",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateDrawDefense(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		--刷新队列数
        local red_alert_time_mine_event_queue_refresh_list_number_terminal = {
            _name = "red_alert_time_mine_event_queue_refresh_list_number",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateListNumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--设置世界的事件类型呈现
        local red_alert_time_mine_event_queue_set_event_type_show_terminal = {
            _name = "red_alert_time_mine_event_queue_set_event_type_show",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.setWorldEventShowType ~= nil then
    				instance:setWorldEventShowType()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_event_queue_update_show_lists_terminal = {
            _name = "red_alert_time_mine_event_queue_update_show_lists",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
    				instance:updateShowLists()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_event_queue_reset_all_lists_terminal = {
            _name = "red_alert_time_mine_event_queue_reset_all_lists",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:resetAllLists()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_mine_event_queue_updte_draw_list_view_terminal)
        state_machine.add(red_alert_time_mine_event_queue_show_terminal)
        state_machine.add(red_alert_time_mine_event_queue_hide_terminal)
        state_machine.add(red_alert_time_mine_event_queue_animation_terminal)
        state_machine.add(red_alert_time_mine_event_queue_page_terminal)
        state_machine.add(red_alert_time_mine_event_queue_refresh_the_interface_list_terminal)
        state_machine.add(red_alert_time_mine_event_queue_refresh_button_terminal)
        state_machine.add(red_alert_time_mine_event_queue_refresh_list_number_terminal)
        state_machine.add(red_alert_time_mine_event_queue_set_event_type_show_terminal)
        state_machine.add(red_alert_time_mine_event_queue_refresh_button_struck_terminal)
        state_machine.add(red_alert_time_mine_event_queue_update_show_lists_terminal)
        state_machine.add(red_alert_time_mine_event_queue_refresh_button_defense_terminal)
        state_machine.add(red_alert_time_mine_event_queue_reset_all_lists_terminal)

		state_machine.init()
	end
	
	init_red_alert_time_mine_event_queue_terminal()
	
end

function redAlertTimeMineEventQueue:resetAllLists()
    state_machine.excute("red_alert_time_mine_pause_refresh", 0, true)
    state_machine.excute("red_alert_time_mine_event_queue_struck_pause_refresh", 0, true)
    state_machine.excute("red_alert_time_mine_event_queue_defense_pause_refresh", 0, true)
end

function redAlertTimeMineEventQueue:updateShowLists()
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		_ED.world_map.target_event_info = {}
		local function responseWorldInfoInitCallBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then 
                    state_machine.excute("red_alert_time_mine_pause_refresh", 0, true)
                    state_machine.excute("red_alert_time_mine_event_queue_struck_pause_refresh", 0, true)
					state_machine.excute("red_alert_time_mine_event_queue_defense_pause_refresh", 0, true)
                end
            end
        end
		
		NetworkManager:register(protocol_command.world_info_init.code, nil, nil, nil, self, responseWorldInfoInitCallBack, false, nil)
	end
end

function redAlertTimeMineEventQueue:onShow()
    if self.actionsOpen == true then
        return
    end
    state_machine.excute("red_alert_time_mine_event_queue_animation", 0, "")
end

function redAlertTimeMineEventQueue:onHide()
    if self.actionsOpen == false then
        return
    end
    state_machine.excute("red_alert_time_mine_event_queue_animation", 0, "")
end

function redAlertTimeMineEventQueue:refreshTheDisplay()
	self.isShow = false
	self.updateDatas = nil
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if tonumber(v._event_type) ~= 10 then
				self.isShow = true
				return
			end
		end
	end
end

-- function redAlertTimeMineEventQueue:RefreshTheInterfaceList(page)
	-- local root = self.roots[1]
	-- if true then
		
	-- end
	-- self.ListView_world_attack = ccui.Helper:seekWidgetByName(root,"ListView_world_attack")
	-- -- ListView_world_attack:removeAllItems()
	-- -- ListView_world_attack:jumpToTop()
	-- local items = self.ListView_world_attack:getItems()
	-- local posy = self.ListView_world_attack:getInnerContainer():getPositionY()
	
	-- self.ListView_world_attack._first_event_cell = nil
	
	-- local eventItem = {}
	-- local nilItem = {}
	-- local closeItem = {}
	
	-- for i, v in pairs(items) do
		-- -- v:retain()
		-- if v._state == 1 then
			-- if nil == self.ListView_world_attack._first_event_cell then
				-- self.ListView_world_attack._first_event_cell = v
			-- end
			-- table.insert(eventItem, v)
		-- elseif v._state == 0 then
			-- table.insert(nilItem, v)
		-- elseif v._state == -1 then
			-- table.insert(closeItem, v)
		-- end
	-- end
	
	-- self._if_data_available = false
	-- local a_index = 0
	-- local cell =  nil
	-- self.isShow = false
	-- if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		-- for i, v in pairs(_ED.world_map.target_event_info) do
			-- if nil == v._event_cell 
				-- and tonumber(v._event_type) ~= 10 
				-- then
				-- self._if_data_available = true
				-- cell = table.remove(nilItem, 1, 1)
				-- state_machine.excute("world_nearby_list_cell_change_update_draw", 0, {_datas = 
					-- {_cell = cell, _object = v, _listType = page, _state = 1}
					-- })
				
				-- v._event_cell = cell
				-- cell._is_event = true
				
				-- if nil == self.ListView_world_attack._first_event_cell then
					-- self.ListView_world_attack._first_event_cell = cell
				-- end
				-- state_machine.excute("adventure_mine_force_mobile",0,{v._sx,v._sy,v._dx,v._dy,cell})
				-- a_index = a_index + 1
				-- self.isShow = true
			-- end
		-- end
	-- end
	
	-- self:updateDraw("")
-- end

function redAlertTimeMineEventQueue:changeSelectPage( page )
	local root = self.roots[1]
	self.ListView_world_attack = ccui.Helper:seekWidgetByName(root,"ListView_world_attack")
	local Panel_world_attack_box = ccui.Helper:seekWidgetByName(root,"Panel_world_attack_box")
	Panel_world_attack_box:setVisible(true)
	self.ListView_world_attack:setVisible(false)
	local Button_world_attack = ccui.Helper:seekWidgetByName(root,"Button_world_attack")
	local Button_world_attack_incoming = ccui.Helper:seekWidgetByName(root,"Button_world_attack_incoming")
	local Button_world_attack_help = ccui.Helper:seekWidgetByName(root,"Button_world_attack_help")
	if page == self._current_page then
        if page == 1 then
            Button_world_attack:setHighlighted(true)
		elseif page == 2 then
			Button_world_attack_incoming:setHighlighted(true)
        else
            Button_world_attack_help:setHighlighted(true)
        end
		if self._if_data_available == true then
			return
		end
    end
    self._current_page = page
    Button_world_attack:setHighlighted(false)
    Button_world_attack_incoming:setHighlighted(false)
    Button_world_attack_help:setHighlighted(false)
	-- if self._current_march ~= nil then
	-- 	if self._current_march:isVisible() == true then
	-- 		self._current_march:setVisible(false)
	-- 	end
	-- end
	-- if self._current_struck ~= nil then
	-- 	if self._current_struck:isVisible() == true then
	-- 		self._current_struck:setVisible(false)
	-- 	end
	-- end
	state_machine.excute("red_alert_time_mine_event_queue_march_hide", 0, nil)
    state_machine.excute("red_alert_time_mine_event_queue_struck_hide", 0, nil)
    state_machine.excute("red_alert_time_mine_event_queue_defense_hide", 0, nil)
	-- ListView_world_attack:removeAllItems()
	-- self.ListView_world_attack:jumpToTop()
	if page == 1 then
		Button_world_attack:setHighlighted(true)
		-- if Panel_world_attack_box._march ~= nil then
		-- 	Panel_world_attack_box._march:setVisible(true)
		-- end
		-- self:RefreshTheInterfaceList(page)
		if self._current_march == nil then
            self._current_march = state_machine.excute("red_alert_time_mine_event_queue_march_open", 0, {Panel_world_attack_box,1,self.ListView_world_attack})
        	-- self._current_march:setVisible(true)
        else
            state_machine.excute("red_alert_time_mine_event_queue_march_update", 0, nil)
            -- self._current_march:setVisible(true)
        end
	elseif page == 2 then
		Button_world_attack_incoming:setHighlighted(true)
		-- if self._current_struck ~= nil then
		-- 	self._current_struck:setVisible(true)
		-- end
		if self._current_struck == nil then
            self._current_struck = state_machine.excute("red_alert_time_mine_event_queue_struck_open", 0, {Panel_world_attack_box,1,self.ListView_world_attack})
        	-- self._current_struck:setVisible(true)
        else
            state_machine.excute("red_alert_time_mine_event_queue_struck_update", 0, nil)
            -- self._current_struck:setVisible(true)
        end
	else
		Button_world_attack_help:setHighlighted(true)
		if self._current_defense == nil then
			self._current_defense = state_machine.excute("red_alert_time_mine_event_queue_defense_open", 0, {Panel_world_attack_box,1,self.ListView_world_attack})
		else
			state_machine.excute("red_alert_time_mine_event_queue_defense_update", 0, nil)
		end
	end
end

function redAlertTimeMineEventQueue:setWorldEventShowType()
	local root = self.roots[1]

	self.march_index = 0
	self.struck_index = 0
	self.defense_index = 0
	local infomarch_index = 0
	local infostruck_index = 0
	local infodefense_index = 0
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if tonumber(v._event_type) < 10 or tonumber(v._event_type) == 18 then
				infomarch_index = infomarch_index + tonumber(v.march_index)
			end
			if tonumber(v._event_type) > 10 and tonumber(v._event_type) < 13 then
				infostruck_index = infostruck_index + tonumber(v.struck_index)
			end
			if tonumber(v._event_type) >= 13 and tonumber(v._event_type) < 18 then
				infodefense_index = infodefense_index + tonumber(v.defense_index)
			end
		end
	end
	
	if tonumber(infomarch_index) > 0 and tonumber(infostruck_index) > 0 and tonumber(infodefense_index) > 0 then
		self.march_index = 3
		self.struck_index = 2
		self.defense_index = 1
	elseif tonumber(infomarch_index) > 0 and tonumber(infostruck_index) > 0 then
		self.march_index = 2
		self.struck_index = 1
	elseif tonumber(infomarch_index) > 0 and tonumber(infodefense_index) > 0 then	
		self.march_index = 2
		self.defense_index = 1
	elseif tonumber(infostruck_index) > 0 and tonumber(infodefense_index) > 0 then
		self.struck_index = 2	
		self.defense_index = 1
	elseif tonumber(infomarch_index) > 0 then
		self.march_index = 1	
	elseif tonumber(infostruck_index) > 0 then
		self.struck_index = 1
	elseif tonumber(infodefense_index) > 0 then
		self.defense_index = 1		
	end
	-- if tonumber(infomarch_index) > 0 then
	-- 	self.march_index = self.march_index + 1
	-- end	
	-- if tonumber(infostruck_index) > 0 then
	-- 	self.march_index = self.march_index + 1
	-- 	self.struck_index = self.struck_index + 1
	-- end	
	-- if tonumber(infodefense_index) > 0 then
	-- 	self.march_index = self.march_index + 1
	-- 	self.struck_index = self.struck_index + 1
	-- 	self.defense_index = self.defense_index + 1
	-- end
	
	for i=1,3 do
		ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_"..i):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Panel_world_attack_icon_"..i):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Image_distance_bg_"..i):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_distance_n_"..i):setVisible(false)
	end
	redAlertTimeMineEventQueue._march_index = 0
	redAlertTimeMineEventQueue._struck_index = 0
	redAlertTimeMineEventQueue._defense_index = 0

	--行军的按钮
	if self.march_index >= 1 then
		redAlertTimeMineEventQueue._march_index = 1
		self.Button_world_attack_state_march = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_"..self.march_index)
		self.Button_world_attack_state_march:setVisible(true)
		local Panel_world_attack_icon_march = ccui.Helper:seekWidgetByName(root,"Panel_world_attack_icon_"..self.march_index)
		Panel_world_attack_icon_march:setVisible(true)
		Panel_world_attack_icon_march:removeAllChildren(true)
		Panel_world_attack_icon_march:setBackGroundImage("images/ui/share/world_implement_icon_1.png")
		local Image_distance_bg_march = ccui.Helper:seekWidgetByName(root,"Image_distance_bg_"..self.march_index)
		Image_distance_bg_march:setVisible(true)
		self.Text_distance_n_march = ccui.Helper:seekWidgetByName(root,"Text_distance_n_"..self.march_index)
		self.Text_distance_n_march:setVisible(true)
		-- self.Text_distance_n_march:setString(m_string)
	end
	
	--来袭的按钮
	if self.struck_index >= 1 then
		redAlertTimeMineEventQueue._struck_index = 1
		self.Button_world_attack_state_struck = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_"..self.struck_index)
		self.Button_world_attack_state_struck:setVisible(true)
		
		local Panel_world_attack_icon_struck = ccui.Helper:seekWidgetByName(root,"Panel_world_attack_icon_"..self.struck_index)
		Panel_world_attack_icon_struck:setVisible(true)
		Panel_world_attack_icon_struck:removeAllChildren(true)
		Panel_world_attack_icon_struck:setBackGroundImage("images/ui/share/world_implement_icon_4.png")
		local Image_distance_bg_struck = ccui.Helper:seekWidgetByName(root,"Image_distance_bg_"..self.struck_index)
		Image_distance_bg_struck:setVisible(true)
		self.Text_distance_n_struck = ccui.Helper:seekWidgetByName(root,"Text_distance_n_"..self.struck_index)
		self.Text_distance_n_struck:setVisible(true)
		-- self.Text_distance_n_struck:setString(m_string)
	end
	
	--协防的按钮
	if self.defense_index >= 1 then
		redAlertTimeMineEventQueue._defense_index = 1
		self.Button_world_attack_state_defense = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_"..self.defense_index)
		self.Button_world_attack_state_defense:setVisible(true)
		local Panel_world_attack_icon_defense = ccui.Helper:seekWidgetByName(root,"Panel_world_attack_icon_"..self.defense_index)
		Panel_world_attack_icon_defense:setVisible(true)
		Panel_world_attack_icon_defense:removeAllChildren(true)
		Panel_world_attack_icon_defense:setBackGroundImage("images/ui/share/world_implement_icon_6.png")
		local Image_distance_bg_defense = ccui.Helper:seekWidgetByName(root,"Image_distance_bg_"..self.defense_index)
		Image_distance_bg_defense:setVisible(true)
		self.Text_distance_n_defense = ccui.Helper:seekWidgetByName(root,"Text_distance_n_"..self.defense_index)
		self.Text_distance_n_defense:setVisible(true)
		-- self.Text_distance_n_defense:setString(m_string)
	end
	state_machine.excute("notification_center_update", 0, "push_notification_queue_march")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_struck")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_defense")

	if self.actionsOpen == true then
		ccui.Helper:seekWidgetByName(root,"Button_world_attack_window"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root,"Button_world_attack_window"):setVisible(false)
	end
end

function redAlertTimeMineEventQueue:updateDraw(m_string)
	local root = self.roots[1]
	
	--行军的按钮
	if self.Text_distance_n_march ~= nil then
		self.Text_distance_n_march:setString(m_string)
	end
	state_machine.excute("notification_center_update", 0, "push_notification_queue_march")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_struck")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_defense")
	-- --来袭的按钮
	-- if self.Text_distance_n_struck ~= nil then
		-- self.Text_distance_n_struck:setString(m_string)
	-- end
	
	-- --协防的按钮
	-- if self.Text_distance_n_defense ~= nil then
		-- self.Text_distance_n_defense:setString(m_string)
	-- end
end

function redAlertTimeMineEventQueue:updateDrawStruck(m_string)
	local root = self.roots[1]
	--来袭的按钮
	if self.Text_distance_n_struck ~= nil then
		self.Text_distance_n_struck:setString(m_string)
	end
	state_machine.excute("notification_center_update", 0, "push_notification_queue_march")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_struck")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_defense")
end

function redAlertTimeMineEventQueue:updateDrawDefense(m_string)
	local root = self.roots[1]
	--协防的按钮
	if self.Text_distance_n_defense ~= nil then
		self.Text_distance_n_defense:setString(m_string)
	end
	state_machine.excute("notification_center_update", 0, "push_notification_queue_march")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_struck")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_defense")
end


function redAlertTimeMineEventQueue:updateListNumber()
	local root = self.roots[1]
	self._force_number = 0
	self._struck_number = 0
	self._defense_number = 0
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if tonumber(v._event_type) < 10 or tonumber(v._event_type) == 18 then
				self._force_number = self._force_number + 1
			elseif tonumber(v._event_type) > 10 and tonumber(v._event_type) < 13 then	
				self._struck_number = self._struck_number + 1
			elseif tonumber(v._event_type) >= 13 and tonumber(v._event_type) < 18 then	
				self._defense_number = self._defense_number + 1
			end
		end
	end
	--print("self._force_number=="..self._force_number)
	--print("self._struck_number=="..self._struck_number)
	local playTheQueue = dms.element(dms["base_consume"], 81)
	local nCount = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
	ccui.Helper:seekWidgetByName(root,"Button_world_attack"):setTitleText(string.format(tipStringInfo_consumption_info[14],self._force_number, nCount))
	
	ccui.Helper:seekWidgetByName(root,"Button_world_attack_incoming"):setTitleText(string.format(tipStringInfo_consumption_info[15],self._struck_number))
	local wdatas = zstring.split(dms.string(dms["world_config"], 22 , world_config.param), ",")
	ccui.Helper:seekWidgetByName(root,"Button_world_attack_help"):setTitleText(string.format(tipStringInfo_consumption_info[16],self._defense_number,tonumber(wdatas[1])))

	state_machine.excute("notification_center_update", 0, "push_notification_queue_march")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_struck")
	state_machine.excute("notification_center_update", 0, "push_notification_queue_defense")
end

function redAlertTimeMineEventQueue:onUpdate(dt)
	-- self:refreshTheDisplay()
	if self.isShow == true then
		-- if self.isOpen == true then
		-- 	state_machine.excute("red_alert_time_mine_event_queue_show", 0, 0)
		-- else
			-- if self._current_march ~= nil then
				-- if self.ListView_world_attack._first_event_cell ~= nil then
					-- local text_info = zstring.split(ccui.Helper:seekWidgetByName(self.ListView_world_attack._first_event_cell.roots[1],"Text_distance_ing"):getString(), "/")
					-- state_machine.excute("red_alert_time_mine_event_queue_refresh_button", 0, text_info[1])	
				-- else
					-- -- state_machine.excute("red_alert_time_mine_event_queue_refresh_button", 0, "")	
					-- self:updateDraw("")
				-- end
				-- self.isOpen = true
			-- end
			
			
		-- end
	elseif self.isShow == false then
		-- state_machine.excute("red_alert_time_mine_event_queue_hide", 0, 0)
	end
end

function redAlertTimeMineEventQueue:init()
    self:onInit()
    return self
end

-- function redAlertTimeMineEventQueue:initDrawEventListView()
	-- local root = self.roots[1]
	-- self.ListView_world_attack = ccui.Helper:seekWidgetByName(root,"ListView_world_attack")
	
	-- for i=1, 10 do
		-- cell = WorldEventListCell:createCell()
		-- cell:init(nil, 1, 0)
		-- cell._is_nil = true
		-- cell._list_view = self.ListView_world_attack
		-- self.ListView_world_attack:addChild(cell)
	-- end
	
	-- self.ListView_world_attack:requestRefreshView()
-- end

function redAlertTimeMineEventQueue:onInit()
    local csbredAlertTimeMineEventQueue = csb.createNode(config_csb.world_map.battle_infor)
    local root = csbredAlertTimeMineEventQueue:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineEventQueue)
	
	local action = csb.createTimeline(config_csb.world_map.battle_infor)
	table.insert(self.actions, action)
	csbredAlertTimeMineEventQueue:runAction(action)
	
	-- self:initDrawEventListView()
	
	for i=1, 3 do
		--打开动画界面
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_"..i), nil, 
		{
			terminal_name = "red_alert_time_mine_event_queue_animation",
			terminal_state = 0,
			open_tyoe = 1,
			_index = i,
		},
		nil,1)
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_queue_march",
		    _widget = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_1"),
		    _m_type = 0,
		    _invoke = nil,
		    _interval = 0.2,})
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_queue_struck",
		    _widget = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_2"),
		    _m_type = 0,
		    _invoke = nil,
		    _interval = 0.2,})
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_queue_defense",
		    _widget = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_3"),
		    _m_type = 0,
		    _invoke = nil,
		    _interval = 0.2,})
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_attack_window"), nil, 
    {
        terminal_name = "red_alert_time_mine_event_queue_animation",
        terminal_state = 0,
    },
    nil,1)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panell_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_event_queue_animation",
        terminal_state = 0,
    },
    nil,1)
	
	
	--翻到行军页
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_attack"), nil, 
    {
        terminal_name = "red_alert_time_mine_event_queue_page",
        terminal_state = 0,
        touch_black = true,
		_page = 1,
    },
    nil,1)
	
	--翻到来袭页
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_attack_incoming"), nil, 
    {
        terminal_name = "red_alert_time_mine_event_queue_page",
        terminal_state = 0,
        touch_black = true,
		_page = 2,
    },
    nil,1)
	
	--翻到协防页
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_attack_help"), nil, 
    {
        terminal_name = "red_alert_time_mine_event_queue_page",
        terminal_state = 0,
        touch_black = true,
		_page = 3,
    },
    nil,1)
	
	-- self:updateDraw()
	self.isOpen = false
	-- self:changeSelectPage(1)
    self:setWorldEventShowType()
    state_machine.excute("red_alert_time_mine_event_queue_refresh_the_interface_list", 0, 0)
end

function redAlertTimeMineEventQueue:showAnimation(actionStart, actionEnd)
	self.actions[1]:play(actionStart, false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == actionEnd then
			--打开结束
        end
        
    end)
end

function redAlertTimeMineEventQueue:onExit()
	state_machine.remove("red_alert_time_mine_event_queue_updte_draw_list_view")
    state_machine.remove("red_alert_time_mine_event_queue_show")
    state_machine.remove("red_alert_time_mine_event_queue_hide")
    state_machine.remove("red_alert_time_mine_event_queue_animation")
    state_machine.remove("red_alert_time_mine_event_queue_page")
    state_machine.remove("red_alert_time_mine_event_queue_refresh_the_interface_list")
    state_machine.remove("red_alert_time_mine_event_queue_refresh_button")
    state_machine.remove("red_alert_time_mine_event_queue_refresh_list_number")
    state_machine.remove("red_alert_time_mine_event_queue_set_event_type_show")
    state_machine.remove("red_alert_time_mine_event_queue_refresh_button_struck")
    state_machine.remove("red_alert_time_mine_event_queue_update_show_lists")
    state_machine.remove("red_alert_time_mine_event_queue_refresh_button_defense")
    state_machine.remove("red_alert_time_mine_event_queue_reset_all_lists")
end