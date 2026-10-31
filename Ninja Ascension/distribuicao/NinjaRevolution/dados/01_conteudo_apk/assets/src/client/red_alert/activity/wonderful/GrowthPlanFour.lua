-----------------------------
--VIP4基金(活动类型25)
-----------------------------
GrowthPlanFour = class("GrowthPlanFourClass", Window)

local growth_plan_four_window_open_terminal = {
    _name = "growth_plan_four_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("GrowthPlanFourClass") then
            local panel = GrowthPlanFour:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(growth_plan_four_window_open_terminal)
state_machine.init()

function GrowthPlanFour:ctor()
    self.super:ctor()
    self.roots = {}

    self._height = 0
    -- load lua file

    -- Initialize growth_plan_four state machine.
    local function init_growth_plan_four_terminal()
	
		--购买
		local growth_plan_four_buy_terminal = {
            _name = "growth_plan_four_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local need_infos = _ED.activity_info["25"].activity_data[1][1].achieve_complete_count
                local need_gems = tonumber(_ED.activity_info["25"].activity_data[1][1].achieve_other_info)
                need_infos = zstring.split(need_infos,"/")
                need_infos = tonumber(need_infos[2])
                -- print("======",_ED.vip_grade,need_infos)
                if tonumber(_ED.vip_grade) >= need_infos then
                    if need_gems > tonumber(_ED.user_info.user_gold) then
                        TipDlg.drawTextDailog(red_alert_all_str[79])
                        return
                    end
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.updateBuyButton ~= nil then
                                response.node:updateBuyButton() 
                                instance:onUpdateDraw()
                            end
                        end
                    end
                    protocol_command.grow_up_activity_buy.param_list = "" .. 25
                    NetworkManager:register(protocol_command.grow_up_activity_buy.code, nil, nil, nil, instance, responseCallback, false, nil)
                else
                    TipDlg.drawTextDailog(red_alert_all_str[154])
                    state_machine.excute("recharge_dialog_window_open",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        --刷新
        local growth_plan_four_get_reward_terminal = {
            _name = "growth_plan_four_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index_day = params._datas.index
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{1025})
                        local index = 0 
                        local activity_data = _ED.activity_info["25"].activity_data[2]
                        for k,v in pairs(activity_data) do
                            if tonumber(v.achieve_state) == 2 then 
                                index = index + 1 
                            end
                        end 
                        if index == #activity_data then
                            state_machine.excute("wonderful_remove_page",0,{25})
                        else
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:onUpdateDraw()
                            end
                        end
                    end
                end
                local acitvity = _ED.activity_info["25"]
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n25\r\n1\r\n"..(index_day - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(growth_plan_four_buy_terminal)	
        state_machine.add(growth_plan_four_get_reward_terminal)
        state_machine.init()
    end
    
    -- call func init up_level state machine.
    init_growth_plan_four_terminal()
end

function GrowthPlanFour:onUpdateDraw()
    local root = self.roots[1]
    -- debug.print_r(_ED.activity_info["9"])
    local Text_growth_plan_gem = ccui.Helper:seekWidgetByName(root, "Text_growth_plan_gem") 
    Text_growth_plan_gem:setString("1")
    local Text_growth_plan_get_gem = ccui.Helper:seekWidgetByName(root, "Text_growth_plan_get_gem") 
    Text_growth_plan_get_gem:setString("6000")
    local Text_growth_plan_vip = ccui.Helper:seekWidgetByName(root, "Text_growth_plan_vip") 
    Text_growth_plan_vip:setString("VIP4")

    ccui.Helper:seekWidgetByName(root, "Image_growth_title_1"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_growth_title_2"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_growth_title_3"):setVisible(true)

    for i = 1,10 do
        local Panel_recive = ccui.Helper:seekWidgetByName(root,"Panel_recive_"..i) -- 可领取状态
        Panel_recive:setVisible(false)
        local Panel_get = ccui.Helper:seekWidgetByName(root,"Panel_get_"..i)       -- 已领取状态
        Panel_get:setVisible(false)
        local achieve_state = tonumber(_ED.activity_info["25"].activity_data[2][i].achieve_state)
        if achieve_state == 1 then
            Panel_recive:setVisible(true)
        elseif achieve_state == 2 then
            Panel_get:setVisible(true)
        end
        -- 需要达到等级
        local Text_day_number = ccui.Helper:seekWidgetByName(root,"Text_day_number_"..i)       
        local achieve_mould_dec = _ED.activity_info["25"].activity_data[2][i].achieve_mould_dec
        Text_day_number:setString(achieve_mould_dec)
        -- 获得数量
        local Text_props_n = ccui.Helper:seekWidgetByName(root,"Text_props_n_"..i)     
        local achieve_reward = _ED.activity_info["25"].activity_data[2][i].achieve_reward
        local achieve_reward = zstring.split(achieve_reward,",")  
        Text_props_n:setString(string.format(red_alert_all_str[242],achieve_reward[3]))
    end
end

-- 按钮状态
function GrowthPlanFour:updateBuyButton()
    local root = self.roots[1]
    local Button_buy = ccui.Helper:seekWidgetByName(root,"Button_buy")      -- 购买按钮
    local Image_geted = ccui.Helper:seekWidgetByName(root,"Image_geted")    -- 已购买
    local Text_buy = ccui.Helper:seekWidgetByName(root,"Text_buy") 
    local Panel_kgm = ccui.Helper:seekWidgetByName(root,"Panel_kgm")        -- 可购买光效
    if tonumber(_ED.activity_info["25"].activity_data[1][1].achieve_state) >= 1 then
        Button_buy:setVisible(false)
        Image_geted:setVisible(true)
    else
        if tonumber(_ED.vip_grade) >= 4 then
            Panel_kgm:setVisible(true)
            Text_buy:setString(red_alert_all_str[225])
        end
        Button_buy:setVisible(true)
        Image_geted:setVisible(false)
    end
    local ListView_growth_plan = ccui.Helper:seekWidgetByName(root, "ListView_growth_plan") 
    for i, cell in pairs(ListView_growth_plan:getItems()) do
        cell:updateDrawButtons()
    end
end

function GrowthPlanFour:onEnterTransitionFinish()

end

function GrowthPlanFour:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.growth_plan)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy"), nil, 
    {
        terminal_name = "growth_plan_four_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 领取
    for i=1,10 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_sday_"..i), nil, 
        {
            terminal_name = "growth_plan_four_get_reward", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i, 
        }, nil, 0)
    end

	self:onUpdateDraw()
    self:updateBuyButton()
end

function GrowthPlanFour:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function GrowthPlanFour:onExit()
    state_machine.remove("growth_plan_four_buy")
    state_machine.remove("growth_plan_four_get_reward")
    
end
