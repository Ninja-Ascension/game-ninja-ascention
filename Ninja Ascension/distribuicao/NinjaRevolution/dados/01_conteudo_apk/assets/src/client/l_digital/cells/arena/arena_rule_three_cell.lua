-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场规则3
-------------------------------------------------------------------------------------------------------

ArenaRuleThreeCell = class("ArenaRuleThreeCellClass", Window)
ArenaRuleThreeCell.__size = nil
function ArenaRuleThreeCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize ArenaRuleThreeCell page state machine.
    local function init_arena_rule_three_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_rule_three_cell_terminal()
end

function ArenaRuleThreeCell:initDraw()
	local root = self.roots[1]

	--列表
	local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
	ListView_ranking_reward_2:removeAllItems()
	-- 奖励荣誉*
	local targetHonor = dms.int(dms["arena_reward_param"], self.m_index, arena_reward_param.arena1_reward_bounty)
	local cell1 = ResourcesIconCell:createCell()
	cell1:init(3, targetHonor, -1,nil,nil,nil,true)
	ccui.Helper:seekWidgetByName(cell1.roots[1], "Panel_prop"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(cell1.roots[1], "Label_l-order_level"):setString(targetHonor)
	ListView_ranking_reward_2:addChild(cell1)
	-- 奖励银子*
	local targetCoin = dms.int(dms["arena_reward_param"], self.m_index, arena_reward_param.arena1_reward_silver)
	local cell2 = ResourcesIconCell:createCell()
	cell2:init(1, targetCoin, -1,nil,nil,nil,true)
	ccui.Helper:seekWidgetByName(cell2.roots[1], "Panel_prop"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(cell2.roots[1], "Label_l-order_level"):setString(targetCoin)
	ListView_ranking_reward_2:addChild(cell2)
	-- 奖励金币
	local targetItemNums = dms.int(dms["arena_reward_param"], self.m_index, arena_reward_param.arena1_reward_combat_food)
	local cell3 = ResourcesIconCell:createCell()
	cell3:init(2, targetItemNums, -1,nil,nil,nil,true)
	ccui.Helper:seekWidgetByName(cell3.roots[1], "Panel_prop"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(cell3.roots[1], "Label_l-order_level"):setString(targetItemNums)
	ListView_ranking_reward_2:addChild(cell3)

	-- 额外奖励内容
	local arena_reward_data  = dms.element(dms["arena_reward_param"], self.m_index)
    local extraRewardString  = arena_reward_data[arena_reward_param.arena_extra_reward]

	if extraRewardString ~= nil and tonumber(extraRewardString) ~= -1 then
		self:addExtraRewardToListView(extraRewardString, ListView_ranking_reward_2)
	end

	--排名
	local rank = dms.int(dms["arena_reward_param"], self.m_index, arena_reward_param.arena_order_begin)

	local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	Text_ranking:setString(string.format(_new_interface_text[43],zstring.tonumber(rank)))

end

-- 添加额外奖励到ListView中
function ArenaRuleThreeCell:addExtraRewardToListView(rewardString, listView)
	local rewardIcons = DrawHandle.drawIcons(rewardString)
	if rewardIcons ~= nil then
		for i, v in ipairs(rewardIcons) do
			listView:addChild(v)
		end
	end

	listView:requestRefreshView()
	listView:jumpToLeft()
end

function ArenaRuleThreeCell:onEnterTransitionFinish()
	
end

function ArenaRuleThreeCell:onInit()
	local root = cacher.createUIRef("campaign/ArenaStorage/ArenaStorage_rule_list_3.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if ArenaRuleThreeCell.__size == nil then
	 	ArenaRuleThreeCell.__size = root:getContentSize()
	end
	self:initDraw()
end

function ArenaRuleThreeCell:clearUIInfo( ... )
	local root = self.roots[1]
	local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
	if ListView_ranking_reward_2 ~= nil then
		ListView_ranking_reward_2:removeAllItems()
	end
end

function ArenaRuleThreeCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaRuleThreeCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_rule_list_3.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaRuleThreeCell:init(index)
	self.m_index = index
	self:onInit()
	self:setContentSize(ArenaRuleThreeCell.__size)
	return self
end

function ArenaRuleThreeCell:createCell()
	local cell = ArenaRuleThreeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function ArenaRuleThreeCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_rule_list_3.csb", self.roots[1])
end
