--[[ ----------------------------------------------------------------------------
-- 挑战窗口
--]] ----------------------------------------------------------------------------
TeamArenaChallenge = class("TeamArenaChallengeClass", Window)

-- 打开窗口
local team_arena_challenge_window_open_terminal = {
	_name = "team_arena_challenge_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaChallengeClass") then
			fwin:open(TeamArenaChallenge:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_challenge_window_close_terminal = {
	_name = "team_arena_challenge_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaChallengeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_challenge_window_open_terminal)
state_machine.add(team_arena_challenge_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaChallenge:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena challenge page state machine.
	local function init_team_arena_challenge_terminal()
		-- 打开角色创建窗口
		local team_arena_challenge_open_terminal = {
			_name = "team_arena_challenge_open",
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
		local team_arena_challenge_close_terminal = {
			_name = "team_arena_challenge_close",
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
		local team_arena_challenge_show_terminal = {
			_name = "team_arena_challenge_show",
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
		local team_arena_challenge_hide_terminal = {
			_name = "team_arena_challenge_hide",
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

		-- 刷新数据
		local team_arena_challenge_refresh_terminal = {
			_name = "team_arena_challenge_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:initData()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 挑战
		local team_arena_challenge_begin_terminal = {
			_name = "team_arena_challenge_begin",
			_init = function (terminal)
                app.load("client.battle.BattleStartEffect")
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local pos = tonumber(params._datas.pos)
					local function team_arena_challengeCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

							if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
								_ED.user_is_level_up = true
								_ED.arena_is_level_up = true
								_ED.last_grade = _ED.user_info.last_user_grade
								_ED.last_food = _ED.user_info.last_user_food
								_ED.last_endurance = _ED.user_info.last_endurance			
							end

							-- 战斗结果处理
							for k,v in pairs(_ED.TeamArena_battleData) do
								v.battle_total_count = #_ED.TeamArena_battleData
							end

							_ED.TeamArena_round = #_ED.TeamArena_attackData
							_ED.TeamArena_iswin = true
							_ED.TeamArena_win = {}
							_ED.TeamArena_lose = {}
							local me = 0
							local en = 0
							for k,v in pairs(_ED.TeamArena_attackData) do
								
								if tonumber(v.isWin) == 1 then
									me = me+1
								else
									en = en+1
								end
							end
							if me > en then
								_ED.TeamArena_iswin = true
							else
								_ED.TeamArena_iswin = false
							end
							_ED.TeamArena_win.score = me
							_ED.TeamArena_win.name = _ED.team_arena_data.myTeamInfo.teamName
							_ED.TeamArena_win.integral = _ED.team_arena_attack_result.attackIntegral.."(+".._ED.team_arena_attack_result.attackChange..")"
							_ED.TeamArena_win.server = _ED.selected_server
							_ED.TeamArena_win.headPic = _ED.user_info.user_head
							
							
							_ED.TeamArena_lose.score = en
							_ED.TeamArena_lose.name = _ED.team_arena_matching.list[pos].teamName
							_ED.TeamArena_lose.integral = _ED.team_arena_attack_result.defendIntegral.."(".._ED.team_arena_attack_result.defendChange..")"
							_ED.TeamArena_lose.server = _ED.team_arena_matching.list[pos].serverNum
							_ED.TeamArena_lose.headPic = _ED.team_arena_matching.list[pos].players[1].headPic

							if _ED.TeamArena_iswin == false then
								_ED.TeamArena_win.integral = _ED.team_arena_attack_result.attackIntegral.."(".._ED.team_arena_attack_result.attackChange..")"
								_ED.TeamArena_lose.integral = _ED.team_arena_attack_result.defendIntegral.."(+".._ED.team_arena_attack_result.defendChange..")"
							end
							-- debug.print_r(_ED.team_arena_matching.list[pos],"_ED.team_arena_matching.list[pos]")


							-- debug.print_r(_ED.TeamArena_win,"_ED.TeamArena_win")
							-- debug.print_r(_ED.TeamArena_lose,"_ED.TeamArena_lose")

							-- 初始第一场的数据
							_ED.battleData = _ED.TeamArena_battleData[1]
							_ED.attackData = _ED.TeamArena_attackData[1]
							_ED.battleData._battle_start_influence_info = _ED.TeamArena_battle_start_influence_info[1]
							_ED.battleData._battle_round_influence_infos = _ED.TeamArena_battle_round_influence_infos[1]
							_ED.battleData._camp_change_influence_infos = _ED.TeamArena_start_influence_info[1]
							_ED.animalRoundData = _ED.TeamArena_animal_round_data[1]

							--debug.print_r(_ED.attackData.isWin,'_ED.attackData.isWin=========================================')

							-- 记录三场的输赢情况
							_ED.cross_server_battel_result = {}
							table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)
							
							fwin:close(self.userInformationHeroStorage)
							fwin:cleanView(fwin._windows)
							fwin:freeAllMemeryPool()
							local bse = BattleStartEffect:new()
							bse:init(_enum_fight_type._fight_type_220)
							fwin:open(bse, fwin._windows)
						end
					end

					-- 清空跨服战的战斗数据缓存
					_ED.TeamArena_battleData = {}
					_ED.TeamArena_attackData = {}
					_ED.TeamArena_battle_start_influence_info = {}
					_ED.TeamArena_battle_round_influence_infos = {}
					_ED.TeamArena_start_influence_info = {}
					_ED.TeamArena_animal_round_data = {}

					-- local pos = tonumber(sender.fightpos)
					protocol_command.team_arena_challenge.param_list = _ED.team_arena_matching.list[pos].teamId
					NetworkManager:register(protocol_command.team_arena_challenge.code, nil, nil, nil, self, team_arena_challengeCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(team_arena_challenge_begin_terminal)


		state_machine.add(team_arena_challenge_refresh_terminal)

		state_machine.add(team_arena_challenge_open_terminal)
		state_machine.add(team_arena_challenge_close_terminal)
		state_machine.add(team_arena_challenge_show_terminal)
		state_machine.add(team_arena_challenge_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena challenge state machine.
	init_team_arena_challenge_terminal()
end

-- 对象初始化
function TeamArenaChallenge:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaChallenge:onUpdateDraw()
	local root = self.roots[1]
	
	-- 当前体力999/999
	self.Text_tili_n = ccui.Helper:seekWidgetByName(root, "Text_tili_n")

	-- 体力恢复倒计时
	self.Text_tzcs = ccui.Helper:seekWidgetByName(root, "Text_tili_n")
	self.Text_time_0 = ccui.Helper:seekWidgetByName(root, "Text_tili_1_0")
	self.Text_cd_n = ccui.Helper:seekWidgetByName(root, "Text_tili_time")
	-- 自身战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Text_craft:setString(_ED.team_arena_data.myTeamInfo.combat)

	local function func_head(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- 获取攻击阵容
			local pos = tonumber(sender.fightpos)
			state_machine.excute("team_arena_enemy_window_open",0, _ED.team_arena_matching.list[pos])

		end
	end
	
	for i=1,3 do
		local playerRoot = ccui.Helper:seekWidgetByName(root, "Panel_player_"..i)
		playerRoot.fightpos = i
		playerRoot:addTouchEventListener(func_head)
		playerRoot:setVisible(false)
		if _ED.team_arena_matching.list[i] then
			playerRoot:setVisible(true)
			local data = _ED.team_arena_matching.list[i]
			ccui.Helper:seekWidgetByName(root, "Text_player_name_"..i):setString(data.teamName)
			-- local num = "S"..tonumber(data.serverNumber)%1000
			-- ccui.Helper:seekWidgetByName(root, "Text_server_n_"..i):setString(num)

			-- 玩家积分
			ccui.Helper:seekWidgetByName(root, "Text_point_n_"..i):setString(data.integral)
			-- 玩家战力1
			ccui.Helper:seekWidgetByName(root, "Text_craft_n_"..i):setString(data.combat)

			--头像
			for j=1,3 do
				local hdata = data.players[j]
				if hdata then
					local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_"..i.."_"..j)
					Panel_head:removeAllChildren(true)
					if Panel_head ~= nil then
						local playerIconStr = nil
						if tonumber(hdata.headPic) >= 9 then
							playerIconStr = string.format("images/ui/props/props_%s.png", hdata.headPic)
						else
							playerIconStr = string.format("images/ui/home/head_%s.png", hdata.headPic)
						end
						local sprit = cc.Sprite:create(playerIconStr)
						sprit:setAnchorPoint(cc.p(0.5,0.5))
						sprit:setPosition(cc.p(Panel_head:getContentSize().width / 2, Panel_head:getContentSize().height / 2))
						Panel_head:addChild(sprit,0)
					end
				end
			end

		else
			-- playerRoot:setVisible(false)
		end
	end
	
	if tonumber(_ED.team_arena_data.state) == 4 then
		self:getChangeTimes()
	end

end

function TeamArenaChallenge:onEnterTransitionFinish()
	-- 加载TeamArenaChallengeWindow界面资源.
	-- res.campaign.team_arena.team_arena_challenge = res/campaign/team_arena/team_arena_challenge.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_challenge.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 挑战队伍1
	self.Button_fight_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight_1"), nil,
	{
		terminal_name = "team_arena_challenge_begin",
		terminal_state = 0,
		isPressedActionEnabled = true,
		pos = 1
	}, nil, 0)	

	-- 挑战队伍2
	self.Button_fight_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight_2"), nil,
	{
		terminal_name = "team_arena_challenge_begin",
		terminal_state = 0,
		isPressedActionEnabled = true,
		pos = 2
	}, nil, 0)	

	-- 挑战队伍3
	self.Button_fight_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight_3"), nil,
	{
		terminal_name = "team_arena_challenge_begin",
		terminal_state = 0,
		isPressedActionEnabled = true,
		pos = 3
	}, nil, 0)	

	-- 刷新
	self.Button_refresh = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh"), nil,
	{
		terminal_name = "team_arena_challenge_refresh",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_challenge_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:initData()
end
function TeamArenaChallenge:initData()
	local function team_arena_matchingCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onUpdateDraw()
			end
		end
	end
	protocol_command.team_arena_matching.param_list = ""
	NetworkManager:register(protocol_command.team_arena_matching.code, nil, nil, nil, self, team_arena_matchingCallback, false, nil)
end
function TeamArenaChallenge:updateChangeTimes()

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

function TeamArenaChallenge:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%01d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function TeamArenaChallenge:getChangeTimes()
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
function TeamArenaChallenge:onUpdate(dt)
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
end
function TeamArenaChallenge:onExit()
	-- 释放TeamArenaChallengeWindow界面资源.
	state_machine.remove("team_arena_challenge_open")
	state_machine.remove("team_arena_challenge_close")
	state_machine.remove("team_arena_challenge_show")
	state_machine.remove("team_arena_challenge_hide")
	state_machine.remove("team_arena_challenge_refresh")
	state_machine.remove("team_arena_challenge_begin")

end

function TeamArenaChallenge:close()
	-- window event : close.
	
end

function TeamArenaChallenge:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
