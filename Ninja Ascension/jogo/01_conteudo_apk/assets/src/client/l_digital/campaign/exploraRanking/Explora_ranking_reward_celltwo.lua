--------------------------------------------------------------------------------------------------------------
--  说明：探索排行榜 规则cell
--------------------------------------------------------------------------------------------------------------
Explora_ranking_reward_celltwo = class("Explora_ranking_reward_celltwoClass", Window)
Explora_ranking_reward_celltwo.__size = nil

--创建cell
local Explora_ranking_reward_celltwo_terminal = {
    _name = "Explora_ranking_reward_celltwo_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = Explora_ranking_reward_celltwo:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(Explora_ranking_reward_celltwo_terminal)
state_machine.init()

function Explora_ranking_reward_celltwo:ctor()
	self.super:ctor()
	self.roots = {}
end

function Explora_ranking_reward_celltwo:updateDrawInfo()
    if not _ED.pokemonExplore_myranking then
        return
    end
end

function Explora_ranking_reward_celltwo:onUpdate(dt)
    
end

function Explora_ranking_reward_celltwo:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_event_ranking_reward_cell_2.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if Explora_ranking_reward_celltwo.__size == nil then
        Explora_ranking_reward_celltwo.__size = ccui.Helper:seekWidgetByName(root, "root"):getContentSize()
    end
      
    -- self:clearUIInfo()
	self:updateDrawInfo()
end

function Explora_ranking_reward_celltwo:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function Explora_ranking_reward_celltwo:clearUIInfo( ... )
    local root = self.roots[1]
  
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "root") 
    if Panel_2 ~= nil then
        Panel_2:removeAllChildren(true)
        fwin:removeTouchEventListener(Panel_2)
    end
end

function Explora_ranking_reward_celltwo:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function Explora_ranking_reward_celltwo:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_event_ranking_reward_cell_2.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function Explora_ranking_reward_celltwo:init(params)
	self:onInit()
    self:setContentSize(Explora_ranking_reward_celltwo.__size)
    return self
end

function Explora_ranking_reward_celltwo:onExit()
	self:clearUIInfo()
  --  cacher.freeRef("campaign/exploration/exploration_event_ranking_reward_cell_2.csb", self.roots[1])
end