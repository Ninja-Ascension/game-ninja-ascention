-- ----------------------------------------------------------------------------------------------------
-- 说明：王者之战规则2
-------------------------------------------------------------------------------------------------------

SmCrossServerBattleOfKingsRuleTwoCell = class("SmCrossServerBattleOfKingsRuleTwoCellClass", Window)
SmCrossServerBattleOfKingsRuleTwoCell.__size = nil
function SmCrossServerBattleOfKingsRuleTwoCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize SmCrossServerBattleOfKingsRuleTwoCell page state machine.
    local function init_sm_cross_server_battle_of_kings_rule_two_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_sm_cross_server_battle_of_kings_rule_two_cell_terminal()
end

function SmCrossServerBattleOfKingsRuleTwoCell:initDraw()
	local root = self.roots[1]

	local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root,"ListView_ranking_reward_2")
	if ListView_ranking_reward_2 ~= nil then
		ListView_ranking_reward_2:removeAllItems()
		local reworld = dms.string(dms["cross_the_kings_battle_score_rank_reward"], self.m_index, the_kings_battle_score_rank_reward.reworld)
		local reworld_info = zstring.split(reworld,"|")
		for i,v in pairs(reworld_info) do
			local datas = zstring.split(v,",")
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(datas[1], tonumber(datas[3]), datas[2],nil,nil,true,true)
   --  		ListView_ranking_reward_2:addChild(cell)
	    	local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{datas[1],datas[2],datas[3]},false,true,false,true})
	    	ListView_ranking_reward_2:addChild(cell)
		end
		ListView_ranking_reward_2:requestRefreshView()
	end
	local Text_ranking = ccui.Helper:seekWidgetByName(root,"Text_ranking")
	local min = tonumber(dms.string(dms["cross_the_kings_battle_score_rank_reward"], self.m_index, the_kings_battle_score_rank_reward.min_rank))
	local max = tonumber(dms.string(dms["cross_the_kings_battle_score_rank_reward"], self.m_index, the_kings_battle_score_rank_reward.max_rank))
	if max > -1 then
		if max ~= min then
			Text_ranking:setString(string.format(_new_interface_text[157],zstring.tonumber(min),zstring.tonumber(max)))
		else
			Text_ranking:setString(string.format(_new_interface_text[43],zstring.tonumber(min)))
		end
	else
		Text_ranking:setString(string.format(_new_interface_text[71],zstring.tonumber(min)))
	end
end

function SmCrossServerBattleOfKingsRuleTwoCell:onEnterTransitionFinish()
	
end

function SmCrossServerBattleOfKingsRuleTwoCell:onInit()
	local root = cacher.createUIRef("campaign/BattleofKingsX/battle_of_kings_x_rule_list_2.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmCrossServerBattleOfKingsRuleTwoCell.__size == nil then
	 	local Panel_list_3 = ccui.Helper:seekWidgetByName(root, "Panel_list_3")
		local MySize = Panel_list_3:getContentSize()

	 	SmCrossServerBattleOfKingsRuleTwoCell.__size = MySize
	end
	self:initDraw()
end

function SmCrossServerBattleOfKingsRuleTwoCell:clearUIInfo( ... )
	local root = self.roots[1]
	local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root,"ListView_ranking_reward_2")
	if ListView_ranking_reward_2 ~= nil then
		ListView_ranking_reward_2:removeAllItems()
	end
end

function SmCrossServerBattleOfKingsRuleTwoCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmCrossServerBattleOfKingsRuleTwoCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("campaign/BattleofKings/battle_of_kings_rule_list_2.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function SmCrossServerBattleOfKingsRuleTwoCell:init(index)
	self.m_index = index
	self:onInit()
	self:setContentSize(SmCrossServerBattleOfKingsRuleTwoCell.__size)
	return self
end

function SmCrossServerBattleOfKingsRuleTwoCell:createCell()
	local cell = SmCrossServerBattleOfKingsRuleTwoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function SmCrossServerBattleOfKingsRuleTwoCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("campaign/BattleofKings/battle_of_kings_rule_list_2.csb", self.roots[1])
end
