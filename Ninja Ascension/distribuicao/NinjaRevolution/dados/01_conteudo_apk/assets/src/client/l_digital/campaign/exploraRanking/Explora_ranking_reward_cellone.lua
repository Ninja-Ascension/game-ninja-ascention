--------------------------------------------------------------------------------------------------------------
--  说明：探索排行榜cell
--------------------------------------------------------------------------------------------------------------
Explora_ranking_reward_cellone = class("Explora_ranking_reward_celloneClass", Window)
Explora_ranking_reward_cellone.__size = nil

--创建cell
local Explora_ranking_reward_cellone_terminal = {
    _name = "Explora_ranking_reward_cellone_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = Explora_ranking_reward_cellone:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(Explora_ranking_reward_cellone_terminal)
state_machine.init()

function Explora_ranking_reward_cellone:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
end

function Explora_ranking_reward_cellone:updateDrawInfo()
    if not _ED.pokemonExplore_myranking then
        return
    end

    local Text_ranking_tip = ccui.Helper:seekWidgetByName(self.roots[1], "Text_ranking_tip") 
    if tonumber(_ED.pokemonExplore_myranking) ~= -1 then
        Text_ranking_tip:setString(string.format(tipStringInfo_pokemon_recharge_rank_tips[6],_ED.pokemonExplore_myranking))
    else
        Text_ranking_tip:setString(_new_interface_text[117])
        return
    end
   

    local ListView_ranking_reward = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_ranking_reward") 
       --列表
    ListView_ranking_reward:removeAllItems()
    local rewards = zstring.splits(dms.string(dms["role_explore_rank"], _ED.pokemonExplore_myranking, 4), "|",",")
    if not rewards then
        return
    end
    local activity_count = tonumber(#rewards)
    for i, reward in ipairs(rewards) do
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
    ListView_ranking_reward:addChild(cell)
    end

    ListView_ranking_reward:requestRefreshView()
   
end

function Explora_ranking_reward_cellone:onUpdate(dt)
    
end

function Explora_ranking_reward_cellone:onInit()
    local csbexploraone = csb.createNode("campaign/exploration/exploration_event_ranking_reward_cell_1.csb")
    local root = csbexploraone:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbexploraone)
   -- self.ListView_ranking_reward = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward") 
    
    if Explora_ranking_reward_cellone.__size == nil then
        Explora_ranking_reward_cellone.__size = ccui.Helper:seekWidgetByName(root, "root"):getContentSize()
    end
	self:updateDrawInfo()
end

function Explora_ranking_reward_cellone:onEnterTransitionFinish()
end

function Explora_ranking_reward_cellone:clearUIInfo( ... )
    local root = self.roots[1]
  
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "root") 
    if Panel_2 ~= nil then
        Panel_2:removeAllChildren(true)
        fwin:removeTouchEventListener(Panel_2)
    end
end

function Explora_ranking_reward_cellone:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function Explora_ranking_reward_cellone:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_event_ranking_reward_cell_1.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function Explora_ranking_reward_cellone:init(params)
	self:onInit()
    self:setContentSize(Explora_ranking_reward_cellone.__size)
    return self
end

function Explora_ranking_reward_cellone:onExit()
	self:clearUIInfo()
  --  cacher.freeRef("campaign/exploration/exploration_event_ranking_reward_cell_1.csb", self.roots[1])
end