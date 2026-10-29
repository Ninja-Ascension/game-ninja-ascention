--[[ ----------------------------------------------------------------------------
-- 查看他人队伍信息
--]] ----------------------------------------------------------------------------
TeamArenaEnemy = class("TeamArenaEnemyClass", Window)

-- 打开窗口
local team_arena_enemy_window_open_terminal = {
	_name = "team_arena_enemy_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaEnemyClass") then
			fwin:open(TeamArenaEnemy:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_enemy_window_close_terminal = {
	_name = "team_arena_enemy_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaEnemyClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_enemy_window_open_terminal)
state_machine.add(team_arena_enemy_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaEnemy:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena enemy page state machine.
	local function init_team_arena_enemy_terminal()
		-- 打开角色创建窗口
		local team_arena_enemy_open_terminal = {
			_name = "team_arena_enemy_open",
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
		local team_arena_enemy_close_terminal = {
			_name = "team_arena_enemy_close",
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
		local team_arena_enemy_show_terminal = {
			_name = "team_arena_enemy_show",
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
		local team_arena_enemy_hide_terminal = {
			_name = "team_arena_enemy_hide",
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

		state_machine.add(team_arena_enemy_open_terminal)
		state_machine.add(team_arena_enemy_close_terminal)
		state_machine.add(team_arena_enemy_show_terminal)
		state_machine.add(team_arena_enemy_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena enemy state machine.
	init_team_arena_enemy_terminal()
end

-- 对象初始化
function TeamArenaEnemy:init(params)
	self.data = params
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end


function TeamArenaEnemy:onUpdateDraw()
	local root = self.roots[1]

	local serverNum = self.data.serverNum

	self.Text_craft:setString(self.data.combat)

	-- 玩家1头像
	local playerIconStr = nil
	local playerData = nil
	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")
	self.Panel_player_icon_1:removeAllChildren(true)

	if _ED.team_arena_team_info.players[1].headPic then 
		playerData = _ED.team_arena_team_info.players[1]
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		local sprit = cc.Sprite:create(playerIconStr)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(self.Panel_player_icon_1:getContentSize().width / 2, self.Panel_player_icon_1:getContentSize().height / 2))
		self.Panel_player_icon_1:addChild(sprit,0)

		local function func_showinfo(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				state_machine.excute("team_arena_player_info_show_window_open",0, {_ED.team_arena_team_info.players[1], serverNum})
			end
		end
		fwin:addTouchEventListener(self.Panel_player_icon_1, func_showinfo)
	else
		fwin:removeTouchEventListener(self.Panel_player_icon_1)
	end
	-- 玩家2头像
	self.Panel_player_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2")
	self.Panel_player_icon_2:removeAllChildren(true)
	if _ED.team_arena_team_info.players[2].headPic then 
		playerData = _ED.team_arena_team_info.players[2]
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		local sprit = cc.Sprite:create(playerIconStr)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(self.Panel_player_icon_2:getContentSize().width / 2, self.Panel_player_icon_2:getContentSize().height / 2))
		self.Panel_player_icon_2:addChild(sprit,0)

		local function func_showinfo(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				state_machine.excute("team_arena_player_info_show_window_open",0, {_ED.team_arena_team_info.players[2], serverNum})
			end
		end
		fwin:addTouchEventListener(self.Panel_player_icon_2, func_showinfo)
	else
		fwin:removeTouchEventListener(self.Panel_player_icon_2)
	end
	-- 玩家3头像
	self.Panel_player_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3")
	self.Panel_player_icon_3:removeAllChildren(true)
	if _ED.team_arena_team_info.players[3].headPic then 
		playerData = _ED.team_arena_team_info.players[3]
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		local sprit = cc.Sprite:create(playerIconStr)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(self.Panel_player_icon_3:getContentSize().width / 2, self.Panel_player_icon_3:getContentSize().height / 2))
		self.Panel_player_icon_3:addChild(sprit,0)

		local function func_showinfo(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				state_machine.excute("team_arena_player_info_show_window_open",0, {_ED.team_arena_team_info.players[3], serverNum})
			end
		end
		fwin:addTouchEventListener(self.Panel_player_icon_3, func_showinfo)
	else
		fwin:removeTouchEventListener(self.Panel_player_icon_3)
	end
	

	self:updateFormation()

end

function TeamArenaEnemy:updateFormation()

	-- 阵容展示
	-- debug.print_r(self.curformation,'self.curformation')
	for i=1,3 do
		if self.curformation[i] and self.curformation[i].formation then 
			for j,v in pairs(self.curformation[i].formation) do
				self.Panel_player_icon[i][j]:setVisible(true)
				self.Panel_player_icon[i][j]:removeAllChildren(true)
				if v.shipMould ~= nil then
					local data = {}
				
					data.ship_template_id = v.shipMould
					data.evolution_status = v.evolutionStatus
					data.skin_id = ""
					data.Order = v.qualityLevel
					data.ship_grade = v.level
					data.hero_fight = v.combatForce
					data.StarRating = v.starLevel

					local cell = state_machine.excute("team_arena_formation_icon_create", 0, {data, false, i})
					cell:setTag(100)
					self.Panel_player_icon[i][j]:addChild(cell)
					cell:setScale(0.8)
					local ct = self.Panel_player_icon[i][j]:getContentSize()
					cell:setPosition(ct.width/2,ct.height/2)
				end
			end
		else
			for m=1,6 do
				self.Panel_player_icon[i][m]:setVisible(false)
			end
		end
	end
end


function TeamArenaEnemy:onEnterTransitionFinish()
	-- 加载TeamArenaEnemyWindow界面资源.
	-- res.campaign.team_arena.team_arena_enemy = res/campaign/team_arena/team_arena_enemy.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_enemy.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)


	-- 队伍战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Panel_player_icon = {}
	for i=1,3 do
		local e = {}
		for j=1,6 do
			local a = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_"..i.."_"..j)
			table.insert(e,a)
		end
		table.insert(self.Panel_player_icon,e)
	end

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_enemy_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:initData()
end


function TeamArenaEnemy:initData()
	self.curformation = {}

	if _ED.team_arena_data ~=nil and  _ED.team_arena_data.myTeamInfo ~=nil and tonumber(_ED.team_arena_data.myTeamInfo.teamId) == tonumber(self.data.teamId)  then --自己的队伍
		local function team_arena_findCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				--debug.print_r(_ED.team_arena_team_info,"_ED.team_arena_team_info")
				self.curformation[1] = _ED.team_arena_team_info.players[1]
				self.curformation[2] = _ED.team_arena_team_info.players[2]
				self.curformation[3] = _ED.team_arena_team_info.players[3]
				self:onUpdateDraw()
			end
		end
		protocol_command.team_arena_find.param_list = self.data.teamId
		NetworkManager:register(protocol_command.team_arena_find.code, nil, nil, nil, self, team_arena_findCallback, false, nil)
	else 
		local function team_arena_team_info_getCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				self.curformation[1] = _ED.team_arena_team_info.players[1]
				self.curformation[2] = _ED.team_arena_team_info.players[2]
				self.curformation[3] = _ED.team_arena_team_info.players[3]
				self:onUpdateDraw()
			end
		end
		protocol_command.team_arena_team_info_get.param_list = self.data.teamId
		NetworkManager:register(protocol_command.team_arena_team_info_get.code, nil, nil, nil, self, team_arena_team_info_getCallback, false, nil)
	end
end

function TeamArenaEnemy:onExit()
	-- 释放TeamArenaEnemyWindow界面资源.
	state_machine.remove("team_arena_enemy_open")
	state_machine.remove("team_arena_enemy_close")
	state_machine.remove("team_arena_enemy_show")
	state_machine.remove("team_arena_enemy_hide")
end

function TeamArenaEnemy:close()
	-- window event : close.
	
end

function TeamArenaEnemy:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
