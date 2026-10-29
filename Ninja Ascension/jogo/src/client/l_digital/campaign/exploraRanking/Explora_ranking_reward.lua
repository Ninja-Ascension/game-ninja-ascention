-- ----------------------------------------------------------------------------------------------------
-- 说明：探索排行榜奖励
-------------------------------------------------------------------------------------------------------
explora_ranking_reward = class("explora_ranking_rewardClass", Window)

local explora_ranking_reward_open_terminal = {
    _name = "explora_ranking_reward_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("explora_ranking_rewardClass") == nil then
            fwin:open(explora_ranking_reward:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local explora_ranking_reward_close_terminal = {
    _name = "explora_ranking_reward_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("explora_ranking_rewardClass") then
            fwin:close(fwin:find("explora_ranking_rewardClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(explora_ranking_reward_open_terminal)
state_machine.add(explora_ranking_reward_close_terminal)
state_machine.init()

function explora_ranking_reward:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.l_digital.campaign.exploraRanking.Explora_ranking_reward_cellone")
    app.load("client.l_digital.campaign.exploraRanking.Explora_ranking_reward_celltwo")
    app.load("client.l_digital.campaign.exploraRanking.Explora_ranking_reward_cellthree")
end

function explora_ranking_reward:init(params)
    return self
end

function explora_ranking_reward:onUpdate(dt)
end

function explora_ranking_reward:onUpdateDraw()
    if not _ED.pokemonExplore_rank_info and not self.ListView_rule then
        return
    end 
    self.ListView_rule:removeAllItems()
    local cell = state_machine.excute("Explora_ranking_reward_cellone_create",0,nil)
    self.ListView_rule:addChild(cell)
    
    local cell = state_machine.excute("Explora_ranking_reward_celltwo_create",0,nil)
    self.ListView_rule:addChild(cell)
    
    for i = 1, 10 do 
        local cell = state_machine.excute("Explora_ranking_reward_cellthree_create",0,{i})
        self.ListView_rule :addChild(cell)
    end
   self.ListView_rule:refreshView()
end


function explora_ranking_reward:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_event_ranking_reward.csb")
	local root = csbNode:getChildByName("root")
    self.ListView_rule = ccui.Helper:seekWidgetByName(root, "ListView_rule")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "explora_ranking_reward_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function explora_ranking_reward:onExit()
    self.ListView_rule:removeAllItems()
end
