-----------------------------
--英雄属性详细界面
-----------------------------
OtherPlayersHeroAttributes = class("OtherPlayersHeroAttributesClass", Window)

local other_players_hero_attributes_window_open_terminal = {
    _name = "other_players_hero_attributes_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("OtherPlayersHeroAttributesClass")
        if nil == _Window then
            fwin:open(OtherPlayersHeroAttributes:new():init(),fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local other_players_hero_attributes_window_close_terminal = {
    _name = "other_players_hero_attributes_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("OtherPlayersHeroAttributesClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_hero_attributes_window_open_terminal)
state_machine.add(other_players_hero_attributes_window_close_terminal)
state_machine.init()

function OtherPlayersHeroAttributes:ctor()
    self.super:ctor()
    self.roots = {}
end


function OtherPlayersHeroAttributes:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_attributes)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_attributes_response"), nil, 
    {
        terminal_name = "other_players_hero_attributes_window_close", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 0)
end

function OtherPlayersHeroAttributes:init()
    self:onInit()
    return self
end

function OtherPlayersHeroAttributes:onExit()

end
