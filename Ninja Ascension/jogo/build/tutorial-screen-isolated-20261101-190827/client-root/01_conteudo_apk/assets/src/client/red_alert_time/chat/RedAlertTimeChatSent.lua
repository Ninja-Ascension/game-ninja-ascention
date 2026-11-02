--------------------------------------------------------------------------------------------------------------
--  说明：聊天系统
--------------------------------------------------------------------------------------------------------------
RedAlertTimeChatSent = class("RedAlertTimeChatSentClass", Window)

--打开界面
local red_alert_time_chat_sent_window_open_terminal = {
	_name = "red_alert_time_chat_sent_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local RedAlertTimeChatSentWindow = fwin:find("RedAlertTimeChatSentClass")
        if RedAlertTimeChatSentWindow == nil then
            RedAlertTimeChatSentWindow = RedAlertTimeChatSent:new():init(params)
            -- fwin._ui._layer:reorderChild(RedAlertTimeChatSentWindow, -1)
            -- fwin._ui._layer:reorderChild(RedAlertTimeChatSentWindow, 0)
    		fwin:open(RedAlertTimeChatSentWindow,fwin._ui)
        else
            fwin._ui._layer:reorderChild(RedAlertTimeChatSentWindow, -1)
            fwin._ui._layer:reorderChild(RedAlertTimeChatSentWindow, 0)
            local root = RedAlertTimeChatSentWindow.roots[1]
            -- Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
            state_machine.excute("red_alert_time_chat_sent_window_show",0,"")
            if params~= nil and params ~= "" then
                state_machine.excute("red_alert_time_chat_sent_list_manager",0,{
                    _datas = {
                            terminal_name = "red_alert_time_chat_sent_list_manager",     
                            next_terminal_name = "red_alert_time_chat_sent_list_change", 
                            current_button_name = "Button_chat",   
                            but_image = "",     
                            terminal_state = 0,
                            page_index = tonumber(params),
                            isPressedActionEnabled = false
                        }
                    })
            end
        end
        state_machine.excute("red_alert_time_chat_view_update_chat_info",0,"")
        -- NetworkAdaptor.socketInit(NetworkAdaptor.LuaSocket.url)
        -- fwin._ui._layer:reorderChild(RedAlertTimeChatSentWindow, -1)
        -- fwin._ui._layer:reorderChild(RedAlertTimeChatSentWindow, 0)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_chat_sent_window_close_terminal = {
	_name = "red_alert_time_chat_sent_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        -- _ED.chats_add_datas = false
        fwin:close(fwin:find("RedAlertTimeChatSentClass"))
        -- state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)

        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_chat_sent_window_open_terminal)
state_machine.add(red_alert_time_chat_sent_window_close_terminal)
state_machine.init()

function RedAlertTimeChatSent:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    --列表父层
    self._panel_listview = nil
    --所有列表项 
    self._listview_tab = {}
    --当前页面 0：系统；1：世界；2：军团；3:私聊 4 阵营 5 GM
    self.send_type = {1,4,3,4,0,5}
    self.page_index = 1
	
	self.voice_text = nil
	self.is_voice = false
	self.RedAlertTimeChatSentButton = nil
	-- self.voiceButton = nil
	
	self.sent_Panel = nil
	-- self.sent_system = nil
	self.sent_roleName_pointX = nil
	self.sent_roleName_pointY = nil

    self.send_user_data = nil
	
	self._Image_production_arrow_up = nil
    self._Image_production_arrow_down = nil
	self._ScrollView_face = nil
	
	--列表初始高度
    self.scroll_view_poy = nil

    self.scroll_view_height = 0
	
    -- load lua file
	app.load("client.red_alert_time.packs.herostorage.HeroPacks")
	app.load("client.red_alert_time.chat.RedAlertTimeChatSentList")
	app.load("client.red_alert_time.chat.SocialPlatforms")
	app.load("client.red_alert_time.chat.RedAlertTimeChatSentCell")
    -- app.load("client.red_alert_time.notification.push_notification_home_build")
	
	 -- Initialize chat_sent state machine.
    local function init_chat_sent_terminal()
		 --管理
        local red_alert_time_chat_sent_list_manager_terminal = {
        _name = "red_alert_time_chat_sent_list_manager",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)  
            -- local fun_open_id = params._datas.fun_open_id
            -- if fun_open_id ~= nil then 
                -- if funOpenDrawTip(fun_open_id) == true then
                --     return
                -- end
            -- end
			if tonumber(params._datas.page_index) == 3 then
                if funOpenDrawTip(152) == true then
                    return
                end
				if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                    state_machine.excute("home_map_update_build", 0, "")
                    state_machine.excute("legion_window_open", 0, "")
					return
                end
			end
			
			
            state_machine.excute(params._datas.next_terminal_name, 0, params)
            -- set select ui button is highlighted
            local Button_world = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_world")
            local Button_legion = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_legion")
            local Button_chat = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat")
            Button_world:setHighlighted(false)
            Button_world:setTouchEnabled(true)
            Button_legion:setHighlighted(false)
            Button_legion:setTouchEnabled(true)
            Button_chat:setHighlighted(false)
            Button_chat:setTouchEnabled(true)
            if params._datas.page_index == 4 then
                Button_chat:setHighlighted(true)
                Button_chat:setTouchEnabled(false)
            elseif params._datas.page_index == 1 then   
                Button_world:setHighlighted(true)
                Button_world:setTouchEnabled(false)
            elseif params._datas.page_index == 3 then      
                Button_legion:setHighlighted(true)
                Button_legion:setTouchEnabled(false)
            end

            -- if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
            --     terminal.select_button:setHighlighted(false)
            --     terminal.select_button:setTouchEnabled(true)
            -- end
            -- terminal.page_name = params._datas.but_image
            -- if terminal.select_button == nil and params._datas.current_button_name ~= nil then
            --     terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            -- else
            --     terminal.select_button = params
            -- end
            -- if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
            --     terminal.select_button:setHighlighted(true)
            --     terminal.select_button:setTouchEnabled(false)
            -- end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }

        --子页面切换
        local red_alert_time_chat_sent_list_change_terminal = {
            _name = "red_alert_time_chat_sent_list_change",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_chat_sent_cell_record_the_contents",0,0)
                instance.page_index = params._datas.page_index
				
				state_machine.excute("red_alert_time_chat_sent_cell_instal_page",0,instance.page_index)
                for i,list_view in pairs(instance._listview_tab) do
                    list_view:setVisible(false)
                end
                if instance._listview_tab[instance.page_index] == nil then
                    instance._listview_tab[instance.page_index] = state_machine.excute("red_alert_time_chat_sent_list_window_open",0,{instance._panel_listview,instance.send_type[instance.page_index]})
                elseif instance._listview_tab[instance.page_index] ~= nil then
                    state_machine.excute("red_alert_time_chat_sent_list_update_draw",0,instance._listview_tab[instance.page_index])
                end
                if instance.page_index == 1 then
                    _ED._push_chat_world = 0
                end
                state_machine.excute("red_alert_time_chat_push_notification", 0, {instance.page_index, true})
				-- if instance._listview_tab[instance.page_index] == nil then
					-- return
				-- end
                instance._listview_tab[instance.page_index]:setVisible(true)
				instance.RedAlertTimeChatSentButton:setVisible(true)
				-- instance.voiceButton:setVisible(false)
				-- instance.text_field:setPosition(cc.p(instance.sent_roleName_pointX,instance.sent_roleName_pointY))
				self.is_voice = false
                if instance.page_index == 4 then
                    _ED._push_chat_private = 0
					instance.sent_Panel:setVisible(true)
					-- instance.sent_system:setVisible(false)
					-- instance.text_field:setPosition(cc.p(instance.sent_roleName_pointX,instance.sent_roleName_pointY))
                    -- instance.text_field:setPositionX(instance.text_field_posx2)
                    -- instance.text_name:setVisible(true)
                else
					if instance.page_index == 5 then
                        _ED._push_chat_system = 0
						instance.sent_Panel:setVisible(false)
						-- instance.sent_system:setVisible(true)
						-- instance.text_field:setPosition(cc.p(-1000,-1000))
					else
						instance.sent_Panel:setVisible(false)
						-- instance.sent_system:setVisible(false)
						-- instance.text_field:setPosition(cc.p(instance.sent_roleName_pointX,instance.sent_roleName_pointY))
						-- instance.text_field:setPositionX(instance.text_field_posx1)
					end
					-- instance.text_name:setVisible(false)
                end
				state_machine.excute("red_alert_time_chat_view_update_chat_info",0,"")
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		--显示所有
		local red_alert_time_chat_sent_window_show_terminal = {
            _name = "red_alert_time_chat_sent_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onShow()
                if instance.roots[1]:getChildByTag(100) == nil then
                    local cell = state_machine.excute("red_alert_time_chat_sent_create_cell",0,0)
                    instance.roots[1]:addChild(cell)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 隐藏所有
        local red_alert_time_chat_sent_window_hide_terminal = {
            _name = "red_alert_time_chat_sent_window_hide",
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
        local red_alert_time_chat_sent_window_close_action_terminal = {
            _name = "red_alert_time_chat_sent_window_close_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance.actions[1]:play("window_close", false)
                -- state_machine.excute("red_alert_time_chat_sent_window_close",0,"")
                state_machine.excute("red_alert_time_chat_sent_cell_record_the_contents",0,0)
				state_machine.excute("red_alert_time_chat_sent_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 切换语音和文字
        local red_alert_time_switch_chat_sent_type_message_terminal = {
            _name = "red_alert_time_switch_chat_sent_type_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.is_voice == false then
					instance.RedAlertTimeChatSentButton:setVisible(false)
					-- instance.voiceButton:setVisible(true)
					-- instance.text_field:setPosition(cc.p(-1000,-1000))
					self.is_voice = true
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_speak"):setHighlighted(true)
                else
					instance.RedAlertTimeChatSentButton:setVisible(true)
					-- instance.voiceButton:setVisible(false)
					-- instance.text_field:setPosition(cc.p(instance.sent_roleName_pointX,instance.sent_roleName_pointY))
					self.is_voice = false
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_speak"):setHighlighted(false)
				    -- if instance.page_index == 4 then
                        -- instance.text_field:setPositionX(instance.text_field_posx2)
                    -- else
                        -- instance.text_field:setPositionX(instance.text_field_posx1)
                    -- end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 发送消息
        local red_alert_time_chat_sent_message_terminal = {
            _name = "red_alert_time_chat_sent_message",
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
        local red_alert_time_chat_show_ship_terminal = {
            _name = "red_alert_time_chat_show_ship",
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
        local red_alert_time_voice_send_message_terminal = {
            _name = "red_alert_time_voice_send_message",
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
        local red_alert_time_chat_sent_change_to_person_chat_terminal = {
            _name = "red_alert_time_chat_sent_change_to_person_chat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.excute("user_info_window_close",0,"")
                state_machine.excute("red_alert_time_chat_sent_window_show",0,"")
                -- instance.actions[1]:play("window_open", false)

                local user_data = params._datas.user_data
                -- instance.text_name:setString(user_data.user_name)
                instance.send_user_data = user_data
                -- instance.text_name:setVisible(true)
                state_machine.excute("red_alert_time_chat_sent_list_manager",0,{
                _datas = {
                        terminal_name = "red_alert_time_chat_sent_list_manager",     
                        next_terminal_name = "red_alert_time_chat_sent_list_change", 
                        current_button_name = "Button_chat",   
                        but_image = "",     
                        terminal_state = 0,
                        page_index = 4,
                        isPressedActionEnabled = false
                    }
                })
				ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name"):setString( instance.send_user_data.user_name)
				state_machine.excute("red_alert_time_chat_sent_cell_private_chat",0,instance.send_user_data)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

     --    --显示表情
     --    local red_alert_time_chat_sent_face_show_terminal = {
     --        _name = "red_alert_time_chat_sent_face_show",
     --        _init = function (terminal)
                
     --        end,
     --        _inited = false,
     --        _instance = self,
     --        _state = 0,
     --        _invoke = function(terminal, instance, params)
     --            instance:onFaceShow()
     --            return true
     --        end,
     --        _terminal = nil,
     --        _terminals = nil
     --    }

     --    --隐藏表情
     --    local red_alert_time_chat_sent_face_hide_terminal = {
     --        _name = "red_alert_time_chat_sent_face_hide",
     --        _init = function (terminal)
                
     --        end,
     --        _inited = false,
     --        _instance = self,
     --        _state = 0,
     --        _invoke = function(terminal, instance, params)
     --            instance:onFaceHide()
     --            return true
     --        end,
     --        _terminal = nil,
     --        _terminals = nil
     --    }

     --    -- 添加表情
     --    local red_alert_time_chat_sent_add_image_terminal = {
     --        _name = "red_alert_time_chat_sent_add_image",
     --        _init = function (terminal)
                
     --        end,
     --        _inited = false,
     --        _instance = self,
     --        _state = 0,
     --        _invoke = function(terminal, instance, params)
     --            -- state_machine.excute("red_alert_time_chat_sent_face_hide", 0, nil)
     --            if instance ~= nil and instance.roots ~= nil then
     --                local TextField_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1")
     --                local str = TextField_1:getString()
     --                TextField_1:setString(str .. "/"..tonumber(params)+100 .."|")
					-- local str2=string.gsub(TextField_1:getString(), expression_onversion[tonumber(params)][1], expression_onversion[tonumber(params)][2])
					-- TextField_1:setString(str2)
     --                local editChild = TextField_1:getChildByName("editName")
     --                if editChild ~= nil then 
     --                    editChild:setText(str .. "/"..tonumber(params)+100 .."|")
					-- 	local str3=string.gsub(editChild:getText(), expression_onversion[tonumber(params)][1], expression_onversion[tonumber(params)][2])
					-- 	editChild:setText(str3)
     --                end
     --            end
     --            return true
     --        end,
     --        _terminal = nil,
     --        _terminals = nil
     --    }

        -- 隐藏所有
        local red_alert_time_chat_sent_window_turn_off_terminal = {
            _name = "red_alert_time_chat_sent_window_turn_off",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots[1]:getChildByTag(100) ~= nil then
                    instance.roots[1]:removeChildByTag(100)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 清除军团聊天信息
        local red_alert_time_clear_legion_info_terminal = {
            _name = "red_alert_time_clear_legion_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._listview_tab ~= nil and instance._listview_tab[3] == nil then
                    fwin:close(instance._listview_tab[3])
                    instance._listview_tab[3] = nil
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 新消息的聊天推送
        local red_alert_time_chat_push_notification_terminal = {
            _name = "red_alert_time_chat_push_notification",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = params[1]
                local clear = params[2]
                if clear == true or m_type == instance.page_index then
                    _ED.push_chat_count[""..m_type] = 0
                else
                    if _ED.push_chat_count[""..m_type] == nil then
                        _ED.push_chat_count[""..m_type] = 0
                    end
                    _ED.push_chat_count[""..m_type] = _ED.push_chat_count[""..m_type] + 1
                end
                state_machine.excute("notification_center_update", 0, "push_notification_chat_count")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新聊天消息
        local red_alert_time_chat_update_chat_infomation_terminal = {
            _name = "red_alert_time_chat_update_chat_infomation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for k , list_view in pairs(instance._listview_tab) do
                    state_machine.excute("red_alert_time_chat_sent_list_update_chat_infomation",0,list_view)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_chat_sent_list_manager_terminal)
        state_machine.add(red_alert_time_chat_sent_list_change_terminal)
		state_machine.add(red_alert_time_chat_sent_window_show_terminal)
		state_machine.add(red_alert_time_chat_sent_window_hide_terminal)	
        state_machine.add(red_alert_time_chat_sent_window_close_action_terminal)
        state_machine.add(red_alert_time_chat_sent_message_terminal)
        state_machine.add(red_alert_time_chat_sent_change_to_person_chat_terminal)
        state_machine.add(red_alert_time_voice_send_message_terminal)
        state_machine.add(red_alert_time_switch_chat_sent_type_message_terminal)
        state_machine.add(red_alert_time_chat_show_ship_terminal)
        -- state_machine.add(red_alert_time_chat_sent_face_show_terminal)
        -- state_machine.add(red_alert_time_chat_sent_face_hide_terminal)
        -- state_machine.add(red_alert_time_chat_sent_add_image_terminal)
        state_machine.add(red_alert_time_chat_sent_window_turn_off_terminal)
        state_machine.add(red_alert_time_clear_legion_info_terminal)
        state_machine.add(red_alert_time_chat_push_notification_terminal)
        state_machine.add(red_alert_time_chat_update_chat_infomation_terminal)
        state_machine.init()
    end
   
    init_chat_sent_terminal()

end

--显示界面
function RedAlertTimeChatSent:onShow()
	self:setVisible(true)
end

--隐藏界面
function RedAlertTimeChatSent:onHide()
	self:setVisible(false)
    if nil ~= self and true == self.__check_covers then
        fwin:unAllCovers(nil, false, self)
    end
end

--显示表情
function RedAlertTimeChatSent:onFaceShow()
    local root = self.roots[1]
    local Panel_face = ccui.Helper:seekWidgetByName(root, "Panel_face")
    Panel_face:setVisible(true)
    self.actions[1]:play("face_window_open", false)
end

--隐藏表情
function RedAlertTimeChatSent:onFaceHide()
    -- local root = self.roots[1]
    -- local Panel_face = ccui.Helper:seekWidgetByName(root, "Panel_face")
    self.actions[1]:play("face_window_close", false)
end

function RedAlertTimeChatSent:updateDraw()
    local _page_index = 1
    if tonumber(self._index) ~= nil then
        _page_index = tonumber(self._index)
    end
    if self._index ~= nil 
        and self._index == 3 
        then
        state_machine.excute("red_alert_time_chat_sent_list_manager",0,{
            _datas = {
                terminal_name = "red_alert_time_chat_sent_list_manager",     
                next_terminal_name = "red_alert_time_chat_sent_list_change", 
                current_button_name = "Button_legion",   
                but_image = "",     
                terminal_state = 0,
                page_index = 3,
                isPressedActionEnabled = false
            }
        })
    else
        state_machine.excute("red_alert_time_chat_sent_list_manager",0,{
            _datas = {
                terminal_name = "red_alert_time_chat_sent_list_manager",     
                next_terminal_name = "red_alert_time_chat_sent_list_change", 
                current_button_name = "Button_world",   
                but_image = "",     
                terminal_state = 0,
                page_index = _page_index,
                isPressedActionEnabled = false
            }
        })
    end
end

function RedAlertTimeChatSent:SendInfo()
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
		for i=1,#expression_onversion do
			local str2=string.gsub(str, expression_onversion[i][2], expression_onversion[i][1])
			str = str2
		end
					
        local length = zstring.utfstrlenServer(str)
        
        if verifySupportLanguage(_lua_release_language_en) == true then
        else
            if length > 180 then
                TipDlg.drawTextDailog(chat_sent_string[5])
                self.voice_text = nil
                return
            end
        end
        if self.send_user_data == nil then
			local text2 = ccui.Helper:seekWidgetByName(root, "TextField_name")
			local str = zstring.exchangeTo(text:getString())
			if str == "" or str == nil then
				TipDlg.drawTextDailog(chat_sent_string[1])
				self.voice_text = nil
				return
			else
				self.send_user_data = {}
				self.send_user_data.user_id = "-1"
				self.send_user_data.user_name = str
			end
        end
        if text:getString() ~= "" then
            protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. self.send_user_data.user_id.."\r\n"..self.send_user_data.user_name
            NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
        else
            if self.voice_text ~= nil and self.voice_text~="" then
                protocol_command.send_message.param_list = str.."\r\n"..self.send_type[self.page_index] .. "\r\n" .. self.send_user_data.user_id.."\r\n"..self.send_user_data.user_name
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
		for i=1,#expression_onversion do
			local str2=string.gsub(str, expression_onversion[i][2], expression_onversion[i][1])
			str = str2
		end
        local length = zstring.utfstrlenServer(str)
        
        if verifySupportLanguage(_lua_release_language_en) == true then
        else
            if length > 180 then
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

function RedAlertTimeChatSent:detachWithIME()
    local root = self.roots[1]
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1")
    cleanEditBoxString(ccui.Helper:seekWidgetByName(root, "TextField_1"))
    roleName:setString("")
    roleName:didNotSelectSelf()
end

-- 聊天图片
function RedAlertTimeChatSent:onUpdateDrawPic()
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
        cell = state_machine.excute("chat_sent_face_create_cell",0,{i,self.page_index})
        one_width = cell:getContentSize().width
        one_height = cell:getContentSize().height+10
        cell:setAnchorPoint(cc.p(0,0))
        cell:setPosition(cc.p((wight_n-1)*(one_width+4),(total_line - height_n) * one_height))
        self._ScrollView_face:addChild(cell)
    end
    self._ScrollView_face:getInnerContainer():setContentSize(cc.size(width, total_line * one_height))
    self._ScrollView_face:jumpToTop()
end

function RedAlertTimeChatSent:onCheckCovers(window)
    if nil ~= window and true == window.__check_covers then
        fwin:checkCovers(nil, window)
    end
    fwin:addService({
        callback = function ( params )
            _ED.chats_add_datas = true
        end,
        delay = 0.1,
        params = nil
    })
    -- add
end

--初始化界面
function RedAlertTimeChatSent:onInit()
    local csbItem = csb.createNode(config_csb.Chat.red_alert_time_chat)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    local time = nil
    if false == missionIsOver() then
        time = 0
        self._view = fwin._ui
        self:onCheckCovers(self)
    else
        Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    end
    -- fwin._ui._layer:reorderChild(self, -1)
    -- fwin._ui._layer:reorderChild(self, 0)

    -- local action = csb.createTimeline(config_csb.Chat.red_alert_time_chat)
    -- table.insert(self.actions, action)
    -- -- action:play("window_open", false)
    -- csbItem:runAction(action)

    -- action:setFrameEventCallFunc(function (frame)
        -- if nil == frame then
            -- return
        -- end

        -- local str = frame:getEvent()
        -- if str == "window_open_over" then
            -- -- action:play("face_window_open", false)
        -- elseif str == "face_window_close_over" then
            -- ccui.Helper:seekWidgetByName(root, "Panel_face"):setVisible(false)
        -- end  
    -- end)

    
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_1")
	
    roleName = draw:addEditBoxEx(roleName, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sent"), 40, cc.KEYBOARD_RETURNTYPE_DONE)     
	
    local Text_name = ccui.Helper:seekWidgetByName(root,"TextField_name")
	
	Text_name = draw:addEditBoxEx(Text_name, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sent"), 40, cc.KEYBOARD_RETURNTYPE_DONE)  
	
	self.sent_roleName_pointX = roleName:getPositionX()
	self.sent_roleName_pointY = roleName:getPositionY()
    self.text_name = Text_name
    self.text_field = roleName
    self.text_field_posx1 = roleName:getPositionX()
    self.text_field_posx2 = roleName:getPositionX() + Text_name:getContentSize().width
       
	
	self.RedAlertTimeChatSentButton = ccui.Helper:seekWidgetByName(root, "Panel_input")
	-- self.voiceButton = ccui.Helper:seekWidgetByName(root, "Button_say")
	
	self.sent_Panel = ccui.Helper:seekWidgetByName(root, "Panel_private_chat")
	-- self.sent_system = ccui.Helper:seekWidgetByName(root, "Text_system")
	
	-- local function buttonTouchEvent(sender, evenType)
		-- local __spoint = sender:getTouchBeganPosition()
        -- if ccui.TouchEventType.began == evenType then
			-- handlePlatformRequest(0, CC_VOICE_SEND_REQUEST, "")
			-- ccui.Helper:seekWidgetByName(root, "Image_say"):setVisible(true)
		-- elseif ccui.TouchEventType.moved == evenType then	
		
		-- else
			-- handlePlatformRequest(0, CC_VOICE_SEND_OVER, "")
			-- ccui.Helper:seekWidgetByName(root, "Image_say"):setVisible(false)
		-- end
	-- end
	-- fwin:addTouchEventListener(self.voiceButton, buttonTouchEvent, {terminal_name = "",_cell = self}, nil, 1)
	
	local cell = state_machine.excute("red_alert_time_chat_sent_create_cell",0,0)
    cell:setTag(100)
	root:addChild(cell)

    _ED.push_chat_count = {}
	
	-- 切换语音和文字
	local Button_speak = ccui.Helper:seekWidgetByName(root, "Button_speak")
	if Button_speak ~= nil then
		fwin:addTouchEventListener(Button_speak, nil, 
		{
			terminal_name = "red_alert_time_switch_chat_sent_type_message",      
			but_image = "",     
			terminal_state = 0,
			touch_scale = true,
			touch_scale_xy = 0.95, 
		}, nil, 1)
	end
	
	--进入好友
	local Button_share = ccui.Helper:seekWidgetByName(root, "Button_share")
	if Button_share ~= nil then
		fwin:addTouchEventListener(Button_share, nil, 
		{
			terminal_name = "game_social_platforms_open",      
			but_image = "",     
			terminal_state = 0,
			touch_scale = true,
			touch_scale_xy = 0.95, 
			page = 1
		}, nil, 1)
        
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_friend_give_energy",
        _widget = Button_share,
        _m_type = 0,
        _invoke = nil,
        _interval = 0.2,})
	end
	
	-- 发送消息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sent"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_message",      
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 显示表情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_face"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_face_show",     
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 隐藏表情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_face"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_face_hide",      
        but_image = "",     
        terminal_state = 0,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 1)


    --世界
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_list_manager",     
        next_terminal_name = "red_alert_time_chat_sent_list_change", 
        current_button_name = "Button_world",   
        but_image = "",     
        terminal_state = 0,
        page_index = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_chat_count",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_world"),
        _m_type = 1,
        _invoke = nil,
        _interval = 0.2,})
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_system"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_list_manager",     
        next_terminal_name = "red_alert_time_chat_sent_list_change", 
        current_button_name = "Button_system",   
        but_image = "",     
        terminal_state = 0,
        page_index = 5,
    }, nil, 1)
    -- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_chat_system",
    -- _widget = ccui.Helper:seekWidgetByName(root, "Button_system"),
    -- _invoke = nil,
    -- _interval = 0.5,})
	
    --种族
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_race"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_list_manager",     
        next_terminal_name = "red_alert_time_chat_sent_list_change", 
        current_button_name = "Button_race",   
        but_image = "",     
        terminal_state = 0,
        page_index = 2,
    }, nil, 1)

    --公会
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_list_manager",     
        next_terminal_name = "red_alert_time_chat_sent_list_change", 
        current_button_name = "Button_legion",   
        but_image = "",     
        terminal_state = 0,
        page_index = 3,
        fun_open_id = 131,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_chat_count",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_legion"),
        _m_type = 3,
        _invoke = nil,
        _interval = 0.2,})

    --私聊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_list_manager",     
        next_terminal_name = "red_alert_time_chat_sent_list_change", 
        current_button_name = "Button_chat",   
        but_image = "",     
        terminal_state = 0,
        page_index = 4,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_chat_count",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_chat"),
        _m_type = 4,
        _invoke = nil,
        _interval = 0.2,})
    
    --关闭聊天窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_chat_sent"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_window_close_action", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
        touch_black = true,
    }, nil, 3)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_stop"), nil, 
    {
        terminal_name = "red_alert_time_chat_sent_window_close_action", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
        touch_black = true,
    }, nil, 3)
	
	
	self._Image_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_face_arrow_up")
    self._Image_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_face_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_production_arrow_down:stopAllActions()
    self._Image_production_arrow_up:stopAllActions()
    playActions(self._Image_production_arrow_down)
    playActions(self._Image_production_arrow_up)
    self._Image_production_arrow_down:setVisible(false)
    self._Image_production_arrow_up:setVisible(false)
	
	self._ScrollView_face = ccui.Helper:seekWidgetByName(root,"ScrollView_face")
	--列表初始高度
    self.scroll_view_poy = self._ScrollView_face:getInnerContainer():getPositionY()
    self.scroll_view_height = self._ScrollView_face:getInnerContainer():getPositionY()
	
    self._panel_listview = ccui.Helper:seekWidgetByName(root, "Panel_chat_list")
	self:updateDraw()
    -- self:onUpdateDrawPic()
	
	ccui.Helper:seekWidgetByName(root, "Panel_chat_sent_2"):setVisible(false)
	
end

function RedAlertTimeChatSent:onEnterTransitionFinish()

end

-- function RedAlertTimeChatSent:onUpdate(dt)
--     if self._ScrollView_face ~= nil then
--         local size = self._ScrollView_face:getContentSize()
--         local posY = self._ScrollView_face:getInnerContainer():getPositionY()
--         if self.scroll_view_height == 0 then
--             self.scroll_view_height = posY
--         end
--         if self.scroll_view_poy <= -30 then
--             self._Image_production_arrow_down:setVisible(true)
--         else
--             self._Image_production_arrow_down:setVisible(false)
--         end
--         if self.scroll_view_poy >= self.scroll_view_height + 30 then
--             self._Image_production_arrow_up:setVisible(true)
--         else
--             self._Image_production_arrow_up:setVisible(false)
--         end
--         if self.scroll_view_poy == posY then
--             return
--         end
--         self.scroll_view_poy = posY
--     end
-- end

function RedAlertTimeChatSent:init(params)
    self._index = params
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

--移除状态机
function RedAlertTimeChatSent:onExit()
    state_machine.remove("red_alert_time_chat_sent_list_manager")
    state_machine.remove("red_alert_time_chat_sent_list_change")
    state_machine.remove("red_alert_time_chat_sent_window_show")
    state_machine.remove("red_alert_time_chat_sent_window_hide")
    state_machine.remove("red_alert_time_chat_sent_window_close_action")
    state_machine.remove("red_alert_time_chat_sent_message")
    state_machine.remove("red_alert_time_chat_sent_change_to_person_chat")
    state_machine.remove("red_alert_time_voice_send_message")
    state_machine.remove("red_alert_time_switch_chat_sent_type_message")
    state_machine.remove("red_alert_time_chat_show_ship")
    state_machine.remove("red_alert_time_chat_sent_face_show")
    state_machine.remove("red_alert_time_chat_sent_face_hide")
    state_machine.remove("red_alert_time_chat_sent_add_image")
    state_machine.remove("red_alert_time_clear_legion_info")
    state_machine.remove("red_alert_time_chat_push_notification")
    state_machine.remove("red_alert_time_chat_update_chat_infomation")
end

-- function RedAlertTimeChatSent:destroy()

-- end