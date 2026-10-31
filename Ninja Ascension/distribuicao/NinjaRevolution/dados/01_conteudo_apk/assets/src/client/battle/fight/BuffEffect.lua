BuffEffect = class("BuffEffectClass", Window)

function BuffEffect:ctor()
    self.super:ctor()
    self.roots = {}
    self.roundCount = 0
    self.effectId = 0

    -- Initialize buff effect page state machine.
    local function init_buff_effect_terminal()
        local buff_effect_clean_terminal = {
            _name = "buff_effect_clean",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local buffEffectObject = params
                buffEffectObject:clean()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local buff_effect_update_terminal = {
            _name = "buff_effect_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local buffEffectObject = params[1]
                local roundCount = zstring.tonumber(params[2])
                buffEffectObject.roundCount = roundCount + 1
                state_machine.excute("buff_effect_clean", 0, buffEffectObject)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(buff_effect_clean_terminal)
        state_machine.add(buff_effect_update_terminal)
        state_machine.init()
    end

    -- call func init buff effect state machine.
    init_buff_effect_terminal()
end

function BuffEffect:init(buffType, effectId, roundCount)
    self.buffType = buffType
    self.roundCount = roundCount
    return self
end

function BuffEffect:clean()
    self.roundCount = self.roundCount - 1
    if self.roundCount <= 0 then
        self:removeFromParent(true)
    end
end

function BuffEffect:onEnterTransitionFinish()
    if self.roundCount > 0 then
        -- draw buff effect

    end
end

function BuffEffect:onExit()

end
