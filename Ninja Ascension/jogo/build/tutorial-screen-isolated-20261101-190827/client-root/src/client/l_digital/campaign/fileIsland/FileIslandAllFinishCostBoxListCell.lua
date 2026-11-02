----------------------------------------------------------------------------------------------------
-- 试炼扫荡cell
-------------------------------------------------------------------------------------------------------
FileIslandAllFinishCostBoxListCell = class("FileIslandAllFinishCostBoxListCellClass", Window)
FileIslandAllFinishCostBoxListCell.__size = nil

local fileIsland_cost_box_list_cell_create_terminal = {
    _name = "fileIsland_cost_box_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = FileIslandAllFinishCostBoxListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_cost_box_list_cell_create_terminal)
state_machine.init()

function FileIslandAllFinishCostBoxListCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._times = 0
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishCostBoxCell")

    local function init_fileIsland_cost_box_list_cell_terminal()
        local fileIsland_cost_box_list_cell_update_terminal = {
            _name = "fileIsland_cost_box_list_cell_update",
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

        local fileIsland_cost_box_list_cell_buy_terminal = {
            _name = "fileIsland_cost_box_list_cell_buy",
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
                                    state_machine.excute("fileIsland_all_finish_cost_box_all_update", 0, "")
                                end
                            end
                        end

                        local data = {}
                        data[1] = {}
                        data[1].resultIndex = cell.resultIndex
                        data[1].openTimes = 1
                        local req = json.encode(data)
                        protocol_command.fileIslandRewardBoxBuy.param_list = req
                        NetworkManager:register(protocol_command.fileIslandRewardBoxBuy.code, nil, nil, nil, nil, callback, false, nil)
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

        state_machine.add(fileIsland_cost_box_list_cell_update_terminal)
        state_machine.add(fileIsland_cost_box_list_cell_buy_terminal)
        state_machine.init()
    end
    init_fileIsland_cost_box_list_cell_terminal()           
end

function FileIslandAllFinishCostBoxListCell:onUpdateDraw()
    local root = self.roots[1]
    self.resultIndex = self._boxInfo.index
    self._times = tonumber(_ED.eventIds[self._boxInfo.eventId][self._index].buyTimes)
    self.max_times = dms.int(dms["play_config"], 104, play_config.param)
    local costInfo = zstring.split(dms.string(dms["play_config"], 105, play_config.param), ",")
    self.cost = tonumber(costInfo[self._times + 1])
    local Text_sx_infoa = ccui.Helper:seekWidgetByName(root, "Text_sx_infoa")
    local AtlasLabel_num = ccui.Helper:seekWidgetByName(root, "AtlasLabel_num")
    AtlasLabel_num:setString(self._index)
    Text_sx_infoa:setString(self._times)
end

function FileIslandAllFinishCostBoxListCell:onEnterTransitionFinish()

end

function FileIslandAllFinishCostBoxListCell:onInit()
    local csbItem = csb.createNode("campaign/explore/explore_dia_box_cell.csb")
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    -- local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_rweep_tab_3_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if FileIslandAllFinishCostBoxListCell.__size == nil then
        FileIslandAllFinishCostBoxListCell.__size = size
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_box"), nil, 
    {
        terminal_name = "fileIsland_cost_box_list_cell_buy", 
        terminal_state = 0,
        touch_black = true,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function FileIslandAllFinishCostBoxListCell:onExit()
    cacher.freeRef("campaign/explore/explore_dia_box_cell.csb", self.roots[1])
end

function FileIslandAllFinishCostBoxListCell:init(params) 
    self._index = params[1]
    self._boxInfo = params[2]
    
    self:onInit()
    self:setContentSize(FileIslandAllFinishCostBoxListCell.__size)
end

