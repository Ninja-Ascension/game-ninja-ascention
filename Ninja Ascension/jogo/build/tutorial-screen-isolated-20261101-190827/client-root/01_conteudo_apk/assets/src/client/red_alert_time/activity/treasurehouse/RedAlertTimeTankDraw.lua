-----------------------------
--战地机甲和坦克拉霸
-----------------------------
RedAlertTimeTankDraw = class("RedAlertTimeTankDrawClass", Window)

local red_alert_time_tank_draw_window_open_terminal = {
    _name = "red_alert_time_tank_draw_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeTankDrawClass") then
			fwin:open(RedAlertTimeTankDraw:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_tank_draw_window_close_terminal = {
    _name = "red_alert_time_tank_draw_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeTankDrawClass"))
        _ED.show_reward_list_group_ex = {}
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_tank_draw_window_open_terminal)
state_machine.add(red_alert_time_tank_draw_window_close_terminal)
state_machine.init()

function RedAlertTimeTankDraw:ctor()
    self.super:ctor()
    self.roots = {}
    self.schedulerID = nil
    self.stopCount = 0

    self.isOver = true
    self.isCanSpeedUp = true

    self.m_times = 0
    self.have_free_times = false

    --load lua file
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeCongratulationsGet")
    app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
    -- Initialize red_alert_time_tank_draw state machine.
    local function init_red_alert_time_tank_draw_terminal()
        
        -- 50抽取
        local red_alert_time_tank_draw_lottery50_terminal = {
          _name = "red_alert_time_tank_draw_lottery50",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                _ED.tank_draw_lottery = true
                local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            -- checkPlayEffect(67)
                            -- state_machine.lock("red_alert_time_tank_draw_lottery")
                            -- ccui.Helper:seekWidgetByName(instance.roots[1],"Button_senior_recruit"):setTouchEnabled(false)
                            -- ccui.Helper:seekWidgetByName(instance.roots[1],"Button_tank_draw_10"):setTouchEnabled(false)
                            -- ccui.Helper:seekWidgetByName(instance.roots[1],"Button_tank_draw_50"):setTouchEnabled(false)
                            instance:startRound()
                            instance:updateButton()
                            state_machine.excute("home_map_update_build", 0, nil)
                            state_machine.lock("red_alert_time_tank_draw_window_close")
                        end
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n2"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
        -- 抽取
        local red_alert_time_tank_draw_lottery_terminal = {
          _name = "red_alert_time_tank_draw_lottery",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                _ED.tank_draw_lottery = true
                if instance.isOver == false then
                    instance:skipAnimation()
                    return
                end

				local m_type = params._datas._type
                if tonumber(m_type) > 0 and instance.have_free_times == true then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    return
                end

                if tonumber(m_type) == 2 then
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_tank_draw_50_2"):getString(), m_type = 16}})
                    return
                end
				local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
                            -- checkPlayEffect(67)
							-- state_machine.lock("red_alert_time_tank_draw_lottery")
                            -- ccui.Helper:seekWidgetByName(instance.roots[1],"Button_senior_recruit"):setTouchEnabled(false)
                            -- ccui.Helper:seekWidgetByName(instance.roots[1],"Button_tank_draw_10"):setTouchEnabled(false)
                            -- ccui.Helper:seekWidgetByName(instance.roots[1],"Button_tank_draw_50"):setTouchEnabled(false)
							instance:startRound()
                            instance:updateButton()
							state_machine.excute("home_map_update_build", 0, nil)
                            state_machine.lock("red_alert_time_tank_draw_window_close")
						end
					end
				end		
				
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n"..m_type
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         -- 详情
        local red_alert_time_tank_draw_infor_terminal = {
          _name = "red_alert_time_tank_draw_infor",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_tank_draw_reward_window_open", 0, {instance._activity_type})
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
        
        state_machine.add(red_alert_time_tank_draw_lottery_terminal)
        state_machine.add(red_alert_time_tank_draw_infor_terminal)
        state_machine.add(red_alert_time_tank_draw_lottery50_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_tank_draw state machine.
    init_red_alert_time_tank_draw_terminal()
end

function RedAlertTimeTankDraw:replaceSkeleton(index)
	-- debug.print_r(self._activity_type)
	local root = self.roots[1]
	local activity_info = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_optimal_tank = zstring.split(activity_info[#activity_info],",")
	-- for i=1,3 do
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_tank_draw_effect_"..index)
		local cell = panel:getChildByTag(100)
		for k=2,2 do
            local All_icon = dms.string(dms["ship_mould"], activity_optimal_tank[index], ship_mould.All_icon)
            local icon_name = string.format(config_res.images.ui.props.tank, All_icon)
            local icon = ccs.Skin:create(icon_name)
            cell:getBone("Layer_tank_"..k):addDisplay(icon, 0)
        end
	-- end
end

-- 跳过动画
function RedAlertTimeTankDraw:skipAnimation()
    local root = self.roots[1]
    for i=1,3 do
        self:replaceSkeleton(self.ArmatureNodes[i].index)
        self.ArmatureNodes[i]:getAnimation():gotoAndPause(0)
        self.ArmatureNodes[i]._over = false
        self.ArmatureNodes[i]._number = 0
        self.ArmatureNodes[i]._nextAction = 0
    end

    checkPlayEffect(67)
    self.isOver = true
    self.isCanSpeedUp = true
    state_machine.excute("red_alert_time_congratulations_get_window_open", 0, self._activity_type.activity_type)
    self:updateButton()
    state_machine.unlock("red_alert_time_tank_draw_window_close")
end

function RedAlertTimeTankDraw:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_optimal_tank = zstring.split(activity_info[2],",")
    local activity_optimal_one = zstring.split(activity_info[#activity_info],",")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_act_tank_draw)
    self.ArmatureNodes = {}
    for i=1,3 do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_tank_draw_effect_"..i)
        panel:removeAllChildren(true)
        panel:removeBackGroundImage()
        local cell = ccs.Armature:create("effect_act_tank_draw")
        cell:getAnimation():playWithIndex(0)
        cell:setAnchorPoint(0.5,0.5)
        cell.index = i
		cell._number = 0
		cell._over = false
        table.insert(self.ArmatureNodes,cell)
        for k=1,4 do
            local All_icon = dms.string(dms["ship_mould"], activity_optimal_tank[k], ship_mould.All_icon)
            if k == 2 then
                All_icon = dms.string(dms["ship_mould"], activity_optimal_one[i], ship_mould.All_icon)
            end
            local icon_name = string.format(config_res.images.ui.props.tank, All_icon)
            local icon = ccs.Skin:create(icon_name)
            cell:getBone("Layer_tank_"..k):addDisplay(icon, 0)
        end
        cell:setPosition(cc.p(panel:getContentSize().width/2,panel:getContentSize().height/2))
		cell:setTag(100)
        panel:addChild(cell)
    end
	local function resetOver_changeActionCallback(armatureBack)
		local armature = armatureBack
		if armature ~= nil then
			local actionIndex = armature._actionIndex
			if actionIndex == 0 then
				-- armature._nextAction = 1
                if tonumber(armature.index) == 3 and armature._over ~= false then
                    -- self.isOver = true
                    self.isOver = true
                    self.isCanSpeedUp = true
                    armature._over = false
                    checkPlayEffect(67)
                    state_machine.excute("red_alert_time_congratulations_get_window_open", 0, self._activity_type.activity_type)
                    self:updateButton()
                    state_machine.unlock("red_alert_time_tank_draw_window_close")
                end
                if armature._over ~= false then
                    armature._over = false
                    checkPlayEffect(67)
                end
			elseif actionIndex == 1 then
				armature._number = armature._number + 1
				if armature._number <= 4 then
					armature._nextAction = 1
				else
					armature._nextAction = 2
				end
			elseif actionIndex == 2 then
                armature._number = 0
				armature._nextAction = 0
				armature._over = true
                self.isCanSpeedUp = false
			end
		end
	end
	
	local function drawFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
		local armature = bone:getArmature()
		if evt == "change1" then
			if armature._number == 3 then
				self:replaceSkeleton(armature.index)
			end
		end
	end
		
	for i=1,3 do	
		-- self.ArmatureNodes[i]:getAnimation():playWithIndex(1)
		self.ArmatureNodes[i]:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		self.ArmatureNodes[i]._actionIndex = 0
		self.ArmatureNodes[i]._nextAction = 0
		self.ArmatureNodes[i]._invoke = resetOver_changeActionCallback
		self.ArmatureNodes[i]:getAnimation():setFrameEventCallFunc(drawFrameEvent)
	end
	
    self:onUpdateDrawInfo()
    self:updateButton()
end

function RedAlertTimeTankDraw:updateButton()
    local root = self.roots[1]
    local Button_tank_draw_1 = ccui.Helper:seekWidgetByName(root,"Button_tank_draw_1")
    local Button_senior_recruit = ccui.Helper:seekWidgetByName(root,"Button_senior_recruit")
    local Image_senior_recruit_icon = ccui.Helper:seekWidgetByName(root,"Image_senior_recruit_icon")
    local Text_tank_draw_1_1 = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_1_1")

    local activity_info = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_info[1],",")
    Button_tank_draw_1:setVisible(false)
    Button_senior_recruit:setVisible(false)
    Image_senior_recruit_icon:setVisible(false)
    Text_tank_draw_1_1:setString("")
    if tonumber(activity_add_state[7]) >= tonumber(activity_add_state[8]) then
        Button_senior_recruit:setVisible(true)
        Image_senior_recruit_icon:setVisible(true)
        Text_tank_draw_1_1:setString(activity_add_state[4])
        self.have_free_times = false
    else
        Button_tank_draw_1:setVisible(true)
        self.have_free_times = true
    end
end

function RedAlertTimeTankDraw:onUpdateDrawInfo()
    local root = self.roots[1]
    -- 活动名
    local Text_draw_name = ccui.Helper:seekWidgetByName(root,"Text_draw_name")
    Text_draw_name:setString(self._activity_type.activity_title)
    -- 描述
    local Text_tank_draw_infor_p = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_infor_p")
    Text_tank_draw_infor_p:setString(self._activity_type.activity_dec)
    -- 时间
    local Text_tank_draw_time = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_time")
    Text_tank_draw_time:removeAllChildren(true)
    local Text_tank_draw_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_act_time_1")
    Text_tank_draw_act_time_1:setString("")
    Text_tank_draw_act_time_1:removeAllChildren(true)
    local Text_tank_draw_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_act_time_2")
    Text_tank_draw_act_time_2:setString("")
    Text_tank_draw_act_time_2:removeAllChildren(true)
    local activity_info = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_info[1],",")
    local startTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[1] / 1000))
    local endTime = os.date("%m.%d".." ".."%H:%M", zstring.exchangeFrom(activity_add_state[2] / 1000-1))

    local font_size = Text_tank_draw_act_time_1:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_tank_draw_act_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_tank_draw_act_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_tank_draw_act_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_tank_draw_act_time_1:addChild(time_int_1)

    local time_info_2 = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_tank_draw_act_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_tank_draw_act_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_tank_draw_act_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_tank_draw_act_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_tank_draw_act_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_tank_draw_act_time_2:addChild(time_int_2)

    -- 抽取
    local Button_tank_draw_1 = ccui.Helper:seekWidgetByName(root,"Button_tank_draw_1")
    local Button_senior_recruit = ccui.Helper:seekWidgetByName(root,"Button_senior_recruit")
    local Image_senior_recruit_icon = ccui.Helper:seekWidgetByName(root,"Image_senior_recruit_icon")
    local Text_tank_draw_1_1 = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_1_1")
    local Text_tank_draw_10_2 = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_10_2")
    local Text_tank_draw_10_1 = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_10_1")
    local Text_tank_draw_50_2 = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_50_2")
    local Text_tank_draw_50_1 = ccui.Helper:seekWidgetByName(root,"Text_tank_draw_50_1")
    Button_tank_draw_1:setVisible(false)
    Button_senior_recruit:setVisible(false)
    Image_senior_recruit_icon:setVisible(false)
    Text_tank_draw_1_1:setString("")
    if tonumber(activity_add_state[7]) >= tonumber(activity_add_state[8]) then
        Button_senior_recruit:setVisible(true)
        Image_senior_recruit_icon:setVisible(true)
        Text_tank_draw_1_1:setString(activity_add_state[4])
    else
        Button_tank_draw_1:setVisible(true)
    end
    Text_tank_draw_10_2:setString(math.ceil(activity_add_state[4]*10*activity_add_state[5]))
    Text_tank_draw_10_1:setString(activity_add_state[4]*10)
    Text_tank_draw_50_2:setString(math.ceil(activity_add_state[4]*50*activity_add_state[6]))
    Text_tank_draw_50_1:setString(activity_add_state[4]*50)

    -- 本期最佳
    local activity_optimal_tank = zstring.split(activity_info[2],",")
    for i=1,#activity_optimal_tank do
        local Panel_tank_draw_best_icon = ccui.Helper:seekWidgetByName(root, "Panel_tank_draw_best_icon_"..i)
        Panel_tank_draw_best_icon:removeAllChildren(true)
        local cell = state_machine.excute("props_icon_create_cell",0,{1, 10, activity_optimal_tank[i], 3})
        Panel_tank_draw_best_icon:addChild(cell)
    end

    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
end

function RedAlertTimeTankDraw:onUpdate(dt)
    if self.m_times > 0 and self.isOver == true then
        self.m_times = self.m_times - dt
        -- if ccui.Helper:seekWidgetByName(self.roots[1],"Text_tank_draw_time"):getChildByTag(100) ~= nil then
        --     if self.accept_the_prize == false then
        --         ccui.Helper:seekWidgetByName(self.roots[1],"Text_tank_draw_time"):getChildByTag(100):setString(string.format(activity_str_tip[75],getRedAlertTimeFormat(self.m_times)))
        --     else
        --         ccui.Helper:seekWidgetByName(self.roots[1],"Text_tank_draw_time"):getChildByTag(100):setString(string.format(activity_str_tip[62],getRedAlertTimeFormat(self.m_times)))
        --     end
        -- end
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_tank_draw_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_tank_draw_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        local server_time = getCurrentGTM8Time()
        local leave_time = 86400 - (server_time.hour * 3600 + server_time.min * 60 + server_time.sec)
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_tank_draw_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_tank_draw_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(leave_time))
        end
        if leave_time <= 0 then
            self:onUpdateDraw()
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_tank_draw_window_close")
            -- state_machine.excute("red_alert_time_tank_draw_window_close",0,self._activity_type.activity_type)
        end
    end
end

--开始转动
function RedAlertTimeTankDraw:startRound()
    self.isOver = false
	for i=1,3 do
        self.ArmatureNodes[i]:getAnimation():playWithIndex(0)
		local function startRoundFuncN(sender)
            if self.isOver == false then
    			self.ArmatureNodes[i]._nextAction = 1
            end
		end
		self.ArmatureNodes[i]:runAction(cc.Sequence:create(
        cc.DelayTime:create((i-1)/2),
        cc.CallFunc:create(startRoundFuncN)))
	end	
    -- local scheduler = cc.Director:getInstance():getScheduler()
    -- if self.schedulerID ~= nil then 
        -- cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)      
    -- end
    -- self.schedulerID= nil  
    -- local  timer = 0
    -- self.stopCount = 0
    -- self.schedulerID = scheduler:scheduleScriptFunc(function ()
        -- if self.roots[1] ~= nil then 
            -- self:stopRound()
        -- end
        -- cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)      
    -- end,5,false) 
    -- local root = self.roots[1]
	-- self:replaceSkeleton()
    -- for i=1,3 do
        -- local function startRoundFuncN(sender)
            -- --播放转动
            -- draw.initArmature(self.ArmatureNodes[i], nil, -1, 0, 1)     
            -- csb.animationChangeToAction(self.ArmatureNodes[i], 1, 1, false)
            -- -- self.ArmatureNodes[i]:resume()
            -- -- self.ArmatureNodes[i]:setVisible(true)
            -- local panel = ccui.Helper:seekWidgetByName(root, "Panel_tank_draw_effect_"..i)
            -- -- panel:removeBackGroundImage()
            -- self.ArmatureNodes[i]._roundPanel = panel
        -- end
        -- self.ArmatureNodes[i]:runAction(cc.Sequence:create(
        -- cc.DelayTime:create((i-1)/2),
        -- cc.CallFunc:create(startRoundFuncN)))

    -- end
end

local function onRoundFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
    local armature = bone:getArmature()
    local stopEvent = "stop"--.. armature._stopNumbers[zstring.tonumber(armature.index)]
    -- local stopIndex = armature._stopNumbers[zstring.tonumber(armature.index)]
    if evt ~= nil and evt == stopEvent then
        armature:pause()
        -- armature:setVisible(false)
        -- armature._roundPanel:setBackGroundImage(string.format(config_res.images.ui.icon.icon, stopIndex))
    end
end

function RedAlertTimeTankDraw:onEnterTransitionFinish()

end

function RedAlertTimeTankDraw:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.tank_draw)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tank_draw_close"), nil, 
    {
        terminal_name = "red_alert_time_tank_draw_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    -- 免费抽取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tank_draw_1"), nil, 
    {
        terminal_name = "red_alert_time_tank_draw_lottery", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
        _type = 0,
    }, nil, 1)

    -- 单次抽取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_senior_recruit"), nil, 
    {
        terminal_name = "red_alert_time_tank_draw_lottery", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
        _type = 0,
    }, nil, 1)

    -- 抽十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tank_draw_10"), nil, 
    {
        terminal_name = "red_alert_time_tank_draw_lottery", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
        _type = 1,
    }, nil, 1)

    -- 抽50次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tank_draw_50"), nil, 
    {
        terminal_name = "red_alert_time_tank_draw_lottery", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
        _type = 2,
    }, nil, 1)

    -- 详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tank_draw_infor"), nil, 
    {
        terminal_name = "red_alert_time_tank_draw_infor", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 1)
	
	self:onUpdateDraw()
end

function RedAlertTimeTankDraw:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeTankDraw:onExit()
    state_machine.remove("red_alert_time_tank_draw_lottery")
    state_machine.remove("red_alert_time_tank_draw_infor")
    state_machine.remove("red_alert_time_tank_draw_lottery50")
end
