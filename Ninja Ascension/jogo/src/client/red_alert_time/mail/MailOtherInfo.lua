-----------------------------
--邮件其他详情
-----------------------------
MailOtherInfo = class("MailOtherInfoClass", Window)

local mail_other_info_window_open_terminal = {
    _name = "mail_other_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(MailOtherInfo:new():init(params), fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

local mail_other_info_window_close_terminal = {
    _name = "mail_other_info_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("mail_other_info_translate_mail_reduction",0,0)
        fwin:close(fwin:find("MailOtherInfoClass"))
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_other_info_window_open_terminal)
state_machine.add(mail_other_info_window_close_terminal)
state_machine.init()

function MailOtherInfo:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._info = nil
    self._is_translation = false
    self._list_reward_posX = nil
	app.load("client.red_alert_time.cells.mail.mail_other_text_cell")
	app.load("client.red_alert_time.cells.mail.mail_other_reward_cell")

    local function init_mail_other_info_terminal()
        local mail_other_info_delete_terminal = {
            _name = "mail_other_info_delete",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mail_id = instance._mail_data.mail_id
                local mail_date_time = instance._mail_data.mail_date_time
				if tonumber(instance._mail_data.mail_Read) ~= 2 and tonumber(instance._mail_data.mail_item_type) == 1 then
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							checkRewardObtainDraw()
							for i, v in pairs(_ED.mail_system) do
								if tonumber(v.mail_id) == tonumber(mail_id) and tonumber(v.mail_date_time) == tonumber(mail_date_time) then
									_ED.mail_system[""..v.mail_id].mail_Read = "2"
								end
							end
							if fwin:find("MailInBoxClass") ~= nil then
								state_machine.excute("mail_in_box_update_draw",0,0)
                                state_machine.excute("notification_center_update", 0, "push_notification_mine_push")
                                state_machine.excute("notification_center_update", 0, "push_notification_mine_in_box_push")
							end
							if fwin:find("MailOutBoxClass") ~= nil then
								state_machine.excute("mail_out_box_update_draw",0,0)
							end
                            state_machine.excute("mail_update_mail_count_info", 0, "")
                            if tonumber(_ED.mail_system[""..mail_id].mail_box_type) == 0 then
    							if _ED.mould_function_push_info["8"] ~= nil then
    								if _ED.mould_function_push_info["8"].params ~= nil then
    									if zstring.tonumber(_ED.mould_function_push_info["8"].params) > 0 then
    										_ED.mould_function_push_info["8"].params = zstring.tonumber(_ED.mould_function_push_info["8"].params) - 1
    									end
    								end
    							end
                            end
                            -- state_machine.excute("main_window_update_userinfo", 0, nil)
                            state_machine.excute("main_window_update_gold_info", 0, nil)
                            state_machine.excute("main_window_update_fighting", 0, nil)
                            state_machine.excute("main_window_update_resource", 0, nil)
                            state_machine.excute("home_map_update_tanke_info", 0, nil)
                            
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:onUpdateDraw()
                            end
						end	
					end
					protocol_command.draw_attachment_in_mail.param_list = mail_id
					NetworkManager:register(protocol_command.draw_attachment_in_mail.code, nil, nil, nil, instance, responseCallback, false, nil)
				else
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if fwin:find("MailInBoxClass") ~= nil then
								state_machine.excute("mail_in_box_update_draw",0,0)
                                state_machine.excute("notification_center_update", 0, "push_notification_mine_push")
                                state_machine.excute("notification_center_update", 0, "push_notification_mine_in_box_push")
							end
							if fwin:find("MailOutBoxClass") ~= nil then
								state_machine.excute("mail_out_box_update_draw",0,0)
							end
                            state_machine.excute("mail_update_mail_count_info", 0, "")
							state_machine.excute("mail_other_info_window_close",0,0)
						end	
					end
					protocol_command.delete_mail.param_list = mail_id
					NetworkManager:register(protocol_command.delete_mail.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --邮件保存
        local mail_other_info_save_mail_terminal = {
            _name = "mail_other_info_save_mail",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("mail_save_the_box_update_draw", 0, nil)
						end
					end	
				end
                protocol_command.user_save_mail.param_list = "1".."\r\n".."0".."\r\n"..self._mail_data.mail_id
				NetworkManager:register(protocol_command.user_save_mail.code, nil, nil, nil, self, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --邮件翻译
        local mail_other_info_translate_mail_terminal = {
            _name = "mail_other_info_translate_mail",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                mailTranslation(self._mail_data)
                if instance._is_translation == false then
                    instance.old_mail_title = instance._mail_data.mail_title
                    instance.old_mail_dec = instance._mail_data.mail_dec
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --邮件翻译刷新
        local mail_other_info_translate_mail_update_terminal = {
            _name = "mail_other_info_translate_mail_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._mail_data = params
                if instance._is_translation == false then
                    instance._is_translation = true
                else
                    instance._is_translation = false
                    instance._mail_data.mail_title = instance.old_mail_title
                    instance._mail_data.mail_dec = instance.old_mail_dec
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --邮件翻译还原
        local mail_other_info_translate_mail_reduction_terminal = {
            _name = "mail_other_info_translate_mail_reduction",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.old_mail_title ~= nil and self.old_mail_title ~= "" then
                    self._mail_data.mail_title = self.old_mail_title
                end
                if self.old_mail_dec ~= nil and self.old_mail_dec ~= "" then
                    self._mail_data.mail_dec = self.old_mail_dec
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(mail_other_info_delete_terminal)
        state_machine.add(mail_other_info_save_mail_terminal)
        state_machine.add(mail_other_info_translate_mail_terminal)
        state_machine.add(mail_other_info_translate_mail_update_terminal)
		state_machine.add(mail_other_info_translate_mail_reduction_terminal)

        state_machine.init()
    end
    init_mail_other_info_terminal()
end

function MailOtherInfo:getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",getBaseGTM8Time(m_time))

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)

	local timeString = temp.year ..".".. m_month ..".".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec
    return timeString
end

function MailOtherInfo:onUpdateDraw(  )
    local root = self.roots[1]
    local Text_sent_mail = ccui.Helper:seekWidgetByName(root,"Text_sent_mail")
    local Text_mail_name = ccui.Helper:seekWidgetByName(root,"Text_mail_name")
    local Text_mail_time = ccui.Helper:seekWidgetByName(root,"Text_mail_time")
	local Panel_mail_icon = ccui.Helper:seekWidgetByName(root,"Panel_mail_icon")
	local ListView_mail_infor = ccui.Helper:seekWidgetByName(root,"ListView_mail_infor")
	ListView_mail_infor:jumpToTop()
    ListView_mail_infor:removeAllItems()
	local mail_dec = nil
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        if (zstring.tonumber(self._mail_data.mail_channel_id) == 1 and zstring.tonumber(self._mail_data.mail_channel_type) == 6) 
            or (zstring.tonumber(self._mail_data.mail_channel_id) == 5 and zstring.tonumber(self._mail_data.mail_channel_type) == 11)
            then
            fontName = ""
        end
    end
	if zstring.tonumber(self._mail_data.mail_channel_id) == 2 and zstring.tonumber(self._mail_data.mail_channel_type) ~= 27 then
		--邮件标题
		local mail_title = dms.string(dms["mail_content_info"],zstring.tonumber(self._mail_data.mail_channel_child_type),mail_content_info.mail_title)
		Text_mail_name:setString(mail_title)
		--邮件发件人
		local the_sender = dms.string(dms["mail_content_info"],zstring.tonumber(self._mail_data.mail_channel_child_type),mail_content_info.the_sender)
		if tonumber(self._mail_data.mail_channel_child_type) == 31 then
            local decInfo = zstring.split(self._mail_data.mail_dec, ",")
            Text_sent_mail:ignoreContentAdaptWithSize(false)
            Text_sent_mail:setContentSize(300, 30)
            local _richText1 = ccui.RichText:create()
            _richText1:ignoreContentAdaptWithSize(false)
            local re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, decInfo[1], config_res.font.font_name,23)
            _richText1:pushBackElement(re1)
            local re2 =ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, " "..string.format(red_alert_time_str[33],tonumber(decInfo[2])), config_res.font.font_name,23)
            _richText1:pushBackElement(re2)
            local re3 =ccui.RichElementText:create(1, cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]),255, " "..red_alert_time_str[258]..decInfo[3], config_res.font.font_name,23)
            _richText1:pushBackElement(re3)
            _richText1:setContentSize(cc.size(Text_sent_mail:getContentSize().width,Text_sent_mail:getContentSize().height))
            _richText1:setAnchorPoint(0,0.5)
            _richText1:setPosition(cc.p(-Text_sent_mail:getContentSize().width/2,Text_sent_mail:getContentSize().height/2))
            Text_sent_mail:setString("")
            Text_sent_mail:removeAllChildren(true)
            Text_sent_mail:addChild(_richText1)         -- 发件人
        else
            Text_sent_mail:setString(the_sender)
        end
        
		--邮件内容
		local content_of_email = dms.string(dms["mail_content_info"],zstring.tonumber(self._mail_data.mail_channel_child_type),mail_content_info.content_of_email)
		local data1 = ""
		local data2 = ""
		local data3 = ""
		if tonumber(self._mail_data.mail_channel_child_type) == 43 
            or tonumber(self._mail_data.mail_channel_child_type) == 53 
            or tonumber(self._mail_data.mail_channel_child_type) == 54 
            or tonumber(self._mail_data.mail_channel_child_type) == 68 
            or tonumber(self._mail_data.mail_channel_child_type) == 69 
            then
            local str = ""
            if self._mail_data.mail_dec ~= "" then
                local shopInfo = zstring.split(self._mail_data.mail_dec, "|")
                for i=1 ,#shopInfo do
                    local s_info = zstring.split(shopInfo[i], ",")
                    local name = dms.string(dms["ship_mould"], s_info[1], ship_mould.captain_name)
                    local quality = dms.int(dms["ship_mould"], s_info[1], ship_mould.ship_type)
                    if i == #shopInfo then
                        str = str.."%%|"..quality.."|"..name.."*"..s_info[3].."%%"
                    else
                        str = str.."%%|"..quality.."|"..name.."*"..s_info[3].."%%"..","
                    end
                end  
            end
            data1 = string.gsub(content_of_email, "!x@", str)
            mail_dec = data1
        elseif tonumber(self._mail_data.mail_channel_child_type) == 78 
            or tonumber(self._mail_data.mail_channel_child_type) == 75 
            then
            local contentInfo = zstring.split(self._mail_data.mail_dec, ",")
            data1 = string.gsub(content_of_email, "!y@", contentInfo[1])
            if contentInfo[2]~= nil and contentInfo[2] ~= "" then
                if tonumber(self._mail_data.mail_channel_child_type) == 78 then
                    data2 = string.gsub(data1, "!x@", contentInfo[2])
                else
                    data2 = string.gsub(data1, "!x@", exChangeNumToString(contentInfo[2]))
                end
                data1 = data2
            end
            mail_dec = data1
        elseif tonumber(self._mail_data.mail_channel_child_type) == 21
            or tonumber(self._mail_data.mail_channel_child_type) == 22 
            or tonumber(self._mail_data.mail_channel_child_type) == 23 
            then
            local contentInfo = zstring.split(self._mail_data.mail_dec, "|")
            if contentInfo[2]~= nil and contentInfo[2] ~= "" then
                data1 = string.gsub(content_of_email, "!x@", contentInfo[2])
            end
            if contentInfo[3]~= nil and contentInfo[3] ~= "" then
                data2 = string.gsub(data1, "!y@", contentInfo[3])
                data1 = data2
            end
            if contentInfo[4]~= nil and contentInfo[4] ~= "" then
                data3 = string.gsub(data1, "!z@", contentInfo[4])
                data1 = data3
            end
            mail_dec = data1
        elseif tonumber(self._mail_data.mail_channel_child_type) == 31      
            then
            local contentInfo = zstring.split(self._mail_data.mail_dec, ",")
            if contentInfo[4]~= nil and contentInfo[4] ~= "" then
                data1 = string.gsub(content_of_email, "!x@", contentInfo[4])
            end
            if contentInfo[5]~= nil and contentInfo[5] ~= "" then
                data2 = string.gsub(data1, "!y@", contentInfo[5])
                data1 = data2
            end
            mail_dec = data1
        elseif tonumber(self._mail_data.mail_channel_child_type) == 10 
            or tonumber(self._mail_data.mail_channel_child_type) == 9
            or tonumber(self._mail_data.mail_channel_child_type) == 47
            or tonumber(self._mail_data.mail_channel_child_type) == 49 
            or tonumber(self._mail_data.mail_channel_child_type) == 50  
            or tonumber(self._mail_data.mail_channel_child_type) == 59  
            or tonumber(self._mail_data.mail_channel_child_type) == 28  
            or tonumber(self._mail_data.mail_channel_child_type) == 25  
            then
            local contentInfo = zstring.split(self._mail_data.mail_dec, ",")
            if tonumber(self._mail_data.mail_channel_child_type) == 59 then
                data1 = string.gsub(content_of_email, "!x@", dms.string(dms["activity_param"],tonumber(contentInfo[1]),activity_param.name))
            else
                data1 = string.gsub(content_of_email, "!x@", contentInfo[1])
            end
            if contentInfo[2]~= nil and contentInfo[2] ~= "" then
                data2 = string.gsub(data1, "!y@", contentInfo[2])
                data1 = data2
            end
            if contentInfo[3]~= nil and contentInfo[3] ~= "" then
                data3 = string.gsub(data1, "!z@", contentInfo[3])
                data1 = data3
            end
            mail_dec = data1     
        elseif tonumber(self._mail_data.mail_channel_child_type) == 17 
            then
            contentInfo = zstring.split(self._mail_data.mail_dec, ",")
            data1 = string.gsub(content_of_email, "!x@", contentInfo[1])
            if contentInfo[2]~= nil and contentInfo[2] ~= "" then
                data2 = string.gsub(data1, "!y@", contentInfo[2])
                data1 = data2
            end
            mail_dec = data1
        elseif tonumber(self._mail_data.mail_channel_child_type) == 18
            or tonumber(self._mail_data.mail_channel_child_type) == 19
            then
            contentInfo = zstring.split(self._mail_data.mail_dec, "!")
            local propMoulds = dms.int(dms["prop_config"], 26, prop_config.param)
            local name = dms.string(dms["prop_mould"], propMoulds, prop_mould.prop_name)
            data1 = string.gsub(content_of_email, "!x@", name)
            if contentInfo[1]~= nil and contentInfo[1] ~= "" then
                data2 = string.gsub(data1, "!y@", contentInfo[1])
                data1 = data2
            end
            mail_dec = data1
        elseif tonumber(self._mail_data.mail_channel_child_type) == 55 then
            local contentInfo = zstring.split(self._mail_data.mail_dec, ",")
            data1 = string.gsub(content_of_email, "!x@", contentInfo[3])
            data2 = string.gsub(data1, "!y@", contentInfo[2])
            data1 = data2
            data3 = string.gsub(data1, "!z@", dms.string(dms["prop_mould"], contentInfo[1], prop_mould.prop_name))
            data1 = data3
            mail_dec = data1   
	    elseif tonumber(self._mail_data.mail_channel_child_type) == 56 then
            contentInfo = zstring.split(self._mail_data.mail_dec, "!")
            local name = dms.string(dms["activity_param"], contentInfo[1], activity_param.name)
            data1 = string.gsub(content_of_email, "!x@", name)
            if contentInfo[2]~= nil and contentInfo[2] ~= "" then
                data2 = string.gsub(data1, "!y@", contentInfo[2])
                data1 = data2
            end
            local str = ""
            for i,v in pairs(self._mail_data.mail_items) do
                if i < #self._mail_data.mail_items then
                    str = str..dms.string(dms["prop_mould"], tonumber(v.prop_item), prop_mould.prop_name)..","
                else
                    str = str..dms.string(dms["prop_mould"], tonumber(v.prop_item), prop_mould.prop_name)
                end
            end    
            data3 = string.gsub(data1, "!z@", str)
            data1 = data3
            mail_dec = data1  
        elseif tonumber(self._mail_data.mail_channel_child_type) == 90 then
            mail_dec = content_of_email
        elseif tonumber(self._mail_data.mail_channel_child_type) == 92
            or tonumber(self._mail_data.mail_channel_child_type) == 93
            or tonumber(self._mail_data.mail_channel_child_type) == 97
            or tonumber(self._mail_data.mail_channel_child_type) == 98
            or tonumber(self._mail_data.mail_channel_child_type) == 99
            then
            contentInfo = tonumber(self._mail_data.mail_dec)        -- 城市id
            local city_name = dms.string(dms["world_city_mould"], contentInfo, world_city_mould.name)
            data1 = string.gsub(content_of_email, "!x@", city_name)

            mail_dec = data1  
        else
        	local contentInfo = zstring.split(self._mail_data.mail_dec, "!")
        	if tonumber(self._mail_data.mail_channel_child_type) == 64 then
        		local npc_mould_id = dms.string(dms["rebel_haunt_mould"], contentInfo[1], rebel_haunt_mould.npc_mould_id) 
        		contentInfo[1] =  dms.string(dms["npc"], npc_mould_id, npc.npc_name) 
        	end 
            if tonumber(self._mail_data.mail_channel_child_type) == 45 then
                local additionData = zstring.split(dms.string(dms["rebel_haunt_config"], 7, rebel_haunt_config.param), "|")
                local additionInfo = zstring.split(additionData[2], ",")
                local talentData = zstring.split(dms.string(dms["talent_mould"], additionInfo[tonumber(contentInfo[1])], talent_mould.base_additional),",")
                contentInfo[1] = mail_tip_text[tonumber(contentInfo[1])+40] .. string.format(mail_tip_text[46],talentData[2])
            end
            data1 = string.gsub(content_of_email, "!x@", contentInfo[1])
			if contentInfo[2]~= nil and contentInfo[2] ~= "" then
				data2 = string.gsub(data1, "!y@", contentInfo[2])
				data1 = data2
			end
			if contentInfo[3]~= nil and contentInfo[3] ~= "" then
				data3 = string.gsub(data1, "!z@", contentInfo[3])
				data1 = data3
			end
			mail_dec = data1
        end
	else
        if zstring.tonumber(self._mail_data.mail_channel_type) == 27 then
            Text_sent_mail:setString(mail_tip_text[36])                           -- 发件人
        elseif zstring.tonumber(self._mail_data.mail_channel_id) == 5 and zstring.tonumber(self._mail_data.mail_channel_type) == 11 then  -- 军团邮件
            Text_sent_mail:removeAllChildren(true)
            Text_sent_mail:ignoreContentAdaptWithSize(false)
            Text_sent_mail:setContentSize(300, 30)
            local _richText1 = ccui.RichText:create()
            _richText1:ignoreContentAdaptWithSize(false)
            local re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[31][1], color_Type[31][2], color_Type[31][3]),255, mail_tip_text[39], config_res.font.font_name,23)
            _richText1:pushBackElement(re1)
            local re2 =ccui.RichElementText:create(1, cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]),255, mail_tip_text[40]..self._mail_data.mail_name, fontName,23)
            _richText1:pushBackElement(re2)
            _richText1:setContentSize(cc.size(Text_sent_mail:getContentSize().width,Text_sent_mail:getContentSize().height))
            _richText1:setAnchorPoint(0,0.5)
            _richText1:setPosition(cc.p(-Text_sent_mail:getContentSize().width/2,Text_sent_mail:getContentSize().height/2))
            Text_sent_mail:setString("")
            Text_sent_mail:addChild(_richText1)         -- 发件人
        else
            if fontName == "" then
	    	Text_sent_mail:removeAllChildren(true)
                Text_sent_mail:ignoreContentAdaptWithSize(false)
                Text_sent_mail:setContentSize(cc.size(300, 30))
                local _richText1 = ccui.RichText:create()
                _richText1:ignoreContentAdaptWithSize(false)
                local re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[31][1], color_Type[31][2], color_Type[31][3]),255, self._mail_data.mail_name, fontName,23)
                _richText1:pushBackElement(re1)
                local re2 =ccui.RichElementText:create(1, cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]),255, " "..friends_tip_string[12]..self._mail_data.mail_level.." "..red_alert_time_str[258]..self._mail_data.mail_vip_level, config_res.font.font_name,23)
                _richText1:pushBackElement(re2)
                _richText1:setContentSize(cc.size(Text_sent_mail:getContentSize().width,Text_sent_mail:getContentSize().height))
                _richText1:setAnchorPoint(0,0.5)
                _richText1:setPosition(cc.p(-Text_sent_mail:getContentSize().width/2,Text_sent_mail:getContentSize().height/2))
                Text_sent_mail:setString("")
                Text_sent_mail:addChild(_richText1) 
            else
                Text_sent_mail:setString(""..self._mail_data.mail_name.." "..friends_tip_string[12]..self._mail_data.mail_level.." "..red_alert_time_str[258]..self._mail_data.mail_vip_level)                           -- 发件人
            end
        end
		
		Text_mail_name:setString(self._mail_data.mail_title)     -- 标题
        Text_mail_name:setFontName(fontName)
        Text_mail_name:setFontSize(Text_mail_name:getFontSize())
		mail_dec = self._mail_data.mail_dec
	end
    Text_mail_time:setString(self:getTimeFormatYMDHMS(tonumber(self._mail_data.mail_date_time)/1000))    -- 时间
	local Button_mail_delete = ccui.Helper:seekWidgetByName(root,"Button_mail_delete")
	--添加文字
	local textCell = state_machine.excute("mail_other_text_cell", 0, {mail_dec,fontName})
    ListView_mail_infor:addChild(textCell)
    if __lua_project_id == __lua_project_pacific_rim then
    else
    	if tonumber(self._mail_data.mail_item_type) == 1 and #self._mail_data.mail_items > 0 then
    		--添加奖励
            local first_products_reward = {}
            local second_products_reward = {}
            for k,v in pairs(self._mail_data.mail_items) do
                if k <= 4 then
                    table.insert(first_products_reward, v)
                else
                    table.insert(second_products_reward, v)
                end
            end
    		local textCell = state_machine.excute("mail_other_reward_cell", 0, {first_products_reward, self._mail_data.mail_channel_child_type, self._mail_data.mail_dec}) 
    		ListView_mail_infor:addChild(textCell)
            if table.nums(second_products_reward) > 0 then
                local textCell = state_machine.excute("mail_other_reward_cell", 0, {second_products_reward, self._mail_data.mail_channel_child_type, self._mail_data.mail_dec}) 
                ListView_mail_infor:addChild(textCell)
            end
    	end
    end
	ListView_mail_infor:requestRefreshView()
	if tonumber(self._mail_data.mail_item_type) == 1 and #self._mail_data.mail_items > 0 then
		if tonumber(self._mail_data.mail_Read) == 2 then
			Button_mail_delete:setTitleText(mail_tip_text[28])
			ccui.Helper:seekWidgetByName(root,"Text_have_rec"):setVisible(true)
		else
			Button_mail_delete:setTitleText(arena_tip_text[25])
			ccui.Helper:seekWidgetByName(root,"Text_have_rec"):setVisible(false)
		end
	else
		Button_mail_delete:setTitleText(mail_tip_text[28])
		ccui.Helper:seekWidgetByName(root,"Text_have_rec"):setVisible(false)
	end

	--邮件保存没做，暂时屏蔽按钮
	ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
	-- if tonumber(self._mail_data.mail_channel_id) == 2 then
	-- 	ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
	-- else
	-- 	ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(true)
	-- end

    --翻译按钮
    local Image_mail_look_translate = ccui.Helper:seekWidgetByName(root,"Image_mail_look_translate")
    if Image_mail_look_translate ~= nil then
        if #_lua_release_language_param > 1 then
            if zstring.tonumber(self._mail_data.mail_channel_id) == 2 and zstring.tonumber(self._mail_data.mail_channel_type) ~= 27 then
                Image_mail_look_translate:setVisible(false)
            else
                if ((judgeChinese(self._mail_data.mail_dec) == true and m_curr_choose_language == "en")
                    or (judgeChinese(self._mail_data.mail_dec) == false and m_curr_choose_language == "zh_TW")
                    or (judgeChinese(self._mail_data.mail_title) == true and m_curr_choose_language == "en")
                    or (judgeChinese(self._mail_data.mail_title) == false and m_curr_choose_language == "zh_TW"))
                    then
                     Image_mail_look_translate:setVisible(true)
                else
                    if self._is_translation == true then
                        Image_mail_look_translate:setVisible(true)
                    else
                        Image_mail_look_translate:setVisible(false)
                    end
                end
            end
            if self._is_translation == false then
                Image_mail_look_translate:loadTexture("images/ui/icon/timg_2.png")
            else
                Image_mail_look_translate:loadTexture("images/ui/icon/timg_1.png")
            end
        else
            Image_mail_look_translate:setVisible(false)
        end
    end

    self:onUpdateReawrd()
end

function MailOtherInfo:onUpdateReawrd()
    local root = self.roots[1]
    local ListView_mail_reward = ccui.Helper:seekWidgetByName(root,"ListView_mail_reward")

    if ListView_mail_reward ~= nil then
        if tonumber(self._mail_data.mail_item_type) == 1 and #self._mail_data.mail_items > 0 then
            --添加奖励
            ListView_mail_reward:setVisible(true)
            ListView_mail_reward:removeAllItems()
            local reward = self._mail_data.mail_items
            if tonumber(self._mail_data.mail_channel_child_type) == 55 then         -- 红包特殊处理
                local contentInfo = zstring.split(self._mail_data.mail_dec, ",")
                reward = {}
                info = {
                    prop_item = tonumber(contentInfo[1]),
                    prop_type = 6,
                    item_value = tonumber(contentInfo[2]),
                }
                table.insert(reward, info)
            end

            local iemsMargin = ListView_mail_reward:getItemsMargin()
            local listViewSize = ListView_mail_reward:getContentSize()
            local nCoount = 0
            local tWidth = 0
            for k, v in pairs(reward) do
                local cell = createPropIconCell(v, true, true, true)
                ListView_mail_reward:addChild(cell)
                if nCoount > 0 then
                    tWidth = tWidth + iemsMargin
                end
                nCoount = nCoount + 1
            end
            ListView_mail_reward:requestRefreshView()
            tWidth = tWidth + PropsIconCell.__size.width * nCoount
            local viewWidth = listViewSize.width * ListView_mail_reward:getScaleX()
            if viewWidth > tWidth then
                ListView_mail_reward:setPositionX(self._list_reward_posX + viewWidth / 2 - tWidth / 2+20)
                ListView_mail_reward:setTouchEnabled(false)
            end
        else
            ListView_mail_reward:setVisible(false)
        end
    end
end

function MailOtherInfo:onEnterTransitionFinish()

end

function MailOtherInfo:onInit( )
    local csbItem = csb.createNode(config_csb.mail.mail_look_infor)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local ListView_mail_reward = ccui.Helper:seekWidgetByName(root,"ListView_mail_reward")
    if ListView_mail_reward ~= nil and self._list_reward_posX == nil then
        self._list_reward_posX = ListView_mail_reward:getPositionX()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_mail_close"), nil, 
    {
        terminal_name = "mail_other_info_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "mail_other_info_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 删除
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_delete"), nil, 
    {
        terminal_name = "mail_other_info_delete", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
	
	-- 举报
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_report"), nil, 
    {
        terminal_name = "", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
	
	-- 回复
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_reply"), nil, 
    {
        terminal_name = "write_an_email_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		name = self._mail_data.mail_name,
		title = mail_tip_text[14],
    }, nil, 1)
	
	-- 保存
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"), nil, 
    {
        terminal_name = "mail_other_info_save_mail", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --翻译
    local Image_mail_look_translate = ccui.Helper:seekWidgetByName(root,"Image_mail_look_translate")
    if Image_mail_look_translate ~= nil then
        fwin:addTouchEventListener(Image_mail_look_translate, nil, 
        {
            terminal_name = "mail_other_info_translate_mail", 
            terminal_state = 0, 
        }, nil, 1)
    end

    local Button_mail_report = ccui.Helper:seekWidgetByName(root,"Button_mail_report")
    local Button_mail_delete = ccui.Helper:seekWidgetByName(root,"Button_mail_delete")
    if Button_mail_report ~= nil then
	   Button_mail_report:setVisible(false)
    end
	if self._mail_data.mail_name ~= _ED.user_info.user_name 
        and (tonumber(self._mail_data.mail_channel_id) == 1 or tonumber(self._mail_data.mail_channel_id) == 5)
        and tonumber(self._mail_data.mail_box_type) == 0 then
		ccui.Helper:seekWidgetByName(root,"Button_mail_reply"):setVisible(true)
        if Button_mail_report ~= nil then
            Button_mail_delete:setPositionX(Button_mail_report:getPositionX())
        end
		-- ccui.Helper:seekWidgetByName(root,"Button_mail_report"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root,"Button_mail_reply"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root,"Button_mail_report"):setVisible(false)
	end

	--邮件保存没做，暂时屏蔽按钮
	ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
	self:onUpdateDraw()
end

function MailOtherInfo:init(params)   
    self._mail_data = params[1] 
	self:onInit()
    return self
end

function MailOtherInfo:onExit()
    state_machine.remove("mail_other_info_delete")
    state_machine.remove("mail_other_info_save_mail")
    state_machine.remove("mail_other_info_translate_mail")
    state_machine.remove("mail_other_info_translate_mail_update")
end
