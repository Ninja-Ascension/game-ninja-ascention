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

    local function init_chat_sent_world_cell_terminal()
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
	
	-- local panel = ccui.Layout:create()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
	local fontSize = 20
	
	local color = chat_message_color[5] -- cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
	
	local rt, count, text = draw.createMessageRichText(_richText, 
        self._chat_info.information_content, 
        color,
        color,
        0, 
        0, 
        "fonts/simhei.ttf", 
        fontSize,
        chat_message_quality_color)
	local enter_size = 27
    local enter_lenth = enter_size * 3
    local height_number = 1
    local len_size = 0
    local map = string.utf8.chars(text)
    for i,v in pairs(map) do
        len_size = len_size + string.len(v)
        if len_size >= enter_lenth then
            height_number = height_number + 1
            len_size = len_size - enter_size*3
        end
    end
	local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
	local image_widght = 0
	local image_height = 0
	if height_number > 0 then
		image_widght = enter_size * fontSize
	else
		image_widght = len_size / 3 * fontSize
	end
    -- image_widght = enter_size*(Text_chat_sent_inner:getFontSize() + 6)
    _richText:setContentSize(cc.size(image_widght - fontSize * 2, 0))
	_richText:setPosition(cc.p(_richText:getContentSize().width/2, 0))
	ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner"):addChild(_richText)
	ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):setContentSize(cc.size(image_widght,
        (height_number- 1)*14 + ChatSentOtherPlayerCell._image_size.height))
		
		
	
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

function ChatSentWorldCell:setSelfContentSize()
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

    self:setContentSize(cc.size(ChatSentWorldCell.__size.width,
    ChatSentWorldCell.__size.height + height_number * 26))
end


function ChatSentWorldCell:init(chat_info,index)
    self._chat_info = chat_info
    if index ~= nil and index < 5 then
        self:onInit()
    end
    self:setSelfContentSize()
    return self
end

function ChatSentWorldCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.chats.chat_sent_world_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if ChatSentWorldCell.__size == nil then
        ChatSentWorldCell.__size = root:getContentSize()
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
    cacher.freeRef(config_csb.cells.chats.chat_sent_world_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ChatSentWorldCell:onExit()
     cacher.freeRef(config_csb.cells.chats.chat_sent_world_cell, self.roots[1])
end
