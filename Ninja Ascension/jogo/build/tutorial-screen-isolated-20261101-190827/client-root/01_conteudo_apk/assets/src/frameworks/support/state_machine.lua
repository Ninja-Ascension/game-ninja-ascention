-- ----------------------------------------------------------------------------
-- The sample appliction state machine program.
-- 
-- Version 1.0.0
-- The 2d game state machine system for Develop 2d game jar-world 
-- multi-platform.
-- ----------------------------------------------------------------------------
state_machine = state_machine or { _terminals = {} }
local terminal_base = {_name, _init, _inited, _instance, _state, _invoke, _terminal, _terminals}

function state_machine.change_state(_terminal, _state)
    if _terminal ~= nil then
        _terminal._state = _state
    end
    return true
end

function state_machine.invoke(_terminal)
    if _terminal == nil then
        return nil
    end
    _terminal._invoke(_terminal, _terminal._instance)
end

function state_machine.find(_terminal_name)
    if _terminal_name == nil or _terminal_name == "" then
        app.debug.log("error : ", "The invalid state machine, name '", _terminal_name, "'", " call in state_machine.find(#1) function.")
        return nil
    end
    local result = state_machine._terminals[_terminal_name]
    if result == nil then
        app.debug.log("error : ", "The invalid state machine, name '", _terminal_name, "'", " call in state_machine.find(#2) function.")
    end
    return result
end

function state_machine.excute(_terminal_name, _terminal_state, _params)
    local callTerminal = state_machine.find(_terminal_name)
    if callTerminal ~= nil then
        local current = callTerminal
        
        if current._lock == true then return false end

        state_machine.change_state(current, _terminal_state)
        
        if current == callTerminal 
            and current._terminal ~= nil 
            and current._terminal._state == _terminal_state 
            then
            current = current._terminal
        elseif current._terminals ~= nil then
            for i, v in pairs(current._terminals) do
                if v._state == _terminal_state then
                    current = v
                    break
                end
            end 
        end
        
        if current._lock == true then return false end

        callTerminal._terminal = current
        state_machine.check_init(current)
        return current._invoke(current, current._instance, _params)
    end
end

function state_machine.clean()
    state_machine._terminals = nil
    state_machine = nil
    state_machine = { _terminals = {} }
end

function state_machine.remove(_terminal_name)
    local result = state_machine._terminals[_terminal_name]
    state_machine._terminals[_terminal_name] = nil
    return result
end

function state_machine.add(_terminal)
    if _terminal == nil 
        or _terminal._name == nil
        or _terminal._name == ""
        then
        app.debug.log("error : ", "The invalid state machine, terminal is ", _terminal, "  name '",
            _terminal == nil and "nil" or _terminal._name, "'", " call in state_machine.add(#1) function.")
        return _terminal
    end
    if state_machine._terminals[_terminal._name] ~= nil then
        app.debug.log("error : ", "The same state machine, name '", _terminal._name, "'", " call in state_machine.add(#2) function.")
        -- return _terminal
		_terminal._inited = false
    end
    state_machine._terminals[_terminal._name] = _terminal
    return _terminal
end

function state_machine.lock(_terminal_name, _terminal_state, _params)
    local callTerminal = state_machine.find(_terminal_name)
    if callTerminal ~= nil then
        local current = callTerminal

        state_machine.change_state(current, _terminal_state)
        
        if current == callTerminal 
            and current._terminal ~= nil 
            and current._terminal._state == _terminal_state 
            then
            current = current._terminal
        elseif current._terminals ~= nil then
            for i, v in pairs(current._terminals) do
                if v._state == _terminal_state then
                    current = v
                    break
                end
            end 
        end

        callTerminal._terminal = current
        state_machine.check_init(current)
        return state_machine._lock(current)
    end
end

function state_machine.unlock(_terminal_name, _terminal_state, _params)
    local callTerminal = state_machine.find(_terminal_name)
    if callTerminal ~= nil then
        local current = callTerminal

        state_machine.change_state(current, _terminal_state)
        
        if current == callTerminal 
            and current._terminal ~= nil 
            and current._terminal._state == _terminal_state 
            then
            current = current._terminal
        elseif current._terminals ~= nil then
            for i, v in pairs(current._terminals) do
                if v._state == _terminal_state then
                    current = v
                    break
                end
            end 
        end

        callTerminal._terminal = current
        state_machine.check_init(current)
        return state_machine._unlock(current)
    end
end

function state_machine._lock(_terminal)
    if _terminal == nil 
        or _terminal._name == nil
        or _terminal._name == ""
        then
        app.debug.log("error : ", "The invalid state machine, terminal is ", _terminal, "  name '",
            _terminal == nil and "nil" or _terminal._name, "'", " call in state_machine.lock(#1) function.")
        return _terminal
    end
    if state_machine._terminals[_terminal._name] ~= nil then
        app.debug.log("error : ", "The same state machine, name '", _terminal._name, "'", " call in state_machine.lock(#2) function.")
        -- return _terminal
    end
    _terminal._lock = true
    return _terminal   
end

function state_machine._unlock(_terminal)
    if _terminal == nil 
        or _terminal._name == nil
        or _terminal._name == ""
        then
        app.debug.log("error : ", "The invalid state machine, terminal is ", _terminal, "  name '",
            _terminal == nil and "nil" or _terminal._name, "'", " call in state_machine.unlock(#1) function.")
        return _terminal
    end
    if state_machine._terminals[_terminal._name] ~= nil then
        app.debug.log("error : ", "The same state machine, name '", _terminal._name, "'", " call in state_machine.unlock(#2) function.")
        -- return _terminal
    end
    _terminal._lock = false
    return _terminal   
end

function state_machine.call_init(_terminal)
    if _terminal ~= nil and _terminal._inited ~= true and _terminal._init ~= nil then
        _terminal._inited = true
        _terminal._init(_terminal)
    end
end

function state_machine.check_init(_terminal)
    state_machine.call_init(_terminal)
end

function state_machine.init()
    local terminals = state_machine._terminals
    for i, v in pairs(terminals) do
        state_machine.call_init(v)
    end
end

return state_machine
-- ~end for state machine moudle
-- ----------------------------------------------------------------------------