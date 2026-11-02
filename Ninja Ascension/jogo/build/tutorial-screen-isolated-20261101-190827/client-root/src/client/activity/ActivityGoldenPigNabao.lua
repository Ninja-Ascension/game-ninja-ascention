
-- 金猪纳宝
ActivityGoldenPigNabao = class("ActivityGoldenPigNabaoClass", Window)

function ActivityGoldenPigNabao:ctor()
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

	app.load("client.activity.ActivityGoldenPigNabaoGuize")

    local function init_activity_golden_pig_nabao_terminal()
		local golden_pig_nabao_button_terminal = {
            _name = "golden_pig_nabao_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						instance:startRound()
						-- state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 167)
					end
				end
				
                NetworkManager:register(protocol_command.activity_fortune_cat_draw.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

   		local golden_pig_nabao_push_msg_terminal = {
            _name = "golden_pig_nabao_push_msg",
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

        local golden_pig_nabao_close_terminal = {
            _name = "golden_pig_nabao_close",
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

        -- 打开规则界面
		local golden_pig_nabao_rule_window_terminal = {
			_name = "golden_pig_nabao_rule_window",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("activity_golden_pig_nabao_guize_window_open", 0, "")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(golden_pig_nabao_button_terminal)
		state_machine.add(golden_pig_nabao_push_msg_terminal)
		state_machine.add(golden_pig_nabao_close_terminal)
		state_machine.add(golden_pig_nabao_rule_window_terminal)
		
        state_machine.init()
    end
    init_activity_golden_pig_nabao_terminal()
end

function ActivityGoldenPigNabao:onUpdateDrawPushMsgEx()
	local root = self.roots[1]
	if root == nil then 
		return
	end

	app.load("client.l_digital.cells.activity.wonderful.sm_activity_golden_pig_nabao_cell")

	local ListView_tuisong = ccui.Helper:seekWidgetByName(root, "ListView_tuisong")
	ListView_tuisong:removeAllChildren(true)
    ListView_tuisong:jumpToTop()

	for i,v in ipairs(_ED.activity_golden_pig_nabao_extract_data.drawInfo) do
		local cell = state_machine.excute("sm_activity_golden_pig_nabao_create_cell", 0, {v})
		ListView_tuisong:addChild(cell)
	end

	ListView_tuisong:requestRefreshView()
end

function ActivityGoldenPigNabao:onUpdateDrawPushMsg()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self:onUpdateDrawPushMsgEx()
end

function ActivityGoldenPigNabao:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if _ED.active_activity[167] == nil then 
		return
	end

	local file_path = "images/ui/effice/effice_deyf_number/effice_deyf_number.ExportJson"
	local armature_name = "effice_deyf_number"

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
function ActivityGoldenPigNabao:cleanRoundBackGround()
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

function ActivityGoldenPigNabao:onUpdateDrawInfo()
	local root = self.roots[1]
	if root == nil then 
		return
	end

	if _ED.active_activity[167] == nil then 
		return
	end
	local have_times = true
	local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")	-- 消耗
	local Text_14 = ccui.Helper:seekWidgetByName(root, "Text_14")	--今日次数
	local Text_15 = ccui.Helper:seekWidgetByName(root, "Text_15")	-- 时间
	local Text_zs_3 = ccui.Helper:seekWidgetByName(root, "Text_zs_3")	-- 剩余钻石
	local Text_zs_1 = ccui.Helper:seekWidgetByName(root, "Text_zs_1")

	local Text_bencixiaohao_1 = ccui.Helper:seekWidgetByName(root, "Text_bencixiaohao_1")
	Text_bencixiaohao_1:setVisible(false)
	local Text_bencixiaohao_2 = ccui.Helper:seekWidgetByName(root, "Text_bencixiaohao_2")
	Text_bencixiaohao_2:setVisible(false)
	local Text_chongzhi_1 = ccui.Helper:seekWidgetByName(root, "Text_chongzhi_1")
	Text_chongzhi_1:setVisible(false)
	local Text_chongzhi_2 = ccui.Helper:seekWidgetByName(root, "Text_chongzhi_2")
	Text_chongzhi_2:setVisible(false)
	-- local Text_shangxian = ccui.Helper:seekWidgetByName(root, "Text_shangxian")
	-- Text_shangxian:setVisible(false)

	local Panel_over = ccui.Helper:seekWidgetByName(root, "Panel_over")
	Panel_over:setVisible(true)

	local Image_over = ccui.Helper:seekWidgetByName(root, "Image_over")
	Image_over:setVisible(false)

	local Text_zs_3_0 = ccui.Helper:seekWidgetByName(root, "Text_zs_3_0")
	local Image_zs_icon_3 = ccui.Helper:seekWidgetByName(root, "Image_zs_icon_3")


	Text_13:setString("")
	if Text_14 ~= nil then
		Text_14:setString("")
	end
	Text_15:setString("")

	if Text_zs_3 ~= nil then
		Text_zs_3:setString(_ED.user_info.user_gold)
		if Text_zs_3_0._py == nil then
			Text_zs_3_0._py = Text_zs_3_0:getPositionY()
		end
		if Image_zs_icon_3._py == nil then
			Image_zs_icon_3._py = Image_zs_icon_3:getPositionY()
		end
		if Text_zs_3._py == nil then
			Text_zs_3._py = Text_zs_3:getPositionY()
		end
		-- Text_zs_3:setPositionY(Text_zs_3._py)
		-- Text_zs_3_0:setPositionY(Text_zs_3_0._py)
		-- Image_zs_icon_3:setPositionY(Image_zs_icon_3._py)
	end
	
	if Text_14 ~= nil then
		Text_14:setString("".. self.remainTimes)
	end
	local welcomeButton = ccui.Helper:seekWidgetByName(root, "Button_11")
	welcomeButton:setTouchEnabled(true)
	welcomeButton:setColor(cc.c3b(255, 255, 255))

	local remainArrData = zstring.split("" .._ED.active_activity[167].need_recharge_count, "@")
    local remainArr = zstring.splits("" ..remainArrData[3], "~",",")

	self.currentTimes = zstring.tonumber(_ED.active_activity[167].extra_information.drawCount) -- 当前花费钻石索引
	--计算剩余次数
	self.remainTimes = zstring.tonumber(_ED.active_activity[167].extra_information.presenterCount) + zstring.tonumber(_ED.active_activity[167].extra_information.freeCount)

	Text_bencixiaohao_2:setString(self.remainTimes)

	if self.remainTimes > 0 then
		Text_bencixiaohao_1:setVisible(true)
		Text_bencixiaohao_2:setVisible(true)
		Text_chongzhi_1:setVisible(false)
		Text_chongzhi_2:setVisible(false)
		-- Text_shangxian:setVisible(false)
	else
		local rechageSchedule = zstring.splits("" ..remainArrData[2], ",",":")

		local rechageIndexDa = 0
		local isRechageAdd = false
		for i,v in pairs(rechageSchedule) do
			if zstring.tonumber(_ED.active_activity[167].extra_information.rechage) < zstring.tonumber(v[1]) then
				rechageIndexDa = zstring.tonumber(v[1])
				isRechageAdd = true
				break
			end 
		end

		if isRechageAdd == true then
			Text_bencixiaohao_1:setVisible(false)
			Text_bencixiaohao_2:setVisible(false)
			Text_chongzhi_1:setVisible(true)
			Text_chongzhi_2:setVisible(true)
			-- Text_shangxian:setVisible(false)
			Text_chongzhi_2:setString(rechageIndexDa - zstring.tonumber(_ED.active_activity[167].extra_information.rechage))
		else
			Text_bencixiaohao_1:setVisible(false)
			Text_bencixiaohao_2:setVisible(false)
			Text_chongzhi_1:setVisible(false)
			Text_chongzhi_2:setVisible(false)
			-- Text_shangxian:setVisible(true)
			Panel_over:setVisible(false)
			Image_over:setVisible(true)
			-- Text_zs_3:setPositionY(Text_zs_1:getPositionY())
			-- Text_zs_3_0:setPositionY(Text_zs_1:getPositionY())
			-- Image_zs_icon_3:setPositionY(Text_zs_1:getPositionY())
		end
	end

	-- local moneyArr = zstring.split(dms.string(dms["pirates_config"], 122, pirates_config.param), ",")
	if self.currentTimes > #remainArr -1 then 
		self.currentTimes = #remainArr - 1
		--已经领完了
		welcomeButton:setTouchEnabled(false)
		welcomeButton:setColor(cc.c3b(150, 150, 150))
		have_times = false
	end

	if self.remainTimes <= 0 then
		welcomeButton:setTouchEnabled(false)
		welcomeButton:setColor(cc.c3b(150, 150, 150))
		have_times = false
	end

	-- if (self.currentTimes + 2) >= #remainArr then
	-- 	ccui.Helper:seekWidgetByName(root, "Text_bczgkhd_0"):setVisible(false)
	-- 	ccui.Helper:seekWidgetByName(root, "Image_zs_icon_2"):setVisible(false)
	-- else
	-- 	ccui.Helper:seekWidgetByName(root, "Text_bczgkhd_0"):setVisible(true)
	-- 	ccui.Helper:seekWidgetByName(root, "Image_zs_icon_2"):setVisible(true)
	-- end
	
	Text_13:setString(""..remainArr[self.currentTimes +1][3])
	
	
	local end_time = os.date("%Y"..".".."%m"..".".."%d".." ".."%H"..":".."%M:".."%S", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[167].end_time)/1000)))
	Text_15:setString(end_time)
	self:onUpdateDrawPushMsg()

	local end_time = os.date("%m"..".".."%d".."  ".."%H"..":".."%M", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[167].end_time)/1000)))
	local start_time = os.date("%m"..".".."%d".."  ".."%H"..":".."%M", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[167].begin_time)/1000)))
	local Text_hd_time = ccui.Helper:seekWidgetByName(root, "Text_hd_time")
	Text_hd_time:setString(start_time.." - "..end_time)

	self._Text_15 = Text_15
	-- local Panel_over = ccui.Helper:seekWidgetByName(root, "Panel_over")
	-- local Image_over = ccui.Helper:seekWidgetByName(root, "Image_over")
	-- Panel_over:setVisible(true)
	-- Image_over:setVisible(false)
	local times_info = zstring.split(dms.string(dms["activity_config"], 12, pirates_config.param), "|")
	local Panel_vip = ccui.Helper:seekWidgetByName(root, "Panel_vip")
	Panel_vip:setVisible(false)

	
	Text_zs_1:setString(remainArr[self.currentTimes +1][2])

	-- if have_times == false then
	-- 	Panel_over:setVisible(false)
	-- 	Image_over:setVisible(true)
	-- 	for k, v in pairs(times_info) do
	-- 		local info = zstring.split(v, ",")
	-- 		local Image_vip = ccui.Helper:seekWidgetByName(root, "Image_vip_"..info[1])
	-- 		if Image_vip ~= nil then
	-- 			Image_vip:setVisible(false)
	-- 		end
	-- 	end
	-- else
	-- 	-- local max_gold_info = zstring.split(dms.string(dms["activity_config"], 11, pirates_config.param), ",")

	-- 	local Text_zs_1 = ccui.Helper:seekWidgetByName(root, "Text_zs_1")
	-- 	Text_zs_1:setString(remainArr[self.currentTimes +1][2])

	-- 	local need_vip = 0
	-- 	for k, v in pairs(times_info) do
	-- 		local info = zstring.split(v, ",")
	-- 		if self.currentTimes + 1 <= tonumber(info[2]) then
	-- 			need_vip = tonumber(info[1])
	-- 			break
	-- 		end
	-- 	end

	-- 	local Image_vip_5 = ccui.Helper:seekWidgetByName(root, "Image_vip_5")
	-- 	local Image_vip_7 = ccui.Helper:seekWidgetByName(root, "Image_vip_7")
	-- 	local Image_vip_10 = ccui.Helper:seekWidgetByName(root, "Image_vip_10")
	-- 	Image_vip_5:setVisible(false)
	-- 	Image_vip_7:setVisible(false)
	-- 	Image_vip_10:setVisible(false)

	-- 	if need_vip > 0 then
	-- 		Panel_vip:setVisible(true)
	-- 		local Image_vip = ccui.Helper:seekWidgetByName(root, "Image_vip_"..need_vip)
	-- 		if Image_vip ~= nil then
	-- 			Image_vip:setVisible(true)
	-- 		end
	-- 	end

	-- 	if need_vip > tonumber(_ED.vip_grade) then
	-- 		welcomeButton:setTouchEnabled(false)
	-- 		welcomeButton:setColor(cc.c3b(150, 150, 150))
	-- 	end
	-- end
end

function ActivityGoldenPigNabao:onUpdate(dt)
	if self._Text_15 ~= nil then
	    self:updateDrawActivityTime(os.time() + _ED.time_add_or_sub)
	end
end

function ActivityGoldenPigNabao:updateDrawActivityTime(times)
    local root = self.roots[1]
    if root == nil then
        return
    end
    local activity = _ED.active_activity[167]
    local surplus_time = (activity.end_time - ((times))*1000)
    self._Text_15:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time / 1000))
end

--开始转动
function ActivityGoldenPigNabao:startRound()
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

function ActivityGoldenPigNabao:stopRoundEx()
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

function ActivityGoldenPigNabao:rewadDraw()
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7)
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
function ActivityGoldenPigNabao:stopRound( ... )
	self:stopRoundEx()
end

function ActivityGoldenPigNabao:initDraw()
	if self.loaded == false then
		return
	end
    local csbActivityWelcomeMammon = csb.createNode("Lucky/Lucky_number.csb")
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
    
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), nil, 
	{
		terminal_name = "golden_pig_nabao_button", 
		terminal_state = 0, 
		-- isPressedActionEnabled = true
	},
	nil,0)

	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil, 
	{
		terminal_name = "golden_pig_nabao_rule_window", 
		terminal_state = 0, 
		-- isPressedActionEnabled = true
	},
	nil,0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
	{
		terminal_name = "golden_pig_nabao_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

end

function ActivityGoldenPigNabao:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:initDraw()
	self:registerOnNoteUpdate(self, 1)
end

function ActivityGoldenPigNabao:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self:unregisterOnNoteUpdate(self)
end

function ActivityGoldenPigNabao:onEnterTransitionFinish()
end

function ActivityGoldenPigNabao:setActivityInfo()
	local info = {} 
    info = json.decode(_ED.active_activity[167].activity_params)
    _ED.active_activity[167].extra_information = info
    local remainArrData = zstring.split("" .._ED.active_activity[167].need_recharge_count, "@")
    local remainArr = zstring.split("" ..remainArrData[3], "~")

    --activity_params = "{"drawInfo":[],"rechage":0,"presenterCount":0,"drawCount":0,"hasGetCount":[],"freeCount":10}"
    --													收费次数          已使用次数                      免费次数
    if _ED.activity_golden_pig_nabao_extract_data.rewardGold == nil then
    	self.currentTimes = zstring.tonumber(_ED.active_activity[167].extra_information.drawCount) -- 当前花费钻石索引
		--计算剩余次数
		self.remainTimes = zstring.tonumber(_ED.active_activity[167].extra_information.presenterCount) + zstring.tonumber(_ED.active_activity[167].extra_information.freeCount)

    else
	    self.currentTimes = zstring.tonumber(_ED.active_activity[167].extra_information.drawCount)
	    self.remainTimes = zstring.tonumber(_ED.active_activity[167].extra_information.presenterCount) + zstring.tonumber(_ED.active_activity[167].extra_information.freeCount)
	    self.stopNumbers = {}
    	local get_gold = string.format("%05d",_ED.activity_golden_pig_nabao_extract_data.rewardGold)
		for i=1,5 do
			local pushString = get_gold
			table.insert(self.stopNumbers,string.sub(pushString,i,i))
		end
	end
	-- local remainArr = zstring.split("" .._ED.active_activity[167].activity_extra_prame, ",")
	-- if _ED.welcome_money == nil then 
	-- 	--第一次进入游戏 按照活动数据初始化
	-- 	local moneyArr = zstring.split(dms.string(dms["pirates_config"], 122, pirates_config.param), ",")
	-- 	self.currentTimes = 0 -- 当前花费钻石索引
	-- 	--计算剩余次数
	-- 	self.remainTimes = 0

	-- 	for i,v in pairs(remainArr) do
	-- 		if zstring.tonumber(v) == 0 then 
	-- 			self.remainTimes = self.remainTimes + 1 
	-- 		end
	-- 		if zstring.tonumber(v) == 1 then 
	-- 			self.currentTimes = i
	-- 		end
	-- 	end
	-- else
	-- 	self.currentTimes = zstring.tonumber(_ED.welcome_money.current_times)
	-- 	self.remainTimes = #remainArr - self.currentTimes
	-- 	self.stopNumbers = {}
	-- 	--
	-- 	local get_gold = string.format("%05d",_ED.welcome_money.get_gold_count)
	-- 	for i=1,5 do
	-- 		local pushString = get_gold
	-- 		table.insert(self.stopNumbers,string.sub(pushString,i,i))
	-- 	end
	-- end
end

function ActivityGoldenPigNabao:onExit()
	state_machine.remove("golden_pig_nabao_button")
	state_machine.remove("golden_pig_nabao_push_msg")
	state_machine.remove("golden_pig_nabao_close")
	state_machine.remove("golden_pig_nabao_rule_window")

	if self.schedulerID ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
	end
    
    self.roots = {}
end

function ActivityGoldenPigNabao:init()
	
end

function ActivityGoldenPigNabao:createCell()
	local cell = ActivityGoldenPigNabao:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end