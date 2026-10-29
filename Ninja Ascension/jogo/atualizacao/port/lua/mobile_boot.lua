-- mobile_boot.lua - Android part of the port boot (required by
-- assets/src/port_mobile.lua). Lives in port/lua so it is delivered by the
-- in-game update, not only by a new APK.
local fu = cc.FileUtils:getInstance()
local W = fu:getWritablePath() .. "nr_update/"
fu:addSearchPath(W .. "res/", true)

local function log(text)
    print("NR_MOBILE " .. text)
    local f = io.open(fu:getWritablePath() .. "nr-mobile-startup.log", "a")
    if f then f:write(text .. "\n"); f:close() end
end

local function step(name, fn)
    local ok, err = xpcall(fn, debug.traceback)
    log(name .. " " .. (ok and "OK" or ("FALHOU: " .. tostring(err))))
    return ok
end

local function readJson(file)
    local text = fu:isFileExist(file) and fu:getStringFromFile(file) or ""
    if text == "" then return {} end
    local ok, data = pcall(json.decode, text)
    return ok and type(data) == "table" and data or {}
end

-- server path -> path inside the game (nil = not for the phone)
local function localPath(path)
    local p = path:match("^01_conteudo_apk/assets/(src/.+%.lua)$")
    if p == "src/main.lua" then return nil end
    if p then return p end
    p = path:match("^port/lua/(.+%.lua)$")
    if p then return "src/port/lua/" .. p end
    if path == "port/gameplay.json" then return "src/port/gameplay.json" end
    p = path:match("^01_conteudo_apk/assets/(res/.+)$")
    if p and not p:match("%.lua$") then return p end
    return nil
end

local function get(url, binary, done)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = binary and cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER or cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr.timeout = 20
    xhr:open("GET", url)
    xhr:registerScriptHandler(function()
        local r = xhr.status == 200 and xhr.response or nil
        if r and type(r) == "table" then
            local parts = {}
            for i = 1, #r, 4096 do parts[#parts + 1] = string.char(unpack(r, i, math.min(i + 4095, #r))) end
            r = table.concat(parts)
        end
        done(r)
    end)
    xhr:send()
end

-- Downloads everything new, then calls finished(list of changed lua modules).
local function update(finished, state)
    local base = tostring(app.configJson.url or ""):gsub("/iniServer.*$", "")
    if base == "" then return finished({}) end
    local known = readJson("src/nr_versions.json")
    for k, v in pairs(readJson(W .. "versions.json")) do known[k] = v end
    for k, v in pairs(readJson(W .. "res_versions.json")) do known[k] = v end
    get(base .. "/atualizacao/manifesto.json", false, function(body)
        local ok, m = pcall(json.decode, body or "")
        if not ok or type(m) ~= "table" or type(m.arquivos) ~= "table" then
            log("atualizacao: lista indisponivel"); return finished({})
        end
        local queue, changed = {}, {}
        for _, f in ipairs(m.arquivos) do
            local lp = f.caminho and localPath(f.caminho)
            if lp and known[f.caminho] ~= f.sha256 then queue[#queue + 1] = {f, lp} end
        end
        log("atualizacao: " .. #queue .. " arquivo(s) novo(s)")
        if state then state.n = #queue end
        local i = 0
        local function nextFile()
            i = i + 1
            if state then state.i = i - 1 end
            local item = queue[i]
            if not item then
                local out = io.open(W .. "versions.json", "wb")
                if out then out:write(json.encode(known)); out:close() end
                out = io.open(W .. "res_versions.json", "wb")
                if out then out:write(json.encode(known)); out:close() end
                return finished(changed)
            end
            local f, lp = item[1], item[2]
            get(base .. "/atualizacao/arquivos/" .. f.caminho, lp:sub(1, 4) == "res/", function(data)
                if data and #data == tonumber(f.tamanho or #data) then
                    fu:createDirectory(W .. lp:match("^(.*)/[^/]+$") .. "/")
                    local out = io.open(W .. lp, "wb")
                    if out then
                        out:write(data); out:close(); known[f.caminho] = f.sha256
                        local mod = lp:match("^src/port/lua/(.+)%.lua$") or lp:match("^src/(.+)%.lua$")
                        if mod then changed[#changed + 1] = mod end
                    end
                else
                    log("atualizacao: falhou " .. f.caminho)
                end
                nextFile()
            end)
        end
        nextFile()
    end)
end

local function bootSteps()
    step("gameplay_config", function() require("tutorial_disabled").install() end)
    step("session_url", function() require("session_url").arm() end)
    step("instalar_adaptacoes", function() require("instalar_adaptacoes").armar() end)
    step("battle_lifecycle", function() require("battle_lifecycle").armar() end)
    -- Same city bars (collapse arrows) and pt-BR texts as the PC client.
    step("desktop_layout", function() require("desktop_layout").install() end)
    -- Auto-login: a late search_user_platform reply must not reopen the account
    -- window after the saved-token login already succeeded (same as PC).
    step("login_automatico", function() require("account_ui").guardaLoginAutomatico() end)
end

-- The update runs during the original "checking for updates" screen
-- (AssetsVerify), which shows the loading bar until it finishes (max 25 s).
bootSteps()
local state = {done = false, i = 0, n = 0, changed = {}}

local function applyChanged()
    -- Client screens already loaded are reloaded so they are used now; the
    -- port modules running since boot are replaced the next time.
    for _, mod in ipairs(state.changed) do
        local dotted = mod:gsub("/", ".")
        if dotted:sub(1, 7) == "client." and package.loaded[dotted] then
            package.loaded[dotted] = nil
            app.preload[dotted] = nil
            pcall(require, dotted)
            app.preload[dotted] = dotted
        end
    end
    fu:purgeCachedEntries()
end

local function finish(changed)
    if state.done then return end
    state.done = true
    state.changed = changed or {}
    step("atualizacao_aplicar", applyChanged)
end

local sched = cc.Director:getInstance():getScheduler()
local timer
timer = sched:scheduleScriptFunc(function()
    sched:unscheduleScriptEntry(timer)
    if not state.done then log("atualizacao: tempo esgotado, abrindo o jogo") end
    finish({})
end, 25, false)

local ok, err = pcall(update, function(changed)
    sched:unscheduleScriptEntry(timer)
    finish(changed)
end, state)
if not ok then log("atualizacao: " .. tostring(err)); finish({}) end

local function patchVerify()
    if not AssetsVerify or AssetsVerify.__nrPatched then return end
    AssetsVerify.__nrPatched = true
    local original = AssetsVerify.onEnterTransitionFinish
    AssetsVerify.onEnterTransitionFinish = function(self, ...)
        if state.done then return original(self, ...) end
        local args = {...}
        local okUi, node = pcall(csb.createNode, "utils/update_loading.csb")
        local bar, info
        if okUi and node then
            self:addChild(node)
            local root = node:getChildByName("root")
            bar = root and ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
            info = root and ccui.Helper:seekWidgetByName(root, "Text_10")
            if bar then bar:setPercent(0) end
        end
        local tick
        tick = sched:scheduleScriptFunc(function()
            local pct = state.n > 0 and math.floor(state.i * 100 / state.n) or 0
            if bar and not tolua.isnull(bar) then bar:setPercent(pct) end
            if info and not tolua.isnull(info) then
                info:setString(state.n > 0 and string.format("Atualizando %d/%d", state.i, state.n) or "Verificando atualizacao...")
            end
            if state.done then
                sched:unscheduleScriptEntry(tick)
                if node and not tolua.isnull(node) then node:removeFromParent() end
                if not tolua.isnull(self) then original(self, unpack(args)) end
            end
        end, 0.1, false)
    end
end

local originalLoad = app.load
app.load = function(path, ...)
    local r = originalLoad(path, ...)
    if path == "client.assets.AssetsVerify" then pcall(patchVerify) end
    return r
end
