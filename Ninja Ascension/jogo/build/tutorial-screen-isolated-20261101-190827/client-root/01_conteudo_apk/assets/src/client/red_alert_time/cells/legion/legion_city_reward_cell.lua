----------------------------------------------------------------------------------------------------
-- 说明：军团占领城市奖励cell
-------------------------------------------------------------------------------------------------------
LegionCityRewardCell = class("LegionCityRewardCellClass", Window)
LegionCityRewardCell.__size = nil

local legion_city_reward_cell_create_terminal = {
    _name = "legion_city_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LegionCityRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_reward_cell_create_terminal)
state_machine.init()

function LegionCityRewardCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0

    local function init_legion_city_reward_cell_terminal()

    end
    init_legion_city_reward_cell_terminal()         
end

function LegionCityRewardCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_legion_city_reward_rank = ccui.Helper:seekWidgetByName(root,"Text_legion_city_reward_rank")
    local Panel_legion_city_rank = ccui.Helper:seekWidgetByName(root,"Panel_legion_city_rank")
    Panel_legion_city_rank:removeBackGroundImage()

    local reward_data = dms.element(dms["world_city_reward"], self._index)
    local reward_name = dms.atos(reward_data, world_city_reward.reward_name)
    local rewards = dms.atos(reward_data, world_city_reward.rewards)

    Text_legion_city_reward_rank:setString(reward_name)
    if self._index <= 3 then
        Panel_legion_city_rank:setBackGroundImage(string.format(config_res.images.ui.share.rank_icon, self._index))
    end

    local ListView_legion_city_reward = ccui.Helper:seekWidgetByName(root,"ListView_legion_city_reward")
    ListView_legion_city_reward:removeAllItems()

    local reward_info = zstring.split(rewards, "|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(info[1])
        prop_data.prop_type = tonumber(info[2])
        prop_data.item_value = tonumber(info[3])

        local cell = createPropIconCell(prop_data, true, true, true)
        ListView_legion_city_reward:addChild(cell)
    end
    ListView_legion_city_reward:requestRefreshView()
end

function LegionCityRewardCell:onEnterTransitionFinish()

end

function LegionCityRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_city_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LegionCityRewardCell.__size == nil then
        LegionCityRewardCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function LegionCityRewardCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_reward_cell, self.roots[1])
end

function LegionCityRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionCityRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCityRewardCell:clearUIInfo()
    local root = self.roots[1]
    local ListView_legion_city_reward = ccui.Helper:seekWidgetByName(root,"ListView_legion_city_reward")
    if ListView_legion_city_reward ~= nil then
        ListView_legion_city_reward:removeAllItems()
    end
end

function LegionCityRewardCell:init(params)
    self._index = params[1]

    if self._index <= 6 then
       self:onInit()
    end
    self:setContentSize(LegionCityRewardCell.__size)
end

