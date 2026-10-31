


SevenDaysManager = class("SevenDaysManagerClass", Window)

app.load("client.activity.sevendaysnew.SevenDaysWelfare")
app.load("client.activity.sevendaysnew.SevenDaysEveryday")
app.load("client.activity.sevendaysnew.SevenDaysAchieve")
app.load("client.activity.sevendaysnew.SevenDaysPropBuy")
app.load("client.activity.sevendays.SevenDaysActivityHelp")
local seven_days_manager_open_terminal = {
    _name = "seven_days_manager_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local seven_day = SevenDaysManager:new()
        seven_day:init()
        fwin:open(seven_day,fwin._viewdialog)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local seven_days_manager_init_info_terminal = {
    _name = "seven_days_manager_init_info",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if _ED.active_activity ~= nil and _ED.active_activity[42] ~= nil and _ED.active_activity[42] ~= "" then
            protocol_command.week_active_init.param_list = "".._ED.active_activity[42].activity_day_count
            NetworkManager:register(protocol_command.week_active_init.code, nil, nil, nil, nil, nil, false, nil)
        end
        _ED.login_popup_banner = false
        if TutorialSkip ~= nil and TutorialSkip.postersAfterTutorial ~= nil then TutorialSkip.postersAfterTutorial() end
        state_machine.excute("home_update_mission_over_finder_state", 0, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_days_manager_open_terminal)
state_machine.add(seven_days_manager_init_info_terminal)
state_machine.init()

function SevenDaysManager:ctor()
    self.super:ctor()
    self.roots = {}
    self.group = {
        _everyday = nil,
        _welfare = nil,
        _achieve = nil,
        _prop_buy = nil
    }
    self.activity = nil
    self.day_index = 1
    self.last_day_index =
    {
        0,
        0,
        0
    }
    self.now_page_index = 1
    self.terminal_names = {
        "seven_days_everyday",
        "seven_days_welfare",
        "seven_days_achieve",
        "seven_days_prop_buy",
    }
    self._Text_time_1 = nil
    self._Text_time_2 = nil
    self._isShowLast = false

    local function init_seven_days_manager_terminal()
        local seven_days_manager_terminal = {
            _name = "seven_days_manager",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end

                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then

                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end

                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    for i,v in pairs(instance.group) do
                        if v ~= nil then
                            v:setVisible(false)
                        end
                    end
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local seven_days_manager_close_terminal = {
            _name = "seven_days_manager_close",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i,v in pairs(instance.group) do
                    if v ~= nil then
                        fwin:close(v)
                    end
                end
                fwin:close(instance)

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
                    or __lua_project_id == __lua_project_l_naruto
                    then
                    state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 42)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_everyday_terminal = {
            _name = "seven_days_everyday",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.now_page_index = 1
                if instance.group._everyday == nil then
                    instance.group._everyday = SevenDaysEveryday:new()
                    instance.group._everyday:init()
                    fwin:open(instance.group._everyday,fwin._ui)
                end
                instance.group._everyday:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local seven_days_welfare_terminal = {
            _name = "seven_days_welfare",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.now_page_index = 2
                local day_index = instance.day_index
                if instance.group._welfare == nil then
                    instance.group._welfare = SevenDaysWelfare:new()
                    instance.group._welfare:init(day_index)
                    fwin:open(instance.group._welfare,fwin._ui)
                end
                if day_index ~= instance.last_day_index[1] then
                    instance.last_day_index[1] = day_index
                    instance.group._welfare:onUpdateDraw(day_index)
                end
                instance.group._welfare:setVisible(true)

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

                else
                    state_machine.excute("seven_days_walfare_change_image_day",0,instance.day_index)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local seven_days_achieve_terminal = {
            _name = "seven_days_achieve",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.now_page_index = 3
                local day_index = instance.day_index
                if instance.group._achieve == nil then
                    instance.group._achieve = SevenDaysAchieve:new()
                    instance.group._achieve:init(day_index)
                    fwin:open(instance.group._achieve,fwin._ui)
                end
                if day_index ~= instance.last_day_index[3] then
                    instance.last_day_index[3] = day_index
                    instance.group._achieve:onUpdateDraw(day_index)
                end
                instance.group._achieve:setVisible(true)
                state_machine.excute("seven_days_achieve_change_image_day",0,instance.day_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local seven_days_prop_buy_terminal = {
            _name = "seven_days_prop_buy",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.now_page_index = 4
                local day_index = instance.day_index
                if instance.group._prop_buy == nil then
                    instance.group._prop_buy = SevenDaysPropBuy:new()
                    instance.group._prop_buy:init(day_index)
                    fwin:open(instance.group._prop_buy,fwin._ui)
                end
                if day_index ~= instance.last_day_index[4] then
                    instance.last_day_index[4] = day_index
                    instance.group._prop_buy:onUpdateDraw(day_index)
                end
                instance.group._prop_buy:setVisible(true)
                state_machine.excute("seven_days_propbuy_change_image_day",0,instance.day_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_change_day_terminal = {
            _name = "seven_days_change_day",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.day_index = params
                _ED._sevenDaysActivity_selectActivityDayCount = instance.day_index
                state_machine.excute(instance.terminal_names[instance.now_page_index],0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_open_last_reward_terminal = {
            _name = "seven_days_open_last_reward",
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
                state_machine.excute("seven_days_welfare_change_last_reward_state", 0, false)
                instance._isShowLast = true
                local Panel_page = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_page")
                Panel_page:removeAllChildren(true)
                state_machine.excute("seven_days_activity_help_open", 0, {rootWindow = Panel_page})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_remove_last_reward_terminal = {
            _name = "seven_days_remove_last_reward",
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
                state_machine.excute("seven_days_welfare_change_last_reward_state", 0, true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_manager_terminal)
        state_machine.add(seven_days_manager_close_terminal)
        state_machine.add(seven_days_everyday_terminal)
        state_machine.add(seven_days_welfare_terminal)
        state_machine.add(seven_days_achieve_terminal)
        state_machine.add(seven_days_prop_buy_terminal)
        state_machine.add(seven_days_change_day_terminal)
        state_machine.add(seven_days_open_last_reward_terminal)
        state_machine.add(seven_days_remove_last_reward_terminal)
        state_machine.init()
    end


    init_seven_days_manager_terminal()
end
function SevenDaysManager:changeDay()

end
function SevenDaysManager:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime > 0 then
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            timeString = timeString .. _hourTime ..":"
        else
            timeString = timeString .. _hourTime .._string_piece_info[271]
        end
    end
    if _minutesTime > 0 then
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            timeString = timeString .. _minutesTime ..":"
        else
            timeString = timeString .. _minutesTime .._string_piece_info[270]
        end
    end
    if _secondsTime > 0 then
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            timeString = timeString .. _secondsTime
        else
            timeString = timeString .. _secondsTime .._string_piece_info[165]
        end
    end
    return timeString
end

function SevenDaysManager:onUpdate(dt)
    self:updateDrawActivityTime()
end

function SevenDaysManager:updateDrawActivityTime()
    local root = self.roots[1]
    if root == nil or _ED.active_activity[42] == nil then
        return
    end
    local activity = self.activity
    local surplus_time = activity.activity_over_time/1000 + activity.activity_current_time - os.time() + (_ED.system_time - _ED.native_time)*2
    self._Text_time_1:setString(getRedAlertTimeActivityFormat(surplus_time))
    surplus_time = activity.activity_draw_over_time/1000 + activity.activity_current_time - os.time() + (_ED.system_time - _ED.native_time)*2
    if self._Text_time_2 ~= nil then
        self._Text_time_2:setString(getRedAlertTimeActivityFormat(surplus_time))
    end
    if surplus_time <= 0 then
        _ED.active_activity[42] = nil
        state_machine.excute("home_update_top_activity_info_state", 0, nil)
    end
end

function SevenDaysManager:onEnterTransitionFinish()

end

function SevenDaysManager:onInit()
    local csbSevenDaysManager = csb.createNode("activity/7days/week_Activities_lhm.csb")
    self:addChild(csbSevenDaysManager)

    local root = csbSevenDaysManager:getChildByName("root")
    table.insert(self.roots, root)


    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        for i = 1, 4 do
            local rewardTabButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7_day_"..i),   nil,
            {
                terminal_name = "seven_days_manager",
                next_terminal_name = self.terminal_names[i],
                current_button_name = "Button_7_day_"..i,
                terminal_state = 0,
                isPressedActionEnabled = false
            },
            nil, 0)
        end
    end

    self._Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")
    self._Text_time_2 = ccui.Helper:seekWidgetByName(root, "Text_time_2")

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_new_sevendays_welfare",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_7_day_1"),
    _invoke = nil,
    _interval = 0.5,})
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_new_sevendays_recharge",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_7_day_2"),
    _invoke = nil,
    _interval = 0.5,})
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_new_sevendays_achieve",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_7_day_3"),
    _invoke = nil,
    _interval = 0.5,})
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_new_sevendays_half",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_7_day_4"),
    _invoke = nil,
    _interval = 0.5,})
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7day_back"),   nil,
    {
        terminal_name = "seven_days_manager_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bangzhu"),   nil,
    {
        terminal_name = "seven_days_open_last_reward",
        terminal_state = 0,

    },
    nil, 0)

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        self.now_page_index = 2
        self.day_index = 2
        state_machine.excute("seven_days_manager",0,{
            _datas = {
                    terminal_name = "seven_days_manager",
                    next_terminal_name = self.terminal_names[self.now_page_index],
                    terminal_state = 0,
                    isPressedActionEnabled = false
                }
        })
        local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
        if Panel_dh ~= nil then
            Panel_dh:removeAllChildren(true)
            local jsonFile = "sprite/sprite_qmb_reward.json"
            local atlasFile = "sprite/sprite_qmb_reward.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_dh:addChild(animation)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_activity_everydays_all_target",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_bangzhu"),
                _invoke = nil,
                _interval = 0.5,})
        end
    else
    	self.now_page_index = 1
        self.day_index = 1
        state_machine.excute("seven_days_manager",0,{
            _datas = {
                    terminal_name = "seven_days_manager",
                    next_terminal_name = self.terminal_names[self.now_page_index],
                    current_button_name = "Button_7_day_"..self.now_page_index,
                    terminal_state = 0,
                    isPressedActionEnabled = false
                }
        })
    end
end

function SevenDaysManager:init()
    self.activity = _ED.active_activity[42]
    local nowDayCount = zstring.tonumber(self.activity.activity_day_count)
    self.day_index = nowDayCount

    _ED._sevenDaysActivity_currentActivityDayCount = nowDayCount
    _ED._sevenDaysActivity_selectActivityDayCount = nowDayCount
    self:onInit()
end

function SevenDaysManager:onExit()
    state_machine.remove("seven_days_manager")
    state_machine.remove("seven_days_manager_close")
    state_machine.remove("seven_days_everyday")
    state_machine.remove("seven_days_welfare")
    state_machine.remove("seven_days_achieve")
    state_machine.remove("seven_days_prop_buy")
    state_machine.remove("seven_days_change_day")
    state_machine.remove("seven_days_open_last_reward")
    state_machine.remove("seven_days_remove_last_reward")
end

