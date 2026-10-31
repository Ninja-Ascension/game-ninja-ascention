-----------------------------
--说明:官职进阶
-----------------------------
TourneyfieldUp = class("TourneyfieldUpClass", Window)

--打开界面
local tourneyfield_up_window_open_terminal = {
    _name = "tourneyfield_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("TourneyfieldUpClass") then
            fwin:open(TourneyfieldUp:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local tourneyfield_up_window_close_terminal = {
    _name = "tourneyfield_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TourneyfieldUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(tourneyfield_up_window_open_terminal)
state_machine.add(tourneyfield_up_window_close_terminal)
state_machine.init()

function TourneyfieldUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end
--初始化界面
function TourneyfieldUp:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.tourneyfield.tourneyfield_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
end

function TourneyfieldUp:onEnterTransitionFinish()
    local root = self.roots[1]
    local Panel_up = ccui.Helper:seekWidgetByName(root,"Panel_up")
    local ArmatureNode_up = Panel_up:getChildByName("ArmatureNode_up")

    local animation = ArmatureNode_up:getAnimation()
    local AnimationEventCallFunc = function()
         state_machine.excute("tourneyfield_up_window_close",0,"")
         -- state_machine.excute("tourneyfield_play_head_effic",0,"")
    end 
    animation:playWithIndex(0, 0, 0)
    animation:setMovementEventCallFunc(AnimationEventCallFunc)
end

--初始化
function TourneyfieldUp:init()
    self:onInit()
    return self
end


function TourneyfieldUp:onExit()

end