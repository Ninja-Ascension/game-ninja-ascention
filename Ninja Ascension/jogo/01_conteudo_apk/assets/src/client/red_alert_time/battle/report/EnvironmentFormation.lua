
-- 环境战船阵型
-- @author alexdu
EnvironmentFormation = class("EnvironmentFormation")

function EnvironmentFormation:ctor()
    --环境战船阵型名称
    self.formationName =  ""

    --战前可否操作阵型(0:否 1:可)
    self.canBattleOperate =  0

    --战斗回合上限
    self.battleRoundLimit =  0

    --图片索引
    self.picIndex =  nil

    --图片索引
    self.fightBG =  0

    --环境战船阵型显示的等级
    self.level =  0

    --阵型位置一环境战船
    self.seatOne =  0

    --阵型位置二环境战船
    self.seatTwo =  0

    --阵型位置三环境战船
    self.seatThree =  0

    --阵型位置四环境战船
    self.seatFour =  0

    --阵型位置五环境战船
    self.seatFive =  0

    --阵型位置六环境战船
    self.seatSix =  0

    --阵型位置七环境战船
    self.seatSeven =  0

    --阵型位置八环境战船
    self.seatEight =  0

    --阵型位置九环境战船
    self.seatNine =  0

    --卡牌放大比例
    self.amplifyPercentage =  ""

    --得到经验
    self.getOfExperience =  0

    --得到悬赏
    self.getOfRepute =  0

    --得到贝里
    self.getOfSilver =  0

    --得到道具1
    self.getOfProp1 =  0

    --得到道具1几率
    self.propOdds1 =  0

    --得到道具1数量
    self.getOfProp1Count =  0

    --得到道具2
    self.getOfProp2 =  0

    --得到道具2几率
    self.propOdds2 =  0

    --得到道具2数量
    self.getOfProp2Count =  0

    --得到道具3
    self.getOfProp3 =  0

    --得到道具3几率
    self.propOdds3 =  0

    --得到道具3数量
    self.getOfProp3Count =  0

    --得到道具4
    self.getOfProp4 =  0

    --得到道具4几率
    self.propOdds4 =  0

    --得到道具4数量
    self.getOfProp4Count =  0

    --得到道具5
    self.getOfProp5 =  0

    --得到道具5几率
    self.propOdds5 =  0

    --得到道具5数量
    self.getOfProp5Count =  0

    --得到装备
    self.getOfEquipment =  0

    --得到装备几率
    self.equipmentOdds =  0

    --得到得到装备数量
    self.getOfEquipmentCount =  0

    --战斗失败指引
    self.battleFailedGuide =  ""

    --每日可攻击次数(-1为不限次数)
    self.dailyAttackCount =  -1

    --首次奖励库组
    self.firstRewardGroup =  -1

    --战斗力
    self.combatForce =  0

    self._environmentFormations =  nil

end

function EnvironmentFormation:getSeat(seatIndex)
	if (seatIndex == 1)  then
		return self.seatOne
	end
	if (seatIndex == 2)  then
		return self.seatTwo
	end
	if (seatIndex == 3)  then
		return self.seatThree
	end
	if (seatIndex == 4)  then
		return self.seatFour
	end
	if (seatIndex == 5)  then
		return self.seatFive
	end
	if (seatIndex == 6)  then
		return self.seatSix
	end
	return 0
end

local obj = EnvironmentFormation:new()