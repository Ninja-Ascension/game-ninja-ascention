-----------------------------------------------------------------------------------------------
-- LOS CUATRO PASES DE PAGO DE 15 DIAS (Fury, 5-oct-2026; docs/systems/pases_de_pago.md).
--
--   1 torre diaria     saltar hasta el record de AYER y «Skip» en la batalla de cada piso
--   2 torre semanal    lo mismo con el record de la SEMANA PASADA
--   3 elite            AVANCE AUTOMATICO por las etapas nuevas
--   4 historia         AVANCE AUTOMATICO por las etapas nuevas
--   5 PASE TORRES (19-oct-2026): la diaria Y la semanal juntas, 30 dias (fila 5.a de tipo 5).
--     No se «usa»: el servidor alarga los pases 1 y 2. Sale en el panel de las dos torres, debajo
--     de Comprar / Saltar ya, con lo que costarian los dos sueltos esos dias (textos 45-48).
--
-- Cada ventana (las dos torres y la mazmorra de historia / elite) lleva un boton «Pase»
-- que abre un panel: que hace, duracion, precio, estado («Activo: N dias») y los botones
-- Comprar y Usar. Comprar va por la web de pagos EXACTAMENTE como una recarga (C2S 69 con
-- el escalon del pase y platform_request_for_payment, como el evento 119).
--
-- EL «SKIP» DE LA BATALLA es el del propio cliente (Fight.lua, _canSkipFighting ->
-- skeepFighting): calcula el resto del combate al instante con SU motor, el mismo resultado
-- que jugandolo. Con el pase se enciende tambien en los pisos de las torres y en el
-- avance automatico (FuryModePass_canSkipFight, llamado desde Fight:init).
--
-- EL AVANCE AUTOMATICO: pregunta al servidor (C2S 29221) cual es la siguiente etapa nueva y
-- si se puede; la abre con la entrada rapida de la mazmorra (LPVENpc) y la pelea con su
-- boton de siempre (lclick_go_fight -> C2S 328/284, con TODAS sus puertas), salta el
-- combate y, si gana, vuelve a preguntar. Para al perder, al faltar nivel / energia /
-- intentos, en una escena con dialogo, o con «Parar». Va diciendo lo que pasa.
--
-- EL PROTOCOLO: dos comandos PROPIOS, dados de alta aqui como los de las torres.
--   C2S 29220 fury_mode_pass_view  rol
--   C2S 29221 fury_mode_pass_use   rol, pase (1..4)
--   S2C 29320 aviso, hecho, N, N x (pase, escalon, segundos que quedan, dias, precio),
--             T, T x (torre, mejor piso de este periodo), npc y escena siguientes.
--             Aviso: 0 nada, 1 no activo, 2 nada que hacer, 3 hecho, 4 siguiente lista,
--             5 nivel, 6 energia, 7 intentos, 8 cerrada.
-- El servidor manda (mode_pass.erl): el pase se mira alli en cada uso.
-----------------------------------------------------------------------------------------------
local VIEW, USE, PARSER = 29220, 29221, 29320

local function text(i)
	return _fury_mode_pass_text ~= nil and _fury_mode_pass_text[i] or ""
end

local function sub_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_mode_pass(interpreter, datas, pos, strDatas, list, count)
	local v = { passes = {}, towerBest = {} }
	v.notice = tonumber(npos(list)) or 0
	v.done = tonumber(npos(list)) or 0
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local p = {}
		p.kind = tonumber(npos(list)) or 0
		p.gear = tonumber(npos(list)) or 0
		p.seconds = tonumber(npos(list)) or 0
		p.days = tonumber(npos(list)) or 0
		p.money = npos(list) or ""
		p.at = os.time()
		v.passes[p.kind] = p
	end
	local t = tonumber(npos(list)) or 0
	for i = 1, t do
		local tower = tonumber(npos(list)) or 0
		v.towerBest[tower] = tonumber(npos(list)) or 0
	end
	v.nextNpc = tonumber(npos(list)) or 0
	v.nextScene = tonumber(npos(list)) or 0
	_ED.fury_mode_pass = v
end

-- Da de alta (o vuelve a dar) los dos comandos y el bloque. Idempotente.
function FuryModePass_ensureProtocol()
	for name, code in pairs({ fury_mode_pass_view = VIEW, fury_mode_pass_use = USE }) do
		protocol_command[name] = protocol_command[name] or
			{ code = code, command = name, command_fun = sub_command(name), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER, parser = "parse_fury_mode_pass",
		parser_fun = parse_mode_pass })
end

local function send(code, key, params, callback)
	FuryModePass_ensureProtocol()
	protocol_command[key].param_list = table.concat(params, "\r\n")
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

-- Los dias que le quedan (redondeando hacia arriba), 0 si no esta activo.
function FuryModePass_daysLeft(kind)
	local v = _ED.fury_mode_pass
	local p = v ~= nil and v.passes[kind] or nil
	if p == nil then
		return 0
	end
	local left = p.seconds - (os.time() - p.at)
	if left <= 0 then
		return 0
	end
	return math.ceil(left / 86400)
end

-- Los botones de las ventanas, para repintarlos cuando llega el 29320.
FuryModePass_buttons = FuryModePass_buttons or {}

-- 7-oct: CADA BOTON DICE QUE PASE ES («Skip Diaria», «Skip Semanal», «Auto Elite», «Auto
-- Historia», textos 35-38). Con «Pase Skip» en las dos torres y «Pase Auto» en historia y elite,
-- KIRITOLT y NOZAKI pagaron un pase que no querian (la compra si iba al pase de su ventana:
-- docs/systems/pases_de_pago.md). Un idioma sin esas celdas pinta el rotulo de antes.
local function passButtonName(kind)
	local name = text(34 + kind)
	if name == "" then
		name = (kind <= 2) and text(15) or text(16)
	end
	return name
end

local function buttonText(kind)
	local name = passButtonName(kind)
	local days = FuryModePass_daysLeft(kind)
	if days > 0 then
		return name .. "\n" .. string.format(text(12), days)
	end
	return name
end

-- Que el rotulo quepa tambien en el ALTO, medido con la letra del juego: la de Naruto es mas
-- alta que la de Fury y, en su btn_1.png (131x51), «Activo: 15 dias» y «(2.99 USD)» pisaban el
-- borde de abajo (LDPlayer 6-oct).
local function fitTitleHeight(button)
	local label = button:getTitleRenderer()
	if label == nil then
		return
	end
	local room = button:getContentSize().height - 8
	local h = label:getContentSize().height
	if h > room and h > 0 then
		button:setTitleFontSize(math.max(10, math.floor(button:getTitleFontSize() * room / h)))
	end
end

-- El rotulo del boton. btn_1.png mide 108x44: «Pase Skip» + «Activo: 30 dias» en dos lineas a 18
-- se salia por abajo y por los lados (LDPlayer 6-oct). Con dos lineas, letra que quepa en el alto
-- y luego encoger al ancho (fwin:fitButtonTitle).
local function setButtonTitle(button, kind)
	button:setTitleFontSize(18)
	button:setTitleText(buttonText(kind))
	local label = button:getTitleRenderer()
	if label ~= nil then
		label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end
	if string.find(button:getTitleText(), "\n", 1, true) ~= nil then
		button:setTitleFontSize(math.max(10, math.floor((button:getContentSize().height - 6) / 2.3)))
	end
	fwin:fitButtonTitle(button, 12)
	fitTitleHeight(button)
end

function FuryModePass_refreshButtons()
	for kind, button in pairs(FuryModePass_buttons) do
		if button ~= nil and not tolua.isnull(button) then
			setButtonTitle(button, kind)
			button:setTitleColor(FuryModePass_daysLeft(kind) > 0
				and cc.c3b(20, 110, 20) or cc.c3b(90, 45, 10))
		else
			FuryModePass_buttons[kind] = nil
		end
	end
	local panel = fwin:find("FuryModePassPanelClass")
	if panel ~= nil then
		panel:onUpdateDraw()
	end
end

function FuryModePass_requestView(callback)
	send(VIEW, "fury_mode_pass_view", {}, function(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			FuryModePass_refreshButtons()
			if callback ~= nil then
				callback()
			end
		end
	end)
end

-- El boton «Pase» de una ventana: btn_1.png, como «Luchar» de las torres.
function FuryModePass_createButton(kind, parent, x, y, fontName)
	local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	button:setTitleFontName(fontName or "")
	button:setTitleFontSize(18)
	button:setPosition(cc.p(x, y))
	parent:addChild(button, 5)
	FuryModePass_buttons[kind] = button
	setButtonTitle(button, kind)
	button:setTitleColor(cc.c3b(90, 45, 10))
	button:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			FuryModePass_open(kind)
		end
	end)
	FuryModePass_refreshButtons()
	return button
end

function FuryModePass_open(kind)
	FuryModePass_requestView(function()
		fwin:close(fwin:find("FuryModePassPanelClass"))
		fwin:open(FuryModePassPanel:new():init(kind), fwin._ui)
	end)
end

-- COMPRAR: el mismo camino que una recarga (el del evento 119,
-- RechargeForSixtyGiftActivity.lua:141-178): numero de pedido con el escalon del
-- pase y, en el movil, la web de pagos. El servidor solo lo entrega pagado.
--
-- 7-oct: ANTES DE CREAR EL PEDIDO SE CONFIRMA, con el nombre del pase, el precio y para que
-- sirve (texto 40: «Vas a comprar X (2.99 USD). Solo sirve para Y.»). El pase viaja en _datas,
-- no se vuelve a leer de ninguna ventana.
function FuryModePass_buy(kind)
	local v = _ED.fury_mode_pass
	local p = v ~= nil and v.passes[kind] or nil
	if p == nil or p.gear <= 0 then
		return
	end
	if text(40) == "" then
		return FuryModePass_buyConfirmed(kind)
	end
	state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
		terminal_name = "fury_mode_pass_buy_confirmed",
		terminal_state = 0,
		-- 19-oct: el Pase Torres (5) tiene su nombre y su «solo sirve para» en 45 y 48.
		_msg = string.format(text(40), (kind == 5) and text(45) or text(kind), p.money,
			(kind == 5) and text(48) or text(40 + kind)),
		_datas = { kind = kind },
	})
end

function FuryModePass_buyConfirmed(kind)
	local v = _ED.fury_mode_pass
	local p = v ~= nil and v.passes[kind] or nil
	if p == nil or p.gear <= 0 then
		return
	end
	local gear = p.gear
	-- El panel sigue preguntando aunque el pase ya este activo: comprar otra vez SUMA dias y sin
	-- esto seguia en «Activo: 15 dias» hasta cerrarlo (LDPlayer 6-oct).
	FuryModePass_buyPendingAt = os.time()
	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
		local pending = readKey("platform_purchase_info")
		if pending and pending ~= "" then
			CheckOrderToRechargeServer()
			return
		end
	end
	m_reqcharge_info.prevRechargeIndex = gear
	cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "" .. gear)
	cc.UserDefault:getInstance():flush()
	protocol_command.request_top_up_order_number.param_list = "" .. gear .. "\r\n" .. tostring(m_sPayMould)
	NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, nil,
		function(response)
			fwin:close(fwin:find("ConnectingViewClass"))
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local platform = cc.Application:getInstance():getTargetPlatform()
				if platform ~= cc.PLATFORM_OS_WINDOWS and platform ~= cc.PLATFORM_OS_LINUX
					and platform ~= cc.PLATFORM_OS_MAC then
					m_reqcharge_info.rechargeIndex = gear
					state_machine.excute("platform_request_for_payment", 0, response.node)
				end
				TipDlg.drawTextDailog(text(22))
			end
		end, false, nil)
end

-- EL PASE TORRES DE 30 DIAS (19-oct-2026, sugerencia de Discord de Naruto): la linea del panel de
-- las torres. Precio y dias, los del servidor (pase 5 del 29320); «por separado», lo que costarian
-- la diaria y la semanal sueltas esos mismos dias. nil si el servidor no lo vende o faltan los textos.
function FuryModePass_towersOffer()
	local v = _ED.fury_mode_pass
	local p = v ~= nil and v.passes[5] or nil
	if p == nil or p.gear <= 0 or p.days <= 0 or text(46) == "" or text(47) == "" then
		return nil
	end
	local separate = 0
	for k = 1, 2 do
		local s = v.passes[k]
		if s == nil or s.days <= 0 then
			return nil
		end
		separate = separate + (tonumber(s.money) or 0) * p.days / s.days
	end
	return string.format(text(46), p.days, p.money, string.format("%.2f", separate))
end

-- SALTAR (torres): hasta el record del periodo anterior, pagando los pisos saltados.
function FuryModePass_use(kind)
	send(USE, "fury_mode_pass_use", { tostring(kind) }, function(response)
		if not (response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0) then
			return
		end
		FuryModePass_refreshButtons()
		local v = _ED.fury_mode_pass
		if v == nil then
			return
		end
		if v.notice == 1 then
			TipDlg.drawTextDailog(text(17))
		elseif v.notice == 2 then
			TipDlg.drawTextDailog(text(18))
		elseif v.notice == 3 then
			fwin:close(fwin:find("FuryModePassPanelClass"))
			local tower = fwin:find("FuryTowerWindowClass")
			if tower ~= nil then
				tower:onUpdateDraw()
			end
			TipDlg.drawTextDailog(string.format(text(20), v.done))
			app.load("client.reward.DrawRareReward")
			local reward = DrawRareReward:new()
			reward:init(37)
			fwin:open(reward, fwin._ui)
		end
	end)
end

-----------------------------------------------------------------------------------------------
-- EL «SKIP» DE LA BATALLA (Fight:init pregunta aqui).
-----------------------------------------------------------------------------------------------
function FuryModePass_canSkipFight(fightType)
	-- La torre: pase de ESA torre vivo, en CUALQUIER piso de la subida. 7-oct (Victor): antes solo
	-- en los pisos nuevos (por encima del mejor del periodo) y, tras pagar el reinicio, al subir
	-- otra vez no salia. El combate se sigue calculando con el motor del cliente y el servidor
	-- solo acepta el piso siguiente del combate empezado (fury_towers:result/5).
	-- 15-oct (Victor): sin pase, el «Skip» sale a los 15 s de combate real
	-- (FuryTowers_skipLater); con pase, desde el primer segundo, como antes.
	local b = _ED.fury_tower_battle
	if fightType == 54 and b ~= nil then
		if FuryModePass_daysLeft(b.tower) > 0 then
			return true
		end
		if FuryTowers_skipLater ~= nil then
			FuryTowers_skipLater(b)
		end
		return false
	end
	-- El avance automatico: el combate que el mismo lanzo.
	return FuryModePass_auto ~= nil and FuryModePass_auto.fighting == true
end

-----------------------------------------------------------------------------------------------
-- EL AVANCE AUTOMATICO (elite = pase 3, historia = pase 4).
-----------------------------------------------------------------------------------------------
-- «escena-hueco» de una etapa, p. ej. «2-6»: lo que el jugador reconoce en el mapa.
local function stageLabel(npc, scene)
	local list = zstring.split(dms.string(dms["pve_scene"], scene, pve_scene.npcs) or "", ",")
	-- El capitulo que ve el jugador es `pve_scene.scene_id` (col 2): en elite la fila 53 es el
	-- capitulo 3 («53-3» salia en vez de «3-3», LDPlayer 6-oct).
	local chapter = tonumber(dms.string(dms["pve_scene"], scene, pve_scene.scene_id) or "") or scene
	for i, id in ipairs(list) do
		if tonumber(id) == npc then
			return chapter .. "-" .. i
		end
	end
	return tostring(npc)
end

local function removeStopButton()
	local a = FuryModePass_auto
	if a ~= nil and a.stopButton ~= nil and not tolua.isnull(a.stopButton) then
		a.stopButton:removeFromParent(true)
	end
end

-- Se acabo: dice donde y por que, y lo que hizo.
function FuryModePass_autoStop(reason)
	local a = FuryModePass_auto
	if a == nil then
		return
	end
	removeStopButton()
	FuryModePass_auto = nil
	local where = a.label or "-"
	TipDlg.drawTextDailog(string.format(text(26), where, reason) .. "\n"
		.. string.format(text(21), a.done))
	FuryModePass_requestView()
end

-- «Parar», encima de todo (la escena, no una ventana: cleanView no lo borra).
local function showStopButton()
	local a = FuryModePass_auto
	local scene = cc.Director:getInstance():getRunningScene()
	if a == nil or scene == nil then
		return
	end
	removeStopButton()
	local size = cc.Director:getInstance():getWinSize()
	local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	button:setTitleText(text(34))
	button:setTitleFontSize(20)
	button:setTitleColor(cc.c3b(120, 20, 20))
	button:setPosition(cc.p(size.width - 90, size.height - 140))
	scene:addChild(button, 10000)
	button:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended and FuryModePass_auto ~= nil then
			FuryModePass_auto.stopRequested = true
			if FuryModePass_auto.fighting ~= true then
				FuryModePass_autoStop(text(32))
			end
		end
	end)
	a.stopButton = button
end

function FuryModePass_autoStart(kind)
	fwin:close(fwin:find("FuryModePassPanelClass"))
	FuryModePass_auto = { kind = kind, done = 0 }
	FuryModePass_autoNext()
end

local REASON = { [1] = 17, [2] = 19, [5] = 27, [6] = 28, [7] = 29, [8] = 30 }

-- La siguiente: el servidor dice cual y si se puede; la entrada rapida la abre y su boton
-- de siempre la pelea.
function FuryModePass_autoNext()
	local a = FuryModePass_auto
	if a == nil then
		return
	end
	if a.stopRequested then
		FuryModePass_autoStop(text(32))
		return
	end
	-- EL DIALOGO DE FIN DE ETAPA DEL MAPA. Al cerrar la victoria, Fight:onExit lanza la historia
	-- de despues de la etapa (mission3, executeMissionExt(mission_mould_tuition,
	-- touch_off_mission_battle_over)). Lanzar la siguiente etapa encima la dejaba a medias y el
	-- combate siguiente no empezaba nunca: su «inicio de combate» esperaba a esa historia, que ya
	-- no tenia ventana (Naruto 3-9 -> 3-10, «Zabuza ......», LDPlayer 6-oct). Se pasa tocando,
	-- como los dialogos del combate, y se sigue cuando acaba; si no se pasa tocando, se para.
	-- 7-oct (Naruto, log de produccion: Fight.lua:2454 y FightUI.lua:2092 attackData nil,
	-- FightModule.lua:2243 tempBattleCache nil): LA SUBIDA DE NIVEL. En Naruto la victoria con subida
	-- abre BattleLevelUp y NO cierra el combate (SmBattleReward.lua:131-143; los otros juegos se la
	-- saltan). La etapa siguiente lanzada encima limpia las ventanas, el Fight viejo sale DESPUES
	-- (Fight:onExit borra battleCache, _fightModule y attackData) y el nuevo arranca sin datos.
	-- La subida se cierra por su boton de siempre (y la victoria, si sigue ahi) y no se sigue
	-- mientras el combate viejo siga abierto (tras cerrar, una vuelta mas: que salga del todo).
	local cerrando = false
	if fwin:find("BattleLevelUpClass") ~= nil then
		state_machine.excute("battle_level_up_close", 0, nil)
		cerrando = true
	elseif fwin:find("SmBattleRewardClass") ~= nil then
		state_machine.unlock("sm_battle_reward_drop_out")
		state_machine.excute("sm_battle_reward_drop_out", 0, nil)
		cerrando = true
	end
	-- g1 7-oct: tampoco mientras OTRO combate arranca o se carga (BattleStartEffect / FightLoading): el
	-- Fight de esa carga aun no esta en la lista de fwin y lanzar otro encima lo dejaba sin datos.
	if cerrando or fwin:find("FightClass") ~= nil or fwin:find("RoleDialogueClass") ~= nil
		or fwin:find("BattleStartEffectClass") ~= nil or fwin:find("FightLoadingCellClass") ~= nil
		or (missionIsOver ~= nil and missionIsOver() ~= true) then
		a.waitStory = (a.waitStory or 0) + 1
		if a.waitStory > 150 then
			FuryModePass_autoStop(text(33))
			return
		end
		if fwin:find("RoleDialogueClass") ~= nil then
			state_machine.excute("role_dialogue_touch", 0, "")
		end
		fwin:addService({ callback = function() FuryModePass_autoNext() end, delay = 0.8 })
		return
	end
	a.waitStory = 0
	send(USE, "fury_mode_pass_use", { tostring(a.kind) }, function(response)
		if FuryModePass_auto ~= a then
			return
		end
		local v = _ED.fury_mode_pass
		if not (response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0) or v == nil then
			FuryModePass_autoStop(text(30))
			return
		end
		if v.notice ~= 4 or v.nextNpc <= 0 then
			-- En las paradas (nivel, energia, intentos, cerrada) el servidor dice tambien en que etapa.
			if v.nextNpc > 0 then
				a.label = stageLabel(v.nextNpc, v.nextScene)
			end
			FuryModePass_autoStop(text(REASON[v.notice] or 30))
			return
		end
		a.npc, a.scene = v.nextNpc, v.nextScene
		a.label = stageLabel(a.npc, a.scene)
		state_machine.excute("lduplicate_window_pve_quick_entrance", 0,
			{ _type = (a.kind == 3) and 2 or 1, _sceneId = a.scene, _npcid = a.npc })
		fwin:addService({
			callback = function()
				if FuryModePass_auto ~= a then
					return
				end
				-- Una escena con dialogo no abre el panel de la etapa: se juega a mano.
				if fwin:find("LPVENpcClass") == nil then
					FuryModePass_autoStop(text(33))
					return
				end
				a.fighting, a.started = true, false
				state_machine.excute("lclick_go_fight", 0, nil)
				-- Si el boton no llega a lanzar el combate (aviso de mochila llena, compra de
				-- intentos...), no se queda esperando para siempre.
				local service
				service = {
					callback = function()
						if FuryModePass_auto == a and a.fighting and not a.started then
							-- g1 7-oct (LDPlayer, Naruto): tras una subida de nivel la carga de la etapa
							-- siguiente pasaba de 10 s, esto paraba el avance y el combate quedaba en
							-- manual sin «Parar». Mientras el combate arranca o se carga, se espera otra vez.
							if fwin:find("BattleStartEffectClass") ~= nil or fwin:find("FightLoadingCellClass") ~= nil then
								service.delay = 10
								fwin:addService(service)
								return
							end
							a.fighting = false
							FuryModePass_autoStop(text(30))
						end
					end,
					delay = 10,
				}
				fwin:addService(service)
			end,
			delay = 0.5,
		})
	end)
end

-- Fight:startFight: en el avance automatico el combate se salta solo.
function FuryModePass_autoFight(fight)
	local a = FuryModePass_auto
	if a == nil or a.fighting ~= true or fight == nil or fight._canSkipFighting ~= true then
		return
	end
	a.started = true
	showStopButton()
	-- UN SOLO TEMPORIZADOR para todo el combate (LDPlayer 6-oct):
	--  * el Skip del cliente salta solo la OLEADA en curso (FightRoleController:skeepFighting ->
	--    jumpCurrentFight) y Fight:startFight solo corre en la primera: en las etapas de 2 oleadas la
	--    segunda se jugaba entera (~35 s). Se vuelve a pulsar en cada oleada; mientras un salto esta
	--    en marcha el propio cliente tiene «fight_skeep_fighting» cerrado y la pulsacion no hace nada;
	--  * los DIALOGOS DE HISTORIA DENTRO DEL COMBATE (el jefe de la oleada 2 de 4-2, 4-4...) dejaban
	--    el avance esperando un toque para siempre: se pasan solos (role_dialogue_touch), y los de fin
	--    de combate no se lanzan (fight_first_set_skip_misson, lo mismo que el «Saltar» de FightUI);
	--  * la FICHA DEL JEFE de la primera vez (BossIntroduce) tambien esperaba un toque: se cierra.
	state_machine.excute("fight_first_set_skip_misson", 0, "")
	if a.ticker == fight then
		return
	end
	a.ticker = fight
	local function tick()
		if FuryModePass_auto ~= a or a.fighting ~= true or a.ticker ~= fight or tolua.isnull(fight)
			or fight._fight_is_end == true then
			return
		end
		if fwin:find("BossIntroduceClass") ~= nil then
			-- La ficha del jefe la primera vez (Fight.lua:614-631): su boton de cerrar de siempre.
			state_machine.excute("boss_introduce_close", 0, nil)
		elseif fwin:find("RoleDialogueClass") ~= nil then
			state_machine.excute("role_dialogue_touch", 0, "")
		else
			state_machine.excute("fight_skeep_fighting", 0, nil)
		end
		fwin:addService({ callback = tick, delay = 0.8 })
	end
	fwin:addService({ callback = tick, delay = 0.8 })
end

-- Fight:fightEnd: con el combate ya liquidado (C2S 284), seguir o parar.
function FuryModePass_autoBattleEnd(fight)
	local a = FuryModePass_auto
	if a == nil or a.fighting ~= true then
		return
	end
	a.fighting = false
	local win = _ED.attackData ~= nil and tonumber(_ED.attackData.isWin) ~= 0
	if not win then
		FuryModePass_autoStop(text(31))
		return
	end
	a.done = a.done + 1
	TipDlg.drawTextDailog(string.format(text(25), a.label or "-", a.done))
	-- g1 7-oct: la ventana de victoria la cierra autoNext por su boton (SmBattleRewardClass) SOLO si
	-- esta abierta. Antes se pulsaba aqui a ciegas «sm_battle_reward_drop_out», que SmBattleReward:onExit
	-- no quita: sin la ventana, el terminal de una ventana vieja hacia fwin:reset con el combate a medias.
	fwin:addService({
		callback = function()
			if FuryModePass_auto == a then
				FuryModePass_autoNext()
			end
		end,
		delay = 3.0,
	})
end

-- EL BOTON DE LA MAZMORRA: junto a Super Rush (Button_super_mopping), solo en
-- historia (tipo 1 -> pase 4) y elite (tipo 2 -> pase 3), que es donde se ve.
function FuryModePass_attachDuplicate(window, index)
	local root = window.roots ~= nil and window.roots[1] or nil
	if root == nil then
		return
	end
	local rush = ccui.Helper:seekWidgetByName(root, "Button_super_mopping")
	if rush == nil then
		return
	end
	local parent = rush:getParent()
	local old = parent:getChildByName("Button_fury_mode_pass")
	local kind = (index == 1) and 4 or ((index == 2) and 3 or nil)
	if kind == nil or not rush:isVisible() then
		if old ~= nil then
			old:setVisible(false)
		end
		return
	end
	if old ~= nil then
		old:removeFromParent(true)
	end
	-- A la DERECHA de Super Rush: a la izquierda quedaba debajo del titulo del capitulo («Talento
	-- del Futuro 4» lo tapaba y casi no se podia pulsar; LDPlayer 6-oct). A la derecha, en la franja
	-- de arriba del mapa, no hay nada.
	local size = rush:getContentSize()
	local anchor = rush:getAnchorPoint()
	local right = rush:getPositionX() + size.width * rush:getScaleX() * (1 - anchor.x)
	local x = right + 12 + 54
	local y = rush:getPositionY() + size.height * rush:getScaleY() * (0.5 - anchor.y)
	local font = rush.getTitleFontName ~= nil and rush:getTitleFontName() or ""
	local button = FuryModePass_createButton(kind, parent, x, y, font)
	button:setName("Button_fury_mode_pass")
	FuryModePass_requestView()
end

-----------------------------------------------------------------------------------------------
-- EL PANEL: que hace, duracion, precio, estado y los botones Comprar / Usar.
-----------------------------------------------------------------------------------------------
FuryModePassPanel = class("FuryModePassPanelClass", Window)

function FuryModePassPanel:ctor()
	self.super:ctor()
	self.roots = {}
	self.elapsed = 0
end

function FuryModePassPanel:init(kind)
	self.kind = kind
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
		{ terminal_name = "fury_mode_pass_close", terminal_state = 0, touch_black = true }, nil, 3)
	self:onUpdateDraw()
	self:registerOnNoteUpdate(self, 1)
	return self
end

-- Mientras el panel esta abierto y el pase no (o hasta 10 min despues de pulsar Comprar), pregunta
-- cada 10 s: es lo que pinta «Activo» al volver de pagar en el navegador sin cerrar nada.
function FuryModePassPanel:onUpdate(dt)
	self.elapsed = self.elapsed + (dt or 0)
	if self.elapsed >= 10 then
		self.elapsed = 0
		local buying = FuryModePass_buyPendingAt ~= nil and os.time() - FuryModePass_buyPendingAt < 600
		if FuryModePass_daysLeft(self.kind) == 0 or buying then
			FuryModePass_requestView()
		end
	end
end

function FuryModePassPanel:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local kind = self.kind
	local v = _ED.fury_mode_pass
	local p = v ~= nil and v.passes[kind] or nil
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(kind))
	-- El marco del titulo deja ~300 de ancho entre sus dos rombos: «Avance automatico Historia» los
	-- pisaba (LDPlayer 6-oct). Se encoge solo el que no cabe.
	title:setScale(1)
	local titleWidth = title:getContentSize().width
	if titleWidth > 290 then
		title:setScale(290 / titleWidth)
	end
	local fontName = title:getFontName()
	local list = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	list:removeAllItems()
	local width = list:getContentSize().width
	local function line(str, color, size)
		local label = ccui.Text:create(str, fontName, size or 20)
		label:ignoreContentAdaptWithSize(false)
		label:setTextAreaSize(cc.size(width - 32, 0))
		label:setColor(color)
		local height = label:getVirtualRendererSize().height + 12
		label:setContentSize(cc.size(width - 32, height))
		label:setAnchorPoint(cc.p(0, 0.5))
		label:setPosition(cc.p(16, height / 2))
		local row = ccui.Layout:create()
		row:setContentSize(cc.size(width, height))
		row:addChild(label)
		list:addChild(row)
	end
	local days = FuryModePass_daysLeft(kind)
	if days > 0 then
		line(string.format(text(12), days), cc.c3b(80, 230, 80), 24)
	else
		line(text(13), cc.c3b(200, 200, 200), 24)
	end
	line(text(4 + kind), cc.c3b(255, 255, 255))
	if p ~= nil then
		line(string.format(text(9), p.days, p.days), cc.c3b(255, 220, 90))
		line(string.format(text(10), p.money), cc.c3b(255, 220, 90))
	end
	line(text(11), cc.c3b(200, 200, 255))
	line(text(22), cc.c3b(180, 180, 180), 18)

	-- Comprar siempre (otra compra SUMA); Usar solo con el pase activo.
	local row = ccui.Layout:create()
	row:setContentSize(cc.size(width, 90))
	local function button(str, x, callback, into)
		local b = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
		b:setTitleText(str)
		b:setTitleFontName(fontName)
		b:setTitleFontSize(20)
		b:setTitleColor(cc.c3b(90, 45, 10))
		fwin:fitButtonTitle(b, 16)
		fitTitleHeight(b)
		-- 7-oct: «Comprar Skip Semanal» en dos lineas quedaba apretado en btn_1.png (LDPlayer): un
		-- cuarto mas grande, que la fila (90 de alto) tiene sitio.
		b:setScale(1.25)
		b:setPosition(cc.p(x, 45))
		b:addTouchEventListener(function(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				callback()
			end
		end)
		local target = into or row
		target:addChild(b)
	end
	-- 7-oct: «Comprar Skip Semanal» (texto 39 con el nombre corto del boton); el precio lo dicen la
	-- linea de arriba y la confirmacion. Sin la celda, «Comprar (2.99 USD)» como antes.
	local buy = text(39) ~= "" and string.format(text(39), passButtonName(kind))
		or (text(14) .. (p ~= nil and (" (" .. p.money .. " USD)") or ""))
	if days > 0 then
		button(buy, width * 0.3, function() FuryModePass_buy(kind) end)
		if kind <= 2 then
			button(text(23), width * 0.7, function() FuryModePass_use(kind) end)
		else
			button(text(24), width * 0.7, function() FuryModePass_autoStart(kind) end)
		end
	else
		button(buy, width * 0.5, function() FuryModePass_buy(kind) end)
	end
	list:addChild(row)
	-- 19-oct: en las dos torres, el Pase Torres de 30 dias (diaria + semanal) con su boton.
	local offer = (kind <= 2) and FuryModePass_towersOffer() or nil
	if offer ~= nil then
		line(offer, cc.c3b(255, 180, 60))
		local towers = ccui.Layout:create()
		towers:setContentSize(cc.size(width, 90))
		button(text(47), width * 0.5, function() FuryModePass_buy(5) end, towers)
		list:addChild(towers)
	end
	list:requestRefreshView()
end

function FuryModePassPanel:onExit()
	self:unregisterOnNoteUpdate(self)
end

state_machine.add({
	_name = "fury_mode_pass_close",
	_init = function(terminal) end,
	_inited = false,
	_instance = nil,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryModePassPanelClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
})
-- «Aceptar» de la confirmacion de compra (status 1; cancelar o cerrar no hace nada).
state_machine.add({
	_name = "fury_mode_pass_buy_confirmed",
	_init = function(terminal) end,
	_inited = false,
	_instance = nil,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil and params.status == 1 and params._datas ~= nil then
			FuryModePass_buyConfirmed(params._datas.kind)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
})
state_machine.init()
