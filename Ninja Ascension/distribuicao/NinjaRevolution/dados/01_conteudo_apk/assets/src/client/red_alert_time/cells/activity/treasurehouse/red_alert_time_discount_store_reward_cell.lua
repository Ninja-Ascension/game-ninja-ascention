--------------------------------------------------------------------------------------------------------------
--  折扣卖场cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeDiscountStoreRewardCell = class("RedAlertTimeDiscountStoreRewardCellClass", Window)
RedAlertTimeDiscountStoreRewardCell.__size = nil

-- 创建cell
local red_alert_time_discount_store_reward_cell_create_terminal = {
    _name = "red_alert_time_discount_store_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeDiscountStoreRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_discount_store_reward_cell_create_terminal)
state_machine.init()

function RedAlertTimeDiscountStoreRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil
    self._activity_type = 0
    self._group = 0
    
    local function init_red_alert_time_discount_store_reward_cell_terminal()
        local red_alert_time_discount_store_reward_cell_update_info_terminal = {
            _name = "red_alert_time_discount_store_reward_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._index = params.index
                cell._info = params.info
                if cell._info ~= nil then
                    if cell._index <= 8 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_discount_store_reward_cell_get_reward_terminal = {
            _name = "red_alert_time_discount_store_reward_cell_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local activity_info = _ED.activity_info[""..cell._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end     
                local achieve_index = tonumber(cell._info.achieve_index)
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n"..(cell._group-1).."\r\n"..(achieve_index-1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_discount_store_reward_cell_update_info_terminal)
        state_machine.add(red_alert_time_discount_store_reward_cell_get_reward_terminal)
        state_machine.init()
    end 
    init_red_alert_time_discount_store_reward_cell_terminal()
end

-- 刷新
function RedAlertTimeDiscountStoreRewardCell:updateDraw()
    local root = self.roots[1]

    local Text_discount_store_reward_price = ccui.Helper:seekWidgetByName(root,"Text_discount_store_reward_price")
    local Button_discount_store_reward_buy = ccui.Helper:seekWidgetByName(root,"Button_discount_store_reward_buy")

    local complete_info = zstring.split(self._info.achieve_complete_count, "/")
    if tonumber(complete_info[1]) == 0 then      
        Button_discount_store_reward_buy:setTouchEnabled(false)
        Button_discount_store_reward_buy:setBright(false)
        Button_discount_store_reward_buy:setTitleText(red_alert_time_str[231])
    else
        Button_discount_store_reward_buy:setTouchEnabled(true)
        Button_discount_store_reward_buy:setBright(true)
        Button_discount_store_reward_buy:setTitleText(activity_str_tip[49])
    end

    local cost_info = zstring.split(self._info.achieve_other_info, ",")
    Text_discount_store_reward_price:setString(cost_info[3])

    -- 奖励信息
    local ListView_discount_store_reward_icon = ccui.Helper:seekWidgetByName(root,"ListView_discount_store_reward_icon")
    ListView_discount_store_reward_icon:removeAllItems()

    local reward_info = zstring.split(self._info.achieve_reward, "|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(info[1])
        prop_data.prop_type = tonumber(info[2])
        prop_data.item_value = tonumber(info[3])
        local cell = createPropIconCell(prop_data, true, true, true)
        ListView_discount_store_reward_icon:addChild(cell)
    end
    ListView_discount_store_reward_icon:requestRefreshView()
end 

function RedAlertTimeDiscountStoreRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.discount_store_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeDiscountStoreRewardCell.__size == nil then
        RedAlertTimeDiscountStoreRewardCell.__size = root:getContentSize()
    end

    -- 按钮响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_reward_buy"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_reward_cell_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeDiscountStoreRewardCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function RedAlertTimeDiscountStoreRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_discount_store_reward_price = ccui.Helper:seekWidgetByName(root,"Text_discount_store_reward_price")
    local ListView_discount_store_reward_icon = ccui.Helper:seekWidgetByName(root,"ListView_discount_store_reward_icon")
    if Text_discount_store_reward_price ~= nil then
        Text_discount_store_reward_price:setString("")
        ListView_discount_store_reward_icon:removeAllItems()
    end
end

function RedAlertTimeDiscountStoreRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeDiscountStoreRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.discount_store_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeDiscountStoreRewardCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._activity_type = params[3]
    self._group = params[4]
    if self._index ~= nil and self._index <= 8 then
       self:onInit()
    end
    self:setContentSize(RedAlertTimeDiscountStoreRewardCell.__size)
    return self
end

function RedAlertTimeDiscountStoreRewardCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.discount_store_reward_cell, self.roots[1])
end