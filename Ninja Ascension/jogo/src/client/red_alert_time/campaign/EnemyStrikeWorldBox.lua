-----------------------------
--敌军来袭
-----------------------------
EnemyStrikeWorldBox = class("EnemyStrikeWorldBoxClass", Window)

local enemy_strike_world_box_open_terminal = {
    _name = "enemy_strike_world_box_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(220) == true then
            return
        end
        state_machine.lock("enemy_strike_world_box_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("enemy_strike_world_box_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("EnemyStrikeWorldBoxClass") == nil then
                    fwin:open(EnemyStrikeWorldBox:new():init(params), fwin._ui)  
                end
            end
        end
        protocol_command.enemy_boss_init.param_list = ""
        NetworkManager:register(protocol_command.enemy_boss_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local enemy_strike_world_box_close_terminal = {
    _name = "enemy_strike_world_box_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        NetworkManager:register(protocol_command.enemy_boss_exit.code, nil, nil, nil, nil, nil, false, nil)
        fwin:close(fwin:find("EnemyStrikeWorldBoxClass"))
        
        state_machine.excute("main_window_update_resource", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(enemy_strike_world_box_open_terminal)
state_machine.add(enemy_strike_world_box_close_terminal)
state_machine.init()

function EnemyStrikeWorldBox:ctor()
    self.super:ctor()
    self.roots = {}

    self._challgePanel = nil

    self._last_state = -1

    app.load("client.red_alert_time.campaign.EnemyStrike")
    app.load("client.red_alert_time.campaign.EnemyStrikeFight")
    app.load("client.red_alert_time.campaign.EnemyStrikeChallge")
    app.load("client.red_alert_time.campaign.EnemyStrikeHurt")
    app.load("client.red_alert_time.campaign.EnemyStrikeTimes")
    app.load("client.red_alert_time.campaign.EnemyStrikeBlood")
    app.load("client.red_alert_time.campaign.EnemyStrikeFiveHurt")
    app.load("client.red_alert_time.campaign.EnemyStrikeReward")
    app.load("client.red_alert_time.campaign.EnemyStrikeChatCell")
    app.load("client.red_alert_time.campaign.ExpeditionRuleInfor")

    app.load("client.red_alert_time.cells.campaign.enemy_strike_reward_cell")
    app.load("client.red_alert_time.cells.campaign.enemy_strike_fight_rank_cell")

    local function init_enemy_strike_world_box_terminal()
        local enemy_strike_world_box_update_state_info_erminal = {
            _name = "enemy_strike_world_box_update_state_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateStateInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_world_box_request_init_erminal = {
            _name = "enemy_strike_world_box_request_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("enemy_strike_world_box_update_state_info", 0, "")
                    end
                end
                protocol_command.enemy_boss_init.param_list = ""
                NetworkManager:register(protocol_command.enemy_boss_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(enemy_strike_world_box_update_state_info_erminal)
        state_machine.add(enemy_strike_world_box_request_init_erminal)
        state_machine.init()
    end
    init_enemy_strike_world_box_terminal()
end

function EnemyStrikeWorldBox:updateStateInfo( ... )
    local root = self.roots[1]
    if self._last_state == _ED.user_enemy_strike_boss_info.state then
        return
    end
    self._last_state = _ED.user_enemy_strike_boss_info.state
    if self._challgePanel ~= nil then
        self._challgePanel:removeFromParent(true)
    end
    self._challgePanel = nil
    if _ED.user_enemy_strike_boss_info.state == 0 then
        self._challgePanel = state_machine.excute("enemy_strike_challge_open", 0, {root})
    else
        self._challgePanel = state_machine.excute("enemy_strike_fight_open", 0, {root})
    end
end

function EnemyStrikeWorldBox:onEnterTransitionFinish()

end

function EnemyStrikeWorldBox:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.enemy_strike_world_box)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateStateInfo()
end

function EnemyStrikeWorldBox:init()
    self:onInit()
    return self
end

function EnemyStrikeWorldBox:onExit()
    state_machine.remove("enemy_strike_world_box_update_state_info")
    state_machine.remove("enemy_strike_world_box_request_init")
end
