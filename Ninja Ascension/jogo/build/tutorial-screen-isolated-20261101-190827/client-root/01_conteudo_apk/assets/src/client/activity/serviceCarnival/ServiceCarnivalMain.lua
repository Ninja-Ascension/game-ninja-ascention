--[[ ----------------------------------------------------------------------------
-- 排行榜活动主界面
--]] ----------------------------------------------------------------------------
ServiceCarnivalMain = class("ServiceCarnivalMainClass", Window)

-- 打开窗口
local service_carnival_main_window_open_terminal = {
	_name = "service_carnival_main_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ServiceCarnivalMainClass") then
			fwin:open(ServiceCarnivalMain:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local service_carnival_main_window_close_terminal = {
	_name = "service_carnival_main_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ServiceCarnivalMainClass"))
		state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 182)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnival_main_window_open_terminal)
state_machine.add(service_carnival_main_window_close_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalMain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	-- var
	self.Text_rank = {}			-- 排行榜页签文本
	self.Text_stars = {}		-- 成就页签文本
	self.Text_button = {}		-- 排行榜分类文本
	self.Text_num_starType = {}	-- 排行榜玩家说明
	self.Button_rankList = {}	-- 排行榜类型按钮
	self.Button_pageList = {}	-- 页签按钮
	self.Rank_time_limit = {}	-- 各榜单，1、榜单按钮	2、开启时间	   3、结束时间  
	self.Rank_sort_open_time_list = {}	-- 各榜单按照开启时间排序
	self.Rank_sort_close_time_list = {}	-- 各榜单按照结束时间排序

	self.Rank_picList = {}		-- 各页签立绘

	self.click_index = 1			-- 当前点击的排行榜类型
	self.m_type = 1				-- 当前排行榜类型：默认为战力排行榜
	self.m_page = 1				-- 当前页签：默认为排行榜页签
	self.newRankOpen = 1		-- 最新开启的排行榜
	self.getFirstRank = false	-- 是否获取到默认符合条件开启的排行榜
	self.nextOpened = -1			-- 当前应该最新开启的排行榜

	self.curProgress = 0		-- 当前展示的排行榜数量

	self.isSigned = false		-- 今天是否签到
	-- self.jumpToNewType = false	-- 是否切换排行榜类型
	
	self.deltaTime = 0.5	
    self.totalTime = 0

	self.listViewMissionPosY = nil

	-- load lua files.
	app.load("client.activity.serviceCarnival.ServiceCarnivalRule")
	app.load("client.activity.serviceCarnival.ServiceCarnivalRewardReview")
	app.load("client.activity.serviceCarnival.servicecarnivalmissionlist")
	app.load("client.activity.serviceCarnival.servicecarnivalranklist")
	app.load("client.activity.serviceCarnival.ServiceCarnivalSevenday")

	-- Initialize service carnival main page state machine.
	local function init_service_carnival_main_terminal()
		-- 打开角色创建窗口
		local service_carnival_main_open_terminal = {
			_name = "service_carnival_main_open",
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
		local service_carnival_main_close_terminal = {
			_name = "service_carnival_main_close",
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
		local service_carnival_main_show_terminal = {
			_name = "service_carnival_main_show",
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
		local service_carnival_main_hide_terminal = {
			_name = "service_carnival_main_hide",
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

		-- 刷新排行榜
		local service_carnival_main_update_ranking_terminal = {
			_name = "service_carnival_main_update_ranking",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 刷新排行榜
				if nil ~= instance then
					local type = params.curType
					local progress = params.curProgress
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								-- instance.curProgress = instance.curProgress + 10
								instance:updateNewList()
							end
						end
					end
					
					-- 获取最新的排行榜容量
					local maxRankNums = tonumber(dms.string(dms["new_server_celebration"], instance.click_index, new_server_celebration.maxNums))
					-- 如果当前排行榜上榜人员超过限制则不刷新
					if progress >= maxRankNums then
						return false
					end
					if progress + 10 >= maxRankNums then
						progress = maxRankNums
					else
						progress = progress + 10
					end
					protocol_command.celebration_order_get_order.param_list = type .. "\r\n" .. (progress)
					NetworkManager:register(protocol_command.celebration_order_get_order.code, nil, nil, nil, instance, responseCallback, false, nil)
			
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 切换排行榜类型
		local service_carnival_main_change_type_terminal = {
			_name = "service_carnival_main_change_type",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 切换排行榜类型
				if nil ~= instance then
					local click_index = params._datas.click_index
					local state = instance.Rank_time_limit[click_index].state
					if state == 1 then
						local timeString = ""
						local startTime = instance.Rank_time_limit[click_index].startTime
						local curTime =_ED.system_time + (os.time() - _ED.native_time)
						
						local retainTime = startTime - curTime
						if retainTime > 0 then
							local _dayTime = math.floor(retainTime / 86400)
							local _hourTime = math.floor(retainTime % 86400 / 3600)
							local _minuteTime = math.floor(retainTime / 60)
							if _dayTime > 0 then
								timeString = string.format(_new_interface_text[326], _dayTime, _hourTime)
							elseif _hourTime > 0 then
								_minuteTime = math.floor(_hourTime / 60)
								timeString = string.format(_new_interface_text[327], _hourTime, _minuteTime)
							elseif _minuteTime > 0 then
								timeString = string.format(_new_interface_text[328], _minuteTime)
							else
								timeString = string.format(_new_interface_text[331], retainTime)
							end
							TipDlg.drawTextDailog(timeString)
							return false
						else
							
						end
					end
					state_machine.lock("service_carnival_main_change_type")
					instance:initRankUI(click_index)
					if click_index == 4 then

						instance.Panel_sevenday_carnival:removeAllChildren(true)
						instance:updateRed()
						state_machine.excute("service_carnival_sevenday_window_open" , 0 , instance.Panel_sevenday_carnival)
					else
						local m_type = params._datas.m_type
						state_machine.excute("service_carnival_main_change_page", 0, {_datas = {click_index = click_index, m_page = 1, m_type = m_type}})
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 切换排行榜页签
		local service_carnival_main_change_page_terminal = {
			_name = "service_carnival_main_change_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 切换排行榜页签
				if nil ~= instance then
					local curIndex = params._datas.m_page
					local curType = params._datas.m_type
					local click_index = params._datas.click_index
					if click_index == nil then
						click_index = instance.click_index
					end
					if curType == nil then
						curType = instance.m_type
					end
					if curIndex == 1 then
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
									state_machine.unlock("service_carnival_main_change_type")
									instance.Panel_rcrw:setVisible(true)
									instance.curProgress = 10	
									-- instance.jumpToNewType = true
									local params = {curType, curIndex, click_index}
									instance:updatePage(params)
								end
							end
							
							state_machine.unlock("service_carnival_main_change_type")
						end
						protocol_command.celebration_order_get_order.param_list = curType .. "\r\n" .. 10
                   	 	NetworkManager:register(protocol_command.celebration_order_get_order.code, nil, nil, nil, instance, responseCallback, false, nil)
                
					elseif curIndex == 2 then
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
									state_machine.unlock("service_carnival_main_change_type")
									-- instance.jumpToNewType = true
									local params = {curType, curIndex, click_index}
									instance:updatePage(params)
								end
							end
							state_machine.unlock("service_carnival_main_change_type")
						end
						protocol_command.celebration_order_get_achieve.param_list = curType
                   	 	NetworkManager:register(protocol_command.celebration_order_get_achieve.code, nil, nil, nil, instance, responseCallback, false, nil)
						
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击领取每日奖励
		local service_carnival_main_sign_in_terminal = {
			_name = "service_carnival_main_sign_in",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 点击领取每日奖励
				if nil ~= instance then
					if instance.isSigned ~= true then
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
									instance.isSigned = true
									app.load("client.reward.DrawRareReward")
									local getRewardWnd = DrawRareReward:new()
									getRewardWnd:init(7)
									fwin:open(getRewardWnd, fwin._ui)
									_ED.active_activity[182].activity_data.dailyRewardState = 1
									instance:updateState()
									
								end
							end
						end
                   	 	NetworkManager:register(protocol_command.celebration_order_get_day_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击查看排行榜奖励内容
		local service_carnival_main_show_reward_terminal = {
			_name = "service_carnival_main_show_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 点击查看排行榜奖励内容
				if nil ~= instance then
					state_machine.excute("service_carnival_reward_review_window_open" , nil , {type = instance.m_type, clickIndx = instance.click_index})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 领取成就任务奖励后的刷新
		local service_carnival_main_update_achieve_terminal = {
			_name = "service_carnival_main_update_achieve",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				if nil ~= instance then
					instance:updatePage()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(service_carnival_main_open_terminal)
		state_machine.add(service_carnival_main_close_terminal)
		state_machine.add(service_carnival_main_show_terminal)
		state_machine.add(service_carnival_main_hide_terminal)
		state_machine.add(service_carnival_main_change_type_terminal)
		state_machine.add(service_carnival_main_change_page_terminal)
		state_machine.add(service_carnival_main_sign_in_terminal)
		state_machine.add(service_carnival_main_show_reward_terminal)
		state_machine.add(service_carnival_main_update_ranking_terminal)
		state_machine.add(service_carnival_main_update_achieve_terminal)
		
		state_machine.init()
	end
	-- call func init service carnival main state machine.
	init_service_carnival_main_terminal()
end

-- 绘制页签内容
function ServiceCarnivalMain:updatePage(params)
	-- if self.click_index ~= click_index then
	-- 	self.jumpToNewType = true
	-- else
	-- 	self.jumpToNewType = false
	-- end
	if params ~= nil then
		self.m_type = params[1]
		self.m_page = params[2]
		self.click_index = params[3]
	end
	self:initDrawUI()
	self:initDrawListView()
	self:updateRed()
end

-- 更新每日奖励状态
function ServiceCarnivalMain:updateState()
	
	if self.isSigned then
		self.Button_dailyReward:setVisible(false)
	else 
		self.Button_dailyReward:setVisible(true)
	end

	self:updateRed()
end

-- 根据类型索引行的内容
function ServiceCarnivalMain:getTypeInfo(type)
	local typeArray = dms.searchs(dms["new_server_celebration"], new_server_celebration.type, type)

	return typeArray[1]
end

-- 绘制排行榜奖励
function ServiceCarnivalMain:getRankReward(ranking)
	local curRewardString = nil
	local curRewardInfos = nil
	if ranking == -1 then
		local rewardString = dms.string(dms["activity_config"] , 98 , activity_config.param)
		local rewardInfos = zstring.split(rewardString , "@")
		curRewardInfos = rewardInfos[self.m_type]
	else
		local typeArray = self:getTypeInfo(self.m_type)
		local rewardString = typeArray[new_server_celebration.reward]
		local rewardInfos = zstring.splits(rewardString , "@" , ":")
		for i, v in ipairs(rewardInfos) do
			local rankRandom = zstring.split(v[1] , "-")
			if ranking >= tonumber(rankRandom[1]) and ranking <= tonumber(rankRandom[2]) then
				curRewardString = v[2]
				break
			end
		end
		
		curRewardInfos = zstring.split(curRewardString , "|")
	end

	return curRewardInfos
end


-- 下拉排行榜后刷新之前的数据并添加新的内容
function ServiceCarnivalMain:updateNewList()
	local activity_data = _ED.active_activity[182].activity_data
	local rankInfo = activity_data.typeRankInfo
	local userPowers = activity_data.userPowers
	local userRanking = activity_data.curRanking
	local tempNums = 0
	for i, v in ipairs(self.ListView_rcrw:getItems()) do
		if rankInfo[i] ~= nil and rankInfo[i].ranking ~= nil then
			v:updateUserInfo({playerInfo = rankInfo[i]})
			tempNums = tempNums + 1
		end
	end
	for i = tempNums + 1, #rankInfo do
		if rankInfo[i] ~= nil and rankInfo[i].ranking ~= nil then
			local rewardInfo = self:getRankReward(rankInfo[i].ranking)
			local cell = state_machine.excute("service_carnival_rank_list_create", nil, {mType = self.m_type, playerInfo = rankInfo[i], index = i, reward = rewardInfo})
			self.ListView_rcrw:addChild(cell)
		end
	end
	self.ListView_rcrw:requestRefreshView()
	self.curProgress = #rankInfo
	self.listViewRankPosY = self.ListView_rcrw:getInnerContainer():getPositionY()
end

-- 对当前界面元素进行绘制
function ServiceCarnivalMain:initDrawListView()
	local activity_data = _ED.active_activity[182].activity_data
	if activity_data == nil then
		return
	end
	local rankInfo = activity_data.typeRankInfo
	local userPowers = activity_data.userPowers
	local userRanking = activity_data.curRanking
	self.ListView_rcrw:removeAllItems()
	self.ListView_zhandouli:removeAllItems()
	if self.m_page == 1 then
		
		local function sortFunction(a, b)
			if a.ranking ~= nil and b.ranking ~= nil then
				if a.ranking < b.ranking then
					return true
				end
				
			end
			return false
		end
		table.sort(rankInfo, sortFunction)
		self.Panel_checkpoint_rank:setVisible(true)
		self.Panel_cr_rank:setVisible(false)
		self.Text_num_guanqia_star:setString(userPowers.."")
		self.Text_player_name:setString(_ED.user_info.user_name)
		self.ListView_rewards:removeAllItems()
		self.ListView_rewards:setVisible(true)

		local curRanking = _ED.active_activity[182].activity_data.curRanking
		local selfRewardInfo = self:getRankReward(curRanking)

		if curRanking == -1 then
			local cells = DrawHandle.drawIcons(selfRewardInfo)
			for i, v in ipairs(cells) do
				self.ListView_rewards:addChild(v)
			end
		else
			for i, v in ipairs(selfRewardInfo) do
				
				local cell = DrawHandle.drawIcon(v)
				self.ListView_rewards:addChild(cell)
			end
		end
		self.ListView_rewards:jumpToLeft()
		self.ListView_rewards:requestRefreshView()
		local inRankList = false
		for i = 1, #rankInfo do
			if rankInfo[i] ~= nil and rankInfo[i].ranking ~= nil then
				local rewardInfo = self:getRankReward(rankInfo[i].ranking)
				local cell = state_machine.excute("service_carnival_rank_list_create", nil, {mType = self.m_type, playerInfo = rankInfo[i], index = i, reward = rewardInfo})
				self.ListView_rcrw:addChild(cell)
			end
		end
		self.curProgress = #rankInfo
		if userRanking == -1 then
			self.Text_player_st:setString(_new_interface_text[329])
		else
			self.Text_player_st:setString(userRanking.."")
		end
		
		-- if self.jumpToNewType == true then
		self.ListView_rcrw:jumpToTop()
			-- self.jumpToNewType = false
		-- end
		self.ListView_rcrw:requestRefreshView()
		self.listViewRankPosY = self.ListView_rcrw:getInnerContainer():getPositionY()
		local function listViewRankListener(sender, eventType)
			if eventType == ccui.ScrollviewEventType.bounceBottom then	--滚动视图滚动到下边界并且开始回弹时发出的事件
				state_machine.excute("service_carnival_main_update_ranking", nil, {curType= self.m_type, curProgress= self.curProgress})
			end
			
		end
		self.ListView_rcrw:addScrollViewEventListener(listViewRankListener)
	elseif self.m_page == 2 then
		self.Panel_checkpoint_rank:setVisible(false)
		self.Panel_cr_rank:setVisible(true)
		
		local taskInfo = nil
		
		taskInfo = activity_data.achieveResult
		taskInfo = self:sortListItems(taskInfo)
		
		for i, v in ipairs(taskInfo) do
			local info = dms.atos(dms["achieve"], tonumber(v[1]))
			local cell = state_machine.excute("service_carnivalmission_list_create", nil, {missionInfo = info, index = i, mType = self.m_type, openState = self.Rank_time_limit[self.click_index].state, endTime = self.Rank_time_limit[self.click_index].endTime})
			self.ListView_zhandouli:addChild(cell)
			
		end

		self.ListView_zhandouli:jumpToTop()
		self.ListView_zhandouli:requestRefreshView()
		self.listViewMissionPosY = self.ListView_zhandouli:getInnerContainer():getPositionY()

	end
end

-- 对成就榜任务按照任务状态进行排序
function ServiceCarnivalMain:sortListItems(items)
    local result = {}
    local closeItems = {}       -- 已完成
    local drawItems = {}            -- 可领取
    local uncompItems = {}      -- 未完成
	local userInfo = 0

	local missionArray = self:getTypeInfo(self.m_type)
	local missionstring = missionArray[new_server_celebration.achieveTasks]
	local missionInfos = zstring.split(missionstring, ",")

	local activity_data = _ED.active_activity[182].activity_data

	local function sortFunction(a, b)
		if a[1] ~= nil and b[1] ~= nil then
			if tonumber(a[1]) < tonumber(b[1]) then
				return true
			end
		end
		return false
	end
	table.sort(items, sortFunction)
    for k, v in pairs(items) do
	
		local info = dms.atos(dms["achieve"], tonumber(missionInfos[k]))
		local needText = info[achieve.param2]
		local state = tonumber(v[2])
		
        if state == 0 then
            table.insert(uncompItems, v)
        elseif state == 1 then
            table.insert(drawItems, v)
        else
            table.insert(closeItems, v)
        end
    end
	
	table.sort(uncompItems, sortFunction)
	table.sort(drawItems, sortFunction)
	table.sort(closeItems, sortFunction)

    for k, v in pairs(drawItems) do
        table.insert(result, v)
    end
    for k, v in pairs(uncompItems) do
        table.insert(result, v)
    end
    for k, v in pairs(closeItems) do
        table.insert(result, v)
    end

    return result
end


-- ListView实现动态缓存
function ServiceCarnivalMain:updateListView(listView)
	if listView ~= nil then
		local size = listView:getContentSize()
		local posY = listView:getInnerContainer():getPositionY()
		if self.m_page == 1 then
			if self.listViewRankPosY== posY then
				return
			end
			self.listViewRankPosY = posY
		elseif self.m_page == 2 then
			if self.listViewMissionPosY == posY then
				return
			end
			self.listViewMissionPosY = posY
		end
		local items = listView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height/ 2 + itemSize.height < 0 or tempY > size.height + itemSize.height/ 2 then
				v:unload()
			else
				v:reload()
			end
		end

	end
end

-- 绘制倒计时
function ServiceCarnivalMain:updateDrawActivityTime()
	local root = self.roots[1]
    if root == nil then
        return
    end
	
	local times = _ED.system_time + (os.time() - _ED.native_time)
	local surplus_time = tonumber(self.Rank_time_limit[self.click_index].endTime) - times
	self.Text_num_timeCount:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time))
	
end

function ServiceCarnivalMain:onUpdate(dt)

	if self.m_page == 1 and self.ListView_rcrw ~= nil then
		self:updateListView(self.ListView_rcrw)
	elseif self.m_page == 2 and self.ListView_zhandouli ~= nil then
		self:updateListView(self.ListView_zhandouli)
	end
	-- 监测排行榜是否开启
	if #self.Button_rankList == 4 and self.nextOpened ~= 4 and self.nextOpened ~= -1 then
		self:changeRankState(self.nextOpened)
	end
	-- 监测七日狂欢是否开启
	if self.Button_rankList[4] ~= nil and self.Rank_time_limit[4].state == 1 then
		self:changeRankState(4)
	end
	
	self:updateDrawActivityTime()
	
end

function ServiceCarnivalMain:initRankUI(type)
	
	for i, v in ipairs(self.Button_rankList) do
		if i == type then
			v:setHighlighted(true)
			v:setTouchEnabled(false)
		else
			v:setHighlighted(false)
			v:setTouchEnabled(true)
		end
	end
	if type == 4 then
		self.Panel_sevenday_carnival:setVisible(true)
		self.Panel_rcrw:setVisible(false)
		self.Button_rule:setVisible(false)
	else
		self.Panel_rcrw:setVisible(true)
		self.Button_rule:setVisible(true)
		self.Panel_sevenday_carnival:setVisible(false)
	end
end

function ServiceCarnivalMain:initDrawUI()
	local root = self.roots[1]
	self:updateDrawActivityTime()
	if self.isSigned then
		self.Button_dailyReward:setVisible(false)
	else
		self.Button_dailyReward:setVisible(true)
	end
	for i, v in ipairs(self.Text_button) do
		local curType = dms.int(dms["new_server_celebration"], i, new_server_celebration.type)
		local typeName = ""
		if curType == 1 then
			typeName = tipStringInfo_service_sevenday_type_name[1]
		elseif curType == 2 then
			typeName = tipStringInfo_service_sevenday_type_name[2]
		elseif curType == 3 then
			typeName = tipStringInfo_service_sevenday_type_name[3]
		end
		v:setString(typeName)
	end

	for i, v in ipairs(self.Button_pageList) do
		self.Button_pageList[i]:setHighlighted(false)
		self.Button_pageList[i]:setTouchEnabled(true)
		local lightButton = nil 
		if i == 1 then
			lightButton = ccui.Helper:seekWidgetByName(root, "Image_lightButton_rank")
		else
			lightButton = ccui.Helper:seekWidgetByName(root, "Image_lightButton_rankCount")
		end
		lightButton:setVisible(false)
	end
	self.Button_rule:setVisible(true)
	for i, v in ipairs(self.Button_rankList) do
		local lockImage = ccui.Helper:seekWidgetByName(root , "Image_lock_"..i)
		if self.Rank_time_limit[i].state ~= 1 then
			-- self.Button_rankList[i]:setTouchEnabled(true)
			lockImage:setVisible(false)
		else
			-- self.Button_rankList[i]:setTouchEnabled(false)
			lockImage:setVisible(true)
		end
		self.Button_rankList[i]:setHighlighted(false)
	end
	
	for i = 1, 3 do
		self.Text_num_starType[i]:setVisible(false)
		self.Text_rank[i]:setVisible(false)
		self.Text_stars[i]:setVisible(false)
	end

	self.Button_rankList[self.click_index]:setTouchEnabled(false)
	self.Button_rankList[self.click_index]:setHighlighted(true)
	self.Button_pageList[self.m_page]:setTouchEnabled(false)
	self.Button_pageList[self.m_page]:setHighlighted(true)
	local lightButton = nil
	if self.m_page == 1 then
		lightButton = ccui.Helper:seekWidgetByName(root, "Image_lightButton_rank")
	else
		lightButton = ccui.Helper:seekWidgetByName(root, "Image_lightButton_rankCount")
	end
	lightButton:setVisible(true)

	if self.click_index <= 3 then
		self.Text_num_starType[self.m_type]:setVisible(true)
		self.Text_rank[self.m_type]:setVisible(true)
		self.Text_stars[self.m_type]:setVisible(true)
	end
	-- 立绘的绘制
	if self.click_index < 4 then
		self.Panel_role:setVisible(true)
		self.Panel_role:setBackGroundImage(self.Rank_picList[self.click_index])
	else
		self.Panel_role:setVisible(false)
	end
end


-- 刷新各排行榜是否开启的状态
function ServiceCarnivalMain:updateRankLock(curPos)
	local root = self.roots[1]
	for i, v in ipairs(self.Button_rankList) do
		local lockImage = ccui.Helper:seekWidgetByName(root , "Image_lock_"..i)
		if self.Rank_time_limit[i].state == 1 then
			-- self.Button_rankList[i]:setTouchEnabled(false)
			
			lockImage:setVisible(true)
			
		elseif self.Rank_time_limit[i].state == 2 or self.Rank_time_limit[i].state == 3 then
			self.Button_rankList[i]:setTouchEnabled(true)
			lockImage:setVisible(false)
		end
	end
	self:updateRed()
	if curPos ~= 4 then
		self.nextOpened = self.nextOpened + 1
	end
	
end

-- 判断该时刻是否改变排行榜状态  是否锁住
function ServiceCarnivalMain:changeRankState(curPos)
	local isChanged = false
	local times = _ED.system_time + (os.time() - _ED.native_time)
	local curIdx = 0
	if curPos ~= 4 then
		-- 只需判断最近一个未解锁的排行榜
		curIdx = self.Rank_sort_open_time_list[self.nextOpened].click_index
		local curState = self.Rank_time_limit[curIdx].state 
		if times > self.Rank_time_limit[curIdx].startTime and times < self.Rank_time_limit[curIdx].endTime then
			self.Rank_time_limit[curIdx].state = 2
			self.Rank_sort_open_time_list[self.nextOpened].state = 2
		end
		if curState ~= self.Rank_time_limit[curIdx].state then
			isChanged = true
		end
	else
		local curState = self.Rank_time_limit[4].state 
		if times > self.Rank_time_limit[4].startTime and times < self.Rank_time_limit[4].endTime then
			self.Rank_time_limit[4].state = 2
			self.Rank_sort_open_time_list[self.nextOpened].state = 2
		end
		if curState ~= self.Rank_time_limit[4].state then
			curIdx = 4
			isChanged = true
		end
	end

	if isChanged == true then
		self:updateRankLock(curIdx)
	end
end

-- 初始化各排行榜的时间、解锁状态，获取开启时间先后顺序的排名
function ServiceCarnivalMain:getRankOpenStateInit()
	
	local activity = _ED.active_activity[182]
	local beginTime = activity.begin_time / 1000
	local curTime = _ED.system_time + (os.time() - _ED.native_time)
	local completeNum = 0
	local getFirstType = false			-- 标致最近的开启的榜单

	for i = 1 , #self.Button_rankList do
		self.Rank_time_limit[i] = {}
		local rankBeginTime = 0
		if i < 4 then
			self.Rank_sort_open_time_list[i] = {}
			rankBeginTime = tonumber(dms.string(dms["new_server_celebration"] , i , new_server_celebration.openTime))
			self.Rank_time_limit[i].startTime = beginTime + rankBeginTime
			self.Rank_time_limit[i].endTime = self.Rank_time_limit[i].startTime + tonumber(dms.string(dms["new_server_celebration"] , i , new_server_celebration.endTime))
			
			self.Rank_sort_open_time_list[i].startTime = self.Rank_time_limit[i].startTime
			self.Rank_sort_open_time_list[i].click_index = i
			-- self.Rank_sort_close_time_list[i] = {}
			self.Rank_sort_open_time_list[i].endTime = self.Rank_time_limit[i].endTime
			-- self.Rank_sort_close_time_list[i].curRank = i
		else
			self.Rank_time_limit[i].startTime = _ED.active_activity[183].begin_time / 1000
			self.Rank_time_limit[i].endTime = _ED.active_activity[183].end_time / 1000
			
			-- self.Rank_sort_close_time_list[i] = {}
			-- self.Rank_sort_close_time_list[i].endTime = self.Rank_time_limit[i].endTime
			-- self.Rank_sort_close_time_list[i].curRank = i
		end
		-- print(curTime,"=======curTime",self.Rank_time_limit[i].startTime, "=====self.Rank_time_limit[i].startTime", self.Rank_time_limit[i].endTime)
		
		if curTime > self.Rank_time_limit[i].startTime and curTime < self.Rank_time_limit[i].endTime then
			if self.getFirstRank == false then
				if i == 4 then
					self.click_index = i
				else
					self.m_type = activity.activity_data.rankType
					local indexInfo = dms.searchs(dms["new_server_celebration"], new_server_celebration.type, self.m_type)
					self.click_index = tonumber(indexInfo[1][new_server_celebration.id])
				end
				self.getFirstRank = true
			end
			
			self.Rank_time_limit[i].state = 2		-- 2代表开启
		elseif curTime < self.Rank_time_limit[i].startTime then
			self.Rank_time_limit[i].state = 1		-- 1代表不可开启
		else
			self.Rank_time_limit[i].state = 3		-- 3代表排行榜可查看但是不可以操作
		end
	end

	for i = 1 , 3 do
		self.Rank_sort_open_time_list[i].state = self.Rank_time_limit[i].state
	end
	
	
	-- 将时间进行先后排名	留着备用
	local function sortFunction(a, b)
		if tonumber(a.startTime) < (b.startTime) then
			return true
		end
		return false
	end
	table.sort(self.Rank_sort_open_time_list, sortFunction) 
	for i, v in ipairs(self.Rank_sort_open_time_list) do
		if v.state == 1 then
			self.nextOpened = i
			break
		end
	end

	-- 将排名顺序赋值到各排名控件上
	-- for i = 1, #self.Rank_sort_open_time_list do
	-- 	local curRank = self.Rank_sort_open_time_list[i].curRank
	-- 	self.Rank_time_limit[curRank].order = i
	-- end
end

function ServiceCarnivalMain:updateRed()
	fwin:addService({
		callback = function ( params )
			state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_sign_in_push")
			state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_page_push")
			state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_index_push")
			state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 182)
		end,
		delay = 0,
	})
end

function ServiceCarnivalMain:drawRed()
	local root = self.roots[1]
    state_machine.excute(
        "push_notification_center_manager",
        0,
        {
            _terminal_name = "push_notification_service_carnival_sign_in_push",
            _widget = self.Button_dailyReward,
            _invoke = nil,
        }
    )

	

	for i = 1, 4 do
		local redRoot = ccui.Helper:seekWidgetByName(root, "Image_red_"..i)
		local type = i
		if i <= 3 then
			type = dms.int(dms["new_server_celebration"], i, new_server_celebration.type)
		end
		redRoot:setVisible(false)
		if self.Rank_time_limit[i].state ~= 1 then
			state_machine.excute(
				"push_notification_center_manager",
				0,
				{
					_terminal_name = "push_notification_service_carnival_page_push",
					_widget = redRoot,
					_invoke = nil,
					_pageType = type,
					_isFixed = true,		-- 代表该类型是否随着当前排行榜类型的变化而变化
				}
			)
			
		end
		
	end

	state_machine.excute(
		"push_notification_center_manager",
		0,
		{
			_terminal_name = "push_notification_service_carnival_index_push",
			_widget = self.Button_pageList[2],
			_invoke = nil,
			_pageType = self.m_type,
			_isFixed = false,
		}
	)
	

end

function ServiceCarnivalMain:getCurType()
	return self.m_type
end

function ServiceCarnivalMain:initDrawType(type)
	if type ~= nil then
		self.click_index = type
	end
	self:initRankUI(self.click_index)
	if self.click_index == 4 then

		self.Panel_sevenday_carnival:removeAllChildren(true)
		state_machine.excute("service_carnival_sevenday_window_open" , 0 , self.Panel_sevenday_carnival)
	else
		local click_index = self.click_index
		
		self:initDrawUI()
		self:initDrawListView()
		-- state_machine.excute("service_carnival_main_change_page", 0, {_datas = {click_index = click_index, m_page = 1}})
	end
end

-- 对象初始化
function ServiceCarnivalMain:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ServiceCarnivalMain:onUpdateDraw()
	local root = self.roots[1]

	self.Text_num_starType = {}
	self.Text_rank = {}
	self.Text_stars = {}
	self.Rank_picList = {}
	-- 角色立绘
	self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")

	-- 角色立绘文案
	self.Text_role_info = ccui.Helper:seekWidgetByName(root, "Text_role_info")

	-- 排行榜页面
	self.Panel_rcrw = ccui.Helper:seekWidgetByName(root, "Panel_rcrw")

	-- 七日狂欢分页
	self.Panel_sevenday_carnival = ccui.Helper:seekWidgetByName(root, "Panel_sevenday_carnival")

	-- 排行榜分页
	self.Panel_rcrw = ccui.Helper:seekWidgetByName(root, "Panel_rcrw")

	-- 关卡星级分页
	self.Panel_checkpoint_rank = ccui.Helper:seekWidgetByName(root, "Panel_checkpoint_rank")

	for i = 1 , 3 do
		-- 1、玩家标题关卡星级	2、玩家标题战斗力		3、玩家标题数码兽星级
		
		local Text_rank = ccui.Helper:seekWidgetByName(root, "Text_rank_"..i)
		table.insert(self.Text_rank, Text_rank)

		local Text_num_starType = ccui.Helper:seekWidgetByName(root, "Text_num_starType_"..i)
		table.insert(self.Text_num_starType, Text_num_starType)

		local Text_stars = ccui.Helper:seekWidgetByName(root, "Text_stars_"..i)
		table.insert(self.Text_stars, Text_stars)
	end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	table.insert(self.Text_button, self.Text_1)
	self.Text_cr = ccui.Helper:seekWidgetByName(root, "Text_cr")
	table.insert(self.Text_button, self.Text_cr)
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	table.insert(self.Text_button, self.Text_1_0)

	-- 闯关星级数量
	self.Text_num_guanqia_star = ccui.Helper:seekWidgetByName(root, "Text_num_guanqia_star")

	-- 玩家名字
	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")

	-- 玩家排名
	self.Text_player_st = ccui.Helper:seekWidgetByName(root, "Text_player_st")

	-- 玩家所获得獎勵
	self.ListView_rewards = ccui.Helper:seekWidgetByName(root, "ListView_rewards")

	-- 排行榜列表容器
	self.ListView_rcrw = ccui.Helper:seekWidgetByName(root, "ListView_rcrw")

	-- 排行榜倒计时
	self.Text_num_timeCount = ccui.Helper:seekWidgetByName(root, "Text_num_timeCount")
	-- 战力排行
	self.Panel_cr_rank = ccui.Helper:seekWidgetByName(root, "Panel_cr_rank")

	-- 战力排行榜列表容器
	self.ListView_zhandouli = ccui.Helper:seekWidgetByName(root, "ListView_zhandouli")

	-- 立绘图片的获取，各个页面的立绘读取同一张图片
	for i = 1, 3 do
		-- local fileName = "images/ui/text/sm_hd/service_carnival/service_carnival_role_00"..i..".png"
		local fileName = "images/ui/text/sm_hd/service_carnival/service_carnival_role_001.png"
        if true == cc.FileUtils:getInstance():isFileExist(fileName) then
			self.Rank_picList[i] = fileName
        end     
	end
	local dailyState = _ED.active_activity[182].activity_data.dailyRewardState
	if dailyState == 0 then
		self.isSigned = false
	else
		self.isSigned = true
	end

	self:getRankOpenStateInit()
	self:updateState()
	self:initDrawUI()
	self:drawRed()
	self:initDrawType()
end

function ServiceCarnivalMain:onEnterTransitionFinish()
	-- debug.print_r(_ED.active_activity[182], '====182')
	-- 加载ServiceCarnivalMainWindow界面资源.
	-- res.activity.service_carnival.service_carnival_main = res/activity/service_carnival/service_carnival_main.csb
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_main.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	-- 排行榜按钮
	self.Button_rank = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank"), nil,
	{
		terminal_name = "service_carnival_main_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_page = 1,
	}, nil, 0)	
	table.insert(self.Button_pageList, self.Button_rank)

	-- 成就分页按钮
	self.Button_starCount = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_starCount"), nil,
	{
		terminal_name = "service_carnival_main_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		m_page = 2,
	}, nil, 0)	
	table.insert(self.Button_pageList, self.Button_starCount)

	-- 排行獎勵预览按钮
	self.Button_lineReward = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lineReward"), nil,
	{
		terminal_name = "service_carnival_main_show_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
 
	-- 每日獎勵按钮
	self.Button_dailyReward = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dailyReward"), nil,
	{
		terminal_name = "service_carnival_main_sign_in",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 规则按钮
	self.Button_rule = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil,
	{
		terminal_name = "service_carnival_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	local index1 = dms.int(dms["new_server_celebration"], 1, new_server_celebration.type)
	-- 闯关星级分页按钮
	self.Button_tab_guanqia_star = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_guanqia_star"), nil,
	{
		terminal_name = "service_carnival_main_change_type",
		terminal_state = 0,
		isPressedActionEnabled = true,
		click_index = 1,
		m_type = index1,
	}, nil, 0)	
	table.insert(self.Button_rankList, self.Button_tab_guanqia_star)

	local index2 = dms.int(dms["new_server_celebration"], 2, new_server_celebration.type)
	-- 战力排行分页按钮
	self.Button_tab_zhanli = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_zhanli"), nil,
	{
		terminal_name = "service_carnival_main_change_type",
		terminal_state = 0,
		isPressedActionEnabled = true,
		click_index = 2,
		m_type = index2,
	}, nil, 0)	
	table.insert(self.Button_rankList, self.Button_tab_zhanli)

	local index3 = dms.int(dms["new_server_celebration"], 3, new_server_celebration.type)
	-- 星级排行榜分页按钮
	self.Button_tab_star = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_star"), nil,
	{
		terminal_name = "service_carnival_main_change_type",
		terminal_state = 0,
		isPressedActionEnabled = true,
		click_index = 3,
		m_type = index3,
	}, nil, 0)	
	table.insert(self.Button_rankList, self.Button_tab_star)

	-- 七日狂欢分页按钮
	self.Button_tab_sevenday = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_sevenday"), nil,
	{
		terminal_name = "service_carnival_main_change_type",
		terminal_state = 0,
		isPressedActionEnabled = true,
		click_index = 4,
		m_type = 4,
	}, nil, 0)	
	table.insert(self.Button_rankList, self.Button_tab_sevenday)

	-- 关闭
	self.Button_main_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_main_close"), nil,
	{
		terminal_name = "service_carnival_main_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ServiceCarnivalMain:onExit()
	-- 释放ServiceCarnivalMainWindow界面资源.
	state_machine.remove("service_carnival_main_open")
	state_machine.remove("service_carnival_main_close")
	state_machine.remove("service_carnival_main_show")
	state_machine.remove("service_carnival_main_hide")
	state_machine.remove("service_carnival_main_change_type")
	state_machine.remove("service_carnival_main_change_page")
	state_machine.remove("service_carnival_main_sign_in")
	state_machine.remove("service_carnival_main_show_reward")
	state_machine.remove("service_carnival_main_update_ranking")
	state_machine.remove("service_carnival_main_update_achieve")
	
end

function ServiceCarnivalMain:close()
	-- window event : close.
	
end

function ServiceCarnivalMain:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
