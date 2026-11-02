-- ----------------------------------------------------------------------------------------------------
-- 说明：无限山一键三星加层
-------------------------------------------------------------------------------------------------------

TrialTowerOneKeyAdditionListCell = class("TrialTowerOneKeyAdditionListCellClass", Window)
    
function TrialTowerOneKeyAdditionListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self._reward = nil
	
    -- Initialize TrialTowerOneKeyAdditionListCell page state machine.
    local function init_trial_tower_one_key_addition_list_cell_terminal()
	
    end
    
    -- call func init hom state machine.
    init_trial_tower_one_key_addition_list_cell_terminal()
end

function TrialTowerOneKeyAdditionListCell:initDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local addition = zstring.split(""..self._reward.describe ,",")
	if #addition == 2 then 
		local add_type = zstring.tonumber(addition[1]) + 1
		ccui.Helper:seekWidgetByName(root, "Text_062_0"):setString(string_equiprety_name_teo[add_type] .. "+" .. addition[2]..string_equiprety_name_vlua_type[add_type])
		ccui.Helper:seekWidgetByName(root, "Text_152_0"):setString("" ..self._reward.consume ..tipStringInfo_trialTower[4])
	end
end

function TrialTowerOneKeyAdditionListCell:onEnterTransitionFinish()
    local csbArenaLadder = csb.createNode("campaign/TrialTower/trial_tower_3star_list_2.csb")
	local root = csbArenaLadder:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaLadder)
	local tmpPanel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	tmpPanel:setSwallowTouches(false)
	self:setContentSize(tmpPanel:getContentSize())
	self:initDraw()
end

function TrialTowerOneKeyAdditionListCell:createCell()
	local cell = TrialTowerOneKeyAdditionListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function TrialTowerOneKeyAdditionListCell:init(reward)
	self._reward = reward
end

function TrialTowerOneKeyAdditionListCell:onExit()
end
