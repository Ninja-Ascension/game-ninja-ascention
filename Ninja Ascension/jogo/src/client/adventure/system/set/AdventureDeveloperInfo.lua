-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏设置
-------------------------------------------------------------------------------------------------------
AdventureDeveloperInfo = class("AdventureDeveloperInfoClass", Window)
    
function AdventureDeveloperInfo:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure developer info state machine.
    local function init_adventure_developer_info_terminal()

        state_machine.init()
    end
    
    -- call func init adventure developer info state machine.
    init_adventure_developer_info_terminal()
end

function AdventureDeveloperInfo:init()

end

function AdventureDeveloperInfo:onEnterTransitionFinish()
    
end

function AdventureDeveloperInfo:onExit()
    
end