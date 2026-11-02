-- ----------------------------------------------------------------------------------------------------
-- 国战任务界面
-- ----------------------------------------------------------------------------------------------------
NationalTask = class("NationalTaskClass", Window)

-- 打开窗口
local national_task_window_open_terminal = {
    _name = "national_task_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalTaskWindow = fwin:find("NationalTaskClass")
        if nil == nationalTaskWindow then
            local function responseNationalTaskCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(NationalTask:new():init(params), fwin._view)
                end
            end
            protocol_command.get_warfare_task.param_list = ""
            NetworkManager:register(protocol_command.get_warfare_task.code, nil, nil, nil, nil, responseNationalTaskCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local national_task_window_close_terminal = {
    _name = "national_task_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalTaskClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_task_window_open_terminal)
state_machine.add(national_task_window_close_terminal)
state_machine.init()

function NationalTask:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    --load state machine file
    app.load("client.red_alert.campaign.nationalwar.NationalTaskListNational")
    app.load("client.red_alert.campaign.nationalwar.NationalTaskListPersonal")

    -- Initialize national task state machine.
    local function init_national_task_terminal()

        --管理
        local national_task_manager_terminal = {
            _name = "national_task_manager",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    -- excute params._datas.next_terminal_name
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end 
                -- set select ui button is highlighted
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                else
                    terminal.select_button = params
                end

                if terminal.select_button.setHighlighted == nil and params._datas.current_button_name ~= nil then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 国战任务列表切换（国家）
        local national_task_change_to_national_terminal = {
            _name = "national_task_change_to_national",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_national_truce_task = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_task")
                state_machine.excute("national_task_list_national_window_open",0,params._datas)
                state_machine.excute("national_task_list_personal_window_hide",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 国战任务列表切换（个人）
        local national_task_change_to_personal_terminal = {
            _name = "national_task_change_to_personal",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_national_truce_task = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_task")
                state_machine.excute("national_task_list_personal_window_open",0,params._datas)
                state_machine.excute("national_task_list_national_window_hide",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_task_manager_terminal)
        state_machine.add(national_task_change_to_national_terminal)
        state_machine.add(national_task_change_to_personal_terminal)
        state_machine.init()     
    end

    -- call func init national task state machine.
    init_national_task_terminal()
end

function NationalTask:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_task)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    if (Panel_camp_bg ~= nil) then
        Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    end

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_truce_task_back"), nil, 
    {
        terminal_name = "national_task_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --国家按钮
    local Button_national_truce_task_country = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_truce_task_country"), nil, 
    {
        terminal_name = "national_task_manager",     
        next_terminal_name = "national_task_change_to_national", 
        current_button_name = "Button_national_truce_task_country",   
        terminal_state = 0, 
        isPressedActionEnabled = false,
        _rootWindows = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_task")
    }, nil, 3)
    
    --个人按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_truce_task_personal"), nil, 
    {
        terminal_name = "national_task_manager",     
        next_terminal_name = "national_task_change_to_personal", 
        current_button_name = "Button_national_truce_task_personal",   
        terminal_state = 0, 
        isPressedActionEnabled = false,
        _rootWindows = ccui.Helper:seekWidgetByName(root,"Panel_national_truce_task")
    }, nil, 3)

    fwin.touch(Button_national_truce_task_country, ccui.TouchEventType.ended)
end

function NationalTask:init(params)
    self:onInit(params)
    return self
end

function NationalTask:onUpdateDrawDec()
    local root = self.roots[1]

end

function NationalTask:onExit()
    state_machine.remove("national_task_manager")
    state_machine.remove("national_task_change_to_national")
    state_machine.remove("national_task_change_to_personal")
end


