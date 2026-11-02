----------------------------------------------------------------------------------------------------
-- 说明：GM留言界面cell
-------------------------------------------------------------------------------------------------------

GmMessageMineCell = class("GmMessageMineCellClass", Window)
    
function GmMessageMineCell:ctor()
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
	self.str2 = nil
	self.message = nil
	self.notificationId = 0
	self.jumpParams = nil
    -- Initialize ChatStorage page state machine.
    local function init_gm_message_mine_cell_terminal()
		local gm_message_mine_cell_click_head_terminal = {
            _name = "gm_message_mine_cell_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				TipDlg.drawTextDailog(_string_piece_info[258])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(gm_message_mine_cell_join_purify_team_terminal)
		state_machine.add(gm_message_mine_cell_click_head_terminal)
		state_machine.add(gm_message_mine_cell_jump_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_gm_message_mine_cell_terminal()
end



function GmMessageMineCell:drawHead()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon_1")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

    local quality_path = ""
    quality_path = "images/ui/quality/player_1.png"
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(SpritKuang,0)

    local big_icon_path = ""
    local pic = tonumber(_ED.user_info.user_head)
    if tonumber(pic) >= 9 then
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    end
    local sprit = cc.Sprite:create(big_icon_path)
    sprit:setAnchorPoint(cc.p(0.5,0.5))
    sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(sprit,0)
end

function GmMessageMineCell:onUpdateDrawSm()
	local root = self.roots[1]
	local Text_103_0_4 = ccui.Helper:seekWidgetByName(root, "Text_message_infor_1")
	Text_103_0_4:removeAllChildren(true)
	local Panel_chat_2_5 = ccui.Helper:seekWidgetByName(root, "Panel_message_box_1")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_palyer_name_1")
	local Panel_16 = ccui.Helper:seekWidgetByName(root, "Panel_message_1")
	local Text_message_time_1 = ccui.Helper:seekWidgetByName(root, "Text_message_time")
	nameText.__positionX = nameText:getPositionX()
	nameText:setString(self.name)
	nameText:removeAllChildren(true)
	Text_message_time_1:setString(getRedAlertTimeFormatYMDHMS(self.m_time))

	self:drawHead()
	local index = 0
	local _richText2 = ccui.RichText:create()
	_richText2:ignoreContentAdaptWithSize(false)
	_richText2:setContentSize(cc.size(Panel_16:getContentSize().width+Text_103_0_4:getFontSize()*5, 0))
	_richText2:setAnchorPoint(cc.p(0, 0))
	local char_str = self.info

    Text_103_0_4:setString("")
	char_str = smWidthSingle(char_str,Text_103_0_4:getFontSize()/2,Panel_16:getContentSize().width+Text_103_0_4:getFontSize()*5)
	local rt, count, text = draw.richTextCollectionMethod(_richText2, 
	char_str, 
	cc.c3b(0, 0, 0),
	cc.c3b(0, 0, 0),
	0, 
	0, 
	"", 
	Text_103_0_4:getFontSize(),
	chat_rich_text_color)
	_richText2:formatTextExt()
	local rsize = _richText2:getContentSize()
	_richText2:setPositionY(Text_103_0_4:getPositionY() - Panel_16:getContentSize().height + 7)
	_richText2:setPositionX(_richText2:getPositionX())
	Text_103_0_4:addChild(_richText2)
	index = index + rsize.height
	self:setContentSize(Panel_chat_2_5:getContentSize())

end

function GmMessageMineCell:onInit()
	local root = nil
	root = cacher.createUIRef("player/role_information_gm_message_cell_1.csb", "root")
	table.insert(self.roots, root)
	root:removeFromParent(false)	
	self:addChild(root)
	self.__contentSize = self:getContentSize()
	self:onUpdateDrawSm()
end

function GmMessageMineCell:clearUIInfo( ... )
	local root = self.roots[1]
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_message_box_1")
	local Text_103_0_4 = ccui.Helper:seekWidgetByName(root, "Text_message_infor_1")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_palyer_name_1")
	if panel ~= nil then
		panel:removeAllChildren(true)
	end
	if Text_103_0_4 ~= nil then
		Text_103_0_4:removeAllChildren(true)
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

function GmMessageMineCell:onExit()
	-- self:clearUIInfo()
	cacher.freeRef("player/role_information_gm_message_cell_1.csb", self.roots[1])
end

function GmMessageMineCell:init(info,times)
	self.name = _ED.user_info.user_name
	self.info = info
	self.pic = 2
	self.m_time = tonumber(times)/1000
	self:onInit()
	return self
end

function GmMessageMineCell:createCell()
	local cell = GmMessageMineCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end