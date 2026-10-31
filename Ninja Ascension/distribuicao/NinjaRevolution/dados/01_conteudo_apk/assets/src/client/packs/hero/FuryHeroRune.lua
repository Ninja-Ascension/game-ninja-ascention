-----------------------------------------------------------------------------------------------
-- LAS RUNAS DEL HEROE (Fury, sistema L, 29-sep-2026; docs/systems/runas_heroe.md).
--
-- Se abre desde el boton «Runas» del marco de botones del heroe (FuryHeroExtras.lua).
-- Ventana hecha SOLO con maquetas y arte del paquete (la misma que el Rango, FuryHeroTitle.lua):
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed);
--   botones: images/ui/button/btn_1.png; diamantes: ResourcesIconCell (tipo 2);
--   iconos:  images/ui/props/props_8500..8503.png (runas de vida/ataque/defensa y polvo).
-- Textos: `_fury_rune_text` de TipStringInfo.lua (12 idiomas); nombres de runa de word_mould;
-- «Vida/Ataque/Defensa +%d» de `_fury_hero_title_text[5..7]` (Rango, sistema E).
--
-- PROTOCOLO (marco de comandos del heroe, fury_legacy_hero_extra.erl):
--   C2S 29130 fury_hero_rune_view     rol, heroe
--   C2S 29131 fury_hero_rune_equip    rol, heroe, ranura, runa   (+ S2C 44/181/128, 32, 37)
--   C2S 29132 fury_hero_rune_unequip  rol, heroe, ranura         (+ S2C 44/181/128, 32)
--   C2S 29133 fury_hero_rune_fuse     rol, heroe, runa           (+ 32, 37)
--   C2S 29134 fury_hero_rune_summon   rol, heroe, 1 | 10         (+ 28, 32)
--   S2C 29135 heroe, molde del polvo, polvo, precio x1, precio x10,
--             n ranuras x (ranura, nivel, estrellas, abierta, runa),
--             n runas x (molde, tipo, calidad, vida, ataque, defensa, tiene, siguiente,
--                        cuantas fusiona, polvo que gasta),
--             n obtenidas x (molde, cantidad).
-- El servidor manda: ranuras abiertas, atributos, costes y sorteos salen de su base.
-----------------------------------------------------------------------------------------------
FuryHeroRune = class("FuryHeroRuneClass", Window)

local CODES = {
	fury_hero_rune_view = 29130, fury_hero_rune_equip = 29131, fury_hero_rune_unequip = 29132,
	fury_hero_rune_fuse = 29133, fury_hero_rune_summon = 29134,
}
local PARSER_CODE = 29135
local ICONS = { "images/ui/props/props_8500.png", "images/ui/props/props_8501.png",
	"images/ui/props/props_8502.png" }
local DUST_ICON = "images/ui/props/props_8503.png"

local function text(i)
	return _fury_rune_text ~= nil and _fury_rune_text[i] or ""
end

local function rune_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_fury_hero_rune(interpreter, datas, pos, strDatas, list, count)
	local function n() return tonumber(npos(list)) or 0 end
	local v = { hero = n(), dust_mould = n(), dust = n(), price1 = n(), price10 = n(),
		slots = {}, runes = {}, got = {} }
	for i = 1, n() do
		v.slots[i] = { slot = n(), level = n(), star = n(), open = n() == 1, mould = n() }
	end
	for i = 1, n() do
		v.runes[i] = { mould = n(), kind = n(), quality = n(), hp = n(), atk = n(), def = n(),
			owned = n(), next = n(), fuse_count = n(), fuse_dust = n() }
	end
	for i = 1, n() do
		v.got[i] = { mould = n(), count = n() }
	end
	_ED.fury_hero_rune = v
end

function FuryHeroRune_ensureProtocol()
	for key, code in pairs(CODES) do
		protocol_command[key] = protocol_command[key] or
			{ code = code, command = key, command_fun = rune_command(key), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_hero_rune",
		parser_fun = parse_fury_hero_rune })
end

local function rune_of(v, mould)
	for _, r in ipairs(v.runes) do
		if r.mould == mould then
			return r
		end
	end
	return nil
end

-- Cada runa con SU icono (prop_mould.pic_index): desde el 30-sep las calidades II-V tienen
-- dibujo propio (tools/iconos_objetos_nuevos.py); si no se lee, el del tipo.
local function rune_icon(r)
	local ok, pic = pcall(function() return dms.int(dms["prop_mould"], r.mould, prop_mould.pic_index) end)
	if ok and pic ~= nil and pic > 0 then
		return "images/ui/props/props_" .. tostring(pic) .. ".png"
	end
	return ICONS[r.kind] or DUST_ICON
end

local function rune_name(mould)
	local ok, info = pcall(setThePropsIcon, mould)
	if ok and info ~= nil and info[2] ~= nil then
		return info[2]
	end
	return tostring(mould)
end

-- «Vida +500» (los atributos que de la runa), con los textos del Rango (sistema E).
local function rune_stats(r)
	local parts = {}
	local values = { r.hp, r.atk, r.def }
	for i = 1, 3 do
		local fmt = _fury_hero_title_text ~= nil and _fury_hero_title_text[4 + i] or "%d"
		if values[i] > 0 then
			parts[#parts + 1] = string.format(fmt, values[i])
		end
	end
	return table.concat(parts, "  ")
end

local function quality_color(q)
	local c = tipStringInfo_quality_color_Type ~= nil and tipStringInfo_quality_color_Type[q + 1] or nil
	if c == nil then
		return cc.c3b(255, 255, 255)
	end
	return cc.c3b(c[1], c[2], c[3])
end

local function redraw()
	local window = fwin:find("FuryHeroRuneClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function request(key, shipId, args, onOk)
	FuryHeroRune_ensureProtocol()
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
	local params = { tostring(shipId) }
	for _, a in ipairs(args or {}) do
		params[#params + 1] = tostring(a)
	end
	protocol_command[key].param_list = table.concat(params, "\r\n")
	NetworkManager:register(CODES[key], nil, nil, nil, nil, callback, false, nil)
end

-- Tras engarzar o quitar, la ficha del heroe ya tiene el heroe nuevo (S2C 44): se repinta su CR.
local function refresh_hero(shipId)
	if fwin:find("SmRoleStrengthenTabClass") ~= nil then
		state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { shipId })
	end
end

local function show_got(v)
	if v == nil or #v.got == 0 then
		return
	end
	local parts = {}
	for _, g in ipairs(v.got) do
		parts[#parts + 1] = rune_name(g.mould) .. " x" .. g.count
	end
	TipDlg.drawTextDailog(text(17) .. " " .. table.concat(parts, ", "))
end

-- Los datos del boton llegan en params._datas (claves extra de addTouchEventListener).
local function terminal(name, fn)
	state_machine.add({
		_name = name,
		_init = function (terminal) end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			fn(params ~= nil and params._datas or {}, params)
			return true
		end,
		_terminal = nil,
		_terminals = nil
	})
end

terminal("fury_hero_rune_open", function(datas, params)
	local ship = params ~= nil and params.ship or nil
	if ship == nil or fwin:find("FuryHeroRuneClass") ~= nil then
		return
	end
	_ED.fury_hero_rune = nil
	fwin:open(FuryHeroRune:new():init(ship.ship_id), fwin._ui)
	request("fury_hero_rune_view", ship.ship_id, nil, nil)
end)

terminal("fury_hero_rune_close", function(datas)
	fwin:close(fwin:find("FuryHeroRuneClass"))
end)

-- Engarzar en la PRIMERA ranura abierta y vacia; si no hay, se avisa sin mandar nada.
terminal("fury_hero_rune_equip", function(datas)
	local v = _ED.fury_hero_rune
	if v == nil or datas.mould == nil then
		return
	end
	local slot = nil
	for _, s in ipairs(v.slots) do
		if slot == nil and s.open and s.mould == 0 then
			slot = s.slot
		end
	end
	if slot == nil then
		TipDlg.drawTextDailog(text(14))
		return
	end
	local shipId = v.hero
	request("fury_hero_rune_equip", shipId, { slot, datas.mould }, function()
		TipDlg.drawTextDailog(text(16))
		refresh_hero(shipId)
	end)
end)

terminal("fury_hero_rune_unequip", function(datas)
	local v = _ED.fury_hero_rune
	if v == nil or datas.slot == nil then
		return
	end
	local shipId = v.hero
	request("fury_hero_rune_unequip", shipId, { datas.slot }, function()
		refresh_hero(shipId)
	end)
end)

terminal("fury_hero_rune_fuse", function(datas)
	local v = _ED.fury_hero_rune
	local r = v ~= nil and datas.mould ~= nil and rune_of(v, datas.mould) or nil
	if r == nil or r.next == 0 then
		return
	end
	if r.owned < r.fuse_count or v.dust < r.fuse_dust then
		TipDlg.drawTextDailog(text(15))
		return
	end
	request("fury_hero_rune_fuse", v.hero, { r.mould }, function()
		show_got(_ED.fury_hero_rune)
	end)
end)

-- Invocar: los diamantes los rechaza el servidor (-16, abre la recarga).
terminal("fury_hero_rune_summon", function(datas)
	local v = _ED.fury_hero_rune
	if v == nil or datas.count == nil then
		return
	end
	request("fury_hero_rune_summon", v.hero, { datas.count }, function()
		-- La ventana de premio con iconos y nombres (S2C 171 tipo 7 del servidor), como las
		-- demas invocaciones (Victor, 30-sep).
		app.load("client.reward.DrawRareReward")
		local getRewardWnd = DrawRareReward:new()
		getRewardWnd:init(7)
		fwin:open(getRewardWnd, fwin._ui)
	end)
end)

state_machine.init()

function FuryHeroRune:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
end

function FuryHeroRune:init(shipId)
	self.ship_id = shipId
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_hero_rune_close",
		terminal_state = 0,
		touch_black = true,
	}, nil, 3)
	ccui.Helper:seekWidgetByName(root, "Text_title"):setString(text(1))
	self:onUpdateDraw()
	return self
end

local function label(parent, str, fontName, size, x, y, color)
	local t = ccui.Text:create(str, fontName, size)
	t:setAnchorPoint(cc.p(0, 0.5))
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

local function icon(parent, path, size, x, y)
	local img = ccui.ImageView:create(path)
	img:setScale(size / math.max(img:getContentSize().width, 1))
	img:setPosition(cc.p(x, y))
	parent:addChild(img)
	return img
end

-- `datas`: claves que llegan al terminal en params._datas.
local function button(parent, str, fontName, x, y, terminalName, datas)
	local b = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	b:setTitleText(str)
	b:setTitleFontName(fontName)
	b:setTitleFontSize(18)
	b:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(b)
	b:setScale(0.8)
	b:setPosition(cc.p(x, y))
	parent:addChild(b)
	local listener = { terminal_name = terminalName, terminal_state = 0, isPressedActionEnabled = true }
	for k, val in pairs(datas) do
		listener[k] = val
	end
	fwin:addTouchEventListener(b, nil, listener, nil, 0)
	return b
end

function FuryHeroRune:onUpdateDraw()
	local root = self.roots[1]
	local v = _ED.fury_hero_rune
	if root == nil or v == nil or v.hero ~= tonumber(self.ship_id) then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local width = listView:getContentSize().width
	local gold, grey = cc.c3b(255, 220, 90), cc.c3b(170, 170, 170)

	-- Engarzadas: total (solo ranuras abiertas, como el servidor) y una fila por ranura.
	local hp, atk, def = 0, 0, 0
	for _, s in ipairs(v.slots) do
		local r = s.open and s.mould > 0 and rune_of(v, s.mould) or nil
		if r ~= nil then
			hp, atk, def = hp + r.hp, atk + r.atk, def + r.def
		end
	end
	local head = row(width, 60)
	label(head, text(20), fontName, 22, 20, 42, gold)
	label(head, string.format(text(21), hp, atk, def), fontName, 18, 20, 14)
	listView:addChild(head)
	for _, s in ipairs(v.slots) do
		local line = row(width, 70)
		label(line, string.format(text(2), s.slot), fontName, 18, 20, 35, gold)
		local r = s.mould > 0 and rune_of(v, s.mould) or nil
		if r ~= nil then
			icon(line, rune_icon(r), 56, 150, 35)
			label(line, rune_name(r.mould), fontName, 18, 190, 48, quality_color(r.quality))
			label(line, rune_stats(r), fontName, 16, 190, 20)
			button(line, text(6), fontName, width - 80, 35, "fury_hero_rune_unequip", { slot = s.slot })
		elseif s.open then
			label(line, text(3), fontName, 18, 150, 35, grey)
		elseif s.star > 0 then
			label(line, string.format(text(5), s.level, s.star), fontName, 18, 150, 35, grey)
		else
			label(line, string.format(text(4), s.level), fontName, 18, 150, 35, grey)
		end
		listView:addChild(line)
	end

	-- Mochila: polvo e invocacion.
	local bag = row(width, 110)
	label(bag, text(18), fontName, 22, 20, 92, gold)
	icon(bag, DUST_ICON, 40, 40, 55)
	label(bag, string.format(text(10), v.dust), fontName, 18, 70, 55)
	local counts = { { 1, v.price1, text(12) }, { 10, v.price10, text(13) } }
	for i, c in ipairs(counts) do
		local x = width - 250 + (i - 1) * 150
		button(bag, c[3], fontName, x, 60, "fury_hero_rune_summon", { count = c[1] })
		local gems = ResourcesIconCell:createCell()
		gems:init(2, c[2], -1, nil, nil, true, true, 1)
		-- El precio, A LA IZQUIERDA del boton y de su alto (antes, debajo, tapaba los botones:
		-- Victor, 30-sep). El boton mide 108x44 a escala 0,8.
		local cs = gems:getContentSize()
		local sc = (cs.height ~= nil and cs.height > 0) and 40 / cs.height or 0.4
		gems:setScale(sc)
		gems:setPosition(cc.p(x - 48 - cs.width * sc, 60 - 20))
		bag:addChild(gems)
	end
	listView:addChild(bag)

	-- Una fila por runa que tenga.
	local any = false
	for _, r in ipairs(v.runes) do
		if r.owned > 0 then
			any = true
			local line = row(width, 90)
			icon(line, rune_icon(r), 60, 45, 45)
			label(line, rune_name(r.mould), fontName, 18, 85, 72, quality_color(r.quality))
			label(line, rune_stats(r), fontName, 16, 85, 48)
			label(line, string.format(text(9), r.owned), fontName, 16, 85, 24)
			if r.next > 0 then
				label(line, string.format(text(11), r.fuse_count, r.fuse_dust), fontName, 14, 85, 6, grey)
				button(line, text(8), fontName, width - 200, 45, "fury_hero_rune_fuse", { mould = r.mould })
			end
			button(line, text(7), fontName, width - 70, 45, "fury_hero_rune_equip", { mould = r.mould })
			listView:addChild(line)
		end
	end
	if not any then
		local none = row(width, 60)
		local t = label(none, text(19), fontName, 16, 20, 30, grey)
		t:setTextAreaSize(cc.size(width - 40, 56))
		listView:addChild(none)
	end
	listView:requestRefreshView()
end

function FuryHeroRune:onExit()
end
