----------------------------------------------------------------------------------------------------
-- 说明：系统聊天cell
-------------------------------------------------------------------------------------------------------

ChatSystemCell = class("ChatSystemCellClass", Window)
    
function ChatSystemCell:ctor()
   	self.super:ctor()
	self.roots = {}
	self.personId = nil
	self.info = nil
	self.isVip = nil
	self.name = nil
	self.quality = nil
	self.pic = nil
	self.myPic = nil
	self.str = nil
	self.picNum = 0
	self.nType = 0

    local function init_chat_system_cell_terminal()

        state_machine.init()
    end
    
    init_chat_system_cell_terminal()
end

function ChatSystemCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_103_0_0 = ccui.Helper:seekWidgetByName(root, "Text_103_0_0")
	local Panel_chat_2 = ccui.Helper:seekWidgetByName(root, "Panel_chat_2")
	local Panel_chat_channel = ccui.Helper:seekWidgetByName(root, "Panel_chat_channel")
	if zstring.tonumber(self.nType) == 2 then
		Panel_chat_channel:setBackGroundImage("images/ui/text/chat/chat_channel_2.png")
	elseif zstring.tonumber(self.nType) == 3 then
		Panel_chat_channel:setBackGroundImage("images/ui/text/chat/chat_channel_3.png")
	else
		Panel_chat_channel:setBackGroundImage("images/ui/text/chat/chat_channel_0.png")
	end
	index = 0
	local _richText2 = ccui.RichText:create()
	_richText2:ignoreContentAdaptWithSize(false)

	local richTextWidth = Text_103_0_0:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_103_0_0:getFontSize() * 6
    end
			    
	_richText2:setContentSize(cc.size(richTextWidth, 0))
	_richText2:setAnchorPoint(cc.p(0, 0))
	local char_str = self.info
    local fontsName = Text_103_0_0:getFontName()
    if verifySupportLanguage(_lua_release_language_zh_TW) == false then
        fontsName = ""
    else
        fontsName = Text_103_0_0:getFontName()
    end

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(71, 71, 71)
        color_Type_2 = cc.c3b(71, 71, 71)
    elseif __lua_project_id == __lua_project_l_digital then 
		-- DSC重塑
		color_Type_1 = Text_103_0_0:getColor()
		color_Type_2 = Text_103_0_0:getColor()
	else
        color_Type_1 = cc.c3b(189, 206, 224)
        color_Type_2 = cc.c3b(189, 206, 224)
    end

	local rt, count, text = draw.richTextCollectionMethod(_richText2, 
	char_str, 
	color_Type_1,
	color_Type_2,
	0, 
	0, 
	fontsName, 
	Text_103_0_0:getFontSize(),
	chat_rich_text_color)
	if _ED.is_can_use_formatTextExt == false then
		_richText2:setPositionX(_richText2:getPositionX() - _richText2:getContentSize().width / 2)
    else
        _richText2:formatTextExt()
    end
	local rsize = _richText2:getContentSize()
	_richText2:setPositionY(Text_103_0_0:getContentSize().height-index)
	Text_103_0_0:addChild(_richText2)
	index = index + rsize.height
	self:setContentSize(Panel_chat_2:getContentSize())
end

function ChatSystemCell:onEnterTransitionFinish()
	local root = cacher.createUIRef("Chat/chat_list_3.csb", "root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	
	self:onUpdateDraw()
end

function ChatSystemCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_103_0_0 = ccui.Helper:seekWidgetByName(root, "Text_103_0_0")
    if Text_103_0_0 ~= nil then
        Text_103_0_0:setString("")
        Text_103_0_0:removeAllChildren(true)
    end
end

function ChatSystemCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("Chat/chat_list_3.csb", self.roots[1])
	state_machine.remove("chat_system_cell_click_head")
end

function ChatSystemCell:init(personId, name, info, isVip ,quality, pic, nType)
	self.personId = personId
	self.name = name or ""
	self.info = info or ""
	self.isVip = isVip or 0				-- 0 不是VIP   1 是VIP
	self.quality = zstring.tonumber(quality)	
	self.pic = pic or 1508		
	self.nType = nType
end

function ChatSystemCell:createCell()
	local cell = ChatSystemCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end