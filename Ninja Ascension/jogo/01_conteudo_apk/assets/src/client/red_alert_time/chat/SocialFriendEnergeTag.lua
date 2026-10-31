-- ----------------------------------------------------------------------------------------------------
-- 说明：社交赠送能量
-------------------------------------------------------------------------------------------------------
SocialFriendEnergeTag = class("SocialFriendEnergeTagClass", Window)

local game_social_friend_energe_tag_open_terminal = {
    _name = "game_social_friend_energe_tag_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialFriendEnergeTagClass")
        if nil == _homeWindow then
    		fwin:open(SocialFriendEnergeTag:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local game_social_friend_energe_tag_close_terminal = {
    _name = "game_social_friend_energe_tag_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialFriendEnergeTagClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SocialFriendEnergeTagClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(game_social_friend_energe_tag_open_terminal)
state_machine.add(game_social_friend_energe_tag_close_terminal)
state_machine.init()
    
function SocialFriendEnergeTag:ctor()
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
	
	local function init_game_social_friend_energe_tag_terminal()
		local game_social_friend_energe_tag_show_terminal = {
            _name = "game_social_friend_energe_tag_show",
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

        local game_social_friend_energe_tag_hide_terminal = {
            _name = "game_social_friend_energe_tag_hide",
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
		
		--领取后的刷新
		local game_social_friend_energe_tag_receive_update_terminal = {
            _name = "game_social_friend_energe_tag_receive_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:deleteFriend(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--一键领取
		local game_social_friend_energe_tag_receive_all_terminal = {
            _name = "game_social_friend_energe_tag_receive_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local can_receive = false
                for k, v in pairs(_ED.friend_info) do
                    if tonumber(v.is_receive) == 1 then
                        can_receive = true
                    end
                end
                if can_receive == false then
                    TipDlg.drawTextDailog(red_alert_time_str[200])
                    return
                end

                -- local items = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_energe"):getItems()
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
						-- instance._receive_number  = instance._receive_number + number
    					    response.node:onUpdateDraw()
                            TipDlg.drawTextDailog(friends_tip_string[9])
                        end
                        checkRewardObtainDraw()
					end
				end
				protocol_command.draw_endurance.param_list = "-1"
				NetworkManager:register(protocol_command.draw_endurance.code, nil, nil, nil, instance, recruitCallBack, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local game_social_friend_energe_tag_update_draw_terminal = {
            _name = "game_social_friend_energe_tag_update_draw",
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
	
        state_machine.add(game_social_friend_energe_tag_show_terminal)
        state_machine.add(game_social_friend_energe_tag_hide_terminal) 
        state_machine.add(game_social_friend_energe_tag_receive_update_terminal) 
        state_machine.add(game_social_friend_energe_tag_receive_all_terminal) 
	    state_machine.add(game_social_friend_energe_tag_update_draw_terminal)
		state_machine.init()
	end
	
	init_game_social_friend_energe_tag_terminal()
	
end

function SocialFriendEnergeTag:onUpdateDraw()
	local root = self.roots[1]
	local ListView_energe = ccui.Helper:seekWidgetByName(root, "ListView_energe")
    ListView_energe:jumpToTop()
	ListView_energe:removeAllItems()
	local cell_index = 1
	for i, v in pairs(_ED.friend_info) do
		if tonumber(v.is_receive) > 0 then
			local cell = FriendMyListCell:createCell()
			cell:init(v,1,cell_index)
			ListView_energe:addChild(cell)
			cell_index = cell_index + 1
		end
	end
    self._list_view = ListView_energe
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	
	local Text_have_collect_n = ccui.Helper:seekWidgetByName(root, "Text_have_collect_n")
    local Button_sky_collect = ccui.Helper:seekWidgetByName(root, "Button_sky_collect")

    local max_number = dms.int(dms["friend_config"], 4, friend_config.param)
    Text_have_collect_n:setColor(cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]))
    Text_have_collect_n:setString(tonumber(_ED.friendRecipientsNumber))
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_int:setPositionX(Text_have_collect_n:getPositionX()+Text_have_collect_n:getContentSize().width)
    time_int:setPositionY(Text_have_collect_n:getPositionY())
    time_int:setTag(999)
    time_int:setString("/"..max_number)
    if root:getChildByTag(999) ~= nil then
        root:removeChildByTag(999)
    end
    root:addChild(time_int)
	

	if tonumber(_ED.friendRecipientsNumber) >= 10 then
		Button_sky_collect:setEnabled(false)
        Button_sky_collect:setBright(false)
	else
		Button_sky_collect:setEnabled(true)
        Button_sky_collect:setBright(true)
	end
    local Text_energe_not_prompt = ccui.Helper:seekWidgetByName(root, "Text_energe_not_prompt")
    Text_energe_not_prompt:setVisible(false)
    local Items = ListView_energe:getItems()
    if #Items == 0 then
        Text_energe_not_prompt:setVisible(true)
    end
    if nil ~= ListView_energe.setBounceBottomBoundary then
        ListView_energe:setBounceBottomBoundary(0)
    end
end

function SocialFriendEnergeTag:deleteFriend(_id)
	local root = self.roots[1]
	local ListView_energe = ccui.Helper:seekWidgetByName(root, "ListView_energe")
    local items = ListView_energe:getItems()
    for i,v in pairs(items) do
        if tonumber(v.friendInfo.user_id) == tonumber(_id) then
            ListView_energe:removeItem(i-1)
			self._receive_number = self._receive_number + 1
        end
    end
	self._list_view = ListView_energe
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    local Text_energe_not_prompt = ccui.Helper:seekWidgetByName(root, "Text_energe_not_prompt")
    Text_energe_not_prompt:setVisible(false)
    local Items = ListView_energe:getItems()
    if #Items == 0 then
        Text_energe_not_prompt:setVisible(true)
    end
end

function SocialFriendEnergeTag:onUpdate(dt)
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

function SocialFriendEnergeTag:init(params1,params2)
	self._rootWindows = params1
    self:onInit()
    return self
end

function SocialFriendEnergeTag:onInit()
    local csbSocialFriendEnergeTag = csb.createNode(config_csb.friend.friend_give_energe_tab)
    local root = csbSocialFriendEnergeTag:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocialFriendEnergeTag)
	
	-- --一键领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sky_collect"), nil, 
    {
		terminal_name = "game_social_friend_energe_tag_receive_all",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_energe_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_energe_arrow_up")
    
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

function SocialFriendEnergeTag:onExit()
    state_machine.remove("game_social_friend_energe_tag_show")
    state_machine.remove("game_social_friend_energe_tag_hide")
    state_machine.remove("game_social_friend_energe_tag_receive_update")
    state_machine.remove("game_social_friend_energe_tag_receive_all")
    state_machine.remove("game_social_friend_energe_tag_update_draw")
end