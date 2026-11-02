-- ----------------------------------------------------------------------------------------------------
-- 说明：敌军来袭-掉血动画
-- ----------------------------------------------------------------------------------------------------
EnemyStrikeBlood = class("EnemyStrikeBloodClass", Window)

local enemy_strike_blood_create_terminal = {
    _name = "enemy_strike_blood_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return EnemyStrikeBlood:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}

local enemy_strike_blood_delete_terminal = {
    _name = "enemy_strike_blood_delete",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(enemy_strike_blood_create_terminal)
state_machine.add(enemy_strike_blood_delete_terminal)
state_machine.init()

function EnemyStrikeBlood:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end

function EnemyStrikeBlood:init(params)
    local hurt = params[1]
    local parent = params[2]
    local csbItem = csb.createNode(config_csb.campaign.enemy_strike_blood_minus)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.campaign.enemy_strike_blood_minus)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        if frame == "minus_blood_ing_over" then
            self:removeFromParnet(true)
        end
    end)
    action:play("minus_blood_ing", false)

    local BitmapFontLabel_blood = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_blood")
    BitmapFontLabel_blood:setString("-"..hurt)

    parent:addChild(self)
    self:setPosition(cc.p(math.random(-20, 20), math.random(-20, 20)))
    return self
end

function EnemyStrikeBlood:onEnterTransitionFinish()

end

function EnemyStrikeBlood:onExit()

end
