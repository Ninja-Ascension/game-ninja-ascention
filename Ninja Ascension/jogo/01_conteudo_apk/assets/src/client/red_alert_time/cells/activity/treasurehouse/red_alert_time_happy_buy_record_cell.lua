--------------------------------------------------------------------------------------------------------------
--  说明：欢乐团购购买记录cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeHappyBuyRecordCell = class("RedAlertTimeHappyBuyRecordCellClass", Window)
RedAlertTimeHappyBuyRecordCell.__size = nil

--创建cell
local red_alert_time_happy_buy_record_cell_create_terminal = {
    _name = "red_alert_time_happy_buy_record_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeHappyBuyRecordCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_happy_buy_record_cell_create_terminal)
state_machine.init()

function RedAlertTimeHappyBuyRecordCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._index = 0
    self._info = nil
    self.a_type = 0
     
    local function init_red_alert_time_happy_buy_record_cell_terminal()
        local red_alert_time_happy_buy_record_cell_receive_award_terminal = {
            _name = "red_alert_time_happy_buy_record_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 返利请求
                local cell = params._datas.cells
                local acitvity = _ED.activity_info[""..cell.a_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(0).."\r\n"..(tonumber(cell._info.data_index)-1).."\r\n1\r\n"..cell._info.cost_gold
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_happy_buy_record_cell_update_info_terminal = {
            _name = "red_alert_time_happy_buy_record_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._info = params.info
                cell.a_type = params.a_type
                cell._index = params.index
                if cell._info ~= nil then
                    if cell._index <= 16 then
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

        state_machine.add(red_alert_time_happy_buy_record_cell_receive_award_terminal)
        state_machine.add(red_alert_time_happy_buy_record_cell_update_info_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_happy_buy_record_cell_terminal()

end

function RedAlertTimeHappyBuyRecordCell:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self.a_type]
    local activity_data = activity_info.activity_data[1][self._info.data_index]

    -- activity_add_state = "活动起始时间,活动关闭时间,领奖时间|第一件商品第一档折扣数,需要购买次数,第二档折扣数,需要购买次数,第三档折扣数,需要购买次数,全服限购次数|第二件商品...."
    local activity_add_state_attr = zstring.split(activity_info.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_attr[1], ",")
    local goods_info = zstring.split(activity_add_state_attr[self._info.data_index + 1], ",")

    local Text_happy_buy_name_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_name_n")
    local Text_happy_buy_number_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_number_n")
    local Text_happy_buy_gold_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_gold_n")
    local Text_happy_buy_rebate_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_rebate_n")
    local Text_happy_buy_can_rebate_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_can_rebate_n")
    local Button_happy_buy_renate = ccui.Helper:seekWidgetByName(root,"Button_happy_buy_renate")

    Text_happy_buy_name_n:setString(activity_data.achieve_mould_name.."*"..self._info.count)
    Text_happy_buy_rebate_n:setString(self._info.rebate_gold * self._info.count)
    Text_happy_buy_number_n:setString(self._info.cost_gold * self._info.count)

    -- 全服购买数量
    local all_current_count = tonumber(_ED.happy_buy_activity_info.all_count[self._info.data_index].leave_count)
    local all_total_count = tonumber(goods_info[7])
    local count = all_total_count - all_current_count

    local discount = tonumber(_ED.happy_buy_activity_info.all_count[self._info.data_index].discount)

    local cost_info = zstring.split(activity_data.achieve_other_info, ",")
    local old_cost = cost_info[3]
    local cost = math.ceil(old_cost * discount / 10)
    local can_rebate_gold = self._info.cost_gold - cost - self._info.rebate_gold
    if can_rebate_gold > 0 then
        Button_happy_buy_renate:setTouchEnabled(true)
        Button_happy_buy_renate:setBright(true)
    else
        Button_happy_buy_renate:setTouchEnabled(false)
        Button_happy_buy_renate:setBright(false)
    end
    Text_happy_buy_can_rebate_n:setString(can_rebate_gold * self._info.count)
    Text_happy_buy_gold_n:setString(cost * self._info.count)
end 

function RedAlertTimeHappyBuyRecordCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.happy_buy_record_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeHappyBuyRecordCell.__size == nil then
        RedAlertTimeHappyBuyRecordCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_happy_buy_renate"), nil, 
    {
        terminal_name = "red_alert_time_happy_buy_record_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeHappyBuyRecordCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlertTimeHappyBuyRecordCell:clearUIInfo( ... )
    local root = self.roots[1]

end

function RedAlertTimeHappyBuyRecordCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeHappyBuyRecordCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.happy_buy_record_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeHappyBuyRecordCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self.a_type = params[3]
    if self._index ~= nil and self._index <= 16 then
       self:onInit()
    end
    self:setContentSize(RedAlertTimeHappyBuyRecordCell.__size)
    return self
end

function RedAlertTimeHappyBuyRecordCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.happy_buy_record_cell, self.roots[1])
end