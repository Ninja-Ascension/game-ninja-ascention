-- ----------------------------------------------------------------------------------------------------
-- 说明：试炼规则3
-------------------------------------------------------------------------------------------------------

SmTrialTowerRuleThreeCell = class("SmTrialTowerRuleThreeCellClass", Window)
SmTrialTowerRuleThreeCell.__size = nil
function SmTrialTowerRuleThreeCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize SmTrialTowerRuleThreeCell page state machine.
    local function init_sm_trial_tower_rule_three_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_sm_trial_tower_rule_three_cell_terminal()
end

function SmTrialTowerRuleThreeCell:initDraw()
	local root = self.roots[1]
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then 
		for i = 1,3 do 
			local Image_ranking = ccui.Helper:seekWidgetByName(root,"Image_ranking_"..i)
			if Image_ranking then 
				if tonumber(self.m_index) == i then 
					Image_ranking:setVisible(true)
				else
					Image_ranking:setVisible(false)
				end
			end
		end
	end

	local rankTxt = string.format(_new_interface_text[43],zstring.tonumber(tonumber(self.m_index)))
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then 
		rankTxt = self.m_index
	end
	local Text_ranking = ccui.Helper:seekWidgetByName(root,"Text_ranking")
	Text_ranking:setString(rankTxt)

	local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root,"ListView_ranking_reward_2")
	ListView_ranking_reward_2:removeAllItems()
	-- 奖励荣誉*
	local targetHonor = dms.string(dms["three_kingdoms_rank_reward_param"], self.m_index, three_kingdoms_rank_reward_param.experiment_reward)
	local rewardInfo = zstring.split(targetHonor, "|")
	for i,v in pairs(rewardInfo) do
		local datas = zstring.split(v, ",")
		-- local cell1 = ResourcesIconCell:createCell()
		-- cell1:init(tonumber(datas[1]), tonumber(datas[3]), tonumber(datas[2]),nil,nil,nil,true)
		-- ccui.Helper:seekWidgetByName(cell1.roots[1], "Panel_prop"):setSwallowTouches(false)
		-- ccui.Helper:seekWidgetByName(cell1.roots[1], "Label_l-order_level"):setString(tonumber(datas[3]))
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{datas[1],datas[2],datas[3]},false,true,false,true})
		ListView_ranking_reward_2:addChild(cell)
	end
end

function SmTrialTowerRuleThreeCell:onEnterTransitionFinish()
	
end

function SmTrialTowerRuleThreeCell:onInit()
	local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_rule_3.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmTrialTowerRuleThreeCell.__size == nil then
	 	local Panel_list_3 = ccui.Helper:seekWidgetByName(root, "Panel_list_3")
		local MySize = Panel_list_3:getContentSize()

	 	SmTrialTowerRuleThreeCell.__size = MySize
	end
	self:initDraw()
end

function SmTrialTowerRuleThreeCell:clearUIInfo( ... )
	local root = self.roots[1]
	local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root,"ListView_ranking_reward_2")
	if ListView_ranking_reward_2 ~= nil then
		ListView_ranking_reward_2:removeAllItems()
	end
end

function SmTrialTowerRuleThreeCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmTrialTowerRuleThreeCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("campaign/TrialTower/sm_trial_tower_rule_3.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function SmTrialTowerRuleThreeCell:init(index)
	self.m_index = index
	self:onInit()
	self:setContentSize(SmTrialTowerRuleThreeCell.__size)
	return self
end

function SmTrialTowerRuleThreeCell:createCell()
	local cell = SmTrialTowerRuleThreeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function SmTrialTowerRuleThreeCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("campaign/TrialTower/sm_trial_tower_rule_3.csb", self.roots[1])
end
