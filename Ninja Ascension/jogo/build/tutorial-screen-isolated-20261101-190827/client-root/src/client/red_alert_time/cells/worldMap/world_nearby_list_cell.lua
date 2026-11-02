-----------------------------
--世界附近的人和矿的cell
-----------------------------
WorldNearbyListCell = class("WorldNearbyListCellClass", Window)
WorldNearbyListCell.__size = nil

function WorldNearbyListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil
	app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    local function init_world_nearby_list_cell_terminal()
        local world_nearby_list_cell_positioning_terminal = {
            _name = "world_nearby_list_cell_positioning",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- state_machine.lock("world_nearby_list_cell_positioning")
				local x = params._datas.cell.m_object._x
				local y = params._datas.cell.m_object._y
				state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
				state_machine.excute("adventure_mine_record_view_position", 0, {x,y})
				state_machine.excute("adventure_mine_update_view_position", 0, 0)
				
				local function responseCallback(response)
					-- state_machine.unlock("world_nearby_list_cell_positioning")
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("adventure_mine_cell_focus_blink", 0, _ED.world_map_focus)
                    end
                end
                _ED.world_map_focus = {x, y}
				protocol_command.world_map_arena_info_refresh.param_list = "" .. x .. "\r\n" .. y
				NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, responseCallback, false, nil)
				TipDlg.drawTextDailog(red_alert_time_str[236])
				state_machine.excute("red_alert_time_mine_view_nearby_close", 0, 0)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(world_nearby_list_cell_positioning_terminal)
        state_machine.init()
    end
    init_world_nearby_list_cell_terminal()
end

function WorldNearbyListCell:onEnterTransitionFinish()

end

function WorldNearbyListCell:onUpdateDraw()
    local root = self.roots[1]
	
	local Panel_head_icon = ccui.Helper:seekWidgetByName(root,"Panel_head_icon")
	Panel_head_icon:removeAllChildren(true)
	
	--计算到达时间
	local m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,self.m_object._x,self.m_object._y)
	
		
	--名称
	local Text_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_player_name_lv")
	
	--抵达时间
	local Text_arrive_time_n = ccui.Helper:seekWidgetByName(root,"Text_arrive_time_n")
	
	
	--对方基地的繁荣度
	local LoadingBar_boom = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom")
	-- LoadingBar_boom:loadTexture(图片地址)--换图
	local fontName = config_res.font.font_name
	if isContentZh_TW() == true then
		fontName = "" 
	end
	if zstring.tonumber(self.m_object._type) == 0 then
		local level_Info = self.m_object._level
		local max_id = dms.int(dms["arena_config"],10,arena_config.param)
		if tonumber(self.m_object._id) <= max_id then
			level_Info = dms.string(dms["world_config"], 20 , world_config.param)
		end
		Text_player_name_lv:setString(self.m_object._nickname.." "..friends_tip_string[12]..level_Info)
		Text_player_name_lv:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
		Text_player_name_lv:setFontName(fontName)
		local fontSize = Text_player_name_lv:getFontSize()
		Text_player_name_lv:setFontSize(fontSize)
		ccui.Helper:seekWidgetByName(root,"Panel_boom"):setVisible(true)
		local boom_state = 0
		local _glories = zstring.tonumber(self.m_object._glories)
	    if self.m_object._online_state == 1 then
			local s_time = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self.m_object._boom_restore_time)/1000
		    _glories = getBoomReplyalgorithm(zstring.tonumber(self.m_object._glories),zstring.tonumber(self.m_object._max_boom),s_time)
	    end
	    local boom_bar = zstring.tonumber(_glories)/zstring.tonumber(self.m_object._max_boom)
	    for i= 1, dms.count(dms["build_boom_lose"]) do
	        local boom_proportion = tonumber(dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion))
	        if boom_bar >= boom_proportion then
	            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
	            break
	        end
	    end
		local percentage = zstring.tonumber(_glories) / zstring.tonumber(self.m_object._max_boom)*100
		if boom_state == 0 then
			LoadingBar_boom:loadTexture("images/ui/share/loading_boom_bar.png")
		elseif boom_state == 1 then
			LoadingBar_boom:loadTexture("images/ui/share/loading_boom_bar_1.png")
		else
			LoadingBar_boom:loadTexture("images/ui/share/loading_boom_bar_2.png")
		end
		LoadingBar_boom:setPercent(percentage)
		local cell = PlayerHeadIcon:createCell()
		
		local avatar_info = {}
		avatar_info.object =self.m_object._head_pic
		avatar_info.vip = self.m_object._vip_level
		avatar_info._type = 0
		cell:init(avatar_info)
		Panel_head_icon:addChild(cell)	
	else
		local element = dms.element(dms["world_mine_mould"], self.m_object._mould_id)
		local mine_name = dms.atos(element, world_mine_mould.name)
		local mine_quelity_level_up_param = dms.atos(element, world_mine_mould.quelity_level_up_param)
		local per_minute_sub_exp = dms.atoi(element, world_mine_mould.per_minute_sub_quelity_level_up_exp)
		local richOreValue = zstring.split(mine_quelity_level_up_param ,",")
		local quality_id = tonumber(self.m_object._quality)
		local quality_level_up_exp = self.m_object._quality_level_up_exp
		if tonumber(self.m_object._user_info) == -1 then
			local m_times = (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) - tonumber(self.m_object._mining_time)/1000
			if m_times > 0 then
				quality_level_up_exp = self.m_object._quality_level_up_exp - math.floor(math.floor(m_times/60)*per_minute_sub_exp)
				if quality_level_up_exp <= 0 then
					quality_level_up_exp = 0
				end
			end
			local isVariety = false
			for i=1, #richOreValue do
				if quality_level_up_exp >= tonumber(richOreValue[i]) then
					quality_id = i
					isVariety = true
				end
			end
			if quality_id>=3 then
				quality_id=3
			end
			if isVariety == false then
				quality_id = 0
			end
		elseif tonumber(self.m_object._user_info) > 0 then	
			--有富矿隐藏数据
			if self.m_object.talent ~= "" and self.m_object.talent ~= nil then
				if self.m_object._talent_id["76"] ~= nil then
					local talentTime = tonumber(self.m_object._talent_end_time["76"])/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
					if talentTime > 0 then
						quality_id = 0
					end
				end
			end
		end
		--疯狂矿工,隐藏富矿
		if _ED.activity_info["87"] ~= nil then
	        local timesData = zstring.split(_ED.activity_info["87"].activity_add_state, ",")
	        local activity_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
	        if activity_times > 0 then
	            quality_id = 0
	        end
	    end

		Text_player_name_lv:setFontName(config_res.font.font_name)
		Text_player_name_lv:setString(mine_name.." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level))
		Text_player_name_lv:setColor(cc.c3b(color_Type[tonumber(quality_id)+1][1], color_Type[tonumber(quality_id)+1][2], color_Type[tonumber(quality_id)+1][3]))
		ccui.Helper:seekWidgetByName(root,"Panel_boom"):setVisible(false)
		local cell = PlayerHeadIcon:createCell()
		local avatar_info = {}
		avatar_info._type = 1
		if __lua_project_id == __lua_project_pacific_rim then
			avatar_info._type = 2
		end
		avatar_info._mould_id = self.m_object._mould_id
		cell:init(avatar_info)
		Panel_head_icon:addChild(cell)	
	end
	Text_arrive_time_n:setString(exChangeTimeToString(m_times))
end

function WorldNearbyListCell:init(info)
    self.m_object = info
    -- if index ~= nil and index < 5 then
	self:onInit()
    -- end
	self:setContentSize(WorldNearbyListCell.__size)
    return self
end

function WorldNearbyListCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.world.nearby_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if WorldNearbyListCell.__size == nil then
        WorldNearbyListCell.__size = root:getContentSize()
    end
    --定位
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_search_location") , nil, 
    {
        terminal_name = "world_nearby_list_cell_positioning", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cell = self,
    }, nil, 1)    
	
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

function WorldNearbyListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function WorldNearbyListCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Panel_head_icon = ccui.Helper:seekWidgetByName(root,"Panel_head_icon")
	local Text_player_name_lv = ccui.Helper:seekWidgetByName(root,"Text_player_name_lv")
	local Text_arrive_time_n = ccui.Helper:seekWidgetByName(root,"Text_arrive_time_n")
	if Panel_head_icon~= nil then
		Panel_head_icon:removeAllChildren(true)
		Text_player_name_lv:setString("")
		Text_arrive_time_n:setString("")
	end
end

function WorldNearbyListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	local Panel_head_icon = ccui.Helper:seekWidgetByName(root,"Panel_head_icon")
	Panel_head_icon:removeAllChildren(true)
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.nearby_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function WorldNearbyListCell:onExit()
	local Panel_head_icon = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_head_icon")
	if Panel_head_icon ~= nil then
		Panel_head_icon:removeAllChildren(true)
	end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.world.nearby_cell, self.roots[1])
end

function WorldNearbyListCell:createCell()
	local cell = WorldNearbyListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end