-- Patch only the unsafe expression in the recovered method, in memory.
-- Keep the shipped Lua file and all other menu/mission behavior unchanged.
local M={}
function M.install(class)
    if type(class)~='table' or class.__nr_energy_clock then return end
    local original=class.onUpdate
    if type(original)~='function' then return end
    local path=debug.getinfo(original,'S').source
    if path:sub(1,1)~='@' then return end
    local file=assert(io.open(path:sub(2),'rb'))
    local source=file:read('*a');file:close()
    local first=assert(source:find('function Menu:onUpdate(dt)',1,true))
    local last=assert(source:find('function Menu:onExit',first+1,true))
    local method=source:sub(first,last-1)
    local unsafe='_ED._next_energy_recover_time/1000'
    local at=assert(method:find(unsafe,1,true),'Menu energy expression changed')
    method=method:sub(1,at-1)..'(tonumber(_ED._next_energy_recover_time) or math.huge)/1000'
        ..method:sub(at+#unsafe)
    local chunk=assert(loadstring(method,'@port/menu_energy_compat:onUpdate'))
    setfenv(chunk,getfenv(original));chunk()
    class.__nr_energy_clock=true
end
return M
