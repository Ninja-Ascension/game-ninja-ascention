-- ----------------------------------------------------------------------------------------------------
-- 说明：名人堂人物动画左
-- 创建时间	2015.5.4
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FameHallShowPlayTwo = class("FameHallShowPlayTwoClass", Window)
    
function FameHallShowPlayTwo:ctor()
    self.super:ctor()
    self.roots = {}
	self.passage = nil
end

function FameHallShowPlayTwo:onEnterTransitionFinish()
	local csbFameHallShowPlayTwo = csb.createNode("system/famous_general_qipao_2.csb")
	self:addChild(csbFameHallShowPlayTwo)
	local root = csbFameHallShowPlayTwo:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("system/famous_general_qipao_2.csb")
    csbFameHallShowPlayTwo:runAction(action)
	action:play("qipao_dh_zuo", false)
	
	ccui.Helper:seekWidgetByName(root, "Text_6_0_2_2"):setString(self.passage)
end

function FameHallShowPlayTwo:init(passage)
	self.passage = passage
end

function FameHallShowPlayTwo:onExit()

end

function FameHallShowPlayTwo:createCell()
	local cell = FameHallShowPlayTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end