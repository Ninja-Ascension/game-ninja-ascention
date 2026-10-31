-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗掉落
-- ----------------------------------------------------------------------------------------------------
BattleDrop = class("BattleDropClass", Window)

-- 新建战斗掉落对象
local battle_drop_create_terminal = {
    _name = "battle_drop_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return BattleDrop:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}

-- 删除战斗掉落对象
local battle_drop_delete_terminal = {
    _name = "battle_drop_delete",
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

state_machine.add(battle_drop_create_terminal)
state_machine.add(battle_drop_delete_terminal)
state_machine.init()

function BattleDrop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua file

    -- var
end

function BattleDrop:init(params)
    local parent = params.parent
    local zorder = params.zorder
    local dropItem = params.dropItem

    local pos = params.pos

    local csbItem = csb.createNode(config_csb.battle.battle_get_gold)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.battle.battle_get_gold)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        if frame == "battle_gold_anim_over" then
            self:removeFromParnet(true)
        end
    end)
    action:play("battle_gold_anim", false)

    local AtlasLabel_get_gold = ccui.Helper:seekWidgetByName(root, "AtlasLabel_get_gold")
    AtlasLabel_get_gold:setString(dropItem.item_count)

    parent:addChild(self, zorder)
    self:setPosition(pos)
    return self
end

function BattleDrop:onEnterTransitionFinish()

end

function BattleDrop:close()

end

function BattleDrop:destroy()

end


-- ----------------------------------------------------------------------------------------------------