-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场一键扫荡奖励
-------------------------------------------------------------------------------------------------------

ArenaMopRewardListCell = class("ArenaMopRewardListCellClass", Window)
    
function ArenaMopRewardListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.reward = nil

	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.model_prop_icon_cell")
    -- Initialize ArenaMopRewardListCell page state machine.
    local function init_arena_mop_reward_list_cell()

    end
    
    -- call func init hom state machine.
    init_arena_mop_reward_list_cell()
end

function ArenaMopRewardListCell:initDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	ccui.Helper:seekWidgetByName(root, "Text_9"):setString(_string_piece_info[2]..self.reward._fight_times.._string_piece_info[70])
	local activityText = ccui.Helper:seekWidgetByName(root, "Text_303_0")
	if _ED.active_activity[43] ~= nil and _ED.active_activity[43]~="" then
		--有双倍活动
		activityText:setVisible(true)
	else
		activityText:setVisible(false)
	end
	ccui.Helper:seekWidgetByName(root, "Text_303"):setString(self.reward._honour)
	ccui.Helper:seekWidgetByName(root, "Text_304"):setString(self.reward._silver)
	ccui.Helper:seekWidgetByName(root, "Text_305"):setString(self.reward._exp)
	local winPanel = ccui.Helper:seekWidgetByName(root, "Panel_8")
	if self.reward._fight_reward == 0 then 
		winPanel:setVisible(false)
	else
		winPanel:setVisible(true)
	end
	local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_7")
	propPanel:removeAllChildren(true)
	local resourcesId = self.reward._card_reward
	if resourcesId ~= 0 then--翻牌奖励(0没有,资源类型id)
		local cell = ModelPropIconCell:createCell()
		local cellConfig = cell:createConfig(self.reward._id, self.reward._reward_counts, true, nil, resourcesId)
		cell:init(cellConfig)
		propPanel:addChild(cell)
	end
end

function ArenaMopRewardListCell:createConfig(winMouldId, 	
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

function ArenaMopRewardListCell:onEnterTransitionFinish()
	
    local csbArenaLadder = csb.createNode("campaign/ArenaStorage/ArenaStorage_results_list.csb")
	local root = csbArenaLadder:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaLadder)
	
	local tmpPanel = ccui.Helper:seekWidgetByName(root, "Panel_dbzb_list")
	tmpPanel:setSwallowTouches(false)
	self:setContentSize(tmpPanel:getContentSize())
	self:initDraw()
end

function ArenaMopRewardListCell:createCell()
	local cell = ArenaMopRewardListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function ArenaMopRewardListCell:init(reward)
	self.reward = reward
end


function ArenaMopRewardListCell:onExit()
end
