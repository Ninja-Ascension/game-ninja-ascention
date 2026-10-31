----------------------------------------------------------------------------------------------------
-- 说明:一键探索完成
----------------------------------------------------------------------------------------------------
FileIslandAllFinishCostBoxCell = class("FileIslandAllFinishCostBoxCellClass", Window)
FileIslandAllFinishCostBoxCell.__size = nil

function FileIslandAllFinishCostBoxCell:ctor()
    self.super:ctor()
	self.roots = {}
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishCostBoxListCell")

	local function init_fileIsland_all_finish_cost_box_cell_terminal()
		-- -- 点击cell
		local fileIsland_all_finish_window_goto_next_terminal = {
            _name = "fileIsland_all_finish_window_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.max_left_num <= 0 then
                    local cur_index = table.getKeyByValue(instance.ids, instance.id)
                    local id = instance.ids[cur_index + 1]
                    state_machine.excute("fileIsland_window_all_finish_update", 0, {(id or 0), 1})
                else
                    function showConfirmTip(instance,n)
                        if n == 0 then
                            local cur_index = table.getKeyByValue(instance.ids, instance.id)
                            local id = instance.ids[cur_index + 1]
                            state_machine.excute("fileIsland_window_all_finish_update", 0, {(id or 0), 1})
                        end
                    end
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    tip:init(instance, showConfirmTip, _new_interface_text[227])
                    fwin:open(tip, fwin._ui)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_all_finish_cost_box_all_update_terminal = {
            _name = "fileIsland_all_finish_cost_box_all_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateCostBtn()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_all_finish_open_box_terminal = {
            _name = "fileIsland_all_finish_open_box",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local num = params._datas._num
                
                function showConfirmTip(instance, n)
                    if n == 0 then
                        local function callbackbox(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local rewardInfo = getSceneReward(7) 
                                if rewardInfo ~= nil then
                                    app.load("client.reward.DrawRareReward")
                                    local getRewardWnd = DrawRareReward:new()
                                    getRewardWnd:init(nil, rewardInfo)
                                    fwin:open(getRewardWnd, fwin._ui)
                                    
                                    instance:onUpdateDraw()
                                    instance:updateCostBtn()
                                end
                            end
                        end

                        local data = {}
                        for i,v in ipairs(_ED.eventIds[3]) do
                            data[i] = {}
                            data[i].resultIndex = v.index
                            data[i].openTimes = num
                        end
                        local req = json.encode(data)
                        protocol_command.fileIslandRewardBoxBuy.param_list = req
                        NetworkManager:register(protocol_command.fileIslandRewardBoxBuy.code, nil, nil, nil, nil, callbackbox, false, nil)
                    end
                end
                local tempIndex = num == 6 and 4 or num
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, showConfirmTip, string.format(_new_interface_text[300], self.totalCost[tempIndex]))
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_all_finish_window_goto_next_terminal)
        state_machine.add(fileIsland_all_finish_open_box_terminal)
        state_machine.add(fileIsland_all_finish_cost_box_all_update_terminal)
        state_machine.init()
	end

	init_fileIsland_all_finish_cost_box_cell_terminal()
end

function FileIslandAllFinishCostBoxCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_dia_num_n = ccui.Helper:seekWidgetByName(root, "Text_dia_num_n")
    local ListView_box = ccui.Helper:seekWidgetByName(root, "ListView_box")
    
    ListView_box:removeAllItems()
    local nums = table.nums(_ED.eventIds[self.id])
    Text_dia_num_n:setString(nums)
    for i=1,nums do
        local cell = state_machine.excute("fileIsland_cost_box_list_cell_create", 0, {i, _ED.eventIds[self.id][i]})
        ListView_box:addChild(cell)
    end
end

function FileIslandAllFinishCostBoxCell:updateCostBtn()
    local root = self.roots[1]
    self.totalCost = {}
    local oneCost = 0
    local index = 1
    local max_num = dms.int(dms["play_config"], 104, play_config.param)
    local max_left_num = 0
    for i=1,max_num do
        for k,v in ipairs(_ED.eventIds[self.id]) do
            local left_num = max_num - tonumber(v.buyTimes)
            if tonumber(i + v.buyTimes) <= max_num then
                local cost = zstring.split(dms.string(dms["play_config"], 105, play_config.param), ",")[i + v.buyTimes]
                oneCost = oneCost + cost
            end
            if max_left_num < left_num then
                max_left_num = left_num
            end
        end
        
        if i == 1 or i == 2 or i == 3 or i == 6 then
            self.totalCost[index] = oneCost
            index = index + 1
        end
    end

    for k=1,4 do
        local Image_zs_icon = ccui.Helper:seekWidgetByName(root, "Image_zs_icon_" .. k)
        local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n_" .. k)
        local Button_open = ccui.Helper:seekWidgetByName(root, "Button_open_" .. k)
        Text_zuanshi_n:setString(self.totalCost[k])
        -- if k == 4 then
        --     Button_open:setTouchEnabled(max_left_num >= 6)
        --     Button_open:setBright(max_left_num >= 6)
        --     Image_zs_icon:setVisible(max_left_num >= 6)
        --     Text_zuanshi_n:setVisible(max_left_num >= 6)
        -- else
        --     Button_open:setTouchEnabled(max_left_num >= k)
        --     Button_open:setBright(max_left_num >= k)
        --     Image_zs_icon:setVisible(max_left_num >= k)
        --     Text_zuanshi_n:setVisible(max_left_num >= k)
        -- end
        Button_open:setTouchEnabled(max_left_num ~= 0)
        Button_open:setBright(max_left_num ~= 0)
        Image_zs_icon:setVisible(max_left_num ~= 0)
        Text_zuanshi_n:setVisible(max_left_num ~= 0)
    end
    self.max_left_num = max_left_num
end

function FileIslandAllFinishCostBoxCell:onInit()
    local csbNode = csb.createNode("campaign/explore/explore_all_finish_dia_box_cell.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --全开一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_open_1"), nil, 
     {
         terminal_name = "fileIsland_all_finish_open_box", 
         _num = 1,
         isPressedActionEnabled = true
     },
     nil, 0)
     
      --全开两次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_open_2"), nil, 
    {
        terminal_name = "fileIsland_all_finish_open_box", 
        _num = 2,
        isPressedActionEnabled = true
    },
    nil, 0)

    --全开三次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_open_3"), nil, 
     {
         terminal_name = "fileIsland_all_finish_open_box", 
         _num = 3,
         isPressedActionEnabled = true
     },
     nil, 0)

    --全开六次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_open_4"), nil, 
    {
        terminal_name = "fileIsland_all_finish_open_box", 
        _num = 6,
        isPressedActionEnabled = true
    },
    nil, 0)


    self:onUpdateDraw()
    self:updateCostBtn()
end

function FileIslandAllFinishCostBoxCell:clearUIInfo()
end

function FileIslandAllFinishCostBoxCell:initData()
end

function FileIslandAllFinishCostBoxCell:init(params)
    self.id = params[1]
    self.ids = params[2]
    self:onInit()
end

function FileIslandAllFinishCostBoxCell:createCell()
	local cell = FileIslandAllFinishCostBoxCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


