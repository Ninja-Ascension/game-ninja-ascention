----------------------------------------------------------------------------------------------------
-- 客服留言文字cell
-------------------------------------------------------------------------------------------------------

GmMessageQuestionRightCell = class("GmMessageQuestionRightCellClass", Window)
GmMessageQuestionRightCell.__size = nil
function GmMessageQuestionRightCell:ctor()
    self.super:ctor()
    self.roots = {}
end

function GmMessageQuestionRightCell:onUpdateDrawSm()
    local root = self.roots[1]

    local Image_question = ccui.Helper:seekWidgetByName(root, "Image_question")

    local Image_answer = ccui.Helper:seekWidgetByName(root, "Image_answer")

	local char_str = ""
    if self.qaType == 4 then
        Image_question:setVisible(true)
		Image_answer:setVisible(false)
		char_str = dms.element(dms["word_mould"], self.mInfos.qustName)[3]..""
	else
        Image_question:setVisible(false)
		Image_answer:setVisible(true)
		char_str = dms.element(dms["word_mould"], self.mInfos.aswName)[3]..""
    end
    local Text_message_infor_1_2 = ccui.Helper:seekWidgetByName(root, "Text_message_infor_1_2")
    Text_message_infor_1_2:removeAllChildren(true)
    local Panel_message_box_2 = ccui.Helper:seekWidgetByName(root, "Panel_message_box_2")

    local Panel_message_2 = ccui.Helper:seekWidgetByName(root, "Panel_message_2")

    local index = 0
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)
    _richText2:setContentSize(cc.size(Panel_message_2:getContentSize().width, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    

    Text_message_infor_1_2:setString("")
    char_str = smWidthSingle(char_str, Text_message_infor_1_2:getFontSize() / 2, Panel_message_2:getContentSize().width + Text_message_infor_1_2:getFontSize() * 5)
    local rt, count, text = draw.richTextCollectionMethod(_richText2, char_str, cc.c3b(0, 0, 0), cc.c3b(255, 255, 0), 0, 0, "", Text_message_infor_1_2:getFontSize(), chat_rich_text_color)
    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then 
        Text_message_infor_1_2:addChild(_richText2)

        local curHeight = _richText2:getContentSize().height + Image_answer:getContentSize().height
        local pixHeight = root:getContentSize().height - curHeight

        Panel_message_box_2:setPositionY(Panel_message_box_2:getPositionY() - pixHeight)

        root:setPosition(cc.p(0, root:getPositionY() - pixHeight))
        root:setContentSize(cc.size(root:getContentSize().width,curHeight))
        self:setContentSize(root:getContentSize())
    else
        _richText2:setPositionY(Text_message_infor_1_2:getPositionY() - Panel_message_2:getContentSize().height + 7)
        _richText2:setPositionX(_richText2:getPositionX())
        Text_message_infor_1_2:addChild(_richText2)
        index = index + rsize.height
        
        root:setContentSize(cc.size(_richText2:getContentSize().width,_richText2:getContentSize().height + root:getContentSize().height/2 - 11))
        root:setAnchorPoint(cc.p(0, 0))
        root:setPosition(cc.p(0, - (root:getContentSize().height - _richText2:getContentSize().height)))
    end
end

function GmMessageQuestionRightCell:onInit()
    local root = nil
    local csbNode = csb.createNode("player/role_information_gm_message_cell_3.csb")
	local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
    else
        root:setAnchorPoint(cc.p(0, 1))
        root:setPosition(cc.p(0,root:getContentSize().height))
    end
	self:addChild(root)
	self:onUpdateDrawSm()
	
    if GmMessageQuestionRightCell.__size == nil then
		GmMessageQuestionRightCell.__size = root:getContentSize()
    end
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
    else
        self:setContentSize(GmMessageQuestionRightCell.__size)
    end
end

function GmMessageQuestionRightCell:clearUIInfo(...)
	local root = self.roots[1]
	if root == nil then
		return
	end
end

function GmMessageQuestionRightCell:onExit()

end

function GmMessageQuestionRightCell:init(params)
    self.mInfos = params.mInfos
    self.qaType = params.qaType
    self:onInit()
    return self
end

function GmMessageQuestionRightCell:createCell()
    local cell = GmMessageQuestionRightCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
