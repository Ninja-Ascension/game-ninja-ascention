--[[ ----------------------------------------------------------------------------
-- 队长邀请好友
--]] ----------------------------------------------------------------------------
TeamArenaAsk2 = class("TeamArenaAsk2Class", Window)

-- 打开窗口
local team_arena_ask2_window_open_terminal = {
	_name = "team_arena_ask2_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaAsk2Class") then
			fwin:open(TeamArenaAsk2:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_ask2_window_close_terminal = {
	_name = "team_arena_ask2_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaAsk2Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_ask2_window_open_terminal)
state_machine.add(team_arena_ask2_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaAsk2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.campaign.team_arena.teamarenaasklist2")

	-- Initialize team arena ask2 page state machine.
	local function init_team_arena_ask2_terminal()
		-- 打开角色创建窗口
		local team_arena_ask2_open_terminal = {
			_name = "team_arena_ask2_open",
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
		local team_arena_ask2_close_terminal = {
			_name = "team_arena_ask2_close",
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
		local team_arena_ask2_show_terminal = {
			_name = "team_arena_ask2_show",
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
		local team_arena_ask2_hide_terminal = {
			_name = "team_arena_ask2_hide",
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

		-- 邀请
		local team_arena_ask2_invite_terminal = {
			_name = "team_arena_ask2_invite",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local userid = params._datas.userid
					local function team_arena_inviteCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if nil ~= response.node and nil ~= response.node.roots then
								TipDlg.drawTextDailog(tipStringInfo_team_arena[2])
								response.node:initData()
							end
						end
					end
					protocol_command.team_arena_invite.param_list = userid
					NetworkManager:register(protocol_command.team_arena_invite.code, nil, nil, nil, self, team_arena_inviteCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(team_arena_ask2_invite_terminal)
		state_machine.add(team_arena_ask2_open_terminal)
		state_machine.add(team_arena_ask2_close_terminal)
		state_machine.add(team_arena_ask2_show_terminal)
		state_machine.add(team_arena_ask2_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena ask2 state machine.
	init_team_arena_ask2_terminal()
end

-- 对象初始化
function TeamArenaAsk2:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaAsk2:onUpdateDraw()
	local root = self.roots[1]

	-- 好友邀请列表容器
	self.ListView_ask = ccui.Helper:seekWidgetByName(root, "ListView_ask")

	-- 没有好友（默认隐藏）
	self.Text_nothing = ccui.Helper:seekWidgetByName(root, "Text_nothing")

	if #_ED.team_arena_get_can_invite_users.canInvites > 0 then
		self.Text_nothing:setVisible(false)
		self.ListView_ask:removeAllItems()
		self.ListView_ask:removeAllChildren(true)
		for k,v in pairs(_ED.team_arena_get_can_invite_users.canInvites) do
			local cell = state_machine.excute("team_arena_ask_list2_create",0, v)
			self.ListView_ask:addChild(cell)
		end
		self.ListView_ask:jumpToTop()
		self.ListView_ask:refreshView()
	else 
		self.Text_nothing:setVisible(true)

	end

end

function TeamArenaAsk2:onEnterTransitionFinish()
	-- 加载TeamArenaAsk2Window界面资源.
	-- res.campaign.team_arena.team_arena_ask_2 = res/campaign/team_arena/team_arena_ask_2.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_ask_2.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_ask2_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	self:initData()

end

function TeamArenaAsk2:initData()
	--_ED.team_arena_get_can_invite_users = {"canInvites":[{"userId":5011,"level":70,"nickName":"aa","combat":100000,"headPic":10001,"formation":[{"evolutionStatus":"1|2,0,0,0","level":80,"shipMould":100,"combat":2000,"starLevel":4,"qualityLevel":5}]}]}
	local function team_arena_get_can_invite_usersCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				self:onUpdateDraw()
			end
		end
	end
	protocol_command.team_arena_get_can_invite_users.param_list = ""
	NetworkManager:register(protocol_command.team_arena_get_can_invite_users.code, nil, nil, nil, self, team_arena_get_can_invite_usersCallback, false, nil)

end

function TeamArenaAsk2:onExit()
	-- 释放TeamArenaAsk2Window界面资源.
	state_machine.remove("team_arena_ask2_open")
	state_machine.remove("team_arena_ask2_close")
	state_machine.remove("team_arena_ask2_show")
	state_machine.remove("team_arena_ask2_hide")
	state_machine.remove("team_arena_ask2_invite")

end

function TeamArenaAsk2:close()
	-- window event : close.
	
end

function TeamArenaAsk2:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
