--战力计算
--auto zhengchengpeng

FormulaUtil = class("FormulaUtil",window)
app.load("client.battle.report.Ship")
FormulaUtil.FORMULA_COMMON_ATTACK_DAMAGE = 1
	
FormulaUtil.FORMULA_SKILL_ATTACK_DAMAGE = 2

FormulaUtil.FORMULA_AMEND_INTELLECT = 3

FormulaUtil.FORMULA_POWER_GROW = 4

FormulaUtil.FORMULA_JINK_ODDS = 5

FormulaUtil.FORMULA_CRITICAL_ODDS = 6

FormulaUtil.FORMULA_FIGHT_STAR_LEVEL = 7

FormulaUtil.FORMULA_FORMATION_FIRST_STRIKE = 8

FormulaUtil.FORMULA_SHIP_FIRST_STRIKE = 9

FormulaUtil.FORMULA_SHIP_COMBAT_FORCES = 10

FormulaUtil.FORMULA_SKILL_CURE = 11


function FormulaUtil:ctor()
	-- self.fightType = FightModule.FIGHT_TYPE_PVE 
	self.attackShip = nil
	self.byAttackShip = nil
	self.formation = nil
	self.byFormation = nil
	self.skillInfluence = nil
	self.ship = nil
	self.playerShips = nil
	self.shipTotalPowerMaxValue = 0

	self.talents = {}
end

-- /**
--  * 根据公式id查找
--  * @param index 8
--  * @return
--  */
function FormulaUtil:findFormulaByIndex(index)
	local x = self:computeFormationFirstStrike(_ED.user_formetion_status)
	return x
end

-- /**
--  * 计算英雄先攻值
--  * @param ship
--  * @return
--  */
function FormulaUtil:computeShipFirstStrike(ship)
-- //		（攻击*3+生命*0.25+物防*5+法防*5）*（100%+命中率+闪避率+暴击率+抗暴率+伤害加成比例+免伤比例
		-- _crint("攻击 ", ship.courage)
		-- _crint("血量 ", ship.power)
		-- _crint("物防 ", ship.nimable)
		-- _crint("法防 ", ship.intellect)
		-- _crint("命中 ", ship.accuracyAdditionalPercent)
		-- _crint("闪避 ", ship.evasionAdditionalPercent)
		-- _crint("暴击 ", ship.criticalAdditionalPercent)
		-- _crint("抗暴 ", ship.criticalResistAdditionalPercent)
		-- _crint("加伤 ", ship.finalDamageAdditionalPercent)
		-- _crint("免伤 ", ship.finalLessenDamageAdditionalPercent)
	local shipFirstStrike =(ship.courage*3 + ship.power* 0.25 + ship.nimable*5 + ship.intellect*5)
	*(1 + (ship.accuracyAdditionalPercent 
			+ ship.evasionAdditionalPercent
			+ ship.criticalAdditionalPercent
			+ ship.criticalResistAdditionalPercent
			+ ship.finalDamageAdditionalPercent
			+ ship.finalLessenDamageAdditionalPercent)/100)
	return shipFirstStrike
	-- //英雄战力=生命*0.25+ （攻击+物理攻击+法术攻击+物理防御+法术防御*1+（统帅+武力+智慧-150）*10
-- //		shipFirstStrike = (float) (ship.getPower() * 0.2 + ship.getCourage() + ship.getIntellect() + ship.getNimable() + (ship.getLeader() + ship.getStrength() + ship.getWisdom() - 150) * 10)
	-- return shipFirstStrike
end

-- /**
--  * 计算阵型总先攻
--  * @param formation
--  * @return
--  */        [string ".\client/battle/report/FormulaUtil.lua"]:47: in function 'findFormulaByIndex'
function FormulaUtil:computeFormationFirstStrike(formation,ships)
	-- //阵型总先攻=单个武将战力之和
	-- debug.print_r(formation)
	if(nil ~= formation) then
		local formationFirstStrike = 0
		for idx = 1, 6 do
			local ship = nil
			if tonumber(formation[idx]) > 0 then
				ship =  Ship:new()
				ship =  ship:dataTOShip(_ED.user_ship[formation[idx]])
			end
			if (nil ~= ship)  then
				ship:calculateShipProperty(self.talents)
				-- table.insert(ships,ship)
				ships[idx] = ship
			end 
		end
		for i,v in pairs(ships) do
			if v ~= nil then
				v:calculateTalentAuraProperty(self.talents)
				-- ships[idx] = v
			end
			local shipFirstStrike = self:computeShipFirstStrike(v)
			formationFirstStrike = formationFirstStrike + shipFirstStrike
		end
		-- _crint("==========================总战力",formationFirstStrike)
		return formationFirstStrike
	end
	return 0
end
