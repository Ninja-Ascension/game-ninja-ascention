-- ----------------------------------------------------------------------------------------------------
-- 说明：社交坐标收藏夹
-------------------------------------------------------------------------------------------------------
SocialCoordinateFavorites = class("SocialCoordinateFavoritesClass", Window)

local game_social_coordinate_favorites_open_terminal = {
    _name = "game_social_coordinate_favorites_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialCoordinateFavoritesClass")
        if nil == _homeWindow then
    		fwin:open(SocialCoordinateFavorites:new():init(params[1],params[2]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local game_social_coordinate_favorites_close_terminal = {
    _name = "game_social_coordinate_favorites_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialCoordinateFavoritesClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SocialCoordinateFavoritesClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(game_social_coordinate_favorites_open_terminal)
state_machine.add(game_social_coordinate_favorites_close_terminal)
state_machine.init()
    
function SocialCoordinateFavorites:ctor()
    self.super:ctor()
    self.roots = {}
	self._params = nil
	self._current_page = 0
	
	self._collection_friend = nil
    self._collection_enrge = nil
    self._collection_shield = nil
    self._collection_xy = nil
	
	app.load("client.red_alert_time.cells.chats.social_coordinate_favorites_cell")
	
	local function init_game_social_coordinate_favorites_terminal()
		local game_social_coordinate_favorites_show_terminal = {
            _name = "game_social_coordinate_favorites_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local game_social_coordinate_favorites_hide_terminal = {
            _name = "game_social_coordinate_favorites_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local game_social_coordinate_favorites_page_terminal = {
            _name = "game_social_coordinate_favorites_page",
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

        state_machine.add(game_social_coordinate_favorites_show_terminal)
        state_machine.add(game_social_coordinate_favorites_hide_terminal) 
        state_machine.add(game_social_coordinate_favorites_page_terminal) 
	
		state_machine.init()
	end
	
	init_game_social_coordinate_favorites_terminal()
	
end

function SocialCoordinateFavorites:changeSelectPage( page )
    local root = self.roots[1]
    local ListView_collection_xy = ccui.Helper:seekWidgetByName(root, "ListView_collection_xy")
    local Button_collection_xy_all = ccui.Helper:seekWidgetByName(root, "Button_collection_xy_all")
    local Button_collection_xy_res = ccui.Helper:seekWidgetByName(root, "Button_collection_xy_res")
    local Button_collection_xy_friend = ccui.Helper:seekWidgetByName(root, "Button_collection_xy_friend")
    local Button_collection_xy_enemy = ccui.Helper:seekWidgetByName(root, "Button_collection_xy_enemy")
    if page == self._current_page then
        if page == 1 then
            Button_collection_xy_all:setHighlighted(true)
        elseif page == 2 then
            Button_collection_xy_res:setHighlighted(true)
		elseif page == 3 then
			Button_collection_xy_friend:setHighlighted(true)
        else
            Button_collection_xy_enemy:setHighlighted(true)
        end
        -- return
    end
    self._current_page = page
    Button_collection_xy_all:setHighlighted(false)
    Button_collection_xy_res:setHighlighted(false)
    Button_collection_xy_friend:setHighlighted(false)
    Button_collection_xy_enemy:setHighlighted(false)
    ListView_collection_xy:jumpToTop()
	ListView_collection_xy:removeAllItems()
    if page == 1 then
        Button_collection_xy_all:setHighlighted(true)
		for i=1,3 do
			if _ED.world_map ~= nil and _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..i]~= nil then
				for j, v in pairs(_ED.world_map.coord_collent[""..i]) do
					local cell = SocialCoordinateFavoritesCell:createCell()
					cell:init(v,j,i,page)
					ListView_collection_xy:addChild(cell)
				end
			end
		end
		ListView_collection_xy:requestRefreshView()
    elseif page == 2 then
        Button_collection_xy_res:setHighlighted(true)
		if _ED.world_map ~= nil and _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..page-1] ~= nil then
			for i, v in pairs(_ED.world_map.coord_collent[""..page-1]) do
				local cell = SocialCoordinateFavoritesCell:createCell()
				cell:init(v,i,page-1,page)
				ListView_collection_xy:addChild(cell)
			end
			ListView_collection_xy:requestRefreshView()
		end
	elseif page == 3 then
        Button_collection_xy_friend:setHighlighted(true)
		if _ED.world_map ~= nil and _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..page-1] ~= nil then
			for i, v in pairs(_ED.world_map.coord_collent[""..page-1]) do
				local cell = SocialCoordinateFavoritesCell:createCell()
				cell:init(v,i,page-1,page)
				ListView_collection_xy:addChild(cell)
			end
			ListView_collection_xy:requestRefreshView()
		end
    else
        Button_collection_xy_enemy:setHighlighted(true)
		if _ED.world_map ~= nil and _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..page-1] ~= nil then
			for i, v in pairs(_ED.world_map.coord_collent[""..page-1]) do
				local cell = SocialCoordinateFavoritesCell:createCell()
				cell:init(v,i,page-1,page)
				ListView_collection_xy:addChild(cell)
			end
			ListView_collection_xy:requestRefreshView()
		end
    end
    local Text_collection_xy_not_promp = ccui.Helper:seekWidgetByName(root, "Text_collection_xy_not_promp")
    Text_collection_xy_not_promp:setVisible(false)
    local Items = ListView_collection_xy:getItems()
    if #Items == 0 then
        Text_collection_xy_not_promp:setVisible(true)
    end
end

function SocialCoordinateFavorites:init(params1,params2)
	self._rootWindows = params1
	self._params = params2
    self:onInit()
    return self
end

function SocialCoordinateFavorites:onInit()
    local csbSocialCoordinateFavorites = csb.createNode(config_csb.friend.social_coordinate_favorites)
    local root = csbSocialCoordinateFavorites:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocialCoordinateFavorites)
	
	--全部
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collection_xy_all"), nil, 
    {
        terminal_name = "game_social_coordinate_favorites_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	
	--资源
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collection_xy_res"), nil, 
    {
        terminal_name = "game_social_coordinate_favorites_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
	
	--好友
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collection_xy_friend"), nil, 
    {
        terminal_name = "game_social_coordinate_favorites_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
	
	--敌人
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_collection_xy_enemy"), nil, 
    {
        terminal_name = "game_social_coordinate_favorites_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)
	
	if self._params ~= nil then
        self:changeSelectPage(tonumber(self._params))
    else
        self:changeSelectPage(1)
    end
end

function SocialCoordinateFavorites:onExit()
	
end