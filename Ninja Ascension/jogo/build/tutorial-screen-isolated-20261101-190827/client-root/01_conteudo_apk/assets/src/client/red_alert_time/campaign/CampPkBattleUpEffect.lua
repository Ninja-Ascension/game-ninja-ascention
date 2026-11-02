-- ----------------------------------------------------------------------------------------------------
-- 说明：阵营战积分动画
-- ----------------------------------------------------------------------------------------------------
CampPkBattleUpEffect = class("CampPkBattleUpEffectClass", Window)

local camp_pk_battle_up_effect_create_terminal = {
    _name = "camp_pk_battle_up_effect_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FightClass") == nil then
            fwin:open(CampPkBattleUpEffect:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local camp_pk_battle_up_effect_delete_terminal = {
    _name = "camp_pk_battle_up_effect_delete",
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

state_machine.add(camp_pk_battle_up_effect_create_terminal)
state_machine.add(camp_pk_battle_up_effect_delete_terminal)
state_machine.init()

function CampPkBattleUpEffect:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._params = nil
end

function CampPkBattleUpEffect:init(params)
    self._rootWindows = params[1]
    self._params = params[2]
    self:onInit()

    return self
end

function CampPkBattleUpEffect:onInit()
    local csbItem = csb.createNode(config_csb.cells.campaign.camp_pk_battle_up_p_effice)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local ArmatureNode_battle_up_effice = root:getChildByName("ArmatureNode_battle_up_effice")
    ArmatureNode_battle_up_effice:setVisible(false)

    local action = csb.createTimeline(config_csb.cells.campaign.camp_pk_battle_up_p_effice)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        if frame:getEvent() == "pk_battle_up_p_effice" then
            ArmatureNode_battle_up_effice:setVisible(true)
            draw.initArmature(ArmatureNode_battle_up_effice, nil, -1, 0, 1)
            ArmatureNode_battle_up_effice._invoke = function(armatureBack)
                fwin:close(self)
            end
            ArmatureNode_battle_up_effice:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        end
    end)
    action:play("pk_battle_up_p_effice", false)

    local Text_battle_up_n = ccui.Helper:seekWidgetByName(root, "Text_battle_up_n")
    Text_battle_up_n:setString("")
    Text_battle_up_n:removeAllChildren(true)

    local add_con = self._params[1]
    local add_score = self._params[2]
    local info = ""
    if zstring.tonumber(add_con) <= 0 and zstring.tonumber(add_score) <= 0 then
        info = red_alert_campaign_pk_str[11]
        Text_battle_up_n:setString(info)
    else
        local _richText = ccui.RichText:create()
        -- local width = Text_battle_up_n:getContentSize().width
        local width = 300
        _richText:ignoreContentAdaptWithSize(false)       
        _richText:setContentSize(cc.size(width,20))

        -- 功勋
        if zstring.tonumber(add_con) > 0 then
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_campaign_pk_str[2], "fonts/simhei.ttf",20)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, "+"..add_con, "fonts/simhei.ttf",20)
            _richText:pushBackElement(re2)
        end
        -- 阵营
        if zstring.tonumber(add_score) > 0 then
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_campaign_pk_str[3], "fonts/simhei.ttf",20)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, "+"..add_score, "fonts/simhei.ttf",20)
            _richText:pushBackElement(re2)
        end
        _richText:formatTextExt()
        local posX = width - (width / 2 - Text_battle_up_n:getPositionX())
        _richText:setPosition(cc.p(posX, Text_battle_up_n:getContentSize().height))
        Text_battle_up_n:addChild(_richText)
    end
end

function CampPkBattleUpEffect:onEnterTransitionFinish()

end

function CampPkBattleUpEffect:onExit()

end
