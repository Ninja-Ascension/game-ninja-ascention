--[[ ----------------------------------------------------------------------------
-- 玩家信息界面
--]] ----------------------------------------------------------------------------
TeamArenaInfo = class("TeamArenaInfoClass", Window)

-- 打开窗口
local team_arena_info_window_open_terminal = {
	_name = "team_arena_info_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaInfoClass") then
			fwin:open(TeamArenaInfo:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_info_window_close_terminal = {
	_name = "team_arena_info_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_info_window_open_terminal)
state_machine.add(team_arena_info_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cross total war enemy page state machine.
	local function init_team_arena_info_terminal()
		-- 打开角色创建窗口
		local team_arena_info_open_terminal = {
			_name = "team_arena_info_open",
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
		local team_arena_info_close_terminal = {
			_name = "team_arena_info_close",
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
		local team_arena_info_show_terminal = {
			_name = "team_arena_info_show",
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
		local team_arena_info_hide_terminal = {
			_name = "team_arena_info_hide",
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

		local team_arena_info_tuichu_terminal = {
			_name = "team_arena_info_tuichu",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local da = instance.data
					da.machine = "team_arena_team2_disband"
					da.type = 4
					state_machine.excute("team_arena_prpt_window_open",0,da)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		

		local team_arena_info_zhuanrang_terminal = {
			_name = "team_arena_info_zhuanrang",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local da = instance.data
					da.machine = "team_arena_team2_turn"
					da.type = 6
					state_machine.excute("team_arena_prpt_window_open",0, da)
		
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		
		local team_arena_info_qingli_terminal = {
			_name = "team_arena_info_qingli",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local da = instance.data
					da.machine = "team_arena_team2_kick_out"
					da.type = 3
					state_machine.excute("team_arena_prpt_window_open",0, da)
		
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(team_arena_info_tuichu_terminal)
		state_machine.add(team_arena_info_qingli_terminal)
		state_machine.add(team_arena_info_zhuanrang_terminal)
		state_machine.add(team_arena_info_open_terminal)
		state_machine.add(team_arena_info_close_terminal)
		state_machine.add(team_arena_info_show_terminal)
		state_machine.add(team_arena_info_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war enemy state machine.
	init_team_arena_info_terminal()
end

-- 对象初始化
function TeamArenaInfo:init(params)
	self.data = params
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaInfo:onUpdateDraw()
	local root = self.roots[1]

	self.Text_name:setString(self.data.playerInfo.nickName)


	local num = GetServerNameByServerNumber(_ED.team_arena_enter_build_up_hall_out.serverNum)
	self.Text_server_n:setString(num)

	self.Text_craft:setString(self.data.playerInfo.combat)

	self.Panel_lv:setVisible(true)
	self.Text_lv:setString("Lv." .. self.data.playerInfo.level)

	-- 头像
	local hdata = self.data.playerInfo
	local Panel_player = self.Panel_player
	Panel_player:removeAllChildren(true)
	local playerIconStr = nil
	if tonumber(hdata.headPic) >= 9 then
		playerIconStr = string.format("images/ui/props/props_%s.png", hdata.headPic)
	else
		playerIconStr = string.format("images/ui/home/head_%s.png", hdata.headPic)
	end
	local sprit = cc.Sprite:create(playerIconStr)
	sprit:setAnchorPoint(cc.p(0.5,0.5))
	sprit:setPosition(cc.p(Panel_player:getContentSize().width / 2, Panel_player:getContentSize().height / 2))
	Panel_player:addChild(sprit,0)

	self.Button_qingli:setVisible(false)
	self.Button_zhuanrang:setVisible(false)
	self.Button_tuichu:setVisible(false)

	local state = tonumber(_ED.team_arena_team_status.state)
	local playerid = tonumber(self.data.data)
	if (state == 2 and tonumber(playerid) == tonumber(_ED.user_info.user_id))  then  --队员 退出
		self.Button_qingli:setVisible(false)
		self.Button_zhuanrang:setVisible(false)
		self.Button_tuichu:setVisible(true)
	end

	if (state == 3 and tonumber(playerid) ~=  tonumber(_ED.user_info.user_id))  then  --队长 请离
		self.Button_qingli:setVisible(true)
		self.Button_zhuanrang:setVisible(true)
		self.Button_tuichu:setVisible(false)
	end

	self:updateFormation()

end


function TeamArenaInfo:updateFormation()
	
	-- 阵容展示
	local forma = self.data.playerInfo.formation
	for i=1,1 do
		if forma then 
			for j,v in pairs(forma) do
				self.Panel_player_icon[i][j]:removeAllChildren(true)
				if v.shipMould ~= nil then
					local data = {}
				
					data.ship_template_id = v.shipMould
					data.evolution_status = v.evolutionStatus
					data.skin_id = ""
					data.Order = v.qualityLevel
					data.ship_grade = v.level
					data.hero_fight = v.combat
					data.StarRating = v.starLevel

					local cell = state_machine.excute("team_arena_formation_icon_create", 0, {data, false, i})
					cell:setTag(100)
					self.Panel_player_icon[i][j]:addChild(cell)
					cell:setScale(0.8)
					local ct = self.Panel_player_icon[i][j]:getContentSize()
					cell:setPosition(ct.width/2,ct.height/2)
				end
			end
		end
	end

end

function TeamArenaInfo:onEnterTransitionFinish()
	-- 加载TeamArenaInfoWindow界面资源.
	-- res.campaign.cross_total_war.team_arena_info = res/campaign/cross_total_war/team_arena_information.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_information.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 玩家名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 玩家公会名
	-- self.Text_guild_n = ccui.Helper:seekWidgetByName(root, "Text_guild_n")

	-- 玩家服务器
	self.Text_server_n = ccui.Helper:seekWidgetByName(root, "Text_server_n")

	-- 战斗力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	
	-- 等级
	self.Panel_lv = ccui.Helper:seekWidgetByName(root, "Panel_lv")
	self.Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")

	self.Button_qingli = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qingli"), nil,
	{
		terminal_name = "team_arena_info_qingli",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Button_zhuanrang = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhuanrang"), nil,
	{
		terminal_name = "team_arena_info_zhuanrang",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Button_tuichu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuichu"), nil,
	{
		terminal_name = "team_arena_info_tuichu",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_info_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 自身1队角色1
	self.Panel_player_icon = {}
	for i=1,1 do
		local e = {}
		for j=1,6 do
			local a = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_"..i.."_"..j)
			table.insert(e,a)
		end
		table.insert(self.Panel_player_icon,e)
	end

	self:onUpdateDraw()
end

function TeamArenaInfo:onExit()
	-- 释放TeamArenaInfoWindow界面资源.
	state_machine.remove("team_arena_info_open")
	state_machine.remove("team_arena_info_close")
	state_machine.remove("team_arena_info_show")
	state_machine.remove("team_arena_info_hide")
	state_machine.remove("team_arena_info_tuichu")
	state_machine.remove("team_arena_info_zhuanrang")
	state_machine.remove("team_arena_info_qingli")
end

function TeamArenaInfo:close()
	-- window event : close.
	
end

function TeamArenaInfo:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
