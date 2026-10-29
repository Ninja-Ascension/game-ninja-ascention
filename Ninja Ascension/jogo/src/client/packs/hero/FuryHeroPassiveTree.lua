-----------------------------------------------------------------------------------------------
-- EL ARBOL DE PASIVAS DEL HEROE (Fury, sistema H, 29-sep-2026; docs/systems/arbol_pasivas.md).
--
-- Se abre desde el boton «Arbol de pasivas» del marco de botones del heroe (FuryHeroExtras.lua).
-- Ventana hecha SOLO con maquetas y arte del paquete:
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed), la de los Codigos y las Suscripciones;
--   boton:   images/ui/button/btn_1.png; oro y diamantes: ResourcesIconCell (tipos 1 y 2);
--   fruto:   images/ui/props/props_8420.png (objeto 3550);
--   confirmar el reinicio: ConfirmTip (shortcut_open_function_dailog_cancel_and_ok).
-- Textos: `_fury_passive_tree_text` de TipStringInfo.lua (12 idiomas).
--
-- PROTOCOLO (marco de comandos del heroe, fury_legacy_hero_extra.erl):
--   C2S 29090 fury_hero_ptree_view   rol, heroe
--   C2S 29091 fury_hero_ptree_up     rol, heroe  (+ S2C 44/181/128 del heroe, 28 y 37)
--   C2S 29092 fury_hero_ptree_reset  rol, heroe  (+ S2C 44/181/128, 28, 32 y 37)
--   S2C 29095 heroe, abiertos, nodos N, molde del fruto, frutos/oro/diamantes que tiene,
--             diamantes del reinicio, frutos que devuelve, y N x (frutos, oro, diamantes,
--             vida, ataque, defensa, velocidad, pasiva, valor %).
-- El servidor manda: orden, coste, tope, atributos y devolucion salen de su tabla; aqui solo
-- se dice QUE heroe.
-----------------------------------------------------------------------------------------------
FuryHeroPassiveTree = class("FuryHeroPassiveTreeClass", Window)

local VIEW_CODE, UP_CODE, RESET_CODE, PARSER_CODE = 29090, 29091, 29092, 29095
local ICON = "images/ui/props/props_8420.png"
local ROMAN = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII" }
local BRANCH = 5
-- Propiedad de la pasiva -> texto de _fury_passive_tree_text.
local PASSIVE_TEXT = { [8] = 9, [9] = 10, [10] = 11, [11] = 12, [33] = 13, [34] = 14 }

local function text(i)
	return _fury_passive_tree_text ~= nil and _fury_passive_tree_text[i] or ""
end

local function tree_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_fury_hero_ptree(interpreter, datas, pos, strDatas, list, count)
	local v = {}
	for _, k in ipairs({ "hero", "level", "max", "item", "items", "silver", "diamonds",
			"reset_diamonds", "refund" }) do
		v[k] = tonumber(npos(list)) or 0
	end
	v.nodes = {}
	for i = 1, v.max do
		local n = {}
		for _, k in ipairs({ "items", "silver", "diamonds", "hp", "atk", "def", "spd",
				"passive", "value" }) do
			n[k] = tonumber(npos(list)) or 0
		end
		v.nodes[i] = n
	end
	_ED.fury_hero_ptree = v
end

function FuryHeroPassiveTree_ensureProtocol()
	for _, c in ipairs({ { "fury_hero_ptree_view", VIEW_CODE }, { "fury_hero_ptree_up", UP_CODE },
			{ "fury_hero_ptree_reset", RESET_CODE } }) do
		protocol_command[c[1]] = protocol_command[c[1]] or
			{ code = c[2], command = c[1], command_fun = tree_command(c[1]), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_hero_ptree",
		parser_fun = parse_fury_hero_ptree })
end

-- Lo que da un nodo, como lista de textos.
local function node_lines(n)
	local out = {}
	for _, f in ipairs({ { n.hp, 5 }, { n.atk, 6 }, { n.def, 7 }, { n.spd, 8 } }) do
		if f[1] > 0 then
			out[#out + 1] = string.format(text(f[2]), f[1])
		end
	end
	if n.value > 0 and PASSIVE_TEXT[n.passive] ~= nil then
		out[#out + 1] = string.format(text(PASSIVE_TEXT[n.passive]), n.value)
	end
	return out
end

-- Suma de los nodos abiertos (solo para pintar: el servidor aplica la suya).
local function totals(v)
	local t = { hp = 0, atk = 0, def = 0, spd = 0, passive = 0, value = 0 }
	local passives = {}
	for i = 1, v.level do
		local n = v.nodes[i]
		t.hp, t.atk, t.def, t.spd = t.hp + n.hp, t.atk + n.atk, t.def + n.def, t.spd + n.spd
		if n.value > 0 and PASSIVE_TEXT[n.passive] ~= nil then
			passives[n.passive] = (passives[n.passive] or 0) + n.value
		end
	end
	local out = node_lines(t)
	for _, p in ipairs({ 8, 9, 10, 11, 33, 34 }) do
		if passives[p] ~= nil then
			out[#out + 1] = string.format(text(PASSIVE_TEXT[p]), passives[p])
		end
	end
	return out
end

local function redraw()
	local window = fwin:find("FuryHeroPassiveTreeClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

-- La ficha del heroe ya tiene el heroe nuevo (S2C 44): se repinta su CR.
local function refreshHero(shipId)
	if fwin:find("SmRoleStrengthenTabClass") ~= nil then
		state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { shipId })
	end
end

local function request(code, key, shipId, onOk)
	FuryHeroPassiveTree_ensureProtocol()
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
	protocol_command[key].param_list = tostring(shipId)
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

local function terminal(name, invoke)
	return {
		_name = name,
		_init = function (terminal)
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = invoke,
		_terminal = nil,
		_terminals = nil
	}
end

state_machine.add(terminal("fury_hero_ptree_open", function(terminal, instance, params)
	local ship = params ~= nil and params.ship or nil
	if ship == nil or fwin:find("FuryHeroPassiveTreeClass") ~= nil then
		return true
	end
	_ED.fury_hero_ptree = nil
	fwin:open(FuryHeroPassiveTree:new():init(ship.ship_id), fwin._ui)
	request(VIEW_CODE, "fury_hero_ptree_view", ship.ship_id, nil)
	return true
end))

state_machine.add(terminal("fury_hero_ptree_close", function(terminal, instance, params)
	fwin:close(fwin:find("FuryHeroPassiveTreeClass"))
	return true
end))

-- «Desbloquear»: mira los frutos que dijo el servidor (oro y diamantes los rechaza el
-- servidor: -46 / -16) y pide el nodo siguiente.
state_machine.add(terminal("fury_hero_ptree_up", function(terminal, instance, params)
	local v = _ED.fury_hero_ptree
	if v == nil or v.level >= v.max then
		return true
	end
	if v.items < v.nodes[v.level + 1].items then
		TipDlg.drawTextDailog(text(21))
		return true
	end
	local shipId = v.hero
	request(UP_CODE, "fury_hero_ptree_up", shipId, function()
		TipDlg.drawTextDailog(text(22))
		refreshHero(shipId)
	end)
	return true
end))

-- «Reiniciar»: confirma (coste y frutos que vuelven) y lo pide.
state_machine.add(terminal("fury_hero_ptree_reset", function(terminal, instance, params)
	local v = _ED.fury_hero_ptree
	if v == nil or v.level <= 0 then
		return true
	end
	state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, {
		terminal_name = "fury_hero_ptree_reset_confirmed",
		terminal_state = 0,
		_msg = string.format(text(20), v.reset_diamonds, v.refund),
		_datas = { ship_id = v.hero },
	})
	return true
end))

state_machine.add(terminal("fury_hero_ptree_reset_confirmed", function(terminal, instance, params)
	if params ~= nil and params.status == 1 and params._datas ~= nil then
		local shipId = params._datas.ship_id
		request(RESET_CODE, "fury_hero_ptree_reset", shipId, function()
			TipDlg.drawTextDailog(text(23))
			refreshHero(shipId)
		end)
	end
	return true
end))

state_machine.init()

function FuryHeroPassiveTree:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.utils.ConfirmTip")
end

function FuryHeroPassiveTree:init(shipId)
	self.ship_id = shipId
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_hero_ptree_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)
	ccui.Helper:seekWidgetByName(root, "Text_title"):setString(text(1))
	self:onUpdateDraw()
	return self
end

local function label(parent, str, fontName, size, x, y, color, anchorX)
	local t = ccui.Text:create(str, fontName, size)
	t:setAnchorPoint(cc.p(anchorX or 0, 0.5))
	t:setPosition(cc.p(x, y))
	if color ~= nil then
		t:setColor(color)
	end
	parent:addChild(t)
	return t
end

local function row(width, height)
	local r = ccui.Layout:create()
	r:setContentSize(cc.size(width, height))
	return r
end

local function button(parent, title, fontName, x, y, terminalName, enabled)
	local b = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	b:setTitleText(title)
	b:setTitleFontName(fontName)
	b:setTitleFontSize(20)
	b:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(b)
	b:setPosition(cc.p(x, y))
	parent:addChild(b)
	if enabled then
		fwin:addTouchEventListener(b, nil,
		{
			terminal_name = terminalName,
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
	else
		b:setBright(false)
		b:setTouchEnabled(false)
	end
	return b
end

function FuryHeroPassiveTree:onUpdateDraw()
	local root = self.roots[1]
	local v = _ED.fury_hero_ptree
	if root == nil or v == nil or v.hero ~= tonumber(self.ship_id) then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local width = listView:getContentSize().width
	local gold, green, grey, red = cc.c3b(255, 220, 90), cc.c3b(80, 230, 80), cc.c3b(150, 150, 150),
		cc.c3b(255, 80, 80)

	-- Cabecera: fruto, nodos abiertos y frutos que tiene.
	local head = row(width, 80)
	local fruit = ccui.ImageView:create(ICON)
	fruit:setScale(64 / math.max(fruit:getContentSize().width, 1))
	fruit:setPosition(cc.p(45, 40))
	head:addChild(fruit)
	label(head, string.format(text(2), v.level, v.max), fontName, 24, 90, 55, gold)
	label(head, string.format(text(3), v.items), fontName, 20, 90, 22)
	listView:addChild(head)

	-- Bonus total de lo abierto, en dos columnas.
	local lines = totals(v)
	local tot = row(width, 40 + 26 * math.max(1, math.ceil(#lines / 2)))
	local th = tot:getContentSize().height
	label(tot, text(4), fontName, 22, 20, th - 18, gold)
	if #lines == 0 then
		label(tot, text(24), fontName, 20, 30, th - 46, grey)
	end
	for i, s in ipairs(lines) do
		local col, r = (i - 1) % 2, math.floor((i - 1) / 2)
		label(tot, s, fontName, 20, 30 + col * (width / 2), th - 46 - r * 26, green)
	end
	listView:addChild(tot)

	-- El arbol: ramas de cinco nodos; abiertos en verde, el siguiente en amarillo con su
	-- coste y el boton, los demas en gris.
	for i, n in ipairs(v.nodes) do
		if (i - 1) % BRANCH == 0 then
			local br = row(width, 34)
			label(br, string.format(text(15), ROMAN[math.floor((i - 1) / BRANCH) + 1] or ""), fontName,
				22, width / 2, 17, gold, 0.5)
			listView:addChild(br)
		end
		local nextNode = (i == v.level + 1)
		local r = row(width, nextNode and 100 or 34)
		local h = r:getContentSize().height
		local color = (i <= v.level) and green or (nextNode and gold or grey)
		label(r, string.format(text(16), i), fontName, 20, 20, h - 17, color)
		label(r, table.concat(node_lines(n), "  "), fontName, 20, 130, h - 17, color)
		if nextNode then
			local item = ccui.ImageView:create(ICON)
			item:setScale(44 / math.max(item:getContentSize().width, 1))
			item:setPosition(cc.p(45, 32))
			r:addChild(item)
			label(r, v.items .. "/" .. n.items, fontName, 20, 72, 32, v.items >= n.items and green or red)
			local x = 150
			for _, c in ipairs({ { 1, n.silver }, { 2, n.diamonds } }) do
				if c[2] > 0 then
					local cell = ResourcesIconCell:createCell()
					cell:init(c[1], c[2], -1, nil, nil, true, true, 1)
					cell:setScale(0.55)
					cell:setPosition(cc.p(x, 5))
					r:addChild(cell)
					x = x + 110
				end
			end
			button(r, text(17), fontName, width - 90, 32, "fury_hero_ptree_up", true)
		end
		listView:addChild(r)
	end

	-- Pie: arbol completo, de donde salen los frutos y el reinicio (con su coste).
	local foot = row(width, 120)
	if v.level >= v.max then
		label(foot, text(18), fontName, 22, 20, 100, gold)
	end
	local src = label(foot, text(25), fontName, 16, 20, 70, grey)
	src:ignoreContentAdaptWithSize(false)
	src:setTextAreaSize(cc.size(width - 40, 40))
	button(foot, text(19), fontName, width - 90, 25, "fury_hero_ptree_reset", v.level > 0)
	if v.reset_diamonds > 0 then
		local gems = ResourcesIconCell:createCell()
		gems:init(2, v.reset_diamonds, -1, nil, nil, true, true, 1)
		gems:setScale(0.55)
		gems:setPosition(cc.p(width - 260, 0))
		foot:addChild(gems)
	end
	listView:addChild(foot)
	listView:requestRefreshView()
end

function FuryHeroPassiveTree:onExit()
end
