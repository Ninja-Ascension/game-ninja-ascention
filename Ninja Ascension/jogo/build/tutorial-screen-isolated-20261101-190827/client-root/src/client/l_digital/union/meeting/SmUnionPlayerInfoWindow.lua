-- ----------------------------------------------------------------------------------------------------
-- 说明：工会角色信息界面
-------------------------------------------------------------------------------------------------------
SmUnionPlayerInfoWindow = class("SmUnionPlayerInfoWindowClass", Window)

local sm_union_player_info_window_open_terminal = {
    _name = "sm_union_player_info_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionPlayerInfoWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionPlayerInfoWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_player_info_window_close_terminal = {
    _name = "sm_union_player_info_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionPlayerInfoWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionPlayerInfoWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_player_info_window_open_terminal)
state_machine.add(sm_union_player_info_window_close_terminal)
state_machine.init()
    
function SmUnionPlayerInfoWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.campaign.icon.arena_role_icon_cell")
    app.load("client.utils.ConfirmTip")
    local function init_sm_union_player_info_window_terminal()
        -- 显示界面
        local sm_union_player_info_window_display_terminal = {
            _name = "sm_union_player_info_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionPlayerInfoWindowWindow = fwin:find("SmUnionPlayerInfoWindowClass")
                if SmUnionPlayerInfoWindowWindow ~= nil then
                    SmUnionPlayerInfoWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_player_info_window_hide_terminal = {
            _name = "sm_union_player_info_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionPlayerInfoWindowWindow = fwin:find("SmUnionPlayerInfoWindowClass")
                if SmUnionPlayerInfoWindowWindow ~= nil then
                    SmUnionPlayerInfoWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --转让会长
        local sm_union_player_info_window_transfer_president_terminal = {
            _name = "sm_union_player_info_window_transfer_president",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                local function sureFunc(sender, sure_number)
                    if sure_number ~= 0 then
                        return
                    end
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            -- FURY: repintar la lista antes de cerrar; si no, el presidente sigue viendo
                            -- cargos viejos y el siguiente mando se rechaza (mismo camino que
                            -- union_the_meeting_place_member_cell.lua:166).
                            state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                            -- FURY v47: la lista visible de esta variante es la de "Informacion Basica"
                            -- (UnionTheMeetingPlaceInformation); la de arriba solo existe con la pestana de
                            -- miembros, que este .csb no trae, y sin esta linea la lista se quedaba rancia.
                            state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
                            state_machine.excute("sm_union_player_info_window_close", 0, "")
                        end
                    end
                    local killOutParam = ""..sender.unionData.id.."\r\n".."4"
                    protocol_command.union_appoint.param_list = killOutParam
                    NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, nil, responseCallback, false, nil)
                end

                local tip = ConfirmTip:new()
                tip:init(mcell, sureFunc, string.format(union_job_title[7], mcell.unionData.name))
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --提出工会
        local sm_union_player_info_window_present_the_guild_terminal = {
            _name = "sm_union_player_info_window_present_the_guild",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                local function sureFunc(sender, sure_number)
                    if sure_number ~= 0 then
                        return
                    end
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            -- FURY: repintar la lista antes de cerrar; si no, el presidente sigue viendo
                            -- cargos viejos y el siguiente mando se rechaza (mismo camino que
                            -- union_the_meeting_place_member_cell.lua:166).
                            state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                            -- FURY v47: la lista visible de esta variante es la de "Informacion Basica"
                            -- (UnionTheMeetingPlaceInformation); la de arriba solo existe con la pestana de
                            -- miembros, que este .csb no trae, y sin esta linea la lista se quedaba rancia.
                            state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
                            state_machine.excute("sm_union_player_info_window_close", 0, "")
                        end
                    end
                    local killOutParam = ""..sender.unionData.id.."\r\n".."3"
                    protocol_command.union_appoint.param_list = killOutParam
                    NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, nil, responseCallback, false, nil)
                end

                local tip = ConfirmTip:new()
                tip:init(mcell, sureFunc, union_job_title[6])
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --升职
        local sm_union_player_info_window_promotion_terminal = {
            _name = "sm_union_player_info_window_promotion",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(union_job_title[4])
                        -- FURY: repintar la lista antes de cerrar; si no, el presidente sigue viendo
                        -- cargos viejos y el siguiente mando se rechaza (mismo camino que
                        -- union_the_meeting_place_member_cell.lua:166).
                        state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                        -- FURY v47: la lista visible de esta variante es la de "Informacion Basica"
                        -- (UnionTheMeetingPlaceInformation); la de arriba solo existe con la pestana de
                        -- miembros, que este .csb no trae, y sin esta linea la lista se quedaba rancia.
                        state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
                        state_machine.excute("sm_union_player_info_window_close", 0, "")
                    end
                end
                local killOutParam = ""..mcell.unionData.id.."\r\n".."1"
                print("--------killOutParam------"..killOutParam)
                protocol_command.union_appoint.param_list = killOutParam
                NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --降职
        local sm_union_player_info_window_demoted_terminal = {
            _name = "sm_union_player_info_window_demoted",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                local _type = params._datas._type
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(union_job_title[5])
                        -- FURY: repintar la lista antes de cerrar; si no, el presidente sigue viendo
                        -- cargos viejos y el siguiente mando se rechaza (mismo camino que
                        -- union_the_meeting_place_member_cell.lua:166).
                        state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                        -- FURY v47: la lista visible de esta variante es la de "Informacion Basica"
                        -- (UnionTheMeetingPlaceInformation); la de arriba solo existe con la pestana de
                        -- miembros, que este .csb no trae, y sin esta linea la lista se quedaba rancia.
                        state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
                        state_machine.excute("sm_union_player_info_window_close", 0, "")
                    end
                end
                local killOutParam = ""..mcell.unionData.id.."\r\n".."2"
                protocol_command.union_appoint.param_list = killOutParam
                NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_player_info_add_friend_terminal = {
            _name = "sm_union_player_info_add_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local info = instance.unionData
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local str = fwin:find("FriendManagerThreeClass")
                        if str ~= nil then
                            state_machine.excute("friend_manager_three_add", 0, info.id)
                        end
                        if response.node.types == 1 then
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                state_machine.excute("friend_manager_recommend_cell_update", 0, response.node.cell)
                            end
                        end
                        local str2 = fwin:find("FriendManagerRecommendClass")
                        if str2 ~= nil then
                            state_machine.excute("friend_manager_recommend_del", 0, info.id)
                        end
                        
                        TipDlg.drawTextDailog(_string_piece_info[259] .. info.name .._string_piece_info[260])
                        fwin:close(response.node)
                    end
                end
                
                protocol_command.friend_request.param_list = info.id .."\r\n".._string_piece_info[368]
                NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local sm_union_player_info_one_by_one_chat_terminal = {
            _name = "sm_union_player_info_one_by_one_chat",
            _init = function (terminal) 
                 app.load("client.chat.ChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local str = fwin:find("ChatStorageClass")
                if str ~= nil then
                    state_machine.excute("chat_whisper_page_other", 0, instance.unionData.name)
                else
                    local cell = ChatStorage:new()
                    cell:init(1)
                    fwin:open(cell, fwin._ui)
                    state_machine.excute("chat_whisper_page_other", 0, instance.unionData.name)
                end
                local str2 = fwin:find("FriendManagerRecommendClass")
                if str2 ~= nil then
                    fwin:close(str2)
                end
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_union_player_info_window_display_terminal)
        state_machine.add(sm_union_player_info_window_hide_terminal)
        state_machine.add(sm_union_player_info_window_demoted_terminal)
        state_machine.add(sm_union_player_info_window_promotion_terminal)
        state_machine.add(sm_union_player_info_window_present_the_guild_terminal)
        state_machine.add(sm_union_player_info_window_transfer_president_terminal)
        state_machine.add(sm_union_player_info_add_friend_terminal)
        state_machine.add(sm_union_player_info_one_by_one_chat_terminal)


        state_machine.init()
    end
    init_sm_union_player_info_window_terminal()
end

function SmUnionPlayerInfoWindow:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.unionData.headFrameID,
        headFrameStage = self.unionData.headFrameStage,
        headID = self.unionData.user_head,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function SmUnionPlayerInfoWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    -- 头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_player_icon")
    Panel_player_icon:removeAllChildren(true)
    
	local headIcon = nil
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		-- 新增头像框
		headIcon = self:getNewHeadIcon()
	else
        headIcon = ArenaRoleIconCell:createCell()
        headIcon:init(tonumber(self.unionData.user_head), 1)
	end
	Panel_player_icon:addChild(headIcon)

    --玩家名称
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString(self.unionData.name)
    --玩家等级
    local Text_lv_n = ccui.Helper:seekWidgetByName(root,"Text_lv_n")
    Text_lv_n:setString("Lv."..self.unionData.level)
    --职位
    local Text_zhiwei = ccui.Helper:seekWidgetByName(root,"Text_zhiwei")
    if self.unionData.post ~= nil then
        Text_zhiwei:setVisible(true)
        if tonumber(self.unionData.post) > 2 then
            Text_zhiwei:setString(union_job_title[3])
        else
            Text_zhiwei:setString(union_job_title[tonumber(self.unionData.post)])
        end
    else
        Text_zhiwei:setVisible(false)
    end
    --vip
    local Image_vip_icon = ccui.Helper:seekWidgetByName(root,"Image_vip_icon")
    local Text_vip_n = ccui.Helper:seekWidgetByName(root,"Text_vip_n")
    if tonumber(self.unionData.vipLevel) > 0 then
        Image_vip_icon:setVisible(true)
        Text_vip_n:setVisible(true)
        Text_vip_n:setString(self.unionData.vipLevel)
    else
        Image_vip_icon:setVisible(false)
        Text_vip_n:setVisible(false)
    end
    --最近登陆时间
    local Text_time_n = ccui.Helper:seekWidgetByName(root,"Text_time_n")
    Text_time_n:setString(self:getLeaveTimeString(zstring.tonumber(self.unionData.offline_time)/1000))
    --工会贡献
    local Text_gongxian_n = ccui.Helper:seekWidgetByName(root,"Text_gongxian_n")
    if self.unionData.rest_contribution == nil then
        Text_gongxian_n:setString("")
    else
        Text_gongxian_n:setString(self.unionData.rest_contribution)
    end
    
    --战斗力
    local Text_fighting_n = ccui.Helper:seekWidgetByName(root,"Text_fighting_n")
    Text_fighting_n:setString(self.unionData.capactity)

    --武将列表
   	local ListView_player_zr = ccui.Helper:seekWidgetByName(root,"ListView_player_zr")
   	ListView_player_zr:removeAllItems()

   	local shipAllData = zstring.split(_ED.chat_user_info.formation, "!")
   	for i, v in pairs(shipAllData) do
   		--模板id:等级:进阶数据:星级:品阶:战力
   		local shipData = zstring.split(v, ":")

   		local cell = HeroIconListCell:createCell()
   		local ship = {}
   		ship.ship_template_id = shipData[1]
   		ship.evolution_status = shipData[3]
   		ship.Order = shipData[5]
   		ship.StarRating = shipData[4]
   		ship.ship_grade = shipData[2]
        ship.skin_id = shipData[7]
   		ship.ship_id = -1
   		cell:init(ship, i,true)
   		ListView_player_zr:addChild(cell)
   	end
   	ListView_player_zr:requestRefreshView()

    -- Text_speed_n:setString(self.roleInstance.speed)

    -- local Image_vip_icon = ccui.Helper:seekWidgetByName(root,"Image_vip_icon")
    -- Image_vip_icon:setVisible(true)
    -- local Text_vip_n = ccui.Helper:seekWidgetByName(root,"Text_vip_n")
    -- Text_vip_n:setVisible(true)
    -- Text_vip_n:setString(self.roleInstance.vip)
    --确定
    local Button_ok = ccui.Helper:seekWidgetByName(root,"Button_ok")    
    --传职位
    local Button_transfer = ccui.Helper:seekWidgetByName(root,"Button_transfer")    
    --提出工会
    local Button_kick_out = ccui.Helper:seekWidgetByName(root,"Button_kick_out")    
    --升职
    local Button_job_up = ccui.Helper:seekWidgetByName(root,"Button_job_up")    
    --降职
    local Button_job_down = ccui.Helper:seekWidgetByName(root,"Button_job_down")    

    if tonumber(_ED.union.user_union_info.union_post) == 1 then
        --我是会长
        if tonumber(self.unionData.post) == 1 then
            Button_ok:setVisible(true)
            Button_transfer:setVisible(false)
            Button_kick_out:setVisible(false)
            Button_job_up:setVisible(false)
            Button_job_down:setVisible(false)
        elseif tonumber(self.unionData.post) == 2 then
            Button_ok:setVisible(false)
            Button_transfer:setVisible(true)
            Button_kick_out:setVisible(true)
            Button_job_up:setVisible(false)
            Button_job_down:setVisible(true)
        else
            Button_ok:setVisible(false)
            Button_transfer:setVisible(true)
            Button_kick_out:setVisible(true)
            Button_job_up:setVisible(true)
            Button_job_down:setVisible(false)
        end
    elseif tonumber(_ED.union.user_union_info.union_post) == 2 then
        --我是副会长
        if tonumber(self.unionData.post) == 1 or tonumber(self.unionData.post) == 2 then
            Button_ok:setVisible(true)
            Button_transfer:setVisible(false)
            Button_kick_out:setVisible(false)
            Button_job_up:setVisible(false)
            Button_job_down:setVisible(false)
        else
            Button_ok:setVisible(true)
            Button_transfer:setVisible(false)
            Button_kick_out:setVisible(true)
            Button_job_up:setVisible(false)
            Button_job_down:setVisible(false)
        end
    else
        --我是会员
        Button_ok:setVisible(true)
        Button_transfer:setVisible(false)
        Button_kick_out:setVisible(false)
        Button_job_up:setVisible(false)
        Button_job_down:setVisible(false)
    end

    if self.unionData.post == nil then
        Button_ok:setVisible(true)
        Button_transfer:setVisible(false)
        Button_kick_out:setVisible(false)
        Button_job_up:setVisible(false)
        Button_job_down:setVisible(false)
        Text_gongxian_n:setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_gongxian"):setVisible(false)
    else
        Text_gongxian_n:setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_gongxian"):setVisible(true)    
    end

    if self.isHideButton then
        Button_ok:setVisible(true)
        Button_transfer:setVisible(false)
        Button_kick_out:setVisible(false)
        Button_job_up:setVisible(false)
        Button_job_down:setVisible(false)
    end
end

function SmUnionPlayerInfoWindow:getLeaveTimeString(leave_time)
    local str = ""
    local hour = math.floor(tonumber(leave_time)/3600)
    local mins = math.floor((tonumber(leave_time)%3600)/60)
    local day = ""
    if tonumber(leave_time) == 0 or (mins < 1 and hour == 0) then
        str = _string_piece_info[268]                   -- 在线
    elseif hour < 1 then
        str = _string_piece_info[269] .. mins .. _string_piece_info[270]
    elseif hour >= 1 and hour < 24 then
        str = _string_piece_info[269] .. hour .._string_piece_info[271]
    elseif hour >= 24 and hour < 336 then
        day = math.ceil(hour / 24)
        str = _string_piece_info[269] .. day .._string_piece_info[231]
    elseif hour >= 336 then
        if verifySupportLanguage(_lua_release_language_en) == true then
            str = _string_piece_info[269] .. 7 .._string_piece_info[272]
        else
            str = _string_piece_info[269] .. 1 .._string_piece_info[272]
        end
    end
    return str
end

function SmUnionPlayerInfoWindow:init(params)
    self.unionData = params
    self.isHideButton = self.unionData.isHideButton
    self:onInit()
    return self
end

function SmUnionPlayerInfoWindow:onInit()
    local csbSmUnionPlayerInfoWindow = csb.createNode("legion/sm_legion_player_info_window.csb")
    local root = csbSmUnionPlayerInfoWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionPlayerInfoWindow)
    local action = csb.createTimeline("legion/sm_legion_player_info_window.csb")
    table.insert(self.actions, action)
    csbSmUnionPlayerInfoWindow:runAction(action)
	action:play("window_open", false)

    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_union_player_info_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_union_player_info_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    --传职位
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_transfer"), nil, 
    {
        terminal_name = "sm_union_player_info_window_transfer_president",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,0)

    --提出工会
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_kick_out"), nil, 
    {
        terminal_name = "sm_union_player_info_window_present_the_guild",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,0)

    --升职
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_job_up"), nil, 
    {
        terminal_name = "sm_union_player_info_window_promotion",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,0)

    --降职
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_job_down"), nil, 
    {
        terminal_name = "sm_union_player_info_window_demoted",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,0)
    --私聊
    local Button_call = ccui.Helper:seekWidgetByName(root,"Button_call")
    if Button_call ~= nil then
       fwin:addTouchEventListener(Button_call, nil, 
        {
            terminal_name = "sm_union_player_info_one_by_one_chat",
            terminal_state = 0,
            touch_black = true,
        },
        nil,3) 
        Button_call:setVisible(true)
    end
    --加好友
    local Button_add_friend = ccui.Helper:seekWidgetByName(root,"Button_add_friend")
    if Button_add_friend ~= nil then
       fwin:addTouchEventListener(Button_add_friend, nil, 
        {
            terminal_name = "sm_union_player_info_add_friend",
            terminal_state = 0,
            touch_black = true,
        },
        nil,3) 
       Button_add_friend:setVisible(true)
    end

end

function SmUnionPlayerInfoWindow:onExit()
    state_machine.remove("sm_union_player_info_window_display")
    state_machine.remove("sm_union_player_info_window_hide")
    state_machine.remove("sm_union_player_info_window_demoted")
    state_machine.remove("sm_union_player_info_window_promotion")
    state_machine.remove("sm_union_player_info_window_present_the_guild")
    state_machine.remove("sm_union_player_info_window_transfer_president")
    state_machine.remove("sm_union_player_info_one_by_one_chat")
    state_machine.remove("sm_union_player_info_add_friend")
end