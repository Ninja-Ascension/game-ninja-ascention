--[[ ----------------------------------------------------------------------------
-- 玩家信息界面
--]] ----------------------------------------------------------------------------
TeamArenaPlayerInfoShow = class("TeamArenaPlayerInfoShowClass", Window)

-- 打开窗口
local team_arena_player_info_show_window_open_terminal = {
	_name = "team_arena_player_info_show_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaPlayerInfoShowClass") then
			fwin:open(TeamArenaPlayerInfoShow:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_player_info_show_window_close_terminal = {
	_name = "team_arena_player_info_show_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaPlayerInfoShowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_player_info_show_window_open_terminal)
state_machine.add(team_arena_player_info_show_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaPlayerInfoShow:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cross total war enemy page state machine.
	local function init_team_arena_info_showterminal()
		-- 打开角色创建窗口
		local team_arena_info_showopen_terminal = {
			_name = "team_arena_info_showopen",
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
		local team_arena_info_showclose_terminal = {
			_name = "team_arena_info_showclose",
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
		local team_arena_info_showshow_terminal = {
			_name = "team_arena_info_showshow",
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
		local team_arena_info_showhide_terminal = {
			_name = "team_arena_info_showhide",
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

		state_machine.add(team_arena_info_showopen_terminal)
		state_machine.add(team_arena_info_showclose_terminal)
		state_machine.add(team_arena_info_showshow_terminal)
		state_machine.add(team_arena_info_showhide_terminal)
		state_machine.init()
	end
	-- call func init cross total war enemy state machine.
	init_team_arena_info_showterminal()
end

-- 对象初始化
function TeamArenaPlayerInfoShow:init(params)
	self.data = params[1]
	self.serverNum = params[2]
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaPlayerInfoShow:onUpdateDraw()
	local root = self.roots[1]

	self.Text_name:setString(self.data.nickName)

	local num = GetServerNameByServerNumber(self.serverNum)
	self.Text_server_n:setString(num)

	self.Text_craft:setString(self.data.combat)

	self.Panel_lv:setVisible(true)
	self.Text_lv:setString("Lv." .. self.data.level)

	-- 头像
	local hdata = self.data
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

	self:updateFormation()

end

function TeamArenaPlayerInfoShow:updateFormation()
	
	-- 阵容展示
	local forma = self.data.formation
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

function TeamArenaPlayerInfoShow:onEnterTransitionFinish()
	-- 加载TeamArenaPlayerInfoShowWindow界面资源.
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

	self.Button_qingli = ccui.Helper:seekWidgetByName(root, "Button_qingli")

	self.Button_zhuanrang = ccui.Helper:seekWidgetByName(root, "Button_zhuanrang")

	self.Button_tuichu = ccui.Helper:seekWidgetByName(root, "Button_tuichu")

	-- 战斗力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")


	-- 等级
	self.Panel_lv = ccui.Helper:seekWidgetByName(root, "Panel_lv")
	self.Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_player_info_show_window_close",
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

function TeamArenaPlayerInfoShow:onExit()
	-- 释放TeamArenaPlayerInfoShowWindow界面资源.
	state_machine.remove("team_arena_info_showopen")
	state_machine.remove("team_arena_info_showclose")
	state_machine.remove("team_arena_info_showshow")
	state_machine.remove("team_arena_info_showhide")
end

function TeamArenaPlayerInfoShow:close()
	-- window event : close.
	
end

function TeamArenaPlayerInfoShow:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
