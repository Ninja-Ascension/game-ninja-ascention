-----------------------------
-- 写邮件
-----------------------------
MailWriteAn = class("MailWriteAnClass", Window)

--打开界面
local write_an_email_window_open_terminal = {
	_name = "write_an_email_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(238) == true then
            return
        end  
		if fwin:find("MailWriteAnClass") == nil then
			fwin:open(MailWriteAn:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local write_an_email_window_close_terminal = {
	_name = "write_an_email_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MailWriteAnClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(write_an_email_window_open_terminal)
state_machine.add(write_an_email_window_close_terminal)
state_machine.init()

function MailWriteAn:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.aims_name = ""
	self.aims_title = ""

    self._Image_face_arrow_down = nil
    self._Image_face_arrow_up = nil

    self._ScrollView_face = nil
    self.scroll_view_poy = 0
    self.scroll_view_height = 0

    self._text_title = nil
    self._text_field_title = nil
    self._text_content = nil
    self._text_field_content = nil
    self._length_info = nil
	
	app.load("client.red_alert_time.cells.chats.chat_sent_face_cell")
    app.load("client.red_alert_time.chat.ChatFriendWindow")

    local function init_MailWriteAn_terminal()
        local write_an_email_change_page_terminal = {
            _name = "write_an_email_change_page",
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
		
		 --显示表情
        local write_an_email_chat_sent_face_show_terminal = {
            _name = "write_an_email_chat_sent_face_show",
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
        local write_an_email_chat_sent_face_hide_terminal = {
            _name = "write_an_email_chat_sent_face_hide",
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
		
		--发送邮件
        local write_an_email_send_mail_message_terminal = {
            _name = "write_an_email_send_mail_message",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("write_an_email_window_close", 0, nil)
                            TipDlg.drawTextDailog(red_alert_time_str[213])
						end	
					end
                end
				
				local textName = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name")
				local textTitle = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_title")
				local textContent = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_mail_content")

                local nameString = textName:getString()
                if string.gsub(string.gsub(nameString, "^%s+", ""), "%s+$", "") == "" then
                    TipDlg.drawTextDailog(red_alert_time_str[223])
                    return
                end
                local titleString = textTitle:getString()
                if string.gsub(string.gsub(titleString, "^%s+", ""), "%s+$", "") == "" then
                    TipDlg.drawTextDailog(red_alert_time_str[224])
                    return
                end
                local contentString = textContent:getString()
                if string.gsub(string.gsub(contentString, "^%s+", ""), "%s+$", "") == "" then
                    TipDlg.drawTextDailog(red_alert_time_str[227])
                    return
                end

                local content = zstring.exchangeTo(textContent:getString())
                for i=1,#expression_onversion do
                    local str=string.gsub(content, expression_onversion[i][2], expression_onversion[i][1])
                    content = str
                end

                protocol_command.user_send_mail.param_list = zstring.exchangeTo(textName:getString()).."\r\n"..zstring.exchangeTo(textTitle:getString()).."\r\n"..content.."\r\n".."".."\r\n".."0\r\n"
                NetworkManager:register(protocol_command.user_send_mail.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加表情
        local write_an_email_chat_sent_add_image_terminal = {
            _name = "write_an_email_chat_sent_add_image",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.excute("red_alert_time_chat_sent_face_hide", 0, nil)
                if instance ~= nil and instance.roots ~= nil then
                    local TextField_mail_content = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_mail_content")
                    local str = TextField_mail_content:getString()
                    TextField_mail_content:setString(str .. "/&|/"..tonumber(params)+100 .."|")
					local str2=string.gsub(TextField_mail_content:getString(), expression_onversion[tonumber(params)][1], expression_onversion[tonumber(params)][2])
					TextField_mail_content:setString(str2)
                    local editChild = TextField_mail_content:getChildByName("editName")
                    if editChild ~= nil then 
                        editChild:setText(TextField_mail_content:getString())
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local write_an_email_delete_name_terminal = {
            _name = "write_an_email_delete_name",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local TextField_name = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name")
                TextField_name:setString("")
                local editName = TextField_name:getChildByName("editName")
                if editName ~= nil then
                    editName:setText("")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local write_an_email_add_name_terminal = {
            _name = "write_an_email_add_name",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name"):setString(params.user_name)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(write_an_email_change_page_terminal)
        state_machine.add(write_an_email_chat_sent_face_show_terminal)
        state_machine.add(write_an_email_chat_sent_face_hide_terminal)
        state_machine.add(write_an_email_send_mail_message_terminal)
        state_machine.add(write_an_email_chat_sent_add_image_terminal)
        state_machine.add(write_an_email_delete_name_terminal)
        state_machine.add(write_an_email_add_name_terminal)
        state_machine.init()
    end
    init_MailWriteAn_terminal()
end

function MailWriteAn:init(params)
	self.aims_name = params._datas.name or ""
	self.aims_title = params._datas.title or ""
	self:onInit()
    return self
end

--显示表情
function MailWriteAn:onFaceShow()
    local root = self.roots[1]
    local Panel_face = ccui.Helper:seekWidgetByName(root, "Panel_face")
    Panel_face:setVisible(true)
    self.actions[1]:play("face_window_open", false)
end

--隐藏表情
function MailWriteAn:onFaceHide()
    -- local root = self.roots[1]
    -- local Panel_face = ccui.Helper:seekWidgetByName(root, "Panel_face")
    self.actions[1]:play("face_window_close", false)
end

-- 聊天图片
function MailWriteAn:onUpdateDrawPic()
    -- cc.Director:getInstance():getTextureCache():addImage("images/ui/chat/face.png")
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/chat/face.plist")
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
        cell = state_machine.excute("chat_sent_face_create_cell",0,{i,10})
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

function MailWriteAn:onInit()
    local csbItem = csb.createNode(config_csb.mail.mail_write_infor)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
	
	local action = csb.createTimeline(config_csb.mail.mail_write_infor)
    table.insert(self.actions, action)
    -- action:play("window_open", false)
    csbItem:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then
            -- action:play("face_window_open", false)
        elseif str == "face_window_close_over" then
            ccui.Helper:seekWidgetByName(root, "Panel_face"):setVisible(false)
        end  
    end)
	
	ccui.Helper:seekWidgetByName(root, "Panel_face"):setVisible(false)

    local length_info = zstring.split(dms.string(dms["mail_config"], 3, mail_config.param), ",")
    local nameData = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
    local TextField_name = ccui.Helper:seekWidgetByName(root, "TextField_name")
    TextField_name = draw:addEditBoxEx(TextField_name, mail_tip_text[51], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_mail_delete"), tonumber(nameData[2]), cc.KEYBOARD_RETURNTYPE_DONE) 
    draw:addEditBoxEx(ccui.Helper:seekWidgetByName(root, "TextField_title"), mail_tip_text[52], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_mail_delete"), tonumber(length_info[1]), cc.KEYBOARD_RETURNTYPE_DONE) 
    draw:addEditBoxEx(ccui.Helper:seekWidgetByName(root, "TextField_mail_content"), mail_tip_text[53], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_mail_delete"), tonumber(length_info[2]), cc.KEYBOARD_RETURNTYPE_DONE, nil, nil, ccui.Helper:seekWidgetByName(root, "TextField_mail_content")) 
	
	TextField_name:setString(self.aims_name)
	ccui.Helper:seekWidgetByName(root, "TextField_title"):setString(self.aims_title)

    self._text_field_title = ccui.Helper:seekWidgetByName(root, "TextField_title")
    self._text_field_content = ccui.Helper:seekWidgetByName(root, "TextField_mail_content")

    self._text_title = ccui.Helper:seekWidgetByName(root, "Text_mail_title_n")
    self._text_content = ccui.Helper:seekWidgetByName(root, "Text_mail_sent_n")
    self._length_info = length_info
	
	--发送
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_delete"), nil, 
    {
        terminal_name = "write_an_email_send_mail_message", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
	
	--清除对象名字
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_delete"), nil, 
    {
        terminal_name = "write_an_email_delete_name", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
	
	--进入好友列表
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_contact_person"), nil, 
    {
        terminal_name = "chat_friend_window_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        from_type = 3,
    }, nil, 1)
	
	--表情符号
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_face"), nil, 
    {
        terminal_name = "", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
	--关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_mail_close"), nil, 
    {
        terminal_name = "write_an_email_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "write_an_email_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	
	-- 显示表情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_face"), nil, 
    {
        terminal_name = "write_an_email_chat_sent_face_show",     
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 隐藏表情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_face"), nil, 
    {
        terminal_name = "write_an_email_chat_sent_face_hide",      
        but_image = "",     
        terminal_state = 0,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 1)
	
	self._ScrollView_face = ccui.Helper:seekWidgetByName(root,"ScrollView_face")

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

	self:onUpdateDrawPic()
end

function MailWriteAn:onUpdate(dt)
    if self._text_title ~= nil then
        self._text_title:setString(string.format(mail_tip_text[54], string.utf8.len(self._text_field_title:getString()), tonumber(self._length_info[1])))
        self._text_content:setString(string.format(mail_tip_text[54], string.utf8.len(self._text_field_content:getString()), tonumber(self._length_info[2])))
    end

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

function MailWriteAn:onEnterTransitionFinish()
    
end


function MailWriteAn:onExit()
	state_machine.remove("write_an_email_change_page")
    state_machine.remove("write_an_email_chat_sent_face_show")
    state_machine.remove("write_an_email_chat_sent_face_hide")
    state_machine.remove("write_an_email_send_mail_message")
    state_machine.remove("write_an_email_chat_sent_add_image")
    state_machine.remove("write_an_email_delete_name")
end

