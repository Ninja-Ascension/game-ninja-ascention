-- ------------------------------------------------------------------------------------------------------------
--  说明：充值提示
-- ------------------------------------------------------------------------------------------------------------
RechargeTipWindow = class("RechargeTipWindowClass", Window)

--打开界面
local recharge_tip_window_open_terminal = {
    _name = "recharge_tip_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("RechargeTipWindowClass") == nil then
            local _win = RechargeTipWindow:new():init(params)
            fwin:open(_win,fwin._windows)
        end
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local recharge_tip_window_close_terminal = {
    _name = "recharge_tip_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RechargeTipWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(recharge_tip_window_open_terminal)
state_machine.add(recharge_tip_window_close_terminal)
state_machine.init()

function RechargeTipWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}         

    local function init_recharge_tip_window_terminal()
        local recharge_tip_window_sure_recharge_terminal = {
            _name = "recharge_tip_window_sure_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("recharge_tip_window_close", 0, "")
                state_machine.excute("props_use_window_close", 0, "")
                state_machine.excute("recharge_dialog_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(recharge_tip_window_sure_recharge_terminal)
        state_machine.init()
    end
    init_recharge_tip_window_terminal()
end


function RechargeTipWindow:onUpdateDraw()
    local root = self.roots[1]

end

function RechargeTipWindow:onUpdate()

end

function RechargeTipWindow:onInit()
    local csbItem = csb.createNode(config_csb.utils.prompt_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_3_6"), nil, 
    {
        terminal_name = "recharge_tip_window_sure_recharge",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_prompt_close"), nil, 
    {
        terminal_name = "recharge_tip_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "recharge_tip_window_close",
        terminal_state = 0,
    },
    nil,3)

    self:onUpdateDraw()
end

function RechargeTipWindow:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function RechargeTipWindow:onExit()
    state_machine.remove("recharge_tip_window_sure_recharge")
end