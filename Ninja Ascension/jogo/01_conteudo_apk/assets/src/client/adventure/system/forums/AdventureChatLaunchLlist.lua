-- ----------------------------------------------------------------------------------------------------
-- 说明：回复信息list
-------------------------------------------------------------------------------------------------------
AdventureChatLaunchLlist = class("AdventureChatLaunchLlistClass", Window)
AdventureChatLaunchLlist.__size = nil

function AdventureChatLaunchLlist:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.info = nil
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_hero_icon_cell_terminal()
        
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_hero_icon_cell_terminal()
end

function AdventureChatLaunchLlist:onInit()
	local root = cacher.createUIRef("Chat/discussion_xiangqing_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	local Text_word = ccui.Helper:seekWidgetByName(root, "Text_word")
	Text_word:setString(zstring.exchangeFrom(self.info.message_content))
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	Text_number:setString(zstring.exchangeFrom(self.info.message_name))
	-- Get size for root node.
	if AdventureChatLaunchLlist.__size == nil then
		local size = root:getContentSize()
		AdventureChatLaunchLlist.__size = size
	end

end

function AdventureChatLaunchLlist:onExit()
	cacher.freeRef("Chat/discussion_xiangqing_list.csb", self.roots[1])
end


function AdventureChatLaunchLlist:init(info)
	self.info = info
	self:onInit()
	self:setContentSize(AdventureChatLaunchLlist.__size)
	return self
end

function AdventureChatLaunchLlist:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureChatLaunchLlist:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("Chat/discussion_xiangqing_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureChatLaunchLlist:createCell()
	local cell = AdventureChatLaunchLlist:new()
	cell:registerOnNodeEvent(cell)
	return cell
end