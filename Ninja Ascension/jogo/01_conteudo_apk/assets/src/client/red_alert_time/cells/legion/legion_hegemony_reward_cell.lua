-- ------------------------------------------------------------------------------------------------------------
--  军团争霸奖励cell
-- ------------------------------------------------------------------------------------------------------------
LegionHegemonyRewardCell = class("LegionHegemonyRewardCellClass", Window)
LegionHegemonyRewardCell.__size = nil

--创建cell
local legion_hegemony_reward_cell_create_terminal = {
    _name = "legion_hegemony_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionHegemonyRewardCell:new()
        local index = params[1]
        local reward_type = params[2]
        local reward_id = params[3]
        cell:init(index, reward_type, reward_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_hegemony_reward_cell_create_terminal)
state_machine.init()

function LegionHegemonyRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_legion_hegemony_reward_cell_terminal()

    end
    
    init_legion_hegemony_reward_cell_terminal()
end


function LegionHegemonyRewardCell:updateDraw()
    local root = self.roots[1]
    local ListView_hegemony_reward = ccui.Helper:seekWidgetByName(root, "ListView_hegemony_reward")
    local Text_hegemony_reward_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_reward_n")
    local Text_hegemony_people_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_people_t")
    local Text_hegemony_people_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_people_n")
    local Text_hegemony_fight_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_t")
    local Text_hegemony_fight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_n")
    ListView_hegemony_reward:removeAllItems()
    Text_hegemony_reward_n:setString("")
    Text_hegemony_reward_n:removeAllChildren(true)
    Text_hegemony_people_t:setVisible(false)
    Text_hegemony_people_n:setString("")
    Text_hegemony_fight_t:setVisible(false)
    Text_hegemony_fight_n:setString("")

    local rewards = ""
    if self._reward_type == 1 then      -- 第一名额外奖励
        Text_hegemony_reward_n:setString(red_alert_time_str[145])
        rewards = dms.string(dms["union_fight_config"], 9, union_fight_config.param)
    elseif self._reward_type == 2 then  -- 连胜奖励
        local rank = dms.int(dms["union_fight_reward"], self._reward_id, union_fight_reward.rank)
        rewards = dms.string(dms["union_fight_reward"], self._reward_id, union_fight_reward.vector_rewards)

        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[142], "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, ""..rank, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[143], "fonts/simhei.ttf",18)
        _richText:pushBackElement(re3)
        _richText:setPosition(cc.p(Text_hegemony_reward_n:getContentSize().width/2,Text_hegemony_reward_n:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_hegemony_reward_n:getContentSize().width,18))
        Text_hegemony_reward_n:addChild(_richText)
    elseif self._reward_type == 3 then  -- 军团奖励
        local rank = dms.int(dms["union_fight_reward"], self._reward_id, union_fight_reward.rank)
        rewards = dms.string(dms["union_fight_reward"], self._reward_id, union_fight_reward.legion_rewards)

        Text_hegemony_people_t:setVisible(true)
        Text_hegemony_fight_t:setVisible(true)
        local info_data = nil
        if _ED.union.union_union_hegemony_rank_list ~= nil and _ED.union.union_union_hegemony_rank_list["1"] ~= nil then
            info_data = _ED.union.union_union_hegemony_rank_list["1"][rank]
        end

        local legion_name = ""
        if info_data == nil then
            legion_name = ""
            Text_hegemony_people_n:setString("0")
            Text_hegemony_fight_n:setString("0")
        else
            legion_name = info_data.name
            Text_hegemony_people_n:setString(info_data.number)
            Text_hegemony_fight_n:setString(exChangeNumToString(info_data.fight_number))
        end
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(red_alert_time_str[144], rank), "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, legion_name, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_hegemony_reward_n:getContentSize().width/2,Text_hegemony_reward_n:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_hegemony_reward_n:getContentSize().width,18))
        Text_hegemony_reward_n:addChild(_richText)
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

function LegionHegemonyRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_hegemony_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionHegemonyRewardCell.__size == nil then
        LegionHegemonyRewardCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionHegemonyRewardCell:onEnterTransitionFinish()

end

function LegionHegemonyRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionHegemonyRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionHegemonyRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_hegemony_reward = ccui.Helper:seekWidgetByName(root, "ListView_hegemony_reward")
    local Text_hegemony_reward_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_reward_n")
    local Text_hegemony_people_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_people_t")
    local Text_hegemony_people_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_people_n")
    local Text_hegemony_fight_t = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_t")
    local Text_hegemony_fight_n = ccui.Helper:seekWidgetByName(root, "Text_hegemony_fight_n")

    if ListView_hegemony_reward ~= nil then
        ListView_hegemony_reward:removeAllItems()
        Text_hegemony_reward_n:setString("")
        Text_hegemony_reward_n:removeAllChildren(true)
        Text_hegemony_people_t:setVisible(true)
        Text_hegemony_people_n:setString("")
        Text_hegemony_fight_t:setVisible(true)
        Text_hegemony_fight_n:setString("")
    end

end

function LegionHegemonyRewardCell:init(index, reward_type, reward_id)
    self._index = index 
    self._reward_type = reward_type
    self._reward_id = reward_id
    if index ~= nil and index <= 5 then
        self:onInit()
    end
    self:setContentSize(LegionHegemonyRewardCell.__size)
    return self
end

function LegionHegemonyRewardCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_hegemony_reward_cell, self.roots[1])
end

