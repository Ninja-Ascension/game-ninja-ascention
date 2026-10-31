app.load("client.red_alert.battle.report.ConfigDB")
app.load("client.red_alert.battle.report.BattleCache")
app.load("client.red_alert.battle.report.FightObject")
app.load("client.red_alert.battle.report.IniUtil")
app.load("client.red_alert.battle.report.BattleObject")
app.load("client.red_alert.battle.report.TalentSkill")
app.load("client.red_alert.battle.report.TalentUniteSkill")
app.load("client.red_alert.battle.report.TalentAura")
app.load("client.red_alert.battle.report.TalentConstant")
app.load("client.red_alert.battle.report.TalentImmunity")
app.load("client.red_alert.battle.report.TalentJudge")
app.load("client.red_alert.battle.report.TalentJudgeResult")
app.load("client.red_alert.battle.report.TalentMould")
-- 战斗模块
-- @author xiaofeng
FightModule = class("FightModule")
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_NORMAL =  0
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_ELIT =  1
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_MONEY_TREE =  2
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_TREASURE_EXPERIENCE =  3
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_PANDA_EXPERIENCE =  4
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_WORLD_BOSS =  5
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_TRANS_TOWER =  6
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_COUNTERPART =  7
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_BATTLEGROUND =  8
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_GREAT_SOLDIER =  9
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_DAILY_INSTANCE =  101
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_THREE_KING =  102
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_MANOR =  103
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVE_REBELARMY =  104
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_GREAT_SOLDIER_B =  105
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_GRAB =  10
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_ARENA =  11
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_DUEL =  12
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_UNIO =  13
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_RESOURCE_MINE =  14
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_SPIRITE_PALACE =  15
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_TYPE_PVP_CROSS_SERVER =  16
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_RESULT_CONTINUE =  1
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_RESULT_WIN =  1
-- 战斗模块
-- @author xiaofeng
FightModule.FIGHT_RESULT_LOST =  0

function encryptInfo( info )
    return aeslua.encrypt("jar-world", ""..info, aeslua.AES128, aeslua.ECBMODE)
end

function decryptInfo( info )
    return tonumber(aeslua.decrypt("jar-world", ""..info, aeslua.AES128, aeslua.ECBMODE))
end

function FightModule:ctor()

    --战斗中的攻击者对象数组
	self.attackObjects = {}
	--缓存数据对象
	self.attackTempObjects = {}
	--我方英雄数组
	self.heroBattleObjects = {}
	
    --战斗中的被攻者对象数组
	self.byAttackObjects = {}
	--敌方英雄数组
	self.armyBattleObjects = {}
	
    --战斗类型
	self.fightType = FightModule.FIGHT_TYPE_PVE_NORMAL

    --回合计数
	self.roundCount = 1

    --出战人数
	self.shipCount = 0

    --死亡人数
	self.deathCount = 0

    --战斗结果
    self.fightResult =  0

    --剩余血量
	self.surplusHealth = 0

    --总血量
    self.totalHealth =  0

    --用户承受伤害= 总血量-剩余血量
	self.totalAttackDamage = 0

    --NPC承受伤害 = 总血量-剩余
	self.totalDefenceDamage = 0

    self.npcMaxHealth =  0

    self.fakeLevel =  1

    self.isFake =  false

    self.worldBossDamageAdditional =  0

    self.attackDamages =  ""

    self.defenceDamages =  ""

    self.attackDeadState =  ""

    self.defenceDeadState =  ""

    self.fighters =  {}

    self.userThreeKingdomsInfo =  nil

    --日常副本回合数
    self.dailyRoundCount =  0
	
	self.totalRound = 20

    --叛军信息
    self.userRebelArmy =  nil

    --是否加倍
    --1 普通 2加倍
    self.isDouble =  false

    --额外加成血量
    self.addHpoint =  0

    --额外加成攻击
    self.addAttack =  0

    --合体技能
    --检查死亡人数和剩余血量
    --检查NPC所受伤害
    self.fitBuffer =  nil
	
	self.attackCount = 0
	self.byAttackCount = 0
	self.headBuffer = nil
	self.bodyBuffer = nil
	self.buffBuffer = nil

	self.fitBattleSkillCount = 0
	-- self.fitHeadBuffer = nil
	-- self.fitBodyBuffer = nil
	self.fitSelfBuffer = nil
	
	self.counterBuffer = nil
	self.battleSkillCount = 0
	self.battleSkillBuffer = nil
	self.tanlentSkillBuffer = nil
	
	self.fightOrderList = {}	--定义出手对象列表	table 顺序取出
	
	self.currentObject = nil 	-- 定义当前出手对象
	
	self.nextFightObject = nil   -- 定义下一个出手对象
	
	self.hasNextRound = true	--是否有下一场战斗
	
	self.greadCount = 0 	--评分计数
	
	self.star = 0		--星数
	
	self.gradeAttack = 0 	--伤害加成

	self.canFreeSkill = false   		--评分加成

	self.rewardProp = {}	--掉落道具
	
	self.rewardEquipment = {}	--掉落装备
	
	self.rewardCard = {}	--掉落卡牌

	self.maxZolSkillPoint = 4		--合体怒气点数上限

	self.battleTag = 0	--默认我方出手

	self.maxBattleCount = encryptInfo(0)
end

function FightModule:setDouble(type)
	self.isDouble = type == 2
end

function FightModule:isFake()
	return isFake
end

function FightModule:setFake(isFake)
	self.isFake = isFake
end

function FightModule:initPVPFightReport( ... )
	local resultBuffer = {}

	local battleCache = BattleCache:new()

	battleCache.userInfo = _ED.pvpFightReport[1]
	battleCache.battleType = self.fightType
	battleCache.userPVPInfo = _ED.pvpFightReport[2]
	battleCache.byAttackerId = 0
	battleCache.currentBattleCount = encryptInfo(0)
	battleCache.maxBattleCount = encryptInfo(1)
	self.maxBattleCount = encryptInfo(1)
	local attackObjects = {}
	-- 横扫千军增至9个阵型位 对应表中column
	local seatIndex = { environment_formation.seat_one, 
						environment_formation.seat_two, 
						environment_formation.seat_three,
						environment_formation.seat_four, 
						environment_formation.seat_five, 
						environment_formation.seat_six,
						environment_formation.seat_seven,
						environment_formation.seat_eight,
						environment_formation.seat_nine,
					}
	local seatArray = {}
	local pvp_attack = _ED.pvpFightReport[1]
	for idx = 1, 6 do
		-- 读取阵型 到 阵型Array
		seatArray[idx] = pvp_attack.ship_formation[idx + 1]
		-- 如果 Array中值不为0， 则存在user_ship的实例id数据
		if (tonumber(seatArray[idx]) > 0) then
			if( pvp_attack.ship_list[ seatArray[idx] ] ~= nil) then
				-- 根据ship_id获得ship数据
				local userShip = pvp_attack.ship_list[seatArray[idx]]
				-- debug.print_r(userShip)
				-- 生成英雄战斗实例 初始化fightObject数据
				local fightObject = FightObject:new()
				-- fightObject:initWithUserData(#attackObjects+1, userShip, 0, _ED.user_info.user_id)
				fightObject:initWithUserData(idx, userShip, 0, pvp_attack.user_info.user_id)
				table.insert(attackObjects,fightObject)

				-- debug.print_r(userShip)

				--获得小兵模板参数
				local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], fightObject.shipMould, ship_mould.base_mould2))
				local forceCount = dms.atos(forceMould,ship_force_mould.force_count)
				-- print("小兵模板",forceCount)
				-- 生成小兵战斗实例 
				for i=1,forceCount do
					local forceFightObject = fightObject:fightObject(forceMould,userId)			 
					 forceFightObject.coordinate=#attackObjects+1

					forceFightObject.level = fightObject.level           --设置npc小兵等级
					forceFightObject.battleTag = fightObject.battleTag

					 -- table.insert(attackObjects,forceFightObject)
					 table.insert(fightObject.forceArray,forceFightObject)					
				end
			else
				attackObjects[idx] = nil
			end
		else
			attackObjects[idx] = nil
		end
	end
	-- 战力值
	battleCache.attackCombatForce = pvp_attack.user_info.fight_capacity

	-- 将已方战斗实例数据都加入 battleCache
	battleCache.attackName = pvp_attack.user_info.user_name
	battleCache.attackerObjects = attackObjects

	local pvp_byAttack = _ED.pvpFightReport[2]
	local byAttackerObjectsList = {}
	local byAttackObjects = {}
	seatArray = {}
	for idx = 1, 6 do
		-- 读取阵型 到 阵型Array
		seatArray[idx] = pvp_byAttack.ship_formation[idx]
		-- 如果 Array中值不为0， 则存在user_ship的实例id数据
		if (tonumber(seatArray[idx]) > 0) then
			if( pvp_byAttack.ship_list[ seatArray[idx] ] ~= nil) then
				-- 根据ship_id获得ship数据
				local userShip = pvp_byAttack.ship_list[seatArray[idx]]
				-- debug.print_r(userShip)
				-- 生成英雄战斗实例 初始化fightObject数据
				local fightObject = FightObject:new()
				-- fightObject:initWithUserData(#attackObjects+1, userShip, 0, _ED.user_info.user_id)
				fightObject:initWithPVPUserData(idx, userShip, 0, pvp_byAttack.user_info.user_id)
				table.insert(byAttackObjects, fightObject)

				-- debug.print_r(userShip)

				--获得小兵模板参数
				local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], fightObject.shipMould, ship_mould.base_mould2))
				local forceCount = dms.atos(forceMould,ship_force_mould.force_count)
				-- print("小兵模板",forceCount)
				-- 生成小兵战斗实例 
				for i=1,forceCount do
					local forceFightObject = fightObject:fightObject(forceMould,userId)			 
					 forceFightObject.coordinate=#attackObjects+1

					forceFightObject.level = fightObject.level           --设置npc小兵等级
					forceFightObject.battleTag = fightObject.battleTag

					 -- table.insert(attackObjects,forceFightObject)
					 table.insert(fightObject.forceArray,forceFightObject)					
				end
			else
				byAttackObjects[idx] = nil
			end
		else
			byAttackObjects[idx] = nil
		end
	end
	table.insert(byAttackerObjectsList, byAttackObjects)
	-- 战力值
	battleCache.byAttackComobatForce = pvp_byAttack.user_info.fight_capacity
	-- 将已方战斗实例数据都加入 battleCache
	battleCache.byAttackName = pvp_byAttack.user_info.user_name
	battleCache.byAttackerObjectsList = byAttackerObjectsList

	_ED.user_info.battleCache = battleCache
end

function FightModule:initPVPBattleField(  )
	local resultBuffer = {}

	local battleCache = BattleCache:new()

	battleCache.userInfo = _ED.user_info
	battleCache.battleType = self.fightType
	battleCache.userPVPInfo = _ED.other_user_info
	battleCache.byAttackerId = 0
	battleCache.currentBattleCount = encryptInfo(0)
	battleCache.maxBattleCount = encryptInfo(1)
	self.maxBattleCount = encryptInfo(1)
	local attackObjects = {}
	-- 横扫千军增至9个阵型位 对应表中column
	local seatIndex = { environment_formation.seat_one, 
						environment_formation.seat_two, 
						environment_formation.seat_three,
						environment_formation.seat_four, 
						environment_formation.seat_five, 
						environment_formation.seat_six,
						environment_formation.seat_seven,
						environment_formation.seat_eight,
						environment_formation.seat_nine,
					}
	local is_formation_addition = false
	local formationIndex = 0
	for i=1,6 do
		local shipId = _ED.formetion[i + 1]
		if tonumber(shipId) > 0 
			and (_ED.user_ship[shipId] ~= nil) 
			then
			formationIndex = formationIndex + 1
		end
	end
	if formationIndex >= 5 then
		is_formation_addition = true
	end
	local seatArray = {}
	for idx = 1, 6 do
		-- 读取阵型 到 阵型Array
		seatArray[idx] = _ED.formetion[idx + 1]
		-- 如果 Array中值不为0， 则存在user_ship的实例id数据
		if (tonumber(seatArray[idx]) > 0) then
			if( _ED.user_ship[ seatArray[idx] ] ~= nil) then
				-- 根据ship_id获得ship数据
				local userShip = _ED.user_ship[seatArray[idx]]
				-- 生成英雄战斗实例 初始化fightObject数据
				local fightObject = FightObject:new()
				fightObject:initWithUserData(idx, userShip, 0, _ED.user_info.user_id, self.fightType, is_formation_addition)
				table.insert(attackObjects,fightObject)
				--获得小兵模板参数
				local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], fightObject.shipMould, ship_mould.base_mould2))
				local forceCount = dms.atos(forceMould,ship_force_mould.force_count)
				-- 生成小兵战斗实例 
				for i=1,forceCount do
					local forceFightObject = fightObject:fightObject(forceMould,userId)			 
					 forceFightObject.coordinate=#attackObjects+1

					forceFightObject.level = fightObject.level           --设置npc小兵等级
					forceFightObject.battleTag = fightObject.battleTag

					 -- table.insert(attackObjects,forceFightObject)
					 table.insert(fightObject.forceArray,forceFightObject)					
				end
			else
				attackObjects[idx] = nil
			end
		else
			attackObjects[idx] = nil
		end
	end
	-- 战力值
	battleCache.attackCombatForce = _ED.user_info.fighter_capacity

	-- 将已方战斗实例数据都加入 battleCache
	battleCache.attackName = _ED.user_info.user_name
	battleCache.attackerObjects = attackObjects


	is_formation_addition = false
	formationIndex = 0
	for i=1,6 do
		local shipId = _ED.other_user_info.ship_formation[i]
		if tonumber(shipId) > 0 
			and (_ED.other_user_info.ship_list[shipId] ~= nil) 
			then
			formationIndex = formationIndex + 1
		end
	end
	if formationIndex >= 5 then
		is_formation_addition = true
	end
	local byAttackerObjectsList = {}
	local byAttackObjects = {}
	seatArray = {}
	for idx = 1, 6 do
		-- 读取阵型 到 阵型Array
		seatArray[idx] = _ED.other_user_info.ship_formation[idx]
		-- 如果 Array中值不为0， 则存在user_ship的实例id数据
		if (tonumber(seatArray[idx]) > 0) then
			if( _ED.other_user_info.ship_list[ seatArray[idx] ] ~= nil) then
				-- 根据ship_id获得ship数据
				local userShip = _ED.other_user_info.ship_list[seatArray[idx]]
				-- 生成英雄战斗实例 初始化fightObject数据
				local fightObject = FightObject:new()
				fightObject:initWithPVPUserData(idx, userShip, 0, _ED.other_user_info.user_id, self.fightType, is_formation_addition)
				table.insert(byAttackObjects, fightObject)
				--获得小兵模板参数
				local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], fightObject.shipMould, ship_mould.base_mould2))
				local forceCount = dms.atos(forceMould,ship_force_mould.force_count)
				-- 生成小兵战斗实例 
				for i=1,forceCount do
					local forceFightObject = fightObject:fightObject(forceMould,userId)			 
					 forceFightObject.coordinate=#attackObjects+1

					forceFightObject.level = fightObject.level           --设置npc小兵等级
					forceFightObject.battleTag = fightObject.battleTag

					 -- table.insert(attackObjects,forceFightObject)
					 table.insert(fightObject.forceArray,forceFightObject)					
				end
			else
				byAttackObjects[idx] = nil
			end
		else
			byAttackObjects[idx] = nil
		end
	end
	table.insert(byAttackerObjectsList, byAttackObjects)
	-- 战力值
	battleCache.byAttackComobatForce = _ED.other_user_info.fight_capacity
	-- 将已方战斗实例数据都加入 battleCache
	battleCache.byAttackName = _ED.other_user_info.user_name
	battleCache.byAttackerObjectsList = byAttackerObjectsList

	_ED.user_info.battleCache = battleCache
end

function FightModule:initNewBattleField(npcId,fightType)
	--清空战斗缓存
	_ED.user_info.battleCache = nil
	
	self.fightType = fightType
	local formation = _ED.formetion
	local user_ships = _ED.user_ship
	if self.fightType == battle_enum._fight_type._fight_type_20 then
		self:initNewBattleFieldEx(npcId,fightType)
		return
	elseif checkPvpBattleType(self.fightType) == true then
		self:initPVPBattleField()
		return
	elseif self.fightType == battle_enum._fight_type._fight_type_24 then
		self:initPVPFightReport()
	elseif self.fightType == battle_enum._fight_type._fight_type_21 then
        formation = _ED.union.union_team_fight_info.formation
        user_ships = _ED.union.union_team_fight_info.ships
	end

	local resultBuffer = {}

	--初始化NPC 战斗缓存

	for k,v in pairs(data_path.fighting) do
		dms.unload(v)
		dms.load(v)
	end

	local npc = ConfigDB.load("npc",npcId)

	local battleCache = BattleCache:new()


	battleCache.userInfo = _ED.user_info
	battleCache.battleType = fightType
	battleCache.byAttackerId = npc.id
	battleCache.currentBattleCount = encryptInfo(0)
	battleCache.maxBattleCount = encryptInfo(npc.formationCount)
	self.maxBattleCount = encryptInfo(npc.formationCount)
	local attackObjects = {}
	-- 横扫千军增至9个阵型位 对应表中column
	local seatIndex = { environment_formation.seat_one, 
						environment_formation.seat_two, 
						environment_formation.seat_three,
						environment_formation.seat_four, 
						environment_formation.seat_five, 
						environment_formation.seat_six,
						environment_formation.seat_seven,
						environment_formation.seat_eight,
						environment_formation.seat_nine,
					}
	local tempRookieCache = _ED.user_info.rookieCache
	local seatArray = {}

	for idx = 1, 6 do
		-- 读取阵型 到 阵型Array
		seatArray[idx] = formation[idx + 1]
		-- 如果 Array中值不为0， 则存在user_ship的实例id数据
		if (tonumber(seatArray[idx]) > 0) then
			if( user_ships[ seatArray[idx] ] ~= nil) then
				-- 根据ship_id获得ship数据
				local userShip = user_ships[seatArray[idx]]
				-- debug.print_r(userShip)
				-- 生成英雄战斗实例 初始化fightObject数据
				local fightObject = FightObject:new()
				-- fightObject:initWithUserData(#attackObjects+1, userShip, 0, _ED.user_info.user_id)
				fightObject:initWithUserData(idx, userShip, 0, _ED.user_info.user_id, self.fightType)
				table.insert(attackObjects,fightObject)

				-- debug.print_r(userShip)

				--获得小兵模板参数
				local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], fightObject.shipMould, ship_mould.base_mould2))
				local forceCount = dms.atos(forceMould,ship_force_mould.force_count)
				-- print("小兵模板",forceCount)
				-- 生成小兵战斗实例 
				for i=1,forceCount do
					local forceFightObject = fightObject:fightObject(forceMould,userId)			 
					 forceFightObject.coordinate=#attackObjects+1

					forceFightObject.level = fightObject.level           --设置npc小兵等级
					forceFightObject.battleTag = fightObject.battleTag

					 -- table.insert(attackObjects,forceFightObject)
					 table.insert(fightObject.forceArray,forceFightObject)					
				end
			else
				attackObjects[idx] = nil
			end
		else
			attackObjects[idx] = nil
		end
	end
	-- 战力值
	battleCache.attackCombatForce = _ED.user_info.fighter_capacity

	-- 将已方战斗实例数据都加入 battleCache
	battleCache.attackName = _ED.user_info.user_name
	battleCache.attackerObjects = attackObjects

	local byAttackerObjectsList = {}
	-- 根据关卡npc数据创建 敌方角色实例 npc.formationCount代表关卡分段数量
	for i = 1, npc.formationCount do
		local byAttackObjects = {}
		-- 获得关卡阵型id
		local formationId = npc:getEnvironmentFormation(i)
		if self.fightType == battle_enum._fight_type._fight_type_104 then
			formationId = _ED._seven_star_formation
		end
		-- 获得关卡阵型行数据
		local environmentFormation = ConfigDB.load("environment_formation", formationId)
		seatArray = {}
		local environment_ship_id = 0
		local environment_formation_element = dms.element(dms["environment_formation"], formationId)
		for idx, val in pairs(seatIndex) do
			environment_ship_id = dms.atoi(environment_formation_element, val)
			seatArray[#seatArray + 1] = environment_ship_id
		end
		-- 实例放大系数
		local amplifyPercentString = dms.atos(environment_formation_element, environment_formation.amplify_percentage)
		local amplifyPercentArray = zstring.split(amplifyPercentString, ",")

		-- 根据阵型数据生成 战斗实例数据  seatArray 放environment_ship的id
		for j, val in ipairs(seatArray) do
			if(nil ~= val and 0 ~= tonumber(val)) then
				local fightObject = FightObject:new()
				-- fightObject:initWithNpc(npc, difficulty, #byAttackObjects+1, seatArray[j], self.fakeLevel, self.isFake)
				fightObject:initWithNpc(npc, difficulty, j, seatArray[j], self.fakeLevel, self.isFake)
				fightObject.amplifyPercent = amplifyPercentArray[j]

				-- 关卡中承载阵型数据 敌方角色使用阵型数据名字
				fightObject.name = environmentFormation.formationName
				-- byAttackObjects[j] = fightObject
				table.insert(byAttackObjects,fightObject)

				--小兵模板  val = environment_ship_id
				-- local force_mould_index = dms.int(dms["environment_ship"], tonumber(val), environment_ship.capacity) 
				-- -- 
				-- local dms.int(dms["environment_ship"], force_mould_index)
				local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], 
					dms.string(dms["environment_ship"], tonumber(val),environment_ship.directing), 
					ship_mould.base_mould2))
				local forceCount = dms.atos(forceMould,ship_force_mould.force_count)

				-- print("小兵模板",forceCount)
				for i=1,forceCount do
					local forceFightObject = fightObject:fightObject(forceMould,userId)
					 -- 位置
					 forceFightObject.coordinate = #byAttackObjects+1

					forceFightObject.level = fightObject.level           --设置npc小兵等级
					forceFightObject.battleTag = fightObject.battleTag

					 -- table.insert(byAttackObjects,forceFightObject)
					 table.insert(fightObject.forceArray,forceFightObject)
				end
			end
		end
		table.insert(byAttackerObjectsList, byAttackObjects)

		-- 战力值
		battleCache.byAttackComobatForce = environmentFormation.combatForce
	end
	-- 将敌方战斗实例数据都加入 battleCache 
	battleCache.byAttackName = npc.npcName
	battleCache.byAttackerObjectsList = byAttackerObjectsList

	_ED.user_info.battleCache = battleCache
	-- self:writeBattleFieldInit(battleCache,  0,  1, resultBuffer)
	-- local temp ="战场初始化\r\n"
	-- for k = 1, #resultBuffer do
	-- 	temp = temp..resultBuffer[k]
	-- end
	-- print(temp)
	-- self:initNewBattleInfo()
end

function FightModule:initNewBattleFieldEx(npcId,fightType)
	--清空战斗缓存
	_ED.user_info.battleCache = nil
	
	self.fightType = fightType

	local resultBuffer = {}

	--初始化NPC 战斗缓存

	local attackNpc = ConfigDB.load("npc", _ED._attacker_npc_id)
	local npc = ConfigDB.load("npc", npcId)

	local battleCache = BattleCache:new()

	battleCache.userInfo = _ED.user_info
	battleCache.battleType = fightType
	battleCache.byAttackerId = npc.id
	battleCache.currentBattleCount = encryptInfo(0)
	battleCache.maxBattleCount = encryptInfo(npc.formationCount)
	self.maxBattleCount = encryptInfo(npc.formationCount)
	local attackObjects = {}
	-- 横扫千军增至9个阵型位 对应表中column
	local seatIndex = { environment_formation.seat_one, 
						environment_formation.seat_two, 
						environment_formation.seat_three,
						environment_formation.seat_four, 
						environment_formation.seat_five, 
						environment_formation.seat_six,
						environment_formation.seat_seven,
						environment_formation.seat_eight,
						environment_formation.seat_nine,
					}
	local tempRookieCache = _ED.user_info.rookieCache
	local seatArray = {}

	for i = 1, attackNpc.formationCount do
		local byAttackObjects = {}
		-- 获得关卡阵型id
		local formationId = attackNpc:getEnvironmentFormation(i)

		-- 获得关卡阵型行数据
		local environmentFormation = ConfigDB.load("environment_formation", formationId)
		seatArray = {}
		local environment_ship_id = 0
		local environment_formation_element = dms.element(dms["environment_formation"], formationId)
		for idx, val in pairs(seatIndex) do
			environment_ship_id = dms.atoi(environment_formation_element, val)
			seatArray[#seatArray + 1] = environment_ship_id
		end
		-- 实例放大系数
		local amplifyPercentString = dms.atos(environment_formation_element, environment_formation.amplify_percentage)
		local amplifyPercentArray = zstring.split(amplifyPercentString, ",")

		-- 根据阵型数据生成 战斗实例数据  seatArray 放environment_ship的id
		for j, val in ipairs(seatArray) do
			if(nil ~= val and 0 ~= tonumber(val)) then
				local fightObject = FightObject:new()
				-- fightObject:initWithNpc(npc, difficulty, #byAttackObjects+1, seatArray[j], self.fakeLevel, self.isFake)
				fightObject:initWithNpc(attackNpc, difficulty, j, seatArray[j], self.fakeLevel, self.isFake)
				fightObject.amplifyPercent = amplifyPercentArray[j]

				-- 关卡中承载阵型数据 敌方角色使用阵型数据名字
				fightObject.name = environmentFormation.formationName
				-- byAttackObjects[j] = fightObject
				table.insert(attackObjects,fightObject)
				--小兵模板  val = environment_ship_id
				-- local force_mould_index = dms.int(dms["environment_ship"], tonumber(val), environment_ship.capacity) 
				-- -- 
				-- local dms.int(dms["environment_ship"], force_mould_index)
				local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], 
					dms.string(dms["environment_ship"], tonumber(val),environment_ship.directing), 
					ship_mould.base_mould2))
				local forceCount = dms.atoi(forceMould, ship_force_mould.force_count)

				-- print("小兵模板",forceCount)
				for i=1,forceCount do
					local forceFightObject = fightObject:fightObject(forceMould,userId)
					 -- 位置
					forceFightObject.coordinate = #attackObjects+1

					forceFightObject.level = fightObject.level           --设置npc小兵等级
					forceFightObject.battleTag = fightObject.battleTag

					-- table.insert(byAttackObjects,forceFightObject)
					table.insert(fightObject.forceArray,forceFightObject)
				end
			end
		end
		battleCache.attackComobatForce = environmentFormation.combatForce
	end
	-- 将已方战斗实例数据都加入 battleCache
	battleCache.attackName = _ED.user_info.user_name
	battleCache.attackerObjects = attackObjects

	local byAttackerObjectsList = {}
	-- 根据关卡npc数据创建 敌方角色实例 npc.formationCount代表关卡分段数量
	for i = 1, npc.formationCount do
		local byAttackObjects = {}
		-- 获得关卡阵型id
		local formationId = npc:getEnvironmentFormation(i)

		-- 获得关卡阵型行数据
		local environmentFormation = ConfigDB.load("environment_formation", formationId)
		seatArray = {}
		local environment_ship_id = 0
		local environment_formation_element = dms.element(dms["environment_formation"], formationId)
		for idx, val in pairs(seatIndex) do
			environment_ship_id = dms.atoi(environment_formation_element, val)
			seatArray[#seatArray + 1] = environment_ship_id
		end
		-- 实例放大系数
		local amplifyPercentString = dms.atos(environment_formation_element, environment_formation.amplify_percentage)
		local amplifyPercentArray = zstring.split(amplifyPercentString, ",")

		-- 根据阵型数据生成 战斗实例数据  seatArray 放environment_ship的id
		for j, val in ipairs(seatArray) do
			if(nil ~= val and 0 ~= tonumber(val)) then
				local fightObject = FightObject:new()
				-- fightObject:initWithNpc(npc, difficulty, #byAttackObjects+1, seatArray[j], self.fakeLevel, self.isFake)
				fightObject:initWithNpc(npc, difficulty, j, seatArray[j], self.fakeLevel, self.isFake)
				fightObject.amplifyPercent = amplifyPercentArray[j]

				-- 关卡中承载阵型数据 敌方角色使用阵型数据名字
				fightObject.name = environmentFormation.formationName
				-- byAttackObjects[j] = fightObject
				table.insert(byAttackObjects,fightObject)

				--小兵模板  val = environment_ship_id
				-- local force_mould_index = dms.int(dms["environment_ship"], tonumber(val), environment_ship.capacity) 
				-- -- 
				-- local dms.int(dms["environment_ship"], force_mould_index)
				local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], 
					dms.string(dms["environment_ship"], tonumber(val),environment_ship.directing), 
					ship_mould.base_mould2))
				local forceCount = dms.atos(forceMould,ship_force_mould.force_count)

				-- print("小兵模板",forceCount)
				for i=1,forceCount do
					local forceFightObject = fightObject:fightObject(forceMould,userId)
					 -- 位置
					 forceFightObject.coordinate = #byAttackObjects+1

					forceFightObject.level = fightObject.level           --设置npc小兵等级
					forceFightObject.battleTag = fightObject.battleTag

					 -- table.insert(byAttackObjects,forceFightObject)
					 table.insert(fightObject.forceArray,forceFightObject)
				end
			end
		end
		table.insert(byAttackerObjectsList, byAttackObjects)

		-- 战力值
		battleCache.byAttackComobatForce = environmentFormation.combatForce
	end
	-- 将敌方战斗实例数据都加入 battleCache 
	battleCache.byAttackName = npc.npcName
	battleCache.byAttackerObjectsList = byAttackerObjectsList

	_ED.user_info.battleCache = battleCache
	-- self:writeBattleFieldInit(battleCache,  0,  1, resultBuffer)
	-- local temp ="战场初始化\r\n"
	-- for k = 1, #resultBuffer do
	-- 	temp = temp..resultBuffer[k]
	-- end
	-- print(temp)
	-- self:initNewBattleInfo()
end

function FightModule:initWithPartner( partner_id )
	local formation_index = 0
	local formetion_list = {"", "", "", "", "", "", "", "", ""}
	for i, v in pairs(_ED.user_info.battleCache.attackerObjects) do
		formetion_list[v.coordinate] = nil
	end
	local directing = dms.int(dms["environment_ship"], partner_id, environment_ship.directing)
	local capacity = dms.int(dms["ship_mould"], directing, ship_mould.capacity)
	if capacity <= 3 then
		capacity = 1
	elseif capacity <= 6 then
		capacity = 4
	else
		capacity = 7
	end
	for i, v in pairs(formetion_list) do
		if v ~= nil and i >= capacity then
			formation_index = i
			break
		end
	end

	local fightObject = FightObject:new()
	-- fightObject:initWithNpc(npc, difficulty, #byAttackObjects+1, seatArray[j], self.fakeLevel, self.isFake)
	fightObject:initWithNpc(nil, 0, formation_index, partner_id, nil, nil, true)
	fightObject.amplifyPercent = "1"

	-- 关卡中承载阵型数据 敌方角色使用阵型数据名字
	fightObject.name = ""--environmentFormation.formationName

	--小兵模板  val = environment_ship_id
	-- local force_mould_index = dms.int(dms["environment_ship"], tonumber(val), environment_ship.capacity) 
	-- -- 
	-- local dms.int(dms["environment_ship"], force_mould_index)
	local forceMould = dms.element(dms["ship_force_mould"], dms.string(dms["ship_mould"], 
		dms.string(dms["environment_ship"], partner_id, environment_ship.directing), 
		ship_mould.base_mould2))

	local forceCount = dms.atos(forceMould,ship_force_mould.force_count)

	-- print("小兵模板",forceCount)
	for i=1,forceCount do
		local forceFightObject = fightObject:fightObject(forceMould,userId, true)
		 -- 位置
		forceFightObject.coordinate = formation_index+1

		forceFightObject.level = fightObject.level           --设置npc小兵等级
		forceFightObject.battleTag = fightObject.battleTag

		 -- table.insert(byAttackObjects,forceFightObject)
		 table.insert(fightObject.forceArray,forceFightObject)
	end
	local count = table.getn(_ED.user_info.battleCache.attackerObjects)
	_ED.user_info.battleCache.attackerObjects[count + 1] = fightObject
end

function FightModule:initNewBattleInfo()
	local battleCache = _ED.user_info.battleCache
	if battleCache == nil or decryptInfo(battleCache.currentBattleCount) >= decryptInfo(battleCache.maxBattleCount) then
		return false
	end
	-- 清空战斗对象缓存
	self.heroBattleObjects = {}
	self.armyBattleObjects = {}

	if battleCache == nil then
		return false
	end
	-- 攻击方战斗实例数据
	local attackObjects = battleCache.attackerObjects
	battleCache.currentBattleCount = encryptInfo(decryptInfo(battleCache.currentBattleCount) + 1)

	-- 防守方战斗实例数据
	local byAttackObjects = battleCache.byAttackerObjectsList[decryptInfo(battleCache.currentBattleCount)]
  	
	local attackObject = nil
	local byAttackObject = nil
	for i, atkObj in pairs(attackObjects) do
		if(nil ~= attackObjects[i]) then
			local battleObject = BattleObject:new()
			-- 用attackObject 初始化
			battleObject:initWithAttackObject(attackObjects[i])
			self.attackObjects[i] = battleObject
			-- self.shipCount = self.shipCount + 1
			-- self.totalHealth = self.totalHealth + battleObject.healthMaxPoint
			attackObject = battleObject
			if #battleObject.forceObjects >= 0 then
				table.insert(self.heroBattleObjects, battleObject)
			end
		end		
	end

	for i, atkObj in pairs(byAttackObjects) do
		if(nil ~= byAttackObjects[i])then
			local battleObject = BattleObject:new()
			battleObject:initWithAttackObject(byAttackObjects[i])
			self.byAttackObjects[i] = battleObject
			-- self.npcMaxHealth = self.npcMaxHealth + battleObject.healthMaxPoint
			byAttackObject = battleObject
			if #battleObject.forceObjects >= 0 then
				table.insert(self.armyBattleObjects,battleObject)
			end
		end
	end

	self:calculateTalentUnite(self.attackObjects, self.byAttackObjects)
	
	self:fightByAttackObject(attackObject,byAttackObject)
	return true
end

--指定A角色攻击B角色
function FightModule:fightByAttackObject(battleObject,byBattleObject)
	--只要有一个人死亡就不处理攻击逻辑
	if battleObject.isDead == true or byBattleObject.isDead == true then
		return
	end
	local resultBuffer = {}
	table.insert(resultBuffer, battleObject.battleTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, battleObject.coordinate)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, 0)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, 0)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, 0)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, battleObject.commonSkillMould.id)
	table.insert(resultBuffer, IniUtil.compart)
	battleObject:processUserBuffEffect(userInfo, self, resultBuffer)
	local battleSkillList = battleObject.oneselfBattleSkill
	local skillBuffer = {}
	self.battleSkillCount = 0
	for _, battleSkill in pairs(battleSkillList) do
		battleSkill.formulaInfo = battleSkill.skillInfluence.formulaInfo
		battleSkill:processOneAttack(userInfo,battleObject, byBattleObject, self, skillBuffer)
	end
	table.insert(resultBuffer, self.battleSkillCount)
	table.insert(resultBuffer, IniUtil.compart)
	IniUtil.concatTable(resultBuffer, skillBuffer)
	-- local temp ="战斗数据\r\n"
	-- for k = 1, #resultBuffer do
	-- 	temp = temp..resultBuffer[k]
	-- end
	-- print(temp)
end


--[[
--   attackUser 包含了服务器传过来的数据  attackUser.fightForce  为 战力, attackUser.fightObjects 为战斗对象, nickname 为昵称
]]---

function FightModule:initBattleField(npc, difficulty, fightType, resultBuffer,eveNpc)
	self.fightType = fightType
	local battleCache = BattleCache:new()
	battleCache.userInfo =  _ED.user_info
	battleCache.battleType = fightType
	battleCache.byAttackerId = npc.id
	battleCache.maxBattleCount = encryptInfo(npc.formationCount)
	battleCache.difficulty = difficulty
	local attackObjects = {}
	local seatIndex = {environment_formation.seat_one, environment_formation.seat_two, environment_formation.seat_three,
		environment_formation.seat_four, environment_formation.seat_five, environment_formation.seat_six}
	local tempRookieCache = _ED.user_info.rookieCache
	local seatArray = {}
	
	
	if(tonumber(fightType) == 1)then
		
		for idx, val in ipairs(seatIndex) do
			seatArray[#seatArray + 1] = dms.int(dms["environment_formation"], eveNpc, val)
		end	
		

		for idx, val in ipairs(seatArray) do
			if(nil ~= val and 0 ~= val) then
				local fightObject = FightObject:new()
				fightObject:initWithNpc(npc, difficulty, idx, seatArray[idx], self.fakeLevel, self.isFake)
				fightObject.battleTag = 0
				attackObjects[idx] = fightObject
			end
		end

		battleCache.attackCombatForce = dms.int(dms["environment_formation"], eveNpc, environment_formation.combat_force)
	else
		-- 此处本来应该从 服务器传过来, 本地保存的数据取的, 目前写死. 本人是知道 相关数据的
		--local formation = UserDB.findByUserAndIndex(attackUser.id,  1)
		--seatArray = new Integer[]{formation.seatOne, formation.seatTwo, formation.seatThree, formation.seatFour, formation.seatFive, formation.seatSix}
		seatArray = {}
		for idx = 1, 6 do
			seatArray[idx] = _ED.formetion[idx + 1]
			--_crint ("idx .. ": " .. seatArray[idx])
			if (tonumber(seatArray[idx]) > 0) then
				if( _ED.user_ship[ seatArray[idx] ] ~= nil) then
					local fightObject = FightObject:new()
					fightObject:initWithUserData(idx, _ED.user_ship[seatArray[idx]], 0, _ED.user_info.user_id)
					attackObjects[idx] = fightObject
					
				else
					attackObjects[idx] = nil
					--_crint ("Ship not found in user_ship: " .. seatArray[idx])
				end
				--local fightObject = FightObject:new()
				--attackObjects[idx] = fightObject:initWithUserData(_ED)
			else
				--_crint("Set to nil: " .. tonumber(seatArray[idx]))
				attackObjects[idx] = nil
			end
		end
		
		battleCache.attackCombatForce = _ED.user_info.fighter_capacity
	end
	--_crint ("Attack object seat array info: " .. #attackObjects)
	--crint_lua_table(_ED.formetion)
	--_crint ("End print _ED.formetion")
	--crint_lua_table(seatArray)
	for _, attackObject in pairs(attackObjects) do
		if (attackObject ~= nil) then
			--_crint ("Pos " .. _  .. " id: " ..attackObject.id)
		else
			--_crint ("Pos " .. _  .. " is nil")
		end
	end
	
	battleCache.attackName = _ED.user_info.user_name
	battleCache.attackerObjects = attackObjects
	local byAttackerObjectsList = {}
	--_crint ("npc.formationCount = ".. npc.formationCount)
	for i = 1, npc.formationCount do
		local byAttackObjects = {}
		local formationId = npc:getEnvironmentFormation(i)

		--_crint ("loading formation, id: " .. formationId .. "   npc: " .. npc.id)
		local environmentFormation = ConfigDB.load("environment_formation", formationId)
		--EnvironmentFormation:new()
		--environmentFormation:init(dms.element(dms["environment_formation"], formationId))
		
		seatArray = {}
		for idx, val in ipairs(seatIndex) do
			local shipId = dms.int(dms["environment_formation"], formationId, val)
			seatArray[#seatArray + 1] = shipId
			--_crint ("NPC shipId" , i, idx, shipId)
		end
		
		local amplifyPercentString = dms.string(dms["environment_formation"], formationId, environment_formation.amplify_percentage)
		local amplifyPercentArray = zstring.split(amplifyPercentString, IniUtil.comma)
		 
		for j, val in ipairs(seatArray) do
			if(nil ~= val and 0 ~= tonumber(val)) then
				local fightObject = FightObject:new() --(npc, difficulty, j + 1, seatArray[j], fakeLevel, isFake)
				--_crint("Calling: ", j, seatArray[j], self.fakeLevel, self.isFake)
				fightObject:initWithNpc(npc, difficulty, j, seatArray[j], self.fakeLevel, self.isFake)
				fightObject.amplifyPercent = amplifyPercentArray[j]
				fightObject.name = environmentFormation.formationName
				byAttackObjects[j] = fightObject
			end
		end

		battleCache.byAttackComobatForce = environmentFormation.combatForce
		
		--_crint ("ByAttack object seat array info: ")
		--crint_lua_table(seatArray)
		for _, attackObject in pairs(byAttackObjects) do
			if (attackObject ~= nil) then
				--_crint(_, attackObject.id)
				----crint_lua_table (attackObject)
			else
				--_crint ("Pos " .. _  .. " is nil")
			end
		end
	
		table.insert(byAttackerObjectsList, byAttackObjects)
	end
	
	
	
	battleCache.byAttackName = npc.npcName
	-- if (true) then
	-- _crint ("战场初始化：",#byAttackerObjectsList)
	-- end
	
	battleCache.byAttackerObjectsList = byAttackerObjectsList
	_ED.user_info.battleCache = battleCache
	
	----_crint("Dump battleCache info")
	
	
	self:writeBattleFieldInit(battleCache,  0,  1, resultBuffer)
	--writeFashionEquipmentInit(attackUser, nil, resultBuffer)
	-- self:initFightOrder(_ED.user_info,resultBuffer)
end

-- function FightModule:initBattleField(attackUser, byAttackUser, fightType, resultBuffer)
		-- self.fightType = fightType
		-- BattleCache battleCache = new BattleCache()
		-- battleCache.userInfo=attackUser
		-- battleCache.battleType=fightType
		-- battleCache.byAttackerId=byAttackUser.id
		-- battleCache.maxBattleCount=(byte) 1
		-- battleCache.difficulty=(byte) 1
		-- FightObject[] attackObjects = new FightObject[6]
		-- Formation formation = UserDB.findByUserAndIndex(attackUser.id,  1)
		-- Integer seatArray[] = new Integer[]{formation.seatOne, formation.seatTwo, formation.seatThree, formation.seatFour, formation.seatFive, formation.seatSix}
		-- for (local i = 0; i < seatArray.length; i++) {
			-- if(nil ~= seatArray[i] and 0 ~= seatArray[i]){
				-- FightObject fightObject = new FightObject((byte) (i + 1), seatArray[i],  0)
				-- attackObjects[i] = fightObject
			-- }
		-- }
		-- battleCache.attackerObjects=attackObjects
		-- battleCache.attackCombatForce=formation.combatForce
		-- battleCache.attackName=attackUser.nickname
		-- List<FightObject[]> byAttackerObjectsList = new ArrayList<FightObject[]>()
		-- FightObject[] byAttackObjects = new FightObject[6]
		-- Formation byFormation = UserDB.findByUserAndIndex(byAttackUser.id,  1)
		-- Integer bySeatArray[] = new Integer[]{byFormation.seatOne, byFormation.seatTwo, byFormation.seatThree, byFormation.seatFour, byFormation.seatFive, byFormation.seatSix}
		-- for (local i = 0; i < bySeatArray.length; i++) {
			-- if(nil ~= bySeatArray[i] and 0 ~= bySeatArray[i]){
				-- FightObject fightObject = new FightObject((byte) (i + 1), bySeatArray[i],  1)
				-- byAttackObjects[i] = fightObject
			-- }
		-- }
		-- byAttackerObjectsList.add(byAttackObjects)
		-- battleCache.byAttackName=byAttackUser.nickname
		-- battleCache.byAttackComobatForce=byFormation.combatForce
		-- battleCache.byAttackerObjectsList=byAttackerObjectsList
		-- attackUser.battleCache=battleCache
		-- UserViceCaptainInfo userViceCaptainInfo = nil
		-- if(userViceCaptainInfo == nil){
			-- userViceCaptainInfo = new UserViceCaptainInfo()
		-- }
		-- battleCache.userViceCaptainInfo=userViceCaptainInfo
		-- UserViceCaptainInfo byUserViceCaptainInfo = nil
		-- if(byUserViceCaptainInfo == nil){
			-- byUserViceCaptainInfo = new UserViceCaptainInfo()
		-- }
		-- battleCache.byUserViceCaptainInfo=byUserViceCaptainInfo
		-- writeBattleFieldInit(battleCache,  0,  0, resultBuffer)
		-- writeFashionEquipmentInit(attackUser, byAttackUser, resultBuffer)
-- end

-- function FightModule:initThreeBattleField(attackUser, npc, difficulty, fightType, resultBuffer)
		-- self.fightType = fightType
		-- BattleCache battleCache = new BattleCache()
		-- battleCache.userInfo=attackUser
		-- battleCache.battleType=fightType
		-- battleCache.byAttackerId=npc.id
		-- battleCache.maxBattleCount=(byte)1
		-- battleCache.difficulty=difficulty
		-- FightObject[] attackObjects = new FightObject[6]
		-- Integer seatArray[] = nil
		-- Formation formation = UserDB.findByUserAndIndex(attackUser.id,  1)
		-- seatArray = new Integer[]{formation.seatOne, formation.seatTwo, formation.seatThree, formation.seatFour, formation.seatFive, formation.seatSix}
		-- for (local i = 0; i < seatArray.length; i++) {
			-- if(nil ~= seatArray[i] and 0 ~= seatArray[i]){
				-- FightObject fightObject = new FightObject((byte) (i + 1), seatArray[i],  0)
				-- fightObject.finalDamagePercent=worldBossDamageAdditional
				-- if(self.userThreeKingdomsInfo ~= nil){
					-- fightObject.addPropertyByInfluenceValue(userThreeKingdomsInfo.attribute)
				-- }
				-- attackObjects[i] = fightObject
			-- }
		-- }
		-- battleCache.attackCombatForce=formation.combatForce
		-- battleCache.attackName=attackUser.nickname
		-- battleCache.attackerObjects=attackObjects
		-- List<FightObject[]> byAttackerObjectsList = new ArrayList<FightObject[]>()
		-- FightObject[] byAttackObjects = new FightObject[6]
		-- Integer formationId = npc.getEnvironmentFormation(difficulty)
		-- EnvironmentFormation environmentFormation = (EnvironmentFormation)ConfigDB.load("EnvironmentFormation", formationId)
		-- String amplifyPercentArray[] = environmentFormation.amplifyPercentage.split(IniUtil.comma)
		-- seatArray = new Integer[]{environmentFormation.seatOne, environmentFormation.seatTwo, environmentFormation.seatThree, environmentFormation.seatFour, environmentFormation.seatFive, environmentFormation.seatSix}
		-- for (local j = 0; j < seatArray.length; j++) {
			-- if(nil ~= seatArray[j] and 0 ~= seatArray[j]){
				-- FightObject fightObject = new FightObject(npc, difficulty,  (j + 1), seatArray[j], fakeLevel, isFake)
				-- fightObject.amplifyPercent=amplifyPercentArray[j]
				-- fightObject.name=environmentFormation.formationName
				-- byAttackObjects[j] = fightObject
			-- }
		-- }
		-- battleCache.byAttackComobatForce=environmentFormation.combatForce
		-- byAttackerObjectsList.add(byAttackObjects)
 		-- battleCache.byAttackName=npc.npcName
		-- battleCache.byAttackerObjectsList=byAttackerObjectsList
		-- attackUser.battleCache=battleCache
		-- UserViceCaptainInfo userViceCaptainInfo = nil
		-- if(userViceCaptainInfo == nil){
			-- userViceCaptainInfo = new UserViceCaptainInfo()
		-- }
		-- battleCache.userViceCaptainInfo=userViceCaptainInfo
		-- userViceCaptainInfo = new UserViceCaptainInfo()
		-- battleCache.byUserViceCaptainInfo=userViceCaptainInfo
		-- writeBattleFieldInit(battleCache,  0,  1, resultBuffer)
		-- writeFashionEquipmentInit(attackUser, nil, resultBuffer)
-- end

-- 初始化战斗信息
function FightModule:initBattleInfo(battleCache)
	self.fightResult = 0
	self.hasNextRound = true
	self.npcMaxHealth = 0
	self.roundCount = 1
	self.shipCount = 0
	local attackObjects = battleCache.attackerObjects

	local byAttackObjects = battleCache.byAttackerObjectsList[decryptInfo(battleCache.currentBattleCount) + 1]
	--for (local i = 0; i < attackObjects.length; i++) {
	for i, atkObj in pairs(attackObjects) do
		if(nil ~= attackObjects[i]) then
			local battleObject = BattleObject:new()
			battleObject:initWithAttackObject(attackObjects[i])
			if(self.attackObjects[i] ~= nil) then
				battleObject.zomlllSkillPoint = self.attackObjects[i].zomlllSkillPoint
			end
			self.attackObjects[i] = battleObject
			self.shipCount = self.shipCount + 1
			self.totalHealth = self.totalHealth + battleObject.healthMaxPoint
		end		
	end
	--for (local i = 0; i < byAttackObjects.length; i++) {
	for i, atkObj in pairs(byAttackObjects) do
		if(nil ~= byAttackObjects[i])then
			local battleObject = BattleObject:new()
			battleObject:initWithAttackObject(byAttackObjects[i])
			self.byAttackObjects[i] = battleObject
			self.npcMaxHealth = self.npcMaxHealth + battleObject.healthMaxPoint
		end
	end
	if(battleCache.battleType == FightModule.FIGHT_TYPE_PVE_MONEY_TREE) then
		self.fightType = FightModule.FIGHT_TYPE_PVE_MONEY_TREE
		self.totalRound = 5
	end
	if(battleCache.battleType == FightModule.FIGHT_TYPE_PVE_REBELARMY) then
		self.fightType = FightModule.FIGHT_TYPE_PVE_REBELARMY
		self.totalRound = 5
	end
	if(battleCache.battleType == FightModule.FIGHT_TYPE_DAILY_INSTANCE) then
		self.totalRound = self.dailyRoundCount
	end
	self:calculateTalentUnite(self.attackObjects, self.byAttackObjects)
	--initRebelArmy()
end

function FightModule:calculateTalentAuraInfluence(battleObjects)
	local tmpBattleObjects = battleObjects
	for idx, tmpBattleObject in  ipairs(tmpBattleObjects) do
		if(nil ~= tmpBattleObject) then				
			for idx2, talentMould in ipairs(tmpBattleObject.talentMouldList) do
				if(talentMould.influencePriorType ~= -1) then
					if(talentMould.influencePriorType <= 5) then
						for _, battleObject in ipairs( battleObjects) do
							if(nil == battleObject or tmpBattleObject.id == battleObject.id) then
								--continue
							else
								self:calculateTalentAuraInfluence(talentMould, battleObject)
							end
						end
					elseif(talentMould.influencePriorType == TalentConstant.JUDGE_OPPORTUNITY_EMAMY_ATTACK 
							or talentMould.influencePriorType == TalentConstant.JUDGE_OPPORTUNITY_OWER_ATTACK) then
						--continue
					else
						for idx4, battleObject in ipairs(battleObjects) do
							if(nil ~= battleObject)then
								--continue
							else
								if(tmpBattleObject.id == battleObject.id) then
									self:calculateTalentAuraInfluence(talentMould, battleObject)
									break
								end
							end
						end
					end
				end
			end
		end
	end
end



function FightModule:calculateTalentUnite(attackObjects, byAttackObjects)
	local tmpBattleObjects = attackObjects
	for _, tmpBattleObject in pairs(tmpBattleObjects)  do
		if(nil == tmpBattleObject)then
			--continue
		else
			for _, talentMould in pairs(tmpBattleObject.talentMouldList) do
				if(talentMould.influenceJudgeOpportunity ~= -1) then
					if(talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_EMAMY_ATTACK) then
						for _, battleObject in pairs(byAttackObjects) do
							if(nil == battleObject) then
								--continue
							else
								FightModule:calculateTalentUnite(talentMould, battleObject, tmpBattleObject)
							end
						end
					elseif(talentMould.influenceJudgeOpportunity == TalentConstant.JUDGE_OPPORTUNITY_OWER_ATTACK) then
						for _, battleObject in pairs(attackObjects) do
							if(nil == battleObject)then
								--continue
							else
								if(tmpBattleObject.id == battleObject.id)then
									--continue
								else
									FightModule:calculateTalentUnite(talentMould, battleObject, tmpBattleObject)
								end
							end
						end
					end
				end
			end
		end
	end
end



function FightModule:calculateTalentAuraInfluence(talentMould, battleObject)
	local effectCount = -1
	local isActivate = false
	if (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_MALE ) then
		isActivate = battleObject.gender == 1
	elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_FEMALE) then
		isActivate = battleObject.gender == 2			
	elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_WEI) then
		isActivate = battleObject.campPreference == 1			
	elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_SHU) then
		isActivate = battleObject.campPreference == 2			
	elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_WU) then
		isActivate = battleObject.campPreference == 3			
	elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_QUN) then
		isActivate = battleObject.campPreference == 4
		
	elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT1) then
		isActivate = true
		effectCount = 1
		
	elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT2) then
		isActivate = true
		effectCount = 2
	end
	if(isActivate) then
		local effectType  = tonumber(zstring.split(talentMould.influencePriorValue, IniUtil.comma)[1])
		local effectValue = tonumber(zstring.split(talentMould.influencePriorValue, IniUtil.comma)[2])
		if(effectType == TalentConstant.INFLUENCE_PRIOR_VALUE_LIFE_ADDITIONAL_PERCENT) then
			battleObject.healthMaxPoint = math.floor(battleObject.healthMaxPoint * (1.0 + effectValue / 100.0))
			battleObject.healthPoint    = math.floor(battleObject.healthPoint * (1.0 + effectValue / 100.0))
		else				
			local talentAura = TalentAura:new()
			talentAura.effectCount = effectCount
			talentAura.effectType = effectType
			talentAura.effectValue = effectValue
			battleObject:pushTalentAuraList(talentAura)
		end
	end
end


function FightModule:calculateTalentUnite(talentMould, battleObject, extuteObject)
	local effectCount = -1
	local isActivate = false
	if (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_EM_WEI ) then
		isActivate = true
		
	elseif (talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_EM_SHU or
		talentMould.influencePriorType == TalentConstant.INFLUENCE_PRIOR_TYPE_EM_WU ) then
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_EM_QUN) then
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_EM_MALE) then
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_EM_FEMALE) then
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT3) then
		effectCount = 3
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT4) then
		effectCount = 4
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT5) then
		effectCount = 5
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT6) then
		effectCount = 6
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT7) then
		effectCount = 7
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT8) then
		effectCount = 8
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT9) then
		effectCount = 9
		isActivate = true
		
	elseif (talentMould.influencePriorType ==  TalentConstant.INFLUENCE_PRIOR_TYPE_SELF_COUNT10) then
		effectCount = 10
		isActivate = true
		
	end
	if(isActivate) then
		if( talentMould.influencePriorValue ~= "-1" ) then
			local effectType = tonumber(zstring.split(talentMould.influencePriorValue, IniUtil.comma)[1])
			local effectValue = tonumber(zstring.split(talentMould.influencePriorValue, IniUtil.comma)[2])
			if(effectType == TalentConstant.INFLUENCE_PRIOR_VALUE_LIFE_ADDITIONAL_PERCENT) then
				battleObject.healthMaxPoint = math.floor( (battleObject.healthMaxPoint * (1.0 + effectValue / 100.0)))
				battleObject.healthPoint    = math.floor( (battleObject.healthPoint * (1.0 + effectValue / 100.0)))
			elseif(effectCount == -1) then			
				local talentAura = TalentAura:new()
				talentAura.effectCount = effectCount
				talentAura.effectType = effectType
				talentAura.effectValue = effectValue
				battleObject.pushTalentAuraList(talentAura)
			end
		else
			local talentUniteSkill = TalentUniteSkill:new()
			talentUniteSkill.battleObject = extuteObject
			talentUniteSkill.effectCount = effectCount
			talentUniteSkill.talentMould = talentMould
			battleObject.pushTalentUniteSkillList(talentUniteSkill)
		end
	end	
end

--	获取下一个出手对象
--	k 当前出手序列号
--	从k往后开始循环寻找存活战斗对象.不包含k,如果k后面没有,从头开始找下一个出手的人
function FightModule:getNextFightObject(k,fightOrderList)
	local isFind = false
	local nextObject = nil
	for s, battleObject in pairs(fightOrderList) do
		if (s < k) then
			if isFind == false then
				if(battleObject.isDead) then
				else
					nextObject = battleObject
					isFind = true
				end
			end			
		elseif(s > k) then
			if(battleObject.isDead) then
			else
				nextObject = battleObject
				break;
			end
		else
		end
	end
	return nextObject
end

--	重置全部的出手状态
function FightModule:resetActionStatus()
	for s, battleObject in pairs(self.fightOrderList) do
		battleObject.isAction =  false
		--print("====================================================")
	end
end

--  【步骤1】
--	获取指定出手对象
--	参数:标示,方位
function FightModule:getAppointFightObject(battleTag,coordinate)
	--_crint("获取出手方人员数量：",#self.fightOrderList)
	for s, battleObject in pairs(self.fightOrderList) do
		if tonumber(battleObject.battleTag) == tonumber(battleTag) then			--指定攻击方
			if tonumber(battleObject.coordinate) == tonumber(coordinate) then	--指定攻击对象
				if(battleObject.isDead) then
					return nil
				else
					return battleObject
				end
			end
		end
	end
	return nil
end

--  初始化出手顺序
function FightModule:initFightOrder(userInfo, resultBuffer)
	local tempBattleCache = userInfo.battleCache
	local attackerCombatForce = tempBattleCache.attackCombatForce
	local byAttackerCombatForce = tempBattleCache.byAttackComobatForce
	self:initBattleInfo(tempBattleCache)
	self:initDailyInstance()
	
	local tempAttackObjects = self.attackObjects
	local tempByAttackObjects = self.byAttackObjects
	
	-- if (tonumber(attackerCombatForce) < tonumber(byAttackerCombatForce)) then
	-- 	tempAttackObjects = self.byAttackObjects
	-- 	tempByAttackObjects = self.attackObjects
	-- end	
	self.fightOrderList = {}
	--- 生成战战斗对象序列
	for i = 1, 6 do
		if (tempAttackObjects[i] ~= nil) then
			table.insert(self.fightOrderList, tempAttackObjects[i])
		end
	end
	for i = 1, 6 do
		if (tempByAttackObjects[i] ~= nil) then
			table.insert(self.fightOrderList, tempByAttackObjects[i])
		end
	end
end

--	获取下一个出手对象
--	从k往后开始循环寻找存活战斗对象.如果k后面没有,表示回合结束
function FightModule:getNextRoundFightObject(battleObject)
	local nextObject = nil
	local k  = 0
	for s, tempObject in pairs(self.fightOrderList) do
		if(tempObject.isDead) then
		else
			if(battleObject.battleTag == tempObject.battleTag) then
				if(battleObject.coordinate == tempObject.coordinate)then 
					k = s
				end
			end
		end
		if(k ~= 0) then
			if(s > k) then
				if(tempObject.isDead) then
				else
					nextObject = tempObject
					break;
				end
			end
		end
	end
	return nextObject
end


--	是否出手对象列表对象都未出手过
function FightModule:getBattleObjectSite()
	local k  = 1
	-- 出手对象列表	table 顺序取出
	for s, tempObject in pairs(self.fightOrderList) do
		if(tempObject.isDead) or tempObject == nil then
		else
--			print("+*****+",tempObject.battleTag,tempObject.coordinate,tempObject.isAction)
			-- 如果有出过出手就返回 0 否则返回 1
			if(tempObject.isAction == true) then
				k = 0
				break
			end
		end
	end
	return k
end


--	检测我方是否除自身以外其他人都出手过了
function FightModule:findIsAllAttack(battleObject)
	for s, tempObject in pairs(self.attackObjects) do
		if(tempObject.isDead) or tempObject == nil then
		else
			if(tempObject.isAction ~= true and tonumber(battleObject.coordinate) ~= tonumber(tempObject.coordinate)) then
				return 0
			end
		end
	end
	return 1
end


--	检测我方是否只剩眩晕的人未出手
function FightModule:checkLessIsDizzy()
	for s, tempObject in pairs(self.attackObjects) do
		if tempObject ~= nil and tempObject.isDead ~= true and tempObject.isAction ~= true then
			if tempObject.isDizzy ~= true then
				return false
			end
		end
	end
	return true
end

function FightModule:checkAttackObject( ... )
	-- body
end

-- 【步骤2】【分支1】
-- 获取单一对象的攻击数据 BattleReport 用于查看数据
function FightModule:fightObjectAttack(attackObject,resultBuffer)

	-- 获取的出手对象 从FightModule:getAppointFightObject获取
	local battleObject = attackObject
--	print("出手",battleObject.battleTag,battleObject.coordinate,battleObject.zomlllSkillPoint)

	-- 战斗结束标签初始化
	local attackOver = 0

	--	是否出手对象列表对象都未出手过 1. 都没出手 2.有过出手的对象
	local isFirst = self:getBattleObjectSite()

	--	检测我方是否除都出手过
	local isLast = self:findIsAllAttack(battleObject)

	-- 逻辑处理:都出手状态
	if(tonumber(isLast) == 1) then 
		-- 手操评分
		-- self.greadCount = 0
		-- self.roundCount = self.roundCount+1
	end
	-- 逻辑处理:都未出手状态
	if(tonumber(isFirst) == 1) then 
		-- 处理 isAction = false 与  isFirst == 1 可废弃
		-- self:resetActionStatus()
		-- 重置 手操伤害加成  可废弃
		-- self:clearAttacksStatus()
	end

--	print("请求战斗",battleObject.isAction)
	if (battleObject.isAction == true) then
		return
	end

	--记录当前出手对象
	self.currentObject  = battleObject
	--获取下一个出手对象 
	-- self.nextFightObject = self:getNextFightObject(attackObject,self.fightOrderList)
	-- --_crint("下一个出手坐标："..self.nextFightObject.battleTag..self.nextFightObject.coordinate)

	--设置出手状态
	-- battleObject.isAction = true

	self.counterBuffer = nil
	self.battleSkillCount = 0
	self.battleSkillBuffer = {}
	self.headBuffer = {}
	self.bodyBuffer = {}
	self.buffBuffer = {}
	self.fitBuffer = nil
	battleObject.fitBattleObjects = {}
	battleObject.effectDamage = 0
	battleObject.totalEffectDamage = 0
	battleObject.byEffectCoordinateList = nil

	-- battleTag == 0 代表Npc, 否则为 User
	-- 检查战斗对象 合体技能
	if(battleObject.battleTag == 0) then
		-- 
		battleObject:checkBattleObject(self.attackObjects)
	else
		battleObject:checkBattleObject(self.byAttackObjects)
	end

	local hasZoumarSkill = false
	-- 检查是否有合体技能	
	if(battleObject.battleTag == 0) then
		hasZoumarSkill = battleObject:checkState(self.attackObjects)
	else
		hasZoumarSkill = battleObject:checkState(self.byAttackObjects)
	end

	-- 如果角色为空，则清空攻击或受击对象队列, 然后将其从战斗序列fightOrderList中移除
	if(battleObject.isDead ) then
		if(battleObject.battleTag == 0) then
			self.attackObjects[battleObject.coordinate ] = nil
		else
			self.byAttackObjects[battleObject.coordinate ] = nil
		end
		-- 哪里来的k???
		self.fightOrderList[k] = nil
	else
		-- 如果晕眩状态
		if(battleObject.isDizzy) then
			if (attackOver ~= 0) then
				--_crint("1回合：" .. roundCount)
				table.insert(resultBuffer, "0")
				table.insert(resultBuffer, IniUtil.compart)
			end
			-- 对应parser部分 start
			table.insert(resultBuffer, battleObject.battleTag)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, battleObject.coordinate)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, battleObject.commonSkillMould.id)
			table.insert(resultBuffer, IniUtil.compart)
			-- 哪来的userInfo ???
			battleObject:processUserBuffEffect(userInfo, self, resultBuffer)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 0)
			table.insert(resultBuffer, IniUtil.compart)
			-- 对应parser部分 end
			attackOver = 1
			--continue
		else
			-- 主要战斗数据处理		
			local battleSkillList = nil
			local skillReleasePosion = 0
			local  realSkillMould = battleObject.specialSkillMould.id
			-- 标示符
			local goon = true
			-- 达到怒气技能 且没有被封技
			-- 处理到 Buff
			if((battleObject.skillPoint >=4 or self.canFreeSkill == true) and battleObject.isDisSp ~= true) then
				if (attackOver ~= 0)then
					table.insert(resultBuffer, "0")
					table.insert(resultBuffer, IniUtil.compart)
					--_crint("2回合：" + roundCount)
				end
				-- 移至后面处理
				-- battleObject:processUserBuffEffect(userInfo, self, self.buffBuffer)

				-- 出手方标识 battleTag
				table.insert(self.headBuffer, battleObject.battleTag)
				table.insert(self.headBuffer, IniUtil.compart)
				-- 出手方位置
				table.insert(self.headBuffer, battleObject.coordinate)

				skillReleasePosion = battleObject.specialSkillMould.skillReleasePosition
				if(hasZoumarSkill == true and self.canFreeSkill == true) then
					table.insert(self.headBuffer, IniUtil.compart)
					-- 有合体技能，合体对象数量
					table.insert(self.headBuffer, #battleObject.fitBattleObjects)
					battleObject:subZomSkillPoint(5)
					self:fitFight(battleObject,battleObject.fitBattleObjects, userInfo)
					-- battleObject.isAction = true
					battleSkillList = {}
					skillReleasePosion = battleObject.zoariumSkillMould.skillReleasePosition
					-- 合击技能
					realSkillMould = battleObject.zoariumSkillMould.id
				else
					table.insert(self.headBuffer, IniUtil.compart)
					-- 有合体技能，合体对象数量为0
					table.insert(self.headBuffer, 0)
					-- 怒气技能
					battleSkillList = battleObject.oneselfBattleSkill
				end
				table.insert(self.headBuffer, IniUtil.compart)

				-- 相克状态
				-- 在headerBuffer 和bodyBuffer拼接的时候插入

				-- 移动坐标 也根据攻守方判断
				if(battleObject.battleTag == 0) then
					local movePos = FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.byAttackObjects)
					table.insert(self.bodyBuffer, movePos)
					----_crint ("Move pos 0 : " .. movePos)
					--os.exit()
				else
					local movePos = FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.attackObjects)
					table.insert(self.bodyBuffer, movePos)
					----_crint ("Move pos 1 : " .. movePos)
					--os.exit()
				end

				table.insert(self.bodyBuffer, IniUtil.compart)
				--技能模板id
				table.insert(self.bodyBuffer, realSkillMould)
				table.insert(self.bodyBuffer, IniUtil.compart)

				-- buff影响
				battleObject:processUserBuffEffect(userInfo, self, self.buffBuffer)
				IniUtil.concatTable(self.bodyBuffer, self.buffBuffer)
			else
				-- 如果麻痹状态，这个数据都缺失了，这个代码块已经报废
				-- 处理到 Buff
				if(battleObject.isParalysis) then
					if (attackOver ~= 0) then
						table.insert(resultBuffer, "0")
						table.insert(resultBuffer, IniUtil.compart)
						--_crint("3回合：" + roundCount)
					end
					-- 出手方标识
					table.insert(self.headBuffer, battleObject.battleTag)
					table.insert(self.headBuffer, IniUtil.compart)
					-- 出手方位置
					table.insert(self.headBuffer, battleObject.coordinate)
					table.insert(self.headBuffer, IniUtil.compart)
					-- 无合体技
					table.insert(self.headBuffer, 0)
					-- 无相克状态
					table.insert(self.headBuffer, IniUtil.compart)
					-- 移动到的位置
					table.insert(self.bodyBuffer, 0)
					table.insert(self.bodyBuffer, IniUtil.compart)
					-- 技能模板id 使用commonSkillMouldid
					table.insert(self.bodyBuffer, battleObject.commonSkillMould.id)
					table.insert(self.bodyBuffer, IniUtil.compart)
					-- 是否有buff影响
					battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
					-- buff数据
					-- ******
					-- 技能效用数量
					table.insert(self.bodyBuffer, 0)
					table.insert(self.bodyBuffer, IniUtil.compart)
					-- 技能效用
					-- ******
					-- 后段技能效用数量
					table.insert(self.bodyBuffer, 0)
					table.insert(self.bodyBuffer, IniUtil.compart)
					-- 出手方是否有buff影响(0:没有 1:有)
					table.insert(self.bodyBuffer, 0)
					table.insert(self.bodyBuffer, IniUtil.compart)
					attackOver = 1
					goon = false
					--continue
				else
					-- 普通状态，走普通技能攻击
					-- 处理到Buffer					
					if (attackOver ~= 0) then
						table.insert(resultBuffer, "0")
						table.insert(resultBuffer, IniUtil.compart)
						--_crint("4回合：" + roundCount)
					end
					table.insert(self.headBuffer, battleObject.battleTag)
					table.insert(self.headBuffer, IniUtil.compart)
					table.insert(self.headBuffer, battleObject.coordinate)

					table.insert(self.headBuffer, IniUtil.compart)
					table.insert(self.headBuffer, 0)
					table.insert(self.headBuffer, IniUtil.compart)
					
					-- 普通技能
					battleSkillList = battleObject.commonBattleSkill
					skillReleasePosion = battleObject.commonSkillMould.skillReleasePosition

					if(battleObject.battleTag == 0) then							
						table.insert(self.bodyBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.byAttackObjects))
					else
						table.insert(self.bodyBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.attackObjects))
					end
					table.insert(self.bodyBuffer, IniUtil.compart)
					table.insert(self.bodyBuffer, battleObject.commonSkillMould.id)
					table.insert(self.bodyBuffer, IniUtil.compart)
					
					battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
				end
			end
			--  麻痹后不走这里，麻痹状态没怎么使用 
			--  根据battleSkillList 数据处理技能效用数据
			if (goon) then 
				--  处理普通或者怒气攻击 技能效用
				--  Skillbuffer
				local tmpBattleSkillBuffer = {}
				-- 是否格挡
				local hasRestrain = 0
				local byAttackCoordinates = {}
				if(battleObject.isDead ~= true) then
					local lastBattleSkill = nil
					-- 
					for _, battleSkill in pairs(battleSkillList) do
						-- if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or 
						-- 	battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP)then
						-- 	byAttackCoordinates = {}
						-- end

						-- BattleSklll对象赋值
						local attackSkill = battleSkill
						attackSkill.formulaInfo = battleSkill.skillInfluence.formulaInfo
						local battleTag = battleObject.battleTag
						-- 作用阵营：0为作用于敌方阵营、1为作用于本方阵营、2为作用于当前英雄
						local influenceGroup = attackSkill.skillInfluence.influenceGroup
						-- 公式索引
						local formulaInfo = attackSkill.skillInfluence.formulaInfo
						-- 技能效用
						local skillInfluence =  attackSkill.skillInfluence
						
						-- 如果公式类型 为即刻生效
						if (formulaInfo ~= FightUtil.FORMULA_INFO_FORTHWITH) then
							byAttackCoordinates= {}
							if((battleTag == 0 and influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)
								or (battleTag == 1 and influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE))then
								-- 计算攻击的位置
								byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
							else
								byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
							end
						else
							-- 如果不是即刻生效
							local tempList = {}
							if((battleTag == 0 and influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)
								or (battleTag == 1 and influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE))then
								tempList = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
							else
								tempList = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
							end

							-- 覆盖操作
							if (#byAttackCoordinates == 0)then
								byAttackCoordinates = tempList
							else
								local realCoordinates = {}
								for i,v in pairs(byAttackCoordinates) do
									for z,k in ipairs(tempList) do
										if(v == k) then
											table.insert(realCoordinates,v)
										end
									end
								end
								byAttackCoordinates = realCoordinates
								attackSkill.formulaInfo = lastBattleSkill.formulaInfo
							end
						end

						-- 计算技能攻击
						if (0 == battleObject.battleTag) then
							if(influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE) then
								if(hasRestrain == 0) then
									hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
								end
								attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
							elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE)then
								if(hasRestrain == 0)then
									hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
								end
								attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
							elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
								byAttackCoordinates = {}
								table.insert(byAttackCoordinates, battleObject.coordinate)
								if(hasRestrain == 0)then
									hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
								end
								attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
							end
						else
							if(influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
								if(hasRestrain == 0)then
									hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
								end
								attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
							elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE) then
								if(hasRestrain == 0)then
									hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
								end
								attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
							elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
								byAttackCoordinates = {}
								table.insert(byAttackCoordinates, battleObject.coordinate)
								if(hasRestrain == 0) then
									hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
								end
								attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
							end
						end
						lastBattleSkill = attackSkill
					end
				end

				IniUtil.concatTable(resultBuffer, self.headBuffer)
				-- 相克状态
				table.insert(resultBuffer, hasRestrain)
				table.insert(resultBuffer, IniUtil.compart)
				IniUtil.concatTable(resultBuffer, self.bodyBuffer)

				table.insert(resultBuffer, self.battleSkillCount)
				table.insert(resultBuffer, IniUtil.compart)
				-- 技能数据
				IniUtil.concatTable(resultBuffer, tmpBattleSkillBuffer)
				
				
				if(hasZoumarSkill == true and self.canFreeSkill == true) then
					----_crint("合击数量 " + battleObject.fitBattleObjects.size())
					table.insert(resultBuffer, tonumber(#battleObject.fitBattleObjects))
					table.insert(resultBuffer, IniUtil.compart)
					if(self.fitBuffer ~= nil) then
						----_crint("合体技能： " + fitBuffer.toString())
						IniUtil.concatTable(resultBuffer, self.fitBuffer)
					end
					self.canFreeSkill = false
				end
				
				IniUtil.concatTable(resultBuffer, self.battleSkillBuffer)
				if(nil ~= self.counterBuffer)then
					IniUtil.concatTable(resultBuffer, self.counterBuffer)
					self.counterBuffer = nil
				else
					table.insert(resultBuffer, 0)
					table.insert(resultBuffer, IniUtil.compart)
				end
				self.battleSkillCount = 0
				table.insert(resultBuffer, 0)
				table.insert(resultBuffer, IniUtil.compart)
				if battleObject.isDead == true then
					table.insert(resultBuffer, 0)
					table.insert(resultBuffer, IniUtil.compart)
				end
			end  -- 麻痹后不走这里
		end  --眩晕判断结束  眩晕不走下面的代码
	end  -- 死亡判断结束
	-- table.insert(resultBuffer, "1")
	-- self:checkFightResult()
	-- self:checkHasNextRound()

	--	检测我方是否只剩眩晕的人未出手的对象 
	if(self:checkLessIsDizzy()) then 
		for s, tempObject in pairs(self.attackObjects) do
			if(tempObject ~= nil) then
				if tempObject.isAction ~= true then
					if(tempObject.isDizzy) then
						tempObject.isAction = true
						table.insert(resultBuffer, tempObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, tempObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, tempObject.commonSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
						tempObject:processUserBuffEffect(userInfo, self, resultBuffer)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
					end
				end
			end
		end
	end

	self:checkFightResult()
	self:checkHasNextRound()

	-- print("是否需要请求下一场战斗",self.hasNextRound)
	--local temp =""
	--for k = 1, #resultBuffer do
	--temp = temp..resultBuffer[k]
	--end
	--print(temp)
end

-- 【步骤1】【分支2】
-- 获取一回合的攻击数据。不包括已出手的
function FightModule:rountdFight(resultBuffer)
	--回合数+1
	local isFrist = self:getBattleObjectSite()

	-- 当前出手是第一次出手
	if(tonumber(isFrist) == 1) then 
		-- print("----------------------------------------------------")
		self:resetActionStatus()
		self:clearAttacksStatus()
	end

	local isAllFight = true
	for k,v in pairs(self.attackObjects) do
		-- print("出手状态",v.battleTag,v.coordinate,v.isAction)
		if v.isAction ~= true then
			isAllFight = false
			-- break
		end
	end
	-- print("我方是否全部出手",isAllFight)
	if isAllFight == true then
		self.battleTag = 1
	else
		self.battleTag = 0
	end
	-- print("9++++++++++++++",self.battleTag)
	
	local attackOver = 0
	table.insert(resultBuffer, self.roundCount)
	table.insert(resultBuffer, IniUtil.enter)
	-- 检查是否有合击技能
	local needNext = true
	for k, v in pairs(self.fightOrderList) do
		local battleObject = self.fightOrderList[k]
		if(battleObject ~= nil) then
			--print("出手",self.battleTag,battleObject.battleTag)
			if tonumber(battleObject.battleTag) ~= tonumber(self.battleTag) then
			else
			
			self.counterBuffer = nil
			self.battleSkillCount = 0
			self.battleSkillBuffer = {}
			if battleObject.isAction ~= true then
				self.currentObject  = battleObject

				self.headBuffer = {}
				self.bodyBuffer = {}
				self.buffBuffer = {}
				battleObject.fitBattleObjects = {}
				if(battleObject.battleTag == 0) then
					battleObject:checkBattleObject(self.attackObjects)
				else
					battleObject:checkBattleObject(self.byAttackObjects)
				end
				self.fitBuffer = nil
				local hasZoumarSkill = false
				if(battleObject.battleTag == 0) then
					hasZoumarSkill = battleObject:checkState(self.attackObjects)
				else
					hasZoumarSkill = battleObject:checkState(self.byAttackObjects)
				end
				if(hasZoumarSkill == true and battleObject.isDizzy ~= true) then
					needNext = false
					battleObject.effectDamage = 0
					battleObject.effectDamage = 0
					battleObject.totalEffectDamage = 0
					battleObject.byEffectCoordinateList = nil

					if(battleObject.isDead) then
						if(battleObject.battleTag == 0) then
							self.attackObjects[battleObject.coordinate ] = nil
						else
							self.byAttackObjects[battleObject.coordinate ] = nil
						end
						self.fightOrderList[k] = nil
						--k = k - 1
					else
						local battleSkillList = nil
						local skillReleasePosion = 0
						local  realSkillMould = battleObject.specialSkillMould.id
						local goon = true
						-- 处理怒气攻击, 包括buff 和攻击技能
						if (attackOver ~= 0)then
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
							-- --_crint("4回合：" + self.roundCount)
						end
						battleObject:processUserBuffEffect(userInfo, self, self.buffBuffer)
						table.insert(self.headBuffer, battleObject.battleTag)
						table.insert(self.headBuffer, IniUtil.compart)
						table.insert(self.headBuffer, battleObject.coordinate)
						skillReleasePosion = battleObject.specialSkillMould.skillReleasePosition
						if(hasZoumarSkill == true) then
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.headBuffer, #battleObject.fitBattleObjects)
							battleObject:subZomSkillPoint(5)
							battleObject.isNeedAddSkillPoint = false
							self:fitFight(battleObject,battleObject.fitBattleObjects, userInfo)
							battleObject.isAction = true
							battleSkillList = {}
							skillReleasePosion = battleObject.zoariumSkillMould.skillReleasePosition
							realSkillMould = battleObject.zoariumSkillMould.id
						else
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.headBuffer, 0)
							battleSkillList = battleObject.oneselfBattleSkill
						end
						table.insert(self.headBuffer, IniUtil.compart)
						if(battleObject.battleTag == 0) then
							local movePos = FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.byAttackObjects)
							table.insert(self.bodyBuffer, movePos)
							----_crint ("Move pos 0 : " .. movePos)
							--os.exit()
						else
							local movePos = FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.attackObjects)
							table.insert(self.bodyBuffer, movePos)
							----_crint ("Move pos 1 : " .. movePos)
							--os.exit()
						end
						table.insert(self.bodyBuffer, IniUtil.compart)
						table.insert(self.bodyBuffer, realSkillMould)
						table.insert(self.bodyBuffer, IniUtil.compart)
						-- battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
						IniUtil.concatTable(self.bodyBuffer, self.buffBuffer)
						--  处理普通或者怒气攻击 技能效用
						local tmpBattleSkillBuffer = {}
						local hasRestrain = 0
						local byAttackCoordinates = {}
						if(goon) then
							if(battleObject.isDead ~= true) then
								local lastBattleSkill = nil
								for _, battleSkill in pairs(battleSkillList) do
									-- if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or 
									-- 	battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP)then
									-- 	byAttackCoordinates = {}
									-- end
									local attackSkill = battleSkill
									attackSkill.formulaInfo = battleSkill.skillInfluence.formulaInfo
									local battleTag = battleObject.battleTag
									local influenceGroup = attackSkill.skillInfluence.influenceGroup
									local formulaInfo = attackSkill.skillInfluence.formulaInfo
									local skillInfluence =  attackSkill.skillInfluence
									
									if (formulaInfo ~= FightUtil.FORMULA_INFO_FORTHWITH) then
										byAttackCoordinates= {}
										if((battleTag == 0 and influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)
											or (battleTag == 1 and influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE))then
											byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
										else
											byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
										end
									else
										local tempList = {}
										if((battleTag == 0 and influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)
											or (battleTag == 1 and influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE))then
											tempList = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
										else
											tempList = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
										end
										if (#byAttackCoordinates == 0)then
											byAttackCoordinates = tempList
										else
											local realCoordinates = {}
											for i,v in pairs(byAttackCoordinates) do
												for z,k in ipairs(tempList) do
													if(v == k) then
														table.insert(realCoordinates,v)
													end
												end
											end
											byAttackCoordinates = realCoordinates
											attackSkill.formulaInfo = lastBattleSkill.formulaInfo
										end
									end
									if (0 == battleTag) then
										if(influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE) then
											if(hasRestrain == 0) then
												hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
											end
											attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
										elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE)then
											if(hasRestrain == 0)then
												hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
											end
											attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
										elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
											byAttackCoordinates = {}
											table.insert(byAttackCoordinates, battleObject.coordinate)
											if(hasRestrain == 0)then
												hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
											end
											attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
										end
									else
										if(influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
											if(hasRestrain == 0)then
												hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
											end
											attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
										elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE) then
											if(hasRestrain == 0)then
												hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
											end
											attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
										elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
											byAttackCoordinates = {}
											table.insert(byAttackCoordinates, battleObject.coordinate)
											if(hasRestrain == 0) then
												hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
											end
											attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
										end
									end
									lastBattleSkill = battleSkill
								end
							end
						end
						IniUtil.concatTable(resultBuffer, self.headBuffer)
						table.insert(resultBuffer, hasRestrain)
						table.insert(resultBuffer, IniUtil.compart)
						IniUtil.concatTable(resultBuffer, self.bodyBuffer)
						if hasZoumarSkill then
							table.insert(resultBuffer, 0)
						else
							table.insert(resultBuffer, self.battleSkillCount)
						end
						table.insert(resultBuffer, IniUtil.compart)
						IniUtil.concatTable(resultBuffer, tmpBattleSkillBuffer)
						
						if hasZoumarSkill then
							table.insert(resultBuffer, #battleObject.fitBattleObjects)
							table.insert(resultBuffer, IniUtil.compart)
							if(self.fitBuffer ~= nil) then
								IniUtil.concatTable(resultBuffer, self.fitBuffer)
							end
						end
						
						
						self.canFreeSkill = false
						IniUtil.concatTable(resultBuffer, self.battleSkillBuffer)
						if(nil ~= counterBuffer)then
							IniUtil.concatTable(resultBuffer, counterBuffer)
							counterBuffer = nil
						else
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
						end
						self.battleSkillCount = 0
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
					end  -- 死亡判断结束
					battleObject.isAction = false
					-- battleObject.isNeedAddSkillPoint = true
					table.insert(resultBuffer, 1)
					table.insert(resultBuffer, IniUtil.compart)
					self:checkHasNextRound()
					break
				end
			end
			end
		end
	end
	-- print("是否需要请求下一场战斗",needNext)
	if needNext == false then
		return
	end
	-- print("=============================================",#self.fightOrderList)
	-- print("#self.fightOrderList",#self.fightOrderList)
	-- for k = 1,  #self.fightOrderList do
	for k, v in pairs(self.fightOrderList) do
		local battleObject = self.fightOrderList[k]
		if(battleObject ~= nil) then
			--print("11出手",self.battleTag,battleObject.battleTag)
			if tonumber(battleObject.battleTag) ~= tonumber(self.battleTag) then
			else
				
				local isLast = self:findIsAllAttack(battleObject)
				if(tonumber(isLast) == 1) then 
					self.greadCount = 0
				end
				--_crint("===========battleObject",battleObject)
				self.counterBuffer = nil
				self.battleSkillCount = 0
				self.battleSkillBuffer = {}
				-- print("是否已经出手过:",battleObject.isAction)
				-- print("出手坐标：",battleObject.battleTag.." "..battleObject.coordinate)
				if battleObject.isAction ~= true then		
					--_crint("出手坐标：",battleObject.battleTag.." "..battleObject.coordinate)
					--记录当前出手对象
					self.currentObject  = battleObject
					--获取下一个出手对象 
					-- self.nextFightObject = FightModule:getNextFightObject(k,self.fightOrderList)
					--_crint("下一个出手坐标："..self.nextFightObject.battleTag..self.nextFightObject.coordinate)
					--重置出手状态
					-- battleObject.isAction = true
					
					self.headBuffer = {}
					self.bodyBuffer = {}
					battleObject.fitBattleObjects = {}
					if(battleObject.battleTag == 0) then
						battleObject:checkBattleObject(self.attackObjects)
					else
						battleObject:checkBattleObject(self.byAttackObjects)
					end
					self.fitBuffer = nil
					local hasZoumarSkill = false
					-- if(battleObject.battleTag == 0) then
					-- 	hasZoumarSkill = battleObject:checkState(self.attackObjects)
					-- else
					-- 	hasZoumarSkill = battleObject:checkState(self.byAttackObjects)
					-- end
					battleObject.effectDamage = 0
					battleObject.totalEffectDamage = 0

					if(battleObject.isDead ) then
						if(battleObject.battleTag == 0) then
							self.attackObjects[battleObject.coordinate ] = nil
						else
							self.byAttackObjects[battleObject.coordinate ] = nil
						end
						self.fightOrderList[k] = nil
						--k = k - 1
					else
						if(battleObject.isDizzy) then
							battleObject.isAction = true
							if (attackOver ~= 0) then
								-- --_crint("4回合：" + self.roundCount)
								table.insert(resultBuffer, "0")
								table.insert(resultBuffer, IniUtil.compart)
							end
							table.insert(resultBuffer, battleObject.battleTag)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, battleObject.coordinate)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, battleObject.commonSkillMould.id)
							table.insert(resultBuffer, IniUtil.compart)
							battleObject:processUserBuffEffect(userInfo, self, resultBuffer)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							attackOver = 1
							--continue
						else
							
							local battleSkillList = nil
							local skillReleasePosion = 0
							local  realSkillMould = battleObject.specialSkillMould.id
							local goon = true
							-- 处理怒气攻击, 包括buff 和攻击技能
							if(battleObject.skillPoint >=4 and battleObject.isDisSp ~= true) then
								if (attackOver ~= 0)then
									table.insert(resultBuffer, "0")
									table.insert(resultBuffer, IniUtil.compart)
									-- --_crint("4回合：" + self.roundCount)
								end
								table.insert(self.headBuffer, battleObject.battleTag)
								table.insert(self.headBuffer, IniUtil.compart)
								table.insert(self.headBuffer, battleObject.coordinate)
								skillReleasePosion = battleObject.specialSkillMould.skillReleasePosition
								if(hasZoumarSkill == true and self.canFreeSkill == true) then
									table.insert(self.headBuffer, IniUtil.compart)
									table.insert(self.headBuffer, #battleObject.fitBattleObjects)
									battleObject:subZomSkillPoint(5)
									self:fitFight(battleObject,battleObject.fitBattleObjects, userInfo)
									-- battleObject.isAction = true
									battleSkillList = {}
									skillReleasePosion = battleObject.zoariumSkillMould.skillReleasePosition
									realSkillMould = battleObject.zoariumSkillMould.id
								else
									table.insert(self.headBuffer, IniUtil.compart)
									table.insert(self.headBuffer, 0)
									battleSkillList = battleObject.oneselfBattleSkill
								end
								table.insert(self.headBuffer, IniUtil.compart)
								if(battleObject.battleTag == 0) then
									local movePos = FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.byAttackObjects)
									table.insert(self.bodyBuffer, movePos)
									----_crint ("Move pos 0 : " .. movePos)
									--os.exit()
								else
									local movePos = FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.attackObjects)
									table.insert(self.bodyBuffer, movePos)
									----_crint ("Move pos 1 : " .. movePos)
									--os.exit()
								end
								table.insert(self.bodyBuffer, IniUtil.compart)
								table.insert(self.bodyBuffer, realSkillMould)
								table.insert(self.bodyBuffer, IniUtil.compart)
								battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
							else
								-- 处理普通攻击, 包括buff 和攻击技能
								if(battleObject.isParalysis) then
									if (attackOver ~= 0) then
										table.insert(resultBuffer, "0")
										table.insert(resultBuffer, IniUtil.compart)
										-- --_crint("4回合：" + self.roundCount)
									end
									table.insert(self.headBuffer, battleObject.battleTag)
									table.insert(self.headBuffer, IniUtil.compart)
									table.insert(self.headBuffer, battleObject.coordinate)
									table.insert(self.headBuffer, IniUtil.compart)
									table.insert(self.headBuffer, 0)
									table.insert(self.headBuffer, IniUtil.compart)
									table.insert(self.bodyBuffer, 0)
									table.insert(self.bodyBuffer, IniUtil.compart)
									table.insert(self.bodyBuffer, battleObject.commonSkillMould.id)
									table.insert(self.bodyBuffer, IniUtil.compart)
									battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
									table.insert(self.bodyBuffer, 0)
									table.insert(self.bodyBuffer, IniUtil.compart)
									table.insert(self.bodyBuffer, 0)
									table.insert(self.bodyBuffer, IniUtil.compart)
									table.insert(self.bodyBuffer, 0)
									table.insert(self.bodyBuffer, IniUtil.compart)
									attackOver = 1
									goon = false
									--continue
								else
									
									if (attackOver ~= 0) then
										table.insert(resultBuffer, "0")
										table.insert(resultBuffer, IniUtil.compart)
										-- --_crint("4回合：" + self.roundCount)
									end
									table.insert(self.headBuffer, battleObject.battleTag)
									table.insert(self.headBuffer, IniUtil.compart)
									table.insert(self.headBuffer, battleObject.coordinate)
				
									table.insert(self.headBuffer, IniUtil.compart)
									table.insert(self.headBuffer, 0)
									table.insert(self.headBuffer, IniUtil.compart)
									
									battleSkillList = battleObject.commonBattleSkill
									skillReleasePosion = battleObject.commonSkillMould.skillReleasePosition

									if(battleObject.battleTag == 0) then							
										table.insert(self.bodyBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.byAttackObjects))
									else
										table.insert(self.bodyBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.attackObjects))
									end
									table.insert(self.bodyBuffer, IniUtil.compart)
									table.insert(self.bodyBuffer, battleObject.commonSkillMould.id)
									table.insert(self.bodyBuffer, IniUtil.compart)
									
									battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
								end
							end
							if(goon) then -- 麻痹后不走这里
								--  处理普通或者怒气攻击 技能效用
								local tmpBattleSkillBuffer = {}
								local hasRestrain = 0
								local byAttackCoordinates = {}
								if(battleObject.isDead ~= true) then
									local lastBattleSkill = nil
									for _, battleSkill in pairs(battleSkillList) do
										-- if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or 
										-- 	battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP)then
										-- 	byAttackCoordinates = {}
										-- end
										local attackSkill = battleSkill
										attackSkill.formulaInfo = battleSkill.skillInfluence.formulaInfo
										local battleTag = battleObject.battleTag
										local influenceGroup = attackSkill.skillInfluence.influenceGroup
										local formulaInfo = attackSkill.skillInfluence.formulaInfo
										local skillInfluence =  attackSkill.skillInfluence
										
										if (formulaInfo ~= FightUtil.FORMULA_INFO_FORTHWITH) then
											byAttackCoordinates= {}
											if((battleTag == 0 and influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)
												or (battleTag == 1 and influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE))then
												byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
											else
												byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
											end
										else
											local tempList = {}
											if((battleTag == 0 and influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)
												or (battleTag == 1 and influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE))then
												tempList = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
											else
												tempList = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
											end
											if (#byAttackCoordinates == 0)then
												byAttackCoordinates = tempList
											else
												local realCoordinates = {}
												for i,v in pairs(byAttackCoordinates) do
													for z,k in ipairs(tempList) do
														if(v == k) then
															table.insert(realCoordinates,v)
														end
													end
												end
												byAttackCoordinates = realCoordinates
												attackSkill.formulaInfo = lastBattleSkill.formulaInfo
											end
										end
										if (0 == battleObject.battleTag) then
											if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE) then
												if(hasRestrain == 0) then
													hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
												end
												attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
											elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE)then
												if(hasRestrain == 0)then
													hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
												end
												attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
											elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
												byAttackCoordinates = {}
												table.insert(byAttackCoordinates, battleObject.coordinate)
												if(hasRestrain == 0)then
													hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
												end
												attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
											end
										else
											if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
												if(hasRestrain == 0)then
													hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
												end
												attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
											elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE) then
												if(hasRestrain == 0)then
													hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
												end
												attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
											elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
												byAttackCoordinates = {}
												table.insert(byAttackCoordinates, battleObject.coordinate)
												if(hasRestrain == 0) then
													hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
												end
												attackSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
											end
										end
										lastBattleSkill = battleSkill
									end
								end
								IniUtil.concatTable(resultBuffer, self.headBuffer)
								table.insert(resultBuffer, hasRestrain)
								table.insert(resultBuffer, IniUtil.compart)
								IniUtil.concatTable(resultBuffer, self.bodyBuffer)
								table.insert(resultBuffer, self.battleSkillCount)
								table.insert(resultBuffer, IniUtil.compart)
								IniUtil.concatTable(resultBuffer, tmpBattleSkillBuffer)
								if(hasZoumarSkill == true and self.canFreeSkill == true) then
									----_crint("合击数量 " + battleObject.fitBattleObjects.size())
									table.insert(resultBuffer, #battleObject.fitBattleObjects)
									table.insert(resultBuffer, IniUtil.compart)
									if(self.fitBuffer ~= nil) then
										IniUtil.concatTable(resultBuffer, self.fitBuffer)
									end
									self.canFreeSkill = false
								end
								IniUtil.concatTable(resultBuffer, self.battleSkillBuffer)
								if(nil ~= counterBuffer)then
									IniUtil.concatTable(resultBuffer, counterBuffer)
									counterBuffer = nil
								else
									table.insert(resultBuffer, 0)
									table.insert(resultBuffer, IniUtil.compart)
								end
								self.battleSkillCount = 0
								table.insert(resultBuffer, 0)
								table.insert(resultBuffer, IniUtil.compart)
								attackOver = 1
							end  -- 麻痹后不走这里
						end  --眩晕判断结束  眩晕不走下面的代码
					end  -- 死亡判断结束
				end
				self:checkHasNextRound()
			end
		end
	-- 下面这段代码, 死亡后也会走, 不过下面这段代码是废代码, 所以可以不管
		-- if (self.attackCount <= 0 or self.byAttackCount<=0 ) then
		-- 	win = self.byAttackCount<=0
		-- 	fightOver = true
		-- 	self.fightResult = 0
		-- 	if tonumber(self.fightType) == tonumber(FightModule.FIGHT_TYPE_DAILY_INSTANCE) then
		-- 		self.fightResult = 1
		-- 	end
		-- 	print("1111111111111111111111")
		-- 	break
		-- end

		
		if (self.hasNextRound == false) then
			-- print("2222222222222222222222222")
			break
		end
	end
	
	self:checkHasNextRound()
	-- self:resetActionStatus()
	table.insert(resultBuffer, "1")
	-- local temp ="敌方，"
	-- for k = 1, #resultBuffer do
	-- temp = temp..resultBuffer[k]
	-- end
	-- print(temp)

	if self.battleTag == 0 then
		self.battleTag = 1
	else
		self.battleTag = 0
		if(self.roundCount >= self.totalRound) then
			self.roundCount = self.totalRound
			if(self.roundCount == self.totalRound) then
				self.hasNextRound = false
				self.fightResult = 0
			end
			if tonumber(self.fightType) == tonumber(FightModule.FIGHT_TYPE_DAILY_INSTANCE) then
				self.fightResult = 1
			end
		else
			self.roundCount = self.roundCount+1
		end
		--print("总回合数",self.roundCount,self.totalRound)
		
		self:resetActionStatus()
	end
	--print("出手",self.battleTag)
end

-- 生成战斗数据
function FightModule:fight(userInfo, resultBuffer)

	self.fightOrderList = {}
	self.attackCount = 0
	self.byAttackCount = 0

	local tempBattleCache = userInfo.battleCache
	self:initBattleInfo(tempBattleCache)
	self:initDailyInstance()
	self.roundCount = 1
	local fightOver = false
	local attackerCombatForce = tempBattleCache.attackCombatForce
	local byAttackerCombatForce = tempBattleCache.byAttackComobatForce
	
	local attackIndex = 1
	local byAttackIndex = 1
	local arrLength = #self.attackObjects
	local win = false
	local tempAttackObjects = self.attackObjects
	local tempByAttackObjects = self.byAttackObjects
	--_crint("AttackCombatForce type: " .. type(attackerCombatForce) .. attackerCombatForce)
	--_crint("byAttackerCombatForce type: " .. type(byAttackerCombatForce) .. byAttackerCombatForce)
	--_crint ("attack object size: " .. #tempAttackObjects)
	if (tonumber(attackerCombatForce) < tonumber(byAttackerCombatForce)) then
		tempAttackObjects = self.byAttackObjects
		tempByAttackObjects = self.attackObjects
	end	
	
	--- 生成战战斗对象序列
	for i = 1, 6 do
		
		if (tempAttackObjects[i] ~= nil) then
			table.insert(self.fightOrderList, tempAttackObjects[i])
			if(tempAttackObjects[i].battleTag == 0) then
				self.attackCount = self.attackCount + 1
			else
				self.byAttackCount = self.byAttackCount + 1
			end
		end
		
		if (tempByAttackObjects[i] ~= nil) then
			table.insert(self.fightOrderList, tempByAttackObjects[i])
			if(tempByAttackObjects[i].battleTag == 0) then
				self.attackCount = self.attackCount + 1
			else
				self.byAttackCount = self.byAttackCount + 1
			end
		end
	end
	
	for k, obj in pairs(self.fightOrderList) do
		--_crint(k, obj.battleTag, obj.coordinate)
	end
	-- os.exit()
	--_crint("attackCount = " .. self.attackCount)
	--_crint("byAttackCount = " .. self.byAttackCount)
	--_crint("fightType = " .. self.fightType)
	--_crint("self.roundCount = " .. self.roundCount)
	--_crint("self.totalRound = " .. self.totalRound)
	--_crint(self.fightOrderList)
	-- os.exit()
	
	while(fightOver ~= true) do
		if (self.attackCount <= 0 or self.byAttackCount <= 0) then
			win = self.byAttackCount <= 0
			fightOver = true			
			self.hasNextRound = false;
			if self.attackCount <= 0 then
				self.fightResult = 0
				if tonumber(self.fightType) == tonumber(FightModule.FIGHT_TYPE_DAILY_INSTANCE) then
					self.fightResult = 1
				end
			else
				self.fightResult = 1
			end
			break
		end
		if(self.roundCount == self.totalRound) then
			win = self.fightType == FightModule.FIGHT_TYPE_PVE_MONEY_TREE
			fightOver = true
			hasNextRound = false;
			self.fightResult = 0
			if tonumber(self.fightType) == tonumber(FightModule.FIGHT_TYPE_DAILY_INSTANCE) then
				self.fightResult = 1
			end
			break
		end
		self:resetActionStatus()
		self.roundCount = self.roundCount + 1
 		local nowAttackHeathPoint = self:getBattleObjectHeathPoint(self.attackObjects)
		local nowDefenceHeathPoint = self:getBattleObjectHeathPoint(self.byAttackObjects)

		table.insert(resultBuffer, IniUtil.enter)
		table.insert(resultBuffer, self.roundCount)
		table.insert(resultBuffer, IniUtil.enter)
		local attackOver = 0

		local backedFightOrderList = self.fightOrderList
		self.fightOrderList = {}		
		-- for k = 1, #backedFightOrderList do
		for k, v in pairs(backedFightOrderList) do
			local battleObj = backedFightOrderList[k]
			if (battleObj ~= nil and battleObj.isDead ~= true)  then
				self.fightOrderList[#self.fightOrderList + 1] = battleObj
				--_crint ("backedFightOrderList[k].coordinate)
			end
		end

		backedFightOrderList = nil
		
		-- for k = 1,  #self.fightOrderList do
		for k, v in pairs(self.fightOrderList) do
			if (self.attackCount <= 0 or self.byAttackCount<=0) then
				win = self.byAttackCount<=0
				fightOver = true
				self.hasNextRound = false;
				if self.attackCount <= 0 then
					self.fightResult = 0
					if tonumber(self.fightType) == tonumber(FightModule.FIGHT_TYPE_DAILY_INSTANCE) then
						self.fightResult = 1
					end
				else
					self.fightResult = 1
				end
				break
			end
			self.counterBuffer = nil
			self.battleSkillCount = 0
			self.battleSkillBuffer = {}
			for i = 1, 6 do
				if(nil ~= self.attackObjects[i]) then
					self.attackObjects[i].canReAttack = true
					self.attackObjects[i].talentJudgeResultList = {}
				end
			end
			for i = 1, 6 do
				if(nil ~= self.byAttackObjects[i]) then
					self.byAttackObjects[i].canReAttack = true
					self.byAttackObjects[i].talentJudgeResultList = {}
				end
			end
			local battleObject = self.fightOrderList[k]
			--_crint("出手坐标："..battleObject.battleTag..battleObject.coordinate)
			--记录当前出手对象
			self.currentObject  = battleObject
			--获取下一个出手对象 
			self.nextFightObject = FightModule:getNextFightObject(k,self.fightOrderList)
			--_crint("下一个出手坐标："..self.nextFightObject.battleTag..self.nextFightObject.coordinate)
			--重置出手状态
			-- battleObject.isAction = true
			
			self.headBuffer = {}
			self.bodyBuffer = {}
			battleObject.fitBattleObjects = {}
			if(battleObject.battleTag == 0) then
				battleObject:checkBattleObject(self.attackObjects)
			else
				battleObject:checkBattleObject(self.byAttackObjects)
			end
			self.fitBuffer = nil
			local hasZoumarSkill = false
			if(battleObject.battleTag == 0) then
				hasZoumarSkill = battleObject:checkState(self.attackObjects)
			else
				hasZoumarSkill = battleObject:checkState(self.byAttackObjects)
			end
			battleObject.effectDamage = 0
			battleObject.totalEffectDamage = 0

			if(battleObject.isDead ) then
				if(battleObject.battleTag == 0) then
					self.attackObjects[battleObject.coordinate ] = nil
				else
					self.byAttackObjects[battleObject.coordinate ] = nil
				end
				self.fightOrderList[k] = nil
				k = k - 1
			else
				if(battleObject.isDizzy) then
					if (attackOver ~= 0) then
						----_crint("1回合：" .. roundCount)
						table.insert(resultBuffer, "0")
						table.insert(resultBuffer, IniUtil.compart)
					end
					table.insert(resultBuffer, battleObject.battleTag)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, battleObject.coordinate)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, 0)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, 0)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, 0)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, battleObject.commonSkillMould.id)
					table.insert(resultBuffer, IniUtil.compart)
					battleObject:processUserBuffEffect(userInfo, self, resultBuffer)
					table.insert(resultBuffer, 0)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, 0)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, 0)
					table.insert(resultBuffer, IniUtil.compart)
					attackOver = 1
					--continue
				else
					
					local battleSkillList = nil
					local skillReleasePosion = 0
					local  realSkillMould = battleObject.specialSkillMould.id
					local goon = true
					-- 处理怒气攻击, 包括buff 和攻击技能
					if((battleObject.skillPoint >=4 or hasZoumarSkill == true) and battleObject.isDisSp ~= true) then
						if (attackOver ~= 0)then
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
							----_crint("2回合：" + roundCount)
						end
						table.insert(self.headBuffer, battleObject.battleTag)
						table.insert(self.headBuffer, IniUtil.compart)
						table.insert(self.headBuffer, battleObject.coordinate)
						skillReleasePosion = battleObject.specialSkillMould.skillReleasePosition
						if(hasZoumarSkill == true and self.canFreeSkill == true) then
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.headBuffer, #battleObject.fitBattleObjects)
							battleObject:subZomSkillPoint(5)
							self:fitFight(battleObject,battleObject.fitBattleObjects, userInfo)
							-- battleObject.isAction = true
							battleSkillList = {}
							skillReleasePosion = battleObject.zoariumSkillMould.skillReleasePosition
							realSkillMould = battleObject.zoariumSkillMould.id
						else
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.headBuffer, 0)
							battleSkillList = battleObject.oneselfBattleSkill
						end
						table.insert(self.headBuffer, IniUtil.compart)
						if(battleObject.battleTag == 0) then
							local movePos = FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.byAttackObjects)
							table.insert(self.bodyBuffer, movePos)
							----_crint ("Move pos 0 : " .. movePos)
							--os.exit()
						else
							local movePos = FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.attackObjects)
							table.insert(self.bodyBuffer, movePos)
							----_crint ("Move pos 1 : " .. movePos)
							--os.exit()
						end
						table.insert(self.bodyBuffer, IniUtil.compart)
						table.insert(self.bodyBuffer, realSkillMould)
						table.insert(self.bodyBuffer, IniUtil.compart)
						battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
					else
						-- 处理普通攻击, 包括buff 和攻击技能
						if(battleObject.isParalysis) then
							if (attackOver ~= 0) then
								table.insert(resultBuffer, "0")
								table.insert(resultBuffer, IniUtil.compart)
								----_crint("3回合：" + roundCount)
							end
							table.insert(self.headBuffer, battleObject.battleTag)
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.headBuffer, battleObject.coordinate)
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.headBuffer, 0)
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.bodyBuffer, 0)
							table.insert(self.bodyBuffer, IniUtil.compart)
							table.insert(self.bodyBuffer, battleObject.commonSkillMould.id)
							table.insert(self.bodyBuffer, IniUtil.compart)
							battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
							table.insert(self.bodyBuffer, 0)
							table.insert(self.bodyBuffer, IniUtil.compart)
							table.insert(self.bodyBuffer, 0)
							table.insert(self.bodyBuffer, IniUtil.compart)
							table.insert(self.bodyBuffer, 0)
							table.insert(self.bodyBuffer, IniUtil.compart)
							attackOver = 1
							goon = false
							--continue
						else
							
							if (attackOver ~= 0) then
								table.insert(resultBuffer, "0")
								table.insert(resultBuffer, IniUtil.compart)
								----_crint("4回合：" + roundCount)
							end
							table.insert(self.headBuffer, battleObject.battleTag)
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.headBuffer, battleObject.coordinate)
		
							table.insert(self.headBuffer, IniUtil.compart)
							table.insert(self.headBuffer, 0)
							table.insert(self.headBuffer, IniUtil.compart)
							
							battleSkillList = battleObject.commonBattleSkill
							skillReleasePosion = battleObject.commonSkillMould.skillReleasePosition

							if(battleObject.battleTag == 0) then							
								table.insert(self.bodyBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.byAttackObjects))
							else
								table.insert(self.bodyBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.attackObjects))
							end
							table.insert(self.bodyBuffer, IniUtil.compart)
							table.insert(self.bodyBuffer, battleObject.commonSkillMould.id)
							table.insert(self.bodyBuffer, IniUtil.compart)
							
							battleObject:processUserBuffEffect(userInfo, self, self.bodyBuffer)
						end
					end
					if (goon) then -- 麻痹后不走这里
					    --  处理普通或者怒气攻击 技能效用
						local tmpBattleSkillBuffer = {}
						local hasRestrain = 0
						local byAttackCoordinates = {}
						
						for _, battleSkill in pairs(battleSkillList) do
							if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or 
								battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP)then
								byAttackCoordinates = {}
							end
							if (0 == battleObject.battleTag) then
								if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE) then
									if (#byAttackCoordinates == 0) then
										byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
									end
									if(hasRestrain == 0) then
										hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
									end
									battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
								elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE)then
									byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
									if(hasRestrain == 0)then
										hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
									end
									battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
								elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
									byAttackCoordinates = {}
									table.insert(byAttackCoordinates, battleObject.coordinate)
									if(hasRestrain == 0)then
										hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
									end
									battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
								end
							else
								if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)then
									if (#byAttackCoordinates == 0)then
										byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
									end
									if(hasRestrain == 0)then
										hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
									end
									battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, tmpBattleSkillBuffer)
								elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE) then
									byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
									if(hasRestrain == 0)then
										hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
									end
									battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
								elseif(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
									byAttackCoordinates = {}
									table.insert(byAttackCoordinates, battleObject.coordinate)
									if(hasRestrain == 0) then
										hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
									end
									battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, tmpBattleSkillBuffer)
								end
							end
						end
						IniUtil.concatTable(resultBuffer, self.headBuffer)
						table.insert(resultBuffer, hasRestrain)
						table.insert(resultBuffer, IniUtil.compart)
						IniUtil.concatTable(resultBuffer, self.bodyBuffer)
						table.insert(resultBuffer, self.battleSkillCount)
						table.insert(resultBuffer, IniUtil.compart)
						IniUtil.concatTable(resultBuffer, tmpBattleSkillBuffer)
						if(hasZoumarSkill == true and self.canFreeSkill == true) then
							----_crint("合击数量 " + battleObject.fitBattleObjects.size())
							table.insert(resultBuffer, #battleObject.fitBattleObjects)
							table.insert(resultBuffer, IniUtil.compart)
							if(fitBuffer ~= nil) then
								----_crint("合体技能： " + fitBuffer.toString())
								IniUtil.concatTable(resultBuffer, fitBuffer)
							end
							self.canFreeSkill = false
						end
						IniUtil.concatTable(resultBuffer, self.battleSkillBuffer)
						if(nil ~= counterBuffer)then
							IniUtil.concatTable(resultBuffer, counterBuffer)
							counterBuffer = nil
						else
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
						end
						self.battleSkillCount = 0
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						attackOver = 1
					end  -- 麻痹后不走这里
				end  --眩晕判断结束  眩晕不走下面的代码
			end  -- 死亡判断结束
			
			-- 下面这段代码, 死亡后也会走, 不过下面这段代码是废代码, 所以可以不管
			if (self.attackCount <= 0 or self.byAttackCount<=0 ) then
				win = self.byAttackCount<=0
				fightOver = true
				self.fightResult = 0
				if tonumber(self.fightType) == tonumber(FightModule.FIGHT_TYPE_DAILY_INSTANCE) then
					self.fightResult = 1
				end
				break
			end
		end
		table.insert(resultBuffer, "1")
		local endAttackHeathPoint = self:getBattleObjectHeathPoint(self.attackObjects)
		local endDefenceHeathPoint = self:getBattleObjectHeathPoint(self.byAttackObjects)
		local attackHeathPoint = nowAttackHeathPoint - endAttackHeathPoint
		local defenceHeathPoint = nowDefenceHeathPoint - endDefenceHeathPoint
		--_crint("\nThe " .. self.roundCount .. " round health point loses are: " .. attackHeathPoint .. " : " .. defenceHeathPoint)
		self.attackDamages = self.attackDamages .. "," .. attackHeathPoint
		self.defenceDamages = self.defenceDamages .. "," .. defenceHeathPoint
		if (endAttackHeathPoint <= 0) then
			endAttackHeathPoint = endAttackHeathPoint .. ",1"
		else
			endAttackHeathPoint = endAttackHeathPoint .. ",0"
		end
		
		if (endDefenceHeathPoint <= 0) then
			self.defenceDeadState = self.defenceDeadState .. ",1"
		else
			self.defenceDeadState = self.defenceDeadState .. ",0"
		end		
	end
	self.attackDamages = string.sub(self.attackDamages, 1)
	self.defenceDamages = string.sub(self.defenceDamages, 1)
	--self.attackDeadState = string.sub(attackDeadState, 1)
	--self.defenceDeadState = string.sub(defenceDeadState, 1)
	self:checkFightResult()
	self:checkDefenceResult()
	if(win) then
		table.insert(resultBuffer, 1, FightModule.FIGHT_RESULT_WIN)
		table.insert(resultBuffer, 2, IniUtil.enter)
		table.insert(resultBuffer, 3, self.totalRound)
		table.insert(resultBuffer, 4, IniUtil.enter)
		table.insert(resultBuffer, 5, self.roundCount)		
		--table.insert(resultBuffer, 6, IniUtil.enter)
		
		userInfo.battleCache.currentBattleCount = encryptInfo(math.min(decryptInfo(userInfo.battleCache.currentBattleCount) + 1, decryptInfo(userInfo.battleCache.maxBattleCount)))
		return FightModule.FIGHT_RESULT_WIN
	else
		table.insert(resultBuffer, 1, FightModule.FIGHT_RESULT_LOST)
		table.insert(resultBuffer, 2, IniUtil.enter)
		table.insert(resultBuffer, 3, self.totalRound)
		table.insert(resultBuffer, 4, IniUtil.enter)
		table.insert(resultBuffer, 5, self.roundCount)		
		--table.insert(resultBuffer, 6, IniUtil.enter)
		userInfo.battleCache.currentBattleCount = encryptInfo(0)
		return FightModule.FIGHT_RESULT_LOST
	end
end

function FightModule:fitFight(selfObject, list, userInfo)
	self.fitBuffer = {}
	self.fitSelfBuffer = {}
	table.insert(self.fitSelfBuffer, selfObject.battleTag)
	table.insert(self.fitSelfBuffer,IniUtil.compart)
	table.insert(self.fitSelfBuffer,selfObject.coordinate)
	table.insert(self.fitSelfBuffer,IniUtil.compart)
	table.insert(self.fitSelfBuffer,0)
	table.insert(self.fitSelfBuffer, IniUtil.compart)
	table.insert(self.fitSelfBuffer, 3)
	table.insert(self.fitSelfBuffer, IniUtil.compart)
	table.insert(self.fitSelfBuffer, 4)
	table.insert(self.fitSelfBuffer, IniUtil.compart)
	table.insert(self.fitSelfBuffer, 0)
	table.insert(self.fitSelfBuffer, IniUtil.compart)
	table.insert(self.fitSelfBuffer, 0)
	table.insert(self.fitSelfBuffer, IniUtil.compart)
	table.insert(self.fitSelfBuffer, 0)
	table.insert(self.fitSelfBuffer, IniUtil.compart)
	table.insert(self.fitSelfBuffer, 0)
	table.insert(self.fitSelfBuffer, IniUtil.compart)
	-- for k = 1, #list do
	for k, v in pairs(list) do
		battleObject = list[k]
		if(#battleObject.releaseSkill == 0) then
			--continue
		else
			local fitHeadBuffer = {}
			local fitBodyBuffer = {}
			self.fitBattleSkillCount = 0
			table.insert(fitHeadBuffer, battleObject.battleTag)
			table.insert(fitHeadBuffer, IniUtil.compart)
			table.insert(fitHeadBuffer, battleObject.coordinate)
			table.insert(fitHeadBuffer, IniUtil.compart)
			table.insert(fitHeadBuffer, 0)
			table.insert(fitHeadBuffer, IniUtil.compart)
			local battleSkillList = battleObject.releaseSkill
			local skillReleasePosion  = battleObject.releaseSKillMould.skillReleasePosition
			if(battleObject.battleTag == 0) then						
				table.insert(fitBodyBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.byAttackObjects))
			else
				table.insert(fitBodyBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, self.attackObjects))
			end
			table.insert(fitBodyBuffer, IniUtil.compart)
			table.insert(fitBodyBuffer, battleObject.releaseSKillMould.id)
			table.insert(fitBodyBuffer, IniUtil.compart)
			self.battleSkillBuffer = {}
			for i = 1, 6 do
				if(nil ~= self.attackObjects[i]) then
					self.attackObjects[i].canReAttack=true
					self.attackObjects[i]:clearTalentJudgeResultList()
				end
			end
			for i = 1, 6 do
				if(nil ~= self.byAttackObjects[i]) then
					self.byAttackObjects[i].canReAttack=true
					self.byAttackObjects[i]:clearTalentJudgeResultList()
				end
			end
			battleObject.effectDamage=0
			battleObject.totalEffectDamage=0
			local battleSkillBuffer = {}
			local hasRestrain = 0
			local byAttackCoordinates = {}
			local lastBattleSkill = {}
			for _,  battleSkill in pairs(battleSkillList) do
				local attackSkill = battleSkill
				attackSkill.formulaInfo = battleSkill.skillInfluence.formulaInfo
				local battleTag = battleObject.battleTag
				local influenceGroup = attackSkill.skillInfluence.influenceGroup
				local formulaInfo = attackSkill.skillInfluence.formulaInfo
				local skillInfluence =  attackSkill.skillInfluence
				
				if (formulaInfo ~= FightUtil.FORMULA_INFO_FORTHWITH) then
					byAttackCoordinates= {}
					if((battleTag == 0 and influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)
						or (battleTag == 1 and influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE))then
						byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
					else
						byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
					end
				else
					local tempList = {}
					if((battleTag == 0 and influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE)
						or (battleTag == 1 and influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE))then
						tempList = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.byAttackObjects)
					else
						tempList = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, self.attackObjects)
					end
					if (#byAttackCoordinates == 0)then
						byAttackCoordinates = tempList
					else
						local realCoordinates = {}
						for i,v in pairs(byAttackCoordinates) do
							for z,k in ipairs(tempList) do
								if(v == k) then
									table.insert(realCoordinates,v)
								end
							end
						end
						byAttackCoordinates = realCoordinates
						attackSkill.formulaInfo = lastBattleSkill.formulaInfo
					end
				end
				--BattleSkill battleSkill = battleSkillList.get(j)
				-- if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or 
				-- 	battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP) then
				-- 	byAttackCoordinates = {}
				-- end
				if (0 == battleObject.battleTag) then
					if(influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE) then
						if(hasRestrain == 0) then
							hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
						end
						attackSkill:processFitAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, battleSkillBuffer)
					elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE) then
						if(hasRestrain == 0) then
							hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
						end
						attackSkill:processFitAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, battleSkillBuffer)
					elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
						byAttackCoordinates = {}
						table.insert(byAttackCoordinates, battleObject.coordinate)
						if(hasRestrain == 0) then
							hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, attackObjects)
						end
						attackSkill:processFitAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, battleSkillBuffer)
					end
				else
					if(influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE) then
						if(hasRestrain == 0) then
							hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.attackObjects)
						end
						attackSkill:processFitAttack(userInfo, byAttackCoordinates, battleObject, self.attackObjects, self, battleSkillBuffer)
					elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE) then
						if(hasRestrain == 0) then
							hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
						end
						attackSkill:processFitAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, battleSkillBuffer)
					elseif(influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
						byAttackCoordinates = {}
						table.insert(byAttackCoordinates, battleObject.coordinate)
						if(hasRestrain == 0) then
							hasRestrain = RestrainUtil.hasRestrain(battleObject, byAttackCoordinates, self.byAttackObjects)
						end
						attackSkill:processFitAttack(userInfo, byAttackCoordinates, battleObject, self.byAttackObjects, self, battleSkillBuffer)
					end
				end
				lastBattleSkill = battleSkill
			end
			
			battleObject:addFigSkillCount(self.fitBattleSkillCount)
			IniUtil.concatTable(self.fitBuffer, fitHeadBuffer)
			table.insert(self.fitBuffer, hasRestrain)
			table.insert(self.fitBuffer, IniUtil.compart)
			IniUtil.concatTable(self.fitBuffer, fitBodyBuffer)
			-- print("====fitBodyBuffer====")
			-- debug.print_r(fitBodyBuffer)
			if(self.fitSelfBuffer ~= nil) then
				self.fitBattleSkillCount = self.fitBattleSkillCount + 1
			end
			table.insert(self.fitBuffer, self.fitBattleSkillCount)
			table.insert(self.fitBuffer, IniUtil.compart)
			IniUtil.concatTable(self.fitBuffer, battleSkillBuffer)
			IniUtil.concatTable(self.fitBuffer, self.battleSkillBuffer)
			--取消合体技触发人员的出手状态
			-- if selfIsAction ~= true then
			-- 	battleObject.isAction = false
			-- end
		end		
	end
	-- selfObject.isAction = true
end


function FightModule:getBattleObjectHeathPoint(battleObjects)
	local lessAttackHp = 0
	for _, battleObject in pairs(battleObjects) do
		--BattleObject battleObject = battleObjects[i]
		if(battleObject~=nil and battleObject.isDead ~= true) then
			lessAttackHp = lessAttackHp + battleObject.healthPoint
			----_crint (" battleObject.healthPoint = " ..  battleObject.healthPoint)
		else
			----_crint ("battleObject nil or dead")
		end
	end
	--_crint ("getBattleObjectHeathPoint " ..  lessAttackHp)
	return lessAttackHp
end

function FightModule:getFightObjectCount(attackerObjects)
	local count = 0
	for _, attackObj in pairs(attackerObjects) do
		if (attackObj ~= nil) then
			count = count + 1
		end
	end
	return count
end

function FightModule:writeBattleFieldInit(battleCache, selfTag, targetTag, resultBuffer)
	table.insert(resultBuffer, 182)
	table.insert(resultBuffer, IniUtil.enter)
	table.insert(resultBuffer, battleCache.battleType)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, battleCache.byAttackerId)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, battleCache.difficulty)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, battleCache.maxBattleCount)
	table.insert(resultBuffer, IniUtil.enter)
	table.insert(resultBuffer, self:getFightObjectCount(battleCache.attackerObjects))
	table.insert(resultBuffer, IniUtil.enter)
	local fightObjects = battleCache.attackerObjects
	for i, v in pairs(fightObjects) do
		if(nil ~= fightObjects[i]) then
			table.insert(resultBuffer, fightObjects[i].id)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, i)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, fightObjects[i].picIndex)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, fightObjects[i].specialSkillDecribe)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, fightObjects[i].zoarium)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, fightObjects[i].quality)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, fightObjects[i].healthPoint)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, fightObjects[i].skillPoint)
			table.insert(resultBuffer, IniUtil.compart)
			if(self.fightType == 1) then
				table.insert(resultBuffer, 1)
			else
				table.insert(resultBuffer, selfTag)
			end
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, fightObjects[i].mouldId)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, 1)
			table.insert(resultBuffer, IniUtil.compart)
			table.insert(resultBuffer, fightObjects[i].fightName)
			table.insert(resultBuffer, IniUtil.enter)
		end
	end
	
	table.insert(resultBuffer, 0)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer,  "0,0")
	table.insert(resultBuffer, IniUtil.enter)
	
	local byAttackerObjectsList = battleCache.byAttackerObjectsList
	local battleCount = 1
	--for (FightObject[] _fightObjects : byAttackerObjectsList) {
	for _, _fightObjects in pairs(byAttackerObjectsList) do
		table.insert(resultBuffer, battleCount)
		table.insert(resultBuffer, IniUtil.enter)
		if(self.fightType < 10) then
			--for (local i = 0; i < _fightObjects.length; i++) {
			-- for i = 1, #_fightObjects do
			for i, v in pairs(_fightObjects) do
				if(nil ~= _fightObjects[i]) then
					table.insert(resultBuffer, _fightObjects[i].name)
					table.insert(resultBuffer, IniUtil.enter)
					break
				end
			end
		else
			table.insert(resultBuffer, "?")
			table.insert(resultBuffer, IniUtil.enter)
		end
		table.insert(resultBuffer, self:getFightObjectCount(_fightObjects))
		table.insert(resultBuffer, IniUtil.enter)
		--for (local i = 0; i < _fightObjects.length; i++) {
		----_crint("Size is: " .. (#_fightObjects))
		--for i = 1, #_fightObjects do
		for i, attackObj in pairs(_fightObjects) do
			if(nil ~= attackObj) then
				table.insert(resultBuffer, attackObj.id)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, i)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.picIndex)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.specialSkillDecribe)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.zoarium)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.quality)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.healthPoint)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.skillPoint)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, targetTag)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.mouldId)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.amplifyPercent)
				table.insert(resultBuffer, IniUtil.compart)
				table.insert(resultBuffer, attackObj.fightName)
				table.insert(resultBuffer, IniUtil.enter)
			end
		end
		battleCount = battleCount + 1
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer,  "0,0")
		table.insert(resultBuffer, IniUtil.enter)
	end
	table.insert(resultBuffer, 206)
	table.insert(resultBuffer, IniUtil.enter)
	table.insert(resultBuffer, battleCache.attackName)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, battleCache.attackCombatForce)
	table.insert(resultBuffer, IniUtil.enter)
	table.insert(resultBuffer, battleCache.byAttackName)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, battleCache.byAttackComobatForce)
	table.insert(resultBuffer, IniUtil.enter)
end

--检查是否有下一回合
--重置评分伤害加成倍率
function FightModule:checkHasNextRound()
	if(self.hasNextRound == true) then	
		self.attackCount = 0
		self.byAttackCount = 0
		for s, tempObject in pairs(self.attackObjects) do
			if(tempObject.isDead) then
			else
				tempObject.grade_attack = 1
				self.attackCount = self.attackCount + 1
			end
		end
		for s, tempObject in pairs(self.byAttackObjects) do
			if(tempObject.isDead) then
			else
				tempObject.grade_attack = 1
				self.byAttackCount = self.byAttackCount + 1
			end
		end
		if (self.attackCount <= 0 or self.byAttackCount <= 0) then
			self.hasNextRound = false
			_ED.user_info.battleCache.currentBattleCount = encryptInfo(math.min(decryptInfo(_ED.user_info.battleCache.currentBattleCount) + 1, decryptInfo(_ED.user_info.battleCache.maxBattleCount)))
			if self.attackCount <= 0 then
				self.fightResult = 0
			else
				self.fightResult = 1
			end
		end
		
		self:checkFightResult()
		if(self.hasNextRound == false and tonumber(self.fightType) ~= 1) then
			if(tonumber(self.deathCount) == 0) then
				self.star = 3
			elseif(tonumber(self.deathCount) == 1) then
				self.star = 2
			elseif(tonumber(self.deathCount) == tonumber(self.shipCount)) then
				self.star = 0
			else
				self.star = 1
			end
		else
			self.star = 3
		end
		--print("总回合数",self.roundCount,self.totalRound)
		-- if(self.roundCount == self.totalRound) then
		-- 	self.hasNextRound = false
		-- 	self.fightResult = 0
		-- end
		if tonumber(self.fightType) == tonumber(FightModule.FIGHT_TYPE_DAILY_INSTANCE) then
			self.fightResult = 1
		end
	end
end

function FightModule:checkFightResult()
	local nowHeal = 0
	local liveCount = 0
	for _, battleObject in pairs(self.attackObjects) do
		if(battleObject~=nil and battleObject.isDead ~= true) then
			liveCount = liveCount + 1
			nowHeal = nowHeal + battleObject.healthPoint
		end
	end
	self.totalAttackDamage = math.floor (self.totalHealth - nowHeal)
	self.deathCount = self.shipCount - liveCount
	self.surplusHealth = math.floor(nowHeal/self.totalHealth*100)
end

--传递出手方位人员的位置以及评分
--设置评分加成倍率
function FightModule:setGradeAttack(battleObject,grade)
	self.canFreeSkill = false
	self.greadCount = self.greadCount+1
	local operateAddition = dms.element(dms["operate_addition"], self.greadCount)
	local badScore = dms.atoi(operateAddition, operate_addition.bad_score)
	local goodScore = dms.atoi(operateAddition, operate_addition.good_score)
	local greatScore = dms.atoi(operateAddition, operate_addition.great_score)
	local perfectScore = dms.atoi(operateAddition, operate_addition.prefect_score)
	if(tonumber(grade) == tonumber(badScore)) then	--糟糕
		self.gradeAttack = self.gradeAttack + dms.atof(operateAddition, operate_addition.bad_add)
		battleObject.grade_attack = battleObject.grade_attack + self.gradeAttack
	elseif(tonumber(grade) == tonumber(goodScore)) then --普通
		self.gradeAttack = self.gradeAttack + dms.atof(operateAddition, operate_addition.good_add)
		battleObject.grade_attack = battleObject.grade_attack + self.gradeAttack
	elseif(tonumber(grade) == tonumber(greatScore)) then	--良好
		self.gradeAttack = self.gradeAttack + dms.atof(operateAddition, operate_addition.great_add)
		battleObject.grade_attack = battleObject.grade_attack + self.gradeAttack
	elseif(tonumber(grade) == tonumber(perfectScore)) then	--完美
		self.gradeAttack = self.gradeAttack + dms.atof(operateAddition, operate_addition.prefect_add)
		battleObject.grade_attack = battleObject.grade_attack + self.gradeAttack
		--self.canFreeSkill = true
	end
end


-- 设置是否能是否合体就
function FightModule:setFreeSkillTrue()
	self.canFreeSkill = true
end

--检查我方是否还有人能出手
function FightModule:checkAttackSell()
	local selfAction = false
	for _, battleObject in pairs(self.attackObjects) do
		if(battleObject~=nil and battleObject.isDead ~= true
			and battleObject.isAction ~= true) then
				selfAction  = true
		end
	end
	--检查敌方是否有人存活
	local canAction = false
	for _, battleObject in pairs(self.byAttackObjects) do
		if(battleObject~=nil and battleObject.isDead ~= true) then
			canAction = true;
		end
	end
	if(selfAction == true) and (canAction == true) then
		return true
	end
	return false
end
--检查敌方是否还有人能出手
function FightModule:checkByAttackSell()
	local selfAction = false
	for _, battleObject in pairs(self.byAttackObjects) do
		if(battleObject~=nil and battleObject.isDead ~= true
			and battleObject.isAction ~= true) then
				selfAction  = true
		end
	end
	--检查地方是否有人存活
	local canAction = false
	for _, battleObject in pairs(self.attackObjects) do
		if(battleObject~=nil and battleObject.isDead ~= true) then
			canAction = true;
		end
	end
	if(selfAction == true) and (canAction == true) then
		return true
	end
	return false
end


--传递我方当前状态
--0:无人,1:正常普通技能,2:死亡,3:眩晕 4:怒气技能 5:合体技能 6:合体怒气并存
function FightModule:checkSelfAttackStatus()
	local selfAttackObjects = {}
	for i, battleObject in pairs(self.attackObjects) do
		if(battleObject~=nil) then
			if(battleObject.isDead ~= true) then
				if(battleObject.isDizzy ~= true) then
					selfAttackObjects[i] = 1;
					if(battleObject.skillPoint >= 4) then
						selfAttackObjects[i] = 4
					end
					local hasZoumarSkill = battleObject:checkState(self.attackObjects)
					if(hasZoumarSkill) then
						selfAttackObjects[i] = 5
					end
					if(battleObject.skillPoint >= 4 and hasZoumarSkill) then
						selfAttackObjects[i] = 6
					end
				else
					selfAttackObjects[i] = 3;	
				end
			else
				selfAttackObjects[i] = 2;
			end
		else
			selfAttackObjects[i] = 0;
		end
	end
	return selfAttackObjects
end


--传递出手人员合击怒气槽
--0:无人,1:正常普通技能,2:死亡,3:眩晕 4:怒气技能 5:合体技能 6:合体怒气并存
function FightModule:getAttackZomlllSkillPoint()
	local selfAttackObjects = {}
	for i=1,6 do
		local battleObject = self.attackObjects[i]
		if(battleObject~=nil and battleObject.isDead ~= true) then
			selfAttackObjects[i] = battleObject.zomlllSkillPoint
		else
			selfAttackObjects[i] = 0
		end
	end
	return selfAttackObjects
end

--跳过整场战斗过程
function FightModule:jumpFight(userInfo, resultBuffer)
	while tonumber(decryptInfo(_ED.user_info.battleCache.currentBattleCount)) < tonumber(#_ED.user_info.battleCache.byAttackerObjectsList) do
		-- print("跳过",_ED.user_info.battleCache.currentBattleCount,#_ED.user_info.battleCache.byAttackerObjectsList)
		while self.hasNextRound == true do
			self:rountdFight(resultBuffer)
		end
		if tonumber(decryptInfo(_ED.user_info.battleCache.currentBattleCount)) < tonumber(#_ED.user_info.battleCache.byAttackerObjectsList) then
			self:initBattleInfo(_ED.user_info.battleCache)
		end
	end
end

--跳过当前场战斗过程
function FightModule:jumpCurrentFight(userInfo, resultBuffer)
	-- while tonumber(_ED.user_info.battleCache.currentBattleCount) < tonumber(#_ED.user_info.battleCache.byAttackerObjectsList) do
		-- print("当前场次",_ED.user_info.battleCache.currentBattleCount)
		while self.hasNextRound == true do
			-- print("跳过11",self.hasNextRound,#self.fightOrderList)
			self:rountdFight(resultBuffer)
		end
	-- 	if tonumber(_ED.user_info.battleCache.currentBattleCount) < tonumber(#_ED.user_info.battleCache.byAttackerObjectsList) then
	-- 		self:initBattleInfo(_ED.user_info.battleCache)
	-- 	end
	-- end
end

--重置连击加成倍数
function FightModule:clearAttacksStatus()
	self.gradeAttack = 0
	for s, tempObject in pairs(self.attackObjects) do
		if tempObject ~= nil then
			tempObject.grade_attack = 1
		end
	end
end
--[[
function FightModule:getFirstEnvironmentShip(npc)
	local seatArray = nil
	local environmentShip = nil
	for i = 1,  npc.formationCount do
		local formationId = npc.getEnvironmentFormation(i)
		--EnvironmentFormation environmentFormation = (EnvironmentFormation)ConfigDB.load("EnvironmentFormation", formationId)
		--seatArray = new Integer[]{environmentFormation.seatOne, environmentFormation.seatTwo, environmentFormation.seatThree, environmentFormation.seatFour, environmentFormation.seatFive, environmentFormation.seatSix}
		local formationId = npc:getEnvironmentFormation(i)
		local seatArray = {}
		for idx, val in ipairs(seatIndex) do
			seatArray[#seatArray + 1] = dms.int(dms["environment_formation"], formationId, val)
		end
			
		--local amplifyPercentString = dms.string(dms["environment_formation"], formationId, environment_formation.amplify_percentage)
		--local amplifyPercentArray = zstring.split(amplifyPercentString, IniUtil.comma)
			 
		for j, val in pairs(seatArray) do		
		
			if(nil ~= seatArray[j] and 0 ~= seatArray[j]){
				environmentShip = (EnvironmentShip) ConfigDB.load("EnvironmentShip", seatArray[j])
			end
		end
	end
	return environmentShip
end

function FightModule:getTotalHealthPoint(userInfo)
		local seatArray = nil
		local healthPoint= 0
		Formation formation = UserDB.findByUserAndIndex(userInfo.id,  1)
		seatArray = new Integer[]{formation.seatOne, formation.seatTwo, formation.seatThree, formation.seatFour, formation.seatFive, formation.seatSix}
		for (local i = 0; i < seatArray.length; i++) {
			if(nil ~= seatArray[i] and 0 ~= seatArray[i]){
				Ship ship = (Ship) UserDB.load("Ship", seatArray[i])
				healthPoint += ship.power
			}
		}
		return healthPoint
end


function FightModule:getNpcTotalHealthPoint(npc)
	local seatArray = nil
	local healthPoint= 0
	local formationId = npc.getEnvironmentFormation(1)
	local environmentFormation =(EnvironmentFormation)ConfigDB.load("EnvironmentFormation", formationId)
	seatArray = new Integer[]{environmentFormation.seatOne, environmentFormation.seatTwo, environmentFormation.seatThree, environmentFormation.seatFour, environmentFormation.seatFive, environmentFormation.seatSix}
	for (local j = 0; j < seatArray.length; j++) {
		if(nil ~= seatArray[j] and 0 ~= seatArray[j]){
			EnvironmentShip environmentShip = (EnvironmentShip) ConfigDB.load("EnvironmentShip", seatArray[j])
			String difficultyAdditionalArray[] = npc.difficultyAdditional.split("\\|")[0].split(IniUtil.comma)
			healthPoint +=(long) (environmentShip.power * Float.parseFloat(difficultyAdditionalArray[0]))
		}
	}
	return healthPoint
end
--]]
function FightModule:checkDefenceResult()
	local liveHealth = 0
	for _, battleObject in ipairs(self.byAttackObjects) do			
		if(battleObject~=nil and battleObject.isDead ~= true) then
			liveHealth = liveHealth + battleObject.healthPoint
		end
	end
	self.totalDefenceDamage = self.npcMaxHealth - liveHealth
end

function FightModule:initUserBattleField(attackUser, battleCache)
	if(battleCache == nil or attackUser == nil) then
		return
	end
	battleCache.userInfo=attackUser
	battleCache.attackCombatForce=attackUser.combatForce
	battleCache.attackName=attackUser.nickname
	battleCache.attackerObjects=attackUser.attackObjects
	attackUser.battleCache=battleCache
end

function FightModule:initNpcBattleField(attackUser, npc, battleCache)
	if(battleCache == nil or npc == nil or attackUser == nil) then
		return
	end
	battleCache.byAttackerId=npc.id
	battleCache.maxBattleCount= decryptInfo(npc.formationCount)
	local seatArray = {}
	local byAttackerObjectsList = {}
	for i = 1, npc.formationCount do
	
		local byAttackObjects = {}
		local formationId = npc:getEnvironmentFormation(i)
		local seatArray = {}
		for idx, val in ipairs(seatIndex) do
			seatArray[#seatArray + 1] = dms.int(dms["environment_formation"], formationId, val)
		end
		
		local amplifyPercentString = dms.string(dms["environment_formation"], formationId, environment_formation.amplify_percentage)
		local amplifyPercentArray = zstring.split(amplifyPercentString, IniUtil.comma)
		 
		for j, val in ipairs(seatArray) do
			if(nil ~= val and 0 ~= val) then
				local fightObject = FightObject:new(npc, difficulty, j + 1, seatArray[j], fakeLevel, isFake)
				fightObject.amplifyPercent = amplifyPercentArray[j]
				fightObject.name=environmentFormation.formationName
				byAttackObjects[j] = fightObject
			end
		end
		battleCache.byAttackComobatForce(environmentFormation.combatForce)
		table.insert(byAttackerObjectsList, byAttackObjects)
	end			
	
	battleCache.byAttackName=npc.npcName
	battleCache.byAttackerObjectsList=byAttackerObjectsList
	attackUser.battleCache=battleCache
end
--[[
function FightModule:unionFight(userInfo, resultBuffer, obj, member)
		attackCount = 0
		byAttackCount = 0
		fighters = new Object[2][2]
		self.attackDamages = ""
		self.defenceDamages = ""
		self.attackDeadState = ""
		self.defenceDeadState = ""
		roundCount = 0
		boolean fightOver = false
		local attackerCombatForce = 0
		local byAttackerCombatForce = 0
		List<BattleObject> fightOrderList = new ArrayList<BattleObject>()
		local attackIndex = 0
		local byAttackIndex = 0
		local arrLength = attackObjects.length
		boolean win = false
		BattleObject[] tempAttackObjects = attackerCombatForce >= byAttackerCombatForce ? attackObjects : byAttackObjects
		BattleObject[] tempByAttackObjects = attackerCombatForce >= byAttackerCombatForce ? byAttackObjects : attackObjects
		for (local i = 0; i < arrLength; i++) {
			for (; attackIndex<tempAttackObjects.length; attackIndex++){
				if(nil ~= tempAttackObjects[attackIndex]){
					fightOrderList.add(tempAttackObjects[attackIndex])
					if(tempAttackObjects[attackIndex].battleTag == 0){						
						attackCount++
					else
						byAttackCount++
					}
					attackIndex++
					break
				}
			}
			for (; byAttackIndex<tempByAttackObjects.length; byAttackIndex++){
				if(nil ~= tempByAttackObjects[byAttackIndex]){
					fightOrderList.add(tempByAttackObjects[byAttackIndex])
					if(tempByAttackObjects[byAttackIndex].battleTag == 0){						
						attackCount++
					else
						byAttackCount++
					}
					byAttackIndex++
					break
				}
			}
		}
		while(!fightOver){
			if (attackCount <= 0 or byAttackCount<=0){
				win = byAttackCount<=0
				fightOver = true
				break
			}
			if(roundCount == totalRound){
				win = self.fightType == FIGHT_TYPE_PVE_MONEY_TREE
				fightOver = true
				break
			}
			roundCount++
			long nowAttackHeathPoint = self:getBattleObjectHeathPoint(attackObjects)
			long nowDefenceHeathPoint = self:getBattleObjectHeathPoint(byAttackObjects)
			table.insert(resultBuffer, IniUtil.enter)
			table.insert(resultBuffer, roundCount)
			table.insert(resultBuffer, IniUtil.enter)
			byte attackOver = 0
			for (local k = 0; k < fightOrderList.size(); k++) {
				if (attackCount <= 0 or byAttackCount<=0){
					win = byAttackCount<=0
					fightOver = true
					break
				}
				counterBuffer = nil
				battleSkillCount = 0
				battleSkillBuffer = new StringBuffer()
				for (local i = 0; i < attackObjects.length; i++) {
					if(nil ~= attackObjects[i]){
						attackObjects[i].canReAttack=true
						attackObjects[i].clearTalentJudgeResultList()
					}
				}
				for (local i = 0; i < byAttackObjects.length; i++) {
					if(nil ~= byAttackObjects[i]){
						byAttackObjects[i].canReAttack=true
						byAttackObjects[i].clearTalentJudgeResultList()
					}
				}
				BattleObject battleObject = fightOrderList.get(k)
				battleObject.action=true
				battleObject.effectDamage=0
				battleObject.totalEffectDamage=0
				if(battleObject.isDead){
					if(battleObject.battleTag == 0){
						attackObjects[battleObject.coordinate - 1] = nil
					else
						byAttackObjects[battleObject.coordinate - 1] = nil
					}
					fightOrderList.remove(k)
					k--
					sortBattleObject(attackerCombatForce >= byAttackerCombatForce, fightOrderList, battleObject)
				else
					if(battleObject.isDizzy()){
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.commonSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						battleObject:processBuffEffect(userInfo, self, resultBuffer)
						attackOver = 1
						continue
					}
					List<BattleSkill> battleSkillList = nil
					byte skillReleasePosion = 0
					if(battleObject.skillPoint >= 4 and !battleObject.isDisSp()){
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						battleSkillList = battleObject.oneselfBattleSkill
						skillReleasePosion = battleObject.specialSkillMould.skillReleasePosition
						if(battleObject.battleTag == 0){							
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, byAttackObjects))
						else
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, attackObjects))
						}
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.specialSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
					else
						if(battleObject.isParalysis()){
							if (attackOver ~= 0){
								table.insert(resultBuffer, "0")
								table.insert(resultBuffer, IniUtil.compart)
							}
							table.insert(resultBuffer, battleObject.battleTag)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, battleObject.coordinate)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, battleObject.commonSkillMould.id)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							battleObject:processBuffEffect(userInfo, self, resultBuffer)
							attackOver = 1
							continue
						}
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						battleSkillList = battleObject.commonBattleSkill
						skillReleasePosion = battleObject.commonSkillMould.skillReleasePosition
						if(battleObject.battleTag == 0){							
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, byAttackObjects))
						else
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, attackObjects))
						}
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.commonSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
					}
					StringBuffer battleSkillBuffer = new StringBuffer()
					List<Byte> byAttackCoordinates = new ArrayList<Byte>()
					for (BattleSkill battleSkill : battleSkillList) {
						if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP){
							byAttackCoordinates = {}
						}
						if (0 == battleObject.battleTag) {
							if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE){
								if (#byAttackCoordinates == 0){
									byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, self.battleObject, self.byAttackObjects)
								}
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE){
								byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, attackObjects)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT){
								byAttackCoordinates = {}
								table.insert(byAttackCoordinates, battleObject.coordinate)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}
						else
							if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE){
								if (#byAttackCoordinates == 0){									
									byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, attackObjects)
								}
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE){
								byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, self.battleObject, self.byAttackObjects)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT){
								byAttackCoordinates = {}
								table.insert(byAttackCoordinates, battleObject.coordinate)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}
						}
					}
					table.insert(resultBuffer, battleSkillCount)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, battleSkillBuffer)
					table.insert(resultBuffer, self.battleSkillBuffer)
					if(nil ~= counterBuffer){
						table.insert(resultBuffer, counterBuffer)
						counterBuffer = nil
					else
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
					}
					battleSkillCount = 0
					battleObject:processBuffEffect(userInfo, self, resultBuffer)
					attackOver = 1
				}
				if (attackCount <= 0 or byAttackCount<=0){
					win = byAttackCount<=0
					fightOver = true
					break
				}
			}
			table.insert(resultBuffer, "1")
			long endAttackHeathPoint = self:getBattleObjectHeathPoint(attackObjects)
			long endDefenceHeathPoint = self:getBattleObjectHeathPoint(byAttackObjects)
			long attackHeathPoint = nowAttackHeathPoint - endAttackHeathPoint
			long defenceHeathPoint = nowDefenceHeathPoint - endDefenceHeathPoint
			----_crint("第"+roundCount+ "回合双方损血量分别是："+attackHeathPoint+" : "+ defenceHeathPoint)
			attackDamages += "," +attackHeathPoint
			defenceDamages += "," +defenceHeathPoint
			attackDeadState += endAttackHeathPoint <= 0 ? ",1" : ",0"
			defenceDeadState += endDefenceHeathPoint <= 0 ? ",1" : ",0"
		}
		if (IniUtil.isEmpty(attackDamages)) {
			if(attackDamages.startsWith(IniUtil.comma)){				
				attackDamages = string.sub(attackDamages, 1)
			}
		}
		if (IniUtil.isEmpty(defenceDamages)) {
			if(defenceDamages.startsWith(IniUtil.comma)){					
				defenceDamages = string.sub(defenceDamages, 1)
			}
		}
		if (IniUtil.isEmpty(attackDeadState)) {
			if(attackDeadState.startsWith(IniUtil.comma)){					
				attackDeadState = string.sub(attackDeadState, 1)
			}
		}
		if (IniUtil.isEmpty(defenceDeadState)) {
			if(defenceDeadState.startsWith(IniUtil.comma)){				
				defenceDeadState = string.sub(defenceDeadState, 1)
			}
		}
		self.checkFightResult()
		self.checkDefenceResult()
		fighters[member][0] = self.attackObjects
		fighters[member][1] = self.byAttackObjects
		if(win){
			return FIGHT_RESULT_WIN
		}
		else{
			return FIGHT_RESULT_LOST
		}
end

function FightModule:battlegroundFight(userInfo, resultBuffer, member)
		attackCount = 0
		byAttackCount = 0
		self.attackDamages = ""
		self.defenceDamages = ""
		self.attackDeadState = ""
		self.defenceDeadState = ""
		roundCount = 0
		boolean fightOver = false
		local attackerCombatForce = 0
		local byAttackerCombatForce = 0
		List<BattleObject> fightOrderList = new ArrayList<BattleObject>()
		local attackIndex = 0
		local byAttackIndex = 0
		local arrLength = attackObjects.length
		boolean win = false
		BattleObject[] tempAttackObjects = attackerCombatForce >= byAttackerCombatForce ? attackObjects : byAttackObjects
		BattleObject[] tempByAttackObjects = attackerCombatForce >= byAttackerCombatForce ? byAttackObjects : attackObjects
		for (local i = 0; i < arrLength; i++) {
			for (; attackIndex<tempAttackObjects.length; attackIndex++){
				if(nil ~= tempAttackObjects[attackIndex]){
					fightOrderList.add(tempAttackObjects[attackIndex])
					if(tempAttackObjects[attackIndex].battleTag == 0){						
						attackCount++
					else
						byAttackCount++
					}
					attackIndex++
					break
				}
			}
			for (; byAttackIndex<tempByAttackObjects.length; byAttackIndex++){
				if(nil ~= tempByAttackObjects[byAttackIndex]){
					fightOrderList.add(tempByAttackObjects[byAttackIndex])
					if(tempByAttackObjects[byAttackIndex].battleTag == 0){						
						attackCount++
					else
						byAttackCount++
					}
					byAttackIndex++
					break
				}
			}
		}
		while(!fightOver){
			if (attackCount <= 0 or byAttackCount<=0){
				win = byAttackCount<=0
				fightOver = true
				break
			}
			if(roundCount == totalRound){
				win = self.fightType == FIGHT_TYPE_PVE_MONEY_TREE
				fightOver = true
				break
			}
			roundCount++
			long nowAttackHeathPoint = self:getBattleObjectHeathPoint(attackObjects)
			long nowDefenceHeathPoint = self:getBattleObjectHeathPoint(byAttackObjects)
			table.insert(resultBuffer, IniUtil.enter)
			table.insert(resultBuffer, roundCount)
			table.insert(resultBuffer, IniUtil.enter)
			byte attackOver = 0
			for (local k = 0; k < fightOrderList.size(); k++) {
				if (attackCount <= 0 or byAttackCount<=0){
					win = byAttackCount<=0
					fightOver = true
					break
				}
				counterBuffer = nil
				battleSkillCount = 0
				battleSkillBuffer = new StringBuffer()
				for (local i = 0; i < attackObjects.length; i++) {
					if(nil ~= attackObjects[i]){
						attackObjects[i].canReAttack=true
						attackObjects[i].clearTalentJudgeResultList()
					}
				}
				for (local i = 0; i < byAttackObjects.length; i++) {
					if(nil ~= byAttackObjects[i]){
						byAttackObjects[i].canReAttack=true
						byAttackObjects[i].clearTalentJudgeResultList()
					}
				}
				BattleObject battleObject = fightOrderList.get(k)
				battleObject.action=true
				battleObject.effectDamage=0
				battleObject.totalEffectDamage=0
				if(battleObject.isDead){
					if(battleObject.battleTag == 0){
						attackObjects[battleObject.coordinate - 1] = nil
					else
						byAttackObjects[battleObject.coordinate - 1] = nil
					}
					fightOrderList.remove(k)
					k--
					sortBattleObject(attackerCombatForce >= byAttackerCombatForce, fightOrderList, battleObject)
				else
					if(battleObject.isDizzy()){
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.commonSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						battleObject:processBuffEffect(userInfo, self, resultBuffer)
						attackOver = 1
						continue
					}
					List<BattleSkill> battleSkillList = nil
					byte skillReleasePosion = 0
					if(battleObject.skillPoint >= 4 and !battleObject.isDisSp()){
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						battleSkillList = battleObject.oneselfBattleSkill
						skillReleasePosion = battleObject.specialSkillMould.skillReleasePosition
						if(battleObject.battleTag == 0){							
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, byAttackObjects))
						else
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, attackObjects))
						}
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.specialSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
					else
						if(battleObject.isParalysis()){
							if (attackOver ~= 0){
								table.insert(resultBuffer, "0")
								table.insert(resultBuffer, IniUtil.compart)
							}
							table.insert(resultBuffer, battleObject.battleTag)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, battleObject.coordinate)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, battleObject.commonSkillMould.id)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							battleObject:processBuffEffect(userInfo, self, resultBuffer)
							attackOver = 1
							continue
						}
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						battleSkillList = battleObject.commonBattleSkill
						skillReleasePosion = battleObject.commonSkillMould.skillReleasePosition
						if(battleObject.battleTag == 0){							
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, byAttackObjects))
						else
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, attackObjects))
						}
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.commonSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
					}
					StringBuffer battleSkillBuffer = new StringBuffer()
					List<Byte> byAttackCoordinates = new ArrayList<Byte>()
					for (BattleSkill battleSkill : battleSkillList) {
						if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP){
							byAttackCoordinates = {}
						}
						if (0 == battleObject.battleTag) {
							if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE){
								if (#byAttackCoordinates == 0){
									byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, self.battleObject, self.byAttackObjects)
								}
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE){
								byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, attackObjects)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT){
								byAttackCoordinates = {}
								table.insert(byAttackCoordinates, battleObject.coordinate)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}
						else
							if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE){
								if (#byAttackCoordinates == 0){									
									byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, attackObjects)
								}
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE){
								byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, self.battleObject, self.byAttackObjects)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT){
								byAttackCoordinates = {}
								table.insert(byAttackCoordinates, battleObject.coordinate)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}
						}
					}
					table.insert(resultBuffer, battleSkillCount)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, battleSkillBuffer)
					table.insert(resultBuffer, self.battleSkillBuffer)
					if(nil ~= counterBuffer){
						table.insert(resultBuffer, counterBuffer)
						counterBuffer = nil
					else
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
					}
					battleSkillCount = 0
					battleObject:processBuffEffect(userInfo, self, resultBuffer)
					attackOver = 1
				}
				if (attackCount <= 0 or byAttackCount<=0){
					win = byAttackCount<=0
					fightOver = true
					break
				}
			}
			table.insert(resultBuffer, "1")
			----_crint("第"+roundCount+ "回合双方损血量分别是："+nowAttackHeathPoint+" : "+ nowDefenceHeathPoint)
			long endAttackHeathPoint = self:getBattleObjectHeathPoint(attackObjects)
			long endDefenceHeathPoint = self:getBattleObjectHeathPoint(byAttackObjects)
			long attackHeathPoint = nowAttackHeathPoint - endAttackHeathPoint
			long defenceHeathPoint = nowDefenceHeathPoint - endDefenceHeathPoint
			----_crint("第"+roundCount+ "回合双方损血量分别是："+attackHeathPoint+" : "+ defenceHeathPoint)
			attackDamages += "," +attackHeathPoint
			defenceDamages += "," +defenceHeathPoint
			attackDeadState += endAttackHeathPoint <= 0 ? ",1" : ",0"
			defenceDeadState += endDefenceHeathPoint <= 0 ? ",1" : ",0"
		}
		if (IniUtil.isEmpty(attackDamages)) {
			if(attackDamages.startsWith(IniUtil.comma)){				
				attackDamages = string.sub(attackDamages, 1)
			}
		}
		if (IniUtil.isEmpty(defenceDamages)) {
			if(defenceDamages.startsWith(IniUtil.comma)){					
				defenceDamages = string.sub(defenceDamages, 1)
			}
		}
		if (IniUtil.isEmpty(attackDeadState)) {
			if(attackDeadState.startsWith(IniUtil.comma)){					
				attackDeadState = string.sub(attackDeadState, 1)
			}
		}
		if (IniUtil.isEmpty(defenceDeadState)) {
			if(defenceDeadState.startsWith(IniUtil.comma)){				
				defenceDeadState = string.sub(defenceDeadState, 1)
			}
		}
		if(win){
			return FIGHT_RESULT_WIN
		}
		else{
			return FIGHT_RESULT_LOST
		}
end
--]]
function FightModule:initAttackerBattleInfo(battleCache)
		local attackObjects = battleCache.attackerObjects
		self.totalHealth = 0
		self.attackObjects = {}
		for i, attackObject in pairs(attackObjects) do
			if(nil ~= attackObject) then			
				local battleObject = BattleObject:new(attackObject)
				self.attackObjects[i] = battleObject
				self.shipCount = self.shipCount + 1
				self.totalHealth = self.totalHealth + battleObject.healthMaxPoint
			end
		end
end

function FightModule:initAttackerBattleInfo(attackUser)
	FightModule:initAttackerBattleInfo(attackUser.battleCache)
end
--[[
function FightModule:initAttackerBattleInfo(attackUser, fighter)
		totalHealth = 0
		local damage = fighter.damage
		local defence = fighter.defence
		FightObject[] attackObjects = new FightObject[6]
		Integer seatArray[] = nil
		Formation formation = UserDB.findByUserAndIndex(attackUser.id,  1)
		seatArray = new Integer[]{formation.seatOne, formation.seatTwo, formation.seatThree, formation.seatFour, formation.seatFive, formation.seatSix}
		for (local i = 0; i < seatArray.length; i++) {
			if(nil ~= seatArray[i] and 0 ~= seatArray[i]){
				FightObject fightObject = new FightObject((byte) (i + 1), seatArray[i],  0)
				attackObjects[i] = fightObject
			}
		}
		for (local i = 0; i < attackObjects.length; i++) {
			self.attackObjects[i] = nil
			if(nil ~= attackObjects[i]){				
				BattleObject battleObject = new BattleObject(attackObjects[i])
				damage = battleObject.finalDamagePercent
				defence = battleObject.finalLessenDamagePercent
				battleObject.finalDamagePercent=damage
				battleObject.finalLessenDamagePercent=defence
				self.attackObjects[i] = battleObject
				shipCount++
				totalHealth+=battleObject.healthMaxPoint
			}
		}
end

function FightModule:initByAttackerBattleInfo(attackUser, fighter)
		FightObject[] attackObjects = new FightObject[6]
		Integer seatArray[] = nil
		local damage = fighter.damage
		local defence = fighter.defence
		Formation formation = UserDB.findByUserAndIndex(attackUser.id,  1)
		seatArray = new Integer[]{formation.seatOne, formation.seatTwo, formation.seatThree, formation.seatFour, formation.seatFive, formation.seatSix}
		for (local i = 0; i < seatArray.length; i++) {
			if(nil ~= seatArray[i] and 0 ~= seatArray[i]){
				FightObject fightObject = new FightObject((byte) (i + 1), seatArray[i],  1)
				attackObjects[i] = fightObject
			}
		}
		for (local i = 0; i < attackObjects.length; i++) {
			self.byAttackObjects[i] = nil
			if(nil ~= attackObjects[i]){				
				BattleObject battleObject = new BattleObject(attackObjects[i])
				damage = battleObject.finalDamagePercent
				defence = battleObject.finalLessenDamagePercent
				battleObject.finalDamagePercent=damage
				battleObject.finalLessenDamagePercent=defence
				self.byAttackObjects[i] = battleObject
			}
		}
end

function FightModule:initByAttackerBattleInfo(battleCache)
		npcMaxHealth = 0
		FightObject byAttackObjects[]  = battleCache.byAttackerObjectsList.get(battleCache.currentBattleCount)
		for (local i = 0; i < byAttackObjects.length; i++) {
			if(nil ~= byAttackObjects[i]){				
				BattleObject battleObject = new BattleObject(byAttackObjects[i])
				self.byAttackObjects[i] = battleObject
				npcMaxHealth += battleObject.healthMaxPoint
			}
		}
end

function FightModule:initByAttackerBattleInfo(npc)
	self.npcMaxHealth = 0
	local seatArray = nil
	local byAttackerObjectsList = {}
	for i = 1, npc.formationCount do
		local byAttackObjects = {}
		local formationId = npc:getEnvironmentFormation(i)

		local seatIndex = {environment_formation.seat_one, environment_formation.seat_two, environment_formation.seat_three,
			environment_formation.seat_four, environment_formation.seat_five, environment_formation.seat_six}
		local seatArray = {}
		for idx, val in pairs(seatIndex) do
			seatArray[#seatArray + 1] = dms.local(dms["environment_formation"], formationId, val)
		end
			
		local amplifyPercentString = dms.string(dms["environment_formation"], formationId, environment_formation.amplify_percentage)
		local amplifyPercentArray = zstring.split(amplifyPercentString, IniUtil.comma)
			
		for j, val in pairs(seatArray) do
			if(nil ~= seatArray[j] and 0 ~= seatArray[j]){
				local fightObject = FightObject:new(npc, 1,  (j + 1), seatArray[j], fakeLevel, isFake)
				fightObject.amplifyPercent=amplifyPercentArray[j]
				fightObject.name=environmentFormation.formationName
				if(fightType == FIGHT_TYPE_PVE_WORLD_BOSS) then
					fightObject.healthPoint=ConfigDB.worldBossPower
				end
				byAttackObjects[j] = fightObject
			end
		end
		byAttackerObjectsList.add(byAttackObjects)
	end
	local byAttackObjects  = byAttackerObjectsList.get(0)
	for i = 1, 6 do
		self.byAttackObjects[i] = nil
		if(nil ~= byAttackObjects[i]) then			
			BattleObject battleObject = BattleObject:new(byAttackObjects[i])
			self.byAttackObjects[i] = battleObject
			npcMaxHealth = npcMaxHealth + battleObject.healthMaxPoint
		end
	end
end
--]]
--[[
function FightModule:writeFashionEquipmentInit(attacker, byAttacker, resultBuffer)
		if(Constant.CURRENT_PROJECT_NAME.equals("koa")){
		}
end

function FightModule:dragonTigerfight(userInfo, resultBuffer)
		attackCount = 0
		byAttackCount = 0
		BattleCache tempBattleCache = (BattleCache)userInfo.battleCache
		initBattleInfo(tempBattleCache)
		roundCount = 0
		boolean fightOver = false
		local attackerCombatForce = tempBattleCache.attackCombatForce
		local byAttackerCombatForce = tempBattleCache.byAttackComobatForce
		List<BattleObject> fightOrderList = new ArrayList<BattleObject>()
		local attackIndex = 0
		local byAttackIndex = 0
		local arrLength = attackObjects.length
		boolean win = false
		BattleObject[] tempAttackObjects = attackerCombatForce >= byAttackerCombatForce ? attackObjects : byAttackObjects
		BattleObject[] tempByAttackObjects = attackerCombatForce >= byAttackerCombatForce ? byAttackObjects : attackObjects
		for (local i = 0; i < arrLength; i++) {
			for (; attackIndex<tempAttackObjects.length; attackIndex++){
				if(nil ~= tempAttackObjects[attackIndex]){
					fightOrderList.add(tempAttackObjects[attackIndex])
					if(tempAttackObjects[attackIndex].battleTag == 0){						
						attackCount++
					else
						byAttackCount++
					}
					attackIndex++
					break
				}
			}
			for (; byAttackIndex<tempByAttackObjects.length; byAttackIndex++){
				if(nil ~= tempByAttackObjects[byAttackIndex]){
					fightOrderList.add(tempByAttackObjects[byAttackIndex])
					if(tempByAttackObjects[byAttackIndex].battleTag == 0){						
						attackCount++
					else
						byAttackCount++
					}
					byAttackIndex++
					break
				}
			}
		}
		while(!fightOver){
			if (attackCount <= 0 or byAttackCount<=0){
				win = byAttackCount<=0
				fightOver = true
				break
			}
			if(roundCount == totalRound){
				win = self.fightType == FIGHT_TYPE_PVE_MONEY_TREE
				fightOver = true
				break
			}
			roundCount++
			long nowAttackHeathPoint = self:getBattleObjectHeathPoint(attackObjects)
			long nowDefenceHeathPoint = self:getBattleObjectHeathPoint(byAttackObjects)
			table.insert(resultBuffer, IniUtil.enter)
			table.insert(resultBuffer, roundCount)
			table.insert(resultBuffer, IniUtil.enter)
			byte attackOver = 0
			for (local k = 0; k < fightOrderList.size(); k++) {
				if (attackCount <= 0 or byAttackCount<=0){
					win = byAttackCount<=0
					fightOver = true
					break
				}
				counterBuffer = nil
				battleSkillCount = 0
				battleSkillBuffer = new StringBuffer()
				for (local i = 0; i < attackObjects.length; i++) {
					if(nil ~= attackObjects[i]){
						attackObjects[i].canReAttack=true
						attackObjects[i].clearTalentJudgeResultList()
					}
				}
				for (local i = 0; i < byAttackObjects.length; i++) {
					if(nil ~= byAttackObjects[i]){
						byAttackObjects[i].canReAttack=true
						byAttackObjects[i].clearTalentJudgeResultList()
					}
				}
				BattleObject battleObject = fightOrderList.get(k)
				battleObject.action=true
				battleObject.effectDamage=0
				battleObject.totalEffectDamage=0
				if(battleObject.isDead){
					if(battleObject.battleTag == 0){
						attackObjects[battleObject.coordinate - 1] = nil
					else
						byAttackObjects[battleObject.coordinate - 1] = nil
					}
					fightOrderList.remove(k)
					k--
				else
					if(battleObject.isDizzy()){
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.commonSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
						battleObject:processBuffEffect(userInfo, self, resultBuffer)
						attackOver = 1
						continue
					}
					List<BattleSkill> battleSkillList = nil
					byte skillReleasePosion = 0
					if(battleObject.skillPoint >= 4 and !battleObject.isDisSp()){
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						battleSkillList = battleObject.oneselfBattleSkill
						skillReleasePosion = battleObject.specialSkillMould.skillReleasePosition
						if(battleObject.battleTag == 0){							
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, byAttackObjects))
						else
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, attackObjects))
						}
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.specialSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
					else
						if(battleObject.isParalysis()){
							if (attackOver ~= 0){
								table.insert(resultBuffer, "0")
								table.insert(resultBuffer, IniUtil.compart)
							}
							table.insert(resultBuffer, battleObject.battleTag)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, battleObject.coordinate)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, battleObject.commonSkillMould.id)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							table.insert(resultBuffer, 0)
							table.insert(resultBuffer, IniUtil.compart)
							battleObject:processBuffEffect(userInfo, self, resultBuffer)
							attackOver = 1
							continue
						}
						if (attackOver ~= 0){
							table.insert(resultBuffer, "0")
							table.insert(resultBuffer, IniUtil.compart)
						}
						table.insert(resultBuffer, battleObject.battleTag)
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.coordinate)
						table.insert(resultBuffer, IniUtil.compart)
						battleSkillList = battleObject.commonBattleSkill
						skillReleasePosion = battleObject.commonSkillMould.skillReleasePosition
						if(battleObject.battleTag == 0){							
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, byAttackObjects))
						else
							table.insert(resultBuffer, FightUtil.computeMoveCoordinate(battleObject.coordinate, skillReleasePosion, attackObjects))
						}
						table.insert(resultBuffer, IniUtil.compart)
						table.insert(resultBuffer, battleObject.commonSkillMould.id)
						table.insert(resultBuffer, IniUtil.compart)
					}
					StringBuffer battleSkillBuffer = new StringBuffer()
					List<Byte> byAttackCoordinates = new ArrayList<Byte>()
					for (BattleSkill battleSkill : battleSkillList) {
						if (battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_DAMAGEHP or battleSkill.skillInfluence.skillCategory == BattleSkill.SKILL_INFLUENCE_ADDHP){
							byAttackCoordinates = {}
						}
						if (0 == battleObject.battleTag) {
							if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE){
								if (#byAttackCoordinates == 0){
									byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, self.battleObject, self.byAttackObjects)
								}
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE){
								byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, attackObjects)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT){
								byAttackCoordinates = {}
								table.insert(byAttackCoordinates, battleObject.coordinate)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}
						else
							if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OPPOSITE){
								if (#byAttackCoordinates == 0){									
									byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, battleObject, attackObjects)
								}
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, attackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_OURSITE){
								byAttackCoordinates = FightUtil.computeEffectCoordinate(battleObject.coordinate, battleSkill.skillInfluence, self.battleObject, self.byAttackObjects)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}else if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT){
								byAttackCoordinates = {}
								table.insert(byAttackCoordinates, battleObject.coordinate)
								battleSkill:processAttack(userInfo, byAttackCoordinates, battleObject, byAttackObjects, self, battleSkillBuffer)
							}
						}
					}
					table.insert(resultBuffer, battleSkillCount)
					table.insert(resultBuffer, IniUtil.compart)
					table.insert(resultBuffer, battleSkillBuffer)
					table.insert(resultBuffer, self.battleSkillBuffer)
					if(nil ~= counterBuffer){
						table.insert(resultBuffer, counterBuffer)
						counterBuffer = nil
					else
						table.insert(resultBuffer, 0)
						table.insert(resultBuffer, IniUtil.compart)
					}
					battleSkillCount = 0
					battleObject:processBuffEffect(userInfo, self, resultBuffer)
					attackOver = 1
				}
				if (attackCount <= 0 or byAttackCount<=0){
					win = byAttackCount<=0
					fightOver = true
					break
				}
			}
			table.insert(resultBuffer, "1")
			long endAttackHeathPoint = self:getBattleObjectHeathPoint(attackObjects)
			long endDefenceHeathPoint = self:getBattleObjectHeathPoint(byAttackObjects)
			long attackHeathPoint = nowAttackHeathPoint - endAttackHeathPoint
			long defenceHeathPoint = nowDefenceHeathPoint - endDefenceHeathPoint
			----_crint("第"+roundCount+ "回合双方损血量分别是："+attackHeathPoint+" : "+ defenceHeathPoint)
			attackDamages += "," +attackHeathPoint
			defenceDamages += "," +defenceHeathPoint
			attackDeadState += endAttackHeathPoint <= 0 ? ",1" : ",0"
			defenceDeadState += endDefenceHeathPoint <= 0 ? ",1" : ",0"
		}
		attackDamages = string.sub(attackDamages, 1)
		defenceDamages = string.sub(defenceDamages, 1)
		attackDeadState = string.sub(attackDeadState, 1)
		defenceDeadState = string.sub(defenceDeadState, 1)
		self.checkFightResult()
		self.checkDefenceResult()
		if(win){
			return FIGHT_RESULT_WIN
		}
		else{
			return FIGHT_RESULT_LOST
		}
end
--]]
--[[
function FightModule:initRebelArmy()
		if(userRebelArmy ~= nil){
			if(byAttackObjects[0] ~= nil){
				if(userRebelArmy.setOne < 1){
					byAttackObjects[0] = nil
				else
					byAttackObjects[0].healthPoint=userRebelArmy.setOne
				}	
			}
			if(byAttackObjects[1] ~= nil){
				if(userRebelArmy.setTwo < 1){
					byAttackObjects[1] = nil
				else
					byAttackObjects[1].healthPoint=userRebelArmy.setTwo
				}
			}
			if(byAttackObjects[2] ~= nil){
				if(userRebelArmy.setThree < 1){
					byAttackObjects[2] = nil
				else
					byAttackObjects[2].healthPoint=userRebelArmy.setThree
				}
			}
			if(byAttackObjects[3] ~= nil){
				if(userRebelArmy.setFour < 1){
					byAttackObjects[3] = nil
				else
					byAttackObjects[3].healthPoint=userRebelArmy.setFour
				}
			}
			if(byAttackObjects[4] ~= nil){
				if(userRebelArmy.setFive < 1){
					byAttackObjects[4] = nil
				else
					byAttackObjects[4].healthPoint=userRebelArmy.setFive
				}
			}
			if(byAttackObjects[5] ~= nil){
				if(userRebelArmy.setSex < 1){
					byAttackObjects[5] = nil
				else
					byAttackObjects[5].healthPoint=userRebelArmy.setSex
				}
			}
			float doubleAttack = 1
			if(isDouble){
				doubleAttack = 250/100
			}
			if(attackObjects[0] ~= nil){
				attackObjects[0].attack=(local) (attackObjects[0].attack * (attackObjects[0].advance+1) * doubleAttack)
			}
			if(attackObjects[1] ~= nil){
				attackObjects[1].attack=(local) (attackObjects[1].attack * (attackObjects[1].advance+1) * doubleAttack)
			}
			if(attackObjects[2] ~= nil){
				attackObjects[2].attack=(local) (attackObjects[2].attack * (attackObjects[2].advance+1) * doubleAttack)
			}
			if(attackObjects[3] ~= nil){
				attackObjects[3].attack=(local) (attackObjects[3].attack * (attackObjects[3].advance+1) * doubleAttack)
			}
			if(attackObjects[4] ~= nil){
				attackObjects[4].attack=(local) (attackObjects[4].attack * (attackObjects[4].advance+1) * doubleAttack)
			}
			if(attackObjects[5] ~= nil){
				attackObjects[5].attack=(local) (attackObjects[5].attack * (attackObjects[5].advance+1) * doubleAttack)
			}
		}
end
--]]

function FightModule:initFight(npcId, difficulty, fightType,resultBuffer,eveNpc)
	-- local formulaUtil = FormulaUtil:new()
	-- formulaUtil:findFormulaByIndex(1)
	local npcObj = ConfigDB.load("npc", npcId)
	--_crint ("FightModule:initFight ", npcId, difficulty, fightType)
	if(resultBuffer == nil) then
		resultBuffer = {}
	end
	self:initBattleField(npcObj, difficulty, fightType, resultBuffer,eveNpc)
	
	table.insert(resultBuffer, 1, 100)                   -- seq
	table.insert(resultBuffer, 2, IniUtil.enter)
	table.insert(resultBuffer, 3, "battle_field_init")   --cmdname
	table.insert(resultBuffer, 4, IniUtil.enter)
	table.insert(resultBuffer, 5, "0")                   -- result
	table.insert(resultBuffer, 6, IniUtil.enter)
	
	local protocalData = {}
	protocalData.resouce = table.concat(resultBuffer, "")
	
	--_crint ("Using client report data to init battle field \n" .. protocalData.resouce)
	NetworkProtocol.parser_func(protocalData)
end


function FightModule:doFight()
	local resultBuffer = {}
	
	self:fight(_ED.user_info, resultBuffer)
	
	table.insert(resultBuffer, 1, 100)                   -- seq
	table.insert(resultBuffer, 2, IniUtil.enter)
	table.insert(resultBuffer, 3, "environment_fight")   --cmdname
	table.insert(resultBuffer, 4, IniUtil.enter)
	table.insert(resultBuffer, 5, "0")                   -- result
	table.insert(resultBuffer, 6, IniUtil.enter)
	
	local reportString = "" --"100\r\nenvironment_fight\r\n0\r\n39\r\n1\r\n20\r\n3\r\n1\r\n0 1 0 1 3 893 0 1 248 0 0 1 2 -1 -1 0 1 0 2 2 0 0 0 0 1 2 1 0 101 1 0 0 0 0 0 0 0 2 0 1 0 1543 0 1 452 0 0 2 2 -1 -1 0 2 0 2 2 0 0 0 0 1 2 0 0 477 1 0 0 1 1 1 0 0 0 0 3 0 0 7 794 0 1 220 0 0 3 2 -1 -1 0 3 0 2 2 0 0 0 0 1 6 0 0 133 1 0 0 0 0 0 0 1 4 0 0 2 1282 0 1 361 0 1 4 2 -1 -1 1 4 0 2 2 0 0 0 0 0 1 0 0 192 1 0 0 0 0 0 0 1 5 0 0 3 1282 0 1 361 0 1 5 2 -1 -1 1 5 0 2 2 0 0 0 0 0 2 0 0 102 1 0 0 0 0 0 0 1 6 0 0 4 1282 0 1 361 0 1 6 2 -1 -1 1 6 0 2 2 0 0 0 0 0 3 0 0 172 1 0 0 0 0 0 1\r\n2\r\n0 1 0 0 5 893 0 1 248 0 0 1 2 -1 -1 0 1 0 2 2 0 0 0 0 1 4 0 0 107 1 0 0 0 0 0 0 0 2 0 0 0 1543 0 1 452 0 0 2 2 -1 -1 0 2 0 2 2 0 0 0 0 1 5 0 0 446 1 0 0 0 0 0 0 0 3 0 0 7 794 0 1 220 0 0 3 2 -1 -1 0 3 0 2 2 0 0 0 0 1 6 0 0 169 1 0 2 0 0 0 0 1 4 0 0 2 1282 0 1 361 0 1 4 2 -1 -1 1 4 0 2 2 0 0 0 0 0 1 0 0 201 1 0 0 0 0 0 0 1 5 0 0 3 1282 0 1 361 0 1 5 2 -1 -1 1 5 0 2 2 0 0 0 0 0 2 0 0 100 1 0 0 0 0 0 0 1 6 0 0 4 1282 0 1 361 0 1 6 2 -1 -1 1 6 0 2 2 0 0 0 0 0 3 0 0 163 1 0 0 0 0 0 1\r\n3\r\n0 1 0 0 2 894 0 2 249 0 0 1 2 0 1,4 0 1 0 3 5 0 0 0 0 1 4 0 0 204 1 0 0 0 250 0 0 1 1 -1 -1 0 1 0 12 0 1 2 0 0 0 0 0 0 2 0 0 0 1544 0 1 453 0 0 2 4 -1 -1 0 2 0 3 5 0 0 0 0 1 5 0 0 676 1 0 0 1 1 1 1 6 0 0 682 1 0 0 1 1 1 1 4 0 0 722 1 0 0 1 0 0 0 0 1\r\n"
	----_crint("Server report string: ")
	----_crint ("reportString)
	table.insert(resultBuffer, 7, "39")                   -- protocol number
	table.insert(resultBuffer, 8, IniUtil.enter)
	
	reportString = table.concat(resultBuffer, "")
	--_crint ("Battle report is: \n" .. reportString)

	local protocalData = {}
	protocalData.resouce = reportString
	
	--_crint ("Using client report data to replace server data xxxxxxxxxxxxxxxx")
	NetworkProtocol.parser_func(protocalData)
end

function FightModule:setFightIndex(idx)
	if  (_ED.user_info.battleCache ~= nil) then
		_ED.user_info.battleCache.currentBattleCount = encryptInfo(idx)
	else
		--_crint("Set setFightIndex failed")
	end
end

function FightModule:initDailyInstance()
	for i = 1, 6 do
		if(self.attackObjects[i] == nil) then
			--continue
		else
			self.attackObjects[i]:addHealthPoint(self.addHpoint)
			self.attackObjects[i]:addHealthMaxPoint(self.addHpoint)
			self.attackObjects[i]:addAttackValue(self.addAttack)
		end
	end
end

function FightModule:calculateRebelArmy(userRebelArmy)
	local deadCount = 0
	if(byAttackObjects[1] ~= nil and byAttackObjects[1].isDead ~= true) then
		userRebelArmy.setOne=byAttackObjects[1].healthPoint
		deadCount = deadCount + 1
	else
		userRebelArmy.setOne=0
	end
	if(byAttackObjects[2] ~= nil and byAttackObjects[2].isDead ~= true) then
		userRebelArmy.setTwo=byAttackObjects[2].healthPoint
		deadCount = deadCount + 1
	else
		userRebelArmy.setTwo=0
	end
	if(byAttackObjects[3] ~= nil and byAttackObjects[3].isDead ~= true)  then
		userRebelArmy.setThree=byAttackObjects[3].healthPoint
		deadCount = deadCount + 1
	else
		userRebelArmy.setThree=0
	end
	if(byAttackObjects[4] ~= nil and byAttackObjects[4].isDead ~= true)  then
		userRebelArmy.setFour=byAttackObjects[4].healthPoint
		deadCount = deadCount + 1
	else
		userRebelArmy.setFour=0
	end
	if(byAttackObjects[5] ~= nil and byAttackObjects[5].isDead ~= true)  then
		userRebelArmy.setFive=byAttackObjects[5].healthPoint
		deadCount = deadCount + 1
	else
		userRebelArmy.setFive=0
	end
	if(byAttackObjects[6] ~= nil and byAttackObjects[6].isDead ~= true)  then
		userRebelArmy.setSex=byAttackObjects[6].healthPoint
		deadCount = deadCount + 1
	else
		userRebelArmy.setSex=0
	end
	if(deadCount==0)  then
		userRebelArmy.share=0
		userRebelArmy.rebelArmyId=0
	end
end


function FightModule:clear()

    --战斗中的攻击者对象数组
	-- self.attackObjects = {}
	for i, v in pairs(self.attackObjects) do
		v:clear()
		self.attackObjects[i] = nil
	end

	--缓存数据对象
	-- self.attackTempObjects = {}
	for i, v in pairs(self.attackTempObjects) do
		v:clear()
		self.attackTempObjects[i] = nil
	end

	--我方英雄数组
	-- self.heroBattleObjects = {}
	for i, v in pairs(self.heroBattleObjects) do
		v:clear()
		self.heroBattleObjects[i] = nil
	end
	
    --战斗中的被攻者对象数组
	-- self.byAttackObjects = {}
	for i, v in pairs(self.byAttackObjects) do
		v:clear()
		self.byAttackObjects[i] = nil
	end

	--敌方英雄数组
	-- self.armyBattleObjects = {}
	for i, v in pairs(self.armyBattleObjects) do
		v:clear()
		self.armyBattleObjects[i] = nil
	end
	
    --战斗类型
	self.fightType = nil

    --回合计数
	self.roundCount = nil

    --出战人数
	self.shipCount = nil

    --死亡人数
	self.deathCount = nil

    --战斗结果
    self.fightResult = nil

    --剩余血量
	self.surplusHealth = nil

    --总血量
    self.totalHealth = nil

    --用户承受伤害= 总血量-剩余血量
	self.totalAttackDamage = nil

    --NPC承受伤害 = 总血量-剩余
	self.totalDefenceDamage = nil

    self.npcMaxHealth = nil

    self.fakeLevel = nil

    self.isFake = nil

    self.worldBossDamageAdditional = nil

    self.attackDamages = nil

    self.defenceDamages = nil

    self.attackDeadState = nil

    self.defenceDeadState = nil

    -- self.fighters =  {}

    self.userThreeKingdomsInfo = nil

    --日常副本回合数
    self.dailyRoundCount = nil
	
	self.totalRound = nil

    --叛军信息
    self.userRebelArmy = nil

    --是否加倍
    --1 普通 2加倍
    self.isDouble = nil

    --额外加成血量
    self.addHpoint = nil

    --额外加成攻击
    self.addAttack = nil

    --合体技能
    --检查死亡人数和剩余血量
    --检查NPC所受伤害
    self.fitBuffer =  nil
	
	self.attackCount = nil
	self.byAttackCount = nil
	self.headBuffer = nil
	self.bodyBuffer = nil
	self.buffBuffer = nil

	self.fitBattleSkillCount = nil
	-- self.fitHeadBuffer = nil
	-- self.fitBodyBuffer = nil
	self.fitSelfBuffer = nil
	
	self.counterBuffer = nil
	self.battleSkillCount = nil
	self.battleSkillBuffer = nil
	self.tanlentSkillBuffer = nil
	
	-- self.fightOrderList = {}	--定义出手对象列表	table 顺序取出
	
	self.currentObject = nil 	-- 定义当前出手对象
	
	self.nextFightObject = nil   -- 定义下一个出手对象
	
	self.hasNextRound = true	--是否有下一场战斗
	
	self.greadCount = nil	--评分计数
	
	self.star = nil		--星数
	
	self.gradeAttack = nil	--伤害加成

	self.canFreeSkill = nil   		--评分加成

	-- self.rewardProp = {}	--掉落道具
	
	-- self.rewardEquipment = {}	--掉落装备
	
	-- self.rewardCard = {}	--掉落卡牌

	self.maxZolSkillPoint = nil		--合体怒气点数上限

	self.battleTag = nil	--默认我方出手

	self.maxBattleCount = nil
end

-- local obj = FightModule:new()
