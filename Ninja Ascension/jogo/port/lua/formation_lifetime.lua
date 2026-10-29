-- The recovered module caches a native window in a closure. Scene teardown
-- can destroy that node while the Lua reference remains non-nil.
local M={}
function M.install()
    local terminal=state_machine and state_machine._terminals.formation_open_instance_window
    if not terminal or terminal.__nr_lifetime then return end
    local invoke=terminal._invoke
    local index
    for i=1,100 do
        local name=debug.getupvalue(invoke,i)
        if not name then break end
        if name=='g_formationTigerGate' then index=i;break end
    end
    assert(index,'Formation window cache upvalue missing')
    terminal.__nr_lifetime=true
    terminal._invoke=function(...)
        local _,cached=debug.getupvalue(invoke,index)
        if cached and tolua.isnull(cached) then
            debug.setupvalue(invoke,index,nil)
            print('HOST_FORMATION_LIFETIME discarded destroyed window cache')
        end
        return invoke(...)
    end
end
return M
