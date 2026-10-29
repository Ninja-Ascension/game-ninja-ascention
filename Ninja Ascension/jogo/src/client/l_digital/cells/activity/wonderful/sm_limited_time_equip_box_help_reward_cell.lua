--------------------------------------------------------------------------------------------------------------
--  说明：限时宝箱规则奖励cell
--------------------------------------------------------------------------------------------------------------
SmLimitedTimeEquipBoxHelpRewardCell = class("SmLimitedTimeEquipBoxHelpRewardCellClass", Window)
SmLimitedTimeEquipBoxHelpRewardCell.__size = nil

--创建cell
local sm_limited_time_equip_box_help_reward_cell_create_terminal = {
    _name = "sm_limited_time_equip_box_help_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmLimitedTimeEquipBoxHelpRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_limited_time_equip_box_help_reward_cell_create_terminal)
state_machine.init()

function SmLimitedTimeEquipBoxHelpRewardCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._info = nil

	 -- Initialize sm_limited_time_equip_box_help_reward_cell state machine.
    local function init_sm_limited_time_equip_box_help_reward_cell_terminal()

    end 
    -- call func sm_limited_time_equip_box_help_reward_cell create state machine.
    init_sm_limited_time_equip_box_help_reward_cell_terminal()

end

function SmLimitedTimeEquipBoxHelpRewardCell:updateDraw()
    local root = self.roots[1]

    local reward_info = zstring.split(self._info, ":")

    -- 排名
    local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
    local rank_info = zstring.split(reward_info[2], "-")
    local min_rank = tonumber(rank_info[1])
    local max_rank = tonumber(rank_info[2])
    if min_rank == max_rank then
        Text_ranking:setString(""..min_rank)
    else
        Text_ranking:setString(""..min_rank.."-"..max_rank)
    end

    -- 奖励
    local rewards = zstring.split(reward_info[1], "|")
    local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
    ListView_ranking_reward_2:removeAllItems()

    for k, v in pairs(rewards) do
        local info = zstring.split(v, ",")
        local cell = ResourcesIconCell:createCell()

        if 13 == tonumber(info[1]) then
            local table = {}
            if info[4] ~= nil and tonumber(info[4]) ~= -1 then
                table.shipStar = tonumber(info[4])
            end
            cell:init(tonumber(info[1]), tonumber(info[3]), tonumber(info[2]),nil,nil,true,true,1,table)
        else
            cell:init(tonumber(info[1]), tonumber(info[3]), tonumber(info[2]),nil,nil,true,true,1)
        end
        ListView_ranking_reward_2:addChild(cell)
    end

    ListView_ranking_reward_2:requestRefreshView()
end


function SmLimitedTimeEquipBoxHelpRewardCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmLimitedTimeEquipBoxHelpRewardCell.__size == nil then
        SmLimitedTimeEquipBoxHelpRewardCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function SmLimitedTimeEquipBoxHelpRewardCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmLimitedTimeEquipBoxHelpRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
    local ListView_ranking_reward_2 = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
    if Text_ranking ~= nil then
        Text_ranking:setString("")
        ListView_ranking_reward_2:removeAllItems()
    end
end

function SmLimitedTimeEquipBoxHelpRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmLimitedTimeEquipBoxHelpRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmLimitedTimeEquipBoxHelpRewardCell:init(params)
    self._index = params[1]
    self._info = params[2]
	self:onInit()
    self:setContentSize(SmLimitedTimeEquipBoxHelpRewardCell.__size)
    return self
end

function SmLimitedTimeEquipBoxHelpRewardCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_help_list_2.csb", self.roots[1])
end