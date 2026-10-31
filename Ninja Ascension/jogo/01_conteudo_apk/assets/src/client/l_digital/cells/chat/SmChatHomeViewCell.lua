-----------------------------
--数码主界面聊天cell
-----------------------------
SmChatHomeViewList = class("SmChatHomeViewListClass", Window)
SmChatHomeViewList.y = nil 
local sm_chat_home_view_list_cell_terminal = {
    _name = "sm_chat_home_view_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = SmChatHomeViewList:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_chat_home_view_list_cell_terminal)
state_machine.init()

function SmChatHomeViewList:ctor()
    self.super:ctor()
	self.roots = {}		
    self.chat_info = nil

 	local function init_sm_chat_home_view_list_cell_terminal()
        local sm_chat_home_view_list_cell_updata_info_terminal = {
            _name = "sm_chat_home_view_list_cell_updata_info",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                local info = params[2]
                if info ~= nil then
                    cell.chat_info = info
                    cell:onUpdateDraw()
                else
                    cell:unload()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(sm_chat_home_view_list_cell_updata_info_terminal)
        state_machine.init()
    end
	init_sm_chat_home_view_list_cell_terminal()        	
end

function SmChatHomeViewList:onUpdateDraw()
	local root = self.roots[1]
    local Text_chat_infor = ccui.Helper:seekWidgetByName(root, "Text_chat_infor")

    local char_str = self.chat_info.information_content
    local str = self.chat_info.send_information_name
    local pic_type = self.chat_info.information_type
    if tonumber(self.chat_info.information_type) == 0 
        or (tonumber(self.chat_info.send_information_id) == 0 
            and tonumber(self.chat_info.system_info_id) ~= 45
            and tonumber(self.chat_info.system_info_id) ~= 47)
        then
        str = _new_interface_text[74]
        pic_type = 0
    end
    if tonumber(self.chat_info.information_type) == 5 then
        pic_type = 1
    elseif tonumber(self.chat_info.information_type) == 6 then
        pic_type = 2
    end
    local image_str = "/"..pic_type.."|   "
    char_str = image_str.."%|2|["..str.."]%"..char_str

    local max_width = 0
    if _ED.is_can_use_formatTextExt == false then
        Text_chat_infor:setString(char_str)
        max_width = Text_chat_infor:getAutoRenderSize().width
    end

    Text_chat_infor:setString("")
    Text_chat_infor:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_chat_infor:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_chat_infor:getFontSize() * 6
    end
                
    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local fontsName = Text_chat_infor:getFontName()
    if verifySupportLanguage(_lua_release_language_zh_TW) == false then
        fontsName = ""
    else
        fontsName = Text_chat_infor:getFontName()
    end

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(224, 224, 224)
        color_Type_2 = cc.c3b(224, 224, 224)
    else
        color_Type_1 = cc.c3b(189, 206, 224)
        color_Type_2 = cc.c3b(189, 206, 224)
    end

    char_str = smWidthSingle(char_str,Text_chat_infor:getFontSize()/2,Text_chat_infor:getContentSize().width)
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    fontsName, 
    Text_chat_infor:getFontSize(),
    chat_rich_text_color)
    if _ED.is_can_use_formatTextExt == false then
        _richText2:setPositionX( - _richText2:getContentSize().width / 2 )
    else
        _richText2:formatTextExt()
    end
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_chat_infor:getContentSize().height / 2 + Text_chat_infor:getFontSize())
    Text_chat_infor:addChild(_richText2)
    root:setPositionY(SmChatHomeViewList.y +  _richText2:getContentSize().height - root:getContentSize().height)
    self:setContentSize(_richText2:getContentSize())


    --如果formatTextExt不能用 重新计算高度和位置
    if _ED.is_can_use_formatTextExt == false then
        local heightN = math.ceil( max_width / tonumber(_richText2:getContentSize().width))
        local height = heightN * 19
        root:setPositionY(SmChatHomeViewList.y +  height - root:getContentSize().height)
        self:setContentSize(cc.size(_richText2:getContentSize().width , height))
    end
end

function SmChatHomeViewList:onInit()
	local root = cacher.createUIRef("Chat/chat_home_window_cell.csb", "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    if SmChatHomeViewList.y == nil then
       SmChatHomeViewList.y = root:getPositionY()
    end
	self:onUpdateDraw()
end

function SmChatHomeViewList:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef("Chat/chat_home_window_cell.csb", root)
end

function SmChatHomeViewList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmChatHomeViewList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef("Chat/chat_home_window_cell.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function SmChatHomeViewList:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_chat_infor = ccui.Helper:seekWidgetByName(root, "Text_chat_infor")
    if Text_chat_infor ~= nil then
        Text_chat_infor:setString("")
        Text_chat_infor:removeAllChildren(true)
    end
end

function SmChatHomeViewList:init(params)
	self.chat_info = params[1]
    self._index = params[2]
	
    --if self._index ~= nil and self._index <= 5 then
        self:onInit()
    --end
    return self
end

