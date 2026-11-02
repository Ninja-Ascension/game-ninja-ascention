--[[ ----------------------------------------------------------------------------
-- 个人收到的邀请
--]] ----------------------------------------------------------------------------
TeamArenaAsk3 = class("TeamArenaAsk3Class", Window)

-- 打开窗口
local team_arena_ask3_window_open_terminal = {
	_name = "team_arena_ask3_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaAsk3Class") then
			fwin:open(TeamArenaAsk3:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_ask3_window_close_terminal = {
	_name = "team_arena_ask3_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaAsk3Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_ask3_window_open_terminal)
state_machine.add(team_arena_ask3_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaAsk3:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	
	app.load("client.l_digital.campaign.team_arena.teamarenaasklist3")

	-- Initialize team arena ask3 page state machine.
	local function init_team_arena_ask3_terminal()
		-- 打开角色创建窗口
		local team_arena_ask3_open_terminal = {
			_name = "team_arena_ask3_open",
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
		local team_arena_ask3_close_terminal = {
			_name = "team_arena_ask3_close",
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
		local team_arena_ask3_show_terminal = {
			_name = "team_arena_ask3_show",
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
		local team_arena_ask3_hide_terminal = {
			_name = "team_arena_ask3_hide",
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

		-- 删除
		local team_arena_ask3_handle_terminal = {
			_name = "team_arena_ask3_handle",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				local pos = tonumber(params._datas.pos)
				local type = tonumber(params._datas.type)
				if nil ~= instance then
					instance:request(type,pos)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(team_arena_ask3_handle_terminal)
		state_machine.add(team_arena_ask3_open_terminal)
		state_machine.add(team_arena_ask3_close_terminal)
		state_machine.add(team_arena_ask3_show_terminal)
		state_machine.add(team_arena_ask3_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena ask3 state machine.
	init_team_arena_ask3_terminal()
end

-- 对象初始化
function TeamArenaAsk3:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaAsk3:onUpdateDraw()
	local root = self.roots[1]

	-- 收到的申请数
	self.Text_ask_n = ccui.Helper:seekWidgetByName(root, "Text_ask_n")
	self.Text_ask_n:setString(#_ED.team_arena_get_invite_infos.invites)
	-- 申请列表容器
	self.ListView_ask = ccui.Helper:seekWidgetByName(root, "ListView_ask")

	-- 没有收到任何邀请（默认隐藏）
	self.Text_nothing = ccui.Helper:seekWidgetByName(root, "Text_nothing")
	-- {"invites":[{"teamName":"AAAA","teamId":1368462,"serverNum":2001,"players":[{"userId":10001,"level":80,"nickName":"啦","combat":500000,"headPic":10001}],"combat":500000,"joinLimit":10000}]}
	if _ED.team_arena_get_invite_infos.invites then
		self.Text_nothing:setVisible(false)
		self.ListView_ask:removeAllItems()
		self.ListView_ask:removeAllChildren(true)
		for k,v in pairs(_ED.team_arena_get_invite_infos.invites) do
			local cell = state_machine.excute("team_arena_ask_list3_create",0, {pos=k,data=v})
			self.ListView_ask:addChild(cell)
		end
		self.ListView_ask:jumpToTop()
		self.ListView_ask:refreshView()
	else
		self.Text_nothing:setVisible(true)
	end

end

function TeamArenaAsk3:request(type,pos)
	--type  (0 : 拒绝 1 : 接受 2 : 删除所有)
	local tp = tonumber(type)
	local function team_arena_handle_invite_infoCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				if tp == 1  then
					state_machine.excute("team_arena_ask3_window_close",0, "")
					state_machine.excute("team_arena_team2_window_close",0, "")
					state_machine.excute("team_arena_team1_window_close",0, "")
					state_machine.excute("team_arena_jijie",0, "")
					
				else
					response.node:initData()
				end
			end
		end
	end
	protocol_command.team_arena_handle_invite_info.param_list = pos.."\r\n"..type
	NetworkManager:register(protocol_command.team_arena_handle_invite_info.code, nil, nil, nil, self, team_arena_handle_invite_infoCallback, false, nil)
end
function TeamArenaAsk3:onEnterTransitionFinish()
	-- 加载TeamArenaAsk3Window界面资源.
	-- res.campaign.team_arena.team_arena_ask_3 = res/campaign/team_arena/team_arena_ask_3.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_ask_3.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 删除所有
	self.Button_delete = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_delete"), nil,
	{
		terminal_name = "team_arena_ask3_handle",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 2,
		pos = 0,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_ask3_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function TeamArenaAsk3:initData()
	-- 玩家集结大厅状态
	local function team_arena_get_invite_infosCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onUpdateDraw()
				state_machine.excute("team_arena_team1_invitered",0, "")
			end
		end
	end
	protocol_command.team_arena_get_invite_infos.param_list = ""
	NetworkManager:register(protocol_command.team_arena_get_invite_infos.code, nil, nil, nil, self, team_arena_get_invite_infosCallback, false, nil)
end
function TeamArenaAsk3:onExit()
	-- 释放TeamArenaAsk3Window界面资源.
	state_machine.remove("team_arena_ask3_open")
	state_machine.remove("team_arena_ask3_close")
	state_machine.remove("team_arena_ask3_show")
	state_machine.remove("team_arena_ask3_hide")
	state_machine.remove("team_arena_ask3_handle")
	
end

function TeamArenaAsk3:close()
	-- window event : close.
	
end

function TeamArenaAsk3:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
