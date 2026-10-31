-- ----------------------------------------------------------------------------------------------------
-- 说明：空岛探索一键探索主界面
-------------------------------------------------------------------------------------------------------
FileIslandAllFinish = class("FileIslandAllFinishClass", Window)

local fileIsland_all_finish_window_open_terminal = {
    _name = "fileIsland_all_finish_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if type(params) == "number" then
            if fwin:find("FileIslandAllFinishClass") == nil then
                fwin:open(FileIslandAllFinish:new():init(params), fwin._view)
            end
        else
            local function callback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    -- 刷新探索点和计时
                    state_machine.excute("fileIsland_window_onUpdateDraw", 0, "") 

                    if fwin:find("FileIslandAllFinishClass") == nil then
                        fwin:open(FileIslandAllFinish:new():init(params), fwin._view)
                    end
                end
            end

            local data = {}
            data.type = 1
            local req = json.encode(data)
            protocol_command.fileIslandSearch.param_list = req
            NetworkManager:register(protocol_command.fileIslandSearch.code, nil, nil, nil, nil, callback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local fileIsland_all_finish_window_close_terminal = {
    _name = "fileIsland_all_finish_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("FileIslandAllFinishClass") then
            fwin:close(fwin:find("FileIslandAllFinishClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_all_finish_window_open_terminal)
state_machine.add(fileIsland_all_finish_window_close_terminal)
state_machine.init()

function FileIslandAllFinish:ctor()
    self.super:ctor()
    self.roots = {}
    self.current_id = {}
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishRegularCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishFreeBoxCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishCostBoxCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinisQuestionOneCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinisQuestionTowCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishPKOneCell")
    
    
    local function init_fileIsland_all_finish_terminal()
        local fileIsland_window_all_finish_update_terminal = {
            _name = "fileIsland_window_all_finish_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params[1] == 0 then
                    NetworkManager:register(protocol_command.file_island_finish_search_result.code, nil, nil, nil, nil, callback, false, nil)
                    state_machine.excute("fileIsland_all_finish_window_close", 0, "")
                else
                    local req = json.encode({nextEventId = params[1]})
                    protocol_command.file_island_dispose_next_search_eventId.param_list = req
                    --前端自己存进行到哪一步
                    _ED.fileIsland.resultInfo.curRewardIndex = params[1]
                    NetworkManager:register(protocol_command.file_island_dispose_next_search_eventId.code, nil, nil, nil, nil, callback, false, nil)
                    instance:onUpdateDraw(params[1], params[2])
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_window_all_finish_update_terminal)
        state_machine.init()
    end
    
    init_fileIsland_all_finish_terminal()
end

function FileIslandAllFinish:init(params)
    if type(params) == "number" then
        self.id = params
    end
    
    return self
end

function FileIslandAllFinish:onUpdate(dt)

end

function FileIslandAllFinish:onUpdateDraw(id, index)
    local root = self.roots[1]
    local Panel_tab = ccui.Helper:seekWidgetByName(root, "Panel_tab")
    Panel_tab:removeAllChildren(true)

    if id == 0 then
        local cell = FileIslandAllFinishRegularCell:createCell()
        cell:init(self.ids)
        Panel_tab:addChild(cell)
    elseif id == 3 then
        --index 1 免费开启宝箱 2开启付费宝箱
        local cell = FileIslandAllFinishFreeBoxCell:createCell()
        if index == 2 then
            cell = FileIslandAllFinishCostBoxCell:createCell()
        end
        cell:init({id, self.ids, not self.id})
        Panel_tab:addChild(cell)
    elseif id == 4 then
        -- index 第几个题目
        local cell = FileIslandAllFinisQuestionOneCell:createCell()
        cell:init({id, self.ids, index, not self.id})
        Panel_tab:addChild(cell)

        --趣味问答第二种类型
        -- local cell = FileIslandAllFinisQuestionTowCell:createCell()
        -- cell:init({id, isRview})
        -- Panel_tab:addChild(cell)
    elseif id == 5 then
        local cell = FileIslandAllFinishPKOneCell:createCell()
        cell:init({id, self.ids, not self.id})
        Panel_tab:addChild(cell)
    end
end

function FileIslandAllFinish:initData()
    self.ids = {}
    for k,v in pairs(_ED.eventIds) do
        if tonumber(k) > 2 and tonumber(k) < 6 then
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

function FileIslandAllFinish:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/explore/explore_all_finish.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_rule"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_rule_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    local index = 1
    if self.id and self.id == 3 then
        index = 2
    end
    self:initData()
    self:onUpdateDraw(self.id or 0, index)
end

function FileIslandAllFinish:onExit()

end
