--------------------------------------------------------------------------------------------------------------
--  邮件文字cell
--------------------------------------------------------------------------------------------------------------
MailOtherTextCell = class("MailOtherTextCellClass", Window)
MailOtherTextCell.__size = nil
--创建cell
local mail_other_text_cell_terminal = {
    _name = "mail_other_text_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MailOtherTextCell:new()
        local data = params[1]
        local fontName = params[2]
        cell:init(data , fontName)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(mail_other_text_cell_terminal)
state_machine.init()

function MailOtherTextCell:ctor()
	self.super:ctor()
	self.roots = {}
    self._datas = ""
    self.fontName = ""
end

function MailOtherTextCell:updateDraw()
    local root = self.roots[1]
	local Text_mail = ccui.Helper:seekWidgetByName(root,"Text_mail")
	Text_mail:removeAllChildren(true)
    local texts_info = zstring.split(self._datas, "/r/n")
    local index = 0
    local _richText_combination = {}
    for i=1,#texts_info do
        local right_align = false
        if string.sub(texts_info[i], 1, 4) == "----" then
            right_align = true
        end
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        _richText:setContentSize(cc.size(MailOtherTextCell.__size.width-10, 0))
        if right_align == false then
            _richText:setAnchorPoint(cc.p(0, 0))
        else
            _richText:setAnchorPoint(cc.p(1, 0))
        end
        local char_str = texts_info[i]
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
            char_str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            self.fontName, 
            20,
            chat_rich_text_color)
        _richText:formatTextExt()
        local rsize = _richText:getContentSize()
        if right_align == false then
            _richText:setPositionX(0)
        else
            _richText:setPositionX(MailOtherTextCell.__size.width* 2 - 30)
        end
        _richText:setPositionY(Text_mail:getContentSize().height-index)
        Text_mail:addChild(_richText)
        index = index + rsize.height
        _richText_combination[i] = {}
        _richText_combination[i].t_object = _richText
        _richText_combination[i].height = index-rsize.height
    end
    local newHeight = 0
    newHeight = index+20*3/2
    if newHeight > MailOtherTextCell.__size.height then
        newHeight = index+20*3/2
    else
        newHeight = MailOtherTextCell.__size.height
    end
    root:setContentSize(cc.size(MailOtherTextCell.__size.width, newHeight))
    for i, v in pairs( _richText_combination) do
        v.t_object:setPositionY(root:getContentSize().height-tonumber(v.height))
    end
    self:setContentSize(root:getContentSize())	
end

function MailOtherTextCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.mail.mail_text, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    table.insert(self.roots, root) 

    if MailOtherTextCell.__size == nil then
        MailOtherTextCell.__size = root:getContentSize()
    end

    root:setContentSize(MailOtherTextCell.__size)

	self:updateDraw()
end

function MailOtherTextCell:onEnterTransitionFinish()

end

function MailOtherTextCell:init(data , fontName)
    self._datas = data
    self.fontName = fontName
	self:onInit()
    return self
end

function MailOtherTextCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_mail = ccui.Helper:seekWidgetByName(root,"Text_mail")
	if Text_mail~=nil then
		Text_mail:removeAllChildren(true)
	end
end

function MailOtherTextCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function MailOtherTextCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.mail.mail_text, root)
    root:removeFromParent(false)
    self.roots = {}
end

function MailOtherTextCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.mail.mail_text, self.roots[1])
end
