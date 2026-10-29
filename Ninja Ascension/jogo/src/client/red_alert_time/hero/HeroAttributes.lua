-----------------------------
--英雄属性详细界面
-----------------------------
HeroAttributes = class("HeroAttributesClass", Window)

local hero_attributes_window_open_terminal = {
    _name = "hero_attributes_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroAttributesClass")
        if nil == _Window then
            fwin:open(HeroAttributes:new():init(),fwin._viewdialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_attributes_window_close_terminal = {
    _name = "hero_attributes_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroAttributesClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_attributes_window_open_terminal)
state_machine.add(hero_attributes_window_close_terminal)
state_machine.init()

function HeroAttributes:ctor()
    self.super:ctor()
    self.roots = {}
end


function HeroAttributes:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_attributes)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_attributes_response"), nil, 
    {
        terminal_name = "hero_attributes_window_close", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 0)
end

function HeroAttributes:init()
    self:onInit()
    return self
end

function HeroAttributes:onExit()

end
