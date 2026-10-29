--[[ ----------------------------------------------------------------------------
-- 幸运占卜界面
--]] ----------------------------------------------------------------------------
ActivityLuckDivination = class("ActivityLuckDivinationClass", Window)

-- 打开窗口
local activity_luck_divination_window_open_terminal = {
	_name = "activity_luck_divination_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityLuckDivinationClass") then
			fwin:open(ActivityLuckDivination:new():init(params), fwin._view)
		else 
			state_machine.excute("activity_luck_divination_show", 0, 0)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_luck_divination_window_close_terminal = {
	_name = "activity_luck_divination_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityLuckDivinationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_divination_window_open_terminal)
state_machine.add(activity_luck_divination_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityLuckDivination:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.isCardOpen = false
	-- var

	-- load lua files.
	app.load("client.activity.ActivityLuckTimeTips")
	app.load("client.activity.ActivityLuckCongratulationsTips")
	app.load("client.activity.ActivityLuckRecord")
	app.load("client.activity.ActivityLuckDivinationList")
	
	-- Initialize activity luck divination page state machine.
	local function init_activity_luck_divination_terminal()
		-- 打开角色创建窗口
		local activity_luck_divination_open_terminal = {
			_name = "activity_luck_divination_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local activity_luck_divination_close_terminal = {
			_name = "activity_luck_divination_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local activity_luck_divination_show_terminal = {
			_name = "activity_luck_divination_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local activity_luck_divination_hide_terminal = {
			_name = "activity_luck_divination_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local activity_luck_get_num_terminal = {
			_name = "activity_luck_get_num",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance.Button_luck_free:setTouchEnabled(false)
				instance.Button_luck_ten:setTouchEnabled(false)
				-- instance:playAniBack()
				local type = tonumber(params._datas.type)
				instance.type = type
				-- if type == 2 and zstring.tonumber(_ED.active_activity[161].activity_params.freeTimes) == 1 then
				-- 	type = 1
				-- end
				type = tostring(type)
				local function rankcallBack(response)
					if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
						return
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						response.node:playAniAll()
						response.node:updateUI()
					else
						response.node.Button_luck_free:setTouchEnabled(true)
						response.node.Button_luck_ten:setTouchEnabled(true)
					end
				end
				protocol_command.lucky_divine.param_list = type
				NetworkManager:register(protocol_command.lucky_divine.code, nil, nil, nil, self, rankcallBack, false, nil)
		
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 幸运占卜跑马灯推送
		local divination_marquee_terminal = {
			_name = "divination_marquee",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:runHourse()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(activity_luck_divination_open_terminal)
		state_machine.add(activity_luck_divination_close_terminal)
		state_machine.add(activity_luck_divination_show_terminal)
		state_machine.add(activity_luck_divination_hide_terminal)
		state_machine.add(activity_luck_get_num_terminal)
		state_machine.add(divination_marquee_terminal)
		
		state_machine.init()
	end
	-- call func init activity luck divination state machine.
	init_activity_luck_divination_terminal()
end
function ActivityLuckDivination:onUpdate(dt)
    if self.end_times > 0 and self.Text_luck_time_number ~= nil then
        self.end_times = self.end_times - dt
        self.Text_luck_time_number:setString(getRedAlertTimeActivityFormat(self.end_times))
        if self.end_times == 0 then
        end
	end
	if self.ListView_tuisong ~= nil then
		local size = self.ListView_tuisong:getContentSize()
		local posY = self.ListView_tuisong:getInnerContainer():getPositionY()
		if self.ListView_tuisong_poy == posY then
			return
		end
		self.ListView_tuisong_poy = posY
		local items = self.ListView_tuisong:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
					v:unload()
			else	
					v:reload()				
			end
		end
	end
end
-- 对象初始化
function ActivityLuckDivination:init(params)
	self.m_index = 1
	self.isMove = false
	local rootWindow = params[1] 
	if nil ~= rootWindow then
		self._rootWindows = rootWindow
	end
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityLuckDivination:onUpdateDraw()
	local root = self.roots[1]

	-- 卡牌
	self.Panel_luck_cards = {}
	self.luck_cards_ani = {}
	self.BitmapFontLabel_luck_card = {}
	for i = 1, 5 do
		self.Panel_luck_cards[i] = ccui.Helper:seekWidgetByName(root, "Panel_luck_card_" .. i .. "")
		local skeletonNode2 = sp.SkeletonAnimation:create("images/ui/effice/effect_zhanbukapai/effect_zhanbukapai.json", "images/ui/effice/effect_zhanbukapai/effect_zhanbukapai.atlas", 1)
		skeletonNode2:setPosition( cc.p( 50, 0) )
		skeletonNode2:setAnimation(0, "00_beimian", true)
		self.Panel_luck_cards[i]:addChild(skeletonNode2)
		self.luck_cards_ani[i] = skeletonNode2
		
		self.BitmapFontLabel_luck_card[i] = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_luck_card_" .. i .. "")
		self.BitmapFontLabel_luck_card[i]:setOpacity(0)
	end
	
	self.luck_cards_ani[1]:registerSpineEventHandler(function (event)
		-- debug.log(event.animation,"registerSpineEventHandler")
		if event.animation == "03_chuxian" then
			for i=1, 5 do
				local action1 = cc.FadeIn:create(8/60)
				self.BitmapFontLabel_luck_card[i]:runAction(action1)
			end
		end
		if event.animation == "04_chixu" then
			if _ED.active_activity[161].activity_params.extObj.totalReward == nil or _ED.active_activity[161].activity_params.extObj.totalReward == "" then
				if self.type == 1 then --十次
					state_machine.excute("activity_luck_time_tips_window_open", 0, 0)
				else
					TipDlg.drawTextDailog(dms.string(dms.searchs(dms["activity_error_code"], 1,26029), 1, 3))
				end
			else
				if self.type == 1 then
					state_machine.excute("activity_luck_time_tips_window_open", 0, 0)
				else
					local getRewardWnd = DrawRareReward:new()
					getRewardWnd:init(7)
					fwin:open(getRewardWnd,fwin._ui)
				end
			end
			
			self.Button_luck_free:setTouchEnabled(true)
			self.Button_luck_ten:setTouchEnabled(true)
		end
								
	end, sp.EventType.ANIMATION_START)

	-- 本次免费文本做显示隐藏
	self.Text_luck_free = ccui.Helper:seekWidgetByName(root, "Text_luck_free")

	-- 占卜一次文本做显示隐藏
	self.Text_luck_one = ccui.Helper:seekWidgetByName(root, "Text_luck_one")

	-- 近期占卜记录
	self.Text_luck_documentary = ccui.Helper:seekWidgetByName(root, "Text_luck_documentary")

	-- 次数数值
	self.Text_luck_frequency_number = ccui.Helper:seekWidgetByName(root, "Text_luck_frequency_number")

	-- 活动时间
	self.Text_luck_time_number = ccui.Helper:seekWidgetByName(root, "Text_luck_time_number")

	-- 本期幸运数字
	self.Text_luck_current_number = ccui.Helper:seekWidgetByName(root, "Text_luck_current_number")
	self.ListView_tuisong = ccui.Helper:seekWidgetByName(root, "ListView_tuisong")

	-- 走马灯文本
	self.Text_luck_zmd = ccui.Helper:seekWidgetByName(root, "Text_luck_zmd")

	-- 女神动画
	-- self.Panel_luck_goddess_dh = ccui.Helper:seekWidgetByName(root, "Panel_luck_goddess_dh")
	-- local skeletonNode2 = sp.SkeletonAnimation:create("images/ui/effect/effect_26/effect_26.json", "images/ui/effect/effect_26/effect_26.atlas", 0.6)
	-- -- skeletonNode2:setPosition(cc.p( 0, 0))
	-- skeletonNode2:setAnimation(0, "animation", true)
	-- self.Panel_luck_goddess_dh:addChild(skeletonNode2)
	-- 请求初始信息
	self:initData()
	self:updateUI()
end
function ActivityLuckDivination:initData()
	local function responseChanllengeCallback(response)
		if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
			return
		end
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			response.node:updateUI()
			response.node:runHourse()
		else
			response.node.Button_luck_free:setTouchEnabled(true)
			response.node.Button_luck_ten:setTouchEnabled(true)
		end
	end
	-- protocol_command.get_lucky_divine_info.param_list = {uuid=_ED.uuid,token=_ED.token,handle=protocol_command.act_divination.command, data = {divine_type=type}}
	NetworkManager:register(protocol_command.get_lucky_divine_info.code, nil, nil, nil, self, responseChanllengeCallback, false, nil)
end

function ActivityLuckDivination:updateUI()
	local lucknum = zstring.split(_ED.active_activity[161].need_recharge_count,"@")

	self.Text_luck_current_number:setString(lucknum[2])
	local totalTime = tonumber(_ED.active_activity[161].activity_params.freeTimes) + tonumber(_ED.active_activity[161].activity_params.divineTimes)
	self.Text_luck_frequency_number:setString(totalTime)
	-- local startTime = EDgetPushIntervalByTimes(tonumber(_ED.active_activity[161].begin_time)/1000,6)
	-- self.Text_luck_time_number:setString(endTime)
	self.end_times = (tonumber(_ED.active_activity[161].end_time) / 1000) - ( os.time() - _ED.native_time + _ED.system_time)

	if  zstring.tonumber(_ED.active_activity[161].activity_params.freeTimes) == 1 then
		self.Text_luck_free:setVisible(true)
		self.Text_luck_one:setVisible(false)
	else
		self.Text_luck_free:setVisible(false)
		self.Text_luck_one:setVisible(true)
	end
	
	if _ED.active_activity[161].activity_params.divineRecord then
		local str = ""
		for i=1,table.nums(_ED.active_activity[161].activity_params.divineRecord) do
			str = str.._ED.active_activity[161].activity_params.divineRecord[i].num.."  "
			-- if i%4 == 0 then
			-- 	str = str.."\r\n" 
			-- end
		end
		-- debug.log(str,"Text_luck_documentary")
		-- self.Text_luck_documentary:setContentSize(cc.size(560,150))
		self.Text_luck_documentary:setString(str)
	end
end
-- 播放动画
function ActivityLuckDivination:playAniAll()
	self:playAniBack()
	local drawNum = _ED.active_activity[161].activity_params.extObj.ex[1].divineNum or ""
	drawNum = tostring(drawNum)
	local isHit = {}
	local lucknum = zstring.split(_ED.active_activity[161].need_recharge_count,"@")[2]

	for i=1, 5 do
		
		local char1 = string.sub(drawNum, i, i)
		local char2 = string.sub(lucknum, i, i)
		if char1 == char2 then
			isHit[i] = true
			self.BitmapFontLabel_luck_card[i]:setFntFile("fonts/num_double_hit_2.fnt")
		else
			isHit[i] = false
			self.BitmapFontLabel_luck_card[i]:setFntFile("fonts/num_double_hit.fnt")
		end
		self.BitmapFontLabel_luck_card[i]:setString(char1)
	end
	for i,v in pairs(self.luck_cards_ani) do
		v:setToSetupPose()
		if isHit[i] then
			v:setAnimation(0, "01_fanzhuan", false)
		else
			v:setAnimation(0, "02_fanzhuan", false)
		end
		v:addAnimation(0, "03_chuxian", false,1)
		v:addAnimation(0, "04_chixu", true)
	end
	self.isCardOpen = true
end
function ActivityLuckDivination:playAniBack()
	if self.isCardOpen == true then 
		for i=1, 5 do
			self.BitmapFontLabel_luck_card[i]:setOpacity(0)
		end
		for i,v in pairs(self.luck_cards_ani) do
			v:addAnimation(0, "00_beimian", true)
		end
	end
end
-- 跑马灯
function ActivityLuckDivination:runHourse()
	self.ListView_tuisong:removeAllItems()
	local j = 1
	for i=#_ED.marqueeInfo,1,-1 do
		local data = {}
		data.rank = j
		j = j+1
		data.record = _ED.marqueeInfo[i]
		local cell= state_machine.excute("activity_luck_divination_list_create", 0, data)
		self.ListView_tuisong:addChild(cell)
	end
	
	self.ListView_tuisong:refreshView()
	self.ListView_tuisong_poy = self.ListView_tuisong:getInnerContainer():getPositionY()
	
end

-- function ActivityLuckDivination:runHourseCallFunc(sender)
-- 	if self.isMove == false then
-- 		self.isMove = true
-- 		local winSize = cc.Director:getInstance():getWinSize()
-- 		local posY = self.Text_luck_zmd:getPositionY()
-- 		if table.getn(self.hourseObjRand) <=0 then
-- 			self.hourseObjRand = cloneTable(self.hourseObjTotal)
-- 		end

-- 		self.Text_luck_zmd:setString(self.hourseObjRand[self.m_index])
-- 		local txtLength = self.Text_luck_zmd:getContentSize().width
-- 		local moveStart = cc.MoveTo:create(0, cc.p(winSize.width, posY))
-- 		local moveAppear = cc.MoveTo:create(self.appearTime, cc.p(10, posY))
-- 		local movedisaAppear = cc.MoveBy:create(txtLength/self.disappearanceSpeed, cc.p(-txtLength-10, 0))
		
-- 	    local callfunc = cc.CallFunc:create(function ( sender )
-- 					    	self.m_index = self.m_index + 1
-- 							if self.m_index > table.nums(self.hourseObjRand) then
-- 								self.m_index = 1
-- 							end
-- 							self.isMove = false
-- 							self:runHourseCallFunc()
-- 						end)
-- 		local runSeqAction = cc.Sequence:create(moveStart,moveAppear,cc.DelayTime:create(self.stayTime),movedisaAppear,callfunc)
-- 		self.Text_luck_zmd:runAction(runSeqAction)
-- 		table.remove(self.hourseObjRand,self.m_index)
-- 	end
-- end

function ActivityLuckDivination:onEnterTransitionFinish()
	-- 加载ActivityLuckDivinationWindow界面资源.
	-- res.activity.activity_luck_divination = res/activity/activity_luck_divination.csb
	-- debug.log("ActivityLuckDivination:onEnterTransitionFinish")
	local csbNode = csb.createNode("Lucky/activity_luck_divination.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 幸运占卜说明按键
	self.Button_luck_activity_state = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "activity_luck_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 本次免费按键
	self.Button_luck_free = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_free"), nil,
	{
		terminal_name = "activity_luck_get_num",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 0
	}, nil, 0)	

	-- 占卜十次按键
	self.Button_luck_ten = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_ten"), nil,
	{
		terminal_name = "activity_luck_get_num",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 1
	}, nil, 0)	

	-- 排行榜按键
	self.Button_luck_rank = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_rank"), nil,
	{
		terminal_name = "activity_luck_rank_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	-- 占卜记录
	self.Text_luck_frequency_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Text_luck_frequency_0"), nil,
	{
		terminal_name = "activity_luck_record_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.Text_luck_frequency_0:setTouchEnabled(true)

	self:onUpdateDraw()
end

function ActivityLuckDivination:onExit()
	-- 释放ActivityLuckDivinationWindow界面资源.
	state_machine.remove("activity_luck_divination_open")
	state_machine.remove("activity_luck_divination_close")
	state_machine.remove("activity_luck_divination_show")
	state_machine.remove("activity_luck_divination_hide")
	state_machine.remove("activity_luck_get_num")
	state_machine.remove("divination_marquee")
	
end

function ActivityLuckDivination:close()
	-- window event : close.
	
end

function ActivityLuckDivination:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
