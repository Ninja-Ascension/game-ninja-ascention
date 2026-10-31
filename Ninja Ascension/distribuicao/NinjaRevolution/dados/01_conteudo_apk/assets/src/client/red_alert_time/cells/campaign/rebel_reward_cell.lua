----------------------------------------------------------------------------------------------------
-- 敌军来袭-伤害cell
-------------------------------------------------------------------------------------------------------
RebelRewardCell = class("RebelRewardCellClass", Window)
RebelRewardCell.__size = nil

local rebel_reward_create_cell_terminal = {
    _name = "rebel_reward_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = RebelRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_reward_create_cell_terminal)
state_machine.init()

function RebelRewardCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info_data = nil
end

function RebelRewardCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_rebel_reward_reward_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_reward_reward_n")
    local ListView_rebel_reward = ccui.Helper:seekWidgetByName(root, "ListView_rebel_reward")
    ListView_rebel_reward:removeAllItems()
    Text_rebel_reward_reward_n:setString("")

    if self._info_data.min_rank == self._info_data.max_rank then
        Text_rebel_reward_reward_n:setString(string.format(red_alert_time_str[113], self._info_data.min_rank))
    else
        Text_rebel_reward_reward_n:setString(string.format(red_alert_time_str[113], self._info_data.min_rank.."~"..self._info_data.max_rank))
    end

    local reward_info = zstring.split(self._info_data.rewards, "|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_id = tonumber(info[1])
        local prop_count = tonumber(info[3])
        local cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_id, 1, prop_count})
        ListView_rebel_reward:addChild(cell)
    end
    ListView_rebel_reward:requestRefreshView()
end

function RebelRewardCell:onEnterTransitionFinish()

end

function RebelRewardCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.campaign.rebel_reward_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if RebelRewardCell.__size == nil then
		RebelRewardCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RebelRewardCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.rebel_reward_cell, root)
end

function RebelRewardCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RebelRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_rebel_reward_reward_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_reward_reward_n")
    local ListView_rebel_reward = ccui.Helper:seekWidgetByName(root, "ListView_rebel_reward")
    if Text_rebel_reward_reward_n ~= nil then
        Text_rebel_reward_reward_n:setString("")
        ListView_rebel_reward:removeAllItems()
    end
end

function RebelRewardCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.rebel_reward_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function RebelRewardCell:init(params)
    self._index = params[1]
    self._info_data = params[2]
    if self._index <= 5 then
        self:onInit()
    end
	self:setContentSize(RebelRewardCell.__size)
end

