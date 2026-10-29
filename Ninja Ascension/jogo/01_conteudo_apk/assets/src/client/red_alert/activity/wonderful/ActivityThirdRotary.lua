-----------------------------
--签到抽奖
-----------------------------
ActivityThirdRotary = class("ActivityThirdRotaryClass", Window)

local activity_third_rotary_window_open_terminal = {
    _name = "activity_third_rotary_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityThirdRotaryClass") then
            fwin:open(ActivityThirdRotary:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_third_rotary_window_close_terminal = {
    _name = "activity_third_rotary_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ActivityThirdRotaryClass"))    
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_third_rotary_window_open_terminal)
state_machine.add(activity_third_rotary_window_close_terminal)
state_machine.init()

function ActivityThirdRotary:ctor()
    self.super:ctor()
    self.roots = {}

    self._panel_list = {}
    self._image_list = {}

    self._round = 0

    local function init_activity_third_rotary_terminal()
		local activity_third_rotary_get_reward_terminal = {
            _name = "activity_third_rotary_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local infos = zstring.split(zstring.split(_ED.activity_info["21"].activity_add_state, "|")[1], ",")
                if tonumber(infos[3]) <= 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[179])
                    return
                end
                state_machine.lock("activity_third_rotary_get_reward")
                state_machine.lock("activity_third_rotary_window_close")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:beginRotary()
                        else
                            state_machine.unlock("activity_third_rotary_get_reward")
                            state_machine.unlock("activity_third_rotary_window_close")
                        end
                    else
                        state_machine.unlock("activity_third_rotary_get_reward")
                        state_machine.unlock("activity_third_rotary_window_close")
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["21"].activity_id .. "\r\n21\r\n1\r\n0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(activity_third_rotary_get_reward_terminal)	
        state_machine.init()
    end
    
    init_activity_third_rotary_terminal()
end

function ActivityThirdRotary:endRotary( ... )
    self._round = 0
    state_machine.unlock("activity_third_rotary_get_reward")
    state_machine.unlock("activity_third_rotary_window_close")
    -- state_machine.excute("reward_obtain_window_open", 0, {1021})
    state_machine.excute("activity_third_sign_update_rotary_times", 0, nil)
    -- self:onUpdateDraw()
    local function playActionOne(sender)
        if sender.roots ~= nil then
            sender:stopAllActions()
            sender:onUpdateDraw()
        end
        state_machine.excute("reward_obtain_window_open", 0, {1021})
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end

function ActivityThirdRotary:beginRotary( ... )
    local root = self.roots[1]
    local index = 0
    local delayTime = 0
    local max_times = 0
    self._round = self._round + 1
    if self._round == 1 then
        delayTime = 0.003
        max_times = 20
    elseif self._round == 2 then
        delayTime = 0.005
        max_times = 10
    elseif self._round == 3 then
        delayTime = 0.008
        max_times = 10 + tonumber(_ED.activity_rotary_index) - 1
    end

    local function playActionOne(sender)
        index = index + 1
        if index > max_times then
            sender:stopAllActions()
            if sender._round ~= 3 then
                sender:beginRotary()
            else
                sender:endRotary()
            end
        else
            local cell_index = math.floor(index%10)
            for k,v in pairs(sender._image_list) do
                if k == cell_index + 1 then
                    v:setVisible(false)
                else
                    v:setVisible(true)
                end
            end
        end
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(delayTime),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end

function ActivityThirdRotary:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info["21"]
    local rotary_group = zstring.split(activity_info.activity_add_state, "|")[3]
    local state_info = zstring.split(zstring.split(activity_info.activity_add_state, "|")[2], ",")
    
    local reward_info = zstring.split(dms.string(dms["every_three_round_group"], rotary_group, every_three_round_group.reward_info), "|")
    self._panel_list = {}
    self._image_list = {}
    for i=1,10 do
        local panel = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
        local image = ccui.Helper:seekWidgetByName(root,"Image_reward_get_"..i)
        panel:removeAllChildren(true)
        image:setVisible(false)
        table.insert(self._panel_list, panel)
        table.insert(self._image_list, image)

        local info = zstring.split(reward_info[i], ",")
        local data = 
        {
            item_value = info[3],
            prop_type = info[2],
            prop_item = info[1],
        }
        local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        panel:addChild(cell)
        if tonumber(state_info[i]) == 1 then
            ccui.Helper:seekWidgetByName(root,"Image_yiqiandao_"..i):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root,"Image_yiqiandao_"..i):setVisible(false)
        end
        
        -- local armature = ccs.Armature:create("effice_icon_box_light")
        -- draw.initArmature(armature, nil, -1, 0, 1)
        -- armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        -- csb.animationChangeToAction(armature, 0, 0, false)
        -- panel:addChild(armature)
        -- armature:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
    end
    local Text_now_have_v = ccui.Helper:seekWidgetByName(root,"Text_now_have_v")
    local Text_now_spend_v = ccui.Helper:seekWidgetByName(root,"Text_now_spend_v")
    local Text_activity_limit_time_v = ccui.Helper:seekWidgetByName(root,"Text_activity_limit_time_v")
    local infos = zstring.split(zstring.split(activity_info.activity_add_state, "|")[1], ",")
    Text_now_have_v:setString(""..infos[3])
    Text_now_spend_v:setString("1")
    -- Text_activity_limit_time_v:setString("")
end

function ActivityThirdRotary:onEnterTransitionFinish()

end

function ActivityThirdRotary:onInit( )
    -- local effect_paths = "images/ui/effice/effice_icon_box_light/effice_icon_box_light.ExportJson"
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    local csbItem = csb.createNode(config_csb.activity.wonderful.activity_third_rotary)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "activity_third_rotary_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choujaing"), nil, 
    {
        terminal_name = "activity_third_rotary_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()
end

function ActivityThirdRotary:init()
	self:onInit()
    return self
end

function ActivityThirdRotary:onExit()
    -- local effect_paths = "images/ui/effice/effice_icon_box_light/effice_icon_box_light.ExportJson"
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    state_machine.remove("activity_third_rotary_get_reward")
end
