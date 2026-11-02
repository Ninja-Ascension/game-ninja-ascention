-----------------------------
--聊天cell
-----------------------------
ChatSentWorldCell = class("ChatSentWorldCellClass", Window)
ChatSentWorldCell.__size = nil
ChatSentOtherPlayerCell._image_size = nil
--创建cell
local chat_sent_world_create_cell_terminal = {
    _name = "chat_sent_world_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local chat_info = params[1]
        local index = params[2]
        local cell = ChatSentWorldCell:new()
        cell:init(chat_info,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(chat_sent_world_create_cell_terminal)
state_machine.init()

function ChatSentWorldCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._chat_info = nil
    self._prop_id = nil
    self._share_info = nil

    app.load("client.red_alert_time.legion.LegionInforWindow")
    local function init_chat_sent_world_cell_terminal()
        local get_the_way_to_open_other_terminal = {
            _name = "get_the_way_to_open_other",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(cell._chat_info.information_type) == 0 then
                    if cell._prop_id ~= nil then
                        local union_info = zstring.split(cell._prop_id, ",")
                        if tonumber(union_info[2]) == zstring.tonumber(_ED.union.union_info.union_id) then
                            state_machine.excute("legion_window_open",0,"")
                        else
                            local info = {}
                            info.need_verify = union_info[1]
                            info.union_id = union_info[2]
                            info.union_level = union_info[3]
                            info.union_camp = union_info[4]
                            info.union_president_name = union_info[5]
                            info.union_member = union_info[6]
                            info.need_level = union_info[7]
                            info.union_fight = union_info[8]
                            info.union_rank = union_info[9]
                            info.union_name = union_info[10]
                            info.union_watchword = union_info[11]
                            info.need_combat_force = union_info[12]
                            state_machine.excute("legion_infor_window_open", 0, {info, 1})
                        end
                    elseif zstring.tonumber(cell._chat_info.system_info_id) > 0 then
                        local jump_type = dms.int(dms["message_notification_param"], cell._chat_info.system_info_id, message_notification_param.jump_type)
                        if tonumber(jump_type) > 0 then
                            state_machine.excute("short_cut_go_to_other_window", 0, {jump_type})
                        end
                    end
                elseif tonumber(cell._chat_info.information_type) == 8 
                    or tonumber(cell._chat_info.information_type) == 3 
                    then
                    if cell._share_info ~= nil and cell._share_info ~= "" then
                        local param = zstring.split(cell._share_info, "|")
                        if tonumber(param[1]) == 5 then
                            shareJumpClassificationAchieve(param[1],cell._share_info)
                        else
                            shareJumpClassificationAchieve(param[1],param[2])
                        end
                        return
                    end
                    if cell._prop_id == nil then
                        return
                    end
                    local oldToken = 0
                    local oldGold = tonumber(_ED.user_info.user_gold)
                    if _ED.activity_info["61"] ~= nil then
                        local timesData = zstring.split(_ED.activity_info["61"].activity_add_state, ",")
                        oldToken = tonumber(timesData[3])
                    end
                    local function responseSendMessageCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            local isOne = false
                            local token = 0
                            if _ED.activity_info["61"] ~= nil then
                                local timesData = zstring.split(_ED.activity_info["61"].activity_add_state, ",")
                                token = tonumber(timesData[3])
                            end
                            if token~=oldToken or oldGold~=tonumber(_ED.user_info.user_gold) then
                                isOne = true
                                state_machine.excute("main_window_update_userinfo", 0, nil)
                            end
                            if _ED.get_red_envelopes_info ~= nil 
                                or #_ED.get_red_envelopes_info > 0 then
                                for k,v in pairs(_ED.get_red_envelopes_info) do
                                    if v.name == _ED.user_info.user_name then  
                                        if isOne == false then
                                            TipDlg.drawTextDailog(chat_sent_string[12])
                                        else
                                            if tonumber(_ED.red_envelopes_template_id) == 681 then
                                                TipDlg.drawTextDailog(chat_sent_string[13]..v.gold)
                                            end
                                        end
                                        state_machine.excute("red_alert_time_red_rnvelopes_rob_window_open", 0, "")
                                        return
                                    end
                                end
                            end

                            if _ED.red_envelopes_max_times <= _ED.red_envelopes_make_times then
                                TipDlg.drawTextDailog(chat_sent_string[11])
                                state_machine.excute("red_alert_time_red_rnvelopes_rob_window_open", 0, "")
                            else
                                state_machine.excute("main_window_update_userinfo", 0, nil)
                            end

                        end
                    end
                    protocol_command.grab_red_packet.param_list = cell._prop_id
                    NetworkManager:register(protocol_command.grab_red_packet.code, nil, nil, nil, cell, responseSendMessageCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(get_the_way_to_open_other_terminal)
        state_machine.init()
    end
    init_chat_sent_world_cell_terminal()
end

function ChatSentWorldCell:onEnterTransitionFinish()

end

function ChatSentWorldCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")
    Text_time:setString(self._chat_info.send_information_time)
        --文字处理
    -- local enter_size = 20
    local char_str = self._chat_info.information_content
	-- if tonumber(self._chat_info.information_type) == 8 then
        local information_content = zstring.split(self._chat_info.information_content, "|||")
        char_str = information_content[1]
        self._prop_id = information_content[2]
    -- end
    local texts_info = zstring.split(zstring.exchangeTo(char_str), "&#13;&#10;")
    local textDatas = ""
    if #texts_info>1 then
        textDatas = "\r\n"..zstring.exchangeFrom(texts_info[2])
    else
        textDatas = zstring.exchangeFrom(texts_info[1])
    end
    local params = zstring.split(textDatas, chat_section[1])
    if #params > 1 then
        self._share_info = params[2]
    end
	-- local panel = ccui.Layout:create()
    local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
    local Image_chat_sent_bg = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg")
    -- Image_chat_sent_bg:setTouchEnabled(false)
    if Image_chat_sent_bg._size == nil then
        Image_chat_sent_bg._size = Image_chat_sent_bg:getContentSize()
    end
    Image_chat_sent_bg:setContentSize(Image_chat_sent_bg._size)
    local fontSize = 22
    Text_chat_sent_inner:removeAllChildren(true)
    -- local panel = ccui.Layout:create()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setContentSize(cc.size(400, 0))
    _richText:setAnchorPoint(cc.p(0, 0))
    local color = chat_message_color[5] -- cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    local char_str = params[1]
    local rt, count, text = draw.richTextCollectionMethod(_richText, 
        char_str, 
        cc.c3b(189, 206, 224),
        cc.c3b(189, 206, 224),
        0, 
        0, 
        config_res.font.font_name, 
        fontSize,
        chat_rich_text_color)

    _richText:formatTextExt()
    local rsize = _richText:getContentSize()
    _richText:setPositionY(-2)
    _richText:setPositionX(0)
    local newHeight = 0
    newHeight = rsize.height+fontSize*3/2
    if newHeight > Image_chat_sent_bg._size.height then
        newHeight = rsize.height+fontSize*3/2
    else
        newHeight = Image_chat_sent_bg._size.height
    end
    Image_chat_sent_bg:setContentSize(cc.size(rsize.width+Image_chat_sent_bg._size.width,newHeight))
    -- end
    Text_chat_sent_inner:addChild(_richText)
    if #texts_info>1 then
        local _richText3 = ccui.RichText:create()
        _richText3:ignoreContentAdaptWithSize(false)
        _richText3:setContentSize(cc.size(400, 0))
        _richText3:setAnchorPoint(cc.p(1, 0))
        local rt2, count2, text2 = draw.richTextCollectionMethod(_richText3, 
            texts_info[1], 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            config_res.font.font_name, 
            fontSize,
            chat_rich_text_color)
        _richText3:formatTextExt()
        local rsize2 = _richText3:getContentSize()
        _richText3:setPositionY(-2)
        _richText3:setPositionX(0)  
        Text_chat_sent_inner:addChild(_richText3)
    end 
        
    if newHeight > Image_chat_sent_bg._size.height then
        local offY = newHeight - Image_chat_sent_bg._size.height
        self:setContentSize(cc.size(self:getContentSize().width,ChatSentWorldCell.__size.height+offY+20))
        root:setPositionY(root._y+(ChatSentWorldCell.__size.height + offY+20-root:getContentSize().height))
    else
        self:setContentSize(cc.size(self:getContentSize().width,ChatSentWorldCell.__size.height+20))
        root:setPositionY(root._y+(ChatSentWorldCell.__size.height + 20-root:getContentSize().height))
    end
	
    ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):setTouchEnabled(true)

    local Text_world = ccui.Helper:seekWidgetByName(root,"Text_world")
    if tonumber(self._chat_info.information_type) == 3 then
        Text_world:setString(string.format(chat_section[5], chat_section[4]))
    else
        Text_world:setString(string.format(chat_section[5], chat_section[2]))
    end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_chat_sent_bg"), nil, 
    {
        terminal_name = "get_the_way_to_open_other", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1) 
	-- local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
	-- ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):addChild(panel)
    -- local map = string.utf8.chars(char_str)

    -- local len_size = 0
    -- local enter_index = 0
    -- local new_str = ""
    -- local height_number = 1
    -- local width_numbers = 0
    -- for i,v in pairs(map) do
        -- len_size = len_size + string.len(v)
        -- if string.len(v) == 1 then
            -- width_numbers = width_numbers + 16
        -- elseif string.len(v) == 3 then
            -- width_numbers = width_numbers + 32
        -- end
        -- if len_size >= enter_size*3 then
            -- new_str = new_str .. v .. "\r\n"
            -- height_number = height_number + 1
            -- len_size = len_size - enter_size*3
        -- else
            -- new_str = new_str .. v
        -- end
    -- end
	
    -- local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")

    -- Text_chat_sent_inner:setString(new_str)

    -- self:setContentSize(cc.size(ChatSentWorldCell.__size.width,
        -- ChatSentWorldCell.__size.height + height_number * (Text_chat_sent_inner:getFontSize() + 6)))
    -- local image_widght = 0
    -- if height_number > 1 then
        -- image_widght = enter_size*(Text_chat_sent_inner:getFontSize() + 6)
    -- else
        -- image_widght = math.max(math.min(width_numbers,enter_size*(Text_chat_sent_inner:getFontSize() + 6)) , 100) 
    -- end
    
    -- ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):setContentSize(cc.size(image_widght,
        -- (height_number- 1)*14 + ChatSentOtherPlayerCell._image_size.height))

end

function ChatSentWorldCell:setSelfContentSize(index)
      --文字处理
    -- if index ~= 0 then
    --     local enter_size = 20
    --     local char_str = self._chat_info.information_content
    --     local char_str = self._chat_info.information_content
    --     local params = zstring.split(zstring.exchangeFrom(self._chat_info.information_content), chat_section[1])
    --     if #params > 1 then
    --         char_str = params[1]
    --     end
    --     local map = string.utf8.chars(char_str)

    --     local len_size = 0
    --     local new_str = ""
    --     local height_number = 1
    --     for i,v in pairs(map) do
    --         len_size = len_size + string.len(v)
            
    --         if len_size >= enter_size*3 then
    --             new_str = new_str .. v .. "\r\n"
    --             height_number = height_number + 1
    --             len_size = len_size - enter_size*3
    --         else
    --             new_str = new_str .. v
    --         end
    --     end

    --     self:setContentSize(cc.size(ChatSentWorldCell.__size.width,
    --         ChatSentWorldCell.__size.height + height_number * 30))
    -- else
        local fontSize = 22
        local map = nil
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        _richText2:setContentSize(cc.size(400, 0))
        _richText2:setAnchorPoint(cc.p(0, 0))
        local char_str = self._chat_info.information_content
    -- if tonumber(self._chat_info.information_type) == 8 then
        local information_content = zstring.split(self._chat_info.information_content, "|||")
        char_str = information_content[1]
    -- end
        local texts_info = zstring.split(zstring.exchangeTo(char_str), "&#13;&#10;")
        local textDatas = ""
        if #texts_info>1 then
            textDatas = "\r\n"..zstring.exchangeFrom(texts_info[2])
        else
            textDatas = zstring.exchangeFrom(texts_info[1])
        end
        local params = zstring.split(textDatas, chat_section[1])
        -- local params = zstring.split(zstring.exchangeFrom(self._chat_info.information_content), chat_section[1])
        if #params > 1 then
            char_str = params[1]
        end
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            config_res.font.font_name, 
            fontSize,
            chat_rich_text_color)
        map = string.utf8.chars(text)
        local enter_size = 20

        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        local newHeight = 0
        _richText2:setContentSize(cc.size(0, 0))
        _richText2 = nil
        
        newHeight = rsize.height+fontSize*3/2
        if newHeight > 58 then
            newHeight = rsize.height+fontSize*3/2
        else
            newHeight = 58
        end

        -- newHeight = rsize.height+30
        -- if newHeight > 58 then
        --     newHeight = rsize.height+30
        -- else
        --     newHeight = 58
        -- end
        if newHeight > 58 then
            local offY = newHeight - 58
            self:setContentSize(cc.size(ChatSentWorldCell.__size.width,ChatSentWorldCell.__size.height+offY+20))
        else
            self:setContentSize(cc.size(ChatSentWorldCell.__size.width,ChatSentWorldCell.__size.height+20))
        end
    -- end
end


function ChatSentWorldCell:init(chat_info,index)
    self._chat_info = chat_info
    if index ~= nil and index < 9 then
        self:onInit()
    end
    self:setSelfContentSize(index)
    return self
end

function ChatSentWorldCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.chats.chat_sent_world_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if ChatSentWorldCell.__size == nil then
        ChatSentWorldCell.__size = root:getContentSize()
    end
    if ChatSentWorldCell._image_size == nil then
        ChatSentWorldCell._image_size = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):getContentSize()
    end
    
    if root._y == nil then
        root._y = root:getPositionY()
    end

    root:setPositionY(root._y)
    --跳转
    fwin:addTouchEventListener(root , nil, 
    {
        terminal_name = "get_the_way_to_open_other", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)     
    
    self:onUpdateDraw() 
end

function ChatSentWorldCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ChatSentWorldCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
    Text_chat_sent_inner:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.chats.chat_sent_world_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ChatSentWorldCell:onExit()
    local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
    if Text_chat_sent_inner ~= nil then
        Text_chat_sent_inner:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.chats.chat_sent_world_cell, self.roots[1])
end
