-- ---------------------------
-- 军团成员管理
-- ---------------------------
LegionMemberInfor = class("LegionMemberInforClass", Window)

local legion_member_infor_window_open_terminal = {
    _name = "legion_member_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LegionMemberInforClass") == nil then
            local info_data = params[1]
            local cell = params[2]
            local _win = LegionMemberInfor:new()
            _win:init(info_data,cell)
            fwin:open(_win, fwin._ui)
        end
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_member_infor_window_close_terminal = {
    _name = "legion_member_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionMemberInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_member_infor_window_open_terminal)
state_machine.add(legion_member_infor_window_close_terminal)
state_machine.init()

function LegionMemberInfor:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil 
    self._cell = nil
    self._choose_type = 0 
    self.is_friend = false
    app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    local function init_legion_member_infor_terminal()
        --显示界面
        local legion_member_infor_show_terminal = {
            _name = "legion_member_infor_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏界面
        local legion_member_infor_hide_terminal = {
            _name = "legion_member_infor_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local legion_member_infor_change_post_terminal = {
            _name = "legion_member_infor_change_post",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local nType = params._datas._type
                instance._choose_type = nType
                if nType == 1 then
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.quxSureTipCallBack, tipStringInfo_union_str[49])
                    fwin:open(tip, fwin._ui)
                elseif nType == 6 then
                    state_machine.excute("legion_impeachment_window_window_open", 0, {instance._cell,instance._info_data})
                else
                    instance:quxSureTipCallBack(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 好友
        local legion_member_infor_friend_add_or_remove_terminal = {
            _name = "legion_member_infor_friend_add_or_remove",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.is_friend == true then
                    local function recruitDelBackCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                state_machine.excute("game_social_friend_tag_delete_friend", 0, instance._info_data.id)
                                response.node:onUpdateDraw()
                                TipDlg.drawTextDailog(friends_tip_string[4])
                            end
                        end
                    end
                    
                    protocol_command.friend_del.param_list = instance._info_data.id
                    NetworkManager:register(protocol_command.friend_del.code, nil, nil, nil, instance, recruitDelBackCallBack, false, nil)
                else
                    local function recruitDelBackCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node:onUpdateDraw()
                                TipDlg.drawTextDailog(friends_tip_string[1])
                            end
                        end
                    end
                    if instance._info_data.name == _ED.user_info.user_name then
                        TipDlg.drawTextDailog(friends_tip_string[7])
                        return
                    end
                    protocol_command.friend_request.param_list = instance._info_data.name
                    NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitDelBackCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --私聊
        local legion_member_infor_private_chat_terminal = {
            _name = "legion_member_infor_private_chat",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local friend = params._datas.object
                state_machine.excute("red_alert_time_chat_sent_window_open",0,"")
                state_machine.excute("red_alert_time_chat_sent_change_to_person_chat", 0, {_datas = {user_data = {user_id = instance._info_data.id,user_name = instance._info_data.name }}})
                -- TipDlg.drawTextDailog("留下私聊的入口")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --写邮件
        local legion_member_infor_write_an_email_terminal = {
            _name = "legion_member_infor_write_an_email",
            _init = function (terminal)
                app.load("client.red_alert_time.mail.MailWriteAn")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("write_an_email_window_open", 0, {_datas={name=instance._info_data.name,title=""}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --重新刷新玩家信息
        local legion_member_infor_refresh_user_info_terminal = {
            _name = "legion_member_infor_refresh_user_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local user_id = tonumber(instance._info_data.id)
                local new_info = nil
                for k, v in pairs(_ED.union.union_member_list_info) do
                    if user_id == tonumber(v.id) then
                        new_info = v
                        break
                    end
                end
                if new_info == nil then
                    state_machine.excute("legion_member_infor_window_close")
                else
                    instance._info_data = new_info
                    instance:onUpdateDraw()
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_member_infor_show_terminal)  
        state_machine.add(legion_member_infor_hide_terminal)
        state_machine.add(legion_member_infor_change_post_terminal)
        state_machine.add(legion_member_infor_friend_add_or_remove_terminal)
        state_machine.add(legion_member_infor_private_chat_terminal)
        state_machine.add(legion_member_infor_write_an_email_terminal)
        state_machine.add(legion_member_infor_refresh_user_info_terminal)
        state_machine.init()
    end
    init_legion_member_infor_terminal()
end

function LegionMemberInfor:onHide()
    self:setVisible(false)
end

function LegionMemberInfor:onShow()
    self:setVisible(true)
end

function LegionMemberInfor:quxSureTipCallBack(n)
    if n ~= 0 then
        return
    end
    local function responseUnionListCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                if tonumber(response.node._choose_type) == 5 then
                    TipDlg.drawTextDailog(string.format(tipStringInfo_union_str[61], self._info_data.name))
                elseif tonumber(response.node._choose_type) == 1 then
                    TipDlg.drawTextDailog(string.format(tipStringInfo_union_str[64], _ED.user_info.user_name))
                elseif tonumber(response.node._choose_type) == 2 then
                    TipDlg.drawTextDailog(string.format(tipStringInfo_union_str[63], self._info_data.name))
                elseif tonumber(response.node._choose_type) == 4 then
                    TipDlg.drawTextDailog(string.format(tipStringInfo_union_str[64], self._info_data.name))
                end
                state_machine.excute("legion_member_infor_window_close", 0, nil)
            end
        end
    end 
    protocol_command.union_appoint.param_list = _ED.union.union_info.union_id.."\r\n"..self._info_data.id.."\r\n"..self._choose_type
    NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, self, responseUnionListCallback, false, nil)
end

function LegionMemberInfor:onUpdateDraw()
    local root = self.roots[1]
    local Panel_player_head = ccui.Helper:seekWidgetByName(root,"Panel_player_head")                            -- 头像icon
    local Panel_player_military = ccui.Helper:seekWidgetByName(root,"Panel_player_military")                    -- 军衔icon
    local Text_player_military_n = ccui.Helper:seekWidgetByName(root,"Text_player_military_n")                  -- 军衔等级
    local Text_player_fight_n = ccui.Helper:seekWidgetByName(root,"Text_player_fight_n")                        -- 战力
    local Text_player_legion_position_n = ccui.Helper:seekWidgetByName(root,"Text_player_legion_position_n")    -- 职位
    local Text_vip_lv = ccui.Helper:seekWidgetByName(root,"Text_vip_lv")                                        -- VIP等级
    local Text_contribution_n = ccui.Helper:seekWidgetByName(root,"Text_contribution_n")                        -- 贡献
    local Text_week_contribution_n = ccui.Helper:seekWidgetByName(root,"Text_week_contribution_n")              -- 周贡献
    local Text_last_login_n = ccui.Helper:seekWidgetByName(root,"Text_last_login_n")                            -- 最后登录时间

    local Button_player_impeachment = ccui.Helper:seekWidgetByName(root,"Button_player_impeachment")            -- 弹劾按钮
    local Button_up_position = ccui.Helper:seekWidgetByName(root,"Button_up_position")                          -- 升职
    local Button_make_over_postion = ccui.Helper:seekWidgetByName(root,"Button_make_over_postion")              -- 转让团长
    local Button_out_legion = ccui.Helper:seekWidgetByName(root,"Button_out_legion")                            -- 踢出军团
    local Button_up_demotion = ccui.Helper:seekWidgetByName(root,"Button_up_demotion")                          -- 降职

    Button_player_impeachment:setVisible(false)
    Button_up_position:setVisible(false)
    Button_make_over_postion:setVisible(false)
    Button_out_legion:setVisible(false)
    Button_up_demotion:setVisible(false)

    if tonumber(_ED.union.user_union_info.union_post) == 1 then
        if self._info_data.post == 2 then
            Button_up_demotion:setVisible(true)
        else
            Button_up_position:setVisible(true)
        end
        Button_make_over_postion:setVisible(true)
        Button_out_legion:setVisible(true)
    elseif tonumber(_ED.union.user_union_info.union_post) == 2 then
        if self._info_data.post == 1 
            or self._info_data.post == 2 then
            Button_player_impeachment:setVisible(true)
        else
            Button_out_legion:setVisible(true)
            Button_out_legion:setPositionX(320)
        end
    else
        Button_player_impeachment:setVisible(true)
    end

    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    local leave_time = (server_time - tonumber(self._info_data.offline_time))
    local need_time_info = zstring.split(dms.string(dms["union_config"], 56, union_config.param), ",")
    local need_time = tonumber(need_time_info[1]) * 3600 * 24
    -- if leave_time > need_time then
    --     Button_player_impeachment:setBright(true)
    --     Button_player_impeachment:setTouchEnabled(true)
    -- else
    --     Button_player_impeachment:setBright(false)
    --     Button_player_impeachment:setTouchEnabled(false)
    -- end
    self.is_friend = false
    for i, v in pairs(_ED.friend_info) do
        if tonumber(v.user_id) == tonumber(self._info_data.id) then
            self.is_friend = true
        end
    end
    if self.is_friend == true then
        ccui.Helper:seekWidgetByName(root,"Button_player_delete_friend"):setTitleText(friends_tip_string[5])
    else
        ccui.Helper:seekWidgetByName(root,"Button_player_delete_friend"):setTitleText(friends_tip_string[6])
    end

    -- 人物头像      
    local Panel_player_head = ccui.Helper:seekWidgetByName(root,"Panel_player_head") -- 用户头像
    Panel_player_head:removeAllChildren(true)
    local cell = PlayerHeadIcon:createCell()
    local avatar_info = {}
    avatar_info.object = self._info_data.user_head_id
    avatar_info.vip = self._info_data.vip_level
    avatar_info._type = 0
    cell:init(avatar_info)
    Panel_player_head:addChild(cell)  
    -- 战力
    Text_player_fight_n:setString(exChangeNumToString(self._info_data.capactity))

    -- 职位
    if tonumber(self._info_data.post) == 1 then         -- 团长
        Text_player_legion_position_n:setString(tipStringInfo_union_str[52])
    elseif tonumber(self._info_data.post) == 2 then     -- 副团长
        Text_player_legion_position_n:setString(tipStringInfo_union_str[53])
    else                                                -- 团员
        Button_player_impeachment:setBright(false)
        Button_player_impeachment:setTouchEnabled(false)
        Text_player_legion_position_n:setString(tipStringInfo_union_str[54])
    end

    -- VIP等级
    Text_vip_lv:setString(self._info_data.vip_level)

    -- 贡献
    Text_contribution_n:setString(self._info_data.have_devote)

    -- 周贡献
    Text_week_contribution_n:setString(self._info_data.week_devote)

    -- 最后登录时间
    if self._info_data.is_online == true then
        Text_last_login_n:setString(tipStringInfo_union_str[72])
    else
        Text_last_login_n:setString(getLeaveTimeString(self._info_data.offline_time))
    end
    
    -- 军衔
    local military_info = _ED.base_military_info[""..self._info_data.industry_level]
    Panel_player_military:removeBackGroundImage()
    Text_player_military_n:setString("")
    if military_info ~= nil then
        Text_player_military_n:setString(military_info.name)
        Panel_player_military:setBackGroundImage(string.format(config_res.images.ui.props.props, military_info.pic))
    end

    local Text_player_legion_name = ccui.Helper:seekWidgetByName(root,"Text_player_legion_name")
    if Text_player_legion_name ~= nil then
        Text_player_legion_name:setString(self._info_data.name.." "..friends_tip_string[12]..self._info_data.level)
    end
end

function LegionMemberInfor:onEnterTransitionFinish()

end

function LegionMemberInfor:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_member_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_infor_close"), nil, 
    {
        terminal_name = "legion_member_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_member_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3) 

    -- 转让团长
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_make_over_postion"), nil, 
    {
        terminal_name = "legion_member_infor_change_post", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 1,
    }, nil, 1) 

    -- 升职
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up_position"), nil, 
    {
        terminal_name = "legion_member_infor_change_post", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 2,
    }, nil, 1) 

    -- 解除职务
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up_demotion"), nil, 
    {
        terminal_name = "legion_member_infor_change_post", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 4,
    }, nil, 1) 

    -- 踢出军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_out_legion"), nil, 
    {
        terminal_name = "legion_member_infor_change_post", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 5,
    }, nil, 1) 

    -- 弹劾
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_player_impeachment"), nil, 
    {
        terminal_name = "legion_member_infor_change_post", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 6,
    }, nil, 1) 

    -- 好友
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_player_delete_friend"), nil, 
    {
        terminal_name = "legion_member_infor_friend_add_or_remove", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 写邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_player_mail"), nil, 
    {
        terminal_name = "legion_member_infor_write_an_email", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 私聊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_player_chat"), nil, 
    {
        terminal_name = "legion_member_infor_private_chat", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 


    self:onUpdateDraw()
end

function LegionMemberInfor:init(info_data,cell)
    self._info_data = info_data   
    self._cell = cell 
    self:onInit()
    return self
end

function LegionMemberInfor:onExit()
    state_machine.remove("legion_member_infor_show")
    state_machine.remove("legion_member_infor_hide")
    state_machine.remove("legion_member_infor_change_post")
    state_machine.remove("legion_member_infor_friend_add_or_remove")
    state_machine.remove("legion_member_infor_private_chat")
    state_machine.remove("legion_member_infor_write_an_email")
    state_machine.remove("legion_member_infor_refresh_user_info")
end
