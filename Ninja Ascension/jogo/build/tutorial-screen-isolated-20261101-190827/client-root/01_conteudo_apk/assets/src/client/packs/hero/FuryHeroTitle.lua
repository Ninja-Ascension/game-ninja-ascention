-----------------------------------------------------------------------------------------------
-- EL RANGO / TITULO DEL HEROE (Fury, sistema E, 29-sep-2026; docs/systems/rango_heroe.md).
--
-- Se abre desde el boton «Rango» del marco de botones del heroe (FuryHeroExtras.lua).
-- Ventana hecha SOLO con maquetas y arte del paquete:
--   ventana: activity/wonderful/sm_limited_time_equip_box_help.csb (Text_title,
--            ListView_xsbx_rule, Button_closed), la de los Codigos y las Suscripciones;
--   boton:   images/ui/button/btn_1.png; diamantes: ResourcesIconCell (tipo 2);
--   insignia: images/ui/props/props_8350.png (objeto 3480).
-- Textos: `_fury_hero_title_text` de TipStringInfo.lua (12 idiomas).
--
-- PROTOCOLO (marco de comandos del heroe, fury_legacy_hero_extra.erl):
--   C2S 29060 fury_hero_title_view  rol, heroe
--   C2S 29061 fury_hero_title_up    rol, heroe   (+ S2C 44/181/128 del heroe, 28 y 37)
--   S2C 29065 heroe, rango, tope, molde insignia, vida/ataque/defensa actuales,
--             vida/ataque/defensa del siguiente (-1 en el tope), insignias y diamantes
--             que cuesta (-1 en el tope), insignias y diamantes que tiene.
-- El servidor manda: coste, tope y atributos salen de su tabla; aqui solo se dice QUE heroe.
-----------------------------------------------------------------------------------------------
FuryHeroTitle = class("FuryHeroTitleClass", Window)

local VIEW_CODE, UP_CODE, PARSER_CODE = 29060, 29061, 29065
local ICON = "images/ui/props/props_8350.png"
local ROMAN = { "I", "II", "III", "IV", "V" }

local function text(i)
	return _fury_hero_title_text ~= nil and _fury_hero_title_text[i] or ""
end

-- «Guerrero III»: seis tramos de cinco (textos 13..18); rango 0 = texto 19.
function FuryHeroTitle_rankName(level)
	if level == nil or level <= 0 then
		return text(19)
	end
	local tier = math.min(6, math.floor((level - 1) / 5) + 1)
	return text(12 + tier) .. " " .. ROMAN[(level - 1) % 5 + 1]
end

local function title_command(key)
	return function(str)
		local item = protocol_command[key]
		return str .. "\r\n" .. item.command .. "\r\n" .. _ED.user_info.user_id
			.. "\r\n" .. item.param_list
	end
end

local function parse_fury_hero_title(interpreter, datas, pos, strDatas, list, count)
	local v = {}
	for _, k in ipairs({ "hero", "level", "max", "item", "hp", "atk", "def", "nhp", "natk", "ndef",
			"cost_items", "cost_diamonds", "items", "diamonds" }) do
		v[k] = tonumber(npos(list)) or 0
	end
	_ED.fury_hero_title = v
end

function FuryHeroTitle_ensureProtocol()
	protocol_command.fury_hero_title_view = protocol_command.fury_hero_title_view or
		{ code = VIEW_CODE, command = "fury_hero_title_view",
		  command_fun = title_command("fury_hero_title_view"), param_list = "" }
	protocol_command.fury_hero_title_up = protocol_command.fury_hero_title_up or
		{ code = UP_CODE, command = "fury_hero_title_up",
		  command_fun = title_command("fury_hero_title_up"), param_list = "" }
	for _, v in pairs(protocol_parse) do
		if v.code == PARSER_CODE then
			return
		end
	end
	table.insert(protocol_parse, { code = PARSER_CODE, parser = "parse_fury_hero_title",
		parser_fun = parse_fury_hero_title })
end

local function redraw()
	local window = fwin:find("FuryHeroTitleClass")
	if window ~= nil then
		window:onUpdateDraw()
	end
end

local function request(code, key, shipId, onOk)
	FuryHeroTitle_ensureProtocol()
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

local fury_hero_title_open_terminal = {
	_name = "fury_hero_title_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local ship = params ~= nil and params.ship or nil
		if ship == nil or fwin:find("FuryHeroTitleClass") ~= nil then
			return true
		end
		_ED.fury_hero_title = nil
		fwin:open(FuryHeroTitle:new():init(ship.ship_id), fwin._ui)
		request(VIEW_CODE, "fury_hero_title_view", ship.ship_id, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local fury_hero_title_close_terminal = {
	_name = "fury_hero_title_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FuryHeroTitleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- «Subir rango»: comprueba las insignias que dijo el servidor (los diamantes los rechaza el
-- servidor con -16, que abre la recarga) y pide la subida.
local fury_hero_title_up_terminal = {
	_name = "fury_hero_title_up",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local v = _ED.fury_hero_title
		if v == nil or v.cost_items < 0 then
			return true
		end
		if v.items < v.cost_items then
			TipDlg.drawTextDailog(text(11))
			return true
		end
		local shipId = v.hero
		request(UP_CODE, "fury_hero_title_up", shipId, function()
			TipDlg.drawTextDailog(text(12))
			-- La ficha del heroe ya tiene el heroe nuevo (S2C 44): se repinta su CR.
			if fwin:find("SmRoleStrengthenTabClass") ~= nil then
				state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, { shipId })
			end
		end)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fury_hero_title_open_terminal)
state_machine.add(fury_hero_title_close_terminal)
state_machine.add(fury_hero_title_up_terminal)
state_machine.init()

function FuryHeroTitle:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
end

function FuryHeroTitle:init(shipId)
	self.ship_id = shipId
	self:setTouchEnabled(true)
	local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_help.csb")
	local root = csbItem:getChildByName("root")
	self:addChild(csbItem)
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fury_hero_title_close",
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

function FuryHeroTitle:onUpdateDraw()
	local root = self.roots[1]
	local v = _ED.fury_hero_title
	if root == nil or v == nil or v.hero ~= tonumber(self.ship_id) then
		return
	end
	local fontName = ccui.Helper:seekWidgetByName(root, "Text_title"):getFontName()
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
	listView:removeAllItems()
	local width = listView:getContentSize().width
	local gold, green, grey = cc.c3b(255, 220, 90), cc.c3b(80, 230, 80), cc.c3b(170, 170, 170)
	local maxed = v.cost_items < 0

	-- Rango actual: insignia, nombre del tramo y «Rango N/30».
	local head = row(width, 90)
	local badge = ccui.ImageView:create(ICON)
	badge:setScale(70 / math.max(badge:getContentSize().width, 1))
	badge:setPosition(cc.p(50, 45))
	head:addChild(badge)
	label(head, FuryHeroTitle_rankName(v.level), fontName, 26, 100, 60, gold)
	label(head, string.format(text(2), v.level, v.max), fontName, 20, 100, 28)
	listView:addChild(head)

	-- Atributos: actuales y del siguiente rango.
	local stats = row(width, 130)
	local half = width / 2
	label(stats, text(3), fontName, 22, 30, 112, gold)
	label(stats, maxed and text(10) or text(4), fontName, 22, half + 10, 112, maxed and grey or green)
	local cur = { v.hp, v.atk, v.def }
	local nxt = { v.nhp, v.natk, v.ndef }
	for i = 1, 3 do
		local y = 112 - i * 30
		label(stats, string.format(text(4 + i), cur[i]), fontName, 20, 30, y)
		if not maxed then
			label(stats, string.format(text(4 + i), nxt[i]), fontName, 20, half + 10, y, green)
		end
	end
	listView:addChild(stats)

	-- Requisitos del siguiente rango y el boton.
	local req = row(width, 120)
	if not maxed then
		label(req, text(8), fontName, 22, 30, 100, gold)
		local item = ccui.ImageView:create(ICON)
		item:setScale(60 / math.max(item:getContentSize().width, 1))
		item:setPosition(cc.p(60, 45))
		req:addChild(item)
		label(req, v.items .. "/" .. v.cost_items, fontName, 20, 95, 45,
			v.items >= v.cost_items and green or cc.c3b(255, 80, 80))
		if v.cost_diamonds > 0 then
			local gems = ResourcesIconCell:createCell()
			gems:init(2, v.cost_diamonds, -1, nil, nil, true, true, 1)
			gems:setScale(0.6)
			gems:setPosition(cc.p(180, 15))
			req:addChild(gems)
		end
	end
	local button = ccui.Button:create("images/ui/button/btn_1.png", "images/ui/button/btn_1.png")
	button:setTitleText(maxed and text(10) or text(9))
	button:setTitleFontName(fontName)
	button:setTitleFontSize(20)
	button:setTitleColor(cc.c3b(90, 45, 10))
	fwin:fitButtonTitle(button)
	button:setPosition(cc.p(width - 90, 45))
	req:addChild(button)
	if maxed then
		button:setBright(false)
		button:setTouchEnabled(false)
	else
		fwin:addTouchEventListener(button, nil,
		{
			terminal_name = "fury_hero_title_up",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
	end
	listView:addChild(req)
	listView:requestRefreshView()
end

function FuryHeroTitle:onExit()
end
