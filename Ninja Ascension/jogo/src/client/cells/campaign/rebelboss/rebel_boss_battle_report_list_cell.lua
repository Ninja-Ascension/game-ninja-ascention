-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军战报
-------------------------------------------------------------------------------------------------------

RebelBossBattleReportListCell = class("RebelBossBattleReportListCellClass", Window)
    
function RebelBossBattleReportListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.reward = nil

	
    -- Initialize RebelBossBattleReportListCell page state machine.
    local function init_rebel_boss_rank_list_cell()

    end
    
    -- call func init hom state machine.
    init_rebel_boss_rank_list_cell()
end

function RebelBossBattleReportListCell:initDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	
end

function RebelBossBattleReportListCell:createConfig(winMouldId, 	
												index,		
												experience,
												money, 		
												spoilsMouldId,
												spoilsType, 
												spoilsCount
												)
	-- winMouldId:  如果空,就表示该条显示的是失败信息,否则显示获得的物品名和文字品质
	local data = {}
	data.winMouldId 	= winMouldId or nil
	data.index 			= index or nil
	data.experience 	= experience or nil
	data.money 			= money or nil
	data.spoilsMouldId 	= spoilsMouldId or nil
	data.spoilsType 	= spoilsType or nil
	data.spoilsCount 	= spoilsCount or nil
	return data
end

function RebelBossBattleReportListCell:onEnterTransitionFinish()
	
    local csbArenaLadder = csb.createNode("campaign/WorldBoss/wordBoss_zhanbao_list.csb")
	local root = csbArenaLadder:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaLadder)
	
	local tmpPanel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	tmpPanel:setSwallowTouches(false)
	self:setContentSize(tmpPanel:getContentSize())
	self:initDraw()
end

function RebelBossBattleReportListCell:createCell()
	local cell = RebelBossBattleReportListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function RebelBossBattleReportListCell:init(reward)
	self.reward = reward
end


function RebelBossBattleReportListCell:onExit()
end
