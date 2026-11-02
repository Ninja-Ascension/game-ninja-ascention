ActivityWelcomeMoneyMan = class("ActivityWelcomeMoneyManClass", Window)
    
function ActivityWelcomeMoneyMan:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	self.currentTimes = 0
	self.remainTimes = 0
	self.ArmatureNodes = {}
	self.ArmatureNode_2 = nil --开始动画
	self.schedulerID = nil
	self.stopCount = 0
	self.stopNumbers = {}

    local function init_activity_welcome_money_man_terminal()
		local welcome_money_man_button_terminal = {
            _name = "welcome_money_man_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						instance:startRound()
					end
				end
				
                NetworkManager:register(protocol_command.fortune.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

   		local welcome_money_man_push_msg_terminal = {
            _name = "welcome_money_man_push_msg",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onUpdateDrawPushMsg()
        		return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local welcome_money_man_close_terminal = {
            _name = "welcome_money_man_close",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

		state_machine.add(welcome_money_man_button_terminal)
		state_machine.add(welcome_money_man_push_msg_terminal)
		state_machine.add(welcome_money_man_close_terminal)
		
        state_machine.init()
    end
    init_activity_welcome_money_man_terminal()
end

function ActivityWelcomeMoneyMan:onUpdateDrawPushMsgEx()
	local root = self.roots[1]
	if root == nil then 
		return
	end

	app.load("client.l_digital.cells.activity.wonderful.sm_activity_welcome_money_man_cell")

	local ListView_tuisong = ccui.Helper:seekWidgetByName(root, "ListView_tuisong")
	ListView_tuisong:removeAllChildren(true)
    ListView_tuisong:jumpToTop()

	for i,v in ipairs(_ED.user_gree_fortune_info) do
		local cell = state_machine.excute("sm_activity_welcome_money_man_create_cell", 0, {v})
		ListView_tuisong:addChild(cell)
	end

	ListView_tuisong:requestRefreshView()
end

function ActivityWelcomeMoneyMan:onUpdateDrawPushMsg()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self:onUpdateDrawPushMsgEx()
		return
	end
	for i=1,5 do
		local pushText = ccui.Helper:seekWidgetByName(root, "Text_push_"..i)
		pushText:setString("")	
	end
	for i,v in pairs(_ED.user_gree_fortune_info) do
		local pushText = ccui.Helper:seekWidgetByName(root, "Text_push_"..i)
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			pushText:setString(string.format(_string_piece_info[423],v.nickname,""..v.get_of_gold))
		else
			pushText:setString(string.format(_string_piece_info[379],v.nickname,""..v.get_of_gold))
		end
	end
end

function ActivityWelcomeMoneyMan:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if _ED.active_activity[14] == nil then 
		return
	end

	local file_path = "images/ui/effice/effect_yingcaishen/effect_yingcaishen.ExportJson"
	local armature_name = "effect_yingcaishen"
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		file_path = "images/ui/effice/effice_deyf_number/effice_deyf_number.ExportJson"
		armature_name = "effice_deyf_number"
	end

	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(file_path)
	self.ArmatureNodes = {}
	for i=1,5 do
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_number_"..i)
		panel:removeAllChildren(true)
		panel:removeBackGroundImage()
		local cell = ccs.Armature:create(armature_name)
		cell:getAnimation():playWithIndex(0)
		cell:setAnchorPoint(0.5,0.5)
		cell.index = i
		table.insert(self.ArmatureNodes,cell)
		cell:setPosition(cc.p(panel:getContentSize().width/2,-10))
		panel:addChild(cell)

		local label_number = ccui.Helper:seekWidgetByName(root, "AtlasLabel_number_"..i)
		if label_number ~= nil then
			panel:setVisible(false)
			label_number:setVisible(true)
		end
	end
	self:onUpdateDrawInfo()
end

--清除背景
function ActivityWelcomeMoneyMan:cleanRoundBackGround()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	for i=1,5 do
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_number_"..i)
		panel:removeAllChildren(true)
		panel:removeBackGroundImage()
	end
end

function ActivityWelcomeMoneyMan:onUpdateDrawInfo()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if _ED.active_activity[14] == nil then 
		return
	end
	local have_times = true
	local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")	-- 消耗
	local Text_14 = ccui.Helper:seekWidgetByName(root, "Text_14")	--今日次数
	local Text_15 = ccui.Helper:seekWidgetByName(root, "Text_15")	-- 时间
	local Text_zs_3 = ccui.Helper:seekWidgetByName(root, "Text_zs_3")	-- 剩余钻石
	Text_13:setString("")
	if Text_14 ~= nil then
		Text_14:setString("")
	end
	Text_15:setString("")

	if Text_zs_3 ~= nil then
		Text_zs_3:setString(_ED.user_info.user_gold)
	end
	
	if Text_14 ~= nil then
		Text_14:setString("".. self.remainTimes)
	end
	local welcomeButton = ccui.Helper:seekWidgetByName(root, "Button_11")
	welcomeButton:setTouchEnabled(true)
	welcomeButton:setColor(cc.c3b(255, 255, 255))
	local moneyArr = zstring.split(dms.string(dms["pirates_config"], 122, pirates_config.param), ",")
	if self.currentTimes > #moneyArr -1 then 
		self.currentTimes = #moneyArr - 1
		--已经领完了
		welcomeButton:setTouchEnabled(false)
		welcomeButton:setColor(cc.c3b(150, 150, 150))
		have_times = false
	end

	Text_13:setString(""..moneyArr[self.currentTimes +1])
	local end_time = os.date("%Y"..".".."%m"..".".."%d".." ".."%H"..":".."%M:".."%S", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[14].activity_login_day)/1000)))
	Text_15:setString(end_time)
	self:onUpdateDrawPushMsg()

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local end_time = os.date("%m"..".".."%d".."  ".."%H"..":".."%M", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[14].activity_login_day)/1000)))
		local start_time = os.date("%m"..".".."%d".."  ".."%H"..":".."%M", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[14].activity_start_day)/1000)))
		local Text_hd_time = ccui.Helper:seekWidgetByName(root, "Text_hd_time")
		Text_hd_time:setString(start_time.." - "..end_time)

		self._Text_15 = Text_15
		local Panel_over = ccui.Helper:seekWidgetByName(root, "Panel_over")
		local Image_over = ccui.Helper:seekWidgetByName(root, "Image_over")
		Panel_over:setVisible(true)
		Image_over:setVisible(false)
		local times_info = zstring.split(dms.string(dms["activity_config"], 12, pirates_config.param), "|")
		local Panel_vip = ccui.Helper:seekWidgetByName(root, "Panel_vip")
		Panel_vip:setVisible(false)

		if have_times == false then
			Panel_over:setVisible(false)
			Image_over:setVisible(true)
			for k, v in pairs(times_info) do
				local info = zstring.split(v, ",")
				local Image_vip = ccui.Helper:seekWidgetByName(root, "Image_vip_"..info[1])
				if Image_vip ~= nil then
					Image_vip:setVisible(false)
				end
			end
		else
			local max_gold_info = zstring.split(dms.string(dms["activity_config"], 11, pirates_config.param), ",")

			local Text_zs_1 = ccui.Helper:seekWidgetByName(root, "Text_zs_1")
			Text_zs_1:setString(max_gold_info[self.currentTimes + 1])

			local need_vip = 0
			for k, v in pairs(times_info) do
				local info = zstring.split(v, ",")
				if self.currentTimes + 1 <= tonumber(info[2]) then
					need_vip = tonumber(info[1])
					break
				end
			end

			local Image_vip_5 = ccui.Helper:seekWidgetByName(root, "Image_vip_5")
			local Image_vip_7 = ccui.Helper:seekWidgetByName(root, "Image_vip_7")
			local Image_vip_10 = ccui.Helper:seekWidgetByName(root, "Image_vip_10")
			Image_vip_5:setVisible(false)
			Image_vip_7:setVisible(false)
			Image_vip_10:setVisible(false)

			if need_vip > 0 then
				Panel_vip:setVisible(true)
				local Image_vip = ccui.Helper:seekWidgetByName(root, "Image_vip_"..need_vip)
				if Image_vip ~= nil then
					Image_vip:setVisible(true)
				end
			end

			if need_vip > tonumber(_ED.vip_grade) then
				welcomeButton:setTouchEnabled(false)
				welcomeButton:setColor(cc.c3b(150, 150, 150))
			end
		end
	end
end

function ActivityWelcomeMoneyMan:onUpdate(dt)
	if self._Text_15 ~= nil then
	    self:updateDrawActivityTime(os.time() + _ED.time_add_or_sub)
	end
end

function ActivityWelcomeMoneyMan:updateDrawActivityTime(times)
    local root = self.roots[1]
    if root == nil then
        return
    end
    local activity = _ED.active_activity[14]
    local surplus_time = (activity.activity_login_day - ((times))*1000)
    self._Text_15:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time / 1000))
end

--开始转动
function ActivityWelcomeMoneyMan:startRound()
	if self.ArmatureNode_2 ~= nil then
		csb.animationChangeToAction(self.ArmatureNode_2, 0, 0, false)
	    self.ArmatureNode_2._invoke = self.ArmatureNode_2._invoke_w
	    self.ArmatureNode_2:setVisible(true)
	end
    local scheduler = cc.Director:getInstance():getScheduler()
    if self.schedulerID ~= nil then 
    	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)      
    end
    self.schedulerID= nil  
	local  timer = 0
	self.stopCount = 0
	self.schedulerID = scheduler:scheduleScriptFunc(function ()
	 	if self.roots[1] ~= nil then 
	 		self:stopRound()
	 	end
    	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)      
    end,1.5,false) 
    local root = self.roots[1]
    local welcomeButton = ccui.Helper:seekWidgetByName(root, "Button_11")
	welcomeButton:setTouchEnabled(false)
	welcomeButton:setColor(cc.c3b(150, 150, 150))
    for i=1,5 do
    	--播放转动
		draw.initArmature(self.ArmatureNodes[i], nil, -1, 0, 1)		
    	csb.animationChangeToAction(self.ArmatureNodes[i], 1, 1, false)
    	self.ArmatureNodes[i]:resume()
    	self.ArmatureNodes[i]:setVisible(true)
    	local panel = ccui.Helper:seekWidgetByName(root, "Panel_number_"..i)
    	local label_number = ccui.Helper:seekWidgetByName(root, "AtlasLabel_number_"..i)
		panel:removeBackGroundImage()
		self.ArmatureNodes[i]._roundPanel = panel
		self.ArmatureNodes[i]._labelNumber = label_number

		if label_number ~= nil then
			label_number:setVisible(false)
			panel:setVisible(true)
		end
    end
end

function ActivityWelcomeMoneyMan:stopRoundEx()
	self:setActivityInfo()
	local stopNumbers = self.stopNumbers
	local stopCount = 0
	local function callback(sender)
		stopCount = stopCount + 1
		local stopIndex = stopNumbers[zstring.tonumber(sender.index)]
		sender._labelNumber:setString(stopIndex)
    	sender._roundPanel:setVisible(false)
    	sender._labelNumber:setVisible(true)
		if stopCount >= 5 then
			self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(function (sender)
					sender:rewadDraw()
				end
				)))
		end
	end
	for i = 1, 5 do
		local action = cc.Sequence:create(cc.DelayTime:create(0.2 * (6-i)), cc.CallFunc:create(callback))
		self.ArmatureNodes[i]:runAction(action)
	end
end

function ActivityWelcomeMoneyMan:rewadDraw()
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(45)
	fwin:open(getRewardWnd,fwin._ui)
	
	self:onUpdateDrawInfo()
end

local function onRoundFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
    local armature = bone:getArmature()
    local stopEvent = "stop_".. armature._stopNumbers[zstring.tonumber(armature.index)]
    local stopIndex = armature._stopNumbers[zstring.tonumber(armature.index)]
    if evt ~= nil and evt == stopEvent then
    	armature:pause()
    	armature:setVisible(false)
    	armature._roundPanel:setBackGroundImage(string.format("images/ui/number/caishen_%d.png", stopIndex))
    end
end

--开始停止
function ActivityWelcomeMoneyMan:stopRound( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self:stopRoundEx()
		return
	end
	-- body
	self:setActivityInfo()
	for i=1,5 do
		--减慢
		self.ArmatureNodes[i]._stopNumbers = self.stopNumbers
    	csb.animationChangeToAction(self.ArmatureNodes[i], 2, 2, true)
    	self.ArmatureNodes[i]._invoke = function(armatureBack)
    		self.stopCount = self.stopCount + 1
    		if self.stopCount >= 5 then 
    			--全部停下来
				self:onUpdateDrawInfo()
    		end
    		armatureBack._invoke = nil
    		csb.animationChangeToAction(armatureBack, 3, 3, false)
    		armatureBack:getAnimation():setFrameEventCallFunc(onRoundFrameEvent)
    	end
    end
end

function ActivityWelcomeMoneyMan:initDraw()
	if self.loaded == false then
		return
	end
    local csbActivityWelcomeMammon = csb.createNode("activity/wonderful/yingcaishen.csb")
	local root = csbActivityWelcomeMammon:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbActivityWelcomeMammon)
	self:setActivityInfo()
	self:onUpdateDraw()
	local armaturePanel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	if armaturePanel ~= nil then
		self.ArmatureNode_2 = armaturePanel:getChildByName("ArmatureNode_1") 
	    draw.initArmature(self.ArmatureNode_2, nil, -1, 0, 1)
	    
	    csb.animationChangeToAction(self.ArmatureNode_2, 0, 0, false)
	    self.ArmatureNode_2._invoke_w = function(armatureBack)
	        if armatureBack:isVisible() == true then
	        	armatureBack:setVisible(false)
	        end
	    end   
	end
    
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), nil, 
		{
			terminal_name = "welcome_money_man_button", 
			terminal_state = 0, 
			-- isPressedActionEnabled = true
		},
		nil,0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
		{
			terminal_name = "welcome_money_man_close", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil,0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), nil, 
		{
			terminal_name = "welcome_money_man_button", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil,0)
	end

end

function ActivityWelcomeMoneyMan:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:initDraw()
	self:registerOnNoteUpdate(self, 1)
end

function ActivityWelcomeMoneyMan:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self:unregisterOnNoteUpdate(self)
end

function ActivityWelcomeMoneyMan:onEnterTransitionFinish()
end

function ActivityWelcomeMoneyMan:setActivityInfo()
	local remainArr = zstring.split("" .._ED.active_activity[14].activity_extra_prame, ",")
	if _ED.welcome_money == nil then 
		--第一次进入游戏 按照活动数据初始化
		local moneyArr = zstring.split(dms.string(dms["pirates_config"], 122, pirates_config.param), ",")
		self.currentTimes = 0 -- 当前花费钻石索引
		--计算剩余次数
		self.remainTimes = 0

		for i,v in pairs(remainArr) do
			if zstring.tonumber(v) == 0 then 
				self.remainTimes = self.remainTimes + 1 
			end
			if zstring.tonumber(v) == 1 then 
				self.currentTimes = i
			end
		end
	else
		self.currentTimes = zstring.tonumber(_ED.welcome_money.current_times)
		self.remainTimes = #remainArr - self.currentTimes
		self.stopNumbers = {}
		--
		local get_gold = string.format("%05d",_ED.welcome_money.get_gold_count)
		for i=1,5 do
			local pushString = get_gold
			table.insert(self.stopNumbers,string.sub(pushString,i,i))
		end
	end
end

function ActivityWelcomeMoneyMan:onExit()
	state_machine.remove("welcome_money_man_button")
	state_machine.remove("welcome_money_man_push_msg")
	state_machine.remove("welcome_money_man_close")
	if self.schedulerID ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
	end
    
    self.roots = {}
end

function ActivityWelcomeMoneyMan:init()
	
end

function ActivityWelcomeMoneyMan:createCell()
	local cell = ActivityWelcomeMoneyMan:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end