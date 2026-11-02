----------------------------------------------------------------------------------------------------
-- 说明：副本NPC对话气泡框
----------------------------------------------------------------------------------------------------
AdventureDuplicateNpcBubbleCell = class("AdventureDuplicateNpcBubbleCellClass", Window)

function AdventureDuplicateNpcBubbleCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.dir = 0
	self.text = ""

	-- Initialize adventure duplicate npc bubble cell state machine.
	local function init_adventure_duplicate_npc_bubble_cell_terminal()

        state_machine.init()
	end

	-- Initialize adventure duplicate npc bubble cell state machine.
	init_adventure_duplicate_npc_bubble_cell_terminal()
end

-- function AdventureDuplicateNpcBubbleCell:onEnterTransitionFinish()
-- end

function AdventureDuplicateNpcBubbleCell:onEnterTransitionFinish1()
	local root = self.roots[1]
	local dataText = ccui.Helper:seekWidgetByName(root, "Text_dialogue")
	local ttfConfig = {}
	ttfConfig.fontFilePath = dataText:getFontName()
	ttfConfig.fontSize = dataText:getFontSize()
	
	local lableCell = cc.Label:createWithTTF(ttfConfig,"", cc.TEXT_ALIGNMENT_LEFT, 0)
	lableCell:setColor(dataText:getTextColor())
	self.text = self.text .. self.text..self.text..self.text..self.text..self.text
	lableCell:setString(self.text)
	root:addChild(lableCell)
	
	lableCell:setWidth(dataText:getContentSize().width)
	self.text = nil
end

function AdventureDuplicateNpcBubbleCell:onInit()
	local fileName = nil
	if self.dir == 0 then
		fileName = "duplicate/battle_duihua_left.csb"
	else
		fileName = "duplicate/battle_duihua_right.csb"
	end
	local csbAdventureDuplicateNpcBubbleCell = csb.createNode(fileName)
 	local root = csbAdventureDuplicateNpcBubbleCell:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
 	self:addChild(root)

 	local dataText = ccui.Helper:seekWidgetByName(root, "Text_dialogue")
 	dataText:setTextAreaSize(cc.size(dataText:getContentSize().width, (26 * math.floor(#self.text/3) / dataText:getContentSize().width + 1) * 26))
	dataText:setString(self.text)

	local bgImage = ccui.Helper:seekWidgetByName(root, "Image_13")
	local imgSize = bgImage:getContentSize()
	local txtSize = dataText:getContentSize()
	bgImage:setContentSize(cc.size(imgSize.width, imgSize.height / 2 + txtSize.height))

	self:setContentSize(bgImage:getContentSize())
end

function AdventureDuplicateNpcBubbleCell:onExit()

end

function AdventureDuplicateNpcBubbleCell:init(dir, text)
	self.dir = dir -- 0：left、 1：right
	self.text = text
	self:onInit()
	return self
end

function AdventureDuplicateNpcBubbleCell:createCell()
	local cell = AdventureDuplicateNpcBubbleCell:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell)
	return cell
end

