----------------------------------------------------------------------------------------------------
-- 说明：对话气泡框
----------------------------------------------------------------------------------------------------
AdventureMineBubble = class("AdventureMineBubbleClass", Window)

function AdventureMineBubble:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.cell = nil
	
	self.text = 0

	-- Initialize adventure dialogue bubble cell state machine.
	local function init_adventure_dialogue_bubble_cell_terminal()

        state_machine.init()
	end

	-- Initialize adventure dialogue bubble cell state machine.
	init_adventure_dialogue_bubble_cell_terminal()
end

function AdventureMineBubble:onEnterTransitionFinish()
	
end

function AdventureMineBubble:onInit()
	local csbAdventureDialogueBubbleCell = csb.createNode("utils/talk_data.csb")
 	local root = csbAdventureDialogueBubbleCell:getChildByName("root")
    table.insert(self.roots, root)

    root:removeFromParent(false)
 	self:addChild(root)

 	local dataText = ccui.Helper:seekWidgetByName(root, "Text_data")
	dataText:setString(self.text)

	local bgImage = ccui.Helper:seekWidgetByName(root, "Image_1")
	local imgSize = bgImage:getContentSize()
	local txtSize = dataText:getContentSize()
	bgImage:setContentSize(cc.size(txtSize.width + 50, imgSize.height))

	self:setContentSize(bgImage:getContentSize())
	local pos = cc.p(self.cell:getPosition())
	local cellSize = cc.size(self.cell:getContentSize().width,self.cell:getContentSize().height)
	self:setPosition(cc.p(pos.x + cellSize.width /2 ,pos.y + cellSize.height))
end

function AdventureMineBubble:onExit()

end

function AdventureMineBubble:init(node,text)
	self.text = text
	self.cell = node

	self:onInit()

	return self
end

function AdventureMineBubble:createCell()
	local cell = AdventureMineBubble:new()
	cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 0)
	return cell
end

