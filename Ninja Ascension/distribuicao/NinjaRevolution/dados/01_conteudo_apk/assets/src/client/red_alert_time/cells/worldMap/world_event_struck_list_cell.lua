-----------------------------
--世界事件列表控件“来袭”
-----------------------------
worldEventStruckListCell = class("worldEventStruckListCellClass", Window)
worldEventStruckListCell.__size = nil


-- 更新列表的绘图
local world_struck_list_cell_change_update_draw_terminal = {
	_name = "world_struck_list_cell_change_update_draw",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local cell = params._datas._cell
		local object = params._datas._object
		local listType = params._datas._listType
		local state = params._datas._state
		local vipLevel = params._datas._vip_level
		cell:unload()
		cell:init(object, listType, state, vipLevel)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(world_struck_list_cell_change_update_draw_terminal)
state_machine.init()

function worldEventStruckListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil
	self.windowType = 0
	self.old_event_type = 0
	self.local_time = 0
	self.old_local_time = 0
	self.m_mineral = nil
	self.m_second = 0
	self.second_increase_time = 0--产量计数时间
	self.second_total = 0--产量收获值
	self._state = 0
	self._vip_level = 0

    local function init_world_event_struck_list_cell_terminal()
		--时间结束校验时间
        local world_event_struck_list_cell_time_over_terminal = {
            _name = "world_event_stryck_list_cell_time_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
				-- local fighting_type = "0"
				-- if tonumber(cell.m_object._event_type) == 11 then
					-- fighting_type = "12"
				-- end
				cell:updateListDraw(cell,fighting_type)
				--当前状态没改变，但是时间到了需要校验
				-- local function requesrAttackCheck(response)
					-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- cell:updateListDraw(cell,fighting_type)
					-- end
				-- end
				-- local m_times = getWorldTwopointMovementTime(cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy)
				-- protocol_command.world_add_target_event.param_list = "9" .. "\r\n" ..cell.m_object._dx.."\r\n" ..cell.m_object._dy.."\r\n"..m_times.."\r\n"..cell.m_object._time.."\r\n-"
				-- NetworkManager:register(protocol_command.world_add_target_event.code, nil, nil, nil, nil, requesrAttackCheck, false, nil)	
				
				state_machine.excute("adventure_mine_attack_update", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新列表内容信息
		local world_event_struck_list_cell_update_list_info_terminal = {
            _name = "world_event_struck_list_cell_update_list_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params[1]~= nil and params[1].m_object ~= nil then
					-- if params[1].m_object._update == true then
						params[1]:updateListDraw(params[1],params[2])
					-- end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(world_event_struck_list_cell_time_over_terminal)
        state_machine.add(world_event_struck_list_cell_update_list_info_terminal)
        state_machine.init()
    end
    init_world_event_struck_list_cell_terminal()
end

function worldEventStruckListCell:updateListDraw(cell,fighting_type)
	local root = self.roots[1]
	state_machine.excute("adventure_mine_update_map_draw", 0, 0)
	-- cell:onUpdateDraw()
	if tonumber(cell.m_object._event_type) == 10 then
		local items = cell._list_view:getItems()
		for i = 1, #items do
			if items[i] == cell then
				if cell._path ~= nil then
					cell._path:removeFromParent(true)
					cell._path = nil
				end
				cell:retain()
				cell:unload()
				cell._list_view:removeItem(i - 1)
				cell._state = 0
				cell.m_object = nil
				break
			end
		end
		
		-- local inserted = false
		-- for i = 1, #items do
			-- if (items[i]._state == 0 or items[i]._state == -1) and cell ~= items[i] then
				-- cell._list_view:insertCustomItem(cell, i - 2)
				-- cell:onInit()
				-- cell:release()
				-- cell._list_view:requestRefreshView()
				-- inserted = true
				-- break		
			-- end
		-- end
		-- if false == inserted then
			
			-- cell._list_view:insertCustomItem(cell, #items - 1)
			-- cell:onInit()
			-- cell:release()
			-- cell._list_view:requestRefreshView()
			-- inserted = true
		-- end
		-- if cell._list_view._first_event_cell == nil then
			-- local items = cell._list_view:getItems()
			-- cell._list_view._first_event_cell = items[1]
		-- end
		
		state_machine.excute("red_alert_time_mine_event_queue_refresh_the_interface_list", 0, 0)
		--刷新玩家数据
		state_machine.excute("main_window_update_userinfo", 0, nil)
		state_machine.excute("red_alert_time_mine_update_players_resources", 0, nil)
	elseif tonumber(cell.m_object._event_type) == 12 then
		if cell._path ~= nil then
			cell._path:removeFromParent(true)
			cell._path = nil
		end
		-- state_machine.excute("adventure_mine_force_mobile",0,{cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy,cell,2})	
	else
		if cell._path ~= nil then
			cell._path:removeFromParent(true)
			cell._path = nil
		end
	end
	-- cell.rewardList = getSceneReward(82)
	-- cell:rewarldShow()		
	state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
end


function worldEventStruckListCell:onEnterTransitionFinish()

end

function worldEventStruckListCell:onUpdateDraw()
    local root = self.roots[1]
	local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
	local Text_attack_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_player_name_lv")
	local Text_attack_res_xy_n = ccui.Helper:seekWidgetByName(root,"Text_attack_res_xy_n")
	local Text_arrive_time = ccui.Helper:seekWidgetByName(root,"Text_arrive_time")
	local LoadingBar_distance_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_distance_bar")
	Panel_implement_icon:setBackGroundImage("images/ui/share/world_implement_icon_4.png")
	Text_attack_player_name_lv:setString(self.m_object._nickname.." "..string.format(red_alert_all_str[13], ""..self.m_object._level))
	local Text_attack_res_xy_n = ccui.Helper:seekWidgetByName(root,"Text_attack_res_xy_n")
	local worldMines = ""
	if tonumber(self.m_object._world_mine_mould_id) > 0 then
		local element = dms.element(dms["world_mine_mould"], self.m_object._world_mine_mould_id)
		local name = dms.atos(element, world_mine_mould.name)
		worldMines = name.."["..self.m_object._dx..","..self.m_object._dy.."]"
	else
		worldMines = tipStringInfo_consumption_info[24].." "..string.format(red_alert_all_str[13], "".._ED.user_info.user_grade).."["..self.m_object._dx..","..self.m_object._dy.."]"
	end
	Text_attack_res_xy_n:setString(worldMines)
	self.local_time = (tonumber(self.m_object._start_time)/1000+tonumber(self.m_object._complete_time))-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
	local m_times = getWorldTwopointMovementTime(self.m_object._sx,self.m_object._sy,self.m_object._dx,self.m_object._dy)
	self.old_local_time = tonumber(self.m_object._complete_time)
	Text_arrive_time:setString(exChangeTimeToString(self.local_time))
	local progress = math.min((m_times-self.local_time)/m_times*100)
	LoadingBar_distance_bar:setPercent(progress)
end

function worldEventStruckListCell:onUpdate(dt)
	if self.roots == nil and self.roots[1] == nil then
        return
    end
    if self.local_time~= 0 then
		self.local_time = self.local_time - dt
		ccui.Helper:seekWidgetByName(self.roots[1],"Text_arrive_time"):setString(exChangeTimeToString(self.local_time))
		local progress = math.min((self.old_local_time-self.local_time)/self.old_local_time*100)
		ccui.Helper:seekWidgetByName(self.roots[1],"LoadingBar_distance_bar"):setPercent(progress)
        if self.local_time <= 0 then--客户端多延时一秒
            self.local_time = 0
            state_machine.excute("world_event_stryck_list_cell_time_over", 0, {_datas={cells = self}})
        end
		-- state_machine.excute("red_alert_time_mine_event_queue_refresh_button_struck", 0, exChangeTimeToString(self.local_time))
	end
end

function worldEventStruckListCell:init(info, w_type, state, vipLevel)
	self.m_object = info
	self.windowType = w_type
	self._state = state
	self._vip_level = vipLevel or 0
    -- if index ~= nil and index < 5 then
	self:onInit()
    -- end
	self:setContentSize(worldEventStruckListCell.__size)
    return self
end

function worldEventStruckListCell:onInit()
	
    local root = cacher.createUIRef(config_csb.cells.world.battle_infor_window_cell_3, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if worldEventStruckListCell.__size == nil then
        worldEventStruckListCell.__size = root:getContentSize()
    end  
	
	--定位
    fwin:addTouchEventListener(root , nil, 
    {
        terminal_name = "world_nearby_list_cell_positioning", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cell = self,
    }, nil, 1)    
    
    self:onUpdateDraw() 
	
	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self)
	
end

function worldEventStruckListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    local Text_attack_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_player_name_lv")
    local Text_attack_res_xy_n = ccui.Helper:seekWidgetByName(root,"Text_attack_res_xy_n")
    local Text_arrive_time = ccui.Helper:seekWidgetByName(root,"Text_arrive_time")
    local LoadingBar_distance_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_distance_bar")
    if Panel_implement_icon~= nil then
        Text_attack_player_name_lv:setString("")
        Text_attack_res_xy_n:setString("")
        Text_arrive_time:setString("")
        Panel_implement_icon:removeBackGroundImage()
        LoadingBar_distance_bar:setPercent(0)
    end
    self:unregisterOnNoteUpdate(self)
    if nil ~= self._path then
    	self._path:removeFromParent(true)
    	self._path = nil
    end
end

function worldEventStruckListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function worldEventStruckListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_3, root)
    root:removeFromParent(false)
    self.roots = {}
end

function worldEventStruckListCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_3, self.roots[1])
end

function worldEventStruckListCell:createCell()
	local cell = worldEventStruckListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end