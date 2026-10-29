-----------------------------------------------------------------------------------------------
-- EL JEFE INTERSERVIDOR DIARIO: «LA INVASION DE FREEZER» (Fury, sistema D, 29-sep-2026;
-- docs/systems/jefe_interservidor.md).
--
-- Es la ventana del Juego de Cell (campaign/world_boss/world_boss.csb y los metodos de
-- WorldBossWindow.lua, prestados tal cual) con OTRA CLASE, otro jefe y tres comandos
-- PROPIOS. La clase distinta importa: los troceadores del jefe (12656/12659) solo
-- repintan o reenvian el 9115 del Juego de Cell si encuentran "WorldBossWindowClass";
-- con esta abierta no tocan nada.
--
--   C2S 29050 fury_cross_boss_init       rol                    -> 12659 12658 12656 12657 12660
--   C2S 29051 fury_cross_boss_attack     rol, equipo «id|id|..» -> 206 182 39 12658 12656 12667
--   C2S 29052 fury_cross_boss_get_order  rol, tipo, desde, hasta -> 12657 12660
-- Los bloques S2C son los del Juego de Cell (mismos troceadores). El 12658 trae ademas
-- `npcId`: el jefe no es una fila de world_boss, se pinta desde el npc (1219, Freezer).
--
-- Tras el combate, WorldBossFightReward -> ExplorationLoading(218) -> "world_boss_window_open";
-- ese terminal (WorldBossWindow.lua) mira `_ED.fury_cross_boss_return` y vuelve AQUI.
-- TRES golpes al dia (lista de Victor, 30-sep): el servidor manda (-283 si ya no quedan, -336
-- fuera de 20:00-21:00). Cada golpe paga al momento (oro + 2 monedas premium): al volver se
-- avisa. El bloque PROPIO S2C 29053 (en el 29050 y en el 29051) trae los ataques usados/tope,
-- el premio del golpe, los tramos por puesto y el de participacion; el boton «Recompensa»
-- (Button_boss_reward, el de las tareas de Cell) los ensena.
-- Textos: `_fury_cross_boss_text` de TipStringInfo.lua (12 idiomas).
-----------------------------------------------------------------------------------------------
app.load("client.l_digital.campaign.worldboss.WorldBossWindow")

FuryCrossBossWindow = class("FuryCrossBossWindowClass", Window)

local INIT_CODE, ATTACK_CODE, ORDER_CODE, INFO_CODE = 29050, 29051, 29052, 29053

local function text(i)
	return _fury_cross_boss_text ~= nil and _fury_cross_boss_text[i] or ""
end

local function own_command(key)
	return function(str)
		local item = protocol_command[key]
		str = str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
		return str
	end
end

-- «tipo,molde,cantidad|...» -> { {type, mould, count}, ... }. «-» (vacio) da una lista vacia.
local function parseReward(str)
	local out = {}
	for group in string.gmatch(tostring(str or ""), "[^|]+") do
		local f = {}
		for field in string.gmatch(group, "[^,]+") do
			f[#f + 1] = tonumber(field) or 0
		end
		if #f >= 3 and f[3] > 0 then
			out[#out + 1] = { type = f[1], mould = f[2], count = f[3] }
		end
	end
	return out
end

-- S2C 29053: usados, tope, premio del golpe, N tramos (desde, hasta, premio) y participacion.
local function parse_fury_cross_boss_info(interpreter, datas, pos, strDatas, list, count)
	local info = { tiers = {} }
	info.used = tonumber(npos(list)) or 0
	info.max = tonumber(npos(list)) or 0
	info.hit = parseReward(npos(list))
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local from = tonumber(npos(list)) or 0
		local to = tonumber(npos(list)) or 0
		info.tiers[#info.tiers + 1] = { from = from, to = to, reward = parseReward(npos(list)) }
	end
	info.participation = parseReward(npos(list))
	_ED.fury_cross_boss_info = info
end

-- Da de alta (o vuelve a dar) los tres comandos y el bloque 29053. Idempotente.
function FuryCrossBoss_ensureProtocol()
	local defs = {
		{ "fury_cross_boss_init", INIT_CODE },
		{ "fury_cross_boss_attack", ATTACK_CODE },
		{ "fury_cross_boss_get_order", ORDER_CODE },
	}
	for _, d in ipairs(defs) do
		protocol_command[d[1]] = protocol_command[d[1]] or
			{ code = d[2], command = d[1], command_fun = own_command(d[1]), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == INFO_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = INFO_CODE, parser = "parse_fury_cross_boss_info",
		parser_fun = parse_fury_cross_boss_info })
end

local function itemName(kind, mould)
	local ok, info = pcall(getItemNameAndQuality, { kind, mould, 1 })
	if ok and info ~= nil and info[1] ~= nil then
		return tostring(info[1])
	end
	return ""
end

-- Metodos del Juego de Cell que valen tal cual.
for _, m in ipairs({ "updateBossTime", "onUpdateDraw", "onUpdateRankDraw", "addnewlistCell",
		"drawFormationList", "oneKeyFormationChange", "joinFormtion", "formationPosChange",
		"backupFormation", "revertFormation" }) do
	FuryCrossBossWindow[m] = WorldBossWindow[m]
end

local function terminal(name, invoke)
	return {
		_name = name,
		_init = function (terminal) end,
		_inited = false,
		_instance = nil,
		_state = 0,
		_invoke = invoke,
		_terminal = nil,
		_terminals = nil
	}
end

local function requestInit(callback)
	FuryCrossBoss_ensureProtocol()
	protocol_command.fury_cross_boss_init.param_list = ""
	NetworkManager:register(INIT_CODE, nil, nil, nil, nil, callback, false, nil)
end

state_machine.add(terminal("fury_cross_boss_open", function(terminal, instance, params)
	_ED.fury_cross_boss_return = nil
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if fwin:find("FuryCrossBossWindowClass") == nil then
				fwin:open(FuryCrossBossWindow:new(), fwin._view)
			end
		end
	end
	-- Las listas se ACUMULAN en el troceador: se vacian antes de pedir las nuestras.
	_ED.world_boss_personal_rank = nil
	_ED.world_boss_union_rank = nil
	requestInit(callback)
	state_machine.unlock("explore_window_open_fun_window")
	return true
end))

state_machine.add(terminal("fury_cross_boss_close", function(terminal, instance, params)
	fwin:cleanView(fwin._view)
	app.load("client.home.Menu")
	if fwin:find("MenuClass") == nil then
		fwin:open(Menu:new(), fwin._taskbar)
	end
	if fwin:find("HomeClass") == nil then
		state_machine.excute("menu_manager", 0,
			{
				_datas = {
					terminal_name = "menu_manager",
					next_terminal_name = "menu_show_home_page",
					current_button_name = "Button_home",
					but_image = "Image_home",
					terminal_state = 0,
					isPressedActionEnabled = true
				}
			}
		)
	end
	state_machine.excute("menu_back_home_page", 0, "")
	fwin:close(fwin:find("FuryCrossBossWindowClass"))
	return true
end))

state_machine.add(terminal("fury_cross_boss_rules_open", function(terminal, instance, params)
	if fwin:find("FuryCrossBossRulesClass") == nil then
		fwin:open(FuryCrossBossRules:new():init(), fwin._ui)
	end
	return true
end))

state_machine.add(terminal("fury_cross_boss_rules_close", function(terminal, instance, params)
	fwin:close(fwin:find("FuryCrossBossRulesClass"))
	return true
end))

state_machine.add(terminal("fury_cross_boss_rewards_open", function(terminal, instance, params)
	if fwin:find("FuryCrossBossRewardsClass") == nil then
		fwin:open(FuryCrossBossRewards:new():init(), fwin._ui)
	end
	return true
end))

state_machine.add(terminal("fury_cross_boss_rewards_close", function(terminal, instance, params)
	if fwin:find("FuryCrossBossRewardsClass") then
		fwin:close(fwin:find("FuryCrossBossRewardsClass"))
	end
	return true
end))

state_machine.add(terminal("fury_cross_boss_icon", function(terminal, instance, params)
	state_machine.excute("menu_clean_page_state", 0, "home")
	state_machine.excute("fury_cross_boss_open", 0, "")
	return true
end))
state_machine.init()

function FuryCrossBossWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self:backupFormation()
	self.starting_point = 1
	self.end_point = 10
	self.ranktype = 1
	app.load("client.cells.ship.hero_icon_list_cell")
	app.load("client.packs.hero.HeroFormationChoiceWear")
	app.load("client.l_digital.cells.worldboss.world_boss_ranking_cell")

	-- Los terminales que llaman los metodos prestados (mismos nombres que en la
	-- ventana de Cell, que los vuelve a registrar cada vez que se abre ella).
	local list = {
		terminal("world_boss_open_join_formation_window", function(terminal, instance, params)
			state_machine.excute("hero_formation_choice_wear_window_open", 0,
				{params._datas.cell_index, 1, -1, nil, "world_boss_join_formation", params._datas.cell_index})
			return true
		end),
		terminal("world_boss_join_formation", function(terminal, instance, params)
			instance:joinFormtion(params)
			return true
		end),
		terminal("world_boss_formation_change_request", function(terminal, instance, params)
			instance:formationPosChange(params)
			return true
		end),
		terminal("world_boss_rebel_boss_update_rank", function(terminal, instance, params)
			instance:requestMoreRank()
			return true
		end),
		terminal("fury_cross_boss_join_battle", function(terminal, instance, params)
			state_machine.lock("fury_cross_boss_join_battle")
			instance:fight()
			return true
		end),
		terminal("fury_cross_boss_open_formation", function(terminal, instance, params)
			local panel = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_boss_line")
			panel:setVisible(not panel:isVisible())
			return true
		end),
		terminal("fury_cross_boss_formation_change", function(terminal, instance, params)
			app.load("client.formation.FormationChange")
			app.load("client.home.HomeHero")
			state_machine.excute("formation_change_window_open", 0, {nil, "world_boss_formation_change_request", nil})
			return true
		end),
		terminal("fury_cross_boss_one_key", function(terminal, instance, params)
			instance:oneKeyFormationChange(params)
			return true
		end),
		terminal("fury_cross_boss_rank_tab", function(terminal, instance, params)
			instance:requestRank()
			return true
		end),
	}
	for _, t in ipairs(list) do
		t._instance = self
		state_machine.add(t)
	end
	state_machine.init()
end

function FuryCrossBossWindow:onUpdate(dt)
	self:updateAttackTime(os.time() + _ED.time_add_or_sub)
	self:updateBossTime(os.time() + _ED.time_add_or_sub)
	self:drawAttacksLeft()
end

-- «Ataques de hoy: N/3», encima del boton de desafio.
function FuryCrossBossWindow:drawAttacksLeft()
	local info = _ED.fury_cross_boss_info
	if self.attacksLabel == nil or info == nil then
		return
	end
	self.attacksLabel:setString(string.format(text(13), info.used, info.max))
end

-- Como la de Cell, pero sin «reiniciar la espera»: aqui la espera es hasta manana.
function FuryCrossBossWindow:updateAttackTime(times)
	local root = self.roots[1]
	if root == nil or not self.Text_boos_challenge_cool_time or not _ED.world_boss_my_info or not _ED.world_boss_my_info.nextAttackDate then
		return
	end
	local Button_boss_challenge = ccui.Helper:seekWidgetByName(root, "Button_boss_challenge")
	local Image_119 = ccui.Helper:seekWidgetByName(root, "Image_119")
	local Text_boos_challenge_cool = ccui.Helper:seekWidgetByName(root, "Text_boos_challenge_cool")
	ccui.Helper:seekWidgetByName(root, "Button_boss_reset_cooling"):setVisible(false)
	local surplus_time = tonumber(_ED.world_boss_my_info.nextAttackDate) - times * 1000
	local waiting = surplus_time > 0
	if waiting then
		self.Text_boos_challenge_cool_time:setString(getRedAlertTimeActivityFormat(surplus_time / 1000))
	else
		self.Text_boos_challenge_cool_time:setString("00:00:00")
	end
	self.Text_boos_challenge_cool_time:setVisible(waiting)
	Image_119:setVisible(waiting)
	Text_boos_challenge_cool:setVisible(waiting)
	Button_boss_challenge:setVisible(not waiting and tonumber(_ED.world_boss_open_info.status) == 1)
end

-- Sin tareas diarias: el punto rojo nunca se enciende.
function FuryCrossBossWindow:worldBossDailyTaskRedot()
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_red_2"):setVisible(false)
end

-- El jefe sale del npc que dice el servidor (`npcId` del 12658).
function FuryCrossBossWindow:drawWorldBossInfo()
	local root = self.roots[1]
	local Panel_boss_head = ccui.Helper:seekWidgetByName(root, "Panel_boss_head")
	local Text_boss_name = ccui.Helper:seekWidgetByName(root, "Text_boss_name")
	local Text_boss_blood = ccui.Helper:seekWidgetByName(root, "Text_boss_blood")
	local LoadingBar_npc_hp = ccui.Helper:seekWidgetByName(root, "LoadingBar_npc_hp")
	self.Text_boos_challenge_cool_time = ccui.Helper:seekWidgetByName(root, "Text_boos_challenge_cool_time")
	self.Text_boss_act_time = ccui.Helper:seekWidgetByName(root, "Text_boss_act_time")
	local Text_boss_act_time_t = ccui.Helper:seekWidgetByName(root, "Text_boss_act_time_t")
	Panel_boss_head:removeAllChildren(true)
	Text_boss_name:setString("")

	local npcId = tonumber(_ED.world_boss_info.npcId) or 0
	if npcId > 0 then
		local formation = dms.int(dms["npc"], npcId, npc.environment_formation1)
		for i = 1, 6 do
			local shipId = dms.int(dms["environment_formation"], formation, environment_formation.seat_one + i - 1)
			if shipId ~= 0 then
				local bust = dms.int(dms["environment_ship"], shipId, environment_ship.pic_index)
				app.load("client.battle.fight.FightEnum")
				sp.spine_sprite(Panel_boss_head, bust, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
				local bossScale = dms.searchs(dms["role_high"], pokemon_high.hero_fight_state_id, tonumber(bust))
				if bossScale ~= nil and bossScale[1] ~= nil then
					Panel_boss_head:setScale(tonumber(bossScale[1][7]))
				end
				break
			end
		end
		local name = ""
		for _, v in pairs(zstring.split(dms.string(dms["npc"], npcId, npc.npc_name), "|")) do
			local word = dms.element(dms["word_mould"], zstring.tonumber(v))
			if word ~= nil then
				name = name .. word[3]
			end
		end
		Text_boss_name:setString(name)
	end

	local maxHp = math.max(1, tonumber(_ED.world_boss_info.maxHp) or 1)
	local leftHp = tonumber(_ED.world_boss_info.leftHp) or 0
	Text_boss_blood:setString(string.format("%0.2f%%", leftHp / maxHp * 100))
	LoadingBar_npc_hp:setPercent(leftHp / maxHp * 100)
	ccui.Helper:seekWidgetByName(root, "Image_explor_boss_hurt"):setVisible(leftHp <= 0)
	ccui.Helper:seekWidgetByName(root, "Text_cooling_gem_n"):setString("")

	local str = tonumber(_ED.world_boss_open_info.status) == 0 and tipStringInfo_world_boss[11] or tipStringInfo_world_boss[12]
	Text_boss_act_time_t:setString(str)
end

function FuryCrossBossWindow:requestRank()
	local window = self
	local function callBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and fwin:find("FuryCrossBossWindowClass") ~= nil then
			window:onUpdateRankDraw(1)
			window:hideGuildTab()
		end
	end
	self.ranktype = 1
	self.starting_point = 1
	self.end_point = 10
	_ED.world_boss_personal_rank = nil
	_ED.world_boss_union_rank = nil
	FuryCrossBoss_ensureProtocol()
	protocol_command.fury_cross_boss_get_order.param_list = "1\r\n1\r\n10"
	NetworkManager:register(ORDER_CODE, nil, nil, nil, self, callBack, false, nil)
end

function FuryCrossBossWindow:requestMoreRank()
	if tonumber(_ED.world_boss_personal_size or 0) < self.end_point then
		return
	end
	local window = self
	local function callBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and fwin:find("FuryCrossBossWindowClass") ~= nil then
			window.starting_point = window.starting_point + 10
			window.end_point = window.end_point + 10
			window:addnewlistCell(1)
		end
	end
	FuryCrossBoss_ensureProtocol()
	protocol_command.fury_cross_boss_get_order.param_list = "1\r\n" .. (self.starting_point + 10) .. "\r\n" .. (self.end_point + 10)
	NetworkManager:register(ORDER_CODE, nil, nil, nil, self, callBack, false, nil)
end

-- La pestana de gremios no existe aqui (la clasificacion es por jugador).
function FuryCrossBossWindow:hideGuildTab()
	local root = self.roots[1]
	for _, name in ipairs({ "Button_integral_add", "Text_add_0", "Text_everyday" }) do
		local w = ccui.Helper:seekWidgetByName(root, name)
		if w ~= nil then
			w:setVisible(false)
		end
	end
end

-- El combate lo resuelve el servidor (29051), como el de Cell (9248).
function FuryCrossBossWindow:fight()
	local shipIds = { 0, 0, 0, 0, 0, 0 }
	for idx = 1, 6 do
		local shipID = _ED.formetion[idx + 1]
		if tonumber(shipID) > 0 and _ED.user_ship[shipID] ~= nil then
			shipIds[idx] = shipID
		end
	end
	local function responseBattleInitCallback(response)
		state_machine.unlock("fury_cross_boss_join_battle")
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node == nil or response.node.roots == nil then
				return
			end
			-- Al salir del combate se vuelve a ESTA ventana, no a la de Cell, y alli se avisa
			-- del premio del golpe (ya entregado por el servidor en esta respuesta).
			_ED.fury_cross_boss_return = true
			_ED.fury_cross_boss_hit_pending = true
			fwin:cleanView(fwin._windows)
			cc.Director:getInstance():purgeCachedData()
			cacher.removeAllTextures()
			app.load("client.battle.report.BattleReport")
			app.load("client.battle.BattleStartEffect")
			local bse = BattleStartEffect:new()
			bse:init(_enum_fight_type._fight_type_218)
			fwin:open(bse, fwin._windows)
		end
	end
	FuryCrossBoss_ensureProtocol()
	protocol_command.fury_cross_boss_attack.param_list = table.concat(shipIds, "|")
	NetworkManager:register(ATTACK_CODE, nil, nil, nil, self, responseBattleInitCallback, false, nil)
end

function FuryCrossBossWindow:onEnterTransitionFinish()
	local csbNode = csb.createNode("campaign/world_boss/world_boss.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- El titulo «Cell Game» es dibujo (images/ui/text/boss/title_boss.png en
	-- Image_jinjichang): se tapa y se escribe el nuestro en su sitio.
	local title = ccui.Helper:seekWidgetByName(root, "Image_jinjichang")
	if title ~= nil then
		title:setVisible(false)
		local label = ccui.Text:create(text(1), fontName, 26)
		label:setColor(cc.c3b(255, 222, 60))
		label:enableOutline(cc.c4b(90, 30, 0, 255), 2)
		label:setAnchorPoint(title:getAnchorPoint())
		label:setPosition(cc.p(title:getPositionX(), title:getPositionY()))
		title:getParent():addChild(label)
	end

	local function bind(name, terminal_name)
		local w = ccui.Helper:seekWidgetByName(root, name)
		if w ~= nil then
			fwin:addTouchEventListener(w, nil,
				{ terminal_name = terminal_name, isPressedActionEnabled = true }, nil, 0)
		end
	end
	bind("Button_integral_everyday", "fury_cross_boss_rank_tab")
	bind("Button_boss_lineup", "fury_cross_boss_open_formation")
	bind("Button_boss_rule", "fury_cross_boss_rules_open")
	bind("Button_boss_challenge", "fury_cross_boss_join_battle")
	bind("Button_phb_back", "fury_cross_boss_close")
	bind("Panel_boss_line", "fury_cross_boss_open_formation")
	bind("Button_em_line_change", "fury_cross_boss_formation_change")
	bind("Button_em_line", "fury_cross_boss_one_key")
	-- Sin tareas diarias ni reinicio de espera ni pestana de gremios. El boton de las tareas
	-- de Cell («Recompensa», arte con el texto en cada idioma) abre los premios por puesto.
	bind("Button_boss_reward", "fury_cross_boss_rewards_open")
	ccui.Helper:seekWidgetByName(root, "Image_red_2"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Button_boss_reset_cooling"):setVisible(false)

	-- Los ataques que quedan hoy, encima del boton de desafio.
	local challenge = ccui.Helper:seekWidgetByName(root, "Button_boss_challenge")
	if challenge ~= nil then
		self.attacksLabel = ccui.Text:create("", fontName, 20)
		self.attacksLabel:setColor(cc.c3b(255, 222, 60))
		self.attacksLabel:enableOutline(cc.c4b(60, 20, 0, 255), 2)
		self.attacksLabel:setPosition(cc.p(challenge:getPositionX(),
			challenge:getPositionY() + challenge:getContentSize().height * (1 - challenge:getAnchorPoint().y) + 14))
		challenge:getParent():addChild(self.attacksLabel)
	end

	self:onUpdateDraw()
	self:hideGuildTab()
	self:drawAttacksLeft()

	-- Vuelta de un combate: el premio del golpe ya esta en la mochila; se dice cual.
	if _ED.fury_cross_boss_hit_pending then
		_ED.fury_cross_boss_hit_pending = nil
		local info = _ED.fury_cross_boss_info
		if info ~= nil and #info.hit > 0 then
			local parts = {}
			for _, r in ipairs(info.hit) do
				parts[#parts + 1] = itemName(r.type, r.mould) .. " x" .. r.count
			end
			TipDlg.drawTextDailog(string.format(text(14), table.concat(parts, ", ")))
		end
	end
end

function FuryCrossBossWindow:init()
end

function FuryCrossBossWindow:onExit()
	_ED.world_boss_personal_rank = nil
	_ED.world_boss_union_rank = nil
	self:revertFormation()
end

-----------------------------------------------------------------------------------------------
-- La ventana de reglas (el «?»): utils/common_popup_rule.csb con `_fury_cross_boss_text` 3..7.
-----------------------------------------------------------------------------------------------
FuryCrossBossRules = class("FuryCrossBossRulesClass", Window)

function FuryCrossBossRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryCrossBossRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(2))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		local lines = {}
		for i = 3, 7 do
			lines[#lines + 1] = text(i)
		end
		body:setString(table.concat(lines, "\n"))
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fury_cross_boss_rules_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	return self
end

function FuryCrossBossRules:onExit()
end

-----------------------------------------------------------------------------------------------
-- LOS PREMIOS (boton «Recompensa»): activity/wonderful/sm_limited_time_equip_box_help.csb (la
-- lista de Codigos/Suscripciones), una fila por tramo con sus iconos: cada golpe, puesto 1,
-- 2-3, 4-10, 11-50, 51-100 y participacion. Los datos, del S2C 29053 (servidor).
-----------------------------------------------------------------------------------------------
FuryCrossBossRewards = class("FuryCrossBossRewardsClass", Window)

function FuryCrossBossRewards:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
end

function FuryCrossBossRewards:init()
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(8))
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{ terminal_name = "fury_cross_boss_rewards_close", terminal_state = 0, touch_black = true }, nil, 3)

	local info = _ED.fury_cross_boss_info or { tiers = {}, hit = {}, participation = {} }
	local rows = {}
	if #info.hit > 0 then
		rows[#rows + 1] = { label = text(12), reward = info.hit }
	end
	for _, t in ipairs(info.tiers) do
		local label = t.from == t.to and string.format(text(9), t.from) or string.format(text(10), t.from, t.to)
		rows[#rows + 1] = { label = label, reward = t.reward }
	end
	if #info.participation > 0 then
		rows[#rows + 1] = { label = text(11), reward = info.participation }
	end

	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	local font = title:getFontName()
	listView:removeAllItems()
	local width = listView:getContentSize().width
	for _, r in ipairs(rows) do
		local row = ccui.Layout:create()
		row:setContentSize(cc.size(width, 100))
		local name = ccui.Text:create(r.label, font, 22)
		name:setAnchorPoint(cc.p(0, 0.5))
		name:setPosition(cc.p(10, 50))
		name:setColor(cc.c3b(255, 222, 60))
		row:addChild(name)
		local w = name:getVirtualRendererSize().width
		if w > 150 then
			name:setScale(150 / w)
		end
		for i, g in ipairs(r.reward) do
			local cell = ResourcesIconCell:createCell()
			cell:init(g.type, g.count, g.mould, nil, nil, true, true, 1)
			cell:setScale(0.75)
			cell:setPosition(cc.p(165 + (i - 1) * 88, 10))
			row:addChild(cell)
		end
		listView:addChild(row)
	end
	listView:requestRefreshView()
	return self
end

function FuryCrossBossRewards:onExit()
end

-----------------------------------------------------------------------------------------------
-- EL ICONO DE LA CIUDAD (Home.lua; activity_type 20050, sin fila en activity_sorting_mould).
-- Maqueta del icono «Codigos» (activity/icon/activity_shizishou.csb) con el dibujo nuevo
-- zc_icon_fury_xboss.png (la cara de Freezer, props_103901, sobre zc_icon_28.png).
-----------------------------------------------------------------------------------------------
FuryCrossBossCell = class("FuryCrossBossCellClass", Window)

function FuryCrossBossCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryCrossBossCell:init()
	local csbCell = csb.createNode("activity/icon/activity_shizishou.csb")
	local root = csbCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())

	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	local art = "images/ui/text/sm_hd/zc_icon_fury_xboss.png"
	button:loadTextures(art, art, art)
	local label = fwin:furyCityIconCaption(root)
	if label ~= nil then
		label:setString(text(1))
		label:setVisible(true)
		local w = label:getVirtualRendererSize().width
		if w > 74 then
			label:setScale(74 / w)
		end
	end
	fwin:furyCityIconLabel(label)
	local timer = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p")
	if timer ~= nil then
		timer:setString("")
	end
	fwin:addTouchEventListener(button, nil,
	{
		terminal_name = "fury_cross_boss_icon",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function FuryCrossBossCell:createCell()
	local cell = FuryCrossBossCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function FuryCrossBossCell:onExit()
end
