-- ----------------------------------------------------------------------------
-- In the game platform account manager.
-- Add all game platform sdk login state machine.
-- ----------------------------------------------------------------------------
platform_manager = platform_manager or {}
platform_manager._current_account_platform_name = app.account_platform_name

-- All account platform name
local acount_platform_name_jar_world = "jar-world"

-- Excute terminal invoke of account platform manager.
platform_manager.excute = function(params)
    return state_machine.excute(platform_manager._current_platform._name, 0, params)
end

-- --------------------------------------------------------
-- jar-world platfom account login state machine.
-- --------------------------------------------------------
-- If current game acount platform is jar-world,
-- initialize platform_manager table with jar-world state
-- machine. 
local jar_world_platform_manager_init_terminal = {
    _name = "jar_world_platform_manager_init",
    _init = function (terminal)
        if platform_manager._current_account_platform_name == acount_platform_name_jar_world then
            platform_manager._current_platform = terminal
        end
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- Get jar-world platfomr acount list, use login game.
local jar_world_get_platform_account_list_terminal = {
    _name = "jar_world_get_platform_account_list",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- Do it check jar-world platform account can it do login game.
local jar_world_check_account_terminal = {
    _name = "jar_world_check_account",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- Login platform account of jar-world platform account.
local jar_world_login_platform_account_terminal = {
    _name = "jar_world_login_platform_account",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil   
}

-- The game platform account recharge gold.
local jar_world_platform_account_recharge_terminal = {
    _name = "jar_world_platform_account_recharge",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = nil,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil      
}

-- Add state to app state machine manager
state_machine.add(jar_world_platform_manager_init_terminal)
state_machine.add(jar_world_get_platform_account_list_terminal)
state_machine.add(jar_world_check_account_terminal)
state_machine.add(jar_world_login_platform_account_terminal)
state_machine.add(jar_world_platform_account_recharge_terminal)
-- ~end for jar-world platfom account manager state machine.
-- --------------------------------------------------------

-- Initialize all state machine for game platform account manager.
state_machine.init()
-- ~end
-- ----------------------------------------------------------------------------