--[[ ----------------------------------------------------------------------------
-- 组队后集结页面
--]] ----------------------------------------------------------------------------
TeamArenaTeam2 = class("TeamArenaTeam2Class", Window)

-- 打开窗口
local team_arena_team2_window_open_terminal = {
	_name = "team_arena_team2_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaTeam2Class") then
			fwin:open(TeamArenaTeam2:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_team2_window_close_terminal = {
	_name = "team_arena_team2_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaTeam2Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_team2_window_open_terminal)
state_machine.add(team_arena_team2_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaTeam2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.campaign.team_arena.teamarenateamlist2")
	app.load("client.l_digital.campaign.team_arena.TeamArenaAsk1")
	app.load("client.l_digital.campaign.team_arena.TeamArenaAsk2")
	
	-- Initialize team arena team2 page state machine.
	local function init_team_arena_team2_terminal()
		-- 打开角色创建窗口
		local team_arena_team2_open_terminal = {
			_name = "team_arena_team2_open",
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
		local team_arena_team2_close_terminal = {
			_name = "team_arena_team2_close",
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
		local team_arena_team2_show_terminal = {
			_name = "team_arena_team2_show",
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
		local team_arena_team2_hide_terminal = {
			_name = "team_arena_team2_hide",
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

		-- 解散
		local team_arena_team2_disband_terminal = {
			_name = "team_arena_team2_disband",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local function team_arena_exit_teamCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								state_machine.excute("team_arena_team2_window_close",0,"")
								state_machine.excute("team_arena_prpt_window_close",0,"")
								state_machine.excute("team_arena_info_window_close",0,"")
								state_machine.excute("team_arena_refresh_launch_list",0,"")
								state_machine.excute("team_arena_jijie",0,"")
								
						end
					end
					protocol_command.team_arena_exit_team.param_list = ""
					NetworkManager:register(protocol_command.team_arena_exit_team.code, nil, nil, nil, self, team_arena_exit_teamCallback, false, nil)

				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 提交
		local team_arena_team2_submit_terminal = {
			_name = "team_arena_team2_submit",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					local function team_arena_commit_teamCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if nil ~= response.node and nil ~= response.node.roots then
								state_machine.excute("team_arena_team2_window_close",0, "")
								state_machine.excute("team_arena_prpt_window_close",0, "")
								state_machine.excute("team_arena_refresh_launch_list",0, "")
								-- state_machine.excute("team_arena_jijie",0,"")
							end
						end
					end
					protocol_command.team_arena_commit_team.param_list = ""
					NetworkManager:register(protocol_command.team_arena_commit_team.code, nil, nil, nil, self, team_arena_commit_teamCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local team_arena_team2_submit_pop_terminal = {
			_name = "team_arena_team2_submit_pop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("team_arena_prpt_window_open",0, {machine="team_arena_team2_submit",type=5,data="0"})
					
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 请离
		local team_arena_team2_kick_out_terminal = {
			_name = "team_arena_team2_kick_out",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local function team_arena_kick_outCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if nil ~= response.node and nil ~= response.node.roots then
								state_machine.excute("team_arena_prpt_window_close",0,"")
								state_machine.excute("team_arena_info_window_close",0,"")
								response.node:onUpdateDraw()
							end
						end
					end
					debug.print_r(params,"params")
					protocol_command.team_arena_kick_out.param_list = params
					NetworkManager:register(protocol_command.team_arena_kick_out.code, nil, nil, nil, self, team_arena_kick_outCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 转让
		local team_arena_team2_turn_terminal = {
			_name = "team_arena_team2_turn",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local function team_arena_transfer_captainCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if nil ~= response.node and nil ~= response.node.roots then
								state_machine.excute("team_arena_team2_window_close",0,"")
								state_machine.excute("team_arena_prpt_window_close",0,"")
								state_machine.excute("team_arena_info_window_close",0,"")
								state_machine.excute("team_arena_refresh_launch_list",0,"")
								state_machine.excute("team_arena_jijie",0,"")
								
							end
						end
					end
					protocol_command.team_arena_transfer_captain.param_list = params

					NetworkManager:register(protocol_command.team_arena_transfer_captain.code, nil, nil, nil, self, team_arena_transfer_captainCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		
		local team_arena_team2_ql_pop_terminal = {
			_name = "team_arena_team2_ql_pop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local pos = tonumber(params.pos)
				if nil ~= instance then
					local state = tonumber(_ED.team_arena_team_status.state)
					local player = _ED.team_arena_enter_build_up_hall_out.players[pos]
					-- if (state == 2 and tonumber(player.userId) == tonumber(_ED.user_info.user_id))  then  --队员 退出
						-- state_machine.excute("team_arena_info_window_open",0, {type=4,data='0',playerInfo=player})
					-- end

					-- if (state == 3 and tonumber(player.userId) ~=  tonumber(_ED.user_info.user_id))  then  --队长 请离
						state_machine.excute("team_arena_info_window_open",0, {type=3,data=player.userId,playerInfo=player})
					-- end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
-- 刷新红点
		local team_arena_team2_applyred_terminal = {
			_name = "team_arena_team2_applyred",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:onUpdateApplyRed()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(team_arena_team2_applyred_terminal)
		state_machine.add(team_arena_team2_turn_terminal)
		state_machine.add(team_arena_team2_ql_pop_terminal)
		state_machine.add(team_arena_team2_kick_out_terminal)
		state_machine.add(team_arena_team2_submit_pop_terminal)
		state_machine.add(team_arena_team2_submit_terminal)
		state_machine.add(team_arena_team2_disband_terminal)
		state_machine.add(team_arena_team2_open_terminal)
		state_machine.add(team_arena_team2_close_terminal)
		state_machine.add(team_arena_team2_show_terminal)
		state_machine.add(team_arena_team2_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena team2 state machine.
	init_team_arena_team2_terminal()
end

-- 对象初始化
function TeamArenaTeam2:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaTeam2:onUpdateDraw()
	local root = self.roots[1]

	--  {"teamId":"654982","teamName":"BBBB","joinLimit":50000,"combat":100000,"serverNum":2001,"players":[{"userId":10001,"level":70,"nickName":"aa","combat":100000,"headPic":10001},{"userId":10002,"level":60,"nickName":"aaa","combat":200000,"headPic":10001}]}

	-- 队伍名称
	self.Text_team:setString(_ED.team_arena_enter_build_up_hall_out.teamName)

	-- 队伍id
	self.Text_id_t:setString(_ED.team_arena_enter_build_up_hall_out.teamId)

	-- 队伍战力
	self.Text_craft:setString(_ED.team_arena_enter_build_up_hall_out.combat)
	local totalPlayer = 0
	for i=1,3 do
		local data = _ED.team_arena_enter_build_up_hall_out.players[i]
		self.Panel_player[i]:removeAllChildren(true)
		if data  then
			local cell = state_machine.excute("team_arena_team_list2_create",0, data)
			self.Panel_player[i]:addChild(cell)
			if data.userId then 
				-- fwin:addTouchEventListener(self.Panel_player[i], nil,
				-- {
				-- 	terminal_name = "team_arena_team2_ql_pop",
				-- 	terminal_state = 0,
				-- 	isPressedActionEnabled = true,
				-- 	pos = i
				-- }, nil, 0)
				totalPlayer = totalPlayer+1
				function Button_fightcb(sender, eventType)
					if eventType == ccui.TouchEventType.ended then
						state_machine.excute("team_arena_team2_ql_pop",0, {pos=i})
					end
				end
				self.Panel_player[i]:addTouchEventListener(Button_fightcb)

			else
				fwin:addTouchEventListener(self.Panel_player[i], nil,
				{
					terminal_name = "team_arena_ask2_window_open",
					terminal_state = 0,
					isPressedActionEnabled = true,
				}, nil, 0)
			end
		end
	end
	if totalPlayer<3 then
		self.Button_submit:setVisible(false)
	else
		self.Button_submit:setVisible(true)
	end


	local state = tonumber(_ED.team_arena_team_status.state)
	if state == 2 then  --队员
		self.Panel_leader:setVisible(false)
	else
		self.Panel_leader:setVisible(true)
	end

end

function TeamArenaTeam2:onEnterTransitionFinish()
	-- 加载TeamArenaTeam2Window界面资源.
	-- res.campaign.team_arena.team_arena_ask_2 = res/campaign/team_arena/team_arena_team_2.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_team_2.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	-- 申请列表
	self.Button_invite = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_invite"), nil,
	{
		terminal_name = "team_arena_ask1_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 解散
	self.Button_disband = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_disband"), nil,
	{
		terminal_name = "team_arena_team2_disband",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 提交
	self.Button_submit = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_submit"), nil,
	{
		terminal_name = "team_arena_team2_submit_pop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 邀请
	self.Button_ask = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ask"), nil,
	{
		terminal_name = "team_arena_ask2_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_team2_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Panel_leader = ccui.Helper:seekWidgetByName(root, "Panel_leader")


	self.Panel_player = {}

	-- 玩家1容器
	self.Panel_player_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_1")
	table.insert(self.Panel_player,self.Panel_player_1)
	-- 玩家2容器
	self.Panel_player_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_2")
	table.insert(self.Panel_player,self.Panel_player_2)

	-- 玩家3容器
	self.Panel_player_3 = ccui.Helper:seekWidgetByName(root, "Panel_player_3")
	table.insert(self.Panel_player,self.Panel_player_3)

	-- 队伍名称
	self.Text_team = ccui.Helper:seekWidgetByName(root, "Text_team")

	-- 队伍id
	self.Text_id_t = ccui.Helper:seekWidgetByName(root, "Text_id_t")

	-- 队伍战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")

	-- 申请按钮红点
	self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")


	self:onUpdateDraw()

	local state = tonumber(_ED.team_arena_team_status.state)
	if state == 3 then  --队长
		self:getApply()
	end
	
end

function TeamArenaTeam2:getApply()
	-- 玩家集结大厅状态
	local function team_arena_get_apply_infosCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onUpdateApplyRed()
			end
		end
	end
	protocol_command.team_arena_get_apply_infos.param_list = ""
	NetworkManager:register(protocol_command.team_arena_get_apply_infos.code, nil, nil, nil, self, team_arena_get_apply_infosCallback, false, nil)
end

function TeamArenaTeam2:onUpdateApplyRed()
	if #_ED.team_arena_get_apply_infos.applies > 0 then
		-- 申请按钮红点
		self.Image_red:setVisible(true)
	else
		self.Image_red:setVisible(false)
	end
end

function TeamArenaTeam2:onExit()
	-- 释放TeamArenaTeam2Window界面资源.
	state_machine.remove("team_arena_team2_open")
	state_machine.remove("team_arena_team2_close")
	state_machine.remove("team_arena_team2_show")
	state_machine.remove("team_arena_team2_hide")
	state_machine.remove("team_arena_team2_disband")
	state_machine.remove("team_arena_team2_submit")
	state_machine.remove("team_arena_team2_kick_out")
	state_machine.remove("team_arena_team2_submit_pop")
	state_machine.remove("team_arena_team2_ql_pop")
	state_machine.remove("team_arena_team2_turn")
	state_machine.remove("team_arena_team2_applyred")
	
	
end

function TeamArenaTeam2:close()
	-- window event : close.
	
end

function TeamArenaTeam2:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
