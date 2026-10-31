-- ----------------------------------------------------------------------------------------------------
-- 说明：活跃度
-------------------------------------------------------------------------------------------------------
SmActivityActive = class("SmActivityActiveClass", Window)

local sm_activity_active_window_open_terminal = {
    _name = "sm_activity_active_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		
        local function responseDailyMissionInitCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("SmActivityActiveClass") == nil then
                    local panel = SmActivityActive:new():init(params)
                    fwin:open(panel, fwin._ui)
                end
            end
        end
        protocol_command.daily_mission_init.param_list = ""
        NetworkManager:register(protocol_command.daily_mission_init.code, nil, nil, nil, self, responseDailyMissionInitCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_active_window_close_terminal = {
    _name = "sm_activity_active_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmActivityActiveClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_active_window_open_terminal)
state_machine.add(sm_activity_active_window_close_terminal)
state_machine.init()
    
function SmActivityActive:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.cells.prop.prop_icon_new_cell")
    app.load("client.cells.prop.prop_money_icon")

    app.load("client.l_digital.activity.wonderful.SmActivityActiveReward")
    app.load("client.l_digital.activity.wonderful.SmActivityActiveHelp")
    app.load("client.l_digital.cells.activity.wonderful.sm_activity_active_cell")
    app.load("client.l_digital.cells.activity.wonderful.sm_activity_active_reward_cell")

    local function init_sm_activity_active_window_terminal()
        local sm_activity_active_window_update_terminal = {
            _name = "sm_activity_active_window_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                    instance:updateTotalRewardInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_active_window_get_all_reward_terminal = {
            _name = "sm_activity_active_window_get_all_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local str = ""
                for i, v in ipairs(_ED.daily_task_info) do
                    if zstring.tonumber(v.daily_task_param) == 0 then
                        local dailyTaskMould = dms.element(dms["daily_mission_param"], v.daily_task_mould_id)
                        local ntype = dms.atoi(dailyTaskMould, daily_mission_param.ntype)
                        if ntype == 1 then
                            local completeCount = zstring.tonumber(v.daily_task_complete_count)
                            local conditionParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.condition_param), ",")
                            local needCompleteCount = zstring.tonumber(conditionParam[#conditionParam])
                            if completeCount >= needCompleteCount then
                                if str == "" then
                                    str = v.daily_task_id
                                else
                                    str = str..","..v.daily_task_id
                                end
                            end
                        end
                    end
                end
                if str == "" then
                    TipDlg.drawTextDailog(_new_interface_text[288])
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(42)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("sm_activity_active_window_update", 0, nil)
                    end
                end
                protocol_command.draw_daily_mission_reward.param_list = str
                NetworkManager:register(protocol_command.draw_daily_mission_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_active_window_update_reward_info_terminal = {
            _name = "sm_activity_active_window_update_reward_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateTotalRewardInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_active_window_update_terminal)
        state_machine.add(sm_activity_active_window_get_all_reward_terminal)
        state_machine.add(sm_activity_active_window_update_reward_info_terminal)
        state_machine.init()
    end
    init_sm_activity_active_window_terminal()
end

function SmActivityActive:updateTotalRewardInfo( ... )
    local root = self.roots[1]
    local LoadingBar_jfjd = ccui.Helper:seekWidgetByName(root, "LoadingBar_jfjd")
    local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
    if Panel_4._x == nil then
        Panel_4._x = Panel_4:getPositionX()
    end
    local Text_title_1 = ccui.Helper:seekWidgetByName(root, "Text_title_1")
    Text_title_1:setString(_ED.daily_task_integral)
    
    local percent = _ED.daily_task_integral
    LoadingBar_jfjd:setPercent(percent * 100/110)
    local width = LoadingBar_jfjd:getContentSize().width
    if percent >= 110 then
        percent = 110
    end
    Panel_4:setPositionX(Panel_4._x + width * percent/110)
    for k,v in pairs(_ED.daily_task_draw_index) do
        local Panel_reward_box = ccui.Helper:seekWidgetByName(root, "Panel_reward_box_"..k)
        Panel_reward_box:removeAllChildren(true)
        local cell = state_machine.excute("sm_activity_active_reward_cell_create", 0, {k, tonumber(v)})
        Panel_reward_box:addChild(cell)
    end
end

function SmActivityActive:onUpdateDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllItems()

    local function sortFun(a, b)
        return tonumber(a.daily_task_mould_id) < tonumber(b.daily_task_mould_id)
    end
    table.sort(_ED.daily_task_info, sortFun)

    local canRewardList = {}
    local canNotRewardList = {}
    local haveRewardList = {}
    local showTaskList = {}
    for i, v in ipairs(_ED.daily_task_info) do
        local dailyTaskMould = dms.element(dms["daily_mission_param"], v.daily_task_mould_id)
        if dailyTaskMould ~= nil then
            local ntype = dms.atoi(dailyTaskMould, daily_mission_param.ntype)
            if ntype == 1 then
                local drawRewardState = zstring.tonumber(v.daily_task_param)
                local completeCount = zstring.tonumber(v.daily_task_complete_count)
                local conditionParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.condition_param), ",")
                local needCompleteCount = zstring.tonumber(conditionParam[#conditionParam])
                local mission_condition = dms.atoi(dailyTaskMould, daily_mission_param.mission_condition)
                local isFindSame = false
                for k,v in pairs(showTaskList) do
                    if tonumber(v) == mission_condition then
                        isFindSame = true
                        break
                    end
                end
                if isFindSame == false then
                    if drawRewardState == 0 then
                        if completeCount >= needCompleteCount then
                            table.insert(canRewardList, v)
                        else
                            table.insert(canNotRewardList, v)
                        end
                        table.insert(showTaskList, mission_condition)
                    else
                        local next_id = dms.atoi(dailyTaskMould, daily_mission_param.next_id)
                        if next_id == -1 then
                            table.insert(haveRewardList, v)
                            table.insert(showTaskList, mission_condition)
                        end
                    end
                end
            end
        end
    end
    local index = 0
    for k,v in pairs(canRewardList) do
        index = index + 1
        local cell = state_machine.excute("sm_activity_active_cell_create", 0, {index, v})
        ListView_1:addChild(cell)
    end
    for k,v in pairs(canNotRewardList) do
        --  判断神秘商店是否开启
        local traceFunctionId = dms.int(dms["daily_mission_param"], v.daily_task_mould_id, daily_mission_param.trace_function_id)
        if traceFunctionId == 388 then
            if _ED.secret_shop_info and _ED.secret_shop_info.end_time - (_ED.system_time + (os.time() - _ED.native_time)) > 0 then
                index = index + 1
                local cell = state_machine.excute("sm_activity_active_cell_create", 0, {index, v})
                ListView_1:addChild(cell) 
            end
        else
            index = index + 1
            local cell = state_machine.excute("sm_activity_active_cell_create", 0, {index, v})
            ListView_1:addChild(cell) 
        end
        
    end
    for k,v in pairs(haveRewardList) do
        index = index + 1
        local cell = state_machine.excute("sm_activity_active_cell_create", 0, {index, v})
        ListView_1:addChild(cell)
    end
    ListView_1:requestRefreshView()
end

function SmActivityActive:init(params)
    self:onInit()
    return self
end

function SmActivityActive:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_active.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_activity_active_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_yjlq"), nil, 
    {
        terminal_name = "sm_activity_active_window_get_all_reward",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help"), nil, 
    {
        terminal_name = "sm_activity_active_help_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)
    
    
    self:onUpdateDraw()
    self:updateTotalRewardInfo()
end

function SmActivityActive:onExit()
    state_machine.remove("sm_activity_active_window_update")
    state_machine.remove("sm_activity_active_window_get_all_reward")
    state_machine.remove("sm_activity_active_window_update_reward_info")
end