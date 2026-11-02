-- ------------------------------------------------------------------------------------------------------------
--  说明：军团聊天信息
-- ------------------------------------------------------------------------------------------------------------
LegionChatsView = class("LegionChatsViewClass", Window)

--打开界面
local legion_chats_view_open_terminal = {
    _name = "legion_chats_view_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionChatsView:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_chats_view_open_terminal)
state_machine.init()

function LegionChatsView:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._showType = 0

    local function init_legion_chats_view_terminal()
        local legion_chats_view_show_terminal = {
            _name = "legion_chats_view_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_chats_view_open_chat_sent_terminal = {
            _name = "legion_chats_view_open_chat_sent",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("RedAlertTimeChatSentClass"))
                if params._datas._page == 0 then
                    state_machine.excute("red_alert_time_chat_sent_window_open",0,1)
                else
                    if instance._showType == 3 then
                        state_machine.excute("red_alert_time_chat_sent_window_open",0,3)
                    else
                        state_machine.excute("red_alert_time_chat_sent_window_open",0,1)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_chats_view_update_draw_terminal = {
            _name = "legion_chats_view_update_draw",
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

        state_machine.add(legion_chats_view_show_terminal)
        state_machine.add(legion_chats_view_open_chat_sent_terminal)
        state_machine.add(legion_chats_view_update_draw_terminal)
        state_machine.init()
    end
    init_legion_chats_view_terminal()
end

function LegionChatsView:onUpdateChatInfo()
    local root = self.roots[1]
    local Panel_chat_icon = ccui.Helper:seekWidgetByName(root, "Panel_chat_icon")
    Panel_chat_icon:removeAllChildren(true)
    if self._showType == 0 then
        Panel_chat_icon:setBackGroundImage(config_res.images.ui.chat.chat_horn_icon)
    elseif self._showType == 1 then
        local pic = cc.Sprite:createWithSpriteFrameName(config_res.images.ui.home.home_chat_world_icon)
        pic:setAnchorPoint(cc.p(0.5, 0.5))
        pic:setPosition(cc.p(Panel_chat_icon:getContentSize().width/2, Panel_chat_icon:getContentSize().height/2))
        Panel_chat_icon:addChild(pic)
    else
        Panel_chat_icon:setBackGroundImage(config_res.images.ui.legion.legion_chat_icon)
    end
    if _ED.send_chat_view_information == nil or #_ED.send_chat_view_information == 0 then
        return
    end
    self:updateDrawChat()
end

function LegionChatsView:updateDrawChat()
    local root = self.roots[1]
    local Text_legion_chat_push = ccui.Helper:seekWidgetByName(root, "Text_legion_chat_push")
    local Panel_chat_icon = ccui.Helper:seekWidgetByName(root, "Panel_chat_icon")
    Panel_chat_icon:removeAllChildren(true)
    Text_legion_chat_push:removeAllChildren(true)
    local chat_info = _ED.send_chat_view_information[#_ED.send_chat_view_information]
    local panel,height_number = self:createChatCell(chat_info, self._image_wight)
    self._showType = tonumber(chat_info.information_type)
    if self._showType == 0 then        --系统
        Panel_chat_icon:setBackGroundImage(config_res.images.ui.chat.chat_horn_icon)
    elseif self._showType == 3 then    -- 军团
        if chat_info.send_information_id ~= 0 then
            Panel_chat_icon:setBackGroundImage(config_res.images.ui.chat.chat_horn_icon)
        else
            Panel_chat_icon:setBackGroundImage(config_res.images.ui.legion.legion_chat_icon)
        end
    else
        local pic = cc.Sprite:createWithSpriteFrameName(config_res.images.ui.home.home_chat_world_icon)
        pic:setAnchorPoint(cc.p(0.5, 0.5))
        pic:setPosition(cc.p(Panel_chat_icon:getContentSize().width/2, Panel_chat_icon:getContentSize().height/2))
        Panel_chat_icon:addChild(pic)
        -- Panel_chat_icon:setBackGroundImage(config_res.images.ui.home.home_chat_world_icon)
    end
    Text_legion_chat_push:addChild(panel)
end

function LegionChatsView:createChatCell(chat_info,width)

    local panel = ccui.Layout:create()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setContentSize(cc.size(width, 0))

    local re1 = nil
    local re2 = nil
    local re3 = nil
    local reimg = nil
    local fontSize = 20
    local string_info = ""
    local channelType = tonumber(chat_info.information_type)
    local send_draw_info = chat_info.information_content

    local params_one = zstring.split(send_draw_info, "&|&")
    if nil ~= params_one and #params_one == 5 then
        send_draw_info = "["..params_one[5].."]"
    end

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
    re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, chat_info.send_information_name..":", config_res.font.font_name, fontSize)
    string_info = chat_info.send_information_name..":"

    local params = zstring.split(send_draw_info, chat_section[1])
    if #params > 1 then
        send_draw_info = params[1]
    end
    string_info = string_info ..send_draw_info
    if _richText.formatTextExt ~= nil then
        _richText:setAnchorPoint(0, 0)
        panel:setAnchorPoint(0, 0)
    else
        _richText:setAnchorPoint(0.5,1)
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
    local rt, count, text = draw.richTextCollectionMethod(_richText, 
        send_draw_info, 
        color,
        color,
        0, 
        0, 
        config_res.font.font_name, 
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

    if _richText.formatTextExt ~= nil then
        _richText:formatTextExt()
        local rsize = _richText:getContentSize()
        _richText:setPositionY(rsize.height-20)
        panel:setContentSize(rsize)
    else
        _richText:setPosition(cc.p(_richText:getContentSize().width/2, height_number * fontSize))
        panel:setContentSize(cc.size(_richText:getContentSize().width, height_number * fontSize))
    end

    panel:addChild(_richText)
    return panel,height_number
end


function LegionChatsView:onUpdate(dt)

end

function LegionChatsView:onInit()
    local csbItem = csb.createNode(config_csb.cells.legion.legion_chats_view)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_5"), nil, 
    {
        terminal_name = "legion_chats_view_open_chat_sent", 
        terminal_state = 0, 
        touch_black = true,
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_chat_icon"), nil, 
    {
        terminal_name = "legion_chats_view_open_chat_sent", 
        terminal_state = 0, 
        touch_black = true,
        _page = 0,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_legion_chat_push"), nil, 
    {
        terminal_name = "legion_chats_view_open_chat_sent", 
        terminal_state = 0, 
    }, nil, 1)
    

    self:onUpdateChatInfo()
end

function LegionChatsView:init(params)
    local rootWindow = params[1]
    self._showType = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionChatsView:onExit()
    state_machine.remove("legion_chats_view_show")
    state_machine.remove("legion_chats_view_open_chat_sent")
    state_machine.remove("legion_chats_view_update_draw")
end