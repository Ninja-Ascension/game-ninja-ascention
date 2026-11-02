--[[ ----------------------------------------------------------------------------
-- 荣誉榜主展示界面
--]] ----------------------------------------------------------------------------
CommandWorldGlory = class("CommandWorldGloryClass", Window)

-- 打开窗口
local command_world_glory_window_open_terminal = {
	_name = "command_world_glory_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CommandWorldGloryClass") then
			fwin:open(CommandWorldGlory:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_glory_window_close_terminal = {
	_name = "command_world_glory_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldGloryClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_glory_window_open_terminal)
state_machine.add(command_world_glory_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorldGlory:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 当前处于什么状态 1本服排行榜 2跨服排行榜 3展示奖励
	self._activityState = 1

	self.deltaTime = 1
	self.totalTime = 0

	-- 1 本服荣耀榜  2 跨服荣耀榜
	self.page_index = 1

	-- 1 荣耀榜数据
	self.gloryInfo = nil

	-- load lua files.

	-- Initialize command world glory page state machine.
	local function init_command_world_glory_terminal()
		-- 打开角色创建窗口
		local command_world_glory_open_terminal = {
			_name = "command_world_glory_open",
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
		local command_world_glory_close_terminal = {
			_name = "command_world_glory_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_glory_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_glory_show_terminal = {
			_name = "command_world_glory_show",
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
		local command_world_glory_hide_terminal = {
			_name = "command_world_glory_hide",
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

		-- 刷新界面
		local command_world_glory_refesh_terminal = {
			_name = "command_world_glory_refesh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 领奖
		local command_world_glory_get_reward_terminal = {
			_name = "command_world_glory_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local index = params._datas.index

				local data = params._datas.data
				-- 荣耀榜领奖 类型2
				local taskType = 2
				local data = self.gloryInfo[index]

				if data == nil then
					return
				end

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(7)
						fwin:open(getRewardWnd, fwin._ui)

						-- 刷新红点
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 174)
						-- 刷新右侧按钮红点
						state_machine.excute("command_word_update_right_red_dot", 0, nil)
						-- 刷新道具的数量
						state_machine.excute("command_world_refresh_top_prop_num", 0, nil)
						-- 领取完刷新界面
						state_machine.excute("command_world_glory_refesh", 0, nil)

						self:updateAll()
					end
				end
				protocol_command.activity_orders_world_get_reward.param_list = "" .. taskType .. "\r\n" .. data.index .. "\r\n" .. self.page_index-1
				NetworkManager:register(protocol_command.activity_orders_world_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 本服荣誉榜页签按钮事件
		local command_world_button_zuzhi_click_terminal = {
			_name = "command_world_button_zuzhi_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				self.page_index = 1
                self:changeButtonViewState(params._datas._button)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 跨服荣誉榜页签按钮事件
		local command_world_button_fwq_click_terminal = {
			_name = "command_world_button_fwq_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				self.page_index = 2
                self:changeButtonViewState(params._datas._button)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(command_world_glory_open_terminal)
		state_machine.add(command_world_glory_close_terminal)
		state_machine.add(command_world_glory_show_terminal)
		state_machine.add(command_world_glory_hide_terminal)
		state_machine.add(command_world_glory_refesh_terminal)
		state_machine.add(command_world_glory_get_reward_terminal)
		state_machine.add(command_world_button_zuzhi_click_terminal)
		state_machine.add(command_world_button_fwq_click_terminal)
		state_machine.init()
	end
	-- call func init command world glory state machine.
	init_command_world_glory_terminal()
end

-- 对象初始化
function CommandWorldGlory:init(params)
	self._activityEndTime = CommandWorldHandle.getCommandWorldActivityEndTime()
	self._crossServerEndTime = CommandWorldHandle.getCommandWorldCrossServerEndTime()

	local surplus_time_2 = (self._crossServerEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	local surplus_time_3 = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)

	if surplus_time_2 > 0 then
		self._activityState = 2
	else
		self._activityState = 3
	end
	self._tempActivityState = self._activityState

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CommandWorldGlory:updateUI()
	self:updateActivityState()
	self:updateTopUI()

	for i = 1, 3 do
		self.Panel_player[i]:setVisible(false)
		self.Image_no[i]:setVisible(false)
		self.Image_klq[i]:setVisible(false)
		self.Image_klq[i]:stopAllActions()

		local info = self.gloryInfo[i]
		if info then
			self.Panel_player[i]:setVisible(true)
			self.Text_Rank[i]:setString(info.rankNumber)
			self.Text_Name[i]:setString(info.nickName)
			self.Text_point[i]:setString(info.score)
				
			self.Panel_character[i]:removeAllChildren(true)
			self:addHeroAnimation(self.Panel_character[i], tonumber(info.shipMould))

			self.Image_no[i]:setVisible(true)

			local canReward = tonumber(info.status) == 1
			self.Image_klq[i]:setVisible(canReward)

			if canReward then
				local seq = cc.Sequence:create(cc.DelayTime:create(0.3), cc.FadeOut:create(0.6), cc.DelayTime:create(0), cc.FadeIn:create(0.8), NULL)
				self.Image_klq[i]:runAction(cc.RepeatForever:create(seq))
			end

			self.Panel_character[i]:setTouchEnabled(canReward)
		end
	end
end

-- 获得玩家模型
function CommandWorldGlory:addHeroAnimation(widget, shipMouldId)
    local temp_bust_index = nil
     --进化形象
    local evo_image = dms.string(dms["ship_mould"], shipMouldId, ship_mould.fitSkillTwo)
    
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = evo_info[dms.int(dms["ship_mould"], shipMouldId, ship_mould.captain_name)]

    --新的形象编号
    temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

    local hero_animation = sp.spine_sprite(widget, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	hero_animation:setScale(1.3)
	hero_animation.animationNameList = spineAnimations
	sp.initArmature(hero_animation, true)
end

-- 刷新道具数量
function CommandWorldGlory:updateTopUI()
	local costPropDatas = zstring.splits(dms.string(dms["activity_config"], 76, activity_config.param), "|", ",")

	local Text_Donate_Prop_Num = self.Text_Donate_Prop_Num
	for i, v in ipairs(Text_Donate_Prop_Num) do
		local count = getPropAllCountByMouldId(costPropDatas[i][2])
		v:setString(count)
	end
end

function CommandWorldGlory:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateActivityState()
		self.totalTime = 0
	end
end

-- 更新倒计时
function CommandWorldGlory:updateActivityState()
	local surplus_time_2 = (self._crossServerEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	local surplus_time_3 = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)

	if surplus_time_2 > 0 then
		self._activityState = 2
		self:updateEndTime(surplus_time_2)
	else
		self._activityState = 3
		self:updateEndTime(surplus_time_3)
	end

	if self._tempActivityState ~= self._activityState then
		self._tempActivityState = self._activityState
		state_machine.excute("command_world_open_glory", 0, nil)
	end
end

-- 更新倒计时
function CommandWorldGlory:updateEndTime(surplus_time)
	if self.Text_time == nil or surplus_time == nil then
		return
	end
	self.Text_time:setString(surplus_time <= 0 and _string_piece_info[305] or self:drawTime_1(surplus_time))
end

-- HH:mm:ss
function CommandWorldGlory:drawTime_1(_time)
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

function CommandWorldGlory:onUpdateDraw()
	local root = self.roots[1]

	-- 颁奖结束时间
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	-- 排名
	self.Text_rank_0 = ccui.Helper:seekWidgetByName(root, "Text_rank_0")
	-- 排名
	self.Text_rank_0_2 = ccui.Helper:seekWidgetByName(root, "Text_rank_0_2")
	-- 排名
	self.Text_rank_0_3 = ccui.Helper:seekWidgetByName(root, "Text_rank_0_3")

	self.Text_Rank = {}
	table.insert(self.Text_Rank, self.Text_rank_0)
	table.insert(self.Text_Rank, self.Text_rank_0_2)
	table.insert(self.Text_Rank, self.Text_rank_0_3)

	-- 角色昵称
	self.Text_name_0 = ccui.Helper:seekWidgetByName(root, "Text_name_0")
	-- 角色昵称
	self.Text_name_0_2 = ccui.Helper:seekWidgetByName(root, "Text_name_0_2")
	-- 角色昵称
	self.Text_name_0_3 = ccui.Helper:seekWidgetByName(root, "Text_name_0_3")

	self.Text_Name = {}
	table.insert(self.Text_Name, self.Text_name_0)
	table.insert(self.Text_Name, self.Text_name_0_2)
	table.insert(self.Text_Name, self.Text_name_0_3)

	-- 积分数值
	self.Text_point_0 = ccui.Helper:seekWidgetByName(root, "Text_point_0")
	-- 积分数值
	self.Text_point_0_2 = ccui.Helper:seekWidgetByName(root, "Text_point_0_2")
	-- 积分数值
	self.Text_point_0_3 = ccui.Helper:seekWidgetByName(root, "Text_point_0_3")

	self.Text_point = {}
	table.insert(self.Text_point, self.Text_point_0)
	table.insert(self.Text_point, self.Text_point_0_2)
	table.insert(self.Text_point, self.Text_point_0_3)

	-- 角色立绘
	self.Panel_character = {}
	for i = 1, 3 do
		local Panel_character = ccui.Helper:seekWidgetByName(root, "Panel_character_"..i)
		table.insert(self.Panel_character, Panel_character)
		fwin:addTouchEventListener(Panel_character, nil,
		{
			terminal_name = "command_world_glory_get_reward",
			terminal_state = 0,
			isPressedActionEnabled = true,
			index = i,
		}, nil, 0)	
	end

	-- 排名容器
	self.Panel_player = {}
	for i = 1, 3 do
		local Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player_"..i)
		table.insert(self.Panel_player, Panel_player)
	end

	-- 排名
	self.Image_no = {}
	for i = 1, 3 do
		local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no_"..i)
		table.insert(self.Image_no, Image_no)
	end

	-- 奖励领取标志
	self.Image_klq = {}
	for i = 1, 3 do
		local Image_klq = ccui.Helper:seekWidgetByName(root, "Image_klq_"..i)
		table.insert(self.Image_klq, Image_klq)
	end

	-- 上忍道具持有数量
	self.Text_110 = ccui.Helper:seekWidgetByName(root, "Text_110")

	-- 中忍道具持有数量
	self.Text_121 = ccui.Helper:seekWidgetByName(root, "Text_121")

	-- 下忍道具持有数量
	self.Text_111 = ccui.Helper:seekWidgetByName(root, "Text_111")

	-- 捐献道具的数量（下忍，中忍，上忍）
	self.Text_Donate_Prop_Num = {}
	table.insert(self.Text_Donate_Prop_Num, self.Text_111)
	table.insert(self.Text_Donate_Prop_Num, self.Text_121)
	table.insert(self.Text_Donate_Prop_Num, self.Text_110)

	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	self:updateUI()
end

function CommandWorldGlory:onEnterTransitionFinish()
	-- 加载CommandWorldGloryWindow界面资源.
	-- res.activity.command_world.command_world_glory = res/activity/command_world/command_world_glory.csb
	local csbNode = csb.createNode("activity/command_world/command_world_glory.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 规则
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "command_world_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "command_world_glory_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 本服页签按钮
	self.Button_zuzhi_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zuzhi_1"), nil,
	{
		terminal_name = "command_world_button_zuzhi_click",
		terminal_state = 0,
		isPressedActionEnabled = false,
		_button = ccui.Helper:seekWidgetByName(root, "Button_zuzhi_1")
	}, nil, 0)	

	-- 跨服页签按钮
	self.Button_fwq = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fwq"), nil,
	{
		terminal_name = "command_world_button_fwq_click",
		terminal_state = 0,
		isPressedActionEnabled = false,
		_button = ccui.Helper:seekWidgetByName(root, "Button_fwq")
	}, nil, 0)	

	self:initDrawButtonShowState()
	self:changeTo(self.page_index)
end

function CommandWorldGlory:changeTo(page_index)
    local root = self.roots[1]
    if page_index == 1 then
        state_machine.excute("command_world_button_zuzhi_click", 0, {_datas = {_button = ccui.Helper:seekWidgetByName(root, "Button_zuzhi_1")}})
    elseif page_index == 2 then
        state_machine.excute("command_world_button_fwq_click", 0, {_datas = {_button = ccui.Helper:seekWidgetByName(root, "Button_fwq")}})
    end
end

function CommandWorldGlory:changeButtonViewState(button)
    button:setHighlighted(true)

    if button == self.current_button then
        return
    end

    if self.current_button ~= nil then
        self.current_button:setHighlighted(false)
    end
	self.current_button = button
	
	self:updateAll()
end

function CommandWorldGlory:updateAll()
	self:updateData()
	self:onUpdateDraw()
	self:updateServerPic()
end

function CommandWorldGlory:updateData()
	local function insert_glory_info(gloryInfo , arr)
		if gloryInfo ~= nil then
			for k,v in pairs(gloryInfo) do
				if tonumber(v.rankNumber) > 0 then
					table.insert(arr, v)
				end
			end

			table.sort(arr, function(a, b)
				return tonumber(a.rankNumber) < tonumber(b.rankNumber)
			end)
		end
	end

	local result = {}
	local gloryInfo = CommandWorldHandle.getCommandWorldGloryInfo()
	local crossGloryRankInfo = gloryInfo.crossGloryRankInfo
	local selfGloryRankInfo = gloryInfo.selfGloryRankInfo
	if self._activityState == 1 then
		insert_glory_info(selfGloryRankInfo , result)
	elseif self._activityState == 2 or self._activityState == 3 then
		local gloryRankInfo = nil
		if self.page_index == 1 then
			gloryRankInfo = gloryInfo.selfGloryRankInfo
		elseif self.page_index == 2 then
			gloryRankInfo = gloryInfo.crossGloryRankInfo
		end

		insert_glory_info(gloryRankInfo , result)
	end

	if table.nums(result) > 0 then
		self.gloryInfo = result
	else
		self.gloryInfo = nil
	end
end

function CommandWorldGlory:updateServerPic()
	local root = self.roots[1]
	local Image_zuzhi = ccui.Helper:seekWidgetByName(root, "Image_zuzhi")
	local Image_fwq = ccui.Helper:seekWidgetByName(root, "Image_fwq")
	Image_zuzhi:setVisible(self.page_index == 1)
	Image_fwq:setVisible(self.page_index == 2)
end

function CommandWorldGlory:initDrawButtonShowState()
	local root = self.roots[1]
	local Button_zuzhi_1 = ccui.Helper:seekWidgetByName(root, "Button_zuzhi_1")
	local Button_fwq = ccui.Helper:seekWidgetByName(root, "Button_fwq")
	local Button_zuzhi_2 = ccui.Helper:seekWidgetByName(root, "Button_zuzhi_2")
	local Button_fwq_2 = ccui.Helper:seekWidgetByName(root, "Button_fwq_2")

	local gloryInfo = CommandWorldHandle.getCommandWorldGloryInfo()
	local crossGloryRankInfo = gloryInfo.crossGloryRankInfo
	local selfGloryRankInfo = gloryInfo.selfGloryRankInfo

	local time = CommandWorldHandle.getCommandWorldEndTimeInfo()
	local localEndTime = time.localEndTime
	local crossEndTime = time.crossEndTime
	local diff_localEndTime = difftime(localEndTime)
	local diff_crossEndTime = difftime(crossEndTime)

	local function checkGloryRankInfo(gloryRankInfo)
		local success = false
		if gloryRankInfo ~= nil then
			for k,v in pairs(gloryRankInfo) do
				if tonumber(v.rankNumber) > 0 then
					success = true
					break
				end
			end
		end
		
		return success
	end

	if diff_localEndTime < 0 and diff_crossEndTime >= 0 then
		Button_zuzhi_1:setVisible(false)
		Button_fwq:setVisible(false)
		Button_zuzhi_2:setVisible(true)
		Button_fwq_2:setVisible(false)
		self.page_index = 1
	end

	if diff_crossEndTime < 0 then
		local success_1 = checkGloryRankInfo(selfGloryRankInfo)
		local success_2 = checkGloryRankInfo(crossGloryRankInfo)
		if success_1 == true and success_2 == true then
			Button_zuzhi_1:setVisible(true)
			Button_fwq:setVisible(true)
			Button_zuzhi_2:setVisible(false)
			Button_fwq_2:setVisible(false)
			self.page_index = 1  -- 默认值1
		elseif success_1 == true and success_2 == false then
			Button_zuzhi_1:setVisible(false)
			Button_fwq:setVisible(false)
			Button_zuzhi_2:setVisible(true)
			Button_fwq_2:setVisible(false)
			self.page_index = 1  -- 只有本服数据时
		elseif success_1 == false and success_2 == true then
			Button_zuzhi_1:setVisible(false)
			Button_fwq:setVisible(false)
			Button_zuzhi_2:setVisible(false)
			Button_fwq_2:setVisible(true)
			self.page_index = 2  -- 只有跨服数据时
		end
	end
end

function CommandWorldGlory:onExit()
	-- 释放CommandWorldGloryWindow界面资源.
	state_machine.remove("command_world_glory_open")
	state_machine.remove("command_world_glory_close")
	state_machine.remove("command_world_glory_show")
	state_machine.remove("command_world_glory_hide")
	state_machine.remove("command_world_glory_refesh")
	state_machine.remove("command_world_glory_get_reward")
	state_machine.remove("command_world_button_zuzhi_click")
	state_machine.remove("command_world_button_fwq_click")
end

function CommandWorldGlory:close()
	-- window event : close.
	
end

function CommandWorldGlory:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
