
-- 战斗初始对象
-- @author xiaofeng
FightObject = class("FightObject")

function FightObject:ctor()
    --战斗标识
    self.battleTag =  0

    --对象id
    self.id =  0

    --等级
    self.level = 0

    --对战名称
    self.fightName =  ""

    --对象模板id
    self.mouldId =  0

    --对象战船ID
    self.shipMould =  0

    --用户信息
    self.userInfo =  -1

    --名称
    self.name =  ""

    --武将名称
    self.captainName = ""

    --动画标示
    self.picIndex =  ""

    --阵营
    self.campPreference =  0

    --性别
    self.gender =  0

    --品质
    self.quality =  0

    --攻速
    self.attackSpeed = 0

    --攻速加成
    self.attackSpeedPercent= 0 

    --攻速减少百分比
    self.attackSpeedLessenercent = 0 

    --统帅
    self.leader =  0

    --武力
    self.strength =  0

    --智慧
    self.wisdom =  0

    --生命
    self.healthPoint =  0

    --当前血量
    self.currentHealthPoint =  0

    --技能槽
    self.skillPoint =  0

    --攻击
    self.attack =  0

    --物理防御
    self.physicalDefence =  0

    --技能防御
    self.skillDefence =  0

    --暴击
    self.critical =  0

    --暴击倍率
    self.critialMultiple =  1

    --抗暴
    self.criticalResist =  0

    --闪避
    self.evasion =  0

    --命中
    self.accuracy =  0

    --格挡
    self.retain =  0

    --破击
    self.retainBreak =  0

    -- 破击加成
    self.addRetainBreakPercent = 0

    --物理免伤
    self.physicalLessenDamage =  0

    --法术免伤
    self.skillLessenDamage =  0

    --普攻技能
    self.commonSkill =  nil

    --特殊技能
    self.specialSkill =  nil

    --最终伤害加成
    self.finalDamageAddition =  0

    --最终减伤加成
    self.finalSubDamageAddition =  0

    --治疗率
    self.cureOdds =  0

    --被治疗率
    self.byCureOdds =  0

    --初始怒气增加
    self.initialSPIncrease =  0

    --掉落卡片id
    self.rewardCard =  0

    --掉落卡片几率
    self.rewardRatio =  0

    --掉落道具
    self.rewardProp =  0

    --掉落道具几率
    self.rewardPropRatio =  0

    --掉落装备
    self.rewardEquipment =  0

    --掉落装备几率
    self.rewardEquipmentRatio =  0

    --对象坐标
    self.coordinate =  0
	
	--天赋列表
	self.talentMouldList = {}

    --最终伤害比例
    self.finalDamagePercent =  0

    --最终减伤比例
    self.finalLessenDamagePercent =  0

    --放大比例
    self.amplifyPercent =  "1"

    --怒气描述
    self.specialSkillDecribe =  0

    --物理攻击增加
    self.physicalAttackAdd =  0

    --法术攻击增加
    self.skillAttackAdd =  0

    --治疗值增加
    self.cureAdd =  0

    --被治疗值增加
    self.byCureAdd =  0

    --灼烧伤害增加
    self.firingAdd =  0

    --灼烧伤害免疫
    self.byFiringLes =  0

    --中毒伤害增加
    self.posionAdd =  0

    --中毒伤害免伤
    self.byPosionLes =  0

	-- 横扫数据添加
	self.deadlyStrikePersent = 0	-- 必杀百分比
	self.criticalResistSupoerAdditionalPercent = 0 -- 强韧百分比
	self.addDamagePercent = 0		-- 伤害增加百分比
	self.lessenDamagePercent = 0	-- 伤害减少百分比
	self.dyAddDamagePercent = 0		-- 受到伤害增加百分比
	self.dyLessenDamagePercent = 0	-- 受到伤害减少百分比
	self.spAdditionalPercent = 0		-- 聚气增加百分比
	self.spLessenPercent = 0	-- 聚气减少百分比

    --/
    --生命加成百分比
    self.powerAdditionalPercent =  0

    --生命减少百分比
    self.powerLessenPercent =  0

    --攻击加成百分比
    self.courageAdditionalPercent =  0

    --攻击减少百分比
    self.courageLessenPercent =  0

    --物理防御加成百分比
    self.intellectAdditionalPercent =  0

    --物理防御减少百分比
    self.intellectLessenPercent =  0

    --法防加成百分比
    self.nimableAdditionalPercent =  0

    --法防减少百分比
    self.nimableLessenPercent =  0

    --暴击加成百分比
    self.criticalAdditionalPercent =  0

    --暴击减少百分比
    self.criticalLessenPercent =  0

    --抗暴加成百分比
    self.criticalResistAdditionalPercent =  0

    --抗暴减少百分比
    self.criticalResistLessenPercent =  0

    --闪避加成百分比
    self.evasionAdditionalPercent =  0

    --闪避加成百分比
    self.evasionLessenPercent =  0

    --命中加成百分比
    self.accuracyAdditionalPercent =  0

    --命中减少百分比
    self.accuracyLessenPercent =  0

    --挡格加成百分比
    self.retainAdditionalPercent =  0

    --挡格减少百分比
    self.retainLessenPercent =  0

    --破击加成百分比
    self.retainBreakAdditionalPercent =  0

    --破击减少百分比
    self.retainBreakLessenPercent =  0

    --物理免伤加成百分比
    self.physicalLessenDamagePercent =  0

    --法术免伤加成百分比
    self.skillLessenDamagePercent =  0

    --治疗率加成百分比
    self.curePercent =  0

    --被治疗率百分比
    self.byCurePercent =  0

    --被治疗率增加百分比
    self.byCureAdditionalPercent =  0

    --被治疗率减少百分比
    self.byCureLessenPercent =  0

    -- 掉若干血增加若干攻击
    self.addAttackPresent = 0

    -- 对生命低于50%的目标造成伤害增加百分比
    self.addDamagePercent50 = 0

    -- 对生命低于50%的目标受到伤害降低百分比
    self.lessenDamagePercent50 = 0

    -- 对生命低于75%的目标受到伤害增加百分比  
    self.addDamagePercent75 = 0

	--受到暴击伤害减少百分比
    self.byCritLessPercent = 0

    --合体技
    self.zoarium =  0

    --合体对象
    self.zoariumCoordinate =  0

    --进阶等级
    self.advance =  1

    --战船类型
    self.capacity =  0

    --相克类型
    self.restrainMoulds =  {}
	
    self.zoariumSkillPoint = 0

    --模板兵力
    self.forceArray = {}

    self.sprite_id = 0
    self.talent_mould_index_list = nil
    self.capacity = 0
    self.musics = ""

    -- 加密数据
    self.power = 0
    self.courage = 0
    self.intellect = 0
    self.nimable = 0
    self.base_fighting = 0

    self.key_ship_health = ""
	self.key_gas_gather = ""
end

--计算临时属性值
function FightObject:calculateShipProperty(ship,shipMould)
	--计算天赋属性加成
	local talentStateArray = ship.talents
	for i, atkObj in pairs(talentStateArray) do
		if tonumber(atkObj.is_activited) == 1 then	--如果已经激活该天赋
			local talentMould = dms.element(dms["talent_mould"], atkObj.talent_id)
			local baseAdditional = dms.atos(talentMould,talent_mould.base_additional)
			if(baseAdditional ~= nil and baseAdditional ~= "-1") then
				self:addPropertyByInfluenceValue(baseAdditional)
			end
		end
	end

	--计算强化大师属性加成
	local weapon = ship.equipment[1]
	local helmet = ship.equipment[2]
	local belt = ship.equipment[3]
	local armor = ship.equipment[4]
	local attackTreasue = ship.equipment[5]
	local defenceTreasure = ship.equipment[6]
	if(tonumber(weapon.user_equiment_id) ~= 0 and tonumber(helmet.user_equiment_id) ~= 0 and tonumber(belt.user_equiment_id) ~= 0 and tonumber(armor.user_equiment_id) ~= 0
		and tonumber(weapon.ship_id) ~= 0 and tonumber(helmet.ship_id) ~= 0 and tonumber(belt.ship_id) ~= 0 and tonumber(armor.ship_id) ~= 0 )then
		local equipmentStrengthenLevelArray = {weapon.user_equiment_grade,helmet.user_equiment_grade,belt.user_equiment_grade,armor.user_equiment_grade}
		local  minEquipmentLevel = 0
		for i, equipmenLevel in pairs(equipmentStrengthenLevelArray) do
			minEquipmentLevel = equipmenLevel
			for j, tempEquipmentLevel in pairs(equipmentStrengthenLevelArray) do
				if minEquipmentLevel > tempEquipmentLevel then
					minEquipmentLevel = tempEquipmentLevel
				end
			end
			break
		end
		local lessLevel = minEquipmentLevel%10
		minEquipmentLevel = minEquipmentLevel - lessLevel
		-- 装备等级
		local strengthenMasterInfo = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.need_level, minEquipmentLevel)
		if(strengthenMasterInfo ~= nil) then
			local additionalProperty = nil
			for j, obj in pairs(strengthenMasterInfo) do
				local masterType = dms.atoi(obj,strengthen_master_info.master_type)
				if tonumber(masterType) == 0 then
					additionalProperty =  dms.atos(obj,strengthen_master_info.additional_property)
					break
				end
			end
			if(additionalProperty ~= nil and additionalProperty ~= "-1") then
				self:addPropertyByInfluenceValue(additionalProperty)
			end
		end
		-- 装备精炼
		local equipmentRankLevelArray = {weapon.equiment_refine_level,helmet.equiment_refine_level,belt.equiment_refine_level,armor.equiment_refine_level}
		minEquipmentLevel = 0
		for i, equipmenLevel in pairs(equipmentRankLevelArray) do
			minEquipmentLevel = equipmenLevel
			for j, tempEquipmentLevel in pairs(equipmentRankLevelArray) do
				if minEquipmentLevel > tempEquipmentLevel then
					minEquipmentLevel = tempEquipmentLevel
				end
			end
			break
		end
		lessLevel = minEquipmentLevel%10
		minEquipmentLevel = minEquipmentLevel - lessLevel
		strengthenMasterInfo = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.need_level, minEquipmentLevel)
		if(strengthenMasterInfo ~= nil) then
			local additionalProperty = nil
			for j, obj in pairs(strengthenMasterInfo) do
				local masterType = dms.atoi(obj,strengthen_master_info.master_type)
				if tonumber(masterType) == 1 then
					additionalProperty =  dms.atos(obj,strengthen_master_info.additional_property)
					break
				end
			end
			if(additionalProperty ~= nil and additionalProperty ~= "-1") then
				self:addPropertyByInfluenceValue(additionalProperty)
			end
		end
	end
	-- 宝物
	if(tonumber(attackTreasue.user_equiment_id) ~= 0 and tonumber(defenceTreasure.user_equiment_id) ~= 0
		and tonumber(attackTreasue.ship_id) ~= 0 and tonumber(defenceTreasure.ship_id) ~= 0)then
		local equipmentStrengthenLevelArray = {attackTreasue.user_equiment_grade,defenceTreasure.user_equiment_grade}
		local  minEquipmentLevel = 0
		for i, equipmenLevel in pairs(equipmentStrengthenLevelArray) do
			minEquipmentLevel = equipmenLevel
			for j, tempEquipmentLevel in pairs(equipmentStrengthenLevelArray) do
				if minEquipmentLevel > tempEquipmentLevel then
					minEquipmentLevel = tempEquipmentLevel
				end
			end
			break
		end
		local lessLevel = minEquipmentLevel%10
		minEquipmentLevel = minEquipmentLevel - lessLevel
		-- 装备等级
		local strengthenMasterInfo = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.need_level, minEquipmentLevel)
		if(strengthenMasterInfo ~= nil) then
			local additionalProperty = nil
			for j, obj in pairs(strengthenMasterInfo) do
				local masterType = dms.atoi(obj,strengthen_master_info.master_type)
				if tonumber(masterType) == 2 then
					additionalProperty =  dms.atos(obj,strengthen_master_info.additional_property)
					break
				end
			end
			if(additionalProperty ~= nil and additionalProperty ~= "-1") then
				self:addPropertyByInfluenceValue(additionalProperty)
			end
		end
		-- 装备精炼
		local equipmentRankLevelArray = {attackTreasue.equiment_refine_level,defenceTreasure.equiment_refine_level}
		minEquipmentLevel = 0
		for i, equipmenLevel in pairs(equipmentRankLevelArray) do
			minEquipmentLevel = equipmenLevel
			for j, tempEquipmentLevel in pairs(equipmentRankLevelArray) do
				if minEquipmentLevel > tempEquipmentLevel then
					minEquipmentLevel = tempEquipmentLevel
				end
			end
			break
		end
		lessLevel = minEquipmentLevel%10
		minEquipmentLevel = minEquipmentLevel - lessLevel
		strengthenMasterInfo = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.need_level, minEquipmentLevel)
		if(strengthenMasterInfo ~= nil) then
			local additionalProperty = nil
			for j, obj in pairs(strengthenMasterInfo) do
				local masterType = dms.atoi(obj,strengthen_master_info.master_type)
				if tonumber(masterType) == 3 then
					additionalProperty =  dms.atos(obj,strengthen_master_info.additional_property)
					break
				end
			end
			if(additionalProperty ~= nil and additionalProperty ~= "-1") then
				self:addPropertyByInfluenceValue(additionalProperty)
			end
		end
	end
end

function FightObject:addPropertyByInfluenceValue(attributeValue)
	if (attributeValue == nil or "" == attributeValue) then
		return
	end
	local propertyTypeArray = zstring.split(attributeValue, "|")
	--for (local property ) then propertyTypeArray) {
	for _, property in pairs(propertyTypeArray) do
		local propertyType = tonumber(zstring.split(property, ",")[1])
		local propertyValue = tonumber(zstring.split(property, ",")[2])
		-- if (propertyType == EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL) then
		-- 	self.healthPoint = self.healthPoint + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL) then
		-- 	self.attack = self.attack + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL) then
		-- 	self.physicalDefence = self.physicalDefence + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL) then
		-- 	self.skillDefence = self.skillDefence + propertyValue
		-- 	--break
		-- else
		-- if (propertyType == EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL_PERCENTAGE) then
		-- 	if(propertyValue < 1) then
		-- 		propertyValue = propertyValue * 100
		-- 	end
		-- 	self.powerAdditionalPercent = self.powerAdditionalPercent + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL_PERCENTAGE) then
		-- 	if(propertyValue < 1) then
		-- 		propertyValue = propertyValue * 100
		-- 	end
		-- 	self.courageAdditionalPercent = self.courageAdditionalPercent + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL_PERCENTAGE) then
		-- 	if(propertyValue < 1) then
		-- 		propertyValue = propertyValue * 100
		-- 	end
		-- 	self.intellectAdditionalPercent = self.intellectAdditionalPercent + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL_PERCENTAGE) then
		-- 	if(propertyValue < 1) then
		-- 		propertyValue = propertyValue * 100
		-- 	end
		-- 	self.nimableAdditionalPercent = self.nimableAdditionalPercent + propertyValue
		-- 	--break
		-- else
		if (propertyType == EquipmentMould.PROPERTY_TYPE_CRITICAL_ODDS) then
			self.criticalAdditionalPercent = self.criticalAdditionalPercent + propertyValue
			--break
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CRITICAL_RESIST_ODDS) then
			self.criticalResistAdditionalPercent = self.criticalResistAdditionalPercent + propertyValue
			--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_RETAIN_ODDS) then
		-- 	self.retainAdditionalPercent = self.retainAdditionalPercent + propertyValue
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_RETAIN_BREAK_ODDS) then
		-- 	self.retainBreakAdditionalPercent  = self.retainBreakAdditionalPercent + propertyValue
		-- 	--break
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_ACCURACY_ODDS) then
			self.accuracyAdditionalPercent  = self.accuracyAdditionalPercent + propertyValue
			--break
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_EVASION_ODDS) then
			self.evasionAdditionalPercent  = self.evasionAdditionalPercent + propertyValue
			--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_LESSEN_DAMAGE_PERCENTAGE) then
		-- 	self.physicalLessenDamagePercent  = self.physicalLessenDamagePercent + (propertyValue / 100)
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_LESSEN_DAMAGE_PERCENTAGE) then
		-- 	self.skillLessenDamagePercent  = self.skillLessenDamagePercent + (propertyValue / 100)
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CURE_ODDS) then
		-- 	self.curePercent  = self.curePercent + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_BY_CURE_ODDS) then
		-- 	self.byCurePercent  = self.byCurePercent + propertyValue
		-- 	--break
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE) then
			self.finalDamageAddition  = self.finalDamageAddition + propertyValue
			--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE) then
		-- 	self.finalSubDamageAddition  = self.finalSubDamageAddition + propertyValue
		-- 	--break
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_INITIAL_SP_INCREASE) then
			self.initialSPIncrease  = self.initialSPIncrease + propertyValue
			--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_INITIAL_HEAD) then
		-- 	self.leader  = self.leader + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_INITIAL_BODY) then
		-- 	self.strength  = self.strength + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_INITIAL_WISDOM) then
		-- 	self.wisdom  = self.wisdom + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_ATTACK_ADDITIONAL) then
		-- 	self.physicalAttackAdd  = self.physicalAttackAdd + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_ATTACK_ADDITIONAL) then
		-- 	self.skillAttackAdd  = self.skillAttackAdd + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_CURE_ADDITIONAL) then
		-- 	self.cureAdd  = self.cureAdd + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_BY_CURE_ADDITIONAL) then
		-- 	self.byCureAdd  = self.byCureAdd + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FIRING_ADDITIONAL) then
		-- 	self.firingAdd  = self.firingAdd + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_POSION_ADDITIONAL) then
		-- 	self.posionAdd  = self.posionAdd + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FIRING_LESSEN) then
		-- 	self.byFiringLes  = self.byFiringLes + propertyValue
		-- 	--break
		-- elseif (propertyType == EquipmentMould.PROPERTY_TYPE_POSION_LESSEN) then
		-- 	self.byPosionLes  = self.byPosionLes + propertyValue
		-- 	--break
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE_PERCENT) then
			if(propertyValue < 1) then
				propertyValue = propertyValue * 100
			end
			self.finalDamagePercent  = self.finalDamagePercent + propertyValue
			--break
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE_PERCENT) then
			if(propertyValue < 1) then
				propertyValue = propertyValue * 100
			end
			self.finalLessenDamagePercent  = self.finalLessenDamagePercent + propertyValue
			--break
		elseif (propertyType == EquipmentMould.PROPERTY_TYPE_FINAL_INIT_ZOMALSKILLPOINT) then
			self.zoariumSkillPoint = propertyValue
		else
		end
	end
end

-- 计算Npc数值，读取environment_ship的值
function FightObject:initWithNpc(npc, difficulty, coordinate, environmentShipId, fakeLevel, isFake, isPartner) 
	----_crint ("Call initialize function: ") 
	self.battleTag = 1
	self.coordinate = coordinate
	self.isPartner = false
	if isPartner then
		self.isPartner = true
	end

	--local npcDifficultArray = zstring.split(npc.difficultyAdditional, "|")[difficulty]
	local difficultyAdditionalArray = {1, 1, 1, 1, 1, 1} --zstring.split(npcDifficultArray, IniUtil.comma)
	----_crint ("npc.difficultyAdditional: " .. npc.difficultyAdditional)
	----_crint ("npcDifficultArray: " .. npcDifficultArray)
	--local environmentShip = EnvironmentShip:new()
	--Transformers.environmentShipDAOProxy().load(environmentShipId);
	if (fakeLevel == nil) then
		fakeLevel = 1
	end	
	environmentShip = ConfigDB.load('environment_ship', environmentShipId)

	if(isFake) then
		environmentShip.power = environmentShip.power + ((fakeLevel - 1) * environmentShip.growPower)
		environmentShip.courage = environmentShip.courage + ((fakeLevel - 1) * environmentShip.growCourage)
		environmentShip.intellect = environmentShip.intellect + ((fakeLevel - 1) * environmentShip.growIntellect)
		environmentShip.nimable = environmentShip.nimable + ((fakeLevel - 1) * environmentShip.growNimable)
	end

	environmentShip:calculateShipProperty()
	self.fightName = environmentShip.shipName
	self.id = environmentShipId;
	self.mouldId = environmentShipId;

	--npc等级
	self.level = environmentShip.level

	if npc ~= nil then
		self.id = npc.id
	end
	self.mouldId = environmentShipId
	self.shipMould = environmentShip.directing
	-- self.userInfo = npc.id
	self.picIndex = environmentShip.bustIndex .. ""
	self.campPreference = environmentShip.campPreference
	self.gender = environmentShip.gender
	self.quality = environmentShip.shipType
	-- self.leader = ship.ship_leader                               -- 统帅
	-- self.strength = ship.ship_courage                            	-- 武力
	-- self.wisdom = ship.ship_wisdom                               	-- 智慧
	self.attackSpeed = environmentShip.speed               		 	-- 攻速
	self.healthPoint = environmentShip.power                		-- 血量
	self.currentHealthPoint = environmentShip.power 
	self.skillPoint = environmentShip.haveDeadly
	self.attack = environmentShip.courage                           -- 攻击
	self.physicalDefence = environmentShip.intellect         	 	-- 物防
	self.skillDefence = environmentShip.nimable               		-- 法防
	self.critical = environmentShip.critical
	self.criticalResist = environmentShip.criticalResist
	self.evasion = environmentShip.jink
	self.accuracy = environmentShip.accuracy
	self.retain = environmentShip.retain
	self.retainBreak = environmentShip.retainBreak
	self.common_skill_mould = environmentShip.commonSkillMould
	self.special_skill_mould = environmentShip.skillMould

	self.sprite_id = environmentShip.picIndex
    -- self.talent_mould_index_list = nil
    self.capacity = environmentShip.capacity
    self.musics = environmentShip.soundIndex
    self.captainName = environmentShip.shipName

    self.key_ship_health = aeslua.encrypt("jar-world", environmentShip.power, aeslua.AES128, aeslua.ECBMODE)
	self.key_gas_gather = aeslua.encrypt("jar-world", environmentShip.haveDeadly, aeslua.AES128, aeslua.ECBMODE)

	-- self.userInfo = npc.id
	-- self.picIndex = environmentShip.bustIndex .. "";
	-- self.campPreference = environmentShip.campPreference
	-- self.gender = environmentShip.gender
	-- self.quality = environmentShip.shipType
	-- self.attackSpeed = environmentShip.speed
	-- self.healthPoint =  environmentShip.power * tonumber(difficultyAdditionalArray[1])
	-- self.lessHealthPoint =  environmentShip.power * tonumber(difficultyAdditionalArray[1])
	-- self.skillPoint = 1
	-- ----_crint( "environmentShip.courage: " .. environmentShip.courage)
	-- self.attack =  environmentShip.courage * tonumber(difficultyAdditionalArray[2])
	-- ----_crint ("self.attack = " .. self.attack)
	-- self.physicalDefence =  environmentShip.intellect * tonumber(difficultyAdditionalArray[3])
	-- self.skillDefence =  environmentShip.nimable * tonumber(difficultyAdditionalArray[4])
	-- self.critical = environmentShip.critical
	-- self.criticalResist = environmentShip.criticalResist + environmentShip.criticalResistAdditionalPercent
	-- self.evasion = environmentShip.jink
	-- self.accuracy = environmentShip.accuracy + environmentShip.accuracyAdditionalPercent
	-- self.retain = environmentShip.retain + environmentShip.retainAdditionalPercent
	-- self.retainBreak = environmentShip.retainBreak + environmentShip.retainBreakAdditionalPercent
	-- self.physicalLessenDamage = environmentShip.physicalLessenDamagePercent
	-- self.skillLessenDamage = environmentShip.skillLessenDamagePercent
	self.commonSkill = ConfigDB.load("skill_mould", environmentShip.commonSkillMould)
	if environmentShip.skillMould > 0 then
		self.specialSkill = ConfigDB.load("skill_mould", environmentShip.skillMould)
	else
		self.specialSkill = nil
	end
	
	----_crint ("FightObject:initWithNpc coordinate: " .. coordinate .. ", shipid: " .. environmentShipId)
	----_crint ("Common skillid: " .. self.commonSkill.id .. ", effect: " .. self.commonSkill.healthAffect)
	----_crint ("Special skillid: " .. self.specialSkill.id .. ", effect: " .. self.specialSkill.healthAffect)	
	
	self.finalDamageAddition = 0
	self.finalSubDamageAddition = 0
	--设置掉落物品信息
	self.rewardCard = environmentShip.rewardCard
	self.rewardRatio = environmentShip.rewardCardRatio
	self.rewardProp = environmentShip.dropProp;
	self.rewardPropRatio = environmentShip.dropPropRatio;
	self.rewardEquipment = environmentShip.dropEquipment;
	self.rewardEquipmentRatio = environmentShip.dropEquipmentRatio;

	self.cureOdds = environmentShip.curePercent
	self.byCureOdds = environmentShip.byCurePercent

	self.cureOdds = self.cureOdds
	self.byCureOdds = self.byCureOdds

	self.curePercent = self.byCureOdds

	-- self.skillPoint = self.skillPoint + environmentShip.initialSPIncrease
	self.talentMouldList = environmentShip.talentMouldList
	self.shipMould = environmentShip.directing
	----_crint ("environmentShip.directing : " .. environmentShip.directing)
	self.specialSkillDecribe = 0
	self.capacity = environmentShip.capacity
	-- self.restrainMoulds = {ConfigDB.load("restrain_mould", self.capacity + 1)}
	self.zoariumSkillPoint = environmentShip.zoariumSkillPoint

	self.power = environmentShip.power
    self.courage = environmentShip.courage
    self.intellect = environmentShip.intellect
    self.nimable = environmentShip.nimable
	self.base_fighting = environmentShip.base_fighting
	----_crint ("self.restrainMoulds = " .. self.restrainMoulds.id)
	--os.exit()

	-- print("environment_ship Id:", environmentShipId)
	-- self:printInfo()
end

function FightObject:printInfo()
	print("总基础攻击:", self.attack)
	print("总物理防御:", self.physicalDefence)
	print("总法术防御:", self.skillDefence)
	print("总兵力:", self.healthPoint)
	print("总暴击值:", self.critical)
	print("总韧性值:", self.criticalResist)
	print("总命中值:", self.accuracy)
	print("总闪避值:", self.evasion)
	print("总格挡值:", self.retain)
	print("总破击值:", self.retainBreak)
	print("伤害增加:", self.finalDamageAddition)
	print("伤害减少:", self.finalSubDamageAddition)
	print("法力值(等同于聚气):", self.skillPoint)
	print("总攻速值:", self.attackSpeed)
	print("必杀百分比:", self.deadlyStrikePersent)
	print("强韧百分比:", self.criticalResistSupoerAdditionalPercent)
	print("疗效百分比:", self.curePercent)
	print("加伤百分比:", self.finalDamagePercent)
	print("减伤百分比:", self.finalLessenDamagePercent)
	print("伤害增加百分比:", self.addDamagePercent)
	print("伤害减少百分比:", self.lessenDamagePercent)
end

function FightObject:initWithUserData(coordinate, ship, battleTag, userId, fightType, formation_addition)
	local formation_type = ""
	if fightType ~= nil and fightType == battle_enum._fight_type._fight_type_21 then
		formation_type = dms.string(dms["formation_mould"], _ED.union.union_team_fight_info.formation_type, formation_mould.position_six)
	else
		formation_type = dms.string(dms["formation_mould"], tonumber(_ED.formetion[1]), formation_mould.position)
	end
	self.battleTag = battleTag
	self.coordinate = zstring.tonumber(zstring.split(formation_type, ",")[coordinate])
	local shipMould = ConfigDB.load("ship_mould", ship.ship_template_id)
	local fashionImg =  shipMould.bustIndex	
	local tempCommonSkill = ConfigDB.load("skill_mould", shipMould.skillMould);
	-- 更新后报错 暂不使用 
	-- local tempSpecialSkill = ConfigDB.load("skill_mould", shipMould.deadlySkillMould)

	local add_att_precent = ""
	if formation_addition ~= nil and formation_addition == true then
		add_att_precent = dms.string(dms["formation_mould"], tonumber(_ED.formetion[1]), formation_mould.add_pro1 + coordinate - 1)
	end

	if(tonumber(ship.captain_type) == 0) then
		--学艺技能
		for i , v in pairs(_ED.user_skill_equipment) do
		   if tonumber(v.equip_state) == 1 then
		   		local skillEquipment = dms.element(dms['skill_equipment_mould'],v.skill_equipment_base_mould)
		   		local studySkill = dms.atoi(skillEquipment,skill_equipment_mould.skill_equipment_base_mould)
		   		tempSpecialSkill = ConfigDB.load("skill_mould", studySkill)
		   		break
		   end
		end
	end
	--_crint ("FightObject:initWithUserData coordinate: " .. coordinate .. ", shipid: " .. ship.ship_id)
	--_crint ("shipMould id: " .. shipMould.id)
	--_crint ("Common skillid: " .. tempCommonSkill.id .. ", effect: " .. tempCommonSkill.healthAffect)
	--_crint ("Special skillid: " .. tempSpecialSkill.id .. ", effect: " .. tempSpecialSkill.healthAffect)
	
	if(shipMould.captainType == 0) then
		self.fightName = _ED.user_info.user_name
	end

	--玩家等级
	self.level = _ED.user_info.user_grade

	self.id = ship.ship_id
	self.mouldId = ship.ship_template_id
	self.shipMould =shipMould.baseMould 
	self.userInfo = userId
	self.picIndex = fashionImg .. ""
	self.campPreference = shipMould.campPreference
	self.gender = shipMould.heroGender
	self.quality = shipMould.shipType
	self.leader = ship.ship_leader                               -- 统帅
	self.strength = ship.ship_courage                            -- 武力
	self.wisdom = ship.ship_wisdom                               -- 智慧
	self.attackSpeed = tonumber(ship.attack_speed)               -- 攻速
	self.healthPoint = tonumber(ship.ship_health)                -- 血量
	-- TODO...
	self.currentHealthPoint = tonumber(ship.current_hp)  
	self.skillPoint = tonumber(ship.gas_gather)
	self.attack = ship.ship_courage                              -- 攻击
	self.physicalDefence = tonumber(ship.ship_quick)         	 -- 物防
	self.skillDefence = tonumber( ship.ship_intellect)               -- 法防
	self.critical = tonumber(ship.crit)
	self.criticalResist = tonumber(ship.toughness)
	self.evasion = tonumber(ship.dodge)
	self.accuracy = tonumber(ship.hit)
	self.retain = tonumber(ship.block)
	self.retainBreak = tonumber(ship.wreck)
	self.finalDamageAddition = tonumber(ship.add_damage)
	self.finalSubDamageAddition = tonumber(ship.lessen_damage)

	self.key_ship_health = ship.key_ship_health
	self.key_gas_gather = ship.key_gas_gather

	-- 横扫数据添加
	self.deadlyStrikePersent = tonumber(ship.deadly_strike_persent)		-- 必杀百分比
	self.criticalResistSupoerAdditionalPercent = tonumber(ship.strong_persent)	-- 强韧百分比
	self.curePercent = tonumber(ship.by_cure_persent)					-- 疗效百分比
	self.finalDamagePercent = tonumber(ship.damage_add_persent)			-- 加伤百分比
	self.finalLessenDamagePercent = tonumber(ship.damage_sub_persent)	-- 减伤百分比
	self.addDamagePercent = tonumber(ship.final_damage_add_persent)		-- 伤害增加百分比
	self.lessenDamagePercent = tonumber(ship.final_damage_sub_persent)	-- 伤害减少百分比

	self.cureOdds = self.curePercent
	self.byCureOdds = self.curePercent

	self.commonSkill = tempCommonSkill
	self.specialSkill = tempSpecialSkill
	self.common_skill_mould = shipMould.skillMould

	self.sprite_id = shipMould.shipPic
    self.talent_mould_index_list = shipMould.talentId
    self.capacity = shipMould.capacity
    self.musics = shipMould.soundIndex
    self.captainName = shipMould.captainName

    if fightType == battle_enum._fight_type._fight_type_105 then
    	self.key_ship_health = encryptInfo(self.currentHealthPoint)
    else
	    if add_att_precent ~= "" and tonumber(add_att_precent) ~= -1 then
	    	add_att_precent = zstring.split(add_att_precent, ",")
	    	if tonumber(add_att_precent[1]) == 1 then
			elseif tonumber(add_att_precent[1]) == 2 then
			elseif tonumber(add_att_precent[1]) == 3 then
			elseif tonumber(add_att_precent[1]) == 4 then
				self.healthPoint = math.ceil(self.healthPoint*(1+add_att_precent[2]/100))
				self.currentHealthPoint = math.ceil(self.currentHealthPoint*(1+add_att_precent[2]/100))
				self.key_ship_health = encryptInfo(math.ceil(decryptInfo(self.key_ship_health)*(1+add_att_precent[2]/100)))
			elseif tonumber(add_att_precent[1]) == 5 then
			end
	    end
	end

	--self.finalDamageAddition = ship.getFinalDamageAdditional();
	--self.finalSubDamageAddition = ship.getFinalLessenDamageAdditional();
	--self.cureOdds = ship.getCurePercent();
	--self.byCureOdds = ship.getByCurePercent();
	
	--self.talentMouldList = ship.getTalentMouldList();
	--self.specialSkillDecribe = specialSkillDecribe;
	--self.physicalAttackAdd = ship.getPhysicalAttackAdd();
	--self.skillAttackAdd = ship.getSkillAttackAdd();
	--self.cureAdd = ship.getCureAdd();
	--self.byCureAdd = ship.getByCureAdd();
	--self.firingAdd = ship.getFiringAdd();
	--self.byFiringLes = ship.getByFiringLes();
	--self.posionAdd = ship.getPosionAdd();
	--self.byPosionLes = ship.getByPosionLes();
	--self.advance = shipMould.getInitialRankLevel();
	--self.finalDamagePercent = ship.getFinalDamageAdditionalPercent();
	--self.finalLessenDamagePercent = ship.getFinalLessenDamageAdditionalPercent();
	
	self.restrainMoulds = {ConfigDB.load("restraint_mould", self.capacity + 1)}
	-- 合体技的发动者是自身
	if(shipMould.primeMover == shipMould.baseMould) then
		self.zoarium = shipMould.zoariumSkill
	end
	self:calculateShipProperty(ship,shipMould)
	self.skillPoint = self.skillPoint + self.initialSPIncrease


	-- print("ship ship_mould Id:", ship.ship_template_id)
	-- self:printInfo()
end

function FightObject:initWithPVPUserData(coordinate, ship, battleTag, userId, fightType, formation_addition)
	local formation_type = dms.string(dms["formation_mould"], tonumber(_ED.other_user_info.ship_formation_type), formation_mould.position)
	self.battleTag = battleTag
	self.coordinate = zstring.tonumber(zstring.split(formation_type, ",")[coordinate])

	local add_att_precent = ""
	if formation_addition ~= nil and formation_addition == true then
		add_att_precent = dms.string(dms["formation_mould"], tonumber(_ED.other_user_info.ship_formation_type), formation_mould.add_pro1 + coordinate - 1)
	end

	-- self.coordinate = formation_type[tonumber(_ED.other_user_info.ship_formation[1])][coordinate]
	local shipMould = ConfigDB.load("ship_mould", ship.ship_template_id)
	local fashionImg =  shipMould.bustIndex	
	local tempCommonSkill = ConfigDB.load("skill_mould", shipMould.skillMould);
	-- 更新后报错 暂不使用 
	-- local tempSpecialSkill = ConfigDB.load("skill_mould", shipMould.deadlySkillMould)

	if(tonumber(ship.captain_type) == 0) then
		--学艺技能
		for i , v in pairs(_ED.user_skill_equipment) do
		   if tonumber(v.equip_state) == 1 then
		   		local skillEquipment = dms.element(dms['skill_equipment_mould'],v.skill_equipment_base_mould)
		   		local studySkill = dms.atoi(skillEquipment,skill_equipment_mould.skill_equipment_base_mould)
		   		tempSpecialSkill = ConfigDB.load("skill_mould", studySkill)
		   		break
		   end
		end
	end
	--_crint ("FightObject:initWithUserData coordinate: " .. coordinate .. ", shipid: " .. ship.ship_id)
	--_crint ("shipMould id: " .. shipMould.id)
	--_crint ("Common skillid: " .. tempCommonSkill.id .. ", effect: " .. tempCommonSkill.healthAffect)
	--_crint ("Special skillid: " .. tempSpecialSkill.id .. ", effect: " .. tempSpecialSkill.healthAffect)
	
	self.fightName = _ED.other_user_info.user_name

	--玩家等级
	self.level = _ED.other_user_info.user_level

	self.id = ship.ship_id
	self.mouldId = ship.ship_template_id
	self.shipMould = shipMould.baseMould 
	self.userInfo = userId
	self.picIndex = fashionImg .. ""
	self.campPreference = shipMould.campPreference
	self.gender = shipMould.heroGender
	self.quality = shipMould.shipType
	self.leader = ship.ship_leader                               -- 统帅
	self.strength = ship.ship_courage                            -- 武力
	self.wisdom = ship.ship_wisdom                               -- 智慧
	self.attackSpeed = tonumber(ship.attack_speed)               -- 攻速
	self.healthPoint = tonumber(ship.ship_health)                -- 血量
	self.currentHealthPoint = tonumber(ship.current_hp)  
	self.skillPoint = tonumber(ship.gas_gather)
	self.attack = ship.ship_courage                              -- 攻击
	self.physicalDefence = tonumber(ship.ship_quick)         	 -- 物防
	self.skillDefence = tonumber( ship.ship_intellect)               -- 法防
	self.critical = tonumber(ship.crit)
	self.criticalResist = tonumber(ship.toughness)
	self.evasion = tonumber(ship.dodge)
	self.accuracy = tonumber(ship.hit)
	self.retain = tonumber(ship.block)
	self.retainBreak = tonumber(ship.wreck)
	self.finalDamageAddition = tonumber(ship.add_damage)
	self.finalSubDamageAddition = tonumber(ship.lessen_damage)

	self.key_ship_health = ship.key_ship_health
	self.key_gas_gather = ship.key_gas_gather

	-- 横扫数据添加
	self.deadlyStrikePersent = tonumber(ship.deadly_strike_persent)		-- 必杀百分比
	self.criticalResistSupoerAdditionalPercent = tonumber(ship.strong_persent)	-- 强韧百分比
	self.curePercent = tonumber(ship.by_cure_persent)					-- 疗效百分比
	self.finalDamagePercent = tonumber(ship.damage_add_persent)			-- 加伤百分比
	self.finalLessenDamagePercent = tonumber(ship.damage_sub_persent)	-- 减伤百分比
	self.addDamagePercent = tonumber(ship.final_damage_add_persent)		-- 伤害增加百分比
	self.lessenDamagePercent = tonumber(ship.final_damage_sub_persent)	-- 伤害减少百分比

	self.cureOdds = self.curePercent
	self.byCureOdds = self.curePercent

	self.commonSkill = tempCommonSkill
	self.specialSkill = tempSpecialSkill

	self.common_skill_mould = shipMould.skillMould

	self.sprite_id = shipMould.shipPic
    self.talent_mould_index_list = shipMould.talentId
    self.capacity = shipMould.capacity
    self.musics = shipMould.soundIndex
    self.captainName = shipMould.captainName

    if fightType == battle_enum._fight_type._fight_type_105 then
		self.key_ship_health = encryptInfo(self.currentHealthPoint)
    else
	   	if add_att_precent ~= "" and tonumber(add_att_precent) ~= -1 then
	    	add_att_precent = zstring.split(add_att_precent, ",")
	    	if tonumber(add_att_precent[1]) == 1 then
			elseif tonumber(add_att_precent[1]) == 2 then
			elseif tonumber(add_att_precent[1]) == 3 then
			elseif tonumber(add_att_precent[1]) == 4 then
				self.healthPoint = math.ceil(self.healthPoint*(1+add_att_precent[2]/100))
				self.currentHealthPoint = math.ceil(self.currentHealthPoint*(1+add_att_precent[2]/100))
				self.key_ship_health = encryptInfo(math.ceil(decryptInfo(self.key_ship_health)*(1+add_att_precent[2]/100)))
			elseif tonumber(add_att_precent[1]) == 5 then
			end
	    end
	end

	--self.finalDamageAddition = ship.getFinalDamageAdditional();
	--self.finalSubDamageAddition = ship.getFinalLessenDamageAdditional();
	--self.cureOdds = ship.getCurePercent();
	--self.byCureOdds = ship.getByCurePercent();
	
	--self.talentMouldList = ship.getTalentMouldList();
	--self.specialSkillDecribe = specialSkillDecribe;
	--self.physicalAttackAdd = ship.getPhysicalAttackAdd();
	--self.skillAttackAdd = ship.getSkillAttackAdd();
	--self.cureAdd = ship.getCureAdd();
	--self.byCureAdd = ship.getByCureAdd();
	--self.firingAdd = ship.getFiringAdd();
	--self.byFiringLes = ship.getByFiringLes();
	--self.posionAdd = ship.getPosionAdd();
	--self.byPosionLes = ship.getByPosionLes();
	--self.advance = shipMould.getInitialRankLevel();
	--self.finalDamagePercent = ship.getFinalDamageAdditionalPercent();
	--self.finalLessenDamagePercent = ship.getFinalLessenDamageAdditionalPercent();
	
	self.capacity = shipMould.capacity
	self.restrainMoulds = {ConfigDB.load("restraint_mould", self.capacity + 1)}
	-- 合体技的发动者是自身
	if(shipMould.primeMover == shipMould.baseMould) then
		self.zoarium = shipMould.zoariumSkill
	end
	self:calculateShipProperty(ship,shipMould)
	self.skillPoint = self.skillPoint + self.initialSPIncrease


	-- print("ship ship_mould Id:", ship.ship_template_id)
	-- self:printInfo()
end

function FightObject:getTalentMouldList()
	return talentMouldList
end

function FightObject:setTalentMouldList(talentMouldList)
	self.talentMouldList = talentMouldList
end

function FightObject:fightObject(forceMould,userId, isPartner)
	local shipMould = ConfigDB.load("ship_mould", dms.atoi(forceMould,ship_force_mould.force_mould))
	local propertyPercent = dms.atoi(forceMould,ship_force_mould.property_percent)/100
	local fightObject = FightObject:new()
	fightObject.id = 0
	fightObject.fightName = self.fightName
	fightObject.mouldId = dms.atoi(forceMould,ship_force_mould.force_mould)
	fightObject.shipMould = dms.atoi(forceMould,ship_force_mould.force_mould)
	fightObject.userInfo = userId
	fightObject.picIndex = shipMould.bustIndex..""
	fightObject.campPreference = shipMould.campPreference
	fightObject.gender = shipMould.gender
	fightObject.quality = shipMould.shipType
	fightObject.leader = shipMould.ship_leader               							-- 统帅
	fightObject.strength = shipMould.ship_courage                           			-- 武力
	fightObject.wisdom = shipMould.ship_wisdom                              			-- 智慧
	fightObject.attackSpeed = tonumber(self.attackSpeed)                				-- 攻速
	fightObject.healthPoint = tonumber(self.healthPoint)*propertyPercent                -- 血量
	fightObject.currentHealthPoint = tonumber(self.currentHealthPoint)*propertyPercent
	fightObject.attack = self.attack*propertyPercent                              		-- 攻击
	fightObject.physicalDefence = tonumber(self.physicalDefence)*propertyPercent        -- 物防
	fightObject.skillDefence = tonumber(self.skillDefence)*propertyPercent              -- 法防
	fightObject.critical = self.critical
	fightObject.criticalResist = self.criticalResist

	fightObject.evasion = self.evasion
	fightObject.accuracy = self.accuracy
	fightObject.retain = self.retain
	fightObject.retainBreak = self.retainBreak

	fightObject.commonSkill = self.commonSkill
	fightObject.specialSkill = self.specialSkill
	fightObject.capacity = self.capacity
	fightObject.skillPoint = self.skillPoint

	fightObject.common_skill_mould = shipMould.skillMould
	fightObject.sprite_id = shipMould.shipPic
    fightObject.talent_mould_index_list = shipMould.talentId
    fightObject.capacity = shipMould.capacity
    fightObject.musics = shipMould.soundIndex
    fightObject.captainName = shipMould.captainName

	fightObject.isPartner = false
	if isPartner then
		fightObject.isPartner = true
	end

	return fightObject
end


function FightObject:clear()
    --战斗标识
    self.battleTag = nil

    --对象id
    self.id = nil

    --等级
    self.level = nil

    --对战名称
    self.fightName = nil

    --对象模板id
    self.mouldId = nil

    --对象战船ID
    self.shipMould = nil

    --用户信息
    self.userInfo = nil

    --名称
    self.name = nil

    --武将名称
    self.captainName = nil

    --动画标示
    self.picIndex = nil

    --阵营
    self.campPreference = nil

    --性别
    self.gender = nil

    --品质
    self.quality = nil

    --攻速
    self.attackSpeed = nil

    --攻速加成
    self.attackSpeedPercent = nil

    --攻速减少百分比
    self.attackSpeedLessenercent = nil

    --统帅
    self.leader = nil

    --武力
    self.strength = nil

    --智慧
    self.wisdom = nil

    --生命
    self.healthPoint = nil

    --当前血量
    self.currentHealthPoint = nil

    --技能槽
    self.skillPoint = nil

    --攻击
    self.attack = nil

    --物理防御
    self.physicalDefence = nil

    --技能防御
    self.skillDefence = nil

    --暴击
    self.critical = nil

    --暴击倍率
    self.critialMultiple = nil

    --抗暴
    self.criticalResist = nil

    --闪避
    self.evasion = nil

    --命中
    self.accuracy = nil

    --格挡
    self.retain = nil

    --破击
    self.retainBreak = nil

    -- 破击加成
    self.addRetainBreakPercent = nil

    --物理免伤
    self.physicalLessenDamage = nil

    --法术免伤
    self.skillLessenDamage = nil

    --普攻技能
    self.commonSkill = nil

    --特殊技能
    self.specialSkill = nil

    --最终伤害加成
    self.finalDamageAddition = nil

    --最终减伤加成
    self.finalSubDamageAddition = nil

    --治疗率
    self.cureOdds = nil

    --被治疗率
    self.byCureOdds = nil

    --初始怒气增加
    self.initialSPIncrease = nil

    --掉落卡片id
    self.rewardCard = nil

    --掉落卡片几率
    self.rewardRatio = nil

    --掉落道具
    self.rewardProp = nil

    --掉落道具几率
    self.rewardPropRatio = nil

    --掉落装备
    self.rewardEquipment = nil

    --掉落装备几率
    self.rewardEquipmentRatio = nil

    --对象坐标
    self.coordinate = nil
	
	--天赋列表
	-- self.talentMouldList = {}
	for i, v in pairs(self.talentMouldList) do
    	 self.talentMouldList[i] = nil
    end
    self.talentMouldList = nil

    --最终伤害比例
    self.finalDamagePercent = nil

    --最终减伤比例
    self.finalLessenDamagePercent = nil

    --放大比例
    self.amplifyPercent = nil

    --怒气描述
    self.specialSkillDecribe = nil

    --物理攻击增加
    self.physicalAttackAdd = nil

    --法术攻击增加
    self.skillAttackAdd = nil

    --治疗值增加
    self.cureAdd = nil

    --被治疗值增加
    self.byCureAdd = nil

    --灼烧伤害增加
    self.firingAdd = nil

    --灼烧伤害免疫
    self.byFiringLes = nil

    --中毒伤害增加
    self.posionAdd = nil

    --中毒伤害免伤
    self.byPosionLes = nil

	-- 横扫数据添加
	self.deadlyStrikePersent = nil	-- 必杀百分比
	self.criticalResistSupoerAdditionalPercent = nil -- 强韧百分比
	self.addDamagePercent = nil		-- 伤害增加百分比
	self.lessenDamagePercent = nil	-- 伤害减少百分比
	self.dyAddDamagePercent = nil		-- 受到伤害增加百分比
	self.dyLessenDamagePercent = nil	-- 受到伤害减少百分比
	self.spAdditionalPercent = nil		-- 聚气增加百分比
	self.spLessenPercent = nil	-- 聚气减少百分比

    --/
    --生命加成百分比
    self.powerAdditionalPercent = nil

    --生命减少百分比
    self.powerLessenPercent = nil

    --攻击加成百分比
    self.courageAdditionalPercent = nil

    --攻击减少百分比
    self.courageLessenPercent = nil

    --物理防御加成百分比
    self.intellectAdditionalPercent = nil

    --物理防御减少百分比
    self.intellectLessenPercent = nil

    --法防加成百分比
    self.nimableAdditionalPercent = nil

    --法防减少百分比
    self.nimableLessenPercent = nil

    --暴击加成百分比
    self.criticalAdditionalPercent = nil

    --暴击减少百分比
    self.criticalLessenPercent = nil

    --抗暴加成百分比
    self.criticalResistAdditionalPercent = nil

    --抗暴减少百分比
    self.criticalResistLessenPercent = nil

    --闪避加成百分比
    self.evasionAdditionalPercent = nil

    --闪避加成百分比
    self.evasionLessenPercent = nil

    --命中加成百分比
    self.accuracyAdditionalPercent = nil

    --命中减少百分比
    self.accuracyLessenPercent = nil

    --挡格加成百分比
    self.retainAdditionalPercent = nil

    --挡格减少百分比
    self.retainLessenPercent = nil

    --破击加成百分比
    self.retainBreakAdditionalPercent = nil

    --破击减少百分比
    self.retainBreakLessenPercent = nil

    --物理免伤加成百分比
    self.physicalLessenDamagePercent = nil

    --法术免伤加成百分比
    self.skillLessenDamagePercent = nil

    --治疗率加成百分比
    self.curePercent = nil

    --被治疗率百分比
    self.byCurePercent = nil

    --被治疗率增加百分比
    self.byCureAdditionalPercent = nil

    --被治疗率减少百分比
    self.byCureLessenPercent = nil

    -- 掉若干血增加若干攻击
    self.addAttackPresent = nil

    -- 对生命低于50%的目标造成伤害增加百分比
    self.addDamagePercent50 = nil

    -- 对生命低于50%的目标受到伤害降低百分比
    self.lessenDamagePercent50 = nil

    -- 对生命低于75%的目标受到伤害增加百分比  
    self.addDamagePercent75 = nil

	--受到暴击伤害减少百分比
    self.byCritLessPercent = nil

    --合体技
    self.zoarium = nil

    --合体对象
    self.zoariumCoordinate = nil

    --进阶等级
    self.advance = nil

    --战船类型
    self.capacity = nil

    --相克类型
    -- self.restrainMoulds =  {}
	
    self.zoariumSkillPoint = nil

    --模板兵力
    -- self.forceArray = {}
    for i, v in pairs(self.forceArray) do
    	v:clear()
    	self.forceArray[i] = nil
    end
    self.forceArray = nil

    if nil ~= self.fitBattleObjects then
	    for i, v in pairs(self.fitBattleObjects) do
	    	v:clear()
	    	self.fitBattleObjects[i] = nil
	    end
	    self.fitBattleObjects = nil
	end

    self.common_skill_mould = nil
    self.sprite_id = nil
    self.talent_mould_index_list = nil
    self.capacity = nil
    self.musics = nil
end

-- local obj = FightObject:new()


