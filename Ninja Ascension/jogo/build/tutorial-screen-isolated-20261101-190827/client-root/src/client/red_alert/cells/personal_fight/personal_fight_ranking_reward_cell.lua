--------------------------------------
-- 个人居所积分段位奖励信息项
--------------------------------------
PersonalFightRankingRewardCell = class("PersonalFightRankingRewardCellClass", Window)
PersonalFightRankingRewardCell.__size = nil

local personal_fight_ranking_reward_cell_create_terminal = {
    _name = "personal_fight_ranking_reward_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PersonalFightRankingRewardCell:new()
        local rank_index = params[1]
        local rank_id = params[2]
        cell:init(rank_index, rank_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fight_ranking_reward_cell_create_terminal)
state_machine.init()

function PersonalFightRankingRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._rank_index = 0            -- 积分段位序号
    self._list_view = nil           -- 奖励道具列表

    local function init_personal_fight_ranking_cell_terminal()

    end

    init_personal_fight_ranking_cell_terminal()
end

function PersonalFightRankingRewardCell:init(rank_index, rank_id)
    self._rank_index = rank_index
    self._rank_id = rank_id

    if rank_index ~= nil and rank_index < 7 then
        self:onInit()
    end

    self:setContentSize(PersonalFightRankingRewardCell.__size)
end

function PersonalFightRankingRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.palyer_build.palyer_build_rank_rew_cell, "root")
    self:addChild(root)
    table.insert(self.roots, root)
    
    if PersonalFightRankingRewardCell.__size == nil then
        PersonalFightRankingRewardCell.__size = root:getContentSize()
    end

    self._list_view = ccui.Helper:seekWidgetByName(root,"ListView_rew_icon")

    self:updateDraw()
end

function PersonalFightRankingRewardCell:updateDraw()
    local root = self.roots[1]

    local Panel_rew_name = ccui.Helper:seekWidgetByName(root,"Panel_rew_name")          -- 段位名称图片
    local Text_rew_n = ccui.Helper:seekWidgetByName(root,"Text_rew_n")                  -- 需要的积分数

    Panel_rew_name:removeBackGroundImage()
    Text_rew_n:setString("")

    -- 从配置表读取
    local score = dms.int(dms["user_stronghold"], self._rank_id, user_stronghold.score)
    local reward_id = dms.int(dms["user_stronghold"], self._rank_id, user_stronghold.reward_id)
    local reward_info = dms.string(dms["scene_reward"], reward_id, scene_reward.reward_items)

    -- 显示段位图片
    local file_path = string.format("images/ui/play/player_build/integral_name_%d.png", self._rank_index)
    Panel_rew_name:setBackGroundImage(file_path)

    Text_rew_n:setString(score)

    -- 显示奖励的道具
    self._list_view:removeAllItems()
    local reward_list = zstring.split(reward_info, "|")
    for i, reward in pairs(reward_list) do
        local reward_tab = zstring.split(reward, ",")
        local data = {
            item_value = tonumber(reward_tab[3]),
            prop_type = tonumber(reward_tab[2]),
            prop_item = tonumber(reward_tab[1]),
        }
        local cell = nil
        if tonumber(data.prop_type) == 6 then    
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment)) > 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,touch_type,0,false,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,true})
            end  
        elseif tonumber(data.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,touch_type,0,false,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,true})
        end
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
end

function PersonalFightRankingRewardCell:onExit()
    if self.roots ~= nil and self.roots[1] ~= nil then
        self._list_view:removeAllItems()
    end
    cacher.freeRef(config_csb.cells.palyer_build.palyer_build_rank_rew_cell, self.roots[1])
end

function PersonalFightRankingRewardCell:onEnterTransitionFinish()

end

function PersonalFightRankingRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PersonalFightRankingRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self._list_view:removeAllItems()
    local Panel_rew_name = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_rew_name")
    Panel_rew_name:removeBackGroundImage()
    cacher.freeRef(config_csb.cells.palyer_build.palyer_build_rank_rew_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end