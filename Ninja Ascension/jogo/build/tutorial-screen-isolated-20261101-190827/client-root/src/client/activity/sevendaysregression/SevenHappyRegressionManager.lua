----------------------------------------------------------------------------------------------------
-- 说明：七天乐管理器
-------------------------------------------------------------------------------------------------------
SevenHappyRegressionManager = class("SevenHappyRegressionManagerClass", Window)

app.load("client.activity.sevendaysregression.SevenHappyRegressionLastPage")

local seven_days_manager_regression_open_terminal = {
    _name = "seven_happy_regression_manager_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local seven_day_regression = SevenHappyRegressionManager:new()
        seven_day_regression:init()
        fwin:open(seven_day_regression, fwin._viewdialog)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_days_manager_regression_open_terminal)
state_machine.init()

function SevenHappyRegressionManager:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_seven_days_regression_manager_terminal()
        -- 打开终极奖励
        local seven_happy_regression_open_last_reward_terminal = {
            _name = "seven_happy_regression_open_last_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Button_bangzhu"):setHighlighted(true)
                if instance._isShowLast == true then
                    return
                end

                state_machine.excute("seven_happy_regression_page_change_last_reward_state", 0, false)
                instance._isShowLast = true
                local Panel_page = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_page")
                Panel_page:removeAllChildren(true)
                state_machine.excute("seven_happy_regression_lastpage_open", 0, {rootWindow = Panel_page})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭终极奖励
        local seven_happy_regression_remove_last_reward_terminal = {
            _name = "seven_happy_regression_remove_last_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Button_bangzhu"):setHighlighted(false)
                local Panel_page = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_page")
                Panel_page:removeAllChildren(true)
                instance._isShowLast = false
                state_machine.excute("seven_happy_regression_page_change_last_reward_state", 0, true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭七天乐
        local seven_happy_regression_manager_close_terminal = {
            _name = "seven_happy_regression_manager_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if self.SevenHappyRegressionPage then
                    fwin:close(self.SevenHappyRegressionPage)
                end

                state_machine.excute("notification_center_update", 0, "push_notification_seven_day_regression_push")
                if not _ED.sm_check_flag then
                    if fwin:find("SmCheckInInfoWindowClass") == nil then
                        app.load("client.l_digital.activity.wonderful.SmCheckInInfoWindow")
                        if _ED.active_activity ~= nil and _ED.active_activity[38] ~= nil then
                            local activityInfo = _ED.active_activity[38].activity_Info[tonumber(_ED.active_activity[38].activity_login_day)]
                            if activityInfo ~= nil and zstring.tonumber(activityInfo.activityInfo_isReward) == 0 then
                                cc.UserDefault:getInstance():setStringForKey(getKey("GuanBattleIndex"), "-1")
                                cc.UserDefault:getInstance():flush()
                                state_machine.excute("sm_check_in_info_window_window_open", 0, {})
                                state_machine.excute("activity_window_list_view_jump_bottom", 0, "")
                            end
                        end
                    end
                end
                _ED.sm_check_flag = true

                fwin:close(instance)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_happy_regression_open_last_reward_terminal)
        state_machine.add(seven_happy_regression_remove_last_reward_terminal)

        state_machine.add(seven_happy_regression_manager_close_terminal)
        state_machine.init()
    end
    
    init_seven_days_regression_manager_terminal()
end

function SevenHappyRegressionManager:onUpdate(dt)
    self:updateDrawActivityTime()
end

function SevenHappyRegressionManager:updateDrawActivityTime()
    local root = self.roots[1]
    if root == nil or _ED.active_activity[166] == nil then
        return
    end

    local current = _ED.system_time + (os.time() - _ED.native_time)

    local activity = self.activity
    local surplus_time = activity.end_time / 1000 - current
    self._Text_time_1:setString(getRedAlertTimeActivityFormat(surplus_time))

end

function SevenHappyRegressionManager:onEnterTransitionFinish()

end

function SevenHappyRegressionManager:onInit()
    local csbSevenHappyRegressionManager = csb.createNode("activity/user_return/user_return_7days.csb")
    self:addChild(csbSevenHappyRegressionManager)

    local root = csbSevenHappyRegressionManager:getChildByName("root")
    table.insert(self.roots, root)

    -- 时间
    self._Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7day_back"),   nil, 
    {
        terminal_name = "seven_happy_regression_manager_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)    

    -- 终极奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bangzhu"),   nil, 
    {
        terminal_name = "seven_happy_regression_open_last_reward",     
        terminal_state = 0, 
    }, 
    nil, 0)        
    

    app.load("client.activity.sevendaysregression.SevenHappyRegressionPage")
    self.SevenHappyRegressionPage = SevenHappyRegressionPage:new()
    self.SevenHappyRegressionPage:init()
    fwin:open(self.SevenHappyRegressionPage, fwin._ui)

end

function SevenHappyRegressionManager:init()
    self.activity = _ED.active_activity[166]
    self:onInit()
end

function SevenHappyRegressionManager:onExit()
    state_machine.remove("seven_happy_regression_manager_close")  
    state_machine.remove("seven_happy_regression_open_last_reward")
    state_machine.remove("seven_happy_regression_remove_last_reward")
end

