local Role = class("RoleClass", Window)


function Role:ctor()
    self.super:ctor()
    self.roots = {}

    self._show_name = false
    self._show_sp = false
    self._show_hp = false

    self._actionTimeSpeed = 1.0

    -- Initialize role page state machine.
    local function init_role_terminal()
        -- 英雄入场
        local role_into_terminal = {
            _name = "role_into",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(role_into_terminal)
        state_machine.init()
    end

    -- call func init fight state machine.
    init_role_terminal()
end

function Role:init()
    return self
end

function Role:onEnterTransitionFinish()
   local _parent = self:getParent()
end

function Role:onExit()
end
