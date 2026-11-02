--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅信息界面
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingPlaceInformation = class("UnionTheMeetingPlaceInformationClass", Window)

--打开界面
local union_the_meeting_place_information_open_terminal = {
    _name = "union_the_meeting_place_information_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local unionTheMeetingPlaceInformationWindow = fwin:find("UnionTheMeetingPlaceInformationClass")
        if unionTheMeetingPlaceInformationWindow ~= nil then
            return true
        end
        state_machine.lock("union_the_meeting_place_information_open", 0, "")
        return UnionTheMeetingPlaceInformation:createCell()
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_the_meeting_place_information_close_terminal = {
    _name = "union_the_meeting_place_information_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UnionTheMeetingPlaceInformation:closeCell()
        state_machine.excute("union_refresh_info", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_place_information_open_terminal)
state_machine.add(union_the_meeting_place_information_close_terminal)
state_machine.init()

function UnionTheMeetingPlaceInformation:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.red_alert.cells.union.union_the_meeting_place_notice_cell")
    app.load("client.red_alert.union.meeting.UnionTheMeetingCheck")
	app.load("client.utils.ConfirmTip")

	 -- Initialize union the meeting place information machine.
    local function init_union_the_meeting_place_information_terminal()
		-- 隐藏界面
        local union_the_meeting_place_information_hide_event_terminal = {
            _name = "union_the_meeting_place_information_hide_event",
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
		
		-- 显示界面
        local union_the_meeting_place_information_show_event_terminal = {
            _name = "union_the_meeting_place_information_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                instance:updateDraw()
                state_machine.excute("union_refresh_info", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_the_meeting_place_information_refresh_terminal = {
            _name = "union_the_meeting_place_information_refresh",
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
		-- 点击修改公告
		local union_the_meeting_place_information_change_announcement_terminal = {
            _name = "union_the_meeting_place_information_change_announcement",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
                    state_machine.excute("union_the_meeting_place_notice_open", 0, 0)
                else
                    TipDlg.drawTextDailog(tipStringInfo_union_str[68])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 点击解散军团
		local union_the_meeting_place_information_dismiss_union_terminal = {
            _name = "union_the_meeting_place_information_dismiss_union",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                 if tonumber(_ED.union.union_member_list_sum) > 10 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[30])
                    return
                end
                instance:quxSureTip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击打开审核
        local union_the_meeting_place_information_open_apply_info_terminal = {
            _name = "union_the_meeting_place_information_open_apply_info",
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
                if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
                    protocol_command.union_examine_list.param_list = _ED.union.union_info.union_id
                    NetworkManager:register(protocol_command.union_examine_list.code, nil, nil, nil, nil, responseCallback, false, nil)
                else
                    TipDlg.drawTextDailog(tipStringInfo_union_str[68])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_the_meeting_place_information_hide_event_terminal)
		state_machine.add(union_the_meeting_place_information_show_event_terminal)
		state_machine.add(union_the_meeting_place_information_refresh_terminal)
		state_machine.add(union_the_meeting_place_information_change_announcement_terminal)
		state_machine.add(union_the_meeting_place_information_dismiss_union_terminal)
        state_machine.add(union_the_meeting_place_information_open_apply_info_terminal)
        state_machine.init()
    end
    
    init_union_the_meeting_place_information_terminal()
end

function UnionTheMeetingPlaceInformation:onHide()
	self:setVisible(false)
end

function UnionTheMeetingPlaceInformation:onShow()
	self:setVisible(true)
end

function UnionTheMeetingPlaceInformation:quxSureTipCallBack(n)
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

function UnionTheMeetingPlaceInformation:quxSureTip()
    local tip = ConfirmTip:new()
    tip:init(self, self.quxSureTipCallBack, tipStringInfo_union_str[31])
    fwin:open(tip, fwin._view)
end 

function UnionTheMeetingPlaceInformation:updateDraw()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_1"):setString("".._ED.union.union_info.union_name)
    ccui.Helper:seekWidgetByName(root, "Text_87_lv"):setString("".._ED.union.union_info.union_grade)
    local maxMember = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxMember)
    ccui.Helper:seekWidgetByName(root, "Text_072_zl"):setString(_ED.union.union_info.members.."/"..maxMember)
    ccui.Helper:seekWidgetByName(root, "Text_nbgg"):setString(_ED.union.union_info.bulletin)
    ccui.Helper:seekWidgetByName(root, "Text_jdxy"):setString("             ".._ED.union.union_info.watchword)
    local Panel_legion_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_icon")
    Panel_legion_icon:setBackGroundImage("images/ui/quality/camp_".._ED.union.union_info.union_camp..".png")
    -- 申请加入推送
    local Image_push =  ccui.Helper:seekWidgetByName(root, "Image_push")
    Image_push:setVisible(false)
    -- if _ED.union.union_examine_list_sum ~= nil 
    --     and _ED.union.union_examine_list_sum ~= "" 
    --     and tonumber(_ED.union.union_examine_list_sum) ~= 0 
    --     then
    --     Image_push:setVisible(true)
    -- end
end

function UnionTheMeetingPlaceInformation:onInit()
	self:updateDraw()
end

function UnionTheMeetingPlaceInformation:onEnterTransitionFinish()
    local csbItem = csb.createNode(config_csb.legion.legion_procedure_hall_xinxi)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
        local check = ccui.Helper:seekWidgetByName(root, "Button_123_0")
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_apply",
        _widget = check,
        _invoke = nil,
        _interval = 0.5,})
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123_0"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_open_apply_info", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_change_announcement", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
        protocol_command.union_examine_list.param_list = _ED.union.union_info.union_id
        NetworkManager:register(protocol_command.union_examine_list.code, nil, nil, nil, nil, nil, false, nil)
    end

    self:init()
    state_machine.unlock("union_the_meeting_place_information_open", 0, "")
end

function UnionTheMeetingPlaceInformation:init()
	self:onInit()
	return self
end

function UnionTheMeetingPlaceInformation:onExit()
	state_machine.remove("union_the_meeting_place_information_hide_event")
	state_machine.remove("union_the_meeting_place_information_show_event")
	state_machine.remove("union_the_meeting_place_information_refresh")
	state_machine.remove("union_the_meeting_place_information_change_announcement")
	state_machine.remove("union_the_meeting_place_information_dismiss_union")
    state_machine.remove("union_the_meeting_place_information_open_apply_info")
end

function UnionTheMeetingPlaceInformation:createCell( ... )
    local cell = UnionTheMeetingPlaceInformation:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function UnionTheMeetingPlaceInformation:closeCell( ... )
    local unionTheMeetingPlaceInformationWindow = fwin:find("UnionTheMeetingPlaceInformationClass")
    if unionTheMeetingPlaceInformationWindow == nil then
        return
    end
    fwin:close(unionTheMeetingPlaceInformationWindow)
end