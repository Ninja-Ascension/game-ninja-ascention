-- 战斗技能
-- @author xiaofeng
BattleSkill = class("BattleSkill")
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_DAMAGEHP =  0
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADDHP =  1
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADDSP =  2
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_DAMAGESP =  3
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_NOSP =  4
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_DIZZY =  5
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_POISON =  6
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_PARALYSIS =  7
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_DISSP =  8
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_FIRING =  9
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_EXPLODE =  10
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADDRETAIN =  11
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADDDEFENCE =  12
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_BEAR_HP =  15
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_BLIND =  16
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_CRIPPLE =  17
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADD_ATTACK =  21
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_SUB_ATTACK =  22
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADD_DEFENSE =  23
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_SUB_DEFENSE =  24
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_ADD_DAMAGE =  25
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_ADD_BURISE =  26
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_ADD_CRITICAL =  27
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_SUB_CRITICAL =  28
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFLUENCE_ADD_HIT =  29
-- 战斗技能
-- @author xiaofeng
BattleSkill.SILL_INFLUENCE_ADD_DODGE =  30
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFUENCE_ENDURANCE =  31
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFUENCE_CLEAR_BUFF =  32
-- 战斗技能
-- @author xiaofeng
BattleSkill.SKILL_INFUENCE_ADD_FINNAL_DAMAGE =  33

function BattleSkill:ctor()
    --出手方标识(0:我方 1:敌方)
    self.attackerTag =  0

    --出手方坐标
    self.attacterCoordinate =  0

    --作用数量
    self.effectAmount =  0

    --技能模板id
    self.skillMould =  nil

    --技能效用
    self.skillInfluence =  nil

    --承受方标识
    self.byAttackerTag =  0

    --承受方位置
    self.byAttackerCoordinate =  0

    --影响类型
    self.effectType =  0

    --影响值
    self.effectValue =  0

    --是否显示
    self.isDisplay =  1

    --影响回合
    self.effectRound =  0

    --承受状态(0:命中 1:闪避 2:暴击 3:格挡 4:暴击加格挡)
    self.bearState =  0

    --掉落卡牌数量
    self.dropCardNo =  0

    --掉落道具数量
    self.dropPropNo =  0

    --掉落装备数量
    self.dropEquipmentNo =  0

    --掉落类型 0道具 1武将 2装备
    self.dropType =  0

    --生存状态(0:存活 1:死亡 2:反击)
    self.aliveState =  0

    --清除的BUFF类型
    self.clearBuffState =  0

    --相克状态
    self.restrain =  0

    --计算战船死亡掉落
    --@param userInfo
    --@param byAttackObject
    --如果是攻击技能则计算闪避、暴击和挡格
    --击杀恢复生命
    --效用n模板ID
    --如果是攻击技能则计算闪避、暴击和挡格
    --击杀恢复生命
    --效用n模板ID
    self.reattackObject =  nil

    self.formulaInfo = 0

	app.load("client.red_alert.battle.report.FightUtil")
	app.load("client.red_alert.battle.report.RestrainUtil")    
end

function BattleSkill:processAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	--_crint ("endureDirection: " .. endureDirection[1] .. ", " ..endureDirection[2] .. ", " .. attackObject.coordinate)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	if(attackObject.isAction ~= true) then
		attackObject.isAction = true
		-- 初始化状态
		self:restoreStatus()
		self.effectAmount = self.effectAmount + 1
		self.byAttackerTag = attackObject.battleTag
		self.byAttackerCoordinate = attackObject.coordinate
		self.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
		self.isDisplay = 0
		if(attackObject.skillPoint >= 4 and true ~= attackObject.isDisSp) then
			self.effectType = BattleSkill.SKILL_INFLUENCE_DAMAGESP
			self.effectValue = 4
			attackObject:subSkillPoint(4)
			attackObject.totalSkillPoint = self.effectValue
		elseif(true ~= attackObject.isSpDisable) then
			self.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
			self.effectValue = 2
			attackObject:addSkillPoint( 2)
		end
		if attackObject.isNeedAddSkillPoint == false then
			attackObject:addZomSkillPoint(2)
		end
		--_crint ("Exit before write")
		self:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
	end
	local count=0
	
	--for (Byte byAttackCoordinate : byAttackCoordinates) {
	--_crint ("byAttackCoordinates are: ")
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		--_crint(byAttackCoordinate)
	end
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		count = count + 1
		self:restoreStatus()
		attackObject.isCritical=false
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
			--_crint ("Target attack obj nil")
		else
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			-- 技能种类
			self.effectType = self.skillInfluence.skillCategory
			if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
				attackObject:restoreAttackState()
				byAttackObject:restoreAttackState()
				
				local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject);
				
				if (restrainObj ~= nil) then
					self.restrain = 1
				else
					self.restrain = 0
				end
				----_crint ("has restrain: " .. self.restrain)
				--os.exit()

				-- 天赋判断
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)

				-- 计算格挡属性
				RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
				RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)

				-- 计算回避属性
				FightUtil.computeEvasion(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				if(byAttackObject.isEvasionSurely) then
					byAttackObject.isEvasion=true
					byAttackObject.isEvasionSurely=false
				end

				-- 如果没有回避继续往下走
				if(true ~= byAttackObject.isEvasion) then
					FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
					if(attackObject.isCritical) then
						self.bearState = 2
						----_crint ("self.bearState = 2")
						--os.exit()
					end
					-- 如果格挡
					if(byAttackObject.isRetain) then
						if(self.bearState == 2) then
							self.bearState = 4
						else	
							self.bearState = 3
						end
						if(byAttackObject.canReAttack) then						
							self.aliveState = 2
							-- for i = 1, table.maxn(byAttackObjects) do
							for i, v in pairs(byAttackObjects) do
								if(nil ~= byAttackObjects[i]) then
									byAttackObjects[i].canReAttack=false
								end
							end
						end
					end
				else
					self.bearState = 1
				end
			
			else
				self.bearState = 0
			end


			local effectArray = nil
			-- 如果是清除BUFF效用
			if(self.skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				--_crint ("effectArray is clear buff")
				effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			else
				--_crint ("effectArray is computeSkillEffect")

				-- 传递self的类型 调用对应的computeSkillEffect 函数
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
					self.isDisplay = 0
				end
				
				if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_ADD_KILL) then
					self.bearState = 0
				end
			end

			attackObject.totalSkillPoint = 0
			-- 效用数值
			self.effectValue = effectArray[1]
			-- 效用回合数
			self.effectRound =  effectArray[2]
			-- buff清除标示
			self.clearBuffState = effectArray[4]


			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				-- byAttackObject.isDead=true
				-- byAttackObjects[byAttackCoordinate] = nil

				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1

				--self:dropReward(fightModule, byAttackObject)
				
			else
				if(self.aliveState == 2) then
					if(attackObject.healthPoint < 1) then
						if(attackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount - 1
							-- fightModule.attackObjects[attackObject.coordinate] = nil
						else
							fightModule.byAttackCount = fightModule.byAttackCount - 1
							-- fightModule.byAttackObjects[attackObject.coordinate] = nil
						end
						-- attackObject.isDead=true
						self.aliveState = 0
					else
						self.reattackObject = attackObject
					end
					local talentJudgeResultList = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
					if(#talentJudgeResultList > 0) then
						self.aliveState = 0
						self.reattackObject = nil
					end
				end
			end

			-- 承受状态
			if(effectArray[3] > 0)then
				self.bearState =  effectArray[3]
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
			-- 计算伤害数值
			attackObject:addTotalEffectDamage(self.effectValue)
			if(self:checkSkillAndTalent(attackObject) and count < #byAttackCoordinates)then
				--continue
			else
				if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
					TalentSkill.processAttack(userInfo, self, fightModule, attackObject, byAttackObject)
					TalentSkill.processByAttack(userInfo, self, fightModule, attackObject, byAttackObject)
					TalentSkill.processUniteAttack(userInfo, self, fightModule, attackObject, byAttackObject)
				end
				attackObject:clearTalentJudgeResultList()
				byAttackObject:clearTalentJudgeResultList()
				-- attackObject.isAction=false
			end
		end
	end  -- endfor
	if(self.effectAmount > 0) then
		fightModule.battleSkillCount = fightModule.battleSkillCount + 1
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end


function BattleSkill:processTalentAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, byAttackTalent, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	--for (Byte byAttackCoordinate : byAttackCoordinates) {	
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		-- restoreStatus()
		self:restoreStatus()
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
		else
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			if(effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
				attackObject:restoreAttackState()
				byAttackObject:restoreAttackState()
				local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject);
				if (nil == restrainObj) then
					self.restrain = 0
				else
					self.restrain = 1
				end
	
				RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
				RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
				FightUtil.computeEvasion(self.skillMould, skillInfluence, attackObject, byAttackObject)
				if(byAttackObject.isEvasionSurely) then
					byAttackObject.isEvasion=true
					byAttackObject.isEvasionSurely=false
				end
				if(true ~= byAttackObject.isEvasion) then
					FightUtil.computeCritial(self.skillMould, skillInfluence, attackObject, byAttackObject)
					if(attackObject.isCritical) then
						self.bearState = 2
					end
					if(byAttackObject.isRetain) then
						if(self.bearState == 2) then
							self.bearState = 4
						else							
							self.bearState = 3
						end
					end
				else
					self.bearState = 1
				end
			else
				self.bearState = 0
			end
			local effectArray = nil
			if(skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, skillInfluence, attackObject, byAttackObject)
				if(skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
			end
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				byAttackObject.isDead=true
				byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			else
				if(self.aliveState == 2) then
					if(attackObject.healthPoint < 1) then
						if(attackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount - 1
							-- fightModule.attackObjects[attackObject.coordinate] = nil
						else
							----_crint ("处理 天赋反击死亡	byAttackCount--	")
							fightModule.byAttackCount = fightModule.byAttackCount - 1
							-- fightModule.byAttackObjects[attackObject.coordinate] = nil
						end
						-- attackObject.isDead=true
						self.aliveState = 0
					else
						self.reattackObject = attackObject
					end
					local talentJudgeResultList = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
					if(#talentJudgeResultList > 0) then
						self.aliveState = 0
						self.reattackObject = nil
					end
				end
			end
			if(effectArray[2] > 0) then
				self.bearState =  effectArray[3]
			end
			if(self.effectRound > 1 and byAttackTalent) then
				self.effectRound = self.effectRound - 1
			end
			-- 写数据
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
			attackObject:clearTalentJudgeResultList()
			byAttackObject:clearTalentJudgeResultList()
		end
	end   --endfor

	-- 拼接技能数据
	if(self.effectAmount > 0) then
		fightModule.battleSkillCount = fightModule.battleSkillCount + 1
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end

function BattleSkill:processTalentUniteAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, byAttackTalent, resultBuffer, effectCount)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	--for (Byte byAttackCoordinate : byAttackCoordinates) {	
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		self:restoreStatus()
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
		else
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
			TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
				attackObject:restoreAttackState()
				byAttackObject:restoreAttackState()
				local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject)
				if (restrainObj == nil) then
					self.restrain = 0
				else
					self.restrain = 1
				end
				--restrain =  (RestrainUtil.calculateHasRestrain(attackObject, byAttackObject) == nil ? 0:1)
				RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
				RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
				FightUtil.computeEvasion(self.skillMould, skillInfluence, attackObject, byAttackObject)
				if(byAttackObject.isEvasionSurely) then
					byAttackObject.isEvasion=true
					byAttackObject.isEvasionSurely=false
				end
				if(true ~= byAttackObject.isEvasion) then
					FightUtil.computeCritial(self.skillMould, skillInfluence, attackObject, byAttackObject)
					if(attackObject.isCritical) then
						self.bearState = 2
					end
					if(byAttackObject.isRetain) then
						if(self.bearState == 2)then
							self.bearState = 4
						else							
							self.bearState = 3
						end
					end
				else
					self.bearState = 1
				end
			else
				self.bearState = 0
			end
			local effectArray = nil
			if(skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, skillInfluence, attackObject, byAttackObject)
				if(skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
					 and effectArray[3] == 1) then
					self.isDisplay = 0
				end
			end
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				-- byAttackObject.isDead=true
				-- byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			else
				if(self.aliveState == 2) then
					if(attackObject.healthPoint < 1) then
						if(attackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount - 1
							-- fightModule.attackObjects[attackObject.coordinate] = nil
						else
							----_crint ("处理 天赋反击死亡	byAttackCount--	")
							fightModule.byAttackCount = fightModule.byAttackCount - 1
							-- fightModule.byAttackObjects[attackObject.coordinate] = nil
						end
						-- attackObject.isDead=true
						self.aliveState = 0
					else
						self.reattackObject = attackObject
					end
					local talentJudgeResultList = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
					if( #talentJudgeResultList > 0) then
						self.aliveState = 0
						self.reattackObject = nil
					end
				end
			end
			if(effectArray[3] > 0) then
				self.bearState =  effectArray[3]
			end
			if(self.effectRound > 1 and byAttackTalent) then
				self.effectRound = self.effectRound - 1
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
			attackObject:clearTalentJudgeResultList()
			byAttackObject:clearTalentJudgeResultList()
		end
	end  -- endfor
	if(self.effectAmount > 0) then
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end

function BattleSkill:restoreStatus()
	self.byAttackerTag = 0
	self.byAttackerCoordinate = 0
	self.effectType = 0
	self.effectValue = 0
	self.isDisplay = 1
	self.effectRound = 0
	self.bearState = 0
	self.aliveState = 0
	self.dropCardNo = 0
	self.dropPropNo = 0
	self.dropEquipmentNo = 0
	self.dropType = 0
	self.reattackObject = nil
	self.clearBuffState = 0
	self.restrain = 0
end

function BattleSkill:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, resultBuffer)
	table.insert(resultBuffer, self.byAttackerTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.byAttackerCoordinate)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.restrain)
	table.insert(resultBuffer, IniUtil.compart)
	if tonumber(self.effectType) == 35 or tonumber(self.effectType) == 36 then
		self.effectType = 0
	end
	table.insert(resultBuffer, self.effectType)
	table.insert(resultBuffer, IniUtil.compart)
	if(self.clearBuffState > 0) then
		table.insert(resultBuffer, self.clearBuffState)
	else
		if(tonumber(self.effectType) ~= 0 
			and tonumber(self.effectType) ~= 1
			and tonumber(self.effectType) ~= 2
			and tonumber(self.effectType) ~= 3
			and tonumber(self.effectType) ~= 4 
			and tonumber(self.effectType) ~= 6 
			and tonumber(self.effectType) ~= 9
			and tonumber(self.effectType) ~= 31
			and tonumber(self.effectType) ~= 34
			and tonumber(self.effectType) ~= 35) then
			table.insert(resultBuffer, 0)
		else
			table.insert(resultBuffer, self.effectValue)
		end
	end
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.isDisplay)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectRound)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.bearState)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.aliveState)
	table.insert(resultBuffer, IniUtil.compart)
	if(self.aliveState == 1) then
		table.insert(resultBuffer, self.dropType)
		table.insert(resultBuffer, IniUtil.compart)
		--switch (self.dropType) {
		if (self.dropType == 0) then
			table.insert(resultBuffer, self.dropPropNo)
			--break
		elseif (self.dropType == 1) then
			table.insert(resultBuffer, self.dropCardNo)
			--break
		elseif (self.dropType == 2) then
			table.insert(resultBuffer, self.dropEquipmentNo)
			--break
		else
			table.insert(resultBuffer, 0)
			--break
		end
		table.insert(resultBuffer, IniUtil.compart)
	end
	-- if(self.aliveState == 2 and nil ~= reattackObject) then
		-- fightModule.counterBuffer = {}
		-- counterAttack(userInfo, byAttackObject, attackObject, fightModule, fightModule.counterBuffer)
		-- self.reattackObject = nil
	-- end
	self:processReflectDamage(userInfo, self, fightModule, attackObject, byAttackObject)
end

function BattleSkill:writeTalentAttack(userInfo, attackObject, byAttackObject, fightModule, resultBuffer)
	table.insert(resultBuffer, self.byAttackerTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.byAttackerCoordinate)
	table.insert(resultBuffer, self.restrain)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectType)
	table.insert(resultBuffer, IniUtil.compart)
	if(self.clearBuffState > 0) then
		table.insert(resultBuffer, self.clearBuffState)
	else
		if(tonumber(self.effectType) ~= 0 
			and tonumber(self.effectType) ~= 1
			and tonumber(self.effectType) ~= 2
			and tonumber(self.effectType) ~= 3
			and tonumber(self.effectType) ~= 4 
			and tonumber(self.effectType) ~= 6 
			and tonumber(self.effectType) ~= 9
			and tonumber(self.effectType) ~= 31
			and tonumber(self.effectType) ~= 35) then
			table.insert(resultBuffer, 0)
		else
			table.insert(resultBuffer, self.effectValue)
		end
	end
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.isDisplay)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectRound)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.bearState)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.aliveState)
	table.insert(resultBuffer, IniUtil.compart)
	if(self.aliveState == 1) then
		table.insert(resultBuffer, self.dropType)
		table.insert(resultBuffer, IniUtil.compart)
		if (self.dropType == 0 ) then
			table.insert(resultBuffer, self.dropPropNo)
			--break
		elseif (self.dropType == 1) then
			table.insert(resultBuffer, self.dropCardNo)
			--break
		elseif (self.dropType == 2) then
			table.insert(resultBuffer, self.dropEquipmentNo)
			--break
		else
			table.insert(resultBuffer, 0)
			--break
		end
		table.insert(resultBuffer, IniUtil.compart)
	end
end

function BattleSkill:counterAttack(userInfo, attackObject, byAttackObject, fightModule, resultBuffer)
	local battleSkillList = attackObject.counterBattleSkill
	table.insert(resultBuffer, #battleSkillList)
	table.insert(resultBuffer, IniUtil.compart)
	local byAttackCoordinates = {}
	--for (local battleSkill : battleSkillList) {
	for _, battleSkill in pairs(battleSkillList) do
		table.insert(resultBuffer, battleSkill.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 1)
		table.insert(resultBuffer, IniUtil.compart)
		if (0 == attackObject.battleTag)  then
			if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
				byAttackCoordinates = FightUtil.computeEffectCoordinate(attackObject.coordinate, battleSkill.skillInfluence, attackObject, fightModule.attackObjects)
				battleSkill.processOwnCounterAttack(userInfo, byAttackCoordinates, attackObject, fightModule.attackObjects, fightModule, resultBuffer)
			else
				byAttackCoordinates = FightUtil.computeCounterCoordinate(byAttackObject.coordinate, battleSkill.skillInfluence, attackObject, fightModule.byAttackObjects)
				battleSkill.processCounterAttack(userInfo, byAttackCoordinates, attackObject, fightModule.byAttackObjects, fightModule, resultBuffer)
			end
		else
			if(battleSkill.skillInfluence.influenceGroup == SkillInfluence.EFFECT_GROUP_CURRENT) then
				byAttackCoordinates = FightUtil.computeEffectCoordinate(attackObject.coordinate, battleSkill.skillInfluence, attackObject, fightModule.byAttackObjects)
				battleSkill.processOwnCounterAttack(userInfo, byAttackCoordinates, attackObject, fightModule.byAttackObjects, fightModule, resultBuffer)
			else
				byAttackCoordinates = FightUtil.computeCounterCoordinate(byAttackObject.coordinate, battleSkill.skillInfluence, attackObject, fightModule.attackObjects)
				battleSkill.processCounterAttack(userInfo, byAttackCoordinates, attackObject, fightModule.attackObjects, fightModule, resultBuffer)
			end
		end
	end
end

function BattleSkill:processCounterAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, resultBuffer)
	self:restoreStatus()
	self.effectAmount =  #byAttackCoordinates
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	--for (Byte byAttackCoordinate : byAttackCoordinates) {
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject) then
			self.effectAmount = self.effectAmount - 1
			--continue
		else
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			FightUtil.computeCritial(self.skillMould, skillInfluence, attackObject, byAttackObject)
			if(attackObject.isCritical) then
				self.bearState = 2
			end
			local effectArray = nil
			if(skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, skillInfluence, attackObject, byAttackObject)
				if(skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
			end
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					----_crint ("处理反击死亡	byAttackCount--	")
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				-- byAttackObject.isDead=true
				-- byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
		end
	end  --endfor
	table.insert(resultBuffer, attackObject.battleTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, attackObject.coordinate)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectAmount)
	table.insert(resultBuffer, IniUtil.compart)
	IniUtil.concatTable(resultBuffer, effectBuffer)
end

function BattleSkill:processReflectDamage(userInfo, battleSkill, fightModule, attackObject, byAttackObject)
	if(attackObject.isDead) then
		return
	end
	if(battleSkill.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
		--for (Iterator<TalentJudgeResult> talentIter = byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_REFLECT).iterator(); talentIter.hasNext();) {
		for _, talentJudgeResult in pairs(byAttackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_REFLECT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			local immunity = false
			--for (TalentImmunity talentImmunity : attackObject.talentImmunityList) {
			for _, talentImmunity in pairs(attackObject.talentImmunityList) do
				if(talentImmunity.immunityTalent == talentJudgeResult.talentMould.id) then
					immunity = true
					break
				end
			end
			if(immunity) then
				break
			end
			local reflectDamage = math.floor( battleSkill.effectValue * talentJudgeResult.percentValue / 100)
			local _battleSkill =  BattleSkill:new()
			_battleSkill.byAttackerTag=attackObject.battleTag
			_battleSkill.byAttackerCoordinate=attackObject.coordinate
			_battleSkill.effectValue=reflectDamage
			attackObject.subHealthPoint(reflectDamage)
			if(attackObject.healthPoint < 1) then
				_battleSkill.aliveState= 1
				attackObject.isDead=true
				if(attackObject.battleTag == 0) then
					-- fightModule.attackObjects[attackObject.coordinate] = nil
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
					--self:dropReward(fightModule, byAttackObject)
					-- fightModule.byAttackObjects[attackObject.coordinate] = nil
				end
				TalentSkill.processTargetDead(userInfo, fightModule, byAttackObject, attackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, byAttackObject, attackObject)
			end
			fightModule.battleSkillCount = fightModule.battleSkillCount + 1
			table.insert(fightModule.battleSkillBuffer, talentJudgeResult.talentMould.influenceEffectId)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, 1)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, byAttackObject.battleTag)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, byAttackObject.coordinate)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, 1)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, -1)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			table.insert(fightModule.battleSkillBuffer, -1)
			table.insert(fightModule.battleSkillBuffer, IniUtil.compart)
			--talentIter.remove()
			_battleSkill:writeTalentAttack(userInfo, attackObject, byAttackObject, fightModule, fightModule.battleSkillBuffer)
		end
	end
end

function BattleSkill:processHpRemainDamage(userInfo, battleSkill, fightModule, attackObject)
	if(attackObject.isDead) then
		return
	end
	if(battleSkill.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
		--for (Iterator<TalentJudgeResult> talentIter = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_DAMAGE_HP_PERCENT).iterator(); talentIter.hasNext();) {
		for _, talentJudgeResult in pairs(attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_DAMAGE_HP_PERCENT)) do
			--TalentJudgeResult talentJudgeResult = talentIter.next()
			fightModule.battleSkillCount = fightModule.battleSkillCount + 1
			fightModule.battleSkillBuffer.append(talentJudgeResult.talentMould.influenceEffectId)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(1)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(attackObject.battleTag)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(attackObject.coordinate)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			local byEffectCoordinateList = {}
			local itObjects = fightModule.byAttackObjects
			if (attackObject.battleTag ~= 0) then
				itObjects = fightModule.attackObjects
			end
			--for (local _byAttackObject : attackObject.battleTag == 0 ? fightModule.byAttackObjects : fightModule.attackObjects) {
			for _, _byAttackObject in pairs(itObjects) do
				if(true ~= _byAttackObject and true ~= _byAttackObject.isDead) then
					table.insert(byEffectCoordinateList, _byAttackObject.coordinate)
				end
			end
			fightModule.battleSkillBuffer.append(#byEffectCoordinateList)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(-1)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			fightModule.battleSkillBuffer.append(-1)
			fightModule.battleSkillBuffer.append(IniUtil.compart)
			--for (int i = 0; i < byEffectCoordinateList.size(); i++) {
			-- for i = 1, table.maxn(byEffectCoordinateList) do
			for i, v in pairs(byEffectCoordinateList) do
				--local _byAttackObject = attackObject.battleTag == 0 ? fightModule.byAttackObjects[byEffectCoordinateList.get(i) - 1] : fightModule.attackObjects[byEffectCoordinateList.get(i) - 1]
				local _byAttackObject = fightModule.byAttackObjects[byEffectCoordinateList.get(i)]
				if (attackObject.battleTag ~= 0) then
					_byAttackObject = fightModule.attackObjects[byEffectCoordinateList.get(i)]
				end
				local damage =  (_byAttackObject.healthPoint * talentJudgeResult.percentValue / 100)
				local _battleSkill =  BattleSkill:new()
				_battleSkill.byAttackerTag=_byAttackObject.battleTag
				_battleSkill.byAttackerCoordinate=_byAttackObject.coordinate
				_battleSkill.effectValue=damage
				_byAttackObject.subHealthPoint(damage)
				if(_byAttackObject.healthPoint < 1) then
					_battleSkill.aliveState= 1
					_byAttackObject.isDead=true
					if(_byAttackObject.battleTag == 0) then
						-- fightModule.attackObjects[_byAttackObject.coordinate - 1] = nil
						fightModule.attackCount = fightModule.attackCount - 1
					else
						fightModule.byAttackCount = fightModule.byAttackCount - 1
						--self:dropReward(fightModule, byAttackObject)
						-- fightModule.byAttackObjects[_byAttackObject.coordinate - 1] = nil
					end
					TalentSkill.processTargetDead(userInfo, fightModule, attackObject, _byAttackObject)
					TalentSkill.processSelfDead(userInfo, fightModule, attackObject, _byAttackObject)
				end
				_battleSkill:writeTalentAttack(userInfo, attackObject, _byAttackObject, fightModule, fightModule.battleSkillBuffer)
			end
			--talentIter.remove()  --as of no use, just comment this line out
		end
	end
end

function BattleSkill:processHpCurePercent(userInfo, battleSkill, fightModule, attackObject)
	if(attackObject.isDead) then
		return
	end
	if(attackObject.isBearHP) then
		return
	end
	--for (Iterator<TalentJudgeResult> talentIter = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_CURE_HP_BY_HP_UPPER_LIMIT).iterator(); talentIter.hasNext();) {
	for _, talentJudgeResult in pairs(attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_CURE_HP_BY_HP_UPPER_LIMIT)) do
		--TalentJudgeResult talentJudgeResult = talentIter.next()
		fightModule.battleSkillCount = fightModule.battleSkillCount + 1
		fightModule.battleSkillBuffer.append(talentJudgeResult.talentMould.influenceEffectId)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(1)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(attackObject.battleTag)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(attackObject.coordinate)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(1)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(-1)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		fightModule.battleSkillBuffer.append(-1)
		fightModule.battleSkillBuffer.append(IniUtil.compart)
		local cureHp =  (attackObject.healthMaxPoint * talentJudgeResult.percentValue / 100)
		cureHp =  math.min(attackObject.healthMaxPoint - attackObject.healthPoint, cureHp)
		local _battleSkill =  BattleSkill:new()
		_battleSkill.byAttackerTag=attackObject.battleTag
		_battleSkill.byAttackerCoordinate=attackObject.coordinate
		_battleSkill.effectValue = cureHp
		attackObject:addHealthPoint(cureHp)
		_battleSkill.effectType = BattleSkill.SKILL_INFLUENCE_ADDHP
		_battleSkill:writeTalentAttack(userInfo, attackObject, attackObject, fightModule, fightModule.battleSkillBuffer)
	end
end

function BattleSkill:processOwnCounterAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	--for (Byte byAttackCoordinate : byAttackCoordinates) {	
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		self:restoreStatus()
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
		else
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			FightUtil.computeCritial(self.skillMould, skillInfluence, attackObject, byAttackObject)
			if(attackObject.isAction ~= true) then
				attackObject.isAction = true
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
			end
			local effectArray = nil
			if(skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, skillInfluence, attackObject, byAttackObject)
				if(skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
			end
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					----_crint ("处理 processOwnCounterAttack死亡	byAttackCount--	")
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				-- byAttackObject.isDead=true
				-- byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
		end
	end --endfor
	table.insert(resultBuffer, attackObject.battleTag)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, attackObject.coordinate)
	table.insert(resultBuffer, IniUtil.compart)
	table.insert(resultBuffer, self.effectAmount)
	table.insert(resultBuffer, IniUtil.compart)
	IniUtil.concatTable(resultBuffer, effectBuffer)
end

function BattleSkill:checkSkillAndTalent(attackObject)
	if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DRAINS or
			self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_CURE_HP) then
		return true
	end
	--for (Iterator<TalentMould> talentIter = attackObject.talentMouldList.iterator(); talentIter.hasNext();) {
	for _, talentMould in pairs(attackObject.talentMouldList) do
		--TalentMould talentMould = talentIter.next()
		local battleSkillList = talentMould.talentBattleSkill
		--for (int i = 0; i < battleSkillList.size(); i++) {
		for _, battleSkill in pairs(battleSkillList) do
			--local battleSkill = battleSkillList.get(i)
			if(battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DRAINS	
					or battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_CURE_HP	
					or battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_EVASION_SURELY
					or battleSkill.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_CURE_SP) then
				return true
			end
		end
	end
	return false
end

function BattleSkill:processFitAttack(userInfo, byAttackCoordinates, attackObject, byAttackObjects, fightModule, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	local count=0
	--for (Byte byAttackCoordinate : byAttackCoordinates) {
	for _, byAttackCoordinate in pairs(byAttackCoordinates) do
		count = count + 1
		self:restoreStatus()
		attackObject.isCritical=false
		self.aliveState = 0
		self.bearState = 0
		self.dropCardNo = 0
		self.isDisplay = 1
		local byAttackObject = byAttackObjects[byAttackCoordinate]
		if(nil == byAttackObject or byAttackObject.isDead) then
			--continue
		else
			-- if battleObject.isAction ~= true then
			-- 	-- battleObject.isAction = false
			-- end
			self.byAttackerTag = byAttackObject.battleTag
			self.byAttackerCoordinate = byAttackCoordinate
			self.effectType = self.skillInfluence.skillCategory
			if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
				attackObject:restoreAttackState()
				byAttackObject:restoreAttackState()
				local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject);
				if (restrainObj == nil)  then
					self.restrain = 0
				else
					self.restrain = 1
				end
				--restrain =  (RestrainUtil.calculateHasRestrain(attackObject, byAttackObject) == nil ? 0:1)
				RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
				RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
				TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
				FightUtil.computeEvasion(self.skillMould, skillInfluence, attackObject, byAttackObject)
				if(byAttackObject.isEvasionSurely) then
					byAttackObject.isEvasion=true
					byAttackObject.isEvasionSurely=false
				end
				if(true ~= byAttackObject.isEvasion) then
					FightUtil.computeCritial(self.skillMould, skillInfluence, attackObject, byAttackObject)
					if(attackObject.isCritical) then
						self.bearState = 2
					end
					if(byAttackObject.isRetain) then
						if(self.bearState == 2) then
							self.bearState = 4
						else							
							self.bearState = 3
						end
						if(byAttackObject.canReAttack) then
							self.aliveState = 2
							--for (int i = 0; i < byAttackObjects.length; i++) {
							for _, byObj in pairs(byAttackObjects) do
								if(nil ~= byObj) then
									byObj.canReAttack=false
								end
							end
						end
					end
				else
					self.bearState = 1
				end
			else
				self.bearState = 0
			end
			local effectArray = nil
			if(self.skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
				effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			else
				effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
				
				if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
						 and effectArray[3] == 1) then
						self.isDisplay = 0
				end
			end
			attackObject.totalSkillPoint=0
			self.effectValue = effectArray[1]
			self.effectRound =  effectArray[2]
			if(byAttackObject.healthPoint < 1) then
				if(byAttackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
				end
				-- byAttackObject.isDead=true
				-- byAttackObjects[byAttackCoordinate] = nil
				TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
				TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
				self:processHpCurePercent(userInfo, self, fightModule, attackObject)
				self.aliveState = 1
				--self:dropReward(fightModule, byAttackObject)
				
			else
				if(self.aliveState == 2) then
					if(attackObject.healthPoint < 1) then
						if(attackObject.battleTag == 0) then
							fightModule.attackCount = fightModule.attackCount - 1
							-- fightModule.attackObjects[attackObject.coordinate] = nil
						else
							----_crint ("处理攻反击死亡	byAttackCount--	" + attackObject.battleTag)
							fightModule.byAttackCount = fightModule.byAttackCount - 1
							-- fightModule.byAttackObjects[attackObject.coordinate] = nil
						end
						-- attackObject.isDead=true
						self.aliveState = 0
					else
						self.reattackObject = attackObject
					end
					local talentJudgeResultList = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
					if(#talentJudgeResultList > 0) then
						self.aliveState = 0
						self.reattackObject = nil
					end
				end
			end
			if(effectArray[2] > 0) then
				self.bearState =  effectArray[3]
			end
			self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
			self.effectAmount = self.effectAmount + 1
			attackObject:addTotalEffectDamage(self.effectValue)
			if(self:checkSkillAndTalent(attackObject) and count < #byAttackCoordinates) then
				--continue
			else
				if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
					TalentSkill.processAttack(userInfo, self, fightModule, attackObject, byAttackObject)
					TalentSkill.processByAttack(userInfo, self, fightModule, attackObject, byAttackObject)
					TalentSkill.processUniteAttack(userInfo, self, fightModule, attackObject, byAttackObject)
				end
				attackObject:clearTalentJudgeResultList()
				byAttackObject:clearTalentJudgeResultList()
				-- attackObject.isAction=false
			end
		end
	end
	if(self.effectAmount > 0)then
		fightModule.fitBattleSkillCount = fightModule.fitBattleSkillCount + 1
		if(fightModule.fitSelfBuffer ~=  nil) then
			self.effectAmount = self.effectAmount + 1
			-- table.insert(effectBuffer, fightModule.fitSelfBuffer)
			IniUtil.concatTable(effectBuffer, fightModule.fitSelfBuffer)
			fightModule.fitSelfBuffer = nil
		end
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end

-- /**
--  * 计算战船死亡掉落
--  * @param userInfo
--  * @param byAttackObject
--  */
function BattleSkill:dropReward(fightModule,byAttackObject)
	-- //计算道具掉落
	-- if(byAttackObject.rewardPropRatio ~= nil and byAttackObject.rewardPropRatio > 0) then
	-- 	if(math.random(1, 100) <= byAttackObject.rewardPropRatio) then
	-- 		local rewardProp =  fightModule.rewardProp[byAttackObject.rewardProp]
	-- 		if(rewardProp ~= nil) then
	-- 			fightModule.rewardProp[byAttackObject.rewardProp] = {byAttackObject.rewardProp,rewardProp + 1}
	-- 		else
	-- 			fightModule.rewardProp[byAttackObject.rewardProp] = {byAttackObject.rewardProp,1}
	-- 		end
	-- 		self.dropCardNo = 1;
	-- 		self.dropType = 1;
	-- 	end
	-- end
	-- -- //计算装备掉落
	-- if(byAttackObject.rewardEquipmentRatio ~= nil and byAttackObject.rewardEquipmentRatio > 0) then
	-- 	if(math.random(1, 100) <= byAttackObject.rewardEquipment) then
	-- 		local rewardEquipment =  fightModule.rewardEquipment[byAttackObject.rewardEquipment]
	-- 		if(rewardEquipment ~= nil) then
	-- 			fightModule.rewardEquipment[byAttackObject.rewardEquipment] = {byAttackObject.rewardEquipment,rewardEquipment + 1}
	-- 		else
	-- 			fightModule.rewardEquipment[byAttackObject.rewardEquipment] = {byAttackObject.rewardEquipment,1}
	-- 		end
	-- 		self.dropCardNo = 1;
	-- 		self.dropType = 1;
	-- 	end
	-- end

	-- -- //计算卡片掉落
	-- if(byAttackObject.rewardRatio ~= nil and byAttackObject.rewardRatio > 0) then
	-- 	if(math.random(1, 100) <= byAttackObject.rewardCard) then
	-- 		local rewardInfo = {
	-- 			card = byAttackObject.rewardCard,
	-- 			count = 1
	-- 		}
	-- 		local rewardCard =  fightModule.rewardCard[byAttackObject.rewardCard]
	-- 		if(rewardCard ~= nil) then
	-- 			rewardInfo.count = rewardCard.count+1
	-- 			fightModule.rewardCard[byAttackObject.rewardCard] = rewardInfo
	-- 		else
	-- 			fightModule.rewardCard[byAttackObject.rewardCard] = rewardInfo
	-- 		end
	-- 		self.dropCardNo = 1;
	-- 		self.dropType = 1;
	-- 	end
	-- end
end


function BattleSkill:processOneAttack(userInfo,attackObject, byAttackObject, fightModule, resultBuffer)
	self.effectAmount = 0
	local effectBuffer = {}
	local endureDirection = FightUtil.computeEndureDirection(attackObject.coordinate, self.skillInfluence, byAttackObjects)
	--_crint ("endureDirection: " .. endureDirection[1] .. ", " ..endureDirection[2] .. ", " .. attackObject.coordinate)
	table.insert(effectBuffer, endureDirection[1])
	table.insert(effectBuffer, IniUtil.compart)
	table.insert(effectBuffer, endureDirection[2])
	table.insert(effectBuffer, IniUtil.compart)
	-- if(attackObject.isAction ~= true) then
	-- 	attackObject.isAction = true
	-- 	self:restoreStatus()
	-- 	self.effectAmount = self.effectAmount + 1
	-- 	self.byAttackerTag = attackObject.battleTag
	-- 	self.byAttackerCoordinate = attackObject.coordinate
	-- 	self.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
	-- 	self.isDisplay = 0
	-- 	if(attackObject.skillPoint >= 4 and true ~= attackObject.isDisSp) then
	-- 		self.effectType = BattleSkill.SKILL_INFLUENCE_DAMAGESP
	-- 		self.effectValue = 4
	-- 		attackObject:subSkillPoint(4)
	-- 		attackObject.totalSkillPoint = self.effectValue
	-- 	elseif(true ~= attackObject.isSpDisable) then
	-- 		self.effectType = BattleSkill.SKILL_INFLUENCE_ADDSP
	-- 		self.effectValue = 2
	-- 		attackObject:addSkillPoint( 2)
	-- 	end
	-- 	if attackObject.isNeedAddSkillPoint == false then
	-- 		attackObject:addZomSkillPoint(2)
	-- 	end
	-- 	--_crint ("Exit before write")
	-- 	self:writeSkillAttack(userInfo, attackObject, attackObject, fightModule, effectBuffer)
	-- end
	local count=0
	
	--for (Byte byAttackCoordinate : byAttackCoordinates) {
	--_crint ("byAttackCoordinates are: ")
	self.byAttackerTag = byAttackObject.battleTag
	print("出手方坐标",byAttackObject.coordinate)
	self.byAttackerCoordinate = byAttackObject.coordinate
	self.effectType = self.skillInfluence.skillCategory
	if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
		attackObject:restoreAttackState()
		byAttackObject:restoreAttackState()
		
		local restrainObj = RestrainUtil.calculateHasRestrain(attackObject, byAttackObject);
		
		if (restrainObj ~= nil) then
			self.restrain = 1
		else
			self.restrain = 0
		end
		----_crint ("has restrain: " .. self.restrain)
		--os.exit()
		RestrainUtil.calculateRestrainProperty(attackObject, byAttackObject)
		RestrainUtil.calculateRestrainProperty(byAttackObject, attackObject)
		TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_ATTACK, attackObject, byAttackObject, self.skillMould)
		TalentJudge:judge(TalentConstant.JUDGE_OPPORTUNITY_BY_ATTACK, attackObject, byAttackObject, self.skillMould)
		FightUtil.computeEvasion(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
		if(byAttackObject.isEvasionSurely) then
			byAttackObject.isEvasion=true
			byAttackObject.isEvasionSurely=false
		end
		if(true ~= byAttackObject.isEvasion) then
			FightUtil.computeCritial(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
			if(attackObject.isCritical) then
				self.bearState = 2
				----_crint ("self.bearState = 2")
				--os.exit()
			end
			if(byAttackObject.isRetain) then
				if(self.bearState == 2) then
					self.bearState = 4
				else	
					self.bearState = 3
				end
				if(byAttackObject.canReAttack) then						
					self.aliveState = 2
					-- for i = 1, table.maxn(byAttackObjects) do
					for i, v in pairs(byAttackObjects) do
						if(nil ~= byAttackObjects[i]) then
							byAttackObjects[i].canReAttack=false
						end
					end
				end
			end
		else
			self.bearState = 1
		end
	
	else
		self.bearState = 0
	end
	local effectArray = nil
	if(self.skillInfluence.skillCategory == FightUtil.FORMULA_INFO_CLEAR_BUFF) then
		--_crint ("effectArray is clear buff")
		effectArray = FightUtil.computeBuffEffect(self.skillMould, self.skillInfluence, attackObject, byAttackObject)
	else
		--_crint ("effectArray is computeSkillEffect")
		effectArray = FightUtil.computeSkillEffect(self,self.skillMould, self.skillInfluence, attackObject, byAttackObject)
		if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_DIZZY
				 and effectArray[3] == 1) then
				self.isDisplay = 0
		end
		
		if(self.skillInfluence.formulaInfo == FightUtil.FORMULA_INFO_ADD_KILL) then
			self.bearState = 0
		end
	end
	attackObject.totalSkillPoint = 0
	self.effectValue = effectArray[1]
	self.effectRound =  effectArray[2]
	self.clearBuffState = effectArray[4]
	if(byAttackObject.healthPoint < 1) then
		if(byAttackObject.battleTag == 0) then
			fightModule.attackCount = fightModule.attackCount - 1
		else
			fightModule.byAttackCount = fightModule.byAttackCount - 1
		end
		-- byAttackObject.isDead=true
		-- byAttackObjects[byAttackCoordinate] = nil
		TalentSkill.processTargetDead(userInfo, fightModule, attackObject, byAttackObject)
		TalentSkill.processSelfDead(userInfo, fightModule, attackObject, byAttackObject)
		self:processHpCurePercent(userInfo, self, fightModule, attackObject)
		self.aliveState = 1
		--self:dropReward(fightModule, byAttackObject)
	else
		if(self.aliveState == 2) then
			if(attackObject.healthPoint < 1) then
				if(attackObject.battleTag == 0) then
					fightModule.attackCount = fightModule.attackCount - 1
					-- fightModule.attackObjects[attackObject.coordinate] = nil
				else
					fightModule.byAttackCount = fightModule.byAttackCount - 1
					-- fightModule.byAttackObjects[attackObject.coordinate] = nil
				end
				-- attackObject.isDead=true
				self.aliveState = 0
			else
				self.reattackObject = attackObject
			end
			local talentJudgeResultList = attackObject:getTalentJudgeResultByResultType(TalentConstant.JUDGE_RESULT_NO_REATTACK)
			if(#talentJudgeResultList > 0) then
				self.aliveState = 0
				self.reattackObject = nil
			end
		end
	end
	if(effectArray[3] > 0)then
		self.bearState =  effectArray[3]
	end
	self:writeSkillAttack(userInfo, attackObject, byAttackObject, fightModule, effectBuffer)
	self.effectAmount = self.effectAmount + 1
	attackObject:addTotalEffectDamage(self.effectValue)
	-- if(self:checkSkillAndTalent(attackObject) and count < #byAttackCoordinates)then
	-- 	--continue
	-- else
	if(self.effectType == BattleSkill.SKILL_INFLUENCE_DAMAGEHP) then
		TalentSkill.processAttack(userInfo, self, fightModule, attackObject, byAttackObject)
		TalentSkill.processByAttack(userInfo, self, fightModule, attackObject, byAttackObject)
		TalentSkill.processUniteAttack(userInfo, self, fightModule, attackObject, byAttackObject)
	end
	attackObject:clearTalentJudgeResultList()
	byAttackObject:clearTalentJudgeResultList()
		-- attackObject.isAction=false
	-- end
	if(self.effectAmount > 0) then
		fightModule.battleSkillCount = fightModule.battleSkillCount + 1
		table.insert(resultBuffer, self.skillInfluence.id)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, 0)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.battleTag)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, attackObject.coordinate)
		table.insert(resultBuffer, IniUtil.compart)
		table.insert(resultBuffer, self.effectAmount)
		table.insert(resultBuffer, IniUtil.compart)
		IniUtil.concatTable(resultBuffer, effectBuffer)
	end
	self:processHpRemainDamage(userInfo, self, fightModule, attackObject)
end