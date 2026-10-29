-- Use the recovered final mission command; never advance by elapsed time.
local M={}
function M.install()
    if not state_machine or type(state_machine.excute)~='function'
        or package.__nr_intro_menu then return end
    package.__nr_intro_menu=true
    local execute=state_machine.excute
    state_machine.excute=function(name,...)
        if name=='menu_window_open_mission' and require('tutorial_tap_wait').isIntroBattle()
            and fwin:find('FightSceneClass') then
            -- The recovered mission emits this command without loading Menu.
            -- Register its module-level terminals before retiring the arena.
            app.load('client.home.Menu')
            assert(state_machine.find(name),'Final tutorial menu command was not registered')
            -- Menu.new skips its constructor if an old MenuClass is still
            -- registered. Retire that peer before the original command opens it.
            local previous=fwin:find('MenuClass')
            if previous then fwin:close(previous) end
            for _,key in ipairs({'_background','_view','_viewdialog','_ui'}) do
                if fwin[key] then fwin:cleanView(fwin[key]) end
            end
            local file=io.open(cc.FileUtils:getInstance():getWritablePath()..'intro-menu.log','a')
            if file then file:write(os.date('%H:%M:%S')..' final mission command: battle layers closed; opening original menu/tutorial\n');file:close() end
        end
        if name~='menu_window_open_mission' then return execute(name,...) end
        local args={...}
        local result={xpcall(function() return execute(name,unpack(args)) end,debug.traceback)}
        if not result[1] then
            local file=io.open(cc.FileUtils:getInstance():getWritablePath()..'intro-menu.log','a')
            if file then file:write(os.date('%H:%M:%S')..' OPEN FAILED '..tostring(result[2])..'\n');file:close() end
            error(result[2],0)
        end
        if name=='menu_window_open_mission' then
            local menu=fwin:find('MenuClass')
            local file=io.open(cc.FileUtils:getInstance():getWritablePath()..'intro-menu.log','a')
            if file then
                file:write(os.date('%H:%M:%S')..' original command returned; MenuClass='
                    ..tostring(menu~=nil)..'\n');file:close()
            end
        end
        return unpack(result,2)
    end
end
return M
