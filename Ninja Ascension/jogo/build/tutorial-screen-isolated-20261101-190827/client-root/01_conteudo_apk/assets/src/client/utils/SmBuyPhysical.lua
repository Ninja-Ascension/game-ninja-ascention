-----------------------------
-- 购买体力
-----------------------------
SmBuyPhysical = class("SmBuyPhysicalClass", Window)

--打开界面
local sm_buy_physical_open_terminal = {
	_name = "sm_buy_physicalopen",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmBuyPhysicalClass") == nil then
			fwin:open(SmBuyPhysical:new():init(params), fwin._windows)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_buy_physical_open_terminal)
state_machine.init()

function SmBuyPhysical:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.max_times = 0
    self.now_times = 0
    self.data = nil
    self.need_golds = 0
    self.btn_posX =   -- 购买按钮原位置
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.activity.adventure.AdventureTaskWindow")

    local function init_sm_buy_physicalterminal()

        --刷新界面
        local sm_buy_physicalupdate_draw_page_terminal = {
            _name = "sm_buy_physicalupdate_draw_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭界面
        local sm_buy_physical_close_terminal = {
            _name = "sm_buy_physical_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_buy_physical_close")
                instance.actions[1]:play("window_close", false)
                -- fwin:close(fwin:find("SmBuyPhysicalClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_buy_resource_sure_terminal = {
            _name = "sm_buy_resource_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.data ~= nil then
                    if instance.data[1] == 1 then
                        local function responseBuyPointCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("sm_role_strengthen_tab_skill_update_draw",0,nil)
                                state_machine.excute("sm_buy_physical_close",0,"")
                                TipDlg.drawTextDailog(tipStringInfo_prop_buy_tip[2])
                            end
                        end
                        protocol_command.ship_skill_point_buy.param_list = ""
                        NetworkManager:register(protocol_command.ship_skill_point_buy.code, nil, nil, nil, instance, responseBuyPointCallback, false, nil)
                    end
                    return
                end
                local function responseBuyResourceCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                        state_machine.excute("daily_task_update_daily_list", 0, nil)
                        state_machine.excute("adventure_task_window_onUpdate_data", 0, nil)
                    end
                end

                if instance.need_golds > tonumber(_ED.user_info.user_gold) then
                    -- print("======宝石不够")
                    TipDlg.drawTextDailog(_string_piece_info[74])
                    return
                end
                if tonumber(_ED.user_info.user_food) >= 3000 then
                    TipDlg.drawTextDailog(_new_interface_text[289])
                    return
                end
                -- if instance.now_times >= instance.max_times then
                --     TipDlg.drawTextDailog(red_alert_all_str[39])
                --     return
                -- end
                                
                protocol_command.basic_consumption.param_list = "64".."\r\n".."1"
                NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil,instance, responseBuyResourceCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 请求打开广告
        local sm_buy_physical_open_ads_page_terminal = {
            _name = "sm_buy_physical_open_ads_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_buy_physical_open_ads_page", 0, "")
                local function responseOpenCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 拉起广告界面
                        PullAdWindow()
                        state_machine.unlock("sm_buy_physical_open_ads_page", 0, "")
                    else
                        state_machine.unlock("sm_buy_physical_open_ads_page", 0, "")
                    end
                end
                -- 发送用户请求点击广告
                protocol_command.user_advertisement_click.param_list = "2"
                NetworkManager:register(protocol_command.user_advertisement_click.code, nil, nil, nil, instance, responseOpenCallback, false, nil)
                
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 广告返回结果成功
        local sm_buy_physical_result_success_page_terminal = {
            _name = "sm_buy_physical_result_success_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseAdsCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            local rewardInfo = getSceneReward(7) 
                            if rewardInfo ~= nil then
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(nil, rewardInfo)
                                fwin:open(getRewardWnd, fwin._windows)
                            end
                            response.node:onUpdateDraw()
                        end
                        state_machine.excute("daily_task_update_daily_list", 0, nil)
                        state_machine.excute("adventure_task_window_onUpdate_data", 0, nil)
                    end
                end
                protocol_command.user_advertisement_finish.param_list = "2"
                NetworkManager:register(protocol_command.user_advertisement_finish.code, nil, nil, nil, instance, responseAdsCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_buy_physical_close_terminal)
        state_machine.add(sm_buy_physicalupdate_draw_page_terminal)
        state_machine.add(sm_buy_resource_sure_terminal)
        state_machine.add(sm_buy_physical_open_ads_page_terminal)
        state_machine.add(sm_buy_physical_result_success_page_terminal)
        state_machine.init()
    end
    init_sm_buy_physicalterminal()
end

function SmBuyPhysical:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local max_times = dms.int(dms["base_consume"],64,base_consume.vip_0_value + tonumber(_ED.vip_grade))
    self.max_times = max_times
    self.now_times = zstring.tonumber(_ED.food_ready_buy_times)
    local Button_vip = ccui.Helper:seekWidgetByName(root,"Button_vip")
    local Button_goumai = ccui.Helper:seekWidgetByName(root,"Button_goumai")
    Button_vip:setVisible(false)
    Button_goumai:setVisible(false)

    local Panel_goumai = ccui.Helper:seekWidgetByName(root,"Panel_goumai")
    local Panel_tip = ccui.Helper:seekWidgetByName(root,"Panel_tip")

    if self.now_times >= self.max_times then
        Panel_goumai:setVisible(false)
        Panel_tip:setVisible(true)
        Button_vip:setVisible(true)
    else
        Panel_goumai:setVisible(true)
        Panel_tip:setVisible(false)
        local need_array = zstring.split(dms.string(dms["activity_config"] ,10 ,activity_config.param) , ",")
        self.need_golds = tonumber(need_array[self.now_times + 1])
        Button_goumai:setVisible(true)
    end
    --购买次数
    local Text_number = ccui.Helper:seekWidgetByName(root,"Text_number")
    Text_number:setString(string.format(_new_interface_text[12],self.now_times,self.max_times))
    --需要钻石
    local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root,"Text_zuanshi_n")
    Text_zuanshi_n:setString(self.need_golds)
    if self.need_golds <= tonumber(_ED.user_info.user_gold) then
        Text_zuanshi_n:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
    else
        Text_zuanshi_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    end
    local Text_tip_2_sz = ccui.Helper:seekWidgetByName(root,"Text_tip_2_sz")
    if Text_tip_2_sz ~= nil then
        Text_tip_2_sz:setString("")
    end
    local Image_activity_icon = ccui.Helper:seekWidgetByName(root,"Image_activity_icon")
    if Image_activity_icon ~= nil then
        Image_activity_icon:setVisible(false)
    end

    if self.data ~= nil then
        local Button_vip = ccui.Helper:seekWidgetByName(root,"Button_vip")
        local Button_goumai = ccui.Helper:seekWidgetByName(root,"Button_goumai")
        Button_vip:setVisible(false)
        Button_goumai:setVisible(false)
        if self.data[2] == "1" then
            Button_goumai:setVisible(true)
        elseif self.data[2] == "2" then
            Button_vip:setVisible(true)
        else
            Button_goumai:setVisible(true)
            Button_goumai:setTitleText(self.data[6])
        end
        local text_arry_1 = {
            ccui.Helper:seekWidgetByName(root,"Text_title"),
            ccui.Helper:seekWidgetByName(root,"Text_tip"),
            ccui.Helper:seekWidgetByName(root,"Text_number"),
            ccui.Helper:seekWidgetByName(root,"Text_tip_2"),
            ccui.Helper:seekWidgetByName(root,"Text_zuanshi_n"),
        }
        local text_arry_2 = {
            ccui.Helper:seekWidgetByName(root,"Text_title"), 
            ccui.Helper:seekWidgetByName(root,"Text_tip_11"), 
            ccui.Helper:seekWidgetByName(root,"Text_tip_12"), 
        }
        Panel_goumai:setVisible(false)
        Panel_tip:setVisible(false)
        local arry = {}
        if self.data[3] == true then
            Panel_goumai:setVisible(true)
            arry = text_arry_1
        else
            Panel_tip:setVisible(true)
            arry = text_arry_2
        end
        local index = 0
        for i = 4 , #self.data do
            index = index + 1
            if self.data[i] == false then   
                arry[index]:setVisible(false)
            else
                arry[index]:setString(self.data[i])
            end
        end
    else
        if Text_tip_2_sz ~= nil then
            Text_tip_2_sz:setString("120")
            Text_tip_2_sz:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
            if _ED.active_activity[94] ~= nil and _ED.active_activity[94] ~= "" then
                local times = tonumber(zstring.split(_ED.active_activity[94].activity_Info[1].activityInfo_need_day, ",")[2])
                if self.now_times < times then
                    if Image_activity_icon ~= nil then
                        Image_activity_icon:setVisible(true)
                    end
                    Text_tip_2_sz:setString("240")
                    Text_tip_2_sz:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
                end
            end
        end
    end
    self:showAdsView()
end

-- 处理广告的界面显示
function SmBuyPhysical:showAdsView()
    local root = self.roots[1]
    local isMoveBtn = false
    local Panel_look = ccui.Helper:seekWidgetByName(root,"Panel_look")
    if Panel_look then 
        Panel_look:setVisible(false)
    end
    if self.Button_look and getWatchAdFuncOpenState() then 
        self.Button_goumai:setPositionX(self.btn_posX)
        local dayInfo = dms.searchs(dms["ad_reward"], ad_reward_mould.type, 2)
        local maxTence = tonumber(dayInfo[1][ad_reward_mould.limitTence])
        local reward = zstring.split(dayInfo[1][ad_reward_mould.reward],",")
        if _ED.user_advertisement_info.day_strength_tence >= maxTence then 
            isMoveBtn = true
        else
            isMoveBtn = false
            Panel_look:setVisible(true)
        end
        -- 获得体力
        local Text_tip_15 = ccui.Helper:seekWidgetByName(root,"Text_tip_15")
        Text_tip_15:setString(string.format(tipStringInfo_watch_ads_text[5],reward[3]..""))
        -- 观看次数
        local Text_tip_16 = ccui.Helper:seekWidgetByName(root,"Text_tip_16")
        Text_tip_16:setString(string.format(tipStringInfo_watch_ads_text[6],_ED.user_advertisement_info.day_strength_tence.."",maxTence.."")) 
    elseif self.Button_look then 
        isMoveBtn = true
    end
    
    if isMoveBtn then 
        local Text_title = ccui.Helper:seekWidgetByName(root,"Text_title")
        self.Button_goumai:setPositionX(Text_title:getPositionX())
    end
end

function SmBuyPhysical:init(params) 
    if params ~= nil and params ~= "" and type(params) == "table" then
        -- 数组, 1 按钮响应，2按钮显示，3true 显示Panel_goumai false显示Panel_tip，4-..控件显示
        --2为“1”则是购买,“2”是VIP，其他则显示其他
        --如果值为fales，对应控件隐藏 ，如果值为true 则用最初始的
        self.data = params 
    end
	self:onInit()
    return self
end

function SmBuyPhysical:onInit()
    local csbItem = csb.createNode("utils/sm_goumaitili.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    local action = csb.createTimeline("utils/sm_goumaitili.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            state_machine.unlock("sm_buy_physical_close")
            fwin:close(self)
        end
        
    end)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_xzjl"), nil, 
    {
        terminal_name = "sm_buy_physical_close",     
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_buy_physical_close",     
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self.Button_goumai = ccui.Helper:seekWidgetByName(root,"Button_goumai")
    fwin:addTouchEventListener(self.Button_goumai, nil, 
    {
        terminal_name = "sm_buy_resource_sure",     
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_vip"), nil, 
    {
        terminal_name = "recharge_dialog_window_open",     
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 观看广告按钮
    self.Button_look = ccui.Helper:seekWidgetByName(root,"Button_look")
    if self.Button_look then 
        self.btn_posX = self.Button_goumai:getPositionX()
        fwin:addTouchEventListener(self.Button_look, nil, 
        {
            terminal_name = "sm_buy_physical_open_ads_page",     
            terminal_state = 0, 
            touch_black = true,
        }, nil, 3)
    end
    
    self:onUpdateDraw()
end


function SmBuyPhysical:onEnterTransitionFinish()
    
end


function SmBuyPhysical:onExit()
    state_machine.remove("sm_buy_physical_open_ads_page")
    state_machine.remove("sm_buy_physical_result_success_page")
end

