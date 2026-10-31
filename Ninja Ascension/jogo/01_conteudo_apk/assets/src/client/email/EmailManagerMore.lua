-- ----------------------------------------------------------------------------------------------------
-- 说明：邮件more
-- 创建时间	2015-04-23
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EmailManagerMore = class("EmailManagerMoreClass", Window)
    
function EmailManagerMore:ctor()
    self.super:ctor()
	self.roots = {}

end

function EmailManagerMore:onEnterTransitionFinish()
	local csbEmailManagerMore = csb.createNode("email/email_list_more.csb")
	self:addChild(csbEmailManagerMore)
	local root = csbEmailManagerMore:getChildByName("root")
	table.insert(self.roots, root)
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local MySize = Panel_2:getContentSize()
	self:setContentSize(MySize)
	
end

function EmailManagerMore:onExit()

end

function EmailManagerMore:createCell()
	local cell = EmailManagerMore:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
