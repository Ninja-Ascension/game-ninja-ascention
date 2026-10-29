-----------------------------
--聊天cell
-----------------------------
ChatSentPlayerCell = class("ChatSentPlayerCellClass", Window)
ChatSentPlayerCell.__size = nil
ChatSentOtherPlayerCell._image_size = nil

--创建cell
local chat_sent_player_create_cell_terminal = {
    _name = "chat_sent_player_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local chat_info = params[1]
        local index = params[2]
        local cell = ChatSentPlayerCell:new()
        cell:init(chat_info,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(chat_sent_player_create_cell_terminal)
state_machine.init()

function ChatSentPlayerCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._chat_info = nil
    self.copy_information_content = ""
	self.Offsety = 0
	self.height_number = 1
	self._share_info = ""
	app.load("client.red_alert_time.cells.worldMap.player_head_icon")

    local function init_chat_sent_player_cell_terminal()
        local chat_sent_player_cell_jump_terminal = {
            _name = "chat_sent_player_cell_jump",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                -- state_machine.excute("short_cut_go_to_other_window",0,{cell.get_way_id})
				if cell._share_info ~= "" then
					local param = zstring.split(cell._share_info, "|")
					if tonumber(param[1]) == 5 then
						shareJumpClassificationAchieve(param[1],cell._share_info)
					else
						shareJumpClassificationAchieve(param[1],param[2])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_sent_player_cell_title_info_terminal = {
            _name = "chat_sent_player_cell_title_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local headInfo = zstring.split(cell._chat_info.send_information_head, ",")
                if zstring.tonumber(headInfo[3]) > 0 then
                    state_machine.excute("player_avatar_info_open", 0, headInfo[3])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(chat_sent_player_cell_jump_terminal)
        state_machine.add(chat_sent_player_cell_title_info_terminal)
        state_machine.init()
    end
    init_chat_sent_player_cell_terminal()
end

function ChatSentPlayerCell:onEnterTransitionFinish()

end

function ChatSentPlayerCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_player_header = ccui.Helper:seekWidgetByName(root,"Panel_player_header")
    Panel_player_header:removeAllChildren(true)
    local user_data = {
        user_level = _ED.user_info.user_grade,
        user_sex = _ED.user_info.user_gender,
        user_camp = _ED.user_info.user_force
    }
	
	local cell = PlayerHeadIcon:createCell()
	local avatar_info = {}
	avatar_info.object = self._chat_info.send_information_head
	avatar_info.vip = _ED.vip_grade
	avatar_info._type = 0
	cell:init(avatar_info)
	Panel_player_header:addChild(cell)
    -- local head_icon = state_machine.excute("user_head_icon_create",0,{user_data})
    -- Panel_player_header:addChild(head_icon)

    local Panel_race = ccui.Helper:seekWidgetByName(root,"Panel_race")
    Panel_race:removeBackGroundImage()
    -- Panel_race:setBackGroundImage(string.format("images/ui/quality/camp_icon_%d.png", _ED.user_info.user_force))

    local Panel_name = ccui.Helper:seekWidgetByName(root,"Panel_name")
    Panel_name:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)  
    local tinfo = self._chat_info.send_information_name
    local re1 = nil
    local re2 = nil
    local re3 = nil
	local vipLevel = nil
	local vip = nil
	local re0 = nil
	local reC = nil
    local re4 = nil

    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
	-- debug.print_r(self._chat_info)
	if tonumber(self._chat_info.information_type) == 4 then
		re0 = ccui.RichElementText:create(1, chat_message_color[1], 255, "to:", config_res.font.font_name,20)
		re2 = ccui.RichElementText:create(1, chat_message_color[1], 255, self._chat_info.receiver_nickname.." ", fontName,20)
	else
		re2 = ccui.RichElementText:create(1, chat_message_color[1], 255, _ED.user_info.user_name.." ", fontName,20)
	end
    
    re3 = ccui.RichElementText:create(1, chat_message_color[2], 255, self._chat_info.send_information_time.." ", config_res.font.font_name,20)
    -- if self._chat_info.user_official ~= nil then
		-- print("self._chat_info.information_content=="..self._chat_info.information_content)
		-- print("self._chat_info.user_official=="..self._chat_info.user_official)
        -- local color_table = red_alert_officer_color[self._chat_info.user_official]
        -- re1 = ccui.RichElementText:create(1, cc.c3b(color_table[1],color_table[2],color_table[3]),255, red_alert_officer[self._chat_info.user_official].." ", config_res.font.font_name,20)
        -- tinfo = tinfo .. red_alert_officer[self._chat_info.user_official]
    -- end
	
	if re0 ~= nil then
        _richText:pushBackElement(re0)
        -- _richText:setAnchorPoint(0.1,0.2)
    end

    if tonumber(self._chat_info.information_type) == 4 then
        if self._chat_info.receiver_union_name ~= "" 
            and zstring.tonumber(self._chat_info.receiver_union_post) ~= -1 
            then
            local info = self._chat_info.receiver_union_name
            local unionInfo = ccui.RichElementText:create(1, chat_message_color[7], 255, info.." ", config_res.font.font_name, 20)
            _richText:pushBackElement(unionInfo)

            if zstring.tonumber(self._chat_info.receiver_union_post) == 1 then
                re4 = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/legion_icon_chat_1.png")
            elseif zstring.tonumber(self._chat_info.receiver_union_post) == 2 then
                re4 = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/legion_icon_chat_2.png")
            end
        end
    else
        if self._chat_info.union_name ~= "" 
            and zstring.tonumber(self._chat_info.union_post) ~= -1 
            then
            local info = self._chat_info.union_name
            local unionInfo = ccui.RichElementText:create(1, chat_message_color[7], 255, info.." ", config_res.font.font_name, 20)
            _richText:pushBackElement(unionInfo)

            if zstring.tonumber(self._chat_info.union_post) == 1 then
                re4 = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/legion_icon_chat_1.png")
            elseif zstring.tonumber(self._chat_info.union_post) == 2 then
                re4 = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/legion_icon_chat_2.png")
            end
        end
    end
    
	if re2 ~= nil then
        _richText:pushBackElement(re2)
        -- _richText:setAnchorPoint(0.1,0.2)
    end

    local military_info = nil
    if tonumber(self._chat_info.information_type) == 4 then
        military_info = _ED.base_military_info[""..self._chat_info.receiver_arena_id]
    else
        military_info = _ED.base_military_info[""..self._chat_info.send_information_arena_id]
    end
    if military_info ~= nil then
        local sprite = cc.Sprite:create(string.format(config_res.images.ui.props.props, military_info.pic))
        sprite:setScale(0.25)
        sprite:setContentSize(cc.size(sprite:getContentSize().width * 0.25, 20))

        local military = ccui.RichElementCustomNode:create(1, cc.c3b(255, 255, 255), 255, sprite)
        _richText:pushBackElement(military)
    end

    local vipNumber = 0
    if tonumber(self._chat_info.information_type) == 4 then
        vipNumber = zstring.tonumber(self._chat_info.receiver_vip_level)
    else
        vipNumber = zstring.tonumber(self._chat_info.vip_level)
    end
    
    if vipNumber > 0 then
        vip = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/chat_vip_icon.png")
        -- vipLevel = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/chat/text_vip_".. vipNumber .. ".png")
		vipLevel = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]), 255, ""..vipNumber.." ", config_res.font.font_name,20)
        _richText:pushBackElement(vip)
        _richText:pushBackElement(vipLevel)
    end

    -- local headInfo = zstring.split(self._chat_info.send_information_head, ",")
    -- if zstring.tonumber(headInfo[3]) > 0 then
    --     local title_data = dms.element(dms["avatar_head"], headInfo[3])
    --     local quality = dms.atoi(title_data, avatar_head.quality)
    --     local achievement_id = dms.atoi(title_data, avatar_head.condition)
    --     local title_name = dms.string(dms["achievement_mould"], achievement_id, achievement_mould.achievement_name)
    --     local color = cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3])
    --     local title = ccui.RichElementText:create(1, color, 255, title_name.."  ", config_res.font.font_name,20)
    --     _richText:pushBackElement(title)
    -- end

    if re4 ~= nil then
        _richText:pushBackElement(re4)
    end

    if re3 ~= nil then
        _richText:pushBackElement(re3)
    end

    if re1 ~= nil then
        _richText:pushBackElement(re1)
        -- _richText:setAnchorPoint(0.23,0.2)
    end
    if nil ~= _richText.formatTextExt then
        _richText:setContentSize(cc.size(380,20))
        _richText:setAnchorPoint(cc.p(0, 0))
        _richText:formatTextExt()
        _richText:setPositionX(320 - _richText:getContentSize().width)
        -- _richText:setPositionX(150)
        Panel_name:addChild(_richText)
    else
        local map = string.utf8.chars(tinfo)
        local len_size = 0
        for i,v in pairs(map) do
            len_size = len_size + string.len(v)
        end
        local image_width = len_size / 3 * 20
        _richText:setAnchorPoint(0, 0.2)
        _richText:setPositionX(-1 * (image_width - 6 * 20) - 100)
        _richText:setContentSize(cc.size(380,20))
        Panel_name:addChild(_richText)
    end

    self.copy_information_content = self._chat_info.information_content
    local texts_info = zstring.split(zstring.exchangeTo(self.copy_information_content), "&#13;&#10;")
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
    if self._share_info ~= "" or texts_info[2] ~= nil then
        fontName = config_res.font.font_name
    end
	local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
	local Image_chat_sent_bg = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg")
	-- Image_chat_sent_bg:setTouchEnabled(false)
	if Image_chat_sent_bg._size == nil then
		Image_chat_sent_bg._size = Image_chat_sent_bg:getContentSize()
	end
	Image_chat_sent_bg:setContentSize(Image_chat_sent_bg._size)
	local fontSize = 22
	Text_chat_sent_inner:removeAllChildren(true)
	local _richText2 = ccui.RichText:create()
	_richText2:ignoreContentAdaptWithSize(false)
	_richText2:setContentSize(cc.size(400, 0))
	_richText2:setAnchorPoint(cc.p(1, 0))
	local char_str = params[1]
	local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		char_str, 
		cc.c3b(189, 206, 224),
		cc.c3b(189, 206, 224),
		0, 
		0, 
		fontName, 
		fontSize,
		chat_rich_text_color)
	
	-- if _richText2.formatTextExt ~= nil then
		_richText2:formatTextExt()
		local rsize = _richText2:getContentSize()
		_richText2:setPositionY(-2)
		_richText2:setPositionX(400 - 0.5 * fontSize)
		local newHeight = 0
		newHeight = rsize.height+fontSize*3/2
		if newHeight > Image_chat_sent_bg._size.height then
			newHeight = rsize.height+fontSize*3/2
		else
			newHeight = Image_chat_sent_bg._size.height
		end
		Image_chat_sent_bg:setContentSize(cc.size(rsize.width+Image_chat_sent_bg._size.width,newHeight))
	-- end
	Text_chat_sent_inner:addChild(_richText2)
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
			fontName, 
			fontSize,
			chat_rich_text_color)
		_richText3:formatTextExt()
		local rsize2 = _richText3:getContentSize()
		_richText3:setPositionY(-2)
		_richText3:setPositionX(400 - 0.5 * fontSize+rsize2.width-rsize.width)	
		Text_chat_sent_inner:addChild(_richText3)
	end
	
    if newHeight > Image_chat_sent_bg._size.height then
        local offY = newHeight - Image_chat_sent_bg._size.height
        self:setContentSize(cc.size(self:getContentSize().width,ChatSentPlayerCell.__size.height+offY+20))
        root:setPositionY(root._y+(ChatSentPlayerCell.__size.height + offY+20-root:getContentSize().height))
    else
        self:setContentSize(cc.size(self:getContentSize().width,ChatSentPlayerCell.__size.height+20))
        root:setPositionY(root._y+(ChatSentPlayerCell.__size.height+20-root:getContentSize().height))
    end
end

function ChatSentPlayerCell:setHeightNumber(index)
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

    --     self:setContentSize(cc.size(ChatSentPlayerCell.__size.width,
    --         ChatSentPlayerCell.__size.height + height_number * 30))
    -- else
    	local map = nil
    	local _richText2 = ccui.RichText:create()
    	_richText2:ignoreContentAdaptWithSize(false)
    	_richText2:setContentSize(cc.size(400, 0))
    	_richText2:setAnchorPoint(cc.p(1, 0))
    	local char_str = self._chat_info.information_content
    	local params = zstring.split(zstring.exchangeFrom(self._chat_info.information_content), chat_section[1])
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
    		24,
    		chat_rich_text_color)
    	map = string.utf8.chars(text)

        local enter_size = 20
    	_richText2:formatTextExt()
    	local rsize = _richText2:getContentSize()
    	local newHeight = 0
        _richText2:setContentSize(cc.size(0, 0))
        _richText2 = nil
    	newHeight = rsize.height+30
    	if newHeight > 58 then
    		newHeight = rsize.height+30
    	else
    		newHeight = 58
    	end
    	if newHeight > 58 then
    		local offY = newHeight - 58
    		self:setContentSize(cc.size(ChatSentPlayerCell.__size.width,ChatSentPlayerCell.__size.height+offY+20))
    	else
    		self:setContentSize(cc.size(ChatSentPlayerCell.__size.width,ChatSentPlayerCell.__size.height+20))
    	end
    -- end
end

function ChatSentPlayerCell:init(chat_info,index)
    self._chat_info = chat_info
    if index ~= nil and index < 9 then
        self:onInit()
    end
    self:setHeightNumber(index)
    return self
end

function ChatSentPlayerCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.chats.chat_sent_player_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if ChatSentPlayerCell.__size == nil then
        ChatSentPlayerCell.__size = root:getContentSize()
    end
    if ChatSentOtherPlayerCell._image_size == nil then
        ChatSentOtherPlayerCell._image_size = ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):getContentSize()
    end
    -- -- 跳转
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_get_way_break_down_1") , nil, 
    -- {
        -- terminal_name = "get_the_way_to_open_other", 
        -- terminal_state = 0, 
        -- cell = self,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,   
    -- }, nil, 1)    
    
	
	
	if root._y == nil then
		root._y = root:getPositionY()
	end

	root:setPositionY(root._y)
    -- 功能按钮
	root:setTouchEnabled(true)

    
    ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg"):setTouchEnabled(true)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_chat_sent_bg") , nil, 
    {
        terminal_name = "chat_sent_player_cell_jump", 
        terminal_state = 0, 
		cells = self
    }, nil, 1)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_name") , nil, 
    {
        terminal_name = "chat_sent_player_cell_title_info", 
        terminal_state = 0, 
        cells = self,
    }, nil, 1) 
    
    self:onUpdateDraw() 
end

function ChatSentPlayerCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ChatSentPlayerCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_player_header = ccui.Helper:seekWidgetByName(root,"Panel_player_header")
    Panel_player_header:removeAllChildren(true)
    local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(root,"Text_chat_sent_inner")
    Text_chat_sent_inner:removeAllChildren(true)
    local Panel_name = ccui.Helper:seekWidgetByName(root,"Panel_name")
    Panel_name:removeAllChildren(true)
    cacher.freeRef(config_csb.cells.chats.chat_sent_player_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ChatSentPlayerCell:onExit()
    local Panel_player_header = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_header")
    if Panel_player_header ~= nil then
        Panel_player_header:removeAllChildren(true)
    end
    local Text_chat_sent_inner = ccui.Helper:seekWidgetByName(self.roots[1],"Text_chat_sent_inner")
    if Text_chat_sent_inner ~= nil then
        Text_chat_sent_inner:removeAllChildren(true)
    end
    local Panel_name = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_name")
    if Panel_name ~= nil then
        Panel_name:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.chats.chat_sent_player_cell, self.roots[1])
end
