-----------------------------
--聊天cell
-----------------------------
ChatSentOtherPlayerCell = class("ChatSentOtherPlayerCellClass", Window)
ChatSentOtherPlayerCell.__size = nil
ChatSentOtherPlayerCell._image_size = nil
--创建cell
local chat_sent_other_player_create_cell_terminal = {
    _name = "chat_sent_other_player_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local chat_info = params[1]
        local index = params[2]
        local cell = ChatSentOtherPlayerCell:new()
        cell:init(chat_info,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(chat_sent_other_player_create_cell_terminal)
state_machine.init()

function ChatSentOtherPlayerCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._chat_info = nil
    self.copy_information_content = ""

    local function init_chat_sent_other_player_cell_terminal()
        -- local get_the_way_to_open_other_terminal = {
        --     _name = "get_the_way_to_open_other",
        --     _init = function (terminal)
                
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --         local cell = params._datas.cell
        --         state_machine.excute("short_cut_go_to_other_window",0,{cell.get_way_id})
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- }
        -- state_machine.add(get_the_way_to_open_other_terminal)
        -- state_machine.init()
    end
    init_chat_sent_other_player_cell_terminal()
end

function ChatSentOtherPlayerCell:onEnterTransitionFinish()

end

function ChatSentOtherPlayerCell:onUpdateDraw()
    local root = self.roots[1]

    local Panel_player_header = ccui.Helper:seekWidgetByName(root,"Panel_player_header")
    Panel_player_header:removeAllChildren(true)
    local user_data = {
        user_level = self._chat_info.send_information_user_level,
        user_sex = self._chat_info.send_information_sex,
        user_camp = self._chat_info.send_information_camp
    }   
    local head_icon = state_machine.excute("user_head_icon_create",0,{user_data})
    Panel_player_header:addChild(head_icon)

    local Panel_race = ccui.Helper:seekWidgetByName(root,"Panel_race")
    Panel_race:removeBackGroundImage()
    -- Panel_race:setBackGroundImage(string.format("images/ui/quality/camp_icon_%d.png", _ED.user_info.user_force))
    -- Panel_race:setBackGroundImage(string.format("images/ui/quality/camp_icon_%d.png", user_data.user_camp))
    local Panel_name = ccui.Helper:seekWidgetByName(root,"Panel_name")
    Panel_name:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false) 

    local re1 = nil
    local re2 = nil
    local re3 = nil
    local vip = nil
    local vipLevel = nil
    local color_table = red_alert_officer_color[self._chat_info.user_official]
    if self._chat_info.user_official ~= nil then
        re1 = ccui.RichElementText:create(1, cc.c3b(color_table[1],color_table[2],color_table[3]),255, red_alert_officer[self._chat_info.user_official], "fonts/simhei.ttf",20)
        re2 = ccui.RichElementText:create(1, chat_message_color[1], 255, self._chat_info.send_information_name , "fonts/simhei.ttf",20)
        re3 = ccui.RichElementText:create(1, chat_message_color[2], 255, self._chat_info.send_information_time.. " " , "fonts/simhei.ttf",20)
    else
        re2 = ccui.RichElementText:create(1, chat_message_color[1], 255, self._chat_info.send_information_name, "fonts/simhei.ttf",20)
        re3 = ccui.RichElementText:create(1, chat_message_color[2], 255, self._chat_info.send_information_time.. " " , "fonts/simhei.ttf",20)
    end

    if re1 ~= nil then
        _richText:pushBackElement(re1)
    end
    if re2 ~= nil then
        _richText:pushBackElement(re2)
    end

    local vipNumber = zstring.tonumber(self._chat_info.vip_level)
    if vipNumber > 0 then
        vip = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/text_vip.png")
        vipLevel = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/text_vip_".. vipNumber .. ".png")
        _richText:pushBackElement(vip)
        _richText:pushBackElement(vipLevel)
    end
    if re3 ~= nil then
        _richText:pushBackElement(re3)
    end

    _richText:setContentSize(cc.size(380,20))
    -- _richText:setAnchorPoint(0.24,0.45)
    _richText:setAnchorPoint(0.30,0.45)
    Panel_name:addChild(_richText)

    self.copy_information_content = self._chat_info.information_content
    --文字处理
    if nil ~= _richText.formatTextExt then
        local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
        local fontSize = Text_chat_sent_inner:getFontSize()
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        _richText2:setContentSize(cc.size(400, 0))
        _richText2:setAnchorPoint(cc.p(0, 0))
        local char_str = self._chat_info.information_content
        local params_one = zstring.split(char_str, "&|&")
        if nil ~= params_one and #params_one == 5 then
            char_str = "["..params_one[5].."]"
        end

        local isHavePic = false
        local infoList = {}
        local l = string.len(self.copy_information_content)
        while l >= 1 do
            local f,e = string.find(self.copy_information_content, "/%d+|")
            if f == nil then
                table.insert(infoList, {1, self.copy_information_content})
                break
            end
            if f > 1 then
                local info = string.sub(self.copy_information_content, 1, f-1)
                table.insert(infoList, {1, info})
            end
            local pic = string.sub(self.copy_information_content, f+1, e-1)
            if tonumber(pic) ~= nil then
                local img = tonumber(pic) - 100
                if img > 0 and img < 63 then
                    local path = string.format("images/ui/chat/face_icon_%d.png", img)
                    table.insert(infoList, {2, path})
                    isHavePic = true
                else
                    local info = string.sub(self.copy_information_content, f, e)
                    table.insert(infoList, {1, info})
                end
            end
            self.copy_information_content = string.sub(self.copy_information_content, e+1, l)
            l = string.len(self.copy_information_content)
        end

        if isHavePic == true then
            local Image_chat_sent_bg = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg")
            Image_chat_sent_bg:setTouchEnabled(false)
            Text_chat_sent_inner:removeAllChildren(true)
            local total_width = 0
            local newline_width = 0 
            local pic_len = 0
            for k,v in pairs(infoList) do
                local richText = nil
                if v[1] == 1 then
                    richText = ccui.RichElementText:create(1, chat_message_color[6], 255, v[2], Text_chat_sent_inner:getFontName(), Text_chat_sent_inner:getFontSize())
                    local len_size = 0
                    local map = string.utf8.chars(v[2])
                    for i,v in pairs(map) do
                        local len = string.len(v)
                        if string.len(v) > 1 then
                            len = string.len(v) - 1
                        end
                        len_size = len_size + len
                    end
                    total_width = total_width + len_size * 10
                else
                    richText = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, v[2])
                    total_width = total_width + 50
                end
                _richText2:pushBackElement(richText)
                if total_width > 400 then
                    pic_len = 1
                    newline_width = total_width - 400
                end
                -- _richText2:formatTextExt()
            end
            _richText2:setPositionX(-190)
            _richText2:setPositionY(12)
            Text_chat_sent_inner:addChild(_richText2)

            if Image_chat_sent_bg._size == nil then
                Image_chat_sent_bg._size = Image_chat_sent_bg:getContentSize()
            end
            local bsize = _richText2:getContentSize()
            bsize.width = total_width + 60 - newline_width
            if bsize.width < Image_chat_sent_bg._size.width then
                bsize.width = Image_chat_sent_bg._size.width
            end
            bsize.height = Image_chat_sent_bg._size.height + bsize.height + pic_len * 45
            Image_chat_sent_bg:setContentSize(bsize)
        else
            local color = nil
            local Image_chat_sent_bg = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg")
            if nil ~= params_one and #params_one == 5 then
                local quality = zstring.tonumber(params_one[4])
                color = chat_message_quality_color[quality + 1]
                Image_chat_sent_bg:setTouchEnabled(true)
                fwin:addTouchEventListener(Image_chat_sent_bg, nil, 
                {
                    terminal_name = "chat_view_window_user_showing_info", 
                    terminal_state = 0, 
                    cell = self,
                    touch_scale = true,
                    touch_scale_xy = 0.95, 
                    message = params_one,   
                }, nil, 0) 
            else
                color = chat_message_color[6]
                Image_chat_sent_bg:setTouchEnabled(false)
            end
            local rtre2 = ccui.RichElementText:create(1, color, 255, char_str, Text_chat_sent_inner:getFontName(), Text_chat_sent_inner:getFontSize())
            _richText2:pushBackElement(rtre2)
            _richText2:formatTextExt()
            Text_chat_sent_inner:removeAllChildren(true)
            _richText2:setPositionX(0)
            Text_chat_sent_inner:addChild(_richText2)

            local Image_chat_sent_bg = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg")
            if Image_chat_sent_bg._size == nil then
                Image_chat_sent_bg._size = Image_chat_sent_bg:getContentSize()
            end
            local bsize = _richText2:getContentSize()
            bsize.width = bsize.width + fontSize * 2.5
            if bsize.width < Image_chat_sent_bg._size.width then
                bsize.width = Image_chat_sent_bg._size.width
            end
            bsize.height = Image_chat_sent_bg._size.height + bsize.height - fontSize
            Image_chat_sent_bg:setContentSize(bsize)
        end
    else
        local enter_size = 20
        local char_str = self._chat_info.information_content
        local params_one = zstring.split(char_str, "&|&")
        if nil ~= params_one and #params_one == 5 then
            char_str = "["..params_one[5].."]"
        end
        local map = string.utf8.chars(char_str)

        local len_size = 0
        local enter_index = 0
        local new_str = ""
        local height_number = 1
        local width_numbers = 0
        for i,v in pairs(map) do
            len_size = len_size + string.len(v)
            if string.len(v) == 1 then
                width_numbers = width_numbers + 16
            elseif string.len(v) == 3 then
                width_numbers = width_numbers + 32
            end
            if len_size >= enter_size*3 then
                new_str = new_str .. v .. "\r\n"
                height_number = height_number + 1
                len_size = len_size - enter_size*3
            else
                new_str = new_str .. v
            end
        end
        -- print("".."\r\n"..new_str)
        local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
        -- debug.print_r(Text_chat_sent_inner:getAnchorPoint())
        if nil ~= params_one and #params_one == 5 then
            local quality = zstring.tonumber(params_one[4])
            Text_chat_sent_inner:setColor(chat_message_quality_color[quality + 1])
            ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):setTouchEnabled(true)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg") , nil, 
            {
                terminal_name = "chat_view_window_user_showing_info", 
                terminal_state = 0, 
                cell = self,
                touch_scale = true,
                touch_scale_xy = 0.95, 
                message = params_one,   
            }, nil, 0) 
        else
            Text_chat_sent_inner:setColor(chat_message_color[6])
        end
        Text_chat_sent_inner:setString(new_str)

        self:setContentSize(cc.size(ChatSentOtherPlayerCell.__size.width,
            ChatSentOtherPlayerCell.__size.height + height_number * (Text_chat_sent_inner:getFontSize() + 6)))
        local image_widght = 0
        if height_number > 1 then
            image_widght = enter_size*(Text_chat_sent_inner:getFontSize() + 6)
        else
            image_widght = math.max(math.min(width_numbers,enter_size*(Text_chat_sent_inner:getFontSize() + 6)) , 100) 
        end
        
        local Image_chat_sent_bg = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg")
        Image_chat_sent_bg:setContentSize(cc.size(image_widght,
            (height_number- 1)*14 + ChatSentOtherPlayerCell._image_size.height))
    end
end

function ChatSentOtherPlayerCell:setSelfContentSize()
       --文字处理
    local enter_size = 20
    local char_str = self._chat_info.information_content
    local map = string.utf8.chars(char_str)

    local len_size = 0
    local new_str = ""
    local height_number = 1
    for i,v in pairs(map) do
        len_size = len_size + string.len(v)
        
        if len_size >= enter_size*3 then
            new_str = new_str .. v .. "\r\n"
            height_number = height_number + 1
            len_size = len_size - enter_size*3
        else
            new_str = new_str .. v
        end
    end

    self:setContentSize(cc.size(ChatSentOtherPlayerCell.__size.width,
        ChatSentOtherPlayerCell.__size.height + height_number * 30))
end

function ChatSentOtherPlayerCell:init(chat_info,index)
    self._chat_info = chat_info
    if index ~= nil and index < 5 then
        self:onInit()
    end
    self:setSelfContentSize()
    return self
end

function ChatSentOtherPlayerCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.chats.chat_sent_other_player_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if ChatSentOtherPlayerCell.__size == nil then
        ChatSentOtherPlayerCell.__size = root:getContentSize()
    end
    if ChatSentOtherPlayerCell._image_size == nil then
        ChatSentOtherPlayerCell._image_size = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):getContentSize()
    end
    --跳转
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_get_way_break_down_1") , nil, 
    {
        terminal_name = "get_the_way_to_open_other", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,   
    }, nil, 0)    
    
        -- 查看用户信息
    ccui.Helper:seekWidgetByName(root,"Panel_player_header"):setTouchEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_player_header") , nil, 
    {
        terminal_name = "user_info_window_open", 
        terminal_state = 0, 
        user_id = self._chat_info.send_information_id,
    }, nil, 0) 
    
    self:onUpdateDraw() 
end

function ChatSentOtherPlayerCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ChatSentOtherPlayerCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_player_header = ccui.Helper:seekWidgetByName(root,"Panel_player_header")
    Panel_player_header:removeAllChildren(true)
    local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
    Text_chat_sent_inner:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.chats.chat_sent_other_player_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ChatSentOtherPlayerCell:onExit()
    local Panel_player_header = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_header")
    if Panel_player_header ~= nil then
        Panel_player_header:removeAllChildren(true)
    end
    local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
    if Text_chat_sent_inner ~= nil then
        Text_chat_sent_inner:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.chats.chat_sent_other_player_cell, self.roots[1])
end
