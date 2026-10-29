--------------------------------------------------------------------------------------------------------------
--  说明：火线将领招募一次
--------------------------------------------------------------------------------------------------------------
RedAlertTimeLeaderSeniorOnce = class("RedAlertTimeLeaderSeniorOnceClass", Window)

--打开界面
local red_alert_time_leader_senior_once_window_open_terminal = {
	_name = "red_alert_time_leader_senior_once_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(RedAlertTimeLeaderSeniorOnce:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local red_alert_time_leader_senior_once_window_close_terminal = {
    _name = "red_alert_time_leader_senior_once_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeLeaderSeniorOnceClass"))
        state_machine.excute("leader_team_list_update", 0, "")
        state_machine.excute("leader_exchange_list_update", 0, "")
        state_machine.excute("red_alert_time_excavting_comeing_collection_updata", 0, "")
        state_machine.excute("red_alert_time_excavting_comeing_exchange_updata", 0, "")
        state_machine.excute("red_alert_time_falcon_assault_update_draw", 0, "")
        state_machine.excute("red_alert_time_uitimate_breakthrough_update_draw", 0, "")
        _ED.show_reward_list_group = {}
        _ED.show_reward_list_group_ex = {}
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_leader_senior_once_window_open_terminal)
state_machine.add(red_alert_time_leader_senior_once_window_close_terminal)
state_machine.init()

function RedAlertTimeLeaderSeniorOnce:ctor()
	self.super:ctor()
	self.roots = {}
    self.isFree = false
    self.need_gold = 0
    self._activity_type = 0
    self._recruit_type = 0
    local function init_red_alert_time_leader_senior_once_terminal()
        local red_alert_time_leader_senior_once_recruit_terminal = {
            _name = "red_alert_time_leader_senior_once_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance._activity_type) == 99        -- 火线英雄
                    -- or tonumber(instance._activity_type)     -- 传奇名将
                    then
                    if instance.isFree == true then
                        state_machine.excute("red_alert_time_leader_senior_once_sure_recruit",0,nil)
                    else
                        local need_gold = instance.need_gold 
                        state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold, 1, 0}, m_type = 33}})
                    end
                else
                    state_machine.excute("red_alert_time_leader_senior_once_sure_recruit",0,nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_leader_senior_once_update_draw_terminal = {
            _name = "red_alert_time_leader_senior_once_update_draw",
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
        local red_alert_time_leader_senior_once_update_button_terminal = {
            _name = "red_alert_time_leader_senior_once_update_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    local Button_senior_recruit = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_senior_recruit")
                    Button_senior_recruit:setTouchEnabled(false)
                    Button_senior_recruit:setBright(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 招募
        local red_alert_time_leader_senior_once_sure_recruit_terminal = {
            _name = "red_alert_time_leader_senior_once_sure_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local acitvity = _ED.activity_info[""..instance._activity_type]
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n"..instance._recruit_type
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_leader_senior_once_update_button_terminal)
        state_machine.add(red_alert_time_leader_senior_once_sure_recruit_terminal) 
        state_machine.add(red_alert_time_leader_senior_once_update_draw_terminal) 
        state_machine.add(red_alert_time_leader_senior_once_recruit_terminal)
        state_machine.init()
    end
    init_red_alert_time_leader_senior_once_terminal()
end

function RedAlertTimeLeaderSeniorOnce:showGetRewardInfo()
    local root = self.roots[1]
    local Panel_get_text_effice = ccui.Helper:seekWidgetByName(root, "Panel_get_text_effice")
    Panel_get_text_effice:removeAllChildren(true)
    local armature1 = ccs.Armature:create("effice_recruit_get_text")
    draw.initArmature(armature1, nil, -1, 0, 1)
    armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_get_text_effice:addChild(armature1)
    armature1:getAnimation():playWithIndex(0)

    function actionCallBack(sender)
        
    end

    local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon")
    Panel_leader_get_icon:removeBackGroundImage()
    Panel_leader_get_icon:removeAllChildren(true)
    Panel_leader_get_icon:stopAllActions()
    Panel_leader_get_icon:setScale(0.1)

    local reward_data = getSceneReward(1000 + tonumber(self._activity_type),true)
    local data = reward_data.show_reward_list[1]
    local cell = nil 
    if tonumber(data.prop_type) ~= 13 then
        checkPlayEffect(57)
        cell = state_machine.excute("props_icon_create_cell",0,{9,1,data.prop_item,1,data.item_value,true})
    else
        checkPlayEffect(58)
        cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, data.prop_item, 3, data.item_value,true})
    end
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

function RedAlertTimeLeaderSeniorOnce:onUpdateDraw(  )
    local root = self.roots[1]
    --是否免费
    local Image_recruit_gold_icon = ccui.Helper:seekWidgetByName(root, "Image_recruit_gold_icon")
    local Text_recruit_gold_n = ccui.Helper:seekWidgetByName(root, "Text_recruit_gold_n")
    local Button_senior_recruit = ccui.Helper:seekWidgetByName(root, "Button_senior_recruit")
    Button_senior_recruit:setTitleText(activity_str_tip[114])
    local blueButtonTexture = config_res.images.ui.share.blue_button
    local yellowButtonTexture = config_res.images.ui.share.yellow_button
    local grayButtonTexture = config_res.images.ui.share.gray_button
    if self.isFree == true then
        Text_recruit_gold_n:setString(red_alert_time_str[71])
        Image_recruit_gold_icon:setVisible(false)
        Button_senior_recruit:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
    else
        Text_recruit_gold_n:setString(self.need_gold)
        Image_recruit_gold_icon:setVisible(true)
        Button_senior_recruit:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
    end

    if tonumber(self._activity_type) == 30000 and self._recruit_type == 2 then
        -- 极限突破超级实验
        local activity_info = _ED.activity_info[""..self._activity_type] 
        local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "!")
        local activity_add_state = zstring.split(activity_add_state_arr[1], ",")
        Text_recruit_gold_n:setString(activity_add_state[8].."("..activity_add_state[11].."/"..activity_add_state[12]..")")
        Button_senior_recruit:setTitleText(activity_str_tip[208])
        if tonumber(activity_add_state[11]) > 0 then
            Button_senior_recruit:setTouchEnabled(true)
            Button_senior_recruit:setBright(true)
        else
            Button_senior_recruit:setTouchEnabled(false)
            Button_senior_recruit:setBright(false)
        end
    end

    self:showGetRewardInfo()
end

function RedAlertTimeLeaderSeniorOnce:initUI()
    local root = self.roots[1]

    ccui.Helper:seekWidgetByName(root, "Text_free_time_t"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Text_free_time_n"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Text_senior_recruit_free_time"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_leader_draw_get_1"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_senior_get_1_delete"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Text_senior_get_1_consume_discount_n"):setVisible(false)
end

function RedAlertTimeLeaderSeniorOnce:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_recruit_get)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    self:initUI()

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_text) 
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_senior_recruit"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_once_recruit", 
        terminal_state = 0, 
       	touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_sure"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_once_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    self:onUpdateDraw()
end

function RedAlertTimeLeaderSeniorOnce:onEnterTransitionFinish()

end

function RedAlertTimeLeaderSeniorOnce:init(params)
    self._activity_type = params[1]
    self.need_gold = params[2]
    self.isFree = params[3]
    self._recruit_type = params[4] or 0
	self:onInit()
    return self
end

function RedAlertTimeLeaderSeniorOnce:onExit()
    state_machine.remove("red_alert_time_leader_senior_once_sure_recruit")
    state_machine.remove("red_alert_time_leader_senior_once_update_draw")
    state_machine.remove("red_alert_time_leader_senior_once_update_button")
    state_machine.remove("red_alert_time_leader_senior_once_recruit")
end