-- ----------------------------------------------------------------------------------------------------
-- 说明：阵营战坐标指示动画
-- ----------------------------------------------------------------------------------------------------
CampPkBattleAct = class("CampPkBattleActClass", Window)

local camp_pk_battle_act_create_terminal = {
    _name = "camp_pk_battle_act_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return fwin:open(CampPkBattleAct:new():init(params))
    end,
    _terminal = nil,
    _terminals = nil
}

local camp_pk_battle_act_delete_terminal = {
    _name = "camp_pk_battle_act_delete",
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

state_machine.add(camp_pk_battle_act_create_terminal)
state_machine.add(camp_pk_battle_act_delete_terminal)
state_machine.init()

function CampPkBattleAct:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
end

function CampPkBattleAct:updateInfo( time )
    local root = self.roots[1]
    local Text_camp_pk_tank_act_time = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_tank_act_time")
    if time <= 0 then
        Text_camp_pk_tank_act_time:setString("")
    else
        Text_camp_pk_tank_act_time:setString(exChangeNumTimeString(time, 1))
    end
end

function CampPkBattleAct:init(params)
    self._rootWindows = params[1]

    local csbItem = csb.createNode(config_csb.cells.campaign.camp_pk_battle_act_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:setContentSize(root:getContentSize())

    local action = csb.createTimeline(config_csb.cells.campaign.camp_pk_battle_act_cell)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
    end)
    action:play("camp_pk_battle_act", true)

    return self
end

function CampPkBattleAct:onEnterTransitionFinish()

end

function CampPkBattleAct:onExit()

end
