--[[ ----------------------------------------------------------------------------
-- 战报list
--]] ----------------------------------------------------------------------------
TeamArenaReportList = class("TeamArenaReportListClass", Window)
TeamArenaReportList.__size = nil

-- 创建Cell实例
local team_arena_report_list_create_terminal = {
	_name = "team_arena_report_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if TeamArenaReportList then
			local cell = TeamArenaReportList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_report_list_create_terminal)
state_machine.init()

-- 构造器
function TeamArenaReportList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.battle.BattleStartEffect")

	-- Initialize cro cross total war report list page state machine.
	local function init_team_arena_report_list_terminal()
		
	end
	-- call func init cro cross total war report list state machine.
	init_team_arena_report_list_terminal()
end

-- 对象初始化
function TeamArenaReportList:init(params)
	self.reportData = params.data
	self.rank = params.rank
	if params.rank < 6 then
		self:onInit(params)
	end
	self:setContentSize(TeamArenaReportList.__size)
	return self
end

function TeamArenaReportList:onUpdateDraw()
	local root = self.roots[1]
--{"result":0,"type":1,"time":1585222626000,"integralChange":-20,"serverNumber":9001,"teamId":"654982","teamName":"BBBB","combat":100000,"players":[{"userId":5011,"level":70,"nickName":"aa","combat":100000,"headPic":10001},{"userId":5011,"level":60,"nickName":"aaa","combat":200000,"headPic":10001},{"userId":5011,"level":60,"nickName":"aaaa","combat":200000,"headPic":10001}]}

	--头像
	for j=1,3 do
		local hdata = self.reportData.players[j]
		local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_"..j)
		Panel_player_icon:removeAllChildren(true)
		local playerIconStr = nil
		if tonumber(hdata.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", hdata.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", hdata.headPic)
		end
		local sprit = cc.Sprite:create(playerIconStr)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
		Panel_player_icon:addChild(sprit,0)
	end

	self.Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")
	self.Text_name_lv:setString(self.reportData.teamName)

	self.Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
	self.Text_fighting_n:setString(self.reportData.combat)
	
	self.Text_server_n = ccui.Helper:seekWidgetByName(root, "Text_server_n")
	local num = GetServerNameByServerNumber(self.reportData.serverNumber)
	self.Text_server_n:setString(num)
	
	self.Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")

	local Image_win = ccui.Helper:seekWidgetByName(root, "Image_win")
	local Image_lose = ccui.Helper:seekWidgetByName(root, "Image_lose")

	local Image_up = ccui.Helper:seekWidgetByName(root, "Image_up")
	local Image_down = ccui.Helper:seekWidgetByName(root, "Image_down")

	if tonumber(self.reportData.result) == 0 then  --失败
		Image_lose:setVisible(true)
		Image_win:setVisible(false)
		Image_up:setVisible(false)
		Image_down:setVisible(true)
		self.Text_rank_n:setString(self.reportData.integralChange)
	else 
		Image_lose:setVisible(false)
		Image_win:setVisible(true)
		Image_up:setVisible(true)
		Image_down:setVisible(false)
		self.Text_rank_n:setString("+"..self.reportData.integralChange)
	end

	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	Text_time:setString(self:getDifferDay((_ED.system_time + (os.time() - _ED.native_time))-tonumber(self.reportData.time)/1000))
    
	
	-- 回放
	local function func_replay(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local fdata = self.reportData
			local rank = self.rank
			local function team_arena_check_battle_reportCallback(response)
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
					_ED.TeamArena_lose.name = fdata.teamName
					_ED.TeamArena_lose.integral = _ED.team_arena_attack_result.defendIntegral.."(".._ED.team_arena_attack_result.defendChange..")"
					_ED.TeamArena_lose.server = fdata.serverNumber
					_ED.TeamArena_lose.headPic = fdata.players[1].headPic

					if _ED.TeamArena_iswin == false then
						_ED.TeamArena_win.integral = _ED.team_arena_attack_result.attackIntegral.."(".._ED.team_arena_attack_result.attackChange..")"
						_ED.TeamArena_lose.integral = _ED.team_arena_attack_result.defendIntegral.."(+".._ED.team_arena_attack_result.defendChange..")"
					end

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
			protocol_command.team_arena_check_battle_report.param_list = rank
			NetworkManager:register(protocol_command.team_arena_check_battle_report.code, nil, nil, nil, self, team_arena_check_battle_reportCallback, false, nil)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_replay"):addTouchEventListener(func_replay)
	
	
end

function TeamArenaReportList:getDifferDay(times)
	local str = ""
	local hour = math.floor(tonumber(times)/3600)
	local mins = math.floor((tonumber(times)%3600)/60)
	local day = ""
	if times == 0 then
		str = _string_piece_info[290]
	elseif hour < 1 then
		str = mins .. _string_piece_info[289]
	elseif hour >= 1 and hour < 24 then
		str = hour .._string_piece_info[288]
	elseif hour >= 24 then
		day = math.ceil(hour / 24)
		str = day .._string_piece_info[291]
	end
	return str
end

function TeamArenaReportList:onEnterTransitionFinish()
	
end

function TeamArenaReportList:onInit(params)
	-- 加载TeamArenaReportListWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_role = res/campaign/cross_total_war/cross_total_war_report_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_report_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/team_arena/team_arena_report_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if TeamArenaReportList.__size == nil then
		TeamArenaReportList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function TeamArenaReportList:onExit()
	-- 释放TeamArenaReportListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/cross_total_war/cross_total_war_report_list.csb", root)
	-- ]]
end

function TeamArenaReportList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TeamArenaReportList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("campaign/cross_total_war/cross_total_war_report_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
