-- ------------------------------------------------------------------------------------------------------------
--  极限挑战奖励cell
-- ------------------------------------------------------------------------------------------------------------
LimitDekaronaRewardCell = class("LimitDekaronaRewardCellClass", Window)
LimitDekaronaRewardCell.__size = nil

--创建cell
local limit_dekarona_reward_cell_create_terminal = {
    _name = "limit_dekarona_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LimitDekaronaRewardCell:new()
        local index = params[1]
        local info_data = params[2]
        local counts = params[3]
        cell:init(index, info_data,counts)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(limit_dekarona_reward_cell_create_terminal)
state_machine.init()

function LimitDekaronaRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    self._counts = 0
    local function init_limit_dekarona_reward_cell_terminal()

    end
    init_limit_dekarona_reward_cell_terminal()
end

function LimitDekaronaRewardCell:updateDraw()
    local root = self.roots[1]
    local Text_limit_dekarona_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_reward_rank")
    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    local Text_limit_dekarona_title = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_title")
    ListView_limit_dekarona_reward:removeAllItems()
    Text_limit_dekarona_reward_rank:setString("")
    Text_limit_dekarona_title:removeAllChildren(true)
    if self._index == 1 then
        local activation_title = activity_str_tip[66]
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)     
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[67].."：", "fonts/simhei.ttf",20)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[4][1],color_Type[4][2],color_Type[4][3]),255, activation_title, "fonts/simhei.ttf",20)
        _richText:pushBackElement(re2)  
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "("..activity_str_tip[68]..")", "fonts/simhei.ttf",20)
        _richText:pushBackElement(re3)
        _richText:setPosition(cc.p(Text_limit_dekarona_title:getContentSize().width/2,Text_limit_dekarona_title:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_limit_dekarona_title:getContentSize().width,20))
        -- Text_limit_dekarona_title:addChild(_richText)
    end
    if self._info_data.min_rank == self._info_data.max_rank then
        Text_limit_dekarona_reward_rank:setString(string.format(red_alert_time_str[130], self._info_data.min_rank))
    else
        Text_limit_dekarona_reward_rank:setString(string.format(red_alert_time_str[130], self._info_data.min_rank.."~"..self._info_data.max_rank))
    end

    if self._index == self._counts then
        Text_limit_dekarona_reward_rank:setString(string.format(red_alert_time_str[131], self._info_data.min_rank))
    end 

    local reward_info = zstring.split(self._info_data.rewards, "|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_id = tonumber(info[1])
        local prop_count = tonumber(info[3])
        local cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_id, 1, prop_count})
        ListView_limit_dekarona_reward:addChild(cell)
    end
    ListView_limit_dekarona_reward:requestRefreshView()
end

function LimitDekaronaRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.limit_dekarona_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LimitDekaronaRewardCell.__size == nil then
        LimitDekaronaRewardCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LimitDekaronaRewardCell:onEnterTransitionFinish()

end

function LimitDekaronaRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LimitDekaronaRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.limit_dekarona_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LimitDekaronaRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    local Text_limit_dekarona_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_reward_rank")
    local Text_limit_dekarona_title = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_title")
    if ListView_limit_dekarona_reward ~=nil then
        ListView_limit_dekarona_reward:removeAllItems()
        Text_limit_dekarona_reward_rank:setString("")
        Text_limit_dekarona_title:removeAllChildren(true)
    end
end

function LimitDekaronaRewardCell:init(index, info_data,counts)
    self._info_data = info_data
    self._index = index 
    self._counts = counts
    if index ~= nil and index <= 5 then
        self:onInit()
    end
    self:setContentSize(LimitDekaronaRewardCell.__size)
    return self
end

function LimitDekaronaRewardCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.limit_dekarona_reward_cell, self.roots[1])
end

