-- ------------------------------------------------------------------------------------------------------------
--  说明：军团活跃帮助信息
-- ------------------------------------------------------------------------------------------------------------
LegionActiveHelp = class("LegionActiveHelpClass", Window)

--打开界面
local legion_active_help_window_open_terminal = {
    _name = "legion_active_help_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionActiveHelpClass") == nil then
            local _win = LegionActiveHelp:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_active_help_window_close_terminal = {
    _name = "legion_active_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionActiveHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_active_help_window_open_terminal)
state_machine.add(legion_active_help_window_close_terminal)
state_machine.init()

function LegionActiveHelp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
     -- Initialize alert_home state machine.
    local function init_legion_active_help_terminal()

    end
    -- call func alert_home create state machine.
    init_legion_active_help_terminal()
end

-- 显示信息
function LegionActiveHelp:onUpdateDraw()
    local root = self.roots[1]

end

--初始化界面
function LegionActiveHelp:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_active_help)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop_help_close"), nil, 
    {
        terminal_name = "legion_active_help_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_active_help_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function LegionActiveHelp:init()
    self:onInit()
end

--移除状态机
function LegionActiveHelp:onExit()

end