--------------------------------------------------------------------------------------------------------------
--  军衔说明
--------------------------------------------------------------------------------------------------------------
PlayerMilitaryHelpInfor = class("PlayerMilitaryHelpInforClass", Window)

--打开界面
local player_military_help_infor_window_open_terminal = {
    _name = "player_military_help_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _wind = PlayerMilitaryHelpInfor:new()
        _wind:init(params)
        fwin:open(_wind, fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local player_military_help_infor_window_close_terminal = {
    _name = "player_military_help_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerMilitaryHelpInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(player_military_help_infor_window_open_terminal)
state_machine.add(player_military_help_infor_window_close_terminal)
state_machine.init()

function PlayerMilitaryHelpInfor:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize player_military_help_infor state machine.
    local function init_player_military_help_infor_terminal()
   
    end
    
    -- call func player_military_help_infor create state machine.
    init_player_military_help_infor_terminal()

end

function PlayerMilitaryHelpInfor:onInit()
    local csbItem = csb.createNode(config_csb.player.player_military_help_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_infor_close"), nil, 
    {
        terminal_name = "player_military_help_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "player_military_help_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)
end

function PlayerMilitaryHelpInfor:onEnterTransitionFinish()
    
end

function PlayerMilitaryHelpInfor:init(params)
    self:onInit()
    return self
end

function PlayerMilitaryHelpInfor:onExit()
   
end