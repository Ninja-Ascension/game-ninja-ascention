--------------------------------------------------------------------------------------------------------------
--  说明：聊天系统
--------------------------------------------------------------------------------------------------------------
ChatSent = class("ChatSentClass", Window)

--打开界面
local chat_sent_window_open_terminal = {
	_name = "chat_sent_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(49) == true then
            return
        end 
        if fwin:find("ChatSentClass") == nil then
		   fwin:open(ChatSent:new():init(),fwin._windows)
        end
        state_machine.excute("chat_sent_window_show",0,"")
        state_machine.excute("chat_view_update_chat_info",0,"")
        -- NetworkAdaptor.socketInit(NetworkAdaptor.LuaSocket.url)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local chat_sent_window_close_terminal = {
	_name = "chat_sent_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ChatSentClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(chat_sent_window_open_terminal)
state_machine.add(chat_sent_window_close_terminal)
state_machine.init()

function ChatSent:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    --列表父层
    self._panel_listview = nil
    --所有列表项 
    self._listview_tab = {}
    --当前页面 0：系统；1：世界；2：军团；3:私聊 4 阵营 5 GM
    self.send_type = {1,4,2,3,0,5}
    self.page_index = 1
	
	self.voice_text = nil
	self.is_voice = false
	self.chatSentButton = nil
	self.voiceButton = nil
	
	self.sent_Panel = nil
	self.sent_system = nil
	self.sent_roleName_pointX = nil
	self.sent_roleName_pointY = nil

    self.send_user_data = nil
	
    -- load lua file
	app.load("client.red_alert_time.packs.herostorage.HeroPacks")
    app.load("client.red_alert_time.notification.push_notification_home_build")
	
	 -- Initialize chat_sent state machine.
    local function init_chat_sent_terminal()
		 --管理
        local chat_sent_list_manager_terminal = {
        _name = "chat_sent_list_manager",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)  
            local fun_open_id = params._datas.fun_open_id
            if fun_open_id ~= nil then 
                if funOpenDrawTip(fun_open_id) == true then
                    return
                end
            end
            state_machine.excute(params._datas.next_terminal_name, 0, params)
            -- set select ui button is highlighted
            
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            terminal.page_name = params._datas.but_image
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
            end
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(true)
                terminal.select_button:setTouchEnabled(false)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }

        --子页面切换
        local chat_sent_list_change_terminal = {
            _name = "chat_sent_list_change",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.page_index = params._datas.page_index
                for i,list_view in pairs(instance._listview_tab) do
                    list_view:setVisible(false)
                end
                if instance._listview_tab[instance.page_index] == nil then
                    instance._listview_tab[instance.page_index] = state_machine.excute("chat_sent_list_window_open",0,{instance._panel_listview,instance.send_type[instance.page_index]})
                end
                if instance.page_index == 1 then
                    _ED._push_chat_world = 0
                end
                instance._listview_tab[instance.page_index]:setVisible(true)
				instance.chatSentButton:setVisible(true)
				instance.voiceButton:setVisible(false)
				instance.text_field:setPosition(cc.p(instance.sent_roleName_pointX,instance.sent_roleName_pointY))
				self.is_voice = false
                if instance.page_index == 4 then
                    _ED._push_chat_private = 0
					instance.sent_Panel:setVisible(true)
					instance.sent_system:setVisible(false)
					instance.text_field:setPosition(cc.p(instance.sent_roleName_pointX,instance.sent_roleName_pointY))
                    instance.text_field:setPositionX(instance.text_field_posx2)
                    instance.text_name:setVisible(true)
                else
					if instance.page_index == 5 then
                        _ED._push_chat_system = 0
						instance.sent_Panel:setVisible(false)
						instance.sent_system:setVisible(true)
						instance.text_field:setPosition(cc.p(-1000,-1000))
					else
						instance.sent_Panel:setVisible(true)
						instance.sent_system:setVisible(false)
						instance.text_field:setPosition(cc.p(instance.sent_roleName_pointX,instance.sent_roleName_pointY))
						instance.text_field:setPositionX(instance.text_field_posx1)
					end
					instance.text_name:setVisible(false)
                end
				state_machine.excute("chat_view_update_chat_info",0,"")
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		--显示所有
		local chat_sent_window_show_terminal = {
            _name = "chat_sent_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 隐藏所有
        local chat_sent_window_hide_terminal = {
            _name = "chat_sent_window_hide",
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

        -- 播放隐藏动画
        local chat_sent_window_close_action_terminal = {
            _name = "chat_sent_window_close_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 切换语音和文字
        local switch_chat_sent_type_message_terminal = {
            _name = "switch_chat_sent_type_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.is_voice == false then
					instance.chatSentButton:setVisible(false)
					instance.voiceButton:setVisible(true)
					instance.text_field:setPosition(cc.p(-1000,-1000))
					self.is_voice = true
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_speak"):setHighlighted(true)
                else
					instance.chatSentButton:setVisible(true)
					instance.voiceButton:setVisible(false)
					instance.text_field:setPosition(cc.p(instance.sent_roleName_pointX,instance.sent_roleName_pointY))
					self.is_voice = false
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_speak"):setHighlighted(false)
				    if instance.page_index == 4 then
                        instance.text_field:setPositionX(instance.text_field_posx2)
                    else
                        instance.text_field:setPositionX(instance.text_field_posx1)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 发送消息
        local chat_sent_message_terminal = {
            _name = "chat_sent_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:SendInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 聊天展示
        local chat_show_ship_terminal = {
            _name = "chat_show_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				state_machine.excute("hero_packs_window_open",0,{_datas={darwType=1}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 语音读取和聊天展现
        local voice_send_message_terminal = {
            _name = "voice_send_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.voice_text = params
				instance:SendInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        -- 私聊
        local chat_sent_change_to_person_chat_terminal = {
            _name = "chat_sent_change_to_person_chat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("user_info_window_close",0,"")
                state_machine.excute("chat_sent_window_show",0,"")
                instance.actions[1]:play("window_open", false)

                local user_data = params._datas.user_data
                instance.text_name:setString(user_data.user_name)
                instance.send_user_data = user_data
                instance.text_name:setVisible(true)
                state_machine.excute("chat_sent_list_manager",0,{
                _datas = {
                        terminal_name = "chat_sent_list_manager",     
                        next_terminal_name = "chat_sent_list_change", 
                        current_button_name = "Button_chat",   
                        but_image = "",     
                        terminal_state = 0,
                        page_index = 4,
                        isPressedActionEnabled = false
                    }
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示表情
        local chat_sent_face_show_terminal = {
            _name = "chat_sent_face_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(50) == false then 
                    instance:onFaceShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --隐藏表情
        local chat_sent_face_hide_terminal = {
            _name = "chat_sent_face_hide",
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
        local chat_sent_add_image_terminal = {
            _name = "chat_sent_add_image",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("chat_sent_face_hide", 0, nil)
                if instance ~= nil and instance.roots ~= nil then
                    local TextField_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1")
                    local str = TextField_1:getString()
                    TextField_1:setString(str .. "/"..tonumber(params)+100 .."|")
                    local editChild = TextField_1:getChildByName("editName")
                    if editChild ~= nil then 
                        editChild:setText(str .. "/"..tonumber(params)+100 .."|")
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(chat_sent_list_manager_terminal)
        state_machine.add(chat_sent_list_change_terminal)
		state_machine.add(chat_sent_window_show_terminal)
		state_machine.add(chat_sent_window_hide_terminal)	
        state_machine.add(chat_sent_window_close_action_terminal)
        state_machine.add(chat_sent_message_terminal)
        state_machine.add(chat_sent_change_to_person_chat_terminal)
        state_machine.add(voice_send_message_terminal)
        state_machine.add(switch_chat_sent_type_message_terminal)
        state_machine.add(chat_show_ship_terminal)
        state_machine.add(chat_sent_face_show_terminal)
        state_machine.add(chat_sent_face_hide_terminal)
        state_machine.add(chat_sent_add_image_terminal)
        state_machine.init()
    end
   
    init_chat_sent_terminal()

end

--显示界面
function ChatSent:onShow()
	self:setVisible(true)
end

--隐藏界面
function ChatSent:onHide()
	self:setVisible(false)
end

--显示表情
function ChatSent:onFaceShow()
    local root = self.roots[1]
    local Panel_face = ccui.Helper:seekWidgetByName(root, "Panel_face")
    Panel_face:setVisible(true)
    self.actions[1]:play("face_window_open", false)
end

--隐藏表情
function ChatSent:onFaceHide()
    -- local root = self.roots[1]
    -- local Panel_face = ccui.Helper:seekWidgetByName(root, "Panel_face")
    self.actions[1]:play("face_window_close", false)
end

function ChatSent:updateDraw()
    state_machine.excute("chat_sent_list_manager",0,{
            _datas = {
                terminal_name = "chat_sent_list_manager",     
                next_terminal_name = "chat_sent_list_change", 
                current_button_name = "Button_world",   
                but_image = "",     
                terminal_state = 0,
                page_index = 1,
                isPressedActionEnabled = false
            }
        })
end

function ChatSent:SendInfo()
    local root = self.roots[1]
    -- if NetworkAdaptor.socketIsOpen() == false then 
    --     NetworkAdaptor.socketInit(NetworkAdaptor.LuaSocket.url)
    -- end
    if NetworkAdaptor.socketIsOpen() == false then 
        NetworkAdaptor.intSocket()
    end
    
    if self.page_index == 4 then
        local function responseSendMessageCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
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
        local length = zstring.utfstrlenServer(str)
        
        if verifySupportLanguage(_lua_release_language_en) == true then
        else
            if length > 40 then
                TipDlg.drawTextDailog(chat_sent_string[5])
                self.voice_text = nil
                return
            end
        end
        if self.send_user_data == nil then
            TipDlg.drawTextDailog(chat_sent_string[1])
            self.voice_text = nil
            return
        end
        if text:getString() ~= "" then
            protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. self.send_user_data.user_id
            NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
        else
            if self.voice_text ~= nil and self.voice_text~="" then
                protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. self.send_user_data.user_id
                NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                self.voice_text = nil
            else
                TipDlg.drawTextDailog(chat_sent_string[2])
            end
        end
    else
        local function responseSendMessageCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
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
        local length = zstring.utfstrlenServer(str)
        
        if verifySupportLanguage(_lua_release_language_en) == true then
        else
            if length > 40 then
                TipDlg.drawTextDailog(chat_sent_string[5])
                self.voice_text = nil
                return
            end
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
        if text:getString() ~= "" then
            protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. "0"
            NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
        else
            if self.voice_text ~= nil and self.voice_text~="" then
                protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. "0"
                NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                self.voice_text = nil
            else
                TipDlg.drawTextDailog(chat_sent_string[2])
            end
        end
    end
end

function ChatSent:detachWithIME()
    local root = self.roots[1]
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1")
    cleanEditBoxString(ccui.Helper:seekWidgetByName(root, "TextField_1"))
    roleName:setString("")
    roleName:didNotSelectSelf()
end

-- 聊天图片
function ChatSent:onUpdateDrawPic()
    cc.Director:getInstance():getTextureCache():addImage("images/ui/chat/face.png")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/chat/face.plist")
    local root = self.roots[1]
    local ScrollView_face = ccui.Helper:seekWidgetByName(root,"ScrollView_face")
    ScrollView_face:removeAllChildren(true)
    local width = ScrollView_face:getContentSize().width
    local height = ScrollView_face:getContentSize().height
    local scroll_height = 0
    local index = 0

    local total_line = 6
    local one_width = 0
    local one_height = 0

    for i = 1,62 do
        local wight_n = 1
        local height_n = 1
        if i % 12 == 0 then
            wight_n = 12
            height_n = i / 12
        else
            wight_n = i % 12
            height_n = math.floor(i / 12) + 1
        end

        local cell = nil
        cell = state_machine.excute("chat_sent_face_create_cell",0,{i,self.page_index})
        one_width = cell:getContentSize().width
        one_height = cell:getContentSize().height
        cell:setAnchorPoint(cc.p(0,0))
        cell:setPosition(cc.p((wight_n-1)*(one_width+4),(total_line - height_n) * one_height))
        ScrollView_face:addChild(cell)
    end
    ScrollView_face:getInnerContainer():setContentSize(cc.size(width, total_line * one_height))
    ScrollView_face:jumpToTop()
end

--初始化界面
function ChatSent:onInit()
    local csbItem = csb.createNode(config_csb.chats.chat_sent)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.chats.chat_sent)
    table.insert(self.actions, action)
    action:play("window_open", false)
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
        elseif str == "window_close_over" then
            state_machine.excute("chat_sent_window_close",0,"")
        end  
    end)

    
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1")
	
    draw:addEditBoxEx(roleName, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sent"), 40, cc.KEYBOARD_RETURNTYPE_DONE)   
    roleName = ccui.Helper:seekWidgetByName(root, "TextField_1")  
	
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
	self.sent_roleName_pointX = roleName:getPositionX()
	self.sent_roleName_pointY = roleName:getPositionY()
    self.text_name = Text_name
    self.text_field = roleName
    self.text_field_posx1 = roleName:getPositionX()
    self.text_field_posx2 = roleName:getPositionX() + Text_name:getContentSize().width
       
	
	self.chatSentButton = ccui.Helper:seekWidgetByName(root, "Panel_input")
	self.voiceButton = ccui.Helper:seekWidgetByName(root, "Button_say")
	
	self.sent_Panel = ccui.Helper:seekWidgetByName(root, "Panel_chat_sent_2")
	self.sent_system = ccui.Helper:seekWidgetByName(root, "Text_system")
	
	local function buttonTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
        if ccui.TouchEventType.began == evenType then
			handlePlatformRequest(0, CC_VOICE_SEND_REQUEST, "")
			ccui.Helper:seekWidgetByName(root, "Image_say"):setVisible(true)
		elseif ccui.TouchEventType.moved == evenType then	
		
		else
			handlePlatformRequest(0, CC_VOICE_SEND_OVER, "")
			ccui.Helper:seekWidgetByName(root, "Image_say"):setVisible(false)
		end
	end
	fwin:addTouchEventListener(self.voiceButton, buttonTouchEvent, {terminal_name = "",_cell = self}, nil, 0)
	
	-- 切换语音和文字
	local Button_speak = ccui.Helper:seekWidgetByName(root, "Button_speak")
	if Button_speak ~= nil then
		fwin:addTouchEventListener(Button_speak, nil, 
		{
			terminal_name = "switch_chat_sent_type_message",      
			but_image = "",     
			terminal_state = 0,
			touch_scale = true,
			touch_scale_xy = 0.95, 
		}, nil, 3)
	end
	
	--聊天展示
	local Button_share = ccui.Helper:seekWidgetByName(root, "Button_share")
	if Button_share ~= nil then
		fwin:addTouchEventListener(Button_share, nil, 
		{
			terminal_name = "chat_show_ship",      
			but_image = "",     
			terminal_state = 0,
			touch_scale = true,
			touch_scale_xy = 0.95, 
		}, nil, 3)
	end
	
	-- 发送消息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sent"), nil, 
    {
        terminal_name = "chat_sent_message",      
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    -- 显示表情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_face"), nil, 
    {
        terminal_name = "chat_sent_face_show",     
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    -- 隐藏表情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_face"), nil, 
    {
        terminal_name = "chat_sent_face_hide",      
        but_image = "",     
        terminal_state = 0,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 3)


    --世界
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world"), nil, 
    {
        terminal_name = "chat_sent_list_manager",     
        next_terminal_name = "chat_sent_list_change", 
        current_button_name = "Button_world",   
        but_image = "",     
        terminal_state = 0,
        page_index = 1,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_chat_world",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_world"),
    _invoke = nil,
    _interval = 0.5,})
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_system"), nil, 
    {
        terminal_name = "chat_sent_list_manager",     
        next_terminal_name = "chat_sent_list_change", 
        current_button_name = "Button_system",   
        but_image = "",     
        terminal_state = 0,
        page_index = 5,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_chat_system",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_system"),
    _invoke = nil,
    _interval = 0.5,})
	
    --种族
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_race"), nil, 
    {
        terminal_name = "chat_sent_list_manager",     
        next_terminal_name = "chat_sent_list_change", 
        current_button_name = "Button_race",   
        but_image = "",     
        terminal_state = 0,
        page_index = 2,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    --公会
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion"), nil, 
    {
        terminal_name = "chat_sent_list_manager",     
        next_terminal_name = "chat_sent_list_change", 
        current_button_name = "Button_legion",   
        but_image = "",     
        terminal_state = 0,
        page_index = 3,
        fun_open_id = 131,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    --私聊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat"), nil, 
    {
        terminal_name = "chat_sent_list_manager",     
        next_terminal_name = "chat_sent_list_change", 
        current_button_name = "Button_chat",   
        but_image = "",     
        terminal_state = 0,
        page_index = 4,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_chat_private",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_chat"),
    _invoke = nil,
    _interval = 0.5,})
    
    --关闭聊天窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_chat_sent"), nil, 
    {
        terminal_name = "chat_sent_window_close_action", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
    }, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_stop"), nil, 
    {
        terminal_name = "chat_sent_window_close_action", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
    }, nil, 0)

    self._panel_listview = ccui.Helper:seekWidgetByName(root, "Panel_chat_list")
	self:updateDraw()
    self:onUpdateDrawPic()
end

function ChatSent:onEnterTransitionFinish()

end

function ChatSent:init()
	self:onInit()
    return self
end

--移除状态机
function ChatSent:onExit()
    state_machine.remove("chat_sent_list_manager")
    state_machine.remove("chat_sent_list_change")
    state_machine.remove("chat_sent_window_show")
    state_machine.remove("chat_sent_window_hide")
    state_machine.remove("chat_sent_window_close_action")
    state_machine.remove("chat_sent_message")
    state_machine.remove("chat_sent_change_to_person_chat")
    state_machine.remove("voice_send_message")
    state_machine.remove("switch_chat_sent_type_message")
    state_machine.remove("chat_show_ship")
    state_machine.remove("chat_sent_face_show")
    state_machine.remove("chat_sent_face_hide")
    state_machine.remove("chat_sent_add_image")
end