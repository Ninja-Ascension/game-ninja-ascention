-----------------------------
--社交收藏cell
-----------------------------
SocialCoordinateFavoritesCell = class("SocialCoordinateFavoritesCellClass", Window)
SocialCoordinateFavoritesCell.__size = nil

function SocialCoordinateFavoritesCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil
	self.m_type = 0
	self.examples_id = 0
	self.m_recording = 0
	self.windType = 0

    local function init_social_coordinate_favorites_cell_terminal()
        local social_coordinate_favorites_cell_positioning_terminal = {
            _name = "social_coordinate_favorites_cell_positioning",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                -- state_machine.lock("social_coordinate_favorites_cell_positioning")
				local coords_info = zstring.split(cell.m_object.coords, ",")
                if fwin:find("RedAlertTimeChatSentClass") ~= nil then
                    state_machine.excute("red_alert_time_chat_sent_window_close", 0, 0)
                end
                state_machine.excute("game_social_platforms_close", 0, 0)
				state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})

				state_machine.excute("adventure_mine_record_view_position", 0, {coords_info[1],coords_info[2]})
				state_machine.excute("adventure_mine_update_view_position", 0, 0)
				
                local function responseCallback(response)
                    -- state_machine.unlock("social_coordinate_favorites_cell_positioning")
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("adventure_mine_cell_focus_blink", 0, _ED.world_map_focus)
                    end
                end
                _ED.world_map_focus = {coords_info[1], coords_info[2]}
				protocol_command.world_map_arena_info_refresh.param_list = "" .. coords_info[1] .. "\r\n" .. coords_info[2]
				NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, responseCallback, false, nil)
				
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local social_coordinate_favorites_cell_delete_terminal = {
            _name = "social_coordinate_favorites_cell_delete",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cells = params._datas.cell
				local function requesrDeletecoordinate(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            TipDlg.drawTextDailog(friends_tip_string[11])
							_ED.world_map.coord_collent[""..response.node.m_recording][response.node.m_type .. "," .. response.node.examples_id] = nil
							state_machine.excute("game_social_coordinate_favorites_page", 0, {_datas={_page = response.node.windType}})
						end	
					end
				end	
				
				protocol_command.world_coord_collect.param_list = "0" .. "\r\n" .. "" .. cells.m_recording .. "-" ..cells.m_type .. "," .. cells.examples_id .."\r\n"..cells.m_object.name.."|"..cells.m_object.level.."|"..cells.m_object.coords
				NetworkManager:register(protocol_command.world_coord_collect.code, nil, nil, nil, cells, requesrDeletecoordinate, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(social_coordinate_favorites_cell_positioning_terminal)
        state_machine.add(social_coordinate_favorites_cell_delete_terminal)
        state_machine.init()
    end
    init_social_coordinate_favorites_cell_terminal()
end

function SocialCoordinateFavoritesCell:onEnterTransitionFinish()

end

function SocialCoordinateFavoritesCell:onUpdateDraw()
    local root = self.roots[1]
	local Text_world_res_name_lv = ccui.Helper:seekWidgetByName(root,"Text_world_res_name_lv")
	-- if self.m_type == 0 then
		Text_world_res_name_lv:setString(self.m_object.name.." "..friends_tip_string[12]..self.m_object.level)
	-- else
	-- 	Text_world_res_name_lv:setString(self.m_object.name)
	-- end

    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        if self.m_type == 0 then
            fontName = ""
        end
    end
    Text_world_res_name_lv:setFontName(fontName)
    
	local Text_collection_xy_n = ccui.Helper:seekWidgetByName(root,"Text_collection_xy_n")
	Text_collection_xy_n:setString(self.m_object.coords)
end

function SocialCoordinateFavoritesCell:init(m_object,info,m_recording,windType)
    self.m_object = m_object
    self.m_recording = m_recording
	local keys = zstring.split(info, ",")
	self.m_type = zstring.tonumber(keys[1])
	self.examples_id = zstring.tonumber(keys[2])
	self.windType = windType
    -- if index ~= nil and index < 5 then
	self:onInit()
    -- end
	self:setContentSize(SocialCoordinateFavoritesCell.__size)
    return self
end

function SocialCoordinateFavoritesCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.chats.social_coordinate_favorites_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if SocialCoordinateFavoritesCell.__size == nil then
        SocialCoordinateFavoritesCell.__size = root:getContentSize()
    end
    --定位
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_search_location") , nil, 
    {
        terminal_name = "social_coordinate_favorites_cell_positioning", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cell = self,
    }, nil, 1)    
	
	--定位
    fwin:addTouchEventListener(root , nil, 
    {
        terminal_name = "social_coordinate_favorites_cell_positioning", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cell = self,
    }, nil, 1)    
	
	--删除
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_search_build") , nil, 
    {
		terminal_name = "social_coordinate_favorites_cell_delete", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cell = self,
    }, nil, 1) 
    
    self:onUpdateDraw() 
end

function SocialCoordinateFavoritesCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_world_res_name_lv = ccui.Helper:seekWidgetByName(root,"Text_world_res_name_lv")
	local Text_collection_xy_n = ccui.Helper:seekWidgetByName(root,"Text_collection_xy_n")
	if Text_world_res_name_lv ~= nil then
		Text_world_res_name_lv:setString("")
		Text_collection_xy_n:setString("")
	end
end

function SocialCoordinateFavoritesCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SocialCoordinateFavoritesCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.chats.social_coordinate_favorites_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function SocialCoordinateFavoritesCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.chats.social_coordinate_favorites_cell, self.roots[1])
end

function SocialCoordinateFavoritesCell:createCell()
	local cell = SocialCoordinateFavoritesCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end