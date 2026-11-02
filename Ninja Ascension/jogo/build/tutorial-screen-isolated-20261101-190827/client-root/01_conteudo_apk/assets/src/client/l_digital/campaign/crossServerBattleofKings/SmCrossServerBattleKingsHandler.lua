--[[
    author:Rock
    time:2019-10-09 09:42:49
]]

SmCrossServerBattleKingsHandler = SmCrossServerBattleKingsHandler or {}

function SmCrossServerBattleKingsHandler.getServerName(serverNum)
    -- local len = tonumber(string.len(serverNum))
    -- local serverName = "S" .. string.sub( serverNum, len - 2, len )
    return GetServerNameByServerNumber(serverNum)
end