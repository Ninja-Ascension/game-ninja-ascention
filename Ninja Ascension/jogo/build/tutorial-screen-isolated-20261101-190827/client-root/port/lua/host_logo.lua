-- host_logo.lua — M2 milestone: put the ORIGINAL window system in charge of a
-- live scene. Requires the boot-map state (NR_PROBE_BOOT_MAP=1 runs first).
-- The fwin frame created inside app.init() died together with the dormant
-- boot scene when the probe replaced it, so this milestone rebuilds the frame
-- fresh (original fwin:create + graphics), takes over the running scene and
-- re-runs the ORIGINAL launcher terminal (client.launch) against live windows.
-- Adapter/analysis tooling only: original content untouched.
local ok, err = xpcall(function()
    assert(type(fwin) == 'table', 'fwin missing: run with NR_PROBE_BOOT_MAP=1 before host mode')
    assert(type(state_machine) == 'table', 'state machine missing')
    print('HOST_LOGO_BEFORE', type(fwin) == 'table' and fwin.find ~= nil and fwin:find('LogoClass') ~= nil)

    -- 1) fresh original frame (original fwin:init body runs inside)
    fwin:create()
    -- 2) original scene: replaces the probe scene and hosts every container
    fwin:graphics(nil)
    local scene = cc.Director:getInstance():getRunningScene()
    assert(scene ~= nil, 'no running scene after fwin:graphics')
    if os.getenv('NR_PROBE_MENU_TEST')=='1' then
        require('menu_boot_probe')
        return
    end
    print('HOST_LOGO_SCENE_IS_FWIN', scene == fwin._scene)

    -- 3) The original launcher terminal opens the window returned by
    --    app.load("client.login.logo") — but that module cache holds the
    --    instance that died together with the pre-host frame (tolua object
    --    released when the probe scene replaced the boot scene). Rebuild the
    --    window the same way the module did (logo.lua:613 — Logo:new()) and
    --    use the ORIGINAL open call from client/launch.lua against live windows.
    local LogoClass = Logo
    assert(type(LogoClass) == 'table' and type(LogoClass.new) == 'function',
        'Logo class missing: run with NR_PROBE_BOOT_MAP=1 before host mode')
    -- Loud ctor: fwin:open may swallow init errors (release-style). Build the
    -- window under xpcall first so the FIRST blocker of the original chain
    -- surface verbatim in the log.
    local logoInstance, ctorErr = nil, nil
    local okCtor, errCtor = xpcall(function()
        logoInstance = LogoClass:new()
    end, debug.traceback)
    if not okCtor then
        print('HOST_LOGO_CTOR_FAILED ' .. tostring(errCtor))
        error('Logo ctor failed: ' .. tostring(errCtor))
    end
    local okOpen, errOpen = xpcall(function()
        fwin:open(logoInstance, fwin._screen)
    end, debug.traceback)
    if not okOpen then
        print('HOST_LOGO_OPEN_FAILED ' .. tostring(errOpen))
        error('Logo open failed: ' .. tostring(errOpen))
    end

    local logoWin = fwin:find('LogoClass')
    assert(logoWin ~= nil, 'logo window missing after open')
    print('HOST_LOGO_INSTANCE_TYPE', type(logoWin))
    local screen = fwin._screen
    assert(screen ~= nil and screen._layer ~= nil, 'fwin._screen container missing')
    print('HOST_LOGO_ATTACHED', logoWin:getParent() ~= nil,
        'screen_children', screen._layer:getChildrenCount())
    return true
end, debug.traceback)

print('HOST_LOGO_RESULT', ok, err)
do
    local path=cc.FileUtils:getInstance():getWritablePath()..'host-logo.log'
    local log=io.open(path,'w')
    if log then log:write('ok='..tostring(ok)..'\n'..tostring(err));log:close() end
end
if ok and os.getenv('NR_PROBE_TIP_LIFETIME')=='1' then
    local scheduler=cc.Director:getInstance():getScheduler()
    local count,id=0,nil
    id=scheduler:scheduleScriptFunc(function()
        count=count+1
        TipDlg.drawTextDailog('Disponivel no nivel 15')
        local log=assert(io.open(cc.FileUtils:getInstance():getWritablePath()..'tip-lifetime.log','a'))
        log:write('TIP_LIFETIME_OPEN '..count..'\n');log:close()
        if count==3 then scheduler:unscheduleScriptEntry(id) end
    end,1,false)
end
if ok and os.getenv('NR_PROBE_HOME_BASE')=='1' then
    local scheduler=cc.Director:getInstance():getScheduler()
    local id
    id=scheduler:scheduleScriptFunc(function()
        scheduler:unscheduleScriptEntry(id)
        local panel=cc.Node:create();panel:setContentSize(cc.size(200,200));panel:setPosition(380,180)
        fwin._scene:addChild(panel,10000)
        local effect=require('home_hero_base_effect');effect.add(panel);effect.add(panel)
        assert(panel:getChildrenCount()==1,'Duplicate home base effect')
        local file=assert(io.open(cc.FileUtils:getInstance():getWritablePath()..'home-base-test.txt','w'))
        file:write('HOME_BASE_NATIVE_PASSED');file:close()
    end,1,false)
end
return ok and 1 or 0
