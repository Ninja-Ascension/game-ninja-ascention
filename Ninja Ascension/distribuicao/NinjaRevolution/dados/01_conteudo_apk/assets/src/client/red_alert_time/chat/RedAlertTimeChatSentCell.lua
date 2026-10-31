--------------------------------------------------------------------------------------------------------------
--  说明：聊天输入cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeChatSentCell = class("RedAlertTimeChatSentCellClass", Window)
RedAlertTimeChatSentCell.__size = nil
--创建cell
local red_alert_time_chat_sent_create_cell_terminal = {
    _name = "red_alert_time_chat_sent_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeChatSentCell:new()
        cell:init()
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_chat_sent_create_cell_terminal)
state_machine.init()

function RedAlertTimeChatSentCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.voice_text = nil
	self.is_voice = false
	--当前页面 0：系统；1：世界；2：军团；3:私聊 4 阵营 5 GM 7 敌军来袭弹幕 8 敌军来袭聊天
    self.send_type = {1,4,3,4,0,5,9,9}
	self.page_index = 1
	
	self.TextFields = nil
    self.Text_field = nil
	self.textFieldsPointX = nil
    self.len_size = 0
	self.len_size_two = 0
    self.textFieldsData = ""
	self.nameFieldsData = ""

    self._is_init = true
	
    self._show_face_posX = 0
    self._hide_face_posX = 0
    self._is_show_text = true

    self.recording = 0

    self.cursor_name = nil

    self._Image_face_arrow_down = nil
    self._Image_face_arrow_up = nil

    self._ScrollView_face = nil
    self.scroll_view_poy = 0
    self.scroll_view_height = 0

    app.load("client.red_alert_time.chat.ChatFriendWindow")
	
	 -- Initialize chat_sent state machine.
    local function init_chat_sent_terminal()
        -- 播放隐藏动画
        local red_alert_time_chat_sent_cell_window_close_action_terminal = {
            _name = "red_alert_time_chat_sent_cell_window_close_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("red_alert_time_chat_sent_cell_window_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        -- 发送消息
        local red_alert_time_chat_sent_cell_message_terminal = {
            _name = "red_alert_time_chat_sent_cell_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(237) == true then
                    return
                end 
                instance:SendInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示表情
        local red_alert_time_chat_sent_cell_face_show_terminal = {
            _name = "red_alert_time_chat_sent_cell_face_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onFaceShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --隐藏表情
        local red_alert_time_chat_sent_cell_face_hide_terminal = {
            _name = "red_alert_time_chat_sent_cell_face_hide",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onFaceHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 添加表情
        local red_alert_time_chat_sent_cell_add_image_terminal = {
            _name = "red_alert_time_chat_sent_cell_add_image",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.excute("red_alert_time_chat_sent_cell_face_hide", 0, nil)
                if instance ~= nil and instance.roots ~= nil then
                    local TextField_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1")
                    local str = TextField_1:getString()
                    TextField_1:setString(str .. "/&|/"..tonumber(params)+100 .."|")
					local str2=string.gsub(TextField_1:getString(), expression_onversion[tonumber(params)][1], expression_onversion[tonumber(params)][2])
					TextField_1:setString(str2)
                    local editChild = TextField_1:getChildByName("editName")
                    if editChild ~= nil then 
                        editChild:setText(str .. "/&|/"..tonumber(params)+100 .."|")
						local str3=string.gsub(editChild:getText(), expression_onversion[tonumber(params)][1], expression_onversion[tonumber(params)][2])
						editChild:setText(str3)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--设置发送页
		local red_alert_time_chat_sent_cell_instal_page_terminal = {
            _name = "red_alert_time_chat_sent_cell_instal_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.page_index = tonumber(params)
                if _ED._chats_text_info[tonumber(instance.page_index)] ~= nil 
                    and (_ED._chats_text_info[tonumber(instance.page_index)]._info ~=nil or _ED._chats_text_info[tonumber(instance.page_index)]._info ~="") 
                    then
                    ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1"):setString(_ED._chats_text_info[tonumber(instance.page_index)]._info)
                else
                    ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1"):setString("")
                end    
                --print("_ED._private_chat_text_info==".._ED._private_chat_text_info)
                ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name"):setString(_ED._private_chat_text_info)

				if instance.page_index == 4 then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_private_chat"):setVisible(true)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_private_chat"):setVisible(false)
				end
                local root = instance.roots[1]
                local Button_face = ccui.Helper:seekWidgetByName(root, "Button_face")
                local Button_barrage_on = ccui.Helper:seekWidgetByName(root, "Button_barrage_on")
                local Button_share = ccui.Helper:seekWidgetByName(root, "Button_share")
                if instance.page_index == 7 or instance.page_index == 8 then
                    Button_face:setVisible(false)
                    self.Panel_textfield:setPositionX(instance._hide_face_posX)
                else
                    Button_face:setVisible(true)
                    self.Panel_textfield:setPositionX(instance._show_face_posX)
                end
                if instance.page_index == 7 then
                    Button_share:setVisible(false)
                    Button_barrage_on:setVisible(true)
                else
                    Button_share:setVisible(true)
                    Button_barrage_on:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --记录内容
        local red_alert_time_chat_sent_cell_record_the_contents_terminal = {
            _name = "red_alert_time_chat_sent_cell_record_the_contents",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED._chats_text_info[tonumber(instance.page_index)] = {}
                _ED._chats_text_info[tonumber(instance.page_index)]._info = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1"):getString()
                if tonumber(instance.page_index) == 4 then
                    _ED._private_chat_text_info = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name"):getString()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		--设置私聊内容
		local red_alert_time_chat_sent_cell_private_chat_terminal = {
            _name = "red_alert_time_chat_sent_cell_private_chat",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local TextField_name = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name")
                TextField_name:setString(params.user_name)
                _ED._private_chat_text_info = params.user_name
                local editName = TextField_name:getChildByName("editName")
                if editName ~= nil then
                    editName:setText(params.user_name)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 开关弹幕
        local red_alert_time_chat_sent_cell_switch_show_text_terminal = {
            _name = "red_alert_time_chat_sent_cell_switch_show_text",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._is_show_text = not instance._is_show_text
                state_machine.excute("enemy_strike_fight_switch_show_text", 0, instance._is_show_text)
                state_machine.excute("enemy_strike_challge_switch_show_text", 0, instance._is_show_text)
                local Button_barrage_on = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_barrage_on")
                local Button_text_barrage_on = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_text_barrage_on")
                if instance._is_show_text == true then
                    Button_barrage_on:setTitleText(red_alert_time_str[228])
                    Button_barrage_on:setHighlighted(false)
                    Button_barrage_on:loadTexturePressed("images/ui/share/button_share_3.png")
                else
                    Button_barrage_on:setTitleText(red_alert_time_str[229])
                    Button_barrage_on:setHighlighted(true)
                    Button_barrage_on:loadTexturePressed("images/ui/share/button_share_1.png")
                end
                if Button_text_barrage_on ~= nil then
                    Button_text_barrage_on:setString(Button_barrage_on:getTitleText())
                    Button_barrage_on:setTitleText("")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_chat_sent_cell_window_close_action_terminal)
        state_machine.add(red_alert_time_chat_sent_cell_message_terminal)
        state_machine.add(red_alert_time_chat_sent_cell_face_show_terminal)
        state_machine.add(red_alert_time_chat_sent_cell_face_hide_terminal)
        state_machine.add(red_alert_time_chat_sent_cell_add_image_terminal)
        state_machine.add(red_alert_time_chat_sent_cell_instal_page_terminal)
        state_machine.add(red_alert_time_chat_sent_cell_private_chat_terminal)
        state_machine.add(red_alert_time_chat_sent_cell_switch_show_text_terminal)
        state_machine.add(red_alert_time_chat_sent_cell_record_the_contents_terminal)

        state_machine.init()
    end
   
    init_chat_sent_terminal()

end

--显示界面
function RedAlertTimeChatSentCell:onShow()
	self:setVisible(true)
end

--隐藏界面
function RedAlertTimeChatSentCell:onHide()
	self:setVisible(false)
end

--显示表情
function RedAlertTimeChatSentCell:onFaceShow()
    self:onUpdateDrawPic()
    local root = self.roots[1]
    local Panel_face = ccui.Helper:seekWidgetByName(root, "Panel_face")
    Panel_face:setVisible(true)
    self.actions[1]:play("face_window_open", false)
end

--隐藏表情
function RedAlertTimeChatSentCell:onFaceHide()
    self.actions[1]:play("face_window_close", false)
end

function RedAlertTimeChatSentCell:SendInfo()
    local root = self.roots[1]
    if NetworkAdaptor.socketIsOpen() == false then 
        NetworkAdaptor.intSocket()
    end
    if _ED._chat_previous_info[self.page_index] ~= nil then
        local name = ccui.Helper:seekWidgetByName(root, "TextField_name"):getString()
        if ccui.Helper:seekWidgetByName(root, "TextField_1"):getString()..name == _ED._chat_previous_info[self.page_index].info 
            and _ED._chat_text_times_info > 0  then
            TipDlg.drawTextDailog(chat_sent_string[14])
            return
        end
    else
        _ED._chat_previous_info[self.page_index] = {}
    end
    if self.page_index == 4 then
        local function responseSendMessageCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    _ED._chat_text_times_info = os.time() + self.recording
                    _ED._chat_previous_info[self.page_index].info = ccui.Helper:seekWidgetByName(root, "TextField_1"):getString()..self.send_user_data.user_name
                    response.node:detachWithIME()
                    self.send_user_data = nil 
                end
            end
        end

        local text = ccui.Helper:seekWidgetByName(root, "TextField_1")
        local str = nil
		-- if self.voice_text ~= nil and self.voice_text~="" then
            -- str = self.voice_text
		-- else
			str = zstring.exchangeTo(text:getString())
		-- end
		for i=1,#expression_onversion do
			local str2=string.gsub(str, expression_onversion[i][2], expression_onversion[i][1])
			str = str2
		end
					
        local length = zstring.utfstrlenServer(str)
        
        if verifySupportLanguage(_lua_release_language_en) == true then
        else
            -- if length > 100 then
            --     TipDlg.drawTextDailog(chat_sent_string[5])
            --     self.voice_text = nil
            --     self:detachWithIME()
            --     return
            -- end
        end
        -- if self.send_user_data == nil then
		local text2 = ccui.Helper:seekWidgetByName(root, "TextField_name")
		local name = zstring.exchangeTo(text2:getString())
		if name == "" or name == nil then
			TipDlg.drawTextDailog(chat_sent_string[7])
			self.voice_text = nil
			return
		else
			self.send_user_data = {}
			self.send_user_data.user_id = "-1"
			self.send_user_data.user_name = name
		end
        -- end
        local textData = string.gsub(text:getString(), " ", "")
        if textData ~= "" then
            if self:filter_spec_chars(str) == false then
                TipDlg.drawTextDailog(chat_sent_string[16])
            else
                protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. self.send_user_data.user_id.."\r\n"..self.send_user_data.user_name
                NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                -- NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                -- responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
            end
        else
            -- if self.voice_text ~= nil and self.voice_text~="" then
                -- protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. self.send_user_data.user_id.."\r\n"..self.send_user_data.user_name
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                -- self.voice_text = nil
            -- else
                TipDlg.drawTextDailog(chat_sent_string[2])
            -- end
        end
    else
        local function responseSendMessageCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    _ED._chat_text_times_info = os.time() + self.recording
                    _ED._chat_previous_info[self.page_index].info = ccui.Helper:seekWidgetByName(root, "TextField_1"):getString()
                    response.node:detachWithIME()
                end
            end
        end

        local text = ccui.Helper:seekWidgetByName(root, "TextField_1")
		local str = nil
		if self.voice_text ~= nil and self.voice_text~="" then
			str = self.voice_text
		else
			str = zstring.exchangeTo(text:getString())
		end
		for i=1,#expression_onversion do
			local str2=string.gsub(str, expression_onversion[i][2], expression_onversion[i][1])
			str = str2
		end
        local length = zstring.utfstrlenServer(str)
        
        if verifySupportLanguage(_lua_release_language_en) == true then
        else
            -- if length > 180 then
            --     TipDlg.drawTextDailog(chat_sent_string[5])
            --     self.voice_text = nil
            --     self:detachWithIME()
            --     return
            -- end
        end
        if self.send_type[self.page_index] == 2 then
            if _ED.union == nil or _ED.union.user_union_info == nil
                or (_ED.union ~= nil 
                and _ED.union.user_union_info ~= nil 
                and zstring.tonumber(_ED.union.user_union_info.union_id) == 0) then
                TipDlg.drawTextDailog(red_alert_all_str[177])
                self.voice_text = nil
                return
            end
        end
        local textData = string.gsub(text:getString(), " ", "")
        if textData ~= "" then
            if self:filter_spec_chars(str) == false then
                TipDlg.drawTextDailog(chat_sent_string[16])
            else
                protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. "0"
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
            end
        else
            -- if self.voice_text ~= nil and self.voice_text~="" then
                -- protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. "0"
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                -- self.voice_text = nil
            -- else
                TipDlg.drawTextDailog(chat_sent_string[2])
            -- end
        end
    end
end

function RedAlertTimeChatSentCell:filter_spec_chars(s)  
    local ss = {}  
    local isSpecial = true
    local index = 0
    for k = 1, #s do  
        local c = string.byte(s,k)  
        if c == 37 then
            index = index + 1
        end
    --     if not c then break end  
    --     if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
    --         table.insert(ss, string.char(c))  
    --     elseif c>=228 and c<=233 then  
    --         local c1 = string.byte(s,k+1)  
    --         local c2 = string.byte(s,k+2)  
    --         if c1 and c2 then  
    --             local a1,a2,a3,a4 = 128,191,128,191  
    --             if c == 228 then a1 = 184  
    --             elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
    --             end  
    --             if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
    --                 k = k + 2  
    --                 table.insert(ss, string.char(c,c1,c2))  
    --             end  
    --         end  
    --     end  
    end  
    if index > 1 then
        isSpecial = false
    else
        isSpecial = true  
    end
    -- return table.concat(ss)  
    return isSpecial
end 

function RedAlertTimeChatSentCell:detachWithIME()
    local root = self.roots[1]
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1")
    -- cleanEditBoxString(ccui.Helper:seekWidgetByName(root, "TextField_1"))
    roleName:setString("")
    roleName:didNotSelectSelf()
    -- self.Text_field:setString(chat_sent_string[2])
    -- self.Text_field:setColor(cc.c3b(gray_color[1], gray_color[2], gray_color[3]))
    -- self.Text_field:setPositionX(self.TextFields:getPositionX())
    _ED._chats_text_info[tonumber(self.page_index)] = nil
end

-- 聊天图片
function RedAlertTimeChatSentCell:onUpdateDrawPic()
    if self._is_init == false then
        return
    end
    self._is_init = false

    local root = self.roots[1]
    self._ScrollView_face:removeAllChildren(true)
    local width = self._ScrollView_face:getContentSize().width
    local height = self._ScrollView_face:getContentSize().height
    local scroll_height = 0
    local index = 0

    local total_line = 7
    local one_width = 0
    local one_height = 0

    for i = 1,49 do
        local wight_n = 1
        local height_n = 1
        if i % 7 == 0 then
            wight_n = 7
            height_n = i / 7
        else
            wight_n = i % 7
            height_n = math.floor(i / 7) + 1
        end

        local cell = nil
        cell = state_machine.excute("chat_sent_face_create_cell",0,{i,self.page_index})
        one_width = cell:getContentSize().width
        one_height = cell:getContentSize().height+10
        cell:setAnchorPoint(cc.p(0,0))
        cell:setPosition(cc.p((wight_n-1)*(one_width+4),(total_line - height_n) * one_height))
        self._ScrollView_face:addChild(cell)
    end
    self._ScrollView_face:getInnerContainer():setContentSize(cc.size(width, total_line * one_height))
    self._ScrollView_face:jumpToTop()

    self.scroll_view_poy = self._ScrollView_face:getInnerContainer():getPositionY()
    self.scroll_view_height = self._ScrollView_face:getInnerContainer():getPositionY()
end

--初始化界面
function RedAlertTimeChatSentCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.chats.chat_sent_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	
	if RedAlertTimeChatSentCell.__size == nil then
        RedAlertTimeChatSentCell.__size = root:getContentSize()
    end


    local action = csb.createTimeline(config_csb.cells.chats.chat_sent_cell)
    table.insert(self.actions, action)
    csbItem:runAction(action)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then
        elseif str == "face_window_close_over" then
            ccui.Helper:seekWidgetByName(root, "Panel_face"):setVisible(false)
        end  
    end)

    self.TextFields = ccui.Helper:seekWidgetByName(root, "TextField_1")
    self.Text_field = ccui.Helper:seekWidgetByName(root, "Text_field")
    self.Text_field:setString(chat_sent_string[19])
    self.Text_field:setColor(cc.c3b(gray_color[1], gray_color[2], gray_color[3]))
    self.Text_field:setPositionX(self.TextFields:getPositionX())
    self.Text_field:removeFromParent(true)

    self.Panel_textfield = ccui.Helper:seekWidgetByName(root, "Panel_1")
    self.Panel_name = ccui.Helper:seekWidgetByName(root, "Panel_name")
	if self.textFieldsPointX == nil then
		self.textFieldsPointX = self.TextFields:getPositionX()
	end
	if self.TextFields._size == nil then
		self.TextFields._size = self.TextFields:getContentSize()
	end
    local Button_face = ccui.Helper:seekWidgetByName(root, "Button_face")
    self._show_face_posX = self.Panel_textfield:getPositionX()
    self._hide_face_posX = self._show_face_posX - Button_face:getContentSize().width

    local e_editBox = draw:addEditBoxEx(self.TextFields, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sent"), 100, cc.KEYBOARD_RETURNTYPE_DONE)
    self.TextFields = e_editBox
    -- if nil ~= e_editBox then
    --     e_editBox:setTouchEnabled(false)
    --     local function editBoxOpen( sender, eventType )
    --         e_editBox:touchDownAction( sender, eventType )
    --     end
	   -- self.Panel_textfield:addTouchEventListener(editBoxOpen)
    -- else
    --     self.TextFields:setTouchEnabled(true)
    --     self.Panel_textfield:setTouchEnabled(false)
    -- end

    -- draw:addEditBoxEx(self.TextFields, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sent"), 500, cc.KEYBOARD_RETURNTYPE_DONE)     
	self.Text_name = ccui.Helper:seekWidgetByName(root,"TextField_name")
    local nameData = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
    local name_editBox = draw:addEditBoxEx(self.Text_name, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sent"), tonumber(nameData[2]), cc.KEYBOARD_RETURNTYPE_DONE)  
	self.Text_name = name_editBox
    -- -- draw:addEditBoxEx(self.Text_name, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sent"), 40, cc.KEYBOARD_RETURNTYPE_DONE)  
	-- if nil ~= name_editBox then
 --        name_editBox:setTouchEnabled(false)
 --        local function nameEditBoxOpen( sender, eventType )
 --            name_editBox:touchDownAction( sender, eventType )
 --        end
 --       self.Panel_name:addTouchEventListener(nameEditBoxOpen)
 --    else
 --        self.Text_name:setTouchEnabled(true)
 --        self.Panel_name:setTouchEnabled(false)
 --    end

	self._ScrollView_face = ccui.Helper:seekWidgetByName(root,"ScrollView_face")
	--进入好友
	local Button_share = ccui.Helper:seekWidgetByName(root, "Button_share")
	if Button_share ~= nil then
		-- fwin:addTouchEventListener(Button_share, nil, 
		-- {
			-- terminal_name = "game_social_platforms_open",      
			-- but_image = "",     
			-- terminal_state = 0,
			-- touch_scale = true,
			-- touch_scale_xy = 0.95, 
			-- page = 1
		-- }, nil, 1)
		local function platformsOpen( sender, eventType )
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()

			if eventType == ccui.TouchEventType.began then
			elseif eventType == ccui.TouchEventType.moved then
			elseif eventType == ccui.TouchEventType.canceled then
			elseif eventType == ccui.TouchEventType.ended then
				if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
					state_machine.excute("game_social_platforms_open", 0, {_datas = {page = 1}})
				end
			end
		end
		Button_share:addTouchEventListener(platformsOpen)
        
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_friend_give_energy",
        _widget = Button_share,
        _m_type = 0,
        _invoke = nil,
        _interval = 0.2,})
	end
	
	
	-- 发送消息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sent"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_cell_message",      
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 弹幕开关
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_barrage_on"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_cell_switch_show_text",      
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

	-- 打开联系人
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_friend"), nil, 
    {
        terminal_name = "chat_friend_window_window_open",      
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        from_type = 1,
    }, nil, 1)
    -- 显示表情
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_face"), nil, 
    -- {
        -- terminal_name = "red_alert_time_chat_sent_cell_face_show",     
        -- but_image = "",     
        -- terminal_state = 0,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    -- }, nil, 1)
	
	local function chatSentCellFaceShow( sender, eventType )
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.moved then
		elseif eventType == ccui.TouchEventType.canceled then
		elseif eventType == ccui.TouchEventType.ended then
			if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
				state_machine.excute("red_alert_time_chat_sent_cell_face_show", 0, 0)
			end
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_face"):addTouchEventListener(chatSentCellFaceShow)

    -- 隐藏表情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_face"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_cell_face_hide",      
        but_image = "",     
        terminal_state = 0,
    }, nil, 1)
    
    ccui.Helper:seekWidgetByName(root, "Panel_face"):setSwallowTouches(false)

    -- self.cursor = cc.Sprite:create("images/ui/chat/chat_infor_bar.png")
    -- self.cursor:setPositionX(0)
    -- self.cursor:setPositionY(self.Panel_textfield:getContentSize().height/2)
    -- self.Panel_textfield:addChild(self.cursor)
    -- self.cursor_flash = false

    -- self.cursor_name = cc.Sprite:create("images/ui/chat/chat_infor_bar.png")
    -- self.cursor_name:setPositionX(0)
    -- self.cursor_name:setPositionY(self.Panel_name:getContentSize().height/2)
    -- self.Panel_name:addChild(self.cursor_name)
    -- self.cursor_name_flash = false


    if _ED._chats_text_info[tonumber(self.page_index)] ~= nil 
        and (_ED._chats_text_info[tonumber(self.page_index)]._info ~=nil or _ED._chats_text_info[tonumber(self.page_index)]._info ~="") 
        then
        ccui.Helper:seekWidgetByName(self.roots[1], "TextField_1"):setString(_ED._chats_text_info[tonumber(self.page_index)]._info)
    else
        ccui.Helper:seekWidgetByName(self.roots[1], "TextField_1"):setString("")
    end    
    -- self:onUpdateDrawPic()
    self.recording = dms.int(dms["message_config"], 14, pirates_config.param)

    self._Image_face_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_face_arrow_up")
    self._Image_face_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_face_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_face_arrow_down:stopAllActions()
    self._Image_face_arrow_up:stopAllActions()
    playActions(self._Image_face_arrow_down)
    playActions(self._Image_face_arrow_up)
    self._Image_face_arrow_down:setVisible(false)
    self._Image_face_arrow_up:setVisible(false)
end

function RedAlertTimeChatSentCell:onEnterTransitionFinish()

end

function RedAlertTimeChatSentCell:widthSingle(inputstr)
    -- 计算字符串宽度
    -- 可以计算出字符宽度，用于显示使用
   local lenInByte = #inputstr
   local width = 0
   local i = 1
    while (i<=lenInByte) 
    do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
            byteCount = 1                                               --1字节字符
            if curByte >= 48 and curByte<=57 
                or curByte >= 97 and curByte<=122  then
                width = width + 12
            elseif curByte >= 65 and curByte<=90 then
                if curByte==87 then
                    width = width + 21.3
                elseif curByte == 81 then
                    width = width + 17.5    
                elseif curByte == 77 then
                    width = width + 18.2  
                elseif curByte == 82 then
                    width = width + 16.5    
                else
                    width = width + 15
                end
            elseif curByte == 64 or curByte == 37 then
                width = width + 22
            else
                width = width + 12    
            end
        elseif curByte>=192 and curByte<=223 then
            byteCount = 2                                               --双字节字符
            width = width + 22
        elseif curByte>=224 and curByte<=239 then
            byteCount = 3                                               --汉字
            width = width + 22
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4                                               --4字节字符
            width = width + 22
        end
         
        local char = string.sub(inputstr, i, i+byteCount-1)
        -- print(char)                                                          --看看这个字是什么
        i = i + byteCount                                              -- 重置下一字节的索引
        -- width = width + 1                                             -- 字符的个数（长度）
    end
    return width
end

function RedAlertTimeChatSentCell:getTextFieldLenth()
	local map = string.utf8.chars(self.TextFields:getString())
	for i,v in pairs(map) do
		self.len_size = self.len_size + string.len(v)
	end
    --local len = self:widthSingle(self.TextFields:getString())
    local len = self.TextFields:getAutoRenderSize().width

    --print(len,self.Panel_textfield:getContentSize().width)
	if len <= self.Panel_textfield:getContentSize().width then
        self.cursor_point = len+5
		len = self.Panel_textfield:getContentSize().width
    else
        self.cursor_point = self.Panel_textfield:getContentSize().width-2   
	end
	return len
end

function RedAlertTimeChatSentCell:getNameFieldLenth()
    local map = string.utf8.chars(self.Text_name:getString())
    for i,v in pairs(map) do
        self.len_size_two = self.len_size_two + string.len(v)
    end
    --local len = self:widthSingle(self.Text_name:getString())
    local len = self.Text_name:getAutoRenderSize().width

    --print(len,self.Panel_textfield:getContentSize().width)
    if len <= self.Panel_name:getContentSize().width then
        self.cursor_name_point = len+5
        len = self.Panel_name:getContentSize().width
    else
        self.cursor_name_point = self.Panel_name:getContentSize().width-2   
    end
    return len
end

function RedAlertTimeChatSentCell:onUpdate(dt)
    if _ED._chat_text_times_info > 0 then
        local new_time = os.time()
        if _ED._chat_text_times_info - new_time <= 0 then
            _ED._chat_text_times_info = 0
        end
    end
	-- if self.textFieldsData~= self.TextFields:getString() then
	-- 	local leng = self:getTextFieldLenth()
 --        if leng>self.Panel_textfield:getContentSize().width then
 --            self.TextFields:setPositionX(self.textFieldsPointX-(leng-self.Panel_textfield:getContentSize().width)-6)
 --        else
 --            self.TextFields:setPositionX(self.textFieldsPointX-(leng-self.Panel_textfield:getContentSize().width))
 --        end
 --        self.Text_field:setPositionX(self.TextFields:getPositionX())
 --        self.cursor:setPositionX(0+self.cursor_point)
	-- 	self.len_size = 0
	-- 	self.textFieldsData = self.TextFields:getString()

    --     if self.textFieldsData == nil or self.textFieldsData == "" then
    --         self.Text_field:setString(chat_sent_string[19])
    --         self.Text_field:setColor(cc.c3b(gray_color[1], gray_color[2], gray_color[3]))
    --     else
    --         self.Text_field:setString(self.textFieldsData)
    --         self.Text_field:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    --     end
    -- end

    -- if self.nameFieldsData~= self.Text_name:getString() then
    --     local leng = self:getNameFieldLenth()
    --     self.cursor_name:setPositionX(0+self.cursor_name_point)
    --     self.len_size_two = 0
    --     self.nameFieldsData = self.Text_name:getString()
    -- end
    

    -- if self.cursor_flash == false then
    --     function startUpCallback(sender)
    --         self.cursor_flash = true
    --     end

    --     function blinkInCallback(sender)
    --         -- sender.CCFadeTo:create(0, 10)
    --         local fadeIn = cc.FadeTo:create(0.3, 0)
    --         local fadeOut = cc.FadeTo:create(0.4, 255)
    --         self.cursor:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeIn, fadeOut)))
    --     end

    --     function blinkOutCallback(sender)
    --         -- sender:setColor(cc.c3b(255, 255, 255))
    --         -- sender.CCFadeTo:create(1, 10)
    --         local fadeIn = cc.FadeTo:create(0.3, 255)
    --         local fadeOut = cc.FadeTo:create(0.4, 0)
    --         self.cursor:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeIn, fadeOut)))
    --     end

    --     function openEedAlertTimeMine(sender)
    --         self.cursor_flash = false
    --     end

    --     self.cursor:runAction(cc.Sequence:create(
    --                 cc.CallFunc:create(startUpCallback),
    --                 cc.DelayTime:create(0.6),
    --                 cc.CallFunc:create(blinkInCallback),
    --                 cc.DelayTime:create(0.6),
    --                 cc.CallFunc:create(blinkOutCallback),
    --                 -- cc.DelayTime:create(0.5),
    --                 -- cc.CallFunc:create(blinkInCallback),
    --                 cc.CallFunc:create(openEedAlertTimeMine)
    --                 ))
    -- end 

    -- if self.cursor_name_flash == false then
    --     function startUpCallback(sender)
    --         self.cursor_name_flash = true
    --     end

    --     function blinkInCallback(sender)
    --         -- sender.CCFadeTo:create(0, 10)
    --         local fadeIn = cc.FadeTo:create(0.3, 0)
    --         local fadeOut = cc.FadeTo:create(0.4, 255)
    --         self.cursor_name:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeIn, fadeOut)))
    --     end

    --     function blinkOutCallback(sender)
    --         -- sender:setColor(cc.c3b(255, 255, 255))
    --         -- sender.CCFadeTo:create(1, 10)
    --         local fadeIn = cc.FadeTo:create(0.3, 255)
    --         local fadeOut = cc.FadeTo:create(0.4, 0)
    --         self.cursor_name:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeIn, fadeOut)))
    --     end

    --     function openEedAlertTimeMine(sender)
    --         self.cursor_name_flash = false
    --     end

    --     self.cursor_name:runAction(cc.Sequence:create(
    --                 cc.CallFunc:create(startUpCallback),
    --                 cc.DelayTime:create(0.6),
    --                 cc.CallFunc:create(blinkInCallback),
    --                 cc.DelayTime:create(0.6),
    --                 cc.CallFunc:create(blinkOutCallback),
    --                 -- cc.DelayTime:create(0.5),
    --                 -- cc.CallFunc:create(blinkInCallback),
    --                 cc.CallFunc:create(openEedAlertTimeMine)
    --                 ))
    -- end 

    if self._ScrollView_face ~= nil then
        local size = self._ScrollView_face:getContentSize()
        local posY = self._ScrollView_face:getInnerContainer():getPositionY()
        if self.scroll_view_height == 0 then
            self.scroll_view_height = posY
        end
        if self.scroll_view_poy <= -30 then
            self._Image_face_arrow_down:setVisible(true)
        else
            self._Image_face_arrow_down:setVisible(false)
        end
        if self.scroll_view_poy >= self.scroll_view_height + 30 then
            self._Image_face_arrow_up:setVisible(true)
        else
            self._Image_face_arrow_up:setVisible(false)
        end
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
    end
end

function RedAlertTimeChatSentCell:init()
	self:onInit()
	self:setContentSize(RedAlertTimeChatSentCell.__size)
    return self
end

function RedAlertTimeChatSentCell:onExit()
    state_machine.excute("red_alert_time_chat_sent_cell_record_the_contents",0,"")
    cacher.freeRef(config_csb.cells.chats.chat_sent_cell, self.roots[1])

    state_machine.remove("red_alert_time_chat_sent_cell_window_close_action")
    state_machine.remove("red_alert_time_chat_sent_cell_message")
    state_machine.remove("red_alert_time_chat_sent_cell_face_show")
    state_machine.remove("red_alert_time_chat_sent_cell_face_hide")
    state_machine.remove("red_alert_time_chat_sent_cell_add_image")
    state_machine.remove("red_alert_time_chat_sent_cell_instal_page")
    state_machine.remove("red_alert_time_chat_sent_cell_private_chat")
    state_machine.remove("red_alert_time_chat_sent_cell_switch_show_text")
    state_machine.remove("red_alert_time_chat_sent_cell_record_the_contents")
end

function RedAlertTimeChatSentCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeChatSentCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.chats.chat_sent_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end