-- ----------------------------------------------------------------------------------------------------
-- 说明：试炼规则1
-------------------------------------------------------------------------------------------------------

SmTrialTowerRuleOneCell = class("SmTrialTowerRuleOneCellClass", Window)
SmTrialTowerRuleOneCell.__size = nil
function SmTrialTowerRuleOneCell:ctor()
    self.super:ctor()
    self.roots = {}
	
    -- Initialize SmTrialTowerRuleOneCell page state machine.
    local function init_sm_trial_tower_rule_one_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_sm_trial_tower_rule_one_cell_terminal()
end

function SmTrialTowerRuleOneCell:initDraw()
	local root = self.roots[1]
	--当前排名
	local Text_ranking_n = ccui.Helper:seekWidgetByName(root,"Text_ranking_n")
	--描述
	local Text_ranking_tip = ccui.Helper:seekWidgetByName(root,"Text_ranking_tip")

	--奖励列表
	local ListView_ranking_reward = ccui.Helper:seekWidgetByName(root,"ListView_ranking_reward")
	ListView_ranking_reward:removeAllItems()
	function getSectionIndex(userRank)
		-- 获取该排名的区间索引
		local index = 0
		for i, v in ipairs(dms["three_kingdoms_rank_reward_param"]) do
			local minRank = dms.int(dms["three_kingdoms_rank_reward_param"], i, three_kingdoms_rank_reward_param.experiment_order_begin)
			local maxRank = dms.int(dms["three_kingdoms_rank_reward_param"], i, three_kingdoms_rank_reward_param.experiment_order_end)
			if userRank > minRank and userRank < maxRank or userRank == minRank or userRank == maxRank then
				return i
			end
			index = i
		end
		return index
	end

	if _ED.three_kingdoms_score_rank.my_info.user_rank > 0 then
		Text_ranking_n:setString("" .. _ED.three_kingdoms_score_rank.my_info.user_rank)
		local userRank = tonumber(_ED.three_kingdoms_score_rank.my_info.user_rank)
		local m_index = getSectionIndex(userRank)
		--区间
		local max = dms.int(dms["three_kingdoms_rank_reward_param"], m_index, three_kingdoms_rank_reward_param.experiment_order_begin)
		local main = dms.int(dms["three_kingdoms_rank_reward_param"], m_index, three_kingdoms_rank_reward_param.experiment_order_end)
		Text_ranking_tip:setString(string.format(_new_interface_text[42],zstring.tonumber(main),zstring.tonumber(max)))

		-- 奖励荣誉*
		local targetHonor = dms.string(dms["three_kingdoms_rank_reward_param"], m_index, three_kingdoms_rank_reward_param.experiment_reward)
		local rewardInfo = zstring.split(targetHonor, "|")
		for i,v in pairs(rewardInfo) do
			local datas = zstring.split(v, ",")
			local cell1 = ResourcesIconCell:createCell()
			cell1:init(tonumber(datas[1]), tonumber(datas[3]), tonumber(datas[2]),nil,nil,nil,true)
			ccui.Helper:seekWidgetByName(cell1.roots[1], "Panel_prop"):setSwallowTouches(false)
			ccui.Helper:seekWidgetByName(cell1.roots[1], "Label_l-order_level"):setString(tonumber(datas[3]))
			ListView_ranking_reward:addChild(cell1)
		end
		if userRank > 500 then
			Text_ranking_tip:setString(_new_interface_text[315])
			ListView_ranking_reward:setVisible(false)
		end
	else
		Text_ranking_n:setString("--")
		--暂时无排名
		Text_ranking_tip:setString(_new_interface_text[117])
	end
end

function SmTrialTowerRuleOneCell:onEnterTransitionFinish()
	
end

function SmTrialTowerRuleOneCell:onInit()
	local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_rule_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmTrialTowerRuleOneCell.__size == nil then
	 	local Panel_list_1 = ccui.Helper:seekWidgetByName(root, "Panel_list_1")
		local MySize = Panel_list_1:getContentSize()

	 	SmTrialTowerRuleOneCell.__size = MySize
	end
	local function responseCallback(response)
		if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
	    	response.node:initDraw()
	    end
	end
	protocol_command.order_get_info.param_list = "5".."\r\n"..(1).."\r\n"..(50)
	NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseCallback, false, nil)
	
end


function SmTrialTowerRuleOneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmTrialTowerRuleOneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/TrialTower/sm_trial_tower_rule_1.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function SmTrialTowerRuleOneCell:init()
	self:onInit()
	self:setContentSize(SmTrialTowerRuleOneCell.__size)
	return self
end

function SmTrialTowerRuleOneCell:createCell()
	local cell = SmTrialTowerRuleOneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function SmTrialTowerRuleOneCell:onExit()
	cacher.freeRef("campaign/TrialTower/sm_trial_tower_rule_1.csb", self.roots[1])
end
