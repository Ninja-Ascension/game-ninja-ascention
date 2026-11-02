-- ----------------------------------------------------------------------------------------------------
-- 说明：王者之战规则2
-------------------------------------------------------------------------------------------------------

UnionFightingRuleTwoCell = class("UnionFightingRuleTwoCellClass", Window)
UnionFightingRuleTwoCell.__size = nil

--创建cell
local union_fighting_rule_two_cell_create_terminal = {
    _name = "union_fighting_rule_two_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = UnionFightingRuleTwoCell:new()
        cell:registerOnNodeEvent(cell)
        cell:init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_fighting_rule_two_cell_create_terminal)
state_machine.init()

function UnionFightingRuleTwoCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize UnionFightingRuleTwoCell page state machine.
    local function init_sm_battle_of_kings_rule_two_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_sm_battle_of_kings_rule_two_cell_terminal()
end

function UnionFightingRuleTwoCell:initDraw()
	local root = self.roots[1]

	local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root,"ListView_ranking_reward_2")
	if ListView_ranking_reward_2 ~= nil then
		ListView_ranking_reward_2:removeAllItems()
		local reworld = dms.atos(self._info, union_warfare_score_rank_reward.reward)
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
	local min = dms.atoi(self._info, union_warfare_score_rank_reward.min_rank)
	local max = dms.atoi(self._info, union_warfare_score_rank_reward.max_rank)
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

function UnionFightingRuleTwoCell:onEnterTransitionFinish()
	
end

function UnionFightingRuleTwoCell:onInit()
	local root = cacher.createUIRef(string.format(config_csb.union_fight.sm_legion_ghz_rule_cell, 2), "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if UnionFightingRuleTwoCell.__size == nil then
	 	local Panel_list_3 = ccui.Helper:seekWidgetByName(root, "Panel_list_3")
		local MySize = Panel_list_3:getContentSize()

	 	UnionFightingRuleTwoCell.__size = MySize
	end
	self:initDraw()
end

function UnionFightingRuleTwoCell:clearUIInfo( ... )
	local root = self.roots[1]
	local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root,"ListView_ranking_reward_2")
	if ListView_ranking_reward_2 ~= nil then
		ListView_ranking_reward_2:removeAllItems()
	end
end

function UnionFightingRuleTwoCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionFightingRuleTwoCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_rule_cell, 2), root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function UnionFightingRuleTwoCell:init(params)
	self.m_index = params[1]
	self._info = params[2]
	self:onInit()
	self:setContentSize(UnionFightingRuleTwoCell.__size)
	return self
end


function UnionFightingRuleTwoCell:onExit()
	self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_rule_cell, 2), self.roots[1])
end
