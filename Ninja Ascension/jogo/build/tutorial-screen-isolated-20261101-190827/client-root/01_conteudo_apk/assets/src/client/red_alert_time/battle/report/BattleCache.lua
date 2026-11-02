
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
    self.currentBattleCount = encryptInfo(0)

    --最大战斗场次
    self.maxBattleCount = encryptInfo(0)

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

    --pvp地方用户信息
    self.userPVPInfo =  nil
end

function BattleCache:addTotalDamage(totalDamage)
	self.totalDamage = self.totalDamage + totalDamage
end


function BattleCache:addCurrentBattleCount(currentBattleCount)
	self.currentBattleCount = encryptInfo(decryptInfo(self.currentBattleCount) + currentBattleCount)
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



function BattleCache:clear()
    --用户信息
    self.userInfo =  nil

    --攻击方名称
    self.attackName =  nil

    --被攻击方名称
    self.byAttackName = nil

    --战斗类型
    self.battleType = nil

    --攻击方战力
    self.attackCombatForce = nil

    --被攻击方战力
    self.byAttackComobatForce = nil

    --被攻击者Id
    self.byAttackerId =  nil

    --当前战斗场次
    self.currentBattleCount = nil

    --最大战斗场次
    self.maxBattleCount = nil

    --难度
    self.difficulty = nil

    --阵型战斗对象
    -- self.attackerObjects =  {}
    for i, v in pairs(self.attackerObjects) do
        v:clear()
        self.attackerObjects[i] = nil
    end
    self.attackerObjects = nil

    --被攻击者战斗对象队列
    -- self.byAttackerObjectsList = {}
    for n, r in pairs(self.byAttackerObjectsList) do
        for i, v in pairs(r) do
            v:clear()
            r[i] = nil
        end
        self.byAttackerObjectsList[n] = nil
    end
    self.byAttackerObjectsList = nil

    --战斗中奖励卡牌
    -- self.battleReward = {}
    for i, v in pairs(self.battleReward) do
        self.battleReward[i] = nil
    end
    self.battleReward = nil

    --战斗中奖励道具
    -- self.battleRewardProp = {}
    for i, v in pairs(self.battleRewardProp) do
        self.battleRewardProp[i] = nil
    end
    self.battleRewardProp = nil

    --战斗中奖励装备
    -- self.battleRewardEquipment = {}
    for i, v in pairs(self.battleRewardEquipment) do
        self.battleRewardEquipment[i] = nil
    end
    self.battleRewardEquipment = nil

    --总伤害
    self.totalDamage = nil

    self.userViceCaptainInfo =  nil

    self.byUserViceCaptainInfo =  nil

    --pvp地方用户信息
    self.userPVPInfo =  nil
end
