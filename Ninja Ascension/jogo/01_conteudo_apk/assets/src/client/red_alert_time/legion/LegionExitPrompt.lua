-----------------------------
-- 军团退出
-----------------------------
LegionExitPrompt = class("LegionExitPromptClass", Window)

--打开界面
local legion_exit_prompt_window_open_terminal = {
    _name = "legion_exit_prompt_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LegionExitPromptClass") == nil then
            fwin:open(LegionExitPrompt:new():init(params), fwin._ui)     
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_exit_prompt_window_close_terminal = {
    _name = "legion_exit_prompt_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionExitPromptClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_exit_prompt_window_open_terminal)
state_machine.add(legion_exit_prompt_window_close_terminal)
state_machine.init()

function LegionExitPrompt:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._id = 0

    local function init_legion_exit_prompt_terminal()
        local legion_exit_prompt_exit_terminal = {
            _name = "legion_exit_prompt_exit",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("legion_exit_prompt_window_close", 0, nil)
                        state_machine.excute("legion_manage_window_close", 0, nil)
                        state_machine.excute("legion_clean_all_data", 0, nil)
                        state_machine.excute("legion_window_open", 0, "")
                    end
                end
                protocol_command.union_appoint.param_list = _ED.union.union_info.union_id.."\r\n"..instance._id.."\r\n5"
                NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_exit_prompt_exit_terminal)
        state_machine.init()
    end
    init_legion_exit_prompt_terminal()
end

function LegionExitPrompt:init(params)
    self._id = params[1]
    self:onInit()
    return self
end

function LegionExitPrompt:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_sign_out_prompt)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "legion_exit_prompt_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_sign_out_close"), nil, 
    {
        terminal_name = "legion_exit_prompt_window_close",     
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_sign_out"), nil, 
    {
        terminal_name = "legion_exit_prompt_exit",      
        but_image = "",     
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
end

function LegionExitPrompt:onEnterTransitionFinish()
    
end

function LegionExitPrompt:onExit()
    state_machine.remove("legion_exit_prompt_exit")
end

