-- ----------------------------------------------------------------------------------------------------
-- 说明：世界查看附近
-------------------------------------------------------------------------------------------------------
redAlertTimeMineViewNearby = class("redAlertTimeMineViewNearbyClass", Window)

local red_alert_time_mine_view_nearby_open_terminal = {
    _name = "red_alert_time_mine_view_nearby_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineViewNearbyClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMineViewNearby:new():init(params[1],params[2],params[3]), fwin._dview)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_view_nearby_close_terminal = {
    _name = "red_alert_time_mine_view_nearby_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineViewNearbyClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineViewNearbyClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_view_nearby_open_terminal)
state_machine.add(red_alert_time_mine_view_nearby_close_terminal)
state_machine.init()
    
function redAlertTimeMineViewNearby:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0
	self.m_x = 0
	self.m_y = 0
	self._index = 0
	self.update_type = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.worldMap.world_nearby_list_cell")

    local function init_red_alert_time_mine_view_nearby_terminal()
        --翻页
        local red_alert_time_mine_Page_Players_and_resources_terminal = {
            _name = "red_alert_time_mine_Page_Players_and_resources",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local pages = params._datas._page
                --翻页资源和玩家
				local function responseNearbyCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node.update_type = 0
							response.node:changeSelectPage(zstring.tonumber(pages))
						end
                    end
                end
				protocol_command.world_info_search.param_list = (zstring.tonumber(pages)-1).."\r\n"..instance.m_x.."\r\n"..instance.m_y
				NetworkManager:register(protocol_command.world_info_search.code, nil, nil, nil, instance, responseNearbyCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--换一批
        local red_alert_time_mine_view_nearby_replace_terminal = {
            _name = "red_alert_time_mine_view_nearby_replace",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --翻页资源和玩家
				local function responseNearbyCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node.update_type = 1
							response.node:changeSelectPage(zstring.tonumber(response.node._current_page))
						end
                    end
                end
                local page = instance._current_page
				protocol_command.world_info_search.param_list = (page-1).."\r\n"..instance.m_x.."\r\n"..instance.m_y
				NetworkManager:register(protocol_command.world_info_search.code, nil, nil, nil, instance, responseNearbyCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_mine_Page_Players_and_resources_terminal)
        state_machine.add(red_alert_time_mine_view_nearby_replace_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mine state machine.
    init_red_alert_time_mine_view_nearby_terminal()
end

function redAlertTimeMineViewNearby:init(x,y,index)
	self.m_x = x
	self.m_y = y
	self._index = index
    self:onInit()
    return self
end

function redAlertTimeMineViewNearby:changeSelectPage( page )
	local root = self.roots[1]
	local ListView_search = ccui.Helper:seekWidgetByName(root,"ListView_search")
	local Button_search_people = ccui.Helper:seekWidgetByName(root,"Button_search_people")
	local Button_search_mine = ccui.Helper:seekWidgetByName(root,"Button_search_mine")
    local Text_not_payer = ccui.Helper:seekWidgetByName(root,"Text_not_payer")
	if page == self._current_page then
        if page == 1 then
            Button_search_people:setHighlighted(true)
        else
            Button_search_mine:setHighlighted(true)
        end
		if self.update_type == 0 then
			return
		end 
    end
    self._current_page = page
    Button_search_people:setHighlighted(false)
    Button_search_mine:setHighlighted(false)
    ListView_search:jumpToTop()
    ListView_search:removeAllItems()
    Text_not_payer:setVisible(true)
	if page == 1 then
		Button_search_people:setHighlighted(true)
		if _ED.world_map.search_info~= nil then
			for i, v in pairs(self:cityListSorting()) do
				if v._type == 0 then
					local cell = WorldNearbyListCell:createCell()
					cell:init(v)
					ListView_search:addChild(cell)
					Text_not_payer:setVisible(false)
				end
			end
			ListView_search:requestRefreshView()
			
		end
	else
		Button_search_mine:setHighlighted(true)
		if _ED.world_map.search_info~= nil then
			for i, v in pairs(self:mineListSorting()) do
				if v._type ~= 0 then
					local cell = WorldNearbyListCell:createCell()
					cell:init(v)
					ListView_search:addChild(cell)
					Text_not_payer:setVisible(false)
				end
			end
			ListView_search:requestRefreshView()
		end
	end
    self._list_view = ListView_search
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function redAlertTimeMineViewNearby:onUpdate(dt)
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

function redAlertTimeMineViewNearby:cityListSorting()
    local result = {}
    for k, v in pairs(_ED.world_map.search_info) do
        if tonumber(v._type) == 0 then
            table.insert(result, v)
        end
    end
    for k, v in pairs(result) do
        v._reach_time = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,tonumber(v._x),tonumber(v._y))
    end
    local function sortFunction(a, b)
        if tonumber(a._level) > tonumber(b._level)
            or (tonumber(a._level) == tonumber(b._level) and tonumber(a._reach_time) < tonumber(b._reach_time))
            then
            return true
        end
        return false
    end
    table.sort(result, sortFunction)

    return result
end

function redAlertTimeMineViewNearby:mineListSorting()
	local search_list = {}
	local search_one_list = {}
	local search_two_list = {}
	local search_three_list = {}
	local search_four_list = {}
	local search_fives_list = {}
	for i, v in pairs(_ED.world_map.search_info) do
		if tonumber(v._type) == 1 then
			table.insert(search_one_list, v)
		elseif tonumber(v._type) == 2 then
			table.insert(search_two_list, v)
		elseif tonumber(v._type) == 3 then
			table.insert(search_three_list, v)
		elseif tonumber(v._type) == 4 then
			table.insert(search_four_list, v)
		elseif tonumber(v._type) == 5 then
			table.insert(search_fives_list, v)
		end
	end
	local sortFunc = function( cell1, cell2 )
		local element1 = dms.element(dms["world_mine_mould"], cell1._mould_id)
		local element2 = dms.element(dms["world_mine_mould"], cell2._mould_id)
		return dms.atoi(element1, world_mine_mould.level) > dms.atoi(element2, world_mine_mould.level)
	end
	table.sort(search_fives_list, sortFunc)
	table.sort(search_four_list, sortFunc)
	table.sort(search_three_list, sortFunc)
	table.sort(search_two_list, sortFunc)
	table.sort(search_one_list, sortFunc)
	
	for i, v in pairs(search_fives_list) do
		table.insert(search_list, v)
	end
	for i, v in pairs(search_four_list) do
		table.insert(search_list, v)
	end
	for i, v in pairs(search_three_list) do
		table.insert(search_list, v)
	end
	for i, v in pairs(search_two_list) do
		table.insert(search_list, v)
	end
	for i, v in pairs(search_one_list) do
		table.insert(search_list, v)
	end
	return search_list
end

function redAlertTimeMineViewNearby:onInit()
    local csbredAlertTimeMineViewNearby = csb.createNode(config_csb.world_map.view_nearby)
    local root = csbredAlertTimeMineViewNearby:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineViewNearby)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_view_nearby_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_view_nearby_close",
        terminal_state = 0,
    },
    nil,3)
	
	--翻到玩家页
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_search_people"), nil, 
    {
        terminal_name = "red_alert_time_mine_Page_Players_and_resources",
        terminal_state = 0,
		_page = 1,
    },
    nil,1)
	
	--翻到资源页
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_search_mine"), nil, 
    {
        terminal_name = "red_alert_time_mine_Page_Players_and_resources",
        terminal_state = 0,
		_page = 2,
    },
    nil,1)
	
	--换一批
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_search_change"), nil, 
    {
        terminal_name = "red_alert_time_mine_view_nearby_replace",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_search_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_search_arrow_up")
    
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
    ccui.Helper:seekWidgetByName(root,"Text_not_payer"):setVisible(false)

	if self._index ~= nil and self._index == 2 then
		state_machine.excute("red_alert_time_mine_Page_Players_and_resources", 0, {_datas = {_page = 2}})
	else
		state_machine.excute("red_alert_time_mine_Page_Players_and_resources", 0, {_datas = {_page = 1}})
	end
end

function redAlertTimeMineViewNearby:onExit()
	
end