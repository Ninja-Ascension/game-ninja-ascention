-----------------------------
--传承
-----------------------------
Inherit = class("InheritClass", Window)

local inherit_window_open_terminal = {
    _name = "inherit_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(36) == true then
            return
        end 
        local _Window = fwin:find("InheritClass")
        if nil == _Window then
            fwin:open(Inherit:new():init(), fwin._ui)
        end
        state_machine.excute("home_select_action_window_close",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local inherit_window_close_terminal = {
    _name = "inherit_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("InheritClass")) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(inherit_window_open_terminal)
state_machine.add(inherit_window_close_terminal)
state_machine.init()

function Inherit:ctor()
    self.super:ctor()
    self.roots = {}

    self._left_ship = nil
    self._right_ship = nil
    app.load("client.red_alert.cells.hero.hero_icon_cell")
    app.load("client.red_alert.forging.InheritLeftPack")
    app.load("client.red_alert.forging.InheritRightPack")
    app.load("client.red_alert.forging.InheritGet")
    app.load("client.red_alert.forging.InheritRule")

    local function init_inherit_terminal()
        local inherit_sure_inherit_terminal = {
            _name = "inherit_sure_inherit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            local ship_id = response.node._right_ship 
                            response.node._left_ship = nil
                            response.node._right_ship = nil
                            response.node:playSuccessAni(ship_id)
                        else
                            state_machine.unlock("inherit_sure_inherit")    
                        end
                    else
                        state_machine.unlock("inherit_sure_inherit")
                    end
                end
                if instance._left_ship == nil then
                    TipDlg.drawTextDailog(red_alert_all_str[256])
                    return
                end
                if zstring.tonumber(instance._right_ship) <= 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[257])
                    return
                end
                state_machine.lock("inherit_sure_inherit")
                protocol_command.ship_inheritance.param_list = instance._left_ship.ship_id.."\r\n"..instance._right_ship
                NetworkManager:register(protocol_command.ship_inheritance.code, nil, nil, nil, instance, responseCallback, false, nil)                   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local inherit_choose_left_terminal = {
            _name = "inherit_choose_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= "" and params ~= nil then
                    instance._left_ship = params 
                end
                instance:chooseLeft()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local inherit_choose_right_terminal = {
            _name = "inherit_choose_right",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= "" and params ~= nil then
                    instance._right_ship = params 
                end
                instance:chooseRight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local inherit_choose_open_left_packs_terminal = {
            _name = "inherit_choose_open_left_packs",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("inherit_left_pack_window_open", 0, instance._left_ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        
        local inherit_choose_open_right_packs_terminal = {
            _name = "inherit_choose_open_right_packs",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._left_ship == nil then
                    TipDlg.drawTextDailog(red_alert_all_str[256])
                    return
                end
                state_machine.excute("inherit_right_pack_window_open", 0, {instance._left_ship, instance._right_ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(inherit_sure_inherit_terminal)
        state_machine.add(inherit_choose_left_terminal)
        state_machine.add(inherit_choose_right_terminal)
        state_machine.add(inherit_choose_open_left_packs_terminal)
        state_machine.add(inherit_choose_open_right_packs_terminal)
        state_machine.init()
    end
    init_inherit_terminal()
end

function Inherit:playSuccessAni( ship_id )
    local root = self.roots[1]
    local Panel_inerit_su = ccui.Helper:seekWidgetByName(root,"Panel_inerit_su")
    Panel_inerit_su:setVisible(true)
    local ArmatureNode_inerit_su = Panel_inerit_su:getChildByName("ArmatureNode_inerit_su")
    draw.initArmature(ArmatureNode_inerit_su, nil, -1, 0, 1)
    csb.animationChangeToAction(ArmatureNode_inerit_su, 0, 0, false)
    ArmatureNode_inerit_su._self = self
    ArmatureNode_inerit_su._parent = Panel_inerit_su
    ArmatureNode_inerit_su._ship_id = ship_id
    ArmatureNode_inerit_su._invoke = function(armatureBack)
        if zstring.tonumber(armatureBack._ship_id) > 0 then
            state_machine.unlock("inherit_sure_inherit")
            state_machine.excute("inherit_get_window_open", 0, armatureBack._ship_id)
            if armatureBack._self ~= nil and armatureBack._self.roots ~= nil then
                armatureBack._parent:setVisible(false)
                armatureBack._self:onUpdateDraw()
            end
        end
        armatureBack._ship_id = 0
    end  
end

function Inherit:chooseLeft( ... )
    local root = self.roots[1]
    local Panel_in_hero_bg_1 = ccui.Helper:seekWidgetByName(root,"Panel_in_hero_bg_1")
    local Panel_hero_1 = ccui.Helper:seekWidgetByName(root,"Panel_hero_1")
    local Text_name_1 = ccui.Helper:seekWidgetByName(root,"Text_name_1")
    local Text_inherit_infor = ccui.Helper:seekWidgetByName(root,"Text_inherit_infor")
    Panel_hero_1:removeAllChildren(true)
    Panel_in_hero_bg_1:setVisible(true)
    local quality = 0
    Text_name_1:setString("")
    Text_inherit_infor:setString(red_alert_all_str[261])
    if self._left_ship ~= nil then
        Text_name_1:setString(self._left_ship.captain_name)
        quality = tonumber(self._left_ship.ship_type)
        Panel_in_hero_bg_1:setVisible(false)
        Text_inherit_infor:setString(red_alert_all_str[262])

        local ship_mould_id = self._left_ship.ship_template_id
        app.load("client.battle.fight.FightEnum")
        local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
        temp_bust_index = 10000 + temp_bust_index
        local armature = sp.spine_sprite(Panel_hero_1, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
        armature:setPosition(cc.p(Panel_hero_1:getContentSize().width/2, 0))

        if self._right_ship ~= nil then
            local info = zstring.split(dms.string(dms["ship_config"], 3, ship_config.info), "|")
            local show_info = {}
            for k,v in pairs(info) do
                local ships = zstring.split(v, ",")
                for index, shipId in pairs(ships) do
                    if tonumber(shipId) == tonumber(self._left_ship.ship_base_template_id) then
                        show_info = ships
                        break
                    end
                end
            end
            local isNeedChangeRight = true
            for k,v in pairs(show_info) do
                if tonumber(v) == tonumber(self._right_ship) then
                    isNeedChangeRight = false
                end
            end
            if isNeedChangeRight == true then
                self._right_ship = nil
                self:chooseRight()
            else
                Text_inherit_infor:setString(red_alert_all_str[263])
            end
        end
    else
        self._right_ship = nil
        self:chooseRight()
    end
    Text_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
end

function Inherit:chooseRight( ... )
    local root = self.roots[1]
    local Panel_in_hero_bg_2 = ccui.Helper:seekWidgetByName(root,"Panel_in_hero_bg_2")
    local Panel_hero_2 = ccui.Helper:seekWidgetByName(root,"Panel_hero_2")
    local Text_name_2 = ccui.Helper:seekWidgetByName(root,"Text_name_2")
    local Panel_consume_icon = ccui.Helper:seekWidgetByName(root,"Panel_consume_icon")
    local Text_inherit_infor_0 = ccui.Helper:seekWidgetByName(root,"Text_inherit_infor_0")
    local Text_4 = ccui.Helper:seekWidgetByName(root,"Text_4")
    local Text_inherit_infor = ccui.Helper:seekWidgetByName(root,"Text_inherit_infor")
    Panel_hero_2:removeAllChildren(true)
    Panel_in_hero_bg_2:setVisible(true)
    Panel_consume_icon:removeBackGroundImage()
    Text_inherit_infor_0:setVisible(false)
    Text_4:setVisible(false)
    local quality = 0
    Text_name_2:setString("")
    if self._right_ship ~= nil and tonumber(self._right_ship) > 0 then
        Text_inherit_infor:setString(red_alert_all_str[263])
        Text_name_2:setString(dms.string(dms["ship_mould"], self._right_ship, ship_mould.captain_name))
        quality = dms.int(dms["ship_mould"], self._right_ship, ship_mould.ship_type)
        Text_inherit_infor_0:setVisible(true)
        Text_4:setVisible(true)
        Panel_in_hero_bg_2:setVisible(false)
        app.load("client.battle.fight.FightEnum")
        local temp_bust_index = dms.int(dms["ship_mould"], self._right_ship, ship_mould.bust_index)
        temp_bust_index = 10000 + temp_bust_index
        local armature = sp.spine_sprite(Panel_hero_2, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
        armature:setPosition(cc.p(Panel_hero_2:getContentSize().width/2, 0))

        local pic_index = dms.int(dms["ship_mould"], self._right_ship, ship_mould.head_icon) + 10000
        Panel_consume_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))
    end
    Text_name_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
end

function Inherit:onUpdateDraw()
    local root = self.roots[1]
    self:chooseLeft()
end

function Inherit:onInit( )
    local csbItem = csb.createNode(config_csb.forging.inherit)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "inherit_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_inherit"), nil, 
    {
        terminal_name = "inherit_sure_inherit",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hero_1"), nil, 
    {
        terminal_name = "inherit_choose_open_left_packs",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_in_hero_bg_1"), nil, 
    {
        terminal_name = "inherit_choose_open_left_packs",
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 0)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hero_2"), nil, 
    {
        terminal_name = "inherit_choose_open_right_packs",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_in_hero_bg_2"), nil, 
    {
        terminal_name = "inherit_choose_open_right_packs",
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil, 
    {
        terminal_name = "inherit_rule_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    local Image_add_1 = ccui.Helper:seekWidgetByName(root, "Image_add_1")
    local Image_add_2 = ccui.Helper:seekWidgetByName(root, "Image_add_2")
    local actions1 = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.1),cc.ScaleTo:create(0.5,1)))
    Image_add_1:runAction(actions1)
    local actions2 = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.1),cc.ScaleTo:create(0.5,1)))
    Image_add_2:runAction(actions2)

    self:onUpdateDraw() 
end

function Inherit:init()
    for i, v in pairs(config_res.sprites_cached["inherit"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    for i, v in pairs(config_res.armatures_cached["inherit"]) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
    end
    self:onInit()
    return self
end

function Inherit:onExit()
    state_machine.remove("inherit_sure_inherit")
    state_machine.remove("inherit_choose_left")
    state_machine.remove("inherit_choose_right")
    state_machine.remove("inherit_choose_open_left_packs")
    state_machine.remove("inherit_choose_open_right_packs")
end
