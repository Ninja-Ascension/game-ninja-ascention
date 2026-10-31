-- ------------------------------------------------------------------------------------------------------------
--  说明：远征
-- ------------------------------------------------------------------------------------------------------------
Expedition = class("ExpeditionClass", Window)

--打开界面
local expedition_window_open_terminal = {
	_name = "expedition_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = Expedition:new():init(params)
        fwin:open(panel)  
	    return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(expedition_window_open_terminal)
state_machine.init()

function Expedition:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    -- 场景id
    self._scene_id = 0
    -- 开启npc数量
    self._npc_index = 0
	
	self.old_npc_index = 0
	self.armature = nil
    self.m_times = 0
    self.activity_add = 0

    app.load("client.red_alert_time.campaign.ExpeditionRuleInfor")

    local function init_expedition_terminal()
        local expedition_show_terminal = {
            _name = "expedition_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local expedition_hide_terminal = {
            _name = "expedition_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local expedition_rule_infor_terminal = {
            _name = "expedition_rule_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("expedition_rule_infor_window_open",0,2)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local expedition_update_draw_terminal = {
            _name = "expedition_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local update_position = params
                instance:updateDraw(update_position)
                instance:updateDrawNpcPath(true)
                state_machine.excute("expedition_shop_update_integral", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置
        local expedition_reset_terminal = {
            _name = "expedition_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isHaveOtherShip = false
                local isHaveReward = false
                local isHavePass = true
                for k,v in pairs(_ED.user_ship) do
                    if tonumber(v.captain_type) ~= 3 then
                        local last_count = zstring.tonumber(v.current_count) - zstring.tonumber(v.expedition_lose_count)
                        if last_count > 0 then
                            isHaveOtherShip = true
                            break
                        end
                    end
                end

                local npcs = zstring.split(_ED.user_expedition_info.current_state, ",")
                for k, v in pairs(npcs) do
                    if tonumber(v) == 1 then
                        isHaveReward = true
                        break
                    elseif tonumber(v) ~= 2 then
                        isHavePass = false
                    end
                end

                if isHaveReward == true then
                    TipDlg.drawTextDailog(red_alert_time_str[211])
                    return
                end

                if isHaveOtherShip == false 
                    or (isHavePass == true and isHaveReward == false)
                    then
                    instance:sureReset(0)
                else
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureReset, red_alert_time_str[202])
                    fwin:open(tip, fwin._windows) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 扫荡
        local expedition_sweep_terminal = {
            _name = "expedition_sweep",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(_ED.vip_grade) < 4 then
                    TipDlg.drawTextDailog(red_alert_time_str[291])
                    return
                end
                local npcs = zstring.split(_ED.user_expedition_info.current_state, ",")
                local max_state = tonumber(_ED.user_expedition_info.max_state) + 1
                local sweep_count = math.floor(max_state * dms.float(dms["expedition_config"], 6, expedition_config.param))
                if sweep_count == 0 or (npcs[sweep_count] ~= nil and tonumber(npcs[sweep_count]) > 0) then
                    TipDlg.drawTextDailog(red_alert_time_str[292])
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end
                protocol_command.expedition_sweep.param_list = ""
                NetworkManager:register(protocol_command.expedition_sweep.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local expedition_get_all_reward_terminal = {
            _name = "expedition_get_all_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local have_reward = false
                local npcs = zstring.split(_ED.user_expedition_info.current_state, ",")
                for k, v in pairs(npcs) do
                    if tonumber(v) == 1 then
                        have_reward = true
                        break
                    end
                end
                if have_reward == false then
                    TipDlg.drawTextDailog(red_alert_time_str[290])
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                            checkRewardObtainDraw()
                    end
                end
                protocol_command.draw_expedition_reward.param_list = "-1"
                NetworkManager:register(protocol_command.draw_expedition_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(expedition_show_terminal)
        state_machine.add(expedition_hide_terminal)
        state_machine.add(expedition_rule_infor_terminal)
        state_machine.add(expedition_update_draw_terminal)
        state_machine.add(expedition_reset_terminal)
        state_machine.add(expedition_sweep_terminal)
        state_machine.add(expedition_get_all_reward_terminal)
        state_machine.init()
    end
    
    init_expedition_terminal()
end

function Expedition:clearNpcPath()
    if self.armature ~= nil then
        self.armature:removeFromParent(true)
        self.armature = nil
    end
end

function Expedition:sureReset(suer_number)
    local reset_times = dms.int(dms["base_consume"], 94, base_consume.vip_0_value + tonumber(_ED.vip_grade)) + self.activity_add
    local have_reset_times = reset_times - _ED.user_expedition_info.reset_enemy_count
    if have_reset_times <= 0 then
        TipDlg.drawTextDailog(red_alert_time_str[233])
        return
    end

    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                state_machine.excute("notification_center_update", 0, "push_notification_campaign_expedition")
                response.node:clearNpcPath()
                response.node:updateDraw()
                response.node:updateDrawNpcPath(false)
            end
            state_machine.excute("campaign_list_update", 0, "")
        end
    end
    if suer_number == 0 then
        protocol_command.expedition_reset.param_list = ""
        NetworkManager:register(protocol_command.expedition_reset.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function Expedition:updateDraw(update_position)
    --计算火线支援活动加层
    local activity_add = 0
    if _ED.activity_info["91"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["91"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            activity_add = timesData[4]
        end
    end
    self.activity_add = activity_add

    local root = self.roots[1]
    local Text_expedition_integral_n = ccui.Helper:seekWidgetByName(root,"Text_expedition_integral_n")
    local Text_expedition_reset_n = ccui.Helper:seekWidgetByName(root,"Text_expedition_reset_n")
    local Button_expedition_reset = ccui.Helper:seekWidgetByName(root,"Button_expedition_reset")
    local reset_times = dms.int(dms["base_consume"], 94, base_consume.vip_0_value + tonumber(_ED.vip_grade)) + activity_add
    local have_reset_times = reset_times - _ED.user_expedition_info.reset_enemy_count
    have_reset_times = math.max(have_reset_times,0)
    Text_expedition_reset_n:setString(have_reset_times)
    Text_expedition_integral_n:setString(_ED.user_expedition_info.current_score)

    local ScrollView_map = ccui.Helper:seekWidgetByName(root,"ScrollView_map")
    if update_position ~= false then
        ScrollView_map:jumpToBottom()
    end

    -- local isHaveFinishEd = false
    -- local npcs = zstring.split(_ED.user_expedition_info.current_state, ",")
    -- for k, v in pairs(npcs) do
    --     if tonumber(v) > 0 then
    --         isHaveFinishEd = true
    --         break
    --     end
    -- end
    -- Button_expedition_reset:setTouchEnabled(true)
    -- Button_expedition_reset:setBright(true)
    -- if isHaveFinishEd == false then
    --     Button_expedition_reset:setTouchEnabled(false)
    --     Button_expedition_reset:setBright(false)
    -- end

    local npcs = zstring.split(_ED.user_expedition_info.current_state, ",")
    local ty = nil
    local ly = nil
    for i=1,#npcs do
        local Panel_js = ccui.Helper:seekWidgetByName(root, "Panel_js_"..i)
        if Panel_js ~= nil then
            Panel_js:removeAllChildren(true)
            if npcs[i] ~= nil then
                if tonumber(npcs[i]) >= 0 then
                    self._npc_index = i
                end
                local cell = state_machine.excute("expedition_pve_npc_create_cell", 0, {i, npcs[i]})
				cell:setTag(i)
                Panel_js:addChild(cell)
                local y = Panel_js:getPositionY()
                if tonumber(npcs[i]) == 0 then
                    ty = y
                else
                    ly = y
                end
            end
        end
    end

    local size = ScrollView_map:getInnerContainer():getContentSize()
    local viewSize = ScrollView_map:getContentSize()
    local centerPosition = cc.p(viewSize.width / 2, viewSize.height / 2)
    if ty == nil then
        ty = ly
    end
    if ty > centerPosition.y then
        local my = ty - centerPosition.y
        local mmy = viewSize.height - size.height
        my = -1 * my
        if my < mmy then
            my = mmy
        end
        if update_position ~= false then
            ScrollView_map:getInnerContainer():setPositionY(my)
        end
    end
end

function Expedition:updateDrawNpcPathThree()
	local root = self.roots[1]
	local Panel_jsNew = ccui.Helper:seekWidgetByName(root, "Panel_js_"..self._npc_index)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effcet_npc_open_light/effcet_npc_open_light.ExportJson")
	local armature2 = ccs.Armature:create("effcet_npc_open_light")
	armature2:getAnimation():playWithIndex(0)
	armature2:setPosition(Panel_jsNew:getContentSize().width/2,Panel_jsNew:getContentSize().height/2)
	Panel_jsNew:addChild(armature2,-1)

end

function Expedition:updateDrawNpcPathTwo(isShow)
	local root = self.roots[1]
	local Panel_line_effect = ccui.Helper:seekWidgetByName(root, "Panel_line_effect")
	local effect_paths = config_res.images.ui.effice.effect_pve_map_line
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
	
    if __lua_project_id == __lua_project_pacific_rim then
        if self.armature == nil then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_pve_map_line2)
            self.armature = ccs.Armature:create("effect_pve_map_line2")
        end
    else
    	if self.armature == nil then
    		self.armature = ccs.Armature:create("effect_pve_map_line")
    	end
    end

    if isShow == false then
	    draw.initArmatureTwo(self.armature, nil, -1, 0, 1, 0)
	    self.armature:getAnimation():gotoAndPause((self._npc_index - 1)*30)
	else
	    self.armature:getAnimation():gotoAndPlay((self._npc_index - 2)*30)
	end
	
	
	self.armature:setPosition(cc.p(Panel_line_effect:getContentSize().width/2, Panel_line_effect:getContentSize().height/2))
	local isover = false
	local index = 0 
	if isShow == false then
		Panel_line_effect:addChild(self.armature)
	end
	
	if isShow == false then
		return
	end
	-- local Panel_jsNew = ccui.Helper:seekWidgetByName(root, "Panel_js_"..self._npc_index):setVisible(true)
	-- if Panel_jsNew._y == nil then
	-- 	Panel_jsNew._y = Panel_jsNew:getPositionY()
	-- end
	-- Panel_jsNew:setPositionY(Panel_jsNew:getPositionY()+100)
	function blinkOutCallback1(sender)
		-- self:updateDrawNpcPathThree()
		self.armature:getAnimation():gotoAndPause((self._npc_index - 1)*30)
	end
    blinkOutCallback1()

	-- Panel_jsNew:runAction(cc.Sequence:create(
	-- 			cc.MoveTo:create(0.3, cc.p(Panel_jsNew:getPositionX(), Panel_jsNew:getPositionY()-50)),
	-- 			cc.MoveTo:create(0.1, cc.p(Panel_jsNew:getPositionX(), Panel_jsNew._y)),
	-- 			cc.CallFunc:create(blinkOutCallback1)
	-- 			))	
end

function Expedition:updateDrawNpcPath(isShow)
	if isShow == false then
		self.old_npc_index = self._npc_index
		self:updateDrawNpcPathTwo(isShow)
		isShow = true
		return
	end
    if self.old_npc_index == self._npc_index then
        return
    end
	local root = self.roots[1]
	if self.old_npc_index == self._npc_index then
		
		return
	end
	
	local Panel_js = ccui.Helper:seekWidgetByName(root, "Panel_js_"..self._npc_index-1)	
	 
	function blinkOutCallback1(sender)
		self:updateDrawNpcPathTwo()
	end

	Panel_js:runAction(cc.Sequence:create(
			cc.DelayTime:create(1),
			cc.CallFunc:create(blinkOutCallback1)
			))		
	
end

function Expedition:onInit()
    local csbItem = csb.createNode(config_csb.campaign.expedition)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_expedition_help"), nil, 
    {
        terminal_name = "expedition_rule_infor",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    -- 重置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_expedition_reset"), nil, 
    {
        terminal_name = "expedition_reset",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_campaign_expedition",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_expedition_reset"),
    _id = 2,
    _invoke = nil,
    _interval = 0.2,})

    -- 扫荡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_expedition_sweep"), nil, 
    {
        terminal_name = "expedition_sweep",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_expedition_key_receive"), nil, 
    {
        terminal_name = "expedition_get_all_reward",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    local ScrollView_map = ccui.Helper:seekWidgetByName(root1, "ScrollView_map")
    if nil ~= ScrollView_map then
        local Image_pve_1 = ccui.Helper:seekWidgetByName(root1, "Image_pve_1")
        if nil ~= Image_pve_1 then
            local ssize = Image_pve_1:getContentSize()
            ScrollView_map:setInnerContainerSize(ssize)
        end
    end

    self:updateDraw()
    self:updateDrawNpcPath(false)
    
end

function Expedition:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("expedition_update_draw",0,"")
        end
    end
end

function Expedition:onEnterTransitionFinish()

end

function Expedition:init(param)
    self._rootWindows = param[1]
    self._scene_id = 1
	self:onInit()
    return self
end

function Expedition:onExit()
    state_machine.remove("expedition_show")
    state_machine.remove("expedition_hide")
    state_machine.remove("expedition_rule_infor")
    state_machine.remove("expedition_update_draw")
    state_machine.remove("expedition_reset")
    state_machine.remove("expedition_sweep")
    state_machine.remove("expedition_get_all_reward")
end
