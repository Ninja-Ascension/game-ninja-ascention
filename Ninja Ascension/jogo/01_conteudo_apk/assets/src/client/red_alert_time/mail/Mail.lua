-----------------------------
-- 邮件
-----------------------------
Mail = class("MailClass", Window)

--打开界面
local mail_window_open_terminal = {
	_name = "mail_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("MailClass") == nil then
			fwin:open(Mail:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local mail_window_close_terminal = {
	_name = "mail_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MailClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)

        cacher.removeAllTextures()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mail_window_open_terminal)
state_machine.add(mail_window_close_terminal)
state_machine.init()

function Mail:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._reportPanel = nil
    self._inbox = nil
    self._outbox = nil
    self._savethebox = nil
    self._otherPanel = nil
	self._mail_type = 0

	app.load("client.red_alert_time.mail.MailPresentation")
	app.load("client.red_alert_time.mail.MailPresentationInfo")
	app.load("client.red_alert_time.mail.MailRebelInvestigationInfo")
	app.load("client.red_alert_time.mail.MailOtherList")
	app.load("client.red_alert_time.mail.MailOtherInfo")
	app.load("client.red_alert_time.cells.mail.mail_cell")
	app.load("client.red_alert_time.cells.mail.mail_other_cell")
	app.load("client.red_alert_time.cells.mail.mail_load_cell")
	app.load("client.red_alert_time.mail.MailWriteAn")
	app.load("client.red_alert_time.mail.MailInBox")
	app.load("client.red_alert_time.mail.MailOutBox")
	app.load("client.red_alert_time.mail.MailSaveTheBox")

    local function init_mail_terminal()
        local mail_change_page_terminal = {
            _name = "mail_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local mail_type_assignment_terminal = {
            _name = "mail_type_assignment",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance._mail_type = tonumber(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 全部删除
        local mail_all_delete_terminal = {
            _name = "mail_all_delete",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local is_have_mail = false
                if instance._current_page == 1 then
                    if _ED.city_resource_battle_report ~= nil then
                        local info_list = _ED.city_resource_battle_report[tonumber(instance._mail_type)]
                        if info_list ~= nil and #info_list > 0 then
                            is_have_mail = true
                        end
                    end
                elseif instance._current_page == 2 then    
                    if _ED.mail_system ~= nil then
                        for i, v in pairs(_ED.mail_system) do
                            if tonumber(v.mail_box_type)== 0 then
                                is_have_mail = true
                            end 
                        end
                    end
                elseif instance._current_page == 3 then
                    if _ED.mail_system ~= nil then
                        for i, v in pairs(_ED.mail_system) do
                            if tonumber(v.mail_box_type)== 1 then
                                is_have_mail = true
                            end
                        end
                    end
                elseif instance._current_page == 4 then
                    if _ED.city_resource_battle_save_report ~= nil and table.nums(_ED.city_resource_battle_save_report) > 0 then
                       is_have_mail = true
                    end
                end
                if is_have_mail == false then
                    TipDlg.drawTextDailog(mail_tip_text[31])
                    return
                end
                local tip = ConfirmTip:new()
                tip:init(instance, instance.sureAllDelete, mail_tip_text[37])
                fwin:open(tip,fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 一键领取
        local mail_all_receive_terminal = {
            _name = "mail_all_receive",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if table.nums(_ED.mail_system) <= 0 or instance._current_page == 1 then
                	TipDlg.drawTextDailog(mail_tip_text[30])
                	return
                end
                local state = false
                for i, v in pairs(_ED.mail_system) do
					if tonumber(v.mail_item_type) == 1 and tonumber(v.mail_Read) ~= 2 then
						state = true
						break
					end
				end
				if state == false then
                	TipDlg.drawTextDailog(mail_tip_text[30])
                	return
                end
                local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local index = 0
						for i, v in pairs(_ED.mail_system) do
                            if tonumber(v.mail_item_type) == 1 and tonumber(v.mail_Read) ~= 2 then
    							_ED.mail_system[""..v.mail_id].mail_Read = "2"
                                index = index + 1
                            end
						end
						if fwin:find("MailInBoxClass")~= nil then
							state_machine.excute("mail_in_box_update_draw",0,0)
						end
						if fwin:find("MailOutBoxClass")~= nil then
							state_machine.excute("mail_out_box_update_draw",0,0)
						end
						if instance._current_page == 2 then
							if _ED.mould_function_push_info["8"] ~= nil then
								_ED.mould_function_push_info["8"].params = tonumber(_ED.mould_function_push_info["8"].params) - index
							end
						end
						checkRewardObtainDraw()
                        state_machine.excute("notification_center_update", 0, "push_notification_mine_push")
						state_machine.excute("notification_center_update", 0, "push_notification_mine_in_box_push")

                        state_machine.excute("mail_update_mail_count_info", 0, "")
                        state_machine.excute("main_window_update_gold_info", 0, nil)
                        state_machine.excute("main_window_update_fighting", 0, nil)
                        state_machine.excute("main_window_update_resource", 0, nil)
                        state_machine.excute("home_map_update_tanke_info", 0, nil)
					end	
                end
                NetworkManager:register(protocol_command.one_key_draw_attachment_in_mail.code, nil, nil, nil, self, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 全部已读
        local mail_all_read_terminal = {
            _name = "mail_all_read",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local is_have_mail = false
                if instance._current_page == 1 then
                    if _ED.city_resource_battle_report ~= nil then
                        local info_list = _ED.city_resource_battle_report[tonumber(instance._mail_type)]
                        if info_list ~= nil and #info_list > 0 then
                            is_have_mail = true
                        end
                    end
                elseif instance._current_page == 2 then    
                    if _ED.mail_system ~= nil then
                        for i, v in pairs(_ED.mail_system) do
                            if tonumber(v.mail_box_type)== 0 then
                                is_have_mail = true
                            end 
                        end
                    end
                elseif instance._current_page == 3 then
                    if _ED.mail_system ~= nil then
                        for i, v in pairs(_ED.mail_system) do
                            if tonumber(v.mail_box_type)== 1 then
                                is_have_mail = true
                            end
                        end
                    end
                elseif instance._current_page == 4 then
                    if _ED.city_resource_battle_save_report ~= nil and table.nums(_ED.city_resource_battle_save_report) > 0 then
                       is_have_mail = true
                    end
                end
                if is_have_mail == false then
                    TipDlg.drawTextDailog(mail_tip_text[31])
                    return
                end
                local tip = ConfirmTip:new()
                tip:init(instance, instance.sureAllRead, mail_tip_text[38])
                fwin:open(tip,fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local mail_update_mail_count_info_terminal = {
            _name = "mail_update_mail_count_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateMailInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(mail_change_page_terminal)
        state_machine.add(mail_all_delete_terminal)
        state_machine.add(mail_all_receive_terminal)
        state_machine.add(mail_all_read_terminal)
        state_machine.add(mail_type_assignment_terminal)
        state_machine.add(mail_update_mail_count_info_terminal)
        state_machine.init()
    end
    init_mail_terminal()
end

function Mail:sureAllDelete(sure_number)
    if sure_number ~= 0 then
        return
    end
    
    if tonumber(self._current_page) == 1 then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    _ED.city_resource_battle_report[tonumber(response.node._mail_type)] = {}
                    if tonumber(response.node._mail_type) == 200 or tonumber(response.node._mail_type) == 203 then
                        -- state_machine.excute("mail_presentation_attack_update_remove",0,{_datas = {times = cell._mail_data.time}})
                        state_machine.excute("mail_presentation_attack_update_all",0,0)
                    elseif tonumber(response.node._mail_type) == 1200 then
                        state_machine.excute("mail_presentation_defensive_update_all",0,0)
                    elseif tonumber(response.node._mail_type) == 10002 then
                        state_machine.excute("mail_presentation_investigation_update_all",0,0)
                    end
                    
                    if _ED.mould_function_push_info["7"] ~= nil then
                        local datas = zstring.split(_ED.mould_function_push_info["7"].params, ",")
                        local m_type = 0 
                        if tonumber(response.node._mail_type) == 200 then
                            m_type = 1
                        elseif tonumber(response.node._mail_type) == 1200 then
                            m_type = 2
                        elseif tonumber(response.node._mail_type) == 10002 then
                            m_type = 3
                        end
                        if datas[m_type] ~= nil then
                            datas[m_type] = "0"
                        end
                        _ED.mould_function_push_info["7"].params = ""..datas[1]..","..datas[2]..","..datas[3]
                    end
                    -- state_machine.excute("main_window_update_userinfo", 0, nil)
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_push")
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_in_box_push")
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_report_push")
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_report_attack")
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_report_defense")
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_report_scout")

                    state_machine.excute("mail_update_mail_count_info", 0, "")
                end
            end 
        end
        
        protocol_command.delete_all_message.param_list = self._mail_type
        NetworkManager:register(protocol_command.delete_all_message.code, nil, nil, nil, self, responseCallback, false, nil)
    elseif tonumber(self._current_page) == 4 then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    _ED.city_resource_battle_save_report = {}
                    if fwin:find("MailSaveTheBoxClass")~= nil then
                        state_machine.excute("mail_save_the_box_update_draw",0,0)
                    end
                end
            end
        end
        protocol_command.battlefield_report_save_delete.param_list = "-1"
        NetworkManager:register(protocol_command.battlefield_report_save_delete.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        if tonumber(self._current_page) == 2 then
            for i, v in pairs(_ED.mail_system) do
                if tonumber(v.mail_box_type)==0 and tonumber(v.mail_item_type) == 1 and tonumber(v.mail_Read) ~= 2 then
                    TipDlg.drawTextDailog(mail_tip_text[32])
                    return
                end 
            end
        end
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    if fwin:find("MailInBoxClass")~= nil then
                        state_machine.excute("mail_in_box_update_draw",0,0)
                    end
                    if fwin:find("MailOutBoxClass")~= nil then
                        state_machine.excute("mail_out_box_update_draw",0,0)
                    end
                    if response.node._current_page == 2 then
                        if _ED.mould_function_push_info["8"] ~= nil then
                            _ED.mould_function_push_info["8"].params = "0"
                        end
                    end
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_push")
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_in_box_push")
                    state_machine.excute("notification_center_update", 0, "push_notification_mine_report_push")

                    state_machine.excute("mail_update_mail_count_info", 0, "")
                end 
            end
        end
        protocol_command.delete_all_mail.param_list = tonumber(self._current_page)-2
        NetworkManager:register(protocol_command.delete_all_mail.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function Mail:sureAllRead(sure_number)
    if sure_number ~= 0 then
        return
    end

    if self._current_page == 1 then
        if _ED.city_resource_battle_report ~= nil then
            local info_list = _ED.city_resource_battle_report[tonumber(self._mail_type)]
            local isAllRead = true
            if info_list ~= nil then
                for i, v in pairs(info_list) do
                    if tonumber(v.read_type) == 0 then
                        isAllRead = false
                    end
                end
            end
            if isAllRead == true then
                TipDlg.drawTextDailog(mail_tip_text[35])
                return
            end
        end
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    if _ED.city_resource_battle_report[tonumber(response.node._mail_type)] ~= nil then
                        for i, v in pairs(_ED.city_resource_battle_report[tonumber(response.node._mail_type)]) do
                            v.read_type = 1
                        end
                    end
                    if tonumber(response.node._mail_type) == 200 or tonumber(response.node._mail_type) == 203 then
                        -- state_machine.excute("mail_presentation_attack_update_remove",0,{_datas = {times = cell._mail_data.time}})
                        state_machine.excute("mail_presentation_attack_update_all",0,0)
                    elseif tonumber(response.node._mail_type) == 1200 then
                        state_machine.excute("mail_presentation_defensive_update_all",0,0)
                    elseif tonumber(response.node._mail_type) == 10002 then
                        state_machine.excute("mail_presentation_investigation_update_all",0,0)
                    end
                    if _ED.mould_function_push_info["7"] ~= nil then
                        local datas = zstring.split(_ED.mould_function_push_info["7"].params, ",")
                        local m_type = 0 
                        if tonumber(response.node._mail_type) == 200 then
                            m_type = 1
                        elseif tonumber(response.node._mail_type) == 1200 then
                            m_type = 2
                        elseif tonumber(response.node._mail_type) == 10002 then
                            m_type = 3
                        end
                        if datas[m_type] ~= nil then
                            datas[m_type] = "0"
                        end
                        _ED.mould_function_push_info["7"].params = ""..datas[1]..","..datas[2]..","..datas[3]
                    end
                end
                checkRewardObtainDraw()
                -- state_machine.excute("main_window_update_userinfo", 0, nil)
                state_machine.excute("notification_center_update", 0, "push_notification_mine_push")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_in_box_push")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_report_push")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_report_attack")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_report_defense")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_report_scout")

                state_machine.excute("mail_update_mail_count_info", 0, "")
            end       
        end
        -- -- 邮件已读
        protocol_command.one_key_read_message.param_list = self._mail_type
        NetworkManager:register(protocol_command.one_key_read_message.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        local isAllRead = true
        for i, v in pairs(_ED.mail_system) do
            if tonumber(v.mail_box_type) == self._current_page-2 then
                if tonumber(v.mail_Read) == 0 then
                    isAllRead = false
                end
            end
        end
        if isAllRead == true then
            TipDlg.drawTextDailog(mail_tip_text[35])
            return
        end
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                for i, v in pairs(_ED.mail_system) do
                    if tonumber(v.mail_Read) == 0 then
                        v.mail_Read = "1"
                        if tonumber(v.mail_box_type) == 0 then
                            if #v.mail_items <= 0 then
                                if _ED.mould_function_push_info["8"] ~= nil then
                                    if _ED.mould_function_push_info["8"].params ~= nil then
                                        if zstring.tonumber(_ED.mould_function_push_info["8"].params) > 0 then
                                            _ED.mould_function_push_info["8"].params = zstring.tonumber(_ED.mould_function_push_info["8"].params) - 1
                                        end
                                    end
                                end
                            else
                                v.mail_Read = "1"
                            end
                        else
--                              if tonumber(v.mail_box_type) == 0 then
                                -- if _ED.mould_function_push_info["8"] ~= nil then
                                --  if _ED.mould_function_push_info["8"].params ~= nil then
                                --      if zstring.tonumber(_ED.mould_function_push_info["8"].params) > 0 then
                                --          _ED.mould_function_push_info["8"].params = zstring.tonumber(_ED.mould_function_push_info["8"].params) - 1
                                --      end
                                --  end
                                -- end
--                              end  
                        end
                    end
                end
                if fwin:find("MailInBoxClass") ~= nil then
                    state_machine.excute("mail_in_box_update_draw",0,0)
                end
                if fwin:find("MailOutBoxClass") ~= nil then
                    state_machine.excute("mail_out_box_update_draw",0,0)
                end
                state_machine.excute("notification_center_update", 0, "push_notification_mine_push")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_in_box_push")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_report_push")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_report_attack")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_report_defense")
                state_machine.excute("notification_center_update", 0, "push_notification_mine_report_scout")

                state_machine.excute("mail_update_mail_count_info", 0, "")
            end 
        end
        protocol_command.one_key_read_mail.param_list = tonumber(self._current_page)-2
        NetworkManager:register(protocol_command.one_key_read_mail.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function Mail:updateMailInfo()
    local root = self.roots[1]
    -- 邮件总数
    local Text_6_0 = ccui.Helper:seekWidgetByName(root, "Text_6_0")
    if Text_6_0 ~= nil then
        local current_count = 0
        if self._current_page == 1 then
            local report_type_tables = {200, 203, 1200, 10002}
            for k, v in pairs(report_type_tables) do
                if _ED.city_resource_battle_report[v] ~= nil then
                    current_count = current_count + #_ED.city_resource_battle_report[v]
                end
            end
        elseif self._current_page == 2 or self._current_page == 3 then
            for i, v in pairs(_ED.mail_system) do
                if self._current_page == 2 and tonumber(v.mail_box_type) == 0 then
                    current_count = current_count + 1
                elseif self._current_page == 3 and tonumber(v.mail_box_type) == 1 then
                    current_count = current_count + 1
                end
            end
        elseif self._current_page == 4 then
            if _ED.city_resource_battle_save_report ~= nil then
                current_count = #_ED.city_resource_battle_save_report
            end
        end
        Text_6_0:setString(current_count)
    end
    -- 未读邮件数
    local Text_6_0_0 = ccui.Helper:seekWidgetByName(root, "Text_6_0_0")
    if Text_6_0_0 ~= nil then
        if self._current_page == 1 then
            Text_6_0_0:setString(""..getMineTip(7))
        elseif self._current_page == 2 then
            Text_6_0_0:setString(""..getMineTip(8))
        else
            Text_6_0_0:setString("0")
        end
    end
    -- 邮箱上限
    local Text_6_1 = ccui.Helper:seekWidgetByName(root, "Text_6_1")
    if Text_6_1 ~= nil then
        local max_count_info = zstring.split(dms.string(dms["mail_config"], 2, mail_config.param), ",")
        local max_count = 0
        if self._current_page == 1 then
            max_count = tonumber(max_count_info[1])
        else
            max_count = tonumber(max_count_info[self._current_page + 2])
        end
        Text_6_1:setString(string.format(tipString_info_project_pacific_rim[8], max_count))
    end
end

function Mail:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_mail_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_mail_tab_box")
    local Button_presentation = ccui.Helper:seekWidgetByName(root, "Button_presentation")
    local Button_mail_inbox = ccui.Helper:seekWidgetByName(root, "Button_mail_inbox")
    local Button_mail_has_been_sent = ccui.Helper:seekWidgetByName(root, "Button_mail_has_been_sent")
    local Button_mail_saved = ccui.Helper:seekWidgetByName(root, "Button_mail_saved")
    if page == self._current_page then
        if page == 1 then
            Button_presentation:setHighlighted(true)
        elseif page == 2 then
            Button_mail_inbox:setHighlighted(true)
        elseif page == 3 then
            Button_mail_has_been_sent:setHighlighted(true)
        elseif page == 4 then
            Button_mail_saved:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_presentation:setHighlighted(false)
    Button_mail_inbox:setHighlighted(false)
    Button_mail_has_been_sent:setHighlighted(false)
    Button_mail_saved:setHighlighted(false)
    state_machine.excute("mail_presentation_hide", 0, nil)
    state_machine.excute("mail_in_box_hide", 0, nil)
    state_machine.excute("mail_out_box_hide", 0, nil)
    state_machine.excute("mail_save_the_box_hide", 0, nil)

    ccui.Helper:seekWidgetByName(root,"Button_sky_receive"):setTouchEnabled(true)
    ccui.Helper:seekWidgetByName(root,"Button_sky_receive"):setBright(true)
    ccui.Helper:seekWidgetByName(root,"Button_all_read"):setTouchEnabled(true)
    ccui.Helper:seekWidgetByName(root,"Button_all_read"):setBright(true)
    

    if page == 1 then
        Button_presentation:setHighlighted(true)
        if self._reportPanel == nil then
            self._reportPanel = state_machine.excute("mail_presentation_window_open", 0, {Panel_mail_tab_box})
        else
            state_machine.excute("mail_presentation_show", 0, nil)
        end
	elseif page == 2 then
		Button_mail_inbox:setHighlighted(true)
		if self._inbox == nil then
            self._inbox = state_machine.excute("mail_in_box_window_open", 0, {Panel_mail_tab_box})
        else
            state_machine.excute("mail_in_box_show", 0, nil)
        end
	elseif page == 3 then
		Button_mail_has_been_sent:setHighlighted(true)
		if self._outbox == nil then
            self._outbox = state_machine.excute("mail_out_box_window_open", 0, {Panel_mail_tab_box})
        else
            state_machine.excute("mail_out_box_show", 0, nil)
        end
        ccui.Helper:seekWidgetByName(root,"Button_sky_receive"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_sky_receive"):setBright(false)
    else
		Button_mail_saved:setHighlighted(true)
        if self._savethebox == nil then
            self._savethebox = state_machine.excute("mail_save_the_box_window_open", 0, {Panel_mail_tab_box})
        else
            state_machine.excute("mail_save_the_box_show", 0, nil)
        end
        ccui.Helper:seekWidgetByName(root,"Button_sky_receive"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_sky_receive"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_all_read"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_all_read"):setBright(false)
	end

    self:updateMailInfo()
end

function Mail:init()
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function Mail:onInit()
    local csbItem = csb.createNode(config_csb.mail.mail)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_close"), nil, 
    {
        terminal_name = "mail_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation"), nil, 
    {
        terminal_name = "mail_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_report_push",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_presentation"),
	_m_type = 7,
    _invoke = nil,
    _interval = 0.1,})
	

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_inbox"), nil, 
    {
        terminal_name = "mail_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_in_box_push",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_mail_inbox"),
	_m_type = 8,
    _invoke = nil,
    _interval = 0.1,})
	

   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_has_been_sent"), nil, 
    {
        terminal_name = "mail_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_saved"), nil, 
    {
        terminal_name = "mail_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_write_mail"), nil, 
    {
        terminal_name = "write_an_email_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_all_delete"), nil, 
    {
        terminal_name = "mail_all_delete", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sky_receive"), nil, 
    {
        terminal_name = "mail_all_receive", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_all_read"), nil, 
    {
        terminal_name = "mail_all_read", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
	
	if _ED.mail_system == nil or _ED.city_resource_battle_report == nil then
		local function responseCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil then
					if params ~= nil and params._datas ~= nil and params._datas.page ~= nil then
						self:changeSelectPage(tonumber(params.page))
					else
						self:changeSelectPage(1)
					end
				end
			end
		end
		_ED.mail_system_have_new = false
		NetworkManager:register(protocol_command.get_user_mail.code, nil, nil, nil, self, responseCallback, false, nil)
	else
		if params ~= nil and params._datas ~= nil and params._datas.page ~= nil then
			self:changeSelectPage(tonumber(params.page))
		else
			self:changeSelectPage(1)
		end
	end	
end

function Mail:onEnterTransitionFinish()
    
end


function Mail:onExit()
	state_machine.remove("mail_change_page")
    state_machine.remove("mail_all_receive")
    state_machine.remove("mail_all_delete")
    state_machine.remove("mail_all_read")
    state_machine.remove("mail_update_mail_count_info")
end

