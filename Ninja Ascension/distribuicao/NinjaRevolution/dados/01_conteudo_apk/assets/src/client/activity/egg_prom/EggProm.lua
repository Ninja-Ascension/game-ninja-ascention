--[[ ----------------------------------------------------------------------------
-- 彩蛋舞会主界面
--]] ----------------------------------------------------------------------------
EggProm = class("EggPromClass", Window)

-- 打开窗口
local egg_prom_window_open_terminal = {
	_name = "egg_prom_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("EggPromClass") then
			fwin:open(EggProm:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local egg_prom_window_close_terminal = {
	_name = "egg_prom_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EggPromClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_window_open_terminal)
state_machine.add(egg_prom_window_close_terminal)
state_machine.init()

-- 构造器
function EggProm:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0
	self.clickState = false	-- 砸蛋状态

	-- 活动数据信息
	self._activityData = {}
	self._eggPromData = {}
	self._activityEndTime = nil

	-- 道具Id
	self.propIDs = {}

	-- ui
	self.Panel_Egg = {}
	self.Text_harmer = {}
	self.ButtonList = {}

	-- load lua files.
	app.load("client.activity.egg_prom.EggPromReward")
	app.load("client.activity.egg_prom.EggPromRule")
	app.load("client.activity.egg_prom.EggPromTask")
	app.load("client.activity.egg_prom.EggPromTips1")
	app.load("client.activity.egg_prom.EggPromTips2")
	app.load("client.activity.egg_prom.EggPromToGet")

	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.shop.recruit.HeroRecruitSuccess")
	app.load("client.shop.recruit.HeroRecruitSuccessTen")

	app.load("client.reward.DrawRareReward")

	-- Initialize egg prom page state machine.
	local function init_egg_prom_terminal()
		-- 打开角色创建窗口
		local egg_prom_open_terminal = {
			_name = "egg_prom_open",
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
		local egg_prom_close_terminal = {
			_name = "egg_prom_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance.clickState == false then
					state_machine.excute("egg_prom_window_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local egg_prom_show_terminal = {
			_name = "egg_prom_show",
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
		local egg_prom_hide_terminal = {
			_name = "egg_prom_hide",
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

		-- 砸蛋
		local egg_prom_button_click_terminal = {
			_name = "egg_prom_button_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					-- button_type 1, 2, 3
					local button_type = params._datas.button_type
					local times = params._datas.times

					-- 彩蛋舞会抽奖界面类型 9, 10, 11
					local m_type = button_type + 8

					-- 道具不足判定
					if not instance:haveEnoughProp(button_type, times) then
						state_machine.excute("egg_prom_tips2_window_open", 0, nil)
						return true
					end
					instance.clickState = true
					state_machine.lock("egg_prom_button_click")

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								response.node:playEggShakeAni(button_type)
								local seq = cc.Sequence:create({cc.DelayTime:create(2.3), cc.CallFunc:create(function ( sender )
									sender:playEggStandAni(button_type)

									-- -- 弹出奖励弹窗
									-- local getRewardWnd = DrawRareReward:new()
									-- getRewardWnd:init(7)
									-- fwin:open(getRewardWnd, fwin._ui)

									-- 单抽，十连抽沿用限时奖池界面

									if fwin:find("HeroRecruitSuccessClass") ~= nil then
										fwin:close(fwin:find("HeroRecruitSuccessClass"))
									end

									if fwin:find("HeroRecruitSuccessTenClass") ~= nil then
										fwin:close(fwin:find("HeroRecruitSuccessTenClass"))
									end

									getSceneReward(64)
									_ED.show_reward_list_group_ex = {}

									if times == 1 then
										local obj = HeroRecruitSuccess:new()
										obj:setRanking(herorIndex, m_type, false)
										fwin:open(obj, fwin._ui)
									elseif times == 10 then
										local obj = HeroRecruitSuccessTen:new()
										obj:setRanking(herorIndex, m_type, false)
										fwin:open(obj, fwin._ui)
									end

									-- 刷新红点
									state_machine.excute("egg_prom_refresh", 0, nil)
									state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 171)
									instance.clickState = false
								end)})
								response.node:runAction(seq)
							else
								instance.clickState = false
								state_machine.unlock("egg_prom_button_click")
							end
						else
							instance.clickState = false
							state_machine.unlock("egg_prom_button_click")
						end
						_ED.prop_chest_store_recruiting = false
					end

					_ED.new_prop_object = {}
					_ED.recruit_success_ship_id = nil
					_ED.new_reward_object = {}
					_ED.prop_chest_store_recruiting = true
					
					-- 砸蛋类型（0普通，1黄金，2钻石）
					protocol_command.egg_frenzy_draw.param_list = "" .. (button_type - 1) .. "\r\n" .. times
					NetworkManager:register(protocol_command.egg_frenzy_draw.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 购买道具
		local egg_prom_buy_prop_terminal = {
			_name = "egg_prom_buy_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("egg_prom_to_get_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开成就奖励界面
		local egg_prom_open_achievement_terminal = {
			_name = "egg_prom_open_achievement",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("egg_prom_task_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开奖励预览界面
		local egg_prom_show_reward_terminal = {
			_name = "egg_prom_show_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local button_type = params._datas.button_type
					state_machine.excute("egg_prom_reward_window_open", 0, button_type)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开帮助界面
		local egg_prom_help_terminal = {
			_name = "egg_prom_help",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("egg_prom_rule_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面
		local egg_prom_refresh_terminal = {
			_name = "egg_prom_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:onInit()
					instance:updateCostPropCount()
					instance:updateButtonRedDot()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(egg_prom_open_terminal)
		state_machine.add(egg_prom_close_terminal)
		state_machine.add(egg_prom_show_terminal)
		state_machine.add(egg_prom_hide_terminal)
		state_machine.add(egg_prom_button_click_terminal)
		state_machine.add(egg_prom_buy_prop_terminal)
		state_machine.add(egg_prom_open_achievement_terminal)
		state_machine.add(egg_prom_show_reward_terminal)
		state_machine.add(egg_prom_help_terminal)
		state_machine.add(egg_prom_refresh_terminal)
		state_machine.init()
	end
	-- call func init egg prom state machine.
	init_egg_prom_terminal()
end

-- 对象初始化
function EggProm:init(params)
	local tempStr = dms.string(dms["activity_config"], 69, activity_config.param)
	local propIDs =  zstring.split(tempStr, ",")

	self.propIDs = propIDs

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function EggProm:onInit(params)
	self._activityData = _ED.active_activity[171]
	self._eggPromData = self._activityData.eggPromData

	self._activityEndTime = self._activityData.end_time
end
	
function EggProm:updateUI()
	self:updateActivityRemainTime()
	self:updateEggModel()
	self:updateCostPropCount()
	self:updateButtonRedDot()
end

-- 初始化蛋的模型
function EggProm:updateEggModel()
	self._animations = {}

	local Panel_Egg = self.Panel_Egg
	for _, v in ipairs(Panel_Egg) do
		v:removeAllChildren(true)
	end

	for i, v in ipairs(Panel_Egg) do
		local jsonFile = string.format("images/ui/effice/effect_caidanwuhui_dan_%d/effect_caidanwuhui_dan_%d.json", i, i)
		local atlasFile = string.format("images/ui/effice/effect_caidanwuhui_dan_%d/effect_caidanwuhui_dan_%d.atlas", i, i)

		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation2", true, nil)
		sp.initArmature(animation, true)
		animation:setAnimation(0, "animation2", true)
	 	animation:setPosition(v:getContentSize().width / 2, 0)
	 	animation:setScale(0.85)
	 	v:addChild(animation)
		table.insert(self._animations, animation)
	end
end

-- 刷新消耗道具的数量
function EggProm:updateCostPropCount()
	for i, v in ipairs(self.Text_harmer) do
		local propID = self:getNeedCostPropID(i)
		local propCount = tonumber(getPropAllCountByMouldId(propID))
		v:setString("" .. propCount)
	end
end

-- 播放砸蛋动画
function EggProm:playEggShakeAni(eggIndex)
	local animation = self._animations[eggIndex]
	animation:setAnimation(0, "animation", false)
end

-- 播放待机动画
function EggProm:playEggStandAni(eggIndex)
	local animation = self._animations[eggIndex]
	animation:setAnimation(0, "animation2", true)
end

-- 获取消耗道具的id
function EggProm:getNeedCostPropID(eggIndex)
	local propIDs = self.propIDs
	local propID = zstring.tonumber(propIDs[eggIndex])
	return propID
end

-- 是否有足够的道具
function EggProm:haveEnoughProp(eggIndex, times)
	-- 根据索引 读取道具id
	local propID = self:getNeedCostPropID(eggIndex)
	local havePropNum = tonumber(getPropAllCountByMouldId(propID))

	return havePropNum >= times
end

-- 按钮红点的显示
function EggProm:updateButtonRedDot()
	for i, v in ipairs(self.ButtonList) do
		local isShow = false
		if i == 4 then
			isShow = self:canGetTaskReward()
		elseif i == 5 then
			isShow = self:haveEnoughProp(1, 10)
		else
			isShow = self:haveEnoughProp(i, 1)
		end
		self:changeRedDotShowState(i, v, isShow)
	end
end

-- 成就任务是否有可领取的
function EggProm:canGetTaskReward()
	local isShow = false
	local achieveInfos = self._eggPromData.achieveInfo
	for _, v in pairs(achieveInfos) do
		if tonumber(v.rewardStatus) == 1 then
			isShow = true
			break
		end
	end
	return isShow
end

function EggProm:changeRedDotShowState(dotType, widget, isShow)
	if dotType == 4 then
		if widget._istips == true then
			widget:removeChild(widget._nodeChild, true)
			widget._nodeChild = nil
			widget._istips = false
		end

		if isShow then
			if widget._istips == nil or widget._istips == false then
				local ball = cc.Sprite:create("images/ui/bar/tips.png")
				ball:setAnchorPoint(cc.p(1, 1))
				ball:setPosition(cc.p(widget:getContentSize().width-ball:getContentSize().width*0.5, widget:getContentSize().height-ball:getContentSize().height*0.5))
				widget:addChild(ball)
				widget._nodeChild = ball
				widget._istips = true
			end
		end
	else
		widget:setVisible(isShow)
	end
end

function EggProm:onUpdateDraw()
	local root = self.roots[1]

	-- 活动倒计时
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	-- 彩蛋容器1
	self.Panel_egg_1 = ccui.Helper:seekWidgetByName(root, "Panel_egg_1")

	-- 锤子数量1
	self.Text_harmer_1 = ccui.Helper:seekWidgetByName(root, "Text_harmer_1")

	-- 购买锤子
	self.Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")

	-- 彩蛋容器2
	self.Panel_egg_2 = ccui.Helper:seekWidgetByName(root, "Panel_egg_2")

	-- 锤子数量2
	self.Text_harmer_2 = ccui.Helper:seekWidgetByName(root, "Text_harmer_2")

	-- 彩蛋容器3
	self.Panel_egg_3 = ccui.Helper:seekWidgetByName(root, "Panel_egg_3")

	-- 锤子数量3
	self.Text_harmer_3 = ccui.Helper:seekWidgetByName(root, "Text_harmer_3")

	self.Panel_Egg = {self.Panel_egg_1, self.Panel_egg_2, self.Panel_egg_3}
	self.Text_harmer = {self.Text_harmer_1, self.Text_harmer_2, self.Text_harmer_3}

	for i, v in ipairs(self.Panel_Egg) do
		fwin:addTouchEventListener(v, nil,
		{
			terminal_name = "egg_prom_show_reward",
			terminal_state = 0,
			isPressedActionEnabled = true,
			button_type = i,
		}, nil, 0)	
	end


	-- 砸蛋按钮红点
	self.Image_hint_1 = ccui.Helper:seekWidgetByName(root, "Image_hint_1")
	self.Image_hint_2 = ccui.Helper:seekWidgetByName(root, "Image_hint_2")
	self.Image_hint_3 = ccui.Helper:seekWidgetByName(root, "Image_hint_3")
	self.Image_hint_10 = ccui.Helper:seekWidgetByName(root, "Image_hint_10")

	self.ButtonList = {self.Image_hint_1, self.Image_hint_2, self.Image_hint_3, self.Button_task, self.Image_hint_10}

	self:updateUI()
end

function EggProm:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateActivityRemainTime()
		self.totalTime = 0
	end
end

function EggProm:drawTime(_time)
	local timeString = ""
	local _dayTime = math.floor((_time / 1000) / 86400)
	local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
	local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
	local _secondsTime = math.floor((_time / 1000) % 60)
	if _dayTime > 0 then
		timeString = timeString .. _dayTime .._string_piece_info[231]
	end
	if _hourTime < 10 then
		timeString = timeString .. "0".._hourTime ..":"
	else
		timeString = timeString .. _hourTime ..":"
	end

	if _minutesTime < 10 then
		timeString = timeString .. "0".._minutesTime ..":"
	else
		timeString = timeString .. _minutesTime ..":"
	end

	if _secondsTime < 10 then
		timeString = timeString .. "0".._secondsTime 
	else
		timeString = timeString .. _secondsTime 
	end
	return timeString
end

function EggProm:updateActivityRemainTime()
	if self.Text_time == nil or self._activityEndTime == nil then
		return
	end
	local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function EggProm:onEnterTransitionFinish()
	-- 加载EggPromWindow界面资源.
	-- res.activity.egg_prom.egg_prom = res/activity/egg_prom/egg_prom.csb
	local csbNode = csb.createNode("activity/egg_prom/egg_prom.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 成就任务按钮
	self.Button_task = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task"), nil,
	{
		terminal_name = "egg_prom_open_achievement",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 砸蛋按钮1
	self.Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "egg_prom_button_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
		button_type = 1,
		times = 1,
	}, nil, 0)	

	-- 普通砸蛋十连按钮
	self.Button_10 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10"), nil,
	{
		terminal_name = "egg_prom_button_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
		button_type = 1,
		times = 10,
	}, nil, 0)	

	-- 购买锤子
	self.Button_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil,
	{
		terminal_name = "egg_prom_buy_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 砸蛋按钮2
	self.Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "egg_prom_button_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
		button_type = 2,
		times = 1,
	}, nil, 0)	

	-- 砸蛋按钮3
	self.Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
	{
		terminal_name = "egg_prom_button_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
		button_type = 3,
		times = 1,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "egg_prom_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 帮助
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "egg_prom_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function EggProm:onExit()
	-- 释放EggPromWindow界面资源.
	state_machine.remove("egg_prom_open")
	state_machine.remove("egg_prom_close")
	state_machine.remove("egg_prom_show")
	state_machine.remove("egg_prom_hide")
	state_machine.remove("egg_prom_button_click")
	state_machine.remove("egg_prom_buy_prop")
	state_machine.remove("egg_prom_open_achievement")
	state_machine.remove("egg_prom_show_reward")
	state_machine.remove("egg_prom_help")
	state_machine.remove("egg_prom_refresh")
end

function EggProm:close()
	-- window event : close.
	
end

function EggProm:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
