-- ------------------------------------------------------------------------------------------------------------
--  说明：军团协防介绍
-- ------------------------------------------------------------------------------------------------------------
LegionSetAttackHelpInfor = class("LegionSetAttackHelpInforClass", Window)

--打开界面
local legion_set_attack_help_infor_window_open_terminal = {
    _name = "legion_set_attack_help_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionSetAttackHelpInforClass") == nil then
            local _win = LegionSetAttackHelpInfor:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_set_attack_help_infor_window_close_terminal = {
    _name = "legion_set_attack_help_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionSetAttackHelpInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_set_attack_help_infor_window_open_terminal)
state_machine.add(legion_set_attack_help_infor_window_close_terminal)
state_machine.init()

function LegionSetAttackHelpInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
     -- Initialize alert_home state machine.
    local function init_legion_set_attack_help_infor_terminal()

    end
    -- call func alert_home create state machine.
    init_legion_set_attack_help_infor_terminal()
end

-- 显示信息
function LegionSetAttackHelpInfor:onUpdateDraw()
    local root = self.roots[1]

end

--初始化界面
function LegionSetAttackHelpInfor:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_set_attack_help_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_infor_close"), nil, 
    {
        terminal_name = "legion_set_attack_help_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_set_attack_help_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function LegionSetAttackHelpInfor:init()
    self:onInit()
end

--移除状态机
function LegionSetAttackHelpInfor:onExit()

end