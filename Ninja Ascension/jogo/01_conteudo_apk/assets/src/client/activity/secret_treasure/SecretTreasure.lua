--[[ ----------------------------------------------------------------------------
-- 秘境之旅主界面
--]] ----------------------------------------------------------------------------
SecretTreasure = class("SecretTreasureClass", Window)

-- 打开窗口
local secret_treasure_window_open_terminal = {
	_name = "secret_treasure_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasureClass") then
			fwin:open(SecretTreasure:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_window_close_terminal = {
	_name = "secret_treasure_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasureClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_window_open_terminal)
state_machine.add(secret_treasure_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasure:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0

	-- 活动数据信息
	self._activityData = {}
	self._activityEndTime = nil

	-- 道具Id
	self._propID = nil
	self._costPropCount = nil

	-- ui
	self.Panel_card = {}

	-- 是否处于一键翻牌模式
	self._quickFindMode = false
	-- 一键翻牌奖励
	self.quickRewardList = {}
	-- 可一键翻牌的卡牌
	self.canTurnCardCell = {}

	-- load lua files.
	app.load("client.activity.secret_treasure.secrettreasurecard")
	app.load("client.activity.secret_treasure.SecretTreasureDone")
	app.load("client.activity.secret_treasure.SecretTreasureHandle")
	app.load("client.activity.secret_treasure.secrettreasureitem")
	app.load("client.activity.secret_treasure.SecretTreasurePrompt_1")
	app.load("client.activity.secret_treasure.SecretTreasurePrompt_2")
	app.load("client.activity.secret_treasure.SecretTreasurePrompt_3")
	app.load("client.activity.secret_treasure.SecretTreasureRewards")
	app.load("client.activity.secret_treasure.SecretTreasureRewards0")
	app.load("client.activity.secret_treasure.SecretTreasureRule")
	app.load("client.activity.secret_treasure.SecretTreasureTask")
	app.load("client.activity.secret_treasure.secrettreasuretasklist")

	app.load("client.activity.secret_treasure.SecretTreasureGuide")

	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")

	-- Initialize secret treasure page state machine.
	local function init_secret_treasure_terminal()
		-- 打开角色创建窗口
		local secret_treasure_open_terminal = {
			_name = "secret_treasure_open",
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
		local secret_treasure_close_terminal = {
			_name = "secret_treasure_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_show_terminal = {
			_name = "secret_treasure_show",
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
		local secret_treasure_hide_terminal = {
			_name = "secret_treasure_hide",
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

		-- 查看奖励
		local secret_treasure_preview_reward_terminal = {
			_name = "secret_treasure_preview_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("secret_treasure_rewards_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 道具获取
		local secret_treasure_get_cost_prop_terminal = {
			_name = "secret_treasure_get_cost_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("secret_treasure_task_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 开始寻宝（触发寻宝逻辑）
		local secret_treasure_start_find_terminal = {
			_name = "secret_treasure_start_find",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local final_reward = SecretTreasureHandle.getSecretFinalReward()

					if not final_reward then
						TipDlg.drawTextDailog(tipStringInfo_activity_secret_treasure[3])
						return true
					end
					-- 禁用按钮事件
					state_machine.excute("secret_treasure_change_click_state", 0, false)

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								-- 隐藏查看奖励按钮
								response.node.Button_rewards:setVisible(false)
								-- 播放洗牌动画
								state_machine.excute("secret_treasure_play_ani", 0, {_datas = {index = 1, isLoop = false, widget = instance.Panel_effect}})

								self.Panel_effect:setTouchEnabled(true)
								-- 给Panel_effct添加触摸事件 可以跳过洗牌的流程
								fwin:addTouchEventListener(self.Panel_effect, nil,
								{
									terminal_name = "secret_treasure_skip_start_cg",
									terminal_state = 0,
									isPressedActionEnabled = true,
								}, nil, 0)

								-- 关闭指引
								state_machine.excute("secret_treasure_guide_window_close", 0, nil)
								-- 恢复卡牌背面
								response.node:runAction(cc.Sequence:create(cc.DelayTime:create(6.0), cc.CallFunc:create(function (sender)
									-- 显示查看奖励按钮
									sender.Button_rewards:setVisible(true)
									-- 跳过动画
									sender:skipAnimation()
									-- 启用按钮事件
									state_machine.excute("secret_treasure_change_click_state", 0, true)
								end
								)))
							else
								-- 启用按钮事件
								state_machine.excute("secret_treasure_change_click_state", 0, true)
							end
						else
							-- 启用按钮事件
							state_machine.excute("secret_treasure_change_click_state", 0, true)
						end
					end
					-- 开始寻宝
					protocol_command.secret_travel_next_tier.param_list = "" .. 0
					NetworkManager:register(protocol_command.secret_travel_next_tier.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 一键寻宝
		local secret_treasure_quick_find_terminal = {
			_name = "secret_treasure_quick_find",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local turnTimes = instance:getQuickTurnTimes()

					-- 禁用按钮事件
					state_machine.excute("secret_treasure_change_click_state", 0, false)

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local _self = response.node
							if _self ~= nil and _self.roots ~= nil then
								
								local quickRewardList = self:getQuickTurnRewardInfo()
								local canTurnCardCell = self:getCanQuickTurnCell()

								_self.canTurnCardCell = canTurnCardCell
								_self.quickRewardList = quickRewardList
								_self._quickFindMode = true

								-- 开始翻牌
								_self:quickTurnCard()

								self.Panel_effect:setTouchEnabled(true)
								-- 给Panel_effct添加触摸事件 可以跳过一键翻牌的流程
								fwin:addTouchEventListener(self.Panel_effect, nil,
								{
									terminal_name = "secret_treasure_skip_quick_turn_card",
									terminal_state = 0,
									isPressedActionEnabled = true,
								}, nil, 0)
							end
						else
							-- 启用按钮事件
							state_machine.excute("secret_treasure_change_click_state", 0, true)
						end
					end

					-- 清空奖励内容
					_ED.show_reward_list_group = {}
					_ED.show_reward_list_group_ex = {}

					-- 一键寻宝
					protocol_command.secret_travel_draw.param_list = "" .. turnTimes
					NetworkManager:register(protocol_command.secret_travel_draw.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面
		local secret_treasure_refresh_ui_terminal = {
			_name = "secret_treasure_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateUI()
					state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 173)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 创建飞到查看奖励的图标
		local secret_treasure_add_fly_card_terminal = {
			_name = "secret_treasure_add_fly_card",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:createFlyCard(params)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 帮助
		local secret_treasure_help_terminal = {
			_name = "secret_treasure_help",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("secret_treasure_rule_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新道具数量
		local secret_treasure_refresh_cost_prop_count_terminal = {
			_name = "secret_treasure_refresh_cost_prop_count",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateCostProp()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新终极奖励
		local secret_treasure_refresh_final_reward_terminal = {
			_name = "secret_treasure_refresh_final_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateFinalReward()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 播放动画
		local secret_treasure_play_ani_terminal = {
			_name = "secret_treasure_play_ani",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:setAllCardsVisibleState(false)

					local index = params._datas.index
					local isLoop = params._datas.isLoop
					local widget = params._datas.widget
					instance:startCardAnimation(index, isLoop, widget)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 结束动画
		local secret_treasure_stop_ani_terminal = {
			_name = "secret_treasure_stop_ani",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:skipAnimation()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 执行卡牌掉落动画
		local secret_treasure_card_drop_ani_terminal = {
			_name = "secret_treasure_card_drop_ani",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:dropNotTurnCard()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 更改翻牌状态
		local secret_treasure_change_quick_card_state_terminal = {
			_name = "secret_treasure_change_quick_card_state",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance._quickFindMode = params
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 禁用/启用按钮和点击事件
		local secret_treasure_change_click_state_terminal = {
			_name = "secret_treasure_change_click_state",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:setAllButtonEnableState(params)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 获取当前是否处于一键翻牌
		local secret_treasure_get_quick_turn_state_terminal = {
			_name = "secret_treasure_get_quick_turn_state",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					return instance._quickFindMode
				end
				return false
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 跳过一键翻牌
		local secret_treasure_skip_quick_turn_card_terminal = {
			_name = "secret_treasure_skip_quick_turn_card",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					-- 关闭一键翻牌
					state_machine.excute("secret_treasure_change_quick_card_state", 0, false)
					-- 取消Panel_effect的触摸事件
					self.Panel_effect:setTouchEnabled(false)
					fwin:removeTouchEventListener(self.Panel_effect)
					-- 停止cell动作执行
					local Panel_card = instance.Panel_card
					for i, v in ipairs(Panel_card) do
						local cell = v:getChildByName("card_"..i)
						if cell ~= nil then
							cell:stopAllActions()
						end
					end
					-- 展示一键寻宝获得的奖励
					local finalRewardData = _ED.show_reward_list_group[1] and _ED.show_reward_list_group[1].show_reward_list or {}
					local normalRewardData = _ED.show_reward_list_group[2] and _ED.show_reward_list_group[2].show_reward_list or {}

					local rewards = {}
					rewards.show_reward_item_count = 0
					rewards.show_reward_list = {}
					
					for _, v in ipairs(normalRewardData) do
						table.insert(rewards.show_reward_list, v)
						rewards.show_reward_item_count = rewards.show_reward_item_count + 1
					end

					for _, v in ipairs(finalRewardData) do
						table.insert(rewards.show_reward_list, v)
						rewards.show_reward_item_count = rewards.show_reward_item_count + 1
					end

					-- debug.print_r(rewards, "rewards")

					local getRewardWnd = DrawRareReward:new()
					getRewardWnd:init(nil, rewards)
					fwin:open(getRewardWnd, fwin._ui)

					--刷新界面
					state_machine.excute("secret_treasure_refresh_ui", 0, nil)
				end
				return false
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 进入下一层
		local secret_treasure_go_to_next_floor_terminal = {
			_name = "secret_treasure_go_to_next_floor",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					-- 禁用按钮事件
					state_machine.excute("secret_treasure_change_click_state", 0, false)

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								-- 卡牌掉落
								state_machine.excute("secret_treasure_card_drop_ani", 0, nil)

								response.node:runAction(cc.Sequence:create(
									cc.DelayTime:create(0.5),
									cc.CallFunc:create(function (sender)
										-- 播放换层动画
										state_machine.excute("secret_treasure_play_ani", 0, {_datas = {index = 5, isLoop = false}})
										-- 提前把卡刷新出来
										sender:updateUI()
										sender:setAllCardsVisibleState(true)
									end),
									cc.DelayTime:create(1.8), 
									cc.CallFunc:create(function (sender)
										-- 翻页动画播完后显示指引
										sender:showGuide(1)
										-- 刷新主界面
										sender:skipAnimation(true)
										-- 启用按钮事件
										state_machine.excute("secret_treasure_change_click_state", 0, true)
									end
								)))
							else
								-- 启用按钮事件
								state_machine.excute("secret_treasure_change_click_state", 0, true)
							end
						else
							-- 启用按钮事件
							state_machine.excute("secret_treasure_change_click_state", 0, true)
						end
					end
					-- 进入下一层
					protocol_command.secret_travel_next_tier.param_list = "" .. 1
					NetworkManager:register(protocol_command.secret_travel_next_tier.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return false
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 跳过洗牌动画
		local secret_treasure_skip_start_cg_terminal = {
			_name = "secret_treasure_skip_start_cg",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					-- 显示查看奖励按钮
					instance.Button_rewards:setVisible(true)
					-- 跳过动画
					instance:skipAnimation()
					-- 启用按钮事件
					state_machine.excute("secret_treasure_change_click_state", 0, true)

					-- 取消Panel_effect的触摸事件
					self.Panel_effect:setTouchEnabled(false)
					fwin:removeTouchEventListener(self.Panel_effect)
				end
				return false
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(secret_treasure_open_terminal)
		state_machine.add(secret_treasure_close_terminal)
		state_machine.add(secret_treasure_show_terminal)
		state_machine.add(secret_treasure_hide_terminal)
		state_machine.add(secret_treasure_preview_reward_terminal)
		state_machine.add(secret_treasure_get_cost_prop_terminal)
		state_machine.add(secret_treasure_start_find_terminal)
		state_machine.add(secret_treasure_quick_find_terminal)
		state_machine.add(secret_treasure_refresh_ui_terminal)
		state_machine.add(secret_treasure_add_fly_card_terminal)
		state_machine.add(secret_treasure_help_terminal)
		state_machine.add(secret_treasure_refresh_cost_prop_count_terminal)
		state_machine.add(secret_treasure_refresh_final_reward_terminal)
		state_machine.add(secret_treasure_play_ani_terminal)
		state_machine.add(secret_treasure_stop_ani_terminal)
		state_machine.add(secret_treasure_card_drop_ani_terminal)
		state_machine.add(secret_treasure_change_quick_card_state_terminal)
		state_machine.add(secret_treasure_change_click_state_terminal)
		state_machine.add(secret_treasure_get_quick_turn_state_terminal)
		state_machine.add(secret_treasure_skip_quick_turn_card_terminal)
		state_machine.add(secret_treasure_go_to_next_floor_terminal)
		state_machine.add(secret_treasure_skip_start_cg_terminal)
		state_machine.init()
	end
	-- call func init secret treasure state machine.
	init_secret_treasure_terminal()
end

-- 对象初始化
function SecretTreasure:init(params)
	self._propID, self._costPropCount = SecretTreasureHandle.getSecretCostPropID()

	self._animationNameList = {"animation", "animation2", "animation3", "animation4", "animation5"}

	self:onInit(params)
	return self
end

function SecretTreasure:onInit(params)
	self._activityData = _ED.active_activity[173]
	self._activityEndTime = self._activityData.end_time
end

-- 动画期间屏蔽按钮点击事件
function SecretTreasure:setAllButtonEnableState(isEnable)
	-- 查看奖励
	self.Button_rewards:setTouchEnabled(isEnable)
	-- 获取按钮
	self.Button_get:setTouchEnabled(isEnable)
	-- 开始本轮寻宝
	self.Button_start:setTouchEnabled(isEnable)
	-- 一键寻宝（默认隐藏）
	self.Button_quick:setTouchEnabled(isEnable)
	-- 关闭
	self.Button_closed:setTouchEnabled(isEnable)
	-- 规则
	self.Button_help:setTouchEnabled(isEnable)

	local Panel_card = self.Panel_card
	for i, v in ipairs(Panel_card) do
		local cell = v:getChildByName("card_"..i)
		if cell ~= nil then
			local root = cell:getChildByName("root")
			if root ~= nil then
				local Panel_1 = root:getChildByName("Panel_1")
				Panel_1:setTouchEnabled(isEnable)
			end
		end
	end

	local cell = self.Panel_final:getChildren()[1]
	if cell ~= nil then
		local root = cell:getChildByName("root")
		if root ~= nil then
			local Panel_item = root:getChildByName("Panel_item")
			Panel_item:setTouchEnabled(isEnable)
		end
	end
end

function SecretTreasure:updateUI()
	-- 指引如果在 先移除
	if fwin:find("SecretTreasureGuideClass") then
		state_machine.excute("secret_treasure_guide_window_close", 0, nil)
	end

	self:updateFloorNumber()
	self:updateCostProp()
	self:updateActivityRemainTime()

	self:updateFinalReward()
	self:updateRightBottomButtonState()

	if self._quickFindMode then
		state_machine.excute("secret_treasure_change_click_state", 0, false)
		self:quickTurnCard()
	else
		-- 启用按钮事件
		state_machine.excute("secret_treasure_change_click_state", 0, true)
		self:updateCards()
	end
end

-- 播放指引 1设置大奖 2开始游戏
function SecretTreasure:showGuide(guideType)
	local widget = guideType == 1 and self.Panel_final or self.Button_start

	state_machine.excute("secret_treasure_guide_window_open", 0, widget)
end

-- 设置右下角 开始寻宝 一键寻宝 寻宝中的显示隐藏状态
function SecretTreasure:updateRightBottomButtonState()
	self.Button_start:setVisible(false)
	self.Button_quick:setVisible(false)
	self.Image_seeking:setVisible(false)

	local isBegin = SecretTreasureHandle.getSecretGameIsBegin()
	if isBegin then
		if self:canQuickTurnCard() then
			self.Button_quick:setVisible(true)
		else
			self.Image_seeking:setVisible(true)
		end
	else
		-- 指引点击开始游戏
		if self.Panel_effect:getChildren()[1] == nil then
			self:showGuide(2)
		end
		self.Button_start:setVisible(true)
	end
end

-- 是否能一键翻牌
-- 道具数量大于等于当前可翻牌数
-- 并且没有抽到终极大奖
function SecretTreasure:canQuickTurnCard()
	local propID = self._propID
	local havePropNum = tonumber(getPropAllCountByMouldId(tonumber(propID)))

	local notTurnCardCount = 0

	for i, v in ipairs(self.Panel_card) do
		local turnState = SecretTreasureHandle.getSecretCardTurnState(i)
		if turnState == 0 then
			notTurnCardCount = notTurnCardCount + 1
		end
	end

	local canGoToNext = SecretTreasureHandle.canGoToNextFloor()
	local needTotalCount = notTurnCardCount * self._costPropCount

	return havePropNum >= needTotalCount and (not canGoToNext)
end

-- 一键翻牌
-- propDatas 翻牌获得的奖励
function SecretTreasure:quickTurnCard()
	if not self._quickFindMode then
		return
	end

 	-- 可翻牌的卡牌大于0 奖励数量大于0
 	-- print("#self.quickRewardList = ", #self.quickRewardList)
	if #self.quickRewardList > 0 and #self.canTurnCardCell > 0 then
		local propData = table.remove(self.quickRewardList, 1)
		local cell = table.remove(self.canTurnCardCell, 1)
		-- 最后一个奖励必然是最终奖励
		local isFinalReward = #self.quickRewardList == 0
		cell:startTurnCard(propData, isFinalReward, true)
	else
		self._quickFindMode = false
		-- print("一键翻牌 启用按钮事件")
		-- 启用按钮事件
		state_machine.excute("secret_treasure_change_click_state", 0, true)
	end
end

-- 获得一键寻宝可以翻牌的次数
function SecretTreasure:getQuickTurnTimes()
	local canTurnCardCell = self:getCanQuickTurnCell()

	local propID = self._propID
	local havePropNum = tonumber(getPropAllCountByMouldId(tonumber(propID)))
	local canTurnCardCount = math.floor(havePropNum / self._costPropCount)

	return math.min(canTurnCardCount, #canTurnCardCell)
end

function SecretTreasure:getCanQuickTurnCell()
	local canTurnCardCell = {}

	local Panel_card = self.Panel_card
	for i, v in ipairs(Panel_card) do
		local cell = v:getChildByName("card_"..i)
		if cell ~= nil then
			table.insert(canTurnCardCell, cell)
		end
	end

	return canTurnCardCell
end

-- 获得一件寻宝的奖励
function SecretTreasure:getQuickTurnRewardInfo()
	local finalRewardData = _ED.show_reward_list_group[1] and _ED.show_reward_list_group[1].show_reward_list or {}
	local normalRewardData = _ED.show_reward_list_group[2] and _ED.show_reward_list_group[2].show_reward_list or {}

	local propData = {}

	local function dealShipData(data)
		if tonumber(data[1]) == 13 then
			local shipMouldID = tonumber(data[2])
			local star = dms.int(dms["ship_mould"], shipMouldID, ship_mould.ship_star)
			if getShipByTemplateId(data[2]) then
				star = tonumber(getShipByTemplateId(shipMouldID).StarRating)
			end
			data[4] = star
		end
		return data
	end

	for _, v in ipairs(normalRewardData) do
		local data = {v.prop_type, v.prop_item, v.item_value, -1}
		data = dealShipData(data)
		table.insert(propData, data)
	end

	for _, v in ipairs(finalRewardData) do
		local data = {v.prop_type, v.prop_item, v.item_value, -1}
		data = dealShipData(data)
		table.insert(propData, data)
	end
	
	return propData
end

-- 跳过洗牌动画
function SecretTreasure:skipAnimation(notUpdateUI)
	self.Button_rewards:setVisible(true)

	if not notUpdateUI then
		self:setAllCardsVisibleState(true)
		self:updateUI()
	end

	self:stopAllActions()
	self.Panel_effect:removeAllChildren(true)
end

-- animation    洗牌动画
-- animation2   最终奖励选择之后的持续动画
-- animation3   翻牌动画
-- animation4   传送门持续动画
-- animation5   换层动画
function SecretTreasure:startCardAnimation(index, isLoop, widget)
	if widget == nil then
		widget = self.Panel_effect
	end

	widget:removeAllChildren(true)

	local animationName = self._animationNameList[index]

	local jsonFile = "images/ui/effice/effect_secret_treasure/effect_secret_treasure.json"
	local atlasFile = "images/ui/effice/effect_secret_treasure/effect_secret_treasure.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, isLoop, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, animationName, isLoop)
	animation:setPosition(cc.p(widget:getContentSize().width/2, widget:getContentSize().height/2))
	widget:addChild(animation)
end

-- 换层时 让所有未翻牌的卡牌掉落
function SecretTreasure:dropNotTurnCard()
	local Panel_card = self.Panel_card

	for i, v in ipairs(Panel_card) do
		local cell = v:getChildByName("card_"..i)
		if cell ~= nil then
			cell:playDropAni()
		end
	end
end

function SecretTreasure:updateFinalReward()
	local Panel_Flashing = self.Panel_Flashing
	Panel_Flashing:removeAllChildren(true)

	local Panel_final = self.Panel_final
	Panel_final:removeAllChildren(true)

	local final_reward = SecretTreasureHandle.getSecretFinalReward()

	-- 设置终极奖励 亮灯
	if final_reward then
		self.Panel_light:setVisible(false)
		self:startCardAnimation(2, true, Panel_Flashing)
	else
		-- 指引设置最终大奖(翻页的时候不显示)
		if self.Panel_effect:getChildren()[1] == nil then
			self:showGuide(1)
		end
		
		self.Panel_light:setVisible(true)
		self.Image_light_off:setVisible(true)
		self.Image_light_on:setVisible(false)
	end

	local cell = state_machine.excute("secret_treasure_item_create", 0, {type = 1, reward = final_reward})
	Panel_final:addChild(cell)
end

function SecretTreasure:updateCards()
	local Panel_card = self.Panel_card

	-- 1背面 2正面+道具 3传送门状态
	-- 2正面+道具只有在开始所有翻牌前有 优先级最高

	-- 是否已经点击了开始寻宝
	local isBegin = SecretTreasureHandle.getSecretGameIsBegin()

	for _, v in ipairs(Panel_card) do
		v:removeAllChildren(true)
	end

	for i, v in ipairs(Panel_card) do
		local curState = nil
		local rewardInfo = nil
		if isBegin then
			local turnState = SecretTreasureHandle.getSecretCardTurnState(i)
			if turnState == 0 then
				curState = 1
			elseif turnState == 3 then
				curState = 3
			end
		else
			curState = 2
			if i > 1 then
				rewardInfo = SecretTreasureHandle.getSecretCommonRewards()[i - 1]
			else
				-- 1号位放置终极大奖
				rewardInfo = SecretTreasureHandle.getSecretFinalReward()
			end
		end
		
		if curState then
			local cell = state_machine.excute("secret_treasure_card_create", 0, {i, curState, rewardInfo})
			cell:setName("card_"..i)
			cell:setAnchorPoint(cc.p(0, 0))
			cell:setPosition(cc.p(0, 0))
			v:addChild(cell)
		end
	end
end

-- 创建普通奖励飞到奖励福袋里
function SecretTreasure:createFlyCard(params)
	local index = params[1]
	local rewardInfo = params[2]

	local startWidget = nil
	for i, v in ipairs(self.Panel_card) do
		if i == index then
			startWidget = v
			break
		end
	end

	if startWidget == nil then
		-- print("can't find startWidget")
		return
	end

	local cell = state_machine.excute("secret_treasure_card_create", 0, {nil, 2, rewardInfo})
	cell:setAnchorPoint(cc.p(0, 0))
	cell:setPosition(cc.p(startWidget:getPosition()))
	self.Panel_cards:addChild(cell)

	local startPos = fwin:convertToWorldSpace(startWidget, cc.p(0, 0))
	local endPos = fwin:convertToWorldSpace(self.Button_rewards, cc.p(0, 0))

	local speed = self._quickFindMode and 1200 or 800
	local s = cc.pGetDistance(startPos, endPos)
	local t = math.abs(s) / speed
	-- print(s, t)

	local moveToAction = cc.MoveTo:create(t, cc.p(startPos, endPos))
	cell:runAction(cc.Sequence:create(moveToAction, 
        cc.CallFunc:create(function () 
            cell:removeFromParent(true)
        end
    )))
end

-- 显示/隐藏所有卡牌
function SecretTreasure:setAllCardsVisibleState(isShow)
	self.Panel_cards:setVisible(isShow)
end

-- 更新层数
function SecretTreasure:updateFloorNumber()
	local curFloor = SecretTreasureHandle.getSecretFloorNumber()
	self.Text_round:setString(string.format(tipStringInfo_activity_secret_treasure[1], curFloor))
end

-- 右侧消耗
function SecretTreasure:updateCostProp()
	local propID = self._propID
	local havePropNum = tonumber(getPropAllCountByMouldId(tonumber(propID)))

	local picIndex = dms.int(dms["prop_mould"], propID, prop_mould.pic_index)
	self.Image_props:loadTexture(string.format("images/ui/props/props_%d.png", picIndex))

	local costPropCount = self._costPropCount
	self.Text_props:setString(havePropNum)

	if havePropNum >= costPropCount then
		self.Text_props:setColor(cc.c3b(255, 255, 255))
	else
		self.Text_props:setColor(cc.c3b(255, 0, 0))
	end
end

function SecretTreasure:onUpdateDraw()
	local root = self.roots[1]

	-- 主题立绘
	self.Image_role = ccui.Helper:seekWidgetByName(root, "Image_role")

	-- 主题标题
	self.Image_title = ccui.Helper:seekWidgetByName(root, "Image_title")

	-- 主题背景
	self.Image_bg = ccui.Helper:seekWidgetByName(root, "Image_bg")

	-- 活动倒计时
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	-- 未激活（熄灭的灯笼）
	self.Image_light_off = ccui.Helper:seekWidgetByName(root, "Image_light_off")

	-- 已激活（点亮的灯笼）
	self.Image_light_on = ccui.Helper:seekWidgetByName(root, "Image_light_on")

	-- 终极奖励道具容器
	self.Panel_final = ccui.Helper:seekWidgetByName(root, "Panel_final")

	-- 第%s层
	self.Text_round = ccui.Helper:seekWidgetByName(root, "Text_round")

	-- 货币图标
	self.Image_props = ccui.Helper:seekWidgetByName(root, "Image_props")

	-- 999/999
	self.Text_props = ccui.Helper:seekWidgetByName(root, "Text_props")

	-- 寻宝中（默认隐藏）
	self.Image_seeking = ccui.Helper:seekWidgetByName(root, "Image_seeking")

	-- Panel_card_11
	self.Panel_card = {}
	for i = 1, 4 do
		for m = 1, 7 do
			local widget = ccui.Helper:seekWidgetByName(root, "Panel_card_"..i..m)
			table.insert(self.Panel_card, widget)
		end
	end

	self.Panel_cards = ccui.Helper:seekWidgetByName(root, "Panel_cards")

	-- 换层洗牌动画容器
	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")

	-- 终极奖励特效
	self.Panel_Flashing = ccui.Helper:seekWidgetByName(root, "Panel_Flashing")

	-- 灯
	self.Panel_light = ccui.Helper:seekWidgetByName(root, "Panel_light")
	
	self:updateUI()
end

function SecretTreasure:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateActivityRemainTime()
		self.totalTime = 0
	end
end

function SecretTreasure:drawTime(_time)
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

function SecretTreasure:updateActivityRemainTime()
	if self.Text_time == nil or self._activityEndTime == nil then
		return
	end
	local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function SecretTreasure:onEnterTransitionFinish()
	-- 加载SecretTreasureWindow界面资源.
	-- res.activity.secret_treasure.secret_treasure = res/activity/secret_treasure/secret_treasure.csb
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 查看奖励
	self.Button_rewards = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rewards"), nil,
	{
		terminal_name = "secret_treasure_preview_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 获取按钮
	self.Button_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_get"), nil,
	{
		terminal_name = "secret_treasure_get_cost_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 开始本轮寻宝
	self.Button_start = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_start"), nil,
	{
		terminal_name = "secret_treasure_start_find",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 一键寻宝（默认隐藏）
	self.Button_quick = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_quick"), nil,
	{
		terminal_name = "secret_treasure_quick_find",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "secret_treasure_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 规则
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "secret_treasure_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function SecretTreasure:onExit()
	-- 释放SecretTreasureWindow界面资源.
	state_machine.remove("secret_treasure_open")
	state_machine.remove("secret_treasure_close")
	state_machine.remove("secret_treasure_show")
	state_machine.remove("secret_treasure_hide")
	state_machine.remove("secret_treasure_preview_reward")
	state_machine.remove("secret_treasure_get_cost_prop")
	state_machine.remove("secret_treasure_start_find")
	state_machine.remove("secret_treasure_quick_find")
	state_machine.remove("secret_treasure_refresh_ui")
	state_machine.remove("secret_treasure_add_fly_card")
	state_machine.remove("secret_treasure_refresh_cost_prop_count")
	state_machine.remove("secret_treasure_refresh_final_reward")
	state_machine.remove("secret_treasure_play_ani")
	state_machine.remove("secret_treasure_stop_ani")
	state_machine.remove("secret_treasure_card_drop_ani")
	state_machine.remove("secret_treasure_change_quick_card_state")
	state_machine.remove("secret_treasure_change_click_state")
	state_machine.remove("secret_treasure_get_quick_turn_state")
	state_machine.remove("secret_treasure_skip_quick_turn_card")
	state_machine.remove("secret_treasure_go_to_next_floor")
	state_machine.remove("secret_treasure_skip_start_cg")
end

function SecretTreasure:close()
	-- window event : close.
	-- 指引如果在 先移除
	if fwin:find("SecretTreasureGuideClass") then
		state_machine.excute("secret_treasure_guide_window_close", 0, nil)
	end
end

function SecretTreasure:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
