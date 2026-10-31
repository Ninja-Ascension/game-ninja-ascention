----------------------------------------------------------------------------------------------------
-- 试炼扫荡cell
-------------------------------------------------------------------------------------------------------
SmTrialTowerSweepListCell = class("SmTrialTowerSweepListCellClass", Window)
SmTrialTowerSweepListCell.__size = nil

local sm_trial_tower_sweep_list_cell_create_terminal = {
    _name = "sm_trial_tower_sweep_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = SmTrialTowerSweepListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_trial_tower_sweep_list_cell_create_terminal)
state_machine.init()

function SmTrialTowerSweepListCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._times = 0

    local function init_sm_trial_tower_sweep_list_cell_terminal()
        local sm_trial_tower_sweep_list_cell_update_terminal = {
            _name = "sm_trial_tower_sweep_list_cell_update",
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

        local sm_trial_tower_sweep_list_cell_buy_terminal = {
            _name = "sm_trial_tower_sweep_list_cell_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                function showConfirmTip(cell, n)
                    if n == 0 then
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local rewardList = getSceneReward(37)
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(nil, rewardList)
                                fwin:open(getRewardWnd, fwin._ui)
                                state_machine.excute("sm_trial_tower_sweep_info_update_reward_info", 0, nil)

                                if _ED.active_activity[134] ~= nil and _ED.active_activity[134] ~= "" then
                                    local rewardListView = ccui.Helper:seekWidgetByName(getRewardWnd.roots[1], "ListView_136")
                                    local _tables = rewardListView:getItems()
                                    for i, cell in pairs(_tables) do
                                        if 1 == tonumber(cell.item[1]) then
                                            if cell.setActivityDouble ~= nil then
                                                cell:setActivityDouble(true)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        protocol_command.three_kingdoms_sweep.param_list = "3\r\n0\r\n0\r\n"..cell._index.."\r\n0\r\n\r\n1"
                        NetworkManager:register(protocol_command.three_kingdoms_sweep.code, nil, nil, nil, cell, responseCallback,false, nil)
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

        state_machine.add(sm_trial_tower_sweep_list_cell_update_terminal)
        state_machine.add(sm_trial_tower_sweep_list_cell_buy_terminal)
        state_machine.init()
    end
    init_sm_trial_tower_sweep_list_cell_terminal()           
end

function SmTrialTowerSweepListCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_sx_infoa = ccui.Helper:seekWidgetByName(root, "Text_sx_infoa")
    local AtlasLabel_floor = ccui.Helper:seekWidgetByName(root, "AtlasLabel_floor")
    AtlasLabel_floor:setString(self._index)
    Text_sx_infoa:setString(self._times)
end

function SmTrialTowerSweepListCell:onEnterTransitionFinish()

end

function SmTrialTowerSweepListCell:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_rweep_tab_3_list.csb")
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    -- local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_rweep_tab_3_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if SmTrialTowerSweepListCell.__size == nil then
        SmTrialTowerSweepListCell.__size = size
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_box"), nil, 
    {
        terminal_name = "sm_trial_tower_sweep_list_cell_buy", 
        terminal_state = 0,
        touch_black = true,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function SmTrialTowerSweepListCell:onExit()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_rweep_tab_3_list.csb", self.roots[1])
end

function SmTrialTowerSweepListCell:init(params) 
    self._index = params[1]
    self._times = params[2]
    local costInfo = zstring.split(dms.string(dms["play_config"], 27, play_config.param), ",")
    local buyTimes = tonumber(params[2]) + 1
    if buyTimes <= 0 then
        buyTimes = 1
    end
    if buyTimes > #costInfo then
        buyTimes = #costInfo
    end
    self.cost = costInfo[buyTimes]
    self:onInit()
    self:setContentSize(SmTrialTowerSweepListCell.__size)
end

