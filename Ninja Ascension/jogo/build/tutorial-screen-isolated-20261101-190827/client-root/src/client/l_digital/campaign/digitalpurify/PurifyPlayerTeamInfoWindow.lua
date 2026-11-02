-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化玩家队伍信息
-------------------------------------------------------------------------------------------------------
PurifyPlayerTeamInfoWindow = class("PurifyPlayerTeamInfoWindowClass", Window)

local purify_player_team_info_window_open_terminal = {
    _name = "purify_player_team_info_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:open(PurifyPlayerTeamInfoWindow:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local purify_player_team_info_window_close_terminal = {
    _name = "purify_player_team_info_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("PurifyPlayerTeamInfoWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(purify_player_team_info_window_open_terminal)
state_machine.add(purify_player_team_info_window_close_terminal)
state_machine.init()

function PurifyPlayerTeamInfoWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- load luf file

    -- var
    
    -- Initialize purify team page state machine.
    local function init_purify_player_team_info_terminal()

        state_machine.init()
    end
    
    -- call func init purify team state machine.
    init_purify_player_team_info_terminal()
end

function PurifyPlayerTeamInfoWindow:init( params )
    return self
end

function PurifyPlayerTeamInfoWindow:onUpdate(dt)

end

function PurifyPlayerTeamInfoWindow:onUpdateDraw()
    local root = self.roots[1]
end

function PurifyPlayerTeamInfoWindow:onEnterTransitionFinish()
    local csbPurifyPlayerTeamInfoWindow = csb.createNode("campaign/DigitalPurify/digital_purify_change_window.csb")
    self:addChild(csbPurifyPlayerTeamInfoWindow)
    local root = csbPurifyPlayerTeamInfoWindow:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "purify_player_team_info_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)

    self:onUpdateDraw()
end

function PurifyPlayerTeamInfoWindow:onExit()

end
