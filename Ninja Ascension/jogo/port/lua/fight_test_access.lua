-- Reversible PC-only menu access for the user's requested Fight tests.
-- Original server requests, event calendars and combat rules are unchanged.
local M={}
local path=debug.getinfo(1,'S').source:gsub('^@',''):gsub('\\','/')
path=path:gsub('/lua/[^/]+$','/resources/fight_test_access.json')
local config={}
local file=io.open(path,'r')
if file then
    local text=file:read('*a');file:close()
    config=json.decode(text) or {}
end
function M.enabled(feature)
    if not cc or type(cc.nrSpineCommand)~='function' or config.enabled~=true then return false end
    for _,id in ipairs(config.features or {}) do if tonumber(feature)==id then return true end end
    return false
end
return M
