-----------------------------
--传承成功动画
-----------------------------
InheritGet = class("InheritGetClass", Window)

local inherit_get_window_open_terminal = {
    _name = "inherit_get_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("InheritGetClass")
        if nil == _Window then
            fwin:open(InheritGet:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local inherit_get_window_close_terminal = {
    _name = "inherit_get_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("InheritGetClass")) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(inherit_get_window_open_terminal)
state_machine.add(inherit_get_window_close_terminal)
state_machine.init()

function InheritGet:ctor()
    self.super:ctor()
    self.roots = {}
end

function InheritGet:onUpdateDraw(params)
    local root = self.roots[1]
    local Panel_hero = ccui.Helper:seekWidgetByName(root, "Panel_hero")
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    Panel_hero:removeAllChildren(true)
    Text_name:setString("")
    if params ~= nil and tonumber(params) > 0 then
        Text_name:setString(dms.string(dms["ship_mould"], params, ship_mould.captain_name))
        local quality = dms.int(dms["ship_mould"], params, ship_mould.ship_type)
        Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        app.load("client.battle.fight.FightEnum")
        local temp_bust_index = dms.int(dms["ship_mould"], params, ship_mould.bust_index)
        temp_bust_index = 10000 + temp_bust_index
        local armature = sp.spine_sprite(Panel_hero, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
        armature:setPosition(cc.p(Panel_hero:getContentSize().width/2, 0))
    end
end

function InheritGet:onInit( params )
    local csbItem = csb.createNode(config_csb.forging.inherit_get)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.forging.inherit_get)
    csbItem:runAction(action)
    action:play("window_open", false)

    local Panel_reward_obtain = ccui.Helper:seekWidgetByName(root,"Panel_reward_obtain")
    local ArmatureNode_open = Panel_reward_obtain:getChildByName("ArmatureNode_open")
    draw.initArmature(ArmatureNode_open, nil, -1, 0, 1)
    csb.animationChangeToAction(ArmatureNode_open, 0, 0, false)
    ArmatureNode_open._invoke = function(armatureBack)
        armatureBack:setVisible(false)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_obtain_receive"), nil, 
    {
        terminal_name = "inherit_get_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw(params) 
end

function InheritGet:init(params) 
    self:onInit(params)
    return self
end

function InheritGet:onExit()
end
