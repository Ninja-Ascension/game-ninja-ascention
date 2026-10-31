-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场对手控件
-- 创建时间：20170721
-- 作者：李文鋆
-------------------------------------------------------------------------------------------------------

ArenaLadderSeatCell = class("ArenaLadderSeatCellClass", Window)
ArenaLadderSeatCell.__size = nil
function ArenaLadderSeatCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._armature = nil
	
    -- Initialize ArenaLadderSeatCell page state machine.
    local function init_arena_ladder_seat_terminal()

		local arena_ladder_seat_cell_fight_sm_terminal = {
            _name = "arena_ladder_seat_cell_fight_sm",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if tonumber(_ED.arena_user_remain) <= 0 then
            		TipDlg.drawTextDailog(_new_interface_text[178])
            		return
            	end
            	if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
			        protocol_command.education_change.param_list = "509"
			        if nil ~= _ED.user_info.user_id and "" ~= _ED.user_info.user_id then
			            NetworkManager:register(protocol_command.education_change.code, nil, nil, nil, nil, nil, false, nil)
			        end
			    end
            	local cells = params._datas.cell
            	instance:requestArenaFightDatas(cells.roleInstance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_ladder_seat_cell_worship_terminal = {
            _name = "arena_ladder_seat_cell_worship",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cells = params._datas.cell
            	local function responseArenaWorshipCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
							return
						end
						for i, v in pairs(_ED.arena_challenge) do
							if tonumber(v.rank) == tonumber(response.node.roleInstance.rank) then
								response.node.roleInstance = v
							end
						end
						response.node:initDraw()
						local rewardList = getSceneReward(14)
						local number = 0
						for i=1, tonumber(rewardList.show_reward_item_count) do
							if tonumber(rewardList.show_reward_list[i].prop_type) == 1 then
								number = tonumber(rewardList.show_reward_list[i].item_value)
								break
							end
						end
						TipDlg.drawTextDailog(string.format(_new_interface_text[41],zstring.tonumber(number)))
					end
				end
				
				protocol_command.arena_worship.param_list = "0".."\r\n".."0".."\r\n"..cells.roleInstance.rank
				NetworkManager:register(protocol_command.arena_worship.code, nil, nil, nil, cells, responseArenaWorshipCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_ladder_seat_cell_show_info_terminal = {
            _name = "arena_ladder_seat_cell_show_info",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cells = params._datas.cell
				-- DSC统一玩家详情界面
				if __lua_project_id == __lua_project_l_digital then
					local userID = tonumber(cells.roleInstance.id)
					local robotData = cells:getRobotData(cells.roleInstance)
					OpenOtherUserInformation(userID, robotData, nil)
				else
					state_machine.excute("sm_arena_player_info_window_open",0,cells.roleInstance)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
		local arena_ladder_seat_cell_fight_sm_five_terminal = {
            _name = "arena_ladder_seat_cell_fight_sm_five",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if funOpenDrawTip(172) == true then
		            return
		        end
            	local cells = params._datas.cell
            	local haveTimes = tonumber(_ED.arena_user_remain)
			    local totalCost = 0
			    local buyTimes = zstring.tonumber(_ED.arena_user_change_times_buy_times)
			    local buyTimesCost = zstring.split(dms.string(dms["arena_config"], 3, pirates_config.param), ",")
			    local cleanCDGold = dms.int(dms["arena_config"], 5, pirates_config.param)
			    local cdTime = _ED.user_launch_battle_cd / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
			    for i=1,5 do
			        if cdTime > 0 then
			            totalCost = totalCost + cleanCDGold
			            cdTime = 0
			        end
			        if haveTimes <= 0 then
			            if buyTimes >= #buyTimesCost then
			                buyTimes = #buyTimesCost
			            else
			                buyTimes = buyTimes + 1
			            end
			            totalCost = totalCost + zstring.tonumber(buyTimesCost[buyTimes])
			        else
			            haveTimes = haveTimes - 1
			            if haveTimes > 0 then
			        		cdTime = 100
			        	end
			        end
			    end
            	local currentGold = zstring.tonumber(_ED.user_info.user_gold)
                if totalCost > currentGold then
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = _string_piece_info[273], 
                        _datas= 
                        {

                        }
                    })
            		return
            	end
            	local roleInfo = cells.roleInstance
            	local function respondCallback( response )
            		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            			state_machine.excute("arena_update_times_info", 0, nil)
            			state_machine.excute("arena_five_time_result_window_open", 0, {roleInfo})
            		end
            	end
            	protocol_command.arena_sweep.param_list = roleInfo.rank .. "\r\n5"
				NetworkManager:register(protocol_command.arena_sweep.code, nil, nil, nil, cells, respondCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(arena_ladder_seat_cell_fight_sm_terminal)
		state_machine.add(arena_ladder_seat_cell_worship_terminal)
		state_machine.add(arena_ladder_seat_cell_show_info_terminal)
		state_machine.add(arena_ladder_seat_cell_fight_sm_five_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ladder_seat_terminal()
end

-- 初始化机器人数据
function ArenaLadderSeatCell:getRobotData(roleInstance)
	local info = {}
	info.user_id = -1
	info.army = ""
	info.name = roleInstance.name
	info.vip_grade = 0
	info.lead_mould_id = roleInstance.icon
	info.grade = roleInstance.level
	info.fighting = roleInstance.force
	info.headFrameID = -1
	info.headFrameStage = -1
	info.formation = roleInstance.template[1]
	info.imageID = dms.int(dms["user_config"], 23, user_config.param)

	return info
end

function ArenaLadderSeatCell:updateFiveTimesInfo( ... )

	local root = self.roots[1]
	local role = self.roleInstance
	local min_rank = dms.int(dms["arena_config"], 17, arena_config.param)
	local lessRank = dms.int(dms["arena_config"], 19, pirates_config.param)
	local Panel_z5 = ccui.Helper:seekWidgetByName(root, "Panel_z5")
	local Button_tiaozhan = ccui.Helper:seekWidgetByName(root, "Button_tiaozhan")
	local Button_mobai = ccui.Helper:seekWidgetByName(root, "Button_mobai")
	if root ~= nil then
		Button_tiaozhan:setVisible(false)
	    -- Button_tiaozhan:setTouchEnabled(true)
	    -- Button_tiaozhan:setBright(true)
		Button_mobai:setVisible(false)
		Button_mobai:setTouchEnabled(true)
		Button_mobai:setBright(true)
		Panel_z5:setVisible(false)

		if tonumber(_ED.user_info.user_id) == tonumber(role.id) then
		else
			if self.index <= 10 then
				if tonumber(_ED.user_arena_worship_state[role.arena_id]) == tonumber(role.arena_id) then
					if tonumber(_ED.arena_user_rank) < tonumber(self.roleInstance.rank) then
						Panel_z5:setVisible(true)
					elseif tonumber(_ED.arena_user_rank) > tonumber(self.roleInstance.rank)
						and tonumber(_ED.arena_user_rank) <= min_rank
						then
						Button_tiaozhan:setVisible(true)
					else
						Button_mobai:setVisible(true)
						Button_mobai:setTouchEnabled(false)
						Button_mobai:setBright(false)
					end
				else
					if _ED.user_worship_number >= 10 then
						--我没有膜拜次数了
						if tonumber(_ED.arena_user_rank) <= min_rank then
							--如果是我可以打的
							Button_tiaozhan:setVisible(true)
						else
							Button_mobai:setVisible(true)
							Button_mobai:setTouchEnabled(false)
							Button_mobai:setBright(false)
						end
					else
						Button_mobai:setVisible(true)
					end
				end
			else
				if tonumber(_ED.arena_user_rank) <= lessRank and tonumber(_ED.arena_user_rank) < tonumber(self.roleInstance.rank) then
					Panel_z5:setVisible(true)
				else
					Button_tiaozhan:setVisible(true)
				end
			end
		end
	end

	if root ~= nil then
		local Text_z5_0 = ccui.Helper:seekWidgetByName(root, "Text_z5_0")
		local haveTimes = tonumber(_ED.arena_user_remain)
	    local totalCost = 0
	    local buyTimes = zstring.tonumber(_ED.arena_user_change_times_buy_times)
	    local buyTimesCost = zstring.split(dms.string(dms["arena_config"], 3, pirates_config.param), ",")
	    local cleanCDGold = dms.int(dms["arena_config"], 5, pirates_config.param)
	    local cdTime = _ED.user_launch_battle_cd / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
	    for i=1,5 do
	        if cdTime > 0 then
	            totalCost = totalCost + cleanCDGold
	            cdTime = 0
	        end
	        if haveTimes <= 0 then
	            if buyTimes >= #buyTimesCost then
	                buyTimes = #buyTimesCost
	            else
	                buyTimes = buyTimes + 1
	            end
	            totalCost = totalCost + zstring.tonumber(buyTimesCost[buyTimes])
	        else
	            haveTimes = haveTimes - 1
	            if haveTimes > 0 then
	        		cdTime = 100
	        	end
	        end
	    end
	    Text_z5_0:setString(totalCost)
	end
end

function ArenaLadderSeatCell:requestArenaFightDatas(opponentSeat)
	local rank = opponentSeat.rank
	-- local posIndex = opponentSeat.posIndex
	
	---[[
	--DOTO 战斗请求
	local function requestArenaFightDatasCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--> print("数据回来了 啦啦啦啦。。。战斗结果是：", _ED.attackData.isWin)
			if response.node == nil or response.node.roots == nil then
				return
			end
			if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
				_ED.user_is_level_up = true
				_ED.arena_is_level_up = true
				_ED.last_grade = _ED.user_info.last_user_grade
				_ED.last_food = _ED.user_info.last_user_food
				_ED.last_endurance = _ED.user_info.last_endurance			
			end
			-- 胜利了,记录当前.
			if tonumber(_ED.attackData.isWin) == 1 then
				
				-- 并且排名高过自己
				-- if tonumber(rank) < tonumber(self.heroQueue[self.userIndex].roleInstance.rank) then
				-- 	response.node:writeCacheData(posIndex)
				-- end

			end
			
			fwin:close(self.userInformationHeroStorage)
			fwin:cleanView(fwin._windows)
			fwin:freeAllMemeryPool()
			local bse = BattleStartEffect:new()
			bse:init(_enum_fight_type._fight_type_11)
			fwin:open(bse, fwin._windows)
		end
	end

	-- NinjaAscension: the server sends the defender's formation (15980) and the
	-- fight runs in the client's original battle engine (FightModule), like PVE.
	local function nrArenaCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and _ED.nr_arena_defender then
			if false then
				return
			end
			if not nrArenaPrepareFight(_ED.nr_arena_defender) then
				return
			end
			fwin:close(self.userInformationHeroStorage)
			fwin:cleanView(fwin._windows)
			fwin:freeAllMemeryPool()
			local bse = BattleStartEffect:new()
			-- Type 0 (normal stage) runs the live engine; type 11 only plays a server report.
			bse:init(_enum_fight_type._fight_type_0)
			fwin:open(bse, fwin._windows)
		end
	end
	_ED.nr_arena_defender = nil
	protocol_command.arena_launch.param_list = rank .. "\r\n0"
	NetworkManager:register(protocol_command.arena_launch.code, nil, nil, nil, self, nrArenaCallback, false, nil)
end

-- Defender formation from the server (arena_local.py defender_info).
if NetworkProtocol and not NetworkProtocol.find_parser(15980) then
	table.insert(NetworkProtocol.protocol_parses, {code = 15980, parser = "nr_arena_defender", parser_fun = function(_, _, _, _, list)
		_ED.nr_arena_defender = json.decode(npos(list))
	end})
end

-- Our formation (as in PVE) against the defender's ninjas, created with the
-- same FightObject:initWithUserData the engine uses for our side.
function nrArenaPrepareFight(defender)
	app.load("client.battle.report.BattleReport")
	local ok, err = xpcall(function()
		_ED._fightModule = FightModule:new()
		local fm = _ED._fightModule
		local npc = {id = 0, formationCount = 0, npcName = defender.name}
		local resultBuffer = {}
		fm:initBattleField(npc, 1, _enum_fight_type._fight_type_0, resultBuffer, nil, false)
		local battleCache = _ED.user_info.battleCache
		local enemies = {}
		-- initWithUserData looks the ninja up in _ED.user_ship (mega skills,
		-- skin): register the defender ninjas only while they are built.
		for _, ship in ipairs(defender.ships) do
			_ED.user_ship[ship.ship_id] = ship
		end
		local okBuild, errBuild = xpcall(function()
			for _, ship in ipairs(defender.ships) do
				local obj = FightObject:new()
				obj:initWithUserData(ship.pos, ship, 1, defender.uid, fm)
				enemies[ship.pos] = obj
			end
		end, debug.traceback)
		for _, ship in ipairs(defender.ships) do
			_ED.user_ship[ship.ship_id] = nil
		end
		if not okBuild then error(errBuild) end
		battleCache.byAttackerObjectsList = {enemies}
		battleCache.maxBattleCount = 1
		battleCache.byAttackName = defender.name
		battleCache.defender_name = defender.name
		battleCache.byAttackComobatForce = defender.power
		battleCache.byAttackerId = defender.uid
		-- Arena look in the fight UI (names, speed, arena layout): battle_init_type 11.
		battleCache.battleType = _enum_fight_type._fight_type_11
		local defenderSpeed = 0
		for _, ship in ipairs(defender.ships) do defenderSpeed = defenderSpeed + (tonumber(ship.ship_wisdom) or 0) end
		-- Arena speed is the whole account's team speed (server: ranking_local.team_speed).
		battleCache.defender_priority = tonumber(defender.speed) or defenderSpeed
		battleCache.attacker_name = _ED.user_info.user_name
		battleCache.defender_head_pic = defender.head or 0
		fm:writeBattleFieldInit(battleCache, 0, 1, resultBuffer)
		table.insert(resultBuffer, 1, 100)
		table.insert(resultBuffer, 2, IniUtil.enter)
		table.insert(resultBuffer, 3, "battle_field_init")
		table.insert(resultBuffer, 4, IniUtil.enter)
		table.insert(resultBuffer, 5, "0")
		table.insert(resultBuffer, 6, IniUtil.enter)
		NetworkProtocol.parser_func({resouce = table.concat(resultBuffer, "")})
		_ED.attackData = {roundCount = fm.totalRound, roundData = {}}
		_ED.attackData.isWin = fm.result
		fm:initFightOrder(_ED.user_info, {})
		_ED.nr_arena_fight_rank = defender.rank
		_ED.nr_arena_fight_match_id = defender.matchId
		_ED.nr_arena_defender_name = defender.name
		_ED.arena_battle_data = defender.battle_data
		_ED.nr_arena_fight_active = true
		_ED.nr_arena_defender_speed = tonumber(defender.speed)
	end, debug.traceback)
	if not ok then
		print("NR_ARENA prepare failed: " .. tostring(err))
		if __G__TRACKBACK__ then pcall(__G__TRACKBACK__, "NR_ARENA prepare failed: " .. tostring(err)) end
		TipDlg.drawTextDailog("Arena: " .. tostring(err))
		return false
	end
	return true
end


function ArenaLadderSeatCell:getNewHeadIcon()
    local headIconInfo = {
        headFrameID = self.roleInstance.headFrameID,
        headFrameStage = self.roleInstance.headFrameStage,
        headID = self.roleInstance.icon,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function ArenaLadderSeatCell:addHeroAnimaton()
	local root = self.roots[1]
	self.roleIconPanel:removeAllChildren(true)
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		-- 新增头像框
		local headIcon = self:getNewHeadIcon()
		self.roleIconPanel:addChild(headIcon)
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		self.roleIconPanel:removeBackGroundImage()
		local playerIconStr = nil
		if tonumber(self.roleInstance.icon) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", self.roleInstance.icon)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", self.roleInstance.icon)
		end
		self.roleIconPanel:setBackGroundImage(playerIconStr)
	else
		--模板id:等级:进阶数据:星级:品阶:战力!后面的战船
		local role = self.roleInstance

		if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			self._armature = nil
		end

		--所有的船
		local shipAllData = zstring.split(role.template[1], "!")
		local SelectedId = 0		--战力最大的船的位置
		local fightId = -9999
		for i, v in pairs(shipAllData) do
			local shipData = zstring.split(v, ":")
			if tonumber(shipData[6]) > fightId then
				SelectedId = i
				fightId = tonumber(shipData[6])
			end
		end
		--模板id:等级:进阶数据:星级:品阶:战力:皮肤ID
		local selectedShip = zstring.split(shipAllData[SelectedId], ":")

		--进化形象
		local evo_image = dms.string(dms["ship_mould"], tonumber(selectedShip[1]), ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(selectedShip[3], "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]

		if zstring.tonumber(selectedShip[7]) ~= 0 then
	    	evo_mould_id = dms.int(dms["ship_skin_mould"], selectedShip[7], ship_skin_mould.ship_evo_id)
	    end
		--新的形象编号
		local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

		self.roleIconPanel:removeAllChildren(true)
		-- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), self.roleIconPanel, nil, nil, cc.p(0.5, 0))

		--画光圈
		local camp_preference = dms.int(dms["ship_mould"], tonumber(selectedShip[1]), ship_mould.camp_preference)
		local animation_name = ""
		if camp_preference == 1 then    		--攻击
			animation_name = "type_1"
		elseif camp_preference == 2 then 		--防御
			animation_name = "type_2"
		elseif camp_preference == 3 then 		--技能
			animation_name = "type_3"
		end
		local jsonFile = "sprite/spirte_type_di.json"
	    local atlasFile = "sprite/spirte_type_di.atlas"
	    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
	    animation2:setPosition(cc.p(self.roleIconPanel:getContentSize().width/2,0))
	 		self.roleIconPanel:addChild(animation2)
	    

		self:runAction(cc.Sequence:create({cc.DelayTime:create((math.abs(self.index-#_ED.arena_challenge))*0.05), cc.CallFunc:create(function ( sender )
			app.load("client.battle.fight.FightEnum")
			if self._armature == nil then
				self._armature = sp.spine_sprite(self.roleIconPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
				if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
			        self.roleIconPanel:removeAllChildren(true)
			        self.roleIconPanel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", temp_bust_index))
			        self.roleIconPanel:setScale(0.5)
			        self.roleIconPanel:setPosition(70,200)
                end 
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self._armature:setScaleX(-1)
				end
			end
		end)}))

		local pokemon_high_param = dms.searchs(dms["role_high"], pokemon_high.hero_fight_state_id, tonumber(temp_bust_index))
	    --宝可梦单独调整
	    if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and pokemon_high_param then
	    	self.roleIconPanel:setScale(tonumber(pokemon_high_param[1][4]))
	    end
	end
	
end

function ArenaLadderSeatCell:initDraw()

	local root = self.roots[1]
	local role = self.roleInstance
	if root == nil then
        return
    end

	--画角色的
	self.roleIconPanel = ccui.Helper:seekWidgetByName(root, "Panel_role")
	self.roleIconPanel:removeBackGroundImage()
	
	--排名
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2") 
	local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n") 
	Text_2:setString(role.rank)
	Text_rank_n:setString(role.rank)
	--玩家名称
	local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
	Text_role_name:setString(role.name)
	--被膜拜次数
	local Text_mbcs = ccui.Helper:seekWidgetByName(root, "Text_mbcs")
	Text_mbcs:setString(role.worship_value)
	--玩家战力
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	Text_5:setString(role.force)
	--挑战按钮
	local Button_tiaozhan = ccui.Helper:seekWidgetByName(root, "Button_tiaozhan")

	--膜拜按钮
	local Button_mobai = ccui.Helper:seekWidgetByName(root, "Button_mobai")
	local Image_bmb = ccui.Helper:seekWidgetByName(root, "Image_bmb")
	local Text_mbcs = ccui.Helper:seekWidgetByName(root, "Text_mbcs")
	local Image_rank = ccui.Helper:seekWidgetByName(root, "Image_rank")
	local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")

	Button_tiaozhan:setVisible(false)
	Button_tiaozhan:setTouchEnabled(true)
	Button_tiaozhan:setBright(true)
	Button_mobai:setVisible(false)
	Image_bmb:setVisible(false)
	Text_mbcs:setVisible(false)
	Image_rank:setVisible(false)
	Text_rank_n:setVisible(false)	

	local min_rank = dms.int(dms["arena_config"], 17, arena_config.param) 		-- 可挑战前10名的最小名次
	if tonumber(_ED.user_info.user_id) == tonumber(role.id) then
	else
		if self.index <= 10 then
			if tonumber(_ED.user_arena_worship_state[role.arena_id]) == tonumber(role.arena_id) then
				Button_tiaozhan:setVisible(true)
			else
				if _ED.user_worship_number >= 10 then
					Button_tiaozhan:setVisible(true)
				else
					Button_mobai:setVisible(true)
				end
			end
			if tonumber(_ED.arena_user_rank) > min_rank then
				Button_tiaozhan:setTouchEnabled(false)
				Button_tiaozhan:setBright(false)
			end
		else
			Button_tiaozhan:setVisible(true)
		end
	end

	if self.index <= 10 then
		Image_bmb:setVisible(true)
		Text_mbcs:setVisible(true)
	else
		Image_rank:setVisible(true)
		Text_rank_n:setVisible(true)
	end

	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		Text_2:setVisible(self.index > 3)
	end

	local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
	local rank = tonumber(role.rank)
	if rank == 1 then
		Panel_dh:setBackGroundImage("images/ui/play/arena/arena_list.png")
	elseif rank <= 3 then
		Panel_dh:setBackGroundImage("images/ui/play/arena/arena_list_"..(rank - 1)..".png")
	elseif rank <= 10 and rank > 3 then
		Panel_dh:setBackGroundImage("images/ui/play/arena/arena_list_3.png")
	else
		Panel_dh:setBackGroundImage("images/ui/play/arena/arena_list_4.png")
	end

	self:updateFiveTimesInfo()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		self:addHeroAnimaton()
	end
end

function ArenaLadderSeatCell:onEnterTransitionFinish()
	
end

function ArenaLadderSeatCell:onInitDraw( isInit )
	if self.roleInstance == -1 then 
		return
	end
	
    local root = cacher.createUIRef("campaign/ArenaStorage/ArenaStorage_list_role.csb", "root")
	table.insert(self.roots, root)
    self:addChild(root)
	
	-- local action = csb.createTimeline(csbPath)
 --    root:runAction(action)
 --    self.action = action
	
	--local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	--root:setPosition(cc.p(0, 1000))             -- -100
	root:setTouchEnabled(false)
	root:setSwallowTouches(false)
	self:setContentSize(root:getContentSize())
	

	local Button_tiaozhan = ccui.Helper:seekWidgetByName(root, "Button_tiaozhan")
	if Button_tiaozhan ~= nil then 
		fwin:addTouchEventListener(Button_tiaozhan, 	nil, {
			terminal_name = "arena_ladder_seat_cell_fight_sm", 	
			terminal_state = 0, 
			cell = self
		}, 
		nil, 0)
	end
	--膜拜
	local Button_mobai = ccui.Helper:seekWidgetByName(root, "Button_mobai")
	if Button_mobai ~= nil then 
		fwin:addTouchEventListener(Button_mobai, nil, {
			terminal_name = "arena_ladder_seat_cell_worship", 	
			terminal_state = 0, 
			cell = self
		}, 
		nil, 0)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role"), nil, {
		terminal_name = "arena_ladder_seat_cell_show_info", 	
		terminal_state = 0, 
		cell = self
	}, 
	nil, 0)

	local Button_tiaozhan_0 = ccui.Helper:seekWidgetByName(root, "Button_tiaozhan_0")
	if Button_tiaozhan_0 ~= nil then 
		fwin:addTouchEventListener(Button_tiaozhan_0, 	nil, {
			terminal_name = "arena_ladder_seat_cell_fight_sm", 	
			terminal_state = 0, 
			cell = self
		}, 
		nil, 0)
	end
	local Button_z5 = ccui.Helper:seekWidgetByName(root, "Button_z5")
	if Button_z5 ~= nil then 
		fwin:addTouchEventListener(Button_z5, 	nil, {
			terminal_name = "arena_ladder_seat_cell_fight_sm_five", 	
			terminal_state = 0, 
			cell = self
		}, 
		nil, 0)
	end

	self:initDraw()

	if isInit == true then
		-- self:addHeroAnimaton()
	end
end

function ArenaLadderSeatCell:reload()
    local root = self.roots[1]
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
    	if root ~= nil then
	        return
	    end
    	self:onInitDraw()
    else
    	if self._armature == nil then
	    	self:addHeroAnimaton()
	    end

	    if root ~= nil then
	        return
	    end
	    self:onInitDraw()
	end
    
end

function ArenaLadderSeatCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("campaign/ArenaStorage/ArenaStorage_list_role.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ArenaLadderSeatCell:init(role, index)
	if role == -1 then
		self:setVisible(false)
	end
	self.index = index
	self.roleInstance = role
	self.roleShipId = dms.string(dms["ship_mould"], role.template[1], ship_mould.bust_index)
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
	-- 	if self.index and self.index <= 5 then
	-- 		self:onInitDraw(true)
	-- 	end
	-- else
	-- 	self:onInitDraw(true)
	-- end

	self:onInitDraw(true)
end

function ArenaLadderSeatCell:createCell()
	local cell = ArenaLadderSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function ArenaLadderSeatCell:clearUIInfo( ... )
	local root = self.roots[1]
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")
	if Panel_role ~= nil then
		Panel_role:removeAllChildren(true)
		Panel_role:removeBackGroundImage()
	end
	if Panel_dh ~= nil then
		Panel_dh:removeBackGroundImage()
	end
	self._armature = nil
end

function ArenaLadderSeatCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_list_role.csb", self.roots[1])
end
