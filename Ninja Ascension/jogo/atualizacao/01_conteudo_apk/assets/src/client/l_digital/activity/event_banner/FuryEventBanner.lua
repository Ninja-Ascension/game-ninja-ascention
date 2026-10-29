-----------------------------------------------------------------------------------------------
-- EL EVENTO DESTACADO AL ENTRAR (sugerencia de un creador, 18-oct-2026).
--
-- «Los anuncios de cuando entras al juego y sale el evento que esta». El
-- cliente NO trae una ventana viva para esto (docs/systems/anuncio_evento.md):
--   * ActivityPushDialog.lua (活动推送) es de otros proyectos (Menu.lua:2297 solo
--     la abre para __lua_project_naruto/pokemon/digimon_adventure, no para los
--     l_*), nadie rellena `_ED.activity_push_info` y su .csb
--     (activity/wonderful/wonderful_tuijian.csb) no viene en el paquete;
--   * el tablon del login (GameAnnouncement, S2C 999) sale ANTES de elegir
--     servidor y es solo texto: no puede ser «el evento de cada servidor».
--
-- LO MINIMO: al entrar se abre la ventana «Eventos» de siempre YA EN LA
-- PESTANA del evento destacado. Es la pantalla del propio evento, con su arte
-- de cabecera y sus botones: el «ir al evento» es estar en el. Ninguna maqueta
-- ni texto nuevos (nada que traducir en los 13 idiomas).
--
-- EL DESTACADO DEL DIA, POR SERVIDOR: de las pestanas que la ventana pinta
-- (`pageKeys` con `activity_type`), las de un evento CON FECHAS de 2 a 31 dias
-- (`begin_time`/`end_time` del bloque 85, ProtocolParserCopy.lua:4949-4962) que
-- este en marcha ahora. Fuera los permanentes (ventana de un ano), los bonos de
-- un dia (94/131) y las pestanas diarias sin fechas. De esas, las que empezaron
-- el MISMO DIA que la mas nueva (la tanda de la semana) y, entre ellas, una
-- distinta cada dia de juego (token 2 del S2C 342, `_ED.game_request_address`).
-- El bloque 85 ya viene con el calendario DESPLAZADO de cada servidor
-- (event_calendar.erl), asi que cada servidor tiene el suyo.
--
-- CUANDO: una vez por arranque (global que vive lo que el proceso), si el
-- personaje pasa del nivel 6, decidido en la PRIMERA pintura de la ciudad como
-- los Codigos (Home.lua). Nunca encima del tutorial. EN COLA: espera a que no
-- haya ninguna ventana en la capa _ui (la de Codigos, la de primera recarga...)
-- y a estar en la ciudad; abrir «Eventos» limpia esa capa
-- (menu_clean_page_state, Menu.lua:315) y se llevaria la ventana de Codigos.
-----------------------------------------------------------------------------------------------

-- Pestanas que no son «un evento»: inicio de sesion, firma diaria y descuento
-- del dia (las diarias de siempre). Ademas, todo lo >= 1000 son categorias.
FURY_EVENT_BANNER_SKIP = {[24] = true, [38] = true, [93] = true}
FURY_EVENT_BANNER_MIN_DAYS = 2
FURY_EVENT_BANNER_MAX_DAYS = 31
-- Cuanto espera en cola (segundos) antes de rendirse en este arranque.
FURY_EVENT_BANNER_MAX_WAIT = 120

-- Milisegundos o segundos -> segundos (el bloque 85 manda milisegundos).
function FuryEventBanner_seconds(v)
	local n = tonumber(v)
	if n == nil or n <= 0 then
		return nil
	end
	if n > 100000000000 then
		n = math.floor(n / 1000)
	end
	return n
end

-- ¿Se programa en este arranque? Nivel > 6 y aun no decidido.
function FuryEventBanner_shouldSchedule(level, done)
	if done == true then
		return false
	end
	return (tonumber(level) or 0) > 6
end

-- Las pestanas candidatas, en el orden de la ventana.
--   pageKeys: {{key=, activity_type=}, ...} (ActivityWindow.pageKeys)
--   active:   _ED.active_activity
--   now:      segundos del servidor
function FuryEventBanner_candidates(pageKeys, active, now)
	local list = {}
	if type(pageKeys) ~= "table" or type(active) ~= "table" then
		return list
	end
	local seen = {}
	for _, v in ipairs(pageKeys) do
		local t = v ~= nil and tonumber(v.activity_type) or nil
		if t ~= nil and t > 0 and t < 1000 and FURY_EVENT_BANNER_SKIP[t] ~= true
			and seen[t] == nil and type(v.key) == "string" then
			local a = active[t]
			if type(a) == "table" then
				local b = FuryEventBanner_seconds(a.begin_time)
				local e = FuryEventBanner_seconds(a.end_time)
				if b ~= nil and e ~= nil and e > b then
					local days = (e - b) / 86400
					local running = now == nil or (b <= now and now < e)
					if running and days >= FURY_EVENT_BANNER_MIN_DAYS and days <= FURY_EVENT_BANNER_MAX_DAYS then
						seen[t] = true
						list[#list + 1] = {key = v.key, activity_type = t, begin = b}
					end
				end
			end
		end
	end
	return list
end

-- La pestana destacada de hoy (o nil): la tanda mas nueva y, dentro, una por dia.
function FuryEventBanner_pick(candidates, day)
	if type(candidates) ~= "table" or #candidates == 0 then
		return nil
	end
	local newest = nil
	for _, c in ipairs(candidates) do
		local d = math.floor(c.begin / 86400)
		if newest == nil or d > newest then
			newest = d
		end
	end
	local group = {}
	for _, c in ipairs(candidates) do
		if math.floor(c.begin / 86400) == newest then
			group[#group + 1] = c
		end
	end
	local n = math.floor(tonumber(day) or 0)
	return group[(n % #group) + 1]
end

-- El dia de juego (token 2 del S2C 342) o, sin el, el dia UTC del servidor.
function FuryEventBanner_day(now)
	local d = tonumber(_ED and _ED.game_request_address)
	if d ~= nil then
		return d
	end
	return math.floor((now or os.time()) / 86400)
end

-- ¿Que hacer ahora? "go", "wait" o "drop". Pura: el estado llega en `s`.
--   s.tutorial  tutorial en marcha        -> drop (este arranque ya no)
--   s.events    «Eventos» ya abierta       -> drop (ya esta donde queriamos)
--   s.waited    segundos en cola           -> drop al pasar el tope
--   s.home      la ciudad esta abierta
--   s.uiBusy    hay una ventana en la capa _ui (Codigos, primera recarga...)
function FuryEventBanner_decide(s)
	if s.tutorial then
		return "drop"
	end
	if s.events then
		return "drop"
	end
	-- 21-oct (como VW; Victor: «la flecha de volver abre otras ventanas antes de llegar a la ciudad»): si el jugador ya
	-- se fue a otra pantalla (mapa, tienda, Competir...) no se le abre «Eventos» al volver. Solo se espera detras
	-- de las ventanas que salen solas al entrar (Codigos, Regalo quincenal).
	if s.left then
		return "drop"
	end
	-- 21-oct (como VW): una sola ventana sola al entrar. Si ya salio otra (Codigos o Regalo quincenal), al cerrarla se va
	-- a la ciudad y no se encadena «Eventos» detras (antes: Codigos -> Regalo -> Eventos, tres flechas de volver).
	if s.popupShown then
		return "drop"
	end
	if s.home and not s.uiBusy then
		return "go"
	end
	if (s.waited or 0) >= FURY_EVENT_BANNER_MAX_WAIT then
		return "drop"
	end
	return "wait"
end

-- Ventanas que salen solas al entrar en la ciudad: detras de ellas SI se espera.
FURY_EVENT_BANNER_POPUPS = {GiftCodesWindowClass = true, ActivityMonthGiftClass = true}

local function uiBusy()
	local busy, left = false, false
	for _, v in pairs(fwin._list) do
		if v ~= nil and v._view == fwin._ui and v.isVisible ~= nil and v:isVisible() == true then
			busy = true
			if FURY_EVENT_BANNER_POPUPS[v.__cname] ~= true then
				left = true
			end
		end
	end
	return busy, left
end

local function state(waited)
	local events = fwin:find("ActivityWindowClass")
	local home = fwin:find("HomeClass")
	local frame = fwin._frameview ~= nil and fwin._frameview._layer ~= nil
		and fwin._frameview._layer:isVisible() == true
	local busy, left = uiBusy()
	if busy and not left then
		_fury_event_banner_popup_seen = true
	end
	return {
		tutorial = missionIsOver() ~= true or fwin:find("TuitionControllerClass") ~= nil,
		events = events ~= nil and events:isVisible() == true,
		home = home ~= nil and frame,
		uiBusy = busy,
		left = left,
		popupShown = _fury_event_banner_popup_seen == true,
		waited = waited,
	}
end

-- Los tipos en marcha como si todos tuvieran pestana: para no abrir «Eventos»
-- (que recarga la ciudad al cerrarla) cuando no hay ningun evento con fechas.
function FuryEventBanner_anyCandidate(active, now)
	local keys = {}
	if type(active) == "table" then
		for t, _ in pairs(active) do
			keys[#keys + 1] = {key = tostring(t), activity_type = t}
		end
	end
	return #FuryEventBanner_candidates(keys, active, now) > 0
end

-- Abre «Eventos» en la pestana destacada. Sin destacado, la vuelve a cerrar.
function FuryEventBanner_open()
	local now = os.time() + (tonumber(_ED.time_add_or_sub) or 0)
	if not FuryEventBanner_anyCandidate(_ED.active_activity, now) then
		return false
	end
	app.load("client.activity.ActivityWindow")
	state_machine.excute("activity_window_open", 0, {nil, ""})
	local window = fwin:find("ActivityWindowClass")
	if window == nil then
		return false
	end
	local pick = FuryEventBanner_pick(FuryEventBanner_candidates(window.pageKeys, _ED.active_activity, now),
		FuryEventBanner_day(now))
	if pick == nil then
		state_machine.excute("activity_window_close", 0, "")
		return false
	end
	state_machine.excute("activity_window_change_to_page", 0, pick.key)
	return true
end

local function tick(waited)
	local ok, decision = pcall(function() return FuryEventBanner_decide(state(waited)) end)
	if not ok then
		print("[event_banner] " .. tostring(decision))
		return
	end
	if decision == "go" then
		local opened, err = pcall(FuryEventBanner_open)
		if not opened then
			print("[event_banner] " .. tostring(err))
		end
	elseif decision == "wait" then
		fwin:addService({callback = tick, delay = 1.0, params = waited + 1})
	end
end

-- Lo llama Home.lua en la primera pintura de la ciudad tras arrancar.
function FuryEventBanner_schedule(level)
	if not FuryEventBanner_shouldSchedule(level, _fury_event_banner_done) then
		_fury_event_banner_done = true
		return false
	end
	_fury_event_banner_done = true
	if missionIsOver() ~= true or fwin:find("TuitionControllerClass") ~= nil then
		return false
	end
	-- Detras de los Codigos, que se programan a 1.0 s.
	fwin:addService({callback = tick, delay = 2.0, params = 0})
	return true
end
