--------------------------------------------------------------------------------------------------------------
--  说明：帮助
--------------------------------------------------------------------------------------------------------------
HelpWindow = class("HelpWindowClass", Window)

--打开界面
local help_window_open_terminal = {
    _name = "help_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("HelpWindowClass") == nil then
            fwin:open(HelpWindow:new():init(), fwin._display_log)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local help_window_close_terminal = {
    _name = "help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HelpWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(help_window_open_terminal)
state_machine.add(help_window_close_terminal)
state_machine.init()

function HelpWindow:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.red_alert_time.utils.HelpPrompt")

    local function init_help_window_terminal()
        local help_window_click_button_terminal = {
            _name = "help_window_click_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("help_prompt_open", 0, params._datas.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local help_window_change_state_terminal = {
            _name = "help_window_change_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(help_window_click_button_terminal)
        state_machine.add(help_window_change_state_terminal)
        state_machine.init()
    end
    init_help_window_terminal()
end

--初始化
function HelpWindow:onInit()
    local csbItem = csb.createNode(config_csb.help.help)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Text_help_close"), nil, 
    {
        terminal_name = "help_window_close",
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Text_help_back"), nil, 
    {
        terminal_name = "help_window_close",
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    for i=1,11 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help_"..i), nil, 
        {
            terminal_name = "help_window_click_button",
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
        }, nil, 1)
    end
end

function HelpWindow:onEnterTransitionFinish()

end

function HelpWindow:init()
    self:onInit()
    return self
end

function HelpWindow:onExit()
    state_machine.remove("help_window_click_button")
    state_machine.remove("help_window_change_state")
end