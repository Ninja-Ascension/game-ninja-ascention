-- ----------------------------------------------------------------------------------------------------
-- 说明：社交屏蔽界面
-------------------------------------------------------------------------------------------------------
SocialFriendShieldTab = class("SocialFriendShieldTabClass", Window)

local game_social_friend_shield_tab_open_terminal = {
    _name = "game_social_friend_shield_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialFriendShieldTabClass")
        if nil == _homeWindow then
    		fwin:open(SocialFriendShieldTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local game_social_friend_shield_tab_close_terminal = {
    _name = "game_social_friend_shield_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialFriendShieldTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SocialFriendShieldTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(game_social_friend_shield_tab_open_terminal)
state_machine.add(game_social_friend_shield_tab_close_terminal)
state_machine.init()
    
function SocialFriendShieldTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0
	
	self._collection_friend = nil
    self._collection_enrge = nil
    self._collection_shield = nil
    self._collection_xy = nil
	self._receive_number = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.chats.social_coordinate_favorites_cell")
	app.load("client.red_alert_time.cells.friend.friend_my_list_cell")
	
	local function init_game_social_friend_shield_tab_terminal()
		local game_social_friend_shield_tab_show_terminal = {
            _name = "game_social_friend_shield_tab_show",
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

        local game_social_friend_shield_tab_hide_terminal = {
            _name = "game_social_friend_shield_tab_hide",
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
		
		local game_social_friend_shield_tab_udapte_show_terminal = {
            _name = "game_social_friend_shield_tab_udapte_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	
        state_machine.add(game_social_friend_shield_tab_show_terminal)
        state_machine.add(game_social_friend_shield_tab_hide_terminal) 
        state_machine.add(game_social_friend_shield_tab_udapte_show_terminal) 
	
		state_machine.init()
	end
	
	init_game_social_friend_shield_tab_terminal()
	
end

function SocialFriendShieldTab:onUpdateDraw()
	local root = self.roots[1]
	local ListView_energe = ccui.Helper:seekWidgetByName(root, "ListView_shield")
    local Text_shield_not_prompt = ccui.Helper:seekWidgetByName(root, "Text_shield_not_prompt")
    Text_shield_not_prompt:setVisible(false)
    ListView_energe:jumpToTop()
	ListView_energe:removeAllItems()

    if #_ED.black_user <= 0 then
        Text_shield_not_prompt:setVisible(true)
    end

	for i, v in pairs(_ED.black_user) do
		if v.user_id ~= "" and v.user_id ~= nil then
			local cell = FriendMyListCell:createCell()
			cell:init(v,2,i)
			ListView_energe:addChild(cell)
		end
	end
    self._list_view = ListView_energe
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    if nil ~= self._list_view.setBounceBottomBoundary then
        self._list_view:setBounceBottomBoundary(0)
    end
end

function SocialFriendShieldTab:onUpdate(dt)
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

function SocialFriendShieldTab:init(params1,params2)
	self._rootWindows = params1
    self:onInit()
    return self
end

function SocialFriendShieldTab:onInit()
    local csbSocialFriendShieldTab = csb.createNode(config_csb.friend.friend_shield_tab)
    local root = csbSocialFriendShieldTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocialFriendShieldTab)
	
    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_shield_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_shield_arrow_up")
    
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
	
	--领取初始化
	-- local function recruitInitCallBack(response)
		-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			-- if response.node ~= nil and response.node.roots ~= nil then
				-- print("22222222222222222")
				-- self:onUpdateDraw()
			-- end
		-- end
	-- end
	-- NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, nil, recruitInitCallBack, false, nil)
	self:onUpdateDraw()
end

function SocialFriendShieldTab:onExit()
	state_machine.remove("game_social_friend_shield_tab_udapte_show")
end