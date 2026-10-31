-----------------------------------------------------------------------------------------------
-- LOS PERGAMINOS DEL HEROE (Fury, sistema J, 29-sep-2026; docs/systems/pergaminos.md).
--
-- Se abre desde el boton «Pergamino» del marco de botones del heroe (FuryHeroExtras.lua).
-- Cada heroe lleva UN pergamino (objetos 3600-3603). Equipar lo saca de la mochila, quitar lo
-- devuelve; la mejora (Tinta de pergamino, 3604) es del hueco del heroe y se conserva al cambiar.
-- Ventana hecha con la misma maqueta que el Rango (FuryHeroTitle.lua):
--   activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title, ListView_xsbx_rule,
--   Button_closed); botones images/ui/button/btn_1.png; iconos por prop_mould.pic_index.
-- Textos: `_fury_hero_scroll_text` de TipStringInfo.lua (12 idiomas); nombres de los objetos
-- por prop_mould/word_mould.
--
-- PROTOCOLO (marco de comandos del heroe, fury_legacy_hero_extra.erl):
--   C2S 29110 fury_hero_scroll_view     rol, heroe
--   C2S 29111 fury_hero_scroll_equip    rol, heroe, molde   (+ S2C 44/181/128, 32 y 37)
--   C2S 29112 fury_hero_scroll_unequip  rol, heroe          (+ S2C 44/181/128 y 32)
--   C2S 29113 fury_hero_scroll_up       rol, heroe          (+ S2C 44/181/128 y 37)
--   S2C 29115 heroe, molde equipado (0 ninguno), nivel, tope, vida/ataque/defensa actuales,
--             vida/ataque/defensa del siguiente (-1), tinta que cuesta (-1), molde de la tinta,
--             tinta que hay, N y N x (molde, cuantos hay, vida, ataque, defensa en este hueco).
-- El servidor manda: aqui solo se dice QUE heroe y QUE pergamino.
-----------------------------------------------------------------------------------------------
FuryHeroScroll = class("FuryHeroScrollClass", Window)

local VIEW_CODE, EQUIP_CODE, UNEQUIP_CODE, UP_CODE, PARSER_CODE = 29110, 29111, 29112, 29113, 29115

local function text(i)
	return _fury_hero_scroll_text ~= nil and _fury_hero_scroll_text[i] or ""
end

local function propIcon(mould)
	local ok, pic = pcall(function() return dms.int(dms["prop_mould"], mould, prop_mould.pic_index) end)
	return "images/ui/props/props_" .. tostring(ok and pic or 8460) .. ".png"
end

local function propName(mould)
	-- prop_name es el id de word_mould, no el texto (salia «71162», visto 30-sep): el nombre
	-- traducido lo da getItemNameAndQuality, como en las otras ventanas del marco.
	local ok, info = pcall(getItemNameAndQuality, { 6, mould, 1 })
	return ok and info ~= nil and info[1] ~= nil and tostring(info[1]) or tostring(mould)
end

local function scroll_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_fury_hero_scroll(interpreter, datas, pos, strDatas, list, count)
	local v = {}
	for _, k in ipairs({ "hero", "mould", "level", "max", "hp", "atk", "def", "nhp", "natk", "ndef",
			"cost", "ink_mould", "ink", "n" }) do
		v[k] = tonumber(npos(list)) or 0
	end
	v.scrolls = {}
	for i = 1, v.n do
		local s = {}
		for _, k in ipairs({ "mould", "count", "hp", "atk", "def" }) do
			s[k] = tonumber(npos(list)) or 0
		end
		v.scrolls[i] = s
	end
	_ED.fury_hero_scroll = v
end

local COMMANDS = {
	{ "fury_hero_scroll_view", VIEW_CODE }, { "fury_hero_scroll_equip", EQUIP_CODE },
	{ "fury_hero_scroll_unequip", UNEQUIP_CODE }, { "fury_hero_scroll_up", UP_CODE },
}

function FuryHeroScroll_ensureProtocol()
	for _, c in ipairs(COMMANDS) do
		protocol_command[c[1]] = protocol_command[c[1]] or
			{ code = c[2], command = c[1], command_fun = scroll_command(c[1]), param_list = "" }
	end
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_hero_scroll",
		parser_fun = parse_fury_hero_scroll })
end

local function redraw()
	local window = fwin:find("FuryHeroScrollClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

-- params: el heroe y, para equipar, el molde. Tras un cambio: aviso y repintar la ficha.
local function request(code, key, params, changed)
	FuryHeroScroll_ensureProtocol()
	local shipId = params[1]
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if changed then
				TipDlg.drawTextDailog(text(14))
				if smFightingChange ~= nil then
					pcall(smFightingChange)
				end
				if fwin:find("SmRoleStrengthenTabClass") ~= nil then
					state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { shipId })
				end
			end
			redraw()
		end
	end
	local parts = {}
	for i, p in ipairs(params) do
		parts[i] = tostring(p)
	end
	protocol_command[key].param_list = table.concat(parts, "\r\n")
	NetworkManager:register(code, nil, nil, nil, nil, callback, false, nil)
end

local function terminal(name, invoke)
	state_machine.add({
		_name = name,
		_init = function (terminal) end,
		_inited = false,
		_instance = nil,
		_state = 0,
		_invoke = invoke,
		_terminal = nil,
		_terminals = nil
	})
end

terminal("fury_hero_scroll_open", function(terminal, instance, params)
	local ship = params ~= nil and params.ship or nil
	if ship == nil or fwin:find("FuryHeroScrollClass") ~= nil then
		return true
	end
	_ED.fury_hero_scroll = nil
	fwin:open(FuryHeroScroll:new():init(ship.ship_id), fwin._ui)
	request(VIEW_CODE, "fury_hero_scroll_view", { ship.ship_id }, false)
	return true
end)

terminal("fury_hero_scroll_close", function(terminal, instance, params)
	fwin:close(fwin:find("FuryHeroScrollClass"))
	return true
end)

-- Equipar: el boton lleva el molde en sus datos. Sin unidades no se manda nada.
terminal("fury_hero_scroll_equip", function(terminal, instance, params)
	local v = _ED.fury_hero_scroll
	local mould = params ~= nil and params._datas ~= nil and tonumber(params._datas.mould) or 0
	if v == nil or mould <= 0 or mould == v.mould then
		return true
	end
	for _, s in ipairs(v.scrolls) do
		if s.mould == mould and s.count > 0 then
			request(EQUIP_CODE, "fury_hero_scroll_equip", { v.hero, mould }, true)
		end
	end
	return true
end)

terminal("fury_hero_scroll_unequip", function(terminal, instance, params)
	local v = _ED.fury_hero_scroll
	if v ~= nil and v.mould > 0 then
		request(UNEQUIP_CODE, "fury_hero_scroll_unequip", { v.hero }, true)
	end
	return true
end)

terminal("fury_hero_scroll_up", function(terminal, instance, params)
	local v = _ED.fury_hero_scroll
	if v == nil or v.mould <= 0 or v.cost < 0 then
		return true
	end
	if v.ink < v.cost then
		TipDlg.drawTextDailog(text(13))
		return true
	end
	request(UP_CODE, "fury_hero_scroll_up", { v.hero }, true)
	return true
end)

state_machine.init()

function FuryHeroScroll:ctor()
	self.super:ctor()
	self.roots = {}
end

function FuryHeroScroll:init(shipId)
	self.ship_id = shipId
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_hero_scroll_close",
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

local function icon(parent, mould, size, x, y)
	local image = ccui.ImageView:create(propIcon(mould))
	image:setScale(size / math.max(image:getContentSize().width, 1))
	image:setPosition(cc.p(x, y))
	parent:addChild(image)
	return image
end

local function button(parent, title, fontName, x, y, terminalName, enabled, mould)
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
			mould = mould,
			isPressedActionEnabled = true,
		}, nil, 0)
	else
		b:setBright(false)
		b:setTouchEnabled(false)
	end
	return b
end

local function statsText(hp, atk, def)
	return string.format(text(4), hp) .. "  " .. string.format(text(5), atk) .. "  "
		.. string.format(text(6), def)
end

function FuryHeroScroll:onUpdateDraw()
	local root = self.roots[1]
	local v = _ED.fury_hero_scroll
	if root == nil or v == nil or v.hero ~= tonumber(self.ship_id) then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local width = listView:getContentSize().width
	local gold, green, grey, red = cc.c3b(255, 220, 90), cc.c3b(80, 230, 80), cc.c3b(170, 170, 170),
		cc.c3b(255, 80, 80)
	local equipped = v.mould > 0

	-- El pergamino equipado, su nivel, sus atributos y el boton Quitar.
	local head = row(width, 120)
	if equipped then
		icon(head, v.mould, 70, 50, 70)
		label(head, propName(v.mould), fontName, 24, 100, 95, gold)
	else
		label(head, text(3), fontName, 24, 30, 95, grey)
	end
	label(head, string.format(text(2), v.level, v.max), fontName, 20, 100, 65)
	label(head, statsText(v.hp, v.atk, v.def), fontName, 18, 30, 25, equipped and gold or grey)
	button(head, text(10), fontName, width - 90, 80, "fury_hero_scroll_unequip", equipped)
	listView:addChild(head)

	-- Mejora del hueco: siguiente nivel, tinta que cuesta y el boton.
	local up = row(width, 100)
	local maxed = equipped and v.cost < 0
	if equipped and not maxed then
		label(up, text(7), fontName, 20, 30, 82, gold)
		label(up, statsText(v.nhp, v.natk, v.ndef), fontName, 18, 30, 55, green)
		icon(up, v.ink_mould, 40, 50, 20)
		label(up, v.ink .. "/" .. v.cost, fontName, 20, 80, 20, v.ink >= v.cost and green or red)
	elseif maxed then
		label(up, text(9), fontName, 20, 30, 55, grey)
	end
	button(up, maxed and text(9) or text(8), fontName, width - 90, 45, "fury_hero_scroll_up",
		equipped and not maxed)
	listView:addChild(up)

	-- Los pergaminos de la mochila, con lo que darian en este hueco.
	local title = row(width, 40)
	label(title, text(15), fontName, 22, 30, 20, gold)
	listView:addChild(title)
	for _, s in ipairs(v.scrolls) do
		local r = row(width, 90)
		icon(r, s.mould, 60, 45, 45)
		label(r, propName(s.mould), fontName, 20, 90, 70, s.mould == v.mould and green or gold)
		label(r, string.format(text(12), s.count), fontName, 18, 90, 45, s.count > 0 and green or grey)
		label(r, statsText(s.hp, s.atk, s.def), fontName, 16, 90, 20)
		button(r, text(11), fontName, width - 90, 45, "fury_hero_scroll_equip",
			s.count > 0 and s.mould ~= v.mould, s.mould)
		listView:addChild(r)
	end

	local rule = row(width, 50)
	local t = label(rule, text(16), fontName, 16, 30, 25, grey)
	t:ignoreContentAdaptWithSize(false)
	t:setContentSize(cc.size(width - 60, 48))
	listView:addChild(rule)
	listView:requestRefreshView()
end

function FuryHeroScroll:onExit()
end
