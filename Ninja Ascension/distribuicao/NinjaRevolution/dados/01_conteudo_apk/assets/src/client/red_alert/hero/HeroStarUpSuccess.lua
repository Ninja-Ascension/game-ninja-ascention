-----------------------------
--升星成功
-----------------------------
HeroStarUpSuccess = class("HeroStarUpSuccessClass", Window)

local hero_star_up_success_window_open_terminal = {
    _name = "hero_star_up_success_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroStarUpSuccessClass")
        if nil == _Window then
            local text_table = params[1]
            local talent_pic = params[2]
            local talent_name = params[3]
            fwin:open(HeroStarUpSuccess:new():init(text_table,talent_pic,talent_name),fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_star_up_success_window_close_terminal = {
    _name = "hero_star_up_success_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroStarUpSuccessClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_star_up_success_window_open_terminal)
state_machine.add(hero_star_up_success_window_close_terminal)
state_machine.init()

function HeroStarUpSuccess:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.text_table = nil
    --天赋icon
    self.talent_pic = nil
    --天赋名
    self._talent_name = nil

end

function HeroStarUpSuccess:onUpdateDraw()
    local root = self.roots[1]
    local talent_pic = self.talent_pic
    local talent_name = self._talent_name
    local Panel_star_up_success_icon = ccui.Helper:seekWidgetByName(root,"Panel_star_up_success_icon")    --升星成功上的天赋icon
    Panel_star_up_success_icon:setBackGroundImage("images/ui/talent_icon/talent_icon_".. talent_pic .. ".png")
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")     --升星成功上的天赋名称
    Text_name:setString(talent_name)
end

function HeroStarUpSuccess:onEnterTransitionFinish()

end

function HeroStarUpSuccess:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_star_up_success)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.hero.hero_star_up_success)
    table.insert(self.actions, action)
    action:setTimeSpeed(app.getTimeSpeed())
    action:play("star_up_success", false)
    csbItem:runAction(action)
    local text_table = self.text_table

    local Panel_star_up_success_1 = ccui.Helper:seekWidgetByName(root, "Panel_star_up_success_1")
    local ArmatureNode_open = Panel_star_up_success_1:getChildByName("ArmatureNode_open")
    local animation = ArmatureNode_open:getAnimation()
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        
        local str = frame:getEvent()
        if str == "star_up_success_light" then
            animation:playWithIndex(0, 0, 0)
        end  
        if str == "star_up_success_over" then
            state_machine.excute("hero_star_up_success_window_close",0,"")
            state_machine.excute("hero_main_star_up_show_attributes",0,"")
            state_machine.excute("hero_talant_up_star",0,{7,text_table})
        end  
    end)
    self:onUpdateDraw()
end

function HeroStarUpSuccess:init(text_table,talent_pic,talent_name)
    self.text_table = text_table
    self.talent_pic = talent_pic
    self._talent_name = talent_name
    self:onInit()
    return self
end

function HeroStarUpSuccess:onExit()

end
