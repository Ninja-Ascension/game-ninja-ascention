----------------------------------------------------------------------------------------------------
-- 说明：消息推送标识
-------------------------------------------------------------------------------------------------------
NotificationTipCell = class("NotificationTipCellClass", Window)

function NotificationTipCell:ctor()
    self.super:ctor()

	self.roots = {}
	
	self.enum_type = {
		_NOTIFICATION_NO_NUM = 1,
		_NOTIFICATION_HAS_NUM = 2
	}
	
	self.counts = 1
	self.type = self.enum_type._NOTIFICATION_NO_NUM
end

function NotificationTipCell:onUpdateDraw()
	local root = self.roots[1]
	if self.type == self.enum_type._NOTIFICATION_NO_NUM then
		ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
	elseif self.type == self.enum_type._NOTIFICATION_HAS_NUM then
		ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(self.counts)
	end
end

function NotificationTipCell:onEnterTransitionFinish()
	local filePath = "home/home_tag.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function NotificationTipCell:onExit()

end

function NotificationTipCell:init(_counts)
	if _counts == nil then
		self.type = self.enum_type._NOTIFICATION_NO_NUM
	elseif _counts > 0 then
		self.type = self.enum_type._NOTIFICATION_HAS_NUM
		self.counts = _counts
	end
end

function NotificationTipCell:createCell()
	local cell = NotificationTipCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

