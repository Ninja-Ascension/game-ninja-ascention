--------------------------------------------------------------------------------------------------------------
--  说明：科威特秘密探索一次
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSecretGet = class("RedAlertTimeSecretGetClass", Window)

--打开界面
local red_alert_time_secret_get_window_open_terminal = {
	_name = "red_alert_time_secret_get_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(RedAlertTimeSecretGet:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local red_alert_time_secret_get_window_close_terminal = {
    _name = "red_alert_time_secret_get_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeSecretGetClass"))
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

state_machine.add(red_alert_time_secret_get_window_open_terminal)
state_machine.add(red_alert_time_secret_get_window_close_terminal)
state_machine.init()

function RedAlertTimeSecretGet:ctor()
	self.super:ctor()
	self.roots = {}

    self._once_gold = 0
    self._activity_id = nil
    self._activity_type = nil
    self.page = nil
    self.havefree = false
    self.isEnd = false

    self._activity_data = nil

    local function init_red_alert_time_secret_get_terminal()
        local red_alert_time_secret_get_sure_recruit_terminal = {
            _name = "red_alert_time_secret_get_sure_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local price = countActivityHeroDiscount()
                local tip = ConfirmTip:new()
                local str = ""
                if tonumber(instance._activity_type) == 101 then
                    str = string.format(activity_str_tip[131], instance._once_gold, 1)
                else
                    str = string.format(red_alert_time_str[215], instance._once_gold, 1)
                end
                tip:init(instance, instance.sureRecruit, str)
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local red_alert_time_secret_get_updata_button_type_terminal = {
            _name = "red_alert_time_secret_get_updata_button_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params == 1 then -- 免费
                    if instance.page == 1 then
                        instance.havefree = true
                    end
                else           --不可点
                    instance.isEnd = true
                end
                instance:onUpdateButtonType()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_secret_get_updata_button_type_terminal)
        state_machine.add(red_alert_time_secret_get_sure_recruit_terminal) 
        state_machine.init()
    end
    init_red_alert_time_secret_get_terminal()
end

function RedAlertTimeSecretGet:onUpdateButtonType()
    local root = self.roots[1]
    local Button_seek_one = ccui.Helper:seekWidgetByName(root, "Button_seek_one")
    local Text_seek_gold_n = ccui.Helper:seekWidgetByName(root, "Text_seek_gold_n")
    local Image_seek_gold_icon = ccui.Helper:seekWidgetByName(root, "Image_seek_gold_icon")
    Text_seek_gold_n:setString(self._once_gold)
    Image_seek_gold_icon:setVisible(true)
    Text_seek_gold_n:setVisible(true)

    local blueButtonTexture = config_res.images.ui.share.blue_button
    local yellowButtonTexture = config_res.images.ui.share.yellow_button
    local grayButtonTexture = config_res.images.ui.share.gray_button
    if tonumber(self._activity_type) == 101 then
        Button_seek_one:setTitleText(activity_str_tip[152])
    end
    Button_seek_one:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
    Button_seek_one:setTouchEnabled(true)
    Button_seek_one:setBright(true)
    if self.havefree == true then
        Button_seek_one:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
        Button_seek_one:setTitleText(activity_str_tip[132])
        Image_seek_gold_icon:setVisible(false)
        Text_seek_gold_n:setVisible(false)
    end
    if self.isEnd == true then
        Button_seek_one:setTouchEnabled(false)
        Button_seek_one:setBright(false)
    end
end

function RedAlertTimeSecretGet:sureRecruit(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node.havefree = false
                response.node:onUpdateDraw()
            end
        end
    end
    if sure_number == 0 then
        protocol_command.draw_activity_reward.param_list = self._activity_id .. "\r\n"..self._activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."0".."\r\n"..self.page
        NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
    end
end

function RedAlertTimeSecretGet:onUpdateDraw(  )
    local reward_Type = 1000 + tonumber(self._activity_type)
    self._activity_data = getSceneReward(reward_Type)
    local root = self.roots[1]
    local Panel_seek_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_seek_get_icon")
    local Text_ten_recruit_consume_n = ccui.Helper:seekWidgetByName(root, "Text_ten_recruit_consume_n")
    local Text_senior_recruit_free_time = ccui.Helper:seekWidgetByName(root, "Text_senior_recruit_free_time")
    local Panel_get_text_effice = ccui.Helper:seekWidgetByName(root, "Panel_get_text_effice")

    self:onUpdateButtonType()

    Panel_get_text_effice:removeAllChildren(true)
    local armature1 = ccs.Armature:create("effice_recruit_get_text")
    draw.initArmature(armature1, nil, -1, 0, 1)
    armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_get_text_effice:addChild(armature1)
    armature1:getAnimation():playWithIndex(0)

    function actionCallBack(sender)
        
    end
    Panel_seek_get_icon:removeBackGroundImage()
    Panel_seek_get_icon:removeAllChildren(true)
    Panel_seek_get_icon:stopAllActions()
    Panel_seek_get_icon:setScale(0.1)
    local reward_data = self._activity_data
    local data = reward_data.show_reward_list[1]
    local prop_item = data.prop_item
    local item_value = data.item_value
    local prop_type = data.prop_type
    if tonumber(prop_item) == -1 then
        prop_item = resource_prop_id[tonumber(prop_type)]
    end
    local show_type = prop_type
    local change_of_equipment = 0
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
    _ED.show_reward_list_group = {}
    checkPlayEffect(57)
    cell = state_machine.excute("props_icon_create_cell",0,{9,1,prop_item,show_type,item_value,true})
    if change_of_equipment > 0 then
        local equipment_type = dms.int(dms["equipment_mould"], change_of_equipment, equipment_mould.equipment_type)
        ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString(equipment_type_str[equipment_type])
    end
    Panel_seek_get_icon:addChild(cell)
    -- Panel_seek_get_icon:setBackGroundImage("images/ui/props/props_3.png")
    local armature = ccs.Armature:create("effice_recruit_get_light")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_seek_get_icon:addChild(armature)
    armature:setPosition(cc.p(Panel_seek_get_icon:getContentSize().width/2, Panel_seek_get_icon:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
    
    Panel_seek_get_icon:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.1, 1),
        cc.CallFunc:create(actionCallBack)
        ))
end

function RedAlertTimeSecretGet:onInit(params)
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_get)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_text)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_one"), nil, 
    {
        terminal_name = "red_alert_time_secret_get_sure_recruit", 
        terminal_state = 0, 
       	touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seek_sure"), nil, 
    {
        terminal_name = "red_alert_time_secret_get_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    self:onUpdateDraw()
end

function RedAlertTimeSecretGet:onEnterTransitionFinish()

end

function RedAlertTimeSecretGet:init(params)
    self._once_gold = params[1]
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

function RedAlertTimeSecretGet:onExit()
    state_machine.remove("red_alert_time_secret_get_sure_recruit")
    state_machine.remove("red_alert_time_secret_get_updata_button_type")
end