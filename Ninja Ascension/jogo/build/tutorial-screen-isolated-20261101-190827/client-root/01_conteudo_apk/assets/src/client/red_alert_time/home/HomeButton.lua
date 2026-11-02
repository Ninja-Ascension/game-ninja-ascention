--------------------------------------------------------------------------------------------------------------
--  说明：主页面静态功能按钮
--------------------------------------------------------------------------------------------------------------
HomeButton = class("HomeButtonClass", Window)

--打开界面
local home_button_window_open_terminal = {
    _name = "home_button_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeButtonWindow = fwin:find("HomeButtonClass")
        if nil == _homeButtonWindow then
            fwin:open(HomeButton:new():init(), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local home_button_window_close_terminal = {
    _name = "home_button_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)

        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(home_button_window_open_terminal)
state_machine.add(home_button_window_close_terminal)
state_machine.init()

function HomeButton:ctor()
    self.super:ctor()
    self.roots = {}

    self._select_page = 1       -- 默认显示主页面
	self._sendinfomation_last_infomation = nil
	self._image_wight = 0
    self._Button_function_task = nil
    self._Text_chat_time = nil
    self._last_time = 0

    self._isShowTuition = false

    local function init_home_button_terminal()
        -- 切换显示主页面和世界
        local home_button_select_page_terminal = {
            _name = "home_button_select_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._select_page == params._datas.select_page then
                    return
                end
                if tonumber(params._datas.select_page) == 2 then
                    if funOpenDrawTip(210) == true then
                        return
                    end 
                end
                instance._select_page = params._datas.select_page 
                instance:updateDraw()
				if zstring.tonumber(instance._select_page) == 2 then
                    if tonumber(_ED.user_info.user_grade) < tonumber(world_push_tip[1]) then
                        TipDlg.drawTextDailog(world_push_tip[2])
                    end
                    local nCount = #fwin._list
                    for i=1, nCount do
                        local v = fwin._list[nCount - i + 1]
                        if nil ~= v and v._view ~= nil and v._view == fwin._ui 
                            and "redAlertTimeMineEventQueueMarchClass" ~= v.__cname
                            and "redAlertTimeMineEventQueueStruckClass" ~= v.__cname
                            and "redAlertTimeMineEventQueueDefenseClass" ~= v.__cname
                            then
                            fwin:close(v)
                        end
                    end
                    if nil == _ED.world_map then
                        local function responseWorldInfoInitCallBack(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil then 
                                    state_machine.excute("adventure_mine_record_view_position", 0, 0)
                                    state_machine.excute("main_window_hide", 0, "main_window_hide.")
                                    -- app.load("client.red_alert_time.worldMap.redAlertTimeMineManger")
                                    -- state_machine.excute("red_alert_time_mine_manager_open", 0, true)
                                    app.load("client.adventure.campaign.mine.AdventureMineManager")
                                    state_machine.excute("adventure_mine_update_view_position", 0, 0)
                                    state_machine.excute("adventure_mine_manager_open",0,false)
                                end
                            end
                        end
                        NetworkManager:register(protocol_command.world_info_init.code, nil, nil, nil, instance, responseWorldInfoInitCallBack, false, nil)
                    else
                        state_machine.excute("main_window_hide", 0, "main_window_hide.")
                        -- app.load("client.red_alert_time.worldMap.redAlertTimeMineManger")
                        -- state_machine.excute("red_alert_time_mine_manager_open", 0, true)
                        app.load("client.adventure.campaign.mine.AdventureMineManager")
                        -- state_machine.excute("adventure_mine_update_view_position", 0, 0)
                        state_machine.excute("adventure_mine_reset_boss_update_draw", 0, 0)
                        NetworkManager:register(protocol_command.world_join.code, nil, nil, nil, nil, nil, false, nil)
                        state_machine.excute("adventure_mine_manager_open",0,false)
                    end
                else
                    if tonumber(_ED.user_info.user_grade) < tonumber(world_push_tip[1]) then
                        if params._datas.draw_text ~= false then
                            TipDlg.drawTextDailog(world_push_tip[3])
                        end
                    end
                    state_machine.excute("main_window_show", 0, "main_window_show.")
                    state_machine.excute("adventure_mine_manager_hide", 0, "")
                    if zstring.tonumber(_ED.user_info.booming)~=zstring.tonumber(_ED.user_info.forage) then
                        local function respondCallBack(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil then
                                    state_machine.excute("main_window_update_boom_info", 0, nil)
                                end
                            end
                        end
                        NetworkManager:register(protocol_command.check_boom_recover.code, nil, nil, nil, self, respondCallBack, false, nil)
                    end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示所有
        local home_button_window_show_terminal = {
            _name = "home_button_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local home_button_window_hide_terminal = {
            _name = "home_button_window_hide",
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
		
		-- 请求世界事件信息
        local home_button_window_request_world_events_terminal = {
            _name = "home_button_window_request_world_events",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if nil ~= _ED.user_info
                and nil ~= _ED.user_info.user_grade
                and zstring.tonumber(_ED.user_info.user_grade) >= 5 then
                    if nil == _ED.world_map then
    					local function responseWorldInfoInitCallBack(response)
    						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    							if response.node ~= nil and response.node.roots ~= nil then 
    								state_machine.excute("adventure_mine_record_view_position", 0, 0)
    								app.load("client.adventure.campaign.mine.AdventureMineManager")
    								state_machine.excute("adventure_mine_update_view_position", 0, 0)
    							end
    						end
    					end
    					NetworkManager:register(protocol_command.world_info_init.code, nil, nil, nil, instance, responseWorldInfoInitCallBack, false, nil)
    				end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 聊天刷新
        local red_alert_time_button_update_chat_info_terminal = {
            _name = "red_alert_time_button_update_chat_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateChatInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_button_window_update_map_state_terminal = {
            _name = "home_button_window_update_map_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._select_page == 2 then
                    return
                end
                instance._select_page = 2
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 基地被袭击红屏动画
        local home_button_window_world_damage_time_terminal = {
            _name = "home_button_window_world_damage_time",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params[1]
                instance:WorldDamageTime(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 聊天入口
        local home_button_window_open_chat_terminal = {
            _name = "home_button_window_open_chat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params._datas._page ~= nil then
                    state_machine.excute("red_alert_time_chat_sent_window_open", 0, 1)
                else
                    local page = 1
                    local channelType = 0
                    if instance._sendinfomation_last_infomation ~= nil then
                        channelType = tonumber(instance._sendinfomation_last_infomation.information_type)
                    end
                    if channelType == 0 
                        or channelType == 1 
                        or channelType == 5 then
                        page = 1
                    elseif channelType == 3 then
                        if _ED.union.union_info == nil 
                            or _ED.union.union_info == {} 
                            or _ED.union.union_info.union_id == nil 
                            or _ED.union.union_info.union_id == "" 
                            or tonumber(_ED.union.union_info.union_id) == 0 
                            then
                            page = 1
                        else
                            page = 3
                        end
                    elseif channelType == 4 then
                        page = 4
                    end
                    state_machine.excute("red_alert_time_chat_sent_window_open", 0, page)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 叛军出没动画
        local home_button_window_world_effect_rebel_presence_terminal = {
            _name = "home_button_window_world_effect_rebel_presence",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:rebelPresence()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(home_button_select_page_terminal)
        state_machine.add(home_button_window_show_terminal)
        state_machine.add(home_button_window_hide_terminal)
        state_machine.add(home_button_window_request_world_events_terminal)
        state_machine.add(red_alert_time_button_update_chat_info_terminal)
        state_machine.add(home_button_window_update_map_state_terminal)
        state_machine.add(home_button_window_world_damage_time_terminal)
        state_machine.add(home_button_window_open_chat_terminal)
        state_machine.add(home_button_window_world_effect_rebel_presence_terminal)
        state_machine.init()
    end
    init_home_button_terminal()
end

--显示
function HomeButton:onShow()
   self:setVisible(true)
end

--隐藏
function HomeButton:onHide()
   self:setVisible(false)
end

function HomeButton:rebelPresence()
    local root = self.roots[1]
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_rebel_presence)
    local armature = ccs.Armature:create("effect_rebel_presence")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(root:getContentSize().width/2, root:getContentSize().height/2))
    local function changeActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
    end
    armature._invoke = changeActionCallback
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    root:addChild(armature)
end

function HomeButton:updateDraw()
    local root = self.roots[1]

    local Button_funcion_home = ccui.Helper:seekWidgetByName(root, "Button_funcion_home")
    local Button_funcion_res = ccui.Helper:seekWidgetByName(root, "Button_funcion_res")

    if self._select_page == 1 then
        Button_funcion_home:setVisible(false)
        Button_funcion_res:setVisible(true)
        _ED.current_window_in_main_city = true
    else
        Button_funcion_home:setVisible(true)
        Button_funcion_res:setVisible(false)
        _ED.current_window_in_main_city = false
    end
end

--给一个时间如:153000,得到今天15:30:00的时间戳 
function HomeButton:getIntervalByTime( time )
	local temp = os.date("*t",getBaseGTM8Time(time))

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)

	local timeString = m_hour ..":".. m_min ..":".. m_sec

    return timeString
end

function HomeButton:onUpdateChatInfo()
	local root = self.roots[1]
	local Text_chat_infor = ccui.Helper:seekWidgetByName(root,"Text_chat_infor")
	if _ED.send_chat_view_information == nil or #_ED.send_chat_view_information == 0 then
        return
    end
	if self._sendinfomation_last_infomation ~= _ED.send_chat_view_information[#_ED.send_chat_view_information] then
        self:updateDrawChat()
        -- Image_push:setVisible(true)
        -- if tonumber(self._sendinfomation_last_infomation.information_type) == 0 
        -- or tonumber(self._sendinfomation_last_infomation.information_type) == 5 then
            -- _ED._push_chat_system = 1
        -- elseif tonumber(self._sendinfomation_last_infomation.information_type) == 1 then
            -- _ED._push_chat_world = 1
        -- elseif tonumber(self._sendinfomation_last_infomation.information_type) == 3 then
            -- _ED._push_chat_private = 1
        -- end
        
        self._sendinfomation_last_infomation = _ED.send_chat_view_information[#_ED.send_chat_view_information]
    end
	
end

function HomeButton:updateDrawChat()
	local root = self.roots[1]
	local Text_chat_infor = ccui.Helper:seekWidgetByName(root, "Text_chat_infor")
	Text_chat_infor:removeAllChildren(true)
    local panel = nil
    local height_number = 0
    for i = #_ED.send_chat_view_information, 1, -1 do
        if _ED.send_chat_view_information[i].isShow == true
            and tonumber(_ED.send_chat_view_information[i].information_type) ~= 9
            then
            local panel,height_number = self:createChatCell(_ED.send_chat_view_information[i],self._image_wight, Text_chat_infor:getContentSize().height)
            -- local panel,height_number = self:createChatCell(_ED.send_chat_view_information[#_ED.send_chat_view_information],self._image_wight)
            Text_chat_infor:addChild(panel)
            break
        end
    end
	
end

function HomeButton:createChatCell(chat_info, width, text_height)

    local panel = ccui.Layout:create()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setContentSize(cc.size(width, 0))

    -- local sprite_camp = cc.Sprite:create("images/ui/quality/camp_icon_smlle_".. chat_info.send_information_camp .. ".png")
    -- panel:addChild(sprite_camp)
    local re1 = nil
    local re2 = nil
    local re3 = nil
    local reimg = nil
    local fontSize = 20
    -- debug.print_r(chat_info)
    local string_info = ""
    local channelType = tonumber(chat_info.information_type)
    local send_information_id = tonumber(chat_info.send_information_id)
    local send_draw_info = chat_info.information_content
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        if channelType == 1 or (channelType == 3 and send_information_id ~= 0) 
            or channelType == 4 then
            fontName = ""
        end
    end
    local texts_info = zstring.split(zstring.exchangeTo(send_draw_info), "&#13;&#10;")
    local textDatas = ""
    if #texts_info>1 then
        textDatas = "\r\n"..zstring.exchangeFrom(texts_info[2])
    else
        textDatas = zstring.exchangeFrom(texts_info[1])
    end
    local params = zstring.split(textDatas, chat_section[1])
    if params[2] ~= nil or texts_info[2] ~= nil then
        fontName = config_res.font.font_name
    end
	-- print(send_draw_info)
	-- local f,e = string.find(send_draw_info, "%%%C-%%")
	-- if f == nil or e == nil then
		-- for i=1,#expression_onversion do
			-- local str2=string.gsub(send_draw_info, expression_onversion[i][1], expression_onversion[i][2])
			-- send_draw_info = str2
		-- end
	-- end
	local params_one = zstring.split(send_draw_info, "&|&")
	if nil ~= params_one and #params_one == 5 then
		send_draw_info = "["..params_one[5].."]"
	end
    -- if tonumber(chat_info.send_information_arena_id) <= 3 and tonumber(chat_info.send_information_arena_id) ~= 0 then
    --     local color_table = red_alert_officer_color[chat_info.user_official]
    --     re1 = ccui.RichElementText:create(1, cc.c3b(color_table[1],color_table[2],color_table[3]),255, red_alert_officer[chat_info.user_official], "fonts/simhei.ttf", fontSize)
        -- re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[20][1],color_Type[20][2],color_Type[20][3]),255, chat_info.send_information_name..":", "fonts/simhei.ttf", fontSize)
        -- string_info = red_alert_officer[chat_info.user_official] .. chat_info.send_information_name..":"
    -- else
        if channelType ~= 0 
            and channelType ~= 5 
            and channelType ~= 8
            then
			if chat_info.send_information_name == _ED.user_info.user_name then
				chat_info.send_information_name = chat_section[3]
			end
            if tonumber(chat_info.send_information_id) == 0 then
                if tonumber(chat_info.information_type) == 3 then
                    chat_info.send_information_name = chat_section[4]
                else
                    chat_info.send_information_name = chat_section[2]
                end
            end
        else
            chat_info.send_information_name = chat_section[2]
        end
        re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, chat_info.send_information_name..":", fontName, fontSize)
        string_info = chat_info.send_information_name..":"
    -- end
    if channelType == 0 
        or channelType == 8 then--系统
        reimg = nil -- ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/chat_horn_icon.png")
    else
        reimg = nil
    end
    -- if tonumber(chat_info.send_information_arena_id) == 1 then
    --     re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[22][1],color_Type[22][2],color_Type[22][3]),255, chat_info.information_content, "fonts/simhei.ttf", fontSize)
    -- elseif tonumber(chat_info.information_type) == 0 then
    --     re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[23][1],color_Type[23][2],color_Type[23][3]),255, chat_info.information_content, "fonts/simhei.ttf", fontSize)
    -- else
    --     re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[24][1],color_Type[24][2],color_Type[24][3]),255, chat_info.information_content, "fonts/simhei.ttf", fontSize)
    -- end
	local params = zstring.split(send_draw_info, chat_section[1])
	if #params > 1 then
		send_draw_info = params[1]
	end
    string_info = string_info ..send_draw_info
    if _richText.formatTextExt ~= nil then
        _richText:setAnchorPoint(0, 0.5)
        panel:setAnchorPoint(0, 0.5)
    else
        _richText:setAnchorPoint(0.5,1)
        -- sprite_camp:setAnchorPoint(0,1)
        panel:setAnchorPoint(0.5,1)
    end
    if reimg ~= nil then
        _richText:pushBackElement(reimg)
    end
    if re1 ~= nil then
        _richText:pushBackElement(re1)
    end
    if re2 ~= nil then
        _richText:pushBackElement(re2)
    end
    if re3 ~= nil then
        _richText:pushBackElement(re3)
    end
    local color = nil
    if nil ~= params_one and #params_one == 5 then
        local quality = zstring.tonumber(params_one[4])
        color = chat_message_quality_color[quality + 1]
    else
        if channelType == 0 or channelType == 5 then
            color = chat_message_color[4]
        else
            color = chat_message_color[3]
        end
    end
	_richText:setContentSize(cc.size(10000,fontSize))
	-- print("send_draw_info=="..send_draw_info)
    local rt, count, text = draw.richTextCollectionMethod(_richText, 
        send_draw_info, 
        color,
        color,
        0, 
        0, 
        fontName, 
        fontSize,
        chat_rich_text_color)

    local enter_size = 20
    local enter_lenth = enter_size * 4
    local height_number = 1
    local len_size = 0
    local map = string.utf8.chars(string_info .. text)
	
    for i,v in pairs(map) do
        len_size = len_size + string.len(v)
        if len_size >= enter_lenth then
            height_number = height_number + 1
            len_size = len_size - enter_size*4
        end
    end

    -- _richText:setPosition(cc.p(_richText:getContentSize().width/2 + sprite_camp:getContentSize().width,height_number * sprite_camp:getContentSize().height))
    -- sprite_camp:setPosition(cc.p(0,height_number * sprite_camp:getContentSize().height))
    -- panel:setContentSize(cc.size(_richText:getContentSize().width,height_number * sprite_camp:getContentSize().height))
    if _richText.formatTextExt ~= nil then
        _richText:formatTextExt()
        local rsize = _richText:getContentSize()
        _richText:setPositionY(rsize.height)
        panel:setContentSize(rsize)
        panel:setPositionY(text_height / 2)
    else
        _richText:setPosition(cc.p(_richText:getContentSize().width/2, height_number * fontSize))
        panel:setContentSize(cc.size(_richText:getContentSize().width, height_number * fontSize))
    end

    panel:addChild(_richText)
    -- if nil ~= params_one and #params_one == 5 then
        -- panel:setTouchEnabled(true)
        -- fwin:addTouchEventListener(panel, nil, 
        -- {
            -- terminal_name = "chat_view_window_user_showing_info", 
            -- terminal_state = 0, 
            -- cell = self, 
            -- touch_scale = true,
            -- touch_scale_xy = 0.95, 
            -- message = params_one,
        -- }, nil, 1)
    -- end
     
    return panel,height_number
end

function HomeButton:onUpdate(dt)
	local new_time = tonumber(_ED.system_time) + (os.time() - tonumber(_ED.native_time))
    if self._last_time ~= new_time then
        local root = self.roots[1]
        self._Text_chat_time:setString(self:getIntervalByTime(new_time))
    end
    -- local last_list_view_pos = self._list_view_pos
    -- self._list_view_pos = self._list_view:getInnerContainer():getPosition()
    -- if fwin._touch_wait_time > 15 then
    --     if tonumber(_ED.user_info.user_grade) <= 10
    --         and nil ~= self._Button_function_task 
    --         -- and true ~= self._Button_function_task._locked 
    --         and missionIsOver() == true
    --         then
    --         local showController = true
    --         for i, v in pairs(fwin._list) do
    --             if nil ~= v and v._view ~= nil and v._view._z > 10000 and v._view._z < 70000 then
    --                 showController = false
    --                 break
    --             end
    --         end
    --         if showController == true 
    --             and self._list_view_pos > -200
    --             then
    --             self._isShowTuition = true
    --             -- self._Button_function_task:setHighlighted(true)
    --             -- self._Button_function_task._locked = true
    --             state_machine.excute("tuition_controller_touch_normal", 0, {self._Button_function_task, true})
    --         end
    --     end
    --     fwin._touch_wait_time = 0
    -- end
    -- if fwin:find("TuitionControllerClass") ~= nil then
    --     if self._list_view_pos ~= last_list_view_pos
    --         and self._isShowTuition == true 
    --         then
    --         self._isShowTuition = false
    --         state_machine.excute("tuition_controller_exit", 0, nil)
    --     end
    -- else
    --     self._isShowTuition = false
    -- end
end

function HomeButton:WorldDamageTime(index)
    local root = self.roots[1]
    if root:getChildByTag(852) ~= nil then
        return
    end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_world_damage_time)
    local armature = ccs.Armature:create("effect_world_damage_time")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(root:getContentSize().width/2, root:getContentSize().height/2+90))
    local function changeActionCallback( armatureBack )
        if armatureBack._index >= 6 then
            armatureBack:removeFromParent(true)
        else
            armatureBack._index = armatureBack._index + 1
        end
    end
    armature._index = index
    armature._invoke = changeActionCallback
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature:setTag(852)
    root:addChild(armature)
end

function HomeButton:onInit()
    local csbItem = csb.createNode(config_csb.home.home_button)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Text_chat_time = ccui.Helper:seekWidgetByName(root, "Text_chat_time")
    self._last_time = 0
    self.__cdt = 1

    self._list_view = ccui.Helper:seekWidgetByName(root, "ListView_function_but")
    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_funcion_home"), nil, 
    {
        terminal_name = "home_button_select_page",
        terminal_state = 0,
        touch_scale_xy = 0.95, 
        touch_black = true,
        select_page = 1,
    }, nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_funcion_res"), nil, 
    {
        terminal_name = "home_button_select_page",
        terminal_state = 0,
        touch_scale_xy = 0.95, 
        touch_black = true,
        select_page = 2,
    }, nil, 2)

    -- 征战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_pve"), nil, 
    {
        terminal_name = "pve_manager_window_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_pve",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_function_pve"),
    _invoke = nil,
    _interval = 0.2,})
    
    -- 阵型
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_troops"), nil, 
    {
        terminal_name = "formation_window_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
    },
    nil,1)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_formation",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_function_troops"),
    _invoke = nil,
    _interval = 0.2,})

    -- 任务
    self._Button_function_task = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_task"), nil, 
    {
        terminal_name = "task_window_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_task",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_function_task"),
    _invoke = nil,
    _interval = 0.2,})
    
    -- 背包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_package"), nil, 
    {
        terminal_name = "props_shop_packs_window_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
        page_index = 2,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_packs",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_function_package"),
    _invoke = nil,
    _interval = 0.2,})
    
    -- 邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_mail"), nil, 
    {
        terminal_name = "mail_window_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
    },
    nil,1)
	
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_push",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_function_mail"),
	_m_type = 0,
    _invoke = nil,
    _interval = 0.2,})
	   
    -- 配件
    local Button_function_parts = ccui.Helper:seekWidgetByName(root,"Button_function_parts")
    if Button_function_parts ~= nil then
        fwin:addTouchEventListener(Button_function_parts, nil, 
        {
            terminal_name = "equipment_window_open",
            terminal_state = 0,
            touch_scale_xy = 0.95,
        },
        nil,1)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment",
        _widget = Button_function_parts,
        _invoke = nil,
        _interval = 0.2,})
    end
    
    -- 好友
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_friend"), nil, 
    {
        terminal_name = "game_social_platforms_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
		page = 1,
    },
    nil,1)
    --赠送能量推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_friend_give_energy",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_function_friend"),
    _m_type = 0,
    _invoke = nil,
    _interval = 0.2,})

    -- 商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_shop"), nil, 
    {
        terminal_name = "props_shop_packs_window_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
        page_index = 1,
    },
    nil,1)
    -- 排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_rank"), nil, 
    {
        terminal_name = "rank_window_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
        list_type = 1,
    },
    nil,1)
	--聊天功能入口
	ccui.Helper:seekWidgetByName(root,"Text_chat_infor"):setTouchEnabled(true)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Text_chat_infor"), nil, 
    {
        terminal_name = "home_button_window_open_chat",
        terminal_state = 0,
        touch_scale_xy = 0.95,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_wold_chat_icon"), nil, 
    {
        terminal_name = "home_button_window_open_chat",
        terminal_state = 0,
        touch_scale_xy = 0.95,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_chat_icon"), nil, 
    {
        terminal_name = "home_button_window_open_chat",
        terminal_state = 0,
        touch_scale_xy = 0.95,
        _page = 1,
    },
    nil,1)
    --赠送能量推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_friend_give_energy",
    _widget = ccui.Helper:seekWidgetByName(root, "Image_chat_icon"),
    _m_type = 0,
    _invoke = nil,
    _interval = 0.2,})
	
    --帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_help"), nil, 
    {
        terminal_name = "help_window_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
    },
    nil,1)

    local Button_function_armor = ccui.Helper:seekWidgetByName(root,"Button_function_armor")
    if Button_function_armor ~= nil then
        fwin:addTouchEventListener(Button_function_armor, nil, 
        {
            terminal_name = "armor_window_open",
            terminal_state = 0,
            touch_scale_xy = 0.95,
        },
        nil,1)
        --装甲仓库推送
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_armor_pack",
        _widget = Button_function_armor,
        _m_type = 0,
        _invoke = nil,
        _interval = 0.2,})
    end

	--设置入口
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_set"), nil, 
    {
        terminal_name = "red_alert_time_system_settings_open",
        terminal_state = 0,
        touch_scale_xy = 0.95,
    },
    nil,1)

    if ccui.Helper:seekWidgetByName(root,"Button_function_legion") ~= nil then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_function_legion"), nil, 
        {
            terminal_name = "legion_window_open",
            terminal_state = 0,
            touch_scale_xy = 0.95,
        },
        nil,1)
    end
	
	self._image_wight = ccui.Helper:seekWidgetByName(root,"Text_chat_infor"):getContentSize().width
	
    self:updateDraw()
	state_machine.excute("home_button_window_request_world_events", 0, 0)
	state_machine.excute("red_alert_time_button_update_chat_info",0,"")
	
end

function HomeButton:onEnterTransitionFinish()

end

function HomeButton:init()
    self:onInit()
    return self
end

function HomeButton:onExit()
    state_machine.remove("home_button_select_page")
    state_machine.remove("home_button_window_show")
    state_machine.remove("home_button_window_hide")
    state_machine.remove("home_button_window_request_world_events")
    state_machine.remove("red_alert_time_button_update_chat_info")
    state_machine.remove("home_button_window_update_map_state")
    state_machine.remove("home_button_window_world_damage_time")
    state_machine.remove("home_button_window_open_chat")
    state_machine.remove("home_button_window_world_effect_rebel_presence")
end