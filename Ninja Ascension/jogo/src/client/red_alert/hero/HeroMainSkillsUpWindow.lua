-- ---------------------------
-- 查看英雄武学界面
-- ---------------------------
HeroMainSkillsUpWindow = class("HeroMainSkillsUpWindowClass", Window)

local hero_main_skills_up_window_window_open_terminal = {
    _name = "hero_main_skills_up_window_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroMainSkillsUpWindowClass")
        if nil == _Window then
            fwin:open(HeroMainSkillsUpWindow:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_main_skills_up_window_window_close_terminal = {
    _name = "hero_main_skills_up_window_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroMainSkillsUpWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_skills_up_window_window_open_terminal)
state_machine.add(hero_main_skills_up_window_window_close_terminal)
state_machine.init()

function HeroMainSkillsUpWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- var
    self.ship = nil

    -- Initialize hero_main_grow_up state machine.
    local function init_hero_main_skills_up_terminal()
        
    end
    
    -- call func init hom state machine.
    init_hero_main_skills_up_terminal()
end

function HeroMainSkillsUpWindow:onHide( ... )
    self:setVisible(false)
end

function HeroMainSkillsUpWindow:onShow( ... )
    self:setVisible(true)
end

function HeroMainSkillsUpWindow:onUpdateDraw()
    local root = self.roots[1]
    local Panel_skill_up = ccui.Helper:seekWidgetByName(root,"Panel_skill_up")
    Panel_skill_up._update_view_size = true
    state_machine.excute("hero_main_skills_up_window_open",0,{Panel_skill_up,self.ship})
end

function HeroMainSkillsUpWindow:onUpdate(dt) 

end

function HeroMainSkillsUpWindow:onEnterTransitionFinish()

end

function HeroMainSkillsUpWindow:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_skills_up_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_skill_up_window_close"), nil, 
    {
        terminal_name = "hero_main_skills_up_window_window_close", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:onUpdateDraw() 
end

function HeroMainSkillsUpWindow:init(params)
    self.ship = params[1]
    self:onInit()
    return self
end

function HeroMainSkillsUpWindow:onExit()

end
