--------------------------------------------------------------------------------------------------------------
--  说明：开放礼包的cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeGiftPacksCell = class("RedAlerTimeGiftPacksCellClass", Window)
RedAlerTimeGiftPacksCell.__size = nil

--创建cell
local red_alert_time_gift_packs_cell_create_terminal = {
    _name = "red_alert_time_gift_packs_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeGiftPacksCell:new()
        local activity_type = params[1]
        local index = tonumber(params[2])
        local a_type = tonumber(params[3]) or 0
        local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_gift_packs_cell_create_terminal)
state_machine.init()

function RedAlerTimeGiftPacksCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
    self.a_type = 0
    self.example = nil
     -- Initialize red_alert_time_act_share_cell state machine.
     app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_discount_label")
     
    local function init_red_alert_time_gift_packs_cell_terminal()
        local red_alert_time_gift_packs_cell_receive_award_terminal = {
            _name = "red_alert_time_gift_packs_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local acitvity = _ED.activity_info[""..cell.a_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                        checkEffectLevelUp()
                        state_machine.excute("main_window_update_top_button", 0, nil)
                        state_machine.excute("red_alert_time_wonderful_update_push",0,9)
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..tonumber(cell._activity_type.achieve_index)-1
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --充值
        local red_alert_time_gift_packs_cell_recharge_terminal = {
            _name = "red_alert_time_gift_packs_cell_recharge",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local rechargeCell = params._datas._cell
                local rechargeIndex = rechargeCell.example[1]
                local _isMonthCard = rechargeCell.example[13]
                local needGoods = rechargeCell.example[4]
                if __lua_project_id == __lua_project_red_alert_time 
                    or __lua_project_id == __lua_project_pacific_rim 
                    then
                    local crossPiece = dms.searchs(dms["top_up_goods"], top_up_goods.money, needGoods)
                    m_reqcharge_info.rechargeIndex = crossPiece[1][1]
                else
                    m_reqcharge_info.rechargeIndex = rechargeIndex
                end
                m_reqcharge_info.isMonthCard = _isMonthCard

                local function responseGetServerListCallback(response)
                    fwin:close(fwin:find("ConnectingViewClass"))
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if __lua_project_id == __lua_project_red_alert_time 
                            or __lua_project_id == __lua_project_pacific_rim 
                            then
                            _ED.recharge_result.recharge_id = _ED.recharge_result.recharge_id.."_"..rechargeIndex
                        end
                        if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
                            state_machine.excute("platform_request_for_payment", 0, response.node)
                            return
                        end
                        state_machine.excute("red_alert_time_gift_packs_cell_check_the_order_to_refresh", 0, response.node)
                    end
                end
                fwin:open(ConnectingView:new(), fwin._windows)
                protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould
                NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, params, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --请求效验订单刷新列表
        local red_alert_time_gift_packs_cell_check_the_order_to_refresh_terminal = {
            _name = "red_alert_time_gift_packs_cell_check_the_order_to_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --local rechargeCell = params._datas._cell
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("red_alert_time_wonderful_update_push",0,response.node.a_type)
                            response.node:updateDraw()
                        end
                    end
                end
                if app.configJson.UserAccountPlatformName ~= "jar-world" then
                    if m_play_pay_type~= nil and m_play_pay_type~="" then
                        protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id..m_play_pay_type
                    else
                        protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id
                    end
                else
                    protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
                end
                NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                --NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_gift_packs_cell_receive_award_terminal)
        state_machine.add(red_alert_time_gift_packs_cell_recharge_terminal)
        state_machine.add(red_alert_time_gift_packs_cell_check_the_order_to_refresh_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_gift_packs_cell_terminal()

end

function RedAlerTimeGiftPacksCell:updateDraw()
    local root = self.roots[1]
    local Text_gift_packs = ccui.Helper:seekWidgetByName(root,"Text_gift_packs")
    local Button_receive = ccui.Helper:seekWidgetByName(root,"Button_receive")
    local Button_recharge = ccui.Helper:seekWidgetByName(root,"Button_recharge")

    Text_gift_packs:setString(self._activity_type.achieve_mould_name)

    local cost = self.example[4]
    if _string_piece_info[217] == "$" then 
        Button_recharge:setTitleText(_string_piece_info[217]..cost)
    else
        Button_recharge:setTitleText(cost.._string_piece_info[217])
    end 

    local infoData = zstring.split(_ED.activity_info[""..self.a_type].activity_add_state, ",")
    local current_count = zstring.split(self._activity_type.achieve_complete_count, "/")
    local current_recive_count = zstring.tonumber(infoData[self.index + 1])
    if zstring.tonumber(current_count[1]) <= current_recive_count then
        Button_recharge:setVisible(true)
        Button_receive:setVisible(false)
        if zstring.tonumber(current_count[2]) == current_recive_count then
            Button_recharge:setVisible(false)
            Button_receive:setVisible(true)
            Button_receive:setTitleText(red_alert_time_str[231])
            Button_receive:setTouchEnabled(false)
            Button_receive:setBright(false)
        end
    elseif zstring.tonumber(current_count[1]) > current_recive_count then
        Button_recharge:setVisible(false)
        Button_receive:setVisible(true)
        Button_receive:setTitleText(activity_str_tip[5])
        Button_receive:setTouchEnabled(true)
        Button_receive:setBright(true)
    end

    local ListView_gift_exchange_reward = ccui.Helper:seekWidgetByName(root,"ListView_gift_exchange_reward")
    ListView_gift_exchange_reward:removeAllItems()
    local datas = zstring.split(self._activity_type.achieve_reward, "|")
    for k, v in pairs(datas) do
        local info = zstring.split(v, ",")
        local reward = {}
        reward.prop_item = tonumber(info[1])
        reward.prop_type = tonumber(info[2])
        reward.item_value = tonumber(info[3])
        local cell = createPropIconCell(reward, true, true, true)
        ListView_gift_exchange_reward:addChild(cell)
    end

    ListView_gift_exchange_reward:requestRefreshView()
end

function RedAlerTimeGiftPacksCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.act_gift_packs, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeGiftPacksCell.__size == nil then
        RedAlerTimeGiftPacksCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_receive"), nil, 
    {
        terminal_name = "red_alert_time_gift_packs_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    local info = zstring.split(self._activity_type.achieve_other_info, ",")
    local top_up_goods_id = tonumber(info[1])
    self.example = dms.element(dms["top_up_goods"], top_up_goods_id)

    --充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge"), nil, 
    {
        terminal_name = "red_alert_time_gift_packs_cell_recharge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _cell = self,
    }, nil, 1)

    self:updateDraw()

end

function RedAlerTimeGiftPacksCell:onEnterTransitionFinish()
    
end

function RedAlerTimeGiftPacksCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_gift_packs = ccui.Helper:seekWidgetByName(root,"Text_gift_packs")
    local ListView_gift_exchange_reward = ccui.Helper:seekWidgetByName(root,"ListView_gift_exchange_reward")
    if ListView_gift_exchange_reward ~= nil then
        Text_gift_packs:setString("")
        ListView_gift_exchange_reward:removeAllItems()
    end
end

function RedAlerTimeGiftPacksCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlerTimeGiftPacksCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_gift_packs, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeGiftPacksCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self.index = index
    self.a_type = a_type
    self.group = group
    -- if index ~= nil and index < 8 then
       self:onInit()
    -- end

    self:setContentSize(RedAlerTimeGiftPacksCell.__size)
    return self
end

function RedAlerTimeGiftPacksCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_gift_packs, self.roots[1])
end