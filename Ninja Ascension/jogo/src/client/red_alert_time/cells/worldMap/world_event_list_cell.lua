-----------------------------
--世界事件列表控件
-----------------------------
WorldEventListCell = class("WorldEventListCellClass", Window)
WorldEventListCell.__size = nil

-- 更新列表的绘图
local world_nearby_list_cell_change_update_draw_terminal = {
	_name = "world_nearby_list_cell_change_update_draw",
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
state_machine.add(world_nearby_list_cell_change_update_draw_terminal)
state_machine.init()

function WorldEventListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil
	self.windowType = 0
	self.old_event_type = -1
	self.local_time = 0
	self.old_local_time = 0
	self.m_mineral = nil
	self.m_second = 0
	self.second_increase_time = 0--产量计数时间
	self.second_total = 0--产量收获值
	self._state = 0
	self._vip_level = 0
	
	self.rewardList = nil

	self.isAccelerate = false --是否加速

	
	app.load("client.red_alert_time.utils.ShortCut")
	app.load("client.red_alert_time.worldMap.redAlertTimeMineBattleTroopsInfor")
	
    local function init_world_nearby_list_cell_terminal()
		--时间结束校验时间
        local world_nearby_list_cell_time_over_terminal = {
            _name = "world_nearby_list_cell_time_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
				local fighting_type = "0"
				if tonumber(cell.m_object._event_type) == 0 or tonumber(cell.m_object._event_type) == 6 then
					fighting_type = "2"
				elseif tonumber(cell.m_object._event_type) == 1 or tonumber(cell.m_object._event_type) == 18 then 
					fighting_type = "3"
				elseif tonumber(cell.m_object._event_type) == 5 then 	
					fighting_type = "4"
				elseif tonumber(cell.m_object._event_type) == 7 then
					fighting_type = "16"
				end
				local _x = 0
				local _y = 0
				--当前状态没改变，但是时间到了需要校验
				local function requesrAttackCheck(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							checkRewardObtainDraw()
							if cell ~= nil and cell.m_object ~= nil and cell.old_event_type ~= cell.m_object._event_type then
								if fighting_type == "2" then
									-- cell.fighting_type = 2
									state_machine.excute("adventure_mine_get_cells_obj", 0, {_x,_y})
									-- if cell._path~= nil and cell._path:getChildByTag(999) ~= nil then
									-- 	csb.animationChangeToAction(cell._path:getChildByTag(999), 0, 0, false)
									-- end
								end
								state_machine.excute("world_nearby_list_cell_update_list_info", 0, {cell, fighting_type})
								cell.old_event_type = cell.m_object._event_type
							end
							-- checkRewardObtainDraw()
						end	
					end
				end
				local m_times = 0
				if zstring.tonumber(cell.m_object._target_type) == 1000 then
					m_times = getWorldTwopointMovementTime(cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy, true)
				else
					if zstring.tonumber(cell.m_object._event_type) == 6 then
						m_times = getWorldTwopointMovementTime(cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy, nil, true)
					else
						m_times = getWorldTwopointMovementTime(cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy)
					end
				end
				_x = cell.m_object._dx
				_y = cell.m_object._dy
				protocol_command.world_add_target_event.param_list = "9" .. "\r\n" ..cell.m_object._dx.."\r\n" ..cell.m_object._dy.."\r\n"..m_times.."\r\n"..cell.m_object._time.."\r\n-"
				NetworkManager:register(protocol_command.world_add_target_event.code, nil, nil, nil, self, requesrAttackCheck, false, nil)	
				
				state_machine.excute("adventure_mine_attack_update", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--加速或者撤销
		local world_nearby_list_cell_accelerate_or_revoked_terminal = {
            _name = "world_nearby_list_cell_accelerate_or_revoked",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
				if cell ~= nil and cell.m_object ~= nil then
	            	cell.isAccelerate = true
					local fighting_type = "0"
					if tonumber(cell.m_object._event_type) == 0 or tonumber(cell.m_object._event_type) == 6 then
						fighting_type = "2"
					elseif tonumber(cell.m_object._event_type) == 1 or tonumber(cell.m_object._event_type) == 18 then 
						fighting_type = "3"
					elseif tonumber(cell.m_object._event_type) == 5 then 	
						fighting_type = "4"
					elseif tonumber(cell.m_object._event_type) == 7 then
						fighting_type = "16"
					end
					local _x = 0
					local _y = 0
					local function requesrAttack(response)
						
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								-- cell:updateListDraw(cell,fighting_type)
								checkRewardObtainDraw()
								if fighting_type == "2" then
									local info = _ED.world_map.world_map_info_list[_x .. "," .. _y]
									if info ~= nil and ((info._type >= 0 and info._type <= 5) or info._type == 1000) then
										if tonumber(cell.old_event_type) ~= 6 then
											state_machine.excute("adventure_mine_get_cells_obj", 0, {_x,_y})
										end
									end
								end
								if cell~= nil and cell.m_object ~= nil and cell.old_event_type ~= cell.m_object._event_type then
									state_machine.excute("world_nearby_list_cell_update_list_info", 0, {cell, fighting_type})
									state_machine.excute("home_map_update_tanke_info", 0, "")
									cell.old_event_type = cell.m_object._event_type
								end
								-- checkRewardObtainDraw()
							end	
						end
					end
					local m_times = 0
					if zstring.tonumber(cell.m_object._target_type) == 1000 then
						m_times = getWorldTwopointMovementTime(cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy, 1000)
					else
						if zstring.tonumber(cell.m_object._event_type) == 6 then
							m_times = getWorldTwopointMovementTime(cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy, nil, true)
						else
							m_times = getWorldTwopointMovementTime(cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy)
						end
					end
					_x = cell.m_object._dx
					_y = cell.m_object._dy
					protocol_command.world_add_target_event.param_list = fighting_type .. "\r\n" ..cell.m_object._dx.."\r\n" ..cell.m_object._dy.."\r\n"..m_times.."\r\n"..cell.m_object._time.."\r\n-"
					NetworkManager:register(protocol_command.world_add_target_event.code, nil, nil, nil, self, requesrAttack, false, nil)
					state_machine.excute("adventure_mine_attack_update", 0, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--操作提示
		local world_nearby_list_cell_request_accelerate_terminal = {
            _name = "world_nearby_list_cell_request_accelerate",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
				if tonumber(cell.m_object._event_type) == 5 then
					if tonumber(cell.second_total) ~= tonumber(cell.m_object._max_out_put) then
						state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 2}})
						return
					end
					state_machine.excute("world_nearby_list_cell_accelerate_or_revoked", 0, {_datas = {cells = cell}})
				else
					--0攻击移动，1回城移动，2攻击，3加速返回，4请求撤离，5驻守状态，6协防移动，7协防中，8打玩家移动，9校验
					if tonumber(cell.m_object._event_type) == 0 or tonumber(cell.m_object._event_type) == 1 
						or tonumber(cell.m_object._event_type) == 6 or tonumber(cell.m_object._event_type) == 18 then
						state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = cell, m_type = 3}})
					elseif tonumber(cell.m_object._event_type) == 7	then
						state_machine.excute("world_nearby_list_cell_accelerate_or_revoked", 0, {_datas = {cells = cell}})
					else
						state_machine.excute("world_nearby_list_cell_accelerate_or_revoked", 0, {_datas = {cells = cell}})
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新列表内容信息
		local world_nearby_list_cell_update_list_info_terminal = {
            _name = "world_nearby_list_cell_update_list_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if params[1]~= nil and params[1].m_object ~= nil and params[1]._state == 1 then
            		params[1].isAccelerate = false
					-- if params[1].m_object._update == true then
						params[1]:updateListDraw(params[1],params[2])
					-- end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(world_nearby_list_cell_time_over_terminal)
        state_machine.add(world_nearby_list_cell_accelerate_or_revoked_terminal)
        state_machine.add(world_nearby_list_cell_request_accelerate_terminal)
        state_machine.add(world_nearby_list_cell_update_list_info_terminal)
        state_machine.init()
    end
    init_world_nearby_list_cell_terminal()
end

function WorldEventListCell:updateListDraw(cell,fighting_type)
	local root = self.roots[1]
	state_machine.excute("adventure_mine_update_map_draw", 0, 0)
	state_machine.excute("formation_attack_update_info", 0, nil)
	cell:onUpdateDraw()
	if tonumber(cell.m_object._event_type) == 10 then
		local items = cell._list_view:getItems()
		for i = 1, #items do
			if items[i] == cell then
				if cell._path ~= nil then
					if cell._list_view._first_event_cell == cell then
						cell._list_view._first_event_cell = nil
					end
					cell._path:removeFromParent(true)
					-- if cell._path:getChildByTag(999) ~= nil then
					-- 	-- cell._path:getChildByTag(999)._nextAction = _enum_spine_tank_frame_index.animation_attack
					-- 	csb.animationChangeToAction(cell._path:getChildByTag(999), _enum_spine_tank_frame_index.animation_attack, _enum_spine_tank_frame_index.animation_attack, false)
							
					-- end	
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
		
		local inserted = false
		for i = 1, #items do
			if (items[i]._state == 0 or items[i]._state == -1) and cell ~= items[i] then
				cell._list_view:insertCustomItem(cell, i - 2)
				cell:onInit()
				cell:release()
				cell._list_view:requestRefreshView()
				inserted = true
				break		
			end
		end
		if false == inserted then
			
			cell._list_view:insertCustomItem(cell, #items - 1)
			cell:onInit()
			cell:release()
			cell._list_view:requestRefreshView()
			inserted = true
		end
		if cell ~= nil and cell._list_view~= nil and cell._list_view._first_event_cell == nil then
			local items = cell._list_view:getItems()
			cell._list_view._first_event_cell = items[1]
		end
		
		state_machine.excute("red_alert_time_mine_event_queue_refresh_the_interface_list", 0, 0)
		--刷新玩家数据
		state_machine.excute("main_window_update_userinfo", 0, nil)
		state_machine.excute("red_alert_time_mine_update_players_resources", 0, nil)
	elseif tonumber(cell.m_object._event_type) == 1 or tonumber(cell.m_object._event_type) == 18 then
		if cell._path ~= nil then
			cell._path:removeFromParent(true)
			-- if cell._path:getChildByTag(999) ~= nil then
			-- 	-- cell._path:getChildByTag(999)._nextAction = _enum_spine_tank_frame_index.animation_attack-1
			-- 	if cell.fighting_type == 2 then
			-- 		-- cell._path:getChildByTag(999)._nextAction = _enum_spine_tank_frame_index.animation_attack-1
			-- 		csb.animationChangeToAction(cell._path:getChildByTag(999), _enum_spine_tank_frame_index.animation_attack+1, _enum_spine_tank_frame_index.animation_attack+1, false)
			-- 	else
			-- 		-- cell._path:getChildByTag(999)._nextAction = _enum_spine_tank_frame_index.animation_attack
			-- 		csb.animationChangeToAction(cell._path:getChildByTag(999), _enum_spine_tank_frame_index.animation_attack, _enum_spine_tank_frame_index.animation_attack, false)
					
			-- 	end
			-- end	
			cell._path = nil
		end
		state_machine.excute("adventure_mine_force_mobile",0,{cell.m_object._sx,cell.m_object._sy,cell.m_object._dx,cell.m_object._dy,cell})
	elseif tonumber(cell.m_object._event_type) == 0 or tonumber(cell.m_object._event_type) == 6 or tonumber(cell.m_object._event_type) == 8 then
		--加速的处理
	else
		if cell._path ~= nil then
			cell._path:removeFromParent(true)
			-- if cell._path:getChildByTag(999) ~= nil then
			-- 	if cell.fighting_type == 2 then
			-- 		-- cell._path:getChildByTag(999)._nextAction = _enum_spine_tank_frame_index.animation_attack-1
			-- 		csb.animationChangeToAction(cell._path:getChildByTag(999), _enum_spine_tank_frame_index.animation_attack+1, _enum_spine_tank_frame_index.animation_attack+1, false)
			-- 	else
			-- 		-- cell._path:getChildByTag(999)._nextAction = _enum_spine_tank_frame_index.animation_attack
			-- 		csb.animationChangeToAction(cell._path:getChildByTag(999), _enum_spine_tank_frame_index.animation_attack, _enum_spine_tank_frame_index.animation_attack, false)

			-- 	end
			-- end
			cell._path = nil
		end
	end
	-- cell.rewardList = getSceneReward(82)	
	-- checkRewardObtainDraw()
	state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
end

function WorldEventListCell:onEnterTransitionFinish()

end

function WorldEventListCell:onUpdateDraw()
	if -1 == self._state then
		self:onCloseUpdateDraw()
	end
	
	if 0 == self._state then
		self:onNilUpdateDraw()
	end
	
	if 1 == self._state then
		self:onEventUpdateDraw()
	end
end

function WorldEventListCell:onNilUpdateDraw()
    local root = self.roots[1]

	-- local attackCount = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(self._is_index)-1) --
	-- print("attackCount=="..attackCount)
	--vip的暂时先去掉
	ccui.Helper:seekWidgetByName(root,"Button_implement_vip_recharge"):setVisible(false)
	ccui.Helper:seekWidgetByName(root,"Text_implement_vip"):setVisible(false)
	ccui.Helper:seekWidgetByName(root,"Text_troops_empty"):setVisible(true)
	--暂时所有的队列开放	
end

function WorldEventListCell:onCloseUpdateDraw()
	local root = self.roots[1]
	local playTheQueue = dms.element(dms["base_consume"], 81)
	for i=4, 18 do
		if dms.atoi(playTheQueue, i) == tonumber(self._vip_level) then
			ccui.Helper:seekWidgetByName(root,"Text_implement_vip"):setString(string.format(formation_type_string[18], (i-4)))
			return
		end
	end
	
	
	
	-- local attackCount = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(self._is_index)-1) --
	-- print("attackCount=="..attackCount)
	--vip的暂时先去掉
	-- ccui.Helper:seekWidgetByName(root,"Button_implement_vip_recharge"):setVisible(false)
	-- ccui.Helper:seekWidgetByName(root,"Text_implement_vip"):setVisible(false)
	-- ccui.Helper:seekWidgetByName(root,"Text_troops_empty"):setVisible(true)
	--暂时所有的队列开放	
end

function WorldEventListCell:onEventUpdateDraw()
    local root = self.roots[1]
	
	--攻打的名称，等级
	local Text_attack_res_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_res_name_lv")
	if zstring.tonumber(self.m_object._target_type) > 0 and zstring.tonumber(self.m_object._target_type) < 1000 then
		local mine_name = dms.atos(self.m_mineral, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(self.m_mineral, world_mine_mould.level)
		Text_attack_res_name_lv:setString(mine_name)
		Text_attack_res_name_lv:setColor(cc.c3b(color_Type[tonumber(self.m_object._quality)+1][1], color_Type[tonumber(self.m_object._quality)+1][2], color_Type[tonumber(self.m_object._quality)+1][3]))
	else
		if zstring.tonumber(self.m_object._target_type) == 1000 then
			local npcId = dms.int(dms["rebel_haunt_mould"], self.m_object._world_mine_mould_id, rebel_haunt_mould.npc_mould_id)
			local npcName = dms.string(dms["npc"], npcId, npc.npc_name)
			Text_attack_res_name_lv:setString(npcName.." "..friends_tip_string[12].._ED.world_level)
			Text_attack_res_name_lv:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		else
			Text_attack_res_name_lv:setString(self.m_object._nickname.." "..friends_tip_string[12]..self.m_object._level)
			Text_attack_res_name_lv:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		end
	end
	--攻打的坐标
	local Text_attack_res_xy_n = ccui.Helper:seekWidgetByName(root,"Text_attack_res_xy_n")
	Text_attack_res_xy_n:setString(self.m_object._dx..","..self.m_object._dy)
	--移动和采集的进度条
	self.local_time = (tonumber(self.m_object._start_time)/1000+tonumber(self.m_object._complete_time))-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
	if tonumber(self.m_object._event_type) == 5 then
		self.local_time = (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))-(tonumber(self.m_object._start_time)/1000)
		if self.local_time < 0 then
			self.local_time = 0
		end
	end
	local m_times = 0
	if zstring.tonumber(self.m_object._target_type) == 1000 then
		m_times = getWorldTwopointMovementTime(self.m_object._sx,self.m_object._sy,self.m_object._dx,self.m_object._dy, true)
	else
		if zstring.tonumber(self.m_object._event_type) == 6 then
			m_times = getWorldTwopointMovementTime(self.m_object._sx,self.m_object._sy,self.m_object._dx,self.m_object._dy, nil, true)
		else
			m_times = getWorldTwopointMovementTime(self.m_object._sx,self.m_object._sy,self.m_object._dx,self.m_object._dy)
		end
	end
	self.old_local_time = tonumber(self.m_object._complete_time)
	
	local LoadingBar_distance_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_distance_bar")
	local Text_distance_ing = ccui.Helper:seekWidgetByName(root,"Text_distance_ing")
	LoadingBar_distance_bar:setPercent(0)
	if tonumber(self.m_object._event_type) == 5 then
		local prev_out_put = zstring.tonumber(self.m_object._prev_out_put) + self.m_second*self.local_time
		prev_out_put = math.max(0,prev_out_put)
		Text_distance_ing:setString(exChangeNumToString(prev_out_put).."/"..exChangeNumToString(tonumber(self.m_object._max_out_put)))
		local progress = math.min((zstring.tonumber(self.m_object._prev_out_put) + self.m_second*self.local_time)/tonumber(self.m_object._max_out_put)*100)
		LoadingBar_distance_bar:setPercent(progress)
	elseif(tonumber(self.m_object._event_type) == 0 or tonumber(self.m_object._event_type) == 1 
		or tonumber(self.m_object._event_type) == 6 or tonumber(self.m_object._event_type) == 8
		or tonumber(self.m_object._event_type) == 18) 
		and self.local_time ~= 0 then 
		Text_distance_ing:setString(exChangeTimeToString(self.local_time))
		local progress = math.min((self.old_local_time-self.local_time)/self.old_local_time*100)
		LoadingBar_distance_bar:setPercent(progress)
	elseif tonumber(self.m_object._event_type) == 7 then	
		Text_distance_ing:setString(red_alert_time_str[270])
		LoadingBar_distance_bar:setPercent(0)
	end
	
	
	--加速和撤销的按钮
	local Button_quicken = ccui.Helper:seekWidgetByName(root,"Button_quicken")
	local b_image_name = nil
	--button的换图方法
	-- loadTextureNormal
	-- loadTexturePressed
	-- loadTextureDisabled
	--队列图标（移动，占领，返回）
	local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
	local image_name = nil
	
	if tonumber(self.m_object._event_type) == 0 or tonumber(self.m_object._event_type) == 8 or tonumber(self.m_object._event_type) == 6 then--移动（去）
		image_name = "images/ui/share/world_implement_icon_1.png"
		b_image_name = "images/ui/share/button_quicken_1.png"
	elseif tonumber(self.m_object._event_type) == 1 or tonumber(self.m_object._event_type) == 18 then--移动（回）
		image_name = "images/ui/share/world_implement_icon_3.png"
		b_image_name = "images/ui/share/button_quicken_1.png"
	elseif tonumber(self.m_object._event_type) == 7 then
		image_name = "images/ui/share/world_implement_icon_7.png"
		b_image_name = "images/ui/share/button_back_1.png"	
	else
		image_name = "images/ui/share/world_implement_icon_2.png"
		b_image_name = "images/ui/share/button_back_1.png"
	end
	Panel_implement_icon:setBackGroundImage(image_name)
	Button_quicken:loadTextureNormal(b_image_name, 1)
	Button_quicken:loadTexturePressed(b_image_name, 1)
	Button_quicken:loadTextureDisabled(b_image_name, 1)
	
end

function WorldEventListCell:init(info, w_type, state, vipLevel)
	self.m_object = info
	self.windowType = w_type
	self._state = state
	self._vip_level = vipLevel or 0
	if nil ~= self.m_object then
		self.old_event_type = zstring.tonumber(self.m_object._event_type)
		if zstring.tonumber(self.m_object._target_type) > 0 and zstring.tonumber(self.m_object._target_type) < 1000 then
			self.m_mineral = dms.element(dms["world_mine_mould"], self.m_object._world_mine_mould_id)
			local second_info = zstring.split(dms.atos(self.m_mineral, world_mine_mould.per_second_output), ",")
			if tonumber(self.m_object._quality) == 0 then
				if self.m_object._bonus_value ~= 0 then
					self.m_second = tonumber(second_info[2])*(1+self.m_object._bonus_value/100)
				else
					self.m_second = tonumber(second_info[2])
				end
				
			else
				if self.m_object._bonus_value ~= 0 then
					self.m_second = tonumber(second_info[2]) * (1+tonumber(self.m_object._quality)*0.5+self.m_object._bonus_value/100)
				else
					self.m_second = tonumber(second_info[2]) * (1+tonumber(self.m_object._quality)*0.5)
				end
			end
		end
	end
    -- if index ~= nil and index < 5 then
	self:onInit()
    -- end
	self:setContentSize(WorldEventListCell.__size)
    return self
end

function WorldEventListCell:onInitNilCell()
    local root = cacher.createUIRef(config_csb.cells.world.battle_infor_window_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if WorldEventListCell.__size == nil then
        WorldEventListCell.__size = root:getContentSize()
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
end

function WorldEventListCell:onInitCloseCell()
	 local root = cacher.createUIRef(config_csb.cells.world.battle_infor_window_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if WorldEventListCell.__size == nil then
        WorldEventListCell.__size = root:getContentSize()
    end
	--充值
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_implement_vip_recharge") , nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
    }, nil, 1)   
	self:onUpdateDraw()
end

function WorldEventListCell:onInitEventCell()
    local root = cacher.createUIRef(config_csb.cells.world.battle_infor_window_cell_1, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if WorldEventListCell.__size == nil then
        WorldEventListCell.__size = root:getContentSize()
    end  
	
	--加速和撤销
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_quicken") , nil, 
    {
        terminal_name = "world_nearby_list_cell_request_accelerate", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cells = self,
    }, nil, 1)    
	
	--查看信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel") , nil, 
    {
        terminal_name = "red_alert_time_mine_battle_troops_infor_open", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cells = self,
    }, nil, 1)    
	
    self:onUpdateDraw()
end

function WorldEventListCell:onInit()
	if -1 == self._state then
		self:onInitCloseCell()
	end
	
	if 0 == self._state then
		self:onInitNilCell()
	end
	
	if 1 == self._state then
		self:onInitEventCell()
	end
	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self)
end

function WorldEventListCell:onUpdate(dt)
	if self.roots == nil or self.roots[1] == nil then
		return
	end

	if self._state == -1 then
		local playTheQueue = dms.element(dms["base_consume"], 81)
		if tonumber(self._vip_level) <= dms.atoi(playTheQueue, zstring.tonumber(_ED.vip_grade)+4)  then
			self._state = 0
			self:unload()
			self:onInit()
			state_machine.excute("red_alert_time_mine_event_queue_refresh_list_number",0,nil)
		end
	end
	if nil == self.m_object or self._state ~= 1 then
		return
	end
	--0攻击移动，1回城移动，2攻击，3加速返回，4请求撤离，5驻守状态，6协防移动，7协防中，8打玩家移动，9校验
	if (tonumber(self.m_object._event_type) == 0 or tonumber(self.m_object._event_type) == 1 or tonumber(self.m_object._event_type) == 6 or tonumber(self.m_object._event_type) == 8 or tonumber(self.m_object._event_type) == 18) 
		and self.local_time ~= 0 then 
		-- self.local_time = self.local_time - dt
		if self.m_object ~= nil and self.old_event_type ~= self.m_object._event_type then
			if self.isAccelerate == false then
				state_machine.excute("world_nearby_list_cell_update_list_info", 0, {self, 0})
				-- checkRewardObtainDraw()
				self.old_event_type = self.m_object._event_type
			end
		end
		self.local_time = (tonumber(self.m_object._start_time)/1000+tonumber(self.m_object._complete_time))-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
		if self.local_time <= -1 then--客户端多延时一秒
			self.local_time = 0
			state_machine.excute("world_nearby_list_cell_time_over", 0, {_datas={cells = self}})
		end
		ccui.Helper:seekWidgetByName(self.roots[1],"Text_distance_ing"):setString(exChangeTimeToString(self.local_time))
		local progress = math.min((self.old_local_time-self.local_time)/self.old_local_time*100)
		ccui.Helper:seekWidgetByName(self.roots[1],"LoadingBar_distance_bar"):setPercent(progress)
		-- if zstring.tonumber(self._number) == #_ED.world_map.target_event_info then
			state_machine.excute("red_alert_time_mine_event_queue_refresh_button", 0, exChangeTimeToString(self.local_time))
		-- end
	elseif tonumber(self.m_object._event_type) == 5 then
		self.second_increase_time = self.second_increase_time + dt
		if self.m_object ~= nil and self.old_event_type ~= self.m_object._event_type then
			if self.isAccelerate == false then
				state_machine.excute("world_nearby_list_cell_update_list_info", 0, {self, 0})
				-- checkRewardObtainDraw()
				self.old_event_type = self.m_object._event_type
			end
		end
		if self.second_increase_time >= 1 and self.second_total < tonumber(self.m_object._max_out_put) then
			self.second_increase_time = 0
			-- self.local_time = self.local_time + 1
			self.local_time = (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))-(tonumber(self.m_object._start_time)/1000)
			self.second_total = zstring.tonumber(self.m_object._prev_out_put) + self.m_second*self.local_time
		elseif self.second_total >= tonumber(self.m_object._max_out_put) then
			self.second_total = tonumber(self.m_object._max_out_put)
		end
		self.second_total = math.max(0,self.second_total)
		ccui.Helper:seekWidgetByName(self.roots[1],"Text_distance_ing"):setString(exChangeNumToString(math.floor(self.second_total)).."/"..exChangeNumToString(tonumber(self.m_object._max_out_put)))
		local progress = math.min(self.second_total/tonumber(self.m_object._max_out_put)*100)
		ccui.Helper:seekWidgetByName(self.roots[1],"LoadingBar_distance_bar"):setPercent(progress)
		-- if zstring.tonumber(self._number) == #_ED.world_map.target_event_info then
			state_machine.excute("red_alert_time_mine_event_queue_refresh_button", 0, exChangeNumToString(math.floor(self.second_total)))
		-- end
	elseif tonumber(self.m_object._event_type) == 7 then 	--协防中
		if self.m_object ~= nil and self.old_event_type ~= self.m_object._event_type then
			if self.isAccelerate == false then
				state_machine.excute("world_nearby_list_cell_update_list_info", 0, {self, 0})
				-- checkRewardObtainDraw()
				self.old_event_type = self.m_object._event_type
			end
		end
		ccui.Helper:seekWidgetByName(self.roots[1],"LoadingBar_distance_bar"):setPercent(0)
		ccui.Helper:seekWidgetByName(self.roots[1],"Text_distance_ing"):setString(red_alert_time_str[270])
		state_machine.excute("red_alert_time_mine_event_queue_refresh_button", 0, red_alert_time_str[270])
	end
end

function WorldEventListCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_attack_res_name_lv = ccui.Helper:seekWidgetByName(root,"Text_attack_res_name_lv")
	local Text_attack_res_xy_n = ccui.Helper:seekWidgetByName(root,"Text_attack_res_xy_n")
	local Text_distance_ing = ccui.Helper:seekWidgetByName(root,"Text_distance_ing")
	local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
	if Text_attack_res_name_lv~= nil then
		Text_attack_res_name_lv:setString("")
		Text_attack_res_xy_n:setString("")
		Text_distance_ing:setString("")
		Panel_implement_icon:removeBackGroundImage()
	end
	self:unregisterOnNoteUpdate(self)
    if nil ~= self._path then
    	self._path:removeFromParent(true)
    	self._path = nil
    end
end

function WorldEventListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function WorldEventListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
	if 1 == self._state then
		cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_1, root)
	end
	if 0 == self._state then
		cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_2, root)
	end
    root:removeFromParent(false)
    self.roots = {}
end

function WorldEventListCell:onExit()
	self:clearUIInfo()
	if 0 == self._state then
		cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_2, self.roots[1])
	end
	if 1 == self._state then
		cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_1, self.roots[1])
	end
	if self._state >= 0 then
		self._state = 0
	end
end

function WorldEventListCell:createCell()
	local cell = WorldEventListCell:new()
	-- cell:registerOnNodeEvent(cell)
	-- cell:registerOnNoteUpdate(cell)
	return cell
end