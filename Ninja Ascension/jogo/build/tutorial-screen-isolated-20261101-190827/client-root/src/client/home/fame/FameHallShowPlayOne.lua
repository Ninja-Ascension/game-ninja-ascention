-- ----------------------------------------------------------------------------------------------------
-- 说明：名人堂人物动画右
-- 创建时间	2015.5.4
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FameHallShowPlayOne = class("FameHallShowPlayOneClass", Window)
    
function FameHallShowPlayOne:ctor()
    self.super:ctor()
    self.roots = {}
	self.passage = nil
end

function FameHallShowPlayOne:onEnterTransitionFinish()
	local csbFameHallShowPlayOne = csb.createNode("system/famous_general_qipao_1.csb")
	self:addChild(csbFameHallShowPlayOne)
	local root = csbFameHallShowPlayOne:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("system/famous_general_qipao_1.csb")
    csbFameHallShowPlayOne:runAction(action)
	action:play("qipao_dh", false)
	
	ccui.Helper:seekWidgetByName(root, "Text_6_0_2"):setString(self.passage)
end

function FameHallShowPlayOne:init(passage)
	self.passage = passage
end

function FameHallShowPlayOne:onExit()

end

function FameHallShowPlayOne:createCell()
	local cell = FameHallShowPlayOne:new()
	cell:registerOnNodeEvent(cell)
	return cell
end