-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场规则1
-------------------------------------------------------------------------------------------------------

ArenaRuleOneCell = class("ArenaRuleOneCellClass", Window)
ArenaRuleOneCell.__size = nil
function ArenaRuleOneCell:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize ArenaRuleOneCell page state machine.
    local function init_arena_rule_one_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_rule_one_cell_terminal()
end

function ArenaRuleOneCell:initDraw()
	local root = self.roots[1]

	--历史最高排名
	local maxRank = tonumber(_ED.user_arena_max_order)
	local Text_ranking_n = ccui.Helper:seekWidgetByName(root, "Text_ranking_n")
	Text_ranking_n:setString(maxRank)
	--取自己排名位的模板数据
	function getSectionIndex(userRank)
		-- 获取该排名的区间索引
		local index = 0
		for i, v in ipairs(dms["arena_reward_param"]) do
			local minRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_begin)
			local maxRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_end)
			if userRank > minRank and userRank < maxRank or userRank == minRank or userRank == maxRank then
				return i
			end
			index = i
		end
		return index
	end
	local sectionIndex = getSectionIndex(tonumber(_ED.arena_user_rank))

	--列表
	local ListView_ranking_reward = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward")
	ListView_ranking_reward:removeAllItems()
	-- 奖励荣誉*
	local targetHonor = dms.int(dms["arena_reward_param"], tonumber(sectionIndex), arena_reward_param.arena1_reward_bounty)
	local cell1 = ResourcesIconCell:createCell()
	cell1:init(3, targetHonor, -1,nil,nil,nil,true)
	ccui.Helper:seekWidgetByName(cell1.roots[1], "Panel_prop"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(cell1.roots[1], "Label_l-order_level"):setString(targetHonor)
	ListView_ranking_reward:addChild(cell1)
	-- 奖励银子*
	local targetCoin = dms.int(dms["arena_reward_param"], tonumber(sectionIndex), arena_reward_param.arena1_reward_silver)
	local cell2 = ResourcesIconCell:createCell()
	cell2:init(1, targetCoin, -1,nil,nil,nil,true)
	ccui.Helper:seekWidgetByName(cell2.roots[1], "Panel_prop"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(cell2.roots[1], "Label_l-order_level"):setString(targetCoin)
	ListView_ranking_reward:addChild(cell2)
	-- 奖励金币
	local targetItemNums = dms.int(dms["arena_reward_param"], tonumber(sectionIndex), arena_reward_param.arena1_reward_combat_food)
	local cell3 = ResourcesIconCell:createCell()
	cell3:init(2, targetItemNums, -1,nil,nil,nil,true)
	ccui.Helper:seekWidgetByName(cell3.roots[1], "Panel_prop"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(cell3.roots[1], "Label_l-order_level"):setString(targetItemNums)
	ListView_ranking_reward:addChild(cell3)

	-- 额外奖励内容
	local arena_reward_data  = dms.element(dms["arena_reward_param"], tonumber(sectionIndex))
    local extraRewardString  = arena_reward_data[arena_reward_param.arena_extra_reward]
	
	if extraRewardString ~= nil and tonumber(extraRewardString) ~= -1 then
		self:addExtraRewardToListView(extraRewardString, ListView_ranking_reward)
	end

	--区间
	local max = dms.int(dms["arena_reward_param"], tonumber(sectionIndex), arena_reward_param.arena_order_begin)
	local main = dms.int(dms["arena_reward_param"], tonumber(sectionIndex), arena_reward_param.arena_order_end)

	local Text_ranking_tip = ccui.Helper:seekWidgetByName(root, "Text_ranking_tip")
	-- Text_ranking_tip:setString(string.format(_new_interface_text[42], zstring.tonumber(main), zstring.tonumber(max)))
	Text_ranking_tip:setString(string.format(_new_interface_text[42], zstring.tonumber(max), zstring.tonumber(main)))
end

-- 添加额外奖励到ListView中
function ArenaRuleOneCell:addExtraRewardToListView(rewardString, listView)
	local rewardIcons = DrawHandle.drawIcons(rewardString)
	if rewardIcons ~= nil then
		for i, v in ipairs(rewardIcons) do
			listView:addChild(v)
		end
	end

	listView:requestRefreshView()
	listView:jumpToLeft()
end

function ArenaRuleOneCell:onEnterTransitionFinish()
	
end

function ArenaRuleOneCell:onInit()
	local root = cacher.createUIRef("campaign/ArenaStorage/ArenaStorage_rule_list_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if ArenaRuleOneCell.__size == nil then
	 	ArenaRuleOneCell.__size = root:getContentSize()
	end
	self:initDraw()
end

function ArenaRuleOneCell:clearUIInfo( ... )
	local root = self.roots[1]
	local ListView_ranking_reward = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward")
	if ListView_ranking_reward ~= nil then
		ListView_ranking_reward:removeAllItems()
	end
end

function ArenaRuleOneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaRuleOneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_rule_list_1.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaRuleOneCell:init()
	self:onInit()
	self:setContentSize(ArenaRuleOneCell.__size)
	return self
end

function ArenaRuleOneCell:createCell()
	local cell = ArenaRuleOneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function ArenaRuleOneCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_rule_list_1.csb", self.roots[1])
end
