-----------------------------------------------------------------------------------------------
-- LAS DOS TORRES NUEVAS: DIARIA (1) Y SEMANAL (2) (Fury, 29-sep-2026;
-- docs/systems/torres_nuevas.md).
--
-- Tipo Snake Trial pero SIN buffs, SIN cofres y SIN elegir reto: solo pisos, y
-- cada piso ganado da su premio. Reutiliza lo que ya trae el cliente:
--   pantalla: campaign/TrialTower/trial_tower.csb (la torre de Snake Trial) con
--             otro TONO (setColor del fondo y de cada piso) y otro titulo;
--   pisos:    campaign/TrialTower/sm_trial_tower_floor_list.csb (el mismo piso,
--             el mismo heroe y los mismos rivales de play_config 56);
--   combate:  el de Snake Trial (tipo 54, FightModule:initSpecialFight) con el
--             npc y el poder que manda el SERVIDOR; el DEBILITAR lo aplica
--             FightModule (mitad de vida y ataque) si _ED.fury_tower_battle.weaken;
--   premio:   DrawRareReward:init(37) (la ventana de premio de la torre);
--   ranking y reglas: las maquetas de la tienda de suscripciones
--             (sm_limited_time_equip_box_help.csb, utils/common_popup_rule.csb);
--   entrada:  dos paneles nuevos en la pantalla de mazmorras (ExploreWindow),
--             clonados del panel de Snake Trial y tenidos de otro color.
-- Los textos: `_fury_tower_text` de TipStringInfo.lua (12 idiomas).
--
-- EL PROTOCOLO: comandos PROPIOS (sistema B, 29020-29039; bloques +100), dados
-- de alta aqui en protocol_command / protocol_parse (como la suscripcion):
--   C2S 29020 fury_tower_view    rol, torre
--   C2S 29021 fury_tower_start   rol, torre, piso
--   C2S 29022 fury_tower_result  rol, torre, piso, gano(1/0)
--   C2S 29023 fury_tower_buy     rol, torre, que (1 doble, 2 debilitar, 3 reiniciar)
--   C2S 29024 fury_tower_rank    rol
--   S2C 29120 la torre; S2C 29124 el ranking diario (fury_legacy_towers.erl).
-- El servidor manda: piso, rival, poder, premios, precios y estados.
-----------------------------------------------------------------------------------------------
FuryTowerWindow = class("FuryTowerWindowClass", Window)

local VIEW, START, RESULT, BUY, RANK = 29020, 29021, 29022, 29023, 29024
local VIEW_PARSER, RANK_PARSER = 29120, 29124
-- El tono de cada torre (el mismo arte de Snake Trial, otro color).
local TONES = { cc.c3b(140, 190, 255), cc.c3b(255, 150, 200) }
-- El nivel de Snake Trial (fun_open_condition 92): el mismo candado.
local FUN_OPEN_ID = 92

local function text(i)
	return _fury_tower_text ~= nil and _fury_tower_text[i] or ""
end

local function sub_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_view(interpreter, datas, pos, strDatas, list, count)
	local v = {}
	local keys = { "tower", "floors", "floor", "notice", "balance", "double_price",
		"weaken_price", "reset_price", "reset_available", "double_state", "weaken_state",
		"npc_id", "enemy_power", "remaining", "rank_position" }
	for _, k in ipairs(keys) do
		v[k] = tonumber(npos(list)) or 0
	end
	v.rewards = {}
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local f = tonumber(npos(list)) or 0
		v.rewards[f] = npos(list) or ""
	end
	v.received_at = os.time()
	_ED.fury_tower = v
end

local function unescape(s)
	s = string.gsub(s or "", "&nbsp;", " ")
	return (string.gsub(s, "&amp;", "&"))
end

local function parse_rank(interpreter, datas, pos, strDatas, list, count)
	local r = { rows = {} }
	r.my_position = tonumber(npos(list)) or 0
	r.my_floor = tonumber(npos(list)) or 0
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local row = {}
		row.position = tonumber(npos(list)) or 0
		row.role_id = npos(list)
		row.name = unescape(npos(list))
		row.floor = tonumber(npos(list)) or 0
		r.rows[#r.rows + 1] = row
	end
	-- Los premios por puesto (30-sep): K y por tramo desde, hasta, «tipo,molde,cantidad|...».
	r.rewards = {}
	local k = tonumber(npos(list)) or 0
	for i = 1, k do
		local t = { from = tonumber(npos(list)) or 0, to = tonumber(npos(list)) or 0, items = {} }
		for part in string.gmatch(npos(list) or "", "[^|]+") do
			local f = {}
			for field in string.gmatch(part, "[^,]+") do
				f[#f + 1] = tonumber(field) or 0
			end
			if #f >= 3 then
				t.items[#t.items + 1] = f
			end
		end
		r.rewards[#r.rewards + 1] = t
	end
	_ED.fury_tower_rank = r
end

-- Da de alta (o vuelve a dar) los cinco comandos y los dos bloques. Idempotente.
function FuryTowers_ensureProtocol()
	local names = { fury_tower_view = VIEW, fury_tower_start = START,
		fury_tower_result = RESULT, fury_tower_buy = BUY, fury_tower_rank = RANK }
	for name, code in pairs(names) do
		protocol_command[name] = protocol_command[name] or
			{ code = code, command = name, command_fun = sub_command(name), param_list = "" }
	end
	local have = {}
	for _, v in pairs(protocol_parse) do
		have[v.code] = true
	end
	if not have[VIEW_PARSER] then
		table.insert(protocol_parse, { code = VIEW_PARSER, parser = "parse_fury_tower_view",
			parser_fun = parse_view })
	end
	if not have[RANK_PARSER] then
		table.insert(protocol_parse, { code = RANK_PARSER, parser = "parse_fury_tower_rank",
			parser_fun = parse_rank })
	end
end

-- «tipo,molde,cantidad|...» -> {{tipo, cantidad, molde}, ...}
local function rewardList(str)
	local list = {}
	for group in string.gmatch(str or "", "[^|]+") do
		local f = {}
		for field in string.gmatch(group, "[^,]+") do
			f[#f + 1] = tonumber(field)
		end
		if #f >= 3 and f[1] ~= nil and f[2] ~= nil and f[3] ~= nil then
			list[#list + 1] = { f[1], f[3], f[2] }
		end
	end
	return list
end

-- 1 ya comprado, 2 reinicio usado, 3 combate no empezado, 4 demasiado rapido,
-- 5 torre completa, 6 nada que reiniciar, 7 no se reinicia a mano (textos 17-23).
local function showNotice(v)
	if v ~= nil and v.notice ~= nil and v.notice > 0 and v.notice <= 7 then
		TipDlg.drawTextDailog(text(16 + v.notice))
	end
end

local function redraw()
	local window = fwin:find("FuryTowerWindowClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function send(code, key, params, callback)
	FuryTowers_ensureProtocol()
	protocol_command[key].param_list = table.concat(params, "\r\n")
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

function FuryTowers_requestView(tower)
	send(VIEW, "fury_tower_view", { tostring(tower) }, function(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			redraw()
		end
	end)
end

-- Abre la torre (desde la pantalla de mazmorras o al volver del combate).
function FuryTowers_open(tower, afterBattle)
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.utils.ConfirmTip")
	FuryTowers_ensureProtocol()
	if _ED.fury_tower ~= nil and _ED.fury_tower.tower ~= tower then
		_ED.fury_tower = nil
	end
	fwin:close(fwin:find("FuryTowerWindowClass"))
	fwin:open(FuryTowerWindow:new():init(tower), fwin._ui)
	if afterBattle ~= true then
		FuryTowers_requestView(tower)
	end
end

-- EL COMBATE: el servidor apunta el piso (29021) y el cliente pelea en local
-- como Snake Trial (GuanQia:fight), sin los buffs ni la vida arrastrada de
-- Snake Trial: equipo entero contra el npc y el poder que manda el servidor.
function FuryTowers_fight()
	local v = _ED.fury_tower
	if v == nil or v.floor >= v.floors or v.npc_id <= 0 then
		return
	end
	local floor = v.floor + 1
	send(START, "fury_tower_start", { tostring(v.tower), tostring(floor) }, function(response)
		if not (response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0) then
			return
		end
		local nv = _ED.fury_tower
		if nv == nil or nv.notice ~= 0 or nv.floor + 1 ~= floor then
			showNotice(nv)
			redraw()
			return
		end
		FuryTowers_launchBattle(nv, floor)
	end)
end

function FuryTowers_launchBattle(v, floor)
	app.load("client.battle.fight.FightEnum")
	app.load("client.battle.report.BattleReport")
	app.load("client.battle.BattleStartEffect")
	_ED.fury_tower_battle ={ tower = v.tower, floor = floor, weaken = (v.weaken_state == 1) }
	if _ED._fightModule == nil then
		_ED._fightModule = FightModule:new()
	end
	_ED.attackData = { roundCount = _ED._fightModule.totalRound, roundData = {} }
	_ED._current_scene_id = dms.string(dms["play_config"], 26, play_config.param)
	_ED._scene_npc_id = tostring(v.npc_id)
	_ED.trial_scene_npc_id = tostring(v.npc_id)
	_ED._npc_difficulty_index = "1"
	_ED.trial_star_Magnification = 1
	_ED.three_kingdoms_npc_fight = v.enemy_power
	-- La vida guardada de los enemigos de Snake Trial NO se aplica aqui.
	local savedTry = _ED.user_try_ship_datas
	_ED.user_try_ship_datas = ""
	_ED._fightModule:initSpecialFight(_ED._scene_npc_id, _ED._npc_difficulty_index,
		_enum_fight_type._fight_type_54, {})
	_ED.user_try_ship_datas = savedTry
	local orderList = {}
	_ED._fightModule:initFightOrder(_ED.user_info, orderList)
	cacher.removeAllTextures()
	fwin:cleanView(fwin._windows)
	cc.Director:getInstance():purgeCachedData()
	local bse = BattleStartEffect:new()
	bse:init(54)
	fwin:open(bse, fwin._windows)
end

-- Lo llaman TrialTowerBattleReward (gano) y TrialTowerBattleLose (perdio)
-- cuando el combate era de estas torres. Manda el resultado y vuelve a la torre.
function FuryTowers_battleEnd(win)
	local b = _ED.fury_tower_battle
	_ED.fury_tower_battle = nil
	if b == nil then
		return false
	end
	local function back(response)
		fwin:close(fwin:find("BattleSceneClass"))
		fwin:removeAll()
		app.load("client.home.Menu")
		fwin:open(Menu:new(), fwin._taskbar)
		FuryTowers_open(b.tower, true)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			showNotice(_ED.fury_tower)
			redraw()
			-- The local port intentionally has no reviewed floor-reward table yet.
			-- Do not show an empty/fabricated loot window after a valid fight.
			if win and _ED.fury_tower ~= nil and _ED.fury_tower.notice == 0
				and next(_ED.fury_tower.rewards or {}) ~= nil then
				app.load("client.reward.DrawRareReward")
				local reward = DrawRareReward:new()
				reward:init(37)
				fwin:open(reward, fwin._ui)
			end
		else
			FuryTowers_requestView(b.tower)
		end
	end
	send(RESULT, "fury_tower_result",
		{ tostring(b.tower), tostring(b.floor), win and "1" or "0" }, back)
	return true
end

-- Salir del combate con la pausa: vuelve a la torre sin mandar nada (el
-- combate empezado se queda sin resultado; el siguiente «Luchar» lo reabre).
function FuryTowers_battleQuit()
	local b = _ED.fury_tower_battle
	_ED.fury_tower_battle = nil
	if b == nil then
		return false
	end
	FuryTowers_open(b.tower)
	return true
end

-- Comprar: 1 doble, 2 debilitar, 3 reiniciar. Comprueba el saldo que dijo el
-- servidor y pide confirmacion (textos 13-15).
local function askBuy(kind)
	local v = _ED.fury_tower
	if v == nil then
		return
	end
	local price = ({ v.double_price, v.weaken_price, v.reset_price })[kind]
	if v.balance < price then
		TipDlg.drawTextDailog(text(16))
		return
	end
	state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
		terminal_name = "fury_tower_buy_confirmed",
		terminal_state = 0,
		_msg = string.format(text(12 + kind), price),
		_datas = { tower = v.tower, kind = kind },
	})
end

local function terminal(name, invoke)
	state_machine.add({
		_name = name,
		_init = function(terminal) end,
		_inited = false,
		_instance = nil,
		_state = 0,
		_invoke = function(terminal, instance, params)
			invoke(params)
			return true
		end,
		_terminal = nil,
		_terminals = nil
	})
end

terminal("fury_towers_open", function(params)
	local d = params._datas
	if d.locked and funOpenDrawTip(FUN_OPEN_ID) == true then
		return
	end
	FuryTowers_open(d.tower)
end)
terminal("fury_tower_close", function(params)
	-- Como «Volver» de Snake Trial (trial_tower_back_activity): tras un combate la ventana de
	-- mazmorras ya no existe (FuryTowers_battleEnd hace removeAll) y cerrar sin mas dejaba la
	-- pantalla en negro (visto 30-sep).
	state_machine.unlock("explore_window_open_fun_window")
	if fwin:find("ExploreWindowClass") == nil then
		state_machine.excute("explore_window_open", 0, "")
	end
	fwin:close(fwin:find("FuryTowerWindowClass"))
end)
terminal("fury_tower_fight", function(params)
	FuryTowers_fight()
end)
terminal("fury_tower_double", function(params)
	askBuy(1)
end)
terminal("fury_tower_weaken", function(params)
	askBuy(2)
end)
terminal("fury_tower_rank_or_reset", function(params)
	local v = _ED.fury_tower
	if v == nil then
		return
	end
	if v.tower == 1 then
		send(RANK, "fury_tower_rank", {}, function(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				fwin:close(fwin:find("FuryTowerRankClass"))
				fwin:open(FuryTowerRank:new():init(), fwin._ui)
			end
		end)
	elseif v.reset_available == 1 then
		askBuy(3)
	else
		showNotice({ notice = (v.floor == 0) and 6 or 2 })
	end
end)
terminal("fury_tower_buy_confirmed", function(params)
	if params ~= nil and params.status == 1 and params._datas ~= nil then
		local d = params._datas
		send(BUY, "fury_tower_buy", { tostring(d.tower), tostring(d.kind) }, function(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				showNotice(_ED.fury_tower)
				redraw()
			else
				FuryTowers_requestView(d.tower)
			end
		end)
	end
end)
terminal("fury_tower_help", function(params)
	fwin:close(fwin:find("FuryTowerRulesClass"))
	fwin:open(FuryTowerRules:new():init(), fwin._ui)
end)
terminal("fury_tower_popup_close", function(params)
	fwin:close(fwin:find("FuryTowerRulesClass"))
	fwin:close(fwin:find("FuryTowerRankClass"))
end)
state_machine.init()

-----------------------------------------------------------------------------------------------
-- LA PANTALLA: trial_tower.csb con otro tono, otro titulo y otra columna.
-----------------------------------------------------------------------------------------------
local function hide(root, name)
	local w = ccui.Helper:seekWidgetByName(root, name)
	if w ~= nil then
		w:setVisible(false)
	end
	return w
end

local function tint(root, name, color)
	local w = ccui.Helper:seekWidgetByName(root, name)
	if w ~= nil then
		w:setColor(color)
	end
end

local function fitWidth(label, width)
	local w = label:getVirtualRendererSize().width
	if w > width then
		label:setScale(width / w)
	end
end

function FuryTowerWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self.labels = {}
	app.load("client.cells.utils.resources_icon_cell")
end

function FuryTowerWindow:init(tower)
	self.tower = tower
	self:setTouchEnabled(true)
	return self
end

function FuryTowerWindow:onEnterTransitionFinish()
	local csbNode = csb.createNode("campaign/TrialTower/trial_tower.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local tone = TONES[self.tower] or TONES[1]
	for _, name in ipairs({ "Image_4_1_0", "Image_floor_bg", "Image_4_1_0_0", "Image_floor_bg_0",
		"Image_32_0", "Image_32" }) do
		tint(root, name, tone)
	end
	for _, name in ipairs({ "Panel_buff", "Image_star", "Text_star_n", "Image_sljf", "Text_jifen",
		"Image_buff_view", "Panel_floor", "Panel_player_ziji", "Button_shop",
		"Button_reward", "Button_rank", "Image_slb_icon", "Text_shilianbi_n" }) do
		hide(root, name)
	end

	-- El titulo: el de Snake Trial es arte con el nombre quemado; se oculta y
	-- se escribe encima.
	local titleArt = hide(root, "Text_title_shumashilian")
	local centered = false
	if titleArt == nil then
		-- NARUTO (prueba en pantalla 1-oct): el titulo quemado «Ninja Trial» es `Image_4_1` y el
		-- «Best in history N» (record de Ninja Trial, no de la torre) son `Image_lwszg*` + atlas.
		titleArt = hide(root, "Image_4_1")
		centered = titleArt ~= nil
		hide(root, "Image_lwszg_0")
		hide(root, "Image_lwszg")
		hide(root, "AtlasLabel_louceng")
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_jinbi_n"):getFontName()
	self.fontName = fontName
	if titleArt ~= nil then
		local title = ccui.Text:create(text(self.tower), fontName, 26)
		title:setColor(tone)
		title:enableOutline(cc.c4b(40, 20, 0, 255), 2)
		title:setAnchorPoint(titleArt:getAnchorPoint())
		title:setPosition(cc.p(titleArt:getPosition()))
		if centered then
			local box = titleArt:getContentSize()
			local anchor = titleArt:getAnchorPoint()
			title:setFontSize(34)
			title:setAnchorPoint(cc.p(0.5, 0.5))
			title:setPosition(cc.p(titleArt:getPositionX() + box.width * (0.5 - anchor.x),
				titleArt:getPositionY() + box.height * (0.5 - anchor.y)))
		end
		titleArt:getParent():addChild(title)
		fitWidth(title, 200)
	end

	local buttons = {
		{ "Button_back", "fury_tower_close", 3 },
		{ "Button_rule", "fury_tower_help", 0 },
		{ "Button_shop", "fury_tower_double", 0 },
		{ "Button_reward", "fury_tower_weaken", 0 },
		{ "Button_rank", "fury_tower_rank_or_reset", 0 },
	}
	for _, b in ipairs(buttons) do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, b[1]), nil,
			{ terminal_name = b[2], terminal_state = 0, isPressedActionEnabled = true }, nil, b[3])
	end

	-- Un rotulo debajo de cada boton de la columna y tres lineas de estado arriba
	-- (donde Snake Trial pinta estrellas y puntos).
	-- Los botones traen su nombre de Snake Trial quemado abajo («Ranking», «Tienda»...): una
	-- franja oscura lo tapa y el rotulo de la torre va encima, en una linea (visto 30-sep:
	-- debajo del boton se montaba con el nombre quemado del siguiente).
	for _, name in ipairs({ "Button_rule", "Button_shop", "Button_reward", "Button_rank" }) do
		local button = ccui.Helper:seekWidgetByName(root, name)
		local bsize = button:getContentSize()
		local anchor = button:getAnchorPoint()
		local centerX = button:getPositionX() + bsize.width * (0.5 - anchor.x)
		-- NARUTO: los botones son anchos (139x56) y su nombre es un Text hijo («Text_rule»...):
		-- el rotulo de la torre va en ese Text, centrado, sin franja.
		local inner = button:getChildByName("Text_" .. string.sub(name, 8))
		if inner ~= nil then
			inner:setAnchorPoint(cc.p(0.5, 0.5))
			inner:setPosition(cc.p(bsize.width / 2, bsize.height / 2))
			inner:setString("")
			self.labels[name] = inner
		end
		local y = button:getPositionY() - bsize.height * (button:getAnchorPoint().y - 0.18)
		if inner == nil then
		local band = ccui.Layout:create()
		band:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		band:setBackGroundColor(cc.c3b(10, 10, 20))
		band:setBackGroundColorOpacity(255)
		band:setContentSize(cc.size(136, 30))
		band:setAnchorPoint(cc.p(0.5, 0.5))
		band:setPosition(cc.p(centerX, y))
		button:getParent():addChild(band)
		local label = ccui.Text:create("", fontName, 15)
		label:enableOutline(cc.c4b(0, 0, 0, 255), 1)
		label:setPosition(cc.p(centerX, y))
		button:getParent():addChild(label)
		self.labels[name] = label
		end
	end
	local rule = ccui.Helper:seekWidgetByName(root, "Button_rule")
	local ruleX = rule:getPositionX() - rule:getContentSize().width * (rule:getAnchorPoint().x - 0.5)
	for i, y in ipairs({ 470, 430, 395 }) do
		local label = ccui.Text:create("", fontName, 18)
		label:enableOutline(cc.c4b(0, 0, 0, 255), 1)
		label:setPosition(cc.p(ruleX, y))
		rule:getParent():addChild(label)
		self.labels["status" .. i] = label
	end
	self:onUpdateDraw()
	self:registerOnNoteUpdate(self, 1)
end

local function clock(seconds)
	seconds = math.max(0, seconds)
	local d = math.floor(seconds / 86400)
	local h = math.floor((seconds % 86400) / 3600)
	local m = math.floor((seconds % 3600) / 60)
	if d > 0 then
		return string.format("%dd %02d:%02d", d, h, m)
	end
	return string.format("%02d:%02d:%02d", h, m, math.floor(seconds % 60))
end

-- La cuenta atras del reinicio automatico; al llegar a cero pide la torre otra vez.
function FuryTowerWindow:onUpdate(dt)
	local v = _ED.fury_tower
	local label = self.labels.status3
	if v ~= nil and label ~= nil and v.received_at ~= nil and v.tower == self.tower then
		local left = v.remaining - (os.time() - v.received_at)
		label:setString(string.format(text(4), clock(left)))
		fitWidth(label, 130)
		if left <= 0 and self.requested ~= true then
			self.requested = true
			FuryTowers_requestView(v.tower)
		end
	end
end

local function boostLabel(state, price)
	if state == 1 then
		return text(11), cc.c3b(80, 230, 80)
	elseif state == 2 then
		return text(12), cc.c3b(160, 160, 160)
	elseif state == 3 then
		return "-", cc.c3b(160, 160, 160)
	end
	return string.format(text(10), price), cc.c3b(255, 220, 90)
end

function FuryTowerWindow:onUpdateDraw()
	local root = self.roots[1]
	local v = _ED.fury_tower
	if root == nil or v == nil or v.tower ~= self.tower then
		return
	end
	self.requested = false
	local L = self.labels
	L.Button_rule:setString(text(29))
	local s, c = boostLabel(v.double_state, v.double_price)
	L.Button_shop:setString(text(6) .. ": " .. s)
	L.Button_shop:setColor(c)
	s, c = boostLabel(v.weaken_state, v.weaken_price)
	L.Button_reward:setString(text(7) .. ": " .. s)
	L.Button_reward:setColor(c)
	if v.tower == 1 then
		L.Button_rank:setString(text(9))
		L.Button_rank:setColor(cc.c3b(255, 255, 255))
	else
		-- Sin reinicio disponible sale solo el nombre en gris («Usado en este piso» no pinta nada
		-- aqui: el reinicio es semanal, no por piso).
		if v.reset_available == 1 then
			s, c = boostLabel(0, v.reset_price)
			L.Button_rank:setString(text(8) .. ": " .. s)
		else
			s, c = text(8), cc.c3b(160, 160, 160)
			L.Button_rank:setString(s)
		end
		L.Button_rank:setColor(c)
	end
	for _, name in ipairs({ "Button_rule", "Button_shop", "Button_reward", "Button_rank" }) do
		L[name]:setScale(1)
		fitWidth(L[name], 130)
	end
	L.status1:setString(string.format(text(3), v.floor, v.floors))
	if v.tower == 1 and v.rank_position > 0 then
		L.status2:setString(string.format(text(26), v.rank_position, v.floor))
	elseif v.tower == 1 then
		L.status2:setString(text(27))
	else
		L.status2:setString("")
	end
	fitWidth(L.status1, 130)
	fitWidth(L.status2, 130)

	-- La cabecera: plata y gemas como Snake Trial; la tercera, monedas premium.
	ccui.Helper:seekWidgetByName(root, "Text_jinbi_n"):setString(tostring(_ED.user_info.user_silver))
	ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n"):setString(tostring(_ED.user_info.user_gold))
	ccui.Helper:seekWidgetByName(root, "Text_shilianbi_n"):setString(tostring(v.balance))

	self:drawFloors(root, v)
end

-- Los pisos: el siguiente abajo y cinco por encima, con el arte del piso de
-- Snake Trial (numero, heroe, rival) y el premio de cada uno.
function FuryTowerWindow:drawFloors(root, v)
	local list = ccui.Helper:seekWidgetByName(root, "ListView_tower")
	list:removeAllItems()
	local tone = TONES[self.tower] or TONES[1]
	local first = math.min(v.floor + 1, v.floors)
	local last = math.min(v.floors, first + 5)
	local npcGroup = zstring.split(dms.string(dms["play_config"], 56, pirates_config.param), ",")
	for f = first, last do
		local row = self:createFloor(f, f == v.floor + 1, v, tone, npcGroup)
		if f == first then
			list:addChild(row)
		else
			list:insertCustomItem(row, 0)
		end
	end
	-- refreshView ya: con requestRefreshView el salto al fondo llegaba antes de colocar las
	-- filas y la lista se quedaba en los pisos de arriba (se veian el 5 y el 6, sin «Luchar»).
	list:refreshView()
	list:jumpToBottom()
end

local function strongestShip()
	local best, ship = -1, nil
	for i = 2, 7 do
		local s = _ED.user_ship["" .. tostring(_ED.formetion[i])]
		if s ~= nil and tonumber(s.hero_fight) > best then
			best = tonumber(s.hero_fight)
			ship = s
		end
	end
	return ship
end

function FuryTowerWindow:createFloor(f, current, v, tone, npcGroup)
	local csbNode = csb.createNode("campaign/TrialTower/sm_trial_tower_floor_list.csb")
	local root = csbNode:getChildByName("root")
	root:removeFromParent(false)
	local size = root:getContentSize()
	tint(root, "Image_floor_bg", tone)
	tint(root, "Image_line_2", tone)
	hide(root, "Image_buff")
	hide(root, "Image_box")
	hide(root, "Panel_black")
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_floor_number"):setString(tostring(f))

	-- El rival del piso: un dibujo de la lista de Snake Trial, fijo por piso.
	if #npcGroup > 0 and f > v.floor then
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_enemy")
		local index = tonumber(npcGroup[(f - 1) % #npcGroup + 1])
		if index ~= nil then
			local enemy = sp.spine_sprite(panel, index,
				spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			enemy.animationNameList = spineAnimations
			sp.initArmature(enemy, true)
		end
	end

	if current then
		local ship = strongestShip()
		if ship ~= nil then
			local panel = ccui.Helper:seekWidgetByName(root, "Panel_player")
			local bust = dms.int(dms["ship_evo_mould"], smGetSkinEvoIdChange(ship), ship_evo_mould.form_id)
			local hero = sp.spine_sprite(panel, bust,
				spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			hero:setScaleX(-1)
			hero.animationNameList = spineAnimations
			sp.initArmature(hero, true)
		end
		-- Tocar al rival o el boton «Luchar» empieza el combate.
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_object"), nil,
			{ terminal_name = "fury_tower_fight", terminal_state = 0, touch_black = true }, nil, 1)
		local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
		button:setTitleText(text(5))
		button:setTitleFontName(self.fontName)
		button:setTitleFontSize(22)
		button:setTitleColor(cc.c3b(90, 45, 10))
		fwin:fitButtonTitle(button)
		button:setPosition(cc.p(620, 60))
		root:addChild(button)
		fwin:addTouchEventListener(button, nil,
			{ terminal_name = "fury_tower_fight", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	end

	-- El premio del piso (con «x2» si el DOBLE esta puesto en el siguiente).
	local rewards = rewardList(v.rewards[f])
	local x = 520 - (#rewards - 1) * 38
	for _, r in ipairs(rewards) do
		local cell = ResourcesIconCell:createCell()
		cell:init(r[1], r[2], r[3], nil, nil, true, true, 1)
		cell:setScale(0.55)
		cell:setPosition(cc.p(x - 25, 235))
		root:addChild(cell)
		x = x + 76
	end
	if current and v.double_state == 1 then
		local x2 = ccui.Text:create("x2", self.fontName, 28)
		x2:setColor(cc.c3b(255, 220, 90))
		x2:enableOutline(cc.c4b(0, 0, 0, 255), 2)
		x2:setPosition(cc.p(x + 10, 262))
		root:addChild(x2)
	end

	local row = ccui.Layout:create()
	row:setContentSize(size)
	row:addChild(root)
	return row
end

function FuryTowerWindow:onExit()
	self:unregisterOnNoteUpdate(self)
end

-----------------------------------------------------------------------------------------------
-- LAS REGLAS: utils/common_popup_rule.csb (textos 30-36).
-----------------------------------------------------------------------------------------------
FuryTowerRules = class("FuryTowerRulesClass", Window)

function FuryTowerRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryTowerRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local v = _ED.fury_tower
	local tower = v ~= nil and v.tower or 1
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(tower))
	end
	local lines = {}
	for i = 30, 34 do
		lines[#lines + 1] = text(i)
	end
	lines[#lines + 1] = text(tower == 1 and 35 or 36)
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		body:setString(table.concat(lines, "\n"))
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
		{ terminal_name = "fury_tower_popup_close", terminal_state = 0, isPressedActionEnabled = true }, nil, 0)
	return self
end

function FuryTowerRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL RANKING DIARIO (top 50): la maqueta de lista de la tienda de suscripciones
-- (activity/wonderful/sm_limited_time_equip_box_help.csb).
-----------------------------------------------------------------------------------------------
FuryTowerRank = class("FuryTowerRankClass", Window)

function FuryTowerRank:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryTowerRank:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
		{ terminal_name = "fury_tower_popup_close", terminal_state = 0, touch_black = true }, nil, 3)
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(25))
	local fontName = title:getFontName()
	local list = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	list:removeAllItems()
	local width = list:getContentSize().width
	local r = _ED.fury_tower_rank or { rows = {}, my_position = 0, my_floor = 0 }
	local function line(str, color, size)
		local row = ccui.Layout:create()
		row:setContentSize(cc.size(width, 38))
		local label = ccui.Text:create(str, fontName, size or 20)
		label:setAnchorPoint(cc.p(0, 0.5))
		label:setPosition(cc.p(16, 19))
		label:setColor(color)
		row:addChild(label)
		fitWidth(label, width - 32)
		list:addChild(row)
	end
	if r.my_position > 0 then
		line(string.format(text(26), r.my_position, r.my_floor), cc.c3b(255, 220, 90), 22)
	else
		line(text(27), cc.c3b(200, 200, 200), 22)
	end
	-- Los premios por puesto, con sus iconos (tocar uno ensena que es). Victor, 30-sep.
	if #(r.rewards or {}) > 0 then
		app.load("client.cells.utils.resources_icon_cell")
		line(text(37), cc.c3b(255, 180, 60), 22)
		for _, t in ipairs(r.rewards) do
			local row = ccui.Layout:create()
			row:setContentSize(cc.size(width, 66))
			local str = t.from == t.to and string.format(text(38), t.from) or string.format(text(39), t.from, t.to)
			local label = ccui.Text:create(str, fontName, 22)
			label:setAnchorPoint(cc.p(0, 0.5))
			label:setPosition(cc.p(16, 33))
			label:setColor(cc.c3b(255, 255, 255))
			row:addChild(label)
			local x = 150
			for _, f in ipairs(t.items) do
				local cell = ResourcesIconCell:createCell()
				cell:init(f[1], f[3], f[2], nil, nil, true, true, 1)
				local cs = cell:getContentSize()
				local sc = (cs.height ~= nil and cs.height > 0) and 58 / cs.height or 0.5
				cell:setScale(sc)
				cell:setPosition(cc.p(x, 4))
				row:addChild(cell)
				x = x + 70
			end
			list:addChild(row)
		end
		line(text(25), cc.c3b(255, 180, 60), 22)
	end
	for _, row in ipairs(r.rows) do
		local color = cc.c3b(255, 255, 255)
		if tostring(row.role_id) == tostring(_ED.user_info.user_id) then
			color = cc.c3b(80, 230, 80)
		end
		line(string.format(text(28), row.position, row.name, row.floor), color)
	end
	list:requestRefreshView()
	return self
end

function FuryTowerRank:onExit()
end

-----------------------------------------------------------------------------------------------
-- LA ENTRADA: dos paneles en la pantalla de mazmorras (ExploreWindow), clonados
-- del panel de Snake Trial (Panel_maoxian_fun_2) en una tercera columna y
-- tenidos del tono de cada torre. Mismo candado de nivel que Snake Trial.
-----------------------------------------------------------------------------------------------
function FuryTowers_addExploreEntries(root)
	local scroll = ccui.Helper:seekWidgetByName(root, "ScrollView_maoxian_fun")
	local base = scroll ~= nil and scroll:getChildByName("Panel_maoxian_fun_2") or nil
	if base == nil or scroll:getChildByName("Panel_fury_tower_1") ~= nil then
		return
	end
	local locked = funOpenDrawTip(FUN_OPEN_ID, false) ~= false
	local column = 888
	-- NARUTO (prueba en pantalla 1-oct): su maoxian.csb es UNA fila de pergaminos de 278x500 que se
	-- solapan 10 px (no la rejilla 2x3 de Fury), y la tercera columna de Fury caia ENCIMA de «Relic»
	-- (la semanal) y fuera de la vista (la diaria, en y = 262). Si en el alto no caben dos paneles, las
	-- torres van detras del ultimo, en la misma fila. Las X de los paneles no sirven: en este momento
	-- ExploreWindow los esta trayendo desde x = 1240.
	local baseSize = base:getContentSize()
	local oneRow = scroll:getContentSize().height < 2 * baseSize.height
	local count = 0
	while scroll:getChildByName("Panel_maoxian_fun_" .. (count + 1)) ~= nil do
		count = count + 1
	end
	local step = baseSize.width - 10
	for tower = 1, 2 do
		local panel = base:clone()
		panel:setName("Panel_fury_tower_" .. tower)
		panel:stopAllActions()
		if oneRow then
			panel:setPosition(cc.p((count + tower - 1) * step, base:getPositionY()))
		else
			panel:setPosition(cc.p(column, tower == 1 and 262 or 0))
		end
		scroll:addChild(panel)
		local pic = ccui.Helper:seekWidgetByName(panel, "Image_maoxian_fun_pic_2")
		-- Arte PROPIO (tools/torres_arte.py, con arte del paquete): antes era la tarjeta de Snake
		-- Trial tenida y se confundia con ella (Victor, 30-sep).
		pic:loadTexture("images/ui/play/bg_fury_tower_" .. tower .. ".png")
		local lock = ccui.Helper:seekWidgetByName(panel, "Image_maoxian_lock_2")
		if lock ~= nil then
			lock:setVisible(locked)
		end
		-- El nombre de la torre en grande, abajo a la izquierda, con contorno y SIN franja de fondo
		-- (el mismo estilo de rotulo que los iconos nuevos de la ciudad; Victor, 30-sep).
		local fontName = ""
		for _, name in ipairs({ "Text_56_0_0", "Text_56_0_0_0" }) do
			local label = ccui.Helper:seekWidgetByName(panel, name)
			if label ~= nil then
				fontName = label:getFontName()
				label:setString("")
			end
		end
		local size = pic:getContentSize()
		local title = ccui.Text:create(text(tower), fontName, 44)
		title:setColor(cc.c3b(255, 214, 64))
		title:enableOutline(cc.c4b(60, 20, 0, 255), 4)
		title:setAnchorPoint(cc.p(0, 0))
		title:setPosition(cc.p(24, 22))
		if oneRow then
			-- abajo lo tapa la barandilla de madera; arriba, como los rotulos quemados de los demas
			title:setAnchorPoint(cc.p(0, 1))
			title:setPosition(cc.p(24, size.height - 50))
		end
		fitWidth(title, size.width * 0.62)
		pic:addChild(title)
		fwin:addTouchEventListener(pic, nil,
			{ terminal_name = "fury_towers_open", terminal_state = 0, tower = tower,
			  locked = locked, isPressedActionEnabled = true }, nil, 0)
	end
	local inner = scroll:getInnerContainerSize()
	local needed = oneRow and ((count + 1) * step + baseSize.width) or (column + 430)
	scroll:setInnerContainerSize(cc.size(math.max(inner.width, needed), inner.height))
	if inner.height <= scroll:getContentSize().height then
		scroll:setDirection(ccui.ScrollViewDir.horizontal)
	end
	FuryTowers_addScrollHint(scroll)
end

-- Las torres quedan en una TERCERA columna, fuera de la vista: Victor no las veia (30-sep). Una
-- flecha azul que late en el borde derecho dice que hay mas; tocarla desliza hasta las torres y se
-- esconde cuando ya se ven (vuelve si el jugador desliza de nuevo a la izquierda).
function FuryTowers_addScrollHint(scroll)
	local parent = scroll:getParent()
	if parent == nil or parent:getChildByName("Button_fury_tower_hint") ~= nil then
		return
	end
	local arrow = ccui.Button:create("images/ui/button/tongyong_jiantou_03.png",
		"images/ui/button/tongyong_jiantou_03.png")
	arrow:setName("Button_fury_tower_hint")
	local sx, sy = scroll:getPosition()
	local view = scroll:getContentSize()
	arrow:setPosition(cc.p(sx + view.width - 30, sy + view.height / 2))
	parent:addChild(arrow, 10)
	arrow:runAction(cc.RepeatForever:create(cc.Sequence:create(
		cc.MoveBy:create(0.45, cc.p(14, 0)), cc.MoveBy:create(0.45, cc.p(-14, 0)))))
	arrow:addTouchEventListener(function(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			scroll:scrollToPercentHorizontal(100, 0.5, true)
		end
	end)
	local function refresh()
		if tolua.isnull(scroll) or tolua.isnull(arrow) then
			return
		end
		local hidden = scroll:getInnerContainerSize().width - view.width
		arrow:setVisible(hidden > 20 and scroll:getInnerContainer():getPositionX() > -hidden + 20)
	end
	arrow:runAction(cc.RepeatForever:create(cc.Sequence:create(
		cc.DelayTime:create(0.2), cc.CallFunc:create(refresh))))
end
