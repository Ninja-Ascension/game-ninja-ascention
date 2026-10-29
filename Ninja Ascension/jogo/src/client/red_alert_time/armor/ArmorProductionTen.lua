--------------------------------------------------------------------------------------------------------------
--  说明：装甲生产十次
--------------------------------------------------------------------------------------------------------------
ArmorProductionTen = class("ArmorProductionTenClass", Window)

--打开界面
local armor_production_ten_window_open_terminal = {
    _name = "armor_production_ten_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(ArmorProductionTen:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local armor_production_ten_window_close_terminal = {
    _name = "armor_production_ten_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorProductionTenClass"))
        state_machine.excute("armor_production_update_all", 0, "")
        state_machine.excute("armor_pack_update", 0, "")
        state_machine.excute("armor_equipment_update_one_click_setup", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_production_ten_window_open_terminal)
state_machine.add(armor_production_ten_window_close_terminal)
state_machine.init()

function ArmorProductionTen:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._action_index = 0
    self._begin_pos_x = 0
    self._begin_pos_y = 0
    self._move_panel = nil
    self._move_zorder = 150

    self._get_prop_id = 0
    self._get_prop_num = 0
    self._get_prop_type = 0
    self._panel_prop_icon = nil

    self._play_state = 0

    self._production_cost = 0

    local function init_armor_production_ten_terminal()
        local armor_production_ten_sure_recruit_terminal = {
            _name = "armor_production_ten_sure_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local production_type = instance._production_type
                local buy_count = 10
                local cost = instance._production_cost
                if cost > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("recharge_tip_window_open", 0, "")
                    return
                end

                local function gotoArmorPack(instance, sure_number)
                    if sure_number == 0 then
                        state_machine.excute("armor_production_ten_window_close", 0, "")
                        state_machine.excute("armor_change_page", 0, {_datas = {page = 3}})
                    end
                end
                local armor_count = 0
                for k, v in pairs(getArmorList()) do
                    if v.formation_type == 0 then
                        armor_count = armor_count + 1
                    end
                end
                for k, v in pairs(getPropPackList(26)) do
                    armor_count = armor_count + tonumber(v.prop_number)
                end
                if (armor_count + buy_count) > tonumber(_ED.user_armor_info.armor_capacity) then
                    local tip = ConfirmTip:new()
                    tip:init(instance, gotoArmorPack, armor_tip_str[25])
                    fwin:open(tip,fwin._windows) 
                    return
                end

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.armor_production.param_list = ""..production_type.."\r\n"..buy_count
                NetworkManager:register(protocol_command.armor_production.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_production_ten_update_draw_terminal = {
            _name = "armor_production_ten_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_production_ten_update_ani_state_terminal = {
            _name = "armor_production_ten_update_ani_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showActionAni(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_production_ten_sure_recruit_terminal)
        state_machine.add(armor_production_ten_update_draw_terminal)
        state_machine.add(armor_production_ten_update_ani_state_terminal)
        state_machine.init()
    end
    init_armor_production_ten_terminal()
end

function ArmorProductionTen:playAction( ... )
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("ani_leader_get_icon", false)
    checkPlayEffect(57)
    local reward_list = getSceneReward(1000)
    if _ED.show_reward_list_group_ex ~= nil then
        for sgn, v in pairs(_ED.show_reward_list_group_ex) do
            if 1000 == tonumber(v.show_reward_type) then
                table.remove(_ED.show_reward_list_group_ex, sgn, 1)
            end
        end
    end
    if reward_list ~= nil then
        for i=1,10 do
            local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..i)
            -- 获得道具
            local reward_info = reward_list.show_reward_list[i]
            local get_prop_type = tonumber(reward_info.prop_type)
            local get_prop_id = tonumber(reward_info.prop_item)
            local get_prop_num = tonumber(reward_info.item_value)

            local cell = nil 
            if get_prop_type == 6 then          -- 装甲经验
                cell = state_machine.excute("props_icon_create_cell",0,{6, 1, get_prop_id, 1, -1, true})
            elseif get_prop_type == 7 then      -- 装甲
                cell = state_machine.excute("props_icon_create_cell", 0, {8, 14, get_prop_id, 15, -1, true})
            end
            Panel_leader_get_icon:addChild(cell)
        end
    end
end

function ArmorProductionTen:showActionAni( state )
    local root = self.roots[1]
    if state <= 2 then
        checkPlayEffect(57)
    end
    for i=1,10 do
        local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..i)
        if state == 1 then
            if i <= 4 then
                self:createEffect(Panel_leader_get_icon, i)
            end
        elseif state == 2 then
            if i > 4 and i <= 8 then
                self:createEffect(Panel_leader_get_icon, i)
            end
        elseif state == 3 then
            if i > 8 then
                self:createEffect(Panel_leader_get_icon, i)
            end
        end
    end
end

function ArmorProductionTen:createEffect( panel, index )
    local armature = ccs.Armature:create("effice_recruit_get_light")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    panel:addChild(armature)
    armature:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
end

function ArmorProductionTen:onUpdateDraw(  )
    local root = self.roots[1]

    local Text_recruit_get_special = ccui.Helper:seekWidgetByName(root, "Text_recruit_get_special")
    local Image_leader_draw_get_10 = ccui.Helper:seekWidgetByName(root, "Image_leader_draw_get_10")
    local Image_ten_get_10_delete = ccui.Helper:seekWidgetByName(root, "Image_ten_get_10_delete")
    local Text_ten_get_10_consume_discount_n = ccui.Helper:seekWidgetByName(root, "Text_ten_get_10_consume_discount_n")
    Text_recruit_get_special:setVisible(false)
    Image_leader_draw_get_10:setVisible(false)
    Image_ten_get_10_delete:setVisible(false)
    Text_ten_get_10_consume_discount_n:setVisible(false)

    local Button_senior_recruit = ccui.Helper:seekWidgetByName(root, "Button_senior_recruit")
    local Text_recruit_gold_n = ccui.Helper:seekWidgetByName(root, "Text_recruit_gold_n")
    Button_senior_recruit:setTitleText(armor_tip_str[35])
    local cost = dms.int(dms["partner_bounty_param"], 16, partner_bounty_param.spend_gold)
    Text_recruit_gold_n:setString(cost)
    self._production_cost = cost

    local Panel_get_text_effice = ccui.Helper:seekWidgetByName(root, "Panel_get_text_effice")
    Panel_get_text_effice:removeAllChildren(true)
    local armature1 = ccs.Armature:create("effice_recruit_get_text")
    draw.initArmature(armature1, nil, -1, 0, 1)
    armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_get_text_effice:addChild(armature1)
    armature1:getAnimation():playWithIndex(0)

    for i=1,10 do
        local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..i)
        Panel_leader_get_icon:removeAllChildren(true)
        -- Panel_leader_get_icon:stopAllActions()
        -- Panel_leader_get_icon:removeBackGroundImage()
        -- Panel_leader_get_icon:setScale(0.1)
    end

    self._action_index = 0
    self:playAction()
end

function ArmorProductionTen:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_recruit_get_ten)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.leader.leader_recruit_get_ten)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "ani_leader_get_icon_1" then
            state_machine.excute("armor_production_ten_update_ani_state", 0, 1)
        elseif str == "ani_leader_get_icon_2" then
            state_machine.excute("armor_production_ten_update_ani_state", 0, 2)
        elseif str == "ani_leader_get_icon_3" then
            state_machine.excute("armor_production_ten_update_ani_state", 0, 3)
        elseif str == "ani_leader_get_icon_over" then
            
        end
    end)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_text) 
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_senior_recruit"), nil, 
    {
        terminal_name = "armor_production_ten_sure_recruit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_sure"), nil, 
    {
        terminal_name = "armor_production_ten_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)
    
    self:onUpdateDraw()
end

function ArmorProductionTen:onEnterTransitionFinish()

end

function ArmorProductionTen:init(params)
    self._production_type = params[1]

    self:onInit()
    return self
end

function ArmorProductionTen:onExit()
    state_machine.remove("armor_production_ten_sure_recruit")
    state_machine.remove("armor_production_ten_update_draw")
    state_machine.remove("armor_production_ten_update_ani_state")
end