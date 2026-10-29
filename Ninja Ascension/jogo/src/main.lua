
-- Add default search paths for game.
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

-- CC_USE_DEPRECATED_API = true
require "cocos.init"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- `printError` no lo define NADIE en esta build, y las cuatro guardas
-- «node must be a userdata» del framework (cocostudio.lua:268 y :313,
-- gray.lua:22 y :170) lo llaman. Como el `__index` de abajo revienta con
-- los globales que no existen, la guarda que deberia AVISAR tumbaba la
-- pantalla: la del Deck, al grisar el retrato de una carta sin imagen.
function printError(...)
    print("[error] " .. table.concat({...}, " "))
    print(debug.traceback("", 2))
end

function __sleep(n)
    if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS then 
        os.execute("sleep " .. n)
    end
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
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

-- Cierre anterior (tools/carcasa/CierreInforme.java, Android 11+): la carcasa
-- deja UNA linea en files/cierre_informe.txt. En cuanto hay usuario con sesion
-- (cualquier camino de login) se manda con C2S 89 record_crash y se borra.
-- Va aqui y no en login.lua porque login.lua viaja en las actualizaciones
-- y la copia descargada taparia la del APK.
local function enviarCierreInforme()
    local ruta = cc.FileUtils:getInstance():getWritablePath() .. "cierre_informe.txt"
    local f = io.open(ruta, "rb")
    if f == nil then return true end
    if NetworkManager == nil or NetworkAdaptor == nil or protocol_command == nil
        or _ED == nil or _ED.user_info == nil or _ED.user_info.user_id == nil
        or tostring(_ED.user_info.user_id) == "" or tostring(_ED.user_info.user_id) == "0" then
        f:close()
        return false
    end
    local texto = f:read("*a")
    f:close()
    os.remove(ruta)
    if texto == nil or texto == "" then return true end
    texto = string.gsub(string.sub(texto, 1, 3000), "[\r\n]", " ")
    protocol_command.record_crash.param_list = "CIERRE NATIVO\r\n" .. texto
    NetworkAdaptor.send(NetworkManager:register(protocol_command.record_crash.code, nil, nil, nil, nil, nil, false, nil))
    return true
end

local function vigilarCierreInforme()
    local scheduler = cc.Director:getInstance():getScheduler()
    local id
    id = scheduler:scheduleScriptFunc(function()
        local ok, hecho = pcall(enviarCierreInforme)
        if not ok or hecho then
            scheduler:unscheduleScriptEntry(id)
        end
    end, 15, false)
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    -- load frameworks moudle for create application.
    local _app = require("frameworks.app")
    _app.create()

    -- launch the game.
    app.load("client.launch")
    pcall(vigilarCierreInforme)

    local m_targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if m_targetPlatform == cc.PLATFORM_OS_MAC 
        or m_targetPlatform == cc.PLATFORM_OS_WINDOWS
        then
        -- local pvr = require("frameworks.support.pvr")
        -- pvr.converts("./../pvr")

        app.load("client.utils.ShadowUtil")
        if app.configJson.dumpPng then
            for i, v in pairs(app.configJson.dumpPng) do
                for n = 1, v.count do
                    local fileName = ""
                    for i=1, 18 do
                        local c = math.random(1, 9)
                        fileName = fileName .. c
                    end
                    ShadowUtil_saveToFile(v.path .. fileName .. ".png", math.random(1, v.width), math.random(1, v.height))
                end
            end
        end
    end
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
