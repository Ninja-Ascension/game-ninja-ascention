-- ------------------------------------------------------------------------------------------------------------
--  说明：军团协防设置
-- ------------------------------------------------------------------------------------------------------------
LegionSetAttackHelp = class("LegionSetAttackHelpClass", Window)

--打开界面
local legion_set_attack_help_window_open_terminal = {
    _name = "legion_set_attack_help_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionSetAttackHelpClass") == nil then
            local _win = LegionSetAttackHelp:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_set_attack_help_window_close_terminal = {
    _name = "legion_set_attack_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionSetAttackHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_set_attack_help_window_open_terminal)
state_machine.add(legion_set_attack_help_window_close_terminal)
state_machine.init()

function LegionSetAttackHelp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._select_index = 0
    self._check_boxs = {}
    
    app.load("client.red_alert_time.legion.LegionSetAttackHelpInfor")

     -- Initialize alert_home state machine.
    local function init_legion_set_attack_help_terminal()
        local legion_set_attack_help_introduce_terminal = {
            _name = "legion_set_attack_help_introduce",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("legion_set_attack_help_window_close", 0, "")
                state_machine.excute("legion_set_attack_help_infor_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_set_attack_help_select_terminal = {
            _name = "legin_set_attack_help_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local select_index = params._datas.index-1
                for k, v in pairs(instance._check_boxs) do
                    v:setSelected(false)
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.world_help_defend_set.param_list = "0".."\r\n"..select_index.."\r\n0"
                NetworkManager:register(protocol_command.world_help_defend_set.code, nil, nil, nil, self, responseCallback, false, nil)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(legion_set_attack_help_introduce_terminal)
        state_machine.add(legion_set_attack_help_select_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_set_attack_help_terminal()
end

-- 显示信息
function LegionSetAttackHelp:onUpdateDraw()
    local root = self.roots[1]
    self._select_index = _ED.legion_world_defense_type+1   
    for k, v in pairs(self._check_boxs) do
        if k == self._select_index then
            v:setSelected(true)
        else
            v:setSelected(false)
        end
    end
end

--初始化界面
function LegionSetAttackHelp:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_set_attack_help)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_infor_close"), nil, 
    {
        terminal_name = "legion_set_attack_help_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_set_attack_help_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack_help_introduce"), nil, 
    {
        terminal_name = "legion_set_attack_help_introduce", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    for i = 1, 3 do
        local CheckBox_attack_help = ccui.Helper:seekWidgetByName(root, "CheckBox_attack_help_"..i)
        fwin:addTouchEventListener(CheckBox_attack_help, nil, 
        {
            terminal_name = "legin_set_attack_help_select", 
            terminal_state = 0, 
            index = i
        }, nil, 1)
        table.insert(self._check_boxs, CheckBox_attack_help)
    end

    self:onUpdateDraw()
end

--初始化
function LegionSetAttackHelp:init()
    self:onInit()
end

--移除状态机
function LegionSetAttackHelp:onExit()
    state_machine.remove("legion_set_attack_help_introduce")
    state_machine.remove("legin_set_attack_help_select")
end