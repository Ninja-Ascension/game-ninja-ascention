--[[ ----------------------------------------------------------------------------
-- 限时奖池主界面
--]] ----------------------------------------------------------------------------
LimPool = class("LimPoolClass", Window)

-- 打开窗口
local lim_pool_window_open_terminal = {
	_name = "lim_pool_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LimPoolClass") then
			fwin:open(LimPool:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local lim_pool_window_close_terminal = {
	_name = "lim_pool_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LimPoolClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_window_open_terminal)
state_machine.add(lim_pool_window_close_terminal)
state_machine.init()

-- 构造器
function LimPool:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0

	-- 存放特殊奖励的UI
	self._Panel_reward_icons = {}
	-- 存放抽取按钮和次数按钮
	self._ButtonList = {}

	-- 活动数据信息
	self._activityData = {}
	self._activityEndTime = nil
	self._activityRealCloseTime = nil

	-- 活动类型
	self._activityType = 0

	-- load lua files.
	app.load("client.activity.lim_pool.LimPoolRule")
	app.load("client.activity.lim_pool.LimPoolPreview")
	app.load("client.activity.lim_pool.LimPoolToGet")
	app.load("client.activity.lim_pool.LimPoolRanking")
	app.load("client.activity.lim_pool.LimPoolRecord")
	app.load("client.activity.lim_pool.LimPoolTips")
	app.load("client.activity.lim_pool.LimUserTopInfo")
	app.load("client.activity.lim_pool.limpoolrankinglistmain")
	app.load("client.activity.lim_pool.limpoolrecordlist")
	app.load("client.activity.lim_pool.limpoolrewardlist")

	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.shop.recruit.HeroRecruitSuccess")
	app.load("client.shop.recruit.HeroRecruitSuccessTen")

	app.load("client.reward.DrawRareReward")

	-- Initialize lim pool page state machine.
	local function init_lim_pool_terminal()
		-- 打开角色创建窗口
		local lim_pool_open_terminal = {
			_name = "lim_pool_open",
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
		local lim_pool_close_terminal = {
			_name = "lim_pool_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local lim_pool_show_terminal = {
			_name = "lim_pool_show",
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
		local lim_pool_hide_terminal = {
			_name = "lim_pool_hide",
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

		-- 跳转单笔充值
		local lim_pool_jump_single_recharge_terminal = {
			_name = "lim_pool_jump_single_recharge",
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
					state_machine.excute("shortcut_open_recharge_window", 0, "")
				end

				state_machine.excute("lim_pool_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 抽取奖励（1次 10次）
		local lim_pool_get_reward_terminal = {
			_name = "lim_pool_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local state = instance:getCanDrawReward()
				if not state then
					TipDlg.drawTextDailog(tipStringInfo_activity_limit_pool[5])
					return true
				end

				local times = params._datas.times
				local m_type = params._datas.m_type

				if not instance:haveEnoughProp(times) then
					state_machine.excute("lim_pool_tips_window_open", 0, 0)
					return true
				end

				state_machine.lock("lim_pool_get_reward")
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
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
								state_machine.excute("hero_recruit_success_set_activity_type", 0, instance._activityType)
								obj:setRanking(herorIndex, m_type, true)
								fwin:open(obj, fwin._ui)
							elseif times == 10 then
								local obj = HeroRecruitSuccessTen:new()
								state_machine.excute("hero_recruit_success_ten_set_activity_type", 0, instance._activityType)
								obj:setRanking(herorIndex, m_type, true)
								fwin:open(obj, fwin._ui)
							end
							
							state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
							state_machine.excute("lim_pool_refesh_windows", 0, 0)
							-- 刷新活动按钮红点
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, instance._activityType)
							-- 刷新道具的数量
							state_machine.excute("lim_user_top_info_refresh_prop_count", 0, 0)	
						else
							state_machine.unlock("lim_pool_get_reward")
						end
					else
						state_machine.unlock("lim_pool_get_reward")
					end
					_ED.prop_chest_store_recruiting = false
				end

				_ED.new_prop_object = {}
				_ED.recruit_success_ship_id = nil
				_ED.new_reward_object = {}
				_ED.prop_chest_store_recruiting = true

				if instance._activityType == 168 then
					protocol_command.time_limit_jackpot_draw.param_list = "" .. times
					NetworkManager:register(protocol_command.time_limit_jackpot_draw.code, nil, nil, nil, instance, responseCallback, false, nil)
				elseif instance._activityType == 188 then
					protocol_command.cross_time_limit_jackpot_draw.param_list = "" .. times
					NetworkManager:register(protocol_command.cross_time_limit_jackpot_draw.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 查看积分排行详情
		local lim_pool_open_rank_list_detail_terminal = {
			_name = "lim_pool_open_rank_list_detail",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("lim_pool_ranking_window_open", 0, {instance._activityType})
					end
				end
				
				if instance._activityType == 168 then
					NetworkManager:register(protocol_command.time_limit_jackpot_rank.code, nil, nil, nil, instance, responseCallback, false, nil)	
				elseif instance._activityType == 188 then
					NetworkManager:register(protocol_command.cross_time_limit_jackpot_rank.code, nil, nil, nil, instance, responseCallback, false, nil)	
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 奖励预览
		local lim_pool_open_reward_preview_terminal = {
			_name = "lim_pool_open_reward_preview",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_preview_window_open", 0, {instance._activityType})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开抽奖公告界面
		local lim_pool_open_reward_record_terminal = {
			_name = "lim_pool_open_reward_record",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("lim_pool_record_window_open", 0, instance._activityType)
					end
				end
				if instance._activityType == 168 then
					NetworkManager:register(protocol_command.time_limit_jackpot_notice.code, nil, nil, nil, instance, responseCallback, false, nil)	
				elseif instance._activityType == 188 then
					NetworkManager:register(protocol_command.cross_time_limit_jackpot_notice.code, nil, nil, nil, instance, responseCallback, false, nil)	
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开获取次数界面
		local lim_pool_open_get_cost_prop_window_terminal = {
			_name = "lim_pool_open_get_cost_prop_window",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local state = instance:getCanDrawReward()
				if not state then
					TipDlg.drawTextDailog(tipStringInfo_activity_limit_pool[5])
					return true
				end

				state_machine.excute("lim_pool_to_get_window_open", 0, {instance._activityType})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新主界面
		local lim_pool_refesh_windows_terminal = {
			_name = "lim_pool_refesh_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:onInit()
					instance:updateLeftRankList()
					instance:updateNewsList()
					instance:updateButtonRedDot()
					instance:updateMyRankInfo()
					instance:updateBigRewardProgress()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新主界面红点
		local lim_pool_refesh_red_dot_terminal = {
			_name = "lim_pool_refesh_red_dot",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:onInit()
					instance:updateButtonRedDot()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新排行榜
		local lim_pool_refesh_rank_terminal = {
			_name = "lim_pool_refesh_rank",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							state_machine.excute("lim_pool_refesh_windows", 0, 0)
						end
					end
				end
				
				if instance._activityType == 168 then
					NetworkManager:register(protocol_command.time_limit_jackpot_init.code, nil, nil, nil, instance, responseCallback, false, nil)	
				elseif instance._activityType == 188 then
					NetworkManager:register(protocol_command.cross_time_limit_jackpot_init.code, nil, nil, nil, instance, responseCallback, false, nil)	
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(lim_pool_open_terminal)
		state_machine.add(lim_pool_close_terminal)
		state_machine.add(lim_pool_show_terminal)
		state_machine.add(lim_pool_hide_terminal)
		state_machine.add(lim_pool_jump_single_recharge_terminal)
		state_machine.add(lim_pool_get_reward_terminal)
		state_machine.add(lim_pool_open_rank_list_detail_terminal)
		state_machine.add(lim_pool_open_reward_preview_terminal)
		state_machine.add(lim_pool_open_reward_record_terminal)
		state_machine.add(lim_pool_open_get_cost_prop_window_terminal)
		state_machine.add(lim_pool_refesh_windows_terminal)
		state_machine.add(lim_pool_refesh_red_dot_terminal)
		state_machine.add(lim_pool_refesh_rank_terminal)

		state_machine.init()
	end
	-- call func init lim pool state machine.
	init_lim_pool_terminal()
end

-- 对象初始化
function LimPool:init(params)
	self._activityType = params
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function LimPool:onInit(params)
	self._activityData = _ED.active_activity[self._activityType]
	self._activityRealCloseTime = self._activityData.activityRealCloseTime
	self._activityEndTime = self._activityData.end_time
end

-- 充值金额数
function LimPool:updateRechargeCost()
	local taskInfos = self._activityData.info.taskInfos

	local rechargeCost = 6480
	for _, v in pairs(taskInfos) do
		if tonumber(v.taskType) == 6 then
			rechargeCost = v.taskCostGoldNumber
			break
		end
	end
	self.Text_chance:setString(string.format(tipStringInfo_activity_limit_pool[3], rechargeCost))
end

-- 获取消耗道具的id
function LimPool:getNeedCostPropID()
	local propID  = 0
	if self._activityType == 168 then
		propID= dms.int(dms["activity_config"], 62, activity_config.param)
	elseif self._activityType == 188 then
		propID= dms.int(dms["activity_config"], 112, activity_config.param)
	end
	return propID
end

-- 消耗道具数
function LimPool:updateCostPropCount()
	local cost_1 = 1
	local cost_10 = 10
	self.Text_zuanshi_1:setString(cost_1)
	self.Text_zuanshi_2:setString(cost_10)
end

function LimPool:getSortRecordInfo()
	local noticeInfo = self._activityData.noticeInfo or {}
	local sortNoticeInfo = {}
	for _, v in pairs(noticeInfo) do
		table.insert(sortNoticeInfo, v)
	end

	table.sort(sortNoticeInfo, function(a, b)
		return tonumber(a.updateTime) > tonumber(b.updateTime)
	end)

	local newSortInfo = {}
	local count = 0
	for _, v in ipairs(sortNoticeInfo) do
		if count < 3 then
			table.insert(newSortInfo, v)
			count = count + 1
		end
	end

	return newSortInfo
end

function LimPool:updateNewsList()
	local ListView_news = self.ListView_news
	ListView_news:removeAllItems()

	local news = self:getSortRecordInfo()
	for _, v in ipairs(news) do
		local cell = state_machine.excute("lim_pool_record_list_create", 0, v)
		ListView_news:addChild(cell)
	end

	ListView_news:jumpToTop()
	ListView_news:requestRefreshView()
end

-- 获取最新三条排行信息
function LimPool:getLeftSortRankInfo()
	local rankInfo = self._activityData.rankInfo
	local sortRankInfo = {}
	for _, v in pairs(rankInfo) do
		table.insert(sortRankInfo, v)
	end

	table.sort(sortRankInfo, function(a, b)
		local rankA = tonumber(a.rank)
		local rankB = tonumber(b.rank)

		if rankA == rankB then
			local updateTimeA = tonumber(a.updateTime)
			local updateTimeB = tonumber(b.updateTime)
			return updateTimeA < updateTimeB
		else
			return rankA < rankB
		end
		return false
	end)

	local newSortInfo = {}
	local count = 0
	for _, v in ipairs(sortRankInfo) do
		if count < 3 then
			table.insert(newSortInfo, v)
			count = count + 1
		end
	end
	return newSortInfo
end

-- 显示左侧积分排行信息（最新3条）
function LimPool:updateLeftRankList()
	local ListView_points = self.ListView_points
	ListView_points:removeAllItems()

	local rankListInfo = self:getLeftSortRankInfo()

	for _, v in pairs(rankListInfo) do
		local cell = state_machine.excute("lim_pool_ranking_list_main_create", 0, {rankInfo = v, _activityType = self._activityType})
		ListView_points:addChild(cell)
	end

	ListView_points:jumpToTop()
	ListView_points:requestRefreshView()
end

function LimPool:getLeftSortRankReward()
	local rankRewards = self._activityData.info.randRewards
	local sortRankRewards = {}
	for _, v in pairs(rankRewards) do
		table.insert(sortRankRewards, v)
	end

	table.sort(sortRankRewards,  function(a, b)
		return tonumber(a.rankIndex) < tonumber(b.rankIndex)
	end)

	return sortRankRewards
end

-- 显示左侧积分排行奖励
function LimPool:updateLeftRankReward()
	local ListView_rank_reward = self.ListView_rank_reward
	ListView_rank_reward:removeAllItems()

	local rankRewards = self:getLeftSortRankReward()
	for _, v in ipairs(rankRewards) do
		local cell = state_machine.excute("lim_pool_reward_list_create", 0, v)
		ListView_rank_reward:addChild(cell)
	end

	ListView_rank_reward:jumpToTop()
	ListView_rank_reward:requestRefreshView()
end

-- 显示右侧特殊奖励
function LimPool:updateRightReward()
	local tempStr = self._activityData.info.specialRewards
	local specialRewards = zstring.splits(tempStr, "|", ",")
	for i = 1, #self._Panel_reward_icons do
		local Panel_reward_icon = self._Panel_reward_icons[i]
		Panel_reward_icon:removeAllChildren(true)
		Panel_reward_icon:setVisible(false)

		local reward = specialRewards[i]
		if reward then
			local cell = self:addResourcesIconCell(reward)
			Panel_reward_icon:setVisible(true)
			Panel_reward_icon:addChild(cell)
		end
	end
end

function LimPool:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function LimPool:updateActivityRemainTime()
	if self.Text_time_0 == nil or self._activityRealCloseTime == nil then
		return
	end
	local surplus_time = (self._activityRealCloseTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time_0:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
	if surplus_time < 0 and surplus_time >= - 1010 then
       	if not self._end_refresh then
       		self._end_refresh = true
       		state_machine.excute("lim_pool_refesh_rank",0, "")
       	end
    end
end

-- 抽取倒计时
function LimPool:updateExtractRemainTime()
	if self.Text_time == nil or self._activityEndTime == nil then
		return
	end
	local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

-- 我的排行相关信息
function LimPool:updateMyRankInfo()
	local myRankInfo = self._activityData.myRankInfo
	-- 上榜提示
	local upLimit = nil
	if self._activityType == 168 then
		upLimit = dms.string(dms["activity_config"], 65, activity_config.param)
	elseif self._activityType == 188 then
		upLimit = dms.string(dms["activity_config"], 115, activity_config.param)
	end
	self.Text_tips_1:setString(upLimit)

	if myRankInfo then
		-- 我的积分
		if myRankInfo.score then
			self.Text_points_n:setString(myRankInfo.score)
		else
			self.Text_points_n:setString("0")
		end
		
		-- 我的排行
		local rankStr = tipStringInfo_activity_limit_pool[4]
		if myRankInfo.visible and 1 == tonumber(myRankInfo.visible) then
			rankStr = tostring(myRankInfo.rank)
		end 
		self.Text_ranking_n:setString(rankStr)
	end
	
end


-- 能否抽奖
function LimPool:getCanDrawReward()
	local remainTimes = (self._activityRealCloseTime - ((os.time() + _ED.time_add_or_sub))*1000)
	if remainTimes <= 0 then
		return false
	end
	return true
end

-- 按钮红点的显示
function LimPool:updateButtonRedDot()
	if self:getCanDrawReward() then
		for i, v in ipairs(self._ButtonList) do
			local isShow = false
			if i == 1 then
				isShow = self:haveEnoughProp(1)
			elseif i == 2 then
				isShow = self:haveEnoughProp(10)
			else
				isShow = self:haveGetReward()
			end
			self:changeRedDotShowState(i, v, isShow)
		end
	else
		for i, v in ipairs(self._ButtonList) do
			self:changeRedDotShowState(i, v, false)
		end
	end
end

function LimPool:haveEnoughProp(needCount)
	local propID = self:getNeedCostPropID()
	local havePropNum = tonumber(getPropAllCountByMouldId(propID))

	return havePropNum >= needCount
end

function LimPool:haveGetReward()
	local isShow = false
	local taskInfos = self._activityData.info.taskInfos
	for _, v in pairs(taskInfos) do
		if v.getReward == 0 and v.taskStatus == 1 then
			isShow = true
			break
		end
	end
	return isShow
end

function LimPool:changeRedDotShowState(dotType, widget, isShow)
	if dotType == 1 or dotType == 2 then
		widget:setVisible(isShow)
	else
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
	end
end

function LimPool:updateBackGroundImg()
	local backGroundImgID = self._activityData.backgroundImgId
	local backGroundTitleImgID = self._activityData.backgroundTitleImgId

	self.Image_charactor:loadTexture(string.format("images/ui/text/sm_hd/lim_pool/lim_pool_head/lim_pool_head_%s.png", backGroundImgID))
	self.Image_charactor_title:loadTexture(string.format("images/ui/text/sm_hd/lim_pool/lim_pool_head/lim_pool_headtitle_%s.png", backGroundTitleImgID))
end

-- 保底进度展示
function LimPool:updateBigRewardProgress()
	local haveDraw = self._activityData.info.haveDraw
	local sureCount = self._activityData.info.sureCount2

	-- print("haveDraw = ", haveDraw, " sureCount = ", sureCount)

	if self.LoadingBar_1 then
		self.LoadingBar_1:setPercent(haveDraw / sureCount * 100)
	end

	if self.Text_draw_times then
		self.Text_draw_times:setString(haveDraw .. "/" .. sureCount)
	end

	if self.Text_special_times_1 then
		self.Text_special_times_1:setString(sureCount)
	end
end

-- 根据活动类型更换活动标题
function LimPool:updateTitleText()
	if self.Text_1 == nil or self.Text_2 == nil then
		return
	end

	self.Text_1:setVisible(self._activityType == 168)
	self.Text_2:setVisible(self._activityType == 188)
end

function LimPool:updateUI()
	self:updateTitleText()
	self:updateActivityRemainTime()
	self:updateExtractRemainTime()
	self:updateRightReward()
	self:updateLeftRankReward()
	self:updateLeftRankList()
	self:updateCostPropCount()
	self:updateRechargeCost()
	self:updateNewsList()
	self:updateButtonRedDot()
	self:updateBackGroundImg()
	self:updateMyRankInfo()
	self:updateBigRewardProgress()
end

function LimPool:onUpdateDraw()
	local root = self.roots[1]

	-- 主页积分排行列表
	self.ListView_points = ccui.Helper:seekWidgetByName(root, "ListView_points")

	-- 主页抽奖公告列表
	self.ListView_news = ccui.Helper:seekWidgetByName(root, "ListView_news")

	-- 点击列表打开抽奖公示详情
	fwin:addTouchEventListener(self.ListView_news, nil, 
	{
		terminal_name = "lim_pool_open_reward_record",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)

	-- 主页排名奖励列表
	self.ListView_rank_reward = ccui.Helper:seekWidgetByName(root, "ListView_rank_reward")

	-- 倒计时
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	-- 抽1次价格
	self.Text_zuanshi_1 = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_1")

	-- 抽10次价格
	self.Text_zuanshi_2 = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_2")

	-- 跳转充值文本
	self.Text_chance = ccui.Helper:seekWidgetByName(root, "Text_chance")

	-- 稀有奖励展示1
	self.Panel_reward_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_1")

	-- 稀有奖励展示2
	self.Panel_reward_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_2")

	-- 稀有奖励展示3
	self.Panel_reward_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_3")

	-- 稀有奖励展示4
	self.Panel_reward_icon_4 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_4")

	-- 
	self._Panel_reward_icons = {self.Panel_reward_icon_1, self.Panel_reward_icon_2, self.Panel_reward_icon_3, self.Panel_reward_icon_4}

	-- 主页立绘
	self.Image_charactor = ccui.Helper:seekWidgetByName(root, "Image_charactor")

	-- 主页立绘文字
	self.Image_charactor_title = ccui.Helper:seekWidgetByName(root, "Image_charactor_title")

	-- 抽取倒计时
	self.Text_time_0 = ccui.Helper:seekWidgetByName(root, "Text_time_0")

	-- 上榜提示
	self.Text_tips_1 = ccui.Helper:seekWidgetByName(root, "Text_tips_1")

	-- 我的积分
	self.Text_points_n = ccui.Helper:seekWidgetByName(root, "Text_points_n")

	-- 我的排行
	self.Text_ranking_n = ccui.Helper:seekWidgetByName(root, "Text_ranking_n")

	-- 保底进度
	self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

	-- 当前抽奖次数
	self.Text_draw_times = ccui.Helper:seekWidgetByName(root, "Text_draw_times")

	-- 保底大奖次数1
	self.Text_special_times_1 = ccui.Helper:seekWidgetByName(root, "Text_special_times_1")

	-- 限时奖池标题
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	-- 跨服限时奖池标题
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

	self:updateUI()
end

function LimPool:onEnterTransitionFinish()
	-- 加载LimPoolWindow界面资源.
	-- res.activity.lim_pool.lim_pool = res/activity/lim_pool/lim_pool.csb
	local csbNode = csb.createNode("activity/lim_pool/lim_pool.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 规则按钮
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "lim_pool_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 积分排行详情
	self.Button_info = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_info"), nil,
	{	
		terminal_name = "lim_pool_open_rank_list_detail",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 奖励预览
	self.Button_review = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_review"), nil,
	{
		terminal_name = "lim_pool_open_reward_preview",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转充值
	self.Button_recharge = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge"), nil,
	{
		terminal_name = "lim_pool_jump_single_recharge",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 次数获取
	self.Button_to_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_to_get"), nil,
	{
		terminal_name = "lim_pool_open_get_cost_prop_window",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 抽取1次
	self.Button_get_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_get_1"), nil,
	{
		terminal_name = "lim_pool_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		times = 1,
		m_type = 8
	}, nil, 0)	

	-- 抽取10次
	self.Button_get_10 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_get_10"), nil,
	{
		terminal_name = "lim_pool_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		times = 10,
		m_type = 8
	}, nil, 0)	

	-- 抽奖按钮红点
	self.Image_hint_1 = ccui.Helper:seekWidgetByName(root, "Image_hint_1")

	self.Image_hint_10 = ccui.Helper:seekWidgetByName(root, "Image_hint_10")

	self._ButtonList = {self.Image_hint_1, self.Image_hint_10, self.Button_to_get}

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "lim_pool_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 刷新排行榜
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_re"), nil,
	{
		terminal_name = "lim_pool_refesh_rank",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 顶部道具信息
	state_machine.excute("lim_user_top_info_open", 0, {self, self._activityType})

	self:onUpdateDraw()
end

function LimPool:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateActivityRemainTime()
		self:updateExtractRemainTime()
		self.totalTime = 0
	end
end

function LimPool:drawTime(_time)
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

function LimPool:onExit()
	-- 释放LimPoolWindow界面资源.
	state_machine.remove("lim_pool_open")
	state_machine.remove("lim_pool_close")
	state_machine.remove("lim_pool_show")
	state_machine.remove("lim_pool_hide")
	state_machine.remove("lim_pool_jump_single_recharge")
	state_machine.remove("lim_pool_get_reward")
	state_machine.remove("lim_pool_open_rank_list_detail")
	state_machine.remove("lim_pool_open_reward_preview")
	state_machine.remove("lim_pool_open_reward_record")
	state_machine.remove("lim_pool_open_get_cost_prop_window")
	state_machine.remove("lim_pool_refesh_windows")
	state_machine.remove("lim_pool_refesh_red_dot")
end

function LimPool:close()
	-- window event : close.
	
end

function LimPool:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
