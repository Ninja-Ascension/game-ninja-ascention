-- ------------------------------------------------------------------------------------------------------------
--  阵营对决奖励cell
-- ------------------------------------------------------------------------------------------------------------
CampPkRewardCell = class("CampPkRewardCellClass", Window)
CampPkRewardCell.__size = nil

--创建cell
local camp_pk_reward_cell_create_terminal = {
    _name = "camp_pk_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CampPkRewardCell:new()
        local index = params[1]
        local info_data = params[2]
        local page = params[3]
        cell:init(index, info_data, page)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(camp_pk_reward_cell_create_terminal)
state_machine.init()

function CampPkRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    self._page = 0
    local function init_camp_pk_reward_cell_terminal()

    end
    init_camp_pk_reward_cell_terminal()
end

function CampPkRewardCell:updateDraw()
    local root = self.roots[1]
    local Text_limit_dekarona_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_reward_rank")
    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    ListView_limit_dekarona_reward:removeAllItems()
    Text_limit_dekarona_reward_rank:setString("")

    if self._page == 3 then
        Text_limit_dekarona_reward_rank:setString(red_alert_time_str[146])
    else
        if self._info_data.min_rank == self._info_data.max_rank then
            Text_limit_dekarona_reward_rank:setString(string.format(red_alert_time_str[130], self._info_data.min_rank))
        else
            Text_limit_dekarona_reward_rank:setString(string.format(red_alert_time_str[130], self._info_data.min_rank.."~"..self._info_data.max_rank))
        end
    end

    local reward_info = zstring.split(self._info_data.rewards, "|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_id = tonumber(info[1])
        local prop_type = tonumber(info[2])
        local prop_count = tonumber(info[3])
        if prop_type == 6 then
            
        elseif prop_type == 13 then

        else
            prop_id = resource_prop_id[prop_type]
        end
        local cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_id, 1, prop_count})
        ListView_limit_dekarona_reward:addChild(cell)
    end
    ListView_limit_dekarona_reward:requestRefreshView()
end

function CampPkRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.super_scholar_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CampPkRewardCell.__size == nil then
        CampPkRewardCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function CampPkRewardCell:onEnterTransitionFinish()

end

function CampPkRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CampPkRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.super_scholar_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function CampPkRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    local Text_limit_dekarona_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_reward_rank")
    
    if ListView_limit_dekarona_reward ~=nil then
        ListView_limit_dekarona_reward:removeAllItems()
        Text_limit_dekarona_reward_rank:setString("")
    end
end

function CampPkRewardCell:init(index, info_data,page)
    self._info_data = info_data
    self._index = index 
    self._page = page
    if index ~= nil and index <= 5 then
        self:onInit()
    end
    self:setContentSize(CampPkRewardCell.__size)
    return self
end

function CampPkRewardCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.super_scholar_reward_cell, self.roots[1])
end

