--------------------------------------------------------------------------------------------------------------
--  说明：探索排行榜 奖励cell
--------------------------------------------------------------------------------------------------------------
Explora_ranking_reward_cellthree = class("Explora_ranking_reward_cellthreeClass", Window)
Explora_ranking_reward_cellthree.__size = nil

--创建cell
local Explora_ranking_reward_cellthree_terminal = {
    _name = "Explora_ranking_reward_cellthree_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = Explora_ranking_reward_cellthree:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(Explora_ranking_reward_cellthree_terminal)
state_machine.init()

function Explora_ranking_reward_cellthree:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
end

function Explora_ranking_reward_cellthree:updateDrawInfo()
    if not _ED.pokemonExplore_myranking and not self.ListView_ranking_reward then
        return
    end
       --列表
    self.ListView_ranking_reward:removeAllItems()
    local Text_ranking = ccui.Helper:seekWidgetByName(self.roots[1], "Text_ranking") 
    Text_ranking:setString(self.ranking)
    local rewards = zstring.splits(dms.string(dms["role_explore_rank"], self.ranking, 4), "|", ",")
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
    self.ListView_ranking_reward:addChild(cell)
    end

    self.ListView_ranking_reward:requestRefreshView()
   
end

function Explora_ranking_reward_cellthree:onUpdate(dt)
    
end

function Explora_ranking_reward_cellthree:onInit()
    local csbexplorathree = csb.createNode("campaign/exploration/exploration_event_ranking_reward_cell_3.csb")
    local root = csbexplorathree:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbexplorathree)
    self.ListView_ranking_reward = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2") 
    
    if Explora_ranking_reward_cellthree.__size == nil then
        Explora_ranking_reward_cellthree.__size = ccui.Helper:seekWidgetByName(root, "root"):getContentSize()
    end
      
 --   self:clearUIInfo()
	self:updateDrawInfo()
end

function Explora_ranking_reward_cellthree:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function Explora_ranking_reward_cellthree:clearUIInfo( ... )
    local root = self.roots[1]
  
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "root") 
    if Panel_2 ~= nil then
        Panel_2:removeAllChildren(true)
        fwin:removeTouchEventListener(Panel_2)
    end
end

function Explora_ranking_reward_cellthree:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function Explora_ranking_reward_cellthree:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_event_ranking_reward_cell_3.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function Explora_ranking_reward_cellthree:init(params)
    self.ranking = params[1]
	self:onInit()
    self:setContentSize(Explora_ranking_reward_cellthree.__size)
    return self
end

function Explora_ranking_reward_cellthree:onExit()
	self:clearUIInfo()
  --  cacher.freeRef("campaign/exploration/exploration_event_ranking_reward_cell_3.csb", self.roots[1])
end