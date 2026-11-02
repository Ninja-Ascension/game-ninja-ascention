----------------------------------------------------------------------------------------------------
-- 守卫战奖励cell
-------------------------------------------------------------------------------------------------------
GuardBattleRankRewardCell = class("GuardBattleRankRewardCellClass", Window)
GuardBattleRankRewardCell.__size = nil

local guard_battle_rank_reward_cell_create_terminal = {
    _name = "guard_battle_rank_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = GuardBattleRankRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_rank_reward_cell_create_terminal)
state_machine.init()

function GuardBattleRankRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._ntype = 0 

    local function init_guard_battle_rank_reward_cell_terminal()

    end
    
    init_guard_battle_rank_reward_cell_terminal()
end

function GuardBattleRankRewardCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_hegemony_reward_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_reward_n")
    local ListView_hegemony_reward = ccui.Helper:seekWidgetByName(root, "ListView_hegemony_reward")
    local Text_hegemony_people_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_people_t")
    local Text_hegemony_fight_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_t")
    Text_hegemony_reward_n:setString("")
    ListView_hegemony_reward:removeAllItems()
    Text_hegemony_people_t:setVisible(false)
    Text_hegemony_fight_t:setVisible(false)

    local rewards = nil
    if self._ntype == 1 then        -- 胜利方全员奖励
        Text_hegemony_reward_n:setString(red_alert_time_str[165])
        rewards = dms.string(dms["guard_config"], 9, guard_config.param)
     elseif self._ntype == 2 then   -- 活跃奖励
        local win_count = dms.int(dms["guard_active_reward"], self._id, guard_active_reward.win_count)
        Text_hegemony_reward_n:setString(string.format(red_alert_time_str[166], win_count))
        rewards = dms.string(dms["guard_active_reward"], self._id, guard_active_reward.rewards)
    elseif self._ntype == 3 then    -- 军团奖励
        local rank = dms.int(dms["guard_union_reward"], self._id, guard_union_reward.rank)
        Text_hegemony_reward_n:setString(string.format(red_alert_time_str[167], rank))
        rewards = dms.string(dms["guard_union_reward"], self._id, guard_union_reward.rewards)
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
        ListView_hegemony_reward:addChild(cell)
    end
    ListView_hegemony_reward:requestRefreshView()
end

function GuardBattleRankRewardCell:onEnterTransitionFinish()

end

function GuardBattleRankRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_hegemony_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if GuardBattleRankRewardCell.__size == nil then
        GuardBattleRankRewardCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end


function GuardBattleRankRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function GuardBattleRankRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function GuardBattleRankRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_hegemony_reward = ccui.Helper:seekWidgetByName(root, "ListView_hegemony_reward")
    local Text_hegemony_reward_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_reward_n")
    local Text_hegemony_people_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_people_t")
    local Text_hegemony_fight_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_t")
    
    if ListView_hegemony_reward ~=nil then
        ListView_hegemony_reward:removeAllItems()
        Text_hegemony_reward_n:setString("")
        Text_hegemony_people_t:setVisible(true)
    Text_hegemony_fight_t:setVisible(true)
    end
end

function GuardBattleRankRewardCell:init(params)
    self._index = params[1]
    self._ntype = params[2]
    self._id = params[3]
    if self._index ~= nil and self._index <= 5 then
        self:onInit()
    end
    self:setContentSize(GuardBattleRankRewardCell.__size)
end

function GuardBattleRankRewardCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_reward_cell, root)
end

