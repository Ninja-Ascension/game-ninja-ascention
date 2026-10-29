--[[ ----------------------------------------------------------------------------
-- 组队前集结页面
--]] ----------------------------------------------------------------------------
TeamArenaTeam1 = class("TeamArenaTeam1Class", Window)

-- 打开窗口
local team_arena_team1_window_open_terminal = {
	_name = "team_arena_team1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaTeam1Class") then
			fwin:open(TeamArenaTeam1:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_team1_window_close_terminal = {
	_name = "team_arena_team1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaTeam1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_team1_window_open_terminal)
state_machine.add(team_arena_team1_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaTeam1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.joinlimit = 1 --(0 不判断  1 判断)

	-- load lua files.
	app.load("client.l_digital.campaign.team_arena.TeamArenaCreate")
	app.load("client.l_digital.campaign.team_arena.teamarenateamlist1")
	-- Initialize team arena team1 page state machine.
	local function init_team_arena_team1_terminal()
		-- 打开角色创建窗口
		local team_arena_team1_open_terminal = {
			_name = "team_arena_team1_open",
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
		local team_arena_team1_close_terminal = {
			_name = "team_arena_team1_close",
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
		local team_arena_team1_show_terminal = {
			_name = "team_arena_team1_show",
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
		local team_arena_team1_hide_terminal = {
			_name = "team_arena_team1_hide",
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

		-- 搜索队伍
		local team_arena_team1_search_terminal = {
			_name = "team_arena_team1_search",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local teamId = instance.TextField_team_id:getString()
					if teamId == nil or teamId == "" then 
						TipDlg.drawTextDailog(tipStringInfo_team_arena[7])
						return 
					end
					local function team_arena_applyCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if nil ~= response.node and nil ~= response.node.roots then
								TipDlg.drawTextDailog(tipStringInfo_team_arena[1])
							end
						end
					end
					protocol_command.team_arena_apply.param_list = teamId.."\r\n".."0"
					NetworkManager:register(protocol_command.team_arena_apply.code, nil, nil, nil, self, team_arena_applyCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新队伍
		local team_arena_team1_fresh_terminal = {
			_name = "team_arena_team1_fresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					-- 玩家集结大厅状态
					local function team_arena_enter_build_up_hallCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if nil ~= response.node and nil ~= response.node.roots then
								instance.joinlimit = 1
								instance:onUpdateDraw()
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

		-- 申请
		local team_arena_team1_invite_terminal = {
			_name = "team_arena_team1_invite",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
					local teamid = params._datas.teamid
					local function team_arena_applyCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if nil ~= response.node and nil ~= response.node.roots then
								TipDlg.drawTextDailog(tipStringInfo_team_arena[1])
							end
						end
					end
					protocol_command.team_arena_apply.param_list = teamid.."\r\n".."1"
					debug.print_r(protocol_command.team_arena_apply.param_list,"protocol_command.team_arena_apply.param_list")
					NetworkManager:register(protocol_command.team_arena_apply.code, nil, nil, nil, self, team_arena_applyCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		-- 刷新数据
		local team_arena_team1_invitered_terminal = {
			_name = "team_arena_team1_invitered",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateInviteRed()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(team_arena_team1_invitered_terminal)

		state_machine.add(team_arena_team1_invite_terminal)

		state_machine.add(team_arena_team1_fresh_terminal)
		state_machine.add(team_arena_team1_search_terminal)
		state_machine.add(team_arena_team1_open_terminal)
		state_machine.add(team_arena_team1_close_terminal)
		state_machine.add(team_arena_team1_show_terminal)
		state_machine.add(team_arena_team1_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena team1 state machine.
	init_team_arena_team1_terminal()
end

-- 对象初始化
function TeamArenaTeam1:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaTeam1:onUpdateDraw()
	local root = self.roots[1]

	self.ListView_team:removeAllItems()
	self.ListView_team:removeAllChildren(true)
	for k,v in pairs(_ED.team_arena_enter_build_up_hall_in.teams) do
		local cell = state_machine.excute("team_arena_team_list1_create",0, v)
		self.ListView_team:addChild(cell)
	end
	self.ListView_team:jumpToTop()
	self.ListView_team:refreshView()
end

function TeamArenaTeam1:onEnterTransitionFinish()
	-- 加载TeamArenaTeam1Window界面资源.
	-- res.campaign.team_arena.team_arena_ask_1 = res/campaign/team_arena/team_arena_team_1.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_team_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 申请
	self.Button_apply = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_apply"), nil,
	{
		terminal_name = "team_arena_team1_search",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 收到的邀请
	self.Button_invite = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_invite"), nil,
	{
		terminal_name = "team_arena_ask3_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 刷新
	self.Button_refresh = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh"), nil,
	{
		terminal_name = "team_arena_team1_fresh",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 创建队伍
	self.Button_create = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_create"), nil,
	{
		terminal_name = "team_arena_create_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_team1_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 队伍列表
	self.ListView_team = ccui.Helper:seekWidgetByName(root, "ListView_team")

	-- 队伍id输入框
	self.TextField_team_id = ccui.Helper:seekWidgetByName(root, "TextField_team_id")

	-- 我的邀请按钮红点
	self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")


	self:onUpdateDraw()
	self:getInvite()
end

function TeamArenaTeam1:getInvite()
	local function team_arena_get_invite_infosCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:updateInviteRed()
			end
		end
	end
	protocol_command.team_arena_get_invite_infos.param_list = ""
	NetworkManager:register(protocol_command.team_arena_get_invite_infos.code, nil, nil, nil, self, team_arena_get_invite_infosCallback, false, nil)
end

function TeamArenaTeam1:updateInviteRed()
	if #_ED.team_arena_get_invite_infos.invites>0 then
		self.Image_red:setVisible(true)
	else
		self.Image_red:setVisible(false)
	end
end

function TeamArenaTeam1:onExit()
	-- 释放TeamArenaTeam1Window界面资源.
	state_machine.remove("team_arena_team1_open")
	state_machine.remove("team_arena_team1_close")
	state_machine.remove("team_arena_team1_show")
	state_machine.remove("team_arena_team1_hide")
	state_machine.remove("team_arena_team1_search")
	state_machine.remove("team_arena_team1_fresh")
	state_machine.remove("team_arena_team1_invite")
	state_machine.remove("team_arena_team1_invitered")
	
end

function TeamArenaTeam1:close()
	-- window event : close.
	
end

function TeamArenaTeam1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
