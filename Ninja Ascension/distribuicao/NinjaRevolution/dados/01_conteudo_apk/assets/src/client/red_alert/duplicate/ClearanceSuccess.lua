-----------------------------
--说明:副本章节通关成功动画
-----------------------------
ClearanceSuccess = class("ClearanceSuccessClass", Window)

--打开界面
local clearance_success_window_open_terminal = {
    _name = "clearance_success_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ClearanceSuccessClass") then
            fwin:open(ClearanceSuccess:new():init(), fwin._border)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local clearance_success_window_close_terminal = {
    _name = "clearance_success_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ClearanceSuccessClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(clearance_success_window_open_terminal)
state_machine.add(clearance_success_window_close_terminal)
state_machine.init()

function ClearanceSuccess:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end
--初始化界面
function ClearanceSuccess:onInit( )
    local csbItem = csb.createNode(config_csb.duplicate.clearance_success)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local Panel_success = ccui.Helper:seekWidgetByName(root, "Panel_success")
    local ArmatureNode_pass = Panel_success:getChildByName("ArmatureNode_pass")
    Panel_success:setVisible(true)
    local animation = ArmatureNode_pass:getAnimation()
    local animationEventCallFunc = function()
        state_machine.excute("clearance_success_window_close",0,"")
        -- state_machine.excute("duplicate_map_check_level_up",0,"")
    end 
    animation:playWithIndex(0, 0, 0)
    animation:setMovementEventCallFunc(animationEventCallFunc)
end

--初始化
function ClearanceSuccess:init()
    self:onInit()
    return self
end

function ClearanceSuccess:destroy()
    
end

function ClearanceSuccess:onExit()
    
end