--------------------------------------------------------------------------------------------------------------
--  说明：火线将领招募十次
--------------------------------------------------------------------------------------------------------------
RedAlertTimeLeaderSeniorTen = class("RedAlertTimeLeaderSeniorTenClass", Window)

--打开界面
local red_alert_time_leader_senior_ten_window_open_terminal = {
	_name = "red_alert_time_leader_senior_ten_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(RedAlertTimeLeaderSeniorTen:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local red_alert_time_leader_senior_ten_window_close_terminal = {
    _name = "red_alert_time_leader_senior_ten_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeLeaderSeniorTenClass"))
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

state_machine.add(red_alert_time_leader_senior_ten_window_open_terminal)
state_machine.add(red_alert_time_leader_senior_ten_window_close_terminal)
state_machine.init()

function RedAlertTimeLeaderSeniorTen:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._get_prop_id = 0
    self._get_prop_num = 0
    self._get_prop_type = 0

    self.need_gold = 0
    self.data = nil

    local function init_red_alert_time_leader_senior_ten_terminal()
        local red_alert_time_leader_senior_ten_recruit_terminal = {
            _name = "red_alert_time_leader_senior_ten_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(instance._activity_type) == 99        -- 火线英雄
                    -- or tonumber(instance._activity_type)     -- 传奇名将
                    then
                    local need_gold = instance.need_gold
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold, 10, 1}, m_type = 34}})
                else
                    state_machine.excute("red_alert_time_leader_senior_ten_sure_recruit",0,nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_leader_senior_ten_update_draw_terminal = {
            _name = "red_alert_time_leader_senior_ten_update_draw",
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

        local red_alert_time_leader_senior_ten_update_ani_state_terminal = {
            _name = "red_alert_time_leader_senior_ten_update_ani_state",
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
        local red_alert_time_leader_senior_ten_sure_recruit_terminal = {
            _name = "red_alert_time_leader_senior_ten_sure_recruit",
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
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_leader_senior_ten_update_button_terminal)
        state_machine.add(red_alert_time_leader_senior_ten_recruit_terminal)
        state_machine.add(red_alert_time_leader_senior_ten_update_draw_terminal)
        state_machine.add(red_alert_time_leader_senior_ten_update_ani_state_terminal)
        state_machine.add(red_alert_time_leader_senior_ten_sure_recruit_terminal)
        state_machine.init()
    end
    init_red_alert_time_leader_senior_ten_terminal()
end

function RedAlertTimeLeaderSeniorTen:playAction( ... )
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("ani_leader_get_icon", false)
    checkPlayEffect(57)
    for i=1,10 do
        local Panel_leader_get_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_get_icon_"..i)
        local get_prop_type = tonumber(self.data[i].prop_type)
        local get_prop_id = tonumber(self.data[i].prop_item)
        local get_prop_num = tonumber(self.data[i].item_value) 
        local cell = nil 
        if tonumber(self.data[i].prop_type) ~= 13 then
            --checkPlayEffect(57)
            cell = state_machine.excute("props_icon_create_cell",0,{9,1,get_prop_id,1,get_prop_num,true})
        else
            --checkPlayEffect(58)
            cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, get_prop_id, 3, get_prop_num,true})
        end
        Panel_leader_get_icon:addChild(cell)
    end
end

function RedAlertTimeLeaderSeniorTen:showActionAni( state )
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

function RedAlertTimeLeaderSeniorTen:createEffect( panel, index )
    local armature = ccs.Armature:create("effice_recruit_get_light")
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    panel:addChild(armature)
    armature:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
    armature:getAnimation():playWithIndex(0)
    if tonumber(self.data[index].prop_type) == 13 then
        local armature1 = ccs.Armature:create("effect_luck_draw")
        draw.initArmature(armature1, nil, -1, 0, 1)
        armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        panel:addChild(armature1)
        armature1:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
        armature1:getAnimation():playWithIndex(0)
    end
end

function RedAlertTimeLeaderSeniorTen:onUpdateDraw(  )
    local reward_data = getSceneReward(1000 + tonumber(self._activity_type))
    self.data = reward_data.show_reward_list
    local root = self.roots[1]

    -- 折扣
    local Text_leader_draw_get_10_discount = ccui.Helper:seekWidgetByName(root,"Text_leader_draw_get_10_discount")
    local curr = tonumber(self.discount)
    curr = math.round(curr)
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr = (10 - curr) * 10
    end
    local discounts = string.format(activity_str_tip[22],""..curr)
    Text_leader_draw_get_10_discount:setString(discounts)
    -- 10次折后价
    local Text_recruit_gold_n = ccui.Helper:seekWidgetByName(root,"Text_recruit_gold_n")
    Text_recruit_gold_n:setString(self.need_gold)
    -- 10次现价
    local Text_ten_get_10_consume_discount_n = ccui.Helper:seekWidgetByName(root,"Text_ten_get_10_consume_discount_n")
    Text_ten_get_10_consume_discount_n:setString(self.need_gold_old)

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
    end
    self:playAction()
end

function RedAlertTimeLeaderSeniorTen:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_recruit_get_ten)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_text)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_luck_draw)

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
            state_machine.excute("red_alert_time_leader_senior_ten_update_ani_state", 0, 1)
        elseif str == "ani_leader_get_icon_2" then
            state_machine.excute("red_alert_time_leader_senior_ten_update_ani_state", 0, 2)
        elseif str == "ani_leader_get_icon_3" then
            state_machine.excute("red_alert_time_leader_senior_ten_update_ani_state", 0, 3)
        elseif str == "ani_leader_get_icon_over" then
            
        end
    end)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_senior_recruit"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_ten_recruit", 
        terminal_state = 0, 
       	touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recruit_sure"), nil, 
    {
        terminal_name = "red_alert_time_leader_senior_ten_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)
    
    self:onUpdateDraw()
end

function RedAlertTimeLeaderSeniorTen:onEnterTransitionFinish()

end

function RedAlertTimeLeaderSeniorTen:init(params)
    self._activity_type = params[1]
    self.need_gold = params[2]
    self.need_gold_old = params[3]
    self.discount = params[4]
	self:onInit()
    return self
end

function RedAlertTimeLeaderSeniorTen:onExit()
    state_machine.remove("red_alert_time_leader_senior_ten_sure_recruit")
    state_machine.remove("red_alert_time_leader_senior_ten_update_draw")
    state_machine.remove("red_alert_time_leader_senior_ten_update_ani_state")
    state_machine.remove("red_alert_time_leader_senior_ten_update_button")
    state_machine.remove("red_alert_time_leader_senior_ten_recruit")
end