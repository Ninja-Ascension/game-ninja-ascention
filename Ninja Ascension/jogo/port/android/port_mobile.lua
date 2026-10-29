-- port_mobile.lua - Android boot of the port (packed as assets/src/port_mobile.lua;
-- main.lua requires it right after app.create()).
-- 1) Updated scripts live in <writable>/nr_update/ (same layout as the APK
--    assets: src/..., src/port/lua/...). They come first in the search paths,
--    so they win over the copies inside the APK.
-- 2) The update list of the server (/atualizacao/manifesto.json, the same one
--    the PC launcher uses) is checked in the background; changed scripts are
--    downloaded one by one. Screens loaded later already use the new files;
--    scripts already running are replaced the next time the game opens.
-- 3) The rest of the boot is port/lua/mobile_boot.lua, itself updatable.
local fu = cc.FileUtils:getInstance()
local W = fu:getWritablePath() .. "nr_update/"
fu:addSearchPath("src/port/lua")
fu:addSearchPath(W .. "src/port/lua", true)
fu:addSearchPath(W, true)

local function log(text)
    print("NR_MOBILE " .. text)
    local f = io.open(fu:getWritablePath() .. "nr-mobile-startup.log", "a")
    if f then f:write(text .. "\n"); f:close() end
end

-- server path -> path inside the game (nil = not a script for the phone)
local function localPath(path)
    local p = path:match("^01_conteudo_apk/assets/(src/.+%.lua)$")
    if p == "src/main.lua" then return nil end      -- the APK main.lua boots the port
    if p then return p end
    p = path:match("^port/lua/(.+%.lua)$")
    if p then return "src/port/lua/" .. p end
    if path == "port/gameplay.json" then return "src/port/gameplay.json" end
    return nil
end

local function readJson(file)
    local text = fu:isFileExist(file) and fu:getStringFromFile(file) or ""
    if text == "" then return {} end
    local ok, data = pcall(json.decode, text)
    return ok and type(data) == "table" and data or {}
end

local function update()
    local base = tostring(app.configJson.url or ""):gsub("/iniServer.*$", "")
    if base == "" then return end
    local known = readJson("src/nr_versions.json")             -- what the APK carries
    for k, v in pairs(readJson(W .. "versions.json")) do known[k] = v end
    local function get(url, done)
        local xhr = cc.XMLHttpRequest:new()
        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
        xhr:open("GET", url)
        xhr:registerScriptHandler(function()
            done(xhr.status == 200 and xhr.response or nil)
        end)
        xhr:send()
    end
    get(base .. "/atualizacao/manifesto.json", function(body)
        local ok, manifest = pcall(json.decode, body or "")
        if not ok or type(manifest) ~= "table" or type(manifest.arquivos) ~= "table" then
            log("atualizacao: lista indisponivel"); return
        end
        local queue = {}
        for _, f in ipairs(manifest.arquivos) do
            local lp = f.caminho and localPath(f.caminho)
            if lp and known[f.caminho] ~= f.sha256 then queue[#queue + 1] = {f, lp} end
        end
        log("atualizacao: " .. #queue .. " arquivo(s) novo(s)")
        local i = 0
        local function nextFile()
            i = i + 1
            local item = queue[i]
            if not item then
                local out = io.open(W .. "versions.json", "wb")
                if out then out:write(json.encode(known)); out:close() end
                return
            end
            local f, lp = item[1], item[2]
            get(base .. "/atualizacao/arquivos/" .. f.caminho, function(data)
                if data and #data == tonumber(f.tamanho or #data) then
                    fu:createDirectory(W .. lp:match("^(.*)/[^/]+$") .. "/")
                    local out = io.open(W .. lp, "wb")
                    if out then out:write(data); out:close(); known[f.caminho] = f.sha256 end
                else
                    log("atualizacao: falhou " .. f.caminho)
                end
                nextFile()
            end)
        end
        nextFile()
    end)
end

local ok, err = pcall(update)
if not ok then log("atualizacao: " .. tostring(err)) end

local okBoot, errBoot = xpcall(function() require("mobile_boot") end, debug.traceback)
log("mobile_boot " .. (okBoot and "OK" or tostring(errBoot)))
if not okBoot then error(errBoot) end
