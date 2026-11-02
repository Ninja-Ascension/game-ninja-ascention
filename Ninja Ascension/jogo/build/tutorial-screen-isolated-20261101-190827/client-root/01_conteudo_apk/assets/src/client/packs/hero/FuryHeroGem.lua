-----------------------------------------------------------------------------------------------
-- LAS GEMAS DEL HEROE (Fury, sistema M, 29-sep-2026; docs/systems/gemas.md).
--
-- Se abre desde el boton «Gemas» del marco de botones del heroe (FuryHeroExtras.lua),
-- terminal `fury_hero_gem_open` con { ship = _ED.user_ship[id] }.
-- Ventana hecha SOLO con maquetas y arte del paquete:
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed), la de los Codigos y las Suscripciones;
--   botones: images/ui/button/btn_1.png; fichas: ResourcesIconCell.
-- Textos: `_fury_hero_gem_text` de TipStringInfo.lua (12 idiomas).
--
-- PROTOCOLO (marco de comandos del heroe, fury_legacy_hero_extra.erl):
--   C2S 29140 fury_hero_gem_view    rol, heroe
--   C2S 29141 fury_hero_gem_set     rol, heroe, hueco (1..6), molde   (+ S2C 44/181/128, 32, 37)
--   C2S 29142 fury_hero_gem_off     rol, heroe, hueco                 (+ S2C 44/181/128, 32)
--   C2S 29143 fury_hero_gem_fuse    rol, heroe, molde                 (+ 28, 32, 37)
--   C2S 29144 fury_hero_gem_summon  rol, heroe, tiradas (1 o 10)      (+ 28, 32)
--   S2C 29145 heroe, diamantes, plata, precio x1, precio x10, los 6 huecos (molde, 0 vacio),
--             n + por gema (molde, tipo, nivel, vida, ataque, defensa, tiene, iguales para
--             combinar (0 = maximo), plata), n + lo sacado en la invocacion (molde, cantidad).
-- Huecos 1-2 Vida, 3-4 Ataque, 5-6 Defensa. El servidor manda: tipo, atributos, coste y sorteo.
-----------------------------------------------------------------------------------------------
FuryHeroGem = class("FuryHeroGemClass", Window)

local CODES = { fury_hero_gem_view = 29140, fury_hero_gem_set = 29141, fury_hero_gem_off = 29142,
	fury_hero_gem_fuse = 29143, fury_hero_gem_summon = 29144 }
local PARSER_CODE = 29145

local function text(i)
	return _fury_hero_gem_text ~= nil and _fury_hero_gem_text[i] or ""
end

local function gem_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_fury_hero_gem(interpreter, datas, pos, strDatas, list, count)
	local function num()
		return tonumber(npos(list)) or 0
	end
	local v = { hero = num(), diamonds = num(), silver = num(), price_one = num(), price_ten = num() }
	v.slots = {}
	for i = 1, 6 do
		v.slots[i] = num()
	end
	v.gems, v.byMould = {}, {}
	for i = 1, num() do
		local g = {}
		for _, k in ipairs({ "mould", "type", "level", "hp", "atk", "def", "owned", "fuse", "silver" }) do
			g[k] = num()
		end
		v.gems[#v.gems + 1] = g
		v.byMould[g.mould] = g
	end
	v.drawn = {}
	for i = 1, num() do
		v.drawn[#v.drawn + 1] = { mould = num(), count = num() }
	end
	_ED.fury_hero_gem = v
end

function FuryHeroGem_ensureProtocol()
	for key, code in pairs(CODES) do
		protocol_command[key] = protocol_command[key] or
			{ code = code, command = key, command_fun = gem_command(key), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_hero_gem",
		parser_fun = parse_fury_hero_gem })
end

local function itemName(mould)
	local ok, info = pcall(getItemNameAndQuality, { 6, mould, 1 })
	if ok and info ~= nil and info[1] ~= nil then
		return tostring(info[1])
	end
	return ""
end

local function redraw()
	local window = fwin:find("FuryHeroGemClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function request(key, params, onOk)
	FuryHeroGem_ensureProtocol()
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
	NetworkManager:register(CODES[key], nil, nil, nil, nil, callback, false, nil)
end

-- La ficha del heroe ya tiene el heroe nuevo (S2C 44): se repinta su CR.
local function refreshHero(shipId)
	if fwin:find("SmRoleStrengthenTabClass") ~= nil then
		state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { shipId })
	end
end

-- El hueco donde va la gema: el primero libre de su tipo; si no hay, el de la gema mas debil
-- (vuelve a la mochila). nil si la mas debil ya es igual o mejor.
local function slotFor(v, gem)
	local best, bestLevel = nil, nil
	for s = gem.type * 2 - 1, gem.type * 2 do
		local m = v.slots[s]
		if m == 0 then
			return s
		end
		local level = v.byMould[m] ~= nil and v.byMould[m].level or 0
		if bestLevel == nil or level < bestLevel then
			best, bestLevel = s, level
		end
	end
	if bestLevel ~= nil and bestLevel < gem.level then
		return best
	end
	return nil
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

local function datas(params)
	return params ~= nil and params._datas or {}
end

terminal("fury_hero_gem_open", function(terminal, instance, params)
	local ship = params ~= nil and params.ship or nil
	if ship == nil or fwin:find("FuryHeroGemClass") ~= nil then
		return true
	end
	_ED.fury_hero_gem = nil
	fwin:open(FuryHeroGem:new():init(ship.ship_id), fwin._ui)
	request("fury_hero_gem_view", { tostring(ship.ship_id) }, nil)
	return true
end)

terminal("fury_hero_gem_close", function(terminal, instance, params)
	fwin:close(fwin:find("FuryHeroGemClass"))
	return true
end)

terminal("fury_hero_gem_set", function(terminal, instance, params)
	local v, d = _ED.fury_hero_gem, datas(params)
	if v == nil or d.slot == nil then
		return true
	end
	local shipId = v.hero
	request("fury_hero_gem_set", { tostring(shipId), tostring(d.slot), tostring(d.mould) },
		function() refreshHero(shipId) end)
	return true
end)

terminal("fury_hero_gem_off", function(terminal, instance, params)
	local v, d = _ED.fury_hero_gem, datas(params)
	if v == nil or d.slot == nil then
		return true
	end
	local shipId = v.hero
	request("fury_hero_gem_off", { tostring(shipId), tostring(d.slot) }, function() refreshHero(shipId) end)
	return true
end)

terminal("fury_hero_gem_fuse", function(terminal, instance, params)
	local v, d = _ED.fury_hero_gem, datas(params)
	local g = v ~= nil and v.byMould[d.mould or 0] or nil
	if g == nil or g.fuse <= 0 then
		return true
	end
	if g.owned < g.fuse then
		TipDlg.drawTextDailog(text(22))
		return true
	end
	-- Sin plata lo rechaza el servidor (su aviso de plata insuficiente).
	request("fury_hero_gem_fuse", { tostring(v.hero), tostring(g.mould) },
		function() TipDlg.drawTextDailog(text(21)) end)
	return true
end)

-- Invocar: sin comprobar diamantes aqui (el servidor contesta -16, que el cliente ya pinta).
terminal("fury_hero_gem_summon", function(terminal, instance, params)
	local v, d = _ED.fury_hero_gem, datas(params)
	if v == nil or d.times == nil then
		return true
	end
	request("fury_hero_gem_summon", { tostring(v.hero), tostring(d.times) }, function()
		local got = {}
		for _, r in ipairs((_ED.fury_hero_gem or {}).drawn or {}) do
			got[#got + 1] = itemName(r.mould) .. " x" .. r.count
		end
		if #got > 0 then
			TipDlg.drawTextDailog(text(16) .. " " .. table.concat(got, ", "))
		end
	end)
	return true
end)

state_machine.init()

function FuryHeroGem:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
end

function FuryHeroGem:init(shipId)
	self.ship_id = shipId
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_hero_gem_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)
	ccui.Helper:seekWidgetByName(root, "Text_title"):setString(text(1))
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

local function button(parent, str, fontName, x, y, terminalName, d, enabled)
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
		for k, val in pairs(d or {}) do
			listener[k] = val
		end
		fwin:addTouchEventListener(b, nil, listener, nil, 0)
	else
		b:setBright(false)
		b:setTouchEnabled(false)
	end
	return b
end

-- Lo que da una gema (solo su atributo).
local function gemStat(g)
	if g.type == 1 then
		return string.format(text(11), g.hp)
	elseif g.type == 2 then
		return string.format(text(12), g.atk)
	end
	return string.format(text(13), g.def)
end

function FuryHeroGem:onUpdateDraw()
	local root = self.roots[1]
	local v = _ED.fury_hero_gem
	if root == nil or v == nil or v.hero ~= tonumber(self.ship_id) then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local width = listView:getContentSize().width
	local gold, green, grey = cc.c3b(255, 220, 90), cc.c3b(80, 230, 80), cc.c3b(170, 170, 170)

	-- 1) El bono total de las gemas puestas.
	local hp, atk, def = 0, 0, 0
	for s = 1, 6 do
		local g = v.byMould[v.slots[s]]
		if g ~= nil then
			hp, atk, def = hp + g.hp, atk + g.atk, def + g.def
		end
	end
	local head = row(width, 70)
	label(head, text(19), fontName, 22, 20, 50, gold, 0, width - 40)
	label(head, string.format(text(11), hp) .. "   " .. string.format(text(12), atk) .. "   "
		.. string.format(text(13), def), fontName, 20, 20, 18, green, 0, width - 40)
	listView:addChild(head)

	-- 2) Los seis huecos, con «Quitar» si tienen gema.
	for s = 1, 6 do
		local m = v.slots[s]
		local g = v.byMould[m]
		local r = row(width, 90)
		label(r, text(1 + math.floor((s + 1) / 2)), fontName, 18, 20, 76, gold, 0, 200)
		if g ~= nil then
			icon(r, 6, 1, m, 20, 2, 0.55)
			label(r, itemName(m), fontName, 20, 100, 48, nil, 0, width - 300)
			label(r, gemStat(g), fontName, 18, 100, 20, green, 0, width - 300)
		else
			label(r, text(5), fontName, 20, 100, 34, grey)
		end
		button(r, text(6), fontName, width - 80, 40, "fury_hero_gem_off", { slot = s }, g ~= nil)
		listView:addChild(r)
	end

	-- 3) Las gemas de la mochila: «Engastar» y «Combinar».
	local header = row(width, 50)
	label(header, text(9), fontName, 22, 20, 25, gold)
	listView:addChild(header)
	local any = false
	for _, g in ipairs(v.gems) do
		if g.owned > 0 then
			any = true
			local r = row(width, 120)
			icon(r, 6, g.owned, g.mould, 10, 20, 0.65)
			label(r, itemName(g.mould), fontName, 20, 100, 96, nil, 0, width - 330)
			label(r, gemStat(g), fontName, 18, 100, 68, green, 0, width - 330)
			if g.fuse > 0 then
				local fuseLabel = label(r, string.format(text(17), g.fuse), fontName, 16, 100, 40,
					g.owned >= g.fuse and green or grey, 0, width - 330)
				if g.silver > 0 then
					-- A la derecha del texto: debajo lo pisaba (visto 30-sep).
					local lw = fuseLabel:getContentSize().width * fuseLabel:getScaleX()
					icon(r, 1, g.silver, -1, 110 + lw, 22, 0.4)
				end
			else
				label(r, text(18), fontName, 16, 100, 40, grey, 0, width - 330)
			end
			local slot = slotFor(v, g)
			button(r, text(7), fontName, width - 80, 86, "fury_hero_gem_set", { slot = slot, mould = g.mould },
				slot ~= nil)
			button(r, text(8), fontName, width - 80, 32, "fury_hero_gem_fuse", { mould = g.mould },
				g.fuse > 0 and g.owned >= g.fuse)
			listView:addChild(r)
		end
	end
	if not any then
		local empty = row(width, 60)
		label(empty, text(10), fontName, 18, 20, 30, grey, 0, width - 40)
		listView:addChild(empty)
	end

	-- 4) Invocar x1 / x10 con su precio en diamantes.
	local summon = row(width, 110)
	local half = width / 2
	icon(summon, 2, v.price_one, -1, 20, 20, 0.5)
	button(summon, text(14), fontName, half - 90, 55, "fury_hero_gem_summon", { times = 1 }, true)
	icon(summon, 2, v.price_ten, -1, half + 20, 20, 0.5)
	button(summon, text(15), fontName, width - 90, 55, "fury_hero_gem_summon", { times = 10 }, true)
	listView:addChild(summon)

	-- 5) Reglas (texto de varias lineas).
	local rules = row(width, 100)
	local t = ccui.Text:create(text(20), fontName, 16)
	t:ignoreContentAdaptWithSize(false)
	t:setTextAreaSize(cc.size(width - 40, 96))
	t:setAnchorPoint(cc.p(0, 0.5))
	t:setPosition(cc.p(20, 50))
	t:setColor(grey)
	rules:addChild(t)
	listView:addChild(rules)
	listView:requestRefreshView()
end

function FuryHeroGem:onExit()
end
