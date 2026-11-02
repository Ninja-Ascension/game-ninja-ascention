--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅成员
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlaceMemberCell = class("UnionTheMeetingPlaceMemberCellClass", Window)

UnionTheMeetingPlaceMemberCell.__size = nil
function UnionTheMeetingPlaceMemberCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.unionData = nil
	self.isOpenAppoint = false

    self.max = 5
    if __lua_project_id == __lua_project_l_digital then
        self.max = 8
    end

	 -- Initialize union the meeting place member list cell state machine.
    local function init_union_the_meeting_place_member_cell_terminal()
		-- 查看玩家信息
		 local union_the_meeting_place_member_list_cell_look_info_terminal = {
            _name = "union_the_meeting_place_member_cell_look_info",
            _init = function (terminal)
                -- app.load("client.chat.ChatFriendInfo")
                app.load("client.l_digital.union.meeting.SmUnionPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local unionData = params._datas.unionData
                local function responseShowUserInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_union_player_info_window_open", 0, unionData)
                    end
                end
                protocol_command.see_user_info.param_list = params._datas.unionData.id
                NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, self, responseShowUserInfoCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--弹劾
		local union_the_meeting_place_member_cell_impeachment_terminal = {
            _name = "union_the_meeting_place_member_cell_impeachment",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                        state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
                    end
                end
                NetworkManager:register(protocol_command.union_impeach.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 退出军团
		local union_the_meeting_place_member_cell_go_out_terminal = {
            _name = "union_the_meeting_place_member_cell_go_out",
            _init = function (terminal)
                 app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell

                if tonumber(_ED.union.user_union_info.union_post) == 1 then
                    if tonumber(_ED.union.union_info.members) == 1 then  
                        mcell:quxSureTip(2)
                    else
                        TipDlg.drawTextDailog(tipStringInfo_union_str[46])
                    end 
                    return
                else 
                    mcell:quxSureTip(1)
                end  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--打开任命界面
		local union_the_meeting_place_member_cell_open_appoint_terminal = {
            _name = "union_the_meeting_place_member_cell_open_appoint",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                if mcell.isOpenAppoint == false then
                   mcell.isOpenAppoint = true
                   mcell:OpenRenMing(params)
                else  
                    mcell:CloseRenMing(params)
                   mcell.isOpenAppoint = false
                end 
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                --     end
                -- end
                -- local unionData = params._datas.unionData
                -- local killOutParam = ""..unionData.id.."\r\n".."1"
                -- protocol_command.union_appoint.param_list = killOutParam
                -- NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, nil, responseCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 踢出
        local union_the_meeting_place_member_cell_kill_out_terminal = {
            _name = "union_the_meeting_place_member_cell_kill_out",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params ._datas.cell
                mcell:quxSureTip(3)
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                --     end
                -- end
                -- local unionData = params._datas.unionData
                -- local killOutParam = ""..unionData.id.."\r\n".."3"
                -- protocol_command.union_appoint.param_list = killOutParam
                -- NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, nil, responseCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 任命
        local union_the_meeting_place_member_cell_to_appoint_terminal = {
            _name = "union_the_meeting_place_member_cell_to_appoint",
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

                        state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                    end
                end
                local unionData = params._datas.unionData._datas.unionData
                local killOutParam = ""..unionData.id.."\r\n".._type
                protocol_command.union_appoint.param_list = killOutParam
                NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_the_meeting_place_member_list_cell_look_info_terminal)
		state_machine.add(union_the_meeting_place_member_cell_impeachment_terminal)
		state_machine.add(union_the_meeting_place_member_cell_go_out_terminal)
		state_machine.add(union_the_meeting_place_member_cell_open_appoint_terminal)
        state_machine.add(union_the_meeting_place_member_cell_kill_out_terminal)
        state_machine.add(union_the_meeting_place_member_cell_to_appoint_terminal)
        state_machine.init()
    end
    -- call func init union the meeting place member list cell state machine.
    init_union_the_meeting_place_member_cell_terminal()
end

function UnionTheMeetingPlaceMemberCell:CloseRenMing(data)
    local root = self.roots[1]
    if root == nil then
        return
    end
    local action = self.actions[1]
    action:play("button_renming_1", false)
end

function UnionTheMeetingPlaceMemberCell:OpenRenMing(data)
    local root = self.roots[1]
    if root == nil then
        return
    end
    local action = self.actions[1]
    action:play("button_renming", false)
    local zhiwei1 = ccui.Helper:seekWidgetByName(root, "Button_bm_zhiwei_0")  ---任命副队长
    local zhiwei2 = ccui.Helper:seekWidgetByName(root, "Button_bm_zhiwei")  ---罢免职位
    local yijiao = ccui.Helper:seekWidgetByName(root, "Button_rm_juntuanz")  --- 移交队长
    zhiwei1:setVisible(false)
    zhiwei2:setVisible(false)
    yijiao:setVisible(false)
    -- 会长
    if tonumber(_ED.union.user_union_info.union_post) == 1 then
        if tonumber(self.unionData.id) == tonumber(_ED.union.user_union_info.union_leader1_id)  or 
            tonumber(self.unionData.id) == tonumber(_ED.union.user_union_info.union_leader2_id) then -- 副会长
            yijiao:setVisible(true)
            zhiwei2:setVisible(true)
            zhiwei1:setVisible(false)
        else-- 其他成员
            yijiao:setVisible(true)
            zhiwei2:setVisible(false)
            zhiwei1:setVisible(true)
        end
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bm_zhiwei_0"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_to_appoint", 
        terminal_state = 0,
        unionData = data,
        cell = self,
        _type = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bm_zhiwei"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_to_appoint", 
        terminal_state = 0,
        unionData = data,
        cell = self,
        _type = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rm_juntuanz"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_to_appoint", 
        terminal_state = 0,
        unionData = data,
        cell = self,
        _type = 4,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end


function UnionTheMeetingPlaceMemberCell:quxSureTipCallBack(n)
    if n ~= 0 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("union_the_meeting_place_clean_all_data", 0, nil)
            fwin:cleanView(fwin._view)
            fwin:close(response.node)
            if fwin:find("HomeClass") == nil then
                state_machine.excute("menu_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "menu_manager",     
                            next_terminal_name = "menu_show_home_page", 
                            current_button_name = "Button_home",
                            but_image = "Image_home",       
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    }
                )
            end
            state_machine.excute("menu_back_home_page", 0, "")
        end
    end
    NetworkManager:register(protocol_command.union_exit.code, nil, nil, nil, self, responseCallback, false, nil)
end

function UnionTheMeetingPlaceMemberCell:quxSureTipCallBack1( n )
    if n ~= 0 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("union_the_meeting_place_clean_all_data", 0, nil)
            fwin:cleanView(fwin._view)
            fwin:close(response.node)
            if fwin:find("HomeClass") == nil then
                state_machine.excute("menu_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "menu_manager",     
                            next_terminal_name = "menu_show_home_page", 
                            current_button_name = "Button_home",
                            but_image = "Image_home",       
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    }
                )

            end
            state_machine.excute("menu_back_home_page", 0, "")
        end

    end
    NetworkManager:register(protocol_command.union_dismiss.code, nil, nil, nil, self, responseCallback, false, nil)
end

function UnionTheMeetingPlaceMemberCell:quxSureTipCallBack2( n )
    if n ~= 0 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
            
        end
    end
    local unionData = self.unionData
    local killOutParam = ""..unionData.id.."\r\n".."3"
    protocol_command.union_appoint.param_list = killOutParam
    NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, nil, responseCallback, false, nil)
end 

function UnionTheMeetingPlaceMemberCell:quxSureTip(_type)

    local tip = ConfirmTip:new()
    if _type == 1 then 
        tip:init(self, self.quxSureTipCallBack, tipStringInfo_union_str[47])
    elseif _type == 2 then
        tip:init(self, self.quxSureTipCallBack1, tipStringInfo_union_str[49])
    elseif _type == 3 then
         tip:init(self, self.quxSureTipCallBack2, tipStringInfo_union_str[58])
    end
    fwin:open(tip,fwin._ui)
end

function UnionTheMeetingPlaceMemberCell:updateDraw()
    local root = self.roots[1]
    local nameText = ccui.Helper:seekWidgetByName(root, "Text_081"):setString("")
    local Text_086 = ccui.Helper:seekWidgetByName(root, "Text_086"):setString("")
    --local Text_087 = ccui.Helper:seekWidgetByName(root, "Text_087"):setString("")
    local Text_088 = ccui.Helper:seekWidgetByName(root, "Text_088"):setString("")
    --local Text_089 = ccui.Helper:seekWidgetByName(root, "Text_089"):setString("")
    local Text_0810 = ccui.Helper:seekWidgetByName(root, "Text_zjdl"):setString("")
    --local Image_16 = ccui.Helper:seekWidgetByName(root, "Image_16"):setVisible(false)
    --local Image_17 = ccui.Helper:seekWidgetByName(root, "Image_17"):setVisible(false)
    --local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18"):setVisible(false)
    local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
    Panel_4:removeAllChildren(true)
    --local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5"):setVisible(false)
    --local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(false)
    -- local Panel_7 = ccui.Helper:seekWidgetByName(root, "Panel_7"):setVisible(false)
    -- local Panel_7_0 = ccui.Helper:seekWidgetByName(root, "Panel_7_0"):setVisible(false)
    -- local Panel_6_0 = ccui.Helper:seekWidgetByName(root, "Panel_6_0"):setVisible(false)
    -- local Panel_5_0 = ccui.Helper:seekWidgetByName(root, "Panel_5_0"):setVisible(false)
    --职位
    local Text_zhiwei = ccui.Helper:seekWidgetByName(root, "Text_zhiwei")
    if tonumber(self.unionData.post) > 2 then
        Text_zhiwei:setString(union_job_title[3])
    else
        Text_zhiwei:setString(union_job_title[tonumber(self.unionData.post)])
    end
    
    if self.unionData == nil then
        return
    end
    nameText:setString(self.unionData.name)
    local quality = tonumber(self.unionData.quality) + 1

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        nameText:setColor(cc.c3b(71,71,71))
    elseif __lua_project_id == __lua_project_l_digital then

    else
        nameText:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
    end

    Text_086:setString("Lv."..self.unionData.level)
    --Text_087:setString(self.unionData.capactity)
    Text_088:setString(self.unionData.total_contribution)
    -- if tonumber(self.unionData.build_type) == 0 or tonumber(self.unionData.build_type) == nil then
    --     Text_089:setString("0")
    -- else
    --     local configs = zstring.split(dms.string(dms["pirates_config"], 202, pirates_config.param), ",")
    --     local typeInfo = zstring.split(configs[tonumber(self.unionData.build_type)], "|")
    --     Text_089:setString(""..typeInfo[4])
    -- end
    Text_0810:setString(self:getLeaveTimeString(getBaseGTM8Time(zstring.tonumber(self.unionData.offline_time)/1000)))

	local headIcon = nil
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		-- 新增头像框
		headIcon = self:getNewHeadIcon()
	else
		headIcon = self:onHeadDraw(self.unionData.id, quality, self.unionData.user_head, self.unionData.vipLevel)
	end
    if headIcon ~= nil then
        Panel_4:addChild(headIcon)
    end

    -- DSC的VIP显示由头像ICON处理
	if fun_is_open ~= true then
        local Text_vip_lv = ccui.Helper:seekWidgetByName(root, "Text_vip_lv")
        if Text_vip_lv ~= nil then
            if tonumber(self.unionData.vipLevel) > 0 then
                Text_vip_lv:setString("V "..self.unionData.vipLevel)
            else
                Text_vip_lv:setString("")
            end
        end
    end
    -- if tonumber(self.unionData.post) == 1 then
    --     Image_16:setVisible(true)
    -- elseif tonumber(self.unionData.post) == 2 then
    --     Image_17:setVisible(true)
    -- else
    --     Image_18:setVisible(true)
    -- end
    -- 会长
    -- if tonumber(_ED.union.user_union_info.union_post) == 1 then
    --     if tonumber(self.unionData.id) == tonumber(_ED.user_info.user_id) then -- 自己(退出)
    --         Panel_7:setVisible(true)
    --     else-- 副会长，其他成员（任命，踢出）
    --         Panel_5_0:setVisible(true)
    --     end
        
    -- -- 副会长
    -- elseif tonumber(_ED.union.user_union_info.union_post) == 2 then
    --     if tonumber(self.unionData.id) == tonumber(_ED.user_info.user_id) then -- 自己（退出）
    --         Panel_7:setVisible(true)
    --     elseif tonumber(self.unionData.id) == tonumber(_ED.union.user_union_info.union_leader_id) then -- 会长（弹劾）
    --         Panel_7_0:setVisible(true)
    --     elseif tonumber(self.unionData.id) == tonumber(_ED.union.user_union_info.union_leader1_id) or -- 副会长（查看）
    --         tonumber(self.unionData.id) == tonumber(_ED.union.user_union_info.union_leader2_id) then
    --         Panel_6:setVisible(true)
    --     else -- 成员（踢出）
    --         Panel_6_0:setVisible(true)
    --     end
    -- -- 成员
    -- else
    --     if tonumber(self.unionData.id) == tonumber(_ED.user_info.user_id) then -- 自己（退出）
    --         Panel_7:setVisible(true)
    --     elseif tonumber(self.unionData.id) == tonumber(_ED.union.user_union_info.union_leader_id) then -- 会长（弹劾）
    --         Panel_7_0:setVisible(true)
    --     else -- 副会长，成员（查看）
    --         Panel_6:setVisible(true)
    --     end
    -- end

    if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        local Image_1_0 = ccui.Helper:seekWidgetByName(root,"Image_1_0")
        Image_1_0:setVisible(false)
        if tonumber(self.unionData.id) == tonumber(_ED.user_info.user_id) then 
            Image_1_0:setVisible(true)
        end
    end
end

function UnionTheMeetingPlaceMemberCell:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.unionData.headFrameID,
        headFrameStage = self.unionData.headFrameStage,
        headID = self.unionData.user_head,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function UnionTheMeetingPlaceMemberCell:onHeadDraw(userId, quality, headIndex, vipLevel)
    -- local csbItem = csb.createNode("icon/item.csb")
    -- local roots = csbItem:getChildByName("root")
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)

    self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
    if self.item_order_level._x == nil then
        self.item_order_level._x = self.item_order_level:getPositionX()
    end

    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
        Panel_head:removeBackGroundImage()
    end
    if Panel_kuang ~= nil then
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end
    local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
    local quality_kuang = 1
    if tonumber(vipLevel) > 0 then
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 5)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 14)
    else
        quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 1)
        quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 1)
    end
    local big_icon_path = nil
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    Panel_ditu:setBackGroundImage(quality_path)
    Panel_kuang:setBackGroundImage(quality_kuang)
    Panel_head:setBackGroundImage(big_icon_path)
    -- if tonumber(vipLevel) > 0 then
    --     ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
    -- end
    
    fwin:addTouchEventListener(Panel_head, nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_look_info",
        unionData = self.unionData,
        terminal_state = 0,
    }, 
    nil, 0)
    return roots
end

function UnionTheMeetingPlaceMemberCell:getLeaveTimeString(leave_time)
    local str = ""
    local hour = math.floor(tonumber(leave_time)/3600)
    local mins = math.floor((tonumber(leave_time)%3600)/60)
    local day = ""
    if tonumber(leave_time) == 0 or (mins < 1 and hour == 0) then
        str = _string_piece_info[268]                   -- 在线
    elseif hour < 1 then
        str = mins .. _string_piece_info[270]..tipStringInfo_time_info[9]
    elseif hour >= 1 and hour < 24 then
        str = hour .._string_piece_info[271]..tipStringInfo_time_info[9]
    elseif hour >= 24 then
        day = math.ceil(hour / 24)
        if verifySupportLanguage(_lua_release_language_en) == true then
            if day>=7 then
                day = 7
            end
            str = day .._string_piece_info[231]..tipStringInfo_time_info[9]
        else
            str = day .._string_piece_info[231]..tipStringInfo_time_info[9]
        end
    end
    return str
end

function UnionTheMeetingPlaceMemberCell:onInit()    
    local root = cacher.createUIRef("legion/legion_procedure_hall_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    if UnionTheMeetingPlaceMemberCell.__size == nil then
        UnionTheMeetingPlaceMemberCell.__size = root:getContentSize()
    end

    -- local action = csb.createTimeline("legion/legion_procedure_hall_list.csb")
    -- table.insert(self.actions, action)
    -- root:runAction(action)
    -- action:play("list_view_cell_open", false)


    -- action:play("button_renming",false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuichu"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_go_out", 
        terminal_state = 0,
        unionData = self.unionData,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_3"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_look_info", 
        terminal_state = 0,
        unionData = self.unionData,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chakan_1"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_look_info", 
        terminal_state = 0,
        unionData = self.unionData,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tanhe"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_impeachment", 
        terminal_state = 0,
        unionData = self.unionData,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tanhe_1"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_impeachment", 
        terminal_state = 0,
        unionData = self.unionData,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_renming"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_open_appoint", 
        terminal_state = 0,
        unionData = self.unionData,
        cell = self, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tichu"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_kill_out", 
        terminal_state = 0,
        unionData = self.unionData,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tichu_1"), nil, 
    {
        terminal_name = "union_the_meeting_place_member_cell_kill_out", 
        terminal_state = 0,
        unionData = self.unionData,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:updateDraw()
end

function UnionTheMeetingPlaceMemberCell:onEnterTransitionFinish()
end

function UnionTheMeetingPlaceMemberCell:init(unionData,index)
    self.unionData = unionData
    if index ~= nil and index < self.max then
        self:onInit()
    end
    self:setContentSize(UnionTheMeetingPlaceMemberCell.__size)
	return self
end

function UnionTheMeetingPlaceMemberCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionTheMeetingPlaceMemberCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    cacher.freeRef("legion/legion_procedure_hall_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionTheMeetingPlaceMemberCell:clearUIInfo( ... )
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        local root = self.roots[2]
        local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
        local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
        local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
        local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
        local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
        local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
        local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
        local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
        local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
        local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
        local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
        local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
        local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
        local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
        local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
        local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
        local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
        local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
        local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
        local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
        local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
        if Image_double ~= nil then
            Image_double:setVisible(false)
        end
        if Image_xuanzhong ~= nil then
            Image_xuanzhong:setVisible(false)
        end
        if Image_3 ~= nil then
            Image_3:setVisible(false)
        end
        if Label_l_order_level ~= nil then 
            Label_l_order_level:setVisible(true)
            if Label_l_order_level._x then
                Label_l_order_level:setPositionX(Label_l_order_level._x)
            end
            Label_l_order_level:setString("")
        end
        if Label_name ~= nil then
            Label_name:setString("")
            Label_name:setVisible(true)
        end
        if Label_quantity ~= nil then
            Label_quantity:setString("")
        end
        if Label_shuxin ~= nil then
            Label_shuxin:setString("")
        end
        if Panel_prop ~= nil then
            Panel_prop:removeAllChildren(true)
            Panel_prop:removeBackGroundImage()
        end
        if Panel_kuang ~= nil then
            Panel_kuang:removeAllChildren(true)
            Panel_kuang:removeBackGroundImage()
        end
        if Panel_ditu ~= nil then
            Panel_ditu:removeAllChildren(true)
            Panel_ditu:removeBackGroundImage()
        end
        if Panel_star ~= nil then
            Panel_star:removeAllChildren(true)
            Panel_star:removeBackGroundImage()
        end
        if Panel_props_right_icon ~= nil then
            Panel_props_right_icon:removeAllChildren(true)
            Panel_props_right_icon:removeBackGroundImage()
        end
        if Panel_props_left_icon ~= nil then
            Panel_props_left_icon:removeAllChildren(true)
            Panel_props_left_icon:removeBackGroundImage()
        end
        if Panel_num ~= nil then
            Panel_num:removeAllChildren(true)
            Panel_num:removeBackGroundImage()
        end
        if Panel_4 ~= nil then
            Panel_4:removeAllChildren(true)
            Panel_4:removeBackGroundImage()
        end
        if Text_1 ~= nil then
            Text_1:setString("")
        end
    end
    local root = self.roots[1]
    local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
    if Panel_4 ~= nil then
        Panel_4:removeAllChildren(true)
    end
end

function UnionTheMeetingPlaceMemberCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[2])
    cacher.freeRef("legion/legion_procedure_hall_list.csb", self.roots[1])
end

function UnionTheMeetingPlaceMemberCell:createCell()
	local cell = UnionTheMeetingPlaceMemberCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
