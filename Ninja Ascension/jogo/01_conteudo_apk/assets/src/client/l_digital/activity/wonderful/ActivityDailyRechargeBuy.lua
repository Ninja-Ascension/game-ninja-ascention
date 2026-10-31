-- ----------------------------------------------------------------------------------------------------
-- 说明：每日充值
-------------------------------------------------------------------------------------------------------
ActivityDailyRechargeBuy = class("ActivityDailyRechargeBuyClass", Window)

local activity_daily_recharge_buy_window_open_terminal = {
    _name = "activity_daily_recharge_buy_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("ActivityDailyRechargeBuyClass")
        if nil == _homeWindow then
            local panel = ActivityDailyRechargeBuy:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_daily_recharge_buy_window_close_terminal = {
    _name = "activity_daily_recharge_buy_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("ActivityDailyRechargeBuyClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("ActivityDailyRechargeBuyClass"))
        end
        state_machine.excute("home_update_top_activity_info_state", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_daily_recharge_buy_window_open_terminal)
state_machine.add(activity_daily_recharge_buy_window_close_terminal)
state_machine.init()
    
function ActivityDailyRechargeBuy:ctor()
    self.super:ctor()
    self.roots = {}
    self.loaded = false
    self.actions = {}
    self.ship_id = 0
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.activity.wonderful.ActivityDailyRecharge")

    local function init_activity_daily_recharge_buy_window_terminal()
        -- 购买
        local go_to_buy_rmb_terminal = {
            _name = "go_to_buy_rmb",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local rechargeIndex = instance.dangWId
                local function responseRechargeCallback(response)
                    fwin:close(fwin:find("ConnectingViewClass"))
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                            and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                            and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC 
                            then
                            m_reqcharge_info.rechargeIndex = "" .. rechargeIndex
                            state_machine.excute("platform_request_for_payment", 0, response.node)
                            return
                        else
                            state_machine.excute("recharge_for_daily_recharge_activity_request_recharge_vali", 0, 0)
                        end
                    end
                end
                cc.UserDefault:getInstance():setStringForKey("paySpecialpid", ""..instance.dangWId)
                cc.UserDefault:getInstance():flush()
                protocol_command.request_top_up_order_number.param_list = "".. instance.dangWId .."\r\n"..m_sPayMould
                NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, instance, responseRechargeCallback, false, nil)
                state_machine.excute("activity_daily_recharge_buy_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --请求完成订单
        local recharge_for_daily_recharge_activity_request_recharge_vali_terminal = {
            _name = "recharge_for_daily_recharge_activity_request_recharge_vali",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseRechargeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("activity_daily_recharge_window_update_draw", 0, 0)
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
                NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, instance, responseRechargeCallback, false, nil)
                -- NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(recharge_for_daily_recharge_activity_request_recharge_vali_terminal)
        state_machine.add(go_to_buy_rmb_terminal)
        state_machine.init()
    end
    init_activity_daily_recharge_buy_window_terminal()
end

function ActivityDailyRechargeBuy:onUpdateDraw()
    local root = self.roots[1]
    
    local Panel_gift_bag_position = ccui.Helper:seekWidgetByName(root, "Panel_gift_bag_position")
    local Text_consume_power_0 = ccui.Helper:seekWidgetByName(root, "Text_consume_power_0")
    local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")

    if tonumber(self.rewards[self.dangWId].num) ~= 0 then
        Text_consume_power_0:setString(string.format(tipStringInfo_daily_recharge_tips[1], tonumber(self.rewards[self.dangWId].num)))
    else
        Text_consume_power_0:setString(tipStringInfo_daily_recharge_tips[2])
    end

    Panel_gift_bag_position:setBackGroundImage(string.format("images/ui/text/sm_hd/chaozhilibao_position_%d.png", tonumber(self.dangWId)))
    Panel_3:setBackGroundImage(string.format("images/ui/activity/mrlb_%d.png", tonumber(self.dangWId)))

    local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_1")
    local Button_recharge = ccui.Helper:seekWidgetByName(root, "Button_buy_power_connle")
    local scaleBase = ListViewDraw:getScale()
    local centerPosX = Button_recharge:getPositionX()
    local cellSize = 0
    local index = 1
    -- 奖励
    local rewards = zstring.splits(self.rewards[self.dangWId].activityInfo_reward_select, "|", ",")
    local activity_count = tonumber(#rewards)
    for i, reward in ipairs(rewards) do
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
        cellSize = cell:getContentSize().width
        index = index + 1
        ListViewDraw:addChild(cell)
    end

    ListViewDraw:requestRefreshView()

    local cellsAllSize = (cellSize*activity_count + (activity_count -1)*ListViewDraw:getItemsMargin())*scaleBase
    local newPosX = centerPosX - cellsAllSize/2
    ListViewDraw:setPositionX(newPosX)
end

function ActivityDailyRechargeBuy:onUpdate(dt)
end

function ActivityDailyRechargeBuy:init(params)
    self.dangWId = params[1]
    self.rewards = params[2]
    self:onInit()
    return self
end

function ActivityDailyRechargeBuy:onInit()
    local csbActivityDailyRechargeBuy = csb.createNode("activity/wonderful/daily_gift_bag_infor.csb")
    local root = csbActivityDailyRechargeBuy:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbActivityDailyRechargeBuy)
    self:onUpdateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_connle"), nil, 
    {
        terminal_name = "go_to_buy_rmb", 
        terminal_state = 0, 
        _cell = self, 
        dangWId = dangWId,
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil, 
    {
        terminal_name = "activity_daily_recharge_buy_window_close", 
        terminal_state = 0,
    },
    nil,0)
end

function ActivityDailyRechargeBuy:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    self:onInit()
end

function ActivityDailyRechargeBuy:unload()
    self:removeAllChildren(true)
    self.loaded = false
    self.roots = {}
end

function ActivityDailyRechargeBuy:onExit()
    state_machine.remove("activity_daily_recharge_buy_window_display")
    state_machine.remove("activity_daily_recharge_buy_window_hide")
end

function ActivityDailyRechargeBuy:createCell()
    local cell = ActivityDailyRechargeBuy:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 1)
    return cell
end