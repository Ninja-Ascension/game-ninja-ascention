----------------------------------------------------------------------------------------------------
-- 敌军来袭-伤害cell
-------------------------------------------------------------------------------------------------------
EnemyStrikeRewardCell = class("EnemyStrikeRewardCellClass", Window)
EnemyStrikeRewardCell.__size = nil

local enemy_strike_reward_create_cell_terminal = {
    _name = "enemy_strike_reward_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EnemyStrikeRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(enemy_strike_reward_create_cell_terminal)
state_machine.init()

function EnemyStrikeRewardCell:ctor()
    self.super:ctor()
	self.roots = {}

	self._index = 0
    self._ntype = 0	
end

function EnemyStrikeRewardCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_limit_dekarona_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_reward_rank")
    local Text_enemy_strike_num = ccui.Helper:seekWidgetByName(root, "Text_enemy_strike_num")
    local Text_enemy_strike_nplayer_name = ccui.Helper:seekWidgetByName(root, "Text_enemy_strike_nplayer_name")
    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    Text_limit_dekarona_reward_rank:setString("")
    Text_enemy_strike_num:setString("")
    Text_enemy_strike_nplayer_name:setString("")
    ListView_limit_dekarona_reward:removeAllItems()

    local rewards = nil
    if self._ntype == 1 then        -- BOSS击杀
        Text_limit_dekarona_reward_rank:setString(tipStringInfo_campaign_info[8])
        rewards = dms.string(dms["enemy_boss_config"], 10, enemy_boss_config.param)
        Text_enemy_strike_num:setString("")
        if _ED.user_enemy_strike_rank_info ~= nil then
            Text_enemy_strike_nplayer_name:setString(_ED.user_enemy_strike_rank_info.boss_kill_name)
        end
     elseif self._ntype == 2 then   -- 伤害排名
        local rank = dms.int(dms["enemy_boss_reward"], self._id, enemy_boss_reward.rank)
        Text_limit_dekarona_reward_rank:setString(string.format(red_alert_time_str[113], rank))
        rewards = dms.string(dms["enemy_boss_reward"], self._id, enemy_boss_reward.damage_rewards)
        if self._info_data ~= nil then
            if _ED.user_enemy_strike_boss_info.state == 0 then
                Text_enemy_strike_num:setString(string.format(tipStringInfo_campaign_info[9], exChangeNumToString(self._info_data.total_value)))
            else
                Text_enemy_strike_num:setString(string.format(tipStringInfo_campaign_info[9], exChangeNumToString(self._info_data.total_hurt)))
            end
            Text_enemy_strike_nplayer_name:setString(self._info_data.user_name)
        end
    elseif self._ntype == 3 then   -- 次数排名
        local rank = dms.int(dms["enemy_boss_reward"], self._id, enemy_boss_reward.rank)
        Text_limit_dekarona_reward_rank:setString(string.format(red_alert_time_str[113], rank))
        rewards = dms.string(dms["enemy_boss_reward"], self._id, enemy_boss_reward.times_rewards)
        if self._info_data ~= nil then
            if _ED.user_enemy_strike_boss_info.state == 0 then
                Text_enemy_strike_num:setString(string.format(tipStringInfo_campaign_info[10], exChangeNumToString(self._info_data.total_value)))
            else
                Text_enemy_strike_num:setString(string.format(tipStringInfo_campaign_info[10], exChangeNumToString(self._info_data.total_times)))
            end
            Text_enemy_strike_nplayer_name:setString(self._info_data.user_name)
        end
    elseif self._ntype == 4 then
        Text_limit_dekarona_reward_rank:setString(string.format(red_alert_time_str[301], self._info_data.times))
        rewards = self._info_data.rewards
    end

    local reward_info = zstring.split(rewards, "|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_id = tonumber(info[1])
        local prop_type = tonumber(info[2])
        local prop_count = tonumber(info[3])
        local cell = nil
        if prop_id == -1 then
            cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_type, 1, prop_count})
        else
            cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_id, 1, prop_count})
        end
        ListView_limit_dekarona_reward:addChild(cell)
    end
    ListView_limit_dekarona_reward:requestRefreshView()
end

function EnemyStrikeRewardCell:onEnterTransitionFinish()

end

function EnemyStrikeRewardCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.campaign.enemy_strike_reward_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if EnemyStrikeRewardCell.__size == nil then
		EnemyStrikeRewardCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function EnemyStrikeRewardCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.enemy_strike_reward_cell, root)
end

function EnemyStrikeRewardCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EnemyStrikeRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_limit_dekarona_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_reward_rank")
    local Text_enemy_strike_num = ccui.Helper:seekWidgetByName(root, "Text_enemy_strike_num")
    local Text_enemy_strike_nplayer_name = ccui.Helper:seekWidgetByName(root, "Text_enemy_strike_nplayer_name")
    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    if Text_limit_dekarona_reward_rank ~= nil then
        Text_limit_dekarona_reward_rank:setString("")
        Text_enemy_strike_num:setString("")
        Text_enemy_strike_nplayer_name:setString("")
        ListView_limit_dekarona_reward:removeAllItems()
    end
end

function EnemyStrikeRewardCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.enemy_strike_reward_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function EnemyStrikeRewardCell:init(params)
    self._index = params[1]
    self._ntype = params[2]
    self._id = params[3]
    self._info_data = params[4]
    if self._index <= 6 then
        self:onInit()
    end
	self:setContentSize(EnemyStrikeRewardCell.__size)
end

