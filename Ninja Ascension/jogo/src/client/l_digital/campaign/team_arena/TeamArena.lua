--[[ ----------------------------------------------------------------------------
-- 小队竞技场主界面
--]] ----------------------------------------------------------------------------
TeamArena = class("TeamArenaClass", Window)

-- 打开窗口
local team_arena_window_open_terminal = {
	_name = "team_arena_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaClass") then
			fwin:open(TeamArena:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_window_close_terminal = {
	_name = "team_arena_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_window_open_terminal)
state_machine.add(team_arena_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArena:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
    _ED.team_arean_red_flag = true

	self.deltaTime = 1
	self.totalTime = 0
	self._endTime = nil

	-- load lua files.
	app.load("client.l_digital.campaign.team_arena.TeamArenaFormation")
	app.load("client.l_digital.campaign.team_arena.TeamArenaFormation1")
	app.load("client.l_digital.campaign.team_arena.TeamArenaReport")
	app.load("client.l_digital.campaign.team_arena.TeamArenaReward")
	app.load("client.l_digital.campaign.team_arena.TeamArenaChallenge")
	app.load("client.l_digital.campaign.team_arena.TeamArenaTeam1")
	app.load("client.l_digital.campaign.team_arena.TeamArenaTeam2")
	app.load("client.l_digital.campaign.team_arena.TeamArenaAsk1")
	app.load("client.l_digital.campaign.team_arena.TeamArenaAsk2")
	app.load("client.l_digital.campaign.team_arena.TeamArenaAsk3")
	app.load("client.l_digital.campaign.team_arena.teamarenarole")
	app.load("client.l_digital.campaign.team_arena.TeamArenaFormationIcon")
	app.load("client.l_digital.campaign.team_arena.TeamArenaPrompt")
	app.load("client.l_digital.campaign.team_arena.TeamArenaVictory")
	app.load("client.l_digital.campaign.team_arena.TeamArenaInfo")
	app.load("client.l_digital.campaign.team_arena.TeamArenaInfoShow")
	app.load("client.l_digital.campaign.team_arena.TeamArenaEnemy")
	app.load("client.l_digital.campaign.team_arena.TeamArenaRule")
	app.load("client.l_digital.campaign.team_arena.TeamArenaPlayerInfoShow")
	
	-- Initialize team arena page state machine.
	local function init_team_arena_terminal()
		-- 打开角色创建窗口
		local team_arena_open_terminal = {
			_name = "team_arena_open",
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
		local team_arena_close_terminal = {
			_name = "team_arena_close",
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
		local team_arena_show_terminal = {
			_name = "team_arena_show",
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
		local team_arena_hide_terminal = {
			_name = "team_arena_hide",
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

		-- 集结
		local team_arena_jijie_terminal = {
			_name = "team_arena_jijie",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)

				if tonumber(_ED.team_arena_data.state) == 1 then   --未到开启时间(
					TipDlg.drawTextDailog(tipStringInfo_team_arena[9])
				else
					-- 玩家集结大厅状态
					local function team_arena_enter_build_up_hallCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if nil ~= response.node and nil ~= response.node.roots then
								local state = tonumber(_ED.team_arena_team_status.state)
								if state == 1 then
									state_machine.excute("team_arena_team1_window_open",0,"")
								else
									state_machine.excute("team_arena_team2_window_open",0,"")
								end
							end
						end
					end
					protocol_command.team_arena_enter_build_up_hall.param_list = ""
					NetworkManager:register(protocol_command.team_arena_enter_build_up_hall.code, nil, nil, nil, self, team_arena_enter_build_up_hallCallback, false, nil)
				end

				
					
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新数据
		local team_arena_refresh_launch_list_terminal = {
			_name = "team_arena_refresh_launch_list",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:initData()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(team_arena_refresh_launch_list_terminal)
		state_machine.add(team_arena_jijie_terminal)
		state_machine.add(team_arena_open_terminal)
		state_machine.add(team_arena_close_terminal)
		state_machine.add(team_arena_show_terminal)
		state_machine.add(team_arena_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena state machine.
	init_team_arena_terminal()
end

-- 对象初始化
function TeamArena:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArena:onUpdateDraw()
	local root = self.roots[1]
	if _ED.team_arena_data.myTeamInfo then
		-- 玩家排名
		self.Text_rank_n:setString(_ED.team_arena_data.myTeamInfo.ranking)
		
		-- 玩家战力
		self.Text_fight_n:setString(_ED.team_arena_data.myTeamInfo.combat)

		-- 积分
		self.Text_point_n:setString(_ED.team_arena_data.myTeamInfo.integral)
	end

	if tonumber(_ED.team_arena_data.state) == 4 then
		self.Button_call:setVisible(false)
		if self.Panel_di_xv1 then
			self.Panel_di_xv1:setVisible(true)
		end
		self.Panel_top:setVisible(true)
		if _ED.team_arena_data.isLeader and tonumber(_ED.team_arena_data.isLeader) == 1 then --队长
			self.Button_change:setVisible(true)
			self.Button_fight:setVisible(true)
		else
			self.Button_change:setVisible(false)
			self.Button_fight:setVisible(false)
		end
	else
		self.Button_call:setVisible(true)
		if self.Panel_di_xv1 then
			self.Panel_di_xv1:setVisible(false)
		end
		self.Panel_top:setVisible(false)
	end
	-- 设置阵容
	if tonumber(_ED.team_arena_data.state) == 2 then
		state_machine.excute("team_arena_formation_window_open",0,"")
	end

	if tonumber(_ED.team_arena_data.state) == 4 then
		self:getChangeTimes()
	end
	-- 红点
	if _ED.team_arena_data.redDot==nil or tonumber(_ED.team_arena_data.redDot) == 0 then
		self.Image_hint_call:setVisible(false)
	else
		self.Image_hint_call:setVisible(true)
	end
end

function TeamArena:updateEndTime()
	self._endTime = tonumber(_ED.team_arena_data.endTime)
end

function TeamArena:updateRemainTime()
	if self.Text_time_1 == nil or self._endTime == nil then
		return
	end
	local surplus_time = (self._endTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time_1:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function TeamArena:drawTime(_time)
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

function TeamArena:onEnterTransitionFinish()
	-- 加载TeamArenaWindow界面资源.
	-- res.campaign.team_arena.team_arena = res/campaign/team_arena/team_arena.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self.Text_tzcs = ccui.Helper:seekWidgetByName(root, "Text_tzcs")
	self.Text_time_0 = ccui.Helper:seekWidgetByName(root, "Text_time_0")
	self.Text_cd_n = ccui.Helper:seekWidgetByName(root, "Text_time")
	self.Panel_top = ccui.Helper:seekWidgetByName(root, "Panel_top")
	self.Image_hint_call = ccui.Helper:seekWidgetByName(root, "Image_hint_call")

	-- 剩余时间
	self.Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")
	self:updateEndTime()

	-- 奖励预览
	self.Button_reward = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward"), nil,
	{
		terminal_name = "team_arena_reward_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 记录
	self.Button_record = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_record"), nil,
	{
		terminal_name = "team_arena_report_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 挑战
	self.Button_fight = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight"), nil,
	{
		terminal_name = "team_arena_challenge_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_formation = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation"), nil,
	{
		terminal_name = "team_arena_formation_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	-- 队伍调整
	self.Button_change = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"), nil,
	{
		terminal_name = "team_arena_formation1_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	--集结
	self.Button_call = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_call"), nil,
	{
		terminal_name = "team_arena_jijie",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 左箭头
	self.Button_arrow_l = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_l"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.Button_arrow_l:setVisible(false)

	-- 右箭头
	self.Button_arrow_r = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_r"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.Button_arrow_r:setVisible(false)

	self.Button_rule = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil,
	{
		terminal_name = "team_arena_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.panelItems = {}
	-- 队伍内玩家1头像
	local Panel_item_1 = ccui.Helper:seekWidgetByName(root, "Panel_item_1")
	table.insert(self.panelItems,Panel_item_1)
	-- 队伍内玩家2头像
	local Panel_item_2 = ccui.Helper:seekWidgetByName(root, "Panel_item_2")
	table.insert(self.panelItems,Panel_item_2)
	

	-- 队伍内玩家3头像
	local Panel_item_3 = ccui.Helper:seekWidgetByName(root, "Panel_item_3")
	table.insert(self.panelItems,Panel_item_3)

	-- 背景动画
	self.ArmatureNode_bg = ccui.Helper:seekWidgetByName(root, "ArmatureNode_bg")

	-- 玩家排名
	self.Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")
	
	-- 玩家战力
	self.Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")

	-- 积分
	self.Text_point_n = ccui.Helper:seekWidgetByName(root, "Text_point_n")

	-- 主界面列表
	self.ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")

	-- 底部容器，仅在创建队伍后显示（主界面2）
	self.Panel_di_xv1 = ccui.Helper:seekWidgetByName(root, "Panel_di_xv1")
	if self.Panel_di_xv1 == nil then
		self.Panel_di_xv1 = ccui.Helper:seekWidgetByName(root, "Panel_di")
	end

	self:initData()
end

function TeamArena:initData()
	-- _ED.team_arena_data = json.decode('{"ranks":[{"player1":{"level":90,"nickName":"aaa","combat":5555,"headPic":1},"player2":{"level":80,"nickName":"bbb","combat":4444,"headPic":2},"player3":{"level":70,"nickName":"ccc","combat":3333,"headPic":3},"integral":1210,"teamId":1525804,"serverNum":2001,"ranking":1,"combat":55555},{"player1":{"level":90,"nickName":"AAA","combat":5555,"headPic":1},"player2":{"level":80,"nickName":"BBB","combat":4444,"headPic":2},"player3":{"level":70,"nickName":"CCC","combat":3333,"headPic":3},"integral":1200,"teamId":2971201,"serverNum":2002,"ranking":2,"combat":55505}],"state":4,"myTeamInfo":{"player1":{"level":90,"nickName":"AAA","combat":5555,"headPic":1},"player2":{"level":80,"nickName":"BBB","combat":4444,"headPic":2},"player3":{"level":70,"nickName":"CCC","combat":3333,"headPic":3},"integral":1200,"teamId":2971201,"serverNum":2002,"ranking":2,"combat":55505}}')

	-- _ED.team_arena_formation = json.decode('{"formation":[{"evolutionStatus":"1|2,0,0,0","level":80,"shipMould":100,"combat":2000,"starLevel":4,"qualityLevel":5},{"evolutionStatus":"1|2,0,0,0","level":80,"shipMould":200,"combat":3000,"starLevel":4,"qualityLevel":5}]}')
	-- _ED.team_arena_challenge_times = json.decode('{"challengeTimes":5,"countDown":-1}')
	-- self:onInitDraw()

	-- [[初始化竞技场
	local function responseCrossTotalWarInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onInitDraw()
			end
		end

	end
	protocol_command.team_arena_enter.param_list = ""
	NetworkManager:register(protocol_command.team_arena_enter.code, nil, nil, nil, self, responseCrossTotalWarInitCallback, false, nil)
	-- ~初始化竞技场]]

	
end

function TeamArena:onInitDraw()
	self:onUpdateDraw()
	self:updateDrawHead()
	self:onRefreshLaunchListView()
end


function TeamArena:onRefreshLaunchListView( ... )

	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	ListView_challenger:removeAllItems()
	for i, v in pairs(_ED.team_arena_data.ranks) do
		local cell = state_machine.excute("team_arena_role_create",0,v)
		ListView_challenger:addChild(cell)
	end
	ListView_challenger:refreshView()

	-- ListView_challenger:scrollToRight(0.01, false)
	self.cacheListView = ListView_challenger
	
	self.cacheListViewPosX = ListView_challenger:getInnerContainer():getPositionX()
	-- ListView_challenger:getInnerContainer():setPositionX(self.cacheListViewPosX - 1)
	
end

function TeamArena:updateDrawHead()

	if _ED.team_arena_data.myTeamInfo then
		for i=1,3 do
			local data = _ED.team_arena_data.myTeamInfo["player"..i]
			if data then
				local Panel_head = self.panelItems[i]
				if Panel_head ~= nil then
					Panel_head:removeBackGroundImage()
					local playerIconStr = nil
					if tonumber(data.headPic) >= 9 then
						playerIconStr = string.format("images/ui/props/props_%s.png", data.headPic)
					else
						playerIconStr = string.format("images/ui/home/head_%s.png", data.headPic)
					end
					debug.print_r(playerIconStr,"playerIconStr")

					Panel_head:setBackGroundImage(playerIconStr)
				end
			end
		end
	end
	
end

function TeamArena:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%01d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function TeamArena:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateRemainTime()
		self.totalTime = 0
	end

	if nil ~= self._interval and -1 ~= self._interval then
        self._interval = self._interval - dt
        if self._last_interval - self._interval > 0.5 then
            self._last_interval = self._interval
            if self._interval < 0 then
                self:getChangeTimes()
            else
                self.Text_cd_n:setString(self:formatTimeString(self._interval))
            end
        end
    end
    
    if self.cacheListView ~= nil then
    	local size = self.cacheListView:getContentSize()
		local posX = self.cacheListView:getInnerContainer():getPositionX()
		local posY = self.cacheListView:getInnerContainer():getPositionY()

		if self ._list_view_posY == 0 then
	        self._list_view_posY = posY
	    end
    	
		if self.cacheListViewPosX == posX then
			return
		end
		self.cacheListViewPosX = posX
		local items = self.cacheListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempX = v:getPositionX() + posX
			if tempX + itemSize.width/2 < 0 or tempX > size.width + itemSize.width/2 then
				v:unload()
			else
				v:reload()
			end
		end
		
	end
end
function TeamArena:updateChangeTimes()

	-- 挑战次数
	-- if tonumber(_ED.team_arena_data.state) == 4 then
		local everyDayFreeLounchCount = dms.string(dms["gvg_config"], 39, 4)
		self.Text_tzcs:setString("" .. _ED.team_arena_challenge_times.challengeTimes .. "/" .. everyDayFreeLounchCount)
		
		self._interval = nil
		
		
		self.Text_time_0:setVisible(false)
		self.Text_cd_n:setVisible(false)

		if nil ~=_ED.team_arena_challenge_times.countDown and tonumber(_ED.team_arena_challenge_times.countDown) > 0 then
			local interval =_ED.team_arena_challenge_times.countDown / 1000
			if interval > 0 then
				self.Text_time_0:setVisible(true)
				self._interval = interval
				self._last_interval = interval
				self.Text_cd_n:setVisible(true)
				self.Text_cd_n:setString(self:formatTimeString(self._interval))
			end
		end
	-- end
	
end
function TeamArena:getChangeTimes()
	-- 获取挑战次数
	local function team_arena_remaining_challengesCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:updateChangeTimes()
			end
		end
	end
	protocol_command.team_arena_challenge_times.param_list = ""
	NetworkManager:register(protocol_command.team_arena_challenge_times.code, nil, nil, nil, self, team_arena_remaining_challengesCallback, false, nil)
end
function TeamArena:onExit()
	-- 释放TeamArenaWindow界面资源.
	state_machine.remove("team_arena_open")
	state_machine.remove("team_arena_close")
	state_machine.remove("team_arena_show")
	state_machine.remove("team_arena_hide")
	state_machine.remove("team_arena_refresh_launch_list")
	
end

function TeamArena:close()
	-- window event : close.
	
end

function TeamArena:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
