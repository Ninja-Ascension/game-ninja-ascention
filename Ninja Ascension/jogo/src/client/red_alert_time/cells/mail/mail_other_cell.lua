--------------------------------------------------------------------------------------------------------------
--  邮件cell
--------------------------------------------------------------------------------------------------------------
MailOtherCell = class("MailOtherCellClass", Window)
MailOtherCell.__size = nil
--创建cell
local mail_other_create_cell_terminal = {
    _name = "mail_other_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MailOtherCell:new()
        local index = params[1]
        local mail_data = params[2]
        local ntype = params[3]
        local isInvalid = params[4]
        cell:init(index, mail_data, ntype, isInvalid)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(mail_other_create_cell_terminal)
state_machine.init()

function MailOtherCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._mail_data = nil
    self._ntype = 0
    self._isInvalid = false
    
    local function init_mail_other_cell_terminal()
        local mail_other_cell_click_terminal = {
            _name = "mail_other_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                cell:setSelected()
				
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							for i, v in pairs(_ED.mail_system) do
                                if tonumber(v.mail_box_type) == 0 then
    								if tonumber(v.mail_id) == tonumber(cell._mail_data.mail_id) and tonumber(v.mail_date_time) == tonumber(cell._mail_data.mail_date_time) then
                                        if tonumber(v.mail_item_type) == 1 then --有奖励
                                            if tonumber(v.mail_Read) < 2 then
                                                if #v.mail_items <= 0 then
                                                    if _ED.mould_function_push_info["8"] ~= nil then
                                                        if _ED.mould_function_push_info["8"].params ~= nil then
                                                            if zstring.tonumber(_ED.mould_function_push_info["8"].params) > 0 then
                                                                _ED.mould_function_push_info["8"].params = zstring.tonumber(_ED.mould_function_push_info["8"].params) - 1
                                                            end
                                                        end
                                                    end
                                                    v.mail_Read = "2"
                                                else
                                                    v.mail_Read = "1"     
                                                end
                                            end
                                        else
                                            if tonumber(v.mail_Read) == 0 then
                                                v.mail_Read = "1"     
                                                if _ED.mould_function_push_info["8"] ~= nil then
                                                    if _ED.mould_function_push_info["8"].params ~= nil then
                                                        if zstring.tonumber(_ED.mould_function_push_info["8"].params) > 0 then
                                                            _ED.mould_function_push_info["8"].params = zstring.tonumber(_ED.mould_function_push_info["8"].params) - 1
                                                        end
                                                    end
                                                end
                                            end
                                        end 
    								end
                                end
							end
							cell:updateDraw()
							state_machine.excute("mail_other_info_window_open", 0, {cell._mail_data})

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
                if cell._isInvalid == true then
                else
                    protocol_command.user_read_mail.param_list = cell._mail_data.mail_id.."\r\n"..cell._mail_data.mail_box_type
                    NetworkManager:register(protocol_command.user_read_mail.code, nil, nil, nil, cell, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		state_machine.add(mail_other_cell_click_terminal)
        state_machine.init()
    end
    
    init_mail_other_cell_terminal()
end

function MailOtherCell:setSelected()
    local root = self.roots[1]
    local Image_line_icon = ccui.Helper:seekWidgetByName(root,"Image_line_icon")
    Image_line_icon:setVisible(false)
    local Image_line_icon_read = ccui.Helper:seekWidgetByName(root,"Image_line_icon_read")
    Image_line_icon_read:setVisible(true)
    local Image_mail_line = ccui.Helper:seekWidgetByName(root,"Image_mail_line")
    Image_mail_line:setVisible(false)
    local Image_mail_line_read = ccui.Helper:seekWidgetByName(root,"Image_mail_line_read")
    Image_mail_line_read:setVisible(true)
end

function MailOtherCell:getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",getBaseGTM8Time(m_time))

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)


	local timeString = temp.year ..".".. m_month ..".".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec


    return timeString
end

function MailOtherCell:updateDraw()
    local root = self.roots[1]
    local Image_line_icon = ccui.Helper:seekWidgetByName(root,"Image_line_icon")
    local Image_line_icon_read = ccui.Helper:seekWidgetByName(root,"Image_line_icon_read")
    local Text_mail_send_name = ccui.Helper:seekWidgetByName(root,"Text_mail_send_name")
    local Panel_mail_icon = ccui.Helper:seekWidgetByName(root,"Panel_mail_icon")
    local Text_mail_infor_t = ccui.Helper:seekWidgetByName(root,"Text_mail_infor_t")
    local Text_mail_infor_n = ccui.Helper:seekWidgetByName(root,"Text_mail_infor_n")
    local Text_mail_t = ccui.Helper:seekWidgetByName(root,"Text_mail_t")
    Text_mail_infor_n:setString("")
    Text_mail_infor_n:removeAllChildren(true)
    Text_mail_t:setString("")
    local Text_mail_time = ccui.Helper:seekWidgetByName(root,"Text_mail_time")
	local Image_reward = ccui.Helper:seekWidgetByName(root,"Image_reward")
    Panel_mail_icon:removeBackGroundImage()
	Text_mail_send_name:removeAllChildren(true)
    -- Image_reward:removeBackGroundImage()
    local fontSize = Text_mail_send_name:getFontSize()
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        if (zstring.tonumber(self._mail_data.mail_channel_id) == 1 and zstring.tonumber(self._mail_data.mail_channel_type) == 6) 
            or (zstring.tonumber(self._mail_data.mail_channel_id) == 5 and zstring.tonumber(self._mail_data.mail_channel_type) == 11)
            then
            fontName = ""
        end
    end
    Text_mail_infor_t:setFontName(fontName)
    Text_mail_infor_t:setFontSize(Text_mail_infor_t:getFontSize())
    Text_mail_infor_n:setFontName(fontName)
    Text_mail_infor_n:setFontSize(Text_mail_infor_n:getFontSize())

	Image_reward:setVisible(false)
	local image  = ""
	if tonumber(self._mail_data.mail_box_type) == 1 then
		image = "images/ui/share/world_implement_icon_13.png"
        ccui.Helper:seekWidgetByName(root,"Image_line_icon"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_line_icon_read"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Image_mail_line"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_mail_line_read"):setVisible(true)
	else
		if tonumber(self._mail_data.mail_Read) == 0 then
			image = "images/ui/share/world_implement_icon_10.png"
			ccui.Helper:seekWidgetByName(root,"Image_line_icon"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Image_line_icon_read"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_mail_line"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_mail_line_read"):setVisible(false)
		else
			image = "images/ui/share/world_implement_icon_9.png"
			ccui.Helper:seekWidgetByName(root,"Image_line_icon"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Image_line_icon_read"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_mail_line"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_mail_line_read"):setVisible(true)
		end
	end
    Panel_mail_icon:setBackGroundImage(image)         -- 邮件类型图标
    if tonumber(self._mail_data.mail_box_type) == 1 then
        Text_mail_t:setString(mail_tip_text[48])
    else
        Text_mail_t:setString(mail_tip_text[49])
    end
    if self._isInvalid == true then
        --邮件标题
        local mail_title = dms.string(dms["mail_content_info"], 10, mail_content_info.mail_title)
        Text_mail_infor_t:setString(mail_title)
        --邮件发件人
        local the_sender = dms.string(dms["mail_content_info"], 10, mail_content_info.the_sender)
        Text_mail_send_name:setString(the_sender)
        --邮件内容
        local content_of_email = dms.string(dms["mail_content_info"], 10, mail_content_info.content_of_email)
        local contentInfo = zstring.split(self._mail_data.param, "|")
        local data1 = ""
        local data2 = ""
        local data3 = ""

        -- param = "0|卢瑟福泰兹,,30,1551,83,28,0,4,0,60,60|5|"
        local attachedOne = zstring.split(contentInfo[2], ",")
        data1 = string.gsub(content_of_email, "!x@", attachedOne[1])
        data2 = string.gsub(data1, "!y@", attachedOne[5])
        data1 = data2
        data3 = string.gsub(data1, "!z@", attachedOne[6])
        data1 = data3
        content_of_email = data1

        Text_mail_infor_n:setString("")
        Text_mail_infor_n:removeAllChildren(true)
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        _richText2:setAnchorPoint(cc.p(0, 0.5))
        _richText2:setContentSize(cc.size(10000,20))
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        content_of_email, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)
        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        _richText2:setPositionX(0)
        _richText2:setPositionY(Text_mail_infor_n:getContentSize().height)
        Text_mail_infor_n:addChild(_richText2)

        if __lua_project_id == __lua_project_pacific_rim then
            Text_mail_time:setString(getLeaveTimeString(tonumber(self._mail_data.mail_date_time)/1000))
        else
            Text_mail_time:setString(self:getTimeFormatYMDHMS(tonumber(self._mail_data.mail_date_time)/1000))    -- 时间
        end
    else
    	if zstring.tonumber(self._mail_data.mail_channel_id) == 2 and zstring.tonumber(self._mail_data.mail_channel_type) ~= 27 then
    		--邮件标题
    		local mail_title = dms.string(dms["mail_content_info"],zstring.tonumber(self._mail_data.mail_channel_child_type),mail_content_info.mail_title)
    		Text_mail_infor_t:setString(mail_title)
    		--邮件发件人
    		local the_sender = dms.string(dms["mail_content_info"],zstring.tonumber(self._mail_data.mail_channel_child_type),mail_content_info.the_sender)
    		if tonumber(self._mail_data.mail_channel_child_type) == 31 then
                local decInfo = zstring.split(self._mail_data.mail_dec, ",")
                local _richText1 = ccui.RichText:create()
                _richText1:ignoreContentAdaptWithSize(false)
                local re1 =ccui.RichElementText:create(1, cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][3]),255, decInfo[1], config_res.font.font_name,fontSize)
                _richText1:pushBackElement(re1)
                local re2 =ccui.RichElementText:create(1, cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][3]),255, " "..string.format(red_alert_time_str[33],tonumber(decInfo[2])), config_res.font.font_name,fontSize)
                _richText1:pushBackElement(re2)
                local re3 =ccui.RichElementText:create(1, cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]),255, " "..red_alert_time_str[258]..decInfo[3], config_res.font.font_name,fontSize)
                _richText1:pushBackElement(re3)
                _richText1:setContentSize(cc.size(Text_mail_send_name:getContentSize().width,Text_mail_send_name:getContentSize().height))
                _richText1:setAnchorPoint(0,0.5)
                _richText1:setPosition(cc.p(-Text_mail_send_name:getContentSize().width/2,Text_mail_send_name:getContentSize().height/2))
                Text_mail_send_name:setString("")
                Text_mail_send_name:addChild(_richText1)         -- 发件人
            else
                Text_mail_send_name:setString(the_sender)
            end
    		--邮件内容
            local content_of_email = dms.string(dms["mail_content_info"],zstring.tonumber(self._mail_data.mail_channel_child_type),mail_content_info.content_of_email)
            local contentInfo = ""
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
                        local quality = dms.int(dms["ship_mould"], s_info[1], ship_mould.ship_type)+1
                        if i == #shopInfo then
                            str = str.."%|"..quality.."|"..name.."*"..s_info[3].."%"
                        else
                            str = str.."%|"..quality.."|"..name.."*"..s_info[3].."%"..","
                        end
                    end  
                end
                data1 = string.gsub(content_of_email, "!x@", str)
                data2 = string.gsub(data1, "/r/n", " ")
                content_of_email = data2
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
                content_of_email = data1
            elseif tonumber(self._mail_data.mail_channel_child_type) == 21
                or tonumber(self._mail_data.mail_channel_child_type) == 22 
                or tonumber(self._mail_data.mail_channel_child_type) == 23 
                then
                contentInfo = zstring.split(self._mail_data.mail_dec, "|")
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
                content_of_email = data1
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
                content_of_email = data1
            elseif tonumber(self._mail_data.mail_channel_child_type) == 10 
                or tonumber(self._mail_data.mail_channel_child_type) == 47
                or tonumber(self._mail_data.mail_channel_child_type) == 9
                or tonumber(self._mail_data.mail_channel_child_type) == 49
                or tonumber(self._mail_data.mail_channel_child_type) == 50
                or tonumber(self._mail_data.mail_channel_child_type) == 59
                or tonumber(self._mail_data.mail_channel_child_type) == 28
                or tonumber(self._mail_data.mail_channel_child_type) == 25
                then   
                contentInfo = zstring.split(self._mail_data.mail_dec, ",")
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
                content_of_email = data1
            elseif tonumber(self._mail_data.mail_channel_child_type) == 17 
                then
                contentInfo = zstring.split(self._mail_data.mail_dec, ",")
                data1 = string.gsub(content_of_email, "!x@", contentInfo[1])
                if contentInfo[2]~= nil and contentInfo[2] ~= "" then
                    data2 = string.gsub(data1, "!y@", contentInfo[2])
                    data1 = data2
                end
                content_of_email = data1
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
                content_of_email = data1
            elseif tonumber(self._mail_data.mail_channel_child_type) == 55 then
                local contentInfo = zstring.split(self._mail_data.mail_dec, ",")
                data1 = string.gsub(content_of_email, "!x@", contentInfo[3])
                data2 = string.gsub(data1, "!y@", contentInfo[2])
                data1 = data2
                data3 = string.gsub(data1, "!z@", dms.string(dms["prop_mould"], contentInfo[1], prop_mould.prop_name))
                data1 = data3
                content_of_email = data1 
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
                content_of_email = data1
            elseif tonumber(self._mail_data.mail_channel_child_type) == 90 then
            elseif tonumber(self._mail_data.mail_channel_child_type) == 92
                or tonumber(self._mail_data.mail_channel_child_type) == 93
                or tonumber(self._mail_data.mail_channel_child_type) == 97
                or tonumber(self._mail_data.mail_channel_child_type) == 98
                or tonumber(self._mail_data.mail_channel_child_type) == 99
                then
                contentInfo = tonumber(self._mail_data.mail_dec)        -- 城市id
                local city_name = dms.string(dms["world_city_mould"], contentInfo, world_city_mould.name)
                data1 = string.gsub(content_of_email, "!x@", city_name)

                content_of_email = data1
            else
                contentInfo = zstring.split(self._mail_data.mail_dec, "!")
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
                content_of_email = data1
                content_of_email = string.gsub(content_of_email, "/r/n", " ")
            end    
            Text_mail_infor_n:setString("")
            Text_mail_infor_n:removeAllChildren(true)
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)
            _richText2:setAnchorPoint(cc.p(0, 0.5))
            _richText2:setContentSize(cc.size(10000,20))
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            content_of_email, 
            cc.c3b(255, 255, 255),
            cc.c3b(255, 255, 255),
            0, 
            0, 
            config_res.font.font_name, 
            20,
            chat_rich_text_color)
            _richText2:formatTextExt()
            local rsize = _richText2:getContentSize()
            _richText2:setPositionX(0)
            _richText2:setPositionY(Text_mail_infor_n:getContentSize().height)
            Text_mail_infor_n:addChild(_richText2)

    		-- Text_mail_infor_n:setString(content_of_email)
        elseif zstring.tonumber(self._mail_data.mail_channel_id) == 5 and zstring.tonumber(self._mail_data.mail_channel_type) == 11 then  -- 军团邮件
            local _richText1 = ccui.RichText:create()
            _richText1:ignoreContentAdaptWithSize(false)
            local re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[31][1], color_Type[31][2], color_Type[31][3]),255, mail_tip_text[39], config_res.font.font_name,fontSize)
            _richText1:pushBackElement(re1)
            local re2 =ccui.RichElementText:create(1, cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]),255, mail_tip_text[40]..self._mail_data.mail_name, fontName,fontSize)
            _richText1:pushBackElement(re2)
            _richText1:setContentSize(cc.size(Text_mail_send_name:getContentSize().width,Text_mail_send_name:getContentSize().height))
            _richText1:setAnchorPoint(0,0.5)
            _richText1:setPosition(cc.p(-Text_mail_send_name:getContentSize().width/2,Text_mail_send_name:getContentSize().height/2))
            Text_mail_send_name:setString("")
            Text_mail_send_name:addChild(_richText1)         -- 发件人
            Text_mail_infor_t:setString(zstring.exchangeFrom(self._mail_data.mail_title))     -- 标题
            Text_mail_infor_n:setString(zstring.exchangeFrom(self._mail_data.mail_dec))       -- 描述
    	else
    		local _richText1 = ccui.RichText:create()
    		_richText1:ignoreContentAdaptWithSize(false)
    		local color1 = cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3])
    		local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
            local re1 = nil
            local re2 = nil
            local re3 = nil
            if zstring.tonumber(self._mail_data.mail_channel_type) == 27 then
                re1 =ccui.RichElementText:create(1, color2,255, mail_tip_text[36], config_res.font.font_name,fontSize)
            else
                re1 =ccui.RichElementText:create(1, color2,255, self._mail_data.mail_name, fontName,fontSize)
                re3 =ccui.RichElementText:create(1, color2,255, " "..friends_tip_string[12]..self._mail_data.mail_level, config_res.font.font_name,fontSize)
                re2 =ccui.RichElementText:create(1, color1,255, " "..red_alert_time_str[258]..self._mail_data.mail_vip_level, config_res.font.font_name,fontSize)
            end
            if re1~= nil then
        		_richText1:pushBackElement(re1)
            end
            if re3~= nil then
                _richText1:pushBackElement(re3)
            end 
            if re2 ~= nil then
                _richText1:pushBackElement(re2)
            end
    		_richText1:setContentSize(cc.size(Text_mail_send_name:getContentSize().width,Text_mail_send_name:getContentSize().height))
    		_richText1:setAnchorPoint(0,0.5)
    		_richText1:setPosition(cc.p(-Text_mail_send_name:getContentSize().width/2,Text_mail_send_name:getContentSize().height/2))
    		Text_mail_send_name:setString("")
    		Text_mail_send_name:addChild(_richText1)		 -- 发件人
    		-- Text_mail_send_name:setString(""..self._mail_data.mail_name..friends_tip_string[12]..self._mail_data.mail_level)		 -- 发件人

    		Text_mail_infor_t:setString(zstring.exchangeFrom(self._mail_data.mail_title))     -- 标题
            local mail_dec = string.gsub(self._mail_data.mail_dec, "/r/n", " ")
    		Text_mail_infor_n:setString(zstring.exchangeFrom(mail_dec))       -- 描述
    	end
        if __lua_project_id == __lua_project_pacific_rim then
            Text_mail_time:setString(getLeaveTimeString(tonumber(self._mail_data.mail_date_time)/1000, true))
        else
            Text_mail_time:setString(self:getTimeFormatYMDHMS(tonumber(self._mail_data.mail_date_time)/1000))    -- 时间
        end
        if tonumber(self._mail_data.mail_item_type) == 1 and #self._mail_data.mail_items > 0 then
            if tonumber(self._mail_data.mail_Read) ~= 2 then
                Image_reward:setVisible(true)
            end
        end
    end
end

function MailOtherCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.cells.mail.mail_cell, 2), "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    table.insert(self.roots, root) 

    if MailOtherCell.__size == nil then
        MailOtherCell.__size = root:getContentSize()
    end

    root:setSwallowTouches(false)
    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
                state_machine.excute("mail_other_cell_click", 0, {_datas = {cell = self}})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)

	self:updateDraw()
end

function MailOtherCell:onEnterTransitionFinish()

end

function MailOtherCell:init(index, mail_data, ntype, isInvalid)
    self._index = index
    self._mail_data = mail_data
    self._ntype = ntype
    self._isInvalid = isInvalid
    if index ~= nil and index <= 20 then
        self:onInit()
    end
    self:setContentSize(MailOtherCell.__size)
    return self
end

function MailOtherCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_mail_send_name = ccui.Helper:seekWidgetByName(root,"Text_mail_send_name")
    local Panel_mail_icon = ccui.Helper:seekWidgetByName(root,"Panel_mail_icon")
    local Text_mail_infor_t = ccui.Helper:seekWidgetByName(root,"Text_mail_infor_t")
    local Text_mail_infor_n = ccui.Helper:seekWidgetByName(root,"Text_mail_infor_n")
    local Text_mail_time = ccui.Helper:seekWidgetByName(root,"Text_mail_time")
    local Text_mail_t = ccui.Helper:seekWidgetByName(root,"Text_mail_t")
	if Text_mail_send_name ~= nil then
		Text_mail_send_name:removeAllChildren(true)
        Text_mail_infor_n:removeAllChildren(true)
		Text_mail_send_name:setString("")
		Text_mail_infor_t:setString("")
		Text_mail_infor_n:setString("")
		Text_mail_time:setString("")
		Panel_mail_icon:removeBackGroundImage()
        Text_mail_t:setString("")
	end
end

function MailOtherCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function MailOtherCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.mail.mail_cell, 2), root)
    root:removeFromParent(false)
    self.roots = {}
end

function MailOtherCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.mail.mail_cell, 2), self.roots[1])
end
