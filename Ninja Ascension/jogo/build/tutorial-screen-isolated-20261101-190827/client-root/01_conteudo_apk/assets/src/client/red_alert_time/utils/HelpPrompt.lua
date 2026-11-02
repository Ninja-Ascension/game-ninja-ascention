--------------------------------------------------------------------------------------------------------------
--  说明：帮助
--------------------------------------------------------------------------------------------------------------
HelpPrompt = class("HelpPromptClass", Window)

--打开界面
local help_prompt_open_terminal = {
    _name = "help_prompt_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("HelpPromptClass") == nil then
            state_machine.excute("help_window_change_state", 0, false)
            fwin:open(HelpPrompt:new():init(params), fwin._display_log)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local help_prompt_close_terminal = {
    _name = "help_prompt_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("help_window_change_state", 0, true)
        if params._datas.close_state == true then
            state_machine.excute("help_window_close", 0, nil)    
        end
        fwin:close(fwin:find("HelpPromptClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(help_prompt_open_terminal)
state_machine.add(help_prompt_close_terminal)
state_machine.init()

function HelpPrompt:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_help_prompt_terminal()
        
    end
    init_help_prompt_terminal()
end

--初始化
function HelpPrompt:onInit(params)
    local csbItem = csb.createNode(string.format(config_csb.help.help_prompt, params))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Text_help_close"), nil, 
    {
        terminal_name = "help_prompt_close",
        terminal_state = 0, 
        touch_black = true,
        close_state = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Text_help_close_0"), nil, 
    {
        terminal_name = "help_prompt_close",
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
end

function HelpPrompt:onEnterTransitionFinish()

end

function HelpPrompt:init(params)
    self:onInit(params)
    return self
end

function HelpPrompt:onExit()
end