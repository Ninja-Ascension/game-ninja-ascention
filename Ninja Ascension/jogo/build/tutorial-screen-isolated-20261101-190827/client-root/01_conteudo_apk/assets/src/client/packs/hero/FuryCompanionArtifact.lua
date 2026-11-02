-----------------------------------------------------------------------------------------------
-- LOS ARTEFACTOS DE COMPANERO (Fury, sistema F, 29-sep-2026; docs/systems/artefactos_companero.md).
--
-- Se abre desde el boton «Artefacto» del marco de botones del heroe (FuryHeroExtras.lua),
-- terminal `fury_companion_artifact_open` con { ship = _ED.user_ship[id] }, o desde cualquier
-- sitio con la funcion global FuryCompanionArtifact_open(shipId).
-- Ventana hecha SOLO con maquetas y arte del paquete:
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed), la de los Codigos y las Suscripciones;
--   botones: images/ui/button/btn_1.png; «?»: images/ui/button/icon_wenhao.png;
--   reglas:  utils/common_popup_rule.csb; fichas: ResourcesIconCell.
-- Textos: `_fury_companion_artifact_text` de TipStringInfo.lua (12 idiomas).
--
-- PROTOCOLO (comandos propios, fury_legacy_companion_artifact.erl):
--   C2S 29070 fury_companion_artifact_view    rol, heroe
--   C2S 29071 fury_companion_artifact_equip   rol, heroe, artefacto (0 = quitar)
--   C2S 29072 fury_companion_artifact_level   rol, heroe
--   C2S 29073 fury_companion_artifact_summon  rol, heroe, tiradas (1 o 10)
--   S2C 29079 la ventana: heroe, artefacto, molde, nivel, tope, molde del material, material
--             que tiene, material para subir (0 en el tope), vida/ataque/defensa de ahora y del
--             siguiente nivel, propiedad de la habilidad, habilidad ahora y siguiente (centesimas
--             de %), nivel en que se abre, precio de 1 y 10 tiradas, lo que salio en la ultima
--             invocacion («0» si nada), y los artefactos de la mochila (n; artefacto, molde,
--             cantidad, propiedad).
-- El servidor manda: precio, material, atributos y sorteo salen de su base; aqui solo se dice
-- QUE heroe, QUE artefacto y cuantas tiradas.
-----------------------------------------------------------------------------------------------
FuryCompanionArtifact = class("FuryCompanionArtifactClass", Window)

local VIEW_CODE, EQUIP_CODE, LEVEL_CODE, SUMMON_CODE, PARSER_CODE = 29070, 29071, 29072, 29073, 29079
-- La habilidad: propiedad de combate -> texto (22..27).
local SKILL_TEXT = { [8] = 22, [9] = 23, [10] = 24, [11] = 25, [33] = 26, [34] = 27 }

local function text(i)
	return _fury_companion_artifact_text ~= nil and _fury_companion_artifact_text[i] or ""
end

-- «Dano final +3.2%»: el valor llega en centesimas de punto porcentual. Con 0 solo el nombre.
function FuryCompanionArtifact_skillText(property, hundredths)
	local i = SKILL_TEXT[tonumber(property) or 0]
	if i == nil then
		return ""
	end
	local value = string.format("%.2f", (tonumber(hundredths) or 0) / 100)
	value = string.gsub(string.gsub(value, "0+$", ""), "%.$", "")
	local str = string.format(text(i), value)
	if (tonumber(hundredths) or 0) <= 0 then
		str = string.gsub(str, "%s*%+%s*0%%", "")
	end
	return str
end

local function artifact_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_fury_companion_artifact(interpreter, datas, pos, strDatas, list, count)
	local v = {}
	for _, k in ipairs({ "hero", "artifact", "mould", "level", "max", "material", "owned", "cost",
			"hp", "atk", "def", "nhp", "natk", "ndef", "skill", "skill_now", "skill_next", "unlock" }) do
		v[k] = tonumber(npos(list)) or 0
	end
	v.summon_one = npos(list) or ""
	v.summon_ten = npos(list) or ""
	v.drawn = npos(list) or "0"
	v.bag = {}
	local n = tonumber(npos(list)) or 0
	for i = 1, n do
		local a = {}
		a.artifact = tonumber(npos(list)) or 0
		a.mould = tonumber(npos(list)) or 0
		a.count = tonumber(npos(list)) or 0
		a.skill = tonumber(npos(list)) or 0
		v.bag[#v.bag + 1] = a
	end
	_ED.fury_companion_artifact = v
end

-- Da de alta (o vuelve a dar) los cuatro comandos y el bloque. Idempotente.
function FuryCompanionArtifact_ensureProtocol()
	for key, code in pairs({ fury_companion_artifact_view = VIEW_CODE,
			fury_companion_artifact_equip = EQUIP_CODE,
			fury_companion_artifact_level = LEVEL_CODE,
			fury_companion_artifact_summon = SUMMON_CODE }) do
		protocol_command[key] = protocol_command[key] or
			{ code = code, command = key, command_fun = artifact_command(key), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_companion_artifact",
		parser_fun = parse_fury_companion_artifact })
end

-- «tipo,molde,cantidad|...» -> {{tipo, cantidad, molde}, ...}
local function rewards(str)
	local list = {}
	for group in string.gmatch(str or "", "[^|]+") do
		local f = {}
		for field in string.gmatch(group, "[^,]+") do
			f[#f + 1] = tonumber(field)
		end
		if #f == 3 and f[1] ~= nil and f[2] ~= nil and f[3] ~= nil then
			list[#list + 1] = { f[1], f[3], f[2] }
		end
	end
	return list
end

local function itemName(mould)
	local ok, info = pcall(getItemNameAndQuality, { 6, mould, 1 })
	if ok and info ~= nil and info[1] ~= nil then
		return tostring(info[1])
	end
	return ""
end

local function redraw()
	local window = fwin:find("FuryCompanionArtifactClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function request(code, key, params, onOk)
	FuryCompanionArtifact_ensureProtocol()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if onOk ~= nil then
				onOk()
			end
			redraw()
			-- Cartel de «+N poder» como los demas sistemas (si el total subio).
			if smFightingChange ~= nil then
				pcall(smFightingChange)
			end
		end
	end
	protocol_command[key].param_list = table.concat(params, "\r\n")
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

-- La ficha del heroe ya tiene el heroe nuevo (S2C 44): se repinta su CR.
local function refreshHero(shipId)
	if fwin:find("SmRoleStrengthenTabClass") ~= nil then
		state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { shipId })
	end
end

-- LA ENTRADA GLOBAL: abre la ventana del heroe `shipId` (el `ship_id` de `_ED.user_ship`).
function FuryCompanionArtifact_open(shipId)
	if shipId == nil or fwin:find("FuryCompanionArtifactClass") ~= nil then
		return
	end
	_ED.fury_companion_artifact = nil
	fwin:open(FuryCompanionArtifact:new():init(shipId), fwin._ui)
	request(VIEW_CODE, "fury_companion_artifact_view", { tostring(shipId) }, nil)
end

local function terminal(name, invoke)
	state_machine.add({
		_name = name,
		_init = function (terminal) end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = invoke,
		_terminal = nil,
		_terminals = nil
	})
end

terminal("fury_companion_artifact_open", function(terminal, instance, params)
	local ship = params ~= nil and params.ship or nil
	if ship ~= nil then
		FuryCompanionArtifact_open(ship.ship_id)
	end
	return true
end)

terminal("fury_companion_artifact_close", function(terminal, instance, params)
	fwin:close(fwin:find("FuryCompanionArtifactClass"))
	return true
end)

-- Poner (artefacto de la mochila) o quitar (artefacto 0).
terminal("fury_companion_artifact_equip", function(terminal, instance, params)
	local v = _ED.fury_companion_artifact
	local artifact = params ~= nil and params._datas ~= nil and params._datas.artifact or nil
	if v == nil or artifact == nil then
		return true
	end
	local shipId = v.hero
	request(EQUIP_CODE, "fury_companion_artifact_equip", { tostring(shipId), tostring(artifact) },
		function() refreshHero(shipId) end)
	return true
end)

terminal("fury_companion_artifact_level", function(terminal, instance, params)
	local v = _ED.fury_companion_artifact
	if v == nil or v.artifact == 0 or v.cost <= 0 then
		return true
	end
	if v.owned < v.cost then
		TipDlg.drawTextDailog(text(11))
		return true
	end
	local shipId = v.hero
	request(LEVEL_CODE, "fury_companion_artifact_level", { tostring(shipId) }, function()
		TipDlg.drawTextDailog(text(12))
		refreshHero(shipId)
	end)
	return true
end)

-- Invocar: sin comprobar diamantes aqui (el servidor contesta -16, que el cliente ya pinta).
terminal("fury_companion_artifact_summon", function(terminal, instance, params)
	local v = _ED.fury_companion_artifact
	local times = params ~= nil and params._datas ~= nil and params._datas.times or nil
	if v == nil or times == nil then
		return true
	end
	request(SUMMON_CODE, "fury_companion_artifact_summon", { tostring(v.hero), tostring(times) },
		function()
			local got = {}
			for _, r in ipairs(rewards((_ED.fury_companion_artifact or {}).drawn)) do
				got[#got + 1] = itemName(r[3]) .. " x" .. r[2]
			end
			if #got > 0 then
				TipDlg.drawTextDailog(text(19) .. " " .. table.concat(got, ", "))
			end
		end)
	return true
end)

terminal("fury_companion_artifact_help", function(terminal, instance, params)
	if fwin:find("FuryCompanionArtifactRulesClass") == nil then
		fwin:open(FuryCompanionArtifactRules:new():init(), fwin._ui)
	end
	return true
end)

terminal("fury_companion_artifact_rules_close", function(terminal, instance, params)
	fwin:close(fwin:find("FuryCompanionArtifactRulesClass"))
	return true
end)

state_machine.init()

function FuryCompanionArtifact:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
end

function FuryCompanionArtifact:init(shipId)
	self.ship_id = shipId
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_companion_artifact_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)
	local title = ccui.Helper:seekWidgetByName(root, "Text_title")
	title:setString(text(1))
	-- El «?» junto al titulo.
	local help = ccui.Button:create("images/ui/button/icon_wenhao.png", "images/ui/button/icon_wenhao.png")
	local tx, ty = title:getPosition()
	local tw = title:getContentSize().width * title:getScaleX()
	help:setPosition(cc.p(tx + tw * (1 - title:getAnchorPoint().x) + 40, ty))
	title:getParent():addChild(help)
	fwin:addTouchEventListener(help, nil,
	{
		terminal_name = "fury_companion_artifact_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	self:onUpdateDraw()
	return self
end

local function label(parent, str, fontName, size, x, y, color, anchorX, maxWidth)
	local t = ccui.Text:create(str, fontName, size)
	t:setAnchorPoint(cc.p(anchorX or 0, 0.5))
	t:setPosition(cc.p(x, y))
	if color ~= nil then
		t:setColor(color)
	end
	if maxWidth ~= nil then
		local w = t:getVirtualRendererSize().width
		if w > maxWidth then
			t:setScale(maxWidth / w)
		end
	end
	parent:addChild(t)
	return t
end

local function row(width, height)
	local r = ccui.Layout:create()
	r:setContentSize(cc.size(width, height))
	return r
end

local function icon(parent, kind, count, mould, x, y, scale)
	local cell = ResourcesIconCell:createCell()
	cell:init(kind, count, mould, nil, nil, true, true, 1)
	cell:setScale(scale or 0.7)
	cell:setPosition(cc.p(x, y))
	parent:addChild(cell)
	return cell
end

local function button(parent, str, fontName, x, y, terminalName, datas, enabled)
	local b = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	b:setTitleText(str)
	b:setTitleFontName(fontName)
	b:setTitleFontSize(20)
	b:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(b)
	b:setPosition(cc.p(x, y))
	parent:addChild(b)
	if enabled then
		-- Las claves van SUELTAS en la tabla: el terminal recibe el boton y la tabla
		-- en params._datas (anidadas en `_datas` no llegaban: «Poner» no hacia nada, 30-sep).
		local listener = { terminal_name = terminalName, terminal_state = 0, isPressedActionEnabled = true }
		for k, val in pairs(datas or {}) do
			listener[k] = val
		end
		fwin:addTouchEventListener(b, nil, listener, nil, 0)
	else
		b:setBright(false)
		b:setTouchEnabled(false)
	end
	return b
end

-- «2,-1,68» -> tipo, cantidad y molde (para pintarlo con su icono).
local function price(spec)
	local r = rewards(spec)[1]
	if r == nil then
		return 2, 0, -1
	end
	return r[1], r[2], r[3]
end

function FuryCompanionArtifact:onUpdateDraw()
	local root = self.roots[1]
	local v = _ED.fury_companion_artifact
	if root == nil or v == nil or v.hero ~= tonumber(self.ship_id) then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local width = listView:getContentSize().width
	local gold, green, grey, red = cc.c3b(255, 220, 90), cc.c3b(80, 230, 80), cc.c3b(170, 170, 170), cc.c3b(255, 80, 80)
	local equipped = v.artifact > 0
	local maxed = v.cost <= 0

	-- 1) El hueco: artefacto, nombre, nivel y «Quitar».
	local head = row(width, 100)
	if equipped then
		icon(head, 6, 1, v.mould, 10, 12, 0.8)
		label(head, itemName(v.mould), fontName, 24, 110, 66, gold, 0, width - 300)
	else
		label(head, text(3), fontName, 22, 20, 66, grey, 0, width - 200)
	end
	label(head, string.format(text(2), v.level, v.max), fontName, 20, equipped and 110 or 20, 30)
	button(head, text(13), fontName, width - 80, 50, "fury_companion_artifact_equip",
		{ artifact = 0 }, equipped)
	listView:addChild(head)

	if equipped then
		-- 2) Atributos: ahora y en el siguiente nivel.
		local stats = row(width, 130)
		local half = width / 2
		label(stats, text(4), fontName, 22, 30, 112, gold)
		label(stats, maxed and text(10) or text(5), fontName, 22, half + 10, 112, maxed and grey or green)
		local cur = { v.hp, v.atk, v.def }
		local nxt = { v.nhp, v.natk, v.ndef }
		for i = 1, 3 do
			local y = 112 - i * 30
			label(stats, string.format(text(5 + i), cur[i]), fontName, 20, 30, y)
			if not maxed then
				label(stats, string.format(text(5 + i), nxt[i]), fontName, 20, half + 10, y, green)
			end
		end
		listView:addChild(stats)

		-- 3) La habilidad: abierta (su valor) o cerrada (desde que nivel), y la del siguiente.
		local skill = row(width, 70)
		if v.skill_now > 0 then
			label(skill, string.format(text(20), FuryCompanionArtifact_skillText(v.skill, v.skill_now)),
				fontName, 20, 30, 50, gold, 0, width - 60)
		else
			label(skill, string.format(text(21), v.unlock), fontName, 20, 30, 50, grey, 0, width - 60)
		end
		if not maxed and v.skill_next > 0 then
			label(skill, FuryCompanionArtifact_skillText(v.skill, v.skill_next), fontName, 18, 30, 20,
				green, 0, width - 60)
		end
		listView:addChild(skill)

		-- 4) Subir de nivel: polvo que tiene / que cuesta, y el boton.
		local up = row(width, 100)
		if not maxed then
			icon(up, 6, v.owned, v.material, 10, 10, 0.7)
			label(up, v.owned .. "/" .. v.cost, fontName, 20, 100, 50, v.owned >= v.cost and green or red)
		end
		button(up, maxed and text(10) or text(9), fontName, width - 80, 50, "fury_companion_artifact_level",
			nil, not maxed)
		listView:addChild(up)
	end

	-- 5) Los artefactos de la mochila, cada uno con «Poner».
	local header = row(width, 50)
	label(header, text(15), fontName, 22, 20, 25, gold)
	listView:addChild(header)
	if #v.bag == 0 then
		local empty = row(width, 60)
		label(empty, text(16), fontName, 18, 20, 30, grey, 0, width - 40)
		listView:addChild(empty)
	end
	for _, a in ipairs(v.bag) do
		local r = row(width, 100)
		icon(r, 6, a.count, a.mould, 10, 12, 0.7)
		label(r, itemName(a.mould), fontName, 20, 100, 66, nil, 0, width - 280)
		label(r, FuryCompanionArtifact_skillText(a.skill, 0), fontName, 16, 100, 32, grey, 0, width - 280)
		button(r, text(14), fontName, width - 80, 50, "fury_companion_artifact_equip",
			{ artifact = a.artifact }, true)
		listView:addChild(r)
	end

	-- 6) Invocar x1 / x10, cada uno con su precio.
	local summon = row(width, 110)
	local half = width / 2
	local k1, n1, m1 = price(v.summon_one)
	local k10, n10, m10 = price(v.summon_ten)
	icon(summon, k1, n1, m1, 20, 20, 0.5)
	button(summon, text(17), fontName, half - 90, 55, "fury_companion_artifact_summon", { times = 1 }, true)
	icon(summon, k10, n10, m10, half + 20, 20, 0.5)
	button(summon, text(18), fontName, width - 90, 55, "fury_companion_artifact_summon", { times = 10 }, true)
	listView:addChild(summon)
	listView:requestRefreshView()
end

function FuryCompanionArtifact:onExit()
end

-----------------------------------------------------------------------------------------------
-- La ventana de reglas (el «?»): utils/common_popup_rule.csb con los textos 28..33.
-----------------------------------------------------------------------------------------------
FuryCompanionArtifactRules = class("FuryCompanionArtifactRulesClass", Window)

function FuryCompanionArtifactRules:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryCompanionArtifactRules:init()
	self:setTouchEnabled(true)
	local csbNode = csb.createNode("utils/common_popup_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	local title = ccui.Helper:seekWidgetByName(root, "Text_tittle")
	if title ~= nil then
		title:setString(text(28))
	end
	local body = ccui.Helper:seekWidgetByName(root, "Text_1")
	if body ~= nil then
		local lines = {}
		for i = 29, 33 do
			lines[#lines + 1] = text(i)
		end
		body:setString(table.concat(lines, "\n"))
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fury_companion_artifact_rules_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	return self
end

function FuryCompanionArtifactRules:onExit()
end
