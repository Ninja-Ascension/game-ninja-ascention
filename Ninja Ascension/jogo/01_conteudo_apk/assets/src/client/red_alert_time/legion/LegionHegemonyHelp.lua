-- ------------------------------------------------------------------------------------------------------------
--  说明：军团争霸帮助信息
-- ------------------------------------------------------------------------------------------------------------
LegionHegemonyHelp = class("LegionHegemonyHelpClass", Window)

--打开界面
local legion_hegemony_help_window_open_terminal = {
    _name = "legion_hegemony_help_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionHegemonyHelpClass") == nil then
            local _win = LegionHegemonyHelp:new()
            infor_type = params._datas.infor_type
            _win:init(infor_type)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_hegemony_help_window_close_terminal = {
    _name = "legion_hegemony_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionHegemonyHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_hegemony_help_window_open_terminal)
state_machine.add(legion_hegemony_help_window_close_terminal)
state_machine.init()

function LegionHegemonyHelp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
     -- Initialize alert_home state machine.
    local function init_legion_hegemony_help_terminal()

    end
    -- call func alert_home create state machine.
    init_legion_hegemony_help_terminal()
end

-- 显示信息
function LegionHegemonyHelp:onUpdateDraw()
    local root = self.roots[1]

end

--初始化界面
function LegionHegemonyHelp:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_hegemony_help, self._infor_type))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_help_close"), nil, 
    {
        terminal_name = "legion_hegemony_help_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_hegemony_help_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function LegionHegemonyHelp:init(infor_type)
    self._infor_type = infor_type
    self:onInit()
end

--移除状态机
function LegionHegemonyHelp:onExit()

end