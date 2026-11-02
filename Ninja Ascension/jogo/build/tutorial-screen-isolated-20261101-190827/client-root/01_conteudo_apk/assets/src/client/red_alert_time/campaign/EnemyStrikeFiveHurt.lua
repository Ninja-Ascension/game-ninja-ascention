-- ----------------------------------------------------------------------------------------------------
-- 说明：敌军来袭-五连击
-- ----------------------------------------------------------------------------------------------------
EnemyStrikeFiveHurt = class("EnemyStrikeFiveHurtClass", Window)

local enemy_strike_five_hurt_create_terminal = {
    _name = "enemy_strike_five_hurt_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FightClass") == nil then
            fwin:open(EnemyStrikeFiveHurt:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local enemy_strike_five_hurt_delete_terminal = {
    _name = "enemy_strike_five_hurt_delete",
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

state_machine.add(enemy_strike_five_hurt_create_terminal)
state_machine.add(enemy_strike_five_hurt_delete_terminal)
state_machine.init()

function EnemyStrikeFiveHurt:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end

function EnemyStrikeFiveHurt:init(params)
    local hurt = params[1]
    local csbItem = csb.createNode(config_csb.campaign.enemy_strike_blood_five)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.campaign.enemy_strike_blood_five)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        if frame == "five_minus_blood_ing_over" then
            self:removeFromParnet(true)
        end
    end)
    action:play("five_minus_blood_ing", false)

    local BitmapFontLabel_blood = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_blood")
    BitmapFontLabel_blood:setString("-"..hurt)

    return self
end

function EnemyStrikeFiveHurt:onEnterTransitionFinish()

end

function EnemyStrikeFiveHurt:onExit()

end
