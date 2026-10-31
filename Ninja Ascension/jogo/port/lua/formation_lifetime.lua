-- The recovered module caches a native window in a closure. Scene teardown
-- can destroy that node while the Lua reference remains non-nil.
local M={}
function M.install()
    local class=rawget(_G,'FormationTigerGate')
    if class and not class.__nr_cache_destroy_hook then
        class.__nr_cache_destroy_hook=true
        local destroy=class.destroy
        class.destroy=function(self,...)
            self.__nr_formation_closed=true
            if destroy then return destroy(self,...) end
        end
    end
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
        if type(equipmentIsCanEvolution)~='function' or type(equipmentIsCanAwake)~='function' then
            app.load('client.notification.push_notification_sm_hero_develop')
            assert(type(equipmentIsCanEvolution)=='function' and type(equipmentIsCanAwake)=='function','Formation equipment dependencies missing')
        end
        local _,cached=debug.getupvalue(invoke,index)
        local dead=cached and tolua.isnull(cached)
        if cached and (dead or cached.__nr_formation_closed or cached._isDeathed) then
            debug.setupvalue(invoke,index,nil)
            -- The original cache owns one retain. Closing cleans its native
            -- timelines/cells even while that retain keeps the window alive.
            -- Reusing it therefore passes isnull but can dereference freed
            -- children on the next drawHeadQueue. Release and rebuild instead.
            if not dead then cached:release() end
            cached=nil
            print('HOST_FORMATION_LIFETIME discarded closed window and child caches')
        end
        local result=invoke(...)
        if not cached then
            local _,created=debug.getupvalue(invoke,index)
            -- The original first branch constructs/retains but returns before
            -- fwin:open. Complete that same click using its ordinary open path.
            if created and fwin:find('FormationTigerGateClass')~=created then
                local args,count={...},select('#',...)
                fwin:addService({delay=0,callback=function()
                    local _,current=debug.getupvalue(invoke,index)
                    if current==created and not tolua.isnull(created) and not created.__nr_formation_closed then
                        invoke(unpack(args,1,count))
                    end
                end})
            end
        end
        return result
    end
end
return M
