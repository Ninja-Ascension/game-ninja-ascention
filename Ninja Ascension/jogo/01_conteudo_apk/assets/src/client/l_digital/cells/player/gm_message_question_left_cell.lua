----------------------------------------------------------------------------------------------------
-- 客服留言按钮cell
-------------------------------------------------------------------------------------------------------

GmMessageQuestionLeftCell = class("GmMessageQuestionLeftCellClass", Window)
GmMessageQuestionLeftCell.__Size = nil

function GmMessageQuestionLeftCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.infos = {}
    -- Initialize ChatStorage page state machine.
    local function init_gm_message_mine_cell_terminal()
    end

    -- call func init hom state machine.
    init_gm_message_mine_cell_terminal()
end

function GmMessageQuestionLeftCell:onUpdateDrawSm()
    local root = self.roots[1]
    local Button_tag = ccui.Helper:seekWidgetByName(root, "Button_tag")
    local Text_tag = ccui.Helper:seekWidgetByName(root, "Text_tag")
    Button_tag:setHighlighted(false)
    Button_tag:setTouchEnabled(true)
    if self.mSelect == self.mInfos.type then
        Button_tag:setHighlighted(true)
        Button_tag:setTouchEnabled(false)
    end

    local word_info = dms.element(dms["word_mould"], self.mInfos.typeName)
    Text_tag:setString(word_info[3] .. "")

    fwin:addTouchEventListener(
        Button_tag,
        nil,
        {
            terminal_name = "sm_player_system_qa_message_btn_page",
            terminal_state = 0,
            m_type = self.mInfos.type,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function GmMessageQuestionLeftCell:onInit()
    local root = nil
    root = cacher.createUIRef("player/role_information_gm_message_tab_cell.csb", "root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    if GmMessageQuestionLeftCell.__size == nil then
		GmMessageQuestionLeftCell.__size = root:getContentSize()
	end
    self:onUpdateDrawSm()
end

function GmMessageQuestionLeftCell:clearUIInfo(...)
    local root = self.roots[1]

    if self.__contentSize ~= nil then
        self:setContentSize(self.__contentSize)
    end
end

function GmMessageQuestionLeftCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("player/role_information_gm_message_tab_cell.csb", self.roots[1])
end

function GmMessageQuestionLeftCell:init(params)
    self.mInfos = params.mInfos
    self.mSelect = params.mSelect
	self:onInit()
	self:setContentSize(GmMessageQuestionLeftCell.__size)
    return self
end

function GmMessageQuestionLeftCell:createCell()
    local cell = GmMessageQuestionLeftCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
