-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场主界面
-- 创建时间：不明
-- 作者：胡文轩
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------


Arena = class("ArenaClass", Window)
Arena.RoleName = nil
function Arena:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	app.load("client.utils.scene.SceneCacheData")
	app.load("client.campaign.arena.ArenaHonorShop")
	app.load("client.campaign.arena.ArenaRankingPanel")
	app.load("client.campaign.arena.ArenaFirstReward")
	app.load("client.battle.BattleStartEffect")
	app.load("client.battle.fight.FightEnum")
	app.load("client.cells.campaign.arena_ladder_seat_cell")
	
	
	--我的排名
	self.cacheMyRankText = nilbu
	self.myRank = 0				--我的排名
	self.opponentRank = 0		--我的对手排名
	
	self.userIndex = 0 -- 当前我在的位置索引
	self.heroQueue = {} --当前显示cell队列
	
	self.cellRect = { --cell的显示矩阵对象
		-- cellWidth = cellWidth, 
		-- cellHeight = cellHeight,
		-- cellRightX = cellRightX,
		-- cellLeftX = 0,
	}
	--缓存ScrollView_1
	self.cacheListView = nil

	self.cacheListViewPosX = 0
	
	--缓存自定义内部层
	self.widgetLayout = nil
	
	--挑战需要消耗的精力
	self.cacheCostText = nil
	
	--我的荣誉值
	self.cacheHonourText = nil
	
	--战斗胜利返回该界面换位置
	self.changeStates = nil
	
	self.isTouchLock = false

	self.secondRequest = false
	self.secondRequestTime = 0

	self.cacherRoleArmature = {}
	
    -- Initialize Arena page state machine.
    local function init_arena_terminal()
	
		local arena_back_activity_terminal = {
            _name = "arena_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if fwin:find("CampaignClass") == nil then
						state_machine.excute("menu_show_campaign",0,1)
					else
						state_machine.excute("campaign_window_show",0,"")
					end
				else
					fwin:open(Campaign:new(), fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_update_information_terminal = {
            _name = "arena_update_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:updateInformation()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--打开排行榜
		local arena_open_ranking_panel_terminal = {
            _name = "arena_open_ranking_panel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(ArenaRankingPanel:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--打开荣誉商店
		local arena_open_honor_shop_terminal = {
            _name = "arena_open_honor_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
	            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		            	if _ED.arena_good_reward == nil or table.getn(_ED.arena_good_reward) == 0 or 
							_ED.arena_good == nil or table.getn(_ED.arena_good) == 0 then
							local function responseArenaHonorShopInitCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									fwin:open(ArenaHonorShop:new(), fwin._view)
								end
							end
							protocol_command.arena_shop_init.param_list = "0\r\n0"
							NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, nil, responseArenaHonorShopInitCallback, false, nil)
						else
							fwin:open(ArenaHonorShop:new(), fwin._view)
						end
					else
						fwin:open(ArenaHonorShop:new(), fwin._view)
					end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--挑战对手
		local arena_oppoent_fight_terminal = {
            _name = "arena_oppoent_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		local rolecell = params._datas.opponentInstance
        			local role = rolecell.roleInstance					
					local name = role.name
					Arena.RoleName= name
					--print("--------------------------------------------对手是",name)
				end
				local tmpSeat = params._datas.opponentInstance
				--> print("点击NPC了了了了,对手排名：", tmpRole.roleInstance.rank)
				if tonumber(_ED.user_info.user_id) == tonumber(tmpSeat.roleInstance.id) then return end
					instance:requestArenaFightDatas(tmpSeat)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 落水完毕
		local arena_ladder_seat_cell_play_dropout_action_complete_terminal = {
            _name = "arena_ladder_seat_cell_play_dropout_action_complete",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:playDropoutActionComplete()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 进入完毕
		local arena_ladder_seat_cell_play_turninto_action_complete_terminal = {
            _name = "arena_ladder_seat_cell_play_turninto_action_complete",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:playTurnintoActionComplete()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
				-- 打开布阵
		local lclick_open_formation_terminal = {
			_name = "lclick_open_formation",
			_init = function (terminal)
				app.load("client.formation.FormationChange") 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local formationChangeWindow = FormationChange:new()
				fwin:open(formationChangeWindow, fwin._windows)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
	
		state_machine.add(arena_update_information_terminal)
		
		state_machine.add(arena_ladder_seat_cell_play_dropout_action_complete_terminal)
		state_machine.add(arena_ladder_seat_cell_play_turninto_action_complete_terminal)
		
		state_machine.add(arena_back_activity_terminal)
		state_machine.add(arena_open_honor_shop_terminal)
		state_machine.add(arena_oppoent_fight_terminal)
		state_machine.add(arena_open_ranking_panel_terminal)
		state_machine.add(lclick_open_formation_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_terminal()
end

-- 记录下当前离开时的数据
function Arena:writeCacheData(targetIndex)
	local x,y = self.cacheListView:getInnerContainer():getPosition()
	
	local queue = {}
	for i,v in ipairs(_ED.arena_challenge) do
		table.insert(queue, v)
	end
	
	-- local isWin = false
	-- if tonumber(_ED.attackData.isWin) == 1 then
		-- isWin = true
	-- end
	
	--local targetIndex = targetIndex
	local cacheName = SceneCacheNameEnum.ARENA
	local data = SceneCacheData.getInitExample(cacheName)
	data.lastX = x	--最后离开时的坐标X
	data.lastY = y	--最后离开时的坐标X
	data.lastQueue = queue --最后离开时的队列数据
	data.targetIndex = targetIndex --战斗当前的目标
	--data.userIndex = self.userIndex --我的位置
	
	SceneCacheData.write(cacheName, data)
end

-- 读取最后离开时的数据
function Arena:readCacheData()
	self.isTouchLock = false
	local cacheName = SceneCacheNameEnum.ARENA
	if SceneCacheData.has(cacheName) then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game or
			__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		 	then
		else
			self.isTouchLock = true
		end

		-- self.isTouchLock = true
		
		
		--请求数据
		self:requestInitDatas()

		local data = SceneCacheData.read(cacheName)
		SceneCacheData.delete(cacheName)
		-- 复原最后离开时状况
		self:updateLadder(data.lastQueue)
		self:updateInformation()
		self:updateMyRankInfo()
		self.cacheListView:getInnerContainer():setPosition(cc.p(data.lastX,data.lastY))
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			local bgScrollView = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_3")
			bgScrollView:getInnerContainer():setPosition(cc.p(data.lastX,data.lastY))
		end
		
		-- 执行飞人行动
		local cell = self.heroQueue[data.targetIndex]
		self.playDropoutActionCellIndex = data.targetIndex
		self.playDropoutActionCell = cell
		cell:playDropoutAction()
		
		
	else
		-- 无缓存数据,直接正常处理
		
		--请求数据
		self:requestInitDatas()
	end
	
end

-- 显示 首次获胜奖励
function Arena:showFirstReward()
	-- 检查 是否存在 获胜 奖励的 元宝
	local gemRewardNumber = zstring.tonumber(_ED.arena_gem_reward_number)
	if  gemRewardNumber > 0 then
		_ED.arena_gem_reward_number = nil
		
		local view = ArenaFirstReward:new()
		view:init(gemRewardNumber, _ED.arena_user_rank)
		fwin:open(view, fwin._view)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
			or __lua_project_id == __lua_project_warship_girl_b 
			then
			local function responseArenaHonorShopInitCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				end
			end
			protocol_command.arena_shop_init.param_list = "0\r\n0"
			NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, nil, responseArenaHonorShopInitCallback, false, nil)		
		end
	end
end


function Arena:playDropoutActionComplete()
	-- self.playDropoutActionCellIndex = data.targetIndex
	-- self.playDropoutActionCell = cell
	
	-- 胜利的进来,  失败的下去
	local dropIsleft = self.playDropoutActionCell.isleft
	local dropRoleInstance = self.playDropoutActionCell.roleInstance
	local dropRank = dropRoleInstance.rank
	local dx,dy = self.playDropoutActionCell:getPosition()
	self.actionIndex =  self.playDropoutActionCell.posIndex

	local cell = self.heroQueue[self.userIndex]
	local intoIsleft = cell.isleft
	local intoRoleInstance = cell.roleInstance
	local intoRank = intoRoleInstance.rank
	local ix,iy = cell:getPosition()
	
	-- 交换排名
	dropRoleInstance.rank = intoRank
	intoRoleInstance.rank = dropRank
	
	-- 删掉落水的
	self.playDropoutActionCell:removeFromParent(true)
	
	-- 删掉原来的
	cell:removeFromParent(true)
	
	-- 上升的
	local riseCell = ArenaLadderSeatCell:createCell()
	riseCell:init(intoRoleInstance,dropIsleft,-1)
	self.cacheListView:getInnerContainer():addChild(riseCell)
	riseCell:setPosition(cc.p(dx,dy))
	riseCell:playTurnintoAction()
	
	-- 下降的
	local dropCell = ArenaLadderSeatCell:createCell()
	dropCell:init(dropRoleInstance,intoIsleft,-1)
	self.cacheListView:getInnerContainer():addChild(dropCell)
	dropCell:setPosition(cc.p(ix,iy))
	
	
	
end


function Arena:playTurnintoActionComplete()
	self.userIndex = self.actionIndex
	self:setUserY()	
	
	self.intoCompleteTime = os.clock()
end

function Arena:resetData()
	if self.isTouchLock == true	then
		self.isTouchLock = false
		self:updateLadder(_ED.arena_challenge)
		self:updateInformation()
		self:updateMyRankInfo()
		self:showFirstReward()
	end
end


function Arena:requestArenaFightDatas(opponentSeat)
	if self.isTouchLock == true	then
		return
	end
	
	if zstring.tonumber(_ED.user_info.endurance) < 2 then
		app.load("client.cells.prop.prop_buy_prompt")
		local win = PropBuyPrompt:new()
		win:init(getPiratesConfigPropMID(16), 2)
		fwin:open(win, fwin._ui)
		return
	end

	local rank = opponentSeat.roleInstance.rank
	local posIndex = opponentSeat.posIndex
	
	---[[
	--DOTO 战斗请求
	local function requestArenaFightDatasCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--> print("数据回来了 啦啦啦啦。。。战斗结果是：", _ED.attackData.isWin)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				if response.node == nil or response.node.roots == nil then
					return
				end
			end
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
					_ED.user_is_level_up = true
					_ED.arena_is_level_up = true
					_ED.last_grade = _ED.user_info.last_user_grade
					_ED.last_food = _ED.user_info.last_user_food
					_ED.last_endurance = _ED.user_info.last_endurance			
				end
			end
			-- 胜利了,记录当前.
			if tonumber(_ED.attackData.isWin) == 1 then
				
				-- 并且排名高过自己
				if tonumber(rank) < tonumber(self.heroQueue[self.userIndex].roleInstance.rank) then
					
					response.node:writeCacheData(posIndex)
				end

			end
			
			fwin:close(self.userInformationHeroStorage)
			fwin:cleanView(fwin._windows)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				fwin:freeAllMemeryPool()
			end
			local bse = BattleStartEffect:new()
			bse:init(_enum_fight_type._fight_type_11)
			fwin:open(bse, fwin._windows)
		
		end
	end
	
	-- _ED._current_scene_id = self.currentSceneID
	-- _ED._scene_npc_id = self.currentNpcID
	-- _ED._npc_difficulty_index = "1"
	-- protocol_command.arena_init.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
	-- protocol_command.arena_launch.param_list = opponentSeat.roleInstance.rank .. "\r\n0"
	-- NetworkManager:register(protocol_command.arena_launch.code, nil, nil, nil, nil, requestArenaFightDatasCallback, true, nil)
	--]]
	

	
	
	-- -- 引入相克系统战斗前请求
	local function launchBattle()
		protocol_command.arena_launch.param_list = rank .. "\r\n0"
		NetworkManager:register(protocol_command.arena_launch.code, nil, nil, nil, self, requestArenaFightDatasCallback, false, nil)
	end
	
	
	if missionIsOver() == false then
		launchBattle()
	else
		if __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_koone
		then
			local function responseCampPreferenceCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
					if _ED.camp_preference_info ~= nil and _ED.camp_preference_info.count > 0 then
						app.load("client.formation.FormationChangeMakeWar") 
						
						local makeWar = FormationChangeMakeWar:new()
						
						makeWar:init(launchBattle)
						
						fwin:open(makeWar, fwin._ui)
					else
						launchBattle()
					end
				end
			end
			_ED._battle_init_type = "1"
			local rid = opponentSeat.roleInstance.id
			protocol_command.camp_preference.param_list = ""..rid.."\r\n".."0"
			NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, nil, responseCampPreferenceCallback, false, nil)
			
		else
			launchBattle()
		end
	end
end


--请求竞技场数据
function Arena:requestInitDatas()
	
	if self.isRefreshed == true then
		self.isRefreshed = false
		if self.isTouchLock == false then
			self:updateLadder(_ED.arena_challenge)
			self:updateInformation()
			self:updateMyRankInfo()
		end
	else
	
		---[[
		local function responseArenaInitCallback(response)
			local arenaWindow = fwin:find("ArenaClass")
			if arenaWindow == nil then
				return
			end
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if arenaWindow.isTouchLock == false then
					arenaWindow:updateLadder(_ED.arena_challenge)
					arenaWindow:updateInformation()
					arenaWindow:updateMyRankInfo()

					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_yugioh 
						or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
						or __lua_project_id == __lua_project_warship_girl_b 
						then
						arenaWindow:showFirstReward()
					end
				end
			else
				arenaWindow.secondRequest = true
				arenaWindow.secondRequestTime = 3
			end
		end
		
		-- _ED._current_scene_id = self.currentSceneID
		-- _ED._scene_npc_id = self.currentNpcID
		-- _ED._npc_difficulty_index = "1"
		-- protocol_command.arena_init.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
		local drawConnectingView = self.secondRequest
		self.secondRequest = false
		self.secondRequestTime = 0
		protocol_command.arena_init.param_list = "0"
		NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseArenaInitCallback, drawConnectingView, nil)
		--]]
		
	end
end

-- 设置当前主角的位置Y轴
function Arena:setUserY()

	local height = self.cacheListView:getInnerContainer():getContentSize().height
	local y = self.userIndex * self.cellRect.cellHeight - height + self.cellRect.cellHeight
	
	if self.userIndex <= 4 then
		y = self.cacheListView:getContentSize().height - height
	end
	
	
	-- function executeHeroMoveByBackOverFunc()
		-- self:resetData()
		-- self.isTouchLock = false
	-- end
	
	-- local action = cc.Sequence:create(
					-- cc.MoveTo:create(1, cc.p(0, y)),
					-- cc.CallFunc:create(executeHeroMoveByBackOverFunc)
				-- )
	-- self.cacheListView:getInnerContainer():runAction(action)
	
	self.cacheListView:getInnerContainer():setPosition(cc.p(0, y))
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then  
		local bgScrollView = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_3")
		bgScrollView:getInnerContainer():setPosition(cc.p(0, y))
	end
end

-- 设置当前主角的位置X轴
function Arena:setUserX()
	local width = self.cacheListView:getInnerContainer():getContentSize().width
	local x = self.userIndex * self.cellRect.cellWidth - width
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if self.userIndex + 3 >= self.roleCount then
			x = self.cacheListView:getContentSize().width - width
		elseif self.userIndex <= 3 then
			x = 0
		-- elseif self.userIndex <= 10 then
		-- 	x = -(self.userIndex - 3) * self.cellRect.cellWidth
		else
			x = -(self.userIndex - 3) * self.cellRect.cellWidth
		end

		if x > 0 then
			x = 0
		end
	else
		if self.userIndex + 3  >= self.roleCount then
			x = self.cacheListView:getContentSize().width - width
		elseif self.userIndex <= 4 then
			x = 0
		end
	end
	self.cacheListView:getInnerContainer():setPosition(cc.p(x, 0))
	-- if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
	-- 	local bgScrollView = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_3")
	-- 	bgScrollView:getInnerContainer():setPosition(cc.p(0, 0))
	-- end
end

function Arena:onUpdate(dt)

	if nil ~= self.intoCompleteTime then
		if os.clock() - self.intoCompleteTime >= 0.1 then
			self.intoCompleteTime = nil
			self:resetData()
		end
	end
	if self.secondRequest == true then
		self.secondRequestTime = self.secondRequestTime - dt
		if self.secondRequestTime <= 0 then
			self:requestInitDatas()
			self.secondRequest = false
			self.secondRequestTime = 0
		end
	end
	if self.cacheListView ~= nil then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
	        local size = self.cacheListView:getContentSize()
	        local posX = self.cacheListView:getInnerContainer():getPositionX()
	        if self.cacheListViewPosX == posX then
	            return
	        end
	        self.cacheListViewPosX = posX
	        local items = self.cacheListView:getChildren()
	        if items[1] == nil then
	            return
	        end
	        local itemSize = items[1]:getContentSize()
	        for i, v in pairs(items) do
	            local tempX = v:getPositionX() + posX
	            if tempX + itemSize.width/2 < 0 or tempX > size.width + itemSize.width/2 then
	                -- v:unload()
	                local result = v:getRoleArmature()
	                if result ~= nil then
	                	table.insert(self.cacherRoleArmature, result)
	                end
	            else
	                v:reload()
	                self:addHeroArmature(v)
	            end
	        end
	    elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
	    	or __lua_project_id == __lua_project_yugioh 
            or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
            or __lua_project_id == __lua_project_warship_girl_b 
            then
	    	local size = self.cacheListView:getContentSize()
	        local posY = self.cacheListView:getInnerContainer():getPositionY()
	        if self.cacheListViewPosY == posY then
	            return
	        end
	        self.cacheListViewPosY = posY
	        local items = self.cacheListView:getChildren()
	        if items[1] == nil then
	            return
	        end
	        local itemSize = items[1]:getContentSize()
	        for i, v in pairs(items) do
	            local tempY = v:getPositionY() + posY
	            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
	                -- v:unload()
	                local result = v:getRoleArmature()
	                if result ~= nil then
	                	table.insert(self.cacherRoleArmature, result)
	                end
	            else
	                v:reload()
	                self:addHeroArmature(v)
	            end
	        end
	    end
    end
end

function Arena:addHeroArmature( cell )
	if cell.isAddRole == false then
		local isAdd = false
        for index,armatureInfo in pairs(self.cacherRoleArmature) do
        	if armatureInfo ~= nil and tonumber(armatureInfo[1]) == tonumber(cell.roleShipId) then
        		isAdd = true
        		cell:addRoleArmature(armatureInfo[2])
        		table.remove(self.cacherRoleArmature, index)
        		return
        	end
        end
        if isAdd == false then
        	cell:addHeroAnimaton()
        end
    end
end

--显示竞技场天梯
function Arena:updateLadder(queueData)
	-- 清理所有绘制对象
	self.cacheListView:removeAllChildren(true)
	
	local tmpList = {}
	local tmpListIndex = 0
	local createALCNums = 0
	local tmpCellWidth = 0
	local tmpCellHeight = 0
	local unitRoleNum = 6 --一屏角色显示数
	
	local roleCount = #queueData
	local posIndex = roleCount
	local pageCount = math.ceil(roleCount / unitRoleNum)
	local pageIndex = pageCount
	local cellHeight = 0
	local cellWidth = 0
	local cellRightX = 0
	local contentHeight = 0
	------------------------------------------------------------------------------------
	--修改为单个显示----------
	self.heroQueue = {}
	self.cellRect = {} 
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local csbPath = "campaign/ArenaStorage/ArenaStorage_list_role.csb"
	    local root = cacher.createUIRef(csbPath, "root")
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
		if ArenaLadderSeatCell.__size == nil then
			ArenaLadderSeatCell.__size = panel:getContentSize()
		end
		root:removeFromParent(true)

		local contentWidth = 0
		for i=1,roleCount do
			local oneCell = ArenaLadderSeatCell:createCell()
			local oneValue = queueData[i]
			if oneValue.id == _ED.user_info.user_id then
				self.userIndex = i
				ArenaLadderSeatCell.__selfIndex = i
			end

			oneCell:setContentSize(ArenaLadderSeatCell.__size)
			self.cacheListView:getInnerContainer():addChild(oneCell)
			
			cellHeight = ArenaLadderSeatCell.__size.height--oneCell:getContentSize().height
			cellWidth = ArenaLadderSeatCell.__size.width--oneCell:getContentSize().width

			oneCell:setPosition(cc.p(cellWidth*(i-1), 0))
			table.insert(self.heroQueue, oneCell)
		end

		for i=1,roleCount do
			local isLoad = false
			if self.userIndex <= 3 then
				if i <= 5 then
					isLoad = true
				end
			elseif self.userIndex + 3 >= roleCount then
				if i >= roleCount - 5 then
					isLoad = true
				end
			else
				if math.abs(self.userIndex - i) <= 2 then
					isLoad = true
				end
			end
			self.heroQueue[i]:init(queueData[i],true,i,isLoad)
		end
		self.cellRect = {
			cellWidth = cellWidth,
			cellHeight = cellHeight,
			cellRightX = 0,
			cellLeftX = 0,
		}
		self.roleCount = roleCount
		contentWidth = cellWidth*(roleCount)
		self.cacheListView:getInnerContainer():setContentSize(cc.size(contentWidth, self.cacheListView:getContentSize().height))

		self:setUserX()

	    self.cacheListViewPosX = self.cacheListView:getInnerContainer():getPositionX()
	elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local csbPath = "campaign/ArenaStorage/ArenaStorage_list_role.csb"
	    local root = cacher.createUIRef(csbPath, "root")
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
		if ArenaLadderSeatCell.__size == nil then
			ArenaLadderSeatCell.__size = panel:getContentSize()
		end
		root:removeFromParent(true)
		
		local contentHeight = 0
		for i=1,roleCount do
			local oneCell = ArenaLadderSeatCell:createCell()
			local oneValue = queueData[i]
			if oneValue.id == _ED.user_info.user_id then
				self.userIndex = i
				ArenaLadderSeatCell.__selfIndex = i
			end

			oneCell:setContentSize(ArenaLadderSeatCell.__size)
			self.cacheListView:getInnerContainer():addChild(oneCell)
			
			cellHeight = ArenaLadderSeatCell.__size.height
			cellWidth = ArenaLadderSeatCell.__size.width

			local isleft = true
			if i %2 == 0 then
				isleft = false
			end
			local x = 0
			if false == isleft then
				x = fwin._width - cellWidth
			end
			oneCell:setPosition(cc.p(x, cellHeight*(roleCount - i)))
			table.insert(self.heroQueue, oneCell)
		end

		for i=1,roleCount do
			local isLoad = false
			if self.userIndex <= 4 then
				if i <= 5 then
					isLoad = true
				end
			elseif self.userIndex + 3 >= roleCount then
				if i >= roleCount - 5 then
					isLoad = true
				end
			else
				if math.abs(self.userIndex - i) <= 2 then
					isLoad = true
				end
			end
			local isleft = true
			if i %2 == 0 then
				isleft = false
			end
			self.heroQueue[i]:init(queueData[i],isleft,i,isLoad)
		end
		self.cellRect = {
			cellWidth = cellWidth,
			cellHeight = cellHeight,
			cellRightX = 0,
			cellLeftX = 0,
		}
		self.roleCount = roleCount
		contentHeight = cellHeight*(roleCount + 1)
		self.cacheListView:getInnerContainer():setContentSize(cc.size(fwin._width, contentHeight))

		local backgroundScrollView = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_3")
		if backgroundScrollView ~= nil then
			backgroundScrollView:getInnerContainer():setContentSize(cc.size(fwin._width, contentHeight))
			backgroundScrollView:jumpToBottom()
		end

		self:setUserY()

	    self.cacheListViewPosY = self.cacheListView:getInnerContainer():getPositionY()
	else
		local oneCell = ArenaLadderSeatCell:createCell()
		local oneValue = queueData[1]
		if oneValue.id == _ED.user_info.user_id then
			self.userIndex = 1
		end
		oneCell:init(oneValue,true,1)
		self.cacheListView:getInnerContainer():addChild(oneCell)
		cellHeight = oneCell:getContentSize().height
		cellWidth = oneCell:getContentSize().width
		cellRightX = fwin._width - cellWidth
		contentHeight = cellHeight*(roleCount+1)
		self.cacheListView:getInnerContainer():setContentSize(cc.size(fwin._width, contentHeight))
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			local backgroundScrollView = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_3")
			if backgroundScrollView ~= nil then
				backgroundScrollView:getInnerContainer():setContentSize(cc.size(fwin._width, contentHeight))
				backgroundScrollView:jumpToBottom()
			end
		end
		oneCell:setPosition(cc.p(0, contentHeight-cellHeight*2))
		table.insert(self.heroQueue, oneCell)
		
		self.cellRect = {
			cellWidth = cellWidth,
			cellHeight = cellHeight,
			cellRightX = cellRightX,
			cellLeftX = 0,
		}
		
		posIndex = posIndex - 2
		for i=2,roleCount do
			local v = queueData[i]
			if createALCNums == 0 and tmpListIndex == 0 then 
				table.insert(tmpList, -1)
				tmpListIndex = tmpListIndex + 1
			end
			table.insert(tmpList, v)
			tmpListIndex = tmpListIndex + 1
			
			--记录当前角色index 
			if v.id == _ED.user_info.user_id then
				self.userIndex = i
			end

			local cell = ArenaLadderSeatCell:createCell()
			local isleft = true
			if i %2 == 0 then
				isleft = false
			end
			cell:init(v,isleft,i)
			self.cacheListView:getInnerContainer():addChild(cell)
			
			local x = 0
			if false == isleft then
				x = fwin._width - cellWidth
			end

			cell:setPosition(cc.p(x, cellHeight*(posIndex)))
			posIndex = posIndex - 1
			
			table.insert(self.heroQueue, cell)
			
			table.insert(self.roots, cell.roots[1])
		end
		self:setUserY()	
	
	end
	
	if self.userIndex > 1 then
		local topCell = self.heroQueue[self.userIndex - 1]
		topCell:changeTopName()
	end
end

--显示竞技场基础数据
function Arena:updateInformation()

	-- _ED.arena_user_rank
	self.cacheMyRankText:setString(_ED.arena_user_rank)
	self.cacheCostText:setString("2")
	-- _ED.user_info.user_honour
	self.cacheHonourText:setString(_ED.user_info.user_honour)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			
		if self.roleIcon then
			if _ED.user_info.user_gender == 1 then
				self.roleIcon:loadTexture("images/ui/play/arena/arena_head_2.png")
			else
				self.roleIcon:loadTexture("images/ui/play/arena/arena_head_1.png")
			end
		end
	end
end


function Arena:updateMyRankInfo()
	function getSectionIndex(userRank)
		-- 获取该排名的区间索引
		for i, v in ipairs(dms["arena_reward_param"]) do
			local minRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_begin)
			local maxRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_end)
			if userRank > minRank and userRank < maxRank or userRank == minRank or userRank == maxRank then
				return i
			end
		end
		return 0
	end
	
	self.rankInfoPanel:setVisible(false)
	self.boundaryText:setVisible(false)
	
	-- 取配置文件的排名区间
	--local boundaryRankNum = dms.int(dms["pirates_config"], 286, pirates_config.param)
	
	-- 从竞技场排名模板的末尾名
	local rewardData = dms["arena_reward_param"]
	local boundaryRankNum = dms.int(rewardData, #rewardData, arena_reward_param.arena_order_end)
	
	-- 取自己的排名
	local myRankIndex = tonumber(_ED.arena_user_rank)

	if myRankIndex <= boundaryRankNum then
		-- 显示具体的内容
		
		-- 取自己排名位的模板数据
		local sectionIndex = getSectionIndex(myRankIndex)
		
		-- 奖励荣誉*
		local targetHonor = dms.int(dms["arena_reward_param"], sectionIndex, arena_reward_param.arena1_reward_bounty)
		self.cacheTargetHonorText:setString(targetHonor)
		
		
		-- 奖励银子*
		local targetCoin = dms.int(dms["arena_reward_param"], sectionIndex, arena_reward_param.arena1_reward_silver)
		self.cacheTargetCoinText:setString(targetCoin)
		
		-- 奖励道具*
		local targetItemNums = dms.int(dms["arena_reward_param"], sectionIndex, arena_reward_param.arena1_reward_prop_count)
		self.cacheTargetNumsText:setString(targetItemNums)
		
		-- 时间
		local timeString = "22:00:00"--dms.string(dms["pirates_config"], 287, pirates_config.param)
		
		self.issueTimeText:setString(string.format(tipStringInfo_arena[2],timeString))
		
		self.rankInfoPanel:setVisible(true)
	else
		-- 显示文本
		self.boundaryText:setString(string.format(tipStringInfo_arena[1],boundaryRankNum))
		self.boundaryText:setVisible(true)
	end

end

function Arena:onEnterTransitionFinish()

	--显示底板 ArenaBackgroundPanel
	-- self.group.bgPanel = ArenaBackgroundPanel:new()
	-- fwin:open(self.group.bgPanel, fwin._background)
	
    local csbArena = csb.createNode("campaign/ArenaStorage/ArenaStorage.csb")
	local root = csbArena:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArena)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert  then
		local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage.csb") 
		table.insert(self.actions, action )
		csbArena:runAction(action)
		action:play("window_open", false)
		-- state_machine.lock("arena_oppoent_fight")
	end
	
	
	--缓存ScrollView_1
	self.cacheListView = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		self.cacheListView:setSwallowTouches(false)	
	end
	
	--我的排名
	self.cacheMyRankText = ccui.Helper:seekWidgetByName(root, "Text_2")
	
	--------------------------------------------------------------------------------
	-- 0409新增文本
	
	--奖励信息容器
	self.rankInfoPanel = ccui.Helper:seekWidgetByName(root, "Panel_26")
	self.rankInfoPanel:setVisible(false)
	
	--奖励发放时间
	self.issueTimeText = ccui.Helper:seekWidgetByName(root, "Text_45")
	
	--荣誉
	self.cacheTargetHonorText = ccui.Helper:seekWidgetByName(root, "Text_42")
	
	--金钱
	self.cacheTargetCoinText = ccui.Helper:seekWidgetByName(root, "Text_43")
	
	--突破石 道具
	self.cacheTargetNumsText = ccui.Helper:seekWidgetByName(root, "Text_44")
	
	--低于排名分界显示的文本
	self.boundaryText = ccui.Helper:seekWidgetByName(root, "Text_3")
	self.boundaryText:setVisible(false)
	----------------------------------------------------------------------------------
	--挑战需要消耗的精力
	self.cacheCostText = ccui.Helper:seekWidgetByName(root, "Text_5")
	
	--我的荣誉值
	self.cacheHonourText = ccui.Helper:seekWidgetByName(root, "Text_7")

	self.roleIcon = ccui.Helper:seekWidgetByName(root, "Image_4")

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), 	nil, {
		terminal_name = "arena_back_activity", 	
		next_terminal_name = "arena_back_activity", 	
		current_button_name = "Button_2",		
		but_image = "arena",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--荣誉商店
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), 	nil, {
		terminal_name = "arena_open_honor_shop", 	
		next_terminal_name = "arena_open_honor_shop", 	
		current_button_name = "Button_3",		
		but_image = "honor_shop",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_arena_reward_cell",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_3"),
		_invoke = nil,
		_interval = 0.5,})
	
	local Button_2 = ccui.Helper:seekWidgetByName(root, "Button_2")
	--评审状态不显示排行榜
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
		if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
			Button_2:setVisible(true)
		else
			Button_2:setVisible(false)
		end
	end
	--排行榜
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), 	nil, {
		terminal_name = "arena_open_ranking_panel", 	
		next_terminal_name = "arena_open_ranking_panel", 	
		current_button_name = "Button_2",		
		but_image = "ranking_panel",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	-- 布阵
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), 	nil, {
			terminal_name = "lclick_open_formation", 		
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end

	
	self:readCacheData()
	---------------------------------------------------
	--顶部属性栏
	-- app.load("client.player.UserInformationHeroStorage")
	-- self.userInformationHeroStorage = UserInformationHeroStorage:new()
	-- fwin:open(self.userInformationHeroStorage, fwin._view)
	app.load("client.player.EquipPlayerInfomation") 
	local userinfo = EquipPlayerInfomation:new()
	fwin:open(userinfo,fwin._view)
	
	state_machine.excute("menu_button_hide_highlighted_all", 0, nil)

	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and missionIsOver() == true then
		if _ED.is_arena_can_share ~= nil and _ED.is_arena_can_share == 1 then
			_ED.is_arena_can_share = 0
			app.load("client.campaign.arena.ArenaShare") 
			state_machine.excute("arena_share_open", 0, "")
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
        or __lua_project_id == __lua_project_warship_girl_b 
		then
		local function responseArenaRankingPanelInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			end
		end
		protocol_command.arena_order.param_list = "0"
		NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, nil, responseArenaRankingPanelInitCallback, false, nil)

		if _ED.arena_good_reward == nil or table.getn(_ED.arena_good_reward) == 0 or 
			_ED.arena_good == nil or table.getn(_ED.arena_good) == 0 then
			local function responseArenaHonorShopInitCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				end
			end
			protocol_command.arena_shop_init.param_list = "0\r\n0"
			NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, nil, responseArenaHonorShopInitCallback, false, nil)
		end
	end
end

function Arena:init(changeStates, isRefreshed)
	self.changeStates = changeStates
	self.isRefreshed = isRefreshed
end

function Arena:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
        or __lua_project_id == __lua_project_warship_girl_b 
		then
		for k,v in pairs(self.cacherRoleArmature) do
			if v ~= nil and v[2] ~= nil then
				v[2]:release()
			end
		end
		self.cacherRoleArmature = {}
		self.cacheListView:removeAllChildren(true)
		cacher.destoryRefPools()
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
	end
end

function Arena:onExit()
	state_machine.remove("arena_update_information")
	
	state_machine.remove("arena_ladder_seat_cell_play_dropout_action_complete")
	state_machine.remove("arena_ladder_seat_cell_play_turninto_action_complete")

	state_machine.remove("arena_back_activity")
	state_machine.remove("arena_open_honor_shop")
	state_machine.remove("arena_oppoent_fight")
	state_machine.remove("arena_open_ranking_panel")
	state_machine.remove("lclick_open_formation")
end
