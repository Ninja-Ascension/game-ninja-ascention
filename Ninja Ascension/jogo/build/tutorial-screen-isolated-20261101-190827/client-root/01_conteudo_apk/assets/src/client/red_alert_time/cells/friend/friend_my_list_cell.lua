-----------------------------
--我的好友的list的cell
-----------------------------
FriendMyListCell = class("FriendMyListCellClass", Window)FriendMyListCell.__size = nil

function FriendMyListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil
	self.showType = 0
	self.old_local_time = 0

	app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    local function init_friend_my_list_cell_terminal()
        
		--赠送体力
        local friend_my_list_cell_gift_energy_terminal = {
            _name = "friend_my_list_cell_gift_energy",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
				local showType = zstring.tonumber(cell.showType)
				if showType == 0 then
					local id = cell.m_object.user_id
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            TipDlg.drawTextDailog(red_alert_time_str[263])
                            local function responseInitCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    state_machine.excute("game_social_friend_tag_update_draw", 0, "")
                                end
                            end
						    if response.node ~= nil then
						    	NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, response.node, responseInitCallback, false, nil)	
							end
						end
					end
					-- 送耐力接口
					protocol_command.present_endurance.param_list = id
					NetworkManager:register(protocol_command.present_endurance.code, nil, nil, nil, cell, recruitCallBack, false, nil)
				else
					local cell = params._datas.cells
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							TipDlg.drawTextDailog(friends_tip_string[9])
							local function responseInitCallback(response)
						        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    checkRewardObtainDraw()
						            state_machine.excute("game_social_friend_energe_tag_update_draw", 0, "")
						        end
						    end
						    if response.node ~= nil then
						    	NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, response.node, responseInitCallback, false, nil)	
							end
						end
					end
					protocol_command.draw_endurance.param_list = cell.m_object.user_id
					NetworkManager:register(protocol_command.draw_endurance.code, nil, nil, nil, cell, recruitCallBack, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--查看好友属性
        local friend_my_list_cell_look_attributes_terminal = {
            _name = "friend_my_list_cell_look_attributes",
            _init = function (terminal)
                app.load("client.red_alert_time.friend.RedAlertTimeFriendInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cells = params._datas.cells
				if tonumber(cells.showType) == 1 then
					return
				end
				local user_id = 0
				if tonumber(cells.showType) == 0 then
					user_id = params._datas.cells.m_object.user_id
				elseif tonumber(cells.showType) == 2 then
					user_id = params._datas.cells.m_object.shield_user_id
				end
				state_machine.excute("red_alert_time_friend_info_open", 0, user_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --领取体力
        local friend_my_list_cell_receive_energy_terminal = {
            _name = "friend_my_list_cell_receive_energy",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(friends_tip_string[9])
                        local function responseInitCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                checkRewardObtainDraw()
                                state_machine.excute("game_social_friend_tag_update_draw", 0, "")
                            end
                        end
                        if response.node ~= nil then
                            NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, response.node, responseInitCallback, false, nil)    
                        end
                    end
                end
                protocol_command.draw_endurance.param_list = cell.m_object.user_id
                NetworkManager:register(protocol_command.draw_endurance.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(friend_my_list_cell_gift_energy_terminal)
        state_machine.add(friend_my_list_cell_look_attributes_terminal)
        state_machine.add(friend_my_list_cell_receive_energy_terminal)
        state_machine.init()
    end
    init_friend_my_list_cell_terminal()
end

function FriendMyListCell:onEnterTransitionFinish()

end

function FriendMyListCell:onUpdateDraw()
    local root = self.roots[1]
	--头像
	local Panel_player_head = ccui.Helper:seekWidgetByName(root,"Panel_player_head")
	Panel_player_head:removeAllChildren(true)
	local cell = PlayerHeadIcon:createCell()
	local avatar_info = {}
	avatar_info.object = self.m_object.head_pic
	avatar_info.vip = self.m_object.vip_grade
	avatar_info._type = 0
	cell:init(avatar_info)
	Panel_player_head:addChild(cell)
	local fontName = config_res.font.font_name
	if isContentZh_TW() == true then
		fontName = ""
	end
	--名称+等级
	local Text_friend_player_name = ccui.Helper:seekWidgetByName(root,"Text_friend_player_name")
	Text_friend_player_name:removeAllChildren(true)
	local _richText1 = ccui.RichText:create()
	_richText1:ignoreContentAdaptWithSize(false)
	local color = cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3])
	local re1 =ccui.RichElementText:create(1, color,255, self.m_object.name, fontName,22)
	_richText1:pushBackElement(re1)
	local color2 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
	local re2 =ccui.RichElementText:create(1, color2 ,255, " "..friends_tip_string[12]..self.m_object.grade, config_res.font.font_name,22)
	_richText1:pushBackElement(re2)
	_richText1:setContentSize(cc.size(Text_friend_player_name:getContentSize().width,Text_friend_player_name:getContentSize().height))
	_richText1:setAnchorPoint(0,0.5)
	_richText1:setPosition(cc.p(-Text_friend_player_name:getContentSize().width/2,Text_friend_player_name:getContentSize().height/2))
	Text_friend_player_name:addChild(_richText1)

	--最后登录时间
	local Text_last_login_n = ccui.Helper:seekWidgetByName(root,"Text_last_login_n") 
	local times = self.m_object.leave_time
	local str = ""
	local hour = math.floor(tonumber(self.m_object.leave_time)/3600)
	local mins = math.floor((tonumber(self.m_object.leave_time)%3600)/60)
	local day = ""
	if tonumber(self.m_object.leave_time) == 0 or (mins < 1 and hour == 0) then
		str = _string_piece_info[268]
	elseif hour < 1 then
		str = string.format(tipStringInfo_union_str[73], mins)
	elseif hour >= 1 and hour < 24 then
		str = string.format(tipStringInfo_union_str[74], hour)
	elseif hour >= 24 and hour < 168 then
		day = math.ceil(hour / 24)
		str = string.format(tipStringInfo_union_str[75], day)
	elseif hour >= 168 then
		str =  string.format(tipStringInfo_union_str[76], 1)
	end
	Text_last_login_n:setString(str)
	
	--按钮的状态
	local Button_friend_blessing = ccui.Helper:seekWidgetByName(root,"Button_friend_blessing") 
	Button_friend_blessing:setVisible(true)
	if tonumber(self.showType) == 0 then
		ccui.Helper:seekWidgetByName(root,"Button_player_infor"):setVisible(true)
		Button_friend_blessing:setTitleText(red_alert_time_str[188]) 
		if zstring.tonumber(self.m_object.is_send) ~= 0 then
			Button_friend_blessing:setTitleText(red_alert_time_str[190]) 
			Button_friend_blessing:setEnabled(false)
			Button_friend_blessing:setBright(false)
		else
			Button_friend_blessing:setEnabled(true)
			Button_friend_blessing:setBright(true)
		end
	elseif tonumber(self.showType) == 1 then
		ccui.Helper:seekWidgetByName(root,"Button_player_infor"):setVisible(false)
		Button_friend_blessing:setTitleText(red_alert_time_str[189])
		if zstring.tonumber(self.m_object.is_receive) > 1 then
			Button_friend_blessing:setTitleText(red_alert_time_str[191])
			Button_friend_blessing:setEnabled(false)
			Button_friend_blessing:setBright(false)
		else
			Button_friend_blessing:setEnabled(true)
			Button_friend_blessing:setBright(true)
		end
	elseif tonumber(self.showType) == 2 then	
		ccui.Helper:seekWidgetByName(root,"Button_player_infor"):setVisible(false)
		Button_friend_blessing:setVisible(false)
	end

    if __lua_project_id == __lua_project_pacific_rim then
        Button_friend_blessing:setTitleText("")
    end

    -- VIP 
    local Text_friend_vi = ccui.Helper:seekWidgetByName(root,"Text_friend_vi") 
    if Text_friend_vi ~= nil then
        Text_friend_vi:setString(self.m_object.vip_grade)
    end
    -- 战力
    local Text_friend_fight_n = ccui.Helper:seekWidgetByName(root,"Text_friend_fight_n") 
    if Text_friend_fight_n ~= nil then
        Text_friend_fight_n:setString(exChangeNumToString(self.m_object.fighting))
    end
    -- 军团
    local Text_friend_legion_n = ccui.Helper:seekWidgetByName(root,"Text_friend_legion_n") 
    if Text_friend_legion_n ~= nil then
        if self.m_object.army == "" then
            Text_friend_legion_n:setString(tipStringInfo_rank_str[7])
        else
            Text_friend_legion_n:setString(self.m_object.army)
        end
    end
    local Button_friend_blessing_0 = ccui.Helper:seekWidgetByName(root,"Button_friend_blessing_0") 
    if Button_friend_blessing_0 ~= nil then
        if zstring.tonumber(self.m_object.is_receive) == 0 then
            Button_friend_blessing_0:setVisible(false)
        else
            Button_friend_blessing_0:setVisible(true)
            if zstring.tonumber(self.m_object.is_receive) > 1 then
                Button_friend_blessing_0:setEnabled(false)
                Button_friend_blessing_0:setBright(false)
            else
                Button_friend_blessing_0:setEnabled(true)
                Button_friend_blessing_0:setBright(true)
            end
        end
    end
end

function FriendMyListCell:onUpdate(dt)

end

function FriendMyListCell:init(info,showType,index)
	self.m_object = info
	self.showType = showType
    if index ~= nil and index <= 8 then
	
		self:onInit()
    end
	self:setContentSize(FriendMyListCell.__size)
    return self
end

function FriendMyListCell:onInit()
	
    local root = cacher.createUIRef(config_csb.friend.my_friend_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if FriendMyListCell.__size == nil then
        FriendMyListCell.__size = root:getContentSize()
    end  
	
	--赠送体力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_friend_blessing") , nil, 
    {
        terminal_name = "friend_my_list_cell_gift_energy", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cells = self,
    }, nil, 1) 

    --领取体力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_friend_blessing_0") , nil, 
    {
        terminal_name = "friend_my_list_cell_receive_energy", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
        cells = self,
    }, nil, 1)    
	
	--查看好友属性
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_infor") , nil, 
    {
        terminal_name = "friend_my_list_cell_look_attributes", 
        terminal_state = 0,
        touch_black = true, 
		cells = self,
    }, nil, 1)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_player_head") , nil, 
    {
        terminal_name = "friend_my_list_cell_look_attributes", 
        terminal_state = 0,
        touch_black = true, 
		cells = self,
    }, nil, 1)
    
	 fwin:addTouchEventListener(root , nil, 
    {
        terminal_name = "friend_my_list_cell_look_attributes", 
        terminal_state = 0,
		cells = self,
    }, nil, 1)
    
    self:onUpdateDraw() 
	
	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self)
	
end

function FriendMyListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_player_head = ccui.Helper:seekWidgetByName(root,"Panel_player_head")
	local Text_friend_player_name = ccui.Helper:seekWidgetByName(root,"Text_friend_player_name")
	local Text_last_login_n = ccui.Helper:seekWidgetByName(root,"Text_last_login_n") 
	if Panel_player_head~= nil then
		Panel_player_head:removeAllChildren(true)
		Text_friend_player_name:removeAllChildren(true)
		Text_last_login_n:setString("")
	end
end

function FriendMyListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FriendMyListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.friend.my_friend_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FriendMyListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.friend.my_friend_cell, self.roots[1])
end

function FriendMyListCell:createCell()
	local cell = FriendMyListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end