-- ----------------------------------------------------------------------------------------------------
-- 说明：社交平台
-------------------------------------------------------------------------------------------------------
SocialPlatforms = class("SocialPlatformsClass", Window)

local game_social_platforms_open_terminal = {
    _name = "game_social_platforms_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialPlatformsClass")
        if nil == _homeWindow then
    		fwin:open(SocialPlatforms:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local game_social_platforms_close_terminal = {
    _name = "game_social_platforms_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialPlatformsClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SocialPlatformsClass"))
        end
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(game_social_platforms_open_terminal)
state_machine.add(game_social_platforms_close_terminal)
state_machine.init()
    
function SocialPlatforms:ctor()
    self.super:ctor()
    self.roots = {}
	self._params = nil
	self._current_page = 0
	
	self._collection_friend = nil
    self._collection_enrge = nil
    self._collection_shield = nil
    self._collection_xy = nil
	
	app.load("client.red_alert_time.chat.SocialFriendTag")
	app.load("client.red_alert_time.chat.SocialCoordinateFavorites")
	app.load("client.red_alert_time.chat.SocialFriendEnergeTag")
	app.load("client.red_alert_time.chat.SocialFriendShieldTab")
	
	
	local function init_game_social_platforms_terminal()
		-- 翻页
        local game_social_platforms_page_terminal = {
            _name = "game_social_platforms_page",
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

        state_machine.add(game_social_platforms_page_terminal)
	
		state_machine.init()
	end
	
	init_game_social_platforms_terminal()
	
end

function SocialPlatforms:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
    local Button_res_collection_friend = ccui.Helper:seekWidgetByName(root, "Button_res_collection_friend")
    local Button_res_collection_enrge = ccui.Helper:seekWidgetByName(root, "Button_res_collection_enrge")
    local Button_res_collection_shield = ccui.Helper:seekWidgetByName(root, "Button_res_collection_shield")
    local Button_res_collection_xy = ccui.Helper:seekWidgetByName(root, "Button_res_collection_xy")
    if page == self._current_page then
        if page == 1 then
            Button_res_collection_friend:setHighlighted(true)
        elseif page == 2 then
            Button_res_collection_enrge:setHighlighted(true)
		elseif page == 3 then
			Button_res_collection_shield:setHighlighted(true)
        else
            Button_res_collection_xy:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_res_collection_friend:setHighlighted(false)
    Button_res_collection_enrge:setHighlighted(false)
    Button_res_collection_shield:setHighlighted(false)
    Button_res_collection_xy:setHighlighted(false)
	if self._collection_friend ~= nil then
		state_machine.excute("game_social_friend_tag_hide", 0, nil)
	end
	if self._collection_xy ~= nil then
		state_machine.excute("game_social_coordinate_favorites_hide", 0, nil)
	end
	if self._collection_enrge ~= nil then
		state_machine.excute("game_social_friend_energe_tag_hide", 0, nil)
	end
	
	if self._collection_shield ~= nil then
		state_machine.excute("game_social_friend_shield_tab_hide", 0, nil)
	end
    -- state_machine.excute("player_info_build_upgrade_hide", 0, nil)
	
    if page == 1 then
        Button_res_collection_friend:setHighlighted(true)
        if self._collection_friend == nil then
            self._collection_friend = state_machine.excute("game_social_friend_tag_open", 0, {Panel_collection_tab})
        else
            state_machine.excute("game_social_friend_tag_show", 0, nil)
        end
    elseif page == 2 then
        Button_res_collection_enrge:setHighlighted(true)
        if self._collection_enrge == nil then
            self._collection_enrge = state_machine.excute("game_social_friend_energe_tag_open", 0, {Panel_collection_tab})
        else
            state_machine.excute("game_social_friend_energe_tag_show", 0, nil)
        end
	elseif page == 3 then
        Button_res_collection_shield:setHighlighted(true)
        if self._collection_shield == nil then
            self._collection_shield = state_machine.excute("game_social_friend_shield_tab_open", 0, {Panel_collection_tab})
        else
            state_machine.excute("game_social_friend_shield_tab_show", 0, nil)
        end
    else
        Button_res_collection_xy:setHighlighted(true)
        if self._collection_xy == nil then
            self._collection_xy = state_machine.excute("game_social_coordinate_favorites_open", 0, {Panel_collection_tab,1})
        else
            state_machine.excute("game_social_coordinate_favorites_show", 0, nil)
        end
    end
end

function SocialPlatforms:init(params)
	self._params = params
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function SocialPlatforms:onInit()
    local csbSocialPlatforms = csb.createNode(config_csb.friend.social_platforms)
    local root = csbSocialPlatforms:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocialPlatforms)
	
    self.__check_covers = true
    root.__cwindow = self
	Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_collection_close"), nil, 
    {
        terminal_name = "game_social_platforms_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	
	--好友
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_collection_friend"), nil, 
    {
        terminal_name = "game_social_platforms_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	
	--送能量
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_collection_enrge"), nil, 
    {
        terminal_name = "game_social_platforms_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    --赠送能量推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_friend_give_energy",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_res_collection_enrge"),
    _m_type = 0,
    _invoke = nil,
    _interval = 0.2,})
	
	--屏蔽
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_collection_shield"), nil, 
    {
        terminal_name = "game_social_platforms_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
	
	--坐标收藏
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_collection_xy"), nil, 
    {
        terminal_name = "game_social_platforms_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)
	
	if self._params ~= nil and self._params._datas ~= nil and self._params._datas.page ~= nil then
        self:changeSelectPage(tonumber(self._params._datas.page))
    else
        self:changeSelectPage(1)
    end
end

function SocialPlatforms:onExit()
	state_machine.remove("game_social_platforms_page")
end