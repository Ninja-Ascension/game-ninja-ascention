-----------------------------
--今日充值福利(活动类型32)
-----------------------------
NowdayTopupReward = class("NowdayTopupRewardClass", Window)

local nowday_topup_reward_window_open_terminal = {
    _name = "nowday_topup_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("NowdayTopupRewardClass") then
            local panel = NowdayTopupReward:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(nowday_topup_reward_window_open_terminal)
state_machine.init()

function NowdayTopupReward:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    -- 当前天数
    self._now_day = 0 
    -- 剩余时间
    self._left_time = nil
    -- Initialize nowday_topup_reward state machine.
    local function init_nowday_topup_reward_terminal()
	
		--刷新
		local nowday_topup_reward_set_positiony_terminal = {
            _name = "nowday_topup_reward_set_positiony",
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

        --领取奖励
        local nowday_topup_reward_get_reward_terminal = {
            _name = "nowday_topup_reward_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index 
                local rechargeIndex = params._datas.rechargeIndex  --档位id
                if tonumber(self._activity_data[index].achieve_state) == 0 then
                    m_reqcharge_info.rechargeIndex = rechargeIndex --渠道充值档位记录
                    if zstring.tonumber(rechargeIndex) > 10 then
                        m_reqcharge_info.rechargeIndex = rechargeIndex-10
                    end
                    if app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then
                        m_reqcharge_info.tencentRechargeIndex = rechargeIndex
                    end
                    local function responseGetServerListCallback(response)
                        fwin:close(fwin:find("ConnectingViewClass"))
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                            and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                            and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
                                state_machine.excute("platform_request_for_payment", 0, response.node)
                                return
                            end
                            local function responseCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                   state_machine.excute("nowday_topup_reward_set_positiony",0,"")
                                   state_machine.excute("one_recharge_set_positiony",0,"")
                                end
                            end
                            protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
                            NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseCallback, false, nil)
                        end
                    end
                    fwin:open(ConnectingView:new(), fwin._windows)
                    protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould
                    NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{1032})
                        state_machine.excute("nowday_topup_reward_set_positiony",0,"")
                    end
                end
                local acitvity = _ED.activity_info["32"]
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n" ..32 .. "\r\n" .. instance._now_day .."\r\n" .. (index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(nowday_topup_reward_set_positiony_terminal)
        state_machine.add(nowday_topup_reward_get_reward_terminal)	
        state_machine.init()
    end
    
    -- call func init nowday_topup_reward state machine.
    init_nowday_topup_reward_terminal()
end

function NowdayTopupReward:onUpdateDraw()
    local root = self.roots[1]
    for i=1,2 do
        -- 奖励绘制
        for k = 1,6 do
            local Panel_rew_prop = ccui.Helper:seekWidgetByName(root,"Panel_rew_prop_"..i.."_".. k)
            Panel_rew_prop:removeAllChildren(true)
        end
        local reward_items = self._activity_data[i].achieve_reward
        reward_items = zstring.split(reward_items,"|")
        for j,reward in pairs(reward_items) do
            local Panel_rew_prop = ccui.Helper:seekWidgetByName(root,"Panel_rew_prop_"..i.."_".. j)
            local reward_tab = zstring.split(reward,",")
            local _item_value = tonumber(reward_tab[3])
            local _prop_type = tonumber(reward_tab[2])
            local _prop_item = tonumber(reward_tab[1])
            local data = 
            {
                item_value = _item_value,
                prop_type = _prop_type,
                prop_item = _prop_item,
            }
            local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true,6})
            Panel_rew_prop:addChild(cell)
        end
        -- 按钮状态
        local Text_recharge = ccui.Helper:seekWidgetByName(root,"Text_recharge_"..i)    -- 现价
        local Text_money_d = ccui.Helper:seekWidgetByName(root,"Text_money_d_"..i)      -- 原价
        local Button_buy = ccui.Helper:seekWidgetByName(root,"Button_buy_"..i)          -- 领取按钮
        local Button_buy_0_1 = ccui.Helper:seekWidgetByName(root,"Button_buy_0_"..i)    -- 前往按钮
        local Image_rev = ccui.Helper:seekWidgetByName(root,"Image_rev_"..i)          -- 已领取
        local BitmapFontLabel = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_"..i)          -- 百分比
        local achieve_mould_dec = zstring.split(self._activity_data[i].achieve_mould_dec,",")
        Button_buy:setVisible(false)
        Button_buy_0_1:setVisible(false)
        Text_money_d:setString(achieve_mould_dec[1])
        BitmapFontLabel:setString(achieve_mould_dec[2])
        if tonumber(self._activity_data[i].achieve_state) == 0 then -- 进行中
            Button_buy_0_1:setVisible(true)
            Button_buy_0_1:setBright(true)
            Button_buy_0_1:setTouchEnabled(true)
            Text_recharge:setString(red_alert_all_str[243])
        elseif tonumber(self._activity_data[i].achieve_state) == 1 then -- 完成
            Button_buy:setVisible(true)
            Button_buy:setBright(true)
            Button_buy:setTouchEnabled(true)
            Text_recharge:setString(red_alert_all_str[170])
        elseif tonumber(self._activity_data[i].achieve_state) == 2 then -- 已经领取
            Image_rev:setVisible(true)
            Text_recharge:setString("")
        end
    end
end

-- 倒计时
function NowdayTopupReward:onUpdate( dt )
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    server_time = os.date("*t", zstring.tonumber(server_time))
    local now_time = 24*60*60 - server_time.hour*60*60 - server_time.min*60 - server_time.sec
    local hour = math.floor(tonumber(now_time)/3600%24)
    local minute = math.floor((tonumber(now_time)%3600)/60)
    local second = math.floor((tonumber(now_time)%3600)%60)
    if self._left_time ~= nil then
        self._left_time:setString(string.format("%02d:%02d:%02d", hour, minute, second))
    end
end

function NowdayTopupReward:onEnterTransitionFinish()

end

function NowdayTopupReward:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.wonderful_recharge_rew)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --领取奖励
    for i=1,2 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_"..i), nil, 
        {
            terminal_name = "nowday_topup_reward_get_reward", 
            terminal_state = 0, 
            index = i, 
            rechargeIndex = self._activity_data[i].achieve_other_info, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)  

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_0_"..i), nil, 
        {
            terminal_name = "nowday_topup_reward_get_reward", 
            terminal_state = 0, 
            index = i, 
            rechargeIndex = self._activity_data[i].achieve_other_info, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)  
    end

    local Text_topup_reward2 = ccui.Helper:seekWidgetByName(root,"Text_topup_reward2") --剩余时间
    self._left_time = Text_topup_reward2
	self:onUpdateDraw()
end

function NowdayTopupReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._now_day = tonumber(_ED.activity_info["32"].activity_add_state)
    self._activity_data = _ED.activity_info["32"].activity_data[self._now_day+1]
	self:onInit()
    return self
end

function NowdayTopupReward:onExit()
    state_machine.remove("nowday_topup_reward_set_positiony")
    state_machine.remove("nowday_topup_reward_get_reward")
end
