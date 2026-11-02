app.load("client.battle.report.ConfigDB")
app.load("client.battle.report.IniUtil")
app.load("client.battle.report.RestrainUtil")
app.load("client.battle.report.EnvironmentShipModule")
app.load("client.battle.report.EnvironmentShip")
app.load("client.battle.report.RestrainObject")
app.load("client.battle.report.FightObject")
app.load("client.battle.report.FightModule")
app.load("client.battle.report.TalentSkill")
app.load("client.battle.report.TalentUniteSkill")
app.load("client.battle.report.TalentAura")
app.load("client.battle.report.TalentConstant")
app.load("client.battle.report.TalentImmunity")
app.load("client.battle.report.TalentJudge")
app.load("client.battle.report.TalentJudgeResult")
app.load("client.battle.report.TalentMould")
app.load("client.battle.report.BattleCache")
app.load("client.battle.report.EquipmentMould")
app.load("client.battle.report.BattleObject")
app.load("client.battle.report.Npc")
app.load("client.battle.report.SkillMould")
app.load("client.battle.report.ShipMould")
app.load("client.battle.report.SkillInfluence")
app.load("client.battle.report.EnvironmentFormation")
app.load("client.battle.report.RestrainMould")
app.load("client.battle.report.RookieCache")
app.load("client.battle.report.BattleSkill")
app.load("client.battle.report.FightUtil")
app.load("client.battle.report.ClassInit")
app.load("client.battle.report.FightBuff")

app.load("client.battle.report.Unit")

app.load("client.loader.LocalDatas")

app.load("client.loader.EnvironmentDatas")

app.load("frameworks.external.utils.local_datas")
app.load("client.battle.report.RestrainMould")
app.load("client.battle.report.Ship")
app.load("client.battle.report.FormulaUtil")

for idx, filePath in pairs(localData_list) do
	dms.load(filePath)
end

-- local fightModule = FightModule:new()
-- fightModule:initBattleField

BattleReport = {}

BattleReport.initEnvironmentFight = function(userInfo, npcId, difficult)
	local fightModule = FightModule:new()

	local battleCache = BattleCache:new()
	_ED.user_info.battleCache = battleCache
	local difficulty = 1
	local fightType = 0
	local resultBuffer = {}
	local npcObj = ConfigDB.load("npc",1)
	fightModule:initBattleField(npcObj, difficulty, fightType, resultBuffer)
	--_crint ("检查出手人员1：",fightModule:checkAttackSell())
	
	local attackObject = fightModule:getAppointFightObject(0,1)
	if(attackObject ~= nil) then
		--_crint ("获取出手方的攻击数据")
		resultBuffer = {}
		fightModule:fightObjectAttack(attackObject,resultBuffer)
		local t = ""
		for k = 1, #resultBuffer do
			t = t.." "..resultBuffer[k]
		end
		--_crint ("未加成伤害",t)
		fightModule:setGradeAttack(attackObject,15)
		resultBuffer = {}
		fightModule:fightObjectAttack(attackObject,resultBuffer)
		t = ""
		for k = 1, #resultBuffer do
			t = t.." "..resultBuffer[k]
		end
		--_crint ("加成伤害",t)
	end
	local stringBuffer = ""
	-- fightModule:fight(_ED.user_info,resultBuffer)
	
	for k = 1, #resultBuffer do
		stringBuffer = stringBuffer.." "..resultBuffer[k]
	end
	--_crint ("**********************************************")
	--_crint(stringBuffer)
	local temp = {}
	local temp1 =""
	-- --_crint ("检查出手人员：",fightModule:checkAttackSell())
	while (fightModule.hasNextRound ~= false) do
		fightModule:rountdFight(temp)
		--_crint ("回合数：",fightModule.roundCount);
		--_crint ("战斗结果：",fightModule.fightResult);
		--_crint ("是否有下一场战斗",fightModule.hasNextRound)
	end
	for k = 1, #temp do
		temp1 = temp1.." "..temp[k]
	end
	--_crint ("**********************************************")
	--_crint(temp1)
	
	--_crint ("战斗结果",fightModule.fightResult)
	fightModule:initBattleInfo(_ED.user_info.battleCache)
	while (fightModule.hasNextRound ~= false) do
		fightModule:rountdFight(temp)
		--_crint ("回合数1：",fightModule.roundCount);
		--_crint ("战斗结果1：",fightModule.fightResult);
		--_crint ("是否有下一场战斗1",fightModule.hasNextRound)
	end
	
end
