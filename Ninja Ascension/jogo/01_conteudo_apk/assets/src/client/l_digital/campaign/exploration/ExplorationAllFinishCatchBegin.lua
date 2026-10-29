-- ----------------------------------------------------------------------------------------------------
-- 说明：探索积分
-------------------------------------------------------------------------------------------------------
ExplorationAllFinishCatchBegin = class("ExplorationAllFinishCatchBeginClass", Window)

local exploration_all_finish_catch_begin_window_open_terminal = {
    _name = "exploration_all_finish_catch_begin_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExplorationAllFinishCatchBeginClass") == nil then
            fwin:open(ExplorationAllFinishCatchBegin:new():init(params), fwin._view)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_all_finish_catch_begin_window_close_terminal = {
    _name = "exploration_all_finish_catch_begin_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationAllFinishCatchBeginClass") then
            fwin:close(fwin:find("ExplorationAllFinishCatchBeginClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_all_finish_catch_begin_window_open_terminal)
state_machine.add(exploration_all_finish_catch_begin_window_close_terminal)
state_machine.init()

function ExplorationAllFinishCatchBegin:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchWindow")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchCell")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchRule")


    local function init_exploration_all_finish_catch_begin_terminal()
        local exploration_all_finish_catch_begin_type_terminal = {
            _name = "exploration_all_finish_catch_begin",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("exploration_all_finish_catch_window_open", 0, instance.infos.index)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_all_finish_catch_begin_update_terminal = {
            _name = "exploration_all_finish_catch_begin_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local infos =  _ED.pokemonExplore.resultInfo.resultArray[instance.infos.index]
                instance.infos = infos
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_all_finish_catch_begin_buy_terminal = {
            _name = "exploration_all_finish_catch_begin_buy",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                function showConfirmTip(instance,n)
                    if n == 0 then
                        local function callback( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local infos =  _ED.pokemonExplore.resultInfo.resultArray[instance.infos.index]
                                instance.infos = infos
                                instance:onUpdateDraw()
                            end
                        end
                        local req = json.encode({resultIndex = instance.infos.index, buyCount = 1})
                        protocol_command.pokemon_explore_map_catch_buy.param_list = req
                        NetworkManager:register(protocol_command.pokemon_explore_map_catch_buy.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end

                local needCost = 0
                local costs = zstring.split(dms.string(dms["play_config"], 141, play_config.param), ",")

                if costs[tonumber(instance.infos.buyTimes) + 1] then
                    needCost = costs[tonumber(self.infos.buyTimes) + 1]
                else
                    needCost = costs[#costs]
                end

                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, showConfirmTip,string.format(tipStringInfo_exploration_tips[6], tonumber(needCost)))
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_all_finish_catch_begin_cancel_terminal = {
            _name = "exploration_all_finish_catch_begin_cancel",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                function showConfirmTip(instance,n)
                    if n == 0 then
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if instance._type == 2 then
                                    state_machine.excute("exploration_all_finish_catch_cell_update", 0, "")
                                end
                                state_machine.excute("exploration_all_finish_catch_begin_window_close", 0, "")
                            end
                        end
                        protocol_command.pokemon_explore_map_catch_cancel.param_list =json.encode({{resultIndex = instance.infos.index}}) 
                        NetworkManager:register(protocol_command.pokemon_explore_map_catch_cancel.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end

                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, showConfirmTip, tipStringInfo_exploration_tips[5])
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_all_finish_catch_begin_type_terminal)
        state_machine.add(exploration_all_finish_catch_begin_update_terminal)
        state_machine.add(exploration_all_finish_catch_begin_buy_terminal)
        state_machine.add(exploration_all_finish_catch_begin_cancel_terminal)
        state_machine.init()
    end
    
    init_exploration_all_finish_catch_begin_terminal()
end

function ExplorationAllFinishCatchBegin:init(params)
    self.infos = params[1]
    self._type = params[2]
    return self
end

function ExplorationAllFinishCatchBegin:onUpdate(dt)

end

function ExplorationAllFinishCatchBegin:onUpdateDraw()
    local root = self.roots[1]
    local Text_explore_catch_n = ccui.Helper:seekWidgetByName(root, "Text_explore_catch_n")

    local Panel_catch_begin = ccui.Helper:seekWidgetByName(root, "Panel_catch_begin")
    local Text_explore_p_0 = ccui.Helper:seekWidgetByName(root, "Text_explore_p_0")

    local Panel_catch_buy = ccui.Helper:seekWidgetByName(root, "Panel_catch_buy")
    local Text_explore_gem_n = ccui.Helper:seekWidgetByName(root, "Text_explore_gem_n")
    local Text_explore_p_buy_0 = ccui.Helper:seekWidgetByName(root, "Text_explore_p_buy_0")

    Text_explore_catch_n:setString("×" .. self.infos.ballCount)
    Text_explore_p_0:setString(self.infos.hasTimes)

    local maxTimes = dms.int(dms["play_config"], 140, play_config.param)
    local costs = zstring.split(dms.string(dms["play_config"], 141, play_config.param), ",")
    
    Text_explore_p_buy_0:setString(self.infos.buyTimes .. "/" .. maxTimes)

    if costs[tonumber(self.infos.buyTimes) + 1] then
        Text_explore_gem_n:setString(costs[tonumber(self.infos.buyTimes) + 1])
    else
        Text_explore_gem_n:setString(costs[#costs])
    end
    Panel_catch_begin:setVisible(tonumber(self.infos.hasTimes) > 0)
    Panel_catch_buy:setVisible(tonumber(self.infos.hasTimes) <= 0)
end

function ExplorationAllFinishCatchBegin:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_catch_begin.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "exploration_all_finish_catch_begin_cancel", 
        isPressedActionEnabled = true
    },
    nil, 0)

     -- 开始
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_catch_begin"), nil, 
     {
         terminal_name = "exploration_all_finish_catch_begin", 
         isPressedActionEnabled = true,
     },
     nil, 0)

     -- 购买
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_catch_buy"), nil, 
     {
         terminal_name = "exploration_all_finish_catch_begin_buy", 
         isPressedActionEnabled = true,
     },
     nil, 0)

     -- 规则
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_catch_infor"), nil, 
     {
         terminal_name = "exploration_all_finish_catch_rule_window_open", 
         isPressedActionEnabled = true,
     },
     nil, 0)

    self:onUpdateDraw()
end

function ExplorationAllFinishCatchBegin:onExit()

end
