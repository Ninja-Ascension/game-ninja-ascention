app = app or {}

-- cclog
cclog = function(...)
    print(string.format(...))
end

if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
function cc.dms_load( filePath )
    return cc.FileUtils:getInstance():getStringFromFile(filePath)
end
end

function app.addSearchPaths(configJson, storagePath, writablePath, searchPaths)
    for i, v in ipairs(configJson.searchPaths) do
        table.insert(searchPaths, 1, v)
    end

    for i, v in ipairs(configJson.searchPaths) do
        table.insert(searchPaths, 1, storagePath .. v)
    end

    for i, v in ipairs(configJson.searchPaths) do
        table.insert(searchPaths, 1, writablePath .. v)
    end
    -- app.searchPaths predates port_mobile. Language selection rebuilds the
    -- list from that snapshot, so retain the APK's late-loaded port modules.
    if cc.Application:getInstance():getTargetPlatform()==cc.PLATFORM_OS_ANDROID then
        table.insert(searchPaths,1,'src/port/lua')
    end
end

function app.setSearchPaths(_language)
    local configJson = app.configJson
    local version = configJson.version
    local writablePath = cc.FileUtils:getInstance():getWritablePath()
    local storagePath = writablePath .. version .. "/"
	
    if configJson.MultiLanguage == nil or configJson.MultiLanguage[_language] == nil then
        return false
    end
    
    local fileUtils = cc.FileUtils:getInstance()
    local searchPaths = {}
    for i, v in pairs(app.searchPaths) do
        table.insert(searchPaths, v)
    end
    app.addSearchPaths(configJson.MultiLanguage[_language], storagePath, writablePath, searchPaths)

    fileUtils:setSearchPaths(searchPaths)
    return true
end

function app.init()
    -- Initailize app frameworks lua packages.
    app.preload = app.preload or {}

    -- Initailize app config.
    local configData, len = cc.dms_load("configs/app.config") -- cc.FileUtils:getInstance():getStringFromFile("configs/app.config")
    if len ~= nil and len > 0 then
        configData = string.sub(configData, 1, len)
    end
    --    cc.ASSERT(str != NULL, "Unable to open file")
    if (configData == nil) then
        cclog("Unable to open file")
    end
    if configData == nil or configData == "" then
        configData = [[{
            "version" : "1.417",
            "fps" : true,
            "debug" : true,
            "array" : {"array":[1,1,1]},
            "frameSize" : {"width" : 640, "height" : 960},
            "winSize" : {"width" : 640, "height" : 960},
            "designSize" : {"width" : 640, "height" : 960},
            "resourceSize" : {"width" : 640, "height" : 960},
            "ResolutionPolicy" : "SHOW_ALL",
            "searchPaths" : [
                "res",
                "src",
                "src/frameworks/external",
                "src/frameworks/external/aeslua",
                "src/config"
                ]
        }]]
    end
	
    require("cocos.cocos2d.json")
    local configJson = json.decode(configData)
    local version = configJson.version
    local showFPS = configJson.showFPS
    local fps = tonumber(configJson.fps or 25) or 25
    local debugIsOpen = configJson.debug
	local frameSize = cc.size(configJson.frameSize.width, configJson.frameSize.height)
    local winSize = cc.size(configJson.winSize.width, configJson.winSize.height)
    local designSize = cc.size(configJson.designSize.width, configJson.designSize.height)
    local resourceSize = cc.size(configJson.resourceSize.width, configJson.resourceSize.height)
    local ResolutionPolicy = configJson.ResolutionPolicy

    local storagePath = cc.FileUtils:getInstance():getWritablePath() .. version .. "/"
    
    -- Initailize app seach paths.
    local fileUtils = cc.FileUtils:getInstance()
    local searchPaths = fileUtils:getSearchPaths()
    for i, v in ipairs(configJson.searchPaths) do
        table.insert(searchPaths, 1, v)
    end
    for i, v in ipairs(configJson.searchPaths) do
        table.insert(searchPaths, 1, storagePath .. v)
    end
    fileUtils:setSearchPaths(searchPaths)

    if true then
        configData, len = cc.dms_load("configs/app.config") -- cc.FileUtils:getInstance():getStringFromFile("configs/app.config")
        if len ~= nil and len > 0 then
            configData = string.sub(configData, 1, len)
        end
        configJson = json.decode(configData)
        version = configJson.version
        showFPS = configJson.showFPS
        fps = tonumber(configJson.fps or 25) or 25
        debugIsOpen = configJson.debug
		frameSize = cc.size(configJson.frameSize.width, configJson.frameSize.height)
        winSize = cc.size(configJson.winSize.width, configJson.winSize.height)
        designSize = cc.size(configJson.designSize.width, configJson.designSize.height)
        resourceSize = cc.size(configJson.resourceSize.width, configJson.resourceSize.height)
        ResolutionPolicy = configJson.ResolutionPolicy

        storagePath = cc.FileUtils:getInstance():getWritablePath() .. version .. "/"
        
        -- Initailize app seach paths.
        fileUtils = cc.FileUtils:getInstance()
        searchPaths = {} -- fileUtils:getSearchPaths()
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        if cc.PLATFORM_OS_WINDOWS == targetPlatform
            or cc.PLATFORM_OS_MAC == targetPlatform
            then
            -- ...
        else
            table.insert(searchPaths, 1, "res")
            table.insert(searchPaths, 1, "src")
        end

        if nil ~= configJson.patch_path then
            app.patch_path = configJson.patch_path
        else
            app.patch_path = cc.FileUtils:getInstance():getWritablePath() .. "patch/"
        end
        for i, v in ipairs(configJson.searchPaths) do
            table.insert(searchPaths, 1, app.patch_path .. v)
        end

        for i, v in ipairs(configJson.searchPaths) do
            table.insert(searchPaths, 1, v)
        end
        for i, v in ipairs(configJson.searchPaths) do
            table.insert(searchPaths, 1, storagePath .. v)
        end
        for i, v in ipairs(configJson.searchPaths) do
            table.insert(searchPaths, 1, cc.FileUtils:getInstance():getWritablePath() .. v)
        end
        fileUtils:setSearchPaths(searchPaths)
    end

    -- urls
    app.patch_url = configJson.patch_url
    app.assets_update_url = configJson.assets_update_url
    app.assets_version_url = configJson.assets_version_url
    app.assets_version_md5_url = configJson.assets_version_md5_url
    app.assets_local_md5 = configJson.assets_local_md5
    app.assets_version_md5 = configJson.assets_version_md5

    -- load aeslua file
    app.aeslua = app.load("frameworks.external.aeslua.aeslua")

    -- load blowfish file
    app.blowfish = app.load("frameworks.external.blowfish.blowfish")
    -- app.blowfish:setKey("cocos2d-x")
    app.blowfish:setKey("K(7a!ykjTD&DAp0!")

    -- load utils file
    app.utils = app.load("frameworks.external.utils.utils")

    -- utf8
    app.load("frameworks.external.utils.utf8")
    
    -- load audio file
    app.audio = app.load("frameworks.external.utils.AudioUtil")

    -- create texture cache path
    local textureCachePath = cc.FileUtils:getInstance():getWritablePath() .. "cache/texture"
    -- fileUtils:createDirectory(textureCachePath)
    app.dir_cache = cc.FileUtils:getInstance():getWritablePath() .. "cache/"
    app.dir_cache_md5 = app.dir_cache .. "md5/"

    -- create async thread pool
    if cc.JtsThreadHelper ~= nil and cc.JtsThreadHelper.create ~= nil then
        app.thread = cc.JtsThreadHelper:create()
        app.thread:retain()

        create_thread_func = function( ... )
            -- print("-=-=-==========", app.fileUtils)
            -- app.thread_co = coroutine.create(function ()
            --     local i = 1
            --     while true do
            --         print("co", i)
            --         i = i + 1
            --         -- coroutine.yield()
            --     end
            --     -- for i=1,10 do
            --     --     print("co", i)
            --     --     coroutine.yield()
            --     -- end
            -- end)
        end
    end

    -- initialize director
    local director = cc.Director:getInstance()
    local glView   = director:getOpenGLView()

    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
    cc.Image:setPVRImagesHavePremultipliedAlpha(true)

    -- UI
    if nil ~= ccui.ScrollView.setAutoScrollMaxSpeed then
        ccui.ScrollView:setAutoScrollMaxSpeed(2000)
    end

    --turn on display FPS
    director:setDisplayStats(showFPS or false)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / (fps or 25))
    
    if nil == glView then
        -- glView = cc.GLViewImpl:createWithRect("Cocos2d-x for lua", cc.rect(0,0,designSize.width, designSize.height))
        glView = cc.GLViewImpl:createWithRect("Cocos2d-x for lua", cc.rect(0, 0, frameSize.width, frameSize.height))
        director:setOpenGLView(glView)
    end

    -- set design resolution size
    -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(480, 320, 0)
    -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 960, cc.ResolutionPolicy.SHOW_ALL)
    -- cc.Director:getInstance():getOpenGLView():setFrameSize(320, 568)

    -- EXACT_FIT = 0,
    -- NO_BORDER = 1,
    -- SHOW_ALL  = 2,
    -- FIXED_HEIGHT  = 3,
    -- FIXED_WIDTH  = 4,

    -- if ResolutionPolicy == "SHOW_ALL" then
    --     cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(designSize.width, designSize.height, cc.ResolutionPolicy.SHOW_ALL)
    -- elseif ResolutionPolicy == "FIXED_HEIGHT" then
    --     cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(designSize.width, designSize.height, cc.ResolutionPolicy.FIXED_HEIGHT)
    -- end

    local screenSize = glView:getFrameSize()
    if winSize.width > winSize.height then
        if screenSize.width < screenSize.height then
            local sw = screenSize.height
            local sh = screenSize.width
            screenSize.width = sw
            screenSize.height = sh
            glView:setFrameSize(screenSize.width, screenSize.height)
            -- glView:setViewPortInPoints(0, 0, screenSize.width, screenSize.height)
        end
    end

    -- local scaleX = resourceSize.width/screenSize.width
    -- local scaleY = resourceSize.height/screenSize.height
    -- app.scaleFactor = scaleX > scaleY and scaleX or scaleY
    -- cc.Director:getInstance():setContentScaleFactor(app.scaleFactor)
    local scaleX = screenSize.width/winSize.width
    local scaleY = screenSize.height/winSize.height
    app.scaleFactor = scaleX < scaleY and scaleX or scaleY

    -- scaleX = screenSize.width / resourceSize.width;
    -- scaleY = screenSize.height / resourceSize.height;
    -- if scaleX < scaleY then
        -- director:setContentScaleFactor(resourceSize.width/designSize.width);
        -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(designSize.width, designSize.height, cc.ResolutionPolicy.FIXED_WIDTH);
    -- else
        -- director:etContentScaleFactor(resourceSize.height/designSize.height);
        -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(designSize.width, designSize.height, cc.ResolutionPolicy.FIXED_HEIGHT);
    -- end

    
    -- Initialize app params.
    app.fileUtils = fileUtils
    app.version = version
    app.storagePath = storagePath
    app.configJson = configJson
    app.searchPaths = searchPaths

    -- set cocos variable
    app.scheduler = cc.Director:getInstance():getScheduler()
    app.ResolutionPolicy = ResolutionPolicy
    
    -- designSize = cc.size(designSize.width/app.scaleFactor, designSize.height/app.scaleFactor)
    -- designSize = cc.size(designSize.width * app.scaleFactor, designSize.height  * app.scaleFactor)
    app.winSize = cc.size(winSize.width * app.scaleFactor, winSize.height  * app.scaleFactor)
    -- if ResolutionPolicy == "SHOW_ALL" then
    --     designSize = cc.size(designSize.width * app.scaleFactor, designSize.height  * app.scaleFactor)
    -- end
    app.screenSize = screenSize
    app.resourceSize = resourceSize
    app.designSize = designSize
	
	app.baseOffsetX = app.resourceSize.width - app.screenSize.width / app.scaleFactor
    app.baseOffsetY = app.resourceSize.height - app.screenSize.height / app.scaleFactor
 
    -- initialize support libs
    app.debug = app.load("frameworks.support.init") 
    app.debug = app.load("frameworks.support.debug") 
    app.debug._isOpen = debugIsOpen

    configJson.log = configJson.log or {
        log = false,
        info = false,
        debug = false,
        warning = false,
        assert = false,
    }

    app.debug._config = configJson.log
    
    app.load("frameworks.support.cocostudio") 
    
    app.load("frameworks.external.utils.local_datas")
    app.load("frameworks.external.utils.module_datas")
    app.load("frameworks.external.utils.utils")
    app.load("frameworks.external.utils.string")

    app.load("frameworks.network.NetworkAdaptor")
    app.load("frameworks.network.NetworkManager")
    app.load("frameworks.network.NetworkProtocol")
    app.load("frameworks.network.NetworkView")
    NetworkAdaptor.init()

    -- load lua_bridge moudle
    app.lua_bridge = app.load("frameworks.support.lua_bridge")

    -- load app state machine moudle
    app.state_machine = app.load("frameworks.support.state_machine")

    -- load app notification center moudle
    app.notification_center = app.load("frameworks.support.notification_center")
    
    -- load windows module
    app.load("frameworks.windows.fwin")
    app.load("frameworks.windows.window")
    fwin:graphics(nil)

    if debugIsOpen == true then
        app.debug.view = app.load("frameworks.windows.display_log")
        app.debug.view:retain()
    end
	fwin:reset(nil)

    app.debug.log(true, "The application initailize successed!")
    app.debug.log("local storage path:", ""..storagePath)
	
	if cc.UserDefault:getInstance():getStringForKey("version") ~= nil and
	   cc.UserDefault:getInstance():getStringForKey("version") ~= ""  and
	   cc.UserDefault:getInstance():getStringForKey("version") ~= " " then 
		if zstring.tonumber(cc.UserDefault:getInstance():getStringForKey("version")) < tonumber(app.version) then
			cc.UserDefault:getInstance():setStringForKey("package", "0")
			cc.UserDefault:getInstance():setStringForKey("package_rc", "0")
		end	
	end
	cc.UserDefault:getInstance():setStringForKey("version", app.version)
	cc.UserDefault:getInstance():flush()
end

function app.getTimeSpeed()
    local director = cc.Director:getInstance()
    local animationInterval = director:getAnimationInterval()
    return (1 / 60) / animationInterval
end

function app.getTimeSpeed2()
    local director = cc.Director:getInstance()
    local animationInterval = director:getAnimationInterval()
    return animationInterval / (1 / 60)
end

function app.create()
    if __G__TRACKBACK__ == nil then
        __G__TRACKBACK__ = function(msg)
            local errorFunc = "LUA Func\r\n"
            local errorLine = "0\r\n"
            local errorName = "LUA ERROR\r\n"
            local errorMsg = "LUA ERROR: " .. tostring(msg) .. "\r\n"
            local traceback = debug.traceback()
            local tbString = errorFunc..errorLine..errorName..errorMsg .. traceback
            if NetworkManager~=nil and protocol_command~= nil and protocol_command.record_crash.param_list ~= tbString then
                protocol_command.record_crash.param_list = tbString
                local request = NetworkManager:register(protocol_command.record_crash.code, nil, nil, nil, nil, nil, false, nil)
                NetworkAdaptor.send(request)
                -- handlePlatformRequest(0, COLLECT_CRASH_REPORT_TESTIN, msg.."|"..traceback)
                __sleep(1)
            end
            cclog("----------------------------------------")
            cclog("LUA ERROR: " .. tostring(msg) .. "\n")
            cclog(debug.traceback())
            cclog("----------------------------------------")
            -- debug.error(true, "----------------------------------------\r\n".."LUA ERROR: " .. tostring(msg) .. "\r\n"..debug.traceback().."\r\n----------------------------------------")
            return msg
        end

        local status, msg = xpcall(app.init, __G__TRACKBACK__)
        if not status then
            error(msg)
        end
    else
        app.init()
    end
end

function app.reset()
    app.unloadAll()
    app.init()
end

function app.unloadAll()
    for i, v in pairs(app.preload) do
    -- for i, v in pairs(app.loaded) do
        app.unload(i)
    end

    app.preload = {}
end

function app.unload(_luaFilePath)
    local parent = require(_luaFilePath) -- app.preload[_luaFilePath];
    if type(parent) == "table" then
        for k1,_ in pairs(parent) do
            parent[k1] = nil;
        end
    end

    package.preload[_luaFilePath] = nil
    package.loaded[_luaFilePath] = nil
    app.preload[_luaFilePath] = nil
    _G[_luaFilePath] = nil;
end

function app.reload(_luaFilePath)
    app.unload(_luaFilePath)
    return app.load(_luaFilePath)
end

function app.load(_luaFilePath)
    -- -- _luaFilePath = string.gsub(_luaFilePath, "%/", ".");
    -- -- print("_luaFilePath::::", _luaFilePath)
    -- -- app.preload[_luaFilePath] = app.preload[_luaFilePath] or require(_luaFilePath)
    -- local ret = require(_luaFilePath)
    -- app.preload[_luaFilePath] = _luaFilePath

    local ret = app.preload[_luaFilePath]
    if nil == ret then
        ret = require(_luaFilePath)
        app.preload[_luaFilePath] = _luaFilePath
    end
    return ret
end

function app.reload(nr)
    local need_reload_file = {}
    local unReloadModule = {["common.string"] = 1,["common.class"]=1,["common.event"]=1,["common.luadata"]=1,["libs.protobuf"]=1,["pb.protoList"]=1}
    for k,v in pairs(package.loaded) do
        --只有lua模块卸载
        -- local path = string.gsub(k, "%.", "/");
        -- path = cc.FileUtils:getInstance():fullPathForFilename(""..path..".lua");
        -- local file = io.open(path);
        -- if file then
        --     file:close();
            if unReloadModule[k]==nil then
                local s, e = string.find(k, "client")
                if s == nil or s <= 0 then
                    s, e = string.find(k, "data")
                end
                if s~= nil and s > 0 then
                    s, e = string.find(k, "operation")
                    if s~= nil and s > 0 then
                        
                    else
                        s, e = string.find(k, "launch")
                        if s~= nil and s > 0 then
                        else
                            -- local parent = require(k);
                            -- if type(parent) == "table" then
                            --     for k1,_ in pairs(parent) do
                            --         parent[k1] = nil;
                            --         -- print("k1", k1)
                            --     end
                            -- end

                            app.unload(k)
                            
                            app.preload[k] = nil
                            package.loaded[k] = nil;
                            _G[k] = nil;
                            -- print(k)
                            table.insert(need_reload_file, k)
                        end
                    end
                end
            end
        -- end
    end
    
    if nr then
        for i, v in pairs(need_reload_file) do
            app.load(v)
        end
    end

    -- xpcall(main, __G__TRACKBACK__)
end


return app
