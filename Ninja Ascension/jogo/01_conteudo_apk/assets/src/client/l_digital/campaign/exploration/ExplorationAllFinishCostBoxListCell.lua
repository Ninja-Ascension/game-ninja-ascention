----------------------------------------------------------------------------------------------------
-- 试炼扫荡cell
-------------------------------------------------------------------------------------------------------
ExplorationAllFinishCostBoxListCell = class("ExplorationAllFinishCostBoxListCellClass", Window)
ExplorationAllFinishCostBoxListCell.__size = nil

local exploration_cost_box_list_cell_create_terminal = {
    _name = "exploration_cost_box_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ExplorationAllFinishCostBoxListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_cost_box_list_cell_create_terminal)
state_machine.init()

function ExplorationAllFinishCostBoxListCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._times = 0
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCostBoxCell")

    local function init_exploration_cost_box_list_cell_terminal()
        local exploration_cost_box_list_cell_update_terminal = {
            _name = "exploration_cost_box_list_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_cost_box_list_cell_buy_terminal = {
            _name = "exploration_cost_box_list_cell_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._times >= cell.max_times then
                    TipDlg.drawTextDailog(tipStringInfo_file_island_tips[1])
                    return
                end
                function showConfirmTip(cell, n)
                    if n == 0 then
                        local function callback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local rewardInfo = getSceneReward(7) 
                                if rewardInfo ~= nil then
                                    app.load("client.reward.DrawRareReward")
                                    local getRewardWnd = DrawRareReward:new()
                                    getRewardWnd:init(nil, rewardInfo)
                                    fwin:open(getRewardWnd, fwin._ui)
                                    cell:onUpdateDraw()
                                    state_machine.excute("exploration_all_finish_cost_box_all_update", 0, "")
                                end
                            end
                        end
                        local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
                        local data = {}
                        data[1] = {}
                        data[1].resultIndex = cell.resultIndex
                        data[1].openTimes = 1
                        data[1].mapId = mapId
                        local req = json.encode(data)
                        protocol_command.pokemon_explore_reward_box_buy.param_list = req
                        NetworkManager:register(protocol_command.pokemon_explore_reward_box_buy.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(cell, showConfirmTip, string.format(_new_interface_text[313], cell.cost))
                fwin:open(tip, fwin._ui)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_cost_box_list_cell_update_terminal)
        state_machine.add(exploration_cost_box_list_cell_buy_terminal)
        state_machine.init()
    end
    init_exploration_cost_box_list_cell_terminal()           
end

function ExplorationAllFinishCostBoxListCell:onUpdateDraw()
    local root = self.roots[1]
    self.resultIndex = self._boxInfo.index
    self._times = tonumber(_ED.pokemonEventIds[self._boxInfo.eventId][self._index].buyTimes)
    self.max_times = dms.int(dms["play_config"], 104, play_config.param)
    local costInfo = zstring.split(dms.string(dms["play_config"], 105, play_config.param), ",")
    self.cost = tonumber(costInfo[self._times + 1])
    local Text_sx_infoa = ccui.Helper:seekWidgetByName(root, "Text_sx_infoa")
    local AtlasLabel_num = ccui.Helper:seekWidgetByName(root, "AtlasLabel_num")
    AtlasLabel_num:setString(self._index)
    Text_sx_infoa:setString(self._times)
end

function ExplorationAllFinishCostBoxListCell:onEnterTransitionFinish()

end

function ExplorationAllFinishCostBoxListCell:onInit()
    local csbItem = csb.createNode("campaign/exploration/exploration_event_gem_box_cell.csb")
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    -- local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_rweep_tab_3_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if ExplorationAllFinishCostBoxListCell.__size == nil then
        ExplorationAllFinishCostBoxListCell.__size = size
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_box"), nil, 
    {
        terminal_name = "exploration_cost_box_list_cell_buy", 
        terminal_state = 0,
        touch_black = true,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function ExplorationAllFinishCostBoxListCell:onExit()
    cacher.freeRef("campaign/explore/explore_dia_box_cell.csb", self.roots[1])
end

function ExplorationAllFinishCostBoxListCell:init(params) 
    self._index = params[1]
    self._boxInfo = params[2]
    
    self:onInit()
    self:setContentSize(ExplorationAllFinishCostBoxListCell.__size)
end

