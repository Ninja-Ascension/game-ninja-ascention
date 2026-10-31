--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅信息界面
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlaceInformationNew = class("UnionTheMeetingPlaceInformationNewClass", Window)

--打开界面
local union_the_meeting_place_information_new_open_terminal = {
    _name = "union_the_meeting_place_information_new_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = UnionTheMeetingPlaceInformationNew:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_place_information_new_close_terminal = {
    _name = "union_the_meeting_place_information_new_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingPlaceInformationNew:closeCell()
        state_machine.excute("union_refresh_info", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_place_information_new_open_terminal)
state_machine.add(union_the_meeting_place_information_new_close_terminal)
state_machine.init()

function UnionTheMeetingPlaceInformationNew:ctor()
	self.super:ctor()
	self.roots = {}

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    app.load("client.l_digital.union.meeting.UnionTheMeetingCheck")
    app.load("client.l_digital.cells.union.union_the_meeting_place_notice_cell")
    app.load("client.l_digital.cells.union.union_logo_icon_cell")
    app.load("client.l_digital.cells.union.union_the_meeting_place_member_cell")
    app.load("client.l_digital.union.meeting.UnionTheMeetingChangeSign")
    app.load("client.l_digital.union.meeting.SmUnionChangeName")
	
	 -- Initialize union the meeting place information machine.
    local function init_union_the_meeting_place_information_new_terminal()
		-- 隐藏界面
        local union_the_meeting_place_information_new_hide_event_terminal = {
            _name = "union_the_meeting_place_information_new_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
				    instance:onHide()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_the_meeting_place_information_new_show_event_terminal = {
            _name = "union_the_meeting_place_information_new_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
    				instance:onShow()
                    instance:updateDraw()
                    state_machine.excute("union_refresh_info", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_the_meeting_place_information_new_refresh_terminal = {
            _name = "union_the_meeting_place_information_new_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateDraw()
                    state_machine.excute("union_refresh_info", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 点击修改军团宣言
		local union_the_meeting_place_information_new_change_declaration_terminal = {
            _name = "union_the_meeting_place_information_new_change_declaration",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                state_machine.excute("union_the_meeting_place_notice_open", 0, 1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 点击修改公告
		local union_the_meeting_place_information_new_change_announcement_terminal = {
            _name = "union_the_meeting_place_information_new_change_announcement",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
              
                state_machine.excute("union_the_meeting_place_notice_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 点击解散军团
		local union_the_meeting_place_information_new_dismiss_union_terminal = {
            _name = "union_the_meeting_place_information_new_dismiss_union",
            _init = function (terminal)
                app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                mcell:quxSureTip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 退出公会
        local union_the_meeting_place_information_new_union_exit_terminal = {
            _name = "union_the_meeting_place_information_new_union_exit",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_the_meeting_place_clean_all_data", 0, nil)
                    end
                end
                NetworkManager:register(protocol_command.union_exit.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击打开审核
        local union_the_meeting_place_information_new_open_apply_info_terminal = {
            _name = "union_the_meeting_place_information_new_open_apply_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_the_meeting_check_open", 0, 0)
                    end
                end
                NetworkManager:register(protocol_command.union_examine_list.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        -- 打开帮助
        local union_the_meeting_place_information_new_open_help_data_terminal = {
            _name = "union_the_meeting_place_information_new_open_help_data",
            _init = function (terminal)
                app.load("client.l_digital.union.meeting.SmUnionHelpWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_union_help_window_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开帮助
        local union_the_meeting_place_information_new_open_email_terminal = {
            _name = "union_the_meeting_place_information_new_open_email",
            _init = function (terminal)
                app.load("client.l_digital.union.meeting.SmUnionEmailWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = zstring.split(dms.string(dms["union_config"], 4, union_config.param), "|")
                local maxCount = zstring.split(info[tonumber(_ED.union.user_union_info.union_post)], ",")[2]
                if _ED.union.user_union_info.mail_times < tonumber(maxCount) then
                    state_machine.excute("sm_union_email_window_open", 0, 0)
                else
                    TipDlg.drawTextDailog(_new_interface_text[209])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开图标切换
        local union_the_meeting_place_information_new_open_iocn_set_terminal = {
            _name = "union_the_meeting_place_information_new_open_iocn_set",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_the_meeting_change_sign_open", 0, true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新图标
        local union_the_meeting_place_information_new_update_icon_terminal = {
            _name = "union_the_meeting_place_information_new_update_icon",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panelIcon = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_legion_icon")
                local cell = CnionLogoIconCell:createCell():init(_ED.union.union_info.union_kuang, _ED.union.union_info.union_icon,_ED.union.union_info.union_grade)
                panelIcon:removeAllChildren(true)
                panelIcon:addChild(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新图标
        local union_the_meeting_place_information_new_update_name_terminal = {
            _name = "union_the_meeting_place_information_new_update_name",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Text_1"):setString("".._ED.union.union_info.union_name.." Lv.".._ED.union.union_info.union_grade)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_the_meeting_place_information_new_update_email_info_terminal = {
            _name = "union_the_meeting_place_information_new_update_email_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union.user_union_info.union_post) == 1 
                    or tonumber(_ED.union.user_union_info.union_post) == 2 
                    then
                    local info = zstring.split(dms.string(dms["union_config"], 4, union_config.param), "|")
                    local maxCount = tonumber(zstring.split(info[tonumber(_ED.union.user_union_info.union_post)], ",")[2])
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_email_n"):setString(maxCount - tonumber(_ED.union.user_union_info.mail_times).."/"..maxCount)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_the_meeting_place_information_new_hide_event_terminal)
		state_machine.add(union_the_meeting_place_information_new_show_event_terminal)
		state_machine.add(union_the_meeting_place_information_new_refresh_terminal)
		state_machine.add(union_the_meeting_place_information_new_change_declaration_terminal)
		state_machine.add(union_the_meeting_place_information_new_change_announcement_terminal)
		state_machine.add(union_the_meeting_place_information_new_dismiss_union_terminal)
        state_machine.add(union_the_meeting_place_information_new_open_apply_info_terminal)
        state_machine.add(union_the_meeting_place_information_new_open_help_data_terminal)
        state_machine.add(union_the_meeting_place_information_new_open_email_terminal)
        state_machine.add(union_the_meeting_place_information_new_update_icon_terminal)
        state_machine.add(union_the_meeting_place_information_new_open_iocn_set_terminal)
        state_machine.add(union_the_meeting_place_information_new_update_name_terminal)
        state_machine.add(union_the_meeting_place_information_new_union_exit_terminal)
        state_machine.add(union_the_meeting_place_information_new_update_email_info_terminal)

        state_machine.init()
    end
    
    -- call func init union the meeting place information   machine.
    init_union_the_meeting_place_information_new_terminal()

end

function UnionTheMeetingPlaceInformationNew:onHide()
	self:setVisible(false)
end

function UnionTheMeetingPlaceInformationNew:onShow()
	self:setVisible(true)
end
function UnionTheMeetingPlaceInformationNew:quxSureTipCallBack(n)
    if n ~= 0 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("union_the_meeting_place_clean_all_data", 0, nil)
        end

    end
    NetworkManager:register(protocol_command.union_dismiss.code, nil, nil, nil, nil, responseCallback, false, nil)
end

function UnionTheMeetingPlaceInformationNew:quxSureTip()
    local tip = ConfirmTip:new()
    tip:init(self, self.quxSureTipCallBack, tipStringInfo_union_str[49])
    fwin:open(tip,fwin._ui)
end 

function UnionTheMeetingPlaceInformationNew:updateDraw()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_1"):setString("".._ED.union.union_info.union_name.." Lv.".._ED.union.union_info.union_grade)
    local maxMember = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxMember)
    --增加研究院能增加的人数
    local science_info = zstring.split(_ED.union_science_info,"|")
    local hall_technology = zstring.split(science_info[9],",")
    local cur_lv = hall_technology[1]
    local union_science_info = dms.searchs(dms["union_science_exp"], union_science_exp.group_id,9)
    local add_num = 0
    for i,v in ipairs(union_science_info) do
        if zstring.tonumber(v[union_science_exp.level]) == zstring.tonumber(cur_lv) then
            add_num = zstring.tonumber(v[union_science_exp.level_parameter])
        end
    end
    ccui.Helper:seekWidgetByName(root, "Text_072_zl"):setString(_ED.union.union_info.members.."/"..(zstring.tonumber(maxMember)+add_num))
    local maxProgress = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxExp)
    
    local panelIcon = ccui.Helper:seekWidgetByName(root, "Panel_legion_icon")
    local cell = CnionLogoIconCell:createCell():init(_ED.union.union_info.union_kuang, _ED.union.union_info.union_icon,_ED.union.union_info.union_grade)
    panelIcon:removeAllChildren(true)
    panelIcon:addChild(cell)


    if tonumber(_ED.union.union_member_list_sum) == nil then
        return
    end
    local leaderName = ""
    for i=1,tonumber(_ED.union.union_member_list_sum) do
        local unionData = _ED.union.union_member_list_info[i]
        if unionData ~= nil and tonumber(unionData.post) == 1 then
            leaderName = unionData.name
        end
    end
    ccui.Helper:seekWidgetByName(root, "Text_071_jd"):setString(leaderName)

    --工会id
    local Text_id_n = ccui.Helper:seekWidgetByName(root, "Text_id_n")
    Text_id_n:setString(_ED.union.union_info.union_id)

    --工会排名
    local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")
    Text_rank_n:setString(_ED.union.union_info.union_rank)

    if tonumber(_ED.union.user_union_info.union_post) == 1 then
        local info = zstring.split(dms.string(dms["union_config"], 4, union_config.param), "|")
        local maxCount = tonumber(zstring.split(info[tonumber(_ED.union.user_union_info.union_post)], ",")[2])
        ccui.Helper:seekWidgetByName(root, "Button_xiugai_2"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_all_email"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_email_n"):setString(maxCount - tonumber(_ED.union.user_union_info.mail_times).."/"..maxCount)
        ccui.Helper:seekWidgetByName(root, "Button_xiugai"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_tuichu"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_123_0"):setVisible(true)
    elseif tonumber(_ED.union.user_union_info.union_post) == 2 then
        local info = zstring.split(dms.string(dms["union_config"], 4, union_config.param), "|")
        local maxCount = zstring.split(info[tonumber(_ED.union.user_union_info.union_post)], ",")[2]
        ccui.Helper:seekWidgetByName(root, "Button_xiugai_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_all_email"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_email_n"):setString(maxCount - tonumber(_ED.union.user_union_info.mail_times).."/"..maxCount)
        ccui.Helper:seekWidgetByName(root, "Button_xiugai"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_tuichu"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_123_0"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Button_xiugai_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_all_email"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_email_n"):setString("")
        ccui.Helper:seekWidgetByName(root, "Button_xiugai"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_tuichu"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_123_0"):setVisible(false)
    end
end

function UnionTheMeetingPlaceInformationNew:onUpdate( dt )

end

function UnionTheMeetingPlaceInformationNew:onInit()
	local csbUnionTheMeetingPlaceInformationNewCell = csb.createNode("legion/legion_procedure_hall_xinxi_new.csb")
    local root = csbUnionTheMeetingPlaceInformationNewCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingPlaceInformationNewCell)

    --改图标
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xiugai"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_new_open_iocn_set", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --改名称
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xiugai_2"), nil, 
    {
        terminal_name = "sm_union_change_name_window_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123_0"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_new_dismiss_union", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuichu"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_new_union_exit", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_new_open_help_data", 
        terminal_state = 0,
        isPressedActionEnabled = false
    }, 
    nil, 0)
    --邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all_email"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_new_open_email", 
        terminal_state = 0,
        isPressedActionEnabled = false
    }, 
    nil, 0)
    self:updateDraw()
end

function UnionTheMeetingPlaceInformationNew:onEnterTransitionFinish()

end

function UnionTheMeetingPlaceInformationNew:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow   
	self:onInit()
	return self
end

function UnionTheMeetingPlaceInformationNew:onExit()
	state_machine.remove("union_the_meeting_place_information_new_hide_event")
	state_machine.remove("union_the_meeting_place_information_new_show_event")
	state_machine.remove("union_the_meeting_place_information_new_refresh")
	state_machine.remove("union_the_meeting_place_information_new_change_declaration")
	state_machine.remove("union_the_meeting_place_information_new_change_announcement")
	state_machine.remove("union_the_meeting_place_information_new_dismiss_union")
    state_machine.remove("union_the_meeting_place_information_new_open_apply_info")
    state_machine.remove("union_the_meeting_place_information_new_update_email_info")
end

function UnionTheMeetingPlaceInformationNew:createCell( ... )
    local cell = UnionTheMeetingPlaceInformationNew:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 1)
    return cell
end

function UnionTheMeetingPlaceInformationNew:closeCell( ... )
    local UnionTheMeetingPlaceInformationNewWindow = fwin:find("UnionTheMeetingPlaceInformationNewClass")
    if UnionTheMeetingPlaceInformationNewWindow == nil then
        return
    end
    fwin:close(UnionTheMeetingPlaceInformationNewWindow)
end