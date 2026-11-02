
TargetTask = class("TargetTaskClass", Window)

local target_task_window_open_terminal = {
    _name = "target_task_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local complete = _ED.all_achieve[tonumber(_ED.targetAchieveId)]
        local max = dms.int(dms["achieve"], _ED.targetAchieveId, achieve.param2)
        if tonumber(complete) >= max then
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    app.load("client.reward.DrawRareReward")
                    local getRewardWnd = DrawRareReward:new()
                    getRewardWnd:init(24)
                    fwin:open(getRewardWnd, fwin._ui)
                    state_machine.excute("home_update_target_task_info_state", 0, nil)
                end
            end
            protocol_command.draw_achieve_reward.param_list = _ED.targetAchieveId
            NetworkManager:register(protocol_command.draw_achieve_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
        else
            if nil == fwin:find("TargetTaskClass") then
                fwin:open(TargetTask:new():init(params), fwin._ui)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local target_task_window_close_terminal = {
    _name = "target_task_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TargetTaskClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(target_task_window_open_terminal)
state_machine.add(target_task_window_close_terminal)
state_machine.init()

function TargetTask:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_target_task_terminal()
        local target_task_jump_to_terminal = {
            _name = "target_task_jump_to",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local track_address = dms.string(dms["achieve"], _ED.targetAchieveId, achieve.track_address)
                track_address = zstring.split(zstring.split(track_address, "|")[2], ":")[index]
                local traceFunctionId = tonumber(zstring.split(track_address, ",")[2])
                local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
                if dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
                    if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
                        fwin:cleanViews({fwin._ui, fwin._background, fwin._view, fwin._viewdialog})
                    end
                    state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
                else
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(target_task_jump_to_terminal)    
        state_machine.init()
    end
    init_target_task_terminal()
end

function TargetTask:onUpdateDraw( ... )
    local root = self.roots[1]
    local Text_target_1 = ccui.Helper:seekWidgetByName(root, "Text_target_1")
    local Panel_one = ccui.Helper:seekWidgetByName(root, "Panel_one")
    local complete = _ED.all_achieve[tonumber(_ED.targetAchieveId)]
    local max = dms.int(dms["achieve"], _ED.targetAchieveId, achieve.param2)
    local descript = dms.string(dms["achieve"], _ED.targetAchieveId, achieve.descript)
    local track_address = dms.string(dms["achieve"], _ED.targetAchieveId, achieve.track_address)
    track_address = zstring.split(zstring.split(track_address, "|")[2], ":")
    local reward_value = zstring.splits(dms.string(dms["achieve"], _ED.targetAchieveId, achieve.reward_value), "|", ",")
    Text_target_1:setString(descript.."（"..complete.."/"..max.."）")
    Panel_one:removeBackGroundImage()
    Panel_one:setVisible(false)
    for i=1,4 do
        local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop_"..i)
        local Panel_four = ccui.Helper:seekWidgetByName(root, "Panel_four_"..i)
        Panel_prop:removeAllChildren(true)
        Panel_four:removeBackGroundImage()
        Panel_four:setVisible(false)
        local reward = reward_value[i]
        if reward ~= nil and #reward > 0 then
            local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{reward[1],reward[2],reward[3]},true,true,false,true})
            Panel_prop:addChild(cell)
        end
    end
    if #track_address == 1 then
        Panel_one:setVisible(true)
        track_address = zstring.split(track_address[1], ",")
        Panel_one:setBackGroundImage("images/ui/text/task/mbrw_list_"..track_address[1]..".png")
    else
        for k,v in pairs(track_address) do
            v = zstring.split(v, ",")
            local Panel_four = ccui.Helper:seekWidgetByName(root, "Panel_four_"..k)
            Panel_four:setBackGroundImage("images/ui/text/task/mbrw_list_"..v[1]..".png")
            Panel_four:setVisible(true)
        end
    end
end

function TargetTask:onInit()
    local csbItem = csb.createNode("activity/DailyTasks/target_task.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "target_task_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_one"), nil, 
    {
        terminal_name = "target_task_jump_to", 
        terminal_state = 0, 
        index = 1,
    }, nil, 3)

    for i=1,4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_four_"..i), nil, 
        {
            terminal_name = "target_task_jump_to", 
            terminal_state = 0, 
            index = i,
        }, nil, 3)
    end

    self:onUpdateDraw()
end

function TargetTask:onEnterTransitionFinish()

end

function TargetTask:init()
    self:onInit()
    return self
end

function TargetTask:onExit()
    state_machine.remove("target_task_jump_to")
end