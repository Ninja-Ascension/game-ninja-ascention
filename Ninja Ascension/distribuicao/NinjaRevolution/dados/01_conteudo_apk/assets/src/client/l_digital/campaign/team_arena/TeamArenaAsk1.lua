--[[ ----------------------------------------------------------------------------
-- 队长收到申请
--]] ----------------------------------------------------------------------------
TeamArenaAsk1 = class("TeamArenaAsk1Class", Window)

-- 打开窗口
local team_arena_ask1_window_open_terminal = {
	_name = "team_arena_ask1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaAsk1Class") then
			fwin:open(TeamArenaAsk1:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_ask1_window_close_terminal = {
	_name = "team_arena_ask1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaAsk1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_ask1_window_open_terminal)
state_machine.add(team_arena_ask1_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaAsk1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.campaign.team_arena.teamarenaasklist1")

	-- Initialize team arena ask1 page state machine.
	local function init_team_arena_ask1_terminal()
		-- 打开角色创建窗口
		local team_arena_ask1_open_terminal = {
			_name = "team_arena_ask1_open",
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
		local team_arena_ask1_close_terminal = {
			_name = "team_arena_ask1_close",
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
		local team_arena_ask1_show_terminal = {
			_name = "team_arena_ask1_show",
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
		local team_arena_ask1_hide_terminal = {
			_name = "team_arena_ask1_hide",
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
		local team_arena_ask1_handle_terminal = {
			_name = "team_arena_ask1_handle",
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

		state_machine.add(team_arena_ask1_handle_terminal)

		state_machine.add(team_arena_ask1_open_terminal)
		state_machine.add(team_arena_ask1_close_terminal)
		state_machine.add(team_arena_ask1_show_terminal)
		state_machine.add(team_arena_ask1_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena ask1 state machine.
	init_team_arena_ask1_terminal()
end

-- 对象初始化
function TeamArenaAsk1:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaAsk1:onUpdateDraw()
	local root = self.roots[1]
--_ED.team_arena_get_apply_infos = {"applies":[{"userId":5011,"level":70,"nickName":"aa","combat":100000,"headPic":10001,"formation":[{"evolutionStatus":"1|2,0,0,0","level":80,"shipMould":100,"combat":2000,"starLevel":4,"qualityLevel":5}]}]}

	-- 收到的申请数
	self.Text_ask_n = ccui.Helper:seekWidgetByName(root, "Text_ask_n")
	self.Text_ask_n:setString(#_ED.team_arena_get_apply_infos.applies)

	-- 申请列表容器
	self.ListView_ask = ccui.Helper:seekWidgetByName(root, "ListView_ask")

	-- 没有收到任何申请（默认隐藏）
	self.Text_nothing = ccui.Helper:seekWidgetByName(root, "Text_nothing")

	if _ED.team_arena_get_apply_infos.applies then
		self.Text_nothing:setVisible(false)
		self.ListView_ask:removeAllItems()
		self.ListView_ask:removeAllChildren(true)
		for k,v in pairs(_ED.team_arena_get_apply_infos.applies) do
			local cell = state_machine.excute("team_arena_ask_list1_create",0, {pos=k,data=v})
			self.ListView_ask:addChild(cell)
		end
		self.ListView_ask:jumpToTop()
		self.ListView_ask:refreshView()
	else
		self.Text_nothing:setVisible(true)
	end

end



function TeamArenaAsk1:request(type,pos)
	--type  (0 : 拒绝 1 : 接受 2 : 删除所有)
	local tp = tonumber(type)
	local function team_arena_handle_apply_infoCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				if tp == 1  then
					state_machine.excute("team_arena_ask1_window_close",0, "")
					state_machine.excute("team_arena_team2_window_close",0, "")
					state_machine.excute("team_arena_team1_window_close",0, "")
					state_machine.excute("team_arena_jijie",0, "")
					-- state_machine.excute("team_arena_team1_window_close",0, "")
				else
					response.node:initData()
				end
			end
		end
	end
	protocol_command.team_arena_handle_apply_info.param_list = pos.."\r\n"..type
	NetworkManager:register(protocol_command.team_arena_handle_apply_info.code, nil, nil, nil, self, team_arena_handle_apply_infoCallback, false, nil)
end

function TeamArenaAsk1:onEnterTransitionFinish()
	-- 加载TeamArenaAsk1Window界面资源.
	-- res.campaign.team_arena.team_arena_ask_1 = res/campaign/team_arena/team_arena_ask_1.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_ask_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 删除所有
	self.Button_delete = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_delete"), nil,
	{
		terminal_name = "team_arena_ask1_handle",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 2,
		pos = 0,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_ask1_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end


function TeamArenaAsk1:initData()
	-- 玩家集结大厅状态
	local function team_arena_get_apply_infosCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onUpdateDraw()
				state_machine.excute("team_arena_team2_applyred",0, "")
			end
		end
	end
	protocol_command.team_arena_get_apply_infos.param_list = ""
	NetworkManager:register(protocol_command.team_arena_get_apply_infos.code, nil, nil, nil, self, team_arena_get_apply_infosCallback, false, nil)
end

function TeamArenaAsk1:onExit()
	-- 释放TeamArenaAsk1Window界面资源.
	state_machine.remove("team_arena_ask1_open")
	state_machine.remove("team_arena_ask1_close")
	state_machine.remove("team_arena_ask1_show")
	state_machine.remove("team_arena_ask1_hide")
	state_machine.remove("team_arena_ask1_handle")

end

function TeamArenaAsk1:close()
	-- window event : close.
	
end

function TeamArenaAsk1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
