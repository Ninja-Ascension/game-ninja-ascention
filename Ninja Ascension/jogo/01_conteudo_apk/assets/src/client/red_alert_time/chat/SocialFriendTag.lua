-- ----------------------------------------------------------------------------------------------------
-- 说明：社交好友
-------------------------------------------------------------------------------------------------------
SocialFriendTag = class("SocialFriendTagClass", Window)

local game_social_friend_tag_open_terminal = {
    _name = "game_social_friend_tag_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialFriendTagClass")
        if nil == _homeWindow then
    		fwin:open(SocialFriendTag:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local game_social_friend_tag_close_terminal = {
    _name = "game_social_friend_tag_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SocialFriendTagClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SocialFriendTagClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(game_social_friend_tag_open_terminal)
state_machine.add(game_social_friend_tag_close_terminal)
state_machine.init()
    
function SocialFriendTag:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0
	
	self._collection_friend = nil
    self._collection_enrge = nil
    self._collection_shield = nil
    self._collection_xy = nil

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.chats.social_coordinate_favorites_cell")
	app.load("client.red_alert_time.cells.friend.friend_my_list_cell")
	
	local function init_game_social_friend_tag_terminal()
		local game_social_friend_tag_show_terminal = {
            _name = "game_social_friend_tag_show",
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

        local game_social_friend_tag_hide_terminal = {
            _name = "game_social_friend_tag_hide",
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
		
		--添加好友
		local game_social_friend_tag_add_friend_terminal = {
            _name = "game_social_friend_tag_add_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_player_name")
				if text:getString()~= "" and text:getString() ~= nil then
                    if text:getString() == _ED.user_info.user_name then
                        TipDlg.drawTextDailog(friends_tip_string[7])
                        return
                    end
                    for i, v in pairs(_ED.friend_info) do
                        if v.name == text:getString() and tonumber(v.is_delete) < 1 then
                            TipDlg.drawTextDailog(friends_tip_string[8])
                            return
                        end
                    end
                    local function recruitDelBackCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(friends_tip_string[1])
                        end
                    end
					protocol_command.friend_request.param_list = text:getString()
                    NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitDelBackCallBack, false, nil)
				else
					TipDlg.drawTextDailog(friends_tip_string[3])
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--一键祝福
		local game_social_friend_tag_all_blessing_terminal = {
            _name = "game_social_friend_tag_all_blessing",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node:onUpdateDraw()
						end
                        TipDlg.drawTextDailog(red_alert_time_str[264])
					end
				end
				-- 送耐力接口
				protocol_command.present_endurance.param_list = "-1"
				NetworkManager:register(protocol_command.present_endurance.code, nil, nil, nil, instance, responseInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--移除好友(删除时调用)
        local game_social_friend_tag_delete_friend_terminal = {
            _name = "game_social_friend_tag_delete_friend",
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
		
		--刷新添加好友
        local game_social_friend_tag_add_update_friend_terminal = {
            _name = "game_social_friend_tag_add_update_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:addFriend(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local game_social_friend_tag_update_draw_terminal = {
            _name = "game_social_friend_tag_update_draw",
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

        --一键领取
        local game_social_friend_tag_all_receive_terminal = {
            _name = "game_social_friend_tag_all_receive",
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
	
        state_machine.add(game_social_friend_tag_show_terminal)
        state_machine.add(game_social_friend_tag_hide_terminal) 
        state_machine.add(game_social_friend_tag_add_friend_terminal) 
        state_machine.add(game_social_friend_tag_all_blessing_terminal) 
        state_machine.add(game_social_friend_tag_delete_friend_terminal) 
        state_machine.add(game_social_friend_tag_add_update_friend_terminal) 
	    state_machine.add(game_social_friend_tag_update_draw_terminal)
        state_machine.add(game_social_friend_tag_all_receive_terminal)
		state_machine.init()
	end
	
	init_game_social_friend_tag_terminal()
	
end

function SocialFriendTag:onUpdateDraw()
	local root = self.roots[1]
	local ListView_collection_xy = ccui.Helper:seekWidgetByName(root, "ListView_collection_xy")
    ListView_collection_xy:jumpToTop()
	ListView_collection_xy:removeAllItems()

	for i, v in pairs(_ED.friend_info) do
		if v.is_delete ~= "" and v.is_delete ~= nil and tonumber(v.is_delete) == 0 then
			local cell = FriendMyListCell:createCell()
			cell:init(v,0,i)
			ListView_collection_xy:addChild(cell)
		end
	end
    self._list_view = ListView_collection_xy
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    local Text_friend_not_prompt = ccui.Helper:seekWidgetByName(root, "Text_friend_not_prompt")
    Text_friend_not_prompt:setVisible(false)
    local Items = ListView_collection_xy:getItems()
    if #Items == 0 then
        Text_friend_not_prompt:setVisible(true)
    elseif #Items < 8 then
        if nil ~= ListView_collection_xy.setBounceBottomBoundary then
            ListView_collection_xy:setBounceBottomBoundary(0)
        end
    end

    local Text_have_collect_n = ccui.Helper:seekWidgetByName(root, "Text_have_collect_n")
    local Button_res_collection_key_rec = ccui.Helper:seekWidgetByName(root, "Button_res_collection_key_rec")
    local max_number = dms.int(dms["friend_config"], 4, friend_config.param)
    if Text_have_collect_n ~= nil then
        Text_have_collect_n:setString("".._ED.friendRecipientsNumber.."/"..max_number)
    end
    if Button_res_collection_key_rec ~= nil then
        if tonumber(_ED.friendRecipientsNumber) >= max_number then
            Button_res_collection_key_rec:setEnabled(false)
            Button_res_collection_key_rec:setBright(false)
        else
            Button_res_collection_key_rec:setEnabled(true)
            Button_res_collection_key_rec:setBright(true)
        end
    end
end

function SocialFriendTag:addFriend(info)
	local root = self.roots[1]
	local ListView_collection_xy = ccui.Helper:seekWidgetByName(root, "ListView_collection_xy")
    local items = ListView_collection_xy:getItems()
    local cell = FriendMyListCell:createCell()
	cell:init(info,0,#items+1)
	ListView_collection_xy:addChild(cell)
	ListView_collection_xy:jumpToTop()
	ListView_collection_xy:requestRefreshView()
    self._list_view = ListView_collection_xy
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    local Text_friend_not_prompt = ccui.Helper:seekWidgetByName(root, "Text_friend_not_prompt")
    Text_friend_not_prompt:setVisible(false)
    local Items = ListView_collection_xy:getItems()
    if #Items == 0 then
        Text_friend_not_prompt:setVisible(true)
    end
end

function SocialFriendTag:deleteFriend(_id)
	local root = self.roots[1]
	local ListView_collection_xy = ccui.Helper:seekWidgetByName(root, "ListView_collection_xy")
    local items = ListView_collection_xy:getItems()
    for i,v in pairs(items) do
        if tonumber(v.m_object.user_id) == tonumber(_id) then
            ListView_collection_xy:removeItem(i-1)
        end
    end
	ListView_collection_xy:jumpToTop()
	ListView_collection_xy:getInnerContainer():setPositionY(ListView_collection_xy:getInnerContainer():getPositionY() - 1)
	ListView_collection_xy:requestRefreshView()
    self._list_view = ListView_collection_xy
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    local Text_friend_not_prompt = ccui.Helper:seekWidgetByName(root, "Text_friend_not_prompt")
    Text_friend_not_prompt:setVisible(false)
    local Items = ListView_collection_xy:getItems()
    if #Items == 0 then
        Text_friend_not_prompt:setVisible(true)
    end
end

function SocialFriendTag:onUpdate(dt)
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

function SocialFriendTag:init(params1,params2)
	self._rootWindows = params1
    self:onInit()
    return self
end

function SocialFriendTag:onInit()
    local csbSocialFriendTag = csb.createNode(config_csb.friend.friend_list_tab)
    local root = csbSocialFriendTag:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocialFriendTag)
	
	
	local text = ccui.Helper:seekWidgetByName(root, "TextField_player_name")
    local nameData = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
	draw:addEditBoxEx(text, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_01"), tonumber(nameData[2]), cc.KEYBOARD_RETURNTYPE_DONE)
	
	--加好友
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_friend"), nil, 
    {
        terminal_name = "game_social_friend_tag_add_friend", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _page = 1,
    }, nil, 1)
	
	--一键祝福
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sky_blessing"), nil, 
    {
        terminal_name = "game_social_friend_tag_all_blessing", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _page = 1,
    }, nil, 1)

    --一键祝福
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_collection_key_send"), nil, 
    {
        terminal_name = "game_social_friend_tag_all_blessing", 
        terminal_state = 0, 
    }, nil, 1)

    --一键领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_collection_key_rec"), nil, 
    {
        terminal_name = "game_social_friend_tag_all_receive", 
        terminal_state = 0, 
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_friend_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_friend_arrow_up")
    
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
	
	-- 刷新好友
    local function responseInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, self, responseInitCallback, false, nil)
	-- self:onUpdateDraw()
end

function SocialFriendTag:onExit()
	state_machine.remove("game_social_friend_tag_show")
    state_machine.remove("game_social_friend_tag_hide")
    state_machine.remove("game_social_friend_tag_add_friend")
    state_machine.remove("game_social_friend_tag_all_blessing")
    state_machine.remove("game_social_friend_tag_delete_friend")
    state_machine.remove("game_social_friend_tag_add_update_friend")
    state_machine.remove("game_social_friend_tag_update_draw")
    state_machine.remove("game_social_friend_tag_all_receive")
end