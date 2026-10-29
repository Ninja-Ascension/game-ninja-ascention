-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化界面
-------------------------------------------------------------------------------------------------------
PurifyHelpWindow = class("PurifyHelpWindowClass", Window)

local purify_help_window_open_terminal = {
    _name = "purify_help_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:open(PurifyHelpWindow:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local purify_help_window_close_terminal = {
    _name = "purify_help_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("PurifyHelpWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(purify_help_window_open_terminal)
state_machine.add(purify_help_window_close_terminal)
state_machine.init()

function PurifyHelpWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- load luf file

    -- var
    
    -- Initialize purify team page state machine.
    local function init_purify_help_terminal()

        state_machine.init()
    end
    
    -- call func init purify team state machine.
    init_purify_help_terminal()
end

function PurifyHelpWindow:init( params )
    return self
end

function PurifyHelpWindow:onUpdate(dt)

end

function PurifyHelpWindow:onUpdateDraw()
    local root = self.roots[1]
end

function PurifyHelpWindow:onEnterTransitionFinish()
    local csbPurifyHelpWindow = csb.createNode("campaign/DigitalPurify/digital_purify_rule.csb")
    self:addChild(csbPurifyHelpWindow)
    local root = csbPurifyHelpWindow:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "purify_help_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)

    self:onUpdateDraw()
end

function PurifyHelpWindow:onExit()

end
