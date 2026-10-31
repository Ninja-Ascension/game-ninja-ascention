-----------------------------
-- 购买银币
-----------------------------
SmBuySilverCoins = class("SmBuySilverCoinsClass", Window)

--打开界面
local sm_buy_silver_coins_open_terminal = {
	_name = "sm_buy_silver_coinsopen",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmBuySilverCoinsClass") == nil then
			fwin:open(SmBuySilverCoins:new():init(), fwin._windows)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_buy_silver_coins_open_terminal)
state_machine.init()

function SmBuySilverCoins:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    self.isDouble = false
    local function init_sm_buy_silver_coinsterminal()

        --刷新界面
        local sm_buy_silver_coinsupdate_draw_page_terminal = {
            _name = "sm_buy_silver_coinsupdate_draw_page",
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
        local sm_buy_silver_coins_close_terminal = {
            _name = "sm_buy_silver_coins_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_buy_silver_coins_close")
                instance.actions[1]:play("window_close", false)
                -- fwin:close(fwin:find("SmBuySilverCoinsClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --点金
        local sm_buy_silver_coins_buy_request_terminal = {
            _name = "sm_buy_silver_coins_buy_request",
            _init = function (terminal)
                app.load("client.utils.SmBuySilverCoinsSuccess")
                app.load("client.activity.adventure.AdventureTaskWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = params._datas._page
                local number = 1
                if tonumber(m_type) > 1 then
                    --今天定金次数|是否暴击了|双倍结束时间
                    local datas = zstring.split(_ED.active_activity[84].activity_params, ",")
                    number = tonumber(datas[1])
                end
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:onUpdateDraw()
                            if tonumber(m_type) > 1 then
                                local datas = zstring.split(_ED.active_activity[84].activity_params, ",")
                                state_machine.excute("sm_buy_silver_coins_successopen",0,{m_type,tonumber(datas[1])-number})
                            else
                                state_machine.excute("sm_buy_silver_coins_successopen",0,{m_type,1})
                            end
                            state_machine.excute("daily_task_update_daily_list", 0, nil)
                            state_machine.excute("sm_role_strengthen_tab_up_product_update_draw", 0, nil)
                            state_machine.excute("sm_equipment_tab_up_product_update_draw", 0, nil)
                            state_machine.excute("adventure_task_window_onUpdate_data", 0, nil)
                        end
                    end
                end
                local activityId = _ED.active_activity[84].activity_id
                if m_type == 1 then
                    protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n".."0".."\r\n1".."\r\n84"
                else
                    protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n".."-1".."\r\n1".."\r\n84"
                end
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_buy_silver_coins_close_terminal)
        state_machine.add(sm_buy_silver_coinsupdate_draw_page_terminal)
        state_machine.add(sm_buy_silver_coins_buy_request_terminal)
        state_machine.init()
    end
    init_sm_buy_silver_coinsterminal()
end


function SmBuySilverCoins:init()
	self:onInit()
    return self
end

function SmBuySilverCoins:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local activity = _ED.active_activity[84]
    --领取次数
    local Text_number = ccui.Helper:seekWidgetByName(root,"Text_number")
    --计算总次数
    local resetCountElement = dms.element(dms["base_consume"], 62)
    local maxCount = dms.atoi(resetCountElement, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
    --今天定金次数|是否暴击了|双倍结束时间
    local datas = zstring.split(activity.activity_params, ",")
    local strs = string.format(_new_interface_text[89],zstring.tonumber(datas[1]),maxCount)
    Text_number:setString(strs)

    --消耗宝石
    local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root,"Text_zuanshi_n")
    local goodData = zstring.split(dms.string(dms["activity_config"], 7, activity_config.param), ",")
    local number = 0
    if zstring.tonumber(datas[1])+1 > #goodData then
        number = goodData[#goodData]
    else
        number = goodData[zstring.tonumber(datas[1])+1]     
    end
    Text_zuanshi_n:setString(number)

    --获得金钱
    local Text_jinbi_n = ccui.Helper:seekWidgetByName(root,"Text_jinbi_n")
    local openinfo = dms.searchs(dms["user_experience_param"], user_experience_param.level, tonumber(_ED.user_info.user_grade))
    --初始金币数
    local initial = dms.atoi(openinfo[1], user_experience_param.buy_silver_initial)
    --系数
    local coefficient = dms.atoi(openinfo[1], user_experience_param.buy_silver_coefficient)

    Text_jinbi_n:setString(initial+zstring.tonumber(datas[1])*coefficient)

    --双倍显示
    local Image_double = ccui.Helper:seekWidgetByName(root,"Image_double")
    if _ED.active_activity[90] ~= nil and zstring.tonumber(datas[1]) < dms.int(dms["activity_config"], 15, pirates_config.param) then
        --双倍
        Image_double:setVisible(true)
        self.isDouble = true
    else
        --普通
        Image_double:setVisible(false)
        self.isDouble = false
    end
    if _ED.active_activity[90] ~= nil then
        ccui.Helper:seekWidgetByName(root,"Text_tip_2"):setString(_new_interface_text[291].._new_interface_text[292])
    else
        ccui.Helper:seekWidgetByName(root,"Text_tip_2"):setString(_new_interface_text[291])
    end
end

function SmBuySilverCoins:onInit()
    local csbItem = csb.createNode("utils/sm_dianjinshou.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    local action = csb.createTimeline("utils/sm_dianjinshou.csb")
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
            state_machine.unlock("sm_buy_silver_coins_close")
            fwin:close(self)
        end
        
    end)

    self:onUpdateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_xzjl"), nil, 
    {
        terminal_name = "sm_buy_silver_coins_close",     
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_buy_silver_coins_close",     
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --10次买银币
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dianjin_10"), nil, 
    {
        terminal_name = "sm_buy_silver_coins_buy_request",     
        terminal_state = 0, 
        touch_black = true,
        _page = 10,
    }, nil, 0)

    --1次买银币
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dianjin"), nil, 
    {
        terminal_name = "sm_buy_silver_coins_buy_request",     
        terminal_state = 0, 
        touch_black = true,
        _page = 1,
    }, nil, 0)

end

function SmBuySilverCoins:onEnterTransitionFinish()
    
end


function SmBuySilverCoins:onExit()
end

