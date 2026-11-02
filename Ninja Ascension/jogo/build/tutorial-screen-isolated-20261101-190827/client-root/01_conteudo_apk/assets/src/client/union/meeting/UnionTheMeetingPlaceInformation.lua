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
        if unionTheMeetingPlaceInformationWindow ~= nil and unionTheMeetingPlaceInformationWindow:isVisible() == true then
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
    
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.meeting.UnionTheMeetingCheck")
        app.load("client.l_digital.cells.union.union_the_meeting_place_notice_cell")
        app.load("client.l_digital.cells.union.union_logo_icon_cell")
    else
        app.load("client.union.meeting.UnionTheMeetingCheck")
        app.load("client.cells.union.union_the_meeting_place_notice_cell")
        app.load("client.cells.union.union_logo_icon_cell")
    end
	
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
		-- 点击修改军团宣言
		local union_the_meeting_place_information_change_declaration_terminal = {
            _name = "union_the_meeting_place_information_change_declaration",
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
		local union_the_meeting_place_information_change_announcement_terminal = {
            _name = "union_the_meeting_place_information_change_announcement",
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
		local union_the_meeting_place_information_dismiss_union_terminal = {
            _name = "union_the_meeting_place_information_dismiss_union",
            _init = function (terminal)
                app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                 if tonumber(_ED.union.union_member_list_sum) > 10 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[30])
                    return
                end
                mcell:quxSureTip()
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("union_the_meeting_place_clean_all_data", 0, nil)
                --         fwin:cleanView(fwin._view)
                --         fwin:close(self)
                --         if fwin:find("HomeClass") == nil then
                --             state_machine.excute("menu_manager", 0, 
                --                 {
                --                     _datas = {
                --                         terminal_name = "menu_manager",     
                --                         next_terminal_name = "menu_show_home_page", 
                --                         current_button_name = "Button_home",
                --                         but_image = "Image_home",       
                --                         terminal_state = 0, 
                --                         isPressedActionEnabled = true
                --                     }
                --                 }
                --             )
                --         end
                --         state_machine.excute("menu_back_home_page", 0, "")
                --     end
                -- end
                -- if tonumber(_ED.union.union_member_list_sum) > 10 then
                --     TipDlg.drawTextDailog(tipStringInfo_union_str[30])
                --     return
                -- end
                -- NetworkManager:register(protocol_command.union_dismiss.code, nil, nil, nil, nil, responseCallback, true, nil)
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
                NetworkManager:register(protocol_command.union_examine_list.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_the_meeting_place_information_hide_event_terminal)
		state_machine.add(union_the_meeting_place_information_show_event_terminal)
		state_machine.add(union_the_meeting_place_information_refresh_terminal)
		state_machine.add(union_the_meeting_place_information_change_declaration_terminal)
		state_machine.add(union_the_meeting_place_information_change_announcement_terminal)
		state_machine.add(union_the_meeting_place_information_dismiss_union_terminal)
        state_machine.add(union_the_meeting_place_information_open_apply_info_terminal)
        state_machine.init()
    end
    
    -- call func init union the meeting place information   machine.
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
    NetworkManager:register(protocol_command.union_dismiss.code, nil, nil, nil, nil, responseCallback, true, nil)

end

function UnionTheMeetingPlaceInformation:quxSureTip()
    local tip = ConfirmTip:new()
    tip:init(self, self.quxSureTipCallBack, tipStringInfo_union_str[49])
    fwin:open(tip,fwin._ui)
end 

function UnionTheMeetingPlaceInformation:updateDraw()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_1"):setString("".._ED.union.union_info.union_name)
    ccui.Helper:seekWidgetByName(root, "Text_87_lv"):setString("".._ED.union.union_info.union_grade)
    local maxMember = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxMember)
    ccui.Helper:seekWidgetByName(root, "Text_072_zl"):setString(_ED.union.union_info.members.."/"..maxMember)
    ccui.Helper:seekWidgetByName(root, "Text_nbgg"):setString(_ED.union.union_info.bulletin)
    ccui.Helper:seekWidgetByName(root, "Text_jdxy"):setString(_ED.union.union_info.watchword)
    local maxProgress = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxExp)
    ccui.Helper:seekWidgetByName(root, "LoadingBar_58"):setPercent(_ED.union.union_info.union_contribution * 100/maxProgress)
    ccui.Helper:seekWidgetByName(root, "Text_loading_1"):setString(_ED.union.union_info.union_contribution.."/"..maxProgress)
    local panelIcon = ccui.Helper:seekWidgetByName(root, "Panel_legion_icon")
    local cell = CnionLogoIconCell:createCell():init(_ED.union.union_info.union_kuang, _ED.union.union_info.union_icon,_ED.union.union_info.union_grade)
    panelIcon:removeAllChildren(true)
    panelIcon:addChild(cell)
    if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
        ccui.Helper:seekWidgetByName(root, "Panel_juntuanzhang"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_juntuanzhang"):setVisible(false)
    end

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
end

function UnionTheMeetingPlaceInformation:onInit()
	self:updateDraw()
end

function UnionTheMeetingPlaceInformation:onEnterTransitionFinish()
    local csbUnionTheMeetingPlaceInformationCell = csb.createNode("legion/legion_procedure_hall_xinxi.csb")
    local root = csbUnionTheMeetingPlaceInformationCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTheMeetingPlaceInformationCell)


    if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
        local check = ccui.Helper:seekWidgetByName(root, "Button_123")
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_check",
        _widget = check,
        _invoke = nil,
        _interval = 0.5,})
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_open_apply_info", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123_0"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_dismiss_union", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_change_announcement", 
        terminal_state = 0,
        isPressedActionEnabled = false
    }, 
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_1_0"), nil, 
    {
        terminal_name = "union_the_meeting_place_information_change_declaration", 
        terminal_state = 0,
        isPressedActionEnabled = false
    }, 
    nil, 0)

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
	state_machine.remove("union_the_meeting_place_information_change_declaration")
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