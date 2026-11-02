-- ------------------------------------------------------------------------------------------------------------
--  说明：军团切磋帮助信息
-- ------------------------------------------------------------------------------------------------------------
LegionMemberVsHelp = class("LegionMemberVsHelpClass", Window)

--打开界面
local legion_member_vs_help_window_open_terminal = {
    _name = "legion_member_vs_help_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionMemberVsHelpClass") == nil then
            local _win = LegionMemberVsHelp:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_member_vs_help_window_close_terminal = {
    _name = "legion_member_vs_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionMemberVsHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_member_vs_help_window_open_terminal)
state_machine.add(legion_member_vs_help_window_close_terminal)
state_machine.init()

function LegionMemberVsHelp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
     -- Initialize alert_home state machine.
    local function init_legion_member_vs_help_terminal()

    end
    -- call func alert_home create state machine.
    init_legion_member_vs_help_terminal()
end

-- 显示信息
function LegionMemberVsHelp:onUpdateDraw()
    local root = self.roots[1]

end

--初始化界面
function LegionMemberVsHelp:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_member_vs_help)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_member_vs_close"), nil, 
    {
        terminal_name = "legion_member_vs_help_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_member_vs_help_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function LegionMemberVsHelp:init()
    self:onInit()
end

--移除状态机
function LegionMemberVsHelp:onExit()

end