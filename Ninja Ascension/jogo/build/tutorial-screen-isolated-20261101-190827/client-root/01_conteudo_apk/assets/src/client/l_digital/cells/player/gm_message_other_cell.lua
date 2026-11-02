----------------------------------------------------------------------------------------------------
-- 说明：GM留言界面cell
-------------------------------------------------------------------------------------------------------

GmMessageOtherCell = class("GmMessageOtherCellClass", Window)
    
function GmMessageOtherCell:ctor()
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
	self.message = nil
	self.notificationId = 0
	self.jumpParams = nil
	app.load("client.chat.ChatFriendInfo")
    -- Initialize ChatStorage page state machine.
    local function init_gm_message_other_cell_terminal()

        state_machine.init()
    end
    
    init_gm_message_other_cell_terminal()
end


function GmMessageOtherCell:drawHead()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon_2")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

    local quality_path = ""
    quality_path = "images/ui/quality/player_1.png"
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(SpritKuang,0)

    local big_icon_path = ""
    if zstring.tonumber(self.pic) == 0 then
    	self.pic = 1
    end
    big_icon_path = string.format("images/ui/home/head_%d.png", self.pic)
    local sprit = cc.Sprite:create(big_icon_path)
    sprit:setAnchorPoint(cc.p(0.5,0.5))
    sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(sprit,0)
end

function GmMessageOtherCell:onUpdateDrawSm()
	local root = self.roots[1]
	local Text_103_0 = ccui.Helper:seekWidgetByName(root, "Text_message_infor_1_2")
	Text_103_0:removeAllChildren(true)
	local Panel_chat_2 = ccui.Helper:seekWidgetByName(root, "Panel_message_box_2")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_palyer_name_2")
	local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_message_2")
	local Text_message_time_2 = ccui.Helper:seekWidgetByName(root, "Text_message_time_2")

	nameText.__positionX = nameText:getPositionX()
	Panel_5:removeAllChildren(true)
	nameText:setString(self.name)
	Text_message_time_2:setString(getRedAlertTimeFormatYMDHMS(self.m_time))

	-- self:drawHead()
	index = 0
	local _richText2 = ccui.RichText:create()
	_richText2:ignoreContentAdaptWithSize(false)
	_richText2:setContentSize(cc.size(Panel_5:getContentSize().width+Text_103_0:getFontSize()*5, 0))
	_richText2:setAnchorPoint(cc.p(0, 0))
	local char_str = self.info
    Text_103_0:setString("")
	char_str = smWidthSingle(char_str,Text_103_0:getFontSize()/2,Panel_5:getContentSize().width+Text_103_0:getFontSize()*5)
	local rt, count, text = draw.richTextCollectionMethod(_richText2, 
	char_str, 
	cc.c3b(0, 0, 0),
	cc.c3b(0, 0, 0),
	0, 
	0, 
	"", 
	Text_103_0:getFontSize(),
	chat_rich_text_color)
	_richText2:formatTextExt()
	local rsize = _richText2:getContentSize()
	_richText2:setPositionY(Text_103_0:getPositionY() - Panel_5:getContentSize().height + 2)
	_richText2:setPositionX(nameText:getPositionX() - rsize.width + 8)
	Text_103_0:addChild(_richText2)
	index = index + rsize.height
	self:setContentSize(Panel_chat_2:getContentSize())
end

function GmMessageOtherCell:onInit()
	local root = nil
	root = cacher.createUIRef("player/role_information_gm_message_cell_2.csb", "root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self.__contentSize = self:getContentSize()
	self:onUpdateDrawSm()

end

function GmMessageOtherCell:clearUIInfo( ... )
	local root = self.roots[1]
	local Text_103_0 = ccui.Helper:seekWidgetByName(root, "Text_message_infor_1_2")
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_message_box_2")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_palyer_name_2")
	if Text_103_0 ~= nil then
		Text_103_0:removeAllChildren(true)
	end
	if panel ~= nil then
		panel:removeAllChildren(true)
	end
	if nameText ~= nil and nameText.__positionX ~= nil then
		nameText:setPositionX(nameText.__positionX)
	end
	if self.__contentSize ~= nil then
		self:setContentSize(self.__contentSize)
	end
	self.notificationId = 0
	self.jumpParams = nil
end

function GmMessageOtherCell:onExit()
	-- self:clearUIInfo()
	cacher.freeRef("player/role_information_gm_message_cell_2.csb", self.roots[1])
end

function GmMessageOtherCell:init(info,times)
	self.name = "GM"
	self.info = info
	self.pic = 1
	self.m_time = tonumber(times)/1000
	self:onInit()
	return self
end

function GmMessageOtherCell:createCell()
	local cell = GmMessageOtherCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end