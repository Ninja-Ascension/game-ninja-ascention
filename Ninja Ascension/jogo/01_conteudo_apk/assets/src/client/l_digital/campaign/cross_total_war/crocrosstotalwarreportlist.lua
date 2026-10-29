--[[ ----------------------------------------------------------------------------
-- 战报list
--]] ----------------------------------------------------------------------------
CroCrossTotalWarReportList = class("CroCrossTotalWarReportListClass", Window)
CroCrossTotalWarReportList.__size = nil

-- 创建Cell实例
local cro_cross_total_war_report_list_create_terminal = {
	_name = "cro_cross_total_war_report_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CroCrossTotalWarReportList then
			local cell = CroCrossTotalWarReportList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cro_cross_total_war_report_list_create_terminal)
state_machine.init()

-- 构造器
function CroCrossTotalWarReportList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cro cross total war report list page state machine.
	local function init_cro_cross_total_war_report_list_terminal()
		
	end
	-- call func init cro cross total war report list state machine.
	init_cro_cross_total_war_report_list_terminal()
end

-- 对象初始化
function CroCrossTotalWarReportList:init(params)
	self.reportData = params.data
	self.rank = params.rank
	if params.rank < 6 then
		self:onInit(params)
	end
	self:setContentSize(CroCrossTotalWarReportList.__size)
	return self
end

function CroCrossTotalWarReportList:onUpdateDraw()
	local root = self.roots[1]
-- {"result":0,"userId":222,"nickName":"www","headPic":102101,"combatForce":200000,"serverNumber":9002}
-- [{"输赢结果(0失败 1胜利)":0,"玩家id":222,"昵称":"www","头像":14002,"战力":200000,"服务器编号":9002}
	self.Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")
	self.Text_name_lv:setString(self.reportData.nickName)

	self.Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
	self.Text_fighting_n:setString(self.reportData.combatForce)
	
	self.Text_server_n = ccui.Helper:seekWidgetByName(root, "Text_server_n")
	local num = GetServerNameByServerNumber(self.reportData.serverNumber)
	self.Text_server_n:setString(num)
	
	self.Text_point_n = ccui.Helper:seekWidgetByName(root, "Text_point_n")

	local Image_win = ccui.Helper:seekWidgetByName(root, "Image_win")
	local Image_lose = ccui.Helper:seekWidgetByName(root, "Image_lose")

	if tonumber(self.reportData.result) == 0 then  --失败
		Image_lose:setVisible(true)
		Image_win:setVisible(false)
		self.Text_point_n:setString(self.reportData.integralChange)
	else 
		Image_lose:setVisible(false)
		Image_win:setVisible(true)
		self.Text_point_n:setString("+"..self.reportData.integralChange)
	end

	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	Text_time:setString(self:getDifferDay((_ED.system_time + (os.time() - _ED.native_time))-tonumber(self.reportData.time)/1000))

	-- self.Text_point_n = ccui.Helper:seekWidgetByName(root, "Text_point_n")
	-- self.Text_point_n:setString(self.reportData.integralChange)
	
	--头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

    local quality_path = ""
    if tonumber(_ED.vip_grade) > 0 then
        quality_path = "images/ui/quality/player_1.png"
    else
        quality_path = "images/ui/quality/player_2.png"
    end
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(SpritKuang,0)

    local big_icon_path = ""
    local pic = tonumber(self.reportData.headPic)
    if pic >= 9 then
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    end
    local sprit = cc.Sprite:create(big_icon_path)
    sprit:setAnchorPoint(cc.p(0.5,0.5))
    sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
	Panel_player_icon:addChild(sprit,0)
	
	-- 回放
	local function func_replay(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local fdata = self.reportData
			local rank = self.rank
			local function cross_arena_check_battle_reportCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					-- if response.node == nil or response.node.roots == nil then
					-- 	return
					-- end
					if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
						_ED.user_is_level_up = true
						_ED.arena_is_level_up = true
						_ED.last_grade = _ED.user_info.last_user_grade
						_ED.last_food = _ED.user_info.last_user_food
						_ED.last_endurance = _ED.user_info.last_endurance			
					end
					-- 胜利了,记录当前.
					-- if tonumber(_ED.attackData.isWin) == 1 then
						
						-- 并且排名高过自己
						-- if tonumber(rank) < tonumber(self.heroQueue[self.userIndex].roleInstance.ranking) then
						-- 	response.node:writeCacheData(posIndex)
						-- end
		
					-- end
					-- 战斗结果处理

					for k,v in pairs(_ED.crossServerTotal_battleData) do
						v.battle_total_count = #_ED.crossServerTotal_battleData
					end

					_ED.crossServerTotal_round = #_ED.crossServerTotal_attackData
					_ED.crossServerTotal_iswin = true
					_ED.crossServerTotal_win = {}
					_ED.crossServerTotal_lose = {}
					local me = 0
					local en = 0
					for k,v in pairs(_ED.crossServerTotal_attackData) do
						
						if tonumber(v.isWin) == 1 then
							me = me+1
						else
							en = en+1
						end
					end
					if me > en then
						_ED.crossServerTotal_iswin = true
					else
						_ED.crossServerTotal_iswin = false
					end

					local battleData = _ED.crossServerTotal_battleData[1]
					if tostring(_ED.user_info.user_name) ~= tostring(battleData.attacker_name) then
						_ED.crossServerTotal_iswin = not _ED.crossServerTotal_iswin
						_ED.cross_arena_attack_result.attackChange = _ED.cross_arena_attack_result.attackChange * -1
						_ED.cross_arena_attack_result.defendChange = _ED.cross_arena_attack_result.defendChange * -1

						local attackIntegral = _ED.cross_arena_attack_result.attackIntegral
						local defendIntegral = _ED.cross_arena_attack_result.defendIntegral

						_ED.cross_arena_attack_result.attackIntegral = defendIntegral
						_ED.cross_arena_attack_result.defendIntegral = attackIntegral

						local tempMeScore = me
						local tempEnScore = en

						me = tempEnScore
						en = tempMeScore
					end

					_ED.crossServerTotal_win.score = me
					_ED.crossServerTotal_win.name = _ED.user_info.user_name
					_ED.crossServerTotal_win.integral = _ED.cross_arena_attack_result.attackIntegral.."(+".._ED.cross_arena_attack_result.attackChange..")"
					_ED.crossServerTotal_win.server = _ED.selected_server
					_ED.crossServerTotal_win.headPic = _ED.user_info.user_head
					
					
					_ED.crossServerTotal_lose.score = en
					_ED.crossServerTotal_lose.name = fdata.nickName
					_ED.crossServerTotal_lose.integral = _ED.cross_arena_attack_result.defendIntegral.."(".._ED.cross_arena_attack_result.defendChange..")"
					_ED.crossServerTotal_lose.server = fdata.serverNumber
					_ED.crossServerTotal_lose.headPic = fdata.headPic

					if _ED.crossServerTotal_iswin == false then
						_ED.crossServerTotal_win.integral = _ED.cross_arena_attack_result.attackIntegral.."(".._ED.cross_arena_attack_result.attackChange..")"
						_ED.crossServerTotal_lose.integral = _ED.cross_arena_attack_result.defendIntegral.."(+".._ED.cross_arena_attack_result.defendChange..")"
					end
					-- 回访标准
					_ED.crossServerTotalReplay = true

					-- 初始第一场的数据
					_ED.battleData = _ED.crossServerTotal_battleData[1]
					_ED.attackData = _ED.crossServerTotal_attackData[1]
					_ED.battleData._battle_start_influence_info = _ED.crossServerTotal_battle_start_influence_info[1]
					_ED.battleData._battle_round_influence_infos = _ED.crossServerTotal_battle_round_influence_infos[1]
					_ED.battleData._camp_change_influence_infos = _ED.crossServerTotal_start_influence_info[1]
					_ED.animalRoundData = _ED.crossServerTotal_animal_round_data[1]



					-- 记录三场的输赢情况
					_ED.cross_server_battel_result = {}
					table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)
					
					fwin:close(self.userInformationHeroStorage)
					fwin:cleanView(fwin._windows)
					fwin:freeAllMemeryPool()
					local bse = BattleStartEffect:new()
					bse:init(_enum_fight_type._fight_type_219)
					fwin:open(bse, fwin._windows)
				end
			end

			-- 清空跨服战的战斗数据缓存
			_ED.crossServerTotal_battleData = {}
			_ED.crossServerTotal_attackData = {}
			_ED.crossServerTotal_battle_start_influence_info = {}
			_ED.crossServerTotal_battle_round_influence_infos = {}
			_ED.crossServerTotal_start_influence_info = {}
			_ED.crossServerTotal_animal_round_data = {}

			-- local pos = tonumber(sender.fightpos)
			protocol_command.cross_arena_check_battle_report.param_list = rank
			NetworkManager:register(protocol_command.cross_arena_check_battle_report.code, nil, nil, nil, self, cross_arena_check_battle_reportCallback, false, nil)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Button_replay"):addTouchEventListener(func_replay)
	
	-- 复仇
	local function func_revenge(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local fdata = self.reportData
			local function cross_arena_challengeCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					-- if response.node == nil or response.node.roots == nil then
					-- 	return
					-- end
					if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
						_ED.user_is_level_up = true
						_ED.arena_is_level_up = true
						_ED.last_grade = _ED.user_info.last_user_grade
						_ED.last_food = _ED.user_info.last_user_food
						_ED.last_endurance = _ED.user_info.last_endurance			
					end
					-- 胜利了,记录当前.
					-- if tonumber(_ED.attackData.isWin) == 1 then
						
						-- 并且排名高过自己
						-- if tonumber(rank) < tonumber(self.heroQueue[self.userIndex].roleInstance.ranking) then
						-- 	response.node:writeCacheData(posIndex)
						-- end
		
					-- end
					-- 战斗结果处理

					for k,v in pairs(_ED.crossServerTotal_battleData) do
						v.battle_total_count = #_ED.crossServerTotal_battleData
					end

					_ED.crossServerTotal_round = #_ED.crossServerTotal_attackData
					_ED.crossServerTotal_iswin = true
					_ED.crossServerTotal_win = {}
					_ED.crossServerTotal_lose = {}
					local me = 0
					local en = 0
					for k,v in pairs(_ED.crossServerTotal_attackData) do
						
						if tonumber(v.isWin) == 1 then
							me = me+1
						else
							en = en+1
						end
					end
					if me > en then
						_ED.crossServerTotal_iswin = true
					else
						_ED.crossServerTotal_iswin = false
					end

					local battleData = _ED.crossServerTotal_battleData[1]
					if tostring(_ED.user_info.user_name) ~= tostring(battleData.attacker_name) then
						_ED.crossServerTotal_iswin = not _ED.crossServerTotal_iswin
						_ED.cross_arena_attack_result.attackChange = _ED.cross_arena_attack_result.attackChange * -1
						_ED.cross_arena_attack_result.defendChange = _ED.cross_arena_attack_result.defendChange * -1

						local attackIntegral = _ED.cross_arena_attack_result.attackIntegral
						local defendIntegral = _ED.cross_arena_attack_result.defendIntegral

						_ED.cross_arena_attack_result.attackIntegral = defendIntegral
						_ED.cross_arena_attack_result.defendIntegral = attackIntegral

						local tempMeScore = me
						local tempEnScore = en

						me = tempEnScore
						en = tempMeScore
					end
					
					_ED.crossServerTotal_win.score = me
					_ED.crossServerTotal_win.name = _ED.user_info.user_name
					_ED.crossServerTotal_win.integral = _ED.cross_arena_attack_result.attackIntegral.."(+".._ED.cross_arena_attack_result.attackChange..")"
					_ED.crossServerTotal_win.server = _ED.selected_server
					_ED.crossServerTotal_win.headPic = _ED.user_info.user_head
					
					
					_ED.crossServerTotal_lose.score = en
					_ED.crossServerTotal_lose.name = fdata.nickName
					_ED.crossServerTotal_lose.integral = _ED.cross_arena_attack_result.defendIntegral.."(".._ED.cross_arena_attack_result.defendChange..")"
					_ED.crossServerTotal_lose.server = fdata.serverNumber
					_ED.crossServerTotal_lose.headPic = fdata.headPic

					if _ED.crossServerTotal_iswin == false then
						_ED.crossServerTotal_win.integral = _ED.cross_arena_attack_result.attackIntegral.."(".._ED.cross_arena_attack_result.attackChange..")"
						_ED.crossServerTotal_lose.integral = _ED.cross_arena_attack_result.defendIntegral.."(+".._ED.cross_arena_attack_result.defendChange..")"
					end


					-- 初始第一场的数据
					_ED.battleData = _ED.crossServerTotal_battleData[1]
					_ED.attackData = _ED.crossServerTotal_attackData[1]
					_ED.battleData._battle_start_influence_info = _ED.crossServerTotal_battle_start_influence_info[1]
					_ED.battleData._battle_round_influence_infos = _ED.crossServerTotal_battle_round_influence_infos[1]
					_ED.battleData._camp_change_influence_infos = _ED.crossServerTotal_start_influence_info[1]
					_ED.animalRoundData = _ED.crossServerTotal_animal_round_data[1]					

					_ED.crossServerTotalReplay = false
					-- 记录三场的输赢情况
					_ED.cross_server_battel_result = {}
					table.insert(_ED.cross_server_battel_result, _ED.attackData.isWin)
					
					fwin:close(self.userInformationHeroStorage)
					fwin:cleanView(fwin._windows)
					fwin:freeAllMemeryPool()
					local bse = BattleStartEffect:new()
					bse:init(_enum_fight_type._fight_type_219)
					fwin:open(bse, fwin._windows)
				end
			end

			-- 清空跨服战的战斗数据缓存
			_ED.crossServerTotal_battleData = {}
			_ED.crossServerTotal_attackData = {}
			_ED.crossServerTotal_battle_start_influence_info = {}
			_ED.crossServerTotal_battle_round_influence_infos = {}
			_ED.crossServerTotal_start_influence_info = {}
			_ED.crossServerTotal_animal_round_data = {}

			-- local pos = tonumber(sender.fightpos)
			protocol_command.cross_arena_challenge.param_list = fdata.singletonId
			NetworkManager:register(protocol_command.cross_arena_challenge.code, nil, nil, nil, self, cross_arena_challengeCallback, false, nil)
		end
	end
	local Button_revenge = ccui.Helper:seekWidgetByName(root, "Button_revenge")
	Button_revenge:addTouchEventListener(func_revenge)

	if tonumber(self.reportData.result) == 0 and  tonumber(self.reportData.result) == 1  then
		Button_revenge:setVisible(true)
	else
		Button_revenge:setVisible(false)
	end

	

	
end

function CroCrossTotalWarReportList:getDifferDay(times)
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

function CroCrossTotalWarReportList:onEnterTransitionFinish()
	
end

function CroCrossTotalWarReportList:onInit(params)
	-- 加载CroCrossTotalWarReportListWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_role = res/campaign/cross_total_war/cross_total_war_report_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_report_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/cross_total_war/cross_total_war_report_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CroCrossTotalWarReportList.__size == nil then
		CroCrossTotalWarReportList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CroCrossTotalWarReportList:onExit()
	-- 释放CroCrossTotalWarReportListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/cross_total_war/cross_total_war_report_list.csb", root)
	-- ]]
end

function CroCrossTotalWarReportList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CroCrossTotalWarReportList:unload()
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
