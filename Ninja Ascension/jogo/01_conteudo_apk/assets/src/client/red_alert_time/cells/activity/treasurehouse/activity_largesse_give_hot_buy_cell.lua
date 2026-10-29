----------------------------------------------------------------------------------------------------
-- 说明：充值红包cell
-------------------------------------------------------------------------------------------------------
ActivityLargesseGiveHotBuyCell = class("ActivityLargesseGiveHotBuyCellClass", Window)
ActivityLargesseGiveHotBuyCell.__size = nil

local activity_largesse_give_hot_buy_create_cell_terminal = {
    _name = "activity_largesse_give_hot_buy_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ActivityLargesseGiveHotBuyCell:new():init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_largesse_give_hot_buy_create_cell_terminal)
state_machine.init()

function ActivityLargesseGiveHotBuyCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._index = 0
    self._activity_info = {}
    self._activity_type = 0

    local function init_activity_largesse_give_hot_buy_cell_terminal()
        --更新数据
        local activity_largesse_give_hot_buy_cell_update_terminal = {
            _name = "activity_largesse_give_hot_buy_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                cell:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --领取
        local activity_largesse_give_hot_buy_cell_get_reward_terminal = {
            _name = "activity_largesse_give_hot_buy_cell_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("活动领取接口")
                local cell = params._datas.cells
                local acitvity = _ED.activity_info[""..cell._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            -- response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..(tonumber(cell._activity_info.achieve_index)-1).."\r\n".."0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_largesse_give_hot_buy_cell_get_reward_terminal)
        state_machine.add(activity_largesse_give_hot_buy_cell_update_terminal)        
        state_machine.init()
    end
    init_activity_largesse_give_hot_buy_cell_terminal() 
end

function ActivityLargesseGiveHotBuyCell:updateDraw()
    local root = self.roots[1]
    local LoadingBar_integral_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_integral_bar")    --进度条
    local Text_recharge_bonus_n_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_n_1")    --金币
    local ListView_recharge_bonus_reward_1 = ccui.Helper:seekWidgetByName(root,"ListView_recharge_bonus_reward_1")    --图像容器
    local Button_recharge_bonus_rec_1 = ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_rec_1")    --领取按钮
    local Text_recharge_bonus_not_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_not_1")        --按钮下的文本
    Text_recharge_bonus_n_1:setString("0")

    local achieve_complete_count = zstring.split(self._activity_info.achieve_complete_count, "/")
    Text_recharge_bonus_n_1:setString(achieve_complete_count[2])

    ListView_recharge_bonus_reward_1:removeAllItems()
    local reward_info = zstring.split(self._activity_info.achieve_reward, "|")
    for k, v in pairs(reward_info) do
        local prop_info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(prop_info[1])
        prop_data.prop_type = tonumber(prop_info[2])
        prop_data.item_value = tonumber(prop_info[3])
        local cell = createPropIconCell(prop_data, true, false, true)
        ListView_recharge_bonus_reward_1:addChild(cell)
    end 
    ListView_recharge_bonus_reward_1:requestRefreshView()

    Text_recharge_bonus_not_1:setVisible(true)
    if tonumber(self._activity_info.achieve_state) == 0 then
        Button_recharge_bonus_rec_1:setVisible(false)
        Text_recharge_bonus_not_1:setString(activity_str_tip[147])
    elseif tonumber(self._activity_info.achieve_state) == 1 then
        Button_recharge_bonus_rec_1:setVisible(true)
        Text_recharge_bonus_not_1:setString("")
    else
        Button_recharge_bonus_rec_1:setVisible(false)
        Text_recharge_bonus_not_1:setString(activity_str_tip[2])
    end 

    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state,",")

    local activity_data = activity_info.activity_data[2]
    local min_count = 0
    local max_count = tonumber(achieve_complete_count[2])
    local index = self._activity_info.achieve_index
    if activity_data[index - 1] ~= nil then 
        local complete_count = zstring.split(activity_data[index - 1].achieve_complete_count, "/")
        min_count = tonumber(complete_count[2])
    end
    local current_count = tonumber(activity_add_state[4])
    local percent = 0
    if current_count < min_count then
        percent = 0
    elseif current_count > max_count then
        percent = 100
    else
        percent = (current_count - min_count) * 100 / (max_count- min_count)
    end
    LoadingBar_integral_bar:setPercent(percent)
end

function ActivityLargesseGiveHotBuyCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.recharge_bonus_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_rec_1"), nil, 
    {
        terminal_name = "activity_largesse_give_hot_buy_cell_get_reward", 
        terminal_state = 0,
        touch_black = true,
        cells = self,
    },
    nil,1)

    if ActivityLargesseGiveHotBuyCell.__size == nil then
        ActivityLargesseGiveHotBuyCell.__size = root:getContentSize()
    end
    self:updateDraw()
end

function ActivityLargesseGiveHotBuyCell:init(params)
    self._index = params[1]
    self._activity_info = params[2]
    self._activity_type = params[3]
    self.group = params[4]
    self:onInit()
    self:setContentSize(ActivityLargesseGiveHotBuyCell.__size)
    return self
end

function ActivityLargesseGiveHotBuyCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityLargesseGiveHotBuyCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.recharge_bonus_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ActivityLargesseGiveHotBuyCell:clearUIInfo( ... )
    local root = self.roots[1]  
    local Text_recharge_bonus_n_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_n_1")    
    local ListView_recharge_bonus_reward_1 = ccui.Helper:seekWidgetByName(root,"ListView_recharge_bonus_reward_1")        
    local Text_recharge_bonus_not_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_not_1") 
    if ListView_recharge_bonus_reward_1 ~= nil then
        Text_recharge_bonus_n_1:setString("")
        ListView_recharge_bonus_reward_1:removeAllItems()
        Text_recharge_bonus_not_1:setString("")
    end
end

function ActivityLargesseGiveHotBuyCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.recharge_bonus_cell, self.roots[1])
end