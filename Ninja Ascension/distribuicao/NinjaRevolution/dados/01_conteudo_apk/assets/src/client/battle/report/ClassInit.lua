function EnvironmentFormation:init(rowString)
	local row = rowString
	if (type(rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end
    self.id = tonumber( row[1] )
    self.formationName = row[2]
    self.canBattleOperate = tonumber( row[3] )
    self.battleRoundLimit = tonumber( row[4] )
    self.picIndex = row[5]
    self.fightBg = tonumber( row[6] )
    self.level = tonumber( row[7] )
    self.seatOne = tonumber( row[8] )
    self.seatTwo = tonumber( row[9] )
    self.seatThree = tonumber( row[10] )
    self.seatFour = tonumber( row[11] )
    self.seatFive = tonumber( row[12] )
    self.seatSix = tonumber( row[13] )
    self.seatSeven = tonumber( row[14] )
    self.seatEight = tonumber( row[15] )
    self.seatNine = tonumber( row[16] )
    self.amplifyPercentage = row[17]
    self.getOfExperience = tonumber( row[18] )
    self.getOfRepute = tonumber( row[19] )
    self.getOfSilver = tonumber( row[20] )
    self.getOfProp1 = tonumber( row[21] )
    self.propOdds1 = tonumber( row[22] )
    self.getOfProp1Count = tonumber( row[23] )
    self.getOfProp2 = tonumber( row[24] )
    self.propOdds2 = tonumber( row[25] )
    self.getOfProp2Count = tonumber( row[26] )
    self.getOfProp3 = tonumber( row[27] )
    self.propOdds3 = tonumber( row[28] )
    self.getOfProp3Count = tonumber( row[29] )
    self.getOfProp4 = tonumber( row[30] )
    self.propOdds4 = tonumber( row[31] )
    self.getOfProp4Count = tonumber( row[32] )
    self.getOfProp5 = tonumber( row[33] )
    self.propOdds5 = tonumber( row[34] )
    self.getOfProp5Count = tonumber( row[35] )
    self.getOfEquipment = tonumber( row[36] )
    self.equipmentOdds = tonumber( row[37] )
    self.getOfEquipmentCount = tonumber( row[38] )
    self.battleFailedGuide = row[39]
    self.dailyAttackCount = tonumber( row[40] )
    self.firstRewardGroup = tonumber( row[41] )
    self.combatForce = tonumber( row[42] )
end

function EnvironmentShip:init(rowString)
	local row = rowString
	if (type(rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end

    --local 
    self.id = tonumber( row[1] )
    self.captainType = tonumber( row[2] )
    self.campPreference = tonumber( row[3] )
    self.shipName = row[4]
    self.level = tonumber( row[5] )
    self.gender = tonumber( row[6] )
    self.commonSkillMould = tonumber( row[7] )
    self.skillMould = tonumber( row[8] )
    self.skillName = row[9]
    self.skillDescribe = row[10]
    self.shipType = tonumber( row[11] )
    self.power = tonumber( row[12] )
    self.courage = tonumber( row[13] )
    self.intellect = tonumber( row[14] )
    self.nimable = tonumber( row[15] )
    self.critical = tonumber( row[16] )
    self.criticalResist = tonumber( row[17] )
    self.jink = tonumber( row[18] )
    self.accuracy = tonumber( row[19] )
    self.retain = tonumber( row[20] )
    self.retainBreak = tonumber( row[21] )
    self.haveDeadly = tonumber( row[22] )
    self.growPower = tonumber( row[23] )
    self.growCourage = tonumber( row[24] )
    self.growIntellect = tonumber( row[25] )
    self.growNimable = tonumber( row[26] )
    self.picIndex = row[27]
    self.bustIndex = tonumber( row[28] )
    self.physicsAttackEffect = row[29] -- tonumber( row[29] )
    self.screenAttackEffect = tonumber( row[30] )
    self.physicsAttackMode = tonumber( row[31] )
    self.skillAttackMode = tonumber( row[32] )
    self.rewardCard = tonumber( row[33] )
    self.rewardCardRatio = tonumber( row[34] )
    self.talentMould = row[35]
    self.capacity = tonumber( row[36] )
    self.directing = tonumber( row[37] )
    self.dropProp = tonumber( row[38] )
    self.dropPropRatio = tonumber( row[39] )
    self.dropEquipment = tonumber( row[40] )
    self.dropEquipmentRatio = tonumber( row[41] )
    self.signType = tonumber( row[42] )
    self.signPic = tonumber( row[43] )
end

function EquipmentMould:init(rowString)
    local row = rowString
	if (type(rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end 
    self.id = tonumber( row[1] )
    self.equipmentName = row[2]
    self.suitId = tonumber( row[3] )
    self.influenceType = tonumber( row[4] )
    self.equipmentType = tonumber( row[5] )
    self.initialValue = row[6]
    self.rankLevel = tonumber( row[7] )
    self.starLevel = tonumber( row[8] )
    self.growLevel = tonumber( row[9] )
    self.growValue = row[10]
    self.initShipLevel = tonumber( row[11] )
    self.silverPrice = tonumber( row[12] )
    self.isSell = tonumber( row[13] )
    self.shopOfSilver = tonumber( row[14] )
    self.shopOfGold = tonumber( row[15] )
    self.shopOfIron = tonumber( row[16] )
    self.picIndex = row[17]
    self.allIcon = row[18]
    self.traceRemarks = row[19]
    self.traceScene = row[20]
    self.traceNpc = row[21]
    self.traceNpcIndex = row[22]
    self.visibleOfLevel = tonumber( row[23] )
    self.visibleOfVipLevel = tonumber( row[24] )
    self.sellOfVipLevel = tonumber( row[25] )
    self.purchaseCountLimit = tonumber( row[26] )
    self.isDailyRefreshLimit = tonumber( row[27] )
    self.initialLevel = tonumber( row[28] )
    self.sellTag = tonumber( row[29] )
    self.entirePurchaseCountLimit = tonumber( row[30] )
    self.level20UnlockValue = row[31]
    self.level40UnlockValue = row[32]
    self.refiningGrowValue = row[33]
    self.refiningRequireId = row[34]
    self.refiningLevelLimit = tonumber( row[35] )
    self.initialSupplyEscalateExp = tonumber( row[36] )
    self.refiningGetOfStone = tonumber( row[37] )
    self.refiningGetOfEssence = tonumber( row[38] )
    self.relationshipTag = row[39]
    self.grabRankLink = tonumber( row[40] )
    self.refiningPropertyId = tonumber( row[41] )
    self.refiningItems = row[42]
    self.equipmentSeat = tonumber( row[43] )
    self.refiningGetOfGlories = tonumber( row[44] )
    self.skillEquipmentAdronMould = tonumber( row[45] )
    self.traceAddress = row[46]
end

function Npc:init(rowString)
	local row = rowString
	if (type(rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end 
    self.id = tonumber( row[1] )
    self.npcName = row[2]
    self.headPic = tonumber( row[3] )
    self.basePic = tonumber( row[4] )
    self.attackLevelLimit = tonumber( row[5] )
    self.initShow = tonumber( row[6] )
    self.initLock = tonumber( row[7] )
    self.formationCount = tonumber( row[8] )
    self.environmentFormation1 = tonumber( row[9] )
    self.environmentFormation2 = tonumber( row[10] )
    self.environmentFormation3 = tonumber( row[11] )
    self.environmentFormation4 = tonumber( row[12] )
    self.environmentFormation5 = tonumber( row[13] )
    self.environmentFormation6 = tonumber( row[14] )
    self.environmentFormation7 = tonumber( row[15] )
    self.environmentFormation8 = tonumber( row[16] )
    self.environmentFormation9 = tonumber( row[17] )
    self.environmentFormation10 = tonumber( row[18] )
    self.environmentFormation11 = tonumber( row[19] )
    self.environmentFormation12 = tonumber( row[20] )
    self.environmentFormation13 = tonumber( row[21] )
    self.environmentFormation14 = tonumber( row[22] )
    self.environmentFormation15 = tonumber( row[23] )
    self.environmentFormation16 = tonumber( row[24] )
    self.environmentFormation17 = tonumber( row[25] )
    self.environmentFormation18 = tonumber( row[26] )
    self.environmentFormation19 = tonumber( row[27] )
    self.environmentFormation20 = tonumber( row[28] )
    self.environmentFormation21 = tonumber( row[29] )
    self.environmentFormation22 = tonumber( row[30] )
    self.environmentFormation23 = tonumber( row[31] )
    self.environmentFormation24 = tonumber( row[32] )
    self.environmentFormation25 = tonumber( row[33] )
    self.environmentFormation26 = tonumber( row[34] )
    self.environmentFormation27 = tonumber( row[35] )
    self.environmentFormation28 = tonumber( row[36] )
    self.environmentFormation29 = tonumber( row[37] )
    self.environmentFormation30 = tonumber( row[38] )
    self.environmentFormation31 = tonumber( row[39] )
    self.environmentFormation32 = tonumber( row[40] )
    self.environmentFormation33 = tonumber( row[41] )
    self.environmentFormation34 = tonumber( row[42] )
    self.environmentFormation35 = tonumber( row[43] )
    self.environmentFormation36 = tonumber( row[44] )
    self.environmentFormation37 = tonumber( row[45] )
    self.environmentFormation38 = tonumber( row[46] )
    self.environmentFormation39 = tonumber( row[47] )
    self.environmentFormation40 = tonumber( row[48] )
    self.environmentFormation41 = tonumber( row[49] )
    self.environmentFormation42 = tonumber( row[50] )
    self.environmentFormation43 = tonumber( row[51] )
    self.environmentFormation44 = tonumber( row[52] )
    self.environmentFormation45 = tonumber( row[53] )
    self.environmentFormation46 = tonumber( row[54] )
    self.environmentFormation47 = tonumber( row[55] )
    self.environmentFormation48 = tonumber( row[56] )
    self.environmentFormation49 = tonumber( row[57] )
    self.environmentFormation50 = tonumber( row[58] )
    self.environmentFormation51 = tonumber( row[59] )
    self.environmentFormation52 = tonumber( row[60] )
    self.environmentFormation53 = tonumber( row[61] )
    self.environmentFormation54 = tonumber( row[62] )
    self.environmentFormation55 = tonumber( row[63] )
    self.environmentFormation56 = tonumber( row[64] )
    self.environmentFormation57 = tonumber( row[65] )
    self.environmentFormation58 = tonumber( row[66] )
    self.environmentFormation59 = tonumber( row[67] )
    self.environmentFormation60 = tonumber( row[68] )
    self.environmentFormation61 = tonumber( row[69] )
    self.environmentFormation62 = tonumber( row[70] )
    self.environmentFormation63 = tonumber( row[71] )
    self.environmentFormation64 = tonumber( row[72] )
    self.environmentFormation65 = tonumber( row[73] )
    self.environmentFormation66 = tonumber( row[74] )
    self.environmentFormation67 = tonumber( row[75] )
    self.environmentFormation68 = tonumber( row[76] )
    self.environmentFormation69 = tonumber( row[77] )
    self.environmentFormation70 = tonumber( row[78] )
    self.environmentFormation71 = tonumber( row[79] )
    self.environmentFormation72 = tonumber( row[80] )
    self.environmentFormation73 = tonumber( row[81] )
    self.environmentFormation74 = tonumber( row[82] )
    self.environmentFormation75 = tonumber( row[83] )
    self.environmentFormation76 = tonumber( row[84] )
    self.environmentFormation77 = tonumber( row[85] )
    self.environmentFormation78 = tonumber( row[86] )
    self.environmentFormation79 = tonumber( row[87] )
    self.environmentFormation80 = tonumber( row[88] )
    self.environmentFormation81 = tonumber( row[89] )
    self.environmentFormation82 = tonumber( row[90] )
    self.environmentFormation83 = tonumber( row[91] )
    self.environmentFormation84 = tonumber( row[92] )
    self.environmentFormation85 = tonumber( row[93] )
    self.environmentFormation86 = tonumber( row[94] )
    self.environmentFormation87 = tonumber( row[95] )
    self.environmentFormation88 = tonumber( row[96] )
    self.environmentFormation89 = tonumber( row[97] )
    self.environmentFormation90 = tonumber( row[98] )
    self.environmentFormation91 = tonumber( row[99] )
    self.environmentFormation92 = tonumber( row[100] )
    self.environmentFormation93 = tonumber( row[101] )
    self.environmentFormation94 = tonumber( row[102] )
    self.environmentFormation95 = tonumber( row[103] )
    self.environmentFormation96 = tonumber( row[104] )
    self.environmentFormation97 = tonumber( row[105] )
    self.environmentFormation98 = tonumber( row[106] )
    self.environmentFormation99 = tonumber( row[107] )
    self.environmentFormation100 = tonumber( row[108] )
    self.isStatProgress = tonumber( row[109] )
    self.difficultyIncludeCount = tonumber( row[110] )
    self.difficultyReward = row[111]
    self.mapIndex = tonumber( row[112] )
    self.battleBackground = row[113]
    self.battleBackgroundMusic = row[114]
    self.dropLibrary = tonumber( row[115] )
    self.getStarCondition = tonumber( row[116] )
    self.getStarDescribe = row[117]
    self.dailyAttackCount = tonumber( row[118] )
    self.attackNeedFood = tonumber( row[119] )
    self.unlockNpc = row[120]
    self.difficultyAdditional = row[121]
    self.towelReward = tonumber( row[122] )
    self.firstReward = tonumber( row[123] )
    self.npcType = tonumber( row[124] )
    self.soundIndex = tonumber( row[125] )
    self.signMsg = row[126]
    self.byOpenNpc = row[127]
end

function RestrainMould:init(rowString)
    local row = rowString
	if (type(rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end 
    self.id = tonumber( row[1] )
    self.camp = tonumber( row[2] )
    self.restrainCamp = tonumber( row[3] )
    self.restrainAddition = row[4]
end

function ShipMould:init(rowString)
	local row = rowString
	if  (type (rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end
    self.id = tonumber( row[1] )
    self.captainName = row[2]
    self.campPreference = tonumber( row[3] )
    self.captainType = tonumber( row[4] )
    self.heroGender = tonumber( row[5] )
    self.isGeneral = tonumber( row[6] )
    self.shipName = row[7]
    self.canRecruit = tonumber( row[8] )
    self.ability = tonumber( row[9] )
    self.leader = tonumber( row[10] )
    self.strength = tonumber( row[11] )
    self.wisdom = tonumber( row[12] )
    self.initialPower = tonumber( row[13] )
    self.initialCourage = tonumber( row[14] )
    self.initialIntellect = tonumber( row[15] )
    self.initialNimable = tonumber( row[16] )
    self.initialCritical = tonumber( row[17] )
    self.initialCriticalResist = tonumber( row[18] )
    self.initialJink = tonumber( row[19] )
    self.initialAccuracy = tonumber( row[20] )
    self.initialRetain = tonumber( row[21] )
    self.initialRetainBreak = tonumber( row[22] )
    self.haveDeadly = tonumber( row[23] )
    self.growPower = tonumber( row[24] )
    self.growCourage = tonumber( row[25] )
    self.growIntellect = tonumber( row[26] )
    self.growNimable = tonumber( row[27] )
    self.skillMould = tonumber( row[28] )
    self.deadlySkillMould = tonumber( row[29] )
    self.relationshipId = row[30]
    self.talentId = row[31]
    self.talentActiviteNeed = row[32]
    self.skillName = row[33]
    self.skillDescribe = row[34]
    self.boatyardLevel = tonumber( row[35] )
    self.shipType = tonumber( row[36] )
    self.shipPic = row[37]
    self.price = tonumber( row[38] )
    self.needHonor = tonumber( row[39] )
    self.physicsAttackEffect = tonumber( row[40] )
    self.screenAttackEffect = tonumber( row[41] )
    self.physicsAttackMode = tonumber( row[42] )
    self.skillAttackMode = tonumber( row[43] )
    self.initialLevel = tonumber( row[44] )
    self.initialRankLevel = tonumber( row[45] )
    self.rankGrowUpLimit = tonumber( row[46] )
    self.growTargetId = tonumber( row[47] )
    self.requiredMaterialId = tonumber( row[48] )
    self.shipStar = tonumber( row[49] )
    self.headIcon = tonumber( row[50] )
    self.bustIndex = tonumber( row[51] )
    self.allIcon = tonumber( row[52] )
    self.baseMould = tonumber( row[53] )
    self.introduce = row[54]
    self.initialExperienceSupply = tonumber( row[55] )
    self.sellGetMoney = tonumber( row[56] )
    self.refineGetSoul = tonumber( row[57] )
    self.refineGetJade = tonumber( row[58] )
    self.wayOfGain = row[59]
    self.capacity = tonumber( row[60] )
    self.baseMould2 = tonumber( row[61] )
    self.baseMouldPriority = tonumber( row[62] )
    self.cultivatePropertyId = tonumber( row[63] )
    self.zoariumSkill = tonumber( row[64] )
    self.traceAddress = row[65]
    self.primeMover = tonumber( row[66] )
    self.soundIndex = tonumber( row[67] )
    self.signMsg = row[68]
    self.arenaInit = tonumber( row[69] )
end

function SkillInfluence:init(rowString)
    local row = rowString
	if (type(rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end 
    self.id = tonumber( row[1] )
    self.skillMould = tonumber( row[2] )
    self.influenceDescribe = row[3]
    self.skillCategory = tonumber( row[4] )
    self.skillParam = tonumber( row[5] )
    self.skillEffectMinValue = tonumber( row[6] )
    self.skillEffectMaxValue = tonumber( row[7] )
    self.formulaInfo = tonumber( row[8] )
    self.isRate = tonumber( row[9] )
    self.additionEffectProbability = tonumber( row[10] )
    self.influenceGroup = tonumber( row[11] )
    -- self.influenceRange = tonumber( row[12] )
    local arrs = zstring.split(row[12], ",")
    self.influenceRange = tonumber( arrs[1] )
    self.influenceRangeType = tonumber( arrs[2] )
    self.peakLimit = tonumber( row[13] )
    self.influenceRestrict = tonumber( row[14] )
    self.influenceDuration = tonumber( row[15] )
    self.beforeAction = row[16]
    self.forepartLightingEffectId = tonumber( row[17] )
    self.forepartLightingSoundEffectId = tonumber( row[18] )
    self.afterAction = row[19]
    self.posteriorLightingEffectId = tonumber( row[20] )
    self.attackSection = tonumber( row[21] )
    self.posteriorLightingSoundEffectId = tonumber( row[22] )
    self.lightingEffectDrawMethod = tonumber( row[23] )
    self.lightingEffectCount = tonumber( row[24] )
    self.armyBearAction = row[25]
    self.bearLightingEffectId = tonumber( row[26] )
    self.bearSoundEffectId = tonumber( row[27] )
    self.isVibrate = tonumber( row[28] )
    self.pathAcrtoon = row[29]
    self.rearEnd = row[30]
    self.beforeAttackFrame = row[31]
    self.hitDown = row[32]

    -- 技能效用的成长值
    self.levelInitValue = tonumber( row[33] ) -- 固定值
    self.levelGrowValue = tonumber( row[34] ) -- 每级固定值成长
    self.levelPercentGrowValue = tonumber( row[35] ) -- 每级百分比成长
    self.nextSkillInfluence = tonumber( row[36] ) -- 被执行的效用ID

    -- 附加额外属性变化

    local additionalProperty = {}
    if row[37] and row[37] ~= "-1" then
        local temp_arrs = zstring.splits(row[37], "|", ",")
        for _, v in ipairs(temp_arrs) do
            table.insert(additionalProperty, {propertyType = tonumber(v[1]), propertyValue = tonumber(v[2])})
        end
    end
    
    self.additionalProperty = additionalProperty

    self.level = 1
end

function SkillMould:init(rowString)
	local row = rowString
	if (type(rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end   
    self.id = tonumber( row[1] )
    self.skillName = row[2]
    self.skillDescribe = row[3]
    self.skillQuality = tonumber( row[4] )
    self.skillPic = tonumber( row[5] )
    self.skillProperty = tonumber( row[6] )
    self.skillReleasePosition = tonumber( row[7] )
    self.afterRemove = tonumber( row[8] )
    self.healthAffect = row[9]
    self.buffAffect = row[10]
    self.baseMould = tonumber( row[11] )
    self.nextLevelSkill = tonumber( row[12] )
    self.releaseMould = row[13]
    self.releasSkill = row[14]
    self.seriatim = tonumber( row[15] )
    self.attackMoveMode = tonumber( row[16] )
	--_crint ("SkillMould:init: healthAffect " .. self.healthAffect)
	--_crint ("buffAffect " .. self.buffAffect)
	--_crint ("skillProperty " .. self.skillProperty)
end

function TalentMould:init(rowString)
    local row = rowString
	if (type(rowString) == "string") then
		row = zstring.split(rowString, "\t")
	end 
    self.id = tonumber( row[1] )
    self.talentName = row[2]
    self.describe = row[3]
    self.baseAdditional = row[4]
    self.influenceImmunity = row[5]
    self.influencePriorType = tonumber( row[6] )
    self.influencePriorValue = row[7]
    self.influenceJudgeOpportunity = tonumber( row[8] )
    self.influenceJudgeType1 = tonumber( row[9] )
    self.influenceJudgeType2 = tonumber( row[10] )
    self.influenceJudgeResult = row[11]
    self.influenceJudgeOdds = tonumber( row[12] )
    self.influenceEffectId = tonumber( row[13] )
    self.influenceLock = tonumber( row[14] )
end

