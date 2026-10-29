--------------------------------------------------------------------------------------------------------------
--  说明：聊天系统入口
--------------------------------------------------------------------------------------------------------------
ChatView = class("ChatViewClass", Window)

--打开界面
local chat_view_window_open_terminal = {
	_name = "chat_view_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(99) == true then
            return
        end 
        if fwin:find("ChatViewClass") == nil then
		   fwin:open(ChatView:new():init(),fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local chat_view_window_close_terminal = {
	_name = "chat_view_window_close",
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

-- 查看玩家的展示信息
local chat_view_window_user_showing_info_terminal = {
    _name = "chat_view_window_user_showing_info",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function responseUserShowingInfoCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --load lua file
                app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMain")
                app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroAttributes")
                app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroFetters")
                app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMainGrowUp")
                app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMainSkillsUp")
                app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMainStarUp")
                app.load("client.red_alert.other_players_information.other_players_equipstorage.OtherPlayersEquipment")
                app.load("client.red_alert.other_players_information.other_players_equipstorage.other_players_equipment_gem_input_cell")
                
                local ship = nil
                for i, v in pairs(_ED.other_user_ship) do
                    ship = v
                end
                state_machine.excute("other_players_hero_main_window_open",0,ship) 
            end
        end
        _ED.other_user_ship = nil
        local message = params._datas.message
        protocol_command.get_user_showing_info.param_list = message[1] .. "\r\n" .. message[2] .. "\r\n" .. message[3]
        NetworkManager:register(protocol_command.get_user_showing_info.code, nil, nil, nil, nil, responseUserShowingInfoCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(chat_view_window_open_terminal)
state_machine.add(chat_view_window_close_terminal)
state_machine.add(chat_view_window_user_showing_info_terminal)
state_machine.init()

function ChatView:ctor()
	self.super:ctor()
	self.roots = {}
	
    --var image_wight 
    self._image_wight = nil
    --var sendinfomation_count 
    self._sendinfomation_last_infomation = nil
    --load lua file
    app.load("client.red_alert.cells.chats.chat_sent_other_player_cell")
    app.load("client.red_alert.cells.chats.chat_sent_player_cell")
    app.load("client.red_alert.cells.chats.chat_sent_world_cell")
    app.load("client.red_alert.chat.ChatSent")
    app.load("client.red_alert.chat.ChatSentList")
    app.load("client.red_alert.cells.chats.chat_sent_face_cell")
	 -- Initialize alert_home state machine.
    local function init_chat_view_terminal()
		
		
		--显示所有
		local chat_view_window_show_terminal = {
            _name = "chat_view_window_show",
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
        local chat_view_window_hide_terminal = {
            _name = "chat_view_window_hide",
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

                -- 聊天刷新
        local chat_view_update_chat_info_terminal = {
            _name = "chat_view_update_chat_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateChatInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	       
       
		state_machine.add(chat_view_window_show_terminal)
		state_machine.add(chat_view_window_hide_terminal)			
        state_machine.add(chat_view_update_chat_info_terminal)
        state_machine.init()
    end
   
    init_chat_view_terminal()

end

--显示界面
function ChatView:onShow()
	self:setVisible(true)
end

--隐藏界面
function ChatView:onHide()
	self:setVisible(false)
end

function ChatView:updateDraw()
    local root = self.roots[1]
    self._list_view:removeAllItems()
    for i = math.max(#_ED.send_chat_view_information - 3,1) ,#_ED.send_chat_view_information do
        local panel = self:createChatCell(_ED.send_chat_view_information[i],self._image_wight)
        self._list_view:addChild(panel)
    end

    self._sendinfomation_last_infomation = _ED.send_chat_view_information[#_ED.send_chat_view_information]
    self._list_view_cell_count = 0
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view:getInnerContainer():setPositionY(500000)
    self._list_view:requestRefreshView()
end

function ChatView:onUpdateChatInfo()
    local root = self.roots[1]
    if _ED.send_chat_view_information == nil or #_ED.send_chat_view_information == 0 then
        return
    end
    
    local Image_push = ccui.Helper:seekWidgetByName(root, "Image_push")
    -- Image_push:setVisible(false)
    if self._sendinfomation_last_infomation ~= _ED.send_chat_view_information[#_ED.send_chat_view_information] then
        self:updateDraw()
        Image_push:setVisible(true)
        if tonumber(self._sendinfomation_last_infomation.information_type) == 0 
        or tonumber(self._sendinfomation_last_infomation.information_type) == 5 then
            _ED._push_chat_system = 1
        elseif tonumber(self._sendinfomation_last_infomation.information_type) == 1 then
            _ED._push_chat_world = 1
        elseif tonumber(self._sendinfomation_last_infomation.information_type) == 3 then
            _ED._push_chat_private = 1
        end
        
        self._sendinfomation_last_infomation = _ED.send_chat_view_information[#_ED.send_chat_view_information]
    end
    if fwin:find("ChatSentClass") ~= nil then
        _ED._push_chat_world = 0
        if _ED._push_chat_system == 0 and _ED._push_chat_world == 0 and _ED._push_chat_private == 0 then
            Image_push:setVisible(false)
        end
    end
end

function ChatView:createChatCell(chat_info,width)
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
	local send_draw_info = chat_info.information_content
	
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
        if channelType ~= 0 and channelType ~= 5 then
            re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[20][1],color_Type[20][2],color_Type[20][3]),255, "["..chat_info.send_information_name.."]", "fonts/simhei.ttf", fontSize)
            string_info = "["..chat_info.send_information_name.."]"
        end
    -- end

    if channelType == 0 then--系统
        reimg = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/chat_tape_3.png")
    elseif channelType == 1 then--世界
        reimg = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/chat_tape_1.png")
    elseif channelType == 2 then--军团
        reimg = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/chat_tape_2.png")
    elseif channelType == 3 then--私聊
        reimg = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/chat_tape_4.png")
    elseif channelType == 5 then -- GM
        reimg = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/chat_tape_3.png")
    end
    -- if tonumber(chat_info.send_information_arena_id) == 1 then
    --     re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[22][1],color_Type[22][2],color_Type[22][3]),255, chat_info.information_content, "fonts/simhei.ttf", fontSize)
    -- elseif tonumber(chat_info.information_type) == 0 then
    --     re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[23][1],color_Type[23][2],color_Type[23][3]),255, chat_info.information_content, "fonts/simhei.ttf", fontSize)
    -- else
    --     re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[24][1],color_Type[24][2],color_Type[24][3]),255, chat_info.information_content, "fonts/simhei.ttf", fontSize)
    -- end
    string_info = string_info ..send_draw_info
    if _richText.formatTextExt ~= nil then
        _richText:setAnchorPoint(0, 0)
        panel:setAnchorPoint(0, 0)
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
    local rt, count, text = draw.createMessageRichText(_richText, 
        send_draw_info, 
        color,
        color,
        0, 
        0, 
        "fonts/simhei.ttf", 
        fontSize,
        chat_message_quality_color)


    local enter_size = 12
    local enter_lenth = enter_size * 3
    local height_number = 1
    local len_size = 0
    local map = string.utf8.chars(string_info .. text)
    for i,v in pairs(map) do
        len_size = len_size + string.len(v)
        if len_size >= enter_lenth then
            height_number = height_number + 1
            len_size = len_size - enter_size*3
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
    else
        _richText:setPosition(cc.p(_richText:getContentSize().width/2, height_number * fontSize))
        panel:setContentSize(cc.size(_richText:getContentSize().width, height_number * fontSize))
    end
    panel:addChild(_richText)

    if nil ~= params_one and #params_one == 5 then
        panel:setTouchEnabled(true)
        fwin:addTouchEventListener(panel, nil, 
        {
            terminal_name = "chat_view_window_user_showing_info", 
            terminal_state = 0, 
            cell = self, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            message = params_one,
        }, nil, 0)
    end
     
    return panel
end
--初始化界面
function ChatView:onInit()
    local csbItem = csb.createNode(config_csb.chats.chat_view)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  
    --打开聊天窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_home_chat"), nil, 
    {
        terminal_name = "chat_sent_window_open", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_home_chat_bg"), nil, 
    {
        terminal_name = "chat_sent_window_open",
        terminal_state = 0, 
        cell = self
    }, nil, 0)    
    local sprite_camp = cc.Sprite:create("images/ui/quality/camp_icon_smlle_1.png")    
    self._list_view = ccui.Helper:seekWidgetByName(root,"ListView_chat")
    local width = self._list_view:getContentSize().width
    self._image_wight = width - sprite_camp:getContentSize().width - 5
	self:updateDraw()
end

function ChatView:onEnterTransitionFinish()
 
end

function ChatView:init()
	self:onInit()
    return self
end

--移除状态机
function ChatView:onExit()
    state_machine.remove("chat_view_window_show")
    state_machine.remove("chat_view_window_hide")
    state_machine.remove("chat_view_update_chat_info") 
end