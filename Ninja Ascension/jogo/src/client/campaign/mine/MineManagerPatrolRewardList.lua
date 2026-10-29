-----------------------------------------------------------------------------
-- 巡逻的奖励领取获得的列表项
--
-----------------------------------------------------------------------------
MineManagerPatrolRewardList = class("MineManagerPatrolRewardListClass", Window)
    
function MineManagerPatrolRewardList:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.cellIndex = 1
end

--道具
function MineManagerPatrolRewardList:getPropCell(mid, num,mtype)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = num
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cell:init(cellConfig)
	return cell
end


function MineManagerPatrolRewardList:onEnterTransitionFinish()

	local csbHeroChooseForRebornCell = csb.createNode("campaign/MineManager/attack_territory_patrol_rew_k.csb")
	local root = csbHeroChooseForRebornCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_205")
	local size = panel:getContentSize()
	self:setContentSize(size)
	
	self.panelList = {
		ccui.Helper:seekWidgetByName(root, "Panel_31"),
		ccui.Helper:seekWidgetByName(root, "Panel_32"),
		ccui.Helper:seekWidgetByName(root, "Panel_33"),
		ccui.Helper:seekWidgetByName(root, "Panel_34"),
	}
end



function MineManagerPatrolRewardList:addCell(data)

	if self.cellIndex > #self.panelList then
		return
	end
	
	local mid = data.mid
	local num = data.num
	local mtype = data.mtype
	
	local cell = self:getPropCell(mid, num,mtype)
	self.panelList[self.cellIndex]:addChild(cell)
	self.cellIndex = self.cellIndex + 1
end

function MineManagerPatrolRewardList:init()
	
end

function MineManagerPatrolRewardList:onExit()
	
end

function MineManagerPatrolRewardList:createCell()
	local cell = MineManagerPatrolRewardList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end