--------------------------------------------------------------------------------------------------------------
--  说明：装甲生产一次
--------------------------------------------------------------------------------------------------------------
ArmorProductionOnce = class("ArmorProductionOnceClass", Window)

--打开界面
local armor_production_once_window_open_terminal = {
    _name = "armor_production_once_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(ArmorProductionOnce:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local armor_production_once_window_close_terminal = {
    _name = "armor_production_once_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorProductionOnceClass"))
        state_machine.excute("armor_production_update_all", 0, "")
        state_machine.excute("armor_pack_update", 0, "")
        state_machine.excute("armor_equipment_update_one_click_setup", 0, "")
        _ED.show_reward_list_group = {}
        _ED.show_reward_list_group_ex = {}
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_production_once_window_open_terminal)
state_machine.add(armor_production_once_window_close_terminal)
state_machine.init()

function ArmorProductionOnce:ctor()
    self.super:ctor()
    self.roots = {}

    self._production_type = 0
    self._production_cost = 0

    local function init_armor_production_once_terminal()
        local armor_production_once_sure_recruit_terminal = {
            _name = "armor_production_once_sure_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local production_type = instance._production_type
                local buy_count = 1
                local cost = instance._production_cost
                if cost > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("recharge_tip_window_open", 0, "")
                    return
                end

                local function gotoArmorPack(instance, sure_number)
                    if sure_number == 0 then
                        state_machine.excute("armor_production_once_window_close", 0, "")
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

        local armor_production_once_update_draw_terminal = {
            _name = "armor_production_once_update_draw",
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

        state_machine.add(armor_production_once_sure_recruit_terminal) 
        state_machine.add(armor_production_once_update_draw_terminal) 
        state_machine.init()
    end
    init_armor_production_once_terminal()
end

function ArmorProductionOnce:onUpdateDraw(  )
    local root = self.roots[1]

    local Image_leader_draw_get_1 = ccui.Helper:seekWidgetByName(root, "Image_leader_draw_get_1")
    local Text_recruit_get_special = ccui.Helper:seekWidgetByName(root, "Text_recruit_get_special")
    local Text_senior_get_1_consume_discount_n = ccui.Helper:seekWidgetByName(root, "Text_senior_get_1_consume_discount_n")
    local Image_senior_get_1_delete = ccui.Helper:seekWidgetByName(root, "Image_senior_get_1_delete")
    Image_leader_draw_get_1:setVisible(false)
    Text_recruit_get_special:setVisible(false)
    Text_senior_get_1_consume_discount_n:setVisible(false)
    Image_senior_get_1_delete:setVisible(false)

    local free_times_info = _ED.user_armor_info.free_times_info[""..(self._production_type + 1)]
    local free_times = tonumber(free_times_info.free_times)
    local cost = dms.int(dms["partner_bounty_param"], 13 + self._production_type, partner_bounty_param.spend_gold)
    self._production_cost = cost

    local Image_recruit_gold_icon = ccui.Helper:seekWidgetByName(root, "Image_recruit_gold_icon")
    local Text_recruit_gold_n = ccui.Helper:seekWidgetByName(root, "Text_recruit_gold_n")
    local Text_free_time_t = ccui.Helper:seekWidgetByName(root, "Text_free_time_t")
    local Text_free_time_n = ccui.Helper:seekWidgetByName(root, "Text_free_time_n")
    local Button_senior_recruit = ccui.Helper:seekWidgetByName(root, "Button_senior_recruit")
    Image_recruit_gold_icon:setVisible(false)
    Text_recruit_gold_n:setVisible(false)
    Text_free_time_t:setVisible(false)
    Text_free_time_n:setVisible(false)

    if free_times > 0 then
        self._production_cost = 0
        Text_free_time_t:setVisible(true)
        Text_free_time_n:setVisible(true)
        Text_free_time_t:setString(armor_tip_str[38]..":")
        Text_free_time_n:setString(free_times)
        Button_senior_recruit:setTitleText(armor_tip_str[33])
        Button_senior_recruit:loadTextureNormal("images/ui/share/button_share_1.png", 1)
        Button_senior_recruit:loadTexturePressed("images/ui/share/button_share_1.png", 1)
    else
        Image_recruit_gold_icon:setVisible(true)
        Text_recruit_gold_n:setVisible(true)
        Text_recruit_gold_n:setString(cost)
        Button_senior_recruit:setTitleText(armor_tip_str[34])
        Button_senior_recruit:loadTextureNormal("images/ui/share/button_share_2.png", 1)
        Button_senior_recruit:loadTexturePressed("images/ui/share/button_share_2.png", 1)
    end

    local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon")
    local Panel_get_text_effice = ccui.Helper:seekWidgetByName(root, "Panel_get_text_effice")
    Panel_get_text_effice:removeAllChildren(true)
    local armature1 = ccs.Armature:create("effice_recruit_get_text")
    draw.initArmature(armature1, nil, -1, 0, 1)
    armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_get_text_effice:addChild(armature1)
    armature1:getAnimation():playWithIndex(0)

    function actionCallBack(sender)
        
    end
    Panel_leader_get_icon:removeBackGroundImage()
    Panel_leader_get_icon:removeAllChildren(true)
    Panel_leader_get_icon:stopAllActions()
    Panel_leader_get_icon:setScale(0.1)

    -- 获得道具
    local reward_list = getSceneReward(1000)
    local reward_info = reward_list.show_reward_list[1]
    local get_prop_type = tonumber(reward_info.prop_type)
    local get_prop_id = tonumber(reward_info.prop_item)
    local get_prop_num = tonumber(reward_info.item_value)

    local cell = nil 
    if get_prop_type == 6 then              -- 装甲经验
        cell = state_machine.excute("props_icon_create_cell",0,{6, 1, get_prop_id, 1, -1, true})
    elseif get_prop_type == 7 then          -- 装甲
        cell = state_machine.excute("props_icon_create_cell", 0, {8, 14, get_prop_id, 15, -1, true})
    end
    checkPlayEffect(57)
    Panel_leader_get_icon:addChild(cell)

    local armature = ccs.Armature:create("effice_recruit_get_light")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_leader_get_icon:addChild(armature)
    armature:setPosition(cc.p(Panel_leader_get_icon:getContentSize().width/2, Panel_leader_get_icon:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
    
    Panel_leader_get_icon:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.1, 1),
        cc.CallFunc:create(actionCallBack)
        ))
end

function ArmorProductionOnce:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_recruit_get)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)   

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_text) 
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_senior_recruit"), nil, 
    {
        terminal_name = "armor_production_once_sure_recruit", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_sure"), nil, 
    {
        terminal_name = "armor_production_once_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_free_sure"), nil, 
    {
        terminal_name = "armor_production_once_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    self:onUpdateDraw()
end

function ArmorProductionOnce:onEnterTransitionFinish()

end

function ArmorProductionOnce:init(params)
    self._production_type = params[1]
    self:onInit()
    return self
end

function ArmorProductionOnce:onExit()
    state_machine.remove("armor_production_once_sure_recruit")
    state_machine.remove("armor_production_once_update_draw")
end