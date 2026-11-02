
BattleCache = class("BattleCache")

function BattleCache:ctor()
    --用户信息
    self.userInfo =  nil

    --攻击方名称
    self.attackName =  ""

    --被攻击方名称
    self.byAttackName =  ""

    --战斗类型
    self.battleType =  FightModule.FIGHT_TYPE_PVE_NORMAL

    --攻击方战力
    self.attackCombatForce =  0

    --被攻击方战力
    self.byAttackComobatForce =  0

    --被攻击者Id
    self.byAttackerId =  nil

    --当前战斗场次
    self.currentBattleCount =  0

    --最大战斗场次
    self.maxBattleCount =  0

    --难度
    self.difficulty =  1

    --阵型战斗对象
    self.attackerObjects =  {}

    --被攻击者战斗对象队列
    self.byAttackerObjectsList = {}

    --战斗中奖励卡牌
    self.battleReward = {}

    --战斗中奖励道具
    self.battleRewardProp = {}

    --战斗中奖励装备
    self.battleRewardEquipment = {}

    --总伤害
    self.totalDamage =  0

    self.userViceCaptainInfo =  nil

    self.byUserViceCaptainInfo =  nil

end

function BattleCache:addTotalDamage(totalDamage)
	self.totalDamage = self.totalDamage + totalDamage
end


function BattleCache:addCurrentBattleCount(currentBattleCount)
	self.currentBattleCount = self.currentBattleCount + currentBattleCount
end

function BattleCache:getFightObjectCount(fightObjects)
	local count = 0
	for k, v in pairs(fightObjects)  do
		if (nil ~= v) then
			count = count + 1
		end
	end
	return count
end
