--[[ ----------------------------------------------------------------------------
-- 号令天下主界面
--]] ----------------------------------------------------------------------------
CommandWorld = class("CommandWorldClass", Window)

-- 打开窗口
local command_world_window_open_terminal = {
	_name = "command_world_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CommandWorldClass") then
			fwin:open(CommandWorld:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_window_close_terminal = {
	_name = "command_world_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_window_open_terminal)
state_machine.add(command_world_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorld:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 是否是跨服
	self._isCrossServer = false

	-- 当前处于什么状态 1本服排行榜 2跨服排行榜 3展示奖励
	self._activityState = 1
	self._tempActivityState = self._activityState

	-- 是否是每个阶段的结算时间
	self._enterActivityCutOffTime = false

	self.deltaTime = 1
	self.totalTime = 0

	self._pressIntevalTime = 0.3
	self._initialAnimationSpeed = 1.0
	self._animationSpeed = self._initialAnimationSpeed
	self._animations = {}

	-- load lua files.
	app.load("client.activity.command_world.CommandWorldBuy")
	app.load("client.activity.command_world.commandworldcell1")
	app.load("client.activity.command_world.commandworldcell2")
	app.load("client.activity.command_world.commandworldcell10")
	app.load("client.activity.command_world.CommandWorldGlory")
	app.load("client.activity.command_world.CommandWorldHandle")
	app.load("client.activity.command_world.CommandWorldLvlReward")
	app.load("client.activity.command_world.CommandWorldLvlRewardList")
	app.load("client.activity.command_world.CommandWorldReward")
	app.load("client.activity.command_world.commandworldrewardcell")
	app.load("client.activity.command_world.CommandWorldRule")
	app.load("client.activity.command_world.CommandWorldShop")
	app.load("client.activity.command_world.commandworldshoplist")
	app.load("client.activity.command_world.CommandWorldTask")
	app.load("client.activity.command_world.commandworldtaskcell")
	app.load("client.activity.command_world.CommandWorldPopUp")
	app.load("client.activity.command_world.commandworldbuttoncell")

	app.load("client.cells.utils.sm_item_icon_cell")

	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.shop.recruit.HeroRecruitSuccess")
	app.load("client.shop.recruit.HeroRecruitSuccessTen")

	app.load("client.reward.DrawRareReward")

	-- Initialize command world page state machine.
	local function init_command_world_terminal()
		-- 打开角色创建窗口
		local command_world_open_terminal = {
			_name = "command_world_open",
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
		local command_world_close_terminal = {
			_name = "command_world_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_show_terminal = {
			_name = "command_world_show",
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
		local command_world_hide_terminal = {
			_name = "command_world_hide",
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

		-- shop
		local command_world_open_shop_terminal = {
			_name = "command_world_open_shop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_shop_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- rank
		local command_world_open_rank_terminal = {
			_name = "command_world_open_rank",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 请求排行榜信息0本服 1跨服
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("command_world_reward_window_open", 0, nil)
					end
				end
				protocol_command.activity_orders_world_get_order.param_list = "" .. 0
				NetworkManager:register(protocol_command.activity_orders_world_get_order.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- task
		local command_world_open_task_terminal = {
			_name = "command_world_open_task",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_task_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 特惠礼包
		local command_world_jump_single_recharge_terminal = {
			_name = "command_world_jump_single_recharge",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if _ED.active_activity[152] ~= nil then
					app.load("client.activity.wonderful.ActivitySingleRecharge")
					state_machine.excute("activity_single_recharge_window_open", 0, 152)
				else
					if _ED.active_activity[170] ~= nil then
						app.load("client.activity.private_custom.PrivateCustom")
						state_machine.excute("private_custom_window_open", 0, nil)
					else
						state_machine.excute("shortcut_open_recharge_window", 0, "")
					end
				end

				state_machine.excute("command_world_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- glory
		local command_world_open_glory_terminal = {
			_name = "command_world_open_glory",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if nil == fwin:find("CommandWorldGloryClass") then
							state_machine.excute("command_world_glory_window_open", 0, nil)
						else
							state_machine.excute("command_world_glory_refesh", 0, nil)
						end
					end
				end
				NetworkManager:register(protocol_command.activity_orders_world_glory_list.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新左侧信息
		local command_world_update_left_ui_terminal = {
			_name = "command_world_update_left_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local tabType
					if params and params._datas and params._datas.tabType then
						tabType = params._datas.tabType
					else
						tabType = instance._isCrossServer and 1 or 0
					end

					-- 跨服排行暂未开启
					if tabType == 1 and instance._activityState < 2 then
						TipDlg.drawTextDailog(tipStringInfo_command_world[14])
						return true
					end

					-- 请求排行榜信息0本服 1跨服
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots[1] ~= nil then
								response.node._isCrossServer = tabType == 1
								response.node:updateLeftUI()
							end
						end
					end
					protocol_command.activity_orders_world_get_order.param_list = "" .. tabType
					NetworkManager:register(protocol_command.activity_orders_world_get_order.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- score_reward
		local command_world_open_union_score_reward_terminal = {
			_name = "command_world_open_union_score_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_lvl_reward_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 领取公会积分的奖励
		local command_world_get_union_score_reward_terminal = {
			_name = "command_world_get_union_score_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.lock("command_world_get_union_score_reward", 0, nil)

				-- 工会积分奖励 类型1
				local taskType = 1
				local _, index = CommandWorldHandle.getCommandWorldCanGetUniScoreReward()

				if index == nil then
					return true
				end

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node:startAnimation(2, false, response.node.Panel_flashing)
							local seq = cc.Sequence:create({cc.DelayTime:create(1.2), cc.CallFunc:create(function ( sender )
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								fwin:open(getRewardWnd, fwin._ui)

								-- 刷新红点
								state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 174)
								-- 领取完刷新界面
								state_machine.excute("command_world_refresh_ui", 0, false)

								state_machine.unlock("command_world_get_union_score_reward", 0, nil)
							end)})
							response.node.Panel_flashing:runAction(seq)
						else
							state_machine.unlock("command_world_get_union_score_reward", 0, nil)
						end
					else
						state_machine.unlock("command_world_get_union_score_reward", 0, nil)
					end
				end
				protocol_command.activity_orders_world_get_reward.param_list = "" .. taskType .. "\r\n" .. (index - 1)
				NetworkManager:register(protocol_command.activity_orders_world_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新顶部道具数量
		local command_world_refresh_top_prop_num_terminal = {
			_name = "command_world_refresh_top_prop_num",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateTopUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新整个UI
		local command_world_refresh_ui_terminal = {
			_name = "command_world_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					-- 刷新左侧
					local isNeedRefreshLeftUI = params
					if isNeedRefreshLeftUI then
						instance:updateLeftUI()
					end

					instance:updateNeedChangeUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 捐赠道具
		local command_world_donate_prop_terminal = {
			_name = "command_world_donate_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.lock("command_world_donate_prop", 0, nil)

				local donateType = params.donateType
				local donateCount = params.donateCount
				local isSpecial = params.isSpecial and 1 or 0

				-- print("donateType = ", donateType, "donateCount = ", donateCount, " isSpecial = ", isSpecial)

				-- local Panel_effact = self.Panel_effact
				-- for i, v in ipairs(Panel_effact) do
				-- 	v:removeAllChildren(true)
				-- end

				-- 当前活动的状态
				local activityState = self._activityState
				-- 左侧排行榜显示的是本服/跨服的排行
				local isCrossServer = self._isCrossServer

				local isNeedRefreshLeftUI = (activityState == 1 and isCrossServer == false) or (activityState == 2 and isCrossServer == true) or (isSpecial == 1)

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 捐赠成功的飘字
						state_machine.excute("command_world_pop_up_window_open", 0, {donateCount = donateCount, donateType = donateType})

						-- 刷新红点
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 174)
						-- 刷新界面
						state_machine.excute("command_world_refresh_ui", 0, isNeedRefreshLeftUI)
					else
						state_machine.excute("command_world_refresh_ui", 0, isNeedRefreshLeftUI)
					end
					state_machine.unlock("command_world_donate_prop", 0, nil)
				end
				protocol_command.activity_orders_world_donate.param_list = "" .. (donateType - 1) .. "\r\n" .. donateCount .. "\r\n" ..  isSpecial
				NetworkManager:register(protocol_command.activity_orders_world_donate.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 捐赠道具不足 点击去购买
		local command_word_buy_donate_prop_terminal = {
			_name = "command_word_buy_donate_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 处于领奖状态不能去跳转购买
				if self._activityState == 3 then
					return
				end

				local tabType = params._datas.tabType
				if tabType == 1 or tabType == 2 then
					-- 跳转任务
					state_machine.excute("command_world_open_task", 0, nil)
				else
					-- 商店高级捐献道具是否已购买
					local sellOut = CommandWorldHandle.getCommandWorldGoldShopHaveBuy()
					if sellOut then
						-- 跳转特惠礼包
						state_machine.excute("command_world_jump_single_recharge", 0, nil)
					else
						-- 跳转金币商店
						state_machine.excute("command_world_shop_window_open", 0, 3)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新右侧按钮红点
		local command_word_update_right_red_dot_terminal = {
			_name = "command_word_update_right_red_dot",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateRightButtons()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(command_world_open_terminal)
		state_machine.add(command_world_close_terminal)
		state_machine.add(command_world_show_terminal)
		state_machine.add(command_world_hide_terminal)
		state_machine.add(command_world_open_shop_terminal)
		state_machine.add(command_world_open_rank_terminal)
		state_machine.add(command_world_open_task_terminal)
		state_machine.add(command_world_jump_single_recharge_terminal)
		state_machine.add(command_world_open_glory_terminal)
		state_machine.add(command_world_update_left_ui_terminal)
		state_machine.add(command_world_open_union_score_reward_terminal)
		state_machine.add(command_world_get_union_score_reward_terminal)
		state_machine.add(command_world_refresh_top_prop_num_terminal)
		state_machine.add(command_world_refresh_ui_terminal)
		state_machine.add(command_world_donate_prop_terminal)
		state_machine.add(command_word_buy_donate_prop_terminal)
		state_machine.add(command_word_update_right_red_dot_terminal)
		state_machine.init()
	end
	-- call func init command world state machine.
	init_command_world_terminal()
end

-- 对象初始化
function CommandWorld:init(params)
	-- 动画列表
	self._animationNameList = {"animation", "animation2", "animation3", "animation4", "animation5", "animation6", "animation7", "animation8"}
	self._donateAniList = {{8, 4, 6}, {7, 3, 5}}

	self._minRankStr = zstring.split(dms.string(dms["activity_config"], 74, activity_config.param), ",")
	self._addScoreStr = zstring.split(dms.string(dms["activity_config"], 75, activity_config.param), ",")
	self._badgePropsStr = zstring.splits(dms.string(dms["activity_config"], 76, activity_config.param), "|", ",")
	self._scoreSectionStr = zstring.splits(dms.string(dms["activity_config"], 79, activity_config.param), "|", ",")
	self._costPropDatas = zstring.splits(dms.string(dms["activity_config"], 80, activity_config.param), "|", ",")
	self._cutOffTime = dms.int(dms["activity_config"], 81, activity_config.param)

	self._singleServerEndTime = CommandWorldHandle.getCommandWorldSingleServerEndTime()
	self._crossServerEndTime = CommandWorldHandle.getCommandWorldCrossServerEndTime()
	self._activityEndTime = CommandWorldHandle.getCommandWorldActivityEndTime()

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CommandWorld:updateUI()
	-- 时间
	self:updateSingleServerTime()
	self:updateCrossServerTime()
	self:updateActivityState()

	self:updateRightBottom3()
	-- 右侧
	self:updateRightButtons()

	self:updateLeftUI()
	self:updateNeedChangeUI()

	-- 中间立绘
	self:updateBackGroundImg()
end

function CommandWorld:updateNeedChangeUI()
	-- 捐赠道具数量缓存
	self:updateDonatePropHaveCount()
	-- 公会积分缓存
	self:updateUnionLevelScore()

	-- 上部
	self:updateTopUI()

	-- 右中
	self:updateRightMiddleUI()

	-- 右下
	self:updateRightBottom1()
	self:updateRightBottom2()
end

-- 刷新捐赠道具的数量
function CommandWorld:updateDonatePropHaveCount()
	self._tempDonatePropCountList = {}
	for _, v in ipairs(self._costPropDatas) do
		local count = tonumber(getPropAllCountByMouldId(v[2]))
		table.insert(self._tempDonatePropCountList, count)
	end
end

-- 刷新公会积分的值
function CommandWorld:updateUnionLevelScore()
	local myUnionScoreData = CommandWorldHandle.getCommandWorldUnionScoreRewardInfo()
	self._tempUnionLevelScore = myUnionScoreData.currentScore
end

function CommandWorld:updateLeftUI()
	self.Button_bf:setBright(not self._isCrossServer)
	self.Button_kf:setBright(self._isCrossServer)

	self:updateLeftTopUI()
	self:updateLeftMiddleUI()
	self:updateLeftBottom()
end

function CommandWorld:updateLeftTopUI()
	-- 前三名
	local Top_Three = self.Top_Three
	for i, v in ipairs(Top_Three) do
		v.Panel_character:removeAllChildren(true)
		v.Panel_character:removeBackGroundImage()
		v.Panel_character:setVisible(false)
		v.Text_guild:setVisible(false)
		v.Text_player:setVisible(false)
		v.Image_not:setVisible(false)
		v.Image_player_bg:setVisible(false)
		v.Text_point:setVisible(false)
		v.Text_grade:setVisible(false)		
		v.Image_no:setVisible(false)
		v.Image_player_bg_0:setVisible(false)

		local playerData = CommandWorldHandle.getCommandWorldRankInfoByRank(i)
		if playerData then
			local rankInfo = playerData.rankInfo
			local big_icon_path = nil
			if tonumber(rankInfo.headPic) < 9 then
				big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(rankInfo.headPic))
			else
				big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(rankInfo.headPic))
			end
			v.Panel_character:setBackGroundImage(big_icon_path)
			v.Panel_character:setVisible(true)
			v.Image_player_bg:setVisible(true)

			v.Image_no:setVisible(true)
			v.Image_player_bg_0:setVisible(true)

			v.Text_guild:setString(rankInfo.unionName)
			v.Text_guild:setVisible(true)

			v.Text_player:setString(rankInfo.nickName)
			v.Text_player:setVisible(true)

			v.Text_point:setString(rankInfo.score)
			v.Text_point:setVisible(true)

			v.Text_grade:setString(rankInfo.userLevel)
			v.Text_grade:setVisible(true)
		else
			v.Image_not:setVisible(true)
		end 
	end
end

-- 跑马灯/排名
function CommandWorld:updateLeftMiddleUI()
	local Panel_rank = self.Panel_rank
	Panel_rank:removeAllChildren(true)

	local cell = state_machine.excute("command_world_cell1_create", 0, {isCrossServer = self._isCrossServer})
	Panel_rank:addChild(cell)
end

function CommandWorld:updateLeftBottom()
	local isCrossServer = self._isCrossServer

	local myRankData = CommandWorldHandle.getCommandWorldMyRankInfo()
	local myRankNumber = myRankData.myRankNumber
	local myselfScore = myRankData.myselfScore

	self.Text_mine_0:setString((myRankNumber == -1) and tipStringInfo_command_world[1] or myRankNumber)
	self.Text_point_1_0:setString(myselfScore)

	local minRankStr = self._minRankStr
	local minRankScore = isCrossServer and minRankStr[2] or minRankStr[1]
	self.Text_6:setString(string.format(tipStringInfo_command_world[2], minRankScore))
end

-- 刷新道具数量
function CommandWorld:updateTopUI()
	local badgePropDatas = self._badgePropsStr

	local Text_Badge_Prop_Num = self.Text_Badge_Prop_Num
	for i, v in ipairs(Text_Badge_Prop_Num) do
		local count = getPropAllCountByMouldId(badgePropDatas[i][2])
		v:setString(count)
	end
end

-- 公会积分
function CommandWorld:updateRightMiddleUI()
	local myUnionScoreData = CommandWorldHandle.getCommandWorldUnionScoreRewardInfo()

	local unionName = myUnionScoreData.unionName

	local Text_name = self.Text_name
	-- 如果不在公会了，公会名显示为“暂无公会”
	if CommandWorldHandle.getCommandWorldRoleIsInUnion() == false then
		unionName = tipStringInfo_command_world[15]
	end
	Text_name:setString(unionName)

	self:updateScoreProgress()
	self:updateScoreBox()
end

-- 公会积分进度
function CommandWorld:updateScoreProgress(currentScore)
	if currentScore == nil then
		local myUnionScoreData = CommandWorldHandle.getCommandWorldUnionScoreRewardInfo()
		currentScore = myUnionScoreData.currentScore or 0
	end

	local scoreLimit = 0
	local scoreLevel = table.nums(self._scoreSectionStr)

	local scoreSectionStr = self._scoreSectionStr
	for _, v in ipairs(scoreSectionStr) do
		scoreLimit = tonumber(v[2])
		if currentScore <= scoreLimit then
			scoreLevel = tonumber(v[1])
			break
		end
	end

	currentScore = currentScore >= scoreLimit and scoreLimit or currentScore

	self.Text_loading:setString(currentScore .. "/" .. scoreLimit)
	self.LoadingBar_achievement:setPercent((currentScore / scoreLimit) * 100)

	self.Text_point:setString(scoreLevel)
end

-- 公会积分宝箱
function CommandWorld:updateScoreBox()
	local canReward = CommandWorldHandle.getCommandWorldCanGetUniScoreReward()

	local Panel_flashing = self.Panel_flashing
	Panel_flashing:setVisible(canReward)

	Panel_flashing:removeAllChildren(true)
	if canReward then
		-- 宝箱可领取动画
		self:startAnimation(1, true, Panel_flashing)

		self.Image_box:setVisible(false)
		self.Image_box:setTouchEnabled(false)

		Panel_flashing:setTouchEnabled(true)
		fwin:addTouchEventListener(Panel_flashing, nil,
		{
			terminal_name = "command_world_get_union_score_reward",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
	else
		self.Image_box:setVisible(true)
		self.Image_box:setTouchEnabled(true)

		Panel_flashing:setTouchEnabled(false)
		fwin:removeTouchEventListener(Panel_flashing)
	end
end

-- 捐赠道具的数量
function CommandWorld:updateRightBottom1()
	-- 捐献道具的数量（下忍，中忍，上忍）
	local costPropDatas = self._costPropDatas

	for i, v in ipairs(self.Text_own) do
		-- local count = getPropAllCountByMouldId(costPropDatas[i][2])
		local count = self._tempDonatePropCountList[i]
		v:setString("x" .. count)
	end
end

-- 捐赠按钮的状态控制
function CommandWorld:updateRightBottom2()
	local isLowPropEnough = self._tempDonatePropCountList[1] > 0
	local isMiddlePropEnough = self._tempDonatePropCountList[2] > 0
	local isHighPropEnough = self._tempDonatePropCountList[3] > 0


	self.Button_xiaren:setBright(isLowPropEnough)
	self.Button_zhongren:setBright(isMiddlePropEnough)
	self.Button_shangren:setBright(isHighPropEnough)

	if isLowPropEnough == false then
		fwin:addTouchEventListener(self.Button_xiaren, nil,
		{
			terminal_name = "command_word_buy_donate_prop",
			terminal_state = 0,
			isPressedActionEnabled = true,
			tabType = 1,
		}, nil, 0)
	else
		if self._donateAction == nil then
			self.Button_xiaren:setTag(1)
			self:registerTouchEvent(self.Button_xiaren, self.startDonate)
		end
	end
	
	if isMiddlePropEnough == false then
		fwin:addTouchEventListener(self.Button_zhongren, nil,
		{
			terminal_name = "command_word_buy_donate_prop",
			terminal_state = 0,
			isPressedActionEnabled = true,
			tabType = 2,
		}, nil, 0)
	else
		if self._donateAction == nil then
			self.Button_zhongren:setTag(2)
			self:registerTouchEvent(self.Button_zhongren, self.startDonate)
		end
	end

	if isHighPropEnough == false then
		fwin:addTouchEventListener(self.Button_shangren, nil,
		{
			terminal_name = "command_word_buy_donate_prop",
			terminal_state = 0,
			isPressedActionEnabled = true,
			tabType = 3,
		}, nil, 0)
	else
		if self._donateAction == nil then
			self.Button_shangren:setTag(3)
			self:registerTouchEvent(self.Button_shangren, self.startDonate)
		end
	end

end

-- 捐献道具获得的积分、徽章数量显示
function CommandWorld:updateRightBottom3()
	-- 积分增长数值 徽章增长数值
	local scoreStr = self._addScoreStr
	local badgePropsStr = self._badgePropsStr

	for i, v in ipairs(self.Text_Donate_Get) do
		v.Text_point_up:setString(string.format(tipStringInfo_command_world[3], scoreStr[i]))

		local count = badgePropsStr[i][3]
		v.Text_badge_up:setString("+" .. count)
	end
end

-- animation 宝箱可领取动画
-- animation2 宝箱打开动画

-- animation3 “中忍”单次
-- animation4 “中忍”多次

-- animation5 “上忍”单次
-- animation6 “上忍”多次

-- animation7 “下忍”单次  
-- animation8 “下忍”多次
function CommandWorld:startAnimation(index, isLoop, widget, isLongPress)
	if isLongPress and self._animations[index] then
		return
	end

	widget:removeAllChildren(true)

	local animationName = self._animationNameList[index]

	local jsonFile = "images/ui/effice/effect_command_world/effect_command_world.json"
	local atlasFile = "images/ui/effice/effect_command_world/effect_command_world.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, isLoop, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, animationName, isLoop)
	animation:setPosition(cc.p(widget:getContentSize().width/2, widget:getContentSize().height/2))
	animation:getAnimation():setSpeedScale(1.0 / self._animationSpeed)
	widget:addChild(animation)

	if isLongPress then
		widget:stopAllActions()

		local _self = self
		self._animations[index] = animation
		self._animationIndex = index

		local seq = cc.Sequence:create(
			cc.DelayTime:create(0.5 * self._animationSpeed),
			cc.CallFunc:create(function(sender) 
				_self._animations[_self._animationIndex] = nil
			end))
		widget:runAction(seq)
	end
end

-- 捐赠逻辑
function CommandWorld:startDonate(donateType, isLongPress)
	-- donateType 1下忍捐赠 2中忍捐赠 3上忍捐赠
	-- isLongPress 是否是长按

	-- print(donateType, isLongPress)
	local donateCount = 1
	if isLongPress then
		self._countingNum = self._countingNum + 1
		donateCount = self._countingNum

		if self._countingNum == 5 then
			if self._donateAction then
				self:stopAction(self._donateAction)
				local seq = cc.Sequence:create(
					cc.DelayTime:create(self._pressIntevalTime / 2),
					cc.CallFunc:create(function(sender) 
						sender:startDonate(donateType, true)
					end))

				self._animationSpeed = self._initialAnimationSpeed / 1.25
				self._donateAction = self:runAction(cc.RepeatForever:create(seq))
			end
		elseif self._countingNum == 10 then
			if self._donateAction then
				self:stopAction(self._donateAction)
				local seq = cc.Sequence:create(
					cc.DelayTime:create(self._pressIntevalTime / 4),
					cc.CallFunc:create(function(sender) 
						sender:startDonate(donateType, true)
					end))

				self._animationSpeed = self._initialAnimationSpeed / 1.5
				self._donateAction = self:runAction(cc.RepeatForever:create(seq))

			end
		end
	end

	local haveCount = self._tempDonatePropCountList[donateType]
	if haveCount > 0 then
		-- if self._isStartAni == false then
			-- self._isStartAni = true
			local index = isLongPress and 1 or 2
			-- local isLoop = isLongPress
			local animationIndex = self._donateAniList[index][donateType]

			self:startAnimation(animationIndex, false, self.Panel_effact[donateType], isLongPress)
		-- end

		-- 刷新进度条
		local score = self._tempUnionLevelScore + donateCount * tonumber(self._addScoreStr[donateType])
		self:updateScoreProgress(score)

		-- 更新捐赠道具的数量
		self._tempDonatePropCountList[donateType] = haveCount - 1
		self:updateRightBottom1()
	end
	if isLongPress then
		if haveCount <= 0 then
			self._isDonate = true
			self:stopAllActions()

			if donateCount - 1 > 0 then
				-- print("长按后请求捐赠(道具不足停止)")
				state_machine.excute("command_world_donate_prop", 0, {donateType = donateType, donateCount = donateCount - 1})
			end
		elseif self._enterActivityCutOffTime == true then
			self._isDonate = true
			self:stopAllActions()

			-- print("压点结算时自动停止并捐赠")
			state_machine.excute("command_world_donate_prop", 0, {donateType = donateType, donateCount = donateCount, isSpecial = true})

			-- 解除结算状态
			self._enterActivityCutOffTime = false
		end
	end
end

-- 如何判断是单击还是长按
function CommandWorld:registerTouchEvent(trigger, touchEvent)
	local _self = self
	local function trigger_onTouchEvent(sender, eventType)
		local donateType = sender:getTag()
		if eventType == ccui.TouchEventType.began then
			_self._donateAction = nil
			_self._countingNum = 0
			_self._isDonate = false
			_self._isStartAni = false
			_self._animationSpeed = _self._initialAnimationSpeed
			_self:stopAllActions()

			-- 处于领奖阶段是不能捐赠的
			if _self._activityState ~= 3 then
				if CommandWorldHandle.getCommandWorldRoleIsInUnion() == true then
					-- 处于结算状态是不能捐赠的
					if _self._enterActivityCutOffTime == false then
						local seq = cc.Sequence:create(
							cc.DelayTime:create(_self._pressIntevalTime),
							cc.CallFunc:create(function(sender) 
								-- print("长按！！")
								touchEvent(_self, donateType, true)
							end))

						_self._donateAction = _self:runAction(cc.RepeatForever:create(seq))
					else
						TipDlg.drawTextDailog(tipStringInfo_command_world[17])
					end
				else
					TipDlg.drawTextDailog(tipStringInfo_command_world[16])
				end
			else
				TipDlg.drawTextDailog(tipStringInfo_command_world[13])
			end
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if _self._donateAction then
				_self:stopAction(_self._donateAction)

				if _self._countingNum == 0 then
					local tempHaveCount = _self._tempDonatePropCountList[donateType]
					if tempHaveCount > 0 then
						-- print("单击后请求捐赠（正常停止）")
						touchEvent(_self, donateType, false)
						state_machine.excute("command_world_donate_prop", 0, {donateType = donateType, donateCount = 1})
					end
				else
					if _self._isDonate == false then
						local donateCount = _self._countingNum
						-- print("长按后请求捐赠(正常停止)")
						state_machine.excute("command_world_donate_prop", 0, {donateType = donateType, donateCount = donateCount})
					end
				end
			end
		end
	end
	trigger:addTouchEventListener(trigger_onTouchEvent)
end

function CommandWorld:onUpdateDraw()
	local root = self.roots[1]

	-- 本服时间
	self.Text_Server_Mine = ccui.Helper:seekWidgetByName(root, "Text_end")
	self.Text_Server_Time_Mine = ccui.Helper:seekWidgetByName(root, "Text_end_time")

	-- 跨服时间
	self.Text_Cross_Server_Mine = ccui.Helper:seekWidgetByName(root, "Text_start")
	self.Text_Cross_Server_Time_Mine = ccui.Helper:seekWidgetByName(root, "Text_start_time")

	-- 前三名数据
	self.Top_Three = {}
	for i = 1, 3 do
		local Panel_character = ccui.Helper:seekWidgetByName(root, "Panel_character_"..i)
		local Text_guild = ccui.Helper:seekWidgetByName(root, "Text_guild_"..i)
		local Text_player = ccui.Helper:seekWidgetByName(root, "Text_player_"..i)
		local Image_not = ccui.Helper:seekWidgetByName(root, "Image_not_"..i)
		local Image_player_bg = ccui.Helper:seekWidgetByName(root, "Image_player_bg_"..i)
		local Text_point = ccui.Helper:seekWidgetByName(root, "Text_point_"..i)
		local Text_grade = ccui.Helper:seekWidgetByName(root, "Text_grade_"..i)
		local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no_"..i)
		local Image_player_bg_0 = ccui.Helper:seekWidgetByName(root, "Image_player_bg_" .. i .."_0")
		
		table.insert(self.Top_Three, {Panel_character = Panel_character, Text_guild = Text_guild, Text_player = Text_player, Image_not = Image_not, Image_player_bg = Image_player_bg, Text_point = Text_point, Text_grade = Text_grade, Image_no = Image_no, Image_player_bg_0 = Image_player_bg_0})
	end

	-- 我的排名
	self.Text_mine_0 = ccui.Helper:seekWidgetByName(root, "Text_mine_0")

	-- 我的积分数值
	self.Text_point_1_0 = ccui.Helper:seekWidgetByName(root, "Text_point_1_0")

	-- 达到积分可上榜
	self.Text_6 = ccui.Helper:seekWidgetByName(root, "Text_6")

	-- 排名展开容器
	self.Panel_rank = ccui.Helper:seekWidgetByName(root, "Panel_rank")

	-- 服务器结束时间
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	-- 角色立绘
	self.Panel_pic = ccui.Helper:seekWidgetByName(root, "Panel_pic")

	-- 公会名
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 积分等级
	self.Text_point = ccui.Helper:seekWidgetByName(root, "Text_point")

	-- 积分进度条
	self.LoadingBar_achievement = ccui.Helper:seekWidgetByName(root, "LoadingBar_achievement")

	-- 积分经验数值
	self.Text_loading = ccui.Helper:seekWidgetByName(root, "Text_loading")

	-- 闭合箱子
	self.Image_box_1 = ccui.Helper:seekWidgetByName(root, "Image_box_1")

	-- 动画容器
	self.Panel_effact = {}
	for i = 1, 3 do
		local Panel_effact = ccui.Helper:seekWidgetByName(root, "Panel_effact_"..i)
		Panel_effact:setTouchEnabled(false)
		table.insert(self.Panel_effact, Panel_effact)
	end

	-- 本服、跨服、领奖结束时间
	self.Image_countdown = {}
	for i = 1, 3 do
		local Image_countdown = ccui.Helper:seekWidgetByName(root, "Image_countdown_"..i)
		table.insert(self.Image_countdown, Image_countdown)
	end

	-- 捐献道具的数量（下忍，中忍，上忍）
	self.Text_own = {}
	for i = 1, 3 do
		local Text_own = ccui.Helper:seekWidgetByName(root, "Text_own_"..i)
		table.insert(self.Text_own, Text_own)
	end

	-- 积分增长数值 徽章增长数值
	self.Text_Donate_Get = {}

	local temp = {}
	temp[1] = ccui.Helper:seekWidgetByName(root, "Text_badge_up_1")
	temp[2] = ccui.Helper:seekWidgetByName(root, "Text_badge_up_1_0")
	temp[3] = ccui.Helper:seekWidgetByName(root, "Text_badge_up_1_1")

	for i = 1, 3 do
		local Text_point_up = ccui.Helper:seekWidgetByName(root, "Text_point_up_"..i)
		local Text_badge_up = temp[i]
		table.insert(self.Text_Donate_Get, {Text_point_up = Text_point_up, Text_badge_up = Text_badge_up})
	end

	-- 普通徽章道具持有数量
	self.Text_110 = ccui.Helper:seekWidgetByName(root, "Text_110")

	-- 中级徽章道具持有数量
	self.Text_121 = ccui.Helper:seekWidgetByName(root, "Text_121")

	-- 高级徽章道具持有数量
	self.Text_111 = ccui.Helper:seekWidgetByName(root, "Text_111")

	-- 徽章的数量 普通，中级，高级
	self.Text_Badge_Prop_Num = {}
	table.insert(self.Text_Badge_Prop_Num, self.Text_111)
	table.insert(self.Text_Badge_Prop_Num, self.Text_121)
	table.insert(self.Text_Badge_Prop_Num, self.Text_110)

	-- 宝箱动画
	self.Panel_flashing = ccui.Helper:seekWidgetByName(root, "Panel_flashing")

	self.Text_yjs_1 = ccui.Helper:seekWidgetByName(root, "Text_yjs_1")
	self.Text_yjs_1:setVisible(true)

	self.Text_yjs_2 = ccui.Helper:seekWidgetByName(root, "Text_yjs_2")
	self.Text_yjs_2:setVisible(true)

	self.ListView_button = ccui.Helper:seekWidgetByName(root, "ListView_button")

	self:updateUI()
end

function CommandWorld:updateBackGroundImg()
	local backGroundImgID = CommandWorldHandle.getCommandWorldBgImgId()
	self.Panel_pic:setTouchEnabled(false)
	self.Panel_pic:removeAllChildren(true)
	self.Panel_pic:removeBackGroundImage()
	self.Panel_pic:setBackGroundImage(string.format("images/ui/text/sm_hd/command_world/command_big_head/command_%s.png", backGroundImgID))
end

-- 刷新右侧按钮
function CommandWorld:updateRightButtons()
	local ListView_button = self.ListView_button
	ListView_button:removeAllItems()

	local activityState = self._activityState
	local tempButtonsShow = {}
	if activityState == 1 then -- 排行，活跃任务，充值有礼，商店
		tempButtonsShow = {1, 2, 3, 4}
	elseif activityState == 2 then -- 排行，活跃任务，充值有礼，商店，荣耀榜
		tempButtonsShow = {1, 2, 3, 4}

		local haveData = CommandWorldHandle.getCommandWorldHaveGloryInfo()
		if haveData then
			table.insert(tempButtonsShow, 5)
		end
	else -- 排行，商店，荣耀榜
		tempButtonsShow = {1, 4}
		local haveData = CommandWorldHandle.getCommandWorldHaveGloryInfo()
		if haveData then
			table.insert(tempButtonsShow, 5)
		end
	end

	for _, v in ipairs(tempButtonsShow) do
		local cell = state_machine.excute("command_world_button_cell_create", 0, {tabType = v})
		ListView_button:addChild(cell)
	end
	ListView_button:jumpToTop()
	ListView_button:requestRefreshView()
end

-- 本服按钮倒计时
function CommandWorld:updateSingleServerTime()
	if self.Text_Server_Mine == nil or self._singleServerEndTime == nil then
		return
	end
	local surplus_time = (self._singleServerEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_Server_Mine:setString(surplus_time > 0 and tipStringInfo_command_world[10] or "")
	self.Text_Server_Time_Mine:setString(surplus_time > 0 and self:drawTime_1(surplus_time) or "")
	self.Text_yjs_1:setString(surplus_time <= 0 and tipStringInfo_command_world[11] or "")
	if surplus_time <= 0 and surplus_time >= - 1010 then
       	if not self._end_refresh then
       		self._end_refresh = true
       		state_machine.excute("command_world_update_left_ui",0, "")
       	end
    end
end

-- 跨服按钮倒计时
function CommandWorld:updateCrossServerTime()
	if self.Text_Cross_Server_Mine == nil or self._crossServerEndTime == nil then
		return
	end
	local surplus_time_1 = (self._singleServerEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	local surplus_time_2 = (self._crossServerEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	-- 本服倒计时结束 即跨服倒计时开始
	local startCrossTime = surplus_time_1 <= 0

	self.Text_Cross_Server_Mine:setString(startCrossTime and tipStringInfo_command_world[10] or tipStringInfo_command_world[12])
	if surplus_time_1 > 0 then
		self.Text_Cross_Server_Time_Mine:setString(self:drawTime_1(surplus_time_1))
	else
		self.Text_Cross_Server_Time_Mine:setString(surplus_time_2 > 0 and self:drawTime_1(surplus_time_2) or "")
	end

	if surplus_time_2 <= 0 then
		self.Text_Cross_Server_Mine:setString("")
		self.Text_yjs_2:setString(tipStringInfo_command_world[11])
		self.Text_yjs_2:setVisible(true)
	else
		self.Text_yjs_2:setVisible(false)
	end

	if surplus_time_2 <= 0 and surplus_time_2 >= - 1010 then
       	if not self._end_refresh then
       		self._end_refresh = true
       		state_machine.excute("command_world_update_left_ui",0, "")
       	end
    end
end

function CommandWorld:updateActivityState()
	local surplus_time_1 = (self._singleServerEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	local surplus_time_2 = (self._crossServerEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	local surplus_time_3 = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)

	if surplus_time_1 > 0 then
		self._activityState = 1
		self:updateEndTime(surplus_time_1)
	elseif surplus_time_2 > 0 then
		self._activityState = 2
		self:updateEndTime(surplus_time_2)
	else
		self._activityState = 3
		self:updateEndTime(surplus_time_3)
	end

	self._enterActivityCutOffTime = false

	if surplus_time_1 <= 0 then
		if math.abs(surplus_time_1) <= self._cutOffTime * 1000 then
			self._enterActivityCutOffTime = true
		end
	end
	if surplus_time_2 <= 0 then
		if math.abs(surplus_time_2) <= self._cutOffTime * 1000 then
			self._enterActivityCutOffTime = true
		end
	end

	-- print("self._enterActivityCutOffTime = ", self._enterActivityCutOffTime)

	if self._tempActivityState ~= self._activityState then
		self._tempActivityState = self._activityState
		self:updateRightButtons()

		for i, v in ipairs(self.Image_countdown) do
			if self._activityState == i then
				v:setVisible(true)
			else
				v:setVisible(false)
			end
		end
	end
end

-- 更新倒计时
function CommandWorld:updateEndTime(surplus_time)
	if self.Text_time == nil or surplus_time == nil then
		return
	end
	self.Text_time:setString(surplus_time <= 0 and _string_piece_info[305] or self:drawTime_1(surplus_time))
end

function CommandWorld:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateSingleServerTime()
		self:updateCrossServerTime()
		self:updateActivityState()
		self.totalTime = 0
	end
end

-- HH:mm:ss
function CommandWorld:drawTime_1(_time)
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

-- function CommandWorld:drawTime_2(_time)
-- 	local timeString = ""
-- 	local _dayTime = math.floor((_time / 1000) / 86400)
-- 	local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
-- 	local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
-- 	local _secondsTime = math.floor((_time / 1000) % 60)
-- 	if _dayTime > 0 then
-- 		timeString = timeString .. _dayTime .._string_piece_info[231]
-- 	end
-- 	timeString = timeString .. _hourTime .. "h"
-- 	timeString = timeString .. _minutesTime .. "m"

-- 	return timeString
-- end

function CommandWorld:onEnterTransitionFinish()
	-- 加载CommandWorldWindow界面资源.
	-- res.activity.command_world.command_world = res/activity/command_world/command_world.csb
	local csbNode = csb.createNode("activity/command_world/command_world.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self.Button_xiaren = ccui.Helper:seekWidgetByName(root, "Button_xiaren")
	self.Button_zhongren = ccui.Helper:seekWidgetByName(root, "Button_zhongren")
	self.Button_shangren = ccui.Helper:seekWidgetByName(root, "Button_shangren")

	-- 规则界面
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "command_world_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "command_world_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 本服
	self.Button_bf = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bf"), nil,
	{
		terminal_name = "command_world_update_left_ui",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabType = 0,
	}, nil, 0)	

	-- 跨服
	self.Button_kf = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf"), nil,
	{
		terminal_name = "command_world_update_left_ui",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabType = 1,
	}, nil, 0)	

	-- 打开公会积分界面
	self.Image_box = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_box"), nil,
	{
		terminal_name = "command_world_open_union_score_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.Image_box:setTouchEnabled(true)

	-- 刷新按钮
	self.Button_re = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_re"), nil,
	{
		terminal_name = "command_world_update_left_ui",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	
	self:onUpdateDraw()

	-- 刷新一下home界面号令忍界限时道具图标
	state_machine.excute("home_update_back_pack_clock_pic", 0, nil)
end

function CommandWorld:onExit()
	-- 释放CommandWorldWindow界面资源.
	state_machine.remove("command_world_open")
	state_machine.remove("command_world_close")
	state_machine.remove("command_world_show")
	state_machine.remove("command_world_hide")
	state_machine.remove("command_world_open_shop")
	state_machine.remove("command_world_open_rank")
	state_machine.remove("command_world_open_task")
	state_machine.remove("command_world_jump_single_recharge")
	state_machine.remove("command_world_open_glory")
	state_machine.remove("command_world_update_left_ui")
	state_machine.remove("command_world_open_union_score_reward")
	state_machine.remove("command_world_get_union_score_reward")
	state_machine.remove("command_world_refresh_top_prop_num")
	state_machine.remove("command_world_refresh_ui")
	state_machine.remove("command_word_buy_donate_prop")
	state_machine.remove("command_word_update_right_red_dot")
end

function CommandWorld:close()
	-- window event : close.
	
end

function CommandWorld:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
