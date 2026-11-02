require "extern"
require "cc"
require "client.loader.LocalDatas"


require "client.loader.EnvironmentDatas"

require "frameworks.external.utils.local_datas"
require "client.loader.ConfigDB"
require "math"
require "client.report.IniUtil"
require "client.report.RestrainUtil"

require "client.report.EnvironmentShipModule"
require "client.report.EnvironmentShip"
require "client.report.RestrainObject"
require "client.report.FightObject"

require "client.report.FightModule"
require "client.report.TalentSkill"
require "client.report.TalentUniteSkill"
require "client.report.Formation"
require "client.report.TalentAura"
require "client.report.TalentConstant"
require "client.report.TalentImmunity"
require "client.report.TalentJudge"
require "client.report.TalentJudgeResult"

require "client.report.TalentMould"
require "client.report.BattleCache"
require "client.report.EquipmentMould"
require "client.report.BattleObject"
require "client.report.Npc"

require "client.report.SkillMould"
require "client.report.ShipMould"
require "client.report.SkillInfluence"
require "client.report.EnvironmentFormation"
require "client.report.RestrainMould"

require "client.report.RookieCache"

require "client.report.BattleSkill"
require "client.report.FightBuff"

app.load("client.battle.report.RestrainMould")
--require "client.report.UserInfo"

require "client.report.FightUtil"


require "client.loader.class_init"

--math.randomseed(tostring(os.time()):reverse():sub(1, 6))
--split = zstring.split

table.getn = function(arrayObj)
	if (type(arrayObj) ~= "table") then
		return 0
	end
	local count = 0
	for i, v in pairs(arrayObj) do
		count = i
	end
	return count
end

for idx, filePath in pairs(localData_list) do
	dms.load(filePath)
end




--local environmentFormation = dms.load(dms["environment_formation"], tempRookieCache.fightTypeNpc)
local seatArray = {}
local seatIndex = {environment_formation.seat_one, environment_formation.seat_two, environment_formation.seat_three,
			environment_formation.seat_four, environment_formation.seat_five, environment_formation.seat_six}
for idx, val in pairs(seatIndex) do
	seatArray[#seatArray + 1] = dms.int(dms["environment_formation"], 2, val)
end

--seatArray = {environmentFormation.seatOne, environmentFormation.seatTwo(), environmentFormation.seatThree(), 
--		environmentFormation.seatFour, environmentFormation.seatFive, environmentFormation.seatSix}



local npcObj = ConfigDB.load("npc", 29)
----_crint( npcObj.formationCount)
----_crint( npcObj.getFormationCount())




local fightModule = FightModule:new()

local rookieCache = RookieCache:new()
rookieCache.fightType = 1
rookieCache.fightTypeNpc = 30

local battleCache = BattleCache:new()

local attackUser = {}
attackUser.rookieCache = rookieCache
local difficulty = 1
local fightType = 0
local resultBuffer = {}

	
fightModule:initBattleField(attackUser, npcObj, difficulty, fightType, resultBuffer)



--battleCache.byAttackerObjectsList = byAttackerObjectsList
for _, obj in pairs(attackUser.battleCache.byAttackerObjectsList) do
	----_crint(type(obj))
	for _, fightObject in pairs(obj) do
		-- _crint (fightObject.name)
	end
end

for _, obj in pairs(attackUser.battleCache.attackerObjects) do
	----_crint(type(obj))
	--_crint(obj.healthPoint .. ", " .. obj.physicalDefence)
	for _, fightObject in pairs(obj) do
		-- _crint (fightObject)
	end
end
local resultBuffer = {}
fightModule:fight(attackUser, resultBuffer)

-- for _, val in pairs(resultBuffer) do
	-- --_crint(_, val)
-- end
--_crint(table.concat(resultBuffer, ""))
--os.exit()
