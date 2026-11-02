----------------------------------------------------------------------------------------------------
-- 说明：七天乐管理器
-------------------------------------------------------------------------------------------------------
SevenHappyManager = class("SevenHappyManagerClass", Window)

app.load("client.activity.seven_happy.SevenHappyLastPage")

local seven_days_manager_open_terminal = {
    _name = "seven_happy_manager_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local seven_day = SevenHappyManager:new()
        seven_day:init()
        fwin:open(seven_day, fwin._viewdialog)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_days_manager_open_terminal)
state_machine.init()

function SevenHappyManager:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_seven_days_manager_terminal()
        -- 打开终极奖励
        local seven_happy_open_last_reward_terminal = {
            _name = "seven_happy_open_last_reward",
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

                state_machine.excute("seven_happy_page_change_last_reward_state", 0, false)
                instance._isShowLast = true
                local Panel_page = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_page")
                Panel_page:removeAllChildren(true)
                state_machine.excute("sevenHappyLastPage_open", 0, {rootWindow = Panel_page})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭终极奖励
        local seven_happy_remove_last_reward_terminal = {
            _name = "seven_happy_remove_last_reward",
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
                state_machine.excute("seven_happy_page_change_last_reward_state", 0, true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭七天乐
        local seven_happy_manager_close_terminal = {
            _name = "seven_happy_manager_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if self.sevenHappyPage then
                    fwin:close(self.sevenHappyPage)
                end

                state_machine.excute("notification_center_update", 0, "push_notification_7happy_home_push")

                fwin:close(instance)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_happy_open_last_reward_terminal)
        state_machine.add(seven_happy_remove_last_reward_terminal)

        state_machine.add(seven_happy_manager_close_terminal)
        state_machine.init()
    end
    
    init_seven_days_manager_terminal()
end

-- function SevenHappyManager:drawTime(_time)
--     local timeString = ""
--     local _dayTime = math.floor((_time / 1000) / 86400)
--     local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
--     local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
--     local _secondsTime = math.ceil((_time / 1000) % 60)
--     if _dayTime > 0 then
--         timeString = timeString .. _dayTime .._string_piece_info[231]
--     end
--     if _hourTime > 0 then
--         if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
--             timeString = timeString .. _hourTime ..":"
--         else
--             timeString = timeString .. _hourTime .._string_piece_info[271]
--         end
--     end
--     if _minutesTime > 0 then
--         if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
--             timeString = timeString .. _minutesTime ..":"
--         else
--             timeString = timeString .. _minutesTime .._string_piece_info[270]
--         end
--     end
--     if _secondsTime > 0 then
--         if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
--             timeString = timeString .. _secondsTime 
--         else
--             timeString = timeString .. _secondsTime .._string_piece_info[165]
--         end
--     end
--     return timeString
-- end

function SevenHappyManager:onUpdate(dt)
    self:updateDrawActivityTime()
end

function SevenHappyManager:updateDrawActivityTime()
    local root = self.roots[1]
    if root == nil or _ED.active_activity[137] == nil then
        return
    end

    local current = _ED.system_time + (os.time() - _ED.native_time)

    local activity = self.activity
    local surplus_time = activity.end_time / 1000 - current
    self._Text_time_1:setString(getRedAlertTimeActivityFormat(surplus_time))

end

function SevenHappyManager:onEnterTransitionFinish()

end

function SevenHappyManager:onInit()
    local csbSevenHappyManager = csb.createNode("activity/7days/happy_7days.csb")
    self:addChild(csbSevenHappyManager)

    local root = csbSevenHappyManager:getChildByName("root")
    table.insert(self.roots, root)

    -- 时间
    self._Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7day_back"),   nil, 
    {
        terminal_name = "seven_happy_manager_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)    

    -- 终极奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bangzhu"),   nil, 
    {
        terminal_name = "seven_happy_open_last_reward",     
        terminal_state = 0, 
    }, 
    nil, 0)        
    

    app.load("client.activity.seven_happy.SevenHappyPage")
    self.sevenHappyPage = SevenHappyPage:new()
    self.sevenHappyPage:init()
    fwin:open(self.sevenHappyPage, fwin._ui)

end

function SevenHappyManager:init()
    self.activity = _ED.active_activity[137]
    self:onInit()
end

function SevenHappyManager:onExit()
    state_machine.remove("seven_happy_manager_close")  
    state_machine.remove("seven_happy_open_last_reward")
    state_machine.remove("seven_happy_remove_last_reward")
end

