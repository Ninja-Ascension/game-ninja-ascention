
-- NPC
-- @author alexdu
Npc = class("Npc")

function Npc:ctor()
	--NPCId
	self.id = 0
	
    --NPC名称
    self.npcName =  ""

    --npc头像索引
    self.headPic =  0

    --挑战等级限制
    self.basePic =  0

    --NPC名称
    self.attackLevelLimit =  0

    --初始显示状态 0为不显示，1为显示
    self.initShow =  0

    --初始锁定状态 0为锁定 1为不锁定
    self.initLock =  0

    --环境阵型数量
    self.formationCount =  0

    --环境阵型1
    self.environmentFormation1 =  0

    --环境阵型2
    self.environmentFormation2 =  0

    --环境阵型3
    self.environmentFormation3 =  0

    --环境阵型4
    self.environmentFormation4 =  0

    --环境阵型5
    self.environmentFormation5 =  0

    --环境阵型6
    self.environmentFormation6 =  0

    --环境阵型7
    self.environmentFormation7 =  0

    --环境阵型8
    self.environmentFormation8 =  0

    --环境阵型9
    self.environmentFormation9 =  0

    --环境阵型10
    self.environmentFormation10 =  0

    --环境阵型11
    self.environmentFormation11 =  0

    --环境阵型12
    self.environmentFormation12 =  0

    --环境阵型13
    self.environmentFormation13 =  0

    --环境阵型14
    self.environmentFormation14 =  0

    --环境阵型15
    self.environmentFormation15 =  0

    --环境阵型16
    self.environmentFormation16 =  0

    --环境阵型17
    self.environmentFormation17 =  0

    --环境阵型18
    self.environmentFormation18 =  0

    --环境阵型19
    self.environmentFormation19 =  0

    --环境阵型20
    self.environmentFormation20 =  0

    --环境阵型21
    self.environmentFormation21 =  0

    --环境阵型22
    self.environmentFormation22 =  0

    --环境阵型23
    self.environmentFormation23 =  0

    --环境阵型24
    self.environmentFormation24 =  0

    --环境阵型25
    self.environmentFormation25 =  0

    --环境阵型26
    self.environmentFormation26 =  0

    --环境阵型27
    self.environmentFormation27 =  0

    --环境阵型28
    self.environmentFormation28 =  0

    --环境阵型29
    self.environmentFormation29 =  0

    --环境阵型30
    self.environmentFormation30 =  0

    --环境阵型31
    self.environmentFormation31 =  0

    --环境阵型32
    self.environmentFormation32 =  0

    --环境阵型33
    self.environmentFormation33 =  0

    --环境阵型34
    self.environmentFormation34 =  0

    --环境阵型35
    self.environmentFormation35 =  0

    --环境阵型36
    self.environmentFormation36 =  0

    --环境阵型37
    self.environmentFormation37 =  0

    --环境阵型38
    self.environmentFormation38 =  0

    --环境阵型39
    self.environmentFormation39 =  0

    --环境阵型40
    self.environmentFormation40 =  0

    --环境阵型41
    self.environmentFormation41 =  0

    --环境阵型42
    self.environmentFormation42 =  0

    --环境阵型43
    self.environmentFormation43 =  0

    --环境阵型44
    self.environmentFormation44 =  0

    --环境阵型45
    self.environmentFormation45 =  0

    --环境阵型46
    self.environmentFormation46 =  0

    --环境阵型47
    self.environmentFormation47 =  0

    --环境阵型48
    self.environmentFormation48 =  0

    --环境阵型49
    self.environmentFormation49 =  0

    --环境阵型50
    self.environmentFormation50 =  0

    --环境阵型51
    self.environmentFormation51 =  0

    --环境阵型52
    self.environmentFormation52 =  0

    --环境阵型53
    self.environmentFormation53 =  0

    --环境阵型54
    self.environmentFormation54 =  0

    --环境阵型55
    self.environmentFormation55 =  0

    --环境阵型56
    self.environmentFormation56 =  0

    --环境阵型57
    self.environmentFormation57 =  0

    --环境阵型58
    self.environmentFormation58 =  0

    --环境阵型59
    self.environmentFormation59 =  0

    --环境阵型60
    self.environmentFormation60 =  0

    --环境阵型61
    self.environmentFormation61 =  0

    --环境阵型62
    self.environmentFormation62 =  0

    --环境阵型63
    self.environmentFormation63 =  0

    --环境阵型64
    self.environmentFormation64 =  0

    --环境阵型65
    self.environmentFormation65 =  0

    --环境阵型66
    self.environmentFormation66 =  0

    --环境阵型67
    self.environmentFormation67 =  0

    --环境阵型68
    self.environmentFormation68 =  0

    --环境阵型69
    self.environmentFormation69 =  0

    --环境阵型70
    self.environmentFormation70 =  0

    --环境阵型71
    self.environmentFormation71 =  0

    --环境阵型72
    self.environmentFormation72 =  0

    --环境阵型73
    self.environmentFormation73 =  0

    --环境阵型74
    self.environmentFormation74 =  0

    --环境阵型75
    self.environmentFormation75 =  0

    --环境阵型76
    self.environmentFormation76 =  0

    --环境阵型77
    self.environmentFormation77 =  0

    --环境阵型78
    self.environmentFormation78 =  0

    --环境阵型79
    self.environmentFormation79 =  0

    --环境阵型80
    self.environmentFormation80 =  0

    --环境阵型81
    self.environmentFormation81 =  0

    --环境阵型82
    self.environmentFormation82 =  0

    --环境阵型83
    self.environmentFormation83 =  0

    --环境阵型84
    self.environmentFormation84 =  0

    --环境阵型85
    self.environmentFormation85 =  0

    --环境阵型86
    self.environmentFormation86 =  0

    --环境阵型87
    self.environmentFormation87 =  0

    --环境阵型88
    self.environmentFormation88 =  0

    --环境阵型89
    self.environmentFormation89 =  0

    --环境阵型90
    self.environmentFormation90 =  0

    --环境阵型91
    self.environmentFormation91 =  0

    --环境阵型92
    self.environmentFormation92 =  0

    --环境阵型93
    self.environmentFormation93 =  0

    --环境阵型94
    self.environmentFormation94 =  0

    --环境阵型95
    self.environmentFormation95 =  0

    --环境阵型96
    self.environmentFormation96 =  0

    --环境阵型97
    self.environmentFormation97 =  0

    --环境阵型98
    self.environmentFormation98 =  0

    --环境阵型99
    self.environmentFormation99 =  0

    --环境阵型100
    self.environmentFormation100 =  0

    --是否统计进度
    self.isStatProgress =  -1

    --包含难度数量(1:简单 2:简单普通 3: 简单普通困难)
    self.difficultyIncludeCount =  0

    --难度奖励(银币,将魂)
    self.difficultyReward =  ""

    --地图索引
    self.mapIndex =  -1

    --战斗背景
    self.battleBackground =  ""

    --战斗背景音乐
    self.battleBackgroundMusic =  ""

    --掉落库表
    self.dropLibrary =  0

    --得星条件(成就模板)
    self.getStarCondition =  0

    --得星条件描述
    self.getStarDescribe =  ""

    --每日可攻击次数
    self.dailyAttackCount =  0

    --挑战需要体力
    self.attackNeedFood =  0

    --被解锁的npc
    self.unlockNpc =  ""

    --难度加成
    self.difficultyAdditional =  ""

    --试练塔奖励索引
    self.towelReward = nil

    --首胜奖励
    self.fristReward = nil

    self._npcs =  nil

end

Npc.__index = Npc

Npc.getFormationCount = function()
	return self.formationCount
end

function Npc:getFormationCount()
	return self.formationCount
end

function Npc:init(dbLine)
	
end

function Npc:getEnvironmentFormation(index)
	local formationArray = {
			self.environmentFormation1, self.environmentFormation2, self.environmentFormation3, self.environmentFormation4, 
			self.environmentFormation5, self.environmentFormation6, self.environmentFormation7, self.environmentFormation8, 
			environmentFormation9, environmentFormation10, environmentFormation11, environmentFormation12, 
			environmentFormation13, environmentFormation14, environmentFormation15, environmentFormation16, 
			environmentFormation17, environmentFormation18, environmentFormation19, environmentFormation20, 
			environmentFormation21, environmentFormation22, environmentFormation23, environmentFormation24, 
			environmentFormation25, environmentFormation26, environmentFormation27, environmentFormation28, 
			environmentFormation29, environmentFormation30, environmentFormation31, environmentFormation32, 
			environmentFormation33, environmentFormation34, environmentFormation35, environmentFormation36, 
			environmentFormation37, environmentFormation38, environmentFormation39, environmentFormation40, 
			environmentFormation41, environmentFormation42, environmentFormation43, environmentFormation44, 
			environmentFormation45, environmentFormation46, environmentFormation47, environmentFormation48, 
			environmentFormation49, environmentFormation50, environmentFormation51, environmentFormation52, 
			environmentFormation53, environmentFormation54, environmentFormation55, environmentFormation56, 
			environmentFormation57, environmentFormation58, environmentFormation59, environmentFormation60, 
			environmentFormation61, environmentFormation62, environmentFormation63, environmentFormation64, 
			environmentFormation65, environmentFormation66, environmentFormation67, environmentFormation68, 
			environmentFormation69, environmentFormation70, environmentFormation71, environmentFormation72, 
			environmentFormation73, environmentFormation74, environmentFormation75, environmentFormation76, 
			environmentFormation77, environmentFormation78, environmentFormation79, environmentFormation80, 
			environmentFormation81, environmentFormation82, environmentFormation83, environmentFormation84, 
			environmentFormation85, environmentFormation86, environmentFormation87, environmentFormation88, 
			environmentFormation89, environmentFormation90, environmentFormation91, environmentFormation92, 
			environmentFormation93, environmentFormation94, environmentFormation95, environmentFormation96, 
			environmentFormation97, environmentFormation98, environmentFormation99, environmentFormation100
	}
	if (index > 0  and index <= 100) then
		return formationArray[index]
	end
	return nil
end

local obj = Npc:new()
