-- ----------------------------------------------------------------------------
-- Fury: velocidades por VIP (docs/systems/pendientes_maestro.md, V1-V3,
-- 2026-09-23). Es el UNICO sitio con los niveles VIP y la velocidad del juego;
-- las velocidades de cada marcha de combate viven en `_fight_time_scale`
-- (res/data/TipStringInfo.lua y todas sus copias de idioma).
--
-- Combate (V2): marchas 1-3 (x1/x2/x3, se abren por fun_open_condition 36 y
-- 37); 4-6 (x4/x5/x6) por VIP. Desde el 3-oct-2026 cada marcha va un 10 % por
-- encima de fabrica (1.29 -> 1.42, 1.7 -> 1.87, 2.0 -> 2.2...).
-- Juego entero fuera del combate (V3): BASE_SCALE x1.1 para TODOS (3-oct-2026,
-- antes x1); x1.25 / x1.5 por VIP. La casilla 4 de Ajustes
-- (role_information_tab_2.csb, que venia oculta) apaga solo el extra VIP: con
-- ella apagada se vuelve a la base, no a x1.
-- ----------------------------------------------------------------------------
fury_game_speed = fury_game_speed or {}
local M = fury_game_speed

-- VIP minimo de cada marcha de combate (indice de _fight_time_scale).
M.FIGHT_VIP = { [4] = 3, [5] = 6, [6] = 10 }

-- Velocidad del juego fuera del combate, de MAYOR a menor VIP.
-- El x4 global de pruebas rompia Soldier Enhance (memoria
-- fury-client-test-patches): si una pantalla falla, se baja AQUI.
M.GAME_TIERS = { { vip = 8, scale = 1.5 }, { vip = 4, scale = 1.25 } }

-- Velocidad fuera del combate sin VIP (o con la casilla de Ajustes apagada).
-- No puede coincidir con ninguna marcha de _fight_time_scale ni con la camara
-- lenta 0.3: apply() las distingue por el valor.
M.BASE_SCALE = 1.1

M.KEY = "fury_game_speed"   -- UserDefault: "0" = apagado; cualquier otro = encendido

local EPS = 0.001

local function vip()
    return tonumber(_ED ~= nil and _ED.vip_grade or 0) or 0
end

function M.fight_index_allowed(index)
    local need = M.FIGHT_VIP[index]
    return need == nil or vip() >= need
end

-- Marcha siguiente al pulsar el boton estando en la 3 o mas. Si la siguiente
-- esta cerrada por VIP avisa (para que se vea que existe) y vuelve a x1.
function M.next_fight_index(index)
    local nextIndex = index + 1
    local need = M.FIGHT_VIP[nextIndex]
    if need == nil or _fight_time_scale == nil or _fight_time_scale[nextIndex] == nil then
        return 1
    end
    if vip() >= need then
        return nextIndex
    end
    if _fury_speed_text ~= nil and TipDlg ~= nil then
        TipDlg.drawTextDailog(string.format(_fury_speed_text[1], nextIndex, need))
    end
    return 1
end

-- Escala a la que tiene derecho el jugador (nil = ninguna).
function M.game_tier()
    local v = vip()
    for _, t in ipairs(M.GAME_TIERS) do
        if v >= t.vip then
            return t.scale
        end
    end
    return nil
end

function M.game_enabled()
    return cc.UserDefault:getInstance():getStringForKey(M.KEY) ~= "0"
end

function M.set_game_enabled(on)
    cc.UserDefault:getInstance():setStringForKey(M.KEY, on and "1" or "0")
    cc.UserDefault:getInstance():flush()
    M.apply()
end

-- La escala «normal» (fuera del combate): la VIP si tiene derecho y la casilla
-- esta encendida; si no, la base.
function M.normal_scale()
    local s = M.game_tier()
    if s == nil or not M.game_enabled() then
        return M.BASE_SCALE
    end
    return s
end

local function is_game_scale(s)
    if math.abs(s - M.BASE_SCALE) < EPS then
        return true
    end
    for _, t in ipairs(M.GAME_TIERS) do
        if math.abs(s - t.scale) < EPS then
            return true
        end
    end
    return false
end

local function in_fight_scale(s)
    if math.abs(s - 0.3) < EPS then
        return true   -- camara lenta del golpe final (FightRoleController.lua)
    end
    for _, v in ipairs(_fight_time_scale or {}) do
        if math.abs(s - v) < EPS then
            return true
        end
    end
    return false
end

-- El juego vuelve a la normalidad con setTimeScale(1) (Fight:fightEnd,
-- Fight:onExit, BattlePause:doExitBattle). Se intercepta SOLO ese 1: las
-- marchas del combate y la camara lenta pasan intactas. El original se guarda
-- en un global para no envolverlo dos veces si app.reload recarga el modulo.
if __fury_raw_set_time_scale == nil then
    __fury_raw_set_time_scale = cc.Scheduler.setTimeScale
    -- rawset, como hace el propio motor (DeprecatedCocos2dFunc.lua:42)
    rawset(cc.Scheduler, "setTimeScale", function(self, s)
        if s == 1 then
            s = M.normal_scale()
        end
        M.current = s
        return __fury_raw_set_time_scale(self, s)
    end)
end

-- dt en tiempo REAL para las ventanas (frameworks/windows/window.lua y
-- fwin.lua). Con la velocidad de juego puesta, el motor entrega el dt ya
-- multiplicado y las ~90 cuentas atras que restan dt (ofertas, eventos, chat,
-- arena...) correrian un 10-50 % rapido y pedirian al servidor antes de hora.
-- Solo se corrige la escala de JUEGO (base y VIP); las del combate no.
function M.real_dt(dt)
    local s = M.current
    if s ~= nil and s ~= 1 and is_game_scale(s) then
        return dt / s
    end
    return dt
end

-- Pone la escala normal salvo en pleno combate. Tambien deshace cualquier
-- escala ajena (p. ej. un main.lua viejo de pruebas dentro del APK).
function M.apply()
    local scheduler = cc.Director:getInstance():getScheduler()
    if in_fight_scale(scheduler:getTimeScale()) then
        return
    end
    scheduler:setTimeScale(1)
end

-- NO se devuelve M: app.unload (frameworks/app.lua) VACIA la tabla que devuelve
-- un modulo, y app.reload(false) -la que corre AssetsUpdate.lua al terminar una
-- descarga, p. ej. al cambiar de idioma en el login- saca de memoria todos los
-- modulos "client". Con `return M` se borraba fury_game_speed.real_dt y fwin.lua/window.lua
-- (que no se recargan) reventaban en cada fotograma: el login se quedaba sin la
-- barra del servidor y sin poder entrar hasta cerrar el juego. Se devuelve una
-- vista vacia que lee de M: el vaciado no toca nada.
return setmetatable({}, { __index = M })
