-- ----------------------------------------------------------------------------------------------------
-- 说明：无限山一键三星加层
-------------------------------------------------------------------------------------------------------

TrialTowerOneKeyTotalListCell = class("TrialTowerOneKeyTotalListCellClass", Window)
    
function TrialTowerOneKeyTotalListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self._honour = 0
	self._silver = 0
	self._props = nil
	self._otherCounts = 0	
	app.load("client.cells.prop.model_prop_icon_cell")
	app.load("client.cells.prop.model_prop_icon_cell")
    -- Initialize TrialTowerOneKeyTotalListCell page state machine.
    local function init_trial_tower_one_key_addition_list_cell_terminal()
	
    end
    
    -- call func init hom state machine.
    init_trial_tower_one_key_addition_list_cell_terminal()
end

function TrialTowerOneKeyTotalListCell:initDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local propPanels = {}
	for i=1,12 do
		local index = 344 
		local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_" .. index+i)
		propPanel:removeAllChildren(true)
		table.insert(propPanels,propPanel)
	end
	ccui.Helper:seekWidgetByName(root, "Text_062_0"):setString("" .. self._honour)
	ccui.Helper:seekWidgetByName(root, "Text_152_0"):setString("" .. self._silver) --资金
	local counts = 0
	for k,v in pairs(self._props) do
		local cell = ModelPropIconCell:createCell()
		local cellConfig = cell:createConfig()
		cellConfig.mouldId = zstring.tonumber(k)
		cellConfig.count = zstring.tonumber(v)
		cellConfig.isShowName = false
		cellConfig.isDebris = true
		cell:init(cellConfig)
		counts = counts + 1
		local panel = propPanels[counts]
		if panel ~= nil then 
			panel:addChild(cell)
		end
	end
	counts = counts + 1
	if self._otherCounts > 0 then 
		local cell = ModelPropIconCell:createCell()
		local cellConfig = cell:createConfig()
		cellConfig.mouldType = 18
		cellConfig.count = self._otherCounts
		cellConfig.isShowName = false
		cell:init(cellConfig)
		local panel = propPanels[counts]
		if panel ~= nil then 
			panel:addChild(cell)
		end
	end
end

function TrialTowerOneKeyTotalListCell:onEnterTransitionFinish()
    local csbArenaLadder = csb.createNode("campaign/TrialTower/trial_tower_3star_list_3.csb")
	local root = csbArenaLadder:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaLadder)
	local tmpPanel = ccui.Helper:seekWidgetByName(root, "Panel_206")
	tmpPanel:setSwallowTouches(false)
	self:setContentSize(tmpPanel:getContentSize())
	self:initDraw()
end

function TrialTowerOneKeyTotalListCell:createCell()
	local cell = TrialTowerOneKeyTotalListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function TrialTowerOneKeyTotalListCell:init(honour,silver,props,others)
	self._honour = honour
	self._silver = silver
	self._props = props
	self._otherCounts = others	
end

function TrialTowerOneKeyTotalListCell:onExit()
end
