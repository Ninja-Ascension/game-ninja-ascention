-- require('cocos.mobdebug').start()
--战船属性
--auto zhengchengpeng
Ship = class("Ship")
app.load("client.battle.report.EquipmentMould")
--装备类型：武器
EquipmentMould.EQUIPMENT_TYPE_WEAPON = 0;

--装备类型：头盔
EquipmentMould.EQUIPMENT_TYPE_HELMET = 1;

--装备类型：项链
EquipmentMould.EQUIPMENT_TYPE_NECKLACE = 2;

--装备类型：盔甲
EquipmentMould.EQUIPMENT_TYPE_ARMOUR = 3;

--装备类型：战马
EquipmentMould.EQUIPMENT_TYPE_HORSE = 4;

--装备类型：兵书
EquipmentMould.EQUIPMENT_TYPE_BOOK = 5;

--装备类型：时装
EquipmentMould.EQUIPMENT_TYPE_FASHION = 6;

--装备类型：透明时
EquipmentMould.EQUIPMENT_TYPE_HYALINE_FASHION = 7;

--经验宝物
EquipmentMould.EQUIPMENT_TYPE_TREASURE1 = 8;
EquipmentMould.EQUIPMENT_TYPE_TREASURE2 = 9;

--生命加成
EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL = 0;

--攻击加成
EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL = 1;

--物防加成
EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL = 2;

--法防加成
EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL = 3;

--生命加成%
EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL_PERCENTAGE = 4;

--攻击加成%
EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL_PERCENTAGE = 5;

--物防加成%
EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL_PERCENTAGE = 6;

--法防加成%
EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL_PERCENTAGE = 7;

--暴击率%
EquipmentMould.PROPERTY_TYPE_CRITICAL_ODDS = 8;

--抗暴率%
EquipmentMould.PROPERTY_TYPE_CRITICAL_RESIST_ODDS = 9;

--格挡率%
EquipmentMould.PROPERTY_TYPE_RETAIN_ODDS = 10;

--破击率%
EquipmentMould.PROPERTY_TYPE_RETAIN_BREAK_ODDS = 11;

--命中率%
EquipmentMould.PROPERTY_TYPE_ACCURACY_ODDS = 12;

--闪避率%
EquipmentMould.PROPERTY_TYPE_EVASION_ODDS = 13;

--物理免伤%
EquipmentMould.PROPERTY_TYPE_PHYSIC_LESSEN_DAMAGE_PERCENTAGE = 14;

--法术免伤%

EquipmentMould.PROPERTY_TYPE_SKILL_LESSEN_DAMAGE_PERCENTAGE = 15;

--治疗率%
EquipmentMould.PROPERTY_TYPE_CURE_ODDS = 16;

--被治疗率%
EquipmentMould.PROPERTY_TYPE_BY_CURE_ODDS = 17;

--最终伤害
EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE = 18;

--最终减害
EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE = 19;

--初始怒气增加
EquipmentMould.PROPERTY_TYPE_INITIAL_SP_INCREASE = 20;

--统帅增加
EquipmentMould.PROPERTY_TYPE_INITIAL_HEAD = 21;

--体质增加
EquipmentMould.PROPERTY_TYPE_INITIAL_BODY = 22;

--智慧增加
EquipmentMould.PROPERTY_TYPE_INITIAL_WISDOM = 23;

--物理攻击增加
EquipmentMould.PROPERTY_TYPE_PHYSIC_ATTACK_ADDITIONAL = 24;

--法术攻击增加
EquipmentMould.PROPERTY_TYPE_SKILL_ATTACK_ADDITIONAL = 25;

--治疗量增加
EquipmentMould.PROPERTY_TYPE_CURE_ADDITIONAL = 26;

--被治疗量增加
EquipmentMould.PROPERTY_TYPE_BY_CURE_ADDITIONAL = 27;

--灼烧伤害增加
EquipmentMould.PROPERTY_TYPE_FIRING_ADDITIONAL = 28;

--中毒伤害增加
EquipmentMould.PROPERTY_TYPE_POSION_ADDITIONAL = 29;

--灼烧伤害免伤
EquipmentMould.PROPERTY_TYPE_FIRING_LESSEN = 30;

--中毒伤害免伤
EquipmentMould.PROPERTY_TYPE_POSION_LESSEN = 31;
 
--经验
EquipmentMould.PROPERTY_TYPE_EXPERIENCE = 32;

--最终伤害（%）
EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE_PERCENT = 33;

--最终减伤（%）
EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE_PERCENT = 34;

--PVP终伤（%）
EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE_PERCENT_PVP = 35;
 
--PVP免伤（%）
EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE_PERCENT_PVP = 36;

function Ship:ctor()
	self.ship_id = 0
	--穿戴装备数据
	self.equipments = {}
	-- --所属战船模版
	self.shipMould = nil;
	--统帅
	self.leader = 0;

	--武力
	self.strength = 0;

	--智慧
	self.wisdom = 0;

	--血量
	self.power = 0;

	--攻击力	
	self.courage = 0;

	--法防
	self.intellect = 0;

	--物防
	self.nimable = 0;

	--暴击系数
	self.critical = 0;

	--命中系数(闪避)
	self.jink = 0;

	--拥有怒气值 0为拥有，1为没有
	self.haveDeadly = 0;

	--拥有技能
	self.skillMould = 0;

	--技能名称
	self.skillName = "";

	--技能描述
	self.skillDescribe = "";

	--前炮位装备
	self.frontCannon = 0;

	--中炮位装备
	self.middleCannon = 0;

	--后炮位装备
	self.lastCannon = 0;

	--前帆位装备
	self.frontSail = 0;

	--中帆位装备
	self.middleSail = 0;

	--后帆位装备
	self.lastSail = 0;

	--船甲装备
	self.shipArmor = 0;

	--瞭望装备
	self.lookout = 0;

	--霸气装备id列表
	self.powerEquip = "-1,-1,-1,-1,-1,-1,-1";

	--羁绊状态
	self.fateRelationshipState = {};

	--天赋状态
	self.talentState = {};

	--训练状态 -1:未训练 十位:训练位置 个位:训练品质
	self.isTrain = -1;

	--物理攻击特效
	self.physicsAttackEffect = -1; 

	--屏幕攻击特效
	self.screenAttackEffect = -1; 

	--训练结束时间
	self.trainEndTime = os.time();

	--当前战船存放位置
	self.storePlace = 0;

	--成长经验值
	self.growExperience = 0;

	--创建时间
	self.createTime = os.time();

	--眼饰模板
	self.glassesMould=0;

	--耳饰模板
	self.earringsMould=0;

	--帽子模板
	self.headgearMould=0;

	--衣服模板
	self.clothesMould=0;

	--手套模板
	self.glovesMould=0;

	--武器模板
	self.weaponMould=0;

	--鞋子模板
	self.shoesMould=0;

	--翅膀模板
	self.wingMould=0;

	--培养生命值
	self.cultivateValueLife = 0;

	--培养生命临时值
	self.cultivateValueTempLife = 0;

	--培养攻击值
	self.cultivateValueAttack = 0;

	--培养攻击临时值
	self.cultivateValueTempAttack = 0;

	--培养物防值
	self.cultivateValuePhysicalDefence = 0;

	--培养物防临时值
	self.cultivateValueTempPhysicalDefence = 0;

	--培养法防值
	self.cultivateValueSkillDefence = 0;

	--培养法防临时值
	self.cultivateValueTempSkillDefence = 0;

	--培养消耗培养丹数量
	self.cultivateConsumePropCount = 0;

	--天命属性id
	self.destinyPropertyId = 1;

	--天命值
	self.destinyValue = 0;

	--天命消耗天命石数量
	self.destinyConsumePropCount = 0;
	-- 	所属战船位下标
	-- self.shipSeatSuffix = 0;

	-- --战船级别
	self.level = 1;

	-- --当前经验
	-- self.experience = 0;

	-- --当前级别所需要经验
	-- self.levelExperience = 0;

	--生命加成百分比
	self.powerAdditionalPercent = 0;

	--攻击加成百分比
	self.courageAdditionalPercent = 0;

	--物理防御加成百分比
	self.intellectAdditionalPercent = 0;

	--法防加成百分比
	self.nimableAdditionalPercent = 0;

	--暴击加成百分比
	self.criticalAdditionalPercent = 0;

	--抗暴加成百分比
	self.criticalResistAdditionalPercent = 0;

	--闪避加成百分比
	self.evasionAdditionalPercent = 0;

	--命中加成百分比
	self.accuracyAdditionalPercent = 0;

	--挡格加成百分比
	self.retainAdditionalPercent = 0;

	--破击加成百分比
	self.retainBreakAdditionalPercent = 0;

	--物理免伤加成百分比
	self.physicalLessenDamagePercent = 0;

	--法术免伤加成百分比
	self.skillLessenDamagePercent = 0;

	--治疗率加成百分比
	self.curePercent = 0;

	--被治疗率加成百分比
	self.byCurePercent = 0;

	--最终伤害加成
	self.finalDamageAdditional = 0;

	--最终免伤加成
	self.finalLessenDamageAdditional = 0;

	--物理攻击增加
	self.physicalAttackAdd = 0;

	--法术攻击增加
	self.skillAttackAdd = 0;

	--治疗值增加
	self.cureAdd = 0;

	--被治疗值增加
	self.byCureAdd = 0;

	--灼烧伤害增加
	self.firingAdd = 0;

	--灼烧伤害免疫
	self.byFiringLes = 0;

	--中毒伤害增加
	self.posionAdd = 0;

	--中毒伤害免伤
	self.byPosionLes = 0;

	--初始怒气增加
	self.initialSPIncrease = 0;

	--最终伤害加成(%)
	self.finalDamageAdditionalPercent = 0;

	--最终免伤加成(%)
	self.finalLessenDamageAdditionalPercent = 0;

	--天赋模板列表
	self.talentMouldList = {};

	--替换合体技能
	self.zoariumSkill = 0;

	--合体位置
	self.zoariumSeat = 0;
end

--**
-- 转化缓存为战船对象
-- **
function Ship:dataTOShip(ship)
	self.ship_id = ship.ship_id
	local shipMould = dms.element(dms["ship_mould"],ship.ship_template_id)
	self.shipMould = shipMould
	-- --战船级别
	self.level = ship.ship_grade;
	--当前经验
	self.experience = ship.exprience;
	--当前级别所需要经验
	self.levelExperience = ship.grade_need_exprience;
	--统帅
	self.leader = dms.atoi(self.shipMould,ship_mould.leader)
	--武力
	self.strength = dms.atoi(self.shipMould,ship_mould.force)
	--智慧
	self.wisdom = dms.atoi(self.shipMould,ship_mould.wisdom)
	--血量
	self.power = self:computePowerGrow(self,shipMould)
	--攻击力	
	self.courage = self:computeCourageGrow(self,shipMould)
	--法防
	self.intellect = self:computeIntellectGrow(self,shipMould)
	--物防（初始+成长+装备）
	self.nimable = self:computeNimableGrow(self,shipMould)
	--暴击系数
	self.critical = dms.atoi(self.shipMould,ship_mould.initial_critical)
	--命中系数(闪避)
	self.jink = dms.atoi(self.shipMould,ship_mould.initial_jink)
	--拥有怒气值 0为拥有，1为没有
	self.haveDeadly = 0;
	self.equipments = ship.equipment;
	--前炮位装备
	self.frontCannon = ship.equipment[1];
	--中炮位装备
	self.middleCannon = ship.equipment[2];
	--后炮位装备
	self.lastCannon = ship.equipment[3];
	--前帆位装备
	self.frontSail = ship.equipment[4];
	--中帆位装备
	self.middleSail = ship.equipment[5];
	--后帆位装备
	self.lastSail = ship.equipment[6];
	-- --羁绊状态(0:未激活 1:激活)[]
	self.fateRelationshipState = ship.relationship;
	--天赋状态(0:未激活 1:激活)
	self.talentState = ship.talents;
	--培养生命值
	self.cultivateValueLife = ship.ship_train_info.train_life;
	--培养生命临时值
	self.cultivateValueTempLife = ship.ship_train_info.train_life_temp;
	--培养攻击值
	self.cultivateValueAttack = ship.ship_train_info.train_attack;
	--培养攻击临时值
	self.cultivateValueTempAttack = ship.ship_train_info.train_attack_temp;
	--培养物防值
	self.cultivateValuePhysicalDefence = ship.ship_train_info.train_physical_defence;
	--培养物防临时值
	self.cultivateValueTempPhysicalDefence = ship.ship_train_info.train_physical_defence_temp;
	--培养法防值
	self.cultivateValueSkillDefence = ship.ship_train_info.train_skill_defence;
	--培养法防临时值
	self.cultivateValueTempSkillDefence = ship.ship_train_info.train_skill_defence_temp;
	--天命属性id
	self.destinyPropertyId = ship.ship_skillstren.skill_level;
	self.awakenstates = ship.awakenstates
	self.awakenLevel = ship.awakenLevel

	--拥有技能
	-- self.skillMould = ship.skill_mould;
	--技能名称
	-- self.skillName = ship.skill_name;
	-- --技能描述
	-- self.skillDescribe = ship.skill_describe;
	--霸气装备id列表
	-- self.powerEquip = "-1,-1,-1,-1,-1,-1,-1";
	-- 	--船甲装备
	-- self.shipArmor = 0;
	-- --瞭望装备
	-- self.lookout = 0;

	-- --训练状态 -1:未训练 十位:训练位置 个位:训练品质
	-- self.isTrain = -1;

	-- --物理攻击特效
	-- self.physicsAttackEffect = -1; 

	-- --屏幕攻击特效
	-- self.screenAttackEffect = -1; 

	-- --训练结束时间
	-- self.trainEndTime = new Date();

	-- --当前战船存放位置
	-- self.storePlace = 0;

	-- --成长经验值
	-- self.growExperience = 0;

	-- --创建时间
	-- self.createTime = os.time();

	-- --眼饰模板
	-- self.glassesMould=0;

	-- --耳饰模板
	-- self.earringsMould=0;

	-- --帽子模板
	-- self.headgearMould=0;

	-- --衣服模板
	-- self.clothesMould=0;

	-- --手套模板
	-- self.glovesMould=0;

	-- --武器模板
	-- self.weaponMould=0;

	-- --鞋子模板
	-- self.shoesMould=0;

	-- --翅膀模板
	-- self.wingMould=0;
	return self
end

--**
--重新计算战船战力
--**
function  Ship:calculateShipProperty(talents)
	self:calculateShipPropertyByCultivate()
	self:calculateShipPropertyByDestiny()
	self:calculateShipPropertyByLightingStar()
	self:calculateShipPropertyByRelationship()
	-- _crint("self.power1 ", self.power)
	self:calculateShipPropertyByEquipment()
	-- _crint("self.power2 ", self.power)
	self:calculateShipPropertyByLegend()
	-- _crint("self.power3 ", self.power)
	self:calculateAddShipPropertyByAwaken()
	-- _crint("self.power4 ", self.power)
	self:calculateAddShipPropertyByPower()
	-- _crint("self.power5 ", self.power)
	self:calculateShipPropertyByTalent(talents)
	-- self.power = self.power * (100 + self.powerAdditionalPercent) / 100.0; 
	-- self.courage = self.courage * (100 + self.courageAdditionalPercent) / 100.0;
	-- self.intellect = self.intellect * (100 + self.intellectAdditionalPercent) / 100.0;
	-- self.nimable = self.nimable * (100 + self.nimableAdditionalPercent) / 100.0;
	-- self.critical = self.critical + self.criticalAdditionalPercent;
	-- self.jink = self.jink + self.evasionAdditionalPercent;
end

-- 
--  * 计算培养影响船只能力
-- 
function Ship:calculateShipPropertyByCultivate()
	if(tonumber(self.cultivateValueLife) > 0)then
		self.power = tonumber(self.power) + tonumber(self.cultivateValueLife);
	end
	if(tonumber(self.cultivateValueAttack) > 0)then
		self.courage = tonumber(self.courage) + tonumber(self.cultivateValueAttack);
	end
	if(tonumber(self.cultivateValuePhysicalDefence) > 0)then
		self.intellect = tonumber(self.intellect) + tonumber(self.cultivateValuePhysicalDefence);
	end
	if(tonumber(self.cultivateValueSkillDefence) > 0)then
		self.nimable = tonumber(self.nimable) + tonumber(self.cultivateValueSkillDefence);
	end
end

-- 
--  * 计算天命影响船只能力
-- 
function Ship:calculateShipPropertyByDestiny()
	local destinyPropertyParam =  dms.element(dms["destiny_property_param"],self.destinyPropertyId);
	if(nil ~= destinyPropertyParam) then
		self.powerAdditionalPercent =  self.powerAdditionalPercent + dms.atoi(destinyPropertyParam, destiny_property_param.addition_percent_life) / 100;
		self.courageAdditionalPercent = self.courageAdditionalPercent + dms.atoi(destinyPropertyParam, destiny_property_param.addition_percent_attack) / 100;
		self.intellectAdditionalPercent = self.intellectAdditionalPercent + dms.atoi(destinyPropertyParam, destiny_property_param.addition_percent_physical_defence) / 100;
		self.nimableAdditionalPercent = self.nimableAdditionalPercent + dms.atoi(destinyPropertyParam, destiny_property_param.addition_percent_skill_defence) / 100;
	end
end

-- 
--  * 计算点亮命星影响船只能力
-- 
function Ship:calculateShipPropertyByLightingStar()
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		if _ED.cur_destiny_id == nil or _ED.cur_destiny_id == "" then
			--没有到指定级别，下面属性没有赋值 ，协议211 只修改了数码宝贝
			return
		end
	end
	
	self.power = self.power + zstring.tonumber(_ED.hp_add)
	self.courage = self.courage + zstring.tonumber(_ED.atk_add)
	self.intellect = self.intellect + zstring.tonumber(_ED.def_add)
	self.nimable = self.nimable + zstring.tonumber(_ED.res_add)
end

-- 
--  * 计算羁绊影响船只能力
--  * @param userInfo
--  * @param formation
--  * @param resultBuffer
-- 
function Ship:calculateShipPropertyByRelationship()
	for i,v in pairs(self.fateRelationshipState) do
		if(tonumber(v.is_activited) == 1)then
			local fateRelationshipMoul =  dms.element(dms["fate_relationship_mould"],v.relationship_id)
			local life_addition = dms.atoi(fateRelationshipMoul, fate_relationship_mould.life_addition)
			local attack_addition = dms.atoi(fateRelationshipMoul, fate_relationship_mould.attack_addition)
			local physic_defence_addition = dms.atoi(fateRelationshipMoul, fate_relationship_mould.physic_defence_addition)
			local magic_defence_addition = dms.atoi(fateRelationshipMoul, fate_relationship_mould.magic_defence_addition)
			local zoarium_skill = dms.atoi(fateRelationshipMoul, fate_relationship_mould.zoarium_skill)
			if(life_addition ~=nil and life_addition > 0) then
				self.powerAdditionalPercent = self.powerAdditionalPercent + life_addition;
			end
			if(attack_addition ~= nil and attack_addition > 0) then
				self.courageAdditionalPercent = self.courageAdditionalPercent + attack_addition;
			end
			if(physic_defence_addition ~= nil and physic_defence_addition > 0) then
				self.intellectAdditionalPercent = self.intellectAdditionalPercent + physic_defence_addition;
			end
			if(magic_defence_addition ~= nil and magic_defence_addition > 0) then
				self.nimableAdditionalPercent = self.nimableAdditionalPercent + magic_defence_addition;
			end
			if(zoarium_skill ~= nil and zoarium_skill > 0) then
				self.zoariumSkill = zoarium_skill
			end
		end
	end	
end

-- 
--  * 根据影响值改变船只属性
--  * @param influenceValue
-- 
function Ship:addPropertyByInfluenceValue(influenceValue)
	local propertyTypeArray = zstring.split(influenceValue,"|")
	for i,v in pairs(propertyTypeArray) do
		local temp =  zstring.split(v,",")
		local propertyType = temp[1]
		local propertyValue = tonumber(temp[2])
		if(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL)then
			self.power = self.power + propertyValue
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL) then
			self.courage = self.courage + propertyValue
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL) then
			self.intellect = self.intellect + propertyValue; 
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL) then
			self.nimable = self.nimable + propertyValue; 
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL_PERCENTAGE) then
			if(propertyValue < 1) then
				propertyValue = propertyValue * 100;
			end
			if(propertyValue > 100) then
				propertyValue = propertyValue / 100;
			end
			self.powerAdditionalPercent = self.powerAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL_PERCENTAGE) then
			if(propertyValue < 1) then
				propertyValue = propertyValue * 100;
			end
			if(propertyValue > 100)then
				propertyValue = propertyValue / 100;
			end
			self.courageAdditionalPercent = self.courageAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL_PERCENTAGE) then
			if(propertyValue < 1)then
				propertyValue = propertyValue * 100;
			end
			if(propertyValue > 100)then
				propertyValue = propertyValue / 100;
			end
			self.intellectAdditionalPercent = self.intellectAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL_PERCENTAGE) then
			if(propertyValue < 1)then
				propertyValue = propertyValue * 100;
			end
			if(propertyValue > 100)then
				propertyValue = propertyValue / 100;
			end
			self.nimableAdditionalPercent = self.nimableAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_CRITICAL_ODDS) then
			self.criticalAdditionalPercent = self.criticalAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_CRITICAL_RESIST_ODDS) then
			self.criticalResistAdditionalPercent = self.criticalResistAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_RETAIN_ODDS) then
			self.retainAdditionalPercent = self.retainAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_RETAIN_BREAK_ODDS) then
			self.retainBreakAdditionalPercent = self.retainBreakAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_ACCURACY_ODDS) then
			self.accuracyAdditionalPercent = self.accuracyAdditionalPercent + propertyValue
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_EVASION_ODDS) then
			self.evasionAdditionalPercent = self.evasionAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_PHYSIC_LESSEN_DAMAGE_PERCENTAGE) then
			self.physicalLessenDamagePercent = self.physicalLessenDamagePercent + (propertyValue / 100);
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_SKILL_LESSEN_DAMAGE_PERCENTAGE) then
			self.skillLessenDamagePercent = self.skillLessenDamagePercent + (propertyValue / 100);
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_CURE_ODDS) then
			self.curePercent = self.curePercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_BY_CURE_ODDS) then
			self.byCurePercent = self.byCurePercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE) then
			self.finalDamageAdditional = self.finalDamageAdditional + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE) then
			self.finalLessenDamageAdditional = self.finalLessenDamageAdditional + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_INITIAL_SP_INCREASE) then
			self.initialSPIncrease = self.initialSPIncrease + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_INITIAL_HEAD) then
			self.leader = self.leader + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_INITIAL_BODY) then
			self.strength = self.strength + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_INITIAL_WISDOM) then
			self.wisdom = self.wisdom + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_PHYSIC_ATTACK_ADDITIONAL) then
			self.physicalAttackAdd = self.physicalAttackAdd + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_SKILL_ATTACK_ADDITIONAL) then
			self.skillAttackAdd = self.skillAttackAdd + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_CURE_ADDITIONAL) then
			self.cureAdd = self.cureAdd + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_BY_CURE_ADDITIONAL) then
			self.byCureAdd = self.byCureAdd + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_FIRING_ADDITIONAL) then
			self.firingAdd = self.firingAdd + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_POSION_ADDITIONAL) then
			self.posionAdd = self.posionAdd + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_FIRING_LESSEN) then
			self.byFiringLes = self.byFiringLes + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_POSION_LESSEN) then
			self.byPosionLes = self.byPosionLes + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_FINAL_ADDITIONAL_DAMAGE_PERCENT) then
			if(propertyValue < 1)then
				propertyValue = propertyValue * 100;
			end
			self.finalDamageAdditionalPercent = self.finalDamageAdditionalPercent + propertyValue;
		elseif(tonumber(propertyType) == EquipmentMould.PROPERTY_TYPE_FINAL_LESSEN_DAMAGE_PERCENT) then
			if(propertyValue < 1)then
				propertyValue = propertyValue * 100;
			end
			-- 战斗时，最终减伤可能会累加超过100,现象是无敌，这里修改为取所有减伤属性里的最大减伤属性
			if propertyValue > self.finalLessenDamageAdditionalPercent then
				self.finalLessenDamageAdditionalPercent = propertyValue;
			end
		end
	end
end


-- 
--  * 计算装备影响船只能力
--  * @param userInfo
--  * @param formation
--  * @param resultBuffer
-- 
function Ship:calculateShipPropertyByEquipment()
 	local equipSuitMap = {}
 	for i,v in pairs(self.equipments) do
 		if(v.user_equiment_id ~= nil and tonumber(v.user_equiment_id) > 0) then
 			local equipment = _ED.user_equiment[v.user_equiment_id]
	 		local equipmentMould = dms.element(dms["equipment_mould"],equipment.user_equiment_template)
	 		local suit_id = dms.atoi(equipmentMould,equipment_mould.suit_id)
	 		local suitMap = equipSuitMap[suit_id]
	 		if(suitMap ~= nil) then
	 			equipSuitMap[suit_id] = {suitId = suit_id,suitCount = suitMap.suitCount+1}
	 		else
	 			equipSuitMap[suit_id] = {suitId = suit_id,suitCount = 1}	
	 		end

			if(equipment.user_equiment_ability ~= "" and equipment.user_equiment_ability ~= "-1")then
				self:addPropertyByInfluenceValue(equipment.user_equiment_ability);
				local getLevel20UnlockValue = dms.atos(equipmentMould, equipment_mould.level_20_unlock_value)
				local getLevel40UnlockValue = dms.atos(equipmentMould, equipment_mould.level_40_unlock_value)
				local equipmentType = dms.atoi(equipmentMould, equipment_mould.equipment_type)

				if(tonumber(equipment.user_equiment_grade) >= 20 and getLevel20UnlockValue ~= "-1") then
					self:addPropertyByInfluenceValue(getLevel20UnlockValue);
				end
				
				if(tonumber(equipment.user_equiment_grade) >= 40 and getLevel40UnlockValue ~= "-1") then
					self:addPropertyByInfluenceValue(getLevel40UnlockValue);
				end
				if equipment.equiment_refine_param ~= "-1" and equipmentType ~= EquipmentMould.EQUIPMENT_TYPE_FASHION
						and equipmentType ~= EquipmentMould.EQUIPMENT_TYPE_HYALINE_FASHION then
					self:addPropertyByInfluenceValue(equipment.equiment_refine_param);
				end
				-- //洗练属性
				if(tonumber(equipment.refining_value_life) > 0) then
					self.power = self.power + equipment.refining_value_life;
				end
				if(tonumber(equipment.refining_value_attack) > 0)then
					self.courage = self.courage + equipment.refining_value_attack;
				end
				if(tonumber(equipment.refining_value_physical_defence) > 0) then
					self.intellect = self.intellect + equipment.refining_value_physical_defence
				end
				if(tonumber(equipment.refining_value_skill_defence) > 0) then
					self.nimable = self.nimable + equipment.refining_value_skill_defence
				end
				if(tonumber(equipment.refining_value_final_damange) > 0)then
					self.finalDamageAdditional = self.finalDamageAdditional + equipment.refining_value_final_damange
				end
				if(tonumber(equipment.refining_value_final_lessen_damange) > 0)then
					self.finalLessenDamageAdditional = self.finalLessenDamageAdditional + equipment.refining_value_final_lessen_damange
				end
			end
			if v.add_attribute ~= nil and v.add_attribute ~= "" then 
				--有升星属性
				self:calculateShipPropertyByEquipmentUpStar(v.add_attribute)
			end
 		end
 	end
	-- _crint("self.power20 ", self.power)
	-- //计算套装加成
	for i,v in pairs(equipSuitMap) do
		local suitId = v.suitId
		local activateCount = tonumber(v.suitCount)
		if(activateCount >= 2)then
			local suitParam = dms.element(dms["suit_param"],suitId);
			local suitValue = dms.atos(suitParam, suit_param.activate_property1)
			if(suitValue ~= nil and suitValue ~= "-1") then
				self:addPropertyByInfluenceValue(suitValue);
			end
			if(activateCount >= 3) then
				suitValue = nil
				suitValue =  dms.atos(suitParam, suit_param.activate_property2)
				if(suitValue ~= nil and suitValue ~= "-1") then
					self:addPropertyByInfluenceValue(suitValue);
				end
				if(activateCount >= 4) then
					suitValue = nil
					suitValue =  dms.atos(suitParam, suit_param.activate_property3)
					if(suitValue ~= nil and suitValue ~= "-1") then
						self:addPropertyByInfluenceValue(suitValue);
					end
				end
			end
		end
	end
	-- _crint("self.power21 ", self.power)
	-- //计算强化大师
	self:calculateShipPropertyByStrengthenMaster();
	-- _crint("self.power22 ", self.power)
end

-- /**
--  * 计算强化大师英雄船只能力
--  * @param weapon 武器
--  * @param helmet 头盔
--  * @param belt 腰带
--  * @param armor 盔甲
--  * @param attackTreasue 攻击宝物
--  * @param defenceTreasure 防御宝物
--  */
function Ship:calculateShipPropertyByStrengthenMaster()
--计算强化大师属性加成
	local weapon = self.frontCannon
	local helmet = self.middleCannon
	local belt = self.lastCannon
	local armor = self.lastCannon
	local attackTreasue = self.middleSail
	local defenceTreasure = self.lastSail
	
	if(tonumber(weapon) ~= 0 and tonumber(helmet.user_equiment_id) ~= 0 and tonumber(belt.user_equiment_id) ~= 0 and tonumber(armor.user_equiment_id) ~= 0
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
		-- 这里也尴尬了，装备等级大师级别间隔是10
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
		-- 这里也尴尬了，装备精炼大师级别间隔是2
		lessLevel = minEquipmentLevel%2
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

	-- _crint("self.power30 ", self.power)
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
		-- 这里也尴尬了，宝物等级大师级别间隔是5
		local lessLevel = minEquipmentLevel%5
		minEquipmentLevel = minEquipmentLevel - lessLevel
		-- 宝物等级
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
				-- _crint("strengthenMasterInfo = "..additionalProperty)
				self:addPropertyByInfluenceValue(additionalProperty)
			end
		end
		-- _crint("self.power31 ", self.power)
		-- 宝物精炼
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
		-- 这里也尴尬了，宝物精炼大师级别间隔是1
		-- lessLevel = minEquipmentLevel%1
		--minEquipmentLevel = minEquipmentLevel - lessLevel
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
	-- _crint("self.power32 ", self.power)
end


-- /**
--  * 计算天赋影响船只能力
--  * @param userInfo
--  * @param formation
--  */
function Ship:calculateShipPropertyByTalent(talents)
	for i,v in pairs(self.talentState) do
		if(tonumber(v.is_activited) == 1)then
			local talentMould = dms.element(dms["talent_mould"],v.talent_id)
			local baseAdditional = dms.atos(talentMould, talent_mould.base_additional)
			if(baseAdditional ~= "" and baseAdditional ~= "-1") then
				self:addPropertyByInfluenceValue(baseAdditional)
			end
			local influencePriorType = dms.atos(talentMould, talent_mould.influence_prior_type)
			local influencePriorValue = dms.atos(talentMould, talent_mould.influence_prior_value)
			if(influencePriorType ~=nil and  influencePriorValue ~= "" and influencePriorValue ~= "-1")then
				table.insert(talents,talentMould)
			end

		end
	end
	-- //计算所有上阵武将天赋光环影响自身属性加成
	-- Formation formation = Transformers.formationDAOProxy().findByUserAndShip(this.userInfo, this.getId());
	-- for (int i = 1; i <= 6 && formation != null; i++) {
	-- 	Integer shipId = formation.getSeat((byte) i);
	-- 	if(null != shipId && 0 != shipId.intValue()){
	-- 		Ship ship = null;
	-- 		if(shipId.intValue() != this.getId().intValue()){
	-- 			ship = (Ship) Transformers.shipDAOProxy().load(shipId);
	-- 		}else{
	-- 			ship = this;
	-- 		}
	-- 		calculateTalentAuraProperty(ship, shipMould);
	-- 	}
	-- }
end


	
-- /**
--  * 增加天赋光环属性
--  * @param ship
--  * @return
--  */
function Ship:calculateTalentAuraProperty(talents)
	-- debug.print_r(self.shipMould)
	for i,v in pairs(talents) do
		local influencePriorType = dms.atos(v, talent_mould.influence_prior_type)
		local influencePriorValue = dms.atos(v, talent_mould.influence_prior_value)
		local heroGender = dms.atoi(self.shipMould,ship_mould.hero_gender)
		local campPreference = dms.atoi(self.shipMould,ship_mould.camp_preference)
		local isActivate = false
		if(tonumber(influencePriorType) ==  0) then
			isActivate = heroGender == 1
		elseif(tonumber(influencePriorType) ==  1) then
			isActivate = heroGender == 2
		elseif(tonumber(influencePriorType) ==  2) then
			isActivate = campPreference == 1
		elseif(tonumber(influencePriorType) ==  3) then
			isActivate = campPreference == 2
		elseif(tonumber(influencePriorType) ==  4) then
			isActivate = campPreference == 3
		elseif(tonumber(influencePriorType) ==  5) then
			isActivate = campPreference == 4
		elseif(tonumber(influencePriorType) ==  22) then
			isActivate = true
		end
		if(isActivate)then
			if(influencePriorType ~=nil and  influencePriorValue ~= "" and influencePriorValue ~= "-1")then
				self:addPropertyByInfluenceValue(influencePriorValue)
			end
		end
	end

--	if tonumber(self.ship_id) == 15769 then
--		-- _crint("power "..self.power.." courage"..self.courage.." intellect"..self.intellect.." nimable"..self.nimable.." critical"..self.critical.." jink"..self.jink)
--	end

--	-- _crint("self.power6 ", self.power)
	self.power = self.power * (100 + self.powerAdditionalPercent) / 100.0
	self.courage = self.courage * (100 + self.courageAdditionalPercent) / 100.0
	self.intellect = self.intellect * (100 + self.intellectAdditionalPercent) / 100.0
	self.nimable = self.nimable * (100 + self.nimableAdditionalPercent) / 100.0

	self.critical = self.critical + self.criticalAdditionalPercent
	self.jink = self.jink + self.evasionAdditionalPercent;
end


-- /**
--  * 计算名将等级影响船只能力
--  * @param shipMould
--  */
function Ship:calculateShipPropertyByLegend()
	-- UserLegendInfo userLegendInfo = Transformers.userLegendInfoDAOProxy().findByUserInfoAndBaseMould(this.userInfo, shipMould.getBaseMould());
	-- if(null != userLegendInfo)then
	-- 	LegendMould legendMould = Transformers.legendMouldDAOProxy().findByBaseMould(shipMould.getBaseMould());
	-- 	if(null != legendMould)then
	-- 		int favorLevel = userLegendInfo.getFavorLevel();
	-- 		String influenceValue = legendMould.getProperty(favorLevel);
	-- 		if(!influenceValue.equals("") && !influenceValue.equals("-1")) then
	-- 			addPropertyByInfluenceValue(influenceValue);
	-- 		end
	-- 	end
		
	-- end
end


-- /**
--  * 计算名将觉醒增加属性
--  * @param shipMould
--  */
function Ship:calculateAddShipPropertyByAwaken()
	local requirement = dms.atoi(self.shipMould, ship_mould.base_mould2)
	local awaken_info = nil
	local talents = {}
	if requirement >= 1 then 
		--可以觉醒
		local grouds = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, requirement)
		
		if grouds ~= nil then 
	        for i, v in pairs(grouds) do
	        	local talentsId = tonumber(v[15])
	        	if talentsId ~= -1 then 
	        		table.insert(talents,talentsId)
	        	end
	            if tonumber(v[3]) == tonumber(self.awakenLevel) then
	               awaken_info = v
	               break
	            end
	        end
    	end
    end
    if awaken_info ~= nil then 
    	--有觉醒数据
    	local propStates =  zstring.split("" ..self.awakenstates , ",")
    	for i=1,4 do
    		local propId = zstring.tonumber(awaken_info[i+4])
    		local awakenPropId = dms.int(dms["prop_mould"],propId,prop_mould.use_of_ship)
    		if propId ~= -1 and awakenPropId > 0 and zstring.tonumber(propStates[i]) > 0 then 
    			local equipProperty = dms.string(dms["awaken_equipment_mould"],awakenPropId,awaken_equipment_mould.add_attributes1)
				self:addPropertyByInfluenceValue(equipProperty)
    		end
    	end
    	--觉醒等级加层
    	local awakenLevelAdd = dms.atos(awaken_info,awaken_requirement.add_attribution)
    	if awakenLevelAdd ~= "-1" then
    		self:addPropertyByInfluenceValue(awakenLevelAdd)
    	end
    	--觉醒天赋加层
    	for k,v in pairs(talents) do
    		local talentsAdd = dms.string(dms["awaken_talent_mould"],v,awaken_talent_mould.add_attribution)
    		if talentsAdd ~= nil then 
				self:addPropertyByInfluenceValue(talentsAdd)
    		end
    	end
    end
end



-- /**
--  * 增加霸气影响船只能力
--  */
function Ship:calculateAddShipPropertyByPower()
	-- if(self.powerEquip ~= "") then
	-- 	local powerIds = self.powerEquip.split(",")
	-- 	for i,v in pairs(powerIds) do
	-- 		if(v ~= "") then
	-- 			if(tonumber(v) > 0) then
	-- 				local powerMould =  dms.element(dms["power_mould"],v)
	-- 				local powerLv = dms.atoi(powerMould,power_mould.level)
	-- 				local baseProperty =  dms.atos(powerMould,power_mould.base_property)
	-- 				local growProperty =  dms.atos(powerMould,power_mould.grow_property)
	-- 				-- self:addPropertyByPowerProperty(baseProperty, growProperty, powerLv);
	-- 			end
	-- 		end
	-- 	end
	-- end
end



-- /**
--  * 计算战船生命成长值
--  * @param ship
--  * @return
--  */
function Ship:computePowerGrow(ship,shipMould)
	local growPower = dms.atoi(shipMould,ship_mould.grow_power)
	local powerGrowParam = dms.element(dms["ship_grow_param"],growPower)
	local gropParam = dms.atoi(powerGrowParam,ship_grow_param.grow_param)
	local initialPower = dms.atoi(shipMould,ship_mould.initial_power)
	-- _crint("计算战船生命",(initialPower + gropParam * (ship.level - 1)))
	return initialPower + gropParam * (ship.level - 1)
end

-- /**
--  * 计算战船攻击成长值
--  * @param ship
--  * @return
--  */
function Ship:computeCourageGrow(ship,shipMould)
	local growCourage =  dms.atoi(shipMould,ship_mould.grow_courage)
	local powerGrowParam = dms.element(dms["ship_grow_param"],growCourage)
	local gropParam = dms.atoi(powerGrowParam,ship_grow_param.grow_param)
	local initialCourage = dms.atoi(shipMould,ship_mould.initial_courage)
	-- _crint("计算战船攻击",(initialCourage + gropParam * (ship.level - 1)))
	return initialCourage + gropParam * (ship.level - 1)
end


-- /**
--  * 计算战船物防成长值
--  * @param ship
--  * @return
--  */
function Ship:computeIntellectGrow(ship,shipMould)
	local growIntellect =  dms.atoi(shipMould,ship_mould.grow_intellect)
	local powerGrowParam = dms.element(dms["ship_grow_param"],growIntellect)
	local gropParam = dms.atoi(powerGrowParam,ship_grow_param.grow_param)
	local initIalIntellect = dms.atoi(shipMould,ship_mould.initial_intellect)
	-- _crint("计算战船物防",(initIalIntellect + gropParam * (ship.level - 1)))
	return initIalIntellect + gropParam * (ship.level - 1)
end



-- /**
--  * 计算战船法防成长值
--  * @param ship
--  * @return
--  */
function Ship:computeNimableGrow(ship,shipMould)
	local growNimable =  dms.atoi(shipMould,ship_mould.grow_nimable)
	local powerGrowParam = dms.element(dms["ship_grow_param"],growNimable)
	local gropParam = dms.atoi(powerGrowParam,ship_grow_param.grow_param)
	local initNimable = dms.atoi(shipMould,ship_mould.initial_nimable)
	-- _crint("计算战船法防",(initNimable + gropParam * (ship.level - 1)))
	return initNimable + gropParam * (ship.level - 1)
end

-- /**
--  * 计算战船装备升星属性
--  * @param ship
--  * @return
--  */
function Ship:calculateShipPropertyByEquipmentUpStar(influenceValue)
	local propertyTypeArray = zstring.split(influenceValue,",")
	local propertyType = zstring.tonumber(propertyTypeArray[1])
	local propertyValue = zstring.tonumber(propertyTypeArray[2])
	if(propertyType == EquipmentMould.PROPERTY_TYPE_LIFE_ADDITIONAL)then
		self.power = self.power + propertyValue
	elseif(propertyType == EquipmentMould.PROPERTY_TYPE_ATTACK_ADDITIONAL) then
		self.courage = self.courage + propertyValue
	elseif(propertyType == EquipmentMould.PROPERTY_TYPE_PHYSIC_DEFENCE_ADDITIONAL) then
		self.intellect = self.intellect + propertyValue; 
	elseif(propertyType == EquipmentMould.PROPERTY_TYPE_SKILL_DEFENCE_ADDITIONAL) then
		self.nimable = self.nimable + propertyValue 
	end
end
