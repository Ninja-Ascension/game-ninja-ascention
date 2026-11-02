-- ------------------------------------------------------------------------------------------------------------
--  说明：紧急任务
-- ------------------------------------------------------------------------------------------------------------
TaskUrgent = class("TaskUrgentClass", Window)

--打开界面
local task_urgent_open_terminal = {
    _name = "task_urgent_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("TaskUrgentClass") == nil then
            fwin:open(TaskUrgent:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local task_urgent_close_terminal = {
    _name = "task_urgent_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TaskUrgentClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(task_urgent_open_terminal)
state_machine.add(task_urgent_close_terminal)
state_machine.init()

function TaskUrgent:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._taskInfo = nil

    local function init_task_urgent_terminal()
        local task_urgent_goto_terminal = {
            _name = "task_urgent_goto",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local achievement_mould_id = instance._taskInfo.achieve_mould_id
                local achievement_short_id = dms.int(dms["achievement_mould"],achievement_mould_id,achievement_mould.achievement_short_id)
                if achievement_short_id > 0 then
                    state_machine.excute("short_cut_go_to_other_window",0,{achievement_short_id})
                end
                state_machine.excute("task_urgent_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_urgent_get_reward_terminal = {
            _name = "task_urgent_get_reward",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local task_id = instance._taskInfo.task_id
                local task_mould_id = instance._taskInfo.task_mould_id
                _ED.last_user_level = _ED.user_info.user_grade
                _ED.last_prestige_level = _ED.user_info.credit_level
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        checkRewardObtainDraw()
                        checkEffectLevelUp()
                        state_machine.excute("task_main_line_list_update_listview", 0, "")
                        -- state_machine.excute("task_daily_list_update_listview", 0, nil)
                        state_machine.excute("task_urgent_close", 0, nil)
                    end
                end
                protocol_command.get_task_reward.param_list = task_id .. "\r\n" .. task_mould_id
                NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(task_urgent_goto_terminal)
        state_machine.add(task_urgent_get_reward_terminal)
        state_machine.init()
    end
    init_task_urgent_terminal()
end

function TaskUrgent:onUpdateDraw()
    local root = self.roots[1]
    local Text_task_urgent_name = ccui.Helper:seekWidgetByName(root, "Text_task_urgent_name")
    local Text_task_urgent_infor = ccui.Helper:seekWidgetByName(root, "Text_task_urgent_infor")
    local Text_task_urgent_progress_n = ccui.Helper:seekWidgetByName(root, "Text_task_urgent_progress_n")
    local Panel_task_urgent_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_task_urgent_reward_icon")
    -- local Button_task_daily_receive = ccui.Helper:seekWidgetByName(root, "Button_task_daily_receive")
    -- local Button_task_go = ccui.Helper:seekWidgetByName(root, "Button_task_go")
    -- Button_task_daily_receive:setVisible(false)
    -- Button_task_go:setVisible(false)
    local achieve_mould_id = self._taskInfo.achieve_mould_id
    local achieve_data = dms.element(dms["achievement_mould"], achieve_mould_id)
    local achievement_name = dms.atos(achieve_data, achievement_mould.achievement_name)
    local achievement_dec = dms.atos(achieve_data, achievement_mould.achievement_dec)
    Text_task_urgent_name:setString(achievement_name)
    Text_task_urgent_infor:setString(achievement_dec)
    if tonumber(self._taskInfo.task_complete_count) >= tonumber(self._taskInfo.need_complete_count) then
        Text_task_urgent_progress_n:setString(tipString_task_info[4])
        Text_task_urgent_progress_n:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
        -- Button_task_daily_receive:setVisible(true)
        -- if tonumber(self._taskInfo.task_state) == 2 then
        --     Button_task_daily_receive:setTitleText(tipString_task_info[6])
        --     Button_task_daily_receive:setBright(false)
        --     Button_task_daily_receive:setTouchEnabled(false)
        -- end
    else
        Text_task_urgent_progress_n:setString(tipString_task_info[5])
        Text_task_urgent_progress_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        -- Button_task_go:setVisible(true)
    end

    Panel_task_urgent_reward_icon:removeAllChildren(true)
    local achievement_reward = zstring.split(dms.atos(achieve_data, achievement_mould.achievement_reward), "|")
    if achievement_reward ~= nil and #achievement_reward > 0 then
        local temp_tab = zstring.split(achievement_reward[1], ",")
        local reward_data = {
            item_value = temp_tab[3],
            prop_type = temp_tab[2],
            prop_item = temp_tab[1],
        }
        local cell = nil
        if tonumber(reward_data.prop_type) == 6 then    
            cell = state_machine.excute("props_icon_create_cell",0,{6,1,reward_data.prop_item,1,reward_data.item_value})
        elseif tonumber(reward_data.prop_type) == 13 then    
            cell = state_machine.excute("props_icon_create_cell",0,{6,9,reward_data.prop_item,3,reward_data.item_value})
        elseif tonumber(reward_data.prop_item) <= 0 then    
            local prop_item = resource_prop_id[tonumber(reward_data.prop_type)]
            cell = state_machine.excute("props_icon_create_cell",0,{6,1,prop_item,1,reward_data.item_value})
        end
        Panel_task_urgent_reward_icon:addChild(cell)
    end
end

function TaskUrgent:onInit()
    local csbItem = csb.createNode(config_csb.task.task_urgent_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "task_urgent_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_urgent_close"), nil, 
    {
        terminal_name = "task_urgent_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_daily_receive"), nil, 
    {
        terminal_name = "task_urgent_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_urgent_go"), nil, 
    {
        terminal_name = "task_urgent_goto", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:onUpdateDraw()
end

function TaskUrgent:init(params)
    self._taskInfo = params[1]
    self:onInit(index)
    return self
end

function TaskUrgent:onExit()   
    state_machine.remove("task_urgent_get_reward")
    state_machine.remove("task_urgent_goto")
end
