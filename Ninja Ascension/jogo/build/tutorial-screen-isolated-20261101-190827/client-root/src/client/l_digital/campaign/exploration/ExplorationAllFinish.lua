-- ----------------------------------------------------------------------------------------------------
-- 说明：空岛探索一键探索主界面
-------------------------------------------------------------------------------------------------------
ExplorationAllFinish = class("ExplorationAllFinishClass", Window)

local exploration_all_finish_window_open_terminal = {
    _name = "exploration_all_finish_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if type(params) == "number" then
            if fwin:find("ExplorationAllFinishClass") == nil then
                fwin:open(ExplorationAllFinish:new():init(params), fwin._view)
            end
        elseif type(params) == "table" then
            if fwin:find("ExplorationAllFinishClass") == nil then
                fwin:open(ExplorationAllFinish:new():init(params), fwin._view)
            end
        else
            local function callback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    -- 刷新探索点和计时
                    state_machine.excute("exploration_window_onUpdateDraw", 0, "") 

                    if fwin:find("ExplorationAllFinishClass") == nil then
                        fwin:open(ExplorationAllFinish:new():init(params), fwin._view)
                    end
                end
            end

            local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
            local data = {}
            data.mapId = mapId
            data.type = 1
            local req = json.encode(data)
            protocol_command.pokemon_explore_search.param_list = req
            NetworkManager:register(protocol_command.pokemon_explore_search.code, nil, nil, nil, nil, callback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_all_finish_window_close_terminal = {
    _name = "exploration_all_finish_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationAllFinishClass") then
            fwin:close(fwin:find("ExplorationAllFinishClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_all_finish_window_open_terminal)
state_machine.add(exploration_all_finish_window_close_terminal)
state_machine.init()

function ExplorationAllFinish:ctor()
    self.super:ctor()
    self.roots = {}
    self.current_id = {}
    -- app.load("client.l_digital.campaign.fileIsland.ExplorationAllFinishRegularCell")
    -- app.load("client.l_digital.campaign.fileIsland.ExplorationAllFinishFreeBoxCell")
    -- app.load("client.l_digital.campaign.fileIsland.ExplorationAllFinishCostBoxCell")
    -- app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinisQuestionOneCell")
    -- app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinisQuestionTowCell")
    -- app.load("client.l_digital.campaign.fileIsland.ExplorationAllFinishPKOneCell")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishQuestionOneCell")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishRegularCell")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishPKOneCell")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCostBoxCell")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishFreeBoxCell")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchCell")
    
    local function init_exploration_all_finish_terminal()
        local exploration_window_all_finish_update_terminal = {
            _name = "exploration_window_all_finish_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params[1] == 0 then
                    NetworkManager:register(protocol_command.pokemon_explore_finish_search_result.code, nil, nil, nil, nil, callback, false, nil)
                    state_machine.excute("exploration_all_finish_window_close", 0, "")
                else
                    local req = json.encode({nextEventId = params[1]})
                    protocol_command.pokemon_explore_dispose_next_search_eventId.param_list = req
                    --前端自己存进行到哪一步
                    _ED.pokemonExplore.resultInfo.curRewardIndex = params[1]
                    NetworkManager:register(protocol_command.pokemon_explore_dispose_next_search_eventId.code, nil, nil, nil, nil, callback, false, nil)
                    instance:onUpdateDraw(params[1], params[2])
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_window_all_finish_update_terminal)
        state_machine.init()
    end
    
    init_exploration_all_finish_terminal()
end

function ExplorationAllFinish:init(params)
    if type(params) == "number" then
        self.id = params
    elseif type(params) == "table" then -- 答题（此时参数不是id）
        self.eventInfo = params
        self.id = self.eventInfo.eventId
    end
    
    return self
end

function ExplorationAllFinish:onUpdate(dt)

end

function ExplorationAllFinish:onUpdateDraw(id, index)
    local root = self.roots[1]
    local Panel_tab = ccui.Helper:seekWidgetByName(root, "Panel_tab")
    Panel_tab:removeAllChildren(true)

    if id == 0 then
        local cell = ExplorationAllFinishRegularCell:createCell()
        cell:init(self.ids)
        Panel_tab:addChild(cell)
    elseif id == 1 then
        --index 1 免费开启宝箱 2开启付费宝箱
        local cell = ExplorationAllFinishFreeBoxCell:createCell()
        if index == 2 then
            cell = ExplorationAllFinishCostBoxCell:createCell()
        end
        cell:init({id, self.ids, not self.id})
        Panel_tab:addChild(cell)
    elseif id == 4 then
        -- index 第几个题目
        if not self.id then
            local cell = ExplorationAllFinishQuestionOneCell:createCell()
            cell:init({id, self.ids, index, not self.id})
            Panel_tab:addChild(cell)
        else
            local cell = ExplorationAllFinishQuestionOneCell:createCell()
            cell:init({id, self.eventInfo, index, not self.id})
            Panel_tab:addChild(cell)
        end

        --趣味问答第二种类型
        -- local cell = FileIslandAllFinisQuestionTowCell:createCell()
        -- cell:init({id, isRview})
        -- Panel_tab:addChild(cell)
    elseif id == 5 then
        local cell = ExplorationAllFinishCatchCell:createCell()
        cell:init({id, self.ids, not self.id})
        Panel_tab:addChild(cell)
    elseif id == 6 then
        local cell = ExplorationAllFinishPKOneCell:createCell()
        cell:init({id, self.ids, not self.id})
        Panel_tab:addChild(cell)
    end
end

function ExplorationAllFinish:initData()
    self.ids = {}
    for k,v in pairs(_ED.pokemonEventIds) do
        if tonumber(k) ~= 2 and tonumber(k) ~= 3 then
            table.insert(self.ids, k)
        end
    end

    table.sort(self.ids, function (a, b)
        return tonumber(a) < tonumber(b)
    end)

    --趣味问答答案(退出问答界面重置为空))
    _ED.all_answer = {}

    --趣味问答是否是回顾
    _ED.isReview = false
end

function ExplorationAllFinish:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_event.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_rule"), nil, 
    {
        terminal_name = "exploration_all_finish_window_rule_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    local index = 1
    if self.id and self.id == 1 then
        index = 2
    end
    self:initData()
    self:onUpdateDraw(self.id or 0, index)
end

function ExplorationAllFinish:onExit()

end
