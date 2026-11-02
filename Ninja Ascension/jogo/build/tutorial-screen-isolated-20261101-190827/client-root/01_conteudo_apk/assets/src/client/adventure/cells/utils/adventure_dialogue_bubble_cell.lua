----------------------------------------------------------------------------------------------------
-- 说明：对话气泡框
----------------------------------------------------------------------------------------------------
AdventureDialogueBubbleCell = class("AdventureDialogueBubbleCellClass", Window)

function AdventureDialogueBubbleCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.text = 0

	-- Initialize adventure dialogue bubble cell state machine.
	local function init_adventure_dialogue_bubble_cell_terminal()

        state_machine.init()
	end

	-- Initialize adventure dialogue bubble cell state machine.
	init_adventure_dialogue_bubble_cell_terminal()
end

function AdventureDialogueBubbleCell:onEnterTransitionFinish()
	
end

function AdventureDialogueBubbleCell:onInit()
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
end

function AdventureDialogueBubbleCell:onExit()

end

function AdventureDialogueBubbleCell:init(text)
	self.text = text

	self:onInit()
	return self
end

function AdventureDialogueBubbleCell:createCell()
	local cell = AdventureDialogueBubbleCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

