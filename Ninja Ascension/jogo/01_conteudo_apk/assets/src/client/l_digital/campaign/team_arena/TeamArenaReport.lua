--[[ ----------------------------------------------------------------------------
-- 战报界面
--]] ----------------------------------------------------------------------------
TeamArenaReport = class("TeamArenaReportClass", Window)

-- 打开窗口
local team_arena_report_window_open_terminal = {
	_name = "team_arena_report_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaReportClass") then
			fwin:open(TeamArenaReport:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_report_window_close_terminal = {
	_name = "team_arena_report_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaReportClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_report_window_open_terminal)
state_machine.add(team_arena_report_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaReport:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.campaign.team_arena.TeamArenaReportList")

	-- Initialize cross total war report page state machine.
	local function init_team_arena_report_terminal()
		-- 打开角色创建窗口
		local team_arena_report_open_terminal = {
			_name = "team_arena_report_open",
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
		local team_arena_report_close_terminal = {
			_name = "team_arena_report_close",
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
		local team_arena_report_show_terminal = {
			_name = "team_arena_report_show",
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
		local team_arena_report_hide_terminal = {
			_name = "team_arena_report_hide",
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

		state_machine.add(team_arena_report_open_terminal)
		state_machine.add(team_arena_report_close_terminal)
		state_machine.add(team_arena_report_show_terminal)
		state_machine.add(team_arena_report_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war report state machine.
	init_team_arena_report_terminal()
end

-- 对象初始化
function TeamArenaReport:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaReport:onUpdateDraw()
	local root = self.roots[1]

	-- _ED.team_arena_report = json.decode('{"count":2,"battleReport":[{"result":0,"type":0,"time":1585222626000,"integralChange":20,"serverNumber":9002,"teamId":"654982","teamName":"BBBB","combat":100000,"players":[{"userId":5011,"level":70,"nickName":"aa","combat":100000,"headPic":10001},{"userId":5011,"level":60,"nickName":"aaa","combat":200000,"headPic":10001},{"userId":5011,"level":60,"nickName":"aaaa","combat":200000,"headPic":10001}]},{"result":0,"type":1,"time":1585222626000,"integralChange":-20,"serverNumber":9001,"teamId":"654982","teamName":"BBBB","combat":100000,"players":[{"userId":5011,"level":70,"nickName":"aa","combat":100000,"headPic":10001},{"userId":5011,"level":60,"nickName":"aaa","combat":200000,"headPic":10001},{"userId":5011,"level":60,"nickName":"aaaa","combat":200000,"headPic":10001}]}]}')

	-- 战报列表
	self.ListView_zhanbao = ccui.Helper:seekWidgetByName(root, "ListView_zhanbao")
	self.ListView_zhanbao:removeAllItems()
	self.ListView_zhanbao:removeAllChildren(true)
	local myrank = nil
	for k,v in pairs(_ED.team_arena_report.battleReport) do
		local ele = {}
		ele.rank = k
		ele.data = v
		local cell = state_machine.excute("team_arena_report_list_create",0, ele)
		self.ListView_zhanbao:addChild(cell)
	end
	self.ListView_zhanbao:jumpToTop()
	self.ListView_zhanbao:refreshView()
	self.ListView_zhanbao_poy = self.ListView_zhanbao:getInnerContainer():getPositionY()

end

function TeamArenaReport:onEnterTransitionFinish()
	-- 加载TeamArenaReportWindow界面资源.
	-- res.campaign.team_arena.team_arena_report = res/campaign/team_arena/team_arena_report.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_report.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_report_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:initData()
end

function TeamArenaReport:initData()
	-- 初始信息
	local function team_arena_battle_report_listCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onUpdateDraw()
			end
		end
	end
	protocol_command.team_arena_battle_report_list.param_list = ""
	NetworkManager:register(protocol_command.team_arena_battle_report_list.code, nil, nil, nil, self, team_arena_battle_report_listCallback, false, nil)
end


-- @onUpdate(dt)
function TeamArenaReport:onUpdate(dt)
	
	if self.ListView_zhanbao ~= nil then
		local size = self.ListView_zhanbao:getContentSize()
		local posY = self.ListView_zhanbao:getInnerContainer():getPositionY()
		if self.ListView_zhanbao_poy == posY then
			return
		end
		self.ListView_zhanbao_poy = posY
		local items = self.ListView_zhanbao:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
					v:unload()		
			else	
					v:reload()				
			end
		end
	end
end

function TeamArenaReport:onExit()
	-- 释放TeamArenaReportWindow界面资源.
	state_machine.remove("team_arena_report_open")
	state_machine.remove("team_arena_report_close")
	state_machine.remove("team_arena_report_show")
	state_machine.remove("team_arena_report_hide")
end

function TeamArenaReport:close()
	-- window event : close.
	
end

function TeamArenaReport:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
