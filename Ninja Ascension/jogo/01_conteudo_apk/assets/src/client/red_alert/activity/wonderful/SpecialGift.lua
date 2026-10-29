-----------------------------
-- 特惠礼包(活动类型34)
-----------------------------
SpecialGift = class("SpecialGiftClass", Window)

local special_gift_window_open_terminal = {
    _name = "special_gift_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("SpecialGiftClass") then
            local panel = SpecialGift:new():init(params)
            fwin:open(panel)
            return panel
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(special_gift_window_open_terminal)
state_machine.init()

function SpecialGift:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file

    -- Initialize special_gift state machine.
    local function init_special_gift_terminal()
        -- 刷新
        local special_gift_update_terminal = {
            _name = "special_gift_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --充值
        local special_gift_goto_recharge_terminal = {
            _name = "special_gift_goto_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local rechargeIndex = params._datas.index  --档位id
                m_reqcharge_info.rechargeIndex = rechargeIndex --渠道充值档位记录
                if zstring.tonumber(rechargeIndex) > 10 then
                    m_reqcharge_info.rechargeIndex = rechargeIndex-17
                end
                if app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then
                    m_reqcharge_info.tencentRechargeIndex = rechargeIndex
                end
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
                            state_machine.excute("platform_request_for_payment", 0, response.node)
                            return
                        end
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                               state_machine.excute("special_gift_update",0,"")
                            end
                        end
                        protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
                        NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseCallback, false, nil)
                    end
                end
                protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould
                NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --领取奖励
        local special_gift_get_reward_terminal = {
            _name = "special_gift_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{1034})
                        local index = 0 
                        for k,v in pairs(instance._activity_data) do
                            if tonumber(v.achieve_state) == 2 then 
                                index = index + 1 
                            end
                        end 
                        if index == #instance._activity_data then
                            state_machine.excute("wonderful_remove_page",0,{34})
                        else
                            state_machine.excute("special_gift_update",0,"")
                        end
                    end
                end
                local acitvity = _ED.activity_info["34"]
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n34\r\n0\r\n" .. (index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(special_gift_update_terminal)
        state_machine.add(special_gift_get_reward_terminal)
        state_machine.add(special_gift_goto_recharge_terminal)
        state_machine.init()
    end
    
    -- call func init sign_in state machine.
    init_special_gift_terminal()
end

function SpecialGift:onUpdateDraw()
    if _ED.activity_info["34"] == nil then
        return
    end
    local root = self.roots[1]
    local Text_topup_reward1 = ccui.Helper:seekWidgetByName(root, "Text_topup_reward1")
    Text_topup_reward1:setString(_ED.activity_info["34"].activity_dec)
    for i=1,2 do
        -- 奖励绘制
        local ListView_icon = ccui.Helper:seekWidgetByName(root,"ListView_icon_"..i) --列表
        ListView_icon:removeAllItems()  
        local reward_items = self._activity_data[i].achieve_reward
        reward_items = zstring.split(reward_items,"|")
        for i,reward in pairs(reward_items) do
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
            local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
            ListView_icon:addChild(cell)
        end
        -- 按钮状态
        local Text_money = ccui.Helper:seekWidgetByName(root,"Text_money_"..i)                      -- 价格
        local Button_rech_buy = ccui.Helper:seekWidgetByName(root,"Button_rech_buy_"..i)            -- 购买
        local Button_rech_receive = ccui.Helper:seekWidgetByName(root,"Button_rech_receive_"..i)    -- 领取
        local Image_rev = ccui.Helper:seekWidgetByName(root,"Image_rev_"..i)                        -- 已领取
        Button_rech_buy:setVisible(false)
        Button_rech_receive:setVisible(false)
        Image_rev:setVisible(false)
        Text_money:setString(self._activity_data[i].achieve_mould_dec)
        if tonumber(self._activity_data[i].achieve_state) == 0 then -- 进行中
            Button_rech_buy:setVisible(true)
        elseif tonumber(self._activity_data[i].achieve_state) == 1 then -- 完成
            Button_rech_receive:setVisible(true)
        elseif tonumber(self._activity_data[i].achieve_state) == 2 then -- 已经领取
            Image_rev:setVisible(true)
        end
    end
end

function SpecialGift:onEnterTransitionFinish()

end

function SpecialGift:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.wd_one_recharge_2)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    for i=1,2 do
        -- 购买
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rech_buy_"..i), nil, 
        {
            terminal_name = "special_gift_goto_recharge", 
            terminal_state = 0, 
            index = self._activity_data[i].achieve_other_info, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)  
        -- 领取
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rech_receive_"..i), nil, 
        {
            terminal_name = "special_gift_get_reward", 
            terminal_state = 0, 
            index = i, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)  
    end

    self:onUpdateDraw()
end

function SpecialGift:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._activity_data = _ED.activity_info["34"].activity_data[1]
	self:onInit()
    return self
end

function SpecialGift:onExit()
    state_machine.remove("special_gift_update")
    state_machine.remove("special_gift_get_reward")
    state_machine.remove("special_gift_goto_recharge")
end
