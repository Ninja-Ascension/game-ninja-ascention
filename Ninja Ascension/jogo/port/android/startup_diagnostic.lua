-- Embedded before cocos.init so failures before app.create are visible too.
local boot={stage='cocos.init',build='Android diagnostic 20261027-2'}
rawset(_G,'__nr_android_boot',boot)
local originalRequire=require
function require(name)
    local previous=boot.stage
    boot.stage='require '..tostring(name)
    local ok,result=pcall(originalRequire,name)
    if not ok then error(result,0) end
    boot.stage=previous
    return result
end
function boot.report(message)
    local text=boot.build..'\nEtapa: '..boot.stage..'\n'..tostring(message)..'\n'..debug.traceback()
    print(text)
    pcall(function()
        local file=io.open(cc.FileUtils:getInstance():getWritablePath()..'nr-mobile-startup.log','a')
        if file then file:write(text..'\n');file:close() end
    end)
    -- Keep diagnostics independent of the game's framework and asset loading.
    local ok,err=pcall(function()
        local director=cc.Director:getInstance()
        local size=director:getWinSize()
        local scene=cc.Scene:create()
        local label=cc.Label:createWithSystemFont(text,'Arial',18)
        label:setDimensions(math.max(size.width-40,200),math.max(size.height-40,200))
        label:setAnchorPoint({x=0,y=1})
        label:setPosition(20,size.height-20)
        scene:addChild(label,99999)
        if director:getRunningScene() then director:replaceScene(scene) else director:runWithScene(scene) end
    end)
    if not ok then print('NR diagnostic display: '..tostring(err)) end
    return message
end
