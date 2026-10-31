
EnvironmentShipModule = {}


function EnvironmentShipModule.calculateShipProperty(ship)
	EnvironmentShipModule:calculateShipPropertyByTalent(ship)
	ship.power = ship.power * (100.0 + ship.powerAdditionalPercent) / 100.0
	ship.courage = ship.courage * (100.0 + ship.courageAdditionalPercent) / 100.0
	ship.intellect = ship.intellect * (100.0 + ship.intellectAdditionalPercent) / 100.0
	ship.nimable = ship.nimable * (100.0 + ship.nimableAdditionalPercent) / 100.0
	ship.critical = ship.critical + ship.criticalAdditionalPercent
	ship.jink = ship.jink + ship.evasionAdditionalPercent
end

function EnvironmentShipModule.calculateShipPropertyByTalent(ship)
	ship.talentMouldList = {}
	if(ship.talentMould ~= "" and ship.talentMould ~= "-1" ) then			
		local talentIdArray = zstring.split(ship.talentMould, IniUtil.comma)
		for i, v in pairs(talentIdArray) do
			-- _crint (talentIdArray[i])
			local talentMould = dms.element(dms["talent_mould"], talentIdArray[i])
			if (talentMould ~= nil) then
				local addStr = dms.string(dms["talent_mould"], talentIdArray[i], talent_mould.base_additional)
				ship:addPropertyByInfluenceValue(addStr)
				--_crint(addStr)
				table.insert(ship.talentMouldList, talentMould)
			end			
		end
		
	end
end

