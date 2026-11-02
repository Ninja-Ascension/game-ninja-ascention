-- ----------------------------------------------------------------------------------------------------
-- 说明：无限山一键三星奖励
-------------------------------------------------------------------------------------------------------

TrialTowerOneKeyRewardListCell = class("TrialTowerOneKeyRewardListCellClass", Window)
    
function TrialTowerOneKeyRewardListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self._reward = nil
	self._propPanels = nil
	self._current_floor = 0 
    -- Initialize TrialTowerOneKeyRewardListCell page state machine.
    local function init_trial_tower_one_key_reward_list_cell_terminal()
	
    end
    
    -- call func init hom state machine.
    init_trial_tower_one_key_reward_list_cell_terminal()
end

--道具
function TrialTowerOneKeyRewardListCell:getPropCell(mid, num)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = num
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cell:init(cellConfig)
	return cell
end

--威名
function TrialTowerOneKeyRewardListCell:getHonourCell(num)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldType = 18
	cellConfig.count = num
	cellConfig.isShowName = true
	cell:init(cellConfig)
	return cell
end

function TrialTowerOneKeyRewardListCell:initDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	for i=1,4 do
		local propPanel = self._propPanels[i]
		propPanel:removeAllChildren(true)
	end
	for k,v in pairs(self._reward) do
		local propPanel = self._propPanels[zstring.tonumber(k)]
		local cell = nil
		if propPanel ~= nil then 
			if tonumber(v.prop_type) == 6 then
				cell = self:getPropCell(tonumber(v.resource_id), tonumber(v.prop_count))
			elseif tonumber(v.prop_type) == 18 then
				cell = self:getHonourCell(tonumber(v.prop_count))
			end
			if nil ~= cell then
				propPanel:addChild(cell)
			end
		end
	end
	local startfloor = (self._current_floor - 1) * 3 + 1
	local endfloor = startfloor + 2 
	ccui.Helper:seekWidgetByName(root, "Text_287"):setString(string.format(tipStringInfo_trialTower[27],startfloor,endfloor))
end

function TrialTowerOneKeyRewardListCell:onEnterTransitionFinish()
    local csbArenaLadder = csb.createNode("campaign/TrialTower/trial_tower_3star_list_1.csb")
	local root = csbArenaLadder:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaLadder)
	
	self._propPanels = {
		ccui.Helper:seekWidgetByName(root, "Panel_345"),
		ccui.Helper:seekWidgetByName(root, "Panel_346"),
		ccui.Helper:seekWidgetByName(root, "Panel_347"),
		ccui.Helper:seekWidgetByName(root, "Panel_348"),
	}
	local tmpPanel = ccui.Helper:seekWidgetByName(root, "Panel_206")
	tmpPanel:setSwallowTouches(false)
	self:setContentSize(tmpPanel:getContentSize())
	self:initDraw()
end


function TrialTowerOneKeyRewardListCell:createCell()
	local cell = TrialTowerOneKeyRewardListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function TrialTowerOneKeyRewardListCell:init(reward,floor)
	self._reward = reward
	self._current_floor = floor
end

function TrialTowerOneKeyRewardListCell:onExit()
end
