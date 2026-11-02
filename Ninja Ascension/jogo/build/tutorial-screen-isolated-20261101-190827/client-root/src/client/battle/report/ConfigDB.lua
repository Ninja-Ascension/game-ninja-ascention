app.load("client.battle.report.Npc")
app.load("client.battle.report.SkillMould")
app.load("client.battle.report.ShipMould")
app.load("client.battle.report.EquipmentMould")
app.load("client.battle.report.EnvironmentFormation")
app.load("client.battle.report.EnvironmentShip")
app.load("client.battle.report.SkillInfluence")
app.load("client.battle.report.RestrainMould")
app.load("client.battle.report.TalentMould")
app.load("client.battle.report.ClassInit")

ConfigDB = {}


ConfigDB.newObj = function(db_name)

	if (db_name == 'skill_mould') then
		return SkillMould:new()
	end
	
	if (db_name == 'ship_mould') then
		return ShipMould:new()
	end
	
	if (db_name == 'equipment_mould') then
		return EquipmentMould:new()
	end
	
	if (db_name == 'environment_formation') then
		return EnvironmentFormation:new()
	end
	
	if (db_name == 'environment_ship') then
		return EnvironmentShip:new()
	end
	
	if (db_name == 'skill_influence') then
		return SkillInfluence:new()
	end
	
	if (db_name == 'talent_mould') then
		return TalentMould:new()
	end
	
	if (db_name == 'restrain_mould') then
		return RestrainMould:new()
	end
	
	if (db_name == 'npc') then
		return Npc:new()
	end

	return nil
end

ConfigDB.load = function(db_name, idx)
	----_crint(db_name, idx)
	local obj = ConfigDB.newObj(db_name)
	if (obj ~= nil) then
		local rowString = dms.element(dms[db_name], idx)
		if (type(rowString) ~= "table") then
			-- _crint (db_name .. " Idx: " .. idx .. ", " .. rowString)
		else
			-- _crint_lua_table(rowString)
		end
		--rowString = table.concat(rowString, "\t")
		----_crint ("ConfigDB.load from dms" )
		----_crint(rowString)
		obj:init(rowString)		
	end
	
	return obj
end

--ConfigDB.getClassName