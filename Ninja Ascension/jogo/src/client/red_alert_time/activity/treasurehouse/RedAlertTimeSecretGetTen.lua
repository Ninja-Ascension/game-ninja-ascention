--------------------------------------------------------------------------------------------------------------
--  说明：科威特秘密探索十次
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSecretGetTen = class("RedAlertTimeSecretGetTenClass", Window)

--打开界面
local red_alert_time_secret_get_ten_window_open_terminal = {
	_name = "red_alert_time_secret_get_ten_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(RedAlertTimeSecretGetTen:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local red_alert_time_secret_get_ten_window_close_terminal = {
    _name = "red_alert_time_secret_get_ten_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeSecretGetTenClass"))
        state_machine.excute("leader_team_list_update", 0, "")
        state_machine.excute("leader_exchange_list_update", 0, "")
        state_machine.unlock("red_alert_time_secret_transfer_explore")
        _ED.show_reward_list_group = {}
        _ED.show_reward_list_group_ex = {}
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_secret_get_ten_window_open_terminal)
state_machine.add(red_alert_time_secret_get_ten_window_close_terminal)
state_machine.init()

function RedAlertTimeSecretGetTen:ctor()
	self.super:ctor()
	self.roots = {}

    self._ten_gold = 0

    self._action_index = 0
    self._begin_pos_x = 0
    self._begin_pos_y = 0
    self._move_panel = nil
    self._move_zorder = 150

    self._get_prop_id = 0
    self._get_prop_num = 0
    self._get_prop_type = 0
    self._panel_prop_icon = nil
    self.page = nil

    self._activity_id = nil
    self._activity_type = nil
    self.have_free = false
    self.reward_data = nil 
    local function init_red_alert_time_secret_get_ten_terminal()
        local red_alert_time_secret_get_ten_sure_recruit_terminal = {
            _name = "red_alert_time_secret_get_ten_sure_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.have_free == true and instance.page == 1 then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    return
                end
                local tip = ConfirmTip:new()
                if tonumber(instance._activity_type) == 101 then
                    str = string.format(activity_str_tip[131], instance._ten_gold, 10)
                else
                    str = string.format(red_alert_time_str[215], instance._ten_gold, 10)
                end
                tip:init(instance, instance.sureRecruit, str)
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_secret_get_ten_play_back_action_terminal = {
            _name = "red_alert_time_secret_get_ten_play_back_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:playBackAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local red_alert_time_secret_get_ten_updata_button_type_terminal = {
            _name = "red_alert_time_secret_get_ten_updata_button_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Button_seek_treasure_get_ten = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_seek_treasure_get_ten")
                if params == 1 and self.page == 1 then -- 免费
                    self.have_free = true
                else           --不可点
                    Button_seek_treasure_get_ten:setTouchEnabled(false)
                    Button_seek_treasure_get_ten:setBright(false)
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_secret_get_ten_updata_button_type_terminal)
        state_machine.add(red_alert_time_secret_get_ten_sure_recruit_terminal)
        state_machine.add(red_alert_time_secret_get_ten_play_back_action_terminal)
        state_machine.init()
    end
    init_red_alert_time_secret_get_ten_terminal()
end

function RedAlertTimeSecretGetTen:sureRecruit(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    if sure_number == 0 then
        self.reward_data = nil
        protocol_command.draw_activity_reward.param_list = self._activity_id .. "\r\n"..self._activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."1".."\r\n"..self.page
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)   
    end
end

function RedAlertTimeSecretGetTen:playBackAction( ... )
    local function actionEnd(sender)
        if sender ~= nil then
            sender:getParent():reorderChild(sender, self._move_zorder)
            sender._self:playSuccessAction()
        end
    end
    local Image_recruit_get_special_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_recruit_get_special_bg")
    Image_recruit_get_special_bg:setVisible(false)

    self._panel_prop_icon:removeAllChildren(true)
    local cell = nil
    if self._get_prop_type == 1 then
        cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, self._get_prop_id, 3, self._get_prop_num,true})
    else
        cell = state_machine.excute("props_icon_create_cell", 0, {9, 1, self._get_prop_id, 1, self._get_prop_num})
    end
    self._panel_prop_icon:addChild(cell)

    self._move_panel:runAction(cc.Sequence:create(
        cc.Spawn:create({cc.MoveTo:create(0.3, cc.p(self._begin_pos_x, self._begin_pos_y)),
                cc.ScaleTo:create(0.3, 1)
            }),
        cc.CallFunc:create(actionEnd)
        ))
end

function RedAlertTimeSecretGetTen:playSuccessAction( ... )
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    self._action_index = self._action_index + 1
    if self.reward_data ~= nil and self._action_index > #self.reward_data.show_reward_list then
        _ED.show_reward_list_group = {}
        self:updateState(true)
        return
    end
    local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..self._action_index)
    
    function actionCallBack(sender)
        sender._self:playSuccessAction()
    end

    function actionCallBack2(sender)
        if sender ~= nil then
            local Image_recruit_get_special_bg = ccui.Helper:seekWidgetByName(root, "Image_recruit_get_special_bg")
            Image_recruit_get_special_bg:setTouchEnabled(true)

            self._panel_prop_icon:removeAllChildren(true)
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_leader)
            local armature = ccs.Armature:create("effect_leader")
            armature:getAnimation():playWithIndex(0)
            armature:setPosition(cc.p(self._panel_prop_icon:getContentSize().width/2,self._panel_prop_icon:getContentSize().height/2))
            self._panel_prop_icon:addChild(armature)
            local cell = state_machine.excute("leader_big_head_create_cell", 0, {self._get_prop_id, self._get_prop_num, self._get_prop_type})
            local size = self._panel_prop_icon:getContentSize()
            cell:setAnchorPoint(cc.p(0.5, 0.5))
            cell:setPosition(cc.p(size.width / 2, size.height / 2))
            self._panel_prop_icon:addChild(cell)
        end
    end
    local reward_Type = 1000 + tonumber(self._activity_type)
    local reward_data = getSceneReward(reward_Type,true)
    self.reward_data = reward_data
    if reward_data ~= nil then
        local data = reward_data.show_reward_list[self._action_index]
        local prop_item = data.prop_item
        local item_value = data.item_value
        local prop_type = data.prop_type
        local change_of_equipment = 0
        if tonumber(prop_item) == -1 then
            prop_item = resource_prop_id[tonumber(prop_type)]
        end
        local show_type = prop_type
        if tonumber(prop_type) == 13 then --坦克
            show_type = 3
        elseif tonumber(prop_type) == 6 then --道具    
            show_type = 1
            change_of_equipment = dms.int(dms["prop_mould"], prop_item, prop_mould.change_of_equipment)
        elseif tonumber(prop_type) == 7 then --配件    
            show_type = 7
        else
            show_type = 1
        end
        checkPlayEffect(57)
        cell = state_machine.excute("props_icon_create_cell",0,{9,1,prop_item,show_type,item_value,true})
        if change_of_equipment > 0 then
            local equipment_type = dms.int(dms["equipment_mould"], change_of_equipment, equipment_mould.equipment_type)
            ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString(equipment_type_str[equipment_type])
        end
        Panel_leader_get_icon:addChild(cell)
    end

    local armature = ccs.Armature:create("effice_recruit_get_light")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_leader_get_icon:addChild(armature)
    armature:setPosition(cc.p(Panel_leader_get_icon:getContentSize().width/2, Panel_leader_get_icon:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
    -- Panel_leader_get_icon:setBackGroundImage("images/ui/props/props_3.png")
    Panel_leader_get_icon._self = self

    if self._get_prop_type == 1 or self._get_prop_type == 2 then
        local Panel_recruit_get_special_icon = ccui.Helper:seekWidgetByName(root, "Panel_recruit_get_special_icon")
        local Image_recruit_get_special_bg = ccui.Helper:seekWidgetByName(root, "Image_recruit_get_special_bg")
        Image_recruit_get_special_bg:setVisible(true)
        Image_recruit_get_special_bg:setTouchEnabled(false)
        self._begin_pos_x, self._begin_pos_y = Panel_leader_get_icon:getPosition()
        self._move_panel = Panel_leader_get_icon
        Panel_leader_get_icon:getParent():reorderChild(Panel_leader_get_icon, 10000)

        self._get_prop_id = get_prop_id
        self._panel_prop_icon = Panel_leader_get_icon
        self._get_prop_num = get_prop_num

        local posx, posy = Panel_recruit_get_special_icon:getPosition()
        Panel_leader_get_icon:runAction(cc.Sequence:create(
            cc.Spawn:create({cc.MoveTo:create(0.2, cc.p(posx, posy)),
                    cc.ScaleTo:create(0.2, 1)
                }),
            cc.CallFunc:create(actionCallBack2)
            ))
    else
        Panel_leader_get_icon:runAction(cc.Sequence:create(
            cc.ScaleTo:create(0.15, 1),
            cc.CallFunc:create(actionCallBack)
            ))
    end
end

function RedAlertTimeSecretGetTen:onUpdateDraw(  )
    local root = self.roots[1]
    local Text_seek_treasure_get_ten_gold_n = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_get_ten_gold_n")
    local Panel_get_text_effice = ccui.Helper:seekWidgetByName(root, "Panel_get_text_effice")

    local Button_seek_treasure_get_ten = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_get_ten")
    if tonumber(self._activity_type) == 101 then
        Button_seek_treasure_get_ten:setTitleText(activity_str_tip[153])
    end

    Text_seek_treasure_get_ten_gold_n:setString(self._ten_gold)
    
    Panel_get_text_effice:removeAllChildren(true)
    local armature1 = ccs.Armature:create("effice_recruit_get_text")
    draw.initArmature(armature1, nil, -1, 0, 1)
    armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_get_text_effice:addChild(armature1)
    armature1:getAnimation():playWithIndex(0)

    for i=1,10 do
        local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..i)
        Panel_leader_get_icon:removeAllChildren(true)
        Panel_leader_get_icon:stopAllActions()
        Panel_leader_get_icon:removeBackGroundImage()
        Panel_leader_get_icon:setScale(0.1)
    end

    self._action_index = 0
    self:updateState(false)
    self:playSuccessAction()
end

function RedAlertTimeSecretGetTen:updateState( state )
    local root = self.roots[1]
    local Button_seek_treasure_get_ten = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_get_ten")
    local Button_seek_treasure_get_ten_sure = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_get_ten_sure")
    local Image_seek_treasure_get_ten_icon = ccui.Helper:seekWidgetByName(root, "Image_seek_treasure_get_ten_icon")
    local Text_seek_treasure_get_ten_gold_n = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_get_ten_gold_n")
    Button_seek_treasure_get_ten:setVisible(state)
    Button_seek_treasure_get_ten_sure:setVisible(state)
    Image_seek_treasure_get_ten_icon:setVisible(state)
    Text_seek_treasure_get_ten_gold_n:setVisible(state)
end

function RedAlertTimeSecretGetTen:onInit(params)
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_get_ten)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_text)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_get_ten"), nil, 
    {
        terminal_name = "red_alert_time_secret_get_ten_sure_recruit", 
        terminal_state = 0, 
       	touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_get_ten_sure"), nil, 
    {
        terminal_name = "red_alert_time_secret_get_ten_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_recruit_get_special_bg"), nil, 
    {
        terminal_name = "red_alert_time_secret_get_ten_play_back_action", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        -- touch_black = true,
    }, nil, 1)
    
    self:onUpdateDraw()
end

function RedAlertTimeSecretGetTen:onEnterTransitionFinish()

end

function RedAlertTimeSecretGetTen:init(params)
    self._ten_gold = params[1]
    self._activity_id = params[2]
    self._activity_type = params[3]
    if params[4] ~= nil and params[4] ~= "" then
        self.page = params[4]
    else
        self.page = ""
    end
	self:onInit()
    return self
end

function RedAlertTimeSecretGetTen:onExit()
    state_machine.remove("red_alert_time_secret_get_ten_sure_recruit")
    state_machine.remove("red_alert_time_secret_get_ten_play_back_action")
    state_machine.remove("red_alert_time_secret_get_ten_updata_button_type")  
end